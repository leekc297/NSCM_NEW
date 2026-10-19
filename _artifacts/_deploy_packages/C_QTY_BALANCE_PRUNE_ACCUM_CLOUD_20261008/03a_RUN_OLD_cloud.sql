/* =====================================================================================================
 * 03a — 구판 실행 (01 적용 **전**에 1회). 그대로 F5 로 실행한다.
 *      C_QTY_BALANCE 만 직접 호출(MF_W → SF_W) — 루트·메일 분기 없음(제외시간 무관, 메일 0). 00시 롤링이 매일 다시 쓰는 버전을 다시 쓸 뿐이다.
 *      출력: T_START / MF_W sec / SF_W sec / T_END. 오류 시 ROLLBACK 후 예외 전파.
 *      모듈명 RUN_C_OLD_1464 로 ASH 가 분리된다(03 R5).
 * ===================================================================================================== */
SET SERVEROUTPUT ON SIZE UNLIMITED
SET TIMING ON

DECLARE
    v_t0  TIMESTAMP := SYSTIMESTAMP;
    v_t1  TIMESTAMP;
    v_t2  TIMESTAMP;
BEGIN
    DBMS_APPLICATION_INFO.SET_MODULE('RUN_C_OLD_1464', 'MF_W');
    DBMS_OUTPUT.PUT_LINE('T_START=' || TO_CHAR(v_t0, 'YYYY-MM-DD HH24:MI:SS.FF3'));

    SCM_MGR.PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE('40', 'MF_W_20261005_V001');
    v_t1 := SYSTIMESTAMP;
    DBMS_OUTPUT.PUT_LINE('MF_W sec=' || TO_CHAR(ROUND(EXTRACT(SECOND FROM (v_t1 - v_t0)) + 60 * EXTRACT(MINUTE FROM (v_t1 - v_t0)) + 3600 * EXTRACT(HOUR FROM (v_t1 - v_t0)), 1)));

    DBMS_APPLICATION_INFO.SET_ACTION('SF_W');
    SCM_MGR.PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE('40', 'SF_W_20261005_V001');
    v_t2 := SYSTIMESTAMP;
    DBMS_OUTPUT.PUT_LINE('SF_W sec=' || TO_CHAR(ROUND(EXTRACT(SECOND FROM (v_t2 - v_t1)) + 60 * EXTRACT(MINUTE FROM (v_t2 - v_t1)) + 3600 * EXTRACT(HOUR FROM (v_t2 - v_t1)), 1)));

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('T_END=' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || '  (OLD run committed)');
EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('ERROR ' || SQLERRM || ' / ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
    RAISE;
END;
/
