-- 优惠券模板创建可靠性改造。
-- 请分别在 one_coupon_0、one_coupon_1 执行本脚本：
--   USE one_coupon_0; SOURCE onecoupon-template-reliability.sql;
--   USE one_coupon_1; SOURCE onecoupon-template-reliability.sql;
-- 每次执行前，当前 database 必须是目标库；脚本会在该库中创建 _0 ~ _15 物理表。

DROP PROCEDURE IF EXISTS init_coupon_template_reliability_tables;

DELIMITER //
CREATE PROCEDURE init_coupon_template_reliability_tables()
BEGIN
    DECLARE table_index INT DEFAULT 0;
    WHILE table_index < 16 DO
        SET @request_sql = CONCAT(
            'CREATE TABLE IF NOT EXISTS t_coupon_template_create_request_', table_index, ' (' ,
            'id BIGINT NOT NULL AUTO_INCREMENT COMMENT ''ID'', ',
            'shop_number BIGINT NOT NULL COMMENT ''店铺编号'', ',
            'request_id VARCHAR(128) NOT NULL COMMENT ''幂等请求标识'', ',
            'request_hash CHAR(32) NOT NULL COMMENT ''请求内容MD5'', ',
            'template_id BIGINT DEFAULT NULL COMMENT ''创建成功后的模板ID'', ',
            'status VARCHAR(16) NOT NULL COMMENT ''PROCESSING/SUCCESS'', ',
            'create_time DATETIME NOT NULL, update_time DATETIME NOT NULL, ',
            'PRIMARY KEY (id), UNIQUE KEY uk_shop_request (shop_number, request_id)',
            ') ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT=''优惠券模板创建幂等请求表''' );
        PREPARE request_stmt FROM @request_sql;
        EXECUTE request_stmt;
        DEALLOCATE PREPARE request_stmt;

        SET @outbox_sql = CONCAT(
            'CREATE TABLE IF NOT EXISTS t_coupon_template_outbox_', table_index, ' (' ,
            'id BIGINT NOT NULL AUTO_INCREMENT COMMENT ''ID'', ',
            'shop_number BIGINT NOT NULL COMMENT ''店铺编号'', ',
            'template_id BIGINT NOT NULL COMMENT ''优惠券模板ID'', ',
            'event_type VARCHAR(64) NOT NULL COMMENT ''事件类型'', ',
            'status VARCHAR(16) NOT NULL COMMENT ''NEW/PROCESSING/RETRY/DONE'', ',
            'retry_at DATETIME NOT NULL COMMENT ''下次重试时间'', ',
            'attempts INT NOT NULL DEFAULT 0 COMMENT ''已尝试次数'', ',
            'worker_id VARCHAR(64) DEFAULT NULL COMMENT ''租约持有者'', ',
            'lease_until DATETIME DEFAULT NULL COMMENT ''租约截止时间'', ',
            'last_error VARCHAR(500) DEFAULT NULL COMMENT ''最近失败原因'', ',
            'create_time DATETIME NOT NULL, update_time DATETIME NOT NULL, ',
            'PRIMARY KEY (id), UNIQUE KEY uk_shop_template_event (shop_number, template_id, event_type), ',
            'KEY idx_status_retry (status, retry_at), KEY idx_status_lease (status, lease_until)',
            ') ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT=''优惠券模板Outbox事件表''' );
        PREPARE outbox_stmt FROM @outbox_sql;
        EXECUTE outbox_stmt;
        DEALLOCATE PREPARE outbox_stmt;
        SET table_index = table_index + 1;
    END WHILE;
END //
DELIMITER ;

CALL init_coupon_template_reliability_tables();
DROP PROCEDURE init_coupon_template_reliability_tables;
