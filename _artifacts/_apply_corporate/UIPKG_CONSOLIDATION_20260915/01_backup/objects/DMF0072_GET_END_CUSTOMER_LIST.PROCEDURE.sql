-- SOURCE-FRESH: SCM_MGR.DMF0072_GET_END_CUSTOMER_LIST PROCEDURE LAST_DDL=2026-09-03 14:03:09 FETCHED=2026-09-15 18:50 DB=ZIOUI1
-- STEP 1 BACKUP (원복용 원문 · STATUS=INVALID)
SET DEFINE OFF
CREATE OR REPLACE PROCEDURE SCM_MGR."DMF0072_GET_END_CUSTOMER_LIST" (
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
