/****************************************************************************************************/
/* DMF0045 Shipment Request 조회 점검 쿼리 (클라우드 실행용)                                          */
/* 대상 : SCM_MGR.PKG_DMF0045.P_DMF0045_GET_SHIPMENT_REQUEST                                        */
/* 실행 : SQL*Plus 또는 SQL Developer 스크립트 실행(F5). 조회 전용이고 마지막에 ROLLBACK 함.          */
/* 작성 : 2026-11-25, 사내 ZIOUI1 원문(PACKAGE BODY 2399줄, LAST_DDL 2026-11-17 19:51:38) 기준       */
/*                                                                                                  */
/* 순서                                                                                             */
/*  1. 접속 DB, PKG_DMF0045 버전 확인                                                                */
/*  2. 조회 조건 원천 건수 (테이블별 소요 초는 SET TIMING 출력)                                     */
/*  3. 조회 1회 실행, 프로시저 초와 결과 FETCH 초 분리 출력                                         */
/*  4. 3번 직후 같은 세션 임시 테이블 단계별 건수                                                    */
/*  5. PKG_DMF0045 안 문장별 누적 소요 (V$SQL 권한 필요)                                             */
/*  6. 소요 상위 5문장 실행계획 (V$SQL_PLAN 권한 필요)                                               */
/*  7. 원천 테이블 통계, 인덱스                                                                      */
/*  8. ROLLBACK (3번에서 사용자 측정값 기본행이 들어갔을 때 되돌림)                                  */
/*                                                                                                  */
/* 5, 6 에서 ORA-00942 가 나면 DBA 에게 SELECT_CATALOG_ROLE 요청 후 다시 실행.                       */
/* 결과 전체를 텍스트로 저장해 회신 (SQL*Plus 는 SPOOL 경로만 바꿔서 사용).                          */
/*                                                                                                  */
/* 사내 ZIOUI1 기준값 (2026-11-25 13:42, 아래 DEFINE 기본 조건 그대로 실행)                          */
/*  3번  1회차 PROC_SEC 12.27 / FETCH_SEC 0.34, 바로 이어 2회차 PROC_SEC 4.42 / FETCH_SEC 0.24       */
/*       RESULT_ROWS 987. 클라우드도 2회 실행해 두 값을 함께 회신.                                   */
/*  4번  SHIP_REQ 432, MKT 512, ETD 323, PLAN 2413, SHIP_ROW 13917, REQUESTOR 101, PIVOT 30762       */
/*  5번  상위 문장 (PROGRAM_LINE, 초)                                                                */
/*       968  Pack FP 생산계획 SCP_ANL_PRODUCTION_PLAN (82 사업부)   3.83                            */
/*       1786 PIVOT BOD_ID 갱신                                      2.37                            */
/*       493  ETD 계산 FN_GET_SSP_ETD_DATE                            0.89                            */
/*       1237 W/H BOH                                                0.81                            */
/*       1931 화면 결과 SELECT                                       0.40                            */
/*  2-6  SCP_ANL_PRODUCTION_PLAN 건수 2044, 10.13초                                                  */
/* 클라우드 값이 기준값보다 큰 줄이 느린 단계임. 같은 줄의 6번 실행계획, 7번 통계를 함께 회신.       */
/****************************************************************************************************/

SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 300
SET PAGESIZE 500
SET TIMING ON
SET VERIFY OFF
SET FEEDBACK ON

/* 느렸던 화면 조회 조건으로 바꿔서 실행. ALL = 조건 없음 */
DEFINE P_SHEET      = 'Pack Biz'
DEFINE P_DIV        = '82'
DEFINE P_TEAM       = 'ALL'
DEFINE P_CUSTOMER   = 'ALL'
DEFINE P_SCM_SITE   = 'ALL'
DEFINE P_PLANT_SITE = 'ALL'
DEFINE P_PROJECT    = 'ALL'
DEFINE P_ITEM       = 'ALL'
DEFINE P_FROM       = '20261123'
DEFINE P_TO         = '20270131'
DEFINE P_USER       = 'jaeuk.shin'

ALTER SESSION SET CURRENT_SCHEMA = SCM_MGR;

-- SPOOL C:\temp\DMF0045_CLOUD_QUERY_CHECK_RESULT.txt

PROMPT ===== 1-1. 접속 DB =====
SELECT SYS_CONTEXT('USERENV', 'DB_NAME')     AS DB_NAME
     , SYS_CONTEXT('USERENV', 'SERVER_HOST') AS SERVER_HOST
     , SYS_CONTEXT('USERENV', 'SESSION_USER') AS SESSION_USER
     , TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') AS RUN_TIME
  FROM DUAL;

PROMPT ===== 1-2. PKG_DMF0045 버전 (사내 ZIOUI1 : BODY 2399줄, HASH_SUM 5095357412898) =====
SELECT A.OBJECT_TYPE
     , A.STATUS
     , TO_CHAR(A.LAST_DDL_TIME, 'YYYY-MM-DD HH24:MI:SS') AS LAST_DDL_TIME
     , (SELECT COUNT(*)          FROM ALL_SOURCE S WHERE S.OWNER = A.OWNER AND S.NAME = A.OBJECT_NAME AND S.TYPE = A.OBJECT_TYPE) AS LINE_CNT
     , (SELECT SUM(ORA_HASH(S.TEXT)) FROM ALL_SOURCE S WHERE S.OWNER = A.OWNER AND S.NAME = A.OBJECT_NAME AND S.TYPE = A.OBJECT_TYPE) AS HASH_SUM
  FROM ALL_OBJECTS A
 WHERE A.OWNER       = 'SCM_MGR'
   AND A.OBJECT_NAME = 'PKG_DMF0045'
 ORDER BY A.OBJECT_TYPE;

PROMPT ===== 2-1. 출하요청 DM_PLN_SHIPMENT_REQ (조회 기간) =====
SELECT COUNT(*) AS CNT
  FROM DM_PLN_SHIPMENT_REQ A
 WHERE A.DIVISION_ID = '&P_DIV'
   AND A.YYYYMMDD BETWEEN '&P_FROM' AND '&P_TO';

PROMPT ===== 2-2. 최신 SCP 주간 계획 버전 (RTF, SCP Ship Plan 기준) =====
SELECT *
  FROM (SELECT A.PLAN_START_YYYYMMDD, A.PLAN_TYPE, A.PLAN_SEQ, A.PLAN_ID
          FROM SCP_PLAN_VERSION_V A
         WHERE A.DIVISION_ID = '&P_DIV'
           AND A.PLAN_CYCLE  = 'WEEKLY'
           AND A.PLAN_TYPE   = 'FN'
         ORDER BY A.PLAN_START_YYYYMMDD DESC, A.PLAN_TYPE_ORDER DESC, A.PLAN_SEQ DESC)
 WHERE ROWNUM <= 3;

PROMPT ===== 2-3. SCP 출하계획 페깅 뷰 SCP_OPT_SHIPMENT_PLAN_PEGGING_V (사업부 전체) =====
SELECT COUNT(*) AS CNT
  FROM SCP_OPT_SHIPMENT_PLAN_PEGGING_V A
 WHERE A.DIVISION_ID = '&P_DIV';

PROMPT ===== 2-4. 마케팅 FCST DM_PLN_MKT_FCST (사업부 전체) =====
SELECT COUNT(*) AS CNT
  FROM DM_PLN_MKT_FCST A
 WHERE A.DIVISION_ID = '&P_DIV';

PROMPT ===== 2-5. 출하확정 SSP_ANL_SHIP_CONFIRM (사업부 전체) =====
SELECT COUNT(*) AS CNT
  FROM SSP_ANL_SHIP_CONFIRM A
 WHERE A.DIVISION_ID = '&P_DIV';

PROMPT ===== 2-6. 생산계획 SCP_ANL_PRODUCTION_PLAN (82 사업부 Pack FP, 최근 2주 최신 버전, 조회 기간) =====
SELECT COUNT(*) AS CNT
  FROM SCP_ANL_PRODUCTION_PLAN A
     , (SELECT DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, PLAN_SEQ
          FROM (SELECT DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, PLAN_SEQ
                     , ROW_NUMBER() OVER (ORDER BY PLAN_START_YYYYMMDD DESC, PLAN_SEQ DESC) AS ROW_NUM
                  FROM SCP_PLAN_VERSION_V
                 WHERE DIVISION_ID          = '&P_DIV'
                   AND PLAN_CYCLE           = 'WEEKLY'
                   AND PLAN_TYPE            = 'FN'
                   AND PLAN_START_YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 14, 'YYYYMMDD'))
         WHERE ROW_NUM = 1) SA
 WHERE A.DIVISION_ID         = SA.DIVISION_ID
   AND A.PLAN_START_YYYYMMDD = SA.PLAN_START_YYYYMMDD
   AND A.PLAN_TYPE           = SA.PLAN_TYPE
   AND A.SEQ                 = SA.PLAN_SEQ
   AND A.MEASURE             = 'PROD_PLAN_AMEND'
   AND A.QTY                 > 0
   AND A.YYYYMMDD BETWEEN '&P_FROM' AND '&P_TO';

PROMPT ===== 2-7. 재고 SSP_DNM_STOCK_C (사업부 전체) =====
SELECT COUNT(*) AS CNT
  FROM SSP_DNM_STOCK_C A
 WHERE A.DIVISION_ID = '&P_DIV';

PROMPT ===== 3. 조회 1회 실행 (화면 조회 버튼과 같은 호출) =====
DECLARE
    V_RC1       SYS_REFCURSOR;
    V_RES       SYS_REFCURSOR;
    V_CUR       INTEGER;
    V_COL_CNT   INTEGER;
    V_DESC      DBMS_SQL.DESC_TAB2;
    V_ROWS      NUMBER := 0;
    V_T0        NUMBER;
    V_T1        NUMBER;
    V_T2        NUMBER;
BEGIN
    V_T0 := DBMS_UTILITY.GET_TIME;

    PKG_DMF0045.P_DMF0045_GET_SHIPMENT_REQUEST
    (
        P_SHEET_NAME    => '&P_SHEET'
      , P_DIVISION_ID   => '&P_DIV'
      , P_TEAM_ID       => '&P_TEAM'
      , P_CUSTOMER      => '&P_CUSTOMER'
      , P_SCM_SITE_ID   => '&P_SCM_SITE'
      , P_PLANT_SITE_ID => '&P_PLANT_SITE'
      , P_PROJECT_CODE  => '&P_PROJECT'
      , P_ITEM_ID       => '&P_ITEM'
      , P_FROM_YYYYMMDD => '&P_FROM'
      , P_TO_YYYYMMDD   => '&P_TO'
      , P_CREATED_BY    => '&P_USER'
      , O_RC1           => V_RC1
      , O_RESULT_CURSOR => V_RES
    );

    V_T1 := DBMS_UTILITY.GET_TIME;

    /* 결과 커서 FETCH : 화면으로 넘어가는 행 수와 시간 */
    V_CUR := DBMS_SQL.TO_CURSOR_NUMBER(V_RC1);
    DBMS_SQL.DESCRIBE_COLUMNS2(V_CUR, V_COL_CNT, V_DESC);
    WHILE DBMS_SQL.FETCH_ROWS(V_CUR) > 0
    LOOP
        V_ROWS := V_ROWS + 1;
    END LOOP;
    DBMS_SQL.CLOSE_CURSOR(V_CUR);
    CLOSE V_RES;

    V_T2 := DBMS_UTILITY.GET_TIME;

    DBMS_OUTPUT.PUT_LINE('PROC_SEC  = ' || TO_CHAR((V_T1 - V_T0) / 100, 'FM9999990.00'));
    DBMS_OUTPUT.PUT_LINE('FETCH_SEC = ' || TO_CHAR((V_T2 - V_T1) / 100, 'FM9999990.00'));
    DBMS_OUTPUT.PUT_LINE('TOTAL_SEC = ' || TO_CHAR((V_T2 - V_T0) / 100, 'FM9999990.00'));
    DBMS_OUTPUT.PUT_LINE('RESULT_ROWS = ' || V_ROWS || ' , RESULT_COLS = ' || V_COL_CNT);
END;
/

PROMPT ===== 4. 임시 테이블 단계별 건수 (3번 직후, 같은 세션) =====
SELECT 'GT_DMF0045_SHIP_REQ'  AS STEP, COUNT(*) AS CNT FROM GT_DMF0045_SHIP_REQ  UNION ALL
SELECT 'GT_DMF0045_PLAN_FG'   AS STEP, COUNT(*) AS CNT FROM GT_DMF0045_PLAN_FG   UNION ALL
SELECT 'GT_DMF0045_MKT'       AS STEP, COUNT(*) AS CNT FROM GT_DMF0045_MKT       UNION ALL
SELECT 'GT_DMF0045_ETD'       AS STEP, COUNT(*) AS CNT FROM GT_DMF0045_ETD       UNION ALL
SELECT 'GT_DMF0045_PLAN'      AS STEP, COUNT(*) AS CNT FROM GT_DMF0045_PLAN      UNION ALL
SELECT 'GT_DMF0045_STOCK'     AS STEP, COUNT(*) AS CNT FROM GT_DMF0045_STOCK     UNION ALL
SELECT 'GT_DMF0045_BOH'       AS STEP, COUNT(*) AS CNT FROM GT_DMF0045_BOH       UNION ALL
SELECT 'GT_DMF0045_SHIP_ROW'  AS STEP, COUNT(*) AS CNT FROM GT_DMF0045_SHIP_ROW  UNION ALL
SELECT 'GT_DMF0045_REQUESTOR' AS STEP, COUNT(*) AS CNT FROM GT_DMF0045_REQUESTOR UNION ALL
SELECT 'GT_DMF0045_PIVOT'     AS STEP, COUNT(*) AS CNT FROM GT_DMF0045_PIVOT;

PROMPT ===== 4-1. 측정값별 PLAN 건수 =====
SELECT MEASURE, COUNT(*) AS CNT
  FROM GT_DMF0045_PLAN
 GROUP BY MEASURE
 ORDER BY 2 DESC;

PROMPT ===== 5. PKG_DMF0045 안 문장별 누적 소요 (PROGRAM_LINE = PACKAGE BODY 줄 번호) =====
SELECT *
  FROM (SELECT S.SQL_ID
             , S.CHILD_NUMBER
             , S.PROGRAM_LINE#                                         AS PROGRAM_LINE
             , S.EXECUTIONS
             , ROUND(S.ELAPSED_TIME / 1000000, 2)                      AS ELAPSED_SEC
             , ROUND(S.ELAPSED_TIME / NULLIF(S.EXECUTIONS, 0) / 1000000, 2) AS SEC_PER_EXEC
             , ROUND(S.CPU_TIME / 1000000, 2)                          AS CPU_SEC
             , S.BUFFER_GETS
             , S.DISK_READS
             , S.ROWS_PROCESSED
             , TO_CHAR(S.LAST_ACTIVE_TIME, 'YYYY-MM-DD HH24:MI:SS')    AS LAST_ACTIVE
             , SUBSTR(S.SQL_TEXT, 1, 80)                               AS SQL_TEXT
          FROM V$SQL S
         WHERE S.PROGRAM_ID = (SELECT O.OBJECT_ID
                                 FROM ALL_OBJECTS O
                                WHERE O.OWNER       = 'SCM_MGR'
                                  AND O.OBJECT_NAME = 'PKG_DMF0045'
                                  AND O.OBJECT_TYPE = 'PACKAGE BODY')
         ORDER BY S.ELAPSED_TIME DESC)
 WHERE ROWNUM <= 20;

PROMPT ===== 6. 소요 상위 5문장 실행계획 =====
SELECT T.PLAN_TABLE_OUTPUT
  FROM (SELECT SQL_ID, CHILD_NUMBER
          FROM (SELECT S.SQL_ID, S.CHILD_NUMBER
                  FROM V$SQL S
                 WHERE S.PROGRAM_ID = (SELECT O.OBJECT_ID
                                         FROM ALL_OBJECTS O
                                        WHERE O.OWNER       = 'SCM_MGR'
                                          AND O.OBJECT_NAME = 'PKG_DMF0045'
                                          AND O.OBJECT_TYPE = 'PACKAGE BODY')
                 ORDER BY S.ELAPSED_TIME DESC)
         WHERE ROWNUM <= 5) X
     , TABLE(DBMS_XPLAN.DISPLAY_CURSOR(X.SQL_ID, X.CHILD_NUMBER, 'TYPICAL')) T;

PROMPT ===== 7-1. 원천 테이블 통계 (STALE_STATS = YES 이면 통계 갱신 필요) =====
SELECT T.TABLE_NAME
     , T.NUM_ROWS
     , T.BLOCKS
     , TO_CHAR(T.LAST_ANALYZED, 'YYYY-MM-DD HH24:MI') AS LAST_ANALYZED
     , T.STALE_STATS
  FROM ALL_TAB_STATISTICS T
 WHERE T.OWNER = 'SCM_MGR'
   AND T.OBJECT_TYPE = 'TABLE'
   AND T.TABLE_NAME IN ('DM_PLN_SHIPMENT_REQ', 'DM_PLN_MKT_FCST', 'SSP_ANL_SHIP_CONFIRM', 'SSP_DNM_FP_PLAN_FROZEN'
                      , 'SCP_ANL_PRODUCTION_PLAN', 'SCP_PLN_SHIPMENT_PLAN', 'SCP_PLN_SHIPMENT_PLAN_PEGGING'
                      , 'SSP_DNM_STOCK_C', 'SCM_MST_LOCATION', 'SCM_MST_SITE', 'SCM_SYS_CALENDAR_M'
                      , 'SCP_MST_FINAL_ITEM', 'SCM_ADM_LOOKUP_MASTER_DETAIL', 'SCM_ADM_USER_M'
                      , 'SCM_MST_TITLESET_USER', 'SCM_MST_SHEET_MEASURE', 'SCM_MST_SSO_DEPT_INFO')
 ORDER BY T.NUM_ROWS DESC NULLS LAST;

PROMPT ===== 7-2. 대량 테이블 인덱스 =====
SELECT C.TABLE_NAME
     , C.INDEX_NAME
     , LISTAGG(C.COLUMN_NAME, ', ') WITHIN GROUP (ORDER BY C.COLUMN_POSITION) AS COLUMNS
     , MAX(I.STATUS) AS STATUS
  FROM ALL_IND_COLUMNS C
     , ALL_INDEXES I
 WHERE C.INDEX_OWNER = I.OWNER
   AND C.INDEX_NAME  = I.INDEX_NAME
   AND C.TABLE_OWNER = 'SCM_MGR'
   AND C.TABLE_NAME IN ('DM_PLN_SHIPMENT_REQ', 'DM_PLN_MKT_FCST', 'SSP_ANL_SHIP_CONFIRM', 'SSP_DNM_FP_PLAN_FROZEN'
                      , 'SCP_ANL_PRODUCTION_PLAN', 'SCP_PLN_SHIPMENT_PLAN', 'SCP_PLN_SHIPMENT_PLAN_PEGGING'
                      , 'SSP_DNM_STOCK_C')
 GROUP BY C.TABLE_NAME, C.INDEX_NAME
 ORDER BY C.TABLE_NAME, C.INDEX_NAME;

PROMPT ===== 8. 되돌림 =====
ROLLBACK;

-- SPOOL OFF
