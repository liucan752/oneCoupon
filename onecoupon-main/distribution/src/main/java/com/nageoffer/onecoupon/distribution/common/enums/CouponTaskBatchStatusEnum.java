package com.nageoffer.onecoupon.distribution.common.enums;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

/** 批次状态；PROCESSING 必须带租约，防止实例宕机后永远卡住。 */
@Getter
@RequiredArgsConstructor
public enum CouponTaskBatchStatusEnum {
    NEW(0),
    PROCESSING(1),
    SUCCESS(2),
    FAILED(3);

    private final int status;
}
