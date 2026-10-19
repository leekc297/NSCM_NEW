  
    
/*        
 * Program ID   : PR_SCP_PLN_ALLOCATION          
 * Description  : PR_SCP_PLN_CREATE_DATA 에서 호출함.        
 * OutTable     :        
 * Execute      :   
  EXEC PR_SCP_PLN_ALLOCATION      @p_plan_cycle          ='WEEKLY'
                                , @p_plan_start_yyyymmdd ='20180702'   
                                , @p_plan_id             ='1033'   
                                , @p_modeling_id         ='4'          
                                , @p_seq                 ='8'
                                , @p_plan_type           ='PR'    
                                , @p_master_id           ='EE::WEEKLY' 
                                , @p_division_id         ='EE'     
                                , @p_engine_plan_id      ='1033::PR::8'  
                                , @p_user_id             = 'KTH'
  
 * Program History        
 *===================================================================================================        
 *   Date       In Charge      Description        
 *===================================================================================================        
 * 2018.04.27   KTH         Initial Release PJ20170278 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트    
 * 2018-05-23   LTW         DUE_DATE DATA TYPE 수정      
 * 2018-06-01   YYDOK       STOCK_PLAN_LOT_ID 칼럼추가 및 DUE_DATE 보다늦은 INT로 ALLOCATION한 경우, ALLOCATION일자를 INT도착일자로 반영  
 * 2018.06.07   KTH         TRANSACTION 삭제  
 * 2018.06.08   KTH         SCP_ENG_PEGGING_INFO_O_TEMP 사용 로직으로 변경, OPERATION_GROUP 함수에서 SCM_MST_FINAL_ITEM_V로 변경  
 * 2018.06.27   KTH         전극 SCP 반영(ORIGIN_TO_DIVISION_ID,ORIGIN_FROM_DIVISION_ID,ELECTRODE_TYPE) 추가  
 * 2018.07.04   KTH         SCP_MST_FINAL_ITEM_V로 변경
 * 2018.07.05   KTH         ORIGIN_TO_DIVISION_ID(SALES_SITE_ID가 LIKE ‘%-A-S’인경우 앞의 ‘____-A’ 6자리)
 * 2018.07.09   KTH         TEMP 테이블 변경으로 로직 수정
 * 2024.05.28   KSG         PJ20244573 LGES SCM SCP 생산모델 기반 공급계획 수립체계 구성 : From Item 정보 추가
 * 2024.11.14   JJG         PJ20249346 LGES SCP 개선과제 이행 : From SITE ID 정보 추가
 */    

/*

 EXEC PR_SCP_PLN_ALLOCATION_add_fromSite	  'WEEKLY'
											, '20241111' 
											, '1365'
											, '2'
											, '1'
											, 'PR'
											, '81::WEEKLY' 
											, '81'
											, '1365::PR::1'
											, 'JJG'

 */ 
  
CREATE PROCEDURE [dbo].[PR_SCP_PLN_ALLOCATION_add_fromSite]        
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
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SCP_PLN_ALLOCATION';        
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...        
    DECLARE @n_log_count    INTEGER = 0;        
    DECLARE @v_log_message  NVARCHAR(1000);        
    DECLARE @v_description  NVARCHAR(500);      
    DECLARE @v_table_id     NVARCHAR(150) = N'SCM_SYS_LOG_BATC';     
    DECLARE @d_event_date   DATETIME;        
    
  -- 시작 LOG        
    SET @v_log_type = N'START';        
    SET @v_log_message = N'########## Start of procedure ##########';        
    SET @v_description = @v_program_name + ':' + N' SCP_PLN_ALLOCATION INSERT LOGIC';        
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
    DECLARE @v_exec_time    NVARCHAR(10) = ''--'00:00';    
    
    BEGIN TRY        
      BEGIN        
--        BEGIN TRAN T1        
                  
            -------------------------------------------------------------------------------------------------------------         
            -- 0. 임시 테이블 생성  
            -------------------------------------------------------------------------------------------------------------   
            IF OBJECT_ID('tempdb..#tmp_SCP_PLN_ALLOCATION') IS NOT NULL
            DROP TABLE #tmp_SCP_PLN_ALLOCATION     
              
                   SELECT   A.MASTER_ID    
                           ,A.PLAN_ID    
                           ,A.OUT_VERSION_ID    
                           ,A.DIVISION_ID    
                           ,A.PLAN_NAME                           AS PLAN_START_YYYYMMDD    
                           ,A.PLAN_TYPE    
                           ,A.SEQ    
                           ,A.OPERATION_GROUP                     AS OPERATION_GROUP      
                           ,A.DEMAND_ID                           AS ENG_DEMAND_ID  
                           ,DBO.FN_SCM_SPLIT(A.DEMAND_ID,1,'::')  AS ITEM_ID          
                           ,DBO.FN_SCM_SPLIT(A.DEMAND_ID,2,'::')  AS PROJECT_CODE        
     
                           ,DBO.FN_SCM_SPLIT(DBO.FN_SCM_SPLIT(A.DEMAND_ID,3,'::'),1,'~') AS SALES_SITE_ID_S
                           ,SUBSTRING(DBO.FN_SCM_SPLIT(DBO.FN_SCM_SPLIT(A.DEMAND_ID,3,'::'),1,'~'),1,6) AS SALES_SITE_ID

                           ,DBO.FN_SCM_SPLIT(DBO.FN_SCM_SPLIT(A.DEMAND_ID,3,'::'),2,'~') AS INCOTERMS          
                           ,DBO.FN_SCM_SPLIT(A.DEMAND_ID,4,'::')  AS DOM_EXP        
                           ,DBO.FN_SCM_SPLIT(A.DEMAND_ID,5,'::')  AS FCST_TYPE        
                           ,DBO.FN_SCM_SPLIT(A.DEMAND_ID,6,'::')  AS DEMAND_TYPE         
                           ,CONVERT(DATETIME,DBO.FN_SCM_SPLIT(A.DEMAND_ID,7,'::'),112) AS DUE_DATE                     
                           ,(CASE DBO.FN_SCM_SPLIT(DBO.FN_SCM_SPLIT(DBO.FN_SCM_SPLIT(A.DEMAND_ID,8,'::'),1,'^'),1,'##')      
                                   WHEN 'NOPLANT' THEN '-'      
                                   ELSE DBO.FN_SCM_SPLIT(DBO.FN_SCM_SPLIT(DBO.FN_SCM_SPLIT(A.DEMAND_ID,8,'::'),1,'^'),1,'##')      
                               END )                              AS PLANT_SITE_ID    
                           ,CASE WHEN ( A.STOCK_PLAN_LOT_ID IS NOT NULL AND DBO.FN_SCM_SPLIT(A.STOCK_PLAN_LOT_ID,4,'::') > CONVERT(NVARCHAR(8), A.DUE_DATE, 112) ) THEN DBO.FN_SCM_SPLIT(A.STOCK_PLAN_LOT_ID,4,'::')  
                                ELSE CONVERT(NVARCHAR(8), A.START_DTTM, 112)  
                            END                                   AS YYYYMMDD  
                           ,A.QTY                                 AS ALLOCATION_QTY          
                           ,A.DELIVERY_ORDER_ID                              
                           ,A.FROM_SITE_ID                        AS FROM_SITE  
                           ,A.STOCK_PLAN_LOT_ID  
                           ,A.ORIGIN_FROM_DIVISION_ID  
                           ,A.ORIGIN_TO_DIVISION_ID  
                           ,A.ELECTRODE_TYPE AS ELECTRODE_TYPE  
                           -- 20240528 PJ20244573 From Item 정보 추가
                           ,A.FROM_ITEM_ID                        AS FROM_ITEM_ID  
						   ,FROM_SITE_SCP = ( CASE  WHEN isnull(a.delivery_order_id,'') > '0' THEN (select SUBSTRING(de.FROM_SITE_ID,1,(CASE WHEN CHARINDEX('~', de.FROM_SITE_ID) = 0  THEN LEN(de.FROM_SITE_ID) ELSE CHARINDEX('~', de.FROM_SITE_ID)  -1 END))
																				--from [10.34.221.78,7433].eng_scp.dbo.th_exp_delivery de with(nolock)
																				from th_exp_delivery_sn de with(nolock)
																				where  de.master_id = a.master_id 
																				and de.plan_id = a.out_version_id 
																				and de.item_id = a.from_item_id -- Group 에 의해 실제 제공된 Item 표시
																				and de.out_version_id = a.out_version_id 
																				and de.order_id = a.delivery_order_id 
																				and de.demand_id = a.demand_id  )  --eng_demand_id
													WHEN LEFT(a.STOCK_PLAN_LOT_ID,3) = 'INT' THEN DBO.FN_SCM_SPLIT(a.STOCK_PLAN_LOT_ID,5,'::')
													--ELSE NULL
													END )
                   INTO #tmp_SCP_PLN_ALLOCATION  
                   FROM SCP_ENG_PEGGING_INFO_O_TEMP_SN A WITH(NOLOCK)      
                  WHERE 0 = 0    
                    AND A.MASTER_ID          = @p_master_id                  
                    AND A.PLAN_ID            = @p_plan_id                    
                    AND A.OUT_VERSION_ID     = @p_engine_plan_id                  
                    AND A.DIVISION_ID        = @p_division_id                
                    AND A.PLAN_NAME          = @p_plan_start_yyyymmdd        
                    AND A.PLAN_TYPE          = @p_plan_type                  
                    AND A.SEQ                = @p_seq                        
                    AND A.PEGGING_TYPE       = 'ALLOCATION'    

            -------------------------------------------------------------------------------------------------------------         
            -- 2. SCP_PLN_ALLOCATION 입력         
            -------------------------------------------------------------------------------------------------------------         
    
              DELETE FROM dbo.SCP_PLN_ALLOCATION          
              WHERE DIVISION_ID = @p_division_id AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd AND PLAN_TYPE = @p_plan_type AND SEQ = @p_seq        
    
              INSERT INTO dbo.SCP_PLN_ALLOCATION        
              (        
                 MASTER_ID    
                ,PLAN_ID    
                ,OUT_VERSION_ID    
                ,DIVISION_ID    
                ,PLAN_START_YYYYMMDD    
                ,PLAN_TYPE    
                ,SEQ    
                ,OPERATION_GROUP    
                ,ENG_DEMAND_ID    
                ,ITEM_ID    
                ,PROJECT_CODE    
                ,SALES_SITE_ID    
                ,INCOTERMS    
                ,DOM_EXP    
                ,FCST_TYPE    
                ,DEMAND_TYPE    
                ,DUE_DATE    
                ,PLANT_SITE_ID    
                ,YYYYMMDD    
                ,ALLOCATION_QTY    
                ,DELIVERY_ORDER_ID    
                ,FROM_SITE  
                ,STOCK_PLAN_LOT_ID         
                ,ORIGIN_FROM_DIVISION_ID    
                ,ORIGIN_TO_DIVISION_ID  
                ,ELECTRODE_TYPE  
                -- 20240528 PJ20244573 From Item 정보 추가
                ,ATTRIBUTE1  -- FROM_ITEM_ID
				,ATTRIBUTE2  -- FROM_SITE_SCP
                ,CREATED_BY        
                ,CREATION_DATE        
                ,LAST_UPDATED_BY        
                ,LAST_UPDATE_DATE        
              )      
                  
                                
                   SELECT    MASTER_ID    
                            ,PLAN_ID    
                            ,OUT_VERSION_ID    
                            ,DIVISION_ID    
                            ,PLAN_START_YYYYMMDD    
                            ,PLAN_TYPE    
                            ,SEQ    
                            ,OPERATION_GROUP    
                            ,ENG_DEMAND_ID    
                            ,ITEM_ID    
                            ,PROJECT_CODE    
--                            ,SALES_SITE_ID
                            ,SALES_SITE_ID_S    
                            ,INCOTERMS    
                            ,DOM_EXP    
                            ,FCST_TYPE    
                            ,DEMAND_TYPE    
                            ,DUE_DATE    
                            ,PLANT_SITE_ID    
                            ,YYYYMMDD    
                            ,ALLOCATION_QTY    
                            ,DELIVERY_ORDER_ID    
                            ,FROM_SITE  
                            ,STOCK_PLAN_LOT_ID         
                            ,ORIGIN_FROM_DIVISION_ID    
                            ,ORIGIN_TO_DIVISION_ID  
                            ,ELECTRODE_TYPE  
                           -- 20240528 PJ20244573 From Item 정보 추가
                            ,FROM_ITEM_ID
							,FROM_SITE_SCP
                            ,@v_batch_user        AS CREATED_BY    
                            ,GETDATE()            AS CREATION_DATE    
                            ,@v_batch_user        AS LAST_UPDATED_BY    
                            ,GETDATE()            AS LAST_UPDATED_BY    
                   FROM #tmp_SCP_PLN_ALLOCATION  
                   ;  
           
        -----------------------------------------------------------        
        -- 실행 Logic END --        
        -----------------------------------------------------------        
        --IF @@TRANCOUNT > 0        
        --  BEGIN        
        --    COMMIT TRAN T1;        
        --  END;     
        
        -----------------------------------------------------------
        -- 임시테이블 삭제
        -----------------------------------------------------------
        IF OBJECT_ID('tempdb..#tmp_SCP_PLN_ALLOCATION') IS NOT NULL
        DROP TABLE #tmp_SCP_PLN_ALLOCATION
        
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
      --IF @@TRANCOUNT > 0        
      --  BEGIN        
      --    ROLLBACK TRAN T1        
      --  END;        
              
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
     SET @v_exec_time  =  REPLICATE('0', 2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +     
                          REPLICATE('0', 2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))     
    
    
    -- 종료 LOG        
    SET @v_log_type = N'END';        
    SET @v_log_message = N'########## END of procedure ##########';        
    SET @v_description = N'[' + @p_master_id + ']['+@p_engine_plan_id+'][' + @v_exec_time + ']';             
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
    
    
    
  

