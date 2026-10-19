
/*
 * Program ID   : SCP0022_GET_FORMATION_EXCEPT_LT
 * Description  : Formation Except LT
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2025/09/22   KH 	            Initial Release  PJ20257329    최적화 Planning Input Constraint UI 개발 및 Master Validation 확산

 */

CREATE PROCEDURE [dbo].[SCP0022_GET_FORMATION_EXCEPT_LT]
	@p_division_id   NVARCHAR(30) ,
	@p_plant_site_id NVARCHAR(max) ,
	@p_item_id		 NVARCHAR(max)
AS

BEGIN
	
	SELECT 
		 a.division_id
		,a.plant_site_id
		,dbo.FN_GET_SCM_SITE_DESCRIPTION (a.division_id, a.plant_site_id ) as plant_site_name
		,a.item_id
		,dbo.fn_get_item_nickname(a.division_id, a.item_id) AS nick_name
		,CONVERT(DATE , b.formation_start_date) AS formation_start_date
		,CONVERT(DATE , b.formation_end_date) AS formation_end_date
		,b.LT_FORMATION  as LT_FORMATION
		,b.ADD_LT_FORMATION  as ADD_LT_FORMATION
		,b.except_comment
		,b.created_by 
		,b.creation_date 
		,b.last_updated_by 
		,b.last_update_date
		-- 수정시 필요한 pk원본 값 2018-04-09 추가 pjs
		,a.division_id as ORG_DIVISION_ID
		,a.plant_site_id as ORG_PLANT_SITE_ID
		,a.item_id as ORG_ITEM_ID
		,CONVERT(DATE , b.formation_start_date) AS ORG_FORMATION_START_DATE
		,CONVERT(DATE , b.formation_end_date) AS ORG_FORMATION_END_DATE
	FROM SCP_MST_FORMATION a (NOLOCK) 
	INNER JOIN SCP_OPMZ_MST_FORMATION_EXCEPT_LT b (NOLOCK)  ON a.division_id   = b.division_id
												           AND a.plant_site_id = b.plant_site_id
												           AND a.item_id       = b.item_id
	WHERE 1=1
	-- 205.09.23 수정
	-- AND a.division_id   = @p_division_id
	-- AND a.plant_site_id = @p_plant_site_id
	-- AND a.item_id       = @p_item_id

	AND ((@p_division_id   IS NULL OR  @p_division_id   = '') OR a.division_id   IN (SELECT token FROM dbo.String_Split(@p_division_id  ,',')))
	AND ((@p_plant_site_id IS NULL OR  @p_plant_site_id = '') OR a.plant_site_id IN (SELECT token FROM dbo.String_Split(@p_plant_site_id  ,',')))
	And ((@p_item_id       IS NULL OR  @p_item_id = '')       OR a.item_id       IN (SELECT token FROM dbo.String_Split(@p_item_id  ,',')))

	ORDER BY a.division_id , a.plant_site_id, a.item_id
	

END
