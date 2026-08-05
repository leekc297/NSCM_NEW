-- =============================================================================
-- PKG_SYS0017 — Mail Setup (AS-IS SCM0006) UI 전용 패키지
-- 생성: 2026-07-29 admin. 구성: 기존 사내 VALID standalone 7본 본문 무수정 승계(헤더/END 라벨만 치환)
--       + INVALID 2본(GET_RECIPIENT_ASSIGN/GET_USERINFO_LIST) AS-IS 원문 기준 재변환.
-- 구 standalone SCM0006_* 9본은 존치(참고) — 배선은 PKG 한정. 근거: SYS0017 화면설계서 v1.0 시트8.
-- =============================================================================
CREATE OR REPLACE PACKAGE SCM_MGR.PKG_SYS0017
AS

PROCEDURE P_SYS0017_GET_RECIPIENT_MASTER
(
    P_USE_TYPE             IN  VARCHAR2,
    P_MODULE               IN  VARCHAR2,
    P_SUBMODULE            IN  VARCHAR2,
    P_ACTIVE               IN  VARCHAR2,
    O_RC1                  OUT SYS_REFCURSOR,
    O_RESULT_CURSOR        OUT SYS_REFCURSOR
);

PROCEDURE P_SYS0017_GET_RECIPIENT_MESSAGE
(
    P_USE_TYPE             IN  VARCHAR2,
    P_CATEGORYID           IN  VARCHAR2,
    O_RC1                  OUT SYS_REFCURSOR,
    O_RESULT_CURSOR        OUT SYS_REFCURSOR
);

PROCEDURE P_SYS0017_GET_RECIPIENT_ASSIGN
(
    P_USE_TYPE             IN  VARCHAR2,
    P_CATEGORYID           IN  VARCHAR2,
    O_RC1                  OUT SYS_REFCURSOR,
    O_RESULT_CURSOR        OUT SYS_REFCURSOR
);

PROCEDURE P_SYS0017_GET_USERINFO_LIST
(
    P_USER                 IN  VARCHAR2,
    P_DEPT                 IN  VARCHAR2,
    O_RC1                  OUT SYS_REFCURSOR,
    O_RESULT_CURSOR        OUT SYS_REFCURSOR
);

PROCEDURE P_SYS0017_GET_SQL_LONG_TEXT
(
    P_USE_TYPE             IN  VARCHAR2,
    P_MODULE               IN  VARCHAR2,
    P_SUBMODULE            IN  VARCHAR2,
    P_CATEGORY_ID          IN  VARCHAR2,
    O_RC1                  OUT SYS_REFCURSOR,
    O_RESULT_CURSOR        OUT SYS_REFCURSOR
);

PROCEDURE P_SYS0017_SAVE_RECIPIENT_MASTER
(
    P_ACTIVE_FLAG          IN  VARCHAR2,
    P_USE_TYPE             IN  VARCHAR2,
    P_MODULE               IN  VARCHAR2,
    P_SUBMODULE            IN  VARCHAR2,
    P_CATEGORY_ID          IN  VARCHAR2,
    P_CATEGORY_DESC        IN  VARCHAR2,
    P_CYCLE_CLASS_CODE     IN  VARCHAR2,
    P_DETAIL_CLASS_CODE    IN  VARCHAR2,
    P_SEND_TIME_TEXT       IN  VARCHAR2,
    P_SEND_MIN_TIME_TEXT   IN  VARCHAR2,
    P_ACTIVE               IN  VARCHAR2,
    P_CREATED_BY           IN  VARCHAR2,
    P_CREATION_DATE        IN  VARCHAR2,
    P_LAST_UPDATED_BY      IN  VARCHAR2,
    O_RC1                  OUT SYS_REFCURSOR,
    O_RESULT_CURSOR        OUT SYS_REFCURSOR
);

PROCEDURE P_SYS0017_SAVE_RECIPIENT_MESSAGE
(
    P_ACTIVE_FLAG          IN  VARCHAR2,
    P_USE_TYPE             IN  VARCHAR2,
    P_CATEGORY_ID          IN  VARCHAR2,
    P_LANGUAGE             IN  VARCHAR2,
    P_TITLE                IN  VARCHAR2,
    P_CONTENT              IN  VARCHAR2,
    P_CREATED_BY           IN  VARCHAR2,
    P_CREATION_DATE        IN  VARCHAR2,
    P_LAST_UPDATED_BY      IN  VARCHAR2,
    O_RC1                  OUT SYS_REFCURSOR,
    O_RESULT_CURSOR        OUT SYS_REFCURSOR
);

PROCEDURE P_SYS0017_SAVE_RECIPIENT_ASSIGN
(
    P_ACTIVE_FLAG          IN  VARCHAR2,
    P_USE_TYPE             IN  VARCHAR2,
    P_CATEGORY_ID          IN  VARCHAR2,
    P_USER_ID              IN  VARCHAR2,
    P_CREATED_BY           IN  VARCHAR2,
    P_CREATION_DATE        IN  VARCHAR2,
    P_LAST_UPDATED_BY      IN  VARCHAR2,
    O_RESULT_CURSOR        OUT SYS_REFCURSOR
);

PROCEDURE P_SYS0017_SAVE_RECIPIENT_MASTER_U
(
    P_USE_TYPE             IN  VARCHAR2,
    P_MODULE               IN  VARCHAR2,
    P_SUBMODULE            IN  VARCHAR2,
    P_CATEGORY_ID          IN  VARCHAR2,
    P_SQL                  IN  VARCHAR2,
    P_LAST_UPDATED_BY      IN  VARCHAR2,
    O_RC1                  OUT SYS_REFCURSOR,
    O_RESULT_CURSOR        OUT SYS_REFCURSOR
);

END PKG_SYS0017;
/
