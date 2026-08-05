-- DMF0068 Demand Manager — 라우트 slug 정정 (2026-07-29)
-- ⚠ 반드시 마지막에 적용한다 (FE 배포와 동시에 반영되어야 화면이 열린다).
-- 현재 : MNU_URL = 'dmf0068'          / ROUTE_PATH = 'demand/demand-waterfall/dmf0068'
-- 정정 : MNU_URL = 'demand-manager'   / ROUTE_PATH = 'demand/demand-waterfall/demand-manager'
-- 3-SET 정합 : MNU_URL(slug) = FE 폴더명(demand-manager) = ROUTE_PATH 말단

-- [백업] 적용 전 상태
SELECT MNU_ID, UPPR_MNU_ID, MNU_URL, ROUTE_PATH, MNU_MSG_ID, MNU_DESC, UNIT_TP_CD, USE_YN
FROM SCM_MGR.SCM_ADM_MNU_M WHERE MNU_ID = 'DMF0068';

UPDATE SCM_MGR.SCM_ADM_MNU_M
SET    MNU_URL          = 'demand-manager',
       ROUTE_PATH       = 'demand/demand-waterfall/demand-manager',
       LAST_UPDATED_BY  = 'admin',
       LAST_UPDATE_DATE = SYSDATE
WHERE  MNU_ID = 'DMF0068'
  AND  MNU_URL <> 'demand-manager';

COMMIT;

-- 검증
SELECT MNU_ID, UPPR_MNU_ID, MNU_URL, ROUTE_PATH, MNU_DESC, UNIT_TP_CD, USE_YN
FROM SCM_MGR.SCM_ADM_MNU_M WHERE MNU_ID = 'DMF0068';
