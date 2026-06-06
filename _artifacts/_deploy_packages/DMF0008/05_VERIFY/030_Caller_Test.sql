--==============================================================================
-- 030_Caller_Test.sql (DMF0008)
--==============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 250
SET TIMING ON

PROMPT === BLOCK 1 : 4 sheet caller 호출 검증 ===

DECLARE
  v_rc SYS_REFCURSOR;
BEGIN
  -- repair
  BEGIN
    DMF0008_GET_EDI_MST_REPAIR(p_division_id => '40', p_sender_name => 'ALL',
                                p_flag => 'ALL', p_user_id => 'minyonglee1', O_RC1 => v_rc);
    DBMS_OUTPUT.PUT_LINE('REPAIR caller 정상'); CLOSE v_rc;
  EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('REPAIR ERR ' || SQLCODE || ' / ' || SUBSTR(SQLERRM, 1, 150));
  END;

  -- summary
  BEGIN
    DMF0008_GET_EDI_MST_SUMMARY(p_division_id => '40', p_ses_user_id => 'minyonglee1',
                                 p_menu_id => 'DMF0008', O_RC1 => v_rc);
    DBMS_OUTPUT.PUT_LINE('SUMMARY caller 정상'); CLOSE v_rc;
  EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('SUMMARY ERR ' || SQLCODE || ' / ' || SUBSTR(SQLERRM, 1, 150));
  END;

  -- salesSite
  BEGIN
    DMF0008_GET_SALES_SITE(p_division_id => '40', p_sold_to => 'ALL',
                            p_ship_to => 'ALL', O_RC1 => v_rc);
    DBMS_OUTPUT.PUT_LINE('SALES_SITE caller 정상'); CLOSE v_rc;
  EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('SALES_SITE ERR ' || SQLCODE || ' / ' || SUBSTR(SQLERRM, 1, 150));
  END;

  -- sspm
  BEGIN
    DMF0008_GET_SALES_SITE_PROJECT_MODEL(p_division_id => '40', p_item_id => 'ALL',
                                          p_scm_site_id => 'ALL', O_RC1 => v_rc);
    DBMS_OUTPUT.PUT_LINE('SSPM caller 정상'); CLOSE v_rc;
  EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('SSPM ERR ' || SQLCODE || ' / ' || SUBSTR(SQLERRM, 1, 150));
  END;
END;
/

PROMPT === 판독 : 4 SP 모두 "정상" → OK. 1건이라도 ERR → 시그니처/메타 cross-check 필요
