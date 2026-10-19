
/*
 * Program ID   : PR_SCM_SYS_LOG_BATCH
 * Description  : Batch 프로그램 LOG 생성 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017. 11. 01    Kim Jaejung      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 *
 */


CREATE PROCEDURE [dbo].[PR_SCM_SYS_LOG_BATCH]
  @p_program_name NVARCHAR(150)
 ,@p_log_type     NVARCHAR(30) -- START/END/ERROR
 ,@p_log_count    INTEGER
 ,@p_log_message  NVARCHAR(1000)
 ,@p_description  NVARCHAR(500)
 ,@p_event_date   DATETIME
AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

	BEGIN TRANSACTION PR_SCM_SYS_LOG_BATCH;

    PRINT 'PR_SCM_SYS_LOG_BATCH : AFTER BEGIN TRAN';
    PRINT @@TRANCOUNT;
    
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
                                    ,last_updated_by)
      VALUES (@p_program_name
             ,@p_log_type
             ,@p_log_count
             ,@p_log_message
             ,@p_description
             ,@p_event_date
             ,SYSDATETIME()
             ,'scm_batch'
             ,SYSDATETIME()
             ,'scm_batch');

      IF @@TRANCOUNT > 0 
        COMMIT TRANSACTION PR_SCM_SYS_LOG_BATCH;
        PRINT 'PR_SCM_SYS_LOG_BATCH : AFTER COMMIT TRAN';
        PRINT @@TRANCOUNT;
    END TRY

    BEGIN CATCH
      BEGIN
	    ROLLBACK TRANSACTION  PR_SCM_SYS_LOG_BATCH;
        PRINT 'PR_SCM_SYS_LOG_BATCH : AFTER ROLLBACK TRAN';
        PRINT @@TRANCOUNT;

		BEGIN TRAN PR_SCM_SYS_LOG_BATCH2
        PRINT 'PR_SCM_SYS_LOG_BATCH : AFTER BEGIN TRAN2';
        PRINT @@TRANCOUNT;
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

        COMMIT TRAN PR_SCM_SYS_LOG_BATCH2;
        PRINT 'PR_SCM_SYS_LOG_BATCH : AFTER COMMIT TRAN2';
        PRINT @@TRANCOUNT;
	   END;
    END CATCH;

  END;
