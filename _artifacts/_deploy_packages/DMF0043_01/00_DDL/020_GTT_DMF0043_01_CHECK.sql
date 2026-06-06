--==============================================================================
-- 020_GTT_DMF0043_01_CHECK.sql
--
-- 목적: DMF0043_01 가 사용하는 GTT 확인 (DMF0043 와 공유)
-- 실행: SCM_MGR / SCMD_APP 세션 모두 OK
-- 작성: 2026-06-05
--
-- DMF0043_01 가 호출하는 SP (CONTRIBUTION_SALES_LIST 등) 가 사용하는 GTT:
--   - GT_DMF0043_TITLE / TEMP / TEMP2 / TEMP3 / MASTER_LIST / TEMP_LIST / DATA_TABLE
--   - GT_GMST_TEMP_2 / GT_GMST_TEMP2_2 (PKG_DMF0043.P_DMF0043_GET_MAIN_SPREAD_TITLE 의존)
--==============================================================================
SET LINESIZE 200
SET PAGESIZE 100
SET SERVEROUTPUT ON

PROMPT === DIAG 1 : DMF0043 / DMF0002 / GMST GTT 인벤토리 ===

SELECT table_name, temporary, duration
  FROM all_tables
 WHERE owner = 'SCM_MGR'
   AND table_name IN (
     'GT_DMF0043_TITLE',
     'GT_DMF0043_TEMP',
     'GT_DMF0043_TEMP2',
     'GT_DMF0043_TEMP3',
     'GT_DMF0043_MASTER_LIST',
     'GT_DMF0043_TEMP_LIST',
     'GT_DMF0043_DATA_TABLE',
     'GT_GMST_TEMP_2',
     'GT_GMST_TEMP2_2'
   )
 ORDER BY table_name;

PROMPT === DIAG 2 : SCMD_APP GTT GRANT 확인 ===

SELECT table_name, grantee, privilege
  FROM all_tab_privs
 WHERE table_schema = 'SCM_MGR'
   AND table_name LIKE 'GT_DMF0043_%'
   AND grantee = 'SCMD_APP'
 ORDER BY table_name, privilege;

PROMPT === 판독 ===
PROMPT - DIAG 1 9 row + TEMPORARY=Y 모두 → OK
PROMPT - DIAG 2 SCMD_APP 가 SELECT/INSERT/DELETE 권한 모두 → 04_GRANT_SYNONYM/010 실행 필요
