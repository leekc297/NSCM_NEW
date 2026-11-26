-- ==============================================================================================================
-- BATCHJOB 속도 점검 쿼리 · Oracle(클라우드) · 조회만 수행
-- 실행 : DBeaver 에서 쿼리 하나씩(커서를 쿼리 안에 두고 Ctrl+Enter). 결과를 회신
-- 입력 : PR_SSP_ANL_SHIP_PLAN_40, PR_SSP_ANL_SHIP_PLAN_40_BALANCE, PR_SSP_MAIL_SHIP_REQ_MINUS_BALANCE_40 · 조회 일수 3
-- 원문 기준 : 사내 ZIOUI1 2026-11-26 10:11:30 조회
--   PR_SSP_ANL_SHIP_PLAN_40 : PROCEDURE · VALID · LAST_DDL_TIME 2026-11-25 10:33:42 · 3579줄 · 단계 주석 25개
--   PR_SSP_ANL_SHIP_PLAN_40_BALANCE : PROCEDURE · VALID · LAST_DDL_TIME 2026-11-25 10:33:41 · 854줄 · 단계 주석 8개
--   PR_SSP_MAIL_SHIP_REQ_MINUS_BALANCE_40 : PROCEDURE · VALID · LAST_DDL_TIME 2026-11-25 16:29:53 · 2248줄 · 단계 주석 0개
-- 로그 PROGRAM_NAME(SCM_SYS_LOG_BATCH) : PR_SSP_ANL_SHIP_PLAN_40, PR_SSP_ANL_SHIP_PLAN_40_BALANCE, PR_SSP_MAIL_SHIP_REQ_MINUS_BALANCE_40
-- JOB : JOB_PR_SSP_PLN_SHIP_PLAN_40, JOB_PR_SSP_PLN_SHIP_PLAN_40_AZ, JOB_PR_SSP_PLN_SHIP_PLAN_40_C
-- 같은 JOB 의 다른 단계(실행 로그 [L1] 에 같이 표시) : PR_SSP_ANL_SHIP_CONFIRM_BATCH_40, PR_SSP_ANL_INVENTORY_RAW
-- [L4] ~ [L8] 은 V$ 조회 권한 필요. [L8] 은 Diagnostics Pack(ASH) 사용 조건. ORA-00942 가 나면 DBA 에 실행 요청
-- 단계 이름(STEP_NAME) = 프로시저 안 /* 1-1 … */ 형식 주석. 주석이 없는 프로시저는 빈 값이고 SRC_LINE 으로 봄
-- SCM_SYS_LOG_BATCH 는 인덱스가 없음(ZIOUI1 195,627행 기준). [L1] [L2] 는 전체 읽기
-- ==============================================================================================================

-- ==============================================================================================================
-- [L0] 현재 스키마 고정(파일 첫 쿼리)
-- 클라우드 접속 창의 현재 스키마가 SCM_MGR 가 아니면(2026-11-25 클라우드 회신 : 로그인 SCM_MGR, 현재 스키마 FP_MGR) 이름만 쓴 테이블, 패키지가 다른 스키마에서 찾아짐
-- 파일의 다른 쿼리보다 먼저 1회 실행. 새 접속 창을 열면 그 창에서도 다시 실행
-- ==============================================================================================================
ALTER SESSION SET CURRENT_SCHEMA = SCM_MGR;

-- ==============================================================================================================
-- [L0-1] 클라우드 원문 판 대조(사내 ZIOUI1 원문과 같은지)
-- 확인 : SAME_AS_CORP = N 이면 클라우드 원문이 사내 원문과 다름. 아래 SRC_LINE(줄 번호), 단계 이름은 클라우드 원문 기준으로 다시 봄(원문 회신 필요)
-- CLOUD_LINES 가 비어 있으면 클라우드에 객체 없음
-- ==============================================================================================================
WITH CORP AS (
  SELECT 'PR_SSP_ANL_SHIP_PLAN_40' AS NAME, 'PROCEDURE' AS TYPE, 3580 AS CORP_LINES, 7998329951007 AS CORP_HASH FROM DUAL
  UNION ALL SELECT 'PR_SSP_ANL_SHIP_PLAN_40_BALANCE' AS NAME, 'PROCEDURE' AS TYPE, 855 AS CORP_LINES, 1950206246293 AS CORP_HASH FROM DUAL
  UNION ALL SELECT 'PR_SSP_MAIL_SHIP_REQ_MINUS_BALANCE_40' AS NAME, 'PROCEDURE' AS TYPE, 2249 AS CORP_LINES, 4921209154246 AS CORP_HASH FROM DUAL
)
, CLOUD AS (
SELECT C.NAME
     , C.TYPE
     , COUNT(*) AS CLOUD_LINES
     , SUM(ORA_HASH(C.TEXT)) AS CLOUD_HASH
  FROM ALL_SOURCE C
 WHERE C.OWNER = 'SCM_MGR'
   AND (C.NAME, C.TYPE) IN (SELECT CORP.NAME, CORP.TYPE FROM CORP)
 GROUP BY C.NAME
        , C.TYPE
)
SELECT CORP.NAME
     , CORP.TYPE
     , (SELECT MAX(O.STATUS) FROM ALL_OBJECTS O WHERE O.OWNER = 'SCM_MGR' AND O.OBJECT_NAME = CORP.NAME AND O.OBJECT_TYPE = CORP.TYPE) AS STATUS
     , (SELECT TO_CHAR(MAX(O.LAST_DDL_TIME), 'YYYY-MM-DD HH24:MI:SS') FROM ALL_OBJECTS O WHERE O.OWNER = 'SCM_MGR' AND O.OBJECT_NAME = CORP.NAME AND O.OBJECT_TYPE = CORP.TYPE) AS LAST_DDL_TIME
     , CLOUD.CLOUD_LINES
     , CORP.CORP_LINES
     , CASE WHEN CLOUD.CLOUD_LINES = CORP.CORP_LINES AND CLOUD.CLOUD_HASH = CORP.CORP_HASH THEN 'Y' ELSE 'N' END AS SAME_AS_CORP
  FROM CORP
  LEFT JOIN CLOUD
    ON CLOUD.NAME = CORP.NAME
   AND CLOUD.TYPE = CORP.TYPE
 ORDER BY CORP.NAME
        , CORP.TYPE;

-- ==============================================================================================================
-- [L1] 최근 실행 로그 · 같은 JOB 에서 앞뒤로 도는 프로그램 포함
-- 확인 : 마지막 START 뒤에 END 나 ERROR 가 있는지. ERROR 면 LOG_MESSAGE, DESCRIPTION(오류 줄)
-- ==============================================================================================================
WITH PRM AS (SELECT 3 AS P_DAYS FROM DUAL)   /* 조회 일수. 이 줄의 값만 바꿔 실행 */
SELECT L.EVENT_DATE
     , L.PROGRAM_NAME
     , L.LOG_TYPE
     , L.LOG_COUNT
     , SUBSTR(L.LOG_MESSAGE, 1, 200) AS LOG_MESSAGE
     , SUBSTR(L.DESCRIPTION, 1, 300) AS DESCRIPTION
     , L.SQL_ERR_CODE
     , SUBSTR(L.IN_PARA_DATA, 1, 200) AS IN_PARA_DATA
     , L.CREATED_BY
  FROM SCM_SYS_LOG_BATCH L
     , PRM
 WHERE (L.PROGRAM_NAME IN ('PR_SSP_ANL_SHIP_PLAN_40', 'PR_SSP_ANL_SHIP_PLAN_40_BALANCE', 'PR_SSP_MAIL_SHIP_REQ_MINUS_BALANCE_40')
        OR L.PROGRAM_NAME IN ('PR_SSP_ANL_SHIP_CONFIRM_BATCH_40', 'PR_SSP_ANL_INVENTORY_RAW'))
   AND L.EVENT_DATE >= TRUNC(SYSDATE) - PRM.P_DAYS
 ORDER BY L.EVENT_DATE DESC;

-- ==============================================================================================================
-- [L2] 실행 회차별 소요 시간
-- 확인 : 회차마다 시작, 종료, 소요 분. END_TYPE 이 비어 있으면 실행 중이거나 세션이 끊긴 회차
-- ==============================================================================================================
WITH PRM AS (SELECT 3 AS P_DAYS FROM DUAL)   /* 조회 일수. 이 줄의 값만 바꿔 실행 */
, LG AS (
SELECT L.PROGRAM_NAME
     , L.EVENT_DATE
     , L.LOG_TYPE
     , LEAD(L.EVENT_DATE) OVER (PARTITION BY L.PROGRAM_NAME ORDER BY L.EVENT_DATE, DECODE(L.LOG_TYPE, 'START', 1, 'TXN', 2, 'ERROR', 3, 'END', 4)) AS NEXT_DATE
     , LEAD(L.LOG_TYPE)   OVER (PARTITION BY L.PROGRAM_NAME ORDER BY L.EVENT_DATE, DECODE(L.LOG_TYPE, 'START', 1, 'TXN', 2, 'ERROR', 3, 'END', 4)) AS NEXT_TYPE
  FROM SCM_SYS_LOG_BATCH L
     , PRM
 WHERE (L.PROGRAM_NAME IN ('PR_SSP_ANL_SHIP_PLAN_40', 'PR_SSP_ANL_SHIP_PLAN_40_BALANCE', 'PR_SSP_MAIL_SHIP_REQ_MINUS_BALANCE_40'))
   AND L.LOG_TYPE IN ('START', 'END', 'ERROR')
   AND L.EVENT_DATE >= TRUNC(SYSDATE) - PRM.P_DAYS
)
SELECT LG.PROGRAM_NAME
     , LG.EVENT_DATE AS START_DATE
     , CASE WHEN LG.NEXT_TYPE IN ('END', 'ERROR') THEN LG.NEXT_DATE END AS END_DATE
     , CASE WHEN LG.NEXT_TYPE IN ('END', 'ERROR') THEN LG.NEXT_TYPE END AS END_TYPE
     , ROUND((NVL(CASE WHEN LG.NEXT_TYPE IN ('END', 'ERROR') THEN LG.NEXT_DATE END, SYSDATE) - LG.EVENT_DATE) * 1440, 1) AS ELAPSED_MIN
     , TO_CHAR(LG.EVENT_DATE, 'HH24:MI') AS START_HHMI
  FROM LG
 WHERE LG.LOG_TYPE = 'START'
 ORDER BY LG.PROGRAM_NAME, LG.EVENT_DATE DESC;

-- ==============================================================================================================
-- [L2-1] 계획 진행 상태(SCM_MST_PLAN_DETAIL, 최근 10회)
-- 확인 : PLAN_STATUS 0 = 진행 중, 1 = 정상 종료, -1 = 오류. 0 인데 [L4] 에 세션이 없으면 비정상 종료
-- 조건값(MODELING_ID, DIVISION_ID, PLAN_TYPE) = 사내 원문, JOB 인자에서 읽은 값
-- ==============================================================================================================
SELECT D.MODELING_ID
     , D.DIVISION_ID
     , D.PLAN_ID
     , D.PLAN_SEQ
     , D.PLAN_TYPE
     , D.PLAN_STATUS
     , D.PLAN_START_DATE
     , D.PLAN_END_DATE
     , ROUND((NVL(D.PLAN_END_DATE, SYSDATE) - D.PLAN_START_DATE) * 1440, 1) AS ELAPSED_MIN
     , D.CREATION_DATE
     , D.LAST_UPDATE_DATE
  FROM SCM_MST_PLAN_DETAIL D
 WHERE D.CREATION_DATE >= TRUNC(SYSDATE) - 3
   AND D.MODELING_ID IN ('101')
   AND D.DIVISION_ID IN ('40')
   AND D.PLAN_TYPE IN ('SP')
 ORDER BY D.CREATION_DATE DESC NULLS LAST
 FETCH FIRST 10 ROWS ONLY;

-- ==============================================================================================================
-- [L3] JOB 상태, 실행 중 JOB
-- 확인 : RUNNING_SID 값이 있으면 실행 중. LAST_RUN_DURATION 으로 이전 회차 소요
-- ==============================================================================================================
SELECT J.JOB_NAME
     , J.ENABLED
     , J.STATE
     , J.LAST_START_DATE
     , J.LAST_RUN_DURATION
     , J.NEXT_RUN_DATE
     , J.REPEAT_INTERVAL
     , R.SESSION_ID AS RUNNING_SID
     , R.ELAPSED_TIME AS RUNNING_ELAPSED
  FROM ALL_SCHEDULER_JOBS J
  LEFT JOIN ALL_SCHEDULER_RUNNING_JOBS R
    ON R.OWNER    = J.OWNER
   AND R.JOB_NAME = J.JOB_NAME
 WHERE J.OWNER = 'SCM_MGR'
   AND J.JOB_NAME IN ('JOB_PR_SSP_PLN_SHIP_PLAN_40', 'JOB_PR_SSP_PLN_SHIP_PLAN_40_AZ', 'JOB_PR_SSP_PLN_SHIP_PLAN_40_C')
 ORDER BY J.JOB_NAME;

-- ==============================================================================================================
-- [L3-1] JOB 실행 이력
-- 확인 : 회차별 RUN_DURATION, STATUS, 오류
-- ==============================================================================================================
SELECT D.JOB_NAME
     , D.ACTUAL_START_DATE
     , D.RUN_DURATION
     , D.STATUS
     , D.ERROR#
     , SUBSTR(D.ADDITIONAL_INFO, 1, 300) AS ADDITIONAL_INFO
  FROM ALL_SCHEDULER_JOB_RUN_DETAILS D
 WHERE D.OWNER = 'SCM_MGR'
   AND D.JOB_NAME IN ('JOB_PR_SSP_PLN_SHIP_PLAN_40', 'JOB_PR_SSP_PLN_SHIP_PLAN_40_AZ', 'JOB_PR_SSP_PLN_SHIP_PLAN_40_C')
   AND D.ACTUAL_START_DATE >= SYSTIMESTAMP - INTERVAL '3' DAY
 ORDER BY D.ACTUAL_START_DATE DESC;

-- ==============================================================================================================
-- [L4] 지금 실행 중인 세션과 현재 단계(V$ 권한 필요)
-- 확인 : STEP_NAME, SRC_LINE = 지금 실행 중인 위치. EVENT, BLOCKING_SESSION = 대기 원인. BLOCKING_SESSION 값이 있으면 [L6]
-- ==============================================================================================================
WITH OBJ AS (
SELECT /*+ MATERIALIZE */ O.OBJECT_ID
     , O.OBJECT_NAME
  FROM ALL_OBJECTS O
 WHERE O.OWNER = 'SCM_MGR'
   AND O.OBJECT_NAME IN ('PR_SSP_ANL_SHIP_PLAN_40', 'PR_SSP_ANL_SHIP_PLAN_40_BALANCE', 'PR_SSP_MAIL_SHIP_REQ_MINUS_BALANCE_40')
   AND O.OBJECT_TYPE IN ('PROCEDURE', 'FUNCTION', 'PACKAGE', 'PACKAGE BODY')
)
, STEP AS (
SELECT /*+ MATERIALIZE */ C.NAME
     , C.LINE AS FROM_LINE
     , NVL(LEAD(C.LINE) OVER (PARTITION BY C.NAME ORDER BY C.LINE) - 1, 999999) AS TO_LINE
     , RTRIM(LTRIM(C.TEXT), ' ' || CHR(9) || CHR(10) || CHR(13)) AS STEP_NAME
  FROM ALL_SOURCE C
 WHERE C.OWNER = 'SCM_MGR'
   AND ((C.NAME = 'PR_SSP_ANL_SHIP_PLAN_40' AND C.TYPE = 'PROCEDURE')
    OR (C.NAME = 'PR_SSP_ANL_SHIP_PLAN_40_BALANCE' AND C.TYPE = 'PROCEDURE')
    OR (C.NAME = 'PR_SSP_MAIL_SHIP_REQ_MINUS_BALANCE_40' AND C.TYPE = 'PROCEDURE'))
   AND REGEXP_LIKE(C.TEXT, '^\s*/\*\s*[0-9](-[0-9]+)*(\.|\s)')
)
SELECT S.INST_ID
     , S.SID
     , S.SERIAL#
     , S.USERNAME
     , S.MODULE
     , S.ACTION
     , S.STATUS
     , S.LOGON_TIME
     , S.SQL_EXEC_START
     , ROUND((SYSDATE - S.SQL_EXEC_START) * 1440, 1) AS SQL_RUN_MIN
     , S.SQL_ID
     , (SELECT MAX(OBJ.OBJECT_NAME) FROM OBJ WHERE OBJ.OBJECT_ID = Q.PROGRAM_ID) AS SRC_OBJECT
     , Q.PROGRAM_LINE# AS SRC_LINE
     , (SELECT MAX(ST.STEP_NAME) FROM STEP ST, OBJ WHERE OBJ.OBJECT_ID = Q.PROGRAM_ID AND ST.NAME = OBJ.OBJECT_NAME AND Q.PROGRAM_LINE# BETWEEN ST.FROM_LINE AND ST.TO_LINE) AS STEP_NAME
     , S.EVENT
     , S.WAIT_CLASS
     , S.SECONDS_IN_WAIT
     , S.BLOCKING_INSTANCE
     , S.BLOCKING_SESSION
     , SUBSTR(Q.SQL_TEXT, 1, 200) AS SQL_TEXT
  FROM GV$SESSION S
  LEFT JOIN GV$SQL Q
    ON Q.INST_ID      = S.INST_ID
   AND Q.SQL_ID       = S.SQL_ID
   AND Q.CHILD_NUMBER = S.SQL_CHILD_NUMBER
 WHERE S.PLSQL_ENTRY_OBJECT_ID IN (SELECT OBJ.OBJECT_ID FROM OBJ)
    OR S.PLSQL_OBJECT_ID IN (SELECT OBJ.OBJECT_ID FROM OBJ)
    OR Q.PROGRAM_ID IN (SELECT OBJ.OBJECT_ID FROM OBJ)
    OR S.ACTION = 'JOB_PR_SSP_PLN_SHIP_PLAN_40'
    OR S.ACTION = 'JOB_PR_SSP_PLN_SHIP_PLAN_40_AZ'
    OR S.ACTION = 'JOB_PR_SSP_PLN_SHIP_PLAN_40_C';

-- ==============================================================================================================
-- [L5] SQL 별 소요 시간(V$ 권한 필요)
-- 확인 : 누적 소요 큰 순서. ELAPSED_SEC 는 공유 풀 누적값이라 앞 회차가 더해져 있음(EXECUTIONS, SEC_PER_EXEC 로 구분)
-- ==============================================================================================================
WITH PRM AS (SELECT 1 AS P_DAYS FROM DUAL)   /* 이 일수 안에 실행된 SQL. 이 줄의 값만 바꿔 실행 */
, OBJ AS (
SELECT /*+ MATERIALIZE */ O.OBJECT_ID
     , O.OBJECT_NAME
  FROM ALL_OBJECTS O
 WHERE O.OWNER = 'SCM_MGR'
   AND O.OBJECT_NAME IN ('PR_SSP_ANL_SHIP_PLAN_40', 'PR_SSP_ANL_SHIP_PLAN_40_BALANCE', 'PR_SSP_MAIL_SHIP_REQ_MINUS_BALANCE_40')
   AND O.OBJECT_TYPE IN ('PROCEDURE', 'FUNCTION', 'PACKAGE', 'PACKAGE BODY')
)
, STEP AS (
SELECT /*+ MATERIALIZE */ C.NAME
     , C.LINE AS FROM_LINE
     , NVL(LEAD(C.LINE) OVER (PARTITION BY C.NAME ORDER BY C.LINE) - 1, 999999) AS TO_LINE
     , RTRIM(LTRIM(C.TEXT), ' ' || CHR(9) || CHR(10) || CHR(13)) AS STEP_NAME
  FROM ALL_SOURCE C
 WHERE C.OWNER = 'SCM_MGR'
   AND ((C.NAME = 'PR_SSP_ANL_SHIP_PLAN_40' AND C.TYPE = 'PROCEDURE')
    OR (C.NAME = 'PR_SSP_ANL_SHIP_PLAN_40_BALANCE' AND C.TYPE = 'PROCEDURE')
    OR (C.NAME = 'PR_SSP_MAIL_SHIP_REQ_MINUS_BALANCE_40' AND C.TYPE = 'PROCEDURE'))
   AND REGEXP_LIKE(C.TEXT, '^\s*/\*\s*[0-9](-[0-9]+)*(\.|\s)')
)
SELECT OBJ.OBJECT_NAME AS SRC_OBJECT
     , Q.PROGRAM_LINE# AS SRC_LINE
     , (SELECT MAX(ST.STEP_NAME) FROM STEP ST WHERE ST.NAME = OBJ.OBJECT_NAME AND Q.PROGRAM_LINE# BETWEEN ST.FROM_LINE AND ST.TO_LINE) AS STEP_NAME
     , Q.SQL_ID
     , Q.EXECUTIONS
     , ROUND(Q.ELAPSED_TIME / 1000000, 1) AS ELAPSED_SEC
     , ROUND(Q.ELAPSED_TIME / NULLIF(Q.EXECUTIONS, 0) / 1000000, 2) AS SEC_PER_EXEC
     , ROUND(Q.CPU_TIME / 1000000, 1) AS CPU_SEC
     , Q.BUFFER_GETS
     , Q.DISK_READS
     , Q.ROWS_PROCESSED
     , Q.PLAN_HASH_VALUE
     , Q.LAST_ACTIVE_TIME
     , SUBSTR(Q.SQL_TEXT, 1, 150) AS SQL_TEXT
  FROM GV$SQL Q
  JOIN OBJ
    ON OBJ.OBJECT_ID = Q.PROGRAM_ID
     , PRM
 WHERE Q.LAST_ACTIVE_TIME >= TRUNC(SYSDATE) - PRM.P_DAYS + 1
 ORDER BY Q.ELAPSED_TIME DESC
 FETCH FIRST 50 ROWS ONLY;

-- ==============================================================================================================
-- [L6] 잠금 대기(V$ 권한 필요)
-- 확인 : 대상 세션을 막는 세션의 MODULE, ACTION, SQL
-- ==============================================================================================================
WITH OBJ AS (
SELECT /*+ MATERIALIZE */ O.OBJECT_ID
     , O.OBJECT_NAME
  FROM ALL_OBJECTS O
 WHERE O.OWNER = 'SCM_MGR'
   AND O.OBJECT_NAME IN ('PR_SSP_ANL_SHIP_PLAN_40', 'PR_SSP_ANL_SHIP_PLAN_40_BALANCE', 'PR_SSP_MAIL_SHIP_REQ_MINUS_BALANCE_40')
   AND O.OBJECT_TYPE IN ('PROCEDURE', 'FUNCTION', 'PACKAGE', 'PACKAGE BODY')
)
SELECT W.INST_ID
     , W.SID AS WAIT_SID
     , W.EVENT AS WAIT_EVENT
     , W.SECONDS_IN_WAIT
     , B.SID AS BLOCK_SID
     , B.SERIAL# AS BLOCK_SERIAL
     , B.USERNAME AS BLOCK_USER
     , B.MODULE AS BLOCK_MODULE
     , B.ACTION AS BLOCK_ACTION
     , B.STATUS AS BLOCK_STATUS
     , B.SQL_ID AS BLOCK_SQL_ID
     , B.PREV_SQL_ID AS BLOCK_PREV_SQL_ID
     , (SELECT O.OWNER || '.' || O.OBJECT_NAME FROM ALL_OBJECTS O WHERE O.OBJECT_ID = W.ROW_WAIT_OBJ#) AS LOCK_OBJECT
  FROM GV$SESSION W
  JOIN GV$SESSION B
    ON B.INST_ID = W.BLOCKING_INSTANCE
   AND B.SID     = W.BLOCKING_SESSION
 WHERE W.BLOCKING_SESSION IS NOT NULL
   AND (W.PLSQL_ENTRY_OBJECT_ID IN (SELECT OBJ.OBJECT_ID FROM OBJ)
        OR W.ACTION = 'JOB_PR_SSP_PLN_SHIP_PLAN_40'
        OR W.ACTION = 'JOB_PR_SSP_PLN_SHIP_PLAN_40_AZ'
        OR W.ACTION = 'JOB_PR_SSP_PLN_SHIP_PLAN_40_C');

-- ==============================================================================================================
-- [L7] 인스턴스 수
-- 확인 : 2 이상이면 GV$ 조회가 인스턴스마다 나뉘어 실행됨
-- ==============================================================================================================
SELECT INST_ID
     , INSTANCE_NAME
     , HOST_NAME
  FROM GV$INSTANCE
 ORDER BY INST_ID;

-- ==============================================================================================================
-- [L8] 이번 회차 단계별 소요와 대기(ASH, V$ 권한 + Diagnostics Pack)
-- 확인 : 단계(STEP_NAME)별 표본 수. 1표본 = 약 1초. EVENT 가 ON CPU 외 값이면 그 대기가 원인
-- 조회 범위 = 마지막 START 부터. START 가 없으면 P_FROM_MIN 분 전부터
-- ==============================================================================================================
WITH PRM AS (SELECT 180 AS P_FROM_MIN FROM DUAL)   /* START 로그가 없을 때 조회 시작(분 전). 이 줄의 값만 바꿔 실행 */
, OBJ AS (
SELECT /*+ MATERIALIZE */ O.OBJECT_ID
     , O.OBJECT_NAME
  FROM ALL_OBJECTS O
 WHERE O.OWNER = 'SCM_MGR'
   AND O.OBJECT_NAME IN ('PR_SSP_ANL_SHIP_PLAN_40', 'PR_SSP_ANL_SHIP_PLAN_40_BALANCE', 'PR_SSP_MAIL_SHIP_REQ_MINUS_BALANCE_40')
   AND O.OBJECT_TYPE IN ('PROCEDURE', 'FUNCTION', 'PACKAGE', 'PACKAGE BODY')
)
, STEP AS (
SELECT /*+ MATERIALIZE */ C.NAME
     , C.LINE AS FROM_LINE
     , NVL(LEAD(C.LINE) OVER (PARTITION BY C.NAME ORDER BY C.LINE) - 1, 999999) AS TO_LINE
     , RTRIM(LTRIM(C.TEXT), ' ' || CHR(9) || CHR(10) || CHR(13)) AS STEP_NAME
  FROM ALL_SOURCE C
 WHERE C.OWNER = 'SCM_MGR'
   AND ((C.NAME = 'PR_SSP_ANL_SHIP_PLAN_40' AND C.TYPE = 'PROCEDURE')
    OR (C.NAME = 'PR_SSP_ANL_SHIP_PLAN_40_BALANCE' AND C.TYPE = 'PROCEDURE')
    OR (C.NAME = 'PR_SSP_MAIL_SHIP_REQ_MINUS_BALANCE_40' AND C.TYPE = 'PROCEDURE'))
   AND REGEXP_LIKE(C.TEXT, '^\s*/\*\s*[0-9](-[0-9]+)*(\.|\s)')
)
, LAST_RUN AS (
SELECT /*+ MATERIALIZE */ CAST(NVL(MAX(L.EVENT_DATE), MAX(SYSDATE - PRM.P_FROM_MIN / 1440)) AS TIMESTAMP) AS FROM_TS
  FROM PRM
  LEFT JOIN SCM_SYS_LOG_BATCH L
    ON (L.PROGRAM_NAME IN ('PR_SSP_ANL_SHIP_PLAN_40', 'PR_SSP_ANL_SHIP_PLAN_40_BALANCE', 'PR_SSP_MAIL_SHIP_REQ_MINUS_BALANCE_40'))
   AND L.LOG_TYPE     = 'START'
   AND L.EVENT_DATE  >= TRUNC(SYSDATE) - 1
)
, ASH AS (
SELECT /*+ MATERIALIZE */ A.INST_ID
     , A.SQL_ID
     , NVL(A.EVENT, 'ON CPU') AS EVENT
     , COUNT(*) AS SAMPLE_CNT
     , MIN(A.SAMPLE_TIME) AS FIRST_SAMPLE
     , MAX(A.SAMPLE_TIME) AS LAST_SAMPLE
  FROM GV$ACTIVE_SESSION_HISTORY A
 WHERE A.PLSQL_ENTRY_OBJECT_ID IN (SELECT OBJ.OBJECT_ID FROM OBJ)
   AND A.SAMPLE_TIME >= (SELECT LAST_RUN.FROM_TS FROM LAST_RUN)
 GROUP BY A.INST_ID
        , A.SQL_ID
        , NVL(A.EVENT, 'ON CPU')
)
, SQL_LINE AS (
SELECT /*+ MATERIALIZE */ Q.INST_ID
     , Q.SQL_ID
     , MAX(OBJ.OBJECT_NAME) AS SRC_OBJECT
     , MAX(Q.PROGRAM_LINE#) AS SRC_LINE
     , MAX(SUBSTR(Q.SQL_TEXT, 1, 150)) AS SQL_TEXT
  FROM GV$SQL Q
  JOIN OBJ
    ON OBJ.OBJECT_ID = Q.PROGRAM_ID
 GROUP BY Q.INST_ID
        , Q.SQL_ID
)
SELECT SL.SRC_OBJECT
     , ST.STEP_NAME
     , SL.SRC_LINE
     , A.SQL_ID
     , A.EVENT
     , A.SAMPLE_CNT
     , A.FIRST_SAMPLE
     , A.LAST_SAMPLE
     , SL.SQL_TEXT
  FROM ASH A
  LEFT JOIN SQL_LINE SL
    ON SL.INST_ID = A.INST_ID
   AND SL.SQL_ID  = A.SQL_ID
  LEFT JOIN STEP ST
    ON ST.NAME = SL.SRC_OBJECT
   AND SL.SRC_LINE BETWEEN ST.FROM_LINE AND ST.TO_LINE
 ORDER BY A.SAMPLE_CNT DESC;

