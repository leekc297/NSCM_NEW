PACKAGE PKG_DMF0045
AS
/****************************************************************************************************/
/* Program ID  : PKG_DMF0045                                                                        */
/* Description : Shipment Request                                                                   */
/* Program History                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2026.09.24  ZIONEX       [PJ202650304] MSSQL -> Oracle 전환                                      */
/****************************************************************************************************/

    /* 출하요청 조회 */
    PROCEDURE P_DMF0045_GET_SHIPMENT_REQUEST
    (
        P_SHEET_NAME        IN  VARCHAR2
      , P_DIVISION_ID       IN  VARCHAR2
      , P_TEAM_ID           IN  VARCHAR2
      , P_CUSTOMER          IN  VARCHAR2
      , P_SCM_SITE_ID       IN  VARCHAR2
      , P_PLANT_SITE_ID     IN  VARCHAR2
      , P_PROJECT_CODE      IN  VARCHAR2
      , P_ITEM_ID           IN  VARCHAR2
      , P_FROM_YYYYMMDD     IN  VARCHAR2
      , P_TO_YYYYMMDD       IN  VARCHAR2
      , P_CREATED_BY        IN  VARCHAR2
      , O_RC1               OUT SYS_REFCURSOR
      , O_RESULT_CURSOR     OUT SYS_REFCURSOR
    );

    /* 화면 칸 머리글 조회 */
    PROCEDURE P_DMF0045_GET_SPREAD_TITLE
    (
        P_START_DT          IN  VARCHAR2
      , P_END_DT            IN  VARCHAR2
      , P_CREATED_BY        IN  VARCHAR2
      , P_SHEET_NAME        IN  VARCHAR2
      , P_DIVISION_ID       IN  VARCHAR2
      , O_RC1               OUT SYS_REFCURSOR
      , O_RESULT_CURSOR     OUT SYS_REFCURSOR
    );

    /* 출하요청 저장 */
    PROCEDURE P_DMF0045_SAVE_SHIPMENT_REQUEST
    (
        P_ACTIVE_FLAG       IN  CLOB
      , P_DIVISION_ID       IN  CLOB
      , P_ITEM_ID           IN  CLOB
      , P_FROM_SITE         IN  CLOB
      , P_TO_SITE           IN  CLOB
      , P_PROJECT_CODE      IN  CLOB
      , P_INCOTERMS         IN  CLOB
      , P_FCST_TYPE         IN  CLOB
      , P_TRANSPORT_MODE    IN  CLOB
      , P_BOD_ID            IN  CLOB
      , P_MEASURE           IN  CLOB
      , P_YYYYMMDD          IN  CLOB
      , P_QTY               IN  CLOB
      , P_CREATED_BY        IN  VARCHAR2
      , O_RESULT_CURSOR     OUT SYS_REFCURSOR
    );

END PKG_DMF0045;