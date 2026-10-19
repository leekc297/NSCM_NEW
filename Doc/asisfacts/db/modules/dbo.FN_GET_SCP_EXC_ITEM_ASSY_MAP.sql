
/*
 * Program ID   : FN_GET_SCP_EXC_ITEM_ASSY_MAP                                                              
 * Description  : SCP exclude 셀 품목과 하위 Cell Assy 매핑 정보 반환 함수 
 * 실행 예제    : - 전체 : SELECT * FROM dbo.FN_GET_SCP_EXC_ITEM_ASSY_MAP (NULL)
 *				  - 소형 : SELECT * FROM dbo.FN_GET_SCP_EXC_ITEM_ASSY_MAP ('40')
 * Program History  
 *===================================================================================================  
 *   Date       In Charge		Description  
 *===================================================================================================  
 * 2025.09.01	hrkim			PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산
 *
 */

CREATE FUNCTION FN_GET_SCP_EXC_ITEM_ASSY_MAP ( 
	@p_division_id	nvarchar(30) = null 
)   
RETURNS @RETURN_TABLE TABLE
(
		  company_id				NVARCHAR(30)	NOT NULL
		, division_id				NVARCHAR(30)	NOT NULL
		, site_id					NVARCHAR(30)	NOT NULL
		, plant_id					NVARCHAR(30)	NOT NULL
		, scp_exc_item_id			NVARCHAR(100)	NOT NULL
		, cell_assy_item_id			NVARCHAR(100)	NOT NULL
)
BEGIN

		declare @p_plan_name date = null

		declare @scm_mst_bom_eng_sn_exc TABLE
		(
				  COMPANY_ID				NVARCHAR(30)	NOT NULL
				, DIVISION_ID				NVARCHAR(30)	NOT NULL
				, SITE_ID					NVARCHAR(30)	NOT NULL
				, PLANT_ID					NVARCHAR(30)	NOT NULL
				, parent_item_id			NVARCHAR(100)	NOT NULL
				, child_item_id				NVARCHAR(100)	NOT NULL
				, alt_id					NVARCHAR(30)	NULL
				, alt_priority				numeric(20,10)	NULL
				, parent_exc_yn				NVARCHAR(8)		NULL 
				, child_exc_yn				NVARCHAR(8)		NULL 
				, key_date					NVARCHAR(8)		NULL 
				, scp_plan_yn				NVARCHAR(8)		NULL 
				, rn						integer			NULL
		)

		declare @scm_mst_bom_eng_sn_exc_alt_priority TABLE
		(
				  COMPANY_ID				NVARCHAR(30)	NOT NULL
				, DIVISION_ID				NVARCHAR(30)	NOT NULL
				, SITE_ID					NVARCHAR(30)	NOT NULL
				, PLANT_ID					NVARCHAR(30)	NOT NULL
				, parent_item_id			NVARCHAR(100)	NOT NULL
				, child_item_id				NVARCHAR(100)	NOT NULL
				, alt_id					NVARCHAR(30)	NULL
				, alt_priority				numeric(20,10)	NULL
				, parent_exc_yn				NVARCHAR(8)		NULL 
				, child_exc_yn				NVARCHAR(8)		NULL 
				, key_date					NVARCHAR(8)		NULL 
				, scp_plan_yn				NVARCHAR(8)		NULL 
				, rn						integer			NULL
				, alt_priority_rn			integer			NULL
		)

		declare @scm_mst_bom_eng_sn_exc_model TABLE
		(
				  COMPANY_ID				NVARCHAR(30)	NOT NULL
				, DIVISION_ID				NVARCHAR(30)	NOT NULL
				, SITE_ID					NVARCHAR(30)	NOT NULL
				, PLANT_ID					NVARCHAR(30)	NOT NULL
				, model_id_exc				NVARCHAR(100)	NOT NULL
				, parent_item_id			NVARCHAR(100)	NOT NULL
				, child_item_id				NVARCHAR(100)	NOT NULL
				, parent_exc_yn				NVARCHAR(8)		NULL 
				, child_exc_yn				NVARCHAR(8)		NULL 
		)

		--------------------------------------------------------------------------------------------------------------------------------------------------
		---- bom 참조 기준 월요일   
		--------------------------------------------------------------------------------------------------------------------------------------------------
		select @p_plan_name = convert(date, isnull(max(yyyymmdd) , convert(nvarchar(8), getdate(), 112)), 112)
		 from scm_mst_bucket b with(nolock)
		where 1=1
		  and b.yyyymmdd <= convert(nvarchar(8), getdate(), 112)
		  and b.dayofweek = 'MON' -- 최근 월요일  

		--------------------------------------------------------------------------------------------------------------------------------------------------
		----PRINT convert(varchar(30), getdate(), 121) +  N' ### SCP Exclude Class 품목 포함 전개 대상 추출  : Step 1 : @scm_mst_bom_eng_sn_exc' 
		---- BOM 조정 구간 대상 데이터 추출 parent 또는 child에 scp exlucde 품목이 포함된 데이터 
		--------------------------------------------------------------------------------------------------------------------------------------------------
		insert into @scm_mst_bom_eng_sn_exc
		select a.company_id
			  ,a.division_id
			  ,a.site_id
			  ,a.plant_id
			  ,a.parent_item_id
			  ,a.child_item_id
			  ,a.alt_id				
			  ,a.alt_priority
			  ,case when pc.scp_exc_yn = 'Y'	then 'Y' else 'N' end as parent_exc_yn
			  ,case when cc.scp_exc_yn = 'Y'	then 'Y' else 'N' end as child_exc_yn 
			  ,a.key_date 
			 , b.scp_plan_yn 
			  ,row_number() over (partition by a.company_id
											  ,a.division_id
											  ,a.site_id
											  ,a.plant_id
											  ,a.parent_item_id
											  ,a.child_item_id
									  order by a.key_date desc ) as rn 
		 FROM dbo.scm_mst_bom_eng_sn a WITH (NOLOCK) 
			  inner join scm_mst_item_sn p with(nolock)
			  	      on p.company_id	= a.company_id
			  	     and p.division_id	= a.division_id
			  	     and p.site_id		= a.site_id
			  	     and p.item_id		= a.parent_item_id
			  	     and isnull(p.item_type,'Z')  != 'R'
			  inner join scm_mst_item_class_m pc with(nolock)
			  		  on pc.class_id		= p.item_class 
			  inner join scm_mst_item_sn c with(nolock)
			  	      on c.company_id	= a.company_id
			  	     and c.division_id	= a.division_id
			  	     and c.site_id		= a.site_id
			  	     and c.item_id		= a.child_item_id
			  	     and isnull(c.item_type,'Z')  != 'R' 
			  inner join scm_mst_item_class_m cc with(nolock)
			  		  on cc.class_id		= c.item_class 
			  LEFT OUTER JOIN dbo.scm_mst_alter_bom_v b WITH(NOLOCK)
						   ON a.division_id		= b.division_id
						  AND a.site_id			= b.site_id
						  AND a.plant_id		= b.plant_id
						  AND a.parent_item_id	= b.parent_item_id
						  AND a.child_item_id	= b.child_item_id
		WHERE 1=1
		  AND (pc.scp_exc_yn = 'Y'	
		 	    or						
		 	   cc.scp_exc_yn = 'Y'    
		 	  ) 
		  AND a.division_id = case	when isnull(@p_division_id, '') = '' 
									then a.division_id 
									else @p_division_id 
								end 
		  AND @p_plan_name  <  CONVERT(VARCHAR(8),a.eff_end_date,112)
		  AND a.active_flag  = 'Y'
		  AND (a.alt_id IS NULL 
				OR (a.alt_id IS NOT NULL AND b.scp_plan_yn IS NULL AND ISNULL(a.alt_priority, 1) = 1) 
				OR (a.alt_id IS NOT NULL AND b.scp_plan_yn IS NOT NULL AND b.scp_plan_yn = 'Y'))
		;

		------------------------------------------------------------------------------------------------------------------------------------------------
		--PRINT convert(varchar(30), getdate(), 121) +  N' ### SCP Exclude Class 품목 포함 BOM 우선순위 : Step 2 : @scm_mst_bom_eng_sn_exc_alt_priority' 
		---- scp except 품목 포함 모델의 경우 alt 품목이 존재할 수 있는지? (2025.08.28 현재 기준에는 없음)
		---- cell 모델기준 cell assy 하나만 매핑되어야 하기 때문에 parent기준 child 하나만 선택 
		---- alt_id null인 것을 우선 선택
		------------------------------------------------------------------------------------------------------------------------------------------------
		insert into @scm_mst_bom_eng_sn_exc_alt_priority
		select *
		  from (select *
					  ,row_number() over (partition by company_id
													  ,division_id
													  ,site_id
													  ,plant_id
													  ,parent_item_id
											  order by case when alt_id is null 
															then 1 
															else 2 
													   end
													  ,alt_id
													  ,alt_priority) alt_priority_rn 
				 from @scm_mst_bom_eng_sn_exc
				where 1=1 
				  and rn = 1 
				) as tgt
		 where 1=1 
		   and alt_priority_rn = 1 

		------------------------------------------------------------------------------------------------------------------------------------------------
		--PRINT convert(varchar(30), getdate(), 121) +  N' ### SCP Exclude Class 품목 포함 BOM 전개 : Step 3 : @scm_mst_bom_eng_sn_exc_model' 
		---- scp exclude item부터 하위 BOM 전개  
		------------------------------------------------------------------------------------------------------------------------------------------------
       ;WITH recursive_query AS (
			select a.company_id
				  ,a.division_id
				  ,a.site_id
				  ,a.plant_id
				  ,a.parent_item_id as model_id_exc
				  ,a.parent_item_id
				  ,a.child_item_id
				  ,a.parent_exc_yn
				  ,a.child_exc_yn
			from @scm_mst_bom_eng_sn_exc_alt_priority a 
			where 1=1
			  and parent_exc_yn = 'Y'	-- SCP Exclude 품목부터 하위 전개
			union all
			select c.company_id
				  ,c.division_id
				  ,c.site_id
				  ,c.plant_id
				  ,p.model_id_exc
				  ,c.parent_item_id
				  ,c.child_item_id
				  ,c.parent_exc_yn
				  ,c.child_exc_yn
			from @scm_mst_bom_eng_sn_exc_alt_priority c 
				 inner join recursive_query p
						 on p.company_id	= c.company_id
						and p.division_id	= c.division_id
						and p.site_id		= c.site_id
						and p.PLANT_ID		= c.plant_id 
						and p.child_item_id = c.parent_item_id 
			where 1=1
		)
	   insert into @scm_mst_bom_eng_sn_exc_model 
		select *
		from recursive_query 
		where 1=1
		Option (MaxRecursion 7)

		------------------------------------------------------------------------------------------------------------------------------------------------
		--PRINT convert(varchar(30), getdate(), 121) +  N' ### SCP Exclude Class 품목과 하위 Cell Assy 매핑 정보 반환 : @RETURN_TABLE' 
		------------------------------------------------------------------------------------------------------------------------------------------------
		insert into @RETURN_TABLE
		select company_id
			 , division_id
			 , site_id
			 , plant_id
			 , model_id_exc			as scp_exc_item_id
			 , max(child_item_id)	as cell_assy_item_id 
		from @scm_mst_bom_eng_sn_exc_model
		where 1=1
		  and child_exc_yn = 'N'
		group by company_id
				,division_id
				,site_id
				,plant_id
				,model_id_exc

    RETURN;
END







