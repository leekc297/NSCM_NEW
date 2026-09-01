-- [E20260826-DMF0040ROUTE] ROUTE_PATH/MNU_URL 의미형 갱신 — 4중 cross-check (MENU_ID=폴더=DB route=MNU_URL)
-- ⚠ 적용 순서 마지막 (B_FE 배포 후) — 먼저 실행하면 폴더 부재로 Page Not Found (viewRegistry glob 계보)
UPDATE SCM_MGR.SCM_ADM_MNU_M
SET ROUTE_PATH='demand/demand-waterfall/mkt-fcst-comparison', MNU_URL='mkt-fcst-comparison',
    LAST_UPDATED_BY='admin', LAST_UPDATE_DATE=SYSDATE
WHERE MNU_ID='DMF0040';
COMMIT;
