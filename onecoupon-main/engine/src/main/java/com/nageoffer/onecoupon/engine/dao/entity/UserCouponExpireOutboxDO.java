package com.nageoffer.onecoupon.engine.dao.entity;

import com.baomidou.mybatisplus.annotation.FieldFill;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

/**
 * 用户优惠券到期事件 Outbox。
 * user_id 与 t_user_coupon 使用同一个分片键，保证写券和写 Outbox 可以在本地事务中完成。
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@TableName("t_user_coupon_expire_outbox")
public class UserCouponExpireOutboxDO {
    private Long id;
    private Long userCouponId;
    private Long userId;
    private Long couponTemplateId;
    private Date validEndTime;
    private String eventType;
    private String status;
    private Date retryAt;
    private Integer attempts;
    private String workerId;
    private Date leaseUntil;
    private String lastError;
    @TableField(fill = FieldFill.INSERT)
    private Date createTime;
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private Date updateTime;
}
