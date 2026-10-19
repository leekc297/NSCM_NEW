



/*
 * Program ID   : SSP0021_GET_HOLD_STOCK
 * Description  : 자동차 Shipment Plan
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2019/03/05   AYJ 			Initial Release [PJ20189106] 전지.GSCM 고도화 이행 PROJECT
 * 2019/06/17	AYJ				조회 조건 추가(p_partLeaderChk, p_teamLeaderChk)
 * 2019/08/28	AYJ			    조회 조건 추가(p_delegateeChk)
 ex) 
 */


 CREATE PROCEDURE [dbo].[SSP0021_GET_HOLD_STOCK]
	 @p_division_id				NVARCHAR(MAX)
	,@p_from_site				NVARCHAR(MAX)
	,@p_item_id					NVARCHAR(MAX)
	,@p_plan_start_yyyymmdd		NVARCHAR(MAX)
	,@p_plan_type				NVARCHAR(MAX)
	,@p_seq						NVARCHAR(MAX)
	,@p_language				NVARCHAR(MAX) = 'KO'
	,@p_search_yn				NVARCHAR(MAX)
	,@p_user_id					NVARCHAR(MAX)
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
	--BLOCK_STOCK
	IF @p_search_yn = 'Y'
	BEGIN
		SELECT a.HOLD_ID
			  ,a.DIVISION_ID
			  ,a.FROM_SITE
			  ,isnull(dbo.fn_get_scm_site_description(a.division_id, a.from_site ),'-') as from_site_nm
			  ,a.item_id
			  ,dbo.fn_get_item_nickname((case when a.division_id = 'EE' then a.origin_from_division_id else a.division_id end), a.item_id ) as nick_name
			  ,CONVERT(NVARCHAR(10),dbo.fn_char_to_date(a.HOLD_YYYYMMDD),121) AS HOLD_YYYYMMDD
			  ,CONVERT(NVARCHAR(10),dbo.fn_char_to_date(a.RELEASE_YYYYMMDD),121) AS RELEASE_YYYYMMDD
			  ,a.HOLD_QTY
			  ,a.REMARKS
			  ,CASE WHEN @p_language = 'KO' THEN U.UserName ELSE U.UserName_E END + '(' + a.LAST_UPDATED_BY + ')' as LAST_UPDATED_BY
			  --,convert(nvarchar, convert(datetime,a.LAST_UPDATE_DATE,112), 23)  LAST_UPDATE_DATE
			  ,a.LAST_UPDATE_DATE
		FROM SSP_ANL_HOLD_STOCK a WITH(NOLOCK)
		LEFT OUTER JOIN TB_FX_User U WITH(NOLOCK) ON a.LAST_UPDATED_BY = u.UserID AND U.UseYN = 'Y'
		LEFT OUTER JOIN SSP_MST_MODEL_USER M WITH(NOLOCK) 
		          ON  M.division_id = a.division_id 
					and M.from_site = a.from_site 
					and M.item_id = a.item_id 
					and M.valid_yn = 'Y' 
		WHERE a.DIVISION_ID = @p_division_id
		  AND a.FROM_SITE = @p_from_site
		  AND a.HOLD_YYYYMMDD <= convert(varchar(8), convert(datetime, @p_plan_start_yyyymmdd), 112)
		  AND a.RELEASE_YYYYMMDD >= convert(varchar(8), convert(datetime, @p_plan_start_yyyymmdd), 112)
		  AND a.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
		  AND a.PLAN_TYPE = @p_plan_type
		  AND a.SEQ = @p_seq
		  AND a.item_id = @p_item_id
		GROUP BY a.HOLD_ID 
			  ,a.item_id
			  ,dbo.fn_get_item_nickname((case when a.division_id = 'EE' then a.origin_from_division_id else a.division_id end), a.item_id )
			  ,a.division_id
			  ,a.FROM_SITE
			  ,isnull(dbo.fn_get_scm_site_description(a.division_id, a.from_site ),'-')
			  ,a.HOLD_YYYYMMDD 
			  ,a.RELEASE_YYYYMMDD
			  ,a.HOLD_QTY
			  ,a.REMARKS
			  ,a.LAST_UPDATE_DATE
			  ,CASE WHEN @p_language = 'KO' THEN U.UserName ELSE U.UserName_E END + '(' + a.LAST_UPDATED_BY + ')' 
		ORDER BY
				a.HOLD_ID
	END
	--2. btnSearch
	ELSE
	BEGIN
		SELECT a.HOLD_ID
			  ,a.DIVISION_ID
			  ,a.FROM_SITE
			  ,isnull(dbo.fn_get_scm_site_description(a.division_id, a.from_site ),'-') as from_site_nm
			  ,a.item_id
			  ,dbo.fn_get_item_nickname((case when a.division_id = 'EE' then a.origin_from_division_id else a.division_id end), a.item_id ) as nick_name
			  ,CONVERT(NVARCHAR(10),dbo.fn_char_to_date(a.HOLD_YYYYMMDD),121) AS HOLD_YYYYMMDD
			  ,CONVERT(NVARCHAR(10),dbo.fn_char_to_date(a.RELEASE_YYYYMMDD),121) AS RELEASE_YYYYMMDD
			  ,a.HOLD_QTY
			  ,a.REMARKS
			  ,CASE WHEN @p_language = 'KO' THEN U.UserName ELSE U.UserName_E END + '(' + a.LAST_UPDATED_BY + ')' as LAST_UPDATED_BY
			  --,convert(nvarchar, convert(datetime,a.LAST_UPDATE_DATE,112), 23)  LAST_UPDATE_DATE
			  ,a.LAST_UPDATE_DATE
		FROM SSP_ANL_HOLD_STOCK a WITH(NOLOCK)
		LEFT OUTER JOIN TB_FX_User U WITH(NOLOCK) ON a.LAST_UPDATED_BY = u.UserID AND U.UseYN = 'Y'
		LEFT OUTER JOIN SSP_MST_MODEL_USER M WITH(NOLOCK) 
		          ON  M.division_id = a.division_id 
					and M.from_site = a.from_site 
					and M.item_id = a.item_id 
					and M.valid_yn = 'Y' 
		WHERE a.DIVISION_ID = @p_division_id
		  AND ( ( @p_from_site   IS NULL OR @p_from_site ='')  OR a.from_site IN (SELECT token FROM dbo.String_Split(@p_from_site,',')) )
		  AND a.HOLD_YYYYMMDD <= convert(varchar(8), convert(datetime, @p_plan_start_yyyymmdd), 112)
		  AND a.RELEASE_YYYYMMDD >= convert(varchar(8), convert(datetime, @p_plan_start_yyyymmdd), 112)
		  AND a.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
		  AND a.PLAN_TYPE = @p_plan_type
		  AND a.SEQ = @p_seq
		  AND ( ( @p_item_id   IS NULL OR @p_item_id ='')  OR a.item_id IN (SELECT token FROM dbo.String_Split(@p_item_id,',')) )
		GROUP BY a.HOLD_ID 
			  ,a.item_id
			  ,dbo.fn_get_item_nickname((case when a.division_id = 'EE' then a.origin_from_division_id else a.division_id end), a.item_id )
			  ,a.division_id
			  ,a.FROM_SITE
			  ,isnull(dbo.fn_get_scm_site_description(a.division_id, a.from_site ),'-')
			  ,a.HOLD_YYYYMMDD 
			  ,a.RELEASE_YYYYMMDD
			  ,a.HOLD_QTY
			  ,a.REMARKS
			  ,a.LAST_UPDATE_DATE
			  ,CASE WHEN @p_language = 'KO' THEN U.UserName ELSE U.UserName_E END + '(' + a.LAST_UPDATED_BY + ')' 
		ORDER BY
				a.HOLD_ID
	END

END



