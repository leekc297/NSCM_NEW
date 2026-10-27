PACKAGE PKG_SCP0125
IS
    /*
     * Package ID   : PKG_SCP0125
     * Description  : SCP0125 Workbench
     *                MKT FCST · Stock · Stock(Elec.) · Elec. Demand · Stock(2nd OCV) 조정 조회 · 저장
     * Program History
     *===================================================================================================
     *   Date       In Charge      Description
     *===================================================================================================
     * 2026/09/17   AJS            MSSQL -> Oracle 전환 (AS-IS 프로시저 12 개 편입)
     *
     * 반환 규약
     *   조회 : O_RC1 ~ O_RCn (결과 커서) · O_RESULT_CODE (S : 성공 · F : 실패) · O_RESULT_MSG
     *   저장 : O_RESULT_CODE · O_RESULT_CNT (AS-IS result_cnt) · O_RESULT_MSG (AS-IS 두 번째 결과셋 문구)
     *   저장 인자는 AS-IS 와 같이 행 값을 ^ 로 이어 붙인 문자열이다.
     */

    /* Workbench 조회조건 및 콤보박스 정보 (AS-IS SCP0125_GET_SEARCH_INFO) */
    PROCEDURE P_SCP0125_GET_SEARCH_INFO
    (
        O_RC1                   OUT SYS_REFCURSOR,   /* MKT FCST Version */
        O_RC2                   OUT SYS_REFCURSOR,   /* Sales Site */
        O_RC3                   OUT SYS_REFCURSOR,   /* Plant Site */
        O_RC4                   OUT SYS_REFCURSOR,   /* 재고 SCM Site */
        O_RC5                   OUT SYS_REFCURSOR,   /* Item (Validation 체크용) */
        O_RC6                   OUT SYS_REFCURSOR,   /* Project Code (Validation 체크용) */
        O_RC7                   OUT SYS_REFCURSOR,   /* 소형 Project Code (Validation 체크용) */
        O_RC8                   OUT SYS_REFCURSOR,   /* Location Code */
        O_RC9                   OUT SYS_REFCURSOR,   /* Line */
        O_RESULT_CODE           OUT VARCHAR2,
        O_RESULT_MSG            OUT VARCHAR2
    );

    /* MKT FCST 조회 (AS-IS SCP0125_GET_MKT_FCST_ADJ) */
    PROCEDURE P_SCP0125_GET_MKT_FCST_ADJ
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_VERSION_NO            IN  VARCHAR2,
        P_NICK_NAME             IN  VARCHAR2,
        P_ITEM_ID               IN  VARCHAR2,
        O_RC1                   OUT SYS_REFCURSOR,
        O_RESULT_CODE           OUT VARCHAR2,
        O_RESULT_MSG            OUT VARCHAR2
    );

    /* Elec. Demand 조회 (AS-IS SCP0125_GET_MKT_FCST_ELEC_DEMAND) */
    PROCEDURE P_SCP0125_GET_ELEC_DEMAND
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_VERSION_NO            IN  VARCHAR2,
        P_NICK_NAME             IN  VARCHAR2,
        P_ITEM_ID               IN  VARCHAR2,
        O_RC1                   OUT SYS_REFCURSOR,
        O_RESULT_CODE           OUT VARCHAR2,
        O_RESULT_MSG            OUT VARCHAR2
    );

    /* Stock 조회 - 81_UC 외 사업부 (AS-IS SCP0125_GET_STOCK_ADJ) */
    PROCEDURE P_SCP0125_GET_STOCK_ADJ
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_VERSION_NO            IN  VARCHAR2,
        P_NICK_NAME             IN  VARCHAR2,
        P_ITEM_ID               IN  VARCHAR2,
        O_RC1                   OUT SYS_REFCURSOR,
        O_RESULT_CODE           OUT VARCHAR2,
        O_RESULT_MSG            OUT VARCHAR2
    );

    /* Stock 조회 - 81_UC 사업부 (AS-IS SCP0125_GET_STOCK_ADJ_UC) */
    PROCEDURE P_SCP0125_GET_STOCK_ADJ_UC
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_VERSION_NO            IN  VARCHAR2,
        P_NICK_NAME             IN  VARCHAR2,
        P_ITEM_ID               IN  VARCHAR2,
        O_RC1                   OUT SYS_REFCURSOR,
        O_RESULT_CODE           OUT VARCHAR2,
        O_RESULT_MSG            OUT VARCHAR2
    );

    /* Stock(Elec. Plant) 조회 - 81_UC 외 사업부 (AS-IS SCP0125_GET_STOCK_ELEC_PLNT) */
    PROCEDURE P_SCP0125_GET_STOCK_ELEC_PLNT
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_VERSION_NO            IN  VARCHAR2,
        P_NICK_NAME             IN  VARCHAR2,
        P_ITEM_ID               IN  VARCHAR2,
        O_RC1                   OUT SYS_REFCURSOR,
        O_RESULT_CODE           OUT VARCHAR2,
        O_RESULT_MSG            OUT VARCHAR2
    );

    /* Stock(Elec. Plant) 조회 - 81_UC 사업부 (AS-IS SCP0125_GET_STOCK_ELEC_PLNT_UC) */
    PROCEDURE P_SCP0125_GET_STOCK_ELEC_UC
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_VERSION_NO            IN  VARCHAR2,
        P_NICK_NAME             IN  VARCHAR2,
        P_ITEM_ID               IN  VARCHAR2,
        O_RC1                   OUT SYS_REFCURSOR,
        O_RESULT_CODE           OUT VARCHAR2,
        O_RESULT_MSG            OUT VARCHAR2
    );

    /* Stock(2nd OCV) 조회 (AS-IS SCP0125_GET_STOCK_SECOND_OCV) */
    PROCEDURE P_SCP0125_GET_STOCK_SECOND_OCV
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_VERSION_NO            IN  VARCHAR2,
        P_NICK_NAME             IN  VARCHAR2,
        P_ITEM_ID               IN  VARCHAR2,
        O_RC1                   OUT SYS_REFCURSOR,
        O_RESULT_CODE           OUT VARCHAR2,
        O_RESULT_MSG            OUT VARCHAR2
    );

    /* MKT FCST 등록 · 수정 · 삭제 (AS-IS SCP0125_SAVE_MKT_FCST_ADJ) */
    PROCEDURE P_SCP0125_SAVE_MKT_FCST_ADJ
    (
        P_ACTIVE_FLAG           IN  CLOB,
        P_DIVISION_ID           IN  CLOB,
        P_VERSION_NO            IN  CLOB,
        P_CUTOFF_YYYYMMDD       IN  CLOB,
        P_PROJECT_CODE          IN  CLOB,
        P_SALES_SITE_ID         IN  CLOB,
        P_ITEM_ID               IN  CLOB,
        P_FCST_TYPE             IN  CLOB,
        P_INCOTERMS             IN  CLOB,
        P_PLANT_SITE_ID         IN  CLOB,
        P_CELL_PROD_SITE_ID     IN  CLOB,
        P_DUE_DATE              IN  CLOB,
        P_QTY                   IN  CLOB,
        P_CHG_QTY               IN  CLOB,
        P_CHG_RSN               IN  CLOB,
        P_CHG_TYPE              IN  CLOB,
        P_USER_ID               IN  VARCHAR2,
        O_RESULT_CODE           OUT VARCHAR2,
        O_RESULT_CNT            OUT NUMBER,
        O_RESULT_MSG            OUT VARCHAR2
    );

    /* Elec. Demand 등록 · 수정 · 삭제 (AS-IS SCP0125_SAVE_MKT_FCST_ELEC_DEMAND) */
    PROCEDURE P_SCP0125_SAVE_ELEC_DEMAND
    (
        P_ACTIVE_FLAG           IN  CLOB,
        P_DIVISION_ID           IN  CLOB,
        P_PLAN_START_YYYYMMDD   IN  CLOB,
        P_PLAN_TYPE             IN  CLOB,
        P_SEQ                   IN  CLOB,
        P_PLANT_SITE_ID         IN  CLOB,
        P_LINE_ID               IN  CLOB,
        P_OPERATION_ID          IN  CLOB,
        P_ITEM_ID               IN  CLOB,
        P_YYYYMMDD              IN  CLOB,
        P_QTY                   IN  CLOB,
        P_CHG_QTY               IN  CLOB,
        P_CHG_RSN               IN  CLOB,
        P_CHG_TYPE              IN  CLOB,
        P_USER_ID               IN  VARCHAR2,
        O_RESULT_CODE           OUT VARCHAR2,
        O_RESULT_CNT            OUT NUMBER,
        O_RESULT_MSG            OUT VARCHAR2
    );

    /* Stock 조정 등록 · 수정 · 삭제 (AS-IS SCP0125_SAVE_STOCK_ADJ) */
    PROCEDURE P_SCP0125_SAVE_STOCK_ADJ
    (
        P_ACTIVE_FLAG           IN  CLOB,
        P_DIVISION_ID           IN  CLOB,
        P_STOCK_TYPE            IN  CLOB,
        P_CUTOFF_YYYYMMDD       IN  CLOB,
        P_PROJECT_CODE          IN  CLOB,
        P_ITEM_ID               IN  CLOB,
        P_INCOTERMS             IN  CLOB,
        P_FROM_SITE_ID          IN  CLOB,
        P_SCM_SITE_ID           IN  CLOB,
        P_LOCATION_CODE         IN  CLOB,
        P_LINE_ID               IN  CLOB,
        P_BEFORE_DEGAS          IN  CLOB,
        P_INV_DATE              IN  CLOB,
        P_QTY                   IN  CLOB,
        P_CHG_QTY               IN  CLOB,
        P_CHG_RSN               IN  CLOB,
        P_CHG_TYPE              IN  CLOB,
        P_USER_ID               IN  VARCHAR2,
        O_RESULT_CODE           OUT VARCHAR2,
        O_RESULT_CNT            OUT NUMBER,
        O_RESULT_MSG            OUT VARCHAR2
    );

    /* Stock(2nd OCV) 등록 · 수정 · 삭제 (AS-IS SCP0125_SAVE_STOCK_SECOND_OCV) */
    PROCEDURE P_SCP0125_SAVE_STOCK_2ND_OCV
    (
        P_ACTIVE_FLAG           IN  CLOB,
        P_DIVISION_ID           IN  CLOB,
        P_STOCK_TYPE            IN  CLOB,
        P_CUTOFF_YYYYMMDD       IN  CLOB,
        P_ITEM_ID               IN  CLOB,
        P_PLANT_ID              IN  CLOB,
        P_OPERATION_ID          IN  CLOB,
        P_SECOND_OCV_TIME       IN  CLOB,
        P_SECOND_OCV_DATE       IN  CLOB,
        P_QTY                   IN  CLOB,
        P_CHG_QTY               IN  CLOB,
        P_CHG_RSN               IN  CLOB,
        P_CHG_TYPE              IN  CLOB,
        P_USER_ID               IN  VARCHAR2,
        O_RESULT_CODE           OUT VARCHAR2,
        O_RESULT_CNT            OUT NUMBER,
        O_RESULT_MSG            OUT VARCHAR2
    );

END PKG_SCP0125;