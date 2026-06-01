--==============================================================================
-- 65_DMF0043_GET_MAIN_SPREAD_TITLE_GTT_Cleanup.sql
--
-- 사고: ORA-56907 (PIVOT 중복 alias) — FE에서 조회 반복 시 발생.
-- 원인: `DMF0043_GET_MAIN_SPREAD_TITLE` 가 GT_GMST_TEMP_2 / GT_GMST_TEMP2_2 에
--       세션 시작 시 DELETE 없이 INSERT만 함. BE pool session 재사용 시 row 누적
--       → COLUMN_NAME 중복 → caller GT_DMF0043_TITLE 도 중복 → PIVOT alias 중복.
-- Fix: SP 시작 (BEGIN 직후) 에 DELETE 2건 삽입.
--==============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON
WHENEVER SQLERROR EXIT FAILURE

DECLARE
    v_src CLOB;
    v_patched CLOB;
    v_old VARCHAR2(4000);
    v_new VARCHAR2(4000);
BEGIN
    DBMS_LOB.CREATETEMPORARY(v_src, TRUE);
    FOR rec IN (
        SELECT TEXT FROM USER_SOURCE
         WHERE NAME='DMF0043_GET_MAIN_SPREAD_TITLE' AND TYPE='PROCEDURE' ORDER BY LINE
    ) LOOP
        DBMS_LOB.APPEND(v_src, rec.TEXT);
    END LOOP;

    -- BEGIN 직후 + JSON_OBJECT 직후 (v_in_para_data 할당) 다음에 DELETE 2 건 삽입.
    -- anchor: 첫 `INSERT INTO GT_GMST_TEMP_2` 바로 앞.
    v_old := '	/* TODO:GTT:GT_GMST_TEMP_2-->GT_GMST_TEMP_2 */' || CHR(10) || '	INSERT INTO GT_GMST_TEMP_2';
    v_new := '	-- [Fix 65] GTT 사전 정리 (BE pool session 재사용 시 누적 회피)' || CHR(10) ||
             '	DELETE FROM GT_GMST_TEMP_2;' || CHR(10) ||
             '	DELETE FROM GT_GMST_TEMP2_2;' || CHR(10) ||
             '	/* TODO:GTT:GT_GMST_TEMP_2-->GT_GMST_TEMP_2 */' || CHR(10) || '	INSERT INTO GT_GMST_TEMP_2';

    v_patched := REPLACE(v_src, v_old, v_new);

    IF DBMS_LOB.GETLENGTH(v_patched) = DBMS_LOB.GETLENGTH(v_src) THEN
        RAISE_APPLICATION_ERROR(-20001, 'Patch anchor not found');
    END IF;

    EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_patched;
    DBMS_OUTPUT.PUT_LINE('GT_GMST_TEMP_2/TEMP2_2 DELETE prepended to TITLE SP');
    DBMS_LOB.FREETEMPORARY(v_src);
END;
/

SELECT OBJECT_NAME, STATUS FROM USER_OBJECTS WHERE OBJECT_NAME='DMF0043_GET_MAIN_SPREAD_TITLE';

PROMPT === Verify : multiple sequential SP calls in same session ===
DECLARE
  v_rc SYS_REFCURSOR;
  v_cursor_id INTEGER;
  v_col_cnt INTEGER;
  v_desc DBMS_SQL.DESC_TAB;
  v_rows NUMBER;
BEGIN
  FOR i IN 1..3 LOOP
    v_rows := 0;
    DMF0043_GET_CONTRIBUTE_MAIN_DATA('2024','12','ALL','N','minyonglee1','',v_rc);
    v_cursor_id := DBMS_SQL.TO_CURSOR_NUMBER(v_rc);
    DBMS_SQL.DESCRIBE_COLUMNS(v_cursor_id, v_col_cnt, v_desc);
    WHILE DBMS_SQL.FETCH_ROWS(v_cursor_id) > 0 LOOP v_rows := v_rows + 1; END LOOP;
    DBMS_SQL.CLOSE_CURSOR(v_cursor_id);
    DBMS_OUTPUT.PUT_LINE('Call #' || i || ': rows=' || v_rows || ', cols=' || v_col_cnt);
  END LOOP;
EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('ERR: ' || SQLERRM);
END;
/

EXIT;
