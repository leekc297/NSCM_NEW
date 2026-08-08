-- ============================================================================
-- 01 SCM_ADM_MNU_M — DMF0042 (1행, KEY=['MNU_ID'])
-- 생성: 2026-08-05 (사내 OCGSCMD_P01 실측 덤프 — 기억/추측 아님)
-- 원칙: 클라우드 INSERT-only 멱등 (기존재 row 무변경, KEY NOT EXISTS)
-- ============================================================================
INSERT INTO SCM_MGR.SCM_ADM_MNU_M (MNU_ID, UPPR_MNU_ID, MNU_URL, SYS_MNUL_URL, MNU_MSG_ID, MNU_DESC, SORT_ORD, MNU_LV_NO, MNU_TP_CD, UNIT_TP_CD, USE_YN, N01_ATR_CTN, N02_ATR_CTN, N03_ATR_CTN, N04_ATR_CTN, N05_ATR_CTN, N06_ATR_CTN, N07_ATR_CTN, N08_ATR_CTN, N09_ATR_CTN, N10_ATR_CTN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ROUTE_PATH)
SELECT 'DMF0042', 'Demand_Plan', 'business-plan', NULL, 'MNU00014', 'Business Plan', 5, 3, 'SCREEN', 'D', 'Y', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'hwi1993', TO_DATE('2019-09-19 12:49:58','YYYY-MM-DD HH24:MI:SS'), 'admin', TO_DATE('2026-07-21 23:02:42','YYYY-MM-DD HH24:MI:SS'), 'demand/demand-plan/business-plan' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_MNU_M X WHERE X.MNU_ID='DMF0042');

COMMIT;
