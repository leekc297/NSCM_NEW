CREATE PROCEDURE [dbo].[PR_SCM_OF_PSI_SHORTER_LT_SIM_CALL]
@p_instance_id nvarchar(MAX) = '-', @p_plan_id nvarchar(MAX) = '-' , @p_check_parallel nvarchar(10) = 'N'
WITH EXEC AS CALLER
AS
BEGIN
  SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
  SET XACT_ABORT ON

  -- LOG 용 변수 설정
  DECLARE @v_proc_name nvarchar(100) = 'PR_SCM_OF_PSI_SHORTER_LT_SIM'
  DECLARE @v_descr     nvarchar(250)
  DECLARE @v_flag  nvarchar(1) = 'N'
  DECLARE @v_run_flag  nvarchar(1) = 'N'
  DECLARE @v_run_step  nvarchar(1) = '0'
  DECLARE @v_plan_flag  nvarchar(1) = 'C'
  DECLARE @v_run_step2  nvarchar(1) = '0'
  DECLARE @n_loop_date nvarchar(250)
  DECLARE @n_loop_count INTEGER    = 0
  DECLARE @n_check_parallel nvarchar(10) = @p_check_parallel
  
  DECLARE @n_log_count  INTEGER    = 0
  DECLARE @sysdate      DATETIME     = GETDATE()
  DECLARE @logdate      DATETIME2 = GETDATE()
  DECLARE @v_log_code   nvarchar(10)
  DECLARE @v_isfinished nvarchar(20)
  
  -- ERROR_LINE
  DECLARE @v_temp1     nvarchar(1000)
  DECLARE @v_temp2     nvarchar(1000)

  -- ================================================
    -- Declare start
  -- ================================================
  DECLARE @v_instance_id  nvarchar(1000)  
  DECLARE @v_plan_id    nvarchar(1000)
  
  DECLARE @sqltext    nvarchar(1000)
  -- ================================================
    -- Declare end
  -- ================================================
  SET @v_instance_id  = @p_instance_id
  SET @v_plan_id    = @p_plan_id
  
  SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))
  SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))

  SET @n_log_count = @n_log_count + 1
  --EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', @n_log_count, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate
  
  EXEC PR_LOG_PROCESS @sysdate, @v_instance_id, @v_plan_id, @v_proc_name, null, 'START', @n_log_count, null, '############### Start of procedure ###############', null
  
  BEGIN TRY        

    BEGIN
     

      SET @v_descr = @v_instance_id + ' PR_SCM_OF_PSI_SHORTER_LT_SIM Start'
      EXEC PR_LOG2_PROCESS @sysdate, @v_instance_id, @v_plan_id, @v_proc_name, null, 'CALL', @n_log_count, NULL, @v_descr, null
      
      IF @n_check_parallel = 'N'
      
      EXEC(@v_instance_id+'_SY_PR_SCM_OF_PSI_SHORTER_LT_SIM '''+@v_instance_id+''','''+@v_plan_id+'''')
      
      ELSE 
      BEGIN
        
        EXEC PR_LOG2_RUNLOG  @logdate, @v_instance_id, @v_plan_id, @v_proc_name, 'START', null
        
        EXEC(@v_instance_id+'_SY_PR_SCM_OF_PSI_SHORTER_LT_SIM_PARALLEL '''+@v_instance_id+''','''+@v_plan_id+'''')
        
        EXEC PR_LOG2_RUNLOG  @logdate, @v_instance_id, @v_plan_id, @v_proc_name, 'END', null
        
      END
      
   -- EXEC PR_XIF_LOG @v_proc_name, NULL, 'END',   999999, @v_temp1, '############### End of procedure ###############', NULL, @sysdate  

    EXEC PR_LOG_PROCESS @sysdate, @v_instance_id, @v_plan_id, @v_proc_name, null, 'END', @n_log_count, null, '############### End of procedure ###############', null
    
    END

  END TRY

  BEGIN CATCH
       
    -- 에러나도 로그는 인서트
    SET @v_log_code = 'E' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))
    SET @v_descr = ERROR_MESSAGE()
    --EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate
    
    EXEC PR_LOG2_PROCESS @sysdate, @v_instance_id, @v_plan_id, @v_proc_name, null, 'ERROR', null, @v_log_code, null, @v_descr

      IF @@TRANCOUNT > 0
         COMMIT WORK 
  END CATCH
  
  --EXEC PR_XIF_LOG @v_proc_name, NULL, 'END',   999999, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
  
  EXEC PR_LOG2_PROCESS @sysdate, @v_instance_id, @v_plan_id, @v_proc_name, null, 'END', 999999, null, '############### End of procedure ###############', null

END
