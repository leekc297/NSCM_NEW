-- SOURCE-FRESH: SCM_MGR.PR_DM_PLN_CUST_FCST_TO_MKT_FCST PROCEDURE LAST_DDL=2026-09-02 17:30:31 FETCHED=2026-09-29 13:11 DB=ZIOUI1
-- [E20260929-DMF0014CFSEQ] GT_DPCF_CUST_FCST_DIVISION.SEQ 0-base 채번 → MAKE_CUST_FCST 루프 복구
SET DEFINE OFF
SET SQLBLANKLINES ON
CREATE OR REPLACE PROCEDURE SCM_MGR."PR_DM_PLN_CUST_FCST_TO_MKT_FCST" 

/* 데이터 확인이 필요할 경우 '--확인' 을 '--확인' 으로 변경하면 DEBUG 모드이고 */
    /* '--확인' 을 '--확인' 으로 변경하면 일반 모드임 */
    /*
    ● PR_DM_PLN_CUST_FCST_TO_MKT_FCST 로직 구조
    -- --------------------------------------------------------
    LOOP_1 (n_PSI_GROUP_CNT : MEASURE별 INPUT된 ROWS만큼 처리)
    -- --------------------------------------------------------
        -- ------------------------------------------------------
        LOOP_1 (CUR_CAR_RESULT : 커서 로딩처리)
        -- ------------------------------------------------------
            -- --------------------------------------------------------
            LOOP_3 (n_PSI_GROUP_CNT : MEASURE별 INPUT된 ROWS만큼 처리)
            -- --------------------------------------------------------
                - PLAN WEEK 추출
                - MEASURE별 BUCKET_TYPE 추출
                - UPLOAD_UOM 추출
                - CONVERT_QTY_PACK 산출
                - BUCKET_TYPE별 MST_BUCKET_CONVERSION 설정날짜로 SPLIT
                    -- -----------------------------------------------------
                    LOOP_4 (@n_bucketcount : BUCKET수량만큼 ROWS 증가 처리)
                    -- -----------------------------------------------------
                        - DM_PLN_MKT_FCST 테이블에 INSERT
                    -- -----------------------------------------------------
                    LOOP_4_END (@n_bucketcount : BUCKET수량만큼 ROWS 증가 처리)
                    -- -----------------------------------------------------
                - DM_PLN_CUSTOMER_PSI 테이블의 처리데이터 작업중임을 마킹 UPDATE

            -- --------------------------------------------------------
            LOOP_3_END
            -- --------------------------------------------------------
        -- ------------------------------------------------------
        LOOP_1_END (CLOSE 커서)
        -- ------------------------------------------------------
        - Input 데이터중 실제 적용될 시작과 끝 날짜산출
        - DM_PLN_CUSTOMER_PSI 테이블의 SPLIT 처리완료된 데이터 INSERT
        - DM_PLN_MKT_FCST 테이블에 SPLIT 처리완료된 데이터 INSERT
    -- --------------------------------------------------------
    LOOP_1_END
    -- --------------------------------------------------------
    */
    /*===================================================================================================
     * Program ID   : PR_DM_PLN_CUST_FCST_TO_MKT_FCST
     * Description  : MKT FCST - Car Production Result Mapping
     * Program History
     *===================================================================================================
     *   Date       In Charge      Description
     *===================================================================================================
     * 2018. 01. 11    KHSONG      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
     * 2022. 10. 26    KDW2819    [C20221024-000507]CUST FCST Upload 오류 수정
     * 2024. 04. 30    kcw3408     N:N Model Mapping_적재 추가(집계 시점에 Cust Item/Unloading Point/Plant 고려,Valid Range 1~5에 포함되지 않는 구간은 Calloff 데이터를 집계하지 않음)
     * 2024. 11. 26    JSSBAE    [E20241126-000426]_Cust.FCST(P+P) Measure 로직 수정
     * 2024. 12. 19    KANG.H.J    [PJ2024-50647] 자동차사업부 고객 수요 분석 기능 개선
     * 2026.07.06   ZIONEX        [PJ202650304] NextSCM Migration
     *=================================================================================================*/
 AS

    V_PROGRAM_NAME            VARCHAR2(200 CHAR) := $$PLSQL_UNIT;
    V_IN_PARA_DATA            VARCHAR2(4000 CHAR);
    V_STEP                    VARCHAR2(4000 CHAR) := NULL;
    V_LOG_TYPE                VARCHAR2(30 CHAR);
    N_LOG_COUNT               INTEGER := 0;
    V_LOG_MESSAGE             VARCHAR2(1000 CHAR);
    V_DESCRIPTION             VARCHAR2(500 CHAR);
    D_EVENT_DATE              DATE;
    V_DIVISION_ID             VARCHAR2(4000 CHAR);
    V_CUSTOMER_PROJECT_CODE   VARCHAR2(4000 CHAR);
    V_CUSTOMER_MODEL          VARCHAR2(4000 CHAR);
    V_SCM_SITE_ID             VARCHAR2(4000 CHAR);
    V_DOM_EXP                 VARCHAR2(4000 CHAR);
    V_FCST_TYPE               VARCHAR2(4000 CHAR);
    V_MEASURE_GROUP           VARCHAR2(4000 CHAR);
    V_MEASURE                 VARCHAR2(4000 CHAR);
    V_YYYYMMDD                VARCHAR2(4000 CHAR);
    V_INCOTERMS               VARCHAR2(4000 CHAR);
    V_PLANT_SITE_ID           VARCHAR2(4000 CHAR);
    V_PROJECT_CODE            VARCHAR2(4000 CHAR);
    V_ITEM_ID                 VARCHAR2(4000 CHAR);
    V_QTY                     NUMBER(20, 10);
    V_UPLOAD_UOM              VARCHAR2(4000 CHAR);
    V_CREATED_BY              VARCHAR2(4000 CHAR);
    V_CREATION_DATE           DATE;
    V_LAST_UPDATED_BY         VARCHAR2(4000 CHAR);
    V_LAST_UPDATE_DATE        DATE;
    V_BATCH_RESULT            VARCHAR2(4000 CHAR);
    V_FETCH_STATUS            INTEGER := 0;
    CUR_CAR_RESULT            SYS_REFCURSOR;
    V_MST_UPLOAD_UOM          VARCHAR2(4000 CHAR);
    V_MST_UPLOAD_BUCKET_TYPE  VARCHAR2(4000 CHAR);
    V_MST_SUMMARY_BUCKET_TYPE VARCHAR2(4000 CHAR);
    V_MST_CONVERT_QTY         VARCHAR2(4000 CHAR);
    V_PLAN_WEEK               VARCHAR2(4000 CHAR);
    V_SPLIT_RESULT            VARCHAR2(4000 CHAR);
    V_ATTRIBUTE1              VARCHAR2(4000 CHAR);
    V_ATTRIBUTE2              VARCHAR2(4000 CHAR);
    V_ATTRIBUTE3              VARCHAR2(4000 CHAR);
    V_ATTRIBUTE4              VARCHAR2(4000 CHAR);
    V_ATTRIBUTE5              VARCHAR2(4000 CHAR);
    V_ATTRIBUTE6              VARCHAR2(4000 CHAR);
    V_ATTRIBUTE7              VARCHAR2(4000 CHAR);
    V_ATTRIBUTE8              VARCHAR2(4000 CHAR);
    V_ATTRIBUTE9              VARCHAR2(4000 CHAR);
    V_ATTRIBUTE10             VARCHAR2(4000 CHAR);
    V_DAY_VALID               VARCHAR2(8 CHAR);
    V_START_WEEK              VARCHAR2(8 CHAR);
    N_BATCH_RESULT            VARCHAR2(4000 CHAR);
    N_PSI_UPDATE_COUNT        INTEGER := 0;
    N_PSI_DELETE_COUNT        INTEGER := 0;
    N_PSI_INSERT_COUNT        INTEGER := 0;
    N_FCST_DELETE_COUNT       INTEGER := 0;
    N_FCST_INSERT_COUNT       INTEGER := 0;
    N_BUCKETCOUNT             INTEGER := 0;
    N_BUCKETINSERT            INTEGER := 1;
    N_PSI_GROUP_INSERT        INTEGER := 1;
    N_PSI_GROUP_CNT           INTEGER := 0;
    N_MIN_YYYYMMDD            VARCHAR2(4000 CHAR);
    N_MAX_YYYYMMDD            VARCHAR2(4000 CHAR);
    N_PLAN_WEEK               VARCHAR2(4000 CHAR);
    N_VALID_BUCKET_TYPE       VARCHAR2(4000 CHAR);
    N_UPLOAD_BUCKET_TYPE      VARCHAR2(4000 CHAR);
    N_SUMMARY_BUCKET_TYPE     VARCHAR2(4000 CHAR);
    N_UPLOAD_UOM              VARCHAR2(4000 CHAR);
    N_UPLOAD_UOM_KEY          VARCHAR2(4000 CHAR);
    N_AUTO_SPLIT_DATA         VARCHAR2(4000 CHAR);
    N_ITEM_CLASS_NAME         VARCHAR2(4000 CHAR);
    N_PROJECT_CODE            VARCHAR2(4000 CHAR);
    N_ITEM_ID                 VARCHAR2(4000 CHAR);
    N_CONVERT_QTY_PACK        NUMBER(20, 10);
    N_CONVERT_QTY_MODULE      NUMBER(20, 10);
    N_CONVERT_QTY_CELL        NUMBER(20, 10);
    N_CONVERT_QTY             NUMBER(20, 10);
    N_CALC_QTY                NUMBER(20, 1);
    N_ADD_QTY                 NUMBER(20, 1);
    N_TEST_VAL                VARCHAR2(4000 CHAR);
    V_I                       INTEGER;
    V_CNT                     INTEGER;
    V_CUST_FCST_DIVISION      VARCHAR2(30 CHAR);
    V_CNT_1                   INTEGER := 0;
    V_CNT_2                   INTEGER := 0;
    V_PROC_INPUT              CLOB := NULL;
    V_SQL_CODE                VARCHAR2(100 CHAR) := NULL;
    V_SQL_ERRMSG              VARCHAR2(4000 CHAR) := NULL;
    V_BACKTRACE               VARCHAR2(4000 CHAR) := NULL;
BEGIN

    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT||'.' ||UTL_CALL_STACK.SUBPROGRAM(1) (2);
    END IF;

    V_IN_PARA_DATA := NULL;

    /* LOG 용 변수 설정 */

    DELETE FROM GT_DPCF_RESULTS_2; /* 원본 TRUNCATE→GTT는 DELETE(단일TX 원자성 보존·Oracle TRUNCATE 암묵COMMIT 회피) */
    /* ------------------------------------------------------------------------------------------ 20180301 추가 (END) */

    /* ------------------------------------------------------------------------------------------ 20180409 추가 (START) */
    /* GT_DPCF_TMP_SITE_CUSTOMER_MAP_2 TEMP TABLE */
    DELETE FROM GT_DPCF_TMP_SITE_CUSTOMER_MAP_2; /* 원본 TRUNCATE→GTT는 DELETE(단일TX 원자성 보존·Oracle TRUNCATE 암묵COMMIT 회피) */
    /* ------------------------------------------------------------------------------------------ 20180409 추가 (END) */

    /* 시작 LOG  (START) */
    V_LOG_TYPE := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := NULL;
    D_EVENT_DATE := SYSTIMESTAMP;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
    V_LOG_MESSAGE := NULL; /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
    /* 시작 LOG  (END) */
    SELECT COUNT(1)
      INTO V_CNT_1
      FROM SYS.DUAL
     WHERE 1 = 2;
    IF V_CNT_1 > 0 THEN
        NULL;
    END IF;
    /* 트랜잭션 (START) */

    /* ----------------------------------------------------------------------------------------- */
    BEGIN
        /* ----------------------------------------------------------------------------------------- */
        BEGIN
            INSERT
            INTO GT_DPCF_DM_PLN_CUSTOMER_PSI_2
                (DIVISION_ID
                , CUSTOMER_PROJECT_CODE
                , CUSTOMER_MODEL
                , SCM_SITE_ID
                , DOM_EXP
                , FCST_TYPE
                , MEASURE_GROUP
                , MEASURE
                , YYYYMMDD
                , INCOTERMS
                , PLANT_SITE_ID
                , PROJECT_CODE
                , ITEM_ID
                , QTY
                , UPLOAD_UOM
                , CREATED_BY
                , CREATION_DATE
                , LAST_UPDATED_BY
                , LAST_UPDATE_DATE
                , BATCH_RESULT
                , MST_UPLOAD_UOM
                , MST_UPLOAD_BUCKET_TYPE
                , MST_SUMMARY_BUCKET_TYPE
                , MST_CONVERT_QTY
                , PLAN_WEEK
                , SPLIT_RESULT
                , ATTRIBUTE1
                , ATTRIBUTE2
                , ATTRIBUTE3
                , ATTRIBUTE4
                , ATTRIBUTE5
                , ATTRIBUTE6
                , ATTRIBUTE7
                , ATTRIBUTE8
                , ATTRIBUTE9
                , ATTRIBUTE10)
                SELECT DIVISION_ID
                     , CUSTOMER_PROJECT_CODE
                     , CUSTOMER_MODEL
                     , SCM_SITE_ID
                     , DOM_EXP
                     , FCST_TYPE
                     , MEASURE_GROUP
                     , MEASURE
                     , YYYYMMDD
                     , INCOTERMS
                     , PLANT_SITE_ID
                     , PROJECT_CODE
                     , ITEM_ID
                     , QTY
                     , UPLOAD_UOM
                     , CREATED_BY
                     , CREATION_DATE
                     , LAST_UPDATED_BY
                     , LAST_UPDATE_DATE
                     , BATCH_RESULT
                     , MST_UPLOAD_UOM
                     , MST_UPLOAD_BUCKET_TYPE
                     , MST_SUMMARY_BUCKET_TYPE
                     , MST_CONVERT_QTY
                     , PLAN_WEEK
                     , SPLIT_RESULT
                     , ATTRIBUTE1
                     , ATTRIBUTE2
                     , ATTRIBUTE3
                     , ATTRIBUTE4
                     , ATTRIBUTE5
                     , ATTRIBUTE6
                     , ATTRIBUTE7
                     , ATTRIBUTE8
                     , ATTRIBUTE9
                     , ATTRIBUTE10
                  FROM DM_PLN_CUSTOMER_PSI
                 WHERE BATCH_RESULT = 'UI' /* 'UI'로 마킹된 데이터만 처리 */
                   AND MEASURE_GROUP = 'CUST_FCST' /* FCST 데이터만 처리 */ /* AND QTY > 0                  -- QTY값이 0인것도 기존데이터 초기화를 위해서 필요함 */
                  ORDER BY DIVISION_ID
                         , SCM_SITE_ID
                         , YYYYMMDD;
        END;
        /* ---------------------------------------------------------------------------------------------------------- 대상자료 저장 END */

        /* [E20241126-000426]_Cust.FCST(P+P) Measure 로직 수정 START */
        /* 프로시져를 호출하여, CUST_FCST 메져 데이터를 생성한다 */
        DELETE FROM GT_DPCF_CUST_FCST_DIVISION; /* 원본 TRUNCATE→GTT는 DELETE(단일TX 원자성 보존·Oracle TRUNCATE 암묵COMMIT 회피) */

        INSERT
        INTO GT_DPCF_CUST_FCST_DIVISION
            (DIVISION_ID)
            SELECT DISTINCT DIVISION_ID
              FROM GT_DPCF_DM_PLN_CUSTOMER_PSI_2;
        /* [E20241126-000426]_Cust.FCST(P+P) Measure 로직 수정 END */

        /* DM_PLN_CUSTOMER_PSI 대상 데이터의 GROUP별 COUNT ------------------------------------------------------------------------------- START */
        BEGIN
            BEGIN
                INSERT
                INTO GT_DPCF_PSI_GROUP_COUNT_2
                    (DIVISION_ID
                    , CUSTOMER_PROJECT_CODE
                    , CUSTOMER_MODEL
                    , SCM_SITE_ID
                    , DOM_EXP
                    , FCST_TYPE
                    , MEASURE_GROUP
                    , MEASURE
                    , INCOTERMS
                    , PLANT_SITE_ID
                    , PSI_ROWNUM)
                    SELECT DIVISION_ID
                         , CUSTOMER_PROJECT_CODE
                         , CUSTOMER_MODEL
                         , SCM_SITE_ID
                         , DOM_EXP
                         , FCST_TYPE
                         , MEASURE_GROUP
                         , MEASURE
                         , INCOTERMS
                         , PLANT_SITE_ID
                         , ROW_NUMBER() OVER (ORDER BY DIVISION_ID) PSI_ROWNUM
                      FROM GT_DPCF_DM_PLN_CUSTOMER_PSI_2
                      GROUP BY DIVISION_ID
                             , CUSTOMER_PROJECT_CODE
                             , CUSTOMER_MODEL
                             , SCM_SITE_ID
                             , DOM_EXP
                             , FCST_TYPE
                             , MEASURE_GROUP
                             , MEASURE
                             , INCOTERMS
                             , PLANT_SITE_ID;
            END;

            BEGIN
                SELECT MAX(PSI_ROWNUM)
                  INTO N_PSI_GROUP_CNT
                  FROM GT_DPCF_PSI_GROUP_COUNT_2;
            END;

        END;
        /* DM_PLN_CUSTOMER_PSI 대상 데이터의 GROUP별 COUNT ------------------------------------------------------------------------------- END */

        /* ------------------------------------------------------------------------------------------------------------- PSI GROUP LOOP START */
        /* ############################################################################################################# */
        /* ------------------------------------------------------------------------------------------------------------- PSI GROUP LOOP START */
        WHILE N_PSI_GROUP_INSERT <= N_PSI_GROUP_CNT LOOP
            /* (임시테이블 존재여부 확인후 생성) START ---------------------------- */
            /* (0) */

            BEGIN
                /* ---------------------------- */
                BEGIN
                    INSERT
                    INTO GT_DPCF_T3_DM_PLN_CUSTOMER_PSI
                        SELECT *
                          FROM GT_DPCF_DM_PLN_CUSTOMER_PSI_2
                         WHERE DIVISION_ID = 'x';
                    DELETE FROM GT_DPCF_T3_DM_PLN_CUSTOMER_PSI; /* 원본 TRUNCATE→GTT는 DELETE(단일TX 원자성 보존·Oracle TRUNCATE 암묵COMMIT 회피) */
                END;
                /* ---------------------------- */
                BEGIN
                    INSERT
                    INTO GT_DPCF_T2_DM_PLN_CUSTOMER_PSI
                        SELECT *
                          FROM GT_DPCF_DM_PLN_CUSTOMER_PSI_2
                         WHERE DIVISION_ID = 'x';
                    DELETE FROM GT_DPCF_T2_DM_PLN_CUSTOMER_PSI; /* 원본 TRUNCATE→GTT는 DELETE(단일TX 원자성 보존·Oracle TRUNCATE 암묵COMMIT 회피) */
                END;

            END;

            /* (임시테이블 존재여부 확인후 생성) END ---------------------------- */

            /* Cursor 데이터 로딩 ----------------------------------------------------------------------------------------------- START */
            BEGIN
                /* Cursor 로 처리 */

                /* CUR_CAR_RESULT CURSOR FAST_FORWARD FOR */
                OPEN CUR_CAR_RESULT FOR
                    SELECT DIVISION_ID
                         , CUSTOMER_PROJECT_CODE
                         , CUSTOMER_MODEL
                         , SCM_SITE_ID
                         , DOM_EXP
                         , FCST_TYPE
                         , MEASURE_GROUP
                         , MEASURE
                         , YYYYMMDD
                         , INCOTERMS
                         , PLANT_SITE_ID
                         , PROJECT_CODE
                         , ITEM_ID
                         , QTY
                         , UPPER(RTRIM(LTRIM(UPLOAD_UOM)))
                         , CREATED_BY
                         , CREATION_DATE
                         , LAST_UPDATED_BY
                         , LAST_UPDATE_DATE
                         , BATCH_RESULT
                         , MST_UPLOAD_UOM
                         , MST_UPLOAD_BUCKET_TYPE
                         , MST_SUMMARY_BUCKET_TYPE
                         , MST_CONVERT_QTY
                         , PLAN_WEEK
                         , SPLIT_RESULT
                         , ATTRIBUTE1
                         , ATTRIBUTE2
                         , ATTRIBUTE3
                         , ATTRIBUTE4
                         , ATTRIBUTE5
                         , ATTRIBUTE6
                         , ATTRIBUTE7
                         , ATTRIBUTE8
                         , ATTRIBUTE9
                         , ATTRIBUTE10
                      FROM GT_DPCF_DM_PLN_CUSTOMER_PSI_2 A
                     WHERE 1 = 1
                       AND EXISTS (SELECT 1
                                     FROM GT_DPCF_PSI_GROUP_COUNT_2 B
                                    WHERE B.PSI_ROWNUM = N_PSI_GROUP_INSERT
                                      AND A.DIVISION_ID = B.DIVISION_ID
                                      AND A.CUSTOMER_PROJECT_CODE = B.CUSTOMER_PROJECT_CODE
                                      AND A.CUSTOMER_MODEL = B.CUSTOMER_MODEL
                                      AND A.SCM_SITE_ID = B.SCM_SITE_ID
                                      AND A.DOM_EXP = B.DOM_EXP
                                      AND A.FCST_TYPE = B.FCST_TYPE
                                      AND A.MEASURE_GROUP = B.MEASURE_GROUP
                                      AND A.MEASURE = B.MEASURE
                                      AND A.INCOTERMS = B.INCOTERMS
                                      AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
                                  );
            END;
            /* */
            BEGIN
                FETCH CUR_CAR_RESULT
                    INTO V_DIVISION_ID
                        , V_CUSTOMER_PROJECT_CODE
                        , V_CUSTOMER_MODEL
                        , V_SCM_SITE_ID
                        , V_DOM_EXP
                        , V_FCST_TYPE
                        , V_MEASURE_GROUP
                        , V_MEASURE
                        , V_YYYYMMDD
                        , V_INCOTERMS
                        , V_PLANT_SITE_ID
                        , V_PROJECT_CODE
                        , V_ITEM_ID
                        , V_QTY
                        , V_UPLOAD_UOM
                        , V_CREATED_BY
                        , V_CREATION_DATE
                        , V_LAST_UPDATED_BY
                        , V_LAST_UPDATE_DATE
                        , V_BATCH_RESULT
                        , V_MST_UPLOAD_UOM
                        , V_MST_UPLOAD_BUCKET_TYPE
                        , V_MST_SUMMARY_BUCKET_TYPE
                        , V_MST_CONVERT_QTY
                        , V_PLAN_WEEK
                        , V_SPLIT_RESULT
                        , V_ATTRIBUTE1
                        , V_ATTRIBUTE2
                        , V_ATTRIBUTE3
                        , V_ATTRIBUTE4
                        , V_ATTRIBUTE5
                        , V_ATTRIBUTE6
                        , V_ATTRIBUTE7
                        , V_ATTRIBUTE8
                        , V_ATTRIBUTE9
                        , V_ATTRIBUTE10;
                IF CUR_CAR_RESULT%NOTFOUND THEN
                    V_FETCH_STATUS := -1;
                ELSE
                    V_FETCH_STATUS := 0;
                END IF;
            END;

            /* (WHILE START) ---------------------------------------------------------------------------------------------------------------- */
            WHILE V_FETCH_STATUS = 0 LOOP

                /* 변수 초기화 */
                BEGIN
                    V_START_WEEK := NULL;
                    N_UPLOAD_BUCKET_TYPE := NULL;
                    N_SUMMARY_BUCKET_TYPE := NULL;
                    N_PLAN_WEEK := NULL;
                    N_UPLOAD_UOM := NULL;
                    N_ITEM_CLASS_NAME := NULL;
                    N_PROJECT_CODE := NULL;
                    N_ITEM_ID := NULL;
                    N_UPLOAD_UOM_KEY := NULL;
                    N_AUTO_SPLIT_DATA := NULL;
                    N_CONVERT_QTY_PACK := 0;
                    N_CONVERT_QTY_MODULE := 0;
                    N_CONVERT_QTY_CELL := 0;
                    N_CONVERT_QTY := 0;
                END;

                /* 마스터에 설정된 MEASURE별 BUCKET_TYPE 추출 */
                /* (F03) */
                IF N_UPLOAD_BUCKET_TYPE IS NULL THEN
                    SELECT UPLOAD_BUCKET_TYPE
                         , SUMMARY_BUCKET_TYPE
                         , MAX(PLAN_WEEK)
                      INTO N_UPLOAD_BUCKET_TYPE
                         , N_SUMMARY_BUCKET_TYPE
                         , N_PLAN_WEEK
                      FROM DM_MST_CUSTOMER_FCST
                     WHERE 1 = 1
                       AND DIVISION_ID = V_DIVISION_ID
                       AND SCM_SITE_ID = V_SCM_SITE_ID
                       AND MEASURE_GROUP = V_MEASURE_GROUP
                       AND MEASURE = V_MEASURE
                       AND VALID_YN = 'Y' /* 20180409 SongKH Add */
                       AND PLAN_WEEK = (SELECT MAX(PLAN_WEEK)
                                          FROM DM_MST_CUSTOMER_FCST
                                         WHERE DIVISION_ID = V_DIVISION_ID
                                           AND SCM_SITE_ID = V_SCM_SITE_ID
                                           AND MEASURE_GROUP = V_MEASURE_GROUP
                                           AND MEASURE = V_MEASURE
                                           AND VALID_YN = 'Y' /* 20180409 SongKH Add */
                                       )
                      GROUP BY UPLOAD_BUCKET_TYPE
                             , SUMMARY_BUCKET_TYPE
                             , PLAN_WEEK;
                    DBMS_OUTPUT.PUT_LINE(N_UPLOAD_BUCKET_TYPE);
                    DBMS_OUTPUT.PUT_LINE(N_SUMMARY_BUCKET_TYPE);
                END IF;
                IF N_UPLOAD_BUCKET_TYPE = 'MONTHLY' THEN
                    V_START_WEEK := V_YYYYMMDD;
                ELSE
                    V_START_WEEK := TO_CHAR(FN_NEXT_DAY(TO_DATE(V_YYYYMMDD, 'YYYYMMDD'), 'MON') + (-7), 'YYYYMMDD');
                END IF;
                DBMS_OUTPUT.PUT_LINE('CUSTOMER_PROJECT_CODE ' ||V_CUSTOMER_PROJECT_CODE);
                DBMS_OUTPUT.PUT_LINE('CUSTOMER_MODEL ' ||V_CUSTOMER_MODEL);
                /*---- PROJECT_CODE 정보 추출하여 저장 ----*/
                BEGIN
                    SELECT PROJECT_CODE
                      INTO N_PROJECT_CODE
                      FROM DM_MST_CUSTOMER_MODEL
                     WHERE 1 = 1
                       AND DIVISION_ID = V_DIVISION_ID
                       AND CUSTOMER_PROJECT_CODE = V_CUSTOMER_PROJECT_CODE
                       AND CUSTOMER_MODEL = V_CUSTOMER_MODEL
                       AND SCM_SITE_ID = V_SCM_SITE_ID;
                    EXCEPTION WHEN NO_DATA_FOUND THEN
                        N_PROJECT_CODE := NULL;
                END;

                DBMS_OUTPUT.PUT_LINE('CUSTOMER_PROJECT_CODE ' ||V_CUSTOMER_PROJECT_CODE);
                DBMS_OUTPUT.PUT_LINE('CUSTOMER_MODEL ' ||V_CUSTOMER_MODEL);

                /* 20180228 추가 (S) */
                IF N_PROJECT_CODE IS NULL THEN
                    BEGIN
                        SELECT PROJECT_CODE
                          INTO N_PROJECT_CODE
                          FROM SCM_MST_SITE_ITEM
                         WHERE 1 = 1
                           AND DIVISION_ID = V_DIVISION_ID
                           AND PROJECT_CODE = V_PROJECT_CODE
                           AND ITEM_ID = V_ITEM_ID
                           AND SCM_SITE_ID = V_SCM_SITE_ID;
                    END;
                END IF;
                /* 20180228 추가 (E) */
                DBMS_OUTPUT.PUT_LINE('PROJECT_CODE ' ||N_PROJECT_CODE);

                /*---- ITEM_ID 정보 추출하여 저장 ----*/
                BEGIN
                    SELECT ITEM_ID
                      INTO N_ITEM_ID
                      FROM DM_MST_CUSTOMER_MODEL
                     WHERE 1 = 1
                       AND DIVISION_ID = V_DIVISION_ID
                       AND CUSTOMER_PROJECT_CODE = V_CUSTOMER_PROJECT_CODE
                       AND CUSTOMER_MODEL = V_CUSTOMER_MODEL
                       AND SCM_SITE_ID = V_SCM_SITE_ID;
                    EXCEPTION WHEN NO_DATA_FOUND THEN
                        N_ITEM_ID := NULL;
                END;

                /* 20180228 추가 (S) */
                IF N_ITEM_ID IS NULL THEN
                    BEGIN
                        SELECT ITEM_ID
                          INTO N_ITEM_ID
                          FROM SCM_MST_SITE_ITEM
                         WHERE 1 = 1
                           AND DIVISION_ID = V_DIVISION_ID
                           AND PROJECT_CODE = V_PROJECT_CODE
                           AND ITEM_ID = V_ITEM_ID
                           AND SCM_SITE_ID = V_SCM_SITE_ID;
                    END;
                END IF;

                /* CODE값이 존재하지 않는경우 처리불가  20180319 SKH MODIFY */
                DBMS_OUTPUT.PUT_LINE('PROJECT_CODE ' ||N_PROJECT_CODE);
                DBMS_OUTPUT.PUT_LINE('ITEM_ID ' ||N_ITEM_ID);
                IF N_PROJECT_CODE IS NULL OR N_PROJECT_CODE IS NULL OR N_ITEM_ID IS NULL OR N_ITEM_ID IS NULL THEN
                    V_LOG_TYPE := 'INVALID';
                    V_LOG_MESSAGE := 'Project_code OR Item_ID 가 존재하지 않습니다.';
                    GOTO ERR_RTN;
                END IF;
                /* 20180228 추가 (E) */

                /* 추출된 PROJECT_CODE, ITEM ID 값으로 대체 */
                BEGIN
                    V_ITEM_ID := N_ITEM_ID;
                    V_PROJECT_CODE := N_PROJECT_CODE;
                END;
                /*---- 마스터의 ITEM_CLASS_NAME 추출 ----*/
                BEGIN
                    SELECT UPPER(RTRIM(LTRIM(ITEM_CLASS_NAME)))
                      INTO N_ITEM_CLASS_NAME
                      FROM SCM_MST_ITEM_SN
                     WHERE 1 = 1
                       AND ITEM_ID = N_ITEM_ID
                      GROUP BY ITEM_CLASS_NAME;
                END;

                /*---- UOM 추출 ----*/
                N_UPLOAD_UOM := CASE
                                    WHEN (N_ITEM_CLASS_NAME LIKE '%CAR%') THEN
                                     'CAR'
                                    WHEN (N_ITEM_CLASS_NAME LIKE '%PACK%') THEN
                                     'PACK'
                                    WHEN (N_ITEM_CLASS_NAME LIKE '%MODULE%') THEN
                                     'MODULE'
                                    WHEN (N_ITEM_CLASS_NAME LIKE '%CELL%') THEN
                                     'CELL'
                                END;

                /* 20180320 제품이 아닌 상품인 경우에는 기본단위로 사용함 SKH ADDED */
                IF N_UPLOAD_UOM IS NULL THEN
                    N_UPLOAD_UOM := 'CELL';
                END IF;

                /*---- CONVERT_QTY_PACK 정보 추출하여 저장 ----*/
                BEGIN
                    SELECT NVL(CONVERT_QTY_PACK, 1)
                      INTO N_CONVERT_QTY_PACK
                      FROM DM_MST_CUSTOMER_MODEL /* 20180301 수정 */
                     WHERE 1 = 1
                       AND DIVISION_ID = V_DIVISION_ID
                       AND CUSTOMER_PROJECT_CODE = V_CUSTOMER_PROJECT_CODE
                       AND CUSTOMER_MODEL = V_CUSTOMER_MODEL
                       AND SCM_SITE_ID = V_SCM_SITE_ID;
                    EXCEPTION WHEN NO_DATA_FOUND THEN
                        N_CONVERT_QTY_PACK := NULL;
                END;
                /*---- CONVERT_QTY_MODULE 정보 추출하여 저장 ----*/
                BEGIN
                    SELECT NVL(CONVERT_QTY_MODULE, 1)
                      INTO N_CONVERT_QTY_MODULE
                      FROM DM_MST_CUSTOMER_MODEL /* 20180301 수정 */
                     WHERE 1 = 1
                       AND DIVISION_ID = V_DIVISION_ID
                       AND CUSTOMER_PROJECT_CODE = V_CUSTOMER_PROJECT_CODE
                       AND CUSTOMER_MODEL = V_CUSTOMER_MODEL
                       AND SCM_SITE_ID = V_SCM_SITE_ID;
                    EXCEPTION WHEN NO_DATA_FOUND THEN
                        N_CONVERT_QTY_MODULE := NULL;
                END;
                /*---- CONVERT_QTY_CELL 정보 추출하여 저장 ----*/
                BEGIN
                    SELECT NVL(CONVERT_QTY_CELL, 1)
                      INTO N_CONVERT_QTY_CELL
                      FROM DM_MST_CUSTOMER_MODEL /* 20180301 수정 */
                     WHERE 1 = 1
                       AND DIVISION_ID = V_DIVISION_ID
                       AND CUSTOMER_PROJECT_CODE = V_CUSTOMER_PROJECT_CODE
                       AND CUSTOMER_MODEL = V_CUSTOMER_MODEL
                       AND SCM_SITE_ID = V_SCM_SITE_ID
                      GROUP BY CONVERT_QTY_CELL
                             , DIVISION_ID
                             , CUSTOMER_PROJECT_CODE
                             , CUSTOMER_MODEL
                             , SCM_SITE_ID;
                    EXCEPTION WHEN NO_DATA_FOUND THEN
                        N_CONVERT_QTY_CELL := NULL;
                END;

                /*---- Convert Qty 구하기 START ----*/
                BEGIN
                    N_CONVERT_QTY := CASE
                                         WHEN (V_UPLOAD_UOM = 'CAR') THEN
                                          CASE
                                              WHEN N_UPLOAD_UOM = 'CAR ' THEN
                                               V_QTY /* n_CONVERT_QTY_PACK */
                                              WHEN N_UPLOAD_UOM = 'PACK' THEN
                                               V_QTY * N_CONVERT_QTY_PACK
                                              WHEN N_UPLOAD_UOM = 'MODULE' THEN
                                               V_QTY * N_CONVERT_QTY_PACK * N_CONVERT_QTY_MODULE
                                              WHEN N_UPLOAD_UOM = 'CELL' THEN
                                               V_QTY * N_CONVERT_QTY_PACK * N_CONVERT_QTY_MODULE * N_CONVERT_QTY_CELL
                                          END
                                         WHEN (V_UPLOAD_UOM = 'PACK') THEN
                                          CASE
                                              WHEN N_UPLOAD_UOM = 'PACK' THEN
                                               V_QTY
                                              WHEN N_UPLOAD_UOM = 'MODULE' THEN
                                               V_QTY * N_CONVERT_QTY_MODULE /* * n_CONVERT_QTY_PACK * n_CONVERT_QTY_MODULE */
                                              WHEN N_UPLOAD_UOM = 'CELL' THEN
                                               V_QTY * N_CONVERT_QTY_MODULE * N_CONVERT_QTY_CELL /* * n_CONVERT_QTY_PACK * n_CONVERT_QTY_MODULE * n_CONVERT_QTY_CELL */
                                          END
                                         WHEN (V_UPLOAD_UOM = 'MODULE') THEN
                                          CASE
                                              WHEN N_UPLOAD_UOM = 'MODULE' THEN
                                               V_QTY /* * n_CONVERT_QTY_MODULE */
                                              WHEN N_UPLOAD_UOM = 'CELL' THEN
                                               V_QTY * N_CONVERT_QTY_CELL /* * n_CONVERT_QTY_PACK * n_CONVERT_QTY_MODULE * n_CONVERT_QTY_CELL */
                                          END
                                         WHEN (V_UPLOAD_UOM = 'CELL') THEN
                                          CASE
                                              WHEN N_UPLOAD_UOM = 'CELL' THEN
                                               V_QTY /* * n_CONVERT_QTY_CELL */
                                          END
                                     END;

                END;

                /* DM_MST_CUSTOMER_MODEL에 설정안된 measure 는 초기화해줌 20180301추가 */
                BEGIN
                    IF N_CONVERT_QTY IS NULL OR N_CONVERT_QTY = 0 THEN
                        N_CONVERT_QTY := V_QTY * 1;
                    END IF;

                    /*---- Convert Qty 구하기 END ----*/
                    /* bucketcount 산출 */
                    BEGIN
                        N_BUCKETINSERT := 1; /* 초기화 */
                        N_BUCKETCOUNT := 0; /* 초기화 */
                        N_CALC_QTY := 0; /* 초기화 */
                        N_ADD_QTY := 0; /* 초기화 */
                    END;

                    /* 캘린더 임시테이블 생성 */
                    BEGIN
                        INSERT
                        INTO GT_DPCF_CALENDAR_DM_PLN_CUSTOMER_PSI
                            SELECT BASIS_YYYYMMDD
                                 , WEEK_NO
                              FROM SCM_SYS_CALENDAR_M
                             WHERE END_FLAG = 'x';
                        DELETE FROM GT_DPCF_CALENDAR_DM_PLN_CUSTOMER_PSI; /* 원본 TRUNCATE→GTT는 DELETE(단일TX 원자성 보존·Oracle TRUNCATE 암묵COMMIT 회피) */
                    END;

                    /* BUCKET_TYPE별 MST_BUCKET_CONVERSION 설정날짜로 SPLIT (START) */
                    BEGIN
                        /* ------------------------------------------------------------------------------------------------- */
                        IF N_UPLOAD_BUCKET_TYPE = 'MONTHLY'
                        /* ------------------------------------------------------------------------------------------------- */
                         THEN
                            BEGIN
                                INSERT
                                INTO GT_DPCF_CALENDAR_DM_PLN_CUSTOMER_PSI
                                    SELECT B.BASIS_YYYYMMDD
                                         , ROW_NUMBER() OVER (ORDER BY B.BASIS_YYYYMMDD) RN
                                      FROM DM_MST_BUCKET_CONVERSION A
                                         , SCM_SYS_CALENDAR_M B
                                         , SCM_SYS_CALENDAR_M C
                                     WHERE A.DIVISION_ID = V_DIVISION_ID
                                       AND A.SCM_SITE_ID = V_SCM_SITE_ID
                                       AND A.INCOTERMS = V_INCOTERMS
                                       AND A.YYYYMMDD = B.DAYOFWEEK
                                       AND A.BUCKET_PER = 'Y'
                                       AND A.VALID_YN = 'Y'
                                       AND B.CALENDAR_YYYY = C.CALENDAR_YYYY
                                       AND B.CALENDAR_MONTH = C.CALENDAR_MONTH
                                       AND C.BASIS_YYYYMMDD = V_START_WEEK; /* 해당 주차 */

                                SELECT MAX(RN)
                                  INTO N_BUCKETCOUNT
                                  FROM GT_DPCF_CALENDAR_DM_PLN_CUSTOMER_PSI;

                                /* -------------------------------------------------- MST_BUCKET 이 설정안된 경우도 처리되도록 20180301 추가 (START) */
                                IF N_BUCKETCOUNT IS NULL OR N_BUCKETCOUNT = 0 THEN
                                    BEGIN
                                        DELETE FROM GT_DPCF_RESULTS_2;

                                        INSERT
                                        INTO GT_DPCF_RESULTS_2
                                            SELECT BASIS_YYYYMMDD
                                                 , DAYOFWEEK
                                              FROM SCM_SYS_CALENDAR_M
                                             WHERE BASIS_YYYYMM = SUBSTR(V_START_WEEK, 1, 6) /* 매월 1일 날짜로 해당월의 모든 날짜 선택 */ /* AND DAYOFWEEK IN ('MON','TUE','WED','THU','FRI') ORDER BY BASIS_YYYYMMDD   -- 20180424 skh modify */
                                               AND DAYOFWEEK IN (SELECT SEGMENT3
                                                                   FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                                                                  WHERE 1 = 1
                                                                    AND SEGMENT1 = V_DIVISION_ID
                                                                    AND LOOKUP_TYPE = 'DEFAULT_BUCKET_DAY'
                                                                    AND SEGMENT2 = N_UPLOAD_BUCKET_TYPE
                                                                ) /* 20180424 skh 조건변경 */
                                              ORDER BY BASIS_YYYYMMDD;

                                        INSERT
                                        INTO GT_DPCF_CALENDAR_DM_PLN_CUSTOMER_PSI
                                            SELECT B.BASIS_YYYYMMDD
                                                 , ROW_NUMBER() OVER (ORDER BY B.BASIS_YYYYMMDD) RN
                                              FROM GT_DPCF_RESULTS_2 A
                                                 , SCM_SYS_CALENDAR_M B
                                             WHERE A.DAYOFWEEK = B.DAYOFWEEK
                                               AND A.YYYYMMDD = B.BASIS_YYYYMMDD;

                                        SELECT MAX(RN)
                                          INTO N_BUCKETCOUNT
                                          FROM GT_DPCF_CALENDAR_DM_PLN_CUSTOMER_PSI;

                                        N_AUTO_SPLIT_DATA := 'Y';

                                    END;
                                END IF;

                                /* -------------------------------------------------- MST_BUCKET 이 설정안된 경우도 처리되도록 20180301 추가 (END) */
                                /* bucketcount 산출 */

                            END;
                            /* ------------------------------------------------------------------------------------------------- */
                        ELSIF N_UPLOAD_BUCKET_TYPE = 'WEEKLY'
                        /* ------------------------------------------------------------------------------------------------- */
                         THEN
                            BEGIN
                                INSERT
                                INTO GT_DPCF_CALENDAR_DM_PLN_CUSTOMER_PSI
                                    SELECT B.BASIS_YYYYMMDD
                                         , ROW_NUMBER() OVER (ORDER BY B.BASIS_YYYYMMDD) RN
                                      FROM DM_MST_BUCKET_CONVERSION A
                                         , SCM_SYS_CALENDAR_M B
                                         , SCM_SYS_CALENDAR_M C
                                     WHERE A.DIVISION_ID = V_DIVISION_ID
                                       AND A.SCM_SITE_ID = V_SCM_SITE_ID
                                       AND A.INCOTERMS = V_INCOTERMS
                                       AND A.YYYYMMDD = B.DAYOFWEEK
                                       AND A.BUCKET_PER = 'Y'
                                       AND A.VALID_YN = 'Y'
                                       AND B.ISO_YYYYWW = C.ISO_YYYYWW
                                       AND C.BASIS_YYYYMMDD = V_START_WEEK; /* 해당 주차 */
                                /* bucketcount 산출 */
                                SELECT MAX(RN)
                                  INTO N_BUCKETCOUNT
                                  FROM GT_DPCF_CALENDAR_DM_PLN_CUSTOMER_PSI;

                                /* -------------------------------------------------- MST_BUCKET 이 설정안된 경우도 처리되도록 20180301 추가 (START) */
                                IF N_BUCKETCOUNT IS NULL OR N_BUCKETCOUNT = 0 THEN
                                    BEGIN
                                        DELETE FROM GT_DPCF_RESULTS_2;

                                        /* 날짜선택오류로 ISO_WEEK 조건추가 20180402 (SONGKH) */
                                        INSERT
                                        INTO GT_DPCF_RESULTS_2
                                            SELECT BASIS_YYYYMMDD
                                                 , DAYOFWEEK
                                              FROM SCM_SYS_CALENDAR_M Z
                                                 , (SELECT DISTINCT ISO_WEEK
                                                         , ISO_YYYYWW
                                                      FROM SCM_SYS_CALENDAR_M W
                                                     WHERE BASIS_START_DATE = V_START_WEEK
                                                   ) K /* 매주 월요일 날짜로 해당주의 날짜 선택 */
                                             WHERE Z.ISO_WEEK = K.ISO_WEEK
                                               AND Z.ISO_YYYYWW = K.ISO_YYYYWW /* AND DAYOFWEEK IN ('MON','TUE','WED','THU','FRI') ORDER BY BASIS_YYYYMMDD   -- 20180424 skh modify */
                                               AND DAYOFWEEK IN (SELECT SEGMENT3
                                                                   FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                                                                  WHERE 1 = 1
                                                                    AND SEGMENT1 = V_DIVISION_ID
                                                                    AND LOOKUP_TYPE = 'DEFAULT_BUCKET_DAY'
                                                                    AND SEGMENT2 = N_UPLOAD_BUCKET_TYPE
                                                                ) /* 20180424 skh 조건변경 */
                                              ORDER BY BASIS_YYYYMMDD;
                                        DBMS_OUTPUT.PUT_LINE(N_BUCKETCOUNT);
                                        /* PRINT v_DIVISION_ID */
                                        /* PRINT n_UPLOAD_BUCKET_TYPE */
                                        /* 날짜선택오류로 ISO_WEEK 조건추가 20180402 (SONGKH) */

                                        INSERT
                                        INTO GT_DPCF_CALENDAR_DM_PLN_CUSTOMER_PSI
                                            SELECT B.BASIS_YYYYMMDD
                                                 , ROW_NUMBER() OVER (ORDER BY B.BASIS_YYYYMMDD) RN
                                              FROM GT_DPCF_RESULTS_2 A
                                                 , SCM_SYS_CALENDAR_M B
                                             WHERE A.DAYOFWEEK = B.DAYOFWEEK
                                               AND A.YYYYMMDD = B.BASIS_YYYYMMDD;
                                        SELECT MAX(RN)
                                          INTO N_BUCKETCOUNT
                                          FROM GT_DPCF_CALENDAR_DM_PLN_CUSTOMER_PSI;
                                        /* 확인 SELECT n_bucketcount AS 'n_bucketcount IMSI' */

                                        N_AUTO_SPLIT_DATA := 'Y';

                                    END;
                                END IF;

                                /* -------------------------------------------------- MST_BUCKET 이 설정안된 경우도 처리되도록 20180301 추가 (END) */
                            END;

                        ELSIF N_UPLOAD_BUCKET_TYPE = 'DAILY'
                        /* ------------------------------------------------------------------------------------------------- */
                         THEN
                            BEGIN

                                INSERT
                                INTO GT_DPCF_CALENDAR_DM_PLN_CUSTOMER_PSI
                                    (BASIS_YYYYMMDD, RN)
                                VALUES
                                    (V_YYYYMMDD, 1);
                                N_BUCKETCOUNT := 1;
                            END;
                        END IF;
                        /* ------------------------------------------------------------------------------------------------- */
                    END;

                    /* BUCKET_TYPE별 MST_BUCKET_CONVERSION 설정날짜로 SPLIT (END) */

                    /* ------------------------------------------------------------------------------------------------------------- bucket loop START */
                    WHILE N_BUCKETINSERT <= N_BUCKETCOUNT LOOP
                        /* 변수 초기화 */
                        BEGIN
                            N_BATCH_RESULT := NULL;
                        END;

                        /* 대상날짜가 해당 MEASURE 의 BUCKET TYPE 과 동일한지 확인하여 같지않으면 INSERT INTO 처리하지 않으려고함 (START) ---------------------------------------------- */
                        BEGIN
                            V_DAY_VALID := NULL; /* 변수초기화 */
                            N_VALID_BUCKET_TYPE := NULL; /* 변수초기화 */

                            SELECT BASIS_YYYYMMDD
                              INTO V_DAY_VALID
                              FROM (SELECT BASIS_YYYYMMDD
                                         , RN
                                      FROM GT_DPCF_CALENDAR_DM_PLN_CUSTOMER_PSI
                                      ORDER BY BASIS_YYYYMMDD
                                   )
                             WHERE RN = N_BUCKETINSERT;
                        END;

                        /* Convert QTY값 산출 */
                        IF N_UPLOAD_BUCKET_TYPE = 'DAILY' THEN
                            BEGIN
                                N_CALC_QTY := V_QTY; /* DAILY 인경우는 계산필요없이 INPUT값을 그대로 사용함 */

                                SELECT UPLOAD_BUCKET_TYPE /* 해당주차의 bucket 추출 */
                                  INTO N_VALID_BUCKET_TYPE
                                  FROM DM_MST_CUSTOMER_FCST
                                 WHERE 1 = 1
                                   AND DIVISION_ID = V_DIVISION_ID
                                   AND SCM_SITE_ID = V_SCM_SITE_ID
                                   AND MEASURE_GROUP = V_MEASURE_GROUP
                                   AND MEASURE = V_MEASURE /* AND SUMMARY_BUCKET_VALUE = v_day_valid -- daily인경우 INPUT된 날짜 */
                                   AND SUMMARY_BUCKET_VALUE = TO_CHAR(FN_NEXT_DAY(TO_DATE(V_DAY_VALID, 'YYYYMMDD'), 'MON') + (- 7), 'YYYYMMDD') /* 2024.01.12 Philsu Park 수정. */
                                   AND PLAN_WEEK = N_PLAN_WEEK
                                   AND VALID_YN = 'Y'; /* 20180409 SongKH Add */

                            EXCEPTION
                                /* ⭐ [2026-08-14] 마스터에 해당 주차 bucket 이 없으면 NULL 로 둔다.
                                   N_VALID_BUCKET_TYPE 은 L909 에서 NULL 초기화되고 아래 979행에
                                   `IF N_VALID_BUCKET_TYPE IS NULL` 분기가 이미 있다 = NULL 은 설계된 경로.
                                   핸들러가 없어 ORA-01403 이 위로 튀었고, 이 프로시저의
                                   WHEN OTHERS THEN ROLLBACK 이 **호출자(DMF0014 업로드)의 INSERT까지**
                                   되돌려 "저장 완료인데 0건" 사고가 났다. */
                                WHEN NO_DATA_FOUND THEN
                                    N_VALID_BUCKET_TYPE := NULL;
                                WHEN TOO_MANY_ROWS THEN
                                    /* 마스터가 모호하면 유효 bucket 을 단정하지 않는다(동일 NULL 경로). */
                                    N_VALID_BUCKET_TYPE := NULL;
                            END;
                        ELSE
                            BEGIN
                                SELECT UPLOAD_BUCKET_TYPE /* 해당주차의 bucket 추출 */
                                  INTO N_VALID_BUCKET_TYPE
                                  FROM DM_MST_CUSTOMER_FCST
                                 WHERE 1 = 1
                                   AND DIVISION_ID = V_DIVISION_ID
                                   AND SCM_SITE_ID = V_SCM_SITE_ID
                                   AND MEASURE_GROUP = V_MEASURE_GROUP
                                   AND MEASURE = V_MEASURE
                                   AND SUMMARY_BUCKET_VALUE = TO_CHAR(FN_NEXT_DAY(TO_DATE(V_DAY_VALID, 'YYYYMMDD'), 'MON') + (- 7), 'YYYYMMDD') /* INPUT된 날짜의 당주 월요일 */
                                   AND PLAN_WEEK = N_PLAN_WEEK
                                   AND VALID_YN = 'Y'; /* 20180409 SongKH Add */
                            EXCEPTION
                                /* ⭐ [2026-08-14] 마스터에 해당 주차 bucket 이 없으면 NULL 로 둔다.
                                   N_VALID_BUCKET_TYPE 은 L909 에서 NULL 초기화되고 아래 979행에
                                   `IF N_VALID_BUCKET_TYPE IS NULL` 분기가 이미 있다 = NULL 은 설계된 경로.
                                   핸들러가 없어 ORA-01403 이 위로 튀었고, 이 프로시저의
                                   WHEN OTHERS THEN ROLLBACK 이 **호출자(DMF0014 업로드)의 INSERT까지**
                                   되돌려 "저장 완료인데 0건" 사고가 났다. */
                                WHEN NO_DATA_FOUND THEN
                                    N_VALID_BUCKET_TYPE := NULL;
                                WHEN TOO_MANY_ROWS THEN
                                    /* 마스터가 모호하면 유효 bucket 을 단정하지 않는다(동일 NULL 경로). */
                                    N_VALID_BUCKET_TYPE := NULL;
                            END;
                        END IF;

                        IF N_BUCKETINSERT < N_BUCKETCOUNT /* 마지막데이터가 아닌경우 SPLIT된값을 넣어줌 */
                         THEN
                            N_CALC_QTY := TRUNC(N_CONVERT_QTY / N_BUCKETCOUNT, 0);
                            N_ADD_QTY := N_ADD_QTY + N_CALC_QTY;

                        ELSE
                            /* 마지막 데이터인경우 나머지값을 몰아주기 */
                            N_CALC_QTY := N_CONVERT_QTY - N_ADD_QTY;
                        END IF;

                        /* 최신 UPLOAD_UOM 값을 변수에 셋팅 */
                        BEGIN
                            N_UPLOAD_UOM_KEY := N_UPLOAD_UOM;
                        END;

                        /* BUCKET_TYPE이 다른경우도 input 받은 measure 로 INSERT INTO 생성하도록 변경 (20180305) */
                        BEGIN
                            IF N_UPLOAD_BUCKET_TYPE <> N_VALID_BUCKET_TYPE THEN
                                N_UPLOAD_UOM_KEY := N_UPLOAD_UOM; /* 주차별 BUCKET_TYPE 이 달라도 그대로 사용함 */
                            END IF;
                        END;

                        /* BUCKET_TYPE이 다른경우도 input 받은 measure 로 INSERT INTO 생성하도록 변경 (20180305) */
                        BEGIN
                            IF N_VALID_BUCKET_TYPE IS NULL THEN
                                N_UPLOAD_UOM_KEY := NULL;
                            END IF;
                        END;

                        /* MERGE대상 : SPLIT_COMPLETED / SPLIT만 하여 확인하는 MEASURE : UPLOAD_COMPLETED */
                        BEGIN
                            IF N_UPLOAD_UOM_KEY IS NULL THEN
                                N_BATCH_RESULT := 'UPLOAD_COMPLETED';
                            ELSE
                                N_BATCH_RESULT := 'SPLIT_COMPLETED';
                            END IF;
                        END;

                        /* MASTER에 BUCKET 설정이 없는 데이터인경우 */
                        BEGIN
                            IF N_AUTO_SPLIT_DATA = 'Y' THEN
                                N_BATCH_RESULT := 'SPLIT_COMPLETED';
                            END IF;
                        END;

                        BEGIN
                            /* insert into  DM_PLN_CUSTOMER_PSI */
                            INSERT
                            INTO GT_DPCF_T3_DM_PLN_CUSTOMER_PSI /* */
                                (DIVISION_ID
                                , CUSTOMER_PROJECT_CODE
                                , CUSTOMER_MODEL
                                , SCM_SITE_ID
                                , DOM_EXP
                                , FCST_TYPE
                                , MEASURE_GROUP
                                , MEASURE
                                , YYYYMMDD
                                , INCOTERMS
                                , PLANT_SITE_ID
                                , PROJECT_CODE
                                , ITEM_ID
                                , QTY
                                , UPLOAD_UOM
                                , CREATED_BY
                                , CREATION_DATE
                                , LAST_UPDATED_BY
                                , LAST_UPDATE_DATE
                                , BATCH_RESULT
                                , MST_UPLOAD_UOM
                                , MST_UPLOAD_BUCKET_TYPE
                                , MST_SUMMARY_BUCKET_TYPE
                                , MST_CONVERT_QTY
                                , PLAN_WEEK
                                , SPLIT_RESULT
                                , ATTRIBUTE1
                                , ATTRIBUTE2
                                , ATTRIBUTE3
                                , ATTRIBUTE4
                                , ATTRIBUTE5
                                , ATTRIBUTE6
                                , ATTRIBUTE7
                                , ATTRIBUTE8
                                , ATTRIBUTE9
                                , ATTRIBUTE10)
                                SELECT V_DIVISION_ID
                                     , V_CUSTOMER_PROJECT_CODE
                                     , V_CUSTOMER_MODEL
                                     , V_SCM_SITE_ID
                                     , V_DOM_EXP
                                     , V_FCST_TYPE
                                     , V_MEASURE_GROUP /* ,RTRIM(LTRIM(TO_CHAR(TO_CHAR(v_MEASURE) || '_new_temp'))) */
                                     , V_MEASURE||'_new_temp'
                                     , (SELECT BASIS_YYYYMMDD FROM(SELECT BASIS_YYYYMMDD, ROW_NUMBER() OVER (ORDER BY BASIS_YYYYMMDD) RN FROM GT_DPCF_CALENDAR_DM_PLN_CUSTOMER_PSI) T WHERE RN = N_BUCKETINSERT)
                                     , V_INCOTERMS
                                     , V_PLANT_SITE_ID
                                     , V_PROJECT_CODE
                                     , V_ITEM_ID
                                     , N_CALC_QTY /* ROW별로 나눠진 값을 넣음 */
                                     , V_UPLOAD_UOM
                                     , V_CREATED_BY
                                     , V_CREATION_DATE
                                     , V_LAST_UPDATED_BY
                                     , SYSTIMESTAMP
                                     , N_BATCH_RESULT
                                     , N_UPLOAD_UOM
                                     , N_UPLOAD_BUCKET_TYPE
                                     , N_SUMMARY_BUCKET_TYPE
                                     , V_MST_CONVERT_QTY
                                     , V_PLAN_WEEK
                                     , V_SPLIT_RESULT
                                     , V_ATTRIBUTE1
                                     , V_ATTRIBUTE2
                                     , V_ATTRIBUTE3
                                     , V_ATTRIBUTE4
                                     , V_ATTRIBUTE5
                                     , V_ATTRIBUTE6
                                     , V_ATTRIBUTE7
                                     , V_ATTRIBUTE8
                                     , V_ATTRIBUTE9
                                     , V_ATTRIBUTE10
                                  FROM DUAL;
                        END;

                        BEGIN
                            N_CALC_QTY := 0; /* 사용후 초기화 */
                        END;

                        BEGIN
                            N_BUCKETINSERT := N_BUCKETINSERT + 1; /* 최대 ROWS 까지 증가시킴 */
                        END;

                    /*----------------------------------------------------------------------------------------------------------------*/
                    END LOOP;
                    /* ------------------------------------------------------------------------------------------------------------- bucket loop END */
                END;

                /* (10) */
                /*-------------------- DM_PLN_CUSTOMER_PSI 테이블 update --------------------*/
                BEGIN
                    UPDATE DM_PLN_CUSTOMER_PSI

                    SET    CUSTOMER_PROJECT_CODE = V_CUSTOMER_PROJECT_CODE
                          , CUSTOMER_MODEL        = V_CUSTOMER_MODEL
                          , SCM_SITE_ID           = V_SCM_SITE_ID
                          , DOM_EXP               = V_DOM_EXP
                          , FCST_TYPE             = V_FCST_TYPE
                          , MEASURE_GROUP         = V_MEASURE_GROUP
                          , MEASURE               = V_MEASURE
                          , YYYYMMDD              = V_YYYYMMDD
                          , INCOTERMS             = V_INCOTERMS
                          , PLANT_SITE_ID         = V_PLANT_SITE_ID
                          , PROJECT_CODE          = N_PROJECT_CODE /* n_PROJECT_CODE         -- 추출된값으로 셋팅 */
                          , ITEM_ID               = N_ITEM_ID /* n_ITEM_ID              -- 추출된값으로 셋팅 */
                          , QTY                   = V_QTY
                          , UPLOAD_UOM            = V_UPLOAD_UOM /* INPUT값 UPLOAD_UOM */
                          , CREATED_BY            = V_CREATED_BY
                          , CREATION_DATE         = V_CREATION_DATE
                          , LAST_UPDATED_BY       = V_LAST_UPDATED_BY
                          , LAST_UPDATE_DATE      = SYSTIMESTAMP
                          , BATCH_RESULT          = N_BATCH_RESULT /* 1.'UI':업로드데이터 2.'UPLOAD_COMPLETED':업데이트작업 3.'UPLOAD_UOM_NOT_FOUND':DM_MST_CUSTOMER_FCST 설정날짜에 안맞는 에러건 */
                           /* 4.'UPLOAD_COMPLETED':DM_PLN_MKT_FCST로 INSERT완료건  5. 'MERGE_COMPLETED':합산완료건 */
                          , MST_UPLOAD_UOM          = N_UPLOAD_UOM /* SCM_MST_ITEM_SN.UPLOAD_UOM 추출값 */
                          , MST_UPLOAD_BUCKET_TYPE  = N_UPLOAD_BUCKET_TYPE /* DM_MST_CUSTOMER_FCST.UPLOAD_BUCKET_TYPE 셋팅 */
                          , MST_SUMMARY_BUCKET_TYPE = N_SUMMARY_BUCKET_TYPE /* DM_MST_CUSTOMER_FCST.SUMMARY_BUCKET_TYPE 셋팅 */
                          , MST_CONVERT_QTY         = N_CONVERT_QTY /* DM_MST_CUSTOMER_FCST.CONVERT_QTY 셋팅 */
                          , PLAN_WEEK               = N_PLAN_WEEK /* DM_MST_CUSTOMER_FCST.PLAN_WEEK 셋팅 */
                          , SPLIT_RESULT            = V_SPLIT_RESULT
                          , ATTRIBUTE1              = V_ATTRIBUTE1
                          , ATTRIBUTE2              = V_ATTRIBUTE2
                          , ATTRIBUTE3              = V_ATTRIBUTE3
                          , ATTRIBUTE4              = V_ATTRIBUTE4
                          , ATTRIBUTE5              = V_ATTRIBUTE5
                          , ATTRIBUTE6              = V_ATTRIBUTE6
                          , ATTRIBUTE7              = V_ATTRIBUTE7
                          , ATTRIBUTE8              = V_ATTRIBUTE8
                          , ATTRIBUTE9              = V_ATTRIBUTE9
                          , ATTRIBUTE10             = V_ATTRIBUTE10
                    WHERE  DIVISION_ID = V_DIVISION_ID
                    AND    CUSTOMER_PROJECT_CODE = V_CUSTOMER_PROJECT_CODE
                    AND    CUSTOMER_MODEL = V_CUSTOMER_MODEL
                    AND    SCM_SITE_ID = V_SCM_SITE_ID
                    AND    DOM_EXP = V_DOM_EXP
                    AND    FCST_TYPE = V_FCST_TYPE
                    AND    MEASURE_GROUP = V_MEASURE_GROUP
                    AND    MEASURE = V_MEASURE
                    AND    YYYYMMDD = V_YYYYMMDD
                    AND    INCOTERMS = V_INCOTERMS
                    AND    PLANT_SITE_ID = V_PLANT_SITE_ID;
                    N_PSI_UPDATE_COUNT := N_PSI_UPDATE_COUNT + 1;
                END;
                /* (10) */

                BEGIN
                    FETCH CUR_CAR_RESULT
                        INTO V_DIVISION_ID
                            , V_CUSTOMER_PROJECT_CODE
                            , V_CUSTOMER_MODEL
                            , V_SCM_SITE_ID
                            , V_DOM_EXP
                            , V_FCST_TYPE
                            , V_MEASURE_GROUP
                            , V_MEASURE
                            , V_YYYYMMDD
                            , V_INCOTERMS
                            , V_PLANT_SITE_ID
                            , V_PROJECT_CODE
                            , V_ITEM_ID
                            , V_QTY
                            , V_UPLOAD_UOM
                            , V_CREATED_BY
                            , V_CREATION_DATE
                            , V_LAST_UPDATED_BY
                            , V_LAST_UPDATE_DATE
                            , V_BATCH_RESULT
                            , V_MST_UPLOAD_UOM
                            , V_MST_UPLOAD_BUCKET_TYPE
                            , V_MST_SUMMARY_BUCKET_TYPE
                            , V_MST_CONVERT_QTY
                            , V_PLAN_WEEK
                            , V_SPLIT_RESULT
                            , V_ATTRIBUTE1
                            , V_ATTRIBUTE2
                            , V_ATTRIBUTE3
                            , V_ATTRIBUTE4
                            , V_ATTRIBUTE5
                            , V_ATTRIBUTE6
                            , V_ATTRIBUTE7
                            , V_ATTRIBUTE8
                            , V_ATTRIBUTE9
                            , V_ATTRIBUTE10;
                    IF CUR_CAR_RESULT%NOTFOUND THEN
                        V_FETCH_STATUS := -1;
                    ELSE
                        V_FETCH_STATUS := 0;
                    END IF;
                END;
                /* (1) */

            END LOOP;
            /* (WHILE END ) ---------------------------------------------------------------------------------------------------------------- */

            BEGIN
                CLOSE CUR_CAR_RESULT;
            EXCEPTION
                WHEN INVALID_CURSOR THEN
                    NULL;
            END;

            /* ---input 데이터의 시작과 끝 산출 ------------------------------------------------------------- (start) EEEE */
BEGIN
                DELETE FROM GT_DPCF_MIN_MAX_PSI_2; /* ⭐ [2026-08-14] MEASURE별 cursor 작업이므로 초기화
                   — 이 GTT 는 ON COMMIT PRESERVE 라 지우지 않으면 measure 마다 누적되어
                     아래 `WHERE RN = 1` 이 복수 행을 반환한다(ORA-01422). 형제 블록 L1233 과 동일 패턴. */
                INSERT
                INTO GT_DPCF_MIN_MAX_PSI_2
                    (YYYYMMDD, RN)
                    SELECT YYYYMMDD
                         , ROW_NUMBER() OVER (ORDER BY YYYYMMDD) RN
                      FROM GT_DPCF_T3_DM_PLN_CUSTOMER_PSI
                      GROUP BY YYYYMMDD
                      ORDER BY YYYYMMDD;

            END;
            BEGIN
                SELECT YYYYMMDD
                  INTO N_MIN_YYYYMMDD
                  FROM GT_DPCF_MIN_MAX_PSI_2
                 WHERE RN = 1;

                SELECT YYYYMMDD
                  INTO N_MAX_YYYYMMDD
                  FROM GT_DPCF_MIN_MAX_PSI_2
                 WHERE RN = (SELECT MAX(RN)
                               FROM GT_DPCF_MIN_MAX_PSI_2
                            );
            END;

            /* -input 데이터의 시작과 끝 산출 ------------------------------------------------------------- (end) */

            /* -INSERT INTO 할 실제 데이터의 시작과 끝 구간 산출 ----------------------------------------------- (start) 20180409 */
            DELETE FROM GT_DPCF_TMP_SITE_CUSTOMER_MAP_2; /* MEASURE별 cursor 작업이므로 초기화 */

            INSERT
            INTO GT_DPCF_TMP_SITE_CUSTOMER_MAP_2
                SELECT A.DIVISION_ID
                     , A.SCM_SITE_ID
                     , A.MEASURE
                     , A.SUMMARY_BUCKET_VALUE START_DAY
                     , CASE
                            WHEN SUMMARY_BUCKET_TYPE = 'WEEKLY' THEN TO_CHAR(FN_NEXT_DAY(TO_DATE(SUMMARY_BUCKET_VALUE, 'YYYYMMDD'), 'SUN') + (0), 'YYYYMMDD')
                            ELSE A.SUMMARY_BUCKET_VALUE
                        END END_DAY
                  FROM DM_MST_CUSTOMER_FCST A
                INNER JOIN (SELECT DISTINCT DIVISION_ID
                                 , SCM_SITE_ID
                                 , MEASURE_GROUP
                              FROM GT_DPCF_T3_DM_PLN_CUSTOMER_PSI
                           ) RSLT
                  ON (A.DIVISION_ID = RSLT.DIVISION_ID AND A.SCM_SITE_ID = RSLT.SCM_SITE_ID AND A.MEASURE_GROUP = RSLT.MEASURE_GROUP)
                 WHERE 1 = 1
                   AND VALID_YN = 'Y' /* 20240507 KCW3408 수정 */
                   AND A.PLAN_WEEK = (SELECT MAX(PLAN_WEEK)
                                        FROM DM_MST_CUSTOMER_FCST X
                                       WHERE X.DIVISION_ID = A.DIVISION_ID
                                         AND X.SCM_SITE_ID = A.SCM_SITE_ID
                                         AND X.MEASURE_GROUP = A.MEASURE_GROUP
                                     )
                   AND A.SUMMARY_BUCKET_VALUE >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (- 7 * 1), 'YYYYMMDD') /* 당주 월요일 이후데이터만 */
                   AND SUMMARY_BUCKET_TYPE IN ('DAILY', 'WEEKLY')
                  UNION
                SELECT A.DIVISION_ID
                     , A.SCM_SITE_ID
                     , A.MEASURE
                     , CASE
                            WHEN SUMMARY_BUCKET_VALUE = TO_CHAR(TRUNC(SYSDATE, 'MM'), 'YYYYMMDD') THEN TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (- 7 * 1), 'YYYYMMDD')
                            ELSE SUMMARY_BUCKET_VALUE
                        END AS START_DAY
                     , TO_CHAR(ADD_MONTHS(TO_DATE(SUMMARY_BUCKET_VALUE, 'YYYYMMDD'), 1) - 1, 'YYYYMMDD') END_DAY
                  FROM DM_MST_CUSTOMER_FCST A
                INNER JOIN (SELECT DISTINCT DIVISION_ID
                                 , SCM_SITE_ID
                                 , MEASURE_GROUP
                              FROM GT_DPCF_T3_DM_PLN_CUSTOMER_PSI
                           ) RSLT
                  ON (A.DIVISION_ID = RSLT.DIVISION_ID AND A.SCM_SITE_ID = RSLT.SCM_SITE_ID AND A.MEASURE_GROUP = RSLT.MEASURE_GROUP)
                 WHERE 1 = 1
                   AND VALID_YN = 'Y'
                   AND A.PLAN_WEEK = (SELECT MAX(PLAN_WEEK)
                                        FROM DM_MST_CUSTOMER_FCST X
                                       WHERE X.DIVISION_ID = A.DIVISION_ID
                                         AND X.SCM_SITE_ID = A.SCM_SITE_ID
                                         AND X.MEASURE_GROUP = A.MEASURE_GROUP
                                     )
                   AND A.SUMMARY_BUCKET_VALUE >= TO_CHAR(TRUNC(SYSDATE, 'MM'), 'YYYYMMDD')
                   AND SUMMARY_BUCKET_TYPE IN ('MONTHLY');

            /* select 'GT_DPCF_T3_DM_PLN_CUSTOMER_PSI ' */
            /* select * from GT_DPCF_T3_DM_PLN_CUSTOMER_PSI */
            /* select 'GT_DPCF_TMP_SITE_CUSTOMER_MAP_2' */
            /* select * from GT_DPCF_TMP_SITE_CUSTOMER_MAP_2 */

            /* -INSERT INTO 할 실제 데이터의 시작과 끝 구간 산출 ----------------------------------------------- (end) 20180409 */

            /* (88) 데이터의 시작~끝 날짜 구하기 ---------------------------------------------- (start) */

            BEGIN
                IF N_UPLOAD_BUCKET_TYPE = 'DAILY' THEN
                    SELECT BASIS_YYYYMMDD
                      INTO N_MAX_YYYYMMDD
                      FROM SCM_SYS_CALENDAR_M T
                     WHERE T.BASIS_YYYYMMDD = TO_CHAR(TO_DATE(N_MAX_YYYYMMDD, 'YYYYMMDD') + 0, 'YYYYMMDD'); /* MAX_YYYYMMDD 셋팅 */
                ELSIF N_UPLOAD_BUCKET_TYPE = 'WEEKLY' THEN
                    N_MIN_YYYYMMDD := TO_CHAR(FN_NEXT_DAY(TO_DATE(N_MIN_YYYYMMDD, 'YYYYMMDD'), 'MON') + (-7), 'YYYYMMDD'); /* MIN_YYYYMMDD 셋팅 */
                    SELECT BASIS_YYYYMMDD
                      INTO N_MAX_YYYYMMDD
                      FROM SCM_SYS_CALENDAR_M T
                     WHERE T.BASIS_YYYYMMDD = TO_CHAR(TO_DATE(N_MAX_YYYYMMDD, 'YYYYMMDD') + 6, 'YYYYMMDD'); /* MAX_YYYYMMDD 셋팅 */
                ELSIF N_UPLOAD_BUCKET_TYPE = 'MONTHLY' THEN
                    SELECT BASIS_YYYYMMDD
                      INTO N_MAX_YYYYMMDD
                      FROM SCM_SYS_CALENDAR_M T
                     WHERE T.BASIS_YYYYMMDD = TO_CHAR(ADD_MONTHS(TO_DATE(N_MAX_YYYYMMDD, 'YYYYMMDD'), 1) - 1, 'YYYYMMDD'); /* MAX_YYYYMMDD 셋팅 */
                END IF;
            END;

            /* (88) 데이터의 시작~끝 날짜 구하기 ---------------------------------------------- (end) */

            /* DM_PLN_CUSTOMER_PSI 최종 데이터 INSERT --------------------------------------------------------------------------------------- */

            /* 2024.05.02    kcw3408       고객수요 N:N Mapping  */
            /* 매핑테이블 데이블  INSERT */
            BEGIN
                PR_DM_CUST_ITEM_MAPPING('RPA');
            END;

            /* 대상 추출 */
            BEGIN

                INSERT
                INTO GT_DPCF_DM_CUST_ITEM_MAPPING_DTL_N
                    SELECT B.DIVISION_ID
                         , B.DATA_TYPE_CODE
                         , B.END_CUSTOMER
                         , B.SCM_SITE_ID
                         , B.PROJECT_CODE
                         , B.FCST_TYPE
                         , B.INCOTERMS
                         , B.DOM_EXP
                         , B.ITEM_ID
                         , B.UNLOADING_POINT
                         , B.CUSTOMER_PLANT
                         , B.CUSTOMER_ITEM_ID
                         , B.VALID_START_DATE
                         , B.VALID_END_DATE
                         , B.MAPPING_ITEM_ID
                      FROM DM_CUST_ITEM_MAPPING_M A
                    JOIN DM_CUST_ITEM_MAPPING_DTL_N B
                      ON A.DIVISION_ID = B.DIVISION_ID
                       AND A.DATA_TYPE_CODE = B.DATA_TYPE_CODE
                       AND A.END_CUSTOMER = B.END_CUSTOMER
                       AND A.SCM_SITE_ID = B.SCM_SITE_ID
                       AND A.PROJECT_CODE = B.PROJECT_CODE
                       AND A.FCST_TYPE = B.FCST_TYPE
                       AND A.INCOTERMS = B.INCOTERMS
                       AND A.DOM_EXP = B.DOM_EXP
                       AND A.ITEM_ID = B.ITEM_ID
                       AND A.UNLOADING_POINT = B.UNLOADING_POINT
                       AND RTRIM(LTRIM(A.CUSTOMER_PLANT)) = RTRIM(LTRIM(B.CUSTOMER_PLANT))
                       AND RTRIM(LTRIM(A.CUSTOMER_ITEM_ID)) = RTRIM(LTRIM(B.CUSTOMER_ITEM_ID))
                     WHERE A.ACTIVE_YN = 'Y'
                       AND A.DATA_TYPE_CODE IN ('RPA', 'EXCEL');
            END;

            /* DM_PLN_CUSTOMER_PSI 최종 데이터 INSERT INTO 전 임시테이블에 모두 저장 */
            BEGIN
                /*
                    -- INSERT --NO_PARALLEL INTO GT_DPCF_T2_DM_PLN_CUSTOMER_PSI
                -- SELECT DISTINCT
                   --   A.DIVISION_ID,A.CUSTOMER_PROJECT_CODE,A.CUSTOMER_MODEL,A.SCM_SITE_ID,A.DOM_EXP,A.FCST_TYPE,A.MEASURE_GROUP
                --     ,v_MEASURE    -- 20180227변경사항 measure를 기존값으로 그대로 사용함
                --  ,A.LAST_UPDATED_BY,A.LAST_UPDATE_DATE,A.BATCH_RESULT,A.MST_UPLOAD_UOM,A.MST_UPLOAD_BUCKET_TYPE,A.MST_SUMMARY_BUCKET_TYPE
                --  ,A.MST_CONVERT_QTY,A.PLAN_WEEK,SPLIT_RESULT,A.ATTRIBUTE1,A.ATTRIBUTE2,A.ATTRIBUTE3,A.ATTRIBUTE4,A.ATTRIBUTE5,A.ATTRIBUTE6
                --  ,A.ATTRIBUTE7,A.ATTRIBUTE8,A.ATTRIBUTE9,A.ATTRIBUTE10
                --  2024.05.02    kcw3408       고객수요 N:N Mapping
                --  전체 대생 추출후 N:N Model Mapping 작업
                --  .집계 시점에 Cust Item/Unloading Point/Plant 반영
                --  .Valid Range 1~5에 포함되지 않는 구간은 Calloff 데이터를 집계하지 않음
                --  ON A.DIVISION_ID = B.DIVISION_ID
                -- AND A.SCM_SITE_ID = B.SCM_SITE_ID
                -- AND A.PROJECT_CODE = B.PROJECT_CODE
                -- AND A.FCST_TYPE = B.FCST_TYPE
                -- AND A.INCOTERMS = B.INCOTERMS
                -- AND A.DOM_EXP = B.DOM_EXP
                -- AND A.ITEM_ID = B.ITEM_ID
                -- AND A.YYYYMMDD >= B.VALID_START_DATE
                -- AND A.YYYYMMDD <= B.VALID_END_DATE
                -- AND B.MAPPING_ITEM_ID IS NOT NULL
                -- AND CASE WHEN A.CREATED_BY LIKE '%robot'
                --  where n_MIN_YYYYMMDD <= YYYYMMDD
                --  AND n_MAX_YYYYMMDD >= YYYYMMDD;

                  --select 'GT_DPCF_TMP_SITE_CUSTOMER_MAP_2'
                  --select * from GT_DPCF_TMP_SITE_CUSTOMER_MAP_2
                  --select 'GT_DPCF_T3_DM_PLN_CUSTOMER_PSI'
                  --select * from GT_DPCF_T3_DM_PLN_CUSTOMER_PSI
                  --select 'GT_DPCF_T2_DM_PLN_CUSTOMER_PSI'
                  --select * from GT_DPCF_T2_DM_PLN_CUSTOMER_PSI
                */
                /* [PJ2024-50647] RPA, EXCEL의 경우 N:N 매핑없이 처리함. START */
                INSERT
                INTO GT_DPCF_T2_DM_PLN_CUSTOMER_PSI
                    SELECT DISTINCT A.DIVISION_ID
                         , A.CUSTOMER_PROJECT_CODE
                         , A.CUSTOMER_MODEL
                         , A.SCM_SITE_ID
                         , A.DOM_EXP
                         , A.FCST_TYPE
                         , A.MEASURE_GROUP
                         , V_MEASURE /* 20180227변경사항 measure를 기존값으로 그대로 사용함 */
                         , A.YYYYMMDD
                         , A.INCOTERMS
                         , A.PLANT_SITE_ID
                         , A.PROJECT_CODE
                         , A.ITEM_ID
                         , QTY
                         , A.UPLOAD_UOM
                         , A.CREATED_BY
                         , A.CREATION_DATE
                         , A.LAST_UPDATED_BY
                         , A.LAST_UPDATE_DATE
                         , A.BATCH_RESULT
                         , A.MST_UPLOAD_UOM
                         , A.MST_UPLOAD_BUCKET_TYPE
                         , A.MST_SUMMARY_BUCKET_TYPE
                         , A.MST_CONVERT_QTY
                         , A.PLAN_WEEK
                         , SPLIT_RESULT
                         , A.ATTRIBUTE1
                         , A.ATTRIBUTE2
                         , A.ATTRIBUTE3
                         , A.ATTRIBUTE4
                         , A.ATTRIBUTE5
                         , A.ATTRIBUTE6
                         , A.ATTRIBUTE7
                         , A.ATTRIBUTE8
                         , A.ATTRIBUTE9
                         , A.ATTRIBUTE10
                      FROM GT_DPCF_T3_DM_PLN_CUSTOMER_PSI A
                     WHERE N_MIN_YYYYMMDD <= YYYYMMDD
                       AND N_MAX_YYYYMMDD >= YYYYMMDD;

                /* [PJ2024-50647] RPA, EXCEL의 경우 N:N 매핑없이 처리함. END */
            END;

            /* DM_PLN_CUSTOMER_PSI DELETE FROM count 확인 ------------------------------------------------------------------------------------ */

            /* DM_PLN_CUSTOMER_PSI INSERT INTO count 확인 ---------------------------------------------------------------------------------------- */
            BEGIN
                SELECT N_PSI_INSERT_COUNT + COUNT(*)
                  INTO N_PSI_INSERT_COUNT
                  FROM GT_DPCF_T2_DM_PLN_CUSTOMER_PSI;
            END;

            /* DM_PLN_CUSTOMER_PSI test222222 ---------------------------------------------------------------------------------------- */
            BEGIN
                SELECT COUNT(*) /* n_psi_insert_count + */
                  INTO N_TEST_VAL
                  FROM (SELECT DIVISION_ID
                             , SCM_SITE_ID
                             , PROJECT_CODE
                             , ITEM_ID
                             , DOM_EXP
                             , FCST_TYPE
                             , INCOTERMS
                             , PLANT_SITE_ID
                             , MEASURE
                             , YYYYMMDD
                          FROM GT_DPCF_T2_DM_PLN_CUSTOMER_PSI
                         WHERE 1 = 1 /* AND YYYYMMDD = '20240205' */
                          GROUP BY DIVISION_ID
                                 , SCM_SITE_ID
                                 , PROJECT_CODE
                                 , ITEM_ID
                                 , DOM_EXP
                                 , FCST_TYPE
                                 , INCOTERMS
                                 , PLANT_SITE_ID
                                 , MEASURE
                                 , YYYYMMDD
                       ) MM;
            END;

            /* (11) */
            /*-------------------- DM_PLN_MKT_FCST 테이블 DELETE FROM count 확인 --------------------*/
            BEGIN
                SELECT COUNT(*)
                  INTO N_FCST_DELETE_COUNT
                  FROM DM_PLN_MKT_FCST A
                 WHERE 1 = 1
                   AND EXISTS (SELECT 1
                                 FROM GT_DPCF_T2_DM_PLN_CUSTOMER_PSI B
                                WHERE A.DIVISION_ID = B.DIVISION_ID
                                  AND A.SCM_SITE_ID = B.SCM_SITE_ID
                                  AND A.PROJECT_CODE = B.PROJECT_CODE
                                  AND A.ITEM_ID = B.ITEM_ID
                                  AND A.DOM_EXP = B.DOM_EXP
                                  AND A.FCST_TYPE = B.FCST_TYPE
                                  AND A.INCOTERMS = B.INCOTERMS
                                  AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
                                  AND A.MEASURE = B.MEASURE /* AND  B.BATCH_RESULT = 'UPLOAD_COMPLETED' */
                                  AND A.YYYYMMDD >= N_MIN_YYYYMMDD /* 추출된 데이터의 MIN ~ MAX의 구간  --20180409 modify */
                                  AND A.YYYYMMDD <= N_MAX_YYYYMMDD /* 추출된 데이터의 MIN ~ MAX의 구간  --20180409 modify */
                              );

            END;

            /*-------------------- DM_PLN_MKT_FCST 테이블 insert전 데이터 중복제거 --------------------*/
            BEGIN

                DELETE FROM DM_PLN_MKT_FCST
                WHERE  EXISTS (SELECT 1
                        FROM   GT_DPCF_T2_DM_PLN_CUSTOMER_PSI B
                        WHERE  1 = 1
                        AND    DM_PLN_MKT_FCST.DIVISION_ID = B.DIVISION_ID
                        AND    DM_PLN_MKT_FCST.SCM_SITE_ID = B.SCM_SITE_ID
                        AND    DM_PLN_MKT_FCST.PROJECT_CODE = B.PROJECT_CODE
                        AND    DM_PLN_MKT_FCST.ITEM_ID = B.ITEM_ID
                        AND    DM_PLN_MKT_FCST.DOM_EXP = B.DOM_EXP
                        AND    DM_PLN_MKT_FCST.FCST_TYPE = B.FCST_TYPE
                        AND    DM_PLN_MKT_FCST.INCOTERMS = B.INCOTERMS
                        AND    DM_PLN_MKT_FCST.PLANT_SITE_ID = B.PLANT_SITE_ID
                        AND    DM_PLN_MKT_FCST.MEASURE = B.MEASURE
                        AND    DM_PLN_MKT_FCST.YYYYMMDD >= N_MIN_YYYYMMDD /* 추출된 데이터의 MIN ~ MAX의 구간 */
                        AND    DM_PLN_MKT_FCST.YYYYMMDD <= N_MAX_YYYYMMDD /* 추출된 데이터의 MIN ~ MAX의 구간 */
                        );
            END;

            /* select * from GT_DPCF_T3_DM_PLN_CUSTOMER_PSI; */

            DBMS_OUTPUT.PUT_LINE('Test99 cnt: ');
            DBMS_OUTPUT.PUT_LINE(0);
            DBMS_OUTPUT.PUT_LINE(N_TEST_VAL);
            DBMS_OUTPUT.PUT_LINE(N_FCST_DELETE_COUNT);
            DBMS_OUTPUT.PUT_LINE('Test99 ' ||N_MAX_YYYYMMDD);

            /*-------------------------------------------------------------------------------------*/
            /* [E20260818-MKTDEL] ⭐ 삭제 범위 = 삽입 범위 (PK 충돌 근본 제거)
               위 선삭제는 YYYYMMDD 를 N_MIN~N_MAX 구간으로만 지운다. 그런데 아래 INSERT 대상은
               `MAP.START_DAY~END_DAY` ∩ `>= 이번주 월요일` 이라 **범위가 다르다** —
               삭제되지 않은 기존 행과 새 행이 PK(10키)에서 충돌해 ORA-00001 이 났다
               (2026-08-18 실사고: DMF0014 업로드가 '저장 완료'인데 원장 0건).
               ⇒ INSERT 가 적재할 키 집합 그대로 한 번 더 정밀 삭제한다. */
            BEGIN
                DELETE FROM DM_PLN_MKT_FCST T
                WHERE  EXISTS (SELECT 1
                        FROM   GT_DPCF_T2_DM_PLN_CUSTOMER_PSI A
                        INNER JOIN (SELECT DIVISION_ID, SCM_SITE_ID, MEASURE, START_DAY, END_DAY
                                      FROM GT_DPCF_TMP_SITE_CUSTOMER_MAP_2
                                     GROUP BY DIVISION_ID, SCM_SITE_ID, MEASURE, START_DAY, END_DAY) MAP
                          ON (A.DIVISION_ID = MAP.DIVISION_ID AND A.SCM_SITE_ID = MAP.SCM_SITE_ID
                              AND A.MEASURE = MAP.MEASURE)
                        WHERE  A.YYYYMMDD BETWEEN MAP.START_DAY AND MAP.END_DAY
                        AND    A.YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (- 7), 'YYYYMMDD')
                        AND    T.DIVISION_ID   = A.DIVISION_ID
                        AND    T.PROJECT_CODE  = A.PROJECT_CODE
                        AND    T.SCM_SITE_ID   = A.SCM_SITE_ID
                        AND    T.ITEM_ID       = A.ITEM_ID
                        AND    T.DOM_EXP       = A.DOM_EXP
                        AND    T.FCST_TYPE     = A.FCST_TYPE
                        AND    T.INCOTERMS     = A.INCOTERMS
                        AND    T.MEASURE       = A.MEASURE
                        AND    T.YYYYMMDD      = A.YYYYMMDD
                        AND    T.PLANT_SITE_ID = A.PLANT_SITE_ID);
            END;

            BEGIN
/* [E20260818-MKTMERGE] ⭐ INSERT → MERGE 전환 (사용자 승인 2026-08-18)
                   동일 파일 2회차 저장이 1회차 적재분과 PK(10키) 충돌해 ORA-00001 로 실패했다.
                   선삭제만으로는 완전히 막히지 않아(재현 확보), 적재 자체를 MERGE 로 바꿔
                   **있으면 UPDATE / 없으면 INSERT** 로 만든다 = 재업로드가 덮어쓰기가 되어 멱등해진다.
                   ⚠ 소스에 PK 중복이 생기면 ORA-30926 으로 드러난다(현 실측 중복 0건). */
                MERGE INTO DM_PLN_MKT_FCST T
                /* [E20260818-MKTDISTINCT] ⭐ DISTINCT 무력화 정정 — 팬아웃 복제 제거
                   MAP 조인이 같은 행을 2건으로 부풀리는데, 종전에는 선택목록의 SYSTIMESTAMP 때문에
                   DISTINCT 가 접지 못해 동일 PK 2건이 INSERT 되어 ORA-00001 이 났다(실측 확인).
                   ⇒ DISTINCT 는 **결정적 컬럼에만** 적용하고 SYSTIMESTAMP·상수는 바깥에서 부여한다. */
                USING (SELECT X.DIVISION_ID, X.PROJECT_CODE, X.SCM_SITE_ID, X.ITEM_ID, X.DOM_EXP
                            , X.FCST_TYPE, X.INCOTERMS, X.MEASURE, X.PLANT_SITE_ID, X.YYYYMMDD
                            , X.QTY, X.CREATED_BY, X.CREATION_DATE, X.LAST_UPDATED_BY
                            , SYSTIMESTAMP              AS LAST_UPDATE_DATE
                            , 'UPLOAD_COMPLETED'        AS ATTRIBUTE1
                            , X.MST_UPLOAD_UOM          AS ATTRIBUTE2
                            , X.MST_UPLOAD_BUCKET_TYPE  AS ATTRIBUTE3
                            , X.MST_SUMMARY_BUCKET_TYPE AS ATTRIBUTE4
                            , X.MST_CONVERT_QTY         AS ATTRIBUTE5
                            , X.PLAN_WEEK               AS ATTRIBUTE6
                            , X.SPLIT_RESULT            AS ATTRIBUTE7
                            , X.ATTRIBUTE8, X.ATTRIBUTE9, X.ATTRIBUTE10
                          FROM (SELECT * FROM (
                                   /* [E20260818-MKTPKGUARD] ⭐ PK 1행 확정
                                      계측 실측: 중복 행이 갈라지는 컬럼은 CREATION_DATE 하나뿐(나머지 전부 동일).
                                      이전 업로드분 PSI 행과 이번 분이 같은 MKT 10키로 겹치는데 DISTINCT 가
                                      CREATION_DATE 차이 때문에 못 접어 ORA-00001 이 났다.
                                      ⇒ 최신(CREATION_DATE DESC) 1건만 채택한다. */
                                   SELECT A.DIVISION_ID
                                     , A.PROJECT_CODE
                                     , A.SCM_SITE_ID
                                     , A.ITEM_ID
                                     , A.DOM_EXP
                                     , A.FCST_TYPE
                                     , A.INCOTERMS
                                     , A.MEASURE
                                     , A.PLANT_SITE_ID
                                     , A.YYYYMMDD
                                     , A.QTY
                                     , A.CREATED_BY
                                     , A.CREATION_DATE
                                     , A.LAST_UPDATED_BY
                                     , A.MST_UPLOAD_UOM
                                     , A.MST_UPLOAD_BUCKET_TYPE
                                     , A.MST_SUMMARY_BUCKET_TYPE
                                     , A.MST_CONVERT_QTY
                                     , A.PLAN_WEEK
                                     , A.SPLIT_RESULT
                                     , A.ATTRIBUTE8
                                     , A.ATTRIBUTE9
                                     , A.ATTRIBUTE10
                                        , ROW_NUMBER() OVER (PARTITION BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.YYYYMMDD, A.PLANT_SITE_ID
                                              ORDER BY A.CREATION_DATE DESC NULLS LAST
                                                     , A.QTY DESC NULLS LAST) AS RN_PKG
                                     FROM GT_DPCF_T2_DM_PLN_CUSTOMER_PSI A
                    INNER JOIN (SELECT DIVISION_ID
                                     , SCM_SITE_ID
                                     , MEASURE
                                     , START_DAY
                                     , END_DAY
                                  FROM GT_DPCF_TMP_SITE_CUSTOMER_MAP_2
                                  GROUP BY DIVISION_ID
                                         , SCM_SITE_ID
                                         , MEASURE
                                         , START_DAY
                                         , END_DAY
                               ) MAP
                      ON (A.DIVISION_ID = MAP.DIVISION_ID AND A.SCM_SITE_ID = MAP.SCM_SITE_ID AND A.MEASURE = MAP.MEASURE)
                     WHERE 1 = 1
                       AND A.YYYYMMDD BETWEEN MAP.START_DAY
                       AND MAP.END_DAY
                       AND A.YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (- 7), 'YYYYMMDD')
                                 ) Y
                                WHERE Y.RN_PKG = 1) X
                      ) S
                ON (    T.DIVISION_ID    = S.DIVISION_ID
                    AND T.PROJECT_CODE   = S.PROJECT_CODE
                    AND T.SCM_SITE_ID    = S.SCM_SITE_ID
                    AND T.ITEM_ID        = S.ITEM_ID
                    AND T.DOM_EXP        = S.DOM_EXP
                    AND T.FCST_TYPE      = S.FCST_TYPE
                    AND T.INCOTERMS      = S.INCOTERMS
                    AND T.MEASURE        = S.MEASURE
                    AND T.YYYYMMDD       = S.YYYYMMDD
                    AND T.PLANT_SITE_ID  = S.PLANT_SITE_ID)
                WHEN MATCHED THEN
                    UPDATE SET T.QTY              = S.QTY
                     , T.CREATED_BY       = S.CREATED_BY
                     , T.CREATION_DATE    = S.CREATION_DATE
                     , T.LAST_UPDATED_BY  = S.LAST_UPDATED_BY
                     , T.LAST_UPDATE_DATE = S.LAST_UPDATE_DATE
                     , T.ATTRIBUTE1       = S.ATTRIBUTE1
                     , T.ATTRIBUTE2       = S.ATTRIBUTE2
                     , T.ATTRIBUTE3       = S.ATTRIBUTE3
                     , T.ATTRIBUTE4       = S.ATTRIBUTE4
                     , T.ATTRIBUTE5       = S.ATTRIBUTE5
                     , T.ATTRIBUTE6       = S.ATTRIBUTE6
                     , T.ATTRIBUTE7       = S.ATTRIBUTE7
                     , T.ATTRIBUTE8       = S.ATTRIBUTE8
                     , T.ATTRIBUTE9       = S.ATTRIBUTE9
                     , T.ATTRIBUTE10      = S.ATTRIBUTE10
                WHEN NOT MATCHED THEN
                    INSERT (DIVISION_ID
                     , PROJECT_CODE
                     , SCM_SITE_ID
                     , ITEM_ID
                     , DOM_EXP
                     , FCST_TYPE
                     , INCOTERMS
                     , MEASURE
                     , PLANT_SITE_ID
                     , YYYYMMDD
                     , QTY
                     , CREATED_BY
                     , CREATION_DATE
                     , LAST_UPDATED_BY
                     , LAST_UPDATE_DATE
                     , ATTRIBUTE1
                     , ATTRIBUTE2
                     , ATTRIBUTE3
                     , ATTRIBUTE4
                     , ATTRIBUTE5
                     , ATTRIBUTE6
                     , ATTRIBUTE7
                     , ATTRIBUTE8
                     , ATTRIBUTE9
                     , ATTRIBUTE10)
                    VALUES (S.DIVISION_ID
                     , S.PROJECT_CODE
                     , S.SCM_SITE_ID
                     , S.ITEM_ID
                     , S.DOM_EXP
                     , S.FCST_TYPE
                     , S.INCOTERMS
                     , S.MEASURE
                     , S.PLANT_SITE_ID
                     , S.YYYYMMDD
                     , S.QTY
                     , S.CREATED_BY
                     , S.CREATION_DATE
                     , S.LAST_UPDATED_BY
                     , S.LAST_UPDATE_DATE
                     , S.ATTRIBUTE1
                     , S.ATTRIBUTE2
                     , S.ATTRIBUTE3
                     , S.ATTRIBUTE4
                     , S.ATTRIBUTE5
                     , S.ATTRIBUTE6
                     , S.ATTRIBUTE7
                     , S.ATTRIBUTE8
                     , S.ATTRIBUTE9
                     , S.ATTRIBUTE10);
                /* [E20241126-000426]_원소스 주석처리 END */
            END;

            DBMS_OUTPUT.PUT_LINE('Test100 ');
            /*-------------------- DM_PLN_MKT_FCST 테이블 MERGE  --------------------*/
            /* [E20241126-000426]_해당 작업을 하는 프로시져를 신규 생성하여, 해당 작업은 주석처리한다. START */
            /*
             delete from DM_PLN_MKT_FCST
             where (
                        select count(1)
                                 where  DM_PLN_MKT_FCST.DIVISION_ID        =  B.DIVISION_ID
               and  DM_PLN_MKT_FCST.SCM_SITE_ID        =  B.SCM_SITE_ID
               and  DM_PLN_MKT_FCST.PROJECT_CODE       =  B.PROJECT_CODE
               and  DM_PLN_MKT_FCST.ITEM_ID            =  B.ITEM_ID
               and  DM_PLN_MKT_FCST.DOM_EXP            =  B.DOM_EXP
               and  DM_PLN_MKT_FCST.FCST_TYPE          =  B.FCST_TYPE
               and  DM_PLN_MKT_FCST.INCOTERMS          =  B.INCOTERMS
               and  DM_PLN_MKT_FCST.PLANT_SITE_ID      =  B.PLANT_SITE_ID
              -- AND B.BATCH_RESULT = 'SPLIT_COMPLETED' -- modified by ytchoi 180305
            AND DM_PLN_MKT_FCST.MEASURE = 'CUST_FCST'
            -- (20230912 : CUST_FCST MEASURE 삭제시 당주(월) 이전 데이터는 삭제 안되도록 수정)
               AND DM_PLN_MKT_FCST.YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7), 'YYYYMMDD')
                   ) > 0

               insert into DM_PLN_MKT_FCST
            select   a.DIVISION_ID
             ,a.PROJECT_CODE
             ,a.SCM_SITE_ID
             ,a.ITEM_ID
             ,a.DOM_EXP
             ,a.FCST_TYPE
             ,a.INCOTERMS
             ,'CUST_FCST'
             ,a.PLANT_SITE_ID
             ,a.YYYYMMDD
             ,a.QTY
             ,a.CREATED_BY
             ,a.CREATION_DATE
             ,a.LAST_UPDATED_BY
             ,a.LAST_UPDATE_DATE
             ,a.ATTRIBUTE1
             ,a.ATTRIBUTE2
             ,a.ATTRIBUTE3
             ,a.ATTRIBUTE4
             ,a.ATTRIBUTE5
             ,a.ATTRIBUTE6
             ,a.ATTRIBUTE7
             ,a.ATTRIBUTE8
             ,a.ATTRIBUTE9
             ,a.ATTRIBUTE10
              from DM_PLN_MKT_FCST a
              inner join
              (select distinct DIVISION_ID,SCM_SITE_ID,ITEM_ID,incoterms, PLANT_SITE_ID, PROJECT_CODE,DOM_EXP,FCST_TYPE
              on(
            a.DIVISION_ID   = rslt.DIVISION_ID
            and a.SCM_SITE_ID   = rslt.SCM_SITE_ID
            -- and a.MEASURE       = rslt.MEASURE
            and a.ITEM_ID       = rslt.ITEM_ID
            and a.incoterms     = rslt.incoterms
            and a.PLANT_SITE_ID  = rslt.PLANT_SITE_ID
            and a.PROJECT_CODE   = rslt.PROJECT_CODE
            and a.DOM_EXP        = rslt.DOM_EXP
            and a.FCST_TYPE      = rslt.FCST_TYPE
            -- and a.yyyymmdd      = rslt.v_yyyymmdd
               )
              inner join
              (select DIVISION_ID,SCM_SITE_ID,MEASURE,start_day,end_day
              from GT_DPCF_TMP_SITE_CUSTOMER_MAP_2 group by DIVISION_ID,SCM_SITE_ID,MEASURE,start_day,end_day) map

              on(
            a.DIVISION_ID   = map.DIVISION_ID
            and a.SCM_SITE_ID   = map.SCM_SITE_ID
            and a.MEASURE       = map.MEASURE
               )
            where 1=1
            and a.YYYYMMDD between map.start_day and map.end_day
            and a.YYYYMMDD >=  TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7), 'YYYYMMDD');
             */
            /* [E20241126-000426]_해당 작업을 하는 프로시져를 신규 생성하여, 해당 작업은 주석처리한다. END */
            /*
                       -- BEGIN

               -- DELETE
                       -- FROM DM_PLN_MKT_FCST
                       -- WHERE (
                                -- SELECT count(1)
                   -- added by ytchoi 180305 measure 별 start와 end 일자 구하기
                  -- ,(
            -- select a.scm_site_id, a.measure,    min(summary_bucket_value)  MIN_DATE
             -- , CASE WHEN SUMMARY_BUCKET_TYPE = 'WEEKLY' THEN   TO_CHAR(cast( max(summary_bucket_value) as DATE ) + (6), 'YYYYMMDD')
                      -- WHEN SUMMARY_BUCKET_TYPE = 'MONTHLY' THEN TO_CHAR(ADD_MONTHS(TO_DATE(SUBSTR(TO_CHAR(MAX(SUMMARY_BUCKET_VALUE)),1,6)||'01','YYYYMMDD'), 1) - 1, 'YYYYMMDD')
                        -- ELSE max(summary_bucket_value) END MAX_DATE
                       -- from DM_MST_CUSTOMER_FCST a
                        -- ,(
                         -- select max(plan_week) pw
                        -- from DM_MST_CUSTOMER_FCST
                         -- ) b
                      -- where a.plan_week = b.pw
                        -- and a.measure_group = 'CUST_FCST'
                     -- group by a.scm_site_id, a.measure, SUMMARY_BUCKET_TYPE
                       -- ) PERIOD
                              -- --------------------------------------------------------------------- 20180409 add
                   -- inner join
                   -- (select DIVISION_ID,SCM_SITE_ID,MEASURE,start_day,end_day
                   -- from GT_DPCF_TMP_SITE_CUSTOMER_MAP_2 group by DIVISION_ID,SCM_SITE_ID,MEASURE,start_day,end_day) map

                  -- on(
                   -- b.DIVISION_ID   = map.DIVISION_ID
                  -- and b.SCM_SITE_ID   = map.SCM_SITE_ID
                  -- and b.MEASURE       = map.MEASURE
                  -- )
                  -- where 1=1
                  -- and b.YYYYMMDD between map.start_day and map.end_day
                  -- and b.YYYYMMDD >=  TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (0), 'YYYYMMDD')
                              -- --------------------------------------------------------------------- 20180409 add
                      -- and  DM_PLN_MKT_FCST.DIVISION_ID        =  B.DIVISION_ID
                      -- and  DM_PLN_MKT_FCST.SCM_SITE_ID        =  B.SCM_SITE_ID
                      -- and  DM_PLN_MKT_FCST.PROJECT_CODE       =  B.PROJECT_CODE
                      -- and  DM_PLN_MKT_FCST.ITEM_ID            =  B.ITEM_ID
                      -- and  DM_PLN_MKT_FCST.DOM_EXP            =  B.DOM_EXP
                      -- and  DM_PLN_MKT_FCST.FCST_TYPE          =  B.FCST_TYPE
                      -- and  DM_PLN_MKT_FCST.INCOTERMS          =  B.INCOTERMS
                      -- and  DM_PLN_MKT_FCST.PLANT_SITE_ID      =  B.PLANT_SITE_ID
                    -- AND B.BATCH_RESULT = 'SPLIT_COMPLETED' -- modified by ytchoi 180305
                    -- AND DM_PLN_MKT_FCST.MEASURE = 'CUST_FCST'
                    -- --AND DM_PLN_MKT_FCST.YYYYMMDD >= n_MIN_YYYYMMDD  -- 추출된 데이터의 MIN ~ MAX의 구간
                    -- --AND DM_PLN_MKT_FCST.YYYYMMDD <= n_MAX_YYYYMMDD  -- 추출된 데이터의 MIN ~ MAX의 구간

                    -- -- added by ytchoi 180305 upload 한 기간에도 속하고
                    -- AND B.SCM_SITE_ID             = PERIOD.SCM_SITE_ID
                    -- AND B.measure                 = PERIOD.MEASURE
                    -- and DM_PLN_MKT_FCST.YYYYMMDD between PERIOD.MIN_DATE and PERIOD.MAX_DATE
                    -- ) > 0
                         -- END

                    -- BEGIN
                  -- INSERT  INTO  DM_PLN_MKT_FCST
                  -- SELECT distinct
                          -- DIVISION_ID
                    -- ,PROJECT_CODE
                    -- ,a.SCM_SITE_ID
                    -- ,ITEM_ID
                    -- ,DOM_EXP
                    -- ,FCST_TYPE
                    -- ,INCOTERMS
                    -- ,'CUST_FCST' AS MEASURE
                    -- ,PLANT_SITE_ID
                    -- ,YYYYMMDD
                    -- ,QTY
                    -- ,CREATED_BY
                    -- ,CREATION_DATE
                    -- ,LAST_UPDATED_BY
                    -- ,'MERGE_COMPLETED',MST_UPLOAD_UOM,MST_UPLOAD_BUCKET_TYPE,MST_SUMMARY_BUCKET_TYPE
                       -- ,MST_CONVERT_QTY,PLAN_WEEK,SPLIT_RESULT,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
                       -- added by ytchoi 180305 measure 별 start와 end 일자 구하기
                      -- ,(
                     -- select a.scm_site_id, a.measure,    min(summary_bucket_value)  MIN_DATE
                       -- , CASE WHEN SUMMARY_BUCKET_TYPE = 'WEEKLY' THEN   TO_CHAR(cast( max(summary_bucket_value) as DATE ) + (6), 'YYYYMMDD')
                        -- WHEN SUMMARY_BUCKET_TYPE = 'MONTHLY' THEN TO_CHAR(ADD_MONTHS(TO_DATE(SUBSTR(TO_CHAR(MAX(SUMMARY_BUCKET_VALUE)),1,6)||'01','YYYYMMDD'), 1) - 1, 'YYYYMMDD')
                        -- ELSE max(summary_bucket_value) END MAX_DATE
              -- from DM_MST_CUSTOMER_FCST a
              -- ,(
               -- select max(plan_week) pw
             -- from DM_MST_CUSTOMER_FCST
               -- ) b
             -- where a.plan_week = b.pw
               -- and a.measure_group = 'CUST_FCST'
            -- group by a.scm_site_id, a.measure, SUMMARY_BUCKET_TYPE
               -- ) PERIOD
                            -- --------------------------------------------------------------------- 20180409 add
            -- inner join
            -- (select DIVISION_ID,SCM_SITE_ID,MEASURE,start_day,end_day
            -- from GT_DPCF_TMP_SITE_CUSTOMER_MAP_2 group by DIVISION_ID,SCM_SITE_ID,MEASURE,start_day,end_day) map

            -- on(
            -- a.DIVISION_ID   = map.DIVISION_ID
            -- and a.SCM_SITE_ID   = map.SCM_SITE_ID
            -- and a.MEASURE       = map.MEASURE
            -- )
            -- where 1=1
            -- and a.YYYYMMDD between map.start_day and map.end_day
            -- and a.YYYYMMDD >=  TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (0), 'YYYYMMDD')
                            -- --------------------------------------------------------------------- 20180409 add
               -- AND BATCH_RESULT = 'SPLIT_COMPLETED'
            -- -- added by ytchoi 180305 upload 한 기간에도 속하고
            -- AND A.SCM_SITE_ID             = PERIOD.SCM_SITE_ID
            -- AND A.measure                 = PERIOD.MEASURE
            -- --and a.YYYYMMDD between PERIOD.MIN_DATE and PERIOD.MAX_DATE

            */
            BEGIN
                SELECT N_FCST_INSERT_COUNT + COUNT(*)
                  INTO N_FCST_INSERT_COUNT
                  FROM GT_DPCF_T2_DM_PLN_CUSTOMER_PSI
                 WHERE 1 = 1
                   AND BATCH_RESULT = 'SPLIT_COMPLETED';
            END;

            /* GROUP 로딩 COUNT 증가 */
            BEGIN
                N_PSI_GROUP_INSERT := N_PSI_GROUP_INSERT + 1;
            END;

            /* GROUP별로 작업종료후 Temp Table TRUNCATE */
            IF N_PSI_GROUP_INSERT <= N_PSI_GROUP_CNT THEN
                /* GROUP별로 작업종료후 Temp Table TRUNCATE */
                DELETE FROM GT_DPCF_T2_DM_PLN_CUSTOMER_PSI; /* 원본 TRUNCATE→GTT는 DELETE(단일TX 원자성 보존·Oracle TRUNCATE 암묵COMMIT 회피) */
                DELETE FROM GT_DPCF_T3_DM_PLN_CUSTOMER_PSI; /* 원본 TRUNCATE→GTT는 DELETE(단일TX 원자성 보존·Oracle TRUNCATE 암묵COMMIT 회피) */
            END IF;

        END LOOP;

        /* [E20241126-000426]_Cust.FCST(P+P) Measure 로직 수정 START */
        /* 프로시져를 호출하여, CUST_FCST 메져 데이터를 생성한다 */

        SELECT MAX(T.SEQ)
          INTO V_CNT
          FROM GT_DPCF_CUST_FCST_DIVISION T;
        V_I := 0;
        V_CUST_FCST_DIVISION := NULL;

        /* 할당단위별 루프 */
        WHILE V_I <= V_CNT LOOP
            SELECT DIVISION_ID
              INTO V_CUST_FCST_DIVISION
              FROM GT_DPCF_CUST_FCST_DIVISION T
             WHERE T.SEQ = V_I;

            PR_DM_PLN_MKT_FCST_MAKE_CUST_FCST(V_CUST_FCST_DIVISION);
            V_I := V_I + 1;
        END LOOP;
        /* [E20241126-000426]_Cust.FCST(P+P) Measure 로직 수정 END */
        /* ------------------------------------------------------------------------------------------------------------- PSI GROUP LOOP END */
        /* ############################################################################################################# */
        /* ------------------------------------------------------------------------------------------------------------- PSI GROUP LOOP END */

        /* [원자성] MSSQL 원본의 COMMIT 은 상위 BEGIN TRAN 내부 실행이라 @@TRANCOUNT 감소일 뿐 실커밋이 아니었다. */
        /* END */

        /* ----------------------------------------------------------- */

        /* 수행결과 성공여부 DISPLAY */
        /* IF v_log_message IS NULL */
        /* SELECT 'success' ; */

        /* 종료 LOG */
        V_LOG_TYPE := 'END';
        V_LOG_MESSAGE := '########## END of procedure ##########';
        V_DESCRIPTION := 'psi_update_count= ' ||TO_CHAR(N_PSI_UPDATE_COUNT)||' / psi_delete_count= ' ||TO_CHAR(N_PSI_DELETE_COUNT)||
                         ' / psi_insert_count= ' ||TO_CHAR(N_PSI_INSERT_COUNT)||' / fcst_delete_count= ' ||TO_CHAR(N_FCST_DELETE_COUNT)||
                         ' / fcst_insert_count= ' ||TO_CHAR(N_FCST_INSERT_COUNT)
        /* || ' */
         ;
        D_EVENT_DATE := SYSTIMESTAMP;

        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        << ERR_RTN >>
        NULL;
        IF V_LOG_TYPE = 'INVALID' THEN
            ROLLBACK;
            PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
        END IF;

    END;
    /* ----------------------------------------------------------------------------------------- */

EXCEPTION
    /* ----------------------------------------------------------- */
    /* 트랜잭션 (END) */
    /* ERROR LOG VALUE SAVE */
    WHEN OTHERS THEN
        ROLLBACK;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME
                            , 'ERROR'
                            , 0
                            , SQLERRM
                            , NULL
                            , SYSDATE
                            , P_IN_PARA_DATA  => V_IN_PARA_DATA
                            , P_SQL_ERR_CODE  => SQLCODE
                            , P_SQL_ERR_MSG   => SQLERRM
                            , P_SQL_BACKTRACE => DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
        /* [E20260818-RAISE] ⭐ 예외를 삼키지 않는다.
           종전에는 ROLLBACK 후 정상 종료해, 호출자(DMF0014 Excel Upload)의 INSERT 까지
           되돌아간 사실이 상위로 전달되지 않았다 = "저장 완료인데 원장 0건"(허위 성공).
           로그를 남긴 뒤 그대로 전파해 호출자가 실패로 끝나게 한다. */
        RAISE;


END;
/
