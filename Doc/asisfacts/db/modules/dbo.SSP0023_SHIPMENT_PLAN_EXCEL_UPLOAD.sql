
/*
 * Program ID   : SSP0023_SHIPMENT_PLAN_EXCEL_UPLOAD
 * Description  : SSP0023_SHIPMENT_PLAN_EXCEL_UPLOAD
 * Program History
 *===========================================================================================================
 *   Date       In Charge		Description
 *===========================================================================================================
 * 2020.07.08	khj79			[PJ20199555] 공급 대응력 향상을 위한 자재재공 수급 점검 체계 개선 - 최초작성
 * 2020.10.21  KIMYONGHO			LOG 이력 START - END 짝이 안맞아서 표준 변경 작업
 * EX > Div*	Company*	FromSite*	Material*	yyyyMMdd*	Qty*
 */
 

 CREATE PROCEDURE [dbo].[SSP0023_SHIPMENT_PLAN_EXCEL_UPLOAD]
	@p_mode		   INT,
	@p_created_by  NVARCHAR(150)
AS

BEGIN
    SET NOCOUNT ON;

    DECLARE @v_program_id     AS NVARCHAR(40) = 'SSP0023';
    DECLARE @v_sheet_name     AS NVARCHAR(40) = 'Shipment Plan(Electrode)';	
	DECLARE @v_sql_text       AS NVARCHAR(MAX);
	DECLARE @v_creation_date  AS NVARCHAR(40);
	DECLARE @v_count          AS INT;
	DECLARE @v_start_yyyymmdd AS NVARCHAR(8);
	DECLARE @v_end_yyyymmdd   AS NVARCHAR(8);

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SSP0023_SHIPMENT_PLAN_EXCEL_UPLOAD';
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
									 AND S.DIVISION_ID = [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE1 -- DIVISION
									 AND S.COMPANY_ID  = [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE2 -- COMPANY
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
									 AND S.DIVISION_ID = [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE1 -- DIVISION
									 AND S.COMPANY_ID  = [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE2 -- COMPANY
									 AND S.SCM_SITE_ID = [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE3 -- FROM SITE
									)	 ;

			SET @v_log_type = '7';
			SET @v_log_message = '########## Invalid From site ##########';
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
			   AND (ISNULL(ATTRIBUTE5,'')='' OR len(substring(replace(replace(ISNULL(ATTRIBUTE5,''),' ',''),'-',''),1,8))!=8) -- YYYYMMDD

			-- 날짜 변환
			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD]
			   SET ATTRIBUTE8 = substring(replace(replace(ISNULL(ATTRIBUTE5,''),' ',''),'-',''),1,8)
			 WHERE PROGRAM_ID         = @v_program_id
			   AND SHEET_NAME         = @v_sheet_name
			   AND CREATED_BY         = @p_created_by
			   AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			   AND UPLOAD_STATUS_CODE = 'UPLOAD'

			SET @v_log_type = '9';
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
			   AND (ATTRIBUTE5         > ( SELECT MAX(CONVERT(NVARCHAR(8), DATEADD(DD, 55, CONVERT(NVARCHAR(10),CONVERT(DATE, PLAN_START_YYYYMMDD, 23))),112))
											 FROM SSP_MST_SHIP_PLAN_SCHEDULE_EE WITH(NOLOCK)
											WHERE PLAN_CUTOFF_CREATE_YN = 'N'
											  AND CURRENT_PLAN_DATE_YN  = 'Y'
											  AND COMPANY_ID            = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE2) -- COMPANY
			         OR ATTRIBUTE5    < ( SELECT MAX(PLAN_START_YYYYMMDD)
											 FROM SSP_MST_SHIP_PLAN_SCHEDULE_EE WITH(NOLOCK)
											WHERE PLAN_CUTOFF_CREATE_YN = 'N'
											  AND CURRENT_PLAN_DATE_YN  = 'Y'
											  AND COMPANY_ID            = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE2) -- COMPANY
					)

			SET @v_log_type = '11';
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
										 , ATTRIBUTE4	AS ITEM_ID
										 , ATTRIBUTE5	AS YYYYMMDD
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
									HAVING COUNT(1) > 1  ) T
							WHERE 1 = 1
	 						  AND T.DIVISION_ID = ATTRIBUTE1
							  AND T.COMPANY_ID  = ATTRIBUTE2
							  AND T.FROM_SITE   = ATTRIBUTE3
							  AND T.ITEM_ID     = ATTRIBUTE4
							  AND T.YYYYMMDD    = ATTRIBUTE5
						) ;

			SET @v_log_type = '12';
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
			   AND (CHARINDEX('.', ATTRIBUTE6) > 0 OR CONVERT(INT, ATTRIBUTE6) < 0 );

			SET @v_log_type = '13';
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
								 WHERE [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE1 = IV.DIVISION_ID
								   AND [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE2 = IV.COMPANY_ID
								   AND [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE3 = IV.SCM_SITE_ID
								   AND [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE4 = IV.ITEM_ID
								) ;

			SET @v_log_type = '14';
			SET @v_log_message = '########## ERROR Invalid item Data ##########';
			SET @v_description = '';
			SET @d_event_date = SYSDATETIME();
				
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END;

		-- 정상(SUCCESS) 처리
		BEGIN
			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD]
				SET UPLOAD_STATUS_CODE = 'SUCCESS'
				WHERE PROGRAM_ID       = @v_program_id
				AND SHEET_NAME         = @v_sheet_name
				AND CREATED_BY         = @p_created_by
				AND CONVERT(NVARCHAR(40), CREATION_DATE, 121)  = @v_creation_date
				AND UPLOAD_STATUS_CODE = 'UPLOAD' ;

			SET @v_log_type = '15';
			SET @v_log_message = '########## SUCCESS ##########';
			SET @v_description = '';
			SET @d_event_date = SYSDATETIME();

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END;
	END;

	BEGIN
		SET @v_log_type = '16';
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
			SET @v_log_type = '17';
			SET @v_log_message = '########## INSERT/UPDATE SSP0023 SHIPMENT PLAN DATA START ##########';
			SET @v_description = @p_mode; --CONVERT(CHAR(30), @v_creation_date, 121);
			SET @d_event_date = SYSDATETIME();

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END;

		BEGIN TRANSACTION SSP0023_SHIPMENT_PLAN_UPLOAD;
		BEGIN TRY
			BEGIN

			SET @v_log_type = '17-1';
			SET @v_log_message = '########## MERGE SSP0023 SHIPMENT PLAN DATA START ##########';
			SET @v_description = @p_mode; --CONVERT(CHAR(30), @v_creation_date, 121);
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			----------------------------------------------------------------------------
			
			BEGIN

					INSERT	INTO SSP_ANL_SHIP_PLAN_SIMU_EE (
							  SEQ        , COMPANY_ID         , DIVISION_ID    , PLANT_ID        , SCM_SITE_ID
							, MODEL_ID   , ITEM_ID            , NPC_ITEM_ID    , YYYYMMDD
							, QTY
							, QTY_TO_CELL
							, PLAN_START_YYYYMMDD
							, CREATED_BY , CREATION_DATE      , LAST_UPDATED_BY, LAST_UPDATE_DATE
						)
					SELECT NEXT VALUE FOR SEQ1_SSP_ANL_SHIP_PLAN_SIMU_EE, E.COMPANY_ID, E.DIVISION_ID		, E.PLANT_ID, E.SCM_SITE_ID
							, E.MODEL_ID								, E.ITEM_ID   , E.NPC_ITEM_ID		, E.YYYYMMDD
							, T.ATTRIBUTE6
							, ISNULL(T.ATTRIBUTE6 * ISNULL(IV.CONVERT_TO_CELL,1),0)
							, PLAN_START_YYYYMMDD
							, T.CREATED_BY, SYSDATETIME()      , T.LAST_UPDATED_BY, SYSDATETIME()
					 FROM SSP_ANL_SHIP_PLAN_EE E WITH(NOLOCK)

					INNER JOIN SCM_ADM_EXCEL_UPLOAD T WITH(NOLOCK)
					   ON E.DIVISION_ID			= T.ATTRIBUTE1
					  AND E.COMPANY_ID			= T.ATTRIBUTE2
					  AND E.SCM_SITE_ID			= T.ATTRIBUTE3
					  AND E.ITEM_ID				= T.ATTRIBUTE4
					  AND E.YYYYMMDD			= T.ATTRIBUTE5

					 LEFT JOIN SSP_MST_SITE_ITEM_EE_V IV WITH(NOLOCK)
					   ON E.DIVISION_ID	= IV.DIVISION_ID
					  AND E.SCM_SITE_ID	= IV.SCM_SITE_ID
					  AND E.ITEM_ID		= IV.ITEM_ID
					
					WHERE 1 = 1
					  AND E.MEASURE_TYPE = 'P'
					  AND E.MEASURE = 'P_SHIP_PLAN_SIMU_ETD'
					  AND T.PROGRAM_ID	= @v_program_id
					  AND T.SHEET_NAME	= @v_sheet_name
					  AND T.CREATED_BY	= @p_created_by
					  AND CONVERT(NVARCHAR(40), T.CREATION_DATE, 121) = @v_creation_date
					  AND T.UPLOAD_STATUS_CODE = 'SUCCESS'
					  AND E.PLAN_START_YYYYMMDD = (SELECT MAX(PLAN_START_YYYYMMDD)
													 FROM SSP_MST_SHIP_PLAN_SCHEDULE_EE 
													WHERE PLAN_CUTOFF_CREATE_YN = 'N'
													  AND CURRENT_PLAN_DATE_YN  = 'Y'
													  AND COMPANY_ID            = T.ATTRIBUTE2 -- COMPANY
												) ;

					MERGE INTO SSP_ANL_SHIP_PLAN_EE A
					USING (
							SELECT 
								   T.ATTRIBUTE1				AS DIVISION_ID
								 , UPPER(T.ATTRIBUTE2)		AS COMPANY_ID
								 , UPPER(T.ATTRIBUTE3)		AS SCM_SITE_ID
								 , UPPER(T.ATTRIBUTE4)		AS ITEM_ID
								 , T.ATTRIBUTE5				AS YYYYMMDD
								 , T.ATTRIBUTE6				AS QTY
								 , 'P'						AS MEASURE_TYPE
								 , 'P_SHIP_PLAN_SIMU_ETD'	AS MEASURE
								 , T.CREATED_BY				AS CREATED_BY
								 , IV.PLANT_ID				AS PLANT_ID
								 , IV.MODEL_ID				AS MODEL_ID
								 , IV.ELECTRODE_TYPE		AS ELECTRODE_TYPE
								 , ISNULL(T.ATTRIBUTE6 * ISNULL(IV.CONVERT_TO_PCM ,1),0) AS QTY_TO_PCM
								 , ISNULL(T.ATTRIBUTE6 * ISNULL(IV.CONVERT_TO_CELL,1),0) AS QTY_TO_CELL
								 , ( SELECT MAX(PLAN_START_YYYYMMDD)
									   FROM SSP_MST_SHIP_PLAN_SCHEDULE_EE 
									  WHERE PLAN_CUTOFF_CREATE_YN = 'N'
										AND CURRENT_PLAN_DATE_YN  = 'Y'
										AND COMPANY_ID            = T.ATTRIBUTE2 -- COMPANY
									)													AS PLAN_START_YYYYMMDD
							  FROM SCM_ADM_EXCEL_UPLOAD T WITH(NOLOCK)

							  LEFT JOIN SSP_MST_SITE_ITEM_EE_V IV WITH(NOLOCK)
								ON T.ATTRIBUTE1	= IV.DIVISION_ID
							   AND T.ATTRIBUTE3	= IV.SCM_SITE_ID
							   AND T.ATTRIBUTE4	= IV.ITEM_ID

							 WHERE T.PROGRAM_ID	= @v_program_id
							   AND T.SHEET_NAME	= @v_sheet_name
							   AND T.CREATED_BY	= @p_created_by
							   AND CONVERT(NVARCHAR(40), T.CREATION_DATE, 121) = @v_creation_date
							   AND T.UPLOAD_STATUS_CODE = 'SUCCESS'

							) B
					ON(
								A.PLAN_START_YYYYMMDD = B.PLAN_START_YYYYMMDD
							AND A.COMPANY_ID          = B.COMPANY_ID
							AND A.DIVISION_ID         = B.DIVISION_ID
							AND A.PLANT_ID            = B.PLANT_ID
							AND A.SCM_SITE_ID         = B.SCM_SITE_ID
							AND A.MODEL_ID            = B.MODEL_ID
							AND A.ITEM_ID             = B.ITEM_ID
							AND A.MEASURE             = B.MEASURE
							AND A.YYYYMMDD            = B.YYYYMMDD
						)
					WHEN MATCHED THEN
							UPDATE SET 
								QTY				= B.QTY
							  , QTY_TO_PCM		= B.QTY_TO_CELL
							  , QTY_TO_CELL		= B.QTY_TO_PCM
							  , LAST_UPDATED_BY	= B.CREATED_BY
							  , LAST_UPDATE_DATE= sysdatetime()
					                
					WHEN NOT MATCHED THEN
					INSERT	(	
								PLAN_START_YYYYMMDD, COMPANY_ID    , DIVISION_ID    , PLANT_ID        , SCM_SITE_ID
							  , MODEL_ID           , ITEM_ID       , NPC_ITEM_ID    , MEASURE_TYPE    , MEASURE
							  , YYYYMMDD           , QTY           , QTY_TO_PCM     , QTY_TO_CELL     , FROM_DIVISION_ID
							  , FROM_SITE          , TO_DIVISION_ID, TO_SITE        , BOD_ID          , ELECTRODE_TYPE
							  , ETD_DATE           , ETA_DATE
							  , CREATED_BY         , CREATION_DATE , LAST_UPDATED_BY, LAST_UPDATE_DATE
							)
					VALUES  (
					 			B.PLAN_START_YYYYMMDD, B.COMPANY_ID, B.DIVISION_ID , B.PLANT_ID     , B.SCM_SITE_ID
							  , B.MODEL_ID           , B.ITEM_ID   , NULL           ,B.MEASURE_TYPE , B.MEASURE
							  , B.YYYYMMDD           , B.QTY       ,  B.QTY_TO_PCM , B.QTY_TO_CELL, '-'
							  , '-'                   , '-'          , '-'            , '-'           , B.ELECTRODE_TYPE
							  , '-'                   , '-'
							  , B.CREATED_BY        , SYSDATETIME()       , B.CREATED_BY , SYSDATETIME()
							)
					;
				END

				SET @v_log_type = '17-2';
				SET @v_log_message = '########## MERGE SSP0023 SHIPMENT PLAN DATA END ##########';
				SET @v_description = @p_mode; --CONVERT(CHAR(30), @v_creation_date, 121);
				SET @d_event_date = SYSDATETIME();
				EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			----------------------------------------------------------------------------
			END;

			COMMIT WORK;

		END TRY
		BEGIN CATCH
			BEGIN
				ROLLBACK TRANSACTION SSP0023_SHIPMENT_PLAN_UPLOAD;
						
				INSERT INTO scm_sys_log_batch (program_name,log_type,log_count,log_message,description,event_date,creation_date,created_by,last_update_date,last_updated_by)
				VALUES (ERROR_PROCEDURE(),'ERROR',NULL,ERROR_MESSAGE(),NULL,SYSDATETIME(),SYSDATETIME(),ERROR_PROCEDURE(),SYSDATETIME(),ERROR_PROCEDURE());
			END;
		END CATCH
				
		BEGIN
			SET @v_log_type = '18';
			SET @v_log_message = '########## INSERT/UPDATE SP0023 SHIPMENT PLAN DATA END ##########';
			SET @v_description = @p_mode; --CONVERT(CHAR(30), @v_creation_date, 121);
			SET @d_event_date = SYSDATETIME();
			
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END;

	END;

	BEGIN
		SET @v_log_type = '19';
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
END;
