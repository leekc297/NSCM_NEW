

/*
 * Program ID   : SCP0051_GET_PRODUCTION_PLAN_TARGET
 * Description  : PRODUCTION PLAN TARTGET
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2020/09/24   khj79          [PJ20199555] 공급 대응력 향상을 위한 자재재공 수급 점검 체계 개선 - 최초작성
 * 2022.05.13   LSC            PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 : GM JV 추가
 * 2023/04/10   LWY			   PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행 - DIVISION_ID 공통화 작업(div_commonization)
 * 2023/06/17   vadabi3		   PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행 - 활성화코드) 제약조건 추가 (국내 CA)
*/

CREATE PROCEDURE [dbo].[SCP0051_GET_PRODUCTION_PLAN_TARGET]
	 @p_division_id			NVARCHAR(20)
	,@p_scm_site_id			NVARCHAR(MAX)
	,@p_line_id				NVARCHAR(MAX)
	,@p_item_id				NVARCHAR(MAX)
	,@p_from_yyyymmdd		NVARCHAR(MAX)
	,@p_to_yyyymmdd			NVARCHAR(MAX)
	,@p_program_id			NVARCHAR(MAX)
	,@p_sheet_name			NVARCHAR(MAX)
	,@p_user_id				NVARCHAR(MAX)
	,@p_nick_name			NVARCHAR(MAX)
	,@debug_mode			NVARCHAR(1) = 'F'

AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	SELECT A.TARGET_ID
		 , CONVERT(DATETIME,A.PROD_DATE,23) AS PROD_DATE
		 , A.DIVISION_ID
		 , A.ORIGIN_DIVISION_ID
		 , A.ITEM_ID
		 , FI.NICK_NAME		AS NICK_NAME
 		 , A.PLANT_SCM_SITE_ID
		 , A.LINE_ID
		 , A.OPERATION_ID
		 , A.ORDER_TYPE
		 , A.MARKET
		 , A.QTY			AS PLANT_QTY
		 , A.REASON
		 , A.REASON_DETAIL
		 , A.REQUEST_USER_ID
		 , A.CHARGE_USER_ID
		 , A.CONFIRM_USER_ID
		 , A.CONFIRM_YN
		 , A.TARGET_YN
		 , A.INPUT_DATE
		 , A.CONFIRM_DATE
		 , CASE WHEN SUBSTRING(a.ITEM_ID,1,2) IN ('AC','EC') THEN 'CP'  -- Cell Product
				WHEN SUBSTRING(a.ITEM_ID,1,2) IN ('AA','EA') THEN 'CA1'  -- Cell Assy
				ELSE ''  
			  END AS CELL_TYPE
		, null AS COUNTRY
		,  (
		   SELECT max(country) FROM  [dbo].[SCM_MST_SITE]   WITH(NOLOCK)  
            WHERE  1 = 1  
		      AND  VALID_YN ='Y'  
		      AND  SITE_TYPE = 'PLANT'
			  AND  SCM_SITE_ID = A.PLANT_SCM_SITE_ID
		  ) AS  COUNTRY2
	  FROM SCP_ANL_PRODUCTION_PLAN_TARGET A WITH(NOLOCK)
	  JOIN SCP_MST_FINAL_ITEM FI WITH(NOLOCK)
	    --ON (CASE WHEN @p_division_id IN ('EE','EE_UC') THEN A.ORIGIN_DIVISION_ID ELSE A.DIVISION_ID END) 	= FI.DIVISION_ID
		ON (CASE WHEN @p_division_id IN (SELECT DIVISION_ID FROM dbo.FN_GET_DIVISION_DIV('EE')) THEN A.ORIGIN_DIVISION_ID ELSE A.DIVISION_ID END) 	= FI.DIVISION_ID --div_commonization
	   AND A.ITEM_ID		= FI.ITEM_ID
	 WHERE 1 = 1
	   AND A.PROD_DATE >= @p_from_yyyymmdd
	   AND A.PROD_DATE <= @p_to_yyyymmdd
	   AND (( @p_division_id		IS NULL OR  @p_division_id		= '' ) OR A.DIVISION_ID			= @p_division_id	)
	   AND (( @p_scm_site_id		IS NULL OR  @p_scm_site_id		= '' ) OR A.PLANT_SCM_SITE_ID	IN (SELECT token FROM dbo.String_Split(@p_scm_site_id		,',')))
	   AND (( @p_line_id			IS NULL OR  @p_line_id			= '' ) OR A.LINE_ID				IN (SELECT token FROM dbo.String_Split(@p_line_id			,',')))
	   AND (( @p_item_id			IS NULL OR  @p_item_id			= '' ) OR A.ITEM_ID		LIKE '%' + @p_item_id	+'%')
	   AND (( @p_nick_name			IS NULL OR  @p_nick_name		= '' ) OR FI.NICK_NAME	LIKE '%' + @p_nick_name	+'%')
	 ORDER BY CONFIRM_YN ,  CONFIRM_DATE DESC ,INPUT_DATE DESC

END
  
