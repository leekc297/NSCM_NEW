PROCEDURE           "SCM0010_SAVE_NOTICE_CONTENT_MASTER"
(
    P_ACTIVE_FLAG       VARCHAR2,
    P_NOTICE_ID         VARCHAR2,
    P_LANGUAGE          VARCHAR2,
    P_TITLE             VARCHAR2,
    P_CONTENT           VARCHAR2,
    P_CREATED_BY        VARCHAR2,
    P_CREATION_DATE     VARCHAR2,
    P_LAST_UPDATED_BY   VARCHAR2,
    O_RC1             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
/*
 * Program ID   : SCM0010_SAVE_NOTICE_CONTENT_MASTER
 * Description  : NOTICE_ID별 메세지 저장
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/02/22   ygkim   Initial Release PJ20170278 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2026.03.24 김준규            [PJ20264226] NextSCM Pilot 설계 및 개발
 * 2026.05.22  최용훈           MS-SQL -> Oracle 변환
 *
 */
AS
    V_RECV_ACTIVE_FLAG VARCHAR2(4000 CHAR);
    V_ACTIVE_FLAG      VARCHAR2(4000 CHAR);
    V_NOTICE_ID        VARCHAR2(4000 CHAR);
    V_LANGUAGE         VARCHAR2(4000 CHAR);
    V_TITLE            VARCHAR2(4000 CHAR);
    V_CONTENT          VARCHAR2(4000 CHAR);
    V_CREATED_BY       VARCHAR2(4000 CHAR);
    V_CREATION_DATE    VARCHAR2(4000 CHAR);
    V_LAST_UPDATED_BY  VARCHAR2(4000 CHAR);
    V_DELIMITER        VARCHAR2(1 CHAR);
    V_MAX_LOOP_CNT     INTEGER            := 0;
    V_MST_LOOP_CNT     INTEGER            := 0;
    V_PROGRAM_NAME     VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
    V_LOG_TYPE         VARCHAR2(30 CHAR);
    V_LOG_MESSAGE      VARCHAR2(1000 CHAR);
    V_DESCRIPTION      VARCHAR2(500 CHAR);
    D_EVENT_DATE       DATE;

    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(100 CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);
    N_LOG_COUNT     PLS_INTEGER := 0;
BEGIN

    V_RECV_ACTIVE_FLAG := NULL;
    V_RECV_ACTIVE_FLAG := P_ACTIVE_FLAG;

    V_ACTIVE_FLAG := NULL;
    V_NOTICE_ID := NULL;
    V_LANGUAGE := NULL;
    V_CONTENT := NULL;
    V_CREATED_BY := NULL;
    V_CREATION_DATE := NULL;
    V_LAST_UPDATED_BY := NULL;

    V_DELIMITER := '^';
    COMMIT;

    -- 시작 LOG
    V_LOG_TYPE := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := NULL;
    D_EVENT_DATE := SYSTIMESTAMP;
    PR_SCM_SYS_LOG_BATCH( V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE );

    -- 프로시저 LOOP 길이를 판단
    V_MAX_LOOP_CNT := SCM_ARR_SPL_CNT( P_ACTIVE_FLAG, V_DELIMITER );
    --SELECT    v_max_loop_cnt;
    --	WHILE LENGTH(p_active_flag) > 0
    WHILE LENGTH( V_RECV_ACTIVE_FLAG ) > 0 AND V_MST_LOOP_CNT < V_MAX_LOOP_CNT
        LOOP

            -- v_mst_loop_cnt 1증가
            V_MST_LOOP_CNT := V_MST_LOOP_CNT + 1;
            --SELECT v_mst_loop_cnt,'v_mst_loop_cnt'
            -- 각 컬럼들에 대한 스플릿처리로직 스타트
            BEGIN

                V_ACTIVE_FLAG := SCM_ARR_SPL_VAL( P_ACTIVE_FLAG, V_DELIMITER, V_MST_LOOP_CNT );
                V_NOTICE_ID := SCM_ARR_SPL_VAL( P_NOTICE_ID, V_DELIMITER, V_MST_LOOP_CNT );
                V_LANGUAGE := SCM_ARR_SPL_VAL( P_LANGUAGE, V_DELIMITER, V_MST_LOOP_CNT );
                V_TITLE := SCM_ARR_SPL_VAL( P_TITLE, V_DELIMITER, V_MST_LOOP_CNT );
                V_CONTENT := SCM_ARR_SPL_VAL( P_CONTENT, V_DELIMITER, V_MST_LOOP_CNT );
                V_CREATED_BY := SCM_ARR_SPL_VAL( P_CREATED_BY, V_DELIMITER, V_MST_LOOP_CNT );
                V_CREATION_DATE := SCM_ARR_SPL_VAL( P_CREATION_DATE, V_DELIMITER, V_MST_LOOP_CNT );
                V_LAST_UPDATED_BY := SCM_ARR_SPL_VAL( P_LAST_UPDATED_BY, V_DELIMITER, V_MST_LOOP_CNT );

            END;

            --HISTORY INSERT INTO
            PR_SCM_ADM_NOTICE_CONTENT_MASTER_HIST(
                    V_NOTICE_ID,
                    V_LANGUAGE,
                    V_TITLE,
                    V_CONTENT,
                    V_CREATED_BY,
                    V_CREATION_DATE,
                    V_LAST_UPDATED_BY
            );

            IF V_MST_LOOP_CNT > 0 THEN
                IF V_ACTIVE_FLAG != 'D' THEN
                    MERGE INTO SCM_ADM_NOTICE_CONTENT_MASTER A
                    USING (
                        SELECT V_NOTICE_ID NOTICE_ID
                             , V_LANGUAGE  LANGUAGE
                        FROM DUAL
                          ) B
                    ON (A.NOTICE_ID = B.NOTICE_ID AND A.LANGUAGE_CODE = B.LANGUAGE)
                    WHEN MATCHED THEN
                        UPDATE
                        SET NOTICE_TITLE     = V_TITLE
                          , NOTICE_CONTENT   = V_CONTENT
                          , LAST_UPDATED_BY  = V_LAST_UPDATED_BY
                          , LAST_UPDATE_DATE = SYSTIMESTAMP

                    WHEN NOT MATCHED THEN

                        INSERT
                        (
                            NOTICE_ID
                        ,   LANGUAGE_CODE
                        ,   NOTICE_TITLE
                        ,   NOTICE_CONTENT
                        ,   CREATED_BY
                        ,   CREATION_DATE
                        ,   LAST_UPDATED_BY
                        ,   LAST_UPDATE_DATE
                        )
                        VALUES
                            (
                                V_NOTICE_ID
                            ,   V_LANGUAGE
                            ,   V_TITLE
                            ,   V_CONTENT
                            ,   V_CREATED_BY
                            ,   SYSTIMESTAMP
                            ,   V_LAST_UPDATED_BY
                            ,   SYSTIMESTAMP
                            );

                ELSIF V_ACTIVE_FLAG = 'D' THEN
                    DELETE
                    FROM SCM_ADM_NOTICE_CONTENT_MASTER
                    WHERE NOTICE_ID = V_NOTICE_ID
                      AND LANGUAGE_CODE = V_LANGUAGE;
                END IF;
            END IF;
        END LOOP;

    V_LOG_TYPE := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := NULL;
    D_EVENT_DATE := SYSTIMESTAMP;
    PR_SCM_SYS_LOG_BATCH( V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE );

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SQLERRM;
        V_PROC_INPUT := JSON_OBJECT(
            'P_ACTIVE_FLAG' VALUE P_ACTIVE_FLAG,
            'P_NOTICE_ID' VALUE P_NOTICE_ID,
            'P_LANGUAGE' VALUE P_LANGUAGE,
            'P_TITLE' VALUE P_TITLE,
            'P_CONTENT' VALUE P_CONTENT,
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

END SCM0010_SAVE_NOTICE_CONTENT_MASTER;