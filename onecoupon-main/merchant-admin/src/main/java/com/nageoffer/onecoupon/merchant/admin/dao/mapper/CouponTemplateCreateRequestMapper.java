package com.nageoffer.onecoupon.merchant.admin.dao.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.nageoffer.onecoupon.merchant.admin.dao.entity.CouponTemplateCreateRequestDO;
import org.apache.ibatis.annotations.Param;

public interface CouponTemplateCreateRequestMapper extends BaseMapper<CouponTemplateCreateRequestDO> {

    int insertOrIgnore(CouponTemplateCreateRequestDO request);

    CouponTemplateCreateRequestDO selectByShopNumberAndRequestId(@Param("shopNumber") Long shopNumber,
                                                                  @Param("requestId") String requestId);

    int bindTemplateId(@Param("id") Long id, @Param("shopNumber") Long shopNumber,
                       @Param("templateId") Long templateId);
}
