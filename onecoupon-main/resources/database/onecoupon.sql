CREATE
DATABASE IF NOT EXISTS one_coupon_0;
CREATE
DATABASE IF NOT EXISTS one_coupon_1;

USE
one_coupon_0;

CREATE TABLE `t_coupon_settlement_0`
(
    `id`          bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `order_id`    bigint(20) DEFAULT NULL COMMENT '订单ID',
    `user_id`     bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_id`   bigint(20) DEFAULT NULL COMMENT '优惠券ID',
    `status`      int(11) DEFAULT NULL COMMENT '结算单状态 0：锁定 1：已取消 2：已支付 3：已退款',
    `create_time` datetime DEFAULT NULL COMMENT '创建时间',
    `update_time` datetime DEFAULT NULL COMMENT '修改时间',
    PRIMARY KEY (`id`),
    KEY           `idx_user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='优惠券结算单表';

CREATE TABLE `t_coupon_settlement_1`
(
    `id`          bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `order_id`    bigint(20) DEFAULT NULL COMMENT '订单ID',
    `user_id`     bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_id`   bigint(20) DEFAULT NULL COMMENT '优惠券ID',
    `status`      int(11) DEFAULT NULL COMMENT '结算单状态 0：锁定 1：已取消 2：已支付 3：已退款',
    `create_time` datetime DEFAULT NULL COMMENT '创建时间',
    `update_time` datetime DEFAULT NULL COMMENT '修改时间',
    PRIMARY KEY (`id`),
    KEY           `idx_user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='优惠券结算单表';

CREATE TABLE `t_coupon_settlement_2`
(
    `id`          bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `order_id`    bigint(20) DEFAULT NULL COMMENT '订单ID',
    `user_id`     bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_id`   bigint(20) DEFAULT NULL COMMENT '优惠券ID',
    `status`      int(11) DEFAULT NULL COMMENT '结算单状态 0：锁定 1：已取消 2：已支付 3：已退款',
    `create_time` datetime DEFAULT NULL COMMENT '创建时间',
    `update_time` datetime DEFAULT NULL COMMENT '修改时间',
    PRIMARY KEY (`id`),
    KEY           `idx_user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='优惠券结算单表';

CREATE TABLE `t_coupon_settlement_3`
(
    `id`          bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `order_id`    bigint(20) DEFAULT NULL COMMENT '订单ID',
    `user_id`     bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_id`   bigint(20) DEFAULT NULL COMMENT '优惠券ID',
    `status`      int(11) DEFAULT NULL COMMENT '结算单状态 0：锁定 1：已取消 2：已支付 3：已退款',
    `create_time` datetime DEFAULT NULL COMMENT '创建时间',
    `update_time` datetime DEFAULT NULL COMMENT '修改时间',
    PRIMARY KEY (`id`),
    KEY           `idx_user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='优惠券结算单表';

CREATE TABLE `t_coupon_settlement_4`
(
    `id`          bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `order_id`    bigint(20) DEFAULT NULL COMMENT '订单ID',
    `user_id`     bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_id`   bigint(20) DEFAULT NULL COMMENT '优惠券ID',
    `status`      int(11) DEFAULT NULL COMMENT '结算单状态 0：锁定 1：已取消 2：已支付 3：已退款',
    `create_time` datetime DEFAULT NULL COMMENT '创建时间',
    `update_time` datetime DEFAULT NULL COMMENT '修改时间',
    PRIMARY KEY (`id`),
    KEY           `idx_user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='优惠券结算单表';

CREATE TABLE `t_coupon_settlement_5`
(
    `id`          bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `order_id`    bigint(20) DEFAULT NULL COMMENT '订单ID',
    `user_id`     bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_id`   bigint(20) DEFAULT NULL COMMENT '优惠券ID',
    `status`      int(11) DEFAULT NULL COMMENT '结算单状态 0：锁定 1：已取消 2：已支付 3：已退款',
    `create_time` datetime DEFAULT NULL COMMENT '创建时间',
    `update_time` datetime DEFAULT NULL COMMENT '修改时间',
    PRIMARY KEY (`id`),
    KEY           `idx_user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='优惠券结算单表';

CREATE TABLE `t_coupon_settlement_6`
(
    `id`          bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `order_id`    bigint(20) DEFAULT NULL COMMENT '订单ID',
    `user_id`     bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_id`   bigint(20) DEFAULT NULL COMMENT '优惠券ID',
    `status`      int(11) DEFAULT NULL COMMENT '结算单状态 0：锁定 1：已取消 2：已支付 3：已退款',
    `create_time` datetime DEFAULT NULL COMMENT '创建时间',
    `update_time` datetime DEFAULT NULL COMMENT '修改时间',
    PRIMARY KEY (`id`),
    KEY           `idx_user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='优惠券结算单表';

CREATE TABLE `t_coupon_settlement_7`
(
    `id`          bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `order_id`    bigint(20) DEFAULT NULL COMMENT '订单ID',
    `user_id`     bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_id`   bigint(20) DEFAULT NULL COMMENT '优惠券ID',
    `status`      int(11) DEFAULT NULL COMMENT '结算单状态 0：锁定 1：已取消 2：已支付 3：已退款',
    `create_time` datetime DEFAULT NULL COMMENT '创建时间',
    `update_time` datetime DEFAULT NULL COMMENT '修改时间',
    PRIMARY KEY (`id`),
    KEY           `idx_user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='优惠券结算单表';

CREATE TABLE `t_coupon_task`
(
    `id`                 bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `shop_number`        bigint(20) DEFAULT NULL COMMENT '店铺编号',
    `batch_id`           bigint(20) DEFAULT NULL COMMENT '批次ID',
    `task_name`          varchar(128) DEFAULT NULL COMMENT '优惠券批次任务名称',
    `file_address`       varchar(512) DEFAULT NULL COMMENT '文件地址',
    `send_num`           int(11) DEFAULT NULL COMMENT '发放优惠券数量',
    `fail_file_address`  varchar(512) DEFAULT NULL COMMENT '发放失败用户文件地址',
    `notify_type`        varchar(32)  DEFAULT NULL COMMENT '通知方式，可组合使用 0：站内信 1：弹框推送 2：邮箱 3：短信',
    `coupon_template_id` bigint(20) DEFAULT NULL COMMENT '优惠券模板ID',
    `send_type`          tinyint(1) DEFAULT NULL COMMENT '发送类型 0：立即发送 1：定时发送',
    `send_time`          datetime     DEFAULT NULL COMMENT '发送时间',
    `status`             tinyint(1) DEFAULT NULL COMMENT '状态 0：待执行 1：执行中 2：执行失败 3：执行成功 4：取消',
    `input_completed`    tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Excel 是否已完整持久化到任务明细',
    `completion_time`    datetime     DEFAULT NULL COMMENT '完成时间',
    `create_time`        datetime     DEFAULT NULL COMMENT '创建时间',
    `operator_id`        bigint(20) DEFAULT NULL COMMENT '操作人',
    `update_time`        datetime     DEFAULT NULL COMMENT '修改时间',
    `del_flag`           tinyint(1) DEFAULT NULL COMMENT '删除标识 0：未删除 1：已删除',
    PRIMARY KEY (`id`),
    KEY                  `idx_batch_id` (`batch_id`) USING BTREE,
    KEY                  `idx_coupon_template_id` (`coupon_template_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1816362696870739971 DEFAULT CHARSET=utf8mb4 COMMENT='优惠券模板发送任务表';

CREATE TABLE `t_coupon_task_fail`
(
    `id`          bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `batch_id`    bigint(20) DEFAULT NULL COMMENT '批次ID',
    `json_object` text COMMENT '失败内容',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- 持久化分发明细与批次表。
-- 这两张表是任务级数据，必须在任务表所在的业务库执行；如果部署环境有多库，
-- 应在每个承载任务数据的库执行同一 DDL，并在 ShardingSphere 中配置明确路由。
--
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

CREATE TABLE `t_coupon_template_0`
(
    `id`               bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `name`             varchar(256) DEFAULT NULL COMMENT '优惠券名称',
    `shop_number`      bigint(20) DEFAULT NULL COMMENT '店铺编号',
    `source`           tinyint(1) DEFAULT NULL COMMENT '优惠券来源 0：店铺券 1：平台券',
    `target`           tinyint(1) DEFAULT NULL COMMENT '优惠对象 0：商品专属 1：全店通用',
    `goods`            varchar(64)  DEFAULT NULL COMMENT '优惠商品编码',
    `type`             tinyint(1) DEFAULT NULL COMMENT '优惠类型 0：立减券 1：满减券 2：折扣券',
    `valid_start_time` datetime     DEFAULT NULL COMMENT '有效期开始时间',
    `valid_end_time`   datetime     DEFAULT NULL COMMENT '有效期结束时间',
    `stock`            int(11) DEFAULT NULL COMMENT '库存',
    `receive_rule`     json         DEFAULT NULL COMMENT '领取规则',
    `consume_rule`     json         DEFAULT NULL COMMENT '消耗规则',
    `status`           tinyint(1) DEFAULT NULL COMMENT '优惠券状态 0：生效中 1：已结束',
    `create_time`      datetime     DEFAULT NULL COMMENT '创建时间',
    `update_time`      datetime     DEFAULT NULL COMMENT '修改时间',
    `del_flag`         tinyint(1) DEFAULT NULL COMMENT '删除标识 0：未删除 1：已删除',
    PRIMARY KEY (`id`),
    KEY                `idx_shop_number` (`shop_number`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1810967816300515330 DEFAULT CHARSET=utf8mb4 COMMENT='优惠券模板表';

CREATE TABLE `t_coupon_template_1`
(
    `id`               bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `name`             varchar(256) DEFAULT NULL COMMENT '优惠券名称',
    `shop_number`      bigint(20) DEFAULT NULL COMMENT '店铺编号',
    `source`           tinyint(1) DEFAULT NULL COMMENT '优惠券来源 0：店铺券 1：平台券',
    `target`           tinyint(1) DEFAULT NULL COMMENT '优惠对象 0：商品专属 1：全店通用',
    `goods`            varchar(64)  DEFAULT NULL COMMENT '优惠商品编码',
    `type`             tinyint(1) DEFAULT NULL COMMENT '优惠类型 0：立减券 1：满减券 2：折扣券',
    `valid_start_time` datetime     DEFAULT NULL COMMENT '有效期开始时间',
    `valid_end_time`   datetime     DEFAULT NULL COMMENT '有效期结束时间',
    `stock`            int(11) DEFAULT NULL COMMENT '库存',
    `receive_rule`     json         DEFAULT NULL COMMENT '领取规则',
    `consume_rule`     json         DEFAULT NULL COMMENT '消耗规则',
    `status`           tinyint(1) DEFAULT NULL COMMENT '优惠券状态 0：生效中 1：已结束',
    `create_time`      datetime     DEFAULT NULL COMMENT '创建时间',
    `update_time`      datetime     DEFAULT NULL COMMENT '修改时间',
    `del_flag`         tinyint(1) DEFAULT NULL COMMENT '删除标识 0：未删除 1：已删除',
    PRIMARY KEY (`id`),
    KEY                `idx_shop_number` (`shop_number`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1810967812836020227 DEFAULT CHARSET=utf8mb4 COMMENT='优惠券模板表';

CREATE TABLE `t_coupon_template_2`
(
    `id`               bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `name`             varchar(256) DEFAULT NULL COMMENT '优惠券名称',
    `shop_number`      bigint(20) DEFAULT NULL COMMENT '店铺编号',
    `source`           tinyint(1) DEFAULT NULL COMMENT '优惠券来源 0：店铺券 1：平台券',
    `target`           tinyint(1) DEFAULT NULL COMMENT '优惠对象 0：商品专属 1：全店通用',
    `goods`            varchar(64)  DEFAULT NULL COMMENT '优惠商品编码',
    `type`             tinyint(1) DEFAULT NULL COMMENT '优惠类型 0：立减券 1：满减券 2：折扣券',
    `valid_start_time` datetime     DEFAULT NULL COMMENT '有效期开始时间',
    `valid_end_time`   datetime     DEFAULT NULL COMMENT '有效期结束时间',
    `stock`            int(11) DEFAULT NULL COMMENT '库存',
    `receive_rule`     json         DEFAULT NULL COMMENT '领取规则',
    `consume_rule`     json         DEFAULT NULL COMMENT '消耗规则',
    `status`           tinyint(1) DEFAULT NULL COMMENT '优惠券状态 0：生效中 1：已结束',
    `create_time`      datetime     DEFAULT NULL COMMENT '创建时间',
    `update_time`      datetime     DEFAULT NULL COMMENT '修改时间',
    `del_flag`         tinyint(1) DEFAULT NULL COMMENT '删除标识 0：未删除 1：已删除',
    PRIMARY KEY (`id`),
    KEY                `idx_shop_number` (`shop_number`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1810967817126793218 DEFAULT CHARSET=utf8mb4 COMMENT='优惠券模板表';

CREATE TABLE `t_coupon_template_3`
(
    `id`               bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `name`             varchar(256) DEFAULT NULL COMMENT '优惠券名称',
    `shop_number`      bigint(20) DEFAULT NULL COMMENT '店铺编号',
    `source`           tinyint(1) DEFAULT NULL COMMENT '优惠券来源 0：店铺券 1：平台券',
    `target`           tinyint(1) DEFAULT NULL COMMENT '优惠对象 0：商品专属 1：全店通用',
    `goods`            varchar(64)  DEFAULT NULL COMMENT '优惠商品编码',
    `type`             tinyint(1) DEFAULT NULL COMMENT '优惠类型 0：立减券 1：满减券 2：折扣券',
    `valid_start_time` datetime     DEFAULT NULL COMMENT '有效期开始时间',
    `valid_end_time`   datetime     DEFAULT NULL COMMENT '有效期结束时间',
    `stock`            int(11) DEFAULT NULL COMMENT '库存',
    `receive_rule`     json         DEFAULT NULL COMMENT '领取规则',
    `consume_rule`     json         DEFAULT NULL COMMENT '消耗规则',
    `status`           tinyint(1) DEFAULT NULL COMMENT '优惠券状态 0：生效中 1：已结束',
    `create_time`      datetime     DEFAULT NULL COMMENT '创建时间',
    `update_time`      datetime     DEFAULT NULL COMMENT '修改时间',
    `del_flag`         tinyint(1) DEFAULT NULL COMMENT '删除标识 0：未删除 1：已删除',
    PRIMARY KEY (`id`),
    KEY                `idx_shop_number` (`shop_number`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1810967817122598915 DEFAULT CHARSET=utf8mb4 COMMENT='优惠券模板表';

CREATE TABLE `t_coupon_template_4`
(
    `id`               bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `name`             varchar(256) DEFAULT NULL COMMENT '优惠券名称',
    `shop_number`      bigint(20) DEFAULT NULL COMMENT '店铺编号',
    `source`           tinyint(1) DEFAULT NULL COMMENT '优惠券来源 0：店铺券 1：平台券',
    `target`           tinyint(1) DEFAULT NULL COMMENT '优惠对象 0：商品专属 1：全店通用',
    `goods`            varchar(64)  DEFAULT NULL COMMENT '优惠商品编码',
    `type`             tinyint(1) DEFAULT NULL COMMENT '优惠类型 0：立减券 1：满减券 2：折扣券',
    `valid_start_time` datetime     DEFAULT NULL COMMENT '有效期开始时间',
    `valid_end_time`   datetime     DEFAULT NULL COMMENT '有效期结束时间',
    `stock`            int(11) DEFAULT NULL COMMENT '库存',
    `receive_rule`     json         DEFAULT NULL COMMENT '领取规则',
    `consume_rule`     json         DEFAULT NULL COMMENT '消耗规则',
    `status`           tinyint(1) DEFAULT NULL COMMENT '优惠券状态 0：生效中 1：已结束',
    `create_time`      datetime     DEFAULT NULL COMMENT '创建时间',
    `update_time`      datetime     DEFAULT NULL COMMENT '修改时间',
    `del_flag`         tinyint(1) DEFAULT NULL COMMENT '删除标识 0：未删除 1：已删除',
    PRIMARY KEY (`id`),
    KEY                `idx_shop_number` (`shop_number`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1810967797723942918 DEFAULT CHARSET=utf8mb4 COMMENT='优惠券模板表';

CREATE TABLE `t_coupon_template_5`
(
    `id`               bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `name`             varchar(256) DEFAULT NULL COMMENT '优惠券名称',
    `shop_number`      bigint(20) DEFAULT NULL COMMENT '店铺编号',
    `source`           tinyint(1) DEFAULT NULL COMMENT '优惠券来源 0：店铺券 1：平台券',
    `target`           tinyint(1) DEFAULT NULL COMMENT '优惠对象 0：商品专属 1：全店通用',
    `goods`            varchar(64)  DEFAULT NULL COMMENT '优惠商品编码',
    `type`             tinyint(1) DEFAULT NULL COMMENT '优惠类型 0：立减券 1：满减券 2：折扣券',
    `valid_start_time` datetime     DEFAULT NULL COMMENT '有效期开始时间',
    `valid_end_time`   datetime     DEFAULT NULL COMMENT '有效期结束时间',
    `stock`            int(11) DEFAULT NULL COMMENT '库存',
    `receive_rule`     json         DEFAULT NULL COMMENT '领取规则',
    `consume_rule`     json         DEFAULT NULL COMMENT '消耗规则',
    `status`           tinyint(1) DEFAULT NULL COMMENT '优惠券状态 0：生效中 1：已结束',
    `create_time`      datetime     DEFAULT NULL COMMENT '创建时间',
    `update_time`      datetime     DEFAULT NULL COMMENT '修改时间',
    `del_flag`         tinyint(1) DEFAULT NULL COMMENT '删除标识 0：未删除 1：已删除',
    PRIMARY KEY (`id`),
    KEY                `idx_shop_number` (`shop_number`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1810967789205311493 DEFAULT CHARSET=utf8mb4 COMMENT='优惠券模板表';

CREATE TABLE `t_coupon_template_6`
(
    `id`               bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `name`             varchar(256) DEFAULT NULL COMMENT '优惠券名称',
    `shop_number`      bigint(20) DEFAULT NULL COMMENT '店铺编号',
    `source`           tinyint(1) DEFAULT NULL COMMENT '优惠券来源 0：店铺券 1：平台券',
    `target`           tinyint(1) DEFAULT NULL COMMENT '优惠对象 0：商品专属 1：全店通用',
    `goods`            varchar(64)  DEFAULT NULL COMMENT '优惠商品编码',
    `type`             tinyint(1) DEFAULT NULL COMMENT '优惠类型 0：立减券 1：满减券 2：折扣券',
    `valid_start_time` datetime     DEFAULT NULL COMMENT '有效期开始时间',
    `valid_end_time`   datetime     DEFAULT NULL COMMENT '有效期结束时间',
    `stock`            int(11) DEFAULT NULL COMMENT '库存',
    `receive_rule`     json         DEFAULT NULL COMMENT '领取规则',
    `consume_rule`     json         DEFAULT NULL COMMENT '消耗规则',
    `status`           tinyint(1) DEFAULT NULL COMMENT '优惠券状态 0：生效中 1：已结束',
    `create_time`      datetime     DEFAULT NULL COMMENT '创建时间',
    `update_time`      datetime     DEFAULT NULL COMMENT '修改时间',
    `del_flag`         tinyint(1) DEFAULT NULL COMMENT '删除标识 0：未删除 1：已删除',
    PRIMARY KEY (`id`),
    KEY                `idx_shop_number` (`shop_number`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1810967789150785539 DEFAULT CHARSET=utf8mb4 COMMENT='优惠券模板表';

CREATE TABLE `t_coupon_template_7`
(
    `id`               bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `name`             varchar(256) DEFAULT NULL COMMENT '优惠券名称',
    `shop_number`      bigint(20) DEFAULT NULL COMMENT '店铺编号',
    `source`           tinyint(1) DEFAULT NULL COMMENT '优惠券来源 0：店铺券 1：平台券',
    `target`           tinyint(1) DEFAULT NULL COMMENT '优惠对象 0：商品专属 1：全店通用',
    `goods`            varchar(64)  DEFAULT NULL COMMENT '优惠商品编码',
    `type`             tinyint(1) DEFAULT NULL COMMENT '优惠类型 0：立减券 1：满减券 2：折扣券',
    `valid_start_time` datetime     DEFAULT NULL COMMENT '有效期开始时间',
    `valid_end_time`   datetime     DEFAULT NULL COMMENT '有效期结束时间',
    `stock`            int(11) DEFAULT NULL COMMENT '库存',
    `receive_rule`     json         DEFAULT NULL COMMENT '领取规则',
    `consume_rule`     json         DEFAULT NULL COMMENT '消耗规则',
    `status`           tinyint(1) DEFAULT NULL COMMENT '优惠券状态 0：生效中 1：已结束',
    `create_time`      datetime     DEFAULT NULL COMMENT '创建时间',
    `update_time`      datetime     DEFAULT NULL COMMENT '修改时间',
    `del_flag`         tinyint(1) DEFAULT NULL COMMENT '删除标识 0：未删除 1：已删除',
    PRIMARY KEY (`id`),
    KEY                `idx_shop_number` (`shop_number`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1810967780615376898 DEFAULT CHARSET=utf8mb4 COMMENT='优惠券模板表';

CREATE TABLE `t_coupon_template_log`
(
    `id`                 bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `shop_number`        varchar(64)   DEFAULT NULL COMMENT '店铺编号',
    `coupon_template_id` bigint(20) DEFAULT NULL COMMENT '优惠券模板ID',
    `operator_id`        bigint(20) DEFAULT NULL COMMENT '操作人',
    `operation_log`      text COMMENT '操作日志',
    `original_data`      varchar(1024) DEFAULT NULL COMMENT '原始数据',
    `modified_data`      varchar(1024) DEFAULT NULL COMMENT '修改后数据',
    `create_time`        datetime      DEFAULT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`),
    KEY                  `idx_shop_number` (`shop_number`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1810714735922958339 DEFAULT CHARSET=utf8mb4;

CREATE TABLE `t_coupon_template_log_0`
(
    `id`                 bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `shop_number`        bigint(20) DEFAULT NULL COMMENT '店铺编号',
    `coupon_template_id` bigint(20) DEFAULT NULL COMMENT '优惠券模板ID',
    `operator_id`        bigint(20) DEFAULT NULL COMMENT '操作人',
    `operation_log`      text COMMENT '操作日志',
    `original_data`      varchar(1024) DEFAULT NULL COMMENT '原始数据',
    `modified_data`      varchar(1024) DEFAULT NULL COMMENT '修改后数据',
    `create_time`        datetime      DEFAULT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`),
    KEY                  `idx_shop_number` (`shop_number`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='优惠券模板操作日志表';

CREATE TABLE `t_coupon_template_log_1`
(
    `id`                 bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `shop_number`        bigint(20) DEFAULT NULL COMMENT '店铺编号',
    `coupon_template_id` bigint(20) DEFAULT NULL COMMENT '优惠券模板ID',
    `operator_id`        bigint(20) DEFAULT NULL COMMENT '操作人',
    `operation_log`      text COMMENT '操作日志',
    `original_data`      varchar(1024) DEFAULT NULL COMMENT '原始数据',
    `modified_data`      varchar(1024) DEFAULT NULL COMMENT '修改后数据',
    `create_time`        datetime      DEFAULT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`),
    KEY                  `idx_shop_number` (`shop_number`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='优惠券模板操作日志表';

CREATE TABLE `t_coupon_template_log_2`
(
    `id`                 bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `shop_number`        bigint(20) DEFAULT NULL COMMENT '店铺编号',
    `coupon_template_id` bigint(20) DEFAULT NULL COMMENT '优惠券模板ID',
    `operator_id`        bigint(20) DEFAULT NULL COMMENT '操作人',
    `operation_log`      text COMMENT '操作日志',
    `original_data`      varchar(1024) DEFAULT NULL COMMENT '原始数据',
    `modified_data`      varchar(1024) DEFAULT NULL COMMENT '修改后数据',
    `create_time`        datetime      DEFAULT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`),
    KEY                  `idx_shop_number` (`shop_number`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='优惠券模板操作日志表';

CREATE TABLE `t_coupon_template_log_3`
(
    `id`                 bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `shop_number`        bigint(20) DEFAULT NULL COMMENT '店铺编号',
    `coupon_template_id` bigint(20) DEFAULT NULL COMMENT '优惠券模板ID',
    `operator_id`        bigint(20) DEFAULT NULL COMMENT '操作人',
    `operation_log`      text COMMENT '操作日志',
    `original_data`      varchar(1024) DEFAULT NULL COMMENT '原始数据',
    `modified_data`      varchar(1024) DEFAULT NULL COMMENT '修改后数据',
    `create_time`        datetime      DEFAULT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`),
    KEY                  `idx_shop_number` (`shop_number`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='优惠券模板操作日志表';

CREATE TABLE `t_coupon_template_log_4`
(
    `id`                 bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `shop_number`        bigint(20) DEFAULT NULL COMMENT '店铺编号',
    `coupon_template_id` bigint(20) DEFAULT NULL COMMENT '优惠券模板ID',
    `operator_id`        bigint(20) DEFAULT NULL COMMENT '操作人',
    `operation_log`      text COMMENT '操作日志',
    `original_data`      varchar(1024) DEFAULT NULL COMMENT '原始数据',
    `modified_data`      varchar(1024) DEFAULT NULL COMMENT '修改后数据',
    `create_time`        datetime      DEFAULT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`),
    KEY                  `idx_shop_number` (`shop_number`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='优惠券模板操作日志表';

CREATE TABLE `t_coupon_template_log_5`
(
    `id`                 bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `shop_number`        bigint(20) DEFAULT NULL COMMENT '店铺编号',
    `coupon_template_id` bigint(20) DEFAULT NULL COMMENT '优惠券模板ID',
    `operator_id`        bigint(20) DEFAULT NULL COMMENT '操作人',
    `operation_log`      text COMMENT '操作日志',
    `original_data`      varchar(1024) DEFAULT NULL COMMENT '原始数据',
    `modified_data`      varchar(1024) DEFAULT NULL COMMENT '修改后数据',
    `create_time`        datetime      DEFAULT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`),
    KEY                  `idx_shop_number` (`shop_number`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='优惠券模板操作日志表';

CREATE TABLE `t_coupon_template_log_6`
(
    `id`                 bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `shop_number`        bigint(20) DEFAULT NULL COMMENT '店铺编号',
    `coupon_template_id` bigint(20) DEFAULT NULL COMMENT '优惠券模板ID',
    `operator_id`        bigint(20) DEFAULT NULL COMMENT '操作人',
    `operation_log`      text COMMENT '操作日志',
    `original_data`      varchar(1024) DEFAULT NULL COMMENT '原始数据',
    `modified_data`      varchar(1024) DEFAULT NULL COMMENT '修改后数据',
    `create_time`        datetime      DEFAULT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`),
    KEY                  `idx_shop_number` (`shop_number`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='优惠券模板操作日志表';

CREATE TABLE `t_coupon_template_log_7`
(
    `id`                 bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `shop_number`        bigint(20) DEFAULT NULL COMMENT '店铺编号',
    `coupon_template_id` bigint(20) DEFAULT NULL COMMENT '优惠券模板ID',
    `operator_id`        bigint(20) DEFAULT NULL COMMENT '操作人',
    `operation_log`      text COMMENT '操作日志',
    `original_data`      varchar(1024) DEFAULT NULL COMMENT '原始数据',
    `modified_data`      varchar(1024) DEFAULT NULL COMMENT '修改后数据',
    `create_time`        datetime      DEFAULT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`),
    KEY                  `idx_shop_number` (`shop_number`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='优惠券模板操作日志表';

CREATE TABLE `t_coupon_template_remind`
(
    `user_id`            bigint(20) NOT NULL COMMENT '用户ID',
    `coupon_template_id` bigint(20) NOT NULL COMMENT '券ID',
    `information`        bigint(20) DEFAULT NULL COMMENT '存储信息',
    `shop_number`        bigint(20) DEFAULT NULL COMMENT '店铺编号',
    `start_time`         datetime DEFAULT NULL COMMENT '优惠券开抢时间',
    PRIMARY KEY (`user_id`, `coupon_template_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户预约提醒信息存储表';

CREATE TABLE `t_user`
(
    `id`          bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `shop_number` varchar(64)  DEFAULT NULL COMMENT '店铺编号',
    `username`    varchar(64)  DEFAULT NULL COMMENT '用户名',
    `password`    varchar(512) DEFAULT NULL COMMENT '密码',
    `phone`       varchar(128) DEFAULT NULL COMMENT '手机号',
    `mail`        varchar(512) DEFAULT NULL COMMENT '邮箱',
    `create_time` datetime     DEFAULT NULL COMMENT '创建时间',
    `update_time` datetime     DEFAULT NULL COMMENT '修改时间',
    `del_flag`    tinyint(1) DEFAULT NULL COMMENT '删除标识 0：未删除 1：已删除',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1810872207291752449 DEFAULT CHARSET=utf8mb4 COMMENT='商家用户表';

CREATE TABLE `t_user_coupon_0`
(
    `id`                 bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`            bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_template_id` bigint(20) DEFAULT NULL COMMENT '优惠券模板ID',
    `receive_time`       datetime DEFAULT NULL COMMENT '领取时间',
    `receive_count`      int(3) DEFAULT NULL COMMENT '领取次数',
    `valid_start_time`   datetime DEFAULT NULL COMMENT '有效期开始时间',
    `valid_end_time`     datetime DEFAULT NULL COMMENT '有效期结束时间',
    `use_time`           datetime DEFAULT NULL COMMENT '使用时间',
    `source`             tinyint(1) DEFAULT NULL COMMENT '券来源 0：领券中心 1：平台发放 2：店铺领取',
    `status`             tinyint(1) DEFAULT NULL COMMENT '状态 0：未使用 1：锁定 2：已使用 3：已过期 4：已撤回',
    `create_time`        datetime DEFAULT NULL COMMENT '创建时间',
    `update_time`        datetime DEFAULT NULL COMMENT '修改时间',
    `del_flag`           tinyint(1) DEFAULT NULL COMMENT '删除标识 0：未删除 1：已删除',
    PRIMARY KEY (`id`),
    UNIQUE KEY `idx_user_id_coupon_template_receive_count` (`user_id`,`coupon_template_id`,`receive_count`) USING BTREE,
    KEY                  `idx_user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1816074493920030734 DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券表';

CREATE TABLE `t_user_coupon_1`
(
    `id`                 bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`            bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_template_id` bigint(20) DEFAULT NULL COMMENT '优惠券模板ID',
    `receive_time`       datetime DEFAULT NULL COMMENT '领取时间',
    `receive_count`      int(3) DEFAULT NULL COMMENT '领取次数',
    `valid_start_time`   datetime DEFAULT NULL COMMENT '有效期开始时间',
    `valid_end_time`     datetime DEFAULT NULL COMMENT '有效期结束时间',
    `use_time`           datetime DEFAULT NULL COMMENT '使用时间',
    `source`             tinyint(1) DEFAULT NULL COMMENT '券来源 0：领券中心 1：平台发放 2：店铺领取',
    `status`             tinyint(1) DEFAULT NULL COMMENT '状态 0：未使用 1：锁定 2：已使用 3：已过期 4：已撤回',
    `create_time`        datetime DEFAULT NULL COMMENT '创建时间',
    `update_time`        datetime DEFAULT NULL COMMENT '修改时间',
    `del_flag`           tinyint(1) DEFAULT NULL COMMENT '删除标识 0：未删除 1：已删除',
    PRIMARY KEY (`id`),
    UNIQUE KEY `idx_user_id_coupon_template_receive_count` (`user_id`,`coupon_template_id`,`receive_count`) USING BTREE,
    KEY                  `idx_user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1816074493920030735 DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券表';

CREATE TABLE `t_user_coupon_10`
(
    `id`                 bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`            bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_template_id` bigint(20) DEFAULT NULL COMMENT '优惠券模板ID',
    `receive_time`       datetime DEFAULT NULL COMMENT '领取时间',
    `receive_count`      int(3) DEFAULT NULL COMMENT '领取次数',
    `valid_start_time`   datetime DEFAULT NULL COMMENT '有效期开始时间',
    `valid_end_time`     datetime DEFAULT NULL COMMENT '有效期结束时间',
    `use_time`           datetime DEFAULT NULL COMMENT '使用时间',
    `source`             tinyint(1) DEFAULT NULL COMMENT '券来源 0：领券中心 1：平台发放 2：店铺领取',
    `status`             tinyint(1) DEFAULT NULL COMMENT '状态 0：未使用 1：锁定 2：已使用 3：已过期 4：已撤回',
    `create_time`        datetime DEFAULT NULL COMMENT '创建时间',
    `update_time`        datetime DEFAULT NULL COMMENT '修改时间',
    `del_flag`           tinyint(1) DEFAULT NULL COMMENT '删除标识 0：未删除 1：已删除',
    PRIMARY KEY (`id`),
    UNIQUE KEY `idx_user_id_coupon_template_receive_count` (`user_id`,`coupon_template_id`,`receive_count`) USING BTREE,
    KEY                  `idx_user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1816074493911642118 DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券表';

CREATE TABLE `t_user_coupon_11`
(
    `id`                 bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`            bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_template_id` bigint(20) DEFAULT NULL COMMENT '优惠券模板ID',
    `receive_time`       datetime DEFAULT NULL COMMENT '领取时间',
    `receive_count`      int(3) DEFAULT NULL COMMENT '领取次数',
    `valid_start_time`   datetime DEFAULT NULL COMMENT '有效期开始时间',
    `valid_end_time`     datetime DEFAULT NULL COMMENT '有效期结束时间',
    `use_time`           datetime DEFAULT NULL COMMENT '使用时间',
    `source`             tinyint(1) DEFAULT NULL COMMENT '券来源 0：领券中心 1：平台发放 2：店铺领取',
    `status`             tinyint(1) DEFAULT NULL COMMENT '状态 0：未使用 1：锁定 2：已使用 3：已过期 4：已撤回',
    `create_time`        datetime DEFAULT NULL COMMENT '创建时间',
    `update_time`        datetime DEFAULT NULL COMMENT '修改时间',
    `del_flag`           tinyint(1) DEFAULT NULL COMMENT '删除标识 0：未删除 1：已删除',
    PRIMARY KEY (`id`),
    UNIQUE KEY `idx_user_id_coupon_template_receive_count` (`user_id`,`coupon_template_id`,`receive_count`) USING BTREE,
    KEY                  `idx_user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1816074493924225035 DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券表';

CREATE TABLE `t_user_coupon_12`
(
    `id`                 bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`            bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_template_id` bigint(20) DEFAULT NULL COMMENT '优惠券模板ID',
    `receive_time`       datetime DEFAULT NULL COMMENT '领取时间',
    `receive_count`      int(3) DEFAULT NULL COMMENT '领取次数',
    `valid_start_time`   datetime DEFAULT NULL COMMENT '有效期开始时间',
    `valid_end_time`     datetime DEFAULT NULL COMMENT '有效期结束时间',
    `use_time`           datetime DEFAULT NULL COMMENT '使用时间',
    `source`             tinyint(1) DEFAULT NULL COMMENT '券来源 0：领券中心 1：平台发放 2：店铺领取',
    `status`             tinyint(1) DEFAULT NULL COMMENT '状态 0：未使用 1：锁定 2：已使用 3：已过期 4：已撤回',
    `create_time`        datetime DEFAULT NULL COMMENT '创建时间',
    `update_time`        datetime DEFAULT NULL COMMENT '修改时间',
    `del_flag`           tinyint(1) DEFAULT NULL COMMENT '删除标识 0：未删除 1：已删除',
    PRIMARY KEY (`id`),
    UNIQUE KEY `idx_user_id_coupon_template_receive_count` (`user_id`,`coupon_template_id`,`receive_count`) USING BTREE,
    KEY                  `idx_user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1816074493915836424 DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券表';

CREATE TABLE `t_user_coupon_13`
(
    `id`                 bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`            bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_template_id` bigint(20) DEFAULT NULL COMMENT '优惠券模板ID',
    `receive_time`       datetime DEFAULT NULL COMMENT '领取时间',
    `receive_count`      int(3) DEFAULT NULL COMMENT '领取次数',
    `valid_start_time`   datetime DEFAULT NULL COMMENT '有效期开始时间',
    `valid_end_time`     datetime DEFAULT NULL COMMENT '有效期结束时间',
    `use_time`           datetime DEFAULT NULL COMMENT '使用时间',
    `source`             tinyint(1) DEFAULT NULL COMMENT '券来源 0：领券中心 1：平台发放 2：店铺领取',
    `status`             tinyint(1) DEFAULT NULL COMMENT '状态 0：未使用 1：锁定 2：已使用 3：已过期 4：已撤回',
    `create_time`        datetime DEFAULT NULL COMMENT '创建时间',
    `update_time`        datetime DEFAULT NULL COMMENT '修改时间',
    `del_flag`           tinyint(1) DEFAULT NULL COMMENT '删除标识 0：未删除 1：已删除',
    PRIMARY KEY (`id`),
    UNIQUE KEY `idx_user_id_coupon_template_receive_count` (`user_id`,`coupon_template_id`,`receive_count`) USING BTREE,
    KEY                  `idx_user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1816074493920030728 DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券表';

CREATE TABLE `t_user_coupon_14`
(
    `id`                 bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`            bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_template_id` bigint(20) DEFAULT NULL COMMENT '优惠券模板ID',
    `receive_time`       datetime DEFAULT NULL COMMENT '领取时间',
    `receive_count`      int(3) DEFAULT NULL COMMENT '领取次数',
    `valid_start_time`   datetime DEFAULT NULL COMMENT '有效期开始时间',
    `valid_end_time`     datetime DEFAULT NULL COMMENT '有效期结束时间',
    `use_time`           datetime DEFAULT NULL COMMENT '使用时间',
    `source`             tinyint(1) DEFAULT NULL COMMENT '券来源 0：领券中心 1：平台发放 2：店铺领取',
    `status`             tinyint(1) DEFAULT NULL COMMENT '状态 0：未使用 1：锁定 2：已使用 3：已过期 4：已撤回',
    `create_time`        datetime DEFAULT NULL COMMENT '创建时间',
    `update_time`        datetime DEFAULT NULL COMMENT '修改时间',
    `del_flag`           tinyint(1) DEFAULT NULL COMMENT '删除标识 0：未删除 1：已删除',
    PRIMARY KEY (`id`),
    UNIQUE KEY `idx_user_id_coupon_template_receive_count` (`user_id`,`coupon_template_id`,`receive_count`) USING BTREE,
    KEY                  `idx_user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1816074493899059215 DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券表';

CREATE TABLE `t_user_coupon_15`
(
    `id`                 bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`            bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_template_id` bigint(20) DEFAULT NULL COMMENT '优惠券模板ID',
    `receive_time`       datetime DEFAULT NULL COMMENT '领取时间',
    `receive_count`      int(3) DEFAULT NULL COMMENT '领取次数',
    `valid_start_time`   datetime DEFAULT NULL COMMENT '有效期开始时间',
    `valid_end_time`     datetime DEFAULT NULL COMMENT '有效期结束时间',
    `use_time`           datetime DEFAULT NULL COMMENT '使用时间',
    `source`             tinyint(1) DEFAULT NULL COMMENT '券来源 0：领券中心 1：平台发放 2：店铺领取',
    `status`             tinyint(1) DEFAULT NULL COMMENT '状态 0：未使用 1：锁定 2：已使用 3：已过期 4：已撤回',
    `create_time`        datetime DEFAULT NULL COMMENT '创建时间',
    `update_time`        datetime DEFAULT NULL COMMENT '修改时间',
    `del_flag`           tinyint(1) DEFAULT NULL COMMENT '删除标识 0：未删除 1：已删除',
    PRIMARY KEY (`id`),
    UNIQUE KEY `idx_user_id_coupon_template_receive_count` (`user_id`,`coupon_template_id`,`receive_count`) USING BTREE,
    KEY                  `idx_user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1816074493920030732 DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券表';

CREATE TABLE `t_user_coupon_2`
(
    `id`                 bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`            bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_template_id` bigint(20) DEFAULT NULL COMMENT '优惠券模板ID',
    `receive_time`       datetime DEFAULT NULL COMMENT '领取时间',
    `receive_count`      int(3) DEFAULT NULL COMMENT '领取次数',
    `valid_start_time`   datetime DEFAULT NULL COMMENT '有效期开始时间',
    `valid_end_time`     datetime DEFAULT NULL COMMENT '有效期结束时间',
    `use_time`           datetime DEFAULT NULL COMMENT '使用时间',
    `source`             tinyint(1) DEFAULT NULL COMMENT '券来源 0：领券中心 1：平台发放 2：店铺领取',
    `status`             tinyint(1) DEFAULT NULL COMMENT '状态 0：未使用 1：锁定 2：已使用 3：已过期 4：已撤回',
    `create_time`        datetime DEFAULT NULL COMMENT '创建时间',
    `update_time`        datetime DEFAULT NULL COMMENT '修改时间',
    `del_flag`           tinyint(1) DEFAULT NULL COMMENT '删除标识 0：未删除 1：已删除',
    PRIMARY KEY (`id`),
    UNIQUE KEY `idx_user_id_coupon_template_receive_count` (`user_id`,`coupon_template_id`,`receive_count`) USING BTREE,
    KEY                  `idx_user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1816074493924225034 DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券表';

CREATE TABLE `t_user_coupon_3`
(
    `id`                 bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`            bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_template_id` bigint(20) DEFAULT NULL COMMENT '优惠券模板ID',
    `receive_time`       datetime DEFAULT NULL COMMENT '领取时间',
    `receive_count`      int(3) DEFAULT NULL COMMENT '领取次数',
    `valid_start_time`   datetime DEFAULT NULL COMMENT '有效期开始时间',
    `valid_end_time`     datetime DEFAULT NULL COMMENT '有效期结束时间',
    `use_time`           datetime DEFAULT NULL COMMENT '使用时间',
    `source`             tinyint(1) DEFAULT NULL COMMENT '券来源 0：领券中心 1：平台发放 2：店铺领取',
    `status`             tinyint(1) DEFAULT NULL COMMENT '状态 0：未使用 1：锁定 2：已使用 3：已过期 4：已撤回',
    `create_time`        datetime DEFAULT NULL COMMENT '创建时间',
    `update_time`        datetime DEFAULT NULL COMMENT '修改时间',
    `del_flag`           tinyint(1) DEFAULT NULL COMMENT '删除标识 0：未删除 1：已删除',
    PRIMARY KEY (`id`),
    UNIQUE KEY `idx_user_id_coupon_template_receive_count` (`user_id`,`coupon_template_id`,`receive_count`) USING BTREE,
    KEY                  `idx_user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1816074493920030727 DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券表';

CREATE TABLE `t_user_coupon_4`
(
    `id`                 bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`            bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_template_id` bigint(20) DEFAULT NULL COMMENT '优惠券模板ID',
    `receive_time`       datetime DEFAULT NULL COMMENT '领取时间',
    `receive_count`      int(3) DEFAULT NULL COMMENT '领取次数',
    `valid_start_time`   datetime DEFAULT NULL COMMENT '有效期开始时间',
    `valid_end_time`     datetime DEFAULT NULL COMMENT '有效期结束时间',
    `use_time`           datetime DEFAULT NULL COMMENT '使用时间',
    `source`             tinyint(1) DEFAULT NULL COMMENT '券来源 0：领券中心 1：平台发放 2：店铺领取',
    `status`             tinyint(1) DEFAULT NULL COMMENT '状态 0：未使用 1：锁定 2：已使用 3：已过期 4：已撤回',
    `create_time`        datetime DEFAULT NULL COMMENT '创建时间',
    `update_time`        datetime DEFAULT NULL COMMENT '修改时间',
    `del_flag`           tinyint(1) DEFAULT NULL COMMENT '删除标识 0：未删除 1：已删除',
    PRIMARY KEY (`id`),
    UNIQUE KEY `idx_user_id_coupon_template_receive_count` (`user_id`,`coupon_template_id`,`receive_count`) USING BTREE,
    KEY                  `idx_user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1816074493915836428 DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券表';

CREATE TABLE `t_user_coupon_5`
(
    `id`                 bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`            bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_template_id` bigint(20) DEFAULT NULL COMMENT '优惠券模板ID',
    `receive_time`       datetime DEFAULT NULL COMMENT '领取时间',
    `receive_count`      int(3) DEFAULT NULL COMMENT '领取次数',
    `valid_start_time`   datetime DEFAULT NULL COMMENT '有效期开始时间',
    `valid_end_time`     datetime DEFAULT NULL COMMENT '有效期结束时间',
    `use_time`           datetime DEFAULT NULL COMMENT '使用时间',
    `source`             tinyint(1) DEFAULT NULL COMMENT '券来源 0：领券中心 1：平台发放 2：店铺领取',
    `status`             tinyint(1) DEFAULT NULL COMMENT '状态 0：未使用 1：锁定 2：已使用 3：已过期 4：已撤回',
    `create_time`        datetime DEFAULT NULL COMMENT '创建时间',
    `update_time`        datetime DEFAULT NULL COMMENT '修改时间',
    `del_flag`           tinyint(1) DEFAULT NULL COMMENT '删除标识 0：未删除 1：已删除',
    PRIMARY KEY (`id`),
    UNIQUE KEY `idx_user_id_coupon_template_receive_count` (`user_id`,`coupon_template_id`,`receive_count`) USING BTREE,
    KEY                  `idx_user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1816074493915836430 DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券表';

CREATE TABLE `t_user_coupon_6`
(
    `id`                 bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`            bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_template_id` bigint(20) DEFAULT NULL COMMENT '优惠券模板ID',
    `receive_time`       datetime DEFAULT NULL COMMENT '领取时间',
    `receive_count`      int(3) DEFAULT NULL COMMENT '领取次数',
    `valid_start_time`   datetime DEFAULT NULL COMMENT '有效期开始时间',
    `valid_end_time`     datetime DEFAULT NULL COMMENT '有效期结束时间',
    `use_time`           datetime DEFAULT NULL COMMENT '使用时间',
    `source`             tinyint(1) DEFAULT NULL COMMENT '券来源 0：领券中心 1：平台发放 2：店铺领取',
    `status`             tinyint(1) DEFAULT NULL COMMENT '状态 0：未使用 1：锁定 2：已使用 3：已过期 4：已撤回',
    `create_time`        datetime DEFAULT NULL COMMENT '创建时间',
    `update_time`        datetime DEFAULT NULL COMMENT '修改时间',
    `del_flag`           tinyint(1) DEFAULT NULL COMMENT '删除标识 0：未删除 1：已删除',
    PRIMARY KEY (`id`),
    UNIQUE KEY `idx_user_id_coupon_template_receive_count` (`user_id`,`coupon_template_id`,`receive_count`) USING BTREE,
    KEY                  `idx_user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1816074493915836425 DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券表';

CREATE TABLE `t_user_coupon_7`
(
    `id`                 bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`            bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_template_id` bigint(20) DEFAULT NULL COMMENT '优惠券模板ID',
    `receive_time`       datetime DEFAULT NULL COMMENT '领取时间',
    `receive_count`      int(3) DEFAULT NULL COMMENT '领取次数',
    `valid_start_time`   datetime DEFAULT NULL COMMENT '有效期开始时间',
    `valid_end_time`     datetime DEFAULT NULL COMMENT '有效期结束时间',
    `use_time`           datetime DEFAULT NULL COMMENT '使用时间',
    `source`             tinyint(1) DEFAULT NULL COMMENT '券来源 0：领券中心 1：平台发放 2：店铺领取',
    `status`             tinyint(1) DEFAULT NULL COMMENT '状态 0：未使用 1：锁定 2：已使用 3：已过期 4：已撤回',
    `create_time`        datetime DEFAULT NULL COMMENT '创建时间',
    `update_time`        datetime DEFAULT NULL COMMENT '修改时间',
    `del_flag`           tinyint(1) DEFAULT NULL COMMENT '删除标识 0：未删除 1：已删除',
    PRIMARY KEY (`id`),
    UNIQUE KEY `idx_user_id_coupon_template_receive_count` (`user_id`,`coupon_template_id`,`receive_count`) USING BTREE,
    KEY                  `idx_user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1816074493924225032 DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券表';

CREATE TABLE `t_user_coupon_8`
(
    `id`                 bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`            bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_template_id` bigint(20) DEFAULT NULL COMMENT '优惠券模板ID',
    `receive_time`       datetime DEFAULT NULL COMMENT '领取时间',
    `receive_count`      int(3) DEFAULT NULL COMMENT '领取次数',
    `valid_start_time`   datetime DEFAULT NULL COMMENT '有效期开始时间',
    `valid_end_time`     datetime DEFAULT NULL COMMENT '有效期结束时间',
    `use_time`           datetime DEFAULT NULL COMMENT '使用时间',
    `source`             tinyint(1) DEFAULT NULL COMMENT '券来源 0：领券中心 1：平台发放 2：店铺领取',
    `status`             tinyint(1) DEFAULT NULL COMMENT '状态 0：未使用 1：锁定 2：已使用 3：已过期 4：已撤回',
    `create_time`        datetime DEFAULT NULL COMMENT '创建时间',
    `update_time`        datetime DEFAULT NULL COMMENT '修改时间',
    `del_flag`           tinyint(1) DEFAULT NULL COMMENT '删除标识 0：未删除 1：已删除',
    PRIMARY KEY (`id`),
    UNIQUE KEY `idx_user_id_coupon_template_receive_count` (`user_id`,`coupon_template_id`,`receive_count`) USING BTREE,
    KEY                  `idx_user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1816074493911642124 DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券表';

CREATE TABLE `t_user_coupon_9`
(
    `id`                 bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`            bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_template_id` bigint(20) DEFAULT NULL COMMENT '优惠券模板ID',
    `receive_time`       datetime DEFAULT NULL COMMENT '领取时间',
    `receive_count`      int(3) DEFAULT NULL COMMENT '领取次数',
    `valid_start_time`   datetime DEFAULT NULL COMMENT '有效期开始时间',
    `valid_end_time`     datetime DEFAULT NULL COMMENT '有效期结束时间',
    `use_time`           datetime DEFAULT NULL COMMENT '使用时间',
    `source`             tinyint(1) DEFAULT NULL COMMENT '券来源 0：领券中心 1：平台发放 2：店铺领取',
    `status`             tinyint(1) DEFAULT NULL COMMENT '状态 0：未使用 1：锁定 2：已使用 3：已过期 4：已撤回',
    `create_time`        datetime DEFAULT NULL COMMENT '创建时间',
    `update_time`        datetime DEFAULT NULL COMMENT '修改时间',
    `del_flag`           tinyint(1) DEFAULT NULL COMMENT '删除标识 0：未删除 1：已删除',
    PRIMARY KEY (`id`),
    UNIQUE KEY `idx_user_id_coupon_template_receive_count` (`user_id`,`coupon_template_id`,`receive_count`) USING BTREE,
    KEY                  `idx_user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1816074493907447818 DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券表';

CREATE TABLE `t_user_coupon_log_0`
(
    `id`            bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`       bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_id`     bigint(20) NOT NULL COMMENT '优惠券ID',
    `operation_log` text COMMENT '操作日志',
    `create_time`   datetime DEFAULT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券操作日志表';

CREATE TABLE `t_user_coupon_log_1`
(
    `id`            bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`       bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_id`     bigint(20) NOT NULL COMMENT '优惠券ID',
    `operation_log` text COMMENT '操作日志',
    `create_time`   datetime DEFAULT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券操作日志表';

CREATE TABLE `t_user_coupon_log_10`
(
    `id`            bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`       bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_id`     bigint(20) NOT NULL COMMENT '优惠券ID',
    `operation_log` text COMMENT '操作日志',
    `create_time`   datetime DEFAULT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券操作日志表';

CREATE TABLE `t_user_coupon_log_11`
(
    `id`            bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`       bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_id`     bigint(20) NOT NULL COMMENT '优惠券ID',
    `operation_log` text COMMENT '操作日志',
    `create_time`   datetime DEFAULT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券操作日志表';

CREATE TABLE `t_user_coupon_log_12`
(
    `id`            bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`       bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_id`     bigint(20) NOT NULL COMMENT '优惠券ID',
    `operation_log` text COMMENT '操作日志',
    `create_time`   datetime DEFAULT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券操作日志表';

CREATE TABLE `t_user_coupon_log_13`
(
    `id`            bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`       bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_id`     bigint(20) NOT NULL COMMENT '优惠券ID',
    `operation_log` text COMMENT '操作日志',
    `create_time`   datetime DEFAULT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券操作日志表';

CREATE TABLE `t_user_coupon_log_14`
(
    `id`            bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`       bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_id`     bigint(20) NOT NULL COMMENT '优惠券ID',
    `operation_log` text COMMENT '操作日志',
    `create_time`   datetime DEFAULT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券操作日志表';

CREATE TABLE `t_user_coupon_log_15`
(
    `id`            bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`       bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_id`     bigint(20) NOT NULL COMMENT '优惠券ID',
    `operation_log` text COMMENT '操作日志',
    `create_time`   datetime DEFAULT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券操作日志表';

CREATE TABLE `t_user_coupon_log_2`
(
    `id`            bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`       bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_id`     bigint(20) NOT NULL COMMENT '优惠券ID',
    `operation_log` text COMMENT '操作日志',
    `create_time`   datetime DEFAULT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券操作日志表';

CREATE TABLE `t_user_coupon_log_3`
(
    `id`            bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`       bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_id`     bigint(20) NOT NULL COMMENT '优惠券ID',
    `operation_log` text COMMENT '操作日志',
    `create_time`   datetime DEFAULT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券操作日志表';

CREATE TABLE `t_user_coupon_log_4`
(
    `id`            bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`       bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_id`     bigint(20) NOT NULL COMMENT '优惠券ID',
    `operation_log` text COMMENT '操作日志',
    `create_time`   datetime DEFAULT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券操作日志表';

CREATE TABLE `t_user_coupon_log_5`
(
    `id`            bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`       bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_id`     bigint(20) NOT NULL COMMENT '优惠券ID',
    `operation_log` text COMMENT '操作日志',
    `create_time`   datetime DEFAULT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券操作日志表';

CREATE TABLE `t_user_coupon_log_6`
(
    `id`            bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`       bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_id`     bigint(20) NOT NULL COMMENT '优惠券ID',
    `operation_log` text COMMENT '操作日志',
    `create_time`   datetime DEFAULT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券操作日志表';

CREATE TABLE `t_user_coupon_log_7`
(
    `id`            bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`       bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_id`     bigint(20) NOT NULL COMMENT '优惠券ID',
    `operation_log` text COMMENT '操作日志',
    `create_time`   datetime DEFAULT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券操作日志表';

CREATE TABLE `t_user_coupon_log_8`
(
    `id`            bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`       bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_id`     bigint(20) NOT NULL COMMENT '优惠券ID',
    `operation_log` text COMMENT '操作日志',
    `create_time`   datetime DEFAULT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券操作日志表';

CREATE TABLE `t_user_coupon_log_9`
(
    `id`            bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`       bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_id`     bigint(20) NOT NULL COMMENT '优惠券ID',
    `operation_log` text COMMENT '操作日志',
    `create_time`   datetime DEFAULT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券操作日志表';

USE
one_coupon_1;

CREATE TABLE `t_coupon_settlement_8`
(
    `id`          bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `order_id`    bigint(20) DEFAULT NULL COMMENT '订单ID',
    `user_id`     bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_id`   bigint(20) DEFAULT NULL COMMENT '优惠券ID',
    `status`      int(11) DEFAULT NULL COMMENT '结算单状态 0：锁定 1：已取消 2：已支付 3：已退款',
    `create_time` datetime DEFAULT NULL COMMENT '创建时间',
    `update_time` datetime DEFAULT NULL COMMENT '修改时间',
    PRIMARY KEY (`id`),
    KEY           `idx_user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='优惠券结算单表';

CREATE TABLE `t_coupon_settlement_9`
(
    `id`          bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `order_id`    bigint(20) DEFAULT NULL COMMENT '订单ID',
    `user_id`     bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_id`   bigint(20) DEFAULT NULL COMMENT '优惠券ID',
    `status`      int(11) DEFAULT NULL COMMENT '结算单状态 0：锁定 1：已取消 2：已支付 3：已退款',
    `create_time` datetime DEFAULT NULL COMMENT '创建时间',
    `update_time` datetime DEFAULT NULL COMMENT '修改时间',
    PRIMARY KEY (`id`),
    KEY           `idx_user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='优惠券结算单表';

CREATE TABLE `t_coupon_settlement_10`
(
    `id`          bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `order_id`    bigint(20) DEFAULT NULL COMMENT '订单ID',
    `user_id`     bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_id`   bigint(20) DEFAULT NULL COMMENT '优惠券ID',
    `status`      int(11) DEFAULT NULL COMMENT '结算单状态 0：锁定 1：已取消 2：已支付 3：已退款',
    `create_time` datetime DEFAULT NULL COMMENT '创建时间',
    `update_time` datetime DEFAULT NULL COMMENT '修改时间',
    PRIMARY KEY (`id`),
    KEY           `idx_user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='优惠券结算单表';

CREATE TABLE `t_coupon_settlement_11`
(
    `id`          bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `order_id`    bigint(20) DEFAULT NULL COMMENT '订单ID',
    `user_id`     bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_id`   bigint(20) DEFAULT NULL COMMENT '优惠券ID',
    `status`      int(11) DEFAULT NULL COMMENT '结算单状态 0：锁定 1：已取消 2：已支付 3：已退款',
    `create_time` datetime DEFAULT NULL COMMENT '创建时间',
    `update_time` datetime DEFAULT NULL COMMENT '修改时间',
    PRIMARY KEY (`id`),
    KEY           `idx_user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='优惠券结算单表';

CREATE TABLE `t_coupon_settlement_12`
(
    `id`          bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `order_id`    bigint(20) DEFAULT NULL COMMENT '订单ID',
    `user_id`     bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_id`   bigint(20) DEFAULT NULL COMMENT '优惠券ID',
    `status`      int(11) DEFAULT NULL COMMENT '结算单状态 0：锁定 1：已取消 2：已支付 3：已退款',
    `create_time` datetime DEFAULT NULL COMMENT '创建时间',
    `update_time` datetime DEFAULT NULL COMMENT '修改时间',
    PRIMARY KEY (`id`),
    KEY           `idx_user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='优惠券结算单表';

CREATE TABLE `t_coupon_settlement_13`
(
    `id`          bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `order_id`    bigint(20) DEFAULT NULL COMMENT '订单ID',
    `user_id`     bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_id`   bigint(20) DEFAULT NULL COMMENT '优惠券ID',
    `status`      int(11) DEFAULT NULL COMMENT '结算单状态 0：锁定 1：已取消 2：已支付 3：已退款',
    `create_time` datetime DEFAULT NULL COMMENT '创建时间',
    `update_time` datetime DEFAULT NULL COMMENT '修改时间',
    PRIMARY KEY (`id`),
    KEY           `idx_user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='优惠券结算单表';

CREATE TABLE `t_coupon_settlement_14`
(
    `id`          bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `order_id`    bigint(20) DEFAULT NULL COMMENT '订单ID',
    `user_id`     bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_id`   bigint(20) DEFAULT NULL COMMENT '优惠券ID',
    `status`      int(11) DEFAULT NULL COMMENT '结算单状态 0：锁定 1：已取消 2：已支付 3：已退款',
    `create_time` datetime DEFAULT NULL COMMENT '创建时间',
    `update_time` datetime DEFAULT NULL COMMENT '修改时间',
    PRIMARY KEY (`id`),
    KEY           `idx_user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='优惠券结算单表';

CREATE TABLE `t_coupon_settlement_15`
(
    `id`          bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `order_id`    bigint(20) DEFAULT NULL COMMENT '订单ID',
    `user_id`     bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_id`   bigint(20) DEFAULT NULL COMMENT '优惠券ID',
    `status`      int(11) DEFAULT NULL COMMENT '结算单状态 0：锁定 1：已取消 2：已支付 3：已退款',
    `create_time` datetime DEFAULT NULL COMMENT '创建时间',
    `update_time` datetime DEFAULT NULL COMMENT '修改时间',
    PRIMARY KEY (`id`),
    KEY           `idx_user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='优惠券结算单表';

CREATE TABLE `t_coupon_template_10`
(
    `id`               bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `name`             varchar(256) DEFAULT NULL COMMENT '优惠券名称',
    `shop_number`      bigint(20) DEFAULT NULL COMMENT '店铺编号',
    `source`           tinyint(1) DEFAULT NULL COMMENT '优惠券来源 0：店铺券 1：平台券',
    `target`           tinyint(1) DEFAULT NULL COMMENT '优惠对象 0：商品专属 1：全店通用',
    `goods`            varchar(64)  DEFAULT NULL COMMENT '优惠商品编码',
    `type`             tinyint(1) DEFAULT NULL COMMENT '优惠类型 0：立减券 1：满减券 2：折扣券',
    `valid_start_time` datetime     DEFAULT NULL COMMENT '有效期开始时间',
    `valid_end_time`   datetime     DEFAULT NULL COMMENT '有效期结束时间',
    `stock`            int(11) DEFAULT NULL COMMENT '库存',
    `receive_rule`     json         DEFAULT NULL COMMENT '领取规则',
    `consume_rule`     json         DEFAULT NULL COMMENT '消耗规则',
    `status`           tinyint(1) DEFAULT NULL COMMENT '优惠券状态 0：生效中 1：已结束',
    `create_time`      datetime     DEFAULT NULL COMMENT '创建时间',
    `update_time`      datetime     DEFAULT NULL COMMENT '修改时间',
    `del_flag`         tinyint(1) DEFAULT NULL COMMENT '删除标识 0：未删除 1：已删除',
    PRIMARY KEY (`id`),
    KEY                `idx_shop_number` (`shop_number`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1810967787024273416 DEFAULT CHARSET=utf8mb4 COMMENT='优惠券模板表';

CREATE TABLE `t_coupon_template_11`
(
    `id`               bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `name`             varchar(256) DEFAULT NULL COMMENT '优惠券名称',
    `shop_number`      bigint(20) DEFAULT NULL COMMENT '店铺编号',
    `source`           tinyint(1) DEFAULT NULL COMMENT '优惠券来源 0：店铺券 1：平台券',
    `target`           tinyint(1) DEFAULT NULL COMMENT '优惠对象 0：商品专属 1：全店通用',
    `goods`            varchar(64)  DEFAULT NULL COMMENT '优惠商品编码',
    `type`             tinyint(1) DEFAULT NULL COMMENT '优惠类型 0：立减券 1：满减券 2：折扣券',
    `valid_start_time` datetime     DEFAULT NULL COMMENT '有效期开始时间',
    `valid_end_time`   datetime     DEFAULT NULL COMMENT '有效期结束时间',
    `stock`            int(11) DEFAULT NULL COMMENT '库存',
    `receive_rule`     json         DEFAULT NULL COMMENT '领取规则',
    `consume_rule`     json         DEFAULT NULL COMMENT '消耗规则',
    `status`           tinyint(1) DEFAULT NULL COMMENT '优惠券状态 0：生效中 1：已结束',
    `create_time`      datetime     DEFAULT NULL COMMENT '创建时间',
    `update_time`      datetime     DEFAULT NULL COMMENT '修改时间',
    `del_flag`         tinyint(1) DEFAULT NULL COMMENT '删除标识 0：未删除 1：已删除',
    PRIMARY KEY (`id`),
    KEY                `idx_shop_number` (`shop_number`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1810967787062022148 DEFAULT CHARSET=utf8mb4 COMMENT='优惠券模板表';

CREATE TABLE `t_coupon_template_12`
(
    `id`               bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `name`             varchar(256) DEFAULT NULL COMMENT '优惠券名称',
    `shop_number`      bigint(20) DEFAULT NULL COMMENT '店铺编号',
    `source`           tinyint(1) DEFAULT NULL COMMENT '优惠券来源 0：店铺券 1：平台券',
    `target`           tinyint(1) DEFAULT NULL COMMENT '优惠对象 0：商品专属 1：全店通用',
    `goods`            varchar(64)  DEFAULT NULL COMMENT '优惠商品编码',
    `type`             tinyint(1) DEFAULT NULL COMMENT '优惠类型 0：立减券 1：满减券 2：折扣券',
    `valid_start_time` datetime     DEFAULT NULL COMMENT '有效期开始时间',
    `valid_end_time`   datetime     DEFAULT NULL COMMENT '有效期结束时间',
    `stock`            int(11) DEFAULT NULL COMMENT '库存',
    `receive_rule`     json         DEFAULT NULL COMMENT '领取规则',
    `consume_rule`     json         DEFAULT NULL COMMENT '消耗规则',
    `status`           tinyint(1) DEFAULT NULL COMMENT '优惠券状态 0：生效中 1：已结束',
    `create_time`      datetime     DEFAULT NULL COMMENT '创建时间',
    `update_time`      datetime     DEFAULT NULL COMMENT '修改时间',
    `del_flag`         tinyint(1) DEFAULT NULL COMMENT '删除标识 0：未删除 1：已删除',
    PRIMARY KEY (`id`),
    KEY                `idx_shop_number` (`shop_number`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1810967795496767492 DEFAULT CHARSET=utf8mb4 COMMENT='优惠券模板表';

CREATE TABLE `t_coupon_template_13`
(
    `id`               bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `name`             varchar(256) DEFAULT NULL COMMENT '优惠券名称',
    `shop_number`      bigint(20) DEFAULT NULL COMMENT '店铺编号',
    `source`           tinyint(1) DEFAULT NULL COMMENT '优惠券来源 0：店铺券 1：平台券',
    `target`           tinyint(1) DEFAULT NULL COMMENT '优惠对象 0：商品专属 1：全店通用',
    `goods`            varchar(64)  DEFAULT NULL COMMENT '优惠商品编码',
    `type`             tinyint(1) DEFAULT NULL COMMENT '优惠类型 0：立减券 1：满减券 2：折扣券',
    `valid_start_time` datetime     DEFAULT NULL COMMENT '有效期开始时间',
    `valid_end_time`   datetime     DEFAULT NULL COMMENT '有效期结束时间',
    `stock`            int(11) DEFAULT NULL COMMENT '库存',
    `receive_rule`     json         DEFAULT NULL COMMENT '领取规则',
    `consume_rule`     json         DEFAULT NULL COMMENT '消耗规则',
    `status`           tinyint(1) DEFAULT NULL COMMENT '优惠券状态 0：生效中 1：已结束',
    `create_time`      datetime     DEFAULT NULL COMMENT '创建时间',
    `update_time`      datetime     DEFAULT NULL COMMENT '修改时间',
    `del_flag`         tinyint(1) DEFAULT NULL COMMENT '删除标识 0：未删除 1：已删除',
    PRIMARY KEY (`id`),
    KEY                `idx_shop_number` (`shop_number`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1810967817328119814 DEFAULT CHARSET=utf8mb4 COMMENT='优惠券模板表';

CREATE TABLE `t_coupon_template_14`
(
    `id`               bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `name`             varchar(256) DEFAULT NULL COMMENT '优惠券名称',
    `shop_number`      bigint(20) DEFAULT NULL COMMENT '店铺编号',
    `source`           tinyint(1) DEFAULT NULL COMMENT '优惠券来源 0：店铺券 1：平台券',
    `target`           tinyint(1) DEFAULT NULL COMMENT '优惠对象 0：商品专属 1：全店通用',
    `goods`            varchar(64)  DEFAULT NULL COMMENT '优惠商品编码',
    `type`             tinyint(1) DEFAULT NULL COMMENT '优惠类型 0：立减券 1：满减券 2：折扣券',
    `valid_start_time` datetime     DEFAULT NULL COMMENT '有效期开始时间',
    `valid_end_time`   datetime     DEFAULT NULL COMMENT '有效期结束时间',
    `stock`            int(11) DEFAULT NULL COMMENT '库存',
    `receive_rule`     json         DEFAULT NULL COMMENT '领取规则',
    `consume_rule`     json         DEFAULT NULL COMMENT '消耗规则',
    `status`           tinyint(1) DEFAULT NULL COMMENT '优惠券状态 0：生效中 1：已结束',
    `create_time`      datetime     DEFAULT NULL COMMENT '创建时间',
    `update_time`      datetime     DEFAULT NULL COMMENT '修改时间',
    `del_flag`         tinyint(1) DEFAULT NULL COMMENT '删除标识 0：未删除 1：已删除',
    PRIMARY KEY (`id`),
    KEY                `idx_shop_number` (`shop_number`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1810967817407811587 DEFAULT CHARSET=utf8mb4 COMMENT='优惠券模板表';

CREATE TABLE `t_coupon_template_15`
(
    `id`               bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `name`             varchar(256) DEFAULT NULL COMMENT '优惠券名称',
    `shop_number`      bigint(20) DEFAULT NULL COMMENT '店铺编号',
    `source`           tinyint(1) DEFAULT NULL COMMENT '优惠券来源 0：店铺券 1：平台券',
    `target`           tinyint(1) DEFAULT NULL COMMENT '优惠对象 0：商品专属 1：全店通用',
    `goods`            varchar(64)  DEFAULT NULL COMMENT '优惠商品编码',
    `type`             tinyint(1) DEFAULT NULL COMMENT '优惠类型 0：立减券 1：满减券 2：折扣券',
    `valid_start_time` datetime     DEFAULT NULL COMMENT '有效期开始时间',
    `valid_end_time`   datetime     DEFAULT NULL COMMENT '有效期结束时间',
    `stock`            int(11) DEFAULT NULL COMMENT '库存',
    `receive_rule`     json         DEFAULT NULL COMMENT '领取规则',
    `consume_rule`     json         DEFAULT NULL COMMENT '消耗规则',
    `status`           tinyint(1) DEFAULT NULL COMMENT '优惠券状态 0：生效中 1：已结束',
    `create_time`      datetime     DEFAULT NULL COMMENT '创建时间',
    `update_time`      datetime     DEFAULT NULL COMMENT '修改时间',
    `del_flag`         tinyint(1) DEFAULT NULL COMMENT '删除标识 0：未删除 1：已删除',
    PRIMARY KEY (`id`),
    KEY                `idx_shop_number` (`shop_number`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1811614173755469826 DEFAULT CHARSET=utf8mb4 COMMENT='优惠券模板表';

CREATE TABLE `t_coupon_template_8`
(
    `id`               bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `name`             varchar(256) DEFAULT NULL COMMENT '优惠券名称',
    `shop_number`      bigint(20) DEFAULT NULL COMMENT '店铺编号',
    `source`           tinyint(1) DEFAULT NULL COMMENT '优惠券来源 0：店铺券 1：平台券',
    `target`           tinyint(1) DEFAULT NULL COMMENT '优惠对象 0：商品专属 1：全店通用',
    `goods`            varchar(64)  DEFAULT NULL COMMENT '优惠商品编码',
    `type`             tinyint(1) DEFAULT NULL COMMENT '优惠类型 0：立减券 1：满减券 2：折扣券',
    `valid_start_time` datetime     DEFAULT NULL COMMENT '有效期开始时间',
    `valid_end_time`   datetime     DEFAULT NULL COMMENT '有效期结束时间',
    `stock`            int(11) DEFAULT NULL COMMENT '库存',
    `receive_rule`     json         DEFAULT NULL COMMENT '领取规则',
    `consume_rule`     json         DEFAULT NULL COMMENT '消耗规则',
    `status`           tinyint(1) DEFAULT NULL COMMENT '优惠券状态 0：生效中 1：已结束',
    `create_time`      datetime     DEFAULT NULL COMMENT '创建时间',
    `update_time`      datetime     DEFAULT NULL COMMENT '修改时间',
    `del_flag`         tinyint(1) DEFAULT NULL COMMENT '删除标识 0：未删除 1：已删除',
    PRIMARY KEY (`id`),
    KEY                `idx_shop_number` (`shop_number`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1810967783614304261 DEFAULT CHARSET=utf8mb4 COMMENT='优惠券模板表';

CREATE TABLE `t_coupon_template_9`
(
    `id`               bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `name`             varchar(256) DEFAULT NULL COMMENT '优惠券名称',
    `shop_number`      bigint(20) DEFAULT NULL COMMENT '店铺编号',
    `source`           tinyint(1) DEFAULT NULL COMMENT '优惠券来源 0：店铺券 1：平台券',
    `target`           tinyint(1) DEFAULT NULL COMMENT '优惠对象 0：商品专属 1：全店通用',
    `goods`            varchar(64)  DEFAULT NULL COMMENT '优惠商品编码',
    `type`             tinyint(1) DEFAULT NULL COMMENT '优惠类型 0：立减券 1：满减券 2：折扣券',
    `valid_start_time` datetime     DEFAULT NULL COMMENT '有效期开始时间',
    `valid_end_time`   datetime     DEFAULT NULL COMMENT '有效期结束时间',
    `stock`            int(11) DEFAULT NULL COMMENT '库存',
    `receive_rule`     json         DEFAULT NULL COMMENT '领取规则',
    `consume_rule`     json         DEFAULT NULL COMMENT '消耗规则',
    `status`           tinyint(1) DEFAULT NULL COMMENT '优惠券状态 0：生效中 1：已结束',
    `create_time`      datetime     DEFAULT NULL COMMENT '创建时间',
    `update_time`      datetime     DEFAULT NULL COMMENT '修改时间',
    `del_flag`         tinyint(1) DEFAULT NULL COMMENT '删除标识 0：未删除 1：已删除',
    PRIMARY KEY (`id`),
    KEY                `idx_shop_number` (`shop_number`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1810967778472087554 DEFAULT CHARSET=utf8mb4 COMMENT='优惠券模板表';

CREATE TABLE `t_coupon_template_log_10`
(
    `id`                 bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `shop_number`        bigint(20) DEFAULT NULL COMMENT '店铺编号',
    `coupon_template_id` bigint(20) DEFAULT NULL COMMENT '优惠券模板ID',
    `operator_id`        bigint(20) DEFAULT NULL COMMENT '操作人',
    `operation_log`      text COMMENT '操作日志',
    `original_data`      varchar(1024) DEFAULT NULL COMMENT '原始数据',
    `modified_data`      varchar(1024) DEFAULT NULL COMMENT '修改后数据',
    `create_time`        datetime      DEFAULT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`),
    KEY                  `idx_shop_number` (`shop_number`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='优惠券模板操作日志表';

CREATE TABLE `t_coupon_template_log_11`
(
    `id`                 bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `shop_number`        bigint(20) DEFAULT NULL COMMENT '店铺编号',
    `coupon_template_id` bigint(20) DEFAULT NULL COMMENT '优惠券模板ID',
    `operator_id`        bigint(20) DEFAULT NULL COMMENT '操作人',
    `operation_log`      text COMMENT '操作日志',
    `original_data`      varchar(1024) DEFAULT NULL COMMENT '原始数据',
    `modified_data`      varchar(1024) DEFAULT NULL COMMENT '修改后数据',
    `create_time`        datetime      DEFAULT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`),
    KEY                  `idx_shop_number` (`shop_number`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='优惠券模板操作日志表';

CREATE TABLE `t_coupon_template_log_12`
(
    `id`                 bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `shop_number`        bigint(20) DEFAULT NULL COMMENT '店铺编号',
    `coupon_template_id` bigint(20) DEFAULT NULL COMMENT '优惠券模板ID',
    `operator_id`        bigint(20) DEFAULT NULL COMMENT '操作人',
    `operation_log`      text COMMENT '操作日志',
    `original_data`      varchar(1024) DEFAULT NULL COMMENT '原始数据',
    `modified_data`      varchar(1024) DEFAULT NULL COMMENT '修改后数据',
    `create_time`        datetime      DEFAULT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`),
    KEY                  `idx_shop_number` (`shop_number`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='优惠券模板操作日志表';

CREATE TABLE `t_coupon_template_log_13`
(
    `id`                 bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `shop_number`        bigint(20) DEFAULT NULL COMMENT '店铺编号',
    `coupon_template_id` bigint(20) DEFAULT NULL COMMENT '优惠券模板ID',
    `operator_id`        bigint(20) DEFAULT NULL COMMENT '操作人',
    `operation_log`      text COMMENT '操作日志',
    `original_data`      varchar(1024) DEFAULT NULL COMMENT '原始数据',
    `modified_data`      varchar(1024) DEFAULT NULL COMMENT '修改后数据',
    `create_time`        datetime      DEFAULT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`),
    KEY                  `idx_shop_number` (`shop_number`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='优惠券模板操作日志表';

CREATE TABLE `t_coupon_template_log_14`
(
    `id`                 bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `shop_number`        bigint(20) DEFAULT NULL COMMENT '店铺编号',
    `coupon_template_id` bigint(20) DEFAULT NULL COMMENT '优惠券模板ID',
    `operator_id`        bigint(20) DEFAULT NULL COMMENT '操作人',
    `operation_log`      text COMMENT '操作日志',
    `original_data`      varchar(1024) DEFAULT NULL COMMENT '原始数据',
    `modified_data`      varchar(1024) DEFAULT NULL COMMENT '修改后数据',
    `create_time`        datetime      DEFAULT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`),
    KEY                  `idx_shop_number` (`shop_number`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='优惠券模板操作日志表';

CREATE TABLE `t_coupon_template_log_15`
(
    `id`                 bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `shop_number`        bigint(20) DEFAULT NULL COMMENT '店铺编号',
    `coupon_template_id` bigint(20) DEFAULT NULL COMMENT '优惠券模板ID',
    `operator_id`        bigint(20) DEFAULT NULL COMMENT '操作人',
    `operation_log`      text COMMENT '操作日志',
    `original_data`      varchar(1024) DEFAULT NULL COMMENT '原始数据',
    `modified_data`      varchar(1024) DEFAULT NULL COMMENT '修改后数据',
    `create_time`        datetime      DEFAULT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`),
    KEY                  `idx_shop_number` (`shop_number`) USING BTREE
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4 COMMENT='优惠券模板操作日志表';

CREATE TABLE `t_coupon_template_log_8`
(
    `id`                 bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `shop_number`        bigint(20) DEFAULT NULL COMMENT '店铺编号',
    `coupon_template_id` bigint(20) DEFAULT NULL COMMENT '优惠券模板ID',
    `operator_id`        bigint(20) DEFAULT NULL COMMENT '操作人',
    `operation_log`      text COMMENT '操作日志',
    `original_data`      varchar(1024) DEFAULT NULL COMMENT '原始数据',
    `modified_data`      varchar(1024) DEFAULT NULL COMMENT '修改后数据',
    `create_time`        datetime      DEFAULT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`),
    KEY                  `idx_shop_number` (`shop_number`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='优惠券模板操作日志表';

CREATE TABLE `t_coupon_template_log_9`
(
    `id`                 bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `shop_number`        bigint(20) DEFAULT NULL COMMENT '店铺编号',
    `coupon_template_id` bigint(20) DEFAULT NULL COMMENT '优惠券模板ID',
    `operator_id`        bigint(20) DEFAULT NULL COMMENT '操作人',
    `operation_log`      text COMMENT '操作日志',
    `original_data`      varchar(1024) DEFAULT NULL COMMENT '原始数据',
    `modified_data`      varchar(1024) DEFAULT NULL COMMENT '修改后数据',
    `create_time`        datetime      DEFAULT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`),
    KEY                  `idx_shop_number` (`shop_number`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='优惠券模板操作日志表';

CREATE TABLE `t_user_coupon_16`
(
    `id`                 bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`            bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_template_id` bigint(20) DEFAULT NULL COMMENT '优惠券模板ID',
    `receive_time`       datetime DEFAULT NULL COMMENT '领取时间',
    `receive_count`      int(3) DEFAULT NULL COMMENT '领取次数',
    `valid_start_time`   datetime DEFAULT NULL COMMENT '有效期开始时间',
    `valid_end_time`     datetime DEFAULT NULL COMMENT '有效期结束时间',
    `use_time`           datetime DEFAULT NULL COMMENT '使用时间',
    `source`             tinyint(1) DEFAULT NULL COMMENT '券来源 0：领券中心 1：平台发放 2：店铺领取',
    `status`             tinyint(1) DEFAULT NULL COMMENT '状态 0：未使用 1：锁定 2：已使用 3：已过期 4：已撤回',
    `create_time`        datetime DEFAULT NULL COMMENT '创建时间',
    `update_time`        datetime DEFAULT NULL COMMENT '修改时间',
    `del_flag`           tinyint(1) DEFAULT NULL COMMENT '删除标识 0：未删除 1：已删除',
    PRIMARY KEY (`id`),
    UNIQUE KEY `idx_user_id_coupon_template_receive_count` (`user_id`,`coupon_template_id`,`receive_count`) USING BTREE,
    KEY                  `idx_user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1816074493920030730 DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券表';

CREATE TABLE `t_user_coupon_17`
(
    `id`                 bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`            bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_template_id` bigint(20) DEFAULT NULL COMMENT '优惠券模板ID',
    `receive_time`       datetime DEFAULT NULL COMMENT '领取时间',
    `receive_count`      int(3) DEFAULT NULL COMMENT '领取次数',
    `valid_start_time`   datetime DEFAULT NULL COMMENT '有效期开始时间',
    `valid_end_time`     datetime DEFAULT NULL COMMENT '有效期结束时间',
    `use_time`           datetime DEFAULT NULL COMMENT '使用时间',
    `source`             tinyint(1) DEFAULT NULL COMMENT '券来源 0：领券中心 1：平台发放 2：店铺领取',
    `status`             tinyint(1) DEFAULT NULL COMMENT '状态 0：未使用 1：锁定 2：已使用 3：已过期 4：已撤回',
    `create_time`        datetime DEFAULT NULL COMMENT '创建时间',
    `update_time`        datetime DEFAULT NULL COMMENT '修改时间',
    `del_flag`           tinyint(1) DEFAULT NULL COMMENT '删除标识 0：未删除 1：已删除',
    PRIMARY KEY (`id`),
    UNIQUE KEY `idx_user_id_coupon_template_receive_count` (`user_id`,`coupon_template_id`,`receive_count`) USING BTREE,
    KEY                  `idx_user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1816074493924225030 DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券表';

CREATE TABLE `t_user_coupon_18`
(
    `id`                 bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`            bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_template_id` bigint(20) DEFAULT NULL COMMENT '优惠券模板ID',
    `receive_time`       datetime DEFAULT NULL COMMENT '领取时间',
    `receive_count`      int(3) DEFAULT NULL COMMENT '领取次数',
    `valid_start_time`   datetime DEFAULT NULL COMMENT '有效期开始时间',
    `valid_end_time`     datetime DEFAULT NULL COMMENT '有效期结束时间',
    `use_time`           datetime DEFAULT NULL COMMENT '使用时间',
    `source`             tinyint(1) DEFAULT NULL COMMENT '券来源 0：领券中心 1：平台发放 2：店铺领取',
    `status`             tinyint(1) DEFAULT NULL COMMENT '状态 0：未使用 1：锁定 2：已使用 3：已过期 4：已撤回',
    `create_time`        datetime DEFAULT NULL COMMENT '创建时间',
    `update_time`        datetime DEFAULT NULL COMMENT '修改时间',
    `del_flag`           tinyint(1) DEFAULT NULL COMMENT '删除标识 0：未删除 1：已删除',
    PRIMARY KEY (`id`),
    UNIQUE KEY `idx_user_id_coupon_template_receive_count` (`user_id`,`coupon_template_id`,`receive_count`) USING BTREE,
    KEY                  `idx_user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1816074493915836432 DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券表';

CREATE TABLE `t_user_coupon_19`
(
    `id`                 bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`            bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_template_id` bigint(20) DEFAULT NULL COMMENT '优惠券模板ID',
    `receive_time`       datetime DEFAULT NULL COMMENT '领取时间',
    `receive_count`      int(3) DEFAULT NULL COMMENT '领取次数',
    `valid_start_time`   datetime DEFAULT NULL COMMENT '有效期开始时间',
    `valid_end_time`     datetime DEFAULT NULL COMMENT '有效期结束时间',
    `use_time`           datetime DEFAULT NULL COMMENT '使用时间',
    `source`             tinyint(1) DEFAULT NULL COMMENT '券来源 0：领券中心 1：平台发放 2：店铺领取',
    `status`             tinyint(1) DEFAULT NULL COMMENT '状态 0：未使用 1：锁定 2：已使用 3：已过期 4：已撤回',
    `create_time`        datetime DEFAULT NULL COMMENT '创建时间',
    `update_time`        datetime DEFAULT NULL COMMENT '修改时间',
    `del_flag`           tinyint(1) DEFAULT NULL COMMENT '删除标识 0：未删除 1：已删除',
    PRIMARY KEY (`id`),
    UNIQUE KEY `idx_user_id_coupon_template_receive_count` (`user_id`,`coupon_template_id`,`receive_count`) USING BTREE,
    KEY                  `idx_user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1816074493924225027 DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券表';

CREATE TABLE `t_user_coupon_20`
(
    `id`                 bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`            bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_template_id` bigint(20) DEFAULT NULL COMMENT '优惠券模板ID',
    `receive_time`       datetime DEFAULT NULL COMMENT '领取时间',
    `receive_count`      int(3) DEFAULT NULL COMMENT '领取次数',
    `valid_start_time`   datetime DEFAULT NULL COMMENT '有效期开始时间',
    `valid_end_time`     datetime DEFAULT NULL COMMENT '有效期结束时间',
    `use_time`           datetime DEFAULT NULL COMMENT '使用时间',
    `source`             tinyint(1) DEFAULT NULL COMMENT '券来源 0：领券中心 1：平台发放 2：店铺领取',
    `status`             tinyint(1) DEFAULT NULL COMMENT '状态 0：未使用 1：锁定 2：已使用 3：已过期 4：已撤回',
    `create_time`        datetime DEFAULT NULL COMMENT '创建时间',
    `update_time`        datetime DEFAULT NULL COMMENT '修改时间',
    `del_flag`           tinyint(1) DEFAULT NULL COMMENT '删除标识 0：未删除 1：已删除',
    PRIMARY KEY (`id`),
    UNIQUE KEY `idx_user_id_coupon_template_receive_count` (`user_id`,`coupon_template_id`,`receive_count`) USING BTREE,
    KEY                  `idx_user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1816074493924225029 DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券表';

CREATE TABLE `t_user_coupon_21`
(
    `id`                 bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`            bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_template_id` bigint(20) DEFAULT NULL COMMENT '优惠券模板ID',
    `receive_time`       datetime DEFAULT NULL COMMENT '领取时间',
    `receive_count`      int(3) DEFAULT NULL COMMENT '领取次数',
    `valid_start_time`   datetime DEFAULT NULL COMMENT '有效期开始时间',
    `valid_end_time`     datetime DEFAULT NULL COMMENT '有效期结束时间',
    `use_time`           datetime DEFAULT NULL COMMENT '使用时间',
    `source`             tinyint(1) DEFAULT NULL COMMENT '券来源 0：领券中心 1：平台发放 2：店铺领取',
    `status`             tinyint(1) DEFAULT NULL COMMENT '状态 0：未使用 1：锁定 2：已使用 3：已过期 4：已撤回',
    `create_time`        datetime DEFAULT NULL COMMENT '创建时间',
    `update_time`        datetime DEFAULT NULL COMMENT '修改时间',
    `del_flag`           tinyint(1) DEFAULT NULL COMMENT '删除标识 0：未删除 1：已删除',
    PRIMARY KEY (`id`),
    UNIQUE KEY `idx_user_id_coupon_template_receive_count` (`user_id`,`coupon_template_id`,`receive_count`) USING BTREE,
    KEY                  `idx_user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1816074493920030736 DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券表';

CREATE TABLE `t_user_coupon_22`
(
    `id`                 bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`            bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_template_id` bigint(20) DEFAULT NULL COMMENT '优惠券模板ID',
    `receive_time`       datetime DEFAULT NULL COMMENT '领取时间',
    `receive_count`      int(3) DEFAULT NULL COMMENT '领取次数',
    `valid_start_time`   datetime DEFAULT NULL COMMENT '有效期开始时间',
    `valid_end_time`     datetime DEFAULT NULL COMMENT '有效期结束时间',
    `use_time`           datetime DEFAULT NULL COMMENT '使用时间',
    `source`             tinyint(1) DEFAULT NULL COMMENT '券来源 0：领券中心 1：平台发放 2：店铺领取',
    `status`             tinyint(1) DEFAULT NULL COMMENT '状态 0：未使用 1：锁定 2：已使用 3：已过期 4：已撤回',
    `create_time`        datetime DEFAULT NULL COMMENT '创建时间',
    `update_time`        datetime DEFAULT NULL COMMENT '修改时间',
    `del_flag`           tinyint(1) DEFAULT NULL COMMENT '删除标识 0：未删除 1：已删除',
    PRIMARY KEY (`id`),
    UNIQUE KEY `idx_user_id_coupon_template_receive_count` (`user_id`,`coupon_template_id`,`receive_count`) USING BTREE,
    KEY                  `idx_user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1816074493924225026 DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券表';

CREATE TABLE `t_user_coupon_23`
(
    `id`                 bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`            bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_template_id` bigint(20) DEFAULT NULL COMMENT '优惠券模板ID',
    `receive_time`       datetime DEFAULT NULL COMMENT '领取时间',
    `receive_count`      int(3) DEFAULT NULL COMMENT '领取次数',
    `valid_start_time`   datetime DEFAULT NULL COMMENT '有效期开始时间',
    `valid_end_time`     datetime DEFAULT NULL COMMENT '有效期结束时间',
    `use_time`           datetime DEFAULT NULL COMMENT '使用时间',
    `source`             tinyint(1) DEFAULT NULL COMMENT '券来源 0：领券中心 1：平台发放 2：店铺领取',
    `status`             tinyint(1) DEFAULT NULL COMMENT '状态 0：未使用 1：锁定 2：已使用 3：已过期 4：已撤回',
    `create_time`        datetime DEFAULT NULL COMMENT '创建时间',
    `update_time`        datetime DEFAULT NULL COMMENT '修改时间',
    `del_flag`           tinyint(1) DEFAULT NULL COMMENT '删除标识 0：未删除 1：已删除',
    PRIMARY KEY (`id`),
    UNIQUE KEY `idx_user_id_coupon_template_receive_count` (`user_id`,`coupon_template_id`,`receive_count`) USING BTREE,
    KEY                  `idx_user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1816074493920030726 DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券表';

CREATE TABLE `t_user_coupon_24`
(
    `id`                 bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`            bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_template_id` bigint(20) DEFAULT NULL COMMENT '优惠券模板ID',
    `receive_time`       datetime DEFAULT NULL COMMENT '领取时间',
    `receive_count`      int(3) DEFAULT NULL COMMENT '领取次数',
    `valid_start_time`   datetime DEFAULT NULL COMMENT '有效期开始时间',
    `valid_end_time`     datetime DEFAULT NULL COMMENT '有效期结束时间',
    `use_time`           datetime DEFAULT NULL COMMENT '使用时间',
    `source`             tinyint(1) DEFAULT NULL COMMENT '券来源 0：领券中心 1：平台发放 2：店铺领取',
    `status`             tinyint(1) DEFAULT NULL COMMENT '状态 0：未使用 1：锁定 2：已使用 3：已过期 4：已撤回',
    `create_time`        datetime DEFAULT NULL COMMENT '创建时间',
    `update_time`        datetime DEFAULT NULL COMMENT '修改时间',
    `del_flag`           tinyint(1) DEFAULT NULL COMMENT '删除标识 0：未删除 1：已删除',
    PRIMARY KEY (`id`),
    UNIQUE KEY `idx_user_id_coupon_template_receive_count` (`user_id`,`coupon_template_id`,`receive_count`) USING BTREE,
    KEY                  `idx_user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1816074493924225033 DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券表';

CREATE TABLE `t_user_coupon_25`
(
    `id`                 bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`            bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_template_id` bigint(20) DEFAULT NULL COMMENT '优惠券模板ID',
    `receive_time`       datetime DEFAULT NULL COMMENT '领取时间',
    `receive_count`      int(3) DEFAULT NULL COMMENT '领取次数',
    `valid_start_time`   datetime DEFAULT NULL COMMENT '有效期开始时间',
    `valid_end_time`     datetime DEFAULT NULL COMMENT '有效期结束时间',
    `use_time`           datetime DEFAULT NULL COMMENT '使用时间',
    `source`             tinyint(1) DEFAULT NULL COMMENT '券来源 0：领券中心 1：平台发放 2：店铺领取',
    `status`             tinyint(1) DEFAULT NULL COMMENT '状态 0：未使用 1：锁定 2：已使用 3：已过期 4：已撤回',
    `create_time`        datetime DEFAULT NULL COMMENT '创建时间',
    `update_time`        datetime DEFAULT NULL COMMENT '修改时间',
    `del_flag`           tinyint(1) DEFAULT NULL COMMENT '删除标识 0：未删除 1：已删除',
    PRIMARY KEY (`id`),
    UNIQUE KEY `idx_user_id_coupon_template_receive_count` (`user_id`,`coupon_template_id`,`receive_count`) USING BTREE,
    KEY                  `idx_user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1816074493920030729 DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券表';

CREATE TABLE `t_user_coupon_26`
(
    `id`                 bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`            bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_template_id` bigint(20) DEFAULT NULL COMMENT '优惠券模板ID',
    `receive_time`       datetime DEFAULT NULL COMMENT '领取时间',
    `receive_count`      int(3) DEFAULT NULL COMMENT '领取次数',
    `valid_start_time`   datetime DEFAULT NULL COMMENT '有效期开始时间',
    `valid_end_time`     datetime DEFAULT NULL COMMENT '有效期结束时间',
    `use_time`           datetime DEFAULT NULL COMMENT '使用时间',
    `source`             tinyint(1) DEFAULT NULL COMMENT '券来源 0：领券中心 1：平台发放 2：店铺领取',
    `status`             tinyint(1) DEFAULT NULL COMMENT '状态 0：未使用 1：锁定 2：已使用 3：已过期 4：已撤回',
    `create_time`        datetime DEFAULT NULL COMMENT '创建时间',
    `update_time`        datetime DEFAULT NULL COMMENT '修改时间',
    `del_flag`           tinyint(1) DEFAULT NULL COMMENT '删除标识 0：未删除 1：已删除',
    PRIMARY KEY (`id`),
    UNIQUE KEY `idx_user_id_coupon_template_receive_count` (`user_id`,`coupon_template_id`,`receive_count`) USING BTREE,
    KEY                  `idx_user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1816074493882281996 DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券表';

CREATE TABLE `t_user_coupon_27`
(
    `id`                 bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`            bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_template_id` bigint(20) DEFAULT NULL COMMENT '优惠券模板ID',
    `receive_time`       datetime DEFAULT NULL COMMENT '领取时间',
    `receive_count`      int(3) DEFAULT NULL COMMENT '领取次数',
    `valid_start_time`   datetime DEFAULT NULL COMMENT '有效期开始时间',
    `valid_end_time`     datetime DEFAULT NULL COMMENT '有效期结束时间',
    `use_time`           datetime DEFAULT NULL COMMENT '使用时间',
    `source`             tinyint(1) DEFAULT NULL COMMENT '券来源 0：领券中心 1：平台发放 2：店铺领取',
    `status`             tinyint(1) DEFAULT NULL COMMENT '状态 0：未使用 1：锁定 2：已使用 3：已过期 4：已撤回',
    `create_time`        datetime DEFAULT NULL COMMENT '创建时间',
    `update_time`        datetime DEFAULT NULL COMMENT '修改时间',
    `del_flag`           tinyint(1) DEFAULT NULL COMMENT '删除标识 0：未删除 1：已删除',
    PRIMARY KEY (`id`),
    UNIQUE KEY `idx_user_id_coupon_template_receive_count` (`user_id`,`coupon_template_id`,`receive_count`) USING BTREE,
    KEY                  `idx_user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1816074493911642125 DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券表';

CREATE TABLE `t_user_coupon_28`
(
    `id`                 bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`            bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_template_id` bigint(20) DEFAULT NULL COMMENT '优惠券模板ID',
    `receive_time`       datetime DEFAULT NULL COMMENT '领取时间',
    `receive_count`      int(3) DEFAULT NULL COMMENT '领取次数',
    `valid_start_time`   datetime DEFAULT NULL COMMENT '有效期开始时间',
    `valid_end_time`     datetime DEFAULT NULL COMMENT '有效期结束时间',
    `use_time`           datetime DEFAULT NULL COMMENT '使用时间',
    `source`             tinyint(1) DEFAULT NULL COMMENT '券来源 0：领券中心 1：平台发放 2：店铺领取',
    `status`             tinyint(1) DEFAULT NULL COMMENT '状态 0：未使用 1：锁定 2：已使用 3：已过期 4：已撤回',
    `create_time`        datetime DEFAULT NULL COMMENT '创建时间',
    `update_time`        datetime DEFAULT NULL COMMENT '修改时间',
    `del_flag`           tinyint(1) DEFAULT NULL COMMENT '删除标识 0：未删除 1：已删除',
    PRIMARY KEY (`id`),
    UNIQUE KEY `idx_user_id_coupon_template_receive_count` (`user_id`,`coupon_template_id`,`receive_count`) USING BTREE,
    KEY                  `idx_user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1816074493915836431 DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券表';

CREATE TABLE `t_user_coupon_29`
(
    `id`                 bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`            bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_template_id` bigint(20) DEFAULT NULL COMMENT '优惠券模板ID',
    `receive_time`       datetime DEFAULT NULL COMMENT '领取时间',
    `receive_count`      int(3) DEFAULT NULL COMMENT '领取次数',
    `valid_start_time`   datetime DEFAULT NULL COMMENT '有效期开始时间',
    `valid_end_time`     datetime DEFAULT NULL COMMENT '有效期结束时间',
    `use_time`           datetime DEFAULT NULL COMMENT '使用时间',
    `source`             tinyint(1) DEFAULT NULL COMMENT '券来源 0：领券中心 1：平台发放 2：店铺领取',
    `status`             tinyint(1) DEFAULT NULL COMMENT '状态 0：未使用 1：锁定 2：已使用 3：已过期 4：已撤回',
    `create_time`        datetime DEFAULT NULL COMMENT '创建时间',
    `update_time`        datetime DEFAULT NULL COMMENT '修改时间',
    `del_flag`           tinyint(1) DEFAULT NULL COMMENT '删除标识 0：未删除 1：已删除',
    PRIMARY KEY (`id`),
    UNIQUE KEY `idx_user_id_coupon_template_receive_count` (`user_id`,`coupon_template_id`,`receive_count`) USING BTREE,
    KEY                  `idx_user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1816074493899059211 DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券表';

CREATE TABLE `t_user_coupon_30`
(
    `id`                 bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`            bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_template_id` bigint(20) DEFAULT NULL COMMENT '优惠券模板ID',
    `receive_time`       datetime DEFAULT NULL COMMENT '领取时间',
    `receive_count`      int(3) DEFAULT NULL COMMENT '领取次数',
    `valid_start_time`   datetime DEFAULT NULL COMMENT '有效期开始时间',
    `valid_end_time`     datetime DEFAULT NULL COMMENT '有效期结束时间',
    `use_time`           datetime DEFAULT NULL COMMENT '使用时间',
    `source`             tinyint(1) DEFAULT NULL COMMENT '券来源 0：领券中心 1：平台发放 2：店铺领取',
    `status`             tinyint(1) DEFAULT NULL COMMENT '状态 0：未使用 1：锁定 2：已使用 3：已过期 4：已撤回',
    `create_time`        datetime DEFAULT NULL COMMENT '创建时间',
    `update_time`        datetime DEFAULT NULL COMMENT '修改时间',
    `del_flag`           tinyint(1) DEFAULT NULL COMMENT '删除标识 0：未删除 1：已删除',
    PRIMARY KEY (`id`),
    UNIQUE KEY `idx_user_id_coupon_template_receive_count` (`user_id`,`coupon_template_id`,`receive_count`) USING BTREE,
    KEY                  `idx_user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1816074493924225031 DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券表';

CREATE TABLE `t_user_coupon_31`
(
    `id`                 bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`            bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_template_id` bigint(20) DEFAULT NULL COMMENT '优惠券模板ID',
    `receive_time`       datetime DEFAULT NULL COMMENT '领取时间',
    `receive_count`      int(3) DEFAULT NULL COMMENT '领取次数',
    `valid_start_time`   datetime DEFAULT NULL COMMENT '有效期开始时间',
    `valid_end_time`     datetime DEFAULT NULL COMMENT '有效期结束时间',
    `use_time`           datetime DEFAULT NULL COMMENT '使用时间',
    `source`             tinyint(1) DEFAULT NULL COMMENT '券来源 0：领券中心 1：平台发放 2：店铺领取',
    `status`             tinyint(1) DEFAULT NULL COMMENT '状态 0：未使用 1：锁定 2：已使用 3：已过期 4：已撤回',
    `create_time`        datetime DEFAULT NULL COMMENT '创建时间',
    `update_time`        datetime DEFAULT NULL COMMENT '修改时间',
    `del_flag`           tinyint(1) DEFAULT NULL COMMENT '删除标识 0：未删除 1：已删除',
    PRIMARY KEY (`id`),
    UNIQUE KEY `idx_user_id_coupon_template_receive_count` (`user_id`,`coupon_template_id`,`receive_count`) USING BTREE,
    KEY                  `idx_user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1816074493920030722 DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券表';

CREATE TABLE `t_user_coupon_log_16`
(
    `id`            bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`       bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_id`     bigint(20) NOT NULL COMMENT '优惠券ID',
    `operation_log` text COMMENT '操作日志',
    `create_time`   datetime DEFAULT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券操作日志表';

CREATE TABLE `t_user_coupon_log_17`
(
    `id`            bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`       bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_id`     bigint(20) NOT NULL COMMENT '优惠券ID',
    `operation_log` text COMMENT '操作日志',
    `create_time`   datetime DEFAULT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券操作日志表';

CREATE TABLE `t_user_coupon_log_18`
(
    `id`            bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`       bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_id`     bigint(20) NOT NULL COMMENT '优惠券ID',
    `operation_log` text COMMENT '操作日志',
    `create_time`   datetime DEFAULT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券操作日志表';

CREATE TABLE `t_user_coupon_log_19`
(
    `id`            bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`       bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_id`     bigint(20) NOT NULL COMMENT '优惠券ID',
    `operation_log` text COMMENT '操作日志',
    `create_time`   datetime DEFAULT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券操作日志表';

CREATE TABLE `t_user_coupon_log_20`
(
    `id`            bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`       bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_id`     bigint(20) NOT NULL COMMENT '优惠券ID',
    `operation_log` text COMMENT '操作日志',
    `create_time`   datetime DEFAULT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券操作日志表';

CREATE TABLE `t_user_coupon_log_21`
(
    `id`            bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`       bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_id`     bigint(20) NOT NULL COMMENT '优惠券ID',
    `operation_log` text COMMENT '操作日志',
    `create_time`   datetime DEFAULT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券操作日志表';

CREATE TABLE `t_user_coupon_log_22`
(
    `id`            bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`       bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_id`     bigint(20) NOT NULL COMMENT '优惠券ID',
    `operation_log` text COMMENT '操作日志',
    `create_time`   datetime DEFAULT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券操作日志表';

CREATE TABLE `t_user_coupon_log_23`
(
    `id`            bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`       bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_id`     bigint(20) NOT NULL COMMENT '优惠券ID',
    `operation_log` text COMMENT '操作日志',
    `create_time`   datetime DEFAULT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券操作日志表';

CREATE TABLE `t_user_coupon_log_24`
(
    `id`            bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`       bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_id`     bigint(20) NOT NULL COMMENT '优惠券ID',
    `operation_log` text COMMENT '操作日志',
    `create_time`   datetime DEFAULT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券操作日志表';

CREATE TABLE `t_user_coupon_log_25`
(
    `id`            bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`       bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_id`     bigint(20) NOT NULL COMMENT '优惠券ID',
    `operation_log` text COMMENT '操作日志',
    `create_time`   datetime DEFAULT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券操作日志表';

CREATE TABLE `t_user_coupon_log_26`
(
    `id`            bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`       bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_id`     bigint(20) NOT NULL COMMENT '优惠券ID',
    `operation_log` text COMMENT '操作日志',
    `create_time`   datetime DEFAULT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券操作日志表';

CREATE TABLE `t_user_coupon_log_27`
(
    `id`            bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`       bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_id`     bigint(20) NOT NULL COMMENT '优惠券ID',
    `operation_log` text COMMENT '操作日志',
    `create_time`   datetime DEFAULT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券操作日志表';

CREATE TABLE `t_user_coupon_log_28`
(
    `id`            bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`       bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_id`     bigint(20) NOT NULL COMMENT '优惠券ID',
    `operation_log` text COMMENT '操作日志',
    `create_time`   datetime DEFAULT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券操作日志表';

CREATE TABLE `t_user_coupon_log_29`
(
    `id`            bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`       bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_id`     bigint(20) NOT NULL COMMENT '优惠券ID',
    `operation_log` text COMMENT '操作日志',
    `create_time`   datetime DEFAULT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券操作日志表';

CREATE TABLE `t_user_coupon_log_30`
(
    `id`            bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`       bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_id`     bigint(20) NOT NULL COMMENT '优惠券ID',
    `operation_log` text COMMENT '操作日志',
    `create_time`   datetime DEFAULT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券操作日志表';

CREATE TABLE `t_user_coupon_log_31`
(
    `id`            bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id`       bigint(20) DEFAULT NULL COMMENT '用户ID',
    `coupon_id`     bigint(20) NOT NULL COMMENT '优惠券ID',
    `operation_log` text COMMENT '操作日志',
    `create_time`   datetime DEFAULT NULL COMMENT '创建时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户优惠券操作日志表';
