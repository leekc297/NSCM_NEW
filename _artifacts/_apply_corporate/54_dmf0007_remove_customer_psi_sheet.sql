-- ============================================================================
-- 54. DMF0007 — Customer PSI / Customer PSI (Pivot) sheet 제거 (APPLY)
-- ----------------------------------------------------------------------------
-- 목적   : DMF0007 화면의 customerPSI / customerPsiPivot 시트 메타 일괄 제거
-- 작성   : 2026-06-15 (사용자 요건 — DMF0007 Customer PSI 탭 제거)
-- 대상   : 사내 Oracle (121.162.245.167:2521/ESSCMD), user SCM_MGR
-- 적용   : apply.sh 54_dmf0007_remove_customer_psi_sheet  (docker exec sqlplus)
-- 검증   : 54_..._Verify.sql 실행 후 모든 카운트 = 0
-- 보존   : PKG_DMF0007 의 P_DMF0007_GET_CUST_PSI* / SAVE SP 자체는 DROP 하지 않음
-- 원복   : git revert + i18n 라벨/메타 재INSERT (백업: ..._Verify 의 0건 확인 전)
-- ============================================================================

SET DEFINE OFF;
SET SERVEROUTPUT ON;

DECLARE
  v_api_count   PLS_INTEGER := 0;
  v_proc_count  PLS_INTEGER := 0;
  v_sht_count   PLS_INTEGER := 0;
  v_col_count   PLS_INTEGER := 0;
  v_btn_count   PLS_INTEGER := 0;
  v_perm_count  PLS_INTEGER := 0;
  v_msg_count   PLS_INTEGER := 0;
BEGIN
  -- 1. SCM_ADM_PROC_M — API_M 의 API_URL 참조 기반 cascade DELETE
  DELETE FROM SCM_ADM_PROC_M
   WHERE PROC_NM IN (SELECT API_URL FROM SCM_ADM_API_M
                      WHERE MNU_ID = 'DMF0007'
                        AND SHT_NM IN ('customerPSI','customerPsiPivot'));
  v_proc_count := SQL%ROWCOUNT;

  -- 2. SCM_ADM_API_M
  DELETE FROM SCM_ADM_API_M
   WHERE MNU_ID = 'DMF0007'
     AND SHT_NM IN ('customerPSI','customerPsiPivot');
  v_api_count := SQL%ROWCOUNT;

  -- 3. SCM_ADM_USER_GR_MNU_BTN_MPG_M (권한 cascade — FK 가 없어도 메타 정합성 보장)
  DELETE FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M
   WHERE MNU_ID = 'DMF0007'
     AND SHT_NM IN ('customerPSI','customerPsiPivot');
  v_perm_count := SQL%ROWCOUNT;

  -- 4. SCM_ADM_MNU_BTN_MPG_M
  DELETE FROM SCM_ADM_MNU_BTN_MPG_M
   WHERE MNU_ID = 'DMF0007'
     AND SHT_NM IN ('customerPSI','customerPsiPivot');
  v_btn_count := SQL%ROWCOUNT;

  -- 5. SCM_MST_SHEET_COLUMNS
  DELETE FROM SCM_MST_SHEET_COLUMNS
   WHERE MENU_ID = 'DMF0007'
     AND SHT_NM IN ('customerPSI','customerPsiPivot');
  v_col_count := SQL%ROWCOUNT;

  -- 6. SCM_MST_SHEET_M
  DELETE FROM SCM_MST_SHEET_M
   WHERE MENU_ID = 'DMF0007'
     AND SHT_NM IN ('customerPSI','customerPsiPivot');
  v_sht_count := SQL%ROWCOUNT;

  -- 7. SCM_ADM_MSG_M — i18n LBL (KO/EN/CN 모든 언어 동시)
  DELETE FROM SCM_ADM_MSG_M
   WHERE MSG_ID IN ('LBL_DMF0007_CUSTOMER_PSI','LBL_DMF0007_CUSTOMER_PSI_PIVOT');
  v_msg_count := SQL%ROWCOUNT;

  DBMS_OUTPUT.PUT_LINE('SCM_ADM_PROC_M deleted             : ' || v_proc_count);
  DBMS_OUTPUT.PUT_LINE('SCM_ADM_API_M deleted              : ' || v_api_count);
  DBMS_OUTPUT.PUT_LINE('SCM_ADM_USER_GR_MNU_BTN_MPG_M del  : ' || v_perm_count);
  DBMS_OUTPUT.PUT_LINE('SCM_ADM_MNU_BTN_MPG_M deleted      : ' || v_btn_count);
  DBMS_OUTPUT.PUT_LINE('SCM_MST_SHEET_COLUMNS deleted      : ' || v_col_count);
  DBMS_OUTPUT.PUT_LINE('SCM_MST_SHEET_M deleted            : ' || v_sht_count);
  DBMS_OUTPUT.PUT_LINE('SCM_ADM_MSG_M deleted              : ' || v_msg_count);

  COMMIT;
END;
