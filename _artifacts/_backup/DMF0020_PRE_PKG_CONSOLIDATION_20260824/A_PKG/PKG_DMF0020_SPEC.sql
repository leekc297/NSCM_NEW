-- [BACKUP 2026-08-24] SCM_MGR.PKG_DMF0020 (PACKAGE, VALID)
-- 원본 LAST_DDL = 2026-08-24 09:32:48

CREATE OR REPLACE PACKAGE           "PKG_DMF0020" 
/*
 * Program ID   : PKG_DMF0020
 * Description  : PKG_DMF0200
 * Program History
 *===========================================================================================================
 *   Date       In Charge      Description
 *===========================================================================================================
 * 2026.03.19   jcnam       [PJ20264226] NextSCM Pilot 설계 및 개발
 *                          UI 항목으로 Package로 전환
 */
AS
    -- 프로시저 선언
    PROCEDURE P_DMF0020_GET_MEASURE_COUNTINFO_SAVE_PRICE
    (
    /* 보류 PCI 협의 3/19
        P_USER_ID         IN VARCHAR2, -- For EditYn
        P_MNU_ID          IN VARCHAR2, -- For EditYn
    */
        O_RC1             OUT SYS_REFCURSOR,
        O_RESULT_CURSOR   OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0020_GET_MEASURE_COUNTINFO
    (
        /*
        P_USER_ID         IN VARCHAR2, -- For EditYn
        P_MNU_ID          IN VARCHAR2, -- For EditYn
        */
        O_RC1             OUT SYS_REFCURSOR,
        O_RESULT_CURSOR   OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0020_GET_EXCHANGE_POPUP_SPREAD_TITLE
    (
        P_START_YYYYMMDD  IN VARCHAR2,
        P_END_YYYYMMDD    IN VARCHAR2,
        O_RC1             OUT SYS_REFCURSOR,
        O_RESULT_CURSOR   OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0020_GET_FUTUREPRICE_INFO
    (
    P_START_YYYYMMDD  IN VARCHAR2,
    P_END_YYYYMMDD    IN VARCHAR2,

    P_USER_ID         IN VARCHAR2, -- For EditYn
    P_MNU_ID          IN VARCHAR2, -- For EditYn

    O_RC1             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0000_SAVE_EXCHANGE_POPUP_DATA
    (
      P_ACTIVE_FLAG            IN VARCHAR2,
      P_DIVISION_ID            IN VARCHAR2,
      P_YYYYMMDD               IN VARCHAR2,
      P_CURRENCY               IN VARCHAR2,
      P_UNIT_CURRENCY          IN VARCHAR2,
      P_EXCHANGE_PRICE         IN VARCHAR2,
      P_CREATED_BY             IN VARCHAR2,
      P_LAST_UPDATED_BY        IN VARCHAR2,
      O_RESULT_CURSOR          OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0020_EXCEL_UPLOAD
    (
      P_MODE            IN PLS_INTEGER,
      P_CREATED_BY      IN VARCHAR2,
      P_PROGRAM_ID      IN VARCHAR2,  -- 3/26 추가 결정
      P_SHEET_NAME      IN VARCHAR2,  -- 3/26 추가 결정

      O_RESULT_CURSOR   OUT SYS_REFCURSOR
    );

    -- 3/20
    /*
    DMF0020_GET_SPREAD_TITLE
    DMF0020_GET_SALES_PRICE_TEMPLATE
    DMF0020_GET_SCM_MST_FUTURE_PRICE_POPUP
    DMF0020_GET_SCM_MST_FUTURE_PRICE_POPUP_DATA
    DMF0020_GET_SPREAD_TITLE_SAVE_PRICE
    DMF0020_GET_SPREAD_TITLE_DATE
    DMF0020_GET_OWNER_DATA
    */
    PROCEDURE P_DMF0020_GET_SPREAD_TITLE
    (
        P_START_DT     IN VARCHAR2,
        P_END_DT       IN VARCHAR2,
        P_CREATED_BY   IN VARCHAR2,
        P_DIVISION_ID  IN VARCHAR2,
        O_RC1          OUT SYS_REFCURSOR,
        O_RESULT_CURSOR OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0020_GET_SALES_PRICE_TEMPLATE
    (
        P_DIVISION_ID   IN VARCHAR2,
        P_USER_ID         IN VARCHAR2, -- For EditYn
        P_MNU_ID          IN VARCHAR2, -- For EditYn
        O_RC1           OUT SYS_REFCURSOR,
        O_RESULT_CURSOR OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0020_GET_SCM_MST_FUTURE_PRICE_POPUP
    (
        P_DIVISION_ID     IN VARCHAR2,
        P_FROM_YYYYMMDD   IN VARCHAR2,
        P_TO_YYYYMMDD     IN VARCHAR2,
        P_CREATED_BY      IN VARCHAR2,
        P_USER_ID         IN VARCHAR2, -- For EditYn
        P_MNU_ID          IN VARCHAR2, -- For EditYn
        O_RC1             OUT SYS_REFCURSOR,
        O_RESULT_CURSOR   OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0020_GET_SCM_MST_FUTURE_PRICE_POPUP_DATA
    (
        P_DIVISION_ID     IN VARCHAR2,
        P_FROM_YYYYMMDD   IN VARCHAR2,
        P_TO_YYYYMMDD     IN VARCHAR2,
        P_CREATED_BY      IN VARCHAR2,
        P_USER_ID         IN VARCHAR2, -- For EditYn
        P_MNU_ID          IN VARCHAR2, -- For EditYn
        O_RC1             OUT SYS_REFCURSOR,
        O_RESULT_CURSOR   OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0020_GET_SPREAD_TITLE_SAVE_PRICE
    (
        P_START_DT        IN VARCHAR2,
        P_END_DT          IN VARCHAR2,
        P_CREATED_BY      IN VARCHAR2,
        P_DIVISION_ID     IN VARCHAR2,
        O_RC1             OUT SYS_REFCURSOR,
        O_RESULT_CURSOR   OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0020_GET_SPREAD_TITLE_DATE
    (
        P_START_YYYYMMDD  IN VARCHAR2,
        P_END_YYYYMMDD    IN VARCHAR2,
        P_CREATED_BY      IN VARCHAR2,
        O_RC1             OUT SYS_REFCURSOR,
        O_RESULT_CURSOR   OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0020_GET_OWNER_DATA
    (
        P_DIVISION_ID     IN VARCHAR2,
        P_DEPT_ID         IN VARCHAR2,
        P_END_CUSTOMER    IN VARCHAR2,
        P_PROJECT_CODE    IN VARCHAR2,
        P_SCM_SITE_ID     IN VARCHAR2,
        P_OWNER_ID        IN VARCHAR2,

        P_USER_ID         IN VARCHAR2, -- For EditYn
        P_MNU_ID          IN VARCHAR2, -- For EditYn

        O_RC1             OUT SYS_REFCURSOR,
        O_RESULT_CURSOR   OUT SYS_REFCURSOR
    );

    -- 3/23
    PROCEDURE P_DMF0020_GET_WEEKDATA
    (
        P_YYYYMMDD        IN VARCHAR2,
        O_RC1             OUT SYS_REFCURSOR,
        O_RESULT_CURSOR   OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0020_SAVE_DM_MST_EXCHANGE_RATE_ALL
    (
        P_ACTIVE_FLAG       IN VARCHAR2,
        P_DIVISION_ID       IN VARCHAR2,
        P_YYYYMMDD          IN VARCHAR2,
        P_CURRENCY          IN VARCHAR2,
        P_UNIT_CURRENCY     IN VARCHAR2,
        P_EXCHANGE_PRICE    IN VARCHAR2,
        P_CREATED_BY        IN VARCHAR2,
        P_LAST_UPDATED_BY   IN VARCHAR2,
        O_RESULT_CURSOR     OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_CONVERSION
    (
        P_DIVISION_ID     IN VARCHAR2,
        O_RESULT_CURSOR   OUT SYS_REFCURSOR
    );




END PKG_DMF0020;
/
