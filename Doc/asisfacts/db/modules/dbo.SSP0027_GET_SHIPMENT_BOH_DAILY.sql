/*
 * Program ID   : SSP0027_GET_SHIPMENT_BOH_DAILY
 * Description  : 
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2021.06.29   KIMYONGHO		최초작성
 *	
 */
CREATE PROCEDURE [dbo].[SSP0027_GET_SHIPMENT_BOH_DAILY]
	 @p_plan_start_yyyymmdd	NVARCHAR(MAX)
	,@p_division_id			NVARCHAR(MAX)
	,@p_storage_id			NVARCHAR(MAX)
	,@p_real_flag			NVARCHAR(MAX)
	,@p_from_yyyymmdd		NVARCHAR(MAX)
	,@p_to_yyyymmdd			NVARCHAR(MAX)
	,@p_item_id				NVARCHAR(MAX)
	,@p_company_id			NVARCHAR(MAX)

AS  
  
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;	

	DECLARE @mDQry NVARCHAR(MAX)='';
	--DECLARE  @v_from_site		NVARCHAR(MAX)='KR012031-P';
	DECLARE  @v_item_id			NVARCHAR(MAX)='';
	
	DECLARE @v_boh_yyyymmdd		NVARCHAR(8);
	DECLARE @v_stock_yyyymmdd	NVARCHAR(8);

	SET @v_boh_yyyymmdd = CONVERT(CHAR(8), DATEADD(DD, -1, CONVERT(VARCHAR, @p_plan_start_yyyymmdd, 121)), 112); --FROM -1일
	SET @v_stock_yyyymmdd = CONVERT(CHAR(8), DATEADD(DD, -3, CONVERT(VARCHAR, @p_plan_start_yyyymmdd, 121)), 112); --FROM -3일

	--IN 조건으로 데이터를 가져옴
	--SET @v_from_site = [dbo].FN_GET_IN_STR(@v_from_site);
	SET @v_item_id = [dbo].FN_GET_IN_STR(@p_item_id);
	--select @v_requestor; --SET @v_requestor = [dbo].FN_GET_IN_STR2(@p_requestor);


	BEGIN

		SELECT  
			STOCK.DIVISION_ID
			,STOCK.COMPANY_ID
			,STOCK.cutoff_date AS CUTOFF_DATE 
			,STOCK.SCM_SITE_ID AS FROM_SITE
			,STOCK.PLANT_ID
			,STOCK.ITEM_ID
			--,dbo.fn_get_item_nickname(STOCK.DIVISION_ID, STOCK.ITEM_ID ) AS nick_name
			,T.ITEM_NAME AS nick_name
			,STOCK.STOCK_TYPE
			,STOCK.STORAGE_ID
			,ISNULL(MS.STORAGE_DESCRIPTION, (SELECT TOP 1 STORAGE_DESCRIPTION 
			                                   FROM SCM_MST_SLOC X WITH(NOLOCK) 
											  WHERE X.PLANT_ID = STOCK.PLANT_ID 
											    AND X.STORAGE_ID = STOCK.STORAGE_ID
												and X.VALID_YN = 'Y')
												) AS STORAGE_DESCRIPTION	
			,ISNULL(STOCK.SCM_QTY, 0) AS TOTAL_QTY
			,ISNULL(STOCK.SSP_QTY, 0) AS AVAILABLE_QTY
			,ISNULL(STOCK.DEFECT_QTY,0) AS DEFECT_QTY 
			,ISNULL(STOCK.MOVING_QTY,0) AS MOVING_QTY
			,STOCK.QTY_UOM
			,ISNULL(STOCK.WIPHOLD_YN,'N') AS WIPHOLD_YN
			,STOCK.HOLDING_DATE
			,STOCK.AVAILABLE_DATE
			,STOCK.OUTSOURCING_FLAG
			,STOCK.OUTSOURCING_FACTORY
		FROM SCM_DNM_STOCK_V STOCK WITH(NOLOCK) --SCM_DNM_STOCK_V
		INNER JOIN SCM_MST_ITEM_SN AS T WITH(NOLOCK)		
				ON STOCK.ITEM_ID		= T.ITEM_ID		
				AND STOCK.DIVISION_ID	= T.DIVISION_ID	
				AND T.COMPANY_ID	= @p_company_id
				AND T.ITEM_TYPE		= 'Q'

		INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL X WITH(NOLOCK)		
			ON X.LOOKUP_TYPE = 'ESS_STOCK_STORAGE_ID'
			AND X.SEGMENT1 = STOCK.STORAGE_ID

		LEFT OUTER JOIN SCM_MST_SLOC MS WITH(NOLOCK)
			ON    STOCK.DIVISION_ID           = MS.DIVISION_ID	
			AND   STOCK.PLANT_ID              = MS.PLANT_ID
			AND   STOCK.STORAGE_ID            = MS.STORAGE_ID

		WHERE 1 = 1
		AND STOCK.DIVISION_ID = @p_division_id
		AND STOCK.COMPANY_ID = @p_company_id
		--AND ((@v_from_site IS NULL OR @v_from_site ='') OR STOCK.scm_site_id IN (SELECT token FROM dbo.String_Split(@v_from_site, ',')))
		AND ((@p_item_id IS NULL OR @p_item_id ='')	OR STOCK.item_id IN (SELECT token FROM dbo.String_Split(@p_item_id, ',')))
		AND ((@p_storage_id IS NULL OR @p_storage_id ='')	OR STOCK.STORAGE_ID IN (SELECT token FROM dbo.String_Split(@p_storage_id, ',')))
		AND STOCK.CUTOFF_DATE = @v_boh_yyyymmdd	
		AND STOCK.STOCK_TYPE = 'INVENTORY'
		--AND STOCK.CUTOFF_DATE >  @v_stock_yyyymmdd -- 현재일 - 3
		--ORDER BY STOCK.item_id, STOCK.storage_id ASC

	
	END

	--IF( @debug_mode ='T')
	--BEGIN				
	--	DECLARE @POS INT =1;
	--	DECLARE @LEN INT =LEN(@mDQry);
	--	WHILE @POS <= @LEN
	--		BEGIN
	--			PRINT SUBSTRING(@mDQry,@POS,4000);
	--			SET @POS = @POS+4000;
	--		END;
	--END;
END
