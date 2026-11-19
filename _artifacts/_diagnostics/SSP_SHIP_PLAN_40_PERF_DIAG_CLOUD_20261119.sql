-- =============================================================================
-- SSP_SHIP_PLAN_40_PERF_DIAG_CLOUD_20261119.sql
--   PR_SSP_ANL_SHIP_PLAN_40 병목 구간 확인 (클라우드, 어제 일자 실행분)
--   조회만 함. 변경 없음. 계정 SCM_MGR. 전체 F5 실행 가능(치환 변수 없음).
--
--   대상 잡 3종 (사내 ZIOUI1 ALL_SCHEDULER_JOBS 원문 2026-11-19 09:25 조회)
--     JOB_PR_SSP_PLN_SHIP_PLAN_40    : _40_BALANCE → CONFIRM_BATCH_40(HQ00) → SHIP_PLAN_40(HQ00) → MAIL_..._40
--     JOB_PR_SSP_PLN_SHIP_PLAN_40_AZ : CONFIRM_BATCH_40(AZ00) → SHIP_PLAN_40(AZ00) → MAIL_..._40
--     JOB_PR_SSP_PLN_SHIP_PLAN_40_C  : CONFIRM_BATCH_40(NJ00) → SHIP_PLAN_40(NJ00) → INVENTORY_RAW → MAIL_..._40
--
--   PR_SSP_ANL_SHIP_PLAN_40 로그는 START, TXN, END, ERROR 4종만 남김. 단계별 시간은 로그에 없음.
--   SQL별 시간은 [4]~[7] ASH, AWR, 커서 캐시로 봄.
--   로그에 COMPANY_ID 가 없어서 회사 구분은 [2] 잡 실행 시각과 맞춰 봄.
--
--   [4] [5] [7] [8] 은 Diagnostics Pack 뷰(DBA_HIST_*, V$ACTIVE_SESSION_HISTORY) 사용.
--   클라우드 라이선스 미확인. 권한 오류가 나면 [6] GV$SQL 결과로 판단함.
--
--   사내 대조값 (ZIOUI1, 2026-11-19 09:28~09:58, HQ00, 사본 프로시저 실행 후 ROLLBACK)
--     라인 1753 INSERT INTO GT_SSP_ANL_SHIP_PLAN_40_TEMP (sql_id 1kd6yst29qa7s) 한 문장에서 30분 초과, 감시 도구가 1,829초에 종료
--     ASH 1초 표본 1,726건 중 CPU 1,719건, User I/O 7건
--       계획 830 IX01_FP_DAILY_PRODUCTIOIN_PLAN_H 범위 검색 779초 (09:29:50~09:43:25)
--         = UNION ALL 4번째 분기 조립계획(원문 1946~2006)의 NOT EXISTS(SSP_DNM_PLAN_FROZEN_V) 가 바깥 행마다 반복
--       계획 989, 990 같은 인덱스 903초 (09:43:27~ 중단 시점)
--         = UNION ALL 5번째 분기 특성계획(원문 2010~)의 SSP_DNM_PLAN_FROZEN_V 읽기
--     인덱스 1회 범위 = DIVISION_ID 40, PLAN_DATE >= AUTO_PLAN_CALL_FLAG.ATTRIBUTE1(사내 20261009~20261022)
--       → HQ00 13,397행, NJ00 32,839행, AZ00 195행. 그중 F5400·F5500·F5600 행 0건(NOT EXISTS 가 끝까지 훑고 실패)
-- =============================================================================
SET LINESIZE 300
SET PAGESIZE 500
SET TRIMSPOOL ON
SET FEEDBACK ON
COLUMN PROGRAM_NAME FORMAT A40
COLUMN LOG_MESSAGE  FORMAT A50
COLUMN DESCRIPTION  FORMAT A60
COLUMN EVENT        FORMAT A40
COLUMN SQL_HEAD     FORMAT A90
COLUMN JOB_NAME     FORMAT A34
COLUMN PLAN_TABLE_OUTPUT FORMAT A200

SPOOL SSP_SHIP_PLAN_40_PERF_DIAG.txt

PROMPT ############################################################
PROMPT [0] 환경
PROMPT ############################################################
SELECT SYS_CONTEXT('USERENV','DB_NAME')        AS DB_NAME
     , SYS_CONTEXT('USERENV','SERVER_HOST')    AS HOST
     , SYS_CONTEXT('USERENV','CURRENT_SCHEMA') AS CUR_SCHEMA
     , TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') AS NOW
     , TO_CHAR(TRUNC(SYSDATE)-1,'YYYY-MM-DD')  AS TARGET_DAY
  FROM DUAL;

SELECT OBJECT_ID, OBJECT_NAME, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') AS LAST_DDL
  FROM ALL_OBJECTS
 WHERE OWNER = 'SCM_MGR'
   AND OBJECT_TYPE = 'PROCEDURE'
   AND OBJECT_NAME IN ( 'PR_SSP_ANL_SHIP_PLAN_40', 'PR_SSP_ANL_SHIP_PLAN_40_BALANCE'
                      , 'PR_SSP_ANL_SHIP_CONFIRM_BATCH_40', 'PR_SSP_MAIL_SHIP_REQ_MINUS_BALANCE_40'
                      , 'PR_SSP_ANL_INVENTORY_RAW' );

PROMPT ############################################################
PROMPT [1] 어제 배치 로그 전체 (잡 4단계 프로그램)
PROMPT     SEC_FROM_PREV = 같은 프로그램 직전 로그와의 간격(초)
PROMPT     END 의 DESCRIPTION = [PLAN_ID][mm:ss] 프로시저가 직접 잰 소요시간
PROMPT ############################################################
SELECT L.PROGRAM_NAME
     , L.LOG_TYPE
     , TO_CHAR(L.EVENT_DATE,'YYYY-MM-DD HH24:MI:SS') AS EVENT_DATE
     , ROUND((L.EVENT_DATE - LAG(L.EVENT_DATE) OVER (PARTITION BY L.PROGRAM_NAME ORDER BY L.EVENT_DATE, L.CREATION_DATE)) * 86400) AS SEC_FROM_PREV
     , L.LOG_COUNT
     , SUBSTR(L.LOG_MESSAGE,1,50)  AS LOG_MESSAGE
     , SUBSTR(L.DESCRIPTION,1,60)  AS DESCRIPTION
  FROM SCM_MGR.SCM_SYS_LOG_BATCH L
 WHERE L.EVENT_DATE >= TRUNC(SYSDATE) - 1
   AND L.EVENT_DATE <  TRUNC(SYSDATE)
   AND L.PROGRAM_NAME IN ( 'PR_SSP_ANL_SHIP_PLAN_40', 'PR_SSP_ANL_SHIP_PLAN_40_BALANCE'
                         , 'PR_SSP_ANL_SHIP_CONFIRM_BATCH_40', 'PR_SSP_MAIL_SHIP_REQ_MINUS_BALANCE_40'
                         , 'PR_SSP_ANL_INVENTORY_RAW' )
 ORDER BY L.EVENT_DATE, L.CREATION_DATE;
--
-- 판정
--   PR_SSP_ANL_SHIP_PLAN_40 의 START → TXN 간격 = 본체 DML 시간, TXN → END = 로그 처리 시간
--   START 가 없으면 조기 종료(당일 SHIP_CONFIRM 이미 있음 또는 IF_STOCK_CHECK 미통과). [9] 로 확인

PROMPT ############################################################
PROMPT [2] 어제 스케줄러 잡 실행 이력 (DBMS_SCHEDULER 로 돌린 경우만 행이 나옴)
PROMPT ############################################################
SELECT D.JOB_NAME
     , TO_CHAR(D.ACTUAL_START_DATE,'YYYY-MM-DD HH24:MI:SS') AS START_TS
     , D.RUN_DURATION
     , D.STATUS
     , D.ERROR#
     , D.SESSION_ID
     , D.CPU_USED
  FROM DBA_SCHEDULER_JOB_RUN_DETAILS D
 WHERE D.OWNER = 'SCM_MGR'
   AND D.JOB_NAME LIKE 'JOB_PR_SSP_PLN_SHIP_PLAN_40%'
   AND D.ACTUAL_START_DATE >= TRUNC(SYSTIMESTAMP) - 1
   AND D.ACTUAL_START_DATE <  TRUNC(SYSTIMESTAMP)
 ORDER BY D.ACTUAL_START_DATE;

PROMPT ############################################################
PROMPT [3] PR_SSP_ANL_SHIP_PLAN_40 실행 회차별 소요 (START 기준으로 다음 TXN/ERROR/END 짝)
PROMPT ############################################################
WITH L AS (
    SELECT LOG_TYPE, EVENT_DATE
         , SUM(CASE WHEN LOG_TYPE = 'START' THEN 1 ELSE 0 END) OVER (ORDER BY EVENT_DATE, CREATION_DATE) AS RUN_NO
         , SUBSTR(DESCRIPTION,1,60) AS DESCRIPTION
      FROM SCM_MGR.SCM_SYS_LOG_BATCH
     WHERE PROGRAM_NAME = 'PR_SSP_ANL_SHIP_PLAN_40'
       AND EVENT_DATE >= TRUNC(SYSDATE) - 1
       AND EVENT_DATE <  TRUNC(SYSDATE)
)
SELECT RUN_NO
     , TO_CHAR(MIN(CASE WHEN LOG_TYPE = 'START' THEN EVENT_DATE END),'HH24:MI:SS') AS START_TS
     , TO_CHAR(MIN(CASE WHEN LOG_TYPE IN ('TXN','ERROR') THEN EVENT_DATE END),'HH24:MI:SS') AS BODY_END_TS
     , TO_CHAR(MIN(CASE WHEN LOG_TYPE = 'END' THEN EVENT_DATE END),'HH24:MI:SS') AS END_TS
     , ROUND((MIN(CASE WHEN LOG_TYPE IN ('TXN','ERROR') THEN EVENT_DATE END)
            - MIN(CASE WHEN LOG_TYPE = 'START' THEN EVENT_DATE END)) * 86400) AS BODY_SEC
     , MAX(CASE WHEN LOG_TYPE = 'ERROR' THEN 'ERROR' END) AS ERR
     , MAX(CASE WHEN LOG_TYPE = 'END' THEN DESCRIPTION END) AS END_DESC
  FROM L
 GROUP BY RUN_NO
 ORDER BY RUN_NO;

PROMPT ############################################################
PROMPT [4] AWR ASH: 어제 PR_SSP_ANL_SHIP_PLAN_40 안에서 돈 SQL별 표본 (표본 1건 = 약 10초)
PROMPT     APPROX_SEC = 해당 SQL, 대기 이벤트 누적 초(근사)
PROMPT ############################################################
SELECT H.SQL_ID
     , H.SQL_PLAN_HASH_VALUE                         AS PHV
     , NVL(H.EVENT,'ON CPU')                         AS EVENT
     , COUNT(*)                                      AS SAMPLES
     , COUNT(*) * 10                                 AS APPROX_SEC
     , TO_CHAR(MIN(H.SAMPLE_TIME),'HH24:MI:SS')      AS FIRST_TS
     , TO_CHAR(MAX(H.SAMPLE_TIME),'HH24:MI:SS')      AS LAST_TS
     , H.SQL_OPNAME
  FROM DBA_HIST_ACTIVE_SESS_HISTORY H
 WHERE H.SAMPLE_TIME >= TRUNC(SYSTIMESTAMP) - 1
   AND H.SAMPLE_TIME <  TRUNC(SYSTIMESTAMP)
   AND H.PLSQL_ENTRY_OBJECT_ID = ( SELECT OBJECT_ID FROM ALL_OBJECTS
                                    WHERE OWNER = 'SCM_MGR' AND OBJECT_TYPE = 'PROCEDURE'
                                      AND OBJECT_NAME = 'PR_SSP_ANL_SHIP_PLAN_40' )
 GROUP BY H.SQL_ID, H.SQL_PLAN_HASH_VALUE, NVL(H.EVENT,'ON CPU'), H.SQL_OPNAME
 ORDER BY SAMPLES DESC
 FETCH FIRST 40 ROWS ONLY;
--
-- [4] 가 0행이면 [4-B] 결과를 봄 (잡 세션 ACTION 기준)

PROMPT ############################################################
PROMPT [4-B] AWR ASH: 잡 세션(ACTION = 잡 이름) 기준 SQL별 표본
PROMPT ############################################################
SELECT H.ACTION                                      AS JOB_NAME
     , H.SQL_ID
     , NVL(H.EVENT,'ON CPU')                         AS EVENT
     , COUNT(*)                                      AS SAMPLES
     , COUNT(*) * 10                                 AS APPROX_SEC
     , TO_CHAR(MIN(H.SAMPLE_TIME),'HH24:MI:SS')      AS FIRST_TS
     , TO_CHAR(MAX(H.SAMPLE_TIME),'HH24:MI:SS')      AS LAST_TS
     , ( SELECT O.OBJECT_NAME FROM DBA_OBJECTS O WHERE O.OBJECT_ID = H.PLSQL_ENTRY_OBJECT_ID ) AS ENTRY_PROC
  FROM DBA_HIST_ACTIVE_SESS_HISTORY H
 WHERE H.SAMPLE_TIME >= TRUNC(SYSTIMESTAMP) - 1
   AND H.SAMPLE_TIME <  TRUNC(SYSTIMESTAMP)
   AND H.ACTION LIKE 'JOB_PR_SSP_PLN_SHIP_PLAN_40%'
 GROUP BY H.ACTION, H.SQL_ID, NVL(H.EVENT,'ON CPU'), H.PLSQL_ENTRY_OBJECT_ID
 ORDER BY SAMPLES DESC
 FETCH FIRST 40 ROWS ONLY;

PROMPT ############################################################
PROMPT [5] 메모리 ASH (1초 표본, 보존 기간 안에 있을 때만 행이 나옴)
PROMPT ############################################################
SELECT H.SQL_ID
     , NVL(H.EVENT,'ON CPU')                    AS EVENT
     , COUNT(*)                                 AS SAMPLES_SEC
     , TO_CHAR(MIN(H.SAMPLE_TIME),'HH24:MI:SS') AS FIRST_TS
     , TO_CHAR(MAX(H.SAMPLE_TIME),'HH24:MI:SS') AS LAST_TS
  FROM GV$ACTIVE_SESSION_HISTORY H
 WHERE H.SAMPLE_TIME >= TRUNC(SYSTIMESTAMP) - 1
   AND H.SAMPLE_TIME <  TRUNC(SYSTIMESTAMP)
   AND H.PLSQL_ENTRY_OBJECT_ID = ( SELECT OBJECT_ID FROM ALL_OBJECTS
                                    WHERE OWNER = 'SCM_MGR' AND OBJECT_TYPE = 'PROCEDURE'
                                      AND OBJECT_NAME = 'PR_SSP_ANL_SHIP_PLAN_40' )
 GROUP BY H.SQL_ID, NVL(H.EVENT,'ON CPU')
 ORDER BY SAMPLES_SEC DESC
 FETCH FIRST 40 ROWS ONLY;

PROMPT ############################################################
PROMPT [6] 커서 캐시: 프로시저 라인별 SQL 누적 시간 (라이선스 불필요)
PROMPT     PROGRAM_LINE# = 프로시저 원문 라인. 잡 3개(HQ00, AZ00, NJ00) 실행분이 합산됨
PROMPT     LAST_ACTIVE 가 어제가 아니면 오늘 실행분이 섞임
PROMPT ############################################################
SELECT S.PROGRAM_LINE#
     , S.SQL_ID
     , S.PLAN_HASH_VALUE                         AS PHV
     , S.EXECUTIONS
     , ROUND(S.ELAPSED_TIME/1e6,1)               AS ELA_SEC
     , ROUND(S.CPU_TIME/1e6,1)                   AS CPU_SEC
     , ROUND(S.USER_IO_WAIT_TIME/1e6,1)          AS IO_SEC
     , ROUND(S.CONCURRENCY_WAIT_TIME/1e6,1)      AS CONC_SEC
     , S.BUFFER_GETS
     , S.DISK_READS
     , S.ROWS_PROCESSED
     , TO_CHAR(S.LAST_ACTIVE_TIME,'YYYY-MM-DD HH24:MI:SS') AS LAST_ACTIVE
     , SUBSTR(REGEXP_REPLACE(S.SQL_TEXT,'\s+',' '),1,90) AS SQL_HEAD
  FROM GV$SQL S
 WHERE S.PROGRAM_ID = ( SELECT OBJECT_ID FROM ALL_OBJECTS
                         WHERE OWNER = 'SCM_MGR' AND OBJECT_TYPE = 'PROCEDURE'
                           AND OBJECT_NAME = 'PR_SSP_ANL_SHIP_PLAN_40' )
 ORDER BY S.ELAPSED_TIME DESC
 FETCH FIRST 40 ROWS ONLY;

PROMPT ############################################################
PROMPT [7] AWR SQLSTAT: 어제 스냅샷 구간의 SQL별 증분 (커서가 밀려났을 때 대체)
PROMPT ############################################################
SELECT Q.SQL_ID
     , Q.PLAN_HASH_VALUE                              AS PHV
     , SUM(Q.EXECUTIONS_DELTA)                        AS EXECS
     , ROUND(SUM(Q.ELAPSED_TIME_DELTA)/1e6,1)         AS ELA_SEC
     , ROUND(SUM(Q.CPU_TIME_DELTA)/1e6,1)             AS CPU_SEC
     , ROUND(SUM(Q.IOWAIT_DELTA)/1e6,1)               AS IO_SEC
     , SUM(Q.BUFFER_GETS_DELTA)                       AS BUFFER_GETS
     , SUM(Q.DISK_READS_DELTA)                        AS DISK_READS
     , SUM(Q.ROWS_PROCESSED_DELTA)                    AS ROWS_PROC
     , ( SELECT SUBSTR(REGEXP_REPLACE(DBMS_LOB.SUBSTR(T.SQL_TEXT,400,1),'\s+',' '),1,90)
           FROM DBA_HIST_SQLTEXT T
          WHERE T.SQL_ID = Q.SQL_ID AND T.DBID = Q.DBID AND ROWNUM = 1 ) AS SQL_HEAD
  FROM DBA_HIST_SQLSTAT Q
  JOIN DBA_HIST_SNAPSHOT N
    ON N.SNAP_ID = Q.SNAP_ID AND N.DBID = Q.DBID AND N.INSTANCE_NUMBER = Q.INSTANCE_NUMBER
 WHERE N.END_INTERVAL_TIME   > TRUNC(SYSTIMESTAMP) - 1
   AND N.BEGIN_INTERVAL_TIME < TRUNC(SYSTIMESTAMP)
   AND Q.SQL_ID IN ( SELECT H.SQL_ID
                       FROM DBA_HIST_ACTIVE_SESS_HISTORY H
                      WHERE H.SAMPLE_TIME >= TRUNC(SYSTIMESTAMP) - 1
                        AND H.SAMPLE_TIME <  TRUNC(SYSTIMESTAMP)
                        AND H.PLSQL_ENTRY_OBJECT_ID = ( SELECT OBJECT_ID FROM ALL_OBJECTS
                                                         WHERE OWNER = 'SCM_MGR' AND OBJECT_TYPE = 'PROCEDURE'
                                                           AND OBJECT_NAME = 'PR_SSP_ANL_SHIP_PLAN_40' ) )
 GROUP BY Q.SQL_ID, Q.PLAN_HASH_VALUE, Q.DBID
 ORDER BY ELA_SEC DESC
 FETCH FIRST 30 ROWS ONLY;

PROMPT ############################################################
PROMPT [8] 상위 3개 SQL 실행계획 (AWR 보관분)
PROMPT ############################################################
SELECT P.PLAN_TABLE_OUTPUT
  FROM ( SELECT SQL_ID, PHV
           FROM ( SELECT H.SQL_ID, H.SQL_PLAN_HASH_VALUE AS PHV, COUNT(*) AS CNT
                    FROM DBA_HIST_ACTIVE_SESS_HISTORY H
                   WHERE H.SAMPLE_TIME >= TRUNC(SYSTIMESTAMP) - 1
                     AND H.SAMPLE_TIME <  TRUNC(SYSTIMESTAMP)
                     AND H.SQL_ID IS NOT NULL
                     AND H.SQL_PLAN_HASH_VALUE <> 0
                     AND H.PLSQL_ENTRY_OBJECT_ID = ( SELECT OBJECT_ID FROM ALL_OBJECTS
                                                      WHERE OWNER = 'SCM_MGR' AND OBJECT_TYPE = 'PROCEDURE'
                                                        AND OBJECT_NAME = 'PR_SSP_ANL_SHIP_PLAN_40' )
                   GROUP BY H.SQL_ID, H.SQL_PLAN_HASH_VALUE
                   ORDER BY CNT DESC )
          WHERE ROWNUM <= 3 ) T
     , TABLE(DBMS_XPLAN.DISPLAY_AWR(T.SQL_ID, T.PHV, NULL, 'TYPICAL')) P;

PROMPT ############################################################
PROMPT [9] 조기 종료 조건 (어제 기준, START 로그가 없을 때 원인 확인)
PROMPT     SHIP_CONFIRM_CNT > 0 또는 STOCK_CHECK_TOT <> STOCK_CHECK_PASS 이면 START 로그 없이 RETURN 함
PROMPT ############################################################
SELECT C.COMPANY_ID
     , ( SELECT COUNT(*) FROM SCM_MGR.SSP_ANL_SHIP_PLAN_40 P
          WHERE P.DIVISION_ID = '40'
            AND P.PLAN_START_YYYYMMDD = TO_CHAR(SYSDATE-1,'YYYYMMDD')
            AND P.MEASURE = 'SHIP_CONFIRM'
            AND P.ATTRIBUTE10 = C.COMPANY_ID ) AS SHIP_CONFIRM_CNT
     , ( SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL D
          WHERE D.LOOKUP_TYPE = 'IF_STOCK_CHECK' AND D.VALID_YN = 'Y'
            AND D.SEGMENT1 = 'PLAN_40' AND D.SEGMENT3 = '40' AND D.SEGMENT4 = C.COMPANY_ID ) AS STOCK_CHECK_TOT
     , ( SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL D
          WHERE D.LOOKUP_TYPE = 'IF_STOCK_CHECK' AND D.VALID_YN = 'Y'
            AND D.SEGMENT1 = 'PLAN_40' AND D.SEGMENT3 = '40' AND D.SEGMENT4 = C.COMPANY_ID
            AND D.SEGMENT5 = TO_CHAR(SYSDATE-1,'YYYYMMDD') AND D.ATTRIBUTE1 = 'Y' ) AS STOCK_CHECK_PASS
  FROM ( SELECT 'HQ00' AS COMPANY_ID FROM DUAL
         UNION ALL SELECT 'AZ00' FROM DUAL
         UNION ALL SELECT 'NJ00' FROM DUAL ) C;
--
-- [9] SHIP_CONFIRM_CNT 는 오늘 실행분이 이미 있으면 어제 기준 값과 다름. 어제 로그와 같이 봄

PROMPT ############################################################
PROMPT [10] 사내 측정 병목 문장 확인 (원문 라인 1753 INSERT INTO GT_SSP_ANL_SHIP_PLAN_40_TEMP)
PROMPT      사내 sql_id = 1kd6yst29qa7s. 원문이 같으면 클라우드 sql_id 도 같음
PROMPT      0행이면 [6] 에서 PROGRAM_LINE# = 1753 행의 SQL_ID 로 바꿔 봄
PROMPT ############################################################
SELECT 'AWR' AS SRC, H.SQL_PLAN_LINE_ID, H.SQL_PLAN_OPERATION || ' ' || H.SQL_PLAN_OPTIONS AS OP
     , NVL(H.EVENT,'ON CPU') AS EVENT, COUNT(*) * 10 AS APPROX_SEC
  FROM DBA_HIST_ACTIVE_SESS_HISTORY H
 WHERE H.SAMPLE_TIME >= TRUNC(SYSTIMESTAMP) - 1
   AND H.SAMPLE_TIME <  TRUNC(SYSTIMESTAMP)
   AND H.SQL_ID = '1kd6yst29qa7s'
 GROUP BY H.SQL_PLAN_LINE_ID, H.SQL_PLAN_OPERATION || ' ' || H.SQL_PLAN_OPTIONS, NVL(H.EVENT,'ON CPU')
 ORDER BY APPROX_SEC DESC
 FETCH FIRST 15 ROWS ONLY;

SELECT P.ID, P.PARENT_ID, LPAD(' ', P.DEPTH) || P.OPERATION || ' ' || P.OPTIONS AS OP
     , P.OBJECT_NAME, P.CARDINALITY
  FROM GV$SQL_PLAN P
 WHERE P.SQL_ID = '1kd6yst29qa7s'
   AND P.CHILD_NUMBER = ( SELECT MIN(S.CHILD_NUMBER) FROM GV$SQL S WHERE S.SQL_ID = '1kd6yst29qa7s' AND S.INST_ID = P.INST_ID )
   AND P.ID IN ( SELECT A.SQL_PLAN_LINE_ID
                   FROM GV$ACTIVE_SESSION_HISTORY A
                  WHERE A.SQL_ID = '1kd6yst29qa7s'
                  GROUP BY A.SQL_PLAN_LINE_ID
                 HAVING COUNT(*) >= 5 )
 ORDER BY P.ID;
--
-- 사내 판정 기준(2026-11-19 측정): 계획 라인 = FP_MGR.IF_SSP_FP_RELEASE_PLAN_V 안의
--   IX01_FP_DAILY_PRODUCTIOIN_PLAN_H INDEX RANGE SCAN. 원문 1995 NOT EXISTS(SSP_DNM_PLAN_FROZEN_V) 가 FILTER 로 행마다 반복됨
--   클라우드도 같은 계획 라인에 표본이 몰리면 같은 원인임

SPOOL OFF
