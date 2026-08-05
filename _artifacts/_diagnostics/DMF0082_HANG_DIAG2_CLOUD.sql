-- =============================================================================
-- DMF0082_HANG_DIAG2_CLOUD.sql  — 2차 (범인 확정 후 정밀 확인)
--
--   1차 진단으로 **범인 SQL 확정**:
--     SQL_ID `8kwr6fp21yu7f` / PHV 1668490756
--     `INSERT INTO SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_PRICE_C`  (PKG_DMF0082 L1131)
--     · 09:55:40 ~ 10:11:59 = **16분 이상 계속 실행 중**, ROWS_PROCESSED 0 (미완료)
--     · BUFFER_GETS 158,411 / **DISK_READS 142,450 (90%가 물리 읽기)**
--     · ASH 563 샘플이 `cell single block physical read: flash cache` = **단일블록 랜덤 IO 폭증**
--   → 락도 mutex 도 루프도 아닙니다. **인덱스 부적합으로 인한 초장시간 실행**입니다.
--
--   ⚠ READ-ONLY. 계정: SCM_MGR
--   ⛔ 가능하면 **스피너가 도는 동안** 실행하세요([1] 실계획 확보를 위해).
--      이미 취소했다면 [2]~[5] 만으로도 원인 규모는 파악됩니다.
-- =============================================================================
SET LINESIZE 300
SET PAGESIZE 5000
SET LONG 500000
SET LONGCHUNKSIZE 500000
SET TRIMSPOOL ON
SET FEEDBACK ON
COLUMN COLS FORMAT A96
COLUMN INDEX_NAME FORMAT A38

SPOOL DMF0082_HANG_DIAG2.txt

PROMPT ############################################################
PROMPT [1] ⭐⭐ 범인 SQL 실행계획 — 어떤 접근으로 14만 블록을 읽는가
PROMPT ############################################################
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR('8kwr6fp21yu7f', NULL,
       'ALLSTATS LAST +COST +BYTES +PREDICATE'));
-- 커서가 없으면 AWR 에서
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_AWR('8kwr6fp21yu7f'));
--
-- ⭐ 확인 포인트
--   ① `DM_PLN_CFM_SELLING_PRICE_C` 접근이 INDEX RANGE SCAN 인지 TABLE ACCESS FULL 인지
--   ② NESTED LOOPS 의 **Starts** 값 (수만이면 그 조인이 원인)
--   ③ 어느 테이블이 **구동(driving)** 인지 — GT_DMF0082_TEMP_SITE_ITEM 이면 그 행수가 곧 반복 횟수

PROMPT ############################################################
PROMPT [2] ⭐ 이 SQL 이 읽는 테이블들의 클라우드 실제 규모
PROMPT ############################################################
SELECT 'DM_PLN_CFM_SELLING_PRICE_C' T, COUNT(*) TOTAL,
       SUM(CASE WHEN DIVISION_ID='81' THEN 1 ELSE 0 END) DIV81,
       SUM(CASE WHEN DIVISION_ID='40' THEN 1 ELSE 0 END) DIV40
  FROM DM_PLN_CFM_SELLING_PRICE_C
UNION ALL
SELECT 'DM_PLN_CFM_MKT_DEMAND_PLAN_C', COUNT(*),
       SUM(CASE WHEN DIVISION_ID='81' THEN 1 ELSE 0 END),
       SUM(CASE WHEN DIVISION_ID='40' THEN 1 ELSE 0 END)
  FROM DM_PLN_CFM_MKT_DEMAND_PLAN_C;
-- ⭐ 사내 실측 대조: DM_PLN_CFM_SELLING_PRICE_C **236,327** / DM_PLN_CFM_MKT_DEMAND_PLAN_C 3,274,247
--    클라우드가 사내보다 훨씬 크면(참고: SCM_MST_FUTURE_PRICE_C 는 사내 3.0M → 클라우드 68M = 22배)
--    같은 계획으로도 시간이 배수로 늘어납니다.

PROMPT ############################################################
PROMPT [3] ⭐⭐ 인덱스 부적합 확인 — 이게 핵심 원인입니다
PROMPT ############################################################
SELECT i.TABLE_NAME, i.INDEX_NAME, i.UNIQUENESS, i.STATUS, i.NUM_ROWS,
       TO_CHAR(i.LAST_ANALYZED,'YYYY-MM-DD') ANZ,
       (SELECT LISTAGG(c.COLUMN_NAME,',') WITHIN GROUP (ORDER BY c.COLUMN_POSITION)
          FROM USER_IND_COLUMNS c WHERE c.INDEX_NAME=i.INDEX_NAME) COLS
  FROM USER_INDEXES i
 WHERE i.TABLE_NAME IN ('DM_PLN_CFM_SELLING_PRICE_C','DM_PLN_CFM_MKT_DEMAND_PLAN_C')
 ORDER BY i.TABLE_NAME, i.INDEX_NAME;
--
-- ⭐ 사내 실측: `DM_PLN_CFM_SELLING_PRICE_C` 는 **인덱스가 PK 1본뿐**이고 컬럼 순서가
--    DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE, END_CUSTOMER,
--    SCM_SITE_ID, PLANT_SITE_ID, CELL_PROD_SITE_ID, ITEM_ID, YYYYMMDD, MEASURE, ...
--
--   그런데 L1131 SQL 의 조건은
--     WHERE  A.DIVISION_ID = :p_division_id
--       AND  A.YYYYMMDD BETWEEN :p_from AND :p_to
--     JOIN   GT_DMF0082_TEMP_SITE_ITEM  ON PROJECT_CODE, SCM_SITE_ID, ITEM_ID
--     JOIN   GT_DMF0082_T_VERSION       ON VERSION_NO
--
--   → PK 선두 2개(DIVISION_ID, VERSION_NO)까지만 쓰고, 그 뒤
--     **CUTOFF_TYPE / CUTOFF_YYYYMMDD / END_CUSTOMER / PLANT_SITE_ID / CELL_PROD_SITE_ID**
--     5개를 건너뛰어야 PROJECT_CODE·SCM_SITE_ID·ITEM_ID·YYYYMMDD 에 닿습니다.
--     그래서 인덱스 범위가 넓게 잡히고 **테이블 단일블록 랜덤 읽기가 폭증**합니다.

PROMPT ############################################################
PROMPT [4] 왜 하필 DIVISION 81 인가 — 구동 행수 비교
PROMPT ############################################################
SELECT DIVISION_ID, COUNT(*) AS SITE_ITEM_CNT
  FROM SCM_MST_SITE_ITEM
 WHERE DIVISION_ID IN ('40','81','82')
 GROUP BY DIVISION_ID ORDER BY 1;
-- 클라우드 1차 실측: 40 = 22,525 / **81 = 52,600** / 82 = 37,423
-- → 81 은 40 의 **2.3배**. `GT_DMF0082_TEMP_SITE_ITEM` 이 구동 테이블이면
--   반복(Starts)이 2.3배 → 랜덤 IO 도 2.3배. 40 은 끝나고 81 만 멈추는 이유와 정합.

PROMPT ############################################################
PROMPT [5] 이 SQL 의 누적 실적 (완료된 적이 있는지)
PROMPT ############################################################
SELECT SQL_ID, PLAN_HASH_VALUE PHV, EXECUTIONS, ROWS_PROCESSED,
       ROUND(ELAPSED_TIME/1e6,1) AS 누적초,
       ROUND(ELAPSED_TIME/1e6/GREATEST(EXECUTIONS,1),1) AS 회당초,
       BUFFER_GETS, DISK_READS,
       TO_CHAR(FIRST_LOAD_TIME) FIRST_LOAD,
       TO_CHAR(LAST_ACTIVE_TIME,'MM-DD HH24:MI:SS') LAST_ACT
  FROM V$SQL WHERE SQL_ID = '8kwr6fp21yu7f'
 ORDER BY CHILD_NUMBER;
-- EXECUTIONS = 0 이면 **한 번도 완료된 적 없음** = 사실상 무한대기

PROMPT ############################################################
PROMPT [6] 같은 계열(_C) 문장들도 같은 문제인지
PROMPT ############################################################
SELECT SQL_ID, PLAN_HASH_VALUE PHV, EXECUTIONS EX, ROWS_PROCESSED RP,
       ROUND(ELAPSED_TIME/1e6,1) AS 누적초, BUFFER_GETS, DISK_READS,
       SUBSTR(REGEXP_REPLACE(SQL_TEXT,'\s+',' '),1,70) T
  FROM V$SQL
 WHERE REGEXP_LIKE(SQL_TEXT,'GT_DMF0082_T_LAST_DATA_SETUP_(FCST|PRICE)_C','i')
 ORDER BY ELAPSED_TIME DESC;
-- 1차 ASH 에서 `br0qzg41fkcrf`(FCST_C) 와 `g2f236ssg1rpu`(FCST_C) 도 관측됨 → 동일 계열 확인

PROMPT ############################################################
PROMPT [7] 통계 상태 (계획 오판 요인 배제용)
PROMPT ############################################################
SELECT TABLE_NAME, NUM_ROWS, BLOCKS, TO_CHAR(LAST_ANALYZED,'YYYY-MM-DD HH24:MI') ANZ
  FROM USER_TABLES
 WHERE TABLE_NAME IN ('DM_PLN_CFM_SELLING_PRICE_C','DM_PLN_CFM_MKT_DEMAND_PLAN_C',
                      'SCM_MST_SITE_ITEM','SCM_MST_FUTURE_PRICE_C')
 ORDER BY TABLE_NAME;

SELECT TABLE_NAME, NUM_ROWS, BLOCKS,
       DBMS_STATS.GET_PREFS('GLOBAL_TEMP_TABLE_STATS','SCM_MGR',TABLE_NAME) PREF,
       TO_CHAR(LAST_ANALYZED,'MM-DD HH24:MI') ANZ
  FROM USER_TABLES
 WHERE TABLE_NAME IN ('GT_DMF0082_TEMP_SITE_ITEM','GT_DMF0082_T_VERSION')
 ORDER BY TABLE_NAME;
-- GT 쪽 NUM_ROWS 가 비어 있으면 동적 샘플링에 의존 → 계획이 흔들릴 수 있음

SPOOL OFF

PROMPT
PROMPT =============================================================
PROMPT 회신 요망: DMF0082_HANG_DIAG2.txt
PROMPT  ⭐ 핵심은 [1] 실행계획(구동 테이블 / NESTED LOOPS Starts)과
PROMPT     [2] DM_PLN_CFM_SELLING_PRICE_C 의 클라우드 실제 행수입니다.
PROMPT =============================================================
