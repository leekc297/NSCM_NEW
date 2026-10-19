

/*
 * Program ID   : SSP0009_GET_SHIPMENT_PLAN_FG_PEGGING
 * Description  : Shipment Plan - pegging 조회
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/06/19	YHW				Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/07/06   ygkim			@p_electrode_type 파리미터, ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID 컬럼 추가
 * 2018/08/21	YHW				조인조건 수정(데이터 출력 오류 수정)
 EX)
 EXEC SSP0009_GET_SHIPMENT_PLAN_FG_PEGGING @p_division_id='81', @p_plan_start_yyyymmdd='20180514', @p_plan_type='MA', @p_seq=2, @p_item_id='ACPP1015U-B1', @p_biz_type='A', @p_to_site='BAE_US_ENC', @p_duedate='20180528'

 */
CREATE PROCEDURE [dbo].[SSP0009_GET_SHIPMENT_PLAN_FG_PEGGING]
	  @p_division_id			NVARCHAR(30)
	, @p_plan_start_yyyymmdd	NVARCHAR(8) 
	, @p_plan_type				NVARCHAR(50)
	, @p_seq					bigint 
	, @p_item_id				NVARCHAR(50)
	, @p_biz_type				nvarchar(1)
	, @p_to_site				nvarchar(50)
	, @p_duedate				nvarchar(8)
	, @p_project_code			nvarchar(50)
	, @p_electrode_type		    NVARCHAR(60) = ''
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
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
		dbo.FN_GET_LOOKUP_CODE_DESC('BIZ_TYPE', a.OPERATION_GROUP) as OPERATION_GROUP ,
		ISNULL(NULLIF(origin_from_division_id,''),'-') origin_from_division_id,
		ISNULL(NULLIF(origin_to_division_id,''),'-') origin_to_division_id,
		ISNULL(NULLIF(electrode_type,''),'-') electrode_type,
		a.REQUIRED_QTY ,
		a.PLANNED_QTY ,
		a.PROBLEM_TYPE AS PROBLEM_TYPE ,
		a.LPST ,
		a.STOCK_PLAN_LOT_ID
	from SSP_ANL_PROBLEM_REPORT_PEGGING (nolock) a
	left join SCM_ADM_LOOKUP_MASTER_DETAIL (nolock) b on b.lookup_type='PEGGING_OPERATION' 
		and a.pegging_operation_code = b.SEGMENT1
	where a.division_id = @p_division_id
		and a.PLAN_START_YYYYMMDD = @p_Plan_Start_yyyymmdd
		and a.PLAN_TYPE = @p_PLAN_TYPE
		and a.SEQ = @p_SEQ
		and a.pegging_operation_code in ('ALLOC','PSHIP','CSHIP','ESHIP')
		and a.OPERATION_GROUP = @p_biz_type
		and a.TO_SITE = @p_to_site
		and a.ITEM_ID = @p_item_id
		and a.DUE_DATE = CONVERT(DATETIME , @p_duedate)
		and dbo.fn_scm_split(a.[eng_demand_id],2,'::') = @p_project_code
		--AND ( (@p_electrode_type   IS NULL OR  @p_electrode_type=''   ) OR a.electrode_type = @p_electrode_type)
		AND ISNULL(NULLIF(A.ELECTRODE_TYPE,''),'-') = ISNULL(NULLIF(@p_electrode_type,''),'-')

END

