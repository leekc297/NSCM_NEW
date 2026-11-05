-- SOURCE-FRESH: SCM_MGR.PKG_DMF0044 PACKAGE BODY LAST_DDL=2026-10-27 13:14:01 FETCHED=2026-10-28 16:06 DB=ZIOUI1 (사내 기준본 대조 · 클라우드는 자기 USER_SOURCE 를 패치)
-- 10_APPLY — [E20261028-DUPROLLBACK] MOBILE_REPORT_CREATE 검증 실패 = 저장 전체 취소 (전체 F5, 값 입력 없음, 멱등)
-- 원인: P_DMF0044_MOBILE_REPORT_CREATE 의 검증 실패 분기 6곳이 메시지만 돌려주고 RETURN(ROLLBACK 없음) →
--       호출한 DMF0049 저장(PKG_DMF0049 L1316~1319)이 이어서 COMMIT → 같은 키 중복 세트가 그대로 저장됨.
--       AS-IS DMF0044_MOBILE_REPORT_CREATE 는 같은 분기에서 GOTO ERR_RTN → ROLLBACK TRANSACTION (바깥 DMF0049 트랜잭션까지 취소).
-- 내용: 6개 분기(DIVISION_INVALID · VERSION_NO_INVALID · ACTION_TYPE_INVALID_C · ACTION_TYPE_INVALID_T · DEPT_NAME INVALID ·
--       DUPLICATION VALIDATION)의 V_LOG_TYPE 대입 줄 바로 앞에 'ROLLBACK;' 한 줄씩 삽입. 로그(PR_DM_SYS_LOG_BATCH)는
--       자율 트랜잭션이라 ROLLBACK 후에도 남는다. 화면 메시지·반환 커서는 그대로.
-- 범위: PKG_DMF0044 BODY 6줄 추가. 다른 프로시저·메타·FE·권한 무변경. BE 재기동 불필요.
-- 방식: 이 DB 의 USER_SOURCE 를 줄 단위로 읽어(FRESH-GATE = 실행 시점 원문) MOBILE_REPORT_CREATE 범위 안에서만 ASCII 토큰으로 위치를 찾는다.
-- 가드: 마커 존재 시 무동작 · 대상 줄 ≠ 6 이면 중단(원문 무변경) · ORA-24344(컴파일 오류 동반 생성) 외 오류는 중단 ·
--       컴파일 실패 시 원문 자동 복원 · 적용 후 마커 6줄 실측
-- 사내 ZIOUI1 적용 완료(2026-10-28). 실행 전 00_PRECHECK_CLOUD · 실행 뒤 90_VERIFY · 원복 = 99_ROLLBACK_DUPROLLBACK_PATCH
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    TYPE t_lines IS TABLE OF VARCHAR2(32767) INDEX BY PLS_INTEGER;
    l        t_lines;
    v_src    CLOB;
    v_new    CLOB;
    v_st     VARCHAR2(30);
    v_err    PLS_INTEGER;
    v_code   PLS_INTEGER := 0;
    v_msg    VARCHAR2(4000);
    n        PLS_INTEGER := 0;
    s_ln     PLS_INTEGER := 0;
    e_ln     PLS_INTEGER := 0;
    v_ind    VARCHAR2(200);
    c_mark   CONSTANT VARCHAR2(40)  := '[E20261028-DUPROLLBACK]';
    c_pat    CONSTANT VARCHAR2(300) := 'V_LOG_TYPE\s*:=\s*''(DIVISION_INVALID|VERSION_NO_INVALID|ACTION_TYPE_INVALID_C|ACTION_TYPE_INVALID_T|DEPT_NAME INVALID|DEPARTMENT_NAME INVALID|DUPLICATION VALIDATION)''';
    c_cmt    CONSTANT VARCHAR2(200) := 'ROLLBACK;    -- 2026.10.28 [E20261028-DUPROLLBACK] validation fail = whole save rollback (AS-IS ERR_RTN ROLLBACK TRANSACTION parity)';
    FUNCTION is_cmt(p VARCHAR2) RETURN BOOLEAN IS
    BEGIN
        RETURN SUBSTR(LTRIM(p), 1, 2) = '--';
    END;
    FUNCTION is_target(k PLS_INTEGER) RETURN BOOLEAN IS
    BEGIN
        RETURN k > s_ln AND k < e_ln AND REGEXP_LIKE(l(k), c_pat, 'i') AND NOT is_cmt(l(k));
    END;
    PROCEDURE put(p VARCHAR2) IS
    BEGIN
        IF p IS NOT NULL THEN DBMS_LOB.WRITEAPPEND(v_new, LENGTH(p), p); END IF;
    END;
BEGIN
    -- FRESH-GATE: 기준본 = 실행 시점의 이 DB USER_SOURCE (로컬 파일 아님)
    SELECT TEXT BULK COLLECT INTO l FROM USER_SOURCE WHERE NAME = 'PKG_DMF0044' AND TYPE = 'PACKAGE BODY' ORDER BY LINE;
    IF l.COUNT = 0 THEN
        RAISE_APPLICATION_ERROR(-20003, '중단 — PKG_DMF0044 BODY 없음');
    END IF;
    DBMS_LOB.CREATETEMPORARY(v_src, TRUE);
    DBMS_LOB.CREATETEMPORARY(v_new, TRUE);
    FOR k IN 1 .. l.COUNT LOOP
        DBMS_LOB.WRITEAPPEND(v_src, LENGTH(l(k)), l(k));
        IF s_ln = 0 AND REGEXP_LIKE(l(k), '^\s*PROCEDURE\s+P_DMF0044_MOBILE_REPORT_CREATE(\s|\(|$)', 'i') THEN s_ln := k; END IF;
        IF s_ln > 0 AND e_ln = 0 AND REGEXP_LIKE(l(k), '^\s*END\s+P_DMF0044_MOBILE_REPORT_CREATE\s*;', 'i') THEN e_ln := k; END IF;
    END LOOP;
    IF DBMS_LOB.INSTR(v_src, c_mark) > 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 이미 적용됨 (마커 있음). 원문 무변경');
        RETURN;
    END IF;
    IF s_ln = 0 OR e_ln = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, '중단 — P_DMF0044_MOBILE_REPORT_CREATE 범위 못 찾음(시작 ' || s_ln || ' / 끝 ' || e_ln || '). 원문 무변경');
    END IF;
    FOR k IN 1 .. l.COUNT LOOP
        IF is_target(k) THEN n := n + 1; END IF;
    END LOOP;
    IF n <> 6 THEN
        RAISE_APPLICATION_ERROR(-20001, '중단 — 검증 실패 분기 ' || n || '건 (6 기대). 00_PRECHECK P3 회신. 원문 무변경');
    END IF;
    FOR k IN 1 .. l.COUNT LOOP
        IF is_target(k) THEN
            v_ind := REGEXP_SUBSTR(l(k), '^\s*');
            put(v_ind || c_cmt || CHR(10));
        END IF;
        put(l(k));
    END LOOP;
    IF DBMS_LOB.INSTR(v_new, c_mark, 1, 6) = 0 OR DBMS_LOB.INSTR(v_new, c_mark, 1, 7) > 0 THEN
        RAISE_APPLICATION_ERROR(-20004, '중단 — 조립 결과 마커 수 ≠ 6. 원문 무변경');
    END IF;
    BEGIN
        EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_new;
    EXCEPTION WHEN OTHERS THEN
        v_code := SQLCODE; v_msg := SQLERRM;
    END;
    IF v_code NOT IN (0, -24344) THEN
        -- 생성 자체가 실행되지 않은 오류(예: ORA-04021 다른 세션이 PKG 실행 중) — 원문 그대로이므로 중단만 한다
        RAISE_APPLICATION_ERROR(-20006, '중단 — 생성 미실행 오류 ' || v_msg || ' (원문 무변경. 잠시 후 재실행)');
    END IF;
    SELECT STATUS INTO v_st FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_DMF0044' AND OBJECT_TYPE = 'PACKAGE BODY';
    SELECT COUNT(*) INTO v_err FROM USER_ERRORS WHERE NAME = 'PKG_DMF0044' AND TYPE = 'PACKAGE BODY';
    IF v_st <> 'VALID' OR v_err > 0 THEN
        FOR x IN (SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME = 'PKG_DMF0044' AND TYPE = 'PACKAGE BODY' ORDER BY SEQUENCE FETCH FIRST 10 ROWS ONLY) LOOP
            DBMS_OUTPUT.PUT_LINE('  ERR L' || x.LINE || ':' || x.POSITION || ' ' || x.TEXT);
        END LOOP;
        BEGIN
            EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_src;   -- 원문 자동 복원
        EXCEPTION WHEN OTHERS THEN NULL;
        END;
        RAISE_APPLICATION_ERROR(-20005, '컴파일 실패(' || v_st || ', 오류 ' || v_err || ') → 원문 복원함. 90_VERIFY 로 STATUS 확인');
    END IF;
    SELECT COUNT(*) INTO n FROM USER_SOURCE WHERE NAME = 'PKG_DMF0044' AND TYPE = 'PACKAGE BODY' AND TEXT LIKE '%' || c_mark || '%';
    IF n <> 6 THEN
        RAISE_APPLICATION_ERROR(-20007, '확인 실패 — 적용 후 마커 ' || n || '줄 (6 기대). 90_VERIFY 회신');
    END IF;
    DBMS_OUTPUT.PUT_LINE('APPLIED — PKG_DMF0044 BODY ' || v_st || ' · ROLLBACK 6줄 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
SELECT 'POST' CHK, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0044' ORDER BY OBJECT_TYPE;
