

/*
 * Program ID   : [SSP0025_GET_SHIPMENT_REQUESTOR_PIC]
 * Description  : Shipment Requestor PIC
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2020/06/23   khj79          [PJ20199555] 공급 대응력 향상을 위한 자재재공 수급 점검 체계 개선 - 최초작성

 ex)  EXEC	SSP0025_SAVE_SHIPMENT_REQUEST_PIC
		@p_active_flag = N'M',
		@p_division_id = N'40',
		@p_to_site = N'G182-A',
		@p_item_id = N'APCAN0019A',
		@p_user_id = N'khj79',
		@p_create_id = N'khj79',
		@p_part_leader = '',
		@p_team_leader = '',
		@p_valid_yn = 'Y'
 */



CREATE PROCEDURE [dbo].[SSP0025_GET_SHIPMENT_REQUESTOR_PIC]
	 @p_division_id			NVARCHAR(MAX)
	,@p_plant_site			NVARCHAR(MAX)
	,@p_item_id				NVARCHAR(MAX)
	,@p_nick_name			NVARCHAR(MAX)
	,@p_model_id			NVARCHAR(MAX)
	--,@p_user_id				NVARCHAR(MAX)
	,@p_language			NVARCHAR(MAX)
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	
	SELECT M.DIVISION_ID
		 , M.TO_SITE				AS TO_SITE
		 , S.SITE_DESCRIPTION		AS SITE_DESCRIPTION
		 , M.ITEM_ID 
		 , C.ELECTRODE_TYPE
		 , C.MODEL_ID
		 , C.MODEL_ID_NICK_NAME		AS NICK_NAME
		 , C.CELL_TYPE
		 , M.USER_ID
		 , ISNULL(M.VALID_YN,'Y')   AS VALID_YN
		 , CASE WHEN @p_language = 'KO' THEN U.USERNAME ELSE U.USERNAME_E END USER_NAME
		 , M.PART_LEADER
		 , CASE WHEN @p_language = 'KO' THEN PL.USERNAME ELSE U.USERNAME_E END PART_LEADER_NAME
		 , M.TEAM_LEADER
		 , CASE WHEN @p_language = 'KO' THEN TL.USERNAME ELSE U.USERNAME_E END TEAM_LEADER_NAME
		 
		 , CASE WHEN @p_language = 'KO' THEN CU.USERNAME ELSE CU.USERNAME_E END + '(' + M.CREATED_BY + ')' CREATED_BY
		 , M.CREATION_DATE
		 , CASE WHEN @p_language = 'KO' THEN LU.USERNAME ELSE LU.USERNAME_E END + '(' + M.LAST_UPDATED_BY + ')' LAST_UPDATED_BY
		 , M.LAST_UPDATE_DATE
	  FROM SSP_MST_MODEL_USER_EE M WITH(NOLOCK)

	  JOIN SCM_MST_SITE S WITH(NOLOCK)
		ON S.DIVISION_ID = M.DIVISION_ID
	   AND S.SCM_SITE_ID = M.TO_SITE

	  LEFT OUTER JOIN (
							SELECT LF.SEGMENT5					AS DIVISION_ID
								 , LF.ATTRIBUTE1				AS TO_SITE
								 , E.ITEM_ID                    AS ITEM_ID
								 , MAX(E.MODEL_ID)				AS MODEL_ID
								 , MAX(E.MODEL_ID_NICK_NAME)	AS MODEL_ID_NICK_NAME
								 , MAX(E.CELL_TYPE)				AS CELL_TYPE
								 , MAX(E.ELECTRODE_TYPE)		AS ELECTRODE_TYPE
							  FROM SCM_ADM_LOOKUP_MASTER_DETAIL LF WITH(NOLOCK)

							  LEFT OUTER JOIN SSP_MST_SITE_ITEM_EE_V E WITH(NOLOCK)
								ON E.DIVISION_ID =  LF.SEGMENT2
							   AND E.SCM_SITE_ID =  LF.SEGMENT3

							 WHERE LF.LOOKUP_TYPE = 'ELECTRODE_SHIP_FROM_TO'
							   AND LF.VALID_YN    = 'Y'
							 GROUP BY E.ITEM_ID, LF.SEGMENT5, LF.ATTRIBUTE1
						) C
		ON C.DIVISION_ID = M.DIVISION_ID
	   AND C.TO_SITE = M.TO_SITE
	   AND C.ITEM_ID = M.ITEM_ID 
	  LEFT OUTER JOIN TB_FX_USER U  ON U.USERID  = M.USER_ID
	  LEFT OUTER JOIN TB_FX_USER PL ON PL.USERID = M.PART_LEADER
	  LEFT OUTER JOIN TB_FX_USER TL ON TL.USERID = M.TEAM_LEADER
	  LEFT OUTER JOIN TB_FX_USER CU ON CU.USERID = M.CREATED_BY
	  LEFT OUTER JOIN TB_FX_USER LU ON LU.USERID = M.LAST_UPDATED_BY
	 WHERE 1=1
	  AND M.DIVISION_ID = @p_division_id
	  AND ( ( @p_plant_site IS NULL OR @p_plant_site ='')  OR M.TO_SITE				IN (SELECT token FROM dbo.String_Split(@p_plant_site,',')) )
	  AND ( ( @p_item_id    IS NULL OR @p_item_id    ='')  OR M.ITEM_ID				IN (SELECT token FROM dbo.String_Split(@p_item_id   ,',')) )
	  AND ( ( @p_nick_name  IS NULL OR @p_nick_name  ='')  OR C.MODEL_ID_NICK_NAME	IN (SELECT token FROM dbo.String_Split(@p_nick_name ,',')) )
	  AND ( ( @p_model_id   IS NULL OR @p_model_id   ='')  OR C.MODEL_ID			IN (SELECT token FROM dbo.String_Split(@p_model_id  ,',')) )
	  --AND ( ( @p_user_id    IS NULL OR @p_user_id   ='')  OR (a.USER_ID     like '%' + @p_user_id + '%') or (u.UserName  like '%' + @p_user_id + '%')
													       --OR (a.PART_LEADER like '%' + @p_user_id + '%') or (pl.UserName like '%' + @p_user_id + '%')
													       --OR (a.TEAM_LEADER like '%' + @p_user_id + '%') or (tl.UserName like '%' + @p_user_id + '%')
		--)
	ORDER BY DIVISION_ID
			, M.TO_SITE
			, M.ITEM_ID
			, M.USER_ID
END
