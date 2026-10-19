
/*
 * Program ID   : SCP0013_GET_EXTRA_SPEC
 * Description  : Extra Spec 조회조건 정보 표시용
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2025/04/02   mrchois			PJ20249548R  LGES SCP역량 강화를 위한 기준정보PSI엔진 기능개선 - Extra Spec 조회조건 추가 표시
 */

 CREATE PROCEDURE [dbo].[SCP0013_GET_EXTRA_SPEC]
	@p_division_id			NVARCHAR(50)		= N''
AS
BEGIN

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	SELECT SCP_OPERATION_GROUP			AS OPERATION_GROUP
		, ISNULL(SCP_EXTRA_SPEC, '-')	AS CODE
		, ISNULL(SCP_EXTRA_SPEC, '-')	AS NAME
	FROM	DBO.SCM_MST_ITEM_SN X  
	WHERE	1=1 
	AND X.DIVISION_ID = @p_division_id
	GROUP BY SCP_OPERATION_GROUP, SCP_EXTRA_SPEC
	ORDER BY CODE

END
