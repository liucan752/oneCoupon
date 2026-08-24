package com.nageoffer.onecoupon.distribution.dao.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.nageoffer.onecoupon.distribution.dao.entity.UserCouponExpireOutboxDO;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface UserCouponExpireOutboxMapper extends BaseMapper<UserCouponExpireOutboxDO> {
    int insertIgnoreBatch(@Param("events") List<UserCouponExpireOutboxDO> events);
}
