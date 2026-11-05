-- 속도 측정 [BEFORE] — 적용 전 P_DMF0082_GET_MAIN_DATA (전체 F5 · 값 입력 없음 · 원장 변경 없음)
-- 사업부 40 · 81 · 82 를 각 3회 호출해 프로시저 실행 시간 · 커서 fetch 시간 · 행 수 · 결과 해시를 ZB_DMF0082_HINT_SPEED 에 기록한다(같은 세션 반복).
-- 조건 = 화면 기본값: 기간 당월 1일 ~ +6개월-1일 · 필터 전부 빈값 · Current · qtyYn N · 사용자 = 아래 규칙.
-- 사용자: c_user 가 NULL 이면 BEFORE 때 DMF0082 FcstNPrice 개인 컬럼 설정 행이 가장 많은 사용자를 고르고, AFTER 는 같은 사용자 · 같은 기간을 그대로 쓴다.
--         특정 사용자로 재려면 c_user 값을 바꾼다 (10 · 30 같은 값).
-- 같은 라벨을 다시 돌리면 그 라벨 기록을 지우고 새로 기록한다. 0행이면 ZERO_ROWS 로 표시 — 그 사업부 비교는 무의미.
-- 이 측정은 DB 안 시간이다. BE 왕복 · JSON 변환은 포함되지 않으므로 화면 체감은 따로 확인한다.
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    n PLS_INTEGER;
BEGIN
    SELECT COUNT(*) INTO n FROM USER_TABLES WHERE TABLE_NAME = 'ZB_DMF0082_HINT_SPEED';
    IF n = 0 THEN
        EXECUTE IMMEDIATE 'CREATE TABLE ZB_DMF0082_HINT_SPEED (LABEL VARCHAR2(20), DIV VARCHAR2(10), RUN_NO NUMBER, USER_ID VARCHAR2(100), FROM_YMD VARCHAR2(8), TO_YMD VARCHAR2(8), PROC_SEC NUMBER, FETCH_SEC NUMBER, TOTAL_SEC NUMBER, ROW_CNT NUMBER, COL_CNT NUMBER, RES_HASH NUMBER, ERR VARCHAR2(1000), BODY_DDL VARCHAR2(20), RUN_AT DATE)';
        DBMS_OUTPUT.PUT_LINE('기록표 생성 ZB_DMF0082_HINT_SPEED');
    END IF;
END;
/
DECLARE
    c_label CONSTANT VARCHAR2(20) := 'BEFORE';
    c_runs  CONSTANT PLS_INTEGER := 3;
    c_user  CONSTANT VARCHAR2(100) := NULL;
    TYPE t_div IS TABLE OF VARCHAR2(10);
    v_divs  t_div := t_div('40', '81', '82');
    v_mark  PLS_INTEGER;
    v_user  VARCHAR2(100);
    v_from  VARCHAR2(8);
    v_to    VARCHAR2(8);
    v_ddl   VARCHAR2(20);
    v_cnt   PLS_INTEGER;

    PROCEDURE one_run(p_div VARCHAR2, p_run PLS_INTEGER) IS
        rc1 SYS_REFCURSOR; rc2 SYS_REFCURSOR; rc3 SYS_REFCURSOR; rc4 SYS_REFCURSOR; rc5 SYS_REFCURSOR; rc6 SYS_REFCURSOR;
        t0 PLS_INTEGER; t1 PLS_INTEGER; t2 PLS_INTEGER;
        c  INTEGER; ncol INTEGER; dsc DBMS_SQL.DESC_TAB2;
        val VARCHAR2(4000); rw VARCHAR2(32767);
        h  NUMBER := 0; r_h NUMBER; rows_n PLS_INTEGER := 0; v_err VARCHAR2(1000);
    BEGIN
        t0 := DBMS_UTILITY.GET_TIME;
        PKG_DMF0082.P_DMF0082_GET_MAIN_DATA(p_div, NULL, NULL, NULL, v_from, v_to, NULL, NULL, 'Current', 'N', v_user, v_user, NULL, NULL, NULL, NULL, rc1, rc2, rc3, rc4, rc5, rc6);
        t1 := DBMS_UTILITY.GET_TIME;
        c := DBMS_SQL.TO_CURSOR_NUMBER(rc1);
        DBMS_SQL.DESCRIBE_COLUMNS2(c, ncol, dsc);
        FOR i IN 1 .. ncol LOOP DBMS_SQL.DEFINE_COLUMN(c, i, val, 4000); END LOOP;
        WHILE DBMS_SQL.FETCH_ROWS(c) > 0 LOOP
            rows_n := rows_n + 1; rw := NULL; r_h := 0;
            FOR i IN 1 .. ncol LOOP
                DBMS_SQL.COLUMN_VALUE(c, i, val);
                IF NVL(LENGTHB(rw), 0) + NVL(LENGTHB(val), 0) > 30000 THEN
                    r_h := MOD(r_h * 31 + DBMS_UTILITY.GET_HASH_VALUE(rw, 1, 1073741824), 1000000007); rw := NULL;
                END IF;
                rw := rw || '|' || val;
            END LOOP;
            r_h := MOD(r_h * 31 + DBMS_UTILITY.GET_HASH_VALUE(rw, 1, 1073741824), 1000000007);
            h := MOD(h + r_h, 281474976710656);   -- 행 순서 무관 합
        END LOOP;
        t2 := DBMS_UTILITY.GET_TIME;
        DBMS_SQL.CLOSE_CURSOR(c);
        IF rc2%ISOPEN THEN CLOSE rc2; END IF; IF rc3%ISOPEN THEN CLOSE rc3; END IF; IF rc4%ISOPEN THEN CLOSE rc4; END IF;
        IF rc5%ISOPEN THEN CLOSE rc5; END IF; IF rc6%ISOPEN THEN CLOSE rc6; END IF;
        INSERT INTO ZB_DMF0082_HINT_SPEED (LABEL, DIV, RUN_NO, USER_ID, FROM_YMD, TO_YMD, PROC_SEC, FETCH_SEC, TOTAL_SEC, ROW_CNT, COL_CNT, RES_HASH, ERR, BODY_DDL, RUN_AT)
        VALUES (c_label, p_div, p_run, v_user, v_from, v_to, (t1 - t0) / 100, (t2 - t1) / 100, (t2 - t0) / 100, rows_n, ncol, h, CASE WHEN rows_n = 0 THEN 'ZERO_ROWS' END, v_ddl, SYSDATE);
        COMMIT;
        DBMS_OUTPUT.PUT_LINE(c_label || ' div' || p_div || ' #' || p_run || ' proc ' || (t1 - t0) / 100 || 's fetch ' || (t2 - t1) / 100 || 's rows=' || rows_n || ' cols=' || ncol);
    EXCEPTION WHEN OTHERS THEN
        v_err := SUBSTR(SQLERRM, 1, 1000);
        ROLLBACK;
        INSERT INTO ZB_DMF0082_HINT_SPEED (LABEL, DIV, RUN_NO, USER_ID, FROM_YMD, TO_YMD, ERR, BODY_DDL, RUN_AT) VALUES (c_label, p_div, p_run, v_user, v_from, v_to, v_err, v_ddl, SYSDATE);
        COMMIT;
        DBMS_OUTPUT.PUT_LINE(c_label || ' div' || p_div || ' #' || p_run || ' ERROR ' || v_err);
    END;
BEGIN
    SELECT COUNT(*) INTO v_mark FROM USER_SOURCE WHERE NAME = 'PKG_DMF0082' AND TYPE = 'PACKAGE BODY' AND TEXT LIKE '%E20261102-DMF0082HINT%';
    IF v_mark > 0 THEN
        RAISE_APPLICATION_ERROR(-20010, '중단 — 이미 패치 적용 상태 — 적용 전 측정 불가. 40_COMPARE 는 비교 불가 (마커 ' || v_mark || '곳)');
    END IF;
    SELECT TO_CHAR(LAST_DDL_TIME, 'YYYY-MM-DD HH24:MI:SS') INTO v_ddl FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_DMF0082' AND OBJECT_TYPE = 'PACKAGE BODY';
    SELECT COUNT(*) INTO v_cnt FROM ZB_DMF0082_HINT_SPEED WHERE LABEL = 'BEFORE' AND USER_ID IS NOT NULL;
    IF c_label <> 'BEFORE' AND v_cnt > 0 THEN   -- 비교 조건 고정: BEFORE 와 같은 사용자 · 기간
        SELECT MAX(USER_ID), MAX(FROM_YMD), MAX(TO_YMD) INTO v_user, v_from, v_to FROM ZB_DMF0082_HINT_SPEED WHERE LABEL = 'BEFORE';
    ELSE
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
    END IF;
    DELETE FROM ZB_DMF0082_HINT_SPEED WHERE LABEL = c_label;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE(c_label || ' 시작 ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') || ' · user=' || v_user || ' · ' || v_from || '~' || v_to || ' · BODY LAST_DDL ' || v_ddl);
    FOR d IN 1 .. v_divs.COUNT LOOP
        FOR r IN 1 .. c_runs LOOP
            one_run(v_divs(d), r);
        END LOOP;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(c_label || ' 끝 ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
SELECT LABEL, DIV, RUN_NO, PROC_SEC, FETCH_SEC, TOTAL_SEC, ROW_CNT, COL_CNT, RES_HASH, ERR FROM ZB_DMF0082_HINT_SPEED WHERE LABEL = 'BEFORE' ORDER BY DIV, RUN_NO;
