


/*
 * Program ID   : SCP0121_GET_PLAN_GROUP_POPUP
 * Description  : PLAN GROUP 정보 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2025/04/25   mrchois			PJ2024A332R 독립적 Planning 체계 및 Master Validation UI 구축 - Initial Release
 * 2025/06/05   mrchois			PJ2024A332R 독립적 Planning 체계 및 Master Validation UI 구축 - Target 대상, Onwer 정보 추가
 *
 */

CREATE PROCEDURE [dbo].[SCP0121_GET_PLAN_GROUP_POPUP]
  
  @p_division_id			NVARCHAR(MAX)

AS
BEGIN
	
    SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	--Plan Group 정보
	SELECT OPMZ_PLAN_GR_ID
		, OPMZ_PLAN_GR_NAME
		, OPMZ_PLAN_GR_DESC
		, OPMZ_TGT_DIVS_CD
		, OWNR_LST_CTN		AS OWNER
		, ATTRIBUTE1		AS OWNER_NAME
		, CREATED_BY
		, VALID_YN
	FROM SCP_OPMZ_PLAN_GR_M WITH(NOLOCK)
	WHERE 1=1
	AND DIVISION_ID = @p_division_id
	AND VALID_YN = 'Y'
  
END

