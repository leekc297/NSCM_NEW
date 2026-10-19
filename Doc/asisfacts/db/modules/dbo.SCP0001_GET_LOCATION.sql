
/*
 * Program ID   : SCP0001_GET_LOCATION
 * Description  : Location 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017/12/05   byunghunjung   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2022/07/25   leejeongil     ERP 재고표기를 위한 SSP Storage 속성 추가 (SSP_STORAGE_ID) 
 *
 */

CREATE PROCEDURE [dbo].[SCP0001_GET_LOCATION]
  @p_division_id    NVARCHAR(30),
  @p_scm_site_id    NVARCHAR(30),
  @p_valid_yn		NVARCHAR(30)      
AS
BEGIN
	
    SET NOCOUNT ON;

	SELECT
	DISTINCT
	      l.location_seq
		 ,l.location_code
		 ,l.location_code location_code2
		 ,l.location_description
		 ,l.factory_id
		 ,l.factory_id as factory_id2
		 ,f.factory_name
		 ,l.operation_id
		 ,l.operation_id operation_id2
		 ,o.operation_name
		 ,l.electrode_type
		 ,l.storage_id
		 ,l.attribute2 as SSP_STORAGE_ID
		 ,l.valid_yn
		 ,l.created_by
		 ,l.creation_date
		 ,l.last_updated_by
		 ,l.last_update_date
		 ,LMD.DISPLAY_SEQ
	FROM SCM_MST_LOCATION L(NOLOCK)
	LEFT OUTER JOIN SCM_MST_FACTORY_SN F(NOLOCK) ON L.DIVISION_ID = F.DIVISION_ID AND L.PLANT_ID = F.PLANT_ID AND L.FACTORY_ID = F.FACTORY_ID
	LEFT OUTER JOIN SCM_MST_OPERATION_SN O(NOLOCK) ON L.DIVISION_ID = O.DIVISION_ID AND L.OPERATION_ID = O.OPERATION_ID
	LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LMD (NOLOCK) ON L.LOCATION_CODE = LMD.SEGMENT1 AND LMD.LOOKUP_TYPE = 'LOCATION_GROUP' AND LMD.VALID_YN = 'Y'
	WHERE 1=1
	  AND l.division_id = @p_division_id
	  AND l.scm_site_id = @p_scm_site_id
	  AND (@p_valid_yn is null or l.VALID_YN = @p_valid_yn)
 ORDER BY LMD.DISPLAY_SEQ, l.location_code, l.factory_id, l.operation_id
	;

END

