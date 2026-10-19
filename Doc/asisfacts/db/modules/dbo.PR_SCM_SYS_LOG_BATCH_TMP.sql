
/*
 * Program ID   : PR_SCM_SYS_LOG_BATCH_TMP
 * Description  : Batch 프로그램 LOG 생성 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017. 11. 01    Kim Jaejung      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 *
 */


CREATE PROCEDURE [dbo].[PR_SCM_SYS_LOG_BATCH_TMP]
  @p_program_name NVARCHAR(150)
 ,@p_log_type     NVARCHAR(30) -- START/END/ERROR
 ,@p_log_count    INTEGER
 ,@p_log_message  NVARCHAR(1000)
 ,@p_description  NVARCHAR(500)
 ,@p_event_date   DATETIME
 ,@p_user_id      NVARCHAR(100)
AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

    -- DECLARE @v_user_id NVARCHAR(100) = [dbo].[FN_GET_USER_ID]();

	BEGIN TRANSACTION PR_SCM_SYS_LOG_BATCH_TMP;
    
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
             ,@p_user_id
             ,SYSDATETIME()
             ,@p_user_id);

      IF @@TRANCOUNT > 0 
        COMMIT TRANSACTION PR_SCM_SYS_LOG_BATCH_TMP;
    END TRY

    BEGIN CATCH
      BEGIN
	    ROLLBACK TRANSACTION  PR_SCM_SYS_LOG_BATCH_TMP;

		BEGIN TRAN PR_SCM_SYS_LOG_BATCH_TMP2
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
               ,@p_user_id
               ,SYSDATETIME()
               ,@p_user_id);

        COMMIT TRAN PR_SCM_SYS_LOG_BATCH_TMP;
	   END;
    END CATCH;

  END;
