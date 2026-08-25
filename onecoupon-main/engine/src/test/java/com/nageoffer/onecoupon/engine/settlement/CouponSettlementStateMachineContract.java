package com.nageoffer.onecoupon.engine.settlement;

import com.nageoffer.onecoupon.engine.service.settlement.CouponSettlementStateMachine;

/**
 * 无 Maven 依赖时可用的状态机契约验证入口。
 */
public final class CouponSettlementStateMachineContract {

    public static void main(String[] args) {
        assertDecision(CouponSettlementStateMachine.Decision.APPLIED,
                CouponSettlementStateMachine.payment(0, 1, null, "pay-1"));
        assertDecision(CouponSettlementStateMachine.Decision.IDEMPOTENT,
                CouponSettlementStateMachine.payment(2, 2, "pay-1", "pay-1"));
        assertDecision(CouponSettlementStateMachine.Decision.REJECTED,
                CouponSettlementStateMachine.payment(2, 2, "pay-1", "pay-2"));
        assertDecision(CouponSettlementStateMachine.Decision.APPLIED,
                CouponSettlementStateMachine.refund(2, 2, null, "refund-1"));
        assertDecision(CouponSettlementStateMachine.Decision.IDEMPOTENT,
                CouponSettlementStateMachine.refund(3, 3, "refund-1", "refund-1"));
        assertDecision(CouponSettlementStateMachine.Decision.APPLIED,
                CouponSettlementStateMachine.cancel(0, 1));
    }

    private static void assertDecision(CouponSettlementStateMachine.Decision expected,
                                       CouponSettlementStateMachine.Decision actual) {
        if (expected != actual) {
            throw new AssertionError("Expected " + expected + " but got " + actual);
        }
    }
}
