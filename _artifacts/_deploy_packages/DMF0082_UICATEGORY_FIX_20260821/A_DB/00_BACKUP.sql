-- ============================================================================
-- DMF0082 UI CATEGORY SETUP 보완 — 00 백업 (적용 전 필수)
--   되돌릴 범위와 정확히 같은 행만 백업한다.
-- ============================================================================
CREATE TABLE SCM_MGR.BAK_DMF0082_SHEETCOL_20260821 AS
SELECT * FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
 WHERE PROGRAM_ID = 'DMF0082'
   AND SHEET_NAME = 'FcstNPrice'
   AND COLUMN_NAME IN ('PROJECT_CODE', 'PLANT_SITE_ID', 'DEPT_ID', 'DEPT_NAME_KO', 'GROUP_ID');

SELECT 'BACKUP' AS STEP, COUNT(*) AS ROWS_SAVED
  FROM SCM_MGR.BAK_DMF0082_SHEETCOL_20260821;   -- 기대 5
