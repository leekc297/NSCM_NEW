



/*
 * Program ID   : SSP0200_GET_PLANT_SITE_BY_DIVISION
 * Description  : SITE 정보
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *=================================================================================================== 
 * 2018/08/14	YMHOON			신규작성
 * 2026/02/20   강주용			[E20260206-001938] VP 권한 확장 - UP_FX_GetCommonDataList_SCP의 'PlantSiteByDivision'를 복사함
 */

CREATE PROCEDURE [dbo].[SSP0200_GET_PLANT_SITE_BY_DIVISION]   
 @p_division_id NVARCHAR(100)
,@p_company_id NVARCHAR(100)
,@p_valid_yn NVARCHAR(10)
,@p_now_group_id NVARCHAR(100) -- NOWGroupID
,@p_user_id NVARCHAR(100) -- UserID
AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	Declare @AuthTypePara varchar(100) = 'D'
	if(@p_user_id = 'JV Planner') SET @AuthTypePara = 'J';

	BEGIN
		SELECT CODE, NAME
		FROM (
		SELECT '-' AS CODE, '-' AS NAME
		UNION ALL
		SELECT A.SCM_SITE_ID AS CODE
			, A.SITE_DESCRIPTION AS NAME
		FROM   [dbo].[SCM_MST_SITE] A  WITH(NOLOCK)
		WHERE  1 = 1
		AND    A.SITE_TYPE = 'PLANT'
		AND    A.VALID_YN  = 'Y'
			AND    (@p_division_id IS NULL OR @p_division_id='' OR A.DIVISION_ID IN (SELECT token FROM dbo.String_Split(@p_division_id,',')))
			AND    (@p_company_id IS NULL OR @p_company_id='' OR A.COMPANY_ID  IN ( SELECT token FROM dbo.String_Split(@p_company_id,',')))
			AND    (@p_valid_yn IS NULL OR @p_valid_yn='' OR A.VALID_YN=@p_valid_yn)
			AND	   A.DIVISION_ID IN (SELECT A.CODE FROM TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) WHERE AuthType = @AuthTypePara AND GroupID  = @p_now_group_id AND UserID   = @p_user_id)
			UNION ALL -- VP 추가 권한
			SELECT A.SCM_SITE_ID AS CODE
				 , A.SITE_DESCRIPTION AS NAME
			FROM   [dbo].[SCM_MST_SITE] A  WITH(NOLOCK)
			WHERE  1 = 1
			AND    A.SITE_TYPE = 'PLANT'
			AND    A.VALID_YN  = 'Y'
			AND    A.DIVISION_ID IN (SELECT token FROM dbo.String_Split(@p_division_id,','))
			AND    (@p_company_id IS NULL OR @p_company_id='' OR A.COMPANY_ID  IN ( SELECT token FROM dbo.String_Split(@p_company_id,',')))
			AND    (@p_valid_yn IS NULL OR @p_valid_yn='' OR A.VALID_YN=@p_valid_yn)
			AND	   A.ATTRIBUTE9 IN (SELECT FS.SCM_SITE_ID
								      FROM SCM_MST_SITE AS FS WITH(NOLOCK) 
								      JOIN TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) 
								        ON FS.DIVISION_ID = A.CODE
								       AND FS.SITE_TYPE = 'PLANT'
							         WHERE AuthType = @AuthTypePara
								       AND GroupID  = @p_now_group_id 
								       AND UserID   = @p_user_id
						     )
			) X
		GROUP BY CODE, NAME
	END

END
