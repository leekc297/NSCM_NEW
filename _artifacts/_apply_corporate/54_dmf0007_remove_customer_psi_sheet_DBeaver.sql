-- ============================================================================
-- 54. DMF0007 — Customer PSI 시트 제거 (DBeaver 적용용)
-- ----------------------------------------------------------------------------
-- 사용법: DBeaver 에서 한 줄씩 또는 PL/SQL BLOCK 전체 실행
-- ============================================================================

-- 사전 확인 (선택) — 영향 row 수 미리 보기
-- SELECT COUNT(*) FROM SCM_MST_SHEET_M           WHERE MENU_ID='DMF0007' AND SHT_NM IN ('customerPSI','customerPsiPivot');
-- SELECT COUNT(*) FROM SCM_MST_SHEET_COLUMNS     WHERE MENU_ID='DMF0007' AND SHT_NM IN ('customerPSI','customerPsiPivot');
-- SELECT COUNT(*) FROM SCM_ADM_API_M             WHERE MNU_ID='DMF0007' AND SHT_NM IN ('customerPSI','customerPsiPivot');

BEGIN
  DELETE FROM SCM_ADM_PROC_M
   WHERE PROC_NM IN (SELECT API_URL FROM SCM_ADM_API_M
                      WHERE MNU_ID='DMF0007'
                        AND SHT_NM IN ('customerPSI','customerPsiPivot'));

  DELETE FROM SCM_ADM_API_M
   WHERE MNU_ID='DMF0007'
     AND SHT_NM IN ('customerPSI','customerPsiPivot');

  DELETE FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M
   WHERE MNU_ID='DMF0007'
     AND SHT_NM IN ('customerPSI','customerPsiPivot');

  DELETE FROM SCM_ADM_MNU_BTN_MPG_M
   WHERE MNU_ID='DMF0007'
     AND SHT_NM IN ('customerPSI','customerPsiPivot');

  DELETE FROM SCM_MST_SHEET_COLUMNS
   WHERE MENU_ID='DMF0007'
     AND SHT_NM IN ('customerPSI','customerPsiPivot');

  DELETE FROM SCM_MST_SHEET_M
   WHERE MENU_ID='DMF0007'
     AND SHT_NM IN ('customerPSI','customerPsiPivot');

  DELETE FROM SCM_ADM_MSG_M
   WHERE MSG_ID IN ('LBL_DMF0007_CUSTOMER_PSI','LBL_DMF0007_CUSTOMER_PSI_PIVOT');

  COMMIT;
END;

-- 사후 검증: 위 7 SELECT 모두 0 인지 확인 (54_..._Verify.sql 참조)
