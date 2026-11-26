-- SOURCE-FRESH: SCM_MGR 화면 DMF0014 객체·META (DB=ZIOUI1 SERVER_HOST=localhost) FETCHED=2026-11-22 13:50:09
/* 20_PKG PKG_DMF0014 — 수정분만 적용(클라우드 원문이 사내와 다른 SPEC/BODY 만 CREATE OR REPLACE · 같으면 SKIP)
 * 패키지 DMF0014_CLOUD_DB_MOD_20261122_1350 · 생성 tools/CloudPkg/cloud_pkg.py 1.4.1 · 2026-11-22 13:50
 * 실행 계정 = SCM_MGR (전체 F5 · 반복 실행 안전)
 * 결과 = DBMS_OUTPUT(DBeaver Output 창) 의 SKIP(같음·미적용) / APPLY(교체) / ERROR 줄로 확인
 * 되돌리기 = 05_BACKUP 을 먼저 실행해 두면 99_ROLLBACK 이 이 객체를 실행 전 원문으로 복원
 */
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED

/* PACKAGE PKG_DMF0014 — 수정분만 패치 · 기준본 = 사내 적용 백업 _artifacts\_apply_corporate\UIPKG_CONSOLIDATION_20260915\01_backup\objects\PKG_DMF0014.PACKAGE.sql
 * 변경 2개 구간: 기준본 L1~4 → 사내 L1~4 (삭제 1줄 · 추가 1줄) / 기준본 L103~106 → 사내 L103~119 (삭제 0줄 · 추가 13줄)
 * 가드: 이미 사내와 같으면 SKIP · 구간 기준 문구가 1건이 아니면 중단(원문 무변경) · 조립 결과 ≠ 사내 원문이면 중단 · 컴파일 오류면 원문 자동 복원 */
DECLARE
    c_dry   CONSTANT BOOLEAN := FALSE;
    v_raw   CLOB;
    v_src   CLOB;
    v_new   CLOB;
    v_o     CLOB;
    v_n     CLOB;
    v_cnt   PLS_INTEGER;
    v_pos   PLS_INTEGER;
    v_st    VARCHAR2(30);
    v_err   PLS_INTEGER;
    FUNCTION hv(c CLOB) RETURN NUMBER IS
        n NUMBER := 0; p INTEGER := 1; i INTEGER := 0; l INTEGER := NVL(DBMS_LOB.GETLENGTH(c), 0);
    BEGIN
        WHILE p <= l LOOP
            i := i + 1;
            n := n + DBMS_UTILITY.GET_HASH_VALUE(i || '~' || DBMS_LOB.SUBSTR(c, 1000, p), 1, 1073741824);
            p := p + 1000;
        END LOOP;
        RETURN n;
    END;
    FUNCTION cnt(c CLOB, t CLOB) RETURN PLS_INTEGER IS
        n PLS_INTEGER := 0; p PLS_INTEGER := 1;
    BEGIN
        LOOP
            p := DBMS_LOB.INSTR(c, t, p);
            EXIT WHEN NVL(p, 0) = 0;
            n := n + 1; p := p + DBMS_LOB.GETLENGTH(t);
        END LOOP;
        RETURN n;
    END;
    PROCEDURE hunk(k PLS_INTEGER) IS
    BEGIN
        v_cnt := cnt(v_new, v_o);
        IF v_cnt <> 1 THEN
            RAISE_APPLICATION_ERROR(-20011, '중단 — PACKAGE PKG_DMF0014 변경 ' || k || ' 기준 문구 ' || v_cnt || '건(1 기대) · 클라우드 원문이 기준본과 다름 → 전체 메뉴 패키지 사용. 원문 무변경');
        END IF;
        v_pos := DBMS_LOB.INSTR(v_new, v_o);
        v_new := SUBSTR(v_new, 1, v_pos - 1) || v_n || SUBSTR(v_new, v_pos + DBMS_LOB.GETLENGTH(v_o));
    END;
BEGIN
    DBMS_LOB.CREATETEMPORARY(v_raw, TRUE);
    FOR r IN (SELECT TEXT FROM USER_SOURCE WHERE NAME = 'PKG_DMF0014' AND TYPE = 'PACKAGE' ORDER BY LINE) LOOP
        DBMS_LOB.WRITEAPPEND(v_raw, LENGTH(r.TEXT), r.TEXT);
    END LOOP;
    IF NVL(DBMS_LOB.GETLENGTH(v_raw), 0) = 0 THEN
        RAISE_APPLICATION_ERROR(-20010, '중단 — 클라우드에 PACKAGE PKG_DMF0014 없음 → 전체 메뉴 패키지 사용. 원문 무변경');
    END IF;
    v_src := REPLACE(v_raw, CHR(13) || CHR(10), CHR(10));   -- CRLF 정규화(패치 문구는 LF 기준)
    IF hv(v_src) = 2096727990 AND DBMS_LOB.GETLENGTH(v_src) = 3992 THEN
        DBMS_OUTPUT.PUT_LINE('> SKIP  PACKAGE PKG_DMF0014 — 이미 사내와 같음 · 원문 무변경');
        RETURN;
    END IF;
    v_new := v_src;

    -- 변경 1: 기준본 L1~4 → 사내 L1~4 (삭제 1줄 · 추가 1줄)
    v_o := NULL;
    v_o := v_o || q'~PACKAGE SCM_MGR."PKG_DMF0014" IS
    /*
    * Program ID   : PKG_DMF0014
    * Description  : PKG_DMF0014
~';
    v_n := NULL;
    v_n := v_n || q'~PACKAGE         "PKG_DMF0014" IS
    /*
    * Program ID   : PKG_DMF0014
    * Description  : PKG_DMF0014
~';
    hunk(1);
    -- 변경 2: 기준본 L103~106 → 사내 L103~119 (삭제 0줄 · 추가 13줄)
    v_o := NULL;
    v_o := v_o || q'~       ,O_RESULT_CURSOR  OUT SYS_REFCURSOR
    );

END PKG_DMF0014;~';
    v_n := NULL;
    v_n := v_n || q'~       ,O_RESULT_CURSOR  OUT SYS_REFCURSOR
    );

    -- [2026-09-15 UIPKG] standalone PR_DM_CUST_ITEM_MAPPING
    PROCEDURE P_PR_DM_CUST_ITEM_MAPPING (P_ACCEPT_FLAG VARCHAR2 /* 업무구분(EDI, RPA) */

                                                    );

    -- [2026-09-15 UIPKG] standalone PR_DM_PLN_CUST_FCST_TO_MKT_FCST
    PROCEDURE P_PR_DM_PLN_CUST_FCST_TO_MKT_FCST;

    -- [2026-09-15 UIPKG] standalone PR_DM_PLN_CUST_FCST_TO_MKT_FCST_40
    PROCEDURE P_PR_DM_PLN_CUST_FCST_TO_MKT_FCST_40 (P_DIVISION_ID IN VARCHAR2
    /* p_active_flag            VARCHAR2    -- 필요없음 */
    );

END PKG_DMF0014;~';
    hunk(2);
    IF hv(v_new) <> 2096727990 OR DBMS_LOB.GETLENGTH(v_new) <> 3992 THEN
        RAISE_APPLICATION_ERROR(-20012, '중단 — PACKAGE PKG_DMF0014 조립 결과가 사내 원문과 다름 → 전체 메뉴 패키지 사용. 원문 무변경');
    END IF;
    IF c_dry THEN
        DBMS_OUTPUT.PUT_LINE('> DRY   PACKAGE PKG_DMF0014 — 패치 2개 구간 적용 가능(조립 결과 = 사내 원문)');
        RETURN;
    END IF;
    BEGIN
        EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_new;
    EXCEPTION WHEN OTHERS THEN
        NULL;   -- 컴파일 오류 동반 생성(ORA-24344)도 예외로 온다 → 아래 STATUS 검사에서 판정·원문 복원
    END;
    SELECT STATUS INTO v_st FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_DMF0014' AND OBJECT_TYPE = 'PACKAGE';
    SELECT COUNT(*) INTO v_err FROM USER_ERRORS WHERE NAME = 'PKG_DMF0014' AND TYPE = 'PACKAGE';
    IF v_st <> 'VALID' OR v_err > 0 THEN
        FOR e IN (SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME = 'PKG_DMF0014' AND TYPE = 'PACKAGE' ORDER BY SEQUENCE FETCH FIRST 10 ROWS ONLY) LOOP
            DBMS_OUTPUT.PUT_LINE('  ERR L' || e.LINE || ':' || e.POSITION || ' ' || e.TEXT);
        END LOOP;
        EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_raw;   -- 원문 자동 복원
        RAISE_APPLICATION_ERROR(-20013, 'PACKAGE PKG_DMF0014 컴파일 실패(' || v_st || ', 오류 ' || v_err || ') → 원문 복원함');
    END IF;
    DBMS_OUTPUT.PUT_LINE('> APPLY PACKAGE PKG_DMF0014 — 패치 2개 구간 적용 · ' || v_st || ' · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/

/* PACKAGE BODY PKG_DMF0014 — 수정분만 패치 · 기준본 = 사내 적용 백업 _artifacts\_apply_corporate\DMF0048_DMF0014_LONGPERIOD_20261122\00_BACKUP_PKG_DMF0014_BODY.ASIS.sql
 * 변경 1개 구간: 기준본 L6646~6652 → 사내 L6646~6656 (삭제 1줄 · 추가 5줄)
 * 가드: 이미 사내와 같으면 SKIP · 구간 기준 문구가 1건이 아니면 중단(원문 무변경) · 조립 결과 ≠ 사내 원문이면 중단 · 컴파일 오류면 원문 자동 복원 */
DECLARE
    c_dry   CONSTANT BOOLEAN := FALSE;
    v_raw   CLOB;
    v_src   CLOB;
    v_new   CLOB;
    v_o     CLOB;
    v_n     CLOB;
    v_cnt   PLS_INTEGER;
    v_pos   PLS_INTEGER;
    v_st    VARCHAR2(30);
    v_err   PLS_INTEGER;
    FUNCTION hv(c CLOB) RETURN NUMBER IS
        n NUMBER := 0; p INTEGER := 1; i INTEGER := 0; l INTEGER := NVL(DBMS_LOB.GETLENGTH(c), 0);
    BEGIN
        WHILE p <= l LOOP
            i := i + 1;
            n := n + DBMS_UTILITY.GET_HASH_VALUE(i || '~' || DBMS_LOB.SUBSTR(c, 1000, p), 1, 1073741824);
            p := p + 1000;
        END LOOP;
        RETURN n;
    END;
    FUNCTION cnt(c CLOB, t CLOB) RETURN PLS_INTEGER IS
        n PLS_INTEGER := 0; p PLS_INTEGER := 1;
    BEGIN
        LOOP
            p := DBMS_LOB.INSTR(c, t, p);
            EXIT WHEN NVL(p, 0) = 0;
            n := n + 1; p := p + DBMS_LOB.GETLENGTH(t);
        END LOOP;
        RETURN n;
    END;
    PROCEDURE hunk(k PLS_INTEGER) IS
    BEGIN
        v_cnt := cnt(v_new, v_o);
        IF v_cnt <> 1 THEN
            RAISE_APPLICATION_ERROR(-20011, '중단 — PACKAGE BODY PKG_DMF0014 변경 ' || k || ' 기준 문구 ' || v_cnt || '건(1 기대) · 클라우드 원문이 기준본과 다름 → 전체 메뉴 패키지 사용. 원문 무변경');
        END IF;
        v_pos := DBMS_LOB.INSTR(v_new, v_o);
        v_new := SUBSTR(v_new, 1, v_pos - 1) || v_n || SUBSTR(v_new, v_pos + DBMS_LOB.GETLENGTH(v_o));
    END;
BEGIN
    DBMS_LOB.CREATETEMPORARY(v_raw, TRUE);
    FOR r IN (SELECT TEXT FROM USER_SOURCE WHERE NAME = 'PKG_DMF0014' AND TYPE = 'PACKAGE BODY' ORDER BY LINE) LOOP
        DBMS_LOB.WRITEAPPEND(v_raw, LENGTH(r.TEXT), r.TEXT);
    END LOOP;
    IF NVL(DBMS_LOB.GETLENGTH(v_raw), 0) = 0 THEN
        RAISE_APPLICATION_ERROR(-20010, '중단 — 클라우드에 PACKAGE BODY PKG_DMF0014 없음 → 전체 메뉴 패키지 사용. 원문 무변경');
    END IF;
    v_src := REPLACE(v_raw, CHR(13) || CHR(10), CHR(10));   -- CRLF 정규화(패치 문구는 LF 기준)
    IF hv(v_src) = 412171740630 AND DBMS_LOB.GETLENGTH(v_src) = 768415 THEN
        DBMS_OUTPUT.PUT_LINE('> SKIP  PACKAGE BODY PKG_DMF0014 — 이미 사내와 같음 · 원문 무변경');
        RETURN;
    END IF;
    v_new := v_src;

    -- 변경 1: 기준본 L6646~6652 → 사내 L6646~6656 (삭제 1줄 · 추가 5줄)
    v_o := NULL;
    v_o := v_o || q'~               , CP.CUSTOMER_MODEL
       ';

        V_SQL_TEXT := REPLACE(V_SQL_TEXT, 'v_iteration', V_ITERATION);
        V_SQL_TEXT := REPLACE(V_SQL_TEXT, 'p_division_id', FN_SCM_GET_WHERE_SQL('CP.DIVISION_ID', 'IN', P_DIVISION_ID));
        --[PJ2024-50461] Team Mapping------------------------------------
        --V_SQL_TEXT := REPLACE(V_SQL_TEXT, 'p_dept_id', FN_SCM_GET_WHERE_SQL('TEAM.DEPT_ID', 'IN', P_DEPT_ID));
~';
    v_n := NULL;
    v_n := v_n || q'~               , CP.CUSTOMER_MODEL
       ';

-- 2026.11.22 [E20261122-LONGPERIOD] REPLACE 바꿀 문자열 32K 한도(Daily 2년 ORA-22828) — 기간 칸 목록을 자리표시 위치에 잘라 붙임 (START)
        -- V_SQL_TEXT := REPLACE(V_SQL_TEXT, 'v_iteration', V_ITERATION);
        V_SQL_TEXT := SUBSTR(V_SQL_TEXT, 1, INSTR(V_SQL_TEXT, 'v_iteration') - 1) || V_ITERATION
                   || SUBSTR(V_SQL_TEXT, INSTR(V_SQL_TEXT, 'v_iteration') + LENGTH('v_iteration'));
-- 2026.11.22 [E20261122-LONGPERIOD] (END)
        V_SQL_TEXT := REPLACE(V_SQL_TEXT, 'p_division_id', FN_SCM_GET_WHERE_SQL('CP.DIVISION_ID', 'IN', P_DIVISION_ID));
        --[PJ2024-50461] Team Mapping------------------------------------
        --V_SQL_TEXT := REPLACE(V_SQL_TEXT, 'p_dept_id', FN_SCM_GET_WHERE_SQL('TEAM.DEPT_ID', 'IN', P_DEPT_ID));
~';
    hunk(1);
    IF hv(v_new) <> 412171740630 OR DBMS_LOB.GETLENGTH(v_new) <> 768415 THEN
        RAISE_APPLICATION_ERROR(-20012, '중단 — PACKAGE BODY PKG_DMF0014 조립 결과가 사내 원문과 다름 → 전체 메뉴 패키지 사용. 원문 무변경');
    END IF;
    IF c_dry THEN
        DBMS_OUTPUT.PUT_LINE('> DRY   PACKAGE BODY PKG_DMF0014 — 패치 1개 구간 적용 가능(조립 결과 = 사내 원문)');
        RETURN;
    END IF;
    BEGIN
        EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_new;
    EXCEPTION WHEN OTHERS THEN
        NULL;   -- 컴파일 오류 동반 생성(ORA-24344)도 예외로 온다 → 아래 STATUS 검사에서 판정·원문 복원
    END;
    SELECT STATUS INTO v_st FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_DMF0014' AND OBJECT_TYPE = 'PACKAGE BODY';
    SELECT COUNT(*) INTO v_err FROM USER_ERRORS WHERE NAME = 'PKG_DMF0014' AND TYPE = 'PACKAGE BODY';
    IF v_st <> 'VALID' OR v_err > 0 THEN
        FOR e IN (SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME = 'PKG_DMF0014' AND TYPE = 'PACKAGE BODY' ORDER BY SEQUENCE FETCH FIRST 10 ROWS ONLY) LOOP
            DBMS_OUTPUT.PUT_LINE('  ERR L' || e.LINE || ':' || e.POSITION || ' ' || e.TEXT);
        END LOOP;
        EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_raw;   -- 원문 자동 복원
        RAISE_APPLICATION_ERROR(-20013, 'PACKAGE BODY PKG_DMF0014 컴파일 실패(' || v_st || ', 오류 ' || v_err || ') → 원문 복원함');
    END IF;
    DBMS_OUTPUT.PUT_LINE('> APPLY PACKAGE BODY PKG_DMF0014 — 패치 1개 구간 적용 · ' || v_st || ' · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/

/* 확인 — VALID, 오류 0 */
SELECT OBJECT_NAME, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME, 'YYYY-MM-DD HH24:MI:SS') AS LAST_DDL
  FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_DMF0014' ORDER BY OBJECT_TYPE;
SELECT TYPE, LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME = 'PKG_DMF0014' ORDER BY TYPE, SEQUENCE;
