-- silent_fail_audit.sql — silent fail family 일괄 검출 (파이프라인 Stage 3)
-- 실행: ./run_sql.sh silent_fail_audit.sql
-- 근거: oracle-db-workflow.md §0-G / 01_MSSQL_to_Oracle_Conversion_Rules.md 부록 C
-- 판정: 모든 섹션 0 rows → PASS. 검출 시 family 전체 fix 후 재실행 (1건 fix 후 종료 금지)

SET PAGESIZE 200 LINESIZE 220 TRIMSPOOL ON

PROMPT === [1] SUBSTR(x, 0, n) — position 0 pitfall (부록 C-1) ===
SELECT name, type, line, SUBSTR(TRIM(text),1,120) AS src
FROM user_source
WHERE REGEXP_LIKE(UPPER(text), 'SUBSTR\s*\(\s*[A-Z0-9_."]+\s*,\s*0\s*,')
ORDER BY name, line;

PROMPT === [2] TRUNCATE ... GT_ — GTT TRUNCATE 금지 (부록 C-2) ===
SELECT name, type, line, SUBSTR(TRIM(text),1,120) AS src
FROM user_source
WHERE REGEXP_LIKE(UPPER(text), 'TRUNCATE\s+TABLE\s+("?GT_|[A-Z0-9_]*\.GT_)')
ORDER BY name, line;

PROMPT === [3] GT_* INSERT 보유 but DELETE 미보유 SP — GTT 잔존 row 위험 (부록 C-5) ===
SELECT s1.name, s1.type
FROM (SELECT DISTINCT name, type FROM user_source WHERE REGEXP_LIKE(UPPER(text),'INSERT\s+INTO\s+"?GT_')) s1
WHERE NOT EXISTS (
  SELECT 1 FROM user_source s2
  WHERE s2.name = s1.name AND s2.type = s1.type
    AND REGEXP_LIKE(UPPER(s2.text), 'DELETE\s+(FROM\s+)?"?GT_'))
ORDER BY 1;

PROMPT === [4] OUT SYS_REFCURSOR 선언 vs OPEN 불일치 (부록 C-6) — 수동 확인 목록 ===
SELECT a.object_name, a.argument_name
FROM user_arguments a
WHERE a.data_type = 'REF CURSOR' AND a.in_out LIKE '%OUT%'
  AND NOT EXISTS (
    SELECT 1 FROM user_source s
    WHERE s.name = NVL(a.package_name, a.object_name)
      AND REGEXP_LIKE(UPPER(s.text), 'OPEN\s+' || UPPER(a.argument_name) || '(\s|$|\()'))
ORDER BY 1, 2;

PROMPT === [5] LISTAGG without ON OVERFLOW — ORA-01489 위험 (부록 C-3) ===
SELECT name, type, line, SUBSTR(TRIM(text),1,120) AS src
FROM user_source s
WHERE UPPER(text) LIKE '%LISTAGG%'
  AND NOT EXISTS (SELECT 1 FROM user_source s2
                  WHERE s2.name=s.name AND s2.type=s.type
                    AND s2.line BETWEEN s.line AND s.line+2
                    AND UPPER(s2.text) LIKE '%ON OVERFLOW%')
ORDER BY name, line;

PROMPT === [6] MSSQL 잔존 키워드 (룰 §9 / CLAUDE.md 금지 10) ===
SELECT name, type, line, SUBSTR(TRIM(text),1,120) AS src
FROM user_source
WHERE REGEXP_LIKE(UPPER(text),
  '(DATEADD|DATEDIFF|CHARINDEX|STRING_SPLIT|GETDATE\s*\(|ISNULL\s*\(|IIF\s*\(|WITH\s*\(\s*NOLOCK)')
ORDER BY name, line;

PROMPT === [7] EXCEPTION OTHERS 가 SQLERRM 가림 (sp-exception-handler-debug-friendly) ===
SELECT name, type, line, SUBSTR(TRIM(text),1,120) AS src
FROM user_source s
WHERE UPPER(text) LIKE '%RAISE_APPLICATION_ERROR%'
  AND UPPER(text) NOT LIKE '%SQLERRM%'
  AND EXISTS (SELECT 1 FROM user_source s2
              WHERE s2.name=s.name AND s2.type=s.type
                AND s2.line BETWEEN s.line-3 AND s.line
                AND UPPER(s2.text) LIKE '%WHEN OTHERS%')
ORDER BY name, line;

PROMPT === audit 종료 — 전 섹션 0 rows = PASS ===
