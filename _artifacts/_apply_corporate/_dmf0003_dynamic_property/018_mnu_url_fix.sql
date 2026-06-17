-- DMF0003 MNU_URL 정합 (FE Router ROUTE_PATHS.DMF0003 = 'mkt_forecast' 와 일치)
--   사내 'dmf0003' → 'mkt_forecast'
--   FE Router 매핑 경로: /demand/demand-plan/mkt_forecast
--   해당 fix 전: 메뉴 클릭 시 /demand/demand-plan/dmf0003 → 404 Page Not Found
--   해당 fix 후: 정상 진입

UPDATE SCM_ADM_MNU_M
   SET MNU_URL          = 'mkt_forecast',
       LAST_UPDATED_BY  = 'admin',
       LAST_UPDATE_DATE = SYSDATE
 WHERE MNU_ID = 'DMF0003';

COMMIT;
