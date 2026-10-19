

/*
 * Program ID   : [DMF0071_GET_RTF_VERSION]
 * Description  : 
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2024-03-13   KJJ				LGES SCM 역량 강화 위한 SCP 개선과제 이행
 * ex)
    EXEC DMF0071_GET_RTF_VERSION @p_division_id='40'
 */
CREATE PROCEDURE [dbo].[DMF0071_GET_RTF_VERSION]
 (
  	 @p_division_id		NVARCHAR(MAX)  

 )
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON;

	SELECT 
		MAX(ATTRIBUTE1)  RTF_VER_TXT--24BP_SCP_2023_W41_V01(화면표시)
		,MAX(PLAN_ID)  RTF_VER_PARAM--24BP_SCP_2023_W41_V01_003(파라미터 던질때)
	FROM SCP_ANL_BUSINESS_PLAN_RTF_DM WITH(NOLOCK) 
	WHERE DIVISION_ID = @p_division_id 

END
