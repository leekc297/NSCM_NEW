CREATE OR REPLACE PACKAGE           "PKG_DMF0043" IS
    /*
    * Program ID   : PKG_DMF0043
    * Description  : PKG_DMF0043
    * Program History
    *===========================================================================================================
    *   Date       In Charge      Description
    *===========================================================================================================
    * 2026.03.15   김준규       [PJ20264226] NextSCM Pilot 설계 및 개발
    */

    PROCEDURE P_DMF0043_GET_CONTRIBUTE_RATE_POPUP
    (
        P_YYYY          VARCHAR2
       ,O_RC1           OUT SYS_REFCURSOR
       ,O_RESULT_CURSOR OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0043_GET_CONTRIBUTE_YEAR_POPUP
    (
        P_USER_ID       VARCHAR2
       ,P_MENU_ID       VARCHAR2
       ,O_RC1           OUT SYS_REFCURSOR
       ,O_RESULT_CURSOR OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0043_GET_CONT_VIEW_VERSIONPOPUP
    (
        P_START_YYYYMMDD VARCHAR2
       ,P_END_YYYYMMDD   VARCHAR2
        --,p_created_by       VARCHAR2,
       ,P_DIVISION_ID  VARCHAR2
       ,P_VERSION_TYPE VARCHAR2
        --,p_version_no       VARCHAR2,
       ,P_DESCRIPTION   VARCHAR2
       ,P_USER_ID       VARCHAR2
       ,P_MENU_ID       VARCHAR2
       ,O_RC1           OUT SYS_REFCURSOR
       ,O_RESULT_CURSOR OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0043_GET_MAIN_SPREAD_TITLE
    (
        P_DIVISION_ID   VARCHAR2
       ,P_YYYY          VARCHAR2
       ,P_CREATED_BY    VARCHAR2
       ,P_USER_ID       VARCHAR2
       ,P_MENU_ID       VARCHAR2
       ,O_RC1           OUT SYS_REFCURSOR
       ,O_RC2           OUT SYS_REFCURSOR
       ,O_RC3           OUT SYS_REFCURSOR
       ,O_RESULT_CURSOR OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0043_GET_MAIN_VARSION_DATA
    (
        P_USER_ID       VARCHAR2
       ,P_MENU_ID       VARCHAR2
       ,O_RC1           OUT SYS_REFCURSOR
       ,O_RESULT_CURSOR OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0043_GET_SALES_LIST_SPREAD_TITLE
    (
        P_DIVISION_ID   VARCHAR2
       ,P_CREATED_BY    VARCHAR2
       ,P_USER_ID       VARCHAR2
       ,P_MENU_ID       VARCHAR2
       ,O_RC1           OUT SYS_REFCURSOR
       ,O_RESULT_CURSOR OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0043_SAVE_DM_MST_CONTRIBUTE_RATIO
    (
        P_ACTIVE_FLAG        VARCHAR2
       ,P_VER_SEQ            VARCHAR2
       ,P_DEPARTMENT_ID      VARCHAR2
       ,P_DEPT_ID            VARCHAR2
       ,P_END_CUST_REPORT    VARCHAR2
       ,P_SOLDTO_CUST_REPORT VARCHAR2
       ,P_PRODUCT_GROUP      VARCHAR2
       ,P_DM_BIZ_TYPE        VARCHAR2
       ,P_YYYYMM             VARCHAR2
       ,P_OS_CORP_CD         VARCHAR2
       ,P_CONTRIBUTION_TYPE  VARCHAR2
       ,P_CONTRIBUTION_RATIO VARCHAR2
       ,P_CREATED_BY         VARCHAR2
       ,O_RESULT_CURSOR      OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0043_SAVE_DM_MST_CONTRIBUTE_VER
    (
        P_ACTIVE_FLAG   VARCHAR2
       ,P_VER_SEQ       VARCHAR2
       ,P_YYYY          VARCHAR2
       ,P_VERSION_NM    VARCHAR2
       ,P_DESCRIPTION   VARCHAR2
       ,P_VALID_YN      VARCHAR2
       ,P_CREATED_BY    VARCHAR2
       ,O_RESULT_CURSOR OUT SYS_REFCURSOR
    );

END PKG_DMF0043;/
