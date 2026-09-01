CREATE OR REPLACE PROCEDURE PR_DM_PLN_CUST_FCST_TO_MKT_FCST_40 (P_DIVISION_ID IN VARCHAR2
    /* p_active_flag            VARCHAR2    -- 필요없음 */
    )

/* 데이터 확인이 필요할 경우 '--확인' 을 '--확인' 으로 변경하면 DEBUG 모드이고 */
    /* '--확인' 을 '--확인' 으로 변경하면 일반 모드임 */
/*
    ● PR_DM_PLN_CUST_FCST_TO_MKT_FCST_40 로직 구조
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
     * Program ID   : PR_DM_PLN_CUST_FCST_TO_MKT_FCST_40
     * Description  : MKT FCST - Car Production Result Mapping
     * Program History
     *===================================================================================================
     *   Date       In Charge      Description
     *===================================================================================================
     * 2018. 01. 11    KHSONG      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
     * 2022. 10. 26    KDW2819    [C20221024-000507]CUST FCST Upload 오류 수정
     * 2023. 02. 28    chano0612    [E20230227-000456]소형사업부 RPA 업로드 시 GSCM Fail 발생 -- EXCEL UPLOAD
     * 2024. 05. 02    kcw3408     N:N Model Mapping_적재 추가(집계 시점에 Cust Item/Unloading Point/Plant 고려,Valid Range 1~5에 포함되지 않는 구간은 Calloff 데이터를 집계하지 않음)
     * 2024. 12. 19    KANG.H.J    [PJ2024-50647] 자동차사업부 고객 수요 분석 기능 개선
     * 2026.07.06   ZIONEX        [PJ202650304] NextSCM Migration
     *=================================================================================================*/
 AS

    V_IN_PARA_DATA            VARCHAR2(4000 CHAR);
    V_DIVISION_ID             VARCHAR2(4000 CHAR);
    V_PROGRAM_NAME            VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
    V_LOG_TYPE                VARCHAR2(30 CHAR);
    N_LOG_COUNT               INTEGER := 0;
    V_LOG_MESSAGE             VARCHAR2(1000 CHAR);
    V_DESCRIPTION             VARCHAR2(500 CHAR);
    D_EVENT_DATE              DATE;
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
    V_CNT_1                   INTEGER := 0;
    V_CNT_2                   INTEGER := 0;
    CUR_CAR_RESULT            SYS_REFCURSOR;
    V_FETCH_STATUS            INTEGER := 0;
BEGIN

    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1) (2);
    END IF;
    V_DIVISION_ID := P_DIVISION_ID;

    /* LOG 용 변수 설정 */
    DELETE FROM GT_DPCF_RESULTS; /* 원본 TRUNCATE→GTT는 DELETE(단일TX 원자성 보존·Oracle TRUNCATE 암묵COMMIT 회피) */
    /* ------------------------------------------------------------------------------------------ 20180301 추가 (END) */
    /* ------------------------------------------------------------------------------------------ 20180409 추가 (START) */
    /* GT_DPCF_TMP_SITE_CUSTOMER_MAP TEMP TABLE */
    DELETE FROM GT_DPCF_TMP_SITE_CUSTOMER_MAP; /* 원본 TRUNCATE→GTT는 DELETE(단일TX 원자성 보존·Oracle TRUNCATE 암묵COMMIT 회피) */
    /* ------------------------------------------------------------------------------------------ 20180409 추가 (END) */

    /* 시작 LOG  (START) */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := NULL;
    D_EVENT_DATE  := SYSTIMESTAMP;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
    V_LOG_MESSAGE := NULL; /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
    /* 시작 LOG  (END) */

    IF P_DIVISION_ID = '40' THEN

        /* 트랜잭션 (START) */
        /* ----------------------------------------------------------------------------------------- */

        /* ----------------------------------------------------------------------------------------- */
        INSERT
        INTO GT_DPCF_DM_PLN_CUSTOMER_PSI
            (DIVISION_ID
            ,CUSTOMER_PROJECT_CODE
            ,CUSTOMER_MODEL
            ,SCM_SITE_ID
            ,DOM_EXP
            ,FCST_TYPE
            ,MEASURE_GROUP
            ,MEASURE
            ,YYYYMMDD
            ,INCOTERMS
            ,PLANT_SITE_ID
            ,PROJECT_CODE
            ,ITEM_ID
            ,QTY
            ,UPLOAD_UOM
            ,CREATED_BY
            ,CREATION_DATE
            ,LAST_UPDATED_BY
            ,LAST_UPDATE_DATE
            ,BATCH_RESULT
            ,MST_UPLOAD_UOM
            ,MST_UPLOAD_BUCKET_TYPE
            ,MST_SUMMARY_BUCKET_TYPE
            ,MST_CONVERT_QTY
            ,PLAN_WEEK
            ,SPLIT_RESULT
            ,ATTRIBUTE1
            ,ATTRIBUTE2
            ,ATTRIBUTE3
            ,ATTRIBUTE4
            ,ATTRIBUTE5
            ,ATTRIBUTE6
            ,ATTRIBUTE7
            ,ATTRIBUTE8
            ,ATTRIBUTE9
            ,ATTRIBUTE10)
            SELECT DIVISION_ID
                  ,CUSTOMER_PROJECT_CODE
                  ,CUSTOMER_MODEL
                  ,SCM_SITE_ID
                  ,DOM_EXP
                  ,FCST_TYPE
                  ,MEASURE_GROUP
                  ,MEASURE
                  ,YYYYMMDD
                  ,INCOTERMS
                  ,PLANT_SITE_ID
                  ,'IM' PROJECT_CODE
                  ,ITEM_ID
                  ,QTY
                  ,UPLOAD_UOM
                  ,CREATED_BY
                  ,CREATION_DATE
                  ,LAST_UPDATED_BY
                  ,LAST_UPDATE_DATE
                  ,BATCH_RESULT
                  ,MST_UPLOAD_UOM
                  ,MST_UPLOAD_BUCKET_TYPE
                  ,MST_SUMMARY_BUCKET_TYPE
                  ,MST_CONVERT_QTY
                  ,PLAN_WEEK
                  ,SPLIT_RESULT
                  ,ATTRIBUTE1
                  ,ATTRIBUTE2
                  ,ATTRIBUTE3
                  ,ATTRIBUTE4
                  ,ATTRIBUTE5
                  ,ATTRIBUTE6
                  ,ATTRIBUTE7
                  ,ATTRIBUTE8
                  ,ATTRIBUTE9
                  ,ATTRIBUTE10
            FROM   DM_PLN_CUSTOMER_PSI
            WHERE  BATCH_RESULT = 'UI'  /* 'UI'로 마킹된 데이터만 처리 */
            AND    MEASURE_GROUP = 'CUST_FCST'  /* FCST 데이터만 처리 */
            AND    DIVISION_ID = '40'
            /* AND QTY > 0                  -- QTY값이 0인것도 기존데이터 초기화를 위해서 필요함 */
            ORDER  BY DIVISION_ID, SCM_SITE_ID, YYYYMMDD;
        /* ---------------------------------------------------------------------------------------------------------- 대상자료 저장 END */
        /* DM_PLN_CUSTOMER_PSI 대상 데이터의 GROUP별 COUNT ------------------------------------------------------------------------------- START */
        /* PRINT('1.DM_PLN_CUSTOMER_PSI 대상 데이터의 GROUP별 COUNT') */
        BEGIN
            INSERT
            INTO GT_DPCF_PSI_GROUP_COUNT
                (DIVISION_ID
                ,CUSTOMER_PROJECT_CODE
                ,CUSTOMER_MODEL
                ,SCM_SITE_ID
                ,DOM_EXP
                ,FCST_TYPE
                ,MEASURE_GROUP
                ,MEASURE
                ,INCOTERMS
                ,PLANT_SITE_ID
                ,PSI_ROWNUM)
                SELECT DIVISION_ID
                      ,CUSTOMER_PROJECT_CODE
                      ,CUSTOMER_MODEL
                      ,SCM_SITE_ID
                      ,DOM_EXP
                      ,FCST_TYPE
                      ,MEASURE_GROUP
                      ,MEASURE
                      ,INCOTERMS
                      ,PLANT_SITE_ID
                      ,ROW_NUMBER() OVER(ORDER BY DIVISION_ID) PSI_ROWNUM
                FROM   GT_DPCF_DM_PLN_CUSTOMER_PSI
                GROUP  BY DIVISION_ID, CUSTOMER_PROJECT_CODE, CUSTOMER_MODEL, SCM_SITE_ID, DOM_EXP, FCST_TYPE, MEASURE_GROUP, MEASURE, INCOTERMS, PLANT_SITE_ID;
        END;

        BEGIN
            SELECT MAX(PSI_ROWNUM) INTO N_PSI_GROUP_CNT FROM GT_DPCF_PSI_GROUP_COUNT;
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
                    DELETE FROM GT_DPCF_TEMP3_DM_PLN_CUSTOMER; /* 원본 TRUNCATE→GTT는 DELETE(단일TX 원자성 보존·Oracle TRUNCATE 암묵COMMIT 회피) */
                END;
                /* ---------------------------- */
                BEGIN
                    DELETE FROM GT_DPCF_TEMP2_DM_PLN_CUSTOMER; /* 원본 TRUNCATE→GTT는 DELETE(단일TX 원자성 보존·Oracle TRUNCATE 암묵COMMIT 회피) */
                END;

            END;

            /* (임시테이블 존재여부 확인후 생성) END ---------------------------- */
            /* Cursor 데이터 로딩 ----------------------------------------------------------------------------------------------- START */
            BEGIN

                /* Cursor 로 처리 */

                /* CUR_CAR_RESULT CURSOR FAST_FORWARD FOR */
                OPEN CUR_CAR_RESULT FOR
                    SELECT DIVISION_ID
                          ,CUSTOMER_PROJECT_CODE
                          ,CUSTOMER_MODEL
                          ,SCM_SITE_ID
                          ,DOM_EXP
                          ,FCST_TYPE
                          ,MEASURE_GROUP
                          ,MEASURE
                          ,YYYYMMDD
                          ,INCOTERMS
                          ,PLANT_SITE_ID
                          ,PROJECT_CODE
                          ,ITEM_ID
                          ,QTY
                          ,UPPER(RTRIM(LTRIM(UPLOAD_UOM)))
                          ,CREATED_BY
                          ,CREATION_DATE
                          ,LAST_UPDATED_BY
                          ,LAST_UPDATE_DATE
                          ,BATCH_RESULT
                          ,MST_UPLOAD_UOM
                          ,MST_UPLOAD_BUCKET_TYPE
                          ,MST_SUMMARY_BUCKET_TYPE
                          ,MST_CONVERT_QTY
                          ,PLAN_WEEK
                          ,SPLIT_RESULT
                          ,ATTRIBUTE1
                          ,ATTRIBUTE2
                          ,ATTRIBUTE3
                          ,ATTRIBUTE4
                          ,ATTRIBUTE5
                          ,ATTRIBUTE6
                          ,ATTRIBUTE7
                          ,ATTRIBUTE8
                          ,ATTRIBUTE9
                          ,ATTRIBUTE10
                    FROM   GT_DPCF_DM_PLN_CUSTOMER_PSI A
                    WHERE  1 = 1
                    AND    EXISTS (SELECT 1
                            FROM   GT_DPCF_PSI_GROUP_COUNT B
                            WHERE  B.PSI_ROWNUM = N_PSI_GROUP_INSERT
                            AND    A.DIVISION_ID = B.DIVISION_ID
                                  /* AND  A.CUSTOMER_PROJECT_CODE    = B.CUSTOMER_PROJECT_CODE */
                            AND    A.CUSTOMER_MODEL = B.CUSTOMER_MODEL
                            AND    A.SCM_SITE_ID = B.SCM_SITE_ID
                            AND    A.DOM_EXP = B.DOM_EXP
                            AND    A.FCST_TYPE = B.FCST_TYPE
                            AND    A.MEASURE_GROUP = B.MEASURE_GROUP
                            AND    A.MEASURE = B.MEASURE
                            AND    A.INCOTERMS = B.INCOTERMS
                            AND    A.PLANT_SITE_ID = B.PLANT_SITE_ID);
            END;
            /*  */
            BEGIN
                FETCH CUR_CAR_RESULT
                    INTO V_DIVISION_ID
                        ,V_CUSTOMER_PROJECT_CODE
                        ,V_CUSTOMER_MODEL
                        ,V_SCM_SITE_ID
                        ,V_DOM_EXP
                        ,V_FCST_TYPE
                        ,V_MEASURE_GROUP
                        ,V_MEASURE
                        ,V_YYYYMMDD
                        ,V_INCOTERMS
                        ,V_PLANT_SITE_ID
                        ,V_PROJECT_CODE
                        ,V_ITEM_ID
                        ,V_QTY
                        ,V_UPLOAD_UOM
                        ,V_CREATED_BY
                        ,V_CREATION_DATE
                        ,V_LAST_UPDATED_BY
                        ,V_LAST_UPDATE_DATE
                        ,V_BATCH_RESULT
                        ,V_MST_UPLOAD_UOM
                        ,V_MST_UPLOAD_BUCKET_TYPE
                        ,V_MST_SUMMARY_BUCKET_TYPE
                        ,V_MST_CONVERT_QTY
                        ,V_PLAN_WEEK
                        ,V_SPLIT_RESULT
                        ,V_ATTRIBUTE1
                        ,V_ATTRIBUTE2
                        ,V_ATTRIBUTE3
                        ,V_ATTRIBUTE4
                        ,V_ATTRIBUTE5
                        ,V_ATTRIBUTE6
                        ,V_ATTRIBUTE7
                        ,V_ATTRIBUTE8
                        ,V_ATTRIBUTE9
                        ,V_ATTRIBUTE10;

                /* (WHILE START) ---------------------------------------------------------------------------------------------------------------- */
                WHILE CUR_CAR_RESULT%FOUND LOOP
                    /* 변수 초기화 */
                    BEGIN
                        V_START_WEEK          := NULL;
                        N_UPLOAD_BUCKET_TYPE  := NULL;
                        N_SUMMARY_BUCKET_TYPE := NULL;
                        N_PLAN_WEEK           := NULL;
                        N_UPLOAD_UOM          := NULL;
                        N_ITEM_CLASS_NAME     := NULL;
                        N_PROJECT_CODE        := NULL;
                        N_ITEM_ID             := NULL;
                        N_UPLOAD_UOM_KEY      := NULL;
                        N_AUTO_SPLIT_DATA     := NULL;
                        N_CONVERT_QTY_PACK    := 0;
                        N_CONVERT_QTY_MODULE  := 0;
                        N_CONVERT_QTY_CELL    := 0;
                        N_CONVERT_QTY         := 0;
                    END;

                    /* 마스터에 설정된 MEASURE별 BUCKET_TYPE 추출 */
                    /* (F03) */
                    IF N_UPLOAD_BUCKET_TYPE IS NULL THEN
                        SELECT UPLOAD_BUCKET_TYPE, SUMMARY_BUCKET_TYPE, MAX(PLAN_WEEK)
                        INTO   N_UPLOAD_BUCKET_TYPE, N_SUMMARY_BUCKET_TYPE, N_PLAN_WEEK
                        FROM   DM_MST_CUSTOMER_FCST
                        WHERE  1 = 1
                        AND    DIVISION_ID = V_DIVISION_ID
                        AND    SCM_SITE_ID = V_SCM_SITE_ID
                        AND    MEASURE_GROUP = V_MEASURE_GROUP
                        AND    MEASURE = V_MEASURE
                        AND    VALID_YN = 'Y'  /* 20180409 SongKH Add */
                        AND    PLAN_WEEK = (SELECT MAX(PLAN_WEEK)
                                            FROM   DM_MST_CUSTOMER_FCST
                                            WHERE  DIVISION_ID = V_DIVISION_ID
                                            AND    SCM_SITE_ID = V_SCM_SITE_ID
                                            AND    MEASURE_GROUP = V_MEASURE_GROUP
                                            AND    MEASURE = V_MEASURE
                                            AND    VALID_YN = 'Y'  /* 20180409 SongKH Add */
                                            )
                        GROUP  BY UPLOAD_BUCKET_TYPE, SUMMARY_BUCKET_TYPE, PLAN_WEEK;
                    END IF;
                    IF N_UPLOAD_BUCKET_TYPE = 'MONTHLY' THEN
                        V_START_WEEK := V_YYYYMMDD;
                    ELSE
                        V_START_WEEK := TO_CHAR(FN_NEXT_DAY(TO_DATE(V_YYYYMMDD, 'YYYYMMDD'), 'MON') + (-7), 'YYYYMMDD');
                    END IF;
                    /*---- PROJECT_CODE 정보 추출하여 저장 ----40사업부는 없음
                    BEGIN
                    SELECT PROJECT_CODE INTO n_PROJECT_CODE FROM DM_MST_CUSTOMER_MODEL
                     WHERE 1=1
                       AND DIVISION_ID = v_DIVISION_ID
                       --AND CUSTOMER_PROJECT_CODE = v_CUSTOMER_PROJECT_CODE
                       AND CUSTOMER_MODEL = v_CUSTOMER_MODEL
                       AND SCM_SITE_ID = v_SCM_SITE_ID;
                    */
                    N_PROJECT_CODE := NULL;

                    /*---- ITEM_ID 정보 추출하여 저장 ----*/
                    BEGIN
                        SELECT ITEM_ID
                        INTO   N_ITEM_ID
                        FROM   DM_MST_CUSTOMER_MODEL
                        WHERE  1 = 1
                        AND    DIVISION_ID = V_DIVISION_ID
                        AND    CUSTOMER_PROJECT_CODE = V_CUSTOMER_PROJECT_CODE
                        AND    CUSTOMER_MODEL = V_CUSTOMER_MODEL
                        AND    SCM_SITE_ID = V_SCM_SITE_ID;
                    END;

                    /* 추출된 PROJECT_CODE, ITEM ID 값으로 대체 */
                    /* BEGIN */
                    /* v_ITEM_ID := n_ITEM_ID */
                    /* v_PROJECT_CODE := n_PROJECT_CODE */
                    /* END */
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
                        SELECT NVL(MAX(CONVERT_QTY_PACK), 1)
                        INTO   N_CONVERT_QTY_PACK
                        FROM   DM_MST_CUSTOMER_MODEL  /* 20180301 수정 */
                        WHERE  1 = 1
                        AND    DIVISION_ID = V_DIVISION_ID
                              /* AND CUSTOMER_PROJECT_CODE = v_CUSTOMER_PROJECT_CODE */
                        AND    CUSTOMER_MODEL = V_CUSTOMER_MODEL
                        AND    SCM_SITE_ID = V_SCM_SITE_ID;
                    END;
                    /*---- CONVERT_QTY_MODULE 정보 추출하여 저장 ----*/
                    BEGIN
                        SELECT NVL(MAX(CONVERT_QTY_MODULE), 1)
                        INTO   N_CONVERT_QTY_MODULE
                        FROM   DM_MST_CUSTOMER_MODEL  /* 20180301 수정 */
                        WHERE  1 = 1
                        AND    DIVISION_ID = V_DIVISION_ID
                        AND    CUSTOMER_MODEL = V_CUSTOMER_MODEL
                        AND    SCM_SITE_ID = V_SCM_SITE_ID;
                    END;
                    /*---- CONVERT_QTY_CELL 정보 추출하여 저장 ----*/
                    BEGIN
                        SELECT NVL(MAX(CONVERT_QTY_CELL), 1)
                        INTO   N_CONVERT_QTY_CELL
                        FROM   DM_MST_CUSTOMER_MODEL  /* 20180301 수정 */
                        WHERE  1 = 1
                        AND    DIVISION_ID = V_DIVISION_ID
                        AND    CUSTOMER_MODEL = V_CUSTOMER_MODEL
                        AND    SCM_SITE_ID = V_SCM_SITE_ID;
                    END;

                    /*---- Convert Qty 구하기 START ----*/
                    BEGIN
                        N_CONVERT_QTY := CASE
                                             WHEN (V_UPLOAD_UOM = 'CAR') THEN
                                              CASE
                                                  WHEN N_UPLOAD_UOM = 'CAR ' THEN
                                                   V_QTY  /* n_CONVERT_QTY_PACK */
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
                                                   V_QTY * N_CONVERT_QTY_MODULE  /* * n_CONVERT_QTY_PACK * n_CONVERT_QTY_MODULE */
                                                  WHEN N_UPLOAD_UOM = 'CELL' THEN
                                                   V_QTY * N_CONVERT_QTY_MODULE * N_CONVERT_QTY_CELL  /* * n_CONVERT_QTY_PACK * n_CONVERT_QTY_MODULE * n_CONVERT_QTY_CELL */
                                              END
                                             WHEN (V_UPLOAD_UOM = 'MODULE') THEN
                                              CASE
                                                  WHEN N_UPLOAD_UOM = 'MODULE' THEN
                                                   V_QTY  /* * n_CONVERT_QTY_MODULE */
                                                  WHEN N_UPLOAD_UOM = 'CELL' THEN
                                                   V_QTY * N_CONVERT_QTY_CELL  /* * n_CONVERT_QTY_PACK * n_CONVERT_QTY_MODULE * n_CONVERT_QTY_CELL */
                                              END
                                             WHEN (V_UPLOAD_UOM = 'CELL') THEN
                                              CASE
                                                  WHEN N_UPLOAD_UOM = 'CELL' THEN
                                                   V_QTY  /* * n_CONVERT_QTY_CELL */
                                              END
                                         END;

                        IF N_CONVERT_QTY IS NULL OR N_CONVERT_QTY = 0 THEN
                            N_CONVERT_QTY := V_QTY * 1;
                        END IF;
                        /*---- Convert Qty 구하기 END ----*/
                        N_BUCKETINSERT := 1;  /* 초기화 */
                        N_BUCKETCOUNT  := 0;  /* 초기화 */
                        N_CALC_QTY     := 0;  /* 초기화 */
                        N_ADD_QTY      := 0;  /* 초기화 */

                        /* 캘린더 임시테이블 생성 */
                        DELETE FROM GT_DPCF_CALENDAR_DM_PLN_CUSTOM; /* 원본 TRUNCATE→GTT는 DELETE(단일TX 원자성 보존·Oracle TRUNCATE 암묵COMMIT 회피) */

                        /* BUCKET_TYPE별 MST_BUCKET_CONVERSION 설정날짜로 SPLIT (START) */
                        /* PRINT('3.BUCKET_TYPE별 MST_BUCKET_CONVERSION 설정날짜로 SPLIT (START)') */
                        BEGIN
                            /* ------------------------------------------------------------------------------------------------- */
                            IF N_UPLOAD_BUCKET_TYPE = 'MONTHLY' THEN
                                INSERT
                                INTO GT_DPCF_CALENDAR_DM_PLN_CUSTOM
                                    (BASIS_YYYYMMDD, RN)
                                    SELECT B.BASIS_YYYYMMDD, ROW_NUMBER() OVER(ORDER BY B.BASIS_YYYYMMDD) RN
                                    FROM   DM_MST_BUCKET_CONVERSION A, SCM_SYS_CALENDAR_M B, SCM_SYS_CALENDAR_M C
                                    WHERE  A.DIVISION_ID = V_DIVISION_ID
                                    AND    A.SCM_SITE_ID = V_SCM_SITE_ID
                                    AND    A.INCOTERMS = V_INCOTERMS
                                    AND    A.YYYYMMDD = B.DAYOFWEEK
                                    AND    A.BUCKET_PER = 'Y'
                                    AND    A.VALID_YN = 'Y'
                                    AND    B.CALENDAR_YYYY = C.CALENDAR_YYYY
                                    AND    B.CALENDAR_MONTH = C.CALENDAR_MONTH
                                    AND    C.BASIS_YYYYMMDD = V_START_WEEK;  /* 해당 주차 */
                                SELECT MAX(RN) INTO N_BUCKETCOUNT FROM GT_DPCF_CALENDAR_DM_PLN_CUSTOM;

                                /* -------------------------------------------------- MST_BUCKET 이 설정안된 경우도 처리되도록 20180301 추가 (START) */
                                IF N_BUCKETCOUNT IS NULL OR N_BUCKETCOUNT = 0 THEN
                                    DELETE FROM GT_DPCF_RESULTS;

                                    INSERT
                                    INTO GT_DPCF_RESULTS
                                        (YYYYMMDD, DAYOFWEEK)
                                        SELECT BASIS_YYYYMMDD, DAYOFWEEK
                                        FROM   SCM_SYS_CALENDAR_M
                                        WHERE  BASIS_YYYYMM = SUBSTR(V_START_WEEK, 1, 6)  /* 매월 1일 날짜로 해당월의 모든 날짜 선택 */
                                              /* AND DAYOFWEEK IN ('MON','TUE','WED','THU','FRI') ORDER BY BASIS_YYYYMMDD   -- 20180424 skh modify */
                                        AND    DAYOFWEEK IN (SELECT SEGMENT3
                                                             FROM   SCM_ADM_LOOKUP_MASTER_DETAIL
                                                             WHERE  1 = 1
                                                             AND    SEGMENT1 = V_DIVISION_ID
                                                             AND    LOOKUP_TYPE = 'DEFAULT_BUCKET_DAY'
                                                             AND    SEGMENT2 = N_UPLOAD_BUCKET_TYPE)  /* 20180424 skh 조건변경 */
                                        ORDER  BY BASIS_YYYYMMDD;

                                    INSERT
                                    INTO GT_DPCF_CALENDAR_DM_PLN_CUSTOM
                                        (BASIS_YYYYMMDD, RN)
                                        SELECT B.BASIS_YYYYMMDD, ROW_NUMBER() OVER(ORDER BY B.BASIS_YYYYMMDD) RN
                                        FROM   GT_DPCF_RESULTS A, SCM_SYS_CALENDAR_M B
                                        WHERE  A.DAYOFWEEK = B.DAYOFWEEK
                                        AND    A.YYYYMMDD = B.BASIS_YYYYMMDD;
                                    SELECT MAX(RN) INTO N_BUCKETCOUNT FROM GT_DPCF_CALENDAR_DM_PLN_CUSTOM;

                                    N_AUTO_SPLIT_DATA := 'Y';

                                END IF;

                                /* -------------------------------------------------- MST_BUCKET 이 설정안된 경우도 처리되도록 20180301 추가 (END) */
                                /* bucketcount 산출 */
                                /* ------------------------------------------------------------------------------------------------- */
                            ELSIF N_UPLOAD_BUCKET_TYPE = 'WEEKLY' THEN
                                /* ------------------------------------------------------------------------------------------------- */
                                BEGIN
                                    INSERT
                                    INTO GT_DPCF_CALENDAR_DM_PLN_CUSTOM
                                        (BASIS_YYYYMMDD, RN)
                                        SELECT B.BASIS_YYYYMMDD, ROW_NUMBER() OVER(ORDER BY B.BASIS_YYYYMMDD) RN
                                        FROM   DM_MST_BUCKET_CONVERSION A, SCM_SYS_CALENDAR_M B, SCM_SYS_CALENDAR_M C
                                        WHERE  A.DIVISION_ID = V_DIVISION_ID
                                        AND    A.SCM_SITE_ID = V_SCM_SITE_ID
                                        AND    A.INCOTERMS = V_INCOTERMS
                                        AND    A.YYYYMMDD = B.DAYOFWEEK
                                        AND    A.BUCKET_PER = 'Y'
                                        AND    A.VALID_YN = 'Y'
                                        AND    B.ISO_YYYYWW = C.ISO_YYYYWW
                                        AND    C.BASIS_YYYYMMDD = V_START_WEEK;  /* 해당 주차 */
                                    /* bucketcount 산출 */
                                    SELECT MAX(RN) INTO N_BUCKETCOUNT FROM GT_DPCF_CALENDAR_DM_PLN_CUSTOM;

                                    /* -------------------------------------------------- MST_BUCKET 이 설정안된 경우도 처리되도록 20180301 추가 (START) */
                                    IF N_BUCKETCOUNT IS NULL OR N_BUCKETCOUNT = 0 THEN
                                        DELETE FROM GT_DPCF_RESULTS;

                                        /* 날짜선택오류로 ISO_WEEK 조건추가 20180402 (SONGKH) */
                                        INSERT
                                        INTO GT_DPCF_RESULTS
                                            (YYYYMMDD, DAYOFWEEK)
                                            SELECT BASIS_YYYYMMDD, DAYOFWEEK
                                            FROM   SCM_SYS_CALENDAR_M Z
                                                  ,(SELECT DISTINCT ISO_WEEK, ISO_YYYYWW FROM SCM_SYS_CALENDAR_M W WHERE BASIS_START_DATE = V_START_WEEK) K  /* 매주 월요일 날짜로 해당주의 날짜 선택 */
                                            WHERE  Z.ISO_WEEK = K.ISO_WEEK
                                            AND    Z.ISO_YYYYWW = K.ISO_YYYYWW
                                                  /* AND DAYOFWEEK IN ('MON','TUE','WED','THU','FRI') ORDER BY BASIS_YYYYMMDD   -- 20180424 skh modify */
                                            AND    DAYOFWEEK IN (SELECT SEGMENT3
                                                                 FROM   SCM_ADM_LOOKUP_MASTER_DETAIL
                                                                 WHERE  1 = 1
                                                                 AND    SEGMENT1 = V_DIVISION_ID
                                                                 AND    LOOKUP_TYPE = 'DEFAULT_BUCKET_DAY'
                                                                 AND    SEGMENT2 = N_UPLOAD_BUCKET_TYPE)  /* 20180424 skh 조건변경 */
                                            ORDER  BY BASIS_YYYYMMDD;

                                        /* 날짜선택오류로 ISO_WEEK 조건추가 20180402 (SONGKH) */
                                        INSERT
                                        INTO GT_DPCF_CALENDAR_DM_PLN_CUSTOM
                                            (BASIS_YYYYMMDD, RN)
                                            SELECT B.BASIS_YYYYMMDD, ROW_NUMBER() OVER(ORDER BY B.BASIS_YYYYMMDD) RN
                                            FROM   GT_DPCF_RESULTS A, SCM_SYS_CALENDAR_M B
                                            WHERE  A.DAYOFWEEK = B.DAYOFWEEK
                                            AND    A.YYYYMMDD = B.BASIS_YYYYMMDD;
                                        SELECT MAX(RN) INTO N_BUCKETCOUNT FROM GT_DPCF_CALENDAR_DM_PLN_CUSTOM;
                                        /* 확인 SELECT n_bucketcount AS 'n_bucketcount IMSI' */
                                        N_AUTO_SPLIT_DATA := 'Y';

                                    END IF;

                                    /* -------------------------------------------------- MST_BUCKET 이 설정안된 경우도 처리되도록 20180301 추가 (END) */
                                END;

                            ELSE
                                /* ------------------------------------------------------------------------------------------------- */
                                IF N_UPLOAD_BUCKET_TYPE = 'DAILY' THEN

                                    INSERT
                                    INTO GT_DPCF_CALENDAR_DM_PLN_CUSTOM
                                        (BASIS_YYYYMMDD, RN)
                                    VALUES
                                        (V_YYYYMMDD, 1);
                                    N_BUCKETCOUNT := 1;
                                END IF;
                                /* ------------------------------------------------------------------------------------------------- */
                            END IF;
                        END;
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
                            V_DAY_VALID         := NULL;  /* 변수초기화 */
                            N_VALID_BUCKET_TYPE := NULL;  /* 변수초기화 */

                            SELECT BASIS_YYYYMMDD INTO V_DAY_VALID FROM GT_DPCF_CALENDAR_DM_PLN_CUSTOM WHERE RN = N_BUCKETINSERT;
                        END;

                        /* Convert QTY값 산출 */
                        IF N_UPLOAD_BUCKET_TYPE = 'DAILY' THEN
                            N_CALC_QTY := V_QTY;  /* DAILY 인경우는 계산필요없이 INPUT값을 그대로 사용함 */

                            SELECT UPLOAD_BUCKET_TYPE
                            INTO   N_VALID_BUCKET_TYPE
                            FROM   DM_MST_CUSTOMER_FCST
                            WHERE  1 = 1
                            AND    DIVISION_ID = V_DIVISION_ID
                            AND    SCM_SITE_ID = V_SCM_SITE_ID
                            AND    MEASURE_GROUP = V_MEASURE_GROUP
                            AND    MEASURE = V_MEASURE
                            AND    SUMMARY_BUCKET_VALUE = V_DAY_VALID  /* daily인경우 INPUT된 날짜 */
                            AND    PLAN_WEEK = N_PLAN_WEEK
                            AND    VALID_YN = 'Y';  /* 20180409 SongKH Add */

                        ELSE
                            SELECT UPLOAD_BUCKET_TYPE
                            INTO   N_VALID_BUCKET_TYPE  /* 해당주차의 bucket 추출 */
                            FROM   DM_MST_CUSTOMER_FCST
                            WHERE  1 = 1
                            AND    DIVISION_ID = V_DIVISION_ID
                            AND    SCM_SITE_ID = V_SCM_SITE_ID
                            AND    MEASURE_GROUP = V_MEASURE_GROUP
                            AND    MEASURE = V_MEASURE
                            AND    SUMMARY_BUCKET_VALUE = TO_CHAR(FN_NEXT_DAY(TO_DATE(V_DAY_VALID, 'YYYYMMDD'), 'MON') + (-7), 'YYYYMMDD')  /* INPUT된 날짜의 당주 월요일 */
                            AND    PLAN_WEEK = N_PLAN_WEEK
                            AND    VALID_YN = 'Y';  /* 20180409 SongKH Add */

                        END IF;

                        IF N_BUCKETINSERT < N_BUCKETCOUNT THEN

                            N_CALC_QTY := TRUNC(N_CONVERT_QTY / N_BUCKETCOUNT, 0);
                            N_ADD_QTY  := N_ADD_QTY + N_CALC_QTY;

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
                                N_UPLOAD_UOM_KEY := N_UPLOAD_UOM;  /* 주차별 BUCKET_TYPE 이 달라도 그대로 사용함 */
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
                            INTO GT_DPCF_TEMP3_DM_PLN_CUSTOMER  /*  */
                                (DIVISION_ID
                                ,CUSTOMER_PROJECT_CODE
                                ,CUSTOMER_MODEL
                                ,SCM_SITE_ID
                                ,DOM_EXP
                                ,FCST_TYPE
                                ,MEASURE_GROUP
                                ,MEASURE
                                ,YYYYMMDD
                                ,INCOTERMS
                                ,PLANT_SITE_ID
                                ,PROJECT_CODE
                                ,ITEM_ID
                                ,QTY
                                ,UPLOAD_UOM
                                ,CREATED_BY
                                ,CREATION_DATE
                                ,LAST_UPDATED_BY
                                ,LAST_UPDATE_DATE
                                ,BATCH_RESULT
                                ,MST_UPLOAD_UOM
                                ,MST_UPLOAD_BUCKET_TYPE
                                ,MST_SUMMARY_BUCKET_TYPE
                                ,MST_CONVERT_QTY
                                ,PLAN_WEEK
                                ,SPLIT_RESULT
                                ,ATTRIBUTE1
                                ,ATTRIBUTE2
                                ,ATTRIBUTE3
                                ,ATTRIBUTE4
                                ,ATTRIBUTE5
                                ,ATTRIBUTE6
                                ,ATTRIBUTE7
                                ,ATTRIBUTE8
                                ,ATTRIBUTE9
                                ,ATTRIBUTE10)
                            VALUES
                                (V_DIVISION_ID
                                ,V_CUSTOMER_PROJECT_CODE
                                ,V_CUSTOMER_MODEL
                                ,V_SCM_SITE_ID
                                ,V_DOM_EXP
                                ,V_FCST_TYPE
                                ,V_MEASURE_GROUP
                                 /* ,RTRIM(LTRIM(TO_CHAR(TO_CHAR(v_MEASURE) || '_new_temp'))) */
                                ,V_MEASURE || '_new_temp'
                                ,(SELECT BASIS_YYYYMMDD FROM GT_DPCF_CALENDAR_DM_PLN_CUSTOM WHERE RN = N_BUCKETINSERT)
                                ,V_INCOTERMS
                                ,V_PLANT_SITE_ID
                                ,'IM'  /* v_PROJECT_CODE */
                                ,V_ITEM_ID
                                ,N_CALC_QTY  /* ROW별로 나눠진 값을 넣음 */
                                ,V_UPLOAD_UOM
                                ,V_CREATED_BY
                                ,V_CREATION_DATE
                                ,V_LAST_UPDATED_BY
                                ,SYSTIMESTAMP
                                ,N_BATCH_RESULT
                                ,N_UPLOAD_UOM
                                ,N_UPLOAD_BUCKET_TYPE
                                ,N_SUMMARY_BUCKET_TYPE
                                ,V_MST_CONVERT_QTY
                                ,V_PLAN_WEEK
                                ,V_SPLIT_RESULT
                                ,V_ATTRIBUTE1
                                ,V_ATTRIBUTE2
                                ,V_ATTRIBUTE3
                                ,V_ATTRIBUTE4
                                ,V_ATTRIBUTE5
                                ,V_ATTRIBUTE6
                                ,V_ATTRIBUTE7
                                ,V_ATTRIBUTE8
                                ,V_ATTRIBUTE9
                                ,V_ATTRIBUTE10);
                        END;

                        BEGIN
                            N_CALC_QTY := 0;  /* 사용후 초기화 */
                        END;

                        BEGIN
                            N_BUCKETINSERT := N_BUCKETINSERT + 1;  /* 최대 ROWS 까지 증가시킴 */
                        END;

                    /*----------------------------------------------------------------------------------------------------------------*/
                    END LOOP;
                    /* ------------------------------------------------------------------------------------------------------------- bucket loop END */

                    /* (10) */
                    /*-------------------- DM_PLN_CUSTOMER_PSI 테이블 update --------------------*/
                    BEGIN
                        /* PRINT('4.DM_PLN_CUSTOMER_PSI 테이블 update') */
                        UPDATE DM_PLN_CUSTOMER_PSI

                        SET    CUSTOMER_PROJECT_CODE = V_CUSTOMER_PROJECT_CODE
                              ,CUSTOMER_MODEL        = V_CUSTOMER_MODEL
                              ,SCM_SITE_ID           = V_SCM_SITE_ID
                              ,DOM_EXP               = V_DOM_EXP
                              ,FCST_TYPE             = V_FCST_TYPE
                              ,MEASURE_GROUP         = V_MEASURE_GROUP
                              ,MEASURE               = V_MEASURE
                              ,YYYYMMDD              = V_YYYYMMDD
                              ,INCOTERMS             = V_INCOTERMS
                              ,PLANT_SITE_ID         = V_PLANT_SITE_ID
                              ,PROJECT_CODE          = N_PROJECT_CODE  /* n_PROJECT_CODE         -- 추출된값으로 셋팅 */
                              ,ITEM_ID               = V_ITEM_ID  /* n_ITEM_ID              -- 추출된값으로 셋팅 */
                              ,QTY                   = V_QTY
                              ,UPLOAD_UOM            = V_UPLOAD_UOM  /* INPUT값 UPLOAD_UOM */
                              ,CREATED_BY            = V_CREATED_BY
                              ,CREATION_DATE         = V_CREATION_DATE
                              ,LAST_UPDATED_BY       = V_LAST_UPDATED_BY
                              ,LAST_UPDATE_DATE      = SYSTIMESTAMP
                              ,BATCH_RESULT          = N_BATCH_RESULT  /* 1.'UI':업로드데이터 2.'UPLOAD_COMPLETED':업데이트작업 3.'UPLOAD_UOM_NOT_FOUND':DM_MST_CUSTOMER_FCST 설정날짜에 안맞는 에러건 */
                               /* 4.'UPLOAD_COMPLETED':DM_PLN_MKT_FCST로 INSERT완료건  5. 'MERGE_COMPLETED':합산완료건 */
                               /* ,MST_UPLOAD_UOM          =   n_UPLOAD_UOM     -- SCM_MST_ITEM_SN.UPLOAD_UOM 추출값 */
                              ,MST_UPLOAD_BUCKET_TYPE  = N_UPLOAD_BUCKET_TYPE  /* DM_MST_CUSTOMER_FCST.UPLOAD_BUCKET_TYPE 셋팅 */
                              ,MST_SUMMARY_BUCKET_TYPE = N_SUMMARY_BUCKET_TYPE  /* DM_MST_CUSTOMER_FCST.SUMMARY_BUCKET_TYPE 셋팅 */
                              ,MST_CONVERT_QTY         = V_MST_CONVERT_QTY  /* DM_MST_CUSTOMER_FCST.CONVERT_QTY 셋팅 */
                              ,PLAN_WEEK               = N_PLAN_WEEK  /* DM_MST_CUSTOMER_FCST.PLAN_WEEK 셋팅 */
                              ,SPLIT_RESULT            = V_SPLIT_RESULT
                              ,ATTRIBUTE1              = V_ATTRIBUTE1
                              ,ATTRIBUTE2              = V_ATTRIBUTE2
                              ,ATTRIBUTE3              = V_ATTRIBUTE3
                              ,ATTRIBUTE4              = V_ATTRIBUTE4
                              ,ATTRIBUTE5              = V_ATTRIBUTE5
                              ,ATTRIBUTE6              = V_ATTRIBUTE6
                              ,ATTRIBUTE7              = V_ATTRIBUTE7
                              ,ATTRIBUTE8              = V_ATTRIBUTE8
                              ,ATTRIBUTE9              = V_ATTRIBUTE9
                              ,ATTRIBUTE10             = V_ATTRIBUTE10
                        WHERE  DIVISION_ID = V_DIVISION_ID
                              /* AND CUSTOMER_PROJECT_CODE  = v_CUSTOMER_PROJECT_CODE */
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
                    /* PRINT('4_1.DM_PLN_CUSTOMER_PSI 테이블 update') */
                    BEGIN
                        FETCH CUR_CAR_RESULT
                            INTO V_DIVISION_ID
                                ,V_CUSTOMER_PROJECT_CODE
                                ,V_CUSTOMER_MODEL
                                ,V_SCM_SITE_ID
                                ,V_DOM_EXP
                                ,V_FCST_TYPE
                                ,V_MEASURE_GROUP
                                ,V_MEASURE
                                ,V_YYYYMMDD
                                ,V_INCOTERMS
                                ,V_PLANT_SITE_ID
                                ,V_PROJECT_CODE
                                ,V_ITEM_ID
                                ,V_QTY
                                ,V_UPLOAD_UOM
                                ,V_CREATED_BY
                                ,V_CREATION_DATE
                                ,V_LAST_UPDATED_BY
                                ,V_LAST_UPDATE_DATE
                                ,V_BATCH_RESULT
                                ,V_MST_UPLOAD_UOM
                                ,V_MST_UPLOAD_BUCKET_TYPE
                                ,V_MST_SUMMARY_BUCKET_TYPE
                                ,V_MST_CONVERT_QTY
                                ,V_PLAN_WEEK
                                ,V_SPLIT_RESULT
                                ,V_ATTRIBUTE1
                                ,V_ATTRIBUTE2
                                ,V_ATTRIBUTE3
                                ,V_ATTRIBUTE4
                                ,V_ATTRIBUTE5
                                ,V_ATTRIBUTE6
                                ,V_ATTRIBUTE7
                                ,V_ATTRIBUTE8
                                ,V_ATTRIBUTE9
                                ,V_ATTRIBUTE10;

                    END;
                    /* (1) */
                END LOOP;
            END;

            /* (WHILE END ) ---------------------------------------------------------------------------------------------------------------- */
            /* PRINT('4_2.DM_PLN_CUSTOMER_PSI 테이블 update') */
            IF CUR_CAR_RESULT%ISOPEN THEN
                CLOSE CUR_CAR_RESULT;
            END IF;

            /* ---input 데이터의 시작과 끝 산출 ------------------------------------------------------------- (start) EEEE */
            BEGIN
                INSERT
                INTO GT_DPCF_MIN_MAX_PSI
                    (YYYYMMDD, RN)
                    SELECT YYYYMMDD, ROW_NUMBER() OVER(ORDER BY YYYYMMDD) RN FROM GT_DPCF_TEMP3_DM_PLN_CUSTOMER GROUP BY YYYYMMDD ORDER BY YYYYMMDD;

            END;
            BEGIN
                SELECT YYYYMMDD INTO N_MIN_YYYYMMDD FROM GT_DPCF_MIN_MAX_PSI WHERE RN = 1;

                SELECT YYYYMMDD INTO N_MAX_YYYYMMDD FROM GT_DPCF_MIN_MAX_PSI WHERE RN = (SELECT MAX(RN) FROM GT_DPCF_MIN_MAX_PSI);
            END;

            /* -input 데이터의 시작과 끝 산출 ------------------------------------------------------------- (end) */
            /* PRINT('5.input 데이터의 시작과 끝 산출') */
            /* -INSERT INTO 할 실제 데이터의 시작과 끝 구간 산출 ----------------------------------------------- (start) 20180409 */
            DELETE FROM GT_DPCF_TMP_SITE_CUSTOMER_MAP;  /* MEASURE별 cursor 작업이므로 초기화 */

            INSERT
            INTO GT_DPCF_TMP_SITE_CUSTOMER_MAP
                SELECT A.DIVISION_ID
                      ,A.SCM_SITE_ID
                      ,A.MEASURE
                      ,A.SUMMARY_BUCKET_VALUE START_DAY
                      ,CASE
                           WHEN A.SUMMARY_BUCKET_TYPE = 'WEEKLY' THEN
                            TO_CHAR(FN_NEXT_DAY(TO_DATE(A.SUMMARY_BUCKET_VALUE, 'YYYYMMDD') /*[E20260827-NLSDATE]*/, 'SUN') + (0), 'YYYYMMDD')
                           ELSE
                            A.SUMMARY_BUCKET_VALUE
                       END END_DAY
                FROM   DM_MST_CUSTOMER_FCST A
                INNER  JOIN (SELECT DISTINCT DIVISION_ID, SCM_SITE_ID, MEASURE_GROUP FROM GT_DPCF_TEMP3_DM_PLN_CUSTOMER) RSLT
                ON     (A.DIVISION_ID = RSLT.DIVISION_ID AND A.SCM_SITE_ID = RSLT.SCM_SITE_ID AND A.MEASURE_GROUP = RSLT.MEASURE_GROUP)
                WHERE  1 = 1
                AND    VALID_YN = 'Y'
                AND    A.PLAN_WEEK = (SELECT MAX(A2.PLAN_WEEK)
                                      FROM   DM_MST_CUSTOMER_FCST A2
                                      WHERE  A2.DIVISION_ID = A.DIVISION_ID
                                      AND    A2.SCM_SITE_ID = A.SCM_SITE_ID
                                      AND    A2.MEASURE_GROUP = A.MEASURE_GROUP)
                AND    A.SUMMARY_BUCKET_VALUE >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7 * 1), 'YYYYMMDD')  /* 당주 월요일 이후데이터만 */
                AND    A.SUMMARY_BUCKET_TYPE IN ('DAILY', 'WEEKLY')

                UNION

                SELECT A.DIVISION_ID
                      ,A.SCM_SITE_ID
                      ,A.MEASURE
                      ,CASE
                           WHEN A.SUMMARY_BUCKET_VALUE = TO_CHAR(TRUNC(SYSDATE, 'MM'), 'YYYYMMDD') THEN
                            TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7 * 1), 'YYYYMMDD')
                           ELSE
                            A.SUMMARY_BUCKET_VALUE
                       END AS START_DAY
                      ,TO_CHAR(ADD_MONTHS(TO_DATE(A.SUMMARY_BUCKET_VALUE, 'YYYYMMDD'), 1) - 1, 'YYYYMMDD') END_DAY
                FROM   DM_MST_CUSTOMER_FCST A
                INNER  JOIN (SELECT DISTINCT DIVISION_ID, SCM_SITE_ID, MEASURE_GROUP FROM GT_DPCF_TEMP3_DM_PLN_CUSTOMER) RSLT
                ON     (A.DIVISION_ID = RSLT.DIVISION_ID AND A.SCM_SITE_ID = RSLT.SCM_SITE_ID AND A.MEASURE_GROUP = RSLT.MEASURE_GROUP)
                WHERE  1 = 1
                AND    A.VALID_YN = 'Y'
                AND    A.PLAN_WEEK = (SELECT MAX(A2.PLAN_WEEK)
                                      FROM   DM_MST_CUSTOMER_FCST A2
                                      WHERE  A2.DIVISION_ID = A.DIVISION_ID
                                      AND    A2.SCM_SITE_ID = A.SCM_SITE_ID
                                      AND    A2.MEASURE_GROUP = A.MEASURE_GROUP)
                AND    A.SUMMARY_BUCKET_VALUE >= TO_CHAR(TRUNC(SYSDATE, 'MM'), 'YYYYMMDD')

                AND    A.SUMMARY_BUCKET_TYPE IN ('MONTHLY');

            /* select 'GT_DPCF_TEMP3_DM_PLN_CUSTOMER ' */
            /* select * from GT_DPCF_TEMP3_DM_PLN_CUSTOMER */
            /* select 'GT_DPCF_TMP_SITE_CUSTOMER_MAP' */
            /* select * from GT_DPCF_TMP_SITE_CUSTOMER_MAP */
            /* -INSERT INTO 할 실제 데이터의 시작과 끝 구간 산출 ----------------------------------------------- (end) 20180409 */
            /* (88) 데이터의 시작~끝 날짜 구하기 ---------------------------------------------- (start) */
            BEGIN
                IF N_UPLOAD_BUCKET_TYPE = 'DAILY' THEN
                    SELECT BASIS_YYYYMMDD INTO N_MAX_YYYYMMDD FROM SCM_SYS_CALENDAR_M T WHERE T.BASIS_YYYYMMDD = TO_CHAR(N_MAX_YYYYMMDD + (0), 'YYYYMMDD');  /* MAX_YYYYMMDD 셋팅 */
                ELSIF N_UPLOAD_BUCKET_TYPE = 'WEEKLY' THEN
                    N_MIN_YYYYMMDD := TO_CHAR(FN_NEXT_DAY(TO_DATE(N_MIN_YYYYMMDD, 'YYYYMMDD'), 'MON') + (-7), 'YYYYMMDD');  /* MIN_YYYYMMDD 셋팅 */
                    SELECT BASIS_YYYYMMDD
                    INTO   N_MAX_YYYYMMDD
                    FROM   SCM_SYS_CALENDAR_M T
                    WHERE  T.BASIS_YYYYMMDD = TO_CHAR(TO_DATE(N_MAX_YYYYMMDD, 'YYYYMMDD') + 6, 'YYYYMMDD');  /* MAX_YYYYMMDD 셋팅 */
                ELSIF N_UPLOAD_BUCKET_TYPE = 'MONTHLY' THEN
                    SELECT BASIS_YYYYMMDD
                    INTO   N_MAX_YYYYMMDD
                    FROM   SCM_SYS_CALENDAR_M T
                    WHERE  T.BASIS_YYYYMMDD = TO_CHAR(ADD_MONTHS(TO_DATE(N_MAX_YYYYMMDD, 'YYYYMMDD'), 1) - 1, 'YYYYMMDD');  /* MAX_YYYYMMDD 셋팅 */
                END IF;
            END;

            /* (88) 데이터의 시작~끝 날짜 구하기 ---------------------------------------------- (end) */
            /* DM_PLN_CUSTOMER_PSI 최종 데이터 INSERT --------------------------------------------------------------------------------------- */
            /* 2024.05.02    kcw3408       고객수요 N:N Mapping */
            /* 매핑테이블 데이블  INSERT */


            /* 대상 프로시저 시그니처: PR_DM_CUST_ITEM_MAPPING(P_ACCEPT_FLAG VARCHAR2). */
            BEGIN
                PR_DM_CUST_ITEM_MAPPING('RPA');
            END;

            /* 대상 추출 */
            BEGIN

                INSERT
                INTO GT_DPCF_DM_CUST_ITEM_MAPPING_D
                    SELECT B.DIVISION_ID
                          ,B.DATA_TYPE_CODE
                          ,B.END_CUSTOMER
                          ,B.SCM_SITE_ID
                          ,B.PROJECT_CODE
                          ,B.FCST_TYPE
                          ,B.INCOTERMS
                          ,B.DOM_EXP
                          ,B.ITEM_ID
                          ,B.UNLOADING_POINT
                          ,B.CUSTOMER_PLANT
                          ,B.CUSTOMER_ITEM_ID
                          ,B.VALID_START_DATE
                          ,B.VALID_END_DATE
                          ,B.MAPPING_ITEM_ID
                    FROM   DM_CUST_ITEM_MAPPING_M A
                    JOIN   DM_CUST_ITEM_MAPPING_DTL_N B
                    ON     A.DIVISION_ID = B.DIVISION_ID
                    AND    A.DATA_TYPE_CODE = B.DATA_TYPE_CODE
                    AND    A.END_CUSTOMER = B.END_CUSTOMER
                    AND    A.SCM_SITE_ID = B.SCM_SITE_ID
                    AND    A.PROJECT_CODE = B.PROJECT_CODE
                    AND    A.FCST_TYPE = B.FCST_TYPE
                    AND    A.INCOTERMS = B.INCOTERMS
                    AND    A.DOM_EXP = B.DOM_EXP
                    AND    A.ITEM_ID = B.ITEM_ID
                    AND    A.UNLOADING_POINT = B.UNLOADING_POINT
                    AND    RTRIM(LTRIM(A.CUSTOMER_PLANT)) = RTRIM(LTRIM(B.CUSTOMER_PLANT))
                    AND    RTRIM(LTRIM(A.CUSTOMER_ITEM_ID)) = RTRIM(LTRIM(B.CUSTOMER_ITEM_ID))
                    WHERE  A.ACTIVE_YN = 'Y'
                    AND    A.DATA_TYPE_CODE IN ('RPA', 'EXCEL')
                    AND    A.DIVISION_ID = '40';
            END;

            /* PRINT('6.DM_PLN_CUSTOMER_PSI 최종 데이터 INSERT INTO 전 임시테이블에 모두 저장') */
            /* DM_PLN_CUSTOMER_PSI 최종 데이터 INSERT INTO 전 임시테이블에 모두 저장 */
            BEGIN
                /* / * */
                /* INSERT / *+ NO_PARALLEL * / INTO GT_DPCF_TEMP2_DM_PLN_CUSTOMER */
                /* SELECT DISTINCT */
                /* '40' DIVISION_ID,A.CUSTOMER_PROJECT_CODE,A.CUSTOMER_MODEL,A.SCM_SITE_ID,A.DOM_EXP,A.FCST_TYPE,A.MEASURE_GROUP */
                /* ,v_MEASURE    -- 20180227변경사항 measure를 기존값으로 그대로 사용함 */
                /* ,A.YYYYMMDD,A.INCOTERMS,A.PLANT_SITE_ID,A.PROJECT_CODE,B.MAPPING_ITEM_ID ITEM_ID,QTY,A.UPLOAD_UOM,A.CREATED_BY,A.CREATION_DATE */
                /* ,A.LAST_UPDATED_BY,A.LAST_UPDATE_DATE,A.BATCH_RESULT,A.MST_UPLOAD_UOM,A.MST_UPLOAD_BUCKET_TYPE,A.MST_SUMMARY_BUCKET_TYPE */
                /* ,A.MST_CONVERT_QTY,A.PLAN_WEEK,SPLIT_RESULT,A.ATTRIBUTE1,A.ATTRIBUTE2,A.ATTRIBUTE3,A.ATTRIBUTE4,A.ATTRIBUTE5,A.ATTRIBUTE6 */
                /* ,A.ATTRIBUTE7,A.ATTRIBUTE8,A.ATTRIBUTE9,A.ATTRIBUTE10 */

                /* -- */
                /* 2024.05.02    kcw3408       고객수요 N:N Mapping */
                /* 전체 대생 추출후 N:N Model Mapping 작업 */
                /* .집계 시점에 Cust Item/Unloading Point/Plant 반영 */
                /* .Valid Range 1~5에 포함되지 않는 구간은 Calloff 데이터를 집계하지 않음 */
                /*  */


                /* AND A.SCM_SITE_ID = B.SCM_SITE_ID */
                /* --AND A.PROJECT_CODE = B.PROJECT_CODE */
                /* AND A.FCST_TYPE = B.FCST_TYPE */
                /* AND A.INCOTERMS = B.INCOTERMS */
                /* AND A.DOM_EXP = B.DOM_EXP */

                /* AND A.YYYYMMDD >= B.VALID_START_DATE */
                /* AND A.YYYYMMDD <= B.VALID_END_DATE */

                /* AND CASE WHEN A.CREATED_BY LIKE '%robot' */


                /* where n_MIN_YYYYMMDD <= YYYYMMDD */
                /* AND n_MAX_YYYYMMDD >= YYYYMMDD; */
                /* * / */
                /* [PJ2024-50647] RPA, EXCEL의 경우 N:N 매핑없이 처리함. START */
                INSERT
                INTO GT_DPCF_TEMP2_DM_PLN_CUSTOMER
                    SELECT DISTINCT '40' DIVISION_ID
                                   ,A.CUSTOMER_PROJECT_CODE
                                   ,A.CUSTOMER_MODEL
                                   ,A.SCM_SITE_ID
                                   ,A.DOM_EXP
                                   ,A.FCST_TYPE
                                   ,A.MEASURE_GROUP
                                   ,V_MEASURE  /* 20180227변경사항 measure를 기존값으로 그대로 사용함 */
                                   ,A.YYYYMMDD
                                   ,A.INCOTERMS
                                   ,A.PLANT_SITE_ID
                                   ,A.PROJECT_CODE
                                   ,A.ITEM_ID
                                   ,A.QTY
                                   ,A.UPLOAD_UOM
                                   ,A.CREATED_BY
                                   ,A.CREATION_DATE
                                   ,A.LAST_UPDATED_BY
                                   ,A.LAST_UPDATE_DATE
                                   ,A.BATCH_RESULT
                                   ,A.MST_UPLOAD_UOM
                                   ,A.MST_UPLOAD_BUCKET_TYPE
                                   ,A.MST_SUMMARY_BUCKET_TYPE
                                   ,A.MST_CONVERT_QTY
                                   ,A.PLAN_WEEK
                                   ,A.SPLIT_RESULT
                                   ,A.ATTRIBUTE1
                                   ,A.ATTRIBUTE2
                                   ,A.ATTRIBUTE3
                                   ,A.ATTRIBUTE4
                                   ,A.ATTRIBUTE5
                                   ,A.ATTRIBUTE6
                                   ,A.ATTRIBUTE7
                                   ,A.ATTRIBUTE8
                                   ,A.ATTRIBUTE9
                                   ,A.ATTRIBUTE10
                    FROM   GT_DPCF_TEMP3_DM_PLN_CUSTOMER A
                    WHERE  N_MIN_YYYYMMDD <= A.YYYYMMDD
                    AND    N_MAX_YYYYMMDD >= A.YYYYMMDD;

                /* [PJ2024-50647] RPA, EXCEL의 경우 N:N 매핑없이 처리함. END */
            END;

            /* DM_PLN_CUSTOMER_PSI DELETE FROM count 확인 ------------------------------------------------------------------------------------ */
            /* DM_PLN_CUSTOMER_PSI INSERT INTO count 확인 ---------------------------------------------------------------------------------------- */
            BEGIN
                SELECT N_PSI_INSERT_COUNT + COUNT(*) INTO N_PSI_INSERT_COUNT FROM GT_DPCF_TEMP2_DM_PLN_CUSTOMER;
            END;

            /* (11) */
            /*-------------------- DM_PLN_MKT_FCST 테이블 DELETE FROM count 확인 --------------------*/
            BEGIN
                DECLARE
                    V_FCST_DEL_CNT INTEGER := 0;
                BEGIN
                    SELECT COUNT(*) CNT
                    INTO   V_FCST_DEL_CNT
                    FROM   DM_PLN_MKT_FCST A
                    WHERE  1 = 1
                    AND    EXISTS (SELECT 1
                            FROM   GT_DPCF_TEMP2_DM_PLN_CUSTOMER B
                            WHERE  A.DIVISION_ID = B.DIVISION_ID
                            AND    A.SCM_SITE_ID = B.SCM_SITE_ID
                                  /* AND  A.PROJECT_CODE              =   B.PROJECT_CODE */
                            AND    A.ITEM_ID = B.ITEM_ID
                            AND    A.DOM_EXP = B.DOM_EXP
                            AND    A.FCST_TYPE = B.FCST_TYPE
                            AND    A.INCOTERMS = B.INCOTERMS
                            AND    A.PLANT_SITE_ID = B.PLANT_SITE_ID
                            AND    A.MEASURE = B.MEASURE
                            /* AND A.YYYYMMDD >= n_MIN_YYYYMMDD  -- 추출된 데이터의 MIN ~ MAX의 구간  --20180409 modify */
                            /* AND A.YYYYMMDD <= n_MAX_YYYYMMDD  -- 추출된 데이터의 MIN ~ MAX의 구간  --20180409 modify */
                            );
                    N_FCST_DELETE_COUNT := N_FCST_DELETE_COUNT + V_FCST_DEL_CNT;
                END;
            END;

            /* PRINT('7.DM_PLN_MKT_FCST 테이블 insert전 데이터 중복제거') */
            /*-------------------- DM_PLN_MKT_FCST 테이블 insert전 데이터 중복제거 --------------------*/
            BEGIN

                DELETE FROM DM_PLN_MKT_FCST
                WHERE  (SELECT COUNT(1)
                        FROM   GT_DPCF_TEMP2_DM_PLN_CUSTOMER B
                        WHERE  1 = 1
                        AND    DM_PLN_MKT_FCST.DIVISION_ID = B.DIVISION_ID
                        AND    DM_PLN_MKT_FCST.SCM_SITE_ID = B.SCM_SITE_ID
                              /* and  DM_PLN_MKT_FCST.PROJECT_CODE       =  B.PROJECT_CODE */
                        AND    DM_PLN_MKT_FCST.ITEM_ID = B.ITEM_ID
                        AND    DM_PLN_MKT_FCST.DOM_EXP = B.DOM_EXP
                        AND    DM_PLN_MKT_FCST.FCST_TYPE = B.FCST_TYPE
                        AND    DM_PLN_MKT_FCST.INCOTERMS = B.INCOTERMS
                        AND    DM_PLN_MKT_FCST.PLANT_SITE_ID = B.PLANT_SITE_ID
                        AND    DM_PLN_MKT_FCST.MEASURE = B.MEASURE
                        AND    DM_PLN_MKT_FCST.YYYYMMDD >= N_MIN_YYYYMMDD  /* 추출된 데이터의 MIN ~ MAX의 구간 */
                        AND    DM_PLN_MKT_FCST.YYYYMMDD <= N_MAX_YYYYMMDD  /* 추출된 데이터의 MIN ~ MAX의 구간 */
                        ) > 0;
            END;
            /*-------------------------------------------------------------------------------------*/
            /* SELECT * FROM DM_PLN_MKT_FCST WHERE MEASURE = 'CUST_FCST' AND SCM_SITE_ID = 'IM_CN_NGG' AND CREATION_DATE > '2023-01-01 00:00' */
            /* PRINT('7_1.DM_PLN_MKT_FCST 테이블 insert전 데이터 중복제거') */

            /* SELECT * FROM GT_DPCF_TEMP2_DM_PLN_CUSTOMER */
            /* PRINT('8_0.DM_PLN_MKT_FCST 테이블 insert =================== START ============================') */

            /*-------------------------------------------------------------------------------------*/
            BEGIN
                IF V_DIVISION_ID = '40' THEN

                    INSERT INTO DM_PLN_MKT_FCST
                        (DIVISION_ID
                        ,PROJECT_CODE
                        ,SCM_SITE_ID
                        ,ITEM_ID
                        ,DOM_EXP
                        ,FCST_TYPE
                        ,INCOTERMS
                        ,MEASURE
                        ,PLANT_SITE_ID
                        ,YYYYMMDD
                        ,QTY
                        ,CREATED_BY
                        ,CREATION_DATE
                        ,LAST_UPDATED_BY
                        ,LAST_UPDATE_DATE
                        ,ATTRIBUTE8
                        ,ATTRIBUTE9
                        ,ATTRIBUTE10)
                        SELECT DISTINCT DIVISION_ID
                                       ,'IM'
                                       ,SCM_SITE_ID
                                       ,ITEM_ID
                                       ,DOM_EXP
                                       ,FCST_TYPE
                                       ,INCOTERMS
                                       ,MEASURE
                                       ,PLANT_SITE_ID
                                       ,YYYYMMDD
                                       ,QTY
                                       ,CREATED_BY
                                       ,CREATION_DATE
                                       ,LAST_UPDATED_BY
                                       ,SYSTIMESTAMP
                                       ,ATTRIBUTE8
                                       ,ATTRIBUTE9
                                       ,ATTRIBUTE10
                        FROM   GT_DPCF_TEMP2_DM_PLN_CUSTOMER
                        WHERE  1 = 1
                              /* AND BATCH_RESULT = 'UPLOAD_COMPLETED'  -- modified by ytchoi 180305 */
                              /* added by ytchoi 180305 */
                        AND    DIVISION_ID = '40'
                        AND    YYYYMMDD >= N_MIN_YYYYMMDD  /* 추출된 데이터의 MIN ~ MAX의 구간 */
                        AND    YYYYMMDD <= N_MAX_YYYYMMDD;  /* 추출된 데이터의 MIN ~ MAX의 구간 */
                END IF;
            END;
            /* PRINT('8_0.DM_PLN_MKT_FCST 테이블 insert =================== END ============================') */
            /* SELECT * FROM DM_PLN_MKT_FCST WHERE MEASURE = 'CUST_FCST' AND LAST_UPDATED_BY = 'chano0612' */
            /*-------------------- DM_PLN_MKT_FCST 테이블 MERGE  --------------------*/
            /* PRINT('8.DM_PLN_MKT_FCST 테이블 MERGE') */

            DELETE FROM DM_PLN_MKT_FCST
            WHERE  (SELECT COUNT(1)
                    FROM   GT_DPCF_TEMP2_DM_PLN_CUSTOMER B
                    WHERE  DM_PLN_MKT_FCST.DIVISION_ID = B.DIVISION_ID
                    AND    DM_PLN_MKT_FCST.SCM_SITE_ID = B.SCM_SITE_ID
                          /* and  DM_PLN_MKT_FCST.PROJECT_CODE       =  B.PROJECT_CODE */
                    AND    DM_PLN_MKT_FCST.ITEM_ID = B.ITEM_ID
                    AND    DM_PLN_MKT_FCST.DOM_EXP = B.DOM_EXP
                    AND    DM_PLN_MKT_FCST.FCST_TYPE = B.FCST_TYPE
                    AND    DM_PLN_MKT_FCST.INCOTERMS = B.INCOTERMS
                    AND    DM_PLN_MKT_FCST.PLANT_SITE_ID = B.PLANT_SITE_ID
                          /* AND B.BATCH_RESULT = 'SPLIT_COMPLETED' -- modified by ytchoi 180305 */
                    AND    DM_PLN_MKT_FCST.MEASURE = 'CUST_FCST'
                          /* (20230912 : CUST_FCST MEASURE 삭제시 당주(월) 이전 데이터는 삭제 안되도록 수정) */
                    AND    DM_PLN_MKT_FCST.YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7), 'YYYYMMDD')) > 0;

            /* PRINT('8_1.DM_PLN_MKT_FCST INSERT') */
            INSERT INTO DM_PLN_MKT_FCST
                (DIVISION_ID
                ,PROJECT_CODE
                ,SCM_SITE_ID
                ,ITEM_ID
                ,DOM_EXP
                ,FCST_TYPE
                ,INCOTERMS
                ,MEASURE
                ,PLANT_SITE_ID
                ,YYYYMMDD
                ,QTY
                ,CREATED_BY
                ,CREATION_DATE
                ,LAST_UPDATED_BY
                ,LAST_UPDATE_DATE
                ,ATTRIBUTE1
                ,ATTRIBUTE2
                ,ATTRIBUTE3
                ,ATTRIBUTE4
                ,ATTRIBUTE5
                ,ATTRIBUTE6
                ,ATTRIBUTE7
                ,ATTRIBUTE8
                ,ATTRIBUTE9
                ,ATTRIBUTE10)
                SELECT A.DIVISION_ID
                      ,A.PROJECT_CODE
                      ,A.SCM_SITE_ID
                      ,A.ITEM_ID
                      ,A.DOM_EXP
                      ,A.FCST_TYPE
                      ,A.INCOTERMS
                      ,'CUST_FCST'
                      ,A.PLANT_SITE_ID
                      ,A.YYYYMMDD
                      ,A.QTY
                      ,A.CREATED_BY
                      ,A.CREATION_DATE
                      ,A.LAST_UPDATED_BY
                      ,A.LAST_UPDATE_DATE
                      ,A.ATTRIBUTE1
                      ,A.ATTRIBUTE2
                      ,A.ATTRIBUTE3
                      ,A.ATTRIBUTE4
                      ,A.ATTRIBUTE5
                      ,A.ATTRIBUTE6
                      ,A.ATTRIBUTE7
                      ,A.ATTRIBUTE8
                      ,A.ATTRIBUTE9
                      ,A.ATTRIBUTE10
                FROM   DM_PLN_MKT_FCST A
                INNER  JOIN (SELECT DISTINCT DIVISION_ID, SCM_SITE_ID, ITEM_ID, INCOTERMS, PLANT_SITE_ID, PROJECT_CODE, DOM_EXP, FCST_TYPE
                             FROM   GT_DPCF_TEMP2_DM_PLN_CUSTOMER V) RSLT
                ON     (A.DIVISION_ID = RSLT.DIVISION_ID AND A.SCM_SITE_ID = RSLT.SCM_SITE_ID
                       /* and a.MEASURE       = rslt.MEASURE */
                       AND A.ITEM_ID = RSLT.ITEM_ID AND A.INCOTERMS = RSLT.INCOTERMS AND A.PLANT_SITE_ID = RSLT.PLANT_SITE_ID
                       /* and a.PROJECT_CODE   = rslt.PROJECT_CODE */
                       AND A.DOM_EXP = RSLT.DOM_EXP AND A.FCST_TYPE = RSLT.FCST_TYPE
                       /* and a.yyyymmdd      = rslt.v_yyyymmdd */
                       )
                INNER  JOIN (SELECT DIVISION_ID, SCM_SITE_ID, MEASURE, START_DAY, END_DAY FROM GT_DPCF_TMP_SITE_CUSTOMER_MAP) MAP

                ON     (A.DIVISION_ID = MAP.DIVISION_ID AND A.SCM_SITE_ID = MAP.SCM_SITE_ID AND A.MEASURE = MAP.MEASURE)
                WHERE  1 = 1
                AND    A.YYYYMMDD BETWEEN MAP.START_DAY AND MAP.END_DAY
                AND    A.YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7), 'YYYYMMDD');

            BEGIN
                /* [변환주의] MSSQL: #TEMP2(GT_DPCF_TEMP2)에서 BATCH_RESULT='SPLIT_COMPLETED' COUNT 누적. */

                SELECT N_FCST_INSERT_COUNT + COUNT(*)
                INTO   N_FCST_INSERT_COUNT
                FROM   GT_DPCF_TEMP2_DM_PLN_CUSTOMER
                WHERE  1 = 1
                AND    BATCH_RESULT = 'SPLIT_COMPLETED';
            END;

            /* GROUP 로딩 COUNT 증가 */
            BEGIN
                N_PSI_GROUP_INSERT := N_PSI_GROUP_INSERT + 1;
            END;

            /* GROUP별로 작업종료후 Temp Table TRUNCATE */
            IF N_PSI_GROUP_INSERT <= N_PSI_GROUP_CNT THEN

                /* GROUP별로 작업종료후 Temp Table TRUNCATE */
                DELETE FROM GT_DPCF_TEMP2_DM_PLN_CUSTOMER; /* 원본 TRUNCATE→GTT는 DELETE(단일TX 원자성 보존·Oracle TRUNCATE 암묵COMMIT 회피) */
                DELETE FROM GT_DPCF_TEMP3_DM_PLN_CUSTOMER; /* 원본 TRUNCATE→GTT는 DELETE(단일TX 원자성 보존·Oracle TRUNCATE 암묵COMMIT 회피) */
            END IF;


        END LOOP;

        /* ------------------------------------------------------------------------------------------------------------- PSI GROUP LOOP END */
        /* ############################################################################################################# */
        /* ------------------------------------------------------------------------------------------------------------- PSI GROUP LOOP END */

    END IF;

    /* 종료 LOG */
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := 'psi_update_count= ' || TO_CHAR(N_PSI_UPDATE_COUNT) || ' / psi_delete_count= ' || TO_CHAR(N_PSI_DELETE_COUNT) || ' / psi_insert_count= ' ||
                     TO_CHAR(N_PSI_INSERT_COUNT) || ' / fcst_delete_count= ' || TO_CHAR(N_FCST_DELETE_COUNT) || ' / fcst_insert_count= ' ||
                     TO_CHAR(N_FCST_INSERT_COUNT);
    /* || ' */
    D_EVENT_DATE := SYSTIMESTAMP;

    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);


    /* [원자성] MSSQL 원본의 COMMIT 은 상위 BEGIN TRAN 내부 실행이라 @@TRANCOUNT 감소일 뿐 실커밋이 아니었다. */
    /* END */


    /* ----------------------------------------------------------- */
EXCEPTION
    WHEN OTHERS THEN
        /* ----------------------------------------------------------- */
        /* 트랜잭션 (END) */

        ROLLBACK;
        /* ERROR LOG VALUE SAVE */
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := SUBSTR(SQLERRM, 1, 1000);
        V_DESCRIPTION := 'ERROR_LINE : ' || TO_CHAR(NULL);
        D_EVENT_DATE  := SYSTIMESTAMP;
        /* SELECT '[' || TO_CHAR(SQLCODE) || ']' || SQLERRM;  / *-- 에러메시지 DISPLAY --* / */
        V_DESCRIPTION := '[' || TO_CHAR(SQLCODE) || ']' || SQLERRM; /*-- 에러로그 --*/
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);


        /* ----------------------------------------------------------- */

        /* ----------------------------------------------------------- */
        /* 임시테이블 삭제 ------------------------------------------------------------- (start) */
        /* 임시테이블 삭제 ------------------------------------------------------------- (END) */


        V_LOG_TYPE    := 'END';
        V_LOG_MESSAGE := '########## END of procedure ##########';
        V_DESCRIPTION := 'psi_update_count= ' || TO_CHAR(N_PSI_UPDATE_COUNT) || ' / psi_delete_count= ' || TO_CHAR(N_PSI_DELETE_COUNT) || ' / psi_insert_count= ' ||
                         TO_CHAR(N_PSI_INSERT_COUNT) || ' / fcst_delete_count= ' || TO_CHAR(N_FCST_DELETE_COUNT) || ' / fcst_insert_count= ' ||
                         TO_CHAR(N_FCST_INSERT_COUNT);
        D_EVENT_DATE  := SYSTIMESTAMP;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        /* 수행결과 성공여부 DISPLAY */
        /* IF v_log_message IS NULL */
        /* SELECT 'success' ; */


        <<ERR_RTN>>

        NULL;

END;
/
