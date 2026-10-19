/*
 * Program ID   : SSP0007_GET_PLAN_EDIT_INFO
 * Description  : PLAN 별 편집가능 여부 정보 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/06/11   PJS    			Initial Release  전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트

 * ex)
    EXEC SSP0007_GET_PLAN_EDIT_INFO @p_division_id='81', @p_scm_site_id='A040-P', @p_plan_start_yyyymmdd='20180613', @p_plan_type='SP', @p_seq='1', @debug_mode='F'
 */

create PROCEDURE [dbo].[SSP0007_GET_PLAN_EDIT_INFO] 
	 @p_division_id			NVARCHAR(50) 
	,@p_scm_site_id			NVARCHAR(150) 
	,@p_plan_start_yyyymmdd NVARCHAR(8)
	,@p_plan_type			NVARCHAR(50)
	,@p_seq					NVARCHAR(50)
    ,@debug_mode			NVARCHAR(20)  ='F'
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON;

	DECLARE @v_plan_version NVARCHAR(100)

	SELECT  division_id
		  , a.plan_version_id
		  , plan_name AS plan_start_yyyymmdd
		  , plan_type
		  , plan_seq
		  , c.osp_yn
		  , c.fp_plan_period
		  , CASE WHEN plan_type ='PR' THEN 0
		         WHEN plan_type ='MA' THEN c.offset -7
		    ELSE c.offset END offset
		  , CONVERT(VARCHAR, CONVERT(DATETIME, plan_name )+(CASE WHEN plan_type ='PR' THEN 0 ELSE c.offset END),112) AS edit_start_date
		  , CASE plan_type WHEN 'PR' THEN 0 WHEN 'MA' THEN 1 WHEN 'SE' THEN 3 WHEN 'FI' THEN 4 ELSE 9 END AS plan_type_order
		  , confirm_yn
		  , CASE WHEN plan_name<basis_start_date THEN 'N' ELSE 'Y' END AS date_chk
		  , CASE WHEN plan_type ='MA' AND confirm_yn='Y' AND plan_name>=basis_start_date THEN 'Y'
			     WHEN plan_type ='SE' AND plan_name>=basis_start_date  THEN 'Y'
				 WHEN plan_type ='PR' AND plan_name>=basis_start_date  THEN 'Y'   
				 ELSE 'N'
			END AS is_editable
			
	FROM (
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
			and m.plan_cycle  = 'DAILY'
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
		cross join (
					SELECT convert(VARCHAR(8), dateadd(dd, -(dayofweek_no-1),basis_yyyymmDD),112) as basis_start_date
					--SELECT '20180501' basis_start_date
					 FROM (
							SELECT (CASE WHEN DAYOFWEEK_NO -1 =0 THEN 7 ELSE dayofweek_no -1 END ) dayofweek_no ,CONVERT(DATETIME, basis_yyyymmDD) as basis_yyyymmDD,DAYOFWEEK
							  FROM scm_sys_calendar_m 
							 WHERE basis_yyyymmdd =convert(VARCHAR(8), GETDATE(),112)
  	                      ) f
					) b
		cross join (SELECT osp_yn
						,fp_plan_period 
						,CASE WHEN osp_yn ='Y' THEN 0 ELSE fp_plan_period END AS offset
					FROM scm_mst_site
					WHERE division_id = @p_division_id
					AND scm_site_id   = @p_scm_site_id
					) c

END
