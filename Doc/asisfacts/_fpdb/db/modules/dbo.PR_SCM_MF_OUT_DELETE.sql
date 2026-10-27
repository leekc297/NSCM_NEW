CREATE PROCEDURE [dbo].[PR_SCM_MF_OUT_DELETE]
   @p_master_id nvarchar(max) = '-',
   @p_plan_id nvarchar(max) = '-'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_SCM_MF_OUT_DELETE                                                             **/
/** 프로그램 명   :                                                                           **/
/** 설 명         :                                                                            **/
/** Version       : 1.0.0                                                                     **/
/**                                                                                           **/
/** Argument                                                                                   **/
/**                                                                                           **/
/**  [검색 조건]                                                                                **/
/**                                                                                           **/
/** [Biz Logic]                                                                                **/
/**                                                                                           **/
/**-------------------------------------------------------------------------------------------**/
/** 작 성 일 자    작 성 자      사     유                                                       **/
/**===========================================================================================**/
/** 2016.08.17    LJH          최초 작성                                                      **/
/***********************************************************************************************/
/*
  EXEC PR_SCM_MF_OUT_DELETE

*/
BEGIN
  SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
  SET XACT_ABORT ON;

  -- 필수 칼럼
  DECLARE @v_master_id      nvarchar(30)
  DECLARE @v_plan_id        nvarchar(30)
  DECLARE @v_new_plan_id    nvarchar(30)

  -- LOG 용 변수 설정
  DECLARE @v_proc_name      nvarchar(100) = 'PR_SCM_MF_OUT_DELETE'
  DECLARE @v_table_name     nvarchar(100)
  DECLARE @v_message        nvarchar(250)
  DECLARE @v_descr          nvarchar(250)
  DECLARE @n_row_count      Integer  = 0
  DECLARE @n_log_count      Integer  = 0
  DECLARE @v_log_code        nvarchar(10)
  
  DECLARE @sysdate          DATETIME2 = GETDATE()
  DECLARE @v_insert_dttm    date

  DECLARE @v_temp1          nvarchar(1000)
  DECLARE @v_temp2          nvarchar(1000)
  
  SET @v_master_id    = @p_master_id
  SET @v_plan_id      = @p_plan_id
  
  SET @v_temp1 = 'S' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))
  SET @v_temp2 = 'E' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))
  
  SET @n_log_count = @n_log_count + 1
  SET @sysdate = GETDATE()
  EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'START', @n_log_count, null, '############### Start of procedure ###############', null

  BEGIN TRY
    
    BEGIN
    
         /* TH_ENG_PLAN_STATUS 테이블 초기화 */
      SET @v_table_name = 'TH_ENG_PLAN_STATUS'
        DELETE FROM dbo.TH_ENG_PLAN_STATUS WHERE MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id AND OUT_VERSION_ID = @v_plan_id
    
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @@ROWCOUNT, null, null, null 
      
    
         /* OUT 테이블 초기화 */
      SET @v_table_name = 'TH_OUT_CONFIG_VALUE'
        DELETE FROM dbo.TH_OUT_CONFIG_VALUE WHERE MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id AND OUT_VERSION_ID = @v_plan_id
    
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @@ROWCOUNT, null, null, null 

      SET @v_table_name = 'TH_OUT_DELIVERY_ORDER'
        DELETE FROM dbo.TH_OUT_DELIVERY_ORDER WHERE MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id AND OUT_VERSION_ID = @v_plan_id
    
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @@ROWCOUNT, null, null, null 

      SET @v_table_name = 'TH_OUT_ITEM_PEGGING'
        DELETE FROM dbo.TH_OUT_ITEM_PEGGING WHERE MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id AND OUT_VERSION_ID = @v_plan_id
    
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @@ROWCOUNT, null, null, null 
         
      SET @v_table_name = 'TH_OUT_ITEM_PLAN'
        DELETE FROM dbo.TH_OUT_ITEM_PLAN WHERE MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id AND OUT_VERSION_ID = @v_plan_id
    
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @@ROWCOUNT, null, null, null 
         
      SET @v_table_name = 'TH_OUT_ITEM_PLAN_SPL'
        DELETE FROM dbo.TH_OUT_ITEM_PLAN_SPL WHERE MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id AND OUT_VERSION_ID = @v_plan_id
    
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @@ROWCOUNT, null, null, null 
         
      SET @v_table_name = 'TH_OUT_ORDER_TRACKING'
        DELETE FROM dbo.TH_OUT_ORDER_TRACKING WHERE MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id AND OUT_VERSION_ID = @v_plan_id
    
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @@ROWCOUNT, null, null, null 
         
      SET @v_table_name = 'TH_OUT_ORDER_TRACKING_DETAIL'
        DELETE FROM dbo.TH_OUT_ORDER_TRACKING_DETAIL WHERE MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id AND OUT_VERSION_ID = @v_plan_id
    
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @@ROWCOUNT, null, null, null 
         
      SET @v_table_name = 'TH_OUT_PROBLEM_DATA'
        DELETE FROM dbo.TH_OUT_PROBLEM_DATA WHERE MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id AND OUT_VERSION_ID = @v_plan_id
    
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @@ROWCOUNT, null, null, null 
         
      SET @v_table_name = 'TH_OUT_PROBLEM_REPORT'
        DELETE FROM dbo.TH_OUT_PROBLEM_REPORT WHERE MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id AND OUT_VERSION_ID = @v_plan_id
    
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @@ROWCOUNT, null, null, null 
         
      SET @v_table_name = 'TH_OUT_RESOURCE_USAGE'
        DELETE FROM dbo.TH_OUT_RESOURCE_USAGE WHERE MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id AND OUT_VERSION_ID = @v_plan_id
    
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @@ROWCOUNT, null, null, null 
         
      SET @v_table_name = 'TH_OUT_UTILIZATION'
        DELETE FROM dbo.TH_OUT_UTILIZATION WHERE MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id AND OUT_VERSION_ID = @v_plan_id
    
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @@ROWCOUNT, null, null, null 
         
      SET @v_table_name = 'TH_OUT_VERSION'
        DELETE FROM dbo.TH_OUT_VERSION WHERE MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id AND OUT_VERSION_ID = @v_plan_id
    
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @@ROWCOUNT, null, null, null 
         
      SET @v_table_name = 'TH_OUT_WO_DEMAND_MAP'
        DELETE FROM dbo.TH_OUT_WO_DEMAND_MAP WHERE MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id AND OUT_VERSION_ID = @v_plan_id
    
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @@ROWCOUNT, null, null, null 
         
      SET @v_table_name = 'TH_OUT_WORK_ORDER'
        DELETE FROM dbo.TH_OUT_WORK_ORDER WHERE MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id AND OUT_VERSION_ID = @v_plan_id
    
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @@ROWCOUNT, null, null, null 
         
      SET @v_table_name = 'TH_OUT_WORK_ORDER_SPL'
        DELETE FROM dbo.TH_OUT_WORK_ORDER_SPL WHERE MASTER_ID = @v_master_id AND PLAN_ID = @v_plan_id AND OUT_VERSION_ID = @v_plan_id
    
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @@ROWCOUNT, null, null, null 
         
    
      IF @@TRANCOUNT > 0
        COMMIT WORK 
    END;
    
  END TRY

  BEGIN CATCH
    --ROLLBACK

    SET @v_descr = ERROR_MESSAGE()
    SET @sysdate = GETDATE()

    EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'ERROR', null, @v_temp2, null, @v_descr
    commit;
  END CATCH

  SET @n_log_count = @n_log_count + 1
  EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'END', 999999, null, '############### End of procedure ###############', null

END
