package com.nageoffer.onecoupon.distribution.mq.consumer;

import com.alibaba.fastjson2.JSON;
import com.nageoffer.onecoupon.distribution.common.constant.DistributionRocketMQConstant;
import com.nageoffer.onecoupon.distribution.mq.base.MessageWrapper;
import com.nageoffer.onecoupon.distribution.mq.event.CouponTaskBatchReadyEvent;
import com.nageoffer.onecoupon.distribution.service.batch.CouponTaskBatchSettlementService;
import com.nageoffer.onecoupon.distribution.service.batch.CouponTaskFinalizer;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.rocketmq.spring.annotation.RocketMQMessageListener;
import org.apache.rocketmq.spring.core.RocketMQListener;
import org.springframework.stereotype.Component;

import java.util.UUID;

/**
 * 持久化批次消费者。
 *
 * <p>不依赖 Redis 幂等锁：同一 batchId 的重复消息会在数据库 claim CAS 处竞争，
 * 只有一个实例得到 leaseOwner。消费者异常抛出，RocketMQ 重试；租约过期后补偿扫描也能接管。</p>
 */
@Component
@RequiredArgsConstructor
@RocketMQMessageListener(
        topic = DistributionRocketMQConstant.TEMPLATE_BATCH_READY_TOPIC_KEY,
        consumerGroup = DistributionRocketMQConstant.TEMPLATE_BATCH_READY_CG_KEY
)
@Slf4j(topic = "CouponTaskBatchReadyConsumer")
public class CouponTaskBatchReadyConsumer implements RocketMQListener<MessageWrapper<CouponTaskBatchReadyEvent>> {

    private final CouponTaskBatchSettlementService settlementService;
    private final CouponTaskFinalizer taskFinalizer;

    @Override
    public void onMessage(MessageWrapper<CouponTaskBatchReadyEvent> wrapper) {
        CouponTaskBatchReadyEvent event = wrapper.getMessage();
        String owner = "batch-consumer-" + UUID.randomUUID();
        log.info("[消费者] 持久化批次开始结算，event={}, owner={}", JSON.toJSONString(event), owner);
        Long taskId = settlementService.claimAndSettle(event.getBatchId(), event.getShopNumber(), owner);
        if (taskId != null) {
            taskFinalizer.tryFinish(taskId, event.getShopNumber());
        }
    }
}
