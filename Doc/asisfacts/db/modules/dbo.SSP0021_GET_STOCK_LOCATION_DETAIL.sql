/*
 * Program ID   : [SSP0021_GET_STOCK_LOCATION_DETAIL]
 * Description  : 자동차 Shipment Plan
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2019/09/06   mcThej			Initial Release [PJ20189106} 전지.GSCM 고도화 이행 PROJECT
 * 2019/10/14   mcThej			Initial Release [PJ20189106} 전지.GSCM 고도화 이행 PROJECT - NICK NAME 추가
 * 2019/10/15   juhlee          Pack 생산 창고 추가 CMA_BMA . 2019.10.15 (requested by 김광희)
 * 2020/01/29   KIMYONGHO       [C20200121-000352]  ESS Packer출하 적용 
                                 - [C20200121-000352]-1 : ESS Packer 재고 적용(SSP_DNM_ESS_PACKER_STOCK_V)
 * 2021/05/27   KIMYONGHO	    A/S PLANT ERP 재고 반영  수정
 * 2021/06/01   SSP Pjt.        AS ERP 재고 적용
 * 2021/06/14   SSP Pjt.        화면속도개선(SCM_DNM_STOCK_V -> SSP_DNM_STOCK_C)
 * 2023/09/11   jilee           반제품->제품코드 변환 작업
 * ex)
	EXEC SSP0021_GET_STOCK_LOCATION_DETAIL @p_division_id = '81', @p_company_id = 'C100', @p_from_site = 'A040-A',  @p_item_id = 'ACEN1053I-B1-D03', @p_plan_start_yyyymmdd = '20191023', @p_dbl_flag = 'Y', @p_language = 'KO', @p_program_id = 'SSP0021', @p_sheet_name ='Stock Location Detail', @debug_mode = 'T'
 */
CREATE PROCEDURE [dbo].[SSP0021_GET_STOCK_LOCATION_DETAIL]
	@p_division_id			VARCHAR(10)
	,@p_company_id			NVARCHAR(100)
	,@p_from_site			NVARCHAR(MAX)
	,@p_item_id				NVARCHAR(MAX)
	,@p_plan_start_yyyymmdd	NVARCHAR(8)
	,@p_dbl_flag			CHAR(1)
	,@p_language            NVARCHAR(MAX) = 'KO'
	,@p_program_id			NVARCHAR(MAX) = 'SSP0021' 
	,@p_sheet_name			NVARCHAR(MAX) = 'Stock Location Detail'
	,@debug_mode			NVARCHAR(1)='T'

AS  
  
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;	

	DECLARE @mDQry NVARCHAR(MAX)='';

	DECLARE  @v_from_site		NVARCHAR(MAX)='';
	DECLARE  @v_item_id			NVARCHAR(MAX)='';
	
	DECLARE @v_boh_yyyymmdd		NVARCHAR(8);
	DECLARE @v_stock_yyyymmdd	NVARCHAR(8);

	SET @v_boh_yyyymmdd = CONVERT(CHAR(8), DATEADD(DD, -1, CONVERT(VARCHAR, @p_plan_start_yyyymmdd, 121)), 112); --FROM -1일
	SET @v_stock_yyyymmdd = CONVERT(CHAR(8), DATEADD(DD, -3, CONVERT(VARCHAR, @p_plan_start_yyyymmdd, 121)), 112); --FROM -3일

	--IN 조건으로 데이터를 가져옴
	SET @v_from_site = [dbo].FN_GET_IN_STR(@p_from_site);
	SET @v_item_id = [dbo].FN_GET_IN_STR(@p_item_id);
	--select @v_requestor; --SET @v_requestor = [dbo].FN_GET_IN_STR2(@p_requestor);

	DECLARE @MST_LOCATION   TABLE
	(
		[DIVISION_ID]			[nvarchar](30) NOT NULL INDEX VIX_TAB_STOCK_01(DIVISION_ID, SCM_SITE_ID, PLANT_ID, STORAGE_ID, LOCATION_CODE)
	   ,[SCM_SITE_ID]			[nvarchar](30) NOT NULL
	   ,[PLANT_ID]              [nvarchar](50) not null
	   ,[STORAGE_ID]			[nvarchar](50)
	   ,LOCATION_CODE           nvarchar(160)  
	)

	INSERT INTO @MST_LOCATION (
	       DIVISION_ID
		  ,SCM_SITE_ID
		  ,PLANT_ID
		  ,STORAGE_ID
		  ,LOCATION_CODE)
	SELECT
		   tt0.DIVISION_ID
		  ,tt0.SCM_SITE_ID
		  ,tt0.PLANT_ID
		  ,tt0.STORAGE_ID
		  ,tt0.LOCATION_CODE
	  FROM SSP_MST_LOCATION_V tt0 WITH(NOLOCK)
		   INNER JOIN SCM_MST_SITE tt1 WITH(NOLOCK)
		ON tt0.DIVISION_ID	= tt1.DIVISION_ID	
	   AND tt0.SCM_SITE_ID	= tt1.SCM_SITE_ID
	   AND tt0.PLANT_ID		= tt1.PLANT_ID
	   AND tt1.DIVISION_ID	= @p_division_id	
	   AND tt1.COMPANY_ID	= @p_company_id
	   AND tt1.VALID_YN		= 'Y'					
	   AND tt1.site_type	= 'PLANT' 
	 WHERE 1 = 1
	   AND tt0.VALID_YN ='Y'
	   AND tt0.DIVISION_ID	= @p_division_id
	   AND tt1.company_id	= @p_company_id
	   AND tt0.LOCATION_CODE IN ('PACK_OWMS', 'CELL_OWMS', 'FORMATION_CHECK_PACKAGING','CMA_BMA')
	   AND ((@p_from_site IS NULL OR @p_from_site ='') OR tt0.scm_site_id IN (SELECT token FROM dbo.String_Split(@p_from_site, ',')))
	 GROUP BY 
	       tt0.DIVISION_ID, tt0.SCM_SITE_ID, tt0.PLANT_ID, tt0.STORAGE_ID, tt0.LOCATION_CODE

	UNION ALL
	SELECT DISTINCT
		   tt0.SEGMENT1 AS DIVISION_ID
		  ,tt0.SEGMENT2 AS SCM_SITE_ID
		  ,tt0.SEGMENT3 AS PLANT_ID
		  ,tt0.SEGMENT4 AS STORAGE_ID
		  ,'AS' AS LOCATION_CODE
	  FROM SCM_ADM_LOOKUP_MASTER_DETAIL tt0 WITH(NOLOCK)
		   INNER JOIN SCM_MST_SITE tt1 WITH(NOLOCK)
		ON tt0.SEGMENT1 = tt1.DIVISION_ID	
	   AND tt0.SEGMENT2 = tt1.SCM_SITE_ID
	   AND tt0.SEGMENT3 = tt1.PLANT_ID
	   and tt0.LOOKUP_TYPE = 'SSP_AS_DIV_SLOC'
	   and tt0.valid_yn = 'Y'
	   AND tt1.DIVISION_ID = @p_division_id	
	   AND tt1.COMPANY_ID  = @p_company_id
	   AND tt1.VALID_YN ='Y'					
	   AND tt1.site_type = 'PLANT' 
	 WHERE 1 = 1
	   AND tt0.VALID_YN ='Y'
	   AND tt0.SEGMENT1   = @p_division_id
	   AND tt1.company_id = @p_company_id
	   AND ((@p_from_site IS NULL OR @p_from_site ='') OR tt0.SEGMENT2 IN (SELECT token FROM dbo.String_Split(@p_from_site, ',')))


	if @p_dbl_flag = 'Y'
	BEGIN
		SELECT A.* FROM (

		-- * 2021/05/27   KIMYONGHO	    A/S PLANT ERP 재고 반영  수정
		--SELECT  
		--	STOCK.DIVISION_ID
		--	,STOCK.COMPANY_ID
		--	,STOCK.cutoff_date AS CUTOFF_DATE 
		--	,STOCK.SCM_SITE_ID AS FROM_SITE
		--	,STOCK.PLANT_ID
		--	,STOCK.ITEM_ID
		--	,dbo.fn_get_item_nickname(STOCK.DIVISION_ID, STOCK.ITEM_ID ) AS nick_name
		--	,STOCK.STOCK_TYPE
		--	,STOCK.STORAGE_ID
		--	,MS.STORAGE_DESCRIPTION	
		--	,ISNULL(STOCK.SCM_QTY, 0) AS TOTAL_QTY
		--	,ISNULL(STOCK.SSP_QTY, 0) AS AVAILABLE_QTY
		--	,STOCK.DEFECT_QTY
		--	,STOCK.MOVING_QTY
		--	,STOCK.QTY_UOM
		--	,ISNULL(STOCK.WIPHOLD_YN,'N') AS WIPHOLD_YN
		--	,STOCK.HOLDING_DATE
		--	,STOCK.AVAILABLE_DATE
		--	,STOCK.OUTSOURCING_FLAG
		--	,STOCK.OUTSOURCING_FACTORY
		--FROM SCM_DNM_STOCK_V STOCK WITH(NOLOCK)
		--LEFT JOIN SCM_MST_SLOC MS WITH(NOLOCK)
		--	ON    STOCK.DIVISION_ID           = MS.DIVISION_ID	
		--	AND   STOCK.PLANT_ID              = MS.PLANT_ID
		--	AND   STOCK.STORAGE_ID            = MS.STORAGE_ID
		--INNER JOIN SCM_MST_LOCATION T1
		--	ON STOCK.division_id = T1.DIVISION_ID			AND STOCK.storage_id = T1.STORAGE_ID
		--	AND STOCK.PLANT_ID = T1.PLANT_ID				
		--	AND STOCK.scm_site_id = T1.SCM_SITE_ID
		--	AND T1.LOCATION_CODE IN ('PACK_OWMS', 'CELL_OWMS', 'FORMATION_CHECK_PACKAGING','CMA_BMA')
		--WHERE 1 = 1
		--AND STOCK.DIVISION_ID = @p_division_id
		--AND STOCK.COMPANY_ID = @p_company_id
		--AND STOCK.scm_site_id = @p_from_site
		--AND STOCK.item_id = @p_item_id
		--AND STOCK.CUTOFF_DATE = @v_boh_yyyymmdd
		--AND STOCK.CUTOFF_DATE >  @v_stock_yyyymmdd -- 현재일 - 3

		SELECT
			   STOCK.DIVISION_ID
			  ,STOCK.COMPANY_ID
			  ,STOCK.cutoff_date AS CUTOFF_DATE 
			  ,STOCK.SCM_SITE_ID AS FROM_SITE
			  ,STOCK.PLANT_ID
			  -- jilee 230911
			  ,ISNULL(STOCK.ATTRIBUTE1,STOCK.ITEM_ID) AS ITEM_ID
			  --,STOCK.ITEM_ID
			  ,dbo.fn_get_item_nickname(STOCK.DIVISION_ID, STOCK.ITEM_ID ) AS nick_name
			  ,STOCK.STOCK_TYPE
			  ,STOCK.STORAGE_ID
			  ,ISNULL(MS.STORAGE_DESCRIPTION, (SELECT TOP 1 STORAGE_DESCRIPTION 
			                                     FROM SCM_MST_SLOC X WITH(NOLOCK) 
			  								    WHERE X.PLANT_ID = STOCK.PLANT_ID 
			  								      AND X.STORAGE_ID = STOCK.STORAGE_ID
			  									  AND X.VALID_YN = 'Y')
			  								  ) AS STORAGE_DESCRIPTION	
			  ,ISNULL(STOCK.SCM_QTY, 0) AS TOTAL_QTY
			  ,ISNULL(STOCK.SSP_QTY, 0) AS AVAILABLE_QTY
			  ,STOCK.DEFECT_QTY
			  ,STOCK.MOVING_QTY
			  ,STOCK.QTY_UOM
			  ,ISNULL(STOCK.WIPHOLD_YN,'N') AS WIPHOLD_YN
			  ,STOCK.HOLDING_DATE
			  ,STOCK.AVAILABLE_DATE
			  ,STOCK.OUTSOURCING_FLAG
			  ,STOCK.OUTSOURCING_FACTORY
		  FROM SSP_DNM_STOCK_C STOCK WITH(NOLOCK) --SCM_DNM_STOCK_V
		       LEFT JOIN SCM_MST_SLOC MS WITH(NOLOCK)
			ON STOCK.DIVISION_ID           = MS.DIVISION_ID	
		   AND STOCK.PLANT_ID              = MS.PLANT_ID
		   AND STOCK.STORAGE_ID            = MS.STORAGE_ID
		 INNER JOIN @MST_LOCATION T1
			ON STOCK.division_id	= T1.DIVISION_ID			
		   AND STOCK.STORAGE_ID		= T1.STORAGE_ID
		   --AND STOCK.STORAGE_ID	IN (SELECT TOKEN FROM DBO.UF_FX_STRING_SPLIT(T1.STORAGE_ID,','))
		   AND STOCK.PLANT_ID		= T1.PLANT_ID				
		   AND STOCK.SCM_SITE_ID	= T1.SCM_SITE_ID
		   AND T1.LOCATION_CODE IN ('PACK_OWMS', 'CELL_OWMS', 'FORMATION_CHECK_PACKAGING','CMA_BMA', 'AS')
		 WHERE 1 = 1
		   AND STOCK.DIVISION_ID	= @p_division_id
		   AND STOCK.COMPANY_ID		= @p_company_id
		   AND STOCK.SCM_SITE_ID	= @p_from_site
		   -- jilee
		   AND (STOCK.item_id		= @p_item_id OR STOCK.ATTRIBUTE1		= @p_item_id)
		   AND STOCK.CUTOFF_DATE	= @v_boh_yyyymmdd
		   AND STOCK.CUTOFF_DATE	>  @v_stock_yyyymmdd -- 현재일 - 3
		   AND STOCK.STOCK_TYPE		= 'INVENTORY'


		--[C20200121-000352]-1 : ESS Packer 재고 적용(SSP_DNM_ESS_PACKER_STOCK_V) 
		-- SSP_DNM_ESS_PACKER_STOCK_V  ESS(82) PACKER STOCK,  STORAGE_ID : 6000(구미 People works), E400(남경 People works)  
		UNION ALL 
		SELECT    
			STOCK.DIVISION_ID
			,STOCK.COMPANY_ID
			,STOCK.cutoff_date AS CUTOFF_DATE 
			,STOCK.SCM_SITE_ID AS FROM_SITE
			,STOCK.PLANT_ID
			,STOCK.ITEM_ID
			,dbo.fn_get_item_nickname(STOCK.DIVISION_ID, STOCK.ITEM_ID ) AS nick_name
			,STOCK.STOCK_TYPE
			,STOCK.STORAGE_ID
			,MS.STORAGE_DESCRIPTION	
			,ISNULL(STOCK.SCM_QTY, 0) AS TOTAL_QTY
			,ISNULL(STOCK.SSP_QTY, 0) AS AVAILABLE_QTY
			,STOCK.DEFECT_QTY
			,STOCK.MOVING_QTY
			,STOCK.QTY_UOM
			,ISNULL(STOCK.WIPHOLD_YN,'N') AS WIPHOLD_YN
			,STOCK.HOLDING_DATE
			,STOCK.AVAILABLE_DATE
			,STOCK.OUTSOURCING_FLAG
			,STOCK.OUTSOURCING_FACTORY
		FROM  SSP_DNM_ESS_PACKER_STOCK_V STOCK WITH(NOLOCK)
		LEFT JOIN SCM_MST_SLOC MS WITH(NOLOCK)
			ON    STOCK.DIVISION_ID           = MS.DIVISION_ID	
			AND   STOCK.PLANT_ID              = MS.PLANT_ID
			AND   STOCK.STORAGE_ID            = MS.STORAGE_ID
		WHERE 1 = 1
		AND STOCK.DIVISION_ID = @p_division_id
		AND STOCK.COMPANY_ID = @p_company_id
		AND STOCK.scm_site_id = @p_from_site
		AND STOCK.item_id = @p_item_id
		AND STOCK.CUTOFF_DATE = @v_boh_yyyymmdd
		AND STOCK.CUTOFF_DATE >  @v_stock_yyyymmdd -- 현재일 - 3
		
		) A
		ORDER BY A.COMPANY_ID,A.DIVISION_ID,A.FROM_SITE,A.PLANT_ID,A.ITEM_ID,A.STOCK_TYPE,A.STORAGE_ID
		
	END
	ELSE
	BEGIN
		SELECT A.* FROM (
		
		-- * 2021/05/27   KIMYONGHO	    A/S PLANT ERP 재고 반영  수정

		--SELECT  
		--	STOCK.DIVISION_ID
		--	,STOCK.COMPANY_ID
		--	,STOCK.cutoff_date AS CUTOFF_DATE 
		--	,STOCK.SCM_SITE_ID AS FROM_SITE
		--	,STOCK.PLANT_ID
		--	,STOCK.ITEM_ID
		--	,dbo.fn_get_item_nickname(STOCK.DIVISION_ID, STOCK.ITEM_ID ) AS nick_name
		--	,STOCK.STOCK_TYPE
		--	,STOCK.STORAGE_ID
		--	,MS.STORAGE_DESCRIPTION	
		--	,ISNULL(STOCK.SCM_QTY, 0) AS TOTAL_QTY
		--	,ISNULL(STOCK.SSP_QTY, 0) AS AVAILABLE_QTY
		--	,STOCK.DEFECT_QTY
		--	,STOCK.MOVING_QTY
		--	,STOCK.QTY_UOM
		--	,ISNULL(STOCK.WIPHOLD_YN,'N') AS WIPHOLD_YN
		--	,STOCK.HOLDING_DATE
		--	,STOCK.AVAILABLE_DATE
		--	,STOCK.OUTSOURCING_FLAG
		--	,STOCK.OUTSOURCING_FACTORY
		--FROM SCM_DNM_STOCK_V STOCK WITH(NOLOCK) 
		--LEFT JOIN SCM_MST_SLOC MS WITH(NOLOCK)
		--	ON    STOCK.DIVISION_ID           = MS.DIVISION_ID	
		--	AND   STOCK.PLANT_ID              = MS.PLANT_ID
		--	AND   STOCK.STORAGE_ID            = MS.STORAGE_ID
		--INNER JOIN SCM_MST_LOCATION T1
		--	ON STOCK.division_id = T1.DIVISION_ID			AND STOCK.storage_id = T1.STORAGE_ID
		--	AND STOCK.PLANT_ID = T1.PLANT_ID				
		--	AND STOCK.scm_site_id = T1.SCM_SITE_ID
		--	AND T1.LOCATION_CODE IN ('PACK_OWMS', 'CELL_OWMS', 'FORMATION_CHECK_PACKAGING','CMA_BMA') -- Pack 생산 창고 추가 CMA_BMA . 2019.10.15 
		--WHERE 1 = 1
		--AND STOCK.DIVISION_ID = @p_division_id
		--AND STOCK.COMPANY_ID = @p_company_id
		--AND ((@p_from_site IS NULL OR @p_from_site ='') OR STOCK.scm_site_id IN (SELECT token FROM dbo.String_Split(@p_from_site, ',')))
		--AND ((@p_item_id IS NULL OR @p_item_id ='')	OR STOCK.item_id IN (SELECT token FROM dbo.String_Split(@p_item_id, ',')))
		--AND STOCK.CUTOFF_DATE = @v_boh_yyyymmdd	
		--AND STOCK.CUTOFF_DATE >  @v_stock_yyyymmdd -- 현재일 - 3
		
		SELECT  
			   STOCK.DIVISION_ID
			  ,STOCK.COMPANY_ID
			  ,STOCK.cutoff_date AS CUTOFF_DATE 
			  ,STOCK.SCM_SITE_ID AS FROM_SITE
			  ,STOCK.PLANT_ID
			  -- jilee 230911
			  ,ISNULL(STOCK.ATTRIBUTE1,STOCK.ITEM_ID) AS ITEM_ID
			  --,STOCK.ITEM_ID
			  ,dbo.fn_get_item_nickname(STOCK.DIVISION_ID, STOCK.ITEM_ID ) AS nick_name
			  ,STOCK.STOCK_TYPE
			  ,STOCK.STORAGE_ID
			  ,ISNULL(MS.STORAGE_DESCRIPTION, (SELECT TOP 1 STORAGE_DESCRIPTION 
			                                     FROM SCM_MST_SLOC X WITH(NOLOCK) 
			  								    WHERE X.PLANT_ID = STOCK.PLANT_ID 
			  								      AND X.STORAGE_ID = STOCK.STORAGE_ID
			  									  AND X.VALID_YN = 'Y')
			  									) AS STORAGE_DESCRIPTION	
			  ,ISNULL(STOCK.SCM_QTY, 0) AS TOTAL_QTY
			  ,ISNULL(STOCK.SSP_QTY, 0) AS AVAILABLE_QTY
			  ,STOCK.DEFECT_QTY
			  ,STOCK.MOVING_QTY
			  ,STOCK.QTY_UOM
			  ,ISNULL(STOCK.WIPHOLD_YN,'N') AS WIPHOLD_YN
			  ,STOCK.HOLDING_DATE
			  ,STOCK.AVAILABLE_DATE
			  ,STOCK.OUTSOURCING_FLAG
			  ,STOCK.OUTSOURCING_FACTORY
		  FROM SSP_DNM_STOCK_C STOCK WITH(NOLOCK) --SCM_DNM_STOCK_V
		       LEFT JOIN SCM_MST_SLOC MS WITH(NOLOCK)
			ON STOCK.DIVISION_ID           = MS.DIVISION_ID	
		   AND STOCK.PLANT_ID              = MS.PLANT_ID
		   AND STOCK.STORAGE_ID            = MS.STORAGE_ID
		       INNER JOIN @MST_LOCATION T1
			ON STOCK.division_id = T1.DIVISION_ID			
			AND STOCK.STORAGE_ID = T1.STORAGE_ID
			--AND STOCK.STORAGE_ID	IN (SELECT TOKEN FROM DBO.UF_FX_STRING_SPLIT(T1.STORAGE_ID,','))
			AND STOCK.PLANT_ID = T1.PLANT_ID				
			AND STOCK.scm_site_id = T1.SCM_SITE_ID
			AND T1.LOCATION_CODE IN ('PACK_OWMS', 'CELL_OWMS', 'FORMATION_CHECK_PACKAGING','CMA_BMA', 'AS')
		  WHERE 1 = 1
		    AND STOCK.DIVISION_ID = @p_division_id
		    AND STOCK.COMPANY_ID = @p_company_id
		    AND ((@p_from_site IS NULL OR @p_from_site ='') OR STOCK.scm_site_id IN (SELECT token FROM dbo.String_Split(@p_from_site, ',')))
			-- jilee
		    AND ((@p_item_id IS NULL OR @p_item_id ='')	OR STOCK.item_id IN (SELECT token FROM dbo.String_Split(@p_item_id, ',')) OR STOCK.ATTRIBUTE1 IN (SELECT token FROM dbo.String_Split(@p_item_id, ',')))
		    AND STOCK.CUTOFF_DATE = @v_boh_yyyymmdd	
		    AND STOCK.CUTOFF_DATE >  @v_stock_yyyymmdd -- 현재일 - 3
		    AND STOCK.STOCK_TYPE = 'INVENTORY'

		
		
		--[C20200121-000352]-1 : ESS Packer 재고 적용(SSP_DNM_ESS_PACKER_STOCK_V) 
		-- SSP_DNM_ESS_PACKER_STOCK_V  ESS(82) PACKER STOCK,  STORAGE_ID : 6000(구미 People works), E400(남경 People works)  
		UNION ALL 
		SELECT  
			STOCK.DIVISION_ID
			,STOCK.COMPANY_ID
			,STOCK.cutoff_date AS CUTOFF_DATE 
			,STOCK.SCM_SITE_ID AS FROM_SITE
			,STOCK.PLANT_ID
			,STOCK.ITEM_ID
			,dbo.fn_get_item_nickname(STOCK.DIVISION_ID, STOCK.ITEM_ID ) AS nick_name
			,STOCK.STOCK_TYPE
			,STOCK.STORAGE_ID
			,MS.STORAGE_DESCRIPTION
			,ISNULL(STOCK.SCM_QTY, 0) AS TOTAL_QTY
			,ISNULL(STOCK.SSP_QTY, 0) AS AVAILABLE_QTY
			,STOCK.DEFECT_QTY
			,STOCK.MOVING_QTY
			,STOCK.QTY_UOM
			,ISNULL(STOCK.WIPHOLD_YN,'N') AS WIPHOLD_YN
			,STOCK.HOLDING_DATE
			,STOCK.AVAILABLE_DATE
			,STOCK.OUTSOURCING_FLAG
			,STOCK.OUTSOURCING_FACTORY
		FROM  SSP_DNM_ESS_PACKER_STOCK_V STOCK WITH(NOLOCK)
		LEFT JOIN SCM_MST_SLOC MS WITH(NOLOCK)
			ON    STOCK.DIVISION_ID           = MS.DIVISION_ID	
			AND   STOCK.PLANT_ID              = MS.PLANT_ID
			AND   STOCK.STORAGE_ID            = MS.STORAGE_ID
		WHERE 1 = 1
		AND STOCK.DIVISION_ID = @p_division_id
		AND STOCK.COMPANY_ID = @p_company_id
		AND ((@p_from_site IS NULL OR @p_from_site ='') OR STOCK.scm_site_id IN (SELECT token FROM dbo.String_Split(@p_from_site, ',')))
		AND ((@p_item_id IS NULL OR @p_item_id ='')	OR STOCK.item_id IN (SELECT token FROM dbo.String_Split(@p_item_id, ',')))
		AND STOCK.CUTOFF_DATE = @v_boh_yyyymmdd	
		AND STOCK.CUTOFF_DATE >  @v_stock_yyyymmdd -- 현재일 - 3
		) A
		ORDER BY A.COMPANY_ID,A.DIVISION_ID,A.FROM_SITE,A.PLANT_ID,A.ITEM_ID,A.STOCK_TYPE,A.STORAGE_ID
	END

	IF( @debug_mode ='T')
	BEGIN				
		DECLARE @POS INT =1;
		DECLARE @LEN INT =LEN(@mDQry);
		WHILE @POS <= @LEN
			BEGIN
				PRINT SUBSTRING(@mDQry,@POS,4000);
				SET @POS = @POS+4000;
			END;
	END;
END
