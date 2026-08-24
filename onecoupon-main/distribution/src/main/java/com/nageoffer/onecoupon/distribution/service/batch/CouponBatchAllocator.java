package com.nageoffer.onecoupon.distribution.service.batch;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * 批次候选人分配器。
 *
 * <p>这个类只做“纯计算”，不访问 Redis、MQ 或数据库。把最容易被并发和重试影响的规则
 * 单独抽出来有两个好处：</p>
 * <ul>
 *     <li>同一批消息重放时，给定相同快照一定得到相同的成功/失败划分；</li>
 *     <li>可以用极小的单元测试覆盖重复用户、已领用户和库存不足，而不用搭建完整基础设施。</li>
 * </ul>
 *
 * <p>注意：该类不负责最终扣库存。最终库存必须由数据库条件更新完成，返回的
 * {@link Allocation#reservedStock()} 只是本地事务要尝试扣减的数量。</p>
 */
public final class CouponBatchAllocator {

    private CouponBatchAllocator() {
    }

    /** Excel 行对应的任务明细候选。itemId 是持久化明细主键，userId 是业务用户标识。 */
    public record Candidate(Long itemId, Long userId) {
    }

    /** 失败原因会持久化到任务明细，供失败 Excel 和运营审计使用。 */
    public enum FailureReason {
        ALREADY_RECEIVED,
        DUPLICATE_IN_TASK,
        OUT_OF_STOCK
    }

    /** 分配结果，successItemIds 保持 Excel 行顺序，便于结果可追溯。 */
    public record Allocation(List<Long> successItemIds,
                             Map<Long, FailureReason> failureByItemId,
                             int reservedStock) {
    }

    /**
     * 按输入顺序分配库存。
     *
     * @param candidates 当前批次的任务明细；调用方应保证 itemId 唯一
     * @param alreadyReceived 已经拥有该模板券的用户集合
     * @param availableStock 当前数据库库存快照，负数按 0 处理
     */
    public static Allocation allocate(List<Candidate> candidates,
                                      Set<Long> alreadyReceived,
                                      int availableStock) {
        int stock = Math.max(availableStock, 0);
        Set<Long> received = alreadyReceived == null ? Set.of() : alreadyReceived;
        Set<Long> seenUserIds = new HashSet<>();
        List<Long> success = new ArrayList<>();
        Map<Long, FailureReason> failures = new LinkedHashMap<>();

        for (Candidate candidate : candidates) {
            if (candidate == null || candidate.itemId() == null || candidate.userId() == null) {
                continue;
            }
            if (received.contains(candidate.userId())) {
                failures.put(candidate.itemId(), FailureReason.ALREADY_RECEIVED);
                continue;
            }
            if (!seenUserIds.add(candidate.userId())) {
                failures.put(candidate.itemId(), FailureReason.DUPLICATE_IN_TASK);
                continue;
            }
            if (success.size() >= stock) {
                failures.put(candidate.itemId(), FailureReason.OUT_OF_STOCK);
                continue;
            }
            success.add(candidate.itemId());
        }
        return new Allocation(List.copyOf(success), Map.copyOf(failures), success.size());
    }
}
