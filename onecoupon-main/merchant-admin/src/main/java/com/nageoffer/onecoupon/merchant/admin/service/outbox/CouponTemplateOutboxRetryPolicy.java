package com.nageoffer.onecoupon.merchant.admin.service.outbox;

import org.springframework.stereotype.Component;

/**
 * Outbox 派生任务的指数退避策略，避免 Redis/MQ 故障时形成忙循环。
 */
@Component
public class CouponTemplateOutboxRetryPolicy {

    private static final int MAX_DELAY_SECONDS = 60;

    public int nextDelaySeconds(int attempts) {
        int normalizedAttempts = Math.max(attempts, 0);
        if (normalizedAttempts >= 6) {
            return MAX_DELAY_SECONDS;
        }
        return Math.min(1 << normalizedAttempts, MAX_DELAY_SECONDS);
    }
}
