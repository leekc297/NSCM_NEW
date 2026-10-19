/* =====================================================================================================
 * 03b — 신판 실행 + 결과 동치 비교 (01 적용 · 02 V1~V3 통과 **후**에 1회). 그대로 F5 로 실행한다. 입력값 없음.
 *      1) MF_W → SF_W 를 신판으로 실행하고 COMMIT (모듈명 RUN_C_NEW_1464)
 *      2) 같은 블록 안에서 "현재 상태" 와 "이 블록 시작 직전(= 구판 03a 결과)" 플래시백을 측정값별 건수·QTY 합·키 해시(감사컬럼 제외)로 비교해 출력
 *      기대: 마지막 줄 DIFF_ROWS=0. 0 이 아니면 측정값 행이 'DIFF' 로 먼저 출력된다.
 *      STAT(redo/undo/temp/physical/logical/CPU) 를 블록 전후 차이로 출력 — 03c(세션 옵션 A/B) 와 같은 계측. 18 L2 GO 일 때, 새 접속에서 실행.
 *      ⚠ 03a 와 연속으로(수 분 안에) 실행해야 입력 데이터가 같다. 플래시백은 UNDO 보존 시간 안에서만 가능하다.
 * ===================================================================================================== */
SET SERVEROUTPUT ON SIZE UNLIMITED
SET TIMING ON

DECLARE
    v_t0  TIMESTAMP := SYSTIMESTAMP;   -- 신판 시작 직전 = 구판 결과 상태 (플래시백 기준)
    v_t1  TIMESTAMP;
    v_t2  TIMESTAMP;
    v_diff_rows NUMBER := 0;
    v_rows      NUMBER := 0;
    TYPE t_cur IS REF CURSOR;
    c   t_cur;
    v_tbl VARCHAR2(20); v_ver VARCHAR2(40); v_msr VARCHAR2(60);
    v_n_new NUMBER; v_n_old NUMBER; v_dn NUMBER; v_dq NUMBER; v_dh NUMBER;
    v_sql CLOB;
    TYPE t_num IS TABLE OF NUMBER INDEX BY VARCHAR2(64);
    v_before t_num; v_after t_num;
    v_names SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST('redo size', 'undo change vector size', 'temp space allocated (bytes)', 'physical reads', 'session logical reads', 'CPU used by this session');
    PROCEDURE snap(p IN OUT t_num) IS
    BEGIN
        FOR r IN (SELECT n.name, s.value FROM v$mystat s JOIN v$statname n ON n.statistic# = s.statistic#
                   WHERE n.name IN ('redo size', 'undo change vector size', 'temp space allocated (bytes)', 'physical reads', 'session logical reads', 'CPU used by this session')) LOOP
            p(r.name) := r.value;
        END LOOP;
    END;
BEGIN
    snap(v_before);
    DBMS_APPLICATION_INFO.SET_MODULE('RUN_C_NEW_1464', 'MF_W');
    DBMS_OUTPUT.PUT_LINE('T_START=' || TO_CHAR(v_t0, 'YYYY-MM-DD HH24:MI:SS.FF3'));

    SCM_MGR.PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE('40', 'MF_W_20261005_V001');
    v_t1 := SYSTIMESTAMP;
    DBMS_OUTPUT.PUT_LINE('MF_W sec=' || TO_CHAR(ROUND(EXTRACT(SECOND FROM (v_t1 - v_t0)) + 60 * EXTRACT(MINUTE FROM (v_t1 - v_t0)) + 3600 * EXTRACT(HOUR FROM (v_t1 - v_t0)), 1)));

    DBMS_APPLICATION_INFO.SET_ACTION('SF_W');
    SCM_MGR.PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE('40', 'SF_W_20261005_V001');
    v_t2 := SYSTIMESTAMP;
    DBMS_OUTPUT.PUT_LINE('SF_W sec=' || TO_CHAR(ROUND(EXTRACT(SECOND FROM (v_t2 - v_t1)) + 60 * EXTRACT(MINUTE FROM (v_t2 - v_t1)) + 3600 * EXTRACT(HOUR FROM (v_t2 - v_t1)), 1)));

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('T_END=' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || '  (NEW run committed)');
    snap(v_after);
    FOR i IN 1 .. v_names.COUNT LOOP
        IF v_before.EXISTS(v_names(i)) THEN
            DBMS_OUTPUT.PUT_LINE('STAT ' || RPAD(v_names(i), 30) || ' = ' || TO_CHAR(v_after(v_names(i)) - v_before(v_names(i)), 'FM999,999,999,999'));
        END IF;
    END LOOP;

    /* ---- 결과 동치: 현재(신판) vs AS OF v_t0(구판) ---- */
    DBMS_APPLICATION_INFO.SET_ACTION('COMPARE');
    v_sql := q'[
WITH cur AS (
    SELECT 'MKT_FCST_C' AS tbl, VERSION_NO, MEASURE, COUNT(*) AS n, SUM(QTY) AS qty
         , SUM(ORA_HASH(PROJECT_CODE || '|' || SCM_SITE_ID || '|' || ITEM_ID || '|' || DOM_EXP || '|' || FCST_TYPE || '|' || INCOTERMS || '|' || PLANT_SITE_ID || '|' || YYYYMMDD || '|' || TO_CHAR(QTY))) AS h
      FROM SCM_MGR.DM_PLN_MKT_FCST_C
     WHERE DIVISION_ID = '40' AND VERSION_NO IN ('MF_W_20261005_V001', 'SF_W_20261005_V001') AND CUTOFF_YYYYMMDD_DATE = TO_DATE('20261005', 'YYYYMMDD')
     GROUP BY VERSION_NO, MEASURE
    UNION ALL
    SELECT 'CFM_C', VERSION_NO, MEASURE, COUNT(*), SUM(QTY)
         , SUM(ORA_HASH(PROJECT_CODE || '|' || END_CUSTOMER || '|' || SCM_SITE_ID || '|' || ITEM_ID || '|' || DOM_EXP || '|' || FCST_TYPE || '|' || INCOTERMS || '|' || PLANT_SITE_ID || '|' || NVL(CELL_PROD_SITE_ID, '-') || '|' || YYYYMMDD || '|' || TO_CHAR(QTY)))
      FROM SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN_C
     WHERE DIVISION_ID = '40' AND VERSION_NO IN ('MF_W_20261005_V001', 'SF_W_20261005_V001') AND CUTOFF_YYYYMMDD_DATE = TO_DATE('20261005', 'YYYYMMDD')
     GROUP BY VERSION_NO, MEASURE)
, prv AS (
    SELECT 'MKT_FCST_C' AS tbl, VERSION_NO, MEASURE, COUNT(*) AS n, SUM(QTY) AS qty
         , SUM(ORA_HASH(PROJECT_CODE || '|' || SCM_SITE_ID || '|' || ITEM_ID || '|' || DOM_EXP || '|' || FCST_TYPE || '|' || INCOTERMS || '|' || PLANT_SITE_ID || '|' || YYYYMMDD || '|' || TO_CHAR(QTY))) AS h
      FROM SCM_MGR.DM_PLN_MKT_FCST_C AS OF TIMESTAMP :t0
     WHERE DIVISION_ID = '40' AND VERSION_NO IN ('MF_W_20261005_V001', 'SF_W_20261005_V001') AND CUTOFF_YYYYMMDD_DATE = TO_DATE('20261005', 'YYYYMMDD')
     GROUP BY VERSION_NO, MEASURE
    UNION ALL
    SELECT 'CFM_C', VERSION_NO, MEASURE, COUNT(*), SUM(QTY)
         , SUM(ORA_HASH(PROJECT_CODE || '|' || END_CUSTOMER || '|' || SCM_SITE_ID || '|' || ITEM_ID || '|' || DOM_EXP || '|' || FCST_TYPE || '|' || INCOTERMS || '|' || PLANT_SITE_ID || '|' || NVL(CELL_PROD_SITE_ID, '-') || '|' || YYYYMMDD || '|' || TO_CHAR(QTY)))
      FROM SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN_C AS OF TIMESTAMP :t0
     WHERE DIVISION_ID = '40' AND VERSION_NO IN ('MF_W_20261005_V001', 'SF_W_20261005_V001') AND CUTOFF_YYYYMMDD_DATE = TO_DATE('20261005', 'YYYYMMDD')
     GROUP BY VERSION_NO, MEASURE)
SELECT NVL(c.tbl, p.tbl), NVL(c.VERSION_NO, p.VERSION_NO), NVL(c.MEASURE, p.MEASURE)
     , c.n, p.n, NVL(c.n, 0) - NVL(p.n, 0), NVL(c.qty, 0) - NVL(p.qty, 0), NVL(c.h, 0) - NVL(p.h, 0)
  FROM cur c FULL OUTER JOIN prv p ON p.tbl = c.tbl AND p.VERSION_NO = c.VERSION_NO AND p.MEASURE = c.MEASURE
 ORDER BY CASE WHEN NVL(c.n, 0) <> NVL(p.n, 0) OR NVL(c.qty, 0) <> NVL(p.qty, 0) OR NVL(c.h, 0) <> NVL(p.h, 0) THEN 0 ELSE 1 END, 1, 2, 3]';
    OPEN c FOR v_sql USING v_t0, v_t0;
    DBMS_OUTPUT.PUT_LINE('--- COMPARE (now=NEW vs AS OF ' || TO_CHAR(v_t0, 'HH24:MI:SS') || '=OLD) : tbl | version | measure | n_new | n_old | diff_n | diff_qty | diff_hash');
    LOOP
        FETCH c INTO v_tbl, v_ver, v_msr, v_n_new, v_n_old, v_dn, v_dq, v_dh;
        EXIT WHEN c%NOTFOUND;
        v_rows := v_rows + 1;
        IF v_dn <> 0 OR v_dq <> 0 OR v_dh <> 0 THEN v_diff_rows := v_diff_rows + 1; END IF;
        DBMS_OUTPUT.PUT_LINE(CASE WHEN v_dn <> 0 OR v_dq <> 0 OR v_dh <> 0 THEN 'DIFF ' ELSE 'same ' END
            || RPAD(v_tbl, 11) || '| ' || RPAD(v_ver, 19) || '| ' || RPAD(v_msr, 16) || '| ' || LPAD(NVL(TO_CHAR(v_n_new), '-'), 7) || ' | ' || LPAD(NVL(TO_CHAR(v_n_old), '-'), 7)
            || ' | ' || LPAD(TO_CHAR(v_dn), 6) || ' | ' || LPAD(TO_CHAR(v_dq), 14) || ' | ' || TO_CHAR(v_dh));
    END LOOP;
    CLOSE c;
    DBMS_OUTPUT.PUT_LINE('MEASURE_ROWS=' || v_rows || '  DIFF_ROWS=' || v_diff_rows || CASE WHEN v_diff_rows = 0 THEN '  => EQUIVALENT' ELSE '  => NOT EQUIVALENT (검토 필요)' END);
EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('ERROR ' || SQLERRM || ' / ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
    RAISE;
END;
/
