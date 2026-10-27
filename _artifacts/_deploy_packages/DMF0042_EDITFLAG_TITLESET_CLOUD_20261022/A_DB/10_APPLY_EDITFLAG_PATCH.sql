-- SOURCE-FRESH: SCM_MGR.PKG_DMF0042 PACKAGE BODY LAST_DDL=2026-10-22 10:32:23 FETCHED=2026-10-22 10:36 DB=ZIOUI1 (사내 적용본 문구 대조 · 클라우드는 자기 USER_SOURCE 를 패치)
-- 10_APPLY — [E20261022-EDITFLAG] DMF0042 개인 컬럼 설정 사용자 EDIT_FLAG 누락 보정 (전체 F5, 값 입력 없음, 멱등)
-- 내용: P_DMF0042_GET_DM_PLN_BUSINESS_PLAN_DATA 컬럼 목록의 '개인 설정 있음' 분기에서 숨은 고정 칸 판정
--       RTRIM(C.DEFAULT_FLAG, ' -') IS NULL → NVL(RTRIM(C.DEFAULT_FLAG, ' -'), 'N') = 'N'  (기본 분기와 같은 판정)
--       DEFAULT_FLAG 'N' 인 EDIT_FLAG 가 빠져 화면 편집 셀(노란색)이 하나도 열리지 않던 증상 해소. 원래 줄은 '--' 주석 보존.
-- 범위: GET 프로시저 1줄(+주석 1줄). 데이터 · 메타 · FE · 권한 무변경. BE 재기동 불필요.
-- 방식: 이 DB 의 USER_SOURCE 를 읽어 ASCII 토큰으로 위치를 찾아 치환 → CREATE OR REPLACE (사내 전체본 복사 아님).
-- 가드: 마커 존재 시 무동작 · 대상 건수 ≠ 1 이면 중단(원문 무변경) · 컴파일 오류 시 원문 자동 복원
-- 사내 ZIOUI1 적용 완료(LAST_DDL 2026-10-22 10:32:23). 실행 전 00_PRECHECK_CLOUD · 실행 뒤 90_VERIFY · 원복 = 99_ROLLBACK
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
    c_mark   CONSTANT VARCHAR2(40)   := '[E20261022-EDITFLAG]';
    c_ind    CONSTANT VARCHAR2(40)   := '                                ';
    c_pfrom  CONSTANT VARCHAR2(200)  := '  PROCEDURE P_DMF0042_GET_DM_PLN_BUSINESS_PLAN_DATA';
    c_astart CONSTANT VARCHAR2(200)  := '                        SELECT SORT_ORDER_NO, COLUMN_NAME, DATA_SORT_METHOD_CODE' || CHR(10) || '';
    c_aend   CONSTANT VARCHAR2(200)  := '                        ) WHERE ROWNUM <= 100' || CHR(10) || '';
    c_oldhd  CONSTANT VARCHAR2(200)  := '                                AND RTRIM(C.DEFAULT_FLAG, '' -'') IS NULL';
    c_cmthd  CONSTANT VARCHAR2(200)  := '                                --AND RTRIM(C.DEFAULT_FLAG, '' -'') IS NULL';
    c_newhd  CONSTANT VARCHAR2(200)  := '                                AND NVL(RTRIM(C.DEFAULT_FLAG, '' -''), ''N'') = ''N''   -- 2026.10.22 [E20261022-EDITFLAG]';
    c_new    CONSTANT VARCHAR2(2000) := '                                AND NVL(RTRIM(C.DEFAULT_FLAG, '' -''), ''N'') = ''N''   -- 2026.10.22 [E20261022-EDITFLAG] 개인 컬럼 설정 분기도 F-19 ''N'' 대응(위 기본 분기와 동일) — 누락 시 EDIT_FLAG 등 숨은 고정 칸 미반환' || CHR(10) || '';
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
    -- 구간: GET 프로시저 시작(BODY 1건) 뒤 개인 컬럼 설정 분기의 숨은 고정 칸 서브쿼리
    --       'SELECT SORT_ORDER_NO, COLUMN_NAME, DATA_SORT_METHOD_CODE' ~ ') WHERE ROWNUM <= 100'
    PROCEDURE rng IS
        p0 PLS_INTEGER;
    BEGIN
        IF cnt(v_new, c_pfrom, 1, DBMS_LOB.GETLENGTH(v_new) + 1) <> 1 THEN
            RAISE_APPLICATION_ERROR(-20002, '중단 — GET 프로시저 위치 1건 아님. 00_PRECHECK 회신. 원문 무변경');
        END IF;
        p0 := DBMS_LOB.INSTR(v_new, c_pfrom);
        lo := DBMS_LOB.INSTR(v_new, c_astart, p0);
        hi := CASE WHEN lo > 0 THEN DBMS_LOB.INSTR(v_new, c_aend, lo) ELSE 0 END;
        IF NOT (lo > p0 AND hi > lo AND hi - lo < 3000) THEN
            RAISE_APPLICATION_ERROR(-20002, '중단 — 개인 설정 분기 구간 확인 불가. 00_PRECHECK 회신. 원문 무변경');
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
    n := cnt(v_new, c_oldhd, lo, hi);
    IF n <> 1 THEN
        RAISE_APPLICATION_ERROR(-20001, '중단 — DEFAULT_FLAG 판정 줄 ' || n || '건 (1 기대). 00_PRECHECK 회신. 원문 무변경');
    END IF;
    s := DBMS_LOB.INSTR(v_new, c_oldhd, lo);
    e := DBMS_LOB.INSTR(v_new, CHR(10), s) + 1;
    v_new := SUBSTR(v_new, 1, s - 1) || c_ind || '--' || SUBSTR(v_new, s + LENGTH(c_ind), e - s - LENGTH(c_ind))
             || c_new || SUBSTR(v_new, e);
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
