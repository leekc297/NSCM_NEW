

/*
 * Program ID   : SSP0050_GET_SHIPMENT_APPORVAL
 * Description  : Shipment Apporval
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *=================================================================================================== 
 * 2024/02/06   jilee          SSP 전자 결재 연동 승인자 기준 정보

 ex) EXEC SSP0050_GET_SHIPMENT_APPORVAL @p_user_id
 */

CREATE PROCEDURE [dbo].[SSP0050_GET_SHIPMENT_APPORVAL]	
	@p_user_id				NVARCHAR(MAX)	
AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	
	
	SELECT A.USER_ID
	       ,A.PERIOD_FROM
		   ,A.PERIOD_TO
		   ,A.DAYS_MON_YN
		   ,A.DAYS_MON_FROM_TO		   
		   ,A.DAYS_TUE_YN
		   ,A.DAYS_TUE_FROM_TO		   
		   ,A.DAYS_WED_YN
		   ,A.DAYS_WED_FROM_TO		   
		   ,A.DAYS_THU_YN
		   ,A.DAYS_THU_FROM_TO		   
		   ,A.DAYS_FRI_YN
		   ,A.DAYS_FRI_FROM_TO		   
		   ,A.DAYS_SAT_YN
		   ,A.DAYS_SAT_FROM_TO		   
		   ,A.DAYS_SUN_YN
		   ,A.DAYS_SUN_FROM_TO		   
		   ,A.VALID_YN
		   ,A.CREATED_BY
		   ,A.CREATION_DATE
		   ,A.LAST_UPDATED_BY 
		   ,A.LAST_UPDATE_DATE
	FROM SSP_MST_APPROVAL A WITH(NOLOCK)
	LEFT OUTER JOIN TB_FX_User u on u.UserID = A.USER_ID
	ORDER BY A.PERIOD_FROM DESC, A.PERIOD_TO DESC

	--SELECT DIVISION_ID
	--	  ,OPERATION_GROUP
	--	  ,FROM_SITE
	--	  ,ITEM_ID
	--	  ,dbo.fn_get_item_nickname(a.DIVISION_ID, a.ITEM_ID ) AS NICK_NAME
	--	  ,a.USER_ID
	--	  ,case when @p_language = 'KO' then u.UserName else u.UserName_E end USER_NAME
	--	  ,a.PART_LEADER
	--	  ,case when @p_language = 'KO' then pl.UserName else pl.UserName_E end PART_LEADER_NAME
	--	  ,a.TEAM_LEADER
	--	  ,case when @p_language = 'KO' then tl.UserName else tl.UserName_E end TEAM_LEADER_NAME
	--	  ,isnull(a.VALID_YN,'Y') VALID_YN
	--	  ,case when @p_language = 'KO' then cu.UserName else cu.UserName_E end + '(' + a.CREATED_BY + ')' CREATED_BY
	--	  ,a.CREATION_DATE
	--	  ,case when @p_language = 'KO' then lu.UserName else lu.UserName_E end + '(' + a.LAST_UPDATED_BY + ')' LAST_UPDATED_BY
	--	  ,a.LAST_UPDATE_DATE
	--	  ,a.ATTRIBUTE1 AS MAIL_USER1
	--	  ,a.ATTRIBUTE2 AS MAIL_USER2
	--	  ,a.ATTRIBUTE3 AS MAIL_USER3
	--	  ,a.ATTRIBUTE4 AS MAIL_USER4
	--	  ,a.ATTRIBUTE5 AS MAIL_USER5
	--FROM(
	--		SELECT SI.DIVISION_ID 			
	--			  ,FS.OPERATION_GROUP
	--			  ,SI.SCM_SITE_ID FROM_SITE 
	--			  ,SI.ITEM_ID 
	--			  ,MU.USER_ID
	--			  ,MU.PART_LEADER
	--			  ,MU.TEAM_LEADER
	--			  ,MU.VALID_YN			
	--			  ,max(mu.CREATED_BY) CREATED_BY
	--			  ,max(MU.CREATION_DATE) CREATION_DATE
	--			  ,max(mu.LAST_UPDATED_BY) LAST_UPDATED_BY
	--			  ,max(mu.LAST_UPDATE_DATE) LAST_UPDATE_DATE
	--			  ,MU.ATTRIBUTE1
	--			  ,MU.ATTRIBUTE2
	--			  ,MU.ATTRIBUTE3
	--			  ,MU.ATTRIBUTE4
	--			  ,MU.ATTRIBUTE5
	--		FROM SCM_MST_SITE_ITEM SI WITH(NOLOCK) 			
	--			JOIN SCM_MST_SITE  FS WITH(NOLOCK) ON FS.DIVISION_ID = SI.DIVISION_ID AND  FS.SCM_SITE_ID = SI.SCM_SITE_ID AND  FS.SITE_TYPE  = 'PLANT'		
	--			LEFT OUTER JOIN SSP_MST_MODEL_USER MU WITH(NOLOCK) ON MU.DIVISION_ID = SI.DIVISION_ID AND MU.FROM_SITE = SI.SCM_SITE_ID AND MU.ITEM_ID = SI.ITEM_iD 	
	--		WHERE 1=1 				
	--		GROUP BY SI.DIVISION_ID, FS.OPERATION_GROUP, SI.SCM_SITE_ID, SI.ITEM_ID, MU.USER_ID, MU.PART_LEADER, MU.TEAM_LEADER, MU.VALID_YN, MU.ATTRIBUTE1, MU.ATTRIBUTE2
	--		         , MU.ATTRIBUTE3, MU.ATTRIBUTE4, MU.ATTRIBUTE5			
	--) a
	--LEFT OUTER JOIN TB_FX_User u on u.UserID = a.USER_ID
	--LEFT OUTER JOIN TB_FX_User pl on pl.UserID = a.PART_LEADER
	--LEFT OUTER JOIN TB_FX_User tl on tl.UserID = a.TEAM_LEADER
	--LEFT OUTER JOIN TB_FX_User cu on cu.UserID = a.CREATED_BY
	--LEFT OUTER JOIN TB_FX_User lu on lu.UserID = a.LAST_UPDATED_BY
	--WHERE a.DIVISION_ID = @p_division_id
	--  AND ( ( @p_operation_group   IS NULL OR @p_operation_group ='')  OR a.OPERATION_GROUP IN (SELECT token FROM dbo.String_Split(@p_operation_group,',')) )
	--  AND ( ( @p_from_site   IS NULL OR @p_from_site ='')  OR a.from_site IN (SELECT token FROM dbo.String_Split(@p_from_site,',')) )
	--  AND ( ( @p_valid_yn   IS NULL OR @p_valid_yn ='')  OR a.VALID_YN IN (SELECT token FROM dbo.String_Split(@p_valid_yn,',')) )
	--  AND ( ( @p_item_id   IS NULL OR @p_item_id ='')  OR a.ITEM_ID IN (SELECT token FROM dbo.String_Split(@p_item_id,',')) )
	--  AND ( ( @p_user_id   IS NULL OR @p_user_id ='')  OR (a.USER_ID like '%' + @p_user_id + '%') or (u.UserName like '%' + @p_user_id + '%')  
	--												   OR (a.PART_LEADER like '%' + @p_user_id + '%') or (pl.UserName like '%' + @p_user_id + '%') 
	--												   OR (a.TEAM_LEADER like '%' + @p_user_id + '%') or (tl.UserName like '%' + @p_user_id + '%') )
	--ORDER BY DIVISION_ID
	--	  ,OPERATION_GROUP
	--	  ,from_site
	--	  ,ITEM_ID
	--	  ,a.USER_ID
END
