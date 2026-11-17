PACKAGE         PKG_SSP0023
IS
/*
 * Program ID   : PKG_SSP0023
 * Description  : SSP0023 Shipment Plan(Electrode) 화면 프로시저 패키지
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2026.09.23   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
 */

    PROCEDURE P_SSP0023_GET_SHEET_CALENDAR_3SPAN
    (
        P_START_YYYYMMDD        IN  VARCHAR2
       ,P_END_YYYYMMDD          IN  VARCHAR2
       ,O_RC1                   OUT SYS_REFCURSOR
    );

    PROCEDURE P_SSP0023_GET_SHIPMENT_PLAN
    (
        P_DIVISION_ID           IN  VARCHAR2
       ,P_COMPANY_ID            IN  VARCHAR2
       ,P_FROM_SITE             IN  VARCHAR2
       ,P_PLAN_START_YYYYMMDD   IN  VARCHAR2
       ,P_FROM_YYYYMMDD         IN  VARCHAR2
       ,P_TO_YYYYMMDD           IN  VARCHAR2
       ,P_MODEL_ID              IN  VARCHAR2
       ,P_ITEM_ID               IN  VARCHAR2
       ,P_NICK_NAME             IN  VARCHAR2
       ,P_USER_ID               IN  VARCHAR2
       ,P_PROGRAM_ID            IN  VARCHAR2
       ,P_SHEET_NAME            IN  VARCHAR2
       ,P_REAL_FLAG             IN  VARCHAR2
       ,P_NON_CHK               IN  VARCHAR2
       ,P_MY_MODEL_CHK          IN  VARCHAR2
       ,P_DELEGATEE_CHK         IN  VARCHAR2
       ,P_PART_LEADER_CHK       IN  VARCHAR2
       ,P_TEAM_LEADER_CHK       IN  VARCHAR2
       ,O_RC1                   OUT SYS_REFCURSOR
    );

    PROCEDURE P_SSP0023_GET_SHIPMENT_PLAN_DETAIL
    (
        P_DIVISION_ID           IN  VARCHAR2
       ,P_COMPANY_ID            IN  VARCHAR2
       ,P_FROM_SITE             IN  VARCHAR2
       ,P_ITEM_ID               IN  VARCHAR2
       ,P_MODEL_ID              IN  VARCHAR2
       ,P_NICK_NAME             IN  VARCHAR2
       ,P_REQUESTOR             IN  VARCHAR2
       ,P_PLAN_START_YYYYMMDD   IN  VARCHAR2
       ,P_FROM_YYYYMMDD         IN  VARCHAR2
       ,P_TO_YYYYMMDD           IN  VARCHAR2
       ,P_DBL_FLAG              IN  VARCHAR2
       ,P_REAL_FLAG             IN  VARCHAR2
       ,P_LANGUAGE              IN  VARCHAR2
       ,P_PROGRAM_ID            IN  VARCHAR2
       ,P_SHEET_NAME            IN  VARCHAR2
       ,P_NON_CHK               IN  VARCHAR2
       ,P_MY_MODEL_CHK          IN  VARCHAR2
       ,P_DELEGATEE_CHK         IN  VARCHAR2
       ,P_PART_LEADER_CHK       IN  VARCHAR2
       ,P_TEAM_LEADER_CHK       IN  VARCHAR2
       ,P_USER_ID               IN  VARCHAR2
       ,DEBUG_MODE              IN  VARCHAR2
       ,O_RC1                   OUT SYS_REFCURSOR
    );

    PROCEDURE P_SSP0023_GET_SHIPMENT_PLAN_DETAIL_EXCEL
    (
        P_DIVISION_ID           IN  VARCHAR2
       ,P_COMPANY_ID            IN  VARCHAR2
       ,P_FROM_SITE             IN  VARCHAR2
       ,P_ITEM_ID               IN  VARCHAR2
       ,P_MODEL_ID              IN  VARCHAR2
       ,P_NICK_NAME             IN  VARCHAR2
       ,P_REQUESTOR             IN  VARCHAR2
       ,P_PLAN_START_YYYYMMDD   IN  VARCHAR2
       ,P_FROM_YYYYMMDD         IN  VARCHAR2
       ,P_TO_YYYYMMDD           IN  VARCHAR2
       ,P_DBL_FLAG              IN  VARCHAR2
       ,P_REAL_FLAG             IN  VARCHAR2
       ,P_LANGUAGE              IN  VARCHAR2
       ,P_PROGRAM_ID            IN  VARCHAR2
       ,P_SHEET_NAME            IN  VARCHAR2
       ,P_NON_CHK               IN  VARCHAR2
       ,P_MY_MODEL_CHK          IN  VARCHAR2
       ,P_DELEGATEE_CHK         IN  VARCHAR2
       ,P_PART_LEADER_CHK       IN  VARCHAR2
       ,P_TEAM_LEADER_CHK       IN  VARCHAR2
       ,P_USER_ID               IN  VARCHAR2
       ,DEBUG_MODE              IN  VARCHAR2
       ,O_RC1                   OUT SYS_REFCURSOR
    );

    PROCEDURE P_SSP0023_GET_SHIPMENT_PLAN_RESULT
    (
        P_DIVISION_ID           IN  VARCHAR2
       ,P_FROM_SITE             IN  VARCHAR2
       ,P_ITEM_ID               IN  VARCHAR2
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

    PROCEDURE P_SSP0023_GET_SHIPMENT_PLAN_STOCK_DETAIL
    (
        P_DIVISION_ID           IN  VARCHAR2
       ,P_COMPANY_ID            IN  VARCHAR2
       ,P_FROM_SITE             IN  VARCHAR2
       ,P_PLAN_START_YYYYMMDD   IN  VARCHAR2
       ,P_ITEM_ID               IN  VARCHAR2
       ,P_NICK_NAME             IN  VARCHAR2
       ,P_LOT_ID                IN  VARCHAR2
       ,P_USER_ID               IN  VARCHAR2
       ,P_PROGRAM_ID            IN  VARCHAR2
       ,P_SHEET_NAME            IN  VARCHAR2
       ,P_MY_MODEL_CHK          IN  VARCHAR2
       ,P_DELEGATEE_CHK         IN  VARCHAR2
       ,P_PART_LEADER_CHK       IN  VARCHAR2
       ,P_TEAM_LEADER_CHK       IN  VARCHAR2
       ,P_NON_CHK               IN  VARCHAR2
       ,O_RC1                   OUT SYS_REFCURSOR
    );

    PROCEDURE P_SSP0023_GET_SHIPMENT_STATUS
    (
        P_DIVISION_ID           IN  VARCHAR2
       ,P_CONFIRM_ID            IN  VARCHAR2
       ,O_RC1                   OUT SYS_REFCURSOR
       ,O_RC2                   OUT SYS_REFCURSOR
       ,O_RC3                   OUT SYS_REFCURSOR
    );

    PROCEDURE P_SSP0023_GET_ERP_SO_NO_CNT
    (
        P_DIVISION_ID           IN  VARCHAR2
       ,P_ERP_SO_NO             IN  VARCHAR2
       ,O_RC1                   OUT SYS_REFCURSOR
    );

    PROCEDURE P_SSP0023_SAVE_SHIPMENT_PLAN_SIMU
    (
        P_ACTIVE_FLAG           IN  VARCHAR2
       ,P_DIVISION_ID           IN  VARCHAR2
       ,P_COMPANY_ID            IN  VARCHAR2
       ,P_PLANT_ID              IN  VARCHAR2
       ,P_SCM_SITE_ID           IN  VARCHAR2
       ,P_MODEL_ID              IN  VARCHAR2
       ,P_ITEM_ID               IN  VARCHAR2
       ,P_NPC_ITEM_ID           IN  VARCHAR2
       ,P_YYYYMMDD              IN  VARCHAR2
       ,P_QTY                   IN  VARCHAR2
       ,P_PLAN_START_YYYYMMDD   IN  VARCHAR2
       ,P_MEASURE               IN  VARCHAR2
       ,P_LAST_UPDATED_BY       IN  VARCHAR2
       ,P_ELECTRODE_TYPE        IN  VARCHAR2
       ,O_RC1                   OUT SYS_REFCURSOR
       ,O_RC2                   OUT SYS_REFCURSOR
    );

    PROCEDURE P_SSP0023_DELETE_SHIPMENT_REQUEST_DRAFTING
    (
        P_CHANGE_REQUEST_NO     IN  VARCHAR2
       ,P_USER_ID               IN  VARCHAR2
       ,O_RC1                   OUT SYS_REFCURSOR
       ,O_RC2                   OUT SYS_REFCURSOR
    );

    PROCEDURE P_SSP0023_SAVE_SHIPMENT_REQUEST_DRAFTING
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
       ,P_ELECTRODE_YN              IN  VARCHAR2 DEFAULT ''
       ,P_ELECTRODE_TYPE            IN  VARCHAR2 DEFAULT ''
       ,P_ORIGIN_FROM_DIVISION_ID   IN  VARCHAR2 DEFAULT ''
       ,P_ORIGION_TO_DIVISION_ID    IN  VARCHAR2 DEFAULT ''
       ,P_REMARKS                   IN  VARCHAR2
       ,P_REMARKS2                  IN  VARCHAR2
       ,P_REMARKS3                  IN  VARCHAR2
       ,P_CHANGE_REASON_CODE        IN  VARCHAR2
       ,P_CHANGE_REASON_DETAIL      IN  VARCHAR2
       ,P_TITLE                     IN  VARCHAR2
       ,P_PROGRAM_ID                IN  VARCHAR2
       ,P_FACTORY_ID                IN  VARCHAR2
       ,P_PACKAGE_TYPE              IN  VARCHAR2
       ,P_DOM_EXP                   IN  VARCHAR2
       ,O_RC1                       OUT SYS_REFCURSOR
       ,O_RC2                       OUT SYS_REFCURSOR
    );

    PROCEDURE P_SSP0023_SAVE_SHIPMENT_REQUEST_CONFIRM
    (
        P_ACTIVE_FLAG               IN  VARCHAR2
       ,P_DIVISION_ID               IN  VARCHAR2
       ,P_CONFIRM_ID                IN  VARCHAR2
       ,P_SHIPMENT_QTY              IN  VARCHAR2
       ,P_SHIPMENT_DATE             IN  VARCHAR2
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
       ,P_REMARKS                   IN  VARCHAR2
       ,P_REMARKS2                  IN  VARCHAR2
       ,P_REMARKS3                  IN  VARCHAR2
       ,P_USER_ID                   IN  VARCHAR2
       ,P_CHECK_NEED_YN             IN  VARCHAR2
       ,P_EDIT_MAIN                 IN  VARCHAR2
       ,P_FACTORY_ID                IN  VARCHAR2
       ,P_PACKAGE_TYPE              IN  VARCHAR2
       ,P_DOM_EXP                   IN  VARCHAR2
       ,O_RC1                       OUT SYS_REFCURSOR
       ,O_RC2                       OUT SYS_REFCURSOR
    );

    PROCEDURE P_SSP0023_SHIPMENT_PLAN_EXCEL_UPLOAD
    (
        P_MODE                  IN  NUMBER
      , P_CREATED_BY            IN  VARCHAR2
      , P_PROGRAM_ID            IN  VARCHAR2 DEFAULT 'SSP0023'
      , P_SHEET_NAME            IN  VARCHAR2 DEFAULT 'Shipment Plan(Electrode)'
      , O_RESULT_CURSOR         OUT SYS_REFCURSOR
    );

    --  2026.10.21 AJS 공용 ERP 오류 처리 프로시저 래퍼 (START)
    PROCEDURE P_SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM
    (
        P_CHANGE_REQUEST_NO     IN  VARCHAR2,
        P_CONFIRM_ID            IN  VARCHAR2,
        P_E_TYPE                IN  VARCHAR2,
        P_E_MESSAGE             IN  VARCHAR2,
        P_LAST_UPDATED_BY       IN  VARCHAR2,
        O_RC1                   OUT SYS_REFCURSOR,
        O_RC2                   OUT SYS_REFCURSOR
    );

    PROCEDURE P_SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM
    (
        P_CONFIRM_ID            IN  VARCHAR2,
        P_CHANGE_REQUEST_NO     IN  VARCHAR2,
        P_DEL_FLAG              IN  VARCHAR2 DEFAULT 'D',
        P_LAST_UPDATED_BY       IN  VARCHAR2,
        P_TIME_ZONE             IN  VARCHAR2,
        P_IF_SEND_FLAG          IN  VARCHAR2 DEFAULT 'Y',
        P_CHANGE_TYPE           IN  VARCHAR2 DEFAULT 'C',
        O_RC1                   OUT SYS_REFCURSOR,
        O_RC2                   OUT SYS_REFCURSOR
    );
    --  2026.10.21 AJS 공용 ERP 오류 처리 프로시저 래퍼 (END)

END PKG_SSP0023;