-- =============================================================================
-- C05_SP_STAGE_BREAKDOWN.sql — DMF0082 조회 클라우드 점검 ⑤ SP 단계(구간)별 소요 · 단계별 적재 행수
--   계정: SCM_MGR · SQL Developer 스크립트 실행(F5) 또는 sqlplus @C05_SP_STAGE_BREAKDOWN.sql
--   무엇을 하나: 화면 Search 와 같은 인자로 P_DMF0082_GET_MAIN_DATA 를 사용자 × division 별로 실행하고
--     (1) 단계별 소요 — SP 본문의 구간 머리주석(-- ===== 다음 줄 제목)을 단계로 삼아 문장 시간(V$SQL 델타)을 합산
--         + 그 단계 안에서 가장 비싼 문장 1개
--     (2) 결과 커서 fetch 시간 (= 최종 동적 PIVOT 실행분)
--     (3) SP 종료 직후 GTT 적재 행수 (단계별 데이터량 — 어디서 행이 불어나는지)
--   변경: 영구 테이블 변경 없음 (GTT 만 채움, 매 회 ROLLBACK)
--   ⚠ 측정 중 다른 사람이 DMF0082 를 조회하면 V$SQL 델타가 섞인다 → 한가한 시간에 실행
--   ⚠ 각 조건 2회 실행, 2회차(커서 재사용 = 화면 BE 조건)로 판단
-- =============================================================================
SET SERVEROUTPUT ON SIZE UNLIMITED FORMAT WRAPPED
SET LINESIZE 400
SET TRIMSPOOL ON
SET FEEDBACK OFF
SPOOL C05_SP_STAGE_BREAKDOWN_OUT.txt

DECLARE
    -- ===== 설정 (필요 시 여기만 수정) =====================================================
    c_users     CONSTANT VARCHAR2(200) := 'minyonglee1,k0101'; -- p_created_by (쉼표) — 메저 선택이 많은 실사용 계정 포함 권장
    c_divs      CONSTANT VARCHAR2(100) := '40,81,82';           -- division (쉼표)
    c_repeat    CONSTANT PLS_INTEGER   := 2;                    -- 조건당 반복 (마지막 회차만 상세 출력)
    c_group     CONSTANT VARCHAR2(50)  := 'ADMIN';              -- p_user_group (C02 [S1] USER_GROUP)
    c_version   CONSTANT VARCHAR2(30)  := 'Current';
    v_from      VARCHAR2(8) := TO_CHAR(TRUNC(SYSDATE,'MM'),'YYYYMMDD');
    v_to        VARCHAR2(8) := TO_CHAR(ADD_MONTHS(TRUNC(SYSDATE,'MM'),6) - 1,'YYYYMMDD');
    -- ==========================================================================================

    TYPE t_snap IS RECORD (el NUMBER, bg NUMBER, rp NUMBER, line NUMBER, pid NUMBER, txt VARCHAR2(400 CHAR));
    TYPE t_map  IS TABLE OF t_snap INDEX BY VARCHAR2(40);
    TYPE t_stg  IS RECORD (title VARCHAR2(200 CHAR), el NUMBER := 0, bg NUMBER := 0, n NUMBER := 0,
                           top_el NUMBER := 0, top_k VARCHAR2(40), top_rows NUMBER, top_line NUMBER);
    TYPE t_stgs IS TABLE OF t_stg INDEX BY PLS_INTEGER;       -- key = 단계 시작 라인
    TYPE t_list IS TABLE OF VARCHAR2(100) INDEX BY PLS_INTEGER;

    v_body_id   NUMBER;
    v_l0        NUMBER; v_l1 NUMBER;                         -- GET_MAIN_DATA 라인 범위
    stg         t_stgs;                                      -- 단계 템플릿 (제목만)
    cur_stg     t_stgs;
    b_sql       t_map;  a_sql t_map;
    users       t_list; divs t_list;
    rc1 SYS_REFCURSOR; rc2 SYS_REFCURSOR; rc3 SYS_REFCURSOR; rc4 SYS_REFCURSOR; rc5 SYS_REFCURSOR; rcr SYS_REFCURSOR;
    t0 NUMBER; t1 NUMBER; t2 NUMBER;
    v_rows      VARCHAR2(200);
    v_other     NUMBER;

    PROCEDURE p(s VARCHAR2) IS BEGIN DBMS_OUTPUT.PUT_LINE(s); END;

    PROCEDURE split(s VARCHAR2, l OUT t_list) IS
        r VARCHAR2(400) := s || ','; i PLS_INTEGER := 0;
    BEGIN
        WHILE INSTR(r, ',') > 0 LOOP
            IF TRIM(SUBSTR(r, 1, INSTR(r, ',') - 1)) IS NOT NULL THEN
                i := i + 1; l(i) := TRIM(SUBSTR(r, 1, INSTR(r, ',') - 1));
            END IF;
            r := SUBSTR(r, INSTR(r, ',') + 1);
        END LOOP;
    END;

    PROCEDURE snap_sql(m OUT t_map) IS
    BEGIN
        -- PKG 문장 + 다른 PL/SQL 단위가 먼저 파싱해 공유 중인 GT_DMF0082 문장(PROGRAM_ID 가 그 단위로 기록됨)
        FOR r IN (SELECT SQL_ID || '/' || CHILD_NUMBER K, ELAPSED_TIME, BUFFER_GETS, ROWS_PROCESSED, PROGRAM_LINE#, PROGRAM_ID,
                         SUBSTR(REGEXP_REPLACE(SQL_TEXT,'\s+',' '),1,90) TXT
                    FROM V$SQL WHERE PROGRAM_ID = v_body_id
                       OR (PARSING_SCHEMA_NAME = USER AND SQL_TEXT LIKE '%GT\_DMF0082%' ESCAPE '\')) LOOP
            m(r.K).el := r.ELAPSED_TIME; m(r.K).bg := r.BUFFER_GETS; m(r.K).rp := r.ROWS_PROCESSED;
            m(r.K).line := CASE WHEN r.PROGRAM_ID = v_body_id THEN r.PROGRAM_LINE# END; m(r.K).pid := r.PROGRAM_ID;
            m(r.K).txt := r.TXT;
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

    FUNCTION stage_of(p_line NUMBER) RETURN PLS_INTEGER IS
        i PLS_INTEGER; r PLS_INTEGER;
    BEGIN
        IF p_line IS NULL OR p_line < v_l0 OR p_line > v_l1 THEN RETURN -1; END IF;
        i := stg.FIRST;
        WHILE i IS NOT NULL AND i <= p_line LOOP r := i; i := stg.NEXT(i); END LOOP;
        RETURN NVL(r, 0);
    END;

    PROCEDURE report(p_user VARCHAR2, p_div VARCHAR2, p_sp NUMBER, p_fetch NUMBER) IS
        k VARCHAR2(40); s t_snap; si PLS_INTEGER; tot NUMBER := 0; n NUMBER;
    BEGIN
        cur_stg := stg;
        v_other := 0;
        k := a_sql.FIRST;
        WHILE k IS NOT NULL LOOP
            s := a_sql(k);
            IF b_sql.EXISTS(k) THEN
                s.el := s.el - b_sql(k).el; s.bg := s.bg - b_sql(k).bg; s.rp := s.rp - b_sql(k).rp;
            END IF;
            IF s.el > 0 THEN
                si := stage_of(s.line);
                IF si > 0 THEN
                    cur_stg(si).el := cur_stg(si).el + s.el; cur_stg(si).bg := cur_stg(si).bg + s.bg;
                    cur_stg(si).n := cur_stg(si).n + 1;
                    IF s.el > cur_stg(si).top_el THEN
                        cur_stg(si).top_el := s.el; cur_stg(si).top_k := SUBSTR(k, 1, INSTR(k, '/') - 1);
                        cur_stg(si).top_rows := s.rp; cur_stg(si).top_line := s.line;
                    END IF;
                ELSE
                    v_other := v_other + s.el;
                    IF s.el >= 50000 THEN
                        p('      [단계 미귀속] ' || RPAD(SUBSTR(k, 1, INSTR(k, '/') - 1),15) || LPAD(TO_CHAR(s.el/1e6,'FM990.00'),7)
                          || 's  BG ' || s.bg || '  행 ' || s.rp || '  PROGRAM_ID ' || s.pid || '  ' || SUBSTR(s.txt,1,70));
                    END IF;
                END IF;
                tot := tot + s.el;
            END IF;
            k := a_sql.NEXT(k);
        END LOOP;

        p('  (1) 단계별 소요 (0.05초 이상) — 초 / 비중(SP+fetch 대비) / 문장수 / BG / 최대문장');
        p('      ' || RPAD('시작L',6) || RPAD('단계',58) || LPAD('초',8) || LPAD('비중',7) || LPAD('문장',5) || LPAD('BG',11)
          || '  ' || RPAD('최대문장 SQL_ID',15) || LPAD('초',7) || LPAD('행',9) || '  L');
        si := cur_stg.FIRST;
        WHILE si IS NOT NULL LOOP
            IF cur_stg(si).el >= 50000 THEN
                p('      ' || RPAD(si,6) || RPAD(SUBSTR(cur_stg(si).title,1,56),58)
                  || LPAD(TO_CHAR(cur_stg(si).el/1e6,'FM990.00'),8)
                  || LPAD(TO_CHAR(100*cur_stg(si).el/1e6/NULLIF(p_sp+p_fetch,0),'FM990')||'%',7)
                  || LPAD(cur_stg(si).n,5) || LPAD(cur_stg(si).bg,11) || '  ' || RPAD(NVL(cur_stg(si).top_k,'-'),15)
                  || LPAD(TO_CHAR(cur_stg(si).top_el/1e6,'FM990.00'),7) || LPAD(NVL(cur_stg(si).top_rows,0),9)
                  || '  ' || cur_stg(si).top_line);
            END IF;
            si := cur_stg.NEXT(si);
        END LOOP;
        p('      문장 합 ' || TO_CHAR(tot/1e6,'FM990.00') || 's (미귀속 ' || TO_CHAR(v_other/1e6,'FM990.00')
          || 's = 위 [단계 미귀속]) / SP ' || TO_CHAR(p_sp,'FM990.00') || 's + fetch ' || TO_CHAR(p_fetch,'FM990.00')
          || 's — 차이 = PL/SQL·재귀SQL');

        p('  (3) GTT 적재 행수 (SP 종료 직후 · 0행 제외)');
        FOR g IN (SELECT TABLE_NAME FROM USER_TABLES
                   WHERE TEMPORARY = 'Y' AND (TABLE_NAME LIKE 'GT\_DMF0082%' ESCAPE '\' OR TABLE_NAME IN
                         ('GTT_TEMP_INTO_GROUP_MEASURE','GTT_TEMP_ADMIN_GROUP_MEASURE','GTT_CAL_MONTH_END_DATE','GTT_CAL_WEEK_END_DATE'))
                   ORDER BY TABLE_NAME) LOOP
            EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM SCM_MGR.' || g.TABLE_NAME INTO n;
            IF n > 0 THEN p('      ' || RPAD(g.TABLE_NAME,46) || LPAD(n,10)); END IF;
        END LOOP;
    END;
BEGIN
    SELECT OBJECT_ID INTO v_body_id FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_DMF0082' AND OBJECT_TYPE = 'PACKAGE BODY';
    SELECT MIN(CASE WHEN REGEXP_LIKE(TEXT,'^PROCEDURE P_DMF0082_GET_MAIN_DATA\s*$') THEN LINE END),
           MIN(CASE WHEN REGEXP_LIKE(TEXT,'^PROCEDURE P_DMF0082_POPUP_GET_FUTUREPRICE_INFO') THEN LINE END)
      INTO v_l0, v_l1
      FROM USER_SOURCE WHERE NAME = 'PKG_DMF0082' AND TYPE = 'PACKAGE BODY';
    -- 단계 = '-- =====' 바로 다음 줄의 주석 제목
    stg(v_l0).title := '(진입 · 파라미터 검증)';
    FOR r IN (SELECT LINE, TRIM(REGEXP_REPLACE(TEXT,'^\s*--\s*','')) TITLE
                FROM (SELECT LINE, TEXT, LAG(TEXT) OVER (ORDER BY LINE) PT
                        FROM USER_SOURCE WHERE NAME = 'PKG_DMF0082' AND TYPE = 'PACKAGE BODY'
                         AND LINE BETWEEN v_l0 AND v_l1)
               WHERE REGEXP_LIKE(PT, '^\s*--\s*={10,}') AND REGEXP_LIKE(TEXT, '^\s*--\s*[^=[:space:]]')) LOOP
        stg(r.LINE).title := REPLACE(r.TITLE, CHR(10));
    END LOOP;

    split(c_users, users); split(c_divs, divs);
    p('================================================================================================');
    p(' DMF0082 SP 단계별 분해  DB=' || SYS_CONTEXT('USERENV','DB_NAME') || '  HOST=' || SYS_CONTEXT('USERENV','SERVER_HOST')
      || '  ' || TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') || '  단계 ' || stg.COUNT || '개');
    p(' 인자: group=' || c_group || ' version=' || c_version || ' 기간 ' || v_from || '~' || v_to || ' · 나머지 ALL');
    p('================================================================================================');
    FOR ui IN 1 .. users.COUNT LOOP
        FOR di IN 1 .. divs.COUNT LOOP
            FOR run IN 1 .. c_repeat LOOP
                b_sql.DELETE; a_sql.DELETE;
                snap_sql(b_sql);
                t0 := DBMS_UTILITY.GET_TIME;
                PKG_DMF0082.P_DMF0082_GET_MAIN_DATA(
                    p_division_id => divs(di), p_team_id => 'ALL', p_customer => 'ALL', p_biz_type => 'ALL',
                    p_from_yyyymmdd => v_from, p_to_yyyymmdd => v_to, p_scm_site_id => 'ALL', p_item_id => NULL,
                    p_version_type => c_version, p_qty_yn => 'N', p_created_by => users(ui), p_user_group => c_group,
                    p_plant_site_id => 'ALL', p_project_code => 'ALL', p_owner => 'ALL', p_sender_code => 'ALL',
                    O_RC1 => rc1, O_RC2 => rc2, O_RC3 => rc3, O_RC4 => rc4, O_RC5 => rc5, O_RESULT_CURSOR => rcr);
                t1 := DBMS_UTILITY.GET_TIME;
                v_rows := fetch_count(rc1) || ',' || fetch_count(rc2) || ',' || fetch_count(rc3) || ','
                       || fetch_count(rc4) || ',' || fetch_count(rc5) || ',' || fetch_count(rcr);
                t2 := DBMS_UTILITY.GET_TIME;
                IF run = c_repeat THEN
                    snap_sql(a_sql);
                    p('');
                    p('### user=' || users(ui) || ' div=' || divs(di) || ' run' || run || '  SP ' || TO_CHAR((t1-t0)/100,'FM9990.00')
                      || 's + 결과 fetch ' || TO_CHAR((t2-t1)/100,'FM9990.00') || 's = ' || TO_CHAR((t2-t0)/100,'FM9990.00')
                      || 's   rows[RC1..5,RESULT]=' || v_rows);
                    report(users(ui), divs(di), (t1-t0)/100, (t2-t1)/100);
                ELSE
                    p('    (user=' || users(ui) || ' div=' || divs(di) || ' run' || run || ' SP ' || TO_CHAR((t1-t0)/100,'FM9990.00')
                      || 's + fetch ' || TO_CHAR((t2-t1)/100,'FM9990.00') || 's — 워밍업)');
                END IF;
                ROLLBACK;
            END LOOP;
        END LOOP;
    END LOOP;
    p('');
    p('완료 — C05_SP_STAGE_BREAKDOWN_OUT.txt 회신');
EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    p('!!! 오류: ' || SQLERRM);
    p(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
    RAISE;
END;
/

SPOOL OFF
SET FEEDBACK ON
