CREATE   PROCEDURE [dbo].[PR_SCM_OF_INSTANCE_CALL_DAILY_AMEND_UI]
@p_master_id nvarchar(MAX) = '-', @p_plan_id nvarchar(MAX) = '-'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_SCM_OF_INSTANCE_CALL_DAILY_AMEND_UI                                    **/
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
/** 2018.03.09    HAJH           최초 작성                                                    **/
/***********************************************************************************************/
/*
  EXEC PR_SCM_OF_INSTANCE_CALL_DAILY_AMEND_UI
  

*/
BEGIN
  SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
  SET XACT_ABORT ON;

  -- 필수 칼럼
  DECLARE @v_master_id      nvarchar(30)
  DECLARE @v_plan_id        nvarchar(30)

  -- LOG 용 변수 설정
  DECLARE @v_proc_name      nvarchar(100) = 'PR_SCM_OF_INSTANCE_CALL_DAILY_AMEND_UI'
  DECLARE @v_table_name     nvarchar(100)
  DECLARE @v_message        nvarchar(250)
  DECLARE @v_descr          nvarchar(250)
  DECLARE @n_row_count      Integer  = 0
  DECLARE @n_log_count      Integer  = 0
  DECLARE @v_log_code        nvarchar(10)
  
  DECLARE @sysdate          DATETIME2 = GETDATE()
  
  DECLARE @v_temp1          nvarchar(1000)
  DECLARE @v_temp2          nvarchar(1000)
  
  
  DECLARE @v_instance_id    nvarchar(30)
        , @v_shop_group_id  nvarchar(30)

  -------------------------------------------------------------------------------------------

  SET @v_master_id      = @p_master_id
  SET @v_plan_id        = @p_plan_id
  SET @v_instance_id    = @p_master_id

  SET @n_log_count = @n_log_count + 1
  EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'START', @n_log_count, null, '############### Start of procedure ###############', null

  BEGIN TRY
    
    
    -- 필수 DATA 쿼리.. 반듯이 있어야 함.
    BEGIN

      BEGIN
      
        SET @v_table_name = 'PR_SCM_OF_DAILY_AMEND_UI'

        --LOG 생성
        SET @v_message   = 'PROCEDURE Start : ' + convert(nvarchar, CHARINDEX('DEV', USER) ) + ' : ' + SUSER_NAME()
        SET @n_log_count = @n_log_count + 1
        SET @sysdate     = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'CALL', @n_log_count, null, @v_message, null
		/*
        IF    CHARINDEX('E_POST',  @v_master_id) > 0
			BEGIN
	        	-- 운영
				IF CHARINDEX('DEV', USER) = 0   
					BEGIN
					
						EXEC(@v_instance_id+'.DBO.PR_SCM_OF_DAILY_AMEND_UI '''+@v_instance_id+''','''+@v_plan_id+''',''-''')
					    
					END
				-- 개발
				ELSE 
					BEGIN
					  
						EXEC LGCE_FPDEV2.DBO.PR_SCM_OF_DAILY_AMEND_UI @v_instance_id, @v_plan_id, '-'
						
					END
			END
        ELSE
        	BEGIN
	        	-- 운영
				IF CHARINDEX('DEV', USER) = 0   
					BEGIN
					
						-- 개발서버에서 USER 정보가 dbo 로만 표시되어 정상적으로 안됨 SYNONYM 으로 변경함 임시
						--EXEC(@v_instance_id+'.DBO.PR_SCM_OF_DAILY_AMEND_UI '''+@v_instance_id+''','''+@v_plan_id+''',''-''')
						EXEC(@v_instance_id+'_SY_PR_SCM_OF_DAILY_AMEND_UI '''+@v_instance_id+''','''+@v_plan_id+''',''-''')
					    
					    EXEC PR_SCM_AMEND_PLAN_PRIORITY @v_instance_id , @v_plan_id
					    
					END
				-- 개발
				ELSE 
					BEGIN
					  
						EXEC LGCE_FPDEV.DBO.PR_SCM_OF_DAILY_AMEND_UI @v_instance_id, @v_plan_id, '-'
						EXEC PR_SCM_AMEND_PLAN_PRIORITY @v_instance_id , @v_plan_id
					    
					END
			END
       */
        
       IF    CHARINDEX('E_POST',  @v_master_id) > 0
			BEGIN
	        	-- 운영
				--IF CHARINDEX('DEV', USER) = 0  
				IF ( CHARINDEX('QA', SUSER_NAME() ) = 0 AND CHARINDEX('DEV', SUSER_NAME() ) = 0 )
					BEGIN
					
						EXEC(@v_instance_id+'.DBO.PR_SCM_OF_DAILY_AMEND_UI '''+@v_instance_id+''','''+@v_plan_id+''',''-''')
					    
					END
				-- 개발
				ELSE 
					BEGIN
						IF CHARINDEX('QA', SUSER_NAME() ) > 0
							BEGIN
								EXEC KR_E_PRE_DEV.DBO.PR_SCM_OF_DAILY_AMEND_UI @v_instance_id, @v_plan_id, '-'
							END 
						ELSE 
							BEGIN
								EXEC LGCE_FPDEV2.DBO.PR_SCM_OF_DAILY_AMEND_UI @v_instance_id, @v_plan_id, '-'
							END
					END
			END
			
        ELSE
        
        	BEGIN
	        	-- 운영
				--IF CHARINDEX('DEV', USER) = 0  
				IF ( CHARINDEX('QA', SUSER_NAME() ) = 0 AND CHARINDEX('DEV', SUSER_NAME() ) = 0 )
					BEGIN
					
						EXEC(@v_instance_id+'.DBO.PR_SCM_OF_DAILY_AMEND_UI '''+@v_instance_id+''','''+@v_plan_id+''',''-''')
					    
					    EXEC PR_SCM_AMEND_PLAN_PRIORITY @v_instance_id , @v_plan_id
					    
					END
				-- 개발
				ELSE 
					BEGIN
						IF CHARINDEX('QA', SUSER_NAME() ) > 0
							BEGIN
							  	EXEC KR_E_PRE_DEV.DBO.PR_SCM_OF_DAILY_AMEND_UI @v_instance_id, @v_plan_id, '-'
							END	
						ELSE 
							BEGIN
								EXEC LGCE_FPDEV.DBO.PR_SCM_OF_DAILY_AMEND_UI @v_instance_id, @v_plan_id, '-'
							END
							
							EXEC PR_SCM_AMEND_PLAN_PRIORITY @v_instance_id , @v_plan_id
					END
			END
		 
        SET @v_message   = 'PROCEDURE End'
        SET @n_log_count = @n_log_count + 1
        SET @sysdate     = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'CALL', @n_log_count, null, @v_message, null
              
      END

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
