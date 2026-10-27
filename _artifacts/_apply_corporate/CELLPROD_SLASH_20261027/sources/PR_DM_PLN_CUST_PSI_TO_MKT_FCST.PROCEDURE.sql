PROCEDURE PR_DM_PLN_CUST_PSI_TO_MKT_FCST

    /* 데이터 확인이 필요할 경우 '--확인' 을 '--확인' 으로 변경하면 DEBUG 모드이고 */
    /* '--확인' 을 '--확인' 으로 변경하면 일반 모드임 */
    /*
    ● PR_DM_PLN_CUST_PSI_TO_MKT_FCST 로직 구조
    -- --------------------------------------------------------
    LOOP_1 (n_PSI_GROUP_CNT : MEASURE별 INPUT된 ROWS만큼 처리)
    -- --------------------------------------------------------
        -- ------------------------------------------------------
        LOOP_1 (CUR_PSI_RESULT : 커서 로딩처리)
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
                    LOOP_4 (n_bucketcount : BUCKET수량만큼 ROWS 증가 처리)
                    -- -----------------------------------------------------
                        - DM_PLN_MKT_FCST 테이블에 INSERT
                    -- -----------------------------------------------------
                    LOOP_4_END (n_bucketcount : BUCKET수량만큼 ROWS 증가 처리)
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
     * Program ID   : PR_DM_PLN_CUST_PSI_TO_MKT_FCST
     * Description  : MKT FCST - PSI Production Result Mapping
     * Program History
     *===================================================================================================
     *   Date       In Charge      Description
     *===================================================================================================
     * 2018. 02. 08    KHSONG      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
     * 2025. 06. 23    KANG.H.J    [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
     * 2026.07.23   ZIONEX        [PJ202650304] NextSCM Migration
     *================================================================================================= */
 AS

    V_PROGRAM_NAME             VARCHAR2(200 CHAR) := $$PLSQL_UNIT;
    V_IN_PARA_DATA             VARCHAR2(4000 CHAR);
    V_LOG_TYPE                 VARCHAR2(30 CHAR);
    N_LOG_COUNT                INTEGER := 0;
    V_LOG_MESSAGE              VARCHAR2(1000 CHAR);
    V_DESCRIPTION              VARCHAR2(500 CHAR);
    D_EVENT_DATE               DATE;
    /* cursor 별 로딩할 변수설정 */
    V_DIVISION_ID              VARCHAR2(4000 CHAR);
    V_CUSTOMER_PROJECT_CODE    VARCHAR2(4000 CHAR);
    V_CUSTOMER_MODEL           VARCHAR2(4000 CHAR);
    V_SCM_SITE_ID              VARCHAR2(4000 CHAR);
    V_DOM_EXP                  VARCHAR2(4000 CHAR);
    V_FCST_TYPE                VARCHAR2(4000 CHAR);
    V_MEASURE_GROUP            VARCHAR2(4000 CHAR);
    V_MEASURE                  VARCHAR2(4000 CHAR);
    V_YYYYMMDD                 VARCHAR2(4000 CHAR);
    V_INCOTERMS                VARCHAR2(4000 CHAR);
    V_PLANT_SITE_ID            VARCHAR2(4000 CHAR);
    V_PROJECT_CODE             VARCHAR2(4000 CHAR);
    V_ITEM_ID                  VARCHAR2(4000 CHAR);
    V_QTY                      NUMBER(20, 10);
    V_UPLOAD_UOM               VARCHAR2(4000 CHAR);
    V_CREATED_BY               VARCHAR2(4000 CHAR);
    V_CREATION_DATE            DATE;
    V_LAST_UPDATED_BY          VARCHAR2(4000 CHAR);
    V_LAST_UPDATE_DATE         DATE;
    V_BATCH_RESULT             VARCHAR2(4000 CHAR);
    V_MST_UPLOAD_UOM           VARCHAR2(4000 CHAR);
    V_MST_UPLOAD_BUCKET_TYPE   VARCHAR2(4000 CHAR);
    V_MST_SUMMARY_BUCKET_TYPE  VARCHAR2(4000 CHAR);
    V_MST_CONVERT_QTY          VARCHAR2(4000 CHAR);
    V_PLAN_WEEK                VARCHAR2(4000 CHAR);
    V_SPLIT_RESULT             VARCHAR2(4000 CHAR);
    V_ATTRIBUTE1               VARCHAR2(4000 CHAR);
    V_ATTRIBUTE2               VARCHAR2(4000 CHAR);
    V_ATTRIBUTE3               VARCHAR2(4000 CHAR);
    V_ATTRIBUTE4               VARCHAR2(4000 CHAR);
    V_ATTRIBUTE5               VARCHAR2(4000 CHAR);
    V_ATTRIBUTE6               VARCHAR2(4000 CHAR);
    V_ATTRIBUTE7               VARCHAR2(4000 CHAR);
    V_ATTRIBUTE8               VARCHAR2(4000 CHAR);
    V_ATTRIBUTE9               VARCHAR2(4000 CHAR);
    V_ATTRIBUTE10              VARCHAR2(4000 CHAR);
    /* 변수 설정 */
    V_DAY_VALID                VARCHAR2(8 CHAR);
    V_START_WEEK               VARCHAR2(8 CHAR);
    N_BATCH_RESULT             VARCHAR2(4000 CHAR);
    N_PSI_UPDATE_COUNT         INTEGER := 0;
    N_PSI_DELETE_COUNT         INTEGER := 0;
    N_PSI_INSERT_COUNT         INTEGER := 0;
    N_FCST_RSLT_DELETE_COUNT   INTEGER := 0;
    N_FCST_RSLT_INSERT_COUNT   INTEGER := 0;
    N_FCST_DELETE_COUNT        INTEGER := 0;
    N_FCST_INSERT_COUNT        INTEGER := 0;
    N_BUCKETCOUNT              INTEGER := 0;
    N_BUCKETINSERT             INTEGER := 1;
    N_PSI_GROUP_INSERT         INTEGER := 1;
    N_PSI_GROUP_CNT            INTEGER := 0;
    N_PLAN_WEEK                VARCHAR2(4000 CHAR);
    N_VALID_BUCKET_TYPE        VARCHAR2(4000 CHAR);
    N_UPLOAD_BUCKET_TYPE       VARCHAR2(4000 CHAR);
    N_SUMMARY_BUCKET_TYPE      VARCHAR2(4000 CHAR);
    N_CUSTOMER_PSI_VALUE       VARCHAR2(4000 CHAR);
    N_UPLOAD_UOM               VARCHAR2(4000 CHAR);
    N_UPLOAD_UOM_KEY           VARCHAR2(4000 CHAR);
    N_ITEM_CLASS_NAME          VARCHAR2(4000 CHAR);
    N_PROJECT_CODE             VARCHAR2(4000 CHAR);
    N_ITEM_ID                  VARCHAR2(4000 CHAR);
    N_CONVERT_QTY_PACK         NUMBER(20, 10);
    N_CONVERT_QTY_MODULE       NUMBER(20, 10);
    N_CONVERT_QTY_CELL         NUMBER(20, 10);
    N_CONVERT_QTY              NUMBER(20, 10);
    N_CALC_QTY                 NUMBER(20, 1);
    N_ADD_QTY                  NUMBER(20, 1);
    N_RESULT_START_DATE        VARCHAR2(4000 CHAR); /* DM_PLN_MKT_FCST_RESULT 테이블에 적용할 데이터의 시작일자 */
    N_RESULT_END_DATE          VARCHAR2(4000 CHAR); /* DM_PLN_MKT_FCST_RESULT 테이블에 적용할 데이터의 종료일자 */
    N_FCST_START_DATE          VARCHAR2(4000 CHAR); /* DM_PLN_MKT_FCST 테이블에 적용할 데이터의 시작일자 */
    N_FCST_END_DATE            VARCHAR2(4000 CHAR); /* DM_PLN_MKT_FCST 테이블에 적용할 데이터의 종료일자 */
    CUR_PSI_RESULT             SYS_REFCURSOR;
    V_FETCH_STATUS             INTEGER := 0;
BEGIN

    /* [변환주의] MSSQL SET TRANSACTION ISOLATION LEVEL / SET NOCOUNT / SET XACT_ABORT ON -> Oracle 미해당(XACT_ABORT=예외시 ROLLBACK 로 대응) */
    V_IN_PARA_DATA := NULL;

    /* 시작 LOG  (START) */
    V_LOG_TYPE := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := NULL;
    D_EVENT_DATE := SYSTIMESTAMP;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
    V_LOG_MESSAGE := NULL; /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
    /* 시작 LOG  (END) */

    /* [변환주의] MSSQL SYS.SYSCURSORS 방어(CLOSE/DEALLOCATE CUR_PSI_RESULT) -> Oracle 명시커서 미해당, 주석화 */
    /* IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WHERE CURSOR_NAME='CUR_PSI_RESULT') CLOSE/DEALLOCATE ... */

    /* 트랜잭션 (START) : MSSQL BEGIN TRANSACTION PR_DM_PLN_CUST_PSI_TO_MKT_FCST -> Oracle 암시적 트랜잭션 */
    BEGIN

        /* MSSQL: #TEMP_DM_PLN_CUSTOMER_PSI$ DROP -> GTT DELETE 후 적재 */
        BEGIN
            DELETE FROM GT_DPCP_PSI;

            INSERT
            INTO GT_DPCP_PSI
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
                   AND MEASURE_GROUP = 'PSI' /* PSI 데이터만 처리 */ /* AND QTY > 0  -- QTY값이 0인것도 기존데이터 초기화를 위해서 필요함 */
                 ORDER BY DIVISION_ID
                        , SCM_SITE_ID
                        , YYYYMMDD;
        END;
        /* ---------------------------------------------------------------------------------------------------------- 대상자료 저장 END */

        /* DM_PLN_CUSTOMER_PSI 대상 데이터의 GROUP별 COUNT ------------------------------------------------------------------------------- START */
        BEGIN
            DELETE FROM GT_DPCP_PSI_GROUP_COUNT;

            INSERT
            INTO GT_DPCP_PSI_GROUP_COUNT
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
                  FROM GT_DPCP_PSI
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

            SELECT MAX(PSI_ROWNUM)
              INTO N_PSI_GROUP_CNT
              FROM GT_DPCP_PSI_GROUP_COUNT;
        END;
        /* DM_PLN_CUSTOMER_PSI 대상 데이터의 GROUP별 COUNT ------------------------------------------------------------------------------- END */

        /* ------------------------------------------------------------------------------------------------------------- PSI GROUP LOOP START */
        WHILE N_PSI_GROUP_INSERT <= N_PSI_GROUP_CNT LOOP

            /* (임시테이블 존재여부 확인후 생성) START ---------------------------- */
            /* (0) MSSQL: #TEMP4/#TEMP3/#TEMP2 DROP + SELECT(division_id='x') + TRUNCATE -> GTT DELETE(빈 구조) */
            BEGIN
                DELETE FROM GT_DPCP_MKT_FCST;
                DELETE FROM GT_DPCP_T3;
                DELETE FROM GT_DPCP_T2;
            END;
            /* (임시테이블 존재여부 확인후 생성) END ---------------------------- */

            /* Cursor 데이터 로딩 ----------------------------------------------------------------------------------------------- START */
            BEGIN
                /* MSSQL: DECLARE CUR_PSI_RESULT CURSOR FAST_FORWARD FOR ... */
                OPEN CUR_PSI_RESULT FOR
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
                      FROM GT_DPCP_PSI A
                     WHERE 1 = 1
                       AND EXISTS (SELECT 1
                                     FROM GT_DPCP_PSI_GROUP_COUNT B
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

            BEGIN
                FETCH CUR_PSI_RESULT
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
                IF CUR_PSI_RESULT%NOTFOUND THEN
                    V_FETCH_STATUS := -1;
                ELSE
                    V_FETCH_STATUS := 0;
                END IF;
            END;

            /* (WHILE START) ---------------------------------------------------------------------------------------------------------------- */
            WHILE V_FETCH_STATUS = 0 LOOP

                /* MEASURE별 LOOP수행시 사용된 변수 초기화 START */
                BEGIN
                    V_START_WEEK := NULL;
                    N_UPLOAD_BUCKET_TYPE := NULL;
                    N_SUMMARY_BUCKET_TYPE := NULL;
                    N_CUSTOMER_PSI_VALUE := NULL;
                    N_PLAN_WEEK := NULL;
                    N_UPLOAD_UOM := NULL;
                    N_ITEM_CLASS_NAME := NULL;
                    N_PROJECT_CODE := NULL;
                    N_ITEM_ID := NULL;
                    N_CONVERT_QTY_PACK := 0;
                    N_CONVERT_QTY_MODULE := 0;
                    N_CONVERT_QTY_CELL := 0;
                    N_CONVERT_QTY := 0;
                END;
                /* MEASURE별 LOOP수행시 사용된 변수 초기화 END */

                /* 마스터에 설정된 MEASURE별 BUCKET_TYPE 추출 (F03) */
                IF N_UPLOAD_BUCKET_TYPE IS NULL THEN
                    BEGIN
                        SELECT UPLOAD_BUCKET_TYPE
                             /* , SUMMARY_BUCKET_TYPE */
                             , CUSTOMER_PSI
                             , MAX(PLAN_WEEK) /* PLAN_WEEK MAX 구하기 */
                          INTO N_UPLOAD_BUCKET_TYPE
                             , N_CUSTOMER_PSI_VALUE
                             , N_PLAN_WEEK
                          FROM DM_MST_CUSTOMER_FCST
                         WHERE 1 = 1
                           AND DIVISION_ID = V_DIVISION_ID
                           AND SCM_SITE_ID = V_SCM_SITE_ID
                           AND MEASURE_GROUP = V_MEASURE_GROUP
                           AND MEASURE = V_MEASURE
                           AND VALID_YN = 'Y'
                           AND PLAN_WEEK = (SELECT MAX(PLAN_WEEK)
                                              FROM DM_MST_CUSTOMER_FCST
                                             WHERE DIVISION_ID = V_DIVISION_ID
                                               AND SCM_SITE_ID = V_SCM_SITE_ID
                                               AND MEASURE_GROUP = V_MEASURE_GROUP
                                               AND MEASURE = V_MEASURE
                                               AND VALID_YN = 'Y'
                                           )
                          GROUP BY UPLOAD_BUCKET_TYPE
                                 , CUSTOMER_PSI
                                 , PLAN_WEEK;
                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN /* [변환주의] MSSQL SELECT @x=... 0행이면 변수 초기값(NULL) 유지·계속 */
                            NULL;
                    END;
                END IF;

                IF N_UPLOAD_BUCKET_TYPE = 'MONTHLY' THEN
                    V_START_WEEK := V_YYYYMMDD;
                ELSE
                    V_START_WEEK := TO_CHAR(FN_NEXT_DAY(TO_DATE(V_YYYYMMDD, 'YYYYMMDD'), 'MON') + (-7), 'YYYYMMDD');
                END IF;

                /*---- PROJECT_CODE 정보 추출하여 저장 ----*/
                BEGIN
                    SELECT PROJECT_CODE
                      INTO N_PROJECT_CODE
                      FROM DM_MST_CUSTOMER_MODEL
                     WHERE 1 = 1
                       AND DIVISION_ID = V_DIVISION_ID
                       AND CUSTOMER_PROJECT_CODE = V_CUSTOMER_PROJECT_CODE
                       AND CUSTOMER_MODEL = V_CUSTOMER_MODEL
                       AND SCM_SITE_ID = V_SCM_SITE_ID
                      GROUP BY PROJECT_CODE;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        N_PROJECT_CODE := NULL;
                END;

                /* 20180228 추가 (S) */
                IF N_PROJECT_CODE IS NULL THEN
                    BEGIN
                        SELECT PROJECT_CODE
                          INTO N_PROJECT_CODE
                          FROM SCM_MST_SITE_ITEM
                         WHERE 1 = 1
                           AND DIVISION_ID = V_DIVISION_ID
                           AND PROJECT_CODE = V_CUSTOMER_PROJECT_CODE
                           AND ITEM_ID = V_CUSTOMER_MODEL
                           AND SCM_SITE_ID = V_SCM_SITE_ID
                          GROUP BY PROJECT_CODE;
                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                            N_PROJECT_CODE := NULL;
                    END;
                END IF;
                /* 20180228 추가 (E) */

                /*---- ITEM_ID 정보 추출하여 저장 ----*/
                BEGIN
                    SELECT ITEM_ID
                      INTO N_ITEM_ID
                      FROM DM_MST_CUSTOMER_MODEL
                     WHERE 1 = 1
                       AND DIVISION_ID = V_DIVISION_ID
                       AND CUSTOMER_PROJECT_CODE = V_CUSTOMER_PROJECT_CODE
                       AND CUSTOMER_MODEL = V_CUSTOMER_MODEL
                       AND SCM_SITE_ID = V_SCM_SITE_ID
                      GROUP BY ITEM_ID;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
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
                           AND PROJECT_CODE = V_CUSTOMER_PROJECT_CODE
                           AND ITEM_ID = V_CUSTOMER_MODEL
                           AND SCM_SITE_ID = V_SCM_SITE_ID
                          GROUP BY ITEM_ID;
                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                            N_ITEM_ID := NULL;
                    END;
                END IF;

                /* CODE값이 존재하지 않는경우 처리불가 (MSSQL x='' 는 Oracle IS NULL 로 흡수, CV-030) */
                IF N_PROJECT_CODE IS NULL OR N_ITEM_ID IS NULL THEN
                    V_LOG_TYPE := 'INVALID';
                    V_LOG_MESSAGE := 'Project_code OR Item_ID 가 존재하지 않습니다.';
                    /* MSSQL: SELECT @v_log_message (디버그 결과셋) -> 주석화 */
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
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        N_ITEM_CLASS_NAME := NULL;
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
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        N_CONVERT_QTY_PACK := 1;
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
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        N_CONVERT_QTY_MODULE := 1;
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
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        N_CONVERT_QTY_CELL := 1;
                END;

                V_UPLOAD_UOM := UPPER(V_UPLOAD_UOM); /* 소문자 변환후 사용 */

                /*---- Convert Qty 구하기 START ----*/
                BEGIN
                    N_CONVERT_QTY := CASE
                                         WHEN (V_UPLOAD_UOM = 'CAR') THEN
                                          CASE
                                              WHEN N_UPLOAD_UOM = 'CAR ' THEN
                                               V_QTY * N_CONVERT_QTY_PACK
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
                                               V_QTY * N_CONVERT_QTY_PACK * N_CONVERT_QTY_MODULE
                                              WHEN N_UPLOAD_UOM = 'CELL' THEN
                                               V_QTY * N_CONVERT_QTY_PACK * N_CONVERT_QTY_MODULE * N_CONVERT_QTY_CELL
                                          END
                                         WHEN (V_UPLOAD_UOM = 'MODULE') THEN
                                          CASE
                                              WHEN N_UPLOAD_UOM = 'MODULE' THEN
                                               V_QTY * N_CONVERT_QTY_MODULE
                                              WHEN N_UPLOAD_UOM = 'CELL' THEN
                                               V_QTY * N_CONVERT_QTY_PACK * N_CONVERT_QTY_MODULE * N_CONVERT_QTY_CELL
                                          END
                                         WHEN (V_UPLOAD_UOM = 'CELL') THEN
                                          CASE
                                              WHEN N_UPLOAD_UOM = 'CELL' THEN
                                               V_QTY * N_CONVERT_QTY_CELL
                                          END
                                     END;
                END;

                /* DM_MST_CUSTOMER_MODEL에 설정안된 measure 는 초기화해줌 20180301추가 */
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

                /* 캘린더 임시테이블 생성 : MSSQL DROP + SELECT(END_FLAG='x' 0행) + TRUNCATE -> GTT DELETE */
                DELETE FROM GT_DPCP_CALENDAR;

                /* DM_MST_CUSTOMER_FCST.CUSTOMER_PSI 값이 'I' 인경우는 SPLIT하지않는다. */
                IF N_CUSTOMER_PSI_VALUE = 'I' THEN
                    INSERT
                    INTO GT_DPCP_CALENDAR
                        (BASIS_YYYYMMDD, ROW_NO)
                    VALUES
                        (V_YYYYMMDD, 1);
                    N_BUCKETCOUNT := 1;
                END IF;

                /* BUCKET_TYPE별 MST_BUCKET_CONVERSION 설정날짜로 SPLIT (START) */
                BEGIN
                    /* ------------------------------------------------------------------------------------------------- */
                    IF N_UPLOAD_BUCKET_TYPE = 'MONTHLY' AND N_CUSTOMER_PSI_VALUE = 'S' THEN
                    /* ------------------------------------------------------------------------------------------------- */
                        BEGIN
                            INSERT
                            INTO GT_DPCP_CALENDAR
                                (BASIS_YYYYMMDD, ROW_NO)
                                SELECT B.BASIS_YYYYMMDD
                                     , ROW_NUMBER() OVER (ORDER BY B.BASIS_YYYYMMDD) RN
                                  FROM DM_MST_BUCKET_CONVERSION A
                                     , SCM_SYS_CALENDAR_M B
                                     , SCM_SYS_CALENDAR_M C
                                 WHERE A.DIVISION_ID = V_DIVISION_ID
                                   AND A.SCM_SITE_ID = V_SCM_SITE_ID
                                   AND A.INCOTERMS = V_INCOTERMS
                                   AND A.YYYYMMDD = B.DAYOFWEEK
                                   AND B.CALENDAR_YYYY = C.CALENDAR_YYYY
                                   AND B.CALENDAR_MONTH = C.CALENDAR_MONTH
                                   AND C.BASIS_YYYYMMDD = V_START_WEEK; /* 해당 주차 */

                            SELECT MAX(ROW_NO)
                              INTO N_BUCKETCOUNT
                              FROM GT_DPCP_CALENDAR;

                            /* -------------------------------------------------- MST_BUCKET 이 설정안된 경우도 처리되도록 20180301 추가 (START) */
                            IF N_BUCKETCOUNT IS NULL OR N_BUCKETCOUNT = 0 THEN
                                BEGIN
                                    DELETE FROM GT_DPCP_RESULTS;

                                    INSERT
                                    INTO GT_DPCP_RESULTS
                                        (YYYYMMDD, DAYOFWEEK)
                                        SELECT BASIS_YYYYMMDD
                                             , DAYOFWEEK
                                          FROM SCM_SYS_CALENDAR_M
                                         WHERE BASIS_YYYYMM = SUBSTR(V_START_WEEK, 1, 6) /* 매월 1일 날짜로 해당월의 모든 날짜 선택 */
                                           /* AND DAYOFWEEK IN ('MON','TUE','WED','THU','FRI') ORDER BY BASIS_YYYYMMDD   -- 20180424 skh modify */
                                           AND DAYOFWEEK IN (SELECT SEGMENT3
                                                               FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                                                              WHERE 1 = 1
                                                                AND SEGMENT1 = V_DIVISION_ID
                                                                AND LOOKUP_TYPE = 'DEFAULT_BUCKET_DAY'
                                                                AND SEGMENT2 = N_UPLOAD_BUCKET_TYPE
                                                            ) /* 20180424 skh 조건변경 */
                                          ORDER BY BASIS_YYYYMMDD;

                                    INSERT
                                    INTO GT_DPCP_CALENDAR
                                        (BASIS_YYYYMMDD, ROW_NO)
                                        SELECT B.BASIS_YYYYMMDD
                                             , ROW_NUMBER() OVER (ORDER BY B.BASIS_YYYYMMDD) RN
                                          FROM GT_DPCP_RESULTS A
                                             , SCM_SYS_CALENDAR_M B
                                         WHERE A.DAYOFWEEK = B.DAYOFWEEK
                                           AND A.YYYYMMDD = B.BASIS_YYYYMMDD;

                                    SELECT MAX(ROW_NO)
                                      INTO N_BUCKETCOUNT
                                      FROM GT_DPCP_CALENDAR;
                                END;
                            END IF;
                            /* -------------------------------------------------- MST_BUCKET 이 설정안된 경우도 처리되도록 20180301 추가 (END) */
                        END;
                        /* ------------------------------------------------------------------------------------------------- */
                    ELSIF N_UPLOAD_BUCKET_TYPE = 'WEEKLY' AND N_CUSTOMER_PSI_VALUE = 'S' THEN
                    /* ------------------------------------------------------------------------------------------------- */
                        BEGIN
                            INSERT
                            INTO GT_DPCP_CALENDAR
                                (BASIS_YYYYMMDD, ROW_NO)
                                SELECT B.BASIS_YYYYMMDD
                                     , ROW_NUMBER() OVER (ORDER BY B.BASIS_YYYYMMDD) RN
                                  FROM DM_MST_BUCKET_CONVERSION A
                                     , SCM_SYS_CALENDAR_M B
                                     , SCM_SYS_CALENDAR_M C
                                 WHERE A.DIVISION_ID = V_DIVISION_ID
                                   AND A.SCM_SITE_ID = V_SCM_SITE_ID
                                   AND A.INCOTERMS = V_INCOTERMS
                                   AND A.YYYYMMDD = B.DAYOFWEEK
                                   AND B.ISO_YYYYWW = C.ISO_YYYYWW
                                   AND C.BASIS_YYYYMMDD = V_START_WEEK; /* 해당 주차 */
                            /* bucketcount 산출 */
                            SELECT MAX(ROW_NO)
                              INTO N_BUCKETCOUNT
                              FROM GT_DPCP_CALENDAR;

                            /* -------------------------------------------------- MST_BUCKET 이 설정안된 경우도 처리되도록 20180301 추가 (START) */
                            IF N_BUCKETCOUNT IS NULL OR N_BUCKETCOUNT = 0 THEN
                                BEGIN
                                    DELETE FROM GT_DPCP_RESULTS;

                                    /* 날짜선택오류로 ISO_WEEK 조건추가 20180402 (SONGKH) */
                                    INSERT
                                    INTO GT_DPCP_RESULTS
                                        (YYYYMMDD, DAYOFWEEK)
                                        SELECT BASIS_YYYYMMDD
                                             , DAYOFWEEK
                                          FROM SCM_SYS_CALENDAR_M Z
                                             , (SELECT DISTINCT ISO_WEEK
                                                     , ISO_YYYYWW
                                                  FROM SCM_SYS_CALENDAR_M W
                                                 WHERE BASIS_START_DATE = V_START_WEEK
                                               ) K /* 매주 월요일 날짜로 해당주의 날짜 선택 */
                                         WHERE Z.ISO_WEEK = K.ISO_WEEK
                                           AND Z.ISO_YYYYWW = K.ISO_YYYYWW
                                           /* AND DAYOFWEEK IN ('MON','TUE','WED','THU','FRI') ORDER BY BASIS_YYYYMMDD   -- 20180424 skh modify */
                                           AND DAYOFWEEK IN (SELECT SEGMENT3
                                                               FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                                                              WHERE 1 = 1
                                                                AND SEGMENT1 = V_DIVISION_ID
                                                                AND LOOKUP_TYPE = 'DEFAULT_BUCKET_DAY'
                                                                AND SEGMENT2 = N_UPLOAD_BUCKET_TYPE
                                                            ) /* 20180424 skh 조건변경 */
                                          ORDER BY BASIS_YYYYMMDD;
                                    /* 날짜선택오류로 ISO_WEEK 조건추가 20180402 (SONGKH) */

                                    INSERT
                                    INTO GT_DPCP_CALENDAR
                                        (BASIS_YYYYMMDD, ROW_NO)
                                        SELECT B.BASIS_YYYYMMDD
                                             , ROW_NUMBER() OVER (ORDER BY B.BASIS_YYYYMMDD) RN
                                          FROM GT_DPCP_RESULTS A
                                             , SCM_SYS_CALENDAR_M B
                                         WHERE A.DAYOFWEEK = B.DAYOFWEEK
                                           AND A.YYYYMMDD = B.BASIS_YYYYMMDD;
                                    SELECT MAX(ROW_NO)
                                      INTO N_BUCKETCOUNT
                                      FROM GT_DPCP_CALENDAR;
                                END;
                            END IF;
                            /* -------------------------------------------------- MST_BUCKET 이 설정안된 경우도 처리되도록 20180301 추가 (END) */
                        END;
                        /* ------------------------------------------------------------------------------------------------- */
                    ELSE
                        /* ------------------------------------------------------------------------------------------------- */
                        IF N_UPLOAD_BUCKET_TYPE = 'DAILY' AND N_CUSTOMER_PSI_VALUE = 'S' THEN
                            INSERT
                            INTO GT_DPCP_CALENDAR
                                (BASIS_YYYYMMDD, ROW_NO)
                            VALUES
                                (V_YYYYMMDD, 1);
                            N_BUCKETCOUNT := 1;
                        END IF;
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

                    /* Convert QTY값 산출 */
                    IF N_UPLOAD_BUCKET_TYPE = 'DAILY' THEN
                        N_CALC_QTY := N_CONVERT_QTY - N_ADD_QTY; /* DAILY 인경우는 SPLIT 은 필요없지만 변환된 QTY값을 그대로 사용함 */
                    ELSIF N_BUCKETINSERT < N_BUCKETCOUNT THEN /* 마지막데이터가 아닌경우 SPLIT된값을 넣어줌 */
                        N_CALC_QTY := TRUNC(N_CONVERT_QTY / N_BUCKETCOUNT, 0);
                        N_ADD_QTY := N_ADD_QTY + N_CALC_QTY;
                    ELSE
                        /* 마지막 데이터인경우 나머지값을 몰아주기 */
                        N_CALC_QTY := N_CONVERT_QTY - N_ADD_QTY;
                    END IF;

                    BEGIN
                        /* insert into DM_PLN_CUSTOMER_PSI (원본은 #TEMP3 로 적재) */
                        INSERT
                        INTO GT_DPCP_T3
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
                                 , V_MEASURE_GROUP
                                 , V_MEASURE || '_new_temp'
                                 , (SELECT BASIS_YYYYMMDD FROM GT_DPCP_CALENDAR WHERE ROW_NO = N_BUCKETINSERT)
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
                                 , 'SPLIT_COMPLETED' /* 7777 */
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
                        N_BATCH_RESULT := 'SPLIT_COMPLETED';
                    END;

                    /* 재고(I) 인경우 2개의 MEASURE 추가생성 --------------------------------------------------------------------------------------------------- start */
                    IF N_CUSTOMER_PSI_VALUE = 'I' THEN
                        INSERT
                        INTO GT_DPCP_T3
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
                                 , V_MEASURE_GROUP
                                 , 'CUST_INV_I' /* @v_MEASURE + '_new_temp' */
                                 , (SELECT BASIS_YYYYMMDD FROM GT_DPCP_CALENDAR WHERE ROW_NO = N_BUCKETINSERT)
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
                                 , 'UPLOAD_COMPLETED' /* 7777 */
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

                        INSERT
                        INTO GT_DPCP_T3
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
                                 , V_MEASURE_GROUP
                                 , 'MKT_INV_I' /* @v_MEASURE + '_new_temp' */
                                 , (SELECT BASIS_YYYYMMDD FROM GT_DPCP_CALENDAR WHERE ROW_NO = N_BUCKETINSERT)
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
                                 , 'UPLOAD_COMPLETED' /* 7777 */
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
                    END IF;
                    /* 재고(I) 인경우 2개의 MEASURE 추가생성 --------------------------------------------------------------------------------------------------- end */

                    /* Customer Product (S) 인경우 2개의 MEASURE 추가생성 --------------------------------------------------------------------------------------------------- start */
                    IF N_CUSTOMER_PSI_VALUE = 'S' THEN
                        INSERT
                        INTO GT_DPCP_T3
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
                                 , V_MEASURE_GROUP
                                 , 'CUST_Product_S' /* @v_MEASURE + '_new_temp' */
                                 , (SELECT BASIS_YYYYMMDD FROM GT_DPCP_CALENDAR WHERE ROW_NO = N_BUCKETINSERT)
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
                                 , 'UPLOAD_COMPLETED' /* 7777 */
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

                        INSERT
                        INTO GT_DPCP_T3
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
                                 , V_MEASURE_GROUP
                                 , 'MKT_Product_S' /* @v_MEASURE + '_new_temp' */
                                 , (SELECT BASIS_YYYYMMDD FROM GT_DPCP_CALENDAR WHERE ROW_NO = N_BUCKETINSERT)
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
                                 , 'UPLOAD_COMPLETED' /* 7777 */
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
                    END IF;
                    /* Customer Product (S) 인경우 2개의 MEASURE 추가생성 --------------------------------------------------------------------------------------------------- end */

                    BEGIN
                        N_CALC_QTY := 0; /* 사용후 초기화 */
                    END;

                    BEGIN
                        N_BUCKETINSERT := N_BUCKETINSERT + 1; /* 최대 ROWS 까지 증가시킴 */
                    END;
                /*----------------------------------------------------------------------------------------------------------------*/
                END LOOP;
                /* ------------------------------------------------------------------------------------------------------------- bucket loop END */

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
                          , PROJECT_CODE          = N_PROJECT_CODE /* 추출된값으로 셋팅 */
                          , ITEM_ID               = N_ITEM_ID /* 추출된값으로 셋팅 */
                          , QTY                   = V_QTY /* CONVERT(INT, CAST(@v_qty AS NVARCHAR(10))) */
                          , UPLOAD_UOM            = V_UPLOAD_UOM /* INPUT값 UPLOAD_UOM */
                          , CREATED_BY            = V_CREATED_BY
                          , CREATION_DATE         = V_CREATION_DATE
                          , LAST_UPDATED_BY       = V_LAST_UPDATED_BY
                          , LAST_UPDATE_DATE      = SYSTIMESTAMP
                          , BATCH_RESULT          = N_BATCH_RESULT /* 1.'UI' 2.'UPLOAD_COMPLETED' 3.'UPLOAD_UOM_NOT_FOUND' 4.'BATCH' 1111 */
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
                    FETCH CUR_PSI_RESULT
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
                    IF CUR_PSI_RESULT%NOTFOUND THEN
                        V_FETCH_STATUS := -1;
                    ELSE
                        V_FETCH_STATUS := 0;
                    END IF;
                END;
                /* (1) */
            END LOOP;
            /* (WHILE END ) ---------------------------------------------------------------------------------------------------------------- */

            BEGIN
                CLOSE CUR_PSI_RESULT;
            EXCEPTION
                WHEN INVALID_CURSOR THEN
                    NULL;
            END;

            /* ---input 데이터의 시작과 끝 산출 ------------------------------------------------------------- (start) EEEE */
            /* MSSQL: #TEMP_MIN_MAX_PSI$ DROP + SELECT INTO -> GTT DELETE 후 적재(그룹루프 매회 신규) */
            DELETE FROM GT_DPCP_MIN_MAX;

            INSERT
            INTO GT_DPCP_MIN_MAX
                (YYYYMMDD, ROW_NO)
                SELECT YYYYMMDD
                     , ROW_NUMBER() OVER (ORDER BY YYYYMMDD) RN
                  FROM GT_DPCP_T3
                  GROUP BY YYYYMMDD
                  ORDER BY YYYYMMDD;

            /* ----------------------------------------------------------------------------------------------- */
            BEGIN
                N_FCST_START_DATE := TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7), 'YYYYMMDD'); /* DM_PLN_MKT_FCST 테이블에 적용할 데이터의 시작일자 */

                BEGIN
                    SELECT YYYYMMDD
                      INTO N_FCST_END_DATE
                      FROM GT_DPCP_MIN_MAX
                     WHERE ROW_NO = (SELECT MAX(ROW_NO)
                                       FROM GT_DPCP_MIN_MAX
                                    ); /* DM_PLN_MKT_FCST 테이블에 적용할 데이터의 종료일자 */
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        N_FCST_END_DATE := NULL;
                END;

                IF N_FCST_START_DATE > N_FCST_END_DATE THEN
                    N_FCST_START_DATE := N_FCST_END_DATE;
                END IF;

                BEGIN
                    SELECT YYYYMMDD
                      INTO N_RESULT_START_DATE
                      FROM GT_DPCP_MIN_MAX
                     WHERE ROW_NO = 1; /* DM_PLN_MKT_FCST_RESULT 테이블에 적용할 데이터의 시작일자 */
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        N_RESULT_START_DATE := NULL;
                END;
            END;
            /* -input 데이터의 시작과 끝 산출 ------------------------------------------------------------- (end) */

            /* (88) 데이터의 시작~끝 날짜 구하기 ---------------------------------------------- (start) */
            BEGIN
                IF N_UPLOAD_BUCKET_TYPE = 'DAILY' THEN
                    BEGIN
                        SELECT BASIS_YYYYMMDD
                          INTO N_FCST_END_DATE
                          FROM SCM_SYS_CALENDAR_M T
                         WHERE T.BASIS_YYYYMMDD = TO_CHAR(TO_DATE(N_FCST_END_DATE, 'YYYYMMDD') + 0, 'YYYYMMDD'); /* MAX_YYYYMMDD 셋팅 */
                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                            NULL;
                    END;
                ELSIF N_UPLOAD_BUCKET_TYPE = 'WEEKLY' THEN
                    N_FCST_START_DATE := TO_CHAR(FN_NEXT_DAY(TO_DATE(N_FCST_START_DATE, 'YYYYMMDD'), 'MON') + (-7), 'YYYYMMDD'); /* MIN_YYYYMMDD 셋팅 */
                    BEGIN
                        SELECT BASIS_YYYYMMDD
                          INTO N_FCST_END_DATE
                          FROM SCM_SYS_CALENDAR_M T
                         WHERE T.BASIS_YYYYMMDD = TO_CHAR(TO_DATE(N_FCST_END_DATE, 'YYYYMMDD') + 6, 'YYYYMMDD'); /* MAX_YYYYMMDD 셋팅 */
                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                            NULL;
                    END;
                ELSIF N_UPLOAD_BUCKET_TYPE = 'MONTHLY' THEN
                    BEGIN
                        SELECT BASIS_YYYYMMDD
                          INTO N_FCST_END_DATE
                          FROM SCM_SYS_CALENDAR_M T
                         WHERE T.BASIS_YYYYMMDD = TO_CHAR(ADD_MONTHS(TO_DATE(N_FCST_END_DATE, 'YYYYMMDD'), 1) - 1, 'YYYYMMDD'); /* MAX_YYYYMMDD 셋팅 : MSSQL DATEADD(DD,-1, MM+1월초) */
                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                            NULL;
                    END;
                END IF;

                N_RESULT_END_DATE := TO_CHAR(TO_DATE(N_FCST_START_DATE, 'YYYYMMDD') - 1, 'YYYYMMDD'); /* DM_PLN_MKT_FCST_RESULT 테이블에 적용할 데이터의 마지막 일자 */

                IF N_RESULT_END_DATE < N_RESULT_START_DATE THEN /* 20180315 SKH MODIFY */
                    N_RESULT_START_DATE := N_RESULT_END_DATE;
                END IF;
            END;
            /* (88) 데이터의 시작~끝 날짜 구하기 ---------------------------------------------- (end) */

            /* DM_PLN_CUSTOMER_PSI 최종 데이터 INSERT 전 임시테이블에 모두 저장 */
            /* CUSTOMER PSI = 'I' 인경우의 INSERT 값 ---------------------------------------------------------------------------- START */
            BEGIN
                INSERT
                INTO GT_DPCP_T2
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
                         , 'UPLOAD_COMPLETED'
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
                      FROM GT_DPCP_T3
                     WHERE 1 = 1
                       AND BATCH_RESULT = 'UPLOAD_COMPLETED' /* SPLIT 완료된 데이터만 처리 */
                       AND YYYYMMDD >= N_RESULT_START_DATE /* 과거의 시작데이터 */
                       AND YYYYMMDD <= N_FCST_END_DATE; /* 미래의 마지막데이터 */
            END;
            /* CUSTOMER PSI = 'I' 인경우의 INSERT 값 ---------------------------------------------------------------------------- END */

            /*-------------------- 기존 데이터를 TEMP TABLE에 INSERT 하여 계산할수 있도록함 --------------------*/
            BEGIN
                INSERT
                INTO GT_DPCP_MKT_FCST
                    /* SELECT *  [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 (개발서버에 소스가 없어서 운영에서 받아와서 변경후 COMPILE 처리) */
                    SELECT DIVISION_ID
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
                         , TO_CHAR(ATTRIBUTE4) /* [변환주의] nvarchar(MAX) UNION 정합 : LS-015 TO_CHAR */
                         , TO_CHAR(ATTRIBUTE5)
                         , TO_CHAR(ATTRIBUTE6)
                         , ATTRIBUTE7
                         , ATTRIBUTE8
                         , ATTRIBUTE9
                         , ATTRIBUTE10
                      FROM DM_PLN_MKT_FCST
                     WHERE 1 = 1
                       AND DIVISION_ID = V_DIVISION_ID
                       AND PROJECT_CODE = V_PROJECT_CODE
                       AND SCM_SITE_ID = V_SCM_SITE_ID
                       AND ITEM_ID = V_ITEM_ID
                       AND DOM_EXP = V_DOM_EXP
                       AND FCST_TYPE = V_FCST_TYPE
                       AND INCOTERMS = V_INCOTERMS
                       AND PLANT_SITE_ID = V_PLANT_SITE_ID
                       AND YYYYMMDD >= N_FCST_START_DATE /* DM_PLN_MKT_FCST_RESULT 테이블에 적용할 데이터의 시작일자 */
                       /* AND YYYYMMDD <= @n_FCST_END_DATE  -- 20180315 skh modify */
                       AND YYYYMMDD <= TO_CHAR(FN_NEXT_DAY(TO_DATE(N_FCST_START_DATE, 'YYYYMMDD'), 'SUN') + (7 * 27), 'YYYYMMDD') /* 미래 6개월치로 설정해놓았음 -- 20180315 skh add */
                    UNION
                    /* SELECT *  [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 */
                    SELECT DIVISION_ID
                         , PROJECT_CODE
                         , SCM_SITE_ID
                         , ITEM_ID
                         , DOM_EXP
                         , FCST_TYPE
                         , INCOTERMS
                         , MEASURE
                         , PLANT_SITE_ID
                         , YYYYMMDD
                         , SUM(QTY) QTY
                         , MAX(CREATED_BY) CREATED_BY
                         , MAX(CREATION_DATE) CREATION_DATE
                         , MAX(LAST_UPDATED_BY) LAST_UPDATED_BY
                         , MAX(LAST_UPDATE_DATE) LAST_UPDATE_DATE
                         , ATTRIBUTE1
                         , ATTRIBUTE2
                         , ATTRIBUTE3
                         , TO_CHAR(ATTRIBUTE4) /* [변환주의] nvarchar(MAX) GROUP BY/UNION 정합 : LS-015 TO_CHAR */
                         , TO_CHAR(ATTRIBUTE5)
                         , TO_CHAR(ATTRIBUTE6)
                         , ATTRIBUTE7
                         , ATTRIBUTE8
                         , ATTRIBUTE9
                         , ATTRIBUTE10
                      FROM DM_PLN_MKT_FCST_RESULT
                     WHERE 1 = 1
                       AND DIVISION_ID = V_DIVISION_ID
                       AND PROJECT_CODE = V_PROJECT_CODE
                       AND SCM_SITE_ID = V_SCM_SITE_ID
                       AND ITEM_ID = V_ITEM_ID
                       AND DOM_EXP = V_DOM_EXP
                       AND FCST_TYPE = V_FCST_TYPE
                       AND INCOTERMS = V_INCOTERMS
                       AND PLANT_SITE_ID = V_PLANT_SITE_ID
                       AND YYYYMMDD >= N_RESULT_START_DATE /* DM_PLN_MKT_FCST_RESULT 테이블에 적용할 데이터의 시작일자 */
                       AND YYYYMMDD <= N_RESULT_END_DATE /* DM_PLN_MKT_FCST_RESULT 테이블에 적용할 데이터의 종료일자 */
                      GROUP BY DIVISION_ID
                             , PROJECT_CODE
                             , SCM_SITE_ID
                             , ITEM_ID
                             , DOM_EXP
                             , FCST_TYPE
                             , INCOTERMS
                             , MEASURE
                             , PLANT_SITE_ID
                             , YYYYMMDD
                             , ATTRIBUTE1
                             , ATTRIBUTE2
                             , ATTRIBUTE3
                             , TO_CHAR(ATTRIBUTE4)
                             , TO_CHAR(ATTRIBUTE5)
                             , TO_CHAR(ATTRIBUTE6)
                             , ATTRIBUTE7
                             , ATTRIBUTE8
                             , ATTRIBUTE9
                             , ATTRIBUTE10;
            END;

            /*-------------------- 데이터 INSERT 전 TEMP TABLE 중복데이터 삭제  --------------------*/
            BEGIN
                DELETE FROM GT_DPCP_MKT_FCST A
                WHERE  (SELECT COUNT(1)
                          FROM GT_DPCP_T2 B
                         WHERE 1 = 1
                           AND A.DIVISION_ID = B.DIVISION_ID
                           AND A.SCM_SITE_ID = B.SCM_SITE_ID
                           AND A.PROJECT_CODE = B.PROJECT_CODE
                           AND A.ITEM_ID = B.ITEM_ID
                           AND A.DOM_EXP = B.DOM_EXP
                           AND A.FCST_TYPE = B.FCST_TYPE
                           AND A.INCOTERMS = B.INCOTERMS
                           AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
                           AND A.MEASURE = B.MEASURE
                           AND B.BATCH_RESULT = 'UPLOAD_COMPLETED'
                       ) > 0;
            END;

            /* (11) */
            /*-------------------- 과거구간부터 미래의 끝 데이터까지 WOS작업을 진행하기 위하여 TEMP TABLE에 INSERT  --------------------*/
            BEGIN
                INSERT
                INTO GT_DPCP_MKT_FCST
                    SELECT DIVISION_ID
                         , PROJECT_CODE
                         , SCM_SITE_ID
                         , ITEM_ID
                         , DOM_EXP
                         , FCST_TYPE
                         , INCOTERMS
                         , MEASURE /* 20180227 */
                         , PLANT_SITE_ID
                         , YYYYMMDD
                         , QTY
                         , CREATED_BY
                         , CREATION_DATE
                         , LAST_UPDATED_BY
                         , SYSTIMESTAMP
                         , 'UPLOAD_COMPLETED'
                         , MST_UPLOAD_UOM
                         , MST_UPLOAD_BUCKET_TYPE
                         , MST_SUMMARY_BUCKET_TYPE
                         , MST_CONVERT_QTY
                         , PLAN_WEEK
                         , SPLIT_RESULT
                         , ATTRIBUTE8
                         , ATTRIBUTE9
                         , ATTRIBUTE10
                      FROM GT_DPCP_T2
                     WHERE 1 = 1
                       AND BATCH_RESULT = 'UPLOAD_COMPLETED';
            END;

            /* 20180315 */
            DELETE FROM GT_DPCP_MKT_FCST WHERE QTY = 0;

            /* WOS 프로시져 호출  pppp */
            /* IF @n_CUSTOMER_PSI_VALUE = 'S'  -- 20180315 skh modify */
            PR_DM_PLN_CUST_PSI_TO_MKT_FCST_WOS(P_DIVISION_ID   => V_DIVISION_ID
                                             , P_PROJECT_CODE  => V_PROJECT_CODE
                                             , P_INCOTERMS     => V_INCOTERMS
                                             , P_SCM_SITE_ID   => V_SCM_SITE_ID
                                             , P_PLANT_SITE_ID => V_PLANT_SITE_ID
                                             , P_DOM_EXP       => V_DOM_EXP
                                             , P_FCST_TYPE     => V_FCST_TYPE
                                             , P_ITEM_ID       => V_ITEM_ID
                                             , P_MON_DAY       => N_RESULT_START_DATE);

            /*-------------------- DM_PLN_MKT_FCST_RESULT 테이블 delete count 확인 --------------------*/
            BEGIN
                SELECT N_FCST_RSLT_DELETE_COUNT + COUNT(*)
                  INTO N_FCST_RSLT_DELETE_COUNT
                  FROM DM_PLN_MKT_FCST_RESULT A
                 WHERE (SELECT COUNT(1)
                          FROM GT_DPCP_MKT_FCST B
                         WHERE 1 = 1
                           AND A.DIVISION_ID = B.DIVISION_ID
                           AND A.SCM_SITE_ID = B.SCM_SITE_ID
                           AND A.PROJECT_CODE = B.PROJECT_CODE
                           AND A.ITEM_ID = B.ITEM_ID
                           AND A.DOM_EXP = B.DOM_EXP
                           AND A.FCST_TYPE = B.FCST_TYPE
                           AND A.INCOTERMS = B.INCOTERMS
                           AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
                           AND A.MEASURE = B.MEASURE
                           /* AND YYYYMMDD >= @n_RESULT_START_DATE  -- 20180315 skh modify */
                           /* AND YYYYMMDD <= @n_RESULT_END_DATE    -- 20180315 skh modify */
                       ) > 0;
            END;

            /*-------------------- DM_PLN_MKT_FCST 테이블 delete count 확인 --------------------*/
            BEGIN
                SELECT N_FCST_DELETE_COUNT + COUNT(*)
                  INTO N_FCST_DELETE_COUNT
                  FROM DM_PLN_MKT_FCST A
                 WHERE (SELECT COUNT(1)
                          FROM GT_DPCP_MKT_FCST B
                         WHERE 1 = 1
                           AND A.DIVISION_ID = B.DIVISION_ID
                           AND A.SCM_SITE_ID = B.SCM_SITE_ID
                           AND A.PROJECT_CODE = B.PROJECT_CODE
                           AND A.ITEM_ID = B.ITEM_ID
                           AND A.DOM_EXP = B.DOM_EXP
                           AND A.FCST_TYPE = B.FCST_TYPE
                           AND A.INCOTERMS = B.INCOTERMS
                           AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
                           AND A.MEASURE = B.MEASURE
                           /* AND YYYYMMDD >= @n_FCST_START_DATE  -- 20180315 skh modify */
                           AND YYYYMMDD <= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'SUN') + (7 * 27), 'YYYYMMDD') /* @n_FCST_END_DATE  DM_PLN_MKT_FCST 종료일자 */
                       ) > 0;
            END;

            /*-------------------- DM_PLN_MKT_FCST_RESULT 테이블 insert전 데이터 중복제거 --------------------*/
            BEGIN
                DELETE FROM DM_PLN_MKT_FCST_RESULT A
                WHERE  (SELECT COUNT(1)
                          FROM GT_DPCP_MKT_FCST B
                         WHERE 1 = 1
                           AND A.DIVISION_ID = B.DIVISION_ID
                           AND A.SCM_SITE_ID = B.SCM_SITE_ID
                           AND A.PROJECT_CODE = B.PROJECT_CODE
                           AND A.ITEM_ID = B.ITEM_ID
                           AND A.DOM_EXP = B.DOM_EXP
                           AND A.FCST_TYPE = B.FCST_TYPE
                           AND A.INCOTERMS = B.INCOTERMS
                           AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
                           AND A.MEASURE = B.MEASURE
                           AND A.YYYYMMDD = B.YYYYMMDD
                           /* AND YYYYMMDD >= @n_RESULT_START_DATE */
                           /* AND YYYYMMDD <= @n_RESULT_END_DATE    -- 20180315 skh modify */
                       ) > 0;
            END;
            /*-------------------- DM_PLN_MKT_FCST 테이블 insert전 데이터 중복제거 --------------------*/
            BEGIN
                DELETE FROM DM_PLN_MKT_FCST A
                WHERE  (SELECT COUNT(1)
                          FROM GT_DPCP_MKT_FCST B
                         WHERE 1 = 1
                           AND A.DIVISION_ID = B.DIVISION_ID
                           AND A.SCM_SITE_ID = B.SCM_SITE_ID
                           AND A.PROJECT_CODE = B.PROJECT_CODE
                           AND A.ITEM_ID = B.ITEM_ID
                           AND A.DOM_EXP = B.DOM_EXP
                           AND A.FCST_TYPE = B.FCST_TYPE
                           AND A.INCOTERMS = B.INCOTERMS
                           AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
                           AND A.MEASURE = B.MEASURE
                           AND A.YYYYMMDD = B.YYYYMMDD
                           /* AND YYYYMMDD >= @n_FCST_START_DATE */
                           /* AND YYYYMMDD <= @n_FCST_END_DATE    -- 20180315 skh modify */
                       ) > 0;
            END;

            /*-------------------- DM_PLN_MKT_FCST_RESULT 테이블 insert  --------------------*/
            BEGIN
                INSERT INTO DM_PLN_MKT_FCST_RESULT
                    SELECT DISTINCT DIVISION_ID
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
                         , SYSTIMESTAMP
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
                         , NULL /* SO_RANK  [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 (칼럼 추가로 인해 NULL로 세팅) */
                         , NULL
                         , NULL
                         , '-' /* CELL_PROD_SITE_ID  [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 (81사업부 전용 소스이므로 '-'로 고정) */
                      FROM GT_DPCP_MKT_FCST
                     WHERE 1 = 1;
                     /* AND YYYYMMDD >= @n_RESULT_START_DATE  -- 20180315 skh modify */
                     /* AND YYYYMMDD <= @n_RESULT_END_DATE    -- 20180315 skh modify */
                     /* AND @n_RESULT_START_DATE <> @n_RESULT_END_DATE -- 20180315 skh modify */
            END;

            /*-------------------- DM_PLN_MKT_FCST_RESULT 테이블 insert count 확인 --------------------*/ /* LLLL */
            BEGIN
                SELECT N_FCST_RSLT_INSERT_COUNT + COUNT(*)
                  INTO N_FCST_RSLT_INSERT_COUNT
                  FROM GT_DPCP_MKT_FCST
                 WHERE 1 = 1
                   AND YYYYMMDD >= N_RESULT_START_DATE /* DM_PLN_MKT_FCST_RESULT 테이블에 적용할 데이터의 시작일자 */
                   AND YYYYMMDD <= N_RESULT_END_DATE; /* DM_PLN_MKT_FCST_RESULT 테이블에 적용할 데이터의 종료일자 */
            END;

            /*-------------------- DM_PLN_MKT_FCST 테이블 insert count 확인 --------------------*/ /* LLLL */
            BEGIN
                SELECT N_FCST_INSERT_COUNT + COUNT(*)
                  INTO N_FCST_INSERT_COUNT
                  FROM GT_DPCP_MKT_FCST
                 WHERE 1 = 1
                   AND YYYYMMDD >= N_FCST_START_DATE /* DM_PLN_MKT_FCST_RESULT 테이블에 적용할 데이터의 시작일자 */
                   /* AND YYYYMMDD <= @n_FCST_END_DATE    -- 20180315 skh modify */
                   AND YYYYMMDD <= TO_CHAR(FN_NEXT_DAY(TO_DATE(N_FCST_START_DATE, 'YYYYMMDD'), 'SUN') + (7 * 27), 'YYYYMMDD'); /* 미래 6개월치로 설정해놓았음  -- 20180315 skh add */
            END;

            /*-------------------- DM_PLN_MKT_FCST 테이블 insert  --------------------*/
            BEGIN
                INSERT INTO DM_PLN_MKT_FCST
                    SELECT DISTINCT DIVISION_ID
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
                         , SYSTIMESTAMP
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
                      FROM GT_DPCP_MKT_FCST
                     WHERE 1 = 1;
                     /* AND YYYYMMDD >= @n_FCST_START_DATE */
                     /* AND YYYYMMDD <= CONVERT(...FN_NEXT_DAY(GETDATE(),'SUN')...) -- 20180315 skh modify 종료일자 적용하지 않음 */
            END;

            BEGIN
                SELECT N_FCST_INSERT_COUNT + COUNT(*)
                  INTO N_FCST_INSERT_COUNT
                  FROM GT_DPCP_T2
                 WHERE 1 = 1
                   AND BATCH_RESULT = 'UPLOAD_COMPLETED';
            END;

            /* GROUP 로딩 COUNT 증가 */
            BEGIN
                N_PSI_GROUP_INSERT := N_PSI_GROUP_INSERT + 1;
            END;

            IF N_PSI_GROUP_INSERT <= N_PSI_GROUP_CNT THEN
                /* GROUP별로 작업종료후 Temp Table TRUNCATE(원본 TRUNCATE -> GTT DELETE) */
                DELETE FROM GT_DPCP_T2;
                DELETE FROM GT_DPCP_T3;
                DELETE FROM GT_DPCP_MKT_FCST;
            END IF;

        END LOOP;
        /* ------------------------------------------------------------------------------------------------------------- PSI GROUP LOOP END */
        COMMIT; /* MSSQL: COMMIT WORK */

        /* 임시테이블 삭제 (원본 DROP -> GTT DELETE) ------------------------------------------------------------- (start) */
        DELETE FROM GT_DPCP_PSI;
        DELETE FROM GT_DPCP_PSI_GROUP_COUNT;
        DELETE FROM GT_DPCP_T3;
        DELETE FROM GT_DPCP_T2;
        DELETE FROM GT_DPCP_CALENDAR;
        DELETE FROM GT_DPCP_MIN_MAX;
        DELETE FROM GT_DPCP_MKT_FCST;
        /* 임시테이블 삭제 ------------------------------------------------------------- (END) */

        /* 종료 LOG */
        V_LOG_TYPE := 'END';
        V_LOG_MESSAGE := '########## END of procedure ##########';
        V_DESCRIPTION := 'psi_update_count= ' ||TO_CHAR(N_PSI_UPDATE_COUNT)||' / psi_delete_count= ' ||TO_CHAR(N_PSI_DELETE_COUNT)||
                         ' / psi_insert_count= ' ||TO_CHAR(N_PSI_INSERT_COUNT)||' / rslt_delete_count= ' ||TO_CHAR(N_FCST_RSLT_DELETE_COUNT)||
                         ' / rslt_insert_count= ' ||TO_CHAR(N_FCST_RSLT_INSERT_COUNT)||' / fcst_delete_count= ' ||TO_CHAR(N_FCST_DELETE_COUNT)||
                         ' / fcst_insert_count= ' ||TO_CHAR(N_FCST_INSERT_COUNT);
        D_EVENT_DATE := SYSTIMESTAMP;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        << ERR_RTN >>
        NULL;
        IF V_LOG_TYPE = 'INVALID' THEN
            ROLLBACK; /* MSSQL: ROLLBACK TRANSACTION PR_DM_PLN_CUST_PSI_TO_MKT_FCST */
            PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
        END IF;

    END;

EXCEPTION
    /* 트랜잭션 (END) : MSSQL BEGIN CATCH(XACT_ABORT ON) -> ROLLBACK 후 ERROR 로깅만 하고 재전파 없이 정상 종료(원본 삼킴 동작 유지) */
    WHEN OTHERS THEN
        ROLLBACK; /* MSSQL: ROLLBACK TRANSACTION PR_DM_PLN_CUST_PSI_TO_MKT_FCST */
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
END;