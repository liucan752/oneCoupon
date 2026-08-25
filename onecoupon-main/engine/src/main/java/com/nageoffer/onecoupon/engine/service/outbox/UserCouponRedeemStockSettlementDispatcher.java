/*
 * 牛券（oneCoupon）优惠券平台项目
 *
 * 版权所有 (C) [2024-至今] [山东流年网络科技有限公司]
 *
 * 保留所有权利。
 *
 * 1. 定义和解释
 *    本文件（包括其任何修改、更新和衍生内容）是由[山东流年网络科技有限公司]及相关人员开发的。
 *    "软件"指的是与本文件相关的任何代码、脚本、文档和相关的资源。
 *
 * 2. 使用许可
 *    本软件的使用、分发和解释均受中华人民共和国法律的管辖。只有在遵守以下条件的前提下，才允许使用和分发本软件：
 *    a. 未经[山东流年网络科技有限公司]的明确书面许可，不得对本软件进行修改、复制、分发、出售或出租。
 *    b. 任何未授权的复制、分发或修改都将被视为侵犯[山东流年网络科技有限公司]的知识产权。
 *
 * 3. 免责声明
 *    本软件按"原样"提供，没有任何明示或暗示的保证，包括但不限于适销性、特定用途的适用性和非侵权性的保证。
 *    在任何情况下，[山东流年网络科技有限公司]均不对任何直接、间接、偶然、特殊、典型或间接的损害（包括但不限于采购替代商品或服务；使用、数据或利润损失）承担责任。
 *
 * 4. 侵权通知与处理
 *    a. 如果[山东流年网络科技有限公司]发现或收到第三方通知，表明存在可能侵犯其知识产权的行为，公司将采取必要的措施以保护其权利。
 *    b. 对于任何涉嫌侵犯知识产权的行为，[山东流年网络科技有限公司]可能要求侵权方立即停止侵权行为，并采取补救措施，包括但不限于删除侵权内容、停止侵权产品的分发等。
 *    c. 如果侵权行为持续存在或未能得到妥善解决，[山东流年网络科技有限公司]保留采取进一步法律行动的权利，包括但不限于发出警告信、提起民事诉讼或刑事诉讼。
 *
 * 5. 其他条款
 *    a. [山东流年网络科技有限公司]保留随时修改这些条款的权利。
 *    b. 如果您不同意这些条款，请勿使用本软件。
 *
 * 未经[山东流年网络科技有限公司]的明确书面许可，不得使用此文件的任何部分。
 *
 * 本软件受到[山东流年网络科技有限公司]及其许可人的版权保护。
 */

package com.nageoffer.onecoupon.engine.service.outbox;

import com.nageoffer.onecoupon.engine.dao.entity.CouponTemplateStockSettlementDO;
import com.nageoffer.onecoupon.engine.dao.entity.UserCouponRedeemStockLedgerDO;
import com.nageoffer.onecoupon.engine.dao.mapper.CouponTemplateMapper;
import com.nageoffer.onecoupon.engine.dao.mapper.CouponTemplateStockSettlementMapper;
import com.nageoffer.onecoupon.engine.dao.mapper.UserCouponRedeemStockLedgerMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.transaction.support.TransactionTemplate;

import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * 将成功发券记账按模板聚合后一次性收敛 MySQL 模板库存。
 * 去重账本先落模板分片，再更新模板库存；任务重试不会重复扣减。
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class UserCouponRedeemStockSettlementDispatcher {
    private final UserCouponRedeemStockLedgerMapper ledgerMapper;
    private final CouponTemplateStockSettlementMapper settlementMapper;
    private final CouponTemplateMapper couponTemplateMapper;
    private final TransactionTemplate transactionTemplate;
    private final String workerId = "user-coupon-stock-settlement-" + UUID.randomUUID();

    @Value("${one-coupon.user-coupon-redeem-stock-settlement.batch-size:500}")
    private int batchSize;
    @Value("${one-coupon.user-coupon-redeem-stock-settlement.lease-seconds:30}")
    private int leaseSeconds;

    @Scheduled(fixedDelayString = "${one-coupon.user-coupon-redeem-stock-settlement.fixed-delay-ms:1000}")
    public void settleReadyLedgers() {
        Date now = new Date();
        ledgerMapper.resetExpiredProcessing(now);
        List<UserCouponRedeemStockLedgerDO> claimed = ledgerMapper.selectReadyEvents(now, batchSize).stream()
                .filter(event -> ledgerMapper.claim(event.getId(), event.getUserId(), workerId,
                        new Date(now.getTime() + leaseSeconds * 1000L)) == 1)
                .toList();
        Map<String, List<UserCouponRedeemStockLedgerDO>> groups = claimed.stream()
                .collect(Collectors.groupingBy(event -> event.getShopNumber() + ":" + event.getCouponTemplateId()));
        groups.values().forEach(this::settleGroup);
    }

    private void settleGroup(List<UserCouponRedeemStockLedgerDO> events) {
        if (events.isEmpty()) {
            return;
        }
        try {
            int inserted = transactionTemplate.execute(status -> {
                List<CouponTemplateStockSettlementDO> settlements = events.stream()
                        .map(event -> CouponTemplateStockSettlementDO.builder()
                                .id(event.getId()).shopNumber(event.getShopNumber())
                                .couponTemplateId(event.getCouponTemplateId()).amount(event.getAmount())
                                .createTime(new Date()).build())
                        .toList();
                int freshRows = settlementMapper.insertIgnoreBatch(settlements);
                if (freshRows > 0) {
                    UserCouponRedeemStockLedgerDO first = events.get(0);
                    int updated = couponTemplateMapper.decrementCouponTemplateStock(
                            first.getShopNumber(), first.getCouponTemplateId(), (long) freshRows);
                    if (updated != 1) {
                        throw new IllegalStateException("模板库存批量收敛失败，shopNumber=" + first.getShopNumber()
                                + ", couponTemplateId=" + first.getCouponTemplateId() + ", amount=" + freshRows);
                    }
                }
                return freshRows;
            });
            events.forEach(event -> ledgerMapper.markDone(event.getId(), event.getUserId(), workerId));
            log.debug("模板库存批量收敛完成，group={}, amount={}", events.get(0).getCouponTemplateId(), inserted);
        } catch (Throwable ex) {
            Date retryAt = new Date(System.currentTimeMillis() + 5000L);
            events.forEach(event -> ledgerMapper.markRetry(event.getId(), event.getUserId(), workerId,
                    retryAt, (event.getAttempts() == null ? 0 : event.getAttempts()) + 1, truncate(ex)));
            log.warn("模板库存批量收敛失败，couponTemplateId={}", events.get(0).getCouponTemplateId(), ex);
        }
    }

    private String truncate(Throwable ex) {
        String value = ex.getClass().getSimpleName() + ": " + ex.getMessage();
        return value.length() <= 500 ? value : value.substring(0, 500);
    }
}
