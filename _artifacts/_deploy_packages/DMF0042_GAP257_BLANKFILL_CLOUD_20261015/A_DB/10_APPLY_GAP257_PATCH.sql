-- SOURCE-FRESH: SCM_MGR.PKG_DMF0042 PACKAGE BODY LAST_DDL=2026-10-15 18:36:13 FETCHED=2026-10-15 18:46 DB=ZIOUI1 (사내 적용본 문구 대조 · 클라우드는 자기 USER_SOURCE 를 패치)
-- 10_APPLY — [E20261015-GAP257] GAP 257 PKG_DMF0042 BODY 패치 (전체 F5, 값 입력 없음, 멱등)
-- 내용: 저장 P_DMF0042_SAVE_DM_PLN_BP_FCST 의 '2021.7.23 키 업데이트용 데이터 처리' 블록 — 같은 키로 새 행을 저장하면
--       FCST Type·Incoterms 가 빈 옛 행을 채우고 끝(AS-IS DMF0042_SAVE_DM_PLN_BP_FCST). 지금은 조건이 항상 거짓이라 미동작.
--   ① 빈값 검사 IS NULL → IN ('-','/')  (두 컬럼 NOT NULL + DEFAULT ON NULL '/' · 이관 빈값 '-' 와 신규 빈값 '/' 과도기 공존)
--   ② AS-IS 의 40 조건 복원 (IF ... AND V_DIVISION_ID = '40')
--   ③ 11키 조인 센티널 키 4종(DEPT_ID·END_CUSTOMER·BIZ_TYPE·ITEM_USE) '-'/'/' 동치 — 40 원장 '-' · GT 정규화 '/'
-- 범위: 저장 SP 블록 1곳만. 원장 데이터 · 메타 · FE · 권한 · GTT 무변경. BE 재기동 불필요.
-- 방식: 이 DB 의 USER_SOURCE 를 읽어 ASCII 토큰으로 위치를 찾고 연산 7개를 순서대로 적용 → CREATE OR REPLACE (사내 전체본 복사 아님).
-- 가드: 마커 존재 시 무동작 · 연산마다 대상 건수가 기대와 다르면 중단(원문 무변경) · 마커 5곳 확인 · 컴파일 오류 시 원문 자동 복원
-- 사내 ZIOUI1 적용 완료(LAST_DDL 2026-10-15 18:36:13). 실행 전 00_PRECHECK_CLOUD · 실행 뒤 90_VERIFY · 원복 = 99_ROLLBACK
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
    IF DBMS_LOB.INSTR(v_src, c_mark) > 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 이미 적용됨 (마커 있음). 원문 무변경');
        RETURN;
    END IF;
    op_tok('③ GT 센티널 키 정규화', c_gt_old, c_gt_new, 2);
    op_tok('③ DEPT_ID 동치', 'A.DEPT_ID = B.DEPT_ID', 'DECODE(A.DEPT_ID, ''-'', ''/'', A.DEPT_ID) = B.DEPT_ID', 2);
    op_tok('③ END_CUSTOMER 동치', 'A.END_CUSTOMER = B.END_CUSTOMER', 'DECODE(A.END_CUSTOMER, ''-'', ''/'', A.END_CUSTOMER) = B.END_CUSTOMER', 2);
    op_tok('③ BIZ_TYPE 동치', 'A.BIZ_TYPE = B.BIZ_TYPE', 'DECODE(A.BIZ_TYPE, ''-'', ''/'', A.BIZ_TYPE) = B.BIZ_TYPE', 2);
    op_tok('③ ITEM_USE 동치', 'A.ITEM_USE = B.ITEM_USE', 'DECODE(A.ITEM_USE, ''-'', ''/'', A.ITEM_USE) = B.ITEM_USE', 2);
    op_tok('① 빈값 검사', c_w_old, c_w_new, 1);
    op_tok('② 40 조건', c_i_old, c_i_new, 1);
    op_tok('③ MERGE 주석', c_m_old, c_m_new, 1);
    IF (DBMS_LOB.GETLENGTH(v_new) - DBMS_LOB.GETLENGTH(REPLACE(v_new, c_mark, ''))) / LENGTH(c_mark) <> 5 THEN
        RAISE_APPLICATION_ERROR(-20004, '중단 — 조립 결과 마커 수 불일치(5 기대). 원문 무변경');
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
    DBMS_OUTPUT.PUT_LINE('APPLIED — PKG_DMF0042 BODY ' || v_st || ' · 마커 5곳 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
SELECT 'POST' CHK, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0042' ORDER BY OBJECT_TYPE;
