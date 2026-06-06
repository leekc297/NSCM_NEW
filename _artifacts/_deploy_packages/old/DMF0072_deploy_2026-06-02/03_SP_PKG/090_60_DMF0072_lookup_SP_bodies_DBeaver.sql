-- =====================================================================
-- 60_DMF0072_lookup_SP_bodies.sql
--
-- 신규 화면 DMF0072 NN Master Mapping 의 조회 조건 dropdown lookup SP body 4건
--
-- 추출: 2026-06-02 (deploy package 누락 보강 — 사용자 명시 요구)
-- 출처: Oracle SCM_MGR (Docker local) ALL_SOURCE / DBMS_METADATA.GET_DDL
--
-- 적용 대상:
--   1) DMF0072_GET_DATA_TYPE_LIST     — DataType 콤보 (DM_EDI_DATA_TYPE_CODE)
--   2) DMF0072_GET_TEAM_LIST          — Team 콤보 (Division → Team cascading)
--   3) DMF0072_GET_END_CUSTOMER_LIST  — EndCustomer 콤보 (Division → EndCustomer cascading)
--   4) DMF0072_GET_SALES_SITE_LIST    — SalesSite 콤보 (Division + EndCustomer → SalesSite multi-value cascading)
--
-- 실행 환경:
--   - SQL*Plus / sqlcl: 그대로 실행
--   - DBeaver:        파일 끝 / 제거 후 SQL Editor 단일 실행 (SP 분리 표시는 PROMPT/-- 로 식별)
-- =====================================================================

-- PROMPT === [1/4] DMF0072_GET_DATA_TYPE_LIST ===

CREATE OR REPLACE EDITIONABLE PROCEDURE "SCM_MGR"."DMF0072_GET_DATA_TYPE_LIST" (
    O_RC1 OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN O_RC1 FOR
        SELECT 'ALL' AS CODE, 'ALL' AS NAME FROM DUAL
        UNION ALL
        SELECT DISTINCT SEGMENT1, NVL(SEGMENT2, SEGMENT1) AS NAME
          FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
         WHERE LOOKUP_TYPE='DM_EDI_DATA_TYPE_CODE' AND VALID_YN='Y'
         ORDER BY 1;
END DMF0072_GET_DATA_TYPE_LIST;

-- PROMPT === [2/4] DMF0072_GET_TEAM_LIST ===

CREATE OR REPLACE EDITIONABLE PROCEDURE "SCM_MGR"."DMF0072_GET_TEAM_LIST" (
    P_DIVISION_ID VARCHAR2,
    O_RC1 OUT SYS_REFCURSOR
) AS
BEGIN
    -- As-Is SCM0001_GET_TEAM_BY_DIVISION 1:1 변환
    --   - SCM_MST_SITE A (SITE_TYPE='SALES') ⋈ SCM_MST_SSO_DEPT_INFO B (DEPT_ID 매칭)
    --   - P_DIVISION_ID 'ALL' 또는 콤마 split IN 매칭
    --   - WITH(NOLOCK) 제거 (Oracle read consistency)
    --   - XML split → UF_FX_STRING_SPLIT (메인 SP P_DMF0072_GET_NNMASTER_MAPPING 과 일관)
    OPEN O_RC1 FOR
      SELECT DISTINCT
             B.DEPT_ID      AS CODE,
             B.DEPT_NAME_KO AS NAME
        FROM SCM_MGR.SCM_MST_SITE          A,
             SCM_MGR.SCM_MST_SSO_DEPT_INFO B
       WHERE A.SITE_TYPE = 'SALES'
         AND A.DEPT_ID   = B.DEPT_ID
         AND (P_DIVISION_ID IS NULL
              OR P_DIVISION_ID = 'ALL'
              OR A.DIVISION_ID IN (
                  SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_DIVISION_ID, ','))
                   WHERE TOKEN IS NOT NULL
              )
             )
       ORDER BY 2;
END DMF0072_GET_TEAM_LIST;

-- PROMPT === [3/4] DMF0072_GET_END_CUSTOMER_LIST ===

CREATE OR REPLACE EDITIONABLE PROCEDURE "SCM_MGR"."DMF0072_GET_END_CUSTOMER_LIST" (
    P_DIVISION_ID VARCHAR2,
    P_DEPT_ID     VARCHAR2,
    O_RC1 OUT SYS_REFCURSOR
) AS
BEGIN
    -- As-Is .cs L165~178: EndCustomerByDivision[40]
    --   div='40' 분기는 To-Be 에서 통합 SP 로 단일화 (분기 logic 은 wrapper 측에서 처리 가능)
    --   P_DEPT_ID 'ALL' 또는 NULL → 부서 무관 / 그 외 → 콤마 split 후 매칭
    OPEN O_RC1 FOR
      SELECT DISTINCT END_CUSTOMER AS CODE,
             END_CUSTOMER AS NAME
        FROM SCM_MGR.SCM_MST_SITE S
       WHERE (P_DIVISION_ID IS NULL OR P_DIVISION_ID = 'ALL' OR S.DIVISION_ID = P_DIVISION_ID)
         AND S.END_CUSTOMER IS NOT NULL
         AND S.VALID_YN = 'Y'
         -- cascading: P_DEPT_ID 가 'ALL' 또는 빈 값이면 전체, 그 외 부서별 (현 시점 매핑 부재 — site.OWNER dept 매핑 후속 작업)
         AND (P_DEPT_ID IS NULL OR P_DEPT_ID = 'ALL'
              OR EXISTS (
                SELECT 1 FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_DEPT_ID, ',')) P
                 WHERE P.TOKEN IS NOT NULL
              )
             )
       ORDER BY 1;
END DMF0072_GET_END_CUSTOMER_LIST;

-- PROMPT === [4/4] DMF0072_GET_SALES_SITE_LIST ===

CREATE OR REPLACE EDITIONABLE PROCEDURE "SCM_MGR"."DMF0072_GET_SALES_SITE_LIST" (
    P_DIVISION_ID  VARCHAR2,
    P_END_CUSTOMER VARCHAR2,
    O_RC1 OUT SYS_REFCURSOR
) AS
BEGIN
    -- As-Is .cs L186: UserSiteByEndCustomer — Division + End Customer(다중) 기반 SCM Site list
    OPEN O_RC1 FOR
      SELECT DISTINCT S.SCM_SITE_ID AS CODE,
             NVL(S.SITE_DESCRIPTION, S.SCM_SITE_ID) AS NAME
        FROM SCM_MGR.SCM_MST_SITE S
       WHERE (P_DIVISION_ID IS NULL OR P_DIVISION_ID = 'ALL' OR S.DIVISION_ID = P_DIVISION_ID)
         AND S.VALID_YN = 'Y'
         -- multi-value cascading: 콤마 split
         AND (P_END_CUSTOMER IS NULL OR P_END_CUSTOMER = 'ALL'
              OR S.END_CUSTOMER IN (
                SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_END_CUSTOMER, ','))
                 WHERE TOKEN IS NOT NULL
              )
             )
       ORDER BY 1
       FETCH FIRST 500 ROWS ONLY;
END DMF0072_GET_SALES_SITE_LIST;

-- PROMPT === DMF0072 lookup SP body 4건 적재 완료 ===
