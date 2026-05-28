-- =============================================================================
-- DMF0007 — Customer PSI Pivot 용 신규 stand-alone SP
-- =============================================================================
-- 대상: Docker Oracle 로컬 (FREEPDB1 / SCM_MGR)
-- 작성: 2026-05-28
-- 의도:
--   기존 PKG_DMF0007.P_DMF0007_GET_CUST_PSI_DATA 의 입력/필터/권한 로직을 유지하되
--   결과 cursor 에 SUMMARY_BUCKET_VALUE 와 SUMMARY_BUCKET_YN 을 포함시켜
--   Wijmo PivotGrid 가 client-side OLAP 으로 사용할 수 있는 long format raw rows 반환.
--
-- 차이점 (vs 기존 PSI SP):
--   - 기존: SUMMARY_BUCKET_VALUE / SUMMARY_BUCKET_YN 미포함
--   - 신규: 둘 다 포함 → PivotGrid 의 columnFields/valueFields 로 사용 가능
--
-- PROC_NM 매핑: 'P_DMF0007_GET_CUST_PSI_PIVOT_DATA' (PKG prefix 없음 — stand-alone)
-- =============================================================================

CREATE OR REPLACE PROCEDURE SCM_MGR.P_DMF0007_GET_CUST_PSI_PIVOT_DATA (
   P_PLAN_WEEK     IN  VARCHAR2
  ,P_DIVISION_ID   IN  VARCHAR2
  ,P_END_CUSTOMER  IN  VARCHAR2
  ,P_SCM_SITE_ID   IN  VARCHAR2
  ,P_BUCKET_TYPE   IN  VARCHAR2
  ,P_VALID_YN      IN  VARCHAR2
  ,P_CREATED_BY    IN  VARCHAR2
  ,P_USER_ID       IN  VARCHAR2
  ,P_MENU_ID       IN  VARCHAR2
  ,O_CURSOR        OUT SYS_REFCURSOR
  ,O_RESULT_CURSOR OUT SYS_REFCURSOR
)
AS
/*============================================================================================================================
 * Program ID   : P_DMF0007_GET_CUST_PSI_PIVOT_DATA
 * Description  : Customer PSI raw rows (long format) - Wijmo PivotGrid 입력용
 * Program History
 *============================================================================================================================
 *   Date       In Charge      Description
 *============================================================================================================================
 * 2026-05-28   minyonglee1    Initial (PKG_DMF0007.P_DMF0007_GET_CUST_PSI_DATA 기반, PIVOT 없이 SUMMARY_BUCKET_VALUE 포함)
 *============================================================================================================================*/
  V_SQL_TEXT          CLOB;
  V_PLAN_WEEK         VARCHAR2(6 CHAR);
  V_GROUP_ID          VARCHAR2(50 CHAR) := '';
  V_ADMIN_CNT         PLS_INTEGER := 0;

  V_PROC_INPUT        VARCHAR2(4000 CHAR);
  V_BACKTRACE         VARCHAR2(4000 CHAR);
  V_SQL_CODE          VARCHAR2(100  CHAR);
  V_SQL_ERRMSG        VARCHAR2(1000 CHAR);
  V_PROGRAM_NAME      VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
BEGIN
  ---------------------------------------------------------------------------------
  -- 권한 그룹 확인 (기존 PSI SP 와 동일 로직)
  ---------------------------------------------------------------------------------
  BEGIN
    SELECT COUNT(1)
      INTO V_ADMIN_CNT
      FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
     WHERE LOOKUP_TYPE = 'GET_ADMIN_GROUP'
       AND VALID_YN = 'Y'
       AND SEGMENT2 = 'ALL'
       AND SEGMENT1 IN ( SELECT DISTINCT USER_GR_ID
                           FROM SCM_MGR.SCM_ADM_USER_GR_UNIT_AUTH_MPG_M A
                          WHERE USER_ID = P_USER_ID
                            AND UNIT_TP_CD = 'D'
                            AND UNIT_ID = P_DIVISION_ID );
  EXCEPTION
    WHEN NO_DATA_FOUND THEN V_ADMIN_CNT := 0;
  END;

  IF V_ADMIN_CNT > 0 THEN V_GROUP_ID := 'ADMIN'; END IF;

  ---------------------------------------------------------------------------------
  -- 당주 PLAN_WEEK 결정 (P_PLAN_WEEK 미지정 시 현재 ISO 주 사용)
  ---------------------------------------------------------------------------------
  IF P_PLAN_WEEK IS NULL OR P_PLAN_WEEK = '' THEN
    SELECT C.ISO_YYYYWW
      INTO V_PLAN_WEEK
      FROM SCM_MGR.SCM_SYS_CALENDAR_M C
     WHERE C.BASIS_YYYYMMDD = TO_CHAR(SYSDATE, 'YYYYMMDD');
  ELSE
    V_PLAN_WEEK := P_PLAN_WEEK;
  END IF;

  ---------------------------------------------------------------------------------
  -- 동적 SQL — PIVOT 없이 raw rows 반환 (SUMMARY_BUCKET_VALUE / SUMMARY_BUCKET_YN 포함)
  ---------------------------------------------------------------------------------
  V_SQL_TEXT := '
  SELECT CF.PLAN_WEEK
       , CF.DIVISION_ID
       , CF.CUSTOMER_CODE
       , CF.SCM_SITE_ID
       , CF.SUMMARY_BUCKET_TYPE
       , CF.SUMMARY_BUCKET_VALUE
       , CF.MEASURE_GROUP
       , CF.MEASURE
       , CF.EDI_FCST_YN
       , CF.CUSTOMER_PSI
       , CF.UPLOAD_UOM
       , CF.UPLOAD_BUCKET_TYPE
       , CF.VALID_YN
       , CASE CF.VALID_YN WHEN ''Y'' THEN ''Y'' ELSE ''N'' END AS SUMMARY_BUCKET_YN
       , CF.LAST_UPDATED_BY
       , CF.LAST_UPDATE_DATE
       , EDY.EDIT_YN
    FROM SCM_MGR.DM_MST_CUSTOMER_FCST CF
         INNER JOIN TABLE(SCM_MGR.PKG_SCM_USER_MNU.PR_SCM_EDIT_YN(''[P_USER_ID]'', ''[P_MENU_ID]'')) EDY
            ON EDY.UNIT_ID = CF.DIVISION_ID
   WHERE 1 = 1
     AND CF.MEASURE_GROUP = ''PSI''
     AND CF.PLAN_WEEK = ''[P_PLAN_WEEK]''
     [P_DIVISION_ID]
     [P_END_CUSTOMER]
     [P_SCM_SITE_ID]
     [P_BUCKET_TYPE]
     [P_VALID_YN]
   ORDER BY CF.DIVISION_ID
          , CF.CUSTOMER_CODE
          , CF.SCM_SITE_ID
          , CF.MEASURE_GROUP
          , CF.MEASURE
          , CF.SUMMARY_BUCKET_VALUE
  ';

  V_SQL_TEXT := REPLACE(V_SQL_TEXT, '[P_PLAN_WEEK]',    V_PLAN_WEEK);
  V_SQL_TEXT := REPLACE(V_SQL_TEXT, '[P_DIVISION_ID]',   SCM_MGR.FN_SCM_GET_WHERE_SQL('CF.DIVISION_ID',         'IN', P_DIVISION_ID ));
  V_SQL_TEXT := REPLACE(V_SQL_TEXT, '[P_END_CUSTOMER]',  SCM_MGR.FN_SCM_GET_WHERE_SQL('CF.CUSTOMER_CODE',       'IN', P_END_CUSTOMER));
  V_SQL_TEXT := REPLACE(V_SQL_TEXT, '[P_SCM_SITE_ID]',   SCM_MGR.FN_SCM_GET_WHERE_SQL('CF.SCM_SITE_ID',         'IN', P_SCM_SITE_ID ));
  V_SQL_TEXT := REPLACE(V_SQL_TEXT, '[P_BUCKET_TYPE]',   SCM_MGR.FN_SCM_GET_WHERE_SQL('CF.SUMMARY_BUCKET_TYPE', 'EQ', P_BUCKET_TYPE ));
  V_SQL_TEXT := REPLACE(V_SQL_TEXT, '[P_VALID_YN]',      SCM_MGR.FN_SCM_GET_WHERE_SQL('CF.VALID_YN',            'EQ', P_VALID_YN    ));
  V_SQL_TEXT := REPLACE(V_SQL_TEXT, '[P_USER_ID]',       P_USER_ID);
  V_SQL_TEXT := REPLACE(V_SQL_TEXT, '[P_MENU_ID]',       P_MENU_ID);

  OPEN O_CURSOR FOR V_SQL_TEXT;

  OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
  WHEN OTHERS THEN
    V_SQL_CODE   := TO_CHAR(SQLCODE);
    V_SQL_ERRMSG := SQLERRM;
    V_PROC_INPUT := JSON_OBJECT(
       'P_PLAN_WEEK'    VALUE P_PLAN_WEEK
      ,'P_DIVISION_ID'  VALUE P_DIVISION_ID
      ,'P_END_CUSTOMER' VALUE P_END_CUSTOMER
      ,'P_SCM_SITE_ID'  VALUE P_SCM_SITE_ID
      ,'P_BUCKET_TYPE'  VALUE P_BUCKET_TYPE
      ,'P_VALID_YN'     VALUE P_VALID_YN
      ,'P_CREATED_BY'   VALUE P_CREATED_BY
      ,'P_USER_ID'      VALUE P_USER_ID
      ,'P_MENU_ID'      VALUE P_MENU_ID
    );
    V_BACKTRACE := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
    RAISE_APPLICATION_ERROR(-20001,
      '[' || V_PROGRAM_NAME || '] SQLCODE=' || V_SQL_CODE ||
      ' / SQLERRM=' || V_SQL_ERRMSG ||
      ' / BACKTRACE=' || V_BACKTRACE ||
      ' / PARAMS=' || V_PROC_INPUT
    );
END P_DMF0007_GET_CUST_PSI_PIVOT_DATA;
/

SHOW ERRORS;
