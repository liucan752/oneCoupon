package com.nageoffer.onecoupon.merchant.admin.service.outbox;

import cn.hutool.core.bean.BeanUtil;
import com.nageoffer.onecoupon.merchant.admin.common.constant.MerchantAdminRedisConstant;
import com.nageoffer.onecoupon.merchant.admin.dao.entity.CouponTemplateDO;
import com.nageoffer.onecoupon.merchant.admin.dto.resp.CouponTemplateQueryRespDTO;
import lombok.RequiredArgsConstructor;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.data.redis.core.script.DefaultRedisScript;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * 以 Lua 原子地写入模板 Hash 与到期时间；重复写相同模板是安全的。
 */
@Component
@RequiredArgsConstructor
public class CouponTemplateCacheWriter {

    private static final String WRITE_TEMPLATE_LUA = "redis.call('HMSET', KEYS[1], unpack(ARGV, 1, #ARGV - 1)) "
            + "redis.call('EXPIREAT', KEYS[1], ARGV[#ARGV])";

    private final StringRedisTemplate stringRedisTemplate;

    public void write(CouponTemplateDO couponTemplate) {
        CouponTemplateQueryRespDTO response = BeanUtil.toBean(couponTemplate, CouponTemplateQueryRespDTO.class);
        Map<String, Object> target = BeanUtil.beanToMap(response, false, true);
        Map<String, String> cache = target.entrySet().stream().collect(Collectors.toMap(
                Map.Entry::getKey,
                entry -> entry.getValue() == null ? "" : entry.getValue().toString()
        ));

        List<String> args = new ArrayList<>(cache.size() * 2 + 1);
        cache.forEach((key, value) -> {
            args.add(key);
            args.add(value);
        });
        args.add(String.valueOf(couponTemplate.getValidEndTime().getTime() / 1000));
        stringRedisTemplate.execute(
                new DefaultRedisScript<>(WRITE_TEMPLATE_LUA, Long.class),
                Collections.singletonList(String.format(MerchantAdminRedisConstant.COUPON_TEMPLATE_KEY, couponTemplate.getId())),
                args.toArray()
        );
    }
}
