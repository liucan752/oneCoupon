package com.nageoffer.onecoupon.engine.service.outbox;

import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.nageoffer.onecoupon.engine.common.constant.EngineRedisConstant;
import com.nageoffer.onecoupon.engine.common.enums.UserCouponStatusEnum;
import com.nageoffer.onecoupon.engine.dao.entity.UserCouponExpireOutboxDO;
import com.nageoffer.onecoupon.engine.dao.entity.UserCouponDO;
import com.nageoffer.onecoupon.engine.dao.mapper.UserCouponExpireOutboxMapper;
import com.nageoffer.onecoupon.engine.dao.mapper.UserCouponMapper;
import com.nageoffer.onecoupon.engine.mq.event.UserCouponDelayCloseEvent;
import com.nageoffer.onecoupon.engine.mq.producer.UserCouponDelayCloseProducer;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Component;

import java.util.Date;
import java.util.List;
import java.util.UUID;

/**
 * 用户券到期 Outbox 调度器。
 *
 * <p>一次投递包含两个幂等派生动作：以 validEndTime 写入 Redis ZSet，并发送延迟到期事件。
 * 任一步失败都会重试；Redis ZADD 和到期消费者的 CAS 更新都可安全重复执行。</p>
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class UserCouponExpireOutboxDispatcher {
    private final UserCouponExpireOutboxMapper outboxMapper;
    private final UserCouponMapper userCouponMapper;
    private final UserCouponDelayCloseProducer delayCloseProducer;
    private final StringRedisTemplate stringRedisTemplate;
    private final String workerId = "user-coupon-expire-outbox-" + UUID.randomUUID();

    @Value("${one-coupon.user-coupon-expire-outbox.batch-size:200}")
    private int batchSize;
    @Value("${one-coupon.user-coupon-expire-outbox.lease-seconds:30}")
    private int leaseSeconds;
    @Value("${one-coupon.user-coupon-expire-outbox.published-check-seconds:15}")
    private int publishedCheckSeconds;

    @Scheduled(fixedDelayString = "${one-coupon.user-coupon-expire-outbox.fixed-delay-ms:1000}")
    public void dispatchReadyEvents() {
        Date now = new Date();
        outboxMapper.resetExpiredProcessing(now);
        checkPublishedEvents(now);
        List<UserCouponExpireOutboxDO> events = outboxMapper.selectReadyEvents(now, batchSize);
        for (UserCouponExpireOutboxDO event : events) {
            Date leaseUntil = new Date(now.getTime() + leaseSeconds * 1000L);
            if (outboxMapper.claim(event.getId(), event.getUserId(), workerId, leaseUntil) == 1) {
                dispatchOne(event);
            }
        }
    }

    private void dispatchOne(UserCouponExpireOutboxDO event) {
        try {
            String key = String.format(EngineRedisConstant.USER_COUPON_TEMPLATE_LIST_KEY, event.getUserId());
            String member = event.getCouponTemplateId() + "_" + event.getUserCouponId();
            stringRedisTemplate.opsForZSet().add(key, member, event.getValidEndTime().getTime());

            delayCloseProducer.sendMessage(UserCouponDelayCloseEvent.builder()
                    .userId(String.valueOf(event.getUserId()))
                    .userCouponId(String.valueOf(event.getUserCouponId()))
                    .couponTemplateId(String.valueOf(event.getCouponTemplateId()))
                    .delayTime(event.getValidEndTime().getTime())
                    .build());

            // RocketMQ 接受只代表消息已进入 Broker；等到期消费者把数据库状态收敛后再 DONE。
            outboxMapper.markPublished(event.getId(), event.getUserId(), nextCheckAt(event), workerId);
        } catch (Throwable ex) {
            int attempts = event.getAttempts() == null ? 0 : event.getAttempts();
            int nextAttempts = attempts + 1;
            int delaySeconds = Math.min(300, 1 << Math.min(nextAttempts, 8));
            Date retryAt = new Date(System.currentTimeMillis() + delaySeconds * 1000L);
            outboxMapper.markRetry(event.getId(), event.getUserId(), workerId, retryAt, nextAttempts, truncate(ex));
            log.warn("用户券到期 Outbox 投递失败，userCouponId={}, attempts={}, retryAt={}",
                    event.getUserCouponId(), nextAttempts, retryAt, ex);
        }
    }

    private void checkPublishedEvents(Date now) {
        for (UserCouponExpireOutboxDO event : outboxMapper.selectPublishedForCheck(now, batchSize)) {
            UserCouponDO coupon = userCouponMapper.selectOne(Wrappers.lambdaQuery(UserCouponDO.class)
                    .eq(UserCouponDO::getId, event.getUserCouponId())
                    .eq(UserCouponDO::getUserId, event.getUserId()));
            if (coupon == null || coupon.getStatus() == UserCouponStatusEnum.EXPIRED.getCode()
                    || coupon.getStatus() == UserCouponStatusEnum.USED.getCode()
                    || coupon.getStatus() == UserCouponStatusEnum.REVOKED.getCode()) {
                outboxMapper.markDoneFromPublished(event.getId(), event.getUserId());
                continue;
            }
            if (coupon.getStatus() == UserCouponStatusEnum.UNUSED.getCode()
                    && !coupon.getValidEndTime().after(now)) {
                outboxMapper.requeuePublished(event.getId(), event.getUserId(), now);
            } else {
                outboxMapper.postponePublishedCheck(event.getId(), event.getUserId(), nextCheckAt(event));
            }
        }
    }

    private Date nextCheckAt(UserCouponExpireOutboxDO event) {
        // 到期前无需反复观察：延迟消息已被 Broker 持有。只在到期后留一小段宽限，
        // 用于检测消费者组异常、RocketMQ 达到最大重试次数等极端情况。
        long earliestCheck = System.currentTimeMillis() + publishedCheckSeconds * 1000L;
        long expireCheck = event.getValidEndTime().getTime() + publishedCheckSeconds * 1000L;
        return new Date(Math.max(earliestCheck, expireCheck));
    }

    private String truncate(Throwable ex) {
        String value = ex.getClass().getSimpleName() + ": " + ex.getMessage();
        return value.length() <= 500 ? value : value.substring(0, 500);
    }
}
