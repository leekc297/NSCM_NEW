-- ============================================================================
-- 91 VERSION_MODAL_ERROR_CHECK — 클라우드 DMF0068 Version 모달 SQL ERROR 점검 (2026-08-06)
--   실행: 클라우드 SCM_MGR (QA·DEV 각각). [0]→[5] 순서 — [0]의 실오류 원문(ORA-코드)이
--   1차 판정 기준이고, 이후 항목이 원인 후보를 각개 격파한다.
--   대상 SP = PKG_DMF0068.P_DMF0068_GET_CONT_VIEW_VERSIONPOPUP (7 IN + 2 OUT)
--   의존 = DM_MDF_VERSION(테이블) / SCM_ADM_USER_MNU_EDIT_AUTH_V(뷰) / PR_SCM_SYS_LOG_BATCH(10-인자판)
--   ⭐ 전 쿼리 사내 OCGSCMD_P01 에서 동일 형태 실측 완료 (dry-run 2026-08-06).
-- ============================================================================

-- ────────────────────────────────────────────────────────────────────────────
-- [0] 실오류 원문 (최우선)
-- ────────────────────────────────────────────────────────────────────────────
-- [0-1] BE SQL 로그: DMF0068 호출 중 EXCEPTION (당일 이후, 최근 50)
SELECT LOG_SEQ, TO_CHAR(EXECUTE_TIME,'MM-DD HH24:MI:SS') AS EXEC_TM, CREATED_BY,
       DBMS_LOB.SUBSTR(SQL_TEXT, 300, 1)  AS SQL_HEAD,
       DBMS_LOB.SUBSTR(EXCEPTION, 500, 1) AS ERR
FROM   SCM_MGR.SCM_COM_SQL_LOG
WHERE  EXECUTE_TIME >= TRUNC(SYSDATE)          -- 당일 이후 (기간 확장 시 이 조건만 조정)
  AND  EXCEPTION IS NOT NULL
  AND  (DBMS_LOB.INSTR(SQL_TEXT,'DMF0068') > 0 OR DBMS_LOB.INSTR(PARAMS,'DMF0068') > 0)
ORDER  BY EXECUTE_TIME DESC
FETCH  FIRST 50 ROWS ONLY;

-- [0-2] BE 시스템 로그: 메뉴 DMF0068 오류 (당일 이후, 최근 50)
SELECT TO_CHAR(CREATION_DATE,'MM-DD HH24:MI:SS') AS TM, MNU_BTN_CD, SHT_NM, CREATED_BY,
       SUBSTR(EXCT_MSG_CTN, 1, 500) AS ERR
FROM   SCM_MGR.SCM_COM_SYS_LOG
WHERE  CREATION_DATE >= TRUNC(SYSDATE)         -- 당일 이후
  AND  MNU_ID = 'DMF0068'
  AND  EXCT_MSG_CTN IS NOT NULL AND TRIM(EXCT_MSG_CTN) IS NOT NULL
ORDER  BY CREATION_DATE DESC
FETCH  FIRST 50 ROWS ONLY;

-- [0-3] SP 내부 배치 로그: VERSIONPOPUP 예외 시 SQLCODE·PARAMS 원문이 여기 남는다 (당일 이후)
SELECT TO_CHAR(EVENT_DATE,'MM-DD HH24:MI:SS') AS TM, PROGRAM_NAME, LOG_TYPE,
       SUBSTR(LOG_MESSAGE,1,120) AS MSG, SQL_ERR_CODE, SUBSTR(SQL_ERR_MSG,1,300) AS ERR,
       SUBSTR(SQL_BACKTRACE,1,200) AS BACKTRACE
FROM   SCM_MGR.SCM_SYS_LOG_BATCH
WHERE  EVENT_DATE >= TRUNC(SYSDATE)            -- 당일 이후
  AND  PROGRAM_NAME LIKE '%DMF0068%'
  AND  (LOG_TYPE IN ('ERR','ERROR','INVALID') OR SQL_ERR_CODE IS NOT NULL)
ORDER  BY EVENT_DATE DESC
FETCH  FIRST 50 ROWS ONLY;

-- ────────────────────────────────────────────────────────────────────────────
-- [1] PKG 상태 (기대: PACKAGE/PACKAGE BODY 전부 VALID, ERRORS 0행)
--     BODY 가 INVALID 인데 호출하면 ORA-04063 이 "SQL ERROR" 로 표출된다
-- ────────────────────────────────────────────────────────────────────────────
SELECT OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI') AS LAST_DDL
FROM   ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0068';

SELECT TYPE, LINE, POSITION, SUBSTR(TEXT,1,200) AS ERR_TEXT
FROM   ALL_ERRORS WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0068' ORDER BY TYPE, SEQUENCE;

-- ────────────────────────────────────────────────────────────────────────────
-- [2] 선행 DDL 적용 확인 (기대: TYPE 2행 VALID / GTT 5행)
-- ────────────────────────────────────────────────────────────────────────────
SELECT OBJECT_NAME, STATUS FROM ALL_OBJECTS
WHERE  OWNER='SCM_MGR' AND OBJECT_TYPE='TYPE'
  AND  OBJECT_NAME IN ('T_DMF0068_ROW','T_DMF0068_TAB') ORDER BY 1;

SELECT TABLE_NAME, TEMPORARY, DURATION FROM ALL_TABLES
WHERE  OWNER='SCM_MGR' AND TABLE_NAME LIKE 'GT_DM68_ORD%' ORDER BY 1;

-- ────────────────────────────────────────────────────────────────────────────
-- [3] SP 의존 객체 (기대: 3행 — TABLE/VIEW/PROCEDURE 각 VALID)
--     PR_SCM_SYS_LOG_BATCH 는 10-인자판 필요 (구판 6-인자만 있으면 BODY 컴파일 오류로 [1]에서 검출)
-- ────────────────────────────────────────────────────────────────────────────
SELECT OBJECT_NAME, OBJECT_TYPE, STATUS FROM ALL_OBJECTS
WHERE  OWNER='SCM_MGR'
  AND  OBJECT_NAME IN ('DM_MDF_VERSION','SCM_ADM_USER_MNU_EDIT_AUTH_V','PR_SCM_SYS_LOG_BATCH')
ORDER  BY 1, 2;

SELECT COUNT(*) AS LOG_BATCH_ARG_CNT
FROM   ALL_ARGUMENTS
WHERE  OWNER='SCM_MGR' AND OBJECT_NAME='PR_SCM_SYS_LOG_BATCH' AND PACKAGE_NAME IS NULL
  AND  DATA_LEVEL=0;                            -- 기대: 10 (사내 실측)

-- ────────────────────────────────────────────────────────────────────────────
-- [4] 메타 배선 (기대: API 1행 / PROC_M 9행 / BTN 1행 / 권한 ≥1행)
--     PROC_M 미적용·행수 상이 = generic call-proc 바인딩 오류 → "SQL ERROR"
-- ────────────────────────────────────────────────────────────────────────────
SELECT API_ID, API_URL, USE_YN FROM SCM_MGR.SCM_ADM_API_M
WHERE  API_ID = 'DMF0068_versionPopup_SEARCH';

SELECT COUNT(*) AS PROC_M_CNT FROM SCM_MGR.SCM_ADM_PROC_M
WHERE  PROC_NM = 'PKG_DMF0068.P_DMF0068_GET_CONT_VIEW_VERSIONPOPUP';   -- 기대 9

SELECT COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD FROM SCM_MGR.SCM_ADM_PROC_M
WHERE  PROC_NM = 'PKG_DMF0068.P_DMF0068_GET_CONT_VIEW_VERSIONPOPUP' ORDER BY TO_NUMBER(SORT_ORD);

SELECT MNU_ID, SHT_NM, MNU_BTN_CD, API_ID, USE_YN FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M
WHERE  MNU_ID='DMF0068' AND SHT_NM='versionPopup';

SELECT COUNT(*) AS AUTH_CNT FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M
WHERE  MNU_ID='DMF0068' AND SHT_NM='versionPopup';

-- ────────────────────────────────────────────────────────────────────────────
-- [5] 데이터 유무 (오류가 아니라 "빈 목록" 인 경우 구분용)
--     기본 조회조건 = VERSION_TYPE 'REPORT_SP_W', 기간 -12~+3개월 (FE 상수)
-- ────────────────────────────────────────────────────────────────────────────
SELECT DIVISION_ID, VERSION_TYPE, COUNT(*) AS CNT
FROM   SCM_MGR.DM_MDF_VERSION
WHERE  SEND_YN <> 'D'
GROUP  BY DIVISION_ID, VERSION_TYPE
ORDER  BY 1, 2;
