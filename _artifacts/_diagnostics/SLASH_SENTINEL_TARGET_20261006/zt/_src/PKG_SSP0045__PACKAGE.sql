PACKAGE PKG_SSP0045
IS
/*
 * Program ID   : PKG_SSP0045
 * Description  : SSP0045 Shipment Request SEMI
 * Program History
 *===================================================================================================
 * Date         In Charge       Description
 *===================================================================================================
 * 2026.09.29   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
 */

    /* AS-IS SCP0009_GET_SHEET_CALENDAR_3SPAN (화면이 SCP 공용 판을 부르나 기능 등록이 이 화면 이름이라 이 패키지에 둔다) */
    PROCEDURE P_SSP0045_GET_SHEET_CALENDAR_3SPAN
    (
        P_START_YYYYMMDD        IN  VARCHAR2
      , P_END_YYYYMMDD          IN  VARCHAR2
      , O_RC1                   OUT SYS_REFCURSOR
      , O_RESULT_CURSOR         OUT SYS_REFCURSOR
    );

    /* AS-IS SCM0002_GET_BODITEM_FOR_PRJROUTE_POPUP (BOD 선택 팝업) */
    PROCEDURE P_SSP0045_GET_BOD_ITEM_PRJ_ROUTE
    (
        P_DIVISION_ID           IN  VARCHAR2
      , P_OPERATION_GROUP       IN  VARCHAR2
      , P_ITEM_ID               IN  VARCHAR2
      , P_FROM_YYYYMMDD         IN  VARCHAR2
      , P_PROGRAM_ID            IN  VARCHAR2
      , O_RC1                   OUT SYS_REFCURSOR
      , O_RESULT_CURSOR         OUT SYS_REFCURSOR
    );

    /* AS-IS SSP0045_GET_SHIPMENT_REQUEST */
    PROCEDURE P_SSP0045_GET_SHIPMENT_REQUEST
    (
        P_DIVISION_ID           IN  VARCHAR2
      , P_OPERATION_GROUP       IN  VARCHAR2
      , P_SCM_SITE_ID           IN  VARCHAR2
      , P_ITEM_ID               IN  VARCHAR2
      , P_FROM_YYYYMMDD         IN  VARCHAR2
      , P_TO_YYYYMMDD           IN  VARCHAR2
      , P_PROGRAM_ID            IN  VARCHAR2
      , P_SHEET_NAME            IN  VARCHAR2
      , P_USER_ID               IN  VARCHAR2
      , DEBUG_MODE              IN  VARCHAR2
      , O_RC1                   OUT SYS_REFCURSOR
      , O_RESULT_CURSOR         OUT SYS_REFCURSOR
    );

    /* AS-IS SSP0045_SAVE_SHIPMENT_REQUEST */
    PROCEDURE P_SSP0045_SAVE_SHIPMENT_REQUEST
    (
        P_ACTIVE_FLAG           IN  CLOB
      , P_DIVISION_ID           IN  CLOB
      , P_FROM_SITE             IN  CLOB
      , P_ITEM_ID               IN  CLOB
      , P_INCOTERMS             IN  CLOB
      , P_TRANSPORT_MODE        IN  CLOB
      , P_TO_SITE               IN  CLOB
      , P_BOD_ID                IN  CLOB
      , P_MEASURE               IN  CLOB
      , P_YYYYMMDD              IN  CLOB
      , P_QTY                   IN  CLOB
      , P_PROJECT_CODE          IN  CLOB
      , P_FCST_TYPE             IN  CLOB
      , P_CREATED_BY            IN  VARCHAR2
      , DEBUG_MODE              IN  VARCHAR2
      , O_RC1                   OUT SYS_REFCURSOR
      , O_RESULT_CURSOR         OUT SYS_REFCURSOR
    );

END PKG_SSP0045;