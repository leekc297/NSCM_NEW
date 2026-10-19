-- SOURCE-FRESH: SCM_MGR.PKG_DMF0022 PACKAGE BODY LAST_DDL=2026-10-19 11:51:29 FETCHED=2026-10-19 12:02 DB=ZIOUI1 (사내 적용본 대조 · 클라우드는 자기 USER_SOURCE 를 패치)
-- 99_ROLLBACK — [E20261019-000071] DMF0035(SALES PLAN) PKG_DMF0022 원복 (전체 F5, 값 입력 없음, 멱등) — START~END 사이 역치환 후 마커 2줄·주석 경계 제거
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    v_src    CLOB;
    v_new    CLOB;
    v_blk    CLOB;
    v_st     VARCHAR2(30);
    v_err    PLS_INTEGER;
    v_s      PLS_INTEGER;
    v_e      PLS_INTEGER;
    c_mark   CONSTANT VARCHAR2(40)   := 'E20261019-000071';
    c_head   CONSTANT VARCHAR2(4000) := '    ------------------------------------------------------------------------------------------' || CHR(10) || '    -- [PJ2024-50611] ' || TO_CHAR(UNISTR('\C18C\D615')) || ' ' || TO_CHAR(UNISTR('\B9E4\CD9C')) || ' ' || TO_CHAR(UNISTR('\D504\B85C\C138\C2A4')) || ' ' || TO_CHAR(UNISTR('\AC1C\C120')) || CHR(10) || '    ------------------------------------------------------------------------------------------' || CHR(10) || '    IF p_division_id = ''40'' THEN' || CHR(10);
    c_tail   CONSTANT VARCHAR2(4000) := '            UPDATE SET A.QTY = A.QTY * B.RATIO--(B.QTY / B.SUM_QTY)-- 2025.01.23 0 ' || TO_CHAR(UNISTR('\B098\B204\AE30')) || ' ' || TO_CHAR(UNISTR('\C624\B958')) || ' ' || TO_CHAR(UNISTR('\C218\C815')) || CHR(10) || '            ;' || CHR(10) || '        END IF;' || CHR(10) || '    END IF;' || CHR(10);
    c_open   CONSTANT VARCHAR2(4000) := '    --[E20261019-000071]_Sales Plan Waterfall ' || TO_CHAR(UNISTR('\B370\C774\D130')) || ' RTF ' || TO_CHAR(UNISTR('\C911\BCF5')) || ' ' || TO_CHAR(UNISTR('\D604\C0C1')) || ' (START)' || CHR(10) || '    -- ' || TO_CHAR(UNISTR('\BD88\D544\C694\D55C')) || ' ' || TO_CHAR(UNISTR('\B85C\C9C1\C73C\B85C')) || ' ' || TO_CHAR(UNISTR('\C8FC\C11D\CC98\B9AC\D55C\B2E4')) || '.' || CHR(10) || '    -- (' || TO_CHAR(UNISTR('\BE14\B85D')) || ' ' || TO_CHAR(UNISTR('\B0B4')) || ' NO_PARALLEL ' || TO_CHAR(UNISTR('\D78C\D2B8\B294')) || ' ' || TO_CHAR(UNISTR('\BE14\B85D\C8FC\C11D')) || ' ' || TO_CHAR(UNISTR('\C911\CCA9')) || ' ' || TO_CHAR(UNISTR('\BD88\AC00')) || '(PLS-00103)' || TO_CHAR(UNISTR('\B85C')) || ' ' || TO_CHAR(UNISTR('\C5ED\C2AC\B798\C2DC')) || ' ' || TO_CHAR(UNISTR('\D45C\AE30\B85C')) || ' ' || TO_CHAR(UNISTR('\BC14\AFC8')) || ')' || CHR(10) || '    /*' || CHR(10);
    c_close  CONSTANT VARCHAR2(4000) := '    */' || CHR(10) || '    --[E20261019-000071]_Sales Plan Waterfall ' || TO_CHAR(UNISTR('\B370\C774\D130')) || ' RTF ' || TO_CHAR(UNISTR('\C911\BCF5')) || ' ' || TO_CHAR(UNISTR('\D604\C0C1')) || '(END)' || CHR(10);
    FUNCTION cnt(p_src CLOB, p_tok VARCHAR2) RETURN PLS_INTEGER IS
        n PLS_INTEGER := 0; pos PLS_INTEGER := 1;
    BEGIN
        IF p_src IS NULL THEN RETURN 0; END IF;
        LOOP
            pos := DBMS_LOB.INSTR(p_src, p_tok, pos);
            EXIT WHEN pos = 0 OR pos IS NULL;
            n := n + 1; pos := pos + LENGTH(p_tok);
        END LOOP;
        RETURN n;
    END;
    PROCEDURE expect(p_name VARCHAR2, p_got PLS_INTEGER, p_exp PLS_INTEGER) IS
    BEGIN
        IF p_got <> p_exp THEN
            RAISE_APPLICATION_ERROR(-20001, 'STOP - ' || p_name || ' ' || p_got || ' (expected ' || p_exp || '). 00_PRECHECK result please. source unchanged');
        END IF;
    END;
BEGIN
    DBMS_LOB.CREATETEMPORARY(v_src, TRUE);
    FOR r IN (SELECT TEXT FROM USER_SOURCE WHERE NAME = 'PKG_DMF0022' AND TYPE = 'PACKAGE BODY' ORDER BY LINE) LOOP
        DBMS_LOB.WRITEAPPEND(v_src, LENGTH(r.TEXT), r.TEXT);
    END LOOP;
    v_src := REPLACE(v_src, CHR(13) || CHR(10), CHR(10));   -- CRLF 정규화 (문구는 LF 기준)
    v_new := v_src;
    IF DBMS_LOB.INSTR(v_src, c_mark) = 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP - no marker (not applied). source unchanged');
        RETURN;
    END IF;
    expect('OPEN text', cnt(v_src, c_open), 1);
    expect('CLOSE text', cnt(v_src, c_close), 1);
    v_s := DBMS_LOB.INSTR(v_src, c_open);
    v_e := DBMS_LOB.INSTR(v_src, c_close);
    IF v_s >= v_e THEN
        RAISE_APPLICATION_ERROR(-20002, 'STOP - OPEN after CLOSE. source unchanged');
    END IF;
    v_blk := SUBSTR(v_src, v_s + LENGTH(c_open), v_e - v_s - LENGTH(c_open));
    v_blk := REPLACE(REPLACE(v_blk, '\*', '/*'), '*\', '*/');
    v_new := SUBSTR(v_src, 1, v_s - 1) || v_blk || SUBSTR(v_src, v_e + LENGTH(c_close));
    expect('marker after build', cnt(v_new, c_mark), 0);
    BEGIN
        EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_new;
    EXCEPTION WHEN OTHERS THEN
        NULL;   -- 컴파일 오류 동반 생성(ORA-24344)도 예외로 온다 → 아래 STATUS 검사에서 판정·원문 복원
    END;
    SELECT STATUS INTO v_st FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_DMF0022' AND OBJECT_TYPE = 'PACKAGE BODY';
    SELECT COUNT(*) INTO v_err FROM USER_ERRORS WHERE NAME = 'PKG_DMF0022' AND TYPE = 'PACKAGE BODY';
    IF v_st <> 'VALID' OR v_err > 0 THEN
        FOR e IN (SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME = 'PKG_DMF0022' AND TYPE = 'PACKAGE BODY' ORDER BY SEQUENCE FETCH FIRST 10 ROWS ONLY) LOOP
            DBMS_OUTPUT.PUT_LINE('  ERR L' || e.LINE || ':' || e.POSITION || ' ' || e.TEXT);
        END LOOP;
        EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_src;   -- 원문 자동 복원
        RAISE_APPLICATION_ERROR(-20005, 'COMPILE FAIL(' || v_st || ', errors ' || v_err || ') -> source restored. run 90_VERIFY');
    END IF;
    DBMS_OUTPUT.PUT_LINE('ROLLED BACK - PKG_DMF0022 BODY ' || v_st || ' / marker 0 / ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
SELECT 'POST' CHK, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0022' ORDER BY OBJECT_TYPE;
