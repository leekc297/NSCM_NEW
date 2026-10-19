-- SOURCE-FRESH: SCM_MGR.PKG_DMF0007 PACKAGE LAST_DDL=2026-09-02 11:47:09 FETCHED=2026-09-15 18:54 DB=ZIOUI1
SET DEFINE OFF
CREATE OR REPLACE PACKAGE SCM_MGR."PKG_DMF0007" IS
/****************************************************************************************************/
/* Program ID  : PKG_DMF0007                                                                        */
/* Description : PKG_DMF0007                                                                        */
/* Usage       :                                                                                    */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2026.03.17  SSLEE        [PJ20264226] NextSCM Pilot 설계 및 개발                                   */
/*                          UI 항목으로 Package로 전환                                                 */
/****************************************************************************************************/

PROCEDURE P_DMF0007_GET_CUST_FCST_DATA (
   P_PLAN_WEEK       IN VARCHAR2
  ,P_DIVISION_ID     IN VARCHAR2
  --,P_DEPT_ID         IN VARCHAR2
  ,P_END_CUSTOMER    IN VARCHAR2
  ,P_SCM_SITE_ID     IN VARCHAR2
  ,P_BUCKET_TYPE     IN VARCHAR2
  ,P_VALID_YN        IN VARCHAR2
  ,P_CREATED_BY      IN VARCHAR2
  --,P_USER_GROUP      IN VARCHAR2
  ,P_USER_ID         IN VARCHAR2
  ,P_MENU_ID         IN VARCHAR2

  ,O_CURSOR          OUT SYS_REFCURSOR
  ,O_RESULT_CURSOR   OUT SYS_REFCURSOR
);

PROCEDURE P_DMF0007_GET_CUST_PSI_DATA (
   P_PLAN_WEEK       IN VARCHAR2
  ,P_DIVISION_ID     IN VARCHAR2
  --,P_DEPT_ID         IN VARCHAR2
  ,P_END_CUSTOMER    IN VARCHAR2
  ,P_SCM_SITE_ID     IN VARCHAR2
  ,P_BUCKET_TYPE     IN VARCHAR2
  ,P_VALID_YN        IN VARCHAR2
  ,P_CREATED_BY      IN VARCHAR2
  --,P_USER_GROUP      IN VARCHAR2
  ,P_USER_ID         IN VARCHAR2
  ,P_MENU_ID         IN VARCHAR2

  ,O_CURSOR          OUT SYS_REFCURSOR
  ,O_RESULT_CURSOR   OUT SYS_REFCURSOR
);

PROCEDURE P_DMF0007_GET_SPREAD_TITLE (
   P_PLAN_WEEK       IN VARCHAR2
  ,P_BUCKET_TYPE     IN VARCHAR2
  ,P_CREATED_BY      IN VARCHAR2
  ,P_USER_ID         IN VARCHAR2
  ,P_MENU_ID         IN VARCHAR2

  ,O_CURSOR          OUT SYS_REFCURSOR
  ,O_RESULT_CURSOR   OUT SYS_REFCURSOR
);

PROCEDURE P_DMF0007_SAVE_CUST_FCST_DATA (
    P_ACTIVE_FLAG           IN VARCHAR2,
    P_DIVISION_ID           IN VARCHAR2,
    P_PLAN_WEEK             IN VARCHAR2,
    P_CUSTOMER_CODE         IN VARCHAR2,
    P_SCM_SITE_ID           IN VARCHAR2,
    P_MEASURE_GROUP         IN VARCHAR2,
    P_MEASURE               IN VARCHAR2,
    P_VALID_YN              IN VARCHAR2,
    P_CUSTOMER_PSI          IN VARCHAR2,
    P_UPLOAD_UOM            IN VARCHAR2,
    P_UPLOAD_BUCKET_TYPE    IN VARCHAR2,
    P_SUMMARY_BUCKET_TYPE   IN VARCHAR2,
    P_SUMMARY_BUCKET_VALUE  IN VARCHAR2,
    P_SUMMARY_BUCKET_YN     IN VARCHAR2,     -- Y: valid_yn값
    P_EDI_FCST_YN           IN VARCHAR2,
    P_CREATED_BY            IN VARCHAR2,
    O_RESULT_CURSOR         OUT SYS_REFCURSOR
);

FUNCTION F_FN_REPLACE_CLOB(
    P_SOURCE      IN CLOB,
    P_SEARCH      IN VARCHAR2,
    P_REPLACEMENT IN CLOB
) RETURN CLOB;

PROCEDURE P_PR_PRINT_CLOB(
    P_TITLE IN VARCHAR2,
    P_TEXT  IN CLOB
);

    -- [2026-09-15 UIPKG] standalone PR_DM_MST_CUSTOMER_FCST_HIST
    PROCEDURE P_PR_DM_MST_CUSTOMER_FCST_HIST 
(
    P_DIVISION_ID            IN VARCHAR2
  , P_PLAN_WEEK              IN VARCHAR2
  , P_CUSTOMER_CODE          IN VARCHAR2
  , P_SCM_SITE_ID            IN VARCHAR2
  , P_SUMMARY_BUCKET_VALUE   IN VARCHAR2
  , P_MEASURE_GROUP          IN VARCHAR2
  , P_MEASURE                IN VARCHAR2
  , P_VALID_YN               IN VARCHAR2
  , P_CUSTOMER_PSI           IN VARCHAR2
  , P_UPLOAD_UOM             IN VARCHAR2
  , P_UPLOAD_BUCKET_TYPE     IN VARCHAR2
  , P_SUMMARY_BUCKET_TYPE    IN VARCHAR2
  , P_EDI_FCST_YN            IN VARCHAR2
  , P_UPLOAD_USER_ID         IN VARCHAR2
  , P_CREATED_BY             IN VARCHAR2
  , P_UPDATE_BY              IN VARCHAR2
);

END PKG_DMF0007;
/
