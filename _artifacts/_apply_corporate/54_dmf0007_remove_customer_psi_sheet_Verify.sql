-- ============================================================================
-- 54. DMF0007 — Customer PSI 시트 제거 (VERIFY — 적용 후 검증)
-- ----------------------------------------------------------------------------
-- 기대: 모든 카운트 = 0
-- ============================================================================

SELECT 'SHEET_M'        AS TBL, COUNT(*) AS CNT FROM SCM_MST_SHEET_M           WHERE MENU_ID='DMF0007' AND SHT_NM IN ('customerPSI','customerPsiPivot')
UNION ALL
SELECT 'SHEET_COLUMNS', COUNT(*)             FROM SCM_MST_SHEET_COLUMNS       WHERE MENU_ID='DMF0007' AND SHT_NM IN ('customerPSI','customerPsiPivot')
UNION ALL
SELECT 'API_M',         COUNT(*)             FROM SCM_ADM_API_M               WHERE MNU_ID='DMF0007' AND SHT_NM IN ('customerPSI','customerPsiPivot')
UNION ALL
SELECT 'PROC_M',        COUNT(*)             FROM SCM_ADM_PROC_M
 WHERE PROC_NM LIKE 'P_DMF0007_GET_CUST_PSI%' OR PROC_NM LIKE 'P_DMF0007_SAVE_CUST_PSI%'
UNION ALL
SELECT 'MNU_BTN_MPG',   COUNT(*)             FROM SCM_ADM_MNU_BTN_MPG_M       WHERE MNU_ID='DMF0007' AND SHT_NM IN ('customerPSI','customerPsiPivot')
UNION ALL
SELECT 'USER_GR_BTN',   COUNT(*)             FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M WHERE MNU_ID='DMF0007' AND SHT_NM IN ('customerPSI','customerPsiPivot')
UNION ALL
SELECT 'MSG_M',         COUNT(*)             FROM SCM_ADM_MSG_M               WHERE MSG_ID IN ('LBL_DMF0007_CUSTOMER_PSI','LBL_DMF0007_CUSTOMER_PSI_PIVOT');

-- 잔존 customerFcst 확인 (영향 0 — 정상 유지)
SELECT 'customerFcst SHEET_M'       AS TBL, COUNT(*) AS CNT FROM SCM_MST_SHEET_M           WHERE MENU_ID='DMF0007' AND SHT_NM='customerFcst'
UNION ALL
SELECT 'customerFcst SHEET_COLUMNS',     COUNT(*) FROM SCM_MST_SHEET_COLUMNS WHERE MENU_ID='DMF0007' AND SHT_NM='customerFcst'
UNION ALL
SELECT 'customerFcst API_M',             COUNT(*) FROM SCM_ADM_API_M         WHERE MNU_ID='DMF0007' AND SHT_NM='customerFcst';

-- PKG_DMF0007 의 PSI SP 자체는 보존 — STATUS 확인 (영향 없음, 호출만 끊김)
SELECT OBJECT_NAME, PROCEDURE_NAME, OBJECT_TYPE
  FROM USER_PROCEDURES
 WHERE OBJECT_NAME='PKG_DMF0007'
   AND PROCEDURE_NAME LIKE '%PSI%';
