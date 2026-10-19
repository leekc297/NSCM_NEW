
/*
 * Program ID   : SSP0015_GET_WH_STOCK
 * Description  : Shipment PSI(Small)
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2019/09/10   mcTheJ			Initial Release [PJ20189106] 전지.GSCM 고도화 이행 PROJECT
 * 2022.04.23   SSP Pjt.        C20220419-000607 / SSP~oWMS 사외창고 재고 I/F개선 요청
 * 2026.09.10	강주용			[E20260910-001263] Shipment Plan(Auto & ESS) 화면 하단 oWMS Detail 확인 요청
 ex) 
 */

CREATE PROCEDURE [dbo].[SSP0021_GET_OWMS_DETAIL]
	@p_division_id			NVARCHAR(MAX)
	,@p_company_id			NVARCHAR(100)
	,@p_from_site			NVARCHAR(MAX)
	,@p_item_id				NVARCHAR(MAX)
	,@p_plan_start_yyyymmdd	NVARCHAR(8)
	,@p_dbl_flag			CHAR(1)
	,@p_language            NVARCHAR(MAX) = 'KO'
	,@p_program_id			NVARCHAR(MAX) = 'SSP0021' 
	,@p_sheet_name			NVARCHAR(MAX) = 'oWMS Detail'
	,@debug_mode			CHAR(1) = 'T'
AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE  @v_from_site		NVARCHAR(MAX)='';
	DECLARE  @v_item_id NVARCHAR(MAX)='';
	
	DECLARE @v_boh_yyyymmdd		NVARCHAR(8);
	DECLARE @v_stock_yyyymmdd	NVARCHAR(8);

	--IN 조건으로 데이터를 가져옴
	SET @v_from_site = [dbo].FN_GET_IN_STR(@p_from_site);
	SET @v_item_id = [dbo].FN_GET_IN_STR(@p_item_id);
	
	SET @v_boh_yyyymmdd = CONVERT(CHAR(8), DATEADD(DD, -1, CONVERT(VARCHAR, @p_plan_start_yyyymmdd, 121)), 112); --FROM -1일
	SET @v_stock_yyyymmdd = CONVERT(CHAR(8), DATEADD(DD, -3, CONVERT(VARCHAR, @p_plan_start_yyyymmdd, 121)), 112); --FROM -3일

	--더블클릭
	--W/H Stock Detail
	IF @p_dbl_flag = 'Y'
	BEGIN
		SELECT 
			* 
		FROM
		(	
			SELECT 
				a.division_id
				,a.item_id
				,dbo.fn_get_item_nickname((case when a.division_id = 'EE' then a.origin_from_division_id else a.division_id end), a.item_id ) AS nick_name
				,a.grade
				,a.capacity_grade CAPA_GRADE
				,a.soc
				,a.LOT_ID
				,a.PALLET_ID
				,a.STOCK_QTY
				,a.AVAILABLE_QTY
				,a.NON_QC_QTY AS UNDECIDED_QTY
				,a.ALLOCATION_QTY
				,a.BLOCK_QTY Hold_Qty
				,a.PACKING_QTY
				,a.MOVING_QTY
				,a.RCVLOC_QTY RECEIVING_QTY
				,a.EXPIRATION_QTY
				,a.LONG_QTY LONG_TERM_QTY
				,a.PLANT_ID
				,a.PACKING_STATUS
				,a.STOCK_STATUS
				,concat(a.storage_id ,' ',storage_description)  STORAGE_ID
				,a.CUSTOMER_CODE
				,a.CUSTOMER_NAME
				-- START [E20260910-001263] Shipment Plan(Auto & ESS) 화면 하단 oWMS Detail 확인 요청
				--원본,convert(nvarchar, convert(datetime,a.LOT_DATE,112), 23)  LOT_ISSUE_DATE
				,case when isdate(a.LOT_DATE) = 1 then convert(nvarchar, convert(datetime,a.LOT_DATE,112), 23) else a.LOT_DATE end AS LOT_ISSUE_DATE
				-- END [E20260910-001263] Shipment Plan(Auto & ESS) 화면 하단 oWMS Detail 확인 요청
			FROM SSP_ANL_OWMS_STOCK_C2 a WITH(NOLOCK)
				  JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)  
			   ON L.LOOKUP_TYPE = 'OWMS_STOCK_STATUS'				--C20220419-000607
			  AND L.VALID_YN = 'Y'
			  AND L.ATTRIBUTE1 = 'Y'
			  AND L.SEGMENT1    = A.STOCK_STATUS

			LEFT OUTER JOIN SCM_MST_SLOC b WITH(NOLOCK)
				on b.division_id = (case when a.division_id = 'EE' then a.ORIGIN_FROM_DIVISION_ID else a.DIVISION_ID end) and b.STORAGE_ID = a.STORAGE_ID and b.PLANT_ID = a.PLANT_ID
			LEFT OUTER JOIN SSP_MST_MODEL_USER M WITH(NOLOCK) 
				ON  M.division_id = a.division_id 
				and M.from_site = a.from_site 
				and M.item_id = a.item_id 
				and M.valid_yn = 'Y' 
			WHERE a.division_id = @p_division_id
			ANd a.COMPANY_ID = @p_company_id
			AND a.CUTOFF_DATE = @v_boh_yyyymmdd
			AND a.from_site = @p_from_site
			AND a.item_id = @p_item_id
		) a
		ORDER BY a.division_id, a.PLANT_ID, a.storage_id, a.item_id, a.grade, a.capa_grade, a.soc, a.LOT_ID, a.PALLET_ID
	END
	--2. btnSearch
	ELSE
	BEGIN
		SELECT 
			* 
		FROM
		(	
			SELECT 
				a.division_id
				,a.item_id
				,dbo.fn_get_item_nickname((case when a.division_id = 'EE' then a.origin_from_division_id else a.division_id end), a.item_id ) AS nick_name
				,a.grade
				,a.capacity_grade CAPA_GRADE
				,a.soc
				,a.LOT_ID
				,a.PALLET_ID
				,a.STOCK_QTY
				,a.AVAILABLE_QTY
				,a.NON_QC_QTY AS UNDECIDED_QTY
				,a.ALLOCATION_QTY
				,a.BLOCK_QTY Hold_Qty
				,a.PACKING_QTY
				,a.MOVING_QTY
				,a.RCVLOC_QTY RECEIVING_QTY
				,a.EXPIRATION_QTY
				,a.LONG_QTY LONG_TERM_QTY
				,a.PLANT_ID
				,a.PACKING_STATUS
				,a.STOCK_STATUS
				,concat(a.storage_id ,' ',storage_description)  STORAGE_ID
				,a.CUSTOMER_CODE
				,a.CUSTOMER_NAME
				-- START [E20260910-001263] Shipment Plan(Auto & ESS) 화면 하단 oWMS Detail 확인 요청
				--원본,convert(nvarchar, convert(datetime,a.LOT_DATE,112), 23)  LOT_ISSUE_DATE
				,case when isdate(a.LOT_DATE) = 1 then convert(nvarchar, convert(datetime,a.LOT_DATE,112), 23) else a.LOT_DATE end AS LOT_ISSUE_DATE
				-- END [E20260910-001263] Shipment Plan(Auto & ESS) 화면 하단 oWMS Detail 확인 요청
			FROM SSP_ANL_OWMS_STOCK_C2 a WITH(NOLOCK)
				 JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)  
			   ON L.LOOKUP_TYPE = 'OWMS_STOCK_STATUS'				--C20220419-000607
			  AND L.VALID_YN = 'Y'
			  AND L.ATTRIBUTE1 = 'Y'
			  AND L.SEGMENT1    = A.STOCK_STATUS

			LEFT OUTER JOIN SCM_MST_SLOC b WITH(NOLOCK)
				on b.division_id = (case when a.division_id = 'EE' then a.ORIGIN_FROM_DIVISION_ID else a.DIVISION_ID end) and b.STORAGE_ID = a.STORAGE_ID and b.PLANT_ID = a.PLANT_ID
			LEFT OUTER JOIN SSP_MST_MODEL_USER M WITH(NOLOCK) 
				ON  M.division_id = a.division_id 
				and M.from_site = a.from_site 
				and M.item_id = a.item_id 
				and M.valid_yn = 'Y' 
			WHERE a.division_id = @p_division_id
			AND a.CUTOFF_DATE = @v_boh_yyyymmdd
			AND ( ( @p_from_site   IS NULL OR @p_from_site ='')  OR a.from_site IN (SELECT token FROM dbo.String_Split(@p_from_site,',')) )
			AND ( ( @p_item_id   IS NULL OR @p_item_id ='')  OR a.item_id IN (SELECT token FROM dbo.String_Split(@p_item_id,',')) )
		) a
		ORDER BY a.division_id, a.PLANT_ID, a.storage_id, a.item_id, a.grade, a.capa_grade, a.soc, a.LOT_ID, a.PALLET_ID
	END
END




