
  
    
    
      
/*      
 * Program ID   : PR_SCP_PLN_CREATE_DATA      
 * Description  : PLN 데이터 반영 SP 호출      
 * Execute      : EXEC PR_SCP_PLN_CREATE_DATA  @p_master_id1 = '81::WEEKLY' ,@p_engine_plan_id1 = '1018::PR::9'     -- 00:02:18         
 * Program History      
 *===================================================================================================      
 *   Date       In Charge      Description      
 *===================================================================================================      
 * 2018.02.22   KTH         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트      
 * 2018.06.07   KTH         TRANSACTION 삭제
 * 2018.06.08   LTW         엔진 OUT용 TEMP 테이블에 데이터 적재 부분 추가 
 *                          SCP_ENG_PEGGING_INFO_O_TEMP,SCP_ENG_UNPEGGING_INFO_O_TEMP,SCP_ENG_WORK_ORDER_O_TEMP
 * 2018.06.12   YYDOK       PR_SCP_PLN_MATERIAL_PLAN 임시수행중지 처리
 * 2018.07.06   KTH         PR_SCP_PLN_ENG_OUTPUT_TEMP_DATA 추가 (SCP_ENG_PEGGING_INFO_O_TEMP_SN,SCP_ENG_UNPEGGING_INFO_O_TEMP_SN,SCP_ENG_WORK_ORDER_O_TEMP_SN) 
 * 2018.08.29   KTH         ASSIGN_QTY 보정로직 반영으로 순서 변경 (PR_SCP_PLN_BOH_ASSIGN)
 * 2018.10.01   YYDOK       PR_SCP_PLN_SET_ASSIGN_TYPE 수행제외처리
 */      
      
CREATE PROCEDURE [dbo].[PR_SCP_PLN_CREATE_DATA]      
    (       
      @p_master_id1      NVARCHAR(4000)         -- '81::WEEKELY'      
    , @p_engine_plan_id1 NVARCHAR(4000)         -- '1018::PR::9'      
    --, @p_user_id              NVARCHAR(150)  = 'scp_batch'        
    ---- , @p_debug       INT OUTPUT      
    )       
 AS      
  BEGIN      
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;      
    SET NOCOUNT ON;      
    SET XACT_ABORT ON;      
    SET ANSI_WARNINGS OFF;      
      
    DECLARE @p_master_id      NVARCHAR(4000) = @p_master_id1 ;                                                                        -- 82::WEEKLY        
    DECLARE @p_engine_plan_id NVARCHAR(4000) = @p_engine_plan_id1 ;                                                                   -- 1018::PR::9        
    DECLARE @p_division_id    NVARCHAR(30)   = SUBSTRING(@p_master_id, 1,       CHARINDEX('::', @p_master_id)-1) ;         
    DECLARE @p_plan_cycle     NVARCHAR(150)  = SUBSTRING(@p_master_id,          CHARINDEX('::', @p_master_id)+2,100) ;        
    DECLARE @p_plan_id        NVARCHAR(4000) = SUBSTRING(@p_engine_plan_id, 1,  CHARINDEX('::', @p_engine_plan_id)-1) ;        
    DECLARE @p_plan_type      NVARCHAR(4000) = SUBSTRING(@p_engine_plan_id,     CHARINDEX('::', @p_engine_plan_id)+2, 2) ;            -- Plan Type이 두 자리이기 때문에 마지막 인수가 2임        
    DECLARE @p_seq            NVARCHAR(4000) = SUBSTRING(@p_engine_plan_id, DBO.FN_CHARINDEX_REV(@p_engine_plan_id, '::', 0)+2,100) ;        
    DECLARE @p_modeling_id    NVARCHAR(4000) ;        
      
    DECLARE @p_plan_name      NVARCHAR(4000) ;        
      
    SET NOCOUNT ON;        
      
      
    -- LOG 용 변수 설정      
    DECLARE @v_batch_user               NVARCHAR(150) = N'scp_batch';        
--    SET @v_batch_user = @p_user_id      
    DECLARE @v_program_name             NVARCHAR(150) = 'PR_SCP_PLN_CREATE_DATA';      
    DECLARE @v_log_type                 NVARCHAR(30); -- START/END/ERROR/...      
    DECLARE @n_log_count                INTEGER = 0;      
    DECLARE @v_log_message              NVARCHAR(1000);      
    DECLARE @v_description              NVARCHAR(500);      
    DECLARE @v_table_id                 NVARCHAR(150) = 'SCP_PLN_ALL';      
    DECLARE @d_event_date               DATETIME;      
    DECLARE @p_plan_start_yyyymmdd      NVARCHAR(30);      
    --SET @p_plan_start_yyyymmdd = @p_plan_id;      
      
    DECLARE @rows INT;      
    DECLARE @v_plan_status INT;     
  
    -- PLAN_TYPE이 SP일 경우  
    if @p_plan_type = 'SP'  
      return -1  
    
     -- 임시 실행시간 확인용    
    DECLARE @v_start_time   DATETIME     = SYSDATETIME();    
    DECLARE @v_exec_time    NVARCHAR(10) = ''--'[00:00]';    
      
    ---------------------------------------------------------        
    -- 실행용 변수 설정        
    -----------------------------------------------------------        
    -- 1. Modelin ID        
    SELECT /* PR_SCP_PLN_CREATE_DATA */        
           @p_modeling_id = m.modeling_id        
    FROM  scm_mst_modeling m with(nolock)        
    WHERE division_id = @p_division_id        
    AND   enterprise  = @p_master_id        
    ANd   plan_cycle  = @p_plan_cycle ;         
        
    -- 2. Plan Name        
    SELECT /* PR_SCP_PLN_CREATE_DATA */        
           @p_plan_name = m.plan_name        
    FROM  scm_mst_plan m with(nolock)        
    WHERE division_id = @p_division_id        
    AND   plan_id     = @p_plan_id        
    ANd   plan_cycle  = @p_plan_cycle ;         
      
    SET @p_plan_start_yyyymmdd =     @p_plan_name;      
      
      
  -- 시작 LOG      
    SET @v_log_type    = 'START';        SET @v_log_message = '#PR_SCP_PLN_CREATE_DATA#### Start of procedure #';      
    SET @v_description = @v_program_name + ':' + @p_plan_start_yyyymmdd;      
    SET @d_event_date  = SYSDATETIME() ;  -- LOG 확인시 순차적으로 보기 위해서       
      
      
    --print '@p_plan_cycle          [' + @p_plan_cycle               +']'      
    --print '@p_plan_name           [' + @p_plan_name                +']'      
    --print '@p_plan_start_yyyymmdd [' + @p_plan_start_yyyymmdd      +']'      
    --print '@p_plan_id             [' + @p_plan_id                  +']'      
    --print '@p_modeling_id         [' + @p_modeling_id              +']'      
    --print '@p_seq                 [' + @p_seq                      +']'      
    --print '@p_plan_type           [' + @p_plan_type                +']'      
    --print '@p_master_id           [' + @p_master_id                +']'      
    --print '@p_division_id         [' + @p_division_id              +']'      
    --print '@p_engine_plan_id      [' + @p_engine_plan_id           +']'      
      
      
      
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name      
                              ,@p_log_type      =@v_log_type      
                              ,@p_log_count     =@n_log_count       
                              ,@p_log_message   =@v_log_message       
                              ,@p_description   =@v_description       
                              ,@p_event_date    =@d_event_date       
                              ,@p_user_id       =@v_batch_user      
                              ;      
      
    SET @rows = 0;      
      
    BEGIN TRY      
      BEGIN      
       -- BEGIN TRAN T1      
        SELECT  @v_plan_status = dbo.FN_GET_PLAN_STATUS(@p_division_id,@p_plan_start_yyyymmdd,@p_plan_type,@p_seq)    
        PRINT '@v_plan_status[START][' +  convert(nvarchar, @v_plan_status)  +']'    
        IF @v_plan_status = -2 GOTO _RETURN_ERR_CODE     
        
        /*
        -------------------------------------------------------------------------------------------------      
        -- ENG OUT -> OUT_TEMP 테일블 데이터 적재
        -------------------------------------------------------------------------------------------------      
        DELETE FROM SCP_ENG_PEGGING_INFO_O_TEMP_SN   WHERE division_id = @p_division_id     --'81'
        DELETE FROM SCP_ENG_UNPEGGING_INFO_O_TEMP_SN WHERE division_id = @p_division_id     --'81'
        DELETE FROM SCP_ENG_WORK_ORDER_O_TEMP_SN     WHERE division_id = @p_division_id     --'81'
                
        --scp_eng_pegging_info_o
        INSERT INTO SCP_ENG_PEGGING_INFO_O_TEMP_SN
        SELECT pi. *
          FROM scp_eng_pegging_info_o_sn AS pi WITH(NOLOCK)
              ,scm_mst_final_item_v      AS fi WITH(NOLOCK)
         WHERE 1=1
           AND pi.division_id     = fi.division_id
           AND pi.from_item_id    = fi.item_id
           AND pi.master_id       = @p_master_id        --'81::WEEKLY'
           AND pi.out_version_id  = @p_engine_plan_id   --'1029::FN::1' 
        
        --scp_eng_unpegging_info_o
        INSERT INTO SCP_ENG_UNPEGGING_INFO_O_TEMP_SN
        SELECT pi. *  
          FROM scp_eng_unpegging_info_o_sn AS pi WITH(NOLOCK)
              ,scm_mst_final_item_v        AS fi WITH(NOLOCK)
         WHERE 1=1
           AND pi.master_id       = @p_master_id        --'81::WEEKLY'
           AND pi.out_version_id  = @p_engine_plan_id   --'1029::FN::1'
           AND pi.division_id     = fi.division_id
           AND pi.item_id         = fi.item_id
        
        --scp_eng_work_order_o
        INSERT INTO SCP_ENG_WORK_ORDER_O_TEMP_SN
        SELECT WO. *
          FROM scp_eng_work_order_o_sn AS wo WITH(NOLOCK)
              ,scm_mst_final_item_v    AS fi WITH(NOLOCK)
         WHERE 1=1
           AND wo.master_id       = @p_master_id        --'81::WEEKLY'
           AND wo.out_version_id  = @p_engine_plan_id   --'1029::FN::1'
           AND wo.division_id     = fi.division_id
           AND wo.item_id         = fi.item_id
           */

        -------------------------------------------------------------------------------------------------      
        -- ENG OUT -> OUT_TEMP 테일블 데이터 적재     
        -------------------------------------------------------------------------------------------------      
        EXEC @ROWS = PR_SCP_PLN_ENG_OUTPUT_TEMP_DATA      @p_plan_cycle             = @p_plan_cycle      
                                                        , @p_plan_start_yyyymmdd    = @p_plan_start_yyyymmdd      
                                                        , @p_plan_id                = @p_plan_id      
                                                        , @p_modeling_id            = @p_modeling_id      
                                                        , @p_seq                    = @p_seq      
                                                        , @p_plan_type              = @p_plan_type      
                                                        , @p_master_id              = @p_master_id      
                                                        , @p_division_id            = @p_division_id      
                                                        , @p_engine_plan_id         = @p_engine_plan_id      
        --------------------------------------------------------------------------------------------------     
        SELECT  @v_plan_status = dbo.FN_GET_PLAN_STATUS(@p_division_id,@p_plan_start_yyyymmdd,@p_plan_type,@p_seq)    
        PRINT '@v_plan_status[PR_SCP_PLN_ENG_OUTPUT_TEMP_DATA][' +  convert(nvarchar, @v_plan_status)  +']'      
        --SELECT 'PR_SCP_PLN_ENG_OUTPUT_TEMP_DATA', @rows;      
        IF (@rows < 0 OR @v_plan_status = -2)  GOTO _RETURN_ERR_CODE        
        --PRINT @rows               

        -------------------------------------------------------------------------------------------------      
        -- TH_ENG_STOCK_PLAN -- SCP_PLN_TH_ENG_STOCK_PLAN로 엔진INPUT데이타를 보관.    
        -------------------------------------------------------------------------------------------------      
        EXEC @ROWS = PR_SCP_PLN_TH_ENG_STOCK_PLAN       @p_plan_cycle             = @p_plan_cycle      
                                                      , @p_plan_start_yyyymmdd    = @p_plan_start_yyyymmdd      
                                                      , @p_plan_id                = @p_plan_id      
                                                      , @p_modeling_id            = @p_modeling_id      
                                                      , @p_seq                    = @p_seq      
                                                      , @p_plan_type              = @p_plan_type      
                                                      , @p_master_id              = @p_master_id      
                                                      , @p_division_id            = @p_division_id      
                                                      , @p_engine_plan_id         = @p_engine_plan_id      
        --------------------------------------------------------------------------------------------------     
        SELECT  @v_plan_status = dbo.FN_GET_PLAN_STATUS(@p_division_id,@p_plan_start_yyyymmdd,@p_plan_type,@p_seq)    
        PRINT '@v_plan_status[PR_SCP_PLN_TH_ENG_STOCK_PLAN][' +  convert(nvarchar, @v_plan_status)  +']'      
        --SELECT 'PR_SCP_PLN_TH_ENG_STOCK_PLAN', @rows;      
        IF (@rows < 0 OR @v_plan_status = -2)  GOTO _RETURN_ERR_CODE        
        --PRINT @rows 

        -------------------------------------------------------------------------------------------------      
        -- 출하계획  -- 출하 Pegging 추가      
        -------------------------------------------------------------------------------------------------      
        EXEC @ROWS = PR_SCP_PLN_SHIPMENT_PLAN   @p_plan_cycle             = @p_plan_cycle      
                                              , @p_plan_start_yyyymmdd    = @p_plan_start_yyyymmdd      
                                              , @p_plan_id                = @p_plan_id      
                                              , @p_modeling_id            = @p_modeling_id      
                                              , @p_seq                    = @p_seq      
                                              , @p_plan_type              = @p_plan_type      
                                              , @p_master_id              = @p_master_id      
                                              , @p_division_id            = @p_division_id      
                                              , @p_engine_plan_id         = @p_engine_plan_id      
        --------------------------------------------------------------------------------------------------     
        SELECT  @v_plan_status = dbo.FN_GET_PLAN_STATUS(@p_division_id,@p_plan_start_yyyymmdd,@p_plan_type,@p_seq)    
        PRINT '@v_plan_status[PR_SCP_PLN_SHIPMENT_PLAN][' +  convert(nvarchar, @v_plan_status)  +']'      
        --SELECT 'PR_SCP_PLN_SHIPMENT_PLAN', @rows;      
        IF (@rows < 0 OR @v_plan_status = -2)  GOTO _RETURN_ERR_CODE        
        --PRINT @rows               
            
        -------------------------------------------------------------------------------------------------      
        -- 생산계획 -- 생산 Pegging 추가      
        -------------------------------------------------------------------------------------------------      
        EXEC @ROWS = PR_SCP_PLN_PRODUCTION_PLAN   @p_plan_cycle             = @p_plan_cycle      
                                                , @p_plan_start_yyyymmdd    = @p_plan_start_yyyymmdd      
                                                , @p_plan_id                = @p_plan_id      
                                                , @p_modeling_id            = @p_modeling_id      
                                                , @p_seq                    = @p_seq      
                                                , @p_plan_type              = @p_plan_type      
                                                , @p_master_id              = @p_master_id      
                                                , @p_division_id            = @p_division_id      
                                                , @p_engine_plan_id         = @p_engine_plan_id      
        --------------------------------------------------------------------------------------------------     
        SELECT  @v_plan_status = dbo.FN_GET_PLAN_STATUS(@p_division_id,@p_plan_start_yyyymmdd,@p_plan_type,@p_seq)    
        PRINT '@v_plan_status[PR_SCP_PLN_PRODUCTION_PLAN][' +  convert(nvarchar, @v_plan_status)  +']'     
        --SELECT 'PR_SCP_PLN_PRODUCTION_PLAN', @rows;      
        IF (@rows < 0 OR @v_plan_status = -2)  GOTO _RETURN_ERR_CODE        
        --PRINT @rows             
         
        --------------------------------------------------------------------------------------------------      
        -- MATERIAL PLAN      
        --------------------------------------------------------------------------------------------------      
-- 임시로 수행을 막음.yydok 2018.06.12
/*
        EXEC @ROWS = PR_SCP_PLN_MATERIAL_PLAN  @p_plan_cycle             = @p_plan_cycle      
                                             , @p_plan_start_yyyymmdd    = @p_plan_start_yyyymmdd      
                                             , @p_plan_id                = @p_plan_id      
                                             , @p_modeling_id            = @p_modeling_id      
                                             , @p_seq                    = @p_seq      
                                             , @p_plan_type              = @p_plan_type      
                                             , @p_master_id              = @p_master_id      
                                             , @p_division_id            = @p_division_id      
                                             , @p_engine_plan_id         = @p_engine_plan_id      
                                           --, @p_user_id                = 'KTH'   
*/                                            
        --------------------------------------------------------------------------------------------------     
        SELECT  @v_plan_status = dbo.FN_GET_PLAN_STATUS(@p_division_id,@p_plan_start_yyyymmdd,@p_plan_type,@p_seq)    
        PRINT '@v_plan_status[PR_SCP_PLN_MATERIAL_PLAN][' +  convert(nvarchar, @v_plan_status)  +']'     
        --SELECT 'PR_SCP_PLN_MATERIAL_PLAN', @rows;      
        IF (@rows < 0 OR @v_plan_status = -2)  GOTO _RETURN_ERR_CODE        
        --PRINT @rows          
    
        --------------------------------------------------------------------------------------------------      
        -- PLANT ON hand      
        --------------------------------------------------------------------------------------------------      
        EXEC @ROWS = PR_SCP_PLN_PLANT_ONHAND   @p_plan_cycle             = @p_plan_cycle      
                                             , @p_plan_start_yyyymmdd    = @p_plan_start_yyyymmdd      
                                             , @p_plan_id                = @p_plan_id      
                                             , @p_modeling_id            = @p_modeling_id      
                                             , @p_seq                    = @p_seq      
                                             , @p_plan_type              = @p_plan_type      
                                             , @p_master_id              = @p_master_id      
                                             , @p_division_id            = @p_division_id      
                                             , @p_engine_plan_id         = @p_engine_plan_id      
        --------------------------------------------------------------------------------------------------     
        SELECT  @v_plan_status = dbo.FN_GET_PLAN_STATUS(@p_division_id,@p_plan_start_yyyymmdd,@p_plan_type,@p_seq)    
        PRINT '@v_plan_status[PR_SCP_PLN_PLANT_ONHAND][' +  convert(nvarchar, @v_plan_status)  +']'     
        --SELECT 'PR_SCP_PLN_PLANT_ONHAND', @rows;      
        IF (@rows < 0 OR @v_plan_status = -2)  GOTO _RETURN_ERR_CODE        
        --PRINT @rows      

         -------------------------------------------------------------------------------------------------      
        -- BOH ASSIGN   
        -------------------------------------------------------------------------------------------------      
        EXEC @ROWS = PR_SCP_PLN_BOH_ASSIGN    @p_plan_cycle             = @p_plan_cycle      
                                            , @p_plan_start_yyyymmdd    = @p_plan_start_yyyymmdd      
                                            , @p_plan_id                = @p_plan_id      
                                            , @p_modeling_id            = @p_modeling_id      
                                            , @p_seq                    = @p_seq      
                                            , @p_plan_type              = @p_plan_type      
                                            , @p_master_id              = @p_master_id      
                                            , @p_division_id            = @p_division_id      
                                            , @p_engine_plan_id         = @p_engine_plan_id      
        --------------------------------------------------------------------------------------------------     
        SELECT  @v_plan_status = dbo.FN_GET_PLAN_STATUS(@p_division_id,@p_plan_start_yyyymmdd,@p_plan_type,@p_seq)    
        PRINT '@v_plan_status[PR_SCP_PLN_BOH_ASSIGN][' +  convert(nvarchar, @v_plan_status)  +']'     
      
        --SELECT 'PR_SCP_PLN_BOH_ASSIGN', @rows;      
        IF (@rows < 0 OR @v_plan_status = -2)  GOTO _RETURN_ERR_CODE      
        --PRINT @rows      
        --------------------------------------------------------------------------------------------------      
        -- SALES ON hand      
        --------------------------------------------------------------------------------------------------      
        EXEC @ROWS = PR_SCP_PLN_SALES_ONHAND   @p_plan_cycle             = @p_plan_cycle      
                                             , @p_plan_start_yyyymmdd    = @p_plan_start_yyyymmdd      
                                             , @p_plan_id                = @p_plan_id      
                                             , @p_modeling_id            = @p_modeling_id      
                                             , @p_seq                    = @p_seq      
                                             , @p_plan_type              = @p_plan_type      
                                             , @p_master_id              = @p_master_id      
                                             , @p_division_id            = @p_division_id      
                                             , @p_engine_plan_id         = @p_engine_plan_id      
        --------------------------------------------------------------------------------------------------     
        SELECT  @v_plan_status = dbo.FN_GET_PLAN_STATUS(@p_division_id,@p_plan_start_yyyymmdd,@p_plan_type,@p_seq)    
        PRINT '@v_plan_status[PR_SCP_PLN_SALES_ONHAND][' +  convert(nvarchar, @v_plan_status)  +']'     
        --SELECT 'PR_SCP_PLN_SALES_ONHAND', @rows;      
        IF (@rows < 0 OR @v_plan_status = -2)  GOTO _RETURN_ERR_CODE        
        --PRINT @rows      
          
        --------------------------------------------------------------------------------------------------      
        -- ALLOCATION    
        --------------------------------------------------------------------------------------------------      
        EXEC @ROWS = PR_SCP_PLN_ALLOCATION     @p_plan_cycle             = @p_plan_cycle      
                                             , @p_plan_start_yyyymmdd    = @p_plan_start_yyyymmdd      
                                             , @p_plan_id                = @p_plan_id      
                                             , @p_modeling_id            = @p_modeling_id      
                                             , @p_seq                    = @p_seq      
                                             , @p_plan_type              = @p_plan_type      
                                             , @p_master_id              = @p_master_id      
                                             , @p_division_id            = @p_division_id      
                                             , @p_engine_plan_id         = @p_engine_plan_id      
        --------------------------------------------------------------------------------------------------     
        SELECT  @v_plan_status = dbo.FN_GET_PLAN_STATUS(@p_division_id,@p_plan_start_yyyymmdd,@p_plan_type,@p_seq)    
        PRINT '@v_plan_status[PR_SCP_PLN_ALLOCATION][' +  convert(nvarchar, @v_plan_status)  +']'     
        --SELECT 'PR_SCP_PLN_ALLOCATION', @rows;      
        IF (@rows < 0 OR @v_plan_status = -2)  GOTO _RETURN_ERR_CODE        
        --PRINT @rows      


        -------------------------------------------------------------------------------------------------      
        -- SCP ASSIGN TYPE    
        -------------------------------------------------------------------------------------------------      
/*
        EXEC @ROWS = PR_SCP_PLN_SET_ASSIGN_TYPE           @p_plan_cycle             = @p_plan_cycle      
                                                        , @p_plan_start_yyyymmdd    = @p_plan_start_yyyymmdd      
                                                        , @p_plan_id                = @p_plan_id      
                                                        , @p_modeling_id            = @p_modeling_id      
                                                        , @p_seq                    = @p_seq      
                                                        , @p_plan_type              = @p_plan_type      
                                                        , @p_master_id          = @p_master_id      
                                                        , @p_division_id            = @p_division_id      
                                                        , @p_engine_plan_id         = @p_engine_plan_id      
      
        --SELECT 'PR_SCP_PLN_SET_ASSIGN_TYPE', @rows;      
        IF @rows < 0 GOTO _RETURN_ERR_CODE      
        --PRINT @rows      
  */   
        -----------------------------------------------------------      
        -- 실행 Logic END --      
        -----------------------------------------------------------      
        --IF @@TRANCOUNT > 0      
        --  BEGIN      
        --    COMMIT ;      
        --  END;             
      
      
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
      --    ROLLBACK       
      --  END;      
            
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
--      PRINT @@ERROR      
      return -1      
    END CATCH;      
      
        
    -- 임시 운영반영시에 주석처리 할것.    
    SET @v_exec_time  =  REPLICATE('0', 2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +     
                         REPLICATE('0', 2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))     
    
    -- 종료 LOG      
    SET @v_log_type = N'END';      
    SET @v_log_message = N'########## END of procedure ##########';      
    SET @v_description = N'[' + @p_master_id1 + ']['+@p_engine_plan_id+'][' + @v_exec_time + ']';   
    SET @d_event_date =  SYSDATETIME()  ;   -- 로그 정렬시에 일자와 LOG_TYPE 순서대로 보기 위해서      
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name      
                              ,@p_log_type      =@v_log_type      
                              ,@p_log_count     =@n_log_count       
                              ,@p_log_message   =@v_log_message       
                              ,@p_description   =@v_description       
                              ,@p_event_date    =@d_event_date       
                              ,@p_user_id       =@v_batch_user      
                              ;      
    return 1        
      
    _RETURN_ERR_CODE:      
        BEGIN      
            
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
          RETURN -1      
        END;      
      
  END;       



