package com.nageoffer.onecoupon.merchant.admin.service.outbox;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

class CouponTemplateOutboxRetryPolicyTest {

    @Test
    void shouldIncreaseDelayExponentiallyAndCapAtOneMinute() {
        CouponTemplateOutboxRetryPolicy retryPolicy = new CouponTemplateOutboxRetryPolicy();

        assertEquals(1, retryPolicy.nextDelaySeconds(0));
        assertEquals(8, retryPolicy.nextDelaySeconds(3));
        assertEquals(60, retryPolicy.nextDelaySeconds(10));
    }
}
