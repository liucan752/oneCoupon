package com.nageoffer.onecoupon.distribution.service.batch;

/** 批次 Outbox 的指数退避策略，最大 5 分钟，避免 MQ 故障时忙循环。 */
public class CouponTaskBatchOutboxRetryPolicy {
    public int nextDelaySeconds(int attempts) {
        if (attempts >= 8) {
            return 300;
        }
        int shift = Math.min(Math.max(attempts + 1, 1), 8);
        return 1 << shift;
    }
}
