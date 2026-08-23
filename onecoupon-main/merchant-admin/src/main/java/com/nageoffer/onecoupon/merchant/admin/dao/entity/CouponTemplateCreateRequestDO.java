package com.nageoffer.onecoupon.merchant.admin.dao.entity;

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
@TableName("t_coupon_template_create_request")
public class CouponTemplateCreateRequestDO {

    private Long id;
    private Long shopNumber;
    private String requestId;
    private String requestHash;
    private Long templateId;
    private String status;
    private Date createTime;
    private Date updateTime;
}
