-- =============================================================================
-- 100_menu_delete_bk_auto_20260714.sql
-- 목적: 메뉴 3종 삭제 (사용자 요청 2026-07-14)
--   - MKT FCST_bk      → DM0003  (USE_YN=Y, Demand_Plan)
--   - Sales Plan_bk    → DM0021  (USE_YN=Y, Demand_Plan)
--   - MKT FCST (Auto)  → DMF0081 (USE_YN=Y, Demand_Plan — 메뉴에 표시 중인 행)
-- 제외: DMF0003_1 (동일명 'MKT FCST (Auto)' 구버전, USE_YN=N 숨김) — 사용자 미지정으로 보존
-- 연관: SCM_ADM_USER_GR_MNU_MPG_M 각 3행 (ADMIN / DM ADMIN / DM Viewer)
--       SCM_ADM_MNU_BTN_MPG_M / SCM_ADM_USER_GR_MNU_BTN_MPG_M / SCM_ADM_USER_MNU_SRCH_COND_M = 0행 (실측)
--       하위 메뉴 없음 (UPPR_MNU_ID 실측 0행)
-- 멱등: DELETE 는 재실행 안전
-- 원복: 100_menu_delete_bk_auto_ROLLBACK_20260714.sql
-- =============================================================================

DELETE FROM SCM_ADM_USER_GR_MNU_MPG_M
 WHERE MNU_ID IN ('DM0003','DM0021','DMF0081');

DELETE FROM SCM_ADM_MNU_M
 WHERE MNU_ID IN ('DM0003','DM0021','DMF0081');

COMMIT;
