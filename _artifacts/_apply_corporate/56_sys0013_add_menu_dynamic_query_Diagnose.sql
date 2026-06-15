-- ============================================================================
-- 56. SYS0013 메뉴 추가 (DIAGNOSE — 적용 전 사전 점검, DML 없음)
-- ============================================================================

-- [Pre-1] SYS0013 이미 존재 여부 (0 row 기대 → 신규 적용 / 1 row → 이미 등록됨)
SELECT '[Pre-1] SYS0013 존재' AS CHECK_ITEM, COUNT(*) CNT
  FROM SCM_ADM_MNU_M
 WHERE MNU_ID='SYS0013';

-- [Pre-2] MNU00211 이미 사용 중 여부 (0 row 기대)
SELECT '[Pre-2] MNU00211 사용' AS CHECK_ITEM, MNU_ID, MNU_DESC
  FROM SCM_ADM_MNU_M
 WHERE MNU_MSG_ID='MNU00211';

SELECT '[Pre-2] MNU00211 i18n' AS CHECK_ITEM, MSG_ID, LANG_CD, MSG_NM
  FROM SCM_ADM_MSG_M
 WHERE MSG_ID='MNU00211';

-- [Pre-3] 다음 가용 MNU_MSG_ID (현재 max)
SELECT '[Pre-3] MAX MNU_MSG_ID' AS CHECK_ITEM,
       MAX(MNU_MSG_ID) MAX_USED
  FROM SCM_ADM_MNU_M
 WHERE MNU_MSG_ID LIKE 'MNU00%';
-- 가용 다음 번호 권장 (현재 MNU00210 사용 중이면 MNU00211 권장)

-- [Pre-4] Admin_Menu 부모 메뉴 존재 (UPPR 정합)
SELECT '[Pre-4] Admin_Menu 부모' AS CHECK_ITEM,
       MNU_ID, UPPR_MNU_ID, MNU_DESC, MNU_TP_CD
  FROM SCM_ADM_MNU_M
 WHERE MNU_ID='Admin_Menu';
-- 기대: UPPR_MNU_ID='Admin' / MNU_DESC='Admin Menu' / MNU_TP_CD='MENU'

-- [Pre-5] 자매 SYS0010 (Lookup) reference row (cascade 기준)
SELECT '[Pre-5] SYS0010 자매' AS CHECK_ITEM,
       MNU_ID, UPPR_MNU_ID, MNU_URL, SORT_ORD, MNU_LV_NO, UNIT_TP_CD, USE_YN
  FROM SCM_ADM_MNU_M
 WHERE MNU_ID='SYS0010';

SELECT '[Pre-5] SYS0010 그룹권한' AS CHECK_ITEM,
       USER_GR_ID, USE_YN
  FROM SCM_ADM_USER_GR_MNU_MPG_M
 WHERE MNU_ID='SYS0010';

SELECT '[Pre-5] SYS0010 버튼권한 카운트' AS CHECK_ITEM,
       USER_GR_ID, COUNT(*) BTN_CNT
  FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M
 WHERE MNU_ID='SYS0010'
 GROUP BY USER_GR_ID;
