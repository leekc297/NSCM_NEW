-- [E20261008-SLASHDEF] 06_CLOUD_INVALID_DIAG — 03_RECOMPILE 뒤 COMPILE FAIL(ORA-24344) 원인 분류 (조회 전용, 변경 없음). 생성 2026-10-09
--   목적: 실패가 "DEV 에 참조 객체(PKG/FUNCTION/TABLE/TYPE) 가 생성되어 있지 않아서" 인지, 본 작업(DEFAULT 변경) 과 관련 있는지 가른다.
--   원리: 01_APPLY_CLOUD 는 컬럼 DEFAULT 메타만 바꾼다(타입·컬럼·객체 변경 없음) → 의존 객체를 INVALID 로 만들 수는 있지만 컴파일 오류를 새로 만들 수는 없다.
--         따라서 재컴파일 뒤에도 ORA-24344 로 남는 객체는 ALL_ERRORS 에 그 환경 고유의 오류(참조 없음 등)가 있어야 한다.
--   SCM_MGR 접속 후 파일 전체 실행(F5). 바인드·DEFINE 없음. 결과 D1~D5.
SET DEFINE OFF

-- D1. 현재 INVALID 객체 수 / 그중 ALL_ERRORS 에 오류가 기록된 수 (오류 없는 INVALID = 단순 stale, 재컴파일로 풀림)
SELECT 'D1 | invalid_total=' || COUNT(*)
    || ' | with_errors=' || SUM(CASE WHEN EXISTS (SELECT 1 FROM all_errors e WHERE e.owner = o.owner AND e.name = o.object_name AND e.type = o.object_type AND e.attribute = 'ERROR') THEN 1 ELSE 0 END)
    || ' | stale_only=' || SUM(CASE WHEN EXISTS (SELECT 1 FROM all_errors e WHERE e.owner = o.owner AND e.name = o.object_name AND e.type = o.object_type AND e.attribute = 'ERROR') THEN 0 ELSE 1 END) AS line
  FROM all_objects o
 WHERE o.owner = 'SCM_MGR' AND o.status = 'INVALID';

-- D2. 오류 코드별 분류 (객체 수) — 참조없음(PLS-00201 식별자 미선언 / ORA-00942 테이블·뷰 없음 / PLS-00302 구성요소 없음) · 컬럼없음(ORA-00904) · 의존객체INVALID(PLS-00905) · 기타
WITH err AS (
    SELECT e.owner, e.name, e.type,
           REGEXP_SUBSTR(e.text, '(PLS|ORA)-[0-9]{5}') AS code,
           e.text, e.line, e.sequence,
           ROW_NUMBER() OVER (PARTITION BY e.owner, e.name, e.type ORDER BY e.sequence) AS rn
      FROM all_errors e
      JOIN all_objects o ON o.owner = e.owner AND o.object_name = e.name AND o.object_type = e.type AND o.status = 'INVALID'
     WHERE e.owner = 'SCM_MGR' AND e.attribute = 'ERROR'
), cls AS (
    SELECT owner, name, type,
           CASE
             WHEN MAX(CASE WHEN code IN ('PLS-00201','ORA-00942','PLS-00302') THEN 1 ELSE 0 END) = 1 THEN 'A_참조객체없음(미생성)'
             WHEN MAX(CASE WHEN code = 'ORA-00904' THEN 1 ELSE 0 END) = 1 THEN 'B_컬럼없음(테이블 구조 차이)'
             WHEN MAX(CASE WHEN code = 'PLS-00905' THEN 1 ELSE 0 END) = 1 THEN 'C_의존객체가 INVALID(연쇄)'
             WHEN MAX(CASE WHEN code = 'ORA-01031' THEN 1 ELSE 0 END) = 1 THEN 'D_권한없음'
             ELSE 'E_기타(원문 확인 필요)'
           END AS cls
      FROM err GROUP BY owner, name, type
)
SELECT 'D2 | ' || cls || ' | objects=' || COUNT(*) AS line FROM cls GROUP BY cls ORDER BY cls;

-- D3. 객체별 첫 오류 1줄 (분류 + 코드 + 원문) — 전체 목록
WITH err AS (
    SELECT e.owner, e.name, e.type,
           REGEXP_SUBSTR(e.text, '(PLS|ORA)-[0-9]{5}') AS code,
           e.text, e.line, e.sequence,
           ROW_NUMBER() OVER (PARTITION BY e.owner, e.name, e.type ORDER BY CASE WHEN e.text LIKE 'PL/SQL: %' AND e.text NOT LIKE '%PLS-%' AND e.text NOT LIKE '%ORA-%' THEN 2 ELSE 1 END, e.sequence) AS rn
      FROM all_errors e
      JOIN all_objects o ON o.owner = e.owner AND o.object_name = e.name AND o.object_type = e.type AND o.status = 'INVALID'
     WHERE e.owner = 'SCM_MGR' AND e.attribute = 'ERROR'
)
SELECT 'D3 | ' || type || ' ' || name || ' | L' || line || ' | ' || NVL(code, '-') || ' | ' || SUBSTR(REPLACE(REPLACE(text, CHR(10), ' '), CHR(13), ' '), 1, 160) AS line
  FROM err WHERE rn = 1 ORDER BY type, name;

-- D4. 미생성 참조 객체 목록 — 오류 원문에서 따온 식별자가 DEV 어느 스키마에도 없으면 '미생성 확인', 있으면 '존재(권한/시노님 문제)'
WITH ids AS (
    SELECT DISTINCT UPPER(REGEXP_SUBSTR(e.text, '''([^'']+)''', 1, 1, NULL, 1)) AS ident, e.name AS in_object, e.type AS in_type
      FROM all_errors e
      JOIN all_objects o ON o.owner = e.owner AND o.object_name = e.name AND o.object_type = e.type AND o.status = 'INVALID'
     WHERE e.owner = 'SCM_MGR' AND e.attribute = 'ERROR'
       AND REGEXP_LIKE(e.text, 'PLS-00201|PLS-00302|ORA-00942')
       AND REGEXP_SUBSTR(e.text, '''([^'']+)''', 1, 1, NULL, 1) IS NOT NULL
), ids2 AS (
    SELECT ident,
           CASE WHEN INSTR(ident, '.') > 0 THEN SUBSTR(ident, INSTR(ident, '.') + 1) ELSE ident END AS tail_name,
           CASE WHEN INSTR(ident, '.') > 0 THEN SUBSTR(ident, 1, INSTR(ident, '.') - 1) ELSE NULL END AS head_name,
           COUNT(DISTINCT in_type || ' ' || in_object) AS used_by
      FROM ids GROUP BY ident
)
SELECT 'D4 | ' || ident || ' | used_by=' || used_by || ' | '
    || CASE
         WHEN EXISTS (SELECT 1 FROM all_objects a WHERE a.object_name = ids2.ident AND a.object_type NOT IN ('SYNONYM','PACKAGE BODY','TYPE BODY')) THEN '존재(' || (SELECT LISTAGG(DISTINCT a.owner || ':' || a.object_type, ',') WITHIN GROUP (ORDER BY a.owner) FROM all_objects a WHERE a.object_name = ids2.ident AND a.object_type NOT IN ('SYNONYM','PACKAGE BODY','TYPE BODY')) || ') → 권한/시노님 확인'
         WHEN EXISTS (SELECT 1 FROM all_objects a WHERE a.object_name = ids2.ident AND a.object_type IN ('PACKAGE BODY','TYPE BODY')) THEN '스펙 미생성(BODY 만 존재 — 스펙 CREATE 누락)'
         WHEN EXISTS (SELECT 1 FROM all_objects a WHERE a.object_name = ids2.head_name AND a.object_type IN ('PACKAGE','TYPE')) THEN '패키지/타입은 존재, 구성요소 ' || tail_name || ' 없음(버전 차이)'
         WHEN EXISTS (SELECT 1 FROM all_objects a WHERE a.object_name = ids2.ident AND a.object_type = 'SYNONYM') THEN '시노님만 존재 → 대상 객체 없음'
         ELSE '미생성 확인(DEV 어느 스키마에도 없음)'
       END AS line
  FROM ids2 ORDER BY ident;

-- D5. 본 작업 관련성 교차검사 — 오류 원문에 DEFAULT 변경 대상 컬럼의 테이블이 ORA-00904(컬럼 없음) 로 나오는지. 0행이면 DEFAULT 변경과 무관.
--     (01 은 컬럼을 추가·삭제·타입변경하지 않으므로 0행이 정상. 행이 나오면 그 테이블의 DEV 구조가 사내와 달라서 생긴 것 — 역시 01 과 무관하지만 기록)
--     ORA-00904 원문은 "TABLE"."COL" 또는 "ALIAS"."COL" 형식 — 별칭이면 잡히지 않을 수 있음(D3 에서 직접 확인)
SELECT 'D5 | ' || e.type || ' ' || e.name || ' | L' || e.line || ' | ' || SUBSTR(REPLACE(e.text, CHR(10), ' '), 1, 160) AS line
  FROM all_errors e
  JOIN all_objects o ON o.owner = e.owner AND o.object_name = e.name AND o.object_type = e.type AND o.status = 'INVALID'
 WHERE e.owner = 'SCM_MGR' AND e.attribute = 'ERROR' AND e.text LIKE '%ORA-00904%'
   AND EXISTS (SELECT 1 FROM all_tab_columns c   -- DATA_DEFAULT 는 LONG 이라 비교 불가 → 01 이 일괄 부여한 DEFAULT_ON_NULL=YES + NOT NULL 을 대상 컬럼 표지로 사용
                WHERE c.owner = 'SCM_MGR' AND c.default_on_null = 'YES' AND c.nullable = 'N'
                  AND e.text LIKE '%"' || c.table_name || '"%')
 ORDER BY e.type, e.name, e.line;
