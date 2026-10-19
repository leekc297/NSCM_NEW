-- 90 VERIFY — [E20261019-000071] DMF0035(SALES PLAN) 조회 전용 (전체 F5, 값 입력 없음)
-- * 기대: V1 마커 2줄 PASS · V2 VALID / 오류 0 / 의존 INVALID 0 · V3 시작/끝 문구 각 1 · 원래 앵커(감싸기 전 시작) 0
-- * 화면 확인: DMF0035 · PLAN TYPE=SALES PLAN · 40 · SP_W_20261001_V001 · MCCM348014A3 · SCUD_CN_FOC
--   → DAP 는 CNY 행만(원천에 CURRENCY 공란 행이 있으면 그 행 수량만 별도 통화로 나옴 — 05_DIAG D1 참고)
SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 220 PAGESIZE 500
SET DEFINE OFF
SELECT 'V1 marker' CHK, COUNT(*) N, CASE WHEN COUNT(*) = 2 THEN 'PASS' ELSE 'FAIL (not applied or marker count mismatch)' END JUDGE
  FROM USER_SOURCE WHERE NAME='PKG_DMF0022' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%E20261019-000071%';
SELECT 'V2 status' CHK, O.OBJECT_TYPE, O.STATUS, TO_CHAR(O.LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL,
       (SELECT COUNT(*) FROM USER_ERRORS E WHERE E.NAME=O.OBJECT_NAME AND E.TYPE=O.OBJECT_TYPE) ERR_CNT,
       (SELECT COUNT(*) FROM USER_OBJECTS X WHERE X.STATUS<>'VALID' AND X.OBJECT_NAME IN (SELECT NAME FROM USER_DEPENDENCIES WHERE REFERENCED_NAME='PKG_DMF0022')) DEP_INVALID
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
    DBMS_OUTPUT.PUT_LINE('V3 OPEN ' || cnt(v_src, c_open) || ' / CLOSE ' || cnt(v_src, c_close) || ' / live HEAD+IF ' || cnt(v_src, c_head) || ' -> '
        || CASE WHEN cnt(v_src, c_open) = 1 AND cnt(v_src, c_close) = 1 AND cnt(v_src, c_head) = 1 THEN 'PASS (HEAD now inside comment)' ELSE 'FAIL (1/1/1 expected)' END);
    v_s := DBMS_LOB.INSTR(v_src, c_open);
    v_e := DBMS_LOB.INSTR(v_src, c_close);
    IF v_s > 0 AND v_e > v_s THEN
        v_blk := SUBSTR(v_src, v_s + LENGTH(c_open), v_e - v_s - LENGTH(c_open));
        DBMS_OUTPUT.PUT_LINE('V3 inner comment-close tokens ' || cnt(v_blk, '*/') || ' -> ' || CASE WHEN cnt(v_blk, '*/') = 0 THEN 'PASS' ELSE 'FAIL' END);
    END IF;
END;
/
