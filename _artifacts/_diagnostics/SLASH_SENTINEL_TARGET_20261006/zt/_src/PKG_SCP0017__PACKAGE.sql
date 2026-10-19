PACKAGE PKG_SCP0017
IS
/*
 * Program ID   : PKG_SCP0017
 * Description  : SCP0017 Waterfall Production Plan
 * Program History
 *===================================================================================================
 * Date         In Charge       Description
 *===================================================================================================
 * 2026.09.26   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
 */

    /* AS-IS SCP0017_GET_PRODUCTION_PLAN_MODEL_WATERFALL */
    PROCEDURE P_SCP0017_GET_PRODUCTION_PLAN_MODEL_WATERFALL
    (
        P_DIVISION_ID           IN  VARCHAR2
      , P_OPERATION_GROUP       IN  VARCHAR2
      , P_SCM_SITE_ID           IN  VARCHAR2
      , P_MODEL_ID              IN  VARCHAR2
      , P_ITEM_ID               IN  VARCHAR2
      , P_FROM_YYYYMMDD         IN  VARCHAR2
      , P_TO_YYYYMMDD           IN  VARCHAR2
      , P_VERSION_NO            IN  VARCHAR2
      , P_PROGRAM_ID            IN  VARCHAR2
      , P_SHEET_NAME            IN  VARCHAR2
      , P_USER_ID               IN  VARCHAR2
      , P_ELECTRODE_TYPE        IN  VARCHAR2
      , P_NICK_NAME             IN  VARCHAR2
      , P_GAP                   IN  VARCHAR2
      , P_LINE_ID               IN  VARCHAR2
      , DEBUG_MODE              IN  VARCHAR2
      , O_RC1                   OUT SYS_REFCURSOR
      , O_RESULT_CURSOR         OUT SYS_REFCURSOR
    );

    /* AS-IS SCP0017_GET_PRODUCTION_PLAN_LINE_WATERFALL */
    PROCEDURE P_SCP0017_GET_PRODUCTION_PLAN_LINE_WATERFALL
    (
        P_DIVISION_ID           IN  VARCHAR2
      , P_OPERATION_GROUP       IN  VARCHAR2
      , P_SCM_SITE_ID           IN  VARCHAR2
      , P_ITEM_ID               IN  VARCHAR2
      , P_FROM_YYYYMMDD         IN  VARCHAR2
      , P_TO_YYYYMMDD           IN  VARCHAR2
      , P_VERSION_NO            IN  VARCHAR2
      , P_PROGRAM_ID            IN  VARCHAR2
      , P_SHEET_NAME            IN  VARCHAR2
      , P_USER_ID               IN  VARCHAR2
      , P_ELECTRODE_TYPE        IN  VARCHAR2
      , DEBUG_MODE              IN  VARCHAR2
      , O_RC1                   OUT SYS_REFCURSOR
      , O_RESULT_CURSOR         OUT SYS_REFCURSOR
    );

    /* 화면 머리글 달력 (공용 PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN 과 같은 내용) */
    PROCEDURE P_SCP0017_GET_SHEET_CALENDAR_3SPAN
    (
        P_START_YYYYMMDD        IN  VARCHAR2
      , P_END_YYYYMMDD          IN  VARCHAR2
      , O_RC1                   OUT SYS_REFCURSOR
      , O_RESULT_CURSOR         OUT SYS_REFCURSOR
    );

END PKG_SCP0017;