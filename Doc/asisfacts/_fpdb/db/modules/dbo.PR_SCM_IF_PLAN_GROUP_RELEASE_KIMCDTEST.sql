
CREATE PROCEDURE [dbo].[PR_SCM_IF_PLAN_GROUP_RELEASE_KIMCDTEST]
WITH EXEC AS CALLER
AS

BEGIN
  SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
  SET XACT_ABORT ON;

  -- 필수 칼럼
  DECLARE @v_master_id      nvarchar(30)
  DECLARE @v_plan_id        nvarchar(30)
  DECLARE @v_plan_date      nvarchar(30)
  DECLARE @v_release_id     nvarchar(30)
  DECLARE @v_plan_group_id  nvarchar(30)

  -- LOG 용 변수 설정
  DECLARE @v_proc_name      nvarchar(100) = 'PR_SCM_IF_PLAN_GROUP_RELEASE_KIMCDTEST'
  DECLARE @v_table_name     nvarchar(100)
  DECLARE @v_message        nvarchar(250)
  DECLARE @v_descr          nvarchar(250)
  DECLARE @n_row_count      Integer  = 0
  DECLARE @n_log_count      Integer  = 0
  DECLARE @v_log_code       nvarchar(10)
  DECLARE @n_cnt            Integer  = 0
  DECLARE @v_confirm_date   date
  DECLARE @v_order_date_code nvarchar(10)
  DECLARE @v_amend_plan_id  nvarchar (100)
  DECLARE @v_fix_count      Int
  DECLARE @v_release_term   Int
  
  DECLARE @sysdate          DATETIME2 = GETDATE()
  DECLARE @v_insert_dttm    date

  DECLARE @v_lgc_site           nvarchar(10)

  DECLARE @v_temp1          nvarchar(1000)
  DECLARE @v_temp2          nvarchar(1000)
  
  SET @v_master_id      = 'CN_FORM_T'
  SET @v_plan_id        = 'CN_FORM_T-20210525-99'
  SET @v_plan_date      = '20210525'
  SET @v_release_id     = 'CN_FORM_T-20210525-99'
  SET @v_plan_group_id  = '2D'
  
  SET @v_temp1 = 'S' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))
  SET @v_temp2 = 'E' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))
  
  SET @n_log_count = @n_log_count + 1
  SET @sysdate = GETDATE()
  EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'START', @n_log_count, null, '############### Start of procedure ###############', null

  BEGIN TRY

  		SET @n_log_count = @n_log_count + 1
  		SET @v_message = @v_master_id + ' PR_XIF_MES_MO_S Start'
  		EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'CALL', @n_log_count, NULL, @v_message, null
  		SELECT 'Pre'			
  		EXEC PR_XIF_MES_MO_S @v_plan_id

  		SET @n_log_count = @n_log_count + 1
  		SET @v_message = @v_master_id + ' PR_XIF_MES_MO_S End'
  		EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'CALL', @n_log_count, NULL, @v_message, null
            
  		SET @n_log_count = @n_log_count + 1
  		SET @v_message = @v_master_id + ' PR_XIF_MES_WO_PEGGING_S Start'
  		EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'CALL', @n_log_count, NULL, @v_message, null
  					
  		EXEC PR_XIF_MES_WO_PEGGING_S @v_plan_id

  		SET @n_log_count = @n_log_count + 1
  		SET @v_message = @v_master_id + ' PR_XIF_MES_WO_PEGGING_S End'
  		EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'CALL', @n_log_count, NULL, @v_message, null
            
  		SET @n_log_count = @n_log_count + 1
  		SET @v_message = @v_master_id + ' PR_XIF_MES_WO_S Start'
  		EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'CALL', @n_log_count, NULL, @v_message, null
  					
  		EXEC PR_XIF_MES_WO_S @v_plan_id

  		SET @n_log_count = @n_log_count + 1
  		SET @v_message = @v_master_id + ' PR_XIF_MES_WO_S End'
  		EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'CALL', @n_log_count, NULL, @v_message, null
            
  		SET @n_log_count = @n_log_count + 1
  		SET @v_message = @v_master_id + ' PR_XIF_MES_DAILY_PP_S Start'
  		EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'CALL', @n_log_count, NULL, @v_message, null
  					
  		EXEC PR_XIF_MES_DAILY_PP_S @v_plan_id

  		SET @n_log_count = @n_log_count + 1
  		SET @v_message = @v_master_id + ' PR_XIF_MES_DAILY_PP_S End'
  		EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'CALL', @n_log_count, NULL, @v_message, null

  END TRY

  BEGIN CATCH
    UPDATE SCM_FP_PLAN_H SET
           RELEASE_FLAG = 'E'
    WHERE  INSTANCE_ID  = @v_master_id
    AND    PLAN_ID      = @v_plan_id

    SET @v_descr = ERROR_MESSAGE()
    SET @sysdate = GETDATE()

    EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'ERROR', null, @v_temp2, null, @v_descr
  END CATCH

  SET @n_log_count = @n_log_count + 1
  EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'END', 999999, null, '############### End of procedure ###############', null

END
