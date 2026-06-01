--==============================================================================
-- 59_DMF0043_GET_CONTRIBUTE_MAIN_DATA_Listagg2_RegexFix.sql
--
-- 58 에서 LISTAGG #1 만 패치됨 (LISTAGG #2 는 탭 들여쓰기 불일치로 미적용).
-- 본 patch: REGEXP_REPLACE 로 LISTAGG #2 + ORA-22275 (DBMS_LOB.TRIM on uninit CLOB) 동시 해결.
--
-- 작성: 2026-06-01 / minyonglee1
--==============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON
SET FEEDBACK ON
WHENEVER SQLERROR EXIT FAILURE

PROMPT === BLOCK 1 : 추출 + REGEXP_REPLACE 적용 ===

DECLARE
    v_src CLOB := EMPTY_CLOB();
    v_patched CLOB;
    v_new2 VARCHAR2(4000);
BEGIN
    DBMS_LOB.CREATETEMPORARY(v_src, TRUE);
    FOR rec IN (
        SELECT TEXT FROM USER_SOURCE
         WHERE NAME = 'DMF0043_GET_CONTRIBUTE_MAIN_DATA' AND TYPE = 'PROCEDURE'
         ORDER BY LINE
    ) LOOP
        DBMS_LOB.APPEND(v_src, rec.TEXT);
    END LOOP;

    -- (a) DBMS_LOB.TRIM(v_ColumnData, 0) → v_ColumnData := ''
    --     (CLOB := '' 초기화는 LOB locator 미생성 → DBMS_LOB.TRIM 폭발 ORA-22275)
    v_src := REPLACE(v_src, 'DBMS_LOB.TRIM(v_ColumnData, 0);',  'v_ColumnData  := '''';');
    v_src := REPLACE(v_src, 'DBMS_LOB.TRIM(v_ColumnData2, 0);', 'v_ColumnData2 := '''';');

    -- (b) LISTAGG #2 — multiline regex (탭/공백 무시)
    v_new2 :=
        '    -- [Fix 59] LISTAGG #2 → CLOB cursor loop' || CHR(10) ||
        '    v_ColumnData2 := '''';' || CHR(10) ||
        '    DECLARE v_first BOOLEAN := TRUE; v_seg VARCHAR2(4000); BEGIN' || CHR(10) ||
        '      FOR r IN (SELECT COLUMN_NAME FROM GT_DMF0043_TITLE' || CHR(10) ||
        '                 WHERE TO_NUMBER(SORT_ORDER_NO) > (SELECT TO_NUMBER(SORT_ORDER_NO) FROM GT_DMF0043_TITLE WHERE COLUMN_NAME = ''EDIT_FLAG'')' || CHR(10) ||
        '                 ORDER BY TO_NUMBER(SORT_ORDER_NO)) LOOP' || CHR(10) ||
        '        IF INSTR(r.COLUMN_NAME, ''999'') <> 0 THEN' || CHR(10) ||
        '          v_seg := ''['' || r.COLUMN_NAME || '']'';' || CHR(10) ||
        '        ELSE' || CHR(10) ||
        '          v_seg := ''CAST(['' || r.COLUMN_NAME || ''] AS NUMERIC(5,2)) AS ['' || r.COLUMN_NAME || '']'';' || CHR(10) ||
        '        END IF;' || CHR(10) ||
        '        IF v_first THEN v_ColumnData2 := v_seg; v_first := FALSE;' || CHR(10) ||
        '        ELSE v_ColumnData2 := v_ColumnData2 || '','' || v_seg; END IF;' || CHR(10) ||
        '      END LOOP;' || CHR(10) ||
        '    END;';

    -- Multi-line regex: LISTAGG..v_ColumnData2 = SUBSTR(...)
    v_patched := REGEXP_REPLACE(
        v_src,
        'SELECT NVL\(LISTAGG\(.*?INTO v_ColumnData2.*?v_ColumnData2 := SUBSTR\(v_ColumnData2, 1, LENGTH\(v_ColumnData2\)-1\);',
        v_new2,
        1, 1, 'n'   -- 'n' = . matches newline
    );

    IF INSTR(v_patched, 'LISTAGG') > 0 THEN
        DBMS_OUTPUT.PUT_LINE('WARNING: LISTAGG still present — patch failed.');
        RAISE_APPLICATION_ERROR(-20001, 'LISTAGG #2 regex failed');
    ELSE
        DBMS_OUTPUT.PUT_LINE('LISTAGG #2 patched OK.');
    END IF;

    v_patched := 'CREATE OR REPLACE ' || v_patched;
    EXECUTE IMMEDIATE v_patched;
    DBMS_OUTPUT.PUT_LINE('SP recompiled.');
    DBMS_LOB.FREETEMPORARY(v_src);
END;
/

PROMPT === BLOCK 2 : Compile state + LISTAGG count ===
SELECT OBJECT_NAME, STATUS FROM USER_OBJECTS WHERE OBJECT_NAME='DMF0043_GET_CONTRIBUTE_MAIN_DATA';
SELECT COUNT(*) AS LISTAGG_REMAINING FROM USER_SOURCE WHERE NAME='DMF0043_GET_CONTRIBUTE_MAIN_DATA' AND TYPE='PROCEDURE' AND UPPER(TEXT) LIKE '%LISTAGG%';

PROMPT === BLOCK 3 : Caller execute verify ===
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

  DBMS_OUTPUT.PUT_LINE('GT_DMF0043_TITLE      = ' || v_title_cnt || ' rows');
  DBMS_OUTPUT.PUT_LINE('GT_DMF0043_TEMP       = ' || v_temp_cnt  || ' rows');
  DBMS_OUTPUT.PUT_LINE('GT_DMF0043_DATA_TABLE = ' || v_data_cnt  || ' rows');
  BEGIN CLOSE v_rc; EXCEPTION WHEN OTHERS THEN NULL; END;
EXCEPTION WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('CALLER ERROR: ' || SQLERRM);
END;
/

EXIT;
