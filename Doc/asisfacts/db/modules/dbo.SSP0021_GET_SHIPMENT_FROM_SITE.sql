



/*
 * Program ID   : SSP0021_GET_SHIPMENT_FROM_SITE
 * Description  : Company에 따른 From_Site Load
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *=================================================================================================== 
 * 2019/08/23   mcTheJ	        신규작성
 * 2026/03/17   강주용			E20260206-001938 VP 권한 확장
 * 2026/09/03	강주용			[E20260831-000063] VILD_YN 적용
 */

CREATE PROCEDURE [dbo].[SSP0021_GET_SHIPMENT_FROM_SITE]   
   @Param1 NVARCHAR(100) -- DIVISION ID
 , @Param2 NVARCHAR(100) -- COMPANY ID
 , @Param3 NVARCHAR(100) -- NOW GroupID
 , @Param4 NVARCHAR(100) -- UserID
AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;


	BEGIN	
		Declare @AuthTypePara varchar(100) = 'D'
		if(@Param1 = 'JV Planner') SET @AuthTypePara = 'J';

		DECLARE @exception_company TABLE ( company_id nvarchar(100) );--[NERP]COMPANY 예외적용--NERP (IT20250117A)

		--[NERP]COMPANY 예외적용 시작--NERP (IT20250117A)
		INSERT INTO @exception_company (company_id) select SEGMENT1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL with(nolock)
				where 1=1
				AND lookup_type = 'SSP_UI_EXCEPT_COMPANY'
				AND VALID_YN = 'y'
		--[NERP]COMPANY 예외적용 끝--NERP (IT20250117A)
		SELECT CODE, NAME
		  FROM (
		SELECT
			S.SCM_SITE_ID AS CODE, S.SITE_DESCRIPTION AS NAME
		FROM SCM_MST_SITE S WITH(NOLOCK)
		WHERE 1 = 1
		AND S.SITE_TYPE = 'PLANT'
		AND S.OPERATION_GROUP <> 'E'
		AND (@Param1 IS NULL OR @Param1='' OR S.DIVISION_ID=@Param1)
		AND (@Param2 IS NULL OR @Param2='' OR S.COMPANY_ID=@Param2)
		AND not exists (select 1 from @exception_company K where @Param2 = K.company_id)--[NERP]COMPANY 예외적용--NERP (IT20250117A)
		--START CSR
		AND DIVISION_ID IN (SELECT CODE FROM TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) WHERE GroupID = @Param3 AND UserID = @Param4 AND AuthType = @AuthTypePara)
		-- START [E20260831-000063] VILD_YN 적용
		AND VALID_YN = 'Y'
		-- END [E20260831-000063] VILD_YN 적용

		UNION ALL
		SELECT
			S.SCM_SITE_ID AS CODE, S.SITE_DESCRIPTION AS NAME
		FROM SCM_MST_SITE S WITH(NOLOCK)
		WHERE 1 = 1
		AND S.SITE_TYPE = 'PLANT'
		AND S.OPERATION_GROUP <> 'E'
		AND (@Param1 IS NULL OR @Param1='' OR S.DIVISION_ID=@Param1)
		AND (@Param2 IS NULL OR @Param2='' OR S.COMPANY_ID=@Param2)
		AND not exists (select 1 from @exception_company K where @Param2 = K.company_id)--[NERP]COMPANY 예외적용--NERP (IT20250117A)
		AND S.ATTRIBUTE9 IN (SELECT FS.SCM_SITE_ID
								FROM SCM_MST_SITE AS FS WITH(NOLOCK) 
								JOIN TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) 
								  ON FS.DIVISION_ID = A.CODE
								 AND FS.SITE_TYPE = 'PLANT'
							   WHERE AuthType = @AuthTypePara
								 AND GroupID  = @Param3 
								 AND UserID   = @Param4
						     )
		-- START [E20260831-000063] VILD_YN 적용
		AND VALID_YN = 'Y'
		-- END [E20260831-000063] VILD_YN 적용
			) A
		GROUP BY CODE, NAME
	END	

END
