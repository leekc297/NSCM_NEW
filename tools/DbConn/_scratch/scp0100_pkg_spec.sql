PACKAGE PKG_SCP0100
IS
/*
 * Program ID   : PKG_SCP0100
 * Description  : SCP0100 Global PSI Report
 * Program History
 *===================================================================================================
 * Date         In Charge       Description
 *===================================================================================================
 * 2026.09.23   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
 */

    PROCEDURE P_SCP0100_GET_GLOBAL_PSI_REPORT
    (
        P_FROM_YYYYMMDD         IN  VARCHAR2
      , P_TO_YYYYMMDD           IN  VARCHAR2
      , P_DIVISION_ID           IN  VARCHAR2
      , P_ITEM_ID               IN  VARCHAR2
      , P_NICK_NAME             IN  VARCHAR2
      , P_FROM_SITE             IN  VARCHAR2
      , P_TO_SITE               IN  VARCHAR2
      , P_PLAN_START_YYYYMMDD   IN  VARCHAR2
      , P_PLAN_TYPE             IN  VARCHAR2
      , P_USER_ID               IN  VARCHAR2
      , P_BUCKET                IN  VARCHAR2
      , P_CELL_GROUP            IN  VARCHAR2
      , P_PROJECT               IN  VARCHAR2
      , P_SEARCH_LEVEL          IN  VARCHAR2
      , P_CHK_CELL_QTY          IN  VARCHAR2
      , P_CHK_AS                IN  VARCHAR2
      , DEBUG_MODE              IN  VARCHAR2
      , O_RC1                   OUT SYS_REFCURSOR
      , O_RESULT_CURSOR         OUT SYS_REFCURSOR
    );

    PROCEDURE P_SCP0100_GET_GLOBAL_PSI_REPORT_WW_DATAONLY
    (
        P_FROM_YYYYMMDD         IN  VARCHAR2
      , P_TO_YYYYMMDD           IN  VARCHAR2
      , P_DIVISION_ID           IN  VARCHAR2
      , P_ITEM_ID               IN  VARCHAR2
      , P_NICK_NAME             IN  VARCHAR2
      , P_FROM_SITE             IN  VARCHAR2
      , P_TO_SITE               IN  VARCHAR2
      , P_PLAN_START_YYYYMMDD   IN  VARCHAR2
      , P_PLAN_TYPE             IN  VARCHAR2
      , P_USER_ID               IN  VARCHAR2
      , P_BUCKET                IN  VARCHAR2
      , P_CELL_GROUP            IN  VARCHAR2
      , P_PROJECT               IN  VARCHAR2
      , P_SEARCH_LEVEL          IN  VARCHAR2
      , P_CHK_CELL_QTY          IN  VARCHAR2
      , P_CHK_AS                IN  VARCHAR2
      , DEBUG_MODE              IN  VARCHAR2
      , O_RC1                   OUT SYS_REFCURSOR
      , O_RESULT_CURSOR         OUT SYS_REFCURSOR
    );

    PROCEDURE P_SCP0100_GET_GLOBAL_PSI_REPORT_MM_DATAONLY
    (
        P_FROM_YYYYMMDD         IN  VARCHAR2
      , P_TO_YYYYMMDD           IN  VARCHAR2
      , P_DIVISION_ID           IN  VARCHAR2
      , P_ITEM_ID               IN  VARCHAR2
      , P_NICK_NAME             IN  VARCHAR2
      , P_FROM_SITE             IN  VARCHAR2
      , P_TO_SITE               IN  VARCHAR2
      , P_PLAN_START_YYYYMMDD   IN  VARCHAR2
      , P_PLAN_TYPE             IN  VARCHAR2
      , P_USER_ID               IN  VARCHAR2
      , P_BUCKET                IN  VARCHAR2
      , P_CELL_GROUP            IN  VARCHAR2
      , P_PROJECT               IN  VARCHAR2
      , P_SEARCH_LEVEL          IN  VARCHAR2
      , P_CHK_CELL_QTY          IN  VARCHAR2
      , P_CHK_AS                IN  VARCHAR2
      , DEBUG_MODE              IN  VARCHAR2
      , O_RC1                   OUT SYS_REFCURSOR
      , O_RESULT_CURSOR         OUT SYS_REFCURSOR
    );

    PROCEDURE P_SCP0100_GET_PLAN_DATE
    (
        P_DIVISION_ID           IN  VARCHAR2
      , P_BUCKET                IN  VARCHAR2
      , P_PROGRAM_ID            IN  VARCHAR2
      , O_RC1                   OUT SYS_REFCURSOR
      , O_RESULT_CURSOR         OUT SYS_REFCURSOR
    );

    PROCEDURE P_SCP0100_GET_SHEET_CALENDAR_3SPAN
    (
        P_START_YYYYMMDD        IN  VARCHAR2
      , P_END_YYYYMMDD          IN  VARCHAR2
      , O_RC1                   OUT SYS_REFCURSOR
      , O_RESULT_CURSOR         OUT SYS_REFCURSOR
    );

    PROCEDURE P_SCP0100_GET_SITE
    (
        P_SITE_TPYE             IN  VARCHAR2
      , P_DIVISION_ID           IN  VARCHAR2
      , P_BUCKET                IN  VARCHAR2
      , O_RC1                   OUT SYS_REFCURSOR
      , O_RESULT_CURSOR         OUT SYS_REFCURSOR
    );

END PKG_SCP0100;