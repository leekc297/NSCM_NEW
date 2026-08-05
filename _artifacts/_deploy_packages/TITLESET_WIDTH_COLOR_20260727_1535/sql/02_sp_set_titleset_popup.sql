-- ============================================================================
-- 02. SCM0002_SET_TITLESET_POPUP — COLUMN_WIDTH/CELL_COLOR/TEXT_COLOR 3종 반영
--     생성: build/10_build_sp.py (사내 라이브 원본 앵커 변환 — 본문 재작성 아님)
--     하위호환: 신규 3 파라미터 DEFAULT NULL — 미전달 기존 화면 정상 동작
-- ============================================================================
CREATE OR REPLACE PROCEDURE SCM_MGR.SCM0002_SET_TITLESET_POPUP
(
    P_PROGRAM_ID       IN VARCHAR2,
    P_SHEET_NAME       IN VARCHAR2,
    P_COLUMN_TYPE      IN VARCHAR2,
    P_ACTIVE_FLAG      IN VARCHAR2,
    P_COLUMN_NAME      IN VARCHAR2,
    P_SORT_ORDER_NO    IN VARCHAR2,
    P_SUB_TOTAL_FLAG   IN VARCHAR2,
    P_SORT_METHOD_CODE IN VARCHAR2,
    P_USER_ID          IN VARCHAR2,
    P_COLUMN_WIDTH     IN VARCHAR2 DEFAULT NULL,   -- ⭐ 2026-07-27 신규: '^' 구분 컬럼폭
    P_CELL_COLOR       IN VARCHAR2 DEFAULT NULL,   -- ⭐ 2026-07-27 신규: '^' 구분 셀 배경색
    P_TEXT_COLOR       IN VARCHAR2 DEFAULT NULL,   -- ⭐ 2026-07-27 신규: '^' 구분 글자색
    O_RC1              OUT SYS_REFCURSOR,
    O_RESULT_CURSOR    OUT SYS_REFCURSOR
)
/*
 * Program ID   : SCM0002_SET_TITLESET_POPUP
 * Description  : Column Setting, Measure Setting
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017.11.21   정병훈         Initial Release PJ20170278 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2024.11.06   jahn1502       UI 컬럼 0처리로 인해 'SCP0104','SCP0105','SCP0106','SCP0107','SCP0108' 화면 별도 설정
 * 2026.05.20  최용훈           MS-SQL -> Oracle 변환
 * 2026.07.27  admin            COLUMN_WIDTH/CELL_COLOR/TEXT_COLOR 3종 추가 (사용자 요청 — 하위호환 DEFAULT NULL)
 *
 */
AS
    V_RECV_ACTIVE_FLAG VARCHAR2(4000 CHAR);
    V_PROGRAM_ID       VARCHAR2(4000 CHAR);
    V_SHEET_NAME       VARCHAR2(4000 CHAR);
    V_COLUMN_TYPE      VARCHAR2(4000 CHAR);
    V_ACTIVE_FLAG      VARCHAR2(4000 CHAR);
    V_COLUMN_NAME      VARCHAR2(4000 CHAR);
    V_SORT_ORDER_NO    VARCHAR2(4000 CHAR);
    V_SUB_TOTAL_FLAG   VARCHAR2(4000 CHAR);
    V_SORT_METHOD_CODE VARCHAR2(4000 CHAR);
    V_USER_ID          VARCHAR2(4000 CHAR);
    V_COLUMN_WIDTH     VARCHAR2(4000 CHAR);        -- ⭐ 2026-07-27 신규
    V_CELL_COLOR       VARCHAR2(4000 CHAR);        -- ⭐ 2026-07-27 신규
    V_TEXT_COLOR       VARCHAR2(4000 CHAR);        -- ⭐ 2026-07-27 신규
    V_DELIMITER        VARCHAR2(10 CHAR);
    V_MAX_LOOP_CNT     INTEGER             := 0;
    V_MST_LOOP_CNT     INTEGER             := 0;
    V_PROGRAM_NAME     VARCHAR2(1500 CHAR) := $$PLSQL_UNIT;

    V_LOG_TYPE         VARCHAR2(300 CHAR);
    V_LOG_MESSAGE      VARCHAR2(1000 CHAR);
    V_DESCRIPTION      VARCHAR2(1000 CHAR);
    D_EVENT_DATE       DATE;
    V_IN_PARA_DATA     VARCHAR2(4000);

    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(100 CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);
    N_LOG_COUNT     PLS_INTEGER := 0;
BEGIN

    V_RECV_ACTIVE_FLAG := NULL;
    V_RECV_ACTIVE_FLAG := P_ACTIVE_FLAG;

    V_PROGRAM_ID := NULL;
    V_SHEET_NAME := NULL;
    V_COLUMN_TYPE := NULL;
    V_ACTIVE_FLAG := NULL;
    V_COLUMN_NAME := NULL;
    V_SORT_ORDER_NO := NULL;
    V_SUB_TOTAL_FLAG := NULL;
    V_SORT_METHOD_CODE := NULL;
    V_USER_ID := NULL;
    V_COLUMN_WIDTH := NULL;
    V_CELL_COLOR := NULL;
    V_TEXT_COLOR := NULL;

    V_DELIMITER := '^';

    -- 시작 LOG
    V_LOG_TYPE := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := NULL;
    D_EVENT_DATE := SYSTIMESTAMP;
    PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

    -- 프로시저 LOOP 길이를 판단
    V_MAX_LOOP_CNT := SCM_ARR_SPL_CNT(P_ACTIVE_FLAG, v_delimiter);

    DELETE FROM SCM_MST_TITLESET_USER
    WHERE  USER_ID          = P_USER_ID
    AND    PROGRAM_ID       = P_PROGRAM_ID
    AND    SHEET_NAME       = P_SHEET_NAME
    AND    USER_INQUIRY_COLUMN_TYPE_CODE = P_COLUMN_TYPE;

    WHILE(LENGTH(V_RECV_ACTIVE_FLAG) > 0 AND V_MST_LOOP_CNT < V_MAX_LOOP_CNT)
        LOOP
            BEGIN
                -- v_mst_loop_cnt 1증가
                V_MST_LOOP_CNT := V_MST_LOOP_CNT + 1;

                -- 각 컬럼들에 대한 스플릿처리로직 스타트
                BEGIN

                    V_ACTIVE_FLAG := SCM_ARR_SPL_VAL(P_ACTIVE_FLAG, V_DELIMITER , V_MST_LOOP_CNT) ;
                    V_COLUMN_NAME := SCM_ARR_SPL_VAL(P_COLUMN_NAME, V_DELIMITER , V_MST_LOOP_CNT) ;
                    V_SORT_ORDER_NO := SCM_ARR_SPL_VAL(P_SORT_ORDER_NO, V_DELIMITER , V_MST_LOOP_CNT) ;
                    V_SUB_TOTAL_FLAG := SCM_ARR_SPL_VAL(P_SUB_TOTAL_FLAG, V_DELIMITER , V_MST_LOOP_CNT) ;
                    V_SORT_METHOD_CODE := SCM_ARR_SPL_VAL(P_SORT_METHOD_CODE, V_DELIMITER , V_MST_LOOP_CNT) ;
                    -- ⭐ 2026-07-27 신규 3종 (미전달 시 NULL — 하위호환)
                    V_COLUMN_WIDTH := SCM_ARR_SPL_VAL(P_COLUMN_WIDTH, V_DELIMITER , V_MST_LOOP_CNT) ;
                    V_CELL_COLOR := SCM_ARR_SPL_VAL(P_CELL_COLOR, V_DELIMITER , V_MST_LOOP_CNT) ;
                    V_TEXT_COLOR := SCM_ARR_SPL_VAL(P_TEXT_COLOR, V_DELIMITER , V_MST_LOOP_CNT) ;
                END;

                IF V_MST_LOOP_CNT > 0 THEN
                    IF (P_COLUMN_TYPE = 'C' and P_PROGRAM_ID NOT IN ('SCP0104', 'SCP0105', 'SCP0106', 'SCP0107', 'SCP0108')) THEN

                        INSERT INTO SCM_MST_TITLESET_USER
                        (
                            USER_ID
                        ,   PROGRAM_ID
                        ,   SHEET_NAME
                        ,   USER_INQUIRY_COLUMN_TYPE_CODE
                        ,   COLUMN_NAME
                        ,   SORT_ORDER_NO
                        ,   SUB_TOTAL_FLAG
                        ,   DATA_SORT_METHOD_CODE
                        ,   CREATED_BY
                        ,   CREATION_DATE
                        ,   LAST_UPDATED_BY
                        ,   LAST_UPDATE_DATE
                        ,   COLUMN_WIDTH
                        ,   CELL_COLOR
                        ,   TEXT_COLOR
                       )
                        SELECT P_USER_ID
                             , C.PROGRAM_ID
                             , C.SHEET_NAME
                             , P_COLUMN_TYPE
                             , C.COLUMN_NAME
                             --, P_SORT_ORDER_NO(I) + C.SORT_ORDER_NO - TRUNC(C.SORT_ORDER_NO)
                             , CASE WHEN V_SORT_ORDER_NO IS NULL OR V_SORT_ORDER_NO = 0 THEN C.SORT_ORDER_NO ELSE V_SORT_ORDER_NO + C.SORT_ORDER_NO - ROUND( C.SORT_ORDER_NO, 1 ) END
                             , V_SUB_TOTAL_FLAG
                             , V_SORT_METHOD_CODE
                             , P_USER_ID
                             , SYSTIMESTAMP
                             , P_USER_ID
                             , SYSTIMESTAMP
                             , CASE WHEN V_COLUMN_WIDTH IS NULL OR V_COLUMN_WIDTH = '' THEN C.COLUMN_WIDTH ELSE TO_NUMBER(V_COLUMN_WIDTH) END
                             , V_CELL_COLOR
                             , V_TEXT_COLOR
                        FROM SCM_MST_SHEET_COLUMNS C
                        WHERE C.PROGRAM_ID = P_PROGRAM_ID
                          AND C.SHEET_NAME = P_SHEET_NAME
                          AND C.SORT_ORDER_NO = (
                            SELECT SORT_ORDER_NO
                            FROM SCM_MST_SHEET_COLUMNS
                            WHERE PROGRAM_ID = P_PROGRAM_ID
                              AND SHEET_NAME = P_SHEET_NAME
                              AND COLUMN_NAME = V_COLUMN_NAME
                                                )
                          AND NOT EXISTS
                            (
                                SELECT 1
                                FROM SCM_MST_TITLESET_USER
                                WHERE PROGRAM_ID = C.PROGRAM_ID
                                  AND SHEET_NAME = C.SHEET_NAME
                                  AND COLUMN_NAME = C.COLUMN_NAME
                                  AND USER_ID = P_USER_ID
                            );

                    -- -----------------------------------------------------------------------------------------------------------
                    ELSIF (P_COLUMN_TYPE = 'C' AND P_PROGRAM_ID IN ('SCP0104','SCP0105','SCP0106','SCP0107','SCP0108')) THEN  --COLUMN

                        INSERT INTO SCM_MST_TITLESET_USER
                        (
                            USER_ID
                        ,   PROGRAM_ID
                        ,   SHEET_NAME
                        ,   USER_INQUIRY_COLUMN_TYPE_CODE
                        ,   COLUMN_NAME
                        ,   SORT_ORDER_NO
                        ,   SUB_TOTAL_FLAG
                        ,   DATA_SORT_METHOD_CODE
                        ,   CREATED_BY
                        ,   CREATION_DATE
                        ,   LAST_UPDATED_BY
                        ,   LAST_UPDATE_DATE
                        ,   ATTRIBUTE3
                        ,   COLUMN_WIDTH
                        ,   CELL_COLOR
                        ,   TEXT_COLOR
                       )
                        SELECT P_USER_ID
                             , C.PROGRAM_ID
                             , C.SHEET_NAME
                             , P_COLUMN_TYPE
                             , C.COLUMN_NAME
                             --, P_SORT_ORDER_NO(I) + C.SORT_ORDER_NO - TRUNC(C.SORT_ORDER_NO)
                             , C.SORT_ORDER_NO
                             , V_SUB_TOTAL_FLAG
                             , V_SORT_METHOD_CODE
                             , P_USER_ID
                             , SYSTIMESTAMP
                             , P_USER_ID
                             , SYSTIMESTAMP
                             , NULL
                             , CASE WHEN V_COLUMN_WIDTH IS NULL OR V_COLUMN_WIDTH = '' THEN C.COLUMN_WIDTH ELSE TO_NUMBER(V_COLUMN_WIDTH) END
                             , V_CELL_COLOR
                             , V_TEXT_COLOR
                        FROM SCM_MST_SHEET_COLUMNS C
                        WHERE C.PROGRAM_ID = P_PROGRAM_ID
                          AND C.SHEET_NAME = P_SHEET_NAME
                          AND C.COLUMN_WIDTH <> 0
                          AND C.SORT_ORDER_NO = (
                            SELECT SORT_ORDER_NO
                            FROM SCM_MST_SHEET_COLUMNS
                            WHERE PROGRAM_ID = P_PROGRAM_ID
                              AND SHEET_NAME = P_SHEET_NAME
                              AND COLUMN_NAME = V_COLUMN_NAME
                                                )
                          AND NOT EXISTS
                            (
                                SELECT 1
                                FROM SCM_MST_TITLESET_USER
                                WHERE PROGRAM_ID = C.PROGRAM_ID
                                  AND SHEET_NAME = C.SHEET_NAME
                                  AND COLUMN_NAME = C.COLUMN_NAME
                                  AND USER_ID = P_USER_ID
                            );

                        --한번만 처리
                        IF V_MST_LOOP_CNT = 0 THEN
                            IF P_PROGRAM_ID = 'SCP0104' THEN
                                INSERT INTO SCM_MST_TITLESET_USER
                                (
                                    USER_ID
                                ,   PROGRAM_ID
                                ,   SHEET_NAME
                                ,   USER_INQUIRY_COLUMN_TYPE_CODE
                                ,   COLUMN_NAME
                                ,   SORT_ORDER_NO
                                ,   SUB_TOTAL_FLAG
                                ,   DATA_SORT_METHOD_CODE
                                ,   CREATED_BY
                                ,   CREATION_DATE
                                ,   LAST_UPDATED_BY
                                ,   LAST_UPDATE_DATE
                                ,   ATTRIBUTE3
                                ,   COLUMN_WIDTH
                                ,   CELL_COLOR
                                ,   TEXT_COLOR
                               )
                                SELECT P_USER_ID
                                     , C.PROGRAM_ID
                                     , C.SHEET_NAME
                                     , P_COLUMN_TYPE
                                     , C.COLUMN_NAME
                                     , C.SORT_ORDER_NO
                                     , V_SUB_TOTAL_FLAG
                                     , V_SORT_METHOD_CODE
                                     , P_USER_ID
                                     , SYSTIMESTAMP
                                     , P_USER_ID
                                     , SYSTIMESTAMP
                                     , NULL
                                     , CASE WHEN V_COLUMN_WIDTH IS NULL OR V_COLUMN_WIDTH = '' THEN C.COLUMN_WIDTH ELSE TO_NUMBER(V_COLUMN_WIDTH) END
                                     , V_CELL_COLOR
                                     , V_TEXT_COLOR
                                FROM SCM_MST_SHEET_COLUMNS C
                                WHERE C.PROGRAM_ID = 'SCP0104'
                                  AND C.SHEET_NAME = P_SHEET_NAME
                                  AND C.COLUMN_NAME = 'DUMMY_YN';
                            ELSIF P_PROGRAM_ID = 'SCP0105' THEN
                                INSERT INTO SCM_MST_TITLESET_USER
                                (
                                    USER_ID
                                ,   PROGRAM_ID
                                ,   SHEET_NAME
                                ,   USER_INQUIRY_COLUMN_TYPE_CODE
                                ,   COLUMN_NAME
                                ,   SORT_ORDER_NO
                                ,   SUB_TOTAL_FLAG
                                ,   DATA_SORT_METHOD_CODE
                                ,   CREATED_BY
                                ,   CREATION_DATE
                                ,   LAST_UPDATED_BY
                                ,   LAST_UPDATE_DATE
                                ,   ATTRIBUTE3
                                ,   COLUMN_WIDTH
                                ,   CELL_COLOR
                                ,   TEXT_COLOR
                               )
                                SELECT P_USER_ID
                                     , C.PROGRAM_ID
                                     , C.SHEET_NAME
                                     , P_COLUMN_TYPE
                                     , C.COLUMN_NAME
                                     , C.SORT_ORDER_NO
                                     , V_SUB_TOTAL_FLAG
                                     , V_SORT_METHOD_CODE
                                     , P_USER_ID
                                     , SYSTIMESTAMP
                                     , P_USER_ID
                                     , SYSTIMESTAMP
                                     , NULL
                                     , CASE WHEN V_COLUMN_WIDTH IS NULL OR V_COLUMN_WIDTH = '' THEN C.COLUMN_WIDTH ELSE TO_NUMBER(V_COLUMN_WIDTH) END
                                     , V_CELL_COLOR
                                     , V_TEXT_COLOR
                                FROM SCM_MST_SHEET_COLUMNS C
                                WHERE C.PROGRAM_ID = 'SCP0105'
                                  AND C.SHEET_NAME = P_SHEET_NAME
                                  AND C.COLUMN_NAME = 'IDX';
                            END IF;
                        END IF;

                        IF V_ACTIVE_FLAG = 'U' THEN
                            UPDATE SCM_MST_TITLESET_USER
                            SET ATTRIBUTE3 = 'N'
                            WHERE 1 = 1
                              AND PROGRAM_ID = P_PROGRAM_ID
                              AND SHEET_NAME = P_SHEET_NAME
                              AND COLUMN_NAME = V_COLUMN_NAME
                              AND USER_ID = P_USER_ID;
                        END IF;

                        -- -----------------------------------------------------------------------------------------------------
                    ELSIF (V_COLUMN_NAME != NULL OR V_COLUMN_NAME IS NOT NULL) THEN -- MEASURE

                        INSERT INTO SCM_MST_TITLESET_USER
                        (
                            USER_ID
                        ,   PROGRAM_ID
                        ,   SHEET_NAME
                        ,   USER_INQUIRY_COLUMN_TYPE_CODE
                        ,   COLUMN_NAME
                        ,   SORT_ORDER_NO
                        ,   SUB_TOTAL_FLAG
                        ,   DATA_SORT_METHOD_CODE
                        ,   CREATED_BY
                        ,   CREATION_DATE
                        ,   LAST_UPDATED_BY
                        ,   LAST_UPDATE_DATE
                        ,   COLUMN_WIDTH
                        ,   CELL_COLOR
                        ,   TEXT_COLOR
                       )
                        VALUES
                            (
                                P_USER_ID
                            ,   P_PROGRAM_ID
                            ,   P_SHEET_NAME
                            ,   P_COLUMN_TYPE
                            ,   V_COLUMN_NAME
                            ,   V_SORT_ORDER_NO
                            ,   V_SUB_TOTAL_FLAG
                            ,   V_SORT_METHOD_CODE
                            ,   P_USER_ID
                            ,   SYSTIMESTAMP
                            ,   P_USER_ID
                            ,   SYSTIMESTAMP
                            ,   CASE WHEN V_COLUMN_WIDTH IS NULL OR V_COLUMN_WIDTH = '' THEN NULL ELSE TO_NUMBER(V_COLUMN_WIDTH) END
                            ,   V_CELL_COLOR
                            ,   V_TEXT_COLOR
                           );
                        /*
                        INSERT INTO scm_mst_titleset_user
                        ( user_id    , program_id   , sheet_name    , user_inquiry_column_type_code
                        , column_name, sort_order_no, sub_total_flag, data_sort_method_code
                        , created_by , creation_date, last_updated_by, last_update_date )
                        SELECT
                         p_user_id       , p_program_id   , p_sheet_name    , p_column_type
                        , m.column_name, v_sort_order_no, v_sub_total_flag, v_sort_method_code
                        , p_user_id , SYSTIMESTAMP, p_user_id, SYSTIMESTAMP
                        FROM   scm_mst_sheet_measure m
                        WHERE  m.program_id = p_program_id
                        AND    m.sheet_name = p_sheet_name
                        AND    m.column_name = p_column_name;
                        ;*/

                    ELSE
                        BEGIN
                            V_ACTIVE_FLAG := P_ACTIVE_FLAG;
                            V_COLUMN_NAME := P_COLUMN_NAME;
                            V_SORT_ORDER_NO := P_SORT_ORDER_NO;
                            V_SUB_TOTAL_FLAG := P_SUB_TOTAL_FLAG;
                            V_SORT_METHOD_CODE := P_SORT_METHOD_CODE;

                            IF P_COLUMN_TYPE = 'C' THEN
                                INSERT INTO SCM_MST_TITLESET_USER
                                (
                                    USER_ID
                                ,   PROGRAM_ID
                                ,   SHEET_NAME
                                ,   USER_INQUIRY_COLUMN_TYPE_CODE
                                ,   COLUMN_NAME
                                ,   SORT_ORDER_NO
                                ,   SUB_TOTAL_FLAG
                                ,   DATA_SORT_METHOD_CODE
                                ,   CREATED_BY
                                ,   CREATION_DATE
                                ,   LAST_UPDATED_BY
                                ,   LAST_UPDATE_DATE
                                ,   COLUMN_WIDTH
                                ,   CELL_COLOR
                                ,   TEXT_COLOR
                               )
                                SELECT P_USER_ID
                                     , C.PROGRAM_ID
                                     , C.SHEET_NAME
                                     , P_COLUMN_TYPE
                                     , C.COLUMN_NAME
                                     --, P_SORT_ORDER_NO(I) + C.SORT_ORDER_NO - TRUNC(C.SORT_ORDER_NO)
                                     , CASE WHEN V_SORT_ORDER_NO IS NULL OR V_SORT_ORDER_NO = 0 THEN C.SORT_ORDER_NO ELSE V_SORT_ORDER_NO + C.SORT_ORDER_NO - ROUND( C.SORT_ORDER_NO, 1 ) END
                                     , V_SUB_TOTAL_FLAG
                                     , V_SORT_METHOD_CODE
                                     , P_USER_ID
                                     , SYSTIMESTAMP
                                     , P_USER_ID
                                     , SYSTIMESTAMP
                                     , CASE WHEN V_COLUMN_WIDTH IS NULL OR V_COLUMN_WIDTH = '' THEN C.COLUMN_WIDTH ELSE TO_NUMBER(V_COLUMN_WIDTH) END
                                     , V_CELL_COLOR
                                     , V_TEXT_COLOR
                                FROM SCM_MST_SHEET_COLUMNS C
                                WHERE C.PROGRAM_ID = P_PROGRAM_ID
                                  AND C.SHEET_NAME = P_SHEET_NAME
                                  AND ROUND( C.SORT_ORDER_NO, 1 ) = (
                                    SELECT ROUND( SORT_ORDER_NO, 1 )
                                    FROM SCM_MST_SHEET_COLUMNS
                                    WHERE PROGRAM_ID = P_PROGRAM_ID
                                      AND SHEET_NAME = P_SHEET_NAME
                                      AND COLUMN_NAME = V_COLUMN_NAME
                                                                    )
                                  AND NOT EXISTS
                                    (
                                        SELECT 1
                                        FROM SCM_MST_TITLESET_USER
                                        WHERE PROGRAM_ID = C.PROGRAM_ID
                                          AND SHEET_NAME = C.SHEET_NAME
                                          AND COLUMN_NAME = C.COLUMN_NAME
                                          AND USER_ID = P_USER_ID
                                    );
                            ELSE
                                IF (V_COLUMN_NAME != NULL OR V_COLUMN_NAME IS NOT NULL) THEN -- MEASURE
                                    INSERT INTO SCM_MST_TITLESET_USER
                                    (
                                        USER_ID
                                    ,   PROGRAM_ID
                                    ,   SHEET_NAME
                                    ,   USER_INQUIRY_COLUMN_TYPE_CODE
                                    ,   COLUMN_NAME
                                    ,   SORT_ORDER_NO
                                    ,   SUB_TOTAL_FLAG
                                    ,   DATA_SORT_METHOD_CODE
                                    ,   CREATED_BY
                                    ,   CREATION_DATE
                                    ,   LAST_UPDATED_BY
                                    ,   LAST_UPDATE_DATE
                                    ,   COLUMN_WIDTH
                                    ,   CELL_COLOR
                                    ,   TEXT_COLOR
                                   )
                                    VALUES
                                        (
                                            P_USER_ID
                                        ,   P_PROGRAM_ID
                                        ,   P_SHEET_NAME
                                        ,   P_COLUMN_TYPE
                                        ,   V_COLUMN_NAME
                                        ,   V_SORT_ORDER_NO
                                        ,   V_SUB_TOTAL_FLAG
                                        ,   V_SORT_METHOD_CODE
                                        ,   P_USER_ID
                                        ,   SYSTIMESTAMP
                                        ,   P_USER_ID
                                        ,   SYSTIMESTAMP
                                        ,   CASE WHEN V_COLUMN_WIDTH IS NULL OR V_COLUMN_WIDTH = '' THEN NULL ELSE TO_NUMBER(V_COLUMN_WIDTH) END
                                        ,   V_CELL_COLOR
                                        ,   V_TEXT_COLOR
                                       );
                                END IF;
                            END IF;
                        END;
                    END IF;
                END IF;
            END;
        END LOOP;

    V_LOG_TYPE := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := NULL;
    D_EVENT_DATE := SYSTIMESTAMP;
    PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION,
                         D_EVENT_DATE,
                         p_in_para_data => V_IN_PARA_DATA
    );

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SQLERRM;
        V_PROC_INPUT := JSON_OBJECT(
            'P_PROGRAM_ID' VALUE P_PROGRAM_ID,
            'P_SHEET_NAME' VALUE P_SHEET_NAME,
            'P_COLUMN_TYPE' VALUE P_COLUMN_TYPE,
            'P_ACTIVE_FLAG' VALUE P_ACTIVE_FLAG,
            'P_COLUMN_NAME' VALUE P_COLUMN_NAME,
            'P_SORT_ORDER_NO' VALUE P_SORT_ORDER_NO,
            'P_SUB_TOTAL_FLAG' VALUE P_SUB_TOTAL_FLAG,
            'P_SORT_METHOD_CODE' VALUE P_SORT_METHOD_CODE,
            'P_USER_ID' VALUE P_USER_ID,
            'P_COLUMN_WIDTH' VALUE P_COLUMN_WIDTH,
            'P_CELL_COLOR' VALUE P_CELL_COLOR,
            'P_TEXT_COLOR' VALUE P_TEXT_COLOR
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

END SCM0002_SET_TITLESET_POPUP;
/
