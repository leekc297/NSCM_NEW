-- SOURCE-FRESH: SCM_MGR.PKG_DMF0082 PACKAGE BODY LAST_DDL=2026-10-15 16:31:27 FETCHED=2026-10-15 16:34 DB=ZIOUI1 (사내 적용본 문구 대조 · 클라우드는 자기 USER_SOURCE 를 패치)
-- 10_APPLY — [GAP452 2026-10-15] GAP 452 PKG_DMF0082 BODY 패치 (전체 F5, 값 입력 없음, 멱등)
-- 내용: DMF0082(40) 저장 도중 오류 시 앞부분만 확정되던 '반쪽 저장'을 줄인다 (사용자 결정 2026-10-15 "패키지 안만").
--   S1 P_DMF0082_SAVE_MAIN_DATA 40 경로 전파 호출 직전 COMMIT 제거
--   P1 P_PR_DM_PLN_CFM_TO_MKT_FCST GTT TRUNCATE(DDL=자동 확정) 9개 → DELETE
--   P2 같은 프로시저 DBMS_STATS(자동 확정) 4개 제거 (저장 SP 세션 optimizer_dynamic_sampling=2 가 대체)
--   P3 같은 프로시저 내부 COMMIT 제거 (호출자 저장 SP 끝 COMMIT 1곳에서 확정, 예외 ROLLBACK+RAISE 유지)
--   한계: 전파 안의 공용 배치 PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE(통계 수집 25곳)는 무변경 → 그 호출 이후 오류는 종전처럼 앞부분 확정.
-- 범위: 저장 SP 1줄 + 전파 프로시저. 조회 · 원장 · 메타 · FE · 권한 · GTT 정의 무변경. 81 경로 무변경. BE 재기동 불필요.
-- 방식: 이 DB 의 USER_SOURCE 를 읽어 ASCII 표지/패턴으로 치환(한글 비교 없음) → CREATE OR REPLACE (사내 전체본 복사 아님).
-- 가드: 마커 존재 시 무동작 · 각 대상 건수(1/9/4/1)가 다르면 중단(원문 무변경) · 마커 15곳 확인 · 컴파일 오류 시 원문 자동 복원
-- 사내 ZIOUI1 적용 완료(LAST_DDL 2026-10-15 16:31:27) — 정상 저장 경로 실측: 100 저장·0 저장·전파(DM_PLN_MKT_FCST) 정상.
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
    c_mark   CONSTANT VARCHAR2(40)   := 'GAP452 2026-10-15';
    c_pa     CONSTANT VARCHAR2(100)  := '' || CHR(10) || 'PROCEDURE P_PR_DM_PLN_CFM_TO_MKT_FCST';
    c_pb     CONSTANT VARCHAR2(100)  := '' || CHR(10) || 'END P_PR_DM_PLN_CFM_TO_MKT_FCST;';
    c_s1_old CONSTANT VARCHAR2(400)  := '        COMMIT;' || CHR(10) || '        P_PR_DM_PLN_CFM_TO_MKT_FCST(v_created_by, v_inner_result_cursor);' || CHR(10) || '';
    c_s1_new CONSTANT VARCHAR2(600)  := '        NULL;  --[GAP452 2026-10-15] commit removed: propagation error rolls back the whole save (single COMMIT at SP end)' || CHR(10) || '        P_PR_DM_PLN_CFM_TO_MKT_FCST(v_created_by, v_inner_result_cursor);' || CHR(10) || '';
    c_p3_old CONSTANT VARCHAR2(100)  := '' || CHR(10) || '    COMMIT;' || CHR(10) || '';
    c_p3_new CONSTANT VARCHAR2(400)  := '' || CHR(10) || '    NULL;  --[GAP452 2026-10-15] internal commit removed (caller P_DMF0082_SAVE_MAIN_DATA commits once; exception ROLLBACK+RAISE kept)' || CHR(10) || '';
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
            RAISE_APPLICATION_ERROR(-20002, '중단 — P_PR_DM_PLN_CFM_TO_MKT_FCST 위치 확인 불가. 원문 무변경');
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
    FOR r IN (SELECT TEXT FROM USER_SOURCE WHERE NAME = 'PKG_DMF0082' AND TYPE = 'PACKAGE BODY' ORDER BY LINE) LOOP
        DBMS_LOB.WRITEAPPEND(v_src, LENGTH(r.TEXT), r.TEXT);
    END LOOP;
    v_src := REPLACE(v_src, CHR(13) || CHR(10), CHR(10));   -- CRLF 정규화 (문구는 LF 기준)
    v_new := v_src;
    IF DBMS_LOB.INSTR(v_src, c_mark) > 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 이미 적용됨 (마커 있음). 원문 무변경');
        RETURN;
    END IF;
    -- S1
    expect('S1 저장 SP 전파 직전 COMMIT', cnt(v_new, c_s1_old), 1);
    v_new := REPLACE(v_new, c_s1_old, c_s1_new);
    -- P1~P3 (전파 프로시저 구간)
    split_seg;
    expect('P1 TRUNCATE', REGEXP_COUNT(v_seg, 'EXECUTE IMMEDIATE ''TRUNCATE TABLE (SCM_MGR\.\w+)'';'), 9);
    expect('P2 DBMS_STATS', REGEXP_COUNT(v_seg, '(    )(DBMS_STATS\.GATHER_TABLE_STATS\(OWNNAME => ''SCM_MGR'', TABNAME => ''\w+'', NO_INVALIDATE => FALSE\);)'), 4);
    expect('P3 COMMIT', cnt(v_seg, c_p3_old), 1);
    v_seg := REGEXP_REPLACE(v_seg, 'EXECUTE IMMEDIATE ''TRUNCATE TABLE (SCM_MGR\.\w+)'';', 'DELETE FROM \1;  --[GAP452 2026-10-15] TRUNCATE->DELETE (no implicit commit)');
    v_seg := REGEXP_REPLACE(v_seg, '(    )(DBMS_STATS\.GATHER_TABLE_STATS\(OWNNAME => ''SCM_MGR'', TABNAME => ''\w+'', NO_INVALIDATE => FALSE\);)', '\1NULL;  --[GAP452 2026-10-15] stats removed (implicit commit): \2');
    v_seg := REPLACE(v_seg, c_p3_old, c_p3_new);
    join_seg;
    IF (DBMS_LOB.GETLENGTH(v_new) - DBMS_LOB.GETLENGTH(REPLACE(v_new, c_mark, ''))) / LENGTH(c_mark) <> 15 THEN
        RAISE_APPLICATION_ERROR(-20004, '중단 — 조립 결과 마커 수 불일치(15 기대). 원문 무변경');
    END IF;
    BEGIN
        EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_new;
    EXCEPTION WHEN OTHERS THEN
        NULL;   -- 컴파일 오류 동반 생성(ORA-24344)도 예외로 온다 → 아래 STATUS 검사에서 판정·원문 복원 (2026-10-15 GAP452 리허설 사고 정정)
    END;
    SELECT STATUS INTO v_st FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_DMF0082' AND OBJECT_TYPE = 'PACKAGE BODY';
    SELECT COUNT(*) INTO v_err FROM USER_ERRORS WHERE NAME = 'PKG_DMF0082' AND TYPE = 'PACKAGE BODY';
    IF v_st <> 'VALID' OR v_err > 0 THEN
        FOR e IN (SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME = 'PKG_DMF0082' AND TYPE = 'PACKAGE BODY' ORDER BY SEQUENCE FETCH FIRST 10 ROWS ONLY) LOOP
            DBMS_OUTPUT.PUT_LINE('  ERR L' || e.LINE || ':' || e.POSITION || ' ' || e.TEXT);
        END LOOP;
        EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_src;   -- 원문 자동 복원
        RAISE_APPLICATION_ERROR(-20005, '컴파일 실패(' || v_st || ', 오류 ' || v_err || ') → 원문 복원함. 90_VERIFY 로 STATUS 확인');
    END IF;
    DBMS_OUTPUT.PUT_LINE('APPLIED — PKG_DMF0082 BODY ' || v_st || ' · 마커 15곳 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
SELECT 'POST' CHK, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0082' ORDER BY OBJECT_TYPE;
