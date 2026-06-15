-- ============================================================================
-- 56. SYS0013 메뉴 추가 (VERIFY — 적용 후 검증)
-- ============================================================================

-- [A] SCM_ADM_MNU_M : SYS0013 row 1건
SELECT '[A] SYS0013 MNU_M' AS CHECK_ITEM,
       MNU_ID, UPPR_MNU_ID, MNU_URL, MNU_MSG_ID, MNU_DESC, SORT_ORD, MNU_LV_NO, MNU_TP_CD, USE_YN
  FROM SCM_ADM_MNU_M
 WHERE MNU_ID='SYS0013';
-- 기대: Admin_Menu / dynamic-query / MNU00211 / Dynamic Query List / 2 / 3 / SCREEN / Y

-- [B] i18n MSG_M : MNU00211 3 row (KO/EN/CN)
SELECT '[B] MNU00211 i18n' AS CHECK_ITEM,
       MSG_ID, LANG_CD, MSG_NM, MSG_TP_CD, USE_YN
  FROM SCM_ADM_MSG_M
 WHERE MSG_ID='MNU00211'
 ORDER BY LANG_CD;
-- 기대: 3 row, MSG_NM 모두 'Dynamic Query List' / MSG_TP_CD='MNU' / USE_YN='Y'

-- [C] USER_GR_MNU_MPG_M : SYS0013 그룹 권한 = 자매 SYS0010 동일
SELECT '[C] SYS0013 그룹권한' AS CHECK_ITEM,
       USER_GR_ID, MNU_ID, USE_YN
  FROM SCM_ADM_USER_GR_MNU_MPG_M
 WHERE MNU_ID='SYS0013'
 ORDER BY USER_GR_ID;
-- 기대: SYS0010 의 row 수와 동일 (ADMIN/Y + SCM PI Admin/N)

-- [D] USER_GR_MNU_BTN_MPG_M : SYS0013 버튼 권한 = 자매 SYS0010 동일
SELECT '[D] SYS0013 버튼권한' AS CHECK_ITEM,
       USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD, USE_YN
  FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M
 WHERE MNU_ID='SYS0013'
 ORDER BY USER_GR_ID, SHT_NM, MNU_BTN_CD;

-- [E] Admin_Menu 트리 (SYS0010 + SYS0013 2 row 기대)
SELECT '[E] Admin_Menu children' AS CHECK_ITEM,
       MNU_ID, MNU_DESC, MNU_URL, SORT_ORD
  FROM SCM_ADM_MNU_M
 WHERE UPPR_MNU_ID='Admin_Menu'
 ORDER BY SORT_ORD;
-- 기대: SYS0010 (Lookup, 1) → SYS0013 (Dynamic Query List, 2)
