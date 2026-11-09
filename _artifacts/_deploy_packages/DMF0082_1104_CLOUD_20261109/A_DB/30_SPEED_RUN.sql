/* =====================================================================================================
 * DMF0082_1104 클라우드 이관 · 30_SPEED_RUN — 속도·결과 측정 — 원본 PKG_DMF0082 ↔ PKG_DMF0082_1104 번갈아 호출
 * 마커 [E20261104-DMF0082ONEQUERY] · 생성 2026-11-09 13:09:09 (사내 ZIOUI1) · 실행 계정 = SCM_MGR · 파일 전체 F5 · 값 입력 없음
 * 대상 = 새 객체 PKG_DMF0082_1104 만. 원본 PKG_DMF0082 는 변경하지 않는다.
 * ===================================================================================================== */
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED

-- 사업부 40 · 81 · 82 마다 c_runs 회 반복. 회차마다 두 패키지를 번갈아 부른다(홀수 회차 = 원본 먼저 · 짝수 회차 = 1104 먼저).
-- 기록 = 프로시저 실행 시간 · 6개 커서 fetch 시간 · 커서별 행 수 · 커서별 결과 해시(행 순서 무관 · 전 열 값) → ZB_DMF0082_1104_SPEED
--   커서3 TODAY_TIME(= SYSDATE 시분)은 호출 시각이라 해시에서 뺀다(두 패키지 같은 식 · 사내 확인).
-- 조건 = 화면 기본값과 같은 값: 기간 당월 1일 ~ +6개월-1일 · 미선택 조회조건 'ALL' · 품목 NULL · 'Current' · qtyYn 'N'
--   사용자 = c_user 가 NULL 이면 DMF0082 FcstNPrice 개인 컬럼 설정 행이 가장 많은 사용자 · 사용자 그룹 = c_group
-- 원장 변경 없음(호출마다 ROLLBACK · 기록표만 COMMIT). 다시 돌리면 기록을 지우고 새로 남긴다.
-- DB 안 시간이다(BE 왕복·JSON 변환 제외). 원본 사업부 40 은 사내에서 1회 63~84초였다(11-06·11-09 실측).
DECLARE
    n PLS_INTEGER;
BEGIN
    SELECT COUNT(*) INTO n FROM USER_TABLES WHERE TABLE_NAME = 'ZB_DMF0082_1104_SPEED';
    IF n = 0 THEN
        EXECUTE IMMEDIATE 'CREATE TABLE ZB_DMF0082_1104_SPEED (PKG VARCHAR2(30), DIV VARCHAR2(10), RUN_NO NUMBER, SEQ_IN_RUN NUMBER, USER_ID VARCHAR2(100), USER_GROUP VARCHAR2(100), FROM_YMD VARCHAR2(8), TO_YMD VARCHAR2(8),'
            || ' PROC_SEC NUMBER, FETCH_SEC NUMBER, TOTAL_SEC NUMBER, R1 NUMBER, R2 NUMBER, R3 NUMBER, R4 NUMBER, R5 NUMBER, R6 NUMBER, C1 NUMBER,'
            || ' H1 NUMBER, H2 NUMBER, H3 NUMBER, H4 NUMBER, H5 NUMBER, H6 NUMBER, ERR VARCHAR2(1000), BODY_DDL VARCHAR2(20), RUN_AT DATE)';
        DBMS_OUTPUT.PUT_LINE('기록표 생성 ZB_DMF0082_1104_SPEED');
    END IF;
END;
/
DECLARE
    c_runs  CONSTANT PLS_INTEGER := 3;
    c_user  CONSTANT VARCHAR2(100) := NULL;
    c_group CONSTANT VARCHAR2(100) := 'ADMIN';
    TYPE t_div IS TABLE OF VARCHAR2(10);
    v_divs  t_div := t_div('40', '81', '82');
    v_user  VARCHAR2(100);
    v_from  VARCHAR2(8);
    v_to    VARCHAR2(8);

    PROCEDURE cur_hash(p_rc IN OUT SYS_REFCURSOR, p_skip VARCHAR2, o_rows OUT NUMBER, o_cols OUT NUMBER, o_hash OUT NUMBER) IS
        c    INTEGER;
        ncol INTEGER;
        dsc  DBMS_SQL.DESC_TAB2;
        val  VARCHAR2(4000);
        cv   CLOB;
        rw   VARCHAR2(32767);
        r_h  NUMBER;
        h    NUMBER := 0;
        k    NUMBER := 0;
    BEGIN
        c := DBMS_SQL.TO_CURSOR_NUMBER(p_rc);
        DBMS_SQL.DESCRIBE_COLUMNS2(c, ncol, dsc);
        FOR i IN 1 .. ncol LOOP
            IF dsc(i).col_type = 112 THEN DBMS_SQL.DEFINE_COLUMN(c, i, cv); ELSE DBMS_SQL.DEFINE_COLUMN(c, i, val, 4000); END IF;
        END LOOP;
        WHILE DBMS_SQL.FETCH_ROWS(c) > 0 LOOP
            k := k + 1; rw := NULL; r_h := 0;
            FOR i IN 1 .. ncol LOOP
                IF dsc(i).col_name = p_skip THEN
                    val := '#';
                ELSIF dsc(i).col_type = 112 THEN
                    DBMS_SQL.COLUMN_VALUE(c, i, cv);
                    val := DBMS_LOB.SUBSTR(cv, 1000, 1) || '#' || DBMS_LOB.GETLENGTH(cv);
                ELSE
                    DBMS_SQL.COLUMN_VALUE(c, i, val);
                END IF;
                IF NVL(LENGTHB(rw), 0) + NVL(LENGTHB(val), 0) + 1 > 30000 THEN
                    r_h := MOD(r_h * 31 + DBMS_UTILITY.GET_HASH_VALUE(rw, 1, 1073741824), 1000000007); rw := NULL;
                END IF;
                rw := rw || '|' || val;
            END LOOP;
            r_h := MOD(r_h * 31 + DBMS_UTILITY.GET_HASH_VALUE(NVL(rw, '~'), 1, 1073741824), 1000000007);
            h := MOD(h + r_h, 281474976710656);
        END LOOP;
        DBMS_SQL.CLOSE_CURSOR(c);
        o_rows := k; o_cols := ncol; o_hash := h;
    END;

    PROCEDURE one_call(p_pkg VARCHAR2, p_div VARCHAR2, p_run PLS_INTEGER, p_seq PLS_INTEGER) IS
        rc1 SYS_REFCURSOR; rc2 SYS_REFCURSOR; rc3 SYS_REFCURSOR; rc4 SYS_REFCURSOR; rc5 SYS_REFCURSOR; rc6 SYS_REFCURSOR;
        t0 PLS_INTEGER; t1 PLS_INTEGER; t2 PLS_INTEGER;
        r1 NUMBER; r2 NUMBER; r3 NUMBER; r4 NUMBER; r5 NUMBER; r6 NUMBER;
        c1 NUMBER; cx NUMBER;
        h1 NUMBER; h2 NUMBER; h3 NUMBER; h4 NUMBER; h5 NUMBER; h6 NUMBER;
        v_err VARCHAR2(1000); v_ddl VARCHAR2(20);
    BEGIN
        SELECT TO_CHAR(LAST_DDL_TIME, 'YYYY-MM-DD HH24:MI:SS') INTO v_ddl FROM USER_OBJECTS WHERE OBJECT_NAME = p_pkg AND OBJECT_TYPE = 'PACKAGE BODY';
        t0 := DBMS_UTILITY.GET_TIME;
        IF p_pkg = 'PKG_DMF0082' THEN
            PKG_DMF0082.P_DMF0082_GET_MAIN_DATA(p_div, 'ALL', 'ALL', 'ALL', v_from, v_to, 'ALL', NULL, 'Current', 'N', v_user, c_group, 'ALL', 'ALL', 'ALL', 'ALL', rc1, rc2, rc3, rc4, rc5, rc6);
        ELSE
            PKG_DMF0082_1104.P_DMF0082_GET_MAIN_DATA(p_div, 'ALL', 'ALL', 'ALL', v_from, v_to, 'ALL', NULL, 'Current', 'N', v_user, c_group, 'ALL', 'ALL', 'ALL', 'ALL', rc1, rc2, rc3, rc4, rc5, rc6);
        END IF;
        t1 := DBMS_UTILITY.GET_TIME;
        cur_hash(rc1, '-', r1, c1, h1);
        cur_hash(rc2, '-', r2, cx, h2);
        cur_hash(rc3, 'TODAY_TIME', r3, cx, h3);
        cur_hash(rc4, '-', r4, cx, h4);
        cur_hash(rc5, '-', r5, cx, h5);
        cur_hash(rc6, '-', r6, cx, h6);
        t2 := DBMS_UTILITY.GET_TIME;
        ROLLBACK;
        INSERT INTO ZB_DMF0082_1104_SPEED (PKG, DIV, RUN_NO, SEQ_IN_RUN, USER_ID, USER_GROUP, FROM_YMD, TO_YMD, PROC_SEC, FETCH_SEC, TOTAL_SEC,
                                           R1, R2, R3, R4, R5, R6, C1, H1, H2, H3, H4, H5, H6, ERR, BODY_DDL, RUN_AT)
        VALUES (p_pkg, p_div, p_run, p_seq, v_user, c_group, v_from, v_to, (t1 - t0) / 100, (t2 - t1) / 100, (t2 - t0) / 100,
                r1, r2, r3, r4, r5, r6, c1, h1, h2, h3, h4, h5, h6, CASE WHEN r1 = 0 THEN 'ZERO_ROWS' END, v_ddl, SYSDATE);
        COMMIT;
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'HH24:MI:SS') || ' ' || RPAD(p_pkg, 17) || ' div' || p_div || ' #' || p_run || ' proc ' || (t1 - t0) / 100 || 's fetch ' || (t2 - t1) / 100 || 's rows=' || r1);
    EXCEPTION WHEN OTHERS THEN
        v_err := SUBSTR(SQLERRM, 1, 1000);
        ROLLBACK;
        INSERT INTO ZB_DMF0082_1104_SPEED (PKG, DIV, RUN_NO, SEQ_IN_RUN, USER_ID, USER_GROUP, FROM_YMD, TO_YMD, ERR, BODY_DDL, RUN_AT)
        VALUES (p_pkg, p_div, p_run, p_seq, v_user, c_group, v_from, v_to, v_err, v_ddl, SYSDATE);
        COMMIT;
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'HH24:MI:SS') || ' ' || RPAD(p_pkg, 17) || ' div' || p_div || ' #' || p_run || ' ERROR ' || v_err);
    END;
BEGIN
    v_from := TO_CHAR(TRUNC(SYSDATE, 'MM'), 'YYYYMMDD');
    v_to   := TO_CHAR(ADD_MONTHS(TRUNC(SYSDATE, 'MM'), 6) - 1, 'YYYYMMDD');
    v_user := c_user;
    IF v_user IS NULL THEN
        SELECT MAX(USER_ID) KEEP (DENSE_RANK FIRST ORDER BY CNT DESC, USER_ID) INTO v_user
          FROM (SELECT USER_ID, COUNT(*) CNT FROM SCM_MST_TITLESET_USER WHERE PROGRAM_ID = 'DMF0082' AND SHEET_NAME = 'FcstNPrice' GROUP BY USER_ID);
    END IF;
    IF v_user IS NULL THEN
        RAISE_APPLICATION_ERROR(-20011, '중단 — DMF0082 FcstNPrice 개인 컬럼 설정 사용자 없음. c_user 에 사용자 ID 를 넣고 다시 실행');
    END IF;
    EXECUTE IMMEDIATE 'DELETE FROM ZB_DMF0082_1104_SPEED';
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('시작 ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') || ' · user=' || v_user || ' · group=' || c_group || ' · ' || v_from || '~' || v_to || ' · 회차 ' || c_runs);
    FOR d IN 1 .. v_divs.COUNT LOOP
        FOR r IN 1 .. c_runs LOOP
            IF MOD(r, 2) = 1 THEN
                one_call('PKG_DMF0082', v_divs(d), r, 1); one_call('PKG_DMF0082_1104', v_divs(d), r, 2);
            ELSE
                one_call('PKG_DMF0082_1104', v_divs(d), r, 1); one_call('PKG_DMF0082', v_divs(d), r, 2);
            END IF;
        END LOOP;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('끝 ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') || ' — 40_SPEED_COMPARE 로 결과 확인');
END;
/
SELECT PKG, DIV, RUN_NO, SEQ_IN_RUN, PROC_SEC, FETCH_SEC, TOTAL_SEC, R1, C1, ERR FROM ZB_DMF0082_1104_SPEED ORDER BY DIV, RUN_NO, SEQ_IN_RUN;
