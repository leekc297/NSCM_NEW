-- ==============================================================================================================
-- BATCHJOB 속도 점검 2차 쿼리 · Oracle(클라우드 QA) · 실행일 20261125
-- 목적 : 1차 회신(2026-11-26 10:40) 에서 SHIP_PLAN_40 1회차 2-4 단계 문장 16zd7hkh15tk1 이 약 5,500초, 2~4회차는 10~20초. 차이 원인 확인과 dynamic_sampling 2 효과 확인
-- 클라우드 설정(1차 [C13]) : optimizer_dynamic_sampling 0(ISDEFAULT FALSE), optimizer_adaptive_plans FALSE. 사내 ZIOUI1 은 2, TRUE
-- 실행 : [D0] 먼저. [D7] ~ [D9] 는 같은 접속 창에서 순서대로. 결과를 블록 번호와 함께 회신
-- [D7] [D8-1] 의 EXPLAIN PLAN 은 PLAN_TABLE(세션 임시)에 계획만 기록함. [D8-3] 만 실제 조회
-- 작성 : 2026-11-26 10:57
-- ==============================================================================================================

-- ==============================================================================================================
-- [D0] 현재 스키마 고정(파일 첫 쿼리)
-- 파일의 다른 쿼리보다 먼저 1회 실행
-- ==============================================================================================================
ALTER SESSION SET CURRENT_SCHEMA = SCM_MGR;

-- ==============================================================================================================
-- [D1] 상위 SQL 실행 단위별 세션, 실행계획(AWR ASH)
-- 확인 : 같은 SQL_ID 가 회차(세션, SQL_EXEC_ID)마다 다른 SQL_PLAN_HASH_VALUE 로 실행됐는지, 어느 MODULE, PROGRAM(직접 실행, JOB)에서 실행됐는지
-- 16zd7hkh15tk1 = SHIP_PLAN_40 2-4 단계 GT_SSP_PLAN_FROZEN_POUCH 적재. 1회차 약 5,500초, 2~4회차 10~20초
-- ==============================================================================================================
WITH PRM AS (SELECT TO_DATE('20261125', 'YYYYMMDD') AS P_DAY FROM DUAL)   /* 실행일. 이 줄의 값만 바꿔 실행 */
SELECT A.SQL_ID
     , A.SESSION_ID
     , A.SESSION_SERIAL#
     , A.SQL_EXEC_ID
     , A.SQL_EXEC_START
     , A.SQL_PLAN_HASH_VALUE
     , A.MODULE
     , A.PROGRAM
     , A.MACHINE
     , COUNT(*) * 10 AS EST_SEC
     , MIN(A.SAMPLE_TIME) AS FIRST_SAMPLE
     , MAX(A.SAMPLE_TIME) AS LAST_SAMPLE
  FROM DBA_HIST_ACTIVE_SESS_HISTORY A
 WHERE A.DBID = (SELECT D.DBID FROM V$DATABASE D)
   AND A.SNAP_ID IN (SELECT S.SNAP_ID FROM DBA_HIST_SNAPSHOT S, PRM P WHERE S.END_INTERVAL_TIME >= CAST(P.P_DAY AS TIMESTAMP) AND S.BEGIN_INTERVAL_TIME < CAST(P.P_DAY + 1 AS TIMESTAMP))
   AND A.SQL_ID IN ('16zd7hkh15tk1', '8jgbuy1dtd7u3', 'awr2c30u4h31c', 'aj7nw6qjt4tjv', '28b97wub4mwwg', '306k4jd69a9wz', 'dhq3n2wf4406u')
 GROUP BY A.SQL_ID
        , A.SESSION_ID
        , A.SESSION_SERIAL#
        , A.SQL_EXEC_ID
        , A.SQL_EXEC_START
        , A.SQL_PLAN_HASH_VALUE
        , A.MODULE
        , A.PROGRAM
        , A.MACHINE
 ORDER BY A.SQL_ID
        , MIN(A.SAMPLE_TIME);

-- ==============================================================================================================
-- [D2] 상위 SQL 구간별 실행 통계(AWR SQLSTAT)
-- 확인 : PLAN_HASH_VALUE, OPTIMIZER_ENV_HASH_VALUE 가 구간마다 다른지. ENV 값이 다르면 실행 세션의 옵티마이저 설정(dynamic_sampling 등)이 달랐음
-- ROWS_DELTA = 처리 행 수, ELAPSED_SEC 는 구간 안 누적
-- ==============================================================================================================
WITH PRM AS (SELECT TO_DATE('20261125', 'YYYYMMDD') AS P_DAY FROM DUAL)   /* 실행일. 이 줄의 값만 바꿔 실행 */
SELECT A.SQL_ID
     , S.BEGIN_INTERVAL_TIME
     , A.PLAN_HASH_VALUE
     , A.OPTIMIZER_ENV_HASH_VALUE
     , A.EXECUTIONS_DELTA AS EXEC_DELTA
     , ROUND(A.ELAPSED_TIME_DELTA / 1000000, 1) AS ELAPSED_SEC
     , ROUND(A.CPU_TIME_DELTA / 1000000, 1) AS CPU_SEC
     , A.BUFFER_GETS_DELTA AS BUFFER_GETS
     , A.ROWS_PROCESSED_DELTA AS ROWS_DELTA
  FROM DBA_HIST_SQLSTAT A
  JOIN DBA_HIST_SNAPSHOT S
    ON S.DBID            = A.DBID
   AND S.SNAP_ID         = A.SNAP_ID
   AND S.INSTANCE_NUMBER = A.INSTANCE_NUMBER
 WHERE A.DBID = (SELECT D.DBID FROM V$DATABASE D)
   AND A.SNAP_ID IN (SELECT S.SNAP_ID FROM DBA_HIST_SNAPSHOT S, PRM P WHERE S.END_INTERVAL_TIME >= CAST(P.P_DAY AS TIMESTAMP) AND S.BEGIN_INTERVAL_TIME < CAST(P.P_DAY + 1 AS TIMESTAMP))
   AND A.SQL_ID IN ('16zd7hkh15tk1', '8jgbuy1dtd7u3', 'awr2c30u4h31c', 'aj7nw6qjt4tjv', '28b97wub4mwwg', '306k4jd69a9wz', 'dhq3n2wf4406u')
 ORDER BY A.SQL_ID
        , S.BEGIN_INTERVAL_TIME;

-- ==============================================================================================================
-- [D3] 16zd7hkh15tk1 실행계획 전체(AWR, 계획마다)
-- 확인 : 계획이 2개 이상이면 1회차 계획과 2~4회차 계획의 차이(MERGE JOIN CARTESIAN + SCM_ITEM_M 전체 읽기 위치)
-- ==============================================================================================================
SELECT P.PLAN_TABLE_OUTPUT
  FROM TABLE(DBMS_XPLAN.DISPLAY_AWR('16zd7hkh15tk1', NULL, NULL, 'TYPICAL')) P;

-- ==============================================================================================================
-- [D4] 16zd7hkh15tk1 바인드 값(AWR)
-- 확인 : :B3 사업부, :B2 시작일, :B1 종료일이 회차마다 같은지
-- ==============================================================================================================
WITH PRM AS (SELECT TO_DATE('20261125', 'YYYYMMDD') AS P_DAY FROM DUAL)   /* 실행일. 이 줄의 값만 바꿔 실행 */
SELECT B.SNAP_ID
     , B.NAME
     , B.POSITION
     , B.VALUE_STRING
     , B.LAST_CAPTURED
  FROM DBA_HIST_SQLBIND B
 WHERE B.DBID = (SELECT D.DBID FROM V$DATABASE D)
   AND B.SQL_ID = '16zd7hkh15tk1'
   AND B.SNAP_ID IN (SELECT S.SNAP_ID FROM DBA_HIST_SNAPSHOT S, PRM P WHERE S.END_INTERVAL_TIME >= CAST(P.P_DAY AS TIMESTAMP) AND S.BEGIN_INTERVAL_TIME < CAST(P.P_DAY + 1 AS TIMESTAMP))
 ORDER BY B.SNAP_ID
        , B.POSITION;

-- ==============================================================================================================
-- [D5] FP 원천 행 수와 계획 기준값
-- 확인 : FP_DAILY_PRODUCTIOIN_PLAN_H 실행일 범위 행 수, AUTO_PLAN_CALL_FLAG 기준(ATTRIBUTE1, MODIFY_DATE). MODIFY_DATE + 3시간 전후로 뷰 조건이 바뀜
-- ==============================================================================================================
SELECT 'FP_DAILY_PRODUCTIOIN_PLAN_H(40, 20261124~20270216)' AS SRC
     , TO_CHAR(COUNT(*)) AS VAL
     , TO_CHAR(MAX(H.UPDATE_TIME), 'YYYY-MM-DD HH24:MI:SS') AS LAST_TIME
  FROM FP_MGR.FP_DAILY_PRODUCTIOIN_PLAN_H H
 WHERE H.DIVISION_ID = '40'
   AND H.PLAN_DATE >= TO_DATE('20261124', 'YYYYMMDD')
   AND H.PLAN_DATE <  TO_DATE('20270217', 'YYYYMMDD')
UNION ALL
SELECT 'AUTO_PLAN_CALL_FLAG ' || V.SEGMENT1 || '/' || V.SEGMENT2
     , V.ATTRIBUTE1
     , TO_CHAR(V.MODIFY_DATE, 'YYYY-MM-DD HH24:MI:SS')
  FROM FP_MGR.SCM_SYS_LOOKUP_VALUE V
 WHERE V.LOOKUP_TYPE_CODE = 'AUTO_PLAN_CALL_FLAG'
   AND V.ACTIVE_FLAG = 'Y';

-- ==============================================================================================================
-- [D6] 결과 캐시 설정과 사용 현황
-- 확인 : FN_GET_SCM_SITE_ID_PLANT 안 SQL(98w93qutz2749)이 11-25 16,821,385회 실행됨. RESULT_CACHE 함수인데 캐시가 쓰였는지
-- 사내 ZIOUI1 값 : result_cache_mode MANUAL, result_cache_max_size 687865856
-- ==============================================================================================================
SELECT 'PARAM ' || P.NAME AS NAME
     , P.VALUE
  FROM V$PARAMETER P
 WHERE P.NAME LIKE 'result_cache%'
UNION ALL
SELECT 'STAT ' || R.NAME
     , TO_CHAR(R.VALUE)
  FROM V$RESULT_CACHE_STATISTICS R;

-- ==============================================================================================================
-- [D7] dynamic_sampling 0(현재) 실행계획 : 실행하지 않고 계획만
-- EXPLAIN PLAN 은 문장을 실행하지 않음. D7 의 두 문장(EXPLAIN, DISPLAY)을 차례로 실행
-- ==============================================================================================================
EXPLAIN PLAN SET STATEMENT_ID = 'DS0' FOR
SELECT COUNT(*) AS ROW_CNT
     , SUM(PLAN_QTY) AS PLAN_QTY
  FROM SSP_DNM_PLAN_FROZEN_V
 WHERE DIVISION_ID   = '40'
   AND SCM_SITE_ID  IS NOT NULL
   AND PLAN_QTY      > 0
   AND PLAN_DATE    >= TO_DATE('20261124', 'YYYYMMDD')
   AND PLAN_DATE     < TO_DATE('20270217', 'YYYYMMDD');

-- ==============================================================================================================
-- [D7-1] D7 계획 보기
-- 확인 : MERGE JOIN CARTESIAN, SCM_ITEM_M STORAGE FULL, FP_DAILY_PRODUCTIOIN_PLAN_H 반복 접근이 있는지
-- ==============================================================================================================
SELECT P.ID
     , LPAD(' ', 2 * P.DEPTH) || P.OPERATION || ' ' || P.OPTIONS AS OPERATION
     , P.OBJECT_OWNER || '.' || P.OBJECT_NAME AS OBJECT_NAME
     , P.CARDINALITY
     , P.COST
     , SUBSTR(P.ACCESS_PREDICATES, 1, 200) AS ACCESS_PRED
     , SUBSTR(P.FILTER_PREDICATES, 1, 200) AS FILTER_PRED
  FROM PLAN_TABLE P
 WHERE P.STATEMENT_ID = 'DS0'
   AND P.PLAN_ID = (SELECT MAX(X.PLAN_ID) FROM PLAN_TABLE X WHERE X.STATEMENT_ID = 'DS0')
 ORDER BY P.ID;

-- ==============================================================================================================
-- [D8] dynamic_sampling 2 세션 설정(이 접속 창에만 적용)
-- UI 조회에서 효과가 있었던 설정(EXECUTE IMMEDIATE 'ALTER SESSION SET optimizer_dynamic_sampling = 2')과 같은 값
-- ==============================================================================================================
ALTER SESSION SET optimizer_dynamic_sampling = 2;

-- ==============================================================================================================
-- [D8-1] dynamic_sampling 2 실행계획 : 실행하지 않고 계획만
-- D8 실행 뒤 같은 접속 창에서 실행
-- ==============================================================================================================
EXPLAIN PLAN SET STATEMENT_ID = 'DS2' FOR
SELECT COUNT(*) AS ROW_CNT
     , SUM(PLAN_QTY) AS PLAN_QTY
  FROM SSP_DNM_PLAN_FROZEN_V
 WHERE DIVISION_ID   = '40'
   AND SCM_SITE_ID  IS NOT NULL
   AND PLAN_QTY      > 0
   AND PLAN_DATE    >= TO_DATE('20261124', 'YYYYMMDD')
   AND PLAN_DATE     < TO_DATE('20270217', 'YYYYMMDD');

-- ==============================================================================================================
-- [D8-2] D8-1 계획 보기
-- 확인 : D7-1 과 계획이 다른지. CARDINALITY(예상 행)가 D7-1 과 다른지
-- ==============================================================================================================
SELECT P.ID
     , LPAD(' ', 2 * P.DEPTH) || P.OPERATION || ' ' || P.OPTIONS AS OPERATION
     , P.OBJECT_OWNER || '.' || P.OBJECT_NAME AS OBJECT_NAME
     , P.CARDINALITY
     , P.COST
     , SUBSTR(P.ACCESS_PREDICATES, 1, 200) AS ACCESS_PRED
     , SUBSTR(P.FILTER_PREDICATES, 1, 200) AS FILTER_PRED
  FROM PLAN_TABLE P
 WHERE P.STATEMENT_ID = 'DS2'
   AND P.PLAN_ID = (SELECT MAX(X.PLAN_ID) FROM PLAN_TABLE X WHERE X.STATEMENT_ID = 'DS2')
 ORDER BY P.ID;

-- ==============================================================================================================
-- [D8-3] dynamic_sampling 2 상태로 실제 조회(조회만)
-- D8 상태에서 실행. 소요 시간과 건수를 회신. 5분이 넘으면 중지(DBeaver 취소)하고 그 사실을 회신
-- D7 상태(dynamic_sampling 0)로는 실행하지 않음. 1회차에서 같은 원천을 약 2시간 읽음
-- ==============================================================================================================
SELECT COUNT(*) AS ROW_CNT
     , SUM(PLAN_QTY) AS PLAN_QTY
  FROM SSP_DNM_PLAN_FROZEN_V
 WHERE DIVISION_ID   = '40'
   AND SCM_SITE_ID  IS NOT NULL
   AND PLAN_QTY      > 0
   AND PLAN_DATE    >= TO_DATE('20261124', 'YYYYMMDD')
   AND PLAN_DATE     < TO_DATE('20270217', 'YYYYMMDD');

-- ==============================================================================================================
-- [D10] MAIL 클라우드 원문의 STRING_SPLIT 사용 줄
-- 확인 : 1회차 GT_SSP0026_PIVOT 적재(8jgbuy1dtd7u3) 669초 중 STRING_SPLIT 안 시간 361초. 사내 원문은 STRING_SPLIT 조건 변수가 항상 NULL. 클라우드 원문(1차 [C1] SAME_AS_CORP = N)과 비교
-- 클라우드 LAST_DDL_TIME 2026-11-25 16:35:59 는 11-25 회차 뒤라 실행 당시 원문과 다를 수 있음
-- ==============================================================================================================
SELECT C.LINE
     , RTRIM(C.TEXT, CHR(10) || CHR(13)) AS TEXT
  FROM ALL_SOURCE C
 WHERE C.OWNER = 'SCM_MGR'
   AND C.NAME  = 'PR_SSP_MAIL_SHIP_REQ_MINUS_BALANCE_40'
   AND C.TYPE  = 'PROCEDURE'
   AND (UPPER(C.TEXT) LIKE '%STRING_SPLIT%' OR UPPER(C.TEXT) LIKE '%INSERT INTO GT_SSP0026_PIVOT%')
 ORDER BY C.LINE;

-- ==============================================================================================================
-- [D9] 설정 원복
-- D8 이후 같은 접속 창에서 다른 쿼리를 돌릴 때 실행
-- ==============================================================================================================
ALTER SESSION SET optimizer_dynamic_sampling = 0;

