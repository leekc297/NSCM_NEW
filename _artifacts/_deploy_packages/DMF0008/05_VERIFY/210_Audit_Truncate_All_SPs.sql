--==============================================================================
-- 210_Audit_Truncate_All_SPs.sql
--
-- 목적:
--   DMF0008_GET_SALES_SITE 사고와 동일 패턴 (SP body 에 EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_*'
--   또는 DROP TABLE) 의 다른 SP 검색. NextSCM Pilot 변환기의 광범위한 패턴 일반화 audit.
--
-- 작성: 2026-06-05
--==============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 250
SET PAGESIZE 200

PROMPT === DIAG 1 : EXECUTE IMMEDIATE TRUNCATE 패턴 SP 전수 ===

SELECT name, type, COUNT(*) AS truncate_lines
  FROM all_source
 WHERE owner = 'SCM_MGR'
   AND REGEXP_LIKE(text, 'EXECUTE\s+IMMEDIATE\s*''\s*TRUNCATE', 'i')
 GROUP BY name, type
 ORDER BY truncate_lines DESC, name
 FETCH FIRST 50 ROWS ONLY;

PROMPT === DIAG 2 : EXECUTE IMMEDIATE DROP TABLE 패턴 SP 전수 ===

SELECT name, type, COUNT(*) AS drop_lines
  FROM all_source
 WHERE owner = 'SCM_MGR'
   AND REGEXP_LIKE(text, 'EXECUTE\s+IMMEDIATE\s*''\s*DROP\s+TABLE', 'i')
 GROUP BY name, type
 ORDER BY drop_lines DESC, name
 FETCH FIRST 50 ROWS ONLY;

PROMPT === DIAG 3 : '오류가 발생했습니다' generic EXCEPTION pattern (디버깅 불가능 SP) ===

SELECT name, type, line, text
  FROM all_source
 WHERE owner = 'SCM_MGR'
   AND REGEXP_LIKE(text, 'RAISE_APPLICATION_ERROR\(-20001,\s*''오류가 발생했습니다', 'i')
 ORDER BY name, line
 FETCH FIRST 50 ROWS ONLY;

PROMPT === DIAG 4 : SCMD_APP 에 GTT INSERT/UPDATE/DELETE grant 누락된 GTT 인벤토리 ===

WITH all_gtt AS (
  SELECT table_name FROM all_tables
   WHERE owner = 'SCM_MGR'
     AND temporary = 'Y'
),
scmd_app_grants AS (
  SELECT table_name, LISTAGG(privilege, ',') WITHIN GROUP (ORDER BY privilege) AS privs
    FROM dba_tab_privs
   WHERE grantee = 'SCMD_APP'
     AND owner = 'SCM_MGR'
   GROUP BY table_name
)
SELECT a.table_name,
       NVL(g.privs, '(none)') AS scmd_app_grants
  FROM all_gtt a
  LEFT JOIN scmd_app_grants g ON g.table_name = a.table_name
 WHERE NVL(g.privs, '(none)') NOT LIKE '%INSERT%'
    OR NVL(g.privs, '(none)') NOT LIKE '%UPDATE%'
    OR NVL(g.privs, '(none)') NOT LIKE '%DELETE%'
 ORDER BY a.table_name;

PROMPT === 판독 ===
PROMPT - DIAG 1 : TRUNCATE 사용 SP 인벤토리 (DMF0008_GET_SALES_SITE 확정 외 후보)
PROMPT - DIAG 2 : DROP TABLE 사용 SP (더 심각 — DDL 권한 + 객체 삭제)
PROMPT - DIAG 3 : generic EXCEPTION SP 인벤토리 (디버깅 어려운 SP 광범위)
PROMPT - DIAG 4 : SCMD_APP GTT DML grant 누락 인벤토리 (일괄 GRANT 후보)
