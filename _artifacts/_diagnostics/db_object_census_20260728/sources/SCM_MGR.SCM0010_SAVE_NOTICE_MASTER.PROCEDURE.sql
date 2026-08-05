PROCEDURE           "SCM0010_SAVE_NOTICE_MASTER"
(
    P_ACTIVE_FLAG       VARCHAR2,
    P_MODULE            VARCHAR2,
    P_SUBMODULE         VARCHAR2,
    P_NOTICE_ID         VARCHAR2,
    P_NOTICE_DESC       VARCHAR2,
    P_CYCLE_CLASS_CODE  VARCHAR2,
    P_DETAIL_CLASS_CODE VARCHAR2,
    P_SEND_TIME_TEXT    VARCHAR2,
    P_ACTIVE            VARCHAR2,
    P_CREATED_BY        VARCHAR2,
    P_CREATION_DATE     VARCHAR2,
    P_LAST_UPDATED_BY   VARCHAR2,
    O_RC1             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
/*
 * Program ID   : SCM0010_SAVE_NOTICE_MASTER
 * Description  : NOTICE Master 저장(NOTICE_ID는 채번으로 저장)
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/02/22   ygkim   Initial Release PJ20170278 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2026.03.24 김준규            [PJ20264226] NextSCM Pilot 설계 및 개발
 * 2026.05.22  최용훈           MS-SQL -> Oracle 변환
 *
 */

/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2026.05.22  최용훈       MS-SQL -> Oracle 변환                                  */
/*                                                                                                  */
/****************************************************************************************************/
AS
    V_IN_PARA_DATA      VARCHAR2(4000);
    V_RECV_ACTIVE_FLAG  VARCHAR2(4000 CHAR);
    V_ACTIVE_FLAG       VARCHAR2(4000 CHAR);
    V_USE_TYPE          VARCHAR2(4000 CHAR);
    V_MODULE            VARCHAR2(4000 CHAR);
    V_SUBMODULE         VARCHAR2(4000 CHAR);
    V_NOTICE_ID         VARCHAR2(4000 CHAR);
    V_NOTICE_DESC       VARCHAR2(4000 CHAR);
    V_CYCLE_CLASS_CODE  VARCHAR2(4000 CHAR);
    V_DETAIL_CLASS_CODE VARCHAR2(4000 CHAR);
    V_SEND_TIME_TEXT    VARCHAR2(4000 CHAR);
    V_ACTIVE            VARCHAR2(4000 CHAR);
    V_CREATED_BY        VARCHAR2(4000 CHAR);
    V_CREATION_DATE     VARCHAR2(4000 CHAR);
    V_LAST_UPDATED_BY   VARCHAR2(4000 CHAR);
    V_SQL_LONG_TEXT     VARCHAR2(4000 CHAR);
    V_DELIMITER         VARCHAR2(1 CHAR);
    V_MAX_LOOP_CNT      INTEGER            := 0;
    V_MST_LOOP_CNT      INTEGER            := 0;
    V_PROGRAM_NAME      VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
    V_LOG_TYPE          VARCHAR2(30 CHAR);
    V_LOG_MESSAGE       VARCHAR2(1000 CHAR);
    V_DESCRIPTION       VARCHAR2(500 CHAR);
    D_EVENT_DATE        DATE;
    N_HISTORY_SEQ       INTEGER;

    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(100 CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);
    N_LOG_COUNT     PLS_INTEGER := 0;
BEGIN

    IF UTL_CALL_STACK.SUBPROGRAM( 1 ).COUNT > 1 THEN V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM( 1 )( 2 ); END IF;

    --SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    V_RECV_ACTIVE_FLAG := NULL;
    V_RECV_ACTIVE_FLAG := P_ACTIVE_FLAG;

    V_ACTIVE_FLAG := NULL;
    V_USE_TYPE := NULL;
    V_MODULE := NULL;
    V_SUBMODULE := NULL;
    V_NOTICE_ID := NULL;
    V_NOTICE_DESC := NULL;
    V_CYCLE_CLASS_CODE := NULL;
    V_DETAIL_CLASS_CODE := NULL;
    V_SEND_TIME_TEXT := NULL;
    V_ACTIVE := NULL;
    V_CREATED_BY := NULL;
    V_CREATION_DATE := NULL;
    V_LAST_UPDATED_BY := NULL;
    V_SQL_LONG_TEXT := NULL;

    V_DELIMITER := '^';

    -- BEGIN TRY (Oracle: EXCEPTION 블록으로 대체)

    -- 시작 LOG
    V_LOG_TYPE := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := NULL;
    D_EVENT_DATE := SYSTIMESTAMP;
    PR_SCM_SYS_LOG_BATCH( V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE );

    -- 프로시저 LOOP 길이를 판단
    V_MAX_LOOP_CNT := SCM_ARR_SPL_CNT( P_ACTIVE_FLAG, V_DELIMITER );
    --SELECT    v_max_loop_cnt;
    --    WHILE LENGTH(p_active_flag) > 0
    WHILE LENGTH( V_RECV_ACTIVE_FLAG ) > 0 AND V_MST_LOOP_CNT < V_MAX_LOOP_CNT
        LOOP

            -- v_mst_loop_cnt 1증가
            V_MST_LOOP_CNT := V_MST_LOOP_CNT + 1;
            --SELECT v_mst_loop_cnt,'v_mst_loop_cnt'
            -- 각 컬럼들에 대한 스플릿처리로직 스타트
            BEGIN

                V_ACTIVE_FLAG := SCM_ARR_SPL_VAL( P_ACTIVE_FLAG, V_DELIMITER, V_MST_LOOP_CNT );
                V_MODULE := SCM_ARR_SPL_VAL( P_MODULE, V_DELIMITER, V_MST_LOOP_CNT );
                V_SUBMODULE := SCM_ARR_SPL_VAL( P_SUBMODULE, V_DELIMITER, V_MST_LOOP_CNT );
                V_NOTICE_ID := SCM_ARR_SPL_VAL( P_NOTICE_ID, V_DELIMITER, V_MST_LOOP_CNT );
                V_NOTICE_DESC := SCM_ARR_SPL_VAL( P_NOTICE_DESC, V_DELIMITER, V_MST_LOOP_CNT );
                V_CYCLE_CLASS_CODE := SCM_ARR_SPL_VAL( P_CYCLE_CLASS_CODE, V_DELIMITER, V_MST_LOOP_CNT );
                V_DETAIL_CLASS_CODE := SCM_ARR_SPL_VAL( P_DETAIL_CLASS_CODE, V_DELIMITER, V_MST_LOOP_CNT );
                V_SEND_TIME_TEXT := SCM_ARR_SPL_VAL( P_SEND_TIME_TEXT, V_DELIMITER, V_MST_LOOP_CNT );
                V_ACTIVE := SCM_ARR_SPL_VAL( P_ACTIVE, V_DELIMITER, V_MST_LOOP_CNT );
                V_CREATED_BY := SCM_ARR_SPL_VAL( P_CREATED_BY, V_DELIMITER, V_MST_LOOP_CNT );
                V_CREATION_DATE := SCM_ARR_SPL_VAL( P_CREATION_DATE, V_DELIMITER, V_MST_LOOP_CNT );
                V_LAST_UPDATED_BY := SCM_ARR_SPL_VAL( P_LAST_UPDATED_BY, V_DELIMITER, V_MST_LOOP_CNT );

            END;

            IF (V_NOTICE_ID IS NULL) THEN
                N_HISTORY_SEQ := SEQ1_SCM_ADM_NOTICE_MASTER.NEXTVAL;
            ELSE
                N_HISTORY_SEQ := V_NOTICE_ID; --HISTORY INSERT INTO
            PR_SCM_ADM_NOTICE_MASTER_HIST(
                V_MODULE,
                V_SUBMODULE,
                V_NOTICE_ID,
                V_NOTICE_DESC,
                V_CYCLE_CLASS_CODE,
                V_DETAIL_CLASS_CODE,
                V_SEND_TIME_TEXT,
                V_ACTIVE,
                V_SQL_LONG_TEXT,
                V_CREATED_BY,
                V_CREATION_DATE,
                V_LAST_UPDATED_BY
            );

            END IF;

            IF V_MST_LOOP_CNT > 0 THEN
                IF V_ACTIVE_FLAG != 'D' THEN
                    BEGIN

                        MERGE INTO SCM_ADM_NOTICE_MASTER A
                        USING (
                            SELECT N_HISTORY_SEQ NOTICE_ID
                                 , V_MODULE      MODULE_CODE
                                 , V_SUBMODULE   SUB_MODULE_CODE
                            FROM DUAL
                              ) B
                        ON (A.NOTICE_ID = B.NOTICE_ID AND A.MODULE_CODE = B.MODULE_CODE AND A.SUB_MODULE_CODE = B.SUB_MODULE_CODE)
                        WHEN MATCHED THEN
                            UPDATE
                            SET NOTICE_TITLE      = V_NOTICE_DESC
                              , CYCLE_CLASS_CODE  = V_CYCLE_CLASS_CODE
                              , DETAIL_CLASS_CODE = V_DETAIL_CLASS_CODE
                              , SEND_TIME_TEXT    = V_SEND_TIME_TEXT
                              , VALID_YN          = V_ACTIVE
                              , LAST_UPDATED_BY   = V_LAST_UPDATED_BY
                              , LAST_UPDATE_DATE  = SYSTIMESTAMP

                        WHEN NOT MATCHED THEN

                            INSERT
                            (
                                NOTICE_ID
                            ,   SUB_MODULE_CODE
                            ,   MODULE_CODE
                            ,   NOTICE_TITLE
                            ,   CYCLE_CLASS_CODE
                            ,   DETAIL_CLASS_CODE
                            ,   SEND_TIME_TEXT
                            ,   VALID_YN
                            ,   CREATED_BY
                            ,   CREATION_DATE
                            ,   LAST_UPDATED_BY
                            ,   LAST_UPDATE_DATE
                            )
                            VALUES
                                (
                                    N_HISTORY_SEQ
                                ,   V_SUBMODULE
                                ,   V_MODULE
                                ,   V_NOTICE_DESC
                                ,   V_CYCLE_CLASS_CODE
                                ,   V_DETAIL_CLASS_CODE
                                ,   V_SEND_TIME_TEXT
                                ,   V_ACTIVE
                                ,   V_CREATED_BY
                                ,   SYSTIMESTAMP
                                ,   V_LAST_UPDATED_BY
                                ,   SYSTIMESTAMP
                                );

                    END;
                ELSIF V_ACTIVE_FLAG = 'D' THEN
                    DELETE
                    FROM SCM_ADM_NOTICE_MASTER
                    WHERE MODULE_CODE = V_MODULE
                      AND SUB_MODULE_CODE = V_SUBMODULE
                      AND NOTICE_ID = N_HISTORY_SEQ;

                    /*해당 notice_ID로 등록되어 있는 메세지를 같이 삭제한다.*/
                    DELETE
                    FROM SCM_ADM_NOTICE_CONTENT_MASTER
                    WHERE NOTICE_ID = N_HISTORY_SEQ;
                END IF;
            END IF;
        END LOOP;

    V_LOG_TYPE := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := NULL;
    D_EVENT_DATE := SYSTIMESTAMP;
    PR_SCM_SYS_LOG_BATCH( V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE );

    -- 결과코드, 결과 카운트 반환
    COMMIT;
    -- END TRY

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SQLERRM;
        V_PROC_INPUT := JSON_OBJECT(
            'P_ACTIVE_FLAG' VALUE P_ACTIVE_FLAG,
            'P_MODULE' VALUE P_MODULE,
            'P_SUBMODULE' VALUE P_SUBMODULE,
            'P_NOTICE_ID' VALUE P_NOTICE_ID,
            'P_NOTICE_DESC' VALUE P_NOTICE_DESC,
            'P_CYCLE_CLASS_CODE' VALUE P_CYCLE_CLASS_CODE,
            'P_DETAIL_CLASS_CODE' VALUE P_DETAIL_CLASS_CODE,
            'P_SEND_TIME_TEXT' VALUE P_SEND_TIME_TEXT,
            'P_ACTIVE' VALUE P_ACTIVE,
            'P_CREATED_BY' VALUE P_CREATED_BY,
            'P_CREATION_DATE' VALUE P_CREATION_DATE,
            'P_LAST_UPDATED_BY' VALUE P_LAST_UPDATED_BY
        );
        V_BACKTRACE  := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                $$PLSQL_UNIT, 'ERROR', N_LOG_COUNT, 'EXCEPTION',
                '', SYSDATE, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        RAISE_APPLICATION_ERROR(-20001,
            '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_SQL_ERRMSG ||
            ' / BACKTRACE=' || V_BACKTRACE ||
            ' / PARAMS=' || V_PROC_INPUT
        );
        RAISE;

END SCM0010_SAVE_NOTICE_MASTER;