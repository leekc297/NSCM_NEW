-- 00_PRECHECK — 조회 전용 (전체 F5, 값 입력 없음). [E20261019-000071] DMF0035(SALES PLAN) PKG_DMF0022 적용 전 상태
-- * [L0] 접속 DB · 문자셋 · PKG_DMF0022 상태·LAST_DDL
-- * [L1] 앵커 시작 1 / 끝 1 · 블록 안 역슬래시 표기 0 (PASS 기대, DBMS_OUTPUT)
-- * [L2] 마커 — 적용 전 0
-- * [L3] 지금 PKG_DMF0022 실행 중 세션 (있으면 끝난 뒤 10 실행 — 컴파일이 대기함)
SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 220 PAGESIZE 300
SET DEFINE OFF
SELECT 'L0' CHK, SYS_CONTEXT('USERENV','DB_NAME') DB_NAME, TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') NOW,
       (SELECT VALUE FROM NLS_DATABASE_PARAMETERS WHERE PARAMETER='NLS_CHARACTERSET') DB_CHARSET FROM DUAL;
SELECT 'L0' CHK, O.OBJECT_TYPE, O.STATUS, TO_CHAR(O.LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL,
       (SELECT MAX(LINE) FROM USER_SOURCE S WHERE S.NAME=O.OBJECT_NAME AND S.TYPE=O.OBJECT_TYPE) LINES_N
  FROM USER_OBJECTS O WHERE O.OBJECT_NAME='PKG_DMF0022' ORDER BY O.OBJECT_TYPE;
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
    IF DBMS_LOB.INSTR(v_src, c_mark) > 0 THEN
        DBMS_OUTPUT.PUT_LINE('L1 N/A - already applied (marker found). 10 rerun is no-op; see 90_VERIFY');
        RETURN;
    END IF;
    v_s := DBMS_LOB.INSTR(v_src, c_head);
    v_e := DBMS_LOB.INSTR(v_src, c_tail);
    DBMS_OUTPUT.PUT_LINE('L1 HEAD anchor ' || cnt(v_src, c_head) || ' / TAIL anchor ' || cnt(v_src, c_tail) || ' -> '
        || CASE WHEN cnt(v_src, c_head) = 1 AND cnt(v_src, c_tail) = 1 AND v_s < v_e THEN 'PASS' ELSE 'FAIL (1/1 expected) -> do not run 10, send this result' END);
    IF cnt(v_src, c_head) = 1 AND cnt(v_src, c_tail) = 1 AND v_s < v_e THEN
        v_blk := SUBSTR(v_src, v_s, v_e + LENGTH(c_tail) - v_s);
        DBMS_OUTPUT.PUT_LINE('L1 block chars ' || LENGTH(v_blk) || ' (corp 23879) / comment-open ' || cnt(v_blk, '/*') || ' / comment-close ' || cnt(v_blk, '*/')
            || ' / backslash tokens ' || (cnt(v_blk, '\*') + cnt(v_blk, '*\')) || ' -> '
            || CASE WHEN cnt(v_blk, '\*') + cnt(v_blk, '*\') = 0 AND cnt(v_blk, '/*') = cnt(v_blk, '*/') THEN 'PASS' ELSE 'FAIL -> send this result' END);
    END IF;
END;
/
SELECT 'L2 marker' CHK, COUNT(*) N, MIN(LINE) LINE,
       CASE WHEN COUNT(*) = 0 THEN 'not applied (expected)' ELSE 'applied - 10 rerun is no-op by guard' END JUDGE
  FROM USER_SOURCE WHERE NAME='PKG_DMF0022' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%E20261019-000071%';
SELECT 'L3 running' CHK, S.INST_ID, S.SID, S.SERIAL#, S.USERNAME, S.LAST_CALL_ET CALL_SEC
  FROM GV$SESSION S WHERE S.TYPE='USER' AND S.STATUS='ACTIVE'
   AND S.PLSQL_ENTRY_OBJECT_ID = (SELECT OBJECT_ID FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0022' AND OBJECT_TYPE='PACKAGE');
