



/*
 * Program ID   : SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE
 * Description  : SITE 정보
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *=================================================================================================== 
 * 
 * 2026/02/20   강주용			[E20260206-001938] VP 권한 확장 - UP_FX_GetCommonDataList_SCP의 'ShipmentPlanPlantSite'를 복사함
 */

CREATE PROCEDURE [dbo].[SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE]   
 @p_division_id NVARCHAR(100)
,@p_now_group_id NVARCHAR(100) -- NOWGroupID
,@p_user_id NVARCHAR(100) -- UserID
AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @exception_company TABLE ( company_id nvarchar(100) );--[NERP]COMPANY 예외적용--NERP (IT20250117A)

	Declare @AuthTypePara varchar(100) = 'D'
	if(@p_user_id = 'JV Planner') SET @AuthTypePara = 'J';
	-- END CSR

	BEGIN
		--[NERP]COMPANY 예외적용 시작--NERP (IT20250117A)
		INSERT INTO @exception_company (company_id) select SEGMENT1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL with(nolock) 
			WHERE 1=1
			AND LOOKUP_TYPE = 'SSP_UI_EXCEPT_COMPANY' and VALID_YN='Y'
		--[NERP]COMPANY 예외적용 끝--NERP (IT20250117A)

		SELECT distinct CODE
		      ,NAME
			  ,COMPANY_ID--[NERP]COMPANY 예외적용--NERP (IT20250117A)
		FROM(
				SELECT A.SCM_SITE_ID AS CODE
					, A.SITE_DESCRIPTION AS NAME
					,A.COMPANY_ID--[NERP]COMPANY 예외적용--NERP (IT20250117A)
				FROM   [dbo].[SCM_MST_SITE] A  WITH(NOLOCK)
				WHERE  1 = 1
				AND    A.SITE_TYPE = 'PLANT'
				AND    A.VALID_YN  = 'Y'
				AND    A.DIVISION_ID  IN ( SELECT token FROM dbo.String_Split(@p_division_id,','))
				-- START [E20260206-001938] VP 권한 확장 
				AND	   A.DIVISION_ID IN (SELECT A.CODE FROM TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) WHERE AuthType = @AuthTypePara AND GroupID  = @p_now_group_id AND UserID   = @p_user_id)
				union all
				SELECT A.SCM_SITE_ID AS CODE
					 , A.SITE_DESCRIPTION AS NAME
					 , A.COMPANY_ID--[NERP]COMPANY 예외적용--NERP (IT20250117A)
				FROM   [dbo].[SCM_MST_SITE] A  WITH(NOLOCK)
				WHERE  1 = 1
				AND    A.SITE_TYPE = 'PLANT'
				AND    A.VALID_YN  = 'Y'
				AND    A.DIVISION_ID  IN ( SELECT token FROM dbo.String_Split(@p_division_id,','))
				AND    A.ATTRIBUTE9 IN (SELECT FS.SCM_SITE_ID
								          FROM SCM_MST_SITE AS FS WITH(NOLOCK) 
								          JOIN TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) 
								            ON FS.DIVISION_ID = A.CODE
								           AND FS.SITE_TYPE = 'PLANT'
							             WHERE A.AuthType = @AuthTypePara
								           AND A.GroupID  = @p_now_group_id 
								           AND A.UserID   = @p_user_id
						               )
				-- END [E20260206-001938] VP 권한 확장 
				union all
				SELECT distinct SEGMENT1 CODE
					  ,A.SEGMENT1 + '   '+b.SITE_DESCRIPTION AS NAME
					   , B.COMPANY_ID--[NERP]COMPANY 예외적용--NERP (IT20250117A)
				FROM [SCM_ADM_LOOKUP_MASTER_DETAIL] a WITH(NOLOCK)
--				LEFT OUTER JOIN SCM_MST_SITE b WITH(NOLOCK) on a.SEGMENT1 = b.SCM_SITE_ID and b.VALID_YN ='Y' 	--/* 전극 구코드가 나오는 문제 해결 ==> 이를 보완함. 강현준 (20240705) */
				INNER JOIN SCM_MST_SITE b WITH(NOLOCK) on a.SEGMENT1 = b.SCM_SITE_ID and b.VALID_YN ='Y'
				WHERE LOOKUP_TYPE = 'EE_SHIPMENT_PLAN'
				  AND a.VALID_YN = 'Y'
		) a
		WHERE not exists (select 1 from @exception_company K where a.COMPANY_ID = K.company_id)--[NERP]COMPANY 예외적용--NERP (IT20250117A)
		ORDER BY CODE
	END

END
