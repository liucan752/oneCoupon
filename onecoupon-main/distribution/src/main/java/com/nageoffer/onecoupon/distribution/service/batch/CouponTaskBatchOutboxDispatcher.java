package com.nageoffer.onecoupon.distribution.service.batch;

import com.nageoffer.onecoupon.distribution.common.enums.CouponTaskBatchStatusEnum;
import com.nageoffer.onecoupon.distribution.dao.entity.CouponTaskBatchDO;
import com.nageoffer.onecoupon.distribution.dao.entity.CouponTaskBatchOutboxDO;
import com.nageoffer.onecoupon.distribution.dao.mapper.CouponTaskBatchMapper;
import com.nageoffer.onecoupon.distribution.dao.mapper.CouponTaskBatchOutboxMapper;
import com.nageoffer.onecoupon.distribution.mq.event.CouponTaskBatchReadyEvent;
import com.nageoffer.onecoupon.distribution.mq.producer.CouponTaskBatchReadyProducer;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.util.Date;
import java.util.List;
import java.util.UUID;

/**
 * 批次就绪 Outbox 调度器。它保证批次落库后最终一定会被 MQ 唤醒；
 * MQ 重复投递由批次消费者的数据库租约 CAS 兜底。
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class CouponTaskBatchOutboxDispatcher {
    private final CouponTaskBatchOutboxMapper outboxMapper;
    private final CouponTaskBatchMapper batchMapper;
    private final CouponTaskBatchReadyProducer batchReadyProducer;
    private final CouponTaskBatchOutboxRetryPolicy retryPolicy = new CouponTaskBatchOutboxRetryPolicy();

    @Value("${one-coupon.distribution.batch-outbox.batch-size:100}")
    private int batchSize;
    @Value("${one-coupon.distribution.batch-outbox.lease-seconds:30}")
    private int leaseSeconds;
    @Value("${one-coupon.distribution.batch-outbox.published-check-seconds:15}")
    private int publishedCheckSeconds;

    private final String workerId = "batch-outbox-" + UUID.randomUUID();

    @Scheduled(fixedDelayString = "${one-coupon.distribution.batch-outbox.fixed-delay-ms:1000}")
    public void dispatchReadyEvents() {
        Date now = new Date();
        outboxMapper.resetExpiredProcessing(now);
        checkPublishedBatches(now);
        List<CouponTaskBatchOutboxDO> events = outboxMapper.selectReadyEvents(now, batchSize);
        for (CouponTaskBatchOutboxDO event : events) {
            Date leaseUntil = new Date(now.getTime() + leaseSeconds * 1000L);
            if (outboxMapper.claim(event.getId(), event.getShopNumber(), workerId, leaseUntil) == 1) {
                dispatchOne(event);
            }
        }
    }

    private void dispatchOne(CouponTaskBatchOutboxDO event) {
        try {
            batchReadyProducer.sendMessage(CouponTaskBatchReadyEvent.builder()
                    .batchId(event.getBatchId()).taskId(event.getTaskId()).shopNumber(event.getShopNumber())
                    .tail(false).build());
            // MQ 收到消息只代表“已唤醒”，不代表消费者已完成结算。先进入 PUBLISHED，
            // 由 checkPublishedBatches 观察批次终态；消费者组宕机/重试耗尽时仍能重新唤醒。
            outboxMapper.markPublished(event.getId(), event.getShopNumber(), workerId, nextCheckAt());
        } catch (Throwable ex) {
            int attempts = event.getAttempts() == null ? 0 : event.getAttempts();
            int nextAttempts = attempts + 1;
            Date retryAt = new Date(System.currentTimeMillis() + retryPolicy.nextDelaySeconds(attempts) * 1000L);
            outboxMapper.markRetry(event.getId(), event.getShopNumber(), workerId, retryAt, nextAttempts, truncate(ex));
            log.warn("批次 Outbox 投递失败，batchId={}, attempts={}, retryAt={}", event.getBatchId(), nextAttempts, retryAt, ex);
        }
    }

    private void checkPublishedBatches(Date now) {
        for (CouponTaskBatchOutboxDO event : outboxMapper.selectPublishedForCheck(now, batchSize)) {
            CouponTaskBatchDO batch = batchMapper.selectByIdAndShopNumber(event.getBatchId(), event.getShopNumber());
            if (batch == null || batch.getStatus() == CouponTaskBatchStatusEnum.SUCCESS.getStatus()
                    || batch.getStatus() == CouponTaskBatchStatusEnum.FAILED.getStatus()) {
                outboxMapper.markDoneFromPublished(event.getId(), event.getShopNumber());
                continue;
            }
            boolean noConsumerClaimed = batch.getStatus() == CouponTaskBatchStatusEnum.NEW.getStatus();
            boolean consumerLeaseExpired = batch.getStatus() == CouponTaskBatchStatusEnum.PROCESSING.getStatus()
                    && (batch.getLeaseExpireTime() == null || batch.getLeaseExpireTime().before(now));
            if (noConsumerClaimed || consumerLeaseExpired) {
                outboxMapper.requeuePublished(event.getId(), event.getShopNumber(), now);
            } else {
                outboxMapper.postponePublishedCheck(event.getId(), event.getShopNumber(), nextCheckAt());
            }
        }
    }

    private Date nextCheckAt() {
        return new Date(System.currentTimeMillis() + publishedCheckSeconds * 1000L);
    }

    private String truncate(Throwable ex) {
        String value = ex.getClass().getSimpleName() + ": " + ex.getMessage();
        return value.length() <= 500 ? value : value.substring(0, 500);
    }
}
