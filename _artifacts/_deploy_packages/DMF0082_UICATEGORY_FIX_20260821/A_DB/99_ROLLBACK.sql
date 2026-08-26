-- ============================================================================
-- 원복 — 00_BACKUP.sql 이 뜬 5행을 그대로 되돌린다.
-- ============================================================================
UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS t
   SET (ATTRIBUTE1, CELL_COMBO_DATA_TYPE, DIVISION_ID, LAST_UPDATED_BY, LAST_UPDATE_DATE) =
       (SELECT b.ATTRIBUTE1, b.CELL_COMBO_DATA_TYPE, b.DIVISION_ID,
               b.LAST_UPDATED_BY, b.LAST_UPDATE_DATE
          FROM SCM_MGR.BAK_DMF0082_SHEETCOL_20260821 b
         WHERE b.PROGRAM_ID=t.PROGRAM_ID AND b.SHEET_NAME=t.SHEET_NAME
           AND b.COLUMN_NAME=t.COLUMN_NAME)
 WHERE t.PROGRAM_ID='DMF0082' AND t.SHEET_NAME='FcstNPrice'
   AND EXISTS (SELECT 1 FROM SCM_MGR.BAK_DMF0082_SHEETCOL_20260821 b
                WHERE b.PROGRAM_ID=t.PROGRAM_ID AND b.SHEET_NAME=t.SHEET_NAME
                  AND b.COLUMN_NAME=t.COLUMN_NAME);
