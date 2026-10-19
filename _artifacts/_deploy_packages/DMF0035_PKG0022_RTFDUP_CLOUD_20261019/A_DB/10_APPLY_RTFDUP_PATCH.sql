-- SOURCE-FRESH: SCM_MGR.PKG_DMF0022 PACKAGE BODY LAST_DDL=2026-10-19 11:51:29 FETCHED=2026-10-19 12:02 DB=ZIOUI1 (사내 적용본 대조 · 클라우드는 자기 USER_SOURCE 를 패치)
-- 10_APPLY — [E20261019-000071] DMF0035(SALES PLAN) PKG_DMF0022 BODY 패치 (전체 F5, 값 입력 없음, 멱등)
-- 내용: P_DMF0022_GET_DM_PLN_SALES_PLAN_WATERFALL 의 40사업부 [PJ2024-50611] 계획구간 RTF 재적재 블록 전체를 주석 처리
--   (Sales Plan Waterfall 데이터 RTF 중복 현상 — 재적재 조인에 CURRENCY 가 없어 같은 키의 다른 통화 행(USD)으로 수량이 복제됨)
-- 범위: 위 블록 1곳(IF p_division_id = '40' ~ END IF). 블록 안의 힌트 '/*+ NO_PARALLEL */' 는 블록주석 중첩 불가로 '\*+ NO_PARALLEL *\' 표기
--       원장 · 메타 · FE · 권한 · GTT 무변경. BE 재기동 불필요.
-- 방식: 이 DB 의 USER_SOURCE 를 읽어 시작/끝 앵커 위치로 감싼다 → CREATE OR REPLACE (사내 전체본 복사 아님). 한글 문구 = UNISTR
-- 가드: 마커 존재 시 무동작 · 앵커 시작 1 / 끝 1 아니면 중단(원문 무변경) · 마커 2줄 확인 · 컴파일 오류 시 원문 자동 복원
-- 사내 ZIOUI1 적용 완료(LAST_DDL 2026-10-19 11:51:29).
-- 실행 전 00_PRECHECK_CLOUD · 실행 뒤 90_VERIFY · 원복 = 99_ROLLBACK
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
    IF DBMS_LOB.INSTR(v_src, c_mark) > 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP - already applied (marker found). source unchanged');
        RETURN;
    END IF;
    expect('HEAD anchor', cnt(v_src, c_head), 1);
    expect('TAIL anchor', cnt(v_src, c_tail), 1);
    v_s := DBMS_LOB.INSTR(v_src, c_head);
    v_e := DBMS_LOB.INSTR(v_src, c_tail);
    IF v_s >= v_e THEN
        RAISE_APPLICATION_ERROR(-20002, 'STOP - HEAD after TAIL. source unchanged');
    END IF;
    v_blk := SUBSTR(v_src, v_s, v_e + LENGTH(c_tail) - v_s);
    expect('backslash-star in block', cnt(v_blk, '\*'), 0);
    expect('star-backslash in block', cnt(v_blk, '*\'), 0);
    v_blk := REPLACE(REPLACE(v_blk, '/*', '\*'), '*/', '*\');
    v_new := SUBSTR(v_src, 1, v_s - 1) || c_open || v_blk || c_close || SUBSTR(v_src, v_e + LENGTH(c_tail));
    expect('marker after build', cnt(v_new, c_mark), 2);
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
    DBMS_OUTPUT.PUT_LINE('APPLIED - PKG_DMF0022 BODY ' || v_st || ' / marker 2 / ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
SELECT 'POST' CHK, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0022' ORDER BY OBJECT_TYPE;
