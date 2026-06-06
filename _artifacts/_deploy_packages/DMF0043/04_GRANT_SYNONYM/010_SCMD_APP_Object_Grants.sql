--==============================================================================
-- 010_SCMD_APP_Object_Grants.sql
--
-- 목적: DMF0043 관련 모든 SCM_MGR 객체에 대해 SCMD_APP 에게 GRANT 일괄 부여 (포괄적)
--       9 standalone SP + 7 GTT + 종속 PKG/FUNC + UF_FX_STRING_SPLIT
-- 실행: SCM_MGR 세션 또는 SYSDBA (SCMD_APP 자기 자신은 GRANT 불가)
-- 작성: 2026-06-04
-- 멱등: BEGIN/EXCEPTION 으로 이미 GRANT 된 경우 SKIP (ORA-01031 / -27486 catch)
--
-- 관련 룰:
--   - Doc/_dev_rules/11_AUTH_SECURITY.md (권한 룰)
--   - 메모리 feedback_sql_idempotent_insert_all.md (멱등 패턴)
--==============================================================================
SET SERVEROUTPUT ON
SET LINESIZE 200

PROMPT === BLOCK 1 : DMF0043 PROCEDURE 9개 + 종속 PKG/FUNC EXECUTE GRANT ===

DECLARE
  v_cnt_ok   PLS_INTEGER := 0;
  v_cnt_skip PLS_INTEGER := 0;
  v_cnt_err  PLS_INTEGER := 0;
BEGIN
  FOR r IN (
    SELECT object_name, object_type
      FROM all_objects
     WHERE owner = 'SCM_MGR'
       AND (
            (object_name LIKE 'DMF0043_%' AND object_type = 'PROCEDURE')
         OR (object_name IN ('PKG_SCM_USER_MNU', 'PR_SCM_SYS_LOG_BATCH')
             AND object_type IN ('PACKAGE', 'PROCEDURE'))
         OR (object_name = 'UF_FX_STRING_SPLIT' AND object_type = 'FUNCTION')
         OR (object_name = 'DMF0002_GET_TITLESET_POPUP' AND object_type = 'PROCEDURE')
       )
       AND object_type IN ('PROCEDURE', 'FUNCTION', 'PACKAGE')
     ORDER BY object_name
  ) LOOP
    BEGIN
      EXECUTE IMMEDIATE 'GRANT EXECUTE ON SCM_MGR.' || r.object_name || ' TO SCMD_APP';
      v_cnt_ok := v_cnt_ok + 1;
      DBMS_OUTPUT.PUT_LINE(RPAD('[OK]', 6) || RPAD(r.object_type, 12) || r.object_name);
    EXCEPTION
      WHEN OTHERS THEN
        IF SQLCODE IN (-27486, -1031) THEN
          v_cnt_skip := v_cnt_skip + 1;
          DBMS_OUTPUT.PUT_LINE(RPAD('[SKIP]', 6) || RPAD(r.object_type, 12) || r.object_name || ' (already granted or insufficient privilege)');
        ELSE
          v_cnt_err := v_cnt_err + 1;
          DBMS_OUTPUT.PUT_LINE(RPAD('[ERR]', 6) || RPAD(r.object_type, 12) || r.object_name || ' / ' || SQLERRM);
        END IF;
    END;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('--------------------------------------------------------------------------------');
  DBMS_OUTPUT.PUT_LINE('BLOCK 1 EXECUTE GRANT : OK=' || v_cnt_ok || ' / SKIP=' || v_cnt_skip || ' / ERR=' || v_cnt_err);
END;
/

PROMPT === BLOCK 2 : DMF0043 GTT 7개 SELECT/INSERT/UPDATE/DELETE GRANT ===

DECLARE
  v_cnt_ok   PLS_INTEGER := 0;
  v_cnt_skip PLS_INTEGER := 0;
  v_cnt_err  PLS_INTEGER := 0;
BEGIN
  FOR r IN (
    SELECT table_name
      FROM all_tables
     WHERE owner = 'SCM_MGR'
       AND table_name IN (
         'GT_DMF0043_TITLE',
         'GT_DMF0043_TEMP',
         'GT_DMF0043_TEMP2',
         'GT_DMF0043_TEMP3',
         'GT_DMF0043_MASTER_LIST',
         'GT_DMF0043_TEMP_LIST',
         'GT_DMF0043_DATA_TABLE'
       )
     ORDER BY table_name
  ) LOOP
    BEGIN
      EXECUTE IMMEDIATE 'GRANT SELECT, INSERT, UPDATE, DELETE ON SCM_MGR.' || r.table_name || ' TO SCMD_APP';
      v_cnt_ok := v_cnt_ok + 1;
      DBMS_OUTPUT.PUT_LINE(RPAD('[OK]', 6) || 'GTT  ' || r.table_name);
    EXCEPTION
      WHEN OTHERS THEN
        IF SQLCODE IN (-27486, -1031) THEN
          v_cnt_skip := v_cnt_skip + 1;
          DBMS_OUTPUT.PUT_LINE(RPAD('[SKIP]', 6) || 'GTT  ' || r.table_name || ' (already)');
        ELSE
          v_cnt_err := v_cnt_err + 1;
          DBMS_OUTPUT.PUT_LINE(RPAD('[ERR]', 6) || 'GTT  ' || r.table_name || ' / ' || SQLERRM);
        END IF;
    END;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('--------------------------------------------------------------------------------');
  DBMS_OUTPUT.PUT_LINE('BLOCK 2 GTT DML GRANT : OK=' || v_cnt_ok || ' / SKIP=' || v_cnt_skip || ' / ERR=' || v_cnt_err);
END;
/

PROMPT === BLOCK 3 : 마스터 테이블 SELECT GRANT (DMF0043 SP body 가 SELECT 함) ===

DECLARE
  v_cnt_ok   PLS_INTEGER := 0;
  v_cnt_skip PLS_INTEGER := 0;
  v_cnt_err  PLS_INTEGER := 0;
BEGIN
  FOR r IN (
    SELECT table_name
      FROM all_tables
     WHERE owner = 'SCM_MGR'
       AND table_name IN (
         'DM_MST_CONTRIBUTE_RATIO_MST',
         'DM_MST_CONTRIBUTE_RATIO_DTL',
         'DM_MST_CONTRIBUTE_VER',
         'SCM_MST_SITE_ITEM',
         'SCM_MST_SITE',
         'SCM_MST_SSO_USER_INFO',
         'SCM_MST_SSO_DEPT_INFO',
         'SCM_MST_SHEET_COLUMNS',
         'SCM_ADM_LOOKUP_MASTER_DETAIL'
       )
     ORDER BY table_name
  ) LOOP
    BEGIN
      EXECUTE IMMEDIATE 'GRANT SELECT ON SCM_MGR.' || r.table_name || ' TO SCMD_APP';
      v_cnt_ok := v_cnt_ok + 1;
      DBMS_OUTPUT.PUT_LINE(RPAD('[OK]', 6) || 'TBL  ' || r.table_name);
    EXCEPTION
      WHEN OTHERS THEN
        IF SQLCODE IN (-27486, -1031) THEN
          v_cnt_skip := v_cnt_skip + 1;
          DBMS_OUTPUT.PUT_LINE(RPAD('[SKIP]', 6) || 'TBL  ' || r.table_name);
        ELSE
          v_cnt_err := v_cnt_err + 1;
          DBMS_OUTPUT.PUT_LINE(RPAD('[ERR]', 6) || 'TBL  ' || r.table_name || ' / ' || SQLERRM);
        END IF;
    END;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('--------------------------------------------------------------------------------');
  DBMS_OUTPUT.PUT_LINE('BLOCK 3 MASTER SELECT GRANT : OK=' || v_cnt_ok || ' / SKIP=' || v_cnt_skip || ' / ERR=' || v_cnt_err);
END;
/

PROMPT === BLOCK 4 : 종합 검증 — SCMD_APP 가 부여받은 권한 ===

SELECT table_name, privilege, grantor
  FROM all_tab_privs
 WHERE grantee = 'SCMD_APP'
   AND table_schema = 'SCM_MGR'
   AND (   table_name LIKE 'DMF0043_%'
        OR table_name LIKE 'GT_DMF0043_%'
        OR table_name IN ('UF_FX_STRING_SPLIT', 'PKG_SCM_USER_MNU', 'PR_SCM_SYS_LOG_BATCH',
                          'DMF0002_GET_TITLESET_POPUP',
                          'DM_MST_CONTRIBUTE_RATIO_MST', 'DM_MST_CONTRIBUTE_RATIO_DTL',
                          'DM_MST_CONTRIBUTE_VER', 'SCM_MST_SITE_ITEM', 'SCM_MST_SITE',
                          'SCM_MST_SSO_USER_INFO', 'SCM_MST_SSO_DEPT_INFO',
                          'SCM_MST_SHEET_COLUMNS', 'SCM_ADM_LOOKUP_MASTER_DETAIL'))
 ORDER BY table_name, privilege;

COMMIT;
