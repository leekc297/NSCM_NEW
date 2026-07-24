CREATE OR REPLACE PACKAGE           "PKG_DMF0003" IS
/*
 * Program ID   : PKG_DMF0003
 * Description  : PKG_DMF0003
 * Program History
 *===========================================================================================================
 *   Date       In Charge      Description
 *===========================================================================================================
 * 2026.03.12   kimcd       [PJ20264226] NextSCM Pilot 설계 및 개발
 *                          UI 항목으로 Package로 전환
 */

    PROCEDURE P_DMF0003_GET_BUCKET_TYPE_CODE
    (
      O_RC1             OUT SYS_REFCURSOR,
      O_RESULT_CURSOR   OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0003_CAR_FCST_EXCEL_UPLOAD
    (
      P_MODE          IN  PLS_INTEGER,
      P_CREATED_BY    IN  VARCHAR2,
      O_RESULT_CURSOR OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0003_GET_DM_ANL_CAR_PROPERTY
    (
      P_DIVISION_ID   IN VARCHAR2,
      P_MAKER_NAME    IN VARCHAR2,
      O_RC1           OUT SYS_REFCURSOR,
      O_RC2           OUT SYS_REFCURSOR,
      O_RC3           OUT SYS_REFCURSOR,
      O_RESULT_CURSOR   OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0003_GET_DM_ANL_CAR_REF
    (
        P_FROM_YYYYMMDD IN VARCHAR2,
        P_TO_YYYYMMDD   IN VARCHAR2,
        P_CAR_MAKER     IN VARCHAR2,
        P_CAR_MODEL     IN VARCHAR2,
        O_RC1           OUT SYS_REFCURSOR,
        O_RC2           OUT SYS_REFCURSOR,
        O_RC3           OUT SYS_REFCURSOR,
        O_RESULT_CURSOR   OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0003_GET_DM_ANL_MKT_PSI_DPINIT
    (
        P_DIVISION_ID   IN VARCHAR2,
        P_PROJECT_CODE  IN VARCHAR2,
        P_YYYYMM        IN VARCHAR2,
        P_CREATED_BY    IN VARCHAR2,
        P_END_CUSTOMER  IN VARCHAR2,
        O_RC1           OUT SYS_REFCURSOR,
        O_RESULT_CURSOR   OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0003_GET_DM_ANL_MKT_PSI_DPRESULT
    (
        P_DIVISION_ID   IN VARCHAR2,
        P_PROJECT_CODE  IN VARCHAR2,
        P_YYYYMM        IN VARCHAR2,
        P_CREATED_BY    IN VARCHAR2,
        P_END_CUSTOMER  IN VARCHAR2,
        O_RC1           OUT SYS_REFCURSOR,
        O_RESULT_CURSOR   OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0003_GET_SPREAD_TITLE
    (
        P_START_YYYYMMDD  IN VARCHAR2,
        P_END_YYYYMMDD    IN VARCHAR2,
        P_CREATED_BY      IN VARCHAR2,
        P_DIVISION_ID     IN VARCHAR2,
        O_RC1             OUT SYS_REFCURSOR,
        O_RESULT_CURSOR   OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0003_GET_MKT_FCST_COMPARE_POPUP
    (
        P_DIVISION_ID   IN VARCHAR2,
        P_SCM_SITE_ID   IN VARCHAR2,
        P_PROJECT_CODE  IN VARCHAR2,
        P_ITEM_ID       IN VARCHAR2,
        --[C20210225-000385] dom_exp, fcst_type, incoterms, yyyymmdd 추가
        P_DOM_EXP       IN VARCHAR2,
        P_FCST_TYPE     IN VARCHAR2,
        P_INCOTERMS     IN VARCHAR2,
        P_YYYYMMDD      IN VARCHAR2,
        O_RC1           OUT SYS_REFCURSOR,
        O_RESULT_CURSOR OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0003_GET_QTY_TYPE_CODE
    (
        O_RC1             OUT SYS_REFCURSOR,
        O_RESULT_CURSOR   OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0003_GET_REPORT_BUCKET_TYPE_CODE
    (
        O_RC1             OUT SYS_REFCURSOR,
        O_RESULT_CURSOR   OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0003_GET_SPREAD_TITLE_CAR
    (
        P_START_YYYYMMDD  IN VARCHAR2,
        P_END_YYYYMMDD    IN VARCHAR2,
        P_CREATED_BY      IN VARCHAR2,
        P_DIVISION_ID     IN VARCHAR2,
        O_RC1             OUT SYS_REFCURSOR,
        O_RESULT_CURSOR   OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0003_GET_SPREAD_TITLE_PSI
    (
        P_START_YYYYMMDD  IN VARCHAR2,
        P_END_YYYYMMDD    IN VARCHAR2,
        P_CREATED_BY      IN VARCHAR2,
        P_DIVISION_ID     IN VARCHAR2,
        O_RC1             OUT SYS_REFCURSOR,
        O_RESULT_CURSOR   OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0003_GET_SPREAD_TITLE_PSI_POPUP
    (
        P_START_YYYYMMDD  IN VARCHAR2,
        P_END_YYYYMMDD    IN VARCHAR2,
        P_CREATED_BY      IN VARCHAR2,
        P_DIVISION_ID     IN VARCHAR2,
        O_RC1             OUT SYS_REFCURSOR,
        O_RESULT_CURSOR   OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0003_MKT_FCST_SALES_PLAN_SYNC
    (
        P_DIVISION_ID   IN VARCHAR2,
        P_CREATED_BY    IN VARCHAR2,
        O_RESULT_CURSOR OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0003_SAVE_MKT_FCST_PK_DATA_UPDATE
    (
         P_DIVISION_ID        IN VARCHAR2
        ,P_PROJECT_CODE       IN VARCHAR2
        ,P_SCM_SITE_ID        IN VARCHAR2
        ,P_ITEM_ID            IN VARCHAR2
        ,P_DOM_EXP            IN VARCHAR2
        ,P_FCST_TYPE          IN VARCHAR2
        ,P_INCOTERMS          IN VARCHAR2
        ,P_PLANT_SITE_ID      IN VARCHAR2
        ,P_DOM_EXP_NEW        IN VARCHAR2
        ,P_FCST_TYPE_NEW      IN VARCHAR2
        ,P_INCOTERMS_NEW      IN VARCHAR2
        ,P_PLANT_SITE_ID_NEW  IN VARCHAR2
        ,P_CREATED_BY         IN VARCHAR2
        ,O_RESULT_CURSOR      OUT SYS_REFCURSOR
    );


    PROCEDURE P_DMF0003_GET_MKT_FCST_DATA
    ( P_DIVISION_ID      IN  VARCHAR2
    , P_SCM_SITE_ID      IN  VARCHAR2
    , P_PLANT_SITE_ID    IN  VARCHAR2
    , P_TEAM_ID          IN  VARCHAR2
    , P_CUSTOMER         IN  VARCHAR2
    , P_BIZ_TYPE         IN  VARCHAR2
    , P_PROJECT_CODE     IN  VARCHAR2
    , P_ITEM_ID          IN  VARCHAR2
    , P_FROM_YYYYMMDD    IN  VARCHAR2
    , P_TO_YYYYMMDD      IN  VARCHAR2
    , P_CREATED_BY       IN  VARCHAR2
    , P_USER_GROUP       IN  VARCHAR2
    , P_ITEM_TYPE        IN  VARCHAR2
    , P_OWNER            IN  VARCHAR2
    , P_QTY_YN           IN  VARCHAR2
    , P_CELL_YN          IN  VARCHAR2
    , P_INVALID_EXEC     IN  VARCHAR2   -- [C20200612-000174] ESS사업부 New Model Flag
    , P_AS_YN            IN  VARCHAR2
    , P_USER_DEPT_ID     IN  VARCHAR2   -- JV Planner 일때 USER 부서정보로 SALES SITE ID 정보를 얻기 위해추가
    , P_SENDER_CODE      IN  VARCHAR2   -- SENDER_CODE 추가
    , P_USER_ID          IN VARCHAR2
    , P_MENU_ID          IN VARCHAR2
    , O_RC1              OUT SYS_REFCURSOR
    , O_RC2              OUT SYS_REFCURSOR   -- 8주 이내 bucket 정보
    , O_RC3              OUT SYS_REFCURSOR   -- 현재 주차 정보
    , O_RESULT_CURSOR    OUT SYS_REFCURSOR

    );

    PROCEDURE P_DMF0003_SAVE_MKT_FCST
    ( P_ACTIVE_FLAG      IN  VARCHAR2
      , P_DIVISION_ID      IN  VARCHAR2
      , P_PROJECT_CODE     IN  VARCHAR2
      , P_SCM_SITE_ID      IN  VARCHAR2
      , P_ITEM_ID          IN  VARCHAR2
      , P_DOM_EXP          IN  VARCHAR2
      , P_FCST_TYPE        IN  VARCHAR2
      , P_INCOTERMS        IN  VARCHAR2
      , P_MEASURE          IN  VARCHAR2
      , P_PLANT_SITE_ID    IN  VARCHAR2
      , P_YYYYMMDD         IN  VARCHAR2
      , P_QTY              IN  VARCHAR2
      , P_CREATED_BY       IN  VARCHAR2
      , P_AS_FROM_SITE     IN  VARCHAR2
      , P_BUCKET           IN  VARCHAR2  --[E20250313-001251]_화면의 bucket 정보 받음
      , P_AUTHORITY        IN  VARCHAR2 DEFAULT NULL  --[E20260604-000994]_저장 시 로그인 권한 그룹 수신 (저장 시간창 게이트 본문은 AS-IS SP 원문 확보 후 이식 예정 — 2026-07-20)
      , O_RC1              OUT SYS_REFCURSOR
      , O_RESULT_CURSOR    OUT SYS_REFCURSOR
      );

END PKG_DMF0003;
/
