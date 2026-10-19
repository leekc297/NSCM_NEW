PACKAGE PKG_SCP0016
IS
    /*
     * Program ID   : PKG_SCP0016
     * Description  : SCP0016 Waterfall Shipment Plan FG 화면
     * Program History
     *===================================================================================================
     *   Date       In Charge      Description
     *===================================================================================================
     * 2026.09.26   ZIONEX         [PJ202650304] MSSQL -> Oracle 전환
     */

    /* 출하계획 워터폴 조회 (값) */
    PROCEDURE P_SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL
    (
        P_FROM_YYYYMMDD     IN  VARCHAR2
      , P_TO_YYYYMMDD       IN  VARCHAR2
      , P_DIVISION_ID       IN  VARCHAR2
      , P_BIZ_TYPE          IN  VARCHAR2
      , P_PROJECT_CODE      IN  CLOB
      , P_ITEM_ID           IN  CLOB
      , P_VERSION_NO        IN  CLOB
      , P_ELECTYPE          IN  CLOB
      , P_PROGRAM_ID        IN  VARCHAR2
      , P_SHEET_NAME        IN  VARCHAR2
      , P_USER_ID           IN  VARCHAR2
      , P_DEBUG_MODE        IN  VARCHAR2
      , O_RC1               OUT SYS_REFCURSOR
      , O_RESULT_CURSOR     OUT SYS_REFCURSOR
    );

    /* 출하계획 워터폴 조회 (머리) */
    PROCEDURE P_SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL_TITLE_PARAL
    (
        P_FROM_YYYYMMDD     IN  VARCHAR2
      , P_TO_YYYYMMDD       IN  VARCHAR2
      , P_DIVISION_ID       IN  VARCHAR2
      , P_BIZ_TYPE          IN  VARCHAR2
      , P_PROJECT_CODE      IN  CLOB
      , P_ITEM_ID           IN  CLOB
      , P_VERSION_NO        IN  CLOB
      , P_ELECTYPE          IN  CLOB
      , P_ISO               IN  VARCHAR2
      , P_PROGRAM_ID        IN  VARCHAR2
      , P_SHEET_NAME        IN  VARCHAR2
      , P_USER_ID           IN  VARCHAR2
      , P_DEBUG_MODE        IN  VARCHAR2
      , O_RC1               OUT SYS_REFCURSOR
      , O_RESULT_CURSOR     OUT SYS_REFCURSOR
    );

END PKG_SCP0016;