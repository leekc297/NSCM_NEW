



/*
 * Program ID   : SSP0009_GET_SHIPMENT_PLAN_FG_PROBLEM
 * Description  : Plan Problem 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2018/08/21	hwyoon			Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 */
CREATE PROCEDURE [dbo].[SSP0009_GET_SHIPMENT_PLAN_FG_PROBLEM]
	 @p_division_id			NVARCHAR(30)
	, @p_plan_start_yyyymmdd	NVARCHAR(8) 
	, @p_plan_type				NVARCHAR(50)
	, @p_seq					bigint 
	, @p_item_id				NVARCHAR(50)
	, @p_project_code			nvarchar(50)
	--, @p_biz_type				nvarchar(1)
	, @p_to_site				nvarchar(50)
	, @p_duedate				nvarchar(8)
AS
BEGIN
	SET NOCOUNT ON; 

	select
		a.problem_seq ,
		a.ENG_PROBLEM_TYPE ,
		a.ENG_PROBLEM_DESC ,
		a.REQUEST_TIME ,
		a.RESPONSE_TIME ,
		convert(int, a.problem_qty) as problem_qty
		--, a.CREATED_BY
		--, a.CREATION_DATE
		--, a.LAST_UPDATED_BY
		--, a.LAST_UPDATE_DATE
	from SSP_ANL_PROBLEM_REPORT_DESC (nolock) a
	where 1=1
		AND division_id		    = @p_division_id
		AND plan_start_yyyymmdd = @p_Plan_Start_yyyymmdd
		AND plan_type		    = @p_plan_type
		AND seq				    = @p_seq
		and dbo.fn_scm_split(a.[eng_demand_id],1,'::') = @p_item_id
		and dbo.fn_scm_split(a.[eng_demand_id],2,'::') = @p_project_code
		and dbo.fn_scm_split(a.[eng_demand_id],3,'::') = @p_to_site
		and dbo.fn_scm_split([eng_demand_id],6,'::') = @p_duedate
		--and REQUEST_TIME = CONVERT(DATETIME , @p_duedate)
		--AND eng_demand_id		= @p_eng_demand_id
		--AND eng_problem_type    = @p_problemtype

	order by a.problem_seq

END



