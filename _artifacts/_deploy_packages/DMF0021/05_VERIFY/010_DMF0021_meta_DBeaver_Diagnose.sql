--==============================================================================
-- 010_DMF0021_meta_DBeaver_Diagnose.sql — DMF0021 SalesPlan 진단
-- 작성 (Option A 정밀화 — 2026-06-09): DMF0048 패턴 복제 + Step 4.5~4.7 부모 메뉴 + FIX SQL
--==============================================================================

-- =====================================================================
-- Step 1: MNU_URL (slug only — leaf slug, full path 금지)
-- =====================================================================
SELECT 'Step1: MNU_URL' AS STEP, MNU_ID, MNU_URL,
       CASE WHEN MNU_URL = 'sales-plan' THEN 'OK'
            ELSE 'FAIL — expected "sales-plan" (slug only, not full path)' END AS STATUS
  FROM SCM_MGR.SCM_ADM_MNU_M WHERE MNU_ID='DMF0021';

-- =====================================================================
-- Step 1.5: UPPR_MNU_ID case 정합 (자매 화면 표준 "Demand_Plan")
--   ⚠️ "DEMAND_PLAN" (대문자) 또는 "demand_plan" (소문자) → 메뉴 미표시
--   메모리 feedback_mnu_uppr_case_standard
-- =====================================================================
SELECT 'Step1.5: UPPR_MNU_ID case' AS STEP, MNU_ID, UPPR_MNU_ID,
       CASE WHEN UPPR_MNU_ID = 'Demand_Plan' THEN 'OK'
            ELSE 'CASE FIX REQUIRED — expected "Demand_Plan" (capital D + P)' END AS STATUS
  FROM SCM_MGR.SCM_ADM_MNU_M WHERE MNU_ID='DMF0021';

-- 자매 화면 cross-check (DMF0048 / DMF0014 / DMF0003 / DMF0007 모두 'Demand_Plan')
SELECT 'Step1.5+: Sibling UPPR_MNU_ID' AS STEP, MNU_ID, UPPR_MNU_ID
  FROM SCM_MGR.SCM_ADM_MNU_M
 WHERE MNU_ID IN ('DMF0021', 'DMF0048', 'DMF0014', 'DMF0003', 'DMF0007')
 ORDER BY MNU_ID;

-- =====================================================================
-- Step 1.6: SHT_NM 자매 표준 ('main')
--   ⚠️ FE constants.ts 의 SHEETS.MAIN='main' 과 DB SCM_ADM_MNU_BTN_MPG_M.SHT_NM 정합 필수
--   불일치 시 ORA-01403 at PKG_NSCM_UI_COMM:17 (retrieveBtnInfoList)
--   메모리 feedback_sheet_name_main_standard
-- =====================================================================
SELECT 'Step1.6: SHT_NM' AS STEP, SHT_NM, COUNT(*) AS BTN_CNT
  FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID='DMF0021' GROUP BY SHT_NM;

-- =====================================================================
-- Step 1.7: MNU_DESC NULL 검증 (FE 사이드바 표시 의무)
--   메모리 feedback_mnu_desc_required
-- =====================================================================
SELECT 'Step1.7: MNU_DESC NULL' AS STEP, MNU_ID, MNU_NM, MNU_DESC,
       CASE WHEN MNU_DESC IS NULL OR LENGTH(TRIM(MNU_DESC))=0 THEN 'FIX REQUIRED'
            ELSE 'OK' END AS STATUS
  FROM SCM_MGR.SCM_ADM_MNU_M WHERE MNU_ID='DMF0021';

-- =====================================================================
-- Step 2: 라우터 — FE route-paths.ts cross-check (수동 grep)
--   grep -n "DMF0021" nscm-fe/packages/foundation/src/constants/route-paths.ts
--   → expected: DMF0021: 'sales-plan'
-- =====================================================================

-- =====================================================================
-- Step 3: 메뉴 권한 (USER_GR_MNU_MPG_M)
-- =====================================================================
SELECT 'Step3: Menu Permission' AS STEP, USER_GR_ID, MNU_ID
  FROM SCM_MGR.SCM_ADM_USER_GR_MNU_MPG_M WHERE MNU_ID='DMF0021';

SELECT 'Step3: Btn Permission' AS STEP, USER_GR_ID, MNU_ID, BTN_ID
  FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M WHERE MNU_ID='DMF0021' ORDER BY USER_GR_ID, BTN_ID;

-- =====================================================================
-- Step 4: 부모 권한 (Demand / Demand_Plan)
-- =====================================================================
SELECT 'Step4: Parent Permission' AS STEP, USER_GR_ID, MNU_ID
  FROM SCM_MGR.SCM_ADM_USER_GR_MNU_MPG_M
 WHERE MNU_ID IN ('Demand', 'Demand_Plan')
 ORDER BY MNU_ID, USER_GR_ID;

-- =====================================================================
-- Step 4.5: Parent MNU 존재 + USE_YN 검증
-- =====================================================================
SELECT 'Step4.5: Parent MNU row' AS STEP, MNU_ID, MNU_NM, UPPR_MNU_ID, USE_YN, MNU_DESC
  FROM SCM_MGR.SCM_ADM_MNU_M
 WHERE MNU_ID IN ('Demand', 'Demand_Plan')
 ORDER BY MNU_ID;

-- =====================================================================
-- Step 4.6: minyonglee1 USER_GR 매핑
-- =====================================================================
SELECT 'Step4.6: User UGA' AS STEP, USER_ID, USER_GR_ID
  FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M
 WHERE USER_ID='minyonglee1'
 ORDER BY USER_GR_ID;

-- =====================================================================
-- Step 4.7: Recently-Added Menu Status (login session check)
-- =====================================================================
SELECT 'Step4.7: Menu Active' AS STEP, MNU_ID, MNU_NM, USE_YN,
       CASE WHEN USE_YN='Y' THEN 'OK'
            ELSE 'USE_YN=N — toggle to Y' END AS STATUS
  FROM SCM_MGR.SCM_ADM_MNU_M WHERE MNU_ID='DMF0021';

-- =====================================================================
-- Step 5: PROC_M ↔ SP signature mismatch
--   메모리 feedback_proc_meta_must_match_sp_signature
-- =====================================================================
SELECT P.PROC_NM, P.COL_NM, P.SORT_ORD,
       (SELECT A.ARGUMENT_NAME FROM ALL_ARGUMENTS A
         WHERE A.OWNER='SCM_MGR' AND A.OBJECT_NAME=P.PROC_NM
           AND A.PACKAGE_NAME='PKG_DMF0021' AND A.POSITION=P.SORT_ORD) AS SP_ARG,
       (SELECT A.IN_OUT FROM ALL_ARGUMENTS A
         WHERE A.OWNER='SCM_MGR' AND A.OBJECT_NAME=P.PROC_NM
           AND A.PACKAGE_NAME='PKG_DMF0021' AND A.POSITION=P.SORT_ORD) AS SP_INOUT
  FROM SCM_MGR.SCM_ADM_PROC_M P
 WHERE P.PROC_NM LIKE 'DMF0021%'
 ORDER BY P.PROC_NM, P.SORT_ORD;

-- =====================================================================
-- Step 6: PKG status (VALID 의무)
-- =====================================================================
SELECT OBJECT_NAME, OBJECT_TYPE, STATUS
  FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0021';

-- =====================================================================
-- Step 7: dedupe (NOT EXISTS 멱등성 검증)
--   메모리 feedback_sql_idempotent_insert_all
-- =====================================================================
SELECT 'MNU dup' AS CHK, COUNT(*) AS CNT FROM SCM_MGR.SCM_ADM_MNU_M WHERE MNU_ID='DMF0021' GROUP BY MNU_ID HAVING COUNT(*) > 1;
SELECT 'API dup' AS CHK, API_ID, COUNT(*) AS CNT FROM SCM_MGR.SCM_ADM_API_M WHERE API_ID LIKE 'P_DMF0021%' GROUP BY API_ID HAVING COUNT(*) > 1;
SELECT 'SHEET dup' AS CHK, COLUMN_NAME, COUNT(*) AS CNT FROM SCM_MGR.SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID='DMF0021' GROUP BY COLUMN_NAME HAVING COUNT(*) > 1;
SELECT 'BTN_MPG dup' AS CHK, BTN_ID, SHT_NM, COUNT(*) AS CNT FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID='DMF0021' GROUP BY BTN_ID, SHT_NM HAVING COUNT(*) > 1;

-- =====================================================================
-- ===== FIX SQL (주석 해제 후 실행) =====
-- =====================================================================

-- (a) UPPR_MNU_ID 대소문자 fix (Demand_Plan 표준)
-- UPDATE SCM_MGR.SCM_ADM_MNU_M
--    SET UPPR_MNU_ID='Demand_Plan'
--  WHERE MNU_ID='DMF0021' AND UPPR_MNU_ID <> 'Demand_Plan';
-- COMMIT;

-- (b) SHT_NM = 'main' 표준 정합 (자매 화면 일치)
-- UPDATE SCM_MGR.SCM_ADM_MNU_BTN_MPG_M
--    SET SHT_NM='main'
--  WHERE MNU_ID='DMF0021' AND SHT_NM <> 'main';
-- COMMIT;

-- (c) MNU_DESC NULL fix (사이드바 표시 의무)
-- UPDATE SCM_MGR.SCM_ADM_MNU_M
--    SET MNU_DESC='Sales Plan'
--  WHERE MNU_ID='DMF0021' AND (MNU_DESC IS NULL OR LENGTH(TRIM(MNU_DESC))=0);
-- COMMIT;

-- (d) 부모 메뉴 (Demand_Plan) USE_YN='Y' fix
-- UPDATE SCM_MGR.SCM_ADM_MNU_M
--    SET USE_YN='Y'
--  WHERE MNU_ID IN ('Demand', 'Demand_Plan') AND USE_YN='N';
-- COMMIT;

-- (e) GUEST 권한 보강 (메뉴 미표시 시)
-- INSERT INTO SCM_MGR.SCM_ADM_USER_GR_MNU_MPG_M (USER_GR_ID, MNU_ID, INST_DT, INST_ID, UPDT_DT, UPDT_ID)
-- SELECT 'GUEST', 'DMF0021', SYSDATE, 'system', SYSDATE, 'system' FROM DUAL
--  WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_USER_GR_MNU_MPG_M WHERE USER_GR_ID='GUEST' AND MNU_ID='DMF0021');
-- COMMIT;
