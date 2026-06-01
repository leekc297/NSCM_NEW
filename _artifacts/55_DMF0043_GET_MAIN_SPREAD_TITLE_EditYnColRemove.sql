--==============================================================================
-- 55_DMF0043_GET_MAIN_SPREAD_TITLE_EditYnColRemove.sql
--
-- 54 적용 후 caller test → ORA-06504 (Return types of Result Set variables or query do not match)
-- 원인: O_RC1 default 분기의 3 UNION SELECT 가 23개 컬럼 (`EDIT_YN` 23번째).
--       caller (DMF0043_GET_CONTRIBUTE_MAIN_DATA) FETCH 는 22개 변수.
-- 결정: caller 가 EDIT_YN 미사용 → SELECT 에서 EDIT_YN 컬럼만 제거.
--        INNER JOIN PKG_SCM_USER_MNU.PR_SCM_EDIT_YN (permission filter) 는 유지.
--
-- 작성: 2026-06-01 / minyonglee1
--==============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON
SET FEEDBACK ON
WHENEVER SQLERROR EXIT FAILURE

PROMPT === BLOCK 1 : SP body 추출 + EDIT_YN column 제거 ===

DECLARE
    v_src CLOB := EMPTY_CLOB();
    v_patched CLOB;
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

    v_cnt_before := REGEXP_COUNT(v_src, 'EDIT_YN', 1, 'i');
    DBMS_OUTPUT.PUT_LINE('EDIT_YN references BEFORE: ' || v_cnt_before);

    -- 1st SELECT (default titleset) — `, tei.EDIT_YN` 줄 제거
    --   원형: `				, tei.EDIT_YN` (이전 줄 끝 ',' 없음 — 직전 라인이 DIVISION_ID)
    v_patched := REPLACE(v_src,
        CHR(10) || '				, tei.EDIT_YN' || CHR(10),
        CHR(10));

    -- 2nd SELECT (VISIBLE_FLAG='N' hidden cols) — `, 'N' AS EDIT_YN`
    v_patched := REPLACE(v_patched,
        CHR(10) || '				, ''N'' AS EDIT_YN' || CHR(10),
        CHR(10));

    -- 3rd SELECT (dynamic month columns) — `, 'N' AS EDIT_YN` (탭 다름)
    v_patched := REPLACE(v_patched,
        CHR(10) || '					, ''N'' AS EDIT_YN' || CHR(10),
        CHR(10));

    v_cnt_after := REGEXP_COUNT(v_patched, 'EDIT_YN', 1, 'i');
    DBMS_OUTPUT.PUT_LINE('EDIT_YN references AFTER : ' || v_cnt_after);

    IF v_cnt_before = v_cnt_after THEN
        RAISE_APPLICATION_ERROR(-20001,
            'Patch failed: EDIT_YN pattern not matched (whitespace mismatch).');
    END IF;

    v_patched := 'CREATE OR REPLACE ' || v_patched;
    EXECUTE IMMEDIATE v_patched;
    DBMS_OUTPUT.PUT_LINE('DMF0043_GET_MAIN_SPREAD_TITLE: EDIT_YN columns removed from 3 UNION SELECTs');
    DBMS_LOB.FREETEMPORARY(v_src);
END;
/

PROMPT === BLOCK 2 : 컴파일 상태 ===
SELECT OBJECT_NAME, STATUS FROM USER_OBJECTS WHERE OBJECT_NAME='DMF0043_GET_MAIN_SPREAD_TITLE';
SELECT COUNT(*) AS REMAINING_EDIT_YN FROM USER_SOURCE WHERE NAME='DMF0043_GET_MAIN_SPREAD_TITLE' AND TYPE='PROCEDURE' AND UPPER(TEXT) LIKE '%EDIT_YN%';

PROMPT === BLOCK 3 : Caller 실행 검증 (GT_TITLE / DATA_TABLE 적재 카운트) ===
DECLARE
  v_rc SYS_REFCURSOR;
  v_title_cnt NUMBER;
  v_temp_cnt  NUMBER;
  v_data_cnt  NUMBER;
BEGIN
  DELETE FROM GT_DMF0043_TITLE;
  DELETE FROM GT_DMF0043_TEMP;
  DELETE FROM GT_DMF0043_TEMP2;
  DELETE FROM GT_DMF0043_TEMP3;
  DELETE FROM GT_DMF0043_DATA_TABLE;

  DMF0043_GET_CONTRIBUTE_MAIN_DATA('2023','8','ALL','N','minyonglee1','',v_rc);

  SELECT COUNT(*) INTO v_title_cnt FROM GT_DMF0043_TITLE;
  SELECT COUNT(*) INTO v_temp_cnt  FROM GT_DMF0043_TEMP;
  SELECT COUNT(*) INTO v_data_cnt  FROM GT_DMF0043_DATA_TABLE;

  DBMS_OUTPUT.PUT_LINE('GT_DMF0043_TITLE      = ' || v_title_cnt || ' rows (expect 14+)');
  DBMS_OUTPUT.PUT_LINE('GT_DMF0043_TEMP       = ' || v_temp_cnt  || ' rows (expect > 0)');
  DBMS_OUTPUT.PUT_LINE('GT_DMF0043_DATA_TABLE = ' || v_data_cnt  || ' rows (expect > 0)');
  BEGIN CLOSE v_rc; EXCEPTION WHEN OTHERS THEN NULL; END;
EXCEPTION WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('CALLER ERROR: ' || SQLERRM);
END;
/

COMMIT;
EXIT;
