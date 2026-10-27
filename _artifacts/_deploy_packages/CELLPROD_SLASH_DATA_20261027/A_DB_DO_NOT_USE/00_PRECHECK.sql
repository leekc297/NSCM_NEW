-- 00_PRECHECK — CELL_PROD_SITE_ID '-' → '/' 데이터 전환 사전 확인 (조회 전용 · 전체 F5 · 값 입력 없음)
-- 대상: CELL_PROD_SITE_ID 한 컬럼만. DIVISION_ID 가 '40' · 'NERP_40' 인 행은 '-' 유지 (40 = 사용자가 고른 Common 값).
-- * [P0] 접속 DB
-- * [P1] 대상 테이블별 · 사업부별 전환 대상('-') 건수 / 이미 '/' 인 건수
-- * [P2] PK 충돌 — 같은 키에 '/' 행이 이미 있는 '-' 행 (있으면 10 이 그 테이블을 건너뛴다)
-- * [P3] 목록 밖 테이블 중 CELL_PROD_SITE_ID + DIVISION_ID 가 있고 전환 대상이 있는 테이블 (있으면 회신 — 목록 추가 검토)
SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 220 PAGESIZE 500
SET DEFINE OFF
SELECT 'P0' CHK, SYS_CONTEXT('USERENV','DB_NAME') DB_NAME, SYS_CONTEXT('USERENV','SERVER_HOST') HOST, USER, TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') NOW FROM DUAL;
DECLARE
    TYPE t_list IS TABLE OF VARCHAR2(128);
    c_tabs t_list := t_list('DM_PLN_CFM_MKT_DEMAND_PLAN', 'DM_PLN_CFM_MKT_DEMAND_PLAN_C', 'DM_PLN_CFM_MKT_DEMAND_PLAN_H',
                            'DM_PLN_CFM_SELLING_PRICE', 'DM_PLN_CFM_SELLING_PRICE_C', 'DM_PLN_CFM_SELLING_PRICE_H',
                            'DM_PLN_DEMANDID_PEGGING', 'DM_PLN_DEMAND_CHANGE_STATUS',
                            'DM_PLN_MKT_FCST_RESULT', 'DM_PLN_MKT_FCST_RESULT_C', 'DM_PLN_NET_DEMAND',
                            'DM_PLN_SALES_PLAN', 'DM_PLN_SALES_PLAN_C', 'DM_PLN_SALES_PLAN_H',
                            'DM_PLN_SALES_PLAN_RESULT', 'DM_PLN_SALES_PLAN_RESULT_C', 'SCP_OPMZ_DMD_ADJ');
    c_keep  CONSTANT VARCHAR2(200) := ' NOT IN (''40'', ''NERP_40'') ';   -- '-' 유지 사업부
    v_n     NUMBER;
    v_pk    VARCHAR2(4000);
    v_on    VARCHAR2(4000);
    v_tot   NUMBER := 0;
    rc      SYS_REFCURSOR;
    v_div   VARCHAR2(100); v_dash NUMBER; v_slash NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('== P1 전환 대상 (DIVISION_ID' || c_keep || ' AND CELL_PROD_SITE_ID = ''-'')');
    FOR i IN 1 .. c_tabs.COUNT LOOP
        SELECT COUNT(*) INTO v_n FROM USER_TABLES WHERE TABLE_NAME = c_tabs(i);
        IF v_n = 0 THEN
            DBMS_OUTPUT.PUT_LINE('   ' || RPAD(c_tabs(i), 32) || ' (이 DB 에 없음 — 건너뜀)');
            CONTINUE;
        END IF;
        OPEN rc FOR 'SELECT DIVISION_ID, SUM(CASE WHEN CELL_PROD_SITE_ID = ''-'' THEN 1 ELSE 0 END), SUM(CASE WHEN CELL_PROD_SITE_ID = ''/'' THEN 1 ELSE 0 END)
                       FROM SCM_MGR.' || c_tabs(i) || ' WHERE DIVISION_ID' || c_keep || ' GROUP BY DIVISION_ID ORDER BY 1';
        LOOP
            FETCH rc INTO v_div, v_dash, v_slash; EXIT WHEN rc%NOTFOUND;
            IF v_dash + v_slash > 0 THEN
                DBMS_OUTPUT.PUT_LINE('   ' || RPAD(c_tabs(i), 32) || ' div ' || RPAD(v_div, 8) || ' 전환 대상 ''-'' ' || LPAD(TO_CHAR(v_dash, 'FM999,999,999'), 12)
                                     || ' · 기존 ''/'' ' || LPAD(TO_CHAR(v_slash, 'FM999,999,999'), 10));
                v_tot := v_tot + v_dash;
            END IF;
        END LOOP;
        CLOSE rc;
        -- P2 PK 충돌
        v_pk := NULL; v_on := NULL;
        FOR k IN (SELECT CC.COLUMN_NAME FROM USER_CONSTRAINTS C JOIN USER_CONS_COLUMNS CC ON CC.CONSTRAINT_NAME = C.CONSTRAINT_NAME
                   WHERE C.TABLE_NAME = c_tabs(i) AND C.CONSTRAINT_TYPE = 'P' ORDER BY CC.POSITION) LOOP
            v_pk := v_pk || k.COLUMN_NAME || ',';
            IF k.COLUMN_NAME <> 'CELL_PROD_SITE_ID' THEN v_on := v_on || ' AND B.' || k.COLUMN_NAME || ' = A.' || k.COLUMN_NAME; END IF;
        END LOOP;
        IF INSTR(',' || v_pk, ',CELL_PROD_SITE_ID,') > 0 THEN
            EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM SCM_MGR.' || c_tabs(i) || ' A WHERE A.CELL_PROD_SITE_ID = ''-'' AND A.DIVISION_ID' || c_keep
                           || ' AND EXISTS (SELECT 1 FROM SCM_MGR.' || c_tabs(i) || ' B WHERE B.CELL_PROD_SITE_ID = ''/''' || v_on || ')' INTO v_n;
            DBMS_OUTPUT.PUT_LINE('   ' || RPAD(c_tabs(i), 32) || ' P2 PK 충돌 ' || v_n || CASE WHEN v_n > 0 THEN '  ← 10 이 이 테이블을 건너뜀 · 회신' ELSE '' END);
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('   합계 전환 대상 ' || TO_CHAR(v_tot, 'FM999,999,999'));

    DBMS_OUTPUT.PUT_LINE('== P3 목록 밖 테이블 (CELL_PROD_SITE_ID + DIVISION_ID 보유 · 백업/스냅샷/보관 제외)');
    FOR t IN (SELECT C.TABLE_NAME FROM USER_TAB_COLUMNS C JOIN USER_TABLES T ON T.TABLE_NAME = C.TABLE_NAME AND T.TEMPORARY = 'N'
               WHERE C.COLUMN_NAME = 'CELL_PROD_SITE_ID'
                 AND EXISTS (SELECT 1 FROM USER_TAB_COLUMNS D WHERE D.TABLE_NAME = C.TABLE_NAME AND D.COLUMN_NAME = 'DIVISION_ID')
                 AND NOT REGEXP_LIKE(C.TABLE_NAME, '(BAK|_SNAPSHOT|_KEEP|_TMP|_TEST|^CMP[0-9]\$)')
               ORDER BY 1) LOOP
        v_n := 0;
        FOR i IN 1 .. c_tabs.COUNT LOOP IF c_tabs(i) = t.TABLE_NAME THEN v_n := 1; END IF; END LOOP;
        IF v_n = 0 THEN
            EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM SCM_MGR.' || t.TABLE_NAME || ' WHERE CELL_PROD_SITE_ID = ''-'' AND DIVISION_ID' || c_keep INTO v_n;
            IF v_n > 0 THEN DBMS_OUTPUT.PUT_LINE('   ★ ' || RPAD(t.TABLE_NAME, 32) || ' 전환 대상 ' || v_n || ' — 목록에 없음 · 회신'); END IF;
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('   (★ 없으면 목록 밖 대상 없음)');
END;
/
