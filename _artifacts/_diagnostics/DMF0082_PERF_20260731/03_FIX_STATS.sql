-- =============================================================================
-- 03_FIX_STATS.sql — 통계·히스토그램 재수집 (클라우드)
--   ⛔ 01_PERF_DIAG.sql [3][4] 로 **통계 미수집/노후/히스토그램 없음**을 확인한 뒤 실행.
--   계정: SCM_MGR.  ⚠ 대형 테이블은 수집에 시간이 걸린다 — 업무 시간 외 권장.
--   변경 대상: 옵티마이저 통계만 (데이터·구조 변경 없음)
-- =============================================================================
SET SERVEROUTPUT ON
SET TIMING ON

-- ── 옵션 설명 ────────────────────────────────────────────────────────────
--   ESTIMATE_PERCENT = AUTO_SAMPLE_SIZE : Oracle 권장(정확도·시간 균형)
--   METHOD_OPT 'FOR ALL COLUMNS SIZE AUTO' : **히스토그램 포함** 재수집
--       → 사내가 DIVISION_ID(8 distinct, 편중) 에 FREQUENCY 히스토그램을 갖고 있어
--         선택도를 정확히 추정한다. 이게 없으면 균등분포로 오추정 → 계획 악화
--   CASCADE = TRUE : 인덱스 통계도 함께
--   DEGREE = 4 : 병렬 수집 (자원 여유에 맞게 조정)

DECLARE
  TYPE T_TAB IS TABLE OF VARCHAR2(128);
  V_TABS T_TAB := T_TAB(
    'SCM_MST_SITE_ITEM',              -- ⭐ 1순위 (REGEXP_SUBSTR(OWNER) 조인 대상)
    'DM_PLN_MKT_FCST',
    'DM_PLN_MKT_FCST_C',
    'DM_PLN_MKT_FCST_RESULT_C',
    'DM_PLN_SALES_PLAN_RESULT',
    'DM_PLN_SALES_PLAN_RESULT_C',
    'DM_PLN_CFM_MKT_DEMAND_PLAN',
    'DM_PLN_CFM_MKT_DEMAND_PLAN_C',
    'DM_PLN_CFM_SELLING_PRICE',
    'DM_PLN_CFM_SELLING_PRICE_C',
    'SCM_MST_FUTURE_PRICE',
    'SCM_MST_FUTURE_PRICE_C',
    'SCM_MST_SSO_USER_INFO',
    'NERP_CONV_MASTER',
    'SCM_ADM_LOOKUP_MASTER_DETAIL'
  );
  V_OK NUMBER := 0;
BEGIN
  FOR I IN 1 .. V_TABS.COUNT LOOP
    BEGIN
      DBMS_STATS.GATHER_TABLE_STATS(
        OWNNAME          => 'SCM_MGR',
        TABNAME          => V_TABS(I),
        ESTIMATE_PERCENT => DBMS_STATS.AUTO_SAMPLE_SIZE,
        METHOD_OPT       => 'FOR ALL COLUMNS SIZE AUTO',
        CASCADE          => TRUE,
        DEGREE           => 4,
        NO_INVALIDATE    => FALSE   -- 기존 커서를 무효화해 새 계획을 쓰게 한다
      );
      V_OK := V_OK + 1;
      DBMS_OUTPUT.PUT_LINE('OK  '||V_TABS(I));
    EXCEPTION WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('FAIL '||V_TABS(I)||' '||SQLERRM);
    END;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('=== 통계 수집 완료 '||V_OK||'/'||V_TABS.COUNT||' ===');
END;
/

-- ── 검증 ────────────────────────────────────────────────────────────────
SELECT TABLE_NAME, NUM_ROWS, TO_CHAR(LAST_ANALYZED,'YYYY-MM-DD HH24:MI') LAST_ANALYZED
  FROM USER_TABLES
 WHERE TABLE_NAME IN ('SCM_MST_SITE_ITEM','DM_PLN_MKT_FCST','DM_PLN_MKT_FCST_C',
                      'SCM_MST_FUTURE_PRICE','SCM_MST_FUTURE_PRICE_C')
 ORDER BY TABLE_NAME;
-- 기대: LAST_ANALYZED 가 방금 시각, NUM_ROWS 가 실제 행수와 근사

SELECT COLUMN_NAME, NUM_DISTINCT, HISTOGRAM, NUM_BUCKETS
  FROM USER_TAB_COL_STATISTICS
 WHERE TABLE_NAME='SCM_MST_SITE_ITEM'
   AND COLUMN_NAME IN ('DIVISION_ID','ITEM_ID','PROJECT_CODE')
 ORDER BY COLUMN_NAME;
-- 기대: DIVISION_ID = FREQUENCY (사내와 동일), ITEM_ID = HYBRID

-- ── 적용 후 반드시 ──────────────────────────────────────────────────────
-- 1) 화면에서 DMF0082 조회를 다시 실행해 소요시간 측정
-- 2) 01_PERF_DIAG.sql [6] 으로 SQL_ID / PLAN_HASH_VALUE 재확인
--    → PLAN_HASH_VALUE 가 바뀌고 시간이 줄었다면 통계가 원인이었던 것
