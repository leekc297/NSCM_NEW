
/*
 * Program ID   : SCP0110_GET_MODEL_LIST
 * Description  : MODEL LIST 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2024/05/22   mrchois    PJ20244573 LGES SCM SCP 생산모델 기반 공급계획 수립체계 구성
 
 */

 CREATE PROCEDURE [dbo].[SCP0110_GET_MODEL_LIST]
   @p_division_id			NVARCHAR(MAX)
  ,@p_operation_group		NVARCHAR(MAX)
  ,@p_group_id				NVARCHAR(MAX)
  ,@p_group_name			NVARCHAR(MAX)
  ,@p_project_id			NVARCHAR(MAX)
  ,@p_item_id				NVARCHAR(MAX)

AS
BEGIN

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @v_cell_attribute8		NVARCHAR(MAX)
	SET @v_cell_attribute8 = ''

	--Cell(A)의 경우 완제품만 표시하도록
	IF (@p_operation_group = 'A')
		SET @v_cell_attribute8 = 'CP'

	-- MODEL LIST 조회
	SELECT a.DIVISION_ID
		, a.PROJECT_CODE
		, ISNULL(d.PROJECT_NAME, a.PROJECT_CODE) AS PROJECT_NAME
		, a.ITEM_ID
		, a.GROUP_ID
		--, b.GROUP_NAME
	FROM SCP_MST_ITEM_GROUP_DETAIL a WITH(NOLOCK)
	LEFT JOIN SCP_MST_ITEM_GROUP b WITH(NOLOCK) ON b.GROUP_ID = a.GROUP_ID
	LEFT JOIN SCP_MST_FINAL_ITEM c WITH(NOLOCK) ON c.DIVISION_ID = @p_division_id AND c.ITEM_ID = a.ITEM_ID
	LEFT JOIN SCM_MST_PROJECT d WITH(NOLOCK) ON d.DIVISION_ID = a.DIVISION_ID AND d.PROJECT_CODE = a.PROJECT_CODE
	WHERE 1=1
	AND (@p_division_id IS NULL OR a.DIVISION_ID IN  ( SELECT token FROM dbo.String_Split(@p_division_id,',') ) )
	AND ( (@p_operation_group IS NULL OR  @p_operation_group = '') OR c.OPERATION_GROUP = @p_operation_group)
	AND ( (@v_cell_attribute8 IS NULL OR  @v_cell_attribute8 = '') OR c.ATTRIBUTE8 = @v_cell_attribute8)
	AND ( (@p_group_id IS NULL OR  @p_group_id = '') OR A.GROUP_ID = @p_group_id)
	AND ((@p_group_name IS NULL OR @p_group_name = '') OR (A.GROUP_ID LIKE '%' + @p_group_name + '%' OR b.GROUP_NAME LIKE '%' + @p_group_name + '%'))		
	AND ( ( @p_project_id IS NULL OR  @p_project_id = '' ) OR a.PROJECT_CODE IN (SELECT token FROM dbo.String_Split(@p_project_id  ,',')) )				
	AND ( ( @p_item_id IS NULL OR  @p_item_id = '' ) OR a.item_id IN (SELECT token FROM dbo.String_Split(@p_item_id  ,',')) )
	--Group이 지정된 모델에 대하여 정렬 순서를 1순위로 올리고 나머지는 정렬 순서는 그대로 유지 
	ORDER BY (CASE WHEN ISNULL(a.GROUP_ID,'') = '' THEN 1 ELSE 0 END), a.GROUP_ID, a.DIVISION_ID, a.PROJECT_CODE, a.ITEM_ID	
    ;

END