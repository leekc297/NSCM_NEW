PACKAGE PKG_SCP0129
IS
    /*
     * Program ID   : PKG_SCP0129
     * Description  : SCP0129 Demand Exception 화면 — 수요제외 조회 · 저장
     * Program History
     *===================================================================================================
     *   Date       In Charge      Description
     *===================================================================================================
     * 2026.09.26   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
     *
     * 조회조건 초기값은 이 화면 전용 기능이 없다. SCP0128 의 초기값 기능을 함께 쓴다
     * (그 기능의 일곱 번째 결과 묶음이 이 화면용 공정 목록이다).
     */

    /* 수요제외 조회 */
    PROCEDURE P_SCP0129_GET_DEMAND_EXCEPTION
    (
        P_DIVISION_ID       IN  CLOB
      , P_PLAN_GROUP_ID     IN  CLOB
      , P_SCM_SITE_ID       IN  CLOB
      , P_ITEM_ID           IN  CLOB
      , P_STAGE             IN  CLOB
      , P_VALID_YN          IN  CLOB
      , P_PERIOD_FROM       IN  CLOB
      , P_PERIOD_TO         IN  CLOB
      , O_RC1               OUT SYS_REFCURSOR
      , O_RESULT_CURSOR     OUT SYS_REFCURSOR
    );

    /* 수요제외 저장 */
    PROCEDURE P_SCP0129_SAVE_DEMAND_EXCEPTION
    (
        P_ACTIVE_FLAG       IN  CLOB
      , P_DIVISION_ID       IN  CLOB
      , P_OPMZ_PLAN_GR_ID   IN  CLOB
      , P_SCM_SITE_ID       IN  CLOB
      , P_ITEM_ID           IN  CLOB
      , P_STAGE             IN  CLOB
      , P_FROM_YYYYMMDD     IN  CLOB
      , P_TO_YYYYMMDD       IN  CLOB
      , P_STOCK_EXCEPTION   IN  CLOB
      , P_VALUE_DESCRIPTION IN  CLOB
      , P_VALID_YN          IN  CLOB
      , P_USER_ID           IN  CLOB
      , P_PRE_DIVISION_ID   IN  CLOB
      , P_PRE_OPMZ_PLAN_GR_ID IN CLOB
      , P_PRE_SCM_SITE_ID   IN  CLOB
      , P_PRE_ITEM_ID       IN  CLOB
      , P_PRE_STAGE         IN  CLOB
      , P_PRE_FROM_YYYYMMDD IN  CLOB
      , P_PRE_TO_YYYYMMDD   IN  CLOB
      , O_RC1               OUT SYS_REFCURSOR
      , O_RESULT_CURSOR     OUT SYS_REFCURSOR
    );

END PKG_SCP0129;