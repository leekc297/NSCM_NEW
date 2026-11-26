PACKAGE PKG_SSP0046
AS
/****************************************************************************************************/
/* Program ID  : PKG_SSP0046                                                                        */
/* Description : Shipment Request                                                                   */
/* Program History                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2026.09.24  ZIONEX       [PJ202650304] MSSQL -> Oracle 전환                                      */
/* 2026.11.26  ZIONEX       [SSP0046] PKG_DMF0045 기준 신규 + AS-IS SSP0046 차이 반영               */
/* 2026.11.26  ZIONEX       [SSP0046] AS-IS 팝업·콤보 SP 9종 추가 (BOD·품목·프로젝트·머리글 등)     */
/****************************************************************************************************/

    /* 출하요청 조회 */
    PROCEDURE P_SSP0046_GET_SHIPMENT_REQUEST
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
    PROCEDURE P_SSP0046_GET_SPREAD_TITLE
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
    PROCEDURE P_SSP0046_SAVE_SHIPMENT_REQUEST
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


    /* Bucket Type 코드 (AS-IS SSP0046_GET_BUCKET_TYPE_CODE) */
    PROCEDURE P_SSP0046_GET_BUCKET_TYPE_CODE
    (
        O_RC1               OUT SYS_REFCURSOR
      , O_RESULT_CURSOR     OUT SYS_REFCURSOR
    );

    /* BOD 팝업 : 품목별 BOD, 경로 (AS-IS SSP0046_GET_BODITEM_FOR_PRJROUTE_POPUP) */
    PROCEDURE P_SSP0046_GET_BODITEM_FOR_PRJROUTE_POPUP
    (
        P_DIVISION_ID       IN  VARCHAR2
      , P_ITEM_ID           IN  VARCHAR2
      , P_FROM_SITE         IN  VARCHAR2
      , O_RC1               OUT SYS_REFCURSOR
      , O_RESULT_CURSOR     OUT SYS_REFCURSOR
    );

    /* 품목 팝업 (AS-IS SSP0046_GET_ITEM_BY_DIVISION_POPUPEx) */
    PROCEDURE P_SSP0046_GET_ITEM_BY_DIVISION_POPUPEX
    (
        P_DIVISION_ID       IN  VARCHAR2
      , P_DEPT_ID           IN  VARCHAR2
      , P_END_CUSTOMER      IN  VARCHAR2
      , P_PROJECT_CODE      IN  VARCHAR2
      , P_SCM_SITE_ID       IN  VARCHAR2
      , P_ITEM_ID           IN  VARCHAR2
      , P_BIZ_TYPE          IN  VARCHAR2
      , O_RC1               OUT SYS_REFCURSOR
      , O_RESULT_CURSOR     OUT SYS_REFCURSOR
    );

    /* 프로젝트 팝업 (AS-IS SSP0046_GET_PROJECT_BY_DIVISION_POPUPEX) */
    PROCEDURE P_SSP0046_GET_PROJECT_BY_DIVISION_POPUPEX
    (
        P_DIVISION_ID       IN  VARCHAR2
      , P_DEPT_ID           IN  VARCHAR2
      , P_END_CUSTOMER      IN  VARCHAR2
      , P_SCM_SITE_ID       IN  VARCHAR2
      , P_PROJECT_CODE      IN  VARCHAR2
      , P_ETC               IN  VARCHAR2
      , O_RC1               OUT SYS_REFCURSOR
      , O_RESULT_CURSOR     OUT SYS_REFCURSOR
    );

    /* 팝업 조회조건 End Customer (AS-IS SSP0046_GET_CUSTOMER_BY_DIVISION) */
    PROCEDURE P_SSP0046_GET_CUSTOMER_BY_DIVISION
    (
        P_DIVISION_ID       IN  VARCHAR2
      , P_DEPT_ID           IN  VARCHAR2
      , O_RC1               OUT SYS_REFCURSOR
      , O_RESULT_CURSOR     OUT SYS_REFCURSOR
    );

    /* 팝업 조회조건 Sales Site (AS-IS SSP0046_GET_SITE_BY_DIVISION) */
    PROCEDURE P_SSP0046_GET_SITE_BY_DIVISION
    (
        P_DIVISION_ID       IN  VARCHAR2
      , P_DEPT_ID           IN  VARCHAR2
      , P_END_CUSTOMER      IN  VARCHAR2
      , O_RC1               OUT SYS_REFCURSOR
      , O_RESULT_CURSOR     OUT SYS_REFCURSOR
    );

    /* 팝업 조회조건 Team (AS-IS SSP0046_GET_TEAM_BY_DIVISION) */
    PROCEDURE P_SSP0046_GET_TEAM_BY_DIVISION
    (
        P_DIVISION_ID       IN  VARCHAR2
      , O_RC1               OUT SYS_REFCURSOR
      , O_RESULT_CURSOR     OUT SYS_REFCURSOR
    );

    /* 품목 팝업 칸 머리글 (AS-IS SSP0046_GET_COMMON_SPREAD_TITLE) */
    PROCEDURE P_SSP0046_GET_COMMON_SPREAD_TITLE
    (
        P_START_YYYYMMDD    IN  VARCHAR2
      , P_END_YYYYMMDD      IN  VARCHAR2
      , P_CREATED_BY        IN  VARCHAR2
      , P_PROGRAM_ID        IN  VARCHAR2
      , P_SHEET_NAME        IN  VARCHAR2
      , P_DIVISION_ID       IN  VARCHAR2
      , O_RC1               OUT SYS_REFCURSOR
      , O_RESULT_CURSOR     OUT SYS_REFCURSOR
    );

    /* 프로젝트 팝업 칸 머리글 (AS-IS SSP0046_GET_COMMON_SPREAD_TITLE_EX) */
    PROCEDURE P_SSP0046_GET_COMMON_SPREAD_TITLE_EX
    (
        P_START_YYYYMMDD    IN  VARCHAR2
      , P_END_YYYYMMDD      IN  VARCHAR2
      , P_CREATED_BY        IN  VARCHAR2
      , P_PROGRAM_ID        IN  VARCHAR2
      , P_SHEET_NAME        IN  VARCHAR2
      , O_RC1               OUT SYS_REFCURSOR
      , O_RESULT_CURSOR     OUT SYS_REFCURSOR
    );

END PKG_SSP0046;