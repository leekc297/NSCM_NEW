PACKAGE PKG_SCP0055
IS
    /*
     * Program ID   : PKG_SCP0055
     * Description  : SCP0055 Shipment(Allo) Report 화면 — 팀별 출하 계획 · 실적 조회, 메모 조회 · 저장
     * Program History
     *===================================================================================================
     *   Date       In Charge      Description
     *===================================================================================================
     * 2026.09.26   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
     */

    /* 팀별 출하 계획 · 실적 조회 (결과 네 묶음) */
    PROCEDURE P_SCP0055_GET_SHIPMENT_ALLO_PLAN
    (
        P_FROM_YYYYMMDD         IN  CLOB
      , P_TO_YYYYMMDD           IN  CLOB
      , P_DIVISION_ID           IN  CLOB
      , P_BIZ_TYPE              IN  CLOB
      , P_ITEM_ID               IN  CLOB
      , P_CELL_TYPE_GR          IN  CLOB
      , P_PLAN_START_YYYYMMDD   IN  CLOB
      , P_FROMSITE              IN  CLOB
      , P_TEAM_ID               IN  CLOB
      , P_NICKNAME              IN  CLOB
      , P_PROGRAM_ID            IN  CLOB
      , P_SHEET_NAME            IN  CLOB
      , P_USER_ID               IN  CLOB
      , P_FCST_YN               IN  CLOB
      , O_RC1                   OUT SYS_REFCURSOR
      , O_RC2                   OUT SYS_REFCURSOR
      , O_RC3                   OUT SYS_REFCURSOR
      , O_RC4                   OUT SYS_REFCURSOR
      , O_RESULT_CURSOR         OUT SYS_REFCURSOR
    );

    /* 메모 조회 */
    PROCEDURE P_SCP0055_GET_SHIPMENT_ALLO_NOTE
    (
        P_SITE_ID               IN  CLOB
      , P_DEPT_ID               IN  CLOB
      , P_NICK_NAME             IN  CLOB
      , P_PLAN_DATE             IN  CLOB
      , P_GAP_DATE              IN  CLOB
      , P_USER_ID               IN  CLOB
      , O_RC1                   OUT SYS_REFCURSOR
      , O_RESULT_CURSOR         OUT SYS_REFCURSOR
    );

    /* 메모 저장 */
    PROCEDURE P_SCP0055_SAVE_SHIPMENT_ALLO_PLAN
    (
        P_SITE_ID               IN  CLOB
      , P_NICK_NAME             IN  CLOB
      , P_DEPT_ID               IN  CLOB
      , P_PLAN_DATE             IN  CLOB
      , P_GAP_DATE              IN  CLOB
      , P_NOTE                  IN  CLOB
      , P_PROGRAM_ID            IN  CLOB
      , P_USER_ID               IN  CLOB
      , O_RC1                   OUT SYS_REFCURSOR
      , O_RESULT_CURSOR         OUT SYS_REFCURSOR
    );

END PKG_SCP0055;