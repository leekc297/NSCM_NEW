/****************************************************************************************************/
/* DMF0045 조회 실행 중 감시 쿼리 (클라우드 실행용)                                                  */
/* 쓰는 때 : DMF0045_CLOUD_QUERY_CHECK_20261125.sql 3번 또는 화면 조회가 끝나지 않을 때             */
/* 실행 : 3번을 돌리는 창은 그대로 두고, 새 접속 창에서 이 파일 전체 실행(F5). 조회 전용임.          */
/*        1~2분 간격으로 2~3회 실행해 1번 PROGRAM_LINE 이 바뀌는지 회신.                           */
/*                                                                                                  */
/* PROGRAM_LINE = PKG_DMF0045 PACKAGE BODY 줄 번호 (사내 ZIOUI1 2026-11-17 19:51:38 본 기준)        */
/*   205 출하요청 / 303 SCP 출하계획 / 435 마케팅 FCST / 493 ETD 계산 / 690 출하확정               */
/*   882 Pack FP(81) / 968 Pack FP 생산계획(82) / 1074 Pack FP / 1126 SHIP_ROW / 1237 W/H BOH      */
/*   1357 달력 행 / 1513~1724 PIVOT / 1786 BOD_ID 갱신 / 1931 화면 결과 SELECT                      */
/*                                                                                                  */
/* V$ 조회에서 ORA-00942 가 나면 DBA 에게 SELECT_CATALOG_ROLE 요청.                                  */
/****************************************************************************************************/

SET LINESIZE 300
SET PAGESIZE 500
SET TIMING ON
SET FEEDBACK ON

PROMPT ===== 1. 실행 중인 DMF0045 조회 세션, 지금 도는 문장 줄 번호 =====
SELECT S.SID
     , S.SERIAL#
     , S.USERNAME
     , S.MACHINE
     , S.PROGRAM
     , S.STATUS
     , S.SQL_ID
     , Q.PROGRAM_LINE#                                        AS PROGRAM_LINE
     , ROUND((SYSDATE - S.SQL_EXEC_START) * 86400)            AS STMT_SEC
     , S.LAST_CALL_ET                                         AS CALL_SEC
     , S.EVENT
     , S.WAIT_CLASS
     , S.SECONDS_IN_WAIT
     , S.BLOCKING_SESSION
     , SUBSTR(Q.SQL_TEXT, 1, 80)                              AS SQL_TEXT
  FROM V$SESSION S
     , V$SQL     Q
 WHERE S.SQL_ID           = Q.SQL_ID
   AND S.SQL_CHILD_NUMBER = Q.CHILD_NUMBER
   AND S.STATUS           = 'ACTIVE'
   AND (   Q.PROGRAM_ID IN (SELECT O.OBJECT_ID
                              FROM ALL_OBJECTS O
                             WHERE O.OWNER       = 'SCM_MGR'
                               AND O.OBJECT_NAME = 'PKG_DMF0045')
        OR S.PLSQL_ENTRY_OBJECT_ID IN (SELECT O.OBJECT_ID
                                         FROM ALL_OBJECTS O
                                        WHERE O.OWNER       = 'SCM_MGR'
                                          AND O.OBJECT_NAME = 'PKG_DMF0045')
        OR Q.SQL_TEXT LIKE '%GT_DMF0045_PIVOT%')
 ORDER BY S.LAST_CALL_ET DESC;

PROMPT ===== 2. 최근 60분 PKG_DMF0045 문장 진행 이력 (LAST_ACTIVE 순, 마지막 줄이 지금 단계) =====
SELECT Q.SQL_ID
     , Q.PROGRAM_LINE#                                             AS PROGRAM_LINE
     , Q.EXECUTIONS
     , Q.USERS_EXECUTING
     , ROUND(Q.ELAPSED_TIME / 1000000, 2)                          AS ELAPSED_SEC
     , ROUND(Q.ELAPSED_TIME / NULLIF(Q.EXECUTIONS, 0) / 1000000, 2) AS SEC_PER_EXEC
     , Q.BUFFER_GETS
     , Q.DISK_READS
     , Q.ROWS_PROCESSED
     , TO_CHAR(Q.LAST_ACTIVE_TIME, 'YYYY-MM-DD HH24:MI:SS')        AS LAST_ACTIVE
     , SUBSTR(Q.SQL_TEXT, 1, 60)                                   AS SQL_TEXT
  FROM V$SQL Q
 WHERE Q.PROGRAM_ID IN (SELECT O.OBJECT_ID
                          FROM ALL_OBJECTS O
                         WHERE O.OWNER       = 'SCM_MGR'
                           AND O.OBJECT_NAME = 'PKG_DMF0045')
   AND Q.LAST_ACTIVE_TIME >= SYSDATE - 1 / 24
 ORDER BY Q.LAST_ACTIVE_TIME;

PROMPT ===== 3. 지금 도는 문장 실행계획 =====
SELECT T.PLAN_TABLE_OUTPUT
  FROM (SELECT DISTINCT S.SQL_ID, S.SQL_CHILD_NUMBER
          FROM V$SESSION S
             , V$SQL     Q
         WHERE S.SQL_ID           = Q.SQL_ID
           AND S.SQL_CHILD_NUMBER = Q.CHILD_NUMBER
           AND S.STATUS           = 'ACTIVE'
           AND Q.PROGRAM_ID IN (SELECT O.OBJECT_ID
                                  FROM ALL_OBJECTS O
                                 WHERE O.OWNER       = 'SCM_MGR'
                                   AND O.OBJECT_NAME = 'PKG_DMF0045')) X
     , TABLE(DBMS_XPLAN.DISPLAY_CURSOR(X.SQL_ID, X.SQL_CHILD_NUMBER, 'TYPICAL')) T;

PROMPT ===== 4. 오래 걸리는 읽기 진행률 (6초 넘는 전체 읽기, 정렬 등) =====
SELECT L.SID
     , L.SQL_ID
     , L.OPNAME
     , L.TARGET
     , L.SOFAR
     , L.TOTALWORK
     , ROUND(L.SOFAR / NULLIF(L.TOTALWORK, 0) * 100, 1) AS PCT
     , L.ELAPSED_SECONDS
     , L.TIME_REMAINING
  FROM V$SESSION_LONGOPS L
 WHERE L.SOFAR < L.TOTALWORK
   AND L.SID IN (SELECT S.SID
                   FROM V$SESSION S
                      , V$SQL     Q
                  WHERE S.SQL_ID           = Q.SQL_ID
                    AND S.SQL_CHILD_NUMBER = Q.CHILD_NUMBER
                    AND S.STATUS           = 'ACTIVE'
                    AND Q.PROGRAM_ID IN (SELECT O.OBJECT_ID
                                           FROM ALL_OBJECTS O
                                          WHERE O.OWNER       = 'SCM_MGR'
                                            AND O.OBJECT_NAME = 'PKG_DMF0045'))
 ORDER BY L.ELAPSED_SECONDS DESC;

PROMPT ===== 5. 막고 있는 세션 (1번 BLOCKING_SESSION 값이 있을 때) =====
SELECT B.SID
     , B.SERIAL#
     , B.USERNAME
     , B.MACHINE
     , B.PROGRAM
     , B.STATUS
     , B.SQL_ID
     , B.PREV_SQL_ID
     , B.LAST_CALL_ET
  FROM V$SESSION B
 WHERE B.SID IN (SELECT S.BLOCKING_SESSION
                   FROM V$SESSION S
                      , V$SQL     Q
                  WHERE S.SQL_ID           = Q.SQL_ID
                    AND S.SQL_CHILD_NUMBER = Q.CHILD_NUMBER
                    AND S.BLOCKING_SESSION IS NOT NULL
                    AND Q.PROGRAM_ID IN (SELECT O.OBJECT_ID
                                           FROM ALL_OBJECTS O
                                          WHERE O.OWNER       = 'SCM_MGR'
                                            AND O.OBJECT_NAME = 'PKG_DMF0045'));

/* 6. 멈추기 : 1번 SID, SERIAL# 를 넣고 주석을 풀어 실행. 문장만 취소되고 접속은 유지됨.            */
/*    취소된 창에서는 ROLLBACK 실행.                                                                */
-- ALTER SYSTEM CANCEL SQL '<SID>, <SERIAL#>';
