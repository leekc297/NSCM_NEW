-- ============================================================================
-- 57_SYS0011_SCM0008_sheet_columns_dedupe_Verify.sql
-- DBeaver — 실행 후 검증 (사후 상태 + duplicate 잔존 0건)
-- ============================================================================

-- A. sheet 별 TOT / DISTINCT (TOT = DISTINCT 여야 함)
SELECT SHEET_NAME,
       COUNT(*) AS TOT,
       COUNT(DISTINCT COLUMN_NAME) AS DISTINCT_CNT
  FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
 WHERE PROGRAM_ID = 'SYS0011'
 GROUP BY SHEET_NAME
 ORDER BY SHEET_NAME;
-- 기대:
--   authority         TOT 3  DISTINCT 3
--   division          TOT 2  DISTINCT 2
--   myAuthorityList   TOT 9  DISTINCT 9
--   userInfo          TOT 7  DISTINCT 7

-- B. duplicate 잔존 검증 (0건 의무)
SELECT SHEET_NAME, COLUMN_NAME, COUNT(*) AS CNT
  FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
 WHERE PROGRAM_ID = 'SYS0011'
 GROUP BY SHEET_NAME, COLUMN_NAME
HAVING COUNT(*) > 1
 ORDER BY SHEET_NAME, COLUMN_NAME;

-- C. 총합 (21 row 의무)
SELECT COUNT(*) AS TOTAL_ROWS
  FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
 WHERE PROGRAM_ID = 'SYS0011';
-- 기대: TOTAL_ROWS = 21
