--==============================================================================
-- 150_Audit_DummyOpen_AllSPs.sql
--
-- 목적:
--   DMF0008_GET_EDI_MST_SUMMARY 사고와 동일 패턴 (메인 SELECT OPEN 후 무조건
--   OPEN ... FOR SELECT NULL AS DUMMY FROM DUAL 로 덮어쓰기) 의 다른 SP 검색.
--
-- 추정:
--   NextSCM Pilot 변환기 (2026-03-15) 가 자동 생성한 fallback template 으로 보임.
--   광범위한 audit 필요.
--
-- 작성: 2026-06-05
--==============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 250
SET PAGESIZE 200

PROMPT === DIAG 1 : DUMMY OPEN 패턴 사용 SP 전수 검색 ===

SELECT name, type, COUNT(*) AS dummy_open_lines
  FROM all_source
 WHERE owner = 'SCM_MGR'
   AND REGEXP_LIKE(text, 'OPEN\s+O_\w+\s+FOR\s+SELECT\s+NULL\s+AS\s+DUMMY\s+FROM\s+DUAL', 'i')
 GROUP BY name, type
 ORDER BY dummy_open_lines DESC, name;

PROMPT === DIAG 2 : 같은 OUT cursor 변수에 OPEN..FOR 가 2번 이상 나오는 SP 검출 ===
-- (메인 SELECT + DUMMY 덮어쓰기 동일 패턴)

WITH open_lines AS (
  SELECT name, type, line,
         REGEXP_SUBSTR(text, 'OPEN\s+(O_\w+)\s+FOR', 1, 1, 'i', 1) AS cursor_var
    FROM all_source
   WHERE owner = 'SCM_MGR'
     AND REGEXP_LIKE(text, 'OPEN\s+O_\w+\s+FOR', 'i')
)
SELECT name, cursor_var, COUNT(*) AS open_count,
       LISTAGG(line, ',') WITHIN GROUP (ORDER BY line) AS lines
  FROM open_lines
 WHERE cursor_var IS NOT NULL
 GROUP BY name, cursor_var
HAVING COUNT(*) >= 2
 ORDER BY open_count DESC, name
 FETCH FIRST 50 ROWS ONLY;

PROMPT === DIAG 3 : DMF/SCM 전체 SP 중 DUMMY OPEN 으로 메인 cursor 덮어쓰는 후보 SP ===
-- (DIAG 1 + DIAG 2 교차)

WITH dummy_users AS (
  SELECT DISTINCT name
    FROM all_source
   WHERE owner = 'SCM_MGR'
     AND REGEXP_LIKE(text, 'OPEN\s+O_\w+\s+FOR\s+SELECT\s+NULL\s+AS\s+DUMMY\s+FROM\s+DUAL', 'i')
),
open_lines AS (
  SELECT name, line,
         REGEXP_SUBSTR(text, 'OPEN\s+(O_\w+)\s+FOR', 1, 1, 'i', 1) AS cursor_var
    FROM all_source
   WHERE owner = 'SCM_MGR'
     AND REGEXP_LIKE(text, 'OPEN\s+O_\w+\s+FOR', 'i')
),
double_open AS (
  SELECT name, cursor_var, COUNT(*) AS open_cnt
    FROM open_lines
   WHERE cursor_var IS NOT NULL
   GROUP BY name, cursor_var
  HAVING COUNT(*) >= 2
)
SELECT DISTINCT d.name AS suspect_sp, d.cursor_var, d.open_cnt
  FROM double_open d
  JOIN dummy_users du ON du.name = d.name
 ORDER BY d.name;

PROMPT === 판독 ===
PROMPT - DIAG 1: DUMMY OPEN 사용 SP 인벤토리. 0 = 안전. >0 = audit
PROMPT - DIAG 2: 같은 cursor 변수 OPEN 2번+ → 첫 번째 덮어쓰기 위험
PROMPT - DIAG 3: 교차 결과 = DMF0008 사고와 동일 위험군. 각 SP body 정밀 확인 필요
