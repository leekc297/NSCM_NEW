-- SOURCE-FRESH: SCM_MGR.PKG_DMF0000 PACKAGE LAST_DDL=2026-09-02 11:47:09 FETCHED=2026-09-15 18:50 DB=ZIOUI1
-- STEP 1 BACKUP (원복용 원문 · STATUS=VALID)
SET DEFINE OFF
CREATE OR REPLACE PACKAGE SCM_MGR."PKG_DMF0000" 
/*
 * Program ID   : PKG_DMF0000
 * Description  : PKG_DMF0000
 * Program History
 *===========================================================================================================
 *   Date       In Charge      Description
 *===========================================================================================================
 * 2026.03.17   jcnam       [PJ20264226] NextSCM Pilot 설계 및 개발
 *                          UI 항목으로 Package로 전환
 */
AS
    -- 프로시저 선언
    PROCEDURE P_DMF0000_GET_COMMON_SPREAD_TITLE
    (
    P_START_YYYYMMDD  IN VARCHAR2,
    P_END_YYYYMMDD    IN VARCHAR2,
    P_CREATED_BY      IN VARCHAR2,
    P_PROGRAM_ID      IN VARCHAR2,
    P_SHEET_NAME      IN VARCHAR2,
    P_DIVISION_ID     IN VARCHAR2,
    O_RC1             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0000_GET_EXCHANGE_POPUP_DATA
    (
    P_DIVISION_ID     IN VARCHAR2,
    P_FROM_YYYYMMDD   IN VARCHAR2,
    P_TO_YYYYMMDD     IN VARCHAR2,
    P_USER_ID         IN VARCHAR2, -- For EditYn
    P_MNU_ID          IN VARCHAR2, -- For EditYn
    O_RC1             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
    );


    PROCEDURE P_DMF0000_GET_EXCHANGE_POPUP_SPREAD_TITLE
    (
    P_START_YYYYMMDD  IN VARCHAR2,
    P_END_YYYYMMDD    IN VARCHAR2,
    O_RC1             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0000_GET_UPDATE_HISTORY
    (
    O_RC1             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0000_SAVE_EXCHANGE_POPUP_DATA
    (
      P_ACTIVE_FLAG            IN VARCHAR2
    , P_DIVISION_ID            IN VARCHAR2
    , P_YYYYMMDD               IN VARCHAR2
    , P_CURRENCY               IN VARCHAR2
    , P_UNIT_CURRENCY          IN VARCHAR2
    , P_EXCHANGE_PRICE         IN VARCHAR2
    , P_CREATED_BY             IN VARCHAR2
    , P_LAST_UPDATED_BY        IN VARCHAR2
    , O_RESULT_CURSOR          OUT SYS_REFCURSOR
    );

END PKG_DMF0000;
/
