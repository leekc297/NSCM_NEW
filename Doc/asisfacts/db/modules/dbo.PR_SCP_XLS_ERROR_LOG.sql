

CREATE PROCEDURE [dbo].[PR_SCP_XLS_ERROR_LOG]
(
	@P_MSG NVARCHAR(100) 
	, @P_TYPE NVARCHAR(100) = NULL
	, @P_SOURCE NVARCHAR(100) = NULL
	, @P_LINE  INT = 0
	, @P_DETAIL NVARCHAR(100) = NULL
	, @P_DIVISION_ID NVARCHAR(100)	 = '81'
	, @P_USER_ID      NVARCHAR(100) ='SCP_BATCH'
	, @p_EXCEL_VER		NVARCHAR(100) = '19991231'
	, @p_FILENAME		NVARCHAR(100) = ''
	, @p_IS_DEBUG		BIT = 0
 )
AS
/****************************************************************************
  * PROGRAM NAME  : PR_SCP_XLS_ERROR_LOG
  * DESCRIPTION   : SCP 시뮬레이터 Batch 프로그램 ERROR LOG
  *
  * PROGRAM HISTORY
  *--------------------------------------------------------------
  *  DATE      IN CHARGE           DESCRIPTION
  *--------------------------------------------------------------
  * 2024-11-05  KSK				신규생성
  
****************************************************************************/
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 

	BEGIN TRY
		INSERT INTO [dbo].[SCP_XLS_ERROR_LOG]
			   (
				MSG
			   ,[TYPE]
			   ,[Source]
			   ,[Line]
			   ,[DETAIL]
			   ,[DIVISION_ID]
			   ,[USER_ID]
			   , EXCEL_VER
			   , [FILENAME]
			   ,[EVENT_DATE]
			   , IS_DEBUG
			   )
		 VALUES
			   (
				  @P_MSG
				, @P_TYPE
				, @P_SOURCE
				, @P_LINE
				, @P_DETAIL
				, @P_DIVISION_ID
				, @P_USER_ID
				, @P_EXCEL_VER
				, @P_FILENAME
				, GETDATE()
				, @p_IS_DEBUG
			   )			
	END TRY
	BEGIN CATCH

	 DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
     DECLARE @n_log_count    INTEGER = 0;
     DECLARE @v_log_message  NVARCHAR(1000);
     DECLARE @v_description  NVARCHAR(500);     
	 DECLARE @d_event_date   DATETIME;
		
     SET @v_log_type = N'ERROR';
     SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
     SET @v_description = N'ERROR_LINE : ' + STR(ERROR_LINE());
     set @d_event_date = getdate()

     EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = 'PR_SCP_XLS_ERROR_LOG'
                                ,@p_log_type      = @v_log_type
                                ,@p_log_count     = @n_log_count 
                                ,@p_log_message   = @v_log_message 
                                ,@p_description   = @v_description 
                                ,@p_event_date    = @d_event_date
                                ,@p_user_id       = @P_USER_ID ;
		RETURN -1
	END CATCH

  END;

