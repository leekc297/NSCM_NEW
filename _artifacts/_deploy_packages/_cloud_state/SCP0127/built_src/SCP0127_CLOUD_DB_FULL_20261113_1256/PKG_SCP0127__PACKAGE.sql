PACKAGE PKG_SCP0127
IS
    /*
     * Program ID   : PKG_SCP0127
     * Description  : SCP0127 Precede / Safety Stock Day 화면 — 선행생산 · 안전재고 일수 조회 · 저장
     * Program History
     *===================================================================================================
     *   Date       In Charge      Description
     *===================================================================================================
     * 2026.09.26   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
     */

    /* 조회조건 초기값 */
    PROCEDURE P_SCP0127_GET_SEARCH_INFO
    (
        P_DIVISION_ID       IN  CLOB
      , P_SITE_ID           IN  CLOB
      , O_RC1               OUT SYS_REFCURSOR
      , O_RC2               OUT SYS_REFCURSOR
      , O_RC3               OUT SYS_REFCURSOR
      , O_RC4               OUT SYS_REFCURSOR
      , O_RC5               OUT SYS_REFCURSOR
      , O_RC6               OUT SYS_REFCURSOR
      , O_RESULT_CURSOR     OUT SYS_REFCURSOR
    );

    /* 선행생산 · 안전재고 일수 조회 */
    PROCEDURE P_SCP0127_GET_PRECEDE_SAFETY_STOCK_DAY
    (
        P_DIVISION_ID       IN  CLOB
      , P_PLAN_GROUP_ID     IN  CLOB
      , P_SCM_SITE_ID       IN  CLOB
      , P_ITEM_ID           IN  CLOB
      , P_STAGE             IN  CLOB
      , P_VALID_YN          IN  CLOB
      , P_VALUE_TYPE        IN  CLOB
      , P_PERIOD_FROM       IN  CLOB
      , P_PERIOD_TO         IN  CLOB
      , O_RC1               OUT SYS_REFCURSOR
      , O_RESULT_CURSOR     OUT SYS_REFCURSOR
    );

    /* 선행생산 · 안전재고 일수 저장 */
    PROCEDURE P_SCP0127_SAVE_PRECEDE_SAFETY_STOCK_DAY
    (
        P_ACTIVE_FLAG       IN  CLOB
      , P_VALUE_TYPE        IN  CLOB
      , P_DIVISION_ID       IN  CLOB
      , P_OPMZ_PLAN_GR_ID   IN  CLOB
      , P_SCM_SITE_ID       IN  CLOB
      , P_ITEM_ID           IN  CLOB
      , P_STAGE             IN  CLOB
      , P_FROM_YYYYMMDD     IN  CLOB
      , P_TO_YYYYMMDD       IN  CLOB
      , P_TYPE_APPLY_DAY    IN  CLOB
      , P_VALUE_DESCRIPTION IN  CLOB
      , P_VALID_YN          IN  CLOB
      , P_USER_ID           IN  CLOB
      , P_PRE_VALUE_TYPE    IN  CLOB
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

END PKG_SCP0127;