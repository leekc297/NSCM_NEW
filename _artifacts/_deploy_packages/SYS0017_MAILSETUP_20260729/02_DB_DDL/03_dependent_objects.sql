-- 03_dependent_objects.sql — 이력 SP 3 + 공용 함수 3 (PKG_SYS0017 실행 의존)


-- ===== PR_SCM_ADM_RECIPIENT_LIST_HIST =====

  CREATE OR REPLACE EDITIONABLE PROCEDURE "SCM_MGR"."PR_SCM_ADM_RECIPIENT_LIST_HIST" 

(
    P_USE_TYPE           VARCHAR2
   ,P_MODULE             VARCHAR2
   ,P_SUBMODULE          VARCHAR2
   ,P_CATEGORY_ID        VARCHAR2
   ,P_CATEGORY_DESC      VARCHAR2
   ,P_CYCLE_CLASS_CODE   VARCHAR2
   ,P_DETAIL_CLASS_CODE  VARCHAR2
   ,P_SEND_TIME_TEXT     VARCHAR2
   ,P_SEND_MIN_TIME_TEXT VARCHAR2
   ,P_ACTIVE             VARCHAR2
   ,P_SQL_LONG_TEXT      VARCHAR2
   ,P_CREATED_BY         VARCHAR2
   ,P_CREATION_DATE      VARCHAR2
   ,P_LAST_UPDATED_BY    VARCHAR2
)
/*
    * Program ID   : PR_SCM_ADM_RECIPIENT_LIST_HIST
    * Description  : SMS/MAIL 수신자 Master History
    * Program History
    *===================================================================================================
    *   Date       In Charge      Description
    *===================================================================================================
    * 2018.01.29   ygkim      Initial Release PJ20170278 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
    * 2018/10/15 hwyoon       메일링 분단위 발송 추가
    * 2026.03.24 김준규    [PJ20264226] NextSCM Pilot 설계 및 개발
    */
 AS

    V_IN_PARA_DATA  VARCHAR2(4000 CHAR);
    N_HISTORY_SEQ   INTEGER;
    V_PROGRAM_NAME  VARCHAR2(200 CHAR) := $$PLSQL_UNIT;
    V_STEP          VARCHAR2(4000 CHAR) := NULL;
    V_LOG_TYPE      VARCHAR2(30 CHAR);
    N_LOG_COUNT     INTEGER := 0;
    V_LOG_MESSAGE   VARCHAR2(1000 CHAR);
    V_DESCRIPTION   VARCHAR2(500 CHAR);
    D_EVENT_DATE    DATE;
    V_CREATION_DATE DATE := TO_DATE(P_CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS');

BEGIN

    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1) (2);
    END IF;

    V_IN_PARA_DATA := JSON_OBJECT('p_use_type' VALUE P_USE_TYPE
                                 ,'p_module' VALUE P_MODULE
                                 ,'p_submodule' VALUE P_SUBMODULE
                                 ,'p_category_id' VALUE P_CATEGORY_ID
                                 ,'p_category_desc' VALUE P_CATEGORY_DESC
                                 ,'p_cycle_class_code' VALUE P_CYCLE_CLASS_CODE
                                 ,'p_detail_class_code' VALUE P_DETAIL_CLASS_CODE
                                 ,'p_send_time_text' VALUE P_SEND_TIME_TEXT
                                 ,'p_send_min_time_text' VALUE P_SEND_MIN_TIME_TEXT
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
        N_HISTORY_SEQ := SEQ1_SCM_ADM_RECIPIENT_LIST_H.NEXTVAL;

        BEGIN
            INSERT
              INTO SCM_ADM_RECIPIENT_LIST_H
                 ( HISTORY_SEQ
                 , USE_TYPE_CODE
                 , CATEGORY_ID
                 , SUB_MODULE_CODE
                 , MODULE_CODE
                 , CATEGORY_DESC
                 , CYCLE_CLASS_CODE
                 , DETAIL_CLASS_CODE
                 , SEND_TIME_TEXT
                 , SEND_MIN_TIME_TEXT
                 , VALID_YN
                 , SQL_LONG_TEXT
                 , CREATED_BY
                 , CREATION_DATE
                 , LAST_UPDATED_BY
                 , LAST_UPDATE_DATE )
            VALUES
                 ( N_HISTORY_SEQ
                 , P_USE_TYPE
                 , P_CATEGORY_ID
                 , P_SUBMODULE
                 , P_MODULE
                 , P_CATEGORY_DESC
                 , P_CYCLE_CLASS_CODE
                 , P_DETAIL_CLASS_CODE
                 , P_SEND_TIME_TEXT
                 , P_SEND_MIN_TIME_TEXT
                 , P_ACTIVE
                 , P_SQL_LONG_TEXT
                 , P_CREATED_BY
                 , V_CREATION_DATE  /* P_CREATION_DATE */
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
/

-- ===== PR_SCM_ADM_RECIPIENT_MESSAGE_HIST =====

  CREATE OR REPLACE EDITIONABLE PROCEDURE "SCM_MGR"."PR_SCM_ADM_RECIPIENT_MESSAGE_HIST" 

(
    P_USE_TYPE                IN VARCHAR2
  , P_CATEGORY_ID            IN VARCHAR2
  , P_LANGUAGE             IN VARCHAR2
  , P_TITLE                 IN VARCHAR2
  , P_CONTENT                 IN VARCHAR2
  , P_CREATED_BY            IN VARCHAR2
  , P_CREATION_DATE        IN VARCHAR2
  , P_LAST_UPDATED_BY        IN VARCHAR2
)
/*
 * Program ID   : PR_SCM_ADM_RECIPIENT_MESSAGE_HIST
 * Description  : SMS/MAIL 수신자 Message History
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.02.20   ygkim      Initial Release PJ20170278 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2026.05.21  최용훈           MS-SQL -> Oracle 변환
 *
 */

/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2026.05.21  최용훈       MS-SQL -> Oracle 변환                                  */
/*                                                                                                  */
/****************************************************************************************************/
AS
    N_HISTORY_SEQ INTEGER;
    V_PROGRAM_NAME VARCHAR2(150 CHAR) := 'PR_SCM_ADM_RECIPIENT_MESSAGE_HIST';
    V_LOG_TYPE VARCHAR2(30 CHAR);
    V_LOG_MESSAGE VARCHAR2(1000 CHAR);
    V_DESCRIPTION VARCHAR2(500 CHAR);
    D_EVENT_DATE DATE;

    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(100 CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);
    N_LOG_COUNT     PLS_INTEGER := 0;
BEGIN

    /* 시작 LOG */
    V_LOG_TYPE := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := NULL;
    D_EVENT_DATE := SYSTIMESTAMP;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

    BEGIN
        SELECT SEQ1_SCM_ADM_RECIPIENT_MESSAGE_H.NEXTVAL
          INTO N_HISTORY_SEQ
          FROM DUAL;

        BEGIN
            INSERT
              INTO SCM_ADM_RECIPIENT_MESSAGE_H
                 ( HISTORY_SEQ
                 , USE_TYPE_CODE
                 , CATEGORY_ID
                 , LANGUAGE_CODE
                 , MAIL_TITLE
                 , MESSAGE_CONTENT
                 , CREATED_BY        /* 최초등록자번호 */
                 , CREATION_DATE     /* 최초등록일시 */
                 , LAST_UPDATED_BY   /* 최종변경자번호 */
                 , LAST_UPDATE_DATE ) /* 최종변경일시 */
            VALUES ( N_HISTORY_SEQ
                   , P_USE_TYPE
                   , P_CATEGORY_ID
                   , P_LANGUAGE
                   , P_TITLE
                   , P_CONTENT
                   , P_CREATED_BY
                   , P_CREATION_DATE
                   , P_LAST_UPDATED_BY
                   , SYSTIMESTAMP );
        END;
    END;

    V_LOG_TYPE := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := NULL;
    D_EVENT_DATE := SYSTIMESTAMP;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        V_SQL_CODE := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SQLERRM;
        V_PROC_INPUT := JSON_OBJECT(
            'P_USE_TYPE' VALUE P_USE_TYPE
          , 'P_CATEGORY_ID' VALUE P_CATEGORY_ID
          , 'P_LANGUAGE' VALUE P_LANGUAGE
          , 'P_TITLE' VALUE P_TITLE
          , 'P_CONTENT' VALUE P_CONTENT
          , 'P_CREATED_BY' VALUE P_CREATED_BY
          , 'P_CREATION_DATE' VALUE P_CREATION_DATE
          , 'P_LAST_UPDATED_BY' VALUE P_LAST_UPDATED_BY
        );
        V_BACKTRACE := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                $$PLSQL_UNIT, 'ERROR', N_LOG_COUNT, 'EXCEPTION'
              , '', SYSDATE, V_PROC_INPUT
              , V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        RAISE_APPLICATION_ERROR(-20001
          , '[' ||$$PLSQL_UNIT||'] SQLCODE=' ||V_SQL_CODE||
            ' / SQLERRM=' ||V_SQL_ERRMSG||
            ' / BACKTRACE=' ||V_BACKTRACE||
            ' / PARAMS=' ||V_PROC_INPUT
        );
        RAISE;

END PR_SCM_ADM_RECIPIENT_MESSAGE_HIST;
/

-- ===== PR_SCM_ADM_RECIPIENT_ASSIGN_HIST =====

  CREATE OR REPLACE EDITIONABLE PROCEDURE "SCM_MGR"."PR_SCM_ADM_RECIPIENT_ASSIGN_HIST" 

(
    P_USE_TYPE        IN VARCHAR2
  , P_CATEGORY_ID     IN VARCHAR2
  , P_USER_ID         IN VARCHAR2
  , P_CREATED_BY      IN VARCHAR2
  , P_CREATION_DATE   IN VARCHAR2
  , P_LAST_UPDATED_BY IN VARCHAR2
)
/*
 * Program ID   : PR_SCM_ADM_RECIPIENT_ASSIGN_HIST
 * Description  : SMS/MAIL 수신자 History
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.02.20   ygkim      Initial Release PJ20170278 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2026.05.21  최용훈           MS-SQL -> Oracle 변환
 *
 */
AS
    N_HISTORY_SEQ INTEGER;
    V_PROGRAM_NAME VARCHAR2(150 CHAR) := 'PR_SCM_ADM_RECIPIENT_ASSIGN_HIST';
    V_LOG_TYPE VARCHAR2(30 CHAR);
    V_LOG_MESSAGE VARCHAR2(1000 CHAR);
    V_DESCRIPTION VARCHAR2(500 CHAR);
    D_EVENT_DATE DATE;

    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(100 CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);
    N_LOG_COUNT     PLS_INTEGER := 0;
BEGIN

    /* 시작 LOG */
    V_LOG_TYPE := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := NULL;
    D_EVENT_DATE := SYSTIMESTAMP;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

    BEGIN
        SELECT SEQ1_SCM_ADM_RECIPIENT_ASSIGN_H.NEXTVAL
          INTO N_HISTORY_SEQ
          FROM DUAL;

        BEGIN
            INSERT
              INTO SCM_ADM_RECIPIENT_ASSIGN_H
                 ( HISTORY_SEQ
                 , USE_TYPE_CODE
                 , CATEGORY_ID
                 , USER_ID
                 , CREATED_BY        /* 최초등록자번호 */
                 , CREATION_DATE     /* 최초등록일시 */
                 , LAST_UPDATED_BY   /* 최종변경자번호 */
                 , LAST_UPDATE_DATE ) /* 최종변경일시 */
            VALUES ( N_HISTORY_SEQ
                   , P_USE_TYPE
                   , P_CATEGORY_ID
                   , P_USER_ID
                   , P_CREATED_BY
                   , P_CREATION_DATE
                   , P_LAST_UPDATED_BY
                   , SYSTIMESTAMP );
        END;
    END;

    V_LOG_TYPE := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := NULL;
    D_EVENT_DATE := SYSTIMESTAMP;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        V_SQL_CODE := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SQLERRM;
        V_PROC_INPUT := JSON_OBJECT(
            'P_USE_TYPE' VALUE P_USE_TYPE
          , 'P_CATEGORY_ID' VALUE P_CATEGORY_ID
          , 'P_USER_ID' VALUE P_USER_ID
          , 'P_CREATED_BY' VALUE P_CREATED_BY
          , 'P_CREATION_DATE' VALUE P_CREATION_DATE
          , 'P_LAST_UPDATED_BY' VALUE P_LAST_UPDATED_BY
        );
        V_BACKTRACE := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                $$PLSQL_UNIT, 'ERROR', N_LOG_COUNT, 'EXCEPTION'
              , '', SYSDATE, V_PROC_INPUT
              , V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        RAISE_APPLICATION_ERROR(-20001
          , '[' ||$$PLSQL_UNIT||'] SQLCODE=' ||V_SQL_CODE||
            ' / SQLERRM=' ||V_SQL_ERRMSG||
            ' / BACKTRACE=' ||V_BACKTRACE||
            ' / PARAMS=' ||V_PROC_INPUT
        );
        RAISE;

END PR_SCM_ADM_RECIPIENT_ASSIGN_HIST;
/

-- ===== FN_GET_SOURCE_CODE =====

  CREATE OR REPLACE EDITIONABLE FUNCTION "SCM_MGR"."FN_GET_SOURCE_CODE" 
(
    P_USE_TYPE     IN VARCHAR2
  , P_MODULE       IN VARCHAR2
  , P_SUBMODULE    IN VARCHAR2
  , P_CATEGORY_ID  IN NUMBER
  , P_SEQ          IN NUMBER
)
RETURN VARCHAR2
/*
 * Program ID   : FN_GET_SOURCE_CODE
 * Description  :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/01/30  ygkim       Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 *
 * 2026-07-03   ZIONEX  [PJ202650304]  NextSCM Migration
*/
AS

    V_TEXT    CLOB;
    V_RETURN  VARCHAR2(4000 CHAR);
    V_SEQ     NUMBER := P_SEQ;

BEGIN

    BEGIN
        SELECT SQL_LONG_TEXT
          INTO V_TEXT
          FROM SCM_ADM_RECIPIENT_LIST A
         WHERE 1 = 1
           AND A.USE_TYPE_CODE   = P_USE_TYPE
           AND A.MODULE_CODE     = P_MODULE
           AND A.SUB_MODULE_CODE = P_SUBMODULE
           AND A.CATEGORY_ID     = P_CATEGORY_ID;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            V_TEXT := NULL;
    END;

    IF V_SEQ < 0 THEN
        V_SEQ := 1;
    END IF;

    IF (V_SEQ = 1) THEN
        V_RETURN := SUBSTR(V_TEXT, 1, 4000);
    ELSIF (V_SEQ = 2) THEN
        V_RETURN := SUBSTR(V_TEXT, 4001, 4000);
    ELSIF (V_SEQ = 3) THEN
        V_RETURN := SUBSTR(V_TEXT, 8001, 4000);
    ELSIF (V_SEQ = 4) THEN
        V_RETURN := SUBSTR(V_TEXT, 12001, 4000);
    ELSIF (V_SEQ = 5) THEN
        V_RETURN := SUBSTR(V_TEXT, 16001, 4000);
    ELSIF (V_SEQ = 6) THEN
        V_RETURN := SUBSTR(V_TEXT, 20001, 4000);
    ELSIF (V_SEQ = 7) THEN
        V_RETURN := SUBSTR(V_TEXT, 24001, 4000);
    ELSIF (V_SEQ = 8) THEN
        V_RETURN := SUBSTR(V_TEXT, 28001, 4000);
    END IF;

    RETURN V_RETURN;  /* @v_return */

END;
/

-- ===== SCM_ARR_SPL_CNT =====

  CREATE OR REPLACE EDITIONABLE FUNCTION "SCM_MGR"."SCM_ARR_SPL_CNT" 
(
    P_STRING     IN VARCHAR2   /* 분리할 문자열 */
  , P_SPLITCHAR  IN VARCHAR2   /* 구분할 문자 */
)
RETURN VARCHAR2
/*
 * FUNCTION NAME : SCM_ARR_SPL_CNT
 * DESCRIPTION   : 구분자로 분리되는 요소 개수 반환
 * PROGRAM HISTORY
 *--------------------------------------------------------------
 * 2026-07-03   ZIONEX  [PJ202650304]  NextSCM Migration
 */
AS

    V_TEMP           VARCHAR2(32767 CHAR);
    V_LENGTH         PLS_INTEGER;
    V_CURRENT_INDEX  PLS_INTEGER;
    V_NEXT_INDEX     PLS_INTEGER;
    V_MAXLOOP_CNT    PLS_INTEGER;

BEGIN

    V_LENGTH        := LENGTH(RTRIM(P_STRING));
    V_CURRENT_INDEX := 1;
    V_NEXT_INDEX    := 1;
    V_MAXLOOP_CNT   := 0;

    WHILE V_NEXT_INDEX > 0 LOOP

        V_NEXT_INDEX := INSTR(P_STRING, P_SPLITCHAR, V_CURRENT_INDEX);

        IF V_NEXT_INDEX = 0 THEN
            V_TEMP := SUBSTR(P_STRING, V_CURRENT_INDEX, (V_LENGTH - V_CURRENT_INDEX + 1));
        ELSE
            V_TEMP := SUBSTR(P_STRING, V_CURRENT_INDEX, (V_NEXT_INDEX - V_CURRENT_INDEX));
            V_CURRENT_INDEX := V_NEXT_INDEX + 1;
        END IF;

        V_MAXLOOP_CNT := V_MAXLOOP_CNT + 1;

    END LOOP;

    RETURN V_MAXLOOP_CNT;

END;
/

-- ===== SCM_ARR_SPL_VAL =====

  CREATE OR REPLACE EDITIONABLE FUNCTION "SCM_MGR"."SCM_ARR_SPL_VAL" 
(
    P_STEXT  IN VARCHAR2                /* 대상 문자열 */
  , P_STR    IN VARCHAR2 DEFAULT '|'    /* 구분기호(Default '|') */
  , P_IDX    IN PLS_INTEGER             /* 배열 인덱스 */
)
RETURN VARCHAR2
/*
 * FUNCTION NAME : SCM_ARR_SPL_VAL
 * DESCRIPTION   : 구분기호로 나눈 배열의 인덱스 요소 반환
 * PROGRAM HISTORY
 *--------------------------------------------------------------
 * 2026-07-03   ZIONEX  [PJ202650304]  NextSCM Migration
 */
AS

    V_WORD        VARCHAR2(32767 CHAR);   /* 반환할 문자 */
    V_STEXT_DATA  VARCHAR2(32767 CHAR);
    V_NUM         PLS_INTEGER;
    V_STR         VARCHAR2(32767 CHAR);

BEGIN

    V_NUM        := 1;
    V_STR        := TRIM(P_STR);
    V_STEXT_DATA := TRIM(P_STEXT) || V_STR;

    WHILE P_IDX >= V_NUM LOOP

        IF INSTR(V_STEXT_DATA, V_STR) > 0 THEN
            /* 문자열의 인덱스 위치의 요소를 반환 */
            V_WORD := SUBSTR(V_STEXT_DATA, 1, INSTR(V_STEXT_DATA, V_STR) - 1);
            V_WORD := TRIM(V_WORD);

            /* 반환된 문자는 버린후 좌우공백 제거 */
            V_STEXT_DATA := TRIM(SUBSTR(V_STEXT_DATA, NVL(LENGTH(V_WORD), 0) + 2));
        ELSE
            V_WORD := NULL;
        END IF;

        V_NUM := V_NUM + 1;

    END LOOP;

    RETURN V_WORD;

END;
/