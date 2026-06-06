--==============================================================================
-- 69_SYS0013_SHEET_COLUMNS_register.sql
--
-- 목적: SYS0013 (SCM0005 Dynamic Query) 의 SHEET_COLUMNS 메타 등록
--       5 sheet × column = main 7 / columns 5 / parameters 6 / history 6 / result (dynamic 0)
--
-- 사고 (2026-06-09 사용자 보고 "Grid Column 이 보이지 않습니다"):
--   FE sub-grid 들이 하드코딩 staticColumns `[{binding, header, width}]` 사용
--   → DataGrid wrapper 의 mapRawColumnsToWijmoColumns 가 `display` 필드 filter
--   → display 없음 → 0 columns rendered
--   → SHEET_COLUMNS 메타 0건 → store fetchStaticColumns 도 빈 배열
--
-- Fix: BE 메타 등록 + FE 5 grid 가 store staticColumns 사용 (별도 작업)
--
-- 멱등성: NOT EXISTS 패턴.
-- 작성: 2026-06-09
--==============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON
SET FEEDBACK ON
WHENEVER SQLERROR EXIT FAILURE

PROMPT === SHEET_COLUMNS INSERT ===
INSERT INTO SCM_MGR.SCM_MST_SHEET_COLUMNS
  (PROGRAM_ID, SHEET_NAME, COLUMN_NAME, COLUMN_LABEL_NAME, SORT_ORDER_NO, COLUMN_WIDTH,
   FIXED_FLAG, VISIBLE_FLAG, HORIZONTAL_ALIGN_CODE, CELL_CONTROL_OBJECT_TYPE_CODE,
   VALID_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT NEW.PROGRAM_ID, NEW.SHEET_NAME, NEW.COLUMN_NAME, NEW.COLUMN_LABEL_NAME, NEW.SORT_ORDER_NO, NEW.COLUMN_WIDTH,
       NEW.FIXED_FLAG, NEW.VISIBLE_FLAG, NEW.HORIZONTAL_ALIGN_CODE, NEW.CELL_CONTROL_OBJECT_TYPE_CODE,
       NEW.VALID_YN, NEW.CREATED_BY, NEW.CREATION_DATE, NEW.LAST_UPDATED_BY, NEW.LAST_UPDATE_DATE
  FROM (
  -- main sheet (Query list, 7 col)
  SELECT 'SYS0013' AS PROGRAM_ID, 'main' AS SHEET_NAME, 'QUERY_ID' AS COLUMN_NAME, 'Query ID' AS COLUMN_LABEL_NAME, 10 AS SORT_ORDER_NO, 100 AS COLUMN_WIDTH, 'N' AS FIXED_FLAG, 'Y' AS VISIBLE_FLAG, 'Center' AS HORIZONTAL_ALIGN_CODE, 'S' AS CELL_CONTROL_OBJECT_TYPE_CODE, 'Y' AS VALID_YN, 'system' AS CREATED_BY, SYSDATE AS CREATION_DATE, 'system' AS LAST_UPDATED_BY, SYSDATE AS LAST_UPDATE_DATE FROM DUAL UNION ALL
  SELECT 'SYS0013','main','QUERY_NAME',    'Query Name',    20, 250,'N','Y','Left',  'S','Y','system',SYSDATE,'system',SYSDATE FROM DUAL UNION ALL
  SELECT 'SYS0013','main','QUERY_CATEGORY','Category',      30, 100,'N','Y','Center','S','Y','system',SYSDATE,'system',SYSDATE FROM DUAL UNION ALL
  SELECT 'SYS0013','main','QUERY_SQL',     'SQL',           40, 400,'N','Y','Left',  'S','Y','system',SYSDATE,'system',SYSDATE FROM DUAL UNION ALL
  SELECT 'SYS0013','main','CREATED_BY',    'Created By',    50, 120,'N','Y','Center','S','Y','system',SYSDATE,'system',SYSDATE FROM DUAL UNION ALL
  SELECT 'SYS0013','main','CREATION_DATE', 'Created At',    60, 140,'N','Y','Center','S','Y','system',SYSDATE,'system',SYSDATE FROM DUAL UNION ALL
  SELECT 'SYS0013','main','USE_YN',        'Use',           70, 60, 'N','Y','Center','S','Y','system',SYSDATE,'system',SYSDATE FROM DUAL UNION ALL
  -- columns sheet (5 col)
  SELECT 'SYS0013','columns','COL_NM',     'Column Name',   10, 150,'N','Y','Left',  'S','Y','system',SYSDATE,'system',SYSDATE FROM DUAL UNION ALL
  SELECT 'SYS0013','columns','COL_HEADER', 'Header',        20, 150,'N','Y','Left',  'S','Y','system',SYSDATE,'system',SYSDATE FROM DUAL UNION ALL
  SELECT 'SYS0013','columns','DATA_TYPE',  'Data Type',     30, 100,'N','Y','Center','S','Y','system',SYSDATE,'system',SYSDATE FROM DUAL UNION ALL
  SELECT 'SYS0013','columns','WIDTH',      'Width',         40,  80,'N','Y','Right', 'S','Y','system',SYSDATE,'system',SYSDATE FROM DUAL UNION ALL
  SELECT 'SYS0013','columns','SORT_ORD',   'Sort',          50,  60,'N','Y','Right', 'S','Y','system',SYSDATE,'system',SYSDATE FROM DUAL UNION ALL
  -- parameters sheet (6 col)
  SELECT 'SYS0013','parameters','PARAM_NM',     'Parameter Name', 10, 150,'N','Y','Left',  'S','Y','system',SYSDATE,'system',SYSDATE FROM DUAL UNION ALL
  SELECT 'SYS0013','parameters','PARAM_LABEL',  'Label',          20, 150,'N','Y','Left',  'S','Y','system',SYSDATE,'system',SYSDATE FROM DUAL UNION ALL
  SELECT 'SYS0013','parameters','DATA_TYPE',    'Data Type',      30, 100,'N','Y','Center','S','Y','system',SYSDATE,'system',SYSDATE FROM DUAL UNION ALL
  SELECT 'SYS0013','parameters','DEFAULT_VALUE','Default',        40, 120,'N','Y','Left',  'S','Y','system',SYSDATE,'system',SYSDATE FROM DUAL UNION ALL
  SELECT 'SYS0013','parameters','REQUIRED_YN',  'Required',       50,  80,'N','Y','Center','S','Y','system',SYSDATE,'system',SYSDATE FROM DUAL UNION ALL
  SELECT 'SYS0013','parameters','SORT_ORD',     'Sort',           60,  60,'N','Y','Right', 'S','Y','system',SYSDATE,'system',SYSDATE FROM DUAL UNION ALL
  -- history sheet (6 col)
  SELECT 'SYS0013','history','HIST_ID',     'Hist ID',     10, 120,'N','Y','Center','S','Y','system',SYSDATE,'system',SYSDATE FROM DUAL UNION ALL
  SELECT 'SYS0013','history','EXECUTED_BY', 'Executed By', 20, 120,'N','Y','Center','S','Y','system',SYSDATE,'system',SYSDATE FROM DUAL UNION ALL
  SELECT 'SYS0013','history','EXECUTED_AT', 'Executed At', 30, 160,'N','Y','Center','S','Y','system',SYSDATE,'system',SYSDATE FROM DUAL UNION ALL
  SELECT 'SYS0013','history','DURATION_MS', 'Duration(ms)',40, 130,'N','Y','Right', 'S','Y','system',SYSDATE,'system',SYSDATE FROM DUAL UNION ALL
  SELECT 'SYS0013','history','ROW_COUNT',   'Rows',        50, 100,'N','Y','Right', 'S','Y','system',SYSDATE,'system',SYSDATE FROM DUAL UNION ALL
  SELECT 'SYS0013','history','STATUS',      'Status',      60, 100,'N','Y','Center','S','Y','system',SYSDATE,'system',SYSDATE FROM DUAL
) NEW
WHERE NOT EXISTS (
  SELECT 1 FROM SCM_MGR.SCM_MST_SHEET_COLUMNS X
   WHERE X.PROGRAM_ID = NEW.PROGRAM_ID
     AND X.SHEET_NAME = NEW.SHEET_NAME
     AND X.COLUMN_NAME = NEW.COLUMN_NAME
);

PROMPT === VERIFY ===
SELECT SHEET_NAME, COUNT(*) AS COL_CNT
  FROM SCM_MGR.SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID='SYS0013'
 GROUP BY SHEET_NAME ORDER BY 1;

COMMIT;
PROMPT === COMPLETE ===
EXIT;
