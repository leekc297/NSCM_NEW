-- ============================================================================
-- 56. SYS0013 (Dynamic Query List) 메뉴 추가 (APPLY)
-- ----------------------------------------------------------------------------
-- 작성  : 2026-06-15 (사용자 명시 — admin/admin/Dynamic Query List)
-- 대상  : 사내 Oracle (121.162.245.167:2521/ESSCMD), user SCM_MGR
-- 위치  : Admin (Lv1) > Admin_Menu (Lv2) > SYS0013 (Lv3, SORT_ORD=2)
-- 자매  : SYS0010 (Lookup, SORT_ORD=1, UPPR_MNU_ID='Admin_Menu') 패턴 따름
-- FE    : @admin/dynamic-query — ROUTE_PATHS.SYS0013='dynamic-query'
--
-- 4 axis (NOT EXISTS 멱등):
--   (1) SCM_ADM_MNU_M           : SYS0013 row
--   (2) SCM_ADM_MSG_M           : MNU00211 i18n (KO/EN/CN = 'Dynamic Query List' 영문 통일)
--   (3) SCM_ADM_USER_GR_MNU_MPG_M : 자매 SYS0010 의 USER_GR 동적 복사
--   (4) SCM_ADM_USER_GR_MNU_BTN_MPG_M : 자매 SYS0010 의 버튼 권한 동적 복사 (있는 경우)
-- ============================================================================

SET DEFINE OFF;
SET SERVEROUTPUT ON;

DECLARE
  v_mnu      PLS_INTEGER := 0;
  v_msg      PLS_INTEGER := 0;
  v_gr_mnu   PLS_INTEGER := 0;
  v_gr_btn   PLS_INTEGER := 0;
BEGIN
  --------------------------------------------------------------------------
  -- (1) SCM_ADM_MNU_M — SYS0013
  --------------------------------------------------------------------------
  INSERT INTO SCM_ADM_MNU_M (
    MNU_ID, UPPR_MNU_ID, MNU_URL, MNU_MSG_ID, MNU_DESC,
    SORT_ORD, MNU_LV_NO, MNU_TP_CD, UNIT_TP_CD, USE_YN,
    CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
  )
  SELECT 'SYS0013', 'Admin_Menu', 'dynamic-query', 'MNU00211', 'Dynamic Query List',
         2, 3, 'SCREEN', '-', 'Y',
         'admin', SYSDATE, 'admin', SYSDATE
    FROM DUAL
   WHERE NOT EXISTS (SELECT 1 FROM SCM_ADM_MNU_M WHERE MNU_ID='SYS0013');
  v_mnu := SQL%ROWCOUNT;

  --------------------------------------------------------------------------
  -- (2) SCM_ADM_MSG_M — MNU00211 i18n (KO=EN=CN 영문 통일)
  --------------------------------------------------------------------------
  INSERT INTO SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_NM, MSG_TP_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
  SELECT * FROM (
    SELECT 'MNU00211' MSG_ID, 'KO' LANG_CD, 'Dynamic Query List' MSG_NM, 'MNU' MSG_TP_CD, 'Y' USE_YN,
           'admin' CREATED_BY, SYSDATE CREATION_DATE, 'admin' LAST_UPDATED_BY, SYSDATE LAST_UPDATE_DATE FROM DUAL
    UNION ALL
    SELECT 'MNU00211', 'EN', 'Dynamic Query List', 'MNU', 'Y', 'admin', SYSDATE, 'admin', SYSDATE FROM DUAL
    UNION ALL
    SELECT 'MNU00211', 'CN', 'Dynamic Query List', 'MNU', 'Y', 'admin', SYSDATE, 'admin', SYSDATE FROM DUAL
  ) NEW
   WHERE NOT EXISTS (SELECT 1 FROM SCM_ADM_MSG_M e WHERE e.MSG_ID=NEW.MSG_ID AND e.LANG_CD=NEW.LANG_CD);
  v_msg := SQL%ROWCOUNT;

  --------------------------------------------------------------------------
  -- (3) SCM_ADM_USER_GR_MNU_MPG_M — 자매 SYS0010 의 그룹 동적 복사 (USE_YN 그대로)
  --------------------------------------------------------------------------
  INSERT INTO SCM_ADM_USER_GR_MNU_MPG_M (USER_GR_ID, MNU_ID, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
  SELECT u.USER_GR_ID, 'SYS0013' MNU_ID, u.USE_YN,
         'admin', SYSDATE, 'admin', SYSDATE
    FROM SCM_ADM_USER_GR_MNU_MPG_M u
   WHERE u.MNU_ID = 'SYS0010'
     AND NOT EXISTS (SELECT 1 FROM SCM_ADM_USER_GR_MNU_MPG_M e
                      WHERE e.USER_GR_ID = u.USER_GR_ID AND e.MNU_ID = 'SYS0013');
  v_gr_mnu := SQL%ROWCOUNT;

  --------------------------------------------------------------------------
  -- (4) SCM_ADM_USER_GR_MNU_BTN_MPG_M — 자매 SYS0010 의 버튼 권한 동적 복사
  --------------------------------------------------------------------------
  INSERT INTO SCM_ADM_USER_GR_MNU_BTN_MPG_M (USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
  SELECT u.USER_GR_ID, 'SYS0013' MNU_ID, u.SHT_NM, u.MNU_BTN_CD, u.USE_YN,
         'admin', SYSDATE, 'admin', SYSDATE
    FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M u
   WHERE u.MNU_ID = 'SYS0010'
     AND NOT EXISTS (SELECT 1 FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M e
                      WHERE e.USER_GR_ID = u.USER_GR_ID AND e.MNU_ID = 'SYS0013'
                        AND e.SHT_NM = u.SHT_NM AND e.MNU_BTN_CD = u.MNU_BTN_CD);
  v_gr_btn := SQL%ROWCOUNT;

  DBMS_OUTPUT.PUT_LINE('(1) SCM_ADM_MNU_M SYS0013          : ' || v_mnu);
  DBMS_OUTPUT.PUT_LINE('(2) SCM_ADM_MSG_M MNU00211 (3 lang): ' || v_msg);
  DBMS_OUTPUT.PUT_LINE('(3) USER_GR_MNU_MPG_M (group cascade) : ' || v_gr_mnu);
  DBMS_OUTPUT.PUT_LINE('(4) USER_GR_MNU_BTN_MPG_M (btn cascade): ' || v_gr_btn);

  COMMIT;
END;
/
