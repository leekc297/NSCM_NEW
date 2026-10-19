/*
 * Program ID   : DM0014_EXCEL_UPLOAD
 * Description  : DM0014_EXCEL_UPLOAD
 * Program History
 *===========================================================================================================
 *   Date       In Charge      Description
 *===========================================================================================================
 * 2018. 01. 02   SongDH     Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 *
 */

 CREATE PROCEDURE [dbo].[DM0014_EXCEL_UPLOAD]
	@p_mode		   INT,
	@p_created_by  NVARCHAR(150)
AS

BEGIN
    SET NOCOUNT ON;

    DECLARE @v_program_id     AS NVARCHAR(40) = 'DMF0014';
    DECLARE @v_sheet_name     AS NVARCHAR(40) = 'FCST Upload';	
	DECLARE @v_sql_text       AS NVARCHAR(MAX);
	DECLARE @v_creation_date  AS NVARCHAR(40);
	DECLARE @v_count          AS INT;
	DECLARE @v_start_yyyymmdd AS NVARCHAR(8);
	DECLARE @v_end_yyyymmdd AS NVARCHAR(8);

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'DM0014_EXCEL_UPLOAD';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		
    --BEGIN TRY
	    --SELECT @v_program_id, @v_sheet_name, @p_created_by;

		SELECT @v_creation_date = CONVERT(NVARCHAR(40), MAX(T.CREATION_DATE), 121)
	    FROM   [dbo].[SCM_ADM_EXCEL_UPLOAD] T
	    WHERE  T.PROGRAM_ID = @v_program_id
	    AND    T.SHEET_NAME = @v_sheet_name
	    AND    T.CREATED_BY = @p_created_by;
			 --  AND UPPER(METADATA1_VALUE) != 'BASIS YYYYMM';
		 
		IF @v_creation_date IS NULL
			SET @v_log_type = 'END';
			SET @v_log_message = '########## END of procedure ##########';
			SET @v_description = 'Data Not Found [' + CONVERT(CHAR(19), @v_creation_date, 121) +']';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        
		-- @p_mode = 0 이면 Validation
		IF ISNULL(@p_mode, 0) = 0 
			BEGIN
		        BEGIN
				UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
                SET    UPLOAD_STATUS_CODE = 'UPLOAD'
                     , MESSAGE_TEXT       = NULL
                     --, METADATA90_VALUE   = NULL
                     --, METADATA91_VALUE   = NULL
                     --, METADATA92_VALUE   = NULL
                     --, METADATA93_VALUE   = NULL
                FROM   [dbo].[SCM_ADM_EXCEL_UPLOAD] T
				WHERE  T.PROGRAM_ID    = @v_program_id
                AND    T.SHEET_NAME    = @v_sheet_name
                AND    T.CREATED_BY    = @p_created_by
                AND    CONVERT(NVARCHAR(40), T.CREATION_DATE, 121) = @v_creation_date
                AND    ISNULL(T.UPLOAD_STATUS_CODE,'X') != 'UPLOAD';
				END;

				BEGIN
                ------------------------------------------------------------------------
                --scm2_mgr.xLOG('RESET Status = UPLOAD', SQL%ROWCOUNT, 1, TRUE);
			    SET @v_log_type = '1';
			    SET @v_log_message = '########## RESET Status = UPLOAD ##########';
			    SET @v_description = '';
			    SET @d_event_date = SYSDATETIME();
			    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
                ------------------------------------------------------------------------
				END;

				BEGIN
			    UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
                SET    UPLOAD_STATUS_CODE = 'SKIP'
                WHERE  PROGRAM_ID    = @v_program_id
                AND    SHEET_NAME    = @v_sheet_name
                AND    CREATED_BY    = @p_created_by
                AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
                AND    (   ATTRIBUTE1  IS NULL 
			            OR UPPER(ATTRIBUTE1) = 'TOTAL') ;
				END;

				BEGIN
                ------------------------------------------------------------------------
                --scm2_mgr.xLOG('SKIP EMPTY LINE      ', SQL%ROWCOUNT, 2, TRUE);
			    SET @v_log_type = '2';
			    SET @v_log_message = '########## SKIP EMPTY LINE ##########';
			    SET @v_description = '';
			    SET @d_event_date = SYSDATETIME();
			    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
                ------------------------------------------------------------------------
				END;

				BEGIN
			    UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
                SET    UPLOAD_STATUS_CODE = '@TITLE'
                WHERE  PROGRAM_ID    = @v_program_id
                AND    SHEET_NAME    = @v_sheet_name
                AND    CREATED_BY    = @p_created_by
                AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
                AND    UPPER(ATTRIBUTE1) = 'DIVISION';               
                --COMMIT;
				END;

				--SELECT @v_creation_date
				--FROM   [dbo].[SCM_ADM_EXCEL_UPLOAD] 
				--WHERE  PROGRAM_ID    = @v_program_id
    --            AND    SHEET_NAME    = @v_sheet_name
    --            AND    CREATED_BY    = @p_created_by
    --            AND    CREATION_DATE = @v_creation_date
    --            AND    UPPER(ATTRIBUTE1) = 'DIVISION';               

				BEGIN
			    ------------------------------------------------------------------------
                --scm2_mgr.xLOG('@TITLE Header Line   ', SQL%ROWCOUNT, 3, TRUE);
			    SET @v_log_type = '3';
			    SET @v_log_message = '########## TITLE Header Line ##########';
			    SET @v_description = '';
			    SET @d_event_date = SYSDATETIME();
			    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
                ------------------------------------------------------------------------
				END;

				BEGIN
				UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
                SET    UPLOAD_STATUS_CODE = 'ERROR'
                     , MESSAGE_TEXT       = 'Duplication Key.'
                WHERE  PROGRAM_ID         = @v_program_id
                AND    SHEET_NAME         = @v_sheet_name
                AND    CREATED_BY         = @p_created_by
                AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
                AND    UPLOAD_STATUS_CODE = 'UPLOAD'
                AND EXISTS (SELECT 1
				            FROM  (SELECT X.ATTRIBUTE1 AS COL1
                                        , X.ATTRIBUTE2 AS COL2
                                        , X.ATTRIBUTE3 AS COL3
                                        , X.ATTRIBUTE4 AS COL4
                                        , X.ATTRIBUTE5 AS COL5
                                        , X.ATTRIBUTE6 AS COL6
                                        , X.ATTRIBUTE7 AS COL7
                                        , X.ATTRIBUTE8  AS COL8
				                        , X.ATTRIBUTE9  AS COL9
					                    , X.ATTRIBUTE10 AS COL10
                                   FROM   [dbo].[SCM_ADM_EXCEL_UPLOAD] X
                                   WHERE  X.PROGRAM_ID    = @v_program_id
                                   AND    X.SHEET_NAME    = @v_sheet_name
                                   AND    X.CREATED_BY    = @p_created_by
                                   AND    X.CREATION_DATE = @v_creation_date
                                   AND    X.UPLOAD_STATUS_CODE = 'UPLOAD'
                                   GROUP BY X.ATTRIBUTE1
                                          , X.ATTRIBUTE2
                                          , X.ATTRIBUTE3
                                          , X.ATTRIBUTE4
                                          , X.ATTRIBUTE5
                                          , X.ATTRIBUTE6
                                          , X.ATTRIBUTE7
                                          , X.ATTRIBUTE8 
				                          , X.ATTRIBUTE9 
					                      , X.ATTRIBUTE10
                                   HAVING COUNT(*) > 1 ) T
							WHERE 1 = 1										 
						    AND T.COL1 = ATTRIBUTE1
                            AND T.COL2 = ATTRIBUTE2
                            AND T.COL3 = ATTRIBUTE3
                            AND T.COL4 = ATTRIBUTE4
                            AND T.COL5 = ATTRIBUTE5
                            AND T.COL6 = ATTRIBUTE6
                            AND T.COL7 = ATTRIBUTE7
                            AND T.COL8 = ATTRIBUTE8
				            AND T.COL9  =ATTRIBUTE9
					        AND T.COL10 = ATTRIBUTE10 
						   );
				END

				BEGIN
				------------------------------------------------------------------------
                --scm2_mgr.xLOG('ERROR Key Duplication ', SQL%ROWCOUNT, 4, TRUE);
				SET @v_log_type = '4';
			    SET @v_log_message = '########## ERROR Key Duplication ##########';
			    SET @v_description = '';
			    SET @d_event_date = SYSDATETIME();
			    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
                ------------------------------------------------------------------------
				END;
				
				BEGIN
				UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
                SET    UPLOAD_STATUS_CODE = 'ERROR'
                     , MESSAGE_TEXT       = 'Invalid Division.'
                WHERE  PROGRAM_ID         = @v_program_id
                AND    SHEET_NAME         = @v_sheet_name
                AND    CREATED_BY         = @p_created_by
                AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
                AND    UPLOAD_STATUS_CODE = 'UPLOAD'
                AND NOT EXISTS (SELECT 1
                                FROM   [dbo].[SCM_MST_DIVISION] D
                                WHERE  D.VALID_YN    = 'Y'
                                AND    D.DIVISION_ID = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE1);
				END;

				BEGIN
				------------------------------------------------------------------------
                --scm2_mgr.xLOG('Invalid Division ', SQL%ROWCOUNT, 5, TRUE);
				SET @v_log_type = '5';
			    SET @v_log_message = '########## Invalid Division ##########';
			    SET @v_description = '';
			    SET @d_event_date = SYSDATETIME();
			    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
                ------------------------------------------------------------------------
				END;
				
				
				BEGIN
				UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
                SET    UPLOAD_STATUS_CODE = 'ERROR'
                     , MESSAGE_TEXT       = 'Invalid Customer Project.'
                WHERE  PROGRAM_ID         = @v_program_id
                AND    SHEET_NAME         = @v_sheet_name
                AND    CREATED_BY         = @p_created_by
                AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
                AND    UPLOAD_STATUS_CODE = 'UPLOAD'
                AND NOT EXISTS (SELECT 1
                                FROM   [dbo].[SCM_MST_PROJECT_CUSTOMER] CP
                                WHERE  CP.DIVISION_ID  = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE1
								AND    CP.PROJECT_CODE = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE2
                                AND    CP.USE_FLAG     = 'Y');
				END;

				BEGIN
                ------------------------------------------------------------------------
                --scm2_mgr.xLOG('Invalid Customer Project ', SQL%ROWCOUNT, 6, TRUE);
				SET @v_log_type = '6';
			    SET @v_log_message = '########## Invalid Customer Project ##########';
			    SET @v_description = '';
			    SET @d_event_date = SYSDATETIME();
			    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
                ------------------------------------------------------------------------
				END;
				
				/*
				BEGIN
				UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
                SET    UPLOAD_STATUS_CODE = 'ERROR'
                     , MESSAGE_TEXT       = 'Invalid Customer Model.'
                WHERE  PROGRAM_ID         = @v_program_id
                AND    SHEET_NAME         = @v_sheet_name
                AND    CREATED_BY         = @p_created_by
                AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
                AND    UPLOAD_STATUS_CODE = 'UPLOAD'
                AND NOT EXISTS (SELECT 1
                                FROM   [dbo].[DM_MST_CUSTOMER_MODEL] C
                                WHERE  C.DIVISION_ID           = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE1
								AND    C.CUSTOMER_PROJECT_CODE = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE2
								AND    C.CUSTOMER_MODEL        = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE3
								AND    C.SCM_SITE_ID           = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE4
                                AND    C.VALID_YN              = 'Y');
				END;

				BEGIN
                ------------------------------------------------------------------------
                --scm2_mgr.xLOG('Invalid Customer Model ', SQL%ROWCOUNT, 7, TRUE);
				SET @v_log_type = '7';
			    SET @v_log_message = '########## Invalid Customer Model ##########';
			    SET @v_description = '';
			    SET @d_event_date = SYSDATETIME();
			    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
                ------------------------------------------------------------------------
				END;
				*/
				
				BEGIN
				UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
                SET    UPLOAD_STATUS_CODE = 'ERROR'
                     , MESSAGE_TEXT       = 'Invalid Scm Site.'
                WHERE  PROGRAM_ID         = @v_program_id
                AND    SHEET_NAME         = @v_sheet_name
                AND    CREATED_BY         = @p_created_by
                AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
                AND    UPLOAD_STATUS_CODE = 'UPLOAD'
                AND NOT EXISTS (SELECT 1
                                FROM   [dbo].[SCM_MST_SITE] S
                                WHERE  S.DIVISION_ID = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE1
								AND    S.SCM_SITE_ID = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE4
                                AND    S.VALID_YN    = 'Y');
				END;

				BEGIN
                ------------------------------------------------------------------------
                --scm2_mgr.xLOG('Invalid Scm Site ', SQL%ROWCOUNT, 8, TRUE);
				SET @v_log_type = '8';
			    SET @v_log_message = '########## Invalid Scm Site. ##########';
			    SET @v_description = '';
			    SET @d_event_date = SYSDATETIME();
			    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
                ------------------------------------------------------------------------
				END;
				
				
				BEGIN
				UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
                SET    UPLOAD_STATUS_CODE = 'ERROR'
                     , MESSAGE_TEXT       = 'Invalid Project.'
                WHERE  PROGRAM_ID         = @v_program_id
                AND    SHEET_NAME         = @v_sheet_name
                AND    CREATED_BY         = @p_created_by
                AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
                AND    UPLOAD_STATUS_CODE = 'UPLOAD'
                AND NOT EXISTS (SELECT 1
                                FROM   [dbo].[SCM_MST_PROJECT] P
                                WHERE  P.DIVISION_ID  = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE1
								AND    P.PROJECT_CODE = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE9 );
				END;

				BEGIN
                ------------------------------------------------------------------------
                --scm2_mgr.xLOG('Invalid Project ', SQL%ROWCOUNT, 9, TRUE);
				SET @v_log_type = '9';
			    SET @v_log_message = '########## Invalid Project. ##########';
			    SET @v_description = '';
			    SET @d_event_date = SYSDATETIME();
			    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
                ------------------------------------------------------------------------
				END;
				
				
				BEGIN
				UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
                SET    UPLOAD_STATUS_CODE = 'ERROR'
                     , MESSAGE_TEXT       = 'Invalid Model.'
                WHERE  PROGRAM_ID         = @v_program_id
                AND    SHEET_NAME         = @v_sheet_name
                AND    CREATED_BY         = @p_created_by
                AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
                AND    UPLOAD_STATUS_CODE = 'UPLOAD'
                AND NOT EXISTS (SELECT 1
                                FROM   [dbo].[SCM_MST_PROJECT_ITEM] I
                                WHERE  I.DIVISION_ID  = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE1
								AND    I.PROJECT_CODE = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE9
								AND    I.PROJECT_VER_SEQ  = '0000000001'
								AND    I.ITEM_ID      = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE10
                                AND    I.VALID_YN     = 'Y');
				END;

				BEGIN
                ------------------------------------------------------------------------
                --scm2_mgr.xLOG('Invalid Model ', SQL%ROWCOUNT, 10, TRUE);
				SET @v_log_type = '10';
			    SET @v_log_message = '########## Invalid Model. ##########';
			    SET @v_description = '';
			    SET @d_event_date = SYSDATETIME();
			    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
                ------------------------------------------------------------------------
				END;
				

				BEGIN
				UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
                SET    UPLOAD_STATUS_CODE = 'SUCCESS'
                WHERE  PROGRAM_ID         = @v_program_id
                AND    SHEET_NAME         = @v_sheet_name
                AND    CREATED_BY         = @p_created_by
                AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121)  = @v_creation_date
                AND    UPLOAD_STATUS_CODE = 'UPLOAD';
				END;

				BEGIN
                ----------------------------------------------------------------------------
                --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
				SET @v_log_type = '12';
			    SET @v_log_message = '########## SUCCESS ##########';
			    SET @v_description = '';
			    SET @d_event_date = SYSDATETIME();
			    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
                ----------------------------------------------------------------------------
				END;

			END;

		--// SCM_UI_EXCEL_UPLOAD_T =>  DMR_CAPA_ALLOC_M
        --//======================================================================================
        SELECT @v_count = COUNT(1)
        FROM   [dbo].[SCM_ADM_EXCEL_UPLOAD] T
        WHERE  T.PROGRAM_ID         = @v_program_id
        AND    T.SHEET_NAME         = @v_sheet_name
        AND    T.CREATED_BY         = @p_created_by
        AND    CONVERT(NVARCHAR(40), T.CREATION_DATE, 121) = @v_creation_date
        AND    T.UPLOAD_STATUS_CODE = 'ERROR' ;

		-- Update Mode and No Errors
		IF @p_mode > 0 AND @v_count = 0				
			BEGIN
			BEGIN
			SET @v_start_yyyymmdd = '';
	        SET @v_end_yyyymmdd = '';
						
			SELECT @v_start_yyyymmdd = MIN(YYYYMMDD)
			     , @v_end_yyyymmdd = MAX(YYYYMMDD)  
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
                    FROM   [dbo].[SCM_ADM_EXCEL_UPLOAD]
		            WHERE  1 = 1
		            AND    PROGRAM_ID    = @v_program_id
	                AND    SHEET_NAME    = @v_sheet_name
		            AND    CREATED_BY    = @p_created_by
                    --AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
		            --AND    UPLOAD_STATUS_CODE = '@TITLE'
                   ) T
           UNPIVOT (    YYYYMMDD
                    FOR COLUMN_NAME
		            IN   ( ATTRIBUTE11, ATTRIBUTE12, ATTRIBUTE13, ATTRIBUTE14, ATTRIBUTE15
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
		           ) AS X
			WHERE X.YYYYMMDD != ''	
			
            END;

			BEGIN
                ----------------------------------------------------------------------------
                --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
				SET @v_log_type = '13';
			    SET @v_log_message = '########## DELETE DATE ##########';
			    SET @v_description = @p_mode; --CONVERT(CHAR(30), @v_creation_date, 121);
			    SET @d_event_date = SYSDATETIME();
			    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
                ----------------------------------------------------------------------------
				END;

			BEGIN
			DELETE [dbo].[DM_PLN_CUSTOMER_PSI]  
            WHERE  1 = 1
            AND    DIVISION_ID IN (SELECT DISTINCT T.ATTRIBUTE1
                                   FROM   [dbo].[SCM_ADM_EXCEL_UPLOAD] T
						           WHERE  T.PROGRAM_ID         = @v_program_id
                                   AND    T.SHEET_NAME         = @v_sheet_name
                                   AND    T.CREATED_BY         = @p_created_by
                                   AND    CONVERT(NVARCHAR(40), T.CREATION_DATE, 121) = @v_creation_date
                                   AND    T.UPLOAD_STATUS_CODE = 'SUCCESS' )
            AND    CUSTOMER_PROJECT_CODE IN (SELECT DISTINCT T.ATTRIBUTE2
                                             FROM   [dbo].[SCM_ADM_EXCEL_UPLOAD] T
						                     WHERE  T.PROGRAM_ID         = @v_program_id
                                             AND    T.SHEET_NAME         = @v_sheet_name
                                             AND    T.CREATED_BY         = @p_created_by
                                             AND    CONVERT(NVARCHAR(40), T.CREATION_DATE, 121)  = @v_creation_date
                                             AND    T.UPLOAD_STATUS_CODE = 'SUCCESS' )
            AND    CUSTOMER_MODEL IN (SELECT DISTINCT T.ATTRIBUTE3
                                      FROM   [dbo].[SCM_ADM_EXCEL_UPLOAD] T
						              WHERE  T.PROGRAM_ID         = @v_program_id
                                      AND    T.SHEET_NAME         = @v_sheet_name
                                      AND    T.CREATED_BY         = @p_created_by
                                      AND    CONVERT(NVARCHAR(40), T.CREATION_DATE, 121) = @v_creation_date
                                      AND    T.UPLOAD_STATUS_CODE = 'SUCCESS' )
            AND    SCM_SITE_ID IN (SELECT DISTINCT T.ATTRIBUTE4
                                   FROM   [dbo].[SCM_ADM_EXCEL_UPLOAD] T
					               WHERE  T.PROGRAM_ID         = @v_program_id
                                   AND    T.SHEET_NAME         = @v_sheet_name
                                   AND    T.CREATED_BY         = @p_created_by
                                   AND    CONVERT(NVARCHAR(40), T.CREATION_DATE, 121) = @v_creation_date
                                   AND    T.UPLOAD_STATUS_CODE = 'SUCCESS' )
            AND    YYYYMMDD BETWEEN @v_start_yyyymmdd AND @v_end_yyyymmdd;
			END;

			BEGIN
			INSERT INTO [dbo].[DM_PLN_CUSTOMER_PSI]
			(
			    DIVISION_ID
		      , CUSTOMER_PROJECT_CODE
			  , CUSTOMER_MODEL
			  , SCM_SITE_ID
			  , DOM_EXP
			  , FCST_TYPE
			  , MEASURE
			  , INCOTERMS
			  , PROJECT_CODE
			  , ITEM_ID
			  , YYYYMMDD
			  , QTY
			  , CREATED_BY
			  , CREATION_DATE
			  , LAST_UPDATED_BY
			  , LAST_UPDATE_DATE
			)			
            SELECT V.ATTRIBUTE1, V.ATTRIBUTE2, V.ATTRIBUTE3, V.ATTRIBUTE4, V.ATTRIBUTE5
	             , V.ATTRIBUTE6, V.ATTRIBUTE7, V.ATTRIBUTE8, V.ATTRIBUTE9, V.ATTRIBUTE10
	             , C.YYYYMMDD  , CONVERT(int, V.VALUE), @p_created_by, CONVERT(varchar(19), GETDATE(), 121)
				 , @p_created_by, CONVERT(varchar(19), GETDATE(), 121)
            FROM  (SELECT ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
	                    , ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
	                    , COLUMN_NAME, YYYYMMDD
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
                           FROM   [dbo].[SCM_ADM_EXCEL_UPLOAD]
		                   WHERE  1 = 1
		                   AND    PROGRAM_ID    = @v_program_id
	                       AND    SHEET_NAME    = @v_sheet_name
		                   AND    CREATED_BY    = @p_created_by
                           AND    CREATION_DATE = @v_creation_date
		                   AND    UPLOAD_STATUS_CODE = '@TITLE'
                          ) T
                  UNPIVOT (    YYYYMMDD
                           FOR COLUMN_NAME
		                   IN   ( ATTRIBUTE11, ATTRIBUTE12, ATTRIBUTE13, ATTRIBUTE14, ATTRIBUTE15
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
								)
		                  ) AS X
                  ) C
                , (SELECT ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
	                    , ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
	                    , COLUMN_NAME, VALUE
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
                           FROM   [dbo].[SCM_ADM_EXCEL_UPLOAD]
		                   WHERE  1 = 1
		                   AND    PROGRAM_ID    = @v_program_id
	                       AND    SHEET_NAME    = @v_sheet_name
		                   AND    CREATED_BY    = @p_created_by
                           AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
		                   AND    UPLOAD_STATUS_CODE = 'SUCCESS'
                          ) T
                  UNPIVOT (    VALUE
                           FOR COLUMN_NAME
		                   IN   ( ATTRIBUTE11, ATTRIBUTE12, ATTRIBUTE13, ATTRIBUTE14, ATTRIBUTE15
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
	                            , ATTRIBUTE96, ATTRIBUTE97, ATTRIBUTE98, ATTRIBUTE99, ATTRIBUTE100)
		                   ) AS X
                        ) V
	        WHERE 1 = 1	
	        AND   C.COLUMN_NAME = V.COLUMN_NAME
			AND   C.YYYYMMDD != ''
			END;
      END;
		    
    --END TRY

  --  BEGIN CATCH
	 --   BEGIN
		--    INSERT INTO scm_sys_log_batch (program_name
		--								  ,log_type
		--								  ,log_count
		--								  ,log_message
		--								  ,description
		--								  ,event_date
		--								  ,creation_date
		--								  ,created_by
		--								  ,last_update_date
		--								  ,last_updated_by)
		--	VALUES (ERROR_PROCEDURE()
		--		   ,'ERROR'
		--		   ,NULL
		--		   ,ERROR_MESSAGE()
		--		   ,NULL
		--		   ,SYSDATETIME()
		--		   ,SYSDATETIME()
		--		   ,ERROR_PROCEDURE()
		--		   ,SYSDATETIME()
		--		   ,ERROR_PROCEDURE());

		--	IF @@TRANCOUNT > 0
		--	  COMMIT WORK;
		--  END;
		--END CATCH;
END;	
