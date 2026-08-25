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

package com.nageoffer.onecoupon.engine.service.impl;

import cn.hutool.core.bean.BeanUtil;
import cn.hutool.core.collection.ListUtil;
import cn.hutool.core.date.DateTime;
import cn.hutool.core.date.DateUtil;
import cn.hutool.core.lang.Singleton;
import cn.hutool.core.util.IdUtil;
import cn.hutool.core.util.ObjectUtil;
import cn.hutool.core.util.StrUtil;
import com.alibaba.fastjson2.JSON;
import com.alibaba.fastjson2.JSONObject;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.toolkit.SqlHelper;
import com.nageoffer.onecoupon.engine.common.constant.EngineRedisConstant;
import com.nageoffer.onecoupon.engine.common.context.UserContext;
import com.nageoffer.onecoupon.engine.common.enums.RedisStockDecrementErrorEnum;
import com.nageoffer.onecoupon.engine.common.enums.UserCouponStatusEnum;
import com.nageoffer.onecoupon.engine.dao.entity.CouponSettlementDO;
import com.nageoffer.onecoupon.engine.dao.entity.UserCouponDO;
import com.nageoffer.onecoupon.engine.dao.entity.UserCouponExpireOutboxDO;
import com.nageoffer.onecoupon.engine.dao.entity.UserCouponRedeemOutboxDO;
import com.nageoffer.onecoupon.engine.dao.entity.UserCouponSettlementProjectionOutboxDO;
import com.nageoffer.onecoupon.engine.dao.mapper.CouponSettlementMapper;
import com.nageoffer.onecoupon.engine.dao.mapper.CouponTemplateMapper;
import com.nageoffer.onecoupon.engine.dao.mapper.UserCouponMapper;
import com.nageoffer.onecoupon.engine.dao.mapper.UserCouponExpireOutboxMapper;
import com.nageoffer.onecoupon.engine.dao.mapper.UserCouponRedeemOutboxMapper;
import com.nageoffer.onecoupon.engine.dao.mapper.UserCouponSettlementProjectionOutboxMapper;
import com.nageoffer.onecoupon.engine.dto.req.CouponCreatePaymentGoodsReqDTO;
import com.nageoffer.onecoupon.engine.dto.req.CouponCreatePaymentReqDTO;
import com.nageoffer.onecoupon.engine.dto.req.CouponProcessPaymentReqDTO;
import com.nageoffer.onecoupon.engine.dto.req.CouponProcessRefundReqDTO;
import com.nageoffer.onecoupon.engine.dto.req.CouponCancelPaymentReqDTO;
import com.nageoffer.onecoupon.engine.dto.req.CouponTemplateQueryReqDTO;
import com.nageoffer.onecoupon.engine.dto.req.CouponTemplateRedeemReqDTO;
import com.nageoffer.onecoupon.engine.dto.resp.CouponTemplateQueryRespDTO;
import com.nageoffer.onecoupon.engine.service.CouponTemplateService;
import com.nageoffer.onecoupon.engine.service.UserCouponService;
import com.nageoffer.onecoupon.engine.toolkit.StockDecrementReturnCombinedUtil;
import com.nageoffer.onecoupon.framework.exception.ClientException;
import com.nageoffer.onecoupon.framework.exception.ServiceException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.redisson.api.RLock;
import org.redisson.api.RedissonClient;
import org.springframework.core.io.ClassPathResource;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.data.redis.core.script.DefaultRedisScript;
import org.springframework.scripting.support.ResourceScriptSource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.support.TransactionTemplate;

import java.math.BigDecimal;
import java.util.Date;
import java.util.Objects;
import java.util.Optional;
import java.util.UUID;

import static com.nageoffer.onecoupon.engine.common.constant.EngineRedisConstant.USER_COUPON_TEMPLATE_LIST_KEY;

/**
 * 用户优惠券业务逻辑实现层
 * <p>
 * 作者：马丁
 * 加项目群：早加入就是优势！500人内部沟通群，分享的知识总有你需要的 <a href="https://t.zsxq.com/cw7b9" />
 * 开发时间：2024-07-25
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class UserCouponServiceImpl implements UserCouponService {

    private final CouponTemplateService couponTemplateService;
    private final UserCouponMapper userCouponMapper;
    private final CouponTemplateMapper couponTemplateMapper;
    private final CouponSettlementMapper couponSettlementMapper;
    private final UserCouponExpireOutboxMapper userCouponExpireOutboxMapper;
    private final UserCouponRedeemOutboxMapper userCouponRedeemOutboxMapper;
    private final UserCouponSettlementProjectionOutboxMapper userCouponSettlementProjectionOutboxMapper;

    private final StringRedisTemplate stringRedisTemplate;
    private final RedissonClient redissonClient;
    private final TransactionTemplate transactionTemplate;

    private final static String STOCK_DECREMENT_AND_SAVE_USER_RECEIVE_LUA_PATH = "lua/stock_decrement_and_save_user_receive.lua";

    @Override
    public void redeemUserCoupon(CouponTemplateRedeemReqDTO requestParam) {
        // 兼容原同步入口：秒杀也统一走可靠 Outbox，避免 Redis 预扣后直接跨库写用户券。
        redeemUserCouponByMQ(requestParam);
    }

    @Override
    public void redeemUserCouponByMQ(CouponTemplateRedeemReqDTO requestParam) {
        // 验证缓存是否存在，保障数据存在并且缓存中存在
        CouponTemplateQueryRespDTO couponTemplate = couponTemplateService.findCouponTemplate(BeanUtil.toBean(requestParam, CouponTemplateQueryReqDTO.class));

        // 验证领取的优惠券是否在活动有效时间
        boolean isInTime = DateUtil.isIn(new Date(), couponTemplate.getValidStartTime(), couponTemplate.getValidEndTime());
        if (!isInTime) {
            // 一般来说优惠券领取时间不到的时候，前端不会放开调用请求，可以理解这是用户调用接口在“攻击”
            throw new ClientException("不满足优惠券领取时间");
        }

        Long userId = Long.parseLong(UserContext.getUserId());
        String requestId = StrUtil.blankToDefault(requestParam.getRequestId(), IdUtil.fastSimpleUUID());
        requestParam.setRequestId(requestId);
        UserCouponRedeemOutboxDO outbox = userCouponRedeemOutboxMapper.selectByUserIdAndRequestId(userId, requestId);
        if (outbox == null) {
            Date now = new Date();
            UserCouponRedeemOutboxDO candidate = UserCouponRedeemOutboxDO.builder()
                    .id(IdUtil.getSnowflakeNextId()).userId(userId).requestId(requestId)
                    .shopNumber(Long.parseLong(requestParam.getShopNumber())).couponTemplateId(Long.parseLong(requestParam.getCouponTemplateId()))
                    .source(requestParam.getSource()).templateSnapshot(JSON.toJSONString(couponTemplate))
                    .status("INIT").attempts(0).createTime(now).updateTime(now).build();
            transactionTemplate.executeWithoutResult(status -> userCouponRedeemOutboxMapper.insertIgnore(candidate));
            outbox = userCouponRedeemOutboxMapper.selectByUserIdAndRequestId(userId, requestId);
        }
        if (outbox == null || "FAILED".equals(outbox.getStatus())) {
            throw new ServiceException("创建领券任务失败，请稍候重试");
        }
        if (!"INIT".equals(outbox.getStatus())) {
            return;
        }

        // 获取 LUA 脚本，并保存到 Hutool 的单例管理容器，下次直接获取不需要加载
        DefaultRedisScript<Long> buildLuaScript = Singleton.get(STOCK_DECREMENT_AND_SAVE_USER_RECEIVE_LUA_PATH, () -> {
            DefaultRedisScript<Long> redisScript = new DefaultRedisScript<>();
            redisScript.setScriptSource(new ResourceScriptSource(new ClassPathResource(STOCK_DECREMENT_AND_SAVE_USER_RECEIVE_LUA_PATH)));
            redisScript.setResultType(Long.class);
            return redisScript;
        });

        // 验证用户是否符合优惠券领取条件
        JSONObject receiveRule = JSON.parseObject(couponTemplate.getReceiveRule());
        String limitPerPerson = receiveRule.getString("limitPerPerson");

        // 执行 LUA 脚本进行扣减库存以及增加 Redis 用户领券记录次数
        String couponTemplateCacheKey = String.format(EngineRedisConstant.COUPON_TEMPLATE_KEY, requestParam.getCouponTemplateId());
        String userCouponTemplateLimitCacheKey = String.format(EngineRedisConstant.USER_COUPON_TEMPLATE_LIMIT_KEY, UserContext.getUserId(), requestParam.getCouponTemplateId());
        String reservationKey = String.format(EngineRedisConstant.USER_COUPON_REDEEM_RESERVATION_KEY, requestId);
        long reservationTtlSeconds = Math.max(3600L, (couponTemplate.getValidEndTime().getTime() - System.currentTimeMillis()) / 1000L + 3600L);
        Long stockDecrementLuaResult = stringRedisTemplate.execute(
                buildLuaScript,
                ListUtil.of(couponTemplateCacheKey, userCouponTemplateLimitCacheKey, reservationKey),
                String.valueOf(couponTemplate.getValidEndTime().getTime() / 1000L), limitPerPerson, String.valueOf(reservationTtlSeconds)
        );

        // 判断 LUA 脚本执行返回类，如果失败根据类型返回报错提示
        long firstField = StockDecrementReturnCombinedUtil.extractFirstField(stockDecrementLuaResult);
        if (RedisStockDecrementErrorEnum.isFail(firstField)) {
            userCouponRedeemOutboxMapper.markFailed(outbox.getId(), userId, RedisStockDecrementErrorEnum.fromType(firstField));
            throw new ServiceException(RedisStockDecrementErrorEnum.fromType(firstField));
        }
        int receiveCount = (int) StockDecrementReturnCombinedUtil.extractSecondField(stockDecrementLuaResult);
        if (userCouponRedeemOutboxMapper.markReady(outbox.getId(), userId, receiveCount) != 1) {
            throw new ServiceException("领券任务状态更新失败，请使用相同 requestId 重试");
        }
    }

    @Override
    public void createPaymentRecord(CouponCreatePaymentReqDTO requestParam) {
        if (requestParam.getOrderId() == null) {
            throw new ClientException("订单号不能为空");
        }
        RLock lock = redissonClient.getLock(String.format(EngineRedisConstant.LOCK_COUPON_SETTLEMENT_KEY, requestParam.getCouponId()));
        boolean tryLock = lock.tryLock();
        if (!tryLock) {
            throw new ClientException("正在创建优惠券结算单，请稍候再试");
        }

        try {
            Long userId = Long.parseLong(UserContext.getUserId());
            if (StrUtil.isBlank(requestParam.getRequestId())) {
                throw new ClientException("结算请求幂等号不能为空");
            }
            String requestId = requestParam.getRequestId();
            requestParam.setRequestId(requestId);
            LambdaQueryWrapper<CouponSettlementDO> queryWrapper = Wrappers.lambdaQuery(CouponSettlementDO.class)
                    .eq(CouponSettlementDO::getCouponId, requestParam.getCouponId())
                    .eq(CouponSettlementDO::getUserId, userId)
                    .eq(CouponSettlementDO::getOrderId, requestParam.getOrderId());

            CouponSettlementDO existingSettlement = couponSettlementMapper.selectOne(queryWrapper);
            if (existingSettlement != null) {
                if (Objects.equals(existingSettlement.getRequestId(), requestId)) {
                    return;
                }
                throw new ClientException("订单优惠券结算单已存在");
            }

            UserCouponDO userCouponDO = userCouponMapper.selectOne(Wrappers.lambdaQuery(UserCouponDO.class)
                    .eq(UserCouponDO::getId, requestParam.getCouponId())
                    .eq(UserCouponDO::getUserId, userId));

            // 验证用户优惠券状态和有效性
            if (Objects.isNull(userCouponDO)) {
                throw new ClientException("优惠券不存在");
            }
            Date now = new Date();
            if (userCouponDO.getValidStartTime() != null && userCouponDO.getValidStartTime().after(now)) {
                throw new ClientException("优惠券尚未生效");
            }
            if (userCouponDO.getValidEndTime() == null || !userCouponDO.getValidEndTime().after(now)) {
                throw new ClientException("优惠券已过期");
            }
            if (userCouponDO.getStatus() != 0) {
                throw new ClientException("优惠券使用状态异常");
            }

            // 获取优惠券模板和消费规则
            CouponTemplateQueryRespDTO couponTemplate = couponTemplateService.findCouponTemplate(
                    new CouponTemplateQueryReqDTO(requestParam.getShopNumber(), String.valueOf(userCouponDO.getCouponTemplateId())));
            JSONObject consumeRule = JSONObject.parseObject(couponTemplate.getConsumeRule());

            // 计算折扣金额
            BigDecimal discountAmount;

            // 商品专属优惠券
            if (couponTemplate.getTarget().equals(0)) {
                // 获取第一个匹配的商品
                Optional<CouponCreatePaymentGoodsReqDTO> matchedGoods = requestParam.getGoodsList().stream()
                        .filter(each -> Objects.equals(couponTemplate.getGoods(), each.getGoodsNumber()))
                        .findFirst();

                if (matchedGoods.isEmpty()) {
                    throw new ClientException("商品信息与优惠券模板不符");
                }

                // 验证折扣金额
                CouponCreatePaymentGoodsReqDTO paymentGoods = matchedGoods.get();
                BigDecimal maximumDiscountAmount = consumeRule.getBigDecimal("maximumDiscountAmount");
                if (paymentGoods.getGoodsAmount().subtract(maximumDiscountAmount).compareTo(paymentGoods.getGoodsPayableAmount()) != 0) {
                    throw new ClientException("商品折扣后金额异常");
                }

                discountAmount = maximumDiscountAmount;
            } else { // 店铺专属
                // 检查店铺编号（如果是店铺券）
                if (couponTemplate.getSource() == 0 && !requestParam.getShopNumber().equals(couponTemplate.getShopNumber())) {
                    throw new ClientException("店铺编号不一致");
                }

                BigDecimal termsOfUse = consumeRule.getBigDecimal("termsOfUse");
                if (requestParam.getOrderAmount().compareTo(termsOfUse) < 0) {
                    throw new ClientException("订单金额未满足使用条件");
                }

                BigDecimal maximumDiscountAmount = consumeRule.getBigDecimal("maximumDiscountAmount");

                switch (couponTemplate.getType()) {
                    case 0: // 立减券
                        discountAmount = maximumDiscountAmount;
                        break;
                    case 1: // 满减券
                        discountAmount = maximumDiscountAmount;
                        break;
                    case 2: // 折扣券
                        BigDecimal discountRate = consumeRule.getBigDecimal("discountRate");
                        discountAmount = requestParam.getOrderAmount().multiply(discountRate);
                        if (discountAmount.compareTo(maximumDiscountAmount) >= 0) {
                            discountAmount = maximumDiscountAmount;
                        }
                        break;
                    default:
                        throw new ClientException("无效的优惠券类型");
                }
            }

            // 计算折扣后金额并进行检查
            BigDecimal actualPayableAmount = requestParam.getOrderAmount().subtract(discountAmount);
            if (actualPayableAmount.compareTo(requestParam.getPayableAmount()) != 0) {
                throw new ClientException("折扣后金额不一致");
            }

            // 通过编程式事务减小事务范围
            transactionTemplate.executeWithoutResult(status -> {
                try {
                    // 创建优惠券结算单记录
                    CouponSettlementDO couponSettlementDO = CouponSettlementDO.builder()
                            .orderId(requestParam.getOrderId())
                            .couponId(requestParam.getCouponId())
                            .userId(userId)
                            .requestId(requestId)
                            .discountAmount(discountAmount)
                            .status(0)
                            .build();
                    couponSettlementMapper.insert(couponSettlementDO);

                    // 变更用户优惠券状态
                    LambdaUpdateWrapper<UserCouponDO> userCouponUpdateWrapper = Wrappers.lambdaUpdate(UserCouponDO.class)
                            .eq(UserCouponDO::getId, requestParam.getCouponId())
                            .eq(UserCouponDO::getUserId, userId)
                            .eq(UserCouponDO::getStatus, UserCouponStatusEnum.UNUSED.getCode());
                    UserCouponDO updateUserCouponDO = UserCouponDO.builder()
                            .status(UserCouponStatusEnum.LOCKING.getCode())
                            .build();
                    if (userCouponMapper.update(updateUserCouponDO, userCouponUpdateWrapper) != 1) {
                        throw new ServiceException("用户优惠券状态更新失败");
                    }
                    userCouponSettlementProjectionOutboxMapper.insertIgnore(UserCouponSettlementProjectionOutboxDO.builder()
                            .id(IdUtil.getSnowflakeNextId()).userId(userId).couponId(userCouponDO.getId())
                            .couponTemplateId(userCouponDO.getCouponTemplateId()).action("REMOVE")
                            .requestId(requestId + ":LOCK").validEndTime(userCouponDO.getValidEndTime())
                            .status("NEW").attempts(0).retryAt(new Date()).createTime(new Date()).updateTime(new Date()).build());
                } catch (Exception ex) {
                    log.error("创建优惠券结算单失败", ex);
                    status.setRollbackOnly();
                    throw ex;
                }
            });

            // 缓存投影由本地事务中写入的 Outbox 异步收敛。
        } finally {
            unlockSafely(lock);
        }
    }

    @Override
    public void processPayment(CouponProcessPaymentReqDTO requestParam) {
        if (requestParam.getOrderId() == null || StrUtil.isBlank(requestParam.getPaymentId())) {
            throw new ClientException("订单号和支付流水号不能为空");
        }
        RLock lock = redissonClient.getLock(String.format(EngineRedisConstant.LOCK_COUPON_SETTLEMENT_KEY, requestParam.getCouponId()));
        boolean tryLock = lock.tryLock();
        if (!tryLock) {
            throw new ClientException("正在核销优惠券结算单，请稍候再试");
        }

        try {
            Long userId = Long.parseLong(UserContext.getUserId());
            CouponSettlementDO settlement = findSettlement(userId, requestParam.getCouponId(), requestParam.getOrderId());
            UserCouponDO coupon = findUserCoupon(userId, requestParam.getCouponId());
            switch (com.nageoffer.onecoupon.engine.service.settlement.CouponSettlementStateMachine.payment(
                    settlement.getStatus(), coupon.getStatus(), settlement.getPaymentId(), requestParam.getPaymentId())) {
                case IDEMPOTENT -> {
                    return;
                }
                case REJECTED -> throw new ClientException("优惠券结算单状态不允许支付");
                default -> {
                }
            }
            transactionTemplate.executeWithoutResult(status -> {
                int settlementUpdated = couponSettlementMapper.update(CouponSettlementDO.builder()
                                .status(2).paymentId(requestParam.getPaymentId()).build(),
                        Wrappers.lambdaUpdate(CouponSettlementDO.class).eq(CouponSettlementDO::getId, settlement.getId())
                                .eq(CouponSettlementDO::getUserId, userId).eq(CouponSettlementDO::getStatus, 0));
                if (settlementUpdated != 1) {
                    throw new ServiceException("核销优惠券结算单失败");
                }
                int couponUpdated = userCouponMapper.update(UserCouponDO.builder()
                                .status(UserCouponStatusEnum.USED.getCode()).useTime(new Date()).build(),
                        Wrappers.lambdaUpdate(UserCouponDO.class).eq(UserCouponDO::getId, requestParam.getCouponId())
                                .eq(UserCouponDO::getUserId, userId).eq(UserCouponDO::getStatus, UserCouponStatusEnum.LOCKING.getCode()));
                if (couponUpdated != 1) {
                    throw new ServiceException("修改用户优惠券记录状态失败");
                }
            });
        } finally {
            unlockSafely(lock);
        }
    }

    @Override
    public void processRefund(CouponProcessRefundReqDTO requestParam) {
        if (requestParam.getOrderId() == null || StrUtil.isBlank(requestParam.getRefundId())) {
            throw new ClientException("订单号和退款流水号不能为空");
        }
        RLock lock = redissonClient.getLock(String.format(EngineRedisConstant.LOCK_COUPON_SETTLEMENT_KEY, requestParam.getCouponId()));
        boolean tryLock = lock.tryLock();
        if (!tryLock) {
            throw new ClientException("正在执行优惠券退款，请稍候再试");
        }

        try {
            Long userId = Long.parseLong(UserContext.getUserId());
            CouponSettlementDO settlement = findSettlement(userId, requestParam.getCouponId(), requestParam.getOrderId());
            UserCouponDO coupon = findUserCoupon(userId, requestParam.getCouponId());
            switch (com.nageoffer.onecoupon.engine.service.settlement.CouponSettlementStateMachine.refund(
                    settlement.getStatus(), coupon.getStatus(), settlement.getRefundId(), requestParam.getRefundId())) {
                case IDEMPOTENT -> {
                    return;
                }
                case REJECTED -> throw new ClientException("优惠券结算单状态不允许退款");
                default -> {
                }
            }
            boolean expired = coupon.getValidEndTime() == null || !coupon.getValidEndTime().after(new Date());
            int nextCouponStatus = expired ? UserCouponStatusEnum.EXPIRED.getCode() : UserCouponStatusEnum.UNUSED.getCode();
            transactionTemplate.executeWithoutResult(status -> {
                if (couponSettlementMapper.update(CouponSettlementDO.builder().status(3).refundId(requestParam.getRefundId()).build(),
                        Wrappers.lambdaUpdate(CouponSettlementDO.class).eq(CouponSettlementDO::getId, settlement.getId())
                                .eq(CouponSettlementDO::getUserId, userId).eq(CouponSettlementDO::getStatus, 2)) != 1) {
                    throw new ServiceException("优惠券结算单退款失败");
                }
                if (userCouponMapper.update(UserCouponDO.builder().status(nextCouponStatus).useTime(null).build(),
                        Wrappers.lambdaUpdate(UserCouponDO.class).eq(UserCouponDO::getId, requestParam.getCouponId())
                                .eq(UserCouponDO::getUserId, userId).eq(UserCouponDO::getStatus, UserCouponStatusEnum.USED.getCode())) != 1) {
                    throw new ServiceException("修改用户优惠券记录状态失败");
                }
                enqueueProjection(userId, coupon, expired ? "REMOVE" : "ADD", requestParam.getRefundId() + ":REFUND");
            });
        } finally {
            unlockSafely(lock);
        }
    }

    @Override
    public void cancelPayment(CouponCancelPaymentReqDTO requestParam) {
        if (requestParam.getOrderId() == null) {
            throw new ClientException("订单号不能为空");
        }
        RLock lock = redissonClient.getLock(String.format(EngineRedisConstant.LOCK_COUPON_SETTLEMENT_KEY, requestParam.getCouponId()));
        if (!lock.tryLock()) {
            throw new ClientException("正在取消优惠券结算单，请稍候再试");
        }
        try {
            Long userId = Long.parseLong(UserContext.getUserId());
            CouponSettlementDO settlement = findSettlement(userId, requestParam.getCouponId(), requestParam.getOrderId());
            UserCouponDO coupon = findUserCoupon(userId, requestParam.getCouponId());
            switch (com.nageoffer.onecoupon.engine.service.settlement.CouponSettlementStateMachine.cancel(
                    settlement.getStatus(), coupon.getStatus())) {
                case IDEMPOTENT -> {
                    return;
                }
                case REJECTED -> throw new ClientException("优惠券结算单状态不允许取消");
                default -> {
                }
            }
            boolean expired = coupon.getValidEndTime() == null || !coupon.getValidEndTime().after(new Date());
            int nextCouponStatus = expired ? UserCouponStatusEnum.EXPIRED.getCode() : UserCouponStatusEnum.UNUSED.getCode();
            transactionTemplate.executeWithoutResult(status -> {
                if (couponSettlementMapper.update(CouponSettlementDO.builder().status(1).build(),
                        Wrappers.lambdaUpdate(CouponSettlementDO.class).eq(CouponSettlementDO::getId, settlement.getId())
                                .eq(CouponSettlementDO::getUserId, userId).eq(CouponSettlementDO::getStatus, 0)) != 1) {
                    throw new ServiceException("取消优惠券结算单失败");
                }
                if (userCouponMapper.update(UserCouponDO.builder().status(nextCouponStatus).build(),
                        Wrappers.lambdaUpdate(UserCouponDO.class).eq(UserCouponDO::getId, requestParam.getCouponId())
                                .eq(UserCouponDO::getUserId, userId).eq(UserCouponDO::getStatus, UserCouponStatusEnum.LOCKING.getCode())) != 1) {
                    throw new ServiceException("释放锁定优惠券失败");
                }
                enqueueProjection(userId, coupon, expired ? "REMOVE" : "ADD",
                        StrUtil.blankToDefault(requestParam.getRequestId(), UUID.randomUUID().toString()) + ":CANCEL");
            });
        } finally {
            unlockSafely(lock);
        }
    }

    private CouponSettlementDO findSettlement(Long userId, Long couponId, Long orderId) {
        CouponSettlementDO settlement = couponSettlementMapper.selectOne(Wrappers.lambdaQuery(CouponSettlementDO.class)
                .eq(CouponSettlementDO::getUserId, userId).eq(CouponSettlementDO::getCouponId, couponId)
                .eq(CouponSettlementDO::getOrderId, orderId));
        if (settlement == null) {
            throw new ClientException("优惠券结算单不存在");
        }
        return settlement;
    }

    private UserCouponDO findUserCoupon(Long userId, Long couponId) {
        UserCouponDO coupon = userCouponMapper.selectOne(Wrappers.lambdaQuery(UserCouponDO.class)
                .eq(UserCouponDO::getId, couponId).eq(UserCouponDO::getUserId, userId));
        if (coupon == null) {
            throw new ClientException("优惠券不存在");
        }
        return coupon;
    }

    private void enqueueProjection(Long userId, UserCouponDO coupon, String action, String requestId) {
        userCouponSettlementProjectionOutboxMapper.insertIgnore(UserCouponSettlementProjectionOutboxDO.builder()
                .id(IdUtil.getSnowflakeNextId()).userId(userId).couponId(coupon.getId())
                .couponTemplateId(coupon.getCouponTemplateId()).action(action).requestId(requestId)
                .validEndTime(coupon.getValidEndTime()).status("NEW").attempts(0).retryAt(new Date())
                .createTime(new Date()).updateTime(new Date()).build());
    }

    private void unlockSafely(RLock lock) {
        if (lock.isHeldByCurrentThread()) {
            lock.unlock();
        }
    }
}
