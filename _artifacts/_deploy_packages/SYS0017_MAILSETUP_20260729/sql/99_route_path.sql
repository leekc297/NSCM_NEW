-- 99_route_path.sql — ROUTE_PATH 최종 (반드시 마지막). '<features 도메인>/<페이지 폴더>' 2단 + 상위 경로
UPDATE SCM_ADM_MNU_M SET ROUTE_PATH = 'admin/system/mail-setup', LAST_UPDATED_BY='admin', LAST_UPDATE_DATE=SYSDATE
 WHERE MNU_ID = 'SYS0017' AND (ROUTE_PATH IS NULL OR ROUTE_PATH <> 'admin/system/mail-setup');
COMMIT;
