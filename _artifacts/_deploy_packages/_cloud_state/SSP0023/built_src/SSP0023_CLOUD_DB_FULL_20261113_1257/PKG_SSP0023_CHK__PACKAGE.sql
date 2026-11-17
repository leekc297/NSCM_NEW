PACKAGE PKG_SSP0023_CHK
IS
/*
 * Program ID   : PKG_SSP0023_CHK
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




END PKG_SSP0023_CHK;