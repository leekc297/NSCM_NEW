--==============================================================================
-- 010_SCMD_APP_Object_Grants.sql (DMF0008)
--==============================================================================
SET SERVEROUTPUT ON
SET LINESIZE 200

PROMPT === BLOCK 1 : DMF0008 SP 9개 + 공용 + 종속 EXECUTE GRANT ===

DECLARE
  v_ok PLS_INTEGER := 0; v_skip PLS_INTEGER := 0; v_err PLS_INTEGER := 0;
BEGIN
  FOR r IN (
    SELECT object_name, object_type FROM all_objects
     WHERE owner = 'SCM_MGR'
       AND (object_name LIKE 'DMF0008_%'
            OR object_name IN ('DMF0000_GET_UPDATE_HISTORY', 'PR_DM_DNM_EDI_CALLOFF_STATUS',
                               'UF_FX_STRING_SPLIT', 'PKG_SCM_USER_MNU', 'PR_SCM_SYS_LOG_BATCH',
                               'PKG_DMF0008'))
       AND object_type IN ('PROCEDURE', 'FUNCTION', 'PACKAGE')
     ORDER BY object_name
  ) LOOP
    BEGIN
      EXECUTE IMMEDIATE 'GRANT EXECUTE ON SCM_MGR.' || r.object_name || ' TO SCMD_APP';
      v_ok := v_ok + 1;
      DBMS_OUTPUT.PUT_LINE(RPAD('[OK]', 6) || RPAD(r.object_type, 12) || r.object_name);
    EXCEPTION WHEN OTHERS THEN
      IF SQLCODE IN (-27486, -1031) THEN v_skip := v_skip + 1; ELSE v_err := v_err + 1; END IF;
    END;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('BLOCK 1: OK=' || v_ok || ' SKIP=' || v_skip || ' ERR=' || v_err);
END;
/

PROMPT === BLOCK 2 : DMF0008 GTT GRANT (있다면) ===

DECLARE
  v_ok PLS_INTEGER := 0; v_skip PLS_INTEGER := 0; v_err PLS_INTEGER := 0;
BEGIN
  FOR r IN (
    SELECT table_name FROM all_tables
     WHERE owner = 'SCM_MGR'
       AND (table_name LIKE 'GT_DMF0008%' OR table_name LIKE 'GT_DM_DNM_EDI%')
  ) LOOP
    BEGIN
      EXECUTE IMMEDIATE 'GRANT SELECT, INSERT, UPDATE, DELETE ON SCM_MGR.' || r.table_name || ' TO SCMD_APP';
      v_ok := v_ok + 1;
    EXCEPTION WHEN OTHERS THEN
      IF SQLCODE IN (-27486, -1031) THEN v_skip := v_skip + 1; ELSE v_err := v_err + 1; END IF;
    END;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('BLOCK 2 GTT: OK=' || v_ok || ' SKIP=' || v_skip || ' ERR=' || v_err);
END;
/

PROMPT === BLOCK 3 : 마스터 테이블 SELECT GRANT ===
-- 정정 2026-06-05 : DM_DNM_EDI_SUMMARY (미존재) → DM_DNM_EDI_CALLOFF_* (실제 source)
-- DMF0008_GET_EDI_MST_SUMMARY body line 89 = FROM DM_DNM_EDI_CALLOFF_ITEM A

DECLARE
  v_ok PLS_INTEGER := 0; v_skip PLS_INTEGER := 0; v_err PLS_INTEGER := 0;
BEGIN
  FOR r IN (
    SELECT table_name FROM all_tables
     WHERE owner = 'SCM_MGR'
       AND table_name IN (
         'DM_DNM_EDI_CALLOFF_ITEM',     -- ⭐ SUMMARY SP 실제 source
         'DM_DNM_EDI_CALLOFF_HEAD',
         'DM_DNM_EDI_CALLOFF_ITEM_C',
         'DM_DNM_EDI_CALLOFF_PARTNER',
         'DM_DNM_FULFILL',
         'SCM_MST_SALES_SITE', 'SCM_MST_SITE_ITEM', 'SCM_MST_SITE',
         'SCM_ADM_SYS_LOG'
       )
  ) LOOP
    BEGIN
      EXECUTE IMMEDIATE 'GRANT SELECT ON SCM_MGR.' || r.table_name || ' TO SCMD_APP';
      v_ok := v_ok + 1;
    EXCEPTION WHEN OTHERS THEN
      IF SQLCODE IN (-27486, -1031) THEN v_skip := v_skip + 1; ELSE v_err := v_err + 1; END IF;
    END;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('BLOCK 3 MASTER: OK=' || v_ok || ' SKIP=' || v_skip || ' ERR=' || v_err);
END;
/

COMMIT;
