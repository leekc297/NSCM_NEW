CREATE PROCEDURE [dbo].[PR_SCP_SYS_LOG_BATCH]
(
  @p_program_name NVARCHAR(150)
 ,@p_log_type     NVARCHAR(30) -- START/END/ERROR
 ,@p_log_count    INTEGER
 ,@p_log_message  NVARCHAR(1000)
 ,@p_description  NVARCHAR(500)
 ,@p_event_date   DATETIME
 ,@p_user_id      NVARCHAR(30) ='SCP_BATCH'
 , @p_ATTRIBUTE1 nvarchar(150) = null
 , @p_ATTRIBUTE2 nvarchar(150) = null
 , @p_ATTRIBUTE3 nvarchar(150) = null
 , @p_ATTRIBUTE4 nvarchar(150) = null
 , @p_ATTRIBUTE5 nvarchar(150) = null
 , @p_ATTRIBUTE6 nvarchar(150) = null
 , @p_ATTRIBUTE7 nvarchar(150) = null
 , @p_ATTRIBUTE8 nvarchar(150) = null
 , @p_ATTRIBUTE9 nvarchar(150) = null
 , @p_ATTRIBUTE10 nvarchar(max) = null
 )
AS
/****************************************************************************
  * PROJECT       : LG CHEM SCP PRJ.
  * PROGRAM NAME  : PR_SCP_SYS_LOG_BATCH
  * DESCRIPTION   : Batch 프로그램 LOG 생성 
  *
  * PROGRAM HISTORY
  *--------------------------------------------------------------
  *  DATE      IN CHARGE           DESCRIPTION
  *--------------------------------------------------------------
  * 2018-01-19  YYDOK    PR_SCM_SYS_LOG_BATCH에 USER_ID PARAMETER추가하여 신규생성
  * 2024-09-06  KSK        ATTRIBUTE1~10 파라미터 추가

  ****************************************************************************/
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

	BEGIN TRANSACTION PR_SCP_SYS_LOG_BATCH;

    BEGIN TRY
      INSERT INTO scm_sys_log_batch (program_name
                                    ,log_type
                                    ,log_count
                                    ,log_message
                                    ,description
                                    ,event_date
                                    ,creation_date
                                    ,created_by
                                    ,last_update_date
                                    ,last_updated_by
									,ATTRIBUTE1
									,ATTRIBUTE2
									,ATTRIBUTE3
									,ATTRIBUTE4
									,ATTRIBUTE5
									,ATTRIBUTE6
									,ATTRIBUTE7
									,ATTRIBUTE8
									,ATTRIBUTE9
									,ATTRIBUTE10
									)
      VALUES (@p_program_name
             ,@p_log_type
             ,@p_log_count
             ,@p_log_message
             ,@p_description
             ,@p_event_date
             ,SYSDATETIME()
             ,@p_user_id
             ,SYSDATETIME()
             ,@p_user_id
			 ,@p_ATTRIBUTE1
			 ,@p_ATTRIBUTE2
			 ,@p_ATTRIBUTE3
			 ,@p_ATTRIBUTE4
			 ,@p_ATTRIBUTE5
			 ,@p_ATTRIBUTE6
			 ,@p_ATTRIBUTE7
			 ,@p_ATTRIBUTE8
			 ,@p_ATTRIBUTE9
			 ,@p_ATTRIBUTE10 )
			 ;

      IF @@TRANCOUNT > 0 
        COMMIT TRANSACTION PR_SCP_SYS_LOG_BATCH;
    END TRY

    BEGIN CATCH
      BEGIN
		ROLLBACK TRANSACTION  PR_SCP_SYS_LOG_BATCH;

		BEGIN TRANSACTION PR_SCP_SYS_LOG_BATCH2

        INSERT INTO scm_sys_log_batch (program_name
                                      ,log_type
                                      ,log_count
                                      ,log_message
                                      ,description
                                      ,event_date
                                      ,creation_date
                                      ,created_by
                                      ,last_update_date
                                      ,last_updated_by)
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

          COMMIT TRANSACTION PR_SCP_SYS_LOG_BATCH2;
      END;
    END CATCH;
  END;
