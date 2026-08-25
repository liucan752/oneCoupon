# oneCoupon 优惠券结算代码阅读指南

> 适用 checkout：`D:\Repository\onecoupon-main`（当前工作树）。
>
> 本文以当前仓库代码为依据，区分“已实现行为”和“推荐改进”。没有启动 MySQL、Redis、RocketMQ，也没有声称 Maven 编译或端到端链路已验证。

## 1. 先建立整体模型

优惠券结算不是一个单表状态更新，而是三类状态共同推进：

| 对象 | 关键状态 | 作用 |
|---|---|---|
| 用户券 `t_user_coupon_*` | `0 UNUSED`、`1 LOCKING`、`2 USED`、`3 EXPIRED`、`4 REVOKED` | 用户真正持有的券；按 `user_id` 分库分表 |
| 结算单 `t_coupon_settlement_*` | `0 LOCKED`、`1 CANCELLED`、`2 PAID`、`3 REFUNDED` | 记录某张用户券与订单的绑定关系；按 `user_id` 分片 |
| Redis 用户券 ZSet | member=`couponTemplateId_couponId`，score=`validEndTime` | settlement 服务的查询投影；用户券被锁定时移除，退款时写回 |

目标状态机可以画成：

```text
UNUSED ──创建结算单──> LOCKING ──支付成功──> USED
  ▲                                  │
  └────────────退款成功──────────────┘

UNUSED ──到期 Outbox/MQ──> EXPIRED
LOCKING ──订单取消/超时──> UNUSED   （当前代码没有看到对应公开入口）
```

代码入口：

- `onecoupon-main/engine/src/main/java/com/nageoffer/onecoupon/engine/controller/UserCouponController.java`
- `onecoupon-main/engine/src/main/java/com/nageoffer/onecoupon/engine/service/impl/UserCouponServiceImpl.java`
- `onecoupon-main/engine/src/main/java/com/nageoffer/onecoupon/engine/common/enums/UserCouponStatusEnum.java`
- `onecoupon-main/engine/src/main/java/com/nageoffer/onecoupon/engine/dao/entity/CouponSettlementDO.java`
- `onecoupon-main/engine/src/main/resources/shardingsphere-config.yaml`

## 2. 详细执行流程

### 2.1 锁定：下单时创建优惠券结算单

入口：`POST /api/engine/user-coupon/create-payment-record`。

实现：`UserCouponServiceImpl#createPaymentRecord`。

执行顺序：

1. 使用 `LOCK_COUPON_SETTLEMENT_KEY(couponId)` 获取 Redisson 锁。同一张券的创建、支付、退款共用这个锁。
2. 按 `couponId + 当前 userId` 查询状态为 `0` 或 `2` 的结算单。命中即拒绝，意图是阻止重复使用或重复锁定。
3. 按 `couponId + userId` 查询用户券，校验：
   - 用户券存在且属于当前用户；
   - `validEndTime` 未过期；
   - `status == UNUSED(0)`。
4. 通过 `CouponTemplateService#findCouponTemplate` 读取模板与消费规则。
5. 校验适用范围与金额：
   - 商品专属券：请求商品列表中必须包含目标商品；
   - 店铺券：店铺编号必须匹配；
   - 满减/折扣券：订单金额达到 `termsOfUse`；
   - 折扣金额不能超过模板的 `maximumDiscountAmount`；
   - 请求方传入的 `payableAmount` 必须等于服务端计算结果。
6. 开启 `TransactionTemplate` 本地事务：
   - 插入 `t_coupon_settlement`，状态为 `0 LOCKED`；
   - 条件更新 `t_user_coupon`：`status UNUSED(0) -> LOCKING(1)`。
7. 事务返回后，从 Redis ZSet `one-coupon_engine:user-template-list:{userId}` 删除 `templateId_couponId`。

关键代码片段位置：`UserCouponServiceImpl.java:195-330`。

结果：

```text
数据库：用户券 UNUSED -> LOCKING；结算单 INSERT(status=0)
Redis：删除该用户券可用投影
```

### 2.2 使用：支付成功后核销

入口：`POST /api/engine/user-coupon/process-payment`。

实现：`UserCouponServiceImpl#processPayment`。

执行顺序：

1. 获取同一张券的 Redisson 锁。
2. 事务内将 `couponId + userId + status=0` 的结算单更新为 `status=2 PAID`。
3. 检查更新条数必须为 1；否则抛出异常并回滚。
4. 同一事务内将 `t_user_coupon` 中 `status=LOCKING(1)` 的用户券更新为 `USED(2)`。
5. 检查用户券更新条数必须为 1；否则回滚结算单更新。

关键代码片段位置：`UserCouponServiceImpl.java:334-379`。

结果：

```text
数据库：结算单 LOCKED -> PAID；用户券 LOCKING -> USED
Redis：保持删除状态，不再回补
```

### 2.3 退款归还：退款成功后恢复用户券

入口：`POST /api/engine/user-coupon/process-refund`。

实现：`UserCouponServiceImpl#processRefund`。

执行顺序：

1. 获取同一张券的 Redisson 锁。
2. 事务内将 `couponId + userId + status=2` 的结算单更新为 `status=3 REFUNDED`。
3. 同一事务内将用户券 `USED(2) -> UNUSED(0)`。
4. 事务提交后重新查询用户券。
5. 将 `templateId_couponId` 以 `validEndTime` 为 score 写回 Redis ZSet。

关键代码片段位置：`UserCouponServiceImpl.java:382-442`。

结果：

```text
数据库：结算单 PAID -> REFUNDED；用户券 USED -> UNUSED
Redis：重新加入可用券投影（但查询只取 score > 当前时间的成员）
```

当前实现默认“退款即整张券归还”。没有看到退款金额、退款商品范围、部分退款次数或优惠券使用明细表。

### 2.4 过期与查询侧的配套链路

虽然不是结算接口本身，但它会影响锁定和退款后的可见性：

1. 发券消费者 `UserCouponRedeemConsumer` 在同一用户分片事务中写入用户券、到期 Outbox 和库存记账。
2. `UserCouponExpireOutboxDispatcher` 将用户券写入 ZSet，并发送延迟到期消息。
3. `UserCouponDelayCloseConsumer` 到期后使用条件更新：仅当 `status=UNUSED` 且 `validEndTime <= now` 时改为 `EXPIRED`，随后删除 ZSet member。
4. `settlement/CouponQueryServiceImpl#findActiveUserCouponMembers` 使用 `rangeByScore(key, now + 1, +inf)`，查询热路径不回查 MySQL，也不会展示已过期 score 的券。

## 3. 事务、锁、缓存和消息边界

| 边界 | 当前实现 | 需要特别关注 |
|---|---|---|
| Redisson 锁 | 以 `couponId` 为粒度，覆盖创建/支付/退款 | 依赖 Redis 可用；`tryLock()` 不等待；租约/释放异常需防御 |
| 本地 DB 事务 | 结算单和用户券在 `TransactionTemplate` 中一起更新 | 只有本地数据库事务，不覆盖 Redis |
| Redis 投影 | 锁定后 `ZREM`，退款后 `ZADD` | 任一步失败都可能出现 DB 与查询投影不一致 |
| MQ/Outbox | 到期链路有 Outbox；领券链路有 Redeem Outbox | 当前未看到支付/退款专用 Outbox |
| 幂等 | 依赖旧状态条件、分布式锁、部分 Outbox 状态 | 重复支付/退款会返回更新 0，而不是明确“已完成” |
| 分片 | 用户券、结算单按 `user_id` 路由 | 需确认生产路由确实将两张表落在同库；状态扫描会广播 |

## 4. 可能存在的问题与建议

### P0/P1：优先修复

1. **锁定没有检查用户券条件更新条数。** 插入结算单成功后，`userCouponMapper.update(...)` 的返回值没有验证。若更新 0 行，可能提交“结算单已锁定、用户券仍 UNUSED”的分裂状态。
   - 建议：要求更新条数必须为 1；否则抛异常回滚。更稳妥的顺序是先用条件更新抢占用户券，再插入结算单，失败时补偿回退。

2. **锁定是“先查后写”，数据库缺少强幂等约束。** Redisson 锁失效、Redis 故障或锁租约过期时，两个请求可能同时通过查询。
   - 建议：增加订单/券/用户业务幂等键；在数据库增加可表达的唯一约束或单独的锁定记录表。

3. **结算单没有以 `orderId` 做幂等。** 查询重复结算单只看 `couponId + userId + status in (0,2)`。如果第一次结算单已是状态 1（取消），重试可能插入另一张结算单。
   - 建议：使用 `orderId + couponId + userId` 作为业务幂等键，并明确取消后是否允许新订单再次使用。

4. **支付/退款请求只有 `couponId`。** 没有订单号、支付流水号、退款流水号或事件版本，难以防止跨订单推进状态，也无法审计“是哪一次退款归还了券”。
   - 建议：请求至少携带 `orderId`、支付/退款业务流水号、事件时间和幂等键，并在 SQL 条件中校验。

5. **支付释放锁发生在事务回调的 `finally` 中。** `processPayment` 在回调结束时释放锁，但 Spring 事务真正提交可能发生在回调返回之后；新请求可能在提交完成前获得同一把锁。
   - 建议：将锁释放放到事务方法外层 `finally`，并确保提交完成后才释放；释放前检查 `isHeldByCurrentThread()`。

6. **数据库提交后 Redis 回补/删除失败无法由同一请求可靠补偿。**
   - 锁定：DB 已锁定、`ZREM` 失败，查询侧可能仍展示该券；
   - 退款：DB 已归还、`ZADD` 失败，查询侧看不到该券；客户端重试退款又会因状态不是 PAID 而失败。
   - 建议：为锁定和退款增加“缓存投影 Outbox”，记录 `ZREM/ZADD` 待执行状态、租约、重试和最终对账；不要把 Redis 写成功作为接口唯一成功凭据。

7. **缺少锁定超时/订单取消回退流程。** 结算单定义了 `CANCELLED(1)`，但当前控制器和服务接口没有对应公开方法；订单支付失败或超时后，用户券可能永久处于 `LOCKING(1)`。
   - 建议：补充订单取消事件消费者或定时补偿任务：`LOCKING + 结算单 LOCKED -> UNUSED + 结算单 CANCELLED`，并回补 Redis。

8. **未来生效时间没有校验。** `createPaymentRecord` 只判断 `validEndTime`，没有判断 `validStartTime <= now`。平台发放或特殊活动券如果尚未生效，可能被提前锁定。
   - 建议：同时校验开始和结束时间，并在查询与锁券使用同一时钟/时区策略。

### P2：一致性与业务语义风险

9. **重复支付/退款不是幂等成功。** 已支付的支付事件再次到达会因为 `status=0` 条件不满足而抛异常；已退款的退款事件也一样。
   - 建议：先读取当前状态：若已经处于目标终态且业务流水号一致，直接返回成功；若状态冲突，再报警/拒绝。

10. **退款按整券归还，无法表达部分退款。** 订单部分退款时可能错误地恢复整张券。
    - 建议：保存优惠券实际抵扣金额和适用商品明细，按退款范围计算可归还金额和状态。

11. **退款后可能把已过期券短暂写回 ZSet。** 当前 `ZADD` 不判断 `validEndTime`；查询依赖 score 过滤不会展示，但过期 member 仍需 Outbox 清理。
    - 建议：回补前判断有效期；过期则保持/转换为 `EXPIRED`，不再加入可用投影。

12. **金额计算在 engine 与 settlement 两处重复实现。** `UserCouponServiceImpl#createPaymentRecord` 手写折扣校验，`settlement` 还有 `CouponCalculationService`、`CouponFactory` 和三种策略。规则、折扣率含义、最大优惠和精度边界可能漂移。
    - 建议：抽取共享金额计算组件，或让一个服务成为唯一金额真相；在结算单中保存规则快照/计算结果。

13. **`BigDecimal.equals` 可能误判金额。** 商品券校验中使用 `subtract(...).equals(payableAmount)`，`10.0` 与 `10.00` 数值相等但 scale 不同，会被判定为不一致。
    - 建议：使用 `compareTo(...) == 0`，并统一货币舍入模式与小数位。

14. **查询依赖 Redis 投影，不回查 MySQL。** 投影缺失会造成用户券漏展示；模板 Hash 缺失也可能产生空模板数据。
    - 建议：增加 DB→Redis 定期对账、缺失回补、缓存命中/空模板监控；把“投影缺失”与“券不可用”区分记录。

15. **MQ 上下文风险。** 控制器依赖 `UserContext`，而 MQ 消费线程通常没有 HTTP 用户上下文。当前到期消费者正确使用事件中的 `userId`；如果未来把支付/退款直接接到 MQ，必须让事件携带 userId，不要从线程上下文取。

## 5. 推荐的代码阅读顺序

建议按业务生命周期阅读，而不是按目录从上到下扫：

1. **先看状态与表结构**
   - `UserCouponStatusEnum.java`
   - `CouponSettlementDO.java`
   - `resources/database/onecoupon.sql`
   - `resources/database/migration/V20260824__coupon_expire_and_distribution_outbox.sql`
   - `resources/database/migration/V20260825__user_coupon_redeem_outbox.sql`
   - 目标：先记住状态码、字段、索引和分片键。

2. **看接口契约与请求 DTO**
   - `UserCouponController.java`
   - `CouponCreatePaymentReqDTO.java`
   - `CouponProcessPaymentReqDTO.java`
   - `CouponProcessRefundReqDTO.java`
   - 目标：确认外部调用者到底传了什么，哪些业务校验目前无法完成。

3. **完整通读 `UserCouponServiceImpl` 的三个结算方法**
   - 先看 `createPaymentRecord`，画出“查询 → 计算 → DB 事务 → Redis 删除”；
   - 再看 `processPayment`，标出两个条件更新和锁释放位置；
   - 最后看 `processRefund`，标出 DB 提交与 Redis 回补之间的断点。

4. **回到 Mapper 与 XML**
   - `CouponSettlementMapper.java`
   - `UserCouponMapper.java`
   - `UserCouponMapper.xml`
   - 目标：确认哪些操作是 MyBatis-Plus 默认 SQL，哪些有显式条件，是否检查 update count。

5. **看分片路由与事务边界**
   - `engine/src/main/resources/shardingsphere-config.yaml`
   - `dao/sharding/DBHashModShardingAlgorithm.java`
   - `dao/sharding/TableHashModShardingAlgorithm.java`
   - 目标：确认用户券和结算单是否按同一 `user_id` 路由到同库，以及状态扫描为什么会广播。

6. **看 settlement 查询投影**
   - `settlement/.../CouponQueryServiceImpl.java`
   - `settlement/.../CouponQueryController.java`
   - 目标：理解锁定前用户看到的是什么，以及 `ZREM/ZADD` 失败会造成什么用户体验。

7. **看金额计算的第二套实现**
   - `CouponCalculationService.java`
   - `CouponFactory.java`
   - `FixedDiscountCalculationStrategy.java`
   - `ThresholdCalculationStrategy.java`
   - `DiscountCalculationStrategy.java`
   - 目标：对比 engine 的消费规则校验与 settlement 的策略计算，检查折扣率、上限、精度是否统一。

8. **再看过期收敛链路**
   - `UserCouponExpireOutboxDispatcher.java`
   - `UserCouponDelayCloseConsumer.java`
   - `UserCouponExpireOutboxMapper.xml`
   - 目标：理解退款后重新变为 UNUSED 的券，最终如何被过期事件转成 EXPIRED 并从 Redis 删除。

9. **最后看领券 Outbox，理解“用户券从哪里来”**
   - `UserCouponRedeemConsumer.java`
   - `UserCouponRedeemOutboxDispatcher.java`
   - `UserCouponRedeemStockSettlementDispatcher.java`
   - 目标：把“发券写入 UNUSED + 创建到期 Outbox + Redis 投影”与后续结算串起来。

10. **按故障场景回放，而不是只看 happy path**
    - 锁拿到后进程崩溃；
    - DB 提交成功、Redis 删除/回补失败；
    - 支付消息重复投递；
    - 退款消息晚到或部分退款；
    - 订单取消但没有调用状态 1；
    - Redis 锁租约过期后两个实例并发操作。

## 6. 建议的验证用例

至少准备以下集成测试或故障演练：

| 场景 | 期望 |
|---|---|
| 两个请求同时锁同一张券 | 只有一个结算单，用户券最终只能为 LOCKING |
| 锁定时用户券条件更新 0 行 | 整个事务回滚，不留下结算单 |
| 支付事件重复两次 | 第二次幂等成功或明确返回“已完成”，不产生异常告警风暴 |
| 退款 DB 成功但 Redis 暂时不可用 | Outbox 能重试，最终 ZSet 恢复 |
| 退款后已超过有效期 | 不重新展示，最终状态为 EXPIRED |
| 订单取消/支付超时 | LOCKING 能回到 UNUSED，结算单进入 CANCELLED |
| MQ 消费线程无 UserContext | 仍能使用事件中的 userId 正确更新与清理 |
| 分片路由检查 | `t_user_coupon_*` 与 `t_coupon_settlement_*` 的同一 userId 落到预期库表 |

## 7. 本次审阅边界

- 结论基于当前 checkout 的静态代码和 SQL/YAML；工作树已有大量用户修改，未做覆盖或回滚。
- 未启动依赖服务，因此无法确认实际 RocketMQ 重试策略、Redisson 租约参数、生产 ShardingSphere 路由和事务提交时序。
- Outbox 对领券/过期已有较完整的租约、重试、PUBLISHED 观察逻辑；支付/退款缓存投影目前没有看到同等级别的专用 Outbox，应把它作为后续可靠性改造的第一候选。
