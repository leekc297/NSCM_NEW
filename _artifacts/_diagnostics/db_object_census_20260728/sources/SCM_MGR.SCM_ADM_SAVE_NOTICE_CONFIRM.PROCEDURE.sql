PROCEDURE SCM_ADM_SAVE_NOTICE_CONFIRM
(
    P_NOTICE_ID INTEGER,
    P_USER_ID   VARCHAR2
)
/*
 * Program ID   : SCM_ADM_SAVE_NOTICE_CONFIRM
 * Description  : 공지 사항 확인
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/02/26   ygkim   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2026.03.24   김준규          [PJ20264226] NextSCM Pilot 설계 및 개발 : 예외 강화로깅(JSON 입력캡처 + 10인자 로깅, 흡수)
 * 2026.07.06   ZIONEX   [PJ202650304] NextSCM Migration
 */
AS

    V_COUNT        INTEGER;
    D_DATE         DATE;

    /* LOG 용 변수 설정 */
    V_PROGRAM_NAME VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
    V_LOG_TYPE     VARCHAR2(30 CHAR); /* START/END/ERROR/... */
    N_LOG_COUNT    INTEGER := 0;
    V_LOG_MESSAGE  VARCHAR2(1000 CHAR);
    V_DESCRIPTION  VARCHAR2(500 CHAR);
    D_EVENT_DATE   DATE;
    V_IN_PARA_DATA VARCHAR2(4000 CHAR);
BEGIN

    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1) (2);
    END IF;

    V_IN_PARA_DATA := JSON_OBJECT('p_notice_id' VALUE P_NOTICE_ID, 'p_user_id' VALUE P_USER_ID);

    /* 시작 LOG */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := NULL;
    D_EVENT_DATE  := SYSDATE;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

    D_DATE := SYSDATE;

    /* HISTORY INSERT */
    PR_SCM_ADM_NOTICE_CONFIRM_HIST(P_NOTICE_ID
                                  ,P_USER_ID
                                  ,P_USER_ID
                                  ,TO_CHAR(D_DATE, 'YYYY-MM-DD HH24:MI:SS')
                                  ,P_USER_ID);

    SELECT COUNT(*)
      INTO V_COUNT
      FROM SCM_ADM_NOTICE_CONFIRM A
     WHERE A.NOTICE_ID = P_NOTICE_ID
       AND UPPER(A.USER_ID) = UPPER(P_USER_ID);

    IF (V_COUNT = 0) THEN
        INSERT
          INTO SCM_ADM_NOTICE_CONFIRM
             ( NOTICE_ID
             , USER_ID
             , CREATED_BY        /* 최초등록자번호 */
             , CREATION_DATE     /* 최초등록일시 */
             , LAST_UPDATED_BY   /* 최종변경자번호 */
             , LAST_UPDATE_DATE )/* 최종변경일시 */
        VALUES ( P_NOTICE_ID
               , P_USER_ID
               , P_USER_ID
               , D_DATE
               , P_USER_ID
               , D_DATE );
    END IF;

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