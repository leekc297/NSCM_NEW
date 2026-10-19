CREATE PROCEDURE [dbo].[PR_SCP_ANL_PLN_TABLE_DELETE_KILL]
AS
/*
 * Program ID   : PR_SCP_ANL_PLN_TABLE_DELETE_KILL
 * Description  : PR_SCP_ANL_PLN_TABLE_DELETE 프로시져 kill 용
 * Program History
 * 
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2020.02.18    khj79         SCP ANL PLN 테이블 삭제
 *
 */
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;
	
    -- LOG 용 변수 설정
    DECLARE @v_batch_user	NVARCHAR(150) = 'scm_batch';
	DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_ANL_PLN_TABLE_DELETE_KILL';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
	DECLARE @v_ReturnCode	NVARCHAR(500);
	DECLARE @v_job_count	bigint;
	DECLARE @v_session_count	bigint;
    DECLARE @d_event_date   DATETIME;
	DECLARE @v_session_id	NVARCHAR(100);
	DECLARE @v_sql			NVARCHAR(1000);
	DECLARE @object			nvarchar(50);
	DECLARE @step_name	    NVARCHAR(1000);

	-- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();

    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    BEGIN TRY

	-- 1. Job Stop
	SELECT @v_job_count = COUNT(*)
    FROM   msdb.dbo.sysjobhistory
	WHERE  run_status in (4)
	AND    step_name like 'JOB.PR_SCP_ANL_PLN_TABLE_DELETE%'

	IF (@v_job_count > 0)
		BEGIN
		DECLARE CUR_JOB_NAME CURSOR FOR
			SELECT step_name
			FROM   msdb.dbo.sysjobhistory
			WHERE  run_status in (4)
			AND    step_name like 'JOB.PR_SCP_ANL_PLN_TABLE_DELETE%'
		
		OPEN CUR_JOB_NAME;
		FETCH NEXT FROM CUR_JOB_NAME INTO @step_name ;

		WHILE (@@FETCH_STATUS = 0)
		  BEGIN
			EXEC msdb.dbo.sp_stop_job @step_name ;
			FETCH NEXT FROM CUR_JOB_NAME INTO @step_name ;
		  END

		CLOSE CUR_JOB_NAME;
		DEALLOCATE CUR_JOB_NAME;

		END

    -- 2. Session Kill
	SELECT @v_session_count = COUNT(*)
	FROM
		(
		SELECT * FROM sys.dm_exec_requests 
		WHERE sql_handle is not null
		) a 
	CROSS APPLY  sys.dm_exec_sql_text(a.sql_handle) t 
	WHERE t.text like '%/* PR_SCP_ANL_PLN_TABLE_DELETE */%'
	AND command = 'DELETE'

	IF (@v_session_count > 0)
		BEGIN
		DECLARE CUR_SESSION_ID CURSOR FOR
			SELECT session_id
			FROM
				(
				SELECT * FROM sys.dm_exec_requests 
				WHERE sql_handle is not null
				) a 
			CROSS APPLY  sys.dm_exec_sql_text(a.sql_handle) t 
			WHERE t.text like '%/* PR_SCP_ANL_PLN_TABLE_DELETE */%'
			AND command = 'DELETE'
		
		OPEN CUR_SESSION_ID;
		FETCH NEXT FROM CUR_SESSION_ID INTO @v_session_id ;

		WHILE (@@FETCH_STATUS = 0)
		  BEGIN

			IF (@v_session_id IS NOT NULL)
			BEGIN
				SET @v_sql = 'KILL ' + @v_session_id + ';';
				EXECUTE sp_executesql @v_sql;
			END

			FETCH NEXT FROM CUR_SESSION_ID INTO @v_session_id ;
		  END

		CLOSE CUR_SESSION_ID;
		DEALLOCATE CUR_SESSION_ID;

		END
    END TRY

    BEGIN CATCH
      -- ROLLBACK
      -- ERROR LOG
      SET @v_log_type = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = CAST(ERROR_LINE() AS nvarchar(10));
      SET @d_event_date = SYSDATETIME();
       EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
    END CATCH;
   
  -- 종료 LOG
  SET @v_log_type    = 'END';
  SET @v_log_message = '########## END of procedure ##########';
  SET @v_description = '';
  SET @d_event_date  = SYSDATETIME();
  EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

  END;
