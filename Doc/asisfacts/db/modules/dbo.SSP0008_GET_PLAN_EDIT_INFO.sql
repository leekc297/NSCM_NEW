/*
 * Program ID   : SSP0008_GET_PLAN_EDIT_INFO
 * Description  : PLAN 별 편집가능 여부 정보 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/06/12   PJS    			Initial Release  전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트

 * ex)
  EXEC SSP0008_GET_PLAN_EDIT_INFO @p_division_id='82', @p_operation_group='P', @p_scm_site_id='', @p_line_id='-', @p_item_id='', @p_from_yyyymmdd='20180507', @p_to_yyyymmdd='20181111', @p_plan_start_yyyymmdd='20180507', @p_plan_type='MA', @p_seq='5', @debug_mode='F'

 */

create PROCEDURE [dbo].[SSP0008_GET_PLAN_EDIT_INFO] 
	 @p_division_id		NVARCHAR(50) 
	,@p_operation_group	NVARCHAR(50) 
	,@p_scm_site_id		NVARCHAR(MAX) 
	,@p_line_id			NVARCHAR(MAX) 
	,@p_item_id			NVARCHAR(MAX) 
	,@p_from_yyyymmdd	NVARCHAR(8)
    ,@p_to_yyyymmdd		NVARCHAR(8)
	,@p_plan_start_yyyymmdd  NVARCHAR(8)
	,@p_plan_type			NVARCHAR(50)
	,@p_seq					NVARCHAR(50)
    ,@debug_mode			NVARCHAR(20)  ='F'
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON;

	DECLARE @v_plan_version NVARCHAR(100)

	SELECT  DISTINCT
			division_id+scm_site_id+plan_name+plan_type+convert(varchar,plan_seq) as cp_key
	      , division_id
		  , scm_site_id
		  , plan_version_id
		  , plan_name AS plan_start_yyyymmdd
		  , plan_type
		  , plan_seq
		  , osp_yn
		  , fp_plan_period
		  , offset
		  , CONVERT(VARCHAR, CONVERT(DATETIME, plan_name )+offset,112) AS edit_start_date
		  , CASE plan_type WHEN 'PR' THEN 0 WHEN 'MA' THEN 1 WHEN 'SE' THEN 3 WHEN 'FI' THEN 4 ELSE 9 END AS plan_type_order
		  , confirm_yn
		  , CASE WHEN plan_name<basis_start_date THEN 'N' ELSE 'Y' END AS date_chk
		  , CASE WHEN plan_type ='MA' AND confirm_yn='Y' AND plan_name>=basis_start_date THEN 'Y'
			     WHEN plan_type ='SE' AND plan_name>=basis_start_date  THEN 'Y'
				 WHEN plan_type ='PR' AND plan_name>=basis_start_date  THEN 'Y'   
				 ELSE 'N'
			END AS is_editable
			
	FROM (
		
		SELECT m.division_id
		      ,m.plan_version_id
			  ,m.plan_name
			  ,m.plan_seq
			  ,m.plan_type
			  ,m.confirm_yn
			  ,n.SCM_SITE_ID
			  ,p.osp_yn
			  ,p.fp_plan_period
			  ,CASE WHEN m.plan_type ='PR' THEN 0
					WHEN m.plan_type ='MA' THEN p.offset -7
					ELSE p.offset 			  
			   END  as offset

			  --,'20180501' basis_start_date
			  ,m.basis_start_date
		  FROM (
				select *
				  from(
						SELECT  d.division_id
								,p.plan_name+'-'+d.plan_type+'-'+ dbo.fn_zero_lpad(CONVERT(NVARCHAR,d.plan_seq),2)  AS plan_version_id
								,p.plan_name
								,d.plan_seq
								,d.plan_type	
								,CASE WHEN ISNULL(d.CONFIRM_FLAG,'')='' THEN 'N' ELSE d.CONFIRM_FLAG END AS confirm_yn			   
							FROM scm_mst_plan_detail d ,
								 scm_mst_plan        p ,
								 scm_mst_modeling    m 
							WHERE 1=1
							and m.modeling_id = d.modeling_id
							and m.plan_cycle  = 'WEEKLY'
							and m.division_id = d.division_id
							and m.modeling_id = d.modeling_id
							and p.division_id = d.division_id
							and p.plan_cycle  = m.plan_cycle
							and p.plan_id     = d.plan_id	
							and plan_name     >= dbo.fn_get_bucket_yyyymmdd(-10) --10주전
							and d.division_id = @p_division_id
							and d.plan_type   = @p_plan_type
							and d.plan_seq    = @p_seq
							and p.plan_name   = @p_plan_start_yyyymmdd
						) a
						CROSS JOIN (
									SELECT convert(VARCHAR(8), dateadd(dd, -(dayofweek_no-1),basis_yyyymmDD),112) as basis_start_date
									 FROM (
											SELECT (CASE WHEN DAYOFWEEK_NO -1 =0 THEN 7 ELSE dayofweek_no -1 END ) dayofweek_no ,CONVERT(DATETIME, basis_yyyymmDD) as basis_yyyymmDD,DAYOFWEEK
											  FROM scm_sys_calendar_m 
											 WHERE basis_yyyymmdd =convert(VARCHAR(8), GETDATE(),112)
  										  ) f						
									) b
			) m
			INNER JOIN ssp_anl_production_plan n ON m.division_id = n.division_id
											  AND m.plan_name     = n.plan_start_yyyymmdd
											  AND m.plan_type     = n.plan_type
											  AND m.plan_seq      = n.seq
								  			  AND n.line_id			     <> '*'
											  AND n.measure              = upper('PROD_PLAN_AMEND')
											  AND n.yyyymmdd			 >= @p_from_yyyymmdd
											  AND n.yyyymmdd			 <= @p_to_yyyymmdd		
											  AND n.division_id	         = @p_division_id
											  AND n.operation_group      = @p_operation_group
											  AND n.plan_start_yyyymmdd  = @p_plan_start_yyyymmdd
											  AND n.plan_type            = @p_plan_type
											  AND n.seq				   = @p_seq	
											  AND ( ( @p_scm_site_id IS NULL OR     @p_scm_site_id     ='' ) OR n.scm_site_id     IN (SELECT token FROM dbo.String_Split(@p_scm_site_id,',')) )
											  AND ( ( @p_item_id IS NULL OR         @p_item_id         ='' ) OR n.item_id         IN (SELECT token FROM dbo.String_Split(@p_item_id    ,',')) )
											  AND ( ( @p_line_id IS NULL OR         @p_line_id         ='' ) OR n.line_id         IN (SELECT token FROM dbo.String_Split(@p_line_id    ,',')) )

			LEFT OUTER JOIN (SELECT division_id
								   ,scm_site_id
								   ,osp_yn
								   ,fp_plan_period 
								   ,CASE WHEN osp_yn ='Y' THEN 0 ELSE fp_plan_period END AS offset
							FROM scm_mst_site
							WHERE division_id = @p_division_id
						) p ON n.division_id = p.division_id
						   AND n.scm_site_id = p.scm_site_id
      ) L
END
