-- ============================================================================
-- 57_SYS0011_SCM0008_sheet_columns_dedupe_DBeaver.sql
-- DBeaver 실행용 — SQL*Plus 명령 (SET / PROMPT / WHENEVER / EXIT) 제거
-- 본체: 57_SYS0011_SCM0008_sheet_columns_dedupe.sql
-- ============================================================================

-- BLOCK 2 : duplicate row 제거
DELETE FROM SCM_MGR.SCM_MST_SHEET_COLUMNS X
 WHERE X.PROGRAM_ID = 'SYS0011'
   AND X.ROWID NOT IN (
     SELECT MIN(Y.ROWID)
       FROM SCM_MGR.SCM_MST_SHEET_COLUMNS Y
      WHERE Y.PROGRAM_ID = 'SYS0011'
      GROUP BY Y.SHEET_NAME, Y.COLUMN_NAME
   );

COMMIT;
