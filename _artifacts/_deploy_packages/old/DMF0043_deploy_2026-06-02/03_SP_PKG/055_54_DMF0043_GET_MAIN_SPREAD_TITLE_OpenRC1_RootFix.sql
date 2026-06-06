--==============================================================================
-- 055_54_DMF0043_GET_MAIN_SPREAD_TITLE_OpenRC1_RootFix.sql
--
-- 사고: DMF0043 조회 시 -9994 SQL Error
--       내부 ORA: ORA-01001 커서 부적합 at DMF0043_GET_CONTRIBUTE_MAIN_DATA line 845
--       (OPEN O_RC1 FOR v_Query — v_Query 의 PIVOT IN 절이 비어 invalid SQL)
--
-- 원인: DMF0043_GET_MAIN_SPREAD_TITLE 의 default 분기 (v_user_col_cnt = 0,
--       즉 사용자 커스텀 titleset 없음 — minyonglee1 default) 가 22-컬럼
--       default titleset 을 OPEN O_RC3 FOR 로 엽니다.
--       그러나 caller (DMF0043_GET_CONTRIBUTE_MAIN_DATA) 는 v_rc1 만 FETCH.
--       → caller 가 빈 cursor fetch → GT_DMF0043_TITLE 0건
--       → 동적 PIVOT 컬럼 0개 → v_Query invalid → OPEN ORA-01001.
--
-- Fix: line 95-96 의 default 분기에서
--      OPEN O_RC3 FOR  →  OPEN O_RC1 FOR
--      (22-컬럼 default result set 을 caller fetch 대상 cursor 에 OPEN)
--
-- 멱등: REGEXP_COUNT 가드로 fix 미적용 시 패치, fix 완료 시 SKIP
-- 실행: SCM_MGR 세션 (USER_SOURCE 자기 schema 조회). SQL*Plus 또는 DBeaver 모두 OK.
-- 원본: _artifacts/54_DMF0043_GET_MAIN_SPREAD_TITLE_OpenRC1_RootFix.sql (2026-06-01)
--
-- 작성: 2026-06-04
--==============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON
SET FEEDBACK ON
WHENEVER SQLERROR EXIT FAILURE

PROMPT === BLOCK 1 : SP body 추출 + O_RC3 -> O_RC1 root fix ===

DECLARE
    v_src CLOB := EMPTY_CLOB();
    v_patched CLOB;
    v_old VARCHAR2(100) := '	IF v_user_col_cnt = 0 THEN' || CHR(10) || '		OPEN O_RC3 FOR';
    v_new VARCHAR2(100) := '	IF v_user_col_cnt = 0 THEN' || CHR(10) || '		OPEN O_RC1 FOR';
    v_cnt_before PLS_INTEGER;
    v_cnt_after  PLS_INTEGER;
    v_pattern    VARCHAR2(200) := 'IF\s+v_user_col_cnt\s*=\s*0\s+THEN\s*' || CHR(10) || '\s*OPEN\s+O_RC3\s+FOR';
BEGIN
    DBMS_LOB.CREATETEMPORARY(v_src, TRUE);
    FOR rec IN (
        SELECT TEXT FROM USER_SOURCE
         WHERE NAME = 'DMF0043_GET_MAIN_SPREAD_TITLE' AND TYPE = 'PROCEDURE'
         ORDER BY LINE
    ) LOOP
        DBMS_LOB.APPEND(v_src, rec.TEXT);
    END LOOP;

    -- 멱등 가드: 이미 fix 적용된 상태 (default branch 가 O_RC1 이면 패턴 0건)
    v_cnt_before := REGEXP_COUNT(v_src, v_pattern);
    DBMS_OUTPUT.PUT_LINE('Pattern (IF v_user_col_cnt=0 + OPEN O_RC3) BEFORE: ' || v_cnt_before);

    IF v_cnt_before = 0 THEN
        DBMS_OUTPUT.PUT_LINE('이미 fix 적용됨 또는 SP body 변형 — SKIP (멱등).');
        DBMS_LOB.FREETEMPORARY(v_src);
    ELSE
        v_patched := REPLACE(v_src, v_old, v_new);
        v_cnt_after := REGEXP_COUNT(v_patched, v_pattern);
        DBMS_OUTPUT.PUT_LINE('Pattern AFTER: ' || v_cnt_after || ' / replaced = ' || (v_cnt_before - v_cnt_after));

        IF v_cnt_before = v_cnt_after THEN
            RAISE_APPLICATION_ERROR(-20001,
                'Patch failed: 패턴 미매치. SP body line 95-96 들여쓰기/줄바꿈 변형. 수동 확인 필요.');
        END IF;

        v_patched := 'CREATE OR REPLACE ' || v_patched;
        EXECUTE IMMEDIATE v_patched;
        DBMS_OUTPUT.PUT_LINE('OK: DMF0043_GET_MAIN_SPREAD_TITLE patched. default branch now opens O_RC1.');
        DBMS_LOB.FREETEMPORARY(v_src);
    END IF;
END;
/

PROMPT === BLOCK 2 : 컴파일 상태 + OPEN 위치 ===

SELECT OBJECT_NAME, STATUS, LAST_DDL_TIME
  FROM USER_OBJECTS
 WHERE OBJECT_NAME='DMF0043_GET_MAIN_SPREAD_TITLE';

SELECT LINE, TEXT
  FROM USER_SOURCE
 WHERE NAME='DMF0043_GET_MAIN_SPREAD_TITLE' AND TYPE='PROCEDURE'
   AND REGEXP_LIKE(TEXT, 'OPEN\s+O_RC[123]\s+FOR', 'i')
 ORDER BY LINE;

PROMPT === BLOCK 3 : Caller 실행 검증 (GT_TITLE 적재 + cursor open) ===

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
    DBMS_OUTPUT.PUT_LINE('Caller OK: O_RC1 opened (main data cursor)');
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
