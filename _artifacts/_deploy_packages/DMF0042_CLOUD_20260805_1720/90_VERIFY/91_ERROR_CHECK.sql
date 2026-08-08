-- ============================================================================
-- 91 ERROR_CHECK — 클라우드 DMF0042 조회 SQL ERROR 원인 점검 (2026-08-06)
--   실행: 클라우드 SCM_MGR (QA·DEV 각각). [0]→[8] 순서로 실행 — [0]의 실오류
--   원문(ORA-코드)이 1차 판정 기준이고, 이후 항목이 원인 후보를 각개 격파한다.
--   조회 경로 SP = PKG_DMF0042.P_DMF0042_GET_DM_PLN_BUSINESS_PLAN_DATA / _GET_SPREAD_TITLE.
-- ============================================================================

-- ────────────────────────────────────────────────────────────────────────────
-- [0] 실오류 원문 (최우선 — 여기서 ORA-코드부터 확보)
-- ────────────────────────────────────────────────────────────────────────────
-- [0-1] BE SQL 로그: DMF0042 호출 중 EXCEPTION 발생분 (당일 이후, 최근 50)
SELECT LOG_SEQ, TO_CHAR(EXECUTE_TIME,'MM-DD HH24:MI:SS') AS EXEC_TM, CREATED_BY,
       DBMS_LOB.SUBSTR(SQL_TEXT, 300, 1)  AS SQL_HEAD,
       DBMS_LOB.SUBSTR(EXCEPTION, 500, 1) AS ERR
FROM   SCM_MGR.SCM_COM_SQL_LOG
WHERE  EXECUTE_TIME >= TRUNC(SYSDATE)          -- 당일 이후 (기간 확장 시 이 조건만 조정)
  AND  EXCEPTION IS NOT NULL
  AND  (DBMS_LOB.INSTR(SQL_TEXT,'DMF0042') > 0 OR DBMS_LOB.INSTR(PARAMS,'DMF0042') > 0)
ORDER  BY EXECUTE_TIME DESC
FETCH  FIRST 50 ROWS ONLY;

-- [0-2] BE 시스템 로그: 메뉴 DMF0042 의 오류 메시지 (당일 이후, 최근 50)
SELECT TO_CHAR(CREATION_DATE,'MM-DD HH24:MI:SS') AS TM, MNU_BTN_CD, SHT_NM, CREATED_BY,
       SUBSTR(EXCT_MSG_CTN, 1, 500) AS ERR
FROM   SCM_MGR.SCM_COM_SYS_LOG
WHERE  CREATION_DATE >= TRUNC(SYSDATE)         -- 당일 이후 (기간 확장 시 이 조건만 조정)
  AND  MNU_ID = 'DMF0042'
  AND  EXCT_MSG_CTN IS NOT NULL AND TRIM(EXCT_MSG_CTN) IS NOT NULL
ORDER  BY CREATION_DATE DESC
FETCH  FIRST 50 ROWS ONLY;

-- [0-3] SP 내부 배치 로그: PKG_DMF0042 계열 ERR/INVALID (당일 이후, 최근 50)
SELECT TO_CHAR(EVENT_DATE,'MM-DD HH24:MI:SS') AS TM, PROGRAM_NAME, LOG_TYPE,
       SUBSTR(LOG_MESSAGE,1,120) AS MSG, SQL_ERR_CODE, SUBSTR(SQL_ERR_MSG,1,300) AS ERR,
       SUBSTR(SQL_BACKTRACE,1,200) AS BACKTRACE
FROM   SCM_MGR.SCM_SYS_LOG_BATCH
WHERE  EVENT_DATE >= TRUNC(SYSDATE)            -- 당일 이후 (기간 확장 시 이 조건만 조정)
  AND  PROGRAM_NAME LIKE '%DMF0042%'
  AND  (LOG_TYPE IN ('ERR','ERROR','INVALID') OR SQL_ERR_CODE IS NOT NULL)
ORDER  BY EVENT_DATE DESC
FETCH  FIRST 50 ROWS ONLY;

-- ────────────────────────────────────────────────────────────────────────────
-- [1] PKG 상태 (기대: PACKAGE/PACKAGE BODY 전부 VALID, ERRORS 0행)
--     INVALID+오류 존재 = 이관물 미적용/의존 결측 — [2]로 원인 특정
-- ────────────────────────────────────────────────────────────────────────────
SELECT OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI') AS LAST_DDL
FROM   ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0042';

SELECT TYPE, LINE, POSITION, SUBSTR(TEXT,1,200) AS ERR_TEXT
FROM   ALL_ERRORS WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0042'
ORDER  BY TYPE, SEQUENCE;

-- ────────────────────────────────────────────────────────────────────────────
-- [2] PKG 의존 객체 자동 점검 (기대: 0행 — 나오는 행 = 결측/INVALID 의존)
--     ORA-00942/PLS-00201 계열의 원샷 특정 (2026-08-05 DMF0020 QA ORA-00942 선례:
--     GTT·뷰·FN 이 QA 미생성 — GTT 자급 의무 계보)
-- ────────────────────────────────────────────────────────────────────────────
SELECT D.REFERENCED_NAME, D.REFERENCED_TYPE,
       NVL(MAX(O.STATUS), '*** MISSING ***') AS STATUS
FROM   ALL_DEPENDENCIES D
LEFT   JOIN ALL_OBJECTS O
  ON   O.OWNER = D.REFERENCED_OWNER AND O.OBJECT_NAME = D.REFERENCED_NAME
WHERE  D.OWNER='SCM_MGR' AND D.NAME='PKG_DMF0042'
  AND  D.REFERENCED_OWNER='SCM_MGR'
  AND  D.REFERENCED_TYPE NOT IN ('PACKAGE')      -- 자기 SPEC 제외
GROUP  BY D.REFERENCED_NAME, D.REFERENCED_TYPE
HAVING NVL(MAX(O.STATUS),'X') <> 'VALID'
ORDER  BY 2, 1;

-- ────────────────────────────────────────────────────────────────────────────
-- [3] GTT 23본 결측 목록 (기대: 0행 — 나오는 이름 = sp/00 재실행 필요)
-- ────────────────────────────────────────────────────────────────────────────
SELECT COLUMN_VALUE AS MISSING_GTT FROM TABLE(SYS.ODCIVARCHAR2LIST(
 'GT_DMF0042_DLT_ITEM_ID','GT_DMF0042_DM_MST_ITEM_SINGLE_A_V','GT_DMF0042_DM_MST_ITEM_SINGLE_B_V',
 'GT_DMF0042_DM_MST_ITEM_SINGLE_ORI_V','GT_DMF0042_DM_MST_ITEM_SINGLE_V','GT_DMF0042_RAW_DATA',
 'GT_DMF0042_RAW_DATA_SUM','GT_DMF0042_SCM_MST_SITE_ITEM','GT_DMF0042_SCM_MST_SSO_USER_INFO',
 'GT_DMF0042_SELECT_MEASURE','GT_SDBE_RESULTS','GT_SDPB_BP_FCST','GT_SDPB_DM_MST_ITEM_SINGLE_A_V',
 'GT_SDPB_DM_MST_ITEM_SINGLE_B_V','GT_SDPB_DM_MST_ITEM_SINGLE_ORI','GT_SDPB_DM_MST_ITEM_SINGLE_V',
 'GT_SDPB_FUTURE_PRICE_TEMP_QTY','GT_SDPB2_BP_FCST_4','GT_SDPB2_DM_PLN_BP_FCST_X_4',
 'GT_SDPBP_FUTURE_PRICE_TEMP0_4','GT_SDPBP_FUTURE_PRICE_TEMP1_2','GT_SDPBP_FUTURE_PRICE_TEMP2_4',
 'GT_SDPBP_FUTURE_PRICE_TEMP3_2'))
WHERE COLUMN_VALUE NOT IN
 (SELECT TABLE_NAME FROM ALL_TABLES WHERE OWNER='SCM_MGR' AND TEMPORARY='Y');

-- ────────────────────────────────────────────────────────────────────────────
-- [4] PROC_M ↔ SP 시그니처 positional 대조 (기대: 0행 — 불일치 행 = sql/03 재적용)
--     불일치 = BE call 문자열이 SP 와 어긋나 PLS-00306/06550 또는 잘못된 바인딩
-- ────────────────────────────────────────────────────────────────────────────
SELECT NVL(P.PROC_NM, 'PKG_DMF0042.' || A.OBJECT_NAME) AS PROC_NM,
       NVL(P.SORT_ORD, A.POSITION) AS ORD,
       P.COL_NM AS PROC_M_COL, A.ARGUMENT_NAME AS SP_ARG,
       CASE WHEN P.COL_NM IS NULL THEN 'PROC_M 결측'
            WHEN A.ARGUMENT_NAME IS NULL THEN 'SP에 없는 PROC_M 행' END AS ISSUE
FROM   (SELECT PROC_NM, COL_NM, SORT_ORD,
               REPLACE(PROC_NM,'PKG_DMF0042.','') AS OBJ
        FROM SCM_MGR.SCM_ADM_PROC_M WHERE PROC_NM LIKE 'PKG_DMF0042.%') P
FULL   OUTER JOIN
       (SELECT OBJECT_NAME, POSITION, ARGUMENT_NAME
        FROM ALL_ARGUMENTS
        WHERE OWNER='SCM_MGR' AND PACKAGE_NAME='PKG_DMF0042' AND ARGUMENT_NAME IS NOT NULL
          AND NVL(OVERLOAD,'1')='1') A   -- PRICE_CONV 내부용 오버로드(BE 미호출) 제외 — 사내 검증 시 오탐 1행
  ON   P.OBJ = A.OBJECT_NAME AND P.SORT_ORD = A.POSITION
WHERE  P.COL_NM IS NULL OR A.ARGUMENT_NAME IS NULL
ORDER  BY 1, 2;

-- ────────────────────────────────────────────────────────────────────────────
-- [5] titleset 'C' 오염 (기대: 0행 — 존재 시 ORA-00960 계보, sql/04 의 DELETE 실행)
--     ⚠ DMF0042 는 SP 측 오염 가드(A2) 미적용 — 오염 row 있으면 조회 즉시 실패 가능
-- ────────────────────────────────────────────────────────────────────────────
SELECT USER_ID, COLUMN_NAME, SORT_ORDER_NO
FROM   SCM_MGR.SCM_MST_TITLESET_USER
WHERE  PROGRAM_ID='DMF0042' AND SHEET_NAME='Biz Plan'
  AND  USER_INQUIRY_COLUMN_TYPE_CODE='C'
  AND  COLUMN_NAME IN ('MEASURE','EDIT_FLAG');

-- [5-2] titleset 'C' 중 SHEET_COLUMNS 미등재 컬럼 (기대: 0행 — 동적 SELECT 오염원)
SELECT U.USER_ID, U.COLUMN_NAME
FROM   SCM_MGR.SCM_MST_TITLESET_USER U
WHERE  U.PROGRAM_ID='DMF0042' AND U.SHEET_NAME='Biz Plan'
  AND  U.USER_INQUIRY_COLUMN_TYPE_CODE='C'
  AND  NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_MST_SHEET_COLUMNS C
                   WHERE C.PROGRAM_ID=U.PROGRAM_ID AND C.SHEET_NAME=U.SHEET_NAME
                     AND C.COLUMN_NAME=U.COLUMN_NAME AND C.VALID_YN='Y');

-- ────────────────────────────────────────────────────────────────────────────
-- [6] 메타 카운트 (기대: MNU 1/API 23/BTN 23/GR_MNU 6/GR_BTN 122/PROC_M 116/SHEET 63·9/CMBO 22)
-- ────────────────────────────────────────────────────────────────────────────
SELECT 'MNU_M' T, COUNT(*) C FROM SCM_MGR.SCM_ADM_MNU_M WHERE MNU_ID='DMF0042'
UNION ALL SELECT 'API_M', COUNT(*) FROM SCM_MGR.SCM_ADM_API_M WHERE API_ID LIKE 'DMF0042%'
UNION ALL SELECT 'BTN_MPG', COUNT(*) FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID='DMF0042'
UNION ALL SELECT 'GR_MNU', COUNT(*) FROM SCM_MGR.SCM_ADM_USER_GR_MNU_MPG_M WHERE MNU_ID='DMF0042'
UNION ALL SELECT 'GR_BTN', COUNT(*) FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M WHERE MNU_ID='DMF0042'
UNION ALL SELECT 'PROC_M', COUNT(*) FROM SCM_MGR.SCM_ADM_PROC_M WHERE PROC_NM LIKE 'PKG_DMF0042.%'
UNION ALL SELECT 'SHEET_COL', COUNT(*) FROM SCM_MGR.SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID='DMF0042'
UNION ALL SELECT 'SHEET_MSR', COUNT(*) FROM SCM_MGR.SCM_MST_SHEET_MEASURE WHERE PROGRAM_ID='DMF0042'
UNION ALL SELECT 'CMBO_22', COUNT(*) FROM SCM_MGR.SCM_ADM_CMBO_SQL_M WHERE SQL_ID IN
 ('BizPlanUserAuthGroup','BizTypeByDivision','BucketType2','CurrencyList','DMF0042CellProdSite',
  'DMF0042CellProdSiteValid','DMF0042_BP_Measure','DeptId','DmBizType','DM_LOOKUP_DIV','EndCustomer',
  'EndCustomerByDivision40','EndCustomerByDivisionDept','FromSiteByDivision','Incoterms','IncotermsEdit',
  'ItemType','MyDivision','PlantSitebyEndCustomer','SiteByEndCustomer','UserSiteByEndCustomer','UserTeamByDivision');

-- ────────────────────────────────────────────────────────────────────────────
-- [7] 공용 의존 6종 (기대: 7행 전부 VALID — PKG_SCM_USER_MNU 는 SPEC+BODY 2행.
--     결측/INVALID = 선행 이관 필요, 룰 22 §9.5. 사내 실측 2026-08-06 = 7행 VALID)
-- ────────────────────────────────────────────────────────────────────────────
SELECT OBJECT_NAME, OBJECT_TYPE, STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME IN
 ('FN_STRING_SPLIT','UF_FX_STRING_SPLITFORIN','FN_GET_DM_MKT_OWNER_NAME',
  'PR_DM_PLN_VERSION_CREATE','PR_SCM_SYS_LOG_BATCH','PKG_SCM_USER_MNU');

-- ────────────────────────────────────────────────────────────────────────────
-- [8] 조회 SP 직접 재현 (조회 전용 — 저장 SP 는 직접 실행 금지)
--     [0]에서 ORA-코드가 안 잡힐 때 SQL*Plus/SQLcl 에서 실행해 오류 재현.
--     division/기간/사용자는 화면과 동일 값으로 치환.
-- ────────────────────────────────────────────────────────────────────────────
-- VAR rc1 REFCURSOR
-- VAR rc2 REFCURSOR
-- EXEC SCM_MGR.PKG_DMF0042.P_DMF0042_GET_SPREAD_TITLE('<FROM_YYYYMMDD>','<TO_YYYYMMDD>','<USER_ID>','<DIVISION>','<USER_ID>','COLUMN',:rc1);
-- EXEC SCM_MGR.PKG_DMF0042.P_DMF0042_GET_DM_PLN_BUSINESS_PLAN_DATA( ... 화면 바인딩 그대로 ..., :rc1, :rc2);
--   ↳ 파라미터 순서는 [4]의 PROC_M(=ALL_ARGUMENTS) 실측 순. BE 로그(SCM_COM_SQL_LOG.SQL_TEXT)의
--     실호출 문자열을 복사해 쓰는 것이 가장 정확.
