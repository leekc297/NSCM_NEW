-- SYS0014 division/plant/customer UNIT_ID dropdown — 클라우드 적용 통합 SQL
-- 사내 적용 49 + 50 + 51 의 최종 상태를 한 번에 반영 (멱등 — 재실행 안전).
--
-- 변경 내용:
--   (1) UNIT_ID 컬럼을 dropdown (FPComboBox) 으로 전환
--       - CELL_CONTROL_OBJECT_TYPE_CODE = 'FPComboBox'
--       - CELL_COMBO_DATA_TYPE         = 'Division'/'SalesPlant'/'EndCustomer' (SCM_ADM_CMBO_SQL_M 의 SQL_ID)
--       - ATTRIBUTE1                   = NULL
--   (2) INPUT_TP_CD typo 정정: 'MI' → 'IM' (5 row)
--       - 영향: CELL_INPUT_EDIT_TYPE.MANDATORY_INSERT_ONLY = 'IM' enum 매칭. 'MI' 면 isEditableCell 항상 false → editor 미동작.
--       - 영향 row: division/UNIT_ID, plant/UNIT_ID, customer/UNIT_ID, main/USER_GR_ID, userInfo/USER_ID
--
-- 사전 조건: SCM_ADM_CMBO_SQL_M 에 'Division'/'SalesPlant'/'EndCustomer' SQL_ID 등록되어 있어야 함 (기존 등록 상태).

-- ============================================================================
-- (1) UNIT_ID 컬럼 dropdown 전환 (3 sheet × 1 column)
-- ============================================================================
UPDATE SCM_MST_SHEET_COLUMNS
   SET CELL_CONTROL_OBJECT_TYPE_CODE = 'FPComboBox',
       CELL_COMBO_DATA_TYPE          = 'Division',
       ATTRIBUTE1                    = NULL,
       LAST_UPDATED_BY               = 'admin',
       LAST_UPDATE_DATE              = SYSDATE
 WHERE PROGRAM_ID = 'SYS0014' AND SHEET_NAME = 'division' AND COLUMN_NAME = 'UNIT_ID';

UPDATE SCM_MST_SHEET_COLUMNS
   SET CELL_CONTROL_OBJECT_TYPE_CODE = 'FPComboBox',
       CELL_COMBO_DATA_TYPE          = 'SalesPlant',
       ATTRIBUTE1                    = NULL,
       LAST_UPDATED_BY               = 'admin',
       LAST_UPDATE_DATE              = SYSDATE
 WHERE PROGRAM_ID = 'SYS0014' AND SHEET_NAME = 'plant' AND COLUMN_NAME = 'UNIT_ID';

UPDATE SCM_MST_SHEET_COLUMNS
   SET CELL_CONTROL_OBJECT_TYPE_CODE = 'FPComboBox',
       CELL_COMBO_DATA_TYPE          = 'EndCustomer',
       ATTRIBUTE1                    = NULL,
       LAST_UPDATED_BY               = 'admin',
       LAST_UPDATE_DATE              = SYSDATE
 WHERE PROGRAM_ID = 'SYS0014' AND SHEET_NAME = 'customer' AND COLUMN_NAME = 'UNIT_ID';

-- ============================================================================
-- (2) INPUT_TP_CD typo 일괄 정정: 'MI' → 'IM' (5 row)
-- ============================================================================
UPDATE SCM_MST_SHEET_COLUMNS
   SET INPUT_TP_CD     = 'IM',
       LAST_UPDATED_BY = 'admin',
       LAST_UPDATE_DATE = SYSDATE
 WHERE PROGRAM_ID = 'SYS0014'
   AND INPUT_TP_CD = 'MI';

COMMIT;

-- ============================================================================
-- 검증 (적용 후 기대 결과)
-- ============================================================================
SELECT SHEET_NAME, COLUMN_NAME, COLUMN_LABEL_NAME, INPUT_TP_CD,
       CELL_CONTROL_OBJECT_TYPE_CODE, CELL_COMBO_DATA_TYPE, ATTRIBUTE1
  FROM SCM_MST_SHEET_COLUMNS
 WHERE PROGRAM_ID = 'SYS0014'
   AND ( (SHEET_NAME IN ('division','plant','customer') AND COLUMN_NAME = 'UNIT_ID')
      OR (SHEET_NAME = 'main' AND COLUMN_NAME = 'USER_GR_ID')
      OR (SHEET_NAME = 'userInfo' AND COLUMN_NAME = 'USER_ID') )
 ORDER BY SHEET_NAME, COLUMN_NAME;

-- 기대 출력 (5 row):
--   customer  | UNIT_ID    | Customer ID | IM | FPComboBox | EndCustomer | NULL
--   division  | UNIT_ID    | Division ID | IM | FPComboBox | Division    | NULL
--   main      | USER_GR_ID | Group ID    | IM | S          | NULL        | NULL
--   plant     | UNIT_ID    | Plant ID    | IM | FPComboBox | SalesPlant  | NULL
--   userInfo  | USER_ID    | User ID     | IM | S          | NULL        | NULL
