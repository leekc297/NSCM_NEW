
/*
 * Program ID   : SSP0006_GET_PLAN_PROBLEM
 * Description  : Problem Report 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/06/12   ygkim		   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 */
CREATE PROCEDURE [dbo].[SSP0006_GET_PLAN_PROBLEM]
	 @p_division_id				NVARCHAR(50) 
	, @p_Plan_Start_yyyymmdd	NVARCHAR(8) 
	, @p_PLAN_TYPE				NVARCHAR(50) 
	, @p_SEQ					bigint
	, @p_ENG_DEMAND_ID			NVARCHAR(1000) 
	, @p_ProblemType			NVARCHAR(40) 
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
		AND eng_demand_id		= @p_eng_demand_id
		AND eng_problem_type    = @p_problemtype
		--AND ( (@p_ENG_DEMAND_ID   IS NULL OR  @p_ENG_DEMAND_ID=''   ) OR ENG_DEMAND_ID = @p_ENG_DEMAND_ID)
		--AND ( (@p_ProblemType   IS NULL OR  @p_ProblemType=''   ) OR ENG_PROBLEM_TYPE = @p_ProblemType)

	order by a.problem_seq

END
