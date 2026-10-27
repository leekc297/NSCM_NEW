
CREATE PROCEDURE [dbo].[PR_SCM_OF_PSI_AMEND_UI_CALCULATION_PARALLEL_A]
@p_instance_id nvarchar(MAX) = '-', @p_plan_id nvarchar(MAX) = '-', @p_confirm_flag nvarchar(MAX) = '-'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_SCM_OF_PSI_AMEND_UI_CALCULATION_PARALLEL_A                             **/
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
  DECLARE @v_proc_name        nvarchar(100) = 'PR_SCM_OF_PSI_AMEND_UI_CALCULATION_PARALLEL_A'
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
  
  EXEC PR_LOG_RUNLOG  @logdate, @v_master_id, @v_plan_id, @v_proc_name, 'START', null

  SET @n_log_count = @n_log_count + 1
  SET @sysdate = GETDATE()
  EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'START', @n_log_count, null, '############### Start of procedure ###############', null

  BEGIN TRY
    
    BEGIN
    
      BEGIN
        
        SET @v_table_name = 'SCM_SYS_LOOKUP_VALUE PSI_CAL_STATUS'
        
         --SELECT ATTRIBUTE5
         UPDATE SCM_SYS_LOOKUP_VALUE
         SET    ATTRIBUTE5 = 'Y'
         WHERE  1=1
         AND  LOOKUP_TYPE_CODE = 'INSTANCE_ID'
         AND  SEGMENT1 = @V_INSTANCE_ID
         
                 --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
        
      END  
      
      BEGIN
      
        SET @v_table_name =USER --'PR_SCM_OF_PSI_AMEND_UI_CAL'

        --LOG 생성
        SET @v_message   = 'PROCEDURE Start'
        SET @n_log_count = @n_log_count + 1
        SET @sysdate     = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'CALL', @n_log_count, null, @v_message, null

        IF CHARINDEX('DEV', USER) = 0   -- 운영
          BEGIN

            EXEC(@v_instance_id+'_SY_PR_SCM_OF_PSI_AMEND_UI_CAL  '''+@v_instance_id+''','''+@v_plan_id+'''')

          END
        ELSE                            -- 개발
          BEGIN

            IF CHARINDEX('E_PRE', @v_master_id) > 0 OR CHARINDEX('E_PMIX', @v_master_id) > 0
              BEGIN
              
                SET @v_master_id = @v_master_id
                
              END
            /*ELSE IF @v_master_id IN ('KR_PACK','CN_PACK','US_PACK')
              BEGIN
              
                EXEC LGCE_FPDEV2.DBO.PR_SCM_OF_PSI_AMEND_UI_CAL     @v_instance_id, @v_plan_id

              END
            ELSE IF @v_master_id IN ('PL_PACK')
              BEGIN
              
                EXEC CN_CELL_M_DEV.DBO.PR_SCM_OF_PSI_AMEND_UI_CAL   @v_instance_id, @v_plan_id

              END*/
            ELSE IF @v_master_id IN ('CN_CELL_M2', 'CN_CELL_M5')
              BEGIN
              
                --EXEC CN_CELL_M2_DEV.DBO.PR_SCM_OF_PSI_AMEND_UI_CAL  @v_instance_id, @v_plan_id
					EXEC KR_CELL_DEV.DBO.PR_SCM_OF_PSI_AMEND_UI_CAL     @v_instance_id, @v_plan_id
              END
            ELSE
              BEGIN
              
                EXEC KR_CELL_DEV.DBO.PR_SCM_OF_PSI_AMEND_UI_CAL     @v_instance_id, @v_plan_id
          
              END

          END

        
        SET @v_message   = 'PROCEDURE End'
        SET @n_log_count = @n_log_count + 1
        SET @sysdate     = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'CALL', @n_log_count, null, @v_message, null
              
      END

      --20180605 SONG CELL / PACK PRIORITY CALCULATION 추가 
      EXECUTE PR_SCM_AMEND_PLAN_PRIORITY @v_master_id , @v_plan_id
            
      BEGIN
        
        SET @v_table_name = 'SCM_SYS_LOOKUP_VALUE PSI_CAL_STATUS'
        
         --SELECT ATTRIBUTE5
         UPDATE SCM_SYS_LOOKUP_VALUE
         SET    ATTRIBUTE5 = 'N'
         WHERE  1=1
         AND  LOOKUP_TYPE_CODE = 'INSTANCE_ID'
         AND  SEGMENT1 = @V_INSTANCE_ID
         
        --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
        
      END 

	     --==== 셀가시성 UI 데이터 생성용 (20190920) ====--
		 -- Amend에서 저장할때도 실행되어야 한다.
	  IF  @v_instance_id = 'PL_PACK' 
	    BEGIN 
	  
		EXEC PR_SCM_OF_PACK_TO_CELL  @v_instance_id , @v_plan_id 

        SET @n_log_count = @n_log_count + 1
        SET @v_descr     = @v_instance_id + ' PR_SCM_OF_PACK_TO_CELL End'
        EXEC PR_LOG_PROCESS @sysdate, @v_instance_id, @v_plan_id, @v_proc_name, null, 'CALL', @n_log_count, NULL, @v_descr, null
		  
	    END 


    END
    
  END TRY

  BEGIN CATCH
    --ROLLBACK

    SET @v_descr = ERROR_MESSAGE()
    SET @sysdate = GETDATE()

      BEGIN
        
        SET @v_table_name = 'SCM_SYS_LOOKUP_VALUE PSI_CAL_STATUS'
        
         --SELECT ATTRIBUTE5
         UPDATE SCM_SYS_LOOKUP_VALUE
         SET    ATTRIBUTE5 = 'N'
         WHERE  1=1
         AND  LOOKUP_TYPE_CODE = 'INSTANCE_ID'
         AND  SEGMENT1 = @V_INSTANCE_ID
         
                 --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
   
     END 
    
    EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'ERROR', null, @v_temp2, null, @v_descr
    
    EXEC PR_LOG_RUNLOG  @logdate, @v_master_id, @v_plan_id, @v_proc_name, 'ERROR', null

    commit;
  END CATCH

  SET @n_log_count = @n_log_count + 1
  EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'END', 999999, null, '############### End of procedure ###############', null

  EXEC PR_LOG_RUNLOG  @logdate, @v_master_id, @v_plan_id, @v_proc_name, 'END', null

END
