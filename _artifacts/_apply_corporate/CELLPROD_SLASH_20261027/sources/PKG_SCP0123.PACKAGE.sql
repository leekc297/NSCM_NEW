PACKAGE PKG_SCP0123
IS
    /*
     * Package ID   : PKG_SCP0123
     * Description  : SCP0123 Plan Control
     * Program History
     *===================================================================================================
     *   Date       In Charge      Description
     *===================================================================================================
     * 2026/09/17   AJS            MSSQL -> Oracle 전환
     *                             AS-IS SCP0123_GET_PLAN_ID_CREATE_INFO  -> P_SCP0123_GET_PLAN_ID_INFO   (이름 30자 초과)
     *                             AS-IS SCP0123_SAVE_PLAN_CTRL_ACTV_RUN  -> P_SCP0123_SAVE_PLAN_ACTV_RUN (이름 30자 초과)
     */

    /* Plan Control 정보 조회 (AS-IS SCP0123_GET_PLAN_CONTROL) */
    PROCEDURE P_SCP0123_GET_PLAN_CONTROL
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_PLAN_GROUP_ID         IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_ACTV_CD               IN  VARCHAR2 DEFAULT NULL,
        P_PLAN_ID               IN  VARCHAR2 DEFAULT NULL,
        O_RC1                   OUT SYS_REFCURSOR,   /* Plan ID 미전달 : Activity 목록 · 전달 : Activity 실행 상태 */
        O_RESULT_CODE           OUT VARCHAR2,        /* S : 정상 · F : 오류 */
        O_RESULT_MSG            OUT VARCHAR2
    );

    /* Engine Run Status 정보 조회 (AS-IS SCP0123_GET_PLAN_ENGINE_RUN) */
    PROCEDURE P_SCP0123_GET_PLAN_ENGINE_RUN
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_PLAN_GROUP_ID         IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_ACTV_CD               IN  VARCHAR2,
        P_PLAN_ID               IN  VARCHAR2,
        O_RC1                   OUT SYS_REFCURSOR,   /* 엔진 진행 단계별 상태 */
        O_RESULT_CODE           OUT VARCHAR2,
        O_RESULT_MSG            OUT VARCHAR2
    );

    /* Plan ID 생성 팝업 초기 정보 조회 (AS-IS SCP0123_GET_PLAN_ID_CREATE_INFO) */
    PROCEDURE P_SCP0123_GET_PLAN_ID_INFO
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_PLAN_GROUP_ID         IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_PLAN_ID               IN  VARCHAR2,
        O_RC1                   OUT SYS_REFCURSOR,   /* Table[0] : Horizon End 일자 · Demand Version */
        O_RC2                   OUT SYS_REFCURSOR,   /* Table[1] : 공정군별 Frozen 일자 */
        O_RC3                   OUT SYS_REFCURSOR,   /* Table[2] : FP · SSP 참조 계획 목록 */
        O_RC4                   OUT SYS_REFCURSOR,   /* Table[3] : SCP 참조 계획 목록 */
        O_RC5                   OUT SYS_REFCURSOR,   /* Table[4] : 선택한 Plan ID 정보 */
        O_RESULT_CODE           OUT VARCHAR2,
        O_RESULT_MSG            OUT VARCHAR2
    );

    /* Activity 실행 등록 (AS-IS SCP0123_SAVE_PLAN_CTRL_ACTV_RUN) */
    PROCEDURE P_SCP0123_SAVE_PLAN_ACTV_RUN
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_PRS_CD                IN  VARCHAR2,
        P_PLAN_GR_ID            IN  VARCHAR2,
        P_ACTV_CD               IN  VARCHAR2,
        P_PLAN_ID               IN  VARCHAR2,
        P_USER_ID               IN  VARCHAR2,
        O_RESULT_CODE           OUT VARCHAR2,        /* S : 정상 · F : 오류 */
        O_RESULT_CNT            OUT NUMBER,          /* 처리 건수 (AS-IS result_cnt) */
        O_RESULT_MSG            OUT VARCHAR2
    );

    /* Plan ID 등록 (AS-IS SCP0123_SAVE_PLAN_ID_CREATE) */
    PROCEDURE P_SCP0123_SAVE_PLAN_ID_CREATE
    (
        P_DIVISION_ID                   IN  VARCHAR2,
        P_PLAN_GR_ID                    IN  VARCHAR2,
        P_PLAN_GR_NAME                  IN  VARCHAR2,
        P_PRS_CD                        IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD           IN  VARCHAR2,
        P_PLAN_END_YYYYMMDD             IN  VARCHAR2,
        P_DMD_VER_ID                    IN  VARCHAR2,
        P_PROD_REF_SYS_DIVS_CD          IN  VARCHAR2,
        P_PROD_REF_SYS_PLAN_ID          IN  VARCHAR2,
        P_PROD_FRZ_START_YYYYMMDD       IN  VARCHAR2,
        P_PROD_FRZ_END_YYYYMMDD         IN  VARCHAR2,
        P_CELL_PROD_FRZ_START_YYYYMMDD  IN  VARCHAR2,
        P_CELL_PROD_FRZ_END_YYYYMMDD    IN  VARCHAR2,
        P_SHIP_REF_SYS_DIVS_CD          IN  VARCHAR2,
        P_SHIP_REF_SYS_PLAN_ID          IN  VARCHAR2,
        P_SHIP_FRZ_START_YYYYMMDD       IN  VARCHAR2,
        P_SHIP_FRZ_END_YYYYMMDD         IN  VARCHAR2,
        P_PRAM_TY_CD                    IN  VARCHAR2,
        P_PLAN_DESC                     IN  VARCHAR2,
        P_PROD_NO_FRZ_YN                IN  VARCHAR2,
        P_CELL_NO_FRZ_YN                IN  VARCHAR2,
        P_SHIP_NO_FRZ_YN                IN  VARCHAR2,
        P_USER_ID                       IN  VARCHAR2,
        O_RESULT_CODE                   OUT VARCHAR2,
        O_RESULT_CNT                    OUT NUMBER,
        O_RESULT_MSG                    OUT VARCHAR2
    );

END PKG_SCP0123;