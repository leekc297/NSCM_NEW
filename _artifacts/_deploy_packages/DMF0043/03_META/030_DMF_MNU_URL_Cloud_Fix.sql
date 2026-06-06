--==============================================================================
-- 030_DMF_MNU_URL_Cloud_Fix.sql
--
-- 원인: 클라우드 SCM_ADM_MNU_M.MNU_URL = 'contribution-rate-registration' (legacy)
--       FE Router (nscm-fe/packages/foundation/src/constants/route-paths.ts:33) = 'contribute-main'
--       → URL slug 불일치 → React Router 화면 미매핑 → 빈 화면 (404)
--
-- DMF0043_01 도 동시 정합: legacy → 'contribute-view'
--
-- 멱등: WHERE 가드 (이미 정합 시 UPDATE 0 row → 재실행 안전)
-- 실행: SCM_MGR 세션. SQL*Plus / DBeaver 모두 OK
--
-- 출처: _artifacts/_deploy_packages/old/DMF0043_deploy_2026-06-02/02_DB_Meta_SQL/020_69_*
--       + _artifacts/33_DMF_MENU_URL_GUEST_Perm_Fix.sql BLOCK 1-2 통합
--
-- 작성: 2026-06-04
--==============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON
SET FEEDBACK ON

PROMPT === BLOCK 1 : DMF0043 MNU_URL slug 정합 (FE: contribute-main) ===

UPDATE SCM_MGR.SCM_ADM_MNU_M
   SET MNU_URL          = 'contribute-main',
       LAST_UPDATED_BY  = 'admin',
       LAST_UPDATE_DATE = SYSDATE
 WHERE MNU_ID = 'DMF0043'
   AND MNU_URL <> 'contribute-main';

PROMPT === BLOCK 2 : DMF0043_01 MNU_URL slug 정합 (FE: contribute-view) ===

UPDATE SCM_MGR.SCM_ADM_MNU_M
   SET MNU_URL          = 'contribute-view',
       LAST_UPDATED_BY  = 'admin',
       LAST_UPDATE_DATE = SYSDATE
 WHERE MNU_ID = 'DMF0043_01'
   AND MNU_URL <> 'contribute-view';

PROMPT === BLOCK 3 : 검증 — 정합 후 값 확인 ===

SELECT mnu_id, mnu_url,
       CASE
         WHEN mnu_id = 'DMF0043'    AND mnu_url = 'contribute-main' THEN 'PASS'
         WHEN mnu_id = 'DMF0043_01' AND mnu_url = 'contribute-view' THEN 'PASS'
         ELSE 'FAIL'
       END AS result
  FROM SCM_MGR.SCM_ADM_MNU_M
 WHERE mnu_id IN ('DMF0043', 'DMF0043_01');

COMMIT;
