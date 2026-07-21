-- =====================================================================
-- DMF0003(MKT FCST) / DMF0021(Sales Plan) — MNU_URL 3-SET 정합 교정 (2026-07-21)
--
-- 문제: SCM_ADM_MNU_M.MNU_URL 이 두 화면 모두 'dmf0003'(placeholder 충돌) →
--   Router path(DMF0003='mkt_forecast' / DMF0021='sales-plan')·route-paths 와 불일치 →
--   메뉴 클릭 시 라우트 미매칭 → 화면 미오픈. (DMF0082='forecast-price' 는 정합 → 정상)
-- 교정: 각 화면 slug 로 MNU_URL 정정 (route-paths / Router.tsx 와 3-SET 일치).
--   - DMF0003 → 'mkt_forecast' (Router 리터럴 slug)
--   - DMF0021 → 'sales-plan'   (ROUTE_PATHS.DMF0021)
--
-- 백업(적용 전 실측): DMF0003 MNU_URL='dmf0003' / DMF0021 MNU_URL='dmf0003'.
-- WHERE MNU_URL='dmf0003' 가드 = 멱등(이미 교정 시 무동작). 감사 'admin'.
-- =====================================================================

UPDATE SCM_MGR.SCM_ADM_MNU_M
   SET MNU_URL = 'mkt_forecast', LAST_UPDATED_BY = 'admin', LAST_UPDATE_DATE = SYSDATE
 WHERE MNU_ID = 'DMF0003' AND MNU_URL = 'dmf0003';

UPDATE SCM_MGR.SCM_ADM_MNU_M
   SET MNU_URL = 'sales-plan', LAST_UPDATED_BY = 'admin', LAST_UPDATE_DATE = SYSDATE
 WHERE MNU_ID = 'DMF0021' AND MNU_URL = 'dmf0003';

COMMIT;

-- 검증:
-- SELECT MNU_ID, MNU_URL FROM SCM_MGR.SCM_ADM_MNU_M WHERE MNU_ID IN ('DMF0003','DMF0021','DMF0082');

-- 원복 (ROLLBACK):
-- UPDATE SCM_MGR.SCM_ADM_MNU_M SET MNU_URL='dmf0003' WHERE MNU_ID='DMF0003' AND MNU_URL='mkt_forecast';
-- UPDATE SCM_MGR.SCM_ADM_MNU_M SET MNU_URL='dmf0003' WHERE MNU_ID='DMF0021' AND MNU_URL='sales-plan';
-- COMMIT;
