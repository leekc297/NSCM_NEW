-- SOURCE-FRESH: SCM_MGR.PKG_DMF0082 PACKAGE BODY LAST_DDL=2026-10-15 16:31:27 FETCHED=2026-10-15 16:34 DB=ZIOUI1 (사내 적용본 문구 대조 · 클라우드는 자기 USER_SOURCE 를 패치)
-- 99_ROLLBACK — [GAP452 2026-10-15] GAP 452 원복 (전체 F5, 값 입력 없음, 멱등) — ASCII 표지·패턴으로 역치환
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
    IF DBMS_LOB.INSTR(v_src, c_mark) = 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 마커 없음 (미적용 상태). 원문 무변경');
        RETURN;
    END IF;
    expect('S1', cnt(v_new, c_s1_new), 1);
    v_new := REPLACE(v_new, c_s1_new, c_s1_old);
    split_seg;
    expect('P1', REGEXP_COUNT(v_seg, 'DELETE FROM (SCM_MGR\.\w+);  --\[GAP452 2026-10-15\] TRUNCATE->DELETE \(no implicit commit\)'), 9);
    expect('P2', REGEXP_COUNT(v_seg, '(    )NULL;  --\[GAP452 2026-10-15\] stats removed \(implicit commit\): (DBMS_STATS\.GATHER_TABLE_STATS\(OWNNAME => ''SCM_MGR'', TABNAME => ''\w+'', NO_INVALIDATE => FALSE\);)'), 4);
    expect('P3', cnt(v_seg, c_p3_new), 1);
    v_seg := REGEXP_REPLACE(v_seg, 'DELETE FROM (SCM_MGR\.\w+);  --\[GAP452 2026-10-15\] TRUNCATE->DELETE \(no implicit commit\)', 'EXECUTE IMMEDIATE ''TRUNCATE TABLE \1'';');
    v_seg := REGEXP_REPLACE(v_seg, '(    )NULL;  --\[GAP452 2026-10-15\] stats removed \(implicit commit\): (DBMS_STATS\.GATHER_TABLE_STATS\(OWNNAME => ''SCM_MGR'', TABNAME => ''\w+'', NO_INVALIDATE => FALSE\);)', '\1\2');
    v_seg := REPLACE(v_seg, c_p3_new, c_p3_old);
    join_seg;
    IF DBMS_LOB.INSTR(v_new, c_mark) > 0 THEN
        RAISE_APPLICATION_ERROR(-20004, '중단 — 조립 결과 불일치(마커 잔존). 원문 무변경');
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
    DBMS_OUTPUT.PUT_LINE('ROLLED BACK — PKG_DMF0082 BODY ' || v_st || ' · 마커 0 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
SELECT 'POST' CHK, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0082' ORDER BY OBJECT_TYPE;
