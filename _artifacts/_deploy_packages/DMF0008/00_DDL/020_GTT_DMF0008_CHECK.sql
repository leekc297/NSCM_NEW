--==============================================================================
-- 020_GTT_DMF0008_CHECK.sql
--
-- 목적: DMF0008 GTT (있다면) 인벤토리
-- 작성: 2026-06-05
--==============================================================================
SET LINESIZE 200
SET SERVEROUTPUT ON

PROMPT === DIAG 1 : DMF0008 / DMF0000 GTT 인벤토리 ===

SELECT table_name, temporary, duration
  FROM all_tables
 WHERE owner = 'SCM_MGR'
   AND (table_name LIKE 'GT_DMF0008%' OR table_name LIKE 'GT_DM_DNM_EDI%')
 ORDER BY table_name;

PROMPT === DIAG 2 : SCMD_APP 권한 ===

SELECT table_name, grantee, privilege
  FROM all_tab_privs
 WHERE table_schema = 'SCM_MGR'
   AND grantee = 'SCMD_APP'
   AND (table_name LIKE 'GT_DMF0008%' OR table_name LIKE 'GT_DM_DNM_EDI%')
 ORDER BY table_name, privilege;

PROMPT === 판독 ===
PROMPT - DIAG 1 row 0 → DMF0008 는 GTT 미사용 (4 sheet 모두 직접 SELECT)
PROMPT - DIAG 1 row > 0 → GTT GRANT 확인 필요 (04_GRANT_SYNONYM/010)
