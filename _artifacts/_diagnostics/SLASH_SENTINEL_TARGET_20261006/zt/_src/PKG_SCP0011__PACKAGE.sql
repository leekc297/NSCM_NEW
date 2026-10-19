PACKAGE PKG_SCP0011
IS
    /*
     * Package ID   : PKG_SCP0011
     * Description  : SCP0011 Production Plan
     * Program History
     *===================================================================================================
     *   Date       In Charge      Description
     *===================================================================================================
     * 2026.09.17                  [MSSQL -> Oracle 전환] 화면 전용 조회 4건 편입
     * 2026.09.18                  [MSSQL -> Oracle 전환] 화면 전용 재계산 PR_SCP_ANL_PRODUCTION_PLAN_I_AMEND 편입
     *
     * 공용으로 판정하여 이 패키지에 넣지 않은 것 (PKG_COM0000 편입)
     *   - SCP0011_GET_LAST_PLAN_VERSION        → PKG_COM0000.P_SCP0011_GET_LAST_PLAN_VER
     *   - SCP0011_SAVE_PRODUCTION_PLAN_LINE    → PKG_COM0000.P_SCP0011_SAVE_PROD_PLAN_LINE (SCP0011 · SCP0013 공용)
     *   - SCP0009_GET_SHEET_CALENDAR_3SPAN     → PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN
     */

    /* Production Plan MODEL QTY 조회 (AS-IS SCP0011_GET_PRODUCTION_PLAN_MODEL) */
    PROCEDURE P_SCP0011_GET_PROD_PLAN_MODEL
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_OPERATION_GROUP       IN  VARCHAR2,
        P_SCM_SITE_ID           IN  VARCHAR2,
        P_MODEL_ID              IN  VARCHAR2,
        P_ITEM_ID               IN  VARCHAR2,
        P_FROM_YYYYMMDD         IN  VARCHAR2,
        P_TO_YYYYMMDD           IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_PLAN_TYPE             IN  VARCHAR2,
        P_SEQ                   IN  VARCHAR2,
        P_PROGRAM_ID            IN  VARCHAR2 DEFAULT 'SCP0011',
        P_SHEET_NAME            IN  VARCHAR2 DEFAULT 'MODEL',
        P_USER_ID               IN  VARCHAR2,
        P_ELECTRODE_TYPE        IN  VARCHAR2 DEFAULT NULL,
        P_NICK_NAME             IN  VARCHAR2 DEFAULT NULL,
        P_BUCKET                IN  VARCHAR2 DEFAULT NULL,
        P_TO_PERIOD             IN  VARCHAR2 DEFAULT NULL,
        P_CHK_ALL               IN  VARCHAR2 DEFAULT NULL,   /* Y : bucket='DAILY' 조회 */
        P_DEBUG_MODE            IN  VARCHAR2 DEFAULT 'F',
        O_RC1                   OUT SYS_REFCURSOR,           /* 조회 결과 (기간 칸 이름 W_ · M_ · D_) */
        O_RESULT_CODE           OUT VARCHAR2,                /* S : 정상 · F : 오류 */
        O_RESULT_MSG            OUT VARCHAR2
    );

    /* Production Plan MODEL 머리 행 조회 (AS-IS SCP0011_GET_PRODUCTION_PLAN_MODEL_TITLE_PARAL) */
    PROCEDURE P_SCP0011_GET_PROD_MODEL_TITLE
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_OPERATION_GROUP       IN  VARCHAR2,
        P_SCM_SITE_ID           IN  VARCHAR2,
        P_MODEL_ID              IN  VARCHAR2,
        P_ITEM_ID               IN  VARCHAR2,
        P_FROM_YYYYMMDD         IN  VARCHAR2,
        P_TO_YYYYMMDD           IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_PLAN_TYPE             IN  VARCHAR2,
        P_SEQ                   IN  VARCHAR2,
        P_PROGRAM_ID            IN  VARCHAR2 DEFAULT 'SCP0011',
        P_SHEET_NAME            IN  VARCHAR2 DEFAULT 'MODEL',
        P_USER_ID               IN  VARCHAR2,
        P_ELECTRODE_TYPE        IN  VARCHAR2 DEFAULT NULL,
        P_NICK_NAME             IN  VARCHAR2 DEFAULT NULL,
        P_BUCKET                IN  VARCHAR2 DEFAULT NULL,
        P_CHK_ALL               IN  VARCHAR2 DEFAULT NULL,   /* Y : bucket='DAILY' 조회 */
        P_DEBUG_MODE            IN  VARCHAR2 DEFAULT 'F',
        O_RC1                   OUT SYS_REFCURSOR,           /* 조회 결과 (기간 칸 값은 모두 '0') */
        O_RESULT_CODE           OUT VARCHAR2,
        O_RESULT_MSG            OUT VARCHAR2
    );

    /* Production Plan Line Header 조회 (AS-IS SCP0011_GET_PRODUCTION_PLAN_LINE) */
    PROCEDURE P_SCP0011_GET_PROD_PLAN_LINE
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_OPERATION_GROUP       IN  VARCHAR2,
        P_SCM_SITE_ID           IN  VARCHAR2,
        P_ITEM_ID               IN  VARCHAR2,
        P_FROM_YYYYMMDD         IN  VARCHAR2,
        P_TO_YYYYMMDD           IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_PLAN_TYPE             IN  VARCHAR2,
        P_SEQ                   IN  VARCHAR2,
        P_PROGRAM_ID            IN  VARCHAR2 DEFAULT 'SCP0011',
        P_SHEET_NAME            IN  VARCHAR2 DEFAULT 'LINE',
        P_USER_ID               IN  VARCHAR2,
        P_ELECTRODE_TYPE        IN  VARCHAR2 DEFAULT NULL,
        P_DEBUG_MODE            IN  VARCHAR2 DEFAULT 'F',
        O_RC1                   OUT SYS_REFCURSOR,           /* 조회 결과 (기간 칸 이름 W_ · M_ · D_) */
        O_RESULT_CODE           OUT VARCHAR2,
        O_RESULT_MSG            OUT VARCHAR2
    );

    /* PLAN 별 편집가능 여부 정보 조회 (AS-IS SCP0011_GET_PLAN_EDIT_INFO) */
    PROCEDURE P_SCP0011_GET_PLAN_EDIT_INFO
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_SCM_SITE_ID           IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_PLAN_TYPE             IN  VARCHAR2,
        P_SEQ                   IN  VARCHAR2,
        P_ORIGIN_DIVISION_ID    IN  VARCHAR2 DEFAULT NULL,
        P_DEBUG_MODE            IN  VARCHAR2 DEFAULT 'F',
        O_RC1                   OUT SYS_REFCURSOR,
        O_RESULT_CODE           OUT VARCHAR2,
        O_RESULT_MSG            OUT VARCHAR2
    );

    /* Target-Plan(Amend) 재계산 - 재고(ONHAND_EOH) = 생산계획(Amend) 누적 - 요구량 누적 (AS-IS PR_SCP_ANL_PRODUCTION_PLAN_I_AMEND) */
    PROCEDURE P_SCP_ANL_PROD_PLAN_I_AMEND
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_PLAN_TYPE             IN  VARCHAR2,
        P_SEQ                   IN  VARCHAR2,
        P_OPERATION_GROUP       IN  VARCHAR2,
        P_USER_ID               IN  VARCHAR2 DEFAULT 'scp_batch',
        O_RC1                   OUT SYS_REFCURSOR,           /* RESULT_CODE (S / F) */
        O_RESULT_CODE           OUT VARCHAR2,
        O_RESULT_MSG            OUT VARCHAR2
    );

END PKG_SCP0011;