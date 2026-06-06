--==============================================================================
-- 020_SCMD_APP_Private_Synonyms.sql (DMF0043_01)
--
-- 목적: SCMD_APP 가 schema prefix 없이 호출하도록 private synonym 일괄
-- 실행: ⚠ SCMD_APP 세션
-- 작성: 2026-06-05
-- 멱등: CREATE OR REPLACE
--==============================================================================
SET SERVEROUTPUT ON
SET LINESIZE 200

PROMPT === BLOCK 1 : DMF0043 공유 + DMF0043_01 전용 + DMF0002 공용 SP synonym ===

DECLARE
  v_ok PLS_INTEGER := 0; v_err PLS_INTEGER := 0;
BEGIN
  FOR r IN (
    SELECT object_name, object_type FROM all_objects
     WHERE owner = 'SCM_MGR'
       AND object_name IN ('DMF0043_GET_CONTRIBUTION_SALES_LIST',
                           'DMF0043_GET_SALES_LIST_SPREAD_TITLE',
                           'DMF0043_GET_MAIN_VARSION_DATA',
                           'DMF0043_GET_CONTRIBUTE_RATE_POPUP',
                           'DMF0043_GET_CONT_VIEW_VERSIONPOPUP',
                           'DMF0043_GET_MAIN_SPREAD_TITLE',
                           'DMF0002_GET_TITLESET_POPUP',
                           'PKG_DMF0043', 'PKG_DMF0002',
                           'PKG_SCM_USER_MNU', 'PR_SCM_SYS_LOG_BATCH', 'UF_FX_STRING_SPLIT')
       AND object_type IN ('PROCEDURE', 'FUNCTION', 'PACKAGE')
     ORDER BY object_name
  ) LOOP
    BEGIN
      EXECUTE IMMEDIATE 'CREATE OR REPLACE SYNONYM ' || r.object_name || ' FOR SCM_MGR.' || r.object_name;
      v_ok := v_ok + 1; DBMS_OUTPUT.PUT_LINE(RPAD('[OK]', 6) || RPAD(r.object_type, 12) || r.object_name);
    EXCEPTION WHEN OTHERS THEN
      v_err := v_err + 1; DBMS_OUTPUT.PUT_LINE(RPAD('[ERR]', 6) || r.object_name || ' / ' || SQLERRM);
    END;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('BLOCK 1 SYNONYM: OK=' || v_ok || ' ERR=' || v_err);
END;
/

PROMPT === BLOCK 2 : GTT synonym ===

DECLARE
  v_ok PLS_INTEGER := 0; v_err PLS_INTEGER := 0;
BEGIN
  FOR r IN (
    SELECT table_name FROM all_tables
     WHERE owner = 'SCM_MGR'
       AND (table_name LIKE 'GT_DMF0043_%' OR table_name IN ('GT_GMST_TEMP_2', 'GT_GMST_TEMP2_2'))
     ORDER BY table_name
  ) LOOP
    BEGIN
      EXECUTE IMMEDIATE 'CREATE OR REPLACE SYNONYM ' || r.table_name || ' FOR SCM_MGR.' || r.table_name;
      v_ok := v_ok + 1;
    EXCEPTION WHEN OTHERS THEN v_err := v_err + 1; END;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('BLOCK 2 GTT SYNONYM: OK=' || v_ok || ' ERR=' || v_err);
END;
/

PROMPT === BLOCK 3 : 마스터 TABLE synonym ===

DECLARE
  v_ok PLS_INTEGER := 0; v_err PLS_INTEGER := 0;
BEGIN
  FOR r IN (
    SELECT table_name FROM all_tables
     WHERE owner = 'SCM_MGR'
       AND table_name IN (
         'DM_MST_CONTRIBUTE_RATIO_MST', 'DM_MST_CONTRIBUTE_RATIO_DTL', 'DM_MST_CONTRIBUTE_VER',
         'SCM_MST_SITE_ITEM', 'SCM_MST_SITE', 'SCM_MST_SSO_USER_INFO', 'SCM_MST_SSO_DEPT_INFO',
         'SCM_MST_SHEET_COLUMNS', 'SCM_ADM_LOOKUP_MASTER_DETAIL', 'SCM_MST_TITLESET_USER'
       )
  ) LOOP
    BEGIN
      EXECUTE IMMEDIATE 'CREATE OR REPLACE SYNONYM ' || r.table_name || ' FOR SCM_MGR.' || r.table_name;
      v_ok := v_ok + 1;
    EXCEPTION WHEN OTHERS THEN v_err := v_err + 1; END;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('BLOCK 3 MASTER SYNONYM: OK=' || v_ok || ' ERR=' || v_err);
END;
/
