-- ==============================================================================================================
-- DMF0045 UI 속도 점검 쿼리 · Oracle(클라우드)
-- 실행 : DBeaver 에서 쿼리 하나씩(Ctrl+Enter). [U4-*] 블록은 출력 창(DBMS_OUTPUT)을 켜고 실행. 마지막 [U9] ROLLBACK
-- 원문 기준 : 사내 ZIOUI1 2026-11-25 15:37:54 조회
-- 순서 : [U0-0] 현재 스키마 고정 → [U0-1] 원문 판 대조(SAME_AS_CORP = N 이면 줄 번호는 클라우드 원문 기준으로 다시 봄) → [U0] ~ [U9-1]
--   PKG_DMF0045 : PACKAGE VALID 2026-11-17 17:17:12 · PACKAGE BODY VALID 2026-11-25 14:27:06
-- 화면 호출 로그 = SCM_COM_SQL_LOG(SQL_ID = com.lgcns.nscm.callProc, SQL_TEXT = 호출 원문, ELAPSED_MS). 인덱스가 LOG_SEQ 뿐이라 최근 P_LOG_ROWS 행으로 범위를 먼저 좁힘
--   [U0] FROM_TIME 이 조회 일수보다 늦으면 P_LOG_ROWS 를 늘림
-- 버튼 로그 = SCM_COM_SYS_LOG(MNU_ID = 화면 ID). TOTAL = 서버 요청 처리 전체, DB = DB 호출 구간. 차이가 크면 DB 밖(서버, 전송) 시간
-- [U4-*] 조회 1회 재실행 = ZIOUI1 최근 호출 로그 값(LOG_SEQ 범위 6659684 ~ 7159684). 느린 조건으로 바꾸려면 [U2] SQL_TEXT 값을 같은 순서로 넣음
-- [U5] 는 [U4-*] 직후 같은 세션에서 실행(임시 테이블 건수). [U6] [U7] 은 V$ 조회 권한 필요(ORA-00942 = DBA 에 SELECT_CATALOG_ROLE 요청)
-- [U4-0] 은 저장 프로시저 안 COMMIT 을 막는 세션 설정(COMMIT 을 만나면 ORA-00034). [U9-1] 에서 되돌림
-- [U4-*] 는 DBeaver 수동 커밋 모드(Manual Commit)에서 실행. 자동 커밋이면 블록이 끝날 때 DBeaver 가 COMMIT 함
-- [U4-*] 가 1분 넘게 끝나지 않으면 그 창은 두고 새 접속 창에서 [U0-0] 실행 뒤 [U4-M1] ~ [U4-M4] 를 1~2분 간격으로 2~3회 실행해 회신(2026-11-25 클라우드 재실행 972초 사례)
-- ==============================================================================================================

-- ==============================================================================================================
-- [U0-0] 현재 스키마 고정(파일 첫 쿼리)
-- 클라우드 접속 창의 현재 스키마가 SCM_MGR 가 아니면(2026-11-25 클라우드 회신 : 로그인 SCM_MGR, 현재 스키마 FP_MGR) 이름만 쓴 테이블, 패키지가 다른 스키마에서 찾아짐
-- 파일의 다른 쿼리보다 먼저 1회 실행. 새 접속 창을 열면 그 창에서도 다시 실행
-- ==============================================================================================================
ALTER SESSION SET CURRENT_SCHEMA = SCM_MGR;

-- ==============================================================================================================
-- [U0-1] 클라우드 원문 판 대조(사내 ZIOUI1 원문과 같은지)
-- 확인 : SAME_AS_CORP = N 이면 클라우드 원문이 사내 원문과 다름. 아래 SRC_LINE(줄 번호), 단계 이름은 클라우드 원문 기준으로 다시 봄(원문 회신 필요)
-- CLOUD_LINES 가 비어 있으면 클라우드에 객체 없음
-- ==============================================================================================================
WITH CORP AS (
  SELECT 'PKG_DMF0045' AS NAME, 'PACKAGE' AS TYPE, 63 AS CORP_LINES, 119644605325 AS CORP_HASH FROM DUAL
  UNION ALL SELECT 'PKG_DMF0045' AS NAME, 'PACKAGE BODY' AS TYPE, 2400 AS CORP_LINES, 5100762242469 AS CORP_HASH FROM DUAL
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
-- [U0] 로그 범위 확인
-- 확인 : FROM_TIME ~ TO_TIME 이 점검할 기간을 덮는지
-- ==============================================================================================================
WITH PRM AS (SELECT 7 AS P_DAYS, 500000 AS P_LOG_ROWS FROM DUAL)   /* 조회 일수, 최근 로그 행 수 범위. 이 줄의 값만 바꿔 실행 */
, RNG AS (SELECT MAX(X.LOG_SEQ) - MAX(PRM.P_LOG_ROWS) AS FROM_SEQ FROM SCM_COM_SQL_LOG X, PRM)
SELECT MIN(L.LOG_SEQ) AS FROM_SEQ
     , MAX(L.LOG_SEQ) AS TO_SEQ
     , MIN(L.EXECUTE_TIME) AS FROM_TIME
     , MAX(L.EXECUTE_TIME) AS TO_TIME
  FROM SCM_COM_SQL_LOG L
     , RNG
 WHERE L.LOG_SEQ > RNG.FROM_SEQ;

-- ==============================================================================================================
-- [U1] 조회 프로시저별 소요(최근 조회 일수)
-- 확인 : MAX_MS, P90_MS 가 큰 프로시저
-- ==============================================================================================================
WITH PRM AS (SELECT 7 AS P_DAYS, 500000 AS P_LOG_ROWS FROM DUAL)   /* 조회 일수, 최근 로그 행 수 범위. 이 줄의 값만 바꿔 실행 */
, RNG AS (SELECT MAX(X.LOG_SEQ) - MAX(PRM.P_LOG_ROWS) AS FROM_SEQ FROM SCM_COM_SQL_LOG X, PRM)
SELECT REGEXP_SUBSTR(DBMS_LOB.SUBSTR(L.SQL_TEXT, 200, 1), 'PKG_[A-Z0-9_]+\.[A-Z0-9_]+', 1, 1, 'i') AS PROC_NAME
     , COUNT(*) AS CALL_CNT
     , ROUND(AVG(L.ELAPSED_MS)) AS AVG_MS
     , ROUND(PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY L.ELAPSED_MS)) AS P90_MS
     , MAX(L.ELAPSED_MS) AS MAX_MS
     , SUM(CASE WHEN L.EXCEPTION IS NOT NULL THEN 1 ELSE 0 END) AS ERR_CNT
     , MAX(L.EXECUTE_TIME) AS LAST_TIME
  FROM SCM_COM_SQL_LOG L
     , RNG
     , PRM
 WHERE L.LOG_SEQ > RNG.FROM_SEQ
   AND L.SQL_ID = 'com.lgcns.nscm.callProc'
   AND L.EXECUTE_TIME >= SYSTIMESTAMP - NUMTODSINTERVAL(PRM.P_DAYS, 'DAY')
   AND DBMS_LOB.SUBSTR(L.SQL_TEXT, 200, 1) LIKE '%PKG\_DMF0045%' ESCAPE '\'
 GROUP BY REGEXP_SUBSTR(DBMS_LOB.SUBSTR(L.SQL_TEXT, 200, 1), 'PKG_[A-Z0-9_]+\.[A-Z0-9_]+', 1, 1, 'i')
 ORDER BY MAX_MS DESC;

-- ==============================================================================================================
-- [U2] 느린 호출 30건
-- 확인 : 느린 호출의 조건값(SQL_TEXT), 사용자, 결과 행 수
-- ==============================================================================================================
WITH PRM AS (SELECT 7 AS P_DAYS, 500000 AS P_LOG_ROWS FROM DUAL)   /* 조회 일수, 최근 로그 행 수 범위. 이 줄의 값만 바꿔 실행 */
, RNG AS (SELECT MAX(X.LOG_SEQ) - MAX(PRM.P_LOG_ROWS) AS FROM_SEQ FROM SCM_COM_SQL_LOG X, PRM)
SELECT L.LOG_SEQ
     , L.EXECUTE_TIME
     , L.ELAPSED_MS
     , L.RESULT_COUNT
     , L.CREATED_BY
     , DBMS_LOB.SUBSTR(L.SQL_TEXT, 2000, 1) AS SQL_TEXT
     , DBMS_LOB.SUBSTR(L.EXCEPTION, 300, 1) AS EXCEPTION
  FROM SCM_COM_SQL_LOG L
     , RNG
     , PRM
 WHERE L.LOG_SEQ > RNG.FROM_SEQ
   AND L.SQL_ID = 'com.lgcns.nscm.callProc'
   AND L.EXECUTE_TIME >= SYSTIMESTAMP - NUMTODSINTERVAL(PRM.P_DAYS, 'DAY')
   AND DBMS_LOB.SUBSTR(L.SQL_TEXT, 200, 1) LIKE '%PKG\_DMF0045%' ESCAPE '\'
 ORDER BY L.ELAPSED_MS DESC
 FETCH FIRST 30 ROWS ONLY;

-- ==============================================================================================================
-- [U3] 버튼별 처리 시간(SCM_COM_SYS_LOG)
-- 확인 : TOTAL 과 DB 차이
-- ==============================================================================================================
WITH PRM AS (SELECT 7 AS P_DAYS FROM DUAL)   /* 조회 일수. 이 줄의 값만 바꿔 실행 */
SELECT L.MNU_BTN_CD
     , L.SHT_NM
     , COUNT(*) AS CNT
     , ROUND(AVG((CAST(L.TRNM_END_DTM AS DATE) - CAST(L.TRNM_ST_DTM AS DATE)) * 86400), 1) AS AVG_TOTAL_SEC
     , ROUND(MAX((CAST(L.TRNM_END_DTM AS DATE) - CAST(L.TRNM_ST_DTM AS DATE)) * 86400), 1) AS MAX_TOTAL_SEC
     , ROUND(AVG((CAST(L.DB_TRNM_END_DTM AS DATE) - CAST(L.DB_TRNM_ST_DTM AS DATE)) * 86400), 1) AS AVG_DB_SEC
     , ROUND(MAX((CAST(L.DB_TRNM_END_DTM AS DATE) - CAST(L.DB_TRNM_ST_DTM AS DATE)) * 86400), 1) AS MAX_DB_SEC
     , SUM(CASE WHEN LENGTH(TRIM(L.EXCT_MSG_CTN)) > 0 THEN 1 ELSE 0 END) AS ERR_CNT
     , MAX(L.CREATION_DATE) AS LAST_DATE
  FROM SCM_COM_SYS_LOG L
     , PRM
 WHERE L.MNU_ID = 'DMF0045'
   AND L.CREATION_DATE >= SYSDATE - PRM.P_DAYS
   AND L.LOG_TP_CD IN ('BUTTON', 'EXCELUPLOAD')
 GROUP BY L.MNU_BTN_CD
        , L.SHT_NM
 ORDER BY MAX_TOTAL_SEC DESC NULLS LAST;

-- ==============================================================================================================
-- [U4-0] 저장 프로시저 COMMIT 막기(재실행 전 필수)
-- 확인 : 오류 없이 끝남. 같은 탭에서 [U4-*] 실행
-- ==============================================================================================================
ALTER SESSION DISABLE COMMIT IN PROCEDURE;

-- ==============================================================================================================
-- [U4-1] 조회 1회 재실행 PKG_DMF0045.P_DMF0045_GET_SHIPMENT_REQUEST
-- 확인 : PROC_SEC = 프로시저 시간, FETCH_SEC = 결과 읽기 시간, 커서별 행 수
-- ZIOUI1 로그 LOG_SEQ 7046465, 17682 ms 호출 값
-- 테이블 쓰기 있음(SCM_MST_TITLESET_USER, COMMIT 없음). DBeaver 수동 커밋 모드에서 실행하고 [U9] ROLLBACK
-- ==============================================================================================================
DECLARE
    V_12         SYS_REFCURSOR;
    V_13         SYS_REFCURSOR;
    V_CUR        INTEGER;
    V_COLS       INTEGER;
    V_DESC       DBMS_SQL.DESC_TAB2;
    V_ROWS       NUMBER;
    V_T0         NUMBER;
    V_T1         NUMBER;
    V_T2         NUMBER;
BEGIN
    V_T0 := DBMS_UTILITY.GET_TIME;
    PKG_DMF0045.P_DMF0045_GET_SHIPMENT_REQUEST(
        P_SHEET_NAME => 'Pack Biz'
      , P_DIVISION_ID => '81'
      , P_TEAM_ID => 'ALL'
      , P_CUSTOMER => 'ALL'
      , P_SCM_SITE_ID => 'ALL'
      , P_PLANT_SITE_ID => 'ALL'
      , P_PROJECT_CODE => ''
      , P_ITEM_ID => ''
      , P_FROM_YYYYMMDD => '20261124'
      , P_TO_YYYYMMDD => '20270118'
      , P_CREATED_BY => 'minyonglee1'
      , O_RC1 => V_12
      , O_RESULT_CURSOR => V_13
    );
    V_T1 := DBMS_UTILITY.GET_TIME;
    BEGIN
        V_ROWS := 0;
        V_CUR := DBMS_SQL.TO_CURSOR_NUMBER(V_12);
        DBMS_SQL.DESCRIBE_COLUMNS2(V_CUR, V_COLS, V_DESC);
        WHILE DBMS_SQL.FETCH_ROWS(V_CUR) > 0 LOOP
            V_ROWS := V_ROWS + 1;
        END LOOP;
        DBMS_SQL.CLOSE_CURSOR(V_CUR);
        DBMS_OUTPUT.PUT_LINE('V_12 ROWS = ' || V_ROWS || ' , COLS = ' || V_COLS);
    EXCEPTION
        WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('V_12 열리지 않음 : ' || SQLERRM);
    END;
    BEGIN
        V_ROWS := 0;
        V_CUR := DBMS_SQL.TO_CURSOR_NUMBER(V_13);
        DBMS_SQL.DESCRIBE_COLUMNS2(V_CUR, V_COLS, V_DESC);
        WHILE DBMS_SQL.FETCH_ROWS(V_CUR) > 0 LOOP
            V_ROWS := V_ROWS + 1;
        END LOOP;
        DBMS_SQL.CLOSE_CURSOR(V_CUR);
        DBMS_OUTPUT.PUT_LINE('V_13 ROWS = ' || V_ROWS || ' , COLS = ' || V_COLS);
    EXCEPTION
        WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('V_13 열리지 않음 : ' || SQLERRM);
    END;
    V_T2 := DBMS_UTILITY.GET_TIME;
    DBMS_OUTPUT.PUT_LINE('PROC_SEC  = ' || TO_CHAR((V_T1 - V_T0) / 100, 'FM9999990.00'));
    DBMS_OUTPUT.PUT_LINE('FETCH_SEC = ' || TO_CHAR((V_T2 - V_T1) / 100, 'FM9999990.00'));
    DBMS_OUTPUT.PUT_LINE('TOTAL_SEC = ' || TO_CHAR((V_T2 - V_T0) / 100, 'FM9999990.00'));
END;
/

-- ==============================================================================================================
-- [U4-2] 조회 1회 재실행 PKG_DMF0045.P_DMF0045_GET_SPREAD_TITLE
-- 확인 : PROC_SEC = 프로시저 시간, FETCH_SEC = 결과 읽기 시간, 커서별 행 수
-- ZIOUI1 로그 LOG_SEQ 7046463, 12 ms 호출 값
-- ==============================================================================================================
DECLARE
    V_6          SYS_REFCURSOR;
    V_7          SYS_REFCURSOR;
    V_CUR        INTEGER;
    V_COLS       INTEGER;
    V_DESC       DBMS_SQL.DESC_TAB2;
    V_ROWS       NUMBER;
    V_T0         NUMBER;
    V_T1         NUMBER;
    V_T2         NUMBER;
BEGIN
    V_T0 := DBMS_UTILITY.GET_TIME;
    PKG_DMF0045.P_DMF0045_GET_SPREAD_TITLE(
        P_START_DT => '20261124'
      , P_END_DT => '20270118'
      , P_CREATED_BY => 'minyonglee1'
      , P_SHEET_NAME => 'Pack Biz'
      , P_DIVISION_ID => '81'
      , O_RC1 => V_6
      , O_RESULT_CURSOR => V_7
    );
    V_T1 := DBMS_UTILITY.GET_TIME;
    BEGIN
        V_ROWS := 0;
        V_CUR := DBMS_SQL.TO_CURSOR_NUMBER(V_6);
        DBMS_SQL.DESCRIBE_COLUMNS2(V_CUR, V_COLS, V_DESC);
        WHILE DBMS_SQL.FETCH_ROWS(V_CUR) > 0 LOOP
            V_ROWS := V_ROWS + 1;
        END LOOP;
        DBMS_SQL.CLOSE_CURSOR(V_CUR);
        DBMS_OUTPUT.PUT_LINE('V_6 ROWS = ' || V_ROWS || ' , COLS = ' || V_COLS);
    EXCEPTION
        WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('V_6 열리지 않음 : ' || SQLERRM);
    END;
    BEGIN
        V_ROWS := 0;
        V_CUR := DBMS_SQL.TO_CURSOR_NUMBER(V_7);
        DBMS_SQL.DESCRIBE_COLUMNS2(V_CUR, V_COLS, V_DESC);
        WHILE DBMS_SQL.FETCH_ROWS(V_CUR) > 0 LOOP
            V_ROWS := V_ROWS + 1;
        END LOOP;
        DBMS_SQL.CLOSE_CURSOR(V_CUR);
        DBMS_OUTPUT.PUT_LINE('V_7 ROWS = ' || V_ROWS || ' , COLS = ' || V_COLS);
    EXCEPTION
        WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('V_7 열리지 않음 : ' || SQLERRM);
    END;
    V_T2 := DBMS_UTILITY.GET_TIME;
    DBMS_OUTPUT.PUT_LINE('PROC_SEC  = ' || TO_CHAR((V_T1 - V_T0) / 100, 'FM9999990.00'));
    DBMS_OUTPUT.PUT_LINE('FETCH_SEC = ' || TO_CHAR((V_T2 - V_T1) / 100, 'FM9999990.00'));
    DBMS_OUTPUT.PUT_LINE('TOTAL_SEC = ' || TO_CHAR((V_T2 - V_T0) / 100, 'FM9999990.00'));
END;
/

-- ==============================================================================================================
-- [U4-M1] 실행 중 감시 : 지금 도는 세션, 문장 줄 번호(V$ 권한 필요)
-- [U4-*] 가 끝나지 않을 때만. 재실행 창은 두고 새 접속 창에서 [U0-0] 실행 뒤 실행. 조회만 함
-- 확인 : SRC_LINE 이 회차마다 바뀌는지, STMT_SEC, EVENT, BLOCKING_SESSION
-- 멈추기 : ALTER SYSTEM CANCEL SQL '<SID>, <SERIAL#>'; (DBA 권한, 문장만 취소. 취소된 창에서 [U9] ROLLBACK)
-- ==============================================================================================================
WITH OBJ AS (SELECT /*+ MATERIALIZE */ O.OBJECT_ID FROM ALL_OBJECTS O WHERE O.OWNER = 'SCM_MGR' AND O.OBJECT_NAME IN ('PKG_DMF0045'))
, SES AS (SELECT /*+ MATERIALIZE */ S.SID, S.SERIAL#, S.USERNAME, S.MACHINE, S.STATUS, S.SQL_ID, S.SQL_CHILD_NUMBER, S.SQL_EXEC_START, S.LAST_CALL_ET
                 , S.EVENT, S.WAIT_CLASS, S.BLOCKING_SESSION, S.PLSQL_ENTRY_OBJECT_ID
              FROM V$SESSION S WHERE S.STATUS = 'ACTIVE' AND S.TYPE = 'USER' AND S.SQL_ID IS NOT NULL)
SELECT S.SID
     , S.SERIAL#
     , S.USERNAME
     , S.MACHINE
     , S.SQL_ID
     , (SELECT MAX(O.OBJECT_NAME) FROM ALL_OBJECTS O WHERE O.OBJECT_ID = Q.PROGRAM_ID) AS SRC_OBJECT
     , Q.PROGRAM_LINE# AS SRC_LINE
     , ROUND((SYSDATE - S.SQL_EXEC_START) * 86400) AS STMT_SEC
     , S.LAST_CALL_ET AS CALL_SEC
     , S.EVENT
     , S.WAIT_CLASS
     , S.BLOCKING_SESSION
     , SUBSTR(Q.SQL_TEXT, 1, 80) AS SQL_TEXT
  FROM SES S
  JOIN V$SQL Q
    ON Q.SQL_ID       = S.SQL_ID
   AND Q.CHILD_NUMBER = S.SQL_CHILD_NUMBER
 WHERE Q.PROGRAM_ID IN (SELECT OBJ.OBJECT_ID FROM OBJ)
    OR S.PLSQL_ENTRY_OBJECT_ID IN (SELECT OBJ.OBJECT_ID FROM OBJ)
 ORDER BY S.LAST_CALL_ET DESC;

-- ==============================================================================================================
-- [U4-M2] 실행 중 감시 : 최근 60분 문장 진행 이력
-- [U4-*] 가 끝나지 않을 때만. 재실행 창은 두고 새 접속 창에서 [U0-0] 실행 뒤 실행. 조회만 함
-- 확인 : LAST_ACTIVE 순. 마지막 줄이 지금 단계
-- ==============================================================================================================
SELECT (SELECT MAX(O.OBJECT_NAME) FROM ALL_OBJECTS O WHERE O.OBJECT_ID = Q.PROGRAM_ID) AS SRC_OBJECT
     , Q.PROGRAM_LINE# AS SRC_LINE
     , Q.SQL_ID
     , Q.EXECUTIONS
     , Q.USERS_EXECUTING
     , ROUND(Q.ELAPSED_TIME / 1000000, 2) AS ELAPSED_SEC
     , Q.BUFFER_GETS
     , Q.ROWS_PROCESSED
     , TO_CHAR(Q.LAST_ACTIVE_TIME, 'YYYY-MM-DD HH24:MI:SS') AS LAST_ACTIVE
     , SUBSTR(Q.SQL_TEXT, 1, 60) AS SQL_TEXT
  FROM V$SQL Q
 WHERE Q.PROGRAM_ID IN (SELECT O.OBJECT_ID FROM ALL_OBJECTS O WHERE O.OWNER = 'SCM_MGR' AND O.OBJECT_NAME IN ('PKG_DMF0045'))
   AND Q.LAST_ACTIVE_TIME >= SYSDATE - 1 / 24
 ORDER BY Q.LAST_ACTIVE_TIME;

-- ==============================================================================================================
-- [U4-M3] 실행 중 감시 : 지금 도는 문장 실행계획
-- [U4-*] 가 끝나지 않을 때만. 재실행 창은 두고 새 접속 창에서 [U0-0] 실행 뒤 실행. 조회만 함
-- ==============================================================================================================
SELECT T.PLAN_TABLE_OUTPUT
  FROM (SELECT DISTINCT A.SQL_ID, A.SQL_CHILD_NUMBER FROM (SELECT S.SQL_ID, S.SQL_CHILD_NUMBER FROM V$SESSION S, V$SQL Q WHERE S.SQL_ID = Q.SQL_ID AND S.SQL_CHILD_NUMBER = Q.CHILD_NUMBER AND S.STATUS = 'ACTIVE' AND Q.PROGRAM_ID IN (SELECT O.OBJECT_ID FROM ALL_OBJECTS O WHERE O.OWNER = 'SCM_MGR' AND O.OBJECT_NAME IN ('PKG_DMF0045'))) A) X
     , TABLE(DBMS_XPLAN.DISPLAY_CURSOR(X.SQL_ID, X.SQL_CHILD_NUMBER, 'TYPICAL')) T;

-- ==============================================================================================================
-- [U4-M4] 실행 중 감시 : 오래 걸리는 읽기 진행률
-- [U4-*] 가 끝나지 않을 때만. 재실행 창은 두고 새 접속 창에서 [U0-0] 실행 뒤 실행. 조회만 함
-- 확인 : PCT, TIME_REMAINING
-- ==============================================================================================================
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
   AND L.SID IN (SELECT S.SID FROM V$SESSION S, V$SQL Q WHERE S.SQL_ID = Q.SQL_ID
                    AND S.SQL_CHILD_NUMBER = Q.CHILD_NUMBER AND S.STATUS = 'ACTIVE' AND Q.PROGRAM_ID IN (SELECT O.OBJECT_ID FROM ALL_OBJECTS O WHERE O.OWNER = 'SCM_MGR' AND O.OBJECT_NAME IN ('PKG_DMF0045')))
 ORDER BY L.ELAPSED_SECONDS DESC;

-- ==============================================================================================================
-- [U5] 임시 테이블 건수([U4-*] 직후 같은 세션)
-- 확인 : 단계별 중간 결과 건수. 큰 단계가 느린 단계 후보
-- ==============================================================================================================
SELECT 'GT_DMF0045_BOH' AS GT_NAME, COUNT(*) AS CNT FROM GT_DMF0045_BOH
UNION ALL
SELECT 'GT_DMF0045_ETD' AS GT_NAME, COUNT(*) AS CNT FROM GT_DMF0045_ETD
UNION ALL
SELECT 'GT_DMF0045_LOC' AS GT_NAME, COUNT(*) AS CNT FROM GT_DMF0045_LOC
UNION ALL
SELECT 'GT_DMF0045_MEASURE' AS GT_NAME, COUNT(*) AS CNT FROM GT_DMF0045_MEASURE
UNION ALL
SELECT 'GT_DMF0045_MKT' AS GT_NAME, COUNT(*) AS CNT FROM GT_DMF0045_MKT
UNION ALL
SELECT 'GT_DMF0045_PIVOT' AS GT_NAME, COUNT(*) AS CNT FROM GT_DMF0045_PIVOT
UNION ALL
SELECT 'GT_DMF0045_PLAN' AS GT_NAME, COUNT(*) AS CNT FROM GT_DMF0045_PLAN
UNION ALL
SELECT 'GT_DMF0045_PLAN_FG' AS GT_NAME, COUNT(*) AS CNT FROM GT_DMF0045_PLAN_FG
UNION ALL
SELECT 'GT_DMF0045_REQUESTOR' AS GT_NAME, COUNT(*) AS CNT FROM GT_DMF0045_REQUESTOR
UNION ALL
SELECT 'GT_DMF0045_SAVE' AS GT_NAME, COUNT(*) AS CNT FROM GT_DMF0045_SAVE
UNION ALL
SELECT 'GT_DMF0045_SHIP_REQ' AS GT_NAME, COUNT(*) AS CNT FROM GT_DMF0045_SHIP_REQ
UNION ALL
SELECT 'GT_DMF0045_SHIP_ROW' AS GT_NAME, COUNT(*) AS CNT FROM GT_DMF0045_SHIP_ROW
UNION ALL
SELECT 'GT_DMF0045_STOCK' AS GT_NAME, COUNT(*) AS CNT FROM GT_DMF0045_STOCK;

-- ==============================================================================================================
-- [U6] 패키지 안 문장별 누적 소요(V$ 권한 필요)
-- 확인 : SRC_LINE = 패키지 본문 줄 번호. SEC_PER_EXEC 가 큰 문장
-- ==============================================================================================================
SELECT (SELECT O.OBJECT_NAME FROM ALL_OBJECTS O WHERE O.OBJECT_ID = S.PROGRAM_ID) AS SRC_OBJECT
     , S.PROGRAM_LINE# AS SRC_LINE
     , S.SQL_ID
     , S.CHILD_NUMBER
     , S.EXECUTIONS
     , ROUND(S.ELAPSED_TIME / 1000000, 2) AS ELAPSED_SEC
     , ROUND(S.ELAPSED_TIME / NULLIF(S.EXECUTIONS, 0) / 1000000, 2) AS SEC_PER_EXEC
     , ROUND(S.CPU_TIME / 1000000, 2) AS CPU_SEC
     , S.BUFFER_GETS
     , S.DISK_READS
     , S.ROWS_PROCESSED
     , S.PLAN_HASH_VALUE
     , S.LAST_ACTIVE_TIME
     , SUBSTR(S.SQL_TEXT, 1, 100) AS SQL_TEXT
  FROM V$SQL S
 WHERE S.PROGRAM_ID IN (SELECT O.OBJECT_ID FROM ALL_OBJECTS O WHERE O.OWNER = 'SCM_MGR' AND O.OBJECT_NAME IN ('PKG_DMF0045') AND O.OBJECT_TYPE = 'PACKAGE BODY')
 ORDER BY S.ELAPSED_TIME DESC
 FETCH FIRST 20 ROWS ONLY;

-- ==============================================================================================================
-- [U7] 소요 상위 5문장 실행계획(V$ 권한 필요)
-- 확인 : FULL 읽기, 예상 행 수와 실제 차이
-- ==============================================================================================================
SELECT T.PLAN_TABLE_OUTPUT
  FROM (SELECT S.SQL_ID
             , S.CHILD_NUMBER
          FROM V$SQL S
         WHERE S.PROGRAM_ID IN (SELECT O.OBJECT_ID FROM ALL_OBJECTS O WHERE O.OWNER = 'SCM_MGR' AND O.OBJECT_NAME IN ('PKG_DMF0045') AND O.OBJECT_TYPE = 'PACKAGE BODY')
         ORDER BY S.ELAPSED_TIME DESC
         FETCH FIRST 5 ROWS ONLY) X
     , TABLE(DBMS_XPLAN.DISPLAY_CURSOR(X.SQL_ID, X.CHILD_NUMBER, 'TYPICAL')) T;

-- ==============================================================================================================
-- [U8] 참조 테이블 통계
-- 확인 : STALE_STATS = YES, LAST_ANALYZED 오래된 테이블
-- ==============================================================================================================
SELECT T.TABLE_NAME
     , T.NUM_ROWS
     , T.BLOCKS
     , T.LAST_ANALYZED
     , T.STALE_STATS
  FROM ALL_TAB_STATISTICS T
 WHERE T.OWNER = 'SCM_MGR'
   AND T.OBJECT_TYPE = 'TABLE'
   AND T.TABLE_NAME IN ('DM_PLN_MKT_FCST', 'DM_PLN_SHIPMENT_REQ', 'DM_PLN_SHIPMENT_REQ_H', 'DUAL', 'FP_CELL_INHOUSE_PLAN_H', 'SCM_ADM_LOOKUP_MASTER_DETAIL', 'SCM_ADM_USER_M', 'SCM_ITEM_M', 'SCM_MST_LOCATION', 'SCM_MST_SHEET_COLUMNS', 'SCM_MST_SHEET_MEASURE', 'SCM_MST_SITE', 'SCM_MST_SSO_DEPT_INFO', 'SCM_MST_TITLESET_USER', 'SCM_SYS_CALENDAR_M', 'SCM_SYS_LOG_BATCH', 'SCP_ANL_PRODUCTION_PLAN', 'SCP_MST_BOD', 'SCP_MST_DISTRIBUTION_ROUTE', 'SCP_MST_FINAL_ITEM', 'SSP_ANL_SHIP_CONFIRM', 'SSP_DNM_FP_PLAN_FROZEN', 'SSP_DNM_STOCK_C')
 ORDER BY T.NUM_ROWS DESC NULLS LAST;

-- ==============================================================================================================
-- [U8-1] 10만 행 이상 참조 테이블 인덱스
-- ==============================================================================================================
SELECT C.TABLE_NAME
     , C.INDEX_NAME
     , LISTAGG(C.COLUMN_NAME, ', ') WITHIN GROUP (ORDER BY C.COLUMN_POSITION) AS COLUMNS
     , MAX(I.STATUS) AS STATUS
  FROM ALL_IND_COLUMNS C
  JOIN ALL_INDEXES I
    ON I.OWNER      = C.INDEX_OWNER
   AND I.INDEX_NAME = C.INDEX_NAME
 WHERE C.TABLE_OWNER = 'SCM_MGR'
   AND C.TABLE_NAME IN ('DM_PLN_MKT_FCST', 'DM_PLN_SHIPMENT_REQ', 'DM_PLN_SHIPMENT_REQ_H', 'DUAL', 'FP_CELL_INHOUSE_PLAN_H', 'SCM_ADM_LOOKUP_MASTER_DETAIL', 'SCM_ADM_USER_M', 'SCM_ITEM_M', 'SCM_MST_LOCATION', 'SCM_MST_SHEET_COLUMNS', 'SCM_MST_SHEET_MEASURE', 'SCM_MST_SITE', 'SCM_MST_SSO_DEPT_INFO', 'SCM_MST_TITLESET_USER', 'SCM_SYS_CALENDAR_M', 'SCM_SYS_LOG_BATCH', 'SCP_ANL_PRODUCTION_PLAN', 'SCP_MST_BOD', 'SCP_MST_DISTRIBUTION_ROUTE', 'SCP_MST_FINAL_ITEM', 'SSP_ANL_SHIP_CONFIRM', 'SSP_DNM_FP_PLAN_FROZEN', 'SSP_DNM_STOCK_C')
   AND C.TABLE_NAME IN (SELECT S.TABLE_NAME FROM ALL_TAB_STATISTICS S WHERE S.OWNER = 'SCM_MGR' AND S.NUM_ROWS >= 100000)
 GROUP BY C.TABLE_NAME
        , C.INDEX_NAME
 ORDER BY C.TABLE_NAME
        , C.INDEX_NAME;

-- ==============================================================================================================
-- [U9] 되돌림
-- [U4-*] 에서 사용자 설정 기본행, 임시 테이블 행이 들어갔을 때 되돌림
-- ==============================================================================================================
ROLLBACK;

-- ==============================================================================================================
-- [U9-1] COMMIT 막기 해제
-- ==============================================================================================================
ALTER SESSION ENABLE COMMIT IN PROCEDURE;

