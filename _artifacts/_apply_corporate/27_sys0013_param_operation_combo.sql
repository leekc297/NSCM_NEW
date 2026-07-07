-- =====================================================================================
-- SYS0013 parameters.OPERATION_ID 드롭다운 메타 보정 (2026-06-28 사용자 요구)
--   Parameters grid 를 admin UI Category Setup(staticColumns) 기준으로 전환하면서
--   OPERATION_ID 가 메타상 CELL_CONTROL_OBJECT_TYPE_CODE='S'(텍스트) → 드롭다운 손실.
--   → FPComboBox + CELL_COMBO_DATA_TYPE='sysOperationOptions' 로 보정(FE comboDataMap 매핑).
--   (FE 하드코딩 staticColumns 제거 → admin 메타 사용. sysOperationOptions 는 FE 상수 OPERATION_OPTIONS)
--   멱등: 이미 FPComboBox 면 0 row. 적용: ora.py exec 27_sys0013_param_operation_combo.sql
-- =====================================================================================
UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS
   SET CELL_CONTROL_OBJECT_TYPE_CODE = 'FPComboBox',
       CELL_COMBO_DATA_TYPE          = 'sysOperationOptions'
 WHERE PROGRAM_ID = 'SYS0013'
   AND SHEET_NAME = 'parameters'
   AND COLUMN_NAME = 'OPERATION_ID';

COMMIT;
