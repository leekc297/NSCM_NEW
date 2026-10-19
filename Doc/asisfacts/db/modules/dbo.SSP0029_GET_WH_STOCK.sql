
/*
 * Program ID   : SSP0029_GET_WH_STOCK
 * Description  : Shipment PSI(Small)
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2022.09.01   SSP Pjt. 	    Created.
 *
 ex) 
 */

CREATE PROCEDURE [dbo].[SSP0029_GET_WH_STOCK]
	 @p_division_id			NVARCHAR(MAX)
	,@p_item_id				NVARCHAR(MAX)
	,@p_plan_start_yyyymmdd	NVARCHAR(MAX)
	,@p_plan_type			NVARCHAR(MAX)
	,@p_plan_seq			NVARCHAR(MAX)
	,@p_from_site			NVARCHAR(MAX)
	,@p_user_id				NVARCHAR(MAX)
	,@p_myModelChk			NVARCHAR(MAX) = 'N'
	,@p_partLeaderChk		NVARCHAR(MAX)
	,@p_teamLeaderChk		NVARCHAR(MAX)
	,@p_search_yn			NVARCHAR(MAX)
	,@p_nonChk				NVARCHAR(MAX)
	,@p_delegateeChk		NVARCHAR(MAX)

AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE  @v_division_id NVARCHAR(MAX)='';
	DECLARE  @v_item_id NVARCHAR(MAX)='';

	--IN 조건으로 데이터를 가져옴
	SET @v_division_id = [dbo].FN_GET_IN_STR(@p_division_id);
	SET @v_item_id = [dbo].FN_GET_IN_STR(@p_item_id);
		
	--1. 셀 더블클릭
	--W/H Stock
	IF @p_search_yn != 'Y'
	BEGIN
		SELECT a.division_id
			 , a.plant_id
			 , concat(a.storage_id ,' ',storage_description)  STORAGE_ID
			 , a.item_id
			 , dbo.fn_get_item_nickname((case when a.division_id = 'EE' then a.origin_from_division_id else a.division_id end), a.item_id ) AS nick_name
			 , a.stock_status
			 , a.grade
			 , a.capacity_grade CAPA_GRADE
			 , a.soc
			 , sum(a.STOCK_QTY) STOCK_QTY
			 , sum(a.AVAILABLE_QTY) AVAILABLE_QTY
			 , sum(a.NON_QC_QTY) UNDECIDED_QTY
			 , sum(a.ALLOCATION_QTY) ALLOCATION_QTY
			 , sum(a.BLOCK_QTY) HOLD_QTY
			 , sum(a.PACKING_QTY) PACKING_QTY
			 , sum(a.MOVING_QTY) MOVING_QTY
			 , sum(a.RCVLOC_QTY) RECEIVING_QTY
			 , sum(a.EXPIRATION_QTY) EXPIRATION_QTY
			 , sum(a.LONG_QTY) LONG_TERM_QTY
		  FROM SSP_ANL_OWMS_STOCK_C a WITH(NOLOCK)
		       LEFT OUTER JOIN SCM_MST_SLOC b WITH(NOLOCK) 
			on b.division_id = (case when a.division_id = 'EE' then a.ORIGIN_FROM_division_id else a.division_id end) 
		   and b.STORAGE_ID = a.STORAGE_ID 
		   and b.plant_id = a.plant_id
		       LEFT OUTER JOIN SSP_MST_MODEL_USER M WITH(NOLOCK) 
		    ON M.division_id = a.division_id 
		   AND M.from_site = a.from_site 
		   AND M.item_id = a.item_id 
		   AND M.valid_yn = 'Y' 
		 WHERE a.division_id = @p_division_id
		   AND a.plan_start_yyyymmdd = @p_plan_start_yyyymmdd
		   AND a.plan_type = @p_plan_type
		   AND a.seq = @p_plan_seq
		   AND a.from_site = @p_from_site
		   AND a.item_id = @p_item_id

		 GROUP BY a.item_id
			 , dbo.fn_get_item_nickname((case when a.division_id = 'EE' then a.origin_from_division_id else a.division_id end), a.item_id )
			 , a.stock_status
			 , a.grade
			 , a.capacity_grade
			 , a.soc
			 , a.plant_id
			 , a.division_id
			 , a.storage_id
			 , b.storage_description
		 ORDER BY
			   a.division_id
			 , a.plant_id 
			 , a.storage_id
			 , a.item_id
			 , a.grade
			 , a.capacity_grade
			 , a.soc;
	END
	--2. btnSearch
	ELSE
	BEGIN
		SELECT a.division_id
			 , a.plant_id
			 , concat(a.storage_id ,' ',storage_description)  STORAGE_ID
			 , a.item_id
			 , dbo.fn_get_item_nickname((case when a.division_id = 'EE' then a.origin_from_division_id else a.division_id end), a.item_id ) AS nick_name
			 , a.stock_status
			 , a.grade
			 , a.capacity_grade CAPA_GRADE
			 , a.soc
			 , sum(a.STOCK_QTY) STOCK_QTY
			 , sum(a.AVAILABLE_QTY) AVAILABLE_QTY
			 , sum(a.NON_QC_QTY) UNDECIDED_QTY
			 , sum(a.ALLOCATION_QTY) ALLOCATION_QTY
			 , sum(a.BLOCK_QTY) HOLD_QTY
			 , sum(a.PACKING_QTY) PACKING_QTY
			 , sum(a.MOVING_QTY) MOVING_QTY
			 , sum(a.RCVLOC_QTY) RECEIVING_QTY
			 , sum(a.EXPIRATION_QTY) EXPIRATION_QTY
			 , sum(a.LONG_QTY) LONG_TERM_QTY
		  FROM SSP_ANL_OWMS_STOCK_C a WITH(NOLOCK)
			   JOIN SCM_MST_SITE AS FS with(NOLOCK)
			ON a.DIVISION_ID = FS.DIVISION_ID
		   AND a.FROM_SITE = FS.SCM_SITE_ID
		   AND FS.OPERATION_GROUP = 'P'
		   AND FS.OSP_YN = 'N'
		   AND FS.VALID_YN = 'Y'
		       LEFT OUTER JOIN SCM_MST_SLOC b WITH(NOLOCK) on b.division_id = (case when a.division_id = 'EE' then a.ORIGIN_FROM_division_id else a.division_id end) and b.STORAGE_ID = a.STORAGE_ID and b.plant_id = a.plant_id
		       LEFT OUTER JOIN SSP_MST_MODEL_USER M WITH(NOLOCK) 
		    ON M.division_id = a.division_id 
		   AND M.from_site = a.from_site 
		   AND M.item_id = a.item_id 
		   AND M.valid_yn = 'Y' 
		 WHERE a.division_id = @p_division_id
		   AND a.plan_start_yyyymmdd = @p_plan_start_yyyymmdd
		   AND a.plan_type = @p_plan_type
		   AND a.seq = @p_plan_seq
		   AND ( ( @p_from_site   IS NULL OR @p_from_site ='')  OR a.from_site IN (SELECT token FROM dbo.String_Split(@p_from_site,',')) )
		   AND ( ( @p_item_id   IS NULL OR @p_item_id ='')  OR a.item_id IN (SELECT token FROM dbo.String_Split(@p_item_id,',')) )
		   
		   --체크박스 체크 여부 조회 시작(@p_nonChk = 'Y' : 체크박스 선택 안한 상태)
		   --AND ((@p_nonChk = 'Y' AND 1 = 1 OR M.USER_ID = CASE WHEN @p_myModelChk = 'Y' THEN @p_user_id  ELSE 'X' END	
		   AND ((@p_nonChk = 'Y' AND 1 = 1 OR M.USER_ID IN (SELECT CASE WHEN @p_myModelChk = 'Y' THEN @p_user_id ELSE 'X' END 
														     UNION 
														    SELECT CASE WHEN @p_delegateeChk = 'Y' THEN USER_ID ELSE 'X' END 
														      FROM SSP_MST_DELEGATE with(nolock) 
															 WHERE VALID_YN = 'Y' 
															   AND DELEGATEE_ID = @p_user_id 
															 GROUP BY USER_ID)
										   OR M.PART_LEADER = CASE WHEN @p_partLeaderChk = 'Y' THEN @p_user_id  ELSE 'X' END	
										   OR M.TEAM_LEADER = CASE WHEN @p_teamLeaderChk = 'Y' THEN @p_user_id  ELSE 'X' END))
		  --체크박스 체크 여부 조회 끝


		 GROUP BY 
		       a.item_id
			 , dbo.fn_get_item_nickname((case when a.division_id = 'EE' then a.origin_from_division_id else a.division_id end), a.item_id )
			 , a.stock_status
			 , a.grade
			 , a.capacity_grade
			 , a.soc
			 , a.plant_id
			 , a.division_id
			 , a.storage_id
			 , b.storage_description
		 ORDER BY
			   a.division_id
			 , a.plant_id 
			 , a.storage_id
			 , a.item_id
			 , a.grade
			 , a.capacity_grade
			 , a.soc;

	END

--------------------------------------------------------------------------------------------------------------------------------------------------------

	--1. 셀 더블클릭
	--W/H Stock Detail
	IF @p_search_yn != 'Y'
	BEGIN
		SELECT * 
		  FROM (	
			   SELECT 
				      a.division_id
				    , a.item_id
				    , dbo.fn_get_item_nickname((case when a.division_id = 'EE' then a.origin_from_division_id else a.division_id end), a.item_id ) AS nick_name
				    , a.grade
				    , a.capacity_grade CAPA_GRADE
				    , a.soc
				    , a.LOT_ID
				    , a.PALLET_ID
				    , a.STOCK_QTY
				    , a.AVAILABLE_QTY
				    , a.NON_QC_QTY UNDECIDED_QTY
				    , a.ALLOCATION_QTY
				    , a.BLOCK_QTY Hold_Qty
				    , a.PACKING_QTY
				    , a.MOVING_QTY
				    , a.RCVLOC_QTY RECEIVING_QTY
				    , a.EXPIRATION_QTY
				    , a.LONG_QTY LONG_TERM_QTY
				    , a.PLANT_ID
				    , a.PACKING_STATUS
				    , a.STOCK_STATUS
				    , concat(a.storage_id ,' ',storage_description)  STORAGE_ID
				    , a.CUSTOMER_CODE
				    , a.CUSTOMER_NAME
				    , convert(nvarchar, convert(datetime,a.LOT_DATE,112), 23)  LOT_ISSUE_DATE
			     FROM SSP_ANL_OWMS_STOCK_C a WITH(NOLOCK)
			          LEFT OUTER JOIN SCM_MST_SLOC b on b.division_id = (case when a.division_id = 'EE' then a.ORIGIN_FROM_DIVISION_ID else a.DIVISION_ID end) and b.STORAGE_ID = a.STORAGE_ID and b.PLANT_ID = a.PLANT_ID
			          LEFT OUTER JOIN SSP_MST_MODEL_USER M WITH(NOLOCK) 
				   ON M.division_id = a.division_id 
				  AND M.from_site = a.from_site 
				  AND M.item_id = a.item_id 
				  AND M.valid_yn = 'Y' 
			    WHERE a.division_id = @p_division_id
			      AND a.plan_start_yyyymmdd = @p_plan_start_yyyymmdd
			      AND a.plan_type = @p_plan_type
			      AND a.seq = @p_plan_seq
			      AND a.from_site = @p_from_site
			      AND ( ( @p_item_id   IS NULL OR @p_item_id ='')  OR a.item_id IN (SELECT token FROM dbo.String_Split(@p_item_id,',')) )
		       ) a
		ORDER BY a.division_id
			   , a.PLANT_ID
			   , a.storage_id
			   , a.item_id
			   , a.grade
			   , a.capa_grade
			   , a.soc
			   , a.LOT_ID
			   , a.PALLET_ID
	END
	--2. btnSearch
	ELSE
	BEGIN
		SELECT * 
		  FROM (	
			   SELECT 
				      a.division_id
				    , a.item_id
				    , dbo.fn_get_item_nickname((case when a.division_id = 'EE' then a.origin_from_division_id else a.division_id end), a.item_id ) AS nick_name
				    , a.grade
				    , a.capacity_grade CAPA_GRADE
				    , a.soc
				    , a.LOT_ID
				    , a.PALLET_ID
				    , a.STOCK_QTY
				    , a.AVAILABLE_QTY
				    , a.NON_QC_QTY UNDECIDED_QTY
				    , a.ALLOCATION_QTY
				    , a.BLOCK_QTY Hold_Qty
				    , a.PACKING_QTY
				    , a.MOVING_QTY
				    , a.RCVLOC_QTY RECEIVING_QTY
				    , a.EXPIRATION_QTY
				    , a.LONG_QTY LONG_TERM_QTY
				    , a.PLANT_ID
				    , a.PACKING_STATUS
				    , a.STOCK_STATUS
				    , concat(a.storage_id ,' ',storage_description)  STORAGE_ID
				    , a.CUSTOMER_CODE
				    , a.CUSTOMER_NAME
				    , convert(nvarchar, convert(datetime,a.LOT_DATE,112), 23)  LOT_ISSUE_DATE
			     FROM SSP_ANL_OWMS_STOCK_C a WITH(NOLOCK)
					  JOIN SCM_MST_SITE AS FS with(NOLOCK)
			   	   ON a.DIVISION_ID = FS.DIVISION_ID
			      AND a.FROM_SITE = FS.SCM_SITE_ID
			      AND FS.OPERATION_GROUP = 'P'
			      AND FS.OSP_YN = 'N'
			      AND FS.VALID_YN = 'Y'
			          LEFT OUTER JOIN SCM_MST_SLOC b on b.division_id = (case when a.division_id = 'EE' then a.ORIGIN_FROM_DIVISION_ID else a.DIVISION_ID end) and b.STORAGE_ID = a.STORAGE_ID and b.PLANT_ID = a.PLANT_ID
			          LEFT OUTER JOIN SSP_MST_MODEL_USER M WITH(NOLOCK) 
				   ON M.division_id = a.division_id 
				  AND M.from_site = a.from_site 
				  AND M.item_id = a.item_id 
				  AND M.valid_yn = 'Y' 
			    WHERE a.division_id = @p_division_id
			      AND a.plan_start_yyyymmdd = @p_plan_start_yyyymmdd
			      AND a.plan_type = @p_plan_type
			      AND a.seq = @p_plan_seq
			      AND ( ( @p_from_site   IS NULL OR @p_from_site ='')  OR a.from_site IN (SELECT token FROM dbo.String_Split(@p_from_site,',')) )
			      AND ( ( @p_item_id   IS NULL OR @p_item_id ='')  OR a.item_id IN (SELECT token FROM dbo.String_Split(@p_item_id,',')) )
			      
			      --체크박스 체크 여부 조회 시작(@p_nonChk = 'Y' : 체크박스 선택 안한 상태)
			      AND ((@p_nonChk = 'Y' AND 1 = 1 OR M.USER_ID IN (SELECT CASE WHEN @p_myModelChk = 'Y' THEN @p_user_id ELSE 'X' END 
														            UNION 
														           SELECT CASE WHEN @p_delegateeChk = 'Y' THEN USER_ID ELSE 'X' END 
														             FROM SSP_MST_DELEGATE with(nolock) 
																	WHERE VALID_YN = 'Y' 
																	  AND DELEGATEE_ID = @p_user_id 
																	GROUP BY USER_ID)
											      OR M.PART_LEADER = CASE WHEN @p_partLeaderChk = 'Y' THEN @p_user_id  ELSE 'X' END	
											      OR M.TEAM_LEADER = CASE WHEN @p_teamLeaderChk = 'Y' THEN @p_user_id  ELSE 'X' END))
			  --체크박스 체크 여부 조회 끝
		       ) a
		 ORDER BY 
		       a.division_id
			 , a.PLANT_ID
			 , a.storage_id
			 , a.item_id
			 , a.grade
			 , a.capa_grade
			 , a.soc
			 , a.LOT_ID
			 , a.PALLET_ID

	END
END
