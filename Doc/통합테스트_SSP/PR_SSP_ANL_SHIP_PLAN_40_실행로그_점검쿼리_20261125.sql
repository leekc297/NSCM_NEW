-- ==============================================================================================================
-- PR_SSP_ANL_SHIP_PLAN_40(40 출하계획 생성) 실행 로그 · 진행 단계 점검 쿼리 · Oracle · 20261125
-- 실행 : DBeaver 에서 쿼리 하나씩(커서를 쿼리 안에 두고 Ctrl+Enter). 조회만 수행
-- 근거(사내 ZIOUI1 원문 2026-11-25 13:36 조회, LAST_DDL_TIME 2026-11-25 10:33:42)
--   - 프로그램 로그 = SCM_SYS_LOG_BATCH(PROGRAM_NAME = 'PR_SSP_ANL_SHIP_PLAN_40'). PR_SCP_SYS_LOG_BATCH 가 자율 트랜잭션으로 바로 COMMIT
--   - 남기는 행 = START(시작) · TXN(정상 처리) · END(종료, DESCRIPTION = [PLAN_ID][분:초]) · ERROR(오류, DESCRIPTION = 오류 줄)
--   - 단계별 로그는 남기지 않음. 실행 중 어느 단계인지는 [L5] · [L6] 처럼 세션 · SQL 의 소스 줄 번호로 확인
--   - 법인 값(P_COMPANY_ID)은 로그에 남지 않음. 잡별 법인 : JOB_PR_SSP_PLN_SHIP_PLAN_40 = HQ00 · _AZ = AZ00 · _C = NJ00
--   - END 의 [분:초] 는 100분 이상이면 빈 값으로 남음(V_EXEC_TIME). 이때는 [L2] 의 ELAPSED_MIN 으로 봄
--   - [L5] ~ [L8] 은 V$ 뷰 조회 권한 필요. [L8] 은 Diagnostics Pack(ASH) 사용 조건. ORA-00942 가 나면 DBA 에 실행 요청
-- ==============================================================================================================

-- ==============================================================================================================
-- [L1] 최근 실행 로그(최근 3일) · 같은 잡에서 앞뒤로 도는 프로그램 포함
-- 확인 : 마지막 START 뒤에 END 나 ERROR 가 있는지. ERROR 면 LOG_MESSAGE · DESCRIPTION(오류 줄)
-- ==============================================================================================================
WITH PRM AS (SELECT 3 AS P_DAYS FROM DUAL)   /* 조회 일수. 이 줄의 값만 바꿔 실행 */
SELECT L.EVENT_DATE
     , L.PROGRAM_NAME
     , L.LOG_TYPE
     , L.LOG_COUNT
     , SUBSTR(L.LOG_MESSAGE, 1, 200) AS LOG_MESSAGE
     , SUBSTR(L.DESCRIPTION, 1, 300) AS DESCRIPTION
     , L.SQL_ERR_CODE
     , L.CREATED_BY
  FROM SCM_SYS_LOG_BATCH L
     , PRM
 WHERE L.PROGRAM_NAME IN ('PR_SSP_ANL_SHIP_PLAN_40', 'PR_SSP_ANL_SHIP_PLAN_40_BALANCE', 'PR_SSP_ANL_SHIP_CONFIRM_BATCH_40'
                        , 'PR_SSP_MAIL_SHIP_REQ_MINUS_BALANCE_40', 'PR_SSP_ANL_INVENTORY_RAW')
   AND L.EVENT_DATE >= TRUNC(SYSDATE) - PRM.P_DAYS
 ORDER BY L.EVENT_DATE DESC;

-- ==============================================================================================================
-- [L2] 실행 회차별 소요 시간(최근 14일)
-- 확인 : 회차마다 시작 · 종료 · 소요 분. END_TYPE 이 비어 있으면 아직 실행 중이거나 세션이 끊긴 회차
-- ==============================================================================================================
WITH PRM AS (SELECT 14 AS P_DAYS FROM DUAL)   /* 조회 일수. 이 줄의 값만 바꿔 실행 */
, LG AS (
SELECT L.EVENT_DATE
     , L.LOG_TYPE
     , L.LOG_MESSAGE
     , L.DESCRIPTION
     , LEAD(L.EVENT_DATE) OVER (ORDER BY L.EVENT_DATE, DECODE(L.LOG_TYPE, 'START', 1, 'TXN', 2, 'ERROR', 3, 'END', 4)) AS NEXT_DATE
     , LEAD(L.LOG_TYPE)   OVER (ORDER BY L.EVENT_DATE, DECODE(L.LOG_TYPE, 'START', 1, 'TXN', 2, 'ERROR', 3, 'END', 4)) AS NEXT_TYPE
  FROM SCM_SYS_LOG_BATCH L
     , PRM
 WHERE L.PROGRAM_NAME = 'PR_SSP_ANL_SHIP_PLAN_40'
   AND L.LOG_TYPE IN ('START', 'END', 'ERROR')
   AND L.EVENT_DATE >= TRUNC(SYSDATE) - PRM.P_DAYS
)
SELECT LG.EVENT_DATE AS START_DATE
     , CASE WHEN LG.NEXT_TYPE IN ('END', 'ERROR') THEN LG.NEXT_DATE END AS END_DATE
     , CASE WHEN LG.NEXT_TYPE IN ('END', 'ERROR') THEN LG.NEXT_TYPE END AS END_TYPE
     , ROUND((NVL(CASE WHEN LG.NEXT_TYPE IN ('END', 'ERROR') THEN LG.NEXT_DATE END, SYSDATE) - LG.EVENT_DATE) * 1440, 1) AS ELAPSED_MIN
     , TO_CHAR(LG.EVENT_DATE, 'HH24:MI') AS START_HHMI   /* 08:00 = HQ00 · 10:30 = AZ00 · 11:00 = NJ00 잡 시각(사내 ZIOUI1 잡 정의 기준) */
  FROM LG
 WHERE LG.LOG_TYPE = 'START'
 ORDER BY LG.EVENT_DATE DESC;

-- ==============================================================================================================
-- [L3] 계획 진행 상태(SCM_MST_PLAN_DETAIL, 최근 10회)
-- 확인 : PLAN_STATUS 0 = 진행 중 · 1 = 정상 종료 · -1 = 오류. 0 인데 [L5] 에 세션이 없으면 비정상 종료
-- ==============================================================================================================
SELECT D.PLAN_ID
     , D.PLAN_SEQ
     , D.PLAN_TYPE
     , D.PLAN_STATUS
     , D.PLAN_START_DATE
     , D.PLAN_END_DATE
     , ROUND((NVL(D.PLAN_END_DATE, SYSDATE) - D.PLAN_START_DATE) * 1440, 1) AS ELAPSED_MIN
     , D.CREATION_DATE
     , D.LAST_UPDATE_DATE
  FROM SCM_MST_PLAN_DETAIL D
 WHERE D.MODELING_ID = '101'
   AND D.DIVISION_ID = '40'
   AND D.PLAN_TYPE   = 'SP'
 ORDER BY D.CREATION_DATE DESC NULLS LAST
 FETCH FIRST 10 ROWS ONLY;

-- ==============================================================================================================
-- [L4] 스케줄러 잡 실행 이력 · 실행 중 잡
-- 확인 : 잡이 실행 중인지(RUNNING_SID 값 있음), 이전 회차 RUN_DURATION · STATUS
-- ==============================================================================================================
SELECT J.JOB_NAME
     , J.ENABLED
     , J.STATE
     , J.LAST_START_DATE
     , J.LAST_RUN_DURATION
     , J.NEXT_RUN_DATE
     , R.SESSION_ID AS RUNNING_SID
     , R.ELAPSED_TIME AS RUNNING_ELAPSED
  FROM ALL_SCHEDULER_JOBS J
  LEFT JOIN ALL_SCHEDULER_RUNNING_JOBS R
    ON R.OWNER    = J.OWNER
   AND R.JOB_NAME = J.JOB_NAME
 WHERE J.OWNER = 'SCM_MGR'
   AND J.JOB_NAME LIKE 'JOB_PR_SSP_PLN_SHIP_PLAN_40%'
 ORDER BY J.JOB_NAME;

SELECT D.JOB_NAME
     , D.ACTUAL_START_DATE
     , D.RUN_DURATION
     , D.STATUS
     , D.ERROR#
     , SUBSTR(D.ADDITIONAL_INFO, 1, 300) AS ADDITIONAL_INFO
  FROM ALL_SCHEDULER_JOB_RUN_DETAILS D
 WHERE D.OWNER = 'SCM_MGR'
   AND D.JOB_NAME LIKE 'JOB_PR_SSP_PLN_SHIP_PLAN_40%'
   AND D.ACTUAL_START_DATE >= SYSTIMESTAMP - INTERVAL '14' DAY
 ORDER BY D.ACTUAL_START_DATE DESC;

-- ==============================================================================================================
-- [L5] 지금 실행 중인 세션 · 현재 단계(V$ 권한 필요)
-- 확인 : STEP_NAME = 지금 실행 중인 단계(프로시저 안 1-1 ~ 4 주석), SRC_LINE = 소스 줄 번호
--        STEP_NAME 이 비어 있고 SRC_LINE 이 474 미만이면 1-1 전 준비 구간(계획 ID · LOOKUP 생성)
--        EVENT · BLOCKING_SESSION = 대기 원인. BLOCKING_SESSION 값이 있으면 [L7] 로 잠금 확인
--        잡이 아닌 DBeaver 직접 실행 세션도 PLSQL_ENTRY_OBJECT_ID 로 잡힘
-- ==============================================================================================================
WITH OBJ AS (
SELECT O.OBJECT_ID
  FROM ALL_OBJECTS O
 WHERE O.OWNER       = 'SCM_MGR'
   AND O.OBJECT_NAME = 'PR_SSP_ANL_SHIP_PLAN_40'
   AND O.OBJECT_TYPE = 'PROCEDURE'
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
     , Q.PROGRAM_LINE# AS SRC_LINE
     , (SELECT TRIM(MAX(C.TEXT) KEEP (DENSE_RANK LAST ORDER BY C.LINE))
          FROM ALL_SOURCE C
         WHERE C.OWNER = 'SCM_MGR'
           AND C.NAME  = 'PR_SSP_ANL_SHIP_PLAN_40'
           AND C.TYPE  = 'PROCEDURE'
           AND C.LINE <= Q.PROGRAM_LINE#
           AND REGEXP_LIKE(C.TEXT, '^\s*/\*\s*[0-9](-[0-9]+)*(\.|\s)')) AS STEP_NAME
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
     , OBJ
 WHERE S.PLSQL_ENTRY_OBJECT_ID = OBJ.OBJECT_ID
    OR S.PLSQL_OBJECT_ID       = OBJ.OBJECT_ID
    OR Q.PROGRAM_ID            = OBJ.OBJECT_ID
    OR S.ACTION LIKE 'JOB_PR_SSP_PLN_SHIP_PLAN_40%';

-- ==============================================================================================================
-- [L6] 이번 회차 SQL 별 소요 시간(V$ 권한 필요)
-- 확인 : 마지막 START 이후 실행된 프로시저 안 SQL 을 누적 소요 시간 큰 순서로. 위 몇 줄이 느린 단계
--        ELAPSED_SEC 는 공유 풀에 남은 누적값. 같은 SQL 이 앞 회차에도 실행됐으면 앞 회차 시간이 더해져 있음(EXECUTIONS 로 구분)
-- ==============================================================================================================
WITH OBJ AS (
SELECT O.OBJECT_ID
  FROM ALL_OBJECTS O
 WHERE O.OWNER       = 'SCM_MGR'
   AND O.OBJECT_NAME = 'PR_SSP_ANL_SHIP_PLAN_40'
   AND O.OBJECT_TYPE = 'PROCEDURE'
)
, LAST_RUN AS (
SELECT MAX(L.EVENT_DATE) AS START_DATE
  FROM SCM_SYS_LOG_BATCH L
 WHERE L.PROGRAM_NAME = 'PR_SSP_ANL_SHIP_PLAN_40'
   AND L.LOG_TYPE     = 'START'
   AND L.EVENT_DATE  >= TRUNC(SYSDATE) - 1
)
SELECT Q.PROGRAM_LINE# AS SRC_LINE
     , (SELECT TRIM(MAX(C.TEXT) KEEP (DENSE_RANK LAST ORDER BY C.LINE))
          FROM ALL_SOURCE C
         WHERE C.OWNER = 'SCM_MGR'
           AND C.NAME  = 'PR_SSP_ANL_SHIP_PLAN_40'
           AND C.TYPE  = 'PROCEDURE'
           AND C.LINE <= Q.PROGRAM_LINE#
           AND REGEXP_LIKE(C.TEXT, '^\s*/\*\s*[0-9](-[0-9]+)*(\.|\s)')) AS STEP_NAME
     , Q.SQL_ID
     , Q.EXECUTIONS
     , ROUND(Q.ELAPSED_TIME / 1000000, 1) AS ELAPSED_SEC
     , ROUND(Q.CPU_TIME / 1000000, 1) AS CPU_SEC
     , Q.BUFFER_GETS
     , Q.DISK_READS
     , Q.ROWS_PROCESSED
     , Q.PLAN_HASH_VALUE
     , Q.LAST_ACTIVE_TIME
     , SUBSTR(Q.SQL_TEXT, 1, 150) AS SQL_TEXT
  FROM GV$SQL Q
     , OBJ
     , LAST_RUN
 WHERE Q.PROGRAM_ID        = OBJ.OBJECT_ID
   AND Q.LAST_ACTIVE_TIME >= NVL(LAST_RUN.START_DATE, TRUNC(SYSDATE))
 ORDER BY Q.ELAPSED_TIME DESC;

-- ==============================================================================================================
-- [L7] 잠금 대기 확인(V$ 권한 필요)
-- 확인 : [L5] 의 BLOCKING_SESSION 이 가리키는 세션이 무엇을 하는지. 다른 화면 저장 · 다른 배치가 같은 테이블을 잡고 있는지
-- ==============================================================================================================
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
     , (SELECT O.OWNER || '.' || O.OBJECT_NAME
          FROM ALL_OBJECTS O
         WHERE O.OBJECT_ID = W.ROW_WAIT_OBJ#) AS LOCK_OBJECT
  FROM GV$SESSION W
  JOIN GV$SESSION B
    ON B.INST_ID = W.BLOCKING_INSTANCE
   AND B.SID     = W.BLOCKING_SESSION
 WHERE W.BLOCKING_SESSION IS NOT NULL
   AND (W.ACTION LIKE 'JOB_PR_SSP_PLN_SHIP_PLAN_40%'
        OR W.PLSQL_ENTRY_OBJECT_ID = (SELECT O.OBJECT_ID
                                        FROM ALL_OBJECTS O
                                       WHERE O.OWNER       = 'SCM_MGR'
                                         AND O.OBJECT_NAME = 'PR_SSP_ANL_SHIP_PLAN_40'
                                         AND O.OBJECT_TYPE = 'PROCEDURE'));

-- ==============================================================================================================
-- [L8-0] 인스턴스 수 확인
-- 확인 : 2 이상이면 GV$ 조회가 인스턴스마다 나뉘어 실행됨. [L8] 은 GV$ 를 각 1회만 조회하도록 작성함
-- ==============================================================================================================
SELECT INST_ID
     , INSTANCE_NAME
     , HOST_NAME
  FROM GV$INSTANCE
 ORDER BY INST_ID;

-- ==============================================================================================================
-- [L8] 이번 회차 단계별 소요 시간 · 대기(ASH, V$ 권한 + Diagnostics Pack)
-- 확인 : 단계(STEP_NAME)별 표본 수. 1표본 = 약 1초. EVENT 가 ON CPU 외 값이면 그 대기가 원인
--        조회 범위 = 마지막 START 부터. START 가 없으면 P_FROM_MIN 분 전부터
--        STEP_NAME 이 비어 있으면 프로시저가 직접 실행한 SQL 이 아님(SQL 안에서 부른 함수 · 로그 프로시저)
-- 2026-11-25 수정 : 표본 1건마다 GV$SQL, 결과 1행마다 ALL_SOURCE 를 다시 조회하던 구조를 각 1회 조회로 바꿈
-- ==============================================================================================================
WITH PRM AS (SELECT 180 AS P_FROM_MIN FROM DUAL)   /* START 로그가 없을 때 조회 시작(분 전). 이 줄의 값만 바꿔 실행 */
, OBJ AS (
SELECT /*+ MATERIALIZE */ O.OBJECT_ID
  FROM ALL_OBJECTS O
 WHERE O.OWNER       = 'SCM_MGR'
   AND O.OBJECT_NAME = 'PR_SSP_ANL_SHIP_PLAN_40'
   AND O.OBJECT_TYPE = 'PROCEDURE'
)
, LAST_RUN AS (
SELECT /*+ MATERIALIZE */ CAST(NVL(MAX(L.EVENT_DATE), MAX(SYSDATE - PRM.P_FROM_MIN / 1440)) AS TIMESTAMP) AS FROM_TS
  FROM PRM
  LEFT JOIN SCM_SYS_LOG_BATCH L
    ON L.PROGRAM_NAME = 'PR_SSP_ANL_SHIP_PLAN_40'
   AND L.LOG_TYPE     = 'START'
   AND L.EVENT_DATE  >= TRUNC(SYSDATE) - 1
)
, STEP AS (
SELECT /*+ MATERIALIZE */ C.LINE AS FROM_LINE
     , NVL(LEAD(C.LINE) OVER (ORDER BY C.LINE) - 1, 999999) AS TO_LINE
     , RTRIM(LTRIM(C.TEXT), ' ' || CHR(9) || CHR(10) || CHR(13)) AS STEP_NAME
  FROM ALL_SOURCE C
 WHERE C.OWNER = 'SCM_MGR'
   AND C.NAME  = 'PR_SSP_ANL_SHIP_PLAN_40'
   AND C.TYPE  = 'PROCEDURE'
   AND REGEXP_LIKE(C.TEXT, '^\s*/\*\s*[0-9](-[0-9]+)*(\.|\s)')
)
, ASH AS (
SELECT /*+ MATERIALIZE */ A.INST_ID
     , A.SQL_ID
     , NVL(A.EVENT, 'ON CPU') AS EVENT
     , COUNT(*) AS SAMPLE_CNT
     , MIN(A.SAMPLE_TIME) AS FIRST_SAMPLE
     , MAX(A.SAMPLE_TIME) AS LAST_SAMPLE
  FROM GV$ACTIVE_SESSION_HISTORY A
 WHERE A.PLSQL_ENTRY_OBJECT_ID = (SELECT OBJ.OBJECT_ID FROM OBJ)
   AND A.SAMPLE_TIME          >= (SELECT LAST_RUN.FROM_TS FROM LAST_RUN)
 GROUP BY A.INST_ID
        , A.SQL_ID
        , NVL(A.EVENT, 'ON CPU')
)
, SQL_LINE AS (
SELECT /*+ MATERIALIZE */ Q.INST_ID
     , Q.SQL_ID
     , MAX(Q.PROGRAM_LINE#) AS SRC_LINE
     , MAX(SUBSTR(Q.SQL_TEXT, 1, 150)) AS SQL_TEXT
  FROM GV$SQL Q
 WHERE Q.PROGRAM_ID = (SELECT OBJ.OBJECT_ID FROM OBJ)
 GROUP BY Q.INST_ID
        , Q.SQL_ID
)
SELECT ST.STEP_NAME
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
    ON SL.SRC_LINE BETWEEN ST.FROM_LINE AND ST.TO_LINE
 ORDER BY A.SAMPLE_CNT DESC;
