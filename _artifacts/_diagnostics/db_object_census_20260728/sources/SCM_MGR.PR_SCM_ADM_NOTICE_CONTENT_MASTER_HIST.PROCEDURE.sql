PROCEDURE PR_SCM_ADM_NOTICE_CONTENT_MASTER_HIST
(
    P_NOTICE_ID       VARCHAR2
  , P_LANGUAGE        VARCHAR2
  , P_TITLE           VARCHAR2
  , P_CONTENT         VARCHAR2
  , P_CREATED_BY      VARCHAR2
  , P_CREATION_DATE   VARCHAR2
  , P_LAST_UPDATED_BY VARCHAR2
)
/*
 * Program ID   : PR_SCM_ADM_NOTICE_CONTENT_MASTER_HIST
 * Description  : NOTICE Message History
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.02.22   ygkim      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2026.07.06   ZIONEX   [PJ202650304] NextSCM Migration
 *
 */
AS
    N_HISTORY_SEQ   INTEGER;

    /* LOG 용 변수 설정 */
    V_PROGRAM_NAME  VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
    V_LOG_TYPE      VARCHAR2(30 CHAR); /* START/END/ERROR/... */
    N_LOG_COUNT     INTEGER := 0;
    V_LOG_MESSAGE   VARCHAR2(1000 CHAR);
    V_DESCRIPTION   VARCHAR2(500 CHAR);
    D_EVENT_DATE    DATE;
    V_IN_PARA_DATA  VARCHAR2(4000 CHAR);

    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(100 CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);
BEGIN

    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1) (2);
    END IF;

    V_IN_PARA_DATA := JSON_OBJECT('P_NOTICE_ID' VALUE P_NOTICE_ID
                                 ,'P_LANGUAGE' VALUE P_LANGUAGE
                                 ,'P_TITLE' VALUE P_TITLE
                                 ,'P_CONTENT' VALUE P_CONTENT
                                 ,'P_CREATED_BY' VALUE P_CREATED_BY
                                 ,'P_CREATION_DATE' VALUE P_CREATION_DATE
                                 ,'P_LAST_UPDATED_BY' VALUE P_LAST_UPDATED_BY
                                  RETURNING VARCHAR2(4000 CHAR));

    /* 시작 LOG */
    V_LOG_TYPE := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := NULL;
    D_EVENT_DATE := SYSDATE;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

    BEGIN
        SELECT SEQ1_SCM_ADM_NOTICE_CONTENT_MASTER_H.NEXTVAL
          INTO N_HISTORY_SEQ
          FROM DUAL;

        BEGIN
            INSERT
              INTO SCM_ADM_NOTICE_CONTENT_MASTER_H
                 ( HISTORY_SEQ
                 , NOTICE_ID
                 , LANGUAGE_CODE
                 , NOTICE_TITLE
                 , NOTICE_CONTENT
                 , CREATED_BY
                 , CREATION_DATE
                 , LAST_UPDATED_BY
                 , LAST_UPDATE_DATE )
            VALUES ( N_HISTORY_SEQ
                   , P_NOTICE_ID
                   , P_LANGUAGE
                   , P_TITLE
                   , P_CONTENT
                   , P_CREATED_BY
                   , P_CREATION_DATE
                   , P_LAST_UPDATED_BY
                   , SYSDATE );
        END;
    END;

    /* 종료 LOG */
    V_LOG_TYPE := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := NULL;
    D_EVENT_DATE := SYSDATE;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME
                            ,'ERROR'
                            ,0
                            ,SQLERRM
                            ,NULL
                            ,SYSDATE
                            ,P_IN_PARA_DATA  => V_IN_PARA_DATA
                            ,P_SQL_ERR_CODE  => SQLCODE
                            ,P_SQL_ERR_MSG   => SQLERRM
                            ,P_SQL_BACKTRACE => DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);

END;