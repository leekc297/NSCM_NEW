-- API_URL 변경 — PKG_DMF0020.P_DMF0020_GET_SPREAD_TITLE_DATE → standalone DMF0020_GET_SPREAD_TITLE_DATE
--   standalone SP 는 037_dmf0020_spread_title_date_fix.sql 측 월 변경 주 분리 logic 보유.
--   PKG 안 procedure 수정은 PKG body 4000+ line 전체 CREATE 위험 → standalone SP 우회.
--   signature 동일 (P_START_YYYYMMDD/P_END_YYYYMMDD/P_CREATED_BY/O_RC1/O_RESULT_CURSOR).

UPDATE SCM_MGR.SCM_ADM_API_M
   SET API_URL          = 'DMF0020_GET_SPREAD_TITLE_DATE',
       LAST_UPDATED_BY  = 'system',
       LAST_UPDATE_DATE = SYSDATE
 WHERE API_ID = 'DMF0020_main_SPREAD_TITLE_DATE';

COMMIT;
