-- DMF0074_CLOUD_20260823 / PKG_DMF0074 SPEC (사내 신선 덤프 20260823)
CREATE OR REPLACE PACKAGE           "PKG_DMF0074" IS
/****************************************************************************************************/
/* Program ID  : PKG_DMF0074                                                                        */
/* Description : PKG_DMF0074                                                                        */
/* Usage       :                                                                                    */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2026.04.03  SSLEE        [PJ20264226] NextSCM Pilot 설계 및 개발                                   */
/*                          UI 항목으로 Package로 전환                                                 */
/****************************************************************************************************/

PROCEDURE P_DMF0074_GET_METAL_LINK_PRICE
(
    P_DIVISION_ID   IN  VARCHAR2,
    P_DEPT_ID       IN  VARCHAR2,   --Department
    P_END_CUSTOMER  IN  VARCHAR2,   --Endcustomer
    P_SCM_SITE_ID   IN  VARCHAR2,
    P_PLANT_SITE_ID IN  VARCHAR2,
    P_PROJECT_CODE  IN  VARCHAR2,
    P_ITEM_ID       IN  VARCHAR2,
    P_FROM_YYYYMMDD IN  VARCHAR2,
    P_TO_YYYYMMDD   IN  VARCHAR2,
    P_VERSION_TYPE  IN  VARCHAR2,
    P_USER_ID       IN  VARCHAR2,
    P_MENU_ID       IN  VARCHAR2,
    O_RC1           OUT SYS_REFCURSOR,
    O_RESULT_CURSOR OUT SYS_REFCURSOR
);

PROCEDURE P_DMF0074_GET_METAL_LINK_TEMPLATE
(
    P_DIVISION_ID   IN  VARCHAR2,
    P_USER_ID       IN  VARCHAR2,
    P_MENU_ID       IN  VARCHAR2,
    O_RC1           OUT SYS_REFCURSOR,
    O_RESULT_CURSOR OUT SYS_REFCURSOR
);

PROCEDURE P_DMF0074_EXCEL_UPLOAD
(
      P_MODE          IN PLS_INTEGER
     ,P_CREATED_BY    IN VARCHAR2
     ,P_PROGRAM_ID    IN VARCHAR2 -- 3/26 추가 결정
     ,P_SHEET_NAME    IN VARCHAR2 -- 3/26 추가 결정
     ,O_RESULT_CURSOR OUT SYS_REFCURSOR
);

END PKG_DMF0074;
/
