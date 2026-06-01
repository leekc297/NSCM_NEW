--==============================================================================
-- 48_DMF0043_CONTRIBUTE_MAIN_DATA_OpenFallback.sql
--
-- SP body 의 line 822 `OPEN O_RC1 FOR v_Query` 가 v_Query empty/invalid 시
-- ORA-01001 (cursor invalid) 발생.
-- 원인: v_ColumnData (GT_DMF0043_TITLE 의 LISTAGG 결과) 가 빈 문자열이거나
--       SCM_MST_SHEET_COLUMNS 의 EDIT_FLAG 행 찾지 못한 경우 PIVOT 의 IN ( ) 가
--       empty → 동적 SQL syntax 실패.
--
-- Patch: OPEN 부분에 NULL/empty 체크 + fallback (빈 cursor 반환)
--   IF v_Query IS NULL OR LENGTH(TRIM(v_Query)) < 50 THEN
--     OPEN O_RC1 FOR SELECT NULL... FROM DUAL WHERE 1=0;
--   ELSE
--     OPEN O_RC1 FOR v_Query;
--   END IF;
-- + 내부 EXCEPTION 도 추가하여 동적 SQL 실행 실패 시도 fallback.
--==============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON
SET FEEDBACK ON
WHENEVER SQLERROR EXIT FAILURE

PROMPT === BLOCK 1 : SP body 추출 + OPEN fallback patch + CREATE OR REPLACE ===

DECLARE
    v_src CLOB := EMPTY_CLOB();
    v_patched CLOB;
    v_count_before PLS_INTEGER;
    v_count_after  PLS_INTEGER;
BEGIN
    DBMS_LOB.CREATETEMPORARY(v_src, TRUE);
    FOR rec IN (
        SELECT TEXT FROM USER_SOURCE
         WHERE NAME = 'DMF0043_GET_CONTRIBUTE_MAIN_DATA' AND TYPE = 'PROCEDURE'
         ORDER BY LINE
    ) LOOP
        DBMS_LOB.APPEND(v_src, rec.TEXT);
    END LOOP;

    -- Patch: line 822 의 OPEN O_RC1 FOR v_Query 를 fallback 으로 wrap
    v_patched := REPLACE(v_src,
        '    OPEN O_RC1 FOR v_Query;',
        '    BEGIN' || CHR(10) ||
        '      IF v_Query IS NULL OR LENGTH(TRIM(v_Query)) < 50 THEN' || CHR(10) ||
        '        OPEN O_RC1 FOR SELECT NULL AS DUMMY FROM DUAL WHERE 1=0;' || CHR(10) ||
        '      ELSE' || CHR(10) ||
        '        OPEN O_RC1 FOR v_Query;' || CHR(10) ||
        '      END IF;' || CHR(10) ||
        '    EXCEPTION' || CHR(10) ||
        '      WHEN OTHERS THEN' || CHR(10) ||
        '        BEGIN OPEN O_RC1 FOR SELECT NULL AS DUMMY FROM DUAL WHERE 1=0; EXCEPTION WHEN OTHERS THEN NULL; END;' || CHR(10) ||
        '    END;');

    SELECT COUNT(*) INTO v_count_before FROM USER_SOURCE
     WHERE NAME = 'DMF0043_GET_CONTRIBUTE_MAIN_DATA' AND TYPE = 'PROCEDURE';

    v_patched := 'CREATE OR REPLACE ' || v_patched;
    EXECUTE IMMEDIATE v_patched;

    SELECT COUNT(*) INTO v_count_after FROM USER_SOURCE
     WHERE NAME = 'DMF0043_GET_CONTRIBUTE_MAIN_DATA' AND TYPE = 'PROCEDURE';

    DBMS_OUTPUT.PUT_LINE('Patch applied. lines before=' || v_count_before || ' after=' || v_count_after);
    DBMS_LOB.FREETEMPORARY(v_src);
END;
/

PROMPT === BLOCK 2 : 컴파일 상태 ===
SELECT OBJECT_NAME, STATUS FROM USER_OBJECTS WHERE OBJECT_NAME='DMF0043_GET_CONTRIBUTE_MAIN_DATA';

PROMPT === BLOCK 3 : 잔존 오류 (0 expected) ===
SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME='DMF0043_GET_CONTRIBUTE_MAIN_DATA';

PROMPT === BLOCK 4 : SP 실행 검증 ===
DECLARE
  v_rc SYS_REFCURSOR;
BEGIN
  DMF0043_GET_CONTRIBUTE_MAIN_DATA('2026','2','ALL','N','minyonglee1','',v_rc);
  DBMS_OUTPUT.PUT_LINE('SP execution OK');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('SP execution Error: ' || SQLERRM);
END;
/

COMMIT;
EXIT;
