-- SOURCE-FRESH: SCM_MGR.PKG_DMF0004 PACKAGE LAST_DDL=2026-09-02 11:47:09 FETCHED=2026-09-28 20:15 DB=ZIOUI1
CREATE OR REPLACE PACKAGE           "PKG_DMF0004" IS
/*
 * Program ID   : PKG_DMF0003
 * Description  : PKG_DMF0003
 * Program History
 *===========================================================================================================
 *   Date       In Charge      Description
 *===========================================================================================================
 * 2026.03.09   park.choyi     [PJ20264226] NextSCM Pilot 화면 및 메뉴 개발
 */


    PROCEDURE P_DMF0004_GET_SALES_SITE_DATA(
        P_DIVISION_ID        IN VARCHAR2,

        P_END_CUSTOMER       IN VARCHAR2,
        P_SCM_SITE_ID        IN VARCHAR2,
        P_ACTIVE_FLAG        IN VARCHAR2,
        P_SOLDTO_CUSTOMER    IN VARCHAR2,
        P_USER_ID            IN VARCHAR2,
        P_MENU_ID            IN VARCHAR2,

        o_rc1                OUT SYS_REFCURSOR,
        O_RESULT_CURSOR    OUT SYS_REFCURSOR
    );
 
    PROCEDURE P_DMF0004_SAVE_SALES_SITE_DATA(

      P_DATA      IN  CLOB,
      P_USER_ID   IN  VARCHAR2,
      O_RESULT_CURSOR    OUT SYS_REFCURSOR
    );
    
   PROCEDURE P_DMF0004_GET_SALES_SITE_DETAIL_DATA(
  		P_DIVISION_ID IN VARCHAR2,
  		P_SCM_SITE_ID IN VARCHAR2,
  		P_ACTIVE_FLAG IN VARCHAR2,
  		P_USER_ID IN VARCHAR2,
  		o_rc1 OUT SYS_REFCURSOR,
  		o_rc2 OUT SYS_REFCURSOR,
  		o_rc3 OUT SYS_REFCURSOR,
      O_RESULT_CURSOR    OUT SYS_REFCURSOR
   );
     
  PROCEDURE P_DMF0004_SAVE_SALES_SITE_CUSTOMER_DATA (
      P_DATA      IN  CLOB,
      P_USER_ID   IN  VARCHAR2,
      O_RESULT_CURSOR    OUT SYS_REFCURSOR
  );
    
  PROCEDURE P_DMF0004_SAVE_SALES_SITE_LOCATION_DATA (
        P_DATA      IN  CLOB
      , P_USER_ID   IN  VARCHAR2
      , O_RESULT_CURSOR    OUT SYS_REFCURSOR
  );
  
  PROCEDURE P_DMF0004_SAVE_SALES_SITE_BUCKET_DATA (
        P_DATA      IN  CLOB
      , P_USER_ID   IN  VARCHAR2
      , O_RESULT_CURSOR    OUT SYS_REFCURSOR
  );


    PROCEDURE P_DMF0004_GET_SOLDTO_CUSTOMER_DATA(
        P_DIVISION_ID        IN VARCHAR2
      , P_DEPT_ID            IN VARCHAR2
      , o_rc1                OUT SYS_REFCURSOR
      , O_RESULT_CURSOR      OUT SYS_REFCURSOR
    );

END PKG_DMF0004;
/
