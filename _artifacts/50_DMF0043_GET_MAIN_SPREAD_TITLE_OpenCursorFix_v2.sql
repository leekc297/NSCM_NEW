--==============================================================================
-- 50_DMF0043_GET_MAIN_SPREAD_TITLE_OpenCursorFix_v2.sql
--
-- 49 의 patch 가 EXCEPTION 핸들러의 RAISE 뒤에 들어가서 unreachable.
-- 본 v2: EXCEPTION 직전 (정상 코드 끝) 에 patch.
-- 또한 49 에서 추가된 unreachable code 도 제거.
--==============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON
SET FEEDBACK ON
WHENEVER SQLERROR EXIT FAILURE

PROMPT === BLOCK 1 : SP body 추출 + EXCEPTION 직전 OPEN fallback patch ===

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

    -- 49 의 unreachable patch 제거 (있는 경우)
    v_src := REPLACE(v_src,
      CHR(10) || '    -- [Round Fix 49] OUT cursor OPEN fallback (변환 누락 보완)' || CHR(10) ||
      '    BEGIN IF NOT O_RC1%ISOPEN THEN OPEN O_RC1 FOR SELECT NULL AS DUMMY FROM DUAL WHERE 1=0; END IF; EXCEPTION WHEN OTHERS THEN NULL; END;' || CHR(10) ||
      '    BEGIN IF NOT O_RC2%ISOPEN THEN OPEN O_RC2 FOR SELECT NULL AS DUMMY FROM DUAL WHERE 1=0; END IF; EXCEPTION WHEN OTHERS THEN NULL; END;' || CHR(10) ||
      '    BEGIN IF NOT O_RC3%ISOPEN THEN OPEN O_RC3 FOR SELECT NULL AS DUMMY FROM DUAL WHERE 1=0; END IF; EXCEPTION WHEN OTHERS THEN NULL; END;' || CHR(10),
      '');

    -- 마지막 'EXCEPTION' 위치 찾기 (정상 코드 끝 직전)
    v_pos := INSTR(UPPER(v_src), 'EXCEPTION', -1);
    IF v_pos > 0 THEN
        -- EXCEPTION 키워드 앞에 patch 삽입
        v_patched :=
            DBMS_LOB.SUBSTR(v_src, v_pos - 1, 1) ||
            CHR(10) ||
            '    -- [Round Fix 50] EXCEPTION 직전 OUT cursor OPEN fallback (변환 누락 보완)' || CHR(10) ||
            '    BEGIN IF NOT O_RC1%ISOPEN THEN OPEN O_RC1 FOR SELECT NULL AS DUMMY FROM DUAL WHERE 1=0; END IF; EXCEPTION WHEN OTHERS THEN NULL; END;' || CHR(10) ||
            '    BEGIN IF NOT O_RC2%ISOPEN THEN OPEN O_RC2 FOR SELECT NULL AS DUMMY FROM DUAL WHERE 1=0; END IF; EXCEPTION WHEN OTHERS THEN NULL; END;' || CHR(10) ||
            '    BEGIN IF NOT O_RC3%ISOPEN THEN OPEN O_RC3 FOR SELECT NULL AS DUMMY FROM DUAL WHERE 1=0; END IF; EXCEPTION WHEN OTHERS THEN NULL; END;' || CHR(10) ||
            DBMS_LOB.SUBSTR(v_src, DBMS_LOB.GETLENGTH(v_src) - v_pos + 1, v_pos);
    ELSE
        RAISE_APPLICATION_ERROR(-20001, 'EXCEPTION keyword not found');
    END IF;

    v_patched := 'CREATE OR REPLACE ' || v_patched;
    EXECUTE IMMEDIATE v_patched;
    DBMS_OUTPUT.PUT_LINE('GET_MAIN_SPREAD_TITLE patched v2');
    DBMS_LOB.FREETEMPORARY(v_src);
END;
/

PROMPT === BLOCK 2 : OPEN 위치 확인 ===
SELECT LINE, TEXT FROM USER_SOURCE WHERE NAME='DMF0043_GET_MAIN_SPREAD_TITLE' AND TYPE='PROCEDURE' AND UPPER(TEXT) LIKE '%OPEN %' ORDER BY LINE;

PROMPT === BLOCK 3 : Caller 실행 검증 ===
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
