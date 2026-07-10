-- ============================================================================
-- DMF0014 클라우드 저장 -9994 실오류 재현 (BE 우회 → 진짜 ORA-xxxxx 노출)
--   전제: 06/07 = 권한·시노님·API·PROC_M·PKG body(마커 일치) 전부 정상.
--         FE payload 도 정상(createdByList 포함 17키 x 4행 '^'-조인).
--   => -9994 / "InvocationTargetException: null" 은 BE 가 진짜 원인을 가린 래퍼.
--      아래는 화면에서 실패한 그 payload(4행) 그대로 SP 를 직접 호출 → EXCEPTION 으로 실오류 출력.
--   실행: 클라우드 DB, SCM_MGR 접속.  SET SERVEROUTPUT ON 필수.
-- ============================================================================
SET SERVEROUTPUT ON SIZE UNLIMITED

DECLARE
  v_rc SYS_REFCURSOR;
BEGIN
  SCM_MGR.PKG_DMF0014.P_DMF0014_SAVE_CUST_FCST_UPLOAD_DATA(
    'M^M^M^M',                                                                          -- P_ACTIVE_FLAG
    '81^81^81^81',                                                                      -- P_DIVISION_ID
    'FCA_US_HLM^FCA_US_HLM^FCA_US_HLM^FCA_US_HLM',                                       -- P_SCM_SITE_ID
    'A15CR7001^A15CR7001^A15CR7002^A15CR7002',                                           -- P_CUSTOMER_PROJECT_CODE
    'APFCAPHEV-B5-020^APFCAPHEV-B5-020^APFCA48V0-C1-020^APFCA48V0-C1-020',               -- P_CUSTOMER_MODEL
    'FCA^FCA^FCA^FCA',                                                                   -- P_INCOTERMS
    'MPS^MPS^MPS^MPS',                                                                   -- P_FCST_TYPE
    'E^E^E^E',                                                                           -- P_DOM_EXP
    'CUST_FCST^CUST_FCST^CUST_FCST^CUST_FCST',                                           -- P_MEASURE_GROUP
    'Customer FCST^Customer FCST^Customer FCST^Customer FCST',                           -- P_MEASURE
    'MI00-P^MI00-P^MI00-P^MI00-P',                                                       -- P_PLANT_SITE_ID
    'PACK^PACK^PACK^PACK',                                                               -- P_UPLOAD_UOM
    'A15CR7001^A15CR7001^A15CR7002^A15CR7002',                                           -- P_PROJECT_CODE
    'APFCAPHEV-B5-020^APFCAPHEV-B5-020^APFCA48V0-C1-020^APFCA48V0-C1-020',               -- P_ITEM_ID
    '20260706^20260713^20260706^20260713',                                              -- P_YYYYMMDD
    '1^2^3^4',                                                                           -- P_QTY
    'minyonglee1^minyonglee1^minyonglee1^minyonglee1',                                   -- P_CREATED_BY
    v_rc);
  DBMS_OUTPUT.PUT_LINE('=== SAVE OK (SP 정상 — 문제는 순수 BE 처리단) ===');
  -- 재현 확인용이면 아래 주석 해제로 원복 (SP 가 내부 COMMIT 하면 무효)
  -- ROLLBACK;
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('=== 실오류(진짜 원인) ===');
    DBMS_OUTPUT.PUT_LINE('SQLCODE : ' || SQLCODE);
    DBMS_OUTPUT.PUT_LINE('SQLERRM : ' || SQLERRM);
    DBMS_OUTPUT.PUT_LINE('BACKTRACE:');
    DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
END;
/
