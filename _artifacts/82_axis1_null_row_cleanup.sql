--==============================================================================
-- 82_axis1_null_row_cleanup.sql
-- AXIS 1 false positive 의 원인 — SCM_MST_SHEET_COLUMNS 에 NULL row 1건 존재
-- (PROGRAM_ID/SHEET_NAME/COLUMN_NAME 모두 NULL — 의미 없음)
--==============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON
SET FEEDBACK ON
WHENEVER SQLERROR EXIT FAILURE

DELETE FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
 WHERE PROGRAM_ID IS NULL AND SHEET_NAME IS NULL AND COLUMN_NAME IS NULL;

COMMIT;

SELECT COUNT(*) AS REMAINING_NULL_ROWS FROM SCM_MGR.SCM_MST_SHEET_COLUMNS WHERE COLUMN_NAME IS NULL;
EXIT;
