--==============================================================================
-- 040_DMF0043_01_MNU_URL_Cloud_Fix.sql
--
-- 원인: 클라우드 SCM_ADM_MNU_M.MNU_URL = 'contribution-rate-view' (legacy) 또는 다른 값
--       FE Router (route-paths.ts:34) = 'contribute-view'
--       → URL slug 불일치 → React Router 404
--
-- DMF0043 와 동일 사고 패턴 #3.
-- 멱등: WHERE 가드 (재실행 안전)
-- 실행: SCM_MGR 세션. SQL*Plus / DBeaver 모두 OK
-- 작성: 2026-06-05
--==============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON
SET FEEDBACK ON

PROMPT === BLOCK 1 : DMF0043_01 MNU_URL slug 정합 (FE: contribute-view) ===

UPDATE SCM_MGR.SCM_ADM_MNU_M
   SET MNU_URL          = 'contribute-view',
       LAST_UPDATED_BY  = 'admin',
       LAST_UPDATE_DATE = SYSDATE
 WHERE MNU_ID = 'DMF0043_01'
   AND MNU_URL <> 'contribute-view';

PROMPT === BLOCK 2 : 검증 ===

SELECT mnu_id, mnu_url,
       CASE WHEN mnu_url = 'contribute-view' THEN 'PASS' ELSE 'FAIL' END AS result
  FROM SCM_MGR.SCM_ADM_MNU_M
 WHERE mnu_id = 'DMF0043_01';

COMMIT;
