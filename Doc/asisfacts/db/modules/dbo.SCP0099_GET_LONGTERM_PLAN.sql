
/*
 * Program ID   : [SCP0099_GET_LONGTERM_PLAN]
 * Description  : 중장기계획 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2023-06-30   KJJ				PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행 - 중장기 계획 조회

 * ex)
    EXEC SCP0099_GET_LONGTERM_PLAN @p_division_id='81',@p_valid_yn='Y', @p_PLAN_ID = ''
 */
CREATE PROCEDURE [dbo].[SCP0099_GET_LONGTERM_PLAN]
 (
  	 @p_division_id		NVARCHAR(MAX)  
	,@p_valid_yn  		NVARCHAR(1)
	,@p_PLAN_ID  		NVARCHAR(MAX)
 )
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON;

	SELECT [DIVISION_ID]
		  ,[PLAN_ID]
		  ,[SALE_VER]
		  ,PLAN_START_DATE
		  ,PLAN_END_DATE
		  ,[PLAN_DESC]
		  ,[VALID_YN]
		  ,[RELEASE_YN]
		  ,[CREATED_BY]
		  ,[CREATION_DATE]
		  ,[LAST_UPDATED_BY]
		  ,[LAST_UPDATE_DATE]
		  ,[ATTRIBUTE1]
		  ,[ATTRIBUTE2]
		  ,[ATTRIBUTE3]
		  ,[ATTRIBUTE4]
		  ,[ATTRIBUTE5]
		  ,[ATTRIBUTE6]
		  ,[ATTRIBUTE7]
		  ,[ATTRIBUTE8]
		  ,[ATTRIBUTE9]
		  ,[ATTRIBUTE10]
		  ,[ATTRIBUTE11]
		  ,[ATTRIBUTE12]
		  ,[ATTRIBUTE13]
		  ,[ATTRIBUTE14]
		  ,[ATTRIBUTE15]
	  FROM [dbo].[SCP_ANL_BUSINESS_PLAN_INFO] WITH(NOLOCK)
		WHERE DIVISION_ID = @p_division_id
		AND ( (@p_valid_yn=NULL OR @p_valid_yn='') OR VALID_YN = @p_valid_yn)
		AND ( (@p_PLAN_ID=NULL OR @p_PLAN_ID='') OR PLAN_ID = @p_PLAN_ID)
		ORDER BY PLAN_ID DESC

END
