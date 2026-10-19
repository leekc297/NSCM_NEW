PACKAGE PKG_SCP0013
IS

    /* Combo) Line List */
    PROCEDURE P_SCP0013_GET_LINE_LIST
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_OPERATION_GROUP       IN  VARCHAR2,
        P_PLANT_SITE            IN  VARCHAR2,
        P_CELL_TYPE_GR          IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        O_RC1                   OUT SYS_REFCURSOR
    );

    /* new - popup 용도 */
    PROCEDURE P_SCP0013_GET_NEW_POPUP_INFO
    (
        P_CODE                  IN  VARCHAR2,
        P_PARAM1                IN  VARCHAR2,
        P_PARAM2                IN  VARCHAR2,
        P_PARAM3                IN  VARCHAR2,
        P_PARAM4                IN  VARCHAR2,
        P_PARAM5                IN  VARCHAR2,
        O_RC1                   OUT SYS_REFCURSOR
    );

    /* PLAN 별 편집가능 여부 정보 조회 */
    PROCEDURE P_SCP0013_GET_PLAN_EDIT_INFO
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_OPERATION_GROUP       IN  VARCHAR2,
        P_SCM_SITE_ID           IN  VARCHAR2,
        P_LINE_ID               IN  VARCHAR2,
        P_ITEM_ID               IN  VARCHAR2,
        P_FROM_YYYYMMDD         IN  VARCHAR2,
        P_TO_YYYYMMDD           IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_PLAN_TYPE             IN  VARCHAR2,
        P_SEQ                   IN  VARCHAR2,
        P_DEBUG_MODE            IN  VARCHAR2 DEFAULT 'F',
        O_RC1                   OUT SYS_REFCURSOR
    );

    /* PLAN 별 저장가능 여부 정보 조회 */
    PROCEDURE P_SCP0013_GET_PLAN_SAVE_YN
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_START_YYYYMMDD        IN  VARCHAR2,
        P_PLAN_TYPE             IN  VARCHAR2,
        O_RC1                   OUT SYS_REFCURSOR
    );

    /* Production Plan Line New 입력 Validation 체크 */
    PROCEDURE P_SCP0013_GET_LINE_NEW_CHECK
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_PLAN_DATE             IN  VARCHAR2,
        P_PLAN_TYPE             IN  VARCHAR2,
        P_SEQ                   IN  VARCHAR2,
        P_ITEM_ID               IN  VARCHAR2,
        P_LINE_ID               IN  VARCHAR2,
        P_OPERATION_GROUP       IN  VARCHAR2,
        P_SCM_SITE_ID           IN  VARCHAR2,
        P_ORIGIN_DIVISION_ID    IN  VARCHAR2,
        O_RC1                   OUT SYS_REFCURSOR
    );

    /* Production Plan Line 별 조회 (결과셋 4벌) */
    PROCEDURE P_SCP0013_GET_PROD_PLAN_LINEBY
    (
        P_DIVISION_ID           IN  VARCHAR2 DEFAULT '',
        P_OPERATION_GROUP       IN  VARCHAR2 DEFAULT '',
        P_SCM_SITE_ID           IN  VARCHAR2 DEFAULT '',
        P_LINE_ID               IN  VARCHAR2 DEFAULT '',
        P_MODEL_ID              IN  VARCHAR2 DEFAULT '',
        P_ITEM_ID               IN  VARCHAR2 DEFAULT '',
        P_FROM_YYYYMMDD         IN  VARCHAR2 DEFAULT '',
        P_TO_YYYYMMDD           IN  VARCHAR2 DEFAULT '',
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2 DEFAULT '',
        P_PLAN_TYPE             IN  VARCHAR2 DEFAULT '',
        P_SEQ                   IN  VARCHAR2 DEFAULT '',
        P_PROGRAM_ID            IN  VARCHAR2 DEFAULT 'SCP0013',
        P_SHEET_NAME            IN  VARCHAR2 DEFAULT 'LINE',
        P_USER_ID               IN  VARCHAR2 DEFAULT '',
        P_ELECTRODE_TYPE        IN  VARCHAR2 DEFAULT '',
        P_NICK_NAME             IN  VARCHAR2 DEFAULT '',
        P_CELL_TYPE_GR          IN  VARCHAR2 DEFAULT '',
        P_LINE_ASSIGN           IN  VARCHAR2 DEFAULT 'N',
        P_BUCKET                IN  VARCHAR2 DEFAULT '',
        P_CHK_ALL               IN  VARCHAR2 DEFAULT '',
        P_EXTRA_SPEC            IN  VARCHAR2 DEFAULT '',
        P_DEBUG_MODE            IN  VARCHAR2 DEFAULT 'F',
        O_RC1                   OUT SYS_REFCURSOR,
        O_RC2                   OUT SYS_REFCURSOR,
        O_RC3                   OUT SYS_REFCURSOR,
        O_RC4                   OUT SYS_REFCURSOR
    );

    /* 각 라인/동별 부하율 팝업 */
    PROCEDURE P_SCP0013_LINE_LOAD_POPUP
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_OPERATION_GROUP       IN  VARCHAR2,
        P_SCM_SITE_ID           IN  VARCHAR2,
        P_LINE_ID               IN  VARCHAR2,
        P_FROM_YYYYMMDD         IN  VARCHAR2,
        P_TO_YYYYMMDD           IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_PLAN_TYPE             IN  VARCHAR2,
        P_SEQ                   IN  VARCHAR2,
        P_DEBUG_MODE            IN  VARCHAR2 DEFAULT 'F',
        O_RC1                   OUT SYS_REFCURSOR
    );

    /* PRODUCTION PLAN LINE 저장 (New 입력 팝업) */
    PROCEDURE P_SCP0013_SAVE_LINE_POPUP
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_PLAN_DATE             IN  VARCHAR2,
        P_PLAN_TYPE             IN  VARCHAR2,
        P_SEQ                   IN  VARCHAR2,
        P_ITEM_ID               IN  VARCHAR2,
        P_LINE_ID               IN  VARCHAR2,
        P_OPERATION_GROUP       IN  VARCHAR2 DEFAULT '',
        P_SCM_SITE_ID           IN  VARCHAR2 DEFAULT '',
        P_USER_ID               IN  VARCHAR2,
        P_ORIGIN_DIVISION_ID    IN  VARCHAR2,
        O_RC1                   OUT SYS_REFCURSOR
    );

    /* Prod. Plan(Amend) Measure 저장 (ROW 단위) */
    PROCEDURE P_SCP0013_SAVE_LINE_ROW
    (
        P_ACTIVE_FLAG           IN  VARCHAR2,
        P_DIVISION_ID           IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_PLAN_TYPE             IN  VARCHAR2,
        P_SEQ                   IN  VARCHAR2,
        P_OPERATION_GROUP       IN  VARCHAR2,
        P_SCM_SITE_ID           IN  VARCHAR2,
        P_ITEM_ID               IN  VARCHAR2,
        P_LINE_ID               IN  VARCHAR2,
        P_OPERATION_ID          IN  VARCHAR2,
        P_MEASURE               IN  VARCHAR2,
        P_ORIGIN_DIVISION_ID    IN  VARCHAR2,
        P_ELECTRODE_TYPE        IN  VARCHAR2,
        P_YYYYMMDD              IN  VARCHAR2,
        P_QTY                   IN  VARCHAR2,
        P_USER_ID               IN  VARCHAR2,
        P_FIX                   IN  VARCHAR2,
        P_LOC_FLAG              IN  VARCHAR2,
        P_PROGRAM_ID            IN  VARCHAR2 DEFAULT 'SCP0013',
        P_DEBUG_MODE            IN  VARCHAR2 DEFAULT 'F',
        O_RC1                   OUT SYS_REFCURSOR,
        O_RC2                   OUT SYS_REFCURSOR
    );

    /* Prod. Plan(Amend) Measure 저장 (Type Table 방식) */
    PROCEDURE P_SCP0013_SAVE_LINE_ROW_DS
    (
        P_SCP0013               IN  T_SCP0013_TAB,
        O_RC1                   OUT SYS_REFCURSOR,
        O_RC2                   OUT SYS_REFCURSOR
    );

    /* 2026.09.17 AJS - P_SCP0013_SAVE_LINE_ROW_DS 의 JSON 입력 창구 (화면 서버는 형식 테이블 인자를 넘기지 못함) */
    PROCEDURE P_SCP0013_SAVE_LINE_ROW_JSON
    (
        P_DATA                  IN  CLOB,
        P_USER_ID               IN  VARCHAR2,
        O_RESULT_CODE           OUT VARCHAR2,
        O_RESULT_CNT            OUT NUMBER,
        O_RESULT_MSG            OUT VARCHAR2
    );

    -- 2026.09.17 AJS Extra Spec 조회조건 목록 추가 (START)
    /* Extra Spec 조회조건 목록 (AS-IS SCP0013_GET_EXTRA_SPEC) */
    PROCEDURE P_SCP0013_GET_EXTRA_SPEC
    (
        P_DIVISION_ID           IN  VARCHAR2,
        O_RC1                   OUT SYS_REFCURSOR
    );
    -- 2026.09.17 AJS Extra Spec 조회조건 목록 추가 (END)

    /* ---------- 공통 이력 저장 (AS-IS PR_SCP_ANL_PRODUCTION_PLAN_* 대응) ---------- */
    PROCEDURE P_SCP_PROD_PLAN_HIST
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_PLAN_TYPE             IN  VARCHAR2,
        P_SEQ                   IN  VARCHAR2,
        P_OPERATION_GROUP       IN  VARCHAR2,
        P_SCM_SITE_ID           IN  VARCHAR2,
        P_ITEM_ID               IN  VARCHAR2,
        P_LINE_ID               IN  VARCHAR2,
        P_OPERATION_ID          IN  VARCHAR2,
        P_MEASURE               IN  VARCHAR2,
        P_YYYYMMDD              IN  VARCHAR2,
        P_QTY                   IN  VARCHAR2,
        P_CREATED_BY            IN  VARCHAR2,
        P_CREATION_DATE         IN  DATE,
        P_LAST_UPDATED_BY       IN  VARCHAR2,
        P_ORIGIN_DIVISION_ID    IN  VARCHAR2,
        P_ELECTRODE_TYPE        IN  VARCHAR2
    );

    PROCEDURE P_SCP_PROD_PLAN_FIX_HIST
    (
        P_FIX_ID                IN  VARCHAR2,
        P_DIVISION_ID           IN  VARCHAR2,
        P_OPERATION_GROUP       IN  VARCHAR2,
        P_SCM_SITE_ID           IN  VARCHAR2,
        P_ITEM_ID               IN  VARCHAR2,
        P_LINE_ID               IN  VARCHAR2,
        P_OPERATION_ID          IN  VARCHAR2,
        P_YYYYMMDD              IN  VARCHAR2,
        P_QTY                   IN  VARCHAR2,
        P_FIX_REASON            IN  VARCHAR2,
        P_CREATED_BY            IN  VARCHAR2,
        P_CREATION_DATE         IN  DATE,
        P_LAST_UPDATED_BY       IN  VARCHAR2,
        P_ORIGIN_DIVISION_ID    IN  VARCHAR2 DEFAULT '',
        P_ELECTRODE_TYPE        IN  VARCHAR2 DEFAULT ''
    );

    PROCEDURE P_SCP_PROD_PLAN_HIST_DS;

    PROCEDURE P_SCP_PROD_PLAN_FIX_HIST_DS;

END PKG_SCP0013;