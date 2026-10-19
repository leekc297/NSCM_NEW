-- =====================================================================================
-- [PARTIALPLAN82] 원복 — DMF0005 / production_82 / PARTIAL_PLAN_YN 행 제거
-- 적용 전 상태 = 해당 행 없음 (2026-10-14 사내 ZIOUI1 조회)
-- 01_MERGE 가 넣은 행(CREATED_BY 'admin')만 지운다.
-- =====================================================================================

DELETE FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
 WHERE PROGRAM_ID  = 'DMF0005'
   AND SHEET_NAME  = 'production_82'
   AND COLUMN_NAME = 'PARTIAL_PLAN_YN'
   AND CREATED_BY  = 'admin';

COMMIT;
