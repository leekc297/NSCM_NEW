-- 53_DMF0072_TEAM_LIST_sp_body_DBeaver.sql  (DBeaver SQL Editor 용)
-- SQL*Plus 명령어 / '/' terminator 제거. 메모리 feedback_dbeaver_sql_mandatory_grep 의무 (^SET/^PROMPT/^DEFINE/^&\w/^/$ = 0)

-- ============================================
-- B1: DMF0072_GET_TEAM_LIST — As-Is SCM0001_GET_TEAM_BY_DIVISION 1:1 변환
-- ============================================
CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0072_GET_TEAM_LIST (
    P_DIVISION_ID VARCHAR2,
    O_RC1 OUT SYS_REFCURSOR
) AS
BEGIN
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

COMMIT;
