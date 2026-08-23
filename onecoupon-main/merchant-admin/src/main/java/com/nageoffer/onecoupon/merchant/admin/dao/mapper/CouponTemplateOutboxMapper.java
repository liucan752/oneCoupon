package com.nageoffer.onecoupon.merchant.admin.dao.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.nageoffer.onecoupon.merchant.admin.dao.entity.CouponTemplateOutboxDO;
import org.apache.ibatis.annotations.Param;

import java.util.Date;
import java.util.List;

public interface CouponTemplateOutboxMapper extends BaseMapper<CouponTemplateOutboxDO> {

    List<CouponTemplateOutboxDO> selectReadyEvents(@Param("now") Date now, @Param("limit") int limit);

    int claim(@Param("id") Long id, @Param("shopNumber") Long shopNumber, @Param("workerId") String workerId,
              @Param("leaseUntil") Date leaseUntil);

    int resetExpiredProcessing(@Param("now") Date now);

    int markDone(@Param("id") Long id, @Param("shopNumber") Long shopNumber, @Param("workerId") String workerId);

    int markRetry(@Param("id") Long id, @Param("shopNumber") Long shopNumber, @Param("workerId") String workerId,
                  @Param("retryAt") Date retryAt, @Param("attempts") int attempts,
                  @Param("lastError") String lastError);
}
