

/*
 * Program ID   : PR_SCP_ENG_OUT_ALL
 * Description  : 엔진 Output 정보 이전을 위한 제어 프로그램
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017.11.21   정원식         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 */

CREATE PROCEDURE [dbo].[PR_SCP_ENG_OUT_ALL]
    ( @p_master_id1      NVARCHAR(4000)
    , @p_engine_plan_id1 NVARCHAR(4000)
    -- , @p_debug      INT OUTPUT
) AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS OFF;

    --20180228 프로시저 속도 개선을 위해서 입력변수를 일반변수로 변경함
    DECLARE @p_master_id      NVARCHAR(4000) = @p_master_id1 ; -- 82::WEEKLY
    DECLARE @p_engine_plan_id NVARCHAR(4000) = @p_engine_plan_id1 ; -- 1018::PR::1
    DECLARE @p_division_id    NVARCHAR(30)   = SUBSTRING(@p_master_id, 1, CHARINDEX('::', @p_master_id)-1) ; 
    DECLARE @p_plan_cycle     NVARCHAR(150)  = SUBSTRING(@p_master_id, CHARINDEX('::', @p_master_id)+2,100) ;
    DECLARE @p_plan_id        NVARCHAR(4000) = SUBSTRING(@p_engine_plan_id, 1, CHARINDEX('::', @p_engine_plan_id)-1) ;
    DECLARE @p_plan_type      NVARCHAR(4000) = SUBSTRING(@p_engine_plan_id, CHARINDEX('::', @p_engine_plan_id)+2, 2) ; -- Plan Type이 두 자리이기 때문에 마지막 인수가 2임
    DECLARE @p_seq            NVARCHAR(4000) = SUBSTRING(@p_engine_plan_id, DBO.FN_CHARINDEX_REV(@p_engine_plan_id, '::', 0)+2,100) ;
    DECLARE @p_modeling_id    NVARCHAR(4000) ;
    DECLARE @p_plan_name      NVARCHAR(4000) ;

    -- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_ENG_OUT_ALL';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @v_table_id     NVARCHAR(150) = 'SCP_ENG_ALL';
    DECLARE @d_event_date   DATETIME;

    DECLARE @n_pre_plan_id       INTEGER = 0;
    DECLARE @n_cur_plan_id       INTEGER = 0;
    DECLARE @n_pre_week_plan_id  INTEGER = 0;
    DECLARE @n_cur_week_plan_id  INTEGER = 0;
    -- DECLARE @v_division_id       NVARCHAR(30);
    DECLARE @v_cur_monday        NVARCHAR(8) = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112); -- 당주 월요일 YYYYMMDD
    DECLARE @d_plan_name         DATETIME;

    DECLARE @rows INT;

  -- 시작 LOG
    SET @v_log_type    = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = @p_master_id + ' / ' + @p_engine_plan_id ;
    SET @d_event_date  = SYSDATETIME();

    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    SET @rows = 0;
	-----------------------------------------------------------
    -- 실행용 변수 설정
    -----------------------------------------------------------
    -- 1. Modelin ID
    SELECT /* PR_SCP_ENG_OUT_ALL */
           @p_modeling_id = m.modeling_id
    FROM  scm_mst_modeling m with(nolock)
    WHERE division_id = @p_division_id
    AND   enterprise  = @p_master_id
    ANd   plan_cycle  = @p_plan_cycle ; 

    -- 2. Plan Name
    SELECT /* PR_SCP_ENG_OUT_ALL */
           @p_plan_name = m.plan_name
    FROM  scm_mst_plan m with(nolock)
    WHERE division_id = @p_division_id
    AND   plan_id     = @p_plan_id
    ANd   plan_cycle  = @p_plan_cycle ; 
	
    -- TXN LOG
    SET @v_log_type    = 'TXN';
    SET @v_log_message = 'Variable Setting  ';
    SET @v_description = @p_master_id + ' / ' + @p_engine_plan_id + ' / ' + @p_modeling_id + ' / ' + @p_plan_name ;
    SET @d_event_date  = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	
    -- Plan Detail 정보 Update
    UPDATE /* PR_SCP_ENG_OUT_ALL */
           scm_mst_plan_detail
    SET    plan_end_date    = GETDATE()
         , last_update_date = GETDATE()
    WHERE  modeling_id = @p_modeling_id
    AND    division_id = @p_division_id
    AND    plan_id     = @p_plan_id
    AND    plan_seq    = @p_seq        
    AND    plan_type   = @p_plan_type 
    ;

    BEGIN TRY
      BEGIN  
        -----------------------------------------------------------
        -- Engine 용 후처리 작업 Call : 후처리는 별도 프로그램 Name으로 Log 남김
        -----------------------------------------------------------
        -- TXN LOG
        SET @v_log_type    = 'START';
        SET @v_description = @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @v_log_message = 'CALL After Engine : pr_scp_post_process ';
        SET @d_event_date  = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH 'PR_SCP_POST_PROCESS', @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        EXEC @ROWS = ENG_SCP.DBO.PR_SCP_POST_PROCESS @p_master_id, @p_engine_plan_id, @p_engine_plan_id
        IF @rows < 0 GOTO _RETURN_ERR_CODE

        -- TXN LOG
        SET @v_log_type    = 'END';
        SET @v_log_message = 'CALL After Engine : pr_scp_post_process ';
        SET @d_event_date  = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH 'PR_SCP_POST_PROCESS', @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		
        -----------------------------------------------------------
        -- Engine => SCP_ENG 작업 Call
        -----------------------------------------------------------		
        -- TXN LOG
        SET @v_log_type    = 'TXN';
        SET @v_log_message = 'CALL SCP_ENG  : Transfer ';
        SET @d_event_date  = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        EXEC @ROWS = PR_SCP_ENG_OUT_DELIVERY @p_plan_cycle, @p_plan_name, @p_plan_id, @p_modeling_id, @p_seq, @p_plan_type, @p_master_id, @p_division_id, @p_engine_plan_id
        -- SELECT 'PR_SCP_ENG_DELIVERY_OUT', @rows;
        IF @rows < 0 GOTO _RETURN_ERR_CODE

        EXEC @ROWS = PR_SCP_ENG_OUT_ITEM_PLAN @p_plan_cycle, @p_plan_name, @p_plan_id, @p_modeling_id, @p_seq, @p_plan_type, @p_master_id, @p_division_id, @p_engine_plan_id
        -- SELECT 'PR_SCP_ENG_ITEM_PLAN_OUT', @rows;
        IF @rows < 0 GOTO _RETURN_ERR_CODE

        EXEC @ROWS = PR_SCP_ENG_OUT_MATERIAL_PLAN @p_plan_cycle, @p_plan_name, @p_plan_id, @p_modeling_id, @p_seq, @p_plan_type, @p_master_id, @p_division_id, @p_engine_plan_id
        -- SELECT 'PR_SCP_ENG_OUT_MATERIAL_PLAN', @rows;
        IF @rows < 0 GOTO _RETURN_ERR_CODE		

        EXEC @ROWS = PR_SCP_ENG_OUT_PEGGING_INFO @p_plan_cycle, @p_plan_name, @p_plan_id, @p_modeling_id, @p_seq, @p_plan_type, @p_master_id, @p_division_id, @p_engine_plan_id
        -- SELECT 'PR_SCP_ENG_PEGGING_INFO_OUT', @rows;
        IF @rows < 0 GOTO _RETURN_ERR_CODE

		-- 2018.04.17 Unpegging 추가
        EXEC @ROWS = PR_SCP_ENG_OUT_UNPEGGING_INFO @p_plan_cycle, @p_plan_name, @p_plan_id, @p_modeling_id, @p_seq, @p_plan_type, @p_master_id, @p_division_id, @p_engine_plan_id
        -- SELECT 'PR_SCP_ENG_PEGGING_INFO_OUT', @rows;
        IF @rows < 0 GOTO _RETURN_ERR_CODE

        EXEC @ROWS = PR_SCP_ENG_OUT_PROBLEMREPORT @p_plan_cycle, @p_plan_name, @p_plan_id, @p_modeling_id, @p_seq, @p_plan_type, @p_master_id, @p_division_id, @p_engine_plan_id
        -- SELECT 'PR_SCP_ENG_PROBLEMREPORT_OUT', @rows;
        IF @rows < 0 GOTO _RETURN_ERR_CODE

        EXEC @ROWS = PR_SCP_ENG_OUT_PROBLEM_DATA @p_plan_cycle, @p_plan_name, @p_plan_id, @p_modeling_id, @p_seq, @p_plan_type, @p_master_id, @p_division_id, @p_engine_plan_id
        -- SELECT 'PR_SCP_ENG_PROBLEM_DATA_OUT', @rows;
        IF @rows < 0 GOTO _RETURN_ERR_CODE

        EXEC @ROWS = PR_SCP_ENG_OUT_PRODUCTION_PSI @p_plan_cycle, @p_plan_name, @p_plan_id, @p_modeling_id, @p_seq, @p_plan_type, @p_master_id, @p_division_id, @p_engine_plan_id
        -- SELECT 'PR_SCP_ENG_PRODUCTION_PSI_OUT', @rows;
        IF @rows < 0 GOTO _RETURN_ERR_CODE

        EXEC @ROWS = PR_SCP_ENG_OUT_SALES_PSI @p_plan_cycle, @p_plan_name, @p_plan_id, @p_modeling_id, @p_seq, @p_plan_type, @p_master_id, @p_division_id, @p_engine_plan_id
        -- SELECT 'PR_SCP_ENG_SALES_PSI_OUT', @rows;
        IF @rows < 0 GOTO _RETURN_ERR_CODE

        EXEC @ROWS = PR_SCP_ENG_OUT_UTILIZATION @p_plan_cycle, @p_plan_name, @p_plan_id, @p_modeling_id, @p_seq, @p_plan_type, @p_master_id, @p_division_id, @p_engine_plan_id
        -- SELECT 'PR_SCP_ENG_UTILIZATION_OUT', @rows;
        IF @rows < 0 GOTO _RETURN_ERR_CODE

        EXEC @ROWS = PR_SCP_ENG_OUT_WORK_ORDER @p_plan_cycle, @p_plan_name, @p_plan_id, @p_modeling_id, @p_seq, @p_plan_type, @p_master_id, @p_division_id, @p_engine_plan_id
        -- SELECT 'PR_SCP_ENG_WORK_ORDER_OUT', @rows;
        IF @rows < 0 GOTO _RETURN_ERR_CODE

        -----------------------------------------------------------

        -----------------------------------------------------------
        -- 실행 Logic END --
        -----------------------------------------------------------
	
        -- Plan Detail 정보 Update
        UPDATE /* PR_SCP_ENG_OUT_ALL */
               scm_mst_plan_detail
        SET    plan_output_end_date = GETDATE()
             , output_start_date    = GETDATE()
             , last_update_date     = GETDATE()
        WHERE  modeling_id = @p_modeling_id
        AND    division_id = @p_division_id
        AND    plan_id     = @p_plan_id
        AND    plan_seq    = @p_seq        
        AND    plan_type   = @p_plan_type 
        ;

        -- TXN LOG
        SET @v_log_type    = 'TXN';
        SET @n_log_count   = @@ROWCOUNT;
        SET @v_log_message = 'CALL  ' + @v_table_id;
        SET @v_description = 'Process Complete... ' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date  = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        IF @@TRANCOUNT > 0
          BEGIN
            COMMIT WORK;
          END;

        _RETURN_ERR_CODE:
        BEGIN
          IF @rows < 0
            BEGIN
              RETURN -1
            END; -- IF @rows < 0
        END;

      END;

    END TRY

    BEGIN CATCH
      -- ROLLBACK
      -- ERROR LOG
      SET @v_log_type    = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE()) + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
      SET @d_event_date  = SYSDATETIME();
      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
      RETURN -1
    END CATCH;

    -- 종료 LOG
    SET @v_log_type    = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = @p_master_id + ' / ' + @p_engine_plan_id ;
    SET @d_event_date  = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
    RETURN 1

  END;


