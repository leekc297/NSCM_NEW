
/*
 * Program ID   : SCM0002_GET_SHIP_REQ_CHANGE_POPUP
 * Description  : BOD Popup 조회
  * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/01/15   byunghunjung   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 *
 */

CREATE PROCEDURE [dbo].[SCM0002_GET_SHIP_REQ_CHANGE_POPUP]
    @p_division_id   NVARCHAR(30),
	@p_bod_id		 NVARCHAR(30),
	@p_from_site	 NVARCHAR(30),
	@p_to_site		 NVARCHAR(30)
AS
BEGIN
	
	SET NOCOUNT ON;
  
	SELECT   
		 r.project_code
		,r.item_id
		,dbo.fn_get_item_nickname(r.division_id, r.item_id) as nick_name
		,b.transport_mode
		,r.qty as org_qty
		,rh.new_qty as new_qty
		,rh.update_reason_ship_req
		,getdate() as change_date
	from scp_anl_shipment_request r (NOLOCK)
	JOIN scm_mst_bod b (NOLOCK) ON r.division_id = b.division_id AND r.bod_id = b.bod_id
	--LEFT OUTER JOIN scm_mst_item_sn i (NOLOCK) ON r.division_id = i.division_id AND r.item_id = i.item_id
	LEFT OUTER JOIN scp_pln_shipment_request_h rh (NOLOCK) ON r.division_id = rh.division_id and r.bod_id =rh.bod_id and r.from_site = rh.from_site and r.to_site = rh.to_site 
	WHERE r.measure ='SHIP_REQ'
	AND r.division_id = '40'
	AND r.biz_type		= 'CELL'
	AND r.bod_id		= '2'
	AND r.from_site		= 'G183-E'
	AND r.to_site		= 'G182-A'
	AND r.yyyymmdd		= '20171222';
	/*
	WHERE r.division_id = @p_division_id--'40'
	AND r.bod_id		= @p_bod_id --'11'
	AND r.from_site		= @p_from_site --'a010-a'
	AND r.to_site		= @p_to_site -- 'ip_ar_05'
	*/
	;

END


