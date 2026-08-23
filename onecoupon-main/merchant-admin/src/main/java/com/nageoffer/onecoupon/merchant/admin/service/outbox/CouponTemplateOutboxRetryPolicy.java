package com.nageoffer.onecoupon.merchant.admin.service.outbox;

import org.springframework.stereotype.Component;

/**
 * Outbox 派生任务的指数退避策略，避免 Redis/MQ 故障时形成忙循环。
 * 作用：根据当前已经重试了多少次，计算【下一次重试需要等待多少秒】
 * 采用 2 的 N 次幂 指数退避，同时设置上限，不会无限增大等待时间
 */
@Component
public class CouponTemplateOutboxRetryPolicy {

    // 最大重试等待秒数：最多等待60s，不再继续放大间隔
    private static final int MAX_DELAY_SECONDS = 60;

    /**
     * @param attempts 已经重试过的次数（调用方传入 event.getAttempts()）
     * @return 本次失败后，距离下一次重试需要延迟多少秒
     */
    public int nextDelaySeconds(int attempts) {
        // 容错：防止负数重试次数，最小按0次处理
        int normalizedAttempts = Math.max(attempts, 0);

        // 如果重试次数 >=6，固定返回最大间隔60秒，不再继续指数放大
        if (normalizedAttempts >= 6) {
            return MAX_DELAY_SECONDS;
        }

        // 1 << normalizedAttempts 等价于 2 ^ normalizedAttempts（2的attempts次方）
        // 再和上限60取最小值，兜底
        return Math.min(1 << normalizedAttempts, MAX_DELAY_SECONDS);
    }
}
