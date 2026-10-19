
/*
 * Program ID   : SSP0015_GET_SHIPMENT_PSI_PACKER
 * Description  : Shipment Plan Confrim
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2020/11/10   KIMYONGHO	   SSP0015_GET_SHIPMENT_PSI 복사 신규추가
 * 2022/02/21   SMS	           @v_confirm_date 일자 scm_mst_site(ship_frozen)로 설정
 * 2023/09/19   jilee          G182-P (Group='P',OSP='N')인 사이트 화면에서 제외
 * 2024/10/01   KHJ            NERP_SSP
 */
CREATE PROCEDURE [dbo].[SSP0015_GET_SHIPMENT_PSI_PACKER] 
	 @p_division_id			 NVARCHAR(MAX)
	,@p_from_site			 NVARCHAR(MAX)
	,@p_item_id				 NVARCHAR(MAX)
	,@p_plan_start_yyyymmdd  NVARCHAR(8)
	,@p_plan_type			 NVARCHAR(50)
	,@p_from_yyyymmdd		 NVARCHAR(MAX)
	,@p_to_yyyymmdd			 NVARCHAR(MAX)
	,@p_user_id				 NVARCHAR(MAX)
	,@p_myModelChk			 NVARCHAR(MAX)	= 'N'
	,@p_program_id			 NVARCHAR(MAX)
	,@p_sheet_name			 NVARCHAR(MAX)
	,@debug_mode			 NVARCHAR(1)	='F'
	,@p_seq					 NVARCHAR(MAX)
	,@p_partLeaderChk		 NVARCHAR(MAX)
	,@p_teamLeaderChk		 NVARCHAR(MAX)
	,@p_nonChk				 NVARCHAR(MAX)
	,@p_delegateeChk		 NVARCHAR(MAX)

AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @v_data_cnt NVARCHAR(8);
	SET @v_data_cnt =0;

	DECLARE @v_cnt_usr_measure	INT =0;

	SET @v_cnt_usr_measure = (
								SELECT COUNT(*)
								FROM scm_mst_titleset_user   with(nolock)
								WHERE 1=1
								 AND program_id  =  @p_program_id
								 AND sheet_name  =  @p_sheet_name
								 AND user_id     =  @p_user_id
							  )

   /********************************************************************************
	* 임시테이블만들기
	********************************************************************************/
	DECLARE  @MQRY_SUM					NVARCHAR(MAX)='';
	DECLARE  @MEXEC						NVARCHAR(MAX);
	DECLARE  @v_division_id				NVARCHAR(MAX)='';
	DECLARE  @v_from_site				NVARCHAR(MAX)='';
	DECLARE  @v_item_id					NVARCHAR(MAX)='';
	DECLARE  @v_cutoff_date				NVARCHAR(MAX)='';
	DECLARE  @v_plan_cutoff_date_time	datetime;
	DECLARE  @v_confirm_date			NVARCHAR(MAX)='';
	DECLARE  @v_boh_yyyymmdd			NVARCHAR(8);
	DECLARE  @p_stock_yyyymmdd			NVARCHAR(8);

	-- NERP 매핑코드
    DECLARE @v_C100 NVARCHAR(10);
    DECLARE @v_A010 NVARCHAR(10);
	SET @v_C100 = dbo.FN_GET_LOOKUP_VALUE('SSP0015_GET_SHIPMENT_PSI_PACKER'  ,'ESOC' );	--C100
	SET @v_A010 = dbo.FN_GET_LOOKUP_VALUE('SSP0015_GET_SHIPMENT_PSI_PACKER'  ,'A010' );	--A010


	SET @v_cutoff_date			 = CONVERT(VARCHAR, DATEADD(D, -2, CONVERT(DATETIME, @p_plan_start_yyyymmdd ,112)) ,112) ;
	--SET @v_plan_cutoff_date_time = CONVERT(DATETIME, CONVERT(VARCHAR, DATEADD(D, -1, CONVERT(DATETIME, @p_plan_start_yyyymmdd ,112)) ,112) + ' 07:15:00')
	/* 20220201	SMS	수정	*/
	--SET @v_confirm_date			 = CONVERT(VARCHAR, DATEADD(D,  3, CONVERT(DATETIME, @p_plan_start_yyyymmdd ,112)) ,112) ;
	/* ========================================================================================================================== */

	SET @p_stock_yyyymmdd		 = CONVERT(CHAR(8), DATEADD(DD, -3, CONVERT(VARCHAR, @p_plan_start_yyyymmdd, 121)), 112); --FROM -3일	
	SET @v_boh_yyyymmdd			 = CONVERT(CHAR(8), DATEADD(DD, -1, CONVERT(VARCHAR, @p_plan_start_yyyymmdd, 121)), 112); --FROM -1일


	if  (datepart(DW, convert(date, CONVERT(VARCHAR, DATEADD(D, 0, CONVERT(DATETIME, @p_plan_start_yyyymmdd ,112)) ,112))) = 2)
	   	SET @v_plan_cutoff_date_time = CONVERT(DATETIME, CONVERT(VARCHAR, DATEADD(D, 0, CONVERT(DATETIME, @p_plan_start_yyyymmdd ,112)) ,112) + ' 15:30:00')
	else
	    SET @v_plan_cutoff_date_time = CONVERT(DATETIME, CONVERT(VARCHAR, DATEADD(D, 0, CONVERT(DATETIME, @p_plan_start_yyyymmdd ,112)) ,112) + ' 07:15:00')

	 -- SCM_DNM_SCS_SHIP_RESULT

	--IN 조건으로 데이터를 가져옴
	SET @v_division_id	= [dbo].FN_GET_IN_STR(@p_division_id);
	SET @v_from_site	= [dbo].FN_GET_IN_STR(@p_from_site);
	SET @v_item_id		= [dbo].FN_GET_IN_STR(@p_item_id);

	-- Requestor
	IF OBJECT_ID('tempdb..#TblDynamicTitlest_SSP0015') IS NOT NULL
		DROP TABLE #TblDynamicTitlest_SSP0015;


	-- SHIPMENT ROW DATA
	IF OBJECT_ID('TEMPDB..#TMP_ROWDATA') IS NOT NULL	
		DROP TABLE #TMP_ROWDATA;
	
	IF OBJECT_ID('TEMPDB..#TMP_RESULT_PIVOT_TABLE') IS NOT NULL	
		DROP TABLE #TMP_RESULT_PIVOT_TABLE;

	IF OBJECT_ID('TEMPDB..#TMP_RESULT_TABLE') IS NOT NULL	
		DROP TABLE #TMP_RESULT_TABLE;

	-- SHIPMENT REQUEST DATA
	IF OBJECT_ID('TEMPDB..#TMP_SHIP_REQ') IS NOT NULL	
		DROP TABLE #TMP_SHIP_REQ;
	
	-- PACK RTF DATA
	IF OBJECT_ID('TEMPDB..#TMP_PACK_RTF') IS NOT NULL	
		DROP TABLE #TMP_PACK_RTF;

	-- SHIPMENT CONFIRM DATA
	IF OBJECT_ID('TEMPDB..#TMP_SHIP_CONFIRM') IS NOT NULL	
		DROP TABLE #TMP_SHIP_CONFIRM;
	
	-- PROD_PLAN DATA
	IF OBJECT_ID('TEMPDB..#TMP_PROD_PLAN') IS NOT NULL	
		DROP TABLE #TMP_PROD_PLAN;
	
	-- WH_STOCK DATA
	IF OBJECT_ID('TEMPDB..#TMP_WH_STOCK') IS NOT NULL	
		DROP TABLE #TMP_WH_STOCK;

	-- ERP_STOCK DATA
	IF OBJECT_ID('TEMPDB..#TMP_ERP_STOCK') IS NOT NULL	
		DROP TABLE #TMP_ERP_STOCK;
	

	SELECT * 
	  INTO #TblDynamicTitlest_SSP0015
	  FROM SCM_MST_TITLESET_USER WITH(NOLOCK)
	 WHERE PROGRAM_ID  = @p_program_id
	   AND SHEET_NAME  = @p_sheet_name
	   AND USER_ID     = @p_user_id
	;


	CREATE TABLE #TMP_RESULT_TABLE
	(
		  DIVISION_ID		NVARCHAR(10)
		, ITEM_ID			NVARCHAR(50)
		, FROM_SITE			NVARCHAR(30)
		, MEASURE			NVARCHAR(50)
		, YYYYMMDD			NVARCHAR(8)
		, QTY				NUMERIC(20, 10)
		, SEQ				INT
	);

	CREATE TABLE #TMP_PROD_PLAN
	(
		  DIVISION_ID		NVARCHAR(10)
		, ITEM_ID			NVARCHAR(50)
		, FROM_SITE			NVARCHAR(30)
		, MEASURE			NVARCHAR(50)
		, YYYYMMDD			NVARCHAR(8)
		, QTY				NUMERIC(20, 10)
	);


	--////////////////////////////////////////////////////////////////////////////////--
	--// SHIP_REQ Measure 추가					 									//--
	--////////////////////////////////////////////////////////////////////////////////--
	--;
	SELECT A.DIVISION_ID
	,	  A.ITEM_ID AS ITEM_ID
	,	  TT1.FROM_SITE
	,	  'SHIP_REQ' AS MEASURE
	,	  A.YYYYMMDD
	,	  SUM(A.QTY) AS QTY
	INTO #TMP_SHIP_REQ
	FROM [DBO].[SSP_ANL_SHIP_REQ_P] A WITH(NOLOCK)     
	INNER JOIN  SCP_MST_BOD_N_V TT1 ON A.DIVISION_ID = TT1.DIVISION_ID  AND A.BOD_ID = TT1.BOD_ID                       
	WHERE A.DIVISION_ID	=  @P_DIVISION_ID
		AND A.YYYYMMDD	>= @P_FROM_YYYYMMDD
		AND A.YYYYMMDD	<= @P_TO_YYYYMMDD
		AND (( @p_item_id		IS NULL OR @p_item_id ='')		OR A.ITEM_ID	  IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_item_id , ',')))
		AND (( @p_from_site   IS NULL OR @p_from_site ='')		OR TT1.FROM_SITE	  IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_from_site , ',')))
	GROUP BY A.DIVISION_ID, A.ITEM_ID, TT1.FROM_SITE, A.YYYYMMDD
	;

	--////////////////////////////////////////////////////////////////////////////////--
	--// PACK_RTF Measure 추가					 									//--
	--////////////////////////////////////////////////////////////////////////////////-
	
	SELECT A.DIVISION_ID
	,	  A.ITEM_ID AS ITEM_ID
	,	  TT1.FROM_SITE
	,	  'PACK_RTF' AS MEASURE
	,	  A.ATTRIBUTE3 AS YYYYMMDD
	,	  SUM(CONVERT(NUMERIC ,A.ATTRIBUTE4)) AS QTY
	INTO #TMP_PACK_RTF
	FROM [DBO].[SSP_ANL_SHIP_REQ_P] A WITH(NOLOCK)
	INNER JOIN  SCP_MST_BOD_N_V TT1 ON A.DIVISION_ID = TT1.DIVISION_ID  AND A.BOD_ID = TT1.BOD_ID                       
	WHERE A.DIVISION_ID =  @P_DIVISION_ID
		AND A.YYYYMMDD	>= @P_FROM_YYYYMMDD
		AND A.YYYYMMDD	<= @P_TO_YYYYMMDD
		AND A.ATTRIBUTE2 <> 'N'
		AND (( @p_item_id		IS NULL OR @p_item_id ='')		OR A.ITEM_ID	  IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_item_id , ',')))
		AND (( @p_from_site   IS NULL OR @p_from_site ='')		OR TT1.FROM_SITE	  IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_from_site , ',')))
	GROUP BY A.DIVISION_ID, A.ITEM_ID, TT1.FROM_SITE, A.ATTRIBUTE3, A.ATTRIBUTE4

	--////////////////////////////////////////////////////////////////////////////////--
	--// SHIP_CONFIRM Measure 추가					 									//--
	--////////////////////////////////////////////////////////////////////////////////--
	
	--SELECT A.DIVISION_ID
	--,	  A.ITEM_ID
	--,	  A.SCM_SITE_ID AS FROM_SITE
	--,	  'SHIP_CONFIRM' AS MEASURE
	--,	  A.SHIP_DATE AS YYYYMMDD
	--,	  SUM(A.SHIP_QTY) AS QTY
	--INTO #TMP_SHIP_CONFIRM
	--FROM [DBO].[SCM_DNM_SCS_SHIP_RESULT] A WITH(NOLOCK)          
	--WHERE A.DIVISION_ID	=  @P_DIVISION_ID
	--	AND A.SHIP_DATE	>= @P_FROM_YYYYMMDD
	--	AND A.SHIP_DATE	< @p_plan_start_yyyymmdd
	--	AND (( @p_item_id		IS NULL OR @p_item_id ='')		OR A.ITEM_ID	  IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_item_id , ',')))
	--	AND (( @p_from_site   IS NULL OR @p_from_site ='')	OR A.SCM_SITE_ID	  IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_from_site , ',')))
	--GROUP BY A.DIVISION_ID, A.ITEM_ID, A.SCM_SITE_ID, A.SHIP_DATE

	--UNION ALL

	SELECT A.DIVISION_ID
	,	  A.ITEM_ID
	,	  A.FROM_SITE
	,	  'SHIP_CONFIRM' AS MEASURE
	,	  A.YYYYMMDD
	,	  SUM(A.QTY) AS QTY
	INTO #TMP_SHIP_CONFIRM
	FROM [DBO].[SSP_ANL_SHIP_CONFIRM] A WITH(NOLOCK)
	-- jilee 230919
	JOIN SCM_MST_SITE S WITH(NOLOCK) 
		ON S.DIVISION_ID = A.DIVISION_ID 
		AND S.SCM_SITE_ID = A.FROM_SITE 			
	WHERE A.DIVISION_ID	=  @P_DIVISION_ID
		AND A.YYYYMMDD	>= @P_FROM_YYYYMMDD
		AND A.YYYYMMDD	<= @P_TO_YYYYMMDD
		AND A.BIZ_TYPE	= 'P'
		AND (( @p_item_id		IS NULL OR @p_item_id ='')		OR A.ITEM_ID	  IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_item_id , ',')))
		AND (( @p_from_site   IS NULL OR @p_from_site ='')	OR A.FROM_SITE	  IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_from_site , ',')))		
		-- jilee 230919
		AND S.OSP_YN = 'Y'
	GROUP BY A.DIVISION_ID, A.ITEM_ID, A.FROM_SITE, A.YYYYMMDD

	UNION ALL

	/* 20220221	SMS	@v_confirm_date 일자 scm_mst_site(ship_frozen)로 설정 */
	SELECT A.DIVISION_ID
	,	  A.ITEM_ID AS ITEM_ID
	,	  TT1.FROM_SITE
	,	  'SHIP_CONFIRM' AS MEASURE
	,	  A.YYYYMMDD
	,	  SUM(A.QTY) AS QTY
	--INTO #TMP_SHIP_CONFIRM
	FROM [DBO].[SSP_ANL_SHIP_REQ_P] A WITH(NOLOCK)          
	INNER JOIN  SCP_MST_BOD_N_V TT1 ON A.DIVISION_ID = TT1.DIVISION_ID  AND A.BOD_ID = TT1.BOD_ID 
	/* 20020221	SMS	추가 */
	INNER JOIN SCM_MST_SITE			AS FS WITH(NOLOCK)	
	        ON A.DIVISION_ID = FS.DIVISION_ID 
           AND TT1.FROM_SITE = FS.SCM_SITE_ID
           AND FS.VALID_YN = 'Y'
	/*===================================================*/
	WHERE A.DIVISION_ID	=  @P_DIVISION_ID
		AND A.YYYYMMDD	>= CONVERT(CHAR(8), DATEADD(DAY, ISNULL(FS.SHIP_FROZEN, 0) , CONVERT(DATETIME, @p_plan_start_yyyymmdd ,112)), 112) -- SHIP_FROZEN 20020221	SMS	추가
		AND A.YYYYMMDD	<= @P_TO_YYYYMMDD
		--AND A.MEASURE		IN('SHIP_REQ')
		AND (( @p_item_id		IS NULL OR @p_item_id ='')		OR A.ITEM_ID	  IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_item_id , ',')))
		AND (( @p_from_site   IS NULL OR @p_from_site ='')		OR TT1.FROM_SITE	  IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_from_site , ',')))
	GROUP BY A.DIVISION_ID, A.ITEM_ID, TT1.FROM_SITE, A.YYYYMMDD
	;

	--SELECT A.DIVISION_ID
	--,	  A.ITEM_ID AS ITEM_ID
	--,	  TT1.FROM_SITE
	--,	  'SHIP_CONFIRM' AS MEASURE
	--,	  A.YYYYMMDD
	--,	  SUM(A.QTY) AS QTY
	----INTO #TMP_SHIP_CONFIRM
	--FROM [DBO].[SSP_ANL_SHIP_REQ_P] A WITH(NOLOCK)          
	--INNER JOIN  SCP_MST_BOD_N_V TT1 ON A.DIVISION_ID = TT1.DIVISION_ID  AND A.BOD_ID = TT1.BOD_ID 
	--WHERE A.DIVISION_ID	=  @P_DIVISION_ID
	--	AND A.YYYYMMDD	>= @v_confirm_date
	--	AND A.YYYYMMDD	<= @P_TO_YYYYMMDD
	--	--AND A.MEASURE		IN('SHIP_REQ')
	--	AND (( @p_item_id		IS NULL OR @p_item_id ='')		OR A.ITEM_ID	  IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_item_id , ',')))
	--	AND (( @p_from_site   IS NULL OR @p_from_site ='')		OR TT1.FROM_SITE	  IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_from_site , ',')))
	--GROUP BY A.DIVISION_ID, A.ITEM_ID, TT1.FROM_SITE, A.YYYYMMDD
	--;

	--////////////////////////////////////////////////////////////////////////////////--
	--// PROD_PLAN Measure 추가					 									//--
	--////////////////////////////////////////////////////////////////////////////////--


	INSERT INTO #TMP_PROD_PLAN

	--SELECT A.DIVISION_ID
	--,	  A.PACK_MODEL_CODE AS ITEM_ID
	--,	  A.SCM_SITE_ID AS FROM_SITE
	--,	  'PROD_PLAN' AS MEASURE
	--,	  A.PROD_DATE AS YYYYMMDD
	--,	  ISNULL(A.PROD_QTY, 0)   AS QTY
	----INTO #TMP_PROD_PLAN
	--FROM [DBO].[SCM_DNM_SCS_PROD_RESULT] A
	
	--WHERE  1 = 1
	--AND    A.DIVISION_ID = @P_DIVISION_ID
	--AND    A.PROD_DATE  = @v_boh_yyyymmdd
	--AND    ISNULL(A.PROD_QTY, 0) > 0
	--AND (( @p_item_id		IS NULL OR @p_item_id ='')		OR A.PACK_MODEL_CODE	  IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_item_id , ',')))
	--AND (( @p_from_site   IS NULL OR @p_from_site ='')		OR A.SCM_SITE_ID	  IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_from_site , ',')))


	--UNION ALL

	SELECT A.DIVISION_ID
	,	  A.PACK_MODEL_CODE AS ITEM_ID
	,	  A.SCM_SITE_ID AS FROM_SITE
	,	  'PROD_PLAN' AS MEASURE
	,	  A.PROD_DATE AS YYYYMMDD
	,	  ISNULL(A.PROD_QTY, 0)   AS QTY
	--INTO #TMP_PROD_PLAN
	FROM [DBO].[SCM_DNM_SCS_PROD_PLAN] A WITH(NOLOCK)
	JOIN (
	   SELECT DIVISION_ID, MAX(CUTOFF_DATE) AS CUTOFF_DATE, PACK_MODEL_CODE, SCM_SITE_ID, prod_date
	  FROM [DBO].[SCM_DNM_SCS_PROD_PLAN] WITH(NOLOCK)
	   GROUP BY DIVISION_ID, PACK_MODEL_CODE, SCM_SITE_ID, PROD_DATE
	  ) B
	  ON A.DIVISION_ID = B.DIVISION_ID AND A.CUTOFF_DATE = B.CUTOFF_DATE AND A.PACK_MODEL_CODE = B.PACK_MODEL_CODE and a.SCM_SITE_ID = b.SCM_SITE_ID and a.PROD_DATE = b.prod_date
	WHERE  1 = 1
	AND    A.DIVISION_ID = @P_DIVISION_ID
	--AND    A.CUTOFF_DATE = '20210705'     cutoff 일자별로 해야하나 ?
	AND    A.PROD_DATE >= @P_FROM_YYYYMMDD
	AND    A.PROD_DATE <= @P_TO_YYYYMMDD
	AND    ISNULL(A.PROD_QTY, 0) > 0
	AND (( @p_item_id		IS NULL OR @p_item_id ='')		OR A.PACK_MODEL_CODE	  IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_item_id , ',')))
	AND (( @p_from_site   IS NULL OR @p_from_site ='')		OR A.SCM_SITE_ID	  IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_from_site , ',')))
	--GROUP BY A.DIVISION_ID, A.PACK_MODEL_CODE, A.SCM_SITE_ID,  A.PROD_DATE
	;

	--////////////////////////////////////////////////////////////////////////////////--
	--// WH_STOCK Measure 추가					 									//--
	--////////////////////////////////////////////////////////////////////////////////--
	SELECT A.DIVISION_ID
	, A.ITEM_ID         AS ITEM_ID
	, A.SCM_SITE_ID     AS FROM_SITE
	, 'WH_STOCK'		AS MEASURE
	--, A.STOCK_DATE		AS YYYYMMDD
	, CONVERT(CHAR(8), DATEADD(DD, 0, CONVERT(VARCHAR, A.STOCK_DATE, 121)), 112) AS YYYYMMDD
	, SUM(ISNULL(STOCK_QTY, 0))  AS QTY

	INTO #TMP_WH_STOCK
	FROM   [DBO].[SCM_DNM_SCS_STOCK] A (NOLOCK)
	WHERE  1 = 1
	AND    DIVISION_ID = @P_DIVISION_ID
	AND    CUTOFF_DATE = @v_cutoff_date
	AND	   LAST_UPDATE_DATE  <= @v_plan_cutoff_date_time
	AND    CELL_PACK   = 'P'
	AND (( @p_item_id		IS NULL OR @p_item_id ='')		OR A.ITEM_ID	  IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_item_id , ',')))
	AND (( @p_from_site   IS NULL OR @p_from_site ='')		OR A.SCM_SITE_ID	  IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_from_site , ',')))
	GROUP BY DIVISION_ID
			, SCM_SITE_ID
			, ITEM_ID
			, STOCK_DATE
	;

	--////////////////////////////////////////////////////////////////////////////////--
	--// -- ERP 재고 데이터 (참조 위치 확인)				 							//--
	--////////////////////////////////////////////////////////////////////////////////--
	WITH MST_STOCK AS
	(

	
		SELECT    division_id
			, company_id
			, item_id
			--, SUM(ssp_qty) AS SSP_QTY
			, SUM(scm_qty) AS SCM_QTY
			, cutoff_date
			, PLANT_ID
			, stock_type
			
			FROM (
			
					SELECT DISTINCT
						division_id
						, company_id
						, item_id
						--, SUM(ssp_qty) AS SSP_QTY
						, scm_qty AS SCM_QTY
						, cutoff_date
						, PLANT_ID
						, stock_type
					FROM [dbo].[SCM_DNM_STOCK_V] WITH(NOLOCK) --SCM_DNM_STOCK_V WITH(NOLOCK) 
					WHERE 1 = 1
					AND division_id = '40'
					AND company_id = @v_C100		--'C100'
					--AND cutoff_date >  @p_stock_yyyymmdd -- 현재일 - 3
					AND cutoff_date = @v_boh_yyyymmdd	
					and plant_id = @v_A010			--'A010'
					AND stock_type = 'INVENTORY'
					--AND ((@p_item_id IS NULL OR @p_item_id ='')	OR item_id IN (SELECT token FROM dbo.String_Split(@p_item_id, ',')))
		) A


		GROUP BY 
			division_id
			, company_id
			, item_id
			, cutoff_date
			, PLANT_ID
			, stock_type
			
		--SELECT
		--	division_id
		--	, company_id
		--	, item_id
		--	--, SUM(ssp_qty) AS SSP_QTY
		--	, SUM(scm_qty) AS SCM_QTY
		--	, cutoff_date
		--	, PLANT_ID
		--	, stock_type
		--FROM [dbo].[SCM_DNM_STOCK_V] WITH(NOLOCK) --SCM_DNM_STOCK_V WITH(NOLOCK) 
		--WHERE 1 = 1
		--AND division_id = '40'
		--AND company_id = 'C100'
		----AND cutoff_date >  @p_stock_yyyymmdd -- 현재일 - 3
		--AND cutoff_date = @v_boh_yyyymmdd	
		--and plant_id = 'A010'
		--AND stock_type = 'INVENTORY'
		----AND ((@p_item_id IS NULL OR @p_item_id ='')	OR item_id IN (SELECT token FROM dbo.String_Split(@p_item_id, ',')))

		--GROUP BY 
		--	division_id
		--	, company_id
		--	, item_id
		--	, cutoff_date
		--	, PLANT_ID
		--	, stock_type	
	)
	SELECT
	T0.division_id			AS DIVISION_ID
	, T0.PLANT_ID
	, T0.item_id			AS ITEM_ID
	, 'ERP'					AS BOH_TYPE
	, cutoff_date			AS YYYYMMDD
	, T0.SCM_QTY            AS QTY
	INTO #TMP_ERP_STOCK
	FROM MST_STOCK T0 WITH(NOLOCK)
	WHERE 1 = 1
	AND T0.stock_type = 'INVENTORY'

	--WITH MST_STOCK AS
	--(
	--	SELECT
	--		division_id
	--		, company_id
	--		, scm_site_id
	--		, item_id
	--		, ssp_qty
	--		, scm_qty
	--		, cutoff_date
	--		, site_id
	--		, storage_id
	--		, PLANT_ID
	--		, OPERATION_ID
	--		, stock_type
	--	FROM [dbo].[SCM_DNM_STOCK_V] WITH(NOLOCK) --SCM_DNM_STOCK_V WITH(NOLOCK) 
	--	WHERE 1 = 1
	--	AND division_id = '40'
	--	AND company_id = 'C100'
	--	AND cutoff_date >  @p_stock_yyyymmdd -- 현재일 - 3
	--	AND cutoff_date = @v_boh_yyyymmdd	
	--	AND ((@p_item_id IS NULL OR @p_item_id ='')	OR item_id IN (SELECT token FROM dbo.String_Split(@p_item_id, ',')))
	--),
	--------------------------------------------------------------------------------------------------------------------------------------
	--MST_LOCATION AS
	--(
	--	SELECT
	--		tt0.DIVISION_ID,	tt0.STORAGE_ID,		tt0.SCM_SITE_ID,		tt0.LOCATION_CODE,		tt0.PLANT_ID,	tt1.COMPANY_ID,		tt0.VALID_YN
	--	FROM SCM_MST_LOCATION tt0 WITH(NOLOCK)
	--	INNER JOIN SCM_MST_SITE tt1 WITH(NOLOCK)
	--		ON tt0.DIVISION_ID = tt1.DIVISION_ID	AND tt0.SCM_SITE_ID = tt1.SCM_SITE_ID
	--		AND tt0.PLANT_ID = tt1.PLANT_ID
	--		AND tt1.DIVISION_ID = '40'	--AND tt1.COMPANY_ID = @p_company_id
	--		AND tt1.VALID_YN ='Y'					AND tt1.site_type = 'PLANT' 
	--	WHERE 1 = 1
	--	AND tt0.VALID_YN ='Y'
	--	AND tt0.DIVISION_ID = '40'
	--	AND tt1.company_id = 'C100'
	--	--AND tt0.LOCATION_CODE IN ('PACK_OWMS', 'CELL_OWMS', 'FORMATION_CHECK_PACKAGING','CMA_BMA')
	--	GROUP BY tt0.DIVISION_ID, tt0.STORAGE_ID, tt0.SCM_SITE_ID, tt0.LOCATION_CODE, tt0.PLANT_ID, tt1.COMPANY_ID,	tt0.VALID_YN
	--)
	--SELECT
	--T0.division_id			AS DIVISION_ID
	--, T0.scm_site_id		AS FROM_SITE
	--, T0.item_id			AS ITEM_ID
	--, 'ERP'					AS BOH_TYPE
	--, cutoff_date			AS YYYYMMDD
	--, T0.scm_qty            AS BOH_QTY
	--, T0.storage_id			AS STORAGE_ID
	--INTO #TMP_ERP_STOCK
	--FROM MST_STOCK T0 WITH(NOLOCK)
	--INNER JOIN MST_LOCATION T1
	--ON T0.division_id = T1.DIVISION_ID			AND T0.storage_id = T1.STORAGE_ID
	--AND T0.PLANT_ID = T1.PLANT_ID				AND T0.COMPANY_ID = T1.COMPANY_ID
	--AND T0.scm_site_id = T1.SCM_SITE_ID
	----AND T1.LOCATION_CODE IN ('PACK_OWMS', 'CELL_OWMS', 'FORMATION_CHECK_PACKAGING','CMA_BMA') -- 
	--WHERE 1 = 1
	--AND T0.stock_type = 'INVENTORY'


	--////////////////////////////////////////////////////////////////////////////////--
	--// TMP_ROWDATA					 											//--
	--////////////////////////////////////////////////////////////////////////////////--

	SELECT DISTINCT
			T0.DIVISION_ID
	,	  T0.ITEM_ID
	,	  T0.FROM_SITE
	,     T0.MEASURE
	,	  T0.YYYYMMDD
	,	  SUM(T0.QTY) QTY
	INTO #TMP_ROWDATA
	FROM 
	(		
		SELECT * FROM #TMP_SHIP_REQ WITH(NOLOCK)
		UNION
		SELECT * FROM #TMP_PACK_RTF WITH(NOLOCK)
		UNION
		SELECT * FROM #TMP_SHIP_CONFIRM WITH(NOLOCK)
		UNION
		SELECT * FROM #TMP_PROD_PLAN WITH(NOLOCK)
		--UNION
		--SELECT * FROM #TMP_WH_STOCK WITH(NOLOCK)
			  
	) T0
	WHERE 1 = 1
	GROUP BY T0.DIVISION_ID
	,	  T0.ITEM_ID
	,	  T0.FROM_SITE
	,     T0.MEASURE
	,	  T0.YYYYMMDD
	--,	  T0.QTY
	;

	--////////////////////////////////////////////////////////////////////////////////--
	--//4. WH_STOCK											//--
	--////////////////////////////////////////////////////////////////////////////////--
	WITH WH_STOCK AS
	(
		SELECT A.DIVISION_ID AS DIVISION_ID
		,	  A.ITEM_ID  AS ITEM_ID
		,	  A.FROM_SITE AS FROM_SITE
		,	  'WH_STOCK'  AS MEASURE
		,	  A.YYYYMMDD  AS YYYYMMDD
		--,	  SUM(A.QTY)  AS QTY
		,	  A.QTY  AS QTY     
		FROM #TMP_WH_STOCK A
		WHERE A.DIVISION_ID	= @p_division_id
			AND A.YYYYMMDD	= @v_cutoff_date 
			AND A.MEASURE			IN('WH_STOCK')
			AND (( @p_item_id		IS NULL OR @p_item_id ='')		OR A.ITEM_ID	  IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_item_id , ',')))
			AND (( @p_from_site		IS NULL OR @p_from_site ='')	OR A.FROM_SITE	  IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_from_site , ',')))
	),
	Deduplication AS
	(
		SELECT
			DIVISION_ID
			, FROM_SITE
			, ITEM_ID
			, C.YYYYMMDD
		FROM #TMP_ROWDATA WITH(NOLOCK)
		LEFT OUTER JOIN (	
								SELECT BASIS_YYYYMMDD AS YYYYMMDD
								FROM   SCM_SYS_CALENDAR_M WITH(NOLOCK)
								WHERE  BASIS_YYYYMMDD >= CONVERT(VARCHAR, DATEADD(D, -1, CONVERT(DATETIME, @p_plan_start_yyyymmdd ,112)) ,112) --@p_plan_start_yyyymmdd
								AND    BASIS_YYYYMMDD <= @p_to_yyyymmdd
								)  C
							ON C.YYYYMMDD    >= CONVERT(VARCHAR, DATEADD(D, -1, CONVERT(DATETIME, @p_plan_start_yyyymmdd ,112)) ,112) --@p_plan_start_yyyymmdd 
							AND   C.YYYYMMDD  <= @p_to_yyyymmdd
		GROUP BY DIVISION_ID, FROM_SITE, ITEM_ID, C.YYYYMMDD
	)
	INSERT INTO #TMP_ROWDATA
	(
		  DIVISION_ID
	,	  ITEM_ID
	,	  FROM_SITE
	,     MEASURE
	,	  YYYYMMDD
	,	  QTY
	)
	SELECT 
		 T0.DIVISION_ID
		, T0.ITEM_ID 
		, T0.FROM_SITE
		, 'WH_STOCK' AS MEASURE
		, T0.YYYYMMDD 
		,
		(
			SELECT
				ISNULL( 
					SUM( 
						CASE	
							WHEN tt0.MEASURE = 'SHIP_CONFIRM' THEN -1 * ISNULL(tt0.QTY, 0)
							WHEN tt0.MEASURE = 'PROD_PLAN' THEN ISNULL(tt0.QTY, 0)
						ELSE 0.0
						END), 
					0)
			FROM #TMP_ROWDATA tt0
			WHERE 1 = 1
			AND tt0.DIVISION_ID = T0.DIVISION_ID
			AND tt0.FROM_SITE = T0.FROM_SITE
			AND tt0.ITEM_ID = T0.ITEM_ID
			AND tt0.MEASURE IN ('SHIP_CONFIRM','PROD_PLAN')
			AND tt0.YYYYMMDD  >=  CONVERT(VARCHAR, DATEADD(D, -1, CONVERT(DATETIME, @p_plan_start_yyyymmdd ,112)) ,112)
			AND tt0.YYYYMMDD <= T0.YYYYMMDD
			) 
			+ 
			ISNULL(T1.QTY, 0) 
				AS QTY
	FROM Deduplication T0 WITH(NOLOCK)
	LEFT OUTER JOIN WH_STOCK T1 WITH(NOLOCK)
		ON T0.DIVISION_ID = T1.DIVISION_ID	AND T0.FROM_SITE = T1.FROM_SITE
		AND T0.ITEM_ID = T1.ITEM_ID			
	WHERE 1 = 1
	  AND T0.YYYYMMDD  <= @p_to_yyyymmdd
	ORDER BY T0.DIVISION_ID, T0.FROM_SITE, T0.ITEM_ID, T0.YYYYMMDD
	;
	--////////////////////////////////////////////////////////////////////////////////--
	--// BALANCE Measure 추가					 									//--
	--////////////////////////////////////////////////////////////////////////////////--
	--//4-2. BALANCE DATA INSERT
		INSERT INTO #TMP_ROWDATA
		(
					DIVISION_ID
				,	  ITEM_ID
				,	  FROM_SITE
				,     MEASURE
				,	  YYYYMMDD
				,	  QTY
		)
		SELECT
			DIVISION_ID,		
			
			ITEM_ID,	
			FROM_SITE,		
			'BALANCE' AS MEASURE,		
			YYYYMMDD,
			ISNULL(
				SUM(
					CASE	WHEN MEASURE = 'SHIP_CONFIRM' THEN -1 * ISNULL(QTY, 0)
							WHEN MEASURE = 'WH_STOCK' THEN ISNULL(QTY, 0)
							--WHEN MEASURE = 'PROD_PLAN' THEN ISNULL(QTY, 0)
					ELSE 0 END
				), 0) AS QTY
		FROM #TMP_ROWDATA WITH(NOLOCK)
		WHERE 1 = 1
		AND MEASURE IN ('SHIP_CONFIRM', 'WH_STOCK','PROD_PLAN')
		AND YYYYMMDD >= CONVERT(VARCHAR, DATEADD(D, -1, CONVERT(DATETIME, @p_plan_start_yyyymmdd ,112)) ,112)
		GROUP BY DIVISION_ID, FROM_SITE, ITEM_ID, YYYYMMDD;


	--WITH BOH AS (    
	--			SELECT   X.DIVISION_ID
	--					, X.ITEM_ID
	--					, X.FROM_SITE AS FROM_SITE
	--					, X.YYYYMMDD
	--					--, SUM(X.QTY) AS QTY 
	--					, X.QTY AS QTY
	--			FROM ( 
	--					-- BOH 
	--					SELECT A.DIVISION_ID
	--					,	  A.ITEM_ID
	--					,	  A.FROM_SITE AS FROM_SITE
	--					,     A.YYYYMMDD
	--					,	  A.QTY AS QTY
	--					FROM #TMP_WH_STOCK A WITH(NOLOCK)          
	--					--FROM #TMP_ROWDATA A WITH(NOLOCK)          
	--					WHERE A.DIVISION_ID	=  @P_DIVISION_ID
	--						--AND A.YYYYMMDD	=  @v_cutoff_date
	--						AND A.MEASURE		IN('WH_STOCK')
	--						AND (( @p_item_id		IS NULL OR @p_item_id ='')		OR A.ITEM_ID	  IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_item_id , ',')))
	--						AND (( @p_from_site   IS NULL OR @p_from_site ='')		OR A.FROM_SITE	  IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_from_site , ',')))	
	--			) X
	--			--GROUP BY  X.DIVISION_ID
	--			--		, X.ITEM_ID
	--			--		, X.FROM_SITE
	--			--		, X.YYYYMMDD
	--			),  
	--	Z AS (
	--			SELECT DISTINCT  
	--			T.DIVISION_ID
	--			,T.FROM_SITE
	--			,T.ITEM_ID
	--			,C.YYYYMMDD
	--			FROM  #TMP_ROWDATA T WITH(NOLOCK)
	--				LEFT OUTER JOIN (	
	--									SELECT BASIS_YYYYMMDD AS YYYYMMDD
	--									FROM   SCM_SYS_CALENDAR_M WITH(NOLOCK)
	--									WHERE  BASIS_YYYYMMDD >= @p_plan_start_yyyymmdd 
	--									AND    BASIS_YYYYMMDD <= @p_to_yyyymmdd
	--									)  C
	--							ON C.YYYYMMDD    >= @p_plan_start_yyyymmdd 
	--							AND   C.YYYYMMDD  <= @p_to_yyyymmdd
	--			WHERE 1=1 
	--			GROUP BY 
	--				T.DIVISION_ID
	--			,T.FROM_SITE
	--			,T.ITEM_ID
	--			,C.YYYYMMDD
	--		) 

	--	INSERT INTO #TMP_ROWDATA (
	--					DIVISION_ID
	--			,	  ITEM_ID
	--			,	  FROM_SITE
	--			,     MEASURE
	--			,	  YYYYMMDD
	--			,	  QTY
	--	)
	--	SELECT    Z.DIVISION_ID                   
	--			,Z.ITEM_ID
	--			,Z.FROM_SITE
	--			,'BALANCE' AS MEASURE
	--			,Z.YYYYMMDD  
	------------------------------------------------------
	--			,  ISNULL(B.QTY,0)  --AS QTY
	--			+ 
	--			(  SELECT ISNULL( SUM( CASE WHEN T.MEASURE = 'SHIP_CONFIRM'   THEN ISNULL(T.QTY,0) * -1
	--									    WHEN T.MEASURE = 'PROD_PLAN' THEN ISNULL(T.QTY, 0)
	--									ELSE 0.0 END
	--									) ,0)    

	--				FROM #TMP_ROWDATA T WITH(NOLOCK)
	--				WHERE 1=1  
	--				AND T.ITEM_ID     = Z.ITEM_ID
 --					AND T.MEASURE              IN ('SHIP_CONFIRM','PROD_PLAN')
	--				AND T.YYYYMMDD             >= @P_PLAN_START_YYYYMMDD
	--				AND T.YYYYMMDD             <= Z.YYYYMMDD 
	--			) AS QTY  			     
	----------------------------------------------------------------------------------------------------------------------------------------
	--	FROM Z WITH(NOLOCK)   
	--	LEFT OUTER JOIN BOH B WITH(NOLOCK) 
	--		ON  Z.DIVISION_ID = B.DIVISION_ID
	--		AND Z.FROM_SITE	  = B.FROM_SITE
	--		AND Z.ITEM_ID     = B.ITEM_ID
			
	--	WHERE 1=1 
	--	;


	--////////////////////////////////////////////////////////////////////////////////--
	--// TMP_RESULT_TABLE				 											//--
	--////////////////////////////////////////////////////////////////////////////////--

	INSERT INTO #TMP_RESULT_TABLE
	(
		DIVISION_ID
		, ITEM_ID
		, FROM_SITE
		, MEASURE
		, YYYYMMDD
		, QTY
		, SEQ
	)
	SELECT  DISTINCT
		X.DIVISION_ID
		, X.ITEM_ID
		, X.FROM_SITE
		, X.MEASURE
		, X.YYYYMMDD
		, ISNULL(R.QTY,0)				AS QTY
		, X.SEQ
	FROM  
	(
			SELECT T.DIVISION_ID 
			,      T.ITEM_ID
			,	 ISNULL(T.FROM_SITE,'-') AS FROM_SITE
			,	 T.QTY
			,    TT1.COLUMN_NAME		 AS MEASURE 
			,	 TT1.COLUMN_LABEL_NAME	 AS MEASURE_NAME																									
			,	 TT1.ATTRIBUTE3			 AS BACK_COLOR							
			,	 TT1.SORT_ORDER_NO		 AS SEQ
			,    T.YYYYMMDD				  
			FROM  #TMP_ROWDATA T				 
			INNER JOIN SCM_MST_SHEET_MEASURE TT1
				ON TT1.PROGRAM_ID = @P_PROGRAM_ID
				AND TT1.SHEET_NAME = @P_SHEET_NAME	
			LEFT OUTER JOIN SCM_MST_TITLESET_USER T3 WITH(NOLOCK)                                                                                       
				ON T3.PROGRAM_ID = TT1.PROGRAM_ID                                                                                                       
				AND T3.SHEET_NAME = TT1.SHEET_NAME                                                                                                      
				AND T3.COLUMN_NAME = TT1.COLUMN_NAME                                                                                                    
				AND T3.USER_ID =  @p_user_id    
	) X
	LEFT OUTER JOIN  #TMP_ROWDATA R  
		ON R.DIVISION_ID		= X.DIVISION_ID
		AND R.ITEM_ID			= X.ITEM_ID
		AND R.MEASURE			= X.MEASURE
		AND R.YYYYMMDD			= X.YYYYMMDD
		AND R.FROM_SITE			= X.FROM_SITE
	WHERE  X.MEASURE IN ('SHIP_REQ', 'SHIP_CONFIRM','PACK_RTF', 'PROD_PLAN','WH_STOCK' ,'BALANCE')
	;

	--////////////////////////////////////////////////////////////////////////////////--
	--// PIVOT				 														//--
	--////////////////////////////////////////////////////////////////////////////////--


	SELECT DISTINCT T0.DIVISION_ID
	,	  T0.ITEM_ID	
	,	  T0.FROM_SITE
	,      T0.MEASURE
	,	  'D_' + T0.YYYYMMDD						AS YYYYMMDD		
	,	  T1.BASIS_YYYYMM							AS YYYYMM
	,	  RIGHT(T1.BASIS_YYYYMM,4) + T1.ISO_WEEK	AS ISO_WEEK
	,	  T0.QTY
	,	  T0.SEQ
	INTO #TMP_RESULT_PIVOT_TABLE
	FROM #TMP_RESULT_TABLE T0
	LEFT OUTER  JOIN SCM_SYS_CALENDAR_M T1 
		ON T0.YYYYMMDD = T1.BASIS_YYYYMMDD		                                
	WHERE 1=1
	;

	/*PIVOIT처리*******************************************************************************/
	BEGIN
		
		-- PIVOIT 대상 날짜문자열 생성
		SET @MQRY_SUM = '';
			
		SELECT  @MQRY_SUM = @MQRY_SUM+','+  CASE WHEN CHARINDEX('M_', YYYYMMDD) =1 THEN  'CEILING(SUM(CASE WHEN T0.YYYYMM   = RIGHT('''+YYYYMMDD+''',6) THEN CONVERT(NUMERIC(20, 10), ISNULL(T0.QTY, 0)) ELSE 0 END )) AS ' + YYYYMMDD
											WHEN CHARINDEX('W_', YYYYMMDD) =1 THEN  'CEILING(SUM(CASE WHEN T0.ISO_WEEK = RIGHT('''+YYYYMMDD+''',6) THEN CONVERT(NUMERIC(20, 10),ISNULL(T0.QTY, 0)) ELSE 0  END )) AS ' + YYYYMMDD
											WHEN CHARINDEX('D_', YYYYMMDD) =1 THEN  'CEILING(SUM(CASE WHEN T0.YYYYMMDD = RIGHT('''+YYYYMMDD+''',10)THEN CONVERT(NUMERIC(20, 10),ISNULL(T0.QTY, 0)) ELSE 0 END )) AS ' + YYYYMMDD
										
									END +''+  CHAR(10)
		FROM ( 
				SELECT 'W_'+A.BASIS_YYYYMM + A.ISO_WEEK AS YYYYMMDD        
					, A.BASIS_START_DATE + CONVERT(CHAR(2), 21) AS SORT_ORDER_NO
				FROM [DBO].[SCM_SYS_CALENDAR_M] A 
				WHERE A.BASIS_YYYYMMDD  BETWEEN @p_from_yyyymmdd AND @p_to_yyyymmdd
				GROUP BY A.BASIS_YYYYMM, A.ISO_WEEK, A.BASIS_START_DATE

				UNION ALL

				SELECT 'M_'+A.BASIS_YYYYMM  AS YYYYMMDD
						,MIN(A.BASIS_START_DATE) + CONVERT(CHAR(2), '01') AS SORT_ORDER_NO
				FROM [DBO].[SCM_SYS_CALENDAR_M] A 
				WHERE A.BASIS_YYYYMMDD  BETWEEN @p_from_yyyymmdd AND @p_to_yyyymmdd
				GROUP BY A.BASIS_YYYYMM, A.MONTH_NAME		

				UNION ALL

				SELECT 'D_'+A.BASIS_YYYYMMDD   AS YYYYMMDD      
						,A.BASIS_YYYYMMDD + CONVERT(CHAR(2), 31) AS SORT_ORDER_NO
				FROM [DBO].[SCM_SYS_CALENDAR_M] A 
				WHERE A.BASIS_YYYYMMDD  BETWEEN @p_from_yyyymmdd AND @p_to_yyyymmdd
				GROUP BY A.BASIS_YYYYMMDD	
				-------------------------------------------------------------------------
				) AS A
		ORDER BY SORT_ORDER_NO  ;
	END;

	--SELECT * FROM #TMP_RESULT_PIVOT_TABLE

	SET @MEXEC = 'SELECT DISTINCT TTT.* FROM ( '	
	SET @MEXEC = @MEXEC+'	SELECT  																																											' + CHAR(10);
	SET @MEXEC = @MEXEC+'         T0.DIVISION_ID																																								' + CHAR(10);
	SET @MEXEC = @MEXEC+'         , T0.ITEM_ID																																									' + CHAR(10);
	SET @MEXEC = @MEXEC+'         , ISNULL(IT.NICK_NAME,''-'')		    AS NICK_NAME																															' + CHAR(10);
	SET @mEXEC = @mEXEC+' 		  , (CASE WHEN T0.MEASURE=''WH_STOCK'' THEN ''SCS'' WHEN T0.MEASURE=''BALANCE'' THEN ''ERP'' ELSE '' '' END ) AS TYPE															' + CHAR(10);
	SET @mEXEC = @mEXEC+' 		  , (CASE WHEN T0.MEASURE=''WH_STOCK'' THEN CONVERT(NUMERIC(20, 10),ISNULL(T5.QTY, 0))
										  WHEN T0.MEASURE=''BALANCE''  THEN CONVERT(NUMERIC(20, 10),ISNULL(T6.QTY, 0))
										ELSE NULL
									END)  AS FIGURE		' +CHAR(10);

	
	SET @MEXEC = @MEXEC+'         , ISNULL(T0.FROM_SITE,''-'') 			AS FROM_SITE																															' + CHAR(10);
	SET @MEXEC = @MEXEC+'         , ISNULL(T4.SITE_DESCRIPTION,''-'')	AS FROM_SITE_NM																															' + CHAR(10);
	SET @MEXEC = @MEXEC+'         , T0.MEASURE							AS MEASURE																																' + CHAR(10);		
	SET @MEXEC = @MEXEC+'         , T2.ATTRIBUTE1						AS PSI_NAME																																' + CHAR(10);		
	SET @MEXEC = @MEXEC+'         , T0.SEQ							 																																			' + CHAR(10);		
	-- 20220221	SMS	추가
	SET @MEXEC = @MEXEC+'         , CASE WHEN ISNULL(T4.SHIP_FROZEN, 0) - 1 > 0 THEN T4.SHIP_FROZEN - 1 ELSE 0 END AS SHIP_FROZEN							 																																			' + CHAR(10);		

	SET @MEXEC = @MEXEC+'       	' + @MQRY_SUM																																								  + CHAR(10);
	SET @MEXEC = @MEXEC+'       FROM #TMP_RESULT_PIVOT_TABLE T0 WITH(NOLOCK)																																	' + CHAR(10);
	
	SET @MEXEC = @MEXEC+'		INNER JOIN SCM_MST_SHEET_MEASURE T2																																				' + CHAR(10);
	SET @MEXEC = @MEXEC+'			ON T0.MEASURE = T2.COLUMN_NAME																																				' + CHAR(10);
	SET @MEXEC = @MEXEC+'			AND T2.PROGRAM_ID = ''' + @p_program_id + '''																																' + CHAR(10);
	SET @MEXEC = @MEXEC+'			AND T2.SHEET_NAME = ''' + @p_sheet_name + '''																																' + CHAR(10);
	
	SET @MEXEC = @MEXEC+'		LEFT OUTER JOIN SCM_MST_TITLESET_USER T3 WITH(NOLOCK)																															' + CHAR(10) ;
	SET @MEXEC = @MEXEC+'			ON T3.PROGRAM_ID = T2.PROGRAM_ID																																			' + CHAR(10) ;
	SET @MEXEC = @MEXEC+'			AND T3.SHEET_NAME = T2.SHEET_NAME																																			' + CHAR(10) ;
	SET @MEXEC = @MEXEC+'			AND T3.COLUMN_NAME = T2.COLUMN_NAME																																			' + CHAR(10) ;
	SET @MEXEC = @MEXEC+'			AND T3.USER_ID = ''' + @p_user_id + '''																																		' + CHAR(10) ;
	
	SET @MEXEC = @MEXEC+'		LEFT OUTER JOIN SCM_MST_SITE T4 WITH(NOLOCK)																																	' + CHAR(10) ;
	SET @MEXEC = @MEXEC+'			ON T0.DIVISION_ID = T4.DIVISION_ID																																			' + CHAR(10) ;
	SET @MEXEC = @MEXEC+'			AND T0.FROM_SITE = T4.SCM_SITE_ID																																			' + CHAR(10) ;
	SET @MEXEC = @MEXEC+'			AND T4.VALID_YN = ''Y''																																						' + CHAR(10) ;

	SET @MEXEC = @MEXEC+'		LEFT OUTER JOIN #TMP_WH_STOCK T5 WITH(NOLOCK)																																	' + CHAR(10) ;
	SET @MEXEC = @MEXEC+'			ON T0.DIVISION_ID = T5.DIVISION_ID																																			' + CHAR(10) ;
	SET @MEXEC = @MEXEC+'			AND T0.FROM_SITE  = T5.FROM_SITE																																			' + CHAR(10) ;
	SET @MEXEC = @MEXEC+'			AND T0.ITEM_ID	  = T5.ITEM_ID																																				' + CHAR(10) ;
	--SET @MEXEC = @MEXEC+'			AND T5.YYYYMMDD   = ''' + @p_plan_start_yyyymmdd + '''																														' + CHAR(10) ;
	SET @MEXEC = @MEXEC+'			AND T5.YYYYMMDD   = '''+@v_cutoff_date+'''																														' + CHAR(10) ;
	SET @MEXEC = @MEXEC+'			AND T5.MEASURE    = ''WH_STOCK''																																			' + CHAR(10) ;

	SET @MEXEC = @MEXEC+'		LEFT OUTER JOIN #TMP_ERP_STOCK T6 WITH(NOLOCK)																																	' + CHAR(10) ;
	SET @MEXEC = @MEXEC+'			ON T0.DIVISION_ID = T6.DIVISION_ID																																			' + CHAR(10) ;																																	
	SET @MEXEC = @MEXEC+'			AND T0.ITEM_ID	  = T6.ITEM_ID																																				' + CHAR(10) ;
	

	SET @MEXEC = @MEXEC+'		INNER JOIN (SELECT DISTINCT DIVISION_ID, ITEM_ID, NICK_NAME																														' + CHAR(10) ;
	SET @MEXEC = @MEXEC+'				    FROM SCM_MST_ITEM_SN WITH (NOLOCK)																																	' + CHAR(10) ;
	SET @MEXEC = @MEXEC+'				   WHERE DIVISION_ID =  ''' + @p_division_id + '''    																													' + CHAR(10) ;
	SET @MEXEC = @MEXEC+'					AND ACTIVE_FLAG = ''Y''																																				' + CHAR(10) ;
	SET @MEXEC = @MEXEC+'					AND SCP_OPERATION_GROUP = ''P''  -- CELL/PACK 구분																													' + CHAR(10) ;
	SET @MEXEC = @MEXEC+'				  ) IT 																																									' + CHAR(10) ;
	SET @MEXEC = @MEXEC+'			ON T0.DIVISION_ID = IT.DIVISION_ID AND T0.ITEM_ID = IT.ITEM_ID																												' + CHAR(10) ;

	SET @MEXEC = @MEXEC + '		LEFT OUTER JOIN SSP_MST_MODEL_USER tt3 WITH(NOLOCK)																' + CHAR(10);                                           
	SET @MEXEC = @MEXEC + '			ON  tt3.DIVISION_ID = t0.DIVISION_ID			                                                            ' + CHAR(10);                                           
	SET @MEXEC = @MEXEC + '			AND tt3.FROM_SITE = t0.FROM_SITE				                                                            ' + CHAR(10);                                           
	SET @MEXEC = @MEXEC + '			AND tt3.ITEM_ID = t0.ITEM_ID					                                                             ' + CHAR(10);                                          
	SET @MEXEC = @MEXEC + '			AND tt3.VALID_YN = ''Y''																					' + CHAR(10);
	SET @MEXEC = @MEXEC+'		WHERE 1 = 1																										' + CHAR(10);
	SET @MEXEC = @MEXEC+'		AND T2.PROGRAM_ID = ''' + @P_PROGRAM_ID + '''                                                                                               ' + CHAR(10) ;
	SET @MEXEC = @MEXEC+'		AND T2.SHEET_NAME = ''' + @P_SHEET_NAME + '''                                                                                               ' + CHAR(10) ;
	SET @MEXEC = @MEXEC+'		AND T2.VALID_YN = ''Y''                                                                                                                     ' + CHAR(10) ;
	--체크박스 체크 여부 조회 시작(@p_nonChk = 'Y' : 체크박스 선택 안한 상태)
	--SET @mDQry1 = @mDQry1 + '		AND ((''' + @p_nonChk + ''' = ''Y'' AND 1 = 1 OR tt3.USER_ID = CASE WHEN ''' + @p_myModelChk + ''' = ''Y'' THEN ''' + @p_user_id + ''' ELSE ''X'' END				' + char(10) ;
	SET @MEXEC = @MEXEC + '		AND ((''' + @p_nonChk + ''' = ''Y'' AND 1 = 1 OR tt3.USER_ID IN (SELECT CASE WHEN ''' + @p_myModelChk + ''' = ''Y'' THEN ''' + @p_user_id + ''' ELSE ''X'' END		' + char(10) ;
	SET @MEXEC = @MEXEC + '																		 UNION 																								' + char(10) ;
	SET @MEXEC = @MEXEC + '																		 SELECT CASE WHEN ''' + @p_delegateeChk + ''' = ''Y'' THEN USER_ID ELSE ''X'' END					' + char(10) ;
	SET @MEXEC = @MEXEC + '																		 FROM SSP_MST_DELEGATE with(nolock) WHERE VALID_YN = ''Y'' AND DELEGATEE_ID = ''' + @p_user_id + ''' GROUP BY USER_ID) 				' + char(10) ;
	SET @MEXEC = @MEXEC + '		   											  OR tt3.PART_LEADER = CASE WHEN ''' + @p_partLeaderChk + ''' = ''Y'' THEN ''' + @p_user_id + ''' ELSE ''X'' END		' + char(10) ;
	SET @MEXEC = @MEXEC + '		   											  OR tt3.TEAM_LEADER = CASE WHEN ''' + @p_teamLeaderChk + ''' = ''Y'' THEN ''' + @p_user_id + ''' ELSE ''X'' END))		' + char(10) ;
	--체크박스 체크 여부 조회 끝
	
	IF (@p_from_site IS NOT NULL AND @p_from_site !='')
		SET @MEXEC = @MEXEC+'		AND (( '''+@p_from_site+'''   IS NULL OR '''+@p_from_site+''' ='''')   OR T0.FROM_SITE	  IN (SELECT TOKEN FROM DBO.STRING_SPLIT('''+@p_from_site+''' , '','')))                                                                                                 ' + CHAR(10) ;
	
	
	SET @MEXEC = @MEXEC+' 		AND ('+CONVERT(VARCHAR,@V_CNT_USR_MEASURE)+' = 0                                      ' + CHAR(10) ;                                                                                                                 
	SET @MEXEC = @MEXEC+' 						OR EXISTS (SELECT 1                                    ' + CHAR(10) ;                                                                                                                 
	SET @MEXEC = @MEXEC+' 									 FROM #TblDynamicTitlest_SSP0015			   ' + CHAR(10) ;                                                                                                                 
	SET @MEXEC = @MEXEC+' 									 WHERE COLUMN_NAME = T2.COLUMN_NAME)         ' + CHAR(10) ;                                                                                                                 
	SET @MEXEC = @MEXEC+' 				                  )                                            ' + CHAR(10) ; 	
	SET @MEXEC = @MEXEC+' 			  AND ( ( '+CONVERT(VARCHAR,@V_CNT_USR_MEASURE)+' = 0 AND T2.DEFAULT_FLAG=''Y'' )                                      ' + CHAR(10) ;                                                                                                                 
	SET @MEXEC = @MEXEC+' 						OR  ('+CONVERT(VARCHAR,@V_CNT_USR_MEASURE)+' != 0 )       ' + CHAR(10) ;                                                                                                                 
	SET @MEXEC = @MEXEC+' 				                  )                                            ' + CHAR(10) ; 	
	SET @MEXEC = @MEXEC+'		AND T2.COLUMN_NAME = T0.MEASURE																							' + CHAR(10) ;
	-- 20220221	SMS	추가 	T4.SHIP_FROZEN
--	SET @MEXEC = @MEXEC+'		GROUP BY T0.DIVISION_ID, T0.ITEM_ID, IT.NICK_NAME, T0.FROM_SITE, T4.SITE_DESCRIPTION, T0.MEASURE, T0.SEQ, T2.ATTRIBUTE1, T5.QTY, T6.QTY ' + CHAR(10);
	SET @MEXEC = @MEXEC+'		GROUP BY T0.DIVISION_ID, T0.ITEM_ID, IT.NICK_NAME, T0.FROM_SITE, T4.SITE_DESCRIPTION, T0.MEASURE, T0.SEQ, T2.ATTRIBUTE1, T5.QTY, T6.QTY, T4.SHIP_FROZEN ' + CHAR(10);
	SET @MEXEC = @MEXEC+'	) TTT' + CHAR(10);
	SET @MEXEC = @MEXEC+'		ORDER BY TTT.DIVISION_ID, TTT.FROM_SITE DESC, TTT.ITEM_ID, TTT.SEQ ASC		' + CHAR(10);

	EXEC(@MEXEC);



	-- Requestor
	IF OBJECT_ID('tempdb..#TblDynamicTitlest_SSP0015') IS NOT NULL
		DROP TABLE #TblDynamicTitlest_SSP0015;


	-- SHIPMENT ROW DATA
	IF OBJECT_ID('TEMPDB..#TMP_ROWDATA') IS NOT NULL	
		DROP TABLE #TMP_ROWDATA;
	
	IF OBJECT_ID('TEMPDB..#TMP_RESULT_PIVOT_TABLE') IS NOT NULL	
		DROP TABLE #TMP_RESULT_PIVOT_TABLE;

	IF OBJECT_ID('TEMPDB..#TMP_RESULT_TABLE') IS NOT NULL	
		DROP TABLE #TMP_RESULT_TABLE;

	-- SHIPMENT REQUEST DATA
	IF OBJECT_ID('TEMPDB..#TMP_SHIP_REQ') IS NOT NULL	
		DROP TABLE #TMP_SHIP_REQ;
	
	-- PACK RTF DATA
	IF OBJECT_ID('TEMPDB..#TMP_PACK_RTF') IS NOT NULL	
		DROP TABLE #TMP_PACK_RTF;

	-- SHIPMENT CONFIRM DATA
	IF OBJECT_ID('TEMPDB..#TMP_SHIP_CONFIRM') IS NOT NULL	
		DROP TABLE #TMP_SHIP_CONFIRM;
	
	-- PROD_PLAN DATA
	IF OBJECT_ID('TEMPDB..#TMP_PROD_PLAN') IS NOT NULL	
		DROP TABLE #TMP_PROD_PLAN;
	
	-- WH_STOCK DATA
	IF OBJECT_ID('TEMPDB..#TMP_WH_STOCK') IS NOT NULL	
		DROP TABLE #TMP_WH_STOCK;

	-- ERP_STOCK DATA
	IF OBJECT_ID('TEMPDB..#TMP_ERP_STOCK') IS NOT NULL	
		DROP TABLE #TMP_ERP_STOCK;
	

END
