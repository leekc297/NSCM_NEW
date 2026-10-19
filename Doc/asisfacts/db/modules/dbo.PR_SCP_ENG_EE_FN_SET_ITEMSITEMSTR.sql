
/*
 * Program ID   : PR_SCP_ENG_EE_FN_SET_ITEMSITEMSTR
 * Description  : 동일 PLAN_ID의 Confirm Flag ='Y'인 이전 PLAN_TYPE의 최종 생성된 데이터를 적재
 * OutTable     : scp_eng_itemsitemstr_i_sn
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017.12.15   정원식         SDB의 Site Item 처리를 위한 Master 정보를 ODB에 적재되도록 한다.
 *
 */

CREATE PROCEDURE [dbo].[PR_SCP_ENG_EE_FN_SET_ITEMSITEMSTR]
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
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_ENG_EE_FN_SET_ITEMSITEMSTR';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @v_table_id     NVARCHAR(150) = 'scp_eng_itemsitemstr_i_sn';
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
        DELETE /* PR_SCP_ENG_EE_FN_SET_ITEMSITEMSTR */
        FROM   scp_eng_itemsitemstr_i_sn
        WHERE  modeling_id  = @p_modeling_id
        AND    plan_id      = @p_plan_id
        AND    seq          = @p_seq
        AND    enterprise   = @p_master_id
        AND    plan_type    = @p_plan_type 
        ;
        -----------------------------------------------------------
        INSERT INTO /* PR_SCP_ENG_EE_FN_SET_ITEMSITEMSTR */ scp_eng_itemsitemstr_i_sn
          ( modeling_id, plan_id, plan_type, seq, ENTERPRISE, engine_id  --20180321 plan_type 추가
          , item, siteid, isresponsebuffer, sellable, stage
          , ss_priority, sc_level, non_constrained_buffer, eol
          , abc_class           
          , cutoff_itemid, item_type, kit_item_yn, constraint_yn, simulation_yn
          , proportional_split  
          , ppshipdate          
          , creation_date, created_by, last_update_date, last_updated_by
          )
        SELECT DISTINCT
               @p_modeling_id, @p_plan_id, @p_plan_type, @p_seq, @p_master_id, @p_modeling_id --20180321 @p_plan_type 추가
             , sie.item_id                            AS item
             , sie.eng_scm_site_id                    AS siteid
             , 1                                      AS isresponsebuffer
             , CASE WHEN se.site_type = 'SALES' THEN 1
                    ELSE 0
               END                                    AS sellable
             , CASE WHEN se.site_type = 'SALES' THEN 'S_PSI'
                --    WHEN se.site_type = 'DC'    THEN 'H_PSI'
                    WHEN se.site_type = 'PLANT' THEN 'M_PSI' --AND xitem.item_grp_name = 'PLANT_FG' THEN 'M_PSI' -- Model인 경우
                  --  WHEN xitem.site_group = 'PLANT' AND xitem.item_grp_name IS NULL      THEN 'R_PSI' -- 자재인 경우
               END                                    AS stage
             , 100                                    AS ss_priority
             , CASE WHEN se.site_type = 'SALES' THEN 1
                --    WHEN se.site_type = 'DC'    THEN 2
                    WHEN se.site_type = 'PLANT' THEN 3 --AND xitem.item_grp_name = 'PLANT_FG' THEN 3 -- Model인 경우
                   -- WHEN se.site_type = 'PLANT' AND xitem.item_grp_name IS NULL      THEN 4 -- 자재인 경우
               END                                    AS sc_level
             , NULL                                   AS non_constrained_buffer
             , 0                                      AS eol
             , NULL                                   AS abc_class -- 무재고 버퍼 추가 : Zero Inventory
             , sie.item_id                            AS cutoff_itemid
             , 'H'                                    AS item_type -- Demand 입력대상 모델 = 'FG'  - P / H / R
             , 'N'                                    AS kit_item
             , 'N'                                    AS constraint_yn
             , 'N'                                    AS simulation_yn
             , NULL                                   AS proportional_split
             , NULL                                   AS ppshipdate
             , GETDATE()                              AS creation_date
             , 'scp_batch'                            AS created_by
             , GETDATE()                              AS last_update_date
             , 'scp_batch'                            AS last_updated_by
        FROM   scm_mst_site_item_eng sie WITH (NOLOCK)  
             , scm_mst_site_eng      se WITH (NOLOCK)  
        WHERE  sie.modeling_id     = @p_modeling_id
        AND    sie.plan_id         = @p_plan_id
        AND    sie.plan_type       = @p_plan_type
        AND    sie.plan_seq        = @p_seq
        AND    sie.modeling_id     = se.modeling_id
        AND    sie.plan_id         = se.plan_id
        AND    sie.plan_type       = se.plan_type
        AND    sie.plan_seq        = se.plan_seq
        AND    sie.eng_scm_site_id = se.eng_scm_site_id
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

