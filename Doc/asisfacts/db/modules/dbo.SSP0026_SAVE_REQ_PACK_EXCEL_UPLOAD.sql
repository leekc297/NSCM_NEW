

/*
 * Program ID   : SSP0026_SAVE_REQ_PACK_EXCEL_UPLOAD
 * Description  : SSP0026_SAVE_REQ_PACK_EXCEL_UPLOAD
 * Program History
 *===========================================================================================================
 *   Date       In Charge		Description
 *===========================================================================================================
 * 2020.10.07	 KIMYONGHO		최초작성
 * 2020/10/21   KIMYONGHO	    LOG 이력  START - END 짝이 안맞아서 GSCM 표준에 맞게 수정 . 
 * 2021/09/02   KIMYONGHO       SCP_MST_BOD_v -> SCP_MST_BOD_N_V 변경
 * 2021/11/03   SHINMYUNGSU     XIF_SCS_PACK_SHIP_PLAN_S 입력값수정, SSP_ANL_SHIP_PLAN_PACK_REQ_H -> SSP_ANL_SHIP_REQ_P_H 변경
 * 2022/01/04    KIMYONGHO		ITEM 코드 11자리까지 동일하면 유효한 BOD ITEM
 * 2024/10/01   KHJ             NERP_SSP
 *
 */
 
CREATE PROCEDURE [dbo].[SSP0026_SAVE_REQ_PACK_EXCEL_UPLOAD]
	@p_mode		   INT,
	@p_created_by  NVARCHAR(150)
AS

BEGIN
	SET NOCOUNT ON;

	/********************************************************************************      
	* 임시테이블만들기
	********************************************************************************/ 
	IF OBJECT_ID('tempdb..#TblDynamic_SSP0026_ShpimentReq') IS NOT NULL
		DROP TABLE #TblDynamic_SSP0026_ShpimentReq;    


	CREATE TABLE #TblDynamic_SSP0026_ShpimentReq (
		ACTIVE_FLAG					NVARCHAR(1)
		,DIVISION_ID				NVARCHAR(30)
		,FROM_SITE					NVARCHAR(50)
		,TO_SITE					NVARCHAR(50)
		,SHIPTO_CODE				NVARCHAR(30)
		,ITEM_ID					NVARCHAR(50)
		,INCOTERMS					NVARCHAR(10)
		,TRANSPORT_MODE				NVARCHAR(10)
		,FCST_TYPE					NVARCHAR(10)
		,BOD_ID						NVARCHAR(150)
		,YYYYMMDD					NVARCHAR(8)
		,QTY						NVARCHAR(30)
		,REQUEST_ID					NVARCHAR(30)
--		,ORDER_TYPE_DETAIL      NVARCHAR(50)
	);

     DECLARE @v_program_id     AS NVARCHAR(40) = 'SSP0026';
     DECLARE @v_sheet_name     AS NVARCHAR(40) = 'Shipment Request(IT & Mobile)';	
	DECLARE @v_sql_text       AS NVARCHAR(MAX);
	DECLARE @v_creation_date  AS NVARCHAR(40);
	DECLARE @v_count          AS INT;
	DECLARE @v_start_yyyymmdd AS NVARCHAR(8);
	DECLARE @v_end_yyyymmdd   AS NVARCHAR(8);

	DECLARE @v_plant_start_yyyymmdd   AS NVARCHAR(8);


	DECLARE @v_cnt				INT;


	DECLARE @v_active_flag		NVARCHAR(MAX)  = 'M';
	DECLARE @v_division_id		NVARCHAR(MAX)	= '40';
	DECLARE @v_scm_site_id		NVARCHAR(MAX)  = NULL;
	DECLARE @v_model_id			NVARCHAR(MAX)	= NULL;
	DECLARE @v_from_site		NVARCHAR(MAX)	= NULL;
	DECLARE @v_to_site			NVARCHAR(MAX)	= NULL;
	DECLARE @v_yyyymmdd			NVARCHAR(MAX)	= NULL;
	DECLARE @v_bod_id			NVARCHAR(MAX)	= NULL;
	DECLARE @v_qty				NVARCHAR(MAX)	= NULL;
	DECLARE @v_created_by		NVARCHAR(300)  = @p_created_by;
	DECLARE @debug_mode			NVARCHAR(1)	= 'F';
--	DECLARE @v_order_type_detail	NVARCHAR(50) = NULL;

	DECLARE @v_req_id_seq		NVARCHAR(60);

	SET @v_req_id_seq = NULL;


	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SSP0026_SAVE_REQ_PACK_EXCEL_UPLOAD';
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


	DECLARE @v_plan_start_date		 [NVARCHAR](8);
	DECLARE @v_plan_end_date			 [NVARCHAR](8);
	DECLARE @v_cutoff_date		      [NVARCHAR](8);
	DECLARE @v_cutoff_end_date		      [NVARCHAR](8);
	DECLARE @v_plan_start_yyyymmdd   [NVARCHAR](8);
	DECLARE @IF_GROUP_NO             [NVARCHAR](50)   = FORMAT(CURRENT_TIMESTAMP, 'yyyyMMddHHmmss');

	SET @v_plan_start_yyyymmdd = CONVERT(CHAR(8), GETDATE(), 112);
	SET @v_plan_start_date = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112);

	SELECT @v_plan_end_date = BASIS_END_DATE
	FROM   SCM_SYS_CALENDAR_M WITH(NOLOCK)
	WHERE  BASIS_YYYYMMDD = CONVERT(VARCHAR, DATEADD(D, 64, CONVERT(DATETIME, @v_plan_start_date ,112)) ,112)
	
	SET @v_cutoff_date = CONVERT(VARCHAR, DATEADD(D, -1, CONVERT(DATETIME, @v_plan_start_date ,112)) ,112)
	SET @v_cutoff_end_date = CONVERT(CHAR(8), GETDATE()-1, 112);
	

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
									 AND S.DIVISION_ID = ( SELECT DIVISION_ID  
														FROM SCM_MST_SITE WITH(NOLOCK)
													    WHERE DIVISION_ID   = [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE1 -- DIVISION_ID
													      AND  SCM_SITE_ID  = [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE2 -- FROM SITE
														 AND	   VALID_YN  = 'Y'
														 AND   SITE_TYPE  = 'PLANT')
									 AND S.SCM_SITE_ID = [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE2  -- FROM SITE
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
									 AND S.SITE_TYPE = 'SALES'
									 AND S.DIVISION_ID = ( SELECT DIVISION_ID  
														FROM SCM_MST_SITE WITH(NOLOCK) 
													    WHERE DIVISION_ID   = [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE1 -- DIVISION_ID
													      AND  SCM_SITE_ID  = [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE3 -- TO SITE
														 AND	   VALID_YN  = 'Y'
														 AND   SITE_TYPE  = 'SALES')
									 AND S.SCM_SITE_ID = [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE3 -- TO SITE
									)	 ;

			SET @v_log_type = '8';
			SET @v_log_message = '########## Invalid To site ##########';
			SET @v_description = '';
			SET @d_event_date = SYSDATETIME();

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END;

		-- Shipto Code 체크
		BEGIN
			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
			   SET UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'Invalid ShipTo Code.'
			 WHERE PROGRAM_ID         = @v_program_id
			   AND SHEET_NAME         = @v_sheet_name
			   AND CREATED_BY         = @p_created_by
			   AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			   AND UPLOAD_STATUS_CODE = 'UPLOAD'
			   AND NOT EXISTS  (  SELECT 1
									FROM SCM_MST_SITE_CUSTOMER S WITH(NOLOCK)
								   WHERE 1 = 1
									 AND S.DIVISION_ID = ( SELECT DIVISION_ID  
														FROM SCM_MST_SITE WITH(NOLOCK) 
													    WHERE DIVISION_ID   = [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE1 -- DIVISION_ID
														 AND SCM_SITE_ID  = [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE3 -- TO SITE
														 AND	   VALID_YN  = 'Y'
														 AND   SITE_TYPE  = 'SALES')
									 AND S.SCM_SITE_ID = [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE3 -- TO SITE
									 AND S.SHIPTO_CODE = [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE4 -- SHIPTO_CODE
									)	 ;

			SET @v_log_type = '8';
			SET @v_log_message = '########## Invalid ShipTo Code. ##########';
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
			   SET ATTRIBUTE11 = substring(replace(replace(ISNULL(ATTRIBUTE6,''),' ',''),'-',''),1,8)
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
			   AND NOT EXISTS  ( SELECT 1
							   FROM SCP_MST_BOD_N_V S WITH(NOLOCK)
							  WHERE 1 = 1
							    AND S.DIVISION_ID =  ( SELECT DIVISION_ID  
												    FROM SCM_MST_SITE WITH(NOLOCK) 
											        WHERE DIVISION_ID   = [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE1 -- DIVISION_ID
												     AND SCM_SITE_ID  = [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE2 -- FROM SITE
												     AND	  VALID_YN  = 'Y'
												     AND   SITE_TYPE  = 'PLANT')
							    AND S.FROM_SITE = [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE2 -- FROM SITE
							    AND S.TO_SITE	= [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE3 -- TO SITE
							    AND S.TRANSPORT_MODE = [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE8 -- TRANS MODE
							    AND S.SSP_INCOTERMS = [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE9 -- INCOTERMS
								AND S.FROM_YYYYMMDD <= [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE11
								AND S.TO_YYYYMMDD >= [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE11
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
			   AND NOT EXISTS  ( SELECT 1
							   FROM SCP_MST_BOD_N_V S WITH(NOLOCK)
							  WHERE 1 = 1
							    AND S.DIVISION_ID =  ( SELECT DIVISION_ID  
												    FROM SCM_MST_SITE WITH(NOLOCK)
												   WHERE DIVISION_ID   = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE1 -- DIVISION_ID
											          AND SCM_SITE_ID  = [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE2 -- FROM SITE
												     AND	  VALID_YN  = 'Y'
												     AND   SITE_TYPE  = 'PLANT')
							    AND S.FROM_SITE = [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE2 -- FROM SITE
						        AND S.TO_SITE	= [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE3 -- TO SITE
							    -- 2020.09.21	 KIMYONGHO		SSP INCOTERMS 변경작업
						         --AND S.INCOTERMS = [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE9 -- INCOTERMS
								AND S.TRANSPORT_MODE = [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE8 -- TRANS MODE
							    AND S.SSP_INCOTERMS = [SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE9 -- INCOTERMS
								AND S.FROM_YYYYMMDD <= [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE11
								AND S.TO_YYYYMMDD >= [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE11
						    ) ;

			SET @v_log_type = '11';
			SET @v_log_message = '########## Invalid Incoterms ##########';
			SET @v_description = '';
			SET @d_event_date = SYSDATETIME();

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END;

		-- fcst_Type 값 체크
		BEGIN
			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD] 
			   SET UPLOAD_STATUS_CODE = 'ERROR'
				 , MESSAGE_TEXT       = 'Invalid Fcst Type.'
			 WHERE PROGRAM_ID         = @v_program_id
			   AND SHEET_NAME         = @v_sheet_name
			   AND CREATED_BY         = @p_created_by
			   AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			   AND UPLOAD_STATUS_CODE = 'UPLOAD'
			   AND NOT EXISTS (SELECT 1
								 FROM [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] D  WITH(NOLOCK)
								WHERE D.VALID_YN    = 'Y'
								  AND D.LOOKUP_TYPE = 'SALES_TYPE_CODE'		
								  AND D.SEGMENT1 = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE10
								UNION
							  SELECT 1
								 FROM [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] D  WITH(NOLOCK)
								WHERE D.VALID_YN    = 'Y'
								  AND D.LOOKUP_TYPE = 'SALES_TYPE_CODE'		
								  AND D.SEGMENT2 = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE10
						) ;

			SET @v_log_type = '12';
			SET @v_log_message = '########## Invalid Division ##########';
			SET @v_description = '';
			SET @d_event_date = SYSDATETIME();

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END;



		

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
										 , ATTRIBUTE2	AS FROM_SITE
										 , ATTRIBUTE3	AS TO_SITE
										 , ATTRIBUTE4	AS SHIPTO_CODE
										 , ATTRIBUTE5	AS ITEM_ID
										 , ATTRIBUTE11	AS YYYYMMDD
										 --, ATTRIBUTE7	AS QTY
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
											, ATTRIBUTE11
											--, ATTRIBUTE7
											, ATTRIBUTE8
										     , ATTRIBUTE9
									HAVING COUNT(1) > 1  ) T
							WHERE 1 = 1
	 						  AND T.DIVISION_ID = ATTRIBUTE1							  
							  AND T.FROM_SITE   = ATTRIBUTE2
							  AND T.TO_SITE	= ATTRIBUTE3
							  AND T.SHIPTO_CODE	= ATTRIBUTE4
							  AND T.ITEM_ID     = ATTRIBUTE5
							  AND T.YYYYMMDD    = ATTRIBUTE11
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

		---- ITEM 유무 체크
		--BEGIN
		--	UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD]
		--	   SET UPLOAD_STATUS_CODE = 'ERROR'
		--		 , MESSAGE_TEXT       = 'Invalid item Data.'
		--	 WHERE PROGRAM_ID         = @v_program_id
		--	   AND SHEET_NAME         = @v_sheet_name
		--	   AND CREATED_BY         = @p_created_by
		--	   AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
		--	   AND UPLOAD_STATUS_CODE = 'UPLOAD'
		--	   AND NOT EXISTS ( SELECT 1
		--						  FROM SCP_MST_BOD_ITEM IV WITH(NOLOCK)
		--						  INNER JOIN SCP_MST_BOD_N_V V WITH(NOLOCK)
		--								ON V.DIVISION_ID = IV.DIVISION_ID
		--								AND V.BOD_ID = IV.BOD_ID
		--						  INNER JOIN SCM_MST_SITE	B
		--								ON B.DIVISION_ID = V.DIVISION_ID
		--							    AND B.SCM_SITE_ID = V.FROM_SITE
		--						  WHERE 1=1
		--						     AND IV.DIVISION_ID = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE1
		--							 AND V.VALID_YN ='Y'
		--							--AND IV.ITEM_ID = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE5
		--							--ITEM 코드 11자리까지 동일하면 유효한 BOD ITEM
		--							 AND SUBSTRING(IV.ITEM_ID,1,11)  = SUBSTRING([dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE5,1,11) 
		--						) ;

		--	SET @v_log_type = '16';
		--	SET @v_log_message = '########## ERROR Invalid item Data ##########';
		--	SET @v_description = '';
		--	SET @d_event_date = SYSDATETIME();
				
		--	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		--END;

		-- BOD_ID  체크
		BEGIN
			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD]
			   SET ATTRIBUTE12 =  (SELECT BOD_ID
							    FROM SCP_MST_BOD_N_V WITH(NOLOCK)
							   WHERE FROM_SITE = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE2
								AND TO_SITE     = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE3
								-- 2020.09.21	 KIMYONGHO		SSP INCOTERMS 변경작업
								--AND INCOTERMS   = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE9
								AND SSP_INCOTERMS   = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE9
								AND TRANSPORT_MODE= [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE8
								AND FROM_YYYYMMDD <= [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE11
								AND TO_YYYYMMDD >= [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE11)
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
							INNER JOIN SCP_MST_BOD_N_V V WITH(NOLOCK)
								ON V.DIVISION_ID = X.DIVISION_ID
								AND V.BOD_ID = X.BOD_ID
							INNER JOIN SCM_MST_SITE	B
								 ON B.DIVISION_ID = V.DIVISION_ID
								AND B.SCM_SITE_ID = V.FROM_SITE
							WHERE X.DIVISION_ID = (SELECT DIVISION_ID  
												FROM SCM_MST_SITE WITH(NOLOCK) 
											    WHERE DIVISION_ID   = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE1 -- DIVISION_ID
											      AND  SCM_SITE_ID  = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE2 -- FROM SITE
										           AND	VALID_YN  = 'Y'
										           AND SITE_TYPE  = 'PLANT')
							AND X.VALID_YN ='Y'
							AND X.BOD_ID  = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE12
							AND CASE WHEN ISNULL(B.PACKER_ITEM_ID_SUFFIX,'') = '' THEN X.ITEM_ID ELSE ISNULL(STUFF(X.ITEM_ID,12,1, B.PACKER_ITEM_ID_SUFFIX), X.ITEM_ID) END =  [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE5 ) 						     

			   --AND NOT EXISTS (SELECT 1
						--	FROM SCP_MST_BOD_ITEM X WITH(NOLOCK)
						--	JOIN SCP_MST_BOD_N_V V WITH(NOLOCK)
						--		ON V.DIVISION_ID = X.DIVISION_ID
						--		AND V.BOD_ID = X.BOD_ID
						--	WHERE X.DIVISION_ID = (SELECT DIVISION_ID  
						--						FROM SCM_MST_SITE WITH(NOLOCK) 
						--					    WHERE DIVISION_ID   = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE1 -- DIVISION_ID
						--					      AND  SCM_SITE_ID  = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE2 -- FROM SITE
						--				           AND	VALID_YN  = 'Y'
						--				           AND SITE_TYPE  = 'PLANT')
						--	AND X.VALID_YN ='Y'
						--	AND X.BOD_ID  = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE12
						--	--AND X.ITEM_ID = [dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE5 );
						--	--ITEM 코드 11자리까지 동일하면 유효한 BOD ITEM
						--	AND    SUBSTRING(X.ITEM_ID,1,11)  = SUBSTRING([dbo].[SCM_ADM_EXCEL_UPLOAD].ATTRIBUTE5,1,11) ) ;

			SET @v_log_type = '19';
			SET @v_log_message = '########## ERROR Invalid Bod item Data ##########';
			SET @v_description = '';
			SET @d_event_date = SYSDATETIME();
				
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END;
		

		-- Confirm Day 체크
		BEGIN
			UPDATE [dbo].[SCM_ADM_EXCEL_UPLOAD]
			   SET ATTRIBUTE13   =  convert(varchar(8), GETDATE() + 7, 112)
			 WHERE PROGRAM_ID         = @v_program_id
			   AND SHEET_NAME         = @v_sheet_name
			   AND CREATED_BY         = @p_created_by
			   AND CONVERT(NVARCHAR(40), CREATION_DATE, 121) = @v_creation_date
			   AND UPLOAD_STATUS_CODE = 'UPLOAD';

			SET @v_log_type = '20';
			SET @v_log_message = '########## SUCCESS. ##########';
			SET @v_description = '';
			SET @d_event_date = SYSDATETIME();

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END


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
			   AND (ATTRIBUTE11         <  ATTRIBUTE13)
			        

			SET @v_log_type = '13';
			SET @v_log_message = '########## Invalid yyyyMMdd. ##########';
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
			SET @v_log_message = '########## INSERT/UPDATE SSP0026 SHIPMENT REQUEST DATA START ##########';
			SET @v_description = @p_mode; --CONVERT(CHAR(30), @v_creation_date, 121);
			SET @d_event_date = SYSDATETIME();

			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END;

		BEGIN TRANSACTION SSP0026_SHIPMENT_REQUEST_UPLOAD;
		BEGIN TRY
			BEGIN

			SET @v_log_type = '23-1';
			SET @v_log_message = '########## MERGE SSP0026 SHIPMENT REQUEST DATA START ##########';
			SET @v_description = @p_mode; --CONVERT(CHAR(30), @v_creation_date, 121);
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			----------------------------------------------------------------------------


			-- 파라미터 출력 DEBUG용
			BEGIN		
				PRINT '===============================================';
				PRINT '@v_active_flag         = ''' +@v_active_flag            +'''';
				PRINT '@v_division_id         = ''' +@v_division_id               +'''';
				PRINT '@v_scm_site_id         = ''' +@v_scm_site_id               +'''';
				PRINT '@v_model_id            = ''' +@v_model_id                +'''';
				PRINT '@v_bod_id              = ''' +@v_bod_id                    +'''';
				PRINT '@v_from_site           = ''' +@v_from_site            +'''';
				PRINT '@v_to_site			= ''' +@v_to_site    +'''';
				PRINT '@v_yyyymmdd            = ''' +@v_yyyymmdd                +'''';
				PRINT '@v_qty				= ''' +@v_qty        +'''';
			END;



			--INSERT INTO #TblDynamic_SSP0026_ShpimentReq
			--SELECT @v_active_flag			 AS ACTIVE_FLAG
			--		, @v_division_id		 AS DIVISION_ID
			--		, @v_item_id			 AS MODEL_ID
			--		, @v_from_site			 AS FROM_SITE
			--		, @v_to_site			 AS TO_SITE
			--		, @v_shipto_code		 AS SHIPTO_CODE
			--		, @v_new_incoterms_temp	 AS INCOTERMS
			--		, @v_new_transport_mode_temp AS TRANSPORT_MODE
			--		, @v_fcst_type			 AS FCST_TYPE
			--		, @v_new_bod_id_temp	 AS BOD_ID
			--		, @v_yyyymmdd			 AS YYYYMMDD
			--		, @v_qty				 AS QTY
			--		, @v_remark				 AS REMARK
			--		, @v_order_type_detail   AS ORDER_TYPE_DETAIL
			--		, 'R'+ CONVERT(VARCHAR(8), GETDATE(), 112) + RIGHT('000000' + CONVERT(NVARCHAR, NEXT VALUE FOR SEQ1_SSP_ANL_SHIP_PACKER_REQ_ID),6) AS REQUEST_ID
			--;



			-- 변경, 추가 대상 건 TEMP 생성
			INSERT INTO #TblDynamic_SSP0026_ShpimentReq
			SELECT 'M'							AS ACTIVE_FLAG
			, T.ATTRIBUTE1					    AS DIVISION_ID
			, T.ATTRIBUTE2						AS FROM_SITE
			, T.ATTRIBUTE3						AS TO_SITE	
			, T.ATTRIBUTE4						AS SHIPTO_CODE
			, T.ATTRIBUTE5						AS ITEM_ID
			, T.ATTRIBUTE9						AS INCOTERMS
			, T.ATTRIBUTE8						AS TRANSPORT_MODE
			, D.SEGMENT1					    AS FCST_TYPE
			, T.ATTRIBUTE12						AS BOD_ID
			, T.ATTRIBUTE11						AS YYYYMMDD
			, CONVERT(INT,CEILING(T.ATTRIBUTE7))	AS QTY
			, 'R'+ CONVERT(VARCHAR(8), GETDATE(), 112) + RIGHT('000000' + CONVERT(NVARCHAR, NEXT VALUE FOR SEQ1_SSP_ANL_SHIP_PACKER_REQ_ID),6) AS REQUEST_ID
			FROM SCM_ADM_EXCEL_UPLOAD T WITH(NOLOCK)
			LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL D WITH(NOLOCK)
			 ON D.LOOKUP_TYPE = 'SALES_TYPE_CODE'
			 AND (D.SEGMENT1 = T.ATTRIBUTE10 OR D.SEGMENT2 = T.ATTRIBUTE10 )
			WHERE T.PROGRAM_ID    = @v_program_id
				AND T.SHEET_NAME    = @v_sheet_name
				AND T.CREATED_BY    = @p_created_by
				AND CONVERT(NVARCHAR(40), T.CREATION_DATE, 121) = @v_creation_date
				AND ISNULL(T.UPLOAD_STATUS_CODE,'X') = 'SUCCESS'



			--SELECT 
			--	T0.ACTIVE_FLAG
			--	,T0.DIVISION_ID
			--	,T0.FROM_SITE
			--	,T0.TO_SITE
			--	,T0.SHIPTO_CODE
			--	,T0.ITEM_ID
			--	,T0.INCOTERMS
			--	,T0.TRANSPORT_MODE
			--	,T0.FCST_TYPE
			--	,T0.BOD_ID
			--	,T0.YYYYMMDD
			--	,CEILING(T0.QTY * 1)					AS QTY
			--FROM(

			--	SELECT 'M'								AS ACTIVE_FLAG
			--		, T.ATTRIBUTE1					    AS DIVISION_ID
			--		, T.ATTRIBUTE2						AS FROM_SITE
			--		, T.ATTRIBUTE3						AS TO_SITE	
			--		, T.ATTRIBUTE4						AS SHIPTO_CODE
			--		, T.ATTRIBUTE5						AS ITEM_ID
			--		, T.ATTRIBUTE9						AS INCOTERMS
			--		, T.ATTRIBUTE8						AS TRANSPORT_MODE
			--		, T.ATTRIBUTE10						AS FCST_TYPE
			--		, T.ATTRIBUTE12						AS BOD_ID
			--		, T.ATTRIBUTE11						AS YYYYMMDD
			--		, CONVERT(INT,CEILING(T.ATTRIBUTE7))	AS QTY
			--		FROM SCM_ADM_EXCEL_UPLOAD T WITH(NOLOCK)
			--		WHERE T.PROGRAM_ID    = @v_program_id
			--	       AND T.SHEET_NAME    = @v_sheet_name
			--	       AND T.CREATED_BY    = @p_created_by
			--	       AND CONVERT(NVARCHAR(40), T.CREATION_DATE, 121) = @v_creation_date
			--	       AND ISNULL(T.UPLOAD_STATUS_CODE,'X') = 'SUCCESS'

			--) T0
			--;

			SELECT  @v_cnt = COUNT(*)  
			FROM #TblDynamic_SSP0026_ShpimentReq;

		IF @v_cnt > 0 
		BEGIN

			SET @d_event_date = SYSDATETIME();
			-- 수정
			-- 삭제기능은 없으므로 Active Flag는 'I' 또는 'M'으로 가정하고 입력/수정만 진행

			-- 2020-09-25 KIMYONGHO REQUEST_ID 없는 경우 새로 생성
			--SELECT @v_req_id_seq = 'R'+ CONVERT(VARCHAR(8), GETDATE(), 112) + RIGHT('000000' + CONVERT(NVARCHAR, NEXT VALUE FOR SEQ1_SSP_ANL_SHIP_PACKER_REQ_ID),6)
			--FROM SSP_ANL_SHIP_PLAN_PACK_REQ A WITH(NOLOCK)
			--JOIN #TblDynamic_SSP0026_ShpimentReq B WITH(NOLOCK) ON A.DIVISION_ID		= B.DIVISION_ID
			--										AND A.FROM_SITE		= B.FROM_SITE
			--										AND A.TO_SITE			= B.TO_SITE
			--										AND A.SHIPTO_CODE		= B.SHIPTO_CODE
			--										AND A.MODEL_ID			= B.ITEM_ID
			--										AND A.INCOTERMS			= B.INCOTERMS
			--										AND A.BOD_ID			= B.BOD_ID				
			--										AND A.TRANSPORT_MODE	= B.TRANSPORT_MODE	
			--										AND A.YYYYMMDD			= B.YYYYMMDD
		 --    WHERE A.REQUEST_ID IS NULL
			--;

			--SET @v_req_id_seq = 'R'+ CONVERT(VARCHAR(8), GETDATE(), 112) + RIGHT('000000' + CONVERT(NVARCHAR, NEXT VALUE FOR SEQ1_SSP_ANL_SHIP_PACKER_REQ_ID),6);

			UPDATE A
			SET A.QTY = B.QTY
				, A.BOD_ID			  = B.BOD_ID
				, A.PROJECT_CODE	  = EC.SOLDTO_CUSTOMER
				, A.FCST_TYPE		  = B.FCST_TYPE
				, A.REQUEST_ID		  = CASE WHEN A.REQUEST_ID IS NULL THEN B.REQUEST_ID ELSE A.REQUEST_ID END
				, A.LAST_UPDATED_BY   = @p_created_by
				, A.LAST_UPDATE_DATE  = @d_event_date
			FROM [DBO].[SSP_ANL_SHIP_REQ_P] A WITH(NOLOCK)

			JOIN #TblDynamic_SSP0026_ShpimentReq B WITH(NOLOCK) ON A.DIVISION_ID		= B.DIVISION_ID
													AND A.SHIPTO_CODE					= B.SHIPTO_CODE
													AND A.ITEM_ID						= B.ITEM_ID
													AND A.BOD_ID						= B.BOD_ID				
													AND A.YYYYMMDD						= B.YYYYMMDD

			LEFT OUTER JOIN SCM_MST_SITE EC  WITH(NOLOCK)														
			  ON EC.DIVISION_ID = A.DIVISION_ID																	
			  AND EC.SCM_SITE_ID = B.TO_SITE																	
			 AND EC.VALID_YN = 'Y'															

			--* 2020.09.21   KIM BOK KI		HISTORY 저장 추가
			--* 2021.11.03   SHIN MYUNG SU  수정 ( SSP_ANL_SHIP_PLAN_PACK_REQ_H -> SSP_ANL_SHIP_REQ_P_H 변경)
			INSERT INTO SSP_ANL_SHIP_REQ_P_H (
				   HISTORY_SEQ
				 , DIVISION_ID
				 --, MODEL_TYPE
				 --, MODEL_ID
				 --, FROM_SITE
				 --, TO_SITE
				 , SHIPTO_CODE
				 , YYYYMMDD
				 , BOD_ID
				 , QTY
				 , REQUEST_ID
				 , CONFIRM_ID
				 --, INCOTERMS
				 --, TRANSPORT_MODE
				 , ORDER_TYPE_DETAIL
				 , REMARK
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
				 , ATTRIBUTE10
				 , FCST_TYPE
				 , ITEM_ID
				   )
			SELECT NEXT VALUE FOR SEQ1_SSP_ANL_SHIP_PACKER_REQ_H   AS HISTORY_SEQ
				 , A.DIVISION_ID
				 --, '-' AS MODEL_TYPE
				 --, A.ITEM_ID
				 --, B.FROM_SITE
				 --, B.TO_SITE
				 , A.SHIPTO_CODE
				 , A.YYYYMMDD
				 , A.BOD_ID
				 , A.QTY
				 , A.REQUEST_ID
				 , A.CONFIRM_ID
				 --, B.INCOTERMS
				 --, B.TRANSPORT_MODE
				 , A.ORDER_TYPE_DETAIL
				 , A.REMARK
				 , A.CREATED_BY
				 , A.CREATION_DATE
				 , A.LAST_UPDATED_BY
				 , A.LAST_UPDATE_DATE
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
				 , A.FCST_TYPE
				 , A.ITEM_ID
			FROM   [DBO].[SSP_ANL_SHIP_REQ_P]  A WITH(NOLOCK)

			--JOIN SCP_MST_BOD_N_V   V WITH(NOLOCK)
			--		ON   A.DIVISION_ID = V.DIVISION_ID
			--		AND  A.BOD_ID      = V.BOD_ID


			JOIN #TblDynamic_SSP0026_ShpimentReq B WITH(NOLOCK) ON A.DIVISION_ID		= B.DIVISION_ID
													--AND A.FROM_SITE			= B.FROM_SITE
													--AND A.TO_SITE			= B.TO_SITE
													AND A.SHIPTO_CODE		= B.SHIPTO_CODE
													AND A.ITEM_ID			= B.ITEM_ID
													--AND A.INCOTERMS			= B.INCOTERMS
													AND A.BOD_ID			= B.BOD_ID				
													--AND A.TRANSPORT_MODE	= B.TRANSPORT_MODE	
													AND A.YYYYMMDD			= B.YYYYMMDD
			WHERE  1 = 1
			;
			--INSERT INTO SSP_ANL_SHIP_PLAN_PACK_REQ_H (
			--	   HISTORY_SEQ
			--	 , DIVISION_ID
			--	 , MODEL_TYPE
			--	 , MODEL_ID
			--	 , FROM_SITE
			--	 , TO_SITE
			--	 , SHIPTO_CODE
			--	 , YYYYMMDD
			--	 , BOD_ID
			--	 , QTY
			--	 , REQUEST_ID
			--	 , CONFIRM_ID
			--	 , INCOTERMS
			--	 , TRANSPORT_MODE
			--	 , ORDER_TYPE_DETAIL
			--	 , REMARK
			--	 , CREATED_BY
			--	 , CREATION_DATE
			--	 , LAST_UPDATED_BY
			--	 , LAST_UPDATE_DATE
			--	 , ATTRIBUTE1
			--	 , ATTRIBUTE2
			--	 , ATTRIBUTE3
			--	 , ATTRIBUTE4
			--	 , ATTRIBUTE5
			--	 , ATTRIBUTE6
			--	 , ATTRIBUTE7
			--	 , ATTRIBUTE8
			--	 , ATTRIBUTE9
			--	 , ATTRIBUTE10
			--	 , FCST_TYPE
			--	   )
			--SELECT NEXT VALUE FOR SEQ1_SSP_ANL_SHIP_PACKER_REQ_H   AS HISTORY_SEQ
			--	 , A.DIVISION_ID
			--	 , '-' AS MODEL_TYPE
			--	 , A.ITEM_ID
			--	 , B.FROM_SITE
			--	 , B.TO_SITE
			--	 , A.SHIPTO_CODE
			--	 , A.YYYYMMDD
			--	 , A.BOD_ID
			--	 , A.QTY
			--	 , A.REQUEST_ID
			--	 , A.CONFIRM_ID
			--	 , B.INCOTERMS
			--	 , B.TRANSPORT_MODE
			--	 , A.ORDER_TYPE_DETAIL
			--	 , A.REMARK
			--	 , A.CREATED_BY
			--	 , A.CREATION_DATE
			--	 , A.LAST_UPDATED_BY
			--	 , A.LAST_UPDATE_DATE
			--	 , A.ATTRIBUTE1
			--	 , A.ATTRIBUTE2
			--	 , A.ATTRIBUTE3
			--	 , A.ATTRIBUTE4
			--	 , A.ATTRIBUTE5
			--	 , A.ATTRIBUTE6
			--	 , A.ATTRIBUTE7
			--	 , A.ATTRIBUTE8
			--	 , A.ATTRIBUTE9
			--	 , A.ATTRIBUTE10
			--	 , A.FCST_TYPE
			--FROM   [DBO].[SSP_ANL_SHIP_REQ_P]  A WITH(NOLOCK)

			----JOIN SCP_MST_BOD_N_V   V WITH(NOLOCK)
			----		ON   A.DIVISION_ID = V.DIVISION_ID
			----		AND  A.BOD_ID      = V.BOD_ID


			--JOIN #TblDynamic_SSP0026_ShpimentReq B WITH(NOLOCK) ON A.DIVISION_ID		= B.DIVISION_ID
			--										--AND A.FROM_SITE			= B.FROM_SITE
			--										--AND A.TO_SITE			= B.TO_SITE
			--										AND A.SHIPTO_CODE		= B.SHIPTO_CODE
			--										AND A.ITEM_ID			= B.ITEM_ID
			--										--AND A.INCOTERMS			= B.INCOTERMS
			--										AND A.BOD_ID			= B.BOD_ID				
			--										--AND A.TRANSPORT_MODE	= B.TRANSPORT_MODE	
			--										AND A.YYYYMMDD			= B.YYYYMMDD

			
				
						
			--WHERE  1 = 1
			--;


			-- SCS I/F 정보 생성
			-- I/F 주체는 SCS 에서 함
			INSERT INTO XIF_SCS_PACK_SHIP_PLAN_S_SN (
				   IF_SEQ           
				 , IF_TYPE          
				 , IF_ID            
				 , IF_INS_DATE      
				 , IF_FLAG          
				 , PACKER_CODE      
				 , DIVISION_ID      
				 , PLAN_VERSION   
				 , PACK_MODEL_CODE  
				 , NICK_NAME 
				 , TARGET_ORDER
				 , SSP_CNFM
				 , SALES_SITE
				 , SHIP_TO
				 , SHIP_TO_NAME
				 , TRANSPORT_MODE
				 , INCOTERMS
				 , SHIP_PLAN_DATE 
				 , SHIP_PLAN_QTY 
				 , COMMENT
				 , ATTR_01           
				 , ATTR_02           
				 , ATTR_03           
				 , ATTR_04           
				 , ATTR_05           
				 , ATTR_06           
				 , ATTR_07           
				 , ATTR_08           
				 , ATTR_09           
				 , ATTR_10           
				 , ORDER_TYPE_DETAIL
				 )
			SELECT
				 'OSCM' + CONVERT(VARCHAR,GETDATE(),12) + DBO.FN_ZERO_LPAD(CONVERT(VARCHAR,NEXT VALUE FOR DBO.SEQ1_XIF_SCS),10)  AS IF_SEQ
				, N'I'         AS IF_TYPE          
				, N'OSCM_OSCS_SCS_PACK_SHIP_PLAN'  AS IF_ID            
				, GETDATE()    AS IF_INS_DATE      
				, 'N'          AS IF_FLAG          
				, ISNULL(X1.NEW_VALUE1, A.PACKER_CODE)	AS PACKER_CODE     
				, A.DIVISION_ID      
				, @v_plan_start_yyyymmdd   AS PLAN_VERSION   
				, A.PACK_MODEL_CODE  
				, A.NICK_NAME 
				, N'O'          AS TARGET_ORDER
				, A.SSP_CNFM
				, A.SALES_SITE
				, A.SHIP_TO
				, A.SHIP_TO_NAME
				, A.TRANSPORT_MODE
				, A.INCOTERMS
				, A.SHIP_PLAN_DATE 
				, A.SHIP_PLAN_QTY 
				, NULL								AS COMMENT
				, A.ATTR_01           
				, NULL								AS ATTR_02           
			/* 20211102  SHINMYUNGSU  수정  ****************************************************/
				--, NULL								AS ATTR_03    
				, A.ATTR_03      --Model PIC   				
				--, NULL								AS ATTR_04           
				, A.ATTR_04		--MTK_OWNER       
			/***********************************************************************************/
				, NULL								AS ATTR_05           
				, NULL								AS ATTR_06           
				, NULL								AS ATTR_07           
				, NULL								AS ATTR_08           
				, NULL								AS ATTR_09           
				, NULL								AS ATTR_10    
				/* 20211102  SHINMYUNGSU  수정  ********************************************/
				, A.ORDER_TYPE_DETAIL
				/***************************************************************************/
			FROM
			(
				SELECT 
					   B.FROM_SITE  AS PACKER_CODE      
					 , B.DIVISION_ID AS DIVISION_ID      
					 , B.ITEM_ID    AS PACK_MODEL_CODE  
					 , [dbo].[FN_GET_ITEM_NICKNAME](B.DIVISION_ID, B.ITEM_ID)  AS NICK_NAME 
					 , A.REQUEST_ID AS SSP_CNFM
					 , B.TO_SITE     AS SALES_SITE
					 , B.SHIPTO_CODE AS SHIP_TO
					-- , [dbo].[FN_GET_SITE_CUSTOMER_INFO](B.DIVISION_ID, B.TO_SITE,'SHIPTO_CODE')	AS SHIP_TO
					 , [dbo].[FN_GET_SITE_CUSTOMER_INFO](B.DIVISION_ID, B.TO_SITE,'SHIPTO_DESCRIPTION')	AS SHIP_TO_NAME
					 , B.TRANSPORT_MODE
					 , B.INCOTERMS
					 , B.YYYYMMDD    AS SHIP_PLAN_DATE 
					 , B.QTY         AS SHIP_PLAN_QTY 
					 , B.DIVISION_ID + '_' + @v_plan_start_yyyymmdd + '_' + @IF_GROUP_NO	AS ATTR_01           
					/* 20211102  SHINMYUNGSU  수정  ****************************************************/
					 --, NULL								AS ATTR_03    
					 , U2.UserName + '(' + MU.USER_ID + ')'					AS ATTR_03      --Model PIC   				
					 --, NULL								AS ATTR_04           
					 , DBO.FN_GET_SSP_MKT_OWNER_NAME (SI.OWNER, '', 'KO')	AS ATTR_04		--MTK_OWNER       
					/***********************************************************************************/
					 /* 20211102  SHINMYUNGSU  수정  ********************************************/
					 , ISNULL(LK.SEGMENT2, A.FCST_TYPE) AS ORDER_TYPE_DETAIL
					 /***************************************************************************/
				FROM [DBO].[SSP_ANL_SHIP_REQ_P] A WITH(NOLOCK)

				--JOIN SCP_MST_BOD_N_V   V WITH(NOLOCK)
				--		ON   A.DIVISION_ID = V.DIVISION_ID
				--		AND  A.BOD_ID      = V.BOD_ID

				JOIN #TblDynamic_SSP0026_ShpimentReq B WITH(NOLOCK) ON A.DIVISION_ID		= B.DIVISION_ID
														--AND A.FROM_SITE			= B.FROM_SITE
														--AND A.TO_SITE			= B.TO_SITE
														AND A.SHIPTO_CODE		= B.SHIPTO_CODE
														AND A.ITEM_ID			= B.ITEM_ID
														--AND A.INCOTERMS			= B.INCOTERMS
														AND A.BOD_ID			= B.BOD_ID				
														--AND A.TRANSPORT_MODE	= B.TRANSPORT_MODE	
														AND A.YYYYMMDD			= B.YYYYMMDD
					/* 20211102  SHINMYUNGSU  추가 **************************************************************************************/
						 LEFT OUTER JOIN (SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
 							FROM(																						
 								SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID									
 								  ,ROW_NUMBER() over(partition by DIVISION_ID, SCM_SITE_ID, ITEM_ID order by PROJECT_CODE) num	
 							FROM scm_mst_site_item																				
 						 ) a WHERE num = 1) g on g.DIVISION_ID =  B.DIVISION_ID and g.SCM_SITE_ID = B.TO_SITE and g.ITEM_ID = B.ITEM_ID	
						 LEFT OUTER JOIN SCM_MST_SITE_ITEM AS SI WITH(NOLOCK)
					  ON B.DIVISION_ID					= SI.DIVISION_ID
					 AND B.TO_SITE						= SI.SCM_SITE_ID
					 AND B.ITEM_ID						= SI.ITEM_ID
					 AND G.PROJECT_CODE					= SI.PROJECT_CODE
						 LEFT OUTER JOIN SSP_MST_MODEL_USER AS MU WITH(NOLOCK)
					  ON B.DIVISION_ID = MU.DIVISION_ID
					 AND B.FROM_SITE = MU.FROM_SITE
					 AND B.ITEM_ID = MU.ITEM_ID
					 AND MU.VALID_YN = 'Y'
						 LEFT OUTER JOIN TB_FX_User as U2 with(nolock) 
					  ON mu.user_id = u2.UserID 
	   				 AND U2.UseYN = 'Y'
						 LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL AS LK WITH(NOLOCK)
					  ON LK.LOOKUP_TYPE = 'SALES_TYPE_CODE'
					 AND LK.VALID_YN	= 'Y'
					 AND B.FCST_TYPE	= LK.SEGMENT1
					/********************************************************************************************************************/
			) A
			LEFT OUTER JOIN NERP_CONV_MASTER X1 WITH(NOLOCK) ON X1.CODETYPE = 'SCP_SITE_ID'	AND A.PACKER_CODE = X1.OLD_VALUE1
			
				;

			SET @v_cnt = 0;  -- 저장 후 초기화
		END
		-- UPDATE END

		-- INSERT START
		SELECT @v_cnt = COUNT(*)
		FROM #TblDynamic_SSP0026_ShpimentReq B WITH(NOLOCK)
		WHERE 1=1
		AND NOT EXISTS (SELECT 1 
						FROM [DBO].[SSP_ANL_SHIP_REQ_P] A WITH(NOLOCK)
						WHERE 1=1
						AND A.DIVISION_ID		= B.DIVISION_ID
						--AND A.FROM_SITE			= B.FROM_SITE
						--AND A.TO_SITE			= B.TO_SITE
						AND A.SHIPTO_CODE		= B.SHIPTO_CODE
						AND A.ITEM_ID			= B.ITEM_ID
						AND A.YYYYMMDD			= B.YYYYMMDD
						--AND A.INCOTERMS			= B.INCOTERMS
						--AND A.TRANSPORT_MODE	= B.TRANSPORT_MODE
						)
	
     	IF @v_cnt > 0
		BEGIN
			--SET @v_req_id_seq = 'R'+ CONVERT(VARCHAR(8), GETDATE(), 112) + RIGHT('000000' + CONVERT(NVARCHAR, NEXT VALUE FOR SEQ1_SSP_ANL_SHIP_PACKER_REQ_ID),6)
			
			-- INSERT 대상 건 ACTIVE FLAG 변경
			UPDATE  A
			SET A.ACTIVE_FLAG = 'I'
			FROM #TblDynamic_SSP0026_ShpimentReq A
			WHERE  NOT EXISTS (SELECT 1 
							FROM [DBO].[SSP_ANL_SHIP_REQ_P] B WITH(NOLOCK)
							WHERE 1=1
							AND A.DIVISION_ID		= B.DIVISION_ID
							--AND A.FROM_SITE			= B.FROM_SITE
							--AND A.TO_SITE			= B.TO_SITE
							AND A.SHIPTO_CODE		= B.SHIPTO_CODE
							AND A.ITEM_ID			= B.ITEM_ID
							AND A.YYYYMMDD			= B.YYYYMMDD
							AND A.BOD_ID			= B.BOD_ID
							--AND A.INCOTERMS			= B.INCOTERMS
							--AND A.TRANSPORT_MODE	= B.TRANSPORT_MODE
							)
			;

			-- 신규 REQEUST INSERT
			--DETAIL INSERT
			INSERT INTO [DBO].[SSP_ANL_SHIP_REQ_P]
			(
				 DIVISION_ID
				--,MODEL_TYPE
				--,FROM_SITE
				--,TO_SITE
				,ITEM_ID
				,SHIPTO_CODE
				,BOD_ID
				,YYYYMMDD
				,QTY
				,REQUEST_ID
				--,INCOTERMS
				--,TRANSPORT_MODE
				,FCST_TYPE
				,PROJECT_CODE
				,ORDER_TYPE_DETAIL
				,REMARK
				,CREATED_BY
				,CREATION_DATE
				,LAST_UPDATED_BY
				,LAST_UPDATE_DATE
			)
			SELECT 
				  B.DIVISION_ID
				--, '-'
				--, B.FROM_SITE
				--, B.TO_SITE
				, B.ITEM_ID
				, B.SHIPTO_CODE            
				, B.BOD_ID
				, B.YYYYMMDD
				, B.QTY	
				, B.REQUEST_ID
				--, B.INCOTERMS
				--, B.TRANSPORT_MODE
				, B.FCST_TYPE
				, C.SOLDTO_CUSTOMER
				, '-'
				, '-'
				, @p_created_by		AS CREATED_BY
				, @d_event_date		AS CREATION_DATE
				, @p_created_by		AS LAST_UPDATED_BY
				, @d_event_date		AS LAST_UPDATE_DATE
			FROM #TblDynamic_SSP0026_ShpimentReq B WITH(NOLOCK)
			INNER JOIN SCM_MST_SITE C  WITH(NOLOCK)
				ON B.DIVISION_ID = C.DIVISION_ID 
				AND B.TO_SITE = C.SCM_SITE_ID
				AND C.VALID_YN = 'Y'
			WHERE 1=1
			AND NOT EXISTS (SELECT 1 
							FROM [DBO].[SSP_ANL_SHIP_REQ_P] A WITH(NOLOCK)
							WHERE 1=1
							AND A.DIVISION_ID		= B.DIVISION_ID
							--AND A.FROM_SITE			= B.FROM_SITE
							--AND A.TO_SITE			= B.TO_SITE
							AND A.SHIPTO_CODE		= B.SHIPTO_CODE
							AND A.ITEM_ID			= B.ITEM_ID
							AND A.YYYYMMDD			= B.YYYYMMDD
							AND A.BOD_ID			= B.BOD_ID)
			;

			--* 2020.09.21   KIM BOK KI		HISTORY 저장 추가
			--* 2021.11.03   SHIN MYUNG SU  수정 ( SSP_ANL_SHIP_PLAN_PACK_REQ_H -> SSP_ANL_SHIP_REQ_P_H 변경)
			INSERT INTO SSP_ANL_SHIP_REQ_P_H (
				   HISTORY_SEQ
				 , DIVISION_ID
				 --, MODEL_TYPE
				 --, MODEL_ID
				 --, FROM_SITE
				 --, TO_SITE
				 , SHIPTO_CODE
				 , YYYYMMDD
				 , BOD_ID
				 , QTY
				 , REQUEST_ID
				 , CONFIRM_ID
				 --, INCOTERMS
				 --, TRANSPORT_MODE
				 , FCST_TYPE
				 , PROJECT_CODE
				 , ORDER_TYPE_DETAIL
				 , REMARK
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
				 , ATTRIBUTE10
				 , ITEM_ID
				   )
			SELECT NEXT VALUE FOR SEQ1_SSP_ANL_SHIP_PACKER_REQ_H   AS HISTORY_SEQ
				 , A.DIVISION_ID
				 --, '-' AS MODEL_TYPE
				 --, A.ITEM_ID
				 --, B.FROM_SITE
				 --, B.TO_SITE
				 , A.SHIPTO_CODE
				 , A.YYYYMMDD
				 , A.BOD_ID
				 , A.QTY
				 , A.REQUEST_ID
				 , A.CONFIRM_ID
				 --, B.INCOTERMS
				 --, B.TRANSPORT_MODE
				 , A.FCST_TYPE
				 , A.PROJECT_CODE
				 , A.ORDER_TYPE_DETAIL
				 , A.REMARK
				 , A.CREATED_BY
				 , A.CREATION_DATE
				 , A.LAST_UPDATED_BY
				 , A.LAST_UPDATE_DATE
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
				 , A.ITEM_ID
			FROM   [DBO].[SSP_ANL_SHIP_REQ_P]  A WITH(NOLOCK)

				--JOIN SCP_MST_BOD_N_V   V WITH(NOLOCK)
				--	ON   A.DIVISION_ID = V.DIVISION_ID
				--		AND  A.BOD_ID      = V.BOD_ID

				JOIN #TblDynamic_SSP0026_ShpimentReq B WITH(NOLOCK) 
					ON A.DIVISION_ID		= B.DIVISION_ID
						AND A.SHIPTO_CODE		= B.SHIPTO_CODE
						AND A.ITEM_ID			= B.ITEM_ID
						AND A.BOD_ID			= B.BOD_ID				
						AND A.YYYYMMDD			= B.YYYYMMDD
			WHERE  1 = 1
			;
			--INSERT INTO SSP_ANL_SHIP_PLAN_PACK_REQ_H (
			--	   HISTORY_SEQ
			--	 , DIVISION_ID
			--	 , MODEL_TYPE
			--	 , MODEL_ID
			--	 , FROM_SITE
			--	 , TO_SITE
			--	 , SHIPTO_CODE
			--	 , YYYYMMDD
			--	 , BOD_ID
			--	 , QTY
			--	 , REQUEST_ID
			--	 , CONFIRM_ID
			--	 , INCOTERMS
			--	 , TRANSPORT_MODE
			--	 , FCST_TYPE
			--	 , PROJECT_CODE
			--	 , ORDER_TYPE_DETAIL
			--	 , REMARK
			--	 , CREATED_BY
			--	 , CREATION_DATE
			--	 , LAST_UPDATED_BY
			--	 , LAST_UPDATE_DATE
			--	 , ATTRIBUTE1
			--	 , ATTRIBUTE2
			--	 , ATTRIBUTE3
			--	 , ATTRIBUTE4
			--	 , ATTRIBUTE5
			--	 , ATTRIBUTE6
			--	 , ATTRIBUTE7
			--	 , ATTRIBUTE8
			--	 , ATTRIBUTE9
			--	 , ATTRIBUTE10
			--	   )
			--SELECT NEXT VALUE FOR SEQ1_SSP_ANL_SHIP_PACKER_REQ_H   AS HISTORY_SEQ
			--	 , A.DIVISION_ID
			--	 , '-' AS MODEL_TYPE
			--	 , A.ITEM_ID
			--	 , B.FROM_SITE
			--	 , B.TO_SITE
			--	 , A.SHIPTO_CODE
			--	 , A.YYYYMMDD
			--	 , A.BOD_ID
			--	 , A.QTY
			--	 , A.REQUEST_ID
			--	 , A.CONFIRM_ID
			--	 , B.INCOTERMS
			--	 , B.TRANSPORT_MODE
			--	 , A.FCST_TYPE
			--	 , A.PROJECT_CODE
			--	 , A.ORDER_TYPE_DETAIL
			--	 , A.REMARK
			--	 , A.CREATED_BY
			--	 , A.CREATION_DATE
			--	 , A.LAST_UPDATED_BY
			--	 , A.LAST_UPDATE_DATE
			--	 , A.ATTRIBUTE1
			--	 , A.ATTRIBUTE2
			--	 , A.ATTRIBUTE3
			--	 , A.ATTRIBUTE4
			--	 , A.ATTRIBUTE5
			--	 , A.ATTRIBUTE6
			--	 , A.ATTRIBUTE7
			--	 , A.ATTRIBUTE8
			--	 , A.ATTRIBUTE9
			--	 , A.ATTRIBUTE10
			--FROM   [DBO].[SSP_ANL_SHIP_REQ_P]  A WITH(NOLOCK)

			--	--JOIN SCP_MST_BOD_N_V   V WITH(NOLOCK)
			--	--	ON   A.DIVISION_ID = V.DIVISION_ID
			--	--		AND  A.BOD_ID      = V.BOD_ID

			--	JOIN #TblDynamic_SSP0026_ShpimentReq B WITH(NOLOCK) 
			--		ON A.DIVISION_ID		= B.DIVISION_ID
			--			AND A.SHIPTO_CODE		= B.SHIPTO_CODE
			--			AND A.ITEM_ID			= B.ITEM_ID
			--			AND A.BOD_ID			= B.BOD_ID				
			--			AND A.YYYYMMDD			= B.YYYYMMDD
			--WHERE  1 = 1
			--;


			-- SCS I/F 정보 생성
			-- I/F 주체는 SCS 에서 함
			INSERT INTO XIF_SCS_PACK_SHIP_PLAN_S_SN (
				   IF_SEQ           
				 , IF_TYPE          
				 , IF_ID            
				 , IF_INS_DATE      
				 , IF_FLAG          
				 , PACKER_CODE      
				 , DIVISION_ID      
				 , PLAN_VERSION   
				 , PACK_MODEL_CODE  
				 , NICK_NAME 
				 , TARGET_ORDER
				 , SSP_CNFM
				 , SALES_SITE
				 , SHIP_TO
				 , SHIP_TO_NAME
				 , TRANSPORT_MODE
				 , INCOTERMS
				 , SHIP_PLAN_DATE 
				 , SHIP_PLAN_QTY 
				 , COMMENT
				 , ATTR_01           
				 , ATTR_02           
				 , ATTR_03           
				 , ATTR_04           
				 , ATTR_05           
				 , ATTR_06           
				 , ATTR_07           
				 , ATTR_08           
				 , ATTR_09           
				 , ATTR_10           
				 , ORDER_TYPE_DETAIL
				 )
			SELECT 
						'OSCM' + CONVERT(VARCHAR,GETDATE(),12) + DBO.FN_ZERO_LPAD(CONVERT(VARCHAR,NEXT VALUE FOR DBO.SEQ1_XIF_SCS),10)  AS IF_SEQ
					 , N'I'         AS IF_TYPE          
					 , N'OSCM_OSCS_SCS_PACK_SHIP_PLAN'  AS IF_ID            
					 , GETDATE()    AS IF_INS_DATE      
					 , 'N'          AS IF_FLAG          
					 , ISNULL(X1.NEW_VALUE1, A.PACKER_CODE)		AS PACKER_CODE        
					 , A.DIVISION_ID      
					 , @v_plan_start_yyyymmdd   AS PLAN_VERSION   
					 , A.PACK_MODEL_CODE  
					 , A.NICK_NAME 
					 , N'O'          AS TARGET_ORDER
					 , A.SSP_CNFM
					 , A.SALES_SITE
					 , A.SHIP_TO
					 , A.SHIP_TO_NAME
					 , A.TRANSPORT_MODE
					 , A.INCOTERMS
					 , A.SHIP_PLAN_DATE 
					 , B.SHIP_PLAN_QTY 
					 , NULL								AS COMMENT
					 , A.ATTR_01           
					 , NULL								AS ATTR_02           
					/* 20211102  SHINMYUNGSU  수정  *******************************************************/
				 --, NULL								AS ATTR_03    
					 , A.ATTR_03      --Model PIC   				
				 --, NULL								AS ATTR_04           
					 , A.ATTR_04		--MTK_OWNER       
					/**************************************************************************************/
					 , NULL								AS ATTR_05           
					 , NULL								AS ATTR_06           
					 , NULL								AS ATTR_07           
					 , NULL								AS ATTR_08           
					 , NULL								AS ATTR_09           
					 , NULL								AS ATTR_10    
					 /* 20211102  SHINMYUNGSU  수정  ********************************************/
					 , A.ORDER_TYPE_DETAIL
					 /***************************************************************************/
			FROM
			(
				SELECT B.FROM_SITE  AS PACKER_CODE      
					 , B.DIVISION_ID AS DIVISION_ID      
					 , B.ITEM_ID    AS PACK_MODEL_CODE  
					 , [dbo].[FN_GET_ITEM_NICKNAME](B.DIVISION_ID, B.ITEM_ID)  AS NICK_NAME 
					 , A.REQUEST_ID  AS SSP_CNFM
					 , B.TO_SITE     AS SALES_SITE
					 , B.SHIPTO_CODE AS SHIP_TO
					 , [dbo].[FN_GET_SITE_CUSTOMER_INFO](B.DIVISION_ID, B.TO_SITE,'SHIPTO_DESCRIPTION')	AS SHIP_TO_NAME
					 , B.TRANSPORT_MODE
					 , B.INCOTERMS
					 , B.YYYYMMDD    AS SHIP_PLAN_DATE 
					 , B.QTY         AS SHIP_PLAN_QTY 
					 , B.DIVISION_ID + '_' + @v_plan_start_yyyymmdd + '_' + @IF_GROUP_NO	AS ATTR_01           
					/* 20211102  SHINMYUNGSU  수정  *******************************************************/
				 --, NULL								AS ATTR_03    
					 , U2.UserName + '(' + MU.USER_ID + ')'					AS ATTR_03      --Model PIC   				
				 --, NULL								AS ATTR_04           
					 , DBO.FN_GET_SSP_MKT_OWNER_NAME (SI.OWNER, '', 'KO')	AS ATTR_04		--MTK_OWNER       
					/**************************************************************************************/
					 /* 20211102  SHINMYUNGSU  수정  ********************************************/
					 , ISNULL(LK.SEGMENT2, A.FCST_TYPE) AS ORDER_TYPE_DETAIL
					 /***************************************************************************/
					FROM   [DBO].[SSP_ANL_SHIP_REQ_P]  A WITH(NOLOCK)
					JOIN #TblDynamic_SSP0026_ShpimentReq B WITH(NOLOCK) ON A.DIVISION_ID		= B.DIVISION_ID
															--AND A.FROM_SITE			= B.FROM_SITE
															--AND A.TO_SITE			= B.TO_SITE
															AND A.SHIPTO_CODE		= B.SHIPTO_CODE
															AND A.ITEM_ID			= B.ITEM_ID
															--AND A.INCOTERMS			= B.INCOTERMS
															AND A.BOD_ID			= B.BOD_ID				
															--AND A.TRANSPORT_MODE	= B.TRANSPORT_MODE	
															AND A.YYYYMMDD			= B.YYYYMMDD
					/* 20211102  SHINMYUNGSU  추가 *************************************************************************************/
						 LEFT OUTER JOIN (SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
 							FROM(																						
 								SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID									
 								  ,ROW_NUMBER() over(partition by DIVISION_ID, SCM_SITE_ID, ITEM_ID order by PROJECT_CODE) num	
 							FROM scm_mst_site_item																				
 						 ) a WHERE num = 1) g on g.DIVISION_ID =  B.DIVISION_ID and g.SCM_SITE_ID = B.TO_SITE and g.ITEM_ID = B.ITEM_ID	
						 LEFT OUTER JOIN SCM_MST_SITE_ITEM AS SI WITH(NOLOCK)
					  ON B.DIVISION_ID					= SI.DIVISION_ID
					 AND B.TO_SITE						= SI.SCM_SITE_ID
					 AND B.ITEM_ID						= SI.ITEM_ID
					 AND G.PROJECT_CODE					= SI.PROJECT_CODE
						 LEFT OUTER JOIN SSP_MST_MODEL_USER AS MU WITH(NOLOCK)
					  ON B.DIVISION_ID = MU.DIVISION_ID
					 AND B.FROM_SITE = MU.FROM_SITE
					 AND B.ITEM_ID = MU.ITEM_ID
					 AND MU.VALID_YN = 'Y'
						 LEFT OUTER JOIN TB_FX_User as U2 with(nolock) 
					  ON mu.user_id = u2.UserID 
	   				 AND U2.UseYN = 'Y'
						 LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL AS LK WITH(NOLOCK)
					  ON LK.LOOKUP_TYPE = 'SALES_TYPE_CODE'
					 AND LK.VALID_YN	= 'Y'
					 AND B.FCST_TYPE	= LK.SEGMENT1
					/*******************************************************************************************************************/

				--FROM #TblDynamic_SSP0026_ShpimentReq B WITH(NOLOCK)
				WHERE 1=1
				AND B.ACTIVE_FLAG = 'I'
			) A 
			LEFT OUTER JOIN NERP_CONV_MASTER X1 WITH(NOLOCK) ON X1.CODETYPE = 'SCP_SITE_ID'	AND A.PACKER_CODE = X1.OLD_VALUE1
			
			
			
			
			
			
			
			--AND NOT EXISTS (SELECT 1 
			--				FROM SSP_ANL_SHIP_PLAN_PACK_REQ A WITH(NOLOCK)
			--				WHERE 1=1
			--				AND A.DIVISION_ID		= B.DIVISION_ID
			--				AND A.FROM_SITE		= B.FROM_SITE
			--				AND A.TO_SITE			= B.TO_SITE
			--				AND A.MODEL_ID			= B.ITEM_ID
			--				AND A.YYYYMMDD			= B.YYYYMMDD
			--				AND A.BOD_ID			= B.BOD_ID)
			;

			SET @v_cnt = 0;  -- 저장 후 초기화
		END



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
				ROLLBACK TRANSACTION SSP0026_SHIPMENT_REQUEST_UPLOAD;
						
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

	IF OBJECT_ID('tempdb..#TblDynamic_SSP0026_ShpimentReq') IS NOT NULL
		DROP TABLE #TblDynamic_SSP0026_ShpimentReq;    
END;
