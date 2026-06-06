--==============================================================================
-- 020_SCMD_APP_Private_Synonyms.sql (DMF0072)
-- 실행: ⚠ SCMD_APP 세션
--==============================================================================
SET SERVEROUTPUT ON

PROMPT === BLOCK 1 : DMF0072 SP synonym ===

DECLARE
  v_ok PLS_INTEGER := 0;
BEGIN
  FOR r IN (
    SELECT object_name FROM all_objects
     WHERE owner = 'SCM_MGR'
       AND (object_name LIKE 'DMF0072_%'
            OR object_name IN ('PKG_DMF0072', 'DMF0008_GET_MY_DIVISION_LIST',
                               'UF_FX_STRING_SPLITFORIN', 'UF_FX_STRING_SPLIT',
                               'PKG_SCM_USER_MNU', 'PR_SCM_SYS_LOG_BATCH'))
       AND object_type IN ('PROCEDURE', 'FUNCTION', 'PACKAGE')
  ) LOOP
    BEGIN
      EXECUTE IMMEDIATE 'CREATE OR REPLACE SYNONYM ' || r.object_name || ' FOR SCM_MGR.' || r.object_name;
      v_ok := v_ok + 1;
    EXCEPTION WHEN OTHERS THEN NULL; END;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('BLOCK 1: OK=' || v_ok);
END;
/

PROMPT === BLOCK 2 : 마스터 TABLE synonym ===

DECLARE
  v_ok PLS_INTEGER := 0;
BEGIN
  FOR r IN (
    SELECT table_name FROM all_tables
     WHERE owner = 'SCM_MGR'
       AND table_name IN ('SCM_MST_SITE_ITEM', 'SCM_MST_SITE',
                          'DM_MST_PROJECT', 'DM_MST_ITEM',
                          'SCM_MST_SSO_USER_INFO', 'SCM_MST_SSO_DEPT_INFO',
                          'SCM_ADM_CMBO_SQL_M', 'SCM_ADM_LOOKUP_MASTER_DETAIL')
  ) LOOP
    BEGIN
      EXECUTE IMMEDIATE 'CREATE OR REPLACE SYNONYM ' || r.table_name || ' FOR SCM_MGR.' || r.table_name;
      v_ok := v_ok + 1;
    EXCEPTION WHEN OTHERS THEN NULL; END;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('BLOCK 2 MASTER: OK=' || v_ok);
END;
/
