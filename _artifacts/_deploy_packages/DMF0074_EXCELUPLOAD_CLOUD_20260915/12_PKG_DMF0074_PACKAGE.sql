-- SOURCE-FRESH: SCM_MGR.PKG_DMF0074 PACKAGE LAST_DDL=2026-09-14 17:12:53 FETCHED=2026-09-15 16:33 DB=ZIOUI1
-- PKG_DMF0074 PACKAGE — ③ 검증 P_DMF0074_EXCEL_UPLOAD / ⑤ 저장 / 조회
-- 원천: 사내 ZIOUI1 SCM_MGR 현재 원문 (LAST_DDL 2026-09-14 17:12:53, VALID) · 수정 마커 0종
SET DEFINE OFF
SET SQLBLANKLINES ON
CREATE OR REPLACE PACKAGE SCM_MGR.PKG_DMF0074
IS
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
SHOW ERRORS PACKAGE SCM_MGR.PKG_DMF0074
