-- =============================================================================
-- D03_SP_STAGE_PROFILE_81.sql — DMF0082 81 조회 타임아웃 점검 ③ SP 직접 실행 · 문장별 병목 귀속 (81 → 40 순)
--   계정: SCM_MGR · SQL Developer 스크립트 실행(F5) 또는 sqlplus @D03_SP_STAGE_PROFILE_81.sql
--   ⚠ 81 이 타임아웃급이면 이 스크립트도 그만큼 걸린다(세션 타임아웃 없음 — 끝까지 둔다). 급하면 c_divs := '81' 로 먼저.
--   ⚠ c_user / c_group 은 타임아웃을 본 사용자의 로그인 ID / D02 [S1] USER_GROUP 으로 바꾸면 그 사용자 메저 조건으로 재현된다 (09-30 k0101 사례).
--   무엇을 하나: 화면 Search 와 같은 인자로 PKG_DMF0082.P_DMF0082_GET_MAIN_DATA 를 division 별로 N회 실행하고
--     (A) SP 시간 / 결과 커서 6개 fetch 시간·행수
--     (B) 문장별 귀속 — V$SQL 전후 델타(이 PKG 문장 + GT_DMF0082 동적 SQL + 동적 샘플링 재귀 SQL)
--     (C) 내 세션 ASH — SQL_ID × 대기이벤트 (1초 표본, 긴 구간 확인용)
--     (D) 세션 통계 델타 — 논리/물리 IO · 하드파싱 · TEMP 유출 · CPU
--   변경: 영구 테이블 변경 없음 (GTT 만 채움, 매 회 ROLLBACK). 세션 파라미터는 SP 자체가 dynamic_sampling=2 로 설정.
--   ⚠ 측정 중 다른 사람이 DMF0082 를 조회하면 (B) V$SQL 델타가 섞인다 — (C) ASH 는 내 세션만이라 섞이지 않음.
--   ⚠ 1회차 = 하드파싱 포함, 2회차 = 커서 재사용 (화면 BE 커넥션 풀 조건). 2회차 수치로 판단.
--   ⏱ 클라우드 82 가 수 분 걸릴 수 있음 → c_divs 를 '82' 하나로 좁혀 먼저 실행해도 됨.
-- =============================================================================
SET SERVEROUTPUT ON SIZE UNLIMITED FORMAT WRAPPED
SET LINESIZE 400
SET TRIMSPOOL ON
SET FEEDBACK OFF
SPOOL D03_SP_STAGE_PROFILE_81_OUT.txt

DECLARE
    -- ===== 설정 (필요 시 여기만 수정) =====================================================
    c_divs      CONSTANT VARCHAR2(100) := '81,40';        -- 측정 division (쉼표) — 81 먼저, 40 은 대조군
    c_repeat    CONSTANT PLS_INTEGER   := 2;              -- division 당 반복 (2회차 = 재사용 조건)
    c_user      CONSTANT VARCHAR2(50)  := 'minyonglee1';  -- p_created_by (화면 로그인 ID)
    c_group     CONSTANT VARCHAR2(50)  := 'ADMIN';        -- p_user_group (C02 [S1] USER_GROUP 값과 동일하게)
    c_version   CONSTANT VARCHAR2(30)  := 'Current';      -- p_version_type
    c_rowstats  CONSTANT VARCHAR2(1)   := 'N';            -- 'Y' = statistics_level=ALL (C04 에서 A-Rows 확인용 · 약간 느려짐)
    c_top       CONSTANT PLS_INTEGER   := 25;             -- 문장별 상위 N
    -- 기간 = FE 기본값 (당월 1일 ~ +6개월 -1일, makeInitSearchParams)
    v_from      VARCHAR2(8) := TO_CHAR(TRUNC(SYSDATE,'MM'),'YYYYMMDD');
    v_to        VARCHAR2(8) := TO_CHAR(ADD_MONTHS(TRUNC(SYSDATE,'MM'),6) - 1,'YYYYMMDD');
    -- ==========================================================================================

    TYPE t_snap IS RECORD (ex NUMBER, el NUMBER, cpu NUMBER, bg NUMBER, dr NUMBER, rp NUMBER,
                           phv NUMBER, line NUMBER, hp NUMBER, txt VARCHAR2(400 CHAR));
    TYPE t_map  IS TABLE OF t_snap INDEX BY VARCHAR2(40);
    TYPE t_dlt  IS RECORD (k VARCHAR2(40), s t_snap);
    TYPE t_dlts IS TABLE OF t_dlt INDEX BY PLS_INTEGER;
    TYPE t_num  IS TABLE OF NUMBER INDEX BY VARCHAR2(64);
    TYPE t_proc IS TABLE OF VARCHAR2(60) INDEX BY PLS_INTEGER;
    TYPE t_cb   IS RECORD (sec NUMBER, bg NUMBER, phv NUMBER);
    TYPE t_cbm  IS TABLE OF t_cb INDEX BY VARCHAR2(40);
    TYPE t_ca   IS TABLE OF VARCHAR2(80) INDEX BY VARCHAR2(10);
    cb          t_cbm;        -- 사내 기준 (div:SQL_ID → 1회 초·BG·PHV)
    ca          t_ca;         -- 사내 기준 (div → SP·fetch 초)

    v_body_id   NUMBER;
    v_sid       NUMBER := SYS_CONTEXT('USERENV','SID');
    v_procs     t_proc;           -- BODY 시작 라인 → 프로시저명
    b_sql       t_map;  a_sql t_map;
    b_st        t_num;  a_st  t_num;
    d           t_dlts;
    v_div       VARCHAR2(10);
    v_rest      VARCHAR2(100);
    rc1 SYS_REFCURSOR; rc2 SYS_REFCURSOR; rc3 SYS_REFCURSOR; rc4 SYS_REFCURSOR; rc5 SYS_REFCURSOR; rcr SYS_REFCURSOR;
    t0 NUMBER; t1 NUMBER; t2 NUMBER;
    v_ts        TIMESTAMP;
    v_rows      VARCHAR2(200);
    v_sum_el    NUMBER;

    PROCEDURE p(s VARCHAR2) IS BEGIN DBMS_OUTPUT.PUT_LINE(s); END;

    PROCEDURE c(k VARCHAR2, sec NUMBER, bg NUMBER, phv NUMBER) IS
    BEGIN cb(k).sec := sec; cb(k).bg := bg; cb(k).phv := phv; END;

    PROCEDURE load_corp IS
    BEGIN
        -- <<CORP_BASELINE>> (_build_c03_baseline.py 가 _corp_C03_out.txt 2회차에서 생성 — 손으로 고치지 말 것)
        ca('40') := 'SP 3.34s + fetch 0.61s = 3.95s  rows=2099,6,1,5,182,1';
        ca('81') := 'SP 4.15s + fetch 0.74s = 4.89s  rows=2383,6,1,5,182,1';
        ca('82') := 'SP 13.93s + fetch 0.89s = 14.82s  rows=2608,6,1,5,182,1';
        c('40:18xg1y5298qgq', 0.704, 25794, 3971101268);
        c('40:56fkh52zfndm7', 0.602, 16195, 360512032);
        c('40:631pzfvq8r0ut', 0.516, 62379, 620290878);
        c('40:20xrvz802rfsy', 0.339, 89883, 1553021311);
        c('40:4svg4dhnqxh8f', 0.185, 32400, 3195295405);
        c('40:f6r0861xjw0h1', 0.180, 26674, 4237537377);
        c('40:70xvv1ktud7js', 0.151, 6944, 1667501949);
        c('40:6bucw2kzuc0nt', 0.145, 18670, 3737877804);
        c('40:19mfxqb34sbky', 0.133, 18385, 4145401064);
        c('40:c0muq7dr11ks5', 0.133, 13888, 633531915);
        c('40:fy9k6a9dk8uph', 0.129, 16801, 633531915);
        c('40:0rp3b1v236wwz', 0.124, 33345, 4066606801);
        c('40:day2h1hdkc8y1', 0.121, 14927, 3484297769);
        c('40:ac561dnz1arup', 0.110, 15527, 2591175856);
        c('40:3x9ardnmfczp0', 0.098, 7767, 116174995);
        c('40:63ar9rz0axr5p', 0.092, 4771, 2395782385);
        c('40:9wgfrws532db6', 0.044, 2068, 3069957411);
        c('40:8ngcf5avm1q3q', 0.035, 2160, 3642427876);
        c('40:41tabk4sgrfsy', 0.019, 6944, 3273597457);
        c('40:cct9d3wpufmjn', 0.015, 659, 3069957411);
        c('40:ar7u7g5yjbm65', 0.013, 708, 1994303945);
        c('40:ggkupust9vjpj', 0.012, 6944, 422164050);
        c('40:67sysamdcxzmj', 0.012, 3239, 2351976090);
        c('40:chnk6fsq0zmjw', 0.007, 3239, 2351976090);
        c('40:8zj5nqpk4g3d6', 0.005, 3239, 4271728968);
        c('81:d019r0hbb0muh', 1.069, 68062, 2682586817);
        c('81:18xg1y5298qgq', 0.815, 27155, 3971101268);
        c('81:56fkh52zfndm7', 0.734, 17260, 360512032);
        c('81:19mfxqb34sbky', 0.400, 53667, 4145401064);
        c('81:20xrvz802rfsy', 0.341, 101508, 1553021311);
        c('81:63ar9rz0axr5p', 0.235, 9769, 2395782385);
        c('81:f6r0861xjw0h1', 0.171, 26610, 4237537377);
        c('81:70xvv1ktud7js', 0.157, 7019, 1667501949);
        c('81:day2h1hdkc8y1', 0.133, 15528, 3484297769);
        c('81:c0muq7dr11ks5', 0.128, 14038, 633531915);
        c('81:0rp3b1v236wwz', 0.107, 31859, 4066606801);
        c('81:fy9k6a9dk8uph', 0.106, 14038, 633531915);
        c('81:3x9ardnmfczp0', 0.067, 3452, 116174995);
        c('81:ar7u7g5yjbm65', 0.026, 1432, 1994303945);
        c('81:9wgfrws532db6', 0.023, 1176, 3069957411);
        c('81:41tabk4sgrfsy', 0.017, 7019, 3273597457);
        c('81:8ngcf5avm1q3q', 0.015, 1030, 3642427876);
        c('81:67sysamdcxzmj', 0.012, 3452, 2351976090);
        c('81:ggkupust9vjpj', 0.012, 7019, 422164050);
        c('81:chnk6fsq0zmjw', 0.007, 3452, 2351976090);
        c('81:cct9d3wpufmjn', 0.007, 548, 3069957411);
        c('81:44vn8bsu0xuxu', 0.007, 375, 235092075);
        c('81:8zj5nqpk4g3d6', 0.005, 3452, 4271728968);
        c('81:0yy1vysbs3rca', 0.003, 150, 235092075);
        c('81:7jg4wbat2mb66', 0.002, 1426, 125332918);
        c('82:d019r0hbb0muh', 9.472, 127563, 2682586817);
        c('82:19mfxqb34sbky', 1.670, 38824, 4145401064);
        c('82:18xg1y5298qgq', 1.183, 104149, 3971101268);
        c('82:56fkh52zfndm7', 0.880, 20290, 360512032);
        c('82:20xrvz802rfsy', 0.331, 95792, 1553021311);
        c('82:63ar9rz0axr5p', 0.195, 9470, 2395782385);
        c('82:70xvv1ktud7js', 0.187, 7270, 1667501949);
        c('82:c0muq7dr11ks5', 0.140, 14540, 633531915);
        c('82:f6r0861xjw0h1', 0.128, 15338, 4237537377);
        c('82:fy9k6a9dk8uph', 0.117, 14891, 633531915);
        c('82:gfjpdh7fc1u59', 0.112, 45481, 982384402);
        c('82:0rp3b1v236wwz', 0.089, 30867, 4066606801);
        c('82:day2h1hdkc8y1', 0.082, 14766, 3484297769);
        c('82:3x9ardnmfczp0', 0.082, 4058, 116174995);
        c('82:ar7u7g5yjbm65', 0.031, 1432, 1994303945);
        c('82:41tabk4sgrfsy', 0.019, 7270, 3273597457);
        c('82:67sysamdcxzmj', 0.015, 4058, 2351976090);
        c('82:c3bg6q8n39195', 0.015, 3040, 3995613941);
        c('82:ggkupust9vjpj', 0.011, 7270, 422164050);
        c('82:chnk6fsq0zmjw', 0.009, 4058, 2351976090);
        c('82:8zj5nqpk4g3d6', 0.008, 4058, 4271728968);
        c('82:9wgfrws532db6', 0.007, 687, 3069957411);
        c('82:8ngcf5avm1q3q', 0.004, 508, 3642427876);
        c('82:cct9d3wpufmjn', 0.003, 530, 3069957411);
        c('82:9pbzwq00mxuh3', 0.002, 1431, 3123668380);
        -- <</CORP_BASELINE>>
    END;

    FUNCTION proc_of(p_line NUMBER) RETURN VARCHAR2 IS
        i PLS_INTEGER; r VARCHAR2(60) := '-';
    BEGIN
        IF p_line IS NULL OR p_line = 0 THEN RETURN '-'; END IF;
        i := v_procs.FIRST;
        WHILE i IS NOT NULL AND i <= p_line LOOP r := v_procs(i); i := v_procs.NEXT(i); END LOOP;
        RETURN REPLACE(r, 'P_DMF0082_', '');
    END;

    PROCEDURE snap_sql(m OUT t_map) IS
    BEGIN
        FOR r IN (SELECT SQL_ID || '/' || CHILD_NUMBER K, EXECUTIONS, ELAPSED_TIME, CPU_TIME, BUFFER_GETS, DISK_READS,
                         ROWS_PROCESSED, PLAN_HASH_VALUE, PROGRAM_LINE#, LOADS,
                         SUBSTR(REGEXP_REPLACE(SQL_TEXT,'\s+',' '),1,100) TXT
                    FROM V$SQL
                   WHERE PROGRAM_ID = v_body_id
                      OR (PARSING_SCHEMA_NAME = USER AND SQL_TEXT LIKE '%GT\_DMF0082%' ESCAPE '\')
                      OR SQL_TEXT LIKE '%OPT\_DYN\_SAMP%' ESCAPE '\') LOOP
            m(r.K).ex := r.EXECUTIONS; m(r.K).el := r.ELAPSED_TIME; m(r.K).cpu := r.CPU_TIME;
            m(r.K).bg := r.BUFFER_GETS; m(r.K).dr := r.DISK_READS; m(r.K).rp := r.ROWS_PROCESSED;
            m(r.K).phv := r.PLAN_HASH_VALUE; m(r.K).line := r.PROGRAM_LINE#; m(r.K).hp := r.LOADS;
            m(r.K).txt := r.TXT;
        END LOOP;
    END;

    PROCEDURE snap_stat(m OUT t_num) IS
    BEGIN
        FOR r IN (SELECT N.NAME, S.VALUE FROM V$MYSTAT S JOIN V$STATNAME N ON N.STATISTIC# = S.STATISTIC#
                   WHERE N.NAME IN ('session logical reads','physical reads','physical reads direct temporary tablespace',
                                    'physical writes direct temporary tablespace','parse count (hard)','parse count (total)',
                                    'parse time elapsed','CPU used by this session','execute count','recursive calls',
                                    'sorts (disk)','sorts (rows)','redo size','user I/O wait time','DB time')) LOOP
            m(r.NAME) := r.VALUE;
        END LOOP;
    END;

    FUNCTION fetch_count(rc IN OUT SYS_REFCURSOR) RETURN NUMBER IS
        c INTEGER; n NUMBER := 0;
    BEGIN
        IF NOT rc%ISOPEN THEN RETURN -1; END IF;
        c := DBMS_SQL.TO_CURSOR_NUMBER(rc);
        WHILE DBMS_SQL.FETCH_ROWS(c) > 0 LOOP n := n + 1; END LOOP;
        DBMS_SQL.CLOSE_CURSOR(c);
        RETURN n;
    EXCEPTION WHEN OTHERS THEN RETURN -2;
    END;

    PROCEDURE report(p_div VARCHAR2, p_run PLS_INTEGER) IS
        k VARCHAR2(40); ks VARCHAR2(64); ck VARCHAR2(40); v_cmp VARCHAR2(200); s t_snap; n PLS_INTEGER := 0; tmp t_dlt; mx PLS_INTEGER;
        v_cat VARCHAR2(10); tot_pkg NUMBER := 0; tot_dyn NUMBER := 0; tot_ds NUMBER := 0; cnt_ds NUMBER := 0;
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
                IF s.txt LIKE '%OPT_DYN_SAMP%' THEN tot_ds := tot_ds + s.el; cnt_ds := cnt_ds + 1;
                ELSIF NVL(s.line,0) > 0 THEN tot_pkg := tot_pkg + s.el;
                ELSE tot_dyn := tot_dyn + s.el; END IF;
            END IF;
            k := a_sql.NEXT(k);
        END LOOP;
        -- 경과시간 내림차순 (선택 정렬 — 수십~수백 건)
        FOR i IN 1 .. LEAST(n, c_top) LOOP
            mx := i;
            FOR j IN i + 1 .. n LOOP IF d(j).s.el > d(mx).s.el THEN mx := j; END IF; END LOOP;
            IF mx <> i THEN tmp := d(i); d(i) := d(mx); d(mx) := tmp; END IF;
        END LOOP;

        p('  (B) 문장별 귀속 — V$SQL 델타 상위 ' || c_top || ' (초 = ELAPSED, BG = buffer gets, DR = disk reads, HP = 하드파싱 로드)');
        p('      ' || RPAD('LINE',6) || RPAD('PROC',22) || LPAD('SEC',8) || LPAD('CPU',8) || LPAD('EXEC',6) || LPAD('BG',12)
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
            p('      ' || RPAD(NVL(TO_CHAR(NULLIF(s.line,0)),'-'),6) || RPAD(proc_of(s.line),22)
              || LPAD(TO_CHAR(s.el/1e6,'FM9990.000'),8) || LPAD(TO_CHAR(s.cpu/1e6,'FM9990.000'),8) || LPAD(s.ex,6)
              || LPAD(s.bg,12) || LPAD(s.dr,10) || LPAD(s.rp,10) || LPAD(s.hp,4) || '  ' || RPAD(d(i).k,18)
              || RPAD(s.phv,12) || v_cmp || SUBSTR(s.txt,1,80));
        END LOOP;
        p('      합계: PKG 정적문장 ' || TO_CHAR(tot_pkg/1e6,'FM9990.00') || 's · 동적/기타(GT_DMF0082) '
          || TO_CHAR(tot_dyn/1e6,'FM9990.00') || 's · 동적샘플링 재귀 ' || TO_CHAR(tot_ds/1e6,'FM9990.00')
          || 's (' || cnt_ds || '문장)');
        v_sum_el := tot_pkg + tot_dyn + tot_ds;

        p('  (C) 내 세션 ASH — SQL_ID × 이벤트 (샘플 ≈ 초)');
        FOR r IN (SELECT NVL(A.SQL_ID,'(PL/SQL)') SQL_ID, NVL(A.EVENT,'ON CPU') EVT, COUNT(*) N,
                         MAX(A.SQL_PLAN_HASH_VALUE) PHV,
                         MAX(A.SQL_PLAN_OPERATION || ' ' || A.SQL_PLAN_OPTIONS) KEEP (DENSE_RANK LAST ORDER BY A.SAMPLE_ID) OP
                    FROM V$ACTIVE_SESSION_HISTORY A
                   WHERE A.SESSION_ID = v_sid AND A.SAMPLE_TIME >= v_ts
                   GROUP BY NVL(A.SQL_ID,'(PL/SQL)'), NVL(A.EVENT,'ON CPU')
                   ORDER BY 3 DESC FETCH FIRST 12 ROWS ONLY) LOOP
            p('      ' || RPAD(r.SQL_ID,16) || LPAD(r.N,5) || '  ' || RPAD(r.EVT,40) || RPAD(NVL(TO_CHAR(r.PHV),'-'),12) || r.OP);
        END LOOP;

        p('  (D) 세션 통계 델타');
        ks := a_st.FIRST;
        WHILE ks IS NOT NULL LOOP
            IF a_st(ks) - CASE WHEN b_st.EXISTS(ks) THEN b_st(ks) ELSE 0 END <> 0 THEN
                p('      ' || RPAD(ks,48) || LPAD(a_st(ks) - CASE WHEN b_st.EXISTS(ks) THEN b_st(ks) ELSE 0 END, 16));
            END IF;
            ks := a_st.NEXT(ks);
        END LOOP;
    END;
BEGIN
    SELECT OBJECT_ID INTO v_body_id FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_DMF0082' AND OBJECT_TYPE = 'PACKAGE BODY';
    FOR r IN (SELECT LINE, REGEXP_SUBSTR(TEXT,'P_\w+') NM FROM USER_SOURCE
               WHERE NAME = 'PKG_DMF0082' AND TYPE = 'PACKAGE BODY' AND REGEXP_LIKE(TEXT,'^PROCEDURE\s+P_')) LOOP
        v_procs(r.LINE) := r.NM;
    END LOOP;
    IF c_rowstats = 'Y' THEN EXECUTE IMMEDIATE 'ALTER SESSION SET statistics_level = ALL'; END IF;
    load_corp;

    p('================================================================================================');
    p(' DMF0082 SP 프로파일  DB=' || SYS_CONTEXT('USERENV','DB_NAME') || '/' || SYS_CONTEXT('USERENV','CON_NAME')
      || '  HOST=' || SYS_CONTEXT('USERENV','SERVER_HOST') || '  SID=' || v_sid || '  ' || TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS'));
    p(' 인자: user=' || c_user || ' group=' || c_group || ' version=' || c_version || ' 기간 ' || v_from || '~' || v_to
      || ' · 나머지 필터 ALL · itemId NULL · statistics_level=' || CASE c_rowstats WHEN 'Y' THEN 'ALL' ELSE '기본' END);
    p(' 사내SEC/사내BG = 같은 SQL_ID 의 사내 1회 실측 · SEC_X = 클라우드÷사내 · PHV비교 ≠ = 실행계획이 사내와 다름 (최우선 의심)');
    p('================================================================================================');

    v_rest := c_divs || ',';
    WHILE INSTR(v_rest, ',') > 0 LOOP
        v_div  := TRIM(SUBSTR(v_rest, 1, INSTR(v_rest, ',') - 1));
        v_rest := SUBSTR(v_rest, INSTR(v_rest, ',') + 1);
        CONTINUE WHEN v_div IS NULL;
        FOR run IN 1 .. c_repeat LOOP
            b_sql.DELETE; a_sql.DELETE; b_st.DELETE; a_st.DELETE;
            snap_sql(b_sql); snap_stat(b_st);
            v_ts := SYSTIMESTAMP;
            t0 := DBMS_UTILITY.GET_TIME;
            PKG_DMF0082.P_DMF0082_GET_MAIN_DATA(
                p_division_id => v_div, p_team_id => 'ALL', p_customer => 'ALL', p_biz_type => 'ALL',
                p_from_yyyymmdd => v_from, p_to_yyyymmdd => v_to, p_scm_site_id => 'ALL', p_item_id => NULL,
                p_version_type => c_version, p_qty_yn => 'N', p_created_by => c_user, p_user_group => c_group,
                p_plant_site_id => 'ALL', p_project_code => 'ALL', p_owner => 'ALL', p_sender_code => 'ALL',
                O_RC1 => rc1, O_RC2 => rc2, O_RC3 => rc3, O_RC4 => rc4, O_RC5 => rc5, O_RESULT_CURSOR => rcr);
            t1 := DBMS_UTILITY.GET_TIME;
            v_rows := fetch_count(rc1) || ',' || fetch_count(rc2) || ',' || fetch_count(rc3) || ','
                   || fetch_count(rc4) || ',' || fetch_count(rc5) || ',' || fetch_count(rcr);
            t2 := DBMS_UTILITY.GET_TIME;
            snap_sql(a_sql); snap_stat(a_st);
            ROLLBACK;
            p('');
            p('### div=' || v_div || ' run' || run || '  (A) SP ' || TO_CHAR((t1 - t0)/100,'FM99990.00') || 's  + 커서 fetch '
              || TO_CHAR((t2 - t1)/100,'FM99990.00') || 's  = DB 합 ' || TO_CHAR((t2 - t0)/100,'FM99990.00')
              || 's   rows[RC1..5,RESULT]=' || v_rows);
            IF ca.EXISTS(v_div) THEN p('      사내 기준(ZIOUI1 2회차): ' || ca(v_div)); END IF;
            report(v_div, run);
            p('      → 문장 귀속 합 ' || TO_CHAR(v_sum_el/1e6,'FM99990.00') || 's / DB 합 ' || TO_CHAR((t2 - t0)/100,'FM99990.00')
              || 's (차이 = PL/SQL 처리·귀속 밖 재귀SQL)');
        END LOOP;
    END LOOP;
    IF c_rowstats = 'Y' THEN EXECUTE IMMEDIATE 'ALTER SESSION SET statistics_level = TYPICAL'; END IF;
    p('');
    p('완료 — 상위 문장의 SQL_ID 를 D04_PLAN_OF_SQLID.sql DEFINE SQL_ID 에 넣어 실행계획 확인 (D04 [P0] 는 ASH 상위 3 자동)');
EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    p('!!! 오류: ' || SQLERRM);
    p(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
    RAISE;
END;
/

SPOOL OFF
SET FEEDBACK ON
