
/*************************************************************************************************
* Program ID  : DMF0044_GET_TEXTBOX                                               
* Description : Procedure 작성 가이드                                                             
* Usage       : TextBox 를 열 때 사용. 생성된 VERSION_NO 를 조회할 때에는 날짜와 13개의 DESCRIPTION 받음.
* Parameter   :                                                                                  
*                                                                                                
*------------------------------------------------------------------------------------------------
* Date        In Charge    Description                                                           
*------------------------------------------------------------------------------------------------
* 2021-09-15   ROSIA27		[과제] TEXTBOX


***************************************************************************************************/

CREATE PROCEDURE [dbo].[DMF0044_GET_TEXTBOX]
	@P_VERSION_NO		NVARCHAR(50)
AS  
  
BEGIN
	SET NOCOUNT ON;

	DECLARE @YYYYMMDD			NVARCHAR(8)

	SELECT
		DESCRIPTION1
		, DESCRIPTION2
		, DESCRIPTION3
		, DESCRIPTION4
		, DESCRIPTION5
		, DESCRIPTION6
		, DESCRIPTION7
		, DESCRIPTION8
		, DESCRIPTION9
		, DESCRIPTION10
		, DESCRIPTION11
		, DESCRIPTION12
		, DESCRIPTION13
	FROM DM_MDF_VERSION (NOLOCK)
	WHERE 
		DIVISION_ID = '82'
		AND VERSION_NO = @P_VERSION_NO

	SELECT @YYYYMMDD = YYYYMMDD 
	FROM DM_MDF_VERSION 
	WHERE  
		DIVISION_ID = '82'
		AND VERSION_NO = @P_VERSION_NO 

	SELECT CONVERT(CHAR(11), DATEADD(DD, -7, dbo.FN_NEXT_DAY( @YYYYMMDD, 'MON')), 120) AS MONDAY

END
