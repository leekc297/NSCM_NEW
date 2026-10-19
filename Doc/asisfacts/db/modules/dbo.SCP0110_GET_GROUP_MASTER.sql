
/*
 * Program ID   : SCP0110_GET_GROUP_MASTER
 * Description  : GROUP 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2024/05/22   mrchois    PJ20244573 LGES SCM SCP 생산모델 기반 공급계획 수립체계 구성
 * 2025-08-14   twinlove   PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - Only Stock(Y/N) 추가 attribute1
 
 */

 CREATE PROCEDURE [dbo].[SCP0110_GET_GROUP_MASTER]
   @p_division_id			NVARCHAR(MAX)
  ,@p_operation_group		NVARCHAR(MAX)
  ,@p_group_name			NVARCHAR(MAX)

AS
BEGIN

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	--GROUP 조회
	SELECT DIVISION_ID, OPERATION_GROUP,  GROUP_ID, GROUP_NAME, ATTRIBUTE1 as ONLY_STOCK  --PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산
	FROM SCP_MST_ITEM_GROUP WITH(NOLOCK)
	WHERE 1=1
	AND DIVISION_ID = @p_division_id
	AND ( (@p_operation_group IS NULL OR  @p_operation_group = '') OR OPERATION_GROUP = @p_operation_group)
	AND ((@p_group_name IS NULL OR @p_group_name = '') OR (GROUP_ID LIKE '%' + @p_group_name + '%' OR GROUP_NAME LIKE '%' + @p_group_name + '%'))	
	ORDER BY DIVISION_ID, OPERATION_GROUP, GROUP_ID
   ;

END