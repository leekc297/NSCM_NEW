

/*
 * Program ID   : PR_SSP_ANL_ESS_PLAN_CUTOFF
 * Description  : ESS_PLAN CUTOFF 정보 생성(Monthly BOH 생성시)
 * OutTable     :
 * Execute      : PR_SSP_ANL_ESS_PLAN_CUTOFF null, null
 * Program History
 *===================================================================================================
 *  Date         In Charge      Description
 *===================================================================================================
 *  2021.03.22   SSP Pjt.       Create.
  * 2021.09.01   SSP Pjt.       SCP_MST_BOD_N_V 적용
 *  2024.10.01   KHJ            NERP_SSP 
 */

CREATE PROCEDURE [dbo].[PR_SSP_ANL_ESS_PLAN_CUTOFF]
(
      @p_division_id              NVARCHAR(10)
	 ,@p_plan_start_yyyymmdd      NVARCHAR(8)
)
AS
BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    --SET ANSI_WARNINGS OFF;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user				NVARCHAR(150)	= N'ssp_batch';
    DECLARE @v_program_name				NVARCHAR(150)	= N'PR_SSP_ANL_ESS_PLAN_CUTOFF';
    DECLARE @v_log_type					NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count				INTEGER = 0;
    DECLARE @v_log_message				NVARCHAR(1000);
    DECLARE @v_description				NVARCHAR(500);      --상세설명
    DECLARE @v_table_id					NVARCHAR(150)	= N'SSP_ANL_ESS_PLAN'; --테이블 필수
    DECLARE @d_event_date				DATETIME;
    DECLARE @v_insert_cnt				INTEGER = 0;
	DECLARE @v_insert_sum				INTEGER = 0;

	-- NERP 매핑코드
    DECLARE @v_KR012031 NVARCHAR(20);
    DECLARE @v_Storage_6006 NVARCHAR(20);
	SET @v_KR012031 = dbo.FN_GET_LOOKUP_VALUE('PR_SSP_ANL_ESS_PLAN_CUTOFF'  ,'KR012031P')
	SET @v_Storage_6006 = dbo.FN_GET_LOOKUP_VALUE('PR_SSP_ANL_ESS_PLAN_CUTOFF'  ,'STORAGE_6006')

	DECLARE @v_division_id				NVARCHAR(30)	= '';
    DECLARE @v_plan_start_yyyymmdd		NVARCHAR(8)		= '';
    DECLARE @v_plan_cutoff_yyyymmdd		NVARCHAR(8)		= '';
    DECLARE @v_data_start_yyyymmdd		NVARCHAR(8)		= '';
	DECLARE @v_data_end_yyyymmdd		NVARCHAR(8)		= '';
	DECLARE @v_storage_id               NVARCHAR(10)	= @v_Storage_6006  --'6006';

	IF @p_division_id IS NULL
		SET @v_division_id = '82';
    ELSE
   	    SET @v_division_id =  @p_division_id ;

	IF @p_plan_start_yyyymmdd IS NULL
		SET @v_plan_start_yyyymmdd = CONVERT(varchar, getdate(), 112);
	ELSE
		SET @v_plan_start_yyyymmdd = @p_plan_start_yyyymmdd;

	 SELECT @v_plan_cutoff_yyyymmdd = X.ATTRIBUTE1
       FROM SCM_ADM_LOOKUP_MASTER_DETAIL AS X WITH(NOLOCK)
      WHERE X.LOOKUP_TYPE	= 'SSP_ANL_ESS_PLAN'
	    AND X.SEGMENT1		= @v_division_id
		AND X.VALID_YN		= 'Y'

	IF @v_plan_start_yyyymmdd <= @v_plan_cutoff_yyyymmdd
		RETURN 0;

	-- DATA 생성 FROM ~ TO
	SET @v_data_start_yyyymmdd = @v_plan_cutoff_yyyymmdd ;
	SET @v_data_end_yyyymmdd   = CONVERT(VARCHAR, DATEADD(D, 84, CONVERT(DATETIME, @v_data_start_yyyymmdd ,112)) ,112) ; --12주(84일)

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

        -------------------------------------------------------------------------------------------------------------
        --1. BOH Data
        -------------------------------------------------------------------------------------------------------------
		DELETE
		  FROM [dbo].[SSP_ANL_ESS_STOCK]
		 WHERE PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd

		INSERT INTO [dbo].[SSP_ANL_ESS_STOCK]
		      (PLAN_START_YYYYMMDD
			  ,COMPANY_ID
			  ,DIVISION_ID
			  ,SITE_ID
			  ,PLANT_ID
			  ,STORAGE_ID
			  ,CUTOFF_DATE
			  ,ITEM_ID
			  ,INV_QTY
			  ,REMAIN_QTY
			  ,UOM
			  ,CREATED_BY
			  ,CREATION_DATE
			  ,LAST_UPDATED_BY
			  ,LAST_UPDATE_DATE
			  )
		SELECT @v_plan_start_yyyymmdd
		      ,S.COMPANY_ID
		      ,S.DIVISION_ID
			  ,S.SITE_ID
			  ,S.PLANT_ID
			  ,S.STORAGE_ID
			  ,CONVERT(NVARCHAR, S.CUTOFF_DATE, 112)
			  ,S.ITEM_ID
			  ,S.QTY2
			  ,S.QTY2
			  ,S.QTY_UOM
			  ,@v_batch_user
			  ,getdate()
			  ,@v_batch_user
			  ,getdate()
		  FROM [dbo].SCM_DNM_STOCK_SN S WITH(NOLOCK)
			   JOIN dbo.SCM_MST_ITEM_SN AS M WITH(NOLOCK)
		    ON S.COMPANY_ID = M.COMPANY_ID
		   AND S.DIVISION_ID = M.DIVISION_ID
		   AND S.SITE_ID = M.SITE_ID
		   AND S.ITEM_ID = M.ITEM_ID
		 WHERE S.CUTOFF_DATE = (SELECT MAX(CUTOFF_DATE)
								  FROM [dbo].SCM_DNM_STOCK_SN S WITH(NOLOCK)
								 WHERE S.STOCK_TYPE		= 'INVENTORY'
								   AND S.CUTOFF_DATE	> getdate() -30
								   AND S.DIVISION_ID	= @v_division_id
								   AND S.STORAGE_ID		= @v_Storage_6006	--'6006'  --6011, 6012 추가
							   )
		  AND S.STOCK_TYPE	= 'INVENTORY'
		  --AND S.STORAGE_ID	IN ('6006', '6011', '6012')
		  AND S.STORAGE_ID	= @v_Storage_6006		--'6006'
		  AND M.ITEM_TYPE	= 'Q'
		  AND S.DIVISION_ID = @v_division_id

        -------------------------------------------------------------------------------------------------------------
        --2. MEASURE별 Data생성
        -------------------------------------------------------------------------------------------------------------
        --temp 테이블 생성 : Measure까지 생성후 마지막에 한번에 입력하기 위해서
        IF OBJECT_ID('tempdb..#tmp_SSP_ANL_ESS_PLAN') IS NOT NULL
            DROP TABLE #tmp_SSP_ANL_ESS_PLAN

			CREATE TABLE #tmp_SSP_ANL_ESS_PLAN(
				 [PLAN_START_YYYYMMDD]	[nvarchar](8)
				,[MEASURE]				[nvarchar](50)
				,[DIVISION_ID]			[nvarchar](10)
				,[PROJECT_CODE]			[nvarchar](50)
				,[ITEM_ID]				[nvarchar](50)
				,[SCM_SITE_ID]			[nvarchar](50)
				,[PLANT_SITE_ID]		[nvarchar](50)
				,[DOM_EXP]				[nvarchar](6)
				,[FCST_TYPE]			[nvarchar](50)
				,[INCOTERMS]			[nvarchar](20)
				,[YYYYMMDD]				[nvarchar](8)
				,[CONFIRM_ID]			[nvarchar](20)
				,[QTY]					[numeric](20, 10)  default 0
				,[UOM]					[nvarchar](10)
				,[INV_ALLO_QTY]         [numeric](20, 10)  default 0
				,[DM_REQ_NO]			[nvarchar](60)
				,[PR_NO]				[nvarchar](50)
				,[PO_NO]				[nvarchar](50)
            );

			-------------------------------------------------------------------------------------------------------------
			--2-1. BNP_IN(MKT_FCST)
			-------------------------------------------------------------------------------------------------------------
			INSERT INTO #tmp_SSP_ANL_ESS_PLAN
				  (
				   [PLAN_START_YYYYMMDD]
				  ,[MEASURE]
				  ,[DIVISION_ID]
				  ,[PROJECT_CODE]
				  ,[ITEM_ID]
				  ,[SCM_SITE_ID]
				  ,[PLANT_SITE_ID]
				  ,[DOM_EXP]
				  ,[FCST_TYPE]
				  ,[INCOTERMS]
				  ,[YYYYMMDD]
				  ,[CONFIRM_ID]
				  ,[QTY]
				  ,[UOM]
				  ,[DM_REQ_NO]
				  ,[PR_NO]
				  ,[PO_NO]
				  )
			SELECT
				   @v_plan_cutoff_yyyymmdd  AS PLAN_START_YYYYMMDD
				  ,'BNP_IN'
				  ,R.[DIVISION_ID]
				  ,R.[PROJECT_CODE]
				  ,R.[ITEM_ID]
				  ,R.[SCM_SITE_ID]
--				  ,CASE WHEN R.[PLANT_SITE_ID] IS NULL OR R.[PLANT_SITE_ID] = '' THEN 'KR012031-P' ELSE R.[PLANT_SITE_ID] END AS [PLANT_SITE_ID]		--PeopleWorks-KR-2
				  ,CASE WHEN R.[PLANT_SITE_ID] IS NULL OR R.[PLANT_SITE_ID] = '' THEN @v_KR012031 ELSE R.[PLANT_SITE_ID] END AS [PLANT_SITE_ID]		--PeopleWorks-KR-2
				  ,R.[DOM_EXP]
				  ,R.[FCST_TYPE]
				  ,R.[INCOTERMS]
				  ,R.[YYYYMMDD]
				  ,ISNULL(R.ATTRIBUTE9,'-') AS CONFIRM_ID
				  ,R.QTY AS [PLAN_QTY]
				  ,M.ITEM_UOM AS [UOM]
				  ,'-' AS DM_REQ_NO
				  ,'-' AS PR_NO
				  ,'-' AS PO_NO
			  FROM DM_PLN_MKT_FCST R WITH(NOLOCK)
			       INNER JOIN DM_MST_ITEM_SINGLE_V M WITH(NOLOCK)
				ON R.DIVISION_ID = M.DIVISION_ID
			   AND R.ITEM_ID       = M.ITEM_ID
			 WHERE 1 = 1
			   AND R.YYYYMMDD	>= @v_data_start_yyyymmdd
			   AND R.YYYYMMDD	 < @v_data_end_yyyymmdd
			   AND R.DIVISION_ID = @v_division_id
			   AND R.MEASURE     = 'BNPIn'

			-------------------------------------------------------------------------------------------------------------
			--2-2. REQ
			-------------------------------------------------------------------------------------------------------------
			INSERT INTO #tmp_SSP_ANL_ESS_PLAN
				  (
				   [PLAN_START_YYYYMMDD]
				  ,[MEASURE]
				  ,[DIVISION_ID]
				  ,[PROJECT_CODE]
				  ,[ITEM_ID]
				  ,[SCM_SITE_ID]
				  ,[PLANT_SITE_ID]
				  ,[DOM_EXP]
				  ,[FCST_TYPE]
				  ,[INCOTERMS]
				  ,[YYYYMMDD]
				  ,[CONFIRM_ID]
				  ,[QTY]
				  ,[UOM]
				  ,[INV_ALLO_QTY]
				  ,[DM_REQ_NO]
				  ,[PR_NO]
				  ,[PO_NO]
				  )
			SELECT
				   @v_plan_cutoff_yyyymmdd  AS PLAN_START_YYYYMMDD
				  ,'REQ'
				  ,[DIVISION_ID]
				  ,[PROJECT_CODE]
				  ,[ITEM_ID]
				  ,[SCM_SITE_ID]
--				  ,CASE WHEN [PLANT_SITE_ID] IS NULL OR [PLANT_SITE_ID] = '' THEN 'KR012031-P' ELSE [PLANT_SITE_ID] END AS [PLANT_SITE_ID]		--PeopleWorks-KR-2
				  ,CASE WHEN [PLANT_SITE_ID] IS NULL OR [PLANT_SITE_ID] = '' THEN @v_KR012031 ELSE [PLANT_SITE_ID] END AS [PLANT_SITE_ID]		--PeopleWorks-KR-2
				  ,[DOM_EXP]
				  ,[FCST_TYPE]
				  ,[INCOTERMS]
				  ,[YYYYMMDD]
				  ,'-' AS CONFIRM_ID
				  ,[PLAN_QTY]
				  ,[UOM]
				  ,[INV_ALLO_QTY]
				  ,[DM_REQ_NO]
				  ,'-' AS PR_NO
				  ,'-' AS PO_NO
			  FROM [dbo].[SSP_ANL_ESS_REQ] R WITH(NOLOCK)
		     WHERE 1 = 1
			   AND R.YYYYMMDD	>= @v_data_start_yyyymmdd
			   AND R.YYYYMMDD	 < @v_data_end_yyyymmdd
			   AND R.DIVISION_ID = @v_division_id

			-------------------------------------------------------------------------------------------------------------
			--2-3. PR
			-------------------------------------------------------------------------------------------------------------
			INSERT INTO #tmp_SSP_ANL_ESS_PLAN
				  (
				   [PLAN_START_YYYYMMDD]
				  ,[MEASURE]
				  ,[DIVISION_ID]
				  ,[PROJECT_CODE]
				  ,[ITEM_ID]
				  ,[SCM_SITE_ID]
				  ,[PLANT_SITE_ID]
				  ,[DOM_EXP]
				  ,[FCST_TYPE]
				  ,[INCOTERMS]
				  ,[YYYYMMDD]
				  ,[CONFIRM_ID]
				  ,[QTY]
				  ,[UOM]
				  ,[DM_REQ_NO]
				  ,[PR_NO]
				  ,[PO_NO]
				  )
			SELECT
				   @v_plan_cutoff_yyyymmdd  AS PLAN_START_YYYYMMDD
				  ,'PR'
				  ,R.DIVISION_ID
				  ,R.PROJECT_CODE
				  ,PR.PR_ITEM_ID
				  ,R.SCM_SITE_ID
				  ,R.PLANT_SITE_ID
				  ,R.DOM_EXP
				  ,R.FCST_TYPE
				  ,R.INCOTERMS
				  ,PR.YYYYMMDD
				  ,'-' AS CONFIRM_ID
				  ,PR.PR_REQ_QTY
				  ,PR.UOM
				  ,PR.DM_REQ_NO
				  ,PR.PR_NO
				  ,'-' AS PO_NO
			  FROM [dbo].[SSP_ANL_ESS_PR] PR WITH(NOLOCK)
			       JOIN [dbo].[SSP_ANL_ESS_REQ] R WITH(NOLOCK)
				ON PR.DM_REQ_NO = R.DM_REQ_NO
			   AND PR.PR_ITEM_ID = R.ITEM_ID
			 WHERE 1 = 1
			   AND PR.YYYYMMDD		>= @v_data_start_yyyymmdd
			   AND PR.YYYYMMDD		 < @v_data_end_yyyymmdd
			   AND R.DIVISION_ID	 = @v_division_id
			   AND PR.PR_NO			!= '-'
			   ;

			-------------------------------------------------------------------------------------------------------------
			--2-3. PO
			-------------------------------------------------------------------------------------------------------------
			INSERT INTO #tmp_SSP_ANL_ESS_PLAN
				  (
				   [PLAN_START_YYYYMMDD]
				  ,[MEASURE]
				  ,[DIVISION_ID]
				  ,[PROJECT_CODE]
				  ,[ITEM_ID]
				  ,[SCM_SITE_ID]
				  ,[PLANT_SITE_ID]
				  ,[DOM_EXP]
				  ,[FCST_TYPE]
				  ,[INCOTERMS]
				  ,[YYYYMMDD]
				  ,[CONFIRM_ID]
				  ,[QTY]
				  ,[UOM]
				  ,[DM_REQ_NO]
				  ,[PR_NO]
				  ,[PO_NO]
				  )
			SELECT
				   @v_plan_cutoff_yyyymmdd  AS PLAN_START_YYYYMMDD
				  ,'PO'
				  ,R.DIVISION_ID
				  ,R.PROJECT_CODE
				  ,PO.PO_ITEM_ID AS ITEM_ID
				  ,R.SCM_SITE_ID
				  ,R.PLANT_SITE_ID
				  ,R.DOM_EXP
				  ,R.FCST_TYPE
				  ,R.INCOTERMS
				  ,PO.PO_CREATED_DATE
				  ,'-' AS CONFIRM_ID
				  ,PO.PO_QTY
				  ,R.UOM
				  ,R.DM_REQ_NO
				  ,PO.PR_NO
				  ,PO.PO_NO
			  FROM [dbo].[SSP_ANL_ESS_PO] PO WITH(NOLOCK)
			       JOIN [dbo].[SSP_ANL_ESS_PR] PR WITH(NOLOCK)
                ON PO.PR_NO = PR.PR_NO
               AND PO.PO_ITEM_ID = PR.PR_ITEM_ID
			       JOIN [dbo].[SSP_ANL_ESS_REQ] R WITH(NOLOCK)
				ON PR.DM_REQ_NO = R.DM_REQ_NO
			   AND PR.PR_ITEM_ID = R.ITEM_ID
		     WHERE 1 = 1
			   AND PO.YYYYMMDD		>= @v_data_start_yyyymmdd
			   AND PO.YYYYMMDD		 < @v_data_end_yyyymmdd
			   AND R.DIVISION_ID	 = @v_division_id

			-------------------------------------------------------------------------------------------------------------
			--2-3. PO_RTF
			-------------------------------------------------------------------------------------------------------------
			INSERT INTO #tmp_SSP_ANL_ESS_PLAN
				  (
				   [PLAN_START_YYYYMMDD]
				  ,[MEASURE]
				  ,[DIVISION_ID]
				  ,[PROJECT_CODE]
				  ,[ITEM_ID]
				  ,[SCM_SITE_ID]
				  ,[PLANT_SITE_ID]
				  ,[DOM_EXP]
				  ,[FCST_TYPE]
				  ,[INCOTERMS]
				  ,[YYYYMMDD]
				  ,[CONFIRM_ID]
				  ,[QTY]
				  ,[UOM]
				  ,[DM_REQ_NO]
				  ,[PR_NO]
				  ,[PO_NO]
				  )
			SELECT
				   @v_plan_cutoff_yyyymmdd  AS PLAN_START_YYYYMMDD
				  ,'PO_RTF'
				  ,R.DIVISION_ID
				  ,R.PROJECT_CODE
				  ,PO.PO_ITEM_ID AS ITEM_ID
				  ,R.SCM_SITE_ID
				  ,R.PLANT_SITE_ID
				  ,R.DOM_EXP
				  ,R.FCST_TYPE
				  ,R.INCOTERMS
				  ,PO.YYYYMMDD
				  ,'-' AS CONFIRM_ID
				  ,PO.PO_QTY
				  ,R.UOM
				  ,R.DM_REQ_NO
				  ,PO.PR_NO
				  ,PO.PO_NO
			  FROM [dbo].[SSP_ANL_ESS_PO] PO WITH(NOLOCK)
			       JOIN [dbo].[SSP_ANL_ESS_PR] PR WITH(NOLOCK)
                ON PO.PR_NO = PR.PR_NO
               AND PO.PO_ITEM_ID = PR.PR_ITEM_ID
			       JOIN [dbo].[SSP_ANL_ESS_REQ] R WITH(NOLOCK)
				ON PR.DM_REQ_NO = R.DM_REQ_NO
			   AND PR.PR_ITEM_ID = R.ITEM_ID
		     WHERE 1 = 1
			   AND PO.YYYYMMDD		>= @v_data_start_yyyymmdd
			   AND PO.YYYYMMDD		 < @v_data_end_yyyymmdd
			   AND R.DIVISION_ID	 = @v_division_id


 			-------------------------------------------------------------------------------------------------------------
			--2-2. CONFIRM
			-------------------------------------------------------------------------------------------------------------
			INSERT INTO #tmp_SSP_ANL_ESS_PLAN
				  (
				   [PLAN_START_YYYYMMDD]
				  ,[MEASURE]
				  ,[DIVISION_ID]
				  ,[PROJECT_CODE]
				  ,[ITEM_ID]
				  ,[SCM_SITE_ID]
				  ,[PLANT_SITE_ID]
				  ,[DOM_EXP]
				  ,[FCST_TYPE]
				  ,[INCOTERMS]
				  ,[YYYYMMDD]
				  ,[CONFIRM_ID]
				  ,[QTY]
				  ,[UOM]
				  ,[DM_REQ_NO]
				  ,[PR_NO]
				  ,[PO_NO]
				  )
			SELECT
			       @v_plan_cutoff_yyyymmdd	  AS PLAN_START_YYYYMMDD
				  ,'SHIP_CONFIRM'
			      ,C.DIVISION_ID
			      ,C.PROJECT_CODE
			      ,C.ITEM_ID
			      ,C.TO_SITE	AS SCM_SITE_ID
			      ,C.FROM_SITE AS PLANT_SITE_ID
			      ,'-' AS DOM_EXP
			      ,C.FCST_TYPE
			      ,ISNULL(B.SSP_INCOTERMS, C.INCOTERMS)   AS INCOTERMS -- R.INCOTERMS
			      ,C.YYYYMMDD
			      ,C.CONFIRM_ID
			      ,C.QTY
			      ,'-' AS UOM
			      ,'-' AS DM_REQ_NO
			      ,'-' AS PR_NO
			      ,'-' AS PO_NO
			  FROM SSP_ANL_SHIP_CONFIRM C WITH(NOLOCK)
			       JOIN SCM_MST_SITE AS S WITH(NOLOCK)
                ON C.FROM_SITE		= S.SCM_SITE_ID
			   AND C.DIVISION_ID	= S.DIVISION_ID
			   AND S.SITE_TYPE		= 'PLANT'
			  	   LEFT OUTER JOIN SCP_MST_BOD_N_V  B WITH(NOLOCK)
			    ON B.DIVISION_ID	= C.DIVISION_ID
			   AND B.BOD_ID			= C.BOD_ID
			       JOIN SCM_MST_ITEM_SN AS T WITH(NOLOCK)
			    ON C.ITEM_ID		= T.ITEM_ID
			   AND C.DIVISION_ID	= T.DIVISION_ID
			   AND S.COMPANY_ID		= T.COMPANY_ID
			   AND T.ITEM_TYPE		= 'Q'  --상품
			 WHERE 1 = 1
			   AND C.YYYYMMDD	   >= @v_data_start_yyyymmdd
			   AND C.YYYYMMDD	    < @v_data_end_yyyymmdd
			   AND C.CHANGE_TYPE	= 'C' -- 확정
			  --AND   [DBO].[FN_GET_SSP_SITE_INFO](C.DIVISION_ID, C.FROM_SITE, 'COMPANY_ID') = @v_company_id
			   AND C.DIVISION_ID	= @v_division_id

 			-------------------------------------------------------------------------------------------------------------
			--2-5. 존재하지 않는 경우, 해당 MEASURE를 0으로 추가
			-------------------------------------------------------------------------------------------------------------
 			DECLARE @X_INT        INT		= 1;
			DECLARE @X_MEASURE    NVARCHAR(100);

			WHILE @X_INT <= 6
			BEGIN

			    SELECT @X_MEASURE = ( CASE @X_INT WHEN 1 THEN 'BNP_IN'
				                                  WHEN 2 THEN 'REQ'
												  WHEN 3 THEN 'PR'
												  WHEN 4 THEN 'PO'
												  WHEN 5 THEN 'PO_RTF'
												  WHEN 6 THEN 'SHIP_CONFIRM'
								       END);

				INSERT INTO #tmp_SSP_ANL_ESS_PLAN
				      (
				       [PLAN_START_YYYYMMDD]
				      ,[MEASURE]
				      ,[DIVISION_ID]
				      ,[PROJECT_CODE]
				      ,[ITEM_ID]
				      ,[SCM_SITE_ID]
				      ,[PLANT_SITE_ID]
				      ,[DOM_EXP]
				      ,[FCST_TYPE]
				      ,[INCOTERMS]
				      ,[YYYYMMDD]
				      ,[CONFIRM_ID]
				      ,[QTY]
				      ,[UOM]
				      ,[DM_REQ_NO]
				      ,[PR_NO]
				      ,[PO_NO]
				      )
			    SELECT
					   SUB.PLAN_START_YYYYMMDD
                      ,SUB.MEASURE
					  ,SUB.DIVISION_ID
					  ,SUB.PROJECT_CODE
					  ,SUB.ITEM_ID
					  ,SUB.SCM_SITE_ID
					  ,SUB.PLANT_SITE_ID
					  ,SUB.DOM_EXP
					  ,SUB.FCST_TYPE
					  ,SUB.INCOTERMS
					  ,SUB.YYYYMMDD
					  ,'-'		AS CONFIRM_ID
					  ,0        AS QTY
					  ,SUB.UOM
					  ,'-'		AS DM_REQ_NO
					  ,'-'		AS PR_NO
					  ,'-'		AS PO_NO
				  FROM (
					   SELECT PLAN_START_YYYYMMDD
							 ,@X_MEASURE  AS MEASURE
							 ,DIVISION_ID
							 ,PROJECT_CODE
							 ,ITEM_ID
							 ,YYYYMMDD
							 ,'-'	AS SCM_SITE_ID
							 ,'-'   AS PLANT_SITE_ID
							 ,'-'	AS DOM_EXP
							 ,'-'	AS FCST_TYPE
							 ,'-'	AS INCOTERMS
						     ,'-'	AS UOM
						 FROM (
							  SELECT C.BASIS_YYYYMMDD AS YYYYMMDD
								FROM SCM_SYS_CALENDAR_M    C WITH(NOLOCK)
							   WHERE 1 = 1
								 AND C.BASIS_YYYYMMDD >= @v_data_start_yyyymmdd
								 AND C.BASIS_YYYYMMDD <  @v_data_end_yyyymmdd
							  ) A,
							  (
							  SELECT DISTINCT
									 PLAN_START_YYYYMMDD
									,DIVISION_ID
									,PROJECT_CODE
									,ITEM_ID
								FROM #tmp_SSP_ANL_ESS_PLAN X WITH(NOLOCK)
							  ) B
					   ) SUB
				 WHERE 1 = 1
				   AND NOT EXISTS (
								  SELECT 'X'
									FROM #tmp_SSP_ANL_ESS_PLAN Z WITH(NOLOCK)
								   WHERE 1 = 1
									 AND Z.PLAN_START_YYYYMMDD   = SUB.PLAN_START_YYYYMMDD
									 AND Z.DIVISION_ID           = SUB.DIVISION_ID
									 AND Z.PROJECT_CODE          = SUB.PROJECT_CODE
									 AND Z.ITEM_ID               = SUB.ITEM_ID
									 AND Z.MEASURE               = @X_MEASURE
									 AND Z.YYYYMMDD              = SUB.YYYYMMDD
								  )
					;

				SET @X_INT = @X_INT + 1;
			END  ;


			-------------------------------------------------------------------------------------------------------------
			--2-7. Purchasing Balance
			-------------------------------------------------------------------------------------------------------------
            WITH INV_ALLO AS (
			     SELECT
				       SUB.PLAN_START_YYYYMMDD
				      ,SUB.DIVISION_ID
				      ,SUB.PROJECT_CODE
				      ,SUB.ITEM_ID
				      ,SUB.BOH_ALLO_QTY
			      FROM (
				       SELECT A.PLAN_START_YYYYMMDD
						     ,A.DIVISION_ID
						     ,A.PROJECT_CODE
						     ,A.ITEM_ID
							 ,ISNULL(B.BOH_ALLO_QTY, 0) AS BOH_ALLO_QTY
					     FROM (
						      SELECT DISTINCT
								     PLAN_START_YYYYMMDD
								    ,DIVISION_ID
								    ,PROJECT_CODE
								    ,ITEM_ID
							    FROM #tmp_SSP_ANL_ESS_PLAN X WITH(NOLOCK)
						      ) A
						      LEFT OUTER JOIN
						      (
						      SELECT PLAN_START_YYYYMMDD
								    ,DIVISION_ID
								    ,PROJECT_CODE
								    ,ITEM_ID
								    ,SUM(ISNULL(INV_ALLO_QTY,0)) AS BOH_ALLO_QTY
							    FROM #tmp_SSP_ANL_ESS_PLAN X WITH(NOLOCK)
						       WHERE 1 = 1
							     AND MEASURE = 'REQ'
						       GROUP BY
							         PLAN_START_YYYYMMDD
								    ,DIVISION_ID
								    ,PROJECT_CODE
								    ,ITEM_ID
						     ) B
					      ON A.PLAN_START_YYYYMMDD = B.PLAN_START_YYYYMMDD
					     AND A.DIVISION_ID         = B.DIVISION_ID
					     AND A.PROJECT_CODE        = B.PROJECT_CODE
					     AND A.ITEM_ID             = B.ITEM_ID
				       ) SUB
			     WHERE 1 = 1
				 ),
				 Z AS (
				 SELECT PLAN_START_YYYYMMDD
					   ,DIVISION_ID
					   ,PROJECT_CODE
					   ,ITEM_ID
					   ,YYYYMMDD
				   FROM #tmp_SSP_ANL_ESS_PLAN X WITH(NOLOCK)
				  WHERE 1 = 1
					AND MEASURE = 'BNP_IN'
				  GROUP BY
						PLAN_START_YYYYMMDD
					   ,DIVISION_ID
					   ,PROJECT_CODE
					   ,ITEM_ID
					   ,YYYYMMDD
				  )

				INSERT INTO #tmp_SSP_ANL_ESS_PLAN
				      (
				       [PLAN_START_YYYYMMDD]
				      ,[MEASURE]
				      ,[DIVISION_ID]
				      ,[PROJECT_CODE]
				      ,[ITEM_ID]
				      ,[SCM_SITE_ID]
				      ,[PLANT_SITE_ID]
				      ,[DOM_EXP]
				      ,[FCST_TYPE]
				      ,[INCOTERMS]
				      ,[YYYYMMDD]
				      ,[CONFIRM_ID]
				      ,[QTY]
				      ,[UOM]
				      ,[DM_REQ_NO]
				      ,[PR_NO]
				      ,[PO_NO]
				      )
			    SELECT
				       Z.[PLAN_START_YYYYMMDD]
				      ,'PUR_BALANCE'
				      ,Z.[DIVISION_ID]
				      ,Z.[PROJECT_CODE]
				      ,Z.[ITEM_ID]
				      ,'-' AS [SCM_SITE_ID]
				      ,'-' AS [PLANT_SITE_ID]
				      ,'-' AS [DOM_EXP]
				      ,'-' AS [FCST_TYPE]
				      ,'-' AS [INCOTERMS]
				      ,Z.[YYYYMMDD]
				      ,'-' AS [CONFIRM_ID]
				      ,ISNULL(B.BOH_ALLO_QTY, 0)
					   + (
					     SELECT ISNULL( SUM( CASE WHEN T.MEASURE = 'PO'     THEN ISNULL(T.QTY,0)
												  WHEN T.MEASURE = 'BNP_IN' THEN ISNULL(T.QTY,0) * -1
												  ELSE 0.0 END
												 ) ,0)
						  FROM #tmp_SSP_ANL_ESS_PLAN T WITH(NOLOCK)
						 WHERE 1 = 1
						   AND T.PLAN_START_YYYYMMDD  = Z.PLAN_START_YYYYMMDD
						   AND T.DIVISION_ID = Z.DIVISION_ID
						   AND T.PROJECT_CODE    = Z.PROJECT_CODE
						   AND T.ITEM_ID     = Z.ITEM_ID
 						   AND T.MEASURE              IN ('BNP_IN', 'PO')
						   AND T.YYYYMMDD             >= @v_data_start_yyyymmdd
						   AND T.YYYYMMDD             <= Z.YYYYMMDD
                         )
				      ,'-' AS [UOM]
				      ,'-' AS [DM_REQ_NO]
				      ,'-' AS [PR_NO]
				      ,'-' AS [PO_NO]
				  FROM Z WITH(NOLOCK)
				       LEFT OUTER JOIN INV_ALLO B WITH(NOLOCK)
					ON Z.PLAN_START_YYYYMMDD  = B.PLAN_START_YYYYMMDD
				   AND Z.DIVISION_ID = B.DIVISION_ID
				   AND Z.PROJECT_CODE    = B.PROJECT_CODE
				   AND Z.ITEM_ID     = B.ITEM_ID
				 WHERE 1 = 1
				 ORDER BY
				       Z.YYYYMMDD
				 ;

			-------------------------------------------------------------------------------------------------------------
			--2-7. Shipping Balance
			-------------------------------------------------------------------------------------------------------------
            WITH INV_ALLO AS (
			     SELECT
				       SUB.PLAN_START_YYYYMMDD
				      ,SUB.DIVISION_ID
				      ,SUB.PROJECT_CODE
				      ,SUB.ITEM_ID
				      ,SUB.BOH_ALLO_QTY
			      FROM (
				       SELECT A.PLAN_START_YYYYMMDD
						     ,A.DIVISION_ID
						     ,A.PROJECT_CODE
						     ,A.ITEM_ID
							 ,ISNULL(B.BOH_ALLO_QTY, 0) AS BOH_ALLO_QTY
					     FROM (
						      SELECT DISTINCT
								     PLAN_START_YYYYMMDD
								    ,DIVISION_ID
								    ,PROJECT_CODE
								    ,ITEM_ID
							    FROM #tmp_SSP_ANL_ESS_PLAN X WITH(NOLOCK)
						      ) A
						      LEFT OUTER JOIN
						      (
						      SELECT PLAN_START_YYYYMMDD
								    ,DIVISION_ID
								    ,PROJECT_CODE
								    ,ITEM_ID
								    ,SUM(ISNULL(INV_ALLO_QTY,0)) AS BOH_ALLO_QTY
							    FROM #tmp_SSP_ANL_ESS_PLAN X WITH(NOLOCK)
						       WHERE 1 = 1
							     AND MEASURE = 'REQ'
						       GROUP BY
							         PLAN_START_YYYYMMDD
								    ,DIVISION_ID
								    ,PROJECT_CODE
								    ,ITEM_ID
						     ) B
					      ON A.PLAN_START_YYYYMMDD = B.PLAN_START_YYYYMMDD
					     AND A.DIVISION_ID         = B.DIVISION_ID
					     AND A.PROJECT_CODE        = B.PROJECT_CODE
					     AND A.ITEM_ID             = B.ITEM_ID
				       ) SUB
			     WHERE 1 = 1
				 ),
				 Z AS (
				 SELECT PLAN_START_YYYYMMDD
					   ,DIVISION_ID
					   ,PROJECT_CODE
					   ,ITEM_ID
					   ,YYYYMMDD
				   FROM #tmp_SSP_ANL_ESS_PLAN X WITH(NOLOCK)
				  WHERE 1 = 1
					AND MEASURE = 'BNP_IN'
				  GROUP BY
						PLAN_START_YYYYMMDD
					   ,DIVISION_ID
					   ,PROJECT_CODE
					   ,ITEM_ID
					   ,YYYYMMDD
				  )

				 INSERT INTO #tmp_SSP_ANL_ESS_PLAN
				      (
				       [PLAN_START_YYYYMMDD]
				      ,[MEASURE]
				      ,[DIVISION_ID]
				      ,[PROJECT_CODE]
				      ,[ITEM_ID]
				      ,[SCM_SITE_ID]
				      ,[PLANT_SITE_ID]
				      ,[DOM_EXP]
				      ,[FCST_TYPE]
				      ,[INCOTERMS]
				      ,[YYYYMMDD]
				      ,[CONFIRM_ID]
				      ,[QTY]
				      ,[UOM]
				      ,[DM_REQ_NO]
				      ,[PR_NO]
				      ,[PO_NO]
				      )
			    SELECT
				       Z.[PLAN_START_YYYYMMDD]
				      ,'SHIP_BALANCE'
				      ,Z.[DIVISION_ID]
				      ,Z.[PROJECT_CODE]
				      ,Z.[ITEM_ID]
				      ,'-' AS [SCM_SITE_ID]
				      ,'-' AS [PLANT_SITE_ID]
				      ,'-' AS [DOM_EXP]
				      ,'-' AS [FCST_TYPE]
				      ,'-' AS [INCOTERMS]
				      ,Z.[YYYYMMDD]
				      ,'-' AS [CONFIRM_ID]
				      ,ISNULL(B.BOH_ALLO_QTY, 0)
					   + (
					     SELECT ISNULL( SUM( CASE WHEN T.MEASURE = 'PO_RTF'     THEN ISNULL(T.QTY,0)
												  WHEN T.MEASURE = 'SHIP_CONFIRM' THEN ISNULL(T.QTY,0) * -1
												  ELSE 0.0 END
												 ) ,0)
						  FROM #tmp_SSP_ANL_ESS_PLAN T WITH(NOLOCK)
						 WHERE 1 = 1
						   AND T.PLAN_START_YYYYMMDD  = Z.PLAN_START_YYYYMMDD
						   AND T.DIVISION_ID = Z.DIVISION_ID
						   AND T.PROJECT_CODE    = Z.PROJECT_CODE
						   AND T.ITEM_ID     = Z.ITEM_ID
 						   AND T.MEASURE              IN ('SHIP_CONFIRM', 'PO_RTF')
						   AND T.YYYYMMDD             >= @v_data_start_yyyymmdd
						   AND T.YYYYMMDD             <= Z.YYYYMMDD
                         )
				      ,'-' AS [UOM]
				      ,'-' AS [DM_REQ_NO]
				      ,'-' AS [PR_NO]
				      ,'-' AS [PO_NO]
				  FROM Z WITH(NOLOCK)
				       LEFT OUTER JOIN INV_ALLO B WITH(NOLOCK)
					ON Z.PLAN_START_YYYYMMDD  = B.PLAN_START_YYYYMMDD
				   AND Z.DIVISION_ID = B.DIVISION_ID
				   AND Z.PROJECT_CODE    = B.PROJECT_CODE
				   AND Z.ITEM_ID     = B.ITEM_ID
				 WHERE 1 = 1
				 ORDER BY
				       Z.YYYYMMDD
				 ;


 		-------------------------------------------------------------------------------------------------------------
		--3. 최종 SSP_ANL_ESS_PLAN 생성
		-------------------------------------------------------------------------------------------------------------
        DELETE
		FROM  SSP_ANL_ESS_PLAN
        WHERE 1 = 1
        AND   PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
        ;

        INSERT INTO dbo.SSP_ANL_ESS_PLAN
				(
				 [PLAN_START_YYYYMMDD]
				,[MEASURE]
				,[DIVISION_ID]
				,[PROJECT_CODE]
				,[ITEM_ID]
				,[SCM_SITE_ID]
				,[PLANT_SITE_ID]
				,[DOM_EXP]
				,[FCST_TYPE]
				,[INCOTERMS]
				,[YYYYMMDD]
				,[CONFIRM_ID]
				,[QTY]
				,[INV_ALLO_QTY]
				,[UOM]
				,[DM_REQ_NO]
				,[PR_NO]
				,[PO_NO]
				)
			SELECT
				 [PLAN_START_YYYYMMDD]
				,[MEASURE]
				,[DIVISION_ID]
				,[PROJECT_CODE]
				,[ITEM_ID]
				,[SCM_SITE_ID]
				,[PLANT_SITE_ID]
				,[DOM_EXP]
				,[FCST_TYPE]
				,[INCOTERMS]
				,[YYYYMMDD]
				,[CONFIRM_ID]
				,[QTY]
				,[INV_ALLO_QTY]
				,[UOM]
				,[DM_REQ_NO]
				,[PR_NO]
				,[PO_NO]
            FROM #tmp_SSP_ANL_ESS_PLAN
			;

 		-------------------------------------------------------------------------------------------------------------
		--3. LOOKUP 처리
		-------------------------------------------------------------------------------------------------------------
        UPDATE SCM_ADM_LOOKUP_MASTER_DETAIL
	       SET ATTRIBUTE1		= @v_plan_start_yyyymmdd
		      ,LAST_UPDATED_BY	= @v_batch_user
			  ,LAST_UPDATE_DATE = getdate()
         WHERE LOOKUP_TYPE		= 'SSP_ANL_ESS_PLAN'
	       AND SEGMENT1			= @v_division_id
		   AND VALID_YN			= 'Y'
		;

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

		IF OBJECT_ID('tempdb..#tmp_SSP_ANL_ESS_PLAN') IS NOT NULL
			DROP TABLE #tmp_SSP_ANL_ESS_PLAN

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


	IF OBJECT_ID('tempdb..#tmp_SSP_ANL_ESS_PLAN') IS NOT NULL
        DROP TABLE #tmp_SSP_ANL_ESS_PLAN

    RETURN 1

END;
