package com.nageoffer.onecoupon.distribution.service.batch;

import cn.hutool.core.util.IdUtil;
import com.nageoffer.onecoupon.distribution.common.enums.CouponTaskBatchStatusEnum;
import com.nageoffer.onecoupon.distribution.common.enums.CouponTaskBatchOutboxStatusEnum;
import com.nageoffer.onecoupon.distribution.common.enums.CouponTaskItemStatusEnum;
import com.nageoffer.onecoupon.distribution.dao.entity.CouponTaskBatchDO;
import com.nageoffer.onecoupon.distribution.dao.entity.CouponTaskBatchOutboxDO;
import com.nageoffer.onecoupon.distribution.dao.entity.CouponTaskDO;
import com.nageoffer.onecoupon.distribution.dao.entity.CouponTaskItemDO;
import com.nageoffer.onecoupon.distribution.dao.mapper.CouponTaskBatchMapper;
import com.nageoffer.onecoupon.distribution.dao.mapper.CouponTaskBatchOutboxMapper;
import com.nageoffer.onecoupon.distribution.dao.mapper.CouponTaskItemMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;

/**
 * 批次持久化写入组件 CouponTaskBatchWriter
 *
 * 职责：将Excel解析出来的一批用户明细，原子固化：【多条发放明细 item + 一条分发批次 batch】
 * 核心保障：明细和批次在同一个本地事务内写入，保证一致性
 *
 * 设计要点：
 * 1. 先查询是否已存在该批次（taskId + shopNumber + batchNo），防止重复生成批次，实现幂等
 * 2. 事务内：批量写入明细 item → 写入批次 batch → 写入批次就绪 Outbox。
 * 3. Outbox 记录与批次同事务提交；调度器只扫描 Outbox，消除“批次已提交、MQ 没发出”的窗口。
 */
@Service
@RequiredArgsConstructor
public class CouponTaskBatchWriter {

    // 用户发放明细Mapper（t_coupon_task_item）
    private final CouponTaskItemMapper couponTaskItemMapper;
    // 分发批次Mapper（t_coupon_task_batch）
    private final CouponTaskBatchMapper couponTaskBatchMapper;
    // 批次就绪事件 Outbox Mapper
    private final CouponTaskBatchOutboxMapper couponTaskBatchOutboxMapper;

    /**
     * 持久化一批明细并创建对应的分发批次记录
     * @param task 批量发券主任务
     * @param sourceItems Excel解析得到的一批原始用户明细
     * @param batchNo 当前子批次编号（同一个task下自增）
     * @return 持久化完成后的批次DO
     */
    @Transactional(rollbackFor = Exception.class)
    public CouponTaskBatchDO persist(CouponTaskDO task, List<CouponTaskItemDO> sourceItems, int batchNo) {
        // 幂等校验：根据 taskId + 店铺编号 + 批次号 查询批次是否已经存在
        // 应对场景：MQ重试、上层flush重复调用persist，避免重复入库明细和批次
        CouponTaskBatchDO existed = couponTaskBatchMapper.selectByTaskIdAndBatchNo(
                task.getId(), task.getShopNumber(), batchNo);
        if (existed != null) {
            return existed;
        }

        // 雪花算法生成全局唯一batch主键
        long batchId = IdUtil.getSnowflakeNextId();
        Date now = new Date();

        // 加工明细：补充主键、批次ID、店铺、初始状态、时间等数据库字段
        List<CouponTaskItemDO> items = sourceItems.stream()
                .map(item -> item.toBuilder()
                        .id(IdUtil.getSnowflakeNextId())       // 明细唯一主键
                        .taskId(task.getId())                  // 归属主任务
                        .batchId(batchId)                      // 归属当前子批次，关联batch
                        .shopNumber(task.getShopNumber())      // 归属店铺
                        .status(CouponTaskItemStatusEnum.NEW.getStatus()) // 明细初始状态：待发放
                        .createTime(now)
                        .updateTime(now)
                        .build())
                .toList();

        // 【写入顺序：先明细，后批次】同一事务内执行
        // 好处：MQ消费端拿到batchId去查明细时，明细一定已经入库；防止批次存在但明细还未写入
        couponTaskItemMapper.insertIgnoreBatch(items);

        // 组装批次记录：记录预期发放总数，成功/失败计数初始为0，状态NEW待消费
        CouponTaskBatchDO batch = CouponTaskBatchDO.builder()
                .id(batchId)
                .taskId(task.getId())
                .shopNumber(task.getShopNumber())
                .couponTemplateId(task.getCouponTemplateId())
                .batchNo(batchNo)
                .expectedCount(items.size())  // 本批次预期发放用户总数
                .successCount(0)              // 发放成功条数，后续消费时更新
                .failCount(0)                 // 发放失败条数，后续消费时更新
                .status(CouponTaskBatchStatusEnum.NEW.getStatus()) // 批次初始状态：待处理
                .createTime(now)
                .updateTime(now)
                .build();
        couponTaskBatchMapper.insert(batch);

        // 在同一个本地事务中写入“批次就绪”Outbox。此处绝不直接发送 MQ：
        // 事务回滚时 Outbox 一并回滚；事务提交后即使服务宕机，调度器也会持续扫描并投递。
        couponTaskBatchOutboxMapper.insertIgnore(CouponTaskBatchOutboxDO.builder()
                .id(IdUtil.getSnowflakeNextId())
                .batchId(batchId)
                .taskId(task.getId())
                .shopNumber(task.getShopNumber())
                .eventType("BATCH_READY")
                .status(CouponTaskBatchOutboxStatusEnum.NEW.getCode())
                .retryAt(now)
                .attempts(0)
                .createTime(now)
                .updateTime(now)
                .build());

        // 返回已入库的批次对象；MQ 由 Outbox 调度器异步可靠发送。
        return batch;
    }
}
