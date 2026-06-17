-- 2026-06-16 — DMF0003 Column 속성 룰 적용 누락분 보정
-- 사용자 명시: Insert 시 cell object type 적용 누락 (예: END_CUSTOMER FPComboBox dropdown 미동작)
-- 룰 (메모리):
--   feedback_column_lookup_meta_standard.md — combo SQL_ID 는 CELL_COMBO_DATA_TYPE 위치 (ATTRIBUTE 금지)
--   feedback_input_tp_cd_im_standard.md     — 신규 Insert 필수 = INPUT_TP_CD 'IM' (Mandatory Insert)

-- ============================================================
-- BLOCK 1) INPUT_TP_CD 'S' (read only) → 'IM' (Mandatory Insert)
--   신규 Insert row 의 셀이 cell editor 진입 가능하도록.
--   대상: lookup column (popup / combo 측 신규 row 의무 입력)
-- ============================================================
UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS
   SET INPUT_TP_CD     = 'IM',
       LAST_UPDATED_BY = 'system',
       LAST_UPDATE_DATE = SYSDATE
 WHERE PROGRAM_ID = 'DMF0003'
   AND SHEET_NAME = 'main'
   AND COLUMN_NAME IN (
       'END_CUSTOMER', 'SCM_SITE_ID', 'PROJECT_CODE', 'ITEM_ID',
       'INCOTERMS', 'FCST_TYPE', 'DOM_EXP', 'PLANT_SITE_ID',
       'BIZ_TYPE', 'TEAM_ID'
   )
   AND INPUT_TP_CD = 'S';

-- ============================================================
-- BLOCK 2) PROJECT_CODE — CELL_TP 'FPTextBox' → 'FPModal' + CBO_TP 'ProjectByDivision'
--   popup 더블클릭 → ProjectByDivisionModal 호출
-- ============================================================
UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS
   SET CELL_CONTROL_OBJECT_TYPE_CODE = 'FPModal',
       CELL_COMBO_DATA_TYPE          = 'ProjectByDivision',
       LAST_UPDATED_BY  = 'system',
       LAST_UPDATE_DATE = SYSDATE
 WHERE PROGRAM_ID = 'DMF0003'
   AND SHEET_NAME = 'main'
   AND COLUMN_NAME = 'PROJECT_CODE';

-- ============================================================
-- BLOCK 3) ITEM_ID — CELL_TP 'FPTextBox' → 'FPModal' + CBO_TP 'ItemByDivision'
-- ============================================================
UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS
   SET CELL_CONTROL_OBJECT_TYPE_CODE = 'FPModal',
       CELL_COMBO_DATA_TYPE          = 'ItemByDivision',
       LAST_UPDATED_BY  = 'system',
       LAST_UPDATE_DATE = SYSDATE
 WHERE PROGRAM_ID = 'DMF0003'
   AND SHEET_NAME = 'main'
   AND COLUMN_NAME = 'ITEM_ID';

COMMIT;
