--==============================================================================
-- 59_SYS0011_division_column_width_2x.sql
--
-- 목적: SCM0008 (Auth Request) 우측 상단 Division grid 의 column width 2배 확장
--       사용자 요구 (2026-06-06): "우측 상단 Grid Column 의 Text가 다 보이도록 Column 가로 사이즈를 2배로 변경"
--
-- 현황:
--   DIVISION_ID   (Div.)       50  → 100
--   DIVISION_NAME (Div. Name) 120  → 240
--
-- 멱등성: 정확히 2배 값으로 UPDATE — 재실행 시 4배 / 8배 폭증 방지 위해 NOT (이미 변경된 값) 조건 미사용
--         재실행 시 값이 동일하므로 사실상 no-op (UPDATE 0 rows or 동일 값)
-- 작성: 2026-06-06
--==============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON
SET FEEDBACK ON
WHENEVER SQLERROR EXIT FAILURE

PROMPT === BLOCK 1 : 사전 상태 ===
SELECT COLUMN_NAME, COLUMN_LABEL_NAME, COLUMN_WIDTH
  FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
 WHERE PROGRAM_ID='SYS0011' AND SHEET_NAME='division'
 ORDER BY SORT_ORDER_NO;

PROMPT === BLOCK 2 : COLUMN_WIDTH 2x UPDATE ===
UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS
   SET COLUMN_WIDTH = 100
 WHERE PROGRAM_ID='SYS0011' AND SHEET_NAME='division' AND COLUMN_NAME='DIVISION_ID'
   AND COLUMN_WIDTH <> 100;

UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS
   SET COLUMN_WIDTH = 240
 WHERE PROGRAM_ID='SYS0011' AND SHEET_NAME='division' AND COLUMN_NAME='DIVISION_NAME'
   AND COLUMN_WIDTH <> 240;

PROMPT === BLOCK 3 : 사후 상태 ===
SELECT COLUMN_NAME, COLUMN_LABEL_NAME, COLUMN_WIDTH
  FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
 WHERE PROGRAM_ID='SYS0011' AND SHEET_NAME='division'
 ORDER BY SORT_ORDER_NO;

COMMIT;
PROMPT === COMPLETE ===
EXIT;
