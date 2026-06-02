-- 52_DMF0072_lookup_sp_fix_Diagnose.sql  (사전 진단 — DBeaver 용)
-- fix 적용 전후 상태 비교용

-- ============================================
-- D1: 현재 WRAPPER 소스 (변경 전)
-- ============================================
SELECT 'D1: WRAPPER source ' || LINE AS LN, TEXT
  FROM ALL_SOURCE
 WHERE OWNER='SCM_MGR' AND NAME='DMF0072_GET_NNMASTER_MAPPING_WRAPPER'
 ORDER BY LINE;

-- ============================================
-- D2: 현재 END_CUSTOMER_LIST / SALES_SITE_LIST 소스
-- ============================================
SELECT 'D2: ' || NAME || ' L' || LINE AS LN, TEXT
  FROM ALL_SOURCE
 WHERE OWNER='SCM_MGR'
   AND NAME IN ('DMF0072_GET_END_CUSTOMER_LIST', 'DMF0072_GET_SALES_SITE_LIST')
 ORDER BY NAME, LINE;

-- ============================================
-- D3: 현재 WRAPPER PROC_M 메타 (변경 전 9 / 변경 후 11)
-- ============================================
SELECT 'D3: ' || COL_NM || ' (' || COL_TP_CD || ') SORT=' || SORT_ORD AS ARG
  FROM SCM_MGR.SCM_ADM_PROC_M
 WHERE PROC_NM = 'DMF0072_GET_NNMASTER_MAPPING_WRAPPER'
 ORDER BY SORT_ORD;

-- ============================================
-- D4: SCM_MST_SITE 데이터 카운트 (lookup 가능 데이터)
-- ============================================
SELECT 'D4: SITE total/division=40/valid' AS K,
       COUNT(*) AS TOTAL_ROWS
  FROM SCM_MGR.SCM_MST_SITE;

SELECT 'D4: SITE by division (top 5)' AS K, DIVISION_ID, COUNT(*) AS CNT
  FROM SCM_MGR.SCM_MST_SITE
 WHERE VALID_YN = 'Y'
 GROUP BY DIVISION_ID
 ORDER BY 3 DESC
 FETCH FIRST 5 ROWS ONLY;

SELECT 'D4: SITE.END_CUSTOMER distinct (division=40, top 10)' AS K, END_CUSTOMER, COUNT(*) AS CNT
  FROM SCM_MGR.SCM_MST_SITE
 WHERE VALID_YN = 'Y' AND DIVISION_ID = '40' AND END_CUSTOMER IS NOT NULL
 GROUP BY END_CUSTOMER
 ORDER BY 2
 FETCH FIRST 10 ROWS ONLY;

-- ============================================
-- D5: DM_CUST_MODEL_MAPPING_M 데이터 (메인 SP 의 소스 테이블)
-- ============================================
SELECT 'D5: NNMapping total/by division' AS K, DIVISION_ID, COUNT(*) AS ROWS_CNT
  FROM SCM_MGR.DM_CUST_MODEL_MAPPING_M
 GROUP BY DIVISION_ID
 ORDER BY 2;

-- ============================================
-- D6: 사용자 권한 (minyonglee1 의 DIVISION EDIT_YN)
-- ============================================
SELECT 'D6: minyonglee1 권한' AS K, UNIT_ID, EDIT_YN
  FROM TABLE(SCM_MGR.PKG_SCM_USER_MNU.PR_SCM_EDIT_YN('minyonglee1', 'DMF0072'))
 ORDER BY UNIT_ID
 FETCH FIRST 20 ROWS ONLY;

-- ============================================
-- D7: 자기 검증 — WRAPPER 가 'ALL → '' 변환 했는지 (변경 전 식별)
-- ============================================
SELECT 'D7: ALL_THEN_EMPTY pattern in WRAPPER (변경 전이면 >0, 변경 후 0)' AS K,
       COUNT(*) AS PATTERN_CNT
  FROM ALL_SOURCE
 WHERE OWNER='SCM_MGR' AND NAME='DMF0072_GET_NNMASTER_MAPPING_WRAPPER'
   AND UPPER(TEXT) LIKE '%THEN ''''%';
