
/*
 * Program ID   : SSP0015_GET_STOCK_LOCATION_DETAIL
 * Description  : 소형 외주 Packer
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2021-09-28   KIMYONGHO	    최초작성
 * 2024-10-01   KHJ             NERP_SSP
 */
CREATE PROCEDURE [dbo].[SSP0015_GET_STOCK_LOCATION_DETAIL]
	 @p_division_id			VARCHAR(10)
	,@p_company_id			NVARCHAR(100)
	,@p_from_site			NVARCHAR(MAX)
	,@p_item_id				NVARCHAR(MAX)
	,@p_plan_start_yyyymmdd	NVARCHAR(8)
	,@p_dbl_flag			CHAR(1)
	,@p_language            NVARCHAR(MAX) = 'KO'
	,@p_program_id			NVARCHAR(MAX) = 'SSP0015' 
	,@p_sheet_name			NVARCHAR(MAX) = 'Stock Location Detail'
	,@debug_mode			NVARCHAR(1)='T'
	,@p_user_id				NVARCHAR(MAX)
	,@p_myModelChk			NVARCHAR(MAX)
	,@p_partLeaderChk		NVARCHAR(MAX)
	,@p_teamLeaderChk		NVARCHAR(MAX)
	,@p_delegateeChk		NVARCHAR(MAX)
	,@p_nonChk				NVARCHAR(MAX)

AS  
  
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;	

	DECLARE @mDQry NVARCHAR(MAX)='';

	DECLARE  @v_from_site		NVARCHAR(MAX)='';
	DECLARE  @v_item_id			NVARCHAR(MAX)='';
	
	DECLARE @v_boh_yyyymmdd		NVARCHAR(8);
	DECLARE @v_stock_yyyymmdd	NVARCHAR(8);

	-- NERP 매핑코드
    DECLARE @v_A010 NVARCHAR(10);
	SET @v_A010 = dbo.FN_GET_LOOKUP_VALUE('SSP0015_GET_STOCK_LOCATION_DETAIL'  ,'A010' );	--A010


	SET @v_boh_yyyymmdd = CONVERT(CHAR(8), DATEADD(DD, -1, CONVERT(VARCHAR, @p_plan_start_yyyymmdd, 121)), 112); --FROM -1일
	SET @v_stock_yyyymmdd = CONVERT(CHAR(8), DATEADD(DD, -3, CONVERT(VARCHAR, @p_plan_start_yyyymmdd, 121)), 112); --FROM -3일

	--IN 조건으로 데이터를 가져옴
	SET @v_from_site = [dbo].FN_GET_IN_STR(@p_from_site);
	SET @v_item_id = [dbo].FN_GET_IN_STR(@p_item_id);

	DECLARE @MST_LOCATION   TABLE
	(
		[DIVISION_ID]			[nvarchar](30) NOT NULL INDEX VIX_TAB_STOCK_01(DIVISION_ID, SCM_SITE_ID, PLANT_ID, STORAGE_ID, LOCATION_CODE)
	   ,[SCM_SITE_ID]			[nvarchar](30) NOT NULL
	   ,[PLANT_ID]              [nvarchar](50) not null
	   ,[STORAGE_ID]			[nvarchar](50) NOT NULL
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
		  ,isnull(tt0.STORAGE_ID,'-') as STORAGE_ID
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
	   AND TT1.PLANT_ID     = @v_A010			--'A010'
	 
	 WHERE 1 = 1
	   AND tt0.VALID_YN ='Y'
	   AND tt0.DIVISION_ID	= @p_division_id
	   AND tt1.company_id	= @p_company_id
	   --AND tt0.LOCATION_CODE IN ('PACK_OWMS', 'CELL_OWMS', 'FORMATION_CHECK_PACKAGING','CMA_BMA')
	   AND ((@p_from_site IS NULL OR @p_from_site ='') OR tt0.scm_site_id IN (SELECT token FROM dbo.String_Split(@p_from_site, ',')))
	 GROUP BY 
	       tt0.DIVISION_ID, tt0.SCM_SITE_ID, tt0.PLANT_ID, tt0.STORAGE_ID, tt0.LOCATION_CODE

	if @p_dbl_flag = 'Y'
	BEGIN
		SELECT A.* FROM (	
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

		  FROM [DBO].[SCM_DNM_STOCK_V] STOCK WITH(NOLOCK) --SCM_DNM_STOCK_V
		       LEFT JOIN SCM_MST_SLOC MS WITH(NOLOCK)
			ON STOCK.DIVISION_ID           = MS.DIVISION_ID	
		   AND STOCK.PLANT_ID              = MS.PLANT_ID
		   AND STOCK.STORAGE_ID            = MS.STORAGE_ID
		 --INNER JOIN @MST_LOCATION T1
			--ON STOCK.division_id	= T1.DIVISION_ID			
		 --  AND STOCK.STORAGE_ID		= T1.STORAGE_ID
		 --  AND STOCK.PLANT_ID		= T1.PLANT_ID				
		 --  AND STOCK.SCM_SITE_ID	= T1.SCM_SITE_ID
		   --AND T1.LOCATION_CODE IN ('PACK_OWMS', 'CELL_OWMS', 'FORMATION_CHECK_PACKAGING','CMA_BMA', 'AS')

		  INNER JOIN (SELECT DISTINCT DIVISION_ID, ITEM_ID, NICK_NAME																														
				    FROM SCM_MST_ITEM_SN WITH (NOLOCK)																																	
				   WHERE DIVISION_ID =  @p_division_id    																													
					AND ACTIVE_FLAG = 'Y'																																				
					AND SCP_OPERATION_GROUP = 'P'  -- CELL/PACK 구분																													
				  ) IT 																																									
			ON STOCK.DIVISION_ID = IT.DIVISION_ID AND STOCK.ITEM_ID = IT.ITEM_ID	

			LEFT OUTER JOIN SSP_MST_MODEL_USER M WITH(NOLOCK) 
				    ON M.DIVISION_ID = STOCK.DIVISION_ID 
				   AND M.FROM_SITE = STOCK.SCM_SITE_ID 
				   AND M.ITEM_ID = STOCK.ITEM_ID 
				   AND M.VALID_YN = 'Y' 
		 WHERE 1 = 1
		   AND STOCK.DIVISION_ID	= @p_division_id
		   AND STOCK.COMPANY_ID		= @p_company_id
		   AND STOCK.SCM_SITE_ID	= @p_from_site
		   AND STOCK.item_id		= @p_item_id
		   AND STOCK.CUTOFF_DATE	= @v_boh_yyyymmdd
		   AND STOCK.CUTOFF_DATE	>  @v_stock_yyyymmdd -- 현재일 - 3
		   AND STOCK.STOCK_TYPE		= 'INVENTORY'
		   AND STOCK.PLANT_ID		= @v_A010			--'A010'
		   --AND STOCK.STORAGE_ID   IN ('311T', '310T', '5000')
		   AND ((@p_nonChk = 'Y' AND 1 = 1 OR M.USER_ID IN (SELECT CASE WHEN @P_MYMODELCHK = 'Y' THEN @P_USER_ID ELSE 'X' END 
																	 UNION 
																	SELECT CASE WHEN @P_DELEGATEECHK = 'Y' THEN USER_ID ELSE 'X' END 
																	  FROM SSP_MST_DELEGATE WITH(NOLOCK) WHERE VALID_YN = 'Y' AND DELEGATEE_ID = @P_USER_ID GROUP BY USER_ID)
												   OR M.PART_LEADER = CASE WHEN @P_PARTLEADERCHK = 'Y' THEN @P_USER_ID  ELSE 'X' END	
												   OR M.TEAM_LEADER = CASE WHEN @P_TEAMLEADERCHK = 'Y' THEN @P_USER_ID  ELSE 'X' END))
		
		) A
		ORDER BY A.COMPANY_ID,A.DIVISION_ID,A.FROM_SITE,A.PLANT_ID,A.ITEM_ID,A.STOCK_TYPE,A.STORAGE_ID
		
	END
	ELSE
	BEGIN
		SELECT A.* FROM (
		
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
		  FROM [DBO].[SCM_DNM_STOCK_V] STOCK WITH(NOLOCK) --SCM_DNM_STOCK_V
		  LEFT JOIN SCM_MST_SLOC MS WITH(NOLOCK)
				ON STOCK.DIVISION_ID           = MS.DIVISION_ID	
			   AND STOCK.PLANT_ID              = MS.PLANT_ID
			   AND STOCK.STORAGE_ID            = MS.STORAGE_ID
		  --INNER JOIN @MST_LOCATION T1
				--ON STOCK.division_id = T1.DIVISION_ID			
				--AND STOCK.STORAGE_ID = T1.STORAGE_ID
				--AND STOCK.PLANT_ID = T1.PLANT_ID				
				--AND STOCK.scm_site_id = T1.SCM_SITE_ID
			--AND T1.LOCATION_CODE IN ('PACK_OWMS', 'CELL_OWMS', 'FORMATION_CHECK_PACKAGING','CMA_BMA', 'AS')
		  INNER JOIN (SELECT DISTINCT DIVISION_ID, ITEM_ID, NICK_NAME																														
				    FROM SCM_MST_ITEM_SN WITH (NOLOCK)																																	
				   WHERE DIVISION_ID =  @p_division_id    																													
					AND ACTIVE_FLAG = 'Y'																																				
					AND SCP_OPERATION_GROUP = 'P'  -- CELL/PACK 구분																													
				  ) IT 																																									
			ON STOCK.DIVISION_ID = IT.DIVISION_ID AND STOCK.ITEM_ID = IT.ITEM_ID
			
		 LEFT OUTER JOIN SSP_MST_MODEL_USER M WITH(NOLOCK) 
				    ON M.DIVISION_ID = STOCK.DIVISION_ID 
				   AND M.FROM_SITE = STOCK.SCM_SITE_ID 
				   AND M.ITEM_ID = STOCK.ITEM_ID 
				   AND M.VALID_YN = 'Y' 
		  WHERE 1 = 1
		    AND STOCK.DIVISION_ID = @p_division_id
		    AND STOCK.COMPANY_ID = @p_company_id
		    --AND ((@p_from_site IS NULL OR @p_from_site ='') OR STOCK.scm_site_id IN (SELECT token FROM dbo.String_Split(@p_from_site, ',')))
		    AND ((@p_item_id IS NULL OR @p_item_id ='')	OR STOCK.item_id IN (SELECT token FROM dbo.String_Split(@p_item_id, ',')))
		    AND STOCK.CUTOFF_DATE = @v_boh_yyyymmdd	
		    AND STOCK.CUTOFF_DATE >  @v_stock_yyyymmdd -- 현재일 - 3
		    AND STOCK.STOCK_TYPE = 'INVENTORY'
			AND STOCK.PLANT_ID = @v_A010				--'A010'
			-- AND STOCK.STORAGE_ID   IN ('311T', '310T', '5000')

			AND ((@p_nonChk = 'Y' AND 1 = 1 OR M.USER_ID IN (SELECT CASE WHEN @P_MYMODELCHK = 'Y' THEN @P_USER_ID ELSE 'X' END 
																	 UNION 
																	SELECT CASE WHEN @P_DELEGATEECHK = 'Y' THEN USER_ID ELSE 'X' END 
																	  FROM SSP_MST_DELEGATE WITH(NOLOCK) WHERE VALID_YN = 'Y' AND DELEGATEE_ID = @P_USER_ID GROUP BY USER_ID)
												   OR M.PART_LEADER = CASE WHEN @P_PARTLEADERCHK = 'Y' THEN @P_USER_ID  ELSE 'X' END	
												   OR M.TEAM_LEADER = CASE WHEN @P_TEAMLEADERCHK = 'Y' THEN @P_USER_ID  ELSE 'X' END))
	
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
