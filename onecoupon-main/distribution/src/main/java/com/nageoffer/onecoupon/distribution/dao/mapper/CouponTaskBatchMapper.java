package com.nageoffer.onecoupon.distribution.dao.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.nageoffer.onecoupon.distribution.dao.entity.CouponTaskBatchDO;
import org.apache.ibatis.annotations.Param;

import java.util.Date;
import java.util.List;

public interface CouponTaskBatchMapper extends BaseMapper<CouponTaskBatchDO> {

    /**
     * 抢占批次：NEW 或已过期 PROCESSING 才允许更新为 PROCESSING。
     * 返回 1 表示当前实例获得租约，返回 0 表示竞争失败。
     */
    int claim(@Param("batchId") Long batchId,
              @Param("shopNumber") Long shopNumber,
              @Param("owner") String owner,
              @Param("leaseExpireTime") Date leaseExpireTime);

    CouponTaskBatchDO selectForUpdate(@Param("batchId") Long batchId,
                                      @Param("shopNumber") Long shopNumber);

    CouponTaskBatchDO selectByIdAndShopNumber(@Param("batchId") Long batchId,
                                              @Param("shopNumber") Long shopNumber);

    CouponTaskBatchDO selectByTaskIdAndBatchNo(@Param("taskId") Long taskId,
                                                @Param("shopNumber") Long shopNumber,
                                                @Param("batchNo") Integer batchNo);

    int markSuccess(@Param("batchId") Long batchId,
                    @Param("shopNumber") Long shopNumber,
                    @Param("owner") String owner,
                    @Param("successCount") int successCount,
                    @Param("failCount") int failCount);

    int markFailed(@Param("batchId") Long batchId,
                   @Param("shopNumber") Long shopNumber,
                   @Param("owner") String owner);

    int countUnfinishedByTaskId(@Param("taskId") Long taskId,
                                @Param("shopNumber") Long shopNumber);
}
