
/*
 * Program ID   : SCP0001_GET_LOCATION_OSP
 * Description  : Plant 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/08/10   ygkim			Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 */

CREATE PROCEDURE [dbo].[SCP0001_GET_LOCATION_OSP]
  @p_division_id    NVARCHAR(100),
  @p_scm_site_id    NVARCHAR(100), 
  @p_valid_yn		NVARCHAR(100)
AS
BEGIN
	
	SELECT 
		 a.division_id
		,a.plant_id
		,a.storage_id
		,a.scm_site_id
		,b.site_description as site_description
		,a.description
		,a.valid_yn
		,a.created_by
		,a.creation_date
		,a.last_updated_by
		,a.last_update_date
		,b.LOGISTIC_PLANT_ID
	FROM SCM_MST_OSP_SLOC A(NOLOCK)
	LEFT OUTER JOIN SCM_MST_SITE B(NOLOCK) ON  a.division_id = b.division_id AND a.scm_site_id = b.scm_site_id
	WHERE A.DIVISION_ID = @p_division_id
	  AND A.SCM_SITE_ID = @p_scm_site_id
	  AND (@p_valid_yn IS NULL OR A.VALID_YN = @p_valid_yn)	
	ORDER BY A.division_id, A.plant_id, A.scm_site_id
   ;
END

