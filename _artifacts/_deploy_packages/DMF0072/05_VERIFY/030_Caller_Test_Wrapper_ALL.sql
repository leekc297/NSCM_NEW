--==============================================================================
-- 030_Caller_Test_Wrapper_ALL.sql (DMF0072)
--
-- 목적: wrapper 'ALL' 처리 + UF_FX_STRING_SPLITFORIN COLUMN_VALUE 검증
--       DMF0072 의 핵심 특성 — multi-select Division + ALL 값 + wrapper 'ALL' → '' 변환 안티패턴 회피
-- 작성: 2026-06-05
--==============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 250
SET TIMING ON

PROMPT === BLOCK 1 : DMF0072 main wrapper 'ALL' 호출 검증 ===

DECLARE
  v_rc SYS_REFCURSOR;
BEGIN
  -- multi-select Division = 'ALL' (wrapper 가 그대로 전달 — '' 변환 X)
  DMF0072_GET_NNMASTER_MAPPING_WRAPPER(
    p_division_id  => 'ALL',
    p_dept_id      => 'ALL',
    p_end_customer => 'ALL',
    p_scm_site_id  => 'ALL',
    p_project_code => 'ALL',
    p_item_id      => 'ALL',
    p_ses_user_id  => 'minyonglee1',
    p_menu_id      => 'DMF0072',
    O_RC1          => v_rc
  );
  DBMS_OUTPUT.PUT_LINE('main wrapper ALL 호출 정상 (전달값 그대로 — wrapper ALL→'''' 변환 사고 없음)');
  CLOSE v_rc;
EXCEPTION WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('main wrapper ERR ' || SQLCODE || ' / ' || SUBSTR(SQLERRM, 1, 200));
END;
/

PROMPT === BLOCK 2 : DMF0072 lookup combo SP 4개 호출 검증 ===

DECLARE
  v_rc SYS_REFCURSOR;
BEGIN
  -- dataType
  BEGIN
    DMF0072_GET_DATA_TYPE_LIST(p_ses_user_id => 'minyonglee1', p_menu_id => 'DMF0072', O_RC1 => v_rc);
    DBMS_OUTPUT.PUT_LINE('dataType OK'); CLOSE v_rc;
  EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('dataType ERR ' || SUBSTR(SQLERRM, 1, 100));
  END;

  -- team
  BEGIN
    DMF0072_GET_TEAM_LIST(p_division_id => '40', p_dept_id => 'ALL',
                          p_ses_user_id => 'minyonglee1', p_menu_id => 'DMF0072', O_RC1 => v_rc);
    DBMS_OUTPUT.PUT_LINE('team OK'); CLOSE v_rc;
  EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('team ERR ' || SUBSTR(SQLERRM, 1, 100));
  END;

  -- endCustomer
  BEGIN
    DMF0072_GET_END_CUSTOMER_LIST(p_division_id => '40', p_dept_id => 'ALL',
                                  p_ses_user_id => 'minyonglee1', p_menu_id => 'DMF0072', O_RC1 => v_rc);
    DBMS_OUTPUT.PUT_LINE('endCustomer OK'); CLOSE v_rc;
  EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('endCustomer ERR ' || SUBSTR(SQLERRM, 1, 100));
  END;

  -- salesSite
  BEGIN
    DMF0072_GET_SALES_SITE_LIST(p_division_id => '40', p_end_customer => 'ALL',
                                p_ses_user_id => 'minyonglee1', p_menu_id => 'DMF0072', O_RC1 => v_rc);
    DBMS_OUTPUT.PUT_LINE('salesSite OK'); CLOSE v_rc;
  EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('salesSite ERR ' || SUBSTR(SQLERRM, 1, 100));
  END;
END;
/

PROMPT === BLOCK 3 : Project / Item popup SP 호출 ===

DECLARE
  v_rc SYS_REFCURSOR;
BEGIN
  BEGIN
    DMF0072_GET_PROJECT_POPUP_LIST(
      p_division_id => '40', p_dept_id => 'ALL', p_end_customer => 'ALL',
      p_scm_site_id => 'ALL', p_project_code => 'ALL',
      p_ses_user_id => 'minyonglee1', p_menu_id => 'DMF0072', O_RC1 => v_rc);
    DBMS_OUTPUT.PUT_LINE('projectPopup OK'); CLOSE v_rc;
  EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('projectPopup ERR ' || SUBSTR(SQLERRM, 1, 100));
  END;

  BEGIN
    DMF0072_GET_ITEM_POPUP_LIST(
      p_division_id => '40', p_dept_id => 'ALL', p_end_customer => 'ALL',
      p_scm_site_id => 'ALL', p_item_id => 'ALL',
      p_ses_user_id => 'minyonglee1', p_menu_id => 'DMF0072', O_RC1 => v_rc);
    DBMS_OUTPUT.PUT_LINE('itemPopup OK'); CLOSE v_rc;
  EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('itemPopup ERR ' || SUBSTR(SQLERRM, 1, 100));
  END;
END;
/

PROMPT === 판독 : 모두 OK → DMF0072 wrapper ALL 처리 + COLUMN_VALUE 정상
PROMPT - 1건이라도 ERR → SQLERRM 메시지로 다음 진단 진행
