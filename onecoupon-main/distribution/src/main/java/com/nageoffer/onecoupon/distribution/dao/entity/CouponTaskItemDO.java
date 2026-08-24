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
 * Excel 一行的持久化快照。
 *
 * <p>旧实现把行数据放在 Redis Set 中，Redis 数据丢失后无法知道哪些行已经处理。
 * 新实现先把行写入 MySQL，再投递批次消息，因此 MQ 只负责唤醒处理，不再承担唯一数据载体的职责。</p>
 */
@Data
@Builder(toBuilder = true)
@NoArgsConstructor
@AllArgsConstructor
@TableName("t_coupon_task_item")
public class CouponTaskItemDO {

    private Long id;
    private Long taskId;
    private Long batchId;
    /** 与模板一致的分片键；任务明细、批次和模板需要落到同一物理库。 */
    private Long shopNumber;
    private Integer rowNum;
    /** 保留原始字符串，非法用户 ID 可以落失败表而不是让整个 Excel 解析失败。 */
    private String userId;
    private String phone;
    private String mail;
    private Integer status;
    private Long couponId;
    private String failReason;

    @TableField(fill = FieldFill.INSERT)
    private Date createTime;

    @TableField(fill = FieldFill.INSERT_UPDATE)
    private Date updateTime;
}
