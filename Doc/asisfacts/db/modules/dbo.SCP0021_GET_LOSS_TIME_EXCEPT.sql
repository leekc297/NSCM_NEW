

/*
 * Program ID   : SCP0021_GET_LOSS_TIME
 * Description  : Loss Time
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/03/13   byunghunjung   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 ex) 
   EXEC SCP0021_GET_LOSS_TIME_EXCEPT @p_Division_Id='81', @p_Plant_Site='A040-A', @p_Building='A1', @p_Operation='A9000', @p_Line='A1A03'

 */

CREATE PROCEDURE [dbo].[SCP0021_GET_LOSS_TIME_EXCEPT]
  @p_Division_Id		NVARCHAR(MAX) ,
  @p_Plant_Site			NVARCHAR(MAX) ,
  @p_Building			NVARCHAR(MAX) ,
  @p_Operation			NVARCHAR(MAX) ,
  @p_Line				NVARCHAR(MAX)

AS

BEGIN
	SET NOCOUNT ON; 

	SELECT  
		 l.division_id
		,dbo.fn_get_division_name ( l.division_id ) AS division_name
		,s.scm_site_id  AS plant_site_id
		,dbo.fn_get_scm_site_description ( l.division_id, s.scm_site_id ) AS plant_site_name
		,l.factory_id
		,f.factory_name
		,l.operation_id
		,o.operation_name
		,l.line_id
		--,l.line_name
		,convert(datetime,t.loss_start_date) as loss_start_date
		,convert(datetime,t.loss_end_date) as loss_end_date
		,t.loss_time_min AS loss_time
		,t.setup_loss_time_min AS setup_loss_time
		,t.except_comment AS comment 
		,t.created_by
		,t.creation_date
		,t.last_updated_by
		,t.last_update_date
		-- 수정시 필요한 pk원본 값 2018-04-09 추가 pjs
		,t.division_id		as org_division_id
		,t.plant_site_id	as org_plant_site_id
		,t.factory_id		as org_factory_id
		,t.operation_id		as org_operation_id
		,t.line_id			as org_line_id
		,t.loss_start_date	as org_loss_start_date
		,t.loss_end_date	as org_loss_end_date
	FROM SCM_MST_LINE_SN l 
	INNER JOIN SCM_MST_SITE S ON l.company_id   = s.company_id 
							 AND l.division_id  = s.division_id 
							 AND l.site_id      = s.site_id 
							 AND l.plant_id     = s.plant_id 
	INNER JOIN SCM_MST_FACTORY_SN f ON l.company_id   = f.company_id 
								   AND l.division_id  = f.division_id 
								   AND l.site_id      = f.site_id 
								   AND l.plant_id     = f.plant_id 
								   AND l.factory_id   = f.factory_id 
								   AND s.operation_group = f.shop_group_id
	INNER JOIN SCM_MST_OPERATION_SN o  ON l.company_id   = o.company_id 
									  AND l.division_id  = o.division_id 
									  AND l.site_id      = o.site_id 
									  AND l.operation_id = o.operation_id
	INNER JOIN SCP_MST_LOSS_TIME_EXCEPT t ON l.division_id  = t.division_id 
									     AND s.SCM_SITE_ID  = t.plant_site_id
										 AND l.factory_id   = t.factory_id 
										 AND l.operation_id = t.operation_id 
										 AND l.line_id      = t.line_id
	WHERE 1=1
	AND s.valid_yn	 = 'Y'
	AND l.ACTIVE_FLAG ='Y'
		AND ( (@p_division_id IS NULL OR @p_division_id ='') OR T.DIVISION_ID   IN ( SELECT token FROM dbo.String_Split(@p_division_id	 ,',')) )
		AND ( (@p_Plant_Site  IS NULL OR @p_Plant_Site  ='') OR T.PLANT_SITE_ID IN ( SELECT token FROM dbo.String_Split(@p_Plant_Site	 ,',')) )
		AND ( (@p_Building    IS NULL OR @p_Building    ='') OR T.FACTORY_ID    IN ( SELECT token FROM dbo.String_Split(@p_Building	 ,',')) )
		AND ( (@p_Building    IS NULL OR @p_Building    ='') OR T.OPERATION_ID  IN ( SELECT token FROM dbo.String_Split(@p_Operation	 ,',')) )
		AND ( (@p_Line        IS NULL OR @p_Line        ='') OR T.LINE_ID       IN ( SELECT token FROM dbo.String_Split(@p_Line	 ,',')) )
	ORDER BY t.division_id , t.plant_site_id , t.factory_id , t.operation_id , t.line_id

END

