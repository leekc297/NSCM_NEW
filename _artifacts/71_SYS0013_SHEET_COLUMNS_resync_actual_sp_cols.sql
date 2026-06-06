--==============================================================================
-- 71_SYS0013_SHEET_COLUMNS_resync_actual_sp_cols.sql
--
-- 목적: SHEET_COLUMNS binding 이 SP 실제 반환 컬럼과 일치하도록 재등록
--
-- 사고 (2026-06-09 사용자 보고 "columns/parameters/history grid 값 안 보임"):
--   row 는 추가되지만 cell 값이 빈 칸 — SHEET_COLUMNS 의 COLUMN_NAME (binding)
--   이 SP 가 반환하는 실제 컬럼명과 mismatch → wijmo binding 0 match
--
-- SP 실제 반환:
--   COLUMNS: DQ_ID, COLUMN_NAME, VALUE_YN, VALUE_TYPE, VALID_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
--   PARAMETERS: DQ_ID, PARAMETER_ID, PARAMETER_TYPE, OPERATION_ID, VALID_YN, REP_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, SEQNO
--   HISTORY: HISTORY_SEQ, DQ_ID, DQ_TEXT, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
--
-- 작성: 2026-06-09
--==============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON
SET FEEDBACK ON
WHENEVER SQLERROR EXIT FAILURE

PROMPT === DELETE 기존 (잘못된 binding) SHEET_COLUMNS ===
DELETE FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
 WHERE PROGRAM_ID='SYS0013'
   AND SHEET_NAME IN ('columns','parameters','history');

PROMPT === INSERT 정정 SHEET_COLUMNS ===
INSERT INTO SCM_MGR.SCM_MST_SHEET_COLUMNS
  (PROGRAM_ID, SHEET_NAME, COLUMN_NAME, COLUMN_LABEL_NAME, SORT_ORDER_NO, COLUMN_WIDTH,
   FIXED_FLAG, VISIBLE_FLAG, HORIZONTAL_ALIGN_CODE, CELL_CONTROL_OBJECT_TYPE_CODE,
   VALID_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT NEW.PROGRAM_ID, NEW.SHEET_NAME, NEW.COLUMN_NAME, NEW.COLUMN_LABEL_NAME, NEW.SORT_ORDER_NO, NEW.COLUMN_WIDTH,
       NEW.FIXED_FLAG, NEW.VISIBLE_FLAG, NEW.HORIZONTAL_ALIGN_CODE, NEW.CELL_CONTROL_OBJECT_TYPE_CODE,
       NEW.VALID_YN, NEW.CREATED_BY, NEW.CREATION_DATE, NEW.LAST_UPDATED_BY, NEW.LAST_UPDATE_DATE
  FROM (
  -- COLUMNS sheet (SP: DQ_ID, COLUMN_NAME, VALUE_YN, VALUE_TYPE, VALID_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
  SELECT 'SYS0013' AS PROGRAM_ID, 'columns' AS SHEET_NAME, 'DQ_ID' AS COLUMN_NAME, 'DQ ID' AS COLUMN_LABEL_NAME, 10 AS SORT_ORDER_NO, 80 AS COLUMN_WIDTH, 'N' AS FIXED_FLAG, 'N' AS VISIBLE_FLAG, 'Center' AS HORIZONTAL_ALIGN_CODE, 'S' AS CELL_CONTROL_OBJECT_TYPE_CODE, 'Y' AS VALID_YN, 'system' AS CREATED_BY, SYSDATE AS CREATION_DATE, 'system' AS LAST_UPDATED_BY, SYSDATE AS LAST_UPDATE_DATE FROM DUAL UNION ALL
  SELECT 'SYS0013','columns','COLUMN_NAME',      'Column Name',  20, 200,'N','Y','Left',  'S','Y','system',SYSDATE,'system',SYSDATE FROM DUAL UNION ALL
  SELECT 'SYS0013','columns','VALUE_YN',         'Value Y/N',    30,  80,'N','Y','Center','S','Y','system',SYSDATE,'system',SYSDATE FROM DUAL UNION ALL
  SELECT 'SYS0013','columns','VALUE_TYPE',       'Value Type',   40, 120,'N','Y','Center','S','Y','system',SYSDATE,'system',SYSDATE FROM DUAL UNION ALL
  SELECT 'SYS0013','columns','VALID_YN',         'Valid',        50,  80,'N','Y','Center','S','Y','system',SYSDATE,'system',SYSDATE FROM DUAL UNION ALL
  SELECT 'SYS0013','columns','CREATED_BY',       'Created By',   60, 120,'N','Y','Center','S','Y','system',SYSDATE,'system',SYSDATE FROM DUAL UNION ALL
  SELECT 'SYS0013','columns','CREATION_DATE',    'Created At',   70, 160,'N','Y','Center','S','Y','system',SYSDATE,'system',SYSDATE FROM DUAL UNION ALL
  -- PARAMETERS sheet
  SELECT 'SYS0013','parameters','DQ_ID',         'DQ ID',        10,  80,'N','N','Center','S','Y','system',SYSDATE,'system',SYSDATE FROM DUAL UNION ALL
  SELECT 'SYS0013','parameters','PARAMETER_ID',  'Parameter ID', 20, 180,'N','Y','Left',  'S','Y','system',SYSDATE,'system',SYSDATE FROM DUAL UNION ALL
  SELECT 'SYS0013','parameters','PARAMETER_TYPE','Type',         30, 120,'N','Y','Center','S','Y','system',SYSDATE,'system',SYSDATE FROM DUAL UNION ALL
  SELECT 'SYS0013','parameters','OPERATION_ID',  'Operation',    40, 120,'N','Y','Center','S','Y','system',SYSDATE,'system',SYSDATE FROM DUAL UNION ALL
  SELECT 'SYS0013','parameters','VALID_YN',      'Valid',        50,  80,'N','Y','Center','S','Y','system',SYSDATE,'system',SYSDATE FROM DUAL UNION ALL
  SELECT 'SYS0013','parameters','REP_YN',        'Rep',          60,  80,'N','Y','Center','S','Y','system',SYSDATE,'system',SYSDATE FROM DUAL UNION ALL
  SELECT 'SYS0013','parameters','SEQNO',         'Seq',          70,  60,'N','Y','Right', 'S','Y','system',SYSDATE,'system',SYSDATE FROM DUAL UNION ALL
  SELECT 'SYS0013','parameters','CREATED_BY',    'Created By',   80, 120,'N','Y','Center','S','Y','system',SYSDATE,'system',SYSDATE FROM DUAL UNION ALL
  -- HISTORY sheet
  SELECT 'SYS0013','history','HISTORY_SEQ',      'History Seq',  10, 100,'N','Y','Right', 'S','Y','system',SYSDATE,'system',SYSDATE FROM DUAL UNION ALL
  SELECT 'SYS0013','history','DQ_ID',            'DQ ID',        20,  80,'N','N','Right', 'S','Y','system',SYSDATE,'system',SYSDATE FROM DUAL UNION ALL
  SELECT 'SYS0013','history','DQ_TEXT',          'Query Text',   30, 400,'N','Y','Left',  'S','Y','system',SYSDATE,'system',SYSDATE FROM DUAL UNION ALL
  SELECT 'SYS0013','history','CREATED_BY',       'Executed By',  40, 120,'N','Y','Center','S','Y','system',SYSDATE,'system',SYSDATE FROM DUAL UNION ALL
  SELECT 'SYS0013','history','CREATION_DATE',    'Executed At',  50, 160,'N','Y','Center','S','Y','system',SYSDATE,'system',SYSDATE FROM DUAL
  ) NEW;

PROMPT === VERIFY ===
SELECT SHEET_NAME, COUNT(*) AS COL_CNT
  FROM SCM_MGR.SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID='SYS0013'
 GROUP BY SHEET_NAME ORDER BY 1;

COMMIT;
PROMPT === COMPLETE ===
EXIT;
