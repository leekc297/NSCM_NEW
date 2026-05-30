--==============================================================================
-- 36_DMF0043_Data_Source_Diagnose.sql
--
-- TO-BE DB 의 DMF0043 데이터 소스 + 컬럼 매핑 직접 검증 SQL.
-- DBeaver 에서 블록 단위로 (각 SELECT) 실행하여 확인.
--
-- 의심 가설:
--   DM_MST_CONTRIBUTE_RATIO_DTL.DEPARTMENT_ID = 8자리 숫자 (인사 부서 ID)
--   SCM_MST_DIVISION.DIVISION_ID            = '40','81_HD' 등 short code (사업부)
--   → 두 값은 다른 entity → 현재 stub SP 의 별칭 DIVISION_NM ← DEPARTMENT_ID 매핑 오류.
--
-- 작성: 2026-05-29
--==============================================================================

-- ====================================================================
-- A. SCM_MST_DIVISION 전체 (= 사업부 마스터, 14 rows)
-- ====================================================================
SELECT DIVISION_ID, DIVISION_NAME, VALID_YN
  FROM SCM_MGR.SCM_MST_DIVISION
 ORDER BY DIVISION_ID;
-- 기대: '40' Mobility & IT, '81*' Automotive, '82' ESS, 'EE*' Electrode

-- ====================================================================
-- B. DM_MST_CONTRIBUTE_RATIO_DTL 의 DEPARTMENT_ID 값들 (분포)
-- ====================================================================
SELECT DEPARTMENT_ID, COUNT(*) row_cnt,
       COUNT(DISTINCT DEPT_ID) distinct_depts,
       MIN(YYYYMM) min_yymm, MAX(YYYYMM) max_yymm
  FROM SCM_MGR.DM_MST_CONTRIBUTE_RATIO_DTL
 WHERE VER_SEQ = 12
 GROUP BY DEPARTMENT_ID
 ORDER BY DEPARTMENT_ID;
-- 기대: 8개의 8자리 숫자 (50007840, 58691249 등) — 사업부 short code 가 아님

-- ====================================================================
-- C. SCM_MST_SSO_DEPT_INFO (인사 부서 마스터) — DEPT_ID → 사업부 매핑 후보
-- ====================================================================
SELECT DEPT_ID, DEPT_NAME_KO, DEPT_NAME_EN,
       UPPER_DEPT_ID, "2LEVEL_DEPT_ID", VALID_YN
  FROM SCM_MGR.SCM_MST_SSO_DEPT_INFO
 WHERE DEPT_ID IN ('70021341','58691249','58607728','58001644','50030981')
 ORDER BY DEPT_ID;
-- 기대: 2LEVEL_DEPT_ID 가 '81_HD' 같은 short code 이면 = SCM_MST_DIVISION.DIVISION_ID 와 매핑 가능

-- ====================================================================
-- D. DM_MST_CONTRIBUTE_RATIO_DTL 의 DEPARTMENT_ID 들이 SSO_DEPT_INFO 에 있는지
-- ====================================================================
SELECT
  (SELECT COUNT(DISTINCT DEPARTMENT_ID)
     FROM SCM_MGR.DM_MST_CONTRIBUTE_RATIO_DTL WHERE VER_SEQ=12) AS dtl_distinct_depts,
  (SELECT COUNT(DISTINCT DEPARTMENT_ID)
     FROM SCM_MGR.DM_MST_CONTRIBUTE_RATIO_DTL DT WHERE VER_SEQ=12
      AND EXISTS (SELECT 1 FROM SCM_MGR.SCM_MST_SSO_DEPT_INFO S WHERE S.DEPT_ID = DT.DEPARTMENT_ID)
  ) AS matched_in_sso,
  (SELECT COUNT(DISTINCT DEPT_ID)
     FROM SCM_MGR.DM_MST_CONTRIBUTE_RATIO_DTL WHERE VER_SEQ=12) AS dtl_distinct_dept_id,
  (SELECT COUNT(DISTINCT DEPT_ID)
     FROM SCM_MGR.DM_MST_CONTRIBUTE_RATIO_DTL DT WHERE VER_SEQ=12
      AND EXISTS (SELECT 1 FROM SCM_MGR.SCM_MST_SSO_DEPT_INFO S WHERE S.DEPT_ID = DT.DEPT_ID)
  ) AS dept_matched_in_sso
FROM DUAL;

-- ====================================================================
-- E. DTL × SSO_DEPT 매핑 결과 — 컬럼 매핑이 정확한지
-- ====================================================================
SELECT DT.DEPARTMENT_ID,
       SD.DEPT_NAME_KO AS DEPARTMENT_NM,
       SD."2LEVEL_DEPT_ID" AS LEVEL2_KEY,
       DIV.DIVISION_NAME AS LEVEL2_DIVISION,
       COUNT(*) row_cnt
  FROM SCM_MGR.DM_MST_CONTRIBUTE_RATIO_DTL DT
  LEFT JOIN SCM_MGR.SCM_MST_SSO_DEPT_INFO SD
    ON SD.DEPT_ID = DT.DEPARTMENT_ID
  LEFT JOIN SCM_MGR.SCM_MST_DIVISION DIV
    ON DIV.DIVISION_ID = SD."2LEVEL_DEPT_ID"
 WHERE DT.VER_SEQ = 12
 GROUP BY DT.DEPARTMENT_ID, SD.DEPT_NAME_KO, SD."2LEVEL_DEPT_ID", DIV.DIVISION_NAME
 ORDER BY DT.DEPARTMENT_ID;
-- 기대: DEPARTMENT_NM = 한글 부서명, LEVEL2_DIVISION = 'Automotive Battery(HD)' 같은 사업부명

-- ====================================================================
-- F. 사용자 minyonglee1 의 권한 단위 (UNIT_ID 들이 SCM_MST_DIVISION 의 DIVISION_ID 와 일치?)
-- ====================================================================
SELECT DISTINCT U.UNIT_ID, D.DIVISION_NAME, U.USE_YN
  FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M G
  JOIN SCM_MGR.SCM_ADM_USER_GR_UNIT_AUTH_MPG_M U
    ON U.USER_GR_ID = G.USER_GR_ID
  LEFT JOIN SCM_MGR.SCM_MST_DIVISION D
    ON D.DIVISION_ID = U.UNIT_ID
 WHERE G.USER_ID = 'minyonglee1'
   AND G.USE_YN = 'Y' AND U.USE_YN = 'Y'
 ORDER BY U.UNIT_ID;
-- 기대: 권한 UNIT_ID 가 SCM_MST_DIVISION 의 DIVISION_ID 와 일치 (LEFT JOIN 결과 NULL 없음)
