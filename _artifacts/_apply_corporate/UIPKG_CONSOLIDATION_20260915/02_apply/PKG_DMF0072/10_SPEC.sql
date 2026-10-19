-- SOURCE-FRESH: SCM_MGR.PKG_DMF0072 PACKAGE LAST_DDL=2026-09-02 11:47:10 FETCHED=2026-09-15 18:54 DB=ZIOUI1
SET DEFINE OFF
CREATE OR REPLACE PACKAGE SCM_MGR."PKG_DMF0072" IS
/****************************************************************************************************/
/* Program ID  : PKG_DMF0072                                                                        */
/* Description : PKG_DMF0072                                                                        */
/* Usage       :                                                                                    */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2026.03.23  SSLEE        [PJ20264226] NextSCM Pilot 설계 및 개발                                   */
/*                          UI 항목으로 Package로 전환                                                 */
/****************************************************************************************************/

PROCEDURE P_DMF0072_GET_NNMASTER_MAPPING
(
      P_DATA_TYPE_CODE    IN VARCHAR2
    , P_DIVISION_ID       IN VARCHAR2
    , P_DEPT_ID           IN VARCHAR2   --Department
    , P_END_CUSTOMER      IN VARCHAR2   --Endcustomer
    , P_SCM_SITE_ID       IN VARCHAR2
    , P_PROJECT_CODE      IN VARCHAR2
    , P_ITEM_ID           IN VARCHAR2
    , P_USER_ID           IN VARCHAR2
    , P_MENU_ID           IN VARCHAR2
   
    , O_RC1               OUT SYS_REFCURSOR
    , O_RESULT_CURSOR     OUT SYS_REFCURSOR
);

PROCEDURE P_DMF0072_SAVE_NNMASTER_MAPPING
(
      P_DIVISION_ID              IN VARCHAR2
    , P_COMPANY_ID               IN VARCHAR2
    , P_ACT_TYPE                 IN VARCHAR2  -- 신규 / 수정 구분( I / M)
    , P_CUST_FCST_TYPE           IN VARCHAR2  -- DATA_TYPE_CODE
    , P_END_CUSTOMER             IN VARCHAR2
    , P_CUST_UNLOAD              IN VARCHAR2
    , P_CUST_PLANT               IN VARCHAR2
    , P_SOLDTO                   IN VARCHAR2
    , P_SHIPTO                   IN VARCHAR2
    , P_PROJECT_CODE             IN VARCHAR2
    , P_SCM_SITE_ID              IN VARCHAR2
    , P_FCST_TYPE                IN VARCHAR2
    , P_INCOTERMS                IN VARCHAR2
    , P_DOM_EXP                  IN VARCHAR2
    , P_CUST_ITEM_ID             IN VARCHAR2
    , P_MDM_CODE                 IN VARCHAR2
    , P_MAPPING_ITEM_ID          IN VARCHAR2
    , P_MAPPING_ITEM_ID_ORIGINAL IN VARCHAR2  --P_MAPPING_ITEM_ID가 KEY인데 수정 해야 해서 원본 값을 가져온다.
    , P_ACTIVE_FLAG              IN VARCHAR2
    , P_VALID_FROM               IN VARCHAR2
    , P_VALID_TO                 IN VARCHAR2
    , P_USER_ID                  IN VARCHAR2
    , O_RESULT_CURSOR            OUT SYS_REFCURSOR
);


    -- [2026-09-15 UIPKG] standalone DMF0072_GET_DATA_TYPE_LIST
    PROCEDURE P_DMF0072_GET_DATA_TYPE_LIST (
    O_RC1 OUT SYS_REFCURSOR
);

    -- [2026-09-15 UIPKG] standalone DMF0072_GET_END_CUSTOMER_LIST
    PROCEDURE P_DMF0072_GET_END_CUSTOMER_LIST (
    P_DIVISION_ID VARCHAR2,
    P_DEPT_ID     VARCHAR2,
    O_RC1 OUT SYS_REFCURSOR
);

    -- [2026-09-15 UIPKG] standalone DMF0072_GET_NNMASTER_MAPPING_WRAPPER
    PROCEDURE P_DMF0072_GET_NNMASTER_MAPPING_WRAPPER (
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
);

    -- [2026-09-15 UIPKG] standalone DMF0072_GET_SALES_SITE_LIST
    PROCEDURE P_DMF0072_GET_SALES_SITE_LIST (
    P_DIVISION_ID  VARCHAR2,
    P_END_CUSTOMER VARCHAR2,
    O_RC1 OUT SYS_REFCURSOR
);

    -- [2026-09-15 UIPKG] standalone DMF0072_GET_TEAM_LIST
    PROCEDURE P_DMF0072_GET_TEAM_LIST (
    P_DIVISION_ID VARCHAR2,
    O_RC1 OUT SYS_REFCURSOR
);

END PKG_DMF0072;
/
