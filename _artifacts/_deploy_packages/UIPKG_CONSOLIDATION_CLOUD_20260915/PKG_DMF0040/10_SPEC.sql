-- SOURCE-FRESH: SCM_MGR.PKG_DMF0040 PACKAGE LAST_DDL=2026-09-15 18:58:16 FETCHED=2026-09-15 21:03 DB=ZIOUI1
-- PKG_DMF0040 PACKAGE — standalone SP 취합본 (사내 적용 2026-09-15)
SET DEFINE OFF
CREATE OR REPLACE PACKAGE SCM_MGR."PKG_DMF0040" IS
/****************************************************************************************************/
/* PROGRAM ID  : PKG_DMF0040                                                                        */
/* DESCRIPTION : PKG_DMF0040                                                                        */
/* USAGE       :                                                                                    */
/* PARAMETER   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* DATE        IN CHARGE    DESCRIPTION                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2026.04.06  SSLEE        [PJ20264226] NEXTSCM PILOT 설계 및 개발                                   */
/*                          UI 항목으로 PACKAGE로 전환                                                 */
/****************************************************************************************************/

PROCEDURE P_DMF0040_GET_MKT_FCST_COMPARISON
(
    P_DIVISION_ID   IN  VARCHAR2,
    P_SCM_SITE_ID   IN  VARCHAR2,
    P_PLANT_SITE_ID IN  VARCHAR2,
    P_TEAM_ID       IN  VARCHAR2,
    P_CUSTOMER      IN  VARCHAR2,
    P_BIZ_TYPE      IN  VARCHAR2,
    P_PROJECT_CODE  IN  VARCHAR2,
    P_ITEM_ID       IN  VARCHAR2,
    P_FROM_YYYYMMDD IN  VARCHAR2,
    P_TO_YYYYMMDD   IN  VARCHAR2,
    P_CREATED_BY    IN  VARCHAR2,
    P_VERSION_NO    IN  VARCHAR2,
    P_ITEM_TYPE     IN  VARCHAR2,
    P_OWNER         IN  VARCHAR2,
    P_DIFF_ONLY     IN  VARCHAR2,   -- 'True' or 'False'
    P_BUCKET        IN  VARCHAR2,
    P_USER_ID       IN  VARCHAR2,
    P_MENU_ID       IN  VARCHAR2,
    O_RC1           OUT SYS_REFCURSOR,   -- 메인 데이터
    O_RESULT_CURSOR OUT SYS_REFCURSOR    -- 항상 마지막 파라미터
);

    -- [2026-09-15 UIPKG] standalone DMF0040_GET_SPREAD_TITLE
    PROCEDURE P_DMF0040_GET_SPREAD_TITLE 
(
    P_START_YYYYMMDD  IN VARCHAR2,
    P_END_YYYYMMDD    IN VARCHAR2,
    P_CREATED_BY      IN VARCHAR2,
    P_DIVISION_ID     IN VARCHAR2,
    P_BUCKET          IN VARCHAR2,
    O_RC1             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
);

END PKG_DMF0040;
/
