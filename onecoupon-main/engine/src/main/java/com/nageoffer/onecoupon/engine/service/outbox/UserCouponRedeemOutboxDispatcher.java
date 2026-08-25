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

import com.alibaba.fastjson2.JSON;
import com.nageoffer.onecoupon.engine.common.constant.EngineRedisConstant;
import com.nageoffer.onecoupon.engine.common.enums.RedisStockDecrementErrorEnum;
import com.nageoffer.onecoupon.engine.dao.entity.UserCouponRedeemOutboxDO;
import com.nageoffer.onecoupon.engine.dao.mapper.UserCouponRedeemOutboxMapper;
import com.nageoffer.onecoupon.engine.dto.req.CouponTemplateRedeemReqDTO;
import com.nageoffer.onecoupon.engine.dto.resp.CouponTemplateQueryRespDTO;
import com.nageoffer.onecoupon.engine.mq.event.UserCouponRedeemEvent;
import com.nageoffer.onecoupon.engine.mq.producer.UserCouponRedeemProducer;
import com.nageoffer.onecoupon.engine.toolkit.StockDecrementReturnCombinedUtil;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.util.Date;
import java.util.List;
import java.util.UUID;

/**
 * 领券 Outbox 投递器。复用分发批次 Outbox 的租约、退避重试与 PUBLISHED 回查语义。
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class UserCouponRedeemOutboxDispatcher {
    private final UserCouponRedeemOutboxMapper outboxMapper;
    private final UserCouponRedeemProducer redeemProducer;
    private final StringRedisTemplate stringRedisTemplate;
    private final String workerId = "user-coupon-redeem-outbox-" + UUID.randomUUID();

    @Value("${one-coupon.user-coupon-redeem-outbox.batch-size:200}")
    private int batchSize;
    @Value("${one-coupon.user-coupon-redeem-outbox.lease-seconds:30}")
    private int leaseSeconds;
    @Value("${one-coupon.user-coupon-redeem-outbox.published-check-seconds:15}")
    private int publishedCheckSeconds;
    @Value("${one-coupon.user-coupon-redeem-outbox.init-recovery-seconds:5}")
    private int initRecoverySeconds;

    @Scheduled(fixedDelayString = "${one-coupon.user-coupon-redeem-outbox.fixed-delay-ms:1000}")
    public void dispatchReadyEvents() {
        Date now = new Date();
        recoverInterruptedReservations(now);
        outboxMapper.resetExpiredProcessing(now);
        checkPublishedEvents(now);
        List<UserCouponRedeemOutboxDO> events = outboxMapper.selectReadyEvents(now, batchSize);
        for (UserCouponRedeemOutboxDO event : events) {
            Date leaseUntil = new Date(now.getTime() + leaseSeconds * 1000L);
            if (outboxMapper.claim(event.getId(), event.getUserId(), workerId, leaseUntil) == 1) {
                dispatchOne(event);
            }
        }
    }

    private void recoverInterruptedReservations(Date now) {
        Date staleBefore = new Date(now.getTime() - initRecoverySeconds * 1000L);
        for (UserCouponRedeemOutboxDO event : outboxMapper.selectStaleInitEvents(staleBefore, batchSize)) {
            String value = stringRedisTemplate.opsForValue().get(String.format(EngineRedisConstant.USER_COUPON_REDEEM_RESERVATION_KEY, event.getRequestId()));
            if (value == null) {
                outboxMapper.markFailed(event.getId(), event.getUserId(), "INIT 状态未发现 Redis 预扣结果，请使用相同 requestId 重试");
                continue;
            }
            long result = Long.parseLong(value);
            long code = StockDecrementReturnCombinedUtil.extractFirstField(result);
            if (RedisStockDecrementErrorEnum.isFail(code)) {
                outboxMapper.markFailed(event.getId(), event.getUserId(), RedisStockDecrementErrorEnum.fromType(code));
            } else {
                outboxMapper.markReady(event.getId(), event.getUserId(), (int) StockDecrementReturnCombinedUtil.extractSecondField(result));
            }
        }
    }

    private void dispatchOne(UserCouponRedeemOutboxDO event) {
        try {
            CouponTemplateRedeemReqDTO requestParam = new CouponTemplateRedeemReqDTO();
            requestParam.setSource(event.getSource());
            requestParam.setShopNumber(String.valueOf(event.getShopNumber()));
            requestParam.setCouponTemplateId(String.valueOf(event.getCouponTemplateId()));
            requestParam.setRequestId(event.getRequestId());
            redeemProducer.sendMessage(UserCouponRedeemEvent.builder()
                    .outboxId(event.getId()).requestId(event.getRequestId()).requestParam(requestParam)
                    .receiveCount(event.getReceiveCount()).userId(String.valueOf(event.getUserId()))
                    .couponTemplate(JSON.parseObject(event.getTemplateSnapshot(), CouponTemplateQueryRespDTO.class)).build());
            outboxMapper.markPublished(event.getId(), event.getUserId(), nextCheckAt(), workerId);
        } catch (Throwable ex) {
            int attempts = event.getAttempts() == null ? 0 : event.getAttempts();
            outboxMapper.markRetry(event.getId(), event.getUserId(), workerId, retryAt(attempts), attempts + 1, truncate(ex));
            log.warn("领券 Outbox 投递失败，outboxId={}, requestId={}", event.getId(), event.getRequestId(), ex);
        }
    }

    private void checkPublishedEvents(Date now) {
        for (UserCouponRedeemOutboxDO event : outboxMapper.selectPublishedForCheck(now, batchSize)) {
            // 消费成功会在同一用户分片事务内更新为 DONE；仍为 PUBLISHED 则可靠重新唤醒。
            outboxMapper.requeuePublished(event.getId(), event.getUserId(), now);
        }
    }

    private Date nextCheckAt() {
        return new Date(System.currentTimeMillis() + publishedCheckSeconds * 1000L);
    }

    private Date retryAt(int attempts) {
        return new Date(System.currentTimeMillis() + Math.min(300, 1 << Math.min(attempts + 1, 8)) * 1000L);
    }

    private String truncate(Throwable ex) {
        String value = ex.getClass().getSimpleName() + ": " + ex.getMessage();
        return value.length() <= 500 ? value : value.substring(0, 500);
    }
}
