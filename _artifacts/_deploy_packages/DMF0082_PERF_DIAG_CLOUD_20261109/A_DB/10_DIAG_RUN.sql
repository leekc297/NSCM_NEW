/* =====================================================================================================
 * DMF0082 조회 속도 진단 · 10_DIAG_RUN — 사업부 40 · 81 · 82 를 1회씩 조회하며 이 세션의 시간 사용처를 기록
 * 마커 [E20261104-DMF0082ONEQUERY] · 2026-11-09 · 실행 계정 = SCM_MGR · 파일 전체 F5 · 값 입력 없음 · 원장 변경 없음
 *
 * 기록하는 것 (모두 '이 세션' 것만 — QA 공유 풀 전체를 훑지 않음):
 *   RUN  : 사업부별 프로시저 실행(PROC) · 6개 커서 전 행 읽기(FETCH) 시간 · 행 수
 *   ASH  : V$ACTIVE_SESSION_HISTORY 1초 샘플 — 문장(SQL_ID) × 실행계획 줄 × 대기 이벤트별 초
 *   MON  : V$SQL_MONITOR / V$SQL_PLAN_MONITOR — 5초 넘는 문장의 계획 줄별 실제 행 수 · 예상 행 수 · 반복 횟수 · TEMP
 *   EVT  : V$SESSION_EVENT 전후 차이 — 대기 이벤트별 시간
 *   SQL  : 위에서 찾은 SQL_ID 만 V$SQL 조회 — 문장 앞부분 · 계획 해시 · 패키지 줄 번호(단계 판정용)
 *   ENV  : 옵티마이저 관련 파라미터
 * 권한이 없는 뷰는 오류 대신 ZB_DMF0082_DIAG_NOTE 에 '권한 없음'으로 남긴다 → 20_DIAG_REPORT 의 D0 에서 확인.
 * 다시 돌리면 기록을 지우고 새로 남긴다. 끝나면 20_DIAG_REPORT 실행 → 결과 회신 → 98 로 정리.
 * ===================================================================================================== */
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
DECLARE
    n PLS_INTEGER;
    PROCEDURE mk(p_t VARCHAR2, p_ddl VARCHAR2) IS
    BEGIN
        SELECT COUNT(*) INTO n FROM USER_TABLES WHERE TABLE_NAME = p_t;
        IF n = 0 THEN EXECUTE IMMEDIATE p_ddl; END IF;
        EXECUTE IMMEDIATE 'DELETE FROM ' || p_t;
    END;
BEGIN
    mk('ZB_DMF0082_DIAG_RUN',  'CREATE TABLE ZB_DMF0082_DIAG_RUN (DIV VARCHAR2(10), PKG VARCHAR2(30), USER_ID VARCHAR2(100), USER_GROUP VARCHAR2(100), FROM_YMD VARCHAR2(8), TO_YMD VARCHAR2(8), T_START TIMESTAMP, T_END TIMESTAMP, PROC_SEC NUMBER, FETCH_SEC NUMBER, R1 NUMBER, C1 NUMBER, SID NUMBER, SERIAL# NUMBER, GMD_L1 NUMBER, BODY_OBJ_ID NUMBER, ERR VARCHAR2(1000))');
    mk('ZB_DMF0082_DIAG_ASH',  'CREATE TABLE ZB_DMF0082_DIAG_ASH (DIV VARCHAR2(10), SQL_ID VARCHAR2(13), PLAN_HASH NUMBER, PLAN_LINE NUMBER, OPERATION VARCHAR2(100), OPTIONS VARCHAR2(100), EVENT VARCHAR2(100), SAMPLES NUMBER, TEMP_MB NUMBER, PGA_MB NUMBER)');
    mk('ZB_DMF0082_DIAG_MON',  'CREATE TABLE ZB_DMF0082_DIAG_MON (DIV VARCHAR2(10), SQL_ID VARCHAR2(13), SQL_EXEC_ID NUMBER, PLAN_HASH NUMBER, ELAPSED_SEC NUMBER, CPU_SEC NUMBER, BUFFER_GETS NUMBER, DISK_READS NUMBER, FETCHES NUMBER, PX NUMBER)');
    mk('ZB_DMF0082_DIAG_PMON', 'CREATE TABLE ZB_DMF0082_DIAG_PMON (DIV VARCHAR2(10), SQL_ID VARCHAR2(13), SQL_EXEC_ID NUMBER, PLAN_LINE NUMBER, PARENT_LINE NUMBER, DEPTH NUMBER, OPERATION VARCHAR2(100), OPTIONS VARCHAR2(100), OBJECT_NAME VARCHAR2(128), EST_ROWS NUMBER, STARTS NUMBER, ACT_ROWS NUMBER, TEMP_MB NUMBER, READ_MB NUMBER)');
    mk('ZB_DMF0082_DIAG_EVT',  'CREATE TABLE ZB_DMF0082_DIAG_EVT (DIV VARCHAR2(10), PHASE VARCHAR2(1), EVENT VARCHAR2(100), WAIT_CLASS VARCHAR2(64), WAITS NUMBER, TIME_SEC NUMBER)');
    mk('ZB_DMF0082_DIAG_SQL',  'CREATE TABLE ZB_DMF0082_DIAG_SQL (SQL_ID VARCHAR2(13), CHILD NUMBER, PLAN_HASH NUMBER, PROGRAM_ID NUMBER, PROGRAM_LINE NUMBER, EXECUTIONS NUMBER, ELAPSED_SEC NUMBER, BUFFER_GETS NUMBER, ROWS_PROCESSED NUMBER, SQL_TEXT VARCHAR2(400))');
    mk('ZB_DMF0082_DIAG_ENV',  'CREATE TABLE ZB_DMF0082_DIAG_ENV (NAME VARCHAR2(100), VALUE VARCHAR2(400))');
    mk('ZB_DMF0082_DIAG_NOTE', 'CREATE TABLE ZB_DMF0082_DIAG_NOTE (DIV VARCHAR2(10), ITEM VARCHAR2(100), MSG VARCHAR2(1000))');
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('기록표 준비 ZB_DMF0082_DIAG_* 8개');
END;
/
DECLARE
    c_pkg   CONSTANT VARCHAR2(30)  := 'PKG_DMF0082';   -- 진단 대상 패키지
    c_user  CONSTANT VARCHAR2(100) := NULL;            -- NULL = DMF0082 FcstNPrice 개인 컬럼 설정 행이 가장 많은 사용자 (30_SPEED_RUN 과 같은 규칙)
    c_group CONSTANT VARCHAR2(100) := 'ADMIN';
    TYPE t_div IS TABLE OF VARCHAR2(10);
    v_divs  t_div := t_div('40', '81', '82');
    v_user  VARCHAR2(100);
    v_from  VARCHAR2(8);
    v_to    VARCHAR2(8);
    v_sid   NUMBER;
    v_ser   NUMBER;
    v_l1    NUMBER;
    v_obj   NUMBER;

    PROCEDURE note(p_div VARCHAR2, p_item VARCHAR2, p_msg VARCHAR2) IS
    BEGIN
        EXECUTE IMMEDIATE 'INSERT INTO ZB_DMF0082_DIAG_NOTE VALUES (:1, :2, :3)' USING p_div, p_item, SUBSTR(p_msg, 1, 1000);
    END;

    PROCEDURE cur_count(p_rc IN OUT SYS_REFCURSOR, o_rows OUT NUMBER, o_cols OUT NUMBER) IS
        c INTEGER; ncol INTEGER; dsc DBMS_SQL.DESC_TAB2; val VARCHAR2(4000); cv CLOB; k NUMBER := 0;
    BEGIN
        c := DBMS_SQL.TO_CURSOR_NUMBER(p_rc);
        DBMS_SQL.DESCRIBE_COLUMNS2(c, ncol, dsc);
        FOR i IN 1 .. ncol LOOP
            IF dsc(i).col_type = 112 THEN DBMS_SQL.DEFINE_COLUMN(c, i, cv); ELSE DBMS_SQL.DEFINE_COLUMN(c, i, val, 4000); END IF;
        END LOOP;
        WHILE DBMS_SQL.FETCH_ROWS(c) > 0 LOOP
            k := k + 1;
            FOR i IN 1 .. ncol LOOP
                IF dsc(i).col_type = 112 THEN DBMS_SQL.COLUMN_VALUE(c, i, cv); ELSE DBMS_SQL.COLUMN_VALUE(c, i, val); END IF;
            END LOOP;
        END LOOP;
        DBMS_SQL.CLOSE_CURSOR(c);
        o_rows := k; o_cols := ncol;
    END;

    PROCEDURE evt(p_div VARCHAR2, p_phase VARCHAR2) IS
    BEGIN
        EXECUTE IMMEDIATE 'INSERT INTO ZB_DMF0082_DIAG_EVT SELECT :1, :2, EVENT, WAIT_CLASS, TOTAL_WAITS, TIME_WAITED_MICRO / 1e6 FROM V$SESSION_EVENT WHERE SID = :3'
            USING p_div, p_phase, v_sid;
    EXCEPTION WHEN OTHERS THEN note(p_div, 'V$SESSION_EVENT', SQLERRM);
    END;

    PROCEDURE one(p_div VARCHAR2) IS
        rc1 SYS_REFCURSOR; rc2 SYS_REFCURSOR; rc3 SYS_REFCURSOR; rc4 SYS_REFCURSOR; rc5 SYS_REFCURSOR; rc6 SYS_REFCURSOR;
        ts0 TIMESTAMP; ts1 TIMESTAMP;
        t0 PLS_INTEGER; t1 PLS_INTEGER; t2 PLS_INTEGER;
        r1 NUMBER; c1 NUMBER; rx NUMBER; cx NUMBER;
        v_err VARCHAR2(1000);
    BEGIN
        evt(p_div, 'B');
        ts0 := SYSTIMESTAMP;
        t0 := DBMS_UTILITY.GET_TIME;
        BEGIN
            EXECUTE IMMEDIATE 'BEGIN ' || c_pkg || '.P_DMF0082_GET_MAIN_DATA(:1, ''ALL'', ''ALL'', ''ALL'', :2, :3, ''ALL'', NULL, ''Current'', ''N'', :4, :5, ''ALL'', ''ALL'', ''ALL'', ''ALL'', :6, :7, :8, :9, :10, :11); END;'
                USING IN p_div, IN v_from, IN v_to, IN v_user, IN c_group, OUT rc1, OUT rc2, OUT rc3, OUT rc4, OUT rc5, OUT rc6;
            t1 := DBMS_UTILITY.GET_TIME;
            cur_count(rc1, r1, c1); cur_count(rc2, rx, cx); cur_count(rc3, rx, cx);
            cur_count(rc4, rx, cx); cur_count(rc5, rx, cx); cur_count(rc6, rx, cx);
            t2 := DBMS_UTILITY.GET_TIME;
        EXCEPTION WHEN OTHERS THEN v_err := SUBSTR(SQLERRM, 1, 1000); t1 := NVL(t1, DBMS_UTILITY.GET_TIME); t2 := DBMS_UTILITY.GET_TIME;
        END;
        ts1 := SYSTIMESTAMP;
        ROLLBACK;
        evt(p_div, 'A');
        EXECUTE IMMEDIATE 'INSERT INTO ZB_DMF0082_DIAG_RUN VALUES (:1, :2, :3, :4, :5, :6, :7, :8, :9, :10, :11, :12, :13, :14, :15, :16, :17)'
            USING p_div, c_pkg, v_user, c_group, v_from, v_to, ts0, ts1, (t1 - t0) / 100, (t2 - t1) / 100, r1, c1, v_sid, v_ser, v_l1, v_obj, v_err;
        -- ASH (이 세션 · 이 조회 시간대)
        BEGIN
            EXECUTE IMMEDIATE q'[INSERT INTO ZB_DMF0082_DIAG_ASH
                SELECT :1, SQL_ID, SQL_PLAN_HASH_VALUE, SQL_PLAN_LINE_ID, SQL_PLAN_OPERATION, SQL_PLAN_OPTIONS,
                       CASE WHEN SESSION_STATE = 'ON CPU' THEN 'ON CPU' ELSE EVENT END, COUNT(*),
                       ROUND(MAX(TEMP_SPACE_ALLOCATED) / 1048576, 1), ROUND(MAX(PGA_ALLOCATED) / 1048576, 1)
                  FROM V$ACTIVE_SESSION_HISTORY
                 WHERE SESSION_ID = :2 AND (:3 IS NULL OR SESSION_SERIAL# = :4) AND SAMPLE_TIME BETWEEN :5 AND :6
                 GROUP BY SQL_ID, SQL_PLAN_HASH_VALUE, SQL_PLAN_LINE_ID, SQL_PLAN_OPERATION, SQL_PLAN_OPTIONS, CASE WHEN SESSION_STATE = 'ON CPU' THEN 'ON CPU' ELSE EVENT END]'
                USING p_div, v_sid, v_ser, v_ser, ts0, ts1;
        EXCEPTION WHEN OTHERS THEN note(p_div, 'V$ACTIVE_SESSION_HISTORY', SQLERRM);
        END;
        -- SQL Monitor (5초 넘는 문장)
        BEGIN
            EXECUTE IMMEDIATE q'[INSERT INTO ZB_DMF0082_DIAG_MON
                SELECT :1, SQL_ID, SQL_EXEC_ID, SQL_PLAN_HASH_VALUE, ROUND(ELAPSED_TIME / 1e6, 2), ROUND(CPU_TIME / 1e6, 2), BUFFER_GETS, DISK_READS, FETCHES, PX_SERVERS_ALLOCATED
                  FROM V$SQL_MONITOR WHERE SID = :2 AND (:3 IS NULL OR SESSION_SERIAL# = :4) AND SQL_EXEC_START >= CAST(:5 AS DATE) AND SQL_PLAN_HASH_VALUE > 0]'
                USING p_div, v_sid, v_ser, v_ser, ts0;
            EXECUTE IMMEDIATE q'[INSERT INTO ZB_DMF0082_DIAG_PMON
                SELECT :1, P.SQL_ID, P.SQL_EXEC_ID, P.PLAN_LINE_ID, P.PLAN_PARENT_ID, P.PLAN_DEPTH, P.PLAN_OPERATION, P.PLAN_OPTIONS, P.PLAN_OBJECT_NAME,
                       P.PLAN_CARDINALITY, P.STARTS, P.OUTPUT_ROWS, ROUND(P.WORKAREA_MAX_TEMPSEG / 1048576, 1), ROUND(P.PHYSICAL_READ_BYTES / 1048576, 1)
                  FROM V$SQL_PLAN_MONITOR P WHERE P.SID = :2 AND (:3 IS NULL OR P.SESSION_SERIAL# = :4) AND P.SQL_EXEC_START >= CAST(:5 AS DATE)]'
                USING p_div, v_sid, v_ser, v_ser, ts0;
        EXCEPTION WHEN OTHERS THEN note(p_div, 'V$SQL_MONITOR', SQLERRM);
        END;
        COMMIT;
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'HH24:MI:SS') || ' div' || p_div || ' proc ' || (t1 - t0) / 100 || 's fetch ' || (t2 - t1) / 100 || 's rows=' || r1
            || CASE WHEN v_err IS NOT NULL THEN ' ERROR ' || v_err END);
    END;
BEGIN
    v_from := TO_CHAR(TRUNC(SYSDATE, 'MM'), 'YYYYMMDD');
    v_to   := TO_CHAR(ADD_MONTHS(TRUNC(SYSDATE, 'MM'), 6) - 1, 'YYYYMMDD');
    v_user := c_user;
    IF v_user IS NULL THEN
        SELECT MAX(USER_ID) KEEP (DENSE_RANK FIRST ORDER BY CNT DESC, USER_ID) INTO v_user
          FROM (SELECT USER_ID, COUNT(*) CNT FROM SCM_MST_TITLESET_USER WHERE PROGRAM_ID = 'DMF0082' AND SHEET_NAME = 'FcstNPrice' GROUP BY USER_ID);
    END IF;
    v_sid := TO_NUMBER(SYS_CONTEXT('USERENV', 'SID'));
    BEGIN
        EXECUTE IMMEDIATE 'SELECT SERIAL# FROM V$SESSION WHERE SID = :1' INTO v_ser USING v_sid;
    EXCEPTION WHEN OTHERS THEN v_ser := NULL; note(NULL, 'V$SESSION', SQLERRM);
    END;
    SELECT MIN(LINE) INTO v_l1 FROM USER_SOURCE WHERE NAME = c_pkg AND TYPE = 'PACKAGE BODY' AND REGEXP_LIKE(TEXT, '^\s*PROCEDURE\s+P_DMF0082_GET_MAIN_DATA\s*(\(|$)');
    SELECT OBJECT_ID INTO v_obj FROM USER_OBJECTS WHERE OBJECT_NAME = c_pkg AND OBJECT_TYPE = 'PACKAGE BODY';
    -- 옵티마이저 환경
    BEGIN
        EXECUTE IMMEDIATE q'[INSERT INTO ZB_DMF0082_DIAG_ENV SELECT NAME, SUBSTR(VALUE, 1, 400) FROM V$PARAMETER
            WHERE NAME IN ('optimizer_dynamic_sampling','optimizer_adaptive_plans','optimizer_adaptive_statistics','optimizer_features_enable','optimizer_mode',
                           'optimizer_index_cost_adj','cursor_sharing','statistics_level','pga_aggregate_target','pga_aggregate_limit','workarea_size_policy',
                           'cpu_count','parallel_degree_policy','parallel_max_servers','temp_undo_enabled','sga_target','db_file_multiblock_read_count')]';
    EXCEPTION WHEN OTHERS THEN note(NULL, 'V$PARAMETER', SQLERRM);
    END;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('시작 ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') || ' · ' || c_pkg || ' · user=' || v_user || ' · ' || v_from || '~' || v_to || ' · SID ' || v_sid || ' · GET_MAIN_DATA 시작 줄 ' || v_l1);
    FOR d IN 1 .. v_divs.COUNT LOOP
        one(v_divs(d));
    END LOOP;
    -- 찾은 SQL_ID 만 V$SQL 조회 (공유 풀 전체 스캔 아님)
    FOR s IN (SELECT DISTINCT SQL_ID FROM (SELECT SQL_ID FROM ZB_DMF0082_DIAG_ASH UNION SELECT SQL_ID FROM ZB_DMF0082_DIAG_MON) WHERE SQL_ID IS NOT NULL) LOOP
        BEGIN
            EXECUTE IMMEDIATE q'[INSERT INTO ZB_DMF0082_DIAG_SQL
                SELECT SQL_ID, CHILD_NUMBER, PLAN_HASH_VALUE, PROGRAM_ID, PROGRAM_LINE#, EXECUTIONS, ROUND(ELAPSED_TIME / 1e6, 2), BUFFER_GETS, ROWS_PROCESSED,
                       SUBSTR(REGEXP_REPLACE(SQL_TEXT, '\s+', ' '), 1, 400)
                  FROM V$SQL WHERE SQL_ID = :1 AND ROWNUM <= 5]' USING s.SQL_ID;
        EXCEPTION WHEN OTHERS THEN note(NULL, 'V$SQL ' || s.SQL_ID, SQLERRM);
        END;
    END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('끝 ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') || ' — 20_DIAG_REPORT 실행');
END;
/
SELECT DIV, PROC_SEC, FETCH_SEC, R1, C1, ERR FROM ZB_DMF0082_DIAG_RUN ORDER BY DIV;
SELECT DIV, ITEM, MSG FROM ZB_DMF0082_DIAG_NOTE ORDER BY 1, 2;
