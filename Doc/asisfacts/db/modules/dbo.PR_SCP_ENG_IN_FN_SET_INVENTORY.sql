
/*
 * Program ID   : PR_SCP_ENG_IN_FN_SET_INVENTORY
 * Description  : 동일 PLAN_ID의 Confirm Flag ='Y'인 이전 PLAN_TYPE의 최종 생성된 데이터를 적재

                  참고) Confirm Flag => 현재(20180321)는 scm_mst_plan_detail.attribute1 컬럼값
                 

 * OutTable     : SCP_ENG_INVENTORY_I
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.01.18   KSW            전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2025.04.21   KJJ            E20250310-000135 셀 생산지별 공급계획 수립 엔진기능 개발
 */

CREATE PROCEDURE [dbo].[PR_SCP_ENG_IN_FN_SET_INVENTORY]
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
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_ENG_IN_FN_SET_INVENTORY';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @v_table_id     NVARCHAR(150) = 'SCP_ENG_INVENTORY_I';
    DECLARE @d_event_date   DATETIME;

    DECLARE @n_pre_plan_id       INTEGER = 0;
    DECLARE @n_cur_plan_id       INTEGER = 0;
    DECLARE @n_pre_week_plan_id  INTEGER = 0;
    DECLARE @n_cur_week_plan_id  INTEGER = 0;
    -- DECLARE @v_division_id       NVARCHAR(30);
    DECLARE @v_cur_monday        NVARCHAR(8)  = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112); -- 당주 월요일 YYYYMMDD
    --DECLARE @v_cutoff_day       NVARCHAR(8)  = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'SUN')), 112); -- 지난주 일요일 YYYYMMDD
	DECLARE @v_cutoff_day        NVARCHAR(10) = CONVERT(CHAR(10), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'SUN')), 112); -- 지난주 일요일 YYYYMMDD
    DECLARE @d_cutoff_day        DATETIME     = CONVERT(DATETIME, @v_cutoff_day)
	DECLARE @v_demand_cutoff_day NVARCHAR(8)  = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'TUE')), 112); -- 당주 화요일 YYYYMMDD
    DECLARE @d_plan_name         DATETIME;

	
  -- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = @p_master_id + ' / ' + @p_engine_plan_id ;
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    BEGIN TRY
      BEGIN
		
		DELETE /* PR_SCP_ENG_IN_FN_SET_INVENTORY */ 
		FROM   scp_eng_inventory_i_sn
		WHERE  modeling_id = @p_modeling_id  
	    AND    plan_id = @p_plan_id      
	    AND    plan_type = @p_plan_type    
		AND    plan_seq = @p_seq          
		AND    division_id = @p_division_id  
		;
        -----------------------------------------------------------
		INSERT INTO /* PR_SCP_ENG_IN_FN_SET_INVENTORY */ scp_eng_inventory_i_sn 
         (modeling_id, plan_id, plan_type, plan_seq
        , division_id, scm_site_id, org_scm_site_id, company_id, site_id, plant_id
        , factory_id, storage_id, cutoff_date, seq, stock_type, item_id, lane
        , production_type, available_date, remain_lead_time, holding_date
        , qty, qty_uom, stock_status, operation_id, line_id
        , outsourcing_flag, outsourcing_factory, description
        , fp_apply_operation_id, fp_apply_item_id, fp_apply_wipqty, wiphold_yn, wip_type_code
        , qty2, modify_fp_apply_wipqty, modify_description, cal_qty, formation_rework_type
        , created_by, creation_date, last_updated_by, last_update_date
        , location, site_item_yn, site_type
		, from_scm_site_id -- 2025.04.21 추가
         )
        SELECT modeling_id, plan_id, @p_plan_type AS plan_type, @p_seq AS plan_seq
            , division_id, scm_site_id, org_scm_site_id, company_id, site_id, plant_id
            , factory_id, storage_id, cutoff_date, seq, stock_type, item_id, lane
            , production_type, available_date, remain_lead_time, holding_date
            , qty, qty_uom, stock_status, operation_id, line_id
            , outsourcing_flag, outsourcing_factory, description
            , fp_apply_operation_id, fp_apply_item_id, fp_apply_wipqty, wiphold_yn, wip_type_code
            , qty2, modify_fp_apply_wipqty, modify_description, cal_qty, formation_rework_type
            , created_by, creation_date, last_updated_by, last_update_date
            , location, site_item_yn, site_type
			, from_scm_site_id -- 2025.04.21 추가
        FROM  scp_eng_inventory_i_sn WITH (NOLOCK)
        WHERE modeling_id = @p_modeling_id
        AND   plan_id     = @p_plan_id
        AND   plan_type   = @p_pre_plan_type
        AND   plan_seq    = @p_pre_plan_seq
        AND   division_id = @p_division_id
        ;

       
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


