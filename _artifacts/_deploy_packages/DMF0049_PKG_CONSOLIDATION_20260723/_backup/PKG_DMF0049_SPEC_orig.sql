
  CREATE OR REPLACE EDITIONABLE PACKAGE "SCM_MGR"."PKG_DMF0049" IS
    /*
    * Program ID   : PKG_DMF0049
    * Description  : PKG_DMF0049
    * Program History
    *===========================================================================================================
    *   Date       In Charge      Description
    *===========================================================================================================
    * 2026.03.15   김준규       [PJ20264226] NextSCM Pilot 설계 및 개발
    */

    PROCEDURE P_DMF0049_GET_MEASURE
    (
        P_DIVISION_ID   VARCHAR2
       ,P_USER_ID       VARCHAR2
       ,P_MENU_ID       VARCHAR2
       ,O_RC1           OUT SYS_REFCURSOR
       ,O_RESULT_CURSOR OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0049_GET_SPREAD_TITLE
    (
        P_DIVISION_ID   VARCHAR2
       ,P_CREATED_BY    VARCHAR2
       ,P_START_DT      VARCHAR2
       ,P_END_DT        VARCHAR2
       ,P_USER_ID       VARCHAR2
       ,P_MENU_ID       VARCHAR2
       ,O_RC1           OUT SYS_REFCURSOR
       ,O_RESULT_CURSOR OUT SYS_REFCURSOR
    );

END PKG_DMF0049;
/