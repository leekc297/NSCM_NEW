--==============================================================================
-- 020_GTT_DMF0072_CHECK.sql
--==============================================================================
SET SERVEROUTPUT ON

PROMPT === DIAG 1 : DMF0072 GTT 인벤토리 (있다면) ===

SELECT table_name, temporary, duration
  FROM all_tables
 WHERE owner = 'SCM_MGR'
   AND table_name LIKE 'GT_DMF0072%'
 ORDER BY table_name;

PROMPT === 판독 ===
PROMPT - DIAG 1 row 0 → DMF0072 는 GTT 미사용 (WITH CTE 패턴)
PROMPT - DIAG 1 row > 0 → GTT GRANT 확인 필요
