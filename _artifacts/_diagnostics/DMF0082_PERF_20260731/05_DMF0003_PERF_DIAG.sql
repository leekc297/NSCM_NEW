-- =============================================================================
-- 05_DMF0003_PERF_DIAG.sql — DMF0003 조회 (사내 3초 / 클라우드 20초) 진단
--   ⭐ **클라우드에서 실행**. READ-ONLY. 계정: SCM_MGR
--   ⚠ 조회를 1회 실행한 **직후** 돌려야 [3] V$SQL 에 커서가 잡힌다.
--
--   배경: DMF0082 건에서 확정된 원인(optimizer_dynamic_sampling=0)이
--         DMF0003 에도 그대로 적용되는지 검증하는 것이 핵심 목적.
--         DMF0003 은 GTT 를 **79종** 사용(DMF0082 보다 GTT 의존이 더 큼) →
--         동적 샘플링 부재의 영향이 더 클 것으로 예상.
-- =============================================================================
SET LINESIZE 300
SET PAGESIZE 300
SET TRIMSPOOL ON
COLUMN T FORMAT A66
COLUMN TABLE_NAME FORMAT A30
COLUMN NAME FORMAT A34
COLUMN VALUE FORMAT A26

SPOOL DMF0003_PERF_DIAG_OUTPUT.txt

PROMPT ################ [1] ⭐⭐ 최우선 — 동적 샘플링 (DMF0082 확정 원인) ################
SELECT NAME, VALUE FROM V$PARAMETER WHERE NAME='optimizer_dynamic_sampling';
-- 사내 = 2 (Oracle 기본값) / DMF0082 진단 시 클라우드 = 0
-- ⛔ 0 이면 DMF0003 도 동일 원인일 가능성이 매우 높다 →
--    04_ROOTCAUSE_FIX.sql [Step 1] 의 세션 증명을 **DMF0003 조회로** 그대로 수행할 것.

PROMPT ################ [2] 통계 · 행수 대조 ################
SELECT TABLE_NAME, NUM_ROWS, TO_CHAR(LAST_ANALYZED,'YYYY-MM-DD HH24:MI') LAST_ANALYZED
  FROM USER_TABLES
 WHERE TABLE_NAME IN ('DM_PLN_MKT_FCST_C','DM_PLN_MKT_FCST_RESULT','SCM_MST_FUTURE_PRICE',
   'DM_PLN_MKT_FCST','DM_PLN_MKT_FCST_RESULT_C','DM_PLN_MKT_FCST_H','SCM_MST_SSO_USER_INFO',
   'SCM_MST_SITE_ITEM','DM_PLN_SALES_PLAN','SCM_MST_CITY','NERP_CONV_MASTER',
   'SCM_ADM_LOOKUP_MASTER_DETAIL','SCM_MST_PROJECT_ITEM','SCP_MST_FINAL_ITEM')
 ORDER BY NUM_ROWS DESC NULLS FIRST;
-- ⭐ 사내 기준 (NUM_ROWS / LAST_ANALYZED / 인덱스수):
--   DM_PLN_MKT_FCST_C            7,536,901 / 2026-07-20 / 6
--   DM_PLN_MKT_FCST_RESULT       4,248,912 / 2026-07-20 / 2   ← 인덱스 2본뿐, 클라우드 행수 확인 요
--   SCM_MST_FUTURE_PRICE         1,732,210 / 2026-07-27 / 2
--   DM_PLN_MKT_FCST              1,193,521 / 2026-07-30 / 4
--   DM_PLN_MKT_FCST_RESULT_C       788,367 / 2026-07-27 / 5
--   DM_PLN_MKT_FCST_H              226,941 / 2026-06-24 / 1
--   SCM_MST_SSO_USER_INFO          128,610 / 2026-07-23 / 3
--   SCM_MST_SITE_ITEM              114,235 / 2026-07-30 / 8
--   DM_PLN_SALES_PLAN              112,682 / 2026-07-27 / 2
--   SCM_MST_CITY                    89,426 / 2026-06-19 / 2
--   NERP_CONV_MASTER                87,309 / 2026-07-02 / 3
--   SCM_ADM_LOOKUP_MASTER_DETAIL    78,222 / 2026-07-14 / 2
--   SCM_MST_PROJECT_ITEM            63,124 / 2026-07-03 / 1
--   SCP_MST_FINAL_ITEM              34,605 / 2026-07-20 / 4

PROMPT ################ [2-B] 인덱스 수 대조 ################
SELECT TABLE_NAME, COUNT(*) IDX_CNT, SUM(CASE WHEN STATUS='UNUSABLE' THEN 1 ELSE 0 END) UNUSABLE
  FROM USER_INDEXES
 WHERE TABLE_NAME IN ('DM_PLN_MKT_FCST_C','DM_PLN_MKT_FCST_RESULT','SCM_MST_FUTURE_PRICE',
   'DM_PLN_MKT_FCST','DM_PLN_MKT_FCST_RESULT_C','SCM_MST_SITE_ITEM','DM_PLN_SALES_PLAN',
   'SCM_MST_PROJECT_ITEM','SCP_MST_FINAL_ITEM','SCM_MST_SSO_USER_INFO','NERP_CONV_MASTER')
 GROUP BY TABLE_NAME ORDER BY TABLE_NAME;
-- 사내 기준은 [2] 주석의 마지막 숫자와 동일.
-- ⛔ SCM_MST_SITE_ITEM 은 DMF0082 진단에서 클라우드 6 / 사내 8 로 **2본 결손** 확인됨
--    (04_ROOTCAUSE_FIX.sql [Step 4] 로 보정)

PROMPT ################ [3] ⭐⭐ 실측 — DMF0003 조회 직후 실행 ################
SELECT * FROM (
  SELECT SQL_ID, PLAN_HASH_VALUE PHV, EXECUTIONS EX,
         ROUND(ELAPSED_TIME/1e6/GREATEST(EXECUTIONS,1),2) S_PER_EX,
         BUFFER_GETS BG, DISK_READS DR, ROWS_PROCESSED RP,
         SUBSTR(REGEXP_REPLACE(SQL_TEXT,'\s+',' '),1,66) T
    FROM V$SQL
   WHERE LAST_ACTIVE_TIME > SYSDATE - 1/24
     AND (UPPER(SQL_TEXT) LIKE '%GT_DMF0003%' OR UPPER(SQL_TEXT) LIKE '%GT_ANLO%'
       OR UPPER(SQL_TEXT) LIKE '%DM_ANL_MKT_PSI%' OR UPPER(SQL_TEXT) LIKE '%GT_PSI%')
   ORDER BY ELAPSED_TIME DESC
) WHERE ROWNUM <= 15;
-- ⭐ 사내 실측 기준 (SQL_ID / PHV / 초·회 / BUFFER_GETS / 처리행):
--   d0hxg387f395t / 2933124554 / 2.74 / 328,866 / 2,994      INSERT GT_DMF0003_LAST_DATA_SETUP
--   8fzdju31p9htc /  352436063 / 1.98 / 818,204 / 98,933      INSERT GT_DMF0003_SITE_ITEM_ALL
--   8kfydzds35fy2 /  580999819 / 0.71 / 318,212 / 29,612      INSERT GT_DMF0003_SITE_ITEM_ALL
--   fd8sm6x0qyg3g / 1906973123 / 0.53 /  42,084 / 323,747     INSERT GT_DMF0003_ITEM_SINGLE_A
--   58g1a0k2zx332 /  376132258 / 0.17 /  52,071 / 323,747     INSERT GT_DMF0003_ITEM_SINGLE_V
--   7cq7m9yazk1dp /  527955105 / 0.16 / 337,493 / 323,747     UPDATE GT_DMF0003_ITEM_SINGLE_V
--   c3q139rvus3sy / 2557874793 / 0.13 / 185,801 / 399,408     INSERT GT_DMF0003_ITEM_SINGLE_ORI
--   8xujp4952szvj / 1727581449 / 0.12 /  47,472 / 143,351     INSERT GT_DMF0003_SITE_ITEM
--   fquabykr25nyy / 1590849756 / 0.10 /  21,865 /  2,384      INSERT GT_DMF0003_MKT_FCST_DATA
--   3xmpd6ma2bz01 /  266465805 / 0.10 /  22,623 /  5,125      INSERT GT_DMF0003_MKT_FCST_RESULT
--
-- ⭐⭐ 판정법 (DMF0082 에서 통했던 방식):
--   ① **같은 SQL_ID 를 위 목록에서 찾아** PLAN_HASH_VALUE 를 비교 → 다르면 계획 문제 확정
--   ② BUFFER_GETS 가 사내 대비 몇 배인지 확인 → 데이터 배수보다 크면 계획 열화
--   ③ **ROWS_PROCESSED 가 사내와 같은데 시간만 긴 SQL** 이 있으면 데이터량 가설이 죽는다
--      (DMF0082 는 0행짜리가 120초 걸려 이걸로 확정했다)

PROMPT ################ [4] 범인 SQL 실행계획 ################
PROMPT -- SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR('<SQL_ID>',NULL,'ALLSTATS LAST +COST +BYTES'));
PROMPT -- ⭐ 확인: NESTED LOOPS 가 대량 행에 걸려 있는지 / TABLE ACCESS FULL 대상이 무엇인지

PROMPT ################ [5] 대기 이벤트 (ASH) ################
SELECT * FROM (
  SELECT NVL(EVENT,'ON CPU') EVENT, WAIT_CLASS, COUNT(*) SAMPLES
    FROM V$ACTIVE_SESSION_HISTORY
   WHERE SAMPLE_TIME > SYSTIMESTAMP - INTERVAL '20' MINUTE
   GROUP BY NVL(EVENT,'ON CPU'), WAIT_CLASS ORDER BY 3 DESC
) WHERE ROWNUM <= 12;
-- DMF0082 클라우드 1위 = 'cell single block physical read: flash cache' (Nested Loop 과다)
-- 같은 양상이면 동일 원인.

PROMPT ################ [6] PKG_DMF0003 상태 ################
SELECT OBJECT_NAME, OBJECT_TYPE, STATUS, LAST_DDL_TIME FROM USER_OBJECTS
 WHERE OBJECT_NAME='PKG_DMF0003' ORDER BY OBJECT_TYPE;
-- 사내 최신 BODY = 2026-07-30 22:38 (TRUNCATE→DELETE 반영본)
-- ⛔ 클라우드가 이보다 오래됐다면 사내 튜닝분이 빠져 있는 것

PROMPT ################ [7] ⚠ 별건 — TRIM(REGEXP_SUBSTR(OWNER)) 는 FBI 를 못 탄다 ################
SELECT INDEX_NAME, STATUS FROM USER_INDEXES WHERE TABLE_NAME='SCM_MST_SITE_ITEM'
 ORDER BY INDEX_NAME;
-- 사내 FBI 식 = REGEXP_SUBSTR("OWNER",'[^,]+',1,1)   (TRIM 없음)
-- 그런데 PKG_DMF0003 L6795 = TRIM(REGEXP_SUBSTR(F.OWNER,'[^,]+',1,1))  ← TRIM 으로 감쌈
--   → 식이 달라 **사내에서도 이 FBI 를 못 쓴다**. 즉 FBI 결손은 DMF0003 의 원인이 아니다.
--   → 개선하려면 별건으로 TRIM 포함 FBI 를 새로 만들거나 SQL 에서 TRIM 을 걷어내야 한다
--      (양쪽 DB 동시 적용 필요 — 별도 승인 사안)

SPOOL OFF

PROMPT
PROMPT =============================================================
PROMPT 완료 — DMF0003_PERF_DIAG_OUTPUT.txt 회신 요망
PROMPT  판정 순서: [1] dynamic_sampling → [3] 같은 SQL_ID 의 PHV·BG 대조 → [2] 행수 → [5] ASH
PROMPT =============================================================
