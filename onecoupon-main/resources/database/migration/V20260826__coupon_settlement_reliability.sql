-- Demo 结算可靠性增强：按 user_id 分片执行。
-- 在 one_coupon_0 与 one_coupon_1 分别执行。

DROP PROCEDURE IF EXISTS init_coupon_settlement_reliability;
DELIMITER //
CREATE PROCEDURE init_coupon_settlement_reliability()
BEGIN
    DECLARE table_index INT DEFAULT 0;
    WHILE table_index < 16 DO
        SET @settlement_sql = CONCAT(
            'ALTER TABLE t_coupon_settlement_', table_index,
            ' ADD COLUMN IF NOT EXISTS request_id VARCHAR(128) NULL,',
            ' ADD COLUMN IF NOT EXISTS payment_id VARCHAR(128) NULL,',
            ' ADD COLUMN IF NOT EXISTS refund_id VARCHAR(128) NULL,',
            ' ADD COLUMN IF NOT EXISTS discount_amount DECIMAL(18,2) NULL,',
            ' ADD COLUMN IF NOT EXISTS update_time DATETIME NULL,',
            ' ADD KEY IF NOT EXISTS idx_order_coupon_user (order_id,coupon_id,user_id),',
            ' ADD KEY IF NOT EXISTS idx_payment_id (payment_id),',
            ' ADD KEY IF NOT EXISTS idx_refund_id (refund_id)' );
        PREPARE settlement_stmt FROM @settlement_sql;
        EXECUTE settlement_stmt;
        DEALLOCATE PREPARE settlement_stmt;
        SET table_index = table_index + 1;
    END WHILE;

    SET table_index = 0;
    WHILE table_index < 32 DO
        SET @projection_sql = CONCAT(
            'CREATE TABLE IF NOT EXISTS t_user_coupon_settlement_projection_outbox_', table_index, ' (',
            'id BIGINT NOT NULL, user_id BIGINT NOT NULL, coupon_id BIGINT NOT NULL, coupon_template_id BIGINT NOT NULL, ',
            'action VARCHAR(16) NOT NULL, request_id VARCHAR(128) NOT NULL, valid_end_time DATETIME NOT NULL, ',
            'status VARCHAR(16) NOT NULL, attempts INT NOT NULL DEFAULT 0, retry_at DATETIME NULL, ',
            'worker_id VARCHAR(128) NULL, lease_until DATETIME NULL, last_error VARCHAR(500) NULL, ',
            'create_time DATETIME NOT NULL, update_time DATETIME NOT NULL, PRIMARY KEY (id), ',
            'UNIQUE KEY uk_projection_request (user_id,request_id), KEY idx_status_retry(status,retry_at), ',
            'KEY idx_status_lease(status,lease_until)',
            ') ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT=''优惠券结算 Redis 投影 Outbox''' );
        PREPARE projection_stmt FROM @projection_sql;
        EXECUTE projection_stmt;
        DEALLOCATE PREPARE projection_stmt;
        SET table_index = table_index + 1;
    END WHILE;
END //
DELIMITER ;
CALL init_coupon_settlement_reliability();
DROP PROCEDURE init_coupon_settlement_reliability;
