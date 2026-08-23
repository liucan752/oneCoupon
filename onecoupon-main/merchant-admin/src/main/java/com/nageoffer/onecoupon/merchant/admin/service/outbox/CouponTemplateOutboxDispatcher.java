package com.nageoffer.onecoupon.merchant.admin.service.outbox;

import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.nageoffer.onecoupon.merchant.admin.common.enums.CouponTemplateStatusEnum;
import com.nageoffer.onecoupon.merchant.admin.dao.entity.CouponTemplateDO;
import com.nageoffer.onecoupon.merchant.admin.dao.entity.CouponTemplateOutboxDO;
import com.nageoffer.onecoupon.merchant.admin.dao.mapper.CouponTemplateMapper;
import com.nageoffer.onecoupon.merchant.admin.dao.mapper.CouponTemplateOutboxMapper;
import com.nageoffer.onecoupon.merchant.admin.mq.event.CouponTemplateDelayEvent;
import com.nageoffer.onecoupon.merchant.admin.mq.producer.CouponTemplateDelayExecuteStatusProducer;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.redisson.api.RBloomFilter;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.util.Date;
import java.util.List;
import java.util.UUID;

/**
 * Outbox 发件箱分发器
 * 核心职责：
 * 1. 定时扫描 outbox 待投递事件（事务内预先落库的消息记录）
 * 2. 通过抢占锁（lease 租赁机制）防止多实例定时任务重复消费同一条事件
 * 3. 完成事件投递逻辑：写Redis缓存、添加布隆过滤器、发送RocketMQ延迟消息
 * 4. 投递成功标记完成；投递失败按照重试策略延后重试，记录错误信息
 * 设计模式：Outbox Pattern（事务发件箱），保障【优惠券模板入库】和【消息投递】最终一致性
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class CouponTemplateOutboxDispatcher {

    // outbox 发件箱表 Mapper：存储待投递消息记录
    private final CouponTemplateOutboxMapper couponTemplateOutboxMapper;
    // 优惠券模板主表 Mapper：查询模板真实业务状态
    private final CouponTemplateMapper couponTemplateMapper;
    // 缓存写入组件：负责将优惠券模板写入Redis缓存，供下游查询
    private final CouponTemplateCacheWriter couponTemplateCacheWriter;
    // MQ生产者：发送优惠券到期延迟消息，到期后自动关闭优惠券模板
    private final CouponTemplateDelayExecuteStatusProducer couponTemplateDelayExecuteStatusProducer;
    // Redisson 布隆过滤器：拦截不存在的优惠券ID查询，缓存穿透防护
    private final RBloomFilter<String> couponTemplateQueryBloomFilter;
    // 重试策略组件：根据重试次数计算下次重试延迟时间（指数退避等策略）
    private final CouponTemplateOutboxRetryPolicy retryPolicy;

    // 单次定时任务批量拉取 outbox 消息数量，默认100条
    @Value("${one-coupon.template-outbox.batch-size:100}")
    private int batchSize;

    // 任务租赁有效期（秒）：抢占到任务后，多久内属于当前worker持有，防止其他实例抢占；默认30s
    @Value("${one-coupon.template-outbox.lease-seconds:30}")
    private int leaseSeconds;

    // 当前服务实例唯一标识 workerId，用于分布式抢占锁，区分不同服务节点
    private final String workerId = UUID.randomUUID().toString();

    /**
     * 定时调度入口
     * fixedDelay：上一次调度执行完成后，间隔多久再执行（区别 fixedRate，避免任务重叠堆积）
     * 配置默认 1000ms 执行一次
     */
    @Scheduled(fixedDelayString = "${one-coupon.template-outbox.fixed-delay-ms:1000}")
    public void dispatchReadyEvents() {
        Date now = new Date();

        // 【步骤1】释放超时未处理的任务：
        // 如果某个worker抢占任务后宕机，lease租赁时间过期，任务状态重置为待处理，允许其他节点重新认领
        couponTemplateOutboxMapper.resetExpiredProcessing(now);

        // 【步骤2】批量查询符合投递条件的待就绪事件：状态待投递、到达可投递时间，限制批量条数
        List<CouponTemplateOutboxDO> events = couponTemplateOutboxMapper.selectReadyEvents(now, batchSize);

        // 【步骤3】遍历每一条待投递事件，分布式抢占认领
        for (CouponTemplateOutboxDO event : events) {
            // 计算当前worker持有该任务的到期时间
            Date leaseUntil = new Date(now.getTime() + leaseSeconds * 1000L);

            /**
             * claim 认领SQL（乐观锁抢占）：
             * 更新 outbox 记录，标记 workerId、租赁截止时间；
             * 只有更新影响行数=1 代表抢占成功，防止多实例同时消费同一条消息（避免重复投递）
             * 主键 + shopNumber 作为行锁维度，保证原子抢占
             */
            if (couponTemplateOutboxMapper.claim(event.getId(), event.getShopNumber(), workerId, leaseUntil) == 1) {
                // 抢占成功，执行投递逻辑
                dispatch(event);
            }
            // 抢占失败：其他节点已经认领，跳过本条
        }
    }

    /**
     * 真正执行单条 outbox 事件投递业务逻辑
     * @param event outbox待投递事件记录
     */
    private void dispatch(CouponTemplateOutboxDO event) {
        try {
            // 【步骤1】查询优惠券模板主表真实数据（以业务主表为准，outbox仅作为消息载体，防止数据不一致）
            CouponTemplateDO template = couponTemplateMapper.selectOne(Wrappers.lambdaQuery(CouponTemplateDO.class)
                    .eq(CouponTemplateDO::getShopNumber, event.getShopNumber())
                    .eq(CouponTemplateDO::getId, event.getTemplateId()));

            // 分支A：模板不存在 OR 模板已经结束 → 无需投递，直接标记outbox完成，丢弃事件
            if (template == null || CouponTemplateStatusEnum.ENDED.getStatus() == template.getStatus()) {
                couponTemplateOutboxMapper.markDone(event.getId(), event.getShopNumber(), workerId);
                return;
            }

            // 分支B：优惠券有效期已经过期，但状态还是ACTIVE生效中 → 自动更新模板状态为已结束，标记事件完成
            if (!template.getValidEndTime().after(new Date())) {
                couponTemplateMapper.update(CouponTemplateDO.builder()
                                .status(CouponTemplateStatusEnum.ENDED.getStatus())
                                .build(),
                        Wrappers.lambdaUpdate(CouponTemplateDO.class)
                                .eq(CouponTemplateDO::getShopNumber, event.getShopNumber())
                                .eq(CouponTemplateDO::getId, event.getTemplateId())
                                .eq(CouponTemplateDO::getStatus, CouponTemplateStatusEnum.ACTIVE.getStatus()));
                couponTemplateOutboxMapper.markDone(event.getId(), event.getShopNumber(), workerId);
                return;
            }

            // 分支C：模板正常有效，执行完整投递链路
            // 1. 将优惠券模板写入Redis缓存，对外提供高速查询
            couponTemplateCacheWriter.write(template);
            // 2. 将模板ID加入布隆过滤器，拦截不存在模板ID的查询，防止缓存穿透
            couponTemplateQueryBloomFilter.add(String.valueOf(template.getId()));
            // 3. 发送 RocketMQ 延迟消息：延迟到 validEndTime 优惠券到期时间执行，用于到期关闭模板
            couponTemplateDelayExecuteStatusProducer.sendMessage(CouponTemplateDelayEvent.builder()
                    .shopNumber(template.getShopNumber())
                    .couponTemplateId(template.getId())
                    .delayTime(template.getValidEndTime().getTime())
                    .build());

            // ✅ 全部投递成功：标记outbox事件为已完成，后续定时任务不再扫描这条记录
            couponTemplateOutboxMapper.markDone(event.getId(), event.getShopNumber(), workerId);
        } catch (Throwable throwable) {
            // ❌ 投递异常：按照重试策略延后重试
            // 累计重试次数 +1
            int attempts = event.getAttempts() + 1;
            // 根据重试策略（如指数退避）计算本次重试需要等待多少秒
            int delaySeconds = retryPolicy.nextDelaySeconds(event.getAttempts());
            // 计算下次允许重试的时间
            Date retryAt = new Date(System.currentTimeMillis() + delaySeconds * 1000L);

            // 更新outbox记录：标记下次重试时间、重试次数、截断后的异常信息
            couponTemplateOutboxMapper.markRetry(event.getId(), event.getShopNumber(), workerId, retryAt, attempts,
                    truncateError(throwable));

            log.warn("优惠券模板 Outbox 投递失败，eventId={}, shopNumber={}, attempts={}, retryAt={}",
                    event.getId(), event.getShopNumber(), attempts, retryAt, throwable);
        }
    }

    /**
     * 截断异常信息，避免数据库存储超长文本
     * 只保留异常类名 + 异常message，最长500字符
     */
    private String truncateError(Throwable throwable) {
        String message = throwable.getClass().getSimpleName() + ": " + throwable.getMessage();
        return message.length() > 500 ? message.substring(0, 500) : message;
    }
}
