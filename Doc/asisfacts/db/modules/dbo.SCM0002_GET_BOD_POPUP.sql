
/*
 * Program ID   : SCM0002_GET_BOD_POPUP
 * Description  : BOD Popup 조회
  * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/01/15   byunghunjung   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 *
 */

CREATE procedure [dbo].[SCM0002_GET_BOD_POPUP]
    @p_division_id   NVARCHAR(30),
	@p_bod_id		 NVARCHAR(30),
	@p_from_site	 NVARCHAR(30),
	@p_to_site		 NVARCHAR(30)
AS
BEGIN
	
	SET NOCOUNT ON;
  
	SELECT 
		'' as chk
		, '' as is_lock
		, (m.DIVISION_ID + m.FROM_SITE + m.TO_SITE) as key_idx
		, m.bod_id
		, m.from_site
		, m.to_site
		, m.priority
		, m.incoterms
		, m.transport_mode
		, m.period_shipsch_mon
		, m.period_shipsch_tue
		, m.period_shipsch_wed
		, m.period_shipsch_thu
		, m.period_shipsch_fri
		, m.period_shipsch_sat
		, m.period_shipsch_sun
		, m.pol
		, m.pod
		, (period1_lt + period2_lt + period3_lt) AS lt
		, r.update_reason_bod 
	FROM scm_mst_bod m  WITH(NOLOCK)
	LEFT OUTER JOIN scp_anl_shipment_plan_semi_h r  WITH(NOLOCK) ON m.division_id = r.division_id and m.bod_id =r.bod_id
		and m.from_site = r.from_site and m.to_site = r.to_site 
	WHERE 1=1
	AND m.division_id = @p_division_id--'40'
	--AND m.bod_id		= @p_bod_id --'11'
	AND m.from_site		= @p_from_site --'a010-a'
	--AND m.to_site		= @p_to_site -- 'ip_ar_05'
	AND m.bod_type		= 'PRODUCTION'
	;

END
