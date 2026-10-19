/*
 * Program ID   : DM0013_CUST_PSI_EXCEL_UPLOAD
 * Description  : DM0013_CUST_PSI_EXCEL_UPLOAD
 * Program History
 *===========================================================================================================
 *   Date       In Charge      Description
 *===========================================================================================================
 * 2018. 01. 02   SongDH     Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 *
 */

 CREATE PROCEDURE [dbo].[DM0013_CUST_PSI_EXCEL_UPLOAD]
	@p_mode		   INT,
	@p_created_by  NVARCHAR(150)
AS

BEGIN
    SET NOCOUNT ON;

    DECLARE @v_program_id     AS NVARCHAR(40) = 'DMF0013';
    DECLARE @v_sheet_name     AS NVARCHAR(40) = 'PSI Upload';	
	DECLARE @v_sql_text       AS NVARCHAR(MAX);
	DECLARE @v_creation_date  AS NVARCHAR(40);
	DECLARE @v_count          AS INT;
	DECLARE @v_start_yyyymmdd AS NVARCHAR(8);
	DECLARE @v_end_yyyymmdd AS NVARCHAR(8);

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'DM0013_CUST_PSI_EXCEL_UPLOAD';
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
	

	SELECT @v_creation_date = CONVERT(NVARCHAR(40), MAX(T.CREATION_DATE), 121)
	FROM   [dbo].[SCM_ADM_EXCEL_UPLOAD] T
	WHERE  T.PROGRAM_ID = @v_program_id
	AND    T.SHEET_NAME = @v_sheet_name
	AND    T.CREATED_BY = @p_created_by;
	--  AND UPPER(METADATA1_VALUE) != 'BASIS YYYYMM';
		 
	IF @v_creation_date IS NULL BEGIN
			SET @v_log_type = 'END';
			SET @v_log_message = '########## END of procedure ##########';
			SET @v_description = 'Data Not Found [' + CONVERT(CHAR(19), @v_creation_date, 121) +']';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
    END;

	-- @p_mode = 0 이면 Validation
	IF ISNULL(@p_mode, 0) = 0 BEGIN
		BEGIN
		UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
        SET    UPLOAD_STATUS_CODE = 'UPLOAD'
             , MESSAGE_TEXT       = NULL             
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
        AND    UPPER(ATTRIBUTE1) = 'DIVISION*';               
        END;
     
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
                           FROM   [dbo].[SCM_ADM_EXCEL_UPLOAD] X  WITH(NOLOCK)
                           WHERE  X.PROGRAM_ID    = @v_program_id
                           AND    X.SHEET_NAME    = @v_sheet_name
                           AND    X.CREATED_BY    = @p_created_by
                           AND    CONVERT(NVARCHAR(40), X.CREATION_DATE, 121) = @v_creation_date
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
                        FROM   [dbo].[SCM_MST_DIVISION] D  WITH(NOLOCK)
                        WHERE  D.VALID_YN    = 'Y'
                        AND    D.DIVISION_ID = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE1
						UNION
						SELECT 1
                        FROM   [dbo].[SCM_MST_DIVISION] D  WITH(NOLOCK)
                        WHERE  D.VALID_YN    = 'Y'
                        AND    D.DIVISION_NAME = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE1
					   );
		END;

		BEGIN -- Division Validation은 끝났으니 코드로 정보를 치환해줌.
		UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
        SET    ATTRIBUTE1 = (
								SELECT D.DIVISION_ID
								FROM   [dbo].[SCM_MST_DIVISION] D  WITH(NOLOCK)
								WHERE  D.VALID_YN    = 'Y'
								AND    D.DIVISION_NAME = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE1
		                     )
        WHERE  PROGRAM_ID         = @v_program_id
        AND    SHEET_NAME         = @v_sheet_name
        AND    CREATED_BY         = @p_created_by
        AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND NOT EXISTS (SELECT 1
                        FROM   [dbo].[SCM_MST_DIVISION] D  WITH(NOLOCK)
                        WHERE  D.VALID_YN    = 'Y'
                        AND    D.DIVISION_ID = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE1
					   );
		END;


		BEGIN
		UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid Measure Upload Bucket.'
        WHERE  PROGRAM_ID         = @v_program_id
        AND    SHEET_NAME         = @v_sheet_name
        AND    CREATED_BY         = @p_created_by
        AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND NOT EXISTS (SELECT 1
                        FROM   [dbo].[DM_MST_CUSTOMER_FCST] D  WITH(NOLOCK)
						      ,[dbo].[SCM_MST_DIVISION]     D2 WITH(NOLOCK)
                        WHERE  D.VALID_YN    = 'Y'
                        AND    D.DIVISION_ID = D2.DIVISION_ID
						and   ( D2.DIVISION_ID = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE1 or  D2.DIVISION_NAME = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE1  )
						AND    D.SCM_SITE_ID = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE2
						AND    D.MEASURE     = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE10
						AND    D.[UPLOAD_BUCKET_TYPE] IN (
						                                    SELECT CASE DATEDIFF( DAY, CAST( Z.ATTRIBUTE14 AS DATETIME) , CAST( Z.ATTRIBUTE15 AS DATETIME) )  WHEN 1 THEN 'DAILY' WHEN 7 THEN 'WEEKLY' ELSE 'MONTHLY' END
															FROM   [dbo].[SCM_ADM_EXCEL_UPLOAD] Z  WITH(NOLOCK)
                                                            WHERE  Z.PROGRAM_ID = @v_program_id
															AND    Z.SHEET_NAME = @v_sheet_name
															AND    Z.CREATED_BY = @p_created_by
															AND    CONVERT(NVARCHAR(40), z.CREATION_DATE, 121) = @v_creation_date
															AND    Z.UPLOAD_STATUS_CODE = '@TITLE'
						                                 )   
						);
		END;
		
		BEGIN
		UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid Measure Upload UOM.'
        WHERE  PROGRAM_ID         = @v_program_id
        AND    SHEET_NAME         = @v_sheet_name
        AND    CREATED_BY         = @p_created_by
        AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND NOT EXISTS (SELECT 1
                        FROM   [dbo].[DM_MST_CUSTOMER_FCST] D  WITH(NOLOCK)
						      ,[dbo].[SCM_MST_DIVISION]     D2 WITH(NOLOCK)
                        WHERE  D.VALID_YN    = 'Y'
                        AND    D.DIVISION_ID = D2.DIVISION_ID
						and   ( D2.DIVISION_ID = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE1 or  D2.DIVISION_NAME = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE1  )
						AND    D.SCM_SITE_ID = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE2
						AND    D.MEASURE     = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE10
						AND    D.UPLOAD_UOM =  [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE11  
						);
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
             , MESSAGE_TEXT       = 'Invalid Scm Site.'
        WHERE  PROGRAM_ID         = @v_program_id
        AND    SHEET_NAME         = @v_sheet_name
        AND    CREATED_BY         = @p_created_by
        AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND NOT EXISTS (SELECT 1
                        FROM   [dbo].[SCM_MST_SITE] S  WITH(NOLOCK)
                        WHERE  S.DIVISION_ID = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE1
						AND    S.SCM_SITE_ID = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE2
                        AND    S.VALID_YN    = 'Y');
		END;

		BEGIN
        ------------------------------------------------------------------------
        --scm2_mgr.xLOG('Invalid Scm Site ', SQL%ROWCOUNT, 8, TRUE);
		SET @v_log_type = '6';
	    SET @v_log_message = '########## Invalid Scm Site. ##########';
	    SET @v_description = '';
	    SET @d_event_date = SYSDATETIME();
	    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        ------------------------------------------------------------------------
		END;

		BEGIN
		UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid Plant Site.'
        WHERE  PROGRAM_ID         = @v_program_id
        AND    SHEET_NAME         = @v_sheet_name
        AND    CREATED_BY         = @p_created_by
        AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
		AND    (ATTRIBUTE1 =  '81' or ATTRIBUTE1 = 'Automotive Battery')  -- ess는 제외
        AND NOT EXISTS (SELECT 1
                        FROM   [dbo].[SCM_MST_SITE] S  WITH(NOLOCK)
                        WHERE  S.DIVISION_ID = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE1
						AND    S.SCM_SITE_ID = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE3
                        AND    S.VALID_YN    = 'Y');
		END;

		BEGIN
        ------------------------------------------------------------------------
        --scm2_mgr.xLOG('Invalid Scm Site ', SQL%ROWCOUNT, 8, TRUE);
		SET @v_log_type = '6';
	    SET @v_log_message = '########## Invalid Plant Site. ##########';
	    SET @v_description = '';
	    SET @d_event_date = SYSDATETIME();
	    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        ------------------------------------------------------------------------
		END;
		/*
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
                        FROM   [dbo].[DM_MST_CUSTOMER_MODEL] CM  WITH(NOLOCK)
                        WHERE  CM.DIVISION_ID           = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE1
					    AND    CM.SCM_SITE_ID           = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE2
					    AND    CM.CUSTOMER_PROJECT_CODE = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE4
                        AND    CM.VALID_YN              = 'Y');
		END;

		BEGIN
        ------------------------------------------------------------------------
        --scm2_mgr.xLOG('Invalid Customer Project ', SQL%ROWCOUNT, 6, TRUE);
		SET @v_log_type = '7';
	    SET @v_log_message = '########## Invalid Customer Project ##########';
	    SET @v_description = '';
	    SET @d_event_date = SYSDATETIME();
	    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        ------------------------------------------------------------------------
		END;
		*/

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
                        FROM   [dbo].[DM_MST_CUSTOMER_MODEL] CM  WITH(NOLOCK)
                        WHERE  CM.DIVISION_ID           = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE1
					    AND    CM.SCM_SITE_ID           = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE2
					    AND    CM.CUSTOMER_PROJECT_CODE = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE4
						AND    CM.CUSTOMER_MODEL        = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE5
                        AND    CM.VALID_YN              = 'Y');
		END;

		BEGIN
        ------------------------------------------------------------------------
        --scm2_mgr.xLOG('Invalid Customer Model ', SQL%ROWCOUNT, 7, TRUE);
		SET @v_log_type = '8';
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
             , MESSAGE_TEXT       = 'Invalid Incoterms.'
        WHERE  PROGRAM_ID         = @v_program_id
        AND    SHEET_NAME         = @v_sheet_name
        AND    CREATED_BY         = @p_created_by
        AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND NOT EXISTS (SELECT 1
                        FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L WITH(NOLOCK)  
                        WHERE  L.SEGMENT1    = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE6
						AND    L.LOOKUP_TYPE = 'INCOTERMS'
						AND    L.VALID_YN    = 'Y');
		END;

		BEGIN
        ------------------------------------------------------------------------
        --scm2_mgr.xLOG('Invalid Project ', SQL%ROWCOUNT, 9, TRUE);
		SET @v_log_type = '10';
		SET @v_log_message = '########## Invalid Incoterms. ##########';
		SET @v_description = '';
	    SET @d_event_date = SYSDATETIME();
	    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        ------------------------------------------------------------------------
		END;

		BEGIN
		UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid Sales Type.'
        WHERE  PROGRAM_ID         = @v_program_id
        AND    SHEET_NAME         = @v_sheet_name
        AND    CREATED_BY         = @p_created_by
        AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND NOT EXISTS (SELECT 1
                        FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L WITH(NOLOCK)
                        WHERE  L.SEGMENT1    = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE7
						AND    L.LOOKUP_TYPE = 'SALES_TYPE_CODE'
						AND    L.VALID_YN    = 'Y'
						UNION
						SELECT 1
                        FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] D  WITH(NOLOCK)
                        WHERE  D.VALID_YN    = 'Y'
                        AND    D.SEGMENT2 = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE7
					   );
		END;

		BEGIN -- validation이 끝났으니 code로 update
		UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
        SET    ATTRIBUTE7 = (
							SELECT D.SEGMENT1
							FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] D  WITH(NOLOCK)
							WHERE  D.VALID_YN    = 'Y'
							AND    D.LOOKUP_TYPE = 'SALES_TYPE_CODE'
							AND    D.SEGMENT2 = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE7
		                    )
        WHERE  PROGRAM_ID         = @v_program_id
        AND    SHEET_NAME         = @v_sheet_name
        AND    CREATED_BY         = @p_created_by
        AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND NOT EXISTS (SELECT 1
                        FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L WITH(NOLOCK)
                        WHERE  L.SEGMENT1 = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE7
						AND    L.LOOKUP_TYPE = 'SALES_TYPE_CODE'
						AND    L.VALID_YN    = 'Y'
					   );
		END;

		BEGIN
        ------------------------------------------------------------------------
        --scm2_mgr.xLOG('Invalid Project ', SQL%ROWCOUNT, 9, TRUE);
		SET @v_log_type = '11';
		SET @v_log_message = '########## Invalid Sales Type. ##########';
		SET @v_description = '';
	    SET @d_event_date = SYSDATETIME();
	    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        ------------------------------------------------------------------------
		END;

		/*
		BEGIN
		UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid Customs Handbook'
        WHERE  PROGRAM_ID         = @v_program_id
        AND    SHEET_NAME         = @v_sheet_name
        AND    CREATED_BY         = @p_created_by
        AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND NOT EXISTS (SELECT 1
                        FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L WITH(NOLOCK)
                        WHERE  L.SEGMENT1 = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE8
						AND    L.LOOKUP_TYPE = 'DOM/EXP'
						AND    L.VALID_YN    = 'Y');
		END;

		BEGIN
        ------------------------------------------------------------------------
        --scm2_mgr.xLOG('Invalid Project ', SQL%ROWCOUNT, 9, TRUE);
		SET @v_log_type = '12';
		SET @v_log_message = '########## Invalid DOM/EXP. ##########';
		SET @v_description = '';
	    SET @d_event_date = SYSDATETIME();
	    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        ------------------------------------------------------------------------
		END;
		*/

		BEGIN
		UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid Measure Group.'
        WHERE  PROGRAM_ID         = @v_program_id
        AND    SHEET_NAME         = @v_sheet_name
        AND    CREATED_BY         = @p_created_by
        AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND NOT EXISTS (SELECT 1
                        FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L WITH(NOLOCK)
                        WHERE  L.SEGMENT1 = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE9
						AND    L.LOOKUP_TYPE = 'MEASURE_GROUP_CODE'
						AND    L.SEGMENT1 = 'PSI'
						AND    L.VALID_YN    = 'Y');
		END;

		BEGIN
        ------------------------------------------------------------------------
        --scm2_mgr.xLOG('Invalid Project ', SQL%ROWCOUNT, 9, TRUE);
		SET @v_log_type = '13';
		SET @v_log_message = '########## Invalid Measure Group. ##########';
		SET @v_description = '';
	    SET @d_event_date = SYSDATETIME();
	    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        ------------------------------------------------------------------------
		END;

		BEGIN
		UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid Upload UOM.'
        WHERE  PROGRAM_ID         = @v_program_id
        AND    SHEET_NAME         = @v_sheet_name
        AND    CREATED_BY         = @p_created_by
        AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND NOT EXISTS (SELECT 1
                        FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L WITH(NOLOCK)
                        WHERE  L.SEGMENT1 = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE11
						AND    L.LOOKUP_TYPE = 'UPLOAD_UOM_TYPE_CODE'
						AND    L.VALID_YN    = 'Y');
		END;

		BEGIN
        ------------------------------------------------------------------------
        --scm2_mgr.xLOG('Invalid Project ', SQL%ROWCOUNT, 9, TRUE);
		SET @v_log_type = '14';
		SET @v_log_message = '########## Invalid Upload UOM. ##########';
		SET @v_description = '';
	    SET @d_event_date = SYSDATETIME();
	    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        ------------------------------------------------------------------------
		END;

		-- Upload UOM by Model
	/*	BEGIN
		UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid Upload UOM by .'
        WHERE  PROGRAM_ID         = @v_program_id
        AND    SHEET_NAME         = @v_sheet_name
        AND    CREATED_BY         = @p_created_by
        AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND NOT EXISTS (SELECT 1
                        FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L WITH(NOLOCK)
                        WHERE  L.SEGMENT1 = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE11
						AND    L.LOOKUP_TYPE = 'UPLOAD_UOM_TYPE_CODE'
						AND    L.VALID_YN    = 'Y');
		END;

		BEGIN
        ------------------------------------------------------------------------
        --scm2_mgr.xLOG('Invalid Project ', SQL%ROWCOUNT, 9, TRUE);
		SET @v_log_type = '14';
		SET @v_log_message = '########## Invalid Upload UOM. ##########';
		SET @v_description = '';
	    SET @d_event_date = SYSDATETIME();
	    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        ------------------------------------------------------------------------
		END;
		*/
		/*
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
                        FROM   [dbo].[DM_MST_CUSTOMER_MODEL] CM  WITH(NOLOCK)
                        WHERE  CM.DIVISION_ID           = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE1
					    AND    CM.SCM_SITE_ID           = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE2
					    AND    CM.CUSTOMER_PROJECT_CODE = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE4
						AND    CM.CUSTOMER_MODEL        = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE5
						AND    CM.PROJECT_CODE          = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE12
                        AND    CM.VALID_YN              = 'Y');
		END;

		BEGIN
        ------------------------------------------------------------------------
        --scm2_mgr.xLOG('Invalid Project ', SQL%ROWCOUNT, 9, TRUE);
		SET @v_log_type = '16';
		SET @v_log_message = '########## Invalid Project. ##########';
		SET @v_description = '';
	    SET @d_event_date = SYSDATETIME();
	    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        ------------------------------------------------------------------------
		END;
		*/
		/*
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
                        FROM   [dbo].[DM_MST_CUSTOMER_MODEL] CM  WITH(NOLOCK)
                        WHERE  CM.DIVISION_ID           = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE1
					    AND    CM.SCM_SITE_ID           = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE2
					    AND    CM.CUSTOMER_PROJECT_CODE = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE4
						AND    CM.CUSTOMER_MODEL        = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE5
						AND    CM.PROJECT_CODE          = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE12
						AND    CM.ITEM_ID               = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE13
                        AND    CM.VALID_YN              = 'Y');
		END;

		BEGIN
        ------------------------------------------------------------------------
        --scm2_mgr.xLOG('Invalid Model ', SQL%ROWCOUNT, 10, TRUE);
		SET @v_log_type = '17';
	    SET @v_log_message = '########## Invalid Model. ##########';
	    SET @v_description = '';
	    SET @d_event_date = SYSDATETIME();
	    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        ------------------------------------------------------------------------
		END;
		*/

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

	BEGIN
    ----------------------------------------------------------------------------
    --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
	SET @v_log_type = '13';
	SET @v_log_message = '########## INSERT DATA START ##########';
	SET @v_description = @p_mode; --CONVERT(CHAR(30), @v_creation_date, 121);
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
    ----------------------------------------------------------------------------
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
	IF @p_mode > 0 AND @v_count = 0	BEGIN
		BEGIN
		SET @v_start_yyyymmdd = '';
	    SET @v_end_yyyymmdd = '';
		END;
		
		BEGIN
        ----------------------------------------------------------------------------
        --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
		SET @v_log_type = '13';
		SET @v_log_message = '########## DELETE DATE START ##########';
		SET @v_description = @p_mode; --CONVERT(CHAR(30), @v_creation_date, 121);
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        ----------------------------------------------------------------------------
		END;

		BEGIN
		SELECT @v_start_yyyymmdd = D.MIN_YYYYMMDD
		     , @v_end_yyyymmdd = D.MAX_YYYYMMDD
		FROM  (				
		       SELECT MIN(YYYYMMDD) AS MIN_YYYYMMDD
		            , MAX(YYYYMMDD) AS MAX_YYYYMMDD
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
                FROM   [dbo].[SCM_ADM_EXCEL_UPLOAD]  WITH(NOLOCK)
		        WHERE  1 = 1
		        AND    PROGRAM_ID    = @v_program_id
	            AND    SHEET_NAME    = @v_sheet_name
		        AND    CREATED_BY    = @p_created_by
                AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
		        AND    UPLOAD_STATUS_CODE = '@TITLE'
               ) T
       UNPIVOT (    YYYYMMDD
                FOR COLUMN_NAME
		        IN   ( ATTRIBUTE12, ATTRIBUTE13, ATTRIBUTE14, ATTRIBUTE15
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
		) AS D;			
        END;

		BEGIN
        ----------------------------------------------------------------------------
        --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
		SET @v_log_type = '14';
		SET @v_log_message = '########## DELETE DATE END ##########';
		SET @v_description = @p_mode; --CONVERT(CHAR(30), @v_creation_date, 121);
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        ----------------------------------------------------------------------------
		END;

		BEGIN TRANSACTION;
		BEGIN TRY
			BEGIN
			DELETE [dbo].[DM_PLN_CUSTOMER_PSI]  
			WHERE  1 = 1
			AND    MEASURE_GROUP = 'PSI'
			AND    DIVISION_ID IN (SELECT DISTINCT T.ATTRIBUTE1
								   FROM   [dbo].[SCM_ADM_EXCEL_UPLOAD] T  WITH(NOLOCK)
								   WHERE  T.PROGRAM_ID         = @v_program_id
								   AND    T.SHEET_NAME         = @v_sheet_name
								   AND    T.CREATED_BY         = @p_created_by
								   AND    CONVERT(NVARCHAR(40), T.CREATION_DATE, 121) = @v_creation_date
								   AND    T.UPLOAD_STATUS_CODE = 'SUCCESS' )
			AND    SCM_SITE_ID IN (SELECT DISTINCT T.ATTRIBUTE2 
								   FROM   [dbo].[SCM_ADM_EXCEL_UPLOAD] T  WITH(NOLOCK)
								   WHERE  T.PROGRAM_ID         = @v_program_id
								   AND    T.SHEET_NAME         = @v_sheet_name
								   AND    T.CREATED_BY         = @p_created_by
								   AND    CONVERT(NVARCHAR(40), T.CREATION_DATE, 121) = @v_creation_date
								   AND    T.UPLOAD_STATUS_CODE = 'SUCCESS' )
			AND    PLANT_SITE_ID IN (SELECT DISTINCT T.ATTRIBUTE3
								     FROM   [dbo].[SCM_ADM_EXCEL_UPLOAD] T  WITH(NOLOCK)
								     WHERE  T.PROGRAM_ID         = @v_program_id
								     AND    T.SHEET_NAME         = @v_sheet_name
								     AND    T.CREATED_BY         = @p_created_by
								     AND    CONVERT(NVARCHAR(40), T.CREATION_DATE, 121) = @v_creation_date
								     AND    T.UPLOAD_STATUS_CODE = 'SUCCESS' )
			AND    CUSTOMER_PROJECT_CODE IN (SELECT DISTINCT T.ATTRIBUTE4
											 FROM   [dbo].[SCM_ADM_EXCEL_UPLOAD] T  WITH(NOLOCK)
											 WHERE  T.PROGRAM_ID         = @v_program_id
											 AND    T.SHEET_NAME         = @v_sheet_name
											 AND    T.CREATED_BY         = @p_created_by
											 AND    CONVERT(NVARCHAR(40), T.CREATION_DATE, 121)  = @v_creation_date
											 AND    T.UPLOAD_STATUS_CODE = 'SUCCESS' )
			AND    CUSTOMER_MODEL IN (SELECT DISTINCT T.ATTRIBUTE5
									  FROM   [dbo].[SCM_ADM_EXCEL_UPLOAD] T  WITH(NOLOCK)
									  WHERE  T.PROGRAM_ID         = @v_program_id
									  AND    T.SHEET_NAME         = @v_sheet_name
									  AND    T.CREATED_BY         = @p_created_by
									  AND    CONVERT(NVARCHAR(40), T.CREATION_DATE, 121) = @v_creation_date
									  AND    T.UPLOAD_STATUS_CODE = 'SUCCESS' )        
			AND    MEASURE IN (SELECT DISTINCT T.ATTRIBUTE10
							   FROM   [dbo].[SCM_ADM_EXCEL_UPLOAD] T  WITH(NOLOCK)
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
			  , SCM_SITE_ID
			  , PLANT_SITE_ID
			  , CUSTOMER_PROJECT_CODE
			  , CUSTOMER_MODEL
			  , INCOTERMS
			  , FCST_TYPE
			  , DOM_EXP
			  , MEASURE_GROUP
			  , MEASURE
			  , UPLOAD_UOM
			  , PROJECT_CODE
			  , ITEM_ID
			  , YYYYMMDD
			  , QTY
			  , CREATED_BY
			  , CREATION_DATE
			  , LAST_UPDATED_BY
			  , LAST_UPDATE_DATE
			  , BATCH_RESULT
			)			
			SELECT V.ATTRIBUTE1, V.ATTRIBUTE2, V.ATTRIBUTE3, V.ATTRIBUTE4, V.ATTRIBUTE5
				 , V.ATTRIBUTE6, V.ATTRIBUTE7, V.ATTRIBUTE8, V.ATTRIBUTE9, V.ATTRIBUTE10
				 , V.ATTRIBUTE11, V.ATTRIBUTE12, V.ATTRIBUTE13
				 , C.YYYYMMDD  , CONVERT(int, V.VALUE), @p_created_by, CONVERT(varchar(19), GETDATE(), 121)
				 , @p_created_by, CONVERT(varchar(19), GETDATE(), 121), 'UI'
			FROM  (SELECT ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
						, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
						, ATTRIBUTE11, ATTRIBUTE12, ATTRIBUTE13
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
						   FROM   [dbo].[SCM_ADM_EXCEL_UPLOAD]  WITH(NOLOCK)
						   WHERE  1 = 1
						   AND    PROGRAM_ID    = @v_program_id
						   AND    SHEET_NAME    = @v_sheet_name
						   AND    CREATED_BY    = @p_created_by
						   AND    CREATION_DATE = @v_creation_date
						   AND    UPLOAD_STATUS_CODE = '@TITLE'
						  ) T
				  UNPIVOT (    YYYYMMDD
						   FOR COLUMN_NAME
						   IN   ( ATTRIBUTE14, ATTRIBUTE15
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
				  ) C
				, (SELECT ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
						, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
						, ATTRIBUTE11, ATTRIBUTE12, ATTRIBUTE13
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
						   FROM   [dbo].[SCM_ADM_EXCEL_UPLOAD]  WITH(NOLOCK)
						   WHERE  1 = 1
						   AND    PROGRAM_ID    = @v_program_id
						   AND    SHEET_NAME    = @v_sheet_name
						   AND    CREATED_BY    = @p_created_by
						   AND    CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
						   AND    UPLOAD_STATUS_CODE = 'SUCCESS'
						  ) T
				  UNPIVOT (    VALUE
						   FOR COLUMN_NAME
						   IN   ( ATTRIBUTE14, ATTRIBUTE15
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
				  ) V               
			WHERE 1 = 1	
			AND   C.COLUMN_NAME = V.COLUMN_NAME
			AND   C.YYYYMMDD != ''
			AND   V.VALUE ! = ''
			END;

			COMMIT WORK;
        END TRY
		BEGIN CATCH
		    ROLLBACK TRANSACTION;
		END CATCH
		   
		
		BEGIN
	    EXEC  [dbo].[PR_DM_PLN_CUST_PSI_TO_MKT_FCST];
	    END;
    END;

	BEGIN
    ----------------------------------------------------------------------------
    --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
	SET @v_log_type = '13';
	SET @v_log_message = '########## INSERT DATA END ##########';
	SET @v_description = @p_mode; --CONVERT(CHAR(30), @v_creation_date, 121);
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
    ----------------------------------------------------------------------------
	END;
		  
END;	
