package com.nageoffer.onecoupon.distribution.service.batch;

import com.nageoffer.onecoupon.distribution.dao.entity.CouponTaskDO;
import com.nageoffer.onecoupon.distribution.dao.mapper.CouponTaskBatchMapper;
import com.nageoffer.onecoupon.distribution.dao.mapper.CouponTaskMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

/**
 * 优惠券批量分发【任务完成屏障】
 *
 * 核心作用：控制整个批量发券任务什么时候才算真正完成，标记为 SUCCESS
 * 业务约束：整个批量发放任务，必须同时满足两个前提，才能判定完成
 * 1）Excel导入的所有用户明细已经持久化完成（前置阶段）
 * 2）任务拆分出来的【所有分发批次】都流转到终态（成功/失败，不再处理）
 *
 * 解决 MQ 经典问题：RocketMQ 消息乱序、消息重复、最后一批消息延迟到达，
 * 避免某一个批次先完成就直接把整个大任务标记成功，造成状态提前完成（数据不一致）
 *
 * 调用时机：每一个分发批次执行完毕（成功/失败）后，都调用本组件 tryFinish，尝试闭合整个任务
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class CouponTaskFinalizer {

    // 分发批次Mapper：查询该任务下还有多少未完成的子批次
    private final CouponTaskBatchMapper couponTaskBatchMapper;
    // 主任务Mapper：更新主任务状态为成功
    private final CouponTaskMapper couponTaskMapper;

    /**
     * 尝试闭合整个批量发券任务（重载方法，传入完整task对象）
     * @param task 优惠券批量发放主任务DO（coupon_task 主表记录）
     */
    public void tryFinish(CouponTaskDO task) {
        // 查询：当前这个task下，状态【未完成】的子批次一共有多少个
        int unfinished = couponTaskBatchMapper.countUnfinishedByTaskId(task.getId(), task.getShopNumber());

        // 还有子批次在处理中，不满足完成条件，直接返回，等待下一次批次完成后再来校验
        if (unfinished != 0) {
            return;
        }

        // 所有子批次全部终态，执行更新：只有全部批次完成时，才把主任务更新为成功
        // markSuccessIfAllBatchesFinished 内部SQL必须携带乐观锁条件：主任务当前不是成功状态，防止重复更新
        int updated = couponTaskMapper.markSuccessIfAllBatchesFinished(task.getId());

        // 更新行数=1，代表本次成功将主任务流转为完成状态，打印日志
        if (updated == 1) {
            log.info("[分发] 任务完成屏障通过，taskId={}", task.getId());
        }
        // updated=0 说明：主任务已经是成功状态（MQ重复调用，幂等），无需处理
    }

    /**
     * 重载方法：由MQ消息入口调用，传入taskId和消息携带的shopNumber
     * @param taskId 批量发放任务ID
     * @param shopNumber MQ事件消息中携带的店铺编号
     */
    public void tryFinish(Long taskId, Long shopNumber) {
        // 根据taskId查询数据库里真实的主任务记录（以DB为准，不信任MQ消息里的数据）
        CouponTaskDO task = couponTaskMapper.selectById(taskId);

        if (task != null) {
            if (!shopNumber.equals(task.getShopNumber())) {
                log.warn("[分发] 批次店铺与任务不一致，taskId={}, eventShop={}, taskShop={}",
                        taskId, shopNumber, task.getShopNumber());
                // 店铺不匹配，直接终止，不继续执行任务闭合逻辑
                return;
            }
            // 校验通过，调用重载方法，执行任务完成屏障判断
            tryFinish(task);
        }
        // task == null：任务主记录不存在，直接丢弃，不做处理（脏消息）
    }
}
