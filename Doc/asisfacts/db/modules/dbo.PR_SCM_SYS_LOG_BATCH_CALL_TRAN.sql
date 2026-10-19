
/*
 * Program ID   : PR_SCM_SYS_LOG_BATCH_CALL_TRAN
 * Description  : Batch 프로그램 LOG 생성 배치 다중 call 용도 로그 프로시저
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018. 1. 29    Okaniel      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 *
 */


create PROCEDURE [dbo].[PR_SCM_SYS_LOG_BATCH_CALL_TRAN]
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

      --IF @@TRANCOUNT > 0 
      --  COMMIT WORK;
    END TRY

    BEGIN CATCH
      BEGIN
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

        --IF @@TRANCOUNT > 0
        --  COMMIT WORK;
      END;
    END CATCH;
  END;