-- ============================================================================================
-- File         : 03_seed_menu_parents_and_guest_perm_Verify.sql
-- Description  : DBeaver Verify — 단일 SELECT (UNION ALL). 메뉴 시드 결과 검증.
-- Connection   : SCM_MGR @ FREEPDB1
-- ============================================================================================

SELECT 'master menu exists'             AS check_name,
       COUNT(*)                          AS pass_count
  FROM SCM_ADM_MNU_M WHERE MNU_ID = 'master'
UNION ALL
SELECT 'DEMAND_MASTER menu exists',
       COUNT(*) FROM SCM_ADM_MNU_M WHERE MNU_ID = 'DEMAND_MASTER'
UNION ALL
SELECT 'DMF0020 menu exists',
       COUNT(*) FROM SCM_ADM_MNU_M WHERE MNU_ID = 'DMF0020'
UNION ALL
SELECT 'MNU_MASTER i18n (3 langs)',
       COUNT(*) FROM SCM_ADM_MSG_M WHERE MSG_ID = 'MNU_MASTER'
UNION ALL
SELECT 'MNU_DEMAND_MASTER i18n (3 langs)',
       COUNT(*) FROM SCM_ADM_MSG_M WHERE MSG_ID = 'MNU_DEMAND_MASTER'
UNION ALL
SELECT 'MNU_DMF0020 i18n (3 langs)',
       COUNT(*) FROM SCM_ADM_MSG_M WHERE MSG_ID = 'MNU_DMF0020'
UNION ALL
SELECT 'GUEST→master perm',
       COUNT(*) FROM SCM_ADM_USER_GR_MNU_MPG_M WHERE USER_GR_ID='GUEST' AND MNU_ID='master'
UNION ALL
SELECT 'GUEST→DEMAND_MASTER perm',
       COUNT(*) FROM SCM_ADM_USER_GR_MNU_MPG_M WHERE USER_GR_ID='GUEST' AND MNU_ID='DEMAND_MASTER'
UNION ALL
SELECT 'GUEST→DMF0020 perm',
       COUNT(*) FROM SCM_ADM_USER_GR_MNU_MPG_M WHERE USER_GR_ID='GUEST' AND MNU_ID='DMF0020'
ORDER BY 1
