package com.nageoffer.onecoupon.distribution.common.enums;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

/** 批次就绪 Outbox 的生命周期状态。 */
@Getter
@RequiredArgsConstructor
public enum CouponTaskBatchOutboxStatusEnum {
    NEW("NEW"), PROCESSING("PROCESSING"), RETRY("RETRY"),
    PUBLISHED("PUBLISHED"), DONE("DONE");

    private final String code;
}
