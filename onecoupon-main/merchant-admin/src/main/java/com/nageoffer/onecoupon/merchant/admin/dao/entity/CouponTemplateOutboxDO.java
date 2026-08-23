package com.nageoffer.onecoupon.merchant.admin.dao.entity;

import com.baomidou.mybatisplus.annotation.FieldFill;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@TableName("t_coupon_template_outbox")
public class CouponTemplateOutboxDO {

    private Long id;
    private Long shopNumber;
    private Long templateId;
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
