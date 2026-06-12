-- SYS0014 division/plant/customer 의 UNIT_ID 컬럼을 lookup combo (FPComboBox) 로 전환
-- 정책: 모든 컬럼 속성 = UI Category Setup (SYS0004) 에서 관리
-- BE MenuServiceImpl.resolveComboBoxDataMaps 가 ATTRIBUTE1=SQL_ID 자동 resolve
-- 매핑 (SCM_ADM_CMBO_SQL_M 등록 SQL_ID):
--   division   → 'Division'      (전체 Division 목록)
--   plant      → 'SalesPlant'    (사용자 권한 Plant)
--   customer   → 'EndCustomer'   (End Customer)

UPDATE SCM_MST_SHEET_COLUMNS
   SET CELL_CONTROL_OBJECT_TYPE_CODE = 'FPComboBox',
       ATTRIBUTE1                    = 'Division',
       LAST_UPDATED_BY               = 'admin',
       LAST_UPDATE_DATE              = SYSDATE
 WHERE PROGRAM_ID = 'SYS0014'
   AND SHEET_NAME = 'division'
   AND COLUMN_NAME = 'UNIT_ID';

UPDATE SCM_MST_SHEET_COLUMNS
   SET CELL_CONTROL_OBJECT_TYPE_CODE = 'FPComboBox',
       ATTRIBUTE1                    = 'SalesPlant',
       LAST_UPDATED_BY               = 'admin',
       LAST_UPDATE_DATE              = SYSDATE
 WHERE PROGRAM_ID = 'SYS0014'
   AND SHEET_NAME = 'plant'
   AND COLUMN_NAME = 'UNIT_ID';

UPDATE SCM_MST_SHEET_COLUMNS
   SET CELL_CONTROL_OBJECT_TYPE_CODE = 'FPComboBox',
       ATTRIBUTE1                    = 'EndCustomer',
       LAST_UPDATED_BY               = 'admin',
       LAST_UPDATE_DATE              = SYSDATE
 WHERE PROGRAM_ID = 'SYS0014'
   AND SHEET_NAME = 'customer'
   AND COLUMN_NAME = 'UNIT_ID';

COMMIT;

-- 검증
SELECT SHEET_NAME, COLUMN_NAME, COLUMN_LABEL_NAME, INPUT_TP_CD,
       CELL_CONTROL_OBJECT_TYPE_CODE, ATTRIBUTE1
  FROM SCM_MST_SHEET_COLUMNS
 WHERE PROGRAM_ID = 'SYS0014'
   AND SHEET_NAME IN ('division','plant','customer')
   AND COLUMN_NAME = 'UNIT_ID'
 ORDER BY SHEET_NAME;
