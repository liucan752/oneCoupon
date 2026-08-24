package com.nageoffer.onecoupon.distribution.mq.event;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

/** 只携带持久化批次定位信息，消费者不信任 MQ 中的用户列表和库存数字。 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CouponTaskBatchReadyEvent implements Serializable {

    private Long batchId;
    private Long taskId;
    private Long shopNumber;
    /** 尾批标记只用于日志，不参与完成判断。 */
    private Boolean tail;
}
