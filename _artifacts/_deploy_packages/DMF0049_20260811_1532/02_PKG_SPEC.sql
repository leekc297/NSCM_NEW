-- ============================================================================
-- PKG_DMF0049 — PACKAGE SPEC (live)
--   생성: 2026-08-11 15:32:35 (build_cloud_packages_20260811.py — 사내 live 실측)
--   대상: 클라우드 QA·DEV **2DB 동시 적용** 의무
--   ⚠ MERGE 는 DELETE 절이 없다 — 클라우드 고유 행은 삭제되지 않는다.
-- ============================================================================
SET DEFINE OFF

CREATE OR REPLACE PACKAGE           "PKG_DMF0049" IS
    /*
    * Program ID   : PKG_DMF0049
    * Description  : PKG_DMF0049
    * Program History
    *===========================================================================================================
    *   Date       In Charge      Description
    *===========================================================================================================
    * 2026.03.15   김준규       [PJ20264226] NextSCM Pilot 설계 및 개발
    */

    PROCEDURE P_DMF0049_GET_MEASURE
    (
        P_DIVISION_ID   VARCHAR2
       ,P_USER_ID       VARCHAR2
       ,P_MENU_ID       VARCHAR2
       ,O_RC1           OUT SYS_REFCURSOR
       ,O_RESULT_CURSOR OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0049_GET_SPREAD_TITLE
    (
        P_DIVISION_ID   VARCHAR2
       ,P_CREATED_BY    VARCHAR2
       ,P_START_DT      VARCHAR2
       ,P_END_DT        VARCHAR2
       ,P_USER_ID       VARCHAR2
       ,P_MENU_ID       VARCHAR2
       ,O_RC1           OUT SYS_REFCURSOR
       ,O_RESULT_CURSOR OUT SYS_REFCURSOR
    );

    -- [PKG CONSOLIDATION 20260723] 신규 멤버 2
    PROCEDURE P_DMF0049_GET_SALES_ETC_REPORTS_DATA
    (
        P_DIVISION_ID IN VARCHAR2
      , P_MDF_TYPE IN VARCHAR2
      , P_YYYY IN VARCHAR2
      , P_SP_VERSION_NO IN VARCHAR2
      , P_USER_GROUP IN VARCHAR2
      , P_CREATED_BY IN VARCHAR2
      , P_USER_ID IN VARCHAR2
      , P_MENU_ID IN VARCHAR2
      , O_RC1 OUT SYS_REFCURSOR
      , O_RESULT_CURSOR OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0049_SAVE_SALES_ETC_REPORT_C
    (
        P_ACTIVE_FLAG IN VARCHAR2
      , P_RESULT_MONTH IN VARCHAR2
      , P_DIVISION_ID IN VARCHAR2
      , P_VERSION_NO IN VARCHAR2
      , P_DATA_SEQ IN VARCHAR2
      , P_DEPARTMENT_ID IN VARCHAR2
      , P_DEPARTMENT_EDIT_FLAG IN VARCHAR2
      , P_DEPARTMENT_NAME IN VARCHAR2
      , P_DEPT_ID IN VARCHAR2
      , P_CUST_REPORT IN VARCHAR2
      , P_END_CUST_REPORT IN VARCHAR2
      , P_SOLDTO_CODE IN VARCHAR2
      , P_SOLDTO_CUST_REPORT IN VARCHAR2
      , P_PRODUCT_GROUP IN VARCHAR2
      , P_ITEM_ID IN VARCHAR2
      , P_PRODUCT_DETAILS IN VARCHAR2
      , P_CURRENCY IN VARCHAR2
      , P_COMPANY_ID IN VARCHAR2
      , P_BIZ_TYPE IN VARCHAR2
      , P_APPLICATION_GR IN VARCHAR2
      , P_APPLICATION IN VARCHAR2
      , P_COUNTRY_CODE IN VARCHAR2
      , P_PROJECT_CODE IN VARCHAR2
      , P_SCM_SITE_ID IN VARCHAR2
      , P_FCST_TYPE IN VARCHAR2
      , P_ITEM_USE IN VARCHAR2
      , P_SOLDTO_COUNTRY IN VARCHAR2
      , P_SHIPTO_COUNTRY IN VARCHAR2
      , P_END_CUSTOMER IN VARCHAR2
      , P_ETC_DESCR IN VARCHAR2
      , P_CELL_MODEL_INFO IN VARCHAR2
      , P_CELL_MODEL IN VARCHAR2
      , P_MEASURE IN VARCHAR2
      , P_YYYYMMDD IN VARCHAR2
      , P_QTY IN VARCHAR2
      , P_CREATED_BY IN VARCHAR2
      , O_RESULT_CURSOR OUT SYS_REFCURSOR
    );

END PKG_DMF0049;
/
