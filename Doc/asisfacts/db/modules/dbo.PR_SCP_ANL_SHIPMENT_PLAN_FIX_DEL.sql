
/*
 * Program ID   : PR_SCP_ANL_SHIPMENT_PLAN_FIX_DEL
 * Description  : 매주 Pre Plan 수행 전 시점에 Shipment Plan FIX 정보 삭제
 *                - 자동차사업부 / To Site가 SALES인 FG향 정보 대상
 * OutTable     : SCP_ANL_SHIPMENT_PLAN_FIX
 * Execute      : EXEC PR_SCP_ANL_SHIPMENT_PLAN_FIX_DEL
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2019.05.21   KSG           Initial Release [CSR ID:3997268]GSCM Shipment Plan Fix 기능 관련 변경 요청 | [요청번호]C20190520_97268
 * 2021.10.14   KSG           ESS 사업부 추가
 * 2025.05.19   kimcd         E20250429-000386  81 자동차 Division 갱신 로직 주석 처리
 */

CREATE PROCEDURE [dbo].[PR_SCP_ANL_SHIPMENT_PLAN_FIX_DEL]
--(      @p_division_id          NVARCHAR(30)      )
AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS OFF;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user   NVARCHAR(150) = N'scp_batch';
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SCP_ANL_SHIPMENT_PLAN_FIX_DEL';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER       = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @v_table_id     NVARCHAR(150) = N'SCP_ANL_SHIPMENT_PLAN_FIX';
    DECLARE @d_event_date   DATETIME;
                        
    -- 시작 LOG
    SET @v_log_type     = N'START';
    SET @v_log_message  = N'########## Start of procedure ##########';
    SET @v_description  = @v_program_name + ':' + N' SCP_ANL_SHIPMENT_PLAN_FIX DELETE LOGIC';
    SET @d_event_date   = SYSDATETIME();
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
                              ,@p_log_type      = @v_log_type
                              ,@p_log_count     = @n_log_count
                              ,@p_log_message   = @v_log_message
                              ,@p_description   = @v_description
                              ,@p_event_date    = @d_event_date
                              ,@p_user_id       = @v_batch_user
                              ;

    BEGIN TRY
      BEGIN
        --BEGIN TRAN TX_FG
          -------------------------------------------------------------------------------------------------------------
          -- 1. 자동차사업부(81) / FG향(To Site = 'SALES') FIX 정보 삭제
          ------------------------------------------------------------------------------------------------------------- 
		  -- 2025.05.19   kimcd         E20250429-000386  81 자동차 Division 갱신 로직 주석 처리 시작
          --DELETE scp_anl_shipment_plan_fix
		  /*
          UPDATE scp_anl_shipment_plan_fix 
		  SET    yyyymmdd         = '20011231'      -- Plan에사용되지 않는 과거 시점
		       , last_updated_by  = 'Weekly Delete' -- 구분자
			   , last_update_date = GETDATE()
          WHERE  division_id = '81'
          AND    to_site IN (SELECT scm_site_id
                             FROM   scm_mst_site with(nolock)
                             WHERE  division_id = '81'
                             AND    site_type   = 'SALES'
                            )
          ;

        -- TXN LOG
        SET @n_log_count    = @@ROWCOUNT;
        SET @v_log_type     = N'TXN';
        SET @v_log_message  = N'UPDATE  '+@v_table_id;
        SET @d_event_date   = SYSDATETIME();
        SET @v_description  = N'1. 81 ' + ':' + CONVERT(CHAR(8), @d_event_date, 112);

        EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
                                  ,@p_log_type      = @v_log_type
                                  ,@p_log_count     = @n_log_count
                                  ,@p_log_message   = @v_log_message
                                  ,@p_description   = @v_description
                                  ,@p_event_date    = @d_event_date
                                  ,@p_user_id       = @v_batch_user
                                  ; */
          -- 2025.05.19   kimcd         E20250429-000386  81 자동차 Division 갱신 로직 주석 처리 종료


          -------------------------------------------------------------------------------------------------------------
          -- 2. ESS 사업부(82) / FG향(To Site = 'SALES') FIX 정보 삭제
          ------------------------------------------------------------------------------------------------------------- 
          --DELETE scp_anl_shipment_plan_fix
          UPDATE scp_anl_shipment_plan_fix 
		  SET    yyyymmdd         = '20011231'      -- Plan에사용되지 않는 과거 시점
		       , last_updated_by  = 'Weekly Delete' -- 구분자
			   , last_update_date = GETDATE()
          WHERE  division_id = '82'
          AND    to_site IN (SELECT scm_site_id
                             FROM   scm_mst_site with(nolock)
                             WHERE  division_id = '82'
                             AND    site_type   = 'SALES'
                            )
          ;

        -- TXN LOG
        SET @n_log_count    = @@ROWCOUNT;
        SET @v_log_type     = N'TXN';
        SET @v_log_message  = N'UPDATE  '+@v_table_id;
        SET @d_event_date   = SYSDATETIME();
        SET @v_description  = N'2. 82 ' + ':' + CONVERT(CHAR(8), @d_event_date, 112);

        EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
                                  ,@p_log_type      = @v_log_type
                                  ,@p_log_count     = @n_log_count
                                  ,@p_log_message   = @v_log_message
                                  ,@p_description   = @v_description
                                  ,@p_event_date    = @d_event_date
                                  ,@p_user_id       = @v_batch_user
                                  ;
        -----------------------------------------------------------
        -- 실행 Logic END --
        -----------------------------------------------------------
        --IF @@TRANCOUNT > 0
        --  BEGIN
        --    COMMIT TRAN TX_FG;
        --  END;

      END
    END TRY

    BEGIN CATCH

      -- ERROR LOG
      SET @v_log_type     = N'ERROR';
      SET @v_log_message  = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description  = N'ERROR_LINE : ' + STR(ERROR_LINE());
      SET @d_event_date   = SYSDATETIME();
      EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
                                ,@p_log_type      = @v_log_type
                                ,@p_log_count     = @n_log_count
                                ,@p_log_message   = @v_log_message
                                ,@p_description   = @v_description
                                ,@p_event_date    = @d_event_date
                                ,@p_user_id       = @v_batch_user
                                ;
      RETURN -1
    END CATCH

    -- 종료 LOG
    SET @v_log_type     = N'END';
    SET @v_log_message  = N'########## END of procedure ##########';
    SET @v_description  = N'';
    SET @d_event_date   = SYSDATETIME() ;
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
                              ,@p_log_type      = @v_log_type
                              ,@p_log_count     = @n_log_count
                              ,@p_log_message   = @v_log_message
                              ,@p_description   = @v_description
                              ,@p_event_date    = @d_event_date
                              ,@p_user_id       = @v_batch_user
                              ;
    RETURN 1

  END;
