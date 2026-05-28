-- ============================================================================
-- ARCHIVED: 다음 SP들은 PKG_DMF0003 에 이미 등록되어 있어 standalone에서 제거됨
--          PKG 호출 권장: SCM_MGR.PKG_DMF0003.P_{SP_NAME}
-- ============================================================================


-- DMF0003_CAR_FCST_EXCEL_UPLOAD → PKG_DMF0003.P_DMF0003_CAR_FCST_EXCEL_UPLOAD에 등록됨
CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0003_CAR_FCST_EXCEL_UPLOAD (
    p_mode       IN INTEGER,
    p_created_by IN VARCHAR2
)
AS
    v_program_id VARCHAR2(40 CHAR) := 'DMF0003';
    v_sheet_name VARCHAR2(40 CHAR) := 'Car Fcst';
    v_sql_text VARCHAR2(4000 CHAR);
    v_creation_date VARCHAR2(40 CHAR);
    v_count INTEGER;
    v_start_yyyymmdd VARCHAR2(8 CHAR);
    v_end_yyyymmdd VARCHAR2(8 CHAR);
    v_division VARCHAR2(10 CHAR);
    v_program_name VARCHAR2(150 CHAR) := 'DMF0003_CAR_FCST_EXCEL_UPLOAD';
    v_log_type VARCHAR2(30 CHAR);
    n_log_count INTEGER := 0;
    v_log_message VARCHAR2(1000 CHAR);
    v_description VARCHAR2(500 CHAR);
    d_event_date DATE;
BEGIN 
    -- LOG 용 변수 설정
    v_log_type := 'START';
    v_log_message := '########## Start of procedure ##########';
    v_description := NULL;
    d_event_date := SYSTIMESTAMP;
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
        d_event_date := SYSTIMESTAMP;
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
            d_event_date := SYSTIMESTAMP;
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
            d_event_date := SYSTIMESTAMP;
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
            d_event_date := SYSTIMESTAMP;
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
            d_event_date := SYSTIMESTAMP;
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
            d_event_date := SYSTIMESTAMP;
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
            d_event_date := SYSTIMESTAMP;
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
        d_event_date := SYSTIMESTAMP;
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
            d_event_date := SYSTIMESTAMP;
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
            d_event_date := SYSTIMESTAMP;
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
                d_event_date := SYSTIMESTAMP;
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
                d_event_date := SYSTIMESTAMP;
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
            d_event_date := SYSTIMESTAMP;
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
        d_event_date := SYSTIMESTAMP;
        PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        -- -------------------------------------------------------------------------
    END;
    
END;
/

-- DMF0003_GET_BUCKET_TYPE_CODE → PKG_DMF0003.P_DMF0003_GET_BUCKET_TYPE_CODE에 등록됨
CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0003_GET_BUCKET_TYPE_CODE
AS

    p_end_week VARCHAR2(6 CHAR);
BEGIN


  SELECT L.SEGMENT1  AS CODE
       , L.SEGMENT2  AS NAME
  FROM   SCM_ADM_LOOKUP_MASTER_DETAIL L
  WHERE  L.LOOKUP_TYPE = 'BUCKET_TYPE_CODE'
  AND    L.VALID_YN    = 'Y'
  ORDER BY DISPLAY_SEQ;

END;
/

-- DMF0003_GET_DM_ANL_CAR_PROPERTY → PKG_DMF0003.P_DMF0003_GET_DM_ANL_CAR_PROPERTY에 등록됨
CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0003_GET_DM_ANL_CAR_PROPERTY
(
	p_division_id	VARCHAR2,
	p_maker_name	VARCHAR2
)
AS
BEGIN
		IF(p_maker_name IS NULL) THEN
		BEGIN
			SELECT DISTINCT MAKER_NAME AS CODE, MAKER_NAME AS NAME FROM DM_ANL_CAR_FCST_REF ORDER BY MAKER_NAME
		END;

		BEGIN
			SELECT DISTINCT CAR_MODEL AS CODE, CAR_MODEL AS NAME FROM DM_ANL_CAR_FCST_REF ORDER BY CAR_MODEL
		END;

		BEGIN
		   SELECT 'CELL' AS CODE, 'CELL' AS NAME
		   UNION
		   SELECT 'MODULE' AS CODE, 'MODULE' AS NAME
		   UNION
		   SELECT 'PACK' AS CODE, 'PACK' AS NAME
		END;


	ELSE
		SELECT DISTINCT CAR_MODEL AS CODE, CAR_MODEL AS NAME FROM DM_ANL_CAR_FCST_REF WHERE MAKER_NAME = p_maker_name
		ORDER BY CAR_MODEL;
	END IF;



END;
/

-- DMF0003_GET_DM_ANL_CAR_REF → PKG_DMF0003.P_DMF0003_GET_DM_ANL_CAR_REF에 등록됨
CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0003_GET_DM_ANL_CAR_REF
(
	p_from_yyyymmdd	VARCHAR2,
	p_to_yyyymmdd	    VARCHAR2,
	p_car_maker        VARCHAR2,
	p_car_model	    VARCHAR2
)
AS

--DMF0003_GET_DM_ANL_CAR_REF '20230701', '20240630', 'FORD', 'Ford Mustang Mach-E BEV'

    p_from_yyyyQQ VARCHAR2(6 CHAR);
    p_to_yyyyQQ VARCHAR2(6 CHAR);
    V_COLUMNS VARCHAR2(4000 CHAR);
    V_SQL VARCHAR2(4000 CHAR);
    V_SQL0 VARCHAR2(4000 CHAR);
    V_SQL1 VARCHAR2(4000 CHAR);
    V_SQL2 VARCHAR2(4000 CHAR);
    V_SQL3 VARCHAR2(4000 CHAR);
    V_SQL4 VARCHAR2(4000 CHAR);
    V_SQL5 VARCHAR2(4000 CHAR);
    V_SQL6 VARCHAR2(4000 CHAR);
    V_SQL7 VARCHAR2(4000 CHAR);
EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DMF0_DATA';

BEGIN
		SELECT p_from_yyyyQQ = CALENDAR_YYYYQQ FROM SCM_SYS_CALENDAR_M WHERE BASIS_YYYYMMDD = p_from_yyyymmdd
	SELECT p_to_yyyyQQ = CALENDAR_YYYYQQ FROM SCM_SYS_CALENDAR_M WHERE BASIS_YYYYMMDD = p_to_yyyymmdd

	DBMS_OUTPUT.PUT_LINE(p_from_yyyyQQ);
	DBMS_OUTPUT.PUT_LINE(p_to_yyyyQQ);
	DBMS_OUTPUT.PUT_LINE(p_car_maker);

	SELECT DISTINCT YYYYQQ FROM DM_ANL_CAR_FCST_REF WHERE YYYYQQ BETWEEN p_from_yyyyQQ AND p_to_yyyyQQ ORDER BY YYYYQQ ASC

	V_COLUMNS := NULL
	SELECT V_COLUMNS  ||  '['  ||  YYYYQQ  ||  ']
  INTO V_COLUMNS
	FROM
	(SELECT DISTINCT YYYYQQ FROM DM_ANL_CAR_FCST_REF WHERE YYYYQQ BETWEEN p_from_yyyyQQ AND p_to_yyyyQQ) YYYYQQ
	ORDER BY YYYYQQ;



	IF (p_car_maker IS NOT NULL AND p_car_modelIS NOT NULL) THEN
		INSERT INTO GT_DMF0_DATA
		SELECT MAKER_NAME,CAR_MODEL,YYYYQQ,P_QTY,S_QTY,I_QTY  FROM DM_ANL_CAR_FCST_REF  WHERE 1=1
		AND YYYYQQ BETWEEN p_from_yyyyQQ AND p_to_yyyyQQ
		AND MAKER_NAME = p_car_maker
		AND CAR_MODEL = p_car_model;
	ELSIF (p_car_maker IS NOT NULL AND p_car_model IS NULL) THEN
		INSERT INTO GT_DMF0_DATA
		SELECT MAKER_NAME,CAR_MODEL,YYYYQQ,P_QTY,S_QTY,I_QTY FROM DM_ANL_CAR_FCST_REF  WHERE 1=1
		AND YYYYQQ BETWEEN p_from_yyyyQQ AND p_to_yyyyQQ
		AND MAKER_NAME = p_car_maker;
	END IF;

	--SELECT * FROM GT_DMF0_DATA

V_COLUMNS := SUBSTR(V_COLUMNS, 1, LENGTH(V_COLUMNS) - 1);

V_SQL := '
SELECT * FROM(
	SELECT *, ''차량대수별'' AS MAJOR_CAT, ''P) 차량생산[R || P]'' AS MINOR_CAT FROM(
	SELECT * FROM (SELECT MAKER_NAME, CAR_MODEL, YYYYQQ, P_QTY FROM GT_DMF0_DATA) RESULT PIVOT (SUM(P_QTY) FOR YYYYQQ IN (' + V_COLUMNS + ')) AS PIVOT_RESULT
	) A;
	UNION ALL
	SELECT *,  ''차량대수별'' AS MAJOR_CAT, ''S) 차량판매[R || P]'' AS MINOR_CAT FROM(
	SELECT * FROM (SELECT MAKER_NAME, CAR_MODEL, YYYYQQ, S_QTY FROM GT_DMF0_DATA) RESULT PIVOT (SUM(S_QTY) FOR YYYYQQ IN (' + V_COLUMNS + ')) AS PIVOT_RESULT
	) A;
	UNION ALL
	SELECT *,  ''차량대수별'' AS MAJOR_CAT, ''I) 누적차량재고[R || P]'' AS MINOR_CAT FROM(
	SELECT * FROM (SELECT MAKER_NAME, CAR_MODEL, YYYYQQ, I_QTY FROM GT_DMF0_DATA) RESULT PIVOT (SUM(I_QTY) FOR YYYYQQ IN (' + V_COLUMNS + ')) AS PIVOT_RESULT
	) A;
) AA ORDER BY AA.MAKER_NAME, AA.CAR_MODEL
'

V_SQL0 := 'SELECT * FROM(';

V_SQL1 := '
	SELECT *, ''차량대수별'' AS MAJOR_CAT, ''P) 차량생산[R || P]'' AS MINOR_CAT FROM(
	SELECT * FROM (SELECT MAKER_NAME, CAR_MODEL, YYYYQQ, P_QTY FROM GT_DMF0_DATA) RESULT PIVOT (SUM(P_QTY) FOR YYYYQQ IN (' + V_COLUMNS + ')) AS PIVOT_RESULT
	) A;
	UNION ALL
'
V_SQL2 := '
	SELECT *,  ''차량대수별'' AS MAJOR_CAT, ''S) 차량판매[R || P]'' AS MINOR_CAT FROM(
	SELECT * FROM (SELECT MAKER_NAME, CAR_MODEL, YYYYQQ, S_QTY FROM GT_DMF0_DATA) RESULT PIVOT (SUM(S_QTY) FOR YYYYQQ IN (' + V_COLUMNS + ')) AS PIVOT_RESULT
	) A;
	UNION ALL
'
V_SQL3 := '
	SELECT *,  ''차량대수별'' AS MAJOR_CAT, ''I) 누적차량재고[R || P]'' AS MINOR_CAT FROM(
	SELECT * FROM (SELECT MAKER_NAME, CAR_MODEL, YYYYQQ, I_QTY FROM GT_DMF0_DATA) RESULT PIVOT (SUM(I_QTY) FOR YYYYQQ IN (' + V_COLUMNS + ')) AS PIVOT_RESULT
	) A;
	UNION ALL
'
V_SQL4 := '
	SELECT *,  ''BIZ단위환산'' AS MAJOR_CAT, ''P) 차량생산[R || P]'' AS MINOR_CAT FROM(
	SELECT * FROM (SELECT MAKER_NAME, CAR_MODEL, YYYYQQ, 0 P_QTY FROM GT_DMF0_DATA) RESULT PIVOT (SUM(P_QTY) FOR YYYYQQ IN (' + V_COLUMNS + ')) AS PIVOT_RESULT
	) A;
	UNION ALL
'
V_SQL5 := '
	SELECT *,  ''BIZ단위환산'' AS MAJOR_CAT, ''S) 차량판매[R || P]'' AS MINOR_CAT FROM(
	SELECT * FROM (SELECT MAKER_NAME, CAR_MODEL, YYYYQQ, 0 S_QTY FROM GT_DMF0_DATA) RESULT PIVOT (SUM(S_QTY) FOR YYYYQQ IN (' + V_COLUMNS + ')) AS PIVOT_RESULT
	) A;
	UNION ALL
'
V_SQL6 := '
	SELECT *,  ''BIZ단위환산'' AS MAJOR_CAT, ''I) 누적차량재고[R || P]'' AS MINOR_CAT FROM(
	SELECT * FROM (SELECT MAKER_NAME, CAR_MODEL, YYYYQQ, 0 I_QTY FROM GT_DMF0_DATA) RESULT PIVOT (SUM(I_QTY) FOR YYYYQQ IN (' + V_COLUMNS + ')) AS PIVOT_RESULT
	) A;
'

V_SQL7 := ') AA ORDER BY AA.MAKER_NAME, AA.CAR_MODEL';

EXEC(V_SQL0 || V_SQL1 || V_SQL2 || V_SQL3 || V_SQL4 || V_SQL5 || V_SQL6 || V_SQL7)
--EXEC(V_SQL0+V_SQL1+V_SQL2+V_SQL3+V_SQL7)

--엑셀 추가정보 조회
--SELECT DISTINCT ATTRIBUTE1, ATTRIBUTE2
SELECT
MAX(ATTRIBUTE1) ATTRIBUTE1 --Data Source
, MAX(ATTRIBUTE2) ATTRIBUTE2 --Basis Date
FROM DM_ANL_CAR_FCST_REF
WHERE CREATION_DATE =
(
	SELECT MAX(CREATION_DATE)
	FROM DM_ANL_CAR_FCST_REF
	WHERE 1=1
	AND YYYYQQ BETWEEN p_from_yyyyQQ AND p_to_yyyyQQ
	AND MAKER_NAME = p_car_maker
	AND CAR_MODEL = p_car_model
)
AND YYYYQQ BETWEEN p_from_yyyyQQ AND p_to_yyyyQQ
AND MAKER_NAME = p_car_maker
AND CAR_MODEL = p_car_model
		/*

		SELECT DISTINCT ATTRIBUTE1, ATTRIBUTE2
		FROM DM_ANL_CAR_FCST_REF
		WHERE CREATION_DATE =
		(
			SELECT MAX(CREATION_DATE)
			FROM DM_ANL_CAR_FCST_REF
			WHERE MAKER_NAME = 'Ford'
			AND CAR_MODEL = 'Ford Mustang Mach-E BEV'
		)

		SELECT*
		FROM DM_ANL_CAR_FCST_REF
		WHERE MAKER_NAME = 'Ford'
		AND CAR_MODEL = 'Ford Mustang Mach-E BEV'
		ORDER BY CREATION_DATE DESC;
		*/

FETCH FIRST 100 ROWS ONLY
END;

--DMF0003_GET_DM_ANL_CAR_REF '20210301', '20230701', 'BMW', ''

DROP TABLE GT_DMF0_DATA;
/

-- DMF0003_GET_DM_ANL_MKT_PSI_DPINIT → PKG_DMF0003.P_DMF0003_GET_DM_ANL_MKT_PSI_DPINIT에 등록됨
CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0003_GET_DM_ANL_MKT_PSI_DPINIT
(
	p_division_id	VARCHAR2,
    p_project_code    VARCHAR2,
	p_yyyymm    VARCHAR2,
	p_created_by	VARCHAR2,
    p_end_customer VARCHAR2
)
AS
BEGIN
		-- CREATE TABLE GT_DMF0_DATA(
	--   PROJECT_CODE              VARCHAR2(30 CHAR) NOT NULL,
	--   YYYYMM          VARCHAR2(6 CHAR)  NOT NULL,
	--   MKT_FCST          VARCHAR2(30 CHAR) NOT NULL,
	--   IN_DE_VOL         VARCHAR2(30 CHAR) NULL,
	--   IMPUTATION_YN         VARCHAR2(30 CHAR) NULL,
	--   DEMAND_OPERATION         VARCHAR2(30 CHAR) NULL,
	--   VARIATION_FACTOR        VARCHAR2(30 CHAR) NULL,
	--   DESC          VARCHAR2(4000 CHAR) NULL,
	--   IN_DE_DEMAND         VARCHAR2(30 CHAR) NULL,
	--   IN_DDAY      VARCHAR2(30 CHAR) NULL,
	--   DE_PL            VARCHAR2(30 CHAR) NULL,
	--   )

	--    V_CNT INTEGER := 0, v_i INTEGER =  1;
	--    v_yyyymm VARCHAR2(20 CHAR);
	--v_i := -12

    --WHILE v_i <= 0
	BEGIN

		--BEGIN
		--	SELECT V_CNT = COUNT(*) FROM DM_ANL_MKT_PSI_DETAIL WHERE 1=1
		--	   AND DIVISION_ID = p_division_id
		--	   AND PROJECT_CODE = p_project_code
		--	   AND MEASURE = 'DP_INIT'

		--	   AND YYYYMM = TO_CHAR(ADD_MONTHS(p_yyyymm + '01', v_i), 'YYYYMMDD')
		--END

		--IF (V_CNT = 0)
		--BEGIN
		--	BEGIN
		--		INSERT INTO GT_DMF0_DATA
		--		SELECT p_project_code, TO_CHAR(ADD_MONTHS(p_yyyymm + '01', v_i), 'YYYYMMDD'), 0, 0, '고객', '수요', '차량생산', '', 0, '', 0
		--	END
		--	BEGIN
		--		INSERT INTO GT_DMF0_DATA
		--		SELECT p_project_code, TO_CHAR(ADD_MONTHS(p_yyyymm + '01', v_i), 'YYYYMMDD'), 0, 0, '고객', '수요', '차량판매', '', 0, '', 0
		--	END
		--	BEGIN
		--		INSERT INTO GT_DMF0_DATA
		--		SELECT p_project_code, TO_CHAR(ADD_MONTHS(p_yyyymm + '01', v_i), 'YYYYMMDD'), 0, 0, '고객', '수요', '물류이슈', '', 0, '', 0
		--	END
		--	BEGIN
		--		INSERT INTO GT_DMF0_DATA
		--		SELECT p_project_code, TO_CHAR(ADD_MONTHS(p_yyyymm + '01', v_i), 'YYYYMMDD'), 0, 0, '당사', '운영', '시점조정', '', 0, '', 0
		--	END
		--	BEGIN
		--		INSERT INTO GT_DMF0_DATA
		--		SELECT p_project_code, TO_CHAR(ADD_MONTHS(p_yyyymm + '01', v_i), 'YYYYMMDD'), 0, 0, '당사', '운영', '모델믹스', '', 0, '', 0
		--	END
		--END
		--ELSE
		BEGIN

		-- 수요계획 1st 조회 쿼리
		--INSERT INTO GT_DMF0_DATA
		-- wbs 주석
		/*
		SELECT PROJECT_CODE
			 , YYYYMM
			 , TO_NUMBER(CUST_FCST_M) AS MKT_FCST
			 , TO_NUMBER(QTY) AS IN_DE_VOL
			 , CASE QTYCD1 WHEN 'CUSTOMER' THEN '고객'--'100'-- '고객'
						   WHEN 'COMPANY' THEN '당사'--'200' --'당사'
						   END AS IMPUTATION_YN
			 , CASE QTYCD2 WHEN 'DEMAND' THEN '수요'--'110'--'수요'
						   WHEN 'OPERATION' THEN '운영'--'210'--'운영'
						   WHEN 'SUPPLY' THEN '공급'--'220'--'공급'
						   END AS DEMAND_OPERATION
			 , CASE QTYCD3 WHEN 'PRODUCT' THEN '차량생산'--'111'--'차량생산'
						   WHEN 'SALES' THEN '차량판매'--'112'--'차량판매'
						   WHEN 'INVENTORY' THEN '물류이슈'--'113'--'물류이슈'
						   WHEN 'VPA' THEN '시점조정'--'211'--'시점조정'
						   WHEN 'MODELMIX' THEN '모델믹스' --'212'--'모델믹스'
						   WHEN 'SUPPLYISSUE' THEN '공급차질' --'221'--'공급차질'

						   END AS VARIATION_FACTOR
			 , DESC AS DESC--DESC AS DESC
			 , '' AS IN_DE_DEMAND
			 , INPUT_LIMIT AS IN_DDAY
			 , TO_NUMBER(MKT_FCST_M) AS DE_PL
		  FROM DM_ANL_MKT_PSI_DETAIL
		 WHERE 1=1
		   AND DIVISION_ID = p_division_id
		   AND PROJECT_CODE = p_project_code
		   AND MEASURE = 'DP_INIT'
		   --AND YYYYMM BETWEEN TO_CHAR(ADD_MONTHS(SYSDATE, -11), 'YYYYMMDD') AND TO_CHAR(SYSDATE, 'YYYYMMDD');
		   AND YYYYMM = p_yyyymm; --TO_CHAR(ADD_MONTHS(p_yyyymm + '01', v_i), 'YYYYMMDD')
		*/
		--v_i := V_I + 1
		SELECT PROJECT_CODE
			 , END_CUSTOMER
			 , YYYYMM
			 , NVL(CEILING(CUST_FCST_M), 0) AS EDI_QTY
			 , NVL(CEILING(QTY), 0) AS IN_DE_VOL
			 , CASE QTYCD1 WHEN 'CUSTOMER' THEN '고객'--'100'-- '고객'
						   WHEN 'COMPANY' THEN '당사'--'200' --'당사'
						   END AS IMPUTATION_YN
			 , CASE QTYCD2 WHEN 'DEMAND' THEN '수요'--'110'--'수요'
						   WHEN 'OPERATION' THEN '운영'--'210'--'운영'
						   WHEN 'SUPPLY' THEN '공급'--'220'--'공급'
						   END AS DEMAND_OPERATION
			 , CASE QTYCD3 WHEN 'PRODUCT' THEN '차량생산'--'111'--'차량생산'
						   WHEN 'SALES' THEN '차량판매'--'112'--'차량판매'
						   WHEN 'INVENTORY' THEN '물류이슈'--'113'--'물류이슈'
						   WHEN 'VPA' THEN '시점조정'--'211'--'시점조정'
						   WHEN 'MODELMIX' THEN '모델믹스' --'212'--'모델믹스'
						   WHEN 'SUPPLYISSUE' THEN '공급차질' --'221'--'공급차질'
						   END AS VARIATION_FACTOR
			 , DESC AS DESC--DESC AS DESC
			 --, NVL(CEILING(CUST_FCST_M + QTY), 0) AS RESULT
			 --, INPUT_LIMIT AS IN_DDAY
			 , NVL(CEILING(MKT_FCST_M), 0) AS MKT_FCST
		  FROM DM_ANL_MKT_PSI_DETAIL
		 WHERE 1=1
		   AND DIVISION_ID = p_division_id
		   AND END_CUSTOMER = p_end_customer
		   AND PROJECT_CODE = p_project_code
		   AND MEASURE = 'DP_INIT'
		   AND QTYCD3 IS NOT NULL
		   --AND YYYYMM BETWEEN TO_CHAR(ADD_MONTHS(SYSDATE, -11), 'YYYYMMDD') AND TO_CHAR(SYSDATE, 'YYYYMMDD');
		   AND YYYYMM = p_yyyymm--TO_CHAR(ADD_MONTHS(p_yyyymm + '01', v_i), 'YYYYMMDD')
		 ORDER BY SEQ;
		END;
	END;

	--SELECT * FROM GT_DMF0_DATA



END;
/

-- DMF0003_GET_DM_ANL_MKT_PSI_DPRESULT → PKG_DMF0003.P_DMF0003_GET_DM_ANL_MKT_PSI_DPRESULT에 등록됨
CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0003_GET_DM_ANL_MKT_PSI_DPRESULT
(
	p_division_id	VARCHAR2,
    p_project_code    VARCHAR2,
	p_yyyymm    VARCHAR2,
	p_created_by	VARCHAR2,
    p_end_customer VARCHAR2

--DMF0003_GET_DM_ANL_MKT_PSI_DPRESULT'81','A15AI7001','202307','leetw85'

)
AS
BEGIN
		/*
	   2023.11.02	   kcw3408		  ⓓ MKT.FCST (DP) 을 월 MKT FCST[R || P] Measure실적과 동일하게 관리
    */
	BEGIN
		UPDATE T1
		SET MKT_FCST_M = T2.MKT_FCST_M
		FROM DM_ANL_MKT_PSI_DETAIL T1
		JOIN
		     (SELECT X.DIVISION_ID
			      , X.END_CUSTOMER
			      , X.PROJECT_CODE
				  , X.YYYYMM
			      , NVL(CEILING(X.MKT_FCST_M), 0) AS MKT_FCST_M
			   FROM DM_ANL_MKT_PSI X
		      WHERE 1 = 1
		        AND X.DIVISION_ID = p_division_id
			    AND X.END_CUSTOMER = p_end_customer
			    AND X.PROJECT_CODE = p_project_code
	            AND X.MEASURE = 'DP_RESULT'
				AND X.YYYYMM = p_yyyymm
		  ) T2;
		 ON T2.DIVISION_ID  = T1.DIVISION_ID
		AND T2.END_CUSTOMER = T1.END_CUSTOMER
		AND T2.PROJECT_CODE = T1.PROJECT_CODE
		AND T2.YYYYMM       = T1.YYYYMM
		AND T1.MEASURE = 'DP_RESULT';
	END;

    -- 수요계획 Result 조회 쿼리 
	SELECT PROJECT_CODE
		 , END_CUSTOMER
		 , YYYYMM
		 , NVL(CEILING(CUST_FCST_M), 0) AS EDI_QTY
		 , NVL(CEILING(QTY), 0) AS IN_DE_VOL
		 , CASE QTYCD1 WHEN 'CUSTOMER' THEN '고객'
					   WHEN 'COMPANY' THEN '당사' END AS IMPUTATION_YN
		 , CASE QTYCD2 WHEN 'DEMAND' THEN '수요'
					   WHEN 'OPERATION' THEN '운영'
					   WHEN 'SUPPLY' THEN '공급'  END AS DEMAND_OPERATION
		 , CASE QTYCD3 WHEN 'PRODUCT' THEN '차량생산'
					   WHEN 'SALES' THEN '차량판매'
					   WHEN 'INVENTORY' THEN '물류이슈'
					   WHEN 'VPA' THEN '시점조정'
					   WHEN 'MODELMIX' THEN '모델믹스'
					   WHEN 'SUPPLYISSUE' THEN '공급차질' END AS VARIATION_FACTOR
		 , DESC AS "DESC"
		 --, NVL(CEILING(CUST_FCST_M + QTY), 0) AS IN_DE_DEMAND
		 --, INPUT_LIMIT AS IN_DDAY
		 , NVL(CEILING(MKT_FCST_M), 0) AS MKT_FCST
	  FROM DM_ANL_MKT_PSI_DETAIL
	 WHERE 1=1
	   AND DIVISION_ID = p_division_id
	   AND END_CUSTOMER = p_end_customer
	   AND PROJECT_CODE = p_project_code
	   AND MEASURE = 'DP_RESULT'
       AND QTYCD3 IS NOT NULL
	   --AND YYYYMM BETWEEN TO_CHAR(ADD_MONTHS(SYSDATE, -11), 'YYYYMMDD') AND TO_CHAR(SYSDATE, 'YYYYMMDD');
	   AND YYYYMM = p_yyyymm
	 ORDER BY SEQ;
END;
/

-- DMF0003_GET_MKT_FCST_COMPARE_POPUP → PKG_DMF0003.P_DMF0003_GET_MKT_FCST_COMPARE_POPUP에 등록됨
CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0003_GET_MKT_FCST_COMPARE_POPUP
(
    p_division_id    VARCHAR2,
    p_scm_site_id    VARCHAR2,
    p_project_code   VARCHAR2,
    p_item_id        VARCHAR2,
	--[C20210225-000385] dom_exp, fcst_type, incoterms, yyyymmdd 추가
	p_dom_exp		  VARCHAR2,
	p_fcst_type	  VARCHAR2,
	p_incoterms	  VARCHAR2,
	p_yyyymmdd		  VARCHAR2
)
AS


    V_PROGRAM_NAME VARCHAR2(150 CHAR) := 'DMF0003_GET_MKT_FCST_COMPARE_POPUP';
    V_LOG_TYPE VARCHAR2(30 CHAR);
    N_LOG_COUNT INTEGER := 0;
    V_LOG_MESSAGE VARCHAR2(1000 CHAR);
    V_DESCRIPTION VARCHAR2(500 CHAR);
    D_EVENT_DATE DATE;
    N_DELETE_COUNT INTEGER := 0;
    N_INSERT_COUNT INTEGER := 0;
BEGIN
    	-- LOG 용 변수 설정








	V_LOG_TYPE := 'START';
	V_LOG_MESSAGE := '########## START OF PROCEDURE ##########';
	V_DESCRIPTION := NULL;
	D_EVENT_DATE := SYSTIMESTAMP;
	PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);



	--1. 동기화
	/* TODO:GTT:GT_DMF0_DM_SSP-->GT_DMF0_DM_SSP */
	INSERT INTO GT_DMF0_DM_SSP
	select 'SYNC' AS CATEGORY
		 , SYNC.VALUE AS CONFIRM_ID
		 , A.*
	from   DM_PLN_MKT_FCST A
	CROSS JOIN LATERAL (  SELECT ID,VALUE FROM FN_SplitString(A.ATTRIBUTE4,','))  SYNC
	where  1=1
	and    measure		= 'MKT_FCST'
	and    division_id	= p_division_id
	and    project_code	= p_project_code
	AND    scm_site_id	= p_scm_site_id
	AND    ITEM_ID		= p_item_id
	and    dom_exp		= p_dom_exp
	and    fcst_type	= p_fcst_type
	and    incoterms	= p_incoterms
	AND    YYYYMMDD		= p_yyyymmdd

	UNION ALL
	--2. 캐리오버
	select 'CARRY_OVER' AS CATEGORY
		 , CARRY.VALUE AS CONFIRM_ID
		 , A.*
	from   DM_PLN_MKT_FCST A
	CROSS JOIN LATERAL (  SELECT ID,VALUE FROM FN_SplitString(A.ATTRIBUTE5,','))  CARRY
	where  1=1
	and    measure		= 'MKT_FCST'
	and    division_id	= p_division_id
	and    project_code	= p_project_code
	AND    scm_site_id	= p_scm_site_id
	AND    ITEM_ID		= p_item_id
	and    dom_exp		= p_dom_exp
	and    fcst_type	= p_fcst_type
	and    incoterms	= p_incoterms
	AND    YYYYMMDD		= p_yyyymmdd
	AND    NVL(A.ATTRIBUTE5, NULL) IS NOT NULL
	UNION ALL
	--3. 네팅
	/*select 'NETTING' AS CATEGORY
		 , NET.VALUE AS CONFIRM_ID
		 , A.*
	from   DM_PLN_MKT_FCST A
	CROSS JOIN LATERAL (  SELECT ID,VALUE FROM FN_SplitString(A.ATTRIBUTE6,','))  NET
	where  1=1
	and    measure		= 'MKT_FCST'
	and    division_id	= p_division_id
	and    project_code	= p_project_code
	AND    scm_site_id	= p_scm_site_id
	AND    ITEM_ID		= p_item_id
	and    dom_exp		= p_dom_exp
	and    fcst_type	= p_fcst_type
	and    incoterms	= p_incoterms
	AND    YYYYMMDD		= p_yyyymmdd
	AND    NVL(A.ATTRIBUTE6, NULL) IS NOT NULL
	UNION ALL*/
	--4.MKT Fcst
	select 'MKT_FCST' AS CATEGORY
		 , '' AS CONFIRM_ID
		 , A.*
	from   DM_PLN_MKT_FCST A
	where  1=1
	and    measure		= 'MKT_FCST'
	and    division_id	= p_division_id
	and    project_code	= p_project_code
	AND    scm_site_id	= p_scm_site_id
	AND    ITEM_ID		= p_item_id
	and    dom_exp		= p_dom_exp
	and    fcst_type	= p_fcst_type
	and    incoterms	= p_incoterms
	AND    YYYYMMDD		= p_yyyymmdd


	--MKT_FCST = Confrim 제외 수량
	SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.INCOTERMS, A.FCST_TYPE, A.DOM_EXP, A.YYYYMMDD
		 , A.CATEGORY, A.CONFIRM_ID
		 , CASE WHEN CAST(CAST(CASE WHEN SO_NO = 'X' THEN '' ELSE SO_NO END AS INTEGER) AS VARCHAR2(10 CHAR)) = '0'
					THEN ''
				ELSE CAST(CAST(CASE WHEN SO_NO = 'X' THEN '' ELSE SO_NO END AS INTEGER) AS VARCHAR2(10 CHAR))
			END AS SO_NO
		 , PLAN_QTY, SHIP_RESULT_QTY AS RESULT_QTY
		 , CASE WHEN A.CATEGORY = 'MKT_FCST' THEN 1
				  WHEN A.CATEGORY = 'SYNC' THEN 2
				  WHEN A.CATEGORY = 'CARRY_OVER' THEN 3
				  ELSE 4
			 END AS SEQ
	FROM GT_DMF0_DM_SSP A
	INNER JOIN DM_PLN_MKT_FCST_CONFIRM B
	ON   ( A.CONFIRM_ID = B.CONFIRM_ID
	   AND A.ITEM_ID = B.ITEM_ID )
	UNION ALL

	SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.INCOTERMS, A.FCST_TYPE, A.DOM_EXP, A.YYYYMMDD
		 , CASE WHEN A.CATEGORY = 'MKT_FCST' THEN 'Non-Sync MKT Fcst'
				WHEN A.CATEGORY = 'SYNC' THEN 'Sync'
				WHEN A.CATEGORY = 'CARRY_OVER' THEN 'Carry Over'
			END AS CATEGORY
		 , A.CONFIRM_ID, '' AS SO_NO
		 , MAX(QTY) - NVL(( SELECT SUM(PLAN_QTY)
								FROM GT_DMF0_DM_SSP A
								INNER JOIN DM_PLN_MKT_FCST_CONFIRM B
								ON   ( A.CONFIRM_ID = B.CONFIRM_ID
								   AND A.ITEM_ID = B.ITEM_ID )), 0) AS PLAN_QTY
		 , NULL AS SHIP_RESULT_QTY
		 , CASE WHEN A.CATEGORY = 'MKT_FCST' THEN 1
				  WHEN A.CATEGORY = 'SYNC' THEN 2
				  WHEN A.CATEGORY = 'CARRY_OVER' THEN 3
				  ELSE 4
			 END AS SEQ
	FROM GT_DMF0_DM_SSP A
	WHERE  CATEGORY = 'MKT_FCST'
	GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.INCOTERMS, A.FCST_TYPE, A.DOM_EXP, A.YYYYMMDD
		 , A.CATEGORY, A.CONFIRM_ID
	ORDER BY CASE WHEN A.CATEGORY = 'MKT_FCST' THEN 1;
				  WHEN A.CATEGORY = 'SYNC' THEN 2
				  WHEN A.CATEGORY = 'CARRY_OVER' THEN 3
				  ELSE 4
			 END;
	       , A.CONFIRM_ID


	-- 종료 LOG
	V_LOG_TYPE := 'END';
	V_LOG_MESSAGE := '########## END OF PROCEDURE ##########';
	D_EVENT_DATE := SYSTIMESTAMP;
	PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

END;
/

-- DMF0003_GET_QTY_TYPE_CODE → PKG_DMF0003.P_DMF0003_GET_QTY_TYPE_CODE에 등록됨
CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0003_GET_QTY_TYPE_CODE
AS
BEGIN

    SELECT L.SEGMENT1  AS CODE
       , L.SEGMENT2  AS NAME
  FROM   SCM_ADM_LOOKUP_MASTER_DETAIL L
  WHERE  L.LOOKUP_TYPE = 'MKT_FCST_UNIT_QTY'
  AND    L.VALID_YN    = 'Y'
  ORDER BY DISPLAY_SEQ;

END;
/

-- DMF0003_GET_REPORT_BUCKET_TYPE_CODE → PKG_DMF0003.P_DMF0003_GET_REPORT_BUCKET_TYPE_CODE에 등록됨
CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0003_GET_REPORT_BUCKET_TYPE_CODE
AS

    p_end_week VARCHAR2(6 CHAR);
BEGIN


  SELECT L.SEGMENT1  AS CODE
       , L.SEGMENT2  AS NAME
  FROM   SCM_ADM_LOOKUP_MASTER_DETAIL L
  WHERE  L.LOOKUP_TYPE = 'REPORT_BUCKET_TYPE_CODE'
  AND    L.VALID_YN    = 'Y'
  ORDER BY DISPLAY_SEQ;

END;
/

-- DMF0003_GET_SPREAD_TITLE → PKG_DMF0003.P_DMF0003_GET_SPREAD_TITLE에 등록됨
CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0003_GET_SPREAD_TITLE
(
    p_start_yyyymmdd  VARCHAR2,
    p_end_yyyymmdd    VARCHAR2,
	p_created_by	   VARCHAR2,
	p_division_id	   VARCHAR2
)
AS

    v_user_col_cnt INTEGER;
    v_program_id VARCHAR2(4000 CHAR);
    v_sheet_name VARCHAR2(4000 CHAR);
BEGIN




	v_program_id := 'DMF0003';
	v_sheet_name := 'Mkt Fcst';
	v_user_col_cnt := 0;

	SELECT COUNT(*)
  INTO v_user_col_cnt
	FROM   SCM_MST_TITLESET_USER U
	WHERE  1 = 1
	AND    U.PROGRAM_ID = v_program_id
    AND    U.SHEET_NAME = v_sheet_name
    AND    U.USER_ID    = p_created_by;


	IF v_user_col_cnt > 0 THEN
		SELECT U.PROGRAM_ID
				, U.SHEET_NAME
				, U.COLUMN_NAME
				, C.COLUMN_LABEL_NAME
				, U.SORT_ORDER_NO        --TO_CHAR(U.SORT_ORDER_NO) AS SORT_ORDER_NO
				, U.DATA_SORT_METHOD_CODE
				, C.SMALL_CLASS_LABEL_NAME
				, C.LARGE_CLASS_LABEL_NAME
				, '' AS DAY_CODE
				, C.FIXED_FLAG
				, C.COLUMN_WIDTH
				, C.CELL_CONTROL_OBJECT_TYPE_CODE
				, C.CELL_COMBO_DATA_TYPE
				, C.DATA_SCALE_NUMBER
				, C.DATA_MAX_LENGTH
				, C.HORIZONTAL_ALIGN_CODE
				, C.UPPERCASE_APPLY_FLAG
				, C.VISIBLE_FLAG
				, C.DEFAULT_FLAG
				, C.USER_SELECTABLE_FLAG
				, C.VALID_YN
				, C.DIVISION_ID
		FROM   SCM_MST_TITLESET_USER U
				, SCM_MST_SHEET_COLUMNS C
		WHERE  1 = 1
		AND    U.PROGRAM_ID  = C.PROGRAM_ID
		AND    U.SHEET_NAME  = C.SHEET_NAME
		AND    U.COLUMN_NAME = C.COLUMN_NAME
		AND    U.PROGRAM_ID  = v_program_id
		AND    U.SHEET_NAME  = v_sheet_name
		AND    U.USER_ID     = p_created_by
		AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
		AND	 p_division_id IN (SELECT token FROM TABLE(fn_string_split(C.DIVISION_ID ,',')) )		-- 20180620 division 추가
		UNION ALL
		SELECT C.PROGRAM_ID
				, C.SHEET_NAME
				, C.COLUMN_NAME
				, C.COLUMN_LABEL_NAME
				, C.SORT_ORDER_NO        --TO_CHAR(U.SORT_ORDER_NO) AS SORT_ORDER_NO
				, C.DATA_SORT_METHOD_CODE
				, C.SMALL_CLASS_LABEL_NAME
				, C.LARGE_CLASS_LABEL_NAME
				, '' AS DAY_CODE
				, C.FIXED_FLAG
				, C.COLUMN_WIDTH
				, C.CELL_CONTROL_OBJECT_TYPE_CODE
				, C.CELL_COMBO_DATA_TYPE
				, C.DATA_SCALE_NUMBER
				, C.DATA_MAX_LENGTH
				, C.HORIZONTAL_ALIGN_CODE
				, C.UPPERCASE_APPLY_FLAG
				, C.VISIBLE_FLAG
				, C.DEFAULT_FLAG
				, C.USER_SELECTABLE_FLAG
				, C.VALID_YN
				, C.DIVISION_ID
		FROM   SCM_MST_SHEET_COLUMNS C
		WHERE  1 = 1
		AND    C.PROGRAM_ID  = v_program_id
		AND    C.SHEET_NAME  = v_sheet_name
		AND    C.VISIBLE_FLAG = ''
		AND    C.DEFAULT_FLAG IS NULL
		AND    C.VALID_YN     = 'Y'
		AND	 p_division_id IN (SELECT token FROM TABLE(fn_string_split(C.DIVISION_ID ,',')) )		-- 20180620 division 추가

		UNION ALL

		SELECT v_program_id   AS PROGRAM_ID
				, v_sheet_name AS SHEET_NAME
				, T.COLUMN_NAME
				, T.COLUMN_LABEL_NAME
				, T.SORT_ORDER_NO
				, ''         AS DATA_SORT_METHOD_CODE
				, T.SMALL_CLASS_LABEL_NAME
				, T.LARGE_CLASS_LABEL_NAME
				, T.DAY_CODE
				, ''         AS FIXED_FLAG
				, 50         AS COLUMN_WIDTH
				, T.CELL_CONTROL_OBJECT_TYPE_CODE   --'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
				, ''         AS CELL_COMBO_DATA_TYPE
				, ''         AS DATA_SCALE_NUMBER
				, ''         AS DATA_MAX_LENGTH
				, 'R'        AS HORIZONTAL_ALIGN_CODE
				, 'Y'        AS UPPERCASE_APPLY_FLAG
				, 'Y'        AS VISIBLE_FLAG
				, ''         AS DEFAULT_FLAG
				, ''         AS USER_SELECTABLE_FLAG
				, ''         AS VALID_YN
				, ''			AS DIVISION_ID
		FROM  (
				SELECT 'D_'  ||  A.BASIS_YYYYMMDD   AS COLUMN_NAME
					, A.CALENDAR_DAY            AS COLUMN_LABEL_NAME
					, CASE WHEN INSTR(PARTIAL_WEEK_NAME, 'A') <> 0 THEN A.WEEK_NAME  ||  '+'
						WHEN INSTR(PARTIAL_WEEK_NAME, 'B') <> 0 THEN '+'  ||  A.WEEK_NAME
						ELSE A.WEEK_NAME END               AS SMALL_CLASS_LABEL_NAME
					, A.MONTH_NAME              AS LARGE_CLASS_LABEL_NAME
					, A.DAYOFWEEK               AS DAY_CODE
					, A.BASIS_YYYYMMDD  ||  TO_CHAR(31) AS SORT_ORDER_NO
					, 'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
				FROM   SCM_SYS_CALENDAR_M A
				WHERE  A.BASIS_YYYYMMDD >= p_start_yyyymmdd --TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD')
				AND    A.basis_yyyymmdd <= p_end_yyyymmdd --TO_CHAR(ADD_MONTHS(CURRENT_TIMESTAMP, (1)*12), 'YYYYMMDD')
				--[C20210827-000411] GSCM 시스템의 효율성을 위한 개선방안 기능 변경의 건
				--UNION ALL
				--SELECT 'DB_' + A.BASIS_YYYYMMDD  AS COLUMN_NAME
				--	, A.CALENDAR_DAY            AS COLUMN_LABEL_NAME
				--	, CASE WHEN INSTR(PARTIAL_WEEK_NAME, 'A') <> 0 THEN A.WEEK_NAME + '+'
				--		WHEN INSTR(PARTIAL_WEEK_NAME, 'B') <> 0 THEN '+' + A.WEEK_NAME
				--		ELSE A.WEEK_NAME END               AS SMALL_CLASS_LABEL_NAME
				--	, A.MONTH_NAME              AS LARGE_CLASS_LABEL_NAME
				--	, ''                        AS DAY_CODE
				--	, A.BASIS_YYYYMMDD + TO_CHAR(32) AS SORT_ORDER_NO
				--	, 'FPText' AS CELL_CONTROL_OBJECT_TYPE_CODE
				--FROM   SCM_SYS_CALENDAR_M A
				--WHERE  A.BASIS_YYYYMMDD >= p_start_yyyymmdd --TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD')
				--AND    A.BASIS_YYYYMMDD <= p_end_yyyymmdd --TO_CHAR(ADD_MONTHS(CURRENT_TIMESTAMP, (1)*12), 'YYYYMMDD')
				UNION ALL
				SELECT 'W_'  ||  A.BASIS_YYYYMM  ||  A.ISO_WEEK   AS COLUMN_NAME
					, CASE WHEN INSTR(PARTIAL_WEEK_NAME, 'A') <> 0 THEN A.WEEK_NAME  ||  '+'
						WHEN INSTR(PARTIAL_WEEK_NAME, 'B') <> 0 THEN '+'  ||  A.WEEK_NAME
						ELSE A.WEEK_NAME END AS COLUMN_LABEL_NAME	-- 20190610
					, CASE WHEN INSTR(PARTIAL_WEEK_NAME, 'A') <> 0 THEN A.WEEK_NAME  ||  '+'
						WHEN INSTR(PARTIAL_WEEK_NAME, 'B') <> 0 THEN '+'  ||  A.WEEK_NAME
						ELSE A.WEEK_NAME END          AS SMALL_CLASS_LABEL_NAME
					, A.MONTH_NAME         AS LARGE_CLASS_LABEL_NAME
					, ''                   AS DAY_CODE
					, A.BASIS_START_DATE  ||  TO_CHAR(21) AS SORT_ORDER_NO
					, 'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
				FROM   SCM_SYS_CALENDAR_M A
				WHERE  A.BASIS_YYYYMMDD >= p_start_yyyymmdd --TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD')
				AND    A.BASIS_YYYYMMDD <= p_end_yyyymmdd --TO_CHAR(ADD_MONTHS(CURRENT_TIMESTAMP, (1)*12), 'YYYYMMDD')
				GROUP BY A.BASIS_YYYYMM
						, A.ISO_WEEK
						, A.WEEK_NAME
						, PARTIAL_WEEK_NAME	-- 20190610
						, A.MONTH_NAME
						, A.BASIS_START_DATE
				--[C20210827-000411] GSCM 시스템의 효율성을 위한 개선방안 기능 변경의 건
				--UNION ALL
				--SELECT 'WB_' + A.BASIS_YYYYMM + A.ISO_WEEK   AS COLUMN_NAME
				--	, CASE WHEN INSTR(PARTIAL_WEEK_NAME, 'A') <> 0 THEN A.WEEK_NAME + '+'
				--		WHEN INSTR(PARTIAL_WEEK_NAME, 'B') <> 0 THEN '+' + A.WEEK_NAME
				--		ELSE A.WEEK_NAME END AS COLUMN_LABEL_NAME	-- 20190610
				--	, CASE WHEN INSTR(PARTIAL_WEEK_NAME, 'A') <> 0 THEN A.WEEK_NAME + '+'
				--		WHEN INSTR(PARTIAL_WEEK_NAME, 'B') <> 0 THEN '+' + A.WEEK_NAME
				--		ELSE A.WEEK_NAME END          AS SMALL_CLASS_LABEL_NAME
				--	, A.MONTH_NAME          AS LARGE_CLASS_LABEL_NAME
				--	, ''                    AS DAY_CODE
				--	, A.BASIS_START_DATE + TO_CHAR(22) AS SORT_ORDER_NO
				--	, 'FPText' AS CELL_CONTROL_OBJECT_TYPE_CODE
				--FROM   SCM_SYS_CALENDAR_M A
				--WHERE  A.BASIS_YYYYMMDD >= p_start_yyyymmdd --TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD')
				--AND    A.BASIS_YYYYMMDD <= p_end_yyyymmdd --TO_CHAR(ADD_MONTHS(CURRENT_TIMESTAMP, (1)*12), 'YYYYMMDD')
				--GROUP BY A.BASIS_YYYYMM
				--		, A.ISO_WEEK
				--		, A.WEEK_NAME
				--		, PARTIAL_WEEK_NAME	-- 20190610
				--		, A.MONTH_NAME
				--		, A.BASIS_START_DATE
				UNION ALL
				SELECT 'M_'  ||  A.BASIS_YYYYMM  AS COLUMN_NAME
						, A.MONTH_NAME          AS COLUMN_LABEL_NAME
						, A.MONTH_NAME          AS SMALL_CLASS_LABEL_NAME
						, A.MONTH_NAME          AS LARGE_CLASS_LABEL_NAME
						, ''                    AS DAY_CODE
						, MIN(A.BASIS_START_DATE)  ||  TO_CHAR('01') AS SORT_ORDER_NO
						, 'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
				FROM    SCM_SYS_CALENDAR_M A
				WHERE  A.BASIS_YYYYMMDD >= p_start_yyyymmdd --TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD')
				AND    A.BASIS_YYYYMMDD <= p_end_yyyymmdd --TO_CHAR(ADD_MONTHS(CURRENT_TIMESTAMP, (1)*12), 'YYYYMMDD')
				GROUP BY A.BASIS_YYYYMM
						, A.MONTH_NAME
				--[C20210827-000411] GSCM 시스템의 효율성을 위한 개선방안 기능 변경의 건
				--UNION ALL
				--SELECT 'MB_' + A.BASIS_YYYYMM  AS COLUMN_NAME
				--		, A.MONTH_NAME           AS COLUMN_LABEL
				--		, A.MONTH_NAME           AS SMALL_LABEL_NAME
				--		, A.MONTH_NAME           AS LARGE_LABEL_NAME
				--		, ''                     AS DAY_CODE
				--		, MIN(A.BASIS_START_DATE) + TO_CHAR(11) AS SORT_ORDER_NO
				--		, 'FPText' AS CELL_CONTROL_OBJECT_TYPE_CODE
				--FROM    SCM_SYS_CALENDAR_M A
				--WHERE  A.BASIS_YYYYMMDD >= p_start_yyyymmdd --TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD')
				--AND    A.BASIS_YYYYMMDD <= p_end_yyyymmdd --TO_CHAR(ADD_MONTHS(CURRENT_TIMESTAMP, (1)*12), 'YYYYMMDD')
				--GROUP BY A.BASIS_YYYYMM
				--		, A.MONTH_NAME
				--ORDER BY sort_order_no
			) T;
		  ORDER BY SORT_ORDER_NO   ;
	  ELSE

			SELECT C.PROGRAM_ID
					, C.SHEET_NAME
					, C.COLUMN_NAME
					, C.COLUMN_LABEL_NAME
					, C.SORT_ORDER_NO        --TO_CHAR(U.SORT_ORDER_NO) AS SORT_ORDER_NO
					, C.DATA_SORT_METHOD_CODE
					, C.SMALL_CLASS_LABEL_NAME
					, C.LARGE_CLASS_LABEL_NAME
					, '' AS DAY_CODE
					, C.FIXED_FLAG
					, C.COLUMN_WIDTH
					, C.CELL_CONTROL_OBJECT_TYPE_CODE
					, C.CELL_COMBO_DATA_TYPE
					, C.DATA_SCALE_NUMBER
					, C.DATA_MAX_LENGTH
					, C.HORIZONTAL_ALIGN_CODE
					, C.UPPERCASE_APPLY_FLAG
					, C.VISIBLE_FLAG
					, C.DEFAULT_FLAG
					, C.USER_SELECTABLE_FLAG
					, C.VALID_YN
					, C.DIVISION_ID
			FROM   SCM_MST_SHEET_COLUMNS C
			WHERE  1 = 1
			AND    C.PROGRAM_ID  = v_program_id
			AND    C.SHEET_NAME  = v_sheet_name
			AND    C.DEFAULT_FLAG = 'Y'
			AND    C.VALID_YN     = 'Y'
			AND	 p_division_id IN (SELECT token FROM TABLE(fn_string_split(C.DIVISION_ID ,',')) )		-- 20180620 division 추가

			UNION ALL

			SELECT C.PROGRAM_ID
					, C.SHEET_NAME
					, C.COLUMN_NAME
					, C.COLUMN_LABEL_NAME
					, C.SORT_ORDER_NO        --TO_CHAR(U.SORT_ORDER_NO) AS SORT_ORDER_NO
					, C.DATA_SORT_METHOD_CODE
					, C.SMALL_CLASS_LABEL_NAME
					, C.LARGE_CLASS_LABEL_NAME
					, '' AS DAY_CODE
					, C.FIXED_FLAG
					, C.COLUMN_WIDTH
					, C.CELL_CONTROL_OBJECT_TYPE_CODE
					, C.CELL_COMBO_DATA_TYPE
					, C.DATA_SCALE_NUMBER
					, C.DATA_MAX_LENGTH
					, C.HORIZONTAL_ALIGN_CODE
					, C.UPPERCASE_APPLY_FLAG
					, C.VISIBLE_FLAG
					, C.DEFAULT_FLAG
					, C.USER_SELECTABLE_FLAG
					, C.VALID_YN
					, C.DIVISION_ID
			FROM   SCM_MST_SHEET_COLUMNS C
			WHERE  1 = 1
			AND    C.PROGRAM_ID  = v_program_id
			AND    C.SHEET_NAME  = v_sheet_name
			AND    C.VISIBLE_FLAG = ''
			AND    C.DEFAULT_FLAG IS NULL
			AND    C.VALID_YN     = 'Y'
			AND	 p_division_id IN (SELECT token FROM TABLE(fn_string_split(C.DIVISION_ID ,',')) )		-- 20180620 division 추가

			UNION ALL

			SELECT v_program_id   AS PROGRAM_ID
					, v_sheet_name AS SHEET_NAME
					, T.COLUMN_NAME
					, T.COLUMN_LABEL_NAME
					, T.SORT_ORDER_NO
					, ''         AS DATA_SORT_METHOD_CODE
					, T.SMALL_CLASS_LABEL_NAME
					, T.LARGE_CLASS_LABEL_NAME
					, T.DAY_CODE
					, ''         AS FIXED_FLAG
					, 50         AS COLUMN_WIDTH
					, 'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
					, ''         AS CELL_COMBO_DATA_TYPE
					, ''         AS DATA_SCALE_NUMBER
					, ''         AS DATA_MAX_LENGTH
					, 'R'        AS HORIZONTAL_ALIGN_CODE
					, 'Y'        AS UPPERCASE_APPLY_FLAG
					, 'Y'        AS VISIBLE_FLAG
					, ''         AS DEFAULT_FLAG
					, ''         AS USER_SELECTABLE_FLAG
					, ''         AS VALID_YN
					, ''			AS DIVISION_ID
			FROM  (
					SELECT 'D_'  ||  A.BASIS_YYYYMMDD   AS COLUMN_NAME
						, A.CALENDAR_DAY            AS COLUMN_LABEL_NAME
						, CASE WHEN INSTR(PARTIAL_WEEK_NAME, 'A') <> 0 THEN A.WEEK_NAME  ||  '+'
						WHEN INSTR(PARTIAL_WEEK_NAME, 'B') <> 0 THEN '+'  ||  A.WEEK_NAME
						ELSE A.WEEK_NAME END               AS SMALL_CLASS_LABEL_NAME
						, A.MONTH_NAME              AS LARGE_CLASS_LABEL_NAME
						, A.DAYOFWEEK               AS DAY_CODE
						, A.BASIS_YYYYMMDD  ||  TO_CHAR(31) AS SORT_ORDER_NO
					FROM   SCM_SYS_CALENDAR_M A
					WHERE  A.BASIS_YYYYMMDD >= p_start_yyyymmdd --TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD')
					AND    A.basis_yyyymmdd <= p_end_yyyymmdd --TO_CHAR(ADD_MONTHS(CURRENT_TIMESTAMP, (1)*12), 'YYYYMMDD')
					--[C20210827-000411] GSCM 시스템의 효율성을 위한 개선방안 기능 변경의 건
					--UNION ALL
					--SELECT 'DB_' + A.BASIS_YYYYMMDD  AS COLUMN_NAME
					--	, A.CALENDAR_DAY            AS COLUMN_LABEL_NAME
					--	, CASE WHEN INSTR(PARTIAL_WEEK_NAME, 'A') <> 0 THEN A.WEEK_NAME + '+'
					--	WHEN INSTR(PARTIAL_WEEK_NAME, 'B') <> 0 THEN '+' + A.WEEK_NAME
					--	ELSE A.WEEK_NAME END               AS SMALL_CLASS_LABEL_NAME
					--	, A.MONTH_NAME              AS LARGE_CLASS_LABEL_NAME
					--	, ''                        AS DAY_CODE
					--	, A.BASIS_YYYYMMDD + TO_CHAR(32) AS SORT_ORDER_NO
					--FROM   SCM_SYS_CALENDAR_M A
					--WHERE  A.BASIS_YYYYMMDD >= p_start_yyyymmdd --TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD')
					--AND    A.BASIS_YYYYMMDD <= p_end_yyyymmdd --TO_CHAR(ADD_MONTHS(CURRENT_TIMESTAMP, (1)*12), 'YYYYMMDD')
					UNION ALL
					SELECT 'W_'  ||  A.BASIS_YYYYMM  ||  A.ISO_WEEK   AS COLUMN_NAME
						, CASE WHEN INSTR(PARTIAL_WEEK_NAME, 'A') <> 0 THEN A.WEEK_NAME  ||  '+'
						WHEN INSTR(PARTIAL_WEEK_NAME, 'B') <> 0 THEN '+'  ||  A.WEEK_NAME
						ELSE A.WEEK_NAME END AS COLUMN_LABEL_NAME	-- 20190610
					, CASE WHEN INSTR(PARTIAL_WEEK_NAME, 'A') <> 0 THEN A.WEEK_NAME  ||  '+'
						WHEN INSTR(PARTIAL_WEEK_NAME, 'B') <> 0 THEN '+'  ||  A.WEEK_NAME
						ELSE A.WEEK_NAME END          AS SMALL_CLASS_LABEL_NAME
						, A.MONTH_NAME         AS LARGE_CLASS_LABEL_NAME
						, ''                   AS DAY_CODE
						, A.BASIS_START_DATE  ||  TO_CHAR(21) AS SORT_ORDER_NO
					FROM   SCM_SYS_CALENDAR_M A
					WHERE  A.BASIS_YYYYMMDD >= p_start_yyyymmdd --TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD')
					AND    A.BASIS_YYYYMMDD <= p_end_yyyymmdd --TO_CHAR(ADD_MONTHS(CURRENT_TIMESTAMP, (1)*12), 'YYYYMMDD')
					GROUP BY A.BASIS_YYYYMM
							, A.ISO_WEEK
							, A.WEEK_NAME
							, PARTIAL_WEEK_NAME	-- 20190610
							, A.MONTH_NAME
							, A.BASIS_START_DATE
					--[C20210827-000411] GSCM 시스템의 효율성을 위한 개선방안 기능 변경의 건
					--UNION ALL
					--SELECT 'WB_' + A.BASIS_YYYYMM + A.ISO_WEEK   AS COLUMN_NAME
					--	, CASE WHEN INSTR(PARTIAL_WEEK_NAME, 'A') <> 0 THEN A.WEEK_NAME + '+'
					--	WHEN INSTR(PARTIAL_WEEK_NAME, 'B') <> 0 THEN '+' + A.WEEK_NAME
					--	ELSE A.WEEK_NAME END AS COLUMN_LABEL_NAME	-- 20190610
					--, CASE WHEN INSTR(PARTIAL_WEEK_NAME, 'A') <> 0 THEN A.WEEK_NAME + '+'
					--	WHEN INSTR(PARTIAL_WEEK_NAME, 'B') <> 0 THEN '+' + A.WEEK_NAME
					--	ELSE A.WEEK_NAME END          AS SMALL_CLASS_LABEL_NAME
					--	, A.MONTH_NAME          AS LARGE_CLASS_LABEL_NAME
					--	, ''                    AS DAY_CODE
					--	, A.BASIS_START_DATE + TO_CHAR(22) AS SORT_ORDER_NO
					--FROM   SCM_SYS_CALENDAR_M A
					--WHERE  A.BASIS_YYYYMMDD >= p_start_yyyymmdd --TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD')
					--AND    A.BASIS_YYYYMMDD <= p_end_yyyymmdd --TO_CHAR(ADD_MONTHS(CURRENT_TIMESTAMP, (1)*12), 'YYYYMMDD')
					--GROUP BY A.BASIS_YYYYMM
					--		, A.ISO_WEEK
					--		, A.WEEK_NAME
					--		, PARTIAL_WEEK_NAME	-- 20190610
					--		, A.MONTH_NAME
					--		, A.BASIS_START_DATE
					UNION ALL
					SELECT 'M_'  ||  A.BASIS_YYYYMM  AS COLUMN_NAME
							, A.MONTH_NAME          AS COLUMN_LABEL_NAME
							, A.MONTH_NAME          AS SMALL_CLASS_LABEL_NAME
							, A.MONTH_NAME          AS LARGE_CLASS_LABEL_NAME
							, ''                    AS DAY_CODE
							, MIN(A.BASIS_START_DATE)  ||  TO_CHAR('01') AS SORT_ORDER_NO
					FROM    SCM_SYS_CALENDAR_M A
					WHERE  A.BASIS_YYYYMMDD >= p_start_yyyymmdd --TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD')
					AND    A.BASIS_YYYYMMDD <= p_end_yyyymmdd --TO_CHAR(ADD_MONTHS(CURRENT_TIMESTAMP, (1)*12), 'YYYYMMDD')
					GROUP BY A.BASIS_YYYYMM
							, A.MONTH_NAME
					--[C20210827-000411] GSCM 시스템의 효율성을 위한 개선방안 기능 변경의 건
					--UNION ALL
					--SELECT 'MB_' + A.BASIS_YYYYMM  AS COLUMN_NAME
					--		, A.MONTH_NAME           AS COLUMN_LABEL
					--		, A.MONTH_NAME           AS SMALL_LABEL_NAME
					--		, A.MONTH_NAME           AS LARGE_LABEL_NAME
					--		, ''                     AS DAY_CODE
					--		, MIN(A.BASIS_START_DATE) + TO_CHAR(11) AS SORT_ORDER_NO
					--FROM    SCM_SYS_CALENDAR_M A
					--WHERE  A.BASIS_YYYYMMDD >= p_start_yyyymmdd --TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD')
					--AND    A.BASIS_YYYYMMDD <= p_end_yyyymmdd --TO_CHAR(ADD_MONTHS(CURRENT_TIMESTAMP, (1)*12), 'YYYYMMDD')
					--GROUP BY A.BASIS_YYYYMM
					--		, A.MONTH_NAME
					--ORDER BY sort_order_no
				) T;
			  ORDER BY SORT_ORDER_NO   ;
		  END IF;
END;
/

-- DMF0003_GET_SPREAD_TITLE_CAR → PKG_DMF0003.P_DMF0003_GET_SPREAD_TITLE_CAR에 등록됨
CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0003_GET_SPREAD_TITLE_CAR
(
    p_start_yyyymmdd  VARCHAR2,
    p_end_yyyymmdd    VARCHAR2,
	p_created_by	   VARCHAR2,
	p_division_id	   VARCHAR2
)
AS

    v_user_col_cnt INTEGER;
    v_program_id VARCHAR2(4000 CHAR);
    v_sheet_name VARCHAR2(4000 CHAR);
BEGIN




	v_program_id := 'DMF0003';
	v_sheet_name := 'Car Fcst';
	v_user_col_cnt := 0;

	SELECT COUNT(*)
  INTO v_user_col_cnt
	FROM   SCM_MST_TITLESET_USER U
	WHERE  1 = 1
	AND    U.PROGRAM_ID = v_program_id
    AND    U.SHEET_NAME = v_sheet_name
    AND    U.USER_ID    = p_created_by;


	IF v_user_col_cnt > 0 THEN
		SELECT * FROM
		(
		SELECT U.PROGRAM_ID
				, U.SHEET_NAME
				, U.COLUMN_NAME
				, C.COLUMN_LABEL_NAME
				, U.SORT_ORDER_NO        --TO_CHAR(U.SORT_ORDER_NO) AS SORT_ORDER_NO
				, U.DATA_SORT_METHOD_CODE
				, C.SMALL_CLASS_LABEL_NAME
				, C.LARGE_CLASS_LABEL_NAME
				, '' AS DAY_CODE
				, C.FIXED_FLAG
				, C.COLUMN_WIDTH
				, C.CELL_CONTROL_OBJECT_TYPE_CODE
				, C.CELL_COMBO_DATA_TYPE
				, C.DATA_SCALE_NUMBER
				, C.DATA_MAX_LENGTH
				, C.HORIZONTAL_ALIGN_CODE
				, C.UPPERCASE_APPLY_FLAG
				, C.VISIBLE_FLAG
				, C.DEFAULT_FLAG
				, C.USER_SELECTABLE_FLAG
				, C.VALID_YN
				, C.DIVISION_ID
		FROM   SCM_MST_TITLESET_USER U
				, SCM_MST_SHEET_COLUMNS C
		WHERE  1 = 1
		AND    U.PROGRAM_ID  = C.PROGRAM_ID
		AND    U.SHEET_NAME  = C.SHEET_NAME
		AND    U.COLUMN_NAME = C.COLUMN_NAME
		AND    U.PROGRAM_ID  = v_program_id
		AND    U.SHEET_NAME  = v_sheet_name
		AND    U.USER_ID     = p_created_by
		AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
		AND	 p_division_id IN (SELECT token FROM TABLE(fn_string_split(C.DIVISION_ID ,',')) )		-- 20180620 division 추가


		UNION ALL

		SELECT C.PROGRAM_ID
				, C.SHEET_NAME
				, C.COLUMN_NAME
				, C.COLUMN_LABEL_NAME
				, C.SORT_ORDER_NO        --TO_CHAR(U.SORT_ORDER_NO) AS SORT_ORDER_NO
				, C.DATA_SORT_METHOD_CODE
				, C.SMALL_CLASS_LABEL_NAME
				, C.LARGE_CLASS_LABEL_NAME
				, '' AS DAY_CODE
				, C.FIXED_FLAG
				, C.COLUMN_WIDTH
				, C.CELL_CONTROL_OBJECT_TYPE_CODE
				, C.CELL_COMBO_DATA_TYPE
				, C.DATA_SCALE_NUMBER
				, C.DATA_MAX_LENGTH
				, C.HORIZONTAL_ALIGN_CODE
				, C.UPPERCASE_APPLY_FLAG
				, C.VISIBLE_FLAG
				, C.DEFAULT_FLAG
				, C.USER_SELECTABLE_FLAG
				, C.VALID_YN
				, C.DIVISION_ID
		FROM   SCM_MST_SHEET_COLUMNS C
		WHERE  1 = 1
		AND    C.PROGRAM_ID  = v_program_id
		AND    C.SHEET_NAME  = v_sheet_name
		AND    C.VISIBLE_FLAG = ''
		AND    C.DEFAULT_FLAG IS NULL
		AND    C.VALID_YN     = 'Y'
		AND	 p_division_id IN (SELECT token FROM TABLE(fn_string_split(C.DIVISION_ID ,',')) )		-- 20180620 division 추가
		) A ORDER BY A.SORT_ORDER_NO

		--UNION ALL

		--SELECT v_program_id   AS PROGRAM_ID
		--		, v_sheet_name AS SHEET_NAME
		--		, T.COLUMN_NAME
		--		, T.COLUMN_LABEL_NAME
		--		, T.SORT_ORDER_NO
		--		, ''         AS DATA_SORT_METHOD_CODE
		--		, T.SMALL_CLASS_LABEL_NAME
		--		, T.LARGE_CLASS_LABEL_NAME
		--		, T.DAY_CODE
		--		, ''         AS FIXED_FLAG
		--		, 50         AS COLUMN_WIDTH
		--		, T.CELL_CONTROL_OBJECT_TYPE_CODE   --'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
		--		, ''         AS CELL_COMBO_DATA_TYPE
		--		, ''         AS DATA_SCALE_NUMBER
		--		, ''         AS DATA_MAX_LENGTH
		--		, 'R'        AS HORIZONTAL_ALIGN_CODE
		--		, 'Y'        AS UPPERCASE_APPLY_FLAG
		--		, 'Y'        AS VISIBLE_FLAG
		--		, ''         AS DEFAULT_FLAG
		--		, ''         AS USER_SELECTABLE_FLAG
		--		, ''         AS VALID_YN
		--		, ''			AS DIVISION_ID
		--FROM  (
		--		SELECT 'D_' + A.BASIS_YYYYMMDD   AS COLUMN_NAME
		--			, A.CALENDAR_DAY            AS COLUMN_LABEL_NAME
		--			, CASE WHEN INSTR(PARTIAL_WEEK_NAME, 'A') <> 0 THEN A.WEEK_NAME + '+'
		--				WHEN INSTR(PARTIAL_WEEK_NAME, 'B') <> 0 THEN '+' + A.WEEK_NAME
		--				ELSE A.WEEK_NAME END               AS SMALL_CLASS_LABEL_NAME
		--			, A.MONTH_NAME              AS LARGE_CLASS_LABEL_NAME
		--			, A.DAYOFWEEK               AS DAY_CODE
		--			, A.BASIS_YYYYMMDD + TO_CHAR(31) AS SORT_ORDER_NO
		--			, 'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
		--		FROM   SCM_SYS_CALENDAR_M A
		--		WHERE  A.BASIS_YYYYMMDD >= p_start_yyyymmdd --TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD')
		--		AND    A.basis_yyyymmdd <= p_end_yyyymmdd --TO_CHAR(ADD_MONTHS(CURRENT_TIMESTAMP, (1)*12), 'YYYYMMDD')

		--		UNION ALL
		--		SELECT 'W_' + A.BASIS_YYYYMM + A.ISO_WEEK   AS COLUMN_NAME
		--			, CASE WHEN INSTR(PARTIAL_WEEK_NAME, 'A') <> 0 THEN A.WEEK_NAME + '+'
		--				WHEN INSTR(PARTIAL_WEEK_NAME, 'B') <> 0 THEN '+' + A.WEEK_NAME
		--				ELSE A.WEEK_NAME END AS COLUMN_LABEL_NAME	-- 20190610
		--			, CASE WHEN INSTR(PARTIAL_WEEK_NAME, 'A') <> 0 THEN A.WEEK_NAME + '+'
		--				WHEN INSTR(PARTIAL_WEEK_NAME, 'B') <> 0 THEN '+' + A.WEEK_NAME
		--				ELSE A.WEEK_NAME END          AS SMALL_CLASS_LABEL_NAME
		--			, A.MONTH_NAME         AS LARGE_CLASS_LABEL_NAME
		--			, ''                   AS DAY_CODE
		--			, A.BASIS_START_DATE + TO_CHAR(21) AS SORT_ORDER_NO
		--			, 'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
		--		FROM   SCM_SYS_CALENDAR_M A
		--		WHERE  A.BASIS_YYYYMMDD >= p_start_yyyymmdd --TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD')
		--		AND    A.BASIS_YYYYMMDD <= p_end_yyyymmdd --TO_CHAR(ADD_MONTHS(CURRENT_TIMESTAMP, (1)*12), 'YYYYMMDD')
		--		GROUP BY A.BASIS_YYYYMM
		--				, A.ISO_WEEK
		--				, A.WEEK_NAME
		--				, PARTIAL_WEEK_NAME	-- 20190610
		--				, A.MONTH_NAME
		--				, A.BASIS_START_DATE
		--		UNION ALL
		--		SELECT 'M_' + A.BASIS_YYYYMM  AS COLUMN_NAME
		--				, A.MONTH_NAME          AS COLUMN_LABEL_NAME
		--				, A.MONTH_NAME          AS SMALL_CLASS_LABEL_NAME
		--				, A.MONTH_NAME          AS LARGE_CLASS_LABEL_NAME
		--				, ''                    AS DAY_CODE
		--				, MIN(A.BASIS_START_DATE) + TO_CHAR('01') AS SORT_ORDER_NO
		--				, 'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
		--		FROM    SCM_SYS_CALENDAR_M A
		--		WHERE  A.BASIS_YYYYMMDD >= p_start_yyyymmdd --TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD')
		--		AND    A.BASIS_YYYYMMDD <= p_end_yyyymmdd --TO_CHAR(ADD_MONTHS(CURRENT_TIMESTAMP, (1)*12), 'YYYYMMDD')
		--		GROUP BY A.BASIS_YYYYMM
		--				, A.MONTH_NAME
		--	) T
		--  ORDER BY SORT_ORDER_NO   ;
	  ELSE
			DBMS_OUTPUT.PUT_LINE('2');
			SELECT * FROM (
			SELECT C.PROGRAM_ID
					, C.SHEET_NAME
					, C.COLUMN_NAME
					, C.COLUMN_LABEL_NAME
					, C.SORT_ORDER_NO        --TO_CHAR(U.SORT_ORDER_NO) AS SORT_ORDER_NO
					, C.DATA_SORT_METHOD_CODE
					, C.SMALL_CLASS_LABEL_NAME
					, C.LARGE_CLASS_LABEL_NAME
					, '' AS DAY_CODE
					, C.FIXED_FLAG
					, C.COLUMN_WIDTH
					, C.CELL_CONTROL_OBJECT_TYPE_CODE
					, C.CELL_COMBO_DATA_TYPE
					, C.DATA_SCALE_NUMBER
					, C.DATA_MAX_LENGTH
					, C.HORIZONTAL_ALIGN_CODE
					, C.UPPERCASE_APPLY_FLAG
					, C.VISIBLE_FLAG
					, C.DEFAULT_FLAG
					, C.USER_SELECTABLE_FLAG
					, C.VALID_YN
					, C.DIVISION_ID
			FROM   SCM_MST_SHEET_COLUMNS C
			WHERE  1 = 1
			AND    C.PROGRAM_ID  = v_program_id
			AND    C.SHEET_NAME  = v_sheet_name
			AND    C.DEFAULT_FLAG = 'Y'
			AND    C.VALID_YN     = 'Y'
			AND	 p_division_id IN (SELECT token FROM TABLE(fn_string_split(C.DIVISION_ID ,',')) )		-- 20180620 division 추가

			UNION ALL

			SELECT C.PROGRAM_ID
					, C.SHEET_NAME
					, C.COLUMN_NAME
					, C.COLUMN_LABEL_NAME
					, C.SORT_ORDER_NO        --TO_CHAR(U.SORT_ORDER_NO) AS SORT_ORDER_NO
					, C.DATA_SORT_METHOD_CODE
					, C.SMALL_CLASS_LABEL_NAME
					, C.LARGE_CLASS_LABEL_NAME
					, '' AS DAY_CODE
					, C.FIXED_FLAG
					, C.COLUMN_WIDTH
					, C.CELL_CONTROL_OBJECT_TYPE_CODE
					, C.CELL_COMBO_DATA_TYPE
					, C.DATA_SCALE_NUMBER
					, C.DATA_MAX_LENGTH
					, C.HORIZONTAL_ALIGN_CODE
					, C.UPPERCASE_APPLY_FLAG
					, C.VISIBLE_FLAG
					, C.DEFAULT_FLAG
					, C.USER_SELECTABLE_FLAG
					, C.VALID_YN
					, C.DIVISION_ID
			FROM   SCM_MST_SHEET_COLUMNS C
			WHERE  1 = 1
			AND    C.PROGRAM_ID  = v_program_id
			AND    C.SHEET_NAME  = v_sheet_name
			AND    C.VISIBLE_FLAG = ''
			AND    C.DEFAULT_FLAG IS NULL
			AND    C.VALID_YN     = 'Y'
			AND	 p_division_id IN (SELECT token FROM TABLE(fn_string_split(C.DIVISION_ID ,',')) )		-- 20180620 division 추가
			) A ORDER BY A.SORT_ORDER_NO
			--UNION ALL

			--SELECT v_program_id   AS PROGRAM_ID
			--		, v_sheet_name AS SHEET_NAME
			--		, T.COLUMN_NAME
			--		, T.COLUMN_LABEL_NAME
			--		, T.SORT_ORDER_NO
			--		, ''         AS DATA_SORT_METHOD_CODE
			--		, T.SMALL_CLASS_LABEL_NAME
			--		, T.LARGE_CLASS_LABEL_NAME
			--		, T.DAY_CODE
			--		, ''         AS FIXED_FLAG
			--		, 50         AS COLUMN_WIDTH
			--		, 'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
			--		, ''         AS CELL_COMBO_DATA_TYPE
			--		, ''         AS DATA_SCALE_NUMBER
			--		, ''         AS DATA_MAX_LENGTH
			--		, 'R'        AS HORIZONTAL_ALIGN_CODE
			--		, 'Y'        AS UPPERCASE_APPLY_FLAG
			--		, 'Y'        AS VISIBLE_FLAG
			--		, ''         AS DEFAULT_FLAG
			--		, ''         AS USER_SELECTABLE_FLAG
			--		, ''         AS VALID_YN
			--		, ''			AS DIVISION_ID
			--FROM  (
			--		SELECT 'D_' + A.BASIS_YYYYMMDD   AS COLUMN_NAME
			--			, A.CALENDAR_DAY            AS COLUMN_LABEL_NAME
			--			, CASE WHEN INSTR(PARTIAL_WEEK_NAME, 'A') <> 0 THEN A.WEEK_NAME + '+'
			--			WHEN INSTR(PARTIAL_WEEK_NAME, 'B') <> 0 THEN '+' + A.WEEK_NAME
			--			ELSE A.WEEK_NAME END               AS SMALL_CLASS_LABEL_NAME
			--			, A.MONTH_NAME              AS LARGE_CLASS_LABEL_NAME
			--			, A.DAYOFWEEK               AS DAY_CODE
			--			, A.BASIS_YYYYMMDD + TO_CHAR(31) AS SORT_ORDER_NO
			--		FROM   SCM_SYS_CALENDAR_M A
			--		WHERE  A.BASIS_YYYYMMDD >= p_start_yyyymmdd --TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD')
			--		AND    A.basis_yyyymmdd <= p_end_yyyymmdd --TO_CHAR(ADD_MONTHS(CURRENT_TIMESTAMP, (1)*12), 'YYYYMMDD')

			--		UNION ALL
			--		SELECT 'W_' + A.BASIS_YYYYMM + A.ISO_WEEK   AS COLUMN_NAME
			--			, CASE WHEN INSTR(PARTIAL_WEEK_NAME, 'A') <> 0 THEN A.WEEK_NAME + '+'
			--			WHEN INSTR(PARTIAL_WEEK_NAME, 'B') <> 0 THEN '+' + A.WEEK_NAME
			--			ELSE A.WEEK_NAME END AS COLUMN_LABEL_NAME	-- 20190610
			--		, CASE WHEN INSTR(PARTIAL_WEEK_NAME, 'A') <> 0 THEN A.WEEK_NAME + '+'
			--			WHEN INSTR(PARTIAL_WEEK_NAME, 'B') <> 0 THEN '+' + A.WEEK_NAME
			--			ELSE A.WEEK_NAME END          AS SMALL_CLASS_LABEL_NAME
			--			, A.MONTH_NAME         AS LARGE_CLASS_LABEL_NAME
			--			, ''                   AS DAY_CODE
			--			, A.BASIS_START_DATE + TO_CHAR(21) AS SORT_ORDER_NO
			--		FROM   SCM_SYS_CALENDAR_M A
			--		WHERE  A.BASIS_YYYYMMDD >= p_start_yyyymmdd --TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD')
			--		AND    A.BASIS_YYYYMMDD <= p_end_yyyymmdd --TO_CHAR(ADD_MONTHS(CURRENT_TIMESTAMP, (1)*12), 'YYYYMMDD')
			--		GROUP BY A.BASIS_YYYYMM
			--				, A.ISO_WEEK
			--				, A.WEEK_NAME
			--				, PARTIAL_WEEK_NAME	-- 20190610
			--				, A.MONTH_NAME
			--				, A.BASIS_START_DATE

			--		UNION ALL
			--		SELECT 'M_' + A.BASIS_YYYYMM  AS COLUMN_NAME
			--				, A.MONTH_NAME          AS COLUMN_LABEL_NAME
			--				, A.MONTH_NAME          AS SMALL_CLASS_LABEL_NAME
			--				, A.MONTH_NAME          AS LARGE_CLASS_LABEL_NAME
			--				, ''                    AS DAY_CODE
			--				, MIN(A.BASIS_START_DATE) + TO_CHAR('01') AS SORT_ORDER_NO
			--		FROM    SCM_SYS_CALENDAR_M A
			--		WHERE  A.BASIS_YYYYMMDD >= p_start_yyyymmdd --TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD')
			--		AND    A.BASIS_YYYYMMDD <= p_end_yyyymmdd --TO_CHAR(ADD_MONTHS(CURRENT_TIMESTAMP, (1)*12), 'YYYYMMDD')
			--		GROUP BY A.BASIS_YYYYMM
			--				, A.MONTH_NAME
			--	) T
			--  ORDER BY SORT_ORDER_NO   ;
		  END IF;
END;
/

-- DMF0003_GET_SPREAD_TITLE_PSI → PKG_DMF0003.P_DMF0003_GET_SPREAD_TITLE_PSI에 등록됨
CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0003_GET_SPREAD_TITLE_PSI
(
    p_start_yyyymmdd  VARCHAR2,
    p_end_yyyymmdd    VARCHAR2,
	p_created_by	   VARCHAR2,
	p_division_id	   VARCHAR2
)
AS

    v_user_col_cnt INTEGER;
    v_program_id VARCHAR2(4000 CHAR);
    v_sheet_name VARCHAR2(4000 CHAR);
BEGIN
	--DMF0003_GET_SPREAD_TITLE_PSI '20230101', '20231231', 'chano0612', '81'



	v_program_id := 'DMF0003';
	v_sheet_name := 'PSI';
	v_user_col_cnt := 0;

	SELECT COUNT(*)
  INTO v_user_col_cnt
	FROM   SCM_MST_TITLESET_USER U
	WHERE  1 = 1
	AND    U.PROGRAM_ID = v_program_id
    AND    U.SHEET_NAME = v_sheet_name
    AND    U.USER_ID    = p_created_by;


	IF v_user_col_cnt > 0 THEN
		SELECT * FROM
		(
		SELECT U.PROGRAM_ID
				, U.SHEET_NAME
				, U.COLUMN_NAME
				, C.COLUMN_LABEL_NAME
				, U.SORT_ORDER_NO        --TO_CHAR(U.SORT_ORDER_NO) AS SORT_ORDER_NO
				, U.DATA_SORT_METHOD_CODE
				, C.SMALL_CLASS_LABEL_NAME
				, C.LARGE_CLASS_LABEL_NAME
				, '' AS DAY_CODE
				, C.FIXED_FLAG
				, C.COLUMN_WIDTH
				, C.CELL_CONTROL_OBJECT_TYPE_CODE
				, C.CELL_COMBO_DATA_TYPE
				, C.DATA_SCALE_NUMBER
				, C.DATA_MAX_LENGTH
				, C.HORIZONTAL_ALIGN_CODE
				, C.UPPERCASE_APPLY_FLAG
				, C.VISIBLE_FLAG
				, C.DEFAULT_FLAG
				, C.USER_SELECTABLE_FLAG
				, C.VALID_YN
				, C.DIVISION_ID
		FROM   SCM_MST_TITLESET_USER U
				, SCM_MST_SHEET_COLUMNS C
		WHERE  1 = 1
		AND    U.PROGRAM_ID  = C.PROGRAM_ID
		AND    U.SHEET_NAME  = C.SHEET_NAME
		AND    U.COLUMN_NAME = C.COLUMN_NAME
		AND    U.PROGRAM_ID  = v_program_id
		AND    U.SHEET_NAME  = v_sheet_name
		AND    U.USER_ID     = p_created_by
		AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
		AND	 p_division_id IN (SELECT token FROM TABLE(fn_string_split(C.DIVISION_ID ,',')) )		-- 20180620 division 추가


		UNION ALL

		SELECT C.PROGRAM_ID
				, C.SHEET_NAME
				, C.COLUMN_NAME
				, C.COLUMN_LABEL_NAME
				, C.SORT_ORDER_NO        --TO_CHAR(U.SORT_ORDER_NO) AS SORT_ORDER_NO
				, C.DATA_SORT_METHOD_CODE
				, C.SMALL_CLASS_LABEL_NAME
				, C.LARGE_CLASS_LABEL_NAME
				, '' AS DAY_CODE
				, C.FIXED_FLAG
				, C.COLUMN_WIDTH
				, C.CELL_CONTROL_OBJECT_TYPE_CODE
				, C.CELL_COMBO_DATA_TYPE
				, C.DATA_SCALE_NUMBER
				, C.DATA_MAX_LENGTH
				, C.HORIZONTAL_ALIGN_CODE
				, C.UPPERCASE_APPLY_FLAG
				, C.VISIBLE_FLAG
				, C.DEFAULT_FLAG
				, C.USER_SELECTABLE_FLAG
				, C.VALID_YN
				, C.DIVISION_ID
		FROM   SCM_MST_SHEET_COLUMNS C
		WHERE  1 = 1
		AND    C.PROGRAM_ID  = v_program_id
		AND    C.SHEET_NAME  = v_sheet_name
		AND    C.VISIBLE_FLAG = ''
		AND    C.DEFAULT_FLAG IS NULL
		AND    C.VALID_YN     = 'Y'
		AND	 p_division_id IN (SELECT token FROM TABLE(fn_string_split(C.DIVISION_ID ,',')) )		-- 20180620 division 추가
		) A ORDER BY A.SORT_ORDER_NO

		--UNION ALL

		--SELECT v_program_id   AS PROGRAM_ID
		--		, v_sheet_name AS SHEET_NAME
		--		, T.COLUMN_NAME
		--		, T.COLUMN_LABEL_NAME
		--		, T.SORT_ORDER_NO
		--		, ''         AS DATA_SORT_METHOD_CODE
		--		, T.SMALL_CLASS_LABEL_NAME
		--		, T.LARGE_CLASS_LABEL_NAME
		--		, T.DAY_CODE
		--		, ''         AS FIXED_FLAG
		--		, 50         AS COLUMN_WIDTH
		--		, T.CELL_CONTROL_OBJECT_TYPE_CODE   --'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
		--		, ''         AS CELL_COMBO_DATA_TYPE
		--		, ''         AS DATA_SCALE_NUMBER
		--		, ''         AS DATA_MAX_LENGTH
		--		, 'R'        AS HORIZONTAL_ALIGN_CODE
		--		, 'Y'        AS UPPERCASE_APPLY_FLAG
		--		, 'Y'        AS VISIBLE_FLAG
		--		, ''         AS DEFAULT_FLAG
		--		, ''         AS USER_SELECTABLE_FLAG
		--		, ''         AS VALID_YN
		--		, ''			AS DIVISION_ID
		--FROM  (
		--		SELECT 'D_' + A.BASIS_YYYYMMDD   AS COLUMN_NAME
		--			, A.CALENDAR_DAY            AS COLUMN_LABEL_NAME
		--			, CASE WHEN INSTR(PARTIAL_WEEK_NAME, 'A') <> 0 THEN A.WEEK_NAME + '+'
		--				WHEN INSTR(PARTIAL_WEEK_NAME, 'B') <> 0 THEN '+' + A.WEEK_NAME
		--				ELSE A.WEEK_NAME END               AS SMALL_CLASS_LABEL_NAME
		--			, A.MONTH_NAME              AS LARGE_CLASS_LABEL_NAME
		--			, A.DAYOFWEEK               AS DAY_CODE
		--			, A.BASIS_YYYYMMDD + TO_CHAR(31) AS SORT_ORDER_NO
		--			, 'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
		--		FROM   SCM_SYS_CALENDAR_M A
		--		WHERE  A.BASIS_YYYYMMDD >= p_start_yyyymmdd --TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD')
		--		AND    A.basis_yyyymmdd <= p_end_yyyymmdd --TO_CHAR(ADD_MONTHS(CURRENT_TIMESTAMP, (1)*12), 'YYYYMMDD')

		--		UNION ALL
		--		SELECT 'W_' + A.BASIS_YYYYMM + A.ISO_WEEK   AS COLUMN_NAME
		--			, CASE WHEN INSTR(PARTIAL_WEEK_NAME, 'A') <> 0 THEN A.WEEK_NAME + '+'
		--				WHEN INSTR(PARTIAL_WEEK_NAME, 'B') <> 0 THEN '+' + A.WEEK_NAME
		--				ELSE A.WEEK_NAME END AS COLUMN_LABEL_NAME	-- 20190610
		--			, CASE WHEN INSTR(PARTIAL_WEEK_NAME, 'A') <> 0 THEN A.WEEK_NAME + '+'
		--				WHEN INSTR(PARTIAL_WEEK_NAME, 'B') <> 0 THEN '+' + A.WEEK_NAME
		--				ELSE A.WEEK_NAME END          AS SMALL_CLASS_LABEL_NAME
		--			, A.MONTH_NAME         AS LARGE_CLASS_LABEL_NAME
		--			, ''                   AS DAY_CODE
		--			, A.BASIS_START_DATE + TO_CHAR(21) AS SORT_ORDER_NO
		--			, 'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
		--		FROM   SCM_SYS_CALENDAR_M A
		--		WHERE  A.BASIS_YYYYMMDD >= p_start_yyyymmdd --TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD')
		--		AND    A.BASIS_YYYYMMDD <= p_end_yyyymmdd --TO_CHAR(ADD_MONTHS(CURRENT_TIMESTAMP, (1)*12), 'YYYYMMDD')
		--		GROUP BY A.BASIS_YYYYMM
		--				, A.ISO_WEEK
		--				, A.WEEK_NAME
		--				, PARTIAL_WEEK_NAME	-- 20190610
		--				, A.MONTH_NAME
		--				, A.BASIS_START_DATE
		--		UNION ALL
		--		SELECT 'M_' + A.BASIS_YYYYMM  AS COLUMN_NAME
		--				, A.MONTH_NAME          AS COLUMN_LABEL_NAME
		--				, A.MONTH_NAME          AS SMALL_CLASS_LABEL_NAME
		--				, A.MONTH_NAME          AS LARGE_CLASS_LABEL_NAME
		--				, ''                    AS DAY_CODE
		--				, MIN(A.BASIS_START_DATE) + TO_CHAR('01') AS SORT_ORDER_NO
		--				, 'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
		--		FROM    SCM_SYS_CALENDAR_M A
		--		WHERE  A.BASIS_YYYYMMDD >= p_start_yyyymmdd --TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD')
		--		AND    A.BASIS_YYYYMMDD <= p_end_yyyymmdd --TO_CHAR(ADD_MONTHS(CURRENT_TIMESTAMP, (1)*12), 'YYYYMMDD')
		--		GROUP BY A.BASIS_YYYYMM
		--				, A.MONTH_NAME
		--	) T
		--  ORDER BY SORT_ORDER_NO   ;
	  ELSE
			DBMS_OUTPUT.PUT_LINE('2');
			SELECT * FROM (
			SELECT C.PROGRAM_ID
					, C.SHEET_NAME
					, C.COLUMN_NAME
					, C.COLUMN_LABEL_NAME
					, C.SORT_ORDER_NO        --TO_CHAR(U.SORT_ORDER_NO) AS SORT_ORDER_NO
					, C.DATA_SORT_METHOD_CODE
					, C.SMALL_CLASS_LABEL_NAME
					, C.LARGE_CLASS_LABEL_NAME
					, '' AS DAY_CODE
					, C.FIXED_FLAG
					, C.COLUMN_WIDTH
					, C.CELL_CONTROL_OBJECT_TYPE_CODE
					, C.CELL_COMBO_DATA_TYPE
					, C.DATA_SCALE_NUMBER
					, C.DATA_MAX_LENGTH
					, C.HORIZONTAL_ALIGN_CODE
					, C.UPPERCASE_APPLY_FLAG
					, C.VISIBLE_FLAG
					, C.DEFAULT_FLAG
					, C.USER_SELECTABLE_FLAG
					, C.VALID_YN
					, C.DIVISION_ID
			FROM   SCM_MST_SHEET_COLUMNS C
			WHERE  1 = 1
			AND    C.PROGRAM_ID  = v_program_id
			AND    C.SHEET_NAME  = v_sheet_name
			AND    C.DEFAULT_FLAG = 'Y'
			AND    C.VALID_YN     = 'Y'
			AND	 p_division_id IN (SELECT token FROM TABLE(fn_string_split(C.DIVISION_ID ,',')) )		-- 20180620 division 추가

			UNION ALL

			SELECT C.PROGRAM_ID
					, C.SHEET_NAME
					, C.COLUMN_NAME
					, C.COLUMN_LABEL_NAME
					, C.SORT_ORDER_NO        --TO_CHAR(U.SORT_ORDER_NO) AS SORT_ORDER_NO
					, C.DATA_SORT_METHOD_CODE
					, C.SMALL_CLASS_LABEL_NAME
					, C.LARGE_CLASS_LABEL_NAME
					, '' AS DAY_CODE
					, C.FIXED_FLAG
					, C.COLUMN_WIDTH
					, C.CELL_CONTROL_OBJECT_TYPE_CODE
					, C.CELL_COMBO_DATA_TYPE
					, C.DATA_SCALE_NUMBER
					, C.DATA_MAX_LENGTH
					, C.HORIZONTAL_ALIGN_CODE
					, C.UPPERCASE_APPLY_FLAG
					, C.VISIBLE_FLAG
					, C.DEFAULT_FLAG
					, C.USER_SELECTABLE_FLAG
					, C.VALID_YN
					, C.DIVISION_ID
			FROM   SCM_MST_SHEET_COLUMNS C
			WHERE  1 = 1
			AND    C.PROGRAM_ID  = v_program_id
			AND    C.SHEET_NAME  = v_sheet_name
			AND    C.VISIBLE_FLAG = ''
			AND    C.DEFAULT_FLAG IS NULL
			AND    C.VALID_YN     = 'Y'
			AND	 p_division_id IN (SELECT token FROM TABLE(fn_string_split(C.DIVISION_ID ,',')) )		-- 20180620 division 추가
			) A ORDER BY A.SORT_ORDER_NO
			--UNION ALL

			--SELECT v_program_id   AS PROGRAM_ID
			--		, v_sheet_name AS SHEET_NAME
			--		, T.COLUMN_NAME
			--		, T.COLUMN_LABEL_NAME
			--		, T.SORT_ORDER_NO
			--		, ''         AS DATA_SORT_METHOD_CODE
			--		, T.SMALL_CLASS_LABEL_NAME
			--		, T.LARGE_CLASS_LABEL_NAME
			--		, T.DAY_CODE
			--		, ''         AS FIXED_FLAG
			--		, 50         AS COLUMN_WIDTH
			--		, 'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
			--		, ''         AS CELL_COMBO_DATA_TYPE
			--		, ''         AS DATA_SCALE_NUMBER
			--		, ''         AS DATA_MAX_LENGTH
			--		, 'R'        AS HORIZONTAL_ALIGN_CODE
			--		, 'Y'        AS UPPERCASE_APPLY_FLAG
			--		, 'Y'        AS VISIBLE_FLAG
			--		, ''         AS DEFAULT_FLAG
			--		, ''         AS USER_SELECTABLE_FLAG
			--		, ''         AS VALID_YN
			--		, ''			AS DIVISION_ID
			--FROM  (
			--		SELECT 'D_' + A.BASIS_YYYYMMDD   AS COLUMN_NAME
			--			, A.CALENDAR_DAY            AS COLUMN_LABEL_NAME
			--			, CASE WHEN INSTR(PARTIAL_WEEK_NAME, 'A') <> 0 THEN A.WEEK_NAME + '+'
			--			WHEN INSTR(PARTIAL_WEEK_NAME, 'B') <> 0 THEN '+' + A.WEEK_NAME
			--			ELSE A.WEEK_NAME END               AS SMALL_CLASS_LABEL_NAME
			--			, A.MONTH_NAME              AS LARGE_CLASS_LABEL_NAME
			--			, A.DAYOFWEEK               AS DAY_CODE
			--			, A.BASIS_YYYYMMDD + TO_CHAR(31) AS SORT_ORDER_NO
			--		FROM   SCM_SYS_CALENDAR_M A
			--		WHERE  A.BASIS_YYYYMMDD >= p_start_yyyymmdd --TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD')
			--		AND    A.basis_yyyymmdd <= p_end_yyyymmdd --TO_CHAR(ADD_MONTHS(CURRENT_TIMESTAMP, (1)*12), 'YYYYMMDD')

			--		UNION ALL
			--		SELECT 'W_' + A.BASIS_YYYYMM + A.ISO_WEEK   AS COLUMN_NAME
			--			, CASE WHEN INSTR(PARTIAL_WEEK_NAME, 'A') <> 0 THEN A.WEEK_NAME + '+'
			--			WHEN INSTR(PARTIAL_WEEK_NAME, 'B') <> 0 THEN '+' + A.WEEK_NAME
			--			ELSE A.WEEK_NAME END AS COLUMN_LABEL_NAME	-- 20190610
			--		, CASE WHEN INSTR(PARTIAL_WEEK_NAME, 'A') <> 0 THEN A.WEEK_NAME + '+'
			--			WHEN INSTR(PARTIAL_WEEK_NAME, 'B') <> 0 THEN '+' + A.WEEK_NAME
			--			ELSE A.WEEK_NAME END          AS SMALL_CLASS_LABEL_NAME
			--			, A.MONTH_NAME         AS LARGE_CLASS_LABEL_NAME
			--			, ''                   AS DAY_CODE
			--			, A.BASIS_START_DATE + TO_CHAR(21) AS SORT_ORDER_NO
			--		FROM   SCM_SYS_CALENDAR_M A
			--		WHERE  A.BASIS_YYYYMMDD >= p_start_yyyymmdd --TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD')
			--		AND    A.BASIS_YYYYMMDD <= p_end_yyyymmdd --TO_CHAR(ADD_MONTHS(CURRENT_TIMESTAMP, (1)*12), 'YYYYMMDD')
			--		GROUP BY A.BASIS_YYYYMM
			--				, A.ISO_WEEK
			--				, A.WEEK_NAME
			--				, PARTIAL_WEEK_NAME	-- 20190610
			--				, A.MONTH_NAME
			--				, A.BASIS_START_DATE

			--		UNION ALL
			--		SELECT 'M_' + A.BASIS_YYYYMM  AS COLUMN_NAME
			--				, A.MONTH_NAME          AS COLUMN_LABEL_NAME
			--				, A.MONTH_NAME          AS SMALL_CLASS_LABEL_NAME
			--				, A.MONTH_NAME          AS LARGE_CLASS_LABEL_NAME
			--				, ''                    AS DAY_CODE
			--				, MIN(A.BASIS_START_DATE) + TO_CHAR('01') AS SORT_ORDER_NO
			--		FROM    SCM_SYS_CALENDAR_M A
			--		WHERE  A.BASIS_YYYYMMDD >= p_start_yyyymmdd --TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD')
			--		AND    A.BASIS_YYYYMMDD <= p_end_yyyymmdd --TO_CHAR(ADD_MONTHS(CURRENT_TIMESTAMP, (1)*12), 'YYYYMMDD')
			--		GROUP BY A.BASIS_YYYYMM
			--				, A.MONTH_NAME
			--	) T
			--  ORDER BY SORT_ORDER_NO   ;
		  END IF;
END;
/

-- DMF0003_GET_SPREAD_TITLE_PSI_POPUP → PKG_DMF0003.P_DMF0003_GET_SPREAD_TITLE_PSI_POPUP에 등록됨
CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0003_GET_SPREAD_TITLE_PSI_POPUP
(
    p_start_yyyymmdd  VARCHAR2,
    p_end_yyyymmdd    VARCHAR2,
	p_created_by	   VARCHAR2,
	p_division_id	   VARCHAR2
)
AS

    v_user_col_cnt INTEGER;
    v_program_id VARCHAR2(4000 CHAR);
    v_sheet_name VARCHAR2(4000 CHAR);
BEGIN




	v_program_id := 'DMF0003';
	v_sheet_name := 'Customer Demand Analysis';
	v_user_col_cnt := 0;

	SELECT COUNT(*)
  INTO v_user_col_cnt
	FROM   SCM_MST_TITLESET_USER U
	WHERE  1 = 1
	AND    U.PROGRAM_ID = v_program_id
    AND    U.SHEET_NAME = v_sheet_name
    AND    U.USER_ID    = p_created_by;


	IF v_user_col_cnt > 0 THEN
		SELECT * FROM
		(
		SELECT U.PROGRAM_ID
				, U.SHEET_NAME
				, U.COLUMN_NAME
				, C.COLUMN_LABEL_NAME
				, U.SORT_ORDER_NO        --TO_CHAR(U.SORT_ORDER_NO) AS SORT_ORDER_NO
				, U.DATA_SORT_METHOD_CODE
				, C.SMALL_CLASS_LABEL_NAME
				, C.LARGE_CLASS_LABEL_NAME
				, '' AS DAY_CODE
				, C.FIXED_FLAG
				, C.COLUMN_WIDTH
				, C.CELL_CONTROL_OBJECT_TYPE_CODE
				, C.CELL_COMBO_DATA_TYPE
				, C.DATA_SCALE_NUMBER
				, C.DATA_MAX_LENGTH
				, C.HORIZONTAL_ALIGN_CODE
				, C.UPPERCASE_APPLY_FLAG
				, C.VISIBLE_FLAG
				, C.DEFAULT_FLAG
				, C.USER_SELECTABLE_FLAG
				, C.VALID_YN
				, C.DIVISION_ID
		FROM   SCM_MST_TITLESET_USER U
				, SCM_MST_SHEET_COLUMNS C
		WHERE  1 = 1
		AND    U.PROGRAM_ID  = C.PROGRAM_ID
		AND    U.SHEET_NAME  = C.SHEET_NAME
		AND    U.COLUMN_NAME = C.COLUMN_NAME
		AND    U.PROGRAM_ID  = v_program_id
		AND    U.SHEET_NAME  = v_sheet_name
		AND    U.USER_ID     = p_created_by
		AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
		AND	 p_division_id IN (SELECT token FROM TABLE(fn_string_split(C.DIVISION_ID ,',')) )		-- 20180620 division 추가


		UNION ALL

		SELECT C.PROGRAM_ID
				, C.SHEET_NAME
				, C.COLUMN_NAME
				, C.COLUMN_LABEL_NAME
				, C.SORT_ORDER_NO        --TO_CHAR(U.SORT_ORDER_NO) AS SORT_ORDER_NO
				, C.DATA_SORT_METHOD_CODE
				, C.SMALL_CLASS_LABEL_NAME
				, C.LARGE_CLASS_LABEL_NAME
				, '' AS DAY_CODE
				, C.FIXED_FLAG
				, C.COLUMN_WIDTH
				, C.CELL_CONTROL_OBJECT_TYPE_CODE
				, C.CELL_COMBO_DATA_TYPE
				, C.DATA_SCALE_NUMBER
				, C.DATA_MAX_LENGTH
				, C.HORIZONTAL_ALIGN_CODE
				, C.UPPERCASE_APPLY_FLAG
				, C.VISIBLE_FLAG
				, C.DEFAULT_FLAG
				, C.USER_SELECTABLE_FLAG
				, C.VALID_YN
				, C.DIVISION_ID
		FROM   SCM_MST_SHEET_COLUMNS C
		WHERE  1 = 1
		AND    C.PROGRAM_ID  = v_program_id
		AND    C.SHEET_NAME  = v_sheet_name
		AND    C.VISIBLE_FLAG = ''
		AND    C.DEFAULT_FLAG IS NULL
		AND    C.VALID_YN     = 'Y'
		AND	 p_division_id IN (SELECT token FROM TABLE(fn_string_split(C.DIVISION_ID ,',')) )		-- 20180620 division 추가
		) A ORDER BY A.SORT_ORDER_NO

	  ELSE
			DBMS_OUTPUT.PUT_LINE('2');
			SELECT * FROM (
			SELECT C.PROGRAM_ID
					, C.SHEET_NAME
					, C.COLUMN_NAME
					, C.COLUMN_LABEL_NAME
					, C.SORT_ORDER_NO        --TO_CHAR(U.SORT_ORDER_NO) AS SORT_ORDER_NO
					, C.DATA_SORT_METHOD_CODE
					, C.SMALL_CLASS_LABEL_NAME
					, C.LARGE_CLASS_LABEL_NAME
					, '' AS DAY_CODE
					, C.FIXED_FLAG
					, C.COLUMN_WIDTH
					, C.CELL_CONTROL_OBJECT_TYPE_CODE
					, C.CELL_COMBO_DATA_TYPE
					, C.DATA_SCALE_NUMBER
					, C.DATA_MAX_LENGTH
					, C.HORIZONTAL_ALIGN_CODE
					, C.UPPERCASE_APPLY_FLAG
					, C.VISIBLE_FLAG
					, C.DEFAULT_FLAG
					, C.USER_SELECTABLE_FLAG
					, C.VALID_YN
					, C.DIVISION_ID
			FROM   SCM_MST_SHEET_COLUMNS C
			WHERE  1 = 1
			AND    C.PROGRAM_ID  = v_program_id
			AND    C.SHEET_NAME  = v_sheet_name
			AND    C.DEFAULT_FLAG = 'Y'
			AND    C.VALID_YN     = 'Y'
			AND	 p_division_id IN (SELECT token FROM TABLE(fn_string_split(C.DIVISION_ID ,',')) )		-- 20180620 division 추가

			UNION ALL

			SELECT C.PROGRAM_ID
					, C.SHEET_NAME
					, C.COLUMN_NAME
					, C.COLUMN_LABEL_NAME
					, C.SORT_ORDER_NO        --TO_CHAR(U.SORT_ORDER_NO) AS SORT_ORDER_NO
					, C.DATA_SORT_METHOD_CODE
					, C.SMALL_CLASS_LABEL_NAME
					, C.LARGE_CLASS_LABEL_NAME
					, '' AS DAY_CODE
					, C.FIXED_FLAG
					, C.COLUMN_WIDTH
					, C.CELL_CONTROL_OBJECT_TYPE_CODE
					, C.CELL_COMBO_DATA_TYPE
					, C.DATA_SCALE_NUMBER
					, C.DATA_MAX_LENGTH
					, C.HORIZONTAL_ALIGN_CODE
					, C.UPPERCASE_APPLY_FLAG
					, C.VISIBLE_FLAG
					, C.DEFAULT_FLAG
					, C.USER_SELECTABLE_FLAG
					, C.VALID_YN
					, C.DIVISION_ID
			FROM   SCM_MST_SHEET_COLUMNS C
			WHERE  1 = 1
			AND    C.PROGRAM_ID  = v_program_id
			AND    C.SHEET_NAME  = v_sheet_name
			AND    C.VISIBLE_FLAG = ''
			AND    C.DEFAULT_FLAG IS NULL
			AND    C.VALID_YN     = 'Y'
			AND	 p_division_id IN (SELECT token FROM TABLE(fn_string_split(C.DIVISION_ID ,',')) )		-- 20180620 division 추가
			) A ORDER BY A.SORT_ORDER_NO
			--UNION ALL

			--SELECT v_program_id   AS PROGRAM_ID
			--		, v_sheet_name AS SHEET_NAME
			--		, T.COLUMN_NAME
			--		, T.COLUMN_LABEL_NAME
			--		, T.SORT_ORDER_NO
			--		, ''         AS DATA_SORT_METHOD_CODE
			--		, T.SMALL_CLASS_LABEL_NAME
			--		, T.LARGE_CLASS_LABEL_NAME
			--		, T.DAY_CODE
			--		, ''         AS FIXED_FLAG
			--		, 50         AS COLUMN_WIDTH
			--		, 'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
			--		, ''         AS CELL_COMBO_DATA_TYPE
			--		, ''         AS DATA_SCALE_NUMBER
			--		, ''         AS DATA_MAX_LENGTH
			--		, 'R'        AS HORIZONTAL_ALIGN_CODE
			--		, 'Y'        AS UPPERCASE_APPLY_FLAG
			--		, 'Y'        AS VISIBLE_FLAG
			--		, ''         AS DEFAULT_FLAG
			--		, ''         AS USER_SELECTABLE_FLAG
			--		, ''         AS VALID_YN
			--		, ''			AS DIVISION_ID
			--FROM  (
			--		SELECT 'D_' + A.BASIS_YYYYMMDD   AS COLUMN_NAME
			--			, A.CALENDAR_DAY            AS COLUMN_LABEL_NAME
			--			, CASE WHEN INSTR(PARTIAL_WEEK_NAME, 'A') <> 0 THEN A.WEEK_NAME + '+'
			--			WHEN INSTR(PARTIAL_WEEK_NAME, 'B') <> 0 THEN '+' + A.WEEK_NAME
			--			ELSE A.WEEK_NAME END               AS SMALL_CLASS_LABEL_NAME
			--			, A.MONTH_NAME              AS LARGE_CLASS_LABEL_NAME
			--			, A.DAYOFWEEK               AS DAY_CODE
			--			, A.BASIS_YYYYMMDD + TO_CHAR(31) AS SORT_ORDER_NO
			--		FROM   SCM_SYS_CALENDAR_M A
			--		WHERE  A.BASIS_YYYYMMDD >= p_start_yyyymmdd --TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD')
			--		AND    A.basis_yyyymmdd <= p_end_yyyymmdd --TO_CHAR(ADD_MONTHS(CURRENT_TIMESTAMP, (1)*12), 'YYYYMMDD')

			--		UNION ALL
			--		SELECT 'W_' + A.BASIS_YYYYMM + A.ISO_WEEK   AS COLUMN_NAME
			--			, CASE WHEN INSTR(PARTIAL_WEEK_NAME, 'A') <> 0 THEN A.WEEK_NAME + '+'
			--			WHEN INSTR(PARTIAL_WEEK_NAME, 'B') <> 0 THEN '+' + A.WEEK_NAME
			--			ELSE A.WEEK_NAME END AS COLUMN_LABEL_NAME	-- 20190610
			--		, CASE WHEN INSTR(PARTIAL_WEEK_NAME, 'A') <> 0 THEN A.WEEK_NAME + '+'
			--			WHEN INSTR(PARTIAL_WEEK_NAME, 'B') <> 0 THEN '+' + A.WEEK_NAME
			--			ELSE A.WEEK_NAME END          AS SMALL_CLASS_LABEL_NAME
			--			, A.MONTH_NAME         AS LARGE_CLASS_LABEL_NAME
			--			, ''                   AS DAY_CODE
			--			, A.BASIS_START_DATE + TO_CHAR(21) AS SORT_ORDER_NO
			--		FROM   SCM_SYS_CALENDAR_M A
			--		WHERE  A.BASIS_YYYYMMDD >= p_start_yyyymmdd --TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD')
			--		AND    A.BASIS_YYYYMMDD <= p_end_yyyymmdd --TO_CHAR(ADD_MONTHS(CURRENT_TIMESTAMP, (1)*12), 'YYYYMMDD')
			--		GROUP BY A.BASIS_YYYYMM
			--				, A.ISO_WEEK
			--				, A.WEEK_NAME
			--				, PARTIAL_WEEK_NAME	-- 20190610
			--				, A.MONTH_NAME
			--				, A.BASIS_START_DATE

			--		UNION ALL
			--		SELECT 'M_' + A.BASIS_YYYYMM  AS COLUMN_NAME
			--				, A.MONTH_NAME          AS COLUMN_LABEL_NAME
			--				, A.MONTH_NAME          AS SMALL_CLASS_LABEL_NAME
			--				, A.MONTH_NAME          AS LARGE_CLASS_LABEL_NAME
			--				, ''                    AS DAY_CODE
			--				, MIN(A.BASIS_START_DATE) + TO_CHAR('01') AS SORT_ORDER_NO
			--		FROM    SCM_SYS_CALENDAR_M A
			--		WHERE  A.BASIS_YYYYMMDD >= p_start_yyyymmdd --TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD')
			--		AND    A.BASIS_YYYYMMDD <= p_end_yyyymmdd --TO_CHAR(ADD_MONTHS(CURRENT_TIMESTAMP, (1)*12), 'YYYYMMDD')
			--		GROUP BY A.BASIS_YYYYMM
			--				, A.MONTH_NAME
			--	) T
			--  ORDER BY SORT_ORDER_NO   ;
		  END IF;
END;
/

-- DMF0003_MKT_FCST_SALES_PLAN_SYNC → PKG_DMF0003.P_DMF0003_MKT_FCST_SALES_PLAN_SYNC에 등록됨
CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0003_MKT_FCST_SALES_PLAN_SYNC
(

	-- Add the parameters for the stored procedure here
	p_division_id				VARCHAR2		,
	p_CREATED_BY               VARCHAR2

/*
 * Program ID   : DMF0003_MKT_FCST_SALES_PLAN_SYNC
 * Description  : MKT_FCST & SALES_PLAN DATA SYNC
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 20230607   chano0612 고희선님 요청으로 MKT_FCST 와 SALES_PLAN 데이터 SYNC
  */
)
AS

/*
 * ========================================
 * [변환검증] 2026-03-02 20:37:03
 * 파일: dbo.DMF0003_MKT_FCST_SALES_PLAN_SYNC.sql
 * ----------------------------------------
 * ⚠ IF: IF:3  END IF:1  차이:+2
 * ⚠ BEGIN: BEGIN:5  END:6  차이:-1
 * ----------------------------------------
 * BEGIN 위치: L34, L82, L84, L287, L358
 * END;  위치: L88, L305, L321, L364, L367
 * ----------------------------------------
 * 수정 완료 후 이 주석 블록을 삭제하세요.
 * ========================================
 */



    v_recv_division_id VARCHAR2(4000 CHAR);
    v_delimiter VARCHAR2(1 CHAR);
    v_max_loop_cnt INTEGER := 0;
    v_mst_loop_cnt INTEGER := 0;
    v_division_id VARCHAR2(4000 CHAR);
    v_created_by VARCHAR2(4000 CHAR);
    v_program_name VARCHAR2(150 CHAR) := 'DMF0003_MKT_FCST_SALES_PLAN_SYNC';
    v_log_type VARCHAR2(30 CHAR);
    n_log_count INTEGER := 0;
    v_log_message VARCHAR2(1000 CHAR);
    v_description VARCHAR2(500 CHAR);
    d_event_date DATE;
BEGIN
            	-- CUTOFF 변수 설정

	-- 스플릿관련 변수

	v_recv_division_id := NULL;
	v_recv_division_id := p_division_id;

	v_delimiter := '^'; -- 데이터 구분자




	--            있는경우[매개변수로 처리]
	--			  없는경우[ROLLING 에서 처리하므로 'CUTOFF'로 처리]
	IF NVL(p_CREATED_BY, NULL) IS NULL THEN
		v_created_by := 'CUTOFF';
	ELSE
		v_created_by := p_CREATED_BY;

	-- LOG 용 변수 설정






		v_log_type := 'START';
		v_log_message := '########## Start of procedure ##########';
		v_description := 'p_division_id : '  ||  p_division_id  ||  ' / '  || 'v_created_by : '  ||   NVL(v_created_by, 'NULL');
		d_event_date := SYSTIMESTAMP;
		PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
		v_log_message := NULL      /*; -- <- 변수 재사용을 위하여 초기화해야함 --*/
		-- 시작 LOG  (END)

		-- 트랜잭션 (START)

	-- -----------------------------------------------------------------------------------------
		BEGIN TRY
	-- -----------------------------------------------------------------------------------------
		-- 프로시저 LOOP 길이를 판단
		v_max_loop_cnt := SCM_ARR_SPL_CNT(p_division_id, v_delimiter);
		-- SELECT v_max_loop_cnt  as 'v_max_loop_cnt (input된 division값)';  -- 확인용 81^82^83
		-- SELECT TO_CHAR(v_max_loop_cnt)  as 'v_max_loop_cnt (input된 division값)';  -- 확인용 81^82^83
DBMS_OUTPUT.PUT_LINE('A--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
        /*---------------------------------------------------------------*/
		WHILE LENGTH(v_recv_division_id) > 0 AND v_mst_loop_cnt < v_max_loop_cnt

		BEGIN
			-- 각 컬럼들에 대한 스플릿처리로직 스타트
			BEGIN
				-- Loop Count +1씩 증가시킴
				v_mst_loop_cnt := v_mst_loop_cnt || 1;
				v_division_id := SCM_ARR_SPL_VAL (p_division_id  ,  v_delimiter , v_mst_loop_cnt) ;
			END;

          /*----------------------------- MULTI & SINGLE ROW START -------------------------------------------------------------*/
		  /*-- max_loop_cnt:전체 Row수 , mst_loop_cnt:1씩 증가시켜서 전체 Row수 까지만 로직을 수행하도록함 --*/
          IF       v_mst_loop_cnt <= v_max_loop_cnt THEN
				-- 기존 정보 삭제
				delete dm_pln_sales_plan
				-- where yyyymmdd >= TO_CHAR(7 + (/* TODO:DATEDIFF(week,0,(SYSDATE) + (-1*7) */ ))*7SYSDATE + (-1*7) ), 7), 'YYYYMMDD')
				 where yyyymmdd >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7), 'YYYYMMDD')
				   and division_id = v_division_id
				   -- MKT/금형비처럼 사람이 넣은것 삭제.
				   and item_id in (select item_id  from scm_mst_item_sn  group by item_id )
				   -- Sales Plan을 Unsync 하고 한번이라도 수정한 건에 대해서는 삭제 하지 않음.
				   and NOT EXISTS (
							select A.DIVISION_ID
							  from SCM_MST_SITE_ITEM a
								  ,dm_pln_sales_plan b
							 where sales_plan_adjust_yn = ''
							   and a.ITEM_ID = b.ITEM_ID
							   and a.DIVISION_ID = b.DIVISION_ID
							   and a.PROJECT_CODE = b.PROJECT_CODE
							   and a.SCM_SITE_ID = b.SCM_SITE_ID
							   and b.LAST_UPDATED_BY not in ( 'SYSTEM','CUTOFF')
							   and yyyymmdd >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7), 'YYYYMMDD')
							   and a.division_id    = dm_pln_sales_plan.division_id
							   and a.project_code   = dm_pln_sales_plan.project_code
							   and a.scm_site_id    = dm_pln_sales_plan.scm_site_id
							   and a.item_id        = dm_pln_sales_plan.item_id
				       )
DBMS_OUTPUT.PUT_LINE('B--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
                -- Sales Plan을 Unsync 하고 한번이라도 수정한 건에 대해서도 'MKT_FCST', 'RTF' 는 다시 계산.
				delete dm_pln_sales_plan
				 where yyyymmdd >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7), 'YYYYMMDD')
				   and division_id = v_division_id
				   -- MKT/금형비처럼 사람이 넣은것 삭제.
				   and item_id in (select item_id  from scm_mst_item_sn  group by item_id )
				   and MEASURE in ( 'MKT_FCST','CUST_FCST', 'RTF','RTF_SYS_RP','TMM_FCST' ); -- 20180417 modify skh  -- 20190709 KHSONG [CSR ID:4034895] 'RTF_SYS_RP' MEASURE 추가 -- 20200309 KHSONG TMM_FCST ADD
DBMS_OUTPUT.PUT_LINE('C--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
				-- 2021.08.25
				/* TODO:GTT:GT_DMF0_PRICE-->GT_DMF0_PRICE */
				INSERT INTO GT_DMF0_PRICE
				SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, YYYYMMDD, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, PRICE
				FROM SCM_MST_FUTURE_PRICE A
				WHERE DIVISION_ID = v_division_id
					AND YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7), 'YYYYMMDD')
					AND A.MEASURE IN ( 'KRW', 'LOC', 'USD' );
DBMS_OUTPUT.PUT_LINE('D--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
				/* TODO:GTT:GT_DMF0_MKT_FCST-->GT_DMF0_MKT_FCST */
				INSERT INTO GT_DMF0_MKT_FCST
				SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID, QTY, CREATED_BY, CREATION_DATE
				FROM DM_PLN_MKT_FCST A
				WHERE A.DIVISION_ID = v_division_id
					-- and w.yyyymmdd >= TO_CHAR(7 + (/* TODO:DATEDIFF(week,0,(SYSDATE) + (-1*7) */ ))*7SYSDATE + (-1*7) ), 7), 'YYYYMMDD')
					and A.YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7), 'YYYYMMDD')
					and A.MEASURE IN ('MKT_FCST','CUST_FCST','TMM_FCST', 'RTF','RTF_SYS_RP')
					and A.ITEM_ID in ( select item_id  from scm_mst_item_sn  group by item_id);
DBMS_OUTPUT.PUT_LINE('E--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
				--20191114 KHSONG SALES_PLAN 테이블 컬럼추가되어 에러발생으로 SELECT조건에 컬럼명을 추가
				EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DMF0_SALES_PLAN_TEMP_LOC';

--SELECT * FROM GT_DMF0_PRICE
DBMS_OUTPUT.PUT_LINE('F--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
				--PRINT 'EXEC_001                                       =>  ' + TO_CHAR(SYSDATE)

				-- 신규 정보 추가

				-- Temp 테이블에 저장
				--20191114 KHSONG SALES_PLAN 테이블 컬럼추가되어 에러발생으로 SELECT조건에 컬럼명을 추가
				INSERT INTO GT_DMF0_SALES_PLAN_TEMP_LOC
					(DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,MEASURE,PLANT_SITE_ID,YYYYMMDD,CURRENCY,QTY,CREATED_BY,CREATION_DATE)
				-- MKT FCST 값을 update 함.
				select   distinct
				         w.DIVISION_ID
						,w.PROJECT_CODE
						,w.SCM_SITE_ID
						,w.ITEM_ID
						,w.DOM_EXP
						,w.FCST_TYPE
						,w.INCOTERMS
						,w.MEASURE
						,w.PLANT_SITE_ID
						,w.YYYYMMDD
						,si.CURRENCY
						,w.QTY
						,w.CREATED_BY
						,w.CREATION_DATE
					from GT_DMF0_MKT_FCST w
					left outer join GT_DMF0_PRICE si
					on ( 1=1
						and w.DIVISION_ID   = si.DIVISION_ID
						and w.PROJECT_CODE  = si.PROJECT_CODE
						and w.SCM_SITE_ID   = si.SCM_SITE_ID
						and w.ITEM_ID       = si.ITEM_ID
						and w.DOM_EXP       = si.dom_exp
						and w.fcst_type     = si.fcst_type
						and w.INCOTERMS     = si.INCOTERMS
						and w.plant_site_id = si.plant_site_id
						-- and w.yyyymmdd      = si.yyyymmdd
						and ( select basis_start_date from SCM_SYS_CALENDAR_M  where basis_yyyymmdd = w.yyyymmdd )     = si.yyyymmdd
					)
					where w.measure in ('MKT_FCST','CUST_FCST','TMM_FCST', 'RTF','RTF_SYS_RP')  -- 20180417 modify skh  -- 20200309 KHSONG TMM_FCST ADD

				UNION ALL
				-- KRW 값을 계산
				select   w.DIVISION_ID
						,w.PROJECT_CODE
						,w.SCM_SITE_ID
						,w.ITEM_ID
						,w.DOM_EXP
						,w.FCST_TYPE
						,w.INCOTERMS
						, CASE WHEN FP.MEASURE = 'KRW' THEN 'SalesAmt_KRW'
								WHEN FP.MEASURE = 'LOC' THEN 'SalesAmt_LOC'
								WHEN FP.MEASURE = 'USD' THEN  'SalesAmt_USD'
								ELSE FP.MEASURE
								END AS MEASURE
						,w.PLANT_SITE_ID
						,w.YYYYMMDD
						,fp.CURRENCY
						, CASE WHEN FP.MEASURE = 'KRW' THEN cast( STR( w.QTY * NVL(FP.PRICE , 0) , 20, 5 ) as numeric(30, 10))
								WHEN FP.MEASURE = 'LOC' THEN cast( STR( w.QTY * NVL(FP.PRICE , 0) , 20, 5 ) as numeric(30, 10))
								WHEN FP.MEASURE = 'USD' THEN cast( STR( w.QTY * NVL(FP.PRICE , 0) , 20, 5 ) as numeric(30, 10))
								end as qty
						, NULL, NULL
					from GT_DMF0_MKT_FCST w
					join GT_DMF0_PRICE FP
					on (    FP.DIVISION_ID   = w.DIVISION_ID
						AND FP.PROJECT_CODE  = w.PROJECT_CODE
						AND FP.SCM_SITE_ID   = w.SCM_SITE_ID
						AND FP.ITEM_ID       = w.ITEM_ID
						AND FP.DOM_EXP       = w.DOM_EXP
						AND FP.FCST_TYPE     = w.FCST_TYPE
						AND FP.INCOTERMS     = w.INCOTERMS
						and FP.plant_site_id = w.plant_site_id
						AND FP.YYYYMMDD = ( select basis_start_date from SCM_SYS_CALENDAR_M where basis_yyyymmdd = w.yyyymmdd )
						--AND FP.MEASURE = 'KRW'
					   )
					where w.measure = 'RTF_SYS_RP' --[C20201208-000087] ESS 'RTF' -> 'RTF_SYS_RP' 적용
				   -- Sales Plan을 Unsync 하고 한번이라도 수정한 건에 대해서는 삭제 하지 않음.
				   and NOT EXISTS (
							select A.DIVISION_ID
							  from SCM_MST_SITE_ITEM a
								  ,dm_pln_sales_plan b
							 where sales_plan_adjust_yn = ''
							   and a.ITEM_ID = b.ITEM_ID
							   and a.DIVISION_ID = b.DIVISION_ID
							   and a.PROJECT_CODE = b.PROJECT_CODE
							   and a.SCM_SITE_ID = b.SCM_SITE_ID
							   and b.LAST_UPDATED_BY not in ( 'SYSTEM','CUTOFF')
							   and yyyymmdd >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7), 'YYYYMMDD')
							   and a.division_id    = w.division_id
							   and a.project_code   = w.project_code
							   and a.scm_site_id    = w.scm_site_id
							   and a.item_id        = w.item_id
				       )


				-- ---------------------------------------------------------------------------------------------------------------------
				-- 2020/08/06		hwi1993		[C20200803-000105] MKT FCST 금액 Measure 추가 개발 요청의 건
				-- ---------------------------------------------------------------------------------------------------------------------
				UNION ALL
				-- KRW 값을 계산
				select   w.DIVISION_ID
						,w.PROJECT_CODE
						,w.SCM_SITE_ID
						,w.ITEM_ID
						,w.DOM_EXP
						,w.FCST_TYPE
						,w.INCOTERMS
						, CASE WHEN FP.MEASURE = 'KRW' THEN 'MKT_AMT_KRW'
								WHEN FP.MEASURE = 'LOC' THEN 'MKT_AMT_LOC'
								END AS MEASURE
						,w.PLANT_SITE_ID
						,w.YYYYMMDD
						,fp.CURRENCY
						--,cast( STR( w.QTY * NVL(FP.PRICE , 1) , 20, 5 ) as numeric)
						, CASE WHEN FP.MEASURE = 'KRW' THEN cast( STR( w.QTY * NVL(FP.PRICE , 0) , 20, 5 ) as numeric(30, 10))
								WHEN FP.MEASURE = 'LOC' THEN cast( STR( w.QTY * NVL(FP.PRICE , 0) , 20, 5 ) as numeric(30, 10))
								END AS QTY
						, NULL, NULL
					from GT_DMF0_MKT_FCST w
					join GT_DMF0_PRICE FP
					on (    FP.DIVISION_ID   = w.DIVISION_ID
						AND FP.PROJECT_CODE  = w.PROJECT_CODE
						AND FP.SCM_SITE_ID   = w.SCM_SITE_ID
						AND FP.ITEM_ID       = w.ITEM_ID
						AND FP.DOM_EXP       = w.DOM_EXP
						AND FP.FCST_TYPE     = w.FCST_TYPE
						AND FP.INCOTERMS     = w.INCOTERMS
						and FP.plant_site_id = w.plant_site_id
						AND FP.YYYYMMDD = ( select basis_start_date from SCM_SYS_CALENDAR_M where basis_yyyymmdd = w.yyyymmdd )
						AND FP.MEASURE IN ( 'KRW' , 'LOC' )
					   )
					where w.measure = 'MKT_FCST';

DBMS_OUTPUT.PUT_LINE('G--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
				-- 확인용
				-- select * from GT_DMF0_SALES_PLAN_TEMP_LOC;
				-- 테이블의 중복제거
				   BEGIN
					   DELETE
					   FROM dm_pln_sales_plan
					   WHERE exists(
								SELECT B.DIVISION_ID
								  FROM GT_DMF0_SALES_PLAN_TEMP_LOC B
								 where 1=1
								   and dm_pln_sales_plan.DIVISION_ID    =  B.DIVISION_ID
								   and dm_pln_sales_plan.PROJECT_CODE   =  B.PROJECT_CODE
								   and dm_pln_sales_plan.SCM_SITE_ID    =  B.SCM_SITE_ID
								   and dm_pln_sales_plan.ITEM_ID        =  B.ITEM_ID
								   and dm_pln_sales_plan.DOM_EXP        =  B.DOM_EXP
								   and dm_pln_sales_plan.FCST_TYPE      =  B.FCST_TYPE
								   and dm_pln_sales_plan.INCOTERMS      =  B.INCOTERMS
								   and dm_pln_sales_plan.MEASURE        =  B.MEASURE
								   and dm_pln_sales_plan.PLANT_SITE_ID  =  B.PLANT_SITE_ID
								   and dm_pln_sales_plan.YYYYMMDD       =  B.YYYYMMDD
							  )
				   END;
DBMS_OUTPUT.PUT_LINE('H--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
				--20191114 KHSONG SALES_PLAN 테이블 컬럼추가되어 에러발생으로 SELECT조건에 컬럼명을 추가
				INSERT  INTO  dm_pln_sales_plan
				(DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,MEASURE,PLANT_SITE_ID,YYYYMMDD,CURRENCY,QTY,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE
				,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10)
				SELECT distinct
					   DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,MEASURE,PLANT_SITE_ID,YYYYMMDD,CURRENCY,QTY
					  ,NVL(CREATED_BY, v_created_by) , NVL(CREATION_DATE, SYSDATE)
					  ,v_created_by, SYSTIMESTAMP as LAST_UPDATE_DATE
					  , NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
				FROM GT_DMF0_SALES_PLAN_TEMP_LOC;
DBMS_OUTPUT.PUT_LINE('I--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
		    END IF;
          /*----------------------------- MULTI & SINGLE ROW END ---------------------------------------------------------------*/

		END
        /*---------------------------------------------------------------*/

     -- IF @V_TRANCOUNT > 0

  	-- 트랜잭션 (COMMIT)
        COMMIT WORK;

	-- -----------------------------------------------------------------------------------------
		-- END TRY
	-- -----------------------------------------------------------------------------------------
	-- -----------------------------------------------------------
    EXCEPTION
        WHEN OTHERS THEN
	-- -----------------------------------------------------------
	-- 트랜잭션 (END)

      -- ERROR LOG VALUE SAVE
      v_log_type := 'ERROR';
      v_log_message := CAST(SQLERRM AS VARCHAR2(1000 CHAR));
      v_description := 'ERROR_LINE : '  ||  STR(NULL);
      d_event_date := SYSTIMESTAMP;

	  SELECT '['  ||  TO_CHAR(SQLCODE)  ||  ']'  ||  SQLERRM;  /*-- 에러메시지 DISPLAY --*/
	  PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
	  FROM DUAL;


	-- -----------------------------------------------------------
    END CATCH;
	-- -----------------------------------------------------------
	-- 수행결과 성공여부 DISPLAY
   --  IF v_log_message IS NULL
	  --SELECT 'success'

    -- 종료 LOG
    IF v_log_message IS NULL
		BEGIN
			v_log_type := 'END';
			v_log_message := '########## END of procedure ##########';
			v_description := 'p_division_id : '  ||  p_division_id  ||  ' / '  || 'v_created_by : '  ||   NVL(v_created_by, 'NULL');
			d_event_date := SYSTIMESTAMP;
			PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
		END

        RAISE_APPLICATION_ERROR(-20001, '오류가 발생했습니다.');
  END;
/

-- DMF0003_SAVE_MKT_FCST_PK_DATA_UPDATE → PKG_DMF0003.P_DMF0003_SAVE_MKT_FCST_PK_DATA_UPDATE에 등록됨
CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0003_SAVE_MKT_FCST_PK_DATA_UPDATE
(

	-- Add the parameters for the stored procedure here
	 p_division_id			VARCHAR2
	,p_project_code		VARCHAR2
	,p_scm_site_id			VARCHAR2
	,p_item_id				VARCHAR2
	,p_dom_exp				VARCHAR2
	,p_fcst_type			VARCHAR2
	,p_incoterms			VARCHAR2
	,p_plant_site_id  	    VARCHAR2

	,p_dom_exp_new		    VARCHAR2
	,p_fcst_type_new		VARCHAR2
	,p_incoterms_new		VARCHAR2
	,p_plant_site_id_new	VARCHAR2
	,p_created_by      	VARCHAR2

/*
 * Program ID   : DMF0003_SAVE_MKT_FCST_PK_DATA_UPDATE
 * Description  : MKT FCST 화면에서 팝업화면을 띄워서 INCOTERMS등 PK값을 수정할수 있도록 함.
 * Program History
 *====================================================================================================
 *   Date       In Charge      Description
 *====================================================================================================
 * 2018.05.16   KHSONG         Initial Release PJ20170278 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * ---------------------------------------------------------------------------------------------------
 * 20180601 pk값 validation KHSONG
 * 20180807
 * 2020/09/09     P.C.I		[C20200909-000203] LOG 표준화 적용
 * 2021/05/04     P.C.I		[C20210504-000051] Sales Plan, Sales Price 적용 기준 변경
 * 2021.07.02	HWI1993		[C20210629-000239] [SCM PI팀] MKT FCST Amt. 추가의 건
 * 2021.08.06		hwi1993		중장기과제 -- 특정 기간동안은 2022년 데이터 수정할 수 없도록
 * 2022.11.04		rosia27		[C20221024-000510]DM UI 소스 정리 요청
 * 2022.12.07		hwi1993		[C20221205-000135] GSCM Master change 인코텀즈 변경 기능 개선
 * ---------------------------------------------------------------------------------------------------
 */
)
AS

/*
 * ========================================
 * [변환검증] 2026-03-02 20:37:05
 * 파일: dbo.DMF0003_SAVE_MKT_FCST_PK_DATA_UPDATE.sql
 * ----------------------------------------
 * ⚠ IF: IF:16  END IF:1  차이:+15
 * ⚠ BEGIN: BEGIN:17  END:19  차이:-2
 * ----------------------------------------
 * BEGIN 위치: L82, L154, L185, L257, L307, L313, L346, L369, L380, L391 ...
 * END;  위치: L255, L301, L303, L317, L318, L350, L372, L386, L584, L621 ...
 * ----------------------------------------
 * 힌트: END가 1개 더 많음 → 고아 END; 확인 필요
 * 수정 완료 후 이 주석 블록을 삭제하세요.
 * ========================================
 */



    v_division_id VARCHAR2(4000 CHAR);
    v_project_code VARCHAR2(4000 CHAR);
    v_scm_site_id VARCHAR2(4000 CHAR);
    v_item_id VARCHAR2(4000 CHAR);
    v_dom_exp VARCHAR2(4000 CHAR);
    v_fcst_type VARCHAR2(4000 CHAR);
    v_incoterms VARCHAR2(4000 CHAR);
    v_plant_site_id VARCHAR2(4000 CHAR);
    v_dom_exp_new VARCHAR2(4000 CHAR);
    v_fcst_type_new VARCHAR2(4000 CHAR);
    v_incoterms_new VARCHAR2(4000 CHAR);
    v_plant_site_id_new VARCHAR2(4000 CHAR);
    v_created_by VARCHAR2(4000 CHAR);
    v_program_name VARCHAR2(150 CHAR) := 'DMF0003_SAVE_MKT_FCST_PK_DATA_UPDATE';
    v_log_type VARCHAR2(30 CHAR);
    n_log_count INTEGER := 0;
    v_log_message VARCHAR2(1000 CHAR);
    v_description VARCHAR2(500 CHAR);
    d_event_date DATE;
    v_index_division_id INTEGER;
    v_index_project_code INTEGER;
    v_index_scm_site_id INTEGER;
    v_index_item_id INTEGER;
    v_index_dom_exp INTEGER;
    v_index_fcst_type INTEGER;
    v_index_incoterms INTEGER;
    v_index_plant_site_id INTEGER;
    v_index_dom_exp_new INTEGER;
    v_index_fcst_type_new INTEGER;
    v_index_incoterms_new INTEGER;
    v_index_plant_site_id_new INTEGER;
    v_index_created_by INTEGER;
    m_DIVISION_ID VARCHAR2(4000 CHAR);
    m_SCM_SITE_ID VARCHAR2(4000 CHAR);
    m_PROJECT_CODE VARCHAR2(4000 CHAR);
    s_FUTURE_valid VARCHAR2(4000 CHAR);
    s_unit_price_valid VARCHAR2(1000 CHAR);
    v_cnt_1  INTEGER := 0;
    v_cnt_2  INTEGER := 0;
BEGIN













	v_division_id := NULL;
	v_project_code := NULL;
	v_scm_site_id := NULL;
	v_item_id := NULL;
	v_dom_exp := NULL;
	v_fcst_type := NULL;
	v_incoterms := NULL;
	v_plant_site_id := NULL;
	v_dom_exp_new := NULL;
	v_fcst_type_new := NULL;
	v_incoterms_new := NULL;
	v_plant_site_id_new := NULL;
	v_created_by := NULL;

	-- LOG 용 변수 설정






	p_division_id := RTRIM(p_division_id		)  ||  '^';
	p_project_code := RTRIM(p_project_code		)  ||  '^';
	p_scm_site_id := RTRIM(p_scm_site_id		)  ||  '^';
	p_item_id := RTRIM(p_item_id			)  ||  '^';
	p_dom_exp := RTRIM(p_dom_exp			)  ||  '^';
	p_fcst_type := RTRIM(p_fcst_type		)  ||  '^';
	p_incoterms := RTRIM(p_incoterms		)  ||  '^';
	p_plant_site_id := RTRIM(p_plant_site_id	)  ||  '^';
	p_dom_exp_new := RTRIM(p_dom_exp_new      )  ||  '^';
	p_fcst_type_new := RTRIM(p_fcst_type_new    )  ||  '^';
	p_incoterms_new := RTRIM(p_incoterms_new    )  ||  '^';
	p_plant_site_id_new := RTRIM(p_plant_site_id_new)  ||  '^';
	p_created_by := RTRIM(p_created_by       )  ||  '^';

	-- GT_DMF0_results TEMP TABLE
	EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DMF0_results';

	-- GT_DMF0_valid_results TEMP TABLE
	EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DMF0_valid_results';

		-- 시작 LOG  (START)
		v_log_type := 'START';
		v_log_message := '########## Start of procedure ##########';
		v_description := NULL;
		d_event_date := SYSTIMESTAMP;
		PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
		v_log_message := NULL      /*; -- <- 변수 재사용을 위하여 초기화해야함 --*/
		-- 시작 LOG  (END)

		-- 트랜잭션 (START)

	-- -----------------------------------------------------------------------------------------
		BEGIN TRY
	-- -----------------------------------------------------------------------------------------
--===================================================================================== GT_DMF0_results 테이블에 split후 INSERT INTO start
	--###############################################  GT_DMF0_results 테이블에 split후 insert (START)
	WHILE LENGTH(p_DIVISION_ID) > 0
	BEGIN














	 v_index_division_id := PATINDEX('%'  ||  '^'  ||  '%', p_division_id			);
	 v_index_project_code := PATINDEX('%'  ||  '^'  ||  '%', p_project_code			);
	 v_index_scm_site_id := PATINDEX('%'  ||  '^'  ||  '%', p_scm_site_id			);
	 v_index_item_id := PATINDEX('%'  ||  '^'  ||  '%', p_item_id				);
	 v_index_dom_exp := PATINDEX('%'  ||  '^'  ||  '%', p_dom_exp				);
	 v_index_fcst_type := PATINDEX('%'  ||  '^'  ||  '%', p_fcst_type			);
	 v_index_incoterms := PATINDEX('%'  ||  '^'  ||  '%', p_incoterms			);
	 v_index_plant_site_id := PATINDEX('%'  ||  '^'  ||  '%', p_plant_site_id		);
	 v_index_dom_exp_new := PATINDEX('%'  ||  '^'  ||  '%', p_dom_exp_new			);
	 v_index_fcst_type_new := PATINDEX('%'  ||  '^'  ||  '%', p_fcst_type_new		);
	 v_index_incoterms_new := PATINDEX('%'  ||  '^'  ||  '%', p_incoterms_new		);
	 v_index_plant_site_id_new := PATINDEX('%'  ||  '^'  ||  '%', p_plant_site_id_new	);
	 v_index_created_by := PATINDEX('%'  ||  '^'  ||  '%', p_created_by			);

	 -- 확인  select v_index_DIVISION_ID as 'v_index_DIVISION_ID';
		IF v_index_DIVISION_ID > 0
			  BEGIN
			   v_division_id := SUBSTR(p_division_id			, 0, v_index_division_id			);
			   v_project_code := SUBSTR(p_project_code			, 0, v_index_project_code		);
			   v_scm_site_id := SUBSTR(p_scm_site_id			, 0, v_index_scm_site_id			);
			   v_item_id := SUBSTR(p_item_id				, 0, v_index_item_id				);
			   v_dom_exp := SUBSTR(p_dom_exp				, 0, v_index_dom_exp				);
			   v_fcst_type := SUBSTR(p_fcst_type			, 0, v_index_fcst_type			);
			   v_incoterms := SUBSTR(p_incoterms			, 0, v_index_incoterms			);
			   v_plant_site_id := SUBSTR(p_plant_site_id		, 0, v_index_plant_site_id		);
			   v_dom_exp_new := SUBSTR(p_dom_exp_new			, 0, v_index_dom_exp_new         );
			   v_fcst_type_new := SUBSTR(p_fcst_type_new		, 0, v_index_fcst_type_new       );
			   v_incoterms_new := SUBSTR(p_incoterms_new		, 0, v_index_incoterms_new       );
			   v_plant_site_id_new := SUBSTR(p_plant_site_id_new	, 0, v_index_plant_site_id_new   );
			   v_created_by := SUBSTR(p_created_by			, 0, v_index_created_by		    );

			   p_division_id := SUBSTR(p_division_id		, LENGTH(v_division_id		 ||  '^') || 1, LENGTH(p_division_id		));
			   p_project_code := SUBSTR(p_project_code		, LENGTH(v_project_code		 ||  '^') || 1, LENGTH(p_project_code		));
			   p_scm_site_id := SUBSTR(p_scm_site_id		, LENGTH(v_scm_site_id		 ||  '^') || 1, LENGTH(p_scm_site_id		));
			   p_item_id := SUBSTR(p_item_id			, LENGTH(v_item_id			 ||  '^') || 1, LENGTH(p_item_id			));
			   p_dom_exp := SUBSTR(p_dom_exp			, LENGTH(v_dom_exp			 ||  '^') || 1, LENGTH(p_dom_exp			));
			   p_fcst_type := SUBSTR(p_fcst_type		, LENGTH(v_fcst_type			 ||  '^') || 1, LENGTH(p_fcst_type		));
			   p_incoterms := SUBSTR(p_incoterms		, LENGTH(v_incoterms			 ||  '^') || 1, LENGTH(p_incoterms		));
			   p_plant_site_id := SUBSTR(p_plant_site_id	, LENGTH(v_plant_site_id		 ||  '^') || 1, LENGTH(p_plant_site_id	));
			   p_dom_exp_new := SUBSTR(p_dom_exp_new      , LENGTH(v_dom_exp_new		 ||  '^') || 1, LENGTH(p_dom_exp_new      ));
			   p_fcst_type_new := SUBSTR(p_fcst_type_new    , LENGTH(v_fcst_type_new		 ||  '^') || 1, LENGTH(p_fcst_type_new    ));
			   p_incoterms_new := SUBSTR(p_incoterms_new    , LENGTH(v_incoterms_new		 ||  '^') || 1, LENGTH(p_incoterms_new    ));
			   p_plant_site_id_new := SUBSTR(p_plant_site_id_new, LENGTH(v_plant_site_id_new	 ||  '^') || 1, LENGTH(p_plant_site_id_new));
			   p_created_by := SUBSTR(p_created_by		, LENGTH(v_created_by			 ||  '^') || 1, LENGTH(p_created_by		));

			   -- UPDATE 할 값이 컬럼에 없는경우 기존값으로 대체함 (START)
			   IF  v_dom_exp_new			IS NULL OR v_dom_exp_new = ''
			      v_dom_exp_new := v_dom_exp;
			   IF  v_fcst_type_new			IS NULL OR v_fcst_type_new = ''
			      v_fcst_type_new := v_fcst_type;
			   IF  v_incoterms_new			IS NULL OR v_incoterms_new = ''
			      v_incoterms_new := v_incoterms;
			   IF  v_plant_site_id_new		IS NULL OR v_plant_site_id_new = ''
			      v_plant_site_id_new := v_plant_site_id;
			   -- UPDATE 할 값이 컬럼에 없는경우 기존값으로 대체함 (END)


			   INSERT INTO GT_DMF0_results (;
					  v_division_id
					 ,v_project_code
					 ,v_scm_site_id
					 ,v_item_id
					 ,v_dom_exp
					 ,v_fcst_type
					 ,v_incoterms
					 ,v_plant_site_id
					 ,v_dom_exp_new
					 ,v_fcst_type_new
					 ,v_incoterms_new
					 ,v_plant_site_id_new
					 ,v_created_by
			   ) VALUES (
					  v_division_id
					 ,v_project_code
					 ,v_scm_site_id
					 ,v_item_id
					 ,v_dom_exp
					 ,v_fcst_type
					 ,v_incoterms
					 ,v_plant_site_id
					 ,v_dom_exp_new
					 ,v_fcst_type_new
					 ,v_incoterms_new
					 ,v_plant_site_id_new
					 ,v_created_by
			   )
			  END
		ELSE
			  BEGIN
			   v_DIVISION_ID := p_DIVISION_ID;
			   p_DIVISION_ID := NULL;

			   -- UPDATE 할 값이 컬럼에 없는경우 기존값으로 대체함 (START)
			   IF  v_dom_exp_new			IS NULL OR v_dom_exp_new = ''
			      v_dom_exp_new := v_dom_exp;
			   IF  v_fcst_type_new			IS NULL OR v_fcst_type_new = ''
			      v_fcst_type_new := v_fcst_type;
			   IF  v_incoterms_new			IS NULL OR v_incoterms_new = ''
			      v_incoterms_new := v_incoterms;
			   IF  v_plant_site_id_new		IS NULL OR v_plant_site_id_new = ''
			      v_plant_site_id_new := v_plant_site_id;
			   -- UPDATE 할 값이 컬럼에 없는경우 기존값으로 대체함 (END)

			   INSERT INTO GT_DMF0_results (;
					  v_division_id
					 ,v_project_code
					 ,v_scm_site_id
					 ,v_item_id
					 ,v_dom_exp
					 ,v_fcst_type
					 ,v_incoterms
					 ,v_plant_site_id
					 ,v_dom_exp_new
					 ,v_fcst_type_new
					 ,v_incoterms_new
					 ,v_plant_site_id_new
					 ,v_created_by
			   ) VALUES (
					  v_division_id
					 ,v_project_code
					 ,v_scm_site_id
					 ,v_item_id
					 ,v_dom_exp
					 ,v_fcst_type
					 ,v_incoterms
					 ,v_plant_site_id
					 ,v_dom_exp_new
					 ,v_fcst_type_new
					 ,v_incoterms_new
					 ,v_plant_site_id_new
					 ,v_created_by
			   )
	  END

	END
		--###############################################   GT_DMF0_results 테이블에 split후 insert (END)

	----------------------------------------------------------------------------------------------- 신규 parameter 값으로 pk validation (start)
	BEGIN
		IF (select count(1) from DM_PLN_MKT_FCST
			        where 1=1
			            and division_id   = v_division_id
			            and project_code  = v_project_code
		) = 0
		begin
			v_log_type := 'INVALID';
			SELECT '[' ||  v_PROJECT_CODE  || ']' ||  ' Invalid Project Code !'
			goto err_rtn
		end
	END

	-- 22년 데이터가 있고, 소형이고 , 마감이 되었다면 수정내역 취소
	SELECT COUNT(1)
	INTO v_cnt_1
	FROM GT_DMF0_results WHERE V_DIVISION_ID = '40';
	IF v_cnt_1 > 0 THEN
		AND EXISTS (
				SELECT *
				FROM SCM_ADM_LOOKUP_MASTER_DETAIL
				WHERE LOOKUP_TYPE = 'DM_LONG_PLAN'
				AND SEGMENT1 = '40'
				AND ATTRIBUTE1 = 'Y'	-- 마감여부
				AND VALID_YN = 'Y')
		AND EXISTS (
				SELECT *
				FROM GT_DMF0_results A
				JOIN DM_PLN_MKT_FCST B ON	A.V_DIVISION_ID		= B.DIVISION_ID
										AND A.V_PROJECT_CODE 	= B.PROJECT_CODE
										AND A.V_SCM_SITE_ID 	= B.SCM_SITE_ID
										AND A.V_ITEM_ID 		= B.ITEM_ID
										AND A.V_DOM_EXP 		= B.DOM_EXP
										AND A.V_FCST_TYPE 		= B.FCST_TYPE
										AND A.V_INCOTERMS 		= B.INCOTERMS
										AND A.V_PLANT_SITE_ID	= B.PLANT_SITE_ID
				WHERE B.YYYYMMDD >= '20220101'
					AND B.MEASURE IN ( 'MKT_FCST', 'RTF', 'RTF_SYS_RP', 'VMI_IN_REQ' )
				)
		begin
			v_log_type := 'INVALID';
			SELECT '2022년 데이터가 있는 마스터는 변경할 수 없습니다.'
			goto err_rtn
		end




	----------------------------------------------------------------------------------------------- 신규 parameter 값으로 pk validation (end)

		-- 속도개선 cursor 구조로 변경
		-- 신규변수



		DELETE GT_DMF0_valid_results;


		SELECT COUNT(1)
		INTO v_cnt_2
		FROM SYS.SYSCURSORS WHERE CURSOR_NAME = 'CURSOR1_MST';
		IF v_cnt_2 > 0
			BEGIN
				CLOSE CURSOR1_MST
				DEALLOCATE CURSOR1_MST
			END;
		-- TODO: CURSOR-->BULK COLLECT 변환 필요
    -- CURSOR1_MST CURSOR FAST_FORWARD FOR
		SELECT
			      V_DIVISION_ID,V_SCM_SITE_ID,V_PROJECT_CODE
			FROM GT_DMF0_results WHERE 1=1
		GROUP BY V_DIVISION_ID,  V_SCM_SITE_ID,V_PROJECT_CODE;

		BEGIN
			OPEN CURSOR1_MST;
			FETCH CURSOR1_MST INTO; -- PROJECT_CODE별 LOOP수행
									  m_DIVISION_ID
									 ,m_SCM_SITE_ID
									 ,m_PROJECT_CODE
		END

		---------------------------------------------------------------------------------------- WHILE_1 LOOP START
		WHILE v_fetch_status = 0
		-- -------------------------------------------------------------------------------------
        BEGIN


		----------------------------------------------------------------------------------------------- 20180601 pk값 validation (start)
		--BEGIN
			--			-- 신규 update 할 값이 값이 0 인 것이 있으면 삭제 처리 함. (start)
			delete from DM_PLN_MKT_FCST
			where EXISTS(
					select v_division_id
						from GT_DMF0_results x
						where x.v_division_id     = DM_PLN_MKT_FCST.DIVISION_ID
						and x.v_project_code      = DM_PLN_MKT_FCST.PROJECT_CODE
						and x.v_scm_site_id       = DM_PLN_MKT_FCST.SCM_SITE_ID
						and x.v_item_id           = DM_PLN_MKT_FCST.ITEM_ID
						and x.v_dom_exp_new       = DM_PLN_MKT_FCST.DOM_EXP
						and x.v_fcst_type_new     = DM_PLN_MKT_FCST.FCST_TYPE
						and x.v_incoterms_new     = DM_PLN_MKT_FCST.incoterms
						and x.v_plant_site_id_new = DM_PLN_MKT_FCST.PLANT_SITE_ID
					)
				and qty = 0
				and yyyymmdd >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7), 'YYYYMMDD')   -- 당주월요일 이후 데이터를 대상으로 함
				AND DIVISION_ID   =  m_DIVISION_ID
				AND SCM_SITE_ID   =  m_SCM_SITE_ID
				AND PROJECT_CODE  =  m_PROJECT_CODE;
			-- 신규 update 할 값이 값이 0 인 것이 있으면 삭제 처리 함. (end)
			--		--END

			-- 20181108 (start)
			delete from SCM_MST_FUTURE_PRICE
			where EXISTS(
					select v_division_id
						from GT_DMF0_results x
						where x.v_division_id     = SCM_MST_FUTURE_PRICE.DIVISION_ID
						and x.v_project_code      = SCM_MST_FUTURE_PRICE.PROJECT_CODE
						and x.v_scm_site_id       = SCM_MST_FUTURE_PRICE.SCM_SITE_ID
						and x.v_item_id           = SCM_MST_FUTURE_PRICE.ITEM_ID
						and x.v_dom_exp_new       = SCM_MST_FUTURE_PRICE.DOM_EXP
						and x.v_fcst_type_new     = SCM_MST_FUTURE_PRICE.FCST_TYPE
						and x.v_incoterms_new     = SCM_MST_FUTURE_PRICE.incoterms
						and x.v_plant_site_id_new = SCM_MST_FUTURE_PRICE.PLANT_SITE_ID
						--[C20210504-000051] 변경 전 fcst type이 유상인 경우에만 변경 후 Sales Price 삭제
						AND x.v_fcst_type not in (	SELECT SEGMENT2
													FROM SCM_ADM_LOOKUP_MASTER_DETAIL MST
													WHERE 1=1
													AND MST.LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE'
													AND MST.SEGMENT1    = 'FCST_TYPE'
													AND VALID_YN        = 'Y'  )
					)
				--and PRICE = 0 --[C20210504-000051] Sales Price 적용 기준 변경
				and yyyymmdd >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7), 'YYYYMMDD')   -- 당주월요일 이후 데이터를 대상으로 함
				AND DIVISION_ID   =  m_DIVISION_ID
				AND SCM_SITE_ID   =  m_SCM_SITE_ID
				AND PROJECT_CODE  =  m_PROJECT_CODE;
			-- 20181108 (END)


			--[C20210504-000051] 변경 후 fcst type이 무상인 경우에 Sales Plan의 SalesAMT 삭제
			delete from DM_PLN_SALES_PLAN
			where EXISTS(
					select v_division_id
						from GT_DMF0_results x
						where x.v_division_id     = DM_PLN_SALES_PLAN.DIVISION_ID
						and x.v_project_code      = DM_PLN_SALES_PLAN.PROJECT_CODE
						and x.v_scm_site_id       = DM_PLN_SALES_PLAN.SCM_SITE_ID
						and x.v_item_id           = DM_PLN_SALES_PLAN.ITEM_ID
						and x.v_dom_exp           = DM_PLN_SALES_PLAN.DOM_EXP
						and x.v_fcst_type		  = DM_PLN_SALES_PLAN.FCST_TYPE
						and x.v_incoterms		  = DM_PLN_SALES_PLAN.incoterms
						and x.v_plant_site_id	  = DM_PLN_SALES_PLAN.PLANT_SITE_ID
						--[C20210504-000051] 변경 후 fcst type이 무상인 경우에 Sales Plan의 SalesAMT 삭제
						AND x.v_fcst_type_new in (	SELECT SEGMENT2
													FROM SCM_ADM_LOOKUP_MASTER_DETAIL MST
													WHERE 1=1
													AND MST.LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE'
													AND MST.SEGMENT1    = 'FCST_TYPE'
													AND VALID_YN        = 'Y'  )
					)
				and yyyymmdd >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7), 'YYYYMMDD')   -- 당주월요일 이후 데이터를 대상으로 함
				AND DIVISION_ID   =  m_DIVISION_ID
				AND SCM_SITE_ID   =  m_SCM_SITE_ID
				AND PROJECT_CODE  =  m_PROJECT_CODE
				AND MEASURE in ('SalesAmt_KRW','SalesAmt_LOC','SalesAmt_USD','MKT_AMT_KRW','MKT_AMT_LOC');



			-- 입력된 MASTER 정보로 MEASURE 추출 (start)
			INSERT INTO GT_DMF0_valid_results
				SELECT   a.DIVISION_ID
						,a.PROJECT_CODE
						,a.SCM_SITE_ID
						,a.ITEM_ID
						,a.DOM_EXP
						,a.FCST_TYPE
						,a.INCOTERMS
						,a.PLANT_SITE_ID
						,a.MEASURE
				FROM   DM_PLN_MKT_FCST a
					  ,GT_DMF0_results rslt
				where   a.division_id		= rslt.v_division_id
					and a.project_code		= rslt.v_project_code
					and a.scm_site_id		= rslt.v_scm_site_id
					and a.item_id			= rslt.v_item_id
					and a.dom_exp			= rslt.v_dom_exp_new
					and a.fcst_type			= rslt.v_fcst_type_new
					and a.incoterms			= rslt.v_incoterms_new
					and a.plant_site_id		= rslt.v_plant_site_id_new
					and a.yyyymmdd >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7), 'YYYYMMDD')   -- 당주월요일 이후 데이터를 대상으로 함
					AND a.DIVISION_ID        =  m_DIVISION_ID
					AND a.SCM_SITE_ID        =  m_SCM_SITE_ID
					AND a.PROJECT_CODE       =  m_PROJECT_CODE
					AND rslt.v_DIVISION_ID   =  m_DIVISION_ID
					AND rslt.v_SCM_SITE_ID   =  m_SCM_SITE_ID
					AND rslt.v_PROJECT_CODE  =  m_PROJECT_CODE
					group by a.DIVISION_ID
						,a.PROJECT_CODE
						,a.SCM_SITE_ID
						,a.ITEM_ID
						,a.DOM_EXP
						,a.FCST_TYPE
						,a.INCOTERMS
						,a.PLANT_SITE_ID
						,a.MEASURE

				UNION

				SELECT   a.DIVISION_ID
						,a.PROJECT_CODE
						,a.SCM_SITE_ID
						,a.ITEM_ID
						,a.DOM_EXP
						,a.FCST_TYPE
						,a.INCOTERMS
						,a.PLANT_SITE_ID
						,a.MEASURE
				FROM   DM_PLN_MKT_FCST a
					  ,GT_DMF0_results rslt
				where   a.division_id		= rslt.v_division_id
					and a.project_code		= rslt.v_project_code
					and a.scm_site_id		= rslt.v_scm_site_id
					and a.item_id			= rslt.v_item_id
					and a.dom_exp			= rslt.v_dom_exp
					and a.fcst_type			= rslt.v_fcst_type
					and a.incoterms			= rslt.v_incoterms
					and a.plant_site_id		= rslt.v_plant_site_id
					and a.yyyymmdd >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7), 'YYYYMMDD')   -- 당주월요일 이후 데이터를 대상으로 함
					AND a.DIVISION_ID        =  m_DIVISION_ID
					AND a.SCM_SITE_ID        =  m_SCM_SITE_ID
					AND a.PROJECT_CODE       =  m_PROJECT_CODE
					AND rslt.v_DIVISION_ID   =  m_DIVISION_ID
					AND rslt.v_SCM_SITE_ID   =  m_SCM_SITE_ID
					AND rslt.v_PROJECT_CODE  =  m_PROJECT_CODE
					group by a.DIVISION_ID
						,a.PROJECT_CODE
						,a.SCM_SITE_ID
						,a.ITEM_ID
						,a.DOM_EXP
						,a.FCST_TYPE
						,a.INCOTERMS
						,a.PLANT_SITE_ID
						,a.MEASURE

			-- 입력된 MASTER 정보로 MEASURE 추출 (end)

			-- DM_PLN_MKT_FCST 테이블에서 당주월요일 이후 데이터가 존재하는지 체크 (start)
			IF
				(SELECT COUNT(1) from DM_PLN_MKT_FCST
				where (
						select count(1)
							from GT_DMF0_valid_results rslt
							where rslt.v_division_id    = DM_PLN_MKT_FCST.DIVISION_ID
							and rslt.v_project_code     = DM_PLN_MKT_FCST.PROJECT_CODE
							and rslt.v_scm_site_id      = DM_PLN_MKT_FCST.SCM_SITE_ID
							and rslt.v_item_id          = DM_PLN_MKT_FCST.ITEM_ID
							and rslt.v_dom_exp			= DM_PLN_MKT_FCST.DOM_EXP
							and rslt.v_fcst_type		= DM_PLN_MKT_FCST.FCST_TYPE
							and rslt.v_incoterms		= DM_PLN_MKT_FCST.incoterms
							and rslt.v_plant_site_id	= DM_PLN_MKT_FCST.PLANT_SITE_ID
							and rslt.v_measure			= DM_PLN_MKT_FCST.MEASURE
							and DM_PLN_MKT_FCST.yyyymmdd >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7), 'YYYYMMDD')   -- 당주월요일 이후 데이터를 대상으로 함
							AND rslt.v_DIVISION_ID   =  m_DIVISION_ID
							AND rslt.v_SCM_SITE_ID   =  m_SCM_SITE_ID
							AND rslt.v_PROJECT_CODE  =  m_PROJECT_CODE
							group by v_division_id,v_project_code,v_scm_site_id,v_item_id,v_dom_exp,v_fcst_type,v_incoterms,v_plant_site_id HAVING COUNT(*) > 1) > 1
					AND DIVISION_ID        =  m_DIVISION_ID
					AND SCM_SITE_ID        =  m_SCM_SITE_ID
					AND PROJECT_CODE       =  m_PROJECT_CODE

					 )
					> 0
					BEGIN
						v_log_type := 'INVALID';
						SELECT '이미 존재하는 Project,site,model 정보입니다.'
						goto err_rtn
					END

			----------------------------------------------------------------------------------------------- 20180601 pk값 validation (end)

				-- DM_PLN_MKT_FCST UPDATE
				BEGIN
				--						MERGE INTO DM_PLN_MKT_FCST A
						USING (
								SELECT v_division_id,v_project_code,v_scm_site_id,v_item_id,v_dom_exp,v_fcst_type,v_incoterms,v_plant_site_id
									  ,v_dom_exp_new,v_fcst_type_new,v_incoterms_new,v_plant_site_id_new,v_created_by
									  from GT_DMF0_results
										  where 1=1
											AND v_DIVISION_ID        =  m_DIVISION_ID
											AND v_SCM_SITE_ID        =  m_SCM_SITE_ID
											AND v_PROJECT_CODE       =  m_PROJECT_CODE
								  ) B;
						ON(
									A.division_id     = B.v_division_id
								AND A.project_code    = B.v_project_code
								AND A.scm_site_id     = B.v_scm_site_id
								AND A.item_id         = B.v_item_id
								AND A.dom_exp         = B.v_dom_exp
								AND A.fcst_type       = B.v_fcst_type
								AND A.incoterms       = B.v_incoterms
								AND A.plant_site_id   = B.v_plant_site_id
 								and A.yyyymmdd       >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7), 'YYYYMMDD')   -- 당주월요일 이후 데이터를 대상으로 함
								AND A.DIVISION_ID        =  m_DIVISION_ID
								AND A.SCM_SITE_ID        =  m_SCM_SITE_ID
								AND A.PROJECT_CODE       =  m_PROJECT_CODE
						  )
						WHEN MATCHED THEN
							 UPDATE  SET  dom_exp			= v_dom_exp_new
										 ,fcst_type			= v_fcst_type_new
										 ,incoterms			= v_incoterms_new
										 ,plant_site_id		= v_plant_site_id_new
										,last_updated_by	= v_created_by
										,last_update_date	= SYSDATE
				END

				-- DM_PLN_SALES_PLAN UPDATE
				BEGIN
						MERGE INTO DM_PLN_SALES_PLAN A;
						USING (
								SELECT v_division_id,v_project_code,v_scm_site_id,v_item_id,v_dom_exp,v_fcst_type,v_incoterms,v_plant_site_id
									  ,v_dom_exp_new,v_fcst_type_new,v_incoterms_new,v_plant_site_id_new,v_created_by
									  from GT_DMF0_results
										  where 1=1
											AND v_DIVISION_ID        =  m_DIVISION_ID
											AND v_SCM_SITE_ID        =  m_SCM_SITE_ID
											AND v_PROJECT_CODE       =  m_PROJECT_CODE
							  ) B;
						ON(
									A.division_id     = B.v_division_id
								AND A.project_code    = B.v_project_code
								AND A.scm_site_id     = B.v_scm_site_id
								AND A.item_id         = B.v_item_id
								AND A.dom_exp         = B.v_dom_exp
								AND A.fcst_type       = B.v_fcst_type
								AND A.incoterms       = B.v_incoterms
								AND A.plant_site_id   = B.v_plant_site_id
 								and A.yyyymmdd       >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7), 'YYYYMMDD')   -- 당주월요일 이후 데이터를 대상으로 함
								AND A.DIVISION_ID        =  m_DIVISION_ID
								AND A.SCM_SITE_ID        =  m_SCM_SITE_ID
								AND A.PROJECT_CODE       =  m_PROJECT_CODE
						  )
						WHEN MATCHED THEN
							 UPDATE  SET  dom_exp			= v_dom_exp_new
										 ,fcst_type			= v_fcst_type_new
										 ,incoterms			= v_incoterms_new
										 ,plant_site_id		= v_plant_site_id_new
										,last_updated_by	= v_created_by
										,last_update_date	= SYSDATE

						--[C20210504-000051] 변경 전 fcst type이 무상인 경우에 SalesAMT 생성
						INSERT INTO DM_PLN_SALES_PLAN
						-- KRW 값을 계산
						select   w.DIVISION_ID
								,w.PROJECT_CODE
								,w.SCM_SITE_ID
								,w.ITEM_ID
								,w.DOM_EXP
								,w.FCST_TYPE
								,w.INCOTERMS
								,'SalesAmt_KRW' MEASURE
								,w.PLANT_SITE_ID
								,w.YYYYMMDD
								,fp.CURRENCY
								,cast( STR( w.QTY * NVL(FP.PRICE , 0) , 20, 5 ) as numeric(30, 10))
								,v_created_by
								,SYSDATE
								,'SYSTEM'
								,SYSDATE
								,NULL -- ATTRIBUTE1
								,NULL -- ATTRIBUTE2
								,NULL -- ATTRIBUTE3
								,NULL -- ATTRIBUTE4
								,NULL -- ATTRIBUTE5
								,NULL -- ATTRIBUTE6
								,NULL -- ATTRIBUTE7
								,NULL -- ATTRIBUTE8
								,NULL -- ATTRIBUTE9
								,NULL -- ATTRIBUTE10
							from dm_pln_mkt_fcst w
							left outer join SCM_MST_FUTURE_PRICE FP
							on (    FP.DIVISION_ID   = w.DIVISION_ID
								AND FP.PROJECT_CODE  = w.PROJECT_CODE
								AND FP.SCM_SITE_ID   = w.SCM_SITE_ID
								AND FP.ITEM_ID       = w.ITEM_ID
								AND FP.DOM_EXP       = w.DOM_EXP
								AND FP.FCST_TYPE     = w.FCST_TYPE
								AND FP.INCOTERMS     = w.INCOTERMS
								and FP.plant_site_id = w.plant_site_id
								AND FP.YYYYMMDD = ( select basis_start_date from SCM_SYS_CALENDAR_M where basis_yyyymmdd = w.yyyymmdd )
								AND FP.MEASURE = 'KRW'
							   )
							where w.measure = 'RTF_SYS_RP'
							and w.yyyymmdd >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7), 'YYYYMMDD')
							AND w.DIVISION_ID   =  m_DIVISION_ID
							AND w.SCM_SITE_ID   =  m_SCM_SITE_ID
							AND w.PROJECT_CODE  =  m_PROJECT_CODE
							and w.item_id in ( select item_id  from scm_mst_item_sn  group by item_id )
						   and (
									select count(1)
									  from SCM_MST_SITE_ITEM a
										  ,dm_pln_sales_plan b
									 where sales_plan_adjust_yn = ''
									   and a.ITEM_ID = b.ITEM_ID
									   and a.DIVISION_ID = b.DIVISION_ID
									   and a.PROJECT_CODE = b.PROJECT_CODE
									   and a.SCM_SITE_ID = b.SCM_SITE_ID
									   and b.LAST_UPDATED_BY not in ( 'SYSTEM','CUTOFF')
									   and yyyymmdd >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7), 'YYYYMMDD')
									   and a.division_id    = w.division_id
									   and a.project_code   = w.project_code
									   and a.scm_site_id    = w.scm_site_id
									   and a.item_id        = w.item_id
							   ) = 0
							and exists (select v_division_id
											from GT_DMF0_results  where 1=1
												and W.DIVISION_ID		= v_DIVISION_ID
												and W.project_code		= v_project_code
												and W.SCM_SITE_ID		= v_SCM_SITE_ID
												and W.item_id			= v_item_id
												and W.PLANT_SITE_ID		= NVL(v_plant_site_id, NULL)
												and W.dom_exp			= v_dom_exp_new
												and W.fcst_type			= v_fcst_type_new
												and W.incoterms			= v_incoterms_new
												--[C20210504-000051] 변경 전 fcst type이 무상이고 변경 후 fcst type이 유상이 경우에만 SalesAMT 생성
												AND v_fcst_type in (SELECT SEGMENT2
																	FROM SCM_ADM_LOOKUP_MASTER_DETAIL MST
																	WHERE 1=1
																	AND MST.LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE'
																	AND MST.SEGMENT1    = 'FCST_TYPE'
																	AND VALID_YN        = 'Y'  )
												--AND v_fcst_type_new not in (SELECT SEGMENT2
												--							FROM SCM_ADM_LOOKUP_MASTER_DETAIL MST
												--							WHERE 1=1
												--							AND MST.LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE'
												--							AND MST.SEGMENT1    = 'FCST_TYPE'
												--							AND VALID_YN        = 'Y'  )
												)
						UNION ALL
						-- LOC 값을 계산
						select   w.DIVISION_ID
								,w.PROJECT_CODE
								,w.SCM_SITE_ID
								,w.ITEM_ID
								,w.DOM_EXP
								,w.FCST_TYPE
								,w.INCOTERMS
								,'SalesAmt_LOC' MEASURE
								,w.PLANT_SITE_ID
								,w.YYYYMMDD
								,FP.CURRENCY
								,cast( STR( w.QTY * NVL(FP.PRICE , 0) , 20, 5 ) as numeric(30, 10))
								,v_created_by
								,SYSDATE
								,'SYSTEM'
								,SYSDATE
								,NULL -- ATTRIBUTE1
								,NULL -- ATTRIBUTE2
								,NULL -- ATTRIBUTE3
								,NULL -- ATTRIBUTE4
								,NULL -- ATTRIBUTE5
								,NULL -- ATTRIBUTE6
								,NULL -- ATTRIBUTE7
								,NULL -- ATTRIBUTE8
								,NULL -- ATTRIBUTE9
								,NULL -- ATTRIBUTE10
							from dm_pln_mkt_fcst w
							left outer join SCM_MST_FUTURE_PRICE FP
							on (    FP.DIVISION_ID   = w.DIVISION_ID
								AND FP.PROJECT_CODE  = w.PROJECT_CODE
								AND FP.SCM_SITE_ID   = w.SCM_SITE_ID
								AND FP.ITEM_ID       = w.ITEM_ID
								AND FP.DOM_EXP       = w.DOM_EXP
								AND FP.FCST_TYPE     = w.FCST_TYPE
								AND FP.INCOTERMS     = w.INCOTERMS
								and FP.plant_site_id = w.plant_site_id
								AND FP.YYYYMMDD = ( select basis_start_date from SCM_SYS_CALENDAR_M  where basis_yyyymmdd = w.yyyymmdd )
								AND FP.MEASURE = 'LOC'
							   )
							where w.measure = 'RTF_SYS_RP'
							and w.yyyymmdd >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7), 'YYYYMMDD')
							AND w.DIVISION_ID   =  m_DIVISION_ID
							AND w.SCM_SITE_ID   =  m_SCM_SITE_ID
							AND w.PROJECT_CODE  =  m_PROJECT_CODE
							and w.item_id in ( select item_id  from scm_mst_item_sn  group by item_id )
						   and (
									select count(1)
									  from SCM_MST_SITE_ITEM a
										  ,dm_pln_sales_plan b
									 where sales_plan_adjust_yn = ''
									   and a.ITEM_ID = b.ITEM_ID
									   and a.DIVISION_ID = b.DIVISION_ID
									   and a.PROJECT_CODE = b.PROJECT_CODE
									   and a.SCM_SITE_ID = b.SCM_SITE_ID
									   and b.LAST_UPDATED_BY not in ( 'SYSTEM','CUTOFF')
									   and yyyymmdd >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7), 'YYYYMMDD')
									   and a.division_id    = w.division_id
									   and a.project_code   = w.project_code
									   and a.scm_site_id    = w.scm_site_id
									   and a.item_id        = w.item_id
							   ) = 0
							and exists (select v_division_id
											from GT_DMF0_results  where 1=1
												and W.DIVISION_ID		= v_DIVISION_ID
												and W.project_code		= v_project_code
												and W.SCM_SITE_ID		= v_SCM_SITE_ID
												and W.item_id			= v_item_id
												and W.PLANT_SITE_ID		= NVL(v_plant_site_id, NULL)
												and W.dom_exp			= v_dom_exp_new
												and W.fcst_type			= v_fcst_type_new
												and W.incoterms			= v_incoterms_new
												--[C20210504-000051] 변경 전 fcst type이 무상이고 변경 후 fcst type이 유상이 경우에만 SalesAMT 생성
												AND v_fcst_type in (SELECT SEGMENT2
																	FROM SCM_ADM_LOOKUP_MASTER_DETAIL MST
																	WHERE 1=1
																	AND MST.LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE'
																	AND MST.SEGMENT1    = 'FCST_TYPE'
																	AND VALID_YN        = 'Y'  )
												--AND v_fcst_type_new not in (SELECT SEGMENT2
												--							FROM SCM_ADM_LOOKUP_MASTER_DETAIL MST
												--							WHERE 1=1
												--							AND MST.LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE'
												--							AND MST.SEGMENT1    = 'FCST_TYPE'
												--							AND VALID_YN        = 'Y'  )
												)
						UNION ALL
						-- USD 값을 계산
						select   w.DIVISION_ID
								,w.PROJECT_CODE
								,w.SCM_SITE_ID
								,w.ITEM_ID
								,w.DOM_EXP
								,w.FCST_TYPE
								,w.INCOTERMS
								,'SalesAmt_USD' MEASURE
								,w.PLANT_SITE_ID
								,w.YYYYMMDD
								,FP.CURRENCY
								,cast( STR( w.QTY * NVL(FP.PRICE , 0) , 20, 5 ) as numeric(30, 10))
								,v_created_by
								,SYSDATE
								,'SYSTEM'
								,SYSDATE
								,NULL -- ATTRIBUTE1
								,NULL -- ATTRIBUTE2
								,NULL -- ATTRIBUTE3
								,NULL -- ATTRIBUTE4
								,NULL -- ATTRIBUTE5
								,NULL -- ATTRIBUTE6
								,NULL -- ATTRIBUTE7
								,NULL -- ATTRIBUTE8
								,NULL -- ATTRIBUTE9
								,NULL -- ATTRIBUTE10
							from dm_pln_mkt_fcst w
							left outer join SCM_MST_FUTURE_PRICE FP
							on (    FP.DIVISION_ID   = w.DIVISION_ID
								AND FP.PROJECT_CODE  = w.PROJECT_CODE
								AND FP.SCM_SITE_ID   = w.SCM_SITE_ID
								AND FP.ITEM_ID       = w.ITEM_ID
								AND FP.DOM_EXP       = w.DOM_EXP
								AND FP.FCST_TYPE     = w.FCST_TYPE
								AND FP.INCOTERMS     = w.INCOTERMS
								and FP.plant_site_id = w.plant_site_id
								AND FP.YYYYMMDD = ( select basis_start_date from SCM_SYS_CALENDAR_M where basis_yyyymmdd = w.yyyymmdd )
								AND FP.MEASURE = 'USD'
							   )
							where w.measure = 'RTF_SYS_RP'
						   and w.yyyymmdd >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7), 'YYYYMMDD')
						   AND w.DIVISION_ID   =  m_DIVISION_ID
							AND w.SCM_SITE_ID   =  m_SCM_SITE_ID
							AND w.PROJECT_CODE  =  m_PROJECT_CODE
							and w.item_id in ( select item_id  from scm_mst_item_sn  group by item_id )
						   and (
									select count(1)
									  from SCM_MST_SITE_ITEM a
										  ,dm_pln_sales_plan b
									 where sales_plan_adjust_yn = ''
									   and a.ITEM_ID = b.ITEM_ID
									   and a.DIVISION_ID = b.DIVISION_ID
									   and a.PROJECT_CODE = b.PROJECT_CODE
									   and a.SCM_SITE_ID = b.SCM_SITE_ID
									   and b.LAST_UPDATED_BY not in ( 'SYSTEM','CUTOFF')
									   and yyyymmdd >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7), 'YYYYMMDD')
									   and a.division_id    = w.division_id
									   and a.project_code   = w.project_code
									   and a.scm_site_id    = w.scm_site_id
									   and a.item_id        = w.item_id
							   ) = 0
							and exists (select v_division_id
											from GT_DMF0_results  where 1=1
												and W.DIVISION_ID		= v_DIVISION_ID
												and W.project_code		= v_project_code
												and W.SCM_SITE_ID		= v_SCM_SITE_ID
												and W.item_id			= v_item_id
												and W.PLANT_SITE_ID		= NVL(v_plant_site_id, NULL)
												and W.dom_exp			= v_dom_exp_new
												and W.fcst_type			= v_fcst_type_new
												and W.incoterms			= v_incoterms_new
												--[C20210504-000051] 변경 전 fcst type이 무상이고 변경 후 fcst type이 유상이 경우에만 SalesAMT 생성
												AND v_fcst_type in (SELECT SEGMENT2
																	FROM SCM_ADM_LOOKUP_MASTER_DETAIL MST
																	WHERE 1=1
																	AND MST.LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE'
																	AND MST.SEGMENT1    = 'FCST_TYPE'
																	AND VALID_YN        = 'Y'  )
												--AND v_fcst_type_new not in (SELECT SEGMENT2
												--							FROM SCM_ADM_LOOKUP_MASTER_DETAIL MST
												--							WHERE 1=1
												--							AND MST.LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE'
												--							AND MST.SEGMENT1    = 'FCST_TYPE'
												--							AND VALID_YN        = 'Y'  )
												)
						UNION ALL
						-- KRW 값을 계산
						select   w.DIVISION_ID
								,w.PROJECT_CODE
								,w.SCM_SITE_ID
								,w.ITEM_ID
								,w.DOM_EXP
								,w.FCST_TYPE
								,w.INCOTERMS
								,'MKT_AMT_KRW' MEASURE
								,w.PLANT_SITE_ID
								,w.YYYYMMDD
								,fp.CURRENCY
								,cast( STR( w.QTY * NVL(FP.PRICE , 0) , 20, 5 ) as numeric(30, 10))
								,v_created_by						--[2018-03-15]수정
								,SYSDATE							--[2018-03-15]수정
								,'SYSTEM'						--[2018-03-15]수정
								,SYSDATE							--[2018-03-15]수정
								,NULL -- ATTRIBUTE1
								,NULL -- ATTRIBUTE2
								,NULL -- ATTRIBUTE3
								,NULL -- ATTRIBUTE4
								,NULL -- ATTRIBUTE5
								,NULL -- ATTRIBUTE6
								,NULL -- ATTRIBUTE7
								,NULL -- ATTRIBUTE8
								,NULL -- ATTRIBUTE9
								,NULL -- ATTRIBUTE10
							from dm_pln_mkt_fcst w
							left outer join SCM_MST_FUTURE_PRICE FP
							on (    FP.DIVISION_ID   = w.DIVISION_ID
								AND FP.PROJECT_CODE  = w.PROJECT_CODE
								AND FP.SCM_SITE_ID   = w.SCM_SITE_ID
								AND FP.ITEM_ID       = w.ITEM_ID
								AND FP.DOM_EXP       = w.DOM_EXP
								AND FP.FCST_TYPE     = w.FCST_TYPE
								AND FP.INCOTERMS     = w.INCOTERMS
								and FP.plant_site_id = w.plant_site_id
								AND FP.YYYYMMDD = ( select basis_start_date from SCM_SYS_CALENDAR_M where basis_yyyymmdd = w.yyyymmdd )
								AND FP.MEASURE = 'KRW'
							   )
							where w.measure = 'MKT_FCST'
							--and w.division_id = '40'	-- [C20210629-000239]
							and w.division_id = v_division_id
							and w.yyyymmdd >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7), 'YYYYMMDD')
							AND w.DIVISION_ID   =  m_DIVISION_ID
							AND w.SCM_SITE_ID   =  m_SCM_SITE_ID
							AND w.PROJECT_CODE  =  m_PROJECT_CODE
							and w.item_id in ( select item_id  from scm_mst_item_sn  group by item_id )
							and exists (select v_division_id
											from GT_DMF0_results  where 1=1
												and W.DIVISION_ID		= v_DIVISION_ID
												and W.project_code		= v_project_code
												and W.SCM_SITE_ID		= v_SCM_SITE_ID
												and W.PLANT_SITE_ID		= NVL(v_plant_site_id, NULL)
												and W.item_id			= v_item_id
												and W.dom_exp			= v_dom_exp_new
												and W.fcst_type			= v_fcst_type_new
												and W.incoterms			= v_incoterms_new
												--[C20210504-000051] 변경 전 fcst type이 무상이고 변경 후 fcst type이 유상이 경우에만 SalesAMT 생성
												AND v_fcst_type in (SELECT SEGMENT2
																	FROM SCM_ADM_LOOKUP_MASTER_DETAIL MST
																	WHERE 1=1
																	AND MST.LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE'
																	AND MST.SEGMENT1    = 'FCST_TYPE'
																	AND VALID_YN        = 'Y'  )
												--AND v_fcst_type_new not in (SELECT SEGMENT2
												--							FROM SCM_ADM_LOOKUP_MASTER_DETAIL MST
												--							WHERE 1=1
												--							AND MST.LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE'
												--							AND MST.SEGMENT1    = 'FCST_TYPE'
												--							AND VALID_YN        = 'Y'  )
												)
						UNION ALL
						-- LOC 값을 계산
						select   w.DIVISION_ID
								,w.PROJECT_CODE
								,w.SCM_SITE_ID
								,w.ITEM_ID
								,w.DOM_EXP
								,w.FCST_TYPE
								,w.INCOTERMS
								,'MKT_AMT_LOC' MEASURE
								,w.PLANT_SITE_ID
								,w.YYYYMMDD
								,FP.CURRENCY
								,cast( STR( w.QTY * NVL(FP.PRICE , 0) , 20, 5 ) as numeric(30, 10))
								,v_created_by							--[2018-03-15]수정
								,SYSDATE								--[2018-03-15]수정
								,'SYSTEM'    							--[2018-03-15]수정
								,SYSDATE								--[2018-03-15]수정
								,NULL -- ATTRIBUTE1
								,NULL -- ATTRIBUTE2
								,NULL -- ATTRIBUTE3
								,NULL -- ATTRIBUTE4
								,NULL -- ATTRIBUTE5
								,NULL -- ATTRIBUTE6
								,NULL -- ATTRIBUTE7
								,NULL -- ATTRIBUTE8
								,NULL -- ATTRIBUTE9
								,NULL -- ATTRIBUTE10
							from dm_pln_mkt_fcst w
							left outer join SCM_MST_FUTURE_PRICE FP
							on (    FP.DIVISION_ID   = w.DIVISION_ID
								AND FP.PROJECT_CODE  = w.PROJECT_CODE
								AND FP.SCM_SITE_ID   = w.SCM_SITE_ID
								AND FP.ITEM_ID       = w.ITEM_ID
								AND FP.DOM_EXP       = w.DOM_EXP
								AND FP.FCST_TYPE     = w.FCST_TYPE
								AND FP.INCOTERMS     = w.INCOTERMS
								and FP.plant_site_id = w.plant_site_id
								AND FP.YYYYMMDD = ( select basis_start_date from SCM_SYS_CALENDAR_M  where basis_yyyymmdd = w.yyyymmdd )
								AND FP.MEASURE = 'LOC'
							   )
							where w.measure = 'MKT_FCST'
							--and w.division_id = '40'	[C20210629-000239]
							and w.division_id = v_division_id
							and w.yyyymmdd >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7), 'YYYYMMDD')
							AND w.DIVISION_ID   =  m_DIVISION_ID
							AND w.SCM_SITE_ID   =  m_SCM_SITE_ID
							AND w.PROJECT_CODE  =  m_PROJECT_CODE
							and w.item_id in ( select item_id  from scm_mst_item_sn  group by item_id )
							and exists (select v_division_id
											from GT_DMF0_results  where 1=1
												and W.DIVISION_ID		= v_DIVISION_ID
												and W.project_code		= v_project_code
												and W.SCM_SITE_ID		= v_SCM_SITE_ID
												and W.item_id			= v_item_id
												and W.PLANT_SITE_ID		= NVL(v_plant_site_id, NULL)
												and W.dom_exp			= v_dom_exp_new
												and W.fcst_type			= v_fcst_type_new
												and W.incoterms			= v_incoterms_new
												--[C20210504-000051] 변경 전 fcst type이 무상이고 변경 후 fcst type이 유상이 경우에만 SalesAMT 생성
												AND v_fcst_type in (SELECT SEGMENT2
																	FROM SCM_ADM_LOOKUP_MASTER_DETAIL MST
																	WHERE 1=1
																	AND MST.LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE'
																	AND MST.SEGMENT1    = 'FCST_TYPE'
																	AND VALID_YN        = 'Y'  )
												--AND v_fcst_type_new not in (SELECT SEGMENT2
												--							FROM SCM_ADM_LOOKUP_MASTER_DETAIL MST
												--							WHERE 1=1
												--							AND MST.LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE'
												--							AND MST.SEGMENT1    = 'FCST_TYPE'
												--							AND VALID_YN        = 'Y'  )
												)



				END

				-- SCM_MST_FUTURE_PRICE UPDATE
				BEGIN
					----------------------------------------------------------------------------------------------- 20181108 pk값 validation (START)
					-- DM_PLN_MKT_FCST 테이블에서 당주월요일 이후 데이터가 존재하는지 체크 (start)

					s_FUTURE_valid := NULL

					SELECT'[PROJECT_CODE : ' || PROJECT_CODE || ']' || char(10) || '[SCM_SITE_ID : ' || SCM_SITE_ID || ']' || char(10) || '[ITEM_ID : ' || ITEM_ID || ']' || char(10) || '[DOM_EXP : ' || DOM_EXP || ']'  INTO s_FUTURE_valid
					 || char(10) || '[FCST_TYPE : ' || FCST_TYPE || ']' || char(10) || '[INCOTERMS : ' || INCOTERMS || ']' || char(10) || '[PLANT_SITE_ID : ' || PLANT_SITE_ID || ']'
						  from SCM_MST_FUTURE_PRICE
						where exists (
FETCH FIRST 1 ROWS ONLY
								select v_project_code,v_scm_site_id,v_item_id,v_dom_exp,v_fcst_type,v_incoterms,v_plant_site_id
								--DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,incoterms,PLANT_SITE_ID
									from GT_DMF0_results rslt
									where rslt.v_division_id		= SCM_MST_FUTURE_PRICE.DIVISION_ID
									and rslt.v_project_code			= SCM_MST_FUTURE_PRICE.PROJECT_CODE
									and rslt.v_scm_site_id			= SCM_MST_FUTURE_PRICE.SCM_SITE_ID
									and rslt.v_item_id				= SCM_MST_FUTURE_PRICE.ITEM_ID
									and rslt.v_dom_exp_new			= SCM_MST_FUTURE_PRICE.DOM_EXP
									and rslt.v_fcst_type_new		= SCM_MST_FUTURE_PRICE.FCST_TYPE
									and rslt.v_incoterms_new		= SCM_MST_FUTURE_PRICE.incoterms
									and rslt.v_plant_site_id_new	= SCM_MST_FUTURE_PRICE.PLANT_SITE_ID
									and SCM_MST_FUTURE_PRICE.yyyymmdd >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7), 'YYYYMMDD')   -- 당주월요일 이후 데이터를 대상으로 함
									AND rslt.v_DIVISION_ID   =  m_DIVISION_ID
									AND rslt.v_SCM_SITE_ID   =  m_SCM_SITE_ID
									AND rslt.v_PROJECT_CODE  =  m_PROJECT_CODE
									--[C20210504-000051] 변경 전 fcst type이 유상인 경우에만 중복 Check
									AND rslt.v_fcst_type not in (	SELECT SEGMENT2
																	FROM SCM_ADM_LOOKUP_MASTER_DETAIL MST
																	WHERE 1=1
																	AND MST.LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE'
																	AND MST.SEGMENT1    = 'FCST_TYPE'
																	AND VALID_YN        = 'Y'  )
									group by v_division_id,v_project_code,v_scm_site_id,v_item_id,v_dom_exp,v_fcst_type,v_incoterms,v_plant_site_id HAVING COUNT(*) > 0
									)
							AND DIVISION_ID        =  m_DIVISION_ID
							AND SCM_SITE_ID        =  m_SCM_SITE_ID
							AND PROJECT_CODE       =  m_PROJECT_CODE;


					if s_FUTURE_valid IS NOT NULL
						BEGIN
							v_log_type := 'INVALID';
							SELECT 'Sales Price 중복이 발생하였습니다.' || char(10) || s_FUTURE_valid
							goto err_rtn
						END
						----------------------------------------------------------------------------------------------- 20181108 pk값 validation (end)
						--[C20210504-000051] Sales Price 적용 기준 변경(변경된 Key 값으로 Update -> 변경된 Key 값으로 Insert, 무상은 제외)
						INSERT INTO SCM_MST_FUTURE_PRICE
						SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, v_plant_site_id_new, A.ITEM_ID, A.YYYYMMDD, A.CURRENCY, A.MEASURE
						     , v_dom_exp_new, v_fcst_type_new, v_incoterms_new, A.PRICE, A.CREATED_BY, A.CREATION_DATE, v_created_by, SYSDATE
							 , A.ATTRIBUTE1 , A.ATTRIBUTE2 , A.ATTRIBUTE3 , A.ATTRIBUTE4 , A.ATTRIBUTE5 , A.ATTRIBUTE6 , A.ATTRIBUTE7 , A.ATTRIBUTE8 , A.ATTRIBUTE9 , A.ATTRIBUTE10
						FROM   SCM_MST_FUTURE_PRICE A
						INNER JOIN (SELECT v_division_id,v_project_code,v_scm_site_id,v_item_id,v_dom_exp,v_fcst_type,v_incoterms,v_plant_site_id
									  ,v_dom_exp_new,v_fcst_type_new,v_incoterms_new,v_plant_site_id_new,v_created_by
									from GT_DMF0_results
									where 1=1
									AND v_DIVISION_ID        =  m_DIVISION_ID
									AND v_SCM_SITE_ID        =  m_SCM_SITE_ID
									AND v_PROJECT_CODE       =  m_PROJECT_CODE
									AND v_fcst_type_new not in (SELECT SEGMENT2
																FROM SCM_ADM_LOOKUP_MASTER_DETAIL MST
																WHERE 1=1
																AND MST.LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE'
																AND MST.SEGMENT1    = 'FCST_TYPE'
																AND VALID_YN        = 'Y' )  -- 무상은 제외
									) B;
						ON(
									A.division_id     = B.v_division_id
								AND A.project_code    = B.v_project_code
								AND A.scm_site_id     = B.v_scm_site_id
								AND A.item_id         = B.v_item_id
								AND A.dom_exp         = B.v_dom_exp
								AND A.fcst_type       = B.v_fcst_type
								AND A.incoterms       = B.v_incoterms
								AND A.plant_site_id   = B.v_plant_site_id
 								and A.yyyymmdd       >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7), 'YYYYMMDD')   -- 당주월요일 이후 데이터를 대상으로 함
								AND A.DIVISION_ID     =  m_DIVISION_ID
								AND A.SCM_SITE_ID     =  m_SCM_SITE_ID
								AND A.PROJECT_CODE    =  m_PROJECT_CODE
						  )


						--[C20210504-000051] 무상->유상으로 변경된 경우에 유상 Sales Price가 없으면 알림
						/* s_unit_price_valid 변수내에는 Null이 발생하는 컬럼값이 존재하면 안됨 (변수전체가 Null로 저장됨) */

						s_unit_price_valid := null;
										SELECTCASE
																WHEN a.v_division_id = '40' THEN
																	'End Customer________ : ' ||  NVL(v_project_code , NULL)
																ELSE
																	'Project_________ : ' ||  NVL(v_project_code , NULL)
FETCH FIRST 1 ROWS ONLY
																END;
														 || char(10)  ||  'Sales site_____________ : ' ||  NVL(v_scm_site_id , NULL)
														 || char(10)  ||  'Model________________ : ' ||  NVL(v_item_id , NULL)
														 || char(10)  ||  'Customs Handbook__ : ' ||  NVL(v_dom_exp_new , NULL)
														 || char(10)  ||  'Fcst Type_____________ : ' ||
																	NVL((SELECTSEGMENT2
																		INTO s_unit_price_valid FROM SCM_ADM_LOOKUP_MASTER_DETAIL MST
																		WHERE 1=1
																		AND MST.LOOKUP_TYPE = 'SALES_TYPE_CODE'
																		AND MST.SEGMENT1    = A.v_fcst_type_new
																		), NULL)
														 || char(10)  ||  'Incoterms____________ : ' ||  NVL(v_incoterms_new , NULL)
														 || char(10)  ||  'Plant Site___________ : ' ||  NVL(v_plant_site_id_new , NULL)
														 || CHAR(10)  ||  'YYYYMMDD_________ : ' ||  NVL( MIN(M.BASIS_START_DATE), NULL)   ||  ' ~ '  ||  NVL(MAX(M.BASIS_START_DATE), NULL)
														 || char(10)  || char(10)

										FROM GT_DMF0_results A
										inner join scm_mst_site_item z
										on  a.v_division_id		 = z.DIVISION_ID
										and a.v_project_code	 = z.PROJECT_CODE
										and a.v_scm_site_id		 = z.SCM_SITE_ID
										and a.v_item_id			 = z.ITEM_ID
										and z.VALID_YN			 = 'Y'
										AND ( z.SALES_PLAN_ADJUST_YN = 'Y' OR z.SALES_PLAN_ADJUST_YN IS NULL OR z.SALES_PLAN_ADJUST_YN IS NULL )
										LEFT JOIN ( SELECT BASIS_START_DATE
													FROM SCM_SYS_CALENDAR_M M
														WHERE M.BASIS_YYYYMMDD BETWEEN TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7), 'YYYYMMDD')  --당주 월요일부터
AND TO_CHAR(/* TODO:(TO_CHAR(DATEADD(DD, -7, FN_NEXT_DAY(SYSDATE, 'MON')) + (52) * 7, 'YYYYMMDD')) */FN_NEXT_DAY(SYSDATE, 'MON') + (-7), 'YYYYMMDD')), 'YYYYMMDD')  -- 52주후 월요일까지;
													GROUP BY BASIS_START_DATE

													) M;
													ON 1=1

										LEFT JOIN SCM_MST_FUTURE_PRICE P
											ON (
													a.v_division_id		= p.division_id
												AND a.v_project_code	= p.project_code
												AND a.v_scm_site_id		= p.scm_site_id
												AND a.v_item_id			= p.item_id
												AND a.v_dom_exp_new		= p.dom_exp
												AND a.v_fcst_type_new	= p.fcst_type
												AND a.v_incoterms_new	= p.INCOTERMS
												AND a.v_plant_site_id_new = CASE WHEN a.v_division_id = '81' THEN p.plant_site_id ELSE a.v_plant_site_id END
												AND p.yyyymmdd			= M.basis_start_date
												AND p.price > 0
												)

										WHERE 1=1
											AND p.yyyymmdd IS NULL  -- PRICE값이 없는경우
											AND a.v_fcst_type_new not in (  SELECT SEGMENT2
																			FROM SCM_ADM_LOOKUP_MASTER_DETAIL MST
																			WHERE 1=1
																			AND MST.LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE'
																			AND MST.SEGMENT1     = 'FCST_TYPE'
																			AND VALID_YN        = 'Y'  )
											AND a.v_fcst_type in (		SELECT SEGMENT2
																		FROM SCM_ADM_LOOKUP_MASTER_DETAIL MST
																		WHERE 1=1
																		AND MST.LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE'
																		AND MST.SEGMENT1     = 'FCST_TYPE'
																		AND VALID_YN        = 'Y'  )
										GROUP BY V_DIVISION_ID,V_PROJECT_CODE,V_SCM_SITE_ID,V_ITEM_ID,V_DOM_EXP_NEW,V_FCST_TYPE_NEW,V_INCOTERMS_NEW,V_PLANT_SITE_ID_NEW,P.YYYYMMDD
										ORDER BY V_DIVISION_ID,V_PROJECT_CODE,V_SCM_SITE_ID,V_ITEM_ID,V_DOM_EXP_NEW,V_FCST_TYPE_NEW,V_INCOTERMS_NEW,V_PLANT_SITE_ID_NEW,P.YYYYMMDD
									)

						IF s_unit_price_valid IS NOT NULL THEN
							v_log_type := 'INVALID'
FETCH FIRST 1 ROWS ONLY;
							v_description := s_unit_price_valid  ||  'Unit Price Not Found !' || char(10)  ||  '해당주차의 Sales Price 값을 입력하시기 바랍니다.' || char(10)  ||  '미래구간 52주차까지 Sales Price 값이 모두 입력되어야 합니다.'
							SELECT v_description
							GOTO ERR_RTN
						END IF;

						/*
						MERGE INTO SCM_MST_FUTURE_PRICE A;
						USING (
								SELECT v_division_id,v_project_code,v_scm_site_id,v_item_id,v_dom_exp,v_fcst_type,v_incoterms,v_plant_site_id
									  ,v_dom_exp_new,v_fcst_type_new,v_incoterms_new,v_plant_site_id_new,v_created_by
									  from GT_DMF0_results
										  where 1=1
											AND v_DIVISION_ID        =  m_DIVISION_ID
											AND v_SCM_SITE_ID        =  m_SCM_SITE_ID
											AND v_PROJECT_CODE       =  m_PROJECT_CODE
							  ) B;
						ON(
									A.division_id     = B.v_division_id
								AND A.project_code    = B.v_project_code
								AND A.scm_site_id     = B.v_scm_site_id
								AND A.item_id         = B.v_item_id
								AND A.dom_exp         = B.v_dom_exp
								AND A.fcst_type       = B.v_fcst_type
								AND A.incoterms       = B.v_incoterms
								AND A.plant_site_id   = B.v_plant_site_id
 								and A.yyyymmdd       >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7), 'YYYYMMDD')   -- 당주월요일 이후 데이터를 대상으로 함
								AND A.DIVISION_ID        =  m_DIVISION_ID
								AND A.SCM_SITE_ID        =  m_SCM_SITE_ID
								AND A.PROJECT_CODE       =  m_PROJECT_CODE
						  )
						WHEN MATCHED THEN
							 UPDATE  SET  dom_exp			= v_dom_exp_new
										 ,fcst_type			= v_fcst_type_new
										 ,incoterms			= v_incoterms_new
										 ,plant_site_id		= v_plant_site_id_new
										,last_updated_by	= v_created_by
										,last_update_date	= SYSDATE
							 ;*/
				END;


				--===================================================================================== HISTORY INSERT INTO start
				BEGIN

							INSERT INTO DM_PLN_MKT_FCST_PK_DATA_UPDATE_H
							SELECT
									 v_division_id
									,NEXT VALUE FOR SEQ1_DM_PLN_MKT_FCST_PK_DATA_UPDATE_H
									,v_project_code
									,v_scm_site_id
									,v_item_id
									,v_dom_exp
									,v_fcst_type
									,v_incoterms
									,v_plant_site_id
									,v_dom_exp_new
									,v_fcst_type_new
									,v_incoterms_new
									,v_plant_site_id_new
									,v_created_by
									,SYSDATE
									,v_created_by
									,SYSDATE
									,null,null,null,null,null,null,null,null,null,null
							FROM GT_DMF0_results
								where 1=1
								AND v_DIVISION_ID        =  m_DIVISION_ID
								AND v_SCM_SITE_ID        =  m_SCM_SITE_ID
								AND v_PROJECT_CODE       =  m_PROJECT_CODE;

				END;

				--===================================================================================== HISTORY INSERT INTO end

			--
			FETCH CURSOR1_MST INTO;
										m_DIVISION_ID
										,m_SCM_SITE_ID
										,m_PROJECT_CODE

			-- -------------------------------------------------------------------------------------
			END;
		---------------------------------------------------------------------------------------- WHILE_1 LOOP END

		CLOSE CURSOR1_MST;
        DEALLOCATE CURSOR1_MST;

  	-- 트랜잭션 (COMMIT)

	-- -----------------------------------------------------------------------------------------
		-- END TRY
	-- -----------------------------------------------------------------------------------------
	-- -----------------------------------------------------------
    EXCEPTION
        WHEN OTHERS THEN
	-- -----------------------------------------------------------
	-- 트랜잭션 (END)
		--
      -- ERROR LOG VALUE SAVE
      v_log_type := 'ERROR';
      v_log_message := CAST(SQLERRM AS VARCHAR2(1000 CHAR));
      v_description := 'ERROR_LINE : '  ||  STR(NULL);
      d_event_date := SYSTIMESTAMP;
	  --[C20200909-000203] LOG 표준화 적용
	  PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);

	  SELECT '['  ||  TO_CHAR(SQLCODE)  ||  ']'  ||  SQLERRM;  /*-- 에러메시지 DISPLAY --*/


	-- -----------------------------------------------------------
    END CATCH;
	-- -----------------------------------------------------------
	-- 수행결과 성공여부 DISPLAY
    --  IF v_log_message IS NULL
	--  SELECT 'success'

    -- 종료 LOG
    v_log_type := 'END';
    v_log_message := '########## END of procedure ##########';
    v_description := NULL;
    d_event_date := SYSTIMESTAMP;
    PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);


	-- 트랜잭션 (END)
	err_rtn:
	IF v_log_type = 'INVALID'
		begin
						v_log_message := '########## END of procedure ##########';
			v_description := NULL;
			d_event_date := SYSTIMESTAMP;
			PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
		end
        RAISE_APPLICATION_ERROR(-20001, '오류가 발생했습니다.');
  END;
/
