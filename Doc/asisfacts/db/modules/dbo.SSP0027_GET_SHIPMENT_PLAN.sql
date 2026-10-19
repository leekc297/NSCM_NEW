
/*
 * Program ID   : SSP0027_GET_SHIPMENT_PLAN
 * Description  : ESS 상품자재 Shipment Plan
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2021/03/24   KIMYONGHO		신규추가
 * 2024/10/01   KHJ             NERP_SSP
 */
CREATE PROCEDURE [dbo].[SSP0027_GET_SHIPMENT_PLAN]
	 @p_division_id			VARCHAR(10)
	,@p_company_id			NVARCHAR(100)
	,@p_from_site			NVARCHAR(MAX)
	,@p_plan_start_yyyymmdd	NVARCHAR(8)
	,@p_from_yyyymmdd		NVARCHAR(8)
	,@p_to_yyyymmdd			NVARCHAR(8)
	,@p_project_code		NVARCHAR(MAX)
	,@p_item_id				NVARCHAR(MAX)
	,@p_user_id				NVARCHAR(MAX)
	,@p_program_id			NVARCHAR(MAX) = 'SSP0027' 
	,@p_sheet_name			NVARCHAR(MAX) = 'Purchasing PSI(ESS)'
	,@p_real_flag			CHAR(1)
AS  
  
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;	
	
	DECLARE @v_from_yyyymmdd		NVARCHAR(8);
	DECLARE @v_to_yyyymmdd			NVARCHAR(8);
	DECLARE @v_boh_yyyymmdd			NVARCHAR(8);
	DECLARE @v_plan_cutoff_yyyymmdd	NVARCHAR(8);
	DECLARE @v_current_yyyymmdd		NVARCHAR(8);

	DECLARE @mQry_sum NVARCHAR(MAX);
	DECLARE @mEXEC NVARCHAR(MAX);
	DECLARE @mDAY_QTY NVARCHAR(MAX);

	DECLARE @p_stock_yyyymmdd NVARCHAR(8);

	DECLARE @v_seq				INT;

	-- NERP 매핑코드
    DECLARE @v_C100 NVARCHAR(10);
    DECLARE @v_KR012031 NVARCHAR(20);
    DECLARE @v_Storage_6006 NVARCHAR(20);
	SET @v_C100 = dbo.FN_GET_LOOKUP_VALUE('SSP0027_GET_SHIPMENT_PLAN'  ,'ESOC' );	--C100
	SET @v_KR012031 = dbo.FN_GET_LOOKUP_VALUE('SSP0027_GET_SHIPMENT_PLAN'  ,'KR012031P' )
	SET @v_Storage_6006 = dbo.FN_GET_LOOKUP_VALUE('SSP0027_GET_SHIPMENT_PLAN'  ,'STORAGE_6006' )


	SET @p_stock_yyyymmdd = CONVERT(CHAR(8), DATEADD(DD, -3, CONVERT(VARCHAR, @p_from_yyyymmdd, 121)), 112); --FROM -3일

	SET @v_from_yyyymmdd = @p_from_yyyymmdd;
	SET @v_to_yyyymmdd = @p_to_yyyymmdd;
	--SET @v_boh_yyyymmdd = CONVERT(CHAR(8), DATEADD(DD, -1, CONVERT(VARCHAR, @p_from_yyyymmdd, 121)), 112); --FROM -1일
	SET @v_boh_yyyymmdd = @p_plan_start_yyyymmdd;
	SET @v_current_yyyymmdd = CONVERT(VARCHAR(8), CONVERT(DATETIME, GETDATE()), 112);

	SELECT @v_plan_cutoff_yyyymmdd = ATTRIBUTE1 
	FROM SCM_ADM_LOOKUP_MASTER_DETAIL AS X WITH(NOLOCK) 
	WHERE X.LOOKUP_TYPE	= 'SSP_ANL_ESS_PLAN'
	  AND X.SEGMENT1	= @p_division_id;


		-- DATA 생성 FROM ~ TO 
	SET @v_from_yyyymmdd = @v_from_yyyymmdd ; 
	SET @v_to_yyyymmdd   = CONVERT(VARCHAR, DATEADD(D, 84, CONVERT(DATETIME, @v_from_yyyymmdd ,112)) ,112) ; --12주(84일)   


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

	
	IF OBJECT_ID('tempdb..#TblDynamicTitlest_SSP0027') IS NOT NULL	
		DROP TABLE #TblDynamicTitlest_SSP0027;

	-- SHIPMENT BOH
	IF OBJECT_ID('tempdb..#Tmp_BOHData_STORAGE') IS NOT NULL	
		DROP TABLE #Tmp_BOHData_STORAGE;

	IF OBJECT_ID('tempdb..#Tmp_BOHData') IS NOT NULL	
		DROP TABLE #Tmp_BOHData;

	-- SHIPMENT ROW DATA
	IF OBJECT_ID('tempdb..#Tmp_RowData') IS NOT NULL	
		DROP TABLE #Tmp_RowData;

	IF OBJECT_ID('tempdb..#Tmp_Allo_Qty_Table') IS NOT NULL	
		DROP TABLE #Tmp_Allo_Qty_Table;

	IF OBJECT_ID('tempdb..#Tmp_Allo_Qty_Table_Old') IS NOT NULL	
		DROP TABLE #Tmp_Allo_Qty_Table_Old;

	IF OBJECT_ID('tempdb..#Tmp_Result_PIVOT_Table') IS NOT NULL	
		DROP TABLE #Tmp_Result_PIVOT_Table;

	IF OBJECT_ID('tempdb..#Tmp_Result_PIVOT_Table_Old') IS NOT NULL	
		DROP TABLE #Tmp_Result_PIVOT_Table_Old;

	IF OBJECT_ID('tempdb..#Tmp_Result_Table') IS NOT NULL	
		DROP TABLE #Tmp_Result_Table;

	SELECT * INTO #TblDynamicTitlest_SSP0027 
	FROM SCM_MST_TITLESET_USER WITH(NOLOCK)
	WHERE PROGRAM_ID	= @p_program_id
		AND SHEET_NAME  = @p_sheet_name
		AND USER_ID     = @p_user_id;

	CREATE TABLE #Tmp_Result_Table
	(
		DIVISION_ID		NVARCHAR(30)
		, FROM_SITE		NVARCHAR(30)
		, ITEM_ID		NVARCHAR(50)
		, PROJECT_CODE	NVARCHAR(50)
		, MEASURE		NVARCHAR(50)
		, SEQ			INT
		, CONFIRM_DAY   INT
		, YYYYMMDD		NVARCHAR(8)
		, QTY			NUMERIC(20, 10)
		, LOT_YN		CHAR(1)
	);
	/********************************************************************************/

	--////////////////////////////////////////////////////////////////////////////////--
	--//1. BOH																		//--
	--////////////////////////////////////////////////////////////////////////////////--

	WITH MST_STOCK AS
	(
		SELECT A.DIVISION_ID
			, A.COMPANY_ID
			, A.ITEM_ID
			, A.UOM
			, A.INV_QTY					AS INV_QTY
			, 0							AS INV_ALLO_QTY
			, A.PLAN_START_YYYYMMDD		AS PLAN_START_YYYYMMDD
			, A.SITE_ID
			, A.STORAGE_ID
			, A.PLANT_ID
			, @p_real_flag				AS REAL_FLAG

		FROM SSP_ANL_ESS_STOCK A WITH(NOLOCK)
		WHERE 1 = 1
		AND A.DIVISION_ID		  = @p_division_id
		AND A.COMPANY_ID		  = @p_company_id
		AND A.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd 
		AND A.UOM <> '-'
		AND A.STORAGE_ID = @v_Storage_6006		--'6006'
		AND ((@p_item_id IS NULL OR @p_item_id ='')	OR A.ITEM_ID IN (SELECT token FROM dbo.String_Split(@p_item_id, ',')))


		UNION ALL

		SELECT A.DIVISION_ID
			, @p_company_id			AS COMPANY_ID
			, A.ITEM_ID
			, A.UOM
			, 0						AS INV_QTY
			, A.INV_ALLO_QTY		AS INV_ALLO_QTY
			, A.PLAN_START_YYYYMMDD AS PLAN_START_YYYYMMDD
			, ''					AS SITE_ID
			, ''					AS STORAGE_ID
			, ''					AS PLANT_ID
			, 'N'					AS REAL_FLAG
			
		FROM SSP_ANL_ESS_PLAN A WITH(NOLOCK)
		WHERE 1 = 1
		AND A.DIVISION_ID = @p_division_id
		AND A.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
		AND A.MEASURE = 'BNP_IN' 
		AND A.UOM <> '-'
		AND ((@p_project_code IS NULL OR @p_project_code ='')	OR A.PROJECT_CODE IN (SELECT token FROM dbo.String_Split(@p_project_code, ',')))
		AND ((@p_item_id IS NULL OR @p_item_id ='')	OR A.ITEM_ID IN (SELECT token FROM dbo.String_Split(@p_item_id, ',')))


		UNION ALL

		SELECT A.DIVISION_ID
			, @p_company_id			AS COMPANY_ID
			, A.ITEM_ID
			, A.UOM
			, 0						 AS INV_QTY
			, A.INV_ALLO_QTY		 AS INV_ALLO_QTY
			, @p_plan_start_yyyymmdd AS PLAN_START_YYYYMMDD
			, ''					 AS SITE_ID
			, ''					 AS STORAGE_ID
			, ''					 AS PLANT_ID
			, 'Y'					 AS REAL_FLAG
		FROM SSP_ANL_ESS_REQ A WITH(NOLOCK)
		     inner join SSP_ANL_ESS_REQ_NET B WITH(NOLOCK)
		  on A.DM_REQ_NO = B.DM_REQ_NO
		 and A.ITEM_ID   = B.ITEM_ID
		 and B.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
		WHERE 1 = 1
		AND A.DIVISION_ID = @p_division_id
		AND A.YYYYMMDD >= @v_from_yyyymmdd
		AND A.YYYYMMDD <= @v_to_yyyymmdd
		AND A.UOM <> '-'
		AND ((@p_project_code IS NULL OR @p_project_code ='')	OR A.PROJECT_CODE IN (SELECT token FROM dbo.String_Split(@p_project_code, ',')))
		AND ((@p_item_id IS NULL OR @p_item_id ='')	OR A.ITEM_ID IN (SELECT token FROM dbo.String_Split(@p_item_id, ',')))

	)
	SELECT DIVISION_ID			AS DIVISION_ID
		, ITEM_ID				AS ITEM_ID
		, CONVERT(NVARCHAR(8), YYYYMMDD, 112) AS YYYYMMDD
		, BOH_TYPE				AS BOH_TYPE
		, UOM					AS UOM
		, SUM(M_BOH_QTY)		AS M_BOH_QTY
		, SUM(ALLO_BOH_QTY)		AS ALLO_BOH_QTY
		--, SUM(DAILY_BOH_QTY)	AS DAILY_BOH_QTY
	INTO #Tmp_BOHData_STORAGE
	FROM
	(
		SELECT T0.DIVISION_ID
			, T0.ITEM_ID
			, T0.BOH_TYPE
			, MAX(T0.UOM) AS UOM
			, T0.YYYYMMDD
			, SUM(T0.M_BOH_QTY)	    AS M_BOH_QTY
			, SUM(T0.ALLO_BOH_QTY)  AS ALLO_BOH_QTY
			--, SUM(T0.DAILY_BOH_QTY) AS DAILY_BOH_QTY
		FROM
		(
			SELECT
				 T0.DIVISION_ID				 AS DIVISION_ID
				, T0.ITEM_ID				 AS ITEM_ID
				, 'BOH'						 AS BOH_TYPE
				, T0.UOM					 AS UOM
				, PLAN_START_YYYYMMDD		 AS YYYYMMDD
				, ISNULL(T0.INV_QTY, 0)		 AS M_BOH_QTY
				, ISNULL(T0.INV_ALLO_QTY, 0) AS ALLO_BOH_QTY
				--, ISNULL(T0.INV_QTY, 0) - ISNULL(T0.INV_ALLO_QTY, 0) AS DAILY_BOH_QTY
			FROM MST_STOCK T0 WITH(NOLOCK)
			WHERE 1 = 1
			AND REAL_FLAG = @p_real_flag 
		) AS T0
		GROUP BY T0.DIVISION_ID, T0.ITEM_ID, T0.BOH_TYPE, T0.UOM, T0.M_BOH_QTY, T0.ALLO_BOH_QTY, T0.YYYYMMDD
		
	) AS TMP_BOH
	GROUP BY DIVISION_ID, ITEM_ID,  YYYYMMDD, BOH_TYPE, UOM
	;

	SELECT T0.ITEM_ID, T0.DIVISION_ID, T0.PLANT_SITE_ID, MAX(T0.UOM) AS UOM, T0.PROJECT_CODE, SUM(T0.INV_ALLO_QTY) AS  ALLO_BOH_QTY
	--SELECT T0.ITEM_ID, T0.DIVISION_ID, T0.PLANT_SITE_ID, T0.UOM, SUM(T0.INV_ALLO_QTY) AS  ALLO_BOH_QTY
	INTO #Tmp_Allo_Qty_Table
	FROM SSP_ANL_ESS_REQ T0 WITH(NOLOCK)
		     inner join SSP_ANL_ESS_REQ_NET B WITH(NOLOCK)
		  on T0.DM_REQ_NO = B.DM_REQ_NO
		 and T0.ITEM_ID   = B.ITEM_ID
		 and B.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd	
	WHERE 1=1
	AND T0.DIVISION_ID = @p_division_id
	AND T0.yyyymmdd >= @v_from_yyyymmdd
	AND T0.yyyymmdd <= @v_to_yyyymmdd
	AND ((@p_project_code IS NULL OR @p_project_code ='')	OR T0.PROJECT_CODE IN (SELECT token FROM dbo.String_Split(@p_project_code, ',')))
	AND ((@p_item_id IS NULL OR @p_item_id ='')	OR T0.ITEM_ID IN (SELECT token FROM dbo.String_Split(@p_item_id    ,',')))
	GROUP BY T0.ITEM_ID, T0.DIVISION_ID, T0.PLANT_SITE_ID, T0.PROJECT_CODE
	;


	SELECT T0.ITEM_ID, T0.DIVISION_ID, T0.PLANT_SITE_ID, MAX(T0.UOM) AS UOM, T0.PROJECT_CODE, SUM(T0.INV_ALLO_QTY) AS  ALLO_BOH_QTY
	--SELECT T0.ITEM_ID, T0.DIVISION_ID, T0.PLANT_SITE_ID, T0.UOM, SUM(T0.INV_ALLO_QTY) AS  ALLO_BOH_QTY
	INTO #Tmp_Allo_Qty_Table_Old
	FROM SSP_ANL_ESS_PLAN T0 WITH(NOLOCK)
	WHERE 1=1
	AND T0.DIVISION_ID = @p_division_id
	AND T0.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
	AND T0.MEASURE = 'BNP_IN' 
	AND T0.yyyymmdd >= @v_from_yyyymmdd
	AND T0.yyyymmdd <= @v_to_yyyymmdd
	AND T0.UOM <> '-'
	AND ((@p_project_code IS NULL OR @p_project_code ='')	OR T0.PROJECT_CODE IN (SELECT token FROM dbo.String_Split(@p_project_code, ',')))
	AND ((@p_item_id IS NULL OR @p_item_id ='')	OR T0.ITEM_ID IN (SELECT token FROM dbo.String_Split(@p_item_id    ,',')))
	GROUP BY T0.ITEM_ID, T0.DIVISION_ID, T0.PLANT_SITE_ID, T0.PROJECT_CODE
	;

	
	SELECT T0.DIVISION_ID	
		, T0.ITEM_ID	
		, CONVERT(NVARCHAR(8), T0.YYYYMMDD, 112) AS YYYYMMDD		
		, T0.BOH_TYPE			 AS BOH_TYPE
		, MAX(T0.UOM)		 AS UOM
		, SUM(T0.M_BOH_QTY)		AS M_BOH_QTY		
		, SUM(T0.ALLO_BOH_QTY)	 AS ALLO_BOH_QTY		
		--, SUM(DAILY_BOH_QTY) AS DAILY_BOH_QTY
	--	, PROJECT_CODE
	INTO #Tmp_BOHData
	FROM #Tmp_BOHData_STORAGE T0
	GROUP BY T0.DIVISION_ID,  T0.ITEM_ID,  T0.YYYYMMDD, T0.BOH_TYPE


	--SELECT * FROM #Tmp_BOHData;
	
	IF @p_real_flag = 'Y'
	BEGIN
		--////////////////////////////////////////////////////////////////////////////////--
		--//2. DATA ROW DATE															//--
		--////////////////////////////////////////////////////////////////////////////////--

		SELECT
			T0.DIVISION_ID
			, T0.ITEM_ID
			, T0.FROM_SITE
			, T0.PROJECT_CODE
			, T0.MEASURE
			, T0.SEQ
			, T0.YYYYMMDD
			, SUM(T0.QTY) AS QTY
			, CASE WHEN (T1.SHIP_FROZEN - 1) > 0 THEN (T1.SHIP_FROZEN - 1) ELSE 0 END AS CONFIRM_DAY
		INTO #Tmp_RowData
		FROM 
		(
			--////////////////////////////////////////////////////////////////////////////////--
			--//2-1. BNP in : 납품 요청														//--
			--//	SSP_ANL_ESS_REQ / MEASURE = 'BNP_IN'									//--
			--////////////////////////////////////////////////////////////////////////////////--

			SELECT R.DIVISION_ID			AS DIVISION_ID
				,  R.ITEM_ID					AS ITEM_ID			
--				, CASE WHEN R.[PLANT_SITE_ID] IS NULL OR R.[PLANT_SITE_ID] = '' THEN 'KR012031-P' ELSE R.[PLANT_SITE_ID] END AS FROM_SITE  --PeopleWorks-KR-2
				, CASE WHEN R.[PLANT_SITE_ID] IS NULL OR R.[PLANT_SITE_ID] = '' THEN @v_KR012031 ELSE R.[PLANT_SITE_ID] END AS FROM_SITE  --PeopleWorks-KR-2
				, R.PROJECT_CODE			AS PROJECT_CODE
				, 'BNP_IN'					AS MEASURE
				, R.YYYYMMDD				AS YYYYMMDD
				, R.QTY						AS QTY
				, 1							AS SEQ
			FROM DM_PLN_MKT_FCST R WITH(NOLOCK)
           INNER JOIN DM_MST_ITEM_SINGLE_V M WITH(NOLOCK)
			 ON R.DIVISION_ID = M.DIVISION_ID
			   AND R.ITEM_ID       = M.ITEM_ID
			WHERE R.MEASURE     = 'BNPIn'
			AND R.DIVISION_ID  = @p_division_id 
			AND R.yyyymmdd		>= @v_from_yyyymmdd	
			AND R.yyyymmdd		<= @v_to_yyyymmdd	
			--AND R.QTY > 0
--			AND (( @p_from_site IS NULL OR @p_from_site ='') OR CASE WHEN R.[PLANT_SITE_ID] IS NULL OR R.[PLANT_SITE_ID] = '' THEN 'KR012031-P' ELSE R.[PLANT_SITE_ID] END IN (SELECT token FROM dbo.String_Split(@p_from_site , ',')))
			AND (( @p_from_site IS NULL OR @p_from_site ='') OR CASE WHEN R.[PLANT_SITE_ID] IS NULL OR R.[PLANT_SITE_ID] = '' THEN @v_KR012031 ELSE R.[PLANT_SITE_ID] END IN (SELECT token FROM dbo.String_Split(@p_from_site , ',')))
			AND ((@p_project_code IS NULL OR @p_project_code ='')	OR R.PROJECT_CODE IN (SELECT token FROM dbo.String_Split(@p_project_code, ',')))
			AND (( @p_item_id IS NULL OR @p_item_id ='') OR R.ITEM_ID IN (SELECT token FROM dbo.String_Split(@p_item_id , ',')))

			--SELECT T0.DIVISION_ID			AS DIVISION_ID
			--	, T0.ITEM_ID				AS ITEM_ID
			--	, T0.PLANT_SITE_ID			AS FROM_SITE
			--	, T0.PROJECT_CODE			AS PROJECT_CODE
			--	, 'BNP_IN'					AS MEASURE
			--	, T0.YYYYMMDD				AS YYYYMMDD
			--	, T0.PLAN_QTY				AS QTY
			--	, 1							AS SEQ
			--FROM   SSP_ANL_ESS_REQ T0 WITH(NOLOCK)
			--INNER JOIN SCM_MST_SITE T1 WITH(NOLOCK)
			--	ON T0.DIVISION_ID	 = @p_division_id		
			--	AND	T0.PLANT_SITE_ID = T1.SCM_SITE_ID
			--	AND T1.COMPANY_ID	 = @p_company_id
			--	AND T1.SITE_TYPE	 = 'PLANT'				
			--	AND T1.VALID_YN		 = 'Y'
			--WHERE  1=1
			--AND T0.DIVISION_ID  = @p_division_id 
			--AND T1.COMPANY_ID   = @p_company_id
			--AND T0.yyyymmdd		>= @v_from_yyyymmdd	
			--AND T0.yyyymmdd		<= @v_to_yyyymmdd	
			--AND T0.PLAN_QTY > 0
			--AND (( @p_from_site IS NULL OR @p_from_site ='') OR T0.PLANT_SITE_ID IN (SELECT token FROM dbo.String_Split(@p_from_site , ',')))
			--AND ((@p_project_code IS NULL OR @p_project_code ='')	OR T0.PROJECT_CODE IN (SELECT token FROM dbo.String_Split(@p_project_code, ',')))
			--AND (( @p_item_id IS NULL OR @p_item_id ='') OR T0.ITEM_ID IN (SELECT token FROM dbo.String_Split(@p_item_id , ',')))

			UNION ALL
			--//PR//===================================================================
			--////////////////////////////////////////////////////////////////////////////////--
			--//2-2. PR : BOH Allo 제외 PR 수량												//--
			--//	SSP_ANL_ESS_PR / MEASURE = 'PR'											//--
			--////////////////////////////////////////////////////////////////////////////////--
			SELECT '82'						AS DIVISION_ID --T0.DIVISION_ID
					, T0.PR_ITEM_ID			AS ITEM_ID
--					, 'KR012031-P'			AS FROM_SITE	--T0.FROM_SITE
					, @v_KR012031			AS FROM_SITE	--T0.FROM_SITE
					, T1.PROJECT_CODE		AS PROJECT_CODE
					, 'PR'					AS MEASURE
					, T0.YYYYMMDD			AS YYYYMMDD
					, T0.PR_REQ_QTY			AS QTY
					, 2                     AS SEQ
				FROM SSP_ANL_ESS_PR T0 WITH (NOLOCK)
				LEFT OUTER JOIN SSP_ANL_ESS_REQ T1 WITH (NOLOCK)
					ON T0.DM_REQ_NO		= T1.DM_REQ_NO
					AND T0.PR_ITEM_ID	= T1.ITEM_ID
					--AND T0.PR_ITEM_SEQ	= T1.ITEM_SEQ
				WHERE 1 = 1
			AND T0.YYYYMMDD		>= @v_from_yyyymmdd	
			AND T0.YYYYMMDD		<= @v_to_yyyymmdd	
			AND T0.PR_REQ_QTY > 0
			AND (( @p_item_id IS NULL OR @p_item_id ='') OR T0.PR_ITEM_ID IN (SELECT token FROM dbo.String_Split(@p_item_id , ',')))

			UNION ALL
			--//PO//===================================================================
			--////////////////////////////////////////////////////////////////////////////////--
			--//2-3. PO : ERP PO 생성일 및 PO 수량											//--
			--//	SSP_ANL_ESS_PO_IN / MEASURE = 'PO'											//--
			--////////////////////////////////////////////////////////////////////////////////--
			SELECT '82'						AS DIVISION_ID --T0.DIVISION_ID
					, T0.PO_ITEM_ID			AS ITEM_ID
--					, 'KR012031-P'			AS FROM_SITE	--T0.FROM_SITE
					, @v_KR012031			AS FROM_SITE	--T0.FROM_SITE
					, T2.PROJECT_CODE		AS PROJECT_CODE
					, 'PO'					AS MEASURE
					, T0.PO_CREATED_DATE	AS YYYYMMDD
					, T0.PO_QTY				AS QTY
					, 3                     AS SEQ
				FROM SSP_ANL_ESS_PO T0 WITH (NOLOCK)
				LEFT OUTER JOIN SSP_ANL_ESS_PR T1 WITH (NOLOCK)
					ON T0.PR_NO= T1.PR_NO
					AND T0.PO_ITEM_ID	= T1.PR_ITEM_ID
					--AND T0.PO_ITEM_SEQ	= T1.PR_ITEM_SEQ
				LEFT OUTER JOIN SSP_ANL_ESS_REQ T2 WITH (NOLOCK)
					ON T1.DM_REQ_NO		= T2.DM_REQ_NO
					AND T1.PR_ITEM_ID	= T2.ITEM_ID
					--AND T1.PR_ITEM_SEQ	= T2.ITEM_SEQ
				WHERE 1 = 1
			AND T0.PO_CREATED_DATE		>= @v_from_yyyymmdd	
			AND T0.PO_CREATED_DATE		<= @v_to_yyyymmdd	
			AND T0.PO_QTY		> 0
			AND (( @p_item_id IS NULL OR @p_item_id ='') OR T0.PO_ITEM_ID IN (SELECT token FROM dbo.String_Split(@p_item_id , ',')))

			UNION ALL
			--//PO//===================================================================
			--////////////////////////////////////////////////////////////////////////////////--
			--//2-3. PO_RTF : PO에 대한 납품 예정일											//--
			--//	SSP_ANL_ESS_PO / MEASURE = 'PO_RTF'											//--
			--////////////////////////////////////////////////////////////////////////////////--
			SELECT '82'						AS DIVISION_ID --T0.DIVISION_ID
				, T0.PO_ITEM_ID			AS ITEM_ID
--				, 'KR012031-P'			AS FROM_SITE	--T0.FROM_SITE
				, @v_KR012031			AS FROM_SITE	--T0.FROM_SITE
				, T1.PROJECT_CODE		AS PROJECT_CODE
				, 'PO_RTF'				AS MEASURE
				, T0.YYYYMMDD			AS YYYYMMDD
				, T0.PO_QTY				AS QTY
				, 5                     AS SEQ
			FROM SSP_ANL_ESS_PO T0 WITH (NOLOCK)
			INNER JOIN (
				SELECT PR_NO, PR_ITEM_ID, PROJECT_CODE 
				FROM SSP_ANL_ESS_PR  A WITH(NOLOCK)
				LEFT OUTER JOIN  SSP_ANL_ESS_REQ B WITH(NOLOCK)
					ON A.DM_REQ_NO = B.DM_REQ_NO 
					AND A.PR_ITEM_ID =  B.ITEM_ID
				WHERE 1 = 1
				AND A.YYYYMMDD		>= @v_from_yyyymmdd	
				AND A.YYYYMMDD		<= @v_to_yyyymmdd	
				AND (( @p_item_id IS NULL OR @p_item_id ='') OR A.PR_ITEM_ID IN (SELECT token FROM dbo.String_Split(@p_item_id , ',')))
			) T1
			ON T0.PR_NO			= T1.PR_NO
			AND T0.PO_ITEM_ID	= T1.PR_ITEM_ID
			WHERE 1 = 1
			AND T0.YYYYMMDD		>= @v_from_yyyymmdd	
			AND T0.YYYYMMDD		<= @v_to_yyyymmdd	
			AND T0.PO_QTY		> 0
			AND (( @p_item_id IS NULL OR @p_item_id ='') OR T0.PO_ITEM_ID IN (SELECT token FROM dbo.String_Split(@p_item_id , ',')))



			UNION ALL
			--//PO//===================================================================
			--////////////////////////////////////////////////////////////////////////////////--
			--//2-3. PO_RTF : PO에 대한 납품 예정일											//--
			--//	SSP_ANL_ESS_PO / MEASURE = 'PO_RTF'											//--
			--////////////////////////////////////////////////////////////////////////////////--
			SELECT '82'						AS DIVISION_ID --T0.DIVISION_ID
					, C.ITEM_ID				AS ITEM_ID
					, C.FROM_SITE			AS FROM_SITE	--T0.FROM_SITE
					, C.PROJECT_CODE		AS PROJECT_CODE
					, 'SHIP_CONFIRM'			AS MEASURE
					, C.YYYYMMDD			AS YYYYMMDD
					, C.QTY				AS QTY
					, 6                     AS SEQ
				FROM SSP_ANL_SHIP_CONFIRM C WITH(NOLOCK) 
			    JOIN SCM_MST_SITE AS S WITH(NOLOCK)
					ON C.FROM_SITE		= S.SCM_SITE_ID
				   AND C.DIVISION_ID	= S.DIVISION_ID
				   AND S.SITE_TYPE		= 'PLANT'
			  --	LEFT OUTER JOIN SCP_MST_BOD_N_V  B WITH(NOLOCK) 
					--ON B.DIVISION_ID	= C.DIVISION_ID
				 --  AND B.BOD_ID			= C.BOD_ID
				JOIN SCM_MST_ITEM_SN AS T WITH(NOLOCK)
					ON C.ITEM_ID		= T.ITEM_ID
				   AND C.DIVISION_ID	= T.DIVISION_ID
				   AND S.COMPANY_ID		= T.COMPANY_ID
				   AND T.ITEM_TYPE		IN ('Q','R')  --상품
				 WHERE 1 = 1
				   AND C.YYYYMMDD	   >= @v_from_yyyymmdd  
				   AND C.YYYYMMDD	    < @v_to_yyyymmdd 			  
				   AND C.CHANGE_TYPE	= 'C' -- 확정
				   AND C.DIVISION_ID	= @p_division_id
				   AND (( @p_from_site IS NULL OR @p_from_site ='') OR C.FROM_SITE IN (SELECT token FROM dbo.String_Split(@p_from_site , ',')))
				   AND ((@p_project_code IS NULL OR @p_project_code ='')	OR C.PROJECT_CODE IN (SELECT token FROM dbo.String_Split(@p_project_code, ',')))
				   AND (( @p_item_id IS NULL OR @p_item_id ='') OR C.ITEM_ID IN (SELECT token FROM dbo.String_Split(@p_item_id , ',')))
			
			UNION ALL
			--확정구간 이후 Ship Req 수량 합
			SELECT '82'						AS DIVISION_ID 
					, T1.ITEM_ID			AS ITEM_ID
					, T1.FROM_SITE			AS FROM_SITE	
					, T1.PROJECT_CODE		AS PROJECT_CODE
					, 'SHIP_CONFIRM'		AS MEASURE
					, T1.YYYYMMDD			AS YYYYMMDD
					, T1.QTY				AS QTY
					, 6                     AS SEQ
			FROM
			(

				SELECT
					R.DIVISION_ID				AS DIVISION_ID
					, R.ITEM_ID					AS ITEM_ID
--					,CASE WHEN R.[PLANT_SITE_ID] IS NULL OR R.[PLANT_SITE_ID] = '' THEN 'KR012031-P' ELSE R.[PLANT_SITE_ID] END AS FROM_SITE  --PeopleWorks-KR-2 AS FROM_SITE
					,CASE WHEN R.[PLANT_SITE_ID] IS NULL OR R.[PLANT_SITE_ID] = '' THEN @v_KR012031 ELSE R.[PLANT_SITE_ID] END AS FROM_SITE  --PeopleWorks-KR-2 AS FROM_SITE
					, R.PROJECT_CODE			AS PROJECT_CODE
					, 'SHIP_PLAN'				AS MEASURE
					, R.YYYYMMDD				AS YYYYMMDD
					, R.QTY						AS QTY
					, 6							AS SEQ
					, CASE WHEN ISNULL(FS.SHIP_FROZEN,0) > 0 THEN CONVERT(CHAR(8), DATEADD(DD, ISNULL(FS.SHIP_FROZEN,0), CONVERT(VARCHAR, @v_current_yyyymmdd, 121)), 112) ELSE @v_current_yyyymmdd END AS FROZEN_YYYYMMDD -- SHIP FROZEN구간 다음일자
				FROM DM_PLN_MKT_FCST R WITH(NOLOCK)
			    INNER JOIN DM_MST_ITEM_SINGLE_V M WITH(NOLOCK)
				 ON R.DIVISION_ID = M.DIVISION_ID
				   AND R.ITEM_ID       = M.ITEM_ID
				INNER JOIN SCM_MST_SITE FS WITH(NOLOCK)	
					ON  FS.DIVISION_ID		= @p_division_id
--					AND CASE WHEN R.[PLANT_SITE_ID] IS NULL OR R.[PLANT_SITE_ID] = '' THEN 'KR012031-P' ELSE R.[PLANT_SITE_ID] END  = FS.SCM_SITE_ID
					AND CASE WHEN R.[PLANT_SITE_ID] IS NULL OR R.[PLANT_SITE_ID] = '' THEN @v_KR012031 ELSE R.[PLANT_SITE_ID] END  = FS.SCM_SITE_ID
					AND FS.COMPANY_ID		= @p_company_id
					AND FS.SITE_TYPE		= 'PLANT'  
					AND FS.VALID_YN			= 'Y'
				WHERE R.MEASURE     = 'BNPIn'
				AND R.DIVISION_ID  = @p_division_id 
				AND R.yyyymmdd		>= @v_from_yyyymmdd	
				AND R.yyyymmdd		<= @v_to_yyyymmdd	
				--AND R.QTY > 0
				AND (( @p_from_site IS NULL OR @p_from_site ='') OR R.PLANT_SITE_ID IN (SELECT token FROM dbo.String_Split(@p_from_site , ',')))
				AND ((@p_project_code IS NULL OR @p_project_code ='')	OR R.PROJECT_CODE IN (SELECT token FROM dbo.String_Split(@p_project_code, ',')))
				AND (( @p_item_id IS NULL OR @p_item_id ='') OR R.ITEM_ID IN (SELECT token FROM dbo.String_Split(@p_item_id , ',')))


				--SELECT 
				--	T0.DIVISION_ID				AS DIVISION_ID
				--	, T0.ITEM_ID				AS ITEM_ID
				--	, T0.PLANT_SITE_ID			AS FROM_SITE
				--	, T0.PROJECT_CODE			AS PROJECT_CODE
				--	, 'SHIP_PLAN'				AS MEASURE
				--	, T0.YYYYMMDD				AS YYYYMMDD
				--	, T0.PLAN_QTY				AS QTY
				--	, 6							AS SEQ
				--	, CASE WHEN ISNULL(FS.SHIP_FROZEN,0) > 0 THEN CONVERT(CHAR(8), DATEADD(DD, ISNULL(FS.SHIP_FROZEN,0), CONVERT(VARCHAR, @v_current_yyyymmdd, 121)), 112) ELSE @v_current_yyyymmdd END AS FROZEN_YYYYMMDD -- SHIP FROZEN구간 다음일자
				--FROM SSP_ANL_ESS_REQ T0 WITH(NOLOCK)
				--INNER JOIN SCM_MST_SITE FS WITH(NOLOCK)	
				--	ON  FS.DIVISION_ID		= @p_division_id
				--	AND T0.PLANT_SITE_ID    = FS.SCM_SITE_ID
				--	AND FS.COMPANY_ID		= @p_company_id
				--	AND FS.SITE_TYPE		= 'PLANT'  
				--	AND FS.VALID_YN			= 'Y'
				--WHERE  1=1
				--AND T0.division_id = @p_division_id -- 변수
				--AND FS.COMPANY_ID = @p_company_id
				--AND T0.yyyymmdd >= @v_from_yyyymmdd	
				--AND T0.yyyymmdd <= @v_to_yyyymmdd	
				----AND T0.PLAN_QTY > 0
				--AND (( @p_from_site IS NULL OR @p_from_site ='') OR T0.plant_site_id IN (SELECT token FROM dbo.String_Split(@p_from_site , ',')))
				--AND ((@p_project_code IS NULL OR @p_project_code ='')	OR T0.PROJECT_CODE IN (SELECT token FROM dbo.String_Split(@p_project_code, ',')))
				--AND (( @p_item_id IS NULL OR @p_item_id ='') OR T0.item_id IN (SELECT token FROM dbo.String_Split(@p_item_id , ',')))
			) T1
			WHERE 1 = 1
			--AND YYYYMMDD >= frozen_yyyymmdd 


		) T0
		INNER JOIN SCM_MST_SITE T1	WITH(NOLOCK)	
				ON T1.DIVISION_ID = @p_division_id
				AND T1.COMPANY_ID = @p_company_id
				AND T0.FROM_SITE = T1.SCM_SITE_ID
				AND T1.SITE_TYPE  = 'PLANT'  
				AND T1.VALID_YN   = 'Y'
		WHERE 1 = 1
		GROUP BY T0.DIVISION_ID, T0.FROM_SITE, T0.ITEM_ID, T0.YYYYMMDD, T0.PROJECT_CODE, T0.MEASURE, T0.SEQ, T1.SHIP_FROZEN
		ORDER BY T0.DIVISION_ID, T0.FROM_SITE, T0.ITEM_ID, T0.YYYYMMDD, T0.PROJECT_CODE, T0.SEQ
		;
		

		--SELECT * FROM  #Tmp_RowData;
	
		--////////////////////////////////////////////////////////////////////////////////--
		--//3. 해당 ITEM별 MEASURE 및 날짜 생성											//--
		--////////////////////////////////////////////////////////////////////////////////--
		INSERT INTO #Tmp_Result_Table
		(
			DIVISION_ID,		FROM_SITE,		ITEM_ID,		PROJECT_CODE,		MEASURE,		SEQ,		CONFIRM_DAY,		YYYYMMDD,		QTY
		)

		SELECT
			T0.DIVISION_ID
			, T0.FROM_SITE
			, T0.ITEM_ID
			, T0.PROJECT_CODE
			, T0.MEASURE
			, T0.SEQ
			, T0.CONFIRM_DAY
			, T0.YYYYMMDD
			, ISNULL(T1.QTY, 0)		 AS QTY
		FROM 
		(
			SELECT
				tt0.DIVISION_ID
				, tt0.FROM_SITE
				, tt0.ITEM_ID
				, tt0.CONFIRM_DAY
				, tt0.PROJECT_CODE
				, tt1.COLUMN_NAME AS MEASURE
				, tt1.SORT_ORDER_NO AS SEQ
				, tt0.YYYYMMDD
			FROM #Tmp_RowData tt0
			--LEFT OUTER JOIN 
			--(
			--	SELECT
			--		BASIS_YYYYMMDD AS YYYYMMDD,
			--		ISO_WEEK
			--	FROM scm_sys_calendar_m WITH(NOLOCK)
			--	WHERE BASIS_YYYYMMDD >= @v_from_yyyymmdd	AND BASIS_YYYYMMDD <= @v_to_yyyymmdd
			--) tt2
			--	ON  tt2.YYYYMMDD >= @v_from_yyyymmdd	AND tt2.YYYYMMDD <= @v_to_yyyymmdd

			INNER JOIN SCM_MST_SHEET_MEASURE TT1
				ON TT1.PROGRAM_ID = @P_PROGRAM_ID
				AND TT1.SHEET_NAME = @P_SHEET_NAME
				AND TT1.COLUMN_NAME IN ('PO','BNP_IN','SHIP_CONFIRM','PO_RTF','PR')
			GROUP BY tt0.DIVISION_ID, tt0.FROM_SITE, tt0.ITEM_ID, tt0.PROJECT_CODE, tt1.COLUMN_NAME, tt1.COLUMN_LABEL_NAME, tt1.SORT_ORDER_NO, tt0.YYYYMMDD,tt0.CONFIRM_DAY
		) T0
		LEFT OUTER JOIN #Tmp_RowData T1 WITH(NOLOCK)
			ON T0.DIVISION_ID = T1.DIVISION_ID		AND T0.FROM_SITE = T1.FROM_SITE
			AND T0.ITEM_ID = T1.ITEM_ID				AND T0.MEASURE = T1.MEASURE
			AND T0.PROJECT_CODE = T1.PROJECT_CODE
			AND T0.YYYYMMDD = T1.YYYYMMDD
		--LEFT OUTER JOIN #Tmp_BOHData T2
		--	ON T0.DIVISION_ID = T2.DIVISION_ID
		--	AND T0.ITEM_ID = T2.ITEM_ID		
		WHERE 1 = 1

		AND ((@p_project_code IS NULL OR @p_project_code ='')	OR T0.PROJECT_CODE IN (SELECT token FROM dbo.String_Split(@p_project_code, ',')))
		AND (( @p_item_id IS NULL OR @p_item_id ='') OR T0.ITEM_ID IN (SELECT token FROM dbo.String_Split(@p_item_id , ',')))

		ORDER BY T0.DIVISION_ID, T0.FROM_SITE, T0.ITEM_ID, T0.YYYYMMDD, T0.SEQ
		;

		--//END 해당 ITEM별 MEASURE 및 날짜 생성///////////////////////////////////////////////////////////////////////////////////////////////////////////////////--

		--////////////////////////////////////////////////////////////////////////////////--
		--//4. PUR_BALANCE, SHIP_BALANCE 생성											//--
		--////////////////////////////////////////////////////////////////////////////////--
		--//4-1. PUR_BALANCE DATA INSERT
		WITH WH_STOCK AS
		(
			SELECT
				DIVISION_ID
				--, FROM_SITE
				, ITEM_ID
				, CONVERT(CHAR(8), DATEADD(DD, +1, CONVERT(VARCHAR, YYYYMMDD, 121)), 112) AS YYYYMMDD
				, M_BOH_QTY AS M_BOH_QTY
				, ALLO_BOH_QTY AS ALLO_BOH_QTY
			FROM #Tmp_BOHData WITH(NOLOCK)
			WHERE 1 = 1
			AND BOH_TYPE = 'BOH'
			AND YYYYMMDD = @v_boh_yyyymmdd
		),
		Deduplication AS
		(
			SELECT
				DIVISION_ID
				, FROM_SITE
				, ITEM_ID
				, tt2.YYYYMMDD
				, CONFIRM_DAY
				, PROJECT_CODE
			FROM #Tmp_Result_Table WITH(NOLOCK)
			LEFT OUTER JOIN 
			(
				SELECT
					BASIS_YYYYMMDD AS YYYYMMDD,
					ISO_WEEK
				FROM scm_sys_calendar_m WITH(NOLOCK)
				WHERE BASIS_YYYYMMDD >= @v_from_yyyymmdd	AND BASIS_YYYYMMDD <= @v_to_yyyymmdd
			) tt2
				ON  tt2.YYYYMMDD >= @v_from_yyyymmdd	AND tt2.YYYYMMDD <= @v_to_yyyymmdd

			GROUP BY DIVISION_ID, FROM_SITE, ITEM_ID, tt2.YYYYMMDD, CONFIRM_DAY, PROJECT_CODE
		)
		INSERT INTO #Tmp_Result_Table
		(
			DIVISION_ID,		FROM_SITE,		ITEM_ID,		PROJECT_CODE,		MEASURE,		SEQ,		CONFIRM_DAY,		YYYYMMDD,		QTY
		)
		SELECT 
			T0.DIVISION_ID
			, T0.FROM_SITE
			, T0.ITEM_ID 
			, T0.PROJECT_CODE
			, 'PUR_BALANCE' AS MEASURE
			, 4 AS SEQ
			, T0.CONFIRM_DAY
			, T0.YYYYMMDD
			, (
				SELECT
					ISNULL( 
						SUM( 
							CASE	
								WHEN tt0.MEASURE = 'BNP_IN' THEN -1 * ISNULL(tt0.QTY, 0)
								WHEN tt0.MEASURE = 'PO'		THEN ISNULL(tt0.QTY, 0)
							ELSE 0.0
							END), 
						0)
				FROM #Tmp_Result_Table tt0
				WHERE 1 = 1
				AND tt0.DIVISION_ID = T0.DIVISION_ID
				AND tt0.FROM_SITE = T0.FROM_SITE
				AND tt0.ITEM_ID = T0.ITEM_ID
				AND tt0.PROJECT_CODE = T0.PROJECT_CODE
				AND tt0.MEASURE IN ('BNP_IN', 'PO')
				AND tt0.YYYYMMDD <= T0.YYYYMMDD
				) 
				+ ISNULL(T2.ALLO_BOH_QTY, 0)
				 AS QTY
		FROM Deduplication T0 WITH(NOLOCK)
		LEFT OUTER JOIN #Tmp_Allo_Qty_Table T2 WITH(NOLOCK)
			ON T0.DIVISION_ID   = T2.DIVISION_ID	
			--AND T0.FROM_SITE	= T2.PLANT_SITE_ID
			AND T0.ITEM_ID		= T2.ITEM_ID		
			AND T0.PROJECT_CODE	= T2.PROJECT_CODE
		--LEFT OUTER JOIN WH_STOCK T1 WITH(NOLOCK)
		--	ON T0.DIVISION_ID = T1.DIVISION_ID	
		--	AND T0.ITEM_ID = T1.ITEM_ID		
		WHERE 1 = 1
		
		UNION ALL

		SELECT 
			T0.DIVISION_ID
			, T0.FROM_SITE
			, T0.ITEM_ID 
			, T0.PROJECT_CODE
			, 'SHIP_BALANCE' AS MEASURE
			, 7 AS SEQ
			, T0.CONFIRM_DAY
			, T0.YYYYMMDD
			, (
				SELECT
					ISNULL( 
						SUM( 
							CASE	
								WHEN tt0.MEASURE = 'SHIP_CONFIRM' THEN -1 * ISNULL(tt0.QTY, 0)
								WHEN tt0.MEASURE = 'PO_RTF'		  THEN ISNULL(tt0.QTY, 0)
							ELSE 0.0
							END), 
						0)
				FROM #Tmp_Result_Table tt0
				WHERE 1 = 1
				AND tt0.DIVISION_ID = T0.DIVISION_ID
				AND tt0.FROM_SITE = T0.FROM_SITE
				AND tt0.ITEM_ID		= T0.ITEM_ID
				AND tt0.PROJECT_CODE = T0.PROJECT_CODE
				AND tt0.MEASURE IN ('SHIP_CONFIRM', 'PO_RTF')
				AND tt0.YYYYMMDD <= T0.YYYYMMDD
				) 
				+ ISNULL(T2.ALLO_BOH_QTY, 0)
				 AS QTY
		FROM Deduplication T0 WITH(NOLOCK)
		LEFT OUTER JOIN #Tmp_Allo_Qty_Table T2 WITH(NOLOCK)
			ON T0.DIVISION_ID   = T2.DIVISION_ID	
			--AND T0.FROM_SITE	= T2.PLANT_SITE_ID
			AND T0.ITEM_ID		= T2.ITEM_ID		
			AND T0.PROJECT_CODE	= T2.PROJECT_CODE
		--LEFT OUTER JOIN WH_STOCK T1 WITH(NOLOCK)
		--	ON T0.DIVISION_ID = T1.DIVISION_ID	
		--	AND T0.ITEM_ID = T1.ITEM_ID			
		WHERE 1 = 1
		--ORDER BY T0.DIVISION_ID, T0.FROM_SITE, T0.ITEM_ID, T0.YYYYMMDD 
		;

		--SELECT * fROM #Tmp_RowData -- WHERE MEASURE = 'BNP_IN' AND ITEM_ID  = 'ECW01399AA';

		--SELECT * fROM #Tmp_BOHData
		--SELECT * FROM #Tmp_Result_Table WHERE MEASURE = 'BNP_IN' AND ITEM_ID  = 'EAWH00205AA';
		--SELECT * FROM #Tmp_Result_Table WHERE MEASURE = 'PO' AND ITEM_ID  = 'ECW01394AA' AND YYYYMMDD ='20210420' ORDER BY PROJECT_CODE, YYYYMMDD ASC
		--SELECT * FROM #Tmp_Result_Table WHERE MEASURE = 'PUR_BALANCE' AND ITEM_ID  = 'EBA01784AA 'AND YYYYMMDD ='20210420'  ORDER BY PROJECT_CODE, YYYYMMDD ASC
		--//END PUR_BALANCE, SHIP_BALANCE 생성 생성////////////////////////////////////////--

		--////////////////////////////////////////////////////////////////////////////////--
		--//5. PIVOT				 													//--
		--////////////////////////////////////////////////////////////////////////////////--

		SELECT T0.DIVISION_ID
--			, 'KR012031-P'  AS FROM_SITE --T0.PLANT_SITE_ID AS FROM_SITE
			, @v_KR012031  AS FROM_SITE --T0.PLANT_SITE_ID AS FROM_SITE
			, T0.ITEM_ID
			, T0.PROJECT_CODE
			, T0.MEASURE
		    , T0.CONFIRM_DAY
			, T0.YYYYMMDD
			, T0.yyyymm
			, T0.iso_week
			, isnull(T0.QTY, 0)		 AS QTY
			, T0.LOT_YN
			--, T0.SEQ
		INTO #Tmp_Result_PIVOT_Table
		FROM
		(
			SELECT DISTINCT
				T0.DIVISION_ID
				, T0.FROM_SITE
				, T0.ITEM_ID
				, T0.PROJECT_CODE
				, T0.MEASURE
				, T0.CONFIRM_DAY
				, sum(convert(int, T0.QTY)) AS QTY
				--, CASE WHEN T2.LOT_SIZE IS NULL THEN 'N' ELSE 'Y' END AS LOT_YN
				, NULL AS LOT_YN
				, 'D_' + T0.YYYYMMDD AS YYYYMMDD
				, T1.basis_yyyymm AS yyyymm
				, RIGHT(T1.basis_yyyymm,4) + T1.iso_week AS iso_week
			FROM #Tmp_Result_Table T0
			INNER JOIN scm_sys_calendar_m T1 WITH(NOLOCK)
				ON T0.yyyymmdd = T1.basis_yyyymmdd
	
			WHERE 1= 1
			AND T0.DIVISION_ID = @p_division_id
			AND T0.yyyymmdd >= @v_from_yyyymmdd
			AND T0.yyyymmdd <= @v_to_yyyymmdd
			AND ((@p_from_site IS NULL OR @p_from_site ='') OR T0.FROM_SITE IN (SELECT token FROM dbo.String_Split(@p_from_site    ,',')))
			AND ((@p_item_id IS NULL OR @p_item_id ='')	OR T0.ITEM_ID IN (SELECT token FROM dbo.String_Split(@p_item_id    ,',')))
			GROUP BY T0.DIVISION_ID, T0.FROM_SITE, T0.ITEM_ID, T0.PROJECT_CODE, T0.MEASURE, T0.CONFIRM_DAY, T0.YYYYMMDD, T1.basis_yyyymm, T1.iso_week

		) T0
	

	    --SELECT * fROM #Tmp_Result_PIVOT_Table WHERE MEASURE = 'BNP_IN';
		/*PIVOIT처리*******************************************************************************/
		BEGIN
		
			-- PIVOIT 대상 날짜문자열 생성
			SET @mQry_sum = '';
			
			SELECT  @mQry_sum = @mQry_sum+','+ CASE WHEN CHARINDEX('M_', yyyymmdd) =1 THEN  'SUM(CASE WHEN T0.yyyymm   = RIGHT('''+yyyymmdd+''',6) THEN CONVERT(numeric(20, 10), ISNULL(T0.QTY, 0))  ELSE 0 END ) AS ' + yyyymmdd
													WHEN CHARINDEX('W_', yyyymmdd) =1 THEN  'SUM(CASE WHEN T0.iso_week = RIGHT('''+yyyymmdd+''',6) THEN CONVERT(numeric(20, 10),ISNULL(T0.QTY, 0))  ELSE 0 END ) AS ' + yyyymmdd
													WHEN CHARINDEX('D_', yyyymmdd) =1 THEN  'SUM(CASE WHEN T0.yyyymmdd = '''+yyyymmdd+''' THEN CONVERT(numeric(20, 10),ISNULL(T0.QTY, 0)) ELSE 0 END ) AS ' + yyyymmdd
												END +''+CHAR(10)


			FROM ( 
					SELECT 'W_'+a.basis_yyyymm + a.iso_week AS yyyymmdd        
						, a.basis_start_date + CONVERT(CHAR(2), 21) AS sort_order_no
						FROM [dbo].[scm_sys_calendar_m] a 
					WHERE a.basis_yyyymmdd  BETWEEN @v_from_yyyymmdd AND @v_to_yyyymmdd
					GROUP BY a.basis_yyyymm, a.iso_week, a.basis_start_date

					UNION ALL

					SELECT 'M_'+a.basis_yyyymm  AS yyyymmdd
							,MIN(a.basis_start_date) + CONVERT(CHAR(2), '01') AS sort_order_no
						FROM [dbo].[scm_sys_calendar_m] a 
						WHERE a.basis_yyyymmdd  BETWEEN @v_from_yyyymmdd AND @v_to_yyyymmdd
					GROUP BY a.basis_yyyymm, a.month_name		

					UNION ALL

					SELECT 'D_'+a.basis_yyyymmdd   AS yyyymmdd      
							, a.basis_yyyymmdd + CONVERT(CHAR(2), 31) AS sort_order_no
						FROM [dbo].[scm_sys_calendar_m] a 
						WHERE a.basis_yyyymmdd  BETWEEN @v_from_yyyymmdd AND @v_to_yyyymmdd
					GROUP BY a.basis_yyyymmdd	
								
					) AS A
			ORDER BY sort_order_no  ;
		END;
		--//END PIVOT///////////////////////////////////////////////////////////////////////////////////////////////////////////////////--

		--////////////////////////////////////////////////////////////////////////////////--
		--//6. RESULT				 													//--
		--////////////////////////////////////////////////////////////////////////////////--
		SET @mEXEC = '';
		SET @mEXEC = @mEXEC + '	SELECT																														' + CHAR(10);
		SET @mEXEC = @mEXEC + '		T0.DIVISION_ID																											' + CHAR(10);
		SET @mEXEC = @mEXEC + '		, T0.FROM_SITE																											' + CHAR(10);
		--SET @mEXEC = @mEXEC+'       , ISNULL(DBO.FN_GET_SCM_SITE_DESCRIPTION(T0.DIVISION_ID, T0.FROM_SITE ),''-'') AS FROM_SITE_DESCRIPTION					' + CHAR(10);
		SET @mEXEC = @mEXEC + '		, T0.ITEM_ID																											' + CHAR(10);
		SET @mEXEC = @mEXEC + '		, MAX(M.ITEM_UOM) AS UOM																							' + CHAR(10);
		SET @mEXEC = @mEXEC + '		, T0.PROJECT_CODE																										' + CHAR(10);
		SET @mEXEC = @mEXEC+'		, ISNULL(T2.M_BOH_QTY, 0)		AS M_BOH_QTY																			' + CHAR(10);
		--SET @mEXEC = @mEXEC+'		, ISNULL(T2.DAILY_BOH_QTY, 0)	AS DAILY_BOH_QTY																		' + CHAR(10);
		SET @mEXEC = @mEXEC+'		, ISNULL(T2.M_BOH_QTY, 0) - ISNULL(T2.ALLO_BOH_QTY, 0)	AS DAILY_BOH_QTY												' + CHAR(10);
		SET @mEXEC = @mEXEC+'		, ISNULL(T5.ALLO_BOH_QTY, 0)	AS ALLO_BOH_QTY																			' + CHAR(10);
		--SET @mEXEC = @mEXEC+'		, (SELECT SUM(AA.INV_ALLO_QTY) FROM SSP_ANL_ESS_REQ AA WHERE AA.DIVISION_ID = T0.DIVISION_ID AND AA.ITEM_ID = T0.ITEM_ID AND AA.PROJECT_CODE = T0.PROJECT_CODE  GROUP BY )	AS ALLO_BOH_QTY																			' + CHAR(10);
		SET @mEXEC = @mEXEC + '		, T0.MEASURE																											' + CHAR(10);
		SET @mEXEC = @mEXEC + '		, T1.COLUMN_LABEL_NAME		AS COLUM_LABEL_NAME																			' + CHAR(10);
		SET @mEXEC = @mEXEC+'       , T1.SMALL_CLASS_LABEL_NAME AS MEASURE_NAME																				' + CHAR(10);
		SET @mEXEC = @mEXEC + '		, T1.SORT_ORDER_NO																										' + CHAR(10);
		SET @mEXEC = @mEXEC + '		, CONVERT(CHAR(8), DATEADD(DD, CASE WHEN (T0.CONFIRM_DAY - 1) > 0 THEN (T0.CONFIRM_DAY - 1) ELSE 0 END, CONVERT(VARCHAR, '''+ @v_current_yyyymmdd + ''', 121)), 112) AS CONFIRM_DAY							' + CHAR(10);
		--SET @mEXEC = @mEXEC + '		, CONVERT(CHAR(8), DATEADD(DD, CASE WHEN (T3.SHIP_FROZEN - 1) > 0 THEN (T3.SHIP_FROZEN - 1) ELSE 0 END, CONVERT(VARCHAR, '''+ @v_current_yyyymmdd + ''', 121)), 112) AS CONFIRM_DAY							' + CHAR(10);
		SET @mEXEC = @mEXEC+'       , T1.ATTRIBUTE3 AS BACK_COLOR																							' + CHAR(10);
		SET @mEXEC = @mEXEC+'       , T0.LOT_YN																												' + CHAR(10);
		SET @mEXEC = @mEXEC + '		' + @mQry_sum + '																										' + CHAR(10);
		SET @mEXEC = @mEXEC + '	FROM #Tmp_Result_PIVOT_Table T0																								' + CHAR(10);
		SET @mEXEC = @mEXEC + '	INNER JOIN SCM_MST_ITEM_SN M WITH(NOLOCK)																					' + CHAR(10);
		SET @mEXEC = @mEXEC + '			ON T0.ITEM_ID    = M.ITEM_ID																						' + CHAR(10);
		SET @mEXEC = @mEXEC + '			AND T0.DIVISION_ID = M.DIVISION_ID																					' + CHAR(10);
--		SET @mEXEC = @mEXEC + '			AND M.COMPANY_ID  = ''C100''																						' + CHAR(10);
		SET @mEXEC = @mEXEC + '			AND M.COMPANY_ID  = ''' + @v_C100 + '''																				' + CHAR(10);
		SET @mEXEC = @mEXEC + '			AND M.ITEM_TYPE	  IN (''Q'',''R'')																					' + CHAR(10)

		SET @mEXEC = @mEXEC+'	INNER JOIN SCM_MST_SHEET_MEASURE T1	WITH(NOLOCK)																			' + CHAR(10);
		SET @mEXEC = @mEXEC+'		ON T0.MEASURE = T1.COLUMN_NAME																							' + CHAR(10);
		SET @mEXEC = @mEXEC+'		AND T1.PROGRAM_ID = ''' + @p_program_id + '''																			' + CHAR(10);
		SET @mEXEC = @mEXEC+'		AND T1.SHEET_NAME = ''' + @p_sheet_name + '''																			' + CHAR(10);
		SET @mEXEC = @mEXEC+'	LEFT OUTER JOIN	#Tmp_BOHData T2																								' + CHAR(10);
		SET @mEXEC = @mEXEC+'		ON T0.DIVISION_ID = T2.DIVISION_ID																						' + CHAR(10);
		SET @mEXEC = @mEXEC+'		AND T0.ITEM_ID = T2.ITEM_ID																								' + CHAR(10);
		SET @mEXEC = @mEXEC+'	LEFT OUTER JOIN	#Tmp_Allo_Qty_Table T5																						' + CHAR(10);
		SET @mEXEC = @mEXEC+'		ON T0.DIVISION_ID   = T5.DIVISION_ID																					' + CHAR(10);
		SET @mEXEC = @mEXEC+'		AND T0.ITEM_ID		= T5.ITEM_ID																						' + CHAR(10);	
		SET @mEXEC = @mEXEC+'		AND T0.PROJECT_CODE = T5.PROJECT_CODE																					' + CHAR(10);
		--SET @mEXEC = @mEXEC+'	INNER JOIN scm_mst_site T3 WITH(NOLOCK)																									' + CHAR(10);	
		--SET @mEXEC = @mEXEC+'		ON T0.DIVISION_ID = ''' + @p_division_id + '''																			' + CHAR(10);	
		--SET @mEXEC = @mEXEC+'		AND T3.COMPANY_ID = ''' + @p_company_id + '''																			' + CHAR(10);	
		--SET @mEXEC = @mEXEC+'		AND T0.FROM_SITE = T3.SCM_SITE_ID																						' + CHAR(10);	
		--SET @mEXEC = @mEXEC+'		AND T3.site_type  = ''PLANT''																							' + CHAR(10);	
		--SET @mEXEC = @mEXEC+'		AND T3.valid_yn   = ''Y''																								' + CHAR(10);	
		SET @mEXEC = @mEXEC+'	LEFT OUTER JOIN SCM_MST_TITLESET_USER T4 WITH(NOLOCK)																		' + char(10);
		SET @mEXEC = @mEXEC+'			ON T4.PROGRAM_ID = T1.PROGRAM_ID                                                                                    ' + char(10);
		SET @mEXEC = @mEXEC+'			AND T4.SHEET_NAME = T1.SHEET_NAME                                                                                   ' + char(10);
		SET @mEXEC = @mEXEC+'			AND T4.COLUMN_NAME = T1.COLUMN_NAME                                                                                 ' + char(10);
		SET @mEXEC = @mEXEC+'			AND T4.USER_ID = ''' + @p_user_id + '''                                                                             ' + char(10);
		SET @mEXEC = @mEXEC+'	WHERE 1 = 1																													' + CHAR(10);
		SET @mEXEC = @mEXEC+'		AND T1.PROGRAM_ID = ''' + @p_program_id + '''                                                                           ' + char(10);
		SET @mEXEC = @mEXEC+'		AND T1.SHEET_NAME = ''' + @p_sheet_name + '''                                                                           ' + char(10);
		SET @mEXEC = @mEXEC+'		AND T1.VALID_YN = ''Y''                                                                                                 ' + char(10);
		SET @mEXEC = @mEXEC+' 		AND ('+convert(varchar,@v_cnt_usr_measure)+' = 0																		' + char(10);                                                                                                                 
		SET @mEXEC = @mEXEC+' 						OR EXISTS (SELECT 1																						' + char(10);                                                                                                                 
		SET @mEXEC = @mEXEC+' 									 FROM #TblDynamicTitlest_SSP0027															' + char(10);                                                                                                                 
		SET @mEXEC = @mEXEC+' 									 WHERE COLUMN_NAME = T1.COLUMN_NAME)														' + char(10);                                                                                                                 
		SET @mEXEC = @mEXEC+' 				                  )																								' + char(10); 	
		SET @mEXEC = @mEXEC+' 			  AND ( ( '+convert(varchar,@v_cnt_usr_measure)+' = 0 AND T1.DEFAULT_FLAG=''Y'' )                                   ' + char(10);                                                                                                                 
		SET @mEXEC = @mEXEC+' 						OR  ('+convert(varchar,@v_cnt_usr_measure)+' != 0 )														' + char(10);                                                                                                                 
		SET @mEXEC = @mEXEC+' 				                  )																								' + char(10); 	
		--SET @mEXEC = @mEXEC+'	AND T1.COLUMN_NAME = T0.MEASURE																								' + char(10);
		if(@p_Item_id != '' AND @p_Item_id IS NOT NULL ) SET @mEXEC = @mEXEC + '	AND T0.ITEM_ID = ''' + @p_Item_id + '''									' + CHAR(10);
--		SET @mEXEC = @mEXEC + '	GROUP BY T0.DIVISION_ID, T0.FROM_SITE, T0.ITEM_ID, T0.PROJECT_CODE, T0.MEASURE, T1.COLUMN_LABEL_NAME, T1.SMALL_CLASS_LABEL_NAME, T1.SORT_ORDER_NO, T2.BOH_TYPE, T2.M_BOH_QTY, T5.ALLO_BOH_QTY, T2.ALLO_BOH_QTY, T3.SHIP_FROZEN, T1.ATTRIBUTE3, T0.LOT_YN 																' + CHAR(10);
SET @mEXEC = @mEXEC + '	GROUP BY T0.DIVISION_ID, T0.FROM_SITE, T0.ITEM_ID, T0.PROJECT_CODE, T0.MEASURE, T1.COLUMN_LABEL_NAME, T1.SMALL_CLASS_LABEL_NAME, T1.SORT_ORDER_NO, T2.BOH_TYPE, T2.M_BOH_QTY, T5.ALLO_BOH_QTY, T2.ALLO_BOH_QTY, T0.CONFIRM_DAY, T1.ATTRIBUTE3, T0.LOT_YN 																' + CHAR(10);
		SET @mEXEC = @mEXEC + '	ORDER BY T0.DIVISION_ID, T0.FROM_SITE, T0.ITEM_ID, T0.PROJECT_CODE, T1.SORT_ORDER_NO										' + CHAR(10);
	
		--SELECT @mEXEC;
		EXEC(@mEXEC);
		--//END RESULT///////////////////////////////////////////////////////////////////////////////////////////////////////////////////--
	END
	ELSE
	BEGIN
		/*PIVOIT처리*******************************************************************************/
		BEGIN
			-- PIVOIT 대상 날짜문자열 생성
			SET @mQry_sum = '';
			
			SELECT  @mQry_sum = @mQry_sum+','+ CASE WHEN CHARINDEX('M_', yyyymmdd) =1 THEN  'SUM(CASE WHEN T0.yyyymm   = RIGHT('''+yyyymmdd+''',6) THEN T0.QTY  END ) AS ' + yyyymmdd
													WHEN CHARINDEX('W_', yyyymmdd) =1 THEN  'SUM(CASE WHEN T0.iso_week = RIGHT('''+yyyymmdd+''',6) THEN T0.QTY  END ) AS ' + yyyymmdd
													WHEN CHARINDEX('D_', yyyymmdd) =1 THEN  'SUM(CASE WHEN T0.yyyymmdd = '''+yyyymmdd+''' THEN T0.QTY END ) AS ' + yyyymmdd
												END +''+CHAR(10)
			FROM ( 
					SELECT 'W_'+a.basis_yyyymm + a.iso_week AS yyyymmdd        
						, a.basis_start_date + CONVERT(CHAR(2), 21) AS sort_order_no
						FROM [dbo].[scm_sys_calendar_m] a 
					WHERE a.basis_yyyymmdd  BETWEEN @v_from_yyyymmdd AND @v_to_yyyymmdd
					GROUP BY a.basis_yyyymm, a.iso_week, a.basis_start_date

					UNION ALL

					SELECT 'M_'+a.basis_yyyymm  AS yyyymmdd
							,MIN(a.basis_start_date) + CONVERT(CHAR(2), '01') AS sort_order_no
						FROM [dbo].[scm_sys_calendar_m] a 
						WHERE a.basis_yyyymmdd  BETWEEN @v_from_yyyymmdd AND @v_to_yyyymmdd
					GROUP BY a.basis_yyyymm, a.month_name		

					UNION ALL

					SELECT 'D_'+a.basis_yyyymmdd   AS yyyymmdd      
							, a.basis_yyyymmdd + CONVERT(CHAR(2), 31) AS sort_order_no
						FROM [dbo].[scm_sys_calendar_m] a 
						WHERE a.basis_yyyymmdd  BETWEEN @v_from_yyyymmdd AND @v_to_yyyymmdd
					GROUP BY a.basis_yyyymmdd	
								
					) AS A
			ORDER BY sort_order_no  ;
		END;
		--//END PIVOT///////////////////////////////////////////////////////////////////////////////////////////////////////////////////--

		

		SELECT
			T0.DIVISION_ID
--			, 'KR012031-P'  AS FROM_SITE --T0.PLANT_SITE_ID AS FROM_SITE
			, @v_KR012031  AS FROM_SITE --T0.PLANT_SITE_ID AS FROM_SITE
			, T0.ITEM_ID
			, T0.PROJECT_CODE
			, T0.MEASURE
			, T0.YYYYMMDD
			, T0.yyyymm
			, T0.iso_week
			, isnull(T0.QTY, 0) AS QTY
			, T0.LOT_YN
			--, T0.SEQ
		INTO #Tmp_Result_PIVOT_Table_Old
		FROM
		(
			SELECT
				T0.DIVISION_ID
				, T0.PLANT_SITE_ID
				, T0.ITEM_ID
				, T0.PROJECT_CODE
				, T0.MEASURE
				, sum(convert(int, T0.QTY)) AS QTY
				--, CASE WHEN T2.LOT_SIZE IS NULL THEN 'N' ELSE 'Y' END AS LOT_YN
				, NULL AS LOT_YN
				, 'D_' + T0.YYYYMMDD AS YYYYMMDD
				, T1.basis_yyyymm AS yyyymm
				, RIGHT(T1.basis_yyyymm,4) + T1.iso_week AS iso_week
			FROM SSP_ANL_ESS_PLAN T0
			INNER JOIN scm_sys_calendar_m T1 
				ON T0.yyyymmdd = T1.basis_yyyymmdd
	
			WHERE 1= 1
			AND T0.DIVISION_ID = @p_division_id
			AND T0.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
			AND T0.yyyymmdd >= @v_from_yyyymmdd
			AND T0.yyyymmdd <= @v_to_yyyymmdd
			AND ((@p_item_id IS NULL OR @p_item_id ='')	OR T0.ITEM_ID IN (SELECT token FROM dbo.String_Split(@p_item_id    ,',')))
			AND ((@p_project_code IS NULL OR @p_project_code ='')	OR T0.PROJECT_CODE IN (SELECT token FROM dbo.String_Split(@p_project_code    ,',')))
			GROUP BY T0.DIVISION_ID, T0.PLANT_SITE_ID, T0.ITEM_ID, T0.PROJECT_CODE, T0.MEASURE, T0.YYYYMMDD, T1.basis_yyyymm, T1.iso_week

		) T0

		SET @mEXEC = '';
		SET @mEXEC = @mEXEC + '	SELECT																														' + CHAR(10);
		SET @mEXEC = @mEXEC + '		T0.DIVISION_ID																											' + CHAR(10);
		SET @mEXEC = @mEXEC + '		, T0.FROM_SITE																											' + CHAR(10);
		--SET @mEXEC = @mEXEC+'       , ISNULL(DBO.FN_GET_SCM_SITE_DESCRIPTION(T0.DIVISION_ID, T0.FROM_SITE ),''-'') AS FROM_SITE_DESCRIPTION					' + CHAR(10);
		SET @mEXEC = @mEXEC + '		, T0.ITEM_ID																											' + CHAR(10);
		SET @mEXEC = @mEXEC + '		, MAX(M.ITEM_UOM) AS UOM																							' + CHAR(10);
		SET @mEXEC = @mEXEC + '		, T0.PROJECT_CODE																										' + CHAR(10);
		SET @mEXEC = @mEXEC+'		, ISNULL(T2.M_BOH_QTY, 0)		AS M_BOH_QTY																			' + CHAR(10);
		--SET @mEXEC = @mEXEC+'		, ISNULL(T2.DAILY_BOH_QTY, 0)	AS DAILY_BOH_QTY																		' + CHAR(10);
		SET @mEXEC = @mEXEC+'		, ISNULL(T2.M_BOH_QTY, 0) - ISNULL(T2.ALLO_BOH_QTY, 0)	AS DAILY_BOH_QTY																		' + CHAR(10);
		SET @mEXEC = @mEXEC+'		, ISNULL(T5.ALLO_BOH_QTY, 0)	AS ALLO_BOH_QTY																			' + CHAR(10);
		SET @mEXEC = @mEXEC + '		, T0.MEASURE																											' + CHAR(10);
		SET @mEXEC = @mEXEC + '		, T1.COLUMN_LABEL_NAME		AS COLUM_LABEL_NAME																		' + CHAR(10);
		SET @mEXEC = @mEXEC+'       , T1.SMALL_CLASS_LABEL_NAME AS MEASURE_NAME																				' + CHAR(10);
		SET @mEXEC = @mEXEC + '		, T1.SORT_ORDER_NO																										' + CHAR(10);
		SET @mEXEC = @mEXEC + '		, CONVERT(CHAR(8), DATEADD(DD, 14, CONVERT(VARCHAR, '''+ @v_plan_cutoff_yyyymmdd + ''', 121)), 112) AS CONFIRM_DAY							' + CHAR(10);
		SET @mEXEC = @mEXEC+'       , T1.ATTRIBUTE3 AS BACK_COLOR																									' + CHAR(10);
		SET @mEXEC = @mEXEC+'       , T0.LOT_YN ' + CHAR(10);
		SET @mEXEC = @mEXEC + '		' + @mQry_sum + '																									' + CHAR(10);
		SET @mEXEC = @mEXEC + '	FROM #Tmp_Result_PIVOT_Table_Old T0																							' + CHAR(10);
		SET @mEXEC = @mEXEC + '	INNER JOIN SCM_MST_ITEM_SN M WITH(NOLOCK)																					' + CHAR(10);
		SET @mEXEC = @mEXEC + '			ON T0.DIVISION_ID = M.DIVISION_ID																					' + CHAR(10);
		SET @mEXEC = @mEXEC + '			AND T0.ITEM_ID    = M.ITEM_ID																						' + CHAR(10);
--		SET @mEXEC = @mEXEC + '			AND M.COMPANY_ID  = ''C100''																						' + CHAR(10);
		SET @mEXEC = @mEXEC + '			AND M.COMPANY_ID  = ''' + @v_C100 + '''																				' + CHAR(10);
		SET @mEXEC = @mEXEC + '			AND M.ITEM_TYPE	  IN (''Q'',''R'')																					' + CHAR(10)
		SET @mEXEC = @mEXEC+'	INNER JOIN SCM_MST_SHEET_MEASURE T1																						' + CHAR(10);
		SET @mEXEC = @mEXEC+'		ON T0.MEASURE = T1.COLUMN_NAME																						' + CHAR(10);
		SET @mEXEC = @mEXEC+'		AND T1.PROGRAM_ID = ''' + @p_program_id + '''																		' + CHAR(10);
		SET @mEXEC = @mEXEC+'		AND T1.SHEET_NAME = ''' + @p_sheet_name + '''																		' + CHAR(10);
		SET @mEXEC = @mEXEC+'	LEFT OUTER JOIN	#Tmp_BOHData T2																							' + CHAR(10);
		SET @mEXEC = @mEXEC+'			ON T0.DIVISION_ID = T2.DIVISION_ID																				' + CHAR(10);
		SET @mEXEC = @mEXEC+'			AND T0.ITEM_ID = T2.ITEM_ID																						' + CHAR(10);
		SET @mEXEC = @mEXEC+'	LEFT OUTER JOIN	#Tmp_Allo_Qty_Table_Old T5																						' + CHAR(10);
		SET @mEXEC = @mEXEC+'		ON T0.DIVISION_ID   = T5.DIVISION_ID																					' + CHAR(10);
		SET @mEXEC = @mEXEC+'		AND T0.ITEM_ID		= T5.ITEM_ID																						' + CHAR(10);	
		SET @mEXEC = @mEXEC+'		AND T0.PROJECT_CODE = T5.PROJECT_CODE																					' + CHAR(10);
		--SET @mEXEC = @mEXEC+'	INNER JOIN SCM_MST_SITE T3																								' + CHAR(10);	
		--SET @mEXEC = @mEXEC+'		ON T0.DIVISION_ID = ''' + @p_division_id + '''																					' + CHAR(10);	
		--SET @mEXEC = @mEXEC+'		AND T3.COMPANY_ID = ''' + @p_company_id + '''																					' + CHAR(10);	
		--SET @mEXEC = @mEXEC+'		AND T0.FROM_SITE = T3.scm_site_id																					' + CHAR(10);	
		--SET @mEXEC = @mEXEC+'		AND T3.site_type  = ''PLANT''																						' + CHAR(10);	
		--SET @mEXEC = @mEXEC+'		AND T3.valid_yn   = ''Y''																							' + CHAR(10);	
		SET @mEXEC = @mEXEC+'		LEFT OUTER JOIN SCM_MST_TITLESET_USER T4 WITH(NOLOCK)                                                                                                           ' + char(10) ;
		SET @mEXEC = @mEXEC+'			ON T4.PROGRAM_ID = T1.PROGRAM_ID                                                                                                                            ' + char(10) ;
		SET @mEXEC = @mEXEC+'			AND T4.SHEET_NAME = T1.SHEET_NAME                                                                                                                           ' + char(10) ;
		SET @mEXEC = @mEXEC+'			AND T4.COLUMN_NAME = T1.COLUMN_NAME                                                                                                                         ' + char(10) ;
		SET @mEXEC = @mEXEC+'			AND T4.USER_ID = ''' + @p_user_id + '''                                                                                                                     ' + char(10) ;
		SET @mEXEC = @mEXEC+'	WHERE 1 = 1' + CHAR(10);
		SET @mEXEC = @mEXEC+'		AND T1.PROGRAM_ID = ''' + @p_program_id + '''                                                                                                                                   ' + char(10) ;
		SET @mEXEC = @mEXEC+'		AND T1.SHEET_NAME = ''' + @p_sheet_name + '''                                                                                                                       ' + char(10) ;
		SET @mEXEC = @mEXEC+'		AND T1.VALID_YN = ''Y''                                                                                                                                           ' + char(10) ;
		SET @mEXEC = @mEXEC+' 		AND ('+convert(varchar,@v_cnt_usr_measure)+' = 0                                      ' + char(10) ;                                                                                                                 
		SET @mEXEC = @mEXEC+' 						OR EXISTS (SELECT 1                                    ' + char(10) ;                                                                                                                 
		SET @mEXEC = @mEXEC+' 									 FROM #TblDynamicTitlest_SSP0027			   ' + char(10) ;                                                                                                                 
		SET @mEXEC = @mEXEC+' 									 WHERE COLUMN_NAME = T1.COLUMN_NAME)         ' + char(10) ;                                                                                                                 
		SET @mEXEC = @mEXEC+' 				                  )                                            ' + char(10) ; 	
		SET @mEXEC = @mEXEC+' 			  AND ( ( '+convert(varchar,@v_cnt_usr_measure)+' = 0 AND T1.DEFAULT_FLAG=''Y'' )                                      ' + char(10) ;                                                                                                                 
		SET @mEXEC = @mEXEC+' 						OR  ('+convert(varchar,@v_cnt_usr_measure)+' != 0 )       ' + char(10) ;                                                                                                                 
		SET @mEXEC = @mEXEC+' 				                  )                                            ' + char(10) ; 	
		SET @mEXEC = @mEXEC+'	AND T1.COLUMN_NAME = T0.MEASURE																																	  ' + char(10) ;
		if(@p_Item_id != '' AND @p_Item_id IS NOT NULL ) SET @mEXEC = @mEXEC + '	AND T0.ITEM_ID = ''' + @p_Item_id + '''																						' + CHAR(10);
		SET @mEXEC = @mEXEC + '	GROUP BY T0.DIVISION_ID, T0.FROM_SITE, T0.ITEM_ID, T0.PROJECT_CODE, T0.MEASURE, T1.COLUMN_LABEL_NAME, T1.SMALL_CLASS_LABEL_NAME, T1.SORT_ORDER_NO, T2.BOH_TYPE, T2.M_BOH_QTY, T5.ALLO_BOH_QTY, T2.ALLO_BOH_QTY, T1.ATTRIBUTE3, T0.LOT_YN 																' + CHAR(10);
		SET @mEXEC = @mEXEC + '	ORDER BY T0.DIVISION_ID, T0.FROM_SITE, T0.ITEM_ID, T0.PROJECT_CODE, T1.SORT_ORDER_NO										' + CHAR(10);

		--select @mEXEC;
		EXEC(@mEXEC);

	END;


	IF OBJECT_ID('tempdb..#TblDynamicTitlest_SSP0027') IS NOT NULL	
		DROP TABLE #TblDynamicTitlest_SSP0027;

	-- SHIPMENT BOH
	IF OBJECT_ID('tempdb..#Tmp_BOHData_STORAGE') IS NOT NULL	
		DROP TABLE #Tmp_BOHData_STORAGE;

	IF OBJECT_ID('tempdb..#Tmp_BOHData') IS NOT NULL	
		DROP TABLE #Tmp_BOHData;

	-- SHIPMENT ROW DATA
	IF OBJECT_ID('tempdb..#Tmp_RowData') IS NOT NULL	
		DROP TABLE #Tmp_RowData;

	IF OBJECT_ID('tempdb..#Tmp_Allo_Qty_Table') IS NOT NULL	
		DROP TABLE #Tmp_Allo_Qty_Table;

	IF OBJECT_ID('tempdb..#Tmp_Allo_Qty_Table_Old') IS NOT NULL	
		DROP TABLE #Tmp_Allo_Qty_Table_Old;

	IF OBJECT_ID('tempdb..#Tmp_Result_PIVOT_Table') IS NOT NULL	
		DROP TABLE #Tmp_Result_PIVOT_Table;

	IF OBJECT_ID('tempdb..#Tmp_Result_PIVOT_Table_Old') IS NOT NULL	
		DROP TABLE #Tmp_Result_PIVOT_Table_Old;

	IF OBJECT_ID('tempdb..#Tmp_Result_Table') IS NOT NULL	
		DROP TABLE #Tmp_Result_Table;

END
