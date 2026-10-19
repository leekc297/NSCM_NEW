/*
 * Program ID   : SCM0001_GET_CALENDAR_WEEK
 * Description  : Calendar Week 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/01/02   byunghunjung   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 *
 */
create PROCEDURE [dbo].[SCM0001_GET_CALENDAR_WEEK]
  
@p_from_yyyymmdd  NVARCHAR(MAX),
@p_to_yyyymmdd    NVARCHAR(MAX) 

AS
BEGIN
	
    SET NOCOUNT ON;

	SELECT 
		 q.basis_yyyymmdd
		,q.week_name
	FROM scm_sys_calendar_m q with(nolock)	
	WHERE 1=1
	AND q.basis_yyyymmdd >= @p_from_yyyymmdd
	AND q.basis_yyyymmdd <= @p_to_yyyymmdd
 
    ;

END


