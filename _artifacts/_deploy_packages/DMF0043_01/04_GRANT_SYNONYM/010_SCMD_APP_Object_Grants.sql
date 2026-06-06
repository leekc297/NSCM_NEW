--==============================================================================
-- 010_SCMD_APP_Object_Grants.sql (DMF0043_01)
--
-- 목적: DMF0043_01 가 사용하는 SP/GTT/마스터 모두 SCMD_APP 권한 부여 (포괄적)
-- 실행: SCM_MGR 또는 SYSDBA 세션
-- 작성: 2026-06-05
-- 멱등: BEGIN/EXCEPTION (ORA-01031 / -27486 catch)
--==============================================================================
SET SERVEROUTPUT ON
SET LINESIZE 200

PROMPT === BLOCK 1 : DMF0043 공유 SP + DMF0043_01 전용 SP + DMF0002 공용 + 종속 PKG EXECUTE GRANT ===

DECLARE
  v_ok PLS_INTEGER := 0; v_skip PLS_INTEGER := 0; v_err PLS_INTEGER := 0;
BEGIN
  FOR r IN (
    SELECT object_name, object_type
      FROM all_objects
     WHERE owner = 'SCM_MGR'
       AND (
            object_name IN ('DMF0043_GET_CONTRIBUTION_SALES_LIST',
                            'DMF0043_GET_SALES_LIST_SPREAD_TITLE',
                            'DMF0043_GET_MAIN_VARSION_DATA',
                            'DMF0043_GET_CONTRIBUTE_RATE_POPUP',
                            'DMF0043_GET_CONT_VIEW_VERSIONPOPUP',
                            'DMF0043_GET_MAIN_SPREAD_TITLE',
                            'DMF0002_GET_TITLESET_POPUP',
                            'PKG_DMF0043', 'PKG_DMF0002',
                            'PKG_SCM_USER_MNU', 'PR_SCM_SYS_LOG_BATCH', 'UF_FX_STRING_SPLIT')
       )
       AND object_type IN ('PROCEDURE', 'FUNCTION', 'PACKAGE')
     ORDER BY object_name
  ) LOOP
    BEGIN
      EXECUTE IMMEDIATE 'GRANT EXECUTE ON SCM_MGR.' || r.object_name || ' TO SCMD_APP';
      v_ok := v_ok + 1;
      DBMS_OUTPUT.PUT_LINE(RPAD('[OK]', 6) || RPAD(r.object_type, 12) || r.object_name);
    EXCEPTION WHEN OTHERS THEN
      IF SQLCODE IN (-27486, -1031) THEN v_skip := v_skip + 1;
        DBMS_OUTPUT.PUT_LINE(RPAD('[SKIP]', 6) || RPAD(r.object_type, 12) || r.object_name);
      ELSE v_err := v_err + 1;
        DBMS_OUTPUT.PUT_LINE(RPAD('[ERR]', 6) || RPAD(r.object_type, 12) || r.object_name || ' / ' || SQLERRM);
      END IF;
    END;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('-------------------------------------------');
  DBMS_OUTPUT.PUT_LINE('BLOCK 1 EXECUTE GRANT: OK=' || v_ok || ' SKIP=' || v_skip || ' ERR=' || v_err);
END;
/

PROMPT === BLOCK 2 : DMF0043 GTT 7개 + GT_GMST 2개 GRANT (DMF0043_01 도 공유) ===

DECLARE
  v_ok PLS_INTEGER := 0; v_skip PLS_INTEGER := 0; v_err PLS_INTEGER := 0;
BEGIN
  FOR r IN (
    SELECT table_name FROM all_tables
     WHERE owner = 'SCM_MGR'
       AND (table_name LIKE 'GT_DMF0043_%' OR table_name IN ('GT_GMST_TEMP_2', 'GT_GMST_TEMP2_2'))
     ORDER BY table_name
  ) LOOP
    BEGIN
      EXECUTE IMMEDIATE 'GRANT SELECT, INSERT, UPDATE, DELETE ON SCM_MGR.' || r.table_name || ' TO SCMD_APP';
      v_ok := v_ok + 1; DBMS_OUTPUT.PUT_LINE(RPAD('[OK]', 6) || 'GTT  ' || r.table_name);
    EXCEPTION WHEN OTHERS THEN
      IF SQLCODE IN (-27486, -1031) THEN v_skip := v_skip + 1; ELSE v_err := v_err + 1; END IF;
    END;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('BLOCK 2 GTT DML GRANT: OK=' || v_ok || ' SKIP=' || v_skip || ' ERR=' || v_err);
END;
/

PROMPT === BLOCK 3 : 마스터 테이블 SELECT GRANT ===

DECLARE
  v_ok PLS_INTEGER := 0; v_skip PLS_INTEGER := 0; v_err PLS_INTEGER := 0;
BEGIN
  FOR r IN (
    SELECT table_name FROM all_tables
     WHERE owner = 'SCM_MGR'
       AND table_name IN (
         'DM_MST_CONTRIBUTE_RATIO_MST', 'DM_MST_CONTRIBUTE_RATIO_DTL', 'DM_MST_CONTRIBUTE_VER',
         'SCM_MST_SITE_ITEM', 'SCM_MST_SITE', 'SCM_MST_SSO_USER_INFO', 'SCM_MST_SSO_DEPT_INFO',
         'SCM_MST_SHEET_COLUMNS', 'SCM_ADM_LOOKUP_MASTER_DETAIL', 'SCM_MST_TITLESET_USER'
       )
     ORDER BY table_name
  ) LOOP
    BEGIN
      EXECUTE IMMEDIATE 'GRANT SELECT ON SCM_MGR.' || r.table_name || ' TO SCMD_APP';
      v_ok := v_ok + 1; DBMS_OUTPUT.PUT_LINE(RPAD('[OK]', 6) || 'TBL  ' || r.table_name);
    EXCEPTION WHEN OTHERS THEN
      IF SQLCODE IN (-27486, -1031) THEN v_skip := v_skip + 1; ELSE v_err := v_err + 1; END IF;
    END;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('BLOCK 3 MASTER SELECT GRANT: OK=' || v_ok || ' SKIP=' || v_skip || ' ERR=' || v_err);
END;
/

COMMIT;
