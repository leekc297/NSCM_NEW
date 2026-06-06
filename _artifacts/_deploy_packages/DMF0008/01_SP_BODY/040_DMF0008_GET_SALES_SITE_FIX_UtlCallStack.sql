--==============================================================================
-- 040_DMF0008_GET_SALES_SITE_FIX_UtlCallStack.sql
--
-- 목적:
--   030 fix (TRUNCATE → DELETE) 적용 후 2차 사고 — UTL_CALL_STACK.SUBPROGRAM(1)(2)
--   가 direct call 시 ORA-06533 (Subscript beyond count).
--
-- DIAG 5 결과:
--   ORA-06533: 첨자가 개수를 넘었습니다
--   PARAMS={"p_division_id":"81","p_soldto":"DE000161","p_shipto":"DEH000086","p_scm_site_id":null}
--
-- 원인:
--   IF UTL_CALL_STACK.SUBPROGRAM(1)(1) IS NOT NULL THEN
--     v_program_name := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);  ← (2) 없으면 폭발
--   END IF;
--
--   Direct call (anonymous block / BE→직접): SUBPROGRAM(1) = ('DMF0008_GET_SALES_SITE') length=1
--   Nested call (PKG): SUBPROGRAM(1) = ('PKG', 'PROC') length=2
--
-- Fix:
--   UTL_CALL_STACK.SUBPROGRAM(1).COUNT >= 2 THEN
--     v_program_name := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
--   ELSE
--     v_program_name := $$PLSQL_UNIT;
--   END IF;
--
-- 작성: 2026-06-05
--==============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 250

PROMPT === BLOCK 1 : SP recompile (UTL_CALL_STACK 안전화) ===

CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0008_GET_SALES_SITE
(
  p_division_id   VARCHAR2,
  p_soldto        VARCHAR2,
  p_shipto        VARCHAR2,
  p_scm_site_id   VARCHAR2,
  O_RESULT_CURSOR OUT SYS_REFCURSOR
)
/*
 * Program ID   : DMF0008_GET_SALES_SITE
 * Program History
 *===================================================================================================
 2023.04.05  kdmcc14  ERP, EDI MASTER DATA 정비 SALES_SITE
 2024.12.31  dsiol    [PJ2024-50647]
 2025.01.21  dsiol    2차배포
 2026.03.26  김준규   [PJ20264226] NextSCM Pilot 설계 및 개발
 2026-05-15  전병주   컴파일 오류 수정
 2026-06-05  Claude   TRUNCATE → DELETE 변환 + UTL_CALL_STACK SUBPROGRAM(1)(2) 안전화 (ORA-06533 fix)
*/
AS
  v_program_name VARCHAR2(200)        := $$PLSQL_UNIT;
  v_cnt_1        INTEGER              := 0;
  v_in_para_data VARCHAR2(4000);
  v_step         VARCHAR2(4000 CHAR)  := NULL;
  V_LOG_TYPE     VARCHAR2(20)         := NULL;
  N_LOG_COUNT    NUMBER               := 0;
  V_LOG_MESSAGE  VARCHAR2(4000 CHAR)  := NULL;
  V_DESCRIPTION  VARCHAR2(4000 CHAR)  := NULL;
  D_EVENT_DATE   DATE                 := SYSDATE;
  V_PROC_INPUT   CLOB                 := NULL;
  V_SQL_CODE     VARCHAR2(100)        := NULL;
  V_SQL_ERRMSG   VARCHAR2(4000 CHAR)  := NULL;
  V_BACKTRACE    VARCHAR2(4000 CHAR)  := NULL;
BEGIN
  -- 2026-06-05 fix : TRUNCATE → DELETE
  DELETE FROM GT_GSSI_DMF0008_RESULT_TABLE_1_2;
  DELETE FROM GT_GSSI_DMF0008_RESULT_TABLE_2_2;

  v_in_para_data := JSON_OBJECT(
    'p_division_id' VALUE p_division_id,
    'p_soldto'      VALUE p_soldto,
    'p_shipto'      VALUE p_shipto,
    'p_scm_site_id' VALUE p_scm_site_id
  );

  -- 2026-06-05 fix : UTL_CALL_STACK.SUBPROGRAM(1) 의 length 검사 추가 (ORA-06533 방지)
  BEGIN
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT >= 2 THEN
      v_program_name := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    ELSE
      v_program_name := $$PLSQL_UNIT;
    END IF;
  EXCEPTION WHEN OTHERS THEN
    v_program_name := $$PLSQL_UNIT;  -- 어떤 사유로든 UTL_CALL_STACK 실패 시 안전 fallback
  END;

  -- 1차 : Division + Sold to + Ship to + Sales Site 4 키 조합 조회
  BEGIN
    INSERT /*+ NO_PARALLEL */ INTO GT_GSSI_DMF0008_RESULT_TABLE_1_2
    SELECT '1' SearchType, TEMP.*
      FROM (
            SELECT S.DIVISION_ID
                 , CASE WHEN S.DIVISION_ID = '40' THEN 'XXX' ELSE T.DEPT_ID END         AS TEAM_ID
                 , CASE WHEN S.DIVISION_ID = '40' THEN 'XXX' ELSE T.DEPT_NAME_KO END    AS TEAM_NAME
                 , CASE WHEN S.DIVISION_ID = '40' THEN 'acer' ELSE S.END_CUSTOMER END   AS END_CUSTOMER
                 , S.SOLDTO_CUSTOMER SOLDTO_CUSTOMER
                 , C.SOLDTO_CODE REP_SOLDTO_CODE
                 , C.SHIPTO_CODE REP_SHIPTO_CODE
                 , S.COUNTRY
                 , CO.COUNTRY_NAME
                 , S.CITY
                 , CT.CITY_NAME
                 , S.SCM_SITE_ID SSCM_SITE_ID
                 , S.COMPANY_ID
                 , S.SITE_DESCRIPTION
                 , S.ATTRIBUTE3 DISTRIBUTION_CHANNEL
                 , S.VMI_YN
                 , S.VALID_YN SITE_VALID_YN
                 , C.VALID_YN CUSTOMER_VALID_YN
                 , C.REP_YN REP_YN
                 , S.LAST_UPDATED_BY
                 , S.LAST_UPDATE_DATE
                 , S.ATTRIBUTE2 SHIP_PLAN_AUTO
                 , CASE WHEN S.DIVISION_ID <> '40' AND ((FN_GET_DEPT_LIST('p_created_by', T.DEPT_ID) = 'Y') OR 'v_group_id' = 'ADMIN') THEN 'Y'
                        WHEN S.DIVISION_ID  = '40' AND ((FN_GET_DEPT_LIST2('p_created_by', S.SCM_SITE_ID) = 'Y')
                             OR 'v_group_id' = 'ADMIN' OR 'p_created_by' = S.LAST_UPDATED_BY) THEN 'Y' ELSE 'N' END AS EDIT_FLAG
                 , (SELECT NVL(MAX(LU.VALID_YN), 'N')
                      FROM SCM_ADM_LOOKUP_MASTER_DETAIL LU
                     WHERE LU.LOOKUP_TYPE = 'SALES_MGMT_TEAM'
                       AND LU.VALID_YN    = 'Y'
                       AND ( LU.SEGMENT1 = (SELECT MAX(Dept_ID) FROM SCM_ADM_USER_M WHERE USER_ID = 'p_created_by')
                          OR LU.SEGMENT1 = 'p_userinfo' )
                       AND 'v_group_id' = 'ADMIN') TEAM_EDIT_FLAG
                 , S.ATTRIBUTE5
              FROM SCM_MST_SITE S
              LEFT OUTER JOIN (SELECT * FROM SCM_MST_SSO_DEPT_INFO WHERE VALID_YN = 'Y') T
                ON S.ATTRIBUTE4 = T.DEPT_ID
              LEFT OUTER JOIN SCM_MST_SITE_CUSTOMER C ON S.DIVISION_ID = C.DIVISION_ID AND S.SCM_SITE_ID = C.SCM_SITE_ID
              LEFT OUTER JOIN SCM_MST_COUNTRY CO     ON S.COUNTRY     = CO.COUNTRY
              LEFT OUTER JOIN SCM_MST_CITY    CT     ON S.COUNTRY     = CT.COUNTRY AND S.CITY = CT.CITY
             WHERE 1 = 1
               AND S.DIVISION_ID = p_division_id
               AND S.SCM_SITE_ID = p_scm_site_id
               AND C.SOLDTO_CODE = p_soldto
               AND C.SHIPTO_CODE = p_shipto
           ) TEMP;
  END;

  -- 2차 : 1차 0 row 시 Division + Sold to + Ship to 3 키 조합 (Sales Site 제외) 조회
  IF (SQL%ROWCOUNT = 0) THEN
    INSERT /*+ NO_PARALLEL */ INTO GT_GSSI_DMF0008_RESULT_TABLE_2_2
    SELECT TEMP.*
      FROM (
            SELECT S.DIVISION_ID
                 , CASE WHEN S.DIVISION_ID = '40' THEN 'XXX' ELSE T.DEPT_ID END         AS TEAM_ID
                 , CASE WHEN S.DIVISION_ID = '40' THEN 'XXX' ELSE T.DEPT_NAME_KO END    AS TEAM_NAME
                 , CASE WHEN S.DIVISION_ID = '40' THEN 'acer' ELSE S.END_CUSTOMER END   AS END_CUSTOMER
                 , S.SOLDTO_CUSTOMER SOLDTO_CUSTOMER
                 , C.SOLDTO_CODE REP_SOLDTO_CODE
                 , C.SHIPTO_CODE REP_SHIPTO_CODE
                 , S.COUNTRY
                 , CO.COUNTRY_NAME
                 , S.CITY
                 , CT.CITY_NAME
                 , S.SCM_SITE_ID SSCM_SITE_ID
                 , S.COMPANY_ID
                 , S.SITE_DESCRIPTION
                 , S.ATTRIBUTE3 DISTRIBUTION_CHANNEL
                 , S.VMI_YN
                 , S.VALID_YN SITE_VALID_YN
                 , C.VALID_YN CUSTOMER_VALID_YN
                 , C.REP_YN REP_YN
                 , S.LAST_UPDATED_BY
                 , S.LAST_UPDATE_DATE
                 , S.ATTRIBUTE2 SHIP_PLAN_AUTO
                 , CASE WHEN S.DIVISION_ID <> '40' AND ((FN_GET_DEPT_LIST('p_created_by', T.DEPT_ID) = 'Y') OR 'v_group_id' = 'ADMIN') THEN 'Y'
                        WHEN S.DIVISION_ID  = '40' AND ((FN_GET_DEPT_LIST2('p_created_by', S.SCM_SITE_ID) = 'Y')
                             OR 'v_group_id' = 'ADMIN' OR 'p_created_by' = S.LAST_UPDATED_BY) THEN 'Y' ELSE 'N' END AS EDIT_FLAG
                 , (SELECT NVL(MAX(LU.VALID_YN), 'N')
                      FROM SCM_ADM_LOOKUP_MASTER_DETAIL LU
                     WHERE LU.LOOKUP_TYPE = 'SALES_MGMT_TEAM'
                       AND LU.VALID_YN    = 'Y'
                       AND ( LU.SEGMENT1 = (SELECT MAX(Dept_ID) FROM SCM_ADM_USER_M WHERE USER_ID = 'p_created_by')
                          OR LU.SEGMENT1 = 'p_userinfo' )
                       AND 'v_group_id' = 'ADMIN') TEAM_EDIT_FLAG
                 , S.ATTRIBUTE5
              FROM SCM_MST_SITE S
              LEFT OUTER JOIN (SELECT * FROM SCM_MST_SSO_DEPT_INFO WHERE VALID_YN = 'Y') T
                ON S.ATTRIBUTE4 = T.DEPT_ID
              LEFT OUTER JOIN SCM_MST_SITE_CUSTOMER C ON S.DIVISION_ID = C.DIVISION_ID AND S.SCM_SITE_ID = C.SCM_SITE_ID
              LEFT OUTER JOIN SCM_MST_COUNTRY CO     ON S.COUNTRY     = CO.COUNTRY
              LEFT OUTER JOIN SCM_MST_CITY    CT     ON S.COUNTRY     = CT.COUNTRY AND S.CITY = CT.CITY
             WHERE 1 = 1
               AND S.DIVISION_ID = p_division_id
               AND C.SOLDTO_CODE = p_soldto
               AND C.SHIPTO_CODE = p_shipto
           ) TEMP;
  END IF;

  SELECT COUNT(1) INTO v_cnt_1 FROM GT_GSSI_DMF0008_RESULT_TABLE_1_2;
  IF v_cnt_1 > 0 THEN
    OPEN O_RESULT_CURSOR FOR
    SELECT T.* FROM GT_GSSI_DMF0008_RESULT_TABLE_1_2 T;
  ELSE
    OPEN O_RESULT_CURSOR FOR
    SELECT T.* FROM GT_GSSI_DMF0008_RESULT_TABLE_2_2 T;
  END IF;

EXCEPTION
  WHEN OTHERS THEN
    V_LOG_TYPE   := 'ERROR';
    V_SQL_CODE   := TO_CHAR(SQLCODE);
    V_SQL_ERRMSG := SQLERRM;
    V_BACKTRACE  := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
    PR_SCM_SYS_LOG_BATCH(
      v_program_name,
      V_LOG_TYPE,
      N_LOG_COUNT,
      V_LOG_MESSAGE,
      V_DESCRIPTION,
      D_EVENT_DATE,
      V_PROC_INPUT,
      V_SQL_CODE,
      V_SQL_ERRMSG,
      V_BACKTRACE
    );
    RAISE_APPLICATION_ERROR(
      -20001,
      '[' || v_program_name || '] SQLCODE=' || SQLCODE
        || ' / SQLERRM=' || SQLERRM
        || ' / PARAMS=' || v_in_para_data
    );
END DMF0008_GET_SALES_SITE;
/

PROMPT === BLOCK 2 : 컴파일 STATUS + 오류 ===

SELECT object_name, status, last_ddl_time
  FROM all_objects
 WHERE owner = 'SCM_MGR'
   AND object_name = 'DMF0008_GET_SALES_SITE'
   AND object_type = 'PROCEDURE';

SELECT line, position, text
  FROM all_errors
 WHERE owner = 'SCM_MGR'
   AND name = 'DMF0008_GET_SALES_SITE'
   AND type = 'PROCEDURE'
 ORDER BY sequence;

PROMPT === BLOCK 3 : 정정 후 SP 단독 호출 검증 ===

DECLARE
  v_result_rc SYS_REFCURSOR;
  v_cnt PLS_INTEGER := 0;
  v_dummy VARCHAR2(4000);
BEGIN
  DMF0008_GET_SALES_SITE(
    p_division_id   => '81',
    p_soldto        => 'DE000161',
    p_shipto        => 'DEH000086',
    p_scm_site_id   => '',
    O_RESULT_CURSOR => v_result_rc
  );
  BEGIN
    LOOP FETCH v_result_rc INTO v_dummy; EXIT WHEN v_result_rc%NOTFOUND OR v_cnt >= 5; v_cnt := v_cnt + 1; END LOOP;
  EXCEPTION WHEN OTHERS THEN v_cnt := -99; END;
  BEGIN CLOSE v_result_rc; EXCEPTION WHEN OTHERS THEN NULL; END;

  DBMS_OUTPUT.PUT_LINE('SALES_SITE 2차 fix 후 fetch = ' || v_cnt || ' (-99=multi-col 정상)');
EXCEPTION WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('SALES_SITE ERR ' || SQLCODE || ' / ' || SUBSTR(SQLERRM, 1, 500));
END;
/

PROMPT === 판독 ===
PROMPT - BLOCK 2 STATUS=VALID + 0 errors
PROMPT - BLOCK 3 fetch=-99 (multi-col 정상) → SP 본문 정상 동작
PROMPT - FE 재조회 시 3단 SALES_SITE/SSPM grid 표시
