-- ============================================================================================
-- File         : 02_seed_minyonglee1_Verify.sql
-- Description  : DBeaver Verify — 단일 SELECT (UNION ALL). 시드 결과 검증.
-- Connection   : SCM_MGR @ FREEPDB1
-- ============================================================================================

SELECT 'GUEST group exists'           AS check_name,
       COUNT(*)                        AS pass_count
  FROM SCM_ADM_USER_GR_M WHERE USER_GR_ID = 'GUEST'
UNION ALL
SELECT 'minyonglee1 SSO user exists',
       COUNT(*) FROM SCM_MST_SSO_USER_INFO WHERE USER_ID = 'minyonglee1'
UNION ALL
SELECT 'minyonglee1 USER_M (PR-auto)',
       COUNT(*) FROM SCM_ADM_USER_M WHERE USER_ID = 'minyonglee1'
UNION ALL
SELECT 'minyonglee1 GUEST mapping (PR-auto)',
       COUNT(*) FROM SCM_ADM_USER_GR_MPG_M
       WHERE USER_ID = 'minyonglee1' AND USER_GR_ID = 'GUEST'
ORDER BY 1
