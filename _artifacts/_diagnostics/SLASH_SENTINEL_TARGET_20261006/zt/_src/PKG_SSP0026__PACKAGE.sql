PACKAGE PKG_SSP0026
IS
/*
 * Program ID   : PKG_SSP0026
 * Description  : SSP0026 Shipment Request Pack (외주 Packer 출하 지시)
 * Program History
 *===================================================================================================
 * Date         In Charge       Description
 *===================================================================================================
 * 2026.09.26   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
 *
 * 1 단계 : 작은 조회 6 건
 *   P_SSP0026_GET_BOD_ITEM                        AS-IS SSP0026_GET_BOD_ITEM
 *   P_SSP0026_GET_ITEM_BY_DIVISION_POPUP          AS-IS SSP0026_GET_ITEM_BY_DIVISION_POPUP
 *   P_SSP0026_GET_SPREAD_TITLE                    AS-IS SSP0026_GET_SPREAD_TITLE
 *   P_SSP0026_GET_RESULT_DETAIL                   AS-IS SSP0026_GET_RESULT_DETAIL
 *   P_SSP0026_GET_REQUEST_DETAIL_PACK             AS-IS SSP0026_GET_REQUEST_DETAIL_PACK
 *   P_SSP0026_GET_REQUEST_DETAIL_PACK_EXCEL_DOWN  AS-IS SSP0026_GET_REQUEST_DETAIL_PACK_EXCEL_DOWN
 *
 * 2 단계 : 큰 조회 2 건
 *   P_SSP0026_GET_SHIPMENT_REQUEST_PACK           AS-IS SSP0026_GET_SHIPMENT_REQUEST_PACK
 *   P_SSP0026_GET_SHIPMENT_REQUEST_CELL           AS-IS SSP0026_GET_SHIPMENT_REQUEST_CELL
 *
 * 3 단계 : 저장 4 건
 *   P_SSP0026_SAVE_SHIP_REQ_CELL                  AS-IS SSP0026_SAVE_SHIP_REQ_CELL
 *   P_SSP0026_SAVE_SHIP_REQ_DETAIL_PACK           AS-IS SSP0026_SAVE_SHIP_REQ_DETAIL_PACK
 *   P_SSP0026_SAVE_SHIP_REQ_PACK                  AS-IS SSP0026_SAVE_SHIP_REQ_PACK
 *   P_SSP0026_SAVE_REQ_PACK_EXCEL_UPLOAD          AS-IS SSP0026_SAVE_REQ_PACK_EXCEL_UPLOAD
 */

    PROCEDURE P_SSP0026_GET_BOD_ITEM
    (
        P_DIVISION_ID           IN  VARCHAR2
      , P_FROM_SITE_ID          IN  VARCHAR2
      , P_TO_SITE_ID            IN  VARCHAR2
      , P_ITEM_ID               IN  VARCHAR2
      , P_BOD_ID                IN  VARCHAR2
      , O_RC1                   OUT SYS_REFCURSOR
      , O_RESULT_CURSOR         OUT SYS_REFCURSOR
    );

    PROCEDURE P_SSP0026_GET_ITEM_BY_DIVISION_POPUP
    (
        P_DIVISION_ID           IN  VARCHAR2
      , P_PROJECT_CODE          IN  VARCHAR2
      , P_SCM_SITE_ID           IN  VARCHAR2
      , P_ITEM_ID               IN  VARCHAR2
      , O_RC1                   OUT SYS_REFCURSOR
      , O_RESULT_CURSOR         OUT SYS_REFCURSOR
    );

    PROCEDURE P_SSP0026_GET_SPREAD_TITLE
    (
        P_START_DT              IN  VARCHAR2
      , P_END_DT                IN  VARCHAR2
      , P_CREATED_BY            IN  VARCHAR2
      , P_SHEET_NAME            IN  VARCHAR2
      , P_DIVISION_ID           IN  VARCHAR2
      , O_RC1                   OUT SYS_REFCURSOR
      , O_RESULT_CURSOR         OUT SYS_REFCURSOR
    );

    PROCEDURE P_SSP0026_GET_RESULT_DETAIL
    (
        P_SHEET_NAME            IN  VARCHAR2
      , P_DIVISION_ID           IN  VARCHAR2
      , P_TEAM_ID               IN  VARCHAR2
      , P_CUSTOMER              IN  VARCHAR2
      , P_SCM_SITE_ID           IN  VARCHAR2
      , P_PLANT_SITE_ID         IN  VARCHAR2
      , P_PROJECT_CODE          IN  VARCHAR2
      , P_ITEM_ID               IN  VARCHAR2
      , P_FROM_YYYYMMDD         IN  VARCHAR2
      , P_TO_YYYYMMDD           IN  VARCHAR2
      , P_NICK_NAME             IN  VARCHAR2
      , P_REQUESTOR_ID          IN  VARCHAR2
      , P_CREATED_BY            IN  VARCHAR2
      , DEBUG_MODE              IN  VARCHAR2
      , O_RC1                   OUT SYS_REFCURSOR
      , O_RESULT_CURSOR         OUT SYS_REFCURSOR
    );

    PROCEDURE P_SSP0026_GET_REQUEST_DETAIL_PACK
    (
        P_SHEET_NAME            IN  VARCHAR2
      , P_DIVISION_ID           IN  VARCHAR2
      , P_TEAM_ID               IN  VARCHAR2
      , P_CUSTOMER              IN  VARCHAR2
      , P_SCM_SITE_ID           IN  VARCHAR2
      , P_PLANT_SITE_ID         IN  VARCHAR2
      , P_PROJECT_CODE          IN  VARCHAR2
      , P_ITEM_ID               IN  VARCHAR2
      , P_FROM_YYYYMMDD         IN  VARCHAR2
      , P_TO_YYYYMMDD           IN  VARCHAR2
      , P_NICK_NAME             IN  VARCHAR2
      , P_REQUESTOR_ID          IN  VARCHAR2
      , P_CREATED_BY            IN  VARCHAR2
      , DEBUG_MODE              IN  VARCHAR2
      , O_RC1                   OUT SYS_REFCURSOR
      , O_RESULT_CURSOR         OUT SYS_REFCURSOR
    );

    PROCEDURE P_SSP0026_GET_REQUEST_DETAIL_PACK_EXCEL_DOWN
    (
        P_DIVISION_ID           IN  VARCHAR2
      , P_FROM_YYYYMMDD         IN  VARCHAR2
      , P_TO_YYYYMMDD           IN  VARCHAR2
      , P_PLANT_SITE_ID         IN  VARCHAR2
      , P_SCM_SITE_ID           IN  VARCHAR2
      , P_LOT_ID                IN  VARCHAR2
      , P_ITEM_ID               IN  VARCHAR2
      , P_NICK_NAME             IN  VARCHAR2
      , P_USER_ID               IN  VARCHAR2
      , P_REQUESTOR_ID          IN  VARCHAR2
      , P_PROGRAM_ID            IN  VARCHAR2
      , P_SHEET_NAME            IN  VARCHAR2
      , O_RC1                   OUT SYS_REFCURSOR
      , O_RESULT_CURSOR         OUT SYS_REFCURSOR
    );

    PROCEDURE P_SSP0026_GET_SHIPMENT_REQUEST_PACK
    (
        P_SHEET_NAME            IN  VARCHAR2
      , P_DIVISION_ID           IN  VARCHAR2
      , P_TEAM_ID               IN  VARCHAR2
      , P_CUSTOMER              IN  VARCHAR2
      , P_SCM_SITE_ID           IN  VARCHAR2
      , P_PLANT_SITE_ID         IN  VARCHAR2
      , P_PROJECT_CODE          IN  VARCHAR2
      , P_ITEM_ID               IN  VARCHAR2
      , P_FROM_YYYYMMDD         IN  VARCHAR2
      , P_TO_YYYYMMDD           IN  VARCHAR2
      , P_CREATED_BY            IN  VARCHAR2
      , DEBUG_MODE              IN  VARCHAR2
      , O_RC1                   OUT SYS_REFCURSOR
      , O_RESULT_CURSOR         OUT SYS_REFCURSOR
    );

    PROCEDURE P_SSP0026_GET_SHIPMENT_REQUEST_CELL
    (
        P_SHEET_NAME            IN  VARCHAR2
      , P_DIVISION_ID           IN  VARCHAR2
      , P_TEAM_ID               IN  VARCHAR2
      , P_CUSTOMER              IN  VARCHAR2
      , P_SCM_SITE_ID           IN  VARCHAR2
      , P_PLANT_SITE_ID         IN  VARCHAR2
      , P_PROJECT_CODE          IN  VARCHAR2
      , P_ITEM_ID               IN  VARCHAR2
      , P_FROM_YYYYMMDD         IN  VARCHAR2
      , P_TO_YYYYMMDD           IN  VARCHAR2
      , P_CREATED_BY            IN  VARCHAR2
      , DEBUG_MODE              IN  VARCHAR2
      , O_RC1                   OUT SYS_REFCURSOR
      , O_RESULT_CURSOR         OUT SYS_REFCURSOR
    );

    PROCEDURE P_SSP0026_SAVE_SHIP_REQ_CELL
    (
        P_ACTIVE_FLAG           IN  VARCHAR2
      , P_DIVISION_ID           IN  VARCHAR2
      , P_ITEM_ID               IN  VARCHAR2
      , P_FROM_SITE             IN  VARCHAR2
      , P_TO_SITE               IN  VARCHAR2
      , P_PROJECT_CODE          IN  VARCHAR2
      , P_INCOTERMS             IN  VARCHAR2
      , P_FCST_TYPE             IN  VARCHAR2
      , P_TRANSPORT_MODE        IN  VARCHAR2
      , P_BOD_ID                IN  VARCHAR2
      , P_MEASURE               IN  VARCHAR2
      , P_YYYYMMDD              IN  VARCHAR2
      , P_QTY                   IN  VARCHAR2
      , P_REMARK                IN  VARCHAR2
      , P_CREATED_BY            IN  VARCHAR2
      , DEBUG_MODE              IN  VARCHAR2
      , O_RC1                   OUT SYS_REFCURSOR
      , O_RC2                   OUT SYS_REFCURSOR
    );

    PROCEDURE P_SSP0026_SAVE_SHIP_REQ_DETAIL_PACK
    (
        P_ACTIVE_FLAG           IN  VARCHAR2
      , P_DIVISION_ID           IN  VARCHAR2
      , P_ITEM_ID               IN  VARCHAR2
      , P_FROM_SITE             IN  VARCHAR2
      , P_TO_SITE               IN  VARCHAR2
      , P_SHIPTO_CODE           IN  VARCHAR2
      , P_INCOTERMS             IN  VARCHAR2
      , P_TRANSPORT_MODE        IN  VARCHAR2
      , P_FCST_TYPE             IN  VARCHAR2
      , P_BOD_ID                IN  VARCHAR2
      , P_YYYYMMDD              IN  VARCHAR2
      , P_QTY                   IN  VARCHAR2
      , P_REMARK                IN  VARCHAR2
      , P_ORDER_TYPE_DETAIL     IN  VARCHAR2
      , P_CREATED_BY            IN  VARCHAR2
      , DEBUG_MODE              IN  VARCHAR2
      , O_RC1                   OUT SYS_REFCURSOR
      , O_RC2                   OUT SYS_REFCURSOR
    );

    PROCEDURE P_SSP0026_SAVE_SHIP_REQ_PACK
    (
        P_ACTIVE_FLAG           IN  VARCHAR2
      , P_DIVISION_ID           IN  VARCHAR2
      , P_ITEM_ID               IN  VARCHAR2
      , P_FROM_SITE             IN  VARCHAR2
      , P_TO_SITE               IN  VARCHAR2
      , P_PROJECT_CODE          IN  VARCHAR2
      , P_INCOTERMS             IN  VARCHAR2
      , P_FCST_TYPE             IN  VARCHAR2
      , P_TRANSPORT_MODE        IN  VARCHAR2
      , P_BOD_ID                IN  VARCHAR2
      , P_MEASURE               IN  VARCHAR2
      , P_YYYYMMDD              IN  VARCHAR2
      , P_QTY                   IN  VARCHAR2
      , P_CREATED_BY            IN  VARCHAR2
      , DEBUG_MODE              IN  VARCHAR2
      , O_RC1                   OUT SYS_REFCURSOR
      , O_RC2                   OUT SYS_REFCURSOR
    );

    PROCEDURE P_SSP0026_SAVE_REQ_PACK_EXCEL_UPLOAD
    (
        P_MODE                  IN  NUMBER
      , P_CREATED_BY            IN  VARCHAR2
      , O_RC1                   OUT SYS_REFCURSOR
      , O_RC2                   OUT SYS_REFCURSOR
    );

END PKG_SSP0026;