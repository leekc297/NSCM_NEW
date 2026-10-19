

/*
 * Program ID   : SCP0014_GET_PROBLEM_REPORT
 * Description  : Problem Report 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/02/21   byunghunjung   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/07/04   YHW			   ELECTRODE TYPE 조회조건 추가
 * 2018/07/18   byunghunjung   전극 조회조건 수정
 */
CREATE PROCEDURE [dbo].[SCP0014_GET_PEGGING_INFO]
	  @p_division_id				NVARCHAR(50) 
	, @p_Plan_Start_yyyymmdd	NVARCHAR(8) 
	, @p_PLAN_TYPE				NVARCHAR(50) 
	, @p_SEQ					bigint
	, @p_ENG_DEMAND_ID			NVARCHAR(1000) 
	, @p_item_id				NVARCHAR(50) 
	, @p_electrode_type			NVARCHAR(30) =NULL
AS
BEGIN
	SET NOCOUNT ON; 

	select
		a.pegging_operation_code ,
		b.segment2 as PEGGING_OPERATION ,
		a.item_id ,
		a.FROM_SITE ,
		a.to_site ,
		a.DUE_DATE ,
		a.PLAN_START_DATE ,
		a.PLAN_END_DATE ,
		--a.OPERATION_GROUP ,
		dbo.FN_GET_LOOKUP_CODE_DESC('BIZ_TYPE', a.OPERATION_GROUP) as OPERATION_GROUP ,
		ISNULL(NULLIF(a.ELECTRODE_TYPE,''),'-') as ELECTRODE_TYPE ,
		a.REQUIRED_QTY ,
		a.PLANNED_QTY ,
		--CONVERT(INT , a.PROBLEM_TYPE) AS PROBLEM_TYPE
		a.PROBLEM_TYPE AS PROBLEM_TYPE ,
		
		-- 2018.0430 추가 : LPST	STOCK_PLAN_LOT_ID
		a.LPST ,
		a.STOCK_PLAN_LOT_ID,
		ISNULL(NULLIF(a.ORIGIN_FROM_DIVISION_ID,''),'-') as ORIGIN_FROM_DIVISION_ID,
		ISNULL(NULLIF(a.ORIGIN_TO_DIVISION_ID,''),'-') as ORIGIN_TO_DIVISION_ID
	from SCP_ANL_PROBLEM_REPORT_PEGGING (nolock) a
	left join SCM_ADM_LOOKUP_MASTER_DETAIL (nolock) b on b.lookup_type='PEGGING_OPERATION' 
		and a.pegging_operation_code = b.SEGMENT1
	where 1=1
		AND division_id		    = @p_division_id
		AND plan_start_yyyymmdd = @p_Plan_Start_yyyymmdd
		AND PLAN_TYPE		    = @p_PLAN_TYPE
		AND SEQ				    = @p_SEQ
		AND ENG_DEMAND_ID		= @p_ENG_DEMAND_ID
		--AND ( (@p_ENG_DEMAND_ID   IS NULL OR  @p_ENG_DEMAND_ID=''   ) OR ENG_DEMAND_ID = @p_ENG_DEMAND_ID)
		--and ( (@p_item_id is null or @p_item_id = '') or item_id = @p_item_id) -- 모델기준 삭제 2018.04.18
		--and ( (@p_yyyymmdd is null or @p_yyyymmdd = '') or yyyymmdd = @p_yyyymmdd)
		--( (@p_electrode_type is null or @p_electrode_type = '') or ISNULL(NULLIF(a.ELECTRODE_TYPE,''),'-') = @p_electrode_type)
		AND (CASE WHEN @p_electrode_type = '-' THEN a.ELECTRODE_TYPE ELSE @p_electrode_type END ) = a.ELECTRODE_TYPE 		
	order by b.display_seq, PLAN_END_DATE desc,PLAN_START_DATE desc

END

