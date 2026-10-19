-- SOURCE-FRESH: SCM_MGR.PKG_DMF0042 PACKAGE BODY LAST_DDL=2026-10-15 18:36:13 FETCHED=2026-10-15 18:46 DB=ZIOUI1 (사내 적용본 문구 대조 · 클라우드는 자기 USER_SOURCE 를 패치)
-- 99_ROLLBACK — [E20261015-GAP257] GAP 257 원복 (전체 F5, 값 입력 없음, 멱등)
-- 내용: 10_APPLY 연산을 역순으로 되돌린다 — 위치는 ASCII 마커·토큰으로만 찾는다(한글 비교 없음).
-- 가드: 마커 없음 → 무동작 · 대상 건수 이상 → 중단(원문 무변경) · 컴파일 오류 → 원문 자동 복원
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    v_src    CLOB;
    v_new    CLOB;
    v_st     VARCHAR2(30);
    v_err    PLS_INTEGER;
    c_mark   CONSTANT VARCHAR2(40)   := '[E20261015-GAP257]';
    c_tagpfx CONSTANT VARCHAR2(100)  := '/* 2026.10.15 GAP257 [E20261015-GAP257]';
    c_astart CONSTANT VARCHAR2(100)  := '            INTO   V_CNT_1' || CHR(10) || '';
    c_aend   CONSTANT VARCHAR2(100)  := 'GOTO END_PKUPDATE;';
    c_gt_old CONSTANT VARCHAR2(100)  := 'FROM   GT_SDPB2_BP_FCST_4';
    c_gt_new CONSTANT VARCHAR2(2000) := 'FROM   (SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, CURRENCY, UNIT_ENERGY, CELL_PROD_SITE, MEASURE, FCST_TYPE, INCOTERMS' || CHR(10) || '                                  , DECODE(DEPT_ID, ''-'', ''/'', DEPT_ID) DEPT_ID, DECODE(END_CUSTOMER, ''-'', ''/'', END_CUSTOMER) END_CUSTOMER' || CHR(10) || '                                  , DECODE(BIZ_TYPE, ''-'', ''/'', BIZ_TYPE) BIZ_TYPE, DECODE(ITEM_USE, ''-'', ''/'', ITEM_USE) ITEM_USE' || CHR(10) || '                            FROM   GT_SDPB2_BP_FCST_4) /* 2026.10.15 GAP257 [E20261015-GAP257] 원본 : FROM GT_SDPB2_BP_FCST_4 */';
    c_gt_hd  CONSTANT VARCHAR2(200)  := 'FROM   (SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, CURRENCY, UNIT_ENERGY';
    c_gt_tl  CONSTANT VARCHAR2(100)  := 'FROM   GT_SDPB2_BP_FCST_4) ';
    c_w_old  CONSTANT VARCHAR2(300)  := 'WHERE  A.FCST_TYPE IS NULL' || CHR(10) || '            OR     A.INCOTERMS IS NULL;';
    c_w_asc  CONSTANT VARCHAR2(300)  := 'WHERE  A.FCST_TYPE IN (''-'', ''/'')' || CHR(10) || '            OR     A.INCOTERMS IN (''-'', ''/'');';
    c_w_new  CONSTANT VARCHAR2(2000) := '/* 2026.10.15 GAP257 [E20261015-GAP257] 빈값 = 이관 ''-'' · 신규 ''/'' 공존(과도기) */' || CHR(10) || '            /* 원본 : WHERE A.FCST_TYPE IS NULL OR A.INCOTERMS IS NULL (NOT NULL+DEFAULT ON NULL ''/'' 라 항상 거짓 → 블록 미동작) */' || CHR(10) || '            WHERE  A.FCST_TYPE IN (''-'', ''/'')' || CHR(10) || '            OR     A.INCOTERMS IN (''-'', ''/'');';
    c_i_old  CONSTANT VARCHAR2(100)  := 'IF V_CNT_1 > 0 THEN';
    c_i_asc  CONSTANT VARCHAR2(100)  := 'IF V_CNT_1 > 0 AND V_DIVISION_ID = ''40'' THEN';
    c_i_new  CONSTANT VARCHAR2(2000) := '/* 2026.10.15 GAP257 [E20261015-GAP257] AS-IS 의 40 조건 복원 */' || CHR(10) || '            /* 원본 : IF V_CNT_1 > 0 THEN (AS-IS = IF EXISTS(...) AND @v_DIVISION_ID = ''40'') */' || CHR(10) || '            IF V_CNT_1 > 0 AND V_DIVISION_ID = ''40'' THEN';
    c_m_old  CONSTANT VARCHAR2(100)  := 'MERGE INTO DM_PLN_BP_FCST A';
    c_m_new  CONSTANT VARCHAR2(2000) := '/* 2026.10.15 GAP257 [E20261015-GAP257] ON 센티널 키 4종 ''-''/''/'' 동치 — 원본 : A.DEPT_ID = B.DEPT_ID ... (raw 비교) */' || CHR(10) || '                MERGE INTO DM_PLN_BP_FCST A';
    FUNCTION cnt(p_src CLOB, p_tok VARCHAR2, p_from PLS_INTEGER, p_to PLS_INTEGER) RETURN PLS_INTEGER IS
        n PLS_INTEGER := 0; pos PLS_INTEGER := p_from;
    BEGIN
        LOOP
            pos := DBMS_LOB.INSTR(p_src, p_tok, pos);
            EXIT WHEN pos = 0 OR pos IS NULL OR pos >= p_to;
            n := n + 1; pos := pos + LENGTH(p_tok);
        END LOOP;
        RETURN n;
    END;
    -- 구간: 'INTO   V_CNT_1' (BODY 전체 1건) ~ 그 뒤 첫 'GOTO END_PKUPDATE;'
    PROCEDURE rng(o_lo OUT PLS_INTEGER, o_hi OUT PLS_INTEGER) IS
    BEGIN
        IF cnt(v_new, c_astart, 1, DBMS_LOB.GETLENGTH(v_new) + 1) <> 1 THEN
            RAISE_APPLICATION_ERROR(-20002, '중단 — 시작 앵커(INTO V_CNT_1) 1건 아님. 00_PRECHECK 회신. 원문 무변경');
        END IF;
        o_lo := DBMS_LOB.INSTR(v_new, c_astart);
        o_hi := DBMS_LOB.INSTR(v_new, c_aend, o_lo);
        IF NOT (o_hi > o_lo AND o_hi - o_lo < 8000) THEN RAISE_APPLICATION_ERROR(-20002, '중단 — 구간 끝(GOTO END_PKUPDATE) 확인 불가. 원문 무변경'); END IF;
    END;
    PROCEDURE op_tok(p_name VARCHAR2, p_tok VARCHAR2, p_new VARCHAR2, p_n PLS_INTEGER) IS
        lo PLS_INTEGER; hi PLS_INTEGER; pos PLS_INTEGER; st PLS_INTEGER;
    BEGIN
        rng(lo, hi);
        IF cnt(v_new, p_tok, lo, hi) <> p_n THEN
            RAISE_APPLICATION_ERROR(-20001, '중단 — ' || p_name || ' 대상 ' || cnt(v_new, p_tok, lo, hi) || '건 (' || p_n || ' 기대). 00_PRECHECK 회신. 원문 무변경');
        END IF;
        st := lo;
        FOR i IN 1 .. p_n LOOP
            pos := DBMS_LOB.INSTR(v_new, p_tok, st);
            v_new := SUBSTR(v_new, 1, pos - 1) || p_new || SUBSTR(v_new, pos + LENGTH(p_tok));
            st := pos + LENGTH(p_new);   -- 치환 결과 안의 토큰 재매칭 방지
        END LOOP;
    END;
    PROCEDURE op_cut(p_name VARCHAR2, p_start VARCHAR2, p_end VARCHAR2) IS
        lo PLS_INTEGER; hi PLS_INTEGER; s PLS_INTEGER; e PLS_INTEGER;
    BEGIN
        rng(lo, hi);
        s := DBMS_LOB.INSTR(v_new, p_start, lo);
        e := CASE WHEN s > 0 THEN DBMS_LOB.INSTR(v_new, p_end, s) ELSE 0 END;
        IF NOT (s > 0 AND s < hi AND e > s AND e < hi AND e - s < 400) THEN
            RAISE_APPLICATION_ERROR(-20001, '중단 — ' || p_name || ' 주석 위치 확인 불가. 원문 무변경');
        END IF;
        v_new := SUBSTR(v_new, 1, s - 1) || SUBSTR(v_new, e);
    END;
    PROCEDURE op_line_tail(p_name VARCHAR2, p_head VARCHAR2, p_tail VARCHAR2, p_new VARCHAR2, p_n PLS_INTEGER) IS
        lo PLS_INTEGER; hi PLS_INTEGER; s PLS_INTEGER; t PLS_INTEGER; e PLS_INTEGER;
    BEGIN
        rng(lo, hi);
        IF cnt(v_new, p_head, lo, hi) <> p_n THEN
            RAISE_APPLICATION_ERROR(-20001, '중단 — ' || p_name || ' 대상 ' || cnt(v_new, p_head, lo, hi) || '건 (' || p_n || ' 기대). 원문 무변경');
        END IF;
        FOR i IN 1 .. p_n LOOP
            rng(lo, hi);
            s := DBMS_LOB.INSTR(v_new, p_head, lo);
            t := DBMS_LOB.INSTR(v_new, p_tail, s);
            e := DBMS_LOB.INSTR(v_new, CHR(10), t);
            IF NOT (t > s AND e > t AND e - s < 600) THEN RAISE_APPLICATION_ERROR(-20001, '중단 — ' || p_name || ' 줄 끝 확인 불가. 원문 무변경'); END IF;
            v_new := SUBSTR(v_new, 1, s - 1) || p_new || SUBSTR(v_new, e);
        END LOOP;
    END;
BEGIN
    DBMS_LOB.CREATETEMPORARY(v_src, TRUE);
    FOR r IN (SELECT TEXT FROM USER_SOURCE WHERE NAME = 'PKG_DMF0042' AND TYPE = 'PACKAGE BODY' ORDER BY LINE) LOOP
        DBMS_LOB.WRITEAPPEND(v_src, LENGTH(r.TEXT), r.TEXT);
    END LOOP;
    v_src := REPLACE(v_src, CHR(13) || CHR(10), CHR(10));   -- CRLF 정규화 (문구는 LF 기준)
    v_new := v_src;
    IF DBMS_LOB.INSTR(v_src, c_mark) = 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 마커 없음 (미적용 상태). 원문 무변경');
        RETURN;
    END IF;
    op_line_tail('③ GT 센티널 키 정규화', c_gt_hd, c_gt_tl, c_gt_old, 2);
    op_tok('③ DEPT_ID 동치', 'DECODE(A.DEPT_ID, ''-'', ''/'', A.DEPT_ID) = B.DEPT_ID', 'A.DEPT_ID = B.DEPT_ID', 2);
    op_tok('③ END_CUSTOMER 동치', 'DECODE(A.END_CUSTOMER, ''-'', ''/'', A.END_CUSTOMER) = B.END_CUSTOMER', 'A.END_CUSTOMER = B.END_CUSTOMER', 2);
    op_tok('③ BIZ_TYPE 동치', 'DECODE(A.BIZ_TYPE, ''-'', ''/'', A.BIZ_TYPE) = B.BIZ_TYPE', 'A.BIZ_TYPE = B.BIZ_TYPE', 2);
    op_tok('③ ITEM_USE 동치', 'DECODE(A.ITEM_USE, ''-'', ''/'', A.ITEM_USE) = B.ITEM_USE', 'A.ITEM_USE = B.ITEM_USE', 2);
    op_cut('① 빈값 검사 주석', c_tagpfx, c_w_asc);  op_tok('① 빈값 검사', c_w_asc, c_w_old, 1);
    op_cut('② 40 조건 주석', c_tagpfx, c_i_asc);    op_tok('② 40 조건', c_i_asc, c_i_old, 1);
    op_cut('③ MERGE 주석', c_tagpfx, c_m_old);
    IF DBMS_LOB.INSTR(v_new, c_mark) > 0 THEN
        RAISE_APPLICATION_ERROR(-20004, '중단 — 조립 결과 불일치(마커 잔존). 원문 무변경');
    END IF;
    BEGIN
        EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_new;
    EXCEPTION WHEN OTHERS THEN
        NULL;   -- 컴파일 오류 동반 생성(ORA-24344)도 예외로 온다 → 아래 STATUS 검사에서 판정·원문 복원
    END;
    SELECT STATUS INTO v_st FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_DMF0042' AND OBJECT_TYPE = 'PACKAGE BODY';
    SELECT COUNT(*) INTO v_err FROM USER_ERRORS WHERE NAME = 'PKG_DMF0042' AND TYPE = 'PACKAGE BODY';
    IF v_st <> 'VALID' OR v_err > 0 THEN
        FOR e IN (SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME = 'PKG_DMF0042' AND TYPE = 'PACKAGE BODY' ORDER BY SEQUENCE FETCH FIRST 10 ROWS ONLY) LOOP
            DBMS_OUTPUT.PUT_LINE('  ERR L' || e.LINE || ':' || e.POSITION || ' ' || e.TEXT);
        END LOOP;
        BEGIN
            EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_src;   -- 원문 자동 복원
        EXCEPTION WHEN OTHERS THEN NULL;
        END;
        RAISE_APPLICATION_ERROR(-20005, '컴파일 실패(' || v_st || ', 오류 ' || v_err || ') → 원문 복원함. 90_VERIFY 로 STATUS 확인');
    END IF;
    DBMS_OUTPUT.PUT_LINE('ROLLED BACK — PKG_DMF0042 BODY ' || v_st || ' · 마커 0 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
SELECT 'POST' CHK, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0042' ORDER BY OBJECT_TYPE;
