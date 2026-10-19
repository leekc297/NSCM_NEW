-- SOURCE-FRESH: SCM_MGR.PKG_DMF0053 PACKAGE BODY LAST_DDL=2026-10-15 19:11:27 FETCHED=2026-10-15 19:16 DB=ZIOUI1 (사내 적용본 문구 대조 · 클라우드는 자기 USER_SOURCE 를 패치)
-- 10_APPLY — [GAP377 2026-10-15] GAP 377 PKG_DMF0053 BODY 패치 (전체 F5, 값 입력 없음, 멱등)
-- 내용: Customer FCST Waterfall 조회조건 Bucket = Only Weekly 를 AS-IS 와 같게 한다.
--   머리글 P_DMF0053_GET_SPREAD_TITLE (사용자설정·기본 두 분기 모두)
--     T1 기간 칸 폭 Only Weekly 100 (그 외 50)
--     T2·T3 월별 주 칸(W_월+주차)·월 칸(M_) 은 Only Weekly 에서 제외
--     T3 Only Weekly 주 칸 = 'W_' + 그 주의 기간 내 마지막 날 월 + 주차, 대분류 'MM.DD ~ MM.DD' (AS-IS [C20220620-000567])
--   조회 P_DMF0053_GET_CUST_FCST_WATERFALL 동적 SQL
--     G1·G2 Only Weekly 주 키를 날짜별 월이 아니라 '그 주의 기간 내 마지막 날 월 + 주차' 로 (AS-IS #CALENDAR) — 월에 걸친 주의 앞달 수량 누락 해소
-- 범위: 위 두 프로시저. Monthly·Weekly·Daily 결과 · 원장 · 메타 · FE · 권한 · GTT 무변경. BE 재기동 불필요.
-- 방식: 이 DB 의 USER_SOURCE 를 읽어 ASCII 문구로 치환(한글 비교 없음) → CREATE OR REPLACE (사내 전체본 복사 아님).
-- 가드: 마커 존재 시 무동작 · 각 대상 건수(T1~T3 2 / G1~G2 1)가 다르면 중단(원문 무변경) · 마커 10곳 확인 · 컴파일 오류 시 원문 자동 복원
-- 사내 ZIOUI1 적용 완료(LAST_DDL 2026-10-15 19:11:27).
-- 실행 전 00_PRECHECK_CLOUD · 실행 뒤 90_VERIFY · 원복 = 99_ROLLBACK
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    v_src    CLOB;
    v_new    CLOB;
    v_st     VARCHAR2(30);
    v_err    PLS_INTEGER;
    c_mark   CONSTANT VARCHAR2(40) := 'GAP377 2026-10-15';
    c_t1_old CONSTANT VARCHAR2(4000) := '                     , '''' AS FIXED_FLAG, 50 AS COLUMN_WIDTH' || CHR(10) || '';
    c_t1_new CONSTANT VARCHAR2(4000) := '                     , '''' AS FIXED_FLAG, CASE WHEN P_BUCKET = ''ONLY_WEEKLY'' THEN 100 ELSE 50 END AS COLUMN_WIDTH  --[GAP377 2026-10-15] AS-IS width' || CHR(10) || '';
    c_t2_old CONSTANT VARCHAR2(4000) := '                           AND A.BASIS_YYYYMMDD <= P_END_YYYYMMDD' || CHR(10) || '                         GROUP BY A.BASIS_YYYYMM, A.ISO_WEEK, A.WEEK_NAME, A.MONTH_NAME' || CHR(10) || '';
    c_t2_new CONSTANT VARCHAR2(4000) := '                           AND A.BASIS_YYYYMMDD <= P_END_YYYYMMDD' || CHR(10) || '                           AND P_BUCKET <> ''ONLY_WEEKLY''  --[GAP377 2026-10-15]' || CHR(10) || '                         GROUP BY A.BASIS_YYYYMM, A.ISO_WEEK, A.WEEK_NAME, A.MONTH_NAME' || CHR(10) || '';
    c_t3_old CONSTANT VARCHAR2(4000) := '                           AND A.BASIS_YYYYMMDD <= P_END_YYYYMMDD' || CHR(10) || '                         GROUP BY A.BASIS_YYYYMM, A.MONTH_NAME' || CHR(10) || '                       ) T' || CHR(10) || '';
    c_t3_new CONSTANT VARCHAR2(4000) := '                           AND A.BASIS_YYYYMMDD <= P_END_YYYYMMDD' || CHR(10) || '                           AND P_BUCKET <> ''ONLY_WEEKLY''  --[GAP377 2026-10-15]' || CHR(10) || '                         GROUP BY A.BASIS_YYYYMM, A.MONTH_NAME' || CHR(10) || '                        UNION ALL' || CHR(10) || '                        --[GAP377 2026-10-15] ONLY_WEEKLY: one column per ISO week (AS-IS C20220620-000567)' || CHR(10) || '                        SELECT ''W_'' || SUBSTR(MAX(A.BASIS_YYYYMMDD), 1, 6) || A.ISO_WEEK AS COLUMN_NAME' || CHR(10) || '                             , A.WEEK_NAME AS COLUMN_LABEL_NAME' || CHR(10) || '                             , A.WEEK_NAME AS SMALL_CLASS_LABEL_NAME' || CHR(10) || '                             , SUBSTR(MIN(A.BASIS_YYYYMMDD), 5, 2) || ''.'' || SUBSTR(MIN(A.BASIS_YYYYMMDD), 7, 2)' || CHR(10) || '                               || '' ~ '' || SUBSTR(MAX(A.BASIS_YYYYMMDD), 5, 2) || ''.'' || SUBSTR(MAX(A.BASIS_YYYYMMDD), 7, 2) AS LARGE_CLASS_LABEL_NAME' || CHR(10) || '                             , '''' AS DAY_CODE' || CHR(10) || '                             , TO_NUMBER(MAX(A.BASIS_YYYYMMDD) || ''21'') AS SORT_ORDER_NO' || CHR(10) || '                          FROM SCM_SYS_CALENDAR_M A' || CHR(10) || '                         WHERE A.BASIS_YYYYMMDD >= P_START_YYYYMMDD' || CHR(10) || '                           AND A.BASIS_YYYYMMDD <= P_END_YYYYMMDD' || CHR(10) || '                           AND P_BUCKET = ''ONLY_WEEKLY''' || CHR(10) || '                         GROUP BY A.ISO_YYYYWW, A.ISO_WEEK, A.WEEK_NAME' || CHR(10) || '                       ) T' || CHR(10) || '';
    c_g1_old CONSTANT VARCHAR2(4000) := '         , SUBSTR(CAL.BASIS_YYYYMM, 1, 6) || CAL.ISO_WEEK AS BASIS_YYYYMMWW' || CHR(10) || '';
    c_g1_new CONSTANT VARCHAR2(4000) := '         , CW.BASIS_YYYYMMWW AS BASIS_YYYYMMWW  /* [GAP377 2026-10-15] AS-IS #CALENDAR week key */' || CHR(10) || '';
    c_g2_old CONSTANT VARCHAR2(4000) := '      JOIN SCM_SYS_CALENDAR_M CAL ON A.YYYYMMDD = CAL.BASIS_YYYYMMDD' || CHR(10) || '';
    c_g2_new CONSTANT VARCHAR2(4000) := '      JOIN SCM_SYS_CALENDAR_M CAL ON A.YYYYMMDD = CAL.BASIS_YYYYMMDD' || CHR(10) || '      /* [GAP377 2026-10-15] week key = month of the last in-period day of the ISO week + ISO_WEEK (AS-IS #CALENDAR) */' || CHR(10) || '      LEFT OUTER JOIN ( SELECT ISO_YYYYWW, ISO_WEEK, SUBSTR(MAX(BASIS_YYYYMMDD), 1, 6) || ISO_WEEK AS BASIS_YYYYMMWW' || CHR(10) || '                          FROM SCM_SYS_CALENDAR_M' || CHR(10) || '                         WHERE BASIS_YYYYMMDD BETWEEN '''''' || P_FROM_YYYYMMDD || '''''' AND '''''' || P_TO_YYYYMMDD || ''''''' || CHR(10) || '                         GROUP BY ISO_YYYYWW, ISO_WEEK ) CW ON CAL.ISO_YYYYWW = CW.ISO_YYYYWW AND CAL.ISO_WEEK = CW.ISO_WEEK' || CHR(10) || '';
    FUNCTION cnt(p_src CLOB, p_tok VARCHAR2) RETURN PLS_INTEGER IS
        n PLS_INTEGER := 0; pos PLS_INTEGER := 1;
    BEGIN
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
            RAISE_APPLICATION_ERROR(-20001, '중단 — ' || p_name || ' ' || p_got || '건 (' || p_exp || ' 기대). 00_PRECHECK 회신. 원문 무변경');
        END IF;
    END;
BEGIN
    DBMS_LOB.CREATETEMPORARY(v_src, TRUE);
    FOR r IN (SELECT TEXT FROM USER_SOURCE WHERE NAME = 'PKG_DMF0053' AND TYPE = 'PACKAGE BODY' ORDER BY LINE) LOOP
        DBMS_LOB.WRITEAPPEND(v_src, LENGTH(r.TEXT), r.TEXT);
    END LOOP;
    v_src := REPLACE(v_src, CHR(13) || CHR(10), CHR(10));   -- CRLF 정규화 (문구는 LF 기준)
    v_new := v_src;
    IF DBMS_LOB.INSTR(v_src, c_mark) > 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 이미 적용됨 (마커 있음). 원문 무변경');
        RETURN;
    END IF;
    expect('T1', cnt(v_new, c_t1_old), 2);
    expect('T2', cnt(v_new, c_t2_old), 2);
    expect('T3', cnt(v_new, c_t3_old), 2);
    expect('G1', cnt(v_new, c_g1_old), 1);
    expect('G2', cnt(v_new, c_g2_old), 1);
    v_new := REPLACE(v_new, c_t1_old, c_t1_new);
    v_new := REPLACE(v_new, c_t2_old, c_t2_new);
    v_new := REPLACE(v_new, c_t3_old, c_t3_new);
    v_new := REPLACE(v_new, c_g1_old, c_g1_new);
    v_new := REPLACE(v_new, c_g2_old, c_g2_new);
    expect('조립 결과 마커', cnt(v_new, c_mark), 10);
    BEGIN
        EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_new;
    EXCEPTION WHEN OTHERS THEN
        NULL;   -- 컴파일 오류 동반 생성(ORA-24344)도 예외로 온다 → 아래 STATUS 검사에서 판정·원문 복원
    END;
    SELECT STATUS INTO v_st FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_DMF0053' AND OBJECT_TYPE = 'PACKAGE BODY';
    SELECT COUNT(*) INTO v_err FROM USER_ERRORS WHERE NAME = 'PKG_DMF0053' AND TYPE = 'PACKAGE BODY';
    IF v_st <> 'VALID' OR v_err > 0 THEN
        FOR e IN (SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME = 'PKG_DMF0053' AND TYPE = 'PACKAGE BODY' ORDER BY SEQUENCE FETCH FIRST 10 ROWS ONLY) LOOP
            DBMS_OUTPUT.PUT_LINE('  ERR L' || e.LINE || ':' || e.POSITION || ' ' || e.TEXT);
        END LOOP;
        EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_src;   -- 원문 자동 복원
        RAISE_APPLICATION_ERROR(-20005, '컴파일 실패(' || v_st || ', 오류 ' || v_err || ') → 원문 복원함. 90_VERIFY 로 STATUS 확인');
    END IF;
    DBMS_OUTPUT.PUT_LINE('APPLIED — PKG_DMF0053 BODY ' || v_st || ' · 마커 10곳 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
SELECT 'POST' CHK, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0053' ORDER BY OBJECT_TYPE;
