-- SOURCE-FRESH: SCM_MGR.PKG_DMF0072 PACKAGE BODY LAST_DDL=2026-10-15 11:17:46 FETCHED=2026-10-15 21:19 DB=ZIOUI1 (사내는 GAP412 미적용 — 문구 기준 = GAP412 적용본 · 클라우드는 자기 USER_SOURCE 를 패치)
-- 10_APPLY — [GAP418 2026-10-15] GAP 418 PKG_DMF0072 BODY 패치 (전체 F5, 값 입력 없음, 멱등)
-- 내용: N N Master Mapping 저장 P_DMF0072_SAVE_NNMASTER_MAPPING — 행별 존재 확인 · UPDATE 조건에서 END_CUSTOMER 제외 (AS-IS MERGE ON 과 같은 키).
--   종전: End Customer 만 바꾼 수정 행이 기존 행과 못 맞춰져 INSERT → ORA-00001 저장 실패. AS-IS: 같은 행 UPDATE(End Customer 는 미갱신).
--   행별 루프 구조(ORA-38104 사유) · 신규(I) 행 처리 · 다른 프로시저 무변경. 원장 · 메타 · FE · 권한 무변경. BE 재기동 불필요.
-- ⚠ 선행: DMF0072_GAP412_INSDUP_CLOUD_20261015 (마커 GAP412 2026-10-15). 없으면 중단.
-- 방식: 이 DB 의 USER_SOURCE 를 읽어 저장 SP 구간 안 ASCII 문구 2줄을 주석 처리 → CREATE OR REPLACE (사내 전체본 복사 아님).
-- 가드: 마커 존재 시 무동작 · GAP412 마커 없으면 중단 · 대상 줄 각 1건 아니면 중단(원문 무변경) · 컴파일 오류 시 원문 자동 복원
-- 실행 전 00_PRECHECK_CLOUD · 실행 뒤 90_VERIFY · 원복 = 99_ROLLBACK
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    v_src    CLOB;
    v_new    CLOB;
    v_seg    CLOB;
    v_st     VARCHAR2(30);
    v_err    PLS_INTEGER;
    v_a      PLS_INTEGER;
    v_b      PLS_INTEGER;
    c_mark   CONSTANT VARCHAR2(40)   := 'GAP418 2026-10-15';
    c_m412   CONSTANT VARCHAR2(40)   := 'GAP412 2026-10-15';
    c_pa     CONSTANT VARCHAR2(200)  := '' || CHR(10) || 'PROCEDURE P_DMF0072_SAVE_NNMASTER_MAPPING' || CHR(10) || '';
    c_pb     CONSTANT VARCHAR2(200)  := '' || CHR(10) || 'END P_DMF0072_SAVE_NNMASTER_MAPPING;';
    c_old1   CONSTANT VARCHAR2(400)  := '          AND  A.END_CUSTOMER    = REC.END_CUSTOMER' || CHR(10) || '';
    c_new1   CONSTANT VARCHAR2(400)  := '          --AND  A.END_CUSTOMER    = REC.END_CUSTOMER  -- [GAP418 2026-10-15] AS-IS MERGE ON excludes END_CUSTOMER (not in PK)' || CHR(10) || '';
    c_old2   CONSTANT VARCHAR2(400)  := '              AND A.END_CUSTOMER    = REC.END_CUSTOMER' || CHR(10) || '';
    c_new2   CONSTANT VARCHAR2(400)  := '              --AND A.END_CUSTOMER    = REC.END_CUSTOMER  -- [GAP418 2026-10-15] AS-IS MERGE ON excludes END_CUSTOMER (not in PK)' || CHR(10) || '';
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
    PROCEDURE split_seg IS
    BEGIN
        v_a := DBMS_LOB.INSTR(v_new, c_pa);
        v_b := CASE WHEN v_a > 0 THEN DBMS_LOB.INSTR(v_new, c_pb, v_a) ELSE 0 END;
        IF NOT (v_a > 0 AND v_b > v_a) THEN
            RAISE_APPLICATION_ERROR(-20002, '중단 — P_DMF0072_SAVE_NNMASTER_MAPPING 위치 확인 불가. 원문 무변경');
        END IF;
        v_seg := SUBSTR(v_new, v_a, v_b - v_a);
    END;
    PROCEDURE join_seg IS
    BEGIN
        v_new := SUBSTR(v_new, 1, v_a - 1) || v_seg || SUBSTR(v_new, v_b);
    END;
    PROCEDURE expect(p_name VARCHAR2, p_got PLS_INTEGER, p_exp PLS_INTEGER) IS
    BEGIN
        IF p_got <> p_exp THEN
            RAISE_APPLICATION_ERROR(-20001, '중단 — ' || p_name || ' ' || p_got || '건 (' || p_exp || ' 기대). 00_PRECHECK 회신. 원문 무변경');
        END IF;
    END;
BEGIN
    DBMS_LOB.CREATETEMPORARY(v_src, TRUE);
    FOR r IN (SELECT TEXT FROM USER_SOURCE WHERE NAME = 'PKG_DMF0072' AND TYPE = 'PACKAGE BODY' ORDER BY LINE) LOOP
        DBMS_LOB.WRITEAPPEND(v_src, LENGTH(r.TEXT), r.TEXT);
    END LOOP;
    v_src := REPLACE(v_src, CHR(13) || CHR(10), CHR(10));   -- CRLF 정규화 (문구는 LF 기준)
    v_new := v_src;
    IF DBMS_LOB.INSTR(v_src, c_mark) > 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 이미 적용됨 (마커 있음). 원문 무변경');
        RETURN;
    END IF;
    IF DBMS_LOB.INSTR(v_src, c_m412) = 0 THEN
        RAISE_APPLICATION_ERROR(-20003, '중단 — 선행 GAP412 미적용 (마커 GAP412 2026-10-15 없음). DMF0072_GAP412_INSDUP 패키지 먼저 적용. 원문 무변경');
    END IF;
    split_seg;
    expect('존재 확인 END_CUSTOMER 조건 줄', cnt(v_seg, c_old1), 1);
    expect('UPDATE WHERE END_CUSTOMER 조건 줄', cnt(v_seg, c_old2), 1);
    v_seg := REPLACE(v_seg, c_old1, c_new1);
    v_seg := REPLACE(v_seg, c_old2, c_new2);
    join_seg;
    expect('조립 결과 마커', cnt(v_new, c_mark), 2);
    BEGIN
        EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_new;
    EXCEPTION WHEN OTHERS THEN
        NULL;   -- 컴파일 오류 동반 생성(ORA-24344)도 예외로 온다 → 아래 STATUS 검사에서 판정·원문 복원
    END;
    SELECT STATUS INTO v_st FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_DMF0072' AND OBJECT_TYPE = 'PACKAGE BODY';
    SELECT COUNT(*) INTO v_err FROM USER_ERRORS WHERE NAME = 'PKG_DMF0072' AND TYPE = 'PACKAGE BODY';
    IF v_st <> 'VALID' OR v_err > 0 THEN
        FOR e IN (SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME = 'PKG_DMF0072' AND TYPE = 'PACKAGE BODY' ORDER BY SEQUENCE FETCH FIRST 10 ROWS ONLY) LOOP
            DBMS_OUTPUT.PUT_LINE('  ERR L' || e.LINE || ':' || e.POSITION || ' ' || e.TEXT);
        END LOOP;
        BEGIN
            EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_src;   -- 원문 자동 복원
        EXCEPTION WHEN OTHERS THEN
            NULL;
        END;
        RAISE_APPLICATION_ERROR(-20005, '컴파일 실패(' || v_st || ', 오류 ' || v_err || ') → 원문 복원함. 90_VERIFY 로 STATUS 확인');
    END IF;
    DBMS_OUTPUT.PUT_LINE('APPLIED — PKG_DMF0072 BODY ' || v_st || ' · 마커 2곳 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
SELECT 'POST' CHK, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0072' ORDER BY OBJECT_TYPE;
