CREATE PROCEDURE [dbo].[PR_SCM_IF_PLAN]
@p_master_id nvarchar(MAX) = '-', @p_plan_id nvarchar(MAX) = '-'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_SCM_IF_PLAN                                                            **/
/** 프로그램 명   :                                                                           **/
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
/** 2016.01.01    COCHO          최초 작성                                                    **/
/***********************************************************************************************/
/*
  EXEC PR_SCM_IF_PLAN
*/
BEGIN
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
    SET NOCOUNT ON; 
  SET XACT_ABORT ON;

  -- 필수 칼럼
  DECLARE @v_company        nvarchar(30)   
  DECLARE @v_division        nvarchar(30)
  DECLARE @v_corporation    nvarchar(30)
  DECLARE @v_plant           nvarchar(30)
  DECLARE @v_master_id      nvarchar(30)
  DECLARE @v_plan_id        nvarchar(30)
  DECLARE @v_plan_type      nvarchar(30)
  DECLARE @v_top_plan_id    nvarchar(30)
  DECLARE @v_instance_id    nvarchar(30)  
  DECLARE @n_count          integer = 0
  DECLARE @v_plan_date      nvarchar(10)

  DECLARE @v_prod_plan_id   nvarchar(30)
  DECLARE @v_ship_plan_id   nvarchar(30)
  
  -- LOG 용 변수 설정
  DECLARE @v_proc_name      nvarchar(100) = 'PR_SCM_IF_PLAN'
  DECLARE @v_table_name     nvarchar(100)
  DECLARE @v_message        nvarchar(250)
  DECLARE @v_descr          nvarchar(250)
  DECLARE @n_row_count      Integer  = 0
  DECLARE @n_log_count      Integer  = 0
  DECLARE @v_log_code        nvarchar(10)
  
  DECLARE @sysdate          DATETIME2 = GETDATE()

  DECLARE @v_temp1        nvarchar(1000)
  DECLARE @v_temp2        nvarchar(1000)
  
  SET @v_master_id  = @p_master_id
  SET @v_plan_id    = @p_plan_id

  SET @n_log_count = @n_log_count + 1
  EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'START', @n_log_count, null, '############### Start of procedure ###############', null

  BEGIN TRY

    -- PLAN 시작시 MASTER VALIDATION 이 실행되었는지 확인 후 실행하는 부분
    /*
    IF CHARINDEX('CELL', @v_master_id) > 0
    BEGIN
    
      SELECT @n_row_count = COUNT(1)
      FROM   SY_FP_MASTER_VALIDATION_H
      WHERE  PLAN_DATE = CONVERT(nvarchar(10),GETDATE(),23)
      
      IF @n_row_count = 0
        EXECUTE SY_PR_SCM_AF_MASTER_VALIDATION
    
    END
    */
    
    -- 필수 DATA 쿼리.. 반듯이 있어야 함.
    BEGIN

      SET @v_table_name = 'SCM_FP_PLAN_H'

      SELECT @v_plan_type = PLAN_TYPE
      FROM   SY_SCM_FP_PLAN_H
      WHERE  INSTANCE_ID = @v_master_id
      AND    PLAN_ID = @v_plan_id

    UPDATE SY_FP_PLAN_STATUS_H
      SET 
         INBOUND_STEP = '1',
         UPDATE_ID = @v_proc_name, 
     UPDATE_TIME = sysdatetime()
    FROM SY_FP_PLAN_STATUS_H  AS a    
    WHERE 
      a.INSTANCE_ID = @v_master_id AND 
      a.PLAN_ID = @v_plan_id

      IF @v_plan_type = 'PRE' 
        BEGIN
          EXECUTE dbo.PR_SCM_IF_PLAN_PRE     @v_master_id,@v_plan_id ;
        END
      
      ELSE IF @v_plan_type = 'SYNC' 
        BEGIN
          EXECUTE dbo.PR_SCM_IF_PLAN_SYNC    @v_master_id,@v_plan_id ;
        END

      ELSE    -- SCM_FP_PLAN_H 에 등록되어 있지 않으면 PRE 다..
        BEGIN
          EXECUTE dbo.PR_SCM_IF_PLAN_PRE     @v_master_id,@v_plan_id ;
        END
        
      SET @v_message = '@v_plan_type : ' + @v_plan_type
      SET @n_log_count = @n_log_count + 1
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, @v_log_code, @v_message, null
        

      IF @@TRANCOUNT > 0
        COMMIT WORK 
    END;
    
  END TRY

  BEGIN CATCH
    --ROLLBACK
    SET @v_log_code = 'E' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))
    SET @v_descr = ERROR_MESSAGE()

    EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'ERROR', null, @v_log_code, null, @v_descr
    commit;
  END CATCH

  EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'END', 999999, null, '############### End of procedure ###############', null

END
