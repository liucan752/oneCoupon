package com.nageoffer.onecoupon.distribution.mq.producer;

import cn.hutool.core.util.StrUtil;
import com.nageoffer.onecoupon.distribution.common.constant.DistributionRocketMQConstant;
import com.nageoffer.onecoupon.distribution.mq.base.BaseSendExtendDTO;
import com.nageoffer.onecoupon.distribution.mq.base.MessageWrapper;
import com.nageoffer.onecoupon.distribution.mq.event.CouponTaskBatchReadyEvent;
import lombok.extern.slf4j.Slf4j;
import org.apache.rocketmq.common.message.MessageConst;
import org.apache.rocketmq.spring.core.RocketMQTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.ConfigurableEnvironment;
import org.springframework.messaging.Message;
import org.springframework.messaging.support.MessageBuilder;
import org.springframework.stereotype.Component;

import java.util.UUID;

/** 批次就绪事件生产者；业务 key 使用 batchId，而不是 taskId。 */
@Slf4j
@Component
public class CouponTaskBatchReadyProducer extends AbstractCommonSendProduceTemplate<CouponTaskBatchReadyEvent> {

    private final ConfigurableEnvironment environment;

    public CouponTaskBatchReadyProducer(@Autowired RocketMQTemplate rocketMQTemplate,
                                        @Autowired ConfigurableEnvironment environment) {
        super(rocketMQTemplate);
        this.environment = environment;
    }

    @Override
    protected BaseSendExtendDTO buildBaseSendExtendParam(CouponTaskBatchReadyEvent event) {
        return BaseSendExtendDTO.builder()
                .eventName("优惠券持久化批次就绪")
                .keys(String.valueOf(event.getBatchId()))
                .topic(environment.resolvePlaceholders(DistributionRocketMQConstant.TEMPLATE_BATCH_READY_TOPIC_KEY))
                .sentTimeout(2000L)
                .build();
    }

    @Override
    protected Message<?> buildMessage(CouponTaskBatchReadyEvent event, BaseSendExtendDTO requestParam) {
        String keys = StrUtil.isEmpty(requestParam.getKeys()) ? UUID.randomUUID().toString() : requestParam.getKeys();
        return MessageBuilder.withPayload(new MessageWrapper<>(keys, event))
                .setHeader(MessageConst.PROPERTY_KEYS, keys)
                .build();
    }
}
