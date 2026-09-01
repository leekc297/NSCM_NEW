CREATE OR REPLACE PACKAGE         PKG_DMF0051 IS
    /*
    * Program ID   : PKG_DMF0051
    * Description  : PKG_DMF0051
    * Program History
    *===========================================================================================================
    *   Date       In Charge      Description
    *===========================================================================================================
    * 2026.03.15   김준규       [PJ20264226] NextSCM Pilot 설계 및 개발
    */

    PROCEDURE P_DMF0051_GET_SPREAD_TITLE
    (
        P_START_YYYYMMDD VARCHAR2
       ,P_END_YYYYMMDD   VARCHAR2
       ,P_CREATED_BY     VARCHAR2
       ,P_DIVISION_ID    VARCHAR2
       ,P_BUCKET         VARCHAR2
       ,P_USER_ID        VARCHAR2
       ,P_MENU_ID        VARCHAR2
       ,O_RC1            OUT SYS_REFCURSOR
       ,O_RESULT_CURSOR  OUT SYS_REFCURSOR
    );

    /* [E20260806-WF] DMF0035 Demand Plan Waterfall 통합 — AS-IS DMF0051_GET_DM_PLN_BIZ_PLAN_WATERFALL(1,296행) 6-Stage 재변환
       IN 19 = AS-IS 17 positional 순서 그대로 + P_USER_ID/P_MENU_ID (사내 표준, PKG_DMF0022 waterfall 규약)
       OUT 3 = O_RC1(메인 피벗+EDIT_YN) / O_RC2(금일 ISO_WEEK·BASIS_DATE) / O_RESULT_CURSOR(결과코드) */
    PROCEDURE P_DMF0051_GET_DM_PLN_BIZ_PLAN_WATERFALL
    (
        P_DIVISION_ID       IN VARCHAR2,
        P_DEPT_ID           IN VARCHAR2,
        P_END_CUSTOMER      IN VARCHAR2,
        P_SCM_SITE_ID       IN VARCHAR2,
        P_PROJECT_CODE      IN VARCHAR2,
        P_ITEM_ID           IN VARCHAR2,
        P_ITEM_TYPE         IN VARCHAR2,
        P_FROM_YYYYMMDD     IN VARCHAR2,
        P_NOW_YYYYMMDD      IN VARCHAR2,   -- AS-IS 수신만·본문 미사용 (계약 보존)
        P_TO_YYYYMMDD       IN VARCHAR2,
        P_CREATED_BY        IN VARCHAR2,
        P_PLANT_SITE_ID     IN VARCHAR2,
        P_BIZTYPE           IN VARCHAR2,
        P_OWNER             IN VARCHAR2,
        P_VERSION_TYPE      IN VARCHAR2,
        P_CELL_YN           IN VARCHAR2,
        P_QTY_YN            IN VARCHAR2,
        P_USER_ID           IN VARCHAR2,
        P_MENU_ID           IN VARCHAR2,

        O_RC1               OUT SYS_REFCURSOR,
        O_RC2               OUT SYS_REFCURSOR,
        O_RESULT_CURSOR     OUT SYS_REFCURSOR
    );

END PKG_DMF0051;
/
