

/*
 * Program ID   : SCP0041_GET_STOCK_OSP
 * Description  : STOCK OSP 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2022/11/14   vadabi3			Initial Release Pack 보류재고 - LGCE_INFDEV.DBO.XIF_QMS_LOT_CONTROL_R
 * 2022/11/16   vadabi3			조회조건 추가 p_inspection_id
 * 2022/11/22   vadabi3			DIR = HOLD 만 조회
                                기간조회 기준 = HOLD_END_DATE => CUTOFF_DATE
 * 2022/11/29   vadabi3			1, ORG_HOLD_END_DATE  컬럼 삭제
                                2, 조회조건 추가 Status (Hold/ Release)
                                3, Hold / Release 모두 조회로 변경
 * 2022/12/05   vadabi3			조회조건 추가) Cutoff Date
 */

CREATE PROCEDURE [dbo].[SCP0041_GET_PACK_HOLD_STOCK]
   @p_division_id        NVARCHAR(30)
  ,@p_plant_site_id		 NVARCHAR(MAX)
  ,@p_item_id            NVARCHAR(MAX)
  ,@p_from_yyyymmdd      NVARCHAR(MAX)
  ,@p_to_yyyymmdd		 NVARCHAR(MAX)
  ,@p_inspection_id		 NVARCHAR(MAX)
  ,@p_status		     NVARCHAR(MAX)
  ,@p_cutoff_from_yyyymmdd     NVARCHAR(MAX)
  ,@p_cutoff_to_yyyymmdd		   NVARCHAR(MAX)
AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

	 --##################################################################
	 -- XIF_QMS_LOT_CONTROL_R
	 --##################################################################
			SELECT 
				  DIVISION_ID
				, SCM_SITE_ID AS SCM_SITE_ID	 								
				, CASE WHEN SCM_SITE_ID != '-' 
				       THEN (select TOP 1 site_description from scm_mst_site where scm_site_id = A.SCM_SITE_ID and division_id = A.division_id)
					   ELSE SCM_SITE_ID
				       END AS SITE_DESCRIPTION
				, CONVERT(DATE, CUTOFF_DATE)	                AS CUTOFF_DATE
				, ITEM_ID										AS PROD_ID
				, dbo.fn_get_item_nickname (NULL, A.ITEM_ID )	AS NICK_NAME
				, ORG_ITEM_ID
				, QTY											AS QTY
				, CONVERT(DATE, RELEASE_DATE)					AS DATE_FINISH_REAL
				, CONVERT(DATE, HOLD_START_DATE)				AS DATE_FORECAST_START
				, CONVERT(DATE, HOLD_END_DATE)					AS DATE_FORECAST_FINISH
			  --, ORG_HOLD_END_DATE -- 20221129 컬럼 삭제
				, CHANGE_REQUEST_USER
				, [dbo].[FN_GET_USER_NAME](CHANGE_REQUEST_USER)  AS REQUSET_USER
				, DIR
				, LOT_ID
				, PLANT_ID
				, SHOP_ID
				, LINE_ID
				, APPLY_PSN_ID
				, APPLY_DATE
				, INSPECTION_ID
				, NOTE
				, INSP_LCLASS_CODE
				, INSP_MCLASS_CODE
				, RISK_RANGE_FLAG
				, CREATED_BY
				, CREATION_DATE
				, LAST_UPDATED_BY
				, LAST_UPDATE_DATE
				, ATTRIBUTE1
				, ATTRIBUTE2
				, ATTRIBUTE3
				, ATTRIBUTE4
				, ATTRIBUTE5
				, ATTRIBUTE6
				, ATTRIBUTE7
				, ATTRIBUTE8
				, ATTRIBUTE9
				, ATTRIBUTE10
				, CASE WHEN CREATED_BY != LAST_UPDATED_BY 
				       THEN [dbo].[FN_GET_USER_NAME](LAST_UPDATED_BY) 
					   ELSE NULL
				       END AS MODIFIER
				, CASE WHEN CREATED_BY != LAST_UPDATED_BY 
				       THEN LAST_UPDATE_DATE
					   ELSE NULL
				       END AS MODIFIER_DATE
			FROM SCM_DNM_STOCK_LOT_CONTROL A
			WHERE 1 =1 
	      --AND DIR = 'HOLD' -- 20221129 Hold / Release 모두 조회로 변경
			AND (isnull(@p_division_id, '' )			= '' OR A.division_id   IN ( SELECT token FROM dbo.String_Split(@p_division_id	 ,',')) )
			AND (isnull(@p_plant_site_id, '' )			= '' OR A.SCM_SITE_ID   IN ( SELECT token FROM dbo.String_Split(@p_plant_site_id	 ,',')) )
			AND (isnull(@p_item_id,       '' )			= '' OR A.ITEM_ID       IN ( SELECT token FROM dbo.String_Split(@p_item_id	 ,',')) )
			AND (isnull(@p_inspection_id,       '' )	= '' OR A.INSPECTION_ID IN ( SELECT token FROM dbo.String_Split(@p_inspection_id	 ,',')) )
			AND (isnull(@p_status,       'ALL' )	    = '' OR A.DIR IN ( SELECT token FROM dbo.String_Split(@p_status	 ,',')) )
			AND (
					( A.HOLD_START_DATE >= @p_from_yyyymmdd AND A.HOLD_START_DATE <= @p_to_yyyymmdd ) 
					OR
					( A.HOLD_END_DATE   >= @p_from_yyyymmdd AND A.HOLD_END_DATE   <= @p_to_yyyymmdd ) 
			    )
			AND A.CUTOFF_DATE >= @p_cutoff_from_yyyymmdd AND A.CUTOFF_DATE <= @p_cutoff_to_yyyymmdd
			ORDER BY INSPECTION_ID, CUTOFF_DATE,  DIR, PLANT_ID, ITEM_ID

	 /*
	 --##################################################################
	 -- XIF_QMS_LOT_CONTROL_R
	 --##################################################################
	  WITH P_LIST AS
	  (
	  SELECT DISTINCT 
	         PLANT_ID
	       , SITE_DESCRIPTION
		FROM SCM_MST_SITE  P WITH(NOLOCK)
	   WHERE 1 = 1
		 AND SITE_TYPE = 'PLANT'
		 AND VALID_YN  = 'Y'
	  )
	  */

END

