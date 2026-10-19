


/*        
 * Program ID   : PR_SCP_PLN_TH_ENG_STOCK_PLAN          
 * Description  : PR_SCP_PLN_CREATE_DATA 에서 호출함.        
 * OutTable     :        
 * Execute      :   
  EXEC PR_SCP_PLN_TH_ENG_STOCK_PLAN       @p_plan_cycle          ='WEEKLY'  
                                , @p_plan_start_yyyymmdd ='20180702'     
                                , @p_plan_id             ='1033'     
                                , @p_modeling_id         ='2'            
                                , @p_seq                 ='6'  
                                , @p_plan_type           ='PR'      
                                , @p_master_id           ='81::WEEKLY'   
                                , @p_division_id         ='81'       
                                , @p_engine_plan_id      ='1033::PR::6'    
                                , @p_user_id             = 'KWON'  

 * Program History        
 *===================================================================================================        
 *   Date       In Charge      Description        
 *===================================================================================================        
 * 2018.12.12   YYDOK         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 
 * 2019.04.23   KTH           자동차 조립완료재고를 활성화진행중 수량으로 변경처리
 * 2021.09.07   KSW           PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 - 전진검사
 */        
         
CREATE PROCEDURE [dbo].[PR_SCP_PLN_TH_ENG_STOCK_PLAN]        
(         
      @p_plan_cycle           NVARCHAR(150)          
    , @p_plan_start_yyyymmdd  NVARCHAR(8)          
    , @p_plan_id              NVARCHAR(4000)          
    , @p_modeling_id          NVARCHAR(4000)          
    , @p_seq                  NVARCHAR(4000)          
    , @p_plan_type            NVARCHAR(4000)          
    , @p_master_id            NVARCHAR(4000)          
    , @p_division_id          NVARCHAR(30)          
    , @p_engine_plan_id       NVARCHAR(4000)          
    , @p_user_id              NVARCHAR(150)  = 'scp_batch'          
    ---- , @p_debug       INT OUTPUT        
)         
AS        
  BEGIN        
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;        
    SET NOCOUNT ON;        
    SET XACT_ABORT ON;        
    SET ANSI_WARNINGS OFF;        
        
    -- LOG 용 변수 설정        
    DECLARE @v_batch_user   NVARCHAR(150) = N'scp_batch';          
    SET @v_batch_user = @p_user_id        
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SCP_PLN_TH_ENG_STOCK_PLAN';        
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...        
    DECLARE @n_log_count    INTEGER = 0;        
    DECLARE @v_log_message  NVARCHAR(1000);        
    DECLARE @v_description  NVARCHAR(500);         
    DECLARE @v_table_id     NVARCHAR(150) = N'SCM_SYS_LOG_BATC';     
    DECLARE @d_event_date   DATETIME;        
        
  -- 시작 LOG        
    SET @v_log_type = N'START';        
    SET @v_log_message = N'########## Start of procedure ##########';        
    SET @v_description = @v_program_name + ':' + N' INSERT LOGIC';        
    SET @d_event_date = SYSDATETIME();        
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
    DECLARE @v_exec_time    NVARCHAR(10) = ''--'[00:00]';         
      
    BEGIN TRY        
      BEGIN        

           DELETE FROM SCP_PLN_TH_ENG_STOCK_PLAN
           WHERE MASTER_ID  = @p_master_id      
             AND PLAN_ID    = @p_engine_plan_id 
             ;
           
           INSERT INTO SCP_PLN_TH_ENG_STOCK_PLAN
                       (
                          MASTER_ID
                         ,PLAN_ID
                         ,STOCK_SEQ
                         ,ITEM_ID
                         ,SITE_ID
                         ,ROUTE_ID
                         ,OPERATION_ID
                         ,RECEIVING_DTTM
                         ,QTY
                         ,LOT_ID
                         ,WORK_ORDER_ID
                         ,DEMAND_ID
                         ,STOCK_STATUS
                         ,ATTRIBUTE_SET_ID
                         ,DESCR
						 ,INSP_TYPE			-- 2021.09.07   KSW PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 - 전진검사
                       )
           SELECT 
                   MASTER_ID
                  ,PLAN_ID
                  ,STOCK_SEQ
                  ,ITEM_ID
                  ,SITE_ID
                  ,ROUTE_ID
                  ,OPERATION_ID
                  ,RECEIVING_DTTM
                  ,QTY
                  ,LOT_ID
                  ,WORK_ORDER_ID
                  ,DEMAND_ID
                  ,STOCK_STATUS
                  ,ATTRIBUTE_SET_ID
                  ,DESCR
				  ,INSP_TYPE			-- 2021.09.07   KSW PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 - 전진검사
            FROM TH_ENG_STOCK_PLAN_SN WITH(NOLOCK)
           WHERE MASTER_ID  = @p_master_id      
             AND PLAN_ID    = @p_engine_plan_id 
             ;
        --------------------------------------------------------------------------------------        
        -- UPDATE -- 2019.04.23   KTH           자동차 조립완료재고를 활성화진행중 수량으로 변경처리       
        --------------------------------------------------------------------------------------        

           UPDATE X
             SET X.SITE_ID        = REPLACE(X.SITE_ID,  '***','001') 
                ,X.ROUTE_ID       = REPLACE(X.ROUTE_ID, '***','001') 
                ,X.OPERATION_ID   = REPLACE(X.OPERATION_ID,'***','001') 
                ,X.RECEIVING_DTTM = DATEADD(DAY, ISNULL(Z.TOTAL_LT_FORMATION,0), X.RECEIVING_DTTM) 
                ,X.LOT_ID         = REPLACE(REPLACE(X.LOT_ID,'WH','FOR'),'***','001') 
                ,X.DESCR          = REPLACE(X.DESCR,'WH','FOR') 
            FROM SCP_PLN_TH_ENG_STOCK_PLAN X WITH(NOLOCK)
            INNER JOIN SCP_MST_FINAL_ITEM_V Y WITH (NOLOCK)
              ON X.ITEM_ID   = Y.ITEM_ID
            LEFT OUTER JOIN SCP_MST_FORMATION_V Z WITH (NOLOCK)
              ON X.ITEM_ID   = Z.ITEM_ID
             AND SUBSTRING(X.SITE_ID,1,(CASE WHEN CHARINDEX('~', X.SITE_ID) = 0  THEN LEN(X.SITE_ID) ELSE CHARINDEX('~', X.SITE_ID)  -1 END))   = Z.PLANT_SITE_ID
           WHERE 0 = 0
             AND Y.ITEM_ID          = Z.ITEM_ID
             AND Y.OPERATION_GROUP  = 'A'
             AND X.MASTER_ID        = @p_master_id
             AND X.PLAN_ID          = @p_engine_plan_id
             AND X.DESCR            = 'WH'
             AND X.SITE_ID          like '%A~***%'


        -----------------------------------------------------------        
        -- 실행 Logic END --        
        -----------------------------------------------------------        

        -- TXN LOG        
        SET @v_log_type = N'TXN';        
        SET @n_log_count = @@ROWCOUNT;        
        SET @v_log_message = N'INSERT INTO '+@v_table_id;        
        SET @v_description = N'Process Complete...' + ':' + CONVERT(CHAR(8), @d_event_date, 112);        
        SET @d_event_date = SYSDATETIME();        
        
        EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name        
                                  ,@p_log_type      =@v_log_type        
                                  ,@p_log_count     =@n_log_count         
                                  ,@p_log_message   =@v_log_message         
                                  ,@p_description   =@v_description         
                                  ,@p_event_date    =@d_event_date         
                                  ,@p_user_id       =@v_batch_user        
                                  ;              
        
    END        
    END TRY        
        
    BEGIN CATCH        
     
              
      -- ERROR LOG        
      SET @v_log_type = N'ERROR';        
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));        
      SET @v_description = @v_program_name + N'ERROR_LINE : ' + STR(ERROR_LINE());        
      SET @d_event_date = SYSDATETIME();        
      EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name        
                                ,@p_log_type      =@v_log_type        
                                ,@p_log_count     =@n_log_count         
                                ,@p_log_message   =@v_log_message         
                                ,@p_description   =@v_description         
                                ,@p_event_date    =@d_event_date         
                                ,@p_user_id       =@v_batch_user        
                                ;        
--      PRINT @@ERROR        
      return -1        
    END CATCH;
    
     -- 임시 운영반영시에 주석처리 할것.            
     SET @v_exec_time  =  REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +             
                          REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))             

        
    -- 종료 LOG        
    SET @v_log_type = N'END';        
    SET @v_log_message = N'########## END of procedure ##########';        
    SET @v_description = N'['+@p_engine_plan_id+'][' + @v_exec_time + ']';              
    SET @d_event_date = SYSDATETIME()  ;        
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name        
                              ,@p_log_type      =@v_log_type        
                              ,@p_log_count     =@n_log_count         
                              ,@p_log_message   =@v_log_message         
                              ,@p_description   =@v_description         
                              ,@p_event_date    =@d_event_date         
                              ,@p_user_id       =@v_batch_user        
                              ;        
    return 1          
        
  END;         
 




