

/*
 * Program ID   : SSP0060_GET_MES_STOCK_DETAIL
 * Description  : Shipment PSI(Small)
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2019/09/15   mcTheJ			Initial Release [PJ20189106] 전지.GSCM 고도화 이행 PROJECT
 * 2019/10/28	AYJ				검색조건 추가 : BOXID
 * 2022/02/16   SSP Pjt.        SSP_DNM_MES_STOCK_81_82 -> SSP_DNM_GMES_STOCK_81_82
 * 2023/09/01   jilee           반제품->제품 코드 변환 작업
 * 2024.06.12   hsbang		파라미터 @p_product_level1 추가
 ex) 
 */

CREATE PROCEDURE [dbo].[SSP0060_GET_MES_STOCK_DETAIL]
	@p_division_id			NVARCHAR(MAX)
	,@p_company_id			NVARCHAR(100)
	,@p_from_site			NVARCHAR(MAX)
	,@p_item_id				NVARCHAR(MAX)
	,@p_product_level1		NVARCHAR(MAX)
	,@p_box_id				NVARCHAR(MAX)
	,@p_plan_start_yyyymmdd	NVARCHAR(8)
	,@p_dbl_flag			CHAR(1)
	,@p_language            NVARCHAR(MAX) = 'KO'
	,@p_program_id			NVARCHAR(MAX) = 'SSP0060' 
	,@p_sheet_name			NVARCHAR(MAX) = 'MES Stock Detail'
	,@debug_mode			CHAR(1) = 'T'
AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE  @v_from_site		NVARCHAR(MAX)='';
	DECLARE  @v_item_id			NVARCHAR(MAX)='';
	DECLARE  @v_product_level1	NVARCHAR(MAX)='';
	
	DECLARE @v_boh_yyyymmdd		NVARCHAR(8);
	DECLARE @v_stock_yyyymmdd	NVARCHAR(8);

	--IN 조건으로 데이터를 가져옴
	SET @v_from_site	= [dbo].FN_GET_IN_STR(@p_from_site);
	SET @v_item_id		= [dbo].FN_GET_IN_STR(@p_item_id);
	SET @v_product_level1 = [dbo].FN_GET_IN_STR(@p_product_level1);
	
	SET @v_boh_yyyymmdd = CONVERT(CHAR(8), DATEADD(DD, -1, CONVERT(VARCHAR, @p_plan_start_yyyymmdd, 121)), 112); --FROM -1일
	SET @v_stock_yyyymmdd = CONVERT(CHAR(8), DATEADD(DD, -3, CONVERT(VARCHAR, @p_plan_start_yyyymmdd, 121)), 112); --FROM -3일

	--더블클릭
	--W/H Stock Detail
	IF @p_dbl_flag = 'Y'
	BEGIN
		SELECT
			T0.BOXID,
			-- jilee 0901
			T0.ATTRIBUTE5 as PRODID,
			T0.PRJT_NAME,
			T0.AVAILABLE_YN,
			T0.OQC_INSP_RESULT,
			T0.LOTID,
			ISNULL(T0.LOT_QTY, 0) AS LOT_QTY,
			CASE WHEN T0.PROD_VALID_DATE = '-' OR T0.PROD_VALID_DATE IS NULL THEN NULL ELSE CONVERT(NVARCHAR(10), CONVERT(DATE, T0.PROD_VALID_DATE, 121)) END AS PROD_VALID_DATE,
			CASE WHEN T0.EXP_INSP_VALID_DATE = '-' OR T0.EXP_INSP_VALID_DATE IS NULL THEN NULL ELSE CONVERT(nvarchar(10), CONVERT(DATE, T0.EXP_INSP_VALID_DATE, 121)) END AS EXP_INSP_VALID_DATE,
			T0.MES_HOLD_YN,
			T0.QMS_HOLD_YN,
			CASE WHEN T0.MES_HOLD_RELEASE = '-' OR T0.MES_HOLD_RELEASE IS NULL THEN NULL ELSE CONVERT(NVARCHAR(10), CONVERT(DATE, T0.MES_HOLD_RELEASE, 121)) END AS MES_UNHOLD_SCHD_DATE,
			CASE WHEN T0.QMS_HOLD_RELEASE = '-' OR T0.QMS_HOLD_RELEASE IS NULL THEN NULL ELSE CONVERT(NVARCHAR(10), CONVERT(DATE, T0.QMS_HOLD_RELEASE, 121)) END AS QMS_UNHOLD_SCHD_DATE
		FROM SSP_DNM_GMES_STOCK_81_82 AS T0 with(nolock)
		LEFT OUTER JOIN dbo.SCP_MST_FINAL_ITEM FI WITH(NOLOCK)
			ON FI.DIVISION_ID = T0.DIVISION_ID
			AND FI.ITEM_ID	  = T0.ITEM_ID
		WHERE 1 = 1
		AND T0.DIVISION_ID = @p_division_id
		AND T0.COMPANY_ID = @p_company_id
		AND T0.YYYYMMDD = @p_plan_start_yyyymmdd
		-- jilee 0901
		AND T0.ATTRIBUTE5 = @p_item_id
		AND FI.GROUP_CODE1 = @p_product_level1
		--AND ITEM_ID = @p_item_id
		AND ((@p_from_site IS NULL OR @p_from_site ='') OR T0.FROM_SITE IN (SELECT token FROM dbo.String_Split(@p_from_site, ',')))
	END
	--2. btnSearch
	ELSE
	BEGIN
		SELECT
			T0.BOXID,
			-- jilee 0901
			T0.ATTRIBUTE5 as PRODID,			
			T0.PRJT_NAME,
			T0.AVAILABLE_YN,
			T0.OQC_INSP_RESULT,
			T0.LOTID,
			ISNULL(T0.LOT_QTY, 0) AS LOT_QTY,
			CASE WHEN T0.PROD_VALID_DATE = '-' OR T0.PROD_VALID_DATE IS NULL THEN NULL ELSE CONVERT(NVARCHAR(10), CONVERT(DATE, T0.PROD_VALID_DATE, 121)) END AS PROD_VALID_DATE,
			CASE WHEN T0.EXP_INSP_VALID_DATE = '-' OR T0.EXP_INSP_VALID_DATE IS NULL THEN NULL ELSE CONVERT(nvarchar(10), CONVERT(DATE, T0.EXP_INSP_VALID_DATE, 121)) END AS EXP_INSP_VALID_DATE,
			T0.MES_HOLD_YN,
			T0.QMS_HOLD_YN,
			CASE WHEN T0.MES_HOLD_RELEASE = '-' OR T0.MES_HOLD_RELEASE IS NULL THEN NULL ELSE CONVERT(NVARCHAR(10), CONVERT(DATE, T0.MES_HOLD_RELEASE, 121)) END AS MES_UNHOLD_SCHD_DATE,
			CASE WHEN T0.QMS_HOLD_RELEASE = '-' OR T0.QMS_HOLD_RELEASE IS NULL THEN NULL ELSE CONVERT(NVARCHAR(10), CONVERT(DATE, T0.QMS_HOLD_RELEASE, 121)) END AS QMS_UNHOLD_SCHD_DATE
		FROM SSP_DNM_GMES_STOCK_81_82 AS T0 with(nolock)
		LEFT OUTER JOIN dbo.SCP_MST_FINAL_ITEM FI WITH(NOLOCK)
			ON FI.DIVISION_ID = T0.DIVISION_ID
			AND FI.ITEM_ID	  = T0.ITEM_ID
		WHERE 1 = 1
		AND T0.DIVISION_ID = @p_division_id
		AND T0.COMPANY_ID = @p_company_id
		AND T0.YYYYMMDD = @p_plan_start_yyyymmdd
		AND ((@p_from_site IS NULL OR @p_from_site ='') OR T0.FROM_SITE IN (SELECT token FROM dbo.String_Split(@p_from_site, ',')))
		-- jilee 0901
		AND ((@p_item_id IS NULL OR @p_item_id ='')	OR T0.ATTRIBUTE5 IN (SELECT token FROM dbo.String_Split(@p_item_id, ',')))
		--AND ((@p_item_id IS NULL OR @p_item_id ='')	OR ITEM_ID IN (SELECT token FROM dbo.String_Split(@p_item_id, ',')))
		AND ((@p_product_level1 IS NULL OR @p_product_level1 ='')	OR FI.GROUP_CODE1 IN (SELECT token FROM dbo.String_Split(@p_product_level1, ',')))
		AND ((@p_box_id IS NULL OR @p_box_id ='')	OR T0.BOXID IN (SELECT token FROM dbo.String_Split(@p_box_id, ',')))
	END
END

