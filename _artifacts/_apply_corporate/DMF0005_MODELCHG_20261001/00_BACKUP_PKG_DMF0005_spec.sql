-- SOURCE-FRESH: SCM_MGR.PKG_DMF0005 PACKAGE LAST_DDL=2026-09-30 19:44:24 FETCHED=2026-10-01 10:49 DB=ZIOUI1
CREATE OR REPLACE PACKAGE         "PKG_DMF0005" IS
/*
 * Program ID   : PKG_DMF0005
 * Description  : PKG_DMF0005
 * Program History
 *===========================================================================================================
 *   Date       In Charge      Description
 *===========================================================================================================
 * 2026.03.16   park.choyi     [PJ20264226] NextSCM Pilot 화면 및 메뉴 개발
 */



  PROCEDURE P_DMF0005_GET_SALES_SITE_MODEL_PRODUCTION (
      P_DIVISION_ID         IN VARCHAR2
    , P_DEPT_ID             IN VARCHAR2
    , P_END_CUSTOMER        IN VARCHAR2
    , P_SCM_SITE_ID         IN VARCHAR2
    , P_PROJECT_CODE        IN VARCHAR2
    , P_ITEM_ID             IN VARCHAR2
    , P_VALID_YN            IN VARCHAR2
    , P_OWNER               IN VARCHAR2
    , P_USER_ID          IN VARCHAR2
    , O_RC1              OUT SYS_REFCURSOR
    , O_RESULT_CURSOR    OUT SYS_REFCURSOR
  );


  PROCEDURE P_DMF0005_GET_SALES_SITE_MODEL_PURCHASE (
      P_DIVISION_ID       IN VARCHAR2
    , P_SCM_SITE_ID        IN VARCHAR2
    , P_PROJECT_CODE   IN VARCHAR2
    , P_ACTIVE_FLAG    IN VARCHAR2
    , P_USER_ID     IN VARCHAR2
    , O_RC1              OUT SYS_REFCURSOR
    , O_RESULT_CURSOR    OUT SYS_REFCURSOR
  );
 
 PROCEDURE P_DMF0005_SAVE_SALES_SITE_MODEL_PRODUCTION (
      P_DATA           IN CLOB
    , P_USER_ID        IN VARCHAR2
    , O_RESULT_CURSOR    OUT SYS_REFCURSOR
  );
 

END PKG_DMF0005;
/
