CREATE OR REPLACE PROCEDURE           "DMF0003_CAR_FCST_EXCEL_UPLOAD" (
    p_mode       IN NUMBER,
    p_created_by IN VARCHAR2
)
AS
/*
 * 2026.05.08 박재민 컴파일 오류 수정
 */
 /*
 * Program ID   : DMF0003_CAR_FCST_EXCEL_UPLOAD
 * Description  : DMF0003_CAR_FCST_EXCEL_UPLOAD
 * Program History
 *===========================================================================================================
 *   Date       In Charge      Description
 *===========================================================================================================
 * 2023. 06. 29   bswon        고객수요증감분석 프로젝트
 * 2024. 01. 03   KJJ			엑셀 업로드 기능개선
 ==>SCM_ADM_EXCEL_UPLOAD시 필드 2개 추가사용 : ATTRIBUTE5, ATTRIBUTE6
 ==>해당값을 DM_ANL_CAR_FCST_REF에 저장시 ATTRIBUTE1, ATTRIBUTE2 사용
 */
    v_program_id     VARCHAR2(40 CHAR) := 'DMF0003';
    v_sheet_name     VARCHAR2(40 CHAR) := 'Car Fcst';
    v_sql_text       VARCHAR2(4000 CHAR);
    v_creation_date  VARCHAR2(40 CHAR);
    v_count          NUMBER(10);
    v_start_yyyymmdd VARCHAR2(8 CHAR);
    v_end_yyyymmdd   VARCHAR2(8 CHAR);
    v_division       VARCHAR2(10 CHAR);
    v_program_name   VARCHAR2(150 CHAR) := 'DMF0003_CAR_FCST_EXCEL_UPLOAD';
    v_log_type       VARCHAR2(30 CHAR);
    n_log_count      NUMBER(10) := 0;
    v_log_message    VARCHAR2(1000 CHAR);
    v_description    VARCHAR2(500 CHAR);
    d_event_date     DATE;
BEGIN
    -- LOG 용 변수 설정
    v_log_type := 'START';
    v_log_message := '########## Start of procedure ##########';
    v_description := NULL;
    d_event_date := SYSDATE;
    PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);


    SELECT TO_CHAR(MAX(T.CREATION_DATE), 'YYYY-MM-DD HH24:MI:SS.FF3')
    INTO   v_creation_date
    FROM   SCM_ADM_EXCEL_UPLOAD T
    WHERE  T.PROGRAM_ID = v_program_id
    AND    T.SHEET_NAME = v_sheet_name
    AND    T.CREATED_BY = p_created_by;
    --  AND UPPER(METADATA1_VALUE) != 'BASIS YYYYMM';

    IF v_creation_date IS NULL THEN
        v_log_type := 'END';
        v_log_message := '########## END of procedure ##########';
        v_description := 'Data Not Found ['  ||  TO_CHAR(v_creation_date, 'YYYY-MM-DD HH24:MI:SS.FF3')  || ']';
        d_event_date := SYSDATE;
        PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
    END IF;

    BEGIN
        SELECT ATTRIBUTE1
        INTO v_division
        FROM SCM_ADM_EXCEL_UPLOAD
        WHERE  PROGRAM_ID    = v_program_id
        AND    SHEET_NAME    = v_sheet_name
        AND    CREATED_BY    = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
--        --AND    UPPER(ATTRIBUTE1) = 'DIVISION*'
        AND    UPLOAD_STATUS_CODE = 'SUCCESS'
        AND ROWNUM = 1;

        --
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_division := NULL;
    END;

    IF NVL(p_mode, 0) = 0 THEN
        BEGIN
            UPDATE SCM_ADM_EXCEL_UPLOAD
            SET    UPLOAD_STATUS_CODE = 'UPLOAD'
                 , MESSAGE_TEXT       = NULL
--            AS-IS가 MSSQL 이라고 해도 자기 자신을 조회 한 후에 업데아트 칠 필요가 없어 보임.
--            FROM   SCM_ADM_EXCEL_UPLOAD T
            WHERE  PROGRAM_ID    = v_program_id
            AND    SHEET_NAME    = v_sheet_name
            AND    CREATED_BY    = p_created_by
            AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
            AND    NVL(UPLOAD_STATUS_CODE,'X') != 'UPLOAD';
        END;

        BEGIN
            -- ---------------------------------------------------------------------
            --scm2_mgr.xLOG('RESET Status = UPLOAD', SQL%ROWCOUNT, 1, TRUE);
            v_log_type := '1';
            v_log_message := '########## RESET Status = UPLOAD ##########';
            v_description := NULL;
            d_event_date := SYSDATE;
            PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
            -- ---------------------------------------------------------------------
        END;

        BEGIN
            UPDATE SCM_ADM_EXCEL_UPLOAD
            SET    UPLOAD_STATUS_CODE = 'SKIP'
            WHERE  PROGRAM_ID    = v_program_id
            AND    SHEET_NAME    = v_sheet_name
            AND    CREATED_BY    = p_created_by
            AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
            AND    (   ATTRIBUTE1  IS NULL
                    OR UPPER(ATTRIBUTE1) = 'TOTAL') ;
        END;

        BEGIN
            -- ---------------------------------------------------------------------
            --scm2_mgr.xLOG('SKIP EMPTY LINE      ', SQL%ROWCOUNT, 2, TRUE);
            v_log_type := '2';
            v_log_message := '########## SKIP EMPTY LINE ##########';
            v_description := NULL;
            d_event_date := SYSDATE;
            PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
            -- ---------------------------------------------------------------------
        END;

        BEGIN
            UPDATE SCM_ADM_EXCEL_UPLOAD
            SET    UPLOAD_STATUS_CODE = '@TITLE'
            WHERE  PROGRAM_ID    = v_program_id
            AND    SHEET_NAME    = v_sheet_name
            AND    CREATED_BY    = p_created_by
            AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
            AND    UPPER(ATTRIBUTE1) = 'DIVISION*';
        END;

        BEGIN
            -- ---------------------------------------------------------------------
            --scm2_mgr.xLOG('V_TITLE Header Line   ', SQL%ROWCOUNT, 3, TRUE);
            v_log_type := '3';
            v_log_message := '########## TITLE Header Line ##########';
            v_description := NULL;
            d_event_date := SYSDATE;
            PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
            -- ---------------------------------------------------------------------
        END;
        --WBS
        BEGIN
            UPDATE SCM_ADM_EXCEL_UPLOAD
            SET    UPLOAD_STATUS_CODE = 'ERROR'
                 , MESSAGE_TEXT       = 'Duplication Key.'
            WHERE  PROGRAM_ID         = v_program_id
            AND    SHEET_NAME         = v_sheet_name
            AND    CREATED_BY         = p_created_by
            AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
            AND    UPLOAD_STATUS_CODE = 'UPLOAD'
            AND EXISTS (SELECT 1
                        FROM  (SELECT X.ATTRIBUTE1 AS COL1
                                    , X.ATTRIBUTE2 AS COL2
                                    , X.ATTRIBUTE3 AS COL3
                                    , X.ATTRIBUTE4 AS COL4
                               FROM   SCM_ADM_EXCEL_UPLOAD X
                               WHERE  X.PROGRAM_ID    = v_program_id
                               AND    X.SHEET_NAME    = v_sheet_name
                               AND    X.CREATED_BY    = p_created_by
                               AND    TO_CHAR(X.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
                               AND    X.UPLOAD_STATUS_CODE = 'UPLOAD'
                               GROUP BY X.ATTRIBUTE1
                                      , X.ATTRIBUTE2
                                      , X.ATTRIBUTE3
                                      , X.ATTRIBUTE4
                               HAVING COUNT(*) > 1 ) T
                        WHERE 1 = 1
                        AND T.COL1 = ATTRIBUTE1
                        AND T.COL2 = ATTRIBUTE2
                        AND T.COL3 = ATTRIBUTE3
                        AND T.COL4 = ATTRIBUTE4
                       );
        END;

        BEGIN
            -- ---------------------------------------------------------------------
            --scm2_mgr.xLOG('ERROR Key Duplication ', SQL%ROWCOUNT, 4, TRUE);
            v_log_type := '4';
            v_log_message := '########## ERROR Key Duplication ##########';
            v_description := NULL;
            d_event_date := SYSDATE;
            PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
            -- ---------------------------------------------------------------------
        END;

        BEGIN
            UPDATE SCM_ADM_EXCEL_UPLOAD
            SET    UPLOAD_STATUS_CODE = 'ERROR'
                 , MESSAGE_TEXT       = 'Invalid Division.'
            WHERE  PROGRAM_ID         = v_program_id
            AND    SHEET_NAME         = v_sheet_name
            AND    CREATED_BY         = p_created_by
            AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
            AND    UPLOAD_STATUS_CODE = 'UPLOAD'
            AND NOT EXISTS (SELECT 1
                            FROM   SCM_MST_DIVISION D
                            WHERE  D.VALID_YN    = 'Y'
                            AND    D.DIVISION_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1
                            union
                            SELECT 1
                            FROM   SCM_MST_DIVISION D
                            WHERE  D.VALID_YN    = 'Y'
                            AND    D.DIVISION_NAME = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1
                           );
        END;

        BEGIN -- Division Validation은 끝났으니 코드로 정보를 치환해줌.
            UPDATE SCM_ADM_EXCEL_UPLOAD
            SET    ATTRIBUTE1 = (
                                    SELECT D.DIVISION_ID
                                    FROM   SCM_MST_DIVISION D
                                    WHERE  D.VALID_YN    = 'Y'
                                    AND    D.DIVISION_NAME = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1
                                 )
            WHERE  PROGRAM_ID         = v_program_id
            AND    SHEET_NAME         = v_sheet_name
            AND    CREATED_BY         = p_created_by
            AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
            AND    UPLOAD_STATUS_CODE = 'UPLOAD'
            AND NOT EXISTS (SELECT 1
                            FROM   SCM_MST_DIVISION D
                            WHERE  D.VALID_YN    = 'Y'
                            AND    D.DIVISION_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1
                           );
        END;

        BEGIN
            -- ---------------------------------------------------------------------
            --scm2_mgr.xLOG('Invalid Division ', SQL%ROWCOUNT, 5, TRUE);
            v_log_type := '5';
            v_log_message := '########## Invalid Division ##########';
            v_description := NULL;
            d_event_date := SYSDATE;
            PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
            -- ---------------------------------------------------------------------
        END;

        BEGIN
            UPDATE SCM_ADM_EXCEL_UPLOAD
            SET    UPLOAD_STATUS_CODE = 'SUCCESS'
            WHERE  PROGRAM_ID         = v_program_id
            AND    SHEET_NAME         = v_sheet_name
            AND    CREATED_BY         = p_created_by
            AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3')  = v_creation_date
            AND    UPLOAD_STATUS_CODE = 'UPLOAD';
        END;

        BEGIN
            -- -------------------------------------------------------------------------
            --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
            v_log_type := '16';
            v_log_message := '########## SUCCESS ##########';
            v_description := NULL;
            d_event_date := SYSDATE;
            PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
            -- -------------------------------------------------------------------------
        END;

    END IF;

    BEGIN
        -- -------------------------------------------------------------------------
        --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
        v_log_type := '17';
        v_log_message := '########## INSERT INTO DATA START ##########';
        v_description := p_mode; --TO_CHAR(v_creation_date, 'YYYY-MM-DD HH24:MI:SS.FF3');
        d_event_date := SYSDATE;
        PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        -- -------------------------------------------------------------------------
    END;

    --// SCM_UI_EXCEL_UPLOAD_T =>  DMR_CAPA_ALLOC_M
    --//======================================================================================
    SELECT COUNT(1)
    INTO   v_count
    FROM   SCM_ADM_EXCEL_UPLOAD T
    WHERE  T.PROGRAM_ID         = v_program_id
    AND    T.SHEET_NAME         = v_sheet_name
    AND    T.CREATED_BY         = p_created_by
    AND    TO_CHAR(T.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
    AND    T.UPLOAD_STATUS_CODE = 'ERROR' ;

    -- Update Mode and No Errors
    IF p_mode > 0 AND v_count = 0 THEN
        BEGIN
            v_start_yyyymmdd := NULL;
            v_end_yyyymmdd := NULL;
        END;

        BEGIN
            -- -------------------------------------------------------------------------
            --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
            v_log_type := '18';
            v_log_message := '########## DELETE DATE START ##########';
            v_description := p_mode; --TO_CHAR(v_creation_date, 'YYYY-MM-DD HH24:MI:SS.FF3');
            d_event_date := SYSDATE;
            PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
            -- -------------------------------------------------------------------------
        END;

        BEGIN
            SELECT D.MIN_YYYYQQ
                ,  D.MAX_YYYYQQ
            INTO   v_start_yyyymmdd, v_end_yyyymmdd
            FROM (
               SELECT MIN(YYYYQQ) AS MIN_YYYYQQ
                    , MAX(YYYYQQ) AS MAX_YYYYQQ
               FROM   (SELECT ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
                         , ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
                         , ATTRIBUTE11, ATTRIBUTE12, ATTRIBUTE13, ATTRIBUTE14, ATTRIBUTE15
                         , ATTRIBUTE16, ATTRIBUTE17, ATTRIBUTE18, ATTRIBUTE19, ATTRIBUTE20
                         , ATTRIBUTE21, ATTRIBUTE22, ATTRIBUTE23, ATTRIBUTE24, ATTRIBUTE25
                         , ATTRIBUTE26, ATTRIBUTE27, ATTRIBUTE28, ATTRIBUTE29, ATTRIBUTE30
                         , ATTRIBUTE31, ATTRIBUTE32, ATTRIBUTE33, ATTRIBUTE34, ATTRIBUTE35
                         , ATTRIBUTE36, ATTRIBUTE37, ATTRIBUTE38, ATTRIBUTE39, ATTRIBUTE40
                         , ATTRIBUTE41, ATTRIBUTE42, ATTRIBUTE43, ATTRIBUTE44, ATTRIBUTE45
                         , ATTRIBUTE46, ATTRIBUTE47, ATTRIBUTE48, ATTRIBUTE49, ATTRIBUTE50
                         , ATTRIBUTE51, ATTRIBUTE52, ATTRIBUTE53, ATTRIBUTE54, ATTRIBUTE55
                         , ATTRIBUTE56, ATTRIBUTE57, ATTRIBUTE58, ATTRIBUTE59, ATTRIBUTE60
                         , ATTRIBUTE61, ATTRIBUTE62, ATTRIBUTE63, ATTRIBUTE64, ATTRIBUTE65
                         , ATTRIBUTE66, ATTRIBUTE67, ATTRIBUTE68, ATTRIBUTE69, ATTRIBUTE70
                         , ATTRIBUTE71, ATTRIBUTE72, ATTRIBUTE73, ATTRIBUTE74, ATTRIBUTE75
                         , ATTRIBUTE76, ATTRIBUTE77, ATTRIBUTE78, ATTRIBUTE79, ATTRIBUTE80
                         , ATTRIBUTE81, ATTRIBUTE82, ATTRIBUTE83, ATTRIBUTE84, ATTRIBUTE85
                         , ATTRIBUTE86, ATTRIBUTE87, ATTRIBUTE88, ATTRIBUTE89, ATTRIBUTE90
                         , ATTRIBUTE91, ATTRIBUTE92, ATTRIBUTE93, ATTRIBUTE94, ATTRIBUTE95
                         , ATTRIBUTE96, ATTRIBUTE97, ATTRIBUTE98, ATTRIBUTE99, ATTRIBUTE100
                         , ATTRIBUTE101, ATTRIBUTE102, ATTRIBUTE103, ATTRIBUTE104, ATTRIBUTE105
                         , ATTRIBUTE106, ATTRIBUTE107, ATTRIBUTE108, ATTRIBUTE109, ATTRIBUTE110
                         , ATTRIBUTE111, ATTRIBUTE112, ATTRIBUTE113, ATTRIBUTE114, ATTRIBUTE115
                         , ATTRIBUTE116, ATTRIBUTE117, ATTRIBUTE118, ATTRIBUTE119, ATTRIBUTE120
                         , ATTRIBUTE121, ATTRIBUTE122, ATTRIBUTE123, ATTRIBUTE124, ATTRIBUTE125
                         , ATTRIBUTE126, ATTRIBUTE127, ATTRIBUTE128, ATTRIBUTE129, ATTRIBUTE130
                         , ATTRIBUTE131, ATTRIBUTE132, ATTRIBUTE133, ATTRIBUTE134, ATTRIBUTE135
                         , ATTRIBUTE136, ATTRIBUTE137, ATTRIBUTE138, ATTRIBUTE139, ATTRIBUTE140
                         , ATTRIBUTE141, ATTRIBUTE142, ATTRIBUTE143, ATTRIBUTE144, ATTRIBUTE145
                         , ATTRIBUTE146, ATTRIBUTE147, ATTRIBUTE148, ATTRIBUTE149, ATTRIBUTE150
                         , ATTRIBUTE151, ATTRIBUTE152, ATTRIBUTE153, ATTRIBUTE154, ATTRIBUTE155
                         , ATTRIBUTE156, ATTRIBUTE157, ATTRIBUTE158, ATTRIBUTE159, ATTRIBUTE160
                         , ATTRIBUTE161, ATTRIBUTE162, ATTRIBUTE163, ATTRIBUTE164, ATTRIBUTE165
                         , ATTRIBUTE166, ATTRIBUTE167, ATTRIBUTE168, ATTRIBUTE169, ATTRIBUTE170
                         , ATTRIBUTE171, ATTRIBUTE172, ATTRIBUTE173, ATTRIBUTE174, ATTRIBUTE175
                         , ATTRIBUTE176, ATTRIBUTE177, ATTRIBUTE178, ATTRIBUTE179, ATTRIBUTE180
                         , ATTRIBUTE181, ATTRIBUTE182, ATTRIBUTE183, ATTRIBUTE184, ATTRIBUTE185
                         , ATTRIBUTE186, ATTRIBUTE187, ATTRIBUTE188, ATTRIBUTE189, ATTRIBUTE190
                         , ATTRIBUTE191, ATTRIBUTE192, ATTRIBUTE193, ATTRIBUTE194, ATTRIBUTE195
                         , ATTRIBUTE196, ATTRIBUTE197, ATTRIBUTE198, ATTRIBUTE199, ATTRIBUTE200
                    FROM   SCM_ADM_EXCEL_UPLOAD
                    WHERE  1 = 1
                    AND    PROGRAM_ID    = v_program_id
                    AND    SHEET_NAME    = v_sheet_name
                    AND    CREATED_BY    = p_created_by
                    AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
                    AND    UPLOAD_STATUS_CODE = '@TITLE'
               ) T
       UNPIVOT (YYYYQQ
                FOR COLUMN_NAME
                IN   (-- ATTRIBUTE5
                     --, ATTRIBUTE6,
                       ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
                     , ATTRIBUTE11, ATTRIBUTE12, ATTRIBUTE13, ATTRIBUTE14, ATTRIBUTE15
                     , ATTRIBUTE16, ATTRIBUTE17, ATTRIBUTE18, ATTRIBUTE19, ATTRIBUTE20
                     , ATTRIBUTE21, ATTRIBUTE22, ATTRIBUTE23, ATTRIBUTE24, ATTRIBUTE25
                     , ATTRIBUTE26, ATTRIBUTE27, ATTRIBUTE28, ATTRIBUTE29, ATTRIBUTE30
                     , ATTRIBUTE31, ATTRIBUTE32, ATTRIBUTE33, ATTRIBUTE34, ATTRIBUTE35
                     , ATTRIBUTE36, ATTRIBUTE37, ATTRIBUTE38, ATTRIBUTE39, ATTRIBUTE40
                     , ATTRIBUTE41, ATTRIBUTE42, ATTRIBUTE43, ATTRIBUTE44, ATTRIBUTE45
                     , ATTRIBUTE46, ATTRIBUTE47, ATTRIBUTE48, ATTRIBUTE49, ATTRIBUTE50
                     , ATTRIBUTE51, ATTRIBUTE52, ATTRIBUTE53, ATTRIBUTE54, ATTRIBUTE55
                     , ATTRIBUTE56, ATTRIBUTE57, ATTRIBUTE58, ATTRIBUTE59, ATTRIBUTE60
                     , ATTRIBUTE61, ATTRIBUTE62, ATTRIBUTE63, ATTRIBUTE64, ATTRIBUTE65
                     , ATTRIBUTE66, ATTRIBUTE67, ATTRIBUTE68, ATTRIBUTE69, ATTRIBUTE70
                     , ATTRIBUTE71, ATTRIBUTE72, ATTRIBUTE73, ATTRIBUTE74, ATTRIBUTE75
                     , ATTRIBUTE76, ATTRIBUTE77, ATTRIBUTE78, ATTRIBUTE79, ATTRIBUTE80
                     , ATTRIBUTE81, ATTRIBUTE82, ATTRIBUTE83, ATTRIBUTE84, ATTRIBUTE85
                     , ATTRIBUTE86, ATTRIBUTE87, ATTRIBUTE88, ATTRIBUTE89, ATTRIBUTE90
                     , ATTRIBUTE91, ATTRIBUTE92, ATTRIBUTE93, ATTRIBUTE94, ATTRIBUTE95
                     , ATTRIBUTE96, ATTRIBUTE97, ATTRIBUTE98, ATTRIBUTE99, ATTRIBUTE100
                     , ATTRIBUTE101, ATTRIBUTE102, ATTRIBUTE103, ATTRIBUTE104, ATTRIBUTE105
                     , ATTRIBUTE106, ATTRIBUTE107, ATTRIBUTE108, ATTRIBUTE109, ATTRIBUTE110
                     , ATTRIBUTE111, ATTRIBUTE112, ATTRIBUTE113, ATTRIBUTE114, ATTRIBUTE115
                     , ATTRIBUTE116, ATTRIBUTE117, ATTRIBUTE118, ATTRIBUTE119, ATTRIBUTE120
                     , ATTRIBUTE121, ATTRIBUTE122, ATTRIBUTE123, ATTRIBUTE124, ATTRIBUTE125
                     , ATTRIBUTE126, ATTRIBUTE127, ATTRIBUTE128, ATTRIBUTE129, ATTRIBUTE130
                     , ATTRIBUTE131, ATTRIBUTE132, ATTRIBUTE133, ATTRIBUTE134, ATTRIBUTE135
                     , ATTRIBUTE136, ATTRIBUTE137, ATTRIBUTE138, ATTRIBUTE139, ATTRIBUTE140
                     , ATTRIBUTE141, ATTRIBUTE142, ATTRIBUTE143, ATTRIBUTE144, ATTRIBUTE145
                     , ATTRIBUTE146, ATTRIBUTE147, ATTRIBUTE148, ATTRIBUTE149, ATTRIBUTE150
                     , ATTRIBUTE151, ATTRIBUTE152, ATTRIBUTE153, ATTRIBUTE154, ATTRIBUTE155
                     , ATTRIBUTE156, ATTRIBUTE157, ATTRIBUTE158, ATTRIBUTE159, ATTRIBUTE160
                     , ATTRIBUTE161, ATTRIBUTE162, ATTRIBUTE163, ATTRIBUTE164, ATTRIBUTE165
                     , ATTRIBUTE166, ATTRIBUTE167, ATTRIBUTE168, ATTRIBUTE169, ATTRIBUTE170
                     , ATTRIBUTE171, ATTRIBUTE172, ATTRIBUTE173, ATTRIBUTE174, ATTRIBUTE175
                     , ATTRIBUTE176, ATTRIBUTE177, ATTRIBUTE178, ATTRIBUTE179, ATTRIBUTE180
                     , ATTRIBUTE181, ATTRIBUTE182, ATTRIBUTE183, ATTRIBUTE184, ATTRIBUTE185
                     , ATTRIBUTE186, ATTRIBUTE187, ATTRIBUTE188, ATTRIBUTE189, ATTRIBUTE190
                     , ATTRIBUTE191, ATTRIBUTE192, ATTRIBUTE193, ATTRIBUTE194, ATTRIBUTE195
                     , ATTRIBUTE196, ATTRIBUTE197, ATTRIBUTE198, ATTRIBUTE199, ATTRIBUTE200
                     )
                ) X
                WHERE X.YYYYQQ IS NOT NULL
            ) D;
        END;

        BEGIN
            -- -------------------------------------------------------------------------
            --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
            v_log_type := '19-1';
            v_log_message := '########## DELETE DATE END ##########';
            v_description := p_mode; --TO_CHAR(v_creation_date, 'YYYY-MM-DD HH24:MI:SS.FF3');
            d_event_date := SYSDATE;
            PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
            -- -------------------------------------------------------------------------
        END;
        -- 아래와 같이 MSSQL에서 ORACLE로 마이그레이션 함
        -- MSSQL문법
		-- BEGIN TRANSACTION CAR_FCST;
        -- BEGIN TRY
        --    BEGIN ~ END;
        --    BEGIN ~ END;
        --    COMMIT WORK;
        -- END TRY
		-- BEGIN CATCH
		--    ROLLBACK TRANSACTION CAR_FCST;
		-- END CATCH

        -- ORACLE 문법
        -- BEGIN
        --    BEGIN ~ END;
        --    BEGIN ~ END;
        --    COMMIT WORK;
        --    EXCEPTION
        --        WHEN OTHERS THEN
        --            ROLLBACK;
        -- END


        BEGIN

            BEGIN
                -- -------------------------------------------------------------------------
                --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
                v_log_type := '20-1';
                v_log_message := '########## DELETE DM_ANL_CAR_FCST_REF DATE END ##########';
                v_description := p_mode; --TO_CHAR(v_creation_date, 'YYYY-MM-DD HH24:MI:SS.FF3');
                d_event_date := SYSDATE;
                PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
                -- -------------------------------------------------------------------------
                -- delete 주석
                DELETE DM_ANL_CAR_FCST_REF
                WHERE  1 = 1
                -- modified by ytchoi 180305  incoterms, fcst_type, dom_exp 조건 없어서 추가.
                AND    (
                          SELECT COUNT(1)
                          FROM   SCM_ADM_EXCEL_UPLOAD T
                          WHERE  T.PROGRAM_ID         = v_program_id
                          AND    T.SHEET_NAME         = v_sheet_name
                          --AND    T.CREATED_BY         = p_created_by
                          AND    TO_CHAR(T.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
                          AND    T.UPLOAD_STATUS_CODE = 'SUCCESS'
                          AND    DM_ANL_CAR_FCST_REF.DIVISION_ID           =  T.ATTRIBUTE1
                          AND    DM_ANL_CAR_FCST_REF.MAKER_NAME           =  T.ATTRIBUTE2
                          AND    DM_ANL_CAR_FCST_REF.CAR_MODEL         =  T.ATTRIBUTE3
                       ) > 0
                AND    YYYYQQ BETWEEN v_start_yyyymmdd AND v_end_yyyymmdd;

                -- -------------------------------------------------------------------------
                --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
                v_log_type := '20';
                v_log_message := '########## DELETE DM_ANL_CAR_FCST_REF DATE END ##########';
                v_description := p_mode; --TO_CHAR(v_creation_date, 'YYYY-MM-DD HH24:MI:SS.FF3');
                d_event_date := SYSDATE;
                PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
                -- -------------------------------------------------------------------------
            END;


            BEGIN
                INSERT INTO DM_ANL_CAR_FCST_REF (
                    DIVISION_ID
                  , END_CUSTOMER
                  , MAKER_NAME
                  , CAR_MODEL
                  , YYYYQQ
                  , P_QTY
                  , S_QTY
                  , I_QTY
                  , CREATED_BY
                  , CREATION_DATE
                  , LAST_UPDATED_BY
                  , LAST_UPDATE_DATE
                  , ATTRIBUTE1 --추가사용 필드 : Data Sourse
                  , ATTRIBUTE2 --추가사용 필드 : Basis Date
                )
                SELECT  V.ATTRIBUTE1 AS DIVISION
                      , ''
                      , V.ATTRIBUTE2 AS MAKER_NAME
                      , V.ATTRIBUTE3 AS CAR_MODEL
                      , C.YYYYQQ        AS YYYYQQ
                      , SUM(CASE WHEN V.ATTRIBUTE4 = 'P' THEN  TO_NUMBER(V.VALUE) ELSE 0 END) AS P_QTY
                      , SUM(CASE WHEN V.ATTRIBUTE4 = 'S' THEN  TO_NUMBER(V.VALUE) ELSE 0 END) AS S_QTY
                      , SUM(CASE WHEN V.ATTRIBUTE4 = 'I' THEN  TO_NUMBER(V.VALUE) ELSE 0 END) AS I_QTY
                      , p_created_by AS CREATED_BY
                      , TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3') AS CREATION_DATE
                      , p_created_by AS LAST_UPDATED_BY
                      , TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3') AS LAST_UPDATE_DATE
                      , MAX(V.ATTRIBUTE5) AS ATTRIBUTE1 --추가사용 필드 : 엑셀에서 업로드 한 Data Sourse
                      , MAX(V.ATTRIBUTE6) AS ATTRIBUTE2 --추가사용 필드 : 엑셀에서 업로드 한 Basis Date
                FROM  (SELECT ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, COLUMN_NAME, YYYYQQ, ATTRIBUTE5, ATTRIBUTE6
                       FROM   (SELECT ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
                                    , ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
                                    , ATTRIBUTE11, ATTRIBUTE12, ATTRIBUTE13, ATTRIBUTE14, ATTRIBUTE15
                                    , ATTRIBUTE16, ATTRIBUTE17, ATTRIBUTE18, ATTRIBUTE19, ATTRIBUTE20
                                    , ATTRIBUTE21, ATTRIBUTE22, ATTRIBUTE23, ATTRIBUTE24, ATTRIBUTE25
                                    , ATTRIBUTE26, ATTRIBUTE27, ATTRIBUTE28, ATTRIBUTE29, ATTRIBUTE30
                                    , ATTRIBUTE31, ATTRIBUTE32, ATTRIBUTE33, ATTRIBUTE34, ATTRIBUTE35
                                    , ATTRIBUTE36, ATTRIBUTE37, ATTRIBUTE38, ATTRIBUTE39, ATTRIBUTE40
                                    , ATTRIBUTE41, ATTRIBUTE42, ATTRIBUTE43, ATTRIBUTE44, ATTRIBUTE45
                                    , ATTRIBUTE46, ATTRIBUTE47, ATTRIBUTE48, ATTRIBUTE49, ATTRIBUTE50
                                    , ATTRIBUTE51, ATTRIBUTE52, ATTRIBUTE53, ATTRIBUTE54, ATTRIBUTE55
                                    , ATTRIBUTE56, ATTRIBUTE57, ATTRIBUTE58, ATTRIBUTE59, ATTRIBUTE60
                                    , ATTRIBUTE61, ATTRIBUTE62, ATTRIBUTE63, ATTRIBUTE64, ATTRIBUTE65
                                    , ATTRIBUTE66, ATTRIBUTE67, ATTRIBUTE68, ATTRIBUTE69, ATTRIBUTE70
                                    , ATTRIBUTE71, ATTRIBUTE72, ATTRIBUTE73, ATTRIBUTE74, ATTRIBUTE75
                                    , ATTRIBUTE76, ATTRIBUTE77, ATTRIBUTE78, ATTRIBUTE79, ATTRIBUTE80
                                    , ATTRIBUTE81, ATTRIBUTE82, ATTRIBUTE83, ATTRIBUTE84, ATTRIBUTE85
                                    , ATTRIBUTE86, ATTRIBUTE87, ATTRIBUTE88, ATTRIBUTE89, ATTRIBUTE90
                                    , ATTRIBUTE91, ATTRIBUTE92, ATTRIBUTE93, ATTRIBUTE94, ATTRIBUTE95
                                    , ATTRIBUTE96, ATTRIBUTE97, ATTRIBUTE98, ATTRIBUTE99, ATTRIBUTE100
                                    , ATTRIBUTE101, ATTRIBUTE102, ATTRIBUTE103, ATTRIBUTE104, ATTRIBUTE105
                                    , ATTRIBUTE106, ATTRIBUTE107, ATTRIBUTE108, ATTRIBUTE109, ATTRIBUTE110
                                    , ATTRIBUTE111, ATTRIBUTE112, ATTRIBUTE113, ATTRIBUTE114, ATTRIBUTE115
                                    , ATTRIBUTE116, ATTRIBUTE117, ATTRIBUTE118, ATTRIBUTE119, ATTRIBUTE120
                                    , ATTRIBUTE121, ATTRIBUTE122, ATTRIBUTE123, ATTRIBUTE124, ATTRIBUTE125
                                    , ATTRIBUTE126, ATTRIBUTE127, ATTRIBUTE128, ATTRIBUTE129, ATTRIBUTE130
                                    , ATTRIBUTE131, ATTRIBUTE132, ATTRIBUTE133, ATTRIBUTE134, ATTRIBUTE135
                                    , ATTRIBUTE136, ATTRIBUTE137, ATTRIBUTE138, ATTRIBUTE139, ATTRIBUTE140
                                    , ATTRIBUTE141, ATTRIBUTE142, ATTRIBUTE143, ATTRIBUTE144, ATTRIBUTE145
                                    , ATTRIBUTE146, ATTRIBUTE147, ATTRIBUTE148, ATTRIBUTE149, ATTRIBUTE150
                                    , ATTRIBUTE151, ATTRIBUTE152, ATTRIBUTE153, ATTRIBUTE154, ATTRIBUTE155
                                    , ATTRIBUTE156, ATTRIBUTE157, ATTRIBUTE158, ATTRIBUTE159, ATTRIBUTE160
                                    , ATTRIBUTE161, ATTRIBUTE162, ATTRIBUTE163, ATTRIBUTE164, ATTRIBUTE165
                                    , ATTRIBUTE166, ATTRIBUTE167, ATTRIBUTE168, ATTRIBUTE169, ATTRIBUTE170
                                    , ATTRIBUTE171, ATTRIBUTE172, ATTRIBUTE173, ATTRIBUTE174, ATTRIBUTE175
                                    , ATTRIBUTE176, ATTRIBUTE177, ATTRIBUTE178, ATTRIBUTE179, ATTRIBUTE180
                                    , ATTRIBUTE181, ATTRIBUTE182, ATTRIBUTE183, ATTRIBUTE184, ATTRIBUTE185
                                    , ATTRIBUTE186, ATTRIBUTE187, ATTRIBUTE188, ATTRIBUTE189, ATTRIBUTE190
                                    , ATTRIBUTE191, ATTRIBUTE192, ATTRIBUTE193, ATTRIBUTE194, ATTRIBUTE195
                                    , ATTRIBUTE196, ATTRIBUTE197, ATTRIBUTE198, ATTRIBUTE199, ATTRIBUTE200
                               FROM   SCM_ADM_EXCEL_UPLOAD
                               WHERE  1 = 1
                               AND    PROGRAM_ID    = v_program_id
                               AND    SHEET_NAME    = v_sheet_name
                               AND    CREATED_BY    = p_created_by
                               AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') =  v_creation_date
                               AND    UPLOAD_STATUS_CODE = '@TITLE'
                              ) T
                      UNPIVOT (    YYYYQQ
                               FOR COLUMN_NAME
                               IN   ( --ATTRIBUTE5
                                     --, ATTRIBUTE6,
                                     ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
                                     , ATTRIBUTE11, ATTRIBUTE12, ATTRIBUTE13, ATTRIBUTE14, ATTRIBUTE15
                                     , ATTRIBUTE16, ATTRIBUTE17, ATTRIBUTE18, ATTRIBUTE19, ATTRIBUTE20
                                     , ATTRIBUTE21, ATTRIBUTE22, ATTRIBUTE23, ATTRIBUTE24, ATTRIBUTE25
                                     , ATTRIBUTE26, ATTRIBUTE27, ATTRIBUTE28, ATTRIBUTE29, ATTRIBUTE30
                                     , ATTRIBUTE31, ATTRIBUTE32, ATTRIBUTE33, ATTRIBUTE34, ATTRIBUTE35
                                     , ATTRIBUTE36, ATTRIBUTE37, ATTRIBUTE38, ATTRIBUTE39, ATTRIBUTE40
                                     , ATTRIBUTE41, ATTRIBUTE42, ATTRIBUTE43, ATTRIBUTE44, ATTRIBUTE45
                                     , ATTRIBUTE46, ATTRIBUTE47, ATTRIBUTE48, ATTRIBUTE49, ATTRIBUTE50
                                     , ATTRIBUTE51, ATTRIBUTE52, ATTRIBUTE53, ATTRIBUTE54, ATTRIBUTE55
                                     , ATTRIBUTE56, ATTRIBUTE57, ATTRIBUTE58, ATTRIBUTE59, ATTRIBUTE60
                                     , ATTRIBUTE61, ATTRIBUTE62, ATTRIBUTE63, ATTRIBUTE64, ATTRIBUTE65
                                     , ATTRIBUTE66, ATTRIBUTE67, ATTRIBUTE68, ATTRIBUTE69, ATTRIBUTE70
                                     , ATTRIBUTE71, ATTRIBUTE72, ATTRIBUTE73, ATTRIBUTE74, ATTRIBUTE75
                                     , ATTRIBUTE76, ATTRIBUTE77, ATTRIBUTE78, ATTRIBUTE79, ATTRIBUTE80
                                     , ATTRIBUTE81, ATTRIBUTE82, ATTRIBUTE83, ATTRIBUTE84, ATTRIBUTE85
                                     , ATTRIBUTE86, ATTRIBUTE87, ATTRIBUTE88, ATTRIBUTE89, ATTRIBUTE90
                                     , ATTRIBUTE91, ATTRIBUTE92, ATTRIBUTE93, ATTRIBUTE94, ATTRIBUTE95
                                     , ATTRIBUTE96, ATTRIBUTE97, ATTRIBUTE98, ATTRIBUTE99, ATTRIBUTE100
                                     , ATTRIBUTE101, ATTRIBUTE102, ATTRIBUTE103, ATTRIBUTE104, ATTRIBUTE105
                                     , ATTRIBUTE106, ATTRIBUTE107, ATTRIBUTE108, ATTRIBUTE109, ATTRIBUTE110
                                     , ATTRIBUTE111, ATTRIBUTE112, ATTRIBUTE113, ATTRIBUTE114, ATTRIBUTE115
                                     , ATTRIBUTE116, ATTRIBUTE117, ATTRIBUTE118, ATTRIBUTE119, ATTRIBUTE120
                                     , ATTRIBUTE121, ATTRIBUTE122, ATTRIBUTE123, ATTRIBUTE124, ATTRIBUTE125
                                     , ATTRIBUTE126, ATTRIBUTE127, ATTRIBUTE128, ATTRIBUTE129, ATTRIBUTE130
                                     , ATTRIBUTE131, ATTRIBUTE132, ATTRIBUTE133, ATTRIBUTE134, ATTRIBUTE135
                                     , ATTRIBUTE136, ATTRIBUTE137, ATTRIBUTE138, ATTRIBUTE139, ATTRIBUTE140
                                     , ATTRIBUTE141, ATTRIBUTE142, ATTRIBUTE143, ATTRIBUTE144, ATTRIBUTE145
                                     , ATTRIBUTE146, ATTRIBUTE147, ATTRIBUTE148, ATTRIBUTE149, ATTRIBUTE150
                                     , ATTRIBUTE151, ATTRIBUTE152, ATTRIBUTE153, ATTRIBUTE154, ATTRIBUTE155
                                     , ATTRIBUTE156, ATTRIBUTE157, ATTRIBUTE158, ATTRIBUTE159, ATTRIBUTE160
                                     , ATTRIBUTE161, ATTRIBUTE162, ATTRIBUTE163, ATTRIBUTE164, ATTRIBUTE165
                                     , ATTRIBUTE166, ATTRIBUTE167, ATTRIBUTE168, ATTRIBUTE169, ATTRIBUTE170
                                     , ATTRIBUTE171, ATTRIBUTE172, ATTRIBUTE173, ATTRIBUTE174, ATTRIBUTE175
                                     , ATTRIBUTE176, ATTRIBUTE177, ATTRIBUTE178, ATTRIBUTE179, ATTRIBUTE180
                                     , ATTRIBUTE181, ATTRIBUTE182, ATTRIBUTE183, ATTRIBUTE184, ATTRIBUTE185
                                     , ATTRIBUTE186, ATTRIBUTE187, ATTRIBUTE188, ATTRIBUTE189, ATTRIBUTE190
                                     , ATTRIBUTE191, ATTRIBUTE192, ATTRIBUTE193, ATTRIBUTE194, ATTRIBUTE195
                                     , ATTRIBUTE196, ATTRIBUTE197, ATTRIBUTE198, ATTRIBUTE199, ATTRIBUTE200
                                    )
                              ) X
                      ) C
                    , (SELECT ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, COLUMN_NAME, VALUE, ATTRIBUTE5, ATTRIBUTE6
                       FROM   (SELECT ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
                                    , ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
                                    , ATTRIBUTE11, ATTRIBUTE12, ATTRIBUTE13, ATTRIBUTE14, ATTRIBUTE15
                                    , ATTRIBUTE16, ATTRIBUTE17, ATTRIBUTE18, ATTRIBUTE19, ATTRIBUTE20
                                    , ATTRIBUTE21, ATTRIBUTE22, ATTRIBUTE23, ATTRIBUTE24, ATTRIBUTE25
                                    , ATTRIBUTE26, ATTRIBUTE27, ATTRIBUTE28, ATTRIBUTE29, ATTRIBUTE30
                                    , ATTRIBUTE31, ATTRIBUTE32, ATTRIBUTE33, ATTRIBUTE34, ATTRIBUTE35
                                    , ATTRIBUTE36, ATTRIBUTE37, ATTRIBUTE38, ATTRIBUTE39, ATTRIBUTE40
                                    , ATTRIBUTE41, ATTRIBUTE42, ATTRIBUTE43, ATTRIBUTE44, ATTRIBUTE45
                                    , ATTRIBUTE46, ATTRIBUTE47, ATTRIBUTE48, ATTRIBUTE49, ATTRIBUTE50
                                    , ATTRIBUTE51, ATTRIBUTE52, ATTRIBUTE53, ATTRIBUTE54, ATTRIBUTE55
                                    , ATTRIBUTE56, ATTRIBUTE57, ATTRIBUTE58, ATTRIBUTE59, ATTRIBUTE60
                                    , ATTRIBUTE61, ATTRIBUTE62, ATTRIBUTE63, ATTRIBUTE64, ATTRIBUTE65
                                    , ATTRIBUTE66, ATTRIBUTE67, ATTRIBUTE68, ATTRIBUTE69, ATTRIBUTE70
                                    , ATTRIBUTE71, ATTRIBUTE72, ATTRIBUTE73, ATTRIBUTE74, ATTRIBUTE75
                                    , ATTRIBUTE76, ATTRIBUTE77, ATTRIBUTE78, ATTRIBUTE79, ATTRIBUTE80
                                    , ATTRIBUTE81, ATTRIBUTE82, ATTRIBUTE83, ATTRIBUTE84, ATTRIBUTE85
                                    , ATTRIBUTE86, ATTRIBUTE87, ATTRIBUTE88, ATTRIBUTE89, ATTRIBUTE90
                                    , ATTRIBUTE91, ATTRIBUTE92, ATTRIBUTE93, ATTRIBUTE94, ATTRIBUTE95
                                    , ATTRIBUTE96, ATTRIBUTE97, ATTRIBUTE98, ATTRIBUTE99, ATTRIBUTE100
                                    , ATTRIBUTE101, ATTRIBUTE102, ATTRIBUTE103, ATTRIBUTE104, ATTRIBUTE105
                                    , ATTRIBUTE106, ATTRIBUTE107, ATTRIBUTE108, ATTRIBUTE109, ATTRIBUTE110
                                    , ATTRIBUTE111, ATTRIBUTE112, ATTRIBUTE113, ATTRIBUTE114, ATTRIBUTE115
                                    , ATTRIBUTE116, ATTRIBUTE117, ATTRIBUTE118, ATTRIBUTE119, ATTRIBUTE120
                                    , ATTRIBUTE121, ATTRIBUTE122, ATTRIBUTE123, ATTRIBUTE124, ATTRIBUTE125
                                    , ATTRIBUTE126, ATTRIBUTE127, ATTRIBUTE128, ATTRIBUTE129, ATTRIBUTE130
                                    , ATTRIBUTE131, ATTRIBUTE132, ATTRIBUTE133, ATTRIBUTE134, ATTRIBUTE135
                                    , ATTRIBUTE136, ATTRIBUTE137, ATTRIBUTE138, ATTRIBUTE139, ATTRIBUTE140
                                    , ATTRIBUTE141, ATTRIBUTE142, ATTRIBUTE143, ATTRIBUTE144, ATTRIBUTE145
                                    , ATTRIBUTE146, ATTRIBUTE147, ATTRIBUTE148, ATTRIBUTE149, ATTRIBUTE150
                                    , ATTRIBUTE151, ATTRIBUTE152, ATTRIBUTE153, ATTRIBUTE154, ATTRIBUTE155
                                    , ATTRIBUTE156, ATTRIBUTE157, ATTRIBUTE158, ATTRIBUTE159, ATTRIBUTE160
                                    , ATTRIBUTE161, ATTRIBUTE162, ATTRIBUTE163, ATTRIBUTE164, ATTRIBUTE165
                                    , ATTRIBUTE166, ATTRIBUTE167, ATTRIBUTE168, ATTRIBUTE169, ATTRIBUTE170
                                    , ATTRIBUTE171, ATTRIBUTE172, ATTRIBUTE173, ATTRIBUTE174, ATTRIBUTE175
                                    , ATTRIBUTE176, ATTRIBUTE177, ATTRIBUTE178, ATTRIBUTE179, ATTRIBUTE180
                                    , ATTRIBUTE181, ATTRIBUTE182, ATTRIBUTE183, ATTRIBUTE184, ATTRIBUTE185
                                    , ATTRIBUTE186, ATTRIBUTE187, ATTRIBUTE188, ATTRIBUTE189, ATTRIBUTE190
                                    , ATTRIBUTE191, ATTRIBUTE192, ATTRIBUTE193, ATTRIBUTE194, ATTRIBUTE195
                                    , ATTRIBUTE196, ATTRIBUTE197, ATTRIBUTE198, ATTRIBUTE199, ATTRIBUTE200
                               FROM   SCM_ADM_EXCEL_UPLOAD
                               WHERE  1 = 1
                               AND    PROGRAM_ID    = v_program_id
                               AND    SHEET_NAME    = v_sheet_name
                               AND    CREATED_BY    = p_created_by
                               AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
                               AND    UPLOAD_STATUS_CODE = 'SUCCESS'
                              ) T
                      UNPIVOT (    VALUE
                               FOR COLUMN_NAME
                               IN   ( --ATTRIBUTE5
                                     --, ATTRIBUTE6,
                                     ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
                                     , ATTRIBUTE11, ATTRIBUTE12, ATTRIBUTE13, ATTRIBUTE14, ATTRIBUTE15
                                     , ATTRIBUTE16, ATTRIBUTE17, ATTRIBUTE18, ATTRIBUTE19, ATTRIBUTE20
                                     , ATTRIBUTE21, ATTRIBUTE22, ATTRIBUTE23, ATTRIBUTE24, ATTRIBUTE25
                                     , ATTRIBUTE26, ATTRIBUTE27, ATTRIBUTE28, ATTRIBUTE29, ATTRIBUTE30
                                     , ATTRIBUTE31, ATTRIBUTE32, ATTRIBUTE33, ATTRIBUTE34, ATTRIBUTE35
                                     , ATTRIBUTE36, ATTRIBUTE37, ATTRIBUTE38, ATTRIBUTE39, ATTRIBUTE40
                                     , ATTRIBUTE41, ATTRIBUTE42, ATTRIBUTE43, ATTRIBUTE44, ATTRIBUTE45
                                     , ATTRIBUTE46, ATTRIBUTE47, ATTRIBUTE48, ATTRIBUTE49, ATTRIBUTE50
                                     , ATTRIBUTE51, ATTRIBUTE52, ATTRIBUTE53, ATTRIBUTE54, ATTRIBUTE55
                                     , ATTRIBUTE56, ATTRIBUTE57, ATTRIBUTE58, ATTRIBUTE59, ATTRIBUTE60
                                     , ATTRIBUTE61, ATTRIBUTE62, ATTRIBUTE63, ATTRIBUTE64, ATTRIBUTE65
                                     , ATTRIBUTE66, ATTRIBUTE67, ATTRIBUTE68, ATTRIBUTE69, ATTRIBUTE70
                                     , ATTRIBUTE71, ATTRIBUTE72, ATTRIBUTE73, ATTRIBUTE74, ATTRIBUTE75
                                     , ATTRIBUTE76, ATTRIBUTE77, ATTRIBUTE78, ATTRIBUTE79, ATTRIBUTE80
                                     , ATTRIBUTE81, ATTRIBUTE82, ATTRIBUTE83, ATTRIBUTE84, ATTRIBUTE85
                                     , ATTRIBUTE86, ATTRIBUTE87, ATTRIBUTE88, ATTRIBUTE89, ATTRIBUTE90
                                     , ATTRIBUTE91, ATTRIBUTE92, ATTRIBUTE93, ATTRIBUTE94, ATTRIBUTE95
                                     , ATTRIBUTE96, ATTRIBUTE97, ATTRIBUTE98, ATTRIBUTE99, ATTRIBUTE100
                                     , ATTRIBUTE101, ATTRIBUTE102, ATTRIBUTE103, ATTRIBUTE104, ATTRIBUTE105
                                     , ATTRIBUTE106, ATTRIBUTE107, ATTRIBUTE108, ATTRIBUTE109, ATTRIBUTE110
                                     , ATTRIBUTE111, ATTRIBUTE112, ATTRIBUTE113, ATTRIBUTE114, ATTRIBUTE115
                                     , ATTRIBUTE116, ATTRIBUTE117, ATTRIBUTE118, ATTRIBUTE119, ATTRIBUTE120
                                     , ATTRIBUTE121, ATTRIBUTE122, ATTRIBUTE123, ATTRIBUTE124, ATTRIBUTE125
                                     , ATTRIBUTE126, ATTRIBUTE127, ATTRIBUTE128, ATTRIBUTE129, ATTRIBUTE130
                                     , ATTRIBUTE131, ATTRIBUTE132, ATTRIBUTE133, ATTRIBUTE134, ATTRIBUTE135
                                     , ATTRIBUTE136, ATTRIBUTE137, ATTRIBUTE138, ATTRIBUTE139, ATTRIBUTE140
                                     , ATTRIBUTE141, ATTRIBUTE142, ATTRIBUTE143, ATTRIBUTE144, ATTRIBUTE145
                                     , ATTRIBUTE146, ATTRIBUTE147, ATTRIBUTE148, ATTRIBUTE149, ATTRIBUTE150
                                     , ATTRIBUTE151, ATTRIBUTE152, ATTRIBUTE153, ATTRIBUTE154, ATTRIBUTE155
                                     , ATTRIBUTE156, ATTRIBUTE157, ATTRIBUTE158, ATTRIBUTE159, ATTRIBUTE160
                                     , ATTRIBUTE161, ATTRIBUTE162, ATTRIBUTE163, ATTRIBUTE164, ATTRIBUTE165
                                     , ATTRIBUTE166, ATTRIBUTE167, ATTRIBUTE168, ATTRIBUTE169, ATTRIBUTE170
                                     , ATTRIBUTE171, ATTRIBUTE172, ATTRIBUTE173, ATTRIBUTE174, ATTRIBUTE175
                                     , ATTRIBUTE176, ATTRIBUTE177, ATTRIBUTE178, ATTRIBUTE179, ATTRIBUTE180
                                     , ATTRIBUTE181, ATTRIBUTE182, ATTRIBUTE183, ATTRIBUTE184, ATTRIBUTE185
                                     , ATTRIBUTE186, ATTRIBUTE187, ATTRIBUTE188, ATTRIBUTE189, ATTRIBUTE190
                                     , ATTRIBUTE191, ATTRIBUTE192, ATTRIBUTE193, ATTRIBUTE194, ATTRIBUTE195
                                     , ATTRIBUTE196, ATTRIBUTE197, ATTRIBUTE198, ATTRIBUTE199, ATTRIBUTE200
                                    )
                                ) X
                      ) V
                      /*,(
                          SELECTATTRIBUTE5, ATTRIBUTE6
                                   FROM   SCM_ADM_EXCEL_UPLOAD
                                   WHERE  1 = 1
                                   AND    PROGRAM_ID    = v_program_id
                                   AND    SHEET_NAME    = v_sheet_name
                                   AND    CREATED_BY    = p_created_by
                                   AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
                                   AND    UPLOAD_STATUS_CODE = 'SUCCESS'
                      ) Y*/
                WHERE 1 = 1
                AND   C.COLUMN_NAME = V.COLUMN_NAME
                AND   C.YYYYQQ IS NOT NULL
                AND   V.VALUE IS NOT NULL
                GROUP BY V.ATTRIBUTE1, V.ATTRIBUTE2, V.ATTRIBUTE3, C.YYYYQQ --    , V.ATTRIBUTE5, V.ATTRIBUTE6
                ORDER BY YYYYQQ
                FETCH FIRST 1 ROWS ONLY;
            END;

            -- -------------------------------------------------------------------------
            --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
            v_log_type := '21';
            v_log_message := '########## INSERT INTO DM_ANL_CAR_FCST_REF DATE END ##########';
            v_description := p_mode; --TO_CHAR(v_creation_date, 'YYYY-MM-DD HH24:MI:SS.FF3');
            d_event_date := SYSDATE;
            PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
            -- -------------------------------------------------------------------------

            COMMIT WORK;

            EXCEPTION
                WHEN OTHERS THEN
                    ROLLBACK;
        END;
    END IF;

    BEGIN
        -- -------------------------------------------------------------------------
        --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
        v_log_type := 'END';
        v_log_message := '########## INSERT INTO DATA END ##########';
        v_description := p_mode; --TO_CHAR(v_creation_date, 'YYYY-MM-DD HH24:MI:SS.FF3');
        d_event_date := SYSDATE;
        PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        -- -------------------------------------------------------------------------
    END;

END;
/
