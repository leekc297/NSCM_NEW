-- =====================================================================================================
-- 96_DIAGNOSE_SLOW.sql — DMF0035 클라우드 **조회 지연(스피너 무한)** 병목 적출 (SELECT 전용)
--
--   [먼저 확인된 사실 — 튜닝은 클라우드에 **적용돼 있다**]
--     · 90_VERIFY V3 실측: `E20260820-WFITEMPERF` **2건 PASS** (PKG_DMF0035 BODY 4,149줄 = 패치본과 동일)
--     · 즉 "튜닝 미적용" 이 아니라 **같은 코드가 클라우드에서만 느린** 상황이다.
--
--   [볼륨 실측 — 사내 vs 클라우드 (2026-08-20)]
--       DM_PLN_MKT_FCST              2,623,844  vs   2,624,002   (1.0배)
--       DM_PLN_MKT_FCST_C           13,322,066  vs  51,716,730   (**3.9배**)
--       DM_PLN_CFM_MKT_DEMAND_PLAN     313,283  vs     724,439   (2.3배)
--       DM_PLN_MKT_FCST_RESULT       4,255,909  vs   7,383,929   (1.7배)
--     ⇒ 사내 4.2초짜리가 클라우드에서 그대로 4.2초일 수 없다. **볼륨에 맞는 2차 튜닝**이 필요하고,
--       그 전에 hook #129 ⓿ 원칙대로 **어떤 문장이 병목인지 클라우드에서 먼저 특정**해야 한다.
--       (사내에서 빨랐던 문장이 클라우드 병목이라는 보장이 없다 — 추정으로 손대지 말 것)
--
--   ⚠ 이 SP 는 GTT 통계 수집(DBMS_STATS.GATHER_TABLE_STATS + SESSION prefs)에 **13곳** 의존한다.
--     통계 수집 자체가 대용량에서 비용이 되거나, 앱계정 권한/설정 차이로 플랜이 갈릴 수 있다 → P4/P5 확인.
-- =====================================================================================================
SET LINESIZE 250
SET PAGESIZE 300

PROMPT ===== P1. ⭐ 지금 돌고 있는 세션·문장 (스피너 도는 동안 실행) =====
SELECT S.SID, S.SERIAL#, S.USERNAME, S.STATUS, S.SQL_ID, S.EVENT,
       S.SECONDS_IN_WAIT SEC_WAIT, S.LAST_CALL_ET RUNNING_SEC,
       SUBSTR(Q.SQL_TEXT, 1, 120) SQL_HEAD
  FROM V$SESSION S LEFT JOIN V$SQL Q ON Q.SQL_ID = S.SQL_ID AND Q.CHILD_NUMBER = S.SQL_CHILD_NUMBER
 WHERE S.STATUS = 'ACTIVE' AND S.USERNAME IS NOT NULL
   AND (S.PLSQL_ENTRY_OBJECT_ID IN (SELECT OBJECT_ID FROM ALL_OBJECTS
                                     WHERE OWNER='SCM_MGR'
                                       AND OBJECT_NAME IN ('PKG_DMF0035','PKG_DMF0022','PKG_DMF0051'))
        OR UPPER(Q.SQL_TEXT) LIKE '%GT_DM35%' OR UPPER(Q.SQL_TEXT) LIKE '%GT_DM22%'
        OR UPPER(Q.SQL_TEXT) LIKE '%GT_DM51%')
 ORDER BY S.LAST_CALL_ET DESC;

PROMPT ===== P2. ⭐⭐ 최근 30분 SCM_MGR 상위 소요 문장 (병목 확정 — 여기 1~2위가 대상) =====
SELECT SQL_ID, EXECUTIONS EXEC_, ROUND(ELAPSED_TIME/1e6,1) ELA_S,
       ROUND(ELAPSED_TIME/GREATEST(EXECUTIONS,1)/1e6,1) ELA_PER_EXEC_S,
       BUFFER_GETS, ROWS_PROCESSED,
       SUBSTR(REPLACE(SQL_TEXT, CHR(10), ' '), 1, 110) SQL_HEAD
  FROM V$SQL
 WHERE PARSING_SCHEMA_NAME = 'SCM_MGR'
   AND LAST_ACTIVE_TIME > SYSDATE - 30/1440
   AND ELAPSED_TIME > 5e6
 ORDER BY ELAPSED_TIME DESC FETCH FIRST 12 ROWS ONLY;

PROMPT ===== P3. P2 1위 문장의 실행계획 (SQL_ID 를 바꿔 실행) =====
--  ⚠ 아래 '&&SQLID' 자리에 P2 의 1위 SQL_ID 를 넣어 실행할 것.
--  SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR('&&SQLID', NULL, 'ALLSTATS LAST +COST'));
--  (권한이 없으면) SELECT OPERATION, OPTIONS, OBJECT_NAME, CARDINALITY, COST
--                    FROM V$SQL_PLAN WHERE SQL_ID='&&SQLID' ORDER BY ID;

PROMPT ===== P4. ⭐ 인덱스 대조 — 사내 기준선(2026-08-20 실측)과 같은가 =====
--   DM_PLN_MKT_FCST            : 4개 (PK + N1 + N2 + N3)
--   DM_PLN_MKT_FCST_C          : **6개** (PK_..._PART, N1, N3, SUPPLY, SUPPLY_VERSION, IX03)
--   DM_PLN_MKT_FCST_RESULT     : 2개 (PK + N1)
--   DM_PLN_CFM_MKT_DEMAND_PLAN : 1개 (PK)
--   DM_PLN_BP_FCST_C           : 1개 (PK)
--   DM_PLN_SALES_PLAN          : 2개 (PK + N1)
--  ⇒ 클라우드가 더 적으면 **그것이 지연의 직접 원인**(대용량일수록 치명적). 이관 패키지 미포함 축.
SELECT TABLE_NAME, COUNT(DISTINCT INDEX_NAME) IDX_CNT,
       LISTAGG(DISTINCT INDEX_NAME, ',') WITHIN GROUP (ORDER BY INDEX_NAME) NAMES
  FROM ALL_INDEXES
 WHERE OWNER='SCM_MGR'
   AND TABLE_NAME IN ('DM_PLN_MKT_FCST','DM_PLN_MKT_FCST_C','DM_PLN_MKT_FCST_RESULT',
                      'DM_PLN_CFM_MKT_DEMAND_PLAN','DM_PLN_BP_FCST_C','DM_PLN_SALES_PLAN')
 GROUP BY TABLE_NAME ORDER BY 1;

PROMPT ===== P5. 통계 신선도 — 없거나 낡으면 플랜이 무너진다 =====
SELECT TABLE_NAME, NUM_ROWS, TO_CHAR(LAST_ANALYZED,'YYYY-MM-DD HH24:MI') LAST_ANALYZED, STALE_STATS
  FROM ALL_TAB_STATISTICS
 WHERE OWNER='SCM_MGR' AND PARTITION_NAME IS NULL
   AND TABLE_NAME IN ('DM_PLN_MKT_FCST','DM_PLN_MKT_FCST_C','DM_PLN_MKT_FCST_RESULT',
                      'DM_PLN_CFM_MKT_DEMAND_PLAN','DM_PLN_BP_FCST_C','DM_PLN_SALES_PLAN')
 ORDER BY 1;

PROMPT ===== P6. 세션 옵티마이저 설정 (클라우드 특유 계보 — GTT 추정 붕괴) =====
SELECT NAME, VALUE, ISDEFAULT
  FROM V$PARAMETER
 WHERE NAME IN ('optimizer_dynamic_sampling','optimizer_adaptive_statistics',
                'optimizer_features_enable','parallel_degree_policy','cursor_sharing');

PROMPT ===== 판독 =====
PROMPT   P4 에 사내 대비 인덱스 부재      → **1순위 원인**. 부족 인덱스 생성이 최우선(문안 별도 제공)
PROMPT   P5 LAST_ANALYZED 공란/오래됨     → 통계 수집 필요(대용량일수록 플랜 붕괴 폭이 크다)
PROMPT   P6 optimizer_dynamic_sampling=0  → GTT 카디널리티 1 추정 → NL 폭발 계보
PROMPT   P2 1위가 GT_DM35_* 적재문        → 볼륨 스케일 2차 튜닝 대상(사내와 다른 문장일 수 있음)
PROMPT   ※ P2/P3 결과를 보내주시면 해당 문장 기준으로 정정안을 만들겠습니다(추정 튜닝 금지 — hook #129)
