PROCEDURE           "SCM0006_SAVE_RECIPIENT_MASTER"
(
    P_ACTIVE_FLAG            IN VARCHAR2,
    P_USE_TYPE                IN VARCHAR2,
    P_MODULE                 IN VARCHAR2,
    P_SUBMODULE             IN VARCHAR2,
    P_CATEGORY_ID            IN VARCHAR2,
    P_CATEGORY_DESC         IN VARCHAR2,
    P_CYCLE_CLASS_CODE     IN VARCHAR2,
    P_DETAIL_CLASS_CODE    IN VARCHAR2,
    P_SEND_TIME_TEXT        IN VARCHAR2,
    P_SEND_MIN_TIME_TEXT    IN VARCHAR2,
    P_ACTIVE                IN VARCHAR2,
    P_CREATED_BY            IN VARCHAR2,
    P_CREATION_DATE        IN VARCHAR2,
    P_LAST_UPDATED_BY        IN VARCHAR2,
    O_RC1             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
/*
 * Program ID   : SCM0006_SAVE_RECIPIENT_MASTER
 * Description  : SMS/MAIL 수신자 Master 저장(CATEGORY_ID는 채번으로 저장)
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/01/29   ygkim   Initial Release PJ20170278 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/05/14   ygkim   Mail, SMS 구분 추가
 * 2018/10/15    hwyoon    메일링 분단위 발송 추가
 * 2026.05.21  최용훈           MS-SQL -> Oracle 변환
 *
 */
AS
    V_RECV_ACTIVE_FLAG VARCHAR2(4000 CHAR);
    V_ACTIVE_FLAG VARCHAR2(4000 CHAR);
    V_USE_TYPE VARCHAR2(4000 CHAR);
    V_MODULE VARCHAR2(4000 CHAR);
    V_SUBMODULE VARCHAR2(4000 CHAR);
    V_CATEGORY_ID VARCHAR2(4000 CHAR);
    V_CATEGORY_DESC VARCHAR2(4000 CHAR);
    V_CYCLE_CLASS_CODE VARCHAR2(4000 CHAR);
    V_DETAIL_CLASS_CODE VARCHAR2(4000 CHAR);
    V_SEND_TIME_TEXT VARCHAR2(4000 CHAR);
    V_SEND_MIN_TIME_TEXT VARCHAR2(4000 CHAR);
    V_ACTIVE VARCHAR2(4000 CHAR);
    V_CREATED_BY VARCHAR2(4000 CHAR);
    V_CREATION_DATE VARCHAR2(4000 CHAR);
    V_LAST_UPDATED_BY VARCHAR2(4000 CHAR);
    V_SQL_LONG_TEXT VARCHAR2(4000 CHAR);
    V_DELIMITER VARCHAR2(1 CHAR);
    V_MAX_LOOP_CNT INTEGER := 0;
    V_MST_LOOP_CNT INTEGER := 0;
    V_PROGRAM_NAME VARCHAR2(150 CHAR) := 'SCM0006_SAVE_RECIPIENT_MASTER';
    V_LOG_TYPE VARCHAR2(30 CHAR);
    V_LOG_MESSAGE VARCHAR2(1000 CHAR);
    V_DESCRIPTION VARCHAR2(500 CHAR);
    D_EVENT_DATE DATE;
    N_HISTORY_SEQ INTEGER;

    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(100 CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);
    N_LOG_COUNT     PLS_INTEGER := 0;
BEGIN

    V_RECV_ACTIVE_FLAG := NULL;
    V_RECV_ACTIVE_FLAG := P_ACTIVE_FLAG;

    V_ACTIVE_FLAG := NULL;
    V_USE_TYPE := NULL;
    V_MODULE := NULL;
    V_SUBMODULE := NULL;
    V_CATEGORY_ID := NULL;
    V_CATEGORY_DESC := NULL;
    V_CYCLE_CLASS_CODE := NULL;
    V_DETAIL_CLASS_CODE := NULL;
    V_SEND_TIME_TEXT := NULL;
    V_SEND_MIN_TIME_TEXT := NULL;
    V_ACTIVE := NULL;
    V_CREATED_BY := NULL;
    V_CREATION_DATE := NULL;
    V_LAST_UPDATED_BY := NULL;
    V_SQL_LONG_TEXT := NULL;

    V_DELIMITER := '^';

    -- 시작 LOG
    V_LOG_TYPE := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := NULL;
    D_EVENT_DATE := SYSTIMESTAMP;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

    -- 프로시저 LOOP 길이를 판단
    V_MAX_LOOP_CNT := SCM_ARR_SPL_CNT( P_ACTIVE_FLAG, V_DELIMITER);

    WHILE LENGTH(V_RECV_ACTIVE_FLAG) > 0 AND V_MST_LOOP_CNT < V_MAX_LOOP_CNT
        LOOP

            BEGIN

                -- v_mst_loop_cnt 1증가
                v_mst_loop_cnt := v_mst_loop_cnt || 1;

                -- 각 컬럼들에 대한 스플릿처리로직 스타트
                BEGIN
                    V_ACTIVE_FLAG := SCM_ARR_SPL_VAL( P_ACTIVE_FLAG, V_DELIMITER , V_MST_LOOP_CNT) ;
                    V_USE_TYPE := SCM_ARR_SPL_VAL( P_USE_TYPE, V_DELIMITER , V_MST_LOOP_CNT) ;
                    V_MODULE := SCM_ARR_SPL_VAL(P_MODULE, V_DELIMITER , V_MST_LOOP_CNT) ;
                    V_SUBMODULE := SCM_ARR_SPL_VAL(P_SUBMODULE, V_DELIMITER , V_MST_LOOP_CNT) ;
                    V_CATEGORY_ID := SCM_ARR_SPL_VAL(P_CATEGORY_ID, V_DELIMITER , V_MST_LOOP_CNT) ;
                    V_CATEGORY_DESC := SCM_ARR_SPL_VAL(P_CATEGORY_DESC, V_DELIMITER, V_MST_LOOP_CNT) ;
                    V_CYCLE_CLASS_CODE := SCM_ARR_SPL_VAL(P_CYCLE_CLASS_CODE, V_DELIMITER, V_MST_LOOP_CNT) ;
                    V_DETAIL_CLASS_CODE := SCM_ARR_SPL_VAL(P_DETAIL_CLASS_CODE, V_DELIMITER, V_MST_LOOP_CNT) ;
                    V_SEND_TIME_TEXT := SCM_ARR_SPL_VAL(P_SEND_TIME_TEXT, V_DELIMITER, V_MST_LOOP_CNT) ;
                    V_SEND_MIN_TIME_TEXT := SCM_ARR_SPL_VAL(P_SEND_MIN_TIME_TEXT, V_DELIMITER, V_MST_LOOP_CNT) ;
                    V_ACTIVE := SCM_ARR_SPL_VAL(P_ACTIVE, V_DELIMITER, V_MST_LOOP_CNT) ;
                    V_CREATED_BY := SCM_ARR_SPL_VAL(P_CREATED_BY, V_DELIMITER , V_MST_LOOP_CNT) ;
                    V_CREATION_DATE := SCM_ARR_SPL_VAL(P_CREATION_DATE, V_DELIMITER , V_MST_LOOP_CNT) ;
                    V_LAST_UPDATED_BY := SCM_ARR_SPL_VAL(P_LAST_UPDATED_BY, V_DELIMITER , V_MST_LOOP_CNT) ;
                END;

                IF (NVL(v_category_id, NULL) IS NULL) THEN
                    SELECT SEQ1_SCM_ADM_RECIPIENT_LIST.NEXTVAL
                    INTO N_HISTORY_SEQ
                    FROM DUAL;
                ELSE
                    N_HISTORY_SEQ := V_CATEGORY_ID;
                END IF;

                --HISTORY INSERT INTO
                PR_SCM_ADM_RECIPIENT_LIST_HIST(
                    V_USE_TYPE
                    ,V_MODULE
                    ,V_SUBMODULE
                    ,V_CATEGORY_ID
                    ,V_CATEGORY_DESC
                    ,V_CYCLE_CLASS_CODE
                    ,V_DETAIL_CLASS_CODE
                    ,V_SEND_TIME_TEXT
                    ,V_SEND_MIN_TIME_TEXT
                    ,V_ACTIVE
                    ,V_SQL_LONG_TEXT
                    ,V_CREATED_BY
                    ,V_CREATION_DATE
                    ,V_LAST_UPDATED_BY
                );

                IF V_MST_LOOP_CNT > 0 THEN
                    IF V_ACTIVE_FLAG != 'D' THEN
                            BEGIN

                                MERGE INTO SCM_ADM_RECIPIENT_LIST A
                                USING (
                                    SELECT V_USE_TYPE    AS USE_TYPE_CODE
                                         , N_HISTORY_SEQ AS CATEGORY_ID
                                         , V_MODULE      AS MODULE_CODE
                                         , V_SUBMODULE   AS SUB_MODULE_CODE
                                    FROM DUAL
                                      ) B
                                ON (A.USE_TYPE_CODE = B.USE_TYPE_CODE AND A.CATEGORY_ID = B.CATEGORY_ID AND A.MODULE_CODE = B.MODULE_CODE AND A.SUB_MODULE_CODE = B.SUB_MODULE_CODE)
                                WHEN MATCHED THEN
                                    UPDATE
                                    SET CATEGORY_DESC      = V_CATEGORY_DESC
                                      , CYCLE_CLASS_CODE   = V_CYCLE_CLASS_CODE
                                      , DETAIL_CLASS_CODE  = V_DETAIL_CLASS_CODE
                                      , SEND_TIME_TEXT     = V_SEND_TIME_TEXT
                                      , SEND_MIN_TIME_TEXT = V_SEND_MIN_TIME_TEXT
                                      , VALID_YN           = V_ACTIVE
                                      , LAST_UPDATED_BY    = V_LAST_UPDATED_BY
                                      , LAST_UPDATE_DATE   = SYSTIMESTAMP
                                WHEN NOT MATCHED THEN
                                    INSERT
                                    (
                                        USE_TYPE_CODE
                                    ,   CATEGORY_ID
                                    ,   SUB_MODULE_CODE
                                    ,   MODULE_CODE
                                    ,   CATEGORY_DESC
                                    ,   CYCLE_CLASS_CODE
                                    ,   DETAIL_CLASS_CODE
                                    ,   SEND_TIME_TEXT
                                    ,   SEND_MIN_TIME_TEXT
                                    ,   VALID_YN
                                    ,   CREATED_BY
                                    ,   CREATION_DATE
                                    ,   LAST_UPDATED_BY
                                    ,   LAST_UPDATE_DATE
                                    )
                                    VALUES
                                        (
                                            V_USE_TYPE
                                        ,   N_HISTORY_SEQ
                                        ,   V_SUBMODULE
                                        ,   V_MODULE
                                        ,   V_CATEGORY_DESC
                                        ,   V_CYCLE_CLASS_CODE
                                        ,   V_DETAIL_CLASS_CODE
                                        ,   V_SEND_TIME_TEXT
                                        ,   V_SEND_MIN_TIME_TEXT
                                        ,   V_ACTIVE
                                        ,   V_CREATED_BY
                                        ,   SYSTIMESTAMP
                                        ,   V_LAST_UPDATED_BY
                                        ,   SYSTIMESTAMP
                                        );

                            END;
                    ELSIF v_active_flag = 'D' THEN
                        DELETE FROM SCM_ADM_RECIPIENT_LIST
                        WHERE USE_TYPE_CODE = V_USE_TYPE
                          AND MODULE_CODE = V_MODULE
                          AND SUB_MODULE_CODE = V_SUBMODULE
                          AND CATEGORY_ID = N_HISTORY_SEQ;

                        /*해당 MAIL/SMS의 CATEGORY_ID로 등록되어 있는 메세지와 수신자를 같이 삭제한다.*/
                        DELETE FROM SCM_ADM_RECIPIENT_MESSAGE
                        WHERE USE_TYPE_CODE = V_USE_TYPE
                          AND CATEGORY_ID = N_HISTORY_SEQ;

                        /*수신자삭제 : MAIL/SMS 분기처리*/
                        IF V_USE_TYPE = 'SMS' THEN
                                DELETE FROM SCM_ADM_RECIPIENT_SMS_ASSIGN
                                WHERE CATEGORY_ID = N_HISTORY_SEQ;
                        ELSE
                                DELETE FROM SCM_ADM_RECIPIENT_ASSIGN
                                WHERE USE_TYPE_CODE = V_USE_TYPE
                                  AND CATEGORY_ID = N_HISTORY_SEQ;
                        END IF;
                    END IF;
                END IF;

            END;

        END LOOP;

    V_LOG_TYPE := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := NULL;
    D_EVENT_DATE := SYSTIMESTAMP;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SQLERRM;
        V_PROC_INPUT := JSON_OBJECT(
            'P_ACTIVE_FLAG' VALUE P_ACTIVE_FLAG,
            'P_USE_TYPE' VALUE P_USE_TYPE,
            'P_MODULE' VALUE P_MODULE,
            'P_SUBMODULE' VALUE P_SUBMODULE,
            'P_CATEGORY_ID' VALUE P_CATEGORY_ID,
            'P_CATEGORY_DESC' VALUE P_CATEGORY_DESC,
            'P_CYCLE_CLASS_CODE' VALUE P_CYCLE_CLASS_CODE,
            'P_DETAIL_CLASS_CODE' VALUE P_DETAIL_CLASS_CODE,
            'P_SEND_TIME_TEXT' VALUE P_SEND_TIME_TEXT,
            'P_SEND_MIN_TIME_TEXT' VALUE P_SEND_MIN_TIME_TEXT,
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

END SCM0006_SAVE_RECIPIENT_MASTER;