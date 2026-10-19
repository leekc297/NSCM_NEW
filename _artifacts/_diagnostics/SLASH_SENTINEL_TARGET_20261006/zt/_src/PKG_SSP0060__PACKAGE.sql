PACKAGE PKG_SSP0060
IS
/*
 * Program ID   : PKG_SSP0060
 * Description  : SSP0060 Shipment Plan 화면 프로시저 패키지
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2026.09.22   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
 */

    PROCEDURE P_SSP0060_GET_SHIPMENT_DIVISION
    (
        PARAM1                  IN  VARCHAR2
       ,PARAM2                  IN  VARCHAR2
       ,O_RC1                   OUT SYS_REFCURSOR
       ,O_RC2                   OUT SYS_REFCURSOR
    );

    PROCEDURE P_SSP0060_GET_SHIPMENT_STATUS
    (
        P_DIVISION_ID           IN  VARCHAR2
       ,P_CONFIRM_ID            IN  VARCHAR2
       ,O_RC1                   OUT SYS_REFCURSOR
       ,O_RC2                   OUT SYS_REFCURSOR
       ,O_RC3                   OUT SYS_REFCURSOR
    );

    PROCEDURE P_SSP0060_GET_ERP_SO_NO_CNT
    (
        P_DIVISION_ID           IN  VARCHAR2
       ,P_ERP_SO_NO             IN  VARCHAR2
       ,O_RC1                   OUT SYS_REFCURSOR
    );

    PROCEDURE P_SSP0060_GET_SHIPMENT_PSI_COMMENTS
    (
        P_DIVISION_ID           IN  VARCHAR2
       ,P_COMPANY_ID            IN  VARCHAR2
       ,P_PLAN_START_YYYYMMDD   IN  VARCHAR2
       ,P_FROM_SITE             IN  VARCHAR2
       ,P_ITEM_ID               IN  VARCHAR2
       ,P_FROM_YYYYMMDD         IN  VARCHAR2
       ,P_TO_YYYYMMDD           IN  VARCHAR2
       ,O_RC1                   OUT SYS_REFCURSOR
    );

    PROCEDURE P_SSP0060_GET_HOLD_STOCK
    (
        P_DIVISION_ID           IN  VARCHAR2
       ,P_FROM_SITE             IN  VARCHAR2
       ,P_ITEM_ID               IN  VARCHAR2
       ,P_PRODUCT_LEVEL1        IN  VARCHAR2
       ,P_PLAN_START_YYYYMMDD   IN  VARCHAR2
       ,P_PLAN_TYPE             IN  VARCHAR2
       ,P_SEQ                   IN  VARCHAR2
       ,P_LANGUAGE              IN  VARCHAR2
       ,P_SEARCH_YN             IN  VARCHAR2
       ,P_USER_ID               IN  VARCHAR2
       ,O_RC1                   OUT SYS_REFCURSOR
    );

    PROCEDURE P_SSP0060_GET_MES_STOCK
    (
        P_DIVISION_ID           IN  VARCHAR2
       ,P_COMPANY_ID            IN  VARCHAR2
       ,P_FROM_SITE             IN  VARCHAR2
       ,P_ITEM_ID               IN  VARCHAR2
       ,P_PRODUCT_LEVEL1        IN  VARCHAR2
       ,P_PLAN_START_YYYYMMDD   IN  VARCHAR2
       ,P_DBL_FLAG              IN  VARCHAR2
       ,P_LANGUAGE              IN  VARCHAR2
       ,P_PROGRAM_ID            IN  VARCHAR2
       ,P_SHEET_NAME            IN  VARCHAR2
       ,DEBUG_MODE              IN  VARCHAR2
       ,O_RC1                   OUT SYS_REFCURSOR
    );

    PROCEDURE P_SSP0060_GET_MES_STOCK_DETAIL
    (
        P_DIVISION_ID           IN  VARCHAR2
       ,P_COMPANY_ID            IN  VARCHAR2
       ,P_FROM_SITE             IN  VARCHAR2
       ,P_ITEM_ID               IN  VARCHAR2
       ,P_PRODUCT_LEVEL1        IN  VARCHAR2
       ,P_BOX_ID                IN  VARCHAR2
       ,P_PLAN_START_YYYYMMDD   IN  VARCHAR2
       ,P_DBL_FLAG              IN  VARCHAR2
       ,P_LANGUAGE              IN  VARCHAR2
       ,P_PROGRAM_ID            IN  VARCHAR2
       ,P_SHEET_NAME            IN  VARCHAR2
       ,DEBUG_MODE              IN  VARCHAR2
       ,O_RC1                   OUT SYS_REFCURSOR
    );

    PROCEDURE P_SSP0060_GET_OWMS_DETAIL
    (
        P_DIVISION_ID           IN  VARCHAR2
       ,P_COMPANY_ID            IN  VARCHAR2
       ,P_FROM_SITE             IN  VARCHAR2
       ,P_ITEM_ID               IN  VARCHAR2
       ,P_PRODUCT_LEVEL1        IN  VARCHAR2
       ,P_PLAN_START_YYYYMMDD   IN  VARCHAR2
       ,P_DBL_FLAG              IN  VARCHAR2
       ,P_LANGUAGE              IN  VARCHAR2
       ,P_PROGRAM_ID            IN  VARCHAR2
       ,P_SHEET_NAME            IN  VARCHAR2
       ,DEBUG_MODE              IN  VARCHAR2
       ,O_RC1                   OUT SYS_REFCURSOR
    );

    PROCEDURE P_SSP0060_GET_STOCK_LOCATION_DETAIL
    (
        P_DIVISION_ID           IN  VARCHAR2
       ,P_COMPANY_ID            IN  VARCHAR2
       ,P_FROM_SITE             IN  VARCHAR2
       ,P_ITEM_ID               IN  VARCHAR2
       ,P_PRODUCT_LEVEL1        IN  VARCHAR2
       ,P_PLAN_START_YYYYMMDD   IN  VARCHAR2
       ,P_DBL_FLAG              IN  VARCHAR2
       ,P_LANGUAGE              IN  VARCHAR2
       ,P_PROGRAM_ID            IN  VARCHAR2
       ,P_SHEET_NAME            IN  VARCHAR2
       ,DEBUG_MODE              IN  VARCHAR2
       ,O_RC1                   OUT SYS_REFCURSOR
    );

    PROCEDURE P_SSP0060_GET_SHIPMENT_RESULT
    (
        P_DIVISION_ID           IN  VARCHAR2
       ,P_FROM_SITE             IN  VARCHAR2
       ,P_ITEM_ID               IN  VARCHAR2
       ,P_PRODUCT_LEVEL1        IN  VARCHAR2
       ,P_FROM_YYYYMMDD         IN  VARCHAR2
       ,P_TO_YYYYMMDD           IN  VARCHAR2
       ,P_TYPE                  IN  VARCHAR2
       ,P_USER_ID               IN  VARCHAR2
       ,P_COMPANY_ID            IN  VARCHAR2
       ,P_MYMODELCHK            IN  VARCHAR2
       ,P_PARTLEADERCHK         IN  VARCHAR2
       ,P_TEAMLEADERCHK         IN  VARCHAR2
       ,P_DELEGATEECHK          IN  VARCHAR2
       ,P_NONCHK                IN  VARCHAR2
       ,P_REAL_FLAG             IN  VARCHAR2
       ,P_PLAN_START_YYYYMMDD   IN  VARCHAR2
       ,O_RC1                   OUT SYS_REFCURSOR
    );

    PROCEDURE P_SSP0060_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING
    (
        P_CHANGE_REQUEST_NO     IN  VARCHAR2
       ,P_USER_ID               IN  VARCHAR2
       ,P_LANGUAGE              IN  VARCHAR2
       ,O_RC1                   OUT SYS_REFCURSOR
       ,O_RC2                   OUT SYS_REFCURSOR
    );

    PROCEDURE P_SSP0060_GET_SHIPMENT_PLAN
    (
        P_DIVISION_ID           IN  VARCHAR2
       ,P_COMPANY_ID            IN  VARCHAR2
       ,P_FROM_SITE             IN  VARCHAR2
       ,P_PLAN_START_YYYYMMDD   IN  VARCHAR2
       ,P_FROM_YYYYMMDD         IN  VARCHAR2
       ,P_TO_YYYYMMDD           IN  VARCHAR2
       ,P_ITEM_ID               IN  VARCHAR2
       ,P_PRODUCT_LEVEL1        IN  VARCHAR2
       ,P_USER_ID               IN  VARCHAR2
       ,P_PROGRAM_ID            IN  VARCHAR2
       ,P_SHEET_NAME            IN  VARCHAR2
       ,P_REAL_FLAG             IN  VARCHAR2
       ,O_RC1                   OUT SYS_REFCURSOR
       ,O_RC2                   OUT SYS_REFCURSOR
    );

    PROCEDURE P_SSP0060_GET_SHIPMENT_PLAN_DETAIL
    (
        P_DIVISION_ID           IN  VARCHAR2
       ,P_COMPANY_ID            IN  VARCHAR2
       ,P_FROM_SITE             IN  VARCHAR2
       ,P_ITEM_ID               IN  VARCHAR2
       ,P_PRODUCT_LEVEL1        IN  VARCHAR2
       ,P_REQUESTOR             IN  VARCHAR2
       ,P_TO_SITE               IN  VARCHAR2
       ,P_TRANSPORT_MODE        IN  VARCHAR2
       ,P_INCOTERMS             IN  VARCHAR2
       ,P_FCST_TYPE             IN  VARCHAR2
       ,P_PLAN_START_YYYYMMDD   IN  VARCHAR2
       ,P_FROM_YYYYMMDD         IN  VARCHAR2
       ,P_TO_YYYYMMDD           IN  VARCHAR2
       ,P_DBL_FLAG              IN  VARCHAR2
       ,P_REAL_FLAG             IN  VARCHAR2
       ,P_LANGUAGE              IN  VARCHAR2
       ,P_PROGRAM_ID            IN  VARCHAR2
       ,P_SHEET_NAME            IN  VARCHAR2
       ,DEBUG_MODE              IN  VARCHAR2
       ,O_RC1                   OUT SYS_REFCURSOR
    );

    PROCEDURE P_SSP0060_DELETE_SHIPMENT_REQUEST_DRAFTING
    (
        P_CHANGE_REQUEST_NO     IN  VARCHAR2
       ,P_USER_ID               IN  VARCHAR2
       ,O_RC1                   OUT SYS_REFCURSOR
       ,O_RC2                   OUT SYS_REFCURSOR
    );

    PROCEDURE P_SSP0060_SAVE_SHIPMENT_REQUEST_DRAFTING_MAIN
    (
        P_ACTIVE_FLAG           IN  VARCHAR2
       ,P_DIVISION_ID           IN  VARCHAR2
       ,P_CHANGE_REQ_NO         IN  VARCHAR2
       ,P_CONFIRM_ID            IN  VARCHAR2
       ,P_SHIPMENT_QTY          IN  VARCHAR2
       ,P_SHIPMENT_DATE         IN  VARCHAR2
       ,P_NEW_YYYYMMDD          IN  VARCHAR2
       ,P_NEW_QTY               IN  VARCHAR2
       ,P_USER_ID               IN  VARCHAR2
       ,P_CHANGE_REASON_CODE    IN  VARCHAR2
       ,P_CHANGE_REASON_DETAIL  IN  VARCHAR2
       ,P_TITLE                 IN  VARCHAR2
       ,P_PROGRAM_ID            IN  VARCHAR2
       ,O_RC1                   OUT SYS_REFCURSOR
       ,O_RC2                   OUT SYS_REFCURSOR
    );

    PROCEDURE P_SSP0060_SAVE_SHIPMENT_PLAN
    (
        P_ACTIVE_FLAG           IN  VARCHAR2
       ,P_DIVISION_ID           IN  VARCHAR2
       ,P_COMPANY_ID            IN  VARCHAR2
       ,P_FROM_SITE             IN  VARCHAR2
       ,P_ITEM_ID               IN  VARCHAR2
       ,P_TO_SITE               IN  VARCHAR2
       ,P_TRANSPORT_MODE        IN  VARCHAR2
       ,P_INCOTERMS             IN  VARCHAR2
       ,P_FCST_TYPE             IN  VARCHAR2
       ,P_PLAN_START_YYYYMMDD   IN  VARCHAR2
       ,P_YYYYMMDD              IN  VARCHAR2
       ,P_SHIPMENT_QTY          IN  VARCHAR2
       ,P_USER_ID               IN  VARCHAR2
       ,P_USER_DEPT_ID          IN  VARCHAR2
       ,DEBUG_MODE              IN  VARCHAR2
       ,O_RC1                   OUT SYS_REFCURSOR
       ,O_RC2                   OUT SYS_REFCURSOR
    );

    PROCEDURE P_SSP0060_SAVE_SHIPMENT_REQUEST_DRAFTING
    (
        P_ACTIVE_FLAG               IN  VARCHAR2
       ,P_DIVISION_ID               IN  VARCHAR2
       ,P_CONFIRM_ID                IN  VARCHAR2
       ,P_SHIPMENT_QTY              IN  VARCHAR2
       ,P_SHIPMENT_DATE             IN  VARCHAR2
       ,P_FROM_SITE                 IN  VARCHAR2
       ,P_NEW_BOD_ID                IN  VARCHAR2
       ,P_NEW_ROUTE_ID              IN  VARCHAR2
       ,P_NEW_ETD_DATE              IN  VARCHAR2
       ,P_NEW_ETA_DATE              IN  VARCHAR2
       ,P_NEW_INCOTERMS             IN  VARCHAR2
       ,P_NEW_TRANSPORT_MODE        IN  VARCHAR2
       ,P_NEW_D_CONTRY              IN  VARCHAR2
       ,P_NEW_D_PORT_CODE           IN  VARCHAR2
       ,P_NEW_A_COUNTRY             IN  VARCHAR2
       ,P_NEW_A_PORT_CODE           IN  VARCHAR2
       ,P_NEW_CUSTOMER_LT           IN  VARCHAR2
       ,P_NEW_TO_COUNTRY            IN  VARCHAR2
       ,P_NEW_TO_CITY               IN  VARCHAR2
       ,P_EDIT_MAIN                 IN  VARCHAR2
       ,P_EDIT_REMARK               IN  VARCHAR2
       ,P_USER_ID                   IN  VARCHAR2
       ,P_USER_DEPT_ID              IN  VARCHAR2
       ,P_ELECTRODE_YN              IN  VARCHAR2
       ,P_ELECTRODE_TYPE            IN  VARCHAR2
       ,P_ORIGIN_FROM_DIVISION_ID   IN  VARCHAR2
       ,P_ORIGION_TO_DIVISION_ID    IN  VARCHAR2
       ,P_REMARKS                   IN  VARCHAR2
       ,P_REMARKS2                  IN  VARCHAR2
       ,P_REMARKS3                  IN  VARCHAR2
       ,P_CHANGE_REASON_CODE        IN  VARCHAR2
       ,P_CHANGE_REASON_DETAIL      IN  VARCHAR2
       ,P_TITLE                     IN  VARCHAR2
       ,P_PROGRAM_ID                IN  VARCHAR2
       ,O_RC1                       OUT SYS_REFCURSOR
       ,O_RC2                       OUT SYS_REFCURSOR
    );

    PROCEDURE P_SSP0060_SAVE_SHIPMENT_REQUEST_CONFIRM
    (
        P_ACTIVE_FLAG               IN  VARCHAR2
       ,P_DIVISION_ID               IN  VARCHAR2
       ,P_CHANGE_REQUEST_NO         IN  VARCHAR2
       ,P_CONFIRM_ID                IN  VARCHAR2
       ,P_PRODUCT_LEVEL1            IN  VARCHAR2
       ,P_ITEM_ID                   IN  VARCHAR2
       ,P_NICK_NAME                 IN  VARCHAR2
       ,P_FROM_SITE                 IN  VARCHAR2
       ,P_TO_SITE                   IN  VARCHAR2
       ,P_PROJECT_CODE              IN  VARCHAR2
       ,P_PROJECT_NAME              IN  VARCHAR2
       ,P_FCST_TYPE                 IN  VARCHAR2
       ,P_ETD                       IN  VARCHAR2
       ,P_ETA                       IN  VARCHAR2
       ,P_SHIPMENT_QTY              IN  VARCHAR2
       ,P_SHIPMENT_DATE             IN  VARCHAR2
       ,P_NEW_BOD_ID                IN  VARCHAR2
       ,P_NEW_ROUTE_ID              IN  VARCHAR2
       ,P_NEW_ETD_DATE              IN  VARCHAR2
       ,P_NEW_ETA_DATE              IN  VARCHAR2
       ,P_NEW_INCOTERMS             IN  VARCHAR2
       ,P_NEW_TRANSPORT_MODE        IN  VARCHAR2
       ,P_NEW_D_COUNTRY             IN  VARCHAR2
       ,P_NEW_D_PORT_CODE           IN  VARCHAR2
       ,P_NEW_A_COUNTRY             IN  VARCHAR2
       ,P_NEW_A_PORT_CODE           IN  VARCHAR2
       ,P_NEW_CUSTOMER_LT           IN  VARCHAR2
       ,P_NEW_TO_COUNTRY            IN  VARCHAR2
       ,P_NEW_TO_CITY               IN  VARCHAR2
       ,P_REMARKS                   IN  VARCHAR2
       ,P_REMARKS2                  IN  VARCHAR2
       ,P_REMARKS3                  IN  VARCHAR2
       ,P_CHECK_NEED_YN             IN  VARCHAR2
       ,P_USER_ID                   IN  VARCHAR2
       ,P_EDIT_MAIN                 IN  VARCHAR2
       ,P_CHANGE_REASON_CODE        IN  VARCHAR2
       ,P_CHANGE_REASON_DETAIL      IN  VARCHAR2
       ,P_TOP_FLAG                  IN  VARCHAR2
       ,O_RC1                       OUT SYS_REFCURSOR
       ,O_RC2                       OUT SYS_REFCURSOR
    );

END PKG_SSP0060;