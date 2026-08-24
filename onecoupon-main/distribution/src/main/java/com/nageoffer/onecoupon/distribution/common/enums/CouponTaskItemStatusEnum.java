package com.nageoffer.onecoupon.distribution.common.enums;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

/** 任务明细状态：状态只允许向前推进，PROCESSING 超时后可被租约回收为可重试状态。 */
@Getter
@RequiredArgsConstructor
public enum CouponTaskItemStatusEnum {
    NEW(0),
    PROCESSING(1),
    SUCCESS(2),
    FAILED(3);

    private final int status;
}
