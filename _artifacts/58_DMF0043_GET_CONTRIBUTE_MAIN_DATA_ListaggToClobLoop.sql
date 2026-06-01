--==============================================================================
-- 58_DMF0043_GET_CONTRIBUTE_MAIN_DATA_ListaggToClobLoop.sql
--
-- 사고: ORA-01489 (result of string concatenation is too long).
-- 원인: SP `DMF0043_GET_CONTRIBUTE_MAIN_DATA` 의 LISTAGG 2건이 VARCHAR2 4000자 한도 초과.
--       동적 컬럼 (12개월 × ~14 OS_CORP = 168 컬럼 × 평균 30자 = ~5000자) → overflow.
-- 결정: LISTAGG → PL/SQL CURSOR LOOP + CLOB concat (length 무제한, anti-simplification 의미 보존).
--
-- 작성: 2026-06-01 / minyonglee1
--==============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON
SET FEEDBACK ON
WHENEVER SQLERROR EXIT FAILURE

PROMPT === BLOCK 1 : SP body 추출 + LISTAGG 2건 → CLOB LOOP 패치 ===

DECLARE
    v_src CLOB := EMPTY_CLOB();
    v_patched CLOB;
    v_old1 VARCHAR2(4000);
    v_new1 VARCHAR2(4000);
    v_old2 VARCHAR2(4000);
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

    -- LISTAGG #1 (lines 117-121)
    v_old1 :=
        '    SELECT NVL(LISTAGG(''['' || COLUMN_NAME || ''],'', '''') WITHIN GROUP (ORDER BY TO_NUMBER(SORT_ORDER_NO)), '''')' || CHR(10) ||
        '      INTO v_ColumnData' || CHR(10) ||
        '      FROM GT_DMF0043_TITLE' || CHR(10) ||
        '     WHERE TO_NUMBER(SORT_ORDER_NO) > (SELECT TO_NUMBER(SORT_ORDER_NO) FROM GT_DMF0043_TITLE WHERE COLUMN_NAME = ''EDIT_FLAG'');' || CHR(10) ||
        '    v_ColumnData := SUBSTR(v_ColumnData, 1, LENGTH(v_ColumnData)-1);';
    v_new1 :=
        '    -- [Fix 58] LISTAGG → CLOB cursor loop (ORA-01489 회피, 길이 무제한)' || CHR(10) ||
        '    DBMS_LOB.TRIM(v_ColumnData, 0);' || CHR(10) ||
        '    DECLARE v_first BOOLEAN := TRUE; BEGIN' || CHR(10) ||
        '      FOR r IN (SELECT COLUMN_NAME FROM GT_DMF0043_TITLE' || CHR(10) ||
        '                 WHERE TO_NUMBER(SORT_ORDER_NO) > (SELECT TO_NUMBER(SORT_ORDER_NO) FROM GT_DMF0043_TITLE WHERE COLUMN_NAME = ''EDIT_FLAG'')' || CHR(10) ||
        '                 ORDER BY TO_NUMBER(SORT_ORDER_NO)) LOOP' || CHR(10) ||
        '        IF v_first THEN v_ColumnData := ''['' || r.COLUMN_NAME || '']''; v_first := FALSE;' || CHR(10) ||
        '        ELSE v_ColumnData := v_ColumnData || '',['' || r.COLUMN_NAME || '']''; END IF;' || CHR(10) ||
        '      END LOOP;' || CHR(10) ||
        '    END;';

    -- LISTAGG #2 (lines 124-131)
    v_old2 :=
        '    SELECT NVL(LISTAGG(' || CHR(10) ||
        '	CASE WHEN INSTR(COLUMN_NAME, ''999'') <> 0 THEN ''['' || COLUMN_NAME || ''],''' || CHR(10) ||
        '	    ELSE ''CAST(['' || COLUMN_NAME || ''] AS NUMERIC(5,2)) AS ['' || COLUMN_NAME || ''],'' END' || CHR(10) ||
        '	, '''') WITHIN GROUP (ORDER BY TO_NUMBER(SORT_ORDER_NO)), '''')' || CHR(10) ||
        '      INTO v_ColumnData2' || CHR(10) ||
        '      FROM GT_DMF0043_TITLE' || CHR(10) ||
        '     WHERE TO_NUMBER(SORT_ORDER_NO) > (SELECT TO_NUMBER(SORT_ORDER_NO) FROM GT_DMF0043_TITLE WHERE COLUMN_NAME = ''EDIT_FLAG'');' || CHR(10) ||
        '    v_ColumnData2 := SUBSTR(v_ColumnData2, 1, LENGTH(v_ColumnData2)-1);';
    v_new2 :=
        '    -- [Fix 58] LISTAGG → CLOB cursor loop (ORA-01489 회피, 길이 무제한)' || CHR(10) ||
        '    DBMS_LOB.TRIM(v_ColumnData2, 0);' || CHR(10) ||
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

    v_patched := REPLACE(v_src, v_old1, v_new1);
    v_patched := REPLACE(v_patched, v_old2, v_new2);

    IF INSTR(v_patched, 'LISTAGG') > 0 THEN
        DBMS_OUTPUT.PUT_LINE('WARNING: LISTAGG still present after patch — investigate.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Both LISTAGG occurrences replaced.');
    END IF;

    v_patched := 'CREATE OR REPLACE ' || v_patched;
    EXECUTE IMMEDIATE v_patched;
    DBMS_OUTPUT.PUT_LINE('DMF0043_GET_CONTRIBUTE_MAIN_DATA patched.');
    DBMS_LOB.FREETEMPORARY(v_src);
END;
/

PROMPT === BLOCK 2 : Compile state ===
SELECT OBJECT_NAME, STATUS FROM USER_OBJECTS WHERE OBJECT_NAME='DMF0043_GET_CONTRIBUTE_MAIN_DATA';

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
