package com.nageoffer.onecoupon.distribution.dao.entity;

import com.baomidou.mybatisplus.annotation.FieldFill;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

/**
 * 批次就绪事件 Outbox。
 * 批次、明细和 Outbox 使用 shopNumber 同库，能够在一个本地事务中提交。
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@TableName("t_coupon_task_batch_outbox")
public class CouponTaskBatchOutboxDO {
    private Long id;
    private Long batchId;
    private Long taskId;
    private Long shopNumber;
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
