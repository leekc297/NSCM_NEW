
/*
 * Program ID   : PR_SSP_ANL_SHIP_PLAN_P
 * Description  : SHIP_PLAN_P 정보 생성(Dailiy)
 * OutTable     :
 * Execute      : PR_SSP_ANL_SHIP_PLAN_P 
 * Program History
 *===================================================================================================
 *  Date         In Charge      Description
 *===================================================================================================
 *  2021.10.01   SSP Pjt.       Create.
 */

CREATE PROCEDURE [dbo].[PR_SSP_ANL_SHIP_PLAN_P]
AS
BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    --SET ANSI_WARNINGS OFF;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user				NVARCHAR(150)	= N'ssp_batch';
    DECLARE @v_program_name				NVARCHAR(150)	= N'PR_SSP_ANL_SHIP_PLAN_P';
    DECLARE @v_log_type					NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count				INTEGER = 0;
    DECLARE @v_log_message				NVARCHAR(1000);
    DECLARE @v_description				NVARCHAR(500);      --상세설명
    DECLARE @v_table_id					NVARCHAR(150)	= N'SSP_ANL_SHIP_PLAN_P'; --테이블 필수
    DECLARE @d_event_date				DATETIME;
    DECLARE @v_insert_cnt				INTEGER = 0;
	DECLARE @v_insert_sum				INTEGER = 0;


	DECLARE @v_division_id				NVARCHAR(30)	= '40';
    DECLARE @v_plan_start_yyyymmdd		NVARCHAR(8)		= '';
    DECLARE @v_plan_stock_yyyymmdd		NVARCHAR(8)		= '';
    DECLARE @v_data_start_yyyymmdd		NVARCHAR(8)		= '';
	DECLARE @v_data_end_yyyymmdd		NVARCHAR(8)		= '';
    DECLARE @v_plan_cutoff_yyyymmdd		NVARCHAR(8)		= '';
	DECLARE @v_plan_cutoff_datetime     datetime;

	SET @v_plan_start_yyyymmdd	= CONVERT(VARCHAR, DATEADD(D, -1, GETDATE()), 112)  --D-1 기준 Plan Cutoff
	SET @v_data_start_yyyymmdd	= CONVERT(VARCHAR, DATEADD(D, -1, CONVERT(DATETIME, @v_plan_start_yyyymmdd ,112)) ,112)  --START
	SET @v_data_end_yyyymmdd	= CONVERT(VARCHAR, DATEADD(D, 56, CONVERT(DATETIME, @v_plan_start_yyyymmdd ,112)) ,112)  --END : 8주(56일)
	SET @v_plan_stock_yyyymmdd	= CONVERT(VARCHAR, DATEADD(D, -2, CONVERT(DATETIME, @v_plan_start_yyyymmdd ,112)) ,112)  --BOH 

	if  (datepart(DW, convert(date, @v_plan_start_yyyymmdd)) = 2)
		SET @v_plan_cutoff_datetime     = CONVERT(DATETIME, @v_plan_start_yyyymmdd + ' 15:30:00')
	else
		SET @v_plan_cutoff_datetime     = CONVERT(DATETIME, @v_plan_start_yyyymmdd + ' 07:15:00')

	SELECT @v_plan_cutoff_yyyymmdd = ATTRIBUTE1
	  FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
	 WHERE LOOKUP_TYPE		= 'SSP_ANL_SHIP_PLAN_P'
	   AND SEGMENT1			= @v_division_id
	   AND VALID_YN			= 'Y'

	IF @v_plan_start_yyyymmdd <= @v_plan_cutoff_yyyymmdd
		RETURN 0;

	-----------------------------------------------------------
	-- START LOG
	-----------------------------------------------------------
    SET @v_log_type		= N'START';
    SET @v_log_message	= N'########## Start of procedure ##########';
    SET @v_description	= @v_program_name + ': ' + @v_table_id + N' INSERT LOGIC';
    SET @d_event_date	= SYSDATETIME();

    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
                              ,@p_log_type      = @v_log_type
                              ,@p_log_count     = @n_log_count
                              ,@p_log_message   = @v_log_message
                              ,@p_description   = @v_description
                              ,@p_event_date    = @d_event_date
                              ,@p_user_id       = @v_batch_user
                              ;

    BEGIN TRY

	    BEGIN TRAN TX_SH

        -------------------------------------------------------------------------------------------------------------
        --2. MEASURE별 Data생성
        -------------------------------------------------------------------------------------------------------------
        --temp 테이블 생성 : Measure까지 생성후 마지막에 한번에 입력하기 위해서
        IF OBJECT_ID('tempdb..#tmp_SSP_ANL_SHIP_PLAN_P') IS NOT NULL
            DROP TABLE #tmp_SSP_ANL_SHIP_PLAN_P

			CREATE TABLE #tmp_SSP_ANL_SHIP_PLAN_P (
				[DIVISION_ID] [nvarchar](30) NOT NULL,
				[PLAN_START_YYYYMMDD] [nvarchar](8) NOT NULL,
				[FROM_SITE] [nvarchar](30) NOT NULL,
				[ITEM_ID] [nvarchar](50) NOT NULL,
				[MEASURE] [nvarchar](50) NOT NULL,
				[YYYYMMDD] [nvarchar](8) NOT NULL,
				[BOD_ID] [nvarchar](150) NOT NULL,
				[SHIPTO_CODE] [nvarchar](50) NOT NULL,
				[PROJECT_CODE] [nvarchar](50) NOT NULL,
				[FCST_TYPE] [nvarchar](20) NOT NULL,
				[REQUEST_ID] [nvarchar](50) NULL,
				[QTY] [numeric](20, 10) NULL,
				[FCST_ETD_DATE] [nvarchar](8) NULL,
				[FCST_ETA_DATE] [nvarchar](8) NULL,
				[ETD_DATE] [nvarchar](8) NULL,
				[ETA_DATE] [nvarchar](8) NULL,
				[CONFIRM_FLAG] [nvarchar](1) NULL,
				[CONFIRM_ID] [nvarchar](20) NULL,
				[REQUESTOR] [nvarchar](100) NULL, 
				[CREATED_BY] [nvarchar](150) NULL,
				[CREATION_DATE] [datetime] NULL,
				[LAST_UPDATED_BY] [nvarchar](150) NULL,
				[LAST_UPDATE_DATE] [datetime] NULL,
				[ATTRIBUTE1] [nvarchar](150) NULL,
				[ATTRIBUTE2] [nvarchar](150) NULL,
				[ATTRIBUTE3] [nvarchar](150) NULL,
				[ATTRIBUTE4] [nvarchar](150) NULL,
				[ATTRIBUTE5] [nvarchar](150) NULL,
				[ATTRIBUTE6] [nvarchar](150) NULL,
				[ATTRIBUTE7] [nvarchar](150) NULL, 
				[ATTRIBUTE8] [nvarchar](150) NULL,
				[ATTRIBUTE9] [nvarchar](150) NULL,
				[ATTRIBUTE10] [nvarchar](150) NULL
            );


			-------------------------------------------------------------------------------------------------------------
			--2-1. Shipment Request(Measure : SHIP_REQ)
			-------------------------------------------------------------------------------------------------------------
			INSERT INTO #tmp_SSP_ANL_SHIP_PLAN_P
					   ([DIVISION_ID]
					   ,[PLAN_START_YYYYMMDD]
					   ,[FROM_SITE]
					   ,[ITEM_ID]
					   ,[MEASURE]
					   ,[YYYYMMDD]
					   ,[BOD_ID]
					   ,[SHIPTO_CODE]
					   ,[PROJECT_CODE]
					   ,[FCST_TYPE]
					   ,[REQUEST_ID]
					   ,[QTY]
					   ,[FCST_ETD_DATE]
					   ,[FCST_ETA_DATE]
					   ,[ETD_DATE]
					   ,[ETA_DATE]
					   ,[CREATED_BY]
					   ,[CREATION_DATE]
					   ,[LAST_UPDATED_BY]
					   ,[LAST_UPDATE_DATE]
					   )
				 SELECT R.[DIVISION_ID]
				       ,@v_plan_start_yyyymmdd
				       ,B.[FROM_SITE]
				       ,R.[ITEM_ID]
				       ,'SHIP_REQ'
				       ,R.[YYYYMMDD]
				       ,R.[BOD_ID]
				       ,R.[SHIPTO_CODE]
				       ,R.[PROJECT_CODE]
				       ,R.[FCST_TYPE]
				       ,R.[REQUEST_ID]
				       ,R.[QTY]
					  , R.YYYYMMDD			AS FCST_ETD_DATE
					  , DBO.FN_GET_SSP_ETA_DATE(R.DIVISION_ID, R.BOD_ID, R.YYYYMMDD)	AS FCST_ETA_DATE
					  , R.YYYYMMDD			AS ETD_DATE
					  , DBO.FN_GET_SSP_ETA_DATE(R.DIVISION_ID, R.BOD_ID, R.YYYYMMDD)	AS ETA_DATE
				       ,R.[CREATED_BY]
				       ,R.[CREATION_DATE]
				       ,R.[LAST_UPDATED_BY]
				       ,R.[LAST_UPDATE_DATE]
				   FROM [dbo].[SSP_ANL_SHIP_REQ_P] AS R WITH(NOLOCK)
				        INNER JOIN SCP_MST_BOD_N_V AS B
					 ON R.DIVISION_ID	= B.division_id
					AND R.BOD_ID		= B.BOD_ID
			      WHERE 1 = 1
			        AND R.YYYYMMDD		>= @v_data_start_yyyymmdd
			        AND R.YYYYMMDD		<  @v_data_end_yyyymmdd
			        AND R.DIVISION_ID	=  @v_division_id

			-------------------------------------------------------------------------------------------------------------
			--2-2. Shipment Request(Measure : SHIP_RTF)
			-------------------------------------------------------------------------------------------------------------
			INSERT INTO #tmp_SSP_ANL_SHIP_PLAN_P
					   ([DIVISION_ID]
					   ,[PLAN_START_YYYYMMDD]
					   ,[FROM_SITE]
					   ,[ITEM_ID]
					   ,[MEASURE]
					   ,[YYYYMMDD]
					   ,[BOD_ID]
					   ,[SHIPTO_CODE]
					   ,[PROJECT_CODE]
					   ,[FCST_TYPE]
					   ,[REQUEST_ID]
					   ,[QTY]
					   ,[CREATED_BY]
					   ,[CREATION_DATE]
					   ,[LAST_UPDATED_BY]
					   ,[LAST_UPDATE_DATE]
					   )
				 SELECT R.[DIVISION_ID]
				       ,@v_plan_start_yyyymmdd
				       ,B.[FROM_SITE]
				       ,R.[ITEM_ID]
				       ,'SHIP_RTF'
				       ,R.[ATTRIBUTE4]   AS YYYYMMDD  
				       ,R.[BOD_ID]
				       ,R.[SHIPTO_CODE]
				       ,R.[PROJECT_CODE]
				       ,R.[FCST_TYPE]
				       ,R.[REQUEST_ID]
				       ,CONVERT(int, [ATTRIBUTE5]) AS QTY 
				       ,R.[CREATED_BY]
				       ,R.[CREATION_DATE]
				       ,R.[LAST_UPDATED_BY]
				       ,R.[LAST_UPDATE_DATE]
				   FROM [dbo].[SSP_ANL_SHIP_REQ_P] AS R WITH(NOLOCK)
				        INNER JOIN SCP_MST_BOD_N_V AS B
					 ON R.DIVISION_ID	= B.division_id
					AND R.BOD_ID		= B.BOD_ID
			      WHERE 1 = 1
			        AND R.[ATTRIBUTE4]		>= @v_data_start_yyyymmdd
			        AND R.[ATTRIBUTE4]		<  @v_data_end_yyyymmdd
			        AND R.[DIVISION_ID]		=  @v_division_id
					AND CONVERT(int, R.[ATTRIBUTE5])    > 0
					AND R.[ATTRIBUTE3]		!= 'N'

			-------------------------------------------------------------------------------------------------------------
			--2-3. Shipment Plan(Measure : SHIP_CONFIRM)
			-------------------------------------------------------------------------------------------------------------
			INSERT INTO #tmp_SSP_ANL_SHIP_PLAN_P
					   ([DIVISION_ID]
					   ,[PLAN_START_YYYYMMDD]
					   ,[FROM_SITE]
					   ,[ITEM_ID]
					   ,[MEASURE]
					   ,[YYYYMMDD]
					   ,[BOD_ID]
					   ,[SHIPTO_CODE]
					   ,[PROJECT_CODE]
					   ,[FCST_TYPE]
					   ,[REQUEST_ID]
					   ,[QTY]
					   ,[FCST_ETD_DATE]
					   ,[FCST_ETA_DATE]
					   ,[ETD_DATE]
					   ,[ETA_DATE]
					   ,[CONFIRM_FLAG]
					   ,[CONFIRM_ID]
					   ,[REQUESTOR]
					   ,[CREATED_BY]
					   ,[CREATION_DATE]
					   ,[LAST_UPDATED_BY]
					   ,[LAST_UPDATE_DATE]
					   )
			     SELECT X.DIVISION_ID  				
					   ,@v_plan_start_yyyymmdd		AS PLAN_START_YYYYMMDD	
					   ,X.FROM_SITE			
					   ,X.ITEM_ID				
					   ,'SHIP_CONFIRM'				AS MEASURE				
					   ,X.YYYYMMDD				
					   ,X.BOD_ID
					   ,X.SHIPTO_CODE
					   ,X.PROJECT_CODE		
					   ,X.FCST_TYPE
					   ,X.REQUEST_ID
					   ,X.QTY
					   ,X.FCST_ETD_DATE	
					   ,X.FCST_ETA_DATE	
					   ,X.ETD_DATE				
					   ,X.ETA_DATE	
					   ,X.CONFIRM_FLAG
					   ,X.REQUEST_ID				AS CONFIRM_ID
					   ,X.REQUESTOR
					   ,X.CREATED_BY
					   ,X.CREATION_DATE
					   ,X.LAST_UPDATED_BY
					   ,X.LAST_UPDATE_DATE
			       FROM (  
				   --     SELECT C.DIVISION_ID  				
					  --        ,C.SCM_SITE_ID AS FROM_SITE			
					  --        ,C.ITEM_ID				
					  --        ,C.SHIP_DATE  AS YYYYMMDD				
					  --        ,'-' AS BOD_ID	
							--  ,'-' AS SHIPTO_CODE
							--  ,'-' AS PROJECT_CODE
					  --        ,C.SHIP_QTY AS QTY						
							--  ,'-' AS FCST_TYPE
					  --        ,NULL AS FCST_ETD_DATE	
					  --        ,NULL AS FCST_ETA_DATE	
					  --        ,NULL AS ETD_DATE				
					  --        ,NULL AS ETA_DATE				
					  --        ,NULL			AS CONFIRM_FLAG		
					  --        ,NULL 	AS REQUEST_ID 	
					  --        ,NULL AS REQUESTOR
					  --        ,C.CREATED_BY
					  --        ,C.CREATION_DATE
					  --        ,C.LAST_UPDATED_BY
					  --        ,C.LAST_UPDATE_DATE
					  --    FROM SCM_DNM_SCS_SHIP_RESULT AS C WITH(NOLOCK) 
						 --      INNER JOIN SCM_MST_SITE AS FS WITH(NOLOCK)
							--ON C.DIVISION_ID = FS.DIVISION_ID
						 --  AND C.SCM_SITE_ID = FS.SCM_SITE_ID
						 --  AND FS.SITE_TYPE = 'PLANT'
						 --  AND FS.OSP_YN = 'Y'
						 --  AND FS.VALID_YN = 'Y'
						 --  AND FS.OPERATION_GROUP = 'P'
					  --   WHERE 1 = 1
			    --           AND C.SHIP_DATE			= @v_data_start_yyyymmdd
					  --     AND C.DIVISION_ID		= @v_division_id
						 --  AND C.LAST_UPDATE_DATE  <= @v_plan_cutoff_datetime
						 --UNION ALL
				        SELECT C.DIVISION_ID  				
					          ,C.FROM_SITE			
					          ,C.ITEM_ID				
					          ,C.YYYYMMDD				
					          ,C.BOD_ID	
							  ,C.TO_SITE_SHIPTO_CODE AS SHIPTO_CODE
							  ,C.PROJECT_CODE
					          ,C.QTY						
							  ,C.FCST_TYPE
					          ,C.FCST_ETD_DATE	
					          ,C.FCST_ETA_DATE	
					          ,C.ETD_DATE				
					          ,C.ETA_DATE				
					          ,'Y'			AS CONFIRM_FLAG		
					          ,C.CONFIRM_ID	AS REQUEST_ID 	
					          ,C.REQUESTOR
					          ,C.CREATED_BY
					          ,C.CREATION_DATE
					          ,C.LAST_UPDATED_BY
					          ,C.LAST_UPDATE_DATE
					      FROM SSP_ANL_SHIP_CONFIRM AS C WITH(NOLOCK) 
						       INNER JOIN SCM_MST_SITE AS FS WITH(NOLOCK)
							ON C.DIVISION_ID = FS.DIVISION_ID
						   AND C.FROM_SITE = FS.SCM_SITE_ID
						   AND FS.SITE_TYPE = 'PLANT'
						   AND FS.OSP_YN = 'Y'
						   AND FS.VALID_YN = 'Y'
						   AND FS.OPERATION_GROUP = 'P'
					     WHERE 1 = 1
			               AND C.YYYYMMDD		>=  @v_data_start_yyyymmdd
			               AND C.YYYYMMDD		<  @v_data_end_yyyymmdd
					       AND C.CHANGE_TYPE	= 'C' -- 확정
					       AND C.DIVISION_ID	= @v_division_id
						   AND C.CONFIRM_ID		LIKE 'R%'
					     UNION ALL 
					--확정기간 이후 출하요청 
				        SELECT R.DIVISION_ID  				
					          ,R.FROM_SITE			
					          ,R.ITEM_ID				
					          ,R.YYYYMMDD				
					          ,R.BOD_ID	
							  ,R.SHIPTO_CODE
							  ,R.PROJECT_CODE
					          ,R.QTY						
							  ,R.FCST_TYPE
					          ,R.FCST_ETD_DATE	
					          ,R.FCST_ETA_DATE	
					          ,R.ETD_DATE				
					          ,R.ETA_DATE				
					          ,'N'				AS CONFIRM_FLAG		
					          ,R.CONFIRM_ID		AS REQUEST_ID 	
					          ,R.REQUESTOR
					          ,R.CREATED_BY
					          ,R.CREATION_DATE
					          ,R.LAST_UPDATED_BY
					          ,R.LAST_UPDATE_DATE
					      FROM #tmp_SSP_ANL_SHIP_PLAN_P AS R 
						       INNER JOIN SCM_MST_SITE AS FS WITH(NOLOCK)
							ON R.DIVISION_ID = FS.DIVISION_ID
						   AND R.FROM_SITE = FS.SCM_SITE_ID
						   AND FS.SITE_TYPE = 'PLANT'
						   AND FS.OSP_YN = 'Y'
						   AND FS.VALID_YN = 'Y'
						   AND FS.OPERATION_GROUP = 'P'
					     WHERE 1 = 1 
					       AND R.MEASURE		= 'SHIP_REQ'
						   -- 확정구간 7일 운영(D-1 ~ + 7)
					       --AND R.YYYYMMDD		> CONVERT(VARCHAR, DATEADD(D, 7 , CONVERT(DATETIME, @v_data_start_yyyymmdd ,112)) ,112)
						   AND R.YYYYMMDD       >= CONVERT(CHAR(8), DATEADD(DAY, ISNULL(FS.SHIP_FROZEN, 7) , CONVERT(DATETIME, @v_plan_start_yyyymmdd ,112)), 112)
					       AND R.YYYYMMDD		< @v_data_end_yyyymmdd 
					       AND R.DIVISION_ID	= @v_division_id
				        ) X


			-------------------------------------------------------------------------------------------------------------
			--2-4. Production (Measure : PROD_PLAN)
			-------------------------------------------------------------------------------------------------------------
			INSERT INTO #tmp_SSP_ANL_SHIP_PLAN_P
					   ([DIVISION_ID]
					   ,[PLAN_START_YYYYMMDD]
					   ,[FROM_SITE]
					   ,[ITEM_ID]
					   ,[MEASURE]
					   ,[YYYYMMDD]
					   ,[BOD_ID]
					   ,[SHIPTO_CODE]
					   ,[PROJECT_CODE]
					   ,[FCST_TYPE]
					   ,[QTY]
					   ,[CREATED_BY]
					   ,[CREATION_DATE]
					   ,[LAST_UPDATED_BY]
					   ,[LAST_UPDATE_DATE]
					   )
                 SELECT DIVISION_ID
					   ,@v_plan_start_yyyymmdd		AS PLAN_START_YYYYMMDD	
				       ,SCM_SITE_ID
					   ,ITEM_ID
					   ,'PROD_PLAN'
					   ,PROD_DATE
					   ,'-' AS BOD_ID
					   ,'-' AS SHIPTO_CODE
					   ,'-' AS PROJECT_CODE
					   ,'-' AS FCST_TYPE
					   ,SUM(PROD_QTY)
					   ,@v_batch_user
					   ,getdate()
					   ,@v_batch_user
					   ,getdate()
                   FROM (
       --                 SELECT C.DIVISION_ID, C.SCM_SITE_ID, C.ITEM_ID, NULL AS LINE_ID, NULL AS PLAN_OPERATION, NULL AS PLAN_TYPE, NULL AS SHIFT, C.PROD_DATE, C.CUTOFF_DATE, C.PROD_QTY
					  --    FROM SCM_DNM_SCS_PROD_RESULT AS C WITH(NOLOCK) 
						 --      INNER JOIN SCM_MST_SITE AS FS WITH(NOLOCK)
							--ON C.DIVISION_ID = FS.DIVISION_ID
						 --  AND C.SCM_SITE_ID = FS.SCM_SITE_ID
						 --  AND FS.SITE_TYPE = 'PLANT'
						 --  AND FS.OSP_YN = 'Y'
						 --  AND FS.VALID_YN = 'Y'
						 --  AND FS.OPERATION_GROUP = 'P'
					  --   WHERE 1 = 1
			    --           AND C.PROD_DATE			= @v_data_start_yyyymmdd
					  --     AND C.DIVISION_ID			= @v_division_id
						 --  AND C.LAST_UPDATE_DATE		<= @v_plan_cutoff_datetime
       --                  UNION ALL
                        SELECT X.DIVISION_ID, X.SCM_SITE_ID, X.ITEM_ID, X.LINE_ID, X.PLAN_OPERATION, X.PLAN_TYPE, X.SHIFT, X.PROD_DATE, X.CUTOFF_DATE, X.PROD_QTY
                          FROM SCM_DNM_SCS_PROD_PLAN AS X WITH(NOLOCK)
                               INNER JOIN (
	                                      SELECT DIVISION_ID, SCM_SITE_ID, ITEM_ID, LINE_ID, PLAN_OPERATION, PLAN_TYPE, SHIFT, PROD_DATE, MAX(CUTOFF_DATE) AS CUTOFF_DATE
	                                        FROM SCM_DNM_SCS_PROD_PLAN WITH(NOLOCK)
	                                       WHERE 1 = 1
										     AND PROD_DATE		>= @v_data_start_yyyymmdd
			                                 AND PROD_DATE		< @v_data_end_yyyymmdd
	                                         AND DIVISION_ID	= @v_division_id
	                                       GROUP BY DIVISION_ID, SCM_SITE_ID, ITEM_ID, LINE_ID, PLAN_OPERATION, PLAN_TYPE, SHIFT, PROD_DATE
	                                      ) AS Y
	                        ON X.DIVISION_ID = Y.DIVISION_ID
	                       AND X.SCM_SITE_ID = Y.SCM_SITE_ID
	                       AND X.ITEM_ID = Y.ITEM_ID
	                       AND X.LINE_ID = Y.LINE_ID
	                       AND X.PLAN_OPERATION = Y.PLAN_OPERATION
	                       AND X.PLAN_TYPE = Y.PLAN_TYPE
	                       AND X.SHIFT = Y.SHIFT
	                       AND X.PROD_DATE = Y.PROD_DATE
	                       AND X.CUTOFF_DATE = Y.CUTOFF_DATE
	                       AND X.PROD_QTY > 0
	                    ) AS Z
	              GROUP BY 
					    DIVISION_ID
					   ,SCM_SITE_ID
					   ,ITEM_ID
					   ,PROD_DATE

 			-------------------------------------------------------------------------------------------------------------
			--2-5. 존재하지 않는 일자의 경우, 해당 MEASURE를 0으로 추가
			-------------------------------------------------------------------------------------------------------------
 			DECLARE @X_INT        INT		= 1;
			DECLARE @X_MEASURE    NVARCHAR(100);

			WHILE @X_INT <= 4
			BEGIN

			    SELECT @X_MEASURE = ( CASE @X_INT WHEN 1 THEN 'SHIP_REQ'
				                                  WHEN 2 THEN 'SHIP_RTF'
												  WHEN 3 THEN 'SHIP_CONFIRM'
												  WHEN 4 THEN 'PROD_PLAN'
								       END);

				INSERT INTO #tmp_SSP_ANL_SHIP_PLAN_P
				      (
				       [PLAN_START_YYYYMMDD]
				      ,[MEASURE]
				      ,[DIVISION_ID]
				      ,[FROM_SITE]
				      ,[ITEM_ID]
				      ,[YYYYMMDD]
					  ,[BOD_ID]
					  ,[SHIPTO_CODE]
					  ,[PROJECT_CODE]
					  ,[FCST_TYPE]
					  ,[QTY]
					  ,[CREATED_BY]
					  ,[CREATION_DATE]
					  ,[LAST_UPDATED_BY]
					  ,[LAST_UPDATE_DATE]
				      )
			    SELECT
					   SUB.PLAN_START_YYYYMMDD
                      ,SUB.MEASURE
					  ,SUB.DIVISION_ID
					  ,SUB.FROM_SITE
					  ,SUB.ITEM_ID
					  ,SUB.YYYYMMDD
					  ,SUB.BOD_ID
					  ,SUB.SHIPTO_CODE
					  ,SUB.PROJECT_CODE
					  ,SUB.FCST_TYPE
					  ,0        AS QTY
					  ,@v_batch_user
					  ,getdate()
					  ,@v_batch_user
					  ,getdate()
				  FROM (
					   SELECT PLAN_START_YYYYMMDD
							 ,@X_MEASURE  AS MEASURE
							 ,DIVISION_ID
							 ,FROM_SITE
							 ,ITEM_ID
							 ,YYYYMMDD
							 ,'-'	AS BOD_ID
							 ,'-'   AS SHIPTO_CODE
							 ,'-'	AS PROJECT_CODE
							 ,'-'	AS FCST_TYPE
						 FROM (
							  SELECT C.BASIS_YYYYMMDD AS YYYYMMDD
								FROM SCM_SYS_CALENDAR_M AS C WITH(NOLOCK)
							   WHERE 1 = 1
								 AND C.BASIS_YYYYMMDD >= @v_data_start_yyyymmdd
								 AND C.BASIS_YYYYMMDD <  @v_data_end_yyyymmdd
							  ) A,
							  (
							  SELECT DISTINCT
									 PLAN_START_YYYYMMDD
									,DIVISION_ID
									,FROM_SITE
									,ITEM_ID
								FROM #tmp_SSP_ANL_SHIP_PLAN_P AS X 
							  ) B
					   ) SUB
				 WHERE 1 = 1
				   AND NOT EXISTS (
								  SELECT 'X'
									FROM #tmp_SSP_ANL_SHIP_PLAN_P AS Z 
								   WHERE 1 = 1
									 AND Z.PLAN_START_YYYYMMDD		= SUB.PLAN_START_YYYYMMDD
									 AND Z.DIVISION_ID				= SUB.DIVISION_ID
									 AND Z.FROM_SITE				= SUB.FROM_SITE
									 AND Z.ITEM_ID					= SUB.ITEM_ID
									 AND Z.MEASURE					= SUB.MEASURE
									 AND Z.YYYYMMDD					= SUB.YYYYMMDD
								  )
					;

				SET @X_INT = @X_INT + 1;
			END  ;


			-------------------------------------------------------------------------------------------------------------
			--2-6. WH_STOCK
			-------------------------------------------------------------------------------------------------------------
            WITH BOH AS (
			     SELECT
				       SUB.PLAN_START_YYYYMMDD
				      ,SUB.DIVISION_ID
				      ,SUB.FROM_SITE
				      ,SUB.ITEM_ID
				      ,SUB.BOH_QTY
			      FROM (
				       SELECT A.PLAN_START_YYYYMMDD
						     ,A.DIVISION_ID
						     ,A.FROM_SITE
						     ,A.ITEM_ID
							 ,ISNULL(B.STOCK_QTY, 0) AS BOH_QTY
					     FROM (
							  SELECT DISTINCT
									 PLAN_START_YYYYMMDD
									,DIVISION_ID
									,FROM_SITE
									,ITEM_ID
								FROM #tmp_SSP_ANL_SHIP_PLAN_P AS X
						      ) A
						      LEFT OUTER JOIN
						      (
							  SELECT @v_plan_start_yyyymmdd		AS PLAN_START_YYYYMMDD
							       , DIVISION_ID
							       , SCM_SITE_ID                AS FROM_SITE
								   , ITEM_ID                    AS MODEL_ID
								   , SUM(STOCK_QTY)             AS STOCK_QTY
								FROM SCM_DNM_SCS_STOCK WITH(NOLOCK)
							   WHERE DIVISION_ID		= @v_division_id
							     AND CUTOFF_DATE		= @v_plan_stock_yyyymmdd
								 AND LAST_UPDATE_DATE  <= @v_plan_cutoff_datetime
							  GROUP BY 
							        DIVISION_ID
								  , SCM_SITE_ID
								  , ITEM_ID
						     ) B
					      ON A.PLAN_START_YYYYMMDD	= B.PLAN_START_YYYYMMDD
					     AND A.DIVISION_ID			= B.DIVISION_ID
					     AND A.FROM_SITE			= B.FROM_SITE
					     AND A.ITEM_ID				= B.MODEL_ID
				       ) SUB
			     WHERE 1 = 1
				 ),
				 Z AS (
				 SELECT PLAN_START_YYYYMMDD
					   ,DIVISION_ID
					   ,FROM_SITE
					   ,ITEM_ID
					   ,YYYYMMDD
				   FROM #tmp_SSP_ANL_SHIP_PLAN_P AS X
				  WHERE 1 = 1
					AND MEASURE = 'SHIP_REQ'
				  GROUP BY
						PLAN_START_YYYYMMDD
					   ,DIVISION_ID
					   ,FROM_SITE
					   ,ITEM_ID
					   ,YYYYMMDD
				  )

				INSERT INTO #tmp_SSP_ANL_SHIP_PLAN_P
				      (
				       [PLAN_START_YYYYMMDD]
				      ,[MEASURE]
				      ,[DIVISION_ID]
				      ,[FROM_SITE]
				      ,[ITEM_ID]
				      ,[YYYYMMDD]
					  ,[BOD_ID]
					  ,[SHIPTO_CODE]
					  ,[PROJECT_CODE]
					  ,[FCST_TYPE]
					  ,[QTY]
					  ,[CREATED_BY]
					  ,[CREATION_DATE]
					  ,[LAST_UPDATED_BY]
					  ,[LAST_UPDATE_DATE]				      
					  )
			    SELECT
				       Z.[PLAN_START_YYYYMMDD]
				      ,'WH_STOCK'
				      ,Z.[DIVISION_ID]
				      ,Z.[FROM_SITE]
				      ,Z.[ITEM_ID]
				      ,Z.[YYYYMMDD]
				      ,'-' AS [BOD_ID]
				      ,'-' AS [SHIPTO_ID]
				      ,'-' AS [PROJECT_CODE]
				      ,'-' AS [FCST_TYPE]
				      ,ISNULL(B.BOH_QTY, 0)
					   + (
					     SELECT ISNULL( SUM( CASE WHEN T.MEASURE = 'PROD_PLAN'     THEN ISNULL(T.QTY,0)
												  WHEN T.MEASURE = 'SHIP_CONFIRM' THEN ISNULL(T.QTY,0) * -1
												  ELSE 0.0 END
									  ), 0)
						  FROM #tmp_SSP_ANL_SHIP_PLAN_P AS T
						 WHERE 1 = 1
						   AND T.PLAN_START_YYYYMMDD	= Z.PLAN_START_YYYYMMDD
						   AND T.DIVISION_ID			= Z.DIVISION_ID
						   AND T.FROM_SITE				= Z.FROM_SITE
						   AND T.ITEM_ID				= Z.ITEM_ID
 						   AND T.MEASURE				IN ('SHIP_CONFIRM', 'PROD_PLAN')
						   AND T.YYYYMMDD				>= @v_data_start_yyyymmdd
						   AND T.YYYYMMDD				<= Z.YYYYMMDD
                         )
					  ,@v_batch_user
					  ,getdate()
					  ,@v_batch_user
					  ,getdate()
				  FROM Z WITH(NOLOCK)
				       LEFT OUTER JOIN BOH AS B WITH(NOLOCK)
					ON Z.PLAN_START_YYYYMMDD	= B.PLAN_START_YYYYMMDD
				   AND Z.DIVISION_ID			= B.DIVISION_ID
				   AND Z.FROM_SITE				= B.FROM_SITE
				   AND Z.ITEM_ID				= B.ITEM_ID
				 WHERE 1 = 1
				 ORDER BY
				       Z.YYYYMMDD
				 ;

			-------------------------------------------------------------------------------------------------------------
			--2-7. BALANCE
			-------------------------------------------------------------------------------------------------------------
            WITH Z AS (
				 SELECT PLAN_START_YYYYMMDD
					   ,DIVISION_ID
					   ,FROM_SITE
					   ,ITEM_ID
					   ,YYYYMMDD
				   FROM #tmp_SSP_ANL_SHIP_PLAN_P AS X
				  WHERE 1 = 1
					AND MEASURE = 'SHIP_REQ'
				  GROUP BY
						PLAN_START_YYYYMMDD
					   ,DIVISION_ID
					   ,FROM_SITE
					   ,ITEM_ID
					   ,YYYYMMDD
				  )

				 INSERT INTO #tmp_SSP_ANL_SHIP_PLAN_P
				      (
				       [PLAN_START_YYYYMMDD]
				      ,[MEASURE]
				      ,[DIVISION_ID]
				      ,[FROM_SITE]
				      ,[ITEM_ID]
				      ,[YYYYMMDD]
					  ,[BOD_ID]
					  ,[SHIPTO_CODE]
					  ,[PROJECT_CODE]
					  ,[FCST_TYPE]
					  ,[QTY]
					  ,[CREATED_BY]
					  ,[CREATION_DATE]
					  ,[LAST_UPDATED_BY]
					  ,[LAST_UPDATE_DATE]				      
					  )
			    SELECT
				       Z.[PLAN_START_YYYYMMDD]
				      ,'BALANCE'
				      ,Z.[DIVISION_ID]
				      ,Z.[FROM_SITE]
				      ,Z.[ITEM_ID]
				      ,Z.[YYYYMMDD]
				      ,'-' AS [BOD_ID]
				      ,'-' AS [SHIPTO_ID]
				      ,'-' AS [PROJECT_CODE]
				      ,'-' AS [FCST_TYPE]
				      ,(
					     SELECT ISNULL( SUM( CASE WHEN T.MEASURE = 'SHIP_CONFIRM' THEN ISNULL(T.QTY,0) * -1
						                          WHEN T.MEASURE = 'WH_STOCK' THEN ISNULL(T.QTY,0)
												  ELSE 0.0 END
												 ) ,0)
						  FROM #tmp_SSP_ANL_SHIP_PLAN_P AS T
						 WHERE 1 = 1
						   AND T.PLAN_START_YYYYMMDD	= Z.PLAN_START_YYYYMMDD
						   AND T.DIVISION_ID			= Z.DIVISION_ID
						   AND T.FROM_SITE				= Z.FROM_SITE
						   AND T.ITEM_ID				= Z.ITEM_ID
 						   AND T.MEASURE				IN ('SHIP_CONFIRM', 'WH_STOCK')
						   AND T.YYYYMMDD				= Z.YYYYMMDD
                         )
					  ,@v_batch_user
					  ,getdate()
					  ,@v_batch_user
					  ,getdate()
				  FROM Z WITH(NOLOCK)
				 WHERE 1 = 1
				 ORDER BY
				       Z.YYYYMMDD
				 ;
	
 		-------------------------------------------------------------------------------------------------------------
		--3. 최종 SSP_ANL_SHIP_PLAN_P 생성
		-------------------------------------------------------------------------------------------------------------
        DELETE
		  FROM  SSP_ANL_SHIP_PLAN_P
         WHERE 1 = 1
		   AND DIVISION_ID = @v_division_id
           AND PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
        ;

        INSERT INTO dbo.SSP_ANL_SHIP_PLAN_P
				   (
			        [DIVISION_ID]
			       ,[PLAN_START_YYYYMMDD]
			       ,[FROM_SITE]
			       ,[ITEM_ID]
			       ,[MEASURE]
			       ,[YYYYMMDD]
			       ,[BOD_ID]
			       ,[SHIPTO_CODE]
			       ,[PROJECT_CODE]
			       ,[FCST_TYPE]
			       ,[REQUEST_ID]
			       ,[QTY]
			       ,[FCST_ETD_DATE]
			       ,[FCST_ETA_DATE]
			       ,[ETD_DATE]
			       ,[ETA_DATE]
				   ,[CONFIRM_FLAG]
				   ,[CONFIRM_ID]
				   ,[REQUESTOR]
			       ,[CREATED_BY]
			       ,[CREATION_DATE]
			       ,[LAST_UPDATED_BY]
			       ,[LAST_UPDATE_DATE]
			       )
			 SELECT
			        P.[DIVISION_ID]
			       ,P.[PLAN_START_YYYYMMDD]
			       ,P.[FROM_SITE]
			       ,P.[ITEM_ID]
			       ,P.[MEASURE]
			       ,P.[YYYYMMDD]
			       ,P.[BOD_ID]
			       ,P.[SHIPTO_CODE]
			       ,P.[PROJECT_CODE]
			       ,P.[FCST_TYPE]
			       ,P.[REQUEST_ID]
			       ,P.[QTY]
			       ,P.[FCST_ETD_DATE]
			       ,P.[FCST_ETA_DATE]
			       ,P.[ETD_DATE]
			       ,P.[ETA_DATE]
				   ,P.[CONFIRM_FLAG]
				   ,P.[CONFIRM_ID]
				   ,P.[REQUESTOR]
			       ,P.[CREATED_BY]
			       ,P.[CREATION_DATE]
			       ,P.[LAST_UPDATED_BY]
			       ,P.[LAST_UPDATE_DATE]
               FROM #tmp_SSP_ANL_SHIP_PLAN_P AS P
			;

 		-------------------------------------------------------------------------------------------------------------
		--3. LOOKUP 처리
		-------------------------------------------------------------------------------------------------------------
        UPDATE SCM_ADM_LOOKUP_MASTER_DETAIL
	       SET ATTRIBUTE1		= @v_plan_start_yyyymmdd
		      ,LAST_UPDATED_BY	= @v_batch_user
			  ,LAST_UPDATE_DATE = getdate()
         WHERE LOOKUP_TYPE		= 'SSP_ANL_SHIP_PLAN_P'
	       AND SEGMENT1			= @v_division_id
		   AND VALID_YN			= 'Y'
		;

        IF @@TRANCOUNT > 0
        BEGIN
            COMMIT TRAN TX_SH;
        END; 
 		-----------------------------------------------------------
		-- TXN LOG
		-----------------------------------------------------------
		SET @v_log_type		= N'TXN';    --로그타입
		SET @n_log_count	= @@ROWCOUNT;
		SET @v_log_message	= N'INSERT INTO '+ @v_table_id;
		SET @v_description	= N'Process Complete...' + ':' + CONVERT(CHAR(23) ,@d_event_date ,121) + ' [DIVISION]: ' + @v_division_id ;
		SET @d_event_date	= SYSDATETIME();

		EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
								  ,@p_log_type      = @v_log_type
								  ,@p_log_count     = @n_log_count
								  ,@p_log_message   = @v_log_message
								  ,@p_description   = @v_description
								  ,@p_event_date    = @d_event_date
								  ,@p_user_id       = @v_batch_user
								  ;

    END TRY

    BEGIN CATCH

        IF @@TRANCOUNT > 0
        BEGIN
          ROLLBACK TRAN TX_SH
        END;

 		-----------------------------------------------------------
		-- ERROR LOG
		-----------------------------------------------------------
		SET @v_log_type		= N'ERROR';
		SET @v_log_message	= CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
		SET @v_description	= N'ERROR_LINE : ' + STR(ERROR_LINE());
		SET @d_event_date	= SYSDATETIME();

		EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
								  ,@p_log_type      = @v_log_type
								  ,@p_log_count     = @n_log_count
								  ,@p_log_message   = @v_log_message
								  ,@p_description   = @v_description
								  ,@p_event_date    = @d_event_date
								  ,@p_user_id       = @v_batch_user
								  ;

		IF OBJECT_ID('tempdb..#tmp_SSP_ANL_SHIP_PLAN_P') IS NOT NULL
			DROP TABLE #tmp_SSP_ANL_SHIP_PLAN_P

		RETURN -1

    END CATCH;

  	-----------------------------------------------------------
	-- END LOG
	-----------------------------------------------------------
    SET @v_log_type		= N'END';
    SET @v_log_message	= N'########## END of procedure ##########';
    SET @v_description	= N'';
    SET @d_event_date	= SYSDATETIME();

    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
							  ,@p_log_type      = @v_log_type
							  ,@p_log_count     = @v_insert_sum
							  ,@p_log_message   = @v_log_message
							  ,@p_description   = @v_description
							  ,@p_event_date    = @d_event_date
							  ,@p_user_id       = @v_batch_user
							  ;


	IF OBJECT_ID('tempdb..#tmp_SSP_ANL_SHIP_PLAN_P') IS NOT NULL
        DROP TABLE #tmp_SSP_ANL_SHIP_PLAN_P

    RETURN 1

END;
