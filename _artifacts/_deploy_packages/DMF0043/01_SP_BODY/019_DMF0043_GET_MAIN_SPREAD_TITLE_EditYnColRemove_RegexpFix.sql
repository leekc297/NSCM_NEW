--==============================================================================
-- 019_DMF0043_GET_MAIN_SPREAD_TITLE_EditYnColRemove_RegexpFix.sql
--
-- 018 의 REGEXP 안전 버전. 018 의 literal REPLACE 가 들여쓰기 변형 (tab vs space)
-- 으로 4 패턴 중 1개만 매치 → UNION 컬럼 수 불일치 → ORA-06504/24344 폭발 시 사용.
--
-- 원인: SP body 의 default branch 가 3 UNION SELECT 로 22+1=23 컬럼 반환.
--       caller (DMF0043_GET_CONTRIBUTE_MAIN_DATA) FETCH 는 22 변수.
--       3 SELECT 모두에서 EDIT_YN 컬럼을 제거해야 UNION 정합 + caller fetch 일치.
--
-- 매치 대상 (REGEXP — whitespace/quote literal 차이 무관):
--   1. `, tei.EDIT_YN`           (1st SELECT, INNER JOIN 컬럼)
--   2. `, '' AS EDIT_YN`         (2nd SELECT, raw body empty literal)
--   3. `, '' AS EDIT_YN`         (3rd SELECT, raw body empty literal)
--   ✓ 'N' / 'X' / 다른 literal 도 매치 (`,\s*'[^']*'\s+AS\s+EDIT_YN`)
--   ✗ `PR_SCM_EDIT_YN` 함수명은 매치 안 됨 (앞 토큰이 단순 `,` 가 아닌 함수 호출)
--
-- 멱등: 매치 0 (=이미 제거됨) 시 SKIP
-- 실행: SCM_MGR 세션. SQL*Plus / DBeaver 모두 OK
--
-- 사고 회복 절차 (018 부분 실행으로 INVALID 된 경우):
--   1. 005_DMF0043_GET_MAIN_SPREAD_TITLE_Body.sql 재실행 (raw body 복구)
--   2. 019 실행 (본 파일, 3 SELECT 모두 EDIT_YN 제거 정합)
--
-- 작성: 2026-06-05
--==============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON
SET FEEDBACK ON
WHENEVER SQLERROR EXIT FAILURE

PROMPT === BLOCK 1 : REGEXP_REPLACE 로 EDIT_YN SELECT 컬럼 3건 모두 제거 ===

DECLARE
    v_src         CLOB := EMPTY_CLOB();
    v_patched     CLOB;
    -- 패턴: `,` + 공백/탭 + EDIT_YN 컬럼 expression + 행 끝 공백
    --   v_pattern_1: `, tei.EDIT_YN`              (INNER JOIN 컬럼)
    --   v_pattern_2: `, '<literal>' AS EDIT_YN`   (literal 안의 내용 무관 — '', 'N', 'X' 모두 매치)
    --   ✗ PR_SCM_EDIT_YN 함수 호출은 앞 토큰이 `(SCM_USER_MNU.` 또는 `.PR_SCM_` 라서 단순 `,` 매치 X
    v_pattern_1   VARCHAR2(200) := ',\s*tei\.EDIT_YN\s*';
    v_pattern_2   VARCHAR2(200) := ',\s*''[^'']*''\s+AS\s+EDIT_YN\s*';
    v_cnt_before  PLS_INTEGER;
    v_cnt_after   PLS_INTEGER;
    v_func_cnt    PLS_INTEGER;
    v_total_remove PLS_INTEGER;
BEGIN
    DBMS_LOB.CREATETEMPORARY(v_src, TRUE);
    FOR rec IN (
        SELECT TEXT FROM USER_SOURCE
         WHERE NAME = 'DMF0043_GET_MAIN_SPREAD_TITLE' AND TYPE = 'PROCEDURE'
         ORDER BY LINE
    ) LOOP
        DBMS_LOB.APPEND(v_src, rec.TEXT);
    END LOOP;

    v_cnt_before := REGEXP_COUNT(v_src, 'EDIT_YN', 1, 'i');
    v_func_cnt   := REGEXP_COUNT(v_src, 'PR_SCM_EDIT_YN', 1, 'i');
    DBMS_OUTPUT.PUT_LINE('EDIT_YN references BEFORE: ' || v_cnt_before
                      || ' (PR_SCM_EDIT_YN 함수 호출 ' || v_func_cnt || ' 포함)');
    DBMS_OUTPUT.PUT_LINE('제거 대상 SELECT 컬럼 = ' || (v_cnt_before - v_func_cnt));

    -- 1) `, tei.EDIT_YN` 패턴 (1st SELECT)
    v_patched := REGEXP_REPLACE(v_src, v_pattern_1, '', 1, 0, 'i');

    -- 2) `, 'N' AS EDIT_YN` 또는 `, ''N'' AS EDIT_YN` 패턴 (2nd / 3rd SELECT)
    v_patched := REGEXP_REPLACE(v_patched, v_pattern_2, '', 1, 0, 'i');

    v_cnt_after := REGEXP_COUNT(v_patched, 'EDIT_YN', 1, 'i');
    v_total_remove := v_cnt_before - v_cnt_after;
    DBMS_OUTPUT.PUT_LINE('EDIT_YN references AFTER : ' || v_cnt_after
                      || ' (PR_SCM_EDIT_YN ' || v_func_cnt || ' 유지)');
    DBMS_OUTPUT.PUT_LINE('removed = ' || v_total_remove);

    IF v_cnt_after <> v_func_cnt THEN
        DBMS_OUTPUT.PUT_LINE('WARN: AFTER (' || v_cnt_after || ') 가 함수 호출수 (' || v_func_cnt || ') 와 다름.');
        DBMS_OUTPUT.PUT_LINE('       SP body 가 예상치 못한 형태. 005 재실행 후 다시 시도 권장.');
    END IF;

    IF v_total_remove = 0 THEN
        DBMS_OUTPUT.PUT_LINE('이미 fix 적용됨 — SKIP (멱등).');
    ELSE
        v_patched := 'CREATE OR REPLACE ' || v_patched;
        EXECUTE IMMEDIATE v_patched;
        DBMS_OUTPUT.PUT_LINE('OK: DMF0043_GET_MAIN_SPREAD_TITLE EDIT_YN 컬럼 ' || v_total_remove || ' 건 제거 + 재컴파일');
    END IF;

    DBMS_LOB.FREETEMPORARY(v_src);
END;
/

PROMPT === BLOCK 2 : 컴파일 STATUS + EDIT_YN 잔존 카운트 ===

SELECT object_name, status, TO_CHAR(last_ddl_time, 'YYYY-MM-DD HH24:MI:SS') AS last_ddl
  FROM user_objects
 WHERE object_name = 'DMF0043_GET_MAIN_SPREAD_TITLE';

SELECT COUNT(*) AS remaining_edit_yn
  FROM user_source
 WHERE name = 'DMF0043_GET_MAIN_SPREAD_TITLE'
   AND type = 'PROCEDURE'
   AND UPPER(text) LIKE '%EDIT_YN%';

PROMPT === BLOCK 3 : INVALID 시 컴파일 오류 상세 ===

SELECT line, position, text
  FROM user_errors
 WHERE name = 'DMF0043_GET_MAIN_SPREAD_TITLE'
   AND type = 'PROCEDURE'
 ORDER BY sequence
 FETCH FIRST 30 ROWS ONLY;

PROMPT === 판독 ===
PROMPT - STATUS = VALID 이면 OK (다음 020 OpenRC1 patch 진행)
PROMPT - remaining_edit_yn = 1 (PR_SCM_EDIT_YN 함수 호출만 남음) 이면 OK
PROMPT - INVALID + BLOCK 3 에 컴파일 오류 → 005 재실행 후 다시 019 적용 권장

COMMIT;
EXIT;
