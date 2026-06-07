/*=============================================================================================
 * File         : 050_Quick_Diagnose_Menu_Not_Displayed.sql
 * Description  : DMF0003 메뉴 미표시 7단계 진단
 *              :   hook menu-not-displayed-debug + memory feedback_mnu_uppr_case_standard /
 *              :   feedback_sheet_name_main_standard / feedback_mnu_desc_required
 *
 * 실행 방법   : DBeaver 에서 전체 select → Ctrl+Enter (8 결과)
 *===========================================================================================*/

-- Step 1: SCM_ADM_MNU_M 에 DMF0003 row 존재? (가장 흔한 원인 — 메타 미적재)
SELECT 'Step1.MNU_M' AS K,
       MNU_ID, UPPR_MNU_ID, MNU_URL, MNU_DESC, MNU_TP_CD, USE_YN,
       CASE
         WHEN MNU_ID IS NULL THEN '❌ FAIL: 메타 SQL 미적재 — 010_DMF0003_Registration_DBeaver.sql 실행 필요'
         WHEN UPPR_MNU_ID != 'Demand_Master' THEN '❌ FAIL: UPPR_MNU_ID 표준 = Demand_Master PascalCase (현재: '||UPPR_MNU_ID||')'
         WHEN MNU_URL != 'mkt-forecast-master' THEN '❌ FAIL: MNU_URL ↔ FE route-paths slug 불일치 (현재: '||MNU_URL||')'
         WHEN MNU_DESC IS NULL THEN '❌ FAIL: MNU_DESC NULL → 사이드바 미표시 (룰 13 §10)'
         WHEN USE_YN != 'Y' THEN '❌ FAIL: USE_YN != Y'
         ELSE '✅ PASS: 메뉴 row 정상'
       END AS RESULT
FROM SCM_ADM_MNU_M WHERE MNU_ID = 'DMF0003'
UNION ALL
SELECT 'Step1.MNU_M', NULL, NULL, NULL, NULL, NULL, NULL,
       '❌ FAIL: SCM_ADM_MNU_M 에 DMF0003 row 없음 → 010_DMF0003_Registration_DBeaver.sql 실행'
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM SCM_ADM_MNU_M WHERE MNU_ID = 'DMF0003');


-- Step 2: 부모 메뉴 (Demand_Master) 존재 + USE_YN='Y' 확인
SELECT 'Step2.UPPR_EXIST' AS K, MNU_ID, USE_YN,
       CASE WHEN USE_YN = 'Y' THEN '✅ PASS' ELSE '❌ FAIL: 부모 USE_YN != Y' END AS RESULT
FROM SCM_ADM_MNU_M WHERE MNU_ID = 'Demand_Master'
UNION ALL
SELECT 'Step2.UPPR_EXIST', NULL, NULL,
       '❌ FAIL: 부모 메뉴 Demand_Master 없음 (자매 화면 cross-check 필요)'
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM SCM_ADM_MNU_M WHERE MNU_ID = 'Demand_Master');


-- Step 3: 메뉴 권한 (SCM_ADM_USER_GR_MNU_MPG_M)
SELECT 'Step3.MNU_PERM' AS K,
       LISTAGG(USER_GR_ID, ', ') WITHIN GROUP (ORDER BY USER_GR_ID) AS GROUPS,
       COUNT(*) AS CNT,
       CASE WHEN COUNT(*) = 0 THEN '❌ FAIL: 권한 그룹 없음' ELSE '✅ PASS' END AS RESULT
FROM SCM_ADM_USER_GR_MNU_MPG_M WHERE MNU_ID = 'DMF0003';


-- Step 4: minyonglee1 사용자가 권한 그룹에 속해있는지 확인
SELECT 'Step4.USER_GROUP' AS K,
       u.USER_ID,
       u.USER_GR_ID,
       (SELECT COUNT(*) FROM SCM_ADM_USER_GR_MNU_MPG_M ugm
         WHERE ugm.USER_GR_ID = u.USER_GR_ID AND ugm.MNU_ID = 'DMF0003') AS PERM_CNT,
       CASE
         WHEN (SELECT COUNT(*) FROM SCM_ADM_USER_GR_MNU_MPG_M ugm
                WHERE ugm.USER_GR_ID = u.USER_GR_ID AND ugm.MNU_ID = 'DMF0003') = 0
         THEN '❌ FAIL: minyonglee1 그룹 ('||u.USER_GR_ID||') 에 DMF0003 권한 없음 — 060_Grant_minyonglee1.sql 실행 필요'
         ELSE '✅ PASS'
       END AS RESULT
FROM SCM_ADM_USER_M u WHERE u.USER_ID = 'minyonglee1';


-- Step 5: 자매 화면 (DMF0020) 권한 그룹 인벤토리 (cross-check)
SELECT 'Step5.SIBLING_DMF0020' AS K,
       LISTAGG(USER_GR_ID, ', ') WITHIN GROUP (ORDER BY USER_GR_ID) AS GROUPS,
       COUNT(*) AS CNT,
       '참고: DMF0020 권한 그룹 인벤토리 (DMF0003 누락 그룹 확인)' AS RESULT
FROM SCM_ADM_USER_GR_MNU_MPG_M WHERE MNU_ID = 'DMF0020';


-- Step 6: SP 컴파일 상태 (메인 GET SP VALID 확인)
SELECT 'Step6.SP_VALID' AS K, OBJECT_NAME, STATUS,
       CASE WHEN STATUS = 'VALID' THEN '✅' ELSE '❌ FAIL' END AS RESULT
FROM ALL_OBJECTS
WHERE OWNER = 'SCM_MGR'
  AND OBJECT_NAME = 'DMF0003_GET_MKT_FCST_DATA'
UNION ALL
SELECT 'Step6.SP_VALID', NULL, NULL,
       '❌ FAIL: DMF0003_GET_MKT_FCST_DATA SP 미적재 → archive 파일 실행 필요'
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM ALL_OBJECTS WHERE OWNER = 'SCM_MGR' AND OBJECT_NAME = 'DMF0003_GET_MKT_FCST_DATA');


-- Step 7: 종합 — 7-Phase 메타 적재 카운트
SELECT 'Step7.Summary' AS K,
       (SELECT COUNT(*) FROM SCM_ADM_MNU_M WHERE MNU_ID = 'DMF0003') AS MNU_CNT,
       (SELECT COUNT(*) FROM SCM_ADM_USER_GR_MNU_MPG_M WHERE MNU_ID = 'DMF0003') AS MNU_PERM_CNT,
       (SELECT COUNT(*) FROM SCM_ADM_PROC_M WHERE PROC_NM = 'DMF0003_GET_MKT_FCST_DATA') AS PROC_CNT_GET,
       (SELECT COUNT(*) FROM SCM_ADM_API_M WHERE API_ID LIKE 'DMF0003\_%' ESCAPE '\') AS API_CNT,
       (SELECT COUNT(*) FROM SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID = 'DMF0003') AS BTN_CNT,
       (SELECT COUNT(*) FROM SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID = 'DMF0003') AS COL_CNT
FROM DUAL;
-- 기대: MNU 1 / MNU_PERM 3+ / PROC_GET 26 / API 다수 / BTN 다수 / COL 43
