      
/*    
 * Program ID   : PR_SCP_ANL_SHIPMENT_PLAN_SEMI      
 * Description  : PR_SCP_ANL_CREATE_DATA 에서 호출함.    
 * OutTable     :    
 * Execute      :   EXEC PR_SCP_ANL_SHIPMENT_PLAN_SEMI     @p_division_id         = '82'     
                                                          ,@p_plan_start_yyyymmdd = '20180416'    
                                                          ,@p_plan_type           = 'SE'    
                                                          ,@p_seq                 = '1'    
                                                          ,@p_engine_plan_id      = '1022::SE::1'    
                                                          ,@p_user_id             = 'kth'    
 * Program History    
 *===================================================================================================    
 *   Date       In Charge      Description    
 *===================================================================================================    
 * 2018.03.29   KTH         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트    
 * 2018.03.29   YYDOK       특성완료수량(셀), 전극완료수량(전극) 보완    
 * 2018.04.20   KTH         MEASURE 추가 반영으로 수정   
 * 2018.05.23   KTH         계획의 첫째날 출하요청수량로직 변경('SHIP_REQ' PLAN_START_YYYYMMDD 이전 데이터 보정 .)  
 * 2018.06.07   KTH         TRANSACTION 삭제  
 * 2018.06.14   KTH         ORG_DEMAND_ID 조인 부분 삭제  
 * 2018.06.21   KTH         52주 364일 제한 로직 추가 AND YYYYMMDD < CONVERT(VARCHAR,DATEADD(D,364,CONVERT(DATETIME,@p_plan_start_yyyymmdd,112)),112)       
 * 2018.06.28   KTH         전극일 경우만 cell환산수량 반영하도록 수정 ( X.OPERATION_GROUP ='E') , MEASURE '0' 채움 로직 변경    
 * 2018.07.02   KTH         전극 SCP 반영(ORIGIN_FROM_DIVISION_ID,ORIGIN_TO_DIVISION_ID,ELECTRODE_TYPE) 추가
 * 2018.07.09   KTH         파라미터 변경 (PLN과 동일하게 변경)
 * 2018.07.11   KTH         MEASURE를 0으로 추가 로직 변경
 * 2018.07.18   KTH         전극일때 환산비율 로직 수정 
 * 2018.07.26   KTH         INCOTERMS 수정(BOD_ID -> DEMAND_ID)
 * 2018.09.03   KTH         환산비율로직 수정
 * 2018.10.05   KTH         변경된 환산비율 로직 반영(dbo.FN_GET_ELEC_CELL_PER_METER 참조)
 * 2018.10.08   KTH         환산비율 로직 변경 반영(SCP_MST_FINAL_ITEM)
 * 2018.11.21   KTH         'SHIP_REQ' 로직변경(YYYYMMDD = LPST) 추가
 * 2018.12.03   KTH         'SHIP_REQ' 로직변경(YYYYMMDD = LPST) 삭제
 * 2019.05.15   KTH         'SHIP_REQ' 로직변경(Pegging 조인 제거)
 * 2019.10.07   KSG          Shipment Req 관련 처리 정보 추가
 * 2020.01.20   KSG          C20200108-000178 SSP용 Shipment Req 정보 삭제 기준 조정(3->4)
 * 2020.07.28   KSG          C20200723-000010 [SCM PI팀] I/F Blocking 관련 (SSP - SCP Final Plan 동기화)
 *                             SSP용 Shipment Req 정보 생성 부분 제거 : PR_SCP_PLN_SSP_SHIP_REQ 로 별도 생성 
 * 2021.05.25   KSW          PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 플랜 대응
 * 2025.11.19   kimcd        [PJ2025F254]  JV법인 ESS 혼용 생산 시스템 개선
 *                           JV ESS 생산에 따른 가상 Plant 출하 계획 정보 복사
 * 2026.05.22	ymh			E20260331-000738 82사업부 MA Plan 수행 시 속도지연
 */    
    
CREATE PROCEDURE [dbo].[PR_SCP_ANL_SHIPMENT_PLAN_SEMI]
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
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SCP_ANL_SHIPMENT_PLAN_SEMI';        
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...        
    DECLARE @n_log_count    INTEGER = 0;        
    DECLARE @v_log_message  NVARCHAR(1000);        
    DECLARE @v_description  NVARCHAR(500);      
    DECLARE @v_table_id     NVARCHAR(150) = N'SCM_SYS_LOG_BATC';     
    DECLARE @d_event_date   DATETIME;        
    
  -- 시작 LOG        
    SET @v_log_type = N'START';        
    SET @v_log_message = N'########## Start of procedure ##########';        
    SET @v_description = @v_program_name + ':' + N' PR_SCP_ANL_SHIPMENT_PLAN_SEMI INSERT LOGIC';        
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
          IF OBJECT_ID('tempdb..#tmp_SCP_ANL_SHIPMENT_PLAN_SEMI') IS NOT NULL                  
              DROP TABLE #tmp_SCP_ANL_SHIPMENT_PLAN_SEMI    
    
            CREATE TABLE #tmp_SCP_ANL_SHIPMENT_PLAN_SEMI(    
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
    
    
			-- * 2021.05.25   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 플랜 대응 - start
			DECLARE @v_pet_date		NVARCHAR(12) = '';

			--  Plan End Date
			SELECT @v_pet_date = p.horizon_end_date
			FROM   dbo.scm_mst_plan p WITH(NOLOCK)
			WHERE  p.division_id = @p_division_id
			AND    p.plan_id     = @p_plan_id ;

			SET @v_pet_date = CONVERT(VARCHAR(8), DATEADD(DAY, 1, CONVERT(DATETIME, @v_pet_date, 112)), 112);
			-- * 2021-05-25   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 플랜 대응 - end


            -------------------------------------------------------------------------------------------------------------     
            -- 1. SHIP_REQ 입력 (SEMI)  : 셀 출하요청 수량    
            -------------------------------------------------------------------------------------------------------------     

            
              INSERT INTO #tmp_SCP_ANL_SHIPMENT_PLAN_SEMI    
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
                   SELECT    B.ENG_DEMAND_ID,                      
                          B.DIVISION_ID                        
                         ,B.PLAN_START_YYYYMMDD                      -- plan주의 월요일  ,dbo.FN_GET_BUCKET_YYYYMMDD(0)                         
                         ,B.PLAN_TYPE                        
                         ,B.SEQ                          
                         ,B.OPERATION_GROUP                     
                         ,B.PROJECT_CODE                        
                         ,B.ITEM_ID                        
                         ,B.TO_SITE  
                         ,B.INCOTERMS                         
                         ,B.FROM_SITE                        
                         ,B.BOD_ID                         
                         ,B.TRANSPORT_MODE                        
                         ,B.MEASURE                         
                         ,B.YYYYMMDD                        
                         ,B.ALLOCATION_QTY         AS QTY           
                         ,B.ORIGIN_FROM_DIVISION_ID
                         ,B.ORIGIN_TO_DIVISION_ID
                         ,B.ELECTRODE_TYPE             
                     FROM SCP_PLN_SHIPMENT_PLAN B WITH (NOLOCK)                   
                    WHERE 1 = 1                        
                      AND B.DIVISION_ID         = @p_division_id                      
                      AND B.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd                          
                      AND B.PLAN_TYPE           = @p_plan_type                        
                      AND B.SEQ                 = @p_seq       
                      AND B.DIVISION_ID         IS NOT NULL
                      AND B.MEASURE               = 'SHIP_REQ'                         
                      AND B.SEMI_YN               = 'Y'             
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

              INSERT INTO #tmp_SCP_ANL_SHIPMENT_PLAN_SEMI    
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
                      FROM DBO.SCP_PLN_SHIPMENT_PLAN A WITH (NOLOCK)     
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
             INSERT INTO #tmp_SCP_ANL_SHIPMENT_PLAN_SEMI    
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
          FROM  #tmp_SCP_ANL_SHIPMENT_PLAN_SEMI WITH (NOLOCK)     
          WHERE MEASURE ='SHIP_PLAN'    
    
          -------------------------------------------------------------------------------------------------------------     
          -- 4. CHAR_COMPLETED_QTY 입력(셀) : 셀 특성완료일자별 수량    
          -------------------------------------------------------------------------------------------------------------  
   
             INSERT INTO #tmp_SCP_ANL_SHIPMENT_PLAN_SEMI    
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
                  FROM SCP_PLN_PRODUCTION_PLAN A WITH (NOLOCK)    
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
             INSERT INTO #tmp_SCP_ANL_SHIPMENT_PLAN_SEMI    
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
                  FROM SCP_PLN_PRODUCTION_PLAN A WITH (NOLOCK)    
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
          FROM #tmp_SCP_ANL_SHIPMENT_PLAN_SEMI      
          WHERE DIVISION_ID                   = @P_DIVISION_ID              
             AND PLAN_START_YYYYMMDD          = @P_PLAN_START_YYYYMMDD      
             AND PLAN_TYPE                    = @P_PLAN_TYPE                
             AND SEQ                          = @P_SEQ                      
             AND NOT EXISTS ( SELECT 'X'    
                                FROM #tmp_SCP_ANL_SHIPMENT_PLAN_SEMI X WITH(NOLOCK)    
                               WHERE X.DIVISION_ID              = @P_DIVISION_ID              
                                 AND X.PLAN_START_YYYYMMDD      = @P_PLAN_START_YYYYMMDD      
                                 AND X.PLAN_TYPE                = @P_PLAN_TYPE                
                                 AND X.SEQ                      = @P_SEQ                      
                                 AND X.MEASURE                  ='SHIP_PLAN'    
                                 AND X.ITEM_ID                  = #tmp_SCP_ANL_SHIPMENT_PLAN_SEMI.ITEM_ID    
                                 AND X.FROM_SITE                = #tmp_SCP_ANL_SHIPMENT_PLAN_SEMI.FROM_SITE    
                                 --AND X.ORIGIN_FROM_DIVISION_ID  = #tmp_SCP_ANL_SHIPMENT_PLAN_SEMI.ORIGIN_FROM_DIVISION_ID    
                                 --AND X.ORIGIN_TO_DIVISION_ID    = #tmp_SCP_ANL_SHIPMENT_PLAN_SEMI.ORIGIN_TO_DIVISION_ID    
                                 --AND X.ELECTRODE_TYPE           = #tmp_SCP_ANL_SHIPMENT_PLAN_SEMI.ELECTRODE_TYPE    
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
                                           

                INSERT INTO #tmp_SCP_ANL_SHIPMENT_PLAN_SEMI                
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
                                    AND C.BASIS_YYYYMMDD <  @v_pet_date		--CONVERT(VARCHAR,DATEADD(D,364,CONVERT(DATETIME,@p_plan_start_yyyymmdd,112)),112)      -- * 2021-05-25   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 플랜 대응
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
                                  FROM #tmp_SCP_ANL_SHIPMENT_PLAN_SEMI X WITH(NOLOCK)        
                                 WHERE 1=1      
                                 AND (CASE WHEN @X_MEASURE  = 'CHAR_COMPLETED_QTY' THEN 'A' 
                                           WHEN @X_MEASURE  = 'COMPLETED_QTY'      THEN 'E' 
                                            ELSE X.OPERATION_GROUP  END ) = X.OPERATION_GROUP     
                              ) B        
                    ) SUB        
                    WHERE 1=1        
                      AND NOT EXISTS (        
                                       SELECT 'X'        
                                         FROM #tmp_SCP_ANL_SHIPMENT_PLAN_SEMI Z WITH(NOLOCK)        
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

            INSERT INTO #tmp_SCP_ANL_SHIPMENT_PLAN_SEMI                
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
                                AND C.BASIS_YYYYMMDD <  @v_pet_date		--CONVERT(VARCHAR,DATEADD(D,364,CONVERT(DATETIME,@p_plan_start_yyyymmdd,112)),112)      -- * 2021-05-25   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 플랜 대응
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
                              FROM #tmp_SCP_ANL_SHIPMENT_PLAN_SEMI X WITH(NOLOCK)        
                             WHERE 1=1      
                          ) B        
                ) SUB        
                WHERE 1=1        
                  AND NOT EXISTS (        
                                   SELECT 'X'        
                                     FROM #tmp_SCP_ANL_SHIPMENT_PLAN_SEMI Z WITH(NOLOCK)        
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
                 FROM #tmp_SCP_ANL_SHIPMENT_PLAN_SEMI A with (nolock)  
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
                FROM #tmp_SCP_ANL_SHIPMENT_PLAN_SEMI X with (nolock)  
                INNER JOIN #Update Y with (nolock)  
                ON  0 = 0  
                  AND X.OPERATION_GROUP     = Y.OPERATION_GROUP  
                  AND X.ITEM_ID             = Y.ITEM_ID  
                  AND X.FROM_SITE           = Y.FROM_SITE  
                  AND X.TO_SITE             = Y.TO_SITE  
                  AND X.BOD_ID              = Y.BOD_ID               
                  AND X.TRANSPORT_MODE      = Y.TRANSPORT_MODE  
                  AND X.MEASURE             = 'SHIP_REQ'  
                  AND X.MEASURE             = Y.MEASURE              
                  AND X.YYYYMMDD            = X.PLAN_START_YYYYMMDD -- @p_plan_start_yyyymmdd     
                 
               -- PLAN_START_YYYYMMDD 보다 작은 값은 삭제  
               DELETE FROM  #tmp_SCP_ANL_SHIPMENT_PLAN_SEMI WHERE YYYYMMDD < PLAN_START_YYYYMMDD  
  
          -------------------------------------------------------------------------------------------------------------                 
          -- 9. SHIP_REQ_CELL_QTY,SHIP_PLAN_CELL_QTY,SHIP_PLAN_AMEND_CELL_QTY  추가 (전극,셀)    
          -------------------------------------------------------------------------------------------------------------    
          -- 속도 때문에 CELL 환산비율 #ELEC_CELL_PER_METER 테이블 생성    (dbo.FN_GET_ELEC_CELL_PER_METER 참조)

          /*
          SELECT  C.DIVISION_ID, C.ITEM_ID, C.VALUE   -- , *
          INTO #ELEC_CELL_PER_METER    
          FROM SCM_MST_ITEM_CONV_CALC_SN C WITH(NOLOCK),  -- FACTORY별로 여러건이 존재함.      
              SCM_MST_ITEM_SN           I WITH(NOLOCK)      
          WHERE 1=1      
--          AND C.DIVISION_ID              = @p_division_id_Cell               
          AND C.SITE_ID                  = ISNULL(NULL,C.SITE_ID)      
          AND C.PLANT_ID                 = ISNULL(null,C.PLANT_ID)      
          AND C.ITEM_ID                  IN ( SELECT DISTINCT ITEM_ID FROM #tmp_SCP_ANL_SHIPMENT_PLAN_SEMI WITH (NOLOCK) WHERE MEASURE   IN ('SHIP_REQ' ,'SHIP_PLAN','SHIP_PLAN_AMEND'))    
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
              AND A.CHILD_ITEM_ID     IN ( SELECT DISTINCT ITEM_ID FROM #tmp_SCP_ANL_SHIPMENT_PLAN_SEMI WITH (NOLOCK) WHERE MEASURE   IN ('SHIP_REQ' ,'SHIP_PLAN','SHIP_PLAN_AMEND'))    
              AND A.MODEL_ID        LIKE '_C%' --CELL
              AND A.OPERATION_GROUP_ID = 'E'   --CHILD IS ELECTRODE


           INSERT INTO #tmp_SCP_ANL_SHIPMENT_PLAN_SEMI    
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
             FROM #tmp_SCP_ANL_SHIPMENT_PLAN_SEMI X WITH (NOLOCK)    
             WHERE X.MEASURE   IN ('SHIP_REQ' ,'SHIP_PLAN','SHIP_PLAN_AMEND')    
               AND X.OPERATION_GROUP ='E' 
             ;       
         */


         INSERT INTO #tmp_SCP_ANL_SHIPMENT_PLAN_SEMI    
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
             FROM #tmp_SCP_ANL_SHIPMENT_PLAN_SEMI X WITH (NOLOCK)    
             WHERE X.MEASURE   IN ('SHIP_REQ' ,'SHIP_PLAN','SHIP_PLAN_AMEND')    
               AND X.OPERATION_GROUP ='E' 
             ;       

    
        -------------------------------------------------------------------------------------------------------------                 
        -- 10. INVENTORY 계산값 생성       
        --Inventory = BOH - Ship plan + Complate QTY     
        --Inventory = Inventory - Ship plan + Complate QTY     
        -- [dbo].[FN_GET_SCP_ANL_CHAR_BOH_QTY]    
        --           and stock_type                IN ('CHAR','A_MOVE_WH','A_OUT_WH') --특성완료재고        
        -------------------------------------------------------------------------------------------------------------       
    
    
            -- INVENTORY 속도 때문에 CLUSTERED INDEX 추가 함.    
            --DROP INDEX #tmp_SCP_ANL_SHIPMENT_PLAN_SEMI.IX01_#tmp_SCP_ANL_SHIPMENT_PLAN_SEMI    
            CREATE CLUSTERED INDEX [IX01_#tmp_SCP_ANL_SHIPMENT_PLAN_SEMI] ON #tmp_SCP_ANL_SHIPMENT_PLAN_SEMI    
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
                          FROM #tmp_SCP_ANL_SHIPMENT_PLAN_SEMI Z WITH(NOLOCK)       
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
                         from scp_pln_plant_onhand with(nolock)        
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
              INSERT INTO #tmp_SCP_ANL_SHIPMENT_PLAN_SEMI             
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
--                            FROM dbo.SCP_ANL_SHIPMENT_PLAN_SEMI X WITH(NOLOCK)       
                            FROM #tmp_SCP_ANL_SHIPMENT_PLAN_SEMI X WITH (NOLOCK)    
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
              FROM #tmp_SCP_ANL_SHIPMENT_PLAN_SEMI X WITH (NOLOCK)
              LEFT OUTER JOIN DBO.SCM_MST_SITE Y  WITH (NOLOCK)       -- from   PLANT_SITE_ID
                           ON 0 = 0
--                          AND Y.SITE_TYPE   = 'PLANT'    
                          AND Y.SCM_SITE_ID  = X.FROM_SITE
                          AND Y.VALID_YN ='Y'   

            UPDATE X
               SET X.ORIGIN_TO_DIVISION_ID = Y.DIVISION_ID
              FROM #tmp_SCP_ANL_SHIPMENT_PLAN_SEMI X WITH (NOLOCK)
              LEFT OUTER JOIN DBO.SCM_MST_SITE Y  WITH (NOLOCK)       -- to   SALES_SITE_ID
                           ON 0 = 0
--                          AND Y.SITE_TYPE   = 'PLANT'    
                          AND Y.SCM_SITE_ID  = X.TO_SITE
                          AND Y.VALID_YN ='Y'          



             UPDATE X  
               SET X.ELECTRODE_TYPE = ISNULL(Y.ELECTRODE_TYPE,''), X.OPERATION_GROUP = Y.OPERATION_GROUP  
              FROM #tmp_SCP_ANL_SHIPMENT_PLAN_SEMI X WITH (NOLOCK)  
              INNER JOIN DBO.SCP_MST_FINAL_ITEM_V Y  WITH (NOLOCK)         
                    ON 0 = 0
                   AND X.DIVISION_ID      = @p_division_id      
                   AND X.ITEM_ID          = Y.ITEM_ID             

          -------------------------------------------------------------------------------------------------------------     
          -- 12. SCP_ANL_SHIPMENT_PLAN_SEMI 삭제     
          -------------------------------------------------------------------------------------------------------------    
            DELETE     
            FROM SCP_ANL_SHIPMENT_PLAN_SEMI
            WHERE DIVISION_ID         = @p_division_id     
              AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd     
              AND PLAN_TYPE           = @p_plan_type     
              AND SEQ                 = @p_seq    
              
              --SELECT * INTO SCP_ANL_SHIPMENT_PLAN_SEMI_20190515 FROM SCP_ANL_SHIPMENT_PLAN_SEMI WHERE 0 = 1
          -------------------------------------------------------------------------------------------------------------     
          -- 13. SCP_ANL_SHIPMENT_PLAN_SEMI 입력     
          -------------------------------------------------------------------------------------------------------------    

           INSERT INTO /* PR_SCP_ANL_SHIPMENT_PLAN_SEMI */ dbo.SCP_ANL_SHIPMENT_PLAN_SEMI
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
                  ,ISNULL(ORIGIN_TO_DIVISION_ID,'')
                  ,ELECTRODE_TYPE 
                  ,SUM(QTY) AS QTY
                  ,@v_batch_user AS CREATED_BY    
                  ,GETDATE()     AS CREATION_DATE    
                  ,@v_batch_user AS LAST_UPDATED_BY    
                  ,GETDATE()     AS LAST_UPDATED_BY    
              FROM #tmp_SCP_ANL_SHIPMENT_PLAN_SEMI WITH (NOLOCK)    
              WHERE 1=1    
              AND YYYYMMDD < @v_pet_date		--CONVERT(VARCHAR,DATEADD(D,364,CONVERT(DATETIME,@p_plan_start_yyyymmdd,112)),112)       -- * 2021-05-25   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 플랜 대응
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


		-- [PJ2025F254]  JV법인 ESS 혼용 생산 시스템 개선 JV ESS 생산에 따른 가상 Plant 계획 정보 복사 시작
        SET @v_log_message = N'########## Copy from Virtual Plant ##########';
        SET @v_description = @v_program_name + ':' + N' Check Plan Copy Division';
        SET @d_event_date = SYSDATETIME();
		EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
								  ,@p_log_type      =@v_log_type
								  ,@p_log_count     =@n_log_count 
								  ,@p_log_message   =@v_log_message 
								  ,@p_description   =@v_description 
								  ,@p_event_date    =@d_event_date 
								  ,@p_user_id       =@v_batch_user
								  ;

		DECLARE @v_to_division_id    NVARCHAR(30);
		DECLARE @v_from_division_id    NVARCHAR(30);

		SELECT  TOP 1 @v_to_division_id = MS2.DIVISION_ID
		FROM    SCM_MST_SITE MS WITH(NOLOCK)
		        INNER JOIN SCM_MST_SITE MS2 WITH(NOLOCK)
				    ON MS.ATTRIBUTE9 = MS2.SCM_SITE_ID
		WHERE   MS.DIVISION_ID = @p_division_id
		AND     MS.SITE_TYPE   = 'PLANT'
		AND     MS.VALID_YN    = 'Y';

		IF @v_to_division_id > ''
		    BEGIN
				SET @v_log_message = N'########## copy from Virtual Plant ##########';
				SET @v_description = @v_program_name + ':' + N' copy from current Division';
				SET @d_event_date = SYSDATETIME();
				EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
										  ,@p_log_type      =@v_log_type
										  ,@p_log_count     =@n_log_count 
										  ,@p_log_message   =@v_log_message 
										  ,@p_description   =@v_description 
										  ,@p_event_date    =@d_event_date 
										  ,@p_user_id       =@v_batch_user
										  ;


                -- E20260331-000738 82사업부 MA Plan 수행 시 속도지연 신규로직 시작
                IF OBJECT_ID('tempdb..#PLAN_SEQ') IS NOT NULL                  
                    DROP TABLE #PLAN_SEQ    

                IF OBJECT_ID('tempdb..#LINE_SITE') IS NOT NULL                  
                    DROP TABLE #LINE_SITE

                SELECT PD.MODELING_ID, PD.PLAN_SEQ, PD.PLAN_TYPE, PM.DIVISION_ID+'::'+ PM.PLAN_CYCLE AS MASTER_ID, PM.PLAN_ID + '::' + PD.PLAN_TYPE + '::' + CONVERT(NVARCHAR(30),PD.PLAN_SEQ)  AS ENGINE_PLAN_ID
						,PM.DIVISION_ID
						,ROW_NUMBER() OVER (PARTITION BY PM.DIVISION_ID
											ORDER BY  CASE PD.PLAN_TYPE WHEN 'FN' THEN 1 WHEN 'SE' THEN 2 WHEN 'MA' THEN 3 WHEN 'PR' THEN 4 ELSE 5 END
													,CASE WHEN PD.CONFIRM_FLAG = 'Y' THEN 1 ELSE 2 END
													,PD.PLAN_SEQ DESC) AS NUM
                    INTO #PLAN_SEQ
				FROM   SCM_MST_PLAN        PM WITH(NOLOCK)
						INNER JOIN SCM_MST_PLAN_DETAIL PD WITH(NOLOCK)
   							ON  PM.PLAN_ID     = PD.PLAN_ID
							AND PM.DIVISION_ID = PD.DIVISION_ID
				WHERE  PM.DIVISION_ID        IN (	SELECT DISTINCT MS2.DIVISION_ID
													FROM    SCM_MST_SITE MS WITH(NOLOCK)
															INNER JOIN SCM_MST_SITE MS2 WITH(NOLOCK)
																ON MS.ATTRIBUTE9 = MS2.SCM_SITE_ID  -- 실제 생산 Site가 Attribute9에 관리됨
													WHERE   MS.DIVISION_ID = @p_division_id
													AND     MS.SITE_TYPE   = 'PLANT'
													AND     MS.VALID_YN    = 'Y')
				AND    PM.PLAN_ID            = @p_plan_id
				AND    PM.PLAN_CYCLE         = @p_plan_cycle
				AND    PD.PLAN_STATUS        = '1'
				AND    PD.DISPLAY_YN         = 'Y'
				AND    PD.UI_DISPLAY_YN      = 'Y'
				AND    PD.NORMAL_COMPLETE_YN = 'Y'
				AND    PD.ACTIVE_FLAG        = 'Y' 

                SELECT MS2.DIVISION_ID, MS2.SCM_SITE_ID, SAPI.ITEM_ID
                    INTO #LINE_SITE
				FROM   SCM_MST_SITE MS WITH(NOLOCK)
						INNER JOIN SCM_MST_SITE MS2 WITH(NOLOCK)
							ON MS.ATTRIBUTE9 = MS2.SCM_SITE_ID  -- 실제 생산 Site가 Attribute9에 관리됨
						INNER JOIN SCP_ANL_SHIPMENT_PLAN_SEMI SAPI WITH(NOLOCK)
							ON SAPI.FROM_SITE = MS.SCM_SITE_ID
				WHERE   MS.DIVISION_ID   = @p_division_id
				AND     MS.SITE_TYPE     = 'PLANT'
				AND     MS.VALID_YN      = 'Y'
				AND     SAPI.PLAN_TYPE   = @p_plan_type
				AND     SAPI.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
				AND     SAPI.SEQ         = @p_seq
				AND     SAPI.DIVISION_ID = @p_division_id
				GROUP   BY SAPI.ITEM_ID, MS2.DIVISION_ID, MS2.SCM_SITE_ID 

                CREATE INDEX IX_TMP_PLAN_SEQ
                ON #PLAN_SEQ
                (
                    DIVISION_ID,
                    PLAN_TYPE,
                    PLAN_SEQ
                )
                ;

                CREATE INDEX IX_TMP_LINE_SITE
                ON #LINE_SITE
                (
                DIVISION_ID,
                SCM_SITE_ID,
                ITEM_ID
                )
                ;

                DELETE SAP
				FROM   SCP_ANL_SHIPMENT_PLAN_SEMI SAP
                    JOIN #PLAN_SEQ PS
                    ON SAP.PLAN_TYPE   = PS.PLAN_TYPE
                    AND SAP.SEQ        = PS.PLAN_SEQ
                    AND SAP.DIVISION_ID= PS.DIVISION_ID
                    JOIN #LINE_SITE LS
                    ON SAP.DIVISION_ID  = LS.DIVISION_ID
                    AND SAP.FROM_SITE   = LS.SCM_SITE_ID
                    AND SAP.ITEM_ID     = LS.ITEM_ID
                WHERE SAP.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
				;
                -- E20260331-000738 82사업부 MA Plan 수행 시 속도지연 신규로직 끝

                -- E20260331-000738 82사업부 MA Plan 수행 시 속도지연 기존로직 주석처리.
                /* 
                DELETE SAP
				FROM   SCP_ANL_SHIPMENT_PLAN_SEMI SAP
                	   INNER JOIN ( SELECT MODELING_ID, PLAN_SEQ, PLAN_TYPE, MASTER_ID, ENGINE_PLAN_ID, DIVISION_ID
									FROM  (SELECT PD.MODELING_ID, PD.PLAN_SEQ, PD.PLAN_TYPE, PM.DIVISION_ID+'::'+ PM.PLAN_CYCLE AS MASTER_ID, PM.PLAN_ID + '::' + PD.PLAN_TYPE + '::' + CONVERT(NVARCHAR(30),PD.PLAN_SEQ)  AS ENGINE_PLAN_ID
									             ,PM.DIVISION_ID
												 ,ROW_NUMBER() OVER (PARTITION BY PM.DIVISION_ID
																	 ORDER BY  CASE PD.PLAN_TYPE WHEN 'FN' THEN 1 WHEN 'SE' THEN 2 WHEN 'MA' THEN 3 WHEN 'PR' THEN 4 ELSE 5 END
																			  ,CASE WHEN PD.CONFIRM_FLAG = 'Y' THEN 1 ELSE 2 END
																			  ,PD.PLAN_SEQ DESC) AS NUM
											FROM   SCM_MST_PLAN        PM WITH(NOLOCK)
											       INNER JOIN SCM_MST_PLAN_DETAIL PD WITH(NOLOCK)
   												       ON  PM.PLAN_ID     = PD.PLAN_ID
													   AND PM.DIVISION_ID = PD.DIVISION_ID
											WHERE  PM.DIVISION_ID        IN (	SELECT DISTINCT MS2.DIVISION_ID
																				FROM    SCM_MST_SITE MS WITH(NOLOCK)
																						INNER JOIN SCM_MST_SITE MS2 WITH(NOLOCK)
																							ON MS.ATTRIBUTE9 = MS2.SCM_SITE_ID  -- 실제 생산 Site가 Attribute9에 관리됨
																				WHERE   MS.DIVISION_ID = @p_division_id
																				AND     MS.SITE_TYPE   = 'PLANT'
																				AND     MS.VALID_YN    = 'Y')
											AND    PM.PLAN_ID            = @p_plan_id
											AND    PM.PLAN_CYCLE         = @p_plan_cycle
											AND    PD.PLAN_STATUS        = '1'
											AND    PD.DISPLAY_YN         = 'Y'
											AND    PD.UI_DISPLAY_YN      = 'Y'
											AND    PD.NORMAL_COMPLETE_YN = 'Y'
											AND    PD.ACTIVE_FLAG        = 'Y' ) TP
									WHERE NUM = 1 ) PS
							ON  SAP.PLAN_TYPE   = PS.PLAN_TYPE
							AND SAP.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
							AND SAP.SEQ         = PS.PLAN_SEQ
							AND SAP.DIVISION_ID = PS.DIVISION_ID
						INNER JOIN ( SELECT MS2.DIVISION_ID, MS2.SCM_SITE_ID, SAPI.ITEM_ID
									 FROM   SCM_MST_SITE MS WITH(NOLOCK)
											INNER JOIN SCM_MST_SITE MS2 WITH(NOLOCK)
												ON MS.ATTRIBUTE9 = MS2.SCM_SITE_ID  -- 실제 생산 Site가 Attribute9에 관리됨
											INNER JOIN SCP_ANL_SHIPMENT_PLAN_SEMI SAPI WITH(NOLOCK)
											    ON SAPI.FROM_SITE = MS.SCM_SITE_ID
									WHERE   MS.DIVISION_ID   = @p_division_id
									AND     MS.SITE_TYPE     = 'PLANT'
									AND     MS.VALID_YN      = 'Y'
									AND     SAPI.PLAN_TYPE   = @p_plan_type
									AND     SAPI.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
									AND     SAPI.SEQ         = @p_seq
									AND     SAPI.DIVISION_ID = @p_division_id
									GROUP   BY SAPI.ITEM_ID, MS2.DIVISION_ID, MS2.SCM_SITE_ID ) MS2  -- ESS를 생산 지원해서 자동차와 중복 생산하는 제품이 없어야 함. 자동차와 중복되는 품목이 있다면 해당 계획도 삭제됨
							ON  SAP.DIVISION_ID = MS2.DIVISION_ID
							AND SAP.FROM_SITE   = MS2.SCM_SITE_ID
							AND SAP.ITEM_ID     = MS2.ITEM_ID
				WHERE SAP.PLAN_START_YYYYMMDD   = @p_plan_start_yyyymmdd;

                */


			    WITH PLAN_SEQ AS (  SELECT MODELING_ID, PLAN_SEQ, PLAN_TYPE, MASTER_ID, ENGINE_PLAN_ID, DIVISION_ID
									FROM  (SELECT PD.MODELING_ID, PD.PLAN_SEQ, PD.PLAN_TYPE, PM.DIVISION_ID+'::'+ PM.PLAN_CYCLE AS MASTER_ID, PM.PLAN_ID + '::' + PD.PLAN_TYPE + '::' + CONVERT(NVARCHAR(30),PD.PLAN_SEQ)  AS ENGINE_PLAN_ID
									             ,PM.DIVISION_ID
												 ,ROW_NUMBER() OVER (PARTITION BY PM.DIVISION_ID
																	 ORDER BY  CASE PD.PLAN_TYPE WHEN 'FN' THEN 1 WHEN 'SE' THEN 2 WHEN 'MA' THEN 3 WHEN 'PR' THEN 4 ELSE 5 END
																			  ,CASE WHEN PD.CONFIRM_FLAG = 'Y' THEN 1 ELSE 2 END
																			  ,PD.PLAN_SEQ DESC) AS NUM
											FROM   SCM_MST_PLAN        PM WITH(NOLOCK)
											       INNER JOIN SCM_MST_PLAN_DETAIL PD WITH(NOLOCK)
   												       ON  PM.PLAN_ID     = PD.PLAN_ID
													   AND PM.DIVISION_ID = PD.DIVISION_ID
											WHERE  PM.DIVISION_ID        IN (	SELECT DISTINCT MS2.DIVISION_ID
																				FROM    SCM_MST_SITE MS WITH(NOLOCK)
																						INNER JOIN SCM_MST_SITE MS2 WITH(NOLOCK)
																							ON MS.ATTRIBUTE9 = MS2.SCM_SITE_ID  -- 실제 생산 Site가 Attribute9에 관리됨
																				WHERE   MS.DIVISION_ID = @p_division_id
																				AND     MS.SITE_TYPE   = 'PLANT'
																				AND     MS.VALID_YN    = 'Y')
											AND    PM.PLAN_ID            = @p_plan_id
											AND    PM.PLAN_CYCLE         = @p_plan_cycle
											AND    PD.PLAN_STATUS        = '1'
											AND    PD.DISPLAY_YN         = 'Y'
											AND    PD.UI_DISPLAY_YN      = 'Y'
											AND    PD.NORMAL_COMPLETE_YN = 'Y'
											AND    PD.ACTIVE_FLAG        = 'Y' ) TP
									WHERE NUM = 1 )
	            INSERT INTO /* PR_SCP_ANL_SHIPMENT_PLAN_SEMI */ dbo.SCP_ANL_SHIPMENT_PLAN_SEMI
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
                   PS.DIVISION_ID    
                  ,X.PLAN_START_YYYYMMDD    
                  ,PS.PLAN_TYPE    
                  ,PS.PLAN_SEQ     AS SEQ    
                  ,ISNULL(X.OPERATION_GROUP,'')    
                  ,X.ITEM_ID    
                  ,MS2.SCM_SITE_ID AS FROM_SITE    
                  ,X.TO_SITE
                  ,X.BOD_ID
                  ,X.MEASURE
                  ,X.YYYYMMDD
                  ,PS.DIVISION_ID AS ORIGIN_FROM_DIVISION_ID
                  ,CASE WHEN X.ORIGIN_TO_DIVISION_ID = '' THEN '' ELSE PS.DIVISION_ID END AS ORIGIN_TO_DIVISION_ID
                  ,X.ELECTRODE_TYPE 
                  ,X.QTY AS QTY
                  ,@v_batch_user AS CREATED_BY    
                  ,GETDATE()     AS CREATION_DATE    
                  ,@v_batch_user AS LAST_UPDATED_BY    
                  ,GETDATE()     AS LAST_UPDATED_BY    
              FROM ( SELECT DIVISION_ID    
						   ,PLAN_START_YYYYMMDD    
						   ,PLAN_TYPE    
						   ,SEQ    
						   ,ISNULL(OPERATION_GROUP,'')         AS OPERATION_GROUP
						   ,ITEM_ID    
						   ,FROM_SITE    
						   ,TO_SITE    
						   ,BOD_ID  
						   ,MEASURE    
						   ,YYYYMMDD    
						   ,ISNULL(ORIGIN_FROM_DIVISION_ID,'') AS ORIGIN_FROM_DIVISION_ID
						   ,ISNULL(ORIGIN_TO_DIVISION_ID,'')   AS ORIGIN_TO_DIVISION_ID
						   ,ELECTRODE_TYPE 
						   ,SUM(QTY)                           AS QTY
			         FROM   #tmp_SCP_ANL_SHIPMENT_PLAN_SEMI WITH (NOLOCK)    
                     WHERE  1=1    
                     AND    YYYYMMDD < @v_pet_date
                     GROUP BY  
                           DIVISION_ID    
                          ,PLAN_START_YYYYMMDD    
                          ,PLAN_TYPE    
                          ,SEQ    
                          ,ISNULL(OPERATION_GROUP,'')
                          ,ITEM_ID    
                          ,FROM_SITE    
                          ,TO_SITE  
						  ,BOD_ID  
                          ,MEASURE    
                          ,YYYYMMDD    
                          ,ISNULL(ORIGIN_FROM_DIVISION_ID,'')
                          ,ISNULL(ORIGIN_TO_DIVISION_ID,'')
                          ,ELECTRODE_TYPE           ) AS X
					INNER JOIN SCM_MST_SITE MS WITH(NOLOCK)
						ON  X.DIVISION_ID = MS.division_id
						AND X.FROM_SITE   = MS.SCM_SITE_ID
						AND MS.SITE_TYPE  = 'PLANT'
						AND MS.VALID_YN   = 'Y'
		            INNER JOIN SCM_MST_SITE MS2 WITH(NOLOCK)
				        ON MS.ATTRIBUTE9 = MS2.SCM_SITE_ID
					INNER JOIN PLAN_SEQ PS
						ON MS2.DIVISION_ID = PS.DIVISION_ID
						;
			END;
		ELSE -- IF @v_to_division_id > ''
		    BEGIN
				SELECT  TOP 1 @v_from_division_id = MS2.DIVISION_ID
				FROM    SCM_MST_SITE MS WITH(NOLOCK)
						INNER JOIN SCM_MST_SITE MS2 WITH(NOLOCK)
							ON MS.SCM_SITE_ID = MS2.ATTRIBUTE9
				WHERE   MS.DIVISION_ID = @p_division_id
				AND     MS.SITE_TYPE   = 'PLANT'
				AND     MS.VALID_YN    = 'Y';

				IF @v_from_division_id > ''
				    BEGIN
						SET @v_log_message = N'########## copy to Current Division ##########';
						SET @v_description = @v_program_name + ':' + N' copy to current Division';
						SET @d_event_date = SYSDATETIME();
						EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
												  ,@p_log_type      =@v_log_type
												  ,@p_log_count     =@n_log_count 
												  ,@p_log_message   =@v_log_message 
												  ,@p_description   =@v_description 
												  ,@p_event_date    =@d_event_date 
												  ,@p_user_id       =@v_batch_user
												  ;

						WITH PLAN_SEQ AS (  SELECT MODELING_ID, PLAN_SEQ, PLAN_TYPE, MASTER_ID, ENGINE_PLAN_ID, DIVISION_ID
											FROM  (SELECT PD.MODELING_ID, PD.PLAN_SEQ, PD.PLAN_TYPE, PM.DIVISION_ID+'::'+ PM.PLAN_CYCLE AS MASTER_ID, PM.PLAN_ID + '::' + PD.PLAN_TYPE + '::' + CONVERT(NVARCHAR(30),PD.PLAN_SEQ)  AS ENGINE_PLAN_ID
														 ,PM.DIVISION_ID
														 ,ROW_NUMBER() OVER (PARTITION BY PM.DIVISION_ID
																			 ORDER BY  CASE PD.PLAN_TYPE WHEN 'FN' THEN 1 WHEN 'SE' THEN 2 WHEN 'MA' THEN 3 WHEN 'PR' THEN 4 ELSE 5 END
																					  ,CASE WHEN PD.CONFIRM_FLAG = 'Y' THEN 1 ELSE 2 END
																					  ,PD.PLAN_SEQ DESC) AS NUM
													FROM   SCM_MST_PLAN        PM WITH(NOLOCK)
														   INNER JOIN SCM_MST_PLAN_DETAIL PD WITH(NOLOCK)
		   												       ON  PM.PLAN_ID     = PD.PLAN_ID
															   AND PM.DIVISION_ID = PD.DIVISION_ID
													WHERE  PM.DIVISION_ID        IN (	SELECT  MS2.DIVISION_ID
																						FROM    SCM_MST_SITE MS WITH(NOLOCK)
																								INNER JOIN SCM_MST_SITE MS2 WITH(NOLOCK)
																									ON MS.SCM_SITE_ID = MS2.ATTRIBUTE9  -- 실제 생산 Site가 Attribute9에 관리됨
																						WHERE   MS.DIVISION_ID = @p_division_id
																						AND     MS.SITE_TYPE   = 'PLANT'
																						AND     MS.VALID_YN    = 'Y')
													AND    PM.PLAN_ID            = @p_plan_id
													AND    PM.PLAN_CYCLE         = @p_plan_cycle
													AND    PD.PLAN_STATUS        = '1'
													AND    PD.DISPLAY_YN         = 'Y'
													AND    PD.UI_DISPLAY_YN      = 'Y'
													AND    PD.NORMAL_COMPLETE_YN = 'Y'
													AND    PD.ACTIVE_FLAG        = 'Y' ) TP
											WHERE NUM = 1 )
						DELETE SAP
						FROM   SCP_ANL_SHIPMENT_PLAN_SEMI SAP
								INNER JOIN ( SELECT MS2.DIVISION_ID, MS2.SCM_SITE_ID, WO.ITEM_ID
											 FROM   SCP_ANL_SHIPMENT_PLAN_SEMI  AS wo WITH(NOLOCK)
													INNER JOIN SCM_MST_DIVISION AS dm WITH(NOLOCK)
															ON dm.DIVISION_ID = wo.DIVISION_ID
															AND dm.VALID_YN	 = 'Y'
													INNER JOIN PLAN_SEQ  PS --MODELING_ID, PLAN_SEQ, PLAN_TYPE, MASTER_ID, ENGINE_PLAN_ID, DIVISION_ID
									   					ON  wo.plan_type              = PS.PLAN_TYPE              --N'PR'             --
														AND wo.plan_start_yyyymmdd    = @p_plan_start_yyyymmdd    --N'20180702'       --
														AND wo.seq                    = PS.PLAN_SEQ               --N'11'             --
														AND wo.division_id            = PS.DIVISION_ID            --N'EE'             --
													INNER JOIN SCM_MST_SITE MS WITH(NOLOCK)
														ON  MS.DIVISION_ID = WO.DIVISION_ID
														AND MS.SCM_SITE_ID = WO.FROM_SITE
													INNER JOIN SCM_MST_SITE MS2 WITH(NOLOCK)
														ON MS.ATTRIBUTE9 = MS2.SCM_SITE_ID -- 실제 생산 Site가 Attribute9에 관리됨
											WHERE   MS2.DIVISION_ID = @p_division_id
											AND     MS.SITE_TYPE   = 'PLANT'
											AND     MS.VALID_YN    = 'Y'
											AND     MS2.SITE_TYPE  = 'PLANT'
											AND     MS2.VALID_YN   = 'Y'
											AND     WO.QTY         > 0
											GROUP   BY MS2.DIVISION_ID, MS2.SCM_SITE_ID, WO.ITEM_ID
											) MS
									ON  SAP.DIVISION_ID = MS.DIVISION_ID
									AND SAP.FROM_SITE   = MS.SCM_SITE_ID
									AND SAP.ITEM_ID     = MS.ITEM_ID
						WHERE SAP.PLAN_TYPE   = @p_plan_type
						AND   SAP.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
						AND   SAP.SEQ         = @p_seq
						AND   SAP.DIVISION_ID = @p_division_id;

						WITH PLAN_SEQ AS (  SELECT MODELING_ID, PLAN_SEQ, PLAN_TYPE, MASTER_ID, ENGINE_PLAN_ID, DIVISION_ID
											FROM  (SELECT PD.MODELING_ID, PD.PLAN_SEQ, PD.PLAN_TYPE, PM.DIVISION_ID+'::'+ PM.PLAN_CYCLE AS MASTER_ID, PM.PLAN_ID + '::' + PD.PLAN_TYPE + '::' + CONVERT(NVARCHAR(30),PD.PLAN_SEQ)  AS ENGINE_PLAN_ID
														 ,PM.DIVISION_ID
														 ,ROW_NUMBER() OVER (PARTITION BY PM.DIVISION_ID
																			 ORDER BY  CASE PD.PLAN_TYPE WHEN 'FN' THEN 1 WHEN 'SE' THEN 2 WHEN 'MA' THEN 3 WHEN 'PR' THEN 4 ELSE 5 END
																					  ,CASE WHEN PD.CONFIRM_FLAG = 'Y' THEN 1 ELSE 2 END
																					  ,PD.PLAN_SEQ DESC) AS NUM
													FROM   SCM_MST_PLAN        PM WITH(NOLOCK)
														   INNER JOIN SCM_MST_PLAN_DETAIL PD WITH(NOLOCK)
		   												       ON  PM.PLAN_ID     = PD.PLAN_ID
															   AND PM.DIVISION_ID = PD.DIVISION_ID
													WHERE  PM.DIVISION_ID        IN (	SELECT  MS2.DIVISION_ID
																						FROM    SCM_MST_SITE MS WITH(NOLOCK)
																								INNER JOIN SCM_MST_SITE MS2 WITH(NOLOCK)
																									ON MS.SCM_SITE_ID = MS2.ATTRIBUTE9  -- 실제 생산 Site가 Attribute9에 관리됨
																						WHERE   MS.DIVISION_ID = @p_division_id
																						AND     MS.SITE_TYPE   = 'PLANT'
																						AND     MS.VALID_YN    = 'Y')
													AND    PM.PLAN_ID            = @p_plan_id
													AND    PM.PLAN_CYCLE         = @p_plan_cycle
													AND    PD.PLAN_STATUS        = '1'
													AND    PD.DISPLAY_YN         = 'Y'
													AND    PD.UI_DISPLAY_YN      = 'Y'
													AND    PD.NORMAL_COMPLETE_YN = 'Y'
													AND    PD.ACTIVE_FLAG        = 'Y' ) TP
											WHERE NUM = 1 )
						INSERT INTO /* PR_SCP_ANL_SHIPMENT_PLAN_SEMI */ dbo.SCP_ANL_SHIPMENT_PLAN_SEMI
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
							   @p_division_id  AS DIVISION_ID    
							  ,X.PLAN_START_YYYYMMDD    
							  ,@p_plan_type    AS PLAN_TYPE    
							  ,@p_seq          AS SEQ    
							  ,ISNULL(X.OPERATION_GROUP,'')    
							  ,X.ITEM_ID    
							  ,MS2.SCM_SITE_ID AS FROM_SITE    
							  ,X.TO_SITE
							  ,X.BOD_ID
							  ,X.MEASURE
							  ,X.YYYYMMDD
							  ,@p_division_id  AS ORIGIN_FROM_DIVISION_ID
							  ,CASE WHEN X.ORIGIN_TO_DIVISION_ID = '' THEN '' ELSE @p_division_id END AS ORIGIN_TO_DIVISION_ID
							  ,X.ELECTRODE_TYPE 
							  ,X.QTY AS QTY
							  ,@v_batch_user AS CREATED_BY    
							  ,GETDATE()     AS CREATION_DATE    
							  ,@v_batch_user AS LAST_UPDATED_BY    
							  ,GETDATE()     AS LAST_UPDATED_BY    
						  FROM ( SELECT WO.DIVISION_ID    
									   ,WO.PLAN_START_YYYYMMDD    
									   ,WO.PLAN_TYPE    
									   ,WO.SEQ    
									   ,ISNULL(WO.OPERATION_GROUP,'')         AS OPERATION_GROUP
									   ,WO.ITEM_ID    
									   ,WO.FROM_SITE    
									   ,WO.TO_SITE    
									   ,WO.BOD_ID  
									   ,WO.MEASURE    
									   ,WO.YYYYMMDD    
									   ,ISNULL(WO.ORIGIN_FROM_DIVISION_ID,'') AS ORIGIN_FROM_DIVISION_ID
									   ,ISNULL(WO.ORIGIN_TO_DIVISION_ID,'')   AS ORIGIN_TO_DIVISION_ID
									   ,WO.ELECTRODE_TYPE 
									   ,SUM(WO.QTY)                           AS QTY
								 FROM   SCP_ANL_SHIPMENT_PLAN_SEMI WO WITH (NOLOCK)    
									   INNER JOIN SCM_MST_DIVISION AS dm WITH(NOLOCK)
											   ON dm.DIVISION_ID = wo.DIVISION_ID
											  AND dm.VALID_YN	 = 'Y'
									   INNER JOIN PLAN_SEQ  PS --MODELING_ID, PLAN_SEQ, PLAN_TYPE, MASTER_ID, ENGINE_PLAN_ID, DIVISION_ID
									   	    ON  wo.plan_type              = PS.PLAN_TYPE              --N'PR'             --
											AND wo.plan_start_yyyymmdd    = @p_plan_start_yyyymmdd    --N'20180702'       --
											AND wo.seq                    = PS.PLAN_SEQ               --N'11'             --
											AND wo.division_id            = PS.DIVISION_ID            --N'EE'             --
								 WHERE  1=1    
								 AND    WO.YYYYMMDD < @v_pet_date
								 GROUP BY  
									   WO.DIVISION_ID    
									  ,WO.PLAN_START_YYYYMMDD    
									  ,WO.PLAN_TYPE    
									  ,WO.SEQ    
									  ,ISNULL(WO.OPERATION_GROUP,'')
									  ,WO.ITEM_ID    
									  ,WO.FROM_SITE    
									  ,WO.TO_SITE    
									  ,WO.BOD_ID
									  ,WO.MEASURE    
									  ,WO.YYYYMMDD    
									  ,ISNULL(WO.ORIGIN_FROM_DIVISION_ID,'')
									  ,ISNULL(WO.ORIGIN_TO_DIVISION_ID,'')
									  ,WO.ELECTRODE_TYPE           ) AS X
								INNER JOIN SCM_MST_SITE MS WITH(NOLOCK)
									ON  X.DIVISION_ID = MS.division_id
									AND X.FROM_SITE   = MS.SCM_SITE_ID
									AND MS.SITE_TYPE   = 'PLANT'
									AND MS.VALID_YN    = 'Y'
								INNER JOIN SCM_MST_SITE MS2 WITH(NOLOCK)
									ON  MS.ATTRIBUTE9   = MS2.SCM_SITE_ID
								    AND MS2.DIVISION_ID = @p_division_id
								;
					END; -- IF @v_from_division_id > ''
			END; -- IF @v_to_division_id > ''
		-- [PJ2025F254]  JV법인 ESS 혼용 생산 시스템 개선 JV ESS 생산에 따른 가상 Plant 계획 정보 복사 끝


        -------------------------------------------------------------------------------------------------------------                         
        -- TEMPDB TABLE DROP                    
        -------------------------------------------------------------------------------------------------------------    
        IF OBJECT_ID('tempdb..#tmp_SCP_ANL_SHIPMENT_PLAN_SEMI') IS NOT NULL                  
            DROP TABLE #tmp_SCP_ANL_SHIPMENT_PLAN_SEMI
            
        IF OBJECT_ID('tempdb..#Update') IS NOT NULL
            DROP TABLE #Update

        -- E20260331-000738 82사업부 MA Plan 수행 시 속도지연 신규로직 시작
        IF OBJECT_ID('tempdb..#PLAN_SEQ') IS NOT NULL                  
            DROP TABLE #PLAN_SEQ    

        IF OBJECT_ID('tempdb..#LINE_SITE') IS NOT NULL                  
            DROP TABLE #LINE_SITE
        -- E20260331-000738 82사업부 MA Plan 수행 시 속도지연 신규로직 끝

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

    -------------------------------------------------------------------------------------------------------------     
    -- Start : SSP용 Shipment Req 관련 처리 : 20191007 추가 : 81/82 FN 시 수행
    --         Error 발생해도 Log만 남기고 Plan은 계속 진행하도록 할 것
    -------------------------------------------------------------------------------------------------------------  
    -- 20200728  C20200723-000010 [SCM PI팀] I/F Blocking 관련 (SSP - SCP Final Plan 동기화) : SSP용 Shipment Req 정보 생성 부분 제거 : PR_SCP_PLN_SSP_SHIP_REQ 로 별도 생성
    -------------------------------------------------------------------------------------------------------------     
    -- End : SSP용 Shipment Req 관련 처리
    -------------------------------------------------------------------------------------------------------------         
    
     -- 임시 운영반영시에 주석처리 할것.            
     SET @v_exec_time  =  REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +             
                          REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))             
            
    -- 종료 LOG    
    SET @v_log_type = N'END';    
    SET @v_log_message = N'########## END of procedure ##########';    
    SET @v_description  = N'[' + @p_master_id + ']['+@p_engine_plan_id+'][' + @v_exec_time + ']';    
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
