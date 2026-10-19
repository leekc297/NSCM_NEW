
/*
 * Program ID   : SCP0009_GET_SHIPMENT_PLAN_FG
 * Description  : Shipment Plan 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/04		kyh				Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 */
CREATE PROCEDURE [dbo].[SCP_GET_DEFAULT_DATE_RANGE]
	@p_plan_start_yyyymmdd	NVARCHAR(8),
	@p_add_days				int

AS
BEGIN
	declare @plan_start_date date = convert(date, @p_plan_start_yyyymmdd , 112);

	select 
		min(basis_yyyymmdd) + ':' + max(basis_yyyymmdd)
	from scm_sys_calendar_m a
	where A.BASIS_YYYYMMDD >= @p_plan_start_yyyymmdd and a.BASIS_YYYYMMDD <= convert(char(8), dateadd(DD, @p_add_days, @plan_start_date ) )


END

