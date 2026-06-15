--==============================================================================
-- 010_DMF0048_meta_DBeaver_Diagnose.sql — DMF0048 메타 등록 진단 (사고 발생 시)
--   feedback_sql_dual_output 의무 — DBeaver 호환 진단 SQL
--   사고 시나리오 별 진단 query
--==============================================================================

-- ===== 진단 1: 메뉴 미표시 (menu-not-displayed-debug hook 7 단계) =====

-- Step 1: MNU_URL ↔ FE slug 일치 (FE: 'sales-monitoring')
SELECT 'Step1: MNU_URL' AS STEP, MNU_ID, MNU_URL, USE_YN
  FROM SCM_MGR.SCM_ADM_MNU_M
 WHERE MNU_ID='DMF0048';

-- Step 1.5: UPPR_MNU_ID 대소문자 검증 (자매 화면 표준 'Demand_Plan')
SELECT 'Step1.5: UPPR_MNU_ID case' AS STEP, MNU_ID, UPPR_MNU_ID
  FROM SCM_MGR.SCM_ADM_MNU_M
 WHERE MNU_ID='DMF0048'
   AND UPPR_MNU_ID NOT IN (SELECT MNU_ID FROM SCM_MGR.SCM_ADM_MNU_M WHERE UPPR_MNU_ID = 'Demand');

-- Step 1.6: SHT_NM 자매 화면 cross-check
SELECT 'Step1.6: SHT_NM' AS STEP, MNU_ID, SHT_NM, COUNT(*) AS ROW_CNT
  FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M
 WHERE MNU_ID='DMF0048'
 GROUP BY MNU_ID, SHT_NM;

-- Step 1.7: MNU_DESC NULL 검증 (feedback_mnu_desc_required)
SELECT 'Step1.7: MNU_DESC' AS STEP, MNU_ID, MNU_DESC, USE_YN
  FROM SCM_MGR.SCM_ADM_MNU_M
 WHERE MNU_ID='DMF0048'
   AND (MNU_DESC IS NULL OR LENGTH(TRIM(MNU_DESC)) = 0);

-- Step 3: 메뉴 권한 (USER_GR_MNU_MPG_M)
SELECT 'Step3: USER_GR_MNU_MPG_M' AS STEP, USER_GR_ID, MNU_ID, USE_YN
  FROM SCM_MGR.SCM_ADM_USER_GR_MNU_MPG_M
 WHERE MNU_ID='DMF0048';

-- Step 4: 부모 메뉴 권한 (Demand_Plan 자체 + 상위 Demand)
SELECT 'Step4: Parent MNU permission' AS STEP, USER_GR_ID, MNU_ID
  FROM SCM_MGR.SCM_ADM_USER_GR_MNU_MPG_M
 WHERE MNU_ID IN ('Demand', 'Demand_Plan');

-- Step 4.5 (메뉴 미연결 사고 추가 진단): 부모 메뉴 row 자체 존재 여부
SELECT 'Step4.5: Parent MNU row' AS STEP, MNU_ID, MNU_NM, UPPR_MNU_ID, USE_YN
  FROM SCM_MGR.SCM_ADM_MNU_M
 WHERE MNU_ID IN ('Demand', 'Demand_Plan');

-- Step 4.6: minyonglee1 소속 그룹
SELECT 'Step4.6: minyonglee1 groups' AS STEP, USER_GR_ID, USER_ID, USE_YN
  FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M
 WHERE USER_ID = 'minyonglee1';

-- Step 4.7: minyonglee1 의 DMF0048 + 부모 권한
SELECT 'Step4.7: minyonglee1 menu perms' AS STEP, MNU_ID, USE_YN
  FROM SCM_MGR.SCM_ADM_USER_GR_MNU_MPG_M
 WHERE USER_GR_ID IN (SELECT USER_GR_ID FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M WHERE USER_ID = 'minyonglee1' AND USE_YN = 'Y')
   AND MNU_ID IN ('DMF0048', 'Demand', 'Demand_Plan');

-- ===== FIX SQL (부모 메뉴 권한 누락 시 — 주석 해제 후 실행) =====
-- INSERT INTO SCM_MGR.SCM_ADM_USER_GR_MNU_MPG_M (USER_GR_ID, MNU_ID, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
-- SELECT G.USER_GR_ID, M.MNU_ID, 'Y', 'admin', SYSDATE, 'admin', SYSDATE
--   FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M G
--  CROSS JOIN (SELECT 'Demand' AS MNU_ID FROM DUAL UNION ALL SELECT 'Demand_Plan' FROM DUAL) M
--  WHERE G.USER_ID = 'minyonglee1' AND G.USE_YN = 'Y'
--    AND NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_USER_GR_MNU_MPG_M X
--                     WHERE X.USER_GR_ID = G.USER_GR_ID AND X.MNU_ID = M.MNU_ID);
-- COMMIT;


-- ===== 진단 2: PROC_M ↔ SP signature mismatch (proc-meta-signature-match hook) =====

-- PROC_M 시그니처 vs ALL_ARGUMENTS 불일치 진단
SELECT P.PROC_NM, P.COL_NM, P.SORT_ORD, P.COL_TP_CD AS PROC_M_TYPE,
       (SELECT A.ARGUMENT_NAME FROM ALL_ARGUMENTS A
         WHERE A.OWNER='SCM_MGR' AND A.OBJECT_NAME=P.PROC_NM AND A.PACKAGE_NAME IS NULL
           AND A.POSITION=P.SORT_ORD) AS SP_ARG_NAME,
       (SELECT A.IN_OUT FROM ALL_ARGUMENTS A
         WHERE A.OWNER='SCM_MGR' AND A.OBJECT_NAME=P.PROC_NM AND A.PACKAGE_NAME IS NULL
           AND A.POSITION=P.SORT_ORD) AS SP_IN_OUT
  FROM SCM_MGR.SCM_ADM_PROC_M P
 WHERE P.PROC_NM LIKE 'DMF0048%'
 ORDER BY P.PROC_NM, P.SORT_ORD;


-- ===== 진단 3: SP body status (PKG_DMF0048 + body 의 SPREAD_TITLE 누락 여부) =====

-- PKG VALID 검증
SELECT OBJECT_NAME, OBJECT_TYPE, STATUS, LAST_DDL_TIME
  FROM ALL_OBJECTS
 WHERE OWNER='SCM_MGR'
   AND OBJECT_NAME='PKG_DMF0048';

-- ⚠️ 사고 — PKG body 의 SPREAD_TITLE body 가 누락 (spec 만 선언, body 미정의 → PLS-00302)
-- 보강 SQL: 01_SP_BODY/020_DMF0048_SPREAD_TITLE_body_create.sql (별도 작성 필요)


-- ===== 진단 4: SHEET_COLUMNS ↔ SP 반환 alias case mismatch (sheet-columns-binding-match hook) =====

-- 51 row 확인
SELECT PROGRAM_ID, SHT_NM, COLUMN_NAME, HDR_NM, SORT_ORD
  FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
 WHERE PROGRAM_ID='DMF0048'
 ORDER BY SORT_ORD;


-- ===== 진단 5: dedupe 검증 (feedback_sql_idempotent_insert_all — 중복 INSERT 발생 시) =====

SELECT 'MNU_M dup' AS CHK, COUNT(*) AS ROW_CNT
  FROM SCM_MGR.SCM_ADM_MNU_M WHERE MNU_ID='DMF0048' GROUP BY MNU_ID HAVING COUNT(*) > 1;

SELECT 'API_M dup' AS CHK, API_ID, COUNT(*) AS ROW_CNT
  FROM SCM_MGR.SCM_ADM_API_M WHERE API_ID LIKE 'P_DMF0048%' GROUP BY API_ID HAVING COUNT(*) > 1;

SELECT 'SHEET_COLUMNS dup' AS CHK, COLUMN_NAME, COUNT(*) AS ROW_CNT
  FROM SCM_MGR.SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID='DMF0048' GROUP BY COLUMN_NAME HAVING COUNT(*) > 1;

SELECT 'PROC_M dup' AS CHK, PROC_NM, COL_NM, COL_TP_CD, COUNT(*) AS ROW_CNT
  FROM SCM_MGR.SCM_ADM_PROC_M WHERE PROC_NM LIKE 'DMF0048%'
 GROUP BY PROC_NM, COL_NM, COL_TP_CD HAVING COUNT(*) > 1;
