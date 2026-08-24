-- 优惠券分发可靠投递与用户券到期 Outbox 改造。
-- 必须分别在 one_coupon_0 与 one_coupon_1 执行本脚本。
-- 批次 Outbox 按 shop_number 与 t_coupon_task_batch 同库；用户券到期 Outbox
-- 按 user_id 与 t_user_coupon_* 同库同表后缀，确保各自本地事务可以原子提交。

CREATE TABLE IF NOT EXISTS t_coupon_task_batch_outbox
(
    id           BIGINT       NOT NULL COMMENT 'Outbox 事件 ID（雪花）',
    batch_id     BIGINT       NOT NULL COMMENT '优惠券任务批次 ID',
    task_id      BIGINT       NOT NULL COMMENT '优惠券主任务 ID',
    shop_number  BIGINT       NOT NULL COMMENT '店铺分片键',
    event_type   VARCHAR(64)  NOT NULL COMMENT 'BATCH_READY',
    status       VARCHAR(16)  NOT NULL COMMENT 'NEW/PROCESSING/RETRY/PUBLISHED/DONE',
    retry_at     DATETIME     NOT NULL COMMENT 'NEW/RETRY 发送时间或 PUBLISHED 下次观察时间',
    attempts     INT          NOT NULL DEFAULT 0 COMMENT 'MQ 发送尝试次数',
    worker_id    VARCHAR(128) DEFAULT NULL COMMENT '当前 Outbox 租约持有者',
    lease_until  DATETIME     DEFAULT NULL COMMENT 'Outbox 租约截止时间',
    last_error   VARCHAR(500) DEFAULT NULL COMMENT '最近一次发送失败原因',
    create_time  DATETIME     NOT NULL,
    update_time  DATETIME     NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uk_shop_batch_event (shop_number, batch_id, event_type),
    KEY idx_status_retry (status, retry_at),
    KEY idx_status_lease (status, lease_until)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='优惠券分发批次就绪 Outbox';

DROP PROCEDURE IF EXISTS init_user_coupon_expire_outbox_tables;
DELIMITER //
CREATE PROCEDURE init_user_coupon_expire_outbox_tables()
BEGIN
    DECLARE table_index INT DEFAULT 0;
    WHILE table_index < 32 DO
        SET @outbox_sql = CONCAT(
            'CREATE TABLE IF NOT EXISTS t_user_coupon_expire_outbox_', table_index, ' (',
            'id BIGINT NOT NULL COMMENT ''Outbox事件ID（雪花）'', ',
            'user_coupon_id BIGINT NOT NULL COMMENT ''用户优惠券ID'', ',
            'user_id BIGINT NOT NULL COMMENT ''用户分片键'', ',
            'coupon_template_id BIGINT NOT NULL COMMENT ''优惠券模板ID'', ',
            'valid_end_time DATETIME NOT NULL COMMENT ''用户券到期时间'', ',
            'event_type VARCHAR(64) NOT NULL COMMENT ''USER_COUPON_EXPIRE'', ',
            'status VARCHAR(16) NOT NULL COMMENT ''NEW/PROCESSING/RETRY/PUBLISHED/DONE'', ',
            'retry_at DATETIME NOT NULL COMMENT ''下次可投递时间'', ',
            'attempts INT NOT NULL DEFAULT 0 COMMENT ''投递尝试次数'', ',
            'worker_id VARCHAR(128) DEFAULT NULL COMMENT ''当前租约持有者'', ',
            'lease_until DATETIME DEFAULT NULL COMMENT ''租约截止时间'', ',
            'last_error VARCHAR(500) DEFAULT NULL COMMENT ''最近一次失败原因'', ',
            'create_time DATETIME NOT NULL, update_time DATETIME NOT NULL, ',
            'PRIMARY KEY (id), ',
            'UNIQUE KEY uk_user_coupon_event (user_id, user_coupon_id, event_type), ',
            'KEY idx_status_retry (status, retry_at), ',
            'KEY idx_status_lease (status, lease_until)',
            ') ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT=''用户优惠券到期 Outbox''' );
        PREPARE outbox_stmt FROM @outbox_sql;
        EXECUTE outbox_stmt;
        DEALLOCATE PREPARE outbox_stmt;
        SET table_index = table_index + 1;
    END WHILE;
END //
DELIMITER ;
CALL init_user_coupon_expire_outbox_tables();
DROP PROCEDURE init_user_coupon_expire_outbox_tables;
