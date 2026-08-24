package com.nageoffer.onecoupon.distribution.service.batch;

import cn.hutool.core.util.IdUtil;
import cn.hutool.core.date.DateUtil;
import com.alibaba.fastjson2.JSON;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.nageoffer.onecoupon.distribution.common.enums.CouponSourceEnum;
import com.nageoffer.onecoupon.distribution.common.enums.CouponTaskBatchStatusEnum;
import com.nageoffer.onecoupon.distribution.common.enums.CouponTaskItemStatusEnum;
import com.nageoffer.onecoupon.distribution.common.enums.CouponStatusEnum;
import com.nageoffer.onecoupon.distribution.dao.entity.CouponTaskBatchDO;
import com.nageoffer.onecoupon.distribution.dao.entity.CouponTaskItemDO;
import com.nageoffer.onecoupon.distribution.dao.entity.CouponTemplateDO;
import com.nageoffer.onecoupon.distribution.dao.entity.UserCouponDO;
import com.nageoffer.onecoupon.distribution.dao.entity.UserCouponExpireOutboxDO;
import com.nageoffer.onecoupon.distribution.dao.mapper.CouponTaskBatchMapper;
import com.nageoffer.onecoupon.distribution.dao.mapper.CouponTaskItemMapper;
import com.nageoffer.onecoupon.distribution.dao.mapper.CouponTaskMapper;
import com.nageoffer.onecoupon.distribution.dao.mapper.CouponTemplateMapper;
import com.nageoffer.onecoupon.distribution.dao.mapper.UserCouponMapper;
import com.nageoffer.onecoupon.distribution.dao.mapper.UserCouponExpireOutboxMapper;
import com.nageoffer.onecoupon.distribution.mq.event.CouponTemplateDistributionEvent;
import com.nageoffer.onecoupon.distribution.mq.producer.CouponExecuteDistributionProducer;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.support.TransactionTemplate;
import org.springframework.transaction.support.TransactionSynchronization;
import org.springframework.transaction.support.TransactionSynchronizationManager;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.function.Function;
import java.util.stream.Collectors;
import java.time.Instant;
import java.time.temporal.ChronoUnit;

/**
 * 批次结算的数据库事务边界。
 *
 * <p>核心顺序是：读取持久化明细 → 过滤重复/已领用户 → 条件预留真实库存 →
 * `INSERT IGNORE` 写用户券 → 按实际插入数归还多预留库存 → 推进明细和批次终态。
 * Redis 不再参与库存裁决或暂存待写用户，因此 Redis 故障不会丢失待发记录。</p>
 *
 * <p><strong>分库注意：</strong>本项目模板按 shopNumber 分片、用户券按 userId 分片。
 * 当前 `TransactionTemplate` 建立的是本地事务边界；若单批会跨多个物理库，生产部署必须启用 XA/Seata，
 * 或按 Notes 的补偿对账方案运行。不能把此注解单独当作跨库原子性的证明。</p>
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class CouponTaskBatchSettlementService {
    private static final String INVALID_USER_ID = "Excel 用户ID非法";
    private static final String ALREADY_RECEIVED = "用户已领取该优惠券";
    private static final String DUPLICATE_IN_TASK = "Excel 内用户重复";
    private static final String OUT_OF_STOCK = "优惠券模板无库存";

    private final CouponTaskBatchMapper couponTaskBatchMapper;
    private final CouponTaskItemMapper couponTaskItemMapper;
    private final CouponTemplateMapper couponTemplateMapper;
    private final UserCouponMapper userCouponMapper;
    // 与 t_user_coupon 按 userId 同分片，和写券放在同一事务内，保证到期事件不丢。
    private final UserCouponExpireOutboxMapper userCouponExpireOutboxMapper;
    // 手动事务模板，替代方法内@Transactional，规避内部调用AOP失效问题
    private final TransactionTemplate transactionTemplate;
    private final CouponTaskMapper couponTaskMapper;
    // 通知MQ生产者，发放成功后推送短信/邮件通知事件
    private final CouponExecuteDistributionProducer notificationProducer;

    /**
     * 处理一批的最大租约时长；批次过大或数据库变慢时应通过监控调整。
     * 租约超时后，其他消费者实例可以抢占该批次重试，解决实例宕机卡死问题
     */
    private static final long LEASE_SECONDS = 120;

    /**
     * 【对外入口方法】抢占批次租约，并执行批次结算
     * @param batchId 待结算批次主键
     * @param shopNumber 店铺编号（分库分表路由键）
     * @param owner 当前消费者实例标识，作为租约持有者
     * @return 所属主任务taskId，结算完成后用于外层判断整个分发任务是否闭环；抢占失败返回null
     */
    public Long claimAndSettle(Long batchId, Long shopNumber, String owner) {
        // 计算租约过期绝对时间：当前时间 + 租约有效期
        Date expireAt = Date.from(Instant.now().plus(LEASE_SECONDS, ChronoUnit.SECONDS));
        // CAS抢占租约：更新leaseOwner、leaseExpireTime、批次状态PROCESSING
        int claimed = couponTaskBatchMapper.claim(batchId, shopNumber, owner, expireAt);
        // 返回影响行数 !=1：抢占失败，其他实例已抢到租约 / 批次已处理完成，直接返回
        if (claimed != 1) {
            log.debug("[分发] 批次未抢占成功，batchId={}, owner={}", batchId, owner);
            return null;
        }
        // 使用TransactionTemplate手动开启本地事务，执行事务内结算逻辑
        // 注意：同类内部方法调用@Transactional会绕过Spring AOP代理，因此不使用注解声明事务
        return transactionTemplate.execute(status -> settleInTransaction(batchId, shopNumber, owner));
    }

    /**
     * 【事务内批次主流程】租约抢占成功后，在数据库事务中执行完整批次结算
     * 只有已被当前 owner 租约抢占的批次才能进入该方法。
     * 异常向外抛出，RocketMQ 会重试；租约超时后恢复任务也能再次抢占。
     * @param batchId 批次ID
     * @param shopNumber 店铺路由编号
     * @param leaseOwner 当前持有租约的实例标识
     * @return taskId，主分发任务ID
     */
    private Long settleInTransaction(Long batchId, Long shopNumber, String leaseOwner) {
        // selectForUpdate：悲观行锁，对batch记录加排他锁，防止并发修改同一条批次数据，规避ABA脏写
        CouponTaskBatchDO batch = couponTaskBatchMapper.selectForUpdate(batchId, shopNumber);
        // 双重校验：批次不存在 / 状态非处理中 / 租约持有者不匹配 → 拒绝执行（处理迟到旧消息）
        if (batch == null || batch.getStatus() != CouponTaskBatchStatusEnum.PROCESSING.getStatus()
                || !leaseOwner.equals(batch.getLeaseOwner())) {
            return null;
        }

        // 查询该批次下所有待处理明细（PENDING）
        List<CouponTaskItemDO> pendingItems = couponTaskItemMapper.selectPendingByBatchId(batchId, shopNumber);
        // 如果有待处理明细，执行明细结算核心逻辑
        if (!pendingItems.isEmpty()) {
            settlePendingItems(batch, pendingItems);
        }

        // 结算完成后，从明细表实时统计成功、失败行数（不依赖内存变量，保证数据可信）
        int successCount = couponTaskItemMapper.countByBatchIdAndStatus(
                batchId, shopNumber, CouponTaskItemStatusEnum.SUCCESS.getStatus());
        int failCount = couponTaskItemMapper.countByBatchIdAndStatus(
                batchId, shopNumber, CouponTaskItemStatusEnum.FAILED.getStatus());

        // CAS更新批次为终态SUCCESS，携带leaseOwner做条件，防止租约丢失后覆盖结果
        int updated = couponTaskBatchMapper.markSuccess(batchId, shopNumber, leaseOwner, successCount, failCount);
        if (updated != 1) {
            // CAS更新失败：租约已经被抢占/批次已完结，抛出异常交由MQ重试
            throw new IllegalStateException("批次租约已丢失，拒绝覆盖批次终态，batchId=" + batchId);
        }
        log.info("[分发] 批次结算完成，batchId={}, success={}, fail={}", batchId, successCount, failCount);
        return batch.getTaskId();
    }

    /**
     * 明细结算核心方法：对当前批次所有待发放明细做规则校验、库存分配、写入用户券、更新明细状态
     * @param batch 当前批次DO
     * @param pendingItems 待处理明细列表
     */
    private void settlePendingItems(CouponTaskBatchDO batch, List<CouponTaskItemDO> pendingItems) {
        // 构建 itemId → 明细DO映射，方便后续快速查找
        Map<Long, CouponTaskItemDO> itemById = pendingItems.stream()
                .collect(Collectors.toMap(CouponTaskItemDO::getId, Function.identity()));
        // 存储userId非法的明细ID
        List<Long> invalidItemIds = new ArrayList<>();
        // 组装分配器候选对象
        List<CouponBatchAllocator.Candidate> candidates = new ArrayList<>();

        // 第一步：解析并校验userId，过滤非法用户
        for (CouponTaskItemDO item : pendingItems) {
            Long userId = parseUserId(item.getUserId());
            if (userId == null) {
                invalidItemIds.add(item.getId());
            } else {
                candidates.add(new CouponBatchAllocator.Candidate(item.getId(), userId));
            }
        }
        // 标记非法用户明细为失败
        markFailedIfPresent(batch, invalidItemIds, INVALID_USER_ID);
        // 没有合法候选用户，直接返回
        if (candidates.isEmpty()) {
            return;
        }

        // 第二步：查询这批用户中，哪些人已经领取过该模板优惠券
        List<Long> userIds = candidates.stream().map(CouponBatchAllocator.Candidate::userId).distinct().toList();
        List<Long> existingUserIds = userCouponMapper.selectExistingUserIds(batch.getCouponTemplateId(), userIds);
        Set<Long> alreadyReceived = new HashSet<>(existingUserIds == null ? List.of() : existingUserIds);

        // 查询优惠券模板信息（包含库存、有效期、核销规则）
        CouponTemplateDO template = couponTemplateMapper.selectOne(Wrappers.lambdaQuery(CouponTemplateDO.class)
                .eq(CouponTemplateDO::getShopNumber, batch.getShopNumber())
                .eq(CouponTemplateDO::getId, batch.getCouponTemplateId()));
        if (template == null) {
            throw new IllegalStateException("优惠券模板不存在，templateId=" + batch.getCouponTemplateId());
        }

        // 第三步：调用纯内存分配器，基于快照库存做分配规则计算
        // 注意：仅内存预估reservedStock，真实库存扣减依靠数据库条件UPDATE防超发
        CouponBatchAllocator.Allocation allocation = CouponBatchAllocator.allocate(candidates, alreadyReceived,
                template.getStock() == null ? 0 : template.getStock());

        // 如果预估需要预留库存 > 0，执行库存扣减
        if (allocation.reservedStock() > 0) {
            // 条件扣减库存：UPDATE ... SET stock=stock-N WHERE stock >= N
            int reserved = couponTemplateMapper.decrementCouponTemplateStock(
                    batch.getShopNumber(), batch.getCouponTemplateId(), allocation.reservedStock());
            // 扣减失败：并发场景库存被其他批次抢先扣完，重新拉取快照、重新分配并重试一次
            if (reserved != 1) {
                template = couponTemplateMapper.selectOne(Wrappers.lambdaQuery(CouponTemplateDO.class)
                        .eq(CouponTemplateDO::getShopNumber, batch.getShopNumber())
                        .eq(CouponTemplateDO::getId, batch.getCouponTemplateId()));
                allocation = CouponBatchAllocator.allocate(candidates, alreadyReceived,
                        template == null ? 0 : template.getStock());
                // 二次尝试依旧扣减失败，抛出异常，交由MQ重试整个批次
                if (allocation.reservedStock() > 0
                        && couponTemplateMapper.decrementCouponTemplateStock(batch.getShopNumber(), batch.getCouponTemplateId(),
                        allocation.reservedStock()) != 1) {
                    throw new IllegalStateException("模板库存竞争持续失败，交由 MQ 重试，batchId=" + batch.getId());
                }
            }
        }

        // 根据分配结果，标记各类失败明细（已领取、同批次重复、库存不足）
        markAllocationFailures(batch, allocation.failureByItemId());
        // 没有分配成功的明细，直接返回
        if (allocation.successItemIds().isEmpty()) {
            return;
        }

        // 构建 itemId → userId 映射，用于组装UserCoupon
        Map<Long, Long> userIdByItemId = candidates.stream()
                .collect(Collectors.toMap(CouponBatchAllocator.Candidate::itemId, CouponBatchAllocator.Candidate::userId));
        Date now = new Date();
        // 券生效起始时间：模板配置优先，无配置则取当前时间
        Date validStartTime = template.getValidStartTime() == null ? now : template.getValidStartTime();
        Integer validityPeriod = null;
        // 解析核销规则中的有效时长（小时）
        if (template.getConsumeRule() != null && !template.getConsumeRule().isBlank()) {
            validityPeriod = JSON.parseObject(template.getConsumeRule()).getInteger("validityPeriod");
        }
        // 券失效时间：优先模板固定结束时间；否则基于生效时间 + 有效时长偏移
        Date validEndTime = validityPeriod == null
                ? template.getValidEndTime()
                : DateUtil.offsetHour(validStartTime, validityPeriod);

        List<CouponTaskItemDO> successItems = new ArrayList<>(allocation.successItemIds().size());
        List<UserCouponDO> coupons = new ArrayList<>(allocation.successItemIds().size());
        // 循环生成雪花券ID，组装成功明细、用户券DO
        for (Long itemId : allocation.successItemIds()) {
            long couponId = IdUtil.getSnowflakeNextId();
            CouponTaskItemDO item = itemById.get(itemId).toBuilder().couponId(couponId).build();
            successItems.add(item);
            coupons.add(UserCouponDO.builder()
                    .id(couponId)
                    .userId(userIdByItemId.get(itemId))
                    .couponTemplateId(batch.getCouponTemplateId())
                    .receiveTime(now)
                    .receiveCount(1)
                    .validStartTime(validStartTime)
                    .validEndTime(validEndTime)
                    .source(CouponSourceEnum.PLATFORM.getType())
                    .status(CouponStatusEnum.EFFECTIVE.getType())
                    .createTime(now)
                    .updateTime(now)
                    .delFlag(0)
                    .build());
        }

        // 第四步：批量插入用户券 INSERT IGNORE
        // 并发唯一键冲突时不会回滚整批事务，仅跳过冲突行
        userCouponMapper.insertIgnoreBatch(coupons);
        // 查询真实入库成功的couponId，区分哪些写入成功、哪些并发冲突失败
        Set<Long> insertedCouponIds = new HashSet<>(userCouponMapper.selectExistingCouponIds(
                batch.getCouponTemplateId(),
                coupons.stream().map(UserCouponDO::getUserId).toList(),
                coupons.stream().map(UserCouponDO::getId).toList()));

        // 筛选真正入库成功的明细、用户券
        List<CouponTaskItemDO> insertedItems = successItems.stream()
                .filter(item -> insertedCouponIds.contains(item.getCouponId()))
                .toList();
        List<UserCouponDO> insertedCoupons = coupons.stream()
                .filter(coupon -> insertedCouponIds.contains(coupon.getId()))
                .toList();
        // 筛选：分配成功，但并发冲突写入失败的明细（用户已在其他并发请求领到券）
        List<Long> concurrentDuplicateItems = successItems.stream()
                .filter(item -> !insertedCouponIds.contains(item.getCouponId()))
                .map(CouponTaskItemDO::getId)
                .toList();

        // 第五步：归还多预留库存
        // 预估预留数量 - 真实入库数量 = 多扣减的库存，执行归还，保证库存账一致
        int releaseStock = successItems.size() - insertedItems.size();
        if (releaseStock > 0) {
            couponTemplateMapper.incrementCouponTemplateStock(batch.getShopNumber(), batch.getCouponTemplateId(), releaseStock);
        }

        if (!insertedItems.isEmpty()) {
            // 用户券和到期 Outbox 在同一事务内写入。缓存写入、延迟消息发送由 engine 的 Outbox
            // 调度器执行；即使此消费者在提交后立即宕机，Outbox 仍会被可靠唤醒。
            userCouponExpireOutboxMapper.insertIgnoreBatch(insertedCoupons.stream()
                    .map(coupon -> UserCouponExpireOutboxDO.builder()
                            .id(IdUtil.getSnowflakeNextId())
                            .userCouponId(coupon.getId())
                            .userId(coupon.getUserId())
                            .couponTemplateId(coupon.getCouponTemplateId())
                            .validEndTime(coupon.getValidEndTime())
                            .eventType("USER_COUPON_EXPIRE")
                            .status("NEW")
                            .retryAt(now)
                            .attempts(0)
                            .createTime(now)
                            .updateTime(now)
                            .build())
                    .toList());
            // 更新入库成功明细状态为SUCCESS
            couponTaskItemMapper.markSuccess(batch.getId(), batch.getShopNumber(), insertedItems);
            // 通知不影响发券结果；用户券缓存和到期消息已由上面的 Outbox 可靠投影。
            registerPostCommitNotifications(batch, insertedItems, insertedCoupons, template);
        }
        // 并发冲突的明细标记失败：用户已领取
        markFailedIfPresent(batch, concurrentDuplicateItems, ALREADY_RECEIVED);
    }

    /**
     * 根据分配器返回的失败集合，分组标记明细失败
     * @param batch 当前批次
     * @param failures itemId → 失败原因枚举
     */
    private void markAllocationFailures(CouponTaskBatchDO batch,
                                        Map<Long, CouponBatchAllocator.FailureReason> failures) {
        // 按失败原因分组
        Map<CouponBatchAllocator.FailureReason, List<Long>> grouped = failures.entrySet().stream()
                .collect(Collectors.groupingBy(Map.Entry::getValue,
                        Collectors.mapping(Map.Entry::getKey, Collectors.toList())));
        // 分别标记三类失败明细
        markFailedIfPresent(batch, grouped.get(CouponBatchAllocator.FailureReason.ALREADY_RECEIVED), ALREADY_RECEIVED);
        markFailedIfPresent(batch, grouped.get(CouponBatchAllocator.FailureReason.DUPLICATE_IN_TASK), DUPLICATE_IN_TASK);
        markFailedIfPresent(batch, grouped.get(CouponBatchAllocator.FailureReason.OUT_OF_STOCK), OUT_OF_STOCK);
    }

    /**
     * 通用方法：批量标记明细失败，并写入失败原因
     * @param batch 批次
     * @param itemIds 需要标记失败的明细ID集合
     * @param reason 失败中文备注
     */
    private void markFailedIfPresent(CouponTaskBatchDO batch,
                                     List<Long> itemIds,
                                     String reason) {
        if (itemIds != null && !itemIds.isEmpty()) {
            // 失败数据只写入同库的task_item，不引入跨库失败表，保障本地事务边界
            // 运营导出失败Excel直接读取本表
            couponTaskItemMapper.markFailed(batch.getId(), batch.getShopNumber(), itemIds, reason);
        }
    }

    /**
     * 解析userId字符串，校验是否合法正长整型
     * @param userId 原始Excel读取的用户ID字符串
     * @return 合法Long / null（非法）
     */
    private Long parseUserId(String userId) {
        try {
            long parsed = Long.parseLong(userId);
            return parsed > 0 ? parsed : null;
        } catch (RuntimeException ignored) {
            // 数字格式异常，直接返回null判定非法
            return null;
        }
    }

    /**
     * 注册事务提交后回调动作：只发送用户通知。
     * 用户券缓存投影和到期事件已经改由同事务 UserCouponExpireOutbox 负责，不能再在此处直写 Redis。
     * @param batch 批次信息
     * @param insertedItems 入库成功明细
     * @param coupons 入库成功用户券
     * @param template 优惠券模板
     */
    private void registerPostCommitNotifications(CouponTaskBatchDO batch,
                                           List<CouponTaskItemDO> insertedItems,
                                           List<UserCouponDO> coupons,
                                           CouponTemplateDO template) {
        // 需要在事务提交后执行的逻辑封装
        Runnable effect = () -> {
            try {
                // 查询主分发任务配置，如果开启通知，则循环推送通知MQ（短信/邮件）
                var task = couponTaskMapper.selectById(batch.getTaskId());
                if (task != null && task.getNotifyType() != null && !task.getNotifyType().isBlank()) {
                    Map<Long, UserCouponDO> couponById = coupons.stream()
                            .collect(Collectors.toMap(UserCouponDO::getId, Function.identity()));
                    for (CouponTaskItemDO item : insertedItems) {
                        UserCouponDO coupon = couponById.get(item.getCouponId());
                        if (coupon == null) {
                            continue;
                        }
                        notificationProducer.sendMessage(CouponTemplateDistributionEvent.builder()
                                .couponTaskId(batch.getTaskId())
                                .couponTaskBatchId(batch.getId())
                                .notifyType(task.getNotifyType())
                                .shopNumber(batch.getShopNumber())
                                .couponTemplateId(batch.getCouponTemplateId())
                                .couponTemplateConsumeRule(template.getConsumeRule())
                                .userId(String.valueOf(coupon.getUserId()))
                                .phone(item.getPhone())
                                .mail(item.getMail())
                                .distributionEndFlag(Boolean.FALSE)
                                .batchUserSetSize(1)
                                .build());
                    }
                }
            } catch (RuntimeException ex) {
                log.error("[分发] 用户通知投递失败，batchId={}，应由通知补偿任务重试", batch.getId(), ex);
            }
        };

        // 判断当前是否处于事务激活状态，注册afterCommit回调
        if (TransactionSynchronizationManager.isSynchronizationActive()) {
            TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronization() {
                @Override
                public void afterCommit() {
                    effect.run();
                }
            });
        } else {
            // 无事务场景，直接执行（兜底分支）
            effect.run();
        }
    }
}
