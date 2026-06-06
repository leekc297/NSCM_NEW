--==============================================================================
-- 010_SCMD_APP_Object_Grants.sql (DMF0072)
--==============================================================================
SET SERVEROUTPUT ON
SET LINESIZE 200

PROMPT === BLOCK 1 : DMF0072 SP + 공용 + 종속 EXECUTE GRANT ===

DECLARE
  v_ok PLS_INTEGER := 0; v_skip PLS_INTEGER := 0; v_err PLS_INTEGER := 0;
BEGIN
  FOR r IN (
    SELECT object_name, object_type FROM all_objects
     WHERE owner = 'SCM_MGR'
       AND (object_name LIKE 'DMF0072_%'
            OR object_name IN ('PKG_DMF0072', 'DMF0008_GET_MY_DIVISION_LIST',
                               'UF_FX_STRING_SPLIT', 'UF_FX_STRING_SPLITFORIN',
                               'PKG_SCM_USER_MNU', 'PR_SCM_SYS_LOG_BATCH'))
       AND object_type IN ('PROCEDURE', 'FUNCTION', 'PACKAGE')
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

PROMPT === BLOCK 2 : 마스터 테이블 SELECT GRANT ===

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
      EXECUTE IMMEDIATE 'GRANT SELECT ON SCM_MGR.' || r.table_name || ' TO SCMD_APP';
      v_ok := v_ok + 1;
    EXCEPTION WHEN OTHERS THEN NULL; END;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('BLOCK 2 MASTER: OK=' || v_ok);
END;
/

COMMIT;
