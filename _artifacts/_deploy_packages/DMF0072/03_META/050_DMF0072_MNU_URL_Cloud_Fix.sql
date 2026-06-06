--==============================================================================
-- 050_DMF0072_MNU_URL_Cloud_Fix.sql
--
-- 원인: 클라우드 SCM_ADM_MNU_M.MNU_URL = legacy 값
--       FE Router (route-paths.ts:36) = 'nn-master-mapping'
-- 멱등: WHERE 가드
-- 작성: 2026-06-05
--==============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON
SET FEEDBACK ON

PROMPT === BLOCK 1 : DMF0072 MNU_URL slug 정합 ===

UPDATE SCM_MGR.SCM_ADM_MNU_M
   SET MNU_URL          = 'nn-master-mapping',
       LAST_UPDATED_BY  = 'admin',
       LAST_UPDATE_DATE = SYSDATE
 WHERE MNU_ID = 'DMF0072'
   AND MNU_URL <> 'nn-master-mapping';

PROMPT === BLOCK 2 : 검증 ===

SELECT mnu_id, mnu_url,
       CASE WHEN mnu_url = 'nn-master-mapping' THEN 'PASS' ELSE 'FAIL' END AS result
  FROM SCM_MGR.SCM_ADM_MNU_M
 WHERE mnu_id = 'DMF0072';

COMMIT;
