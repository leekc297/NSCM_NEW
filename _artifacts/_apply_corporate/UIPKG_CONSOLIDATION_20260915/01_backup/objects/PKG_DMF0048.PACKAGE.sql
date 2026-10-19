-- SOURCE-FRESH: SCM_MGR.PKG_DMF0048 PACKAGE LAST_DDL=2026-09-14 18:54:24 FETCHED=2026-09-15 18:50 DB=ZIOUI1
-- STEP 1 BACKUP (원복용 원문 · STATUS=VALID)
SET DEFINE OFF
CREATE OR REPLACE PACKAGE SCM_MGR."PKG_DMF0048" IS
    /*
    * Program ID   : PKG_DMF0048
    * Description  : PKG_DMF0048
    * Program History
    *===========================================================================================================
    *   Date       In Charge      Description
    *===========================================================================================================
    * 2026.04.07   김준규          [PJ20264226] NextSCM Pilot 설계 및 개발
    * 2026.09.14   AJS             단독 프로시저 DMF0048_GET_SPREAD_TITLE 를 P_DMF0048_GET_SPREAD_TITLE 로 편입
    */

    PROCEDURE P_DMF0048_GET_DM_PLN_SALES_MONITORING
    (
        P_DIVISION_ID   VARCHAR2
       ,P_DEPT_ID       VARCHAR2
       ,P_END_CUSTOMER  VARCHAR2
       ,P_SCM_SITE_ID   VARCHAR2
       ,P_PROJECT_CODE  VARCHAR2
       ,P_ITEM_ID       VARCHAR2
       ,P_ITEM_TYPE     VARCHAR2
       ,P_FROM_YYYYMMDD VARCHAR2
       ,P_NOW_YYYYMMDD  VARCHAR2
       ,P_TO_YYYYMMDD   VARCHAR2
       ,P_CREATED_BY    VARCHAR2
       ,P_PLANT_SITE_ID VARCHAR2
       ,P_BIZTYPE       VARCHAR2
       ,P_OWNER         VARCHAR2
       ,P_INTERNAL_YN   VARCHAR2
       ,P_USERINFO      VARCHAR2
       ,P_BUCKET        VARCHAR2 -- 20211026 SALES PLAN 속도 개선
       ,P_USER_DEPT_ID  VARCHAR2 -- JV Planner 일때 USER 부서정보로 SALES SITE ID 정보를 얻기 위해추가
       ,P_USER_ID       VARCHAR2
       ,P_MENU_ID       VARCHAR2
       ,O_RC1           OUT SYS_REFCURSOR
       ,O_RC2           OUT SYS_REFCURSOR
       ,O_RESULT_CURSOR OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0048_GET_SPREAD_TITLE                                               -- 2026.09.14 AJS
    (
        p_start_yyyymmdd    VARCHAR2
       ,p_end_yyyymmdd      VARCHAR2
       ,p_created_by        VARCHAR2
       ,p_division_id       VARCHAR2
       ,p_bucket            VARCHAR2
       ,O_RC1               OUT SYS_REFCURSOR
    );

END PKG_DMF0048;
/
