
/*
 * Program ID   : PR_SCP_ENG_IN_FN_SET_BOMCOMPONENTS
 * Description  : 동일 PLAN_ID의 Confirm Flag ='Y'인 이전 PLAN_TYPE의 최종 생성된 데이터를 적재

                  참고) Confirm Flag => 현재(20180321)는 scm_mst_plan_detail.attribute1 컬럼값

 * OutTable     : SCP_ENG_BOMCOMPONENTS_I
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017.12.01   정원식         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2021.04.08   SEO            PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - SCP 대치BOM 적용
 * 2025.09.01   hrkim		   PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 : SCP Exclude Class 품목 BOM에서 제외
 * 2026.07.08   YMH			   E20260706-000082 EE MA 엔진 인풋 1시간이상 발생건
 *
 */

CREATE PROCEDURE [dbo].[PR_SCP_ENG_IN_FN_SET_BOMCOMPONENTS]
    ( @p_plan_cycle1  NVARCHAR(150)
    , @p_plan_name1   NVARCHAR(4000)
    , @p_plan_id1     NVARCHAR(4000)
    , @p_modeling_id1 NVARCHAR(4000)
    , @p_seq1         NVARCHAR(4000)
    , @p_plan_type1   NVARCHAR(4000)
    , @p_master_id1   NVARCHAR(4000)
    , @p_division_id1 NVARCHAR(30)
    , @p_engine_plan_id1 NVARCHAR(4000)

    , @p_pre_plan_type1 NVARCHAR(4000)
    , @p_pre_plan_seq1  NVARCHAR(4000)
    , @p_pre_engine_plan_id1 NVARCHAR(4000)
    
) AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS OFF;

    --20180228 프로시저 속도 개선을 위해서 입력변수를 일반변수로 변경함
    DECLARE @p_plan_cycle  NVARCHAR(150)    = @p_plan_cycle1;
    DECLARE @p_plan_name   NVARCHAR(4000)   = @p_plan_name1;
    DECLARE @p_plan_id     NVARCHAR(4000)   = @p_plan_id1;
    DECLARE @p_modeling_id NVARCHAR(4000)   = @p_modeling_id1 ;
    DECLARE @p_seq         NVARCHAR(4000)   = @p_seq1 ;
    DECLARE @p_plan_type   NVARCHAR(4000)   = @p_plan_type1 ;
    DECLARE @p_master_id   NVARCHAR(4000)   = @p_master_id1 ;
    DECLARE @p_division_id NVARCHAR(30)     = @p_division_id1 ; 
    DECLARE @p_engine_plan_id NVARCHAR(4000) = @p_engine_plan_id1 ; 
    
    DECLARE @p_pre_plan_type NVARCHAR(4000) = @p_pre_plan_type1;
    DECLARE @p_pre_plan_seq  NVARCHAR(4000) = @p_pre_plan_seq1;
    DECLARE @p_pre_engine_plan_id NVARCHAR(4000) = @p_pre_engine_plan_id1; 

    -- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_ENG_IN_FN_SET_BOMCOMPONENTS';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @v_table_id     NVARCHAR(150) = 'SCP_ENG_BOMCOMPONENTS_I';
    DECLARE @d_event_date   DATETIME;

    DECLARE @n_pre_plan_id       INTEGER = 0;
    DECLARE @n_cur_plan_id       INTEGER = 0;
    DECLARE @n_pre_week_plan_id  INTEGER = 0;
    DECLARE @n_cur_week_plan_id  INTEGER = 0;
    -- DECLARE @v_division_id       NVARCHAR(30);
    DECLARE @v_cur_monday        NVARCHAR(8) = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112); -- 당주 월요일 YYYYMMDD
    DECLARE @d_plan_name         DATETIME;

  -- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = @p_master_id + ' / ' + @p_engine_plan_id ;
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    BEGIN TRY
      BEGIN
	    /*-----------------------------------------------------------
		* 2021.04.08 SCP 대치BOM을 적용한 BOM ENG 생성
        -----------------------------------------------------------*/
		IF OBJECT_ID('tempdb..#scm_mst_bom_eng_sn') IS NOT NULL
		BEGIN 
			DROP TABLE  #scm_mst_bom_eng_sn;
		END;
		
		SELECT a.*
			 , b.scp_plan_yn 
		INTO   #scm_mst_bom_eng_sn
		FROM   dbo.scm_mst_bom_eng_sn a WITH (NOLOCK)
					LEFT OUTER JOIN dbo.scm_mst_alter_bom_v b WITH(NOLOCK)
					ON a.division_id = b.division_id
					AND a.site_id = b.site_id
					AND a.plant_id = b.plant_id
					AND a.parent_item_id = b.parent_item_id
					AND a.child_item_id = b.child_item_id
		WHERE  1=1
		AND    a.division_id  = @p_division_id
		AND    @p_plan_name  <  CONVERT(VARCHAR(8),a.eff_end_date,112)
		AND    a.active_flag  = 'Y'
		AND   (a.alt_id IS NULL 
				OR (a.alt_id IS NOT NULL AND b.scp_plan_yn IS NULL AND ISNULL(a.alt_priority, 1) = 1) 
				OR (a.alt_id IS NOT NULL AND b.scp_plan_yn IS NOT NULL AND b.scp_plan_yn = 'Y'))
		;

		-- E20260706-000082 EE MA 엔진 인풋 1시간이상 발생건
		CREATE NONCLUSTERED INDEX IX_bom_parent ON #scm_mst_bom_eng_sn (company_id, division_id, site_id, parent_item_id);





		SET @n_log_count   = @@ROWCOUNT;
		SET @v_log_type    = '';
		SET @v_log_message = '#SCM_MST_BOM_ENG_SN';
		SET @v_description = 'CREATE';
		SET @d_event_date  = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		----------------------------------------------------------------------------------------------------------------------------------------------
		-- Start : PJ20257329 2025.09.01 SCP Exclude Class 품목 BOM에서 제외
		----------------------------------------------------------------------------------------------------------------------------------------------
		SET @n_log_count   = 0;
		SET @v_log_type    = '';
		SET @v_log_message = N'Start-SCP Exclude Class 품목 BOM에서 제외';
		SET @v_description = 'Start';
		SET @d_event_date  = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		----------------------------------------------------------------------------------------------------------------------------------------------
		PRINT convert(varchar(30), getdate(), 121) +  N' ### SCP Exclude Class 품목 BOM에서 제외 : Step 1 : #scm_mst_bom_eng_sn_exc' 
		-- BOM 조정 구간 대상 데이터 추출 parent 또는 child에 scp exlucde 품목이 포함된 데이터 
		----------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#scm_mst_bom_eng_sn_exc') IS NOT NULL  drop table #scm_mst_bom_eng_sn_exc;
		select a.company_id
			  ,a.division_id
			  ,a.site_id
			  ,a.plant_id
			  ,a.parent_item_id
			  ,a.child_item_id
			  ,a.alt_id				
			  ,a.alt_priority		
			  ,case when pc.scp_exc_yn = 'Y' then 'Y' else 'N' end as parent_exc_yn 
			  ,case when cc.scp_exc_yn = 'Y' then 'Y' else 'N' end as child_exc_yn 
			  ,row_number() over (partition by a.company_id
											  ,a.division_id
											  ,a.site_id
											  ,a.plant_id
											  ,a.parent_item_id
											  ,a.child_item_id
										order by a.key_date desc ) as rn 
		  into #scm_mst_bom_eng_sn_exc
		  from #scm_mst_bom_eng_sn  a 
				inner join scm_mst_item_sn p with(nolock)
					    on p.company_id		= a.company_id
					   and p.division_id	= a.division_id
					   and p.site_id		= a.site_id
					   and p.item_id		= a.parent_item_id
					   and isnull(p.item_type,'Z')  not in ('Q','R')
				inner join scm_mst_item_class_m pc with(nolock)
						on pc.class_id		= p.item_class 
				inner join scm_mst_item_sn c with(nolock)
					    on c.company_id	= a.company_id
					   and c.division_id = a.division_id
					   and c.site_id		= a.site_id
					   and c.item_id		= a.child_item_id
					   and isnull(c.item_type,'Z')  not in ('Q','R') 
				inner join scm_mst_item_class_m cc with(nolock)
						on cc.class_id		= c.item_class 
		 where 1=1
		   and (pc.scp_exc_yn = 'Y'
			    or
				cc.scp_exc_yn = 'Y'
				) 

		----------------------------------------------------------------------------------------------------------------------------------------------
		PRINT convert(varchar(30), getdate(), 121) +  N' ### SCP Exclude Class 품목 BOM에서 제외 : Step 2 : #scm_mst_bom_eng_sn_exc_alt_priority' 
		-- scp except 품목 포함 모델의 경우 alt 품목이 존재할 수 있는지? (2025.08.28 현재 기준에는 없음)
		-- cell 모델기준 cell assy 하나만 매핑되어야 하기 때문에 parent기준 child 하나만 선택 
		-- alt_id null인 것을 우선 선택
		----------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#scm_mst_bom_eng_sn_exc_alt_priority') IS NOT NULL  drop table #scm_mst_bom_eng_sn_exc_alt_priority;
		select *
		  into #scm_mst_bom_eng_sn_exc_alt_priority
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
				 from #scm_mst_bom_eng_sn_exc
				where 1=1 
				  and rn = 1 
				) as tgt
		 where 1=1 
		   and alt_priority_rn = 1 

		----------------------------------------------------------------------------------------------------------------------------------------------
		PRINT convert(varchar(30), getdate(), 121) +  N' ### SCP Exclude Class 품목 BOM에서 제외 : Step 3 : #scm_mst_bom_eng_sn_exc_model' 
		-- 최상위 model과 cell assy 매핑을 위한 BOM 전개  
		----------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#scm_mst_bom_eng_sn_exc_model') IS NOT NULL  drop table #scm_mst_bom_eng_sn_exc_model;
        WITH recursive_query AS (
			select a.company_id
				  ,a.division_id
				  ,a.site_id
				  ,a.plant_id
				  ,a.parent_item_id as model_id
				  ,a.parent_item_id
				  ,a.child_item_id
				  ,a.parent_exc_yn
				  ,a.child_exc_yn
			from #scm_mst_bom_eng_sn_exc_alt_priority a 
			where 1=1
			  and parent_exc_yn = 'N'
			union all
			select c.company_id
				  ,c.division_id
				  ,c.site_id
				  ,c.plant_id
				  ,p.model_id
				  ,c.parent_item_id
				  ,c.child_item_id
				  ,c.parent_exc_yn
				  ,c.child_exc_yn
			from #scm_mst_bom_eng_sn_exc_alt_priority c 
				 inner join recursive_query p
						 on p.company_id	= c.company_id
						and p.division_id	= c.division_id
						and p.site_id		= c.site_id
						and p.PLANT_ID		= c.plant_id 
						and p.child_item_id = c.parent_item_id 
			where 1=1
		)
		select *
		 into #scm_mst_bom_eng_sn_exc_model
		 from recursive_query 
		where 1=1
		Option (MaxRecursion 7)

		----------------------------------------------------------------------------------------------------------------------------------------------
		PRINT convert(varchar(30), getdate(), 121) +  N' ### SCP Exclude Class 품목 BOM에서 제외 : Step 4 : delete (parent_exc_yn : Y) ' 
		-- parent 품목이 scp exclude 품목인 데이터 delete 
		----------------------------------------------------------------------------------------------------------------------------------------------
		delete tg 
		from #scm_mst_bom_eng_sn tg 
			 inner join #scm_mst_bom_eng_sn_exc_model ex 
				     on ex.company_id		= tg.company_id
					and ex.division_id		= tg.division_id
					and ex.site_id			= tg.site_id
					and ex.plant_id			= tg.plant_id
					and ex.parent_item_id	= tg.parent_item_id 
					and ex.child_item_id	= tg.child_item_id 
					and ex.parent_exc_yn	= 'Y'	-- scp exclude 품목 
		where 1=1

		----------------------------------------------------------------------------------------------------------------------------------------------
		PRINT convert(varchar(30), getdate(), 121) +  N' ### SCP Exclude Class 품목 BOM에서 제외 : Step 5 : update child item (exclude -> Cell Assy) ' 
		-- child 품목이 scp exclude 품목인 경우 Cell Assy 품목으로 update 
		----------------------------------------------------------------------------------------------------------------------------------------------
		;with model_cell_assy_map as (
			select distinct 
				   ex.company_id
				  ,ex.division_id
				  ,ex.site_id
				  ,ex.plant_id
				  ,ex.model_id
				  ,ex.child_item_id 
			from #scm_mst_bom_eng_sn_exc_model ex 
			where 1=1
			  and ex.parent_exc_yn	= 'Y'	-- scp exclude 품목 (parent) 
			  and ex.child_exc_yn	= 'N'	-- maybe cell assy 
		)
		update tg set tg.child_item_id = mp.child_item_id
		from #scm_mst_bom_eng_sn tg 
			 inner join #scm_mst_bom_eng_sn_exc_model ex
				     on ex.company_id		= tg.company_id
					and ex.division_id		= tg.division_id
					and ex.site_id			= tg.site_id
					and ex.plant_id			= tg.plant_id
					and ex.parent_item_id	= tg.parent_item_id
					and ex.child_item_id	= tg.child_item_id 
					and ex.parent_exc_yn	= 'N'	-- Cell model (product) 
					and ex.child_exc_yn		= 'Y'	-- scp exclude 품목 
			 inner join model_cell_assy_map mp
				     on mp.company_id		= tg.company_id
					and mp.division_id		= tg.division_id
					and mp.site_id			= tg.site_id
					and mp.plant_id			= tg.plant_id
					and mp.model_id			= tg.parent_item_id
		where 1=1

		----------------------------------------------------------------------------------------------------------------------------------------------
		SET @n_log_count   = 0;
		SET @v_log_type    = '';
		SET @v_log_message = N'End-SCP Exclude Class 품목 BOM에서 제외';
		SET @v_description = 'End';
		SET @d_event_date  = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		----------------------------------------------------------------------------------------------------------------------------------------------
		-- End   : PJ20257329 2025.09.01 SCP Exclude Class 품목 BOM에서 제외
		----------------------------------------------------------------------------------------------------------------------------------------------

        -----------------------------------------------------------
		DELETE /* PR_SCP_ENG_IN_FN_SET_BOMCOMPONENTS */
		FROM   dbo.scp_eng_bomcomponents_i_sn
		WHERE  plan_id     = @p_plan_id
		AND	   modeling_id = @p_modeling_id
		AND	   seq         = @p_seq
		AND	   enterprise  = @p_master_id
        AND    plan_type   = @p_plan_type 
		;
		--2021.04.08 LOG 추가
		SET @n_log_count   = @@ROWCOUNT;
		SET @v_log_type    = '';
		SET @v_log_message = 'SCP_ENG_BOMCOMPONENTS_I_SN';
		SET @v_description = 'DELETE';
		SET @d_event_date  = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        -----------------------------------------------------------
      
        WITH tree_query AS (
          SELECT a.company_id
               , a.division_id
               , a.site_id
               , a.plant_id
               , convert(varchar(255), a.parent_item_id) AS model_id
               , convert(varchar(255), a.parent_item_id) AS parent_item_id
               , convert(varchar(255), a.child_item_id)  AS child_item_id
               --, [dbo].[FN_SCM_SYS_NVL](b.flow_id, '-')  AS flow_id
			   -- E20260706-000082 EE MA 엔진 인풋 1시간이상 발생건
			   -- 기존 로직 주석처리
               /*
			   , CASE WHEN [dbo].[FN_SCM_SYS_NVL](b.flow_id, '-') = '-'
                        THEN [dbo].[FN_SCM_SYS_NVL](b.scp_flow_id, '-')
                      ELSE [dbo].[FN_SCM_SYS_NVL](b.flow_id, '-')
                 END AS flow_id
			   */
			   -- E20260706-000082 EE MA 엔진 인풋 1시간이상 발생건
			   -- 신규로직 시작
			   , CASE WHEN ISNULL(NULLIF(b.flow_id, ''), '-') = '-'
                        THEN ISNULL(NULLIF(b.scp_flow_id, ''), '-')
                      ELSE ISNULL(NULLIF(b.flow_id, ''), '-')
                 END AS flow_id
			   -- 신규로직 끝
               , a.bom_version_id
               , a.key_date
               , a.bom_version_line --
               , a.parent_qty
               , a.parent_uom
               , a.child_qty
               , a.child_uom
               , a.alt_id
               , a.alt_priority
               , a.alt_rate         --               
               , a.eff_start_date
               , a.eff_end_date
               , a.eco_code         --
               , a.phantom
               , a.standard_flag 
               , a.active_flag
               , a.description      --
               , CONVERT(VARCHAR(5000), CONVERT(VARCHAR(255), a.parent_item_id) + ' > ' + CONVERT(VARCHAR(255), a.child_item_id)) AS sort
               , b.item_class
          --FROM   dbo.scm_mst_bom_eng_sn a WITH (NOLOCK)
		  FROM   #scm_mst_bom_eng_sn a WITH (NOLOCK)	--2021.04.08 SCP 대치BOM 적용
               , dbo.scm_mst_item_sn b WITH (NOLOCK)
          WHERE  1=1
    --      AND    a.division_id = @p_division_id									--2021.04.08 주석처리
    --      AND    @p_plan_name  < CONVERT(VARCHAR(8),a.eff_end_date,112)			--2021.04.08 주석처리
    --      AND    a.active_flag = 'Y'												--2021.04.08 주석처리
		  --AND   (a.alt_id IS NULL													--2021.04.08 주석처리
    --             OR (a.alt_id IS NOT NULL AND ISNULL(a.alt_priority, 1) = 1)		--2021.04.08 주석처리
    --            )  -- 대치 BOM 제외												--2021.04.08 주석처리
          --AND    b.flow_id        IS NOT NULL
          --AND    b.flow_id        <> ''
          AND    a.company_id     = b.company_id
          AND    a.division_id    = b.division_id
          AND    a.site_id        = b.site_id
          AND    a.parent_item_id = b.item_id
          AND    b.active_flag    = 'Y'
          UNION ALL
          SELECT a.company_id
               , a.division_id
               , a.site_id
               , a.plant_id
               , convert(varchar(255), c.model_id)       AS model_id
               , convert(varchar(255), a.parent_item_id) AS parent_item_id
               , convert(varchar(255), a.child_item_id)  AS child_item_id
               --, [dbo].[FN_SCM_SYS_NVL](b.flow_id, '-')  AS flow_id
			   -- E20260706-000082 EE MA 엔진 인풋 1시간이상 발생건
			   -- 기존로직 주석처리
			   /*
               , CASE WHEN [dbo].[FN_SCM_SYS_NVL](b.flow_id, '-') = '-'
                        THEN [dbo].[FN_SCM_SYS_NVL](b.scp_flow_id, '-')
                      ELSE [dbo].[FN_SCM_SYS_NVL](b.flow_id, '-')
                 END AS flow_id
			   */
			   -- E20260706-000082 EE MA 엔진 인풋 1시간이상 발생건
			   -- 신규로직 시작
			   , CASE WHEN ISNULL(NULLIF(b.flow_id, ''), '-') = '-'
                        THEN ISNULL(NULLIF(b.scp_flow_id, ''), '-')
                      ELSE ISNULL(NULLIF(b.flow_id, ''), '-')
                 END AS flow_id
				-- 신규로직 끝

               , a.bom_version_id
               , a.key_date
               , a.bom_version_line  --
               , a.parent_qty
               , a.parent_uom
               , a.child_qty
               , a.child_uom
               , a.alt_id
               , a.alt_priority
               , a.alt_rate         --               
               , a.eff_start_date
               , a.eff_end_date
               , a.eco_code         --
               , a.phantom
               , a.standard_flag 
               , a.active_flag
               , a.description      --               
               , CONVERT(VARCHAR(5000), CONVERT(VARCHAR(5000),c.sort) + ' > ' + CONVERT(VARCHAR(255), b.item_id)) AS sort
               , b.item_class
          --FROM   dbo.scm_mst_bom_eng_sn a WITH (NOLOCK)
		  FROM   #scm_mst_bom_eng_sn a WITH (NOLOCK)	--2021.04.08 SCP 대치BOM 적용
               , dbo.scm_mst_item_sn b WITH (NOLOCK)
               , tree_query c
          WHERE  1=1
    --      AND    a.division_id = @p_division_id								--2021.04.08 주석처리
    --      AND    @p_plan_name  < CONVERT(VARCHAR(8),a.eff_end_date,112)		--2021.04.08 주석처리
    --      AND    a.active_flag = 'Y'											--2021.04.08 주석처리
		  --AND   (a.alt_id IS NULL												--2021.04.08 주석처리
    --             OR (a.alt_id IS NOT NULL AND ISNULL(a.alt_priority, 1) = 1)	--2021.04.08 주석처리
    --            )  -- 대치 BOM 제외											--2021.04.08 주석처리
          --AND    b.flow_id         IS NOT NULL
          --AND    b.flow_id         <> ''
          AND    a.company_id      = b.company_id
          AND    a.division_id     = b.division_id
          AND    a.site_id         = b.site_id
          AND    a.parent_item_id  = b.item_id
          AND    b.active_flag     = 'Y'
          AND    a.company_id      = c.company_id
          AND    a.division_id     = c.division_id
          AND    a.site_id         = c.site_id
          AND    a.parent_item_id  = c.child_item_id
        )
        INSERT INTO dbo.scp_eng_bomcomponents_i_sn         
          ( plan_id, plan_type, modeling_id, seq, enterprise      --20180321 plan_type 추가 
          , division_id, company_id, site_id, plant_id
          , model_id, parent_item_id, child_item_id
          , bom_version_id, flow_id, key_date
          , bom_version_line, parent_qty, parent_uom --
          , child_qty, child_uom
          , alt_id, alt_priority, alt_rate           --
          , eff_start_date, eff_end_date
          , eco_code, phantom, standard_flag         -- 
          , active_flag, description, sort           --
          , insert_id, insert_time, update_id, update_time
          )
        SELECT DISTINCT @p_plan_id, @p_plan_type, @p_modeling_id, @p_seq, @p_master_id --20180321 @p_plan_type 추가 
             , t.division_id
             , company_id
             , t.site_id
             , plant_id
             , model_id
             , parent_item_id
             , child_item_id
             , bom_version_id
             , flow_id
             , key_date
             , bom_version_line 
             , parent_qty
             , parent_uom
             , child_qty
             , child_uom
             , alt_id
             , alt_priority
             , alt_rate
             , eff_start_date
             , eff_end_date
             , eco_code
             , phantom
             , standard_flag 
             , active_flag
             , description 
             , NULL AS sort
             , 'scp_batch', GETDATE(), 'scp_batch', GETDATE()
        FROM   tree_query t
		-- E20260706-000082 EE MA 엔진 인풋 1시간이상 발생건
		OPTION (RECOMPILE)
		;
		--2021.04.08 LOG 추가
		SET @n_log_count   = @@ROWCOUNT;
		SET @v_log_type    = '';
		SET @v_log_message = 'SCP_ENG_BOMCOMPONENTS_I_SN';
		SET @v_description = 'INSERT';
		SET @d_event_date  = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        -----------------------------------------------------------

	    /*-----------------------------------------------------------
		* 2021.04.08 임시 테이블 삭제
        -----------------------------------------------------------*/
		BEGIN
			IF OBJECT_ID('tempdb..#scm_mst_bom_eng_sn') IS NOT NULL
			BEGIN 
				DROP TABLE  #scm_mst_bom_eng_sn;
			END;

			--------------------------------------------------------------------------------------------------------------------------
			-- Start : PJ20257329 2025.09.01 SCP Exclude Class 품목 BOM에서 제외 : 임시테이블 정리 
			--------------------------------------------------------------------------------------------------------------------------
			IF OBJECT_ID('tempdb..#scm_mst_bom_eng_sn_exc') IS NOT NULL  drop table #scm_mst_bom_eng_sn_exc;
			IF OBJECT_ID('tempdb..#scm_mst_bom_eng_sn_exc_alt_priority') IS NOT NULL  drop table #scm_mst_bom_eng_sn_exc_alt_priority;
			IF OBJECT_ID('tempdb..#scm_mst_bom_eng_sn_exc_model') IS NOT NULL  drop table #scm_mst_bom_eng_sn_exc_model;
			--------------------------------------------------------------------------------------------------------------------------
			-- End   : PJ20257329 2025.09.01 SCP Exclude Class 품목 BOM에서 제외 : 임시테이블 정리 
			--------------------------------------------------------------------------------------------------------------------------

		END;

        -----------------------------------------------------------
        -- 실행 Logic END --
        -----------------------------------------------------------

        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'INSERT INTO '+@v_table_id;
        SET @v_description = 'Process Complete...' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        IF @@TRANCOUNT > 0
          BEGIN
            COMMIT WORK;
          END;

      END;

    END TRY

    BEGIN CATCH
       --ROLLBACK
      -- ERROR LOG
      SET @v_log_type = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE()) + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
      return -1
    END CATCH;

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = @p_master_id + ' / ' + @p_engine_plan_id ;
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
    return 1

  END;

