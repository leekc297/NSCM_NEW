-- DMF0020 튜닝 누적 적용본 SPEC (사내 2026-08-24)
CREATE OR REPLACE PACKAGE           "PKG_DMF0020" 
/*
 * Program ID   : PKG_DMF0020
 * Description  : PKG_DMF0200
 * Program History
 *===========================================================================================================
 *   Date       In Charge      Description
 *===========================================================================================================
 * 2026.03.19   jcnam       [PJ20264226] NextSCM Pilot 설계 및 개발
 *                          UI 항목으로 Package로 전환
 */
AS
    -- 프로시저 선언
    PROCEDURE P_DMF0020_GET_MEASURE_COUNTINFO_SAVE_PRICE
    (
    /* 보류 PCI 협의 3/19
        P_USER_ID         IN VARCHAR2, -- For EditYn
        P_MNU_ID          IN VARCHAR2, -- For EditYn
    */
        O_RC1             OUT SYS_REFCURSOR,
        O_RESULT_CURSOR   OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0020_GET_MEASURE_COUNTINFO
    (
        /*
        P_USER_ID         IN VARCHAR2, -- For EditYn
        P_MNU_ID          IN VARCHAR2, -- For EditYn
        */
        O_RC1             OUT SYS_REFCURSOR,
        O_RESULT_CURSOR   OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0020_GET_EXCHANGE_POPUP_SPREAD_TITLE
    (
        P_START_YYYYMMDD  IN VARCHAR2,
        P_END_YYYYMMDD    IN VARCHAR2,
        O_RC1             OUT SYS_REFCURSOR,
        O_RESULT_CURSOR   OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0020_GET_FUTUREPRICE_INFO
    (
    P_START_YYYYMMDD  IN VARCHAR2,
    P_END_YYYYMMDD    IN VARCHAR2,

    P_USER_ID         IN VARCHAR2, -- For EditYn
    P_MNU_ID          IN VARCHAR2, -- For EditYn

    O_RC1             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0000_SAVE_EXCHANGE_POPUP_DATA
    (
      P_ACTIVE_FLAG            IN VARCHAR2,
      P_DIVISION_ID            IN VARCHAR2,
      P_YYYYMMDD               IN VARCHAR2,
      P_CURRENCY               IN VARCHAR2,
      P_UNIT_CURRENCY          IN VARCHAR2,
      P_EXCHANGE_PRICE         IN VARCHAR2,
      P_CREATED_BY             IN VARCHAR2,
      P_LAST_UPDATED_BY        IN VARCHAR2,
      O_RESULT_CURSOR          OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0020_EXCEL_UPLOAD
    (
      P_MODE            IN PLS_INTEGER,
      P_CREATED_BY      IN VARCHAR2,
      P_PROGRAM_ID      IN VARCHAR2,  -- 3/26 추가 결정
      P_SHEET_NAME      IN VARCHAR2,  -- 3/26 추가 결정

      O_RESULT_CURSOR   OUT SYS_REFCURSOR
    );

    -- 3/20
    /*
    DMF0020_GET_SPREAD_TITLE
    DMF0020_GET_SALES_PRICE_TEMPLATE
    DMF0020_GET_SCM_MST_FUTURE_PRICE_POPUP
    DMF0020_GET_SCM_MST_FUTURE_PRICE_POPUP_DATA
    DMF0020_GET_SPREAD_TITLE_SAVE_PRICE
    DMF0020_GET_SPREAD_TITLE_DATE
    DMF0020_GET_OWNER_DATA
    */
    PROCEDURE P_DMF0020_GET_SPREAD_TITLE
    (
        P_START_DT     IN VARCHAR2,
        P_END_DT       IN VARCHAR2,
        P_CREATED_BY   IN VARCHAR2,
        P_DIVISION_ID  IN VARCHAR2,
        O_RC1          OUT SYS_REFCURSOR,
        O_RESULT_CURSOR OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0020_GET_SALES_PRICE_TEMPLATE
    (
        P_DIVISION_ID   IN VARCHAR2,
        P_USER_ID         IN VARCHAR2, -- For EditYn
        P_MNU_ID          IN VARCHAR2, -- For EditYn
        O_RC1           OUT SYS_REFCURSOR,
        O_RESULT_CURSOR OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0020_GET_SCM_MST_FUTURE_PRICE_POPUP
    (
        P_DIVISION_ID     IN VARCHAR2,
        P_FROM_YYYYMMDD   IN VARCHAR2,
        P_TO_YYYYMMDD     IN VARCHAR2,
        P_CREATED_BY      IN VARCHAR2,
        P_USER_ID         IN VARCHAR2, -- For EditYn
        P_MNU_ID          IN VARCHAR2, -- For EditYn
        O_RC1             OUT SYS_REFCURSOR,
        O_RESULT_CURSOR   OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0020_GET_SCM_MST_FUTURE_PRICE_POPUP_DATA
    (
        P_DIVISION_ID     IN VARCHAR2,
        P_FROM_YYYYMMDD   IN VARCHAR2,
        P_TO_YYYYMMDD     IN VARCHAR2,
        P_CREATED_BY      IN VARCHAR2,
        P_USER_ID         IN VARCHAR2, -- For EditYn
        P_MNU_ID          IN VARCHAR2, -- For EditYn
        O_RC1             OUT SYS_REFCURSOR,
        O_RESULT_CURSOR   OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0020_GET_SPREAD_TITLE_SAVE_PRICE
    (
        P_START_DT        IN VARCHAR2,
        P_END_DT          IN VARCHAR2,
        P_CREATED_BY      IN VARCHAR2,
        P_DIVISION_ID     IN VARCHAR2,
        O_RC1             OUT SYS_REFCURSOR,
        O_RESULT_CURSOR   OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0020_GET_SPREAD_TITLE_DATE
    (
        P_START_YYYYMMDD  IN VARCHAR2,
        P_END_YYYYMMDD    IN VARCHAR2,
        P_CREATED_BY      IN VARCHAR2,
        O_RC1             OUT SYS_REFCURSOR,
        O_RESULT_CURSOR   OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0020_GET_OWNER_DATA
    (
        P_DIVISION_ID     IN VARCHAR2,
        P_DEPT_ID         IN VARCHAR2,
        P_END_CUSTOMER    IN VARCHAR2,
        P_PROJECT_CODE    IN VARCHAR2,
        P_SCM_SITE_ID     IN VARCHAR2,
        P_OWNER_ID        IN VARCHAR2,

        P_USER_ID         IN VARCHAR2, -- For EditYn
        P_MNU_ID          IN VARCHAR2, -- For EditYn

        O_RC1             OUT SYS_REFCURSOR,
        O_RESULT_CURSOR   OUT SYS_REFCURSOR
    );

    -- 3/23
    PROCEDURE P_DMF0020_GET_WEEKDATA
    (
        P_YYYYMMDD        IN VARCHAR2,
        O_RC1             OUT SYS_REFCURSOR,
        O_RESULT_CURSOR   OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0020_SAVE_DM_MST_EXCHANGE_RATE_ALL
    (
        P_ACTIVE_FLAG       IN VARCHAR2,
        P_DIVISION_ID       IN VARCHAR2,
        P_YYYYMMDD          IN VARCHAR2,
        P_CURRENCY          IN VARCHAR2,
        P_UNIT_CURRENCY     IN VARCHAR2,
        P_EXCHANGE_PRICE    IN VARCHAR2,
        P_CREATED_BY        IN VARCHAR2,
        P_LAST_UPDATED_BY   IN VARCHAR2,
        O_RESULT_CURSOR     OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_CONVERSION
    (
        P_DIVISION_ID     IN VARCHAR2,
        O_RESULT_CURSOR   OUT SYS_REFCURSOR
    );





    /* ============================================================================
       [E20260824-PKGCONSOL] 단독 SP -> PKG 통합 (UI별 PKG 원칙)
         편입 4본: P_DMF0020_GET_SCM_MST_FUTURE_PRICE, P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL, P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_POPUP, P_DMF0020_GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP
         원본 단독 SP 는 배선 전환 후 폐기 대상. 본문은 무수정 이식(개명만).
       ============================================================================ */

    PROCEDURE P_DMF0020_GET_SCM_MST_FUTURE_PRICE
(
    P_DIVISION_ID            IN  VARCHAR2,
    P_DEPT_ID                IN  VARCHAR2,   --Department
    P_END_CUSTOMER           IN  VARCHAR2,   --Endcustomer
    P_SCM_SITE_ID            IN  VARCHAR2,
    P_PLANT_SITE_ID          IN  VARCHAR2,
    P_PROJECT_CODE           IN  VARCHAR2,
    P_ITEM_ID                IN  VARCHAR2,
    P_CUSTOMER_PROJECT_CODE  IN  VARCHAR2,
    P_CUSTOMER_MODEL         IN  VARCHAR2,
    P_FROM_YYYYMMDD          IN  VARCHAR2,
    P_TO_YYYYMMDD            IN  VARCHAR2,
    P_BIZTYPE                IN  VARCHAR2,
    P_CREATED_BY             IN  VARCHAR2,
    P_USERINFO               IN  VARCHAR2,
    P_OWNER                  IN  VARCHAR2,
    P_OVER_RANGE             IN  VARCHAR2,   -- [PJ20200138]범위 초과 Flag
    P_INVALID_EXEC           IN  VARCHAR2,   -- [C20200612-000174] ESS사업부 New Model Flag
    P_VERSION_TYPE           IN  VARCHAR2,
    O_RC1                    OUT SYS_REFCURSOR,
    O_RESULT_CURSOR          OUT SYS_REFCURSOR
);

    PROCEDURE P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL
(
    P_ACTIVE_FLAG       IN  VARCHAR2,
    P_DIVISION_ID       IN  VARCHAR2,
    P_PROJECT_CODE      IN  VARCHAR2,
    P_SCM_SITE_ID       IN  VARCHAR2,
    P_PLANT_SITE_ID     IN  VARCHAR2,
    P_ITEM_ID           IN  VARCHAR2,
    P_YYYYMMDD          IN  VARCHAR2,
    P_CURRENCY          IN  VARCHAR2,
    P_MEASURE           IN  VARCHAR2,
    P_DOM_EXP           IN  VARCHAR2,
    P_FCST_TYPE         IN  VARCHAR2,
    P_INCOTERMS         IN  VARCHAR2,
    P_PRICE             IN  VARCHAR2,
    P_CREATED_BY        IN  VARCHAR2,
    P_CREATION_DATE     IN  VARCHAR2,
    P_LAST_UPDATED_BY   IN  VARCHAR2,
    P_ROWNUM            IN  VARCHAR2,                 --[PJ20200138] RowNum 추가
    O_RC1               OUT SYS_REFCURSOR,        -- Range Rate 위반 결과셋
    O_RESULT_CURSOR     OUT SYS_REFCURSOR         -- 작업결과 (항상 마지막)
);

    PROCEDURE P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_POPUP
(
	-- Add the parameters for the stored procedure here
    p_active_flag             IN  VARCHAR2,
    p_DIVISION_ID             IN  VARCHAR2,
    p_PROJECT_CODE            IN  VARCHAR2,
    p_SCM_SITE_ID             IN  VARCHAR2,
    p_PLANT_SITE_ID           IN  VARCHAR2,
    p_ITEM_ID                 IN  VARCHAR2,
    p_YYYYMMDD                IN  VARCHAR2,
    p_CURRENCY                IN  VARCHAR2,
    p_MEASURE                 IN  VARCHAR2,
    p_DOM_EXP                 IN  VARCHAR2,
    p_FCST_TYPE               IN  VARCHAR2,
    p_INCOTERMS               IN  VARCHAR2,
    p_PRICE                   IN  VARCHAR2,
    p_CREATED_BY              IN  VARCHAR2,
    p_CREATION_DATE           IN  VARCHAR2,
    p_LAST_UPDATED_BY         IN  VARCHAR2,
    p_result_cursor           OUT SYS_REFCURSOR
);

    PROCEDURE P_DMF0020_GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP
(
    p_division_id            IN  VARCHAR2,
    p_dept_id                IN  VARCHAR2,    --Department
    p_end_customer           IN  VARCHAR2,    --Endcustomer
    p_scm_site_id            IN  VARCHAR2,
    p_plant_site_id          IN  VARCHAR2,
    p_project_code           IN  VARCHAR2,
    p_item_id                IN  VARCHAR2,
    p_customer_project_code  IN  VARCHAR2,
    p_customer_model         IN  VARCHAR2,
    p_from_yyyymmdd          IN  VARCHAR2,
    p_to_yyyymmdd            IN  VARCHAR2,
    p_biztype                IN  VARCHAR2,
    p_created_by             IN  VARCHAR2,
    p_userinfo               IN  VARCHAR2,
    p_owner                  IN  VARCHAR2,
    p_over_range             IN  VARCHAR2,   -- [PJ20200138]범위 초과 Flag
    p_invalid_exec           IN  VARCHAR2,   -- [C20200612-000174] ESS사업부 New Model Flag
    p_cur                    OUT SYS_REFCURSOR
);

END PKG_DMF0020;
/
