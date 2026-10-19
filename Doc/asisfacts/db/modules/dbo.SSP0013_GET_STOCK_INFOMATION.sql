
/*
 * Program ID   : SSP0013_GET_STOCK_INFOMATION
 * Description  : Shipment Plan Adjustment
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2018/10/19   ygkim			Initial Release [PJ20182279] 전지본부 출하계획 시스템 구축 프로젝트
 * 2018/11/27	hwyoon			division, plant id 항목추가

 ex) 
 */

CREATE PROCEDURE [dbo].[SSP0013_GET_STOCK_INFOMATION]
	 @p_division_id			NVARCHAR(MAX)
	,@p_item_id				NVARCHAR(MAX)
AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	
	--Stock Infomation
	SELECT a.DIVISION_ID
		  ,a.PLANT_ID
		  ,concat(a.storage_id ,' ',storage_description)  STORAGE_ID
		  ,a.item_id
	      ,dbo.fn_get_item_nickname((case when a.division_id = 'EE' then a.origin_from_division_id else a.division_id end), a.item_id ) AS nick_name
		  ,a.STOCK_STATUS
		  ,a.grade
		  ,a.capacity_grade CAPA_GRADE
		  ,a.soc
		  ,sum(a.STOCK_QTY) STOCK_QTY
		  ,sum(a.AVAILABLE_QTY) AVAILABLE_QTY
		  ,sum(a.NON_QC_QTY) UNDECIDED_QTY
		  ,sum(a.ALLOCATION_QTY) ALLOCATION_QTY
		  ,sum(a.BLOCK_QTY) HOLD_QTY
		  ,sum(a.PACKING_QTY) PACKING_QTY
		  ,sum(a.MOVING_QTY) MOVING_QTY
		  ,sum(a.RCVLOC_QTY) RECEIVING_QTY
		  ,sum(a.EXPIRATION_QTY) EXPIRATION_QTY
		  ,sum(a.LONG_QTY) LONG_TERM_QTY
	FROM SSP_DNM_OWMS_STOCK a WITH(NOLOCK)
	LEFT OUTER JOIN SCM_MST_SLOC b WITH(NOLOCK) on b.division_id = (case when a.division_id = 'EE' then a.ORIGIN_FROM_DIVISION_ID else a.DIVISION_ID end) and b.STORAGE_ID = a.STORAGE_ID and b.PLANT_ID = a.PLANT_ID
	WHERE a.DIVISION_ID = @p_division_id
	  AND ( ( @p_item_id   IS NULL OR @p_item_id ='')  OR a.item_id IN (SELECT token FROM dbo.String_Split(@p_item_id,',')) )
	GROUP BY a.item_id
	      ,dbo.fn_get_item_nickname((case when a.division_id = 'EE' then a.origin_from_division_id else a.division_id end), a.item_id )
		  ,a.STOCK_STATUS
		  ,a.grade
		  ,a.capacity_grade
		  ,a.soc
		  ,a.PLANT_ID
		  ,a.division_id
		  ,a.storage_id
		  ,b.storage_description
	ORDER BY
			a.DIVISION_ID
		    ,a.PLANT_ID 
			,a.storage_id
			,a.item_id
	        ,a.grade
		    ,a.capacity_grade
		    ,a.soc;
	
	--Stock Infomation Detail
	SELECT a.division_id
	      ,a.item_id
	      ,dbo.fn_get_item_nickname((case when a.division_id = 'EE' then a.origin_from_division_id else a.division_id end), a.item_id ) AS nick_name
		  ,a.grade
		  ,a.capacity_grade CAPA_GRADE
		  ,a.soc
		  ,a.LOT_ID
		  ,a.PALLET_ID
		  ,a.STOCK_QTY
		  ,a.AVAILABLE_QTY
		  ,a.NON_QC_QTY UNDECIDED_QTY
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
		  ,convert(nvarchar, convert(datetime,a.LOT_DATE,112), 23)  LOT_ISSUE_DATE
	FROM SSP_DNM_OWMS_STOCK a WITH(NOLOCK)
	LEFT OUTER JOIN SCM_MST_SLOC b WITH(NOLOCK) on b.division_id = (case when a.division_id = 'EE' then a.ORIGIN_FROM_DIVISION_ID else a.DIVISION_ID end) and b.STORAGE_ID = a.STORAGE_ID and b.PLANT_ID = a.PLANT_ID
	WHERE a.DIVISION_ID = @p_division_id
	  AND ( ( @p_item_id   IS NULL OR @p_item_id ='')  OR a.item_id IN (SELECT token FROM dbo.String_Split(@p_item_id,',')) )
	ORDER BY a.division_id
	       , a.PLANT_ID
		   , a.storage_id
		   , a.item_id
	       ,a.grade
		  ,a.capacity_grade
		  ,a.soc
		  ,a.LOT_ID
		  ,a.PALLET_ID

	SELECT MIN(a.CREATION_DATE) CREATION_DATE
	FROM SSP_ANL_OWMS_STOCK a WITH(NOLOCK)
	WHERE a.DIVISION_ID = @p_division_id
	  AND ( ( @p_item_id   IS NULL OR @p_item_id ='')  OR a.item_id IN (SELECT token FROM dbo.String_Split(@p_item_id,',')) )
END
