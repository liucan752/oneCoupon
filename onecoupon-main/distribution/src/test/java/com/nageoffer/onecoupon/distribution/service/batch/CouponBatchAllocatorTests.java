package com.nageoffer.onecoupon.distribution.service.batch;

import org.junit.jupiter.api.Test;

import java.util.List;
import java.util.Set;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

/**
 * 批次候选人筛选的纯单元测试。
 *
 * <p>这组测试刻意不启动 Spring、不连接 Redis/MySQL。库存裁决的业务规则先被固定下来，
 * 后续无论由 MQ 消费、定时补偿还是人工重放触发，得到的候选结果都必须一致。</p>
 */
class CouponBatchAllocatorTests {

    @Test
    void shouldKeepExcelOrderAndRejectDuplicateAndExistingUsers() {
        List<CouponBatchAllocator.Candidate> candidates = List.of(
                new CouponBatchAllocator.Candidate(11L, 1001L),
                new CouponBatchAllocator.Candidate(12L, 1002L),
                new CouponBatchAllocator.Candidate(13L, 1001L),
                new CouponBatchAllocator.Candidate(14L, 1003L)
        );

        CouponBatchAllocator.Allocation allocation = CouponBatchAllocator.allocate(candidates, Set.of(1002L), 2);

        assertEquals(List.of(11L, 14L), allocation.successItemIds());
        assertEquals(CouponBatchAllocator.FailureReason.ALREADY_RECEIVED, allocation.failureByItemId().get(12L));
        assertEquals(CouponBatchAllocator.FailureReason.DUPLICATE_IN_TASK, allocation.failureByItemId().get(13L));
        assertEquals(2, allocation.reservedStock());
    }

    @Test
    void shouldNeverAllocateMoreThanCurrentStock() {
        List<CouponBatchAllocator.Candidate> candidates = List.of(
                new CouponBatchAllocator.Candidate(21L, 2001L),
                new CouponBatchAllocator.Candidate(22L, 2002L),
                new CouponBatchAllocator.Candidate(23L, 2003L)
        );

        CouponBatchAllocator.Allocation allocation = CouponBatchAllocator.allocate(candidates, Set.of(), 2);

        assertEquals(List.of(21L, 22L), allocation.successItemIds());
        assertEquals(CouponBatchAllocator.FailureReason.OUT_OF_STOCK, allocation.failureByItemId().get(23L));
        assertEquals(2, allocation.reservedStock());
    }

    @Test
    void shouldRejectAllCandidatesWhenStockIsZero() {
        CouponBatchAllocator.Allocation allocation = CouponBatchAllocator.allocate(
                List.of(new CouponBatchAllocator.Candidate(31L, 3001L)), Set.of(), 0);

        assertTrue(allocation.successItemIds().isEmpty());
        assertEquals(CouponBatchAllocator.FailureReason.OUT_OF_STOCK, allocation.failureByItemId().get(31L));
    }
}
