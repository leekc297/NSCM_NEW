PACKAGE PKG_SSP0015
IS

    /* ============================================================
       조회 (GET)
       ============================================================ */

    /* Shipment PSI 본문 - 조회기간만큼 날짜 칸을 만드는 동적 피벗 */
    PROCEDURE P_SSP0015_GET_SHIPMENT_PSI
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_FROM_SITE             IN  VARCHAR2,
        P_ITEM_ID               IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_PLAN_TYPE             IN  VARCHAR2,
        P_FROM_YYYYMMDD         IN  VARCHAR2,
        P_TO_YYYYMMDD           IN  VARCHAR2,
        P_USER_ID               IN  VARCHAR2,
        P_MYMODELCHK            IN  VARCHAR2 DEFAULT 'N',
        P_PROGRAM_ID            IN  VARCHAR2,
        P_SHEET_NAME            IN  VARCHAR2,
        P_DEBUG_MODE            IN  VARCHAR2 DEFAULT 'F',
        P_SEQ                   IN  VARCHAR2,
        P_PARTLEADERCHK         IN  VARCHAR2,
        P_TEAMLEADERCHK         IN  VARCHAR2,
        P_NONCHK                IN  VARCHAR2,
        P_DELEGATEECHK          IN  VARCHAR2,
        O_RC1                   OUT SYS_REFCURSOR,   /* 피벗 본문 */
        O_RC2                   OUT SYS_REFCURSOR,   /* NOTE (PSI_COMMENTS 1번째) */
        O_RC3                   OUT SYS_REFCURSOR    /* Prod Qty (PSI_COMMENTS 2번째) */
    );

    /* Shipment PSI - NOTE · Prod Qty */
    PROCEDURE P_SSP0015_GET_SHIPMENT_PSI_COMMENTS
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_FROM_SITE             IN  VARCHAR2,
        P_ITEM_ID               IN  VARCHAR2,
        P_FROM_YYYYMMDD         IN  VARCHAR2,
        P_TO_YYYYMMDD           IN  VARCHAR2,
        O_RC1                   OUT SYS_REFCURSOR,   /* NOTE */
        O_RC2                   OUT SYS_REFCURSOR    /* Prod Qty */
    );

    /* Shipment PSI (Packer) */
    PROCEDURE P_SSP0015_GET_SHIPMENT_PSI_PACKER
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_FROM_SITE             IN  VARCHAR2,
        P_ITEM_ID               IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_PLAN_TYPE             IN  VARCHAR2,
        P_FROM_YYYYMMDD         IN  VARCHAR2,
        P_TO_YYYYMMDD           IN  VARCHAR2,
        P_USER_ID               IN  VARCHAR2,
        P_MYMODELCHK            IN  VARCHAR2 DEFAULT 'N',
        P_PROGRAM_ID            IN  VARCHAR2,
        P_SHEET_NAME            IN  VARCHAR2,
        P_DEBUG_MODE            IN  VARCHAR2 DEFAULT 'F',
        P_SEQ                   IN  VARCHAR2,
        P_PARTLEADERCHK         IN  VARCHAR2,
        P_TEAMLEADERCHK         IN  VARCHAR2,
        P_NONCHK                IN  VARCHAR2,
        P_DELEGATEECHK          IN  VARCHAR2,
        O_RC1                   OUT SYS_REFCURSOR
    );

    /* Shipment PSI (Packer) - 과거 버전(SSP_ANL_SHIP_PLAN_P 스냅샷) */
    PROCEDURE P_SSP0015_GET_SHIPMENT_PSI_PACKER_PAST
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_FROM_SITE             IN  VARCHAR2,
        P_ITEM_ID               IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_PLAN_TYPE             IN  VARCHAR2,
        P_FROM_YYYYMMDD         IN  VARCHAR2,
        P_TO_YYYYMMDD           IN  VARCHAR2,
        P_USER_ID               IN  VARCHAR2,
        P_MYMODELCHK            IN  VARCHAR2 DEFAULT 'N',
        P_PROGRAM_ID            IN  VARCHAR2,
        P_SHEET_NAME            IN  VARCHAR2,
        P_DEBUG_MODE            IN  VARCHAR2 DEFAULT 'F',
        P_SEQ                   IN  VARCHAR2,
        P_PARTLEADERCHK         IN  VARCHAR2,
        P_TEAMLEADERCHK         IN  VARCHAR2,
        P_NONCHK                IN  VARCHAR2,
        P_DELEGATEECHK          IN  VARCHAR2,
        O_RC1                   OUT SYS_REFCURSOR
    );

    /* 출하확정 상세 */
    PROCEDURE P_SSP0015_GET_SHIPMENT_CONFIRM_DETAIL
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_FROM_SITE             IN  VARCHAR2,
        P_ITEM_ID               IN  VARCHAR2,
        P_FROM_YYYYMMDD         IN  VARCHAR2,
        P_TO_YYYYMMDD           IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_LANGUAGE              IN  VARCHAR2 DEFAULT 'KO',
        P_USER_ID               IN  VARCHAR2,
        P_MYMODELCHK            IN  VARCHAR2 DEFAULT 'N',
        P_REQUESTOR             IN  VARCHAR2,
        P_PARTLEADERCHK         IN  VARCHAR2,
        P_TEAMLEADERCHK         IN  VARCHAR2,
        P_SEARCH_YN             IN  VARCHAR2,
        P_NONCHK                IN  VARCHAR2 DEFAULT 'N',
        P_REAL_FLAG             IN  VARCHAR2 DEFAULT 'N',
        P_DEBUG_MODE            IN  VARCHAR2 DEFAULT 'T',
        P_DELEGATEECHK          IN  VARCHAR2,
        O_RC1                   OUT SYS_REFCURSOR
    );


    /* 출하실적 */
    PROCEDURE P_SSP0015_GET_SHIPMENT_RESULT
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_FROM_SITE             IN  VARCHAR2,
        P_ITEM_ID               IN  VARCHAR2,
        P_FROM_YYYYMMDD         IN  VARCHAR2,
        P_TO_YYYYMMDD           IN  VARCHAR2,
        P_TYPE                  IN  VARCHAR2,
        P_USER_ID               IN  VARCHAR2,
        P_COMPANY_ID            IN  VARCHAR2,
        P_MYMODELCHK            IN  VARCHAR2,
        P_PARTLEADERCHK         IN  VARCHAR2,
        P_TEAMLEADERCHK         IN  VARCHAR2,
        P_DELEGATEECHK          IN  VARCHAR2,
        P_NONCHK                IN  VARCHAR2,
        P_REAL_FLAG             IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        O_RC1                   OUT SYS_REFCURSOR
    );

    /* 출하실적 (Packer) */
    PROCEDURE P_SSP0015_GET_SHIPMENT_RESULT_PACKER
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_FROM_SITE             IN  VARCHAR2,
        P_ITEM_ID               IN  VARCHAR2,
        P_FROM_YYYYMMDD         IN  VARCHAR2,
        P_TO_YYYYMMDD           IN  VARCHAR2,
        P_TYPE                  IN  VARCHAR2,
        P_USER_ID               IN  VARCHAR2,
        P_COMPANY_ID            IN  VARCHAR2,
        P_MYMODELCHK            IN  VARCHAR2,
        P_PARTLEADERCHK         IN  VARCHAR2,
        P_TEAMLEADERCHK         IN  VARCHAR2,
        P_DELEGATEECHK          IN  VARCHAR2,
        P_NONCHK                IN  VARCHAR2,
        P_REAL_FLAG             IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        O_RC1                   OUT SYS_REFCURSOR
    );

    /* Block Stock (본문 + 상세) */
    PROCEDURE P_SSP0015_GET_BLOCK_STOCK
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_FROM_SITE             IN  VARCHAR2,
        P_ITEM_ID               IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_PLAN_TYPE             IN  VARCHAR2,
        P_SEQ                   IN  VARCHAR2,
        P_LANGUAGE              IN  VARCHAR2 DEFAULT 'KO',
        P_SEARCH_YN             IN  VARCHAR2,
        P_USER_ID               IN  VARCHAR2,
        P_MYMODELCHK            IN  VARCHAR2 DEFAULT 'N',
        P_PARTLEADERCHK         IN  VARCHAR2,
        P_TEAMLEADERCHK         IN  VARCHAR2,
        P_NONCHK                IN  VARCHAR2 DEFAULT 'N',
        P_DELEGATEECHK          IN  VARCHAR2,
        O_RC1                   OUT SYS_REFCURSOR,   /* Block Stock */
        O_RC2                   OUT SYS_REFCURSOR    /* Block Stock Detail */
    );

    /* W/H Stock (본문 + 상세) */
    PROCEDURE P_SSP0015_GET_WH_STOCK
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_ITEM_ID               IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_PLAN_TYPE             IN  VARCHAR2,
        P_PLAN_SEQ              IN  VARCHAR2,
        P_FROM_SITE             IN  VARCHAR2,
        P_USER_ID               IN  VARCHAR2,
        P_MYMODELCHK            IN  VARCHAR2 DEFAULT 'N',
        P_PARTLEADERCHK         IN  VARCHAR2,
        P_TEAMLEADERCHK         IN  VARCHAR2,
        P_SEARCH_YN             IN  VARCHAR2,
        P_NONCHK                IN  VARCHAR2,
        P_DELEGATEECHK          IN  VARCHAR2,
        O_RC1                   OUT SYS_REFCURSOR,   /* W/H Stock */
        O_RC2                   OUT SYS_REFCURSOR    /* W/H Stock Detail */
    );

    /* MES Stock */
    PROCEDURE P_SSP0015_GET_MES_STOCK
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_FROM_SITE             IN  VARCHAR2,
        P_ITEM_ID               IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_USER_ID               IN  VARCHAR2,
        P_LOT_ID                IN  VARCHAR2,
        P_MYMODELCHK            IN  VARCHAR2,
        P_PARTLEADERCHK         IN  VARCHAR2,
        P_TEAMLEADERCHK         IN  VARCHAR2,
        P_DELEGATEECHK          IN  VARCHAR2,
        P_NONCHK                IN  VARCHAR2,
        P_LANGUAGE              IN  VARCHAR2,
        O_RC1                   OUT SYS_REFCURSOR
    );

    /* SCS Stock */
    PROCEDURE P_SSP0015_GET_SCS_STOCK
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_FROM_SITE             IN  VARCHAR2,
        P_ITEM_ID               IN  VARCHAR2,
        P_USER_ID               IN  VARCHAR2,
        P_MYMODELCHK            IN  VARCHAR2,
        P_PARTLEADERCHK         IN  VARCHAR2,
        P_TEAMLEADERCHK         IN  VARCHAR2,
        P_DELEGATEECHK          IN  VARCHAR2,
        P_NONCHK                IN  VARCHAR2,
        O_RC1                   OUT SYS_REFCURSOR
    );

    /* Stock Location Detail */
    PROCEDURE P_SSP0015_GET_STOCK_LOCATION_DETAIL
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_COMPANY_ID            IN  VARCHAR2,
        P_FROM_SITE             IN  VARCHAR2,
        P_ITEM_ID               IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_DBL_FLAG              IN  VARCHAR2,
        P_LANGUAGE              IN  VARCHAR2 DEFAULT 'KO',
        P_PROGRAM_ID            IN  VARCHAR2 DEFAULT 'SSP0015',
        P_SHEET_NAME            IN  VARCHAR2 DEFAULT 'Stock Location Detail',
        P_DEBUG_MODE            IN  VARCHAR2 DEFAULT 'T',
        P_USER_ID               IN  VARCHAR2,
        P_MYMODELCHK            IN  VARCHAR2,
        P_PARTLEADERCHK         IN  VARCHAR2,
        P_TEAMLEADERCHK         IN  VARCHAR2,
        P_DELEGATEECHK          IN  VARCHAR2,
        P_NONCHK                IN  VARCHAR2,
        O_RC1                   OUT SYS_REFCURSOR
    );

    /* ERP SO 번호 건수 */
    PROCEDURE P_SSP0015_GET_ERP_SO_NO_CNT
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_ERP_SO_NO             IN  VARCHAR2,
        O_RC1                   OUT SYS_REFCURSOR
    );

    /* 출하확정 상태 확인 3종 */
    PROCEDURE P_SSP0015_GET_SHIPMENT_STATUS
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_CONFIRM_ID            IN  VARCHAR2,
        O_RC1                   OUT SYS_REFCURSOR,   /* SHIPMENT_STATUS != 'C' */
        O_RC2                   OUT SYS_REFCURSOR,   /* QTY = 0 */
        O_RC3                   OUT SYS_REFCURSOR    /* ERP_STATUS = 'C' */
    );

    /* ============================================================
       저장 (SAVE / DELETE)
       ============================================================ */

    /* PSI 수량 저장 */
    PROCEDURE P_SSP0015_SAVE_SHIPMENT_PSI
    (
        P_ACTIVE_FLAG           IN  VARCHAR2,
        P_DIVISION_ID           IN  VARCHAR2,
        P_FROM_SITE             IN  VARCHAR2,
        P_ITEM_ID               IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_YYYYMMDD              IN  VARCHAR2,
        P_PLAN_TYPE             IN  VARCHAR2,
        P_SEQ                   IN  VARCHAR2,
        P_MEASURE               IN  VARCHAR2,
        P_QTY                   IN  VARCHAR2,
        P_USER_ID               IN  VARCHAR2,
        P_DEBUG_MODE            IN  VARCHAR2 DEFAULT 'F',
        O_RC1                   OUT SYS_REFCURSOR,   /* result_code (+ result_cnt) */
        O_RC2                   OUT SYS_REFCURSOR    /* 오류일 때 err_code / err_message */
    );

    /* PSI Comments 저장 */
    PROCEDURE P_SSP0015_SAVE_SHIPMENT_PSI_COMMENTS
    (
        P_CHANGE_FLAG           IN  VARCHAR2,
        P_DIVISION_ID           IN  VARCHAR2,
        P_FROM_SITE             IN  VARCHAR2,
        P_ITEM_ID               IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_YYYYMMDD              IN  VARCHAR2,
        P_PLAN_TYPE             IN  VARCHAR2,
        P_SEQ                   IN  VARCHAR2,
        P_MEASURE               IN  VARCHAR2,
        P_QTY                   IN  VARCHAR2,
        P_PRODQTY               IN  VARCHAR2,
        P_COMMENTS              IN  VARCHAR2,
        P_USER_ID               IN  VARCHAR2,
        O_RC1                   OUT SYS_REFCURSOR,
        O_RC2                   OUT SYS_REFCURSOR
    );

    /* Block Stock 저장 */
    PROCEDURE P_SSP0015_SAVE_BLOCK_STOCK_DATA
    (
        P_ACTIVE_FLAG           IN  VARCHAR2,
        P_HOLD_ID               IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_PLAN_TYPE             IN  VARCHAR2,
        P_SEQ                   IN  VARCHAR2,
        P_DIVISION_ID           IN  VARCHAR2,
        P_FROM_SITE             IN  VARCHAR2,
        P_ITEM_ID               IN  VARCHAR2,
        P_HOLD_YYYYMMDD         IN  VARCHAR2,
        P_RELEASE_YYYYMMDD      IN  VARCHAR2,
        P_HOLD_QTY              IN  VARCHAR2,
        P_REMARKS               IN  VARCHAR2,
        P_USER_ID               IN  VARCHAR2,
        O_RC1                   OUT SYS_REFCURSOR,
        O_RC2                   OUT SYS_REFCURSOR
    );

    /* MES Stock 저장 */
    PROCEDURE P_SSP0015_SAVE_MES_STOCK
    (
        P_ACTIVE_FLAG              IN  VARCHAR2,
        P_DIVISION_ID              IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD      IN  VARCHAR2,
        P_PLAN_TYPE                IN  VARCHAR2,
        P_SEQ                      IN  VARCHAR2,
        P_FROM_SITE                IN  VARCHAR2,
        P_ITEM_ID                  IN  VARCHAR2,
        P_LOT_ID                   IN  VARCHAR2,
        P_USER_MOD_RELEASE_DATE    IN  VARCHAR2,
        P_REMARKS                  IN  VARCHAR2,
        P_USER_ID                  IN  VARCHAR2,
        O_RC1                      OUT SYS_REFCURSOR,
        O_RC2                      OUT SYS_REFCURSOR
    );





    /* 출하변경요청 작성중 삭제 */
    PROCEDURE P_SSP0015_DELETE_SHIPMENT_REQUEST_DRAFTING
    (
        P_CHANGE_REQUEST_NO     IN  VARCHAR2,
        P_USER_ID               IN  VARCHAR2,
        O_RC1                   OUT SYS_REFCURSOR,
        O_RC2                   OUT SYS_REFCURSOR
    );

    PROCEDURE P_SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_40
    (
        P_ACTIVE_FLAG           IN  VARCHAR2,
        P_DIVISION_ID           IN  VARCHAR2,
        P_CONFIRM_ID            IN  VARCHAR2,
        P_SHIPMENT_QTY          IN  VARCHAR2,
        P_SHIPMENT_DATE         IN  VARCHAR2,
        P_NEW_BOD_ID            IN  VARCHAR2,
        P_NEW_ROUTE_ID          IN  VARCHAR2,
        P_NEW_ETD_DATE          IN  VARCHAR2,
        P_NEW_ETA_DATE          IN  VARCHAR2,
        P_NEW_INCOTERMS         IN  VARCHAR2,
        P_NEW_TRANSPORT_MODE    IN  VARCHAR2,
        P_NEW_D_CONTRY          IN  VARCHAR2,
        P_NEW_D_PORT_CODE       IN  VARCHAR2,
        P_NEW_A_COUNTRY         IN  VARCHAR2,
        P_NEW_A_PORT_CODE       IN  VARCHAR2,
        P_NEW_CUSTOMER_LT       IN  VARCHAR2,
        P_NEW_TO_COUNTRY        IN  VARCHAR2,
        P_NEW_TO_CITY           IN  VARCHAR2,
        P_REMARKS               IN  VARCHAR2,
        P_REMARKS2              IN  VARCHAR2,
        P_REMARKS3              IN  VARCHAR2,
        P_USER_ID               IN  VARCHAR2,
        P_CHECK_NEED_YN         IN  VARCHAR2,
        P_EDIT_MAIN             IN  VARCHAR2,
        O_RC1                   OUT SYS_REFCURSOR,   /* 결과코드 (위 설명) */
        O_RC2                   OUT SYS_REFCURSOR    /* 오류일 때 ERR_CODE / ERR_MESSAGE */
    );

    PROCEDURE P_SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_PACKER
    (
        P_ACTIVE_FLAG           IN  VARCHAR2,
        P_DIVISION_ID           IN  VARCHAR2,
        P_CONFIRM_ID            IN  VARCHAR2,
        P_SHIPMENT_QTY          IN  VARCHAR2,
        P_SHIPMENT_DATE         IN  VARCHAR2,
        P_NEW_BOD_ID            IN  VARCHAR2,
        P_NEW_ROUTE_ID          IN  VARCHAR2,
        P_NEW_ETD_DATE          IN  VARCHAR2,
        P_NEW_ETA_DATE          IN  VARCHAR2,
        P_NEW_INCOTERMS         IN  VARCHAR2,
        P_NEW_TRANSPORT_MODE    IN  VARCHAR2,
        P_NEW_D_CONTRY          IN  VARCHAR2,
        P_NEW_D_PORT_CODE       IN  VARCHAR2,
        P_NEW_A_COUNTRY         IN  VARCHAR2,
        P_NEW_A_PORT_CODE       IN  VARCHAR2,
        P_NEW_CUSTOMER_LT       IN  VARCHAR2,
        P_NEW_TO_COUNTRY        IN  VARCHAR2,
        P_NEW_TO_CITY           IN  VARCHAR2,
        P_REMARKS               IN  VARCHAR2,
        P_REMARKS2              IN  VARCHAR2,
        P_REMARKS3              IN  VARCHAR2,
        P_USER_ID               IN  VARCHAR2,
        P_CHECK_NEED_YN         IN  VARCHAR2,
        P_EDIT_MAIN             IN  VARCHAR2,
        P_SHIPTO_CODE           IN  VARCHAR2,
        O_RC1                   OUT SYS_REFCURSOR,
        O_RC2                   OUT SYS_REFCURSOR
    );

    PROCEDURE P_SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING
    (
        P_ACTIVE_FLAG               IN  VARCHAR2,
        P_DIVISION_ID               IN  VARCHAR2,
        P_CONFIRM_ID                IN  VARCHAR2,
        P_SHIPMENT_QTY              IN  VARCHAR2,
        P_SHIPMENT_DATE             IN  VARCHAR2,
        P_FROM_SITE                 IN  VARCHAR2,
        P_NEW_BOD_ID                IN  VARCHAR2,
        P_NEW_ROUTE_ID              IN  VARCHAR2,
        P_NEW_ETD_DATE              IN  VARCHAR2,
        P_NEW_ETA_DATE              IN  VARCHAR2,
        P_NEW_INCOTERMS             IN  VARCHAR2,
        P_NEW_TRANSPORT_MODE        IN  VARCHAR2,
        P_NEW_D_CONTRY              IN  VARCHAR2,
        P_NEW_D_PORT_CODE           IN  VARCHAR2,
        P_NEW_A_COUNTRY             IN  VARCHAR2,
        P_NEW_A_PORT_CODE           IN  VARCHAR2,
        P_NEW_CUSTOMER_LT           IN  VARCHAR2,
        P_NEW_TO_COUNTRY            IN  VARCHAR2,
        P_NEW_TO_CITY               IN  VARCHAR2,
        P_EDIT_MAIN                 IN  VARCHAR2,
        P_EDIT_REMARK               IN  VARCHAR2,
        P_USER_ID                   IN  VARCHAR2,
        P_USER_DEPT_ID              IN  VARCHAR2,
        P_ELECTRODE_YN              IN  VARCHAR2 DEFAULT '',
        P_ELECTRODE_TYPE            IN  VARCHAR2 DEFAULT '',
        P_ORIGIN_FROM_DIVISION_ID   IN  VARCHAR2 DEFAULT '',
        P_ORIGION_TO_DIVISION_ID    IN  VARCHAR2 DEFAULT '',
        P_REMARKS                   IN  VARCHAR2,
        P_REMARKS2                  IN  VARCHAR2,
        P_REMARKS3                  IN  VARCHAR2,
        P_CHANGE_REASON_CODE        IN  VARCHAR2,
        P_CHANGE_REASON_DETAIL      IN  VARCHAR2,
        P_TITLE                     IN  VARCHAR2,
        P_PROGRAM_ID                IN  VARCHAR2,
        P_SHIPTO_CODE               IN  VARCHAR2,
        O_RC1                       OUT SYS_REFCURSOR,
        O_RC2                       OUT SYS_REFCURSOR
    );

    PROCEDURE P_SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING_PACKER
    (
        P_ACTIVE_FLAG               IN  VARCHAR2,
        P_DIVISION_ID               IN  VARCHAR2,
        P_CONFIRM_ID                IN  VARCHAR2,
        P_SHIPMENT_QTY              IN  VARCHAR2,
        P_SHIPMENT_DATE             IN  VARCHAR2,
        P_FROM_SITE                 IN  VARCHAR2,
        P_NEW_BOD_ID                IN  VARCHAR2,
        P_NEW_ROUTE_ID              IN  VARCHAR2,
        P_NEW_ETD_DATE              IN  VARCHAR2,
        P_NEW_ETA_DATE              IN  VARCHAR2,
        P_NEW_INCOTERMS             IN  VARCHAR2,
        P_NEW_TRANSPORT_MODE        IN  VARCHAR2,
        P_NEW_D_CONTRY              IN  VARCHAR2,
        P_NEW_D_PORT_CODE           IN  VARCHAR2,
        P_NEW_A_COUNTRY             IN  VARCHAR2,
        P_NEW_A_PORT_CODE           IN  VARCHAR2,
        P_NEW_CUSTOMER_LT           IN  VARCHAR2,
        P_NEW_TO_COUNTRY            IN  VARCHAR2,
        P_NEW_TO_CITY               IN  VARCHAR2,
        P_EDIT_MAIN                 IN  VARCHAR2,
        P_EDIT_REMARK               IN  VARCHAR2,
        P_USER_ID                   IN  VARCHAR2,
        P_USER_DEPT_ID              IN  VARCHAR2,
        P_ELECTRODE_YN              IN  VARCHAR2 DEFAULT '',
        P_ELECTRODE_TYPE            IN  VARCHAR2 DEFAULT '',
        P_ORIGIN_FROM_DIVISION_ID   IN  VARCHAR2 DEFAULT '',
        P_ORIGION_TO_DIVISION_ID    IN  VARCHAR2 DEFAULT '',
        P_REMARKS                   IN  VARCHAR2,
        P_REMARKS2                  IN  VARCHAR2,
        P_REMARKS3                  IN  VARCHAR2,
        P_CHANGE_REASON_CODE        IN  VARCHAR2,
        P_CHANGE_REASON_DETAIL      IN  VARCHAR2,
        P_TITLE                     IN  VARCHAR2,
        P_PROGRAM_ID                IN  VARCHAR2,
        P_SHIPTO_CODE               IN  VARCHAR2,
        O_RC1                       OUT SYS_REFCURSOR,
        O_RC2                       OUT SYS_REFCURSOR
    );

    PROCEDURE P_SSP0015_GET_SHIPMENT_CONFIRM_DETAIL_PACKER
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_FROM_SITE             IN  VARCHAR2,
        P_ITEM_ID               IN  VARCHAR2,
        P_FROM_YYYYMMDD         IN  VARCHAR2,
        P_TO_YYYYMMDD           IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_LANGUAGE              IN  VARCHAR2 DEFAULT 'KO',
        P_USER_ID               IN  VARCHAR2,
        P_MYMODELCHK            IN  VARCHAR2 DEFAULT 'N',
        P_REQUESTOR             IN  VARCHAR2,
        P_PARTLEADERCHK         IN  VARCHAR2,
        P_TEAMLEADERCHK         IN  VARCHAR2,
        P_SEARCH_YN             IN  VARCHAR2,
        P_NONCHK                IN  VARCHAR2 DEFAULT 'N',
        P_DEBUG_MODE            IN  VARCHAR2 DEFAULT 'T',
        P_REAL_FLAG             IN  VARCHAR2 DEFAULT 'N',
        P_DELEGATEECHK          IN  VARCHAR2,
        O_RC1                   OUT SYS_REFCURSOR
    );

END PKG_SSP0015;