
              
/*                    
 * Program ID   : PR_SSP_ANL_SHIPMENT_PLAN_FG                      
 * Description  : PR_SSP_ANL_CREATE_DATA 에서 호출함.                    
 * OutTable     :                    
 * Execute      : EXEC PR_SSP_ANL_SHIPMENT_PLAN_FG    @p_plan_cycle          ='DAILY'
                                                    , @p_plan_start_yyyymmdd ='20180807'   
                                                    , @p_plan_id             ='103802'   
                                                    , @p_modeling_id         ='201'          
                                                    , @p_seq                 ='1'
                                                    , @p_plan_type           ='SP'    
                                                    , @p_master_id           ='81::DAILY' 
                                                    , @p_division_id         ='81'     
                                                    , @p_engine_plan_id      ='103802::SP::1'
                                                    , @p_user_id             = 'KTH' 
                 -- UI 실행
                 EXEC SSP0009_GET_SHIPMENT_PLAN_FG     @p_from_yyyymmdd        ='20180807'
                                                     , @p_to_yyyymmdd         ='20181001' 
                                                     , @p_division_id         ='81'
                                                     , @p_biz_type            ='A'
                                                     --, @p_electype            =''
                                                     --, @p_tosite              =''  
                                                     , @p_project_code        ='A15HC2001'
                                                     , @p_item_id             ='ACLN1007I-A1' --'ACEN1059I-A1'--ACLN1007I-A1' -- 'ACEP1038I-A1'
                                                     , @p_plan_start_yyyymmdd ='20180807'
                                                     , @p_plan_type           ='SP'
                                                     , @p_seq                 ='1'
                                                     , @p_program_id          = 'SSP0009'  
                                                     , @p_sheet_name          = 'Shipment Plan FG'    
                                                     , @p_user_id             = 'middleware'   

 * Program History                    
 *===================================================================================================                    
 *   Date       In Charge      Description                    
 *===================================================================================================                    
 * 2018.06.12   LTW         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트  
 * 2018.06.18   KTH         CONVERT(VARCHAR,DATEADD(D,56,CONVERT(DATETIME,@p_plan_start_yyyymmdd ,112)),112)  -- 8주(56일) 추가  
 * 2018.07.16   KTH         전극 SCP 반영(ORIGIN_FROM_DIVISION_ID,ORIGIN_TO_DIVISION_ID,ELECTRODE_TYPE) 추가
                            SCP_MST_FINAL_ITEM_V로 변경, #TMP_SSP_PLN_NET_DEMAND_V로 변경
                            파라미터 변경 (PLN과 동일하게 변경),MEASURE를 0으로 추가 로직 변경
 * 2018.07.19   KTH         INCOTERMS 수정
 * 2018.07.27   KTH         INCOTERMS 수정(BOD_ID -> DEMAND_ID)
 * 2018.08.07   KTH         MEASURE(WH_IN_BALANCE) 로직 추가( to site기준의 BOH + 특정일자까지 누적 Fcst qty * (-1) + 특정일자까지 누적 WH_IN total 누적수량)
 * 2018.08.22   KTH         최종입력시점에 MAX(INCOTERMS) -->    INCOTERMS 로 변경함.
 * 2018.09.14   KTH         UNPEGGING 제외 조건 추가 (ENG_DEMAND_ID      <> 'UNPEGGING')
 * 2018.09.17   KTH         소형(40) Balance데이타 생성시 월별로 계산,Balance(WH_IN) 삭제,  삭제시 속도 개선
 * 2018.11.21   KTH         'SHIP_REQ' 로직변경(YYYYMMDD = LPST) 추가
 * 2019.08.02   KTH         BALANCE 입력(소형(40)일 경우)  월별 BALANCE 적용로직 삭제
 */                    
                    
CREATE PROCEDURE [dbo].[PR_SSP_ANL_SHIPMENT_PLAN_FG]                    
(            
      @p_plan_cycle           NVARCHAR(150)          
    , @p_plan_start_yyyymmdd  NVARCHAR(8)     -- plan_name       
    , @p_plan_id              NVARCHAR(4000)          
    , @p_modeling_id          NVARCHAR(4000)          
    , @p_seq                  NVARCHAR(4000)          
    , @p_plan_type            NVARCHAR(4000)          
    , @p_master_id            NVARCHAR(4000)          
    , @p_division_id          NVARCHAR(30)          
    , @p_engine_plan_id       NVARCHAR(4000)          
    , @p_user_id              NVARCHAR(150)  = 'ssp_batch'          
    ---- , @p_debug       INT OUTPUT                       
)                     
AS                    
  BEGIN                    
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;                    
    SET NOCOUNT ON;                    
    SET XACT_ABORT ON;                    
    SET ANSI_WARNINGS OFF;                    
                    
    -- LOG 용 변수 설정                    
    DECLARE @v_batch_user   NVARCHAR(150) = N'ssp_batch';                      
    SET @v_batch_user = @p_user_id                    
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SSP_ANL_SHIPMENT_PLAN_FG';                    
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...                    
    DECLARE @n_log_count    INTEGER = 0;                    
    DECLARE @v_log_message  NVARCHAR(1000);                    
    DECLARE @v_description  NVARCHAR(500);        
    DECLARE @v_table_id     NVARCHAR(150) = N'SSP_ANL_SHIPMENT_PLAN_FG';                     
    DECLARE @d_event_date   DATETIME;                    
                    
  -- 시작 LOG                    
    SET @v_log_type = N'START';                    
    SET @v_log_message = N'########## Start of procedure ##########';                    
    SET @v_description = @v_program_name + ':' + N' SSP_ANL_SHIPMENT_PLAN_FG INSERT LOGIC';                    
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
        --BEGIN TRAN TX_FG                    
          -------------------------------------------------------------------------------------------------------------                       
          -- 0. temp 테이블 생성 : Measure까지 생성후 마지막에 한번에 입력하기 위해서                      
          -------------------------------------------------------------------------------------------------------------                       
          IF OBJECT_ID('tempdb..#tmp_SSP_ANL_SHIPMENT_PLAN_FG') IS NOT NULL                      
              DROP TABLE #tmp_SSP_ANL_SHIPMENT_PLAN_FG                      
                      
            CREATE TABLE #tmp_SSP_ANL_SHIPMENT_PLAN_FG(                      
               DIVISION_ID         nvarchar(030)                      
              ,PLAN_START_YYYYMMDD nvarchar(008)                      
              ,PLAN_TYPE           nvarchar(050)                      
              ,SEQ                 INT                      
              ,OPERATION_GROUP     nvarchar(010)                      
              ,PROJECT_CODE        nvarchar(100)                      
              ,ITEM_ID             nvarchar(100)                      
              ,TO_SITE             nvarchar(100)                      
              ,INCOTERMS           nvarchar(100)                      
              ,FROM_SITE           nvarchar(100)                      
              ,BOD_ID              nvarchar(150)                      
              ,TRANSPORT_MODE      nvarchar(050)                        
              ,MEASURE             nvarchar(050)                      
              ,YYYYMMDD            nvarchar(008)                  
              ,ORIGIN_FROM_DIVISION_ID  nvarchar(030)   
              ,ORIGIN_TO_DIVISION_ID    nvarchar(030)   
              ,ELECTRODE_TYPE           nvarchar(030)       
              ,QTY                 numeric (20,10)                      
            );                      
          
                      
          
          
                      
            -------------------------------------------------------------------------------------------------------------                       
            -- Measure 확인 (FG)                      
            -------------------------------------------------------------------------------------------------------------                       
            /*                      
            --SHIP PLAN FG MEASURE                      
            SELECT DBO.FN_GET_MEASURE_CODE('Ship Plan')           -- SHIP_PLAN              -- 1 SHIP_PLAN 입력 (FG)                      
            SELECT DBO.FN_GET_MEASURE_CODE('Ship Req')            -- SHIP_REQ               -- 1 SHIP_REQ 입력(FG)                      
                                            
            SELECT DBO.FN_GET_MEASURE_CODE('WH In')                 -- WH_IN                -- 2 WH_IN 입력 FG                      
            SELECT DBO.FN_GET_MEASURE_CODE('Intransit')             -- INTRANSIT            -- 3 INTRANSIT 입력  FG                      
            SELECT DBO.FN_GET_MEASURE_CODE('MKT FCST')              -- MKT_FCST             -- 4 MKT_FCST 입력 FG                      
                      
            SELECT * FROM DBO.SCM_MST_SHEET_MEASURE WITH(NOLOCK)  WHERE PROGRAM_ID ='SCP0009'  -- shipment plan FG                
                         
                       MKT_FCST         MKT FCST            
                       INTRANSIT       Intransit            
                       WH_IN_TOTAL      WH In Total  = SUM(WH_IN) + INTRANSIT            
                       BALANCE         Balance      = BOH - MKT_FCST + WH_IN_TOTAL            
                       WH_IN           WH In            
                       SHIP_REQ         Ship Req            
                       SHIP_PLAN       Ship Plan            
                       SHIP_PLAN_AMEND Ship Plan Amend                             
            */            
                          
            -------------------------------------------------------------------------------------------------------------                       
            -- 1-1. SHIP_REQ 입력 (FG)                      
            -------------------------------------------------------------------------------------------------------------               
            INSERT INTO #tmp_SSP_ANL_SHIPMENT_PLAN_FG                      
                  (                      
                   DIVISION_ID                      
                  ,PLAN_START_YYYYMMDD                      
                  ,PLAN_TYPE                      
                  ,SEQ                      
                  ,OPERATION_GROUP                      
                  ,PROJECT_CODE                      
                  ,ITEM_ID                      
                  ,TO_SITE                      
                  ,INCOTERMS              
                  ,FROM_SITE                      
                  ,BOD_ID                  
                  ,TRANSPORT_MODE                      
                  ,MEASURE                      
                  ,YYYYMMDD                      
                  ,QTY                      
        )                      
            SELECT DIVISION_ID                      
                  ,PLAN_START_YYYYMMDD                      
                  ,PLAN_TYPE                      
                  ,SEQ                      
                  ,MAX(OPERATION_GROUP)                      
                  ,PROJECT_CODE                              
                  ,ITEM_ID                      
                  ,TO_SITE                      
                  ,INCOTERMS                      
                  ,FROM_SITE                      
                  ,BOD_ID                      
                  ,TRANSPORT_MODE                      
                  ,MEASURE                      
                  ,YYYYMMDD                       
                  ,SUM(QTY) AS QTY                      -- sum                      
             FROM (                      
                    SELECT                        
                          B.DIVISION_ID                      
                         ,B.PLAN_START_YYYYMMDD                      -- plan주의 월요일  ,dbo.FN_GET_BUCKET_YYYYMMDD(0)                       
                         ,B.PLAN_TYPE                      
                         ,B.SEQ                        
                         ,B.OPERATION_GROUP                      
                         ,A.PROJECT_CODE                      
                         ,B.ITEM_ID                      
                         ,B.TO_SITE                       
                         ,A.INCOTERMS                     
                         ,B.FROM_SITE                      
                         ,B.BOD_ID                       
                         ,B.TRANSPORT_MODE                      
                         ,B.MEASURE                       
                         ,B.YYYYMMDD                      
                         ,A.ALLOCATION_QTY         AS QTY                      
                     FROM DBO.SSP_PLN_SHIPMENT_PLAN_PEGGING A WITH (NOLOCK)                       
                     LEFT OUTER JOIN  SSP_PLN_SHIPMENT_PLAN B WITH (NOLOCK)                 
                     ON 0 = 0              
                     AND A.DIVISION_ID           = B.DIVISION_ID                      
                     AND A.PLAN_START_YYYYMMDD   = B.PLAN_START_YYYYMMDD              
                     AND A.PLAN_TYPE             = B.PLAN_TYPE                        
                     AND A.SEQ                   = B.SEQ                             
                     AND A.ORDER_ID              = B.ORDER_ID               
                  --   AND A.ENG_DEMAND_ID         = B.ENG_DEMAND_ID              
                     AND A.DIVISION_ID           = @p_division_id              -- '81'               
                     AND A.PLAN_START_YYYYMMDD   = @p_plan_start_yyyymmdd      -- '20180409'                     
                     AND A.PLAN_TYPE             = @p_plan_type                -- 'PR'               
                     AND A.SEQ                   = @p_seq                      -- '9'              
                     AND B.MEASURE               = 'SHIP_REQ'             
                     AND B.SEMI_YN               = 'N'                          
                     AND A.ENG_DEMAND_ID        <> 'UNPEGGING' 
--                     AND B.ENG_DEMAND_ID        <> 'UNPEGGING'                                     
                     WHERE 1 = 1                      
                       AND A.DIVISION_ID         = @p_division_id              -- '81'                
                       AND A.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd      -- '20180409'                      
     AND A.PLAN_TYPE           = @p_plan_type                -- 'PR'                
                       AND A.SEQ                 = @p_seq                      -- '9'               
                       AND B.DIVISION_ID         is not null              
                       AND B.SEMI_YN               = 'N'                          
                       AND A.ENG_DEMAND_ID        <> 'UNPEGGING' 
                       AND B.YYYYMMDD            = A.LPST       
--                       AND B.ENG_DEMAND_ID        <> 'UNPEGGING'  
                ) X                      
             GROUP BY                      
                   DIVISION_ID                      
                  ,PLAN_START_YYYYMMDD                      
                  ,PLAN_TYPE                      
                  ,SEQ                      
                  ,PROJECT_CODE                      
                  ,ITEM_ID                      
                  ,TO_SITE                      
                  ,INCOTERMS                      
                  ,FROM_SITE                      
                  ,TRANSPORT_MODE                      
                  ,BOD_ID                      
                  ,MEASURE                      
                  ,YYYYMMDD                      
                  ;                   
              
            -------------------------------------------------------------------------------------------------------------                       
            -- 1-2. SHIP_PLAN 입력 (FG)                      
            -------------------------------------------------------------------------------------------------------------               
            INSERT INTO #tmp_SSP_ANL_SHIPMENT_PLAN_FG                      
                  (                      
                   DIVISION_ID                      
                  ,PLAN_START_YYYYMMDD                      
                  ,PLAN_TYPE                      
                  ,SEQ                      
                  ,OPERATION_GROUP                      
                  ,PROJECT_CODE                      
                  ,ITEM_ID                      
                  ,TO_SITE                      
                  ,INCOTERMS                      
                  ,FROM_SITE                      
                  ,BOD_ID                      
                  ,TRANSPORT_MODE                      
                  ,MEASURE                      
                  ,YYYYMMDD                      
                  ,QTY                      
                  )                      
            SELECT DIVISION_ID                      
                  ,PLAN_START_YYYYMMDD                      
                  ,PLAN_TYPE               
                  ,SEQ                      
                  ,MAX(OPERATION_GROUP)                      
                  ,ISNULL(PROJECT_CODE,'-') AS PROJECT_CODE              
                  ,ITEM_ID                      
                  ,TO_SITE                      
                  ,INCOTERMS                      
                  ,FROM_SITE                      
                  ,BOD_ID                      
                  ,TRANSPORT_MODE                      
                  ,MEASURE                      
                  ,YYYYMMDD                       
                  ,SUM(QTY) AS QTY                      -- sum                      
             FROM (                      
                                 
                   SELECT      
                          B.DIVISION_ID                      
                         ,B.PLAN_START_YYYYMMDD                      -- plan주의 월요일  ,dbo.FN_GET_BUCKET_YYYYMMDD(0)                       
                         ,B.PLAN_TYPE                      
                         ,B.SEQ                        
                         ,B.OPERATION_GROUP       
                         ,A.PROJECT_CODE                      
                         ,B.ITEM_ID                      
                         ,B.TO_SITE                       
                         ,A.INCOTERMS                    
                         ,B.FROM_SITE                      
                         ,B.BOD_ID                       
                         ,B.TRANSPORT_MODE                      
                         ,B.MEASURE               
                         ,B.YYYYMMDD                      
                         ,A.ALLOCATION_QTY         AS QTY                      
                     FROM DBO.SSP_PLN_SHIPMENT_PLAN_PEGGING A WITH (NOLOCK)                       
                     LEFT OUTER JOIN  SSP_PLN_SHIPMENT_PLAN B WITH (NOLOCK)                 
                     ON 0 = 0              
                    AND A.DIVISION_ID           = B.DIVISION_ID                      
                     AND A.PLAN_START_YYYYMMDD   = B.PLAN_START_YYYYMMDD              
                     AND A.PLAN_TYPE             = B.PLAN_TYPE                        
                     AND A.SEQ                   = B.SEQ                             
                     AND A.ORDER_ID              = B.ORDER_ID               
                  --   AND A.ENG_DEMAND_ID         = B.ENG_DEMAND_ID              
                     AND A.DIVISION_ID           = @p_division_id              -- '81'               
                     AND A.PLAN_START_YYYYMMDD   = @p_plan_start_yyyymmdd      -- '20180409'                     
                     AND A.PLAN_TYPE             = @p_plan_type                -- 'PR'               
                     AND A.SEQ                   = @p_seq                      -- '9'              
                     AND B.MEASURE               = 'SHIP_PLAN'                       
                     AND B.SEMI_YN               = 'N'                                       
                     AND A.ENG_DEMAND_ID        <> 'UNPEGGING' 
--                     AND B.ENG_DEMAND_ID        <> 'UNPEGGING' 
                     WHERE 1 = 1                      
                       AND A.DIVISION_ID         = @p_division_id         -- '81'                
                       AND A.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd      -- '20180409'                      
                       AND A.PLAN_TYPE           = @p_plan_type                -- 'PR'                
                       AND A.SEQ                 = @p_seq                      -- '9'               
                       AND B.DIVISION_ID         is not null              
                       AND A.ENG_DEMAND_ID        <> 'UNPEGGING' 
--                       AND B.ENG_DEMAND_ID        <> 'UNPEGGING' 
                ) X                      
             GROUP BY                      
                   DIVISION_ID                      
                  ,PLAN_START_YYYYMMDD                      
                  ,PLAN_TYPE              
                  ,SEQ                      
                  ,ISNULL(PROJECT_CODE,'-')               
                  ,ITEM_ID                      
                  ,TO_SITE                      
                  ,INCOTERMS                      
                  ,FROM_SITE                      
                  ,TRANSPORT_MODE                      
                  ,BOD_ID                      
                  ,MEASURE                      
                  ,YYYYMMDD                      
                  ;                   
              
      
      
            -------------------------------------------------------------------------------------------------------------                      
            -- 2-1. WH_IN 입력 FG : SSP_ANL_PROBLEM_REPORT_PEGGING      
            -------------------------------------------------------------------------------------------------------------    
            INSERT INTO #tmp_SSP_ANL_SHIPMENT_PLAN_FG                      
                 (                      
                   DIVISION_ID                      
                  ,PLAN_START_YYYYMMDD                      
                  ,PLAN_TYPE                      
                  ,SEQ                      
                  ,OPERATION_GROUP                      
                  ,PROJECT_CODE                      
                  ,ITEM_ID                      
                  ,TO_SITE                      
                  ,INCOTERMS                      
                  ,FROM_SITE                      
                  ,BOD_ID                      
                  ,TRANSPORT_MODE                      
                  ,MEASURE                      
                  ,YYYYMMDD                      
                  ,QTY                                        
                  )         
            SELECT division_id                      
                  ,plan_start_yyyymmdd                      
                  ,plan_type                      
                  ,seq                      
                  ,operation_group      
                  ,project_code             
                  ,item_id                      
                  ,to_site                      
                  ,incoterms                      
                  ,from_site                      
                  ,'-'                      AS bod_id                      
                  ,'-'                      AS transport_mode                      
                  ,'WH_IN'                  AS measure               
                  ,yyyymmdd                     
                  ,sum(qty)                 AS qty               
                  FROM (                      
                                   
                        SELECT a.division_id      
                              ,a.plan_start_yyyymmdd      
                              ,a.plan_type      
                              ,a.seq      
                              ,a.operation_group      
                              ,dbo.fn_scm_split(a.eng_demand_id,2,'::')                             AS project_code      
                              ,a.item_id      
                              ,a.to_site      
                              ,dbo.fn_scm_split(dbo.fn_scm_split(a.stock_plan_lot_id,2,'::'),2,'~') AS incoterms       
                              --,dbo.fn_scm_split(a.eng_demand_id,7,'::')                             AS from_site      
                              ,dbo.fn_scm_split(a.stock_plan_lot_id,5,'::')                         AS from_site    
                              ,(CASE WHEN dbo.fn_scm_split(a.stock_plan_lot_id,4,'::') < @p_plan_start_yyyymmdd THEN @p_plan_start_yyyymmdd      
                                     ELSE dbo.fn_scm_split(a.stock_plan_lot_id,4,'::')      
                                     END)                                                           AS yyyymmdd      
                              ,a.planned_qty                            AS qty      
                          from ssp_anl_problem_report_pegging a with (nolock)      
                          where 1=1      
                            AND a.division_id            = @p_division_id              -- N'81'          --      
                            AND a.plan_start_yyyymmdd    = @p_plan_start_yyyymmdd      -- N'20180521'    --      
                            AND a.plan_type              = @p_plan_type                -- N'PR'          --      
                            AND a.seq                    = @p_seq                      -- N'1'           --            
                            AND a.stock_plan_lot_id   LIKE N'INT%'      
         
                      ) X                      
             GROUP BY                      
                   division_id           
                  ,plan_start_yyyymmdd             
                  ,plan_type                      
                  ,seq        
                  ,operation_group                    
                  ,project_code                 
                  ,item_id                      
                  ,to_site                      
                  ,incoterms                      
                  ,from_site                      
                  ,yyyymmdd                      
                  ;        
      
            -------------------------------------------------------------------------------------------------------------                      
            -- 2-2. WH_IN 입력 FG : SSP_PLN_SHIPMENT_PLAN_PEGGING      
            -------------------------------------------------------------------------------------------------------------                       
            INSERT INTO #tmp_SSP_ANL_SHIPMENT_PLAN_FG                      
                 (                      
                   DIVISION_ID                      
                  ,PLAN_START_YYYYMMDD                      
                  ,PLAN_TYPE                      
                  ,SEQ                      
                  ,OPERATION_GROUP                      
                  ,PROJECT_CODE                      
                  ,ITEM_ID                      
                  ,TO_SITE                      
                  ,INCOTERMS                      
                  ,FROM_SITE                      
                  ,BOD_ID                      
                  ,TRANSPORT_MODE                      
                  ,MEASURE                      
                  ,YYYYMMDD                      
                  ,QTY                                        
                  )                      
            SELECT DIVISION_ID                      
                  ,PLAN_START_YYYYMMDD                      
                  ,PLAN_TYPE                      
                  ,SEQ                      
                  ,MAX(OPERATION_GROUP)                      
                  ,ISNULL(PROJECT_CODE,'-') AS PROJECT_CODE              
                  ,ITEM_ID                      
                  ,TO_SITE                      
                  ,INCOTERMS                      
                  ,FROM_SITE                      
                  ,'-'   AS BOD_ID                      
                  ,'-'   AS TRANSPORT_MODE                      
                  ,MEASURE                      
                  ,YYYYMMDD                     
                  ,SUM(QTY)                      
                  FROM (                      
                                       
              
                        SELECT                        
                          B.DIVISION_ID                      
                         ,B.PLAN_START_YYYYMMDD                      -- plan주의 월요일  ,dbo.FN_GET_BUCKET_YYYYMMDD(0)                       
                         ,B.PLAN_TYPE                      
                         ,B.SEQ                        
                         ,B.OPERATION_GROUP                      
                         ,A.PROJECT_CODE                      
                         ,B.ITEM_ID                      
                         ,B.TO_SITE                       
                         ,A.INCOTERMS           
                         ,B.FROM_SITE                      
                         ,B.BOD_ID                       
                         ,B.TRANSPORT_MODE                      
                         ,'WH_IN' AS MEASURE               
                         ,CONVERT(NVARCHAR(8), B.END_TIME,112) AS YYYYMMDD               
                         ,A.ALLOCATION_QTY         AS QTY                      
                     FROM DBO.SSP_PLN_SHIPMENT_PLAN_PEGGING A WITH (NOLOCK)   
                     LEFT OUTER JOIN  SSP_PLN_SHIPMENT_PLAN B WITH (NOLOCK)                 
                     ON 0 = 0              
                     AND A.DIVISION_ID           = B.DIVISION_ID                      
                     AND A.PLAN_START_YYYYMMDD   = B.PLAN_START_YYYYMMDD              
                     AND A.PLAN_TYPE             = B.PLAN_TYPE                        
                     AND A.SEQ                   = B.SEQ                             
                     AND A.ORDER_ID              = B.ORDER_ID               
                  --   AND A.ENG_DEMAND_ID         = B.ENG_DEMAND_ID              
                     AND A.DIVISION_ID           = @p_division_id              -- '81'               
                     AND A.PLAN_START_YYYYMMDD   = @p_plan_start_yyyymmdd      -- '20180409'                     
                     AND A.PLAN_TYPE             = @p_plan_type                -- 'PR'               
                     AND A.SEQ                   = @p_seq                      -- '9'              
                     AND B.MEASURE               = 'SHIP_PLAN'                       
                     AND B.SEMI_YN               = 'N'                          
                     AND A.ENG_DEMAND_ID        <> 'UNPEGGING' 
--                     AND B.ENG_DEMAND_ID        <> 'UNPEGGING'          
              WHERE 1 = 1                      
                       AND A.DIVISION_ID         = @p_division_id              -- '81'                
                       AND A.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd      -- '20180409'                      
                       AND A.PLAN_TYPE           = @p_plan_type                -- 'PR'                
                       AND A.SEQ                 = @p_seq                      -- '9'               
                       AND B.DIVISION_ID         is not null            
                       AND A.ENG_DEMAND_ID        <> 'UNPEGGING' 
--                       AND B.ENG_DEMAND_ID        <> 'UNPEGGING'   
              
                      ) X                      
             GROUP BY                      
                   DIVISION_ID                      
                  ,PLAN_START_YYYYMMDD                      
                  ,PLAN_TYPE                      
                  ,SEQ                      
                  ,PROJECT_CODE                 
                  ,ISNULL(PROJECT_CODE,'-')               
                  ,ITEM_ID                      
                  ,TO_SITE                      
                  ,INCOTERMS                      
                  ,FROM_SITE                      
                  ,MEASURE                      
                  ,YYYYMMDD                      
                  ;                      
                                      
                    
            -------------------------------------------------------------------------------------------------------------                       
          -- 7. ALLOCATION 추가        
          -------------------------------------------------------------------------------------------------------------             
           INSERT INTO #tmp_SSP_ANL_SHIPMENT_PLAN_FG                      
                 (                      
                   DIVISION_ID                      
                  ,PLAN_START_YYYYMMDD                      
                  ,PLAN_TYPE                      
                  ,SEQ                      
                  ,OPERATION_GROUP                      
                  ,PROJECT_CODE                      
                  ,ITEM_ID                      
                  ,TO_SITE                      
                  ,INCOTERMS                      
                  ,FROM_SITE                      
                  ,BOD_ID                      
                  ,MEASURE                      
    ,YYYYMMDD                      
                  ,QTY                      
                  )             
                 SELECT A.DIVISION_ID                                   --DIVISION_ID                    
                       ,A.PLAN_START_YYYYMMDD                           --PLAN_START_YYYYMMDD            
                       ,A.PLAN_TYPE                                     --PLAN_TYPE                      
                       ,A.SEQ                                           --SEQ                            
                       ,A.OPERATION_GROUP                               --OPERATION_GROUP                
                       ,A.PROJECT_CODE                                   --PROJECT_CODE                   
                       ,A.ITEM_ID                                       --ITEM_ID                        
                       ,A.SALES_SITE_ID         AS TO_SITE              --TO_SITE                        
                       ,A.INCOTERMS                                     --INCOTERMS                      
                       ,'-'                     AS FROM_SITE            --FROM_SITE                      
                       ,'-'                     AS BOD_ID               --BOD_ID                         
                       ,'ALLOCATION'            AS MEASURE              --MEASURE                        
                       ,A.YYYYMMDD                                      --YYYYMMDD                       
                       ,SUM(ISNULL(A.ALLOCATION_QTY,0))  AS QTY         --QTY                            
                  FROM SSP_PLN_ALLOCATION A  WITH(NOLOCK)               
                 WHERE 0 = 0        
                   AND A.DIVISION_ID         = @p_division_id              -- '81'                
                   AND A.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd      -- '20180409'          
                   AND A.PLAN_TYPE           = @p_plan_type                -- 'PR'                
                   AND A.SEQ                 = @p_seq                      -- '9'               
                  GROUP BY            
                       DIVISION_ID            
                      ,PLAN_START_YYYYMMDD            
                      ,PLAN_TYPE            
                      ,SEQ            
                      ,OPERATION_GROUP            
                      ,PROJECT_CODE            
                      ,ITEM_ID            
                      ,SALES_SITE_ID            
                      ,INCOTERMS            
                      ,FROM_SITE        
                      ,YYYYMMDD            
            -------------------------------------------------------------------------------------------------------------                         
            -- 5. MKT_FCST 입력 FG                         
           -------------------------------------------------------------------------------------------------------------   
            IF OBJECT_ID('tempdb..#TMP_SSP_PLN_NET_DEMAND_V') IS NOT NULL                        
              DROP TABLE #TMP_SSP_PLN_NET_DEMAND_V   
  
             
           SELECT                          
                     A.DIVISION_ID                        
                    ,A.PLAN_START_YYYYMMDD  
                    ,A.PLAN_TYPE                        
                    ,A.SEQ                          
                    ,A.MASTER_ID  
                    ,A.ENG_PLAN_ID                           
                    ,ISNULL(A.PROJECT_CODE,'-')  AS PROJECT_CODE  
                    ,A.ITEM_ID                        
                    ,A.SALES_SITE_ID                        
                    ,A.INCOTERMS                        
                    ,A.YYYYMMDD                        
                    ,A.SPLIT_QTY      
                INTO #TMP_SSP_PLN_NET_DEMAND_V                    
                FROM SCP_PLN_NET_DEMAND_V A  WITH (NOLOCK)       
               WHERE ISNUMERIC(A.SEQ)        = 1                      
                 AND A.DIVISION_ID           = @p_division_id                        
                 AND A.PLAN_START_YYYYMMDD   = @p_plan_start_yyyymmdd                        
                 AND A.PLAN_TYPE             = @p_plan_type                        
                 AND A.SEQ                   = @p_seq                        
                 AND A.master_id             = @p_master_id                
                 AND A.eng_plan_id           = @p_engine_plan_id     
  
             
                                   
                      
             INSERT INTO #tmp_SSP_ANL_SHIPMENT_PLAN_FG                        
                 (                        
                   DIVISION_ID                        
                  ,PLAN_START_YYYYMMDD                        
                  ,PLAN_TYPE                        
                  ,SEQ                        
                  ,OPERATION_GROUP                       
                  ,PROJECT_CODE                        
                  ,ITEM_ID                        
                  ,TO_SITE                        
                  ,INCOTERMS                        
                  ,FROM_SITE                        
                  ,BOD_ID                        
                  ,MEASURE                        
                  ,YYYYMMDD        
                  --,ORIGIN_FROM_DIVISION_ID  
                  --,ORIGIN_TO_DIVISION_ID    
                  --,ELECTRODE_TYPE                  
                  ,QTY                        
                  )                        
                        
              SELECT                          
                     A.DIVISION_ID                        
                    ,A.PLAN_START_YYYYMMDD                                      AS PLAN_START_YYYYMMDD                        
                    ,A.PLAN_TYPE                        
                    ,A.SEQ   
                    ,C.OPERATION_GROUP   AS OPERATION_GROUP                            
                    ,A.PROJECT_CODE                
                    ,A.ITEM_ID                        
                    ,A.SALES_SITE_ID                        
                    ,A.INCOTERMS                        
                    , '-'                                                       AS FROM_SITE                        
                    , '-'                                                       AS BOD_ID                        
                    ,'MKT_FCST'                                                 AS MEASURE                        
                    ,A.YYYYMMDD                        
                    ,SUM(A.SPLIT_QTY)                        
                FROM #TMP_SSP_PLN_NET_DEMAND_V A  WITH (NOLOCK)       
                 INNER JOIN DBO.SCP_MST_FINAL_ITEM_V C  WITH (NOLOCK)         
                         ON A.DIVISION_ID  = @p_division_id     
                        AND A.ITEM_ID      = C.ITEM_ID                        
               WHERE ISNUMERIC(A.SEQ)        = 1                      
                 AND A.DIVISION_ID           = @p_division_id                        
                 AND A.PLAN_START_YYYYMMDD   = @p_plan_start_yyyymmdd                        
                 AND A.PLAN_TYPE             = @p_plan_type                        
                 AND A.SEQ                   = @p_seq                        
                 AND A.master_id             = @p_master_id                
                 AND A.eng_plan_id           = @p_engine_plan_id         
                                
--                 AND ISNUMERIC(A.seq)        = 1                      
            GROUP BY                        
                     A.DIVISION_ID                        
                    ,A.PLAN_START_YYYYMMDD                  
                    ,A.PLAN_TYPE                        
                    ,A.SEQ                          
                    ,C.OPERATION_GROUP                          
                    ,A.PROJECT_CODE  
                    ,A.ITEM_ID                        
                    ,A.SALES_SITE_ID                        
                    ,A.INCOTERMS                        
                    ,A.YYYYMMDD                        
                    ;                        
                        
                      
            -------------------------------------------------------------------------------------------------------------                       
            -- 5. SHIP_PLAN_AMEND 입력 FG                       
            -------------------------------------------------------------------------------------------------------------                       
                 INSERT INTO #tmp_SSP_ANL_SHIPMENT_PLAN_FG                      
                 (                      
                   DIVISION_ID                      
                  ,PLAN_START_YYYYMMDD                      
                  ,PLAN_TYPE                      
                  ,SEQ                      
                  ,OPERATION_GROUP           
                  ,PROJECT_CODE                      
                  ,ITEM_ID                      
                  ,TO_SITE                      
                  ,INCOTERMS                      
                  ,FROM_SITE                      
                  ,BOD_ID                      
                  ,MEASURE                      
                  ,YYYYMMDD                      
                  ,QTY                      
                  )                                    
              SELECT DIVISION_ID                              --DIVISION_ID                      
                  ,PLAN_START_YYYYMMDD                               --PLAN_START_YYYYMMDD              
                  ,PLAN_TYPE                                         --PLAN_TYPE                        
                  ,SEQ                                               --SEQ                              
                  ,OPERATION_GROUP                                   --OPERATION_GROUP                  
                  ,ISNULL(PROJECT_CODE,'-') AS PROJECT_CODE          --PROJECT_CODE                     
                  ,ITEM_ID                                           --ITEM_ID                          
                  ,TO_SITE                                           --TO_SITE                          
                  ,INCOTERMS                                         --INCOTERMS                        
                  ,FROM_SITE                                         --FROM_SITE                        
                  ,BOD_ID                                            --BOD_ID                           
                 ,'SHIP_PLAN_AMEND' AS MEASURE                       --MEASURE                          
                  ,YYYYMMDD                                          --YYYYMMDD                         
                  ,QTY                                               --QTY                              
              FROM #tmp_SSP_ANL_SHIPMENT_PLAN_FG  WITH(NOLOCK)                
              WHERE MEASURE ='SHIP_PLAN'                
                          
          -------------------------------------------------------------------------------------------------------------                       
          -- 6. WH_IN_TOTAL 입력 FG  = SUM(WH_IN) + INTRANSIT                     
          -------------------------------------------------------------------------------------------------------------                       
          /*        
                 INSERT INTO #tmp_SSP_ANL_SHIPMENT_PLAN_FG                      
                 (                      
                   DIVISION_ID                      
                  ,PLAN_START_YYYYMMDD                      
                  ,PLAN_TYPE                      
                  ,SEQ                      
                  ,OPERATION_GROUP                      
                  ,PROJECT_CODE                      
                  ,ITEM_ID                      
                  ,TO_SITE                      
                  ,INCOTERMS                      
                  ,FROM_SITE                      
                  ,BOD_ID                      
                  ,MEASURE                      
                  ,YYYYMMDD                      
                  ,QTY                      
                  )             
              SELECT DIVISION_ID                                  --DIVISION_ID                    
                    ,PLAN_START_YYYYMMDD                          --PLAN_START_YYYYMMDD            
                    ,PLAN_TYPE                                    --PLAN_TYPE                      
                    ,SEQ                   --SEQ                            
                    ,OPERATION_GROUP                              --OPERATION_GROUP                
                    ,PROJECT_CODE                                 --PROJECT_CODE                   
                    ,ITEM_ID                                      --ITEM_ID                        
                    ,TO_SITE                                      --TO_SITE                        
                    ,INCOTERMS                                    --INCOTERMS                      
                    ,'-'                  AS FROM_SITE            --FROM_SITE                      
                    ,'-'         AS BOD_ID               --BOD_ID                         
                    ,'WH_IN_TOTAL'        AS MEASURE              --MEASURE                        
                    ,YYYYMMDD                                     --YYYYMMDD                       
                    ,SUM(ISNULL(QTY,0))                           --QTY                            
               FROM #tmp_SSP_ANL_SHIPMENT_PLAN_FG  WITH(NOLOCK)                
              WHERE MEASURE IN ('WH_IN','INTRANSIT')            
              GROUP BY            
                    DIVISION_ID            
                   ,PLAN_START_YYYYMMDD            
                   ,PLAN_TYPE            
                   ,SEQ            
                   ,OPERATION_GROUP            
                   ,PROJECT_CODE            
                   ,ITEM_ID            
                   ,TO_SITE            
                   ,INCOTERMS            
                   ,YYYYMMDD            
                   ;            
           */                    
        
                  
        
          -------------------------------------------------------------------------------------------------------------                       
          -- 7-1. MKT_FCST OR INTRANSIT OR WH_IN_TOTAL 이 존재하지 않는 경우, 해당 MEASURE를 0으로 추가            
          --      (비고) FROM SITE TO SITE 출하계획이 존재하지 않는 경우, 관련 MEASURE가 미생성되는 것은 허용함            
          --             ( WH_IN, SHIP_REQ, SHIP_PLAN, SHIP_PLAN_AMEND )            
          -------------------------------------------------------------------------------------------------------------         
            
               
                      
          DECLARE @X_INT        INT   =1;            
          DECLARE @X_MEASURE    NVARCHAR(100);            
            
          WHILE @X_INT < 3            
          BEGIN            
                        
               SELECT @X_MEASURE = ( CASE @X_INT WHEN 1 THEN 'MKT_FCST'             
                                                 WHEN 2 THEN 'ALLOCATION'             
                                                -- WHEN 3 THEN 'WH_IN_TOTAL'             
                                     END);          
                                                 
                              
                INSERT INTO #tmp_SSP_ANL_SHIPMENT_PLAN_FG                      
                     (                      
                       DIVISION_ID                      
                      ,PLAN_START_YYYYMMDD                      
                      ,PLAN_TYPE                      
                      ,SEQ                      
                      ,OPERATION_GROUP                      
                      ,PROJECT_CODE                      
                      ,ITEM_ID                      
                      ,TO_SITE                      
                      ,INCOTERMS                      
                      ,FROM_SITE                      
                      ,BOD_ID                      
                      ,MEASURE                      
                      ,YYYYMMDD              
                      --,ORIGIN_FROM_DIVISION_ID  
                      --,ORIGIN_TO_DIVISION_ID  
                      --,ELECTRODE_TYPE            
                      ,QTY                      
                      )                           
               SELECT                  
                      SUB.DIVISION_ID                   --DIVISION_ID                      
                     ,SUB.PLAN_START_YYYYMMDD           --PLAN_START_YYYYMMDD              
                     ,SUB.PLAN_TYPE                     --PLAN_TYPE                        
                     ,SUB.SEQ                           --SEQ                              
                     ,SUB.OPERATION_GROUP               --OPERATION_GROUP                  
                     ,SUB.PROJECT_CODE                  --PROJECT_CODE                     
                     ,SUB.ITEM_ID                       --ITEM_ID                          
                     ,SUB.TO_SITE                       --TO_SITE                          
                     ,SUB.INCOTERMS                     --INCOTERMS                        
                     ,SUB.FROM_SITE                     --FROM_SITE                        
                     ,SUB.BOD_ID                        --BOD_ID                           
                     ,SUB.MEASURE            --MEASURE                          
                     ,SUB.YYYYMMDD                      --YYYYMMDD        
                     --,SUB.ORIGIN_FROM_DIVISION_ID  
                     --,SUB.ORIGIN_TO_DIVISION_ID  
                     --,SUB.ELECTRODE_TYPE                     
                     ,0   AS QTY        --QTY                              
                FROM               
                    (              
                        SELECT               
                               DIVISION_ID                      
                              ,PLAN_START_YYYYMMDD                      
                              ,PLAN_TYPE                      
                              ,SEQ                      
                              ,OPERATION_GROUP                      
                              ,PROJECT_CODE                      
                              ,ITEM_ID                      
                              ,TO_SITE                      
                              ,INCOTERMS                      
                              ,'-'        AS FROM_SITE                      
                              ,'-'        AS BOD_ID                      
                              ,@X_MEASURE AS MEASURE             
                              ,YYYYMMDD            
                              --,ORIGIN_FROM_DIVISION_ID  
                              --,ORIGIN_TO_DIVISION_ID  
                              --,ELECTRODE_TYPE   
                         FROM              
                              (  -- 56 DAYS            
                                 SELECT C.BASIS_YYYYMMDD AS YYYYMMDD             
                                   FROM SCM_SYS_CALENDAR_M    C WITH(NOLOCK)               
                                  WHERE 1=1            
                                    AND C.BASIS_YYYYMMDD >= @p_plan_start_yyyymmdd             
                                    AND C.BASIS_YYYYMMDD <  CONVERT(VARCHAR,DATEADD(D,56,CONVERT(DATETIME,@p_plan_start_yyyymmdd ,112)),112)  -- 8주(56일)            
                              ) A,              
                              (              
                                 SELECT DISTINCT             
                                        DIVISION_ID                      
                                       ,PLAN_START_YYYYMMDD                      
                                       ,PLAN_TYPE                      
                                       ,SEQ                      
                                       ,OPERATION_GROUP                      
                                       ,PROJECT_CODE                      
                                       ,ITEM_ID                      
                                       ,TO_SITE                      
                                       ,INCOTERMS            
                                       --,ORIGIN_FROM_DIVISION_ID  
                                       --,ORIGIN_TO_DIVISION_ID  
                                       --,ELECTRODE_TYPE             
                                  FROM #tmp_SSP_ANL_SHIPMENT_PLAN_FG X WITH(NOLOCK)              
                                 WHERE 1=1            
                              ) B              
                    ) SUB              
                    WHERE 1=1              
                      AND NOT EXISTS (              
                                       SELECT 'X'              
                                         FROM #tmp_SSP_ANL_SHIPMENT_PLAN_FG Z WITH(NOLOCK)              
                                        WHERE 1=1              
                                          AND Z.DIVISION_ID              = SUB.DIVISION_ID                      
                                          AND Z.PLAN_START_YYYYMMDD      = SUB.PLAN_START_YYYYMMDD                  
                                          AND Z.PLAN_TYPE                = SUB.PLAN_TYPE                        
                                          AND Z.SEQ    = SUB.SEQ                              
                                          AND Z.OPERATION_GROUP          = SUB.OPERATION_GROUP                  
                                          AND Z.PROJECT_CODE             = SUB.PROJECT_CODE                     
                                          AND Z.ITEM_ID                  = SUB.ITEM_ID                          
                                          AND Z.TO_SITE                  = SUB.TO_SITE                          
                                          AND Z.INCOTERMS                = SUB.INCOTERMS                        
                                          AND Z.MEASURE                  = @X_MEASURE                      
                                          AND Z.YYYYMMDD                 = SUB.YYYYMMDD              
                                          --AND Z.ORIGIN_FROM_DIVISION_ID  = SUB.ORIGIN_FROM_DIVISION_ID         
                                          --AND Z.ORIGIN_TO_DIVISION_ID    = SUB.ORIGIN_TO_DIVISION_ID         
                                          --AND Z.ELECTRODE_TYPE           = SUB.ELECTRODE_TYPE               
                                     );            
                                                                   
                        
               SET @X_INT = @X_INT + 1;            
                
           END            
                                      
  
          -------------------------------------------------------------------------------------------------------------                       
          -- 7-2. MEASURE별 BUCKET일자별 0 채우기                  
          -------------------------------------------------------------------------------------------------------------                                
            
            INSERT INTO #tmp_SSP_ANL_SHIPMENT_PLAN_FG                      
                 (                      
                   DIVISION_ID                      
                  ,PLAN_START_YYYYMMDD                      
                  ,PLAN_TYPE                      
                  ,SEQ                      
                  ,OPERATION_GROUP                      
                  ,PROJECT_CODE                      
                  ,ITEM_ID                      
                  ,TO_SITE                      
                  ,INCOTERMS                      
                  ,FROM_SITE                      
                  ,BOD_ID                      
                  ,MEASURE                      
                  ,YYYYMMDD                
                  --,ORIGIN_FROM_DIVISION_ID  
                  --,ORIGIN_TO_DIVISION_ID  
                  --,ELECTRODE_TYPE      
                  ,QTY                      
                  )                           
           SELECT                  
                  SUB.DIVISION_ID                   --DIVISION_ID                      
                 ,SUB.PLAN_START_YYYYMMDD           --PLAN_START_YYYYMMDD              
                 ,SUB.PLAN_TYPE                     --PLAN_TYPE                        
                 ,SUB.SEQ                           --SEQ                              
                 ,SUB.OPERATION_GROUP               --OPERATION_GROUP                  
                 ,SUB.PROJECT_CODE                  --PROJECT_CODE                     
                 ,SUB.ITEM_ID         --ITEM_ID                          
                 ,SUB.TO_SITE                       --TO_SITE                          
                 ,SUB.INCOTERMS                     --INCOTERMS                        
                 ,SUB.FROM_SITE                     --FROM_SITE                        
                 ,SUB.BOD_ID                        --BOD_ID           
                 ,SUB.MEASURE                       --MEASURE                          
                 ,SUB.YYYYMMDD                      --YYYYMMDD         
                 --,SUB.ORIGIN_FROM_DIVISION_ID  
                 --,SUB.ORIGIN_TO_DIVISION_ID  
                 --,SUB.ELECTRODE_TYPE                             
                 ,0   AS QTY                        --QTY                              
            FROM               
                (              
                    SELECT               
                           DIVISION_ID                      
                          ,PLAN_START_YYYYMMDD                      
                          ,PLAN_TYPE                      
                          ,SEQ                      
                          ,OPERATION_GROUP                      
                          ,PROJECT_CODE                      
                          ,ITEM_ID                      
                          ,TO_SITE                      
                          ,INCOTERMS                      
                          ,FROM_SITE                      
                          ,BOD_ID                      
                          ,MEASURE             
                          ,YYYYMMDD        
                          --,ORIGIN_FROM_DIVISION_ID  
                          --,ORIGIN_TO_DIVISION_ID  
                          --,ELECTRODE_TYPE                 
                     FROM              
                          (  -- 56 DAYS            
                             SELECT C.BASIS_YYYYMMDD AS YYYYMMDD                
                               FROM SCM_SYS_CALENDAR_M    C WITH(NOLOCK)               
                             WHERE 1=1            
                                AND C.BASIS_YYYYMMDD >= @p_plan_start_yyyymmdd             
--                                AND C.BASIS_YYYYMMDD <  CONVERT(VARCHAR,DATEADD(D,364,CONVERT(DATETIME,@p_plan_start_yyyymmdd,112)),112)   
                                AND C.BASIS_YYYYMMDD <  CONVERT(VARCHAR,DATEADD(D,56,CONVERT(DATETIME,@p_plan_start_yyyymmdd ,112)),112)  -- 8주(56일)           
                          ) A,              
                          (              
                             SELECT DISTINCT             
                                    DIVISION_ID                      
                                   ,PLAN_START_YYYYMMDD                      
                                   ,PLAN_TYPE                      
                                   ,SEQ                      
                                   ,OPERATION_GROUP                      
                                   ,PROJECT_CODE                      
                                   ,ITEM_ID                      
                                   ,TO_SITE                      
                                   ,INCOTERMS                      
                                   ,FROM_SITE                      
                                   ,BOD_ID                      
                                   ,MEASURE     
                                   --,ORIGIN_FROM_DIVISION_ID  
                                   --,ORIGIN_TO_DIVISION_ID  
                                   --,ELECTRODE_TYPE                      
                              FROM #tmp_SSP_ANL_SHIPMENT_PLAN_FG X WITH(NOLOCK)              
                             WHERE 1=1            
                          ) B              
                ) SUB              
                WHERE 1=1              
                  AND NOT EXISTS (              
                                   SELECT 'X'              
                                     FROM #tmp_SSP_ANL_SHIPMENT_PLAN_FG Z WITH(NOLOCK)              
                                    WHERE 1=1              
                                      AND Z.DIVISION_ID              = SUB.DIVISION_ID                      
                                      AND Z.PLAN_START_YYYYMMDD      = SUB.PLAN_START_YYYYMMDD                  
                                      AND Z.PLAN_TYPE                = SUB.PLAN_TYPE                        
                                      AND Z.SEQ          = SUB.SEQ                              
                                      AND Z.OPERATION_GROUP          = SUB.OPERATION_GROUP                  
                                      AND Z.PROJECT_CODE             = SUB.PROJECT_CODE                     
                                      AND Z.ITEM_ID                  = SUB.ITEM_ID                                                              
                                      AND Z.TO_SITE                  = SUB.TO_SITE                          
                                      AND Z.INCOTERMS                = SUB.INCOTERMS                        
                                      AND Z.FROM_SITE                = SUB.FROM_SITE                        
                                      AND Z.BOD_ID                   = SUB.BOD_ID                           
                                      AND Z.MEASURE                  = SUB.MEASURE                          
                                      AND Z.YYYYMMDD                 = SUB.YYYYMMDD        
                                      --AND Z.ORIGIN_FROM_DIVISION_ID  = SUB.ORIGIN_FROM_DIVISION_ID         
                                      --AND Z.ORIGIN_TO_DIVISION_ID    = SUB.ORIGIN_TO_DIVISION_ID         
                                      -- AND Z.ELECTRODE_TYPE          = SUB.ELECTRODE_TYPE                       
                                 );              
                                   
          -------------------------------------------------------------------------------------------------------------                       
          -- 8. BALANCE 계산값 생성             
          -------------------------------------------------------------------------------------------------------------             
          -------------------------------------------------------------------------------------------------------------                       
          -- 8.1 BALANCE에 사용할 MEASURE 임시테이블 생성  ('MKT_FCST','ALLOCATION') OR ('MKT_FCST','WH_IN')  = ('MKT_FCST','WH_IN','ALLOCATION')
          ------------------------------------------------------------------------------------------------------------
             SELECT   DISTINCT            
                    DIVISION_ID                      
                  ,PLAN_START_YYYYMMDD                      
                  ,PLAN_TYPE                      
                  ,SEQ              
                  ,OPERATION_GROUP          
                  ,PROJECT_CODE                      
                  ,ITEM_ID                      
                  ,TO_SITE                      
                  ,INCOTERMS            
                  ,YYYYMMDD         
                  --,ORIGIN_FROM_DIVISION_ID  
                  --,ORIGIN_TO_DIVISION_ID  
                  --,ELECTRODE_TYPE       
              INTO #Z
              FROM #tmp_SSP_ANL_SHIPMENT_PLAN_FG WITH(NOLOCK)             
              WHERE 1=1             
                AND MEASURE            IN ('MKT_FCST','ALLOCATION')            
                GROUP BY            
                    DIVISION_ID                      
                  ,PLAN_START_YYYYMMDD                      
                  ,PLAN_TYPE                      
                  ,SEQ                      
                  ,PROJECT_CODE                      
                  ,ITEM_ID                      
                  ,TO_SITE                      
                  ,INCOTERMS            
                  ,YYYYMMDD     
                  ,OPERATION_GROUP   
                  --,ORIGIN_FROM_DIVISION_ID  
                  --,ORIGIN_TO_DIVISION_ID  
                  --,ELECTRODE_TYPE         



         SELECT   DISTINCT            
                    DIVISION_ID                      
                  ,PLAN_START_YYYYMMDD                      
                  ,PLAN_TYPE                      
                  ,SEQ              
                  ,OPERATION_GROUP          
                  ,PROJECT_CODE                      
                  ,ITEM_ID                      
                  ,TO_SITE                      
                  ,INCOTERMS            
                  ,YYYYMMDD         
                  --,ORIGIN_FROM_DIVISION_ID  
                  --,ORIGIN_TO_DIVISION_ID  
                  --,ELECTRODE_TYPE       
              INTO #Y
              FROM #tmp_SSP_ANL_SHIPMENT_PLAN_FG WITH(NOLOCK)             
              WHERE 1=1             
                AND MEASURE            IN ('MKT_FCST','WH_IN')            
                GROUP BY            
                    DIVISION_ID                      
                  ,PLAN_START_YYYYMMDD                      
                  ,PLAN_TYPE                      
                  ,SEQ                      
                  ,PROJECT_CODE                      
                  ,ITEM_ID                      
                  ,TO_SITE                      
                  ,INCOTERMS            
                  ,YYYYMMDD     
                  ,OPERATION_GROUP   

          -------------------------------------------------------------------------------------------------------------                       
          -- 8.2 BALANCE에 사용할 #BOH 임시테이블 생성
          ------------------------------------------------------------------------------------------------------------
          /*
                select @x_site_type = site_type    
                  from scm_mst_site     s with(nolock)    
                 where 1=1    
                   and s.division_id    = @p_division_id    
                   and s.scm_site_id    = @p_scm_site_id    
                   ;    
     
               if @x_site_type = 'PLANT'    
               begin    
    
                    select @x_boh_qty = sum(isnull(psi_boh_qty,0))    
                      from ssp_pln_plant_onhand with(nolock)    
                     where division_id               = @p_division_id    
                       and stock_type    NOT IN ( 'FOR_STOCKPLAN','FORMING','FORMED','CHARING','CHAR','A_MOVE_WH','A_OUT_WH')   --셀 활성화진행중 이후 특성,창고재고 제외   
                       and plan_start_yyyymmdd       = @p_plan_start_yyyymmdd    
                       and plan_type                 = @p_plan_type    
                       and seq                       = @p_plan_seq    
                       and site_id                   = @p_scm_site_id    
                       and item_id                   = @p_item_id    
                       and yyyymmdd                  = @p_yyyymmdd    
                       ;    
    
        
               end    
            else    
               begin    
    
          
                    select @x_boh_qty = sum(isnull(psi_boh_qty,0))    
                      from ssp_pln_sales_onhand with(nolock)    
                     where division_id               = @p_division_id    
                       and plan_start_yyyymmdd       = @p_plan_start_yyyymmdd    
                       and plan_type                 = @p_plan_type    
                       and seq                       = @p_plan_seq    
                       and site_id                   = @p_scm_site_id    
                       and item_id                   = @p_item_id    
                       and yyyymmdd                  = @p_yyyymmdd    
                       ;    
        
               end      
                */
           SELECT DIVISION_ID    
                 ,PLAN_START_YYYYMMDD    
                 ,PLAN_TYPE    
                 ,SEQ    
                 ,SITE_ID    
                 ,ITEM_ID    
                 ,PSI_BOH_QTY     
             INTO #BOH 
             FROM SSP_PLN_SALES_ONHAND  WITH (NOLOCK)      
            WHERE 0 = 0
              and division_id               = @P_DIVISION_ID           --'81'           
--              and stock_type                NOT IN ( 'FOR_STOCKPLAN','FORMING','FORMED','CHARING','CHAR','A_MOVE_WH','A_OUT_WH')  --셀 활성화진행중 이후 특성,창고재고 제외
              and plan_start_yyyymmdd       = @P_PLAN_START_YYYYMMDD   --'20180416'     
              and plan_type                 = @P_PLAN_TYPE             --'PR'           
              and seq                       = @P_SEQ                   --1              
              and yyyymmdd                  = @P_PLAN_START_YYYYMMDD   --계획시작일    

          -------------------------------------------------------------------------------------------------------------                       
          -- 8.3 BALANCE 입력
          ------------------------------------------------------------------------------------------------------------          
          -- BALANCE 속도 때문에 CLUSTERED INDEX 추가 함.          
            --DROP INDEX #tmp_SSP_ANL_SHIPMENT_PLAN_FG.IX01_#tmp_SSP_ANL_SHIPMENT_PLAN_FG          
            CREATE CLUSTERED INDEX [IX01_#tmp_SSP_ANL_SHIPMENT_PLAN_FG] ON #tmp_SSP_ANL_SHIPMENT_PLAN_FG          
            (          
              DIVISION_ID           
             ,PLAN_START_YYYYMMDD          
             ,PLAN_TYPE          
             ,SEQ          
             --,OPERATION_GROUP          
             ,PROJECT_CODE          
             ,ITEM_ID          
             ,TO_SITE          
             ,INCOTERMS      
             --,FROM_SITE          
             --,BOD_ID          
             ,MEASURE          
             ,YYYYMMDD          
              );           
              -- 00:27초         
            --PRINT N'BALANCE 계산전';          

                                  
              INSERT INTO #tmp_SSP_ANL_SHIPMENT_PLAN_FG                  
                      (                      
                        DIVISION_ID                      
                        ,PLAN_START_YYYYMMDD                      
                        ,PLAN_TYPE                      
                        ,SEQ                      
                        ,OPERATION_GROUP                      
                        ,PROJECT_CODE                      
                        ,ITEM_ID                      
                        ,TO_SITE                      
                        ,INCOTERMS                      
                        ,FROM_SITE                      
                        ,BOD_ID                      
                        ,MEASURE                      
                        ,YYYYMMDD               
                        --,ORIGIN_FROM_DIVISION_ID  
                        --,ORIGIN_TO_DIVISION_ID  
                        --,ELECTRODE_TYPE          
                        ,QTY                      
                        )               
                SELECT              
                        Z.DIVISION_ID                      
                       ,Z.PLAN_START_YYYYMMDD                      
                       ,Z.PLAN_TYPE                      
                       ,Z.SEQ                      
                       ,Z.OPERATION_GROUP                                                    
                       ,Z.PROJECT_CODE                      
                       ,Z.ITEM_ID                      
                       ,Z.TO_SITE                      
                       ,Z.INCOTERMS            
                       ,'-' AS FROM_SITE          
                       ,'-' AS BOD_ID          
                       ,'BALANCE' AS MEASURE          
                       ,Z.YYYYMMDD             
                       --,Z.ORIGIN_FROM_DIVISION_ID  
                       --,Z.ORIGIN_TO_DIVISION_ID  
                       --,Z.ELECTRODE_TYPE   
                       ,( SELECT            
                               ISNULL( SUM(CASE MEASURE WHEN 'MKT_FCST'   THEN -1 * ISNULL(QTY,0)            
                                                        WHEN 'ALLOCATION' THEN      ISNULL(QTY,0)            
                                                 ELSE 0.0            
                                     END),0)             
                           FROM #tmp_SSP_ANL_SHIPMENT_PLAN_FG X WITH(NOLOCK)             
                         WHERE 1=1            
                           AND X.DIVISION_ID          = Z.DIVISION_ID            
                           AND X.PLAN_START_YYYYMMDD  = Z.PLAN_START_YYYYMMDD                     
                           AND X.PLAN_TYPE            = Z.PLAN_TYPE            
                           AND X.SEQ                  = Z.SEQ            
                           AND X.PROJECT_CODE         = Z.PROJECT_CODE             
                           AND X.ITEM_ID              = Z.ITEM_ID            
                           AND X.TO_SITE              = Z.TO_SITE            
                           AND X.INCOTERMS            = Z.INCOTERMS            
                           AND X.MEASURE              IN ('MKT_FCST','ALLOCATION')            
                           --AND X.ORIGIN_FROM_DIVISION_ID   = Z.ORIGIN_FROM_DIVISION_ID        
                           --AND X.ORIGIN_TO_DIVISION_ID     = Z.ORIGIN_TO_DIVISION_ID        
                           --AND X.ELECTRODE_TYPE            = Z.ELECTRODE_TYPE      
                           AND X.YYYYMMDD            <= Z.YYYYMMDD            
                         )     AS PSI_BOH_QTY             
                 FROM #Z AS Z WITH(NOLOCK)             
                WHERE 1=1 
                AND Z.YYYYMMDD   < CONVERT(VARCHAR,DATEADD(D,56,CONVERT(DATETIME,@p_plan_start_yyyymmdd ,112)),112)  -- 8주(56일) 추가  
    
          -------------------------------------------------------------------------------------------------------------                         
          -- 8.3 BALANCE 입력(소형(40)일 경우)  월별 BALANCE 적용
          ------------------------------------------------------------------------------------------------------------  
          /*
          IF @p_division_id = '40'  -- MEASURE ='BALANCE'
          BEGIN 
                UPDATE XX        
                SET XX.QTY   = ISNULL((YY.ALLOCATION_SUM_MONTH + MKT_FCST_SUM_MONTH), 0)
                FROM #tmp_SSP_ANL_SHIPMENT_PLAN_FG XX with (nolock)        
                INNER JOIN  (        
                               SELECT DISTINCT DIVISION_ID,PLAN_START_YYYYMMDD,PLAN_TYPE,SEQ        
                                  ,PROJECT_CODE,ITEM_ID,TO_SITE,INCOTERMS,'BALANCE' AS MEASURE,YYYYMMDD        
                               ,(SUM((CASE WHEN MEASURE ='ALLOCATION' THEN ISNULL(QTY,0) ELSE 0 END))  OVER (PARTITION BY PROJECT_CODE,ITEM_ID,TO_SITE,INCOTERMS,SUBSTRING(YYYYMMDD,1,6) ORDER BY PROJECT_CODE,ITEM_ID,TO_SITE,INCOTERMS,YYYYMMDD))       AS ALLOCATION_SUM_MONTH
                               ,(SUM((CASE WHEN MEASURE ='MKT_FCST'   THEN ISNULL(QTY,0) ELSE 0 END))  OVER (PARTITION BY PROJECT_CODE,ITEM_ID,TO_SITE,INCOTERMS,SUBSTRING(YYYYMMDD,1,6) ORDER BY PROJECT_CODE,ITEM_ID,TO_SITE,INCOTERMS,YYYYMMDD) * -1)  AS MKT_FCST_SUM_MONTH
                               FROM #tmp_SSP_ANL_SHIPMENT_PLAN_FG X with (nolock)         
                               WHERE 0 = 0       
                               AND  X.MEASURE in ('ALLOCATION','MKT_FCST')  
                           ) YY        
                       ON  XX.DIVISION_ID             = YY.DIVISION_ID                
                       AND XX.PLAN_START_YYYYMMDD     = YY.PLAN_START_YYYYMMDD        
                       AND XX.PLAN_TYPE               = YY.PLAN_TYPE                  
                       AND XX.SEQ                     = YY.SEQ                        
                       AND XX.PROJECT_CODE            = YY.PROJECT_CODE               
                       AND XX.ITEM_ID                 = YY.ITEM_ID              
                       AND XX.TO_SITE                 = YY.TO_SITE              
                       AND XX.INCOTERMS               = YY.INCOTERMS           
                       AND XX.YYYYMMDD                = YY.YYYYMMDD        
                       AND XX.MEASURE                 = YY.MEASURE        -- 'MKT_FCST_SUM_MONTH'
                       AND XX.MEASURE                 = 'BALANCE'
          END  -- @p_division_id = '40'                     
          */       
          -------------------------------------------------------------------------------------------------------------                       
          -- 8.4 WH_IN_BALANCE 입력(to site기준의 BOH + 특정일자까지 누적 Fcst qty * (-1) + 특정일자까지 누적 WH_IN total 누적수량 )          
          -------------------------------------------------------------------------------------------------------------      
          -- 기존의 RTF Balance는 Allocation에 대해서 Balance를 표현하였으며,WH_in total수량에 대한 Balance는 BOH( 기초재고)를 감안하여, Fcst매출을 차감한 실물기준 재고예상을 보여주는 것입니다.
            -- FN_GET_SSP_ANL_BOH_QTY](division_id ,plan_start_yyyymmdd, plan_type, seq, to_site , item_id,from_yyyymmdd) , 1) as int) as boh            
          IF @p_division_id <>  '40'  -- MEASURE ='BALANCE'
          BEGIN         
              INSERT INTO #tmp_SSP_ANL_SHIPMENT_PLAN_FG                  
                      (                      
                        DIVISION_ID                      
                        ,PLAN_START_YYYYMMDD                      
                        ,PLAN_TYPE                      
                        ,SEQ                      
                        ,OPERATION_GROUP                      
                        ,PROJECT_CODE                      
                        ,ITEM_ID                      
                        ,TO_SITE                      
                        ,INCOTERMS                      
                        ,FROM_SITE                      
                        ,BOD_ID                      
                        ,MEASURE                      
                        ,YYYYMMDD               
                        --,ORIGIN_FROM_DIVISION_ID  
                        --,ORIGIN_TO_DIVISION_ID  
                        --,ELECTRODE_TYPE          
                        ,QTY                      
                        )  
                SELECT              
                              Y.DIVISION_ID                      
                              ,Y.PLAN_START_YYYYMMDD                      
                              ,Y.PLAN_TYPE                      
                              ,Y.SEQ                      
                              ,Y.OPERATION_GROUP                                                    
                              ,Y.PROJECT_CODE                      
                              ,Y.ITEM_ID                      
                              ,Y.TO_SITE                      
                              ,Y.INCOTERMS            
                              ,'-' AS FROM_SITE          
                              ,'-' AS BOD_ID          
                              ,'WH_IN_BALANCE' AS MEASURE          
                              ,Y.YYYYMMDD             
                              --,Y.ORIGIN_FROM_DIVISION_ID  
                              --,Y.ORIGIN_TO_DIVISION_ID  
                              --,Y.ELECTRODE_TYPE   
                              ,( SELECT            
                                      ISNULL( SUM(CASE MEASURE WHEN 'MKT_FCST'  THEN -1 * ISNULL(QTY,0)            
                                                                WHEN 'WH_IN'    THEN      ISNULL(QTY,0)            
                                                        ELSE 0.0            
                                            END),0)             
                                  FROM #tmp_SSP_ANL_SHIPMENT_PLAN_FG X WITH(NOLOCK)             
                                WHERE 1=1            
                                  AND X.DIVISION_ID          = Y.DIVISION_ID            
                                  AND X.PLAN_START_YYYYMMDD  = Y.PLAN_START_YYYYMMDD                     
                                  AND X.PLAN_TYPE            = Y.PLAN_TYPE            
                                  AND X.SEQ                  = Y.SEQ            
                                  AND X.PROJECT_CODE         = Y.PROJECT_CODE             
                                  AND X.ITEM_ID              = Y.ITEM_ID            
                                  AND X.TO_SITE              = Y.TO_SITE            
                                  AND X.INCOTERMS            = Y.INCOTERMS            
                                  AND X.MEASURE              IN ('MKT_FCST','WH_IN')            
                                  --AND X.ORIGIN_FROM_DIVISION_ID   = Y.ORIGIN_FROM_DIVISION_ID        
                                  --AND X.ORIGIN_TO_DIVISION_ID     = Y.ORIGIN_TO_DIVISION_ID        
                                  --AND X.ELECTRODE_TYPE            = Y.ELECTRODE_TYPE      
                                  AND X.YYYYMMDD             <= Y.YYYYMMDD            
                                )  + ISNULL(BOH.PSI_BOH_QTY,0) AS PSI_BOH_QTY     
                          FROM #Y AS Y WITH (NOLOCK)     
                          LEFT OUTER JOIN #BOH AS BOH WITH (NOLOCK) 
                    ON Y.DIVISION_ID          = BOH.DIVISION_ID    
                                      AND Y.PLAN_START_YYYYMMDD  = BOH.PLAN_START_YYYYMMDD    
                                      AND Y.PLAN_TYPE            = BOH.PLAN_TYPE    
                                      AND Y.SEQ                  = BOH.SEQ    
                                      AND Y.TO_SITE              = BOH.SITE_ID    
                                      AND Y.ITEM_ID              = BOH.ITEM_ID    
                        WHERE 1=1
                        AND Y.YYYYMMDD   < CONVERT(VARCHAR,DATEADD(D,56,CONVERT(DATETIME,@p_plan_start_yyyymmdd ,112)),112)  -- 8주(56일) 추가  
            END            
           -------------------------------------------------------------------------------------------------------------                         
            -- 10. MKT_FCST ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID,ELECTRODE_TYPE UPDATE  
            -------------------------------------------------------------------------------------------------------------  
                       
             UPDATE X  
               SET X.ORIGIN_FROM_DIVISION_ID = ISNULL(Y.DIVISION_ID,'')  
              FROM #tmp_SSP_ANL_SHIPMENT_PLAN_FG X WITH (NOLOCK)  
              LEFT OUTER JOIN DBO.SCM_MST_SITE Y  WITH (NOLOCK)       -- from   PLANT_SITE_ID  
                           ON 0 = 0
--                          AND Y.SITE_TYPE   = 'PLANT'      
                          AND (CASE WHEN X.DIVISION_ID = 'EE' THEN 0 ELSE X.DIVISION_ID END ) = (CASE WHEN X.DIVISION_ID = 'EE' THEN 0 ELSE Y.DIVISION_ID END )
                          AND Y.SCM_SITE_ID  = REPLACE(X.FROM_SITE,'-S','')
                          AND Y.VALID_YN ='Y'     
  
            UPDATE X  
               SET X.ORIGIN_TO_DIVISION_ID = ISNULL(Y.DIVISION_ID,'')  
              FROM #tmp_SSP_ANL_SHIPMENT_PLAN_FG X WITH (NOLOCK)  
              LEFT OUTER JOIN DBO.SCM_MST_SITE Y  WITH (NOLOCK)       -- to   SALES_SITE_ID  
                           ON 0 = 0
--                          AND Y.SITE_TYPE   = 'PLANT'      
                          AND (CASE WHEN X.DIVISION_ID = 'EE' THEN 0 ELSE X.DIVISION_ID END ) = (CASE WHEN X.DIVISION_ID = 'EE' THEN 0 ELSE Y.DIVISION_ID END )
                          AND Y.SCM_SITE_ID  = REPLACE(X.TO_SITE,'-S','')
                          AND Y.VALID_YN ='Y'        
                            
            UPDATE X  
               SET X.ELECTRODE_TYPE = ISNULL(Y.ELECTRODE_TYPE,''), X.OPERATION_GROUP = Y.OPERATION_GROUP  
              FROM #tmp_SSP_ANL_SHIPMENT_PLAN_FG X WITH (NOLOCK)  
              INNER JOIN DBO.SCP_MST_FINAL_ITEM_V Y  WITH (NOLOCK)         
                    ON 0 = 0      
                   AND X.DIVISION_ID      = @p_division_id
                   AND X.ITEM_ID          = Y.ITEM_ID        
                                                                         
          -------------------------------------------------------------------------------------------------------------                         
          -- 11. SSP_ANL_SHIPMENT_PLAN_FG 삭제                         
          -------------------------------------------------------------------------------------------------------------              
            --DELETE FROM SSP_ANL_SHIPMENT_PLAN_FG                            
            --WHERE DIVISION_ID = @p_division_id AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd AND PLAN_TYPE = @p_plan_type AND SEQ = @p_seq        
            -- 소형(40) 삭제시 속도 계선.
            -- SELECT @@ROWCOUNT  
            -- 1000 [1043::PR::2][07:23]
            -- 10000 [1043::PR::2][10:12]
            -- 100000 [1043::PR::2][05:38]
            WHILE @@ROWCOUNT > 0  -- 상단의 UPDATE문 @@ROWCOUNT
            BEGIN
              DELETE TOP (10000)
              FROM SSP_ANL_SHIPMENT_PLAN_FG                            
              WHERE DIVISION_ID = @p_division_id AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd AND PLAN_TYPE = @p_plan_type AND SEQ = @p_seq        
            END
                               
                                
           -------------------------------------------------------------------------------------------------------------                         
          -- 12. SSP_ANL_SHIPMENT_PLAN_FG 입력                         
          -------------------------------------------------------------------------------------------------------------                    
          INSERT INTO /* PR_SSP_ANL_SHIPMENT_PLAN_FG */                        
                      dbo.SSP_ANL_SHIPMENT_PLAN_FG                        
                     (                        
                        DIVISION_ID                        
                       ,PLAN_START_YYYYMMDD                        
                       ,PLAN_TYPE                        
                       ,SEQ                        
                       ,BIZ_TYPE  --OPERATION_GROUP                        
                       ,PROJECT_CODE                        
                       ,ITEM_ID                        
                       ,TO_SITE                        
                       ,INCOTERMS                        
                       ,FROM_SITE                        
                       ,BOD_ID                        
--                       ,TRANSPORT_MODE                        
                       ,MEASURE                        
                       ,YYYYMMDD            
                       ,ORIGIN_FROM_DIVISION_ID  
                       ,ORIGIN_TO_DIVISION_ID    
                       ,ELECTRODE_TYPE                                     
                       ,QTY                        
                       ,CREATED_BY                        
                       ,CREATION_DATE                        
                       ,LAST_UPDATED_BY                        
                       ,LAST_UPDATE_DATE                        
                       )                        
                    SELECT              
                           DIVISION_ID                        
                          ,PLAN_START_YYYYMMDD                        
                          ,PLAN_TYPE                        
                          ,SEQ                        
                          ,ISNULL(OPERATION_GROUP, '')   
                          ,PROJECT_CODE                        
                          ,ITEM_ID                        
                          ,TO_SITE                        
--                          ,MAX(ISNULL(INCOTERMS, '-'))  AS INCOTERMS           
                          ,ISNULL(INCOTERMS, '-')  AS INCOTERMS            
                          ,FROM_SITE                        
                          ,ISNULL(BOD_ID,'-')                        
--                          ,TRANSPORT_MODE                        
                          ,MEASURE                        
                          ,YYYYMMDD           
                          ,ORIGIN_FROM_DIVISION_ID  
                          ,ORIGIN_TO_DIVISION_ID    
                          ,ELECTRODE_TYPE                
                          ,SUM(QTY) AS QTY                        
                          ,@v_batch_user AS CREATED_BY                        
                          ,GETDATE()     AS CREATION_DATE                        
                          ,@v_batch_user AS LAST_UPDATED_BY                        
                          ,GETDATE()     AS LAST_UPDATED_BY                        
                      FROM #tmp_SSP_ANL_SHIPMENT_PLAN_FG WITH (NOLOCK)                        
                     WHERE 1=1                        
                     AND YYYYMMDD < CONVERT(VARCHAR,DATEADD(D,56,CONVERT(DATETIME,@p_plan_start_yyyymmdd ,112)),112)  -- 8주(56일) 추가       
                     GROUP BY DIVISION_ID                        
                          ,PLAN_START_YYYYMMDD                        
                          ,PLAN_TYPE                        
                          ,SEQ                        
                          ,ISNULL(OPERATION_GROUP, '')   
                          ,PROJECT_CODE                        
                          ,ITEM_ID        
                          ,TO_SITE                        
                          ,ISNULL(INCOTERMS, '-')        
                          ,FROM_SITE                        
                          ,ISNULL(BOD_ID,'-')                       
                          ,MEASURE                        
                          ,YYYYMMDD           
                          ,ORIGIN_FROM_DIVISION_ID  
                          ,ORIGIN_TO_DIVISION_ID    
                          ,ELECTRODE_TYPE                            
                    
                    
                  
        -----------------------------------------------------------                    
        -- 실행 Logic END --                    
        -----------------------------------------------------------                    
        --IF @@TRANCOUNT > 0                    
        --  BEGIN                    
        --    COMMIT TRAN TX_FG;                    
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
      --    ROLLBACK TRAN TX_FG                    
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
     SET @v_exec_time  =  REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +     
                          REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))     
       
    -- 종료 LOG          
    SET @v_log_type = N'END';          
    SET @v_log_message = N'########## END of procedure ##########';          
    SET @v_description = N'[' + @p_master_id + ']['+@p_engine_plan_id+'][' + @v_exec_time + ']';                    
    SET @d_event_date =  SYSDATETIME()  ;                    
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
             
        
      
