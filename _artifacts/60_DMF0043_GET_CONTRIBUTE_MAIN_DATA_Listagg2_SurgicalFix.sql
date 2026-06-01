--==============================================================================
-- 60_DMF0043_GET_CONTRIBUTE_MAIN_DATA_Listagg2_SurgicalFix.sql
--
-- 59 의 REGEXP_REPLACE 가 CLOB + multiline 'n' 모드에서 매칭 실패.
-- 대안: INSTR 로 anchor 위치 찾고 SUBSTR 로 surgical replace.
--==============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON
SET FEEDBACK ON
WHENEVER SQLERROR EXIT FAILURE

DECLARE
    v_src CLOB := EMPTY_CLOB();
    v_patched CLOB := EMPTY_CLOB();
    v_new2 VARCHAR2(4000);
    v_anchor_start VARCHAR2(50) := 'SELECT NVL(LISTAGG(';
    v_anchor_end   VARCHAR2(80) := 'v_ColumnData2 := SUBSTR(v_ColumnData2, 1, LENGTH(v_ColumnData2)-1);';
    p_start PLS_INTEGER;
    p_end   PLS_INTEGER;
    v_before CLOB;
    v_after  CLOB;
BEGIN
    DBMS_LOB.CREATETEMPORARY(v_src, TRUE);
    DBMS_LOB.CREATETEMPORARY(v_patched, TRUE);
    FOR rec IN (
        SELECT TEXT FROM USER_SOURCE
         WHERE NAME = 'DMF0043_GET_CONTRIBUTE_MAIN_DATA' AND TYPE = 'PROCEDURE'
         ORDER BY LINE
    ) LOOP
        DBMS_LOB.APPEND(v_src, rec.TEXT);
    END LOOP;

    -- LISTAGG #1 was already patched (line 117). Now only LISTAGG #2 remains.
    p_start := DBMS_LOB.INSTR(v_src, v_anchor_start);
    IF p_start = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'LISTAGG anchor start not found');
    END IF;
    p_end := DBMS_LOB.INSTR(v_src, v_anchor_end, p_start);
    IF p_end = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'LISTAGG anchor end not found');
    END IF;

    DBMS_OUTPUT.PUT_LINE('Anchor start pos: ' || p_start);
    DBMS_OUTPUT.PUT_LINE('Anchor end   pos: ' || p_end);

    v_new2 :=
        '-- [Fix 60] LISTAGG #2 → CLOB cursor loop' || CHR(10) ||
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

    -- before = src[1..p_start-1], after = src[p_end + length(anchor_end)..end]
    v_before := DBMS_LOB.SUBSTR(v_src, p_start - 1, 1);
    v_after  := DBMS_LOB.SUBSTR(v_src, DBMS_LOB.GETLENGTH(v_src), p_end + LENGTH(v_anchor_end));

    DBMS_LOB.APPEND(v_patched, v_before);
    DBMS_LOB.WRITEAPPEND(v_patched, LENGTH(v_new2), v_new2);
    DBMS_LOB.APPEND(v_patched, v_after);

    IF DBMS_LOB.INSTR(v_patched, 'LISTAGG') > 0 THEN
        DBMS_OUTPUT.PUT_LINE('WARN: LISTAGG still found at: ' || DBMS_LOB.INSTR(v_patched, 'LISTAGG'));
    ELSE
        DBMS_OUTPUT.PUT_LINE('LISTAGG fully removed.');
    END IF;

    DECLARE
        v_final CLOB := 'CREATE OR REPLACE ';
    BEGIN
        DBMS_LOB.CREATETEMPORARY(v_final, TRUE);
        DBMS_LOB.WRITEAPPEND(v_final, LENGTH('CREATE OR REPLACE '), 'CREATE OR REPLACE ');
        DBMS_LOB.APPEND(v_final, v_patched);
        EXECUTE IMMEDIATE v_final;
        DBMS_LOB.FREETEMPORARY(v_final);
    END;
    DBMS_OUTPUT.PUT_LINE('SP recompiled.');

    DBMS_LOB.FREETEMPORARY(v_src);
    DBMS_LOB.FREETEMPORARY(v_patched);
END;
/

PROMPT === Compile state + LISTAGG count ===
SELECT OBJECT_NAME, STATUS FROM USER_OBJECTS WHERE OBJECT_NAME='DMF0043_GET_CONTRIBUTE_MAIN_DATA';
SELECT COUNT(*) AS LISTAGG_REMAINING FROM USER_SOURCE WHERE NAME='DMF0043_GET_CONTRIBUTE_MAIN_DATA' AND TYPE='PROCEDURE' AND UPPER(TEXT) LIKE '%LISTAGG%';

PROMPT === Caller execute verify ===
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
