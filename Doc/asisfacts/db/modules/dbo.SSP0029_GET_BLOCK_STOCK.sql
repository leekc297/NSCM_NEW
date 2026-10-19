


/*
 * Program ID   : SSP0029_GET_BLOCK_STOCK
 * Description  : Shipment PSI(Small)
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2022.09.01   SSP Pjt. 	    Created.
 *
 */

CREATE PROCEDURE [dbo].[SSP0029_GET_BLOCK_STOCK]
	 @p_division_id				NVARCHAR(MAX)
	,@p_from_site				NVARCHAR(MAX)
	,@p_item_id					NVARCHAR(MAX)
	,@p_plan_start_yyyymmdd		NVARCHAR(MAX)
	,@p_plan_type				NVARCHAR(MAX)
	,@p_seq						NVARCHAR(MAX)
	,@p_language				NVARCHAR(MAX) = 'KO'
	,@p_search_yn				NVARCHAR(MAX)
	,@p_user_id					NVARCHAR(MAX)
	,@p_myModelChk				NVARCHAR(MAX) = 'N'
	,@p_partLeaderChk			NVARCHAR(MAX)
	,@p_teamLeaderChk			NVARCHAR(MAX)
	,@p_nonChk					NVARCHAR(MAX) = 'N'
	,@p_delegateeChk			NVARCHAR(MAX)

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
	IF @p_search_yn != 'Y'
	BEGIN
		SELECT a.HOLD_ID
			 , a.DIVISION_ID
			 , a.FROM_SITE
			 , isnull(dbo.fn_get_scm_site_description(a.division_id, a.from_site ),'-') as from_site_nm
			 , a.item_id
			 , dbo.fn_get_item_nickname((case when a.division_id = 'EE' then a.origin_from_division_id else a.division_id end), a.item_id ) as nick_name
			 , CONVERT(NVARCHAR(10),dbo.fn_char_to_date(a.HOLD_YYYYMMDD),121) AS HOLD_YYYYMMDD
			 , CONVERT(NVARCHAR(10),dbo.fn_char_to_date(a.RELEASE_YYYYMMDD),121) AS RELEASE_YYYYMMDD
			 , a.HOLD_QTY
			 , a.REMARKS
			 , CASE WHEN @p_language = 'KO' THEN U.UserName ELSE U.UserName_E END + '(' + a.LAST_UPDATED_BY + ')' as LAST_UPDATED_BY
			 , a.LAST_UPDATE_DATE
		  FROM SSP_ANL_HOLD_STOCK a WITH(NOLOCK)
		       LEFT OUTER JOIN TB_FX_User U  WITH(NOLOCK)  
			ON a.LAST_UPDATED_BY = u.UserID AND U.UseYN = 'Y'
		       LEFT OUTER JOIN SSP_MST_MODEL_USER M WITH(NOLOCK) 
		    ON M.division_id = a.division_id 
		   AND M.from_site = a.from_site 
		   AND M.item_id = a.item_id 
		   AND M.valid_yn = 'Y' 
		 WHERE a.DIVISION_ID = @p_division_id
		   AND a.FROM_SITE = @p_from_site
		   AND a.HOLD_YYYYMMDD <= convert(varchar(8), convert(datetime, @p_plan_start_yyyymmdd) +1, 112)
		   AND a.RELEASE_YYYYMMDD >= convert(varchar(8), convert(datetime, @p_plan_start_yyyymmdd) +1, 112)
		   AND a.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
		   AND a.PLAN_TYPE = @p_plan_type
		   AND a.SEQ = @p_seq
		   AND a.item_id = @p_item_id
		 GROUP BY a.HOLD_ID 
			 , a.item_id
			 , dbo.fn_get_item_nickname((case when a.division_id = 'EE' then a.origin_from_division_id else a.division_id end), a.item_id )
			 , a.division_id
			 , a.FROM_SITE
			 , isnull(dbo.fn_get_scm_site_description(a.division_id, a.from_site ),'-')
			 , a.HOLD_YYYYMMDD 
			 , a.RELEASE_YYYYMMDD
			 , a.HOLD_QTY
			 , a.REMARKS
			 , a.LAST_UPDATE_DATE
			 , CASE WHEN @p_language = 'KO' THEN U.UserName ELSE U.UserName_E END + '(' + a.LAST_UPDATED_BY + ')' 
		 ORDER BY
			   a.HOLD_ID
	END
	--2. btnSearch
	ELSE
	BEGIN
		SELECT a.HOLD_ID
			 , a.DIVISION_ID
			 , a.FROM_SITE
			 , isnull(dbo.fn_get_scm_site_description(a.division_id, a.from_site ),'-') as from_site_nm
			 , a.item_id
			 , dbo.fn_get_item_nickname((case when a.division_id = 'EE' then a.origin_from_division_id else a.division_id end), a.item_id ) as nick_name
			 , CONVERT(NVARCHAR(10),dbo.fn_char_to_date(a.HOLD_YYYYMMDD),121) AS HOLD_YYYYMMDD
			 , CONVERT(NVARCHAR(10),dbo.fn_char_to_date(a.RELEASE_YYYYMMDD),121) AS RELEASE_YYYYMMDD
			 , a.HOLD_QTY
			 , a.REMARKS
			 , CASE WHEN @p_language = 'KO' THEN U.UserName ELSE U.UserName_E END + '(' + a.LAST_UPDATED_BY + ')' as LAST_UPDATED_BY
			 , a.LAST_UPDATE_DATE
		  FROM SSP_ANL_HOLD_STOCK a WITH(NOLOCK)
			   JOIN SCM_MST_SITE AS FS with(NOLOCK)
			ON a.DIVISION_ID = FS.DIVISION_ID
		   AND a.FROM_SITE = FS.SCM_SITE_ID
		   AND FS.OPERATION_GROUP = 'P'
		   AND FS.OSP_YN = 'N'
		   AND FS.VALID_YN = 'Y'
		       LEFT OUTER JOIN TB_FX_User U  WITH(NOLOCK)  
			ON a.LAST_UPDATED_BY = u.UserID AND U.UseYN = 'Y'
		       LEFT OUTER JOIN SSP_MST_MODEL_USER M WITH(NOLOCK) 
		    ON M.division_id = a.division_id 
		   AND M.from_site = a.from_site 
		   AND M.item_id = a.item_id 
		   AND M.valid_yn = 'Y' 
		 WHERE a.DIVISION_ID = @p_division_id
		   AND ( ( @p_from_site   IS NULL OR @p_from_site ='')  OR a.from_site IN (SELECT token FROM dbo.String_Split(@p_from_site,',')) )
		   AND a.HOLD_YYYYMMDD <= convert(varchar(8), convert(datetime, @p_plan_start_yyyymmdd) +1, 112)
		   AND a.RELEASE_YYYYMMDD >= convert(varchar(8), convert(datetime, @p_plan_start_yyyymmdd) +1, 112)
		   AND a.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
		   AND a.PLAN_TYPE = @p_plan_type
		   AND a.SEQ = @p_seq
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
		GROUP BY 
		      a.HOLD_ID 
			, a.item_id
			, dbo.fn_get_item_nickname((case when a.division_id = 'EE' then a.origin_from_division_id else a.division_id end), a.item_id )
			, a.division_id
			, a.FROM_SITE
			, isnull(dbo.fn_get_scm_site_description(a.division_id, a.from_site ),'-')
			, a.HOLD_YYYYMMDD 
			, a.RELEASE_YYYYMMDD
			, a.HOLD_QTY
			, a.REMARKS
			, a.LAST_UPDATE_DATE
			, CASE WHEN @p_language = 'KO' THEN U.UserName ELSE U.UserName_E END + '(' + a.LAST_UPDATED_BY + ')' 
		ORDER BY
			  a.HOLD_ID
	END


--------------------------------------------------------------------------------------------------------------------------------------------------------

	--BLOCK_STOCK Detail
	--1. 셀 더블클릭
	IF @p_search_yn != 'Y'
	BEGIN
		SELECT a.HOLD_ID
			 , a.DIVISION_ID
			 , a.FROM_SITE
			 , isnull(dbo.fn_get_scm_site_description(a.division_id, a.from_site ),'-') as from_site_nm
			 , a.item_id
			 , dbo.fn_get_item_nickname((case when a.division_id = 'EE' then a.origin_from_division_id else a.division_id end), a.item_id ) as nick_name
			 , CONVERT(NVARCHAR(10),dbo.fn_char_to_date(a.HOLD_YYYYMMDD),121) AS HOLD_YYYYMMDD
			 , CONVERT(NVARCHAR(10),dbo.fn_char_to_date(a.RELEASE_YYYYMMDD),121) AS RELEASE_YYYYMMDD
			 , a.HOLD_QTY
			 , a.REMARKS
			 , CASE WHEN @p_language = 'KO' THEN U.UserName ELSE U.UserName_E END + '(' + a.LAST_UPDATED_BY + ')' as LAST_UPDATED_BY
			 , a.LAST_UPDATE_DATE
		  FROM SSP_ANL_HOLD_STOCK a WITH(NOLOCK)
		       LEFT OUTER JOIN TB_FX_User U  WITH(NOLOCK)  ON a.LAST_UPDATED_BY = u.UserID AND U.UseYN = 'Y'
		       LEFT OUTER JOIN SSP_MST_MODEL_USER M WITH(NOLOCK) 
		    ON M.division_id = a.division_id 
		   AND M.from_site = a.from_site 
		   AND M.item_id = a.item_id 
		   AND M.valid_yn = 'Y' 
		 WHERE a.DIVISION_ID = @p_division_id
		   AND a.FROM_SITE = @p_from_site
		   AND a.HOLD_YYYYMMDD <= convert(varchar(8), convert(datetime, @p_plan_start_yyyymmdd) +1, 112)
		   AND a.RELEASE_YYYYMMDD >= convert(varchar(8), convert(datetime, @p_plan_start_yyyymmdd) +1, 112)
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
			 , a.DIVISION_ID
			 , a.FROM_SITE
			 , isnull(dbo.fn_get_scm_site_description(a.division_id, a.from_site ),'-') as from_site_nm
			 , a.item_id
			 , dbo.fn_get_item_nickname((case when a.division_id = 'EE' then a.origin_from_division_id else a.division_id end), a.item_id ) as nick_name
			 , CONVERT(NVARCHAR(10),dbo.fn_char_to_date(a.HOLD_YYYYMMDD),121) AS HOLD_YYYYMMDD
			 , CONVERT(NVARCHAR(10),dbo.fn_char_to_date(a.RELEASE_YYYYMMDD),121) AS RELEASE_YYYYMMDD
			 , a.HOLD_QTY
			 , a.REMARKS
			 , CASE WHEN @p_language = 'KO' THEN U.UserName ELSE U.UserName_E END + '(' + a.LAST_UPDATED_BY + ')' as LAST_UPDATED_BY
			 , a.LAST_UPDATE_DATE
		  FROM SSP_ANL_HOLD_STOCK a WITH(NOLOCK)
			   JOIN SCM_MST_SITE AS FS with(NOLOCK)
			ON a.DIVISION_ID = FS.DIVISION_ID
		   AND a.FROM_SITE = FS.SCM_SITE_ID
		   AND FS.OPERATION_GROUP = 'P'
		   AND FS.OSP_YN = 'N'
		   AND FS.VALID_YN = 'Y'
		       LEFT OUTER JOIN TB_FX_User U  WITH(NOLOCK)  ON a.LAST_UPDATED_BY = u.UserID AND U.UseYN = 'Y'
		       LEFT OUTER JOIN SSP_MST_MODEL_USER M WITH(NOLOCK) 
		    ON M.division_id = a.division_id 
		   AND M.from_site = a.from_site 
		   AND M.item_id = a.item_id 
		   AND M.valid_yn = 'Y'
		 WHERE a.DIVISION_ID = @p_division_id
		   AND ( ( @p_from_site   IS NULL OR @p_from_site ='')  OR a.from_site IN (SELECT token FROM dbo.String_Split(@p_from_site,',')) )
		   AND a.HOLD_YYYYMMDD <= convert(varchar(8), convert(datetime, @p_plan_start_yyyymmdd) +1, 112)
		   AND a.RELEASE_YYYYMMDD >= convert(varchar(8), convert(datetime, @p_plan_start_yyyymmdd) +1, 112)
		   AND a.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
		   AND a.PLAN_TYPE = @p_plan_type
		   AND a.SEQ = @p_seq
		   AND ( ( @p_item_id   IS NULL OR @p_item_id ='')  OR a.item_id IN (SELECT token FROM dbo.String_Split(@p_item_id,',')) )
		   
		   --체크박스 체크 여부 조회 시작(@p_nonChk = 'Y' : 체크박스 선택 안한 상태)
		   AND ((@p_nonChk = 'Y' AND 1 = 1 OR M.USER_ID IN (SELECT CASE WHEN @p_myModelChk = 'Y' THEN @p_user_id ELSE 'X' END 
														     UNION 
														    SELECT CASE WHEN @p_delegateeChk = 'Y' THEN USER_ID ELSE 'X' END 
														      FROM SSP_MST_DELEGATE  WITH(NOLOCK)  
															 WHERE VALID_YN = 'Y' 
															   AND DELEGATEE_ID = @p_user_id 
															 GROUP BY USER_ID)
										   OR M.PART_LEADER = CASE WHEN @p_partLeaderChk = 'Y' THEN @p_user_id  ELSE 'X' END	
										   OR M.TEAM_LEADER = CASE WHEN @p_teamLeaderChk = 'Y' THEN @p_user_id  ELSE 'X' END))
		   --체크박스 체크 여부 조회 끝
		 GROUP BY a.HOLD_ID 
			 , a.item_id
			 , dbo.fn_get_item_nickname((case when a.division_id = 'EE' then a.origin_from_division_id else a.division_id end), a.item_id )
			 , a.division_id
			 , a.FROM_SITE
			 , isnull(dbo.fn_get_scm_site_description(a.division_id, a.from_site ),'-')
			 , a.HOLD_YYYYMMDD 
			 , a.RELEASE_YYYYMMDD
			 , a.HOLD_QTY
			 , a.REMARKS
			 , a.LAST_UPDATE_DATE
			 , CASE WHEN @p_language = 'KO' THEN U.UserName ELSE U.UserName_E END + '(' + a.LAST_UPDATED_BY + ')' 
		 ORDER BY
			   a.HOLD_ID
	END
END


