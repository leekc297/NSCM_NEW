
/*
 * Program ID   : SCP0101_GET_INVENTORY_TREND
 * Description  : LONG TERM STOCK + Ending Inventory
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2023/09/21   vadabi3			PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 - 최초 생성
 * 2023/10/16   vadabi3			PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 - Plant Name 개선
 * 2025.11.10   park.choyi		[E20250310-000014] 업무 용어 변경에 따른 시스템내 표기 수정 요청 ('부실' -> '장기')
 ----------------------------------------------------------------------------------------------------
	
SCP0101_GET_INVENTORY_TREND
  @p_yyyymm			= '202308'		
, @p_division_id	= ''				
, @p_plant_id		= ''				
, @p_item_id		= ''	           
, @debug_mode		= 'T'	

 */

CREATE PROCEDURE [dbo].[SCP0101_GET_INVENTORY_TREND]
	@p_yyyymm				NVARCHAR(6),
	@p_division_id			NVARCHAR(100),
	@p_plant_id				NVARCHAR(500),
	@p_item_id	            NVARCHAR(30),
	@debug_mode				NVARCHAR(1) = 'T'

AS
BEGIN
    	
	


	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON; 
	
	------------------------------------------------------------------------
	-- LOG 용 변수 설정
	------------------------------------------------------------------------
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0101_GET_INVENTORY_TREND';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
	------------------------------------------------------------------------  

	------------------------------------------------------------------------
	-- LOG 시작
	------------------------------------------------------------------------
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########'; 
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	------------------------------------------------------------------------  
	
	DECLARE @v_yyyymm_month1 NVARCHAR(6);
	DECLARE @v_yyyymm_month2 NVARCHAR(6);
	DECLARE @v_yyyymm_month3 NVARCHAR(6);
	DECLARE @v_yyyymm_month4 NVARCHAR(6);
	DECLARE @v_yyyymm_month5 NVARCHAR(6);

	SELECT @v_yyyymm_month1 = FORMAT(DATEADD(MONTH, -5, Concat(@p_yyyymm,'01')),'yyyyMM')
	SELECT @v_yyyymm_month2 = FORMAT(DATEADD(MONTH, -4, Concat(@p_yyyymm,'01')),'yyyyMM')
	SELECT @v_yyyymm_month3 = FORMAT(DATEADD(MONTH, -3, Concat(@p_yyyymm,'01')),'yyyyMM')
	SELECT @v_yyyymm_month4 = FORMAT(DATEADD(MONTH, -2, Concat(@p_yyyymm,'01')),'yyyyMM')
	SELECT @v_yyyymm_month5 = FORMAT(DATEADD(MONTH, -1, Concat(@p_yyyymm,'01')),'yyyyMM')

	DECLARE @START_TIME DATETIME = GETDATE()
	DECLARE @END_TIME DATETIME	 = GETDATE()
	--PRINT '시작 시간 : ' + CONVERT(VARCHAR(100), @START_TIME, 121) 
	--SELECT @END_TIME = GETDATE()
	--PRINT 'IDX_TMP_MONTH_END_STOCK_MONTH BEFORE : ' + CONVERT(VARCHAR(100), @END_TIME-@START_TIME, 114)


	IF OBJECT_ID('tempdb..#TMP_LONGTERM_ITEM') IS NOT NULL	
		DROP TABLE #TMP_LONGTERM_ITEM;

	IF OBJECT_ID('tempdb..#TMP_TOTAL') IS NOT NULL	
		DROP TABLE #TMP_TOTAL;

	IF OBJECT_ID('tempdb..#TMP_SCP_ANL_LONG_TERM_STOCK') IS NOT NULL	
		DROP TABLE #TMP_SCP_ANL_LONG_TERM_STOCK;

	IF OBJECT_ID('tempdb..#TMP_SCP_ANL_LONG_TERM_STOCK_SUM') IS NOT NULL	
		DROP TABLE #TMP_SCP_ANL_LONG_TERM_STOCK_SUM;

	IF OBJECT_ID('tempdb..#TMP_SCP_ANL_LONG_TERM_STOC_MONTH_SUM') IS NOT NULL	
		DROP TABLE #TMP_SCP_ANL_LONG_TERM_STOC_MONTH_SUM;

	IF OBJECT_ID('tempdb..#TMP_LONG_TERM_STOCK_FINISH') IS NOT NULL	
		DROP TABLE #TMP_LONG_TERM_STOCK_FINISH;

	IF OBJECT_ID('tempdb..#TMP_MONTH_END_STOCK') IS NOT NULL	
		DROP TABLE #TMP_MONTH_END_STOCK;
		
	IF OBJECT_ID('tempdb..#TMP_MONTH_END_STOCK_FINISH') IS NOT NULL	
		DROP TABLE #TMP_MONTH_END_STOCK_FINISH;

	IF OBJECT_ID('tempdb..#W_CELL_CF') IS NOT NULL
		DROP TABLE #W_CELL_CF;

	IF OBJECT_ID('tempdb..#W_CELL_CF_BOM') IS NOT NULL
		DROP TABLE #W_CELL_CF_BOM;

	IF OBJECT_ID('tempdb..#SCP_MST_FINAL_ITEM') IS NOT NULL
		DROP TABLE #SCP_MST_FINAL_ITEM;

	IF OBJECT_ID('tempdb..#TMP_ITEM_CLASS') IS NOT NULL
		DROP TABLE #TMP_ITEM_CLASS;

	IF OBJECT_ID('tempdb..#SCP_MST_FINAL_ITEM') IS NOT NULL
		DROP TABLE #SCP_MST_FINAL_ITEM;

	IF OBJECT_ID('tempdb..#TMP_SCP_ANL_LONG_TERM') IS NOT NULL
		DROP TABLE #TMP_SCP_ANL_LONG_TERM;

	IF OBJECT_ID('tempdb..#TMP_SCP_ANL_LONG_TERM_STOCK_FOCUS') IS NOT NULL	
		DROP TABLE #TMP_SCP_ANL_LONG_TERM_STOCK_FOCUS;

	IF OBJECT_ID('tempdb..#TMP_SCP_ANL_LONG_TERM_STOCK_MONTH') IS NOT NULL	
		DROP TABLE #TMP_SCP_ANL_LONG_TERM_STOCK_MONTH;

	IF OBJECT_ID('tempdb..#TMP_LONG_TERM_STOCK_FINISH') IS NOT NULL	
		DROP TABLE #TMP_LONG_TERM_STOCK_FINISH;
		
		
		
		
	--#####################################################################################################################################
	-- 조회 대상 FOCUS : #TMP_SCP_ANL_LONG_TERM_STOCK_FOCUS
	--#####################################################################################################################################
   		SELECT 
			  @p_yyyymm		AS YYYYMM
			, MAX(YYYYMM)	AS YYYYMM_ORG
			, DIVISION_ID
			, PLANT_ID
			, ITEM_ID
			, LONG_TERM_TYPE
			, LONG_TERM_TYPE_CODE   --[E20250310-000014] 확장성을 고려하여 LONG_TERM_TYPE_CODE 활용
			, MAX(ITEM_NAME)				    AS ITEM_NAME
			, MAX(ITEM_UOM)						AS ITEM_UOM
			, MAX(ITEM_TYPE)					AS ITEM_TYPE
			, MAX(PROCESS_GROUP)				AS PROCESS_GROUP
			, MAX(PROCESS_DETAIL)				AS PROCESS_DETAIL
			, MAX(GPLM_CELL_MODEL)				AS GPLM_CELL_MODEL
			, MAX(MDM_NICK_NAME)				AS MDM_NICK_NAME
			, MAX(GPLM_CELL_CONVERSION_FACTOR)	AS GPLM_CELL_CONVERSION_FACTOR
			, MAX(VALUATION_CLASS)				AS VALUATION_CLASS
			--------------------------------------------------------------------
			, SUM(LONG_TERM_STOCK_QTY)			AS LONG_TERM_STOCK_QTY
			, SUM(LONG_TERM_STOCK_AMOUNT)		AS LONG_TERM_STOCK_AMOUNT
			, MAX(AMOUNT_KRW)					AS AMOUNT_KRW
			, MAX(CURRENCY)						AS CURRENCY
			, SUM(AMOUNT)						AS AMOUNT
			, MAX(UNIT_PRICE)					AS UNIT_PRICE
			, MAX(UNIT_PRICE_ORG)				AS UNIT_PRICE_ORG
			, MAX(UNIT_PRICE_KRW)				AS UNIT_PRICE_KRW_ORG
			, MAX(EX_TO_BAMT)					AS EX_TO_BAMT
			, MAX(WAERS)						AS WAERS
			, MAX(LPEIN)						AS LPEIN
		INTO #TMP_SCP_ANL_LONG_TERM_STOCK_FOCUS
		FROM SCP_ANL_LONG_TERM_STOCK A WITH (NOLOCK)
		WHERE 1=1
		AND A.YYYYMM = @p_yyyymm
		AND ( ISNULL(@p_division_id, '')			= '' OR A.DIVISION_ID			IN (SELECT token FROM dbo.String_Split(@p_division_id,',')) )
		AND ( ISNULL(@p_plant_id, '')				= '' OR A.PLANT_ID				IN (SELECT token FROM dbo.String_Split(@p_plant_id,',')) )
		AND ( ISNULL(@p_item_id, '')	            = '' OR A.ITEM_ID				IN (SELECT token FROM dbo.String_Split(@p_item_id,',')) )
		GROUP BY DIVISION_ID
				,PLANT_ID
				,ITEM_ID
				,LONG_TERM_TYPE
				,LONG_TERM_TYPE_CODE   --[E20250310-000014] 확장성을 고려하여 LONG_TERM_TYPE_CODE 활용


	--#####################################################################################################################################
	-- 조회 대상 MONTH : #TMP_SCP_ANL_LONG_TERM_STOCK_MONTH
	--#####################################################################################################################################

		SELECT 
			  @p_yyyymm							AS YYYYMM
			, MAX(YYYYMM)   					AS YYYYMM_ORG
			, DIVISION_ID
			, PLANT_ID
			, ITEM_ID
			, LONG_TERM_TYPE
			, LONG_TERM_TYPE_CODE   --[E20250310-000014] 확장성을 고려하여 LONG_TERM_TYPE_CODE 활용
			, MAX(ITEM_NAME)				    AS ITEM_NAME
			, MAX(ITEM_UOM)						AS ITEM_UOM
			, MAX(ITEM_TYPE)					AS ITEM_TYPE
			, MAX(PROCESS_GROUP)				AS PROCESS_GROUP
			, MAX(PROCESS_DETAIL)				AS PROCESS_DETAIL
			, MAX(GPLM_CELL_MODEL)				AS GPLM_CELL_MODEL
			, MAX(MDM_NICK_NAME)				AS MDM_NICK_NAME
			, MAX(GPLM_CELL_CONVERSION_FACTOR)	AS GPLM_CELL_CONVERSION_FACTOR
			, MAX(VALUATION_CLASS)				AS VALUATION_CLASS
			--------------------------------------------------------------------
			, NULL	AS LONG_TERM_STOCK_QTY
			, NULL	AS LONG_TERM_STOCK_AMOUNT
			, NULL	AS AMOUNT_KRW
			, ' '	AS CURRENCY
			, NULL	AS AMOUNT
			, NULL	AS UNIT_PRICE
			, NULL	AS UNIT_PRICE_ORG
			, NULL	AS UNIT_PRICE_KRW_ORG
			, NULL	AS EX_TO_BAMT
			, ' '	AS WAERS
			, NULL	AS LPEIN
		INTO #TMP_SCP_ANL_LONG_TERM_STOCK_MONTH
		FROM SCP_ANL_LONG_TERM_STOCK A WITH (NOLOCK)
		WHERE 1=1
		AND A.YYYYMM BETWEEN  @v_yyyymm_month1 AND @v_yyyymm_month5
		AND ( ISNULL(@p_division_id, '')			= '' OR A.DIVISION_ID			IN (SELECT token FROM dbo.String_Split(@p_division_id,',')) )
		AND ( ISNULL(@p_plant_id, '')				= '' OR A.PLANT_ID				IN (SELECT token FROM dbo.String_Split(@p_plant_id,',')) )
		AND ( ISNULL(@p_item_id, '')	            = '' OR A.ITEM_ID				IN (SELECT token FROM dbo.String_Split(@p_item_id,',')) )
		GROUP BY DIVISION_ID
				,PLANT_ID
				,ITEM_ID
				,LONG_TERM_TYPE
				,LONG_TERM_TYPE_CODE   --[E20250310-000014] 확장성을 고려하여 LONG_TERM_TYPE_CODE 활용

	--#####################################################################################################################################
	-- 조회 대상 전채 : LONG TERM 6개월
	--#####################################################################################################################################
	   SELECT DATA.*
			, CASE WHEN LPEIN IS NOT NULL AND LPEIN <> 0 
					THEN IIF(CURRENCY = 'KRW', UNIT_PRICE_ORG / LPEIN, UNIT_PRICE_ORG * EX_TO_BAMT / LPEIN) 
					ELSE UNIT_PRICE_KRW_ORG
					END AS UNIT_PRICE_KRW
	INTO #TMP_SCP_ANL_LONG_TERM_STOCK
	FROM
	(
		SELECT * 
		FROM #TMP_SCP_ANL_LONG_TERM_STOCK_FOCUS

		UNION
		SELECT M.* 
		FROM #TMP_SCP_ANL_LONG_TERM_STOCK_MONTH M
		INNER JOIN
		(
			SELECT DIVISION_ID, PLANT_ID, ITEM_ID, LONG_TERM_TYPE, LONG_TERM_TYPE_CODE   --[E20250310-000014] 확장성을 고려하여 LONG_TERM_TYPE_CODE 활용
			FROM #TMP_SCP_ANL_LONG_TERM_STOCK_MONTH 
			EXCEPT
			SELECT DIVISION_ID, PLANT_ID, ITEM_ID, LONG_TERM_TYPE, LONG_TERM_TYPE_CODE   --[E20250310-000014] 확장성을 고려하여 LONG_TERM_TYPE_CODE 활용
			FROM #TMP_SCP_ANL_LONG_TERM_STOCK_FOCUS F
	    ) AS DATA
		ON  DATA.DIVISION_ID		= M.DIVISION_ID
		AND DATA.PLANT_ID			= M.PLANT_ID
		AND DATA.ITEM_ID			= M.ITEM_ID
		AND DATA.LONG_TERM_TYPE	    = M.LONG_TERM_TYPE 	
	) DATA

	--select * from #TMP_SCP_ANL_LONG_TERM_STOCK

	IF OBJECT_ID('tempdb..#TMP_SCP_ANL_LONG_TERM_STOCK_FOCUS') IS NOT NULL	
		DROP TABLE #TMP_SCP_ANL_LONG_TERM_STOCK_FOCUS;

	IF OBJECT_ID('tempdb..#TMP_SCP_ANL_LONG_TERM_STOCK_MONTH') IS NOT NULL	
		DROP TABLE #TMP_SCP_ANL_LONG_TERM_STOCK_MONTH;

		--#####################################################################################################################################
		-- 최근 5개월
		--#####################################################################################################################################
		SELECT 			 
		     YYYYMM
			,DIVISION_ID
			,PLANT_ID
			,ITEM_ID 			
			,LONG_TERM_TYPE		   --,MAX(LONG_TERM_TYPE				)  AS LONG_TERM_TYPE		--[E20250310-000014] LONG_TERM_TYPE 는 Group 대상이므로 MAX 제외
			,LONG_TERM_TYPE_CODE   --[E20250310-000014] 확장성을 고려하여 LONG_TERM_TYPE_CODE 활용
			,SUM(LONG_TERM_STOCK_QTY	    )  AS LONG_TERM_STOCK_QTY			
		INTO #TMP_SCP_ANL_LONG_TERM_STOC_MONTH_SUM
		FROM SCP_ANL_LONG_TERM_STOCK A WITH (NOLOCK) 
			WHERE 1=1
			AND A.YYYYMM BETWEEN  @v_yyyymm_month1 AND @p_yyyymm
			AND ( ISNULL(@p_division_id, '')			= '' OR A.DIVISION_ID			IN (SELECT token FROM dbo.String_Split(@p_division_id,',')) )
			AND ( ISNULL(@p_plant_id, '')				= '' OR A.PLANT_ID				IN (SELECT token FROM dbo.String_Split(@p_plant_id,',')) )
			AND ( ISNULL(@p_item_id, '')	            = '' OR A.ITEM_ID				IN (SELECT token FROM dbo.String_Split(@p_item_id,',')) )
		GROUP BY YYYYMM
				,DIVISION_ID
				,PLANT_ID
				,ITEM_ID
				,LONG_TERM_TYPE
				,LONG_TERM_TYPE_CODE   --[E20250310-000014] 확장성을 고려하여 LONG_TERM_TYPE_CODE 활용



		--#####################################################################################################################################
		--#W_CELL_CF
		--#W_CELL_CF_BOM
		--W_PLANT
		--W_EXTRA_SPEC
		--#SCP_MST_FINAL_ITEM
		--#TMP_ITEM_CLASS
		--#####################################################################################################################################
		   SELECT TARGET_CELL
				, ITEM_ID
				, CELL_CF
				, ROW_NUMBER() OVER (PARTITION BY ITEM_ID ORDER BY BOM_MODIFY_DATE DESC, ATTRIBUTE5 DESC) AS RankNo
			into #W_CELL_CF
			FROM SCP_MST_ITEM_CELL_CF WITH(NOLOCK)
			WHERE 1=1
			AND ( ISNULL(@p_item_id, '')	            = '' OR ITEM_ID				IN (SELECT token FROM dbo.String_Split(@p_item_id,',')) )

		--#####################################################################################################################################
			  SELECT CT.COMPANY_ID
					,MAX(CT.DIVISION_ID) AS DIVISION_ID
					,CT.SITE_ID 
					,CT.MODEL_ID
					,CT.PLANT_ID
					,CT.CHILD_ITEM_ID
					,max(ITEM_TYPE) as ITEM_TYPE
					,SUM(CT.ACCUMULATED_CHILD_QTY) AS ACCUMULATED_CHILD_QTY
					,MAX(CT.CHILD_QTY)   AS CHILD_QTY
					,round(convert(float,1)/SUM(CT.ACCUMULATED_CHILD_QTY),6) AS CELL_CF_BOM
				into #W_CELL_CF_BOM
				FROM  (
					SELECT CT.COMPANY_ID
						,CT.DIVISION_ID
						,CT.SITE_ID 
						,CT.MODEL_ID
						,CT.PLANT_ID
						,CT.CHILD_ITEM_ID
						,SI.ITEM_TYPE
						,CT.ACCUMULATED_CHILD_QTY
						,CT.CHILD_QTY
					FROM SCM_MODEL_COMP_TEMP_SN CT WITH(NOLOCK)
						,SCM_ITEM_M_SN			SI WITH(NOLOCK)
						,SCM_MST_ITEM_CLASS_SN	IC WITH(NOLOCK)
						,SCP_MST_ITEM_CELL_CF	CELL_CF WITH(NOLOCK)
					WHERE  CT.CHILD_COMPANY_ID  = SI.COMPANY_ID
					AND    CT.CHILD_DIVISION_ID = SI.DIVISION_ID
					AND    CT.CHILD_SITE_ID     = SI.SITE_ID
					AND    CT.CHILD_ITEM_ID     = SI.ITEM_ID
					AND    SI.ITEM_CLASS        = IC.CLASS_ID
					AND    IC.USE_FLAG          = 'Y'
					AND    ISNULL(SI.ITEM_TYPE,'H') IN ('P','Q','H')
					AND    CT.ALT_PRIORITY = 'Y'
					--AND    CT.child_ITEM_ID = 'ANPCA1747B'
					--and    CT.model_id = 'ACEN4065I-A1R001'
					--and    CT.plant_id = 'G451'
					AND CELL_CF.CELL_CF is NULL
					AND CELL_CF.item_id  =  CT.child_ITEM_ID
					AND CELL_CF.TARGET_CELL  =  CT.model_id

				)  CT
				GROUP BY CT.COMPANY_ID ,CT.SITE_ID ,CT.MODEL_ID ,CT.PLANT_ID ,CT.CHILD_ITEM_ID



		--#####################################################################################################################################
			select GROUP_CODE3, item_id 
			into #SCP_MST_FINAL_ITEM
			from SCP_MST_FINAL_ITEM WITH (NOLOCK)   
			where OPERATION_GROUP IN ('A', 'P') 
			and DIVISION_ID = '40'
		--#####################################################################################################################################
		   select DISTINCT 
				  ITEM_ID
				, ITEM_CLASS 
				, ROW_NUMBER() OVER (PARTITION BY A.ITEM_ID ORDER BY A.ITEM_CLASS DESC) AS RankNo
			INTO #TMP_ITEM_CLASS
			from SCM_MST_ITEM_SN A WITH (NOLOCK) 


		CREATE INDEX IDX_TMP_SCP_ANL_LONG_TERM_STOCK          ON #TMP_SCP_ANL_LONG_TERM_STOCK (YYYYMM,DIVISION_ID,PLANT_ID,ITEM_ID,LONG_TERM_TYPE,LONG_TERM_TYPE_CODE);    --[E20250310-000014] 확장성을 고려하여 LONG_TERM_TYPE_CODE 활용
		CREATE INDEX IDX_TMP_SCP_ANL_LONG_TERM_STOC_MONTH_SUM ON #TMP_SCP_ANL_LONG_TERM_STOC_MONTH_SUM (YYYYMM,DIVISION_ID,PLANT_ID,ITEM_ID,LONG_TERM_TYPE,LONG_TERM_TYPE_CODE);    --[E20250310-000014] 확장성을 고려하여 LONG_TERM_TYPE_CODE 활용
		--#####################################################################################################################################
		-- #TMP_LONG_TERM_STOCK_FINISH
		--#####################################################################################################################################
		;WITH W_PLANT AS
		(
				SELECT DISTINCT PLANT_ID , PLANT_NAME
				FROM SCM_PLANT_M_SN WITH(NOLOCK)
				UNION
				select SEGMENT1 as PLANT_ID, SEGMENT2 as PLANT_NAME
				from  [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL]
				where LOOKUP_TYPE   = 'INVENTORY_SITE'
					AND VALID_YN = 'Y'
		)
		,W_EXTRA_SPEC AS
		(
				  SELECT ITEM_ID
					  , MAX(SCP_EXTRA_SPEC) AS SCP_EXTRA_SPEC
					  , MAX(ITEM_CLASS) AS ITEM_CLASS
					FROM  SCM_MST_ITEM_SN WITH(NOLOCK)
					WHERE 1=1
					AND ( ISNULL(@p_division_id, '')			= '' OR DIVISION_ID			IN (SELECT token FROM dbo.String_Split(@p_division_id,',')) )
					AND ( ISNULL(@p_item_id, '')	            = '' OR ITEM_ID				IN (SELECT token FROM dbo.String_Split(@p_item_id,',')) )
				 GROUP BY ITEM_ID
		)
		,W_SI AS
		(
				SELECT  T.ITEM_ID
					, T.ITEM_TYPE
					, T.PROCESS_GROUP
					, T.PROCESS_DETAIL
					, T.LEVEL_1_NAME
					, T.LEVEL_2_NAME
					, T.LEVEL_3_NAME
					, T.LEVEL_4_NAME
				from
				(
					SELECT DISTINCT A.ITEM_ID
						, B.ITEM_TYPE
						, B.PROCESS_GROUP
						, B.PROCESS_DETAIL
						, B.LEVEL_1_NAME
						, B.LEVEL_2_NAME
						, B.LEVEL_3_NAME
						, B.LEVEL_4_NAME
						, ROW_NUMBER() OVER (PARTITION BY A.ITEM_ID ORDER BY A.ITEM_CLASS DESC) AS RankNo
					FROM #TMP_ITEM_CLASS A WITH(NOLOCK)
						, SCM_MST_ITEM_CLASS_M B WITH(NOLOCK)
					WHERE A.ITEM_CLASS = B.CLASS_ID
				) T
				where RankNo = 1
		
		)
		---------------------------------------------------------------------
		SELECT *
			, (SELECT LONG_TERM_STOCK_QTY
			     FROM #TMP_SCP_ANL_LONG_TERM_STOC_MONTH_SUM S 
				WHERE YYYYMM		= @v_yyyymm_month1 
				AND S.DIVISION_ID	= DATA.DIVISION_ID
				AND S.PLANT_ID		= DATA.PLANT_ID
				AND S.ITEM_ID		= DATA.ITEM_ID
				AND S.LONG_TERM_TYPE_CODE = DATA.LONG_TERM_TYPE_CODE --AND S.LONG_TERM_TYPE= DATA.INVENTORY_TYPE --[E20250310-000014] 확장성을 고려하여 LONG_TERM_TYPE_CODE 사용
				) AS QTY_MONTH1 
			, (SELECT LONG_TERM_STOCK_QTY
			     FROM #TMP_SCP_ANL_LONG_TERM_STOC_MONTH_SUM S 
				WHERE YYYYMM		= @v_yyyymm_month2
				AND S.DIVISION_ID	= DATA.DIVISION_ID
				AND S.PLANT_ID		= DATA.PLANT_ID
				AND S.ITEM_ID		= DATA.ITEM_ID
				AND S.LONG_TERM_TYPE_CODE = DATA.LONG_TERM_TYPE_CODE --AND S.LONG_TERM_TYPE= DATA.INVENTORY_TYPE --[E20250310-000014] 확장성을 고려하여 LONG_TERM_TYPE_CODE 사용
				) AS QTY_MONTH2  
			, (SELECT LONG_TERM_STOCK_QTY
			     FROM #TMP_SCP_ANL_LONG_TERM_STOC_MONTH_SUM S 
				WHERE YYYYMM		= @v_yyyymm_month3
				AND S.DIVISION_ID	= DATA.DIVISION_ID
				AND S.PLANT_ID		= DATA.PLANT_ID
				AND S.ITEM_ID		= DATA.ITEM_ID
				AND S.LONG_TERM_TYPE_CODE = DATA.LONG_TERM_TYPE_CODE --AND S.LONG_TERM_TYPE= DATA.INVENTORY_TYPE --[E20250310-000014] 확장성을 고려하여 LONG_TERM_TYPE_CODE 사용
				) AS QTY_MONTH3  
			, (SELECT LONG_TERM_STOCK_QTY
			     FROM #TMP_SCP_ANL_LONG_TERM_STOC_MONTH_SUM S 
				WHERE YYYYMM		= @v_yyyymm_month4
				AND S.DIVISION_ID	= DATA.DIVISION_ID
				AND S.PLANT_ID		= DATA.PLANT_ID
				AND S.ITEM_ID		= DATA.ITEM_ID
				AND S.LONG_TERM_TYPE_CODE = DATA.LONG_TERM_TYPE_CODE --AND S.LONG_TERM_TYPE= DATA.INVENTORY_TYPE --[E20250310-000014] 확장성을 고려하여 LONG_TERM_TYPE_CODE 사용
				) AS QTY_MONTH4
			, (SELECT LONG_TERM_STOCK_QTY
			     FROM #TMP_SCP_ANL_LONG_TERM_STOC_MONTH_SUM S 
				WHERE YYYYMM		= @v_yyyymm_month5
				AND S.DIVISION_ID	= DATA.DIVISION_ID
				AND S.PLANT_ID		= DATA.PLANT_ID
				AND S.ITEM_ID		= DATA.ITEM_ID
				AND S.LONG_TERM_TYPE_CODE = DATA.LONG_TERM_TYPE_CODE --AND S.LONG_TERM_TYPE= DATA.INVENTORY_TYPE --[E20250310-000014] 확장성을 고려하여 LONG_TERM_TYPE_CODE 사용
				) AS QTY_MONTH5
			, (SELECT LONG_TERM_STOCK_QTY
			     FROM #TMP_SCP_ANL_LONG_TERM_STOC_MONTH_SUM S 
				WHERE YYYYMM		= @p_yyyymm
				AND S.DIVISION_ID	= DATA.DIVISION_ID
				AND S.PLANT_ID		= DATA.PLANT_ID
				AND S.ITEM_ID		= DATA.ITEM_ID
				AND S.LONG_TERM_TYPE_CODE = DATA.LONG_TERM_TYPE_CODE --AND S.LONG_TERM_TYPE= DATA.INVENTORY_TYPE --[E20250310-000014] 확장성을 고려하여 LONG_TERM_TYPE_CODE 사용
				) AS QTY_MONTH_FOCUS
			, ( CASE 
				WHEN ITEM_TYPE_GR = 'TYPE_GR_A'		THEN (select MAX(GROUP_CODE3) from #SCP_MST_FINAL_ITEM where  item_id = left(DATA.ITEM_ID,len(DATA.ITEM_ID) - 2))
				WHEN ITEM_TYPE_GR = 'TYPE_GR_G'		THEN (select MAX(GROUP_CODE3) from #SCP_MST_FINAL_ITEM where  item_id = left(DATA.ITEM_ID,len(DATA.ITEM_ID) - 3))
				WHEN ITEM_TYPE_GR = 'TYPE_GR_PRODUCT'	THEN (select MAX(GROUP_CODE3) from #SCP_MST_FINAL_ITEM where  item_id = DATA.ITEM_ID) -- 20220428 Gro
				ELSE NULL 
				END
			) AS CELL_TYPE_GR -- 20221004 추가
 INTO #TMP_LONG_TERM_STOCK_FINISH
 FROM
 (

	SELECT    YYYYMM																				
			, DIVISION_ID																			
			, PLANT_DESCRIPTION																		
			, PLANT_ID																				
			, ITEM_ID																				
			, ITEM_NAME																				
			, ITEM_UOM																				
			--, STOCK_TYPE																			
			, LONG_TERM_TYPE																		
			, LONG_TERM_TYPE_CODE   --[E20250310-000014] 확장성을 고려하여 LONG_TERM_TYPE_CODE 활용
			, ITEM_TYPE																				
			, PROCESS_GROUP																			
			, PROCESS_DETAIL																		
			, GPLM_CELL_MODEL																		
			, MDM_NICK_NAME																			
			, SCP_EXTRA_SPEC																															
		    ----------------------------------------------------------------------------------------------------------------------	
			, CASE WHEN CELL_CF_TYPE = 'BOM' THEN CELL_CF_BOM
			       ELSE CELL_CF
			       END AS GPLM_CELL_CONVERSION_FACTOR		-- UI > 소수점 2자리까지 표시																			
		    ----------------------------------------------------------------------------------------------------------------------
			, LEVEL_1_NAME																			
			, LEVEL_2_NAME																			
			, LEVEL_3_NAME																			
			, LEVEL_4_NAME																			
			, VALUATION_CLASS		
			----------------------------------------------------------------	
			, REPORT_TYPE 
			, LONG_TERM_TYPE AS INVENTORY_TYPE
			--[E20250310-000014] 확장성을 고려하여 LONG_TERM_TYPE_CODE 사용 Start
			, LONG_TERM_TYPE_CODE AS INVENTORY_TYPE_CODE
			,  CASE WHEN REPORT_TYPE = 'LongTerm' AND LONG_TERM_TYPE_CODE = N'CODE_2'   THEN 'GRM00 ~ GRM02' 
					WHEN REPORT_TYPE = 'LongTerm' AND LONG_TERM_TYPE_CODE = N'CODE_5'	THEN 'GRM03 ~ GRM05' 
					WHEN REPORT_TYPE = 'LongTerm' AND LONG_TERM_TYPE_CODE = N'CODE_6'   THEN 'GRM06 ~' 
			        ELSE ''
				    END AS INVENTORY_TYPE_DESC
			,  CASE WHEN REPORT_TYPE = 'LongTerm' AND LONG_TERM_TYPE_CODE = N'CODE_2'   THEN '1'
					WHEN REPORT_TYPE = 'LongTerm' AND LONG_TERM_TYPE_CODE = N'CODE_5'	THEN '2'
					WHEN REPORT_TYPE = 'LongTerm' AND LONG_TERM_TYPE_CODE = N'CODE_6'   THEN '3'
			        ELSE ''
				    END AS INVENTORY_TYPE_SORT
			--, LONG_TERM_TYPE AS INVENTORY_TYPE
			--,  CASE WHEN REPORT_TYPE = 'LongTerm' AND LONG_TERM_TYPE = N'비대상'   THEN 'GRM00 ~ GRM02' 
			--		WHEN REPORT_TYPE = 'LongTerm' AND LONG_TERM_TYPE = N'부실 징후' THEN 'GRM03 ~ GRM05' 
			--		WHEN REPORT_TYPE = 'LongTerm' AND LONG_TERM_TYPE = N'부실'     THEN 'GRM06 ~' 
			--        ELSE ''
			--	    END AS INVENTORY_TYPE_DESC
			--,  CASE WHEN REPORT_TYPE = 'LongTerm' AND LONG_TERM_TYPE = N'비대상'   THEN '1'
			--		WHEN REPORT_TYPE = 'LongTerm' AND LONG_TERM_TYPE = N'부실 징후'THEN '2'
			--		WHEN REPORT_TYPE = 'LongTerm' AND LONG_TERM_TYPE = N'부실'     THEN '3'
			--        ELSE ''
			--	    END AS INVENTORY_TYPE_SORT
			--[E20250310-000014] 확장성을 고려하여 LONG_TERM_TYPE_CODE 사용 End
			--, LONG_TERM_STOCK_QTY AS QTY_MONTH_FOCUS
			,CELL_GROUP
			,PACK_GROUP

			, ( CASE 
				WHEN DIVISION_ID = '40'AND ITEM_TYPE IN (N'제품') AND Right(ITEM_ID,2) IN  ('-A','-B', '-C','-D','-E','-F','-G','-H','-I','-J','-K','-R')  AND CELL_CF IS NULL THEN 'TYPE_GR_A'
				WHEN DIVISION_ID = '40'AND ITEM_TYPE IN (N'제품') AND Right(ITEM_ID,3) IN  ('-GG','-GK')  AND CELL_CF IS NULL THEN 'TYPE_GR_G'
				WHEN DIVISION_ID = '40'AND ITEM_TYPE IN (N'제품') THEN 'TYPE_GR_PRODUCT'
				ELSE 'TYPE_GR'
				END
			) AS ITEM_TYPE_GR																																																					
			, LONG_TERM_STOCK_QTY																	
			, LONG_TERM_STOCK_AMOUNT	
			----------------------------------------------------------------	
			, CURRENCY
			, IIF(CURRENCY =N'KRW', 1, EX_TO_BAMT) AS EX_TO_BAMT
			, AMOUNT_KRW
			, CASE 
			    WHEN CURRENCY = N'KRW' THEN LONG_TERM_STOCK_AMOUNT
				WHEN AMOUNT IS NOT NULL THEN AMOUNT
				ELSE UNIT_PRICE * LONG_TERM_STOCK_QTY
				END AS AMOUNT
			, CASE 
			    WHEN CURRENCY = N'KRW' THEN ROUND(UNIT_PRICE,0)
				ELSE UNIT_PRICE
				END AS UNIT_PRICE
			, CASE 
			    WHEN CURRENCY = N'KRW' THEN ROUND(UNIT_PRICE_KRW,0)
				ELSE ROUND(UNIT_PRICE_KRW,2)
				END AS UNIT_PRICE_KRW

	FROM
	(

		SELECT 
		      ('‘' + SUBSTRING(@p_yyyymm, 3, 2) + '.' + RIGHT(@p_yyyymm, 2)) AS YYYYMM	
			, A.DIVISION_ID								--사업부(소형전지)
			, B.PLANT_NAME AS PLANT_DESCRIPTION			--플랜트지역(오창)
			, A.PLANT_ID								--플랜트(A010)
			, A.ITEM_ID									--자재
			, ITEM_NAME									--자재내역
			, A.ITEM_UOM								--단위																																	--장기진부화구분
			, A.LONG_TERM_TYPE
			, A.LONG_TERM_TYPE_CODE						--[E20250310-000014] 확장성을 고려하여 LONG_TERM_TYPE_CODE 활용
			, (
				CASE 
				WHEN A.VALUATION_CLASS IN ('3020','3030','3040') THEN N'저장품' 
				WHEN A.VALUATION_CLASS IN ('3100','3109') AND D.ITEM_TYPE = N'원부자재'  THEN N'상품' 
				ELSE D.ITEM_TYPE		
				END
			) AS ITEM_TYPE								--원반제구분 기말재고 방식	

			, D.PROCESS_GROUP							--공정그룹
			, D.PROCESS_DETAIL							--자재그룹
			, A.GPLM_CELL_MODEL							--GPLM대상셀
			, A.MDM_NICK_NAME							--MDM프로젝트닉네임
			, C.SCP_EXTRA_SPEC	
			, ( CASE 
					WHEN D.PROCESS_GROUP = 'Cell' THEN '1.000000'					  -- 20220607 CELL 인 경우 환산계수 = 1 
					WHEN D.ITEM_TYPE IN (N'반제품',N'제품') AND WCF.CELL_CF IS NOT NULL 
					THEN WCF.CELL_CF         -- 20220607 GPLM IF 환산계수
					ELSE null
					END
				) AS GPLM_CELL_CONVERSION_FACTOR
			, ( CASE 
					WHEN D.PROCESS_GROUP = 'Cell' THEN 'Cell'					
					WHEN D.ITEM_TYPE IN (N'반제품',N'제품') AND WCF.CELL_CF IS NOT NULL THEN 'WCF'
					WHEN D.ITEM_TYPE IN (N'반제품',N'제품') AND WCF.CELL_CF IS     NULL THEN 'BOM'
					ELSE NULL
					END
				) AS CELL_CF_TYPE
			, (SELECT CELL_CF_BOM FROM #W_CELL_CF_BOM WHERE CHILD_ITEM_ID = A.ITEM_ID and plant_id = A.PLANT_ID and MODEL_ID = WCF.TARGET_CELL) AS CELL_CF_BOM
					
			, D.LEVEL_1_NAME																																	--MDM자재분류계층구조1
			, D.LEVEL_2_NAME																																	--MDM자재분류계층구조2
			, D.LEVEL_3_NAME																																	--MDM자재분류계층구조3
			, D.LEVEL_4_NAME	
			, A.VALUATION_CLASS			
			, A.LONG_TERM_STOCK_QTY		
			, IIF(A.WAERS=N'KRW' OR A.EX_TO_BAMT=0, A.LONG_TERM_STOCK_AMOUNT, A.EX_TO_BAMT*A.LONG_TERM_STOCK_AMOUNT)             AS LONG_TERM_STOCK_AMOUNT			
			, A.CURRENCY					
			, A.AMOUNT		
			, A.AMOUNT_KRW				
			, A.UNIT_PRICE	
			, CASE WHEN A.LPEIN IS NOT NULL AND A.LPEIN <> 0 
					THEN IIF(A.CURRENCY = 'KRW', A.UNIT_PRICE_ORG / A.LPEIN, A.UNIT_PRICE_ORG * A.EX_TO_BAMT / A.LPEIN) 
					ELSE A.UNIT_PRICE_KRW
					END AS UNIT_PRICE_KRW
			, IIF(A.CURRENCY = 'KRW', '1', A.EX_TO_BAMT) AS EX_TO_BAMT								
			, WCF.CELL_CF		
			, 'LongTerm' AS REPORT_TYPE 	
			, A.LPEIN
			, UNIT_PRICE_ORG
			 
			, FI.GROUP_CODE1			AS CELL_GROUP
			, FI.GROUP_CODE2			AS PACK_GROUP
		FROM #TMP_SCP_ANL_LONG_TERM_STOCK A
		LEFT JOIN W_PLANT B							  ON A.PLANT_ID   = B.PLANT_ID
		LEFT JOIN W_EXTRA_SPEC C					  ON A.ITEM_ID    = C.ITEM_ID
		LEFT JOIN SCM_MST_ITEM_CLASS_M D WITH(NOLOCK) ON C.ITEM_CLASS = D.CLASS_ID
		LEFT JOIN #W_CELL_CF WCF WITH(NOLOCK)         ON A.ITEM_ID	  = WCF.ITEM_ID 
		                                             AND WCF.RankNo   = 1
		LEFT JOIN W_SI S1                             ON A.ITEM_ID    = S1.ITEM_ID 
		LEFT JOIN SCP_MST_FINAL_ITEM FI WITH(NOLOCK)  ON A.DIVISION_ID	= FI.DIVISION_ID
			                                         AND A.ITEM_ID		= FI.ITEM_ID
	) LIST
	) DATA
	; 

	IF OBJECT_ID('tempdb..#TMP_SCP_ANL_LONG_TERM_STOCK_SUM') IS NOT NULL	
		DROP TABLE #TMP_SCP_ANL_LONG_TERM_STOCK_SUM;



	--#####################################################################################################################################
	-- #TMP_MONTH_END_STOCK
	--#####################################################################################################################################
	IF OBJECT_ID('tempdb..#TMP_MONTH_END_STOCK') IS NOT NULL	
		DROP TABLE #TMP_MONTH_END_STOCK;


	CREATE TABLE [dbo].[#TMP_MONTH_END_STOCK](
		[YYYYMM] [varchar](6) NOT NULL,
		[DIVISION_ID] [varchar](10) NOT NULL,
	   -- [COMPANY_ID] [varchar](4) NOT NULL,
		[PLANT_ID] [varchar](4) NOT NULL,
		[ITEM_ID] [varchar](18) NOT NULL,
		[STORAGE_LOCATION] [nvarchar](15) NOT NULL,
		[STORAGE_DESC] [nvarchar](200) NULL,
		[VALUATION_CLASS] [varchar](4) NOT NULL,
		--ATTRIBUTE6 [nvarchar](100) NOT NULL,
		[QUANTITY] [numeric](20, 5) NULL,
		[AMOUNT] [numeric](20, 5) NULL,
		[AMOUNT_KRW] [numeric](20, 5) NULL,
		[UNIT_PRICE] [numeric](20, 5) NULL,
		[UNIT_PRICE_KRW] [numeric](20, 5) NULL,
		[CURRENCY] [varchar](3) NULL,
		[EX_TO_BAMT] [numeric](20, 5) NULL,
		[UNRESTRICTED_QTY] [numeric](20, 5) NULL,
		[QT_STOCK] [numeric](20, 5) NULL,
		[BLOCKED_STOCK] [numeric](20, 5) NULL,
		
		PRIMARY KEY (YYYYMM, DIVISION_ID,PLANT_ID ,ITEM_ID, STORAGE_LOCATION, VALUATION_CLASS)
	) 

			---------------------------------------------------------------------
			INSERT INTO #TMP_MONTH_END_STOCK
				(
				YYYYMM
			   ,DIVISION_ID
			   ,PLANT_ID		,ITEM_ID	,STORAGE_LOCATION	,STORAGE_DESC	,VALUATION_CLASS 
			   ,QUANTITY		,AMOUNT		,AMOUNT_KRW			,UNIT_PRICE		,UNIT_PRICE_KRW		,CURRENCY, EX_TO_BAMT
			   ,UNRESTRICTED_QTY,QT_STOCK	,BLOCKED_STOCK
				)
		      select 	 ('‘' + SUBSTRING(@p_yyyymm, 3, 2) + '.' + RIGHT(@p_yyyymm, 2)) AS YYYYMM
						,A.DIVISION_ID
						--,A.COMPANY_ID
						,A.PLANT_ID
						,A.ITEM_ID
						,IIF(A.STORAGE_LOCATION='','-',A.STORAGE_LOCATION) AS STORAGE_LOCATION
						,MAX(A.STORAGE_DESC) AS STORAGE_DESC
						,MAX(A.VALUATION_CLASS) AS VALUATION_CLASS
						--,A.ATTRIBUTE6
						,SUM(IIF(YYYYMM = @p_yyyymm , A.QUANTITY, NULL))		AS QUANTITY
						,SUM(IIF(YYYYMM = @p_yyyymm , A.AMOUNT, NULL))		    AS AMOUNT
						,SUM(IIF(YYYYMM = @p_yyyymm , A.AMOUNT_KRW, NULL))	    AS AMOUNT_KRW
						,MAX(IIF(YYYYMM = @p_yyyymm , A.UNIT_PRICE, NULL))		AS UNIT_PRICE
						,MAX(IIF(YYYYMM = @p_yyyymm , A.UNIT_PRICE_KRW, NULL))	AS UNIT_PRICE_KRW
						,MAX(IIF(YYYYMM = @p_yyyymm , A.CURRENCY, NULL))		AS CURRENCY
						,ISNULL(MAX( IIF(YYYYMM = @p_yyyymm, IIF(A.CURRENCY = 'KRW', '1',A.ATTRIBUTE9) , NULL)),NULL) AS EX_TO_BAMT
						,SUM(IIF(YYYYMM = @p_yyyymm , A.UNRESTRICTED_QTY, NULL) ) AS UNRESTRICTED_QTY
						,SUM(IIF(YYYYMM = @p_yyyymm , A.QT_STOCK, NULL) ) AS QT_STOCK
						,SUM(IIF(YYYYMM = @p_yyyymm , A.BLOCKED_STOCK, NULL) ) AS BLOCKED_STOCK
				from SCP_ANL_MONTH_END_STOCK_R A WITH (NOLOCK) 
		   LEFT JOIN SCP_MST_FINAL_ITEM FI WITH(NOLOCK)
				  ON A.DIVISION_ID	= FI.DIVISION_ID
			     AND A.ITEM_ID		= FI.ITEM_ID
			WHERE 1=1
			and A.DIVISION_ID IS NOT NULL
			AND A.YYYYMM BETWEEN  @v_yyyymm_month1 AND @p_yyyymm
			AND A.STORAGE_LOCATION != N'미착'
			AND A.VALUATION_CLASS NOT IN  
										( SELECT SEGMENT1 
											FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
										   WHERE LOOKUP_TYPE ='ERP_LONGTERM_EXCEPT_VALCALSS'
										     AND VALID_YN = 'Y'
										) 
			AND ( ISNULL(@p_division_id, '')			= '' OR A.DIVISION_ID			IN (SELECT token FROM dbo.String_Split(@p_division_id,',')) )
			AND ( ISNULL(@p_plant_id, '')				= '' OR A.PLANT_ID				IN (SELECT token FROM dbo.String_Split(@p_plant_id,',')) )
			AND ( ISNULL(@p_item_id, '')	            = '' OR A.ITEM_ID				IN (SELECT token FROM dbo.String_Split(@p_item_id,',')) )
		   GROUP BY 
		            --A.YYYYMM
					 A.DIVISION_ID
					--,A.COMPANY_ID
					,A.PLANT_ID
					,A.ITEM_ID
					,A.STORAGE_LOCATION
					--,A.VALUATION_CLASS
					--,A.ATTRIBUTE6

	--#####################################################################################################################################
	-- 최근5개월
	--#####################################################################################################################################
	
		      select 	 ('‘' + SUBSTRING(YYYYMM, 3, 2) + '.' + RIGHT(YYYYMM, 2)) AS YYYYMM
			            ,A.YYYYMM AS YYYYMM_ORG
						,A.DIVISION_ID
						,A.PLANT_ID
						,A.ITEM_ID
						,IIF(A.STORAGE_LOCATION='','-',A.STORAGE_LOCATION) AS STORAGE_LOCATION
						,SUM(A.QUANTITY)			AS QUANTITY
						,SUM(A.UNRESTRICTED_QTY)	AS UNRESTRICTED_QTY
						,SUM(A.QT_STOCK)			AS QT_STOCK
						,SUM(A.BLOCKED_STOCK)		AS BLOCKED_STOCK
				INTO #TMP_MONTH_END_STOCK_MONTH
				from SCP_ANL_MONTH_END_STOCK_R A WITH (NOLOCK) 
		   LEFT JOIN SCP_MST_FINAL_ITEM FI WITH(NOLOCK)
				  ON A.DIVISION_ID	= FI.DIVISION_ID
			     AND A.ITEM_ID		= FI.ITEM_ID
			WHERE 1=1
			and A.DIVISION_ID IS NOT NULL
			AND A.YYYYMM BETWEEN  @v_yyyymm_month1 AND @p_yyyymm
			AND ( ISNULL(@p_division_id, '')			= '' OR A.DIVISION_ID			IN (SELECT token FROM dbo.String_Split(@p_division_id,',')) )
			AND ( ISNULL(@p_plant_id, '')				= '' OR A.PLANT_ID				IN (SELECT token FROM dbo.String_Split(@p_plant_id,',')) )
			AND ( ISNULL(@p_item_id, '')	            = '' OR A.ITEM_ID				IN (SELECT token FROM dbo.String_Split(@p_item_id,',')) )
		   GROUP BY A.YYYYMM
					,A.DIVISION_ID
					,A.PLANT_ID
					,A.ITEM_ID
					,A.STORAGE_LOCATION



	--#####################################################################################################################################
	-- #TMP_MONTH_END_STOCK_JOIN
	--#####################################################################################################################################
	    

		 SELECT  YYYYMM		
				,DIVISION_ID
				,PLANT_ID
				,ITEM_ID
				,MAX(PLANT_DESCRIPTION)				AS PLANT_DESCRIPTION
				,MAX(ITEM_NAME)						AS ITEM_NAME
				,MAX(ITEM_UOM)						AS ITEM_UOM
				,MAX(ITEM_TYPE)						AS ITEM_TYPE
				,MAX(PROCESS_GROUP)					AS PROCESS_GROUP
				,MAX(PROCESS_DETAIL)				AS PROCESS_DETAIL
				,MAX(GPLM_CELL_MODEL)				AS GPLM_CELL_MODEL
				,MAX(MDM_NICK_NAME)					AS MDM_NICK_NAME
				,MAX(SCP_EXTRA_SPEC)				AS SCP_EXTRA_SPEC
				,MAX(GPLM_CELL_CONVERSION_FACTOR)	AS GPLM_CELL_CONVERSION_FACTOR
				,MAX(LEVEL_1_NAME)					AS LEVEL_1_NAME
				,MAX(LEVEL_2_NAME)					AS LEVEL_2_NAME
				,MAX(LEVEL_3_NAME)					AS LEVEL_3_NAME
				,MAX(LEVEL_4_NAME)					AS LEVEL_4_NAME
		INTO #TMP_SCP_ANL_LONG_TERM_STOCK_JOIN
		FROM #TMP_LONG_TERM_STOCK_FINISH
		GROUP BY YYYYMM		
				,DIVISION_ID
				,PLANT_ID
				,ITEM_ID



		 SELECT 
				 L.YYYYMM
				,L.DIVISION_ID
				,L.PLANT_DESCRIPTION
				,L.PLANT_ID
				,L.ITEM_ID
				,L.ITEM_NAME
				,L.ITEM_UOM
				,L.ITEM_TYPE
				,L.PROCESS_GROUP
				,L.PROCESS_DETAIL
				,L.GPLM_CELL_MODEL
				,L.MDM_NICK_NAME
				,L.SCP_EXTRA_SPEC
				,L.GPLM_CELL_CONVERSION_FACTOR
				,L.LEVEL_1_NAME
				,L.LEVEL_2_NAME
				,L.LEVEL_3_NAME
				,L.LEVEL_4_NAME
				,E.VALUATION_CLASS
				,E.QUANTITY AS LONG_TERM_STOCK_QTY
				,E.AMOUNT_KRW AS LONG_TERM_STOCK_AMOUNT
				,E.CURRENCY
				,E.EX_TO_BAMT AS EX_TO_BAMT
				,E.AMOUNT_KRW
				,E.AMOUNT
				,E.UNIT_PRICE
				,E.UNIT_PRICE_KRW
				,'Ending' AS REPORT_TYPE
				,E.STORAGE_LOCATION AS INVENTORY_TYPE
				,E.STORAGE_DESC AS INVENTORY_TYPE_DESC
				,CONCAT('90_',E.STORAGE_DESC) AS INVENTORY_TYPE_SORT
				--,E.QUANTITY AS QTY_MONTH_FOCUS
				,E.UNRESTRICTED_QTY AS INV_STATUS_AVAILABLE
				--,(E.QUANTITY - (ISNULL(QT_STOCK,0) + ISNULL(BLOCKED_STOCK,0)))  AS INV_STATUS_AVAILABLE
				--,CASE WHEN QT_STOCK IS NULL AND BLOCKED_STOCK IS NULL THEN NULL
				--      ELSE (ISNULL(QT_STOCK,0) + ISNULL(BLOCKED_STOCK,0)) 
				--	  END AS INV_STATUS_HOLDING
				,CASE WHEN UNRESTRICTED_QTY IS NULL AND QUANTITY IS NULL THEN NULL
				      ELSE ISNULL(QUANTITY,0) - ISNULL(UNRESTRICTED_QTY,0) 
					  END AS INV_STATUS_HOLDING
				,E.QT_STOCK AS INV_STATUS_QT
				,E.BLOCKED_STOCK AS INV_STATUS_BLOCKED
				, CASE 
				   WHEN QUANTITY != ( UNRESTRICTED_QTY + QT_STOCK + BLOCKED_STOCK) THEN 40
				   WHEN QT_STOCK > 0 THEN 30
				   WHEN BLOCKED_STOCK > 0 THEN 20
				   WHEN QUANTITY != UNRESTRICTED_QTY THEN 10
				   ELSE 0
				   END CHK_QTY

			, ( CASE 
				WHEN L.DIVISION_ID = '40'AND L.ITEM_TYPE IN (N'제품') AND Right(L.ITEM_ID,2) IN  ('-A','-B', '-C','-D','-E','-F','-G','-H','-I','-J','-K','-R')  AND WCF.CELL_CF IS NULL THEN 'TYPE_GR_A'
				WHEN L.DIVISION_ID = '40'AND L.ITEM_TYPE IN (N'제품') AND Right(L.ITEM_ID,3) IN  ('-GG','-GK')  AND WCF.CELL_CF IS NULL THEN 'TYPE_GR_G'
				WHEN L.DIVISION_ID = '40'AND L.ITEM_TYPE IN (N'제품') THEN 'TYPE_GR_PRODUCT'
				ELSE 'TYPE_GR'
				END
			) AS ITEM_TYPE_GR
			, WCF.CELL_CF
			, FI.GROUP_CODE1			AS CELL_GROUP
			, FI.GROUP_CODE2			AS PACK_GROUP


		INTO #TMP_MONTH_END_STOCK_JOIN
		FROM #TMP_SCP_ANL_LONG_TERM_STOCK_JOIN L 
  INNER join #TMP_MONTH_END_STOCK E        ON L.YYYYMM		= E.YYYYMM		
									      and L.DIVISION_ID	= E.DIVISION_ID
										  and L.PLANT_ID	= E.PLANT_ID
										  and L.ITEM_ID		= E.ITEM_ID
	LEFT JOIN #W_CELL_CF WCF WITH(NOLOCK)  ON L.ITEM_ID	    = WCF.ITEM_ID 
		                                  AND WCF.RankNo    = 1
	LEFT JOIN SCP_MST_FINAL_ITEM FI WITH(NOLOCK)
											ON L.DIVISION_ID	= FI.DIVISION_ID
										   AND L.ITEM_ID		= FI.ITEM_ID


	CREATE INDEX IDX_TMP_MONTH_END_STOCK_MONTH ON #TMP_MONTH_END_STOCK_MONTH (YYYYMM_ORG,DIVISION_ID,PLANT_ID,ITEM_ID,STORAGE_LOCATION);
	CREATE INDEX IDX_TMP_MONTH_END_STOCK_JOIN ON #TMP_MONTH_END_STOCK_JOIN (YYYYMM,DIVISION_ID,PLANT_ID,ITEM_ID,INVENTORY_TYPE);


	--#####################################################################################################################################
	-- #TMP_LONG_TERM_STOCK_FINISH
	--#####################################################################################################################################
		SELECT *
		      , (SELECT MAX(QUANTITY)
			     FROM #TMP_MONTH_END_STOCK_MONTH S 
				WHERE YYYYMM_ORG		= @v_yyyymm_month1 
				AND S.DIVISION_ID	= DATA.DIVISION_ID
				AND S.PLANT_ID		= DATA.PLANT_ID
				AND S.ITEM_ID		= DATA.ITEM_ID
				AND S.STORAGE_LOCATION= DATA.INVENTORY_TYPE
				) AS QTY_MONTH1 
			, (SELECT MAX(QUANTITY)
			     FROM #TMP_MONTH_END_STOCK_MONTH S 
				WHERE YYYYMM_ORG		= @v_yyyymm_month2
				AND S.DIVISION_ID	= DATA.DIVISION_ID
				AND S.PLANT_ID		= DATA.PLANT_ID
				AND S.ITEM_ID		= DATA.ITEM_ID
				AND S.STORAGE_LOCATION= DATA.INVENTORY_TYPE
				) AS QTY_MONTH2  
			, (SELECT MAX(QUANTITY)
			     FROM #TMP_MONTH_END_STOCK_MONTH S 
				WHERE YYYYMM_ORG		= @v_yyyymm_month3
				AND S.DIVISION_ID	= DATA.DIVISION_ID
				AND S.PLANT_ID		= DATA.PLANT_ID
				AND S.ITEM_ID		= DATA.ITEM_ID
				AND S.STORAGE_LOCATION= DATA.INVENTORY_TYPE
				) AS QTY_MONTH3  
			, (SELECT MAX(QUANTITY)
			     FROM #TMP_MONTH_END_STOCK_MONTH S 
				WHERE YYYYMM_ORG		= @v_yyyymm_month4
				AND S.DIVISION_ID	= DATA.DIVISION_ID
				AND S.PLANT_ID		= DATA.PLANT_ID
				AND S.ITEM_ID		= DATA.ITEM_ID
				AND S.STORAGE_LOCATION= DATA.INVENTORY_TYPE
				) AS QTY_MONTH4
			, (SELECT MAX(QUANTITY)
			     FROM #TMP_MONTH_END_STOCK_MONTH S 
				WHERE YYYYMM_ORG		= @v_yyyymm_month5
				AND S.DIVISION_ID	= DATA.DIVISION_ID
				AND S.PLANT_ID		= DATA.PLANT_ID
				AND S.ITEM_ID		= DATA.ITEM_ID
				AND S.STORAGE_LOCATION= DATA.INVENTORY_TYPE
				) AS QTY_MONTH5
			, (SELECT MAX(QUANTITY)
			     FROM #TMP_MONTH_END_STOCK_MONTH S 
				WHERE YYYYMM_ORG		= @p_yyyymm
				AND S.DIVISION_ID	= DATA.DIVISION_ID
				AND S.PLANT_ID		= DATA.PLANT_ID
				AND S.ITEM_ID		= DATA.ITEM_ID
				AND S.STORAGE_LOCATION= DATA.INVENTORY_TYPE
				) AS QTY_MONTH_FOCUS
			, ( CASE 
				WHEN ITEM_TYPE_GR = 'TYPE_GR_A'		THEN (select MAX(GROUP_CODE3) from #SCP_MST_FINAL_ITEM where  item_id = left(DATA.ITEM_ID,len(DATA.ITEM_ID) - 2))
				WHEN ITEM_TYPE_GR = 'TYPE_GR_G'		THEN (select MAX(GROUP_CODE3) from #SCP_MST_FINAL_ITEM where  item_id = left(DATA.ITEM_ID,len(DATA.ITEM_ID) - 3))
				WHEN ITEM_TYPE_GR = 'TYPE_GR_PRODUCT'	THEN (select MAX(GROUP_CODE3) from #SCP_MST_FINAL_ITEM where  item_id = DATA.ITEM_ID) -- 20220428 Gro
				ELSE NULL 
				END
			) AS CELL_TYPE_GR -- 20221004 추가
		INTO #TMP_MONTH_END_STOCK_FINISH
		FROM #TMP_MONTH_END_STOCK_JOIN AS DATA

		IF OBJECT_ID('tempdb..#TMP_MONTH_END_STOCK_JOIN') IS NOT NULL
		DROP TABLE #TMP_MONTH_END_STOCK_JOIN;

		IF OBJECT_ID('tempdb..#TMP_MONTH_END_STOCK') IS NOT NULL
		DROP TABLE #TMP_MONTH_END_STOCK;

		IF OBJECT_ID('tempdb..#TMP_MONTH_END_STOCK_MONTH') IS NOT NULL
		DROP TABLE #TMP_MONTH_END_STOCK_MONTH;


	SELECT TOTAL.*
	FROM
	(
		 SELECT  YYYYMM					,DIVISION_ID	,PLANT_ID			,PLANT_DESCRIPTION		,ITEM_ID		,ITEM_NAME					,ITEM_UOM	,ITEM_TYPE	
				,PROCESS_GROUP			,PROCESS_DETAIL	,GPLM_CELL_MODEL	,MDM_NICK_NAME			,SCP_EXTRA_SPEC	,GPLM_CELL_CONVERSION_FACTOR	
				,LEVEL_1_NAME			,LEVEL_2_NAME	,LEVEL_3_NAME		,LEVEL_4_NAME			,VALUATION_CLASS	
				,LONG_TERM_STOCK_QTY	,LONG_TERM_STOCK_AMOUNT				,CURRENCY				,EX_TO_BAMT		,AMOUNT_KRW		,AMOUNT		,UNIT_PRICE	,UNIT_PRICE_KRW	
				,REPORT_TYPE			,INVENTORY_TYPE						,INVENTORY_TYPE_DESC	,INVENTORY_TYPE_SORT	
				,QTY_MONTH_FOCUS		,QTY_MONTH1		,QTY_MONTH2			,QTY_MONTH3				,QTY_MONTH4		,QTY_MONTH5	
				,CELL_GROUP	,PACK_GROUP, CELL_TYPE_GR
				,NULL AS INV_STATUS_AVAILABLE
				,NULL AS INV_STATUS_HOLDING
				,NULL AS INV_STATUS_QT
				,NULL AS INV_STATUS_BLOCKED
				,NULL AS CHK_QTY
		FROM #TMP_LONG_TERM_STOCK_FINISH

		UNION

		 SELECT  YYYYMM					,DIVISION_ID	,PLANT_ID			,PLANT_DESCRIPTION		,ITEM_ID		,ITEM_NAME					,ITEM_UOM	,ITEM_TYPE	
				,PROCESS_GROUP			,PROCESS_DETAIL	,GPLM_CELL_MODEL	,MDM_NICK_NAME			,SCP_EXTRA_SPEC	,GPLM_CELL_CONVERSION_FACTOR	
				,LEVEL_1_NAME			,LEVEL_2_NAME	,LEVEL_3_NAME		,LEVEL_4_NAME			,VALUATION_CLASS	
				,LONG_TERM_STOCK_QTY	,LONG_TERM_STOCK_AMOUNT				,CURRENCY				,EX_TO_BAMT		,AMOUNT_KRW		,AMOUNT		,UNIT_PRICE	,UNIT_PRICE_KRW	
				,REPORT_TYPE			,INVENTORY_TYPE						,INVENTORY_TYPE_DESC	,INVENTORY_TYPE_SORT	
				,QTY_MONTH_FOCUS		,QTY_MONTH1		,QTY_MONTH2			,QTY_MONTH3				,QTY_MONTH4		,QTY_MONTH5	
				,CELL_GROUP				,PACK_GROUP		,CELL_TYPE_GR
				,INV_STATUS_AVAILABLE	,INV_STATUS_HOLDING	,INV_STATUS_QT	,INV_STATUS_BLOCKED     ,CHK_QTY    
		FROM #TMP_MONTH_END_STOCK_FINISH

	) TOTAL
	ORDER BY DIVISION_ID, PLANT_ID, ITEM_ID, INVENTORY_TYPE_SORT
	
	------------------------------------------------------------------------
    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @n_log_count   = @@ROWCOUNT;
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	------------------------------------------------------------------------


	SELECT @END_TIME = GETDATE()
	PRINT '#TOTAL : ' + CONVERT(VARCHAR(100), @END_TIME-@START_TIME, 114)




	IF OBJECT_ID('tempdb..#TMP_LONG_TERM_STOCK_FINISH') IS NOT NULL
	DROP TABLE #TMP_LONG_TERM_STOCK_FINISH;

	IF OBJECT_ID('tempdb..#TMP_MONTH_END_STOCK_FINISH') IS NOT NULL
	DROP TABLE #TMP_MONTH_END_STOCK_FINISH;
END

