/*=============================================================================================
 * File         : 040_Diagnose_Empty_Data.sql
 * Description  : DMF0003 화면 0건 / 빈 데이터 진단
 *              :   룰 21 §10.2 + memory feedback_popup_data_diagnosis 적용 — 5단계 진단
 *===========================================================================================*/

PROMPT === DMF0003 빈 데이터 진단 ===

-- Step 1: 메뉴 등록 확인
SELECT 'Step1' AS K, COUNT(*) AS CNT FROM SCM_ADM_MNU_M WHERE MNU_ID = 'DMF0003';

-- Step 2: PROC_M 26 row (메인 GET) + 17 row (SAVE)
SELECT 'Step2_GET' AS K, COUNT(*) AS CNT, 26 AS EXPECT FROM SCM_ADM_PROC_M WHERE PROC_NM = 'DMF0003_GET_MKT_FCST_DATA';
SELECT 'Step2_SAVE', COUNT(*), 17 FROM SCM_ADM_PROC_M WHERE PROC_NM = 'DMF0003_SAVE_MKT_FCST';

-- Step 3: API_M + BTN_MPG (모든 sheet)
SELECT 'Step3_API' AS K, COUNT(*) AS CNT FROM SCM_ADM_API_M WHERE API_ID LIKE 'DMF0003\_%' ESCAPE '\';
SELECT 'Step3_BTN' AS K, COUNT(*) AS CNT FROM SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID = 'DMF0003';

-- Step 4: USER_GR_MNU_MPG (메뉴 권한) + USER_GR_MNU_BTN_MPG (버튼 권한)
SELECT 'Step4_MNU_PERM' AS K, COUNT(*) AS CNT FROM SCM_ADM_USER_GR_MNU_MPG_M WHERE MNU_ID = 'DMF0003';
SELECT 'Step4_BTN_PERM' AS K, COUNT(*) AS CNT FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M WHERE MNU_ID = 'DMF0003';

-- Step 5: SP 컴파일 VALID
SELECT 'Step5_OBJ' AS K, OBJECT_NAME, STATUS
FROM ALL_OBJECTS
WHERE OWNER = 'SCM_MGR'
  AND (OBJECT_NAME LIKE 'DMF0003%' OR OBJECT_NAME = 'PKG_DMF0003')
ORDER BY OBJECT_NAME;

-- Step 6: 마스터 테이블 row count (실제 데이터 존재 여부)
SELECT 'Step6_DATA_DM_MKT_FCST' AS K, COUNT(*) AS CNT FROM SCM_MST_FUTURE_MKT_FCST WHERE ROWNUM <= 1;
