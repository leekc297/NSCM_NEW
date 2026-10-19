

/*
 * Program ID   : SSP0014_GET_SHIPMENT_MODEL_PIC
 * Description  : Shipment Model PIC
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/10/22   ygkim          Initial Release [PJ20182279] 전지본부 출하계획 시스템 구축 프로젝트
 * 2019/06/17	AYJ			   [CSR ID:4017374] [요청] Shipment Model PIC Part Leader/ Team Leader 추가
 * 2022/01/25   jilee          SSP_MST_MODEL_USER 등록된 추가 사용자 메일 발송 (ATTRIBUTE*)

 ex) EXEC SSP0014_GET_SHIPMENT_MODEL_PIC @p_division_id='40', @p_operation_group='P,A,E', @p_from_site='', @p_valid_yn='', @p_item_id='', @p_user_id='', @p_language='KO'
 */

CREATE PROCEDURE [dbo].[SSP0014_GET_SHIPMENT_MODEL_PIC]
	 @p_division_id			NVARCHAR(MAX)
	,@p_operation_group		NVARCHAR(MAX)
	,@p_from_site			NVARCHAR(MAX)
	,@p_valid_yn			NVARCHAR(MAX)
	,@p_item_id				NVARCHAR(MAX)
	,@p_user_id				NVARCHAR(MAX)
	,@p_language			NVARCHAR(MAX)
AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	
	SELECT DIVISION_ID
		  ,OPERATION_GROUP
		  ,FROM_SITE
		  ,ITEM_ID
		  ,dbo.fn_get_item_nickname(a.DIVISION_ID, a.ITEM_ID ) AS NICK_NAME
		  ,a.USER_ID
		  ,case when @p_language = 'KO' then u.UserName else u.UserName_E end USER_NAME
		  ,a.PART_LEADER
		  ,case when @p_language = 'KO' then pl.UserName else pl.UserName_E end PART_LEADER_NAME
		  ,a.TEAM_LEADER
		  ,case when @p_language = 'KO' then tl.UserName else tl.UserName_E end TEAM_LEADER_NAME
		  ,isnull(a.VALID_YN,'Y') VALID_YN
		  ,case when @p_language = 'KO' then cu.UserName else cu.UserName_E end + '(' + a.CREATED_BY + ')' CREATED_BY
		  ,a.CREATION_DATE
		  ,case when @p_language = 'KO' then lu.UserName else lu.UserName_E end + '(' + a.LAST_UPDATED_BY + ')' LAST_UPDATED_BY
		  ,a.LAST_UPDATE_DATE
		  ,a.ATTRIBUTE1 AS MAIL_USER1
		  ,a.ATTRIBUTE2 AS MAIL_USER2
		  ,a.ATTRIBUTE3 AS MAIL_USER3
		  ,a.ATTRIBUTE4 AS MAIL_USER4
		  ,a.ATTRIBUTE5 AS MAIL_USER5
	FROM(
			SELECT SI.DIVISION_ID 			
				  ,FS.OPERATION_GROUP
				  ,SI.SCM_SITE_ID FROM_SITE 
				  ,SI.ITEM_ID 
				  ,MU.USER_ID
				  ,MU.PART_LEADER
				  ,MU.TEAM_LEADER
				  ,MU.VALID_YN			
				  ,max(mu.CREATED_BY) CREATED_BY
				  ,max(MU.CREATION_DATE) CREATION_DATE
				  ,max(mu.LAST_UPDATED_BY) LAST_UPDATED_BY
				  ,max(mu.LAST_UPDATE_DATE) LAST_UPDATE_DATE
				  ,MU.ATTRIBUTE1
				  ,MU.ATTRIBUTE2
				  ,MU.ATTRIBUTE3
				  ,MU.ATTRIBUTE4
				  ,MU.ATTRIBUTE5
			FROM SCM_MST_SITE_ITEM SI WITH(NOLOCK) 			
				JOIN SCM_MST_SITE  FS WITH(NOLOCK) ON FS.DIVISION_ID = SI.DIVISION_ID AND  FS.SCM_SITE_ID = SI.SCM_SITE_ID AND  FS.SITE_TYPE  = 'PLANT'		
				LEFT OUTER JOIN SSP_MST_MODEL_USER MU WITH(NOLOCK) ON MU.DIVISION_ID = SI.DIVISION_ID AND MU.FROM_SITE = SI.SCM_SITE_ID AND MU.ITEM_ID = SI.ITEM_iD 	
			WHERE 1=1 				
			GROUP BY SI.DIVISION_ID, FS.OPERATION_GROUP, SI.SCM_SITE_ID, SI.ITEM_ID, MU.USER_ID, MU.PART_LEADER, MU.TEAM_LEADER, MU.VALID_YN, MU.ATTRIBUTE1, MU.ATTRIBUTE2
			         , MU.ATTRIBUTE3, MU.ATTRIBUTE4, MU.ATTRIBUTE5			
	) a
	LEFT OUTER JOIN TB_FX_User u on u.UserID = a.USER_ID
	LEFT OUTER JOIN TB_FX_User pl on pl.UserID = a.PART_LEADER
	LEFT OUTER JOIN TB_FX_User tl on tl.UserID = a.TEAM_LEADER
	LEFT OUTER JOIN TB_FX_User cu on cu.UserID = a.CREATED_BY
	LEFT OUTER JOIN TB_FX_User lu on lu.UserID = a.LAST_UPDATED_BY
	WHERE a.DIVISION_ID = @p_division_id
	  AND ( ( @p_operation_group   IS NULL OR @p_operation_group ='')  OR a.OPERATION_GROUP IN (SELECT token FROM dbo.String_Split(@p_operation_group,',')) )
	  AND ( ( @p_from_site   IS NULL OR @p_from_site ='')  OR a.from_site IN (SELECT token FROM dbo.String_Split(@p_from_site,',')) )
	  AND ( ( @p_valid_yn   IS NULL OR @p_valid_yn ='')  OR a.VALID_YN IN (SELECT token FROM dbo.String_Split(@p_valid_yn,',')) )
	  AND ( ( @p_item_id   IS NULL OR @p_item_id ='')  OR a.ITEM_ID IN (SELECT token FROM dbo.String_Split(@p_item_id,',')) )
	  AND ( ( @p_user_id   IS NULL OR @p_user_id ='')  OR (a.USER_ID like '%' + @p_user_id + '%') or (u.UserName like '%' + @p_user_id + '%')  
													   OR (a.PART_LEADER like '%' + @p_user_id + '%') or (pl.UserName like '%' + @p_user_id + '%') 
													   OR (a.TEAM_LEADER like '%' + @p_user_id + '%') or (tl.UserName like '%' + @p_user_id + '%') )
	ORDER BY DIVISION_ID
		  ,OPERATION_GROUP
		  ,from_site
		  ,ITEM_ID
		  ,a.USER_ID
END
