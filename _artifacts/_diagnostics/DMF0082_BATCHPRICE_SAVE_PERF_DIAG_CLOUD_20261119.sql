-- =============================================================================
-- DMF0082_BATCHPRICE_SAVE_PERF_DIAG_CLOUD_20261119.sql
--   DMF0082 Batch Price Input 대량 저장 5분 초과(TIMEOUT) 병목 점검 (클라우드, 운영)
--   조회만 함. 변경 없음. 계정 SCM_MGR. 전체 F5 실행 가능(치환 변수 없음).
--
--   저장 경로: Batch Price Input(SavePricePeriodModal), LOC 저장 모두 PKG_DMF0082.P_DMF0082_SAVE_MAIN_DATA
--   로그: SCM_SYS_LOG_BATCH PROGRAM_NAME = 'PKG_DMF0082'
--         START(IN_PARA_DATA 에 "rows":N, p_active_flag) → ING '■ : A001'~'A028', '■ 1.'~'■ 10.' → END
--   조회 기간: 최근 7일 (아래 SYSDATE - 7 을 바꾸면 기간 변경)
--
--   [5]~[8] 은 Diagnostics Pack 뷰(DBA_HIST_*, GV$ACTIVE_SESSION_HISTORY) 사용. 클라우드 권한 미확인.
--   권한 오류가 나면 [9] GV$SQL 결과로 판단함.
--
--   사내 기준(ZIOUI1, 2026-11-19 17:25 원문 조회)
--     PKG_DMF0082 BODY LAST_DDL 2026-11-17 19:51:52, 저장 프로시저 BODY 라인 24017~27273(3,257줄)
--     2026-09-29 SAVE_PERF 측정: 32,240행 863초 = 파싱 148 / 판가 MERGE 163 / 수요 MERGE 35
--       / SCM_MST_FUTURE_PRICE DELETE 323 / 매출계획 전파 PR 160 (초)
--       개선 후 파싱 148 → 6초, 재저장 32,206건 1분 52초
-- =============================================================================
SET LINESIZE 300
SET PAGESIZE 500
SET TRIMSPOOL ON
SET FEEDBACK ON
SET LONG 100000
COLUMN LOG_MESSAGE  FORMAT A60
COLUMN DESCRIPTION  FORMAT A50
COLUMN EVENT        FORMAT A40
COLUMN SQL_HEAD     FORMAT A90
COLUMN OBJ_NAME     FORMAT A45
COLUMN TABLE_NAME   FORMAT A34
COLUMN PLAN_TABLE_OUTPUT FORMAT A200

SPOOL DMF0082_BATCHPRICE_SAVE_PERF_DIAG.txt

PROMPT ############################################################
PROMPT [0] 환경, 객체, 저장 프로시저 위치
PROMPT ############################################################
SELECT SYS_CONTEXT('USERENV','DB_NAME')        AS DB_NAME
     , SYS_CONTEXT('USERENV','SERVER_HOST')    AS HOST
     , SYS_CONTEXT('USERENV','CURRENT_SCHEMA') AS CUR_SCHEMA
     , TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') AS NOW
     , (SELECT COUNT(*) FROM GV$INSTANCE)      AS RAC_NODES
  FROM DUAL;

SELECT OBJECT_ID, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') AS LAST_DDL
  FROM ALL_OBJECTS
 WHERE OWNER = 'SCM_MGR'
   AND OBJECT_NAME = 'PKG_DMF0082';

SELECT MIN(CASE WHEN REGEXP_LIKE(TEXT,'^PROCEDURE\s+P_DMF0082_SAVE_MAIN_DATA','i') THEN LINE END) AS SAVE_START_LINE
     , MAX(LINE)                                                                                   AS BODY_LAST_LINE
  FROM ALL_SOURCE
 WHERE OWNER = 'SCM_MGR' AND NAME = 'PKG_DMF0082' AND TYPE = 'PACKAGE BODY';

PROMPT [0-B] 속도 관련 보완 반영 여부 (사내 BODY 기준 건수와 비교)
SELECT M.MARKER
     , M.CORP_CNT
     , ( SELECT COUNT(*) FROM ALL_SOURCE S
          WHERE S.OWNER = 'SCM_MGR' AND S.NAME = 'PKG_DMF0082' AND S.TYPE = 'PACKAGE BODY'
            AND INSTR(S.TEXT, M.MARKER) > 0 ) AS THIS_DB_CNT
  FROM ( SELECT '[E20260929-DMF0082SAVEPERF]' AS MARKER, 6 AS CORP_CNT FROM DUAL
         UNION ALL SELECT '[E20260929-DMF0082SAVETXN]', 7  FROM DUAL
         UNION ALL SELECT '[E20260901-SAVECLOB]',       17 FROM DUAL
         UNION ALL SELECT '[E20260820-XLSSAVEPERF]',    2  FROM DUAL
         UNION ALL SELECT '[E20260930-DMF0082FXZERO]',  6  FROM DUAL
         UNION ALL SELECT '[E20260930-DMF0082-81SP]',   2  FROM DUAL ) M;
--
-- THIS_DB_CNT = 0 인 마커가 있으면 그 보완이 이 DB 에 없음. SAVEPERF 가 0 이면 파싱 루프가 구 방식(사내 148초)임

PROMPT ############################################################
PROMPT [1] 최근 7일 저장 실행 목록 (행 수, 소요 초, 종료 메시지)
PROMPT     DUR_SEC 는 START ~ 같은 사용자 다음 END. END 가 없으면 진행 중이었거나 세션이 끊긴 것임
PROMPT     BE 5분 TIMEOUT 뒤에도 DB 는 계속 돌 수 있음. DUR_SEC > 300 이면 DB 가 5분을 넘긴 것임
PROMPT ############################################################
WITH S AS (
    SELECT L.CREATED_BY
         , L.EVENT_DATE                                                     AS START_TS
         , TO_NUMBER(REGEXP_SUBSTR(L.IN_PARA_DATA,'"rows":([0-9]+)',1,1,NULL,1)) AS ROWS_IN
         , REGEXP_SUBSTR(L.IN_PARA_DATA,'"p_division_id":"([0-9]+)',1,1,NULL,1) AS DIV
         , LEAD(L.EVENT_DATE) OVER (PARTITION BY L.CREATED_BY ORDER BY L.EVENT_DATE) AS NEXT_START_TS
      FROM SCM_MGR.SCM_SYS_LOG_BATCH L
     WHERE L.PROGRAM_NAME = 'PKG_DMF0082'
       AND L.LOG_TYPE     = 'START'
       AND L.EVENT_DATE  >= SYSDATE - 7
       AND L.IN_PARA_DATA LIKE '%p_active_flag%'
), E AS (
    SELECT L.CREATED_BY, L.EVENT_DATE, L.LOG_MESSAGE
      FROM SCM_MGR.SCM_SYS_LOG_BATCH L
     WHERE L.PROGRAM_NAME = 'PKG_DMF0082'
       AND L.LOG_TYPE     = 'END'
       AND L.EVENT_DATE  >= SYSDATE - 7
)
SELECT TO_CHAR(S.START_TS,'YYYY-MM-DD HH24:MI:SS') AS START_TS
     , S.CREATED_BY
     , S.DIV
     , S.ROWS_IN
     , TO_CHAR(X.END_TS,'HH24:MI:SS')                AS END_TS
     , ROUND((X.END_TS - S.START_TS) * 86400)        AS DUR_SEC
     , SUBSTR(X.END_MSG,1,60)                        AS LOG_MESSAGE
  FROM S
  OUTER APPLY ( SELECT MIN(E.EVENT_DATE) AS END_TS
                     , MIN(E.LOG_MESSAGE) KEEP (DENSE_RANK FIRST ORDER BY E.EVENT_DATE) AS END_MSG
                  FROM E
                 WHERE E.CREATED_BY  = S.CREATED_BY
                   AND E.EVENT_DATE >= S.START_TS
                   AND E.EVENT_DATE <  NVL(S.NEXT_START_TS, S.START_TS + 1) ) X
 ORDER BY NVL(ROUND((X.END_TS - S.START_TS) * 86400), 999999) DESC, S.START_TS DESC
 FETCH FIRST 30 ROWS ONLY;

PROMPT ############################################################
PROMPT [2] 오래 걸린 저장 3건의 단계별 소요 (STEP_SEC = 이 로그 ~ 다음 로그 간격)
PROMPT     STEP_SEC 가 큰 행의 다음 로그 직전 구간이 병목임
PROMPT ############################################################
WITH S AS (
    SELECT L.CREATED_BY, L.EVENT_DATE AS START_TS
         , TO_NUMBER(REGEXP_SUBSTR(L.IN_PARA_DATA,'"rows":([0-9]+)',1,1,NULL,1)) AS ROWS_IN
         , LEAD(L.EVENT_DATE) OVER (PARTITION BY L.CREATED_BY ORDER BY L.EVENT_DATE) AS NEXT_START_TS
      FROM SCM_MGR.SCM_SYS_LOG_BATCH L
     WHERE L.PROGRAM_NAME = 'PKG_DMF0082'
       AND L.LOG_TYPE     = 'START'
       AND L.EVENT_DATE  >= SYSDATE - 7
       AND L.IN_PARA_DATA LIKE '%p_active_flag%'
), D AS (
    SELECT S.*
         , ( SELECT MAX(L.EVENT_DATE) FROM SCM_MGR.SCM_SYS_LOG_BATCH L
              WHERE L.PROGRAM_NAME = 'PKG_DMF0082'
                AND L.CREATED_BY   = S.CREATED_BY
                AND L.EVENT_DATE  >= S.START_TS
                AND L.EVENT_DATE  <  NVL(S.NEXT_START_TS, S.START_TS + 1) ) AS LAST_TS
      FROM S
), T AS (
    SELECT D.*, ROW_NUMBER() OVER (ORDER BY (D.LAST_TS - D.START_TS) DESC) AS RNK
      FROM D
)
SELECT T.RNK
     , TO_CHAR(T.START_TS,'MM-DD HH24:MI:SS')     AS RUN_START
     , T.ROWS_IN
     , L.LOG_TYPE
     , TO_CHAR(L.EVENT_DATE,'HH24:MI:SS')          AS TS
     , ROUND((LEAD(L.EVENT_DATE) OVER (PARTITION BY T.RNK ORDER BY L.EVENT_DATE, L.ROWID) - L.EVENT_DATE) * 86400) AS STEP_SEC
     , SUBSTR(L.LOG_MESSAGE,1,60)                  AS LOG_MESSAGE
  FROM T
  JOIN SCM_MGR.SCM_SYS_LOG_BATCH L
    ON L.PROGRAM_NAME IN ('PKG_DMF0082', 'PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE')
   AND L.EVENT_DATE  >= T.START_TS
   AND L.EVENT_DATE  <= T.LAST_TS
   AND (L.PROGRAM_NAME <> 'PKG_DMF0082' OR L.CREATED_BY = T.CREATED_BY)
 WHERE T.RNK <= 3
 ORDER BY T.RNK, L.EVENT_DATE, L.ROWID;
--
-- 로그 시각은 초 단위이고 순번 컬럼이 없어서 같은 초 안의 순서는 ROWID(입력 순서)로 맞춤
--
-- 사내 단계 이름: A00C~A00E 파싱, ■1 MAIN 적재, A003~A021 검증, ■4 금액 계산,
--   A023~■5 판가(DM_PLN_CFM_SELLING_PRICE / 81 SCM_MST_FUTURE_PRICE), A024~■6 수요,
--   A025_EE 전극 RTF, ■7 ■8 이력(_H), ■9~■10 매출계획 전파 PR(BALANCE_CREATE 포함), A028 종료

PROMPT ############################################################
PROMPT [3] 저장 시점 동시 실행 확인 (같은 시각 다른 PKG_DMF0082 저장, 배치 BALANCE)
PROMPT ############################################################
SELECT L.PROGRAM_NAME, L.CREATED_BY, L.LOG_TYPE
     , TO_CHAR(L.EVENT_DATE,'YYYY-MM-DD HH24:MI:SS') AS TS
     , SUBSTR(L.LOG_MESSAGE,1,60) AS LOG_MESSAGE
  FROM SCM_MGR.SCM_SYS_LOG_BATCH L
 WHERE L.EVENT_DATE >= SYSDATE - 7
   AND L.LOG_TYPE IN ('START','END')
   AND L.PROGRAM_NAME IN ('PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE','PR_DM_PLN_CFM_TO_MKT_FCST')
 ORDER BY L.EVENT_DATE DESC
 FETCH FIRST 40 ROWS ONLY;

PROMPT ############################################################
PROMPT [4] 저장 프로시저 식별값 (ASH 필터용)
PROMPT ############################################################
SELECT O.OBJECT_ID, O.OBJECT_TYPE, P.SUBPROGRAM_ID, P.PROCEDURE_NAME
  FROM ALL_OBJECTS O
  JOIN ALL_PROCEDURES P
    ON P.OWNER = O.OWNER AND P.OBJECT_NAME = O.OBJECT_NAME
 WHERE O.OWNER = 'SCM_MGR'
   AND O.OBJECT_NAME = 'PKG_DMF0082'
   AND O.OBJECT_TYPE = 'PACKAGE'
   AND P.PROCEDURE_NAME IN ('P_DMF0082_SAVE_MAIN_DATA','P_PR_DM_PLN_CFM_TO_MKT_FCST');

PROMPT ############################################################
PROMPT [5] AWR ASH: 최근 7일 저장 프로시저 안에서 시간 쓴 곳 (표본 1건 = 약 10초)
PROMPT     CUR_OBJ = 그 순간 실행 중이던 PL/SQL 객체(중첩 호출 PR 구분)
PROMPT ############################################################
SELECT ( SELECT O.OBJECT_NAME FROM DBA_OBJECTS O WHERE O.OBJECT_ID = H.PLSQL_OBJECT_ID ) AS OBJ_NAME
     , H.SQL_ID
     , H.SQL_OPNAME
     , NVL(H.EVENT,'ON CPU')                    AS EVENT
     , COUNT(*)                                 AS SAMPLES
     , COUNT(*) * 10                            AS APPROX_SEC
     , COUNT(DISTINCT H.SESSION_ID || ',' || H.SESSION_SERIAL# || ',' || TO_CHAR(H.SQL_EXEC_ID)) AS EXEC_CNT
  FROM DBA_HIST_ACTIVE_SESS_HISTORY H
 WHERE H.SAMPLE_TIME >= SYSTIMESTAMP - INTERVAL '7' DAY
   AND H.PLSQL_ENTRY_OBJECT_ID IN ( SELECT OBJECT_ID FROM ALL_OBJECTS WHERE OWNER = 'SCM_MGR' AND OBJECT_NAME = 'PKG_DMF0082' )
   AND H.PLSQL_ENTRY_SUBPROGRAM_ID = ( SELECT P.SUBPROGRAM_ID FROM ALL_PROCEDURES P
                                        WHERE P.OWNER = 'SCM_MGR' AND P.OBJECT_NAME = 'PKG_DMF0082'
                                          AND P.PROCEDURE_NAME = 'P_DMF0082_SAVE_MAIN_DATA' )
 GROUP BY H.PLSQL_OBJECT_ID, H.SQL_ID, H.SQL_OPNAME, NVL(H.EVENT,'ON CPU')
 ORDER BY SAMPLES DESC
 FETCH FIRST 40 ROWS ONLY;

PROMPT [5-B] 대기 분류 합계와 막힌 시간(BLOCKING_SESSION)
SELECT NVL(H.WAIT_CLASS,'CPU')                       AS WAIT_CLASS
     , NVL(H.EVENT,'ON CPU')                         AS EVENT
     , COUNT(*) * 10                                 AS APPROX_SEC
     , COUNT(H.BLOCKING_SESSION) * 10                AS BLOCKED_SEC
     , MIN(H.BLOCKING_SESSION)                       AS ONE_BLOCKER_SID
  FROM DBA_HIST_ACTIVE_SESS_HISTORY H
 WHERE H.SAMPLE_TIME >= SYSTIMESTAMP - INTERVAL '7' DAY
   AND H.PLSQL_ENTRY_OBJECT_ID IN ( SELECT OBJECT_ID FROM ALL_OBJECTS WHERE OWNER = 'SCM_MGR' AND OBJECT_NAME = 'PKG_DMF0082' )
   AND H.PLSQL_ENTRY_SUBPROGRAM_ID = ( SELECT P.SUBPROGRAM_ID FROM ALL_PROCEDURES P
                                        WHERE P.OWNER = 'SCM_MGR' AND P.OBJECT_NAME = 'PKG_DMF0082'
                                          AND P.PROCEDURE_NAME = 'P_DMF0082_SAVE_MAIN_DATA' )
 GROUP BY NVL(H.WAIT_CLASS,'CPU'), NVL(H.EVENT,'ON CPU')
 ORDER BY APPROX_SEC DESC
 FETCH FIRST 20 ROWS ONLY;
--
-- 판정
--   CPU 비중이 크면 실행계획(반복 읽기) 문제, User I/O 면 읽는 양, Concurrency/Application(enq: TX, TM)이면 잠금 경합,
--   Commit/Configuration(log file sync, log buffer)이면 redo 처리량 문제임

PROMPT ############################################################
PROMPT [6] 메모리 ASH (1초 표본, 보존 기간 안에 있을 때만 행이 나옴)
PROMPT ############################################################
SELECT ( SELECT O.OBJECT_NAME FROM DBA_OBJECTS O WHERE O.OBJECT_ID = H.PLSQL_OBJECT_ID ) AS OBJ_NAME
     , H.SQL_ID
     , H.SQL_PLAN_LINE_ID
     , NVL(H.EVENT,'ON CPU')                    AS EVENT
     , COUNT(*)                                 AS SAMPLES_SEC
     , TO_CHAR(MIN(H.SAMPLE_TIME),'MM-DD HH24:MI:SS') AS FIRST_TS
     , TO_CHAR(MAX(H.SAMPLE_TIME),'MM-DD HH24:MI:SS') AS LAST_TS
  FROM GV$ACTIVE_SESSION_HISTORY H
 WHERE H.PLSQL_ENTRY_OBJECT_ID IN ( SELECT OBJECT_ID FROM ALL_OBJECTS WHERE OWNER = 'SCM_MGR' AND OBJECT_NAME = 'PKG_DMF0082' )
   AND H.PLSQL_ENTRY_SUBPROGRAM_ID = ( SELECT P.SUBPROGRAM_ID FROM ALL_PROCEDURES P
                                        WHERE P.OWNER = 'SCM_MGR' AND P.OBJECT_NAME = 'PKG_DMF0082'
                                          AND P.PROCEDURE_NAME = 'P_DMF0082_SAVE_MAIN_DATA' )
 GROUP BY H.PLSQL_OBJECT_ID, H.SQL_ID, H.SQL_PLAN_LINE_ID, NVL(H.EVENT,'ON CPU')
 ORDER BY SAMPLES_SEC DESC
 FETCH FIRST 40 ROWS ONLY;

PROMPT ############################################################
PROMPT [7] AWR SQLSTAT: [5] 상위 SQL 의 최근 7일 누적 (실행당 평균 포함)
PROMPT ############################################################
SELECT Q.SQL_ID
     , Q.PLAN_HASH_VALUE                                   AS PHV
     , SUM(Q.EXECUTIONS_DELTA)                             AS EXECS
     , ROUND(SUM(Q.ELAPSED_TIME_DELTA)/1e6,1)              AS ELA_SEC
     , ROUND(SUM(Q.ELAPSED_TIME_DELTA)/1e6/NULLIF(SUM(Q.EXECUTIONS_DELTA),0),2) AS ELA_PER_EXEC
     , ROUND(SUM(Q.CPU_TIME_DELTA)/1e6,1)                  AS CPU_SEC
     , ROUND(SUM(Q.IOWAIT_DELTA)/1e6,1)                    AS IO_SEC
     , ROUND(SUM(Q.CCWAIT_DELTA)/1e6,1)                    AS CONC_SEC
     , SUM(Q.BUFFER_GETS_DELTA)                            AS BUFFER_GETS
     , SUM(Q.ROWS_PROCESSED_DELTA)                         AS ROWS_PROC
     , ( SELECT SUBSTR(REGEXP_REPLACE(DBMS_LOB.SUBSTR(T.SQL_TEXT,400,1),'\s+',' '),1,90)
           FROM DBA_HIST_SQLTEXT T
          WHERE T.SQL_ID = Q.SQL_ID AND T.DBID = Q.DBID AND ROWNUM = 1 ) AS SQL_HEAD
  FROM DBA_HIST_SQLSTAT Q
  JOIN DBA_HIST_SNAPSHOT N
    ON N.SNAP_ID = Q.SNAP_ID AND N.DBID = Q.DBID AND N.INSTANCE_NUMBER = Q.INSTANCE_NUMBER
 WHERE N.END_INTERVAL_TIME >= SYSTIMESTAMP - INTERVAL '7' DAY
   AND Q.SQL_ID IN ( SELECT SQL_ID FROM (
                       SELECT H.SQL_ID, COUNT(*) AS CNT
                         FROM DBA_HIST_ACTIVE_SESS_HISTORY H
                        WHERE H.SAMPLE_TIME >= SYSTIMESTAMP - INTERVAL '7' DAY
                          AND H.SQL_ID IS NOT NULL
                          AND H.PLSQL_ENTRY_OBJECT_ID IN ( SELECT OBJECT_ID FROM ALL_OBJECTS WHERE OWNER = 'SCM_MGR' AND OBJECT_NAME = 'PKG_DMF0082' )
                          AND H.PLSQL_ENTRY_SUBPROGRAM_ID = ( SELECT P.SUBPROGRAM_ID FROM ALL_PROCEDURES P
                                                               WHERE P.OWNER = 'SCM_MGR' AND P.OBJECT_NAME = 'PKG_DMF0082'
                                                                 AND P.PROCEDURE_NAME = 'P_DMF0082_SAVE_MAIN_DATA' )
                        GROUP BY H.SQL_ID ORDER BY CNT DESC )
                     WHERE ROWNUM <= 15 )
 GROUP BY Q.SQL_ID, Q.PLAN_HASH_VALUE, Q.DBID
 ORDER BY ELA_SEC DESC;

PROMPT ############################################################
PROMPT [8] 상위 3개 SQL 실행계획 (AWR 보관분)
PROMPT ############################################################
SELECT P.PLAN_TABLE_OUTPUT
  FROM ( SELECT SQL_ID, PHV
           FROM ( SELECT H.SQL_ID, H.SQL_PLAN_HASH_VALUE AS PHV, COUNT(*) AS CNT
                    FROM DBA_HIST_ACTIVE_SESS_HISTORY H
                   WHERE H.SAMPLE_TIME >= SYSTIMESTAMP - INTERVAL '7' DAY
                     AND H.SQL_ID IS NOT NULL
                     AND H.SQL_PLAN_HASH_VALUE <> 0
                     AND H.PLSQL_ENTRY_OBJECT_ID IN ( SELECT OBJECT_ID FROM ALL_OBJECTS WHERE OWNER = 'SCM_MGR' AND OBJECT_NAME = 'PKG_DMF0082' )
                     AND H.PLSQL_ENTRY_SUBPROGRAM_ID = ( SELECT P.SUBPROGRAM_ID FROM ALL_PROCEDURES P
                                                          WHERE P.OWNER = 'SCM_MGR' AND P.OBJECT_NAME = 'PKG_DMF0082'
                                                            AND P.PROCEDURE_NAME = 'P_DMF0082_SAVE_MAIN_DATA' )
                   GROUP BY H.SQL_ID, H.SQL_PLAN_HASH_VALUE
                   ORDER BY CNT DESC )
          WHERE ROWNUM <= 3 ) T
     , TABLE(DBMS_XPLAN.DISPLAY_AWR(T.SQL_ID, T.PHV, NULL, 'TYPICAL')) P;

PROMPT ############################################################
PROMPT [9] 커서 캐시: 저장 프로시저 라인별 SQL 누적 (라이선스 불필요)
PROMPT     PROGRAM_LINE# = PKG_DMF0082 BODY 라인. [0] SAVE_START_LINE 이후 라인이 저장 프로시저임
PROMPT     같은 문장이라도 저장 여러 번이 합산됨. ELA_PER_EXEC 로 1회 비용을 봄
PROMPT ############################################################
SELECT S.PROGRAM_LINE#
     , S.SQL_ID
     , S.PLAN_HASH_VALUE                         AS PHV
     , S.EXECUTIONS
     , ROUND(S.ELAPSED_TIME/1e6,1)               AS ELA_SEC
     , ROUND(S.ELAPSED_TIME/1e6/NULLIF(S.EXECUTIONS,0),2) AS ELA_PER_EXEC
     , ROUND(S.CPU_TIME/1e6,1)                   AS CPU_SEC
     , ROUND(S.USER_IO_WAIT_TIME/1e6,1)          AS IO_SEC
     , ROUND(S.CONCURRENCY_WAIT_TIME/1e6,1)      AS CONC_SEC
     , S.BUFFER_GETS
     , S.ROWS_PROCESSED
     , TO_CHAR(S.LAST_ACTIVE_TIME,'MM-DD HH24:MI:SS') AS LAST_ACTIVE
     , SUBSTR(REGEXP_REPLACE(S.SQL_TEXT,'\s+',' '),1,90) AS SQL_HEAD
  FROM GV$SQL S
 WHERE S.PROGRAM_ID IN ( SELECT OBJECT_ID FROM ALL_OBJECTS
                          WHERE OWNER = 'SCM_MGR'
                            AND OBJECT_NAME IN ('PKG_DMF0082','PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE') )
   AND S.PROGRAM_LINE# >= CASE WHEN S.PROGRAM_ID IN ( SELECT OBJECT_ID FROM ALL_OBJECTS
                                                       WHERE OWNER = 'SCM_MGR' AND OBJECT_NAME = 'PKG_DMF0082' )
                               THEN ( SELECT MIN(LINE) FROM ALL_SOURCE
                                       WHERE OWNER = 'SCM_MGR' AND NAME = 'PKG_DMF0082' AND TYPE = 'PACKAGE BODY'
                                         AND REGEXP_LIKE(TEXT,'^PROCEDURE\s+P_DMF0082_SAVE_MAIN_DATA','i') )
                               ELSE 0 END
 ORDER BY S.ELAPSED_TIME DESC
 FETCH FIRST 40 ROWS ONLY;

PROMPT ############################################################
PROMPT [10] 옵티마이저 설정 (사내와 다르면 같은 SQL 이 다른 계획을 탐)
PROMPT ############################################################
SELECT NAME, VALUE, ISDEFAULT
  FROM V$PARAMETER
 WHERE NAME IN ( 'optimizer_dynamic_sampling','optimizer_adaptive_plans','optimizer_adaptive_statistics'
               , 'optimizer_features_enable','optimizer_mode','cursor_sharing'
               , 'parallel_degree_policy','db_file_multiblock_read_count','pga_aggregate_target'
               , 'pga_aggregate_limit','sga_target','undo_retention' )
 ORDER BY NAME;
--
-- 사내(2026-09-30 점검 기록) 대비 클라우드 차이: optimizer_dynamic_sampling=0, optimizer_adaptive_plans=FALSE
--   저장 프로시저는 GT_PRDM1_* 통계를 지우고(DELETE_TABLE_STATS) 동적 표본에 기대는 구간이 있음.
--   dynamic_sampling=0 이면 GTT 건수를 모르는 채로 계획을 세움

PROMPT ############################################################
PROMPT [11] 저장이 쓰는 GTT 통계 상태 (잠금, 행 수, 수집 시각)
PROMPT ############################################################
SELECT TABLE_NAME, NUM_ROWS, STATTYPE_LOCKED, STALE_STATS
     , TO_CHAR(LAST_ANALYZED,'YYYY-MM-DD HH24:MI:SS') AS LAST_ANALYZED, SCOPE
  FROM DBA_TAB_STATISTICS
 WHERE OWNER = 'SCM_MGR'
   AND ( TABLE_NAME LIKE 'GT_PRDM1\_%' ESCAPE '\' OR TABLE_NAME LIKE 'GT_PRDM\_%' ESCAPE '\' OR TABLE_NAME = 'GT_DMF0082_SAVE_FLAG' )
 ORDER BY TABLE_NAME, SCOPE;

PROMPT ############################################################
PROMPT [12] 저장 대상 영구 테이블 상태 (행 수, 크기, 통계, 인덱스, 트리거)
PROMPT ############################################################
SELECT T.TABLE_NAME
     , T.NUM_ROWS
     , TO_CHAR(T.LAST_ANALYZED,'YYYY-MM-DD')                AS LAST_ANALYZED
     , ( SELECT MAX(S.STALE_STATS) FROM DBA_TAB_STATISTICS S
          WHERE S.OWNER = T.OWNER AND S.TABLE_NAME = T.TABLE_NAME AND S.OBJECT_TYPE = 'TABLE' ) AS STALE
     , T.PARTITIONED
     , ( SELECT ROUND(SUM(G.BYTES)/1048576) FROM DBA_SEGMENTS G
          WHERE G.OWNER = T.OWNER AND G.SEGMENT_NAME = T.TABLE_NAME )      AS TABLE_MB
     , ( SELECT COUNT(*) FROM DBA_INDEXES I
          WHERE I.TABLE_OWNER = T.OWNER AND I.TABLE_NAME = T.TABLE_NAME )  AS IDX_CNT
     , ( SELECT COUNT(*) FROM DBA_INDEXES I
          WHERE I.TABLE_OWNER = T.OWNER AND I.TABLE_NAME = T.TABLE_NAME AND I.STATUS = 'UNUSABLE' ) AS IDX_UNUSABLE
     , ( SELECT COUNT(*) FROM DBA_IND_PARTITIONS IP JOIN DBA_INDEXES I
                 ON I.OWNER = IP.INDEX_OWNER AND I.INDEX_NAME = IP.INDEX_NAME
          WHERE I.TABLE_OWNER = T.OWNER AND I.TABLE_NAME = T.TABLE_NAME AND IP.STATUS = 'UNUSABLE' ) AS IDXPART_UNUSABLE
     , ( SELECT COUNT(*) FROM DBA_TRIGGERS R
          WHERE R.TABLE_OWNER = T.OWNER AND R.TABLE_NAME = T.TABLE_NAME AND R.STATUS = 'ENABLED' ) AS TRG_ENABLED
     , T.LOGGING
  FROM DBA_TABLES T
 WHERE T.OWNER = 'SCM_MGR'
   AND T.TABLE_NAME IN ( 'DM_PLN_CFM_SELLING_PRICE','DM_PLN_CFM_SELLING_PRICE_H'
                       , 'DM_PLN_CFM_MKT_DEMAND_PLAN','DM_PLN_CFM_MKT_DEMAND_PLAN_H'
                       , 'SCM_MST_FUTURE_PRICE','SCM_MST_FUTURE_PRICE_H'
                       , 'DM_PLN_MKT_FCST','DM_PLN_MKT_FCST_H','SCM_SYS_LOG_BATCH' )
 ORDER BY T.TABLE_NAME;
--
-- 사내 2026-09-29 측정에서 SCM_MST_FUTURE_PRICE DELETE 323초(흩어진 블록 읽기)가 최대 구간이었음
--   IDX_UNUSABLE, IDXPART_UNUSABLE 이 0 이 아니면 그 인덱스를 못 써서 전체를 읽음
--   TRG_ENABLED 가 있으면 행마다 트리거가 돌므로 [5] OBJ_NAME 에 트리거 이름이 나오는지 봄

PROMPT ############################################################
PROMPT [13] 저장 대상 테이블 인덱스 목록 (사내와 대조용)
PROMPT ############################################################
SELECT I.TABLE_NAME, I.INDEX_NAME, I.STATUS, I.PARTITIONED, I.BLEVEL, I.CLUSTERING_FACTOR
     , ( SELECT LISTAGG(C.COLUMN_NAME, ',') WITHIN GROUP (ORDER BY C.COLUMN_POSITION)
           FROM DBA_IND_COLUMNS C
          WHERE C.INDEX_OWNER = I.OWNER AND C.INDEX_NAME = I.INDEX_NAME ) AS COLS
  FROM DBA_INDEXES I
 WHERE I.TABLE_OWNER = 'SCM_MGR'
   AND I.TABLE_NAME IN ( 'DM_PLN_CFM_SELLING_PRICE','DM_PLN_CFM_MKT_DEMAND_PLAN'
                       , 'SCM_MST_FUTURE_PRICE','DM_PLN_MKT_FCST' )
 ORDER BY I.TABLE_NAME, I.INDEX_NAME;

SPOOL OFF
