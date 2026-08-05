PROCEDURE         PR_SCM_ADM_NOTICE_MASTER_HIST

(
    P_MODULE            VARCHAR2
   ,P_SUBMODULE         VARCHAR2
   ,P_NOTICE_ID         VARCHAR2
   ,P_NOTICE_DESC       VARCHAR2
   ,P_CYCLE_CLASS_CODE  VARCHAR2
   ,P_DETAIL_CLASS_CODE VARCHAR2
   ,P_SEND_TIME_TEXT    VARCHAR2
   ,P_ACTIVE            VARCHAR2
   ,P_SQL_LONG_TEXT     VARCHAR2
   ,P_CREATED_BY        VARCHAR2
   ,P_CREATION_DATE     VARCHAR2
   ,P_LAST_UPDATED_BY   VARCHAR2
)
/*
    * Program ID   : PR_SCM_ADM_NOTICE_MASTER_HIST
    * Description  : NOTICE Master History
    * Program History
    *===================================================================================================
    *   Date       In Charge      Description
    *===================================================================================================
    * 2018.02.22   ygkim         Initial Release PJ20170278 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
    * 2026.03.24   김준규          [PJ20264226] NextSCM Pilot 설계 및 개발
    */
 AS

    V_IN_PARA_DATA VARCHAR2(4000 CHAR);
    N_HISTORY_SEQ  INTEGER;
    V_PROGRAM_NAME VARCHAR2(200 CHAR) := $$PLSQL_UNIT;
    V_STEP         VARCHAR2(4000 CHAR) := NULL;
    V_LOG_TYPE     VARCHAR2(30 CHAR);
    N_LOG_COUNT    INTEGER := 0;
    V_LOG_MESSAGE  VARCHAR2(1000 CHAR);
    V_DESCRIPTION  VARCHAR2(500 CHAR);
    D_EVENT_DATE   DATE;
    V_CREATION_DATE DATE := TO_DATE(P_CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS');
BEGIN

    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1) (2);
    END IF;

    V_IN_PARA_DATA := JSON_OBJECT('p_module' VALUE P_MODULE
                                 ,'p_submodule' VALUE P_SUBMODULE
                                 ,'p_notice_id' VALUE P_NOTICE_ID
                                 ,'p_notice_desc' VALUE P_NOTICE_DESC
                                 ,'p_cycle_class_code' VALUE P_CYCLE_CLASS_CODE
                                 ,'p_detail_class_code' VALUE P_DETAIL_CLASS_CODE
                                 ,'p_send_time_text' VALUE P_SEND_TIME_TEXT
                                 ,'p_active' VALUE P_ACTIVE
                                 ,'p_sql_long_text' VALUE P_SQL_LONG_TEXT
                                 ,'p_created_by' VALUE P_CREATED_BY
                                 ,'p_creation_date' VALUE P_CREATION_DATE
                                 ,'p_last_updated_by' VALUE P_LAST_UPDATED_BY);

    /* 시작 LOG */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := NULL;
    D_EVENT_DATE  := SYSTIMESTAMP;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

    BEGIN
        N_HISTORY_SEQ := SEQ1_SCM_ADM_NOTICE_MASTER_H.NEXTVAL;

        BEGIN
            INSERT
              INTO SCM_ADM_NOTICE_MASTER_H
                 ( HISTORY_SEQ
                 , NOTICE_ID
                 , SUB_MODULE_CODE
                 , MODULE_CODE
                 , NOTICE_TITLE
                 , CYCLE_CLASS_CODE
                 , DETAIL_CLASS_CODE
                 , SEND_TIME_TEXT
                 , VALID_YN
                 , SQL_LONG_TEXT
                 , CREATED_BY
                 , CREATION_DATE
                 , LAST_UPDATED_BY
                 , LAST_UPDATE_DATE )
            VALUES ( N_HISTORY_SEQ
                   , P_NOTICE_ID
                   , P_SUBMODULE
                   , P_MODULE
                   , P_NOTICE_DESC
                   , P_CYCLE_CLASS_CODE
                   , P_DETAIL_CLASS_CODE
                   , P_SEND_TIME_TEXT
                   , P_ACTIVE
                   , P_SQL_LONG_TEXT
                   , P_CREATED_BY
                   , V_CREATION_DATE      /* P_CREATION_DATE */
                   , P_LAST_UPDATED_BY
                   , SYSTIMESTAMP );
        END;
    END;

    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := NULL;
    D_EVENT_DATE  := SYSTIMESTAMP;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

    COMMIT;

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
        RAISE_APPLICATION_ERROR(-20001
                               ,'[' || V_PROGRAM_NAME || '] SQLCODE=' || SQLCODE || ' / SQLERRM=' || SQLERRM || ' / BACKTRACE=' ||
                                DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' / PARAMS=' || V_IN_PARA_DATA);
END;