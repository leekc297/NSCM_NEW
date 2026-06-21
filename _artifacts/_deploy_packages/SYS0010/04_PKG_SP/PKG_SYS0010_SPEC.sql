CREATE OR REPLACE PACKAGE           "PKG_SYS0010"
AS

/*
 * Program ID   : PKG_SYS0010
 * Description  : PKG_SYS0010
 * Program History
 *===========================================================================================================
 *   Date       In Charge      Description
 *===========================================================================================================
 * 2026.04.13   park.choyi     [PJ20264226] NextSCM Pilot 화면 및 메뉴 개발
 */


    PROCEDURE P_SYS0010_GET_LOOKUP_MASTER (
      P_LOOKUP_TYPE   IN  VARCHAR2
    , P_LOOKUP_GROUP  IN  VARCHAR2
    , P_VALID_YN      IN  VARCHAR2
    , O_RC1           OUT SYS_REFCURSOR
    , O_RESULT_CURSOR OUT SYS_REFCURSOR
    );

    PROCEDURE P_SYS0010_GET_LOOKUP_MASTER_DETAIL (
      P_LOOKUP_TYPE   IN  VARCHAR2
    , O_RC1           OUT SYS_REFCURSOR
    , O_RESULT_CURSOR OUT SYS_REFCURSOR
    );

    PROCEDURE P_SYS0010_SAVE_LOOKUP_MASTER (
      P_DATA         IN CLOB
    , P_USER_ID      IN  VARCHAR2
    , O_RESULT_CURSOR    OUT SYS_REFCURSOR
    );

    PROCEDURE P_SYS0010_SAVE_LOOKUP_MASTER_HIST (
      P_DATA         IN CLOB
    , P_USER_ID      IN  VARCHAR2
    , O_RESULT_CURSOR    OUT SYS_REFCURSOR
    );

    PROCEDURE P_SYS0010_SAVE_LOOKUP_MASTER_DETAIL (
      P_DATA           IN CLOB
    , P_USER_ID        IN VARCHAR2
    , O_RESULT_CURSOR  OUT SYS_REFCURSOR
    );
    PROCEDURE P_SYS0010_SAVE_LOOKUP_MASTER_DETAIL_HIST (
        P_DATA           IN CLOB
      , P_USER_ID        IN VARCHAR2
      , O_RESULT_CURSOR  OUT SYS_REFCURSOR
    );

END PKG_SYS0010;
/
SHOW ERRORS;
