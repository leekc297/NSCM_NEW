
/*
 * Program ID   : SCP0022_GET_FORMATION_EXCEPT
 * Description  : Formation Except
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2018/05/09   byunghunjung	Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/08/08   byunghunjung	item_id 2번째 자리가 C인 모델만 검색
 * 2018/04/08	hwyoon			[CSR:]GSCM 고도화 - Formation 수율 필드 추가, 기능개선
 */

create PROCEDURE [dbo].[SCP0022_GET_FORMATION_EXCEPT_0923수정전]
	@p_division_id   NVARCHAR(30) ,
	@p_plant_site_id NVARCHAR(30) ,
	@p_item_id		 NVARCHAR(100)
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
		--,ROUND(b.formation_yield*100,2)  as formation_yield
		--,b.formation_yield
		,ROUND(b.formation_yield*100,2)  as formation_yield
		,ROUND(b.CHAR_YIELD*100,2)  as CHAR_YIELD
		,ROUND(b.FORMATION_TOTAL_YIELD*100,2)  as FORMATION_TOTAL_YIELD
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
	INNER JOIN SCP_MST_FORMATION_EXCEPT b (NOLOCK)  ON a.division_id   = b.division_id
												   AND a.plant_site_id = b.plant_site_id
												   AND a.item_id       = b.item_id
	WHERE 1=1
	AND a.division_id   = @p_division_id
	AND a.plant_site_id = @p_plant_site_id
	AND a.item_id       = @p_item_id
	--AND substring(a.item_id,2,1) = 'C'
	ORDER BY a.division_id , a.plant_site_id, a.item_id
	

END
