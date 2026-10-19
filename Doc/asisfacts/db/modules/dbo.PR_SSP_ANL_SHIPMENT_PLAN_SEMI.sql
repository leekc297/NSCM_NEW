     
/*    
 * Program ID   : PR_SSP_ANL_SHIPMENT_PLAN_SEMI      
 * Description  : PR_SSP_ANL_CREATE_DATA 에서 호출함.    
 * OutTable     :    
 * Execute      :     
EXEC PR_SSP_ANL_SHIPMENT_PLAN_SEMI     @p_division_id         ='81'      
                                     , @p_plan_start_yyyymmdd ='20180617'       
                                     , @p_plan_type           ='SP'      --                                     
                                     , @p_seq                 ='1'    
                                     , @p_engine_plan_id      ='103007::SP::1'    
                                     , @p_user_id             = 'KTH'    
  
 * Program History    
 *===================================================================================================    
 *   Date       In Charge      Description    
 *===================================================================================================    
 * 2018.06.12   LTW         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트  
 * 2018.06.14   KTH         ORG_DEMAND_ID 조인 부분 삭제  
 * 2018.06.18   KTH         CONVERT(VARCHAR,DATEADD(D,56,CONVERT(DATETIME,@p_plan_start_yyyymmdd ,112)),112)  -- 8주(56일) 추가  
 * 2018.06.28   KTH         전극일 경우만 cell환산수량 반영하도록 수정 ( X.OPERATION_GROUP ='E') , MEASURE '0' 채움 로직 변경
 * 2018.07.16   KTH         전극 SCP 반영(ORIGIN_FROM_DIVISION_ID,ORIGIN_TO_DIVISION_ID,ELECTRODE_TYPE) 추가
                            파라미터 변경 (PLN과 동일하게 변경), MEASURE를 0으로 추가 로직 변경
 * 2018.07.18   KTH         전극일때 환산비율 로직 수정 
 * 2018.07.27   KTH         INCOTERMS 수정(BOD_ID -> DEMAND_ID)
 * 2018.09.03   KTH         환산비율로직 수정
 * 2018.10.05   KTH         변경된 환산비율 로직 반영(dbo.FN_GET_ELEC_CELL_PER_METER 참조)
 * 2018.10.08   KTH         환산비율 로직 변경 반영(SCP_MST_FINAL_ITEM)
 * 2018.11.21   KTH         'SHIP_REQ' 로직변경(YYYYMMDD = LPST) 추가
 */    
    
CREATE PROCEDURE [dbo].[PR_SSP_ANL_SHIPMENT_PLAN_SEMI]    
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
)     
AS    
  BEGIN    
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;    
    SET NOCOUNT ON;    
    SET XACT_ABORT ON;    
    SET ANSI_WARNINGS OFF;    
    
    -- LOG 용 변수 설정    
    DECLARE @v_batch_user   NVARCHAR(150) = N'ssp_batch';      
    SET     @v_batch_user = @p_user_id    
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SSP_ANL_SHIPMENT_PLAN_SEMI';    
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...    
    DECLARE @n_log_count    INTEGER = 0;    
    DECLARE @v_log_message  NVARCHAR(1000);    
    DECLARE @v_description  NVARCHAR(500);        
    DECLARE @v_table_id     NVARCHAR(150) = N'SSP_ANL_SHIPMENT_PLAN_SEMI';   
    DECLARE @d_event_date   DATETIME;    
    
  -- 시작 LOG    
    SET @v_log_type = N'START';    
    SET @v_log_message = N'########## Start of procedure ##########';    
    SET @v_description = @v_program_name + ':' + N' SHIPMENT_PLAN INSERT LOGIC';    
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
--        BEGIN TRAN TX_SH_SEMI    
                    -------------------------------------------------------------------------------------------------------------     
          -- 0. temp 테이블 생성 : Measure까지 생성후 마지막에 한번에 입력하기 위해서    
          -------------------------------------------------------------------------------------------------------------     
          IF OBJECT_ID('tempdb..#tmp_SSP_ANL_SHIPMENT_PLAN_SEMI') IS NOT NULL                  
              DROP TABLE #tmp_SSP_ANL_SHIPMENT_PLAN_SEMI    
    
            CREATE TABLE #tmp_SSP_ANL_SHIPMENT_PLAN_SEMI(    
               DIVISION_ID              nvarchar(030)    
              ,PLAN_START_YYYYMMDD      nvarchar(08)    
              ,PLAN_TYPE                nvarchar(050)    
              ,SEQ                      INT    
              ,OPERATION_GROUP          nvarchar(010)    
              ,ITEM_ID                  nvarchar(050)    
              ,FROM_SITE                nvarchar(030)    
              ,TO_SITE                  nvarchar(030)    
              ,BOD_ID                   nvarchar(150)    
              ,TRANSPORT_MODE           nvarchar(050)     
              ,MEASURE                  nvarchar(100)    
              ,YYYYMMDD                 nvarchar(008) 
              ,ORIGIN_FROM_DIVISION_ID  nvarchar(030) 
              ,ORIGIN_TO_DIVISION_ID    nvarchar(030) 
              ,ELECTRODE_TYPE           nvarchar(030) 
              ,QTY                      numeric (20,10)    
            );    
    
    
                
            /*    
            --SHIP PLAN SEMI MEASURE    
            SELECT * FROM SCM_MST_SHEET_MEASURE T WHERE T.PROGRAM_ID ='SCP0010' order by sheet_name, sort_order_no    
    
            SCP0010       CELL         SHIP_REQ                     Ship Req                      1      셀 출하요청 수량    
            SCP0010       CELL         SHIP_PLAN                     Ship Plan                      2      셀 출하계획 수량    
            SCP0010       CELL         SHIP_PLAN_AMEND               Ship Plan Amend                3      셀 출하계획 Amend수량    
            SCP0010       CELL         CHAR_COMPLETED_QTY           Char. Complete Qty            4      셀 특성완료일자별 수량    
            SCP0010       CELL         INVENTORY                     Inventory                      5      INVENTORY    
    
    
            SCP0010       ELECTRODE     SHIP_REQ                     Ship Req                      1      전극 출하요청 수량    
            SCP0010       ELECTRODE     SHIP_REQ_CELL_QTY             Ship Req(Cell Qty)            2      전극 출하요청 수량(CELL)    
            SCP0010       ELECTRODE     SHIP_PLAN                     Ship Plan                      3      전극 출하계획 수량    
            SCP0010       ELECTRODE     SHIP_PLAN_CELL_QTY           Ship Plan(Cell Qty)            4      전극 출하계획 수량(CELL)    
            SCP0010       ELECTRODE     SHIP_PLAN_AMEND               Ship Plan Amend                5      전극 출하계획 수량 Amed 수량    
            SCP0010       ELECTRODE     SHIP_PLAN_AMEND_CELL_QTY     Ship Plan Amend(Cell Qty)      6      전극 출하계획 수량 Amed 수량(CELL)    
            SCP0010       ELECTRODE     COMPLETED_QTY                 Complete Qty                  7      전극 생산완료 수량    
            SCP0010       ELECTRODE     INVENTORY                     Inventory                      8      INVENTORY    
                
    
           --     1. Inventory = BOH       - Ship plan + Complate QTY     
         --      2. Inventory = Inventory - Ship plan + Complate QTY     
            */    
    
    
            -------------------------------------------------------------------------------------------------------------     
            -- 1. SHIP_REQ 입력 (SEMI)  : 셀 출하요청 수량    
            -------------------------------------------------------------------------------------------------------------     

            
              INSERT INTO #tmp_SSP_ANL_SHIPMENT_PLAN_SEMI    
                  (    
                   DIVISION_ID    
                  ,PLAN_START_YYYYMMDD    
                  ,PLAN_TYPE    
                  ,SEQ    
                  ,OPERATION_GROUP    
                  ,ITEM_ID    
                  ,FROM_SITE    
                  ,TO_SITE    
                  ,BOD_ID    
                  ,TRANSPORT_MODE    
                  ,MEASURE    
                  ,YYYYMMDD    
                  ,ORIGIN_FROM_DIVISION_ID
                  ,ORIGIN_TO_DIVISION_ID
                  ,ELECTRODE_TYPE
                  ,QTY    
                  )    

            SELECT DIVISION_ID    
                  ,PLAN_START_YYYYMMDD    
                  ,PLAN_TYPE    
                  ,SEQ    
                  ,MAX(OPERATION_GROUP)    
                  ,ITEM_ID    
                  ,FROM_SITE    
                  ,TO_SITE    
                  ,BOD_ID    
                  ,TRANSPORT_MODE    
                  ,MEASURE    
                  ,YYYYMMDD     
                  ,ORIGIN_FROM_DIVISION_ID
                  ,ORIGIN_TO_DIVISION_ID
                  ,ELECTRODE_TYPE
                  ,SUM(QTY) AS QTY                         
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
                       ,B.INCOTERMS
                       ,B.FROM_SITE            
                       ,B.BOD_ID             
                       ,B.TRANSPORT_MODE            
                       ,B.MEASURE   -- 출하계획            
                       ,B.YYYYMMDD            
                       ,B.ORIGIN_FROM_DIVISION_ID
                       ,B.ORIGIN_TO_DIVISION_ID
                       ,B.ELECTRODE_TYPE
                       ,A.ALLOCATION_QTY         AS QTY            
                   FROM DBO.SSP_PLN_SHIPMENT_PLAN_PEGGING A WITH (NOLOCK)             
                   LEFT OUTER JOIN  SSP_PLN_SHIPMENT_PLAN B WITH (NOLOCK)       
                   ON 0 = 0    
                   AND A.DIVISION_ID           = B.DIVISION_ID            
                   AND A.PLAN_START_YYYYMMDD   = B.PLAN_START_YYYYMMDD    
                   AND A.PLAN_TYPE             = B.PLAN_TYPE              
                   AND A.SEQ                   = B.SEQ                   
                   AND A.ORDER_ID              = B.ORDER_ID     
                   AND A.DIVISION_ID           = @p_division_id             
                   AND A.PLAN_START_YYYYMMDD   = @p_plan_start_yyyymmdd               
                   AND A.PLAN_TYPE             = @p_plan_type               
                   AND A.SEQ                   = @p_seq                     
                   AND B.MEASURE               = 'SHIP_REQ'             
                   AND B.SEMI_YN = 'Y'                             
                   WHERE 1 = 1            
                     AND A.DIVISION_ID         = @p_division_id              
                     AND A.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd                 
                     AND A.PLAN_TYPE           = @p_plan_type                
                     AND A.SEQ                 = @p_seq      
                     AND B.YYYYMMDD            = A.LPST                       
                     AND B.DIVISION_ID        is not null    
                  ) X    
             GROUP BY    
                   DIVISION_ID    
                  ,PLAN_START_YYYYMMDD    
                  ,PLAN_TYPE    
                  ,SEQ    
                  ,ITEM_ID    
                  ,FROM_SITE    
                  ,TO_SITE    
                  ,BOD_ID    
                  ,TRANSPORT_MODE    
                  ,MEASURE    
                  ,YYYYMMDD   
                  ,ORIGIN_FROM_DIVISION_ID
                  ,ORIGIN_TO_DIVISION_ID
                  ,ELECTRODE_TYPE 
                  ;    
    


            -------------------------------------------------------------------------------------------------------------     
            -- 2. SHIP_PLAN 입력 (SEMI)   : 셀 출하계획 수량    
            -------------------------------------------------------------------------------------------------------------   

              INSERT INTO #tmp_SSP_ANL_SHIPMENT_PLAN_SEMI    
                  (    
                   DIVISION_ID    
                  ,PLAN_START_YYYYMMDD    
                  ,PLAN_TYPE    
                  ,SEQ    
                  ,OPERATION_GROUP    
                  ,ITEM_ID    
                  ,FROM_SITE    
                  ,TO_SITE    
                  ,BOD_ID    
                  ,TRANSPORT_MODE    
                  ,MEASURE    
                  ,YYYYMMDD   
                  ,ORIGIN_FROM_DIVISION_ID
                  ,ORIGIN_TO_DIVISION_ID
                  ,ELECTRODE_TYPE 
                  ,QTY    
                  )    
            SELECT DIVISION_ID    
                  ,PLAN_START_YYYYMMDD    
                  ,PLAN_TYPE    
                  ,SEQ    
                  ,MAX(OPERATION_GROUP)    
                  ,ITEM_ID    
                  ,FROM_SITE    
                  ,TO_SITE    
                  ,BOD_ID    
                  ,TRANSPORT_MODE    
                  ,MEASURE    
                  ,YYYYMMDD     
                  ,ORIGIN_FROM_DIVISION_ID
                  ,ORIGIN_TO_DIVISION_ID
                  ,ELECTRODE_TYPE
                  ,SUM(QTY) AS QTY                         
             FROM (    
                    SELECT      
                           A.DIVISION_ID    
                          ,A.PLAN_START_YYYYMMDD        -- plan주의 월요일  ,dbo.FN_GET_BUCKET_YYYYMMDD(0)     
                          ,A.PLAN_TYPE    
                          ,A.SEQ      
                          ,A.OPERATION_GROUP    
                          ,A.ITEM_ID    
                          ,A.FROM_SITE    
                          ,A.TO_SITE     
                          ,A.BOD_ID     
                          ,A.TRANSPORT_MODE    
                          ,A.MEASURE    
                          ,A.YYYYMMDD    
                          ,A.ORIGIN_FROM_DIVISION_ID
                          ,A.ORIGIN_TO_DIVISION_ID
                          ,A.ELECTRODE_TYPE
                          ,A.COMPLETE_QTY AS QTY    
                      FROM DBO.SSP_PLN_SHIPMENT_PLAN A WITH (NOLOCK)     
                      WHERE 1 = 1    
                        AND A.DIVISION_ID         = @p_division_id          
                        AND A.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd     
                        AND A.PLAN_TYPE           = @p_plan_type            
                        AND A.SEQ                 = @p_seq                  
                        AND A.MEASURE             =  'SHIP_PLAN'    
                        AND A.SEMI_YN             = 'Y'     
                  ) X    
             GROUP BY    
                   DIVISION_ID    
                  ,PLAN_START_YYYYMMDD    
                  ,PLAN_TYPE    
                  ,SEQ    
                  ,ITEM_ID    
                  ,FROM_SITE    
                  ,TO_SITE    
                  ,BOD_ID    
                  ,TRANSPORT_MODE    
                  ,MEASURE    
                  ,YYYYMMDD    
                  ,ORIGIN_FROM_DIVISION_ID
                  ,ORIGIN_TO_DIVISION_ID
                  ,ELECTRODE_TYPE
                  ;    
    
                
          -------------------------------------------------------------------------------------------------------------     
          -- 3. SHIP_PLAN_AMEND 입력 UI 수정용 SEMI에서 사용  : 셀 출하계획 Amend수량    
          -------------------------------------------------------------------------------------------------------------     
             INSERT INTO #tmp_SSP_ANL_SHIPMENT_PLAN_SEMI    
                  (    
                   DIVISION_ID    
                  ,PLAN_START_YYYYMMDD    
                  ,PLAN_TYPE    
                  ,SEQ    
                  ,OPERATION_GROUP    
                  ,ITEM_ID    
                  ,FROM_SITE    
                  ,TO_SITE    
                  ,BOD_ID    
                  ,TRANSPORT_MODE    
                  ,MEASURE    
                  ,YYYYMMDD    
                  ,ORIGIN_FROM_DIVISION_ID
                  ,ORIGIN_TO_DIVISION_ID
                  ,ELECTRODE_TYPE
                  ,QTY    
                  )    
    
            SELECT DIVISION_ID    
                  ,PLAN_START_YYYYMMDD    
                  ,PLAN_TYPE    
                  ,SEQ    
                  ,OPERATION_GROUP    
                  ,ITEM_ID    
                  ,FROM_SITE    
                  ,TO_SITE    
                  ,BOD_ID    
                  ,TRANSPORT_MODE    
                  ,'SHIP_PLAN_AMEND' AS MEASURE    
                  ,YYYYMMDD    
                  ,ORIGIN_FROM_DIVISION_ID
                  ,ORIGIN_TO_DIVISION_ID
                  ,ELECTRODE_TYPE
                  ,QTY    
          FROM  #tmp_SSP_ANL_SHIPMENT_PLAN_SEMI WITH (NOLOCK)     
          WHERE MEASURE ='SHIP_PLAN'    
    
          -------------------------------------------------------------------------------------------------------------     
          -- 4. CHAR_COMPLETED_QTY 입력(셀) : 셀 특성완료일자별 수량    
          -------------------------------------------------------------------------------------------------------------  
   
             INSERT INTO #tmp_SSP_ANL_SHIPMENT_PLAN_SEMI    
                  (    
                   DIVISION_ID    
                  ,PLAN_START_YYYYMMDD    
                  ,PLAN_TYPE    
                  ,SEQ    
                  ,OPERATION_GROUP    
                  ,ITEM_ID    
                  ,FROM_SITE    
                  ,TO_SITE    
                  ,BOD_ID    
                  ,TRANSPORT_MODE    
                  ,MEASURE    
                  ,YYYYMMDD    
                  ,ORIGIN_FROM_DIVISION_ID
                  ,ORIGIN_TO_DIVISION_ID
                  ,ELECTRODE_TYPE
                  ,QTY    
                  )    

                SELECT A.DIVISION_ID    
                     , A.PLAN_START_YYYYMMDD    
                     , A.PLAN_TYPE    
                     , A.SEQ    
                     , MAX(A.OPERATION_GROUP)               AS OPERATION_GROUP    
                     , A.ITEM_ID                      
                     , A.SITE_ID                            AS FROM_SITE    
                     , '-'                                  AS TO_SITE    
                     , '-'         AS BOD_ID    
                     , '-'                                  AS TRANSPORT_MODE    
                     , 'CHAR_COMPLETED_QTY'                 AS MEASURE    
                     , CONVERT(VARCHAR(8),A.END_TIME,112)   AS YYYYMMDD    
                     ,A.ORIGIN_DIVISION_ID                  AS ORIGIN_FROM_DIVISION_ID
                     ,''                                    AS ORIGIN_TO_DIVISION_ID
                     ,A.ELECTRODE_TYPE
                     , SUM(A.COMPLETE_QTY)                  AS QTY    
                  FROM SSP_PLN_PRODUCTION_PLAN A WITH (NOLOCK)    
                 WHERE 1=1    
                   AND A.DIVISION_ID          = @p_division_id          
                   AND A.PLAN_START_YYYYMMDD  = @p_plan_start_yyyymmdd  
                   AND A.PLAN_TYPE            = @p_plan_type            
                   AND A.SEQ                  = @p_seq                            
                   AND A.OPERATION_GROUP      = 'A'    
                   AND A.OPERATION_ID         = 'F6000'    
                
                GROUP BY     
                       A.DIVISION_ID    
                     , A.PLAN_START_YYYYMMDD    
                     , A.PLAN_TYPE    
                     , A.SEQ    
                     , A.OPERATION_GROUP    
                     , A.ITEM_ID    
                     , A.SITE_ID    
                     , CONVERT(VARCHAR(8),A.END_TIME,112)    
                     , A.ORIGIN_DIVISION_ID
                     , A.ELECTRODE_TYPE

          -------------------------------------------------------------------------------------------------------------     
          -- 5. COMPLETED_QTY 입력(전극)  :  전극 생산완료 수량    
          -------------------------------------------------------------------------------------------------------------     
             INSERT INTO #tmp_SSP_ANL_SHIPMENT_PLAN_SEMI    
                  (    
                   DIVISION_ID    
                  ,PLAN_START_YYYYMMDD    
                  ,PLAN_TYPE    
                  ,SEQ    
                  ,OPERATION_GROUP    
                  ,ITEM_ID    
                  ,FROM_SITE    
                  ,TO_SITE    
                  ,BOD_ID    
                  ,TRANSPORT_MODE    
                  ,MEASURE    
                  ,YYYYMMDD  
                  ,ORIGIN_FROM_DIVISION_ID
                  ,ORIGIN_TO_DIVISION_ID
                  ,ELECTRODE_TYPE  
                  ,QTY    
                  )    
                SELECT A.DIVISION_ID    
                     , A.PLAN_START_YYYYMMDD    
                     , A.PLAN_TYPE    
                     , A.SEQ    
                     , MAX(A.OPERATION_GROUP)               AS OPERATION_GROUP    
                     , A.ITEM_ID                      
                     , A.SITE_ID                            AS FROM_SITE    
                     , '-'                                  AS TO_SITE    
                     , '-'                                  AS BOD_ID    
                     , '-'                                  AS TRANSPORT_MODE    
                     , 'COMPLETED_QTY'                      AS MEASURE    
                     , CONVERT(VARCHAR(8),A.END_TIME,112)   AS YYYYMMDD   
                     , A.ORIGIN_DIVISION_ID                 AS ORIGIN_FROM_DIVISION_ID
                     , ''                                  AS ORIGIN_TO_DIVISION_ID
                     , A.ELECTRODE_TYPE 
                     , SUM(A.COMPLETE_QTY)                  AS QTY    
                  FROM SSP_PLN_PRODUCTION_PLAN A WITH (NOLOCK)    
                 WHERE 1=1    
                   AND A.DIVISION_ID          = @p_division_id         
                   AND A.PLAN_START_YYYYMMDD  = @p_plan_start_yyyymmdd      
                   AND A.PLAN_TYPE            = @p_plan_type           
                   AND A.SEQ                  = @p_seq                          
                   AND A.OPERATION_GROUP      = 'E'    
                   AND A.OPERATION_ID         = 'E2000'    
                GROUP BY     
                       DIVISION_ID    
                     , PLAN_START_YYYYMMDD    
                     , PLAN_TYPE    
                     , SEQ    
                     , OPERATION_GROUP    
                     , ITEM_ID    
                     , SITE_ID    
                     , CONVERT(VARCHAR(8),END_TIME,112)    
                     , ORIGIN_DIVISION_ID
                     , ELECTRODE_TYPE
                     ;    
          -------------------------------------------------------------------------------------------------------------     
          -- 6. INVENTORY(셀) : INVENTORY       
          --      1. Inventory = BOH - Ship plan + Complate QTY     
         --      2. Inventory = Inventory - Ship plan + Complate QTY     
          -------------------------------------------------------------------------------------------------------------     
    
--          PRINT 'GETDATE[' + CONVERT(NVARCHAR, GETDATE(),120)+ ']';    
          /* 전구간에 대해서 출하계획이 존재하지 않는 ITEM, FROM_SITE 정보는 삭제 처리 */    
          --SELECT 'DELETE', *    
          DELETE     
          --top (100000)    
          FROM #tmp_SSP_ANL_SHIPMENT_PLAN_SEMI      
          WHERE DIVISION_ID                   = @P_DIVISION_ID              
             AND PLAN_START_YYYYMMDD          = @P_PLAN_START_YYYYMMDD      
             AND PLAN_TYPE                    = @P_PLAN_TYPE                
             AND SEQ                          = @P_SEQ                      
             AND NOT EXISTS ( SELECT 'X'    
                                FROM #tmp_SSP_ANL_SHIPMENT_PLAN_SEMI X WITH(NOLOCK)    
                               WHERE X.DIVISION_ID              = @P_DIVISION_ID              
                                 AND X.PLAN_START_YYYYMMDD      = @P_PLAN_START_YYYYMMDD      
                                 AND X.PLAN_TYPE                = @P_PLAN_TYPE                
                                 AND X.SEQ                      = @P_SEQ                      
                                 AND X.MEASURE                  ='SHIP_PLAN'    
                                 AND X.ITEM_ID                  = #tmp_SSP_ANL_SHIPMENT_PLAN_SEMI.ITEM_ID    
                                 AND X.FROM_SITE                = #tmp_SSP_ANL_SHIPMENT_PLAN_SEMI.FROM_SITE    
                                 --AND X.ORIGIN_FROM_DIVISION_ID  = #tmp_SSP_ANL_SHIPMENT_PLAN_SEMI.ORIGIN_FROM_DIVISION_ID    
                                 --AND X.ORIGIN_TO_DIVISION_ID    = #tmp_SSP_ANL_SHIPMENT_PLAN_SEMI.ORIGIN_TO_DIVISION_ID    
                                 --AND X.ELECTRODE_TYPE           = #tmp_SSP_ANL_SHIPMENT_PLAN_SEMI.ELECTRODE_TYPE    
                             )    
            ;    
--            PRINT 'GETDATE[' + CONVERT(NVARCHAR, GETDATE(),120)+ ']';    
    
          -------------------------------------------------------------------------------------------------------------                 
          --  . CHAR_COMPLETED_QTY OR COMPLETED_QTY OR INVENTORY 이 존재하지 않는 경우, 해당 MEASURE를 0으로 추가      
          --      (비고) FROM SITE TO SITE 출하계획이 존재하지 않는 경우, 관련 MEASURE가 미생성되는 것은 허용함      
          --             (SHIP_REQ(SHIP_REQ_CELL_QTY), SHIP_PLAN(SHIP_PLAN_CELL_QTY), SHIP_PLAN_AMEND(SHIP_PLAN_AMEND_CELL_QTY) )      
          -------------------------------------------------------------------------------------------------------------       
    
          DECLARE @X_INT        INT   =1;      
          DECLARE @X_MEASURE    NVARCHAR(100);      
      
          WHILE @X_INT < 3      
          BEGIN      
                  
               SELECT @X_MEASURE = ( CASE @X_INT WHEN 1 THEN 'CHAR_COMPLETED_QTY'       
                                                 WHEN 2 THEN 'COMPLETED_QTY'       
                                     END);      
                                           

                INSERT INTO #tmp_SSP_ANL_SHIPMENT_PLAN_SEMI                
                     (                
                       DIVISION_ID                
                      ,PLAN_START_YYYYMMDD                
                      ,PLAN_TYPE                                      
                      ,SEQ                
                      ,OPERATION_GROUP                
                      ,ITEM_ID    
                      ,FROM_SITE    
                      ,TO_SITE    
                      ,BOD_ID    
                      ,TRANSPORT_MODE    
                      ,MEASURE    
                      ,YYYYMMDD    
                      --,ORIGIN_FROM_DIVISION_ID
                      --,ORIGIN_TO_DIVISION_ID
                      --,ELECTRODE_TYPE 
                      ,QTY              
                      )        

              
               SELECT         
                      SUB.DIVISION_ID                      
                     ,SUB.PLAN_START_YYYYMMDD              
                     ,SUB.PLAN_TYPE                        
                     ,SUB.SEQ                          
                     ,SUB.OPERATION_GROUP                  
                     ,SUB.ITEM_ID    
                     ,SUB.FROM_SITE              
                     ,SUB.TO_SITE              
                     ,SUB.BOD_ID              
                     ,SUB.TRANSPORT_MODE              
                     ,SUB.MEASURE              
                     ,SUB.YYYYMMDD      
                     --,SUB.ORIGIN_FROM_DIVISION_ID
                     --,SUB.ORIGIN_TO_DIVISION_ID
                     --,SUB.ELECTRODE_TYPE         
                     ,0   AS QTY                           
                FROM         
                    (        
                  SELECT         
                               DIVISION_ID                
                              ,PLAN_START_YYYYMMDD                
                              ,PLAN_TYPE                
                              ,SEQ                
                              ,OPERATION_GROUP                
                              ,ITEM_ID                
                              ,FROM_SITE      
                              ,'-'        AS TO_SITE                
                              ,'-'        AS BOD_ID           
                              ,'-'        AS TRANSPORT_MODE         
                              ,@X_MEASURE AS MEASURE       
                              ,YYYYMMDD      
                              --,ORIGIN_FROM_DIVISION_ID
                              --,ORIGIN_TO_DIVISION_ID
                              --,ELECTRODE_TYPE 
                         FROM        
                              (  -- 365 DAYS      
                                 SELECT C.BASIS_YYYYMMDD AS YYYYMMDD          
                                   FROM SCM_SYS_CALENDAR_M    C WITH(NOLOCK)         
                                  WHERE 1=1      
                                    AND C.BASIS_YYYYMMDD >= @p_plan_start_yyyymmdd       
                                    AND C.BASIS_YYYYMMDD <  CONVERT(VARCHAR,DATEADD(D,56,CONVERT(DATETIME,@p_plan_start_yyyymmdd,112)),112)      
                              ) A,        
                              (        
                                 SELECT DISTINCT       
                                        DIVISION_ID                
                                       ,PLAN_START_YYYYMMDD                
                                       ,PLAN_TYPE                
                                       ,SEQ                
                                       ,OPERATION_GROUP                
                                       ,ITEM_ID                
                                       ,FROM_SITE          
                                       --,ORIGIN_FROM_DIVISION_ID
                                       --,ORIGIN_TO_DIVISION_ID
                                       --,ELECTRODE_TYPE       
                                  FROM #tmp_SSP_ANL_SHIPMENT_PLAN_SEMI X WITH(NOLOCK)        
                                 WHERE 1=1      
                                 AND (CASE WHEN @X_MEASURE  = 'CHAR_COMPLETED_QTY' THEN 'A' 
                                           WHEN @X_MEASURE  = 'COMPLETED_QTY'      THEN 'E' 
                                            ELSE X.OPERATION_GROUP  END ) = X.OPERATION_GROUP     
                              ) B        
                    ) SUB        
                    WHERE 1=1        
                      AND NOT EXISTS (        
                                       SELECT 'X'        
                                         FROM #tmp_SSP_ANL_SHIPMENT_PLAN_SEMI Z WITH(NOLOCK)        
                                        WHERE 1=1        
                                          AND Z.DIVISION_ID              = SUB.DIVISION_ID                                            
                                          AND Z.PLAN_START_YYYYMMDD      = SUB.PLAN_START_YYYYMMDD                                    
                                          AND Z.PLAN_TYPE                = SUB.PLAN_TYPE                                              
                                          AND Z.SEQ                      = SUB.SEQ                                                    
                                          AND Z.OPERATION_GROUP          = SUB.OPERATION_GROUP                                        
                                          AND Z.ITEM_ID                  = SUB.ITEM_ID                                                
                                          AND Z.FROM_SITE                = SUB.FROM_SITE                                                
                                          AND Z.MEASURE                  = @X_MEASURE                                                 
                                          AND Z.YYYYMMDD                 = SUB.YYYYMMDD      
                                          --AND Z.ORIGIN_FROM_DIVISION_ID  = SUB.ORIGIN_FROM_DIVISION_ID      
                                          --AND Z.ORIGIN_TO_DIVISION_ID    = SUB.ORIGIN_TO_DIVISION_ID      
                                          --AND Z.ELECTRODE_TYPE           = SUB.ELECTRODE_TYPE                                               
                                     )    
                      ;                                                                                               
                                                                                                                                      
    
    
                  
               SET @X_INT = @X_INT + 1;      
          
           END      
              
    
 
                            
          -------------------------------------------------------------------------------------------------------------                 
          -- 7. MEASURE별 BUCKET일자별 0 채우기            
          -------------------------------------------------------------------------------------------------------------                          

            INSERT INTO #tmp_SSP_ANL_SHIPMENT_PLAN_SEMI                
                 (                
                   DIVISION_ID                
                  ,PLAN_START_YYYYMMDD                
                  ,PLAN_TYPE                
                  ,SEQ                
                  ,OPERATION_GROUP                
                  ,ITEM_ID    
                  ,FROM_SITE    
                  ,TO_SITE    
                  ,BOD_ID    
                  ,TRANSPORT_MODE    
                  ,MEASURE    
                  ,YYYYMMDD    
                  --,ORIGIN_FROM_DIVISION_ID
                  --,ORIGIN_TO_DIVISION_ID
                  --,ELECTRODE_TYPE 
                  ,QTY                  
                  )                     
           SELECT            
                  SUB.DIVISION_ID               
                 ,SUB.PLAN_START_YYYYMMDD       
                 ,SUB.PLAN_TYPE                 
                 ,SUB.SEQ                
                 ,SUB.OPERATION_GROUP           
                 ,SUB.ITEM_ID    
                 ,SUB.FROM_SITE    
                 ,SUB.TO_SITE    
                 ,SUB.BOD_ID    
                 ,SUB.TRANSPORT_MODE    
                 ,SUB.MEASURE    
                 ,SUB.YYYYMMDD     
                 --,SUB.ORIGIN_FROM_DIVISION_ID
                 --,SUB.ORIGIN_TO_DIVISION_ID
                 --,SUB.ELECTRODE_TYPE            
                 ,0   AS QTY                            
            FROM         
                (        
                    SELECT         
                           DIVISION_ID                
                          ,PLAN_START_YYYYMMDD                
                          ,PLAN_TYPE                
                          ,SEQ                
                          ,OPERATION_GROUP                
                          ,ITEM_ID        
                          ,FROM_SITE    
                          ,TO_SITE    
                          ,BOD_ID     
                          ,TRANSPORT_MODE     
                          ,MEASURE    
                          ,YYYYMMDD    
                          --,ORIGIN_FROM_DIVISION_ID
                          --,ORIGIN_TO_DIVISION_ID
                          --,ELECTRODE_TYPE 
                     FROM        
                          (  -- 365 DAYS      
                             SELECT C.BASIS_YYYYMMDD AS YYYYMMDD          
                               FROM SCM_SYS_CALENDAR_M    C WITH(NOLOCK)         
                              WHERE 1=1      
                                AND C.BASIS_YYYYMMDD >= @p_plan_start_yyyymmdd       
                                AND C.BASIS_YYYYMMDD <  CONVERT(VARCHAR,DATEADD(D,56,CONVERT(DATETIME,@p_plan_start_yyyymmdd,112)),112)      
                          ) A,        
                          (        
                             SELECT DISTINCT       
                                    DIVISION_ID               
                                   ,PLAN_START_YYYYMMDD               
                                   ,PLAN_TYPE               
                                   ,SEQ                
                                   ,OPERATION_GROUP               
                                   ,ITEM_ID       
                                   ,FROM_SITE    
                                   ,TO_SITE    
                                   ,BOD_ID    
                                   ,TRANSPORT_MODE    
                                   ,MEASURE    
                                   --,ORIGIN_FROM_DIVISION_ID
                                   --,ORIGIN_TO_DIVISION_ID
                                   --,ELECTRODE_TYPE 
                              FROM #tmp_SSP_ANL_SHIPMENT_PLAN_SEMI X WITH(NOLOCK)        
                             WHERE 1=1      
                          ) B        
                ) SUB        
                WHERE 1=1        
                  AND NOT EXISTS (        
                                   SELECT 'X'        
                                     FROM #tmp_SSP_ANL_SHIPMENT_PLAN_SEMI Z WITH(NOLOCK)        
                                    WHERE 1=1        
                                      AND Z.DIVISION_ID              = SUB.DIVISION_ID                                
                                      AND Z.PLAN_START_YYYYMMDD      = SUB.PLAN_START_YYYYMMDD                        
                                      AND Z.PLAN_TYPE                = SUB.PLAN_TYPE                                  
                                      AND Z.SEQ                      = SUB.SEQ                                        
                                      AND Z.OPERATION_GROUP          = SUB.OPERATION_GROUP                            
                                      AND Z.ITEM_ID                  = SUB.ITEM_ID                                    
                                      AND Z.TO_SITE                  = SUB.TO_SITE                                    
             
                                      AND Z.FROM_SITE                = SUB.FROM_SITE                                  
                                      AND Z.BOD_ID                   = SUB.BOD_ID                                     
                                      AND Z.MEASURE                  = SUB.MEASURE                                    
                                      AND Z.YYYYMMDD                 = SUB.YYYYMMDD       
                                      --AND Z.ORIGIN_FROM_DIVISION_ID  = SUB.ORIGIN_FROM_DIVISION_ID       
                                      --AND Z.ORIGIN_TO_DIVISION_ID    = SUB.ORIGIN_TO_DIVISION_ID       
                                      --AND Z.ELECTRODE_TYPE           = SUB.ELECTRODE_TYPE                                   
                                 );                                                                                              
                                       

          -------------------------------------------------------------------------------------------------------------     
          -- 8. 'SHIP_REQ'  YYYYMMDD가 PLAN_START_YYYYMMDD 보다 이전일 경우    YYYYMMDD에 합산함.  
          -------------------------------------------------------------------------------------------------------------   
            
                SELECT     DIVISION_ID                  
                          ,PLAN_START_YYYYMMDD   
                          ,PLAN_TYPE             
                          ,SEQ                   
                          ,OPERATION_GROUP       
                          -- ,PROJECT_CODE  
                          ,ITEM_ID               
                          ,FROM_SITE             
                          ,TO_SITE               
                          ,BOD_ID                
                          ,TRANSPORT_MODE        
                          ,MEASURE               
                          ,PLAN_START_YYYYMMDD AS YYYYMMDD              
                          ,SUM(QTY) AS QTY  
                INTO #Update  
                 FROM #tmp_SSP_ANL_SHIPMENT_PLAN_SEMI A with (nolock)  
                WHERE 1 = 1          
                  --AND A.DIVISION_ID         = @p_division_id    
                  --AND A.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd         
                  --AND A.PLAN_TYPE           = @p_plan_type    
                  --AND A.SEQ                 = @p_seq  
                  AND A.YYYYMMDD            < @p_plan_start_yyyymmdd        --  PLAN_START_YYYYMMDD 보다 적은   일자의 QTY를 합산하여 가져옴.  
                  AND A.MEASURE             = 'SHIP_REQ'  
      --          AND A.ITEM_ID             ='ACEP1038I-A1' -- 'ACEN1078I-A1-B03'  
              GROUP BY  DIVISION_ID                  
                       ,PLAN_START_YYYYMMDD   
                       ,PLAN_TYPE             
                       ,SEQ                   
                       ,OPERATION_GROUP       
                       --,PROJECT_CODE  
                       ,ITEM_ID               
                       ,FROM_SITE             
                       ,TO_SITE               
                       ,BOD_ID                             
                       ,TRANSPORT_MODE        
                       ,MEASURE               
  
  
                UPDATE X  
                 SET X.QTY = ISNULL(X.QTY,0) + ISNULL(Y.QTY,0)  
                FROM #tmp_SSP_ANL_SHIPMENT_PLAN_SEMI X with (nolock)  
                INNER JOIN #Update Y with (nolock)  
                ON  0 = 0  
                  AND X.OPERATION_GROUP     = Y.OPERATION_GROUP  
      --            AND X.PROJECT_CODE  
                  AND X.ITEM_ID             = Y.ITEM_ID  
                  AND X.FROM_SITE           = Y.FROM_SITE  
                  AND X.TO_SITE             = Y.TO_SITE  
                  AND X.BOD_ID              = Y.BOD_ID               
                  AND X.TRANSPORT_MODE      = Y.TRANSPORT_MODE  
                  AND X.MEASURE             = 'SHIP_REQ'  
                  AND X.MEASURE             = Y.MEASURE              
                  AND X.YYYYMMDD            = X.PLAN_START_YYYYMMDD -- @p_plan_start_yyyymmdd     
                 
               -- PLAN_START_YYYYMMDD 보다 큰 값은 삭제  
               DELETE FROM  #tmp_SSP_ANL_SHIPMENT_PLAN_SEMI WHERE YYYYMMDD < PLAN_START_YYYYMMDD  
  
                 
         -------------------------------------------------------------------------------------------------------------                 
          -- 9. SHIP_REQ_CELL_QTY,SHIP_PLAN_CELL_QTY,SHIP_PLAN_AMEND_CELL_QTY  추가 (전극,셀)    
          -------------------------------------------------------------------------------------------------------------    
          -- 속도 때문에 CELL 환산비율 #ELEC_CELL_PER_METER 테이블 생성     (dbo.FN_GET_ELEC_CELL_PER_METER 참조)

          /*
          SELECT  C.DIVISION_ID, C.ITEM_ID, C.VALUE   -- , *
          INTO #ELEC_CELL_PER_METER    
          FROM SCM_MST_ITEM_CONV_CALC_SN C WITH(NOLOCK),  -- FACTORY별로 여러건이 존재함.      
              SCM_MST_ITEM_SN           I WITH(NOLOCK)      
          WHERE 1=1      
--          AND C.DIVISION_ID              = @p_division_id_Cell   
            
          AND C.SITE_ID                  = ISNULL(NULL,C.SITE_ID)      
          AND C.PLANT_ID                 = ISNULL(null,C.PLANT_ID)      
          AND C.ITEM_ID                  IN ( SELECT DISTINCT ITEM_ID FROM #tmp_SSP_ANL_SHIPMENT_PLAN_SEMI WITH (NOLOCK) WHERE MEASURE   IN ('SHIP_REQ' ,'SHIP_PLAN','SHIP_PLAN_AMEND'))    
          AND C.CATEGORY                 = 'Pancake (cell/m)'      
          AND C.MAX_VER_FLAG             = 'Y'      
          AND C.OPERATION                = 'E4000'  --SPLIT      
          AND C.DIVISION_ID              = I.DIVISION_ID      
          AND C.SITE_ID                  = I.SITE_ID      
          AND C.ITEM_ID                  = I.ITEM_ID      
          AND C.MODEL_ID                 = I.APPLIED_MODEL --대표cell         
          */

          /*
            SELECT (CASE A.ACCUMULATED_CHILD_QTY WHEN 0 THEN 0 ELSE 1.0 / A.ACCUMULATED_CHILD_QTY END)  AS VALUE 
                   ,A.DIVISION_ID
                   ,A.CHILD_ITEM_ID AS ITEM_ID
            INTO #ELEC_CELL_PER_METER
            FROM  dbo.SCM_MST_MODEL_FINAL_ITEM_BOM_V  A WITH(NOLOCK)
                , SCM_MST_ITEM_SN                     I WITH(NOLOCK)  
            WHERE 0 = 0
              --AND I.DIVISION_ID     = @P_DIVISION_ID
              --AND I.ITEM_ID         = @P_ITEM_ID
              AND A.MODEL_ID          = ISNULL(I.APPLIED_MODEL,A.MODEL_ID)
              AND A.division_id       = I.DIVISION_ID
              AND A.CHILD_ITEM_ID     = I.ITEM_ID
              AND A.CHILD_ITEM_ID     IN ( SELECT DISTINCT ITEM_ID FROM #tmp_SSP_ANL_SHIPMENT_PLAN_SEMI WITH (NOLOCK) WHERE MEASURE   IN ('SHIP_REQ' ,'SHIP_PLAN','SHIP_PLAN_AMEND'))    
              AND A.MODEL_ID        LIKE '_C%' --CELL
              AND A.OPERATION_GROUP_ID = 'E'   --CHILD IS ELECTRODE



    
    
           INSERT INTO #tmp_SSP_ANL_SHIPMENT_PLAN_SEMI    
                  (    
                   DIVISION_ID    
                  ,PLAN_START_YYYYMMDD    
                  ,PLAN_TYPE    
                  ,SEQ    
                  ,OPERATION_GROUP    
                  ,ITEM_ID    
                  ,FROM_SITE    
                  ,TO_SITE    
                  ,BOD_ID    
                  ,TRANSPORT_MODE    
                  ,MEASURE    
                  ,YYYYMMDD    
                  --,ORIGIN_FROM_DIVISION_ID
                  --,ORIGIN_TO_DIVISION_ID
                  --,ELECTRODE_TYPE 
                  ,QTY    
                  )    
            SELECT DIVISION_ID    
                  ,PLAN_START_YYYYMMDD    
                  ,PLAN_TYPE    
                  ,SEQ    
                  ,OPERATION_GROUP    
                  ,ITEM_ID    
                  ,FROM_SITE    
                  ,TO_SITE    
                  ,BOD_ID    
                  ,TRANSPORT_MODE    
                  ,(CASE  WHEN MEASURE = 'SHIP_REQ'         THEN 'SHIP_REQ_CELL_QTY'      
                          WHEN MEASURE = 'SHIP_PLAN'        THEN 'SHIP_PLAN_CELL_QTY'     
                          WHEN MEASURE = 'SHIP_PLAN_AMEND'  THEN 'SHIP_PLAN_AMEND_CELL_QTY'     
                        ELSE '-' END)  AS MEASURE    
                  ,YYYYMMDD    
                  --,ORIGIN_FROM_DIVISION_ID
                  --,ORIGIN_TO_DIVISION_ID
                  --,ELECTRODE_TYPE 
                  ,ISNULL(QTY,0.00) * ISNULL((SELECT TOP 1 Y.VALUE 
                                                FROM #ELEC_CELL_PER_METER Y WITH (NOLOCK)   
                                               WHERE Y.ITEM_ID = X.ITEM_ID AND X.ORIGIN_FROM_DIVISION_ID = Y.DIVISION_ID),1)   AS QTY                      
             FROM #tmp_SSP_ANL_SHIPMENT_PLAN_SEMI X WITH (NOLOCK)    
             WHERE X.MEASURE   IN ('SHIP_REQ' ,'SHIP_PLAN','SHIP_PLAN_AMEND')    
               AND X.OPERATION_GROUP ='E' 
             ;
          */

                  INSERT INTO #tmp_SSP_ANL_SHIPMENT_PLAN_SEMI    
                  (    
                   DIVISION_ID    
                  ,PLAN_START_YYYYMMDD    
                  ,PLAN_TYPE    
                  ,SEQ    
                  ,OPERATION_GROUP    
                  ,ITEM_ID    
                  ,FROM_SITE    
                  ,TO_SITE    
                  ,BOD_ID    
                  ,TRANSPORT_MODE    
                  ,MEASURE    
                  ,YYYYMMDD    
                  --,ORIGIN_FROM_DIVISION_ID
                  --,ORIGIN_TO_DIVISION_ID
                  --,ELECTRODE_TYPE 
                  ,QTY    
                  )    

            SELECT DIVISION_ID    
                  ,PLAN_START_YYYYMMDD    
                  ,PLAN_TYPE    
                  ,SEQ    
                  ,OPERATION_GROUP    
                  ,ITEM_ID    
                  ,FROM_SITE    
                  ,TO_SITE    
                  ,BOD_ID    
                  ,TRANSPORT_MODE    
                  ,(CASE  WHEN MEASURE = 'SHIP_REQ'         THEN 'SHIP_REQ_CELL_QTY'      
                          WHEN MEASURE = 'SHIP_PLAN'        THEN 'SHIP_PLAN_CELL_QTY'     
                          WHEN MEASURE = 'SHIP_PLAN_AMEND'  THEN 'SHIP_PLAN_AMEND_CELL_QTY'     
                        ELSE '-' END)  AS MEASURE    
                  ,YYYYMMDD    
                  --,ORIGIN_FROM_DIVISION_ID
                  --,ORIGIN_TO_DIVISION_ID
                  --,ELECTRODE_TYPE 
                  ,ISNULL(QTY,0.00) * ISNULL((SELECT TOP 1 ISNULL(Y.CONVERT_QTY_CELL,1) 
                                                FROM SCP_MST_FINAL_ITEM Y WITH (NOLOCK)   
                                               WHERE Y.ITEM_ID = X.ITEM_ID AND X.ORIGIN_FROM_DIVISION_ID = Y.DIVISION_ID),1)   AS QTY     
             FROM #tmp_SSP_ANL_SHIPMENT_PLAN_SEMI X WITH (NOLOCK)    
             WHERE X.MEASURE   IN ('SHIP_REQ' ,'SHIP_PLAN','SHIP_PLAN_AMEND')    
               AND X.OPERATION_GROUP ='E' 
             ;       

    
    
        -------------------------------------------------------------------------------------------------------------                 
        -- 10. INVENTORY 계산값 생성       
        --Inventory = BOH - Ship plan + Complate QTY     
        --Inventory = Inventory - Ship plan + Complate QTY     
        -- [dbo].[FN_GET_SSP_ANL_CHAR_BOH_QTY]    
        --           and stock_type                IN ('CHAR','A_MOVE_WH','A_OUT_WH') --특성완료재고        
        -------------------------------------------------------------------------------------------------------------       
    
    
            -- INVENTORY 속도 때문에 CLUSTERED INDEX 추가 함.    
            --DROP INDEX #tmp_SSP_ANL_SHIPMENT_PLAN_SEMI.IX01_#tmp_SSP_ANL_SHIPMENT_PLAN_SEMI    
            CREATE CLUSTERED INDEX [IX01_#tmp_SSP_ANL_SHIPMENT_PLAN_SEMI] ON #tmp_SSP_ANL_SHIPMENT_PLAN_SEMI    
            (    
               DIVISION_ID     
             ,PLAN_START_YYYYMMDD    
             ,PLAN_TYPE    
             ,SEQ    
             ,ITEM_ID    
             ,FROM_SITE    
             ,MEASURE    
             ,YYYYMMDD    
              );    
    
                 WITH Z AS      
                 (      SELECT   DISTINCT      
                               DIVISION_ID                
                              ,PLAN_START_YYYYMMDD                
                              ,PLAN_TYPE                
                              ,SEQ                
                              ,OPERATION_GROUP
--                              ,PROJECT_CODE                
                              ,ITEM_ID                
--                              ,TO_SITE             
                              ,FROM_SITE                
--                              ,INCOTERMS      
                              ,YYYYMMDD       
                              --,ORIGIN_FROM_DIVISION_ID
                              --,ORIGIN_TO_DIVISION_ID
                              --,ELECTRODE_TYPE                               
                          FROM #tmp_SSP_ANL_SHIPMENT_PLAN_SEMI Z WITH(NOLOCK)       
                         WHERE 1=1       
                           AND DIVISION_ID         =@P_DIVISION_ID           --'81'               
                           AND PLAN_START_YYYYMMDD =@P_PLAN_START_YYYYMMDD   --'20180416'      
                           AND PLAN_TYPE           =@P_PLAN_TYPE             --'PR'        
                           AND SEQ                 =@P_SEQ                   --1      
                           AND MEASURE         IN ('SHIP_PLAN','CHAR_COMPLETED_QTY','COMPLETED_QTY')      -- CELL(CHAR_COMPLETED_QTY) / ELECTROID(COMPLETED_QTY)    
                           GROUP BY      
                               DIVISION_ID                
                              ,PLAN_START_YYYYMMDD                
                              ,PLAN_TYPE                
                              ,SEQ                
                              ,ITEM_ID                
                              ,FROM_SITE                    
                              ,YYYYMMDD     
                              --,ORIGIN_FROM_DIVISION_ID
                              --,ORIGIN_TO_DIVISION_ID
                              --,ELECTRODE_TYPE   
                              ,OPERATION_GROUP

               ),      
               BOH AS      
               (      
                       select DIVISION_ID      
                             ,PLAN_START_YYYYMMDD      
                             ,PLAN_TYPE      
                             ,SEQ      
                             ,SITE_ID      
                             ,ITEM_ID     
                             --,ORIGIN_DIVISION_ID
                             --,ELECTRODE_TYPE
                             ,sum(isnull(PSI_BOH_QTY,0)) as     PSI_BOH_QTY    
                         from SSP_PLN_PLANT_ONHAND with(nolock)        
                        where division_id               = @P_DIVISION_ID           --'81'             
                          and plan_start_yyyymmdd       = @P_PLAN_START_YYYYMMDD   --'20180416'       
                          and plan_type                 = @P_PLAN_TYPE             --'PR'             
                          and seq                       = @P_SEQ                   --1                
                          and yyyymmdd                  = @P_PLAN_START_YYYYMMDD   --계획시작일      
--                          and STOCK_TYPE                IN ('CHAR','A_MOVE_WH','A_OUT_WH')  --특성완료재고      
                          and STOCK_TYPE                IN (      
                                                              'CHAR','A_MOVE_WH','A_OUT_WH'                    --CELL      
                                                             ,'COAT','SLITTING','SLIT','E_MOVE_WH','E_OUT_WH'  --ELECTRODE      
                                                             )      
    
                        grouP by DIVISION_ID      
                                 ,PLAN_START_YYYYMMDD      
                                 ,PLAN_TYPE      
                                 ,SEQ      
                                 ,SITE_ID      
                                 ,ITEM_ID  
                                 --,ORIGIN_DIVISION_ID
                                 --,ELECTRODE_TYPE  
               )      
    

                  -- INVENTORY INSERT ON X_YYYYMMDD      
              INSERT INTO #tmp_SSP_ANL_SHIPMENT_PLAN_SEMI             
                (                
                   DIVISION_ID    
                  ,PLAN_START_YYYYMMDD    
                  ,PLAN_TYPE    
                  ,SEQ    
                  ,OPERATION_GROUP    
                  ,ITEM_ID    
                  ,FROM_SITE    
                  ,TO_SITE    
                  ,BOD_ID    
    --                  ,TRANSPORT_MODE    
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
                        ,Z.ITEM_ID                
                        ,Z.FROM_SITE        
                        ,'-' AS TO_SITE    
                        ,'-' AS BOT_ID            
                        ,'INVENTORY'  AS      MEASURE    
                        ,Z.YYYYMMDD    
                        --,Z.ORIGIN_FROM_DIVISION_ID
                        --,Z.ORIGIN_TO_DIVISION_ID
                        --,Z.ELECTRODE_TYPE 
                        ,( SELECT      
                                ISNULL( SUM(CASE MEASURE  WHEN 'SHIP_PLAN'   THEN -1 * ISNULL(QTY,0)      
                                                          WHEN 'CHAR_COMPLETED_QTY' THEN   ISNULL(QTY,0)        -- CELL : CHAR_COMPLETED_QTY  /  전극 : COMPLETED_QTY    
                                                          WHEN 'COMPLETED_QTY'      THEN   ISNULL(QTY,0)      
                                                          ELSE 0.0      
                                      END),0)       
--                            FROM dbo.SSP_ANL_SHIPMENT_PLAN_SEMI X WITH(NOLOCK)       
                            FROM #tmp_SSP_ANL_SHIPMENT_PLAN_SEMI X WITH (NOLOCK)    
                          WHERE 1=1      
                            AND X.DIVISION_ID               = Z.DIVISION_ID      
                            AND X.PLAN_START_YYYYMMDD       = Z.PLAN_START_YYYYMMDD               
                            AND X.PLAN_TYPE                 = Z.PLAN_TYPE      
                            AND X.SEQ                       = Z.SEQ      
                            AND X.ITEM_ID                   = Z.ITEM_ID      
                            AND X.FROM_SITE                 = Z.FROM_SITE      
                            AND X.MEASURE                   IN ('SHIP_PLAN','CHAR_COMPLETED_QTY','COMPLETED_QTY')      
                            --AND X.ORIGIN_FROM_DIVISION_ID   = Z.ORIGIN_FROM_DIVISION_ID      
                            --AND X.ORIGIN_TO_DIVISION_ID     = Z.ORIGIN_TO_DIVISION_ID      
                            --AND X.ELECTRODE_TYPE            = Z.ELECTRODE_TYPE      
                            AND X.YYYYMMDD                  <= Z.YYYYMMDD      
                          )       
                          + ISNULL(BOH.PSI_BOH_QTY,0) AS QTY       
                    FROM Z WITH(NOLOCK)       
                  LEFT OUTER JOIN BOH WITH(NOLOCK) 
                                       ON Z.DIVISION_ID             = BOH.DIVISION_ID      
                                      AND Z.PLAN_START_YYYYMMDD     = BOH.PLAN_START_YYYYMMDD      
                                      AND Z.PLAN_TYPE               = BOH.PLAN_TYPE      
                                      AND Z.SEQ                     = BOH.SEQ      
--                                                   AND Z.TO_SITE              = BOH.SITE_ID      
                                      AND Z.FROM_SITE               = BOH.SITE_ID      
                                      AND Z.ITEM_ID                 = BOH.ITEM_ID      
                                      --AND Z.ORIGIN_FROM_DIVISION_ID = BOH.ORIGIN_DIVISION_ID      
                                      --AND Z.ELECTRODE_TYPE          = BOH.ELECTRODE_TYPE      
 
                  WHERE 1=1     
                  --and z.ITEM_ID ='ECP0640N5-02'     
                  --ORDER BY 8    
                  ;    

    

          -------------------------------------------------------------------------------------------------------------     
          -- 11. 전극 SCP 반영(ORIGIN_FROM_DIVISION_ID,ORIGIN_TO_DIVISION_ID,ELECTRODE_TYPE) 추가 
          ------------------------------------------------------------------------------------------------------------- 

            UPDATE X
               SET X.ORIGIN_FROM_DIVISION_ID = Y.DIVISION_ID
              FROM #tmp_SSP_ANL_SHIPMENT_PLAN_SEMI X WITH (NOLOCK)
              LEFT OUTER JOIN DBO.SCM_MST_SITE Y  WITH (NOLOCK)       -- from   PLANT_SITE_ID
                           ON 0 = 0
--                          AND Y.SITE_TYPE   = 'PLANT'    
                          AND Y.SCM_SITE_ID  = X.FROM_SITE
                          AND Y.VALID_YN ='Y'   

            UPDATE X
               SET X.ORIGIN_TO_DIVISION_ID = Y.DIVISION_ID
              FROM #tmp_SSP_ANL_SHIPMENT_PLAN_SEMI X WITH (NOLOCK)
              LEFT OUTER JOIN DBO.SCM_MST_SITE Y  WITH (NOLOCK)       -- to   SALES_SITE_ID
                           ON 0 = 0
--                          AND Y.SITE_TYPE   = 'PLANT'    
                          AND Y.SCM_SITE_ID  = X.TO_SITE
                          AND Y.VALID_YN ='Y'          

             UPDATE X  
               SET X.ELECTRODE_TYPE = ISNULL(Y.ELECTRODE_TYPE,''), X.OPERATION_GROUP = Y.OPERATION_GROUP  
              FROM #tmp_SSP_ANL_SHIPMENT_PLAN_SEMI X WITH (NOLOCK)  
              INNER JOIN DBO.SCP_MST_FINAL_ITEM_V Y  WITH (NOLOCK)         
                    ON 0 = 0
                   AND X.DIVISION_ID      = @p_division_id      
                   AND X.ITEM_ID          = Y.ITEM_ID             
          -------------------------------------------------------------------------------------------------------------     
          -- 12. SSP_ANL_SHIPMENT_PLAN_SEMI 삭제     
          -------------------------------------------------------------------------------------------------------------    
            DELETE     
            FROM SSP_ANL_SHIPMENT_PLAN_SEMI      
            WHERE DIVISION_ID         = @p_division_id     
              AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd     
              AND PLAN_TYPE           = @p_plan_type     
              AND SEQ                 = @p_seq    
              
          -------------------------------------------------------------------------------------------------------------     
          -- 13. SSP_ANL_SHIPMENT_PLAN_SEMI 입력     
          -------------------------------------------------------------------------------------------------------------    

           INSERT INTO /* PR_SSP_ANL_SHIPMENT_PLAN_SEMI */ dbo.SSP_ANL_SHIPMENT_PLAN_SEMI    
                  (    
                   DIVISION_ID    
                  ,PLAN_START_YYYYMMDD    
                  ,PLAN_TYPE    
                  ,SEQ    
                  ,OPERATION_GROUP    
                  ,ITEM_ID    
                  ,FROM_SITE    
                  ,TO_SITE    
                  ,BOD_ID    
--                  ,TRANSPORT_MODE    
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
                  ,ISNULL(OPERATION_GROUP,'')    
                  ,ITEM_ID    
                  ,FROM_SITE    
                  ,TO_SITE    
                  ,ISNULL(BOD_ID,'-')
--                          ,TRANSPORT_MODE    
                  ,MEASURE    
                  ,YYYYMMDD    
                  ,ISNULL(ORIGIN_FROM_DIVISION_ID,'')
                  ,ISNULL(ORIGIN_TO_DIVISION_ID,'') AS ORIGIN_TO_DIVISION_ID
                  ,ELECTRODE_TYPE 
                  ,SUM(QTY) AS QTY
                  ,@v_batch_user AS CREATED_BY    
                  ,GETDATE()     AS CREATION_DATE    
                  ,@v_batch_user AS LAST_UPDATED_BY    
                  ,GETDATE()     AS LAST_UPDATED_BY    
              FROM #tmp_SSP_ANL_SHIPMENT_PLAN_SEMI WITH (NOLOCK)    
              WHERE 1=1    
              AND YYYYMMDD < CONVERT(VARCHAR,DATEADD(D,56,CONVERT(DATETIME,@p_plan_start_yyyymmdd,112)),112)       
               GROUP BY  
                    DIVISION_ID    
                   ,PLAN_START_YYYYMMDD    
                   ,PLAN_TYPE    
                   ,SEQ    
                   ,ISNULL(OPERATION_GROUP,'')    
                   ,ITEM_ID    
                   ,FROM_SITE    
                   ,TO_SITE    
                   ,ISNULL(BOD_ID,'-')
--                           ,TRANSPORT_MODE    
                   ,MEASURE    
                   ,YYYYMMDD    
                   ,ISNULL(ORIGIN_FROM_DIVISION_ID,'')
                   ,ISNULL(ORIGIN_TO_DIVISION_ID,'')
                   ,ELECTRODE_TYPE           
              ;    
                                      
        -----------------------------------------------------------    
        -- 실행 Logic END --    
        -----------------------------------------------------------    
        --IF @@TRANCOUNT > 0    
        --  BEGIN    
        --    COMMIT TRAN TX_SH_SEMI;    
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
      --    ROLLBACK TRAN TX_SH_SEMI    
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
    
    
  

