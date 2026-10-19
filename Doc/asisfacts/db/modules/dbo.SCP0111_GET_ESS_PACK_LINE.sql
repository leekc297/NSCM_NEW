
/*
 * Program ID   : SCP0111_GET_ESS_PACK_LINE
 * Description  : ESS 팩 Prod plan Insert시 Line정보 표시용
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2025/03/25   mrchois			PJ20249548R  LGES SCP역량 강화를 위한 기준정보PSI엔진 기능개선 - ESS 팩 Prod plan Insert시 Line정보 표시용
 */

 CREATE PROCEDURE [dbo].[SCP0111_GET_ESS_PACK_LINE]

AS
BEGIN

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	SELECT 
		  L.DIVISION_ID
		  , L.SCM_SITE_ID
		  , S.SITE_DESCRIPTION
		  , S.COMPANY_ID
		  , L.LINE_ID		AS CODE
		  , L.LINE_NAME		AS NAME
		  , L.OPERATION_ID
	FROM SCM_MST_LINE_OSP L(NOLOCK)
	JOIN SCM_MST_SITE S(NOLOCK) 
		ON L.DIVISION_ID = S.DIVISION_ID AND L.SCM_SITE_ID = S.SCM_SITE_ID 
	WHERE 1=1
	  AND L.division_id  = '82'
	  AND L.valid_yn = 'Y'
	ORDER BY L.DIVISION_ID, L.SCM_SITE_ID, L.LINE_ID

END
