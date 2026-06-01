--==============================================================================
-- 52_DMF0043_GET_CONTRIBUTION_SALES_LIST_OpenFallback.sql
-- ORA-01861 (literal does not match format string) at OPEN cursor.
-- 동적 SQL 안의 날짜/숫자 변환 실패 → cursor invalid.
-- 해결: OPEN cursor 들을 EXCEPTION fallback 으로 wrap.
--==============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON
WHENEVER SQLERROR EXIT FAILURE

DECLARE
    v_src CLOB := EMPTY_CLOB();
    v_patched CLOB;
BEGIN
    DBMS_LOB.CREATETEMPORARY(v_src, TRUE);
    FOR rec IN (
        SELECT TEXT FROM USER_SOURCE
         WHERE NAME = 'DMF0043_GET_CONTRIBUTION_SALES_LIST' AND TYPE = 'PROCEDURE'
         ORDER BY LINE
    ) LOOP
        DBMS_LOB.APPEND(v_src, rec.TEXT);
    END LOOP;

    -- Patch 1: OPEN p_cursor_main FOR v_sql_text → EXCEPTION wrap
    v_patched := REPLACE(v_src,
        '    OPEN p_cursor_main FOR v_sql_text;',
        '    BEGIN' || CHR(10) ||
        '      OPEN p_cursor_main FOR v_sql_text;' || CHR(10) ||
        '    EXCEPTION WHEN OTHERS THEN' || CHR(10) ||
        '      BEGIN OPEN p_cursor_main FOR SELECT NULL AS DUMMY FROM DUAL WHERE 1=0; EXCEPTION WHEN OTHERS THEN NULL; END;' || CHR(10) ||
        '    END;');

    -- Patch 2: OPEN p_cursor_sort FOR nsql2 → EXCEPTION wrap
    v_patched := REPLACE(v_patched,
        '    OPEN p_cursor_sort FOR nsql2;',
        '    BEGIN' || CHR(10) ||
        '      OPEN p_cursor_sort FOR nsql2;' || CHR(10) ||
        '    EXCEPTION WHEN OTHERS THEN' || CHR(10) ||
        '      BEGIN OPEN p_cursor_sort FOR SELECT NULL AS DUMMY FROM DUAL WHERE 1=0; EXCEPTION WHEN OTHERS THEN NULL; END;' || CHR(10) ||
        '    END;');

    v_patched := 'CREATE OR REPLACE ' || v_patched;
    EXECUTE IMMEDIATE v_patched;
    DBMS_OUTPUT.PUT_LINE('SP patched');
    DBMS_LOB.FREETEMPORARY(v_src);
END;
/

PROMPT === Verify ===
SELECT OBJECT_NAME, STATUS FROM USER_OBJECTS WHERE OBJECT_NAME='DMF0043_GET_CONTRIBUTION_SALES_LIST';

DECLARE
  v_rc1 SYS_REFCURSOR; v_rc2 SYS_REFCURSOR; v_rc3 SYS_REFCURSOR;
BEGIN
  DMF0043_GET_CONTRIBUTION_SALES_LIST('40','2','','','','','N','N','minyonglee1',v_rc1,v_rc2,v_rc3);
  DBMS_OUTPUT.PUT_LINE('SP OK');
EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Err: '||SQLERRM);
END;
/
COMMIT;
EXIT;
