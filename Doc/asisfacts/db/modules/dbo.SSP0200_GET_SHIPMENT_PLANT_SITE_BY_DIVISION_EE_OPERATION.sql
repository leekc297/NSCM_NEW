



/*
 * Program ID   : SSP0200_GET_SHIPMENT_PLANT_SITE_BY_DIVISION_EE_OPERATION
 * Description  : SITE 정보
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *=================================================================================================== 
 * 2018/11/23	YWHOON
 * 2021/05/18	KIMYONGHO		2021-05-18 소형 사업부의 경우 Packer 제외
 * 2026/03/18   강주용			[E20260206-001938] VP 권한 확장 - UP_FX_GetCommonDataList_SCP의 'PlantSiteByDivisionEEOperation'를 복사함
 */

CREATE PROCEDURE [dbo].[SSP0200_GET_SHIPMENT_PLANT_SITE_BY_DIVISION_EE_OPERATION]   
 @Param1 NVARCHAR(100)
,@Param2 NVARCHAR(100) -- NOWGroupID
,@Param3 NVARCHAR(100) -- UserID
AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	-- START [E20260206-001938] VP 권한 확장 
	Declare @AuthTypePara varchar(100) = 'D'
	if(@Param3 = 'JV Planner') SET @AuthTypePara = 'J';

	BEGIN
		SELECT A.CODE, A.NAME FROM (
	-- END [E20260206-001938] VP 권한 확장 
		SELECT A.SCM_SITE_ID AS CODE
			, A.SITE_DESCRIPTION AS NAME
			--, A.SCM_SITE_ID AS NAME
		FROM   [dbo].[SCM_MST_SITE] A  WITH(NOLOCK)
		WHERE  1 = 1
		AND    A.SITE_TYPE = 'PLANT'
		AND    A.VALID_YN  = 'Y'
		--AND	  A.DIVISION_ID = @Param1
		AND	   (@Param1='EE' OR A.DIVISION_ID=@Param1)
		AND NOT EXISTS (SELECT D.SCM_SITE_ID
								 FROM [dbo].[SCM_MST_SITE] D  WITH(NOLOCK)
								WHERE 1=1
									AND A.SCM_SITE_ID = D.SCM_SITE_ID
								  AND D.DIVISION_ID = '40'
								  AND D.OPERATION_GROUP = 'P'
								  -- 220809 jilee Packer항목 조건추가
								  AND D.OSP_YN = 'Y'
						)
		-- START [E20260206-001938] VP 권한 확장 
		AND	   A.DIVISION_ID IN (SELECT A.CODE FROM TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) WHERE AuthType = @AuthTypePara AND GroupID  = @Param2 AND UserID   = @Param3)
		UNION ALL
		SELECT A.SCM_SITE_ID AS CODE
			, A.SITE_DESCRIPTION AS NAME
			--, A.SCM_SITE_ID AS NAME
		FROM   [dbo].[SCM_MST_SITE] A  WITH(NOLOCK)
		WHERE  1 = 1
		AND    A.SITE_TYPE = 'PLANT'
		AND    A.VALID_YN  = 'Y'
		--AND	  A.DIVISION_ID = @Param1
		AND	   (@Param1='EE' OR A.DIVISION_ID=@Param1)
		AND NOT EXISTS (SELECT D.SCM_SITE_ID
								 FROM [dbo].[SCM_MST_SITE] D  WITH(NOLOCK)
								WHERE 1=1
									AND A.SCM_SITE_ID = D.SCM_SITE_ID
								  AND D.DIVISION_ID = '40'
								  AND D.OPERATION_GROUP = 'P'
								  -- 220809 jilee Packer항목 조건추가
								  AND D.OSP_YN = 'Y'
						)
		AND    A.ATTRIBUTE9 IN (SELECT FS.SCM_SITE_ID
								          FROM SCM_MST_SITE AS FS WITH(NOLOCK) 
								          JOIN TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) 
								            ON FS.DIVISION_ID = A.CODE
								           AND FS.SITE_TYPE = 'PLANT'
							             WHERE A.AuthType = @AuthTypePara
								           AND A.GroupID  = @Param2 
								           AND A.UserID   = @Param3
						               )
		) A
		GROUP BY A.CODE, A.NAME
		ORDER BY A.CODE
		-- END [E20260206-001938] VP 권한 확장 
	END

END
