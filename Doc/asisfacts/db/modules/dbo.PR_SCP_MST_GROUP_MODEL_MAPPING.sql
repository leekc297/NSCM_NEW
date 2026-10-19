
/*******************************************************************************************************************                      
 * Program ID   : PR_SCP_MST_GROUP_MODEL_MAPPING                        
 * Description  : [재료비 TASK] 통합 integration 기초 정보 생성
 * OutTable     :                      
 * Execute      : EXEC PR_SCP_MST_GROUP_MODEL_MAPPING   @p_division_id = '81'                  
 * Program History                      
 *===================================================================================================                      
 *   Date       In Charge      Description                      
 *===================================================================================================                      
 * 2024.05.28                  Initial PJ20244573 LGES SCM SCP 생산모델 기반 공급계획 수립체계 구성 : 통합 integration 기초 정보 생성
 *
 *******************************************************************************************************************/                    
-- exec PR_SCP_MST_GROUP_MODEL_MAPPING '81'

CREATE PROCEDURE [dbo].[PR_SCP_MST_GROUP_MODEL_MAPPING]
(                         
      @p_division_id          NVARCHAR(30) = NULL
)                         
AS                        
  BEGIN 
  
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;                        
    SET NOCOUNT ON;                        
    SET XACT_ABORT ON;                        
    SET ANSI_WARNINGS OFF;                        
                        
    -- LOG 용 변수 설정                        
    DECLARE @v_batch_user   NVARCHAR(150) = N'scp_batch';       
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SCP_MST_GROUP_MODEL_MAPPING';                        
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...                        
    DECLARE @n_log_count    INTEGER = 0;                        
    DECLARE @v_log_message  NVARCHAR(1000);                        
    DECLARE @v_description  NVARCHAR(500);            
    DECLARE @v_table_id     NVARCHAR(150) = N'SCP_MST_ITEM_GROUP_DETAIL';                         
    DECLARE @d_event_date   DATETIME;                        

  -- 시작 LOG                        
    SET @v_log_type     = N'START';                        
    SET @v_log_message  = N'########## Start of procedure ##########';                        
    SET @v_description  = @v_program_name + ':' + @v_table_id + N' INSERT LOGIC';                        
    SET @d_event_date   = SYSDATETIME();                        
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name                        
                              ,@p_log_type      =@v_log_type                        
                              ,@p_log_count     =@n_log_count                         
                              ,@p_log_message   =@v_log_message                         
                              ,@p_description   =@v_description                         
                              ,@p_event_date    =@d_event_date                         
                              ,@p_user_id       =@v_batch_user                        
                              ;                        
    -- 임시 실행시간 확인용                
    DECLARE @v_start_time   DATETIME     = SYSDATETIME();                
    DECLARE @v_exec_time    NVARCHAR(10) = ''--'00:00';    

   BEGIN TRY                        
     BEGIN  

		INSERT INTO SCP_MST_ITEM_GROUP_DETAIL
		( division_id, project_code, item_id, valid_yn
		, creation_date, created_by, last_update_date, last_updated_by
		)

		SELECT DISTINCT a.division_id, a.project_code, a.item_id, 'Y'
             , GETDATE(), @v_batch_user, GETDATE(), @v_batch_user
		FROM   SCM_MST_SITE_ITEM a WITH(NOLOCK)

		LEFT JOIN scp_mst_final_item b WITH(NOLOCK)
			 ON  a.division_id = b.division_id
			 AND a.item_id     = b.item_id
		
		WHERE  a.division_id               = ISNULL(@p_division_id, a.division_id) 
		AND    ISNULL(a.item_id,'')       <> ''
		AND    ISNULL(a.project_code,'-') <> '-'
		AND    NOT EXISTS ( SELECT 'Y' FROM SCP_MST_ITEM_GROUP_DETAIL g WITH(NOLOCK)
                            WHERE  g.DIVISION_ID  = a.DIVISION_ID 
                            AND    g.PROJECT_CODE = a.PROJECT_CODE 
                            AND    g.ITEM_ID      = a.ITEM_ID
                          )
		AND    a.valid_yn = 'Y'
		;

        -- TXN LOG               
        SET @n_log_count    = @@ROWCOUNT;              
        SET @v_log_type     = N'TXN';                             
        SET @v_log_message  = N'INSERT INTO '+@v_table_id;                            
        SET @d_event_date   = SYSDATETIME();                                     
        SET @v_description  = N'Process Complete...' + ':' + CONVERT(CHAR(8), @d_event_date, 112);       
                        
        EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name                        
                                  ,@p_log_type      =@v_log_type                        
                                  ,@p_log_count     =@n_log_count                         
                                  ,@p_log_message   =@v_log_message                         
                                  ,@p_description   =@v_description                         
                                  ,@p_event_date    =@d_event_date                         
                                  ,@p_user_id       =@v_batch_user     

     END 

   END TRY

   BEGIN CATCH
        
     -- IF @@TRANCOUNT > 0 
     --   BEGIN
     --     ROLLBACK;
     --   END;
      
      -- ERROR LOG
      SET @v_log_type = N'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = N'ERROR_LINE : ' + STR(ERROR_LINE());
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                                ,@p_log_type      =@v_log_type
                                ,@p_log_count     =@n_log_count 
                                ,@p_log_message   =@v_log_message 
                                ,@p_description   =@v_description 
                                ,@p_event_date    =@d_event_date 
                                ,@p_user_id       =@v_batch_user
                                ;

      return -1 
   END CATCH;

    -- 임시 운영반영시에 주석처리 할것.                
     SET @v_exec_time  =  REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +                 
                          REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))                 
                
                    
    -- 종료 LOG                        
    SET @v_log_type     = N'END';                        
    SET @v_log_message  = N'########## END of procedure ##########';
    SET @v_description  = N'['+ISNULL(@p_division_id, 'ALL') +'][' + @v_exec_time + ']';                  
    SET @d_event_date   =  SYSDATETIME()  ;                        

    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name                  
                              ,@p_log_type      =@v_log_type                        
                              ,@p_log_count     =@n_log_count                         
                              ,@p_log_message   =@v_log_message                         
                              ,@p_description   =@v_description                         
                              ,@p_event_date    =@d_event_date                         
                              ,@p_user_id       =@v_batch_user                        
                              ;                        
    return 1  

end  



