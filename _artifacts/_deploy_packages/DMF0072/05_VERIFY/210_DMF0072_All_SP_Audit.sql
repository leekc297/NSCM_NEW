--==============================================================================
-- 210_DMF0072_All_SP_Audit.sql
--
-- 목적:
--   DMF0072 화면 조회 시 SQL error.
--   NextSCM Pilot 변환기 5종 사고 패턴 audit:
--     1. DUMMY OPEN (메인 cursor 덮어쓰기)
--     2. TRUNCATE GTT (DDL 권한 부족)
--     3. UTL_CALL_STACK SUBPROGRAM(1)(2) (collection out of bounds)
--     4. NVL(x, NULL) (NULL row 제외 사고)
--     5. PROC_M 중복 row
--
-- 작성: 2026-06-05
--==============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 250
SET PAGESIZE 200

PROMPT === DIAG 1 : DMF0072 관련 SP 인벤토리 ===

SELECT object_name, object_type, status
  FROM all_objects
 WHERE owner = 'SCM_MGR'
   AND (object_name LIKE 'DMF0072%' OR object_name = 'PKG_DMF0072')
   AND object_type IN ('PROCEDURE', 'PACKAGE', 'PACKAGE BODY')
 ORDER BY object_type, object_name;

PROMPT === DIAG 2 : DMF0072 BTN_MPG (어떤 sheet 가 어떤 SP 호출하는지) ===

SELECT mnu_id, sht_nm, mnu_btn_cd, api_id, use_yn
  FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M
 WHERE mnu_id = 'DMF0072'
 ORDER BY sht_nm, mnu_btn_cd;

PROMPT === DIAG 3 : DMF0072 API_M (api_id → SP path) ===

SELECT api_id, api_url, api_tp_cd
  FROM SCM_MGR.SCM_ADM_API_M
 WHERE UPPER(api_url) LIKE '%DMF0072%' OR api_id LIKE '%DMF0072%'
 ORDER BY api_id;

PROMPT === DIAG 4 : DMF0072 PROC_M (중복 row 식별) ===

SELECT proc_nm, col_nm, data_tp_cd, col_tp_cd, sort_ord, COUNT(*) OVER (PARTITION BY proc_nm, col_tp_cd, sort_ord) AS dup_in_sort
  FROM SCM_MGR.SCM_ADM_PROC_M
 WHERE proc_nm LIKE 'DMF0072%'
 ORDER BY proc_nm, sort_ord, col_nm;

PROMPT === DIAG 5 : 사고 패턴 audit (DMF0072 + PKG_DMF0072) ===

WITH sps AS (
  SELECT DISTINCT name FROM all_source WHERE owner='SCM_MGR' AND (name LIKE 'DMF0072%' OR name = 'PKG_DMF0072')
)
SELECT s.name,
       SUM(CASE WHEN REGEXP_LIKE(src.text, 'EXECUTE\s+IMMEDIATE.*TRUNCATE', 'i') THEN 1 ELSE 0 END) AS truncate_lines,
       SUM(CASE WHEN REGEXP_LIKE(src.text, 'OPEN\s+O_\w+\s+FOR\s+SELECT\s+NULL\s+AS\s+DUMMY', 'i') THEN 1 ELSE 0 END) AS dummy_open_lines,
       SUM(CASE WHEN REGEXP_LIKE(src.text, 'UTL_CALL_STACK\.SUBPROGRAM\(1\)\(2\)', 'i') THEN 1 ELSE 0 END) AS utl_call_stack_lines,
       SUM(CASE WHEN REGEXP_LIKE(src.text, 'NVL\(\s*\w+(\.\w+)?\s*,\s*NULL\s*\)', 'i') THEN 1 ELSE 0 END) AS nvl_null_lines,
       SUM(CASE WHEN REGEXP_LIKE(src.text, '오류가 발생했습니다', 'i') THEN 1 ELSE 0 END) AS generic_exception_lines
  FROM sps s
  JOIN all_source src ON src.owner='SCM_MGR' AND src.name = s.name
 GROUP BY s.name
 ORDER BY s.name;

PROMPT === DIAG 6 : DMF0072 메인 SP body 의 RAISE_APPLICATION_ERROR (generic 또는 SQLCODE 포함) ===

SELECT name, line, text
  FROM all_source
 WHERE owner = 'SCM_MGR'
   AND (name LIKE 'DMF0072%' OR name = 'PKG_DMF0072')
   AND REGEXP_LIKE(text, 'RAISE_APPLICATION_ERROR', 'i')
 ORDER BY name, line
 FETCH FIRST 30 ROWS ONLY;

PROMPT === DIAG 7 : DMF0072 메인 SP 의 종속 GTT (DML 권한 확인) ===

SELECT g.table_name, NVL(p.privs, '(none)') AS scmd_app_privs
  FROM (SELECT DISTINCT REGEXP_SUBSTR(text, '(INSERT\s+INTO|FROM)\s+(GT_\w+|GTT_\w+)', 1, 1, 'i', 2) AS table_name
          FROM all_source
         WHERE owner='SCM_MGR' AND (name LIKE 'DMF0072%' OR name='PKG_DMF0072')
           AND REGEXP_LIKE(text, '(INSERT\s+INTO|FROM)\s+(GT_\w+|GTT_\w+)', 'i')) g
  LEFT JOIN (SELECT table_name, LISTAGG(privilege, ',') WITHIN GROUP (ORDER BY privilege) AS privs
               FROM dba_tab_privs
              WHERE grantee='SCMD_APP' AND owner='SCM_MGR'
              GROUP BY table_name) p ON p.table_name = g.table_name
 WHERE g.table_name IS NOT NULL
 ORDER BY g.table_name;

PROMPT === 판독 ===
PROMPT - DIAG 1: SP 모두 VALID
PROMPT - DIAG 2/3: BTN_MPG → API_M 매핑 (sht_nm 'main'/lookup 4종/popup 2종)
PROMPT - DIAG 4: dup_in_sort > 1 → PROC_M 중복 (DELETE 필요)
PROMPT - DIAG 5: 사고 패턴 카운트 — TRUNCATE/DUMMY/UTL_CALL_STACK/NVL_NULL/Generic
PROMPT - DIAG 6: generic '오류가 발생했습니다' 사용 SP → 디버깅 어려움
PROMPT - DIAG 7: GTT DML 권한 (INSERT/UPDATE/DELETE) 누락 시 ORA-01031
