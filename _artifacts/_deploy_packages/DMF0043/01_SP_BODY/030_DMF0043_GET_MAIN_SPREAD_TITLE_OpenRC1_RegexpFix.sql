--==============================================================================
-- 056_DMF0043_GET_MAIN_SPREAD_TITLE_OpenRC1_RegexpFix.sql
--
-- 055 의 후속 fix. 055 가 들여쓰기 변형 (tab vs space) 으로 패턴 미매치한 경우용.
-- REGEXP_REPLACE 로 whitespace 무관 매치 → tab/space 어느 쪽이든 1회 교체.
--
-- 적용 후 효과 (055 와 동일):
--   DMF0043_GET_MAIN_SPREAD_TITLE 의 default 분기
--   IF v_user_col_cnt = 0 THEN
--     OPEN O_RC3 FOR  →  OPEN O_RC1 FOR
--
-- 멱등: O_RC3 → O_RC1 변환 패턴이 매치 안 되면 (= 이미 fix 됨) SKIP
-- 실행: SCM_MGR 세션 (USER_SOURCE 자기 schema). SQL*Plus / DBeaver 모두 OK.
--
-- 작성: 2026-06-04
--==============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON
SET FEEDBACK ON
WHENEVER SQLERROR EXIT FAILURE

PROMPT === BLOCK 1 : REGEXP_REPLACE 로 O_RC3 -> O_RC1 변환 ===

DECLARE
    v_src     CLOB := EMPTY_CLOB();
    v_patched CLOB;
    v_pattern VARCHAR2(200) := '(IF\s+v_user_col_cnt\s*=\s*0\s+THEN\s+)OPEN\s+O_RC3(\s+FOR)';
    v_replace VARCHAR2(200) := '\1OPEN O_RC1\2';
    v_cnt_before PLS_INTEGER;
    v_cnt_after  PLS_INTEGER;
BEGIN
    DBMS_LOB.CREATETEMPORARY(v_src, TRUE);
    FOR rec IN (
        SELECT TEXT FROM USER_SOURCE
         WHERE NAME = 'DMF0043_GET_MAIN_SPREAD_TITLE' AND TYPE = 'PROCEDURE'
         ORDER BY LINE
    ) LOOP
        DBMS_LOB.APPEND(v_src, rec.TEXT);
    END LOOP;

    v_cnt_before := REGEXP_COUNT(v_src, v_pattern, 1, 'i');
    DBMS_OUTPUT.PUT_LINE('Pattern (IF v_user_col_cnt=0 + OPEN O_RC3) BEFORE: ' || v_cnt_before);

    IF v_cnt_before = 0 THEN
        DBMS_OUTPUT.PUT_LINE('이미 fix 적용됨 또는 SP body 패턴 변형 — SKIP.');
        DBMS_LOB.FREETEMPORARY(v_src);
    ELSE
        v_patched := REGEXP_REPLACE(v_src, v_pattern, v_replace, 1, 0, 'i');
        v_cnt_after := REGEXP_COUNT(v_patched, v_pattern, 1, 'i');
        DBMS_OUTPUT.PUT_LINE('Pattern AFTER: ' || v_cnt_after
                          || ' / replaced = ' || (v_cnt_before - v_cnt_after));

        IF v_cnt_before = v_cnt_after THEN
            RAISE_APPLICATION_ERROR(-20001,
                'REGEXP_REPLACE failed: ' || v_cnt_before || ' matched but 0 replaced. 수동 확인 필요.');
        END IF;

        v_patched := 'CREATE OR REPLACE ' || v_patched;
        EXECUTE IMMEDIATE v_patched;
        DBMS_OUTPUT.PUT_LINE('OK: DMF0043_GET_MAIN_SPREAD_TITLE patched (REGEXP). default branch now opens O_RC1.');
        DBMS_LOB.FREETEMPORARY(v_src);
    END IF;
END;
/

PROMPT === BLOCK 2 : 컴파일 상태 + OPEN 위치 (O_RC3 0건 확인) ===

SELECT OBJECT_NAME, STATUS, LAST_DDL_TIME
  FROM USER_OBJECTS
 WHERE OBJECT_NAME='DMF0043_GET_MAIN_SPREAD_TITLE';

PROMPT === BLOCK 2.1 : O_RC1 / O_RC2 / O_RC3 별 위치 ===

SELECT LINE, TEXT
  FROM USER_SOURCE
 WHERE NAME='DMF0043_GET_MAIN_SPREAD_TITLE' AND TYPE='PROCEDURE'
   AND REGEXP_LIKE(TEXT, 'OPEN\s+O_RC[123]\s+FOR', 'i')
 ORDER BY LINE;

PROMPT === BLOCK 3 : Caller 실행 검증 ===

DECLARE
  v_rc SYS_REFCURSOR;
  v_title_cnt NUMBER;
  v_temp_cnt  NUMBER;
BEGIN
  DELETE FROM GT_DMF0043_TITLE;
  DELETE FROM GT_DMF0043_TEMP;
  DELETE FROM GT_DMF0043_TEMP2;
  DELETE FROM GT_DMF0043_TEMP3;
  DELETE FROM GT_DMF0043_DATA_TABLE;

  DMF0043_GET_CONTRIBUTE_MAIN_DATA('2024','12','ALL','N','minyonglee1','ALL',v_rc);

  SELECT COUNT(*) INTO v_title_cnt FROM GT_DMF0043_TITLE;
  SELECT COUNT(*) INTO v_temp_cnt  FROM GT_DMF0043_TEMP;

  DBMS_OUTPUT.PUT_LINE('GT_DMF0043_TITLE = ' || v_title_cnt || ' rows (expect 22)');
  DBMS_OUTPUT.PUT_LINE('GT_DMF0043_TEMP  = ' || v_temp_cnt  || ' rows');

  IF v_rc%ISOPEN THEN
    DBMS_OUTPUT.PUT_LINE('Caller OK: O_RC1 opened (main cursor)');
    CLOSE v_rc;
  ELSE
    DBMS_OUTPUT.PUT_LINE('Caller WARN: cursor not opened');
  END IF;
EXCEPTION WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('Caller ERROR ' || SQLCODE || ' / ' || SQLERRM);
  DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
END;
/

COMMIT;
EXIT;
