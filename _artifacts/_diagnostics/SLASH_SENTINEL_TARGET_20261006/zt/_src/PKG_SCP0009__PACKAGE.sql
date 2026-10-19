PACKAGE         PKG_SCP0009
IS

    /* Shipment Plan 조회 - 본문(수량 포함) */
    PROCEDURE P_SCP0009_GET_SHIPMENT_PLAN_FG
    (
        P_FROM_YYYYMMDD         IN  VARCHAR2,
        P_TO_YYYYMMDD           IN  VARCHAR2,
        P_DIVISION_ID           IN  VARCHAR2,
        P_BIZ_TYPE              IN  VARCHAR2,
        P_PROJECT_CODE          IN  VARCHAR2,
        P_ITEM_ID               IN  VARCHAR2,
        P_ELECTYPE              IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_PLAN_TYPE             IN  VARCHAR2,
        P_SEQ                   IN  VARCHAR2,
        P_FROMSITE              IN  VARCHAR2,
        P_TEAM_ID               IN  VARCHAR2,
        P_TOSITE                IN  VARCHAR2,
        P_BUCKET                IN  VARCHAR2,
        P_TO_PERIOD             IN  VARCHAR2,
        P_CHK_ALL               IN  VARCHAR2,
        P_PROGRAM_ID            IN  VARCHAR2 DEFAULT 'SCP0009',
        P_SHEET_NAME            IN  VARCHAR2 DEFAULT 'Shipment Plan FG',
        P_USER_ID               IN  VARCHAR2,
        P_DEBUG_MODE            IN  VARCHAR2 DEFAULT 'F',
        O_RC1                   OUT SYS_REFCURSOR,   /* 피벗 조회 결과 */
        O_RC2                   OUT SYS_REFCURSOR,   /* 수정가능여부 구간 (P_BUCKET 이 WEEKLY·MONTHLY 일 때만 행이 있다) */
        O_RC3                   OUT SYS_REFCURSOR    /* Fix 컬럼 색상 설정 (동일) */
    );

    /* Shipment Plan 조회 - 타이틀(행 축) 병렬 조회 */
    PROCEDURE P_SCP0009_GET_SHIP_PLAN_FG_TITLE_PARAL
    (
        P_FROM_YYYYMMDD         IN  VARCHAR2,
        P_TO_YYYYMMDD           IN  VARCHAR2,
        P_DIVISION_ID           IN  VARCHAR2,
        P_BIZ_TYPE              IN  VARCHAR2,
        P_PROJECT_CODE          IN  VARCHAR2,
        P_ITEM_ID               IN  VARCHAR2,
        P_ELECTYPE              IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_PLAN_TYPE             IN  VARCHAR2,
        P_SEQ                   IN  VARCHAR2,
        P_FROMSITE              IN  VARCHAR2,
        P_TEAM_ID               IN  VARCHAR2,
        P_TOSITE                IN  VARCHAR2,
        P_BUCKET                IN  VARCHAR2,
        P_CHK_ALL               IN  VARCHAR2,
        P_PROGRAM_ID            IN  VARCHAR2 DEFAULT 'SCP0009',
        P_SHEET_NAME            IN  VARCHAR2 DEFAULT 'Shipment Plan FG',
        P_USER_ID               IN  VARCHAR2,
        P_DEBUG_MODE            IN  VARCHAR2 DEFAULT 'F',
        O_RC1                   OUT SYS_REFCURSOR,   /* 타이틀 조회 결과 */
        O_RC2                   OUT SYS_REFCURSOR,   /* 수정가능여부 구간 */
        O_RC3                   OUT SYS_REFCURSOR    /* Fix 컬럼 색상 설정 */
    );

    /* Shipment Plan - pegging 조회 */
    PROCEDURE P_SCP0009_GET_SHIPMENT_PLAN_FG_PEGGING
    (
        P_DIVISION_ID               IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD       IN  VARCHAR2,
        P_PLAN_TYPE                 IN  VARCHAR2,
        P_SEQ                       IN  NUMBER,
        P_ITEM_ID                   IN  VARCHAR2,
        P_ORIGIN_FROM_DIVISION_ID   IN  VARCHAR2,
        P_ORIGIN_TO_DIVISION_ID     IN  VARCHAR2,
        P_ELECTRODE_TYPE            IN  VARCHAR2,
        P_BIZ_TYPE                  IN  VARCHAR2,
        P_TO_SITE                   IN  VARCHAR2,
        P_DUEDATE                   IN  VARCHAR2,
        P_PROJECT_CODE              IN  VARCHAR2,
        O_RC1                       OUT SYS_REFCURSOR
    );

    /* Shipment Plan - problem 조회 */
    PROCEDURE P_SCP0009_GET_SHIPMENT_PLAN_FG_PROBLEM
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_PLAN_TYPE             IN  VARCHAR2,
        P_SEQ                   IN  NUMBER,
        P_ITEM_ID               IN  VARCHAR2,
        P_PROJECT_CODE          IN  VARCHAR2,
        P_TO_SITE               IN  VARCHAR2,
        P_DUEDATE               IN  VARCHAR2,
        O_RC1                   OUT SYS_REFCURSOR
    );

    /* SHIPMENT PLAN FG FIX 등록·수정 (구분자 묶음 문자열) */
    PROCEDURE P_SCP0009_SAVE_ANL_SHIP_PLAN_FG_FIX
    (
        P_ACTIVE_FLAG               IN  VARCHAR2,
        P_DIVISION_ID               IN  VARCHAR2,
        P_BIZ_TYPE                  IN  VARCHAR2,
        P_ITEM_ID                   IN  VARCHAR2,
        P_TO_SITE                   IN  VARCHAR2,
        P_FROM_SITE                 IN  VARCHAR2,
        P_PROJECT_CODE              IN  VARCHAR2,
        P_INCOTERMS                 IN  VARCHAR2,
        P_BOD_ID                    IN  VARCHAR2,
        P_YYYYMMDD                  IN  VARCHAR2,
        P_QTY                       IN  VARCHAR2,
        P_ORIGIN_FROM_DIVISION_ID   IN  VARCHAR2,
        P_ORIGIN_TO_DIVISION_ID     IN  VARCHAR2,
        P_ELECTRODE_TYPE            IN  VARCHAR2,
        P_FIX_REASON                IN  VARCHAR2,
        P_USER_ID                   IN  VARCHAR2,
        P_DEBUG_MODE                IN  VARCHAR2 DEFAULT 'F',
        O_RC1                       OUT SYS_REFCURSOR    /* result_code · result_cnt */
    );

    /* SHIPMENT PLAN FG FIX 등록·수정 (행 묶음) */
    PROCEDURE P_SCP0009_SAVE_ANL_SHIP_FG_FIX_DATASET
    (
        P_SCP0009   IN  T_SCP0009_TAB,
        O_RC1       OUT SYS_REFCURSOR    /* result_code · result_cnt */
    );

    /* ANL SHIPMENT PLAN FG 저장 (일·주 저장) */
    PROCEDURE P_SCP0009_SAVE_ANL_SHIP_PLAN_FG_WEEKLY
    (
        P_SCP0009   IN  T_SCP0009_TAB,
        O_RC1       OUT SYS_REFCURSOR    /* result_code · result_cnt */
    );

    /* 최종 PLAN VERSION 조회 */
    PROCEDURE P_SCP0011_GET_LAST_PLAN_VERSION
    (
        P_DIVISION_ID   IN  VARCHAR2,
        O_RC1           OUT SYS_REFCURSOR
    );

    /* 2026.10.07 AJS 화면 저장용 JSON 래퍼 추가 (START) */
    /* CLOB(JSON 배열) → T_SCP0009_TAB 변환 (확인 SQL 에서 직접 부르려고 공개) */
    FUNCTION F_SCP0009_JSON_TO_COLLECTION
    (
        P_DATA  IN CLOB
    )
    RETURN T_SCP0009_TAB;

    /* ANL SHIPMENT PLAN FG 저장(일·주) — CLOB(JSON) 래퍼. 서버가 컬렉션 인자를 바인딩하지 못해 사용 */
    PROCEDURE P_SCP0009_SAVE_ANL_SHIP_PLAN_FG_WEEKLY_JSON
    (
        P_DATA  IN  CLOB
      , O_RC1   OUT SYS_REFCURSOR    /* RESULT_CODE · RESULT_CNT | ERR_MESSAGE */
    );

    /* SHIPMENT PLAN FG FIX 등록·삭제 — CLOB(JSON) 래퍼. 서버가 컬렉션 인자를 바인딩하지 못해 사용 */
    PROCEDURE P_SCP0009_SAVE_ANL_SHIP_FG_FIX_DATASET_JSON
    (
        P_DATA  IN  CLOB
      , O_RC1   OUT SYS_REFCURSOR    /* RESULT_CODE · RESULT_CNT | ERR_MESSAGE */
    );
    /* 2026.10.07 AJS 화면 저장용 JSON 래퍼 추가 (END) */

END PKG_SCP0009;