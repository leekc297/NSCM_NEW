-- =============================================================================
-- C03_SP_PROFILE.sql — DMF0005 조회 속도 점검 ③ 조회 프로시저 직접 실행 · 문장별 병목 귀속 (82 → 81 → 40, 각 3회)
--   계정: SCM_MGR · SQL Developer 스크립트 실행(F5) 또는 sqlplus @C03_SP_PROFILE.sql · 값 입력 없음
--   무엇을 하나: 화면 [Search] 와 같은 인자(조회조건 없음 · Active ALL)로
--       PKG_DMF0005.P_DMF0005_GET_SALES_SITE_MODEL_PRODUCTION 을 사업부별로 3회 실행하고
--     (A) 프로시저 시간 / 결과 커서 fetch 시간 · 행 수 · 컬럼 수
--         ※ 이 프로시저는 SELECT 한 문장을 커서로 열어 돌려준다 — 실제 일은 fetch 구간에서 일어난다
--     (B) 문장별 귀속 — V$SQL 전후 차이 (패키지 문장 + 안에서 부르는 함수의 내부 SQL + 동적 샘플링 재귀 SQL)
--     (C) 내 세션 ASH — SQL_ID × 대기 이벤트 × 계획 줄 (1초 표본)
--     (D) 세션 통계 차이 — 논리 / 물리 읽기 · 하드파싱 · 임시 영역 · CPU · 재귀 호출 수
--   회차: 1회차 = 하드파싱 포함 · 2회차 = 커서 재사용(화면 조건 — 이 수치로 판단) ·
--         3회차 = 행 단위 실측(statistics_level = ALL, C04 계획의 A-Rows 용 — 시간은 참고만)
--   변경: 영구 테이블 변경 없음 (조회조건 임시 테이블만 비움, 매 회 ROLLBACK)
--   ⚠ 측정 중 다른 사람이 DMF0005 를 조회하면 (B) 가 섞인다 — (C) 는 내 세션만이라 섞이지 않는다
--   ⚠ 느린 사업부가 있으면 이 스크립트도 그만큼 걸린다. 급하면 c_divs 를 하나로 좁혀 먼저 실행
--   ⚠ c_user 는 느리다고 한 사용자의 로그인 ID 로 바꾸면 그 사용자 권한 조건으로 재현된다
-- =============================================================================
SET SERVEROUTPUT ON SIZE UNLIMITED FORMAT WRAPPED
SET LINESIZE 400
SET TRIMSPOOL ON
SET FEEDBACK OFF
SPOOL C03_SP_PROFILE_OUT.txt

DECLARE
    -- ===== 설정 (필요 시 여기만 수정) =====================================================
    c_divs      CONSTANT VARCHAR2(100) := '82,81,40';     -- 측정 사업부 (쉼표)
    c_user      CONSTANT VARCHAR2(50)  := 'minyonglee1';  -- P_USER_ID (화면 로그인 ID)
    c_top       CONSTANT PLS_INTEGER   := 15;             -- 문장별 상위 N
    -- 화면 기본 조회조건 (SCM_COM_SYS_LOG 원문 기준): dept · cust · site = 'ALL', pjt · item · owner = 빈칸, active = 'ALL'
    -- ==========================================================================================

    TYPE t_snap IS RECORD (ex NUMBER, el NUMBER, cpu NUMBER, bg NUMBER, dr NUMBER, rp NUMBER,
                           phv NUMBER, line NUMBER, hp NUMBER, prog VARCHAR2(40), txt VARCHAR2(400 CHAR));
    TYPE t_map  IS TABLE OF t_snap INDEX BY VARCHAR2(40);
    TYPE t_dlt  IS RECORD (k VARCHAR2(40), s t_snap);
    TYPE t_dlts IS TABLE OF t_dlt INDEX BY PLS_INTEGER;
    TYPE t_num  IS TABLE OF NUMBER INDEX BY VARCHAR2(64);
    TYPE t_cb   IS RECORD (sec NUMBER, bg NUMBER, phv NUMBER);
    TYPE t_cbm  IS TABLE OF t_cb INDEX BY VARCHAR2(40);
    TYPE t_ca   IS TABLE OF VARCHAR2(100) INDEX BY VARCHAR2(10);
    cb          t_cbm;        -- 사내 기준 (사업부:SQL_ID → 1회 초 · BG · PHV)
    ca          t_ca;         -- 사내 기준 (사업부 → 프로시저 · fetch 초)

    v_body_id   NUMBER;
    v_sid       NUMBER := SYS_CONTEXT('USERENV','SID');
    b_sql       t_map;  a_sql t_map;
    b_st        t_num;  a_st  t_num;
    d           t_dlts;
    v_div       VARCHAR2(10);
    v_rest      VARCHAR2(100);
    rc1 SYS_REFCURSOR; rcr SYS_REFCURSOR;
    t0 NUMBER; t1 NUMBER; t2 NUMBER;
    v_ts        TIMESTAMP;
    v_rows      NUMBER; v_cols NUMBER; v_dummy NUMBER;
    v_sum_el    NUMBER;

    PROCEDURE p(s VARCHAR2) IS BEGIN DBMS_OUTPUT.PUT_LINE(s); END;

    PROCEDURE c(k VARCHAR2, sec NUMBER, bg NUMBER, phv NUMBER) IS
    BEGIN cb(k).sec := sec; cb(k).bg := bg; cb(k).phv := phv; END;

    PROCEDURE load_corp IS
    BEGIN
        -- 사내 ZIOUI1 2026-10-14 10:4x 2회차 실측 (_corp_C03_out.txt). SQL_ID 는 BODY 원문이 사내 10-14 적용본과 같을 때만 일치한다.
        ca('82') := '프로시저 0.29s + fetch 0.61s = 0.90s  rows=38621 cols=53 · 함수 내부 SQL 562회 0.01s';
        ca('81') := '프로시저 0.35s + fetch 0.59s = 0.94s  rows=42088 cols=53 · 함수 내부 SQL 1218회 0.01s';
        ca('40') := '프로시저 0.33s + fetch 0.41s = 0.74s  rows=15569 cols=53 · 함수 내부 SQL 196회 0.00s';
        c('82:8pn2cpba1y5v8', 0.741, 38126, 3905882324);
        c('81:8pn2cpba1y5v8', 0.791, 42592, 3905882324);
        c('40:8pn2cpba1y5v8', 0.681, 42005, 3905882324);
        c('82:6yxcaghw1xvw4', 0.002, 551, 474365068);
        c('82:80gwfp597xcay', 0.002, 551, 474365068);
    END;

    PROCEDURE snap_sql(m OUT t_map) IS
    BEGIN
        FOR r IN (SELECT Q.SQL_ID || '/' || Q.CHILD_NUMBER K, Q.EXECUTIONS, Q.ELAPSED_TIME, Q.CPU_TIME, Q.BUFFER_GETS, Q.DISK_READS,
                         Q.ROWS_PROCESSED, Q.PLAN_HASH_VALUE, Q.PROGRAM_LINE#, Q.LOADS,
                         NVL(O.OBJECT_NAME, CASE WHEN Q.SQL_TEXT LIKE '%OPT\_DYN\_SAMP%' ESCAPE '\' THEN '(동적샘플링)' ELSE '-' END) PROG,
                         SUBSTR(REGEXP_REPLACE(Q.SQL_TEXT,'\s+',' '),1,100) TXT
                    FROM V$SQL Q LEFT JOIN USER_OBJECTS O ON O.OBJECT_ID = Q.PROGRAM_ID
                   WHERE Q.PROGRAM_ID = v_body_id
                      OR Q.PROGRAM_ID IN (SELECT OBJECT_ID FROM USER_OBJECTS
                                           WHERE OBJECT_NAME IN ('FN_GET_MULTI_OWNER_NAME','FN_SPLITSTRING','FN_GET_DEPT_LIST'))
                      OR Q.SQL_TEXT LIKE '%OPT\_DYN\_SAMP%' ESCAPE '\') LOOP
            m(r.K).ex := r.EXECUTIONS; m(r.K).el := r.ELAPSED_TIME; m(r.K).cpu := r.CPU_TIME;
            m(r.K).bg := r.BUFFER_GETS; m(r.K).dr := r.DISK_READS; m(r.K).rp := r.ROWS_PROCESSED;
            m(r.K).phv := r.PLAN_HASH_VALUE; m(r.K).line := r.PROGRAM_LINE#; m(r.K).hp := r.LOADS;
            m(r.K).prog := r.PROG; m(r.K).txt := r.TXT;
        END LOOP;
    END;

    PROCEDURE snap_stat(m OUT t_num) IS
    BEGIN
        FOR r IN (SELECT N.NAME, S.VALUE FROM V$MYSTAT S JOIN V$STATNAME N ON N.STATISTIC# = S.STATISTIC#
                   WHERE N.NAME IN ('session logical reads','physical reads','physical reads direct temporary tablespace',
                                    'physical writes direct temporary tablespace','parse count (hard)','parse count (total)',
                                    'parse time elapsed','CPU used by this session','execute count','recursive calls',
                                    'sorts (disk)','sorts (rows)','user I/O wait time','DB time',
                                    'bytes sent via SQL*Net to client','table scan rows gotten','index range scans')) LOOP
            m(r.NAME) := r.VALUE;
        END LOOP;
    END;

    PROCEDURE fetch_all(rc IN OUT SYS_REFCURSOR, p_rows OUT NUMBER, p_cols OUT NUMBER) IS
        cn INTEGER; dt DBMS_SQL.DESC_TAB; n NUMBER := 0;
    BEGIN
        p_rows := -1; p_cols := -1;
        IF NOT rc%ISOPEN THEN RETURN; END IF;
        cn := DBMS_SQL.TO_CURSOR_NUMBER(rc);
        DBMS_SQL.DESCRIBE_COLUMNS(cn, p_cols, dt);
        WHILE DBMS_SQL.FETCH_ROWS(cn) > 0 LOOP n := n + 1; END LOOP;
        DBMS_SQL.CLOSE_CURSOR(cn);
        p_rows := n;
    END;

    PROCEDURE report(p_div VARCHAR2) IS
        k VARCHAR2(40); ks VARCHAR2(64); ck VARCHAR2(40); v_cmp VARCHAR2(200); s t_snap; n PLS_INTEGER := 0; tmp t_dlt; mx PLS_INTEGER;
        tot_pkg NUMBER := 0; tot_fn NUMBER := 0; tot_ds NUMBER := 0; cnt_ds NUMBER := 0; ex_fn NUMBER := 0;
    BEGIN
        d.DELETE;
        k := a_sql.FIRST;
        WHILE k IS NOT NULL LOOP
            s := a_sql(k);
            IF b_sql.EXISTS(k) THEN
                s.ex := s.ex - b_sql(k).ex; s.el := s.el - b_sql(k).el; s.cpu := s.cpu - b_sql(k).cpu;
                s.bg := s.bg - b_sql(k).bg; s.dr := s.dr - b_sql(k).dr; s.rp := s.rp - b_sql(k).rp;
                s.hp := s.hp - b_sql(k).hp;
            END IF;
            IF s.ex > 0 OR s.el > 0 THEN
                n := n + 1; d(n).k := k; d(n).s := s;
                IF s.prog = '(동적샘플링)' THEN tot_ds := tot_ds + s.el; cnt_ds := cnt_ds + 1;
                ELSIF s.prog = 'PKG_DMF0005' THEN tot_pkg := tot_pkg + s.el;
                ELSE tot_fn := tot_fn + s.el; ex_fn := ex_fn + s.ex; END IF;
            END IF;
            k := a_sql.NEXT(k);
        END LOOP;
        FOR i IN 1 .. LEAST(n, c_top) LOOP
            mx := i;
            FOR j IN i + 1 .. n LOOP IF d(j).s.el > d(mx).s.el THEN mx := j; END IF; END LOOP;
            IF mx <> i THEN tmp := d(i); d(i) := d(mx); d(mx) := tmp; END IF;
        END LOOP;

        p('  (B) 문장별 귀속 — V$SQL 차이 상위 ' || c_top || ' (SEC = 경과 · BG = buffer gets · DR = disk reads · HP = 하드파싱 로드)');
        p('      ' || RPAD('LINE',6) || RPAD('PROGRAM',26) || LPAD('SEC',9) || LPAD('CPU',9) || LPAD('EXEC',8) || LPAD('BG',12)
          || LPAD('DR',10) || LPAD('ROWS',10) || LPAD('HP',4) || '  ' || RPAD('SQL_ID/CHILD',18) || RPAD('PHV',12)
          || LPAD('사내SEC',8) || LPAD('SEC_X',7) || LPAD('사내BG',10) || '  ' || RPAD('PHV비교',9) || 'TEXT');
        FOR i IN 1 .. LEAST(n, c_top) LOOP
            s := d(i).s;
            ck := p_div || ':' || SUBSTR(d(i).k, 1, INSTR(d(i).k, '/') - 1);
            IF cb.EXISTS(ck) THEN
                v_cmp := LPAD(TO_CHAR(cb(ck).sec,'FM9990.000'),8)
                      || LPAD(CASE WHEN cb(ck).sec > 0 THEN TO_CHAR(s.el/1e6/cb(ck).sec,'FM99990.0') END,7)
                      || LPAD(cb(ck).bg,10) || '  '
                      || RPAD(CASE WHEN cb(ck).phv = s.phv THEN 'same' ELSE '≠ 상이' END, 9);
            ELSE
                v_cmp := LPAD('-',8) || LPAD('-',7) || LPAD('-',10) || '  ' || RPAD('사내없음',9);
            END IF;
            p('      ' || RPAD(NVL(TO_CHAR(NULLIF(s.line,0)),'-'),6) || RPAD(s.prog,26)
              || LPAD(TO_CHAR(s.el/1e6,'FM99990.000'),9) || LPAD(TO_CHAR(s.cpu/1e6,'FM99990.000'),9) || LPAD(s.ex,8)
              || LPAD(s.bg,12) || LPAD(s.dr,10) || LPAD(s.rp,10) || LPAD(s.hp,4) || '  ' || RPAD(d(i).k,18)
              || RPAD(s.phv,12) || v_cmp || SUBSTR(s.txt,1,80));
        END LOOP;
        p('      합계: 패키지 문장 ' || TO_CHAR(tot_pkg/1e6,'FM99990.00') || 's · 함수 내부 SQL ' || TO_CHAR(tot_fn/1e6,'FM99990.00')
          || 's (' || ex_fn || '회 실행) · 동적 샘플링 재귀 ' || TO_CHAR(tot_ds/1e6,'FM99990.00') || 's (' || cnt_ds || '문장)');
        p('      ※ 패키지 문장의 SEC 에는 그 문장이 부른 함수 내부 SQL 시간이 포함된다 (함수 내부 SQL 은 따로 한 번 더 보인다)');
        v_sum_el := tot_pkg + tot_ds;

        p('  (C) 내 세션 ASH — SQL_ID × 이벤트 × 계획 줄 (표본 ≈ 초)');
        FOR r IN (SELECT NVL(A.SQL_ID,'(PL/SQL)') SQL_ID, NVL(A.EVENT,'ON CPU') EVT, COUNT(*) N,
                         MAX(A.SQL_PLAN_HASH_VALUE) PHV, A.SQL_PLAN_LINE_ID LN,
                         MAX(A.SQL_PLAN_OPERATION || ' ' || A.SQL_PLAN_OPTIONS) OP,
                         MAX((SELECT O.OBJECT_NAME FROM ALL_OBJECTS O WHERE O.OBJECT_ID = A.CURRENT_OBJ# AND ROWNUM = 1)) OBJ
                    FROM V$ACTIVE_SESSION_HISTORY A
                   WHERE A.SESSION_ID = v_sid AND A.SAMPLE_TIME >= v_ts
                   GROUP BY NVL(A.SQL_ID,'(PL/SQL)'), NVL(A.EVENT,'ON CPU'), A.SQL_PLAN_LINE_ID
                   ORDER BY 3 DESC FETCH FIRST 15 ROWS ONLY) LOOP
            p('      ' || RPAD(r.SQL_ID,16) || LPAD(r.N,5) || '  ' || RPAD(r.EVT,34) || RPAD(NVL(TO_CHAR(r.PHV),'-'),12)
              || 'line ' || RPAD(NVL(TO_CHAR(r.LN),'-'),5) || RPAD(NVL(r.OP,'-'),34) || NVL(r.OBJ,'-'));
        END LOOP;

        p('  (D) 세션 통계 차이');
        ks := a_st.FIRST;
        WHILE ks IS NOT NULL LOOP
            IF a_st(ks) - CASE WHEN b_st.EXISTS(ks) THEN b_st(ks) ELSE 0 END <> 0 THEN
                p('      ' || RPAD(ks,48) || LPAD(a_st(ks) - CASE WHEN b_st.EXISTS(ks) THEN b_st(ks) ELSE 0 END, 16));
            END IF;
            ks := a_st.NEXT(ks);
        END LOOP;
    END;
BEGIN
    SELECT OBJECT_ID INTO v_body_id FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_DMF0005' AND OBJECT_TYPE = 'PACKAGE BODY';
    load_corp;

    p('================================================================================================');
    p(' DMF0005 조회 프로시저 프로파일  DB=' || SYS_CONTEXT('USERENV','DB_NAME') || '/' || SYS_CONTEXT('USERENV','CON_NAME')
      || '  HOST=' || SYS_CONTEXT('USERENV','SERVER_HOST') || '  SID=' || v_sid || '  ' || TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS'));
    p(' 인자: user=' || c_user || ' · dept / cust / site = ALL · pjt / item / owner = 빈칸 · active = ALL (화면 기본 조회)');
    p(' 사내SEC / 사내BG = 같은 SQL_ID 의 사내 1회 실측 · SEC_X = 이 DB ÷ 사내 · PHV비교 ≠ = 실행계획이 사내와 다름');
    p(' 사내없음 = SQL_ID 가 사내와 다름(문장 원문이 다름 = BODY 판본 차이 — C01 [E2b] 참조)');
    p('================================================================================================');

    v_rest := c_divs || ',';
    WHILE INSTR(v_rest, ',') > 0 LOOP
        v_div  := TRIM(SUBSTR(v_rest, 1, INSTR(v_rest, ',') - 1));
        v_rest := SUBSTR(v_rest, INSTR(v_rest, ',') + 1);
        CONTINUE WHEN v_div IS NULL;
        FOR run IN 1 .. 3 LOOP
            IF run = 3 THEN EXECUTE IMMEDIATE 'ALTER SESSION SET statistics_level = ALL'; END IF;
            b_sql.DELETE; a_sql.DELETE; b_st.DELETE; a_st.DELETE;
            snap_sql(b_sql); snap_stat(b_st);
            v_ts := SYSTIMESTAMP;
            t0 := DBMS_UTILITY.GET_TIME;
            PKG_DMF0005.P_DMF0005_GET_SALES_SITE_MODEL_PRODUCTION(
                P_DIVISION_ID => v_div, P_DEPT_ID => 'ALL', P_END_CUSTOMER => 'ALL', P_SCM_SITE_ID => 'ALL',
                P_PROJECT_CODE => NULL, P_ITEM_ID => NULL, P_VALID_YN => 'ALL', P_OWNER => NULL, P_USER_ID => c_user,
                O_RC1 => rc1, O_RESULT_CURSOR => rcr);
            t1 := DBMS_UTILITY.GET_TIME;
            fetch_all(rc1, v_rows, v_cols);
            fetch_all(rcr, v_dummy, v_dummy);
            t2 := DBMS_UTILITY.GET_TIME;
            snap_sql(a_sql); snap_stat(a_st);
            ROLLBACK;
            IF run = 3 THEN EXECUTE IMMEDIATE 'ALTER SESSION SET statistics_level = TYPICAL'; END IF;
            p('');
            p('### div=' || v_div || ' run' || run || CASE run WHEN 1 THEN ' (하드파싱 포함)' WHEN 2 THEN ' (재사용 — 판단 기준)' ELSE ' (행 실측 켬 — 시간은 참고)' END
              || '  (A) 프로시저 ' || TO_CHAR((t1 - t0)/100,'FM99990.00') || 's  + 커서 fetch '
              || TO_CHAR((t2 - t1)/100,'FM99990.00') || 's  = DB 합 ' || TO_CHAR((t2 - t0)/100,'FM99990.00')
              || 's   rows=' || v_rows || ' cols=' || v_cols);
            IF ca.EXISTS(v_div) THEN p('      사내 기준(ZIOUI1 2회차): ' || ca(v_div)); END IF;
            report(v_div);
            p('      → 문장 귀속 합 ' || TO_CHAR(v_sum_el/1e6,'FM99990.00') || 's / DB 합 ' || TO_CHAR((t2 - t0)/100,'FM99990.00')
              || 's (차이 = PL/SQL 처리 · 행 전달 · 귀속 밖 재귀 SQL)');
        END LOOP;
    END LOOP;
    p('');
    p('완료 — C03_SP_PROFILE_OUT.txt 회신');
EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    BEGIN EXECUTE IMMEDIATE 'ALTER SESSION SET statistics_level = TYPICAL'; EXCEPTION WHEN OTHERS THEN NULL; END;
    p('!!! 오류: ' || SQLERRM);
    p(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
    RAISE;
END;
/

SPOOL OFF
SET FEEDBACK ON
