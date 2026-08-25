package com.nageoffer.onecoupon.engine.service.settlement;

import java.util.Objects;

/**
 * Demo 结算状态机的纯函数契约。
 * 数据库事务和 Redis 投影由上层服务负责，这里只决定状态迁移结果。
 */
public final class CouponSettlementStateMachine {

    private CouponSettlementStateMachine() {
    }

    public enum Decision {
        APPLIED,
        IDEMPOTENT,
        REJECTED
    }

    public static Decision payment(int settlementStatus, int couponStatus,
                                   String recordedPaymentId, String paymentId) {
        if (settlementStatus == 0 && couponStatus == 1) {
            return Decision.APPLIED;
        }
        if (settlementStatus == 2 && couponStatus == 2
                && Objects.equals(recordedPaymentId, paymentId)) {
            return Decision.IDEMPOTENT;
        }
        return Decision.REJECTED;
    }

    public static Decision refund(int settlementStatus, int couponStatus,
                                  String recordedRefundId, String refundId) {
        if (settlementStatus == 2 && couponStatus == 2) {
            return Decision.APPLIED;
        }
        if (settlementStatus == 3 && (couponStatus == 0 || couponStatus == 3)
                && Objects.equals(recordedRefundId, refundId)) {
            return Decision.IDEMPOTENT;
        }
        return Decision.REJECTED;
    }

    public static Decision cancel(int settlementStatus, int couponStatus) {
        if (settlementStatus == 0 && couponStatus == 1) {
            return Decision.APPLIED;
        }
        if (settlementStatus == 1 && couponStatus == 0) {
            return Decision.IDEMPOTENT;
        }
        return Decision.REJECTED;
    }
}
