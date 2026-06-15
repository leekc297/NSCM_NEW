-- ============================================================================
-- 55. 메뉴/MSG i18n 통합 정합화 (APPLY)
-- ----------------------------------------------------------------------------
-- 작성   : 2026-06-15 (사용자 다국어 영문화 작업 후 잔존 사고 4건)
-- 대상   : 사내 Oracle (121.162.245.167:2521/ESSCMD), user SCM_MGR
-- 적용 4 axis:
--   (1) SCM_ADM_LOOKUP_MASTER_DETAIL — MSG_TP_CD lookup 의 DESCRIPTION 정정
--       "Korean" 잔존 3 row → "Label"/"Message"/"Menu" (SYS0001 Type combo 표시 정정)
--   (2) SCM_ADM_MSG_M — MSG_TP_CD typo 통일
--       'MENU' (3 row, MNU_SYS0015) → 'MNU' (자매 표준)
--       'API'  (31 row, MSG_API_*)   → 'MSG'
--   (3) SCM_ADM_MNU_M — DMF0043 / DMF0043_01 의 MNU_DESC 한글 → 영문
--       (FE `t(mnuMsgId, mnuDesc)` fallback 에서 한글 표시 차단)
-- ============================================================================

SET DEFINE OFF;
SET SERVEROUTPUT ON;

DECLARE
  v_lkp_lbl  PLS_INTEGER := 0;
  v_lkp_msg  PLS_INTEGER := 0;
  v_lkp_mnu  PLS_INTEGER := 0;
  v_menu2mnu PLS_INTEGER := 0;
  v_api2msg  PLS_INTEGER := 0;
  v_mnu_43   PLS_INTEGER := 0;
  v_mnu_4301 PLS_INTEGER := 0;
BEGIN
  --------------------------------------------------------------------------
  -- (1) LOOKUP_MASTER_DETAIL.DESCRIPTION — "Korean" → "Label"/"Message"/"Menu"
  --------------------------------------------------------------------------
  UPDATE SCM_ADM_LOOKUP_MASTER_DETAIL
     SET DESCRIPTION='Label',
         LAST_UPDATED_BY='admin', LAST_UPDATE_DATE=SYSDATE
   WHERE LOOKUP_TYPE='MSG_TP_CD' AND SEGMENT1='LBL';
  v_lkp_lbl := SQL%ROWCOUNT;

  UPDATE SCM_ADM_LOOKUP_MASTER_DETAIL
     SET DESCRIPTION='Message',
         LAST_UPDATED_BY='admin', LAST_UPDATE_DATE=SYSDATE
   WHERE LOOKUP_TYPE='MSG_TP_CD' AND SEGMENT1='MSG';
  v_lkp_msg := SQL%ROWCOUNT;

  UPDATE SCM_ADM_LOOKUP_MASTER_DETAIL
     SET DESCRIPTION='Menu',
         LAST_UPDATED_BY='admin', LAST_UPDATE_DATE=SYSDATE
   WHERE LOOKUP_TYPE='MSG_TP_CD' AND SEGMENT1='MNU';
  v_lkp_mnu := SQL%ROWCOUNT;

  --------------------------------------------------------------------------
  -- (2) SCM_ADM_MSG_M.MSG_TP_CD typo 통일
  --------------------------------------------------------------------------
  UPDATE SCM_ADM_MSG_M
     SET MSG_TP_CD='MNU',
         LAST_UPDATED_BY='admin', LAST_UPDATE_DATE=SYSDATE
   WHERE MSG_TP_CD='MENU';
  v_menu2mnu := SQL%ROWCOUNT;

  UPDATE SCM_ADM_MSG_M
     SET MSG_TP_CD='MSG',
         LAST_UPDATED_BY='admin', LAST_UPDATE_DATE=SYSDATE
   WHERE MSG_TP_CD='API';
  v_api2msg := SQL%ROWCOUNT;

  --------------------------------------------------------------------------
  -- (3) SCM_ADM_MNU_M.MNU_DESC 영문화 (DMF0043 / DMF0043_01)
  --------------------------------------------------------------------------
  UPDATE SCM_ADM_MNU_M
     SET MNU_DESC='Overseas Subs. Contribution Rate Reg.',
         LAST_UPDATED_BY='admin', LAST_UPDATE_DATE=SYSDATE
   WHERE MNU_ID='DMF0043';
  v_mnu_43 := SQL%ROWCOUNT;

  UPDATE SCM_ADM_MNU_M
     SET MNU_DESC='Overseas Subs. Contribution Sales',
         LAST_UPDATED_BY='admin', LAST_UPDATE_DATE=SYSDATE
   WHERE MNU_ID='DMF0043_01';
  v_mnu_4301 := SQL%ROWCOUNT;

  DBMS_OUTPUT.PUT_LINE('LOOKUP DESCRIPTION  LBL : ' || v_lkp_lbl);
  DBMS_OUTPUT.PUT_LINE('LOOKUP DESCRIPTION  MSG : ' || v_lkp_msg);
  DBMS_OUTPUT.PUT_LINE('LOOKUP DESCRIPTION  MNU : ' || v_lkp_mnu);
  DBMS_OUTPUT.PUT_LINE('MSG_TP_CD MENU -> MNU   : ' || v_menu2mnu);
  DBMS_OUTPUT.PUT_LINE('MSG_TP_CD API  -> MSG   : ' || v_api2msg);
  DBMS_OUTPUT.PUT_LINE('MNU_DESC DMF0043        : ' || v_mnu_43);
  DBMS_OUTPUT.PUT_LINE('MNU_DESC DMF0043_01     : ' || v_mnu_4301);

  COMMIT;
END;
/
