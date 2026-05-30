-- =============================================================================
-- 38_Cleanup_MNU_MASTER_DBeaver_Diagnose.sql
-- DBeaver 진단용 — 삭제 전/후 상황 파악
-- =============================================================================

-- 1. master / Master 양쪽 root row 비교
SELECT MNU_ID, UPPR_MNU_ID, MNU_LV_NO, MNU_URL, MNU_TP_CD, MNU_MSG_ID, USE_YN
  FROM SCM_MGR.SCM_ADM_MNU_M
 WHERE MNU_ID IN ('master','Master','DEMAND_MASTER','Demand_Master')
 ORDER BY MNU_LV_NO, MNU_ID;

-- 2. master 트리 권한 매핑
SELECT 'USER_GR_MNU_MPG_M' AS TBL, MNU_ID, USER_GR_ID
  FROM SCM_MGR.SCM_ADM_USER_GR_MNU_MPG_M
 WHERE MNU_ID IN ('master','DEMAND_MASTER');

-- 3. 가짜 메뉴의 i18n 등록 여부 (모두 0건이어야 정상 = 청소 가능)
SELECT 'SCM_ADM_MSG_M' AS TBL, MSG_ID, LANG_CD, MSG_NM
  FROM SCM_MGR.SCM_ADM_MSG_M
 WHERE MSG_ID IN ('MNU_MASTER','MNU_DEMAND_MASTER');

-- 4. Master (대문자) 진짜 트리 (참고 — 변경 없음)
SELECT LPAD(' ', (MNU_LV_NO-1)*2) || MNU_ID AS PATH,
       UPPR_MNU_ID, MNU_LV_NO, MNU_URL, MNU_MSG_ID, USE_YN
  FROM SCM_MGR.SCM_ADM_MNU_M
 START WITH MNU_ID = 'Master'
 CONNECT BY PRIOR MNU_ID = UPPR_MNU_ID
 ORDER SIBLINGS BY MNU_ID;
