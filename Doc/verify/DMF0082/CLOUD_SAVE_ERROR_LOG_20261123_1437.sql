-- =====================================================================================
-- DMF0082 Forecast & Price 저장 'Sql Error' 이력 진단 (클라우드 QA, LIVE)
-- 작성 2026-11-23 14:37 · 기준 = 사내 ZIOUI1 SCM_MGR 실측값(아래 [사내] 주석)
--
-- 화면 메시지 'Sql Error'(코드 -9994) = BE GlobalExceptionHandler.sqlException.
--   DB 호출에서 ORA 오류가 나면 이 문구만 화면에 나가고 ORA 원문은 아래 로그 3곳에 남음.
--   ① SCM_MGR.SCM_COM_SYS_LOG   : 요청 1건 = 1행. MNU_ID, SHT_NM, MNU_BTN_CD, EXCT_MSG_CTN(ORA 원문)
--   ② SCM_MGR.SCM_SYS_LOG_BATCH : 저장 SP 가 남기는 단계 로그. 오류 시 SQL_ERR_CODE, SQL_ERR_MSG, SQL_BACKTRACE(줄 번호)
--   ③ SCM_MGR.SCM_COM_SQL_LOG   : BE SQL 로그. 값이 채워진 실제 호출문(SQL_TEXT)과 EXCEPTION
--
-- 저장 버튼 → SP (SCM_ADM_MNU_BTN_MPG_M → SCM_ADM_API_M.API_URL, 사내 2026-11-23 조회)
--   FcstNPrice/fcstNPrice SAVE   → PKG_DMF0082.P_DMF0082_SAVE_MAIN_DATA
--   FcstNPrice UPLOAD, UPLOAD_SAVE → PKG_DMF0082.P_DMF0082_EXCEL_UPLOAD
--   futurePriceInfo SAVE          → PKG_DMF0000.P_DMF0000_SAVE_EXCHANGE_POPUP_DATA
--   futurePriceInfo IF            → PKG_DMF0082.P_PR_SCM_MST_EXCHANGE_RATE_UI
--   titleSet SAVE                 → SCM0002_SET_TITLESET_POPUP
--
-- 사용법
--   1) QA, LIVE 에서 같은 계정으로 접속, DBMS_OUTPUT 켜고 전체 F5 실행
--   2) [3]~[6], [8] 기간은 P_FR(기본 SYSDATE-30), P_TO 만 바꿈. 오류 시각을 알면 앞뒤 1시간으로 좁힘
--   3) [7] SCM_COM_SQL_LOG 는 인덱스가 PK(LOG_SEQ) 1개뿐이고 PARAMS 에 조회 결과 전체가 들어 있음
--      그래서 기간 대신 최근 LOG_SEQ 개수(기본 200000)로 범위를 정함. [7-1] 로 그 범위의 시각을 먼저 확인
--      사내 실측 2026-11-23 14:5x : 200000행 범위 0.51초(2026-11-20 08:50 ~ 11-23 14:51), 전체 5,400,000행 71.92초
--      EXECUTE_TIME 이나 PARAMS 로 전체를 거르면 사내에서 120초 넘게 걸려 중단됨(이 방식은 쓰지 않음)
-- 조회만 함. DML, DDL 없음
-- =====================================================================================

-- [1] 접속 DB, 계정
SELECT SYS_CONTEXT('USERENV','DB_NAME')        AS DB_NAME
     , SYS_CONTEXT('USERENV','CON_NAME')       AS CON_NAME
     , USER                                    AS LOGIN_USER
     , SYS_CONTEXT('USERENV','CURRENT_SCHEMA') AS CUR_SCHEMA
     , SYSDATE                                 AS DB_NOW
  FROM DUAL;

-- [2] 저장 SP 상태, 최종 컴파일 시각, 컴파일 오류
-- [사내] PKG_DMF0082 PACKAGE 2026-11-17 19:46:52 VALID, BODY 2026-11-22 18:00:20 VALID
--        PKG_DMF0000 PACKAGE/BODY 2026-11-17 21:59:10 VALID, SCM0002_SET_TITLESET_POPUP 2026-11-23 14:38:46 VALID
--        ALL_ERRORS 0행
-- 판정: INVALID 이거나 LAST_DDL_TIME 이 오류 시각 직전이면 ORA-04068/04061(패키지 상태 폐기) 후보
SELECT OWNER, OBJECT_NAME, OBJECT_TYPE, STATUS, LAST_DDL_TIME
  FROM ALL_OBJECTS
 WHERE OWNER = 'SCM_MGR'
   AND OBJECT_NAME IN ('PKG_DMF0082','PKG_DMF0000','SCM0002_SET_TITLESET_POPUP'
                      ,'PR_DM_SYS_LOG_BATCH','PR_SCM_SYS_LOG_BATCH')
 ORDER BY OBJECT_NAME, OBJECT_TYPE;

SELECT NAME, TYPE, LINE, POSITION, SUBSTR(TEXT,1,300) AS ERR_TEXT
  FROM ALL_ERRORS
 WHERE OWNER = 'SCM_MGR'
   AND NAME IN ('PKG_DMF0082','PKG_DMF0000','SCM0002_SET_TITLESET_POPUP')
 ORDER BY NAME, TYPE, SEQUENCE;

-- [3] ① SCM_COM_SYS_LOG : DMF0082 저장 계열 요청 건수, 오류 건수 (조회 SEARCH 제외)
-- [사내 30일] FcstNPrice SAVE 1건, titleSet SAVE 5건 등 3행. ERR_CNT 0
-- 판정: ERR_CNT > 0 인 행이 이번 진단 대상
WITH P AS (SELECT SYSDATE - 30 AS P_FR, SYSDATE AS P_TO FROM DUAL)
SELECT L.SHT_NM, L.MNU_BTN_CD
     , COUNT(*)                                                         AS REQ_CNT
     , SUM(CASE WHEN LENGTH(TRIM(L.EXCT_MSG_CTN)) > 0 THEN 1 ELSE 0 END) AS ERR_CNT
     , MIN(L.CREATION_DATE)                                             AS FIRST_AT
     , MAX(L.CREATION_DATE)                                             AS LAST_AT
  FROM SCM_MGR.SCM_COM_SYS_LOG L, P
 WHERE L.MNU_ID = 'DMF0082'
   AND L.LOG_TP_CD IN ('BUTTON','EXCELUPLOAD')
   AND L.MNU_BTN_CD <> 'SEARCH'
   AND L.CREATION_DATE BETWEEN P.P_FR AND P.P_TO
 GROUP BY L.SHT_NM, L.MNU_BTN_CD
 ORDER BY LAST_AT DESC;

-- [4] ① SCM_COM_SYS_LOG : DMF0082 오류 요청 상세 (저장, 조회. 최근 50건)
-- [사내 30일] 0행
-- 읽는 법: EXCT_MSG_CTN 첫 ORA 번호가 원인 분류 기준. 아래 [9] 대조표 참고
--          SYS_LOG_ID(traceId), CREATED_BY, CREATION_DATE 를 [6] 연결 조회에 씀
WITH P AS (SELECT SYSDATE - 30 AS P_FR, SYSDATE AS P_TO FROM DUAL)
SELECT *
  FROM (
        SELECT L.SYS_LOG_ID
             , L.CREATION_DATE
             , L.CREATED_BY
             , L.RQR_CLNT_IP
             , L.SHT_NM
             , L.MNU_BTN_CD
             , L.CALL_PGM_URL
             , ROUND((CAST(L.TRNM_END_DTM AS DATE) - CAST(L.TRNM_ST_DTM AS DATE)) * 86400)        AS SERVER_SEC
             , ROUND((CAST(L.DB_TRNM_END_DTM AS DATE) - CAST(L.DB_TRNM_ST_DTM AS DATE)) * 86400)  AS DB_SEC
             , L.EXCT_MSG_CTN
             , SUBSTR(L.SYS_LOG_MSG_CTN, 1, 2000)                                                AS REQ_PARAMS
          FROM SCM_MGR.SCM_COM_SYS_LOG L, P
         WHERE L.MNU_ID = 'DMF0082'
           AND LENGTH(TRIM(L.EXCT_MSG_CTN)) > 0
           AND L.CREATION_DATE BETWEEN P.P_FR AND P.P_TO
         ORDER BY L.CREATION_DATE DESC
       )
 WHERE ROWNUM <= 50;

-- [5] ② SCM_SYS_LOG_BATCH : 저장 SP 가 남긴 오류, 검증 실패 로그 (최근 100건)
-- PROGRAM_NAME = $$PLSQL_UNIT 이라 패키지명(PKG_DMF0082, PKG_DMF0000)으로 남음
--   LOG_TYPE 'ERROR' + '########## FAIL-1 END ...' = 저장 SP WHEN OTHERS (화면 'Sql Error', RAISE_APPLICATION_ERROR -20001)
--   LOG_TYPE 'END'   + '########## FAIL-2 END ...' = 저장 검증 실패 (화면은 DESCRIPTION 문구, RESULT_CODE 'F'. Sql Error 아님)
--   LOG_TYPE 'E'     + DESCRIPTION 'P_DMF0082_GET_MAIN_DATA ERROR' = 조회 SP 오류 (저장 아님, 비교용으로 같이 나옴)
-- [사내 30일 15행, 2026-11-23 조회]
--   FAIL-2 9건 : 10-24 'Model*: MCP2684B9A20-D01는 Cell Prod Site* 를 Common으로 등록 할 수 없습니다.' 6건,
--                10-24~25 'MKT FCST or RTF or AS_In_Req or SCM_FCST 정보가 해당 주차에 존재하므로 Sales Price 삭제가 불가합니다.' 2건,
--                11-04 hongjae.kim 1건
--   E 6건      : 11-03 ORA-01400 SCM_MST_TITLESET_USER.CREATED_BY 4건, 11-05, 11-09 ORA-03135 2건 (6건 GET_MAIN_DATA)
--   저장 SP FAIL-1(ERROR) 0건. 마지막 저장 2026-11-22 10:52:05 SUCCESS END (qjastar)
-- 읽는 법: SQL_BACKTRACE 의 'line NNNNN' = PKG BODY 줄 번호. [사내] P_DMF0082_SAVE_MAIN_DATA = 24017~27246 줄,
--          P_DMF0082_EXCEL_UPLOAD 끝 = 18295 줄. LIVE 원문 줄 번호는 [2] LAST_DDL_TIME 버전 기준
WITH P AS (SELECT SYSDATE - 30 AS P_FR, SYSDATE AS P_TO FROM DUAL)
SELECT *
  FROM (
        SELECT B.CREATION_DATE
             , B.CREATED_BY
             , B.PROGRAM_NAME
             , B.LOG_TYPE
             , B.LOG_MESSAGE
             , B.LOG_COUNT
             , B.SQL_ERR_CODE
             , B.SQL_ERR_MSG
             , B.SQL_BACKTRACE
             , B.DESCRIPTION
             , B.IN_PARA_DATA
          FROM SCM_MGR.SCM_SYS_LOG_BATCH B, P
         WHERE B.PROGRAM_NAME IN ('PKG_DMF0082','PKG_DMF0000','SCM0002_SET_TITLESET_POPUP')
           AND B.CREATION_DATE BETWEEN P.P_FR AND P.P_TO
           AND (   B.LOG_TYPE IN ('ERROR','E')
                OR B.SQL_ERR_MSG IS NOT NULL
                OR B.LOG_MESSAGE LIKE '%FAIL%')
         ORDER BY B.CREATION_DATE DESC
       )
 WHERE ROWNUM <= 100;

-- [6] ①↔② 연결 : 오류 요청마다 같은 사용자, 같은 시간대의 SP 단계 로그
-- 범위 = 요청 처리 시작(CREATION_DATE - SERVER_SEC - 5초) ~ CREATION_DATE + 5초
-- 판정: SP_LOG_CNT = 0 → SP 본문 진입 전 오류(호출 인자 변환, 패키지 상태 폐기, 권한, 시노님)
--       LAST_STEP 이 '■ N. ...' 단계면 그 단계 다음 문장에서 실패. FAIL-1 행의 SQL_BACKTRACE 로 줄 확인
-- [사내 30일] 0행
WITH P AS (SELECT SYSDATE - 30 AS P_FR, SYSDATE AS P_TO FROM DUAL)
   , E AS (
        SELECT L.SYS_LOG_ID, L.CREATION_DATE, L.CREATED_BY, L.SHT_NM, L.MNU_BTN_CD
             , NVL(ROUND((CAST(L.TRNM_END_DTM AS DATE) - CAST(L.TRNM_ST_DTM AS DATE)) * 86400), 0) AS SERVER_SEC
             , SUBSTR(L.EXCT_MSG_CTN, 1, 500) AS ERR_HEAD
          FROM SCM_MGR.SCM_COM_SYS_LOG L, P
         WHERE L.MNU_ID = 'DMF0082'
           AND L.MNU_BTN_CD <> 'SEARCH'
           AND LENGTH(TRIM(L.EXCT_MSG_CTN)) > 0
           AND L.CREATION_DATE BETWEEN P.P_FR AND P.P_TO
     )
SELECT E.SYS_LOG_ID, E.CREATION_DATE, E.CREATED_BY, E.SHT_NM, E.MNU_BTN_CD, E.SERVER_SEC, E.ERR_HEAD
     , COUNT(B.PROGRAM_NAME)                                                        AS SP_LOG_CNT
     , MAX(B.LOG_MESSAGE) KEEP (DENSE_RANK LAST ORDER BY B.CREATION_DATE, B.LOG_TYPE) AS LAST_STEP
     , MAX(B.SQL_ERR_MSG)                                                           AS SP_ERR_MSG
     , MAX(B.SQL_BACKTRACE)                                                         AS SP_BACKTRACE
  FROM E
  LEFT JOIN SCM_MGR.SCM_SYS_LOG_BATCH B
    ON B.PROGRAM_NAME IN ('PKG_DMF0082','PKG_DMF0000','SCM0002_SET_TITLESET_POPUP')
   AND B.CREATED_BY = E.CREATED_BY
   AND B.CREATION_DATE BETWEEN E.CREATION_DATE - (E.SERVER_SEC + 5) / 86400
                           AND E.CREATION_DATE + 5 / 86400
 GROUP BY E.SYS_LOG_ID, E.CREATION_DATE, E.CREATED_BY, E.SHT_NM, E.MNU_BTN_CD, E.SERVER_SEC, E.ERR_HEAD
 ORDER BY E.CREATION_DATE DESC;

-- [7-1] ③ SCM_COM_SQL_LOG 조회 범위 확인. 최근 LOG_SEQ 200000행이 덮는 시각과 오류 건수
-- [사내 2026-11-23 14:51] 200001행, 오류 58건, 2026-11-20 08:50:36 ~ 2026-11-23 14:51:34, 0.2초
-- 판정: MIN_AT 이 찾는 오류 시각보다 늦으면 아래 [7] 의 200000 을 늘림(전체 = MAX(LOG_SEQ))
--       ERR_CNT = TOTAL_CNT 이면 그 서버는 오류만 남기는 설정(logging-only-error=true). 사내는 false
WITH P AS (SELECT MAX(LOG_SEQ) - 200000 AS P_SEQ FROM SCM_MGR.SCM_COM_SQL_LOG)
SELECT COUNT(*)                                                AS TOTAL_CNT
     , SUM(CASE WHEN X.EXCEPTION IS NOT NULL THEN 1 ELSE 0 END) AS ERR_CNT
     , MIN(X.EXECUTE_TIME)                                     AS MIN_AT
     , MAX(X.EXECUTE_TIME)                                     AS MAX_AT
  FROM SCM_MGR.SCM_COM_SQL_LOG X, P
 WHERE X.LOG_SEQ >= P.P_SEQ;

-- [7] ③ SCM_COM_SQL_LOG : 저장 SP 호출 중 EXCEPTION(Sql Error) 또는 RESULT_CODE 'F'(검증 실패) (최근 50건)
-- K 에서 호출문 앞 120자로 저장 SP 행만 먼저 고르고, 그 행에서만 EXCEPTION, PARAMS 를 읽음
-- CALL_TEXT = 값이 채워진 실제 호출문. 같은 문장을 QA 에서 돌리면 재현됨(저장 SP 안에 COMMIT 있음. LIVE 에서 실행 금지)
-- EXECUTE_TIME 은 BE 서버 시각. [1] DB_NOW 와 시간대 비교
-- [사내 200000행 범위] 0행, 0.51초. 전체 범위(5,400,000)로 바꾸면 12행(12건 RESULT_CODE F, 2026-10-13 ~ 10-15), 71.92초
WITH P AS (SELECT MAX(LOG_SEQ) - 200000 AS P_SEQ FROM SCM_MGR.SCM_COM_SQL_LOG)
   , K AS (SELECT X.LOG_SEQ
             FROM SCM_MGR.SCM_COM_SQL_LOG X, P
            WHERE X.LOG_SEQ >= P.P_SEQ
              AND X.SQL_ID = 'com.lgcns.nscm.callProc'
              AND (   DBMS_LOB.SUBSTR(X.SQL_TEXT, 120, 1) LIKE '%P_DMF0082_SAVE_MAIN_DATA%'
                   OR DBMS_LOB.SUBSTR(X.SQL_TEXT, 120, 1) LIKE '%P_DMF0082_EXCEL_UPLOAD%'
                   OR DBMS_LOB.SUBSTR(X.SQL_TEXT, 120, 1) LIKE '%P_DMF0000_SAVE_EXCHANGE_POPUP_DATA%'
                   OR DBMS_LOB.SUBSTR(X.SQL_TEXT, 120, 1) LIKE '%P_PR_SCM_MST_EXCHANGE_RATE_UI%'
                   OR (    DBMS_LOB.SUBSTR(X.SQL_TEXT, 120, 1) LIKE '%SCM0002_SET_TITLESET_POPUP%'
                       AND DBMS_LOB.SUBSTR(X.SQL_TEXT, 300, 1) LIKE '%DMF0082%'))
              AND ROWNUM > 0)  -- K 를 먼저 끝내게 하는 조건. 지우면 PARAMS 전체를 읽어 사내 120초 초과
SELECT *
  FROM (
        SELECT S.LOG_SEQ
             , S.EXECUTE_TIME
             , S.CREATED_BY
             , S.ELAPSED_MS
             , CASE WHEN S.EXCEPTION IS NOT NULL THEN 'EXCEPTION' ELSE 'RESULT_CODE F' END AS KIND
             , DBMS_LOB.SUBSTR(S.EXCEPTION, 2000, 1) AS EXCEPTION_MSG
             , DBMS_LOB.SUBSTR(S.SQL_TEXT, 3000, 1)  AS CALL_TEXT
             , DBMS_LOB.SUBSTR(S.PARAMS,   1000, 1)  AS PARAMS_HEAD
          FROM K
          JOIN SCM_MGR.SCM_COM_SQL_LOG S
            ON S.LOG_SEQ = K.LOG_SEQ
         WHERE (S.EXCEPTION IS NOT NULL OR DBMS_LOB.INSTR(S.PARAMS, '"RESULT_CODE":"F"') > 0)
         ORDER BY S.LOG_SEQ DESC
       )
 WHERE ROWNUM <= 50;

-- [8] 요약 (DBMS_OUTPUT)
-- [사내 2026-11-23 15:03] 요청 7건 Sql Error 0건 / 저장 SP FAIL-1 0건, 검증 실패 FAIL-2 9건, 조회 SP 오류(E) 6건
SET SERVEROUTPUT ON SIZE UNLIMITED
DECLARE
    v_fr       DATE := SYSDATE - 30;
    v_req      NUMBER;
    v_err      NUMBER;
    v_sp_err   NUMBER;
    v_sp_fail2 NUMBER;
    v_get_err  NUMBER;
    v_last_ok  DATE;
BEGIN
    SELECT COUNT(*), SUM(CASE WHEN LENGTH(TRIM(EXCT_MSG_CTN)) > 0 THEN 1 ELSE 0 END)
      INTO v_req, v_err
      FROM SCM_MGR.SCM_COM_SYS_LOG
     WHERE MNU_ID = 'DMF0082' AND MNU_BTN_CD <> 'SEARCH' AND CREATION_DATE >= v_fr;

    SELECT SUM(CASE WHEN LOG_TYPE = 'ERROR' THEN 1 ELSE 0 END)
         , SUM(CASE WHEN LOG_MESSAGE LIKE '%FAIL-2%' THEN 1 ELSE 0 END)
         , SUM(CASE WHEN LOG_TYPE = 'E' THEN 1 ELSE 0 END)
         , MAX(CASE WHEN LOG_MESSAGE LIKE '%SUCCESS END%' THEN CREATION_DATE END)
      INTO v_sp_err, v_sp_fail2, v_get_err, v_last_ok
      FROM SCM_MGR.SCM_SYS_LOG_BATCH
     WHERE PROGRAM_NAME IN ('PKG_DMF0082','PKG_DMF0000','SCM0002_SET_TITLESET_POPUP') AND CREATION_DATE >= v_fr;

    DBMS_OUTPUT.PUT_LINE('DB=' || SYS_CONTEXT('USERENV','DB_NAME') || ' USER=' || USER || ' NOW=' || TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS'));
    DBMS_OUTPUT.PUT_LINE('최근 30일 DMF0082 저장 계열 요청 ' || NVL(v_req,0) || '건, Sql Error ' || NVL(v_err,0) || '건');
    DBMS_OUTPUT.PUT_LINE('저장 SP FAIL-1 ' || NVL(v_sp_err,0) || '건, 검증 실패 FAIL-2 ' || NVL(v_sp_fail2,0) || '건, 조회 SP 오류 ' || NVL(v_get_err,0) || '건');
    DBMS_OUTPUT.PUT_LINE('마지막 SUCCESS END ' || NVL(TO_CHAR(v_last_ok,'YYYY-MM-DD HH24:MI:SS'),'없음'));
    IF NVL(v_err,0) > 0 AND NVL(v_sp_err,0) = 0 THEN
        DBMS_OUTPUT.PUT_LINE('판정: 요청 오류는 있고 저장 SP 오류 로그 없음. SP 본문 진입 전 실패. [4] EXCT_MSG_CTN 의 ORA 번호 확인');
    ELSIF NVL(v_sp_err,0) > 0 THEN
        DBMS_OUTPUT.PUT_LINE('판정: 저장 SP 안에서 실패. [5] SQL_ERR_MSG, SQL_BACKTRACE 줄 번호 확인');
    ELSIF NVL(v_req,0) = 0 THEN
        DBMS_OUTPUT.PUT_LINE('판정: 저장 요청 기록 없음. 기간(v_fr) 확인');
    ELSE
        DBMS_OUTPUT.PUT_LINE('판정: 기간 안 Sql Error 없음. 기간을 늘리거나 [7] 범위를 늘림');
    END IF;
END;
/

-- =====================================================================================
-- [9] ORA 번호 → 원인 대조표 (EXCT_MSG_CTN, SQL_ERR_MSG, EXCEPTION 첫 ORA 기준)
--   ORA-04068, ORA-04061, ORA-04065 : 저장 직전 PKG 재컴파일로 세션 패키지 상태 폐기. [2] LAST_DDL_TIME 과 오류 시각 비교. 재시도 시 정상이면 확정
--   ORA-06502 문자열 버퍼    : 저장 행 수가 많아 '^' 묶음 값이 변수 길이 초과. [4] REQ_PARAMS 행 수, [5] BACKTRACE 줄 확인
--   ORA-01400, ORA-01407     : NOT NULL 컬럼에 빈 값. [5] DESCRIPTION, IN_PARA_DATA 의 해당 행 값 확인
--   ORA-00001                : 키 중복. [7] CALL_TEXT 의 SITE, ITEM, YYYYMMDD 로 대상 테이블 기존 행 확인
--   ORA-01422, ORA-01427     : 메타 또는 기준 테이블 중복 행(단일 행 조회에 2행 이상). BACKTRACE 줄의 SELECT 대상 확인
--   ORA-00060                : 같은 행 동시 저장 교착. 같은 시각 다른 사용자 저장 여부를 [3] 로 확인
--   ORA-01013, 시간 초과      : BE 조회 시간 제한 초과. [4] SERVER_SEC, DB_SEC 확인
--   ORA-00942, ORA-06550 PLS-00201 : 시노님, 권한 누락. 접속 계정 기준 ALL_SYNONYMS, ALL_TAB_PRIVS 확인
--   ORA-20001                : SP WHEN OTHERS 가 원래 오류를 감싸 다시 던짐. 메시지 뒤 원래 ORA 번호로 위 표 재확인
-- =====================================================================================
