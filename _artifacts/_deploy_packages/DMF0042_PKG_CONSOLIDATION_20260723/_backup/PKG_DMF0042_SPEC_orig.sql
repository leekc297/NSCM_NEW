
  CREATE OR REPLACE EDITIONABLE PACKAGE "SCM_MGR"."PKG_DMF0042" IS
    /*
    * Program ID   : PKG_DMF0042
    * Description  : PKG_DMF0042
    * Program History
    *===========================================================================================================
    *   Date       In Charge      Description
    *===========================================================================================================
    * 2026.03.15   김준규       [PJ20264226] NextSCM Pilot 설계 및 개발
    */

    PROCEDURE P_DMF0042_GET_DM_MDF_VERSION
    (
        P_DIVISION_ID         VARCHAR2
       ,P_VERSION_DESCRIPTION VARCHAR2
       ,P_VERSION_TYPE        VARCHAR2
       ,P_FROM_YYYYMMDD       VARCHAR2
       ,P_TO_YYYYMMDD         VARCHAR2
       ,P_CREATED_BY          VARCHAR2
       ,P_USER_ID             VARCHAR2
       ,P_MENU_ID             VARCHAR2
       ,O_RC1                 OUT SYS_REFCURSOR
       ,O_RESULT_CURSOR       OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0042_GET_DM_PLN_BP_CUTOFF_VERSION
    (
        P_DIVISION_ID   VARCHAR2
       , -- 부서코드
        P_YYYYMM_FROM   VARCHAR2
       , -- 조회(데이터)시작구간
        P_YYYYMM_TO     VARCHAR2
       , -- 조회(데이터)끝구간
        P_VERSION_TYPE  VARCHAR2 -- 버전유형
       ,P_USER_ID       VARCHAR2
       ,P_MENU_ID       VARCHAR2
       ,O_RC1           OUT SYS_REFCURSOR
       ,O_RESULT_CURSOR OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0042_GET_EXCHANGE_PRICE
    (
        P_START_YYYYMMDD VARCHAR2
       ,P_END_YYYYMMDD   VARCHAR2
       ,P_USER_ID        VARCHAR2
       ,P_MENU_ID        VARCHAR2
       ,O_RC1            OUT SYS_REFCURSOR
       ,O_RESULT_CURSOR  OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0042_GET_SCM_MST_FUTURE_PRICE_POPUP
    (
        P_DIVISION_ID   VARCHAR2
       ,P_FROM_YYYYMMDD VARCHAR2
       ,P_TO_YYYYMMDD   VARCHAR2
       ,P_CREATED_BY    VARCHAR2
       ,P_CATE          VARCHAR2
       ,P_USER_ID       VARCHAR2
       ,P_MENU_ID       VARCHAR2
       ,O_RC1           OUT SYS_REFCURSOR
       ,O_RESULT_CURSOR OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0042_GET_SCM_MST_FUTURE_PRICE_POPUP_DATA
    (
        P_DIVISION_ID   VARCHAR2
       ,P_FROM_YYYYMMDD VARCHAR2
       ,P_TO_YYYYMMDD   VARCHAR2
       ,P_CREATED_BY    VARCHAR2
       ,P_CATE          VARCHAR2
       ,P_USER_ID       VARCHAR2
       ,P_MENU_ID       VARCHAR2
       ,O_RC1           OUT SYS_REFCURSOR
       ,O_RESULT_CURSOR OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0042_GET_SPREAD_TITLE
    (
        P_START_YYYYMMDD VARCHAR2
       ,P_END_YYYYMMDD   VARCHAR2
       ,P_CREATED_BY     VARCHAR2
       ,P_DIVISION_ID    VARCHAR2
       ,P_USER_ID        VARCHAR2
       ,P_MENU_ID        VARCHAR2
       ,O_RC1            OUT SYS_REFCURSOR
       ,O_RESULT_CURSOR  OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0042_SAVE_DM_BP_EXCHANGE_RATE
    (
        P_ACTIVE_FLAG     VARCHAR2
       ,P_DIVISION_ID     VARCHAR2
       ,P_YYYYMMDD        VARCHAR2
       ,P_CURRENCY        VARCHAR2
       ,P_UNIT_CURRENCY   VARCHAR2
       ,P_EXCHANGE_PRICE  VARCHAR2
       ,P_CREATED_BY      VARCHAR2
       ,P_LAST_UPDATED_BY VARCHAR2
       ,O_RESULT_CURSOR   OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0042_SAVE_DM_PLN_BP_FCST
    (
        P_ACTIVE_FLAG   VARCHAR2
       ,P_DIVISION_ID   VARCHAR2
       ,P_PROJECT_CODE  VARCHAR2
       ,P_PROJECT_NAME  VARCHAR2
       ,P_SCM_SITE_ID   VARCHAR2
       ,P_PLANT_SITE_ID VARCHAR2
       ,P_ITEM_ID       VARCHAR2
        --, p_DOM_EXP         VARCHAR2
       ,P_FCST_TYPE VARCHAR2
       ,P_INCOTERMS VARCHAR2 -- PJ20200138 Incoterms 삭제
        -- -----------------------------------------------------------------------------------------------
        -- PJ20200138 item_use, unit_energy 추가 (START)
       ,P_ITEM_USE    VARCHAR2
       ,P_UNIT_ENERGY VARCHAR2
        -- PJ20200138 item_use, unit_energy 추가 (END)
        -- -----------------------------------------------------------------------------------------------
       ,P_MEASURE  VARCHAR2
       ,P_YYYYMM   VARCHAR2
       ,P_QTY      VARCHAR2
       ,P_CURRENCY VARCHAR2
        -- -----------------------------------------------------------------------------------------------
        -- 20190830 파라미터추가 (START)
       ,P_DEPT_ID        VARCHAR2
       ,P_END_CUSTOMER   VARCHAR2
       ,P_BIZ_TYPE       VARCHAR2
       ,P_CELL_PROD_SITE VARCHAR2
        --, p_CELL_PER_PACK            VARCHAR2
        --, p_CELL_PER_MODULE          VARCHAR2
        --, p_MODULE_PER_PACK          VARCHAR2
        -- 20190830 파라미터추가 (END)
        -- -----------------------------------------------------------------------------------------------
       ,P_CREATED_BY      VARCHAR2
       ,P_LAST_UPDATED_BY VARCHAR2
       ,O_RESULT_CURSOR   OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0042_SAVE_DM_PLN_BP_FCST_PRICE_CONV
    (
        S_FLAG          VARCHAR2
       ,S_DIVISION_ID   VARCHAR2
       ,O_RC1           OUT SYS_REFCURSOR
       ,O_RC2           OUT SYS_REFCURSOR
       ,O_RESULT_CURSOR OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0042_SAVE_DM_PLN_BP_REPLACE_BY_CUTOFF
    (
        P_DIVISION_ID   VARCHAR2
       , -- 부서코드
        P_VERSION_TYPE  VARCHAR2
       , -- 버전유형
        P_YYYYMM_FROM   VARCHAR2
       , -- 시작구간
        P_YYYYMM_TO     VARCHAR2
       , -- 끝구간
        P_CREATED_BY    VARCHAR2
       , -- 작성자
        P_VERSION_NO    VARCHAR2 -- 버전번호 (BP_M_20220822_V002)
       ,O_RESULT_CURSOR OUT SYS_REFCURSOR
    );

END PKG_DMF0042;
/