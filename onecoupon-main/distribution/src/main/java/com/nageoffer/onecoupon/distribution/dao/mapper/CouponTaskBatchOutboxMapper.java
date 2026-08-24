package com.nageoffer.onecoupon.distribution.dao.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.nageoffer.onecoupon.distribution.dao.entity.CouponTaskBatchOutboxDO;
import org.apache.ibatis.annotations.Param;

import java.util.Date;
import java.util.List;

public interface CouponTaskBatchOutboxMapper extends BaseMapper<CouponTaskBatchOutboxDO> {
    int insertIgnore(CouponTaskBatchOutboxDO outbox);
    List<CouponTaskBatchOutboxDO> selectReadyEvents(@Param("now") Date now, @Param("limit") int limit);
    int claim(@Param("id") Long id, @Param("shopNumber") Long shopNumber,
              @Param("workerId") String workerId, @Param("leaseUntil") Date leaseUntil);
    int resetExpiredProcessing(@Param("now") Date now);
    int markPublished(@Param("id") Long id, @Param("shopNumber") Long shopNumber,
                      @Param("workerId") String workerId, @Param("nextCheckAt") Date nextCheckAt);
    List<CouponTaskBatchOutboxDO> selectPublishedForCheck(@Param("now") Date now, @Param("limit") int limit);
    int markDoneFromPublished(@Param("id") Long id, @Param("shopNumber") Long shopNumber);
    int requeuePublished(@Param("id") Long id, @Param("shopNumber") Long shopNumber, @Param("retryAt") Date retryAt);
    int postponePublishedCheck(@Param("id") Long id, @Param("shopNumber") Long shopNumber,
                               @Param("nextCheckAt") Date nextCheckAt);
    int markRetry(@Param("id") Long id, @Param("shopNumber") Long shopNumber,
                  @Param("workerId") String workerId, @Param("retryAt") Date retryAt,
                  @Param("attempts") int attempts, @Param("lastError") String lastError);
}
