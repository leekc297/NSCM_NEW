-- SYS0014 INPUT_TP_CD typo 정정: 'MI' → 'IM' (Mandatory Insert Only)
-- 원인: CELL_INPUT_EDIT_TYPE.MANDATORY_INSERT_ONLY = 'IM' (FE enum)
--       SYS0014 메타에 'MI' 로 등록되어 있어 isEditableCell 항상 false → cell editor 영원히 미동작
-- 영향: division/plant/customer UNIT_ID + main/USER_GR_ID + userInfo/USER_ID (5 row)
-- 다른 화면 (141개) 은 모두 'IM' 정상 사용 — SYS0014 한정 typo.

UPDATE SCM_MST_SHEET_COLUMNS
   SET INPUT_TP_CD     = 'IM',
       LAST_UPDATED_BY = 'admin',
       LAST_UPDATE_DATE = SYSDATE
 WHERE PROGRAM_ID = 'SYS0014'
   AND INPUT_TP_CD = 'MI';

COMMIT;

-- 검증
SELECT SHEET_NAME, COLUMN_NAME, INPUT_TP_CD
  FROM SCM_MST_SHEET_COLUMNS
 WHERE PROGRAM_ID = 'SYS0014'
   AND COLUMN_NAME IN ('UNIT_ID','USER_GR_ID','USER_ID')
 ORDER BY SHEET_NAME;
