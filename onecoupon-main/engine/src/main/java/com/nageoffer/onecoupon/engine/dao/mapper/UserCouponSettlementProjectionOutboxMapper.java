package com.nageoffer.onecoupon.engine.dao.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.nageoffer.onecoupon.engine.dao.entity.UserCouponSettlementProjectionOutboxDO;
import org.apache.ibatis.annotations.Param;

import java.util.Date;
import java.util.List;

public interface UserCouponSettlementProjectionOutboxMapper extends BaseMapper<UserCouponSettlementProjectionOutboxDO> {
    int insertIgnore(UserCouponSettlementProjectionOutboxDO outbox);
    List<UserCouponSettlementProjectionOutboxDO> selectReadyEvents(@Param("now") Date now, @Param("limit") int limit);
    int claim(@Param("id") Long id, @Param("userId") Long userId, @Param("workerId") String workerId, @Param("leaseUntil") Date leaseUntil);
    int resetExpiredProcessing(@Param("now") Date now);
    int markDone(@Param("id") Long id, @Param("userId") Long userId, @Param("workerId") String workerId);
    int markRetry(@Param("id") Long id, @Param("userId") Long userId, @Param("workerId") String workerId,
                  @Param("retryAt") Date retryAt, @Param("attempts") int attempts, @Param("lastError") String lastError);
}
