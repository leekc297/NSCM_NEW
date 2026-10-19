PACKAGE PKG_SCP0030
IS
/*
 * Program ID   : PKG_SCP0030
 * Description  : BOD ITEM (SCP > Master > BOD ITEM)
 * Program History
 *===================================================================================================
 *   Date        Description
 *===================================================================================================
 * 2026.09.11    신규 변환
 * 2026.09.17    AS-IS 원문 재대조 결함 조치 — 날짜 칸 형식 · 대소문자 무시 비교 · 공백 입력 · 비활성 품목 판정 ·
 *               신규 행 중복 검사 · 이력 적재 · 빈 값 형변환 · 온라인 SQL 표준(MERGE·ANSI 조인 제거)
 *===================================================================================================
 */

    /* BOD ITEM 조회 (AS-IS SCP0030_GET_BOD_ITEM) */
    PROCEDURE P_SCP0030_GET_BOD_ITEM
    (
        P_DIVISION_ID     IN  VARCHAR2
      , P_FROM_SITE       IN  VARCHAR2
      , P_TO_SITE         IN  VARCHAR2
      , P_INCOTERMS       IN  VARCHAR2
      , P_TRANS_MODE      IN  VARCHAR2
      , P_ITEM_ID         IN  VARCHAR2
      , P_NICK_NAME       IN  VARCHAR2
      , P_VALID           IN  VARCHAR2
      , P_USER_ID         IN  VARCHAR2
      , P_MENU_ID         IN  VARCHAR2
      , O_RC1             OUT SYS_REFCURSOR
      , O_RESULT_CURSOR   OUT SYS_REFCURSOR
    );

    /* Excluded Item 조회 (AS-IS SCP0030_GET_BOD_EXCLUDED_ITEM) */
    PROCEDURE P_SCP0030_GET_BOD_EXCLUDED_ITEM
    (
        P_DIVISION_ID     IN  VARCHAR2
      , P_FROM_SITE       IN  VARCHAR2
      , P_TO_SITE         IN  VARCHAR2
      , P_INCOTERMS       IN  VARCHAR2
      , P_TRANS_MODE      IN  VARCHAR2
      , P_ITEM_ID         IN  VARCHAR2
      , P_NICK_NAME       IN  VARCHAR2
      , P_VALID           IN  VARCHAR2
      , P_PLAN_GROUP_ID   IN  VARCHAR2
      , P_USER_ID         IN  VARCHAR2
      , P_MENU_ID         IN  VARCHAR2
      , O_RC1             OUT SYS_REFCURSOR
      , O_RESULT_CURSOR   OUT SYS_REFCURSOR
    );

    /* BOD ITEM 등록·수정 (AS-IS SCP0030_SAVE_BOD_ITEM) */
    PROCEDURE P_SCP0030_SAVE_BOD_ITEM
    (
        P_DATA            IN  CLOB
      , P_USER_ID         IN  VARCHAR2
      , O_RESULT_CURSOR   OUT SYS_REFCURSOR
    );

    /* Excluded Item 등록·수정·삭제 (AS-IS SCP0030_SAVE_BOD_EXCLUDED_ITEM) */
    PROCEDURE P_SCP0030_SAVE_BOD_EXCLUDED_ITEM
    (
        P_DATA            IN  CLOB
      , P_USER_ID         IN  VARCHAR2
      , O_RESULT_CURSOR   OUT SYS_REFCURSOR
    );

    PROCEDURE P_SCP0030_GET_BOD_POPUP
    (
        P_DIVISION_ID           IN  VARCHAR2
      , P_ITEM_ID               IN  VARCHAR2
      , O_RC1                   OUT SYS_REFCURSOR
      , O_RESULT_CURSOR         OUT SYS_REFCURSOR
    );

END PKG_SCP0030;