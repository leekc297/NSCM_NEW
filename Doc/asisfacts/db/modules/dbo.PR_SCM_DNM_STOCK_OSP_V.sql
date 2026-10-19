
CREATE PROCEDURE [dbo].[PR_SCM_DNM_STOCK_OSP_V]
    (           
      @p_plan_start_yyyymmdd           NVARCHAR(150) = NULL
    )  
AS    

/*      
 * Program ID   : PR_SCM_DNM_STOCK_OSP_V
 * Description  : PR_SCM_DNM_STOCK_OSP_V (SCM_DNM_STOCK_V STOCK_TYPE = 'UPLOAD' -> SCM_DNM_STOCK 데이터 복사)
 * OutTable     :      
 * Execute      : 

 
    SELECT * FROM SCM_SYS_LOG_BATCH with (nolock)  where [PROGRAM_NAME] ='PR_SCM_DNM_STOCK_OSP_V' order by CREATION_DATE desc

 * Program History      
 *===================================================================================================      
 *   Date       In Charge      Description      
 *===================================================================================================      
 * 2026.04.22   강주용      E20260417-001783 STOCK OSP 재고 SCM_DNM_STOCK 추가 반영건
 *                          원본 PR_SCM_DNM_STOCK_V 이며 STOCK TYPE = UPLOAD 부분만 화요일 새벽까지 입력한 OSP STOCK 재처리 하도록 수정
 *                          대상 및 마감시간 관리 LOOKUP : STOCK_OSP_V_BAT_MGNT
 *                          DB JOB : 화요일 00시~ 05시 사이
 */        
  BEGIN      
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;      
    SET NOCOUNT ON;      
    SET XACT_ABORT ON;      
    SET ANSI_WARNINGS OFF;      
      
    -- LOG 용 변수 설정
    DECLARE @v_batch_user   NVARCHAR(150) = N'SCP_batch';        
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SCM_DNM_STOCK_OSP_V';      
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...      
    DECLARE @n_log_count    INTEGER = 0;      
    DECLARE @v_log_message  NVARCHAR(1000);      
    DECLARE @v_description  NVARCHAR(500);    
    DECLARE @v_table_id     NVARCHAR(150) = N'SCM_DNM_STOCK';   
    DECLARE @d_event_date   DATETIME;      

    if object_id('tempdb..#TMP_STOCK_OSP_V') is not null
		drop table #TMP_STOCK_OSP_V

    -- 로직 실행관련 변수 설정
    DECLARE @v_start_yyyymmdd      VARCHAR(8)     = IIF(ISNULL(@p_plan_start_yyyymmdd, '') = '', FORMAT(GETDATE() - 2, 'yyyyMMdd'), @p_plan_start_yyyymmdd);  -- 데이터 복사 대상일
    
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

    DECLARE @C_DIVISION_ID  NVARCHAR(30);
	DECLARE @C_SCM_SITE_ID  NVARCHAR(50);
    DECLARE @PROC_CNT       NUMERIC(5);
    DECLARE @ROW_CNT        NUMERIC(5);
    DECLARE @WK_DAY         NUMERIC(5);

    --DECLARE @debug_mode            NVARCHAR(30) = 'T'
        BEGIN TRY        
            BEGIN
          
              SELECT @ROW_CNT = COUNT(1)
                   , @WK_DAY = DATEPART(WEEKDAY, @v_start_yyyymmdd)
                  FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK) 
                 WHERE LOOKUP_TYPE = 'STOCK_OSP_V_BAT_MGNT' 
                   AND SEGMENT3   <= CONVERT(VARCHAR(5), GETDATE(), 108) -- PROC_TIME 처리시간 (HH:MI)
                   AND ATTRIBUTE1 != @v_start_yyyymmdd
                   AND VALID_YN    = 'Y'

              IF (@ROW_CNT > 0 AND @WK_DAY = 1) -- 입력한 CUTOFF DATE로 처리할게 있고 입력한 CUTOFF DATE가 일요일 일때
              BEGIN

                 BEGIN TRAN
                 
                 SELECT V.SCM_SITE_ID, V.COMPANY_ID, V.DIVISION_ID, V.SITE_ID, V.PLANT_ID, V.FACTORY_ID, V.STORAGE_ID
                       , FORMAT(V.CUTOFF_DATE, 'yyyyMMdd') AS CUTOFF_DATE
                       , V.SEQ, V.STOCK_TYPE, V.ITEM_ID, V.ORIGIN_ITEM_ID, V.SCM_QTY, V.SSP_QTY, V.LANE, V.PRODUCTION_TYPE, V.AVAILABLE_DATE, V.REMAIN_LEAD_TIME, V.HOLDING_DATE
                       , V.QTY, V.QTY_UOM, V.STOCK_STATUS, V.OPERATION_ID, V.LINE_ID, V.OUTSOURCING_FLAG, V.OUTSOURCING_FACTORY, V.DESCRIPTION, V.FP_APPLY_OPERATION_ID
                       , V.FP_APPLY_ITEM_ID, V.FP_APPLY_WIPQTY, V.WIPHOLD_YN, V.QMS_HOLD_YN, V.WIP_TYPE_CODE, V.QTY2, V.MODIFY_FP_APPLY_WIPQTY, V.MODIFY_DESCRIPTION
                       , V.CAL_QTY, V.FORMATION_REWORK_TYPE, V.INSERT_ID, V.INSERT_TIME, V.UPDATE_ID, V.UPDATE_TIME, V.LOCATION, V.MOVING_QTY, V.CAPA_GRD_CODE, V.VLTG_GRD_CODE, V.RSST_GRD_CODE
                       , V.DEFECT_QTY, V.UNHOLD_EXP_DATE, V.MES_MAP_SLOC, V.MES_HOLD_YN, V.MES_UNHOLD_DATE, V.QMS_HOLD_DATE, V.QMS_UNHOLD_EXP_DATE, V.QMS_UNHOLD_DATE, V.OPERATION_ID_ORG, V.location_code
                        -- 20230327 E20230327-000187 : 재고 이전/특별 재고 관련 컬럼 추가
		               , V.mes_item_id, V.mes_operation_id, V.from_sloc_id, V.customer_id, V.special_stock_indicator
                  INTO #TMP_STOCK_OSP_V
                  FROM dbo.SCM_DNM_STOCK_V V WITH (NOLOCK)
                  JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK) 
                    ON V.DIVISION_ID = L.SEGMENT1
                   AND V.SCM_SITE_ID = L.SEGMENT2
                   AND L.LOOKUP_TYPE = 'STOCK_OSP_V_BAT_MGNT' 
                   AND L.SEGMENT3   <= CONVERT(VARCHAR(5), GETDATE(), 108) -- PROC_TIME 처리시간 (HH:MI)
                   AND L.ATTRIBUTE1 != @v_start_yyyymmdd
                   AND L.VALID_YN    = 'Y'
                 WHERE CUTOFF_DATE = CONVERT(DATETIME, @v_start_yyyymmdd + ' 00:00:00.000')
                   AND V.STOCK_TYPE  = 'UPLOAD'
                   
               DECLARE CUR_STOCK_OSP_V CURSOR FOR
                SELECT SEGMENT1 AS DIVISION_ID
                     , SEGMENT2 AS SCM_SITE_ID
                  FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK) 
                 WHERE LOOKUP_TYPE = 'STOCK_OSP_V_BAT_MGNT' 
                   AND SEGMENT3   <= CONVERT(VARCHAR(5), GETDATE(), 108) -- PROC_TIME 처리시간 (HH:MI)
                   AND ATTRIBUTE1 != @v_start_yyyymmdd
                   AND VALID_YN    = 'Y'
                   ;
              OPEN CUR_STOCK_OSP_V;
	          FETCH NEXT FROM CUR_STOCK_OSP_V INTO @C_DIVISION_ID, @C_SCM_SITE_ID;
		 
	          WHILE (@@FETCH_STATUS = 0)
	          BEGIN

                 DELETE dbo.SCM_DNM_STOCK 
                  WHERE CUTOFF_DATE = @v_start_yyyymmdd
                    AND DIVISION_ID = @C_DIVISION_ID
                    AND SCM_SITE_ID = @C_SCM_SITE_ID
                    AND STOCK_TYPE  = 'UPLOAD';
           
                 INSERT INTO dbo.SCM_DNM_STOCK
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
                 SELECT  SCM_SITE_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, STORAGE_ID, CUTOFF_DATE
                       , SEQ, STOCK_TYPE, ITEM_ID, ORIGIN_ITEM_ID, SCM_QTY, SSP_QTY, LANE, PRODUCTION_TYPE, AVAILABLE_DATE, REMAIN_LEAD_TIME, HOLDING_DATE
                       , QTY, QTY_UOM, STOCK_STATUS, OPERATION_ID, LINE_ID, OUTSOURCING_FLAG, OUTSOURCING_FACTORY, DESCRIPTION, FP_APPLY_OPERATION_ID
                       , FP_APPLY_ITEM_ID, FP_APPLY_WIPQTY, WIPHOLD_YN, QMS_HOLD_YN, WIP_TYPE_CODE, QTY2, MODIFY_FP_APPLY_WIPQTY, MODIFY_DESCRIPTION
                       , CAL_QTY, FORMATION_REWORK_TYPE, INSERT_ID, INSERT_TIME, UPDATE_ID, UPDATE_TIME, LOCATION, MOVING_QTY, CAPA_GRD_CODE, VLTG_GRD_CODE, RSST_GRD_CODE
                       , DEFECT_QTY, UNHOLD_EXP_DATE, MES_MAP_SLOC, MES_HOLD_YN, MES_UNHOLD_DATE, QMS_HOLD_DATE, QMS_UNHOLD_EXP_DATE, QMS_UNHOLD_DATE, OPERATION_ID_ORG, location_code
                        -- 20230327 E20230327-000187 : 재고 이전/특별 재고 관련 컬럼 추가
		               , mes_item_id, mes_operation_id, from_sloc_id, customer_id, special_stock_indicator
                       , 'SCP_batch' CREATED_BY, GETDATE() CREATION_DATE, 'SCP_batch' LAST_UPDATED_BY, GETDATE() LAST_UPDATE_DATE
                  FROM #TMP_STOCK_OSP_V WITH (NOLOCK)
                 WHERE DIVISION_ID = @C_DIVISION_ID
                   AND SCM_SITE_ID = @C_SCM_SITE_ID
                 ;

                 SET @PROC_CNT = @@ROWCOUNT ; 

                 UPDATE SCM_ADM_LOOKUP_MASTER_DETAIL
                    SET ATTRIBUTE1  = @v_start_yyyymmdd
                      , ATTRIBUTE2  = @PROC_CNT
                      , LAST_UPDATED_BY  = 'SCP_batch'
                      , LAST_UPDATE_DATE = GETDATE()
                  WHERE LOOKUP_TYPE = 'STOCK_OSP_V_BAT_MGNT' 
                    AND SEGMENT1    = @C_DIVISION_ID
                    AND SEGMENT2    = @C_SCM_SITE_ID
                 ;

	          FETCH NEXT FROM CUR_STOCK_OSP_V INTO @C_DIVISION_ID, @C_SCM_SITE_ID;
	          END -- OPEN CUR_STOCK_OSP_V;

              CLOSE CUR_STOCK_OSP_V;
	          DEALLOCATE CUR_STOCK_OSP_V;

              COMMIT

            --IF @@TRANCOUNT > 0      
            --  BEGIN      
            --    COMMIT TRAN;      
            --  END;             
      
            END -- IF @ROW_CNT > 0
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
      
    if object_id('tempdb..#TMP_STOCK_OSP_V') is not null
		drop table #TMP_STOCK_OSP_V
  
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
  
  


