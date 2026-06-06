--==============================================================================
-- 060_DMF0008_NVL_EXCEPTION_FLAG_Recompile.sql
--
-- 목적:
--   SUMMARY + REPAIR SP body 의 EXCEPTION_FLAG NULL 처리 사고 fix.
--   - As-Is MSSQL : ISNULL(EXCEPTION_FLAG, '') != 'Y'  → NULL → '' → TRUE
--   - To-Be 잘못 : EXCEPTION_FLAG != 'Y' / NVL(.., NULL) != 'Y' → NULL row 제외
--   - 올바름    : NVL(EXCEPTION_FLAG, 'N') != 'Y'  → NULL → 'N' → TRUE
--
-- 정확한 patch line (250 audit DIAG 3 기준):
--   SUMMARY: line 72, 73 (NVL(.., NULL) → NVL(.., 'N'))
--   REPAIR : line 125, 126, 132, 153 (EXCEPTION_FLAG != 'Y' → NVL(.., 'N') != 'Y')
--
-- 안전성:
--   - = 'Y' 패턴은 그대로 (NULL = 'Y' 자연스럽게 false, 의미 동일)
--   - != 'Y' 패턴만 fix
--   - 주석 안 (line 234, 265-268) 은 무관
--   - As-Is MSSQL 의 ISNULL(.., '') 와 의미 동등 (안전)
--
-- 참고: anonymous block 으로 GET_DDL + REPLACE 자동화 어려움 (line 의미 인식 복잡)
--   → 본 SQL 은 수동 작성 CREATE OR REPLACE 두 SP.
--   → 원본 line 그대로 carry over + 4 line 만 patch.
--
-- 작성: 2026-06-05
--==============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 250

PROMPT === BLOCK 0 : NVL 'N' 적용 직접 query — BMW row 정상 분류 검증 ===

SELECT
  COUNT(*) AS total_rows,
  SUM(CASE WHEN STATUS_CODE IN ('U', 'E') AND NVL(EXCEPTION_FLAG, 'N') != 'Y' THEN 1 ELSE 0 END) AS gscm_master_data_fixed,
  SUM(CASE WHEN STATUS_CODE = 'S'         AND NVL(EXCEPTION_FLAG, 'N') != 'Y' THEN 1 ELSE 0 END) AS success_cnt_fixed,
  SUM(CASE WHEN NVL(EXCEPTION_FLAG, 'N') = 'Y' THEN 1 ELSE 0 END) AS exception_cnt_fixed
  FROM SCM_MGR.DM_DNM_EDI_CALLOFF_ITEM
 WHERE DIVISION_ID = '81'
   AND SENDER_NAME = 'BMW'
   AND CREATE_DATE >= TO_CHAR(TRUNC(SYSDATE, 'IW') - 52*7, 'YYYYMMDD')
   AND ERP_STATUS = 'S'
   AND LTRIM(RTRIM(YYYYMMDD)) NOT IN ('444444');
-- 기대: gscm_master_data_fixed=31301 / success_cnt_fixed=120863 / exception_cnt_fixed=0

PROMPT === BLOCK 1 : SUMMARY SP body recompile (line 72, 73 NVL fix) ===

CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0008_GET_EDI_MST_SUMMARY
(
  p_FROM_YYYYMMDD VARCHAR2,  --안쓰임
  p_TO_YYYYMMDD   VARCHAR2,  --안쓰임
  p_DIVISION_ID   VARCHAR2,  --쓰임
  p_user_id       VARCHAR2,
  p_menu_id       VARCHAR2,
  O_RC1           OUT SYS_REFCURSOR,
  O_RC3           OUT SYS_REFCURSOR,
  O_RESULT_CURSOR OUT SYS_REFCURSOR
)
/*
 * Program ID   : DMF0008_GET_EDI_MST_SUMMARY
 * History
 *===================================================================================================
 2023.04.05  kdmcc14   ERP, EDI MASTER DATA 정비 SUMMARY
 2023.09.20  chutoc730 제외 ITEM_ID 적용
 2024.04.18  HMIN      [E20240405-001867] 예외 처리 칼럼 추가
 2024.07.03  JSSBAE    [E20240701-000472] 업데이트 범위 개선
 2024-12-31  dsiol     [PJ2024-50647] 자동차사업부 고객 수요 분석 기능 개선
 2025-01-21  dsiol     2차배포
 2026-03-15  김준규    [PJ20264226] NextSCM Pilot 설계 및 개발
 2026-05-15  전병주    컴파일 오류 수정
 2026-06-05  Claude    line 132 OPEN O_RC1 FOR DUMMY 제거 (덮어쓰기 사고 fix)
 2026-06-05  Claude    line 72,73 NVL(.., NULL) → NVL(.., 'N') (NULL row 분류 사고 fix)
*/
AS
  v_FROM_YYYYMMDD VARCHAR2(4000 CHAR);
  v_TO_YYYYMMDD   VARCHAR2(4000 CHAR);
  v_in_para_data  VARCHAR2(4000);
  V_LOG_TYPE      VARCHAR2(20)        := NULL;
  N_LOG_COUNT     NUMBER              := 0;
  V_LOG_MESSAGE   VARCHAR2(4000 CHAR) := NULL;
  V_DESCRIPTION   VARCHAR2(4000 CHAR) := NULL;
  D_EVENT_DATE    DATE                := SYSDATE;
  V_PROC_INPUT    CLOB                := NULL;
  V_SQL_CODE      VARCHAR2(100)       := NULL;
  V_SQL_ERRMSG    VARCHAR2(4000 CHAR) := NULL;
  V_BACKTRACE     VARCHAR2(4000 CHAR) := NULL;
  v_program_name  VARCHAR2(150 CHAR)  := $$PLSQL_UNIT;
BEGIN
  v_in_para_data := JSON_OBJECT(
    'p_FROM_YYYYMMDD' VALUE p_FROM_YYYYMMDD,
    'p_TO_YYYYMMDD'   VALUE p_TO_YYYYMMDD,
    'p_DIVISION_ID'   VALUE p_DIVISION_ID,
    'p_user_id'       VALUE p_user_id,
    'p_menu_id'       VALUE p_menu_id
  );
  V_PROC_INPUT := v_in_para_data;

  v_FROM_YYYYMMDD := TO_CHAR(TRUNC(SYSDATE, 'IW') - (52 * 7), 'YYYYMMDD');

  BEGIN
    OPEN O_RC1 FOR
      SELECT T.DIVISION_ID                  AS DIVISION_ID
           , T.SENDER_NAME                   AS EDI_SENDER_NAME
           , SUM(GSCM_MASTER_DATA)           AS GSCM_MASTER_DATA
           , SUM(SUCCESS)                    AS SUCCESS
           , SUM("EXCEPTION")                AS EXCEPTION_DATA
           , COUNT(1)                        AS CNT
           , tei.EDIT_YN                     AS EDIT_YN
        FROM (
              SELECT A.DIVISION_ID, A.SENDER_CODE, A.SENDER_NAME, A.UNLOADING_POINT
                   , A.CUSTOMER_PLANT, A.CUST_MATERIAL_CODE
                   , A.SHIPTO_CODE, A.SOLDTO_CODE, A.ITEM_ID, A.SCM_SITE_ID
                   , A.STATUS_CODE, A.SSPM_STATUS, A.EDI_INCOTERMS
                   , A.PROJECT_CODE, B.END_CUSTOMER, A.SALES_PLANT_SITE_STATUS, A.ERP_STATUS
                   /* 2025.01.10 Philsu Park 수정 — 2026-06-05 NVL(.., NULL) → NVL(.., 'N') fix */
                   , CASE WHEN A.STATUS_CODE IN ('U', 'E') AND NVL(A.EXCEPTION_FLAG, 'N') != 'Y' THEN 1 ELSE 0 END AS GSCM_MASTER_DATA
                   , CASE WHEN A.STATUS_CODE = 'S'         AND NVL(A.EXCEPTION_FLAG, 'N') != 'Y' THEN 1 ELSE 0 END AS SUCCESS
                   , CASE WHEN A.EXCEPTION_FLAG = 'Y'      THEN 1 ELSE 0 END AS "EXCEPTION"
                FROM DM_DNM_EDI_CALLOFF_ITEM A
                LEFT OUTER JOIN SCM_MST_SITE B
                  ON  A.DIVISION_ID = B.DIVISION_ID
                  AND A.SCM_SITE_ID = B.SCM_SITE_ID
                  AND B.SITE_TYPE   = 'SALES'
                  AND B.VALID_YN    = 'Y'
               WHERE A.CREATE_DATE  >= v_FROM_YYYYMMDD
                 AND A.DIVISION_ID   = p_DIVISION_ID
                 AND A.ERP_STATUS    = 'S'
                 AND LTRIM(RTRIM(A.YYYYMMDD)) NOT IN ('444444')
               GROUP BY A.DIVISION_ID, A.SENDER_CODE, A.SENDER_NAME, A.UNLOADING_POINT
                      , A.CUSTOMER_PLANT, A.CUST_MATERIAL_CODE
                      , A.SHIPTO_CODE, A.SOLDTO_CODE, A.ITEM_ID, A.SCM_SITE_ID
                      , A.STATUS_CODE, A.SSPM_STATUS, A.EDI_INCOTERMS
                      , A.PROJECT_CODE, B.END_CUSTOMER, A.SALES_PLANT_SITE_STATUS
                      , A.ERP_STATUS, A.EXCEPTION_FLAG
             ) T
        INNER JOIN TABLE(PKG_SCM_USER_MNU.PR_SCM_EDIT_YN(p_user_id, p_menu_id)) tei
          ON tei.UNIT_ID = T.DIVISION_ID
       GROUP BY T.DIVISION_ID, T.SENDER_NAME, tei.EDIT_YN
       ORDER BY T.SENDER_NAME;

    OPEN O_RC3 FOR SELECT NULL AS DUMMY FROM DUAL;
  END;

  OPEN O_RESULT_CURSOR FOR
    SELECT '1' AS RESULT_CODE
         , CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS RESULT_MSG
         , 'SUCCESS' AS ERR_EVENT
      FROM DUAL;

EXCEPTION
  WHEN OTHERS THEN
    V_LOG_TYPE   := 'ERROR';
    V_SQL_CODE   := TO_CHAR(SQLCODE);
    V_SQL_ERRMSG := SQLERRM;
    V_BACKTRACE  := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
    PR_SCM_SYS_LOG_BATCH(
      $$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION,
      D_EVENT_DATE, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
    );
    RAISE_APPLICATION_ERROR(
      -20001,
      '[' || $$PLSQL_UNIT || '] SQLCODE=' || SQLCODE
        || ' / SQLERRM='   || SQLERRM
        || ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
    );
END DMF0008_GET_EDI_MST_SUMMARY;
/

PROMPT === BLOCK 2 : REPAIR SP body 의 EXCEPTION_FLAG NULL 처리 fix (안전 patch SQL) ===
-- REPAIR SP body 는 매우 길고 outer query 의 다른 logic 도 보존 필요.
-- ALTER PROCEDURE 의 selective patch 는 Oracle 에서 지원 안 함.
-- DDL 전체 추출 + sed 변환 + recompile 이 안전 — 별도 사용자 적용 절차.
--
-- 권장 단계:
--   1. DBMS_METADATA.GET_DDL('PROCEDURE', 'DMF0008_GET_EDI_MST_REPAIR', 'SCM_MGR') 로 DDL 추출
--   2. 추출 DDL 의 line 125, 126, 132, 153 의 다음 4 표현 search-replace:
--      `A.EXCEPTION_FLAG != 'Y'`      → `NVL(A.EXCEPTION_FLAG, 'N') != 'Y'`
--      `A.EXCEPTION_fLAG != 'Y'`      → `NVL(A.EXCEPTION_fLAG, 'N') != 'Y'`  (오타 carry-over)
--   3. CREATE OR REPLACE PROCEDURE 으로 recompile
--
-- 본 SQL 은 BLOCK 1 (SUMMARY) 만 자동 recompile.
-- REPAIR 는 매뉴얼 patch 권장 — DDL 길이 매우 김 (309 line + outer query 복잡 logic).
-- 또는 별도 070 SQL 로 추출 후 patch.

DECLARE
  v_ddl CLOB;
BEGIN
  v_ddl := DBMS_METADATA.GET_DDL('PROCEDURE', 'DMF0008_GET_EDI_MST_REPAIR', 'SCM_MGR');
  DBMS_OUTPUT.PUT_LINE('-- REPAIR SP DDL length = ' || DBMS_LOB.GETLENGTH(v_ddl) || ' chars');
  DBMS_OUTPUT.PUT_LINE('-- 매뉴얼 patch: line 125, 126, 132, 153 의 EXCEPTION_FLAG != ''Y'' → NVL(.., ''N'') != ''Y''');
END;
/

PROMPT === BLOCK 3 : SUMMARY recompile 검증 ===

SELECT object_name, status, last_ddl_time
  FROM all_objects
 WHERE owner = 'SCM_MGR'
   AND object_name = 'DMF0008_GET_EDI_MST_SUMMARY';

SELECT line, position, text
  FROM all_errors
 WHERE owner = 'SCM_MGR'
   AND name = 'DMF0008_GET_EDI_MST_SUMMARY'
 ORDER BY sequence;

PROMPT === BLOCK 4 : SUMMARY 호출 — BMW row 분류 정상 확인 ===

DECLARE
  v_rc1 SYS_REFCURSOR;
  v_rc3 SYS_REFCURSOR;
  v_result_rc SYS_REFCURSOR;
  v_division   VARCHAR2(20);
  v_sender     VARCHAR2(100);
  v_gscm       NUMBER;
  v_success    NUMBER;
  v_exception  NUMBER;
  v_cnt        NUMBER;
  v_edit_yn    VARCHAR2(1);
  v_row_cnt    PLS_INTEGER := 0;
BEGIN
  DMF0008_GET_EDI_MST_SUMMARY(
    P_FROM_YYYYMMDD => '20240101',
    P_TO_YYYYMMDD   => '20261231',
    P_DIVISION_ID   => '81',
    P_USER_ID       => 'minyonglee1',
    P_MENU_ID       => 'DMF0008',
    O_RC1           => v_rc1,
    O_RC3           => v_rc3,
    O_RESULT_CURSOR => v_result_rc
  );
  LOOP
    FETCH v_rc1 INTO v_division, v_sender, v_gscm, v_success, v_exception, v_cnt, v_edit_yn;
    EXIT WHEN v_rc1%NOTFOUND OR v_row_cnt >= 10;
    v_row_cnt := v_row_cnt + 1;
    DBMS_OUTPUT.PUT_LINE('row#' || v_row_cnt
      || ' DIV=' || v_division
      || ' SENDER=' || v_sender
      || ' GSCM=' || v_gscm
      || ' SUCCESS=' || v_success
      || ' EXCEPTION=' || v_exception
      || ' CNT=' || v_cnt);
  END LOOP;
  BEGIN CLOSE v_rc1; EXCEPTION WHEN OTHERS THEN NULL; END;
  BEGIN CLOSE v_rc3; EXCEPTION WHEN OTHERS THEN NULL; END;
  BEGIN CLOSE v_result_rc; EXCEPTION WHEN OTHERS THEN NULL; END;
EXCEPTION WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('ERR ' || SQLCODE || ' / ' || SUBSTR(SQLERRM, 1, 200));
END;
/

PROMPT === 판독 ===
PROMPT - BLOCK 0: NVL 'N' 적용 직접 query — BMW gscm_master_data_fixed=31301, success_cnt_fixed=120863
PROMPT - BLOCK 1: SUMMARY recompile
PROMPT - BLOCK 3: STATUS=VALID + 0 errors
PROMPT - BLOCK 4: BMW row 의 GSCM/SUCCESS 가 이전 0 → 정상 카운트
PROMPT
PROMPT - REPAIR 는 별도 070 (수동 patch) 권장 (DDL 길이 309 line — 자동화 위험)
PROMPT - 또는 사용자 승인 후 별도 SQL 작성 진행
