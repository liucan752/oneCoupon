package com.nageoffer.onecoupon.distribution.service.handler.excel;

import com.alibaba.excel.context.AnalysisContext;
import com.alibaba.excel.event.AnalysisEventListener;
import com.nageoffer.onecoupon.distribution.dao.entity.CouponTaskBatchDO;
import com.nageoffer.onecoupon.distribution.dao.entity.CouponTaskDO;
import com.nageoffer.onecoupon.distribution.dao.entity.CouponTaskItemDO;
import com.nageoffer.onecoupon.distribution.dao.entity.CouponTemplateDO;
import com.nageoffer.onecoupon.distribution.dao.mapper.CouponTaskMapper;
import com.nageoffer.onecoupon.distribution.service.batch.CouponTaskFinalizer;
import com.nageoffer.onecoupon.distribution.service.batch.CouponTaskBatchWriter;
import lombok.extern.slf4j.Slf4j;

import java.util.ArrayList;
import java.util.List;

/**
 * 持久化版 Excel 监听器 DurableCouponTaskExcelListener
 *
 * 【设计思想：解耦解析阶段 和 实际发券阶段】
 * 旧方案：Excel解析线程里直接执行Redis预扣、直接给用户发券
 * 新持久化方案：解析线程只做一件事：逐行读取Excel，分批写入 t_coupon_task_item 用户明细快照
 * 真正发券交给独立的【批次消费者】MQ异步处理，可以独立水平扩容
 * 优势：进程崩溃后，可以基于已入库批次断点续跑，不会丢失导入数据
 *
 * 完整流程：
 * 1. EasyExcel逐行解析Excel用户数据，存入内存buffer缓冲区
 * 2. buffer攒够1000行，调用flush持久化生成子批次记录及其 Outbox 事件
 * 3. Excel全部解析完成，执行尾批flush（不足1000的剩余行）
 * 4. 更新主任务：标记Excel录入完成 markInputCompleted
 * 5. 调用任务完成屏障 tryFinish，尝试闭合整个批量发券任务
 *
 * 和之前简易版 CouponExcelListener 的核心区别：
 * 简易版：只入库 item，没有拆分 batch、没有投递 MQ
 * Durable持久版：入库item + 拆分子批次batch + Outbox 可靠唤醒，完整分布式分发链路
 */
@Slf4j
public class DurableCouponTaskExcelListener extends AnalysisEventListener<CouponTaskExcelObject> {

    /**
     * 缓冲区批次阈值：攒够1000行才刷盘生成一个分发子批次
     * 可根据压测结果调整，平衡JDBCIO次数、内存占用、MQ消息数量
     */
    public static final int DISTRIBUTION_BATCH_SIZE = 1000;

    // 当前所属批量发券主任务
    private final CouponTaskDO task;
    // 当前发放使用的优惠券模板（本版本解析阶段暂未直接使用，预留后续校验）
    @SuppressWarnings("unused")
    private final CouponTemplateDO template;
    // 批次写入组件：负责持久化一批明细item，生成coupon_task_batch子批次记录
    private final CouponTaskBatchWriter batchWriter;
    // 主任务Mapper，更新主任务状态（录入完成）
    private final CouponTaskMapper taskMapper;
    // 任务完成屏障：判断全部子批次是否处理完毕，闭合主任务
    private final CouponTaskFinalizer taskFinalizer;

    // 内存缓冲区：暂存解析出来的用户明细DO，达到阈值批量刷库
    private final List<CouponTaskItemDO> buffer = new ArrayList<>(DISTRIBUTION_BATCH_SIZE);
    // 已解析的数据行数计数器
    private int rowCount = 1;
    // 子批次编号：每flush一次，batchNo自增，区分同一个task下不同分发批次
    private int batchNo;

    /**
     * 构造方法：所有依赖由上层Controller手动传入
     * ⚠️重点：监听器不能交给Spring作为单例Bean，每次上传Excel必须new全新实例
     */
    public DurableCouponTaskExcelListener(CouponTaskDO task,
                                          CouponTemplateDO template,
                                          CouponTaskBatchWriter batchWriter,
                                          CouponTaskMapper taskMapper,
                                          CouponTaskFinalizer taskFinalizer) {
        this.task = task;
        this.template = template;
        this.batchWriter = batchWriter;
        this.taskMapper = taskMapper;
        this.taskFinalizer = taskFinalizer;
    }

    /**
     * EasyExcel回调：每解析一行有效数据执行一次invoke
     * @param data Excel一行映射后的实体（userId、phone、mail）
     * @param context Excel解析上下文
     */
    @Override
    public void invoke(CouponTaskExcelObject data, AnalysisContext context) {
        // 行号约定：Excel第1行是表头，数据从第2行开始记录
        int excelRowNum = rowCount + 1;
        // 组装用户明细快照存入缓冲区
        buffer.add(CouponTaskItemDO.builder()
                .rowNum(excelRowNum)
                .userId(data.getUserId())
                .phone(data.getPhone())
                .mail(data.getMail())
                .build());
        // 解析行数+1
        rowCount++;

        // 缓冲区达到阈值1000，执行刷盘，生成子批次并投递MQ
        if (buffer.size() >= DISTRIBUTION_BATCH_SIZE) {
            // false：不是最后一批数据
            flush(false);
        }
    }

    /**
     * EasyExcel回调：整个Excel文件全部解析完毕后执行收尾逻辑
     */
    @Override
    public void doAfterAllAnalysed(AnalysisContext context) {
        // 刷入剩余不足1000行的尾批数据，tail=true标记这是最后一个批次
        flush(true);

        // 更新主任务状态：Excel所有行已经持久入库，录入阶段完成
        taskMapper.markInputCompleted(task.getId());
        // 内存对象同步状态
        task.setInputCompleted(1);

        // 调用任务完成屏障，尝试闭合整个批量任务
        taskFinalizer.tryFinish(task);

        log.info("[分发] Excel 已完成持久化，taskId={}, totalRows={}, batchCount={}",
                task.getId(), rowCount - 1, batchNo);
    }

    /**
     * 刷盘方法：把buffer里一批明细持久化，生成 batch 子批次及同事务 Outbox 事件。
     * @param tail 是否是整个Excel的最后一个批次（尾批标记）
     */
    private void flush(boolean tail) {
        // 缓冲区无数据，直接跳过
        if (buffer.isEmpty()) {
            return;
        }
        // 拷贝一份独立集合，防止buffer.clear后数据丢失
        List<CouponTaskItemDO> current = new ArrayList<>(buffer);
        buffer.clear();

        // persist 内部在同一事务中写入 item、batch、BATCH_READY Outbox；
        // 因而这里无需也不能直接发 MQ，避免形成“批次提交成功但消息发送失败”的故障窗口。
        batchWriter.persist(task, current, batchNo++);
    }
}
