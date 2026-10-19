


/*
 * Program ID   : SCP0121_GET_PLAN_GROUP_LINE
 * Description  : Plan Group 설정 정보조회
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2025/04/21   mrchois			PJ2024A332R 독립적 Planning 체계 및 Master Validation UI 구축 - Initial Release
 * 2025/09/03   mrchois			PJ20257329  최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - 사업부별 Operation 룩업으로부터 Operation 및 라인 표시, OSP Plant 및 라인도 표시
 *
 */

CREATE PROCEDURE [dbo].[SCP0121_GET_PLAN_GROUP_LINE]
	@p_division_id			NVARCHAR(MAX)
	, @p_operation_id		NVARCHAR(MAX)
	, @p_plant_id			NVARCHAR(MAX)
	, @p_factory_id			NVARCHAR(MAX)
	, @p_line_id			NVARCHAR(MAX)
	, @p_plan_group_id		NVARCHAR(MAX)

AS
BEGIN
	
    SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	if object_id('tempdb..#temp_plan_group_line') is not null drop table #temp_plan_group_line;

    ;with division_info as (
	select d.division_id
		 , r.division_id	as org_division_id 
		 , d.attribute3		as division_dv
	from scm_mst_division d with(nolock)
		  inner join scm_mst_division r with(nolock)
				  on d.attribute4 = r.attribute4
				 and ( (d.attribute3 != 'EE' and d.division_id = r.division_id)
					  or
					   (d.attribute3 = 'EE'  and r.attribute3 != 'EE') 
					 ) 
	where 1=1
	  and d.valid_yn = 'Y'
	  and r.valid_yn = 'Y'
	), line_master as ( 
		select l.company_id
			  ,l.division_id
			  ,l.site_id
			  ,l.plant_id
			  ,l.factory_id
			  ,f.factory_name
			  ,l.operation_id
			  ,l.line_id
			  ,max(l.line_name) as line_name 
		 from scm_mst_line_sn l with(nolock)
			  inner join scm_mst_factory_sn f with(nolock)
					  on f.company_id = l.company_id
					 and f.factory_id = l.factory_id 
		where 1=1
		 and l.active_flag =  'Y'
		group by l.company_id
				,l.division_id
				,l.site_id
				,l.plant_id
				,l.factory_id
				,f.factory_name
				,l.operation_id
				,l.line_id
	)
	select d.division_id
		  --,l.division_id as org_division_id 
		  --,l.site_id
		  ,l.plant_id
		  ,l.factory_id
		  ,l.factory_name 
		  ,l.line_id
		  ,l.line_name 
		  ,l.operation_id
		  ,lg.OPMZ_plan_gr_id
		  --,pg.OPMZ_plan_gr_name
		  ,lg.item_id AS OPMZ_PLAN_GR_ITEM_ID
		  ,lg.OPMZ_plan_gr_id AS PRE_PLAN_GR_ID
		  ,lg.item_id AS PRE_PLAN_GR_ITEM_ID
	--[PJ20257329] 사업부별 Operation 룩업으로부터 Operation 및 라인 표시(2025-09-03) START
	into #temp_plan_group_line
	from line_master l with(nolock)
	LEFT JOIN scm_adm_lookup_master_detail ld WITH(NOLOCK)
	  ON ld.LOOKUP_TYPE = 'OPMZ_PLAN_OPERATION' AND ld.valid_yn = 'Y' AND ld.SEGMENT1 = @p_division_id
		 inner join division_info d 
				 on l.division_id = d.org_division_id
			    AND l.OPERATION_ID = ld.SEGMENT2	--사업부별 표시할 Operation 지정
				--and l.operation_id = case when d.division_dv  = 'EE'
				--						  then 'E2000'
				--						  else l.operation_id
				--						end 
				--and l.operation_id != case when d.division_dv = 'EE'
				--						   then 'Z'
				--						   else 'E2000'
				--					  end 
	--[PJ20257329] 사업부별 Operation 룩업으로부터 Operation 및 라인 표시(2025-09-03) END
		  left join SCP_OPMZ_PLAN_GR_LINE_M lg with(nolock)
				 on lg.line_id		= l.line_id
				and lg.operation_id	= l.operation_id
				and lg.factory_id	= l.factory_id
				and lg.PLANT_ID		= l.plant_id
		  --left join SCP_OPMZ_PLAN_GR_M pg with(nolock)
				-- on pg.OPMZ_plan_gr_id = lg.OPMZ_plan_gr_id
	where 1=1
	  and d.division_id = @p_division_id
	  AND ( ( @p_operation_id	IS NULL OR  @p_operation_id = ''  ) OR l.operation_id		IN (SELECT token FROM dbo.String_Split(@p_operation_id  ,',')) )
	  AND ( ( @p_plant_id		IS NULL OR  @p_plant_id = ''	  )	OR l.plant_id			IN (SELECT token FROM dbo.String_Split(@p_plant_id  ,',')) )
	  AND ( ( @p_factory_id		IS NULL OR  @p_factory_id = ''    ) OR l.factory_id			IN (SELECT token FROM dbo.String_Split(@p_factory_id  ,',')) )
	  AND ( ( @p_line_id		IS NULL OR  @p_line_id = ''       ) OR l.line_id			IN (SELECT token FROM dbo.String_Split(@p_line_id  ,',')) )
	  AND ( ( @p_plan_group_id	IS NULL OR  @p_plan_group_id = '' ) OR lg.OPMZ_plan_gr_id	IN (SELECT token FROM dbo.String_Split(@p_plan_group_id  ,',')) )
	--[PJ20257329] 사업부별 Operation 룩업으로부터 Operation 및 라인 표시, OSP Plant 및 라인도 표시(2025-09-03) START
	  --and exists (select *
			--		from scm_adm_lookup_master_detail  op with(nolock)
			--		where 1=1
			--		  and op.lookup_type = 'SCP_PLAN_OPERATION'
			--		  and op.valid_yn = 'Y'
			--		  and op.segment1 = l.operation_id
			--		  and op.segment4 like concat('%', l.division_id, '%')) 

	SELECT *
	FROM (
		select *
		from #temp_plan_group_line
		UNION
		select osp.division_id
			  ,site.plant_id
			  , '-'	--osp.factory_id
			  , '-'	--osp.factory_name 
			  ,osp.line_id
			  ,osp.line_name 
			  ,osp.operation_id
			  ,lg.OPMZ_plan_gr_id
			  ,lg.item_id			AS OPMZ_PLAN_GR_ITEM_ID
			  ,lg.OPMZ_plan_gr_id	AS PRE_PLAN_GR_ID
			  ,lg.item_id			AS PRE_PLAN_GR_ITEM_ID
		from SCM_MST_LINE_OSP osp with(nolock)
		join scm_mst_site site with(nolock)
		  on osp.division_id = site.division_id
		 and osp.scm_site_id = site.scm_site_id
			  left join SCP_OPMZ_PLAN_GR_LINE_M lg with(nolock)
					 on lg.line_id		= osp.line_id
					and lg.operation_id	= osp.operation_id
					and lg.factory_id	= '-'
					and lg.PLANT_ID		= site.plant_id
	   where osp.valid_yn = 'Y' and site.valid_yn = 'Y'
		 and osp.division_id = @p_division_id
	     and ( ( @p_operation_id	IS NULL OR  @p_operation_id = ''  ) OR osp.operation_id		IN (SELECT token FROM dbo.String_Split(@p_operation_id  ,',')) )
	     and ( ( @p_plant_id		IS NULL OR  @p_plant_id = ''	  )	OR site.plant_id			IN (SELECT token FROM dbo.String_Split(@p_plant_id  ,',')) )
	     and ( ( @p_line_id		IS NULL OR  @p_line_id = ''       ) OR osp.line_id			IN (SELECT token FROM dbo.String_Split(@p_line_id  ,',')) )
	     and ( ( @p_plan_group_id	IS NULL OR  @p_plan_group_id = '' ) OR lg.OPMZ_plan_gr_id	IN (SELECT token FROM dbo.String_Split(@p_plan_group_id  ,',')) )
	) a
	ORDER BY (CASE WHEN factory_id = '-' THEN 1 ELSE 0 END), division_id, plant_id, line_id, operation_id
	--[PJ20257329] 사업부별 Operation 룩업으로부터 Operation 및 라인 표시, OSP Plant 및 라인도 표시(2025-09-03) END
  
END

