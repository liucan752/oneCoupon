-- 高并发领券可靠性改造。必须分别在 one_coupon_0 与 one_coupon_1 执行。
-- 领券 Outbox/用户库存记账按 user_id 分片；模板库存收敛去重账本按 shop_number 分片。

DROP PROCEDURE IF EXISTS init_user_coupon_redeem_tables;
DELIMITER //
CREATE PROCEDURE init_user_coupon_redeem_tables()
BEGIN
    DECLARE table_index INT DEFAULT 0;
    WHILE table_index < 32 DO
        SET @redeem_outbox_sql = CONCAT(
            'CREATE TABLE IF NOT EXISTS t_user_coupon_redeem_outbox_', table_index, ' (',
            'id BIGINT NOT NULL, user_id BIGINT NOT NULL, request_id VARCHAR(128) NOT NULL, ',
            'shop_number BIGINT NOT NULL, coupon_template_id BIGINT NOT NULL, source TINYINT NOT NULL, ',
            'receive_count INT NOT NULL DEFAULT 0, template_snapshot TEXT NOT NULL, ',
            'status VARCHAR(16) NOT NULL, retry_at DATETIME NULL, attempts INT NOT NULL DEFAULT 0, ',
            'worker_id VARCHAR(128) NULL, lease_until DATETIME NULL, last_error VARCHAR(500) NULL, ',
            'create_time DATETIME NOT NULL, update_time DATETIME NOT NULL, ',
            'PRIMARY KEY (id), UNIQUE KEY uk_user_request (user_id, request_id), ',
            'KEY idx_status_retry (status, retry_at), KEY idx_status_lease (status, lease_until)',
            ') ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT=''用户领券可靠Outbox''' );
        PREPARE redeem_outbox_stmt FROM @redeem_outbox_sql;
        EXECUTE redeem_outbox_stmt;
        DEALLOCATE PREPARE redeem_outbox_stmt;

        SET @redeem_ledger_sql = CONCAT(
            'CREATE TABLE IF NOT EXISTS t_user_coupon_redeem_stock_ledger_', table_index, ' (',
            'id BIGINT NOT NULL, outbox_id BIGINT NOT NULL, user_id BIGINT NOT NULL, shop_number BIGINT NOT NULL, ',
            'coupon_template_id BIGINT NOT NULL, amount INT NOT NULL, status VARCHAR(16) NOT NULL, ',
            'retry_at DATETIME NOT NULL, attempts INT NOT NULL DEFAULT 0, worker_id VARCHAR(128) NULL, ',
            'lease_until DATETIME NULL, last_error VARCHAR(500) NULL, create_time DATETIME NOT NULL, update_time DATETIME NOT NULL, ',
            'PRIMARY KEY (id), UNIQUE KEY uk_user_outbox (user_id, outbox_id), ',
            'KEY idx_status_retry (status, retry_at), KEY idx_status_lease (status, lease_until)',
            ') ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT=''用户领券模板库存批量收敛记账''' );
        PREPARE redeem_ledger_stmt FROM @redeem_ledger_sql;
        EXECUTE redeem_ledger_stmt;
        DEALLOCATE PREPARE redeem_ledger_stmt;
        SET table_index = table_index + 1;
    END WHILE;
END //
DELIMITER ;
CALL init_user_coupon_redeem_tables();
DROP PROCEDURE init_user_coupon_redeem_tables;

DROP PROCEDURE IF EXISTS init_coupon_template_stock_settlement_tables;
DELIMITER //
CREATE PROCEDURE init_coupon_template_stock_settlement_tables()
BEGIN
    DECLARE table_index INT DEFAULT 0;
    WHILE table_index < 16 DO
        SET @settlement_sql = CONCAT(
            'CREATE TABLE IF NOT EXISTS t_coupon_template_stock_settlement_', table_index, ' (',
            'id BIGINT NOT NULL, shop_number BIGINT NOT NULL, coupon_template_id BIGINT NOT NULL, ',
            'amount INT NOT NULL, create_time DATETIME NOT NULL, PRIMARY KEY (id), ',
            'KEY idx_template (shop_number, coupon_template_id)',
            ') ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT=''模板库存收敛去重账本''' );
        PREPARE settlement_stmt FROM @settlement_sql;
        EXECUTE settlement_stmt;
        DEALLOCATE PREPARE settlement_stmt;
        SET table_index = table_index + 1;
    END WHILE;
END //
DELIMITER ;
CALL init_coupon_template_stock_settlement_tables();
DROP PROCEDURE init_coupon_template_stock_settlement_tables;
