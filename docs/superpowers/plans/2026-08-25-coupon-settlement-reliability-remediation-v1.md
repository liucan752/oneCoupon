# 优惠券结算可靠性改造 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 以本地状态机事务、业务幂等键、订单取消回退、可靠 Redis 派生投影和统一金额计算，修复优惠券锁定、支付、退款链路中除查询回查和 MQ 上下文外的已识别问题。

**Architecture:** 用户券和结算单仍按 userId 在同一分片内作为事实状态；订单号与业务流水号定义状态迁移与幂等边界；Redis 的删除与回补改为事务内落库、事务外异步执行的派生投影任务。金额计算下沉到 framework 的纯领域组件，engine 与 settlement 均通过适配器使用。

**Tech Stack:** Java 17、Spring Boot 3、MyBatis-Plus、ShardingSphere 5.3、MySQL、Redisson、Spring Data Redis、RocketMQ、JUnit 5。

---

## Objective

在当前 oneCoupon 结算链路上，修复用户已指出的全部问题，但本轮明确不处理以下两项：

- 结算查询侧是否回查 MySQL、Redis 投影缺失的对账与回补；
- MQ 消费线程是否使用 `UserContext`，以及支付/退款 MQ 事件的上下文传递。

目标是把优惠券结算收敛为可审计、可幂等、可恢复的状态机：用户券、结算单、订单支付/退款业务流水和 Redis 派生投影之间，任何跨系统副作用失败都能重试或人工定位；重复事件不会重复扣券或重复归还；订单取消/超时不会永久锁券。

本文件是审批用方案，不包含业务代码修改。当前 checkout 的核心证据位于：

- `onecoupon-main/engine/src/main/java/com/nageoffer/onecoupon/engine/service/impl/UserCouponServiceImpl.java:195-443`
- `onecoupon-main/engine/src/main/java/com/nageoffer/onecoupon/engine/controller/UserCouponController.java:79-98`
- `onecoupon-main/engine/src/main/java/com/nageoffer/onecoupon/engine/dao/entity/CouponSettlementDO.java:55-93`
- `onecoupon-main/engine/src/main/resources/shardingsphere-config.yaml`
- `onecoupon-main/resources/database/onecoupon.sql` 中的 `t_coupon_settlement_*` 与 `t_user_coupon_*` 定义

## Architecture

推荐采用“本地状态机事务 + 业务幂等键 + 结算副作用 Outbox + 订单事件驱动回退”的渐进式方案。

- 数据库是用户券状态和结算单状态的事实来源；每次状态变更都必须带旧状态条件，并检查更新条数。
- 订单号、支付流水号、退款流水号成为业务幂等与审计主键，不再只靠 `couponId` 和 Redis 锁。
- Redis 删除/回补作为派生投影写入结算副作用 Outbox，由租约、重试和最终状态观察机制驱动，不纳入 MySQL 事务的“假原子”承诺。
- 订单取消/支付超时通过明确的取消命令或事件回退 `LOCKING -> UNUSED`，并把结算单置为 `CANCELLED`。
- 金额计算统一到单一领域组件；在结算单中保存计算快照，退款只按已记录的优惠券抵扣事实决定是否归还。

## Planned file map

| 变更类型 | 文件 | 职责 |
|---|---|---|
| 修改 | `onecoupon-main/engine/src/main/java/com/nageoffer/onecoupon/engine/controller/UserCouponController.java` | 增加取消入口并切换支付、退款到含订单与流水号的新契约 |
| 修改 | `onecoupon-main/engine/src/main/java/com/nageoffer/onecoupon/engine/service/UserCouponService.java` | 定义锁定、支付、退款、取消的明确业务接口 |
| 修改或拆分 | `onecoupon-main/engine/src/main/java/com/nageoffer/onecoupon/engine/service/impl/UserCouponServiceImpl.java` | 保留领券职责，迁出结算流程或调用新的结算服务 |
| 新建 | `onecoupon-main/engine/src/main/java/com/nageoffer/onecoupon/engine/service/CouponSettlementService.java` | 承载结算状态机接口 |
| 新建 | `onecoupon-main/engine/src/main/java/com/nageoffer/onecoupon/engine/service/impl/CouponSettlementServiceImpl.java` | 承载锁定、支付、退款、取消、本地事务和安全解锁 |
| 修改 | `onecoupon-main/engine/src/main/java/com/nageoffer/onecoupon/engine/dto/req/CouponCreatePaymentReqDTO.java` | 增加锁定幂等请求号及统一金额计算所需字段约束 |
| 修改 | `onecoupon-main/engine/src/main/java/com/nageoffer/onecoupon/engine/dto/req/CouponProcessPaymentReqDTO.java` | 增加 orderId、paymentId、eventId 等支付幂等字段 |
| 修改 | `onecoupon-main/engine/src/main/java/com/nageoffer/onecoupon/engine/dto/req/CouponProcessRefundReqDTO.java` | 增加 orderId、refundId、退款金额、全额退款标志和 eventId |
| 新建 | `onecoupon-main/engine/src/main/java/com/nageoffer/onecoupon/engine/dto/req/CouponCancelPaymentReqDTO.java` | 定义取消或支付超时回退契约 |
| 修改 | `onecoupon-main/engine/src/main/java/com/nageoffer/onecoupon/engine/dao/entity/CouponSettlementDO.java` | 承载幂等键、业务流水、金额快照、规则版本、取消/退款审计字段 |
| 修改 | `onecoupon-main/engine/src/main/java/com/nageoffer/onecoupon/engine/dao/mapper/CouponSettlementMapper.java` | 声明按订单、流水号和旧状态条件更新的专用方法 |
| 新建 | `onecoupon-main/engine/src/main/resources/mapper/CouponSettlementMapper.xml` | 实现精确状态转换、幂等读取和条件更新 SQL |
| 新建 | `onecoupon-main/engine/src/main/java/com/nageoffer/onecoupon/engine/dao/entity/UserCouponSettlementProjectionOutboxDO.java` | 描述 Redis 投影动作与重试租约 |
| 新建 | `onecoupon-main/engine/src/main/java/com/nageoffer/onecoupon/engine/dao/mapper/UserCouponSettlementProjectionOutboxMapper.java` | 定义投影任务领取、完成、重试和观察方法 |
| 新建 | `onecoupon-main/engine/src/main/resources/mapper/UserCouponSettlementProjectionOutboxMapper.xml` | 实现 Outbox 状态机 SQL |
| 新建 | `onecoupon-main/engine/src/main/java/com/nageoffer/onecoupon/engine/service/outbox/UserCouponSettlementProjectionOutboxDispatcher.java` | 执行 ZREM/ZADD、租约恢复和指数退避 |
| 新建 | `onecoupon-main/framework/src/main/java/com/nageoffer/onecoupon/framework/coupon/` 下的规则快照与计算组件 | 提供 engine 和 settlement 共用的纯金额计算能力 |
| 修改 | `onecoupon-main/settlement/src/main/java/com/nageoffer/onecoupon/settlement/service/impl/CouponQueryServiceImpl.java` | 将本轮仍保留的 Redis 查询流程接入共用金额计算适配器，不加入 MySQL 回查 |
| 新建 | `onecoupon-main/resources/database/migration/V20260826__coupon_settlement_reliability.sql` | 为所有物理分片表增加结算字段、约束、投影 Outbox 表和索引 |
| 新建 | `onecoupon-main/engine/src/test/java/com/nageoffer/onecoupon/engine/settlement/` 下的状态机、Outbox 与金额测试 | 覆盖本方案的业务和故障场景 |

## Scope and assumptions

- 本轮修复范围为此前阅读指南第 4 节中的前 13 项；不修改用户本次明确排除的最后两项，即查询 Redis 投影回查/对账与 MQ `UserContext` 风险。
- 默认业务口径：只有全额退款才归还整张优惠券；部分退款暂不归还优惠券，并记录拒绝归还原因。若业务必须支持部分退款，需要在审批时改选“按退款明细建模”方案，不能仅改一个状态条件。
- 现有 `t_user_coupon_*` 与 `t_coupon_settlement_*` 按 `user_id` 分片，方案继续保持同一用户维度的本地事务，不引入跨库分布式事务。
- 现有历史数据不假设存在已部署的旧版本迁移；只增加运行时幂等与补偿逻辑，不做无依据的历史回填。
- 订单系统能够提供稳定的 `orderId`、支付成功流水号、退款成功流水号、退款金额及全额/部分退款标识；如果现有订单事件缺失这些字段，先在接口适配层补齐。

## Implementation Plan

- [ ] **建立结算领域状态与错误码契约。** 在 engine 内统一用户券、结算单和订单事件的状态迁移矩阵，明确允许的迁移、重复事件的幂等成功条件、冲突事件的拒绝条件和监控错误码；把 `CANCELLED` 从“仅实体注释”提升为可调用的业务状态。

- [ ] **修复锁定事务的原子性与时间校验。** 调整 `UserCouponServiceImpl#createPaymentRecord`：同时校验 `validStartTime <= now < validEndTime`；锁定事务中对用户券的条件更新必须返回 1，否则抛异常回滚结算单；修正商品金额比较为数值比较，并统一金额舍入规则；锁和事务的释放顺序要保证数据库提交完成后才释放。

- [ ] **补齐结算单和订单事件幂等字段。** 为 `t_coupon_settlement_*` 增加可路由、可审计的 `order_id` 约束字段使用规范，以及支付流水号、退款流水号、优惠券抵扣金额、退款金额、规则快照/计算版本、幂等请求号和状态更新时间等字段；为相同订单、用户、券建立唯一业务约束或等价的条件写入策略，避免取消后的重复插入和跨订单推进。

- [ ] **扩展支付与退款请求契约并实行状态幂等。** `processPayment` 和 `processRefund` 不再只接收 `couponId`，必须同时校验用户、订单和对应流水号；重复的同一流水号在目标状态已存在时返回幂等成功；流水号不同但状态已推进或订单不匹配时拒绝并告警；更新条数为 0 时先区分“已完成”与“状态冲突”，不把所有重复消息当系统异常。

- [ ] **修复分布式锁生命周期。** 将创建、支付、退款的锁释放统一放在事务方法外部的 `finally` 中；释放前确认当前线程仍持有锁；明确等待时间、租约时间和 watchdog 策略；锁只作为并发优化，数据库条件更新和幂等约束必须能独立阻止错误状态。

- [ ] **增加订单取消/支付超时回退链路。** 新增取消命令或订单取消事件适配层，按 `orderId + couponId + userId` 查找锁定中的结算单；在本地事务内执行 `LOCKED -> CANCELLED` 与 `LOCKING -> UNUSED`，只有旧状态匹配时才更新；将缓存投影回补作为后续 Outbox 任务，避免券永久锁死。

- [ ] **增加结算 Redis 投影 Outbox。** 在锁定成功和退款/取消成功的本地事务中写入投影任务，任务至少包含用户、券、模板、动作类型、目标 score、业务来源、幂等键、重试次数、租约和最后错误；调度器执行 `ZREM/ZADD`，成功后标记完成，失败按退避重试；数据库状态成功但 Redis 失败时，接口仍返回业务状态成功并通过任务最终收敛。

- [ ] **定义全额退款归还规则并保存结算快照。** 锁定时记录实际优惠金额、订单金额、应付金额、模板规则版本和适用商品摘要；退款时仅当订单系统标记为全额退款且退款流水号首次处理时，才执行 `USED -> UNUSED`；部分退款不归还整券，记录明确的不可归还原因，避免当前“任意退款即整券回退”。

- [ ] **防止退款回补已过期券。** 退款事务完成后由投影任务读取券的有效期和当前状态；有效期已过则不执行可用 ZSet 回补，并触发/保留过期收敛；有效期内才生成回补 member。该项只处理退款产生的错误回补，不扩展本轮排除的查询侧 DB 回查能力。

- [ ] **统一 engine 与 settlement 的优惠计算。** 抽取共享的金额计算领域组件或明确 engine 为唯一计算真相；固定立减、满减、折扣、最大优惠、门槛和舍入均由同一套策略完成；结算单保存计算结果和规则版本，防止模板更新后支付/退款重算漂移。

- [ ] **补齐测试、故障演练与监控。** 增加锁定并发、更新 0 行回滚、重复支付、重复退款、跨订单流水号、取消回退、Redis 投影失败重试、锁租约过期、全额/部分退款、过期退款和金额 scale 差异测试；增加 Outbox backlog、重试次数、状态冲突、锁券超时和投影失败指标。

- [ ] **分阶段发布并保留回滚开关。** 先发布只读校验和影子 Outbox，再启用严格幂等与取消回退，最后切换支付/退款事件到新契约；对新字段、唯一约束、Outbox 调度器和新接口分别提供开关或停用策略；每阶段保留旧接口兼容窗口，但不允许旧接口绕过新状态条件。

## Verification Criteria

- 锁定事务中用户券条件更新返回 0 时，`t_coupon_settlement_*` 不留下新增记录。
- 两个实例并发锁定同一用户券时，最多一个结算单进入 `LOCKED`，用户券最多一次进入 `LOCKING`。
- 相同订单和相同请求号重试只得到一个业务结果；相同幂等键复用不同请求体会被拒绝。
- 支付成功消息重复投递时，第一次推进到 `PAID/USED`，后续相同流水号幂等成功，不重复写入或告警；不同流水号被拒绝。
- 退款成功消息重复投递时，第一次推进到 `REFUNDED/UNUSED`，后续相同退款流水号幂等成功；不同订单或不同退款流水号不能再次归还。
- 订单取消或支付超时后，锁定中的结算单能够进入 `CANCELLED`，用户券能够回到 `UNUSED`；已支付或已退款结算单不会被取消事件回退。
- Redis `ZREM/ZADD` 任一动作失败时，数据库状态不回滚，Outbox 能够在租约过期后重试并最终完成；重复执行不会产生错误 member 或重复业务效果。
- 退款发生在有效期结束之后时，不会把用户券重新作为可用券写入投影；用户券最终状态为 `EXPIRED` 或保持既有不可用终态。
- 全额退款归还整券；部分退款不会整券归还，并留下可审计的拒绝原因和退款流水号。
- engine 与 settlement 对同一模板、同一订单金额给出一致的优惠金额；`10.0` 与 `10.00` 等 scale 不同但数值相等的金额不会误拒绝。
- 分片 SQL 日志证明用户券、结算单、结算 Outbox 使用同一 userId 路由到预期库表；范围扫描任务能够覆盖全部物理分片。
- 至少完成静态 XML/YAML/Mapper 对应性检查、engine 单元测试、可用依赖下的模块编译、Redis/MQ 故障演练和一轮端到端锁定→支付→退款→取消回放；任何未执行项目都必须在发布记录中标明。

## Potential Risks and Mitigations

1. **新增唯一约束影响现有重复数据或线上写入。**
   Mitigation：先只读扫描重复键并生成报告，再分批清理/人工决策，最后添加约束；不直接假设历史数据天然唯一。

2. **支付/退款接口契约变更导致订单系统同时升级压力。**
   Mitigation：先接受新旧 DTO 的兼容入口，但旧入口只能解析出明确的拒绝结果或走受控适配，不允许在缺少流水号时执行不可逆状态变更；完成调用方切换后再下线旧入口。

3. **Outbox 重试造成 Redis 写放大或旧任务覆盖新状态。**
   Mitigation：任务使用业务幂等键、目标动作版本和旧状态/版本校验；重试采用租约和指数退避，并记录最后错误和最大重试告警。

4. **取消事件与支付成功事件乱序。**
   Mitigation：以订单事件版本或业务时间序列做比较；状态更新必须带允许的旧状态，晚到取消只能观察为已支付并转为无需处理，而不能强行回退。

5. **部分退款业务口径未获订单方确认。**
   Mitigation：本方案默认部分退款不归还整券；若审批选择按明细归还，必须另立数据模型和验收集，不能在当前方案上临时放宽状态条件。

6. **金额计算统一后与现有接口结果存在差异。**
   Mitigation：先对历史模板和代表性订单做双算对比，记录差异；通过规则版本和灰度开关逐步切换，差异超阈值自动阻断发布。

7. **锁释放时机修复后吞吐下降。**
   Mitigation：锁只覆盖同一券的本地事务，Redis 投影和 MQ 不在锁内；通过并发压测确认等待时间，必要时改为数据库版本条件更新承担主要并发控制。

8. **本地事务与 Outbox 同库要求被分片配置破坏。**
   Mitigation：所有 Outbox 表使用同一 user_id 分片策略；为 userId 路由、范围扫描和跨表事务增加 SQL 日志断言及启动配置检查。

## Alternative Approaches

1. **最小修补方案。** 只增加更新条数检查、流水号字段、取消接口、退款有效期判断和锁释放修复，不建设 Redis Outbox。改动小、上线快，但 Redis 失败仍需要人工或定时脚本补偿，不推荐作为最终方案。

2. **推荐的渐进式 Outbox 方案。** 在当前本地事务和分片设计上增加结算投影 Outbox、订单幂等和显式状态机，按阶段灰度。兼容现有架构，能覆盖数据库与 Redis 的故障窗口，改造成本可控。

3. **订单中心主导的结算重构。** 把优惠券结算变为订单域内的不可变优惠明细事件，engine 只消费订单状态并维护用户券投影。长期边界更清晰，但需要订单系统、事件契约和历史数据一起重构，超出本次修复范围。

## Rollout and rollback

- 第一个发布批次只增加字段、Mapper、只读校验和 Outbox 表，不改变旧状态迁移。
- 第二个发布批次启用锁定更新条数检查、开始时间检查、金额比较修复和安全解锁；发现调用方不兼容时可关闭严格参数校验，但不能关闭旧状态条件更新。
- 第三个发布批次启用支付/退款流水号幂等、取消回退和全额退款规则。
- 第四个发布批次启用 Redis 投影 Outbox，并以 backlog、重试率和状态对账作为放量指标。
- 任一批次回滚时，保留已经写入的幂等字段和 Outbox 记录；停止新任务消费前先暂停入口，再处理未完成任务，避免删除事实记录造成不可恢复。

## Approval gate

请重点审批以下三个业务决策后再进入实现：

- 是否接受“部分退款不归还整张券”的默认规则；
- 是否同意把支付/退款请求升级为必须携带订单号和支付/退款流水号；
- 是否采用推荐的“本地状态机事务 + Redis 投影 Outbox + 订单取消回退”方案，而不是最小修补方案。

审批通过后，再拆分为实现计划和逐项代码修改；在此之前不修改业务实现。
