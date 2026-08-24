package com.nageoffer.onecoupon.distribution.dao.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.nageoffer.onecoupon.distribution.dao.entity.CouponTaskItemDO;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface CouponTaskItemMapper extends BaseMapper<CouponTaskItemDO> {

    /**
     * 批量插入 Excel 行；唯一键冲突时忽略，保证任务 MQ 重试不会产生重复行。
     */
    int insertIgnoreBatch(@Param("items") List<CouponTaskItemDO> items);

    /** 查询批次中仍待处理的明细，排序保证重试结果稳定。 */
    List<CouponTaskItemDO> selectPendingByBatchId(@Param("batchId") Long batchId,
                                                   @Param("shopNumber") Long shopNumber);

    /** 只更新仍属于本次租约的明细，避免旧实例覆盖新实例结果。 */
    int markSuccess(@Param("batchId") Long batchId,
                    @Param("shopNumber") Long shopNumber,
                    @Param("items") List<CouponTaskItemDO> items);

    int markFailed(@Param("batchId") Long batchId,
                   @Param("shopNumber") Long shopNumber,
                   @Param("itemIds") List<Long> itemIds,
                   @Param("reason") String reason);

    int countByBatchIdAndStatus(@Param("batchId") Long batchId,
                                @Param("shopNumber") Long shopNumber,
                                @Param("status") Integer status);
}
