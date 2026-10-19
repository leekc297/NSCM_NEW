-- SOURCE-FRESH: SCM_MGR.PKG_DMF0014 PACKAGE LAST_DDL=2026-09-15 18:58:03 FETCHED=2026-09-15 21:03 DB=ZIOUI1
-- PKG_DMF0014 PACKAGE — standalone SP 취합본 (사내 적용 2026-09-15)
SET DEFINE OFF
CREATE OR REPLACE PACKAGE SCM_MGR."PKG_DMF0014" IS
    /*
    * Program ID   : PKG_DMF0014
    * Description  : PKG_DMF0014
    * Program History
    *===========================================================================================================
    *   Date       In Charge      Description
    *===========================================================================================================
    * 2026.03.15   김준규       [PJ20264226] NextSCM Pilot 설계 및 개발
    */

    PROCEDURE P_DMF0014_GET_SPREAD_TITLE
    (
        P_START_YYYYMMDD VARCHAR2
       ,P_END_YYYYMMDD   VARCHAR2
       ,P_BUCKET_TYPE    VARCHAR2
       ,P_USER_ID        VARCHAR2
       ,P_MENU_ID        VARCHAR2
       ,O_RC1            OUT SYS_REFCURSOR
       ,O_RESULT_CURSOR  OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0014_CUST_FCST_EXCEL_UPLOAD
    (
        P_MODE          INTEGER
       ,P_CREATED_BY    VARCHAR2
       ,P_PROGRAM_ID    IN VARCHAR2
       ,P_SHEET_NAME    IN VARCHAR2
       ,O_RESULT_CURSOR OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0014_CUST_FCST_EXCEL_UPLOAD_SM
    (
        P_MODE          INTEGER
       ,P_CREATED_BY    VARCHAR2
       ,O_RESULT_CURSOR OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0014_GET_CUST_FCST_UPLOAD_DATA
    (
        P_DIVISION_ID    VARCHAR2
       ,P_DEPT_ID        VARCHAR2
       ,P_END_CUSTOMER   VARCHAR2
       ,P_SCM_SITE_ID    VARCHAR2
       ,P_PLANT_SITE_ID  VARCHAR2
       ,P_PROJECT_CODE   VARCHAR2
       ,P_ITEM_ID        VARCHAR2
       ,P_START_YYYYMMDD VARCHAR2
       ,P_END_YYYYMMDD   VARCHAR2
       ,P_BUCKET_TYPE    VARCHAR2
       ,P_DOM_EXP        VARCHAR2
       ,P_CREATED_BY     VARCHAR2
       , --, p_debug OUT VARCHAR2
        P_USERINFO       VARCHAR2
       ,P_USER_ID        VARCHAR2
       ,P_MENU_ID        VARCHAR2
       ,O_RC1            OUT SYS_REFCURSOR
       ,O_RESULT_CURSOR  OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0014_SAVE_CUST_FCST_UPLOAD_DATA
    (
        P_ACTIVE_FLAG           VARCHAR2
       ,P_DIVISION_ID           VARCHAR2
       ,P_SCM_SITE_ID           VARCHAR2
       ,P_CUSTOMER_PROJECT_CODE VARCHAR2
       ,P_CUSTOMER_MODEL        VARCHAR2
       ,P_INCOTERMS             VARCHAR2
       ,P_FCST_TYPE             VARCHAR2
       ,P_DOM_EXP               VARCHAR2
       ,P_MEASURE_GROUP         VARCHAR2
       ,P_MEASURE               VARCHAR2
       ,P_PLANT_SITE_ID         VARCHAR2
       ,P_UPLOAD_UOM            VARCHAR2
       ,P_PROJECT_CODE          VARCHAR2
       ,P_ITEM_ID               VARCHAR2
       ,P_YYYYMMDD              VARCHAR2
       ,P_QTY                   VARCHAR2
       ,P_CREATED_BY            VARCHAR2
       ,O_RESULT_CURSOR         OUT SYS_REFCURSOR
    );


    -- [E20260814-EXCELFORM] DMF0014 Excel Form 조회 SP (hook #135 표준 — DMF0082 정본 1:1)
    PROCEDURE P_DMF0014_GET_EXCEL_FORM_DATA
    (
        P_DIVISION_ID    VARCHAR2
       ,P_DEPT_ID        VARCHAR2
       ,P_END_CUSTOMER   VARCHAR2
       ,P_SCM_SITE_ID    VARCHAR2
       ,P_PLANT_SITE_ID  VARCHAR2
       ,P_PROJECT_CODE   VARCHAR2
       ,P_ITEM_ID        VARCHAR2
       ,P_START_YYYYMMDD VARCHAR2
       ,P_END_YYYYMMDD   VARCHAR2
       ,P_BUCKET_TYPE    VARCHAR2
       ,P_DOM_EXP        VARCHAR2
       ,P_CREATED_BY     VARCHAR2
       ,P_USERINFO       VARCHAR2
       ,P_USER_ID        VARCHAR2
       ,P_MENU_ID        VARCHAR2
       ,O_RC1            OUT SYS_REFCURSOR
       ,O_RESULT_CURSOR  OUT SYS_REFCURSOR
    );

    -- [2026-09-15 UIPKG] standalone PR_DM_CUST_ITEM_MAPPING
    PROCEDURE P_PR_DM_CUST_ITEM_MAPPING (P_ACCEPT_FLAG VARCHAR2 /* 업무구분(EDI, RPA) */

                                                    );

    -- [2026-09-15 UIPKG] standalone PR_DM_PLN_CUST_FCST_TO_MKT_FCST
    PROCEDURE P_PR_DM_PLN_CUST_FCST_TO_MKT_FCST;

    -- [2026-09-15 UIPKG] standalone PR_DM_PLN_CUST_FCST_TO_MKT_FCST_40
    PROCEDURE P_PR_DM_PLN_CUST_FCST_TO_MKT_FCST_40 (P_DIVISION_ID IN VARCHAR2
    /* p_active_flag            VARCHAR2    -- 필요없음 */
    );

END PKG_DMF0014;
/
