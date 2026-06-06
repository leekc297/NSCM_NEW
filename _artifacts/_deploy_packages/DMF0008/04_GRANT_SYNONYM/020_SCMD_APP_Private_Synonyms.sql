--==============================================================================
-- 020_SCMD_APP_Private_Synonyms.sql (DMF0008)
-- 실행: ⚠ SCMD_APP 세션
--==============================================================================
SET SERVEROUTPUT ON
SET LINESIZE 200

PROMPT === BLOCK 1 : DMF0008 SP + 공용 + 종속 synonym ===

DECLARE
  v_ok PLS_INTEGER := 0; v_err PLS_INTEGER := 0;
BEGIN
  FOR r IN (
    SELECT object_name, object_type FROM all_objects
     WHERE owner = 'SCM_MGR'
       AND (object_name LIKE 'DMF0008_%'
            OR object_name IN ('DMF0000_GET_UPDATE_HISTORY', 'PR_DM_DNM_EDI_CALLOFF_STATUS',
                               'UF_FX_STRING_SPLIT', 'PKG_SCM_USER_MNU', 'PR_SCM_SYS_LOG_BATCH',
                               'PKG_DMF0008'))
       AND object_type IN ('PROCEDURE', 'FUNCTION', 'PACKAGE')
  ) LOOP
    BEGIN
      EXECUTE IMMEDIATE 'CREATE OR REPLACE SYNONYM ' || r.object_name || ' FOR SCM_MGR.' || r.object_name;
      v_ok := v_ok + 1;
    EXCEPTION WHEN OTHERS THEN v_err := v_err + 1; END;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('BLOCK 1: OK=' || v_ok || ' ERR=' || v_err);
END;
/

PROMPT === BLOCK 2 : GTT synonym (있다면) ===

DECLARE
  v_ok PLS_INTEGER := 0;
BEGIN
  FOR r IN (
    SELECT table_name FROM all_tables
     WHERE owner = 'SCM_MGR'
       AND (table_name LIKE 'GT_DMF0008%' OR table_name LIKE 'GT_DM_DNM_EDI%')
  ) LOOP
    BEGIN
      EXECUTE IMMEDIATE 'CREATE OR REPLACE SYNONYM ' || r.table_name || ' FOR SCM_MGR.' || r.table_name;
      v_ok := v_ok + 1;
    EXCEPTION WHEN OTHERS THEN NULL; END;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('BLOCK 2 GTT: OK=' || v_ok);
END;
/

PROMPT === BLOCK 3 : 마스터 TABLE synonym ===

DECLARE
  v_ok PLS_INTEGER := 0;
BEGIN
  FOR r IN (
    SELECT table_name FROM all_tables
     WHERE owner = 'SCM_MGR'
       AND table_name IN ('DM_DNM_EDI_REPAIR', 'DM_DNM_EDI_SUMMARY',
                          'SCM_MST_SALES_SITE', 'SCM_MST_SITE_ITEM', 'SCM_MST_SITE',
                          'SCM_ADM_SYS_LOG')
  ) LOOP
    BEGIN
      EXECUTE IMMEDIATE 'CREATE OR REPLACE SYNONYM ' || r.table_name || ' FOR SCM_MGR.' || r.table_name;
      v_ok := v_ok + 1;
    EXCEPTION WHEN OTHERS THEN NULL; END;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('BLOCK 3 MASTER: OK=' || v_ok);
END;
/
