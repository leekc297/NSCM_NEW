
/*
 * Program ID   : PR_SCP_ENG_EE_PRE_PROC_SALES_MODEL
 * Description  : SDB의 Sales Model 정보에 대하여 ODB에 적재되도록 한다.
 * OutTable     : TH_ENG_SALES_MODEL

 * EXEC           
                  DECLARE  @p_plan_cycle  NVARCHAR(150)   = 'WEEKLY'
                         , @p_plan_name   nvarchar(4000)  = '20180625'
                         , @p_plan_id     nvarchar(4000)  = '1032'
                         , @p_modeling_id nvarchar(4000)  = '4'
                         , @p_seq         nvarchar(4000)  = '1'
                         , @p_plan_type   nvarchar(4000)  = 'PR'
                         , @p_master_id   nvarchar(4000)  = 'EE::WEEKLY'
                         , @p_division_id nvarchar(30)    = 'EE'
                         , @p_engine_plan_id nvarchar(4000) = '1032::PR::1'
	
                  EXEC PR_SCP_ENG_EE_PRE_PROC_SALES_MODEL @p_plan_cycle, @p_plan_name, @p_plan_id, @p_modeling_id, @p_seq, @p_plan_type, @p_master_id, @p_division_id, @p_engine_plan_id             
                    
                  select * from th_eng_sales_model_sn WITH (NOLOCK)
                  where  master_id = 'EE::WEEKLY'
                  and    plan_id   = '1032::PR::1'
                  ;


 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017.12.22   정원식         Initial Release 전지본부 GSCM(DM/SCP) 구축 프로젝트
 *
 */

CREATE PROCEDURE  [dbo].[PR_SCP_ENG_EE_PRE_PROC_SALES_MODEL]
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
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_ENG_EE_PRE_PROC_SALES_MODEL';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @v_table_id     NVARCHAR(150) = 'TH_ENG_SALES_MODEL';
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
		DELETE 
		FROM   th_eng_sales_model_sn
        WHERE 1=1
        AND   plan_id   = @p_engine_plan_id
        AND   master_id = @p_master_id
		;
        -----------------------------------------------------------
		INSERT INTO th_eng_sales_model_sn
		    ( master_id
		    , plan_id
		    , sales_model_id
		    , descr
		    , priority
		    )
		SELECT DISTINCT
		       @p_master_id                   AS master_id
		     , @p_engine_plan_id              AS plan_id
		     , t.item + '^' + t.siteid + '^S' AS sales_model_id
		     , NULL                           AS descr
		     , 1                              AS priority
		FROM   scp_eng_itemsitemstr_i_sn t WITH (NOLOCK)
		WHERE  t.modeling_id = @p_modeling_id -- '1'    
		AND    t.plan_id     = @p_plan_id     -- '1004' 
        AND    t.plan_type   = @p_plan_type   --20180321 plan_type 추가
		AND    t.seq         = @p_seq    	  -- '1'    
		AND    t.enterprise  = @p_master_id   -- '1'    
		AND    t.item_type  <> 'R'
		AND    t.stage       = 'S_PSI'
        -- Demand에 있는데 sales model에 없는 모델 등록
        UNION -- 중복은 삭제됨
        SELECT DISTINCT
		       @p_master_id                   AS master_id
		     , @p_engine_plan_id              AS plan_id
		     , t.sales_model_id               AS sales_model_id
		     , NULL                           AS descr
		     , 1                              AS priority   
        FROM   th_eng_demand_sn t WITH (NOLOCK)
		WHERE  t.master_id = @p_master_id
        AND    t.plan_id   = @p_engine_plan_id
		;
		
        -----------------------------------------------------------

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


