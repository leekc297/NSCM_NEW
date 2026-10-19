---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[PR_DM_SYS_LOG_BATCH]
(
  @p_program_name NVARCHAR(150)
 ,@p_log_type     NVARCHAR(30) -- START/END/ERROR
 ,@p_log_count    INTEGER
 ,@p_log_message  NVARCHAR(1000)
 ,@p_description  NVARCHAR(500)
 ,@p_event_date   DATETIME
 ,@p_user_id      NVARCHAR(30) ='SCP_BATCH'
 )
AS
/****************************************************************************
  * PROJECT       : LG CHEM SCP PRJ.
  * PROGRAM NAME  : PR_DM_SYS_LOG_BATCH
  * DESCRIPTION   : Batch 프로그램 LOG 생성 
  *
  * PROGRAM HISTORY
  *--------------------------------------------------------------
  *  DATE      IN CHARGE           DESCRIPTION
  *--------------------------------------------------------------
  * 2021-06-23   HWI1993        PR_SCP_SYS_LOG_BATCH 에서 트랜잭션 제거하고 신규 생성
								XACT_STATE() = -1 일 경우 쓰기작업 시도시 에러발생하므로 제외함.
  ****************************************************************************/
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	SET NOCOUNT ON; 
	SET XACT_ABORT ON;

	BEGIN TRY
		IF XACT_STATE() <> -1
		BEGIN
			INSERT INTO SCM_SYS_LOG_BATCH (PROGRAM_NAME
				,LOG_TYPE
				,LOG_COUNT
				,LOG_MESSAGE
				,DESCRIPTION
				,EVENT_DATE
				,CREATION_DATE
				,CREATED_BY
				,LAST_UPDATE_DATE
				,LAST_UPDATED_BY)
			VALUES (@P_PROGRAM_NAME
				,@P_LOG_TYPE
				,@P_LOG_COUNT
				,@P_LOG_MESSAGE
				,@P_DESCRIPTION
				,@P_EVENT_DATE
				,SYSDATETIME()
				,@P_USER_ID
				,SYSDATETIME()
				,@P_USER_ID);
		END
	END TRY

	BEGIN CATCH
		IF XACT_STATE() <> -1
		BEGIN

		INSERT INTO SCM_SYS_LOG_BATCH (PROGRAM_NAME
			,LOG_TYPE
			,LOG_COUNT
			,LOG_MESSAGE
			,DESCRIPTION
			,EVENT_DATE
			,CREATION_DATE
			,CREATED_BY
			,LAST_UPDATE_DATE
			,LAST_UPDATED_BY)
		VALUES (ERROR_PROCEDURE()
			,'ERROR'
			,NULL
			,ERROR_MESSAGE()
			,NULL
			,SYSDATETIME()
			,SYSDATETIME()
			,ERROR_PROCEDURE()
			,SYSDATETIME()
			,ERROR_PROCEDURE());
		END;
	END CATCH;
END;


