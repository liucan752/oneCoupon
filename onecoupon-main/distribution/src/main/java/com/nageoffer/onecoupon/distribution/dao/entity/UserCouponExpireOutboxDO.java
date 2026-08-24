package com.nageoffer.onecoupon.distribution.dao.entity;

import com.baomidou.mybatisplus.annotation.FieldFill;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

/** 分发服务写用户券时同步写入的到期事件 Outbox。 */
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
