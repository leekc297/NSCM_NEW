--==============================================================================
-- 015_DMF0008_Summary_Real_Source_Grant_Fix.sql
--
-- 목적:
--   010_SCMD_APP_Object_Grants.sql 의 BLOCK 3 에 잘못된 테이블명 (DM_DNM_EDI_SUMMARY)
--   가 들어 있어서 실제 source 테이블 (DM_DNM_EDI_CALLOFF_ITEM) 누락.
--   → DMF0008_GET_EDI_MST_SUMMARY 호출 시 EXCEPTION → fallback dummy cursor.
--
-- 사실 (DIAG 1 결과):
--   - DM_DNM_EDI_SUMMARY        : 존재하지 않음 (cloud 전체에 없음 — 010 SQL 의 오류)
--   - DM_DNM_EDI_CALLOFF_ITEM   : 4 owner 에 존재 (SCM_MGR/SCMC/STG_SCM/PRD_SCM_MGR)
--   - SCMD_APP synonym 은 이미 존재. 단 underlying GRANT 누락 가능성.
--
-- 실행: SCM_MGR (또는 system) 계정으로 실행
--
-- 작성: 2026-06-05
--==============================================================================
SET SERVEROUTPUT ON
SET LINESIZE 200

PROMPT === BLOCK 1 : DMF0008_GET_EDI_MST_SUMMARY 실제 source 테이블 SELECT GRANT ===

DECLARE
  v_ok PLS_INTEGER := 0; v_skip PLS_INTEGER := 0; v_err PLS_INTEGER := 0;
  v_msg VARCHAR2(300);
BEGIN
  FOR r IN (
    SELECT table_name FROM all_tables
     WHERE owner = 'SCM_MGR'
       AND table_name IN (
         'DM_DNM_EDI_CALLOFF_ITEM',     -- ⭐ SUMMARY SP 실제 source (line 89)
         'DM_DNM_EDI_CALLOFF_HEAD',     -- 관련 (REPAIR/SSPM 등 사용)
         'DM_DNM_EDI_CALLOFF_ITEM_C',   -- 관련
         'DM_DNM_EDI_CALLOFF_PARTNER',  -- 관련
         'DM_DNM_FULFILL',              -- 관련
         'SCM_MST_SITE'                 -- LEFT OUTER JOIN (line 90)
       )
  ) LOOP
    BEGIN
      EXECUTE IMMEDIATE 'GRANT SELECT ON SCM_MGR.' || r.table_name || ' TO SCMD_APP';
      v_ok := v_ok + 1;
      DBMS_OUTPUT.PUT_LINE(RPAD('[OK SELECT]', 14) || r.table_name);
    EXCEPTION WHEN OTHERS THEN
      v_msg := SUBSTR(SQLERRM, 1, 200);
      IF SQLCODE IN (-27486, -1031) THEN
        v_skip := v_skip + 1;
        DBMS_OUTPUT.PUT_LINE(RPAD('[SKIP]', 14) || r.table_name || ' — ' || v_msg);
      ELSE
        v_err := v_err + 1;
        DBMS_OUTPUT.PUT_LINE(RPAD('[ERR]', 14) || r.table_name || ' — ' || v_msg);
      END IF;
    END;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('BLOCK 1: OK=' || v_ok || ' SKIP=' || v_skip || ' ERR=' || v_err);
END;
/

PROMPT === BLOCK 2 : PKG_SCM_USER_MNU EXECUTE 재확인 (권한 필터 핵심) ===

DECLARE
  v_msg VARCHAR2(300);
BEGIN
  EXECUTE IMMEDIATE 'GRANT EXECUTE ON SCM_MGR.PKG_SCM_USER_MNU TO SCMD_APP';
  DBMS_OUTPUT.PUT_LINE('[OK EXECUTE] PKG_SCM_USER_MNU');
EXCEPTION WHEN OTHERS THEN
  v_msg := SUBSTR(SQLERRM, 1, 200);
  IF SQLCODE IN (-27486, -1031) THEN
    DBMS_OUTPUT.PUT_LINE('[SKIP] PKG_SCM_USER_MNU — ' || v_msg);
  ELSE
    DBMS_OUTPUT.PUT_LINE('[ERR] PKG_SCM_USER_MNU — ' || v_msg);
  END IF;
END;
/

PROMPT === BLOCK 3 : Synonym 존재 + STATUS 확인 ===

SELECT synonym_name, table_owner, table_name, db_link
  FROM all_synonyms
 WHERE owner = 'SCMD_APP'
   AND synonym_name IN (
     'DM_DNM_EDI_CALLOFF_ITEM', 'DM_DNM_EDI_CALLOFF_HEAD',
     'DM_DNM_EDI_CALLOFF_ITEM_C', 'DM_DNM_EDI_CALLOFF_PARTNER',
     'DM_DNM_FULFILL', 'SCM_MST_SITE', 'PKG_SCM_USER_MNU'
   )
 ORDER BY synonym_name;

PROMPT === BLOCK 4 : DBA_TAB_PRIVS 로 실제 grant 확인 ===

SELECT grantee, owner, table_name, privilege, grantor
  FROM dba_tab_privs
 WHERE grantee = 'SCMD_APP'
   AND owner = 'SCM_MGR'
   AND table_name IN (
     'DM_DNM_EDI_CALLOFF_ITEM', 'DM_DNM_EDI_CALLOFF_HEAD',
     'DM_DNM_EDI_CALLOFF_ITEM_C', 'DM_DNM_EDI_CALLOFF_PARTNER',
     'DM_DNM_FULFILL', 'SCM_MST_SITE', 'PKG_SCM_USER_MNU'
   )
 ORDER BY table_name, privilege;

COMMIT;

PROMPT === 다음 단계 ===
PROMPT 1. BLOCK 1 [OK SELECT] 확인 후
PROMPT 2. 130_DMF0008_Summary_EXCEPTION_Capture.sql 재실행
PROMPT 3. DIAG 5 직접 query 가 row > 0 반환 → SP 재호출
PROMPT 4. FE 에서 DMF0008 메뉴 진입 → 조회 (div=81) → grid 데이터 표시 확인
