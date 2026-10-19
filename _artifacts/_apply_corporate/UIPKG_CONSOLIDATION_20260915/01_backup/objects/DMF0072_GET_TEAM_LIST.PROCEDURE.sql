-- SOURCE-FRESH: SCM_MGR.DMF0072_GET_TEAM_LIST PROCEDURE LAST_DDL=2026-09-07 13:18:23 FETCHED=2026-09-15 18:50 DB=ZIOUI1
-- STEP 1 BACKUP (원복용 원문 · STATUS=VALID)
SET DEFINE OFF
CREATE OR REPLACE PROCEDURE SCM_MGR."DMF0072_GET_TEAM_LIST" (
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
--      SELECT DISTINCT
----           B.DEPT_ID      AS CODE,
--             C.DEPT_ID      AS CODE,   /* 부서코드 : 아이템 원장 */                    -- 2026.09.06 AJS
--             B.DEPT_NAME_KO AS NAME
--        FROM SCM_MGR.SCM_MST_SITE          A,
--             SCM_MGR.SCM_MST_SITE_ITEM     C,   /* 아이템 원장 추가 */                 -- 2026.09.06 AJS
--             SCM_MGR.SCM_MST_SSO_DEPT_INFO B
--       WHERE A.SITE_TYPE = 'SALES'
----       AND A.DEPT_ID   = B.DEPT_ID
--         AND A.DIVISION_ID = C.DIVISION_ID                                             -- 2026.09.06 AJS
--         AND A.SCM_SITE_ID = C.SCM_SITE_ID                                             -- 2026.09.06 AJS
--         AND C.DEPT_ID     = B.DEPT_ID                                                 -- 2026.09.06 AJS
--         AND (P_DIVISION_ID IS NULL
--              OR P_DIVISION_ID = 'ALL'
--              OR A.DIVISION_ID IN (
--                  SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_DIVISION_ID, ','))
--                   WHERE TOKEN IS NOT NULL
--              )
--             )
--       ORDER BY 2;
    --*[2026-09-06] SSPM 적용 기준
      SELECT DISTINCT
             C.DEPT_ID      AS CODE,   /* 부서코드 : 아이템 원장 */                    -- 2026.09.06 AJS
             B.DEPT_NAME_KO AS NAME
             
        FROM SCM_MGR.SCM_MST_SITE_ITEM     C,   /* 아이템 원장 추가 */                 -- 2026.09.06 AJS
             SCM_MGR.SCM_MST_SSO_DEPT_INFO B
       WHERE C.DEPT_ID     = B.DEPT_ID                                                 -- 2026.09.06 AJS
         AND C.VALID_YN    = 'Y'
         AND (P_DIVISION_ID IS NULL
              OR P_DIVISION_ID = 'ALL'
              OR C.DIVISION_ID IN (
                  SELECT TOKEN FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(P_DIVISION_ID, ','))
                   WHERE TOKEN IS NOT NULL
              )
             )
       ORDER BY 2;
END DMF0072_GET_TEAM_LIST;
/
