
/*
 * Program ID   : SCP0021_GET_LOSS_TIME
 * Description  : Loss Time
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2018/03/13   byunghunjung	Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/11/12   hwyoon			big data last update date 추가
 */

CREATE PROCEDURE [dbo].[SCP0021_GET_LOSS_TIME]
  @p_Division_Id		NVARCHAR(MAX) ,
  @p_Plant_Site			NVARCHAR(MAX) ,
  @p_Building			NVARCHAR(MAX) ,
  @p_Operation			NVARCHAR(MAX) ,
  @p_Line				NVARCHAR(MAX)

AS

BEGIN
	SET NOCOUNT ON; 

	SELECT  DISTINCT
		L.DIVISION_ID
		,dbo.fn_get_division_name ( l.division_id ) as DIVISION_NAME
		,S.SCM_SITE_ID  AS PLANT_SITE_ID
		,dbo.fn_get_scm_site_description ( l.division_id, s.scm_site_id ) as PLANT_SITE_NAME
		,L.FACTORY_ID
		,F.FACTORY_NAME
		,L.OPERATION_ID
		,O.OPERATION_NAME
		,L.LINE_ID
		--,L.LINE_NAME
		,T.LOSS_TIME_MIN AS LOSS_TIME
		,B.LOSS_TIME_MIN AS LOSS_TIME_BIG
		,T.SETUP_LOSS_TIME_MIN AS SETUP_LOSS_TIME
		,B.SETUP_LOSS_TIME_MIN AS SETUP_LOSS_TIME_BIG
		, t.CREATED_BY
		, t.CREATION_DATE
		, t.LAST_UPDATED_BY
		, t.LAST_UPDATE_DATE
		, (CASE WHEN t.LOSS_TIME_MIN IS NULL THEN '1' ELSE '2' END) AS loss_time_order
		, b.last_update_date big_last_update_date
	FROM SCM_MST_LINE_SN L 
	JOIN SCM_MST_SITE S          on l.company_id   = s.company_id 
		AND l.division_id  = s.division_id 
		AND l.site_id      = s.site_id 
		AND l.plant_id     = s.plant_id 
	JOIN SCM_MST_FACTORY_SN f    on l.company_id   = f.company_id 
		AND l.division_id  = f.division_id 
		AND l.site_id      = f.site_id 
		AND l.plant_id     = f.plant_id 
		AND l.factory_id   = f.factory_id 
		AND s.operation_group = f.shop_group_id
	JOIN SCM_MST_OPERATION_SN o  on l.company_id   = o.company_id 
		AND l.division_id  = o.division_id 
		AND l.site_id      = o.site_id 
		AND l.operation_id = o.operation_id
	LEFT OUTER JOIN SCP_MST_LOSS_TIME t  on l.division_id   = t.division_id 
		AND s.SCM_SITE_ID = t.plant_site_id
		AND l.factory_id    = t.factory_id 
		AND l.operation_id  = t.operation_id 
		AND l.line_id       = t.line_id
	LEFT OUTER JOIN SCP_MST_LOSS_TIME_BIG b  on l.division_id   = b.division_id 
		AND s.SCM_SITE_ID = b.plant_site_id
		AND l.factory_id    = b.factory_id 
		AND l.operation_id  = b.operation_id 
		AND l.line_id       = b.line_id
	WHERE 1=1
	    AND s.valid_yn	 = 'Y'
		AND l.ACTIVE_FLAG ='Y'
		AND l.operation_id IN (
								SELECT DISTINCT b.SEGMENT4
								FROM   scm_adm_lookup_master_detail b WITH(NOLOCK)
								WHERE  b.lookup_type = 'LOCATION_GROUP_ROUTE'
								AND    b.valid_yn = 'Y'
								AND    b.segment3 = 'Y')
		AND s.site_type    = 'PLANT'
		AND l.division_id  = @p_division_id
		AND (isnull(@p_Plant_Site,   '' ) = '' OR S.SCM_SITE_ID   IN ( SELECT token FROM dbo.String_Split(@p_Plant_Site	 ,',')) )
		AND (isnull(@p_Building  ,   '' ) = '' OR L.FACTORY_ID   IN ( SELECT token FROM dbo.String_Split(@p_Building	 ,',')) )
		AND (isnull(@p_Operation,   '' ) = '' OR L.OPERATION_ID   IN ( SELECT token FROM dbo.String_Split(@p_Operation	 ,',')) )
		AND (isnull(@p_Line,   '' ) = '' OR L.LINE_ID   IN ( SELECT token FROM dbo.String_Split(@p_Line	 ,',')) )
	ORDER BY loss_time_order, L.DIVISION_ID, S.SCM_SITE_ID , L.FACTORY_ID , L.OPERATION_ID , L.LINE_ID
   ;

END
