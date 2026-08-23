# Coupon Template Reliability Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** 将优惠券模板创建改造成“MySQL 事务事实 + 幂等请求 + Outbox 异步派生”的可靠链路，并同步补充流程文档中的优化动机与风险。

**Architecture:** 创建接口只在本地数据库事务中写入幂等请求、`t_coupon_template` 和 `t_coupon_template_outbox`，提交后立即返回模板 ID。Outbox 调度器通过租约/CAS 抢占事件，幂等地写 Redis Hash、Bloom Filter 和 RocketMQ 延迟消息，失败进入指数退避重试；查询数据库时始终校验有效时间。

**Tech Stack:** Java 17, Spring Boot 3, Spring Transaction, MyBatis-Plus, ShardingSphere, Redis, Redisson, RocketMQ, JUnit 5.

---

### Task 1: 固化可测试的 Outbox 重试策略

**Files:**
- Create: `onecoupon-main/merchant-admin/src/test/java/com/nageoffer/onecoupon/merchant/admin/service/outbox/CouponTemplateOutboxRetryPolicyTest.java`
- Create: `onecoupon-main/merchant-admin/src/main/java/com/nageoffer/onecoupon/merchant/admin/service/outbox/CouponTemplateOutboxRetryPolicy.java`

- [x] **Step 1: Write the failing test**

  验证首次失败为 1 秒、第三次失败为 8 秒、超过上限后固定为 60 秒，保证重试不会忙循环。

- [ ] **Step 2: Run the focused test and observe the expected missing-class failure** (blocked before compilation: local Maven cache lacks Spring BOM and dependency-download approval timed out)

  Run: `mvnw.cmd -pl merchant-admin -Dtest=CouponTemplateOutboxRetryPolicyTest test`

- [x] **Step 3: Implement the minimal exponential-backoff policy**

  `nextDelaySeconds(int attempts)` 使用 `min(2^attempts, 60)`，并对负数按 0 次处理。

- [ ] **Step 4: Run the focused test and verify it passes**

  Run the same Maven command; expected: 3 tests pass.

### Task 2: Add sharded idempotency and Outbox persistence

**Files:**
- Create: `.../dao/entity/CouponTemplateCreateRequestDO.java`
- Create: `.../dao/entity/CouponTemplateOutboxDO.java`
- Create: `.../dao/mapper/CouponTemplateCreateRequestMapper.java`
- Create: `.../dao/mapper/CouponTemplateOutboxMapper.java`
- Create: `.../resources/mapper/CouponTemplateReliabilityMapper.xml`
- Modify: `.../resources/shardingsphere-config.yaml`
- Create: `onecoupon-main/resources/database/onecoupon-template-reliability.sql`

- [x] **Step 1:** Define `shop_number` on both records and unique `(shop_number, request_id)` / `(shop_number, template_id, event_type)` indexes so all writes route to the same shard.
- [x] **Step 2:** Add XML for insert-or-ignore idempotency, binding template ID, selecting ready events, CAS claim, retry and completion.
- [x] **Step 3:** Register both logical tables in ShardingSphere using the existing shop-number database/table algorithms.
- [x] **Step 4:** Add a migration script documenting execution against every physical shard table.

### Task 3: Make creation transactional and idempotent

**Files:**
- Modify: `.../service/CouponTemplateService.java`
- Modify: `.../service/impl/CouponTemplateServiceImpl.java`
- Modify: `.../controller/CouponTemplateController.java`
- Modify: `.../merchant-admin/src/main/resources/application.yaml`

- [x] **Step 1:** Change the API to accept `Idempotency-Key` and return `Result<Long>`.
- [x] **Step 2:** Add `@Transactional(rollbackFor = Exception.class)` around validation, template insert, Outbox insert and idempotency success binding.
- [x] **Step 3:** Remove Redis/MQ/Bloom writes from the transaction; create one `TEMPLATE_CREATED` Outbox row instead.
- [x] **Step 4:** Return the existing template ID for a completed duplicate request and reject an in-flight duplicate as “请求处理中”.

### Task 4: Implement the Outbox dispatcher

**Files:**
- Create: `.../service/outbox/CouponTemplateOutboxDispatcher.java`
- Create: `.../service/outbox/CouponTemplateCacheWriter.java`
- Modify: `.../MerchantAdminApplication.java`

- [x] **Step 1:** Schedule a bounded batch scan for `NEW`/`RETRY` rows whose retry time has arrived, reset expired leases, and CAS claim rows.
- [x] **Step 2:** Write Redis Hash + TTL atomically, add Bloom, and send the existing delayed RocketMQ event.
- [x] **Step 3:** Mark `DONE` only after all side effects succeed; otherwise record error and exponential retry time.
- [x] **Step 4:** Make repeated dispatch safe by overwriting the same cache key and relying on the existing delayed consumer’s conditional status update.

### Task 5: Preserve query correctness and update documentation

**Files:**
- Modify: `.../engine/.../CouponTemplateServiceImpl.java` (the active template query implementation)
- Modify: `Notes/优惠券模板创建流程.md`

- [x] **Step 1:** Add `validStartTime <= now < validEndTime` to database fallback and cache-hit validation.
- [x] **Step 2:** Add a section “优化前可能产生的问题：为什么要改造” covering partial success, Redis false negatives, fixed Bloom capacity, duplicate requests and MQ loss.
- [x] **Step 3:** Replace the note’s “recommended design only” wording with the implemented code paths and a verification checklist.

### Task 6: Verify the complete change

**Files:**
- No new files.

- [x] **Step 1:** Run focused unit tests (blocked by missing Maven BOM/network approval).
- [ ] **Step 2:** Run `mvnw.cmd -pl merchant-admin -am -DskipTests compile` (blocked by missing Maven BOM/network approval).
- [x] **Step 3:** Inspect `git diff --check` and `git status --short`, then report any environment-dependent database/Redis verification limits.
