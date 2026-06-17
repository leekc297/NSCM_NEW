-- SHEET_NAME 표준화 (사내 AS-IS 호환 → FE 표준)
--   사내 'Mkt Fcst' (공백) → 'main' (FE SHEETS.MAIN)
--   사내 'PSI'            → 'psi'  (FE SHEETS.PSI)
--   사내 'Car Fcst'       → 'carFcst' (FE SHEETS.CAR_FCST)
--   'Customer Demand Analysis' 는 deprecated 라 보존
--
-- PK (PROGRAM_ID, SHEET_NAME, COLUMN_NAME) 충돌 없음 — 현재 'main'/'psi'/'carFcst' 0 row

UPDATE SCM_MST_SHEET_COLUMNS
   SET SHEET_NAME      = 'main',
       LAST_UPDATED_BY = 'admin',
       LAST_UPDATE_DATE= SYSDATE
 WHERE PROGRAM_ID = 'DMF0003' AND SHEET_NAME = 'Mkt Fcst';

UPDATE SCM_MST_SHEET_COLUMNS
   SET SHEET_NAME      = 'psi',
       LAST_UPDATED_BY = 'admin',
       LAST_UPDATE_DATE= SYSDATE
 WHERE PROGRAM_ID = 'DMF0003' AND SHEET_NAME = 'PSI';

UPDATE SCM_MST_SHEET_COLUMNS
   SET SHEET_NAME      = 'carFcst',
       LAST_UPDATED_BY = 'admin',
       LAST_UPDATE_DATE= SYSDATE
 WHERE PROGRAM_ID = 'DMF0003' AND SHEET_NAME = 'Car Fcst';

COMMIT;
