CREATE PROCEDURE [dbo].[PR_SCM_RF_RESCHEDULE]
@p_master_id nvarchar(MAX) = '-', @p_plan_id nvarchar(MAX) = '-', @p_factory_id nvarchar(MAX) = '-'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_SCM_RF_RESCHEDULE                                                      **/
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
/** 2017.06.08    HAJH           KR-CELL  A6000 공정 특화로직 반영 전 원본 소스               **/
/***********************************************************************************************/
/*
  EXEC PR_SCM_RF_RESCHEDULE
  

*/
BEGIN
  SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
  SET XACT_ABORT ON;

  -- 필수 칼럼
  DECLARE @v_master_id      nvarchar(30)
  DECLARE @v_plan_id        nvarchar(30)

  -- LOG 용 변수 설정
  DECLARE @v_proc_name      nvarchar(100) = 'PR_SCM_RF_RESCHEDULE'
  DECLARE @v_table_name     nvarchar(100)
  DECLARE @v_message        nvarchar(250)
  DECLARE @v_descr          nvarchar(250)
  DECLARE @n_row_count      Integer  = 0
  DECLARE @n_log_count      Integer  = 0
  DECLARE @v_log_code        nvarchar(10)
  
  DECLARE @sysdate          DATETIME2 = GETDATE()
  
  DECLARE @v_temp1        nvarchar(1000)
  DECLARE @v_temp2        nvarchar(1000)
  
  
  DECLARE @v_factory_id      nvarchar(30)

  -------------------------------------------------------------------------------------------
  -- amend 유형 정보
  -------------------------------------------------------------------------------------------
   DECLARE @amend_type    nvarchar(30)
  -------------------------------------------------------------------------------------------

  SET @v_master_id      = @p_master_id
  SET @v_plan_id        = @p_plan_id
  SET @v_factory_id     = @p_factory_id

  SET @n_log_count = @n_log_count + 1
  EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'START', @n_log_count, null, '############### Start of procedure ###############', null

  BEGIN TRY
    
    
    -- 필수 DATA 쿼리.. 반듯이 있어야 함.
    BEGIN

      SET @amend_type = 'AMEND UI'

      SELECT @amend_type = ISNULL(MAX(B.ATTRIBUTE1), 'AMEND UI')
      FROM   SCM_SYS_LOOKUP_TYPE_M  A
           , SCM_SYS_LOOKUP_VALUE   B
      WHERE  A.LOOKUP_TYPE_CODE = 'INSTANCE AMEND UI'
      AND    A.LOOKUP_TYPE_CODE = B.LOOKUP_TYPE_CODE
      AND    B.SEGMENT1         = @v_master_id

      --LOG 생성
      SET @v_message = 'AMEND_TYPE : ' + @amend_type
      SET @n_log_count = @n_log_count + 1
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, @v_log_code, @v_message, null

      WAITFOR DELAY '0:0:1'

      IF @amend_type = 'PSI AMEND UI'
        BEGIN

          -- 2018.05.15 : 사용자가 시뮬레이션 버튼을 안해서, 여기서 진행하도록 함
          IF CHARINDEX('FORM', @v_master_id) > 0 AND @v_master_id <> 'CN_FORM_T'
            EXEC dbo.PR_SCM_OF_PSI_AMEND_UI_CALCULATION_FORM    @v_master_id, @v_plan_id , 'Y'
          
          ELSE
            EXEC dbo.PR_SCM_OF_PSI_AMEND_UI_CALCULATION         @v_master_id, @v_plan_id, 'Y'
        
          EXEC dbo.PR_SCM_RF_RESCHEDULE_PSI_AMEND               @v_master_id, @v_plan_id, @v_factory_id
          
          UPDATE SCM_FP_PLAN_DETAIL_H
          SET    CONFIRM_FLAG = 'Y'
          WHERE  INSTANCE_ID    = @v_master_id
          AND    PLAN_ID        = @v_plan_id
          AND    FACTORY_ID     = @v_factory_id

        END
      ELSE 
        BEGIN
        
          EXEC dbo.PR_SCM_RF_RESCHEDULE_FP_AMEND          @v_master_id, @v_plan_id, @v_factory_id
          
          UPDATE SCM_FP_PLAN_DETAIL_H
          SET    CONFIRM_FLAG = 'Y'
          WHERE  INSTANCE_ID    = @v_master_id
          AND    PLAN_ID        = @v_plan_id
          AND    FACTORY_ID     = @v_factory_id

        END
        
      WAITFOR DELAY '0:0:1'

    END;

    IF @@TRANCOUNT > 0
      COMMIT WORK 
    
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
