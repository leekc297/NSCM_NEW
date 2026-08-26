-- =====================================================================================
-- SDM1020 Project List — [02] MNU_M 1행 (SDM > SDM_Project > SDM1020)
-- 2026-08-19 · 상위 SDM(Lv1)/SDM_Project(Lv2) 기존재 확인 완료(INSERT 없음) · 멱등(NOT EXISTS)
-- ROUTE_PATH = NULL 유지 (99_ROUTE_PATH.sql 별도 — FE 완성 후 적용)
-- =====================================================================================
INSERT INTO SCM_MGR.SCM_ADM_MNU_M (MNU_ID, UPPR_MNU_ID, MNU_URL, MNU_MSG_ID, MNU_DESC, SORT_ORD, MNU_LV_NO, MNU_TP_CD, UNIT_TP_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'SDM1020', 'SDM_Project', 'project-list', 'MNU_SDM1020', 'Project List', 2, 3, 'SCREEN', 'D', 'Y', 'admin', SYSDATE, 'admin', SYSDATE FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_MNU_M X WHERE X.MNU_ID = 'SDM1020');

COMMIT;
