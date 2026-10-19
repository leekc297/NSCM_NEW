
/*
 * Program ID   : SSP0022_SHIPMENT_REQUEST_EXCEL_UPLOAD
 * Description  : SSP0022_SHIPMENT_REQUEST_EXCEL_UPLOAD
 * Program History
 *===========================================================================================================
 *   Date       In Charge		Description
 *===========================================================================================================
 * 2020.07.10	 KIMYONGHO		[PJ20199555] 공급 대응력 향상을 위한 자재재공 수급 점검 체계 개선 - 최초작성
 * 2020.09.21	 KIMYONGHO		SSP INCOTERMS 변경 작업
 * 2020.10.21   KIMYONGHO		LOG 이력 START - END 짝이 안맞아서 표준 변경 작업
 * 2021/09/02   KIMYONGHO      scp_mst_bod_n_v -> SCP_MST_BOD_N_V 변경
 */
 

 CREATE PROCEDURE [dbo].[SSP0022_SHIPMENT_REQUEST_EXCEL_UPLOAD]
	@p_mode		   INT,
	@p_created_by  NVARCHAR(150)
AS

BEGIN
	SET NOCOUNT ON;

	/********************************************************************************      
	* 임시테이블만들기
	********************************************************************************/ 
	IF OBJECT_ID('tempdb..#TblDynamic_SSP0022_ShpimentReq') IS NOT NULL
		DROP TABLE #TblDynamic_SSP0022_ShpimentReq;    

	IF OBJECT_ID('tempdb..#TblDynamic_SSP0022_ShpimentReq_H') IS NOT NULL
		DROP TABLE #TblDynamic_SSP0022_ShpimentReq_H;    

	CREATE TABLE #TblDynamic_SSP0022_ShpimentReq (
		ACTIVE_FLAG				NVARCHAR(1)
		,FROM_COMPANY_ID			NVARCHAR(30)
		,FROM_DIVISION_ID			NVARCHAR(30)
		,FROM_PLANT_ID				NVARCHAR(50)
		,FROM_SITE				NVARCHAR(50)
		,TO_COMPANY_ID				NVARCHAR(30)
		,TO_DIVISION_ID			NVARCHAR(30)
		,TO_PLANT_ID				NVARCHAR(50)
		,TO_SITE					NVARCHAR(50)
		,MODEL_ID					NVARCHAR(50)
		,ITEM_ID					NVARCHAR(50)
		,BOD_ID					NVARCHAR(8)
		,ETA_DATE					NVARCHAR(8)
		,ETD_DATE					NVARCHAR(8)
		,QTY						NVARCHAR(30)
		,QTY_TO_PCM				NVARCHAR(30)
		,QTY_TO_CELL				NVARCHAR(30)
	);

     DECLARE @v_program_id     AS NVARCHAR(40) = 'SSP0022';
     DECLARE @v_sheet_name     AS NVARCHAR(40) = 'Shipment Request(Electrode)';	
	DECLARE @v_sql_text       AS NVARCHAR(MAX);
	DECLARE @v_creation_date  AS NVARCHAR(40);
	DECLARE @v_count          AS INT;
	DECLARE @v_start_yyyymmdd AS NVARCHAR(8);
	DECLARE @v_end_yyyymmdd   AS NVARCHAR(8);

	DECLARE @v_plant_start_yyyymmdd   AS NVARCHAR(8);

	DECLARE @v_cnt				INT;


	DECLARE @v_active_flag		NVARCHAR(MAX)  = 'I';
	DECLARE @v_division_id		NVARCHAR(MAX)	= NULL;
	DECLARE @v_company_id		NVARCHAR(MAX)	= NULL;
	DECLARE @v_scm_site_id		NVARCHAR(MAX)  = NULL;
	DECLARE @v_plant_id			NVARCHAR(MAX)	= NULL;
	DECLARE @v_model_id			NVARCHAR(MAX)	= NULL;
	DECLARE @v_item_id			NVARCHAR(MAX)	= NULL;
	DECLARE @v_from_site		NVARCHAR(MAX)	= NULL;
	DECLARE @v_to_site			NVARCHAR(MAX)	= NULL;
	DECLARE @v_eta_date			NVARCHAR(MAX)	= NULL;
	DECLARE @v_bod_id			NVARCHAR(MAX)	= NULL;
	DECLARE @v_qty				NVARCHAR(MAX)	= NULL;
	DECLARE @v_created_by		NVARCHAR(300)  = @p_created_by;
	DECLARE @debug_mode			NVARCHAR(1)	= 'F';

	



	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SSP0022_SHIPMENT_REQUEST_EXCEL_UPLOAD';
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
	FROM   [dbo].[SCM_ADM_EXCEL_UPLOAD] T WITH(NOLOCK)
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
	IF ISNULL(@p_mode, 0) = 0
	BEGIN
		BEGIN
			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD]
			   SET UPLOAD_STATUS_CODE = 'UPLOAD'
				 , MESSAGE_TEXT       = NULL
			  FROM [dbo].[SCM_ADM_EXCEL_UPLOAD] T
			 WHERE T.PROGRAM_ID    = @v_program_id
			   AND T.SHEET_NAME    = @v_sheet_name
			   AND T.CREATED_BY    = @p_created_by
			   AND CONVERT(NVARCHAR(40), T.CREATION_DATE, 121) = @v_creation_date
			   AND ISNULL(T.UPLOAD_STATUS_CODE,'X') != 'UPLOAD';

			SET @v_log_type = '1';
			SET @v_log_message = '########## RESET Status = UPLOAD ##########';
			SET @v_description = '';
			SET @d_event_date = SYSDATETIME();

   			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END;


		-- ///////////////////////////// VALIDATION CHECK /////////////////////////
		-- DIVISION_ID 없을 경우 SKIP 처리 ( ATTRIBUTE1 )
		BEGIN
			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD]
			   SET UPLOAD_STATUS_CODE = 'SKIP'
			 WHERE PROGRAM_ID    = @v_program_id
			   AND SHEET_NAME    = @v_sheet_name
			   AND CREATED_BY    = @p_created_by
			   AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			   AND (ISNULL(ATTRIBUTE1,'')='') ;

			SET @v_log_type = '2';
			SET @v_log_message = '########## SKIP EMPTY LINE ##########';
			SET @v_description = '';
			SET @d_event_date = SYSDATETIME();
				
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END;

		-- TITLE 처리
		BEGIN
			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD]
			   SET UPLOAD_STATUS_CODE = '@TITLE'
			 WHERE PROGRAM_ID    = @v_program_id
			   AND SHEET_NAME    = @v_sheet_name
			   AND CREATED_BY    = @p_created_by
			   AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			   AND (UPPER(ATTRIBUTE1) = 'DIV*' OR UPPER(ATTRIBUTE1) = 'DIV' OR UPPER(ATTRIBUTE1) = 'DIVISION') ;

			SET @v_log_type = '3';
			SET @v_log_message = '########## TITLE Header Line ##########';
			SET @v_description = '';
			SET @d_event_date = SYSDATETIME();
				
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END;

		-- 필수 값 NULL 값 체크
		BEGIN
			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
			   SET UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'Invalid Column Data.'
			 WHERE PROGRAM_ID         = @v_program_id
			   AND SHEET_NAME         = @v_sheet_name
			   AND CREATED_BY         = @p_created_by
			   AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			   AND UPLOAD_STATUS_CODE = 'UPLOAD'
			   AND (   ISNULL(ATTRIBUTE1,'')='' OR ISNULL(ATTRIBUTE2,'')='' OR ISNULL(ATTRIBUTE3,'')='' 
				    OR ISNULL(ATTRIBUTE4,'')='' OR ISNULL(ATTRIBUTE5,'')='' OR ISNULL(ATTRIBUTE6,'')='' 
				    OR ISNULL(ATTRIBUTE7,'')='' OR ISNULL(ATTRIBUTE8,'')=''  OR ISNULL(ATTRIBUTE9,'')=''  
					) ;

			SET @v_log_type = '4';
			SET @v_log_message = '########## ERROR Invalid Column Data ##########';
			SET @v_description = '';
			SET @d_event_date = SYSDATETIME();
				
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END;

		-- DIVISION 값 체크
		BEGIN
			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
			   SET UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'Invalid Division.'
			 WHERE PROGRAM_ID         = @v_program_id
			   AND SHEET_NAME         = @v_sheet_name
			   AND CREATED_BY         = @p_created_by
			   AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			   AND UPLOAD_STATUS_CODE = 'UPLOAD'
			   AND NOT EXISTS (SELECT 1
								 FROM [dbo].[SCM_MST_DIVISION] D  WITH(NOLOCK)
								WHERE D.VALID_YN    = 'Y'
								  AND D.DIVISION_ID = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE1
								UNION
							   SELECT 1
								 FROM [dbo].[SCM_MST_DIVISION] D  WITH(NOLOCK)
								WHERE D.VALID_YN    = 'Y'
								  AND D.DIVISION_NAME = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE1
						) ;

			SET @v_log_type = '5';
			SET @v_log_message = '########## Invalid Division ##########';
			SET @v_description = '';
			SET @d_event_date = SYSDATETIME();

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END;

		-- company 체크
		BEGIN
			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
			   SET UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'Invalid Company.'
			 WHERE PROGRAM_ID         = @v_program_id
			   AND SHEET_NAME         = @v_sheet_name
			   AND CREATED_BY         = @p_created_by
			   AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			   AND UPLOAD_STATUS_CODE = 'UPLOAD'
			   AND NOT EXISTS  (  SELECT 1
									FROM SCM_MST_SITE S WITH(NOLOCK)
								   INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL D WITH(NOLOCK)
									  ON S.COMPANY_ID = D.SEGMENT1 AND D.LOOKUP_TYPE = 'COMPANY_DESC'
								   WHERE 1 = 1
									 AND S.SITE_TYPE = 'PLANT'
									 AND S.OPERATION_GROUP = 'E'
									 AND S.DIVISION_ID = ( SELECT DIVISION_ID  
														FROM SCM_MST_SITE WITH(NOLOCK) 
													    WHERE SCM_SITE_ID  = [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE3 -- FROM SITE
														 AND	   VALID_YN  = 'Y'
														 AND   SITE_TYPE  = 'PLANT') -- DIVISION
								)	 ;
			SET @v_log_type = '6';
			SET @v_log_message = '########## Invalid Company ##########';
			SET @v_description = '';
			SET @d_event_date = SYSDATETIME();

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END;

		-- from site 체크
		BEGIN
			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
			   SET UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'Invalid From Site.'
			 WHERE PROGRAM_ID         = @v_program_id
			   AND SHEET_NAME         = @v_sheet_name
			   AND CREATED_BY         = @p_created_by
			   AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			   AND UPLOAD_STATUS_CODE = 'UPLOAD'
			   AND NOT EXISTS  (  SELECT 1
									FROM SCM_MST_SITE S WITH(NOLOCK)
								   WHERE 1 = 1
									 AND S.SITE_TYPE = 'PLANT'
									 AND S.OPERATION_GROUP = 'E'
									 --AND S.DIVISION_ID = [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE1 -- DIVISION
									 AND S.DIVISION_ID = ( SELECT DIVISION_ID  
														FROM SCM_MST_SITE WITH(NOLOCK) 
													    WHERE SCM_SITE_ID  = [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE3 -- FROM SITE
														 AND	   VALID_YN  = 'Y'
														 AND   SITE_TYPE  = 'PLANT')
									 AND S.SCM_SITE_ID = [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE3  -- FROM SITE
									)	 ;

			SET @v_log_type = '7';
			SET @v_log_message = '########## Invalid From site ##########';
			SET @v_description = '';
			SET @d_event_date = SYSDATETIME();

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END;
		-- to site 체크
		BEGIN
			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
			   SET UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'Invalid To Site.'
			 WHERE PROGRAM_ID         = @v_program_id
			   AND SHEET_NAME         = @v_sheet_name
			   AND CREATED_BY         = @p_created_by
			   AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			   AND UPLOAD_STATUS_CODE = 'UPLOAD'
			   AND NOT EXISTS  (  SELECT 1
									FROM SCM_MST_SITE S WITH(NOLOCK)
								   WHERE 1 = 1
									 AND S.SITE_TYPE = 'PLANT'
									 AND S.OPERATION_GROUP = 'A'
									 --AND S.DIVISION_ID = [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE1 -- DIVISION
									 AND S.DIVISION_ID = ( SELECT DIVISION_ID  
														FROM SCM_MST_SITE WITH(NOLOCK) 
													    WHERE SCM_SITE_ID  = [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE4 -- TO SITE
														 AND	   VALID_YN  = 'Y'
														 AND   SITE_TYPE  = 'PLANT')
									 AND S.SCM_SITE_ID = [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE4 -- TO SITE
									)	 ;

			SET @v_log_type = '8';
			SET @v_log_message = '########## Invalid To site ##########';
			SET @v_description = '';
			SET @d_event_date = SYSDATETIME();

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END;

		-- ELECTRODE_SHIP_FROM_TO 체크
		BEGIN
			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
			   SET UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'Please Check ELECTRODE_SHIP_FROM_TO Site, Div and Company Code.'
			 WHERE PROGRAM_ID         = @v_program_id
			   AND SHEET_NAME         = @v_sheet_name
			   AND CREATED_BY         = @p_created_by
			   AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			   AND UPLOAD_STATUS_CODE = 'UPLOAD'
			   AND NOT EXISTS  (   SELECT 1
								FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
							    WHERE LOOKUP_TYPE = 'ELECTRODE_SHIP_FROM_TO'
							      AND SEGMENT5 = (SELECT DIVISION_ID  
														FROM SCM_MST_SITE WITH(NOLOCK) 
													    WHERE SCM_SITE_ID  = [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE4 -- TO SITE
														 AND	   VALID_YN  = 'Y'
														 AND   SITE_TYPE  = 'PLANT')
								 AND SEGMENT4   = [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE2 -- COMPANY 
								 AND SEGMENT3   = [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE3
								 AND ATTRIBUTE1 = [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE4
						
							)	 ;

			SET @v_log_type = '9';
			SET @v_log_message = '########## Please Check ELECTRODE_SHIP_FROM_TO Site, Div and Company Code. ##########';
			SET @v_description = '';
			SET @d_event_date = SYSDATETIME();

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END;

		-- Trans Mode 체크
		BEGIN
			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
			   SET UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'Invalid Trans Mode.'
			 WHERE PROGRAM_ID         = @v_program_id
			   AND SHEET_NAME         = @v_sheet_name
			   AND CREATED_BY         = @p_created_by
			   AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			   AND UPLOAD_STATUS_CODE = 'UPLOAD'
			   AND NOT EXISTS  ( SELECT TOP 1 *
							   FROM SCP_MST_BOD_N_V S WITH(NOLOCK)
							  WHERE 1 = 1
							    AND S.DIVISION_ID =  ( SELECT DIVISION_ID  
												    FROM SCM_MST_SITE WITH(NOLOCK) 
											        WHERE SCM_SITE_ID  = [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE3 -- FROM SITE
												     AND	  VALID_YN  = 'Y'
												     AND   SITE_TYPE  = 'PLANT')
							    AND S.FROM_SITE = [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE3 -- FROM SITE
							    AND S.TO_SITE	= [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE4 -- TO SITE
							    AND S.TRANSPORT_MODE = [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE8 -- TRANS MODE
							    AND S.SSP_INCOTERMS = [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE9 -- INCOTERMS
								AND S.FROM_YYYYMMDD <= CONVERT(VARCHAR(8), GETDATE(), 112)
								AND S.TO_YYYYMMDD >= CONVERT(VARCHAR(8), GETDATE(), 112)
								ORDER BY S.PRIORITY, S.TO_YYYYMMDD

							) ;

			SET @v_log_type = '10';
			SET @v_log_message = '########## Invalid Trans Mode ##########';
			SET @v_description = '';
			SET @d_event_date = SYSDATETIME();

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END;
		-- Incoterms 체크
		BEGIN
			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
			   SET UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'Invalid Incoterms.'
			 WHERE PROGRAM_ID         = @v_program_id
			   AND SHEET_NAME         = @v_sheet_name
			   AND CREATED_BY         = @p_created_by
			   AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			   AND UPLOAD_STATUS_CODE = 'UPLOAD'
			   AND NOT EXISTS  ( SELECT TOP 1 *
							   FROM SCP_MST_BOD_N_V S WITH(NOLOCK)
							  WHERE 1 = 1
							    AND S.DIVISION_ID =  ( SELECT DIVISION_ID  
												    FROM SCM_MST_SITE WITH(NOLOCK) 
											        WHERE SCM_SITE_ID  = [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE3 -- FROM SITE
												     AND	  VALID_YN  = 'Y'
												     AND   SITE_TYPE  = 'PLANT')
							    AND S.FROM_SITE = [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE3 -- FROM SITE
						         AND S.TO_SITE	= [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE4 -- TO SITE
							    -- 2020.09.21	 KIMYONGHO		SSP INCOTERMS 변경 작업
						         --AND S.INCOTERMS = [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE9 -- INCOTERMS
							    AND S.TRANSPORT_MODE = [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE8 -- TRANS MODE
							    AND S.SSP_INCOTERMS = [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE9 -- INCOTERMS
								AND S.FROM_YYYYMMDD <= CONVERT(VARCHAR(8), GETDATE(), 112)
								AND S.TO_YYYYMMDD >= CONVERT(VARCHAR(8), GETDATE(), 112)
								ORDER BY S.PRIORITY, S.TO_YYYYMMDD
						    ) ;

			SET @v_log_type = '11';
			SET @v_log_message = '########## Invalid Incoterms ##########';
			SET @v_description = '';
			SET @d_event_date = SYSDATETIME();

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END;

		-- 날짜(YYYYMMDD) 체크
		BEGIN
			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD]
			   SET UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'Invalid Date.'
			 WHERE PROGRAM_ID         = @v_program_id
			   AND  SHEET_NAME        = @v_sheet_name
			   AND CREATED_BY         = @p_created_by
			   AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			   AND UPLOAD_STATUS_CODE = 'UPLOAD'
			   AND (ISNULL(ATTRIBUTE6,'')='' OR len(substring(replace(replace(ISNULL(ATTRIBUTE6,''),' ',''),'-',''),1,8))!=8) -- YYYYMMDD

			-- 날짜 변환
			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD]
			   SET ATTRIBUTE10 = substring(replace(replace(ISNULL(ATTRIBUTE6,''),' ',''),'-',''),1,8)
			 WHERE PROGRAM_ID         = @v_program_id
			   AND SHEET_NAME         = @v_sheet_name
			   AND CREATED_BY         = @p_created_by
			   AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			   AND UPLOAD_STATUS_CODE = 'UPLOAD'

			SET @v_log_type = '12';
			SET @v_log_message = '########## Invalid Date ##########';
			SET @v_description = '';
			SET @d_event_date = SYSDATETIME();

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END;

		-- YYYYMMDD 체크
		BEGIN
			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD]
			   SET UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'Invalid yyyyMMdd.'
			 WHERE PROGRAM_ID         = @v_program_id
			   AND SHEET_NAME         = @v_sheet_name
			   AND CREATED_BY         = @p_created_by
			   AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			   AND UPLOAD_STATUS_CODE = 'UPLOAD'
			   AND (ATTRIBUTE10         > ( SELECT MAX(CONVERT(NVARCHAR(8), DATEADD(DD, 55, CONVERT(NVARCHAR(10),CONVERT(DATE, PLAN_START_YYYYMMDD, 23))),112))
											 FROM SSP_MST_SHIP_PLAN_SCHEDULE_EE WITH(NOLOCK)
											WHERE PLAN_CUTOFF_CREATE_YN = 'N'
											  AND CURRENT_PLAN_DATE_YN  = 'Y'
											  AND COMPANY_ID            = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE2) -- COMPANY
			         OR ATTRIBUTE10    < ( SELECT MAX(PLAN_START_YYYYMMDD)
											 FROM SSP_MST_SHIP_PLAN_SCHEDULE_EE WITH(NOLOCK) 
											WHERE PLAN_CUTOFF_CREATE_YN = 'N'
											  AND CURRENT_PLAN_DATE_YN  = 'Y'
											  AND COMPANY_ID            = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE2) -- COMPANY
					)

			SET @v_log_type = '13';
			SET @v_log_message = '########## Invalid yyyyMMdd. ##########';
			SET @v_description = '';
			SET @d_event_date = SYSDATETIME();

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END

		-- 중복 값 체크
		BEGIN
			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
			   SET UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'Duplication Data.'
			 WHERE PROGRAM_ID         = @v_program_id
			   AND SHEET_NAME         = @v_sheet_name
			   AND CREATED_BY         = @p_created_by
			   AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			   AND UPLOAD_STATUS_CODE = 'UPLOAD'
			   AND EXISTS (SELECT 1
							 FROM ( SELECT PROGRAM_ID, SHEET_NAME, CREATION_DATE
										 , ATTRIBUTE1	AS DIVISION_ID
										 , ATTRIBUTE2	AS COMPANY_ID
										 , ATTRIBUTE3	AS FROM_SITE
										 , ATTRIBUTE4	AS TO_SITE
										 , ATTRIBUTE5	AS ITEM_ID
										 , ATTRIBUTE10	AS YYYYMMDD
										 , ATTRIBUTE8	AS TRANSPORT_MODE
										 , ATTRIBUTE9	AS INCOTERMS
									  FROM [dbo].[SCM_ADM_EXCEL_UPLOAD] X  WITH(NOLOCK)
									 WHERE X.PROGRAM_ID    = @v_program_id
									   AND X.SHEET_NAME    = @v_sheet_name
									   AND X.CREATED_BY    = @p_created_by
									   AND CONVERT(NVARCHAR(40), X.CREATION_DATE, 121) = @v_creation_date
									   AND X.UPLOAD_STATUS_CODE = 'UPLOAD'
									 GROUP BY PROGRAM_ID
											, SHEET_NAME
											, CREATION_DATE
											, ATTRIBUTE1
											, ATTRIBUTE2
											, ATTRIBUTE3
											, ATTRIBUTE4
											, ATTRIBUTE5
											, ATTRIBUTE10
											, ATTRIBUTE8
										     , ATTRIBUTE9
									HAVING COUNT(1) > 1  ) T
							WHERE 1 = 1
	 						  AND T.DIVISION_ID = ATTRIBUTE1
							  AND T.COMPANY_ID  = ATTRIBUTE2
							  AND T.FROM_SITE   = ATTRIBUTE3
							  AND T.TO_SITE	= ATTRIBUTE4
							  AND T.ITEM_ID     = ATTRIBUTE5
							  AND T.YYYYMMDD    = ATTRIBUTE10
							  AND T.TRANSPORT_MODE    = ATTRIBUTE8
							  AND T.INCOTERMS    = ATTRIBUTE9

						) ;

			SET @v_log_type = '14';
			SET @v_log_message = '########## Duplication Data. ##########';
			SET @v_description = '';
			SET @d_event_date = SYSDATETIME();

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END;

		-- QTY 값 체크
		BEGIN
			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
			   SET UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'Invalid Qty.'
			 WHERE PROGRAM_ID         = @v_program_id
			   AND SHEET_NAME         = @v_sheet_name
			   AND CREATED_BY         = @p_created_by
			   AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			   AND UPLOAD_STATUS_CODE = 'UPLOAD'
			   AND (CHARINDEX('.', ATTRIBUTE7) > 0 OR CONVERT(INT, ATTRIBUTE7) < 0 );

			SET @v_log_type = '15';
			SET @v_log_message = '########## Invalid Qty. ##########';
			SET @v_description = '';
			SET @d_event_date = SYSDATETIME();

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END;

		-- ITEM 유무 체크
		BEGIN
			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD]
			   SET UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'Invalid item Data.'
			 WHERE PROGRAM_ID         = @v_program_id
			   AND SHEET_NAME         = @v_sheet_name
			   AND CREATED_BY         = @p_created_by
			   AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			   AND UPLOAD_STATUS_CODE = 'UPLOAD'
			   AND NOT EXISTS ( SELECT 1
								  FROM SSP_MST_SITE_ITEM_EE_V IV WITH(NOLOCK)
								 WHERE 1=1
								   AND IV.DIVISION_ID IN (SELECT DIVISION_ID  
												        FROM SCM_MST_SITE WITH(NOLOCK) 
											            WHERE SCM_SITE_ID  = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE3 -- FROM SITE
												         AND	 VALID_YN  = 'Y'
												         AND   SITE_TYPE  = 'PLANT')
								   AND [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE3 = IV.SCM_SITE_ID
								   AND [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE5 = IV.ITEM_ID
								) ;

			SET @v_log_type = '16';
			SET @v_log_message = '########## ERROR Invalid item Data ##########';
			SET @v_description = '';
			SET @d_event_date = SYSDATETIME();
				
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END;

		-- PLAN DATE (YYYYMMDD) 체크
		BEGIN
			-- 날짜 변환
			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD]
			   SET ATTRIBUTE11 =  (SELECT  MAX(PLAN_START_YYYYMMDD)
							    FROM SSP_MST_SHIP_PLAN_SCHEDULE_EE WITH(NOLOCK)
								WHERE PLAN_CUTOFF_CREATE_YN = 'N'
								AND CURRENT_PLAN_DATE_YN  = 'Y'
								AND COMPANY_ID            = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE2) -- COMPANY
			 WHERE PROGRAM_ID         = @v_program_id
			   AND SHEET_NAME         = @v_sheet_name
			   AND CREATED_BY         = @p_created_by
			   AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			   AND UPLOAD_STATUS_CODE = 'UPLOAD'

			SET @v_log_type = '17';
			SET @v_log_message = '########## Invalid PLAN DATE ##########';
			SET @v_description = '';
			SET @d_event_date = SYSDATETIME();

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END;
		
		-- BOD_ID  체크
		BEGIN
			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD]
			   SET ATTRIBUTE12 =  (SELECT TOP 1 BOD_ID
							    FROM SCP_MST_BOD_N_V WITH(NOLOCK)
							   WHERE FROM_SITE = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE3
								AND TO_SITE     = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE4
								 -- 2020.09.21	 KIMYONGHO		SSP INCOTERMS 변경 작업
								--AND INCOTERMS   = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE9
								AND TRANSPORT_MODE = [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE8 -- TRANS MODE
							    AND SSP_INCOTERMS = [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE9 -- INCOTERMS
								AND FROM_YYYYMMDD <= CONVERT(VARCHAR(8), GETDATE(), 112)
								AND TO_YYYYMMDD >= CONVERT(VARCHAR(8), GETDATE(), 112)
								ORDER BY PRIORITY, TO_YYYYMMDD
								)
			 WHERE PROGRAM_ID         = @v_program_id
			   AND SHEET_NAME         = @v_sheet_name
			   AND CREATED_BY         = @p_created_by
			   AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			   AND UPLOAD_STATUS_CODE = 'UPLOAD'

			SET @v_log_type = '18';
			SET @v_log_message = '########## Invalid BOD_ID ##########';
			SET @v_description = '';
			SET @d_event_date = SYSDATETIME();

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END;

		-- BOD_ID_ITEM 체크
		BEGIN
			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD]
			   SET UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'Invalid Bod item Data.'
			 WHERE PROGRAM_ID         = @v_program_id
			   AND SHEET_NAME         = @v_sheet_name
			   AND CREATED_BY         = @p_created_by
			   AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			   AND UPLOAD_STATUS_CODE = 'UPLOAD'
			   AND NOT EXISTS (SELECT 1
							FROM SCP_MST_BOD_ITEM X WITH(NOLOCK)
							JOIN SCP_MST_BOD_N_V V WITH(NOLOCK)
								ON V.DIVISION_ID = X.DIVISION_ID
								AND V.BOD_ID = X.BOD_ID
							WHERE X.DIVISION_ID = (SELECT DIVISION_ID  
												FROM SCM_MST_SITE WITH(NOLOCK) 
											    WHERE SCM_SITE_ID  = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE3 -- FROM SITE
										           AND	VALID_YN  = 'Y'
										           AND SITE_TYPE  = 'PLANT')
							AND X.VALID_YN ='Y'
							AND X.BOD_ID  = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE12
							AND X.ITEM_ID = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE5 );

			SET @v_log_type = '19';
			SET @v_log_message = '########## ERROR Invalid Bod item Data ##########';
			SET @v_description = '';
			SET @d_event_date = SYSDATETIME();
				
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END;
		

		-- Confirm Day 체크
		BEGIN
			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD]
			   SET ATTRIBUTE13   =  ( 	SELECT T1.CONFIRM_DAY FROM
								(SELECT 	 /* 확정구간 과 Oper LT 중 큰 일수 + bod LT   기간 이후 부터 입력 가능하게 적용 
										bod LT 는 [FN_GET_SSP_ETA_DATE] 함수 사용 */
									CASE WHEN ISNULL(TC.SEGMENT5,0) >  ISNULL(TD.SHIP_FROZEN,0) 
										THEN  
											CONVERT(CHAR(8), DATEADD(DD, ISNULL(DATEDIFF(DD, [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE11, [dbo].[FN_GET_SSP_ETA_DATE](X.DIVISION_ID, X.BOD_ID, CONVERT(CHAR(8),DATEADD(DD,ISNULL(TC.SEGMENT5,0) + 0, [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE11),112))),0) , [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE11), 112) 	
										ELSE
											CONVERT(CHAR(8), DATEADD(DD, ISNULL(DATEDIFF(DD, [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE11, [dbo].[FN_GET_SSP_ETA_DATE](X.DIVISION_ID, X.BOD_ID, CONVERT(CHAR(8),DATEADD(DD,ISNULL(TD.SHIP_FROZEN,0) + 0, [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE11),112))),0)  , [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE11), 112) 	

										END AS CONFIRM_DAY
									, [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE10 AS ATTRIBUTE10
								FROM (
										SELECT  DIVISION_ID
											  ,BOD_ID
											  ,ITEM_ID      
											  ,FROM_YYYYMMDD
											  ,TO_YYYYMMDD
										FROM   SCP_MST_BOD_ITEM A WITH(NOLOCK)
										WHERE  VALID_YN ='Y'
										AND    ITEM_ID = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE5
										AND    BOD_ID = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE12 
										) X
								LEFT OUTER JOIN SSP_MST_SHIP_MASTER_EE TB WITH(NOLOCK)	
									ON X.DIVISION_ID = TB.DIVISION_ID
									AND TB.SCM_SITE_ID = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE3
									AND X.ITEM_ID = TB.ITEM_ID
								LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL TC WITH(NOLOCK)	
									ON TB.DIVISION_ID = TC.SEGMENT1
									AND TB.ELECTRODE_POST_OPER_CODE = TC.SEGMENT2
									AND TC.LOOKUP_TYPE = 'ELECTRODE_POST_OPER_CODE'
									AND TC.VALID_YN ='Y'
								LEFT OUTER JOIN SCM_MST_SITE TD WITH(NOLOCK)	
									ON  X.DIVISION_ID	= TD.DIVISION_ID	
									AND X.BOD_ID		= [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE12 
									AND TD.SCM_SITE_ID = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE3
								WHERE 1=1
								  AND X.FROM_YYYYMMDD <= CONVERT(CHAR(8), GETDATE(), 112)
							       AND X.TO_YYYYMMDD   >= CONVERT(CHAR(8), GETDATE(), 112)
								) T1 WHERE 1=1
								   AND (T1.ATTRIBUTE10         >= T1.CONFIRM_DAY)					
						    ) 
			 WHERE PROGRAM_ID         = @v_program_id
			   AND SHEET_NAME         = @v_sheet_name
			   AND CREATED_BY         = @p_created_by
			   AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			   AND UPLOAD_STATUS_CODE = 'UPLOAD';


			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD]
				 SET UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'Invalid Confirm Day.'
				WHERE PROGRAM_ID       = @v_program_id
				AND SHEET_NAME         = @v_sheet_name
				AND CREATED_BY         = @p_created_by
				AND CONVERT(NVARCHAR(40), CREATION_DATE, 121)  = @v_creation_date
				AND UPLOAD_STATUS_CODE = 'UPLOAD'
				AND ATTRIBUTE13 IS NULL;
			 
			SET @v_log_type = '20';
			SET @v_log_message = '########## SUCCESS. ##########';
			SET @v_description = '';
			SET @d_event_date = SYSDATETIME();

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END

		-- 정상(SUCCESS) 처리
		BEGIN
			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD]
				SET UPLOAD_STATUS_CODE = 'SUCCESS'
				WHERE PROGRAM_ID       = @v_program_id
				AND SHEET_NAME         = @v_sheet_name
				AND CREATED_BY         = @p_created_by
				AND CONVERT(NVARCHAR(40), CREATION_DATE, 121)  = @v_creation_date
				AND UPLOAD_STATUS_CODE = 'UPLOAD' ;

			SET @v_log_type = '21';
			SET @v_log_message = '########## SUCCESS ##########';
			SET @v_description = '';
			SET @d_event_date = SYSDATETIME();

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END;
	END;

	BEGIN
		SET @v_log_type = '22';
		SET @v_log_message = '########## INSERT DATA START ##########';
		SET @v_description = @p_mode; --CONVERT(CHAR(30), @v_creation_date, 121);
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	END;

	SELECT @v_count = COUNT(1)
	  FROM [dbo].[SCM_ADM_EXCEL_UPLOAD] T  WITH(NOLOCK)
	 WHERE T.PROGRAM_ID         = @v_program_id
	   AND T.SHEET_NAME         = @v_sheet_name
	   AND T.CREATED_BY         = @p_created_by
	   AND CONVERT(NVARCHAR(40), T.CREATION_DATE, 121) = @v_creation_date
	   AND T.UPLOAD_STATUS_CODE = 'ERROR' ;

	IF @p_mode > 0 AND @v_count = 0
	BEGIN
		
		BEGIN
			SET @v_log_type = '23';
			SET @v_log_message = '########## INSERT/UPDATE SSP0022 SHIPMENT REQUEST DATA START ##########';
			SET @v_description = @p_mode; --CONVERT(CHAR(30), @v_creation_date, 121);
			SET @d_event_date = SYSDATETIME();

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END;

		BEGIN TRANSACTION SSP0022_SHIPMENT_REQUEST_UPLOAD;
		BEGIN TRY
			BEGIN

			SET @v_log_type = '23-1';
			SET @v_log_message = '########## MERGE SSP0022 SHIPMENT REQUEST DATA START ##########';
			SET @v_description = @p_mode; --CONVERT(CHAR(30), @v_creation_date, 121);
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			----------------------------------------------------------------------------


				--BEGIN
				--	SELECT 
				--		 @v_active_flag	=  'I'
				--		 ,@v_division_id	=  T0.ATTRIBUTE1
				--		 ,@v_company_id	=  T0.ATTRIBUTE2
				--		 ,@v_scm_site_id	=  T0.ATTRIBUTE4
				--		 ,@v_plant_id		=  SUBSTRING(T0.ATTRIBUTE4,1,4)
				--		 ,@v_model_id		=  T0.ATTRIBUTE5
				--		 ,@v_item_id		=  T0.ATTRIBUTE5
				--		 ,@v_from_site		=  T0.ATTRIBUTE3
				--		 ,@v_to_site		=  T0.ATTRIBUTE4
				--		 ,@v_eta_date		=  T0.ATTRIBUTE10
				--		 ,@v_bod_id		=  T0.ATTRIBUTE12
				--		 ,@v_qty			=  T0.ATTRIBUTE7
				--	FROM [dbo].[SCM_ADM_EXCEL_UPLOAD] T0
				--    WHERE T0.PROGRAM_ID    = @v_program_id
				--      AND T0.SHEET_NAME    = @v_sheet_name
				--      AND T0.CREATED_BY    = @p_created_by
				--      AND CONVERT(NVARCHAR(40), T0.CREATION_DATE, 121) = @v_creation_date
				--      AND ISNULL(T0.UPLOAD_STATUS_CODE,'X') = 'SUCCESS';

				--	EXEC	[dbo].[SSP0022_SAVE_SHIPMENT_REQUEST] 
				--		 @v_active_flag
				--		 ,@v_division_id
				--		 ,@v_company_id	
				--		 ,@v_scm_site_id
				--		 ,@v_plant_id	
				--		 ,@v_model_id	
				--		 ,@v_item_id	
				--		 ,@v_from_site	
				--		 ,@v_to_site	
				--		 ,@v_eta_date	
				--		 ,@v_bod_id	
				--		 ,@v_qty		
				--		 ,@p_created_by 
				--		 ,@debug_mode 	
				--END
	

			-- 파라미터 출력 DEBUG용
			BEGIN		
				PRINT '===============================================';
				PRINT '@v_active_flag         = ''' +@v_active_flag            +'''';
				PRINT '@v_company_id          = ''' +@v_company_id             +'''';
				PRINT '@v_division_id         = ''' +@v_division_id               +'''';
				PRINT '@v_plant_id			= ''' +@v_plant_id            +'''';
				PRINT '@v_scm_site_id         = ''' +@v_scm_site_id               +'''';
				PRINT '@v_model_id            = ''' +@v_model_id                +'''';
				PRINT '@v_item_id             = ''' +@v_item_id               +'''';
				PRINT '@v_bod_id              = ''' +@v_bod_id                    +'''';
				PRINT '@v_from_site           = ''' +@v_from_site            +'''';
				PRINT '@v_to_site			= ''' +@v_to_site    +'''';
				PRINT '@v_eta_date            = ''' +@v_eta_date                +'''';
				PRINT '@v_qty				= ''' +@v_qty        +'''';
			END;

			-- 변경, 추가 대상 건 TEMP 생성
			INSERT INTO #TblDynamic_SSP0022_ShpimentReq
			SELECT 
				T0.ACTIVE_FLAG
				,MS.COMPANY_ID			AS FROM_COMPANY_ID
				,L.SEGMENT2			AS FROM_DIVISION_ID
				,MS.PLANT_ID			AS FROM_PLANT_ID
				,T0.FROM_SITE
				,T0.COMPANY_ID			AS TO_COMPANY_ID
				,T0.TO_DIVISION_ID
				,T0.PLANT_ID			AS TO_PLANT_ID
				,T0.TO_SITE
				,F.MODEL_ID
				,T0.ITEM_ID
				,T0.BOD_ID
				,T0.ETA_DATE
				,T0.ETD_DATE
				,CEILING(T0.QTY * 1)						 AS QTY
				,CEILING((T0.QTY * ISNULL(F.CONVERT_TO_PCM,  1)))  AS QTY_TO_PCM
				,CEILING((T0.QTY * ISNULL(F.CONVERT_TO_CELL, 1)))  AS QTY_TO_CELL

			FROM(

				SELECT 'I'							AS ACTIVE_FLAG
					, T.ATTRIBUTE2					     AS COMPANY_ID
					, T.ATTRIBUTE1					     AS DIVISION_ID
					, SUBSTRING(T.ATTRIBUTE4,1,4)			AS PLANT_ID
					, T.ATTRIBUTE4						AS SCM_SITE_ID
					, T.ATTRIBUTE1						AS FROM_DIVISION_ID
					, T.ATTRIBUTE3						AS FROM_SITE
					, T.ATTRIBUTE1						AS TO_DIVISION_ID
					, T.ATTRIBUTE4						AS TO_SITE	
					, F.MODEL_ID						AS MODEL_ID
					, T.ATTRIBUTE5						AS ITEM_ID
					, T.ATTRIBUTE10					AS ETA_DATE
					, dbo.FN_GET_SSP_ETD_DATE(T.ATTRIBUTE1, T.ATTRIBUTE12, T.ATTRIBUTE10) AS ETD_DATE
					, T.ATTRIBUTE12						AS BOD_ID
					, CONVERT(INT,CEILING(T.ATTRIBUTE7))				AS QTY
					FROM SCM_ADM_EXCEL_UPLOAD T WITH(NOLOCK)
					JOIN SSP_MST_SITE_ITEM_EE_V F WITH(NOLOCK) 
						ON F.DIVISION_ID   = ( SELECT DIVISION_ID  
											FROM SCM_MST_SITE WITH(NOLOCK) 
										    WHERE SCM_SITE_ID  = T.ATTRIBUTE3 -- FROM SITE
											 AND	   VALID_YN  = 'Y'
											 AND   SITE_TYPE  = 'PLANT')
						AND F.SCM_SITE_ID  =  T.ATTRIBUTE3 
						AND F.ITEM_ID      =  T.ATTRIBUTE5 
					WHERE T.PROGRAM_ID    = @v_program_id
				       AND T.SHEET_NAME    = @v_sheet_name
				       AND T.CREATED_BY    = @p_created_by
				       AND CONVERT(NVARCHAR(40), T.CREATION_DATE, 121) = @v_creation_date
				       AND ISNULL(T.UPLOAD_STATUS_CODE,'X') = 'SUCCESS'


			) T0
			LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)	
				ON L.LOOKUP_TYPE = 'ELECTRODE_SHIP_FROM_TO'
				 AND L.SEGMENT5 = T0.DIVISION_ID
				 AND L.SEGMENT3 = T0.FROM_SITE
				 AND L.ATTRIBUTE1 = T0.TO_SITE
			LEFT JOIN SCM_MST_SITE MS WITH(NOLOCK) 
				ON L.SEGMENT2 = MS.DIVISION_ID
				AND T0.FROM_SITE = MS.SCM_SITE_ID
			JOIN SSP_MST_SITE_ITEM_EE_V F WITH(NOLOCK) 
				ON L.SEGMENT2 = F.DIVISION_ID
				AND T0.FROM_SITE = F.SCM_SITE_ID
				AND T0.ITEM_ID = F.ITEM_ID   
			;



			SELECT  @v_cnt = COUNT(*)  
			FROM #TblDynamic_SSP0022_ShpimentReq

		-- 삭제기능은 없으므로 Active Flag는 'I' 또는 'M'으로 가정하고 입력/수정만 진행


			IF @v_cnt > 0 
			BEGIN
				SET @d_event_date = SYSDATETIME();

				-- 수정
				UPDATE A
				SET A.QTY = B.QTY
					, A.QTY_TO_PCM = B.QTY_TO_PCM
					, A.QTY_TO_CELL = B.QTY_TO_CELL
					, A.LAST_UPDATED_BY	= @p_created_by
					, A.LAST_UPDATE_DATE = @d_event_date
				FROM SSP_ANL_SHIP_REQ_EE A WITH(NOLOCK)
				JOIN #TblDynamic_SSP0022_ShpimentReq B WITH(NOLOCK) ON A.FROM_DIVISION_ID		= B.FROM_DIVISION_ID
															AND A.FROM_SITE		= B.FROM_SITE
															AND A.FROM_PLANT_ID		= B.FROM_PLANT_ID
															AND A.TO_SITE			= B.TO_SITE
															AND A.MODEL_ID			= B.MODEL_ID
															AND A.ITEM_ID			= B.ITEM_ID
															AND A.ETA_DATE			= B.ETA_DATE
															AND A.BOD_ID			= B.BOD_ID

				;

				SET @v_cnt = 0;  -- 저장 후 초기화
			END
			-- UPDATE END

			-- INSERT START
			SELECT @v_cnt = COUNT(*)
			FROM #TblDynamic_SSP0022_ShpimentReq B WITH(NOLOCK)
			WHERE 1=1
			AND NOT EXISTS (SELECT 1 
							FROM SSP_ANL_SHIP_REQ_EE A WITH(NOLOCK)
							WHERE 1=1
							AND A.FROM_DIVISION_ID	= B.FROM_DIVISION_ID
							AND A.FROM_SITE		= B.FROM_SITE
							AND A.FROM_PLANT_ID		= B.FROM_PLANT_ID
							AND A.TO_SITE			= B.TO_SITE
							AND A.MODEL_ID			= B.MODEL_ID
							AND A.ITEM_ID			= B.ITEM_ID
							AND A.ETA_DATE			= B.ETA_DATE
							AND A.BOD_ID			= B.BOD_ID	)
	
     		IF @v_cnt > 0
			BEGIN
			
				-- INSERT 대상 건 ACTIVE FLAG 변경
				UPDATE  A
				SET A.ACTIVE_FLAG = 'I'
				FROM #TblDynamic_SSP0022_ShpimentReq A
				WHERE  NOT EXISTS (SELECT 1 
								FROM SSP_ANL_SHIP_REQ_EE B WITH(NOLOCK)
								WHERE 1=1
								AND A.FROM_DIVISION_ID	= B.FROM_DIVISION_ID
								AND A.FROM_SITE		= B.FROM_SITE
								AND A.FROM_PLANT_ID		= B.FROM_PLANT_ID
								AND A.TO_SITE			= B.TO_SITE
								AND A.MODEL_ID			= B.MODEL_ID
								AND A.ITEM_ID			= B.ITEM_ID
								AND A.ETA_DATE			= B.ETA_DATE
								AND A.BOD_ID			= B.BOD_ID)
				;


				-- 신규 REQEUST INSERT
				INSERT INTO SSP_ANL_SHIP_REQ_EE
				(
					 FROM_COMPANY_ID
					,FROM_DIVISION_ID
					,FROM_PLANT_ID
					,FROM_SITE
					,TO_COMPANY_ID
					,TO_DIVISION_ID
					,TO_PLANT_ID
					,TO_SITE
					,MODEL_ID
					,ITEM_ID
					,BOD_ID
					,ETD_DATE
					,ETA_DATE
					,QTY
					,QTY_TO_PCM
					,QTY_TO_CELL
					,SCP_PLAN_START_YYYYMMDD
					,SCP_PLAN_TYPE
					,SCP_PLAN_SEQ
					,REQUEST_ID
					,CONFIRM_ID
					,CONFIRM_FLAG
					,CREATED_BY
					,CREATION_DATE
					,LAST_UPDATED_BY
					,LAST_UPDATE_DATE
				)
				SELECT 
					 B.FROM_COMPANY_ID
					,B.FROM_DIVISION_ID
					,B.FROM_PLANT_ID
					,B.FROM_SITE
					,B.TO_COMPANY_ID
					,B.TO_DIVISION_ID
					,B.TO_PLANT_ID
					,B.TO_SITE
					,B.MODEL_ID
					,B.ITEM_ID
					,B.BOD_ID
					, dbo.FN_GET_SSP_ETD_DATE(B.TO_DIVISION_ID, B.BOD_ID, B.ETA_DATE) AS ETD_DATE
					,B.ETA_DATE
					,B.QTY
					,B.QTY_TO_PCM AS QTY_TO_PCM
					,B.QTY_TO_CELL AS QTY_TO_CELL
					, NULL				AS SCP_PLAN_START_YYYYMMDD
					, NULL				AS SCP_PLAN_TYPE
					, NULL				AS SCP_PLAN_SEQ
					, ('R'+ CONVERT(VARCHAR(8), GETDATE(), 112) + RIGHT('000000' + CONVERT(NVARCHAR, NEXT VALUE FOR SEQ1_SSP_ANL_SHIP_REQ_EE_ID),6)) AS REQUEST_ID
					, NULL				AS CONFIRM_ID
					, 'N'				AS CONFIRM_FLAG
					, @p_created_by		AS CREATED_BY
					, @d_event_date		AS CREATION_DATE
					, @p_created_by		AS LAST_UPDATED_BY
					, @d_event_date		AS LAST_UPDATE_DATE
				FROM #TblDynamic_SSP0022_ShpimentReq B WITH(NOLOCK)
				WHERE 1=1
				AND NOT EXISTS (SELECT 1 
								FROM SSP_ANL_SHIP_REQ_EE A WITH(NOLOCK)
								WHERE 1=1
								AND A.FROM_DIVISION_ID	= B.FROM_DIVISION_ID
								AND A.FROM_SITE		= B.FROM_SITE
								AND A.FROM_PLANT_ID		= B.FROM_PLANT_ID
								AND A.TO_SITE			= B.TO_SITE
								AND A.MODEL_ID			= B.MODEL_ID
								AND A.ITEM_ID			= B.ITEM_ID
								AND A.ETA_DATE			= B.ETA_DATE
								AND A.BOD_ID			= B.BOD_ID)
				;

				SET @v_cnt = 0;  -- 저장 후 초기화
			END

			-- HISTORY 대상 건 TEMP 생성
			SELECT    NEXT VALUE FOR  SEQ1_SSP_ANL_SHIP_REQ_EE_H AS HISTORY_SEQ
					,B.ACTIVE_FLAG
					,A.FROM_COMPANY_ID
					,A.FROM_DIVISION_ID
					,A.FROM_PLANT_ID
					,A.FROM_SITE
					,A.TO_COMPANY_ID
					,A.TO_DIVISION_ID
					,A.TO_PLANT_ID
					,A.TO_SITE
					,A.MODEL_ID
					,A.ITEM_ID
					,A.BOD_ID	
					,A.ETD_DATE
					,A.ETA_DATE
					,A.QTY
					,A.QTY_TO_PCM
					,A.QTY_TO_CELL
					,A.SCP_PLAN_START_YYYYMMDD
					,A.SCP_PLAN_TYPE
					,A.SCP_PLAN_SEQ
					,A.REQUEST_ID
					,A.CONFIRM_ID
					,A.CONFIRM_FLAG
					,A.CREATED_BY
					,A.CREATION_DATE
					,A.LAST_UPDATED_BY
					,A.LAST_UPDATE_DATE 
					,GETDATE() AS HISTORY_CREATION_DATE
			INTO #TblDynamic_SSP0022_ShpimentReq_H
			FROM SSP_ANL_SHIP_REQ_EE A WITH(NOLOCK) 
			JOIN #TblDynamic_SSP0022_ShpimentReq B WITH(NOLOCK)
			ON A.FROM_DIVISION_ID	= B.FROM_DIVISION_ID
				AND A.FROM_SITE		= B.FROM_SITE
				AND A.FROM_PLANT_ID		= B.FROM_PLANT_ID
				AND A.TO_SITE			= B.TO_SITE
				AND A.MODEL_ID			= B.MODEL_ID
				AND A.ITEM_ID			= B.ITEM_ID
				AND A.ETA_DATE			= B.ETA_DATE
				AND A.BOD_ID			= B.BOD_ID
     	


			-- HISTORY 입력
			INSERT INTO SSP_ANL_SHIP_REQ_EE_H (
					HISTORY_SEQ
					,TRANS_TYPE
					,FROM_COMPANY_ID
					,FROM_DIVISION_ID
					,FROM_PLANT_ID
					,FROM_SITE
					,TO_COMPANY_ID
					,TO_DIVISION_ID
					,TO_PLANT_ID
					,TO_SITE
					,MODEL_ID
					,ITEM_ID
					,BOD_ID
					,ETD_DATE
					,ETA_DATE
					,QTY
					,QTY_TO_PCM
					,QTY_TO_CELL
					,SCP_PLAN_START_YYYYMMDD
					,SCP_PLAN_TYPE
					,SCP_PLAN_SEQ
					,REQUEST_ID
					,CONFIRM_ID
					,CONFIRM_FLAG
					,CREATED_BY
					,CREATION_DATE
					,LAST_UPDATED_BY
					,LAST_UPDATE_DATE 
					,HISTORY_CREATION_DATE
					) 
			SELECT     T.HISTORY_SEQ
					,T.ACTIVE_FLAG
					,T.FROM_COMPANY_ID
					,T.FROM_DIVISION_ID
					,T.FROM_PLANT_ID
					,T.FROM_SITE
					,T.TO_COMPANY_ID
					,T.TO_DIVISION_ID
					,T.TO_PLANT_ID
					,T.TO_SITE
					,T.MODEL_ID
					,T.ITEM_ID
					,T.BOD_ID
					,T.ETD_DATE
					,T.ETA_DATE
					,ROUND(T.QTY, 0)  AS QTY
					,ROUND(T.QTY_TO_PCM, 0)  AS QTY_TO_PCM
					,ROUND(T.QTY_TO_CELL, 0)  AS QTY_TO_CELL
					,T.SCP_PLAN_START_YYYYMMDD
					,T.SCP_PLAN_TYPE
					,T.SCP_PLAN_SEQ
					,T.REQUEST_ID             
					,T.CONFIRM_ID             
					,T.CONFIRM_FLAG             
					,T.CREATED_BY             
					,T.CREATION_DATE             
					,T.LAST_UPDATED_BY             
					,T.LAST_UPDATE_DATE 
					,T.HISTORY_CREATION_DATE					
			FROM #TblDynamic_SSP0022_ShpimentReq_H T WITH(NOLOCK) 
			;

			--SELECT 'S' AS RESULT_CODE, '' AS MSG

			SET @v_log_type = 'END';
			SET @v_log_message = '########## END of procedure ##########';
			SET @v_description = '';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


			SET @v_log_type = '23-1';
			SET @v_log_message = '########## MERGE SSP0022 SHIPMENT REQUEST DATA END ##########';
			SET @v_description = @p_mode; --CONVERT(CHAR(30), @v_creation_date, 121);
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			----------------------------------------------------------------------------
			END;

			COMMIT WORK;

		END TRY
		BEGIN CATCH
			BEGIN
				ROLLBACK TRANSACTION SSP0022_SHIPMENT_REQUEST_UPLOAD;
						
				INSERT INTO scm_sys_log_batch (program_name,log_type,log_count,log_message,description,event_date,creation_date,created_by,last_update_date,last_updated_by)
				VALUES (ERROR_PROCEDURE(),'ERROR',NULL,ERROR_MESSAGE(),NULL,SYSDATETIME(),SYSDATETIME(),ERROR_PROCEDURE(),SYSDATETIME(),ERROR_PROCEDURE());
			END;
		END CATCH
				
		BEGIN
			SET @v_log_type = '24';
			SET @v_log_message = '########## INSERT/UPDATE SP0022 SHIPMENT PLAN DATA END ##########';
			SET @v_description = @p_mode; --CONVERT(CHAR(30), @v_creation_date, 121);
			SET @d_event_date = SYSDATETIME();
			
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END;

	END;

	BEGIN
		SET @v_log_type = '25';
		SET @v_log_message = '########## INSERT DATA END ##########';
		SET @v_description = @p_mode; --CONVERT(CHAR(30), @v_creation_date, 121);
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	END;

	--* 2020.10.21  KIMYONGHO			LOG 이력 START - END 짝이 안맞아서 표준 변경 작업
	BEGIN
		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	END;


	IF OBJECT_ID('tempdb..#TblDynamic_SSP0022_ShpimentReq') IS NOT NULL
		DROP TABLE #TblDynamic_SSP0022_ShpimentReq;    

	IF OBJECT_ID('tempdb..#TblDynamic_SSP0022_ShpimentReq_H') IS NOT NULL
		DROP TABLE #TblDynamic_SSP0022_ShpimentReq_H;    

END;
