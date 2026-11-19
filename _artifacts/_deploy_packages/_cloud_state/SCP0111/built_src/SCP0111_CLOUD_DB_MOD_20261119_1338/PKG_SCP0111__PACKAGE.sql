PACKAGE PKG_SCP0111
IS

    /* ESS 팩 Prod Plan 입력용 Line 정보 조회 */
    PROCEDURE P_SCP0111_GET_ESS_PACK_LINE
    (
        O_RC                    OUT SYS_REFCURSOR,
        O_RESULT_CURSOR         OUT SYS_REFCURSOR
    );

    /* Integration PSI 조회 (월별 PIVOT) */
    PROCEDURE P_SCP0111_GET_INTEGRATION_PSI
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_PLAN_TYPE             IN  VARCHAR2,
        P_SEQ                   IN  VARCHAR2,
        P_FROM_YYYYMM           IN  VARCHAR2,
        P_TO_YYYYMM             IN  VARCHAR2,
        P_NICK_NAME             IN  VARCHAR2,
        P_CELLITEM_ID           IN  VARCHAR2,
        P_ITEM_ID               IN  VARCHAR2,
        P_QTY_YN                IN  VARCHAR2,
        O_RC                    OUT SYS_REFCURSOR,
        O_RESULT_CURSOR         OUT SYS_REFCURSOR
    );

    /* 통합 PSI 월별 수량 수정 (일반 사용자) */
    PROCEDURE P_SCP0111_SAVE_INTEGRATION_PSI
    (
        P_ACTIVE_FLAG           IN  CLOB,
        P_PLAN_TYPE             IN  CLOB,
        P_DIVISION_ID           IN  CLOB,
        P_COMPANY_ID            IN  CLOB,
        P_PLANT_ID              IN  CLOB,
        P_OPERATION_GROUP       IN  CLOB,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_SEQ_FLAG              IN  CLOB,
        P_CELLITEM_ID           IN  CLOB,
        P_ITEM_ID               IN  CLOB,
        P_MEASURE               IN  CLOB,
        P_TO_SITE               IN  CLOB,
        P_LINE_ID               IN  CLOB,
        P_VALUATION_TYPE        IN  CLOB,
        P_TO_PRODUCT            IN  CLOB,
        P_INCOTERMS             IN  CLOB,
        P_YYYYMM                IN  CLOB,
        P_MODIQTY               IN  CLOB,
        P_USER_ID               IN  VARCHAR2,
        O_RESULT_CURSOR         OUT SYS_REFCURSOR
    );

    /* 통합 PSI Admin 사용자 수정/저장 */
    PROCEDURE P_SCP0111_SAVE_PSI_ADMIN
    (
        P_ACTIVE_FLAG           IN  CLOB,
        P_PLAN_TYPE             IN  CLOB,
        P_DIVISION_ID           IN  CLOB,
        P_COMPANY_ID            IN  CLOB,
        P_PLANT_ID              IN  CLOB,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_OPERATION_GROUP       IN  CLOB,
        P_CELLITEM_ID           IN  CLOB,
        P_ITEM_ID               IN  CLOB,
        P_MEASURE               IN  CLOB,
        P_VALUATION_TYPE        IN  CLOB,
        P_TO_PRODUCT            IN  CLOB,
        P_LINE_ID               IN  CLOB,
        P_TO_SITE               IN  CLOB,
        P_INCOTERMS             IN  CLOB,
        P_BOH_QTY               IN  CLOB,
        P_SEQ_FLAG              IN  CLOB,
        P_YYYYMM                IN  CLOB,
        P_MODIQTY               IN  CLOB,
        P_USER_ID               IN  VARCHAR2,
        O_RESULT_CURSOR         OUT SYS_REFCURSOR
    );

END PKG_SCP0111;