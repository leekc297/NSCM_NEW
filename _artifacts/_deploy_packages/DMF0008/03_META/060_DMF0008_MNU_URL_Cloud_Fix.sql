--==============================================================================
-- 060_DMF0008_MNU_URL_Cloud_Fix.sql
--
-- 원인: 클라우드 SCM_ADM_MNU_M.MNU_URL 가 'dmf0008' 또는 legacy 값
--       FE Router (route-paths.ts:35) = 'erp-edi-master'
-- 멱등: WHERE 가드
-- 작성: 2026-06-05
--==============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON
SET FEEDBACK ON

PROMPT === BLOCK 1 : DMF0008 MNU_URL slug 정합 ===

UPDATE SCM_MGR.SCM_ADM_MNU_M
   SET MNU_URL          = 'erp-edi-master',
       LAST_UPDATED_BY  = 'admin',
       LAST_UPDATE_DATE = SYSDATE
 WHERE MNU_ID = 'DMF0008'
   AND MNU_URL <> 'erp-edi-master';

PROMPT === BLOCK 2 : 검증 ===

SELECT mnu_id, mnu_url,
       CASE WHEN mnu_url = 'erp-edi-master' THEN 'PASS' ELSE 'FAIL' END AS result
  FROM SCM_MGR.SCM_ADM_MNU_M
 WHERE mnu_id = 'DMF0008';

COMMIT;
