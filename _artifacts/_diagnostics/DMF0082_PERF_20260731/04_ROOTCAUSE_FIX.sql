-- =============================================================================
-- 04_ROOTCAUSE_FIX.sql — 원인 확정분 조치 (클라우드)
--   원인: optimizer_dynamic_sampling = 0  (사내 = 2, Oracle 기본값)
--   결과: 통계 없는 GTT 의 카디널리티를 추정하지 못해 Nested Loop 선택 → 단일블록 IO 폭증
--
--   ⭐ Step 1 (무위험 증명) 을 먼저 하고, 효과가 확인되면 Step 2(시스템 반영)를 DBA 에 요청.
-- =============================================================================
SET SERVEROUTPUT ON
SET TIMING ON

PROMPT ############################################################
PROMPT [Step 1] 세션 레벨 증명 — 시스템 변경 없이 원인 확정
PROMPT   같은 세션에서 조회를 2회 돌려 소요시간을 비교한다.
PROMPT ############################################################

-- 1-A. 현재 설정 그대로 1회 실행 (기준)
--      → 화면에서 DMF0082 조회 1회, 또는 아래로 직접 호출
ALTER SESSION SET optimizer_dynamic_sampling = 0;
-- ... DMF0082 조회 실행 ...
-- 소요시간 기록: ______ 초  (기대: 현재와 동일한 100초대)

-- 1-B. 동적 샘플링만 사내와 동일하게 켜고 재실행
ALTER SESSION SET optimizer_dynamic_sampling = 2;
ALTER SYSTEM FLUSH SHARED_POOL;   -- ⚠ 선택: 기존 커서를 버려야 새 계획이 선다
                                   --    운영 중이면 생략하고 대신 아래 PURGE 사용
-- ... DMF0082 조회 재실행 ...
-- 소요시간 기록: ______ 초  (기대: 사내 수준으로 단축)

-- ※ SHARED_POOL 전체 FLUSH 가 부담되면 해당 SQL 커서만 제거:
-- DECLARE V VARCHAR2(100);
-- BEGIN
--   FOR R IN (SELECT ADDRESS, HASH_VALUE FROM V$SQLAREA
--              WHERE SQL_ID IN ('br0qzg41fkcrf','5cj6byz57ugdp')) LOOP
--     V := R.ADDRESS||','||R.HASH_VALUE;
--     DBMS_SHARED_POOL.PURGE(V,'C');
--   END LOOP;
-- END;
-- /

PROMPT ############################################################
PROMPT [Step 2] 시스템 반영 — Step 1 에서 효과 확인된 경우에만 (DBA 승인)
PROMPT ############################################################
-- 사내와 동일 = Oracle 기본값 2 로 복귀
-- ALTER SYSTEM SET optimizer_dynamic_sampling = 2 SCOPE=BOTH;
--
-- ⚠ 영향 범위: 이 인스턴스의 **전 화면**. DMF0082 만의 문제가 아니라
--    GTT 를 쓰는 모든 SP 가 같은 영향을 받고 있으므로 전반적 개선이 예상되나,
--    파싱 시 샘플링 비용이 약간 늘어난다(통상 무시할 수준).
-- ⚠ RAC 이므로 SCOPE=BOTH + 전 노드 반영 확인 필요.

PROMPT ############################################################
PROMPT [Step 3] 대안 — 시스템 파라미터를 못 바꿀 때
PROMPT ############################################################
-- 3-A. GTT 에 세션 통계를 수집하도록 전환 (SP 안에서 적재 직후 호출)
--      → 동적 샘플링 없이도 정확한 카디널리티 확보
-- BEGIN
--   DBMS_STATS.SET_TABLE_PREFS('SCM_MGR','GT_DMF0082_T_LAST_DATA_SETUP_FCST_C',
--                              'GLOBAL_TEMP_TABLE_STATS','SESSION');
-- END;
-- /
--   ⚠ 대상 GTT 가 많아(사내 2,388본 중 2,386본이 통계 없음) 전면 적용은 별건 검토.
--
-- 3-B. PKG_DMF0082 도입부에서 세션 한정으로 설정 (SP 수정 = 이관 필요)
--      EXECUTE IMMEDIATE 'ALTER SESSION SET optimizer_dynamic_sampling = 2';
--      ⚠ 트랜잭션 중 ALTER SESSION 은 주의 (선례: PARALLEL DML 로 ORA-12841).
--         동적 샘플링 설정은 DML 모드 변경이 아니라 그 위험은 없으나,
--         SP 수정은 사내·클라우드 동시 이관이 필요하다.

PROMPT ############################################################
PROMPT [Step 4] 부수 조치 — 결손 인덱스 2본 (02_FIX_MISSING_INDEX.sql 로도 가능)
PROMPT ############################################################
-- 클라우드 SCM_MST_SITE_ITEM = 6본 / 사내 = 8본. 결손 2본:
--   ① IDX06_SCM_MST_SITE_ITEM (DIVISION_ID, ITEM_ID)
--   ② FBI_SCM_MST_SITE_ITEM_OWNER_TOKEN1  (함수기반)
BEGIN EXECUTE IMMEDIATE
  'CREATE INDEX SCM_MGR.IDX06_SCM_MST_SITE_ITEM ON SCM_MGR.SCM_MST_SITE_ITEM (DIVISION_ID, ITEM_ID)';
  DBMS_OUTPUT.PUT_LINE('CREATED IDX06_SCM_MST_SITE_ITEM');
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE IN (-955,-1408) THEN DBMS_OUTPUT.PUT_LINE('SKIP IDX06 (이미 존재)');
  ELSE DBMS_OUTPUT.PUT_LINE('FAIL IDX06 '||SQLERRM); END IF;
END;
/

BEGIN EXECUTE IMMEDIATE
  'CREATE INDEX SCM_MGR.FBI_SCM_MST_SITE_ITEM_OWNER_TOKEN1 ON SCM_MGR.SCM_MST_SITE_ITEM ('
  ||'REGEXP_SUBSTR("OWNER",''[^,]+'',1,1))';
  DBMS_OUTPUT.PUT_LINE('CREATED FBI_SCM_MST_SITE_ITEM_OWNER_TOKEN1');
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE IN (-955,-1408) THEN DBMS_OUTPUT.PUT_LINE('SKIP FBI (이미 존재)');
  ELSE DBMS_OUTPUT.PUT_LINE('FAIL FBI '||SQLERRM); END IF;
END;
/

-- 인덱스 생성 후 통계 (히스토그램 포함)
BEGIN
  DBMS_STATS.GATHER_TABLE_STATS('SCM_MGR','SCM_MST_SITE_ITEM',
    ESTIMATE_PERCENT => DBMS_STATS.AUTO_SAMPLE_SIZE,
    METHOD_OPT => 'FOR ALL COLUMNS SIZE AUTO', CASCADE => TRUE,
    DEGREE => 4, NO_INVALIDATE => FALSE);
END;
/

PROMPT ############################################################
PROMPT [검증]
PROMPT ############################################################
SELECT NAME, VALUE FROM V$PARAMETER WHERE NAME='optimizer_dynamic_sampling';
-- 기대: 2

SELECT COUNT(*) SITE_ITEM_IDX FROM USER_INDEXES WHERE TABLE_NAME='SCM_MST_SITE_ITEM';
-- 기대: 8 (사내와 동일)

-- 조회 재실행 후 계획이 바뀌었는지 확인 (⭐ 핵심 검증)
SELECT SQL_ID, PLAN_HASH_VALUE PHV, EXECUTIONS EX,
       ROUND(ELAPSED_TIME/1e6/GREATEST(EXECUTIONS,1),2) S_PER_EX, BUFFER_GETS BG
  FROM V$SQL WHERE SQL_ID IN ('br0qzg41fkcrf','5cj6byz57ugdp')
 ORDER BY SQL_ID, LAST_ACTIVE_TIME DESC;
-- ⭐ 기대: PLAN_HASH_VALUE 가 바뀌고 BUFFER_GETS 가 급감
--    사내 기준: br0qzg41fkcrf = PHV 3170497482 / 0.02초 / BG 47
--               5cj6byz57ugdp = PHV 290871114  / 1.28초 / BG 90,488
