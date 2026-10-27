-- 90_VERIFY — 전환 결과 확인 (조회 전용 · 전체 F5)
-- 기대: 각 테이블 비-40 '-' 잔존 0 · 40/NERP_40 의 '-' 건수는 00 과 동일
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    c_keep CONSTANT VARCHAR2(200) := ' NOT IN (''40'', ''NERP_40'') ';
    TYPE t_list IS TABLE OF VARCHAR2(128);
    c_tabs t_list := t_list('DM_PLN_CFM_MKT_DEMAND_PLAN', 'DM_PLN_CFM_MKT_DEMAND_PLAN_C', 'DM_PLN_CFM_MKT_DEMAND_PLAN_H',
                            'DM_PLN_CFM_SELLING_PRICE', 'DM_PLN_CFM_SELLING_PRICE_C', 'DM_PLN_CFM_SELLING_PRICE_H',
                            'DM_PLN_DEMANDID_PEGGING', 'DM_PLN_DEMAND_CHANGE_STATUS',
                            'DM_PLN_MKT_FCST_RESULT', 'DM_PLN_MKT_FCST_RESULT_C', 'DM_PLN_NET_DEMAND',
                            'DM_PLN_SALES_PLAN', 'DM_PLN_SALES_PLAN_C', 'DM_PLN_SALES_PLAN_H',
                            'DM_PLN_SALES_PLAN_RESULT', 'DM_PLN_SALES_PLAN_RESULT_C', 'SCP_OPMZ_DMD_ADJ');
    v_n NUMBER; v_rest NUMBER; v_keep NUMBER; v_fail NUMBER := 0;
BEGIN
    FOR i IN 1 .. c_tabs.COUNT LOOP
        SELECT COUNT(*) INTO v_n FROM USER_TABLES WHERE TABLE_NAME = c_tabs(i);
        CONTINUE WHEN v_n = 0;
        EXECUTE IMMEDIATE 'SELECT SUM(CASE WHEN DIVISION_ID' || c_keep || ' THEN 1 ELSE 0 END), SUM(CASE WHEN DIVISION_ID' || c_keep || ' THEN 0 ELSE 1 END)
                             FROM SCM_MGR.' || c_tabs(i) || ' WHERE CELL_PROD_SITE_ID = ''-''' INTO v_rest, v_keep;
        v_fail := v_fail + CASE WHEN NVL(v_rest, 0) > 0 THEN 1 ELSE 0 END;
        DBMS_OUTPUT.PUT_LINE(CASE WHEN NVL(v_rest, 0) = 0 THEN 'PASS ' ELSE 'FAIL ' END || RPAD(c_tabs(i), 32)
                             || ' 비-40 ''-'' 잔존 ' || NVL(v_rest, 0) || ' · 40계열 ''-'' 유지 ' || TO_CHAR(NVL(v_keep, 0), 'FM999,999,999'));
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('RESULT ' || CASE WHEN v_fail = 0 THEN 'PASS' ELSE 'FAIL ' || v_fail || ' (10 재실행 — 남은 행만 전환)' END);
END;
/
