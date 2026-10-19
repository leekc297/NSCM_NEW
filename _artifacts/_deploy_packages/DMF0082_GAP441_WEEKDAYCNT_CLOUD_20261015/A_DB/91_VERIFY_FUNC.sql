-- 91 VERIFY_FUNC — [GAP441 2026-10-15] GAP 441 기능 확인 (선택, 전체 F5, 값 입력 없음, 조회만 — 원장 무변경)
-- * 조회 SP 를 Div 81 · Current · 이번 달 1일 ~ +6개월 말일로 호출해 O_RC5 의 WEEK_DAY_CNT 를
--   AS-IS 식(같은 기간 캘린더 ISO_YYYYWW || PARTIAL_WEEK_NAME 일수)과 날짜별로 대조한다.
-- * 기대: F1 … MISMATCH 0 · PASS (조회 1회 — 사내 약 6초, 데이터량에 따라 더 걸릴 수 있음)
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    v_rc1 SYS_REFCURSOR; v_rc2 SYS_REFCURSOR; v_rc3 SYS_REFCURSOR;
    v_rc4 SYS_REFCURSOR; v_rc5 SYS_REFCURSOR; v_res SYS_REFCURSOR;
    v_from VARCHAR2(8) := TO_CHAR(TRUNC(SYSDATE, 'MM'), 'YYYYMMDD');
    v_to   VARCHAR2(8) := TO_CHAR(LAST_DAY(ADD_MONTHS(SYSDATE, 6)), 'YYYYMMDD');
    v_dd   VARCHAR2(8); v_ym VARCHAR2(6); v_f1 VARCHAR2(1); v_f2 VARCHAR2(1);
    v_mdc  NUMBER; v_wdc NUMBER; v_iw VARCHAR2(10);
    v_exp  NUMBER; v_n PLS_INTEGER := 0; v_bad PLS_INTEGER := 0;
BEGIN
    PKG_DMF0082.P_DMF0082_GET_MAIN_DATA('81', 'ALL', 'ALL', 'ALL', v_from, v_to,
        'ALL', '', 'Current', 'N', USER, 'ADMIN', 'ALL', 'ALL', 'ALL', 'ALL',
        v_rc1, v_rc2, v_rc3, v_rc4, v_rc5, v_res);
    LOOP
        FETCH v_rc5 INTO v_dd, v_ym, v_f1, v_f2, v_mdc, v_wdc, v_iw;
        EXIT WHEN v_rc5%NOTFOUND;
        SELECT CNT INTO v_exp
          FROM ( SELECT BASIS_YYYYMMDD, COUNT(*) OVER (PARTITION BY ISO_YYYYWW || PARTIAL_WEEK_NAME) CNT
                   FROM SCM_SYS_CALENDAR_M WHERE BASIS_YYYYMMDD BETWEEN v_from AND v_to )
         WHERE BASIS_YYYYMMDD = v_dd;
        v_n := v_n + 1;
        IF v_wdc <> v_exp THEN
            v_bad := v_bad + 1;
            IF v_bad <= 5 THEN DBMS_OUTPUT.PUT_LINE('  불일치 ' || v_dd || ' RC5=' || v_wdc || ' AS-IS=' || v_exp); END IF;
        END IF;
    END LOOP;
    CLOSE v_rc1; CLOSE v_rc2; CLOSE v_rc3; CLOSE v_rc4; CLOSE v_rc5; CLOSE v_res;
    DBMS_OUTPUT.PUT_LINE('F1 ' || v_from || '~' || v_to || ' RC5 ' || v_n || '일 · MISMATCH ' || v_bad || ' · '
        || CASE WHEN v_n > 0 AND v_bad = 0 THEN 'PASS' ELSE 'FAIL — 회신' END);
END;
/
