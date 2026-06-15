CREATE OR REPLACE PACKAGE           "PKG_SYS0011"
AS

/*
 * Program ID   : PKG_SYS0011
 * Description  : PKG_SYS0011
 * Program History
 *===========================================================================================================
 *   Date       In Charge      Description
 *===========================================================================================================
 * 2026.04.16   park.choyi     [PJ20264226] NextSCM Pilot 화면 및 메뉴 개발
 */


    PROCEDURE P_SYS0011_GET_AUTH_DATA (
	    O_CURSOR        OUT SYS_REFCURSOR
    , O_RESULT_CURSOR OUT SYS_REFCURSOR
    );

    PROCEDURE P_SYS0011_GET_DIVISION_DATA (
	    O_CURSOR        OUT SYS_REFCURSOR
    , O_RESULT_CURSOR OUT SYS_REFCURSOR
    );

    PROCEDURE P_SYS0011_GET_MY_AUTH_DATA (
      P_USER_ID       IN  VARCHAR2
	  , O_CURSOR        OUT SYS_REFCURSOR
    , O_RESULT_CURSOR OUT SYS_REFCURSOR
    );

    PROCEDURE P_SYS0011_GET_USER_INFO_DATA (
      P_USER_ID       IN  VARCHAR2
	  , O_CURSOR        OUT SYS_REFCURSOR
    , O_RESULT_CURSOR OUT SYS_REFCURSOR
    );

    PROCEDURE P_SYS0011_SAVE_USER_INFO_DATA(
      P_DATA      IN    CLOB,
      P_USER_ID   IN    VARCHAR2,
      O_RESULT_CURSOR OUT   SYS_REFCURSOR
    );

    PROCEDURE P_SYS0011_SAVE_MY_AUTH_DATA(
      P_DATA      IN    CLOB,
      P_USER_ID   IN    VARCHAR2,
      O_RESULT_CURSOR OUT   SYS_REFCURSOR
    );

END PKG_SYS0011;
/
SHOW ERRORS;
