package com.nageoffer.onecoupon.distribution.service.batch;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

class CouponTaskBatchOutboxRetryPolicyTest {
    @Test
    void shouldUseBoundedExponentialBackoff() {
        CouponTaskBatchOutboxRetryPolicy policy = new CouponTaskBatchOutboxRetryPolicy();
        assertEquals(2, policy.nextDelaySeconds(0));
        assertEquals(4, policy.nextDelaySeconds(1));
        assertEquals(256, policy.nextDelaySeconds(7));
        assertEquals(300, policy.nextDelaySeconds(8));
        assertEquals(300, policy.nextDelaySeconds(99));
    }
}
