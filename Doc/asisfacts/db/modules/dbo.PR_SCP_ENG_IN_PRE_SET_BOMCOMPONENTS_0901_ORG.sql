
/*
 * Program ID   : PR_SCP_ENG_IN_PRE_SET_BOMCOMPONENTS
 * Description  :
 * OutTable     : SCP_ENG_BOMCOMPONENTS_I
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017.12.01   정원식         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2021.04.08   SEO            PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - SCP 대치BOM 적용
 *
 */

CREATE PROCEDURE [dbo].[PR_SCP_ENG_IN_PRE_SET_BOMCOMPONENTS_0901_ORG]
    ( @p_plan_cycle1  NVARCHAR(150)
    , @p_plan_name1   NVARCHAR(4000)
    , @p_plan_id1     NVARCHAR(4000)
    , @p_modeling_id1 NVARCHAR(4000)
    , @p_seq1         NVARCHAR(4000)
    , @p_plan_type1   NVARCHAR(4000)
    , @p_master_id1   NVARCHAR(4000)
    , @p_division_id1 NVARCHAR(30)
    , @p_engine_plan_id1 NVARCHAR(4000)
    -- , @p_debug       INT OUTPUT
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


    -- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_ENG_IN_PRE_SET_BOMCOMPONENTS';
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
    SET @v_description = @v_program_name + ':' + @p_plan_cycle;
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
		SET @n_log_count   = @@ROWCOUNT;
		SET @v_log_type    = '';
		SET @v_log_message = '#SCM_MST_BOM_ENG_SN';
		SET @v_description = 'CREATE';
		SET @d_event_date  = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        -----------------------------------------------------------
		DELETE
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

        WITH tree_query AS (
          SELECT a.company_id
               , a.division_id
               , a.site_id
               , a.plant_id
               , convert(varchar(255), a.parent_item_id) AS model_id
               , convert(varchar(255), a.parent_item_id) AS parent_item_id
               , convert(varchar(255), a.child_item_id)  AS child_item_id
               --, [dbo].[FN_SCM_SYS_NVL](b.flow_id, '-')  AS flow_id
               , CASE WHEN [dbo].[FN_SCM_SYS_NVL](b.flow_id, '-') = '-'
                        THEN [dbo].[FN_SCM_SYS_NVL](b.scp_flow_id, '-')
                      ELSE [dbo].[FN_SCM_SYS_NVL](b.flow_id, '-')
                 END AS flow_id
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
          --AND    a.division_id = @p_division_id									--2021.04.08 주석처리
          --AND    @p_plan_name  < CONVERT(VARCHAR(8),a.eff_end_date,112)			--2021.04.08 주석처리
          --AND    a.active_flag = 'Y'												--2021.04.08 주석처리
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
               , CASE WHEN [dbo].[FN_SCM_SYS_NVL](b.flow_id, '-') = '-'
                        THEN [dbo].[FN_SCM_SYS_NVL](b.scp_flow_id, '-')
                      ELSE [dbo].[FN_SCM_SYS_NVL](b.flow_id, '-')
                 END AS flow_id
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
          --AND    a.division_id = @p_division_id									--2021.04.08 주석처리
          --AND    @p_plan_name  < CONVERT(VARCHAR(8),a.eff_end_date,112)			--2021.04.08 주석처리
          --AND    a.active_flag = 'Y'												--2021.04.08 주석처리
		  --AND   (a.alt_id IS NULL													--2021.04.08 주석처리
    --             OR (a.alt_id IS NOT NULL AND ISNULL(a.alt_priority, 1) = 1)		--2021.04.08 주석처리
    --            )  -- 대치 BOM 제외												--2021.04.08 주석처리
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
		END;

        -----------------------------------------------------------
        -- 실행 Logic END --
        -----------------------------------------------------------

        -- TXN LOG
        SET @v_log_type = 'TXN';
        SET @n_log_count = @@ROWCOUNT;
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
      -- ROLLBACK
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


