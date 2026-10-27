CREATE PROCEDURE [dbo].[PR_SCM_OF_PSI_AMEND_UI_CALCULATION_PARALLEL_B]
@p_instance_id nvarchar(MAX) = '-', @p_plan_id nvarchar(MAX) = '-', @p_confirm_flag nvarchar(MAX) = '-'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_SCM_OF_PSI_AMEND_UI_CALCULATION_PARALLEL_B                             **/
/** 프로그램 명   : PSI_AMEND_UI 수량변경분 재계산                                            **/
/** 설 명         :                                                                           **/
/** Version       : 1.0.0                                                                     **/
/**                                                                                           **/
/** Argument                                                                                  **/
/**                                                                                           **/
/**  [검색 조건]                                                                              **/
/**                                                                                           **/
/** [Biz Logic]                                                                               **/
/**                                                                                           **/
/**-------------------------------------------------------------------------------------------**/
/** 작 성 일 자    작 성 자      사     유                                                    **/
/**===========================================================================================**/
/** 2017.11.10    KSJEON         최초 작성                                                    **/
/** **/
/***********************************************************************************************/

BEGIN
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
    SET NOCOUNT ON; 
  SET XACT_ABORT ON;

  -- 필수 칼럼
  DECLARE @v_master_id        nvarchar(30)    = @p_instance_id
  DECLARE @v_plan_id          nvarchar(30)    = @p_plan_id
  DECLARE @v_instance_id      nvarchar(30)    = @p_instance_id

  -- LOG 용 변수 설정
  DECLARE @v_proc_name        nvarchar(100) = 'PR_SCM_OF_PSI_AMEND_UI_CALCULATION_PARALLEL_B'
  DECLARE @v_table_name       nvarchar(100)
  DECLARE @v_message          nvarchar(250)
  DECLARE @v_descr            nvarchar(250)
  DECLARE @n_row_count        Integer  = 0
  DECLARE @n_log_count        Integer  = 0
  DECLARE @v_log_code         nvarchar(10)
  
  DECLARE @logdate            DATETIME2 = GETDATE()
  DECLARE @sysdate            DATETIME2 = GETDATE()

  DECLARE @v_temp1            nvarchar(1000)
  DECLARE @v_temp2            nvarchar(1000)
  
  -- 사용자 변수 설정

  
  SET @v_temp1 = 'S' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))
  SET @v_temp2 = 'E' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))

  EXEC PR_LOG2_RUNLOG  @logdate, @v_master_id, @v_plan_id, @v_proc_name, 'START', null

  SET @n_log_count = @n_log_count + 1
  SET @sysdate = GETDATE()
  EXEC PR_LOG2_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'START', @n_log_count, null, '############### Start of procedure ###############', null

  BEGIN TRY
    
    BEGIN
    
      BEGIN
      
        SET @v_table_name = SYSTEM_USER  --'PR_SCM_OF_PSI_AMEND_UI_UTIL'

        --LOG 생성
        SET @v_message   = 'PROCEDURE Start'
        SET @n_log_count = @n_log_count + 1
        SET @sysdate     = GETDATE()
        EXECUTE pr_log2_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'CALL', @n_log_count, null, @v_message, null

        IF CHARINDEX('DEV', SYSTEM_USER) = 0   -- 운영
          BEGIN

            EXEC(@v_instance_id+'_SY_PR_SCM_OF_PSI_AMEND_UI_UTIL '''+@v_instance_id+''','''+@v_plan_id+'''')

          END
        ELSE                            -- 개발
  BEGIN

            IF CHARINDEX('E_PRE', @v_master_id) > 0 OR CHARINDEX('E_PMIX', @v_master_id) > 0
              BEGIN
                
                EXEC KR_CELL_DEV.DBO.PR_SCM_OF_PSI_AMEND_UI_UTIL       @v_instance_id, @v_plan_id
                
              END
            ELSE IF @v_master_id IN ('KR_PACK','CN_PACK','US_PACK')
              BEGIN
                
                EXEC KR_CELL_DEV.DBO.PR_SCM_OF_PSI_AMEND_UI_UTIL      @v_instance_id, @v_plan_id

              END
            ELSE IF @v_master_id IN ('PL_PACK')
              BEGIN
                
                EXEC KR_CELL_DEV.DBO.PR_SCM_OF_PSI_AMEND_UI_UTIL    @v_instance_id, @v_plan_id

              END
            ELSE IF @v_master_id IN ('CN_CELL_M2', 'CN_CELL_M5')
              BEGIN
                
                EXEC KR_CELL_DEV.DBO.PR_SCM_OF_PSI_AMEND_UI_UTIL   @v_instance_id, @v_plan_id

              END
            ELSE
              BEGIN
            
                EXEC KR_CELL_DEV.DBO.PR_SCM_OF_PSI_AMEND_UI_UTIL      @v_instance_id, @v_plan_id
          
              END

          END

        
        SET @v_message   = 'PROCEDURE End'
        SET @n_log_count = @n_log_count + 1
        SET @sysdate     = GETDATE()
        EXECUTE pr_log2_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'CALL', @n_log_count, null, @v_message, null
              
      END
      
    END
    
  END TRY

  BEGIN CATCH
    --ROLLBACK

    SET @v_descr = ERROR_MESSAGE()
    SET @sysdate = GETDATE()
    
    EXEC PR_LOG2_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'ERROR', null, @v_temp2, null, @v_descr
    
    EXEC PR_LOG2_RUNLOG  @logdate, @v_master_id, @v_plan_id, @v_proc_name, 'ERROR', null

    commit;
  END CATCH

  SET @n_log_count = @n_log_count + 1
  EXEC PR_LOG2_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'END', 999999, null, '############### End of procedure ###############', null

  EXEC PR_LOG2_RUNLOG  @logdate, @v_master_id, @v_plan_id, @v_proc_name, 'END', null

END
