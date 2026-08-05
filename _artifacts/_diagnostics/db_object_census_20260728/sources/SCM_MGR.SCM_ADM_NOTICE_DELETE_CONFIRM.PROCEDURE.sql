PROCEDURE SCM_ADM_NOTICE_DELETE_CONFIRM
/*
 * Program ID   : SCM_ADM_NOTICE_DELETE_CONFIRM
 * Description  : 로그는 15일치만 관리함
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/02/23   ygkim   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2026.03.24   김준규   [PJ20264226] NextSCM Pilot 설계 및 개발
 * 2026.07.06   ZIONEX   [PJ202650304] NextSCM Migration
 *
 */
AS

    /* LOG 용 변수 설정 */
    V_PROGRAM_NAME VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
    V_LOG_TYPE     VARCHAR2(30 CHAR);
    N_LOG_COUNT    INTEGER := 0;
    V_LOG_MESSAGE  VARCHAR2(1000 CHAR);
    V_DESCRIPTION  VARCHAR2(500 CHAR);
    D_EVENT_DATE   DATE;
    V_IN_PARA_DATA VARCHAR2(4000 CHAR);

BEGIN

    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1) (2);
    END IF;

    V_IN_PARA_DATA := NULL;

    /* 시작 LOG */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := NULL;
    D_EVENT_DATE  := SYSDATE;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

    BEGIN
        DELETE
          FROM SCM_ADM_NOTICE_CONFIRM
         WHERE CREATION_DATE < SYSDATE - 15;
    END;

    /* 종료 LOG */
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := NULL;
    D_EVENT_DATE  := SYSDATE;
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

END;