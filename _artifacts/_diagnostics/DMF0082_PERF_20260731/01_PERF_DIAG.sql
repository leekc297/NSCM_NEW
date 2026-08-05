-- =============================================================================
-- 01_PERF_DIAG.sql — DMF0082 조회 성능 진단 (사내 10초 vs 클라우드 100초)
--   ⭐ **클라우드에서 실행**하고 결과를 회신. READ-ONLY (변경 없음). 계정: SCM_MGR
--   사내 기준값은 각 섹션 주석에 명기 — 그대로 대조하면 원인이 드러난다.
--
--   실행: sqlplus SCM_MGR/<pwd>@<dsn> @01_PERF_DIAG.sql
--   ※ 양쪽 모두 Oracle 26ai 로 확인됨 → **버전 차이는 배제**.
-- =============================================================================
SET LINESIZE 300
SET PAGESIZE 300
SET TRIMSPOOL ON
COLUMN NAME FORMAT A34
COLUMN VALUE FORMAT A26
COLUMN TABLE_NAME FORMAT A30
COLUMN INDEX_NAME FORMAT A44
COLUMN COLS FORMAT A80
COLUMN COLUMN_NAME FORMAT A24

SPOOL DMF0082_PERF_DIAG_OUTPUT.txt

PROMPT ################ [0] 환경 ################
SELECT BANNER_FULL FROM V$VERSION;
SELECT SYS_CONTEXT('USERENV','DB_NAME') DB_NAME, SYS_CONTEXT('USERENV','SERVER_HOST') HOST,
       TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI') NOW FROM DUAL;

PROMPT ################ [1] ⭐⭐ 1순위 — SCM_MST_SITE_ITEM 인덱스 (튜닝 산물) ################
PROMPT -- 사내는 2026-07-01 튜닝으로 이 테이블에 인덱스 8본을 만들었다.
PROMPT -- 이관 패키지는 PKG/SP 만 옮기므로 **인덱스는 클라우드에 없을 가능성이 높다.**
SELECT i.INDEX_NAME, i.INDEX_TYPE, i.UNIQUENESS, i.STATUS,
       (SELECT LISTAGG(c.COLUMN_NAME,',') WITHIN GROUP (ORDER BY c.COLUMN_POSITION)
          FROM USER_IND_COLUMNS c WHERE c.INDEX_NAME=i.INDEX_NAME) COLS
  FROM USER_INDEXES i WHERE i.TABLE_NAME='SCM_MST_SITE_ITEM' ORDER BY i.INDEX_NAME;
-- ⭐ 사내 기준 = 8본:
--   FBI_SCM_MST_SITE_ITEM_OWNER_TOKEN1  FUNCTION-BASED  → REGEXP_SUBSTR("OWNER",'[^,]+',1,1)
--   IDX01  DIVISION_ID,OWNER
--   IDX02  ITEM_ID,DIVISION_ID
--   IDX03  DIVISION_ID,VALID_YN,OWNER,PROJECT_CODE,ITEM_ID
--   IDX04  DIVISION_ID,SCM_SITE_ID,ITEM_ID
--   IDX05  DIVISION_ID,PROJECT_CODE
--   IDX06  DIVISION_ID,ITEM_ID
--   PK     DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID
-- ⛔ 8본 미만이면 → 02_FIX_MISSING_INDEX.sql 실행 (가장 유력한 원인)
--    근거: PKG_DMF0082 L726 `REGEXP_SUBSTR(F.OWNER,'[^,]+',1,LEVEL)` + 주석 `[PERF 2026-07-12] IN->JOIN`
--          = 같은 시기 SP 튜닝과 인덱스가 **세트**로 만들어졌다. SP 만 이관하면 반쪽이다.

PROMPT ################ [2] 전체 인덱스 대조 ################
SELECT TABLE_NAME, COUNT(*) IDX_CNT,
       SUM(CASE WHEN STATUS='UNUSABLE' THEN 1 ELSE 0 END) UNUSABLE
  FROM USER_INDEXES
 WHERE TABLE_NAME IN ('DM_PLN_MKT_FCST','DM_PLN_MKT_FCST_C','DM_PLN_MKT_FCST_RESULT_C',
   'DM_PLN_SALES_PLAN_RESULT','DM_PLN_SALES_PLAN_RESULT_C','DM_PLN_CFM_MKT_DEMAND_PLAN',
   'DM_PLN_CFM_MKT_DEMAND_PLAN_C','DM_PLN_CFM_SELLING_PRICE','DM_PLN_CFM_SELLING_PRICE_C',
   'SCM_MST_FUTURE_PRICE','SCM_MST_FUTURE_PRICE_C','SCM_MST_SITE_ITEM')
 GROUP BY TABLE_NAME ORDER BY TABLE_NAME;
-- ⭐ 사내 기준 (IDX_CNT / UNUSABLE):
--   DM_PLN_CFM_MKT_DEMAND_PLAN     1 / 0      DM_PLN_CFM_MKT_DEMAND_PLAN_C  1 / 0
--   DM_PLN_CFM_SELLING_PRICE       1 / 0      DM_PLN_CFM_SELLING_PRICE_C    1 / 0
--   DM_PLN_MKT_FCST                4 / 0      DM_PLN_MKT_FCST_C             6 / 5
--   DM_PLN_MKT_FCST_RESULT_C       5 / 0      DM_PLN_SALES_PLAN_RESULT      2 / 0
--   DM_PLN_SALES_PLAN_RESULT_C     3 / 0      SCM_MST_FUTURE_PRICE          2 / 0
--   SCM_MST_FUTURE_PRICE_C         3 / 2      SCM_MST_SITE_ITEM             8 / 0
-- ※ 사내에도 UNUSABLE 7본이 있으나 사내가 10초이므로 주 원인은 아니다(참고용).

PROMPT ################ [3] ⭐ 2순위 — 통계 (미수집/노후) ################
SELECT TABLE_NAME, NUM_ROWS, TO_CHAR(LAST_ANALYZED,'YYYY-MM-DD HH24:MI') LAST_ANALYZED
  FROM USER_TABLES
 WHERE TABLE_NAME IN ('DM_PLN_MKT_FCST','DM_PLN_MKT_FCST_C','DM_PLN_MKT_FCST_RESULT_C',
   'DM_PLN_SALES_PLAN_RESULT_C','DM_PLN_CFM_MKT_DEMAND_PLAN_C','DM_PLN_CFM_SELLING_PRICE',
   'SCM_MST_FUTURE_PRICE','SCM_MST_FUTURE_PRICE_C','SCM_MST_SITE_ITEM')
 ORDER BY NUM_ROWS DESC NULLS FIRST;
-- ⭐ 사내 기준 (NUM_ROWS / LAST_ANALYZED):
--   DM_PLN_MKT_FCST_C            7,536,901 / 2026-07-20
--   DM_PLN_SALES_PLAN_RESULT_C   3,454,721 / 2026-07-20
--   DM_PLN_CFM_MKT_DEMAND_PLAN_C 3,274,247 / 2026-07-20
--   SCM_MST_FUTURE_PRICE_C       3,086,168 / 2026-07-20
--   SCM_MST_FUTURE_PRICE         1,732,210 / 2026-07-27
--   DM_PLN_CFM_SELLING_PRICE     1,651,396 / 2026-07-24
--   DM_PLN_MKT_FCST              1,193,521 / 2026-07-30
--   DM_PLN_MKT_FCST_RESULT_C       788,367 / 2026-07-27
--   SCM_MST_SITE_ITEM              114,235 / 2026-07-30
-- ⛔ NUM_ROWS 가 NULL / LAST_ANALYZED 가 비어 있으면 **통계 미수집** → 03_FIX_STATS.sql
-- ⛔ 실제 행수와 크게 다르면 노후 → 동일 조치

PROMPT ################ [3-B] 실제 행수 (NUM_ROWS 신뢰성) ################
SELECT 'SCM_MST_SITE_ITEM' T, COUNT(*) ACTUAL FROM SCM_MST_SITE_ITEM
UNION ALL SELECT 'DM_PLN_MKT_FCST', COUNT(*) FROM DM_PLN_MKT_FCST
UNION ALL SELECT 'SCM_MST_FUTURE_PRICE', COUNT(*) FROM SCM_MST_FUTURE_PRICE;
-- 사내 실측: 114,235 / 1,193,521 / 1,732,210
-- ⛔ 클라우드 실제 행수가 사내보다 **훨씬 크면** 데이터량 자체가 원인일 수 있다(별도 판단).

PROMPT ################ [4] ⭐ 히스토그램 (편중 컬럼 카디널리티) ################
SELECT COLUMN_NAME, NUM_DISTINCT, HISTOGRAM, NUM_BUCKETS
  FROM USER_TAB_COL_STATISTICS
 WHERE TABLE_NAME='SCM_MST_SITE_ITEM' AND COLUMN_NAME IN
       ('DIVISION_ID','ITEM_ID','OWNER','PROJECT_CODE','VALID_YN')
 ORDER BY COLUMN_NAME;
-- ⭐ 사내: DIVISION_ID = FREQUENCY / 8 buckets (8 distinct, 편중)
--          ITEM_ID     = HYBRID / 254 buckets (15,446 distinct)
-- ⛔ HISTOGRAM=NONE 이면 DIVISION_ID 필터의 선택도를 균등분포로 오추정 →
--    행수를 잘못 잡아 Nested Loop/Full Scan 을 고른다. 03_FIX_STATS.sql 이 METHOD_OPT
--    'FOR ALL COLUMNS SIZE AUTO' 로 히스토그램까지 재수집한다.

PROMPT ################ [5] 병렬·자원 파라미터 ################
SELECT NAME, VALUE FROM V$PARAMETER
 WHERE NAME IN ('cpu_count','parallel_max_servers','parallel_servers_target','parallel_degree_policy',
                'parallel_force_local','pga_aggregate_target','sga_target','db_block_size',
                'optimizer_mode','optimizer_index_cost_adj','optimizer_dynamic_sampling','cursor_sharing')
 ORDER BY NAME;
-- ⭐ 사내: cpu_count 8 / parallel_max_servers 160 / parallel_servers_target 64
--          parallel_degree_policy MANUAL / parallel_force_local FALSE
--          pga_aggregate_target 2,147,483,648(2GB) / sga_target 0 / db_block_size 8192
--          optimizer_mode ALL_ROWS / index_cost_adj 100 / dynamic_sampling 2 / cursor_sharing EXACT
-- ⚠ PKG_DMF0082 는 `INSERT /*+ APPEND PARALLEL(4) */ INTO GT_DMF0082_MF_SP` 를 쓴다.
--   클라우드 cpu_count 가 작거나 parallel 이 제한되면 이 단계가 직접 느려진다.
-- ⚠ pga_aggregate_target 이 작으면 해시조인/정렬이 TEMP 로 유출되어 배수로 느려진다.

PROMPT ################ [6] ⭐⭐ 실측 — 조회 1회 실행 **직후** 이 쿼리를 돌릴 것 ################
SELECT * FROM (
  SELECT SQL_ID, PLAN_HASH_VALUE PHV, EXECUTIONS EX,
         ROUND(ELAPSED_TIME/1e6,1) ELAP_S,
         ROUND(ELAPSED_TIME/1e6/GREATEST(EXECUTIONS,1),2) S_PER_EX,
         BUFFER_GETS BG, DISK_READS DR, ROWS_PROCESSED RP,
         SUBSTR(REGEXP_REPLACE(SQL_TEXT,'\s+',' '),1,90) T
    FROM V$SQL
   WHERE LAST_ACTIVE_TIME > SYSDATE - 1/24
     AND (UPPER(SQL_TEXT) LIKE '%GT_DMF0082%' OR UPPER(SQL_TEXT) LIKE '%GTT_MF_SP%'
       OR UPPER(SQL_TEXT) LIKE '%DM_PLN_MKT_FCST%' OR UPPER(SQL_TEXT) LIKE '%SCM_MST_FUTURE_PRICE%'
       OR UPPER(SQL_TEXT) LIKE '%SCM_MST_SITE_ITEM%')
   ORDER BY ELAPSED_TIME DESC
) WHERE ROWNUM <= 15;
-- ⭐ 사내 실측(참고): GTT INSERT 단계들이 각 1.3~2.4초, 최상위도 5초대.
--    `INSERT /*+ APPEND PARALLEL(4) */ INTO GT_DMF0082_MF_SP` = 1.4초
-- ⛔ 클라우드에서 특정 SQL 하나가 수십 초를 먹으면 **그 SQL_ID 가 범인**이다.
--    그 SQL_ID 로 아래 [7] 실행계획을 떠서 회신할 것.

PROMPT ################ [7] 범인 SQL 실행계획 (SQL_ID 를 넣어 실행) ################
PROMPT -- SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR('<SQL_ID>',NULL,'ALLSTATS LAST +COST +BYTES'));
PROMPT -- 계획이 안 잡히면: SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_AWR('<SQL_ID>'));
PROMPT -- ⭐ 확인 포인트: SCM_MST_SITE_ITEM 접근이 INDEX 인지 TABLE ACCESS FULL 인지.
PROMPT --    FULL 이면 [1] 인덱스 결손이 확정된다.

PROMPT ################ [8] 대기 이벤트 (ASH) — 무엇을 기다리는가 ################
SELECT * FROM (
  SELECT NVL(EVENT,'ON CPU') EVENT, WAIT_CLASS, COUNT(*) SAMPLES
    FROM V$ACTIVE_SESSION_HISTORY
   WHERE SAMPLE_TIME > SYSTIMESTAMP - INTERVAL '30' MINUTE
   GROUP BY NVL(EVENT,'ON CPU'), WAIT_CLASS ORDER BY 3 DESC
) WHERE ROWNUM <= 12;
-- 해석: 'db file scattered read' / 'direct path read' 상위 = Full Scan 과다 → 인덱스·통계
--        'db file sequential read' 상위 = 인덱스 랜덤 IO 과다 → 계획 부적절
--        'ON CPU' 상위 = 행별 함수(REGEXP_SUBSTR 등) CPU 소모 → FBI 결손 의심
--        'direct path write temp' = PGA 부족 TEMP 유출

PROMPT ################ [9] PKG_DMF0082 상태 ################
SELECT OBJECT_NAME, OBJECT_TYPE, STATUS, LAST_DDL_TIME FROM USER_OBJECTS
 WHERE OBJECT_NAME='PKG_DMF0082' ORDER BY OBJECT_TYPE;
-- ⛔ INVALID 면 호출마다 재컴파일 → 지연. 또 BODY 가 구판이면 [PERF 2026-07-12] IN->JOIN
--    튜닝이 빠져 있는 것이므로 이관 패키지의 BODY 로 갱신 필요.

SPOOL OFF

PROMPT
PROMPT =============================================================
PROMPT 완료 — DMF0082_PERF_DIAG_OUTPUT.txt 회신 요망
PROMPT  판정 순서: [1] 인덱스 8본 → [3][4] 통계·히스토그램 → [6][7] 범인 SQL·계획 → [5] 자원
PROMPT =============================================================
