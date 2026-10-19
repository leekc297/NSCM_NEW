-- SOURCE-FRESH: SCM_MGR.PKG_DMF0068 PACKAGE BODY LAST_DDL=2026-10-15 20:05:01 FETCHED=2026-10-15 20:06 DB=ZIOUI1 (사내 적용본 문구 대조 · 클라우드는 자기 USER_SOURCE 를 패치)
-- 10_APPLY — [GAP392 2026-10-15] GAP 392 PKG_DMF0068 BODY 패치 (전체 F5, 값 입력 없음, 멱등)
-- 내용: Demand Manager 조회 결과·Project 선택 목록을 AS-IS 처럼 대소문자 무시 오름차순으로 정렬한다.
--   (AS-IS DB 콜레이션 Latin1_General_CI_AS = 대소문자 무시 · Oracle 기본 BINARY = 대문자 우선 → 같은 ORDER BY 라도 순서가 달랐다)
--   L1 룩업 P_DMF0068_GET_LOOKUPPROJECT        ORDER BY SEGMENT1       → ORDER BY UPPER(D.SEGMENT1), D.SEGMENT1
--   O1 조회 P_DMF0068_GET_ORDERLIST 동적 SQL 2분기  ORDER BY B.PROJECT_NAME → ORDER BY UPPER(B.PROJECT_NAME), B.PROJECT_NAME (뒤 정렬키 그대로)
-- 범위: 위 두 프로시저의 정렬절만. 조회 행·값 · 원장 · 메타 · FE · 권한 · GTT 무변경. BE 재기동 불필요.
-- 방식: 이 DB 의 USER_SOURCE 를 읽어 ASCII 문구로 치환(한글 비교 없음) → CREATE OR REPLACE (사내 전체본 복사 아님).
-- 가드: 마커 존재 시 무동작 · 각 대상 건수(L1 1 / O1 2)가 다르면 중단(원문 무변경) · 마커 3곳 확인 · 컴파일 오류 시 원문 자동 복원
-- 사내 ZIOUI1 적용 완료(LAST_DDL 2026-10-15 20:05:01).
-- 실행 전 00_PRECHECK_CLOUD · 실행 뒤 90_VERIFY · 원복 = 99_ROLLBACK
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    v_src    CLOB;
    v_new    CLOB;
    v_st     VARCHAR2(30);
    v_err    PLS_INTEGER;
    c_mark   CONSTANT VARCHAR2(40) := 'GAP392 2026-10-15';
    c_l1_old CONSTANT VARCHAR2(4000) := '        WHERE D.LOOKUP_TYPE = ''PROJECT_MODEL_MAPPING''' || CHR(10) || '        ORDER BY SEGMENT1;' || CHR(10) || '';
    c_l1_new CONSTANT VARCHAR2(4000) := '        WHERE D.LOOKUP_TYPE = ''PROJECT_MODEL_MAPPING''' || CHR(10) || '        ORDER BY UPPER(D.SEGMENT1), D.SEGMENT1;  --[GAP392 2026-10-15] AS-IS CI collation order' || CHR(10) || '';
    c_o1_old CONSTANT VARCHAR2(4000) := '            ''ORDER BY B.PROJECT_NAME, NVL(ORDERSTART, ''''999999''''), B.MEASURE'';' || CHR(10) || '';
    c_o1_new CONSTANT VARCHAR2(4000) := '            ''ORDER BY UPPER(B.PROJECT_NAME), B.PROJECT_NAME, NVL(ORDERSTART, ''''999999''''), B.MEASURE'';  --[GAP392 2026-10-15] AS-IS CI collation order' || CHR(10) || '';
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
    FOR r IN (SELECT TEXT FROM USER_SOURCE WHERE NAME = 'PKG_DMF0068' AND TYPE = 'PACKAGE BODY' ORDER BY LINE) LOOP
        DBMS_LOB.WRITEAPPEND(v_src, LENGTH(r.TEXT), r.TEXT);
    END LOOP;
    v_src := REPLACE(v_src, CHR(13) || CHR(10), CHR(10));   -- CRLF 정규화 (문구는 LF 기준)
    v_new := v_src;
    IF DBMS_LOB.INSTR(v_src, c_mark) > 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 이미 적용됨 (마커 있음). 원문 무변경');
        RETURN;
    END IF;
    expect('L1', cnt(v_new, c_l1_old), 1);
    expect('O1', cnt(v_new, c_o1_old), 2);
    v_new := REPLACE(v_new, c_l1_old, c_l1_new);
    v_new := REPLACE(v_new, c_o1_old, c_o1_new);
    expect('조립 결과 마커', cnt(v_new, c_mark), 3);
    BEGIN
        EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_new;
    EXCEPTION WHEN OTHERS THEN
        NULL;   -- 컴파일 오류 동반 생성(ORA-24344)도 예외로 온다 → 아래 STATUS 검사에서 판정·원문 복원
    END;
    SELECT STATUS INTO v_st FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_DMF0068' AND OBJECT_TYPE = 'PACKAGE BODY';
    SELECT COUNT(*) INTO v_err FROM USER_ERRORS WHERE NAME = 'PKG_DMF0068' AND TYPE = 'PACKAGE BODY';
    IF v_st <> 'VALID' OR v_err > 0 THEN
        FOR e IN (SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME = 'PKG_DMF0068' AND TYPE = 'PACKAGE BODY' ORDER BY SEQUENCE FETCH FIRST 10 ROWS ONLY) LOOP
            DBMS_OUTPUT.PUT_LINE('  ERR L' || e.LINE || ':' || e.POSITION || ' ' || e.TEXT);
        END LOOP;
        EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_src;   -- 원문 자동 복원
        RAISE_APPLICATION_ERROR(-20005, '컴파일 실패(' || v_st || ', 오류 ' || v_err || ') → 원문 복원함. 90_VERIFY 로 STATUS 확인');
    END IF;
    DBMS_OUTPUT.PUT_LINE('APPLIED — PKG_DMF0068 BODY ' || v_st || ' · 마커 3곳 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
SELECT 'POST' CHK, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0068' ORDER BY OBJECT_TYPE;
