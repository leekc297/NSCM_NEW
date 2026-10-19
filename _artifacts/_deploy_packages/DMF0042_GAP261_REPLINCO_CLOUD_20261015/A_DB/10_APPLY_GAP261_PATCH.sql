-- SOURCE-FRESH: SCM_MGR.PKG_DMF0042 PACKAGE BODY LAST_DDL=2026-10-15 19:04:56 FETCHED=2026-10-15 19:08 DB=ZIOUI1 (사내 적용본 문구 대조 · 클라우드는 자기 USER_SOURCE 를 패치)
-- 10_APPLY — [E20261015-GAP261] GAP 261 PKG_DMF0042 BODY 패치 (전체 F5, 값 입력 없음, 멱등)
-- 내용: 40 Replace(P_DMF0042_SAVE_DM_PLN_BP_REPLACE_BY_CUTOFF) 가 컷오프 DM_PLN_BP_FCST_C.INCOTERMS(NULL 허용) 를 그대로
--       원장 DM_PLN_BP_FCST.INCOTERMS(NOT NULL·PK) 에 넣어, NULL 행이 있는 구간(2024-12 이전)은 ORA-01400 으로 Replace 전체가 실패한다.
--       SELECT 목록 INCOTERMS → NVL(NULLIF(RTRIM(INCOTERMS), ''), '/') 1줄 (빈값 = '/' — 이관·적재 규칙과 같음)
-- 범위: Replace 프로시저 1줄. 원장·컷오프 데이터 · 메타 · FE · 권한 무변경. BE 재기동 불필요.
-- 방식: 이 DB 의 USER_SOURCE 를 읽어 ASCII 토큰으로 위치를 찾아 1줄 치환 → CREATE OR REPLACE (사내 전체본 복사 아님).
-- 가드: 마커 존재 시 무동작 · 대상 건수 ≠ 1 이면 중단(원문 무변경) · 컴파일 오류 시 원문 자동 복원
-- 사내 ZIOUI1 적용 완료(LAST_DDL 2026-10-15 19:04:56). 실행 전 00_PRECHECK_CLOUD · 실행 뒤 90_VERIFY · 원복 = 99_ROLLBACK
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    v_src    CLOB;
    v_new    CLOB;
    v_st     VARCHAR2(30);
    v_err    PLS_INTEGER;
    lo       PLS_INTEGER;
    hi       PLS_INTEGER;
    s        PLS_INTEGER;
    e        PLS_INTEGER;
    n        PLS_INTEGER;
    c_mark   CONSTANT VARCHAR2(40)   := '[E20261015-GAP261]';
    c_pfrom  CONSTANT VARCHAR2(200)  := '  PROCEDURE P_DMF0042_SAVE_DM_PLN_BP_REPLACE_BY_CUTOFF';
    c_astart CONSTANT VARCHAR2(200)  := '          SELECT' || CHR(10) || '            DIVISION_ID,' || CHR(10) || '            PROJECT_CODE,';
    c_aend   CONSTANT VARCHAR2(200)  := '          FROM DM_PLN_BP_FCST_C' || CHR(10) || '          WHERE VERSION_NO = p_version_no';
    c_old    CONSTANT VARCHAR2(100)  := '            INCOTERMS,' || CHR(10) || '';
    c_newhd  CONSTANT VARCHAR2(200)  := '            NVL(NULLIF(RTRIM(INCOTERMS), ''''), ''/''), /* 2026.10.15 GAP261 [E20261015-GAP261]';
    c_new    CONSTANT VARCHAR2(2000) := '            NVL(NULLIF(RTRIM(INCOTERMS), ''''), ''/''), /* 2026.10.15 GAP261 [E20261015-GAP261] 컷오프 INCOTERMS 는 NULL 허용, 원장은 NOT NULL(PK) — 빈값은 ''/'' (원본 : INCOTERMS,) */' || CHR(10) || '';
    FUNCTION cnt(p_src CLOB, p_tok VARCHAR2, p_from PLS_INTEGER, p_to PLS_INTEGER) RETURN PLS_INTEGER IS
        k PLS_INTEGER := 0; pos PLS_INTEGER := p_from;
    BEGIN
        LOOP
            pos := DBMS_LOB.INSTR(p_src, p_tok, pos);
            EXIT WHEN pos = 0 OR pos IS NULL OR pos >= p_to;
            k := k + 1; pos := pos + LENGTH(p_tok);
        END LOOP;
        RETURN k;
    END;
    -- 구간: Replace 프로시저 시작(BODY 1건) 뒤 'SELECT/DIVISION_ID,/PROJECT_CODE,' ~ 'FROM DM_PLN_BP_FCST_C/WHERE VERSION_NO = p_version_no'
    PROCEDURE rng IS
        p0 PLS_INTEGER;
    BEGIN
        IF cnt(v_new, c_pfrom, 1, DBMS_LOB.GETLENGTH(v_new) + 1) <> 1 THEN
            RAISE_APPLICATION_ERROR(-20002, '중단 — Replace 프로시저 위치 1건 아님. 00_PRECHECK 회신. 원문 무변경');
        END IF;
        p0 := DBMS_LOB.INSTR(v_new, c_pfrom);
        lo := DBMS_LOB.INSTR(v_new, c_astart, p0);
        hi := CASE WHEN lo > 0 THEN DBMS_LOB.INSTR(v_new, c_aend, lo) ELSE 0 END;
        IF NOT (lo > p0 AND hi > lo AND hi - lo < 3000) THEN
            RAISE_APPLICATION_ERROR(-20002, '중단 — INSERT SELECT 구간 확인 불가. 00_PRECHECK 회신. 원문 무변경');
        END IF;
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
    rng;
    n := cnt(v_new, c_old, lo, hi);
    IF n <> 1 THEN
        RAISE_APPLICATION_ERROR(-20001, '중단 — INCOTERMS 대상 줄 ' || n || '건 (1 기대). 00_PRECHECK 회신. 원문 무변경');
    END IF;
    s := DBMS_LOB.INSTR(v_new, c_old, lo);
    v_new := SUBSTR(v_new, 1, s - 1) || c_new || SUBSTR(v_new, s + LENGTH(c_old));
    IF DBMS_LOB.INSTR(v_new, c_mark) = 0 THEN
        RAISE_APPLICATION_ERROR(-20004, '중단 — 조립 결과 마커 없음. 원문 무변경');
    END IF;
    BEGIN
        EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_new;
    EXCEPTION WHEN OTHERS THEN
        NULL;   -- 컴파일 오류 동반 생성(ORA-24344)도 예외로 온다 → 아래 STATUS 검사에서 판정·원문 복원
    END;
    SELECT STATUS INTO v_st FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_DMF0042' AND OBJECT_TYPE = 'PACKAGE BODY';
    SELECT COUNT(*) INTO v_err FROM USER_ERRORS WHERE NAME = 'PKG_DMF0042' AND TYPE = 'PACKAGE BODY';
    IF v_st <> 'VALID' OR v_err > 0 THEN
        FOR x IN (SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME = 'PKG_DMF0042' AND TYPE = 'PACKAGE BODY' ORDER BY SEQUENCE FETCH FIRST 10 ROWS ONLY) LOOP
            DBMS_OUTPUT.PUT_LINE('  ERR L' || x.LINE || ':' || x.POSITION || ' ' || x.TEXT);
        END LOOP;
        BEGIN
            EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_src;   -- 원문 자동 복원
        EXCEPTION WHEN OTHERS THEN NULL;
        END;
        RAISE_APPLICATION_ERROR(-20005, '컴파일 실패(' || v_st || ', 오류 ' || v_err || ') → 원문 복원함. 90_VERIFY 로 STATUS 확인');
    END IF;
    DBMS_OUTPUT.PUT_LINE('APPLIED — PKG_DMF0042 BODY ' || v_st || ' · 마커 1곳 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
SELECT 'POST' CHK, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0042' ORDER BY OBJECT_TYPE;
