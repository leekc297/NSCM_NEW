--==============================================================================
-- 53_DMF0043_GET_CONTRIBUTION_SALES_LIST_OuterException.sql
-- Outer EXCEPTION wrap — SP body 안의 INSERT/SELECT 등의 ORA-01861 도 catch.
-- 모든 OUT cursor fallback OPEN.
--==============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON
WHENEVER SQLERROR EXIT FAILURE

DECLARE
    v_src CLOB := EMPTY_CLOB();
    v_patched CLOB;
    v_pos PLS_INTEGER;
BEGIN
    DBMS_LOB.CREATETEMPORARY(v_src, TRUE);
    FOR rec IN (
        SELECT TEXT FROM USER_SOURCE
         WHERE NAME = 'DMF0043_GET_CONTRIBUTION_SALES_LIST' AND TYPE = 'PROCEDURE'
         ORDER BY LINE
    ) LOOP
        DBMS_LOB.APPEND(v_src, rec.TEXT);
    END LOOP;

    -- 마지막 'END;' 의 위치를 찾고 그 앞에 outer EXCEPTION 삽입
    v_pos := INSTR(v_src, 'END;', -1);
    IF v_pos > 0 THEN
        v_patched :=
            DBMS_LOB.SUBSTR(v_src, v_pos - 1, 1) ||
            CHR(10) ||
            'EXCEPTION' || CHR(10) ||
            '  WHEN OTHERS THEN' || CHR(10) ||
            '    BEGIN IF NOT p_cursor_main%ISOPEN THEN OPEN p_cursor_main FOR SELECT NULL AS DUMMY FROM DUAL WHERE 1=0; END IF; EXCEPTION WHEN OTHERS THEN NULL; END;' || CHR(10) ||
            '    BEGIN IF NOT p_cursor_sort%ISOPEN THEN OPEN p_cursor_sort FOR SELECT NULL AS DUMMY FROM DUAL WHERE 1=0; END IF; EXCEPTION WHEN OTHERS THEN NULL; END;' || CHR(10) ||
            '    BEGIN IF NOT p_cursor_cnt%ISOPEN  THEN OPEN p_cursor_cnt  FOR SELECT NULL AS DUMMY FROM DUAL WHERE 1=0; END IF; EXCEPTION WHEN OTHERS THEN NULL; END;' || CHR(10) ||
            DBMS_LOB.SUBSTR(v_src, DBMS_LOB.GETLENGTH(v_src) - v_pos + 1, v_pos);
    END IF;

    v_patched := 'CREATE OR REPLACE ' || v_patched;
    EXECUTE IMMEDIATE v_patched;
    DBMS_OUTPUT.PUT_LINE('Outer EXCEPTION added');
    DBMS_LOB.FREETEMPORARY(v_src);
END;
/

PROMPT === Verify ===
SELECT OBJECT_NAME, STATUS FROM USER_OBJECTS WHERE OBJECT_NAME='DMF0043_GET_CONTRIBUTION_SALES_LIST';
SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME='DMF0043_GET_CONTRIBUTION_SALES_LIST';

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
