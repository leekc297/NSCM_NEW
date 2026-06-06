--==============================================================================
-- 020_SCMD_APP_Private_Synonyms.sql
--
-- 목적: SCMD_APP 가 DMF0043_*, GT_DMF0043_*, 종속 객체를 schema prefix 없이 호출할 수 있도록
--       private synonym 일괄 CREATE OR REPLACE
-- 실행: ⚠ SCMD_APP 세션 (자기 schema 에 synonym 생성)
-- 작성: 2026-06-04
-- 멱등: CREATE OR REPLACE (재실행 안전)
--
-- 참고:
--   - 010_SCMD_APP_Object_Grants.sql 가 먼저 적용되어야 함 (EXECUTE/SELECT 권한 우선)
--   - PUBLIC synonym 옵션은 BLOCK 5 주석으로 제공 (DBA 권한 시)
--==============================================================================
SET SERVEROUTPUT ON
SET LINESIZE 200

PROMPT === BLOCK 1 : DMF0043 PROCEDURE / 종속 PKG/FUNC synonym (12개) ===

DECLARE
  v_cnt_ok   PLS_INTEGER := 0;
  v_cnt_err  PLS_INTEGER := 0;
BEGIN
  FOR r IN (
    SELECT object_name, object_type
      FROM all_objects
     WHERE owner = 'SCM_MGR'
       AND (
            (object_name LIKE 'DMF0043_%' AND object_type = 'PROCEDURE')
         OR (object_name IN ('PKG_SCM_USER_MNU', 'PR_SCM_SYS_LOG_BATCH', 'UF_FX_STRING_SPLIT')
             AND object_type IN ('PACKAGE', 'PROCEDURE', 'FUNCTION'))
         OR (object_name = 'DMF0002_GET_TITLESET_POPUP' AND object_type = 'PROCEDURE')
       )
     ORDER BY object_name
  ) LOOP
    BEGIN
      EXECUTE IMMEDIATE 'CREATE OR REPLACE SYNONYM ' || r.object_name || ' FOR SCM_MGR.' || r.object_name;
      v_cnt_ok := v_cnt_ok + 1;
      DBMS_OUTPUT.PUT_LINE(RPAD('[OK]', 6) || RPAD(r.object_type, 12) || r.object_name);
    EXCEPTION WHEN OTHERS THEN
      v_cnt_err := v_cnt_err + 1;
      DBMS_OUTPUT.PUT_LINE(RPAD('[ERR]', 6) || RPAD(r.object_type, 12) || r.object_name || ' / ' || SQLERRM);
    END;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('--------------------------------------------------------------------------------');
  DBMS_OUTPUT.PUT_LINE('BLOCK 1 PROCEDURE/PKG/FUNC SYNONYM : OK=' || v_cnt_ok || ' / ERR=' || v_cnt_err);
END;
/

PROMPT === BLOCK 2 : DMF0043 GTT 7개 synonym ===

DECLARE
  v_cnt_ok   PLS_INTEGER := 0;
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
      EXECUTE IMMEDIATE 'CREATE OR REPLACE SYNONYM ' || r.table_name || ' FOR SCM_MGR.' || r.table_name;
      v_cnt_ok := v_cnt_ok + 1;
      DBMS_OUTPUT.PUT_LINE(RPAD('[OK]', 6) || 'GTT  ' || r.table_name);
    EXCEPTION WHEN OTHERS THEN
      v_cnt_err := v_cnt_err + 1;
      DBMS_OUTPUT.PUT_LINE(RPAD('[ERR]', 6) || 'GTT  ' || r.table_name || ' / ' || SQLERRM);
    END;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('--------------------------------------------------------------------------------');
  DBMS_OUTPUT.PUT_LINE('BLOCK 2 GTT SYNONYM : OK=' || v_cnt_ok || ' / ERR=' || v_cnt_err);
END;
/

PROMPT === BLOCK 3 : 마스터 TABLE synonym (DMF0043 SP 가 직접 SELECT 하는 객체) ===

DECLARE
  v_cnt_ok   PLS_INTEGER := 0;
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
      EXECUTE IMMEDIATE 'CREATE OR REPLACE SYNONYM ' || r.table_name || ' FOR SCM_MGR.' || r.table_name;
      v_cnt_ok := v_cnt_ok + 1;
      DBMS_OUTPUT.PUT_LINE(RPAD('[OK]', 6) || 'TBL  ' || r.table_name);
    EXCEPTION WHEN OTHERS THEN
      v_cnt_err := v_cnt_err + 1;
      DBMS_OUTPUT.PUT_LINE(RPAD('[ERR]', 6) || 'TBL  ' || r.table_name || ' / ' || SQLERRM);
    END;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('--------------------------------------------------------------------------------');
  DBMS_OUTPUT.PUT_LINE('BLOCK 3 MASTER SYNONYM : OK=' || v_cnt_ok || ' / ERR=' || v_cnt_err);
END;
/

PROMPT === BLOCK 4 : 검증 — SCMD_APP 의 USER_SYNONYMS ===

SELECT synonym_name, table_owner, table_name
  FROM user_synonyms
 WHERE table_name LIKE 'DMF0043_%'
    OR table_name LIKE 'GT_DMF0043_%'
    OR synonym_name IN (
       'UF_FX_STRING_SPLIT', 'PKG_SCM_USER_MNU', 'PR_SCM_SYS_LOG_BATCH', 'DMF0002_GET_TITLESET_POPUP',
       'DM_MST_CONTRIBUTE_RATIO_MST', 'DM_MST_CONTRIBUTE_RATIO_DTL', 'DM_MST_CONTRIBUTE_VER',
       'SCM_MST_SITE_ITEM', 'SCM_MST_SITE', 'SCM_MST_SSO_USER_INFO', 'SCM_MST_SSO_DEPT_INFO',
       'SCM_MST_SHEET_COLUMNS', 'SCM_ADM_LOOKUP_MASTER_DETAIL'
   )
 ORDER BY synonym_name;

PROMPT === BLOCK 5 (선택) : PUBLIC SYNONYM 옵션 — DBA 권한 시에만 ===
PROMPT 모든 사용자에게 노출하려면 다음 패턴 (BLOCK 1~3 의 EXECUTE IMMEDIATE 를 다음으로 교체):
PROMPT   EXECUTE IMMEDIATE 'CREATE OR REPLACE PUBLIC SYNONYM ' || obj_name || ' FOR SCM_MGR.' || obj_name;
PROMPT 보안 정책 확인 후 운영팀 결정 따라 적용
