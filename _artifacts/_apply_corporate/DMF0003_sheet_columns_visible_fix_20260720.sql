-- =====================================================================
-- DMF0003 SHEET_COLUMNS VISIBLE 플래그 이관 오류 정정 (2026-07-20)
--   증상: W/S(및 DM Planner/DM ADMIN) 편집모드 진입 시 MSG00113 "필수 입력 컬럼이 없습니다."
--   원인: EditButton 필수 Column Check(.cs L891~) — 사업부 필수컬럼이 그리드에 없으면 차단.
--         AS-IS 는 PROJECT_CODE·PLANT_SITE_ID·AS_FROM_SITE 가 VISIBLE='Y'(항상 그리드 존재)인데,
--         TO-BE 이관 메타에서 VISIBLE='N' 으로 뒤집힘. 이들은 DEFAULT_FLAG 이 NULL 이 아니라
--         GET_SPREAD_TITLE 의 시스템 숨김컬럼 강제포함 경로(조건 VISIBLE='N' AND DEFAULT_FLAG IS NULL)
--         에도 안 걸려서, 사용자 titleset 에 없으면 그리드에서 완전히 빠짐 → 필수컬럼 검사 실패.
--   정정: AS-IS 기준값으로 복원 (사용자 확인 2026-07-20).
--         AS_FROM_SITE  : VISIBLE='Y', DEFAULT='Y'  (AS-IS Y/Y/Y — USER_SELECTABLE 이미 Y)
--         PROJECT_CODE  : VISIBLE='Y'               (DEFAULT 이미 Y)
--         PLANT_SITE_ID : VISIBLE='Y'               (DEFAULT 이미 Y)
--   멱등. 감사 'admin'.
-- =====================================================================
UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS
   SET VISIBLE_FLAG = 'Y', DEFAULT_FLAG = 'Y',
       LAST_UPDATED_BY = 'admin', LAST_UPDATE_DATE = SYSDATE
 WHERE PROGRAM_ID = 'DMF0003' AND SHEET_NAME = 'Mkt Fcst' AND COLUMN_NAME = 'AS_FROM_SITE';

UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS
   SET VISIBLE_FLAG = 'Y',
       LAST_UPDATED_BY = 'admin', LAST_UPDATE_DATE = SYSDATE
 WHERE PROGRAM_ID = 'DMF0003' AND SHEET_NAME = 'Mkt Fcst'
   AND COLUMN_NAME IN ('PROJECT_CODE', 'PLANT_SITE_ID')
   AND VISIBLE_FLAG = 'N';

COMMIT;
