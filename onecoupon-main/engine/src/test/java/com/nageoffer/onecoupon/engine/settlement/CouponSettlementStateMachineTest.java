package com.nageoffer.onecoupon.engine.settlement;

import com.nageoffer.onecoupon.engine.common.enums.UserCouponStatusEnum;
import com.nageoffer.onecoupon.engine.service.settlement.CouponSettlementStateMachine;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

class CouponSettlementStateMachineTest {

    @Test
    void paymentMovesLockedCouponToPaidAndUsed() {
        assertEquals(CouponSettlementStateMachine.Decision.APPLIED,
                CouponSettlementStateMachine.payment(0, UserCouponStatusEnum.LOCKING.getCode(), null, "pay-1"));
    }

    @Test
    void duplicatePaymentWithSameBusinessIdIsIdempotent() {
        assertEquals(CouponSettlementStateMachine.Decision.IDEMPOTENT,
                CouponSettlementStateMachine.payment(2, UserCouponStatusEnum.USED.getCode(), "pay-1", "pay-1"));
    }

    @Test
    void duplicatePaymentWithDifferentBusinessIdIsRejected() {
        assertEquals(CouponSettlementStateMachine.Decision.REJECTED,
                CouponSettlementStateMachine.payment(2, UserCouponStatusEnum.USED.getCode(), "pay-1", "pay-2"));
    }

    @Test
    void refundReturnsUsedCouponToUnused() {
        assertEquals(CouponSettlementStateMachine.Decision.APPLIED,
                CouponSettlementStateMachine.refund(2, UserCouponStatusEnum.USED.getCode(), null, "refund-1"));
    }

    @Test
    void duplicateRefundOfExpiredCouponIsIdempotent() {
        assertEquals(CouponSettlementStateMachine.Decision.IDEMPOTENT,
                CouponSettlementStateMachine.refund(3, UserCouponStatusEnum.EXPIRED.getCode(), "refund-1", "refund-1"));
    }

    @Test
    void cancellationReturnsLockedCouponToUnused() {
        assertEquals(CouponSettlementStateMachine.Decision.APPLIED,
                CouponSettlementStateMachine.cancel(0, UserCouponStatusEnum.LOCKING.getCode()));
    }
}
