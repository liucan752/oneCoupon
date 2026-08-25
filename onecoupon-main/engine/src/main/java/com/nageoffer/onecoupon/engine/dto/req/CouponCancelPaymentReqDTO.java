package com.nageoffer.onecoupon.engine.dto.req;

import lombok.Data;

/** Demo 订单取消/支付超时回退请求。 */
@Data
public class CouponCancelPaymentReqDTO {
    private Long couponId;
    private Long orderId;
    private String requestId;
}
