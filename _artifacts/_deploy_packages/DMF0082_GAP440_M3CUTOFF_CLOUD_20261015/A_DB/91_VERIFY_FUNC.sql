-- 91 VERIFY_FUNC — [GAP440 2026-10-15] GAP 440 기능 확인 (선택, 전체 F5, 값 입력 없음, 조회만 — 원장 무변경)
-- * 조회 SP 를 Div 81 · Current · 조회 시작월 3가지(오늘 기준 -3/0/+1개월)로 호출해 O_RC2 첫 행(FE 잠금 경계)을 출력한다.
-- * 기대: 3줄 모두 BOUNDARY = 오늘 월 + 3개월 · JUDGE PASS. (조회 1회당 사내 약 6초 — 데이터량에 따라 더 걸릴 수 있음)
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    v_rc1 SYS_REFCURSOR; v_rc2 SYS_REFCURSOR; v_rc3 SYS_REFCURSOR;
    v_rc4 SYS_REFCURSOR; v_rc5 SYS_REFCURSOR; v_res SYS_REFCURSOR;
    v_ym   VARCHAR2(6); v_end VARCHAR2(8); v_m3 VARCHAR2(8);
    v_from VARCHAR2(8);
    v_exp  VARCHAR2(6) := TO_CHAR(ADD_MONTHS(TRUNC(SYSDATE, 'MM'), 3), 'YYYYMM');
BEGIN
    FOR k IN (SELECT -3 OFS FROM DUAL UNION ALL SELECT 0 FROM DUAL UNION ALL SELECT 1 FROM DUAL) LOOP
        v_from := TO_CHAR(ADD_MONTHS(TRUNC(SYSDATE, 'MM'), k.OFS), 'YYYYMMDD');
        PKG_DMF0082.P_DMF0082_GET_MAIN_DATA('81', 'ALL', 'ALL', 'ALL', v_from, TO_CHAR(ADD_MONTHS(TRUNC(SYSDATE, 'MM'), 6), 'YYYYMMDD'),
            'ALL', '', 'Current', 'N', USER, 'ADMIN', 'ALL', 'ALL', 'ALL', 'ALL',
            v_rc1, v_rc2, v_rc3, v_rc4, v_rc5, v_res);
        FETCH v_rc2 INTO v_ym, v_end, v_m3;
        DBMS_OUTPUT.PUT_LINE('F1 시작 ' || v_from || ' → BOUNDARY ' || SUBSTR(v_m3, 1, 6) || ' (기대 ' || v_exp || ') '
            || CASE WHEN SUBSTR(v_m3, 1, 6) = v_exp THEN 'PASS' ELSE 'FAIL — 회신' END);
        CLOSE v_rc1; CLOSE v_rc2; CLOSE v_rc3; CLOSE v_rc4; CLOSE v_rc5; CLOSE v_res;
    END LOOP;
END;
/
