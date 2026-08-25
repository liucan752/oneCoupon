package com.nageoffer.onecoupon.engine.dao.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

/** 结算状态变更产生的 Redis 用户券投影任务。按 user_id 与用户券同分片。 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@TableName("t_user_coupon_settlement_projection_outbox")
public class UserCouponSettlementProjectionOutboxDO {
    private Long id;
    private Long userId;
    private Long couponId;
    private Long couponTemplateId;
    private String action;
    private String requestId;
    private Date validEndTime;
    private String status;
    private Integer attempts;
    private Date retryAt;
    private String workerId;
    private Date leaseUntil;
    private String lastError;
    private Date createTime;
    private Date updateTime;
}
