package com.nageoffer.onecoupon.engine.dao.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.nageoffer.onecoupon.engine.dao.entity.UserCouponExpireOutboxDO;
import org.apache.ibatis.annotations.Param;

import java.util.Date;
import java.util.List;

public interface UserCouponExpireOutboxMapper extends BaseMapper<UserCouponExpireOutboxDO> {
    List<UserCouponExpireOutboxDO> selectReadyEvents(@Param("now") Date now, @Param("limit") int limit);
    int claim(@Param("id") Long id, @Param("userId") Long userId,
              @Param("workerId") String workerId, @Param("leaseUntil") Date leaseUntil);
    int resetExpiredProcessing(@Param("now") Date now);
    int markPublished(@Param("id") Long id, @Param("userId") Long userId,
                      @Param("nextCheckAt") Date nextCheckAt, @Param("workerId") String workerId);
    List<UserCouponExpireOutboxDO> selectPublishedForCheck(@Param("now") Date now, @Param("limit") int limit);
    int markDoneFromPublished(@Param("id") Long id, @Param("userId") Long userId);
    int requeuePublished(@Param("id") Long id, @Param("userId") Long userId, @Param("retryAt") Date retryAt);
    int postponePublishedCheck(@Param("id") Long id, @Param("userId") Long userId,
                               @Param("nextCheckAt") Date nextCheckAt);
    int markRetry(@Param("id") Long id, @Param("userId") Long userId, @Param("workerId") String workerId,
                  @Param("retryAt") Date retryAt, @Param("attempts") int attempts,
                  @Param("lastError") String lastError);
}
