--==============================================================================
-- 250_Audit_NVL_NULL_Pattern.sql
--
-- 목적:
--   To-Be 의 모든 SP 중 As-Is MSSQL 의 `ISNULL(x, '')` 패턴을
--   Oracle 의 `NVL(x, NULL)` 또는 `x` 단독으로 잘못 변환한 SP 검출.
--
-- 사고 패턴:
--   - As-Is MSSQL : ISNULL(EXCEPTION_FLAG, '') != 'Y'  → NULL row 포함
--   - To-Be 잘못   : EXCEPTION_FLAG != 'Y' / NVL(.., NULL) != 'Y'  → NULL row 제외
--   - 올바름      : NVL(EXCEPTION_FLAG, 'N') != 'Y'   → NULL row 포함
--
-- 작성: 2026-06-05
--==============================================================================
SET DEFINE OFF
SET LINESIZE 250
SET PAGESIZE 100

PROMPT === DIAG 1 : NVL(x, NULL) 패턴 (NVL 효과 없음) ===

SELECT name, type, COUNT(*) AS occurrence
  FROM all_source
 WHERE owner = 'SCM_MGR'
   AND REGEXP_LIKE(text, 'NVL\(\s*\w+(\.\w+)?\s*,\s*NULL\s*\)', 'i')
 GROUP BY name, type
 ORDER BY occurrence DESC
 FETCH FIRST 30 ROWS ONLY;

PROMPT === DIAG 2 : EXCEPTION_FLAG != ''Y'' 패턴 (NULL row 제외 위험) ===

SELECT name, type, COUNT(*) AS occurrence
  FROM all_source
 WHERE owner = 'SCM_MGR'
   AND REGEXP_LIKE(text, 'EXCEPTION_FLAG\s*[!<>]=\s*''Y''', 'i')
   AND NOT REGEXP_LIKE(text, 'NVL\(.*EXCEPTION_FLAG.*,\s*''N''', 'i')
 GROUP BY name, type
 ORDER BY occurrence DESC
 FETCH FIRST 30 ROWS ONLY;

PROMPT === DIAG 3 : DMF0008 의 모든 SP 의 EXCEPTION_FLAG 사용 line ===

SELECT name, line, text
  FROM all_source
 WHERE owner = 'SCM_MGR'
   AND name LIKE 'DMF0008%'
   AND REGEXP_LIKE(text, 'EXCEPTION_FLAG', 'i')
 ORDER BY name, line;
