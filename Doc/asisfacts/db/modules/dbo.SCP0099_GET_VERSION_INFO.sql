
/*
 * Program ID   : [SCP0099_GET_VERSION_INFO]
 * Description  : 중장기계획 버전 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2023-07-25   KJJ				PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행 - 중장기계획 버전 조회

 * ex)
    EXEC SCP0099_GET_VERSION_INFO @p_division_id='81'
 */
CREATE PROCEDURE [dbo].[SCP0099_GET_VERSION_INFO]
 (
  	 @p_division_id		NVARCHAR(MAX)  
 )
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON;

	SELECT [VERSION_NO]
		  ,[VERSION_DESCRIPTION]
	  FROM [dbo].[DM_MST_VERSION] WITH(NOLOCK)
		WHERE DIVISION_ID = @p_division_id
		AND VERSION_TYPE = 'BP_M'
		--AND YYYYMMDD > CONVERT(VARCHAR,  DATEADD(YEAR, -1, GETDATE()), 112) --1년전 이후 꺼 다 보이게 함(김성기 책임님 확인)
		AND YYYYMMDD > CONVERT(VARCHAR,  DATEADD(MONTH, -2, GETDATE()), 112)--60일 이전부터 보이게 수정(신재욱 책임님 확인)

		ORDER BY VERSION_NO DESC

END
