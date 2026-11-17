PACKAGE PKG_SCP0104
IS
    /*
     * Program ID   : PKG_SCP0104
     * Description  : SCP0104 CAPA Line Assign 화면 — 계층 조회 · 배정 · 양산시점 · 저장
     * Program History
     *===================================================================================================
     *   Date       In Charge      Description
     *===================================================================================================
     * 2026.09.27   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
     */

    /* CAPA NEW 날짜 타이틀 리턴 (SCP0104, SCP0105, SCP0106, SCP0107, SCP0108 공통) */
    PROCEDURE P_SCP0104_GET_SPREAD_TITLE
    (
        P_FROM_YYYYMM       IN  CLOB
      , P_PROGRAM_ID        IN  CLOB
      , P_SHEET_NAME        IN  CLOB
      , O_RC1               OUT SYS_REFCURSOR
      , O_RESULT_CURSOR     OUT SYS_REFCURSOR
    );

    /* CAPA LINE ASSING — 조립 라인 */
    PROCEDURE P_SCP0104_GET_CAPA_LINE_ASSEMBLY
    (
        P_DIVISION_ID       IN  CLOB
      , P_SITE_ID           IN  CLOB
      , P_PLANT_ID          IN  CLOB
      , P_FACTORY_ID        IN  CLOB
      , P_LINE_ID           IN  CLOB
      , P_PROGRAM_ID        IN  CLOB
      , P_SHEET_NAME        IN  CLOB
      , P_USER_ID           IN  CLOB
      , P_DEBUG_MODE        IN  CLOB
      , O_RC1               OUT SYS_REFCURSOR
      , O_RESULT_CURSOR     OUT SYS_REFCURSOR
    );

    /* CAPA LINE ASSING — 전극 라인 */
    PROCEDURE P_SCP0104_GET_CAPA_LINE_ELTR
    (
        P_DIVISION_ID       IN  CLOB
      , P_SITE_ID           IN  CLOB
      , P_PLANT_ID          IN  CLOB
      , P_FACTORY_ID        IN  CLOB
      , P_LINE_ID           IN  CLOB
      , P_PROGRAM_ID        IN  CLOB
      , P_SHEET_NAME        IN  CLOB
      , P_USER_ID           IN  CLOB
      , P_DEBUG_MODE        IN  CLOB
      , O_RC1               OUT SYS_REFCURSOR
      , O_RESULT_CURSOR     OUT SYS_REFCURSOR
    );


    /* CAPA LINE SOP — 조립 */
    PROCEDURE P_SCP0104_GET_CAPA_LINE_SOP_ASSEMBLY
    (
        P_VERSION           IN  CLOB
      , P_VERSION_SEQ       IN  CLOB
      , P_DIVISION_ID       IN  CLOB
      , P_SITE_ID           IN  CLOB
      , P_PLANT_ID          IN  CLOB
      , P_FACTORY_ID        IN  CLOB
      , P_LINE_ID           IN  CLOB
      , P_OPERATION_ID      IN  CLOB
      , P_ELECTRODE_TYPE    IN  CLOB
      , P_VALID_FLAG        IN  CLOB
      , P_PROGRAM_ID        IN  CLOB
      , P_SHEET_NAME        IN  CLOB
      , P_USER_ID           IN  CLOB
      , P_DEBUG_MODE        IN  CLOB
      , O_RC1               OUT SYS_REFCURSOR
      , O_RESULT_CURSOR     OUT SYS_REFCURSOR
    );

    /* CAPA LINE SOP — 전극 */
    PROCEDURE P_SCP0104_GET_CAPA_LINE_SOP_ELTR
    (
        P_VERSION           IN  CLOB
      , P_VERSION_SEQ       IN  CLOB
      , P_DIVISION_ID       IN  CLOB
      , P_SITE_ID           IN  CLOB
      , P_PLANT_ID          IN  CLOB
      , P_FACTORY_ID        IN  CLOB
      , P_LINE_ID           IN  CLOB
      , P_OPERATION_ID      IN  CLOB
      , P_ELECTRODE_TYPE    IN  CLOB
      , P_VALID_FLAG        IN  CLOB
      , P_PROGRAM_ID        IN  CLOB
      , P_SHEET_NAME        IN  CLOB
      , P_USER_ID           IN  CLOB
      , P_DEBUG_MODE        IN  CLOB
      , O_RC1               OUT SYS_REFCURSOR
      , O_RESULT_CURSOR     OUT SYS_REFCURSOR
    );

    /* Dummy 코드 이름 확인 */
    PROCEDURE P_SCP0104_CHECK_NAME_ON_DUMMY_CODE
    (
        P_CODE_TP           IN  CLOB
      , P_NAME              IN  CLOB
      , P_PROGRAM_ID        IN  CLOB
      , P_SHEET_NAME        IN  CLOB
      , P_USER_ID           IN  CLOB
      , P_DEBUG_MODE        IN  CLOB
      , O_RC1               OUT SYS_REFCURSOR
      , O_RESULT_CURSOR     OUT SYS_REFCURSOR
    );

    /* CAPA 새 버전 추가 */
    PROCEDURE P_SCP0104_ADD_CAPA_NEW_VERSION
    (
        P_DIVISION_ID       IN  CLOB
      , P_PROGRAM_ID        IN  CLOB
      , P_SHEET_NAME        IN  CLOB
      , P_USER_ID           IN  CLOB
      , P_DEBUG_MODE        IN  CLOB
      , O_RC1               OUT SYS_REFCURSOR
      , O_RESULT_CURSOR     OUT SYS_REFCURSOR
    );


    /* CAPA LINE ASSIGN 모델 — 조립 */
    PROCEDURE P_SCP0104_GET_CAPA_LINE_ASSIGN_MDL_ASSEMBLY
    (
        P_VERSION           IN  CLOB
      , P_VERSION_SEQ       IN  CLOB
      , P_DIVISION_ID       IN  CLOB
      , P_SITE_ID           IN  CLOB
      , P_PLANT_ID          IN  CLOB
      , P_FACTORY_ID        IN  CLOB
      , P_LINE_ID           IN  CLOB
      , P_OPERATION_ID      IN  CLOB
      , P_ITEM_ID           IN  CLOB
      , P_ELECTRODE_TYPE    IN  CLOB
      , P_PROGRAM_ID        IN  CLOB
      , P_SHEET_NAME        IN  CLOB
      , P_USER_ID           IN  CLOB
      , P_DEBUG_MODE        IN  CLOB
      , O_RC1               OUT SYS_REFCURSOR
      , O_RESULT_CURSOR     OUT SYS_REFCURSOR
    );

    /* CAPA LINE ASSIGN 모델 — 전극 */
    PROCEDURE P_SCP0104_GET_CAPA_LINE_ASSIGN_MDL_ELTR
    (
        P_VERSION           IN  CLOB
      , P_VERSION_SEQ       IN  CLOB
      , P_DIVISION_ID       IN  CLOB
      , P_SITE_ID           IN  CLOB
      , P_PLANT_ID          IN  CLOB
      , P_FACTORY_ID        IN  CLOB
      , P_LINE_ID           IN  CLOB
      , P_OPERATION_ID      IN  CLOB
      , P_ITEM_ID           IN  CLOB
      , P_ELECTRODE_TYPE    IN  CLOB
      , P_PROGRAM_ID        IN  CLOB
      , P_SHEET_NAME        IN  CLOB
      , P_USER_ID           IN  CLOB
      , P_DEBUG_MODE        IN  CLOB
      , O_RC1               OUT SYS_REFCURSOR
      , O_RESULT_CURSOR     OUT SYS_REFCURSOR
    );


    /* CAPA LINE ASSIGN — 조립 */
    PROCEDURE P_SCP0104_GET_CAPA_LINE_ASSIGN_ASSEMBLY
    (
        P_VERSION           IN  CLOB
      , P_VERSION_SEQ       IN  CLOB
      , P_DIVISION_ID       IN  CLOB
      , P_SITE_ID           IN  CLOB
      , P_PLANT_ID          IN  CLOB
      , P_FACTORY_ID        IN  CLOB
      , P_LINE_ID           IN  CLOB
      , P_OPERATION_ID      IN  CLOB
      , P_ITEM_ID           IN  CLOB
      , P_ELECTRODE_TYPE    IN  CLOB
      , P_VALID_FLAG        IN  CLOB
      , P_PROGRAM_ID        IN  CLOB
      , P_SHEET_NAME        IN  CLOB
      , P_USER_ID           IN  CLOB
      , P_DEBUG_MODE        IN  CLOB
      , O_RC1               OUT SYS_REFCURSOR
      , O_RESULT_CURSOR     OUT SYS_REFCURSOR
    );


    /* CAPA LINE ASSIGN — 전극 */
    PROCEDURE P_SCP0104_GET_CAPA_LINE_ASSIGN_ELTR
    (
        P_VERSION           IN  CLOB
      , P_VERSION_SEQ       IN  CLOB
      , P_DIVISION_ID       IN  CLOB
      , P_SITE_ID           IN  CLOB
      , P_PLANT_ID          IN  CLOB
      , P_FACTORY_ID        IN  CLOB
      , P_LINE_ID           IN  CLOB
      , P_OPERATION_ID      IN  CLOB
      , P_ITEM_ID           IN  CLOB
      , P_ELECTRODE_TYPE    IN  CLOB
      , P_VALID_FLAG        IN  CLOB
      , P_PROGRAM_ID        IN  CLOB
      , P_SHEET_NAME        IN  CLOB
      , P_USER_ID           IN  CLOB
      , P_DEBUG_MODE        IN  CLOB
      , O_RC1               OUT SYS_REFCURSOR
      , O_RESULT_CURSOR     OUT SYS_REFCURSOR
    );


    /* CAPA LINE SOP 저장 — 조립 */
    PROCEDURE P_SCP0104_SAVE_CAPA_LINE_SOP_ASSEMBLY
    (
        P_VERSION           IN  CLOB
      , P_VERSION_SEQ       IN  CLOB
      , P_DIVISION_ID       IN  CLOB
      , P_COMPANY_ID        IN  CLOB
      , P_SITE_ID           IN  CLOB
      , P_PLANT_ID          IN  CLOB
      , P_FACTORY_ID        IN  CLOB
      , P_LINE_ID           IN  CLOB
      , P_OPERATION_ID      IN  CLOB
      , P_ELECTRODE_TYPE    IN  CLOB
      , P_VALID_YN          IN  CLOB
      , P_SOP_DT            IN  CLOB
      , P_PROGRAM_ID        IN  CLOB
      , P_SHEET_NAME        IN  CLOB
      , P_USER_ID           IN  CLOB
      , P_DEBUG_MODE        IN  CLOB
      , O_RC1               OUT SYS_REFCURSOR
      , O_RESULT_CURSOR     OUT SYS_REFCURSOR
    );


    /* CAPA LINE SOP 저장 — 전극 */
    PROCEDURE P_SCP0104_SAVE_CAPA_LINE_SOP_ELTR
    (
        P_VERSION           IN  CLOB
      , P_VERSION_SEQ       IN  CLOB
      , P_DIVISION_ID       IN  CLOB
      , P_COMPANY_ID        IN  CLOB
      , P_SITE_ID           IN  CLOB
      , P_PLANT_ID          IN  CLOB
      , P_FACTORY_ID        IN  CLOB
      , P_LINE_ID           IN  CLOB
      , P_OPERATION_ID      IN  CLOB
      , P_ELECTRODE_TYPE    IN  CLOB
      , P_VALID_YN          IN  CLOB
      , P_SOP_DT            IN  CLOB
      , P_PROGRAM_ID        IN  CLOB
      , P_SHEET_NAME        IN  CLOB
      , P_USER_ID           IN  CLOB
      , P_DEBUG_MODE        IN  CLOB
      , O_RC1               OUT SYS_REFCURSOR
      , O_RESULT_CURSOR     OUT SYS_REFCURSOR
    );


    /* CAPA LINE ASSIGN 저장 — 조립 */
    PROCEDURE P_SCP0104_SAVE_CAPA_LINE_ASSIGN_ASSEMBLY
    (
        P_VERSION               IN  CLOB
      , P_VERSION_SEQ           IN  CLOB
      , P_PROG_STAT             IN  CLOB
      , P_DIVISION_ID           IN  CLOB
      , P_COMPANY_ID            IN  CLOB
      , P_SITE_ID               IN  CLOB
      , P_PLANT_ID              IN  CLOB
      , P_FACTORY_ID            IN  CLOB
      , P_LINE_ID               IN  CLOB
      , P_OPERATION_ID          IN  CLOB
      , P_ELECTRODE_TYPE        IN  CLOB
      , P_SITE_NAME             IN  CLOB
      , P_COMPANY_NAME          IN  CLOB
      , P_PLANT_NAME            IN  CLOB
      , P_FACTORY_NAME          IN  CLOB
      , P_LINE_NAME             IN  CLOB
      , P_VALID_YN              IN  CLOB
      , P_ITEM_ID               IN  CLOB
      , P_NICK_NAME             IN  CLOB
      , P_DATE_COLUMN_NAMES     IN  CLOB
      , P_DATE_COLUMN_VALUES    IN  CLOB
      , P_PROGRAM_ID            IN  CLOB
      , P_SHEET_NAME            IN  CLOB
      , P_USER_ID               IN  CLOB
      , P_DEBUG_MODE            IN  CLOB
      , O_RC1                   OUT SYS_REFCURSOR
      , O_RC2                   OUT SYS_REFCURSOR
    );


    /* CAPA LINE ASSIGN 저장 — 전극 */
    PROCEDURE P_SCP0104_SAVE_CAPA_LINE_ASSIGN_ELTR
    (
        P_VERSION               IN  CLOB
      , P_VERSION_SEQ           IN  CLOB
      , P_PROG_STAT             IN  CLOB
      , P_DIVISION_ID           IN  CLOB
      , P_COMPANY_ID            IN  CLOB
      , P_SITE_ID               IN  CLOB
      , P_PLANT_ID              IN  CLOB
      , P_FACTORY_ID            IN  CLOB
      , P_LINE_ID               IN  CLOB
      , P_OPERATION_ID          IN  CLOB
      , P_ELECTRODE_TYPE        IN  CLOB
      , P_SITE_NAME             IN  CLOB
      , P_COMPANY_NAME          IN  CLOB
      , P_PLANT_NAME            IN  CLOB
      , P_FACTORY_NAME          IN  CLOB
      , P_LINE_NAME             IN  CLOB
      , P_LANE_QTY              IN  CLOB
      , P_VALID_YN              IN  CLOB
      , P_ITEM_ID               IN  CLOB
      , P_NICK_NAME             IN  CLOB
      , P_DATE_COLUMN_NAMES     IN  CLOB
      , P_DATE_COLUMN_VALUES    IN  CLOB
      , P_PROGRAM_ID            IN  CLOB
      , P_SHEET_NAME            IN  CLOB
      , P_USER_ID               IN  CLOB
      , P_DEBUG_MODE            IN  CLOB
      , O_RC1                   OUT SYS_REFCURSOR
      , O_RC2                   OUT SYS_REFCURSOR
    );

END PKG_SCP0104;