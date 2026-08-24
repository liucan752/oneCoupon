-- 适用于已经部署过 oneCoupon 的数据库；如果使用更新后的 onecoupon.sql 初始化新库，
-- 不要再次执行本文件中的 ALTER TABLE，避免重复添加 input_completed。
-- 请先在 one_coupon_0、one_coupon_1 分别核对 t_coupon_task 的实际位置；
-- 默认数据源配置下 t_coupon_task 位于 one_coupon_0，批次/明细表按 shop_number 分库。

ALTER TABLE `t_coupon_task`
    ADD COLUMN `input_completed` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Excel 是否已完整持久化到任务明细' AFTER `status`;

CREATE TABLE `t_coupon_task_batch`
(
    `id`                 bigint(20) NOT NULL COMMENT '批次 ID，雪花算法生成',
    `task_id`            bigint(20) NOT NULL COMMENT '任务 ID',
    `shop_number`        bigint(20) NOT NULL COMMENT '店铺分片键',
    `coupon_template_id` bigint(20) NOT NULL COMMENT '优惠券模板 ID',
    `batch_no`           int(11) NOT NULL COMMENT '任务内递增批次号',
    `expected_count`     int(11) NOT NULL COMMENT '批次明细数量',
    `success_count`      int(11) NOT NULL DEFAULT 0 COMMENT '成功数量',
    `fail_count`         int(11) NOT NULL DEFAULT 0 COMMENT '失败数量',
    `status`             tinyint(1) NOT NULL DEFAULT 0 COMMENT '0 NEW 1 PROCESSING 2 SUCCESS 3 FAILED',
    `lease_owner`        varchar(128) DEFAULT NULL COMMENT '租约持有实例',
    `lease_expire_time`  datetime DEFAULT NULL COMMENT '租约过期时间',
    `create_time`        datetime NOT NULL,
    `update_time`        datetime NOT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_task_batch_no` (`task_id`, `batch_no`),
    KEY `idx_shop_status_id` (`shop_number`, `status`, `id`),
    KEY `idx_task_status` (`task_id`, `status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='优惠券分发持久化批次表';

CREATE TABLE `t_coupon_task_item`
(
    `id`                 bigint(20) NOT NULL COMMENT '明细 ID，雪花算法生成',
    `task_id`            bigint(20) NOT NULL COMMENT '任务 ID',
    `batch_id`           bigint(20) NOT NULL COMMENT '批次 ID',
    `shop_number`        bigint(20) NOT NULL COMMENT '店铺分片键',
    `row_num`            int(11) NOT NULL COMMENT 'Excel 行号',
    `user_id`            varchar(64) NOT NULL COMMENT '原始用户 ID 字符串',
    `phone`              varchar(32) DEFAULT NULL,
    `mail`               varchar(128) DEFAULT NULL,
    `status`             tinyint(1) NOT NULL DEFAULT 0 COMMENT '0 NEW 1 PROCESSING 2 SUCCESS 3 FAILED',
    `coupon_id`          bigint(20) DEFAULT NULL COMMENT '成功生成的用户券 ID',
    `fail_reason`        varchar(128) DEFAULT NULL COMMENT '失败原因',
    `create_time`        datetime NOT NULL,
    `update_time`        datetime NOT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_task_row_num` (`task_id`, `row_num`),
    KEY `idx_batch_status_row` (`batch_id`, `shop_number`, `status`, `row_num`),
    KEY `idx_task_status` (`task_id`, `status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='优惠券分发 Excel 任务明细表';
