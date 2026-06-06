--==============================================================================
-- 020_69_DMF0043_MNU_URL_Cloud_Fix_DBeaver.sql
--
-- 원인: 클라우드 SCM_ADM_MNU_M.MNU_URL = 'contribution-rate-registration'
--       FE Router (route-paths.ts:33) = 'contribute-main'
--       → URL slug 불일치 → React Router 화면 미매핑 → 빈 화면
--
-- 룰: Doc/_dev_rules/hooks/dbeaver-sql-mandatory-grep (SQL*Plus 0건)
--     Doc/_dev_rules/hooks/menu-not-displayed-debug Step 1 (MNU_URL ↔ FE slug)
-- 멱등: WHERE MNU_URL <> 'contribute-main' 가드 (재실행 안전)
--
-- 실행: 클라우드 DBeaver 에서 전체 선택 → Ctrl+Alt+Enter (Auto-Commit OFF 시 마지막 COMMIT)
--
-- 작성: 2026-06-04
--==============================================================================

-- BLOCK 1 : DMF0043 MNU_URL slug 정합 (FE: contribute-main)
UPDATE SCM_ADM_MNU_M
   SET MNU_URL          = 'contribute-main',
       LAST_UPDATED_BY  = 'admin',
       LAST_UPDATE_DATE = SYSDATE
 WHERE MNU_ID = 'DMF0043'
   AND MNU_URL <> 'contribute-main';

COMMIT;
