
/*
 * Program ID   : PR_SCP_MST_ALTER_BOM_ALL_BATCH
 * Description  : 대체 BOM 생성 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021.04.12   SEO			PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선
 *							- SCP 대치BOM
 *
 */

CREATE PROCEDURE [dbo].[PR_SCP_MST_ALTER_BOM_ALL_BATCH] AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS OFF;

    -- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_MST_ALTER_BOM_ALL_BATCH';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @v_table_id     NVARCHAR(150) = '';
    DECLARE @d_event_date   DATETIME;
	
    DECLARE @rows                INT;
	
	-- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = '[PR_SCP_MST_ALTER_BOM_ALL_BATCH]';
    SET @d_event_date = SYSDATETIME();

    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, NULL, @v_log_message, @v_description, @d_event_date;

    SET @rows = 0;


    BEGIN TRY
		BEGIN
			-----------------------------------------------------------
			-- 실행 Logic START --
			-----------------------------------------------------------

			--SCM_MST_ALTER_BOM, SCM_MST_ALTER_BOM_MODEL 생성
			EXEC @rows = PR_SCP_MST_ALTER_BOM;
			SELECT 'PR_SCP_MST_ALTER_BOM', @rows;
			IF @rows < 0 GOTO _RETURN_ERR_CODE

			--SCM_MST_MODEL_BOM 생성
			EXEC @rows = PR_SCP_MST_MODEL_BOM_ALL;
			SELECT 'PR_SCP_MST_MODEL_BOM_ALL', @rows;
			IF @rows < 0 GOTO _RETURN_ERR_CODE

			--SCM_MST_MODEL_BOM_EFFECTIVE 생성
			EXEC @rows = PR_SCP_MST_MODEL_BOM_EFF_ALL;
			SELECT 'PR_SCP_MST_MODEL_BOM_EFF_ALL', @rows;
			IF @rows < 0 GOTO _RETURN_ERR_CODE
		
			-----------------------------------------------------------
			-- 실행 Logic END --
			-----------------------------------------------------------
			SET @v_log_type = 'TXN';
			SET @n_log_count = @@ROWCOUNT;
			SET @v_log_message = 'RUN ';
			SET @v_description = 'Process Complete... ';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		
			_RETURN_ERR_CODE:
			IF @rows < 0
			BEGIN
				SET @v_log_type = 'ERROR';
				SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
				SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
				SET @d_event_date = SYSDATETIME();
				EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
				RETURN -1
			END;
		END;
    END TRY

    BEGIN CATCH
      -- ROLLBACK
      -- ERROR LOG
      SET @v_log_type = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE()) ;
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, NULL, @v_log_message, @v_description, @d_event_date;
      RETURN -1
    END CATCH;

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = '[PR_SCP_MST_ALTER_BOM_ALL_BATCH]';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, NULL, @v_log_message, @v_description, @d_event_date;
    RETURN 1 

  END;

