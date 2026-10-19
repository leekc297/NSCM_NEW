-- SOURCE-FRESH: SCM_MGR.PKG_DMF0044 PACKAGE BODY LAST_DDL=2026-10-14 14:45:28 FETCHED=2026-10-15 18:54 DB=ZIOUI1 (사내 수정 전 원문 기준 문구 · 클라우드는 자기 USER_SOURCE 를 패치)
-- 99_ROLLBACK — [GAP313 2026-10-15] GAP 313 원복 (전체 F5, 값 입력 없음, 멱등) — 적용 블록을 원래 TODO 주석 블록으로 역치환
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    v_src    CLOB;
    v_new    CLOB;
    v_seg    CLOB;
    v_st     VARCHAR2(30);
    v_err    PLS_INTEGER;
    v_arg    PLS_INTEGER;
    v_a      PLS_INTEGER;
    v_b      PLS_INTEGER;
    c_mark   CONSTANT VARCHAR2(40)   := 'GAP313 2026-10-15';
    c_pa     CONSTANT VARCHAR2(200)  := '' || CHR(10) || 'PROCEDURE P_DMF0044_SAVE_SALES_PLAN_REPORT_C_CF' || CHR(10) || '';
    c_pb     CONSTANT VARCHAR2(200)  := '' || CHR(10) || 'END P_DMF0044_SAVE_SALES_PLAN_REPORT_C_CF;';
    c_old    CONSTANT VARCHAR2(4000) := '    /* TODO DMF0044_MOBILE_REPORT_CREATE' || CHR(10) || '    IF V_EXISTS = 1 THEN' || CHR(10) || '        SCM_MGR.DMF0044_MOBILE_REPORT_CREATE(V_DIVISION_ID, V_VERSION_NO, V_CUTOFF_TYPE, ''T'', V_CREATED_BY);' || CHR(10) || '    END IF;' || CHR(10) || '    */' || CHR(10) || '';
    c_new    CONSTANT VARCHAR2(4000) := '    /* [GAP313 2026-10-15] TODO released - AS-IS DMF0044_SAVE_SALES_PLAN_REPORT_C_CF parity:' || CHR(10) || '       SEND_YN=''Y'' version -> regenerate transfer data (ACTION ''T'') after cutoff save.' || CHR(10) || '       Regeneration failure (validation message or error) -> RAISE -> whole save ROLLBACK (AS-IS nested TRAN rollback). */' || CHR(10) || '    IF V_EXISTS = 1 THEN' || CHR(10) || '        DECLARE' || CHR(10) || '            L_MOB_RC   SYS_REFCURSOR;' || CHR(10) || '            L_MOB_MSG  VARCHAR2(4000 CHAR);' || CHR(10) || '        BEGIN' || CHR(10) || '            P_DMF0044_MOBILE_REPORT_CREATE(V_DIVISION_ID, V_VERSION_NO, V_CUTOFF_TYPE, ''T'', V_CREATED_BY, L_MOB_RC);' || CHR(10) || '            FETCH L_MOB_RC INTO L_MOB_MSG;' || CHR(10) || '            CLOSE L_MOB_RC;' || CHR(10) || '            IF NVL(L_MOB_MSG, ''-'') <> ''success'' THEN' || CHR(10) || '                RAISE_APPLICATION_ERROR(-20044, L_MOB_MSG);' || CHR(10) || '            END IF;' || CHR(10) || '        END;' || CHR(10) || '    END IF;' || CHR(10) || '';
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
            RAISE_APPLICATION_ERROR(-20002, '중단 — P_DMF0044_SAVE_SALES_PLAN_REPORT_C_CF 위치 확인 불가. 원문 무변경');
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
    FOR r IN (SELECT TEXT FROM USER_SOURCE WHERE NAME = 'PKG_DMF0044' AND TYPE = 'PACKAGE BODY' ORDER BY LINE) LOOP
        DBMS_LOB.WRITEAPPEND(v_src, LENGTH(r.TEXT), r.TEXT);
    END LOOP;
    v_src := REPLACE(v_src, CHR(13) || CHR(10), CHR(10));   -- CRLF 정규화 (문구는 LF 기준)
    v_new := v_src;
    IF DBMS_LOB.INSTR(v_src, c_mark) = 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 마커 없음 (미적용 상태). 원문 무변경');
        RETURN;
    END IF;
    split_seg;
    expect('CF 적용 블록', cnt(v_seg, c_new), 1);
    v_seg := REPLACE(v_seg, c_new, c_old);
    join_seg;
    expect('조립 결과 마커', cnt(v_new, c_mark), 0);
    BEGIN
        EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_new;
    EXCEPTION WHEN OTHERS THEN
        NULL;   -- 컴파일 오류 동반 생성(ORA-24344)도 예외로 온다 → 아래 STATUS 검사에서 판정·원문 복원
    END;
    SELECT STATUS INTO v_st FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_DMF0044' AND OBJECT_TYPE = 'PACKAGE BODY';
    SELECT COUNT(*) INTO v_err FROM USER_ERRORS WHERE NAME = 'PKG_DMF0044' AND TYPE = 'PACKAGE BODY';
    IF v_st <> 'VALID' OR v_err > 0 THEN
        FOR e IN (SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME = 'PKG_DMF0044' AND TYPE = 'PACKAGE BODY' ORDER BY SEQUENCE FETCH FIRST 10 ROWS ONLY) LOOP
            DBMS_OUTPUT.PUT_LINE('  ERR L' || e.LINE || ':' || e.POSITION || ' ' || e.TEXT);
        END LOOP;
        BEGIN
            EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_src;   -- 원문 자동 복원
        EXCEPTION WHEN OTHERS THEN
            NULL;
        END;
        RAISE_APPLICATION_ERROR(-20005, '컴파일 실패(' || v_st || ', 오류 ' || v_err || ') → 원문 복원함. 90_VERIFY 로 STATUS 확인');
    END IF;
    DBMS_OUTPUT.PUT_LINE('ROLLED BACK — PKG_DMF0044 BODY ' || v_st || ' · 마커 0 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
SELECT 'POST' CHK, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0044' ORDER BY OBJECT_TYPE;
