
  CREATE OR REPLACE EDITIONABLE PACKAGE "SCM_MGR"."PKG_DMF0021" 
/*
 * Program ID   : PKG_DMF0021
 * Description  : PKG_DMF0201
 * Program History
 *===========================================================================================================
 *   Date       In Charge      Description
 *===========================================================================================================
 * 2026.03.23   jcnam       [PJ20264226] NextSCM Pilot 설계 및 개발
 *                          UI 항목으로 Package로 전환
 */
AS
    -- 프로시저 선언
    PROCEDURE P_DMF0021_GET_SALES_PLAN_MEASUREINFO
    (
        O_RC1             OUT SYS_REFCURSOR,
        O_RESULT_CURSOR   OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0021_GET_SALES_PLAN_MEASUREINFO2
    (
        P_USER_ID         IN VARCHAR2, -- For EditYn
        P_MNU_ID          IN VARCHAR2, -- For EditYn

        O_RC1             OUT SYS_REFCURSOR,
        O_RESULT_CURSOR   OUT SYS_REFCURSOR
    );


    PROCEDURE P_DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL
    (
        P_ACTIVE_FLAG         IN VARCHAR2,
        P_DIVISION_ID         IN VARCHAR2,
        P_PROJECT_CODE        IN VARCHAR2,
        P_SCM_SITE_ID         IN VARCHAR2,
        P_PLANT_SITE_ID       IN VARCHAR2,
        P_ITEM_ID             IN VARCHAR2,
        P_DOM_EXP             IN VARCHAR2,
        P_FCST_TYPE           IN VARCHAR2,
        P_INCOTERMS           IN VARCHAR2,
        P_MEASURE             IN VARCHAR2,
        P_YYYYMMDD            IN VARCHAR2,
        P_QTY                 IN VARCHAR2,
        P_CURRENCY            IN VARCHAR2,
        P_CREATED_BY          IN VARCHAR2,
        P_LAST_UPDATED_BY     IN VARCHAR2,
        P_TEXT                IN VARCHAR2,
        P_DEPT_ID             IN VARCHAR2,  --[PJ2024-50611] 부서ID추가
        P_CELL_PROD_SITE_ID   IN VARCHAR2,  --[PJ2025-50017] CELL_PROD_SITE_ID 추가
        O_RESULT_CURSOR       OUT SYS_REFCURSOR
    );





END PKG_DMF0021;
/