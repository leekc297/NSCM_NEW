

/**
  * PROJECT       : LG CHEM SCP PRJ.
  * VIEW NAME     : [FN_SCP_PLAN_VERSION_V1]
  * DESCRIPTION   : SCP 엔진수행 버전조회용 함수 (SCP_PLAN_VERSION_V view 컨버젼)
  *
  * PROGRAM HISTORY
  *--------------------------------------------------------------
  *  DATE      IN CHARGE           DESCRIPTION
  *--------------------------------------------------------------
  * 2018-02-26   pjs        INITIAL
  * 2018-12-20   pjs        CREATE
  */

CREATE FUNCTION [dbo].[FN_SCP_PLAN_VERSION_V1]  
(
 @p_division_id Varchar(1000)
,@p_plan_type Varchar(1000) =''
,@p_plan_year Varchar(1000) =''
,@p_plan_week Varchar(1000) =''
)
RETURNS @Product_Plan_Version1 TABLE
(
	   modeling_id NVARCHAR(1000)
	  ,division_id NVARCHAR(1000)
      ,plan_version_id NVARCHAR(1000)
      ,plan_start_yyyymmdd NVARCHAR(1000)
      ,plan_type NVARCHAR(1000)
	  ,plan_status  NVARCHAR(1000)
	  ,plan_status_name  NVARCHAR(1000)
      ,plan_type_order NVARCHAR(1000)   
	  ,plan_id NVARCHAR(1000)   
	  
)AS
BEGIN

	INSERT @Product_Plan_Version1
	SELECT modeling_id
		  ,division_id
		  ,max(plan_version_id) as plan_version_id
		  ,plan_name as plan_start_yyyymmdd
		  ,plan_type
		  ,plan_status
		  ,DBO.FN_GET_LOOKUP_CODE_DESC('PLAN_RUN_STATUS',plan_status) AS plan_status_name
		  ,case(plan_type) when 'PR' then 0 when 'MA' then 1 when 'SE' then 3 when 'FN' then 4 else 9 end as plan_type_order
		  ,plan_id
	FROM (			  
			select m.modeling_id
			  	   ,d.division_id
				   ,p.plan_name+'-'+d.plan_type+'-'+ dbo.fn_zero_lpad(convert(nvarchar,d.plan_seq),2)  as plan_version_id
				   ,p.plan_name
				   ,d.plan_type
				   ,d.plan_status
				   ,d.plan_id
			  from dbo.scm_mst_plan_detail d with(nolock),
				   dbo.scm_mst_plan        p with(nolock),
				   dbo.scm_mst_modeling    m with(nolock),
				   dbo.scm_sys_calendar_m  o  with(nolock) 
			 where 1=1
			   AND m.modeling_id = d.modeling_id
			   AND m.plan_cycle  = 'WEEKLY'
			   AND m.division_id = d.division_id
			   AND m.modeling_id = d.modeling_id
			   AND p.division_id = d.division_id
			   AND p.plan_cycle  = m.plan_cycle
			   AND p.plan_id     = d.plan_id
			   AND p.plan_name   = o.basis_yyyymmdd	
			   --AND d.division_id    = '81'
 		   	   AND ( (@p_plan_year ='' OR @p_plan_year IS NULL) OR  d.division_id    = @p_division_id)
	           AND ( (@p_plan_year ='' OR @p_plan_year IS NULL) OR  o.calendar_yyyy  = @p_plan_year )
	           AND ( (@p_plan_week ='' OR @p_plan_week IS NULL) OR  o.week_name      = @p_plan_week )
	           AND ( (@p_plan_type ='' OR @p_plan_type IS NULL) OR  d.plan_type      = @p_plan_type )
			   AND p.plan_name >= (select [dbo].[FN_GET_BUCKET_YYYYMMDD](-10) ) --10주전 : 적용여부 확인필요
		  )  M
	 	
	   group by modeling_id,division_id,plan_name,plan_type,plan_status,plan_id
	   ORDER BY plan_type_order, plan_version_id DESC
	  
		RETURN;
END;

