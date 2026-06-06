--==============================================================================
-- 140_DMF0008_Summary_SP_Line111_135_Detail.sql
--
-- 목적:
--   DIAG 1 (130 SQL) 에서 line 130-160 만 보고는 line 111-130 사이의 분기/주석 구조
--   파악 불가. 메인 SELECT (line 66) 와 DUMMY OPEN (line 132) 사이에 무엇이 있는지
--   line 110-140 전체 확인.
--
-- 가설:
--   line 132 의 DUMMY OPEN 이 IF/ELSE 분기 없이 메인 흐름에 있어서 메인 cursor
--   (line 66 OPEN O_RC1 FOR SELECT T.DIVISION_ID...) 결과를 덮어쓰는 중.
--
-- 작성: 2026-06-05
--==============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 250
SET PAGESIZE 200

PROMPT === DIAG 1 : SP body line 1-50 (DECLARE + 시작) ===

SELECT line, text
  FROM all_source
 WHERE owner = 'SCM_MGR'
   AND name = 'DMF0008_GET_EDI_MST_SUMMARY'
   AND type = 'PROCEDURE'
   AND line BETWEEN 1 AND 50
 ORDER BY line;

PROMPT === DIAG 2 : SP body line 105-145 (메인 SELECT 종료 ~ DUMMY OPEN ~ EXCEPTION) ===

SELECT line, text
  FROM all_source
 WHERE owner = 'SCM_MGR'
   AND name = 'DMF0008_GET_EDI_MST_SUMMARY'
   AND type = 'PROCEDURE'
   AND line BETWEEN 105 AND 145
 ORDER BY line;

PROMPT === DIAG 3 : SP body 전체 length + IF/THEN/ELSE 분기 grep ===

SELECT COUNT(*) AS total_lines
  FROM all_source
 WHERE owner = 'SCM_MGR'
   AND name = 'DMF0008_GET_EDI_MST_SUMMARY'
   AND type = 'PROCEDURE';

SELECT line, text
  FROM all_source
 WHERE owner = 'SCM_MGR'
   AND name = 'DMF0008_GET_EDI_MST_SUMMARY'
   AND type = 'PROCEDURE'
   AND REGEXP_LIKE(text, '\b(IF|ELSE|ELSIF|END\s+IF|BEGIN|END)\b', 'i')
 ORDER BY line;

PROMPT === DIAG 4 : OPEN 구문 모두 (몇 번 OPEN 되는지) ===

SELECT line, text
  FROM all_source
 WHERE owner = 'SCM_MGR'
   AND name = 'DMF0008_GET_EDI_MST_SUMMARY'
   AND type = 'PROCEDURE'
   AND REGEXP_LIKE(text, 'OPEN\s+O_', 'i')
 ORDER BY line;

PROMPT === DIAG 5 : 메인 cursor (line 66 OPEN O_RC1 FOR SELECT T.DIVISION_ID) 직후
PROMPT          ;세미콜론 종료 위치 ===

SELECT line, text
  FROM all_source
 WHERE owner = 'SCM_MGR'
   AND name = 'DMF0008_GET_EDI_MST_SUMMARY'
   AND type = 'PROCEDURE'
   AND line BETWEEN 110 AND 132
 ORDER BY line;

PROMPT === 판독 ===
PROMPT - DIAG 2: line 111-131 사이에 IF/ELSE 또는 EXCEPTION 절 있는지
PROMPT - DIAG 3: IF/THEN/ELSE 가 있으면 line 132 가 분기 안 (조건부) 일 가능성
PROMPT - DIAG 4: OPEN O_RC1 가 몇 번 나오는지 (메인 line 66 + DUMMY line 132 = 2 번이면 덮어쓰기 확정)
PROMPT - DIAG 5: 메인 SELECT 종료점 (;) + DUMMY OPEN 시작점 사이 구조
