PACKAGE PKG_SCP0130
IS
    /*
     * Program ID   : PKG_SCP0130
     * Description  : SCP0130 Scheduled Reciept Information 화면 — 입고예정 · 가상 BOM 조회 · 저장
     * Program History
     *===================================================================================================
     *   Date       In Charge      Description
     *===================================================================================================
     * 2026.09.26   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
     *
     * 시트가 둘이다 — 입고예정(Scheduled Reciept Information) · 가상 BOM(Virtual Bom).
     * 원문 이름 SVAE_VIRTUAL_BOM 은 오타지만 화면 기능이 그 이름으로 등록되어 있어 그대로 둔다.
     */

    /* 조회조건 초기값 */
    PROCEDURE P_SCP0130_GET_SEARCH_INFO
    (
        P_DIVISION_ID       IN  CLOB
      , P_SITE_ID           IN  CLOB
      , O_RC1               OUT SYS_REFCURSOR
      , O_RC2               OUT SYS_REFCURSOR
      , O_RC3               OUT SYS_REFCURSOR
      , O_RC4               OUT SYS_REFCURSOR
      , O_RC5               OUT SYS_REFCURSOR
      , O_RC6               OUT SYS_REFCURSOR
      , O_RC7               OUT SYS_REFCURSOR
      , O_RC8               OUT SYS_REFCURSOR
      , O_RC9               OUT SYS_REFCURSOR
      , O_RESULT_CURSOR     OUT SYS_REFCURSOR
    );

    /* 입고예정 조회 */
    PROCEDURE P_SCP0130_GET_SCHEDULED_RECIEPT_INFORMATION
    (
        P_DIVISION_ID       IN  CLOB
      , P_PLAN_GROUP_ID     IN  CLOB
      , P_PLANT_SITE_ID     IN  CLOB
      , P_ITEM_ID_CHILD     IN  CLOB
      , P_VALID_YN          IN  CLOB
      , P_FROM_DATE         IN  CLOB
      , O_RC1               OUT SYS_REFCURSOR
      , O_RESULT_CURSOR     OUT SYS_REFCURSOR
    );

    /* 가상 BOM 조회 */
    PROCEDURE P_SCP0130_GET_VIRTUAL_BOM
    (
        P_DIVISION_ID       IN  CLOB
      , P_PLAN_GROUP_ID     IN  CLOB
      , P_PLANT_SITE_ID     IN  CLOB
      , P_ITEM_ID           IN  CLOB
      , P_ITEM_ID_CHILD     IN  CLOB
      , P_VALID_YN          IN  CLOB
      , P_FROM_DATE         IN  CLOB
      , O_RC1               OUT SYS_REFCURSOR
      , O_RESULT_CURSOR     OUT SYS_REFCURSOR
    );

    /* 입고예정 저장 */
    PROCEDURE P_SCP0130_SAVE_SCHEDULED_RECIEPT_INFORMATION
    (
        P_ACTIVE_FLAG       IN  CLOB
      , P_DIVISION_ID       IN  CLOB
      , P_OPMZ_PLAN_GR_ID   IN  CLOB
      , P_PLANT_SITE_ID     IN  CLOB
      , P_ITEM_ID_CHILD     IN  CLOB
      , P_TO_YYYYMMDD       IN  CLOB
      , P_TO_EXPC_QTY       IN  CLOB
      , P_VALUE_DESCRIPTION IN  CLOB
      , P_VALID_YN          IN  CLOB
      , P_USER_ID           IN  CLOB
      , P_PRE_DIVISION_ID   IN  CLOB
      , P_PRE_OPMZ_PLAN_GR_ID IN CLOB
      , P_PRE_PLANT_SITE_ID IN  CLOB
      , P_PRE_ITEM_ID_CHILD IN  CLOB
      , P_PRE_TO_YYYYMMDD   IN  CLOB
      , O_RC1               OUT SYS_REFCURSOR
      , O_RESULT_CURSOR     OUT SYS_REFCURSOR
    );

    /* 가상 BOM 저장 */
    PROCEDURE P_SCP0130_SVAE_VIRTUAL_BOM
    (
        P_ACTIVE_FLAG       IN  CLOB
      , P_DIVISION_ID       IN  CLOB
      , P_OPMZ_PLAN_GR_ID   IN  CLOB
      , P_PLANT_SITE_ID     IN  CLOB
      , P_ITEM_ID           IN  CLOB
      , P_ITEM_ID_CHILD     IN  CLOB
      , P_TO_YYYYMMDD       IN  CLOB
      , P_TO_EXPC_QTY       IN  CLOB
      , P_VALUE_DESCRIPTION IN  CLOB
      , P_VALID_YN          IN  CLOB
      , P_USER_ID           IN  CLOB
      , P_PRE_DIVISION_ID   IN  CLOB
      , P_PRE_OPMZ_PLAN_GR_ID IN CLOB
      , P_PRE_PLANT_SITE_ID IN  CLOB
      , P_PRE_ITEM_ID       IN  CLOB
      , P_PRE_ITEM_ID_CHILD IN  CLOB
      , O_RC1               OUT SYS_REFCURSOR
      , O_RESULT_CURSOR     OUT SYS_REFCURSOR
    );

END PKG_SCP0130;