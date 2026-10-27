-- 10_APPLY — CELL_PROD_SITE_ID '-' → '/' 데이터 일괄 전환 (전체 F5 · 멱등 · 재실행 시 남은 행만 전환)
-- 대상: CELL_PROD_SITE_ID 한 컬럼만 (다른 컬럼 무변경 · 감사 컬럼 LAST_UPDATED_BY/LAST_UPDATE_DATE 도 건드리지 않음)
--       DIVISION_ID 가 c_keep 목록('40','NERP_40') 이 아닌 행 중 CELL_PROD_SITE_ID = '-' 인 행
--       ★ NERP_40 도 전환하려면 아래 c_keep 에서 'NERP_40' 을 지운다 (00/90/99 의 c_keep 도 같이)
-- 방식: 테이블마다 ROWID 청크(DBMS_PARALLEL_EXECUTE 청크 정보만 사용 · 잡 실행 없음)로 나눠 UPDATE → 청크마다 COMMIT
--       (수천만 행 단일 UPDATE 의 UNDO 폭증 회피). 중간에 끊겨도 다시 실행하면 남은 '-' 만 전환.
-- 가드: PK 에 CELL_PROD_SITE_ID 가 있는 테이블은 같은 키 '/' 행 존재 시(PK 충돌) 그 테이블 전체 건너뜀
-- 원복 대비: 전환 전부터 '/' 이던 비-40 행의 ROWID 를 SCM_MGR.ZZ_CELLPROD_SLASH_PRE_20261027 에 1회 기록 (99_ROLLBACK 이 제외)
-- ★ c_dry_run = 'Y' 이면 건수만 세고 아무것도 바꾸지 않는다 (먼저 'Y' 로 1회 실행 권장 → 'N' 으로 바꿔 실행)
-- ⚠ 실행 순서 주의: '-' 로 비교·생성하는 다른 화면/배치(PKG_DMF0021·0035·0048, SCP0039, SCP 엔진 입력, BALANCE 배치 등)는
--   아직 '-' 기준이다. 이 데이터 전환 전에 그 로직 정리 여부를 확인할 것 (CELLPROD_SLASH_20261027/context_dump.txt).
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    c_dry_run CONSTANT VARCHAR2(1)   := 'Y';                                   -- ★ 'Y' = 건수만 / 'N' = 실제 전환
    c_keep    CONSTANT VARCHAR2(200) := ' NOT IN (''40'', ''NERP_40'') ';      -- '-' 유지 사업부
    c_log     CONSTANT VARCHAR2(60)  := 'ZZ_CELLPROD_SLASH_PRE_20261027';
    c_chunk   CONSTANT NUMBER        := 20000;                                 -- 청크 크기(블록)
    TYPE t_list IS TABLE OF VARCHAR2(128);
    c_tabs t_list := t_list('DM_PLN_CFM_MKT_DEMAND_PLAN', 'DM_PLN_CFM_MKT_DEMAND_PLAN_C', 'DM_PLN_CFM_MKT_DEMAND_PLAN_H',
                            'DM_PLN_CFM_SELLING_PRICE', 'DM_PLN_CFM_SELLING_PRICE_C', 'DM_PLN_CFM_SELLING_PRICE_H',
                            'DM_PLN_DEMANDID_PEGGING', 'DM_PLN_DEMAND_CHANGE_STATUS',
                            'DM_PLN_MKT_FCST_RESULT', 'DM_PLN_MKT_FCST_RESULT_C', 'DM_PLN_NET_DEMAND',
                            'DM_PLN_SALES_PLAN', 'DM_PLN_SALES_PLAN_C', 'DM_PLN_SALES_PLAN_H',
                            'DM_PLN_SALES_PLAN_RESULT', 'DM_PLN_SALES_PLAN_RESULT_C', 'SCP_OPMZ_DMD_ADJ');
    v_n      NUMBER;
    v_pk     VARCHAR2(4000);
    v_on     VARCHAR2(4000);
    v_task   VARCHAR2(128);
    v_done   NUMBER;
    v_all    NUMBER := 0;
    v_t0     DATE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('== CELL_PROD_SITE_ID ''-'' → ''/'' ' || CASE c_dry_run WHEN 'Y' THEN '[DRY RUN — 변경 없음]' ELSE '[실행]' END
                         || ' · ' || SYS_CONTEXT('USERENV','DB_NAME') || ' · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
    IF c_dry_run = 'N' THEN
        SELECT COUNT(*) INTO v_n FROM USER_TABLES WHERE TABLE_NAME = c_log;
        IF v_n = 0 THEN
            EXECUTE IMMEDIATE 'CREATE TABLE SCM_MGR.' || c_log || ' (TABLE_NAME VARCHAR2(128) NOT NULL, RID ROWID NOT NULL, LOGGED_AT DATE DEFAULT SYSDATE NOT NULL)';
        END IF;
    END IF;

    FOR i IN 1 .. c_tabs.COUNT LOOP
        SELECT COUNT(*) INTO v_n FROM USER_TABLES WHERE TABLE_NAME = c_tabs(i);
        IF v_n = 0 THEN
            DBMS_OUTPUT.PUT_LINE('   ' || RPAD(c_tabs(i), 32) || ' 이 DB 에 없음 — 건너뜀');
            CONTINUE;
        END IF;
        -- PK 충돌 가드
        v_pk := NULL; v_on := NULL;
        FOR k IN (SELECT CC.COLUMN_NAME FROM USER_CONSTRAINTS C JOIN USER_CONS_COLUMNS CC ON CC.CONSTRAINT_NAME = C.CONSTRAINT_NAME
                   WHERE C.TABLE_NAME = c_tabs(i) AND C.CONSTRAINT_TYPE = 'P' ORDER BY CC.POSITION) LOOP
            v_pk := v_pk || k.COLUMN_NAME || ',';
            IF k.COLUMN_NAME <> 'CELL_PROD_SITE_ID' THEN v_on := v_on || ' AND B.' || k.COLUMN_NAME || ' = A.' || k.COLUMN_NAME; END IF;
        END LOOP;
        IF INSTR(',' || v_pk, ',CELL_PROD_SITE_ID,') > 0 THEN
            EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM SCM_MGR.' || c_tabs(i) || ' A WHERE A.CELL_PROD_SITE_ID = ''-'' AND A.DIVISION_ID' || c_keep
                           || ' AND EXISTS (SELECT 1 FROM SCM_MGR.' || c_tabs(i) || ' B WHERE B.CELL_PROD_SITE_ID = ''/''' || v_on || ')' INTO v_n;
            IF v_n > 0 THEN
                DBMS_OUTPUT.PUT_LINE('   ★ ' || RPAD(c_tabs(i), 30) || ' PK 충돌 ' || v_n || '건 — 이 테이블 건너뜀 (회신)');
                CONTINUE;
            END IF;
        END IF;

        EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM SCM_MGR.' || c_tabs(i) || ' WHERE CELL_PROD_SITE_ID = ''-'' AND DIVISION_ID' || c_keep INTO v_n;
        IF c_dry_run = 'Y' OR v_n = 0 THEN
            DBMS_OUTPUT.PUT_LINE('   ' || RPAD(c_tabs(i), 32) || ' 전환 대상 ' || LPAD(TO_CHAR(v_n, 'FM999,999,999'), 12) || CASE WHEN v_n = 0 THEN '  (없음)' END);
            CONTINUE;
        END IF;

        -- 원복 대비: 전환 전부터 '/' 이던 비-40 행 ROWID (테이블당 1회)
        EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM SCM_MGR.' || c_log || ' WHERE TABLE_NAME = :t' INTO v_done USING c_tabs(i);
        IF v_done = 0 THEN
            EXECUTE IMMEDIATE 'INSERT INTO SCM_MGR.' || c_log || ' (TABLE_NAME, RID) SELECT :t, ROWID FROM SCM_MGR.' || c_tabs(i)
                           || ' WHERE CELL_PROD_SITE_ID = ''/'' AND DIVISION_ID' || c_keep USING c_tabs(i);
            EXECUTE IMMEDIATE 'INSERT INTO SCM_MGR.' || c_log || ' (TABLE_NAME, RID) VALUES (:t, CHARTOROWID(''AAAAAAAAAAAAAAAAAA''))' USING c_tabs(i);   -- 기록 완료 표식(행 0 테이블 구분)
            COMMIT;
        END IF;

        -- ROWID 청크 단위 전환
        v_t0   := SYSDATE;
        v_done := 0;
        v_task := 'CELLPROD_' || SUBSTR(c_tabs(i), 1, 40) || '_' || TO_CHAR(SYSDATE, 'HH24MISS');
        DBMS_PARALLEL_EXECUTE.CREATE_TASK(v_task);
        DBMS_PARALLEL_EXECUTE.CREATE_CHUNKS_BY_ROWID(v_task, 'SCM_MGR', c_tabs(i), FALSE, c_chunk);
        FOR ch IN (SELECT START_ROWID, END_ROWID FROM USER_PARALLEL_EXECUTE_CHUNKS WHERE TASK_NAME = v_task ORDER BY CHUNK_ID) LOOP
            EXECUTE IMMEDIATE 'UPDATE SCM_MGR.' || c_tabs(i) || ' SET CELL_PROD_SITE_ID = ''/''
                                WHERE ROWID BETWEEN :s AND :e AND CELL_PROD_SITE_ID = ''-'' AND DIVISION_ID' || c_keep
                USING ch.START_ROWID, ch.END_ROWID;
            v_done := v_done + SQL%ROWCOUNT;
            COMMIT;
        END LOOP;
        DBMS_PARALLEL_EXECUTE.DROP_TASK(v_task);
        v_all := v_all + v_done;
        DBMS_OUTPUT.PUT_LINE('   ' || RPAD(c_tabs(i), 32) || ' 전환 ' || LPAD(TO_CHAR(v_done, 'FM999,999,999'), 12)
                             || ' / 대상 ' || TO_CHAR(v_n, 'FM999,999,999') || ' · ' || ROUND((SYSDATE - v_t0) * 86400) || '초');
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('== 완료 ' || CASE c_dry_run WHEN 'Y' THEN '(DRY RUN)' ELSE '전환 합계 ' || TO_CHAR(v_all, 'FM999,999,999') END || ' · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
