--==============================================================================
-- 52_DMF0072_lookup_sp_fix.sql  (SQL*Plus 본체)
--
-- 목적: DMF0072 multi-select 지원을 위한 SP body / 메타 fix
--
-- 사고 원인 (사용자 보고 2026-06-02 — "조회조건을 제대로 가져오지 못함"):
--   1. DMF0072_GET_NNMASTER_MAPPING_WRAPPER 가 'ALL' → '' 으로 변환 후 메인 SP 호출
--      → 메인 SP (PKG_DMF0072.P_DMF0072_GET_NNMASTER_MAPPING) 는 'ALL' 비교만 처리 (빈 string '' 매칭 0건)
--      → 모든 조회 결과 0건 가능성
--   2. WRAPPER 가 sesUserId/mnuId 미전달 → 메인 SP 의 SCM_ADM_USER_MNU_EDIT_AUTH_V EDY 권한 매칭 0건
--      → 사용자 권한 DIVISION 외 행 노출 불가
--   3. lookup SP 의 cascading 필터 부재
--      - DMF0072_GET_END_CUSTOMER_LIST: P_DEPT_ID 인자 받지만 WHERE 절 미사용 + multi-value split 없음
--      - DMF0072_GET_SALES_SITE_LIST: P_END_CUSTOMER 단일 비교만 (multi-value 0건 매칭)
--
-- BLOCK:
--   B1 DMF0072_GET_NNMASTER_MAPPING_WRAPPER : signature 에 sesUserId/mnuId 추가 + ALL 그대로 전달
--   B2 DMF0072_GET_END_CUSTOMER_LIST        : P_DEPT_ID multi-value split + SCM_MST_SSO_USER_INFO JOIN
--   B3 DMF0072_GET_SALES_SITE_LIST          : P_END_CUSTOMER multi-value split
--   B4 SCM_ADM_PROC_M                       : WRAPPER 메타에 sesUserId/mnuId IN 추가 (멱등)
--
-- 멱등성: CREATE OR REPLACE + NOT EXISTS INSERT
-- 작성: 2026-06-02 (DMF0072 multi-select 격차 A 적용)
--==============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON
SET FEEDBACK ON
SET LINESIZE 200
WHENEVER SQLERROR EXIT FAILURE

PROMPT === BLOCK 1 : WRAPPER signature 확장 + ALL 그대로 전달 ===
CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0072_GET_NNMASTER_MAPPING_WRAPPER (
    P_DATA_TYPE_CODE VARCHAR2,
    P_DIVISION_ID    VARCHAR2,
    P_DEPT_ID        VARCHAR2,
    P_END_CUSTOMER   VARCHAR2,
    P_SCM_SITE_ID    VARCHAR2,
    P_PROJECT_CODE   VARCHAR2,
    P_ITEM_ID        VARCHAR2,
    P_USER_ID        VARCHAR2,
    P_MENU_ID        VARCHAR2,
    O_RC1            OUT SYS_REFCURSOR
) AS
    V_RESULT_CURSOR SYS_REFCURSOR;
BEGIN
    -- As-Is .cs L477~485: FoxDataRequest("DMF0072_GET_NNMASTER_MAPPING")
    --   p_data_type_code/divisionId/deptId/endCustomer/scmSiteId 모두 콤마 join 그대로 전달
    --   ('ALL' 도 그대로 — 메인 SP 가 CASE WHEN P_XXX='ALL' THEN ... 으로 처리)
    SCM_MGR.PKG_DMF0072.P_DMF0072_GET_NNMASTER_MAPPING(
        P_DATA_TYPE_CODE,
        P_DIVISION_ID,
        P_DEPT_ID,
        P_END_CUSTOMER,
        P_SCM_SITE_ID,
        P_PROJECT_CODE,
        P_ITEM_ID,
        P_USER_ID,
        P_MENU_ID,
        O_RC1,
        V_RESULT_CURSOR
    );
END DMF0072_GET_NNMASTER_MAPPING_WRAPPER;
/

PROMPT === BLOCK 2 : END_CUSTOMER_LIST — P_DEPT_ID multi-value cascading ===
CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0072_GET_END_CUSTOMER_LIST (
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
/

PROMPT === BLOCK 3 : SALES_SITE_LIST — P_END_CUSTOMER multi-value split ===
CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0072_GET_SALES_SITE_LIST (
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
/

PROMPT === BLOCK 4 : PROC_M 메타 — WRAPPER 에 sesUserId/mnuId 추가 (멱등) ===
INSERT INTO SCM_MGR.SCM_ADM_PROC_M (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT NEW.PROC_NM, NEW.COL_NM, NEW.DATA_TP_CD, NEW.COL_TP_CD, NEW.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE
  FROM (
    -- WRAPPER 의 sesUserId 는 SORT_ORD 8 (P_USER_ID 위치) / mnuId 는 9 (P_MENU_ID 위치). o_rc1 은 기존 SORT_ORD 8 → 재정렬 필요
    -- 단 기존 등록된 컬럼 (1~7 IN + o_rc1=8 OUT) 은 PK 중복으로 SKIP. 신규 sesUserId/mnuId 만 추가.
    SELECT 'DMF0072_GET_NNMASTER_MAPPING_WRAPPER' AS PROC_NM, 'sesUserId' AS COL_NM, 'VARCHAR' AS DATA_TP_CD, 'IN'  AS COL_TP_CD, 8 AS SORT_ORD FROM DUAL UNION ALL
    SELECT 'DMF0072_GET_NNMASTER_MAPPING_WRAPPER',           'mnuId',                  'VARCHAR',               'IN',                9 FROM DUAL
  ) NEW
 WHERE NOT EXISTS (
   SELECT 1 FROM SCM_MGR.SCM_ADM_PROC_M X
    WHERE X.PROC_NM = NEW.PROC_NM AND X.COL_NM = NEW.COL_NM AND X.COL_TP_CD = NEW.COL_TP_CD
 );

-- o_rc1 의 SORT_ORD 를 10 으로 재정렬 (sesUserId/mnuId 가 8,9 차지)
UPDATE SCM_MGR.SCM_ADM_PROC_M
   SET SORT_ORD = 10, LAST_UPDATED_BY='admin', LAST_UPDATE_DATE=SYSDATE
 WHERE PROC_NM = 'DMF0072_GET_NNMASTER_MAPPING_WRAPPER'
   AND COL_NM = 'o_rc1' AND COL_TP_CD = 'OUT' AND SORT_ORD <> 10;

PROMPT === BLOCK 5 : 사후 카운트 ===
SELECT 'POST: WRAPPER cols (10 expected)' AS K, COUNT(*) AS V
  FROM SCM_MGR.SCM_ADM_PROC_M WHERE PROC_NM='DMF0072_GET_NNMASTER_MAPPING_WRAPPER'
UNION ALL SELECT 'POST: WRAPPER sesUserId',    COUNT(*) FROM SCM_MGR.SCM_ADM_PROC_M WHERE PROC_NM='DMF0072_GET_NNMASTER_MAPPING_WRAPPER' AND COL_NM='sesUserId'
UNION ALL SELECT 'POST: WRAPPER mnuId',         COUNT(*) FROM SCM_MGR.SCM_ADM_PROC_M WHERE PROC_NM='DMF0072_GET_NNMASTER_MAPPING_WRAPPER' AND COL_NM='mnuId'
UNION ALL SELECT 'POST: SP VALID (4 expected)', COUNT(*) FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME IN ('DMF0072_GET_NNMASTER_MAPPING_WRAPPER','DMF0072_GET_END_CUSTOMER_LIST','DMF0072_GET_SALES_SITE_LIST','DMF0072_GET_NNMASTER_MAPPING') AND OBJECT_TYPE='PROCEDURE' AND STATUS='VALID';

COMMIT;
PROMPT === COMPLETE ===
EXIT;
