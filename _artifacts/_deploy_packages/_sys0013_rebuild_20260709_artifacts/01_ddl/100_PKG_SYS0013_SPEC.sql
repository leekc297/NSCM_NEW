CREATE OR REPLACE PACKAGE           "PKG_SYS0013" 
/*
 * Program ID   : PKG_SYS0013
 * Description  : PKG_DMF0207
 * Program History
 *===========================================================================================================
 *   Date       In Charge      Description
 *===========================================================================================================
 * 2026.03.24   jcnam       [PJ20264226] NextSCM Pilot 설계 및 개발
 *                          UI 항목으로 Package로 전환
 * 2026.07.09   claude      [SYS0013 재개발] standalone 4종 PKG 흡수(GET_HISTORY/SAVE·DELETE_USER_GROUP/EXECUTE_HIST)
 *                          + P_SYS0013_VALIDATE_QUERY 신설 + SAVE 3종 _H 이력 보강(D1)
 */
AS
    -- 프로시저 선언

    PROCEDURE P_SYS0013_EXECUTE_QUERY
    (
        P_SQL_TEXT        IN  VARCHAR2,
        O_RC1             OUT SYS_REFCURSOR,
        O_RESULT_CURSOR   OUT SYS_REFCURSOR
    );

    PROCEDURE P_SYS0013_GET_DYNAMIC_QUERYS
    (
        P_SQL_TEXT        IN  VARCHAR2,
        O_RC1             OUT SYS_REFCURSOR,
        O_RESULT_CURSOR   OUT SYS_REFCURSOR
    );

    PROCEDURE P_SYS0013_GET_ROLE_DATA
    (
        O_RC1             OUT SYS_REFCURSOR,
        O_RESULT_CURSOR   OUT SYS_REFCURSOR
    );

    PROCEDURE P_SYS0013_GET_PARAMETERS
    (
        P_DQ_ID           IN  VARCHAR2,
        O_RC1             OUT SYS_REFCURSOR,
        O_RESULT_CURSOR   OUT SYS_REFCURSOR
    );

    PROCEDURE P_SYS0013_GET_QUERY_LIST_COMMON
    (
        P_NICKNAME        IN  VARCHAR2,
        O_RC1             OUT SYS_REFCURSOR,
        O_RESULT_CURSOR   OUT SYS_REFCURSOR
    );

    PROCEDURE P_SYS0013_GET_QUERY_LIST
    (
        P_DQ_ID              IN VARCHAR2,
        P_DQ_NAME            IN VARCHAR2,
        P_ROLE               IN VARCHAR2,
        P_USER_ID         IN VARCHAR2, -- For EditYn
        P_MNU_ID          IN VARCHAR2, -- For EditYn
        O_RC1                OUT SYS_REFCURSOR,
        O_RESULT_CURSOR      OUT SYS_REFCURSOR
    );

    PROCEDURE P_SYS0013_GET_COLUMNS
    (
        P_DQ_ID              IN VARCHAR2,
        O_RC1                OUT SYS_REFCURSOR,
        O_RESULT_CURSOR      OUT SYS_REFCURSOR
    );





  PROCEDURE P_SYS0013_SAVE_QUERY_LIST
  (
    P_DATA          IN  CLOB,
    P_USER_ID       IN  VARCHAR2,
    O_RC1           OUT SYS_REFCURSOR,
    O_RESULT_CURSOR OUT SYS_REFCURSOR
  );


  PROCEDURE P_SYS0013_SAVE_COLUMNS
  (
    P_DATA          IN  CLOB,
    P_USER_ID       IN  VARCHAR2,
    O_RC1           OUT SYS_REFCURSOR,
    O_RESULT_CURSOR OUT SYS_REFCURSOR
  );

  PROCEDURE P_SYS0013_SAVE_PARAMETERS
  (
    P_DATA          IN  CLOB,
    P_USER_ID       IN  VARCHAR2,
    O_RC1           OUT SYS_REFCURSOR,
    O_RESULT_CURSOR OUT SYS_REFCURSOR
  );

  -- [2026-07-09] PKG 통합 — standalone 흡수 4종 + 신규 VALIDATE (D2)

  PROCEDURE P_SYS0013_GET_HISTORY
  (
    P_DQ_ID           IN  VARCHAR2,
    P_USER_ID         IN  VARCHAR2,
    P_MNU_ID          IN  VARCHAR2,
    O_RC1             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
  );

  PROCEDURE P_SYS0013_SAVE_USER_GROUP
  (
    P_DQ_ID             IN VARCHAR2,
    P_GROUP_ID          IN VARCHAR2,
    P_VALID_YN          IN VARCHAR2,
    P_CREATED_BY        IN VARCHAR2,
    P_LAST_UPDATED_BY   IN VARCHAR2,
    O_RC1               OUT SYS_REFCURSOR
  );

  PROCEDURE P_SYS0013_DELETE_USER_GROUP
  (
    P_DQ_ID             IN VARCHAR2,
    P_LAST_UPDATED_BY   IN VARCHAR2,
    O_RC1               OUT SYS_REFCURSOR
  );

  PROCEDURE P_SYS0013_EXECUTE_HIST
  (
    P_DQ_ID             IN VARCHAR2,
    P_DQ_TEXT           IN CLOB,
    P_CREATED_BY        IN VARCHAR2,
    P_LAST_UPDATED_BY   IN VARCHAR2,
    O_RC1               OUT SYS_REFCURSOR
  );

  PROCEDURE P_SYS0013_VALIDATE_QUERY
  (
    P_SQL_TEXT        IN  CLOB,
    O_RC1             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
  );

END PKG_SYS0013;
/

