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
 * 将事务内写入的模板创建事件最终投递到 Redis、Bloom 和 RocketMQ。
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class CouponTemplateOutboxDispatcher {

    private final CouponTemplateOutboxMapper couponTemplateOutboxMapper;
    private final CouponTemplateMapper couponTemplateMapper;
    private final CouponTemplateCacheWriter couponTemplateCacheWriter;
    private final CouponTemplateDelayExecuteStatusProducer couponTemplateDelayExecuteStatusProducer;
    private final RBloomFilter<String> couponTemplateQueryBloomFilter;
    private final CouponTemplateOutboxRetryPolicy retryPolicy;

    @Value("${one-coupon.template-outbox.batch-size:100}")
    private int batchSize;

    @Value("${one-coupon.template-outbox.lease-seconds:30}")
    private int leaseSeconds;

    private final String workerId = UUID.randomUUID().toString();

    @Scheduled(fixedDelayString = "${one-coupon.template-outbox.fixed-delay-ms:1000}")
    public void dispatchReadyEvents() {
        Date now = new Date();
        couponTemplateOutboxMapper.resetExpiredProcessing(now);
        List<CouponTemplateOutboxDO> events = couponTemplateOutboxMapper.selectReadyEvents(now, batchSize);
        for (CouponTemplateOutboxDO event : events) {
            Date leaseUntil = new Date(now.getTime() + leaseSeconds * 1000L);
            if (couponTemplateOutboxMapper.claim(event.getId(), event.getShopNumber(), workerId, leaseUntil) == 1) {
                dispatch(event);
            }
        }
    }

    private void dispatch(CouponTemplateOutboxDO event) {
        try {
            CouponTemplateDO template = couponTemplateMapper.selectOne(Wrappers.lambdaQuery(CouponTemplateDO.class)
                    .eq(CouponTemplateDO::getShopNumber, event.getShopNumber())
                    .eq(CouponTemplateDO::getId, event.getTemplateId()));
            if (template == null || CouponTemplateStatusEnum.ENDED.getStatus() == template.getStatus()) {
                couponTemplateOutboxMapper.markDone(event.getId(), event.getShopNumber(), workerId);
                return;
            }
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

            couponTemplateCacheWriter.write(template);
            couponTemplateQueryBloomFilter.add(String.valueOf(template.getId()));
            couponTemplateDelayExecuteStatusProducer.sendMessage(CouponTemplateDelayEvent.builder()
                    .shopNumber(template.getShopNumber())
                    .couponTemplateId(template.getId())
                    .delayTime(template.getValidEndTime().getTime())
                    .build());
            couponTemplateOutboxMapper.markDone(event.getId(), event.getShopNumber(), workerId);
        } catch (Throwable throwable) {
            int attempts = event.getAttempts() + 1;
            int delaySeconds = retryPolicy.nextDelaySeconds(event.getAttempts());
            Date retryAt = new Date(System.currentTimeMillis() + delaySeconds * 1000L);
            couponTemplateOutboxMapper.markRetry(event.getId(), event.getShopNumber(), workerId, retryAt, attempts,
                    truncateError(throwable));
            log.warn("优惠券模板 Outbox 投递失败，eventId={}, shopNumber={}, attempts={}, retryAt={}",
                    event.getId(), event.getShopNumber(), attempts, retryAt, throwable);
        }
    }

    private String truncateError(Throwable throwable) {
        String message = throwable.getClass().getSimpleName() + ": " + throwable.getMessage();
        return message.length() > 500 ? message.substring(0, 500) : message;
    }
}
