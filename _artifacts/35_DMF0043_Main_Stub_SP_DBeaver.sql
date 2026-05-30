--==============================================================================
-- 35_DMF0043_Main_Stub_SP_DBeaver.sql (DBeaver 호환 — 멱등)
-- 적용 시각: 2026-05-29
-- 룰 22 / 메모리 feedback_sql_dual_output / feedback_dbeaver_sql_mandatory_grep
--==============================================================================
-- BLOCK 1 : standalone stub SP (CREATE OR REPLACE 자체가 멱등)
--==============================================================================
CREATE OR REPLACE PROCEDURE SCM_MGR.P_DMF0043_GET_CONTRIBUTE_MAIN_DATA
(
    P_USER_ID         IN  VARCHAR2,
    P_MENU_ID         IN  VARCHAR2,
    P_YEAR_ID         IN  VARCHAR2,
    P_IS_YEAR_BY_YEAR IN  VARCHAR2,
    P_IS_MISMATCH     IN  VARCHAR2,
    P_IS_HISTORY      IN  VARCHAR2,
    O_RC1             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
AS
    V_VER_SEQ NUMBER;
BEGIN
    BEGIN
        V_VER_SEQ := TO_NUMBER(P_YEAR_ID);
    EXCEPTION WHEN OTHERS THEN
        V_VER_SEQ := NULL;
    END;

    OPEN O_RC1 FOR
        SELECT
            DT.VER_SEQ,
            VER.YYYY                                                AS VER_YYYY,
            VER.VERSION_NM,
            /* 6개 고정 컬럼 — AS-IS .cs DefColumns + GetLookupData */
            DT.DEPARTMENT_ID                                        AS DEPT_PARENT_ID,
            NVL(D1.DEPT_NAME_KO, DT.DEPARTMENT_ID)                  AS DEPT_PARENT_NM,
            DT.DEPT_ID                                              AS DEPT_ID,
            NVL(D2.DEPT_NAME_KO, DT.DEPT_ID)                        AS DEPT_NM,
            DT.END_CUST_REPORT                                      AS CUSTOMER_GROUP,
            DT.END_CUST_REPORT                                      AS CUSTOMER_GROUP_NM,
            DT.SOLDTO_CUST_REPORT                                   AS CUSTOMER_DETAIL,
            NVL(CUST.SOLDTO_DESC, DT.SOLDTO_CUST_REPORT)            AS CUSTOMER_DETAIL_NM,
            DT.PRODUCT_GROUP                                        AS PRODUCT_TYPE,
            DT.PRODUCT_GROUP                                        AS PRODUCT_TYPE_NM,
            DT.DM_BIZ_TYPE                                          AS BIZ_TYPE,
            DT.DM_BIZ_TYPE                                          AS BIZ_TYPE_NM,
            /* PIVOT 축 */
            DT.YYYYMM                                               AS YYYYMM,
            SUBSTR(DT.YYYYMM, 1, 4)||'-'||SUBSTR(DT.YYYYMM, 5, 2)   AS YYYYMM_LABEL,
            DT.OS_CORP_CD                                           AS OS_CORP_CD,
            DT.OS_CORP_CD                                           AS OS_CORP_NM,
            /* 값 */
            DT.CONTRIBUTION_TYPE                                    AS CONTRIBUTION_TYPE,
            DT.CONTRIBUTION_RATIO                                   AS CONTRIBUTION_RATIO,
            'N'                                                     AS EDIT_FLAG
        FROM DM_MST_CONTRIBUTE_RATIO_DTL DT
        JOIN DM_MST_CONTRIBUTE_VER VER
          ON DT.VER_SEQ = VER.VER_SEQ
         AND VER.VALID_YN = 'Y'
        LEFT JOIN SCM_MST_SSO_DEPT_INFO D1
          ON D1.DEPT_ID = DT.DEPARTMENT_ID
         AND D1.VALID_YN = 'Y'
        LEFT JOIN SCM_MST_SSO_DEPT_INFO D2
          ON D2.DEPT_ID = DT.DEPT_ID
         AND D2.VALID_YN = 'Y'
        LEFT JOIN (
            SELECT SOLDTO_CODE, MAX(SOLDTO_DESCRIPTION) AS SOLDTO_DESC
              FROM SCM_MST_CUSTOMER
             WHERE VALID_YN = 'Y'
             GROUP BY SOLDTO_CODE
        ) CUST
          ON CUST.SOLDTO_CODE = DT.SOLDTO_CUST_REPORT
        WHERE (DT.VER_SEQ = V_VER_SEQ OR VER.YYYY = P_YEAR_ID)
        ORDER BY DT.VER_SEQ, DT.DEPARTMENT_ID, DT.YYYYMM, DT.OS_CORP_CD;

    OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS CODE, 'SUCCESS' AS MSG, '0' AS EVENT FROM DUAL;
END P_DMF0043_GET_CONTRIBUTE_MAIN_DATA;

--==============================================================================
-- BLOCK 2 : SCM_ADM_API_M.API_URL 정정
--==============================================================================
UPDATE SCM_MGR.SCM_ADM_API_M
   SET API_URL          = 'P_DMF0043_GET_CONTRIBUTE_MAIN_DATA',
       LAST_UPDATED_BY  = 'admin',
       LAST_UPDATE_DATE = SYSDATE
 WHERE API_ID = 'DMF0043_main_SEARCH'
   AND API_URL != 'P_DMF0043_GET_CONTRIBUTE_MAIN_DATA';

--==============================================================================
-- BLOCK 3 : SCM_ADM_PROC_M 메타 자동 등록 (멱등, NOT EXISTS 가드)
--==============================================================================
INSERT INTO SCM_MGR.SCM_ADM_PROC_M
  (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
   CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT
  S.OBJECT_NAME AS PROC_NM,
  CASE
    WHEN S.IN_OUT = 'IN' AND S.ARGUMENT_NAME = 'P_USER_ID' THEN 'sesUserId'
    WHEN S.IN_OUT = 'IN' AND S.ARGUMENT_NAME = 'P_MENU_ID' THEN 'menuId'
    WHEN S.IN_OUT = 'IN' AND S.ARGUMENT_NAME = 'P_LANG_CD' THEN 'sesLangCd'
    WHEN S.IN_OUT = 'IN' THEN
      LOWER(SUBSTR(REPLACE(INITCAP(REPLACE(SUBSTR(S.ARGUMENT_NAME, 3), '_', ' ')), ' ', ''), 1, 1))
      || SUBSTR(REPLACE(INITCAP(REPLACE(SUBSTR(S.ARGUMENT_NAME, 3), '_', ' ')), ' ', ''), 2)
    WHEN S.IN_OUT = 'OUT' AND S.ARGUMENT_NAME = 'O_RESULT_CURSOR' THEN 'O_RESULT_CURSOR'
    WHEN S.IN_OUT = 'OUT' THEN LOWER(S.ARGUMENT_NAME)
    ELSE S.ARGUMENT_NAME
  END AS COL_NM,
  S.IN_OUT AS COL_TP_CD,
  CASE
    WHEN S.ARGUMENT_NAME = 'O_RESULT_CURSOR' THEN 'PROC_RESULT'
    WHEN S.DATA_TYPE = 'REF CURSOR' THEN 'CURSOR'
    WHEN S.DATA_TYPE = 'VARCHAR2' THEN 'VARCHAR'
    ELSE S.DATA_TYPE
  END AS DATA_TP_CD,
  S.POSITION AS SORT_ORD,
  'admin', SYSDATE, 'admin', SYSDATE
FROM ALL_ARGUMENTS S
WHERE S.OWNER = 'SCM_MGR'
  AND S.OBJECT_NAME = 'P_DMF0043_GET_CONTRIBUTE_MAIN_DATA'
  AND S.PACKAGE_NAME IS NULL
  AND S.POSITION > 0
  AND NOT EXISTS (
    SELECT 1 FROM SCM_MGR.SCM_ADM_PROC_M T
     WHERE T.PROC_NM = S.OBJECT_NAME
       AND T.SORT_ORD = S.POSITION
  );

COMMIT;
