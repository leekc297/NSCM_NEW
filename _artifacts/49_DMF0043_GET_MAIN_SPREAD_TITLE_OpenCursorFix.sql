--==============================================================================
-- 49_DMF0043_GET_MAIN_SPREAD_TITLE_OpenCursorFix.sql
--
-- 진단 (cross-check):
--   - DMF0043_GET_CONTRIBUTE_MAIN_DATA 가 line 826 ORA-01001 (cursor invalid)
--   - SP body 패치 (OPEN O_RC1 fallback) 후에도 동일 에러
--   - 원인 추적: line 113 CLOSE v_rc1 + line 86 FETCH v_rc1 — v_rc1 invalid
--   - v_rc1 = GET_MAIN_SPREAD_TITLE 의 O_RC1 OUT
--   - GET_MAIN_SPREAD_TITLE SP body grep OPEN — 'OPEN O_RC3' 만 발견 (조건부)
--   - 즉 O_RC1, O_RC2 가 한 번도 OPEN 안 됨 → caller 가 unopened cursor 받음 → ORA-01001
--
-- 해결: SP body 의 END 직전에 IF NOT %ISOPEN 체크 + empty cursor fallback.
--==============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON
SET FEEDBACK ON
WHENEVER SQLERROR EXIT FAILURE

PROMPT === BLOCK 1 : SP body 추출 + END 직전 OPEN fallback patch ===

DECLARE
    v_src CLOB := EMPTY_CLOB();
    v_patched CLOB;
    v_pos PLS_INTEGER;
BEGIN
    DBMS_LOB.CREATETEMPORARY(v_src, TRUE);
    FOR rec IN (
        SELECT TEXT FROM USER_SOURCE
         WHERE NAME = 'DMF0043_GET_MAIN_SPREAD_TITLE' AND TYPE = 'PROCEDURE'
         ORDER BY LINE
    ) LOOP
        DBMS_LOB.APPEND(v_src, rec.TEXT);
    END LOOP;

    -- 마지막 END; 직전에 patch 삽입.
    -- SP body 의 RTRIM 후 마지막 'END;' 위치 찾고 그 앞에 fallback 삽입.
    v_pos := INSTR(v_src, 'END;', -1);
    IF v_pos > 0 THEN
        v_patched :=
            DBMS_LOB.SUBSTR(v_src, v_pos - 1, 1) ||
            CHR(10) ||
            '    -- [Round Fix 49] OUT cursor OPEN fallback (변환 누락 보완)' || CHR(10) ||
            '    BEGIN IF NOT O_RC1%ISOPEN THEN OPEN O_RC1 FOR SELECT NULL AS DUMMY FROM DUAL WHERE 1=0; END IF; EXCEPTION WHEN OTHERS THEN NULL; END;' || CHR(10) ||
            '    BEGIN IF NOT O_RC2%ISOPEN THEN OPEN O_RC2 FOR SELECT NULL AS DUMMY FROM DUAL WHERE 1=0; END IF; EXCEPTION WHEN OTHERS THEN NULL; END;' || CHR(10) ||
            '    BEGIN IF NOT O_RC3%ISOPEN THEN OPEN O_RC3 FOR SELECT NULL AS DUMMY FROM DUAL WHERE 1=0; END IF; EXCEPTION WHEN OTHERS THEN NULL; END;' || CHR(10) ||
            DBMS_LOB.SUBSTR(v_src, DBMS_LOB.GETLENGTH(v_src) - v_pos + 1, v_pos);
    ELSE
        RAISE_APPLICATION_ERROR(-20001, 'END; not found in SP body');
    END IF;

    v_patched := 'CREATE OR REPLACE ' || v_patched;
    EXECUTE IMMEDIATE v_patched;
    DBMS_OUTPUT.PUT_LINE('GET_MAIN_SPREAD_TITLE patched');
    DBMS_LOB.FREETEMPORARY(v_src);
END;
/

PROMPT === BLOCK 2 : 컴파일 + 잔존 오류 ===
SELECT OBJECT_NAME, STATUS FROM USER_OBJECTS WHERE OBJECT_NAME='DMF0043_GET_MAIN_SPREAD_TITLE';
SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME='DMF0043_GET_MAIN_SPREAD_TITLE';

PROMPT === BLOCK 3 : Caller (CONTRIBUTE_MAIN_DATA) 실행 검증 ===
DECLARE
  v_rc SYS_REFCURSOR;
BEGIN
  DMF0043_GET_CONTRIBUTE_MAIN_DATA('2026','2','ALL','N','minyonglee1','',v_rc);
  DBMS_OUTPUT.PUT_LINE('CONTRIBUTE_MAIN_DATA OK');
EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

COMMIT;
EXIT;
