-- ============================================================================
-- 54. DMF0007 — Customer PSI / Customer PSI (Pivot) sheet 제거 (DIAGNOSE)
-- ----------------------------------------------------------------------------
-- 목적   : DELETE 실행 전 영향 범위 (메타 row 수) 사전 점검
-- 작성   : 2026-06-15 (사용자 요건 — DMF0007 Customer PSI 탭 제거)
-- 대상   : 사내 Oracle (121.162.245.167:2521/ESSCMD), user SCM_MGR
-- 적용   : DBeaver 또는 sqlplus 로 SELECT 만 실행 — DML 없음
-- ============================================================================

-- 1. SCM_MST_SHEET_M — sheet 자체
SELECT 'SCM_MST_SHEET_M' AS TBL, MENU_ID, SHT_NM, SHT_DESC
  FROM SCM_MST_SHEET_M
 WHERE MENU_ID = 'DMF0007'
   AND SHT_NM IN ('customerPSI','customerPsiPivot');

-- 2. SCM_MST_SHEET_COLUMNS — sheet 컬럼 메타
SELECT 'SCM_MST_SHEET_COLUMNS' AS TBL, MENU_ID, SHT_NM, COLUMN_NAME, SORT_ORD
  FROM SCM_MST_SHEET_COLUMNS
 WHERE MENU_ID = 'DMF0007'
   AND SHT_NM IN ('customerPSI','customerPsiPivot')
 ORDER BY SHT_NM, SORT_ORD;

-- 3. SCM_ADM_API_M — API 매핑
SELECT 'SCM_ADM_API_M' AS TBL, MNU_ID, SHT_NM, API_NM, API_URL
  FROM SCM_ADM_API_M
 WHERE MNU_ID = 'DMF0007'
   AND SHT_NM IN ('customerPSI','customerPsiPivot');

-- 4. SCM_ADM_PROC_M — PROC 메타
SELECT 'SCM_ADM_PROC_M' AS TBL, PROC_NM, COL_NM, COL_TP_CD, SORT_ORD
  FROM SCM_ADM_PROC_M
 WHERE PROC_NM IN (SELECT API_URL FROM SCM_ADM_API_M
                    WHERE MNU_ID = 'DMF0007'
                      AND SHT_NM IN ('customerPSI','customerPsiPivot'))
 ORDER BY PROC_NM, SORT_ORD;

-- 5. SCM_ADM_MNU_BTN_MPG_M — 버튼 매핑 (sheet 단위)
SELECT 'SCM_ADM_MNU_BTN_MPG_M' AS TBL, MNU_ID, SHT_NM, MNU_BTN_CD
  FROM SCM_ADM_MNU_BTN_MPG_M
 WHERE MNU_ID = 'DMF0007'
   AND SHT_NM IN ('customerPSI','customerPsiPivot');

-- 6. SCM_ADM_USER_GR_MNU_BTN_MPG_M — 권한 cascade
SELECT 'SCM_ADM_USER_GR_MNU_BTN_MPG_M' AS TBL, COUNT(*) AS CNT
  FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M
 WHERE MNU_ID = 'DMF0007'
   AND SHT_NM IN ('customerPSI','customerPsiPivot');

-- 7. SCM_ADM_MSG_M — i18n LBL (LBL_DMF0007_CUSTOMER_PSI / LBL_DMF0007_CUSTOMER_PSI_PIVOT)
SELECT 'SCM_ADM_MSG_M' AS TBL, MSG_ID, LANG_CD, MSG_NM
  FROM SCM_ADM_MSG_M
 WHERE MSG_ID IN ('LBL_DMF0007_CUSTOMER_PSI','LBL_DMF0007_CUSTOMER_PSI_PIVOT')
 ORDER BY MSG_ID, LANG_CD;

-- 8. SP 인벤토리 — 보존 대상 확인 (DROP 하지 않음, 참고용)
SELECT 'USER_PROCEDURES' AS TBL, OBJECT_NAME, PROCEDURE_NAME, STATUS
  FROM USER_PROCEDURES
 WHERE OBJECT_NAME = 'PKG_DMF0007'
   AND PROCEDURE_NAME LIKE '%PSI%'
 ORDER BY PROCEDURE_NAME;
