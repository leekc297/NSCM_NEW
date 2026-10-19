
CREATE PROCEDURE [dbo].[PR_SCM_DNM_STOCK_V]
    (           
      @p_plan_start_yyyymmdd           NVARCHAR(150) = NULL
    )  
AS    

/*      
 * Program ID   : PR_SCM_DNM_STOCK_V
 * Description  : PR_SCM_DNM_STOCK_V (SCM_DNM_STOCK_V -> SCM_DNM_STOCK 데이터 복사)
 * OutTable     :      
 * Execute      : 

 
    SELECT * FROM SCM_SYS_LOG_BATCH with (nolock)  where [PROGRAM_NAME] ='PR_SCM_DNM_STOCK_V' order by CREATION_DATE desc

 * Program History      
 *===================================================================================================      
 *   Date       In Charge      Description      
 *===================================================================================================      
 * 2022.01.04   sclee.lee      Initial Release PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 : Stock_v -> Stock 테이블로 생성
 * 2023.03.27   KSG            E20230327-000187 [SCM물류PI팀] 재고 테이블 SCM_DNM_STOCK 개선 (GSCM 시스템의 재고 정합성 개선을 위한) : 재고 이전/특별 재고 관련 컬럼 추가
 */        
  BEGIN      
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;      
    SET NOCOUNT ON;      
    SET XACT_ABORT ON;      
    SET ANSI_WARNINGS OFF;      
      
    -- LOG 용 변수 설정
    DECLARE @v_batch_user   NVARCHAR(150) = N'SCP_batch';        
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SCM_DNM_STOCK_V';      
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...      
    DECLARE @n_log_count    INTEGER = 0;      
    DECLARE @v_log_message  NVARCHAR(1000);      
    DECLARE @v_description  NVARCHAR(500);    
    DECLARE @v_table_id     NVARCHAR(150) = N'SCM_DNM_STOCK';   
    DECLARE @d_event_date   DATETIME;      

    -- 로직 실행관련 변수 설정
    DECLARE @v_start_yyyymmdd      VARCHAR(8)     = IIF(ISNULL(@p_plan_start_yyyymmdd, '') = '', FORMAT(GETDATE() - 1, 'yyyyMMdd'), @p_plan_start_yyyymmdd);  -- 데이터 복사 대상일
    DECLARE @v_end_yyyymmdd        VARCHAR(8)     = FORMAT(DATEADD(dd, 1, CAST(@v_start_yyyymmdd AS DATETIME)), 'yyyyMMdd');

    -- 시작 LOG      
    SET @v_log_type     = N'START';      
    SET @v_log_message  = N'########## Start of procedure ##########';      
    SET @v_description  = @v_program_name + ':' + N'INSERT LOGIC';      
    SET @d_event_date   = SYSDATETIME();      
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
                              ,@p_log_type      = @v_log_type
                              ,@p_log_count     = @n_log_count       
                              ,@p_log_message   = @v_log_message       
                              ,@p_description   = @v_description       
                              ,@p_event_date    = @d_event_date       
                              ,@p_user_id       = @v_batch_user      
                              ;  
   
        -- 실행시간 확인용    
    DECLARE @v_start_time   DATETIME     = SYSDATETIME();    
    DECLARE @v_exec_time    NVARCHAR(10) = ''--'00:00';

    --DECLARE @debug_mode            NVARCHAR(30) = 'T'
        BEGIN TRY        
          BEGIN        

             BEGIN TRAN

             DELETE dbo.SCM_DNM_STOCK WHERE cutoff_date BETWEEN @v_start_yyyymmdd AND @v_end_yyyymmdd;
             
             INSERT INTO dbo.SCM_DNM_STOCK WITH (TABLOCK)
             (
               SCM_SITE_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, STORAGE_ID
             , CUTOFF_DATE
             , SEQ, STOCK_TYPE, ITEM_ID, ORIGIN_ITEM_ID, SCM_QTY, SSP_QTY, LANE, PRODUCTION_TYPE, AVAILABLE_DATE, REMAIN_LEAD_TIME, HOLDING_DATE
             , QTY, QTY_UOM, STOCK_STATUS, OPERATION_ID, LINE_ID, OUTSOURCING_FLAG, OUTSOURCING_FACTORY, DESCRIPTION, FP_APPLY_OPERATION_ID
             , FP_APPLY_ITEM_ID, FP_APPLY_WIPQTY, WIPHOLD_YN, QMS_HOLD_YN, WIP_TYPE_CODE, QTY2, MODIFY_FP_APPLY_WIPQTY, MODIFY_DESCRIPTION
             , CAL_QTY, FORMATION_REWORK_TYPE, INSERT_ID, INSERT_TIME, UPDATE_ID, UPDATE_TIME, LOCATION, MOVING_QTY, CAPA_GRD_CODE, VLTG_GRD_CODE, RSST_GRD_CODE
             , DEFECT_QTY, UNHOLD_EXP_DATE, MES_MAP_SLOC, MES_HOLD_YN, MES_UNHOLD_DATE, QMS_HOLD_DATE, QMS_UNHOLD_EXP_DATE, QMS_UNHOLD_DATE, OPERATION_ID_ORG, location_code
              -- 20230327 E20230327-000187 : 재고 이전/특별 재고 관련 컬럼 추가
		     , mes_item_id, mes_operation_id, from_sloc_id, customer_id, special_stock_indicator
             , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
             )
             SELECT 
                     SCM_SITE_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, STORAGE_ID
                   , FORMAT(CUTOFF_DATE, 'yyyyMMdd') AS CUTOFF_DATE
                   , SEQ, STOCK_TYPE, ITEM_ID, ORIGIN_ITEM_ID, SCM_QTY, SSP_QTY, LANE, PRODUCTION_TYPE, AVAILABLE_DATE, REMAIN_LEAD_TIME, HOLDING_DATE
                   , QTY, QTY_UOM, STOCK_STATUS, OPERATION_ID, LINE_ID, OUTSOURCING_FLAG, OUTSOURCING_FACTORY, DESCRIPTION, FP_APPLY_OPERATION_ID
                   , FP_APPLY_ITEM_ID, FP_APPLY_WIPQTY, WIPHOLD_YN, QMS_HOLD_YN, WIP_TYPE_CODE, QTY2, MODIFY_FP_APPLY_WIPQTY, MODIFY_DESCRIPTION
                   , CAL_QTY, FORMATION_REWORK_TYPE, INSERT_ID, INSERT_TIME, UPDATE_ID, UPDATE_TIME, LOCATION, MOVING_QTY, CAPA_GRD_CODE, VLTG_GRD_CODE, RSST_GRD_CODE
                   , DEFECT_QTY, UNHOLD_EXP_DATE, MES_MAP_SLOC, MES_HOLD_YN, MES_UNHOLD_DATE, QMS_HOLD_DATE, QMS_UNHOLD_EXP_DATE, QMS_UNHOLD_DATE, OPERATION_ID_ORG, location_code
                    -- 20230327 E20230327-000187 : 재고 이전/특별 재고 관련 컬럼 추가
		           , mes_item_id, mes_operation_id, from_sloc_id, customer_id, special_stock_indicator
                   , 'SCP_batch' CREATED_BY, GETDATE() CREATION_DATE, 'SCP_batch' LAST_UPDATED_BY, GETDATE() LAST_UPDATE_DATE

             FROM   dbo.SCM_DNM_STOCK_V WITH (NOLOCK)
             WHERE  cutoff_date BETWEEN @v_start_yyyymmdd AND @v_end_yyyymmdd
             ;
             
             COMMIT

        --IF @@TRANCOUNT > 0      
        --  BEGIN      
        --    COMMIT TRAN T1;      
        --  END;             
      
      
        -- TXN LOG      
        SET @v_log_type     = N'TXN';        
        SET @n_log_count    = @@ROWCOUNT;      
        SET @v_log_message  = N'INSERT INTO ' + @v_table_id;      
        SET @v_description  = N'Process Complete...' + ':' + CONVERT(CHAR(8), @d_event_date, 112);      
        SET @d_event_date   = SYSDATETIME();      
      
        EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
                                  ,@p_log_type      = @v_log_type      
                                  ,@p_log_count     = @n_log_count       
                                  ,@p_log_message   = @v_log_message       
                                  ,@p_description   = @v_description       
                                  ,@p_event_date    = @d_event_date       
                                  ,@p_user_id       = @v_batch_user      
                                  ;            
      
    END      
    END TRY      
      
    BEGIN CATCH      
      --IF @@TRANCOUNT > 0      
      --  BEGIN      
      --    ROLLBACK TRAN T1      
      --  END;      
            
      -- ERROR LOG      
      SET @v_log_type     = N'ERROR';      
      SET @v_log_message  = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));      
      SET @v_description  = @v_program_name + N'ERROR_LINE : ' + STR(ERROR_LINE());      
      SET @d_event_date   = SYSDATETIME();      
      EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
                                ,@p_log_type      = @v_log_type      
                                ,@p_log_count     = @n_log_count       
                                ,@p_log_message   = @v_log_message       
                                ,@p_description   = @v_description       
                                ,@p_event_date    = @d_event_date       
                                ,@p_user_id       = @v_batch_user      
                                ;      
--      PRINT @@ERROR      
      return -1      
    END CATCH;      
      
  
  
     SET @v_exec_time  =  REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +     
                          REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))     
       
    -- 종료 LOG          
    SET @v_log_type     = N'END';          
    SET @v_log_message  = N'########## END of procedure ##########';          
    SET @v_description  = N'[' + @v_program_name + '][' + @v_exec_time + '], start_yyyymmdd (' + @v_start_yyyymmdd + ')';
    SET @d_event_date   = SYSDATETIME()  ;     
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
                              ,@p_log_type      = @v_log_type      
                              ,@p_log_count     = @n_log_count       
                              ,@p_log_message   = @v_log_message       
                              ,@p_description   = @v_description       
                              ,@p_event_date    = @d_event_date       
                              ,@p_user_id       = @v_batch_user      
                              ;      
    return 1   
	
    _RETURN_ERR_CODE:                  
        BEGIN                  
             RETURN -1                  
        END; 
		
  END;       
  
  


