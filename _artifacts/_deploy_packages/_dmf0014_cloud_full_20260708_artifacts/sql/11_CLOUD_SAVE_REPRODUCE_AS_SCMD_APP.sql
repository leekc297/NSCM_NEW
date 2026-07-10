-- ============================================================================
-- DMF0014 저장 -9994 진짜 원인 확정 — ⭐ BE 와 '동일 계정'(SCMD_APP) 으로 재현
--   앞선 08 은 SCM_MGR 로 실행 → SAVE OK (definer 소유자라 통과).
--   BE 는 SCMD_APP 으로 접속하므로, SCMD_APP 세션에서 실행해야 BE 가 겪는 실오류가 그대로 난다.
--   블록의 EXCEPTION 핸들러가 BE 가 null 로 가린 SQLCODE/SQLERRM 을 직접 출력한다.
--   ⭐ 실행: 클라우드 DB 에 **SCMD_APP** 계정으로 접속.  SET SERVEROUTPUT ON 필수.
--      (SCM_MGR 아님! 반드시 SCMD_APP)
-- ============================================================================
SET SERVEROUTPUT ON SIZE UNLIMITED

DECLARE
  v_rc SYS_REFCURSOR;
BEGIN
  PKG_DMF0014.P_DMF0014_SAVE_CUST_FCST_UPLOAD_DATA(   -- SCMD_APP 시노님으로 호출(미접두)
    'M^M^M^M',
    '81^81^81^81',
    'FCA_US_HLM^FCA_US_HLM^FCA_US_HLM^FCA_US_HLM',
    'A15CR7001^A15CR7001^A15CR7002^A15CR7002',
    'APFCAPHEV-B5-020^APFCAPHEV-B5-020^APFCA48V0-C1-020^APFCA48V0-C1-020',
    'FCA^FCA^FCA^FCA',
    'MPS^MPS^MPS^MPS',
    'E^E^E^E',
    'CUST_FCST^CUST_FCST^CUST_FCST^CUST_FCST',
    'Customer FCST^Customer FCST^Customer FCST^Customer FCST',
    'MI00-P^MI00-P^MI00-P^MI00-P',
    'PACK^PACK^PACK^PACK',
    'A15CR7001^A15CR7001^A15CR7002^A15CR7002',
    'APFCAPHEV-B5-020^APFCAPHEV-B5-020^APFCA48V0-C1-020^APFCA48V0-C1-020',
    '20260706^20260713^20260706^20260713',
    '11^12^13^14',
    'minyonglee1^minyonglee1^minyonglee1^minyonglee1',
    v_rc);
  DBMS_OUTPUT.PUT_LINE('=== SAVE OK (SCMD_APP 로도 정상 — TRUNCATE 가설 기각) ===');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('=== 실오류(BE 가 감춘 진짜 원인) ===');
    DBMS_OUTPUT.PUT_LINE('SQLCODE : ' || SQLCODE);
    DBMS_OUTPUT.PUT_LINE('SQLERRM : ' || SQLERRM);
    DBMS_OUTPUT.PUT_LINE('BACKTRACE:');
    DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
END;
/
-- 예상: SQLERRM 에 ORA-01031(권한부족) 또는 ORA-00942(테이블 없음) + BACKTRACE 6611행(TRUNCATE)
--   => 확정 시 fix = 저장 SP 6611행 'GT_SCFU_RESULTS' → 'SCM_MGR.GT_SCFU_RESULTS' (DMF0020 표준 1:1)
