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
 * 可重试的分发批次 DO（t_coupon_task_batch）
 *
 * 业务说明：
 * 一个批量发券主任务（CouponTaskDO）会拆分为多个分发子批次，每个子批次管理一批用户发券明细。
 * 核心分布式能力：
 * 1. batchId（id字段）作为MQ消息业务幂等键，防止重复消费；
 * 2. leaseOwner + leaseExpireTime 实现基于数据库CAS的租约抢占机制，解决多实例并发抢占、消费者进程崩溃卡死问题；
 * 3. 唯一约束 (task_id, batch_no)，防止Excel重复解析、上层重试导致重复创建分发批次；
 * 4. expectedCount / successCount / failCount 用于批次完成后的对账校验，确认本批次所有明细处理完毕；
 * 5. shopNumber 作为分库分表路由字段，所有查询、更新必须携带，隔离不同店铺数据。
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@TableName("t_coupon_task_batch")
public class CouponTaskBatchDO {

    /**
     * 批次主键ID，雪花算法生成
     * 同时作为批次MQ消息的业务幂等键；相同batchId重复消费时，通过CAS租约抢占保证仅有一个实例执行
     */
    private Long id;

    /**
     * 所属批量分发主任务ID（关联 t_coupon_task 主键）
     * 一个taskId下可以拆分多个batchNo子批次；主任务是否完成依赖统计该task下所有批次是否到达终态
     */
    private Long taskId;

    /**
     * 店铺编号，分库分表路由键
     * 所有Mapper查询/更新操作必须携带该字段，防止跨店铺越权访问、路由到错误分片
     */
    private Long shopNumber;

    /**
     * 发放优惠券模板ID（关联优惠券模板表）
     * 发券结算阶段依靠该ID查询模板规则、库存并执行库存扣减
     */
    private Long couponTemplateId;

    /**
     * 当前任务内的逻辑批次序号，如 1、2、3
     * 数据库唯一联合约束：(task_id, batch_no)，避免重复创建同一逻辑批次
     * 仅代表拆分顺序，不保证MQ严格顺序消费
     */
    private Integer batchNo;

    /**
     * 本批次预期待处理明细总数
     * 值等于 t_coupon_task_item 中归属该batchId的记录行数，用于批次结束对账校验
     */
    private Integer expectedCount;

    /**
     * 本批次实际发券成功明细数量
     * 批次处理收尾时统计更新；successCount + failCount 应等于 expectedCount
     */
    private Integer successCount;

    /**
     * 本批次实际发券失败明细数量
     * 失败原因包含：用户ID非法、重复领取、库存不足、参数异常等
     */
    private Integer failCount;

    /**
     * 批次状态码：0-NEW，1-PROCESSING，2-SUCCESS，3-FAIL
     * SUCCESS / FAIL 为终态，到达终态后不再重新抢占处理
     */
    private Integer status;

    /**
     * 租约持有者：当前抢占到批次处理权的消费者实例标识（示例格式：batch-consumer-UUID）
     * CAS抢占时写入，用于区分哪个实例持有当前批次执行权
     */
    private String leaseOwner;

    /**
     * 租约过期绝对时间
     * 如果持有租约的实例在过期前未完成处理、未续租，其他消费者实例可重新抢占该批次，解决进程宕机卡死问题
     */
    private Date leaseExpireTime;

    /**
     * 记录创建时间，MyBatis-Plus自动填充【插入时】
     */
    @TableField(fill = FieldFill.INSERT)
    private Date createTime;

    /**
     * 记录更新时间，MyBatis-Plus自动填充【插入 & 更新时】
     * 批次新增、租约抢占、续租、状态流转成功/失败均会更新此字段
     */
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private Date updateTime;
}
