PACKAGE ZT_PKG_SCP0027
AS
/****************************************************************************************************/
/* Program ID  : PKG_SCP0027                                                                        */
/* Description : ProjectRoute Electrode                                                             */
/* Program History                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2026.09.24  ZIONEX       [PJ202650304] MSSQL -> Oracle 전환                                      */
/****************************************************************************************************/

    /* Project Route Plant Site(Electrode) 조회 */
    PROCEDURE P_SCP0027_GET_PROJECTROUTE_ELECTRODE
    (
        P_DIVISION_ID       IN  VARCHAR2
      , P_PLANT_SITE        IN  VARCHAR2
      , P_OPERATION_GROUP   IN  VARCHAR2
      , P_ITEM_ID           IN  VARCHAR2
      , P_FROM_YYYYMM       IN  VARCHAR2
      , P_TO_YYYYMM         IN  VARCHAR2
      , P_VALID_FLAG        IN  VARCHAR2
      , O_MAIN_LIST         OUT SYS_REFCURSOR
      , O_ALL_LIST          OUT SYS_REFCURSOR
      , O_ITEM_LIST         OUT SYS_REFCURSOR
      , O_RESULT_CODE       OUT VARCHAR2
      , O_RESULT_MSG        OUT VARCHAR2
    );

    /* Project Route Plant Site 등록 · 수정 */
    PROCEDURE P_SCP0027_SAVE_PROJECTROUTE_ELECTRODE
    (
        P_ACTIVE_FLAG       IN  CLOB
      , P_PRIORITY_SEQ      IN  CLOB
      , P_DIVISION_ID       IN  CLOB
      , P_PROJECT_CODE      IN  CLOB
      , P_SCM_SITE_ID       IN  CLOB
      , P_PLANT_SITE_ID     IN  CLOB
      , P_ITEM_ID           IN  CLOB
      , P_CREATED_BY        IN  CLOB
      , P_CREATION_DATE     IN  CLOB
      , P_LAST_UPDATED_BY   IN  CLOB
      , P_PRIORITY          IN  CLOB
      , P_FROM_YYYYMMDD     IN  CLOB
      , P_TO_YYYYMMDD       IN  CLOB
      , P_VALID_YN          IN  CLOB
      , P_DEBUG_MODE        IN  VARCHAR2 DEFAULT 'F'
      , O_RESULT_CODE       OUT VARCHAR2
      , O_RESULT_CNT        OUT NUMBER
      , O_RESULT_MSG        OUT VARCHAR2
    );

END ZT_PKG_SCP0027;