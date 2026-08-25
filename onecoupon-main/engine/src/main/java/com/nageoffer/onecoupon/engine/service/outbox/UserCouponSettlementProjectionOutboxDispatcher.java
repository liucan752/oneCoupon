package com.nageoffer.onecoupon.engine.service.outbox;

import com.nageoffer.onecoupon.engine.common.constant.EngineRedisConstant;
import com.nageoffer.onecoupon.engine.dao.entity.UserCouponSettlementProjectionOutboxDO;
import com.nageoffer.onecoupon.engine.dao.mapper.UserCouponSettlementProjectionOutboxMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.util.Date;
import java.util.List;
import java.util.UUID;

/** 结算后 Redis 用户券投影的可靠收敛器。 */
@Slf4j
@Component
@RequiredArgsConstructor
public class UserCouponSettlementProjectionOutboxDispatcher {
    private final UserCouponSettlementProjectionOutboxMapper mapper;
    private final StringRedisTemplate redisTemplate;
    private final String workerId = "coupon-settlement-projection-" + UUID.randomUUID();

    @Value("${one-coupon.user-coupon-settlement-projection-outbox.batch-size:200}")
    private int batchSize;
    @Value("${one-coupon.user-coupon-settlement-projection-outbox.lease-seconds:30}")
    private int leaseSeconds;

    @Scheduled(fixedDelayString = "${one-coupon.user-coupon-settlement-projection-outbox.fixed-delay-ms:1000}")
    public void dispatch() {
        Date now = new Date();
        mapper.resetExpiredProcessing(now);
        List<UserCouponSettlementProjectionOutboxDO> events = mapper.selectReadyEvents(now, batchSize);
        for (UserCouponSettlementProjectionOutboxDO event : events) {
            Date leaseUntil = new Date(now.getTime() + leaseSeconds * 1000L);
            if (mapper.claim(event.getId(), event.getUserId(), workerId, leaseUntil) == 1) {
                dispatchOne(event);
            }
        }
    }

    private void dispatchOne(UserCouponSettlementProjectionOutboxDO event) {
        try {
            String key = String.format(EngineRedisConstant.USER_COUPON_TEMPLATE_LIST_KEY, event.getUserId());
            String member = event.getCouponTemplateId() + "_" + event.getCouponId();
            if ("ADD".equals(event.getAction())) {
                redisTemplate.opsForZSet().add(key, member, event.getValidEndTime().getTime());
            } else {
                redisTemplate.opsForZSet().remove(key, member);
            }
            mapper.markDone(event.getId(), event.getUserId(), workerId);
        } catch (Throwable ex) {
            int attempts = event.getAttempts() == null ? 0 : event.getAttempts();
            int nextAttempts = attempts + 1;
            int delaySeconds = Math.min(300, 1 << Math.min(nextAttempts, 8));
            mapper.markRetry(event.getId(), event.getUserId(), workerId,
                    new Date(System.currentTimeMillis() + delaySeconds * 1000L), nextAttempts, truncate(ex));
            log.warn("结算 Redis 投影任务失败，outboxId={}", event.getId(), ex);
        }
    }

    private String truncate(Throwable ex) {
        String value = ex.getClass().getSimpleName() + ": " + ex.getMessage();
        return value.length() <= 500 ? value : value.substring(0, 500);
    }
}
