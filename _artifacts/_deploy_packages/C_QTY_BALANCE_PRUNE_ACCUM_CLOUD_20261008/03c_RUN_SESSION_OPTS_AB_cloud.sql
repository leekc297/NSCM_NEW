/* =====================================================================================================
 * 03c — 세션 옵션 A/B 측정 (TEMP_UNDO_ENABLED · optimizer_dynamic_sampling): 03b 와 같은 호출(MF_W → SF_W) + 세션 통계(redo·undo·temp) 출력
 *      ⚠ 반드시 **새 접속(세션)** 에서 실행한다. TEMP_UNDO_ENABLED 는 세션에서 임시객체(GTT)를 처음 쓰기 전에만 효력이 생기고, 한 번 GTT 를 쓴 세션은 바꿔도 적용되지 않는다.
 *         SQL Developer: 접속 해제 → 재접속 → 이 파일 F5. (03b 를 돌린 세션에서는 무효)
 *      측정값: 'redo size' · 'undo change vector size' · 'temp space allocated (bytes)' 의 블록 전후 차이 + 회당 초. 결과 동치는 03b 와 같은 방식으로 블록 끝에서 비교.
 *      A(기준) = 03b 를 새 세션에서 1회 · B = 이 파일을 새 세션에서 1회. 둘 다 조용한 창(18 L2 GO)에서.
 *      옵션 자체는 SP 에 넣지 않았다(TEMP_UNDO 는 루트 SP 진입 전 = 잡 세션 시작 시점에만 의미) — 효과가 확인되면 잡 정의/루트 SP 진입점 반영안을 별도 제시.
 * ===================================================================================================== */
SET SERVEROUTPUT ON SIZE UNLIMITED
SET TIMING ON

-- C0. 세션이 깨끗한지 (GTT 미사용 세션이어야 TEMP_UNDO 가 적용됨) + 현재 파라미터 + TEMP 여유
SELECT (SELECT value FROM v$parameter WHERE name = 'temp_undo_enabled') AS temp_undo_now
     , (SELECT value FROM v$parameter WHERE name = 'optimizer_dynamic_sampling') AS dyn_sampling_now
     , (SELECT ROUND(SUM(bytes) / 1073741824, 1) FROM dba_temp_files) AS temp_gb
     , (SELECT ROUND(NVL(SUM(bytes_used), 0) / 1073741824, 1) FROM v$temp_extent_pool) AS temp_used_gb
     , (SELECT COUNT(*) FROM v$tempseg_usage WHERE session_num = SYS_CONTEXT('USERENV', 'SESSIONID')) AS my_temp_segs
  FROM dual;

DECLARE
    v_t0  TIMESTAMP := SYSTIMESTAMP;
    v_t1  TIMESTAMP;
    v_t2  TIMESTAMP;
    TYPE t_num IS TABLE OF NUMBER INDEX BY VARCHAR2(64);
    v_before t_num; v_after t_num;
    v_logon DATE;
    v_tu_before NUMBER; v_tu_after NUMBER;
    v_names SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST('redo size', 'undo change vector size', 'temp space allocated (bytes)', 'physical reads', 'session logical reads', 'CPU used by this session');
    PROCEDURE snap(p IN OUT t_num) IS
    BEGIN
        FOR r IN (SELECT n.name, s.value FROM v$mystat s JOIN v$statname n ON n.statistic# = s.statistic#
                   WHERE n.name IN ('redo size', 'undo change vector size', 'temp space allocated (bytes)', 'physical reads', 'session logical reads', 'CPU used by this session')) LOOP
            p(r.name) := r.value;
        END LOOP;
    END;
BEGIN
    /* ---- 새 접속 게이트: 이 세션이 2분 이내에 접속한 것이 아니면 중단 (TEMP_UNDO 는 GTT 첫 사용 전에만 효력) ---- */
    SELECT logon_time INTO v_logon FROM v$session WHERE sid = SYS_CONTEXT('USERENV', 'SID');
    IF v_logon < SYSDATE - 2 / 1440 THEN
        RAISE_APPLICATION_ERROR(-20001, '새 접속(접속 해제 → 재접속)에서 2분 안에 실행하세요. 현재 세션 접속 시각=' || TO_CHAR(v_logon, 'HH24:MI:SS'));
    END IF;
    /* ---- 세션 옵션 (GTT 첫 사용 전) ---- */
    EXECUTE IMMEDIATE 'ALTER SESSION SET TEMP_UNDO_ENABLED = TRUE';
    EXECUTE IMMEDIATE 'ALTER SESSION SET optimizer_dynamic_sampling = 2';
    DBMS_APPLICATION_INFO.SET_MODULE('RUN_C_OPTS_1464', 'MF_W');
    snap(v_before);
    SELECT NVL(SUM(undoblkcnt), 0) INTO v_tu_before FROM v$tempundostat;
    DBMS_OUTPUT.PUT_LINE('T_START=' || TO_CHAR(v_t0, 'YYYY-MM-DD HH24:MI:SS.FF3') || '  temp_undo=TRUE dyn_sampling=2');

    SCM_MGR.PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE('40', 'MF_W_20261005_V001');
    v_t1 := SYSTIMESTAMP;
    DBMS_OUTPUT.PUT_LINE('MF_W sec=' || TO_CHAR(ROUND(EXTRACT(SECOND FROM (v_t1 - v_t0)) + 60 * EXTRACT(MINUTE FROM (v_t1 - v_t0)) + 3600 * EXTRACT(HOUR FROM (v_t1 - v_t0)), 1)));

    DBMS_APPLICATION_INFO.SET_ACTION('SF_W');
    SCM_MGR.PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE('40', 'SF_W_20261005_V001');
    v_t2 := SYSTIMESTAMP;
    DBMS_OUTPUT.PUT_LINE('SF_W sec=' || TO_CHAR(ROUND(EXTRACT(SECOND FROM (v_t2 - v_t1)) + 60 * EXTRACT(MINUTE FROM (v_t2 - v_t1)) + 3600 * EXTRACT(HOUR FROM (v_t2 - v_t1)), 1)));

    COMMIT;
    snap(v_after);
    SELECT NVL(SUM(undoblkcnt), 0) INTO v_tu_after FROM v$tempundostat;
    DBMS_OUTPUT.PUT_LINE('T_END=' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || '  (committed)');
    FOR i IN 1 .. v_names.COUNT LOOP
        IF v_before.EXISTS(v_names(i)) THEN
            DBMS_OUTPUT.PUT_LINE('STAT ' || RPAD(v_names(i), 30) || ' = ' || TO_CHAR(v_after(v_names(i)) - v_before(v_names(i)), 'FM999,999,999,999'));
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('STAT temp undo blocks (instance delta) = ' || TO_CHAR(v_tu_after - v_tu_before, 'FM999,999,999,999') || '  (0 이면 TEMP_UNDO 미적용 = 새 세션이 아니었음)');
    DBMS_OUTPUT.PUT_LINE('(판정: temp undo blocks > 0 이고 redo size 가 03b 보다 작아야 효과. 03b 와 같은 계측)');
EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('ERROR ' || SQLERRM || ' / ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
    RAISE;
END;
/

-- C9. 결과 동치 (03b 와 동일 기준: 블록 시작 직전 플래시백 대비) — 위 T_START 를 넣고 실행
--     DEFINE 값만 바꾸면 됨. (03b 처럼 블록 안에서 하지 않은 이유: 통계 출력을 분리하기 위함)
/*
DEFINE t_new_start = 'YYYY-MM-DD HH24:MI:SS'
SELECT COUNT(*) AS measure_rows, SUM(CASE WHEN c.n <> p.n OR c.qty <> p.qty OR c.h <> p.h THEN 1 ELSE 0 END) AS diff_rows
  FROM (SELECT VERSION_NO, MEASURE, COUNT(*) n, SUM(QTY) qty, SUM(ORA_HASH(PROJECT_CODE||'|'||SCM_SITE_ID||'|'||ITEM_ID||'|'||DOM_EXP||'|'||FCST_TYPE||'|'||INCOTERMS||'|'||PLANT_SITE_ID||'|'||YYYYMMDD||'|'||TO_CHAR(QTY))) h
          FROM SCM_MGR.DM_PLN_MKT_FCST_C WHERE DIVISION_ID = '40' AND VERSION_NO IN ('MF_W_20261005_V001', 'SF_W_20261005_V001') AND CUTOFF_YYYYMMDD_DATE = TO_DATE('20261005', 'YYYYMMDD') GROUP BY VERSION_NO, MEASURE) c
  JOIN (SELECT VERSION_NO, MEASURE, COUNT(*) n, SUM(QTY) qty, SUM(ORA_HASH(PROJECT_CODE||'|'||SCM_SITE_ID||'|'||ITEM_ID||'|'||DOM_EXP||'|'||FCST_TYPE||'|'||INCOTERMS||'|'||PLANT_SITE_ID||'|'||YYYYMMDD||'|'||TO_CHAR(QTY))) h
          FROM SCM_MGR.DM_PLN_MKT_FCST_C AS OF TIMESTAMP TO_TIMESTAMP('&t_new_start', 'YYYY-MM-DD HH24:MI:SS') WHERE DIVISION_ID = '40' AND VERSION_NO IN ('MF_W_20261005_V001', 'SF_W_20261005_V001') AND CUTOFF_YYYYMMDD_DATE = TO_DATE('20261005', 'YYYYMMDD') GROUP BY VERSION_NO, MEASURE) p
    ON p.VERSION_NO = c.VERSION_NO AND p.MEASURE = c.MEASURE;
*/
