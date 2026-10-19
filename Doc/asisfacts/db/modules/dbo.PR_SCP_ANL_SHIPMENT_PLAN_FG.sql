
           
                    
           
/*                      
 * Program ID   : PR_SCP_ANL_SHIPMENT_PLAN_FG                        
 * Description  : PR_SCP_ANL_CREATE_DATA 에서 호출함.                      
 * OutTable     :                      
 * Execute      : EXEC PR_SCP_ANL_SHIPMENT_PLAN_FG @p_division_id = '81' ,@p_plan_start_yyyymmdd = '20180409',@p_plan_type='PR',@p_seq='1',@p_user_id='scp_batch'                      
 * Program History                      
 *===================================================================================================                      
 *   Date       In Charge      Description                      
 *===================================================================================================                      
 * 2018.01.31   KTH         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트                      
 * 2018.03.28   YYDOK       FG, SEMI PROCEDURE 분리                      
 * 2018.04.03   KTH         FG INTRANSIT 로직 수정              
 * 2018.04.17   YYDOK       UI의 모든 MEASURE에 대하여 데이타 생성하도록 로직보완           
 * 2018.05.15   YYDOK       화면에 ALLOCATION을 적용하면서 BOH를 BALANCE계산식에서 제외처리      
 *                          (ALLOCATION=RTF에는 BOH재고로 ALLOCATION된 수량이 포함되어 있음.)      
 * 2018.05.21   LTW         FG WH_IN MEASURE에 SCP_ANL_PROBLEM_REPORT_PEGGING 의 INTRANSIT 데이터 추가      
 * 2018.05.23   KTH         생성구간 364로 변경              
 * 2018.06.07   KTH         TRANSACTION 삭제    
 * 2018.06.15   KTH         from_site 변경 (dbo.fn_scm_split(a.stock_plan_lot_id,5,'::'))    
 * 2018.06.21   KTH         52주 364일 제한 로직 추가 AND YYYYMMDD < CONVERT(VARCHAR,DATEADD(D,364,CONVERT(DATETIME,@p_plan_start_yyyymmdd,112)),112)          
 * 2018.07.02   KTH         전극 SCP 반영(ORIGIN_FROM_DIVISION_ID,ORIGIN_TO_DIVISION_ID,ELECTRODE_TYPE) 추가      
 * 2018.07.04   KTH         SCP_MST_FINAL_ITEM_V로 변경, #TMP_SCP_PLN_NET_DEMAND_V로 변경  
 * 2018.07.09   KTH         파라미터 변경 (PLN과 동일하게 변경)  
 * 2018.07.11   KTH         MEASURE를 0으로 추가 로직 변경  
 * 2018.07.19   KTH         INCOTERMS 수정  
 * 2018.07.26   KTH         INCOTERMS 수정(BOD_ID -> DEMAND_ID)  
 * 2018.08.07   KTH         MEASURE(WH_IN_BALANCE) 로직 추가( to site기준의 BOH + 특정일자까지 누적 Fcst qty * (-1) + 특정일자까지 누적 WH_IN total 누적수량)  
 * 2018.08.22   KTH         최종입력시점에 MAX(INCOTERMS) -->    INCOTERMS 로 변경함.
 * 2018.09.14   KTH         UNPEGGING 제외 조건 추가 (ENG_DEMAND_ID      <> 'UNPEGGING')
 * 2018.09.17   KTH         소형(40) Balance데이타 생성시 월별로 계산,Balance(WH_IN) 삭제,  삭제시 속도 개선
 * 2018.11.21   KTH         'SHIP_REQ' 로직변경(YYYYMMDD = LPST) 추가
 * 2018.12.10   KTH         'SHIP_REQ' 로직변경(YYYYMMDD = LPST) 제거, PROJECT_CODE 조인조건 추가
 * 2019.06.25   KTH         SHIP_PLAN 입력 (FG) UNPEGGING 조건 주석처리
 * 2019.07.03   KTH         SHIP_PLAN 입력 (FG) SCP_MST_BOD_V.INCOTERMS 로 변경
 * 2019.07.04   KTH         SHIP_PLAN, SHIP_REQ, WH_IN UNPEGGING 일 경우 SCP_MST_BOD_V.INCOTERMS 로 변경
 * 2019.08.02   KTH         BALANCE 입력(소형(40)일 경우)  월별 BALANCE 적용로직 삭제
 * 2021.05.10   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 플랜 대응
 * 2021.07.16   sclee.lee   PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) : SCP_MST_BOD_V에서 SCP_MST_BOD_N_V로 변경 
 * 2021.11.11   sclee.lee   튜닝개선안에 따른 일부 쿼리 변경 
 * 2022.03.22   KSW         JV GM 반영
 * 2023.03.29		HRK			PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 대응
 * 2024.06.05   KSG         PJ20244573 LGES SCM SCP 생산모델 기반 공급계획 수립체계 구성 : From Item 정보 추가
 * 2024.06.14   KSG         PJ20244573 LGES SCM SCP 생산모델 기반 공급계획 수립체계 구성 : Ship Plan 존재 시 동일 Group의 Ship Plan 없는 Item 0값 생성
 * 2024.11.28   HRK         E20241127-000766 [SCP_ANL_SHIPMENT_PLAN_FG] 테이블에 Unpegging Demand [WH_IN] 메져 값 추가
 * 2025.03.11   kimcd       DM RTF 수량 불일치 조치
 * 2025.04.01   KSK			NET_DEMAND의 CELL_PLANT_SITE_ID(셀생산지)를 (MKT_FCST, RTF, BALANCE) 의 FROM_SITE로 전달		
										
 */                    
                    
                        
 CREATE PROCEDURE [dbo].[PR_SCP_ANL_SHIPMENT_PLAN_FG]                        
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
        SET @v_batch_user                = @p_user_id                 
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SCP_ANL_SHIPMENT_PLAN_FG';                        
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...                        
    DECLARE @n_log_count    INTEGER       = 0;                        
    DECLARE @v_log_message  NVARCHAR(1000);                        
    DECLARE @v_description  NVARCHAR(500);            
    DECLARE @v_table_id     NVARCHAR(150) = N'SCP_ANL_SHIPMENT_PLAN_FG';                         
    DECLARE @d_event_date   DATETIME;                        
                        
  -- 시작 LOG                        
    SET @v_log_type     = N'START';                        
    SET @v_log_message  = N'########## Start of procedure ##########';                        
    SET @v_description  = @v_program_name + ':' + N' SCP_ANL_SHIPMENT_PLAN_FG INSERT LOGIC';                        
    SET @d_event_date   = SYSDATETIME();                        
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name                        
                              ,@p_log_type      = @v_log_type                        
                              ,@p_log_count     = @n_log_count                         
                              ,@p_log_message   = @v_log_message                         
                              ,@p_description   = @v_description                         
                              ,@p_event_date    = @d_event_date                         
                              ,@p_user_id       = @v_batch_user                        
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
          IF OBJECT_ID('tempdb..#tmp_SCP_ANL_SHIPMENT_PLAN_FG') IS NOT NULL                        
              DROP TABLE #tmp_SCP_ANL_SHIPMENT_PLAN_FG                        
                        
            CREATE TABLE #tmp_SCP_ANL_SHIPMENT_PLAN_FG(                        
               DIVISION_ID              nvarchar(030)                        
              ,PLAN_START_YYYYMMDD      nvarchar(008)                        
              ,PLAN_TYPE                nvarchar(050)                        
              ,SEQ                      INT                        
              ,OPERATION_GROUP          nvarchar(010)                        
              ,PROJECT_CODE             nvarchar(100)                        
              ,ITEM_ID                  nvarchar(100)                        
              ,TO_SITE                  nvarchar(100)                        
              ,INCOTERMS                nvarchar(100)                        
              ,FROM_SITE                nvarchar(100)                        
              ,BOD_ID                   nvarchar(150)                        
              ,TRANSPORT_MODE           nvarchar(050)                          
              ,MEASURE                  nvarchar(050)                        
              ,YYYYMMDD                 nvarchar(008)                    
              ,ORIGIN_FROM_DIVISION_ID  nvarchar(030)     
              ,ORIGIN_TO_DIVISION_ID    nvarchar(030)     
              ,ELECTRODE_TYPE    nvarchar(030)         
              ,QTY    numeric (20,10)               
            );                         
            
                        
            -- * 2021.05.10   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 플랜 대응 - start
			DECLARE @v_pet_date		NVARCHAR(12) = '';

			--  Plan End Date
			SELECT @v_pet_date = p.horizon_end_date
			FROM   dbo.scm_mst_plan p WITH(NOLOCK)
			WHERE  p.division_id = @p_division_id
			AND    p.plan_id     = @p_plan_id ;

			SET @v_pet_date = CONVERT(VARCHAR(8), DATEADD(DAY, 1, CONVERT(DATETIME, @v_pet_date, 112)), 112);
			-- * 2021.05.10   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 플랜 대응 - end
            
                        
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
            INSERT INTO #tmp_SCP_ANL_SHIPMENT_PLAN_FG                        
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
                    SELECT    B.ENG_DEMAND_ID,                      
                          B.DIVISION_ID                        
                         ,B.PLAN_START_YYYYMMDD                      -- plan주의 월요일  ,dbo.FN_GET_BUCKET_YYYYMMDD(0)                         
                         ,B.PLAN_TYPE                        
                         ,B.SEQ                          
                         ,B.OPERATION_GROUP                     
                         ,B.PROJECT_CODE                        
                         ,B.ITEM_ID                        
                         ,B.TO_SITE  
--                         ,B.INCOTERMS        
                          --, (SELECT TOP 1 X.INCOTERMS                      
                          --     FROM SCP_MST_BOD_V X WITH(NOLOCK)                        
                          --    WHERE X.DIVISION_ID  = B.DIVISION_ID                        
                          --      AND X.BOD_ID       = B.BOD_ID )     AS INCOTERMS     
                          -- PJ20209643 (20210716) : SCP_MST_BOD_V에서 SCP_MST_BOD_N_V로 변경
                         , (CASE WHEN B.INCOTERMS <> '-'  AND  B.INCOTERMS IS NOT NULL THEN B.INCOTERMS
                                 ELSE (SELECT TOP 1 X.INCOTERMS                      
                                         FROM SCP_MST_BOD_N_V X WITH(NOLOCK)                        
                                        WHERE X.DIVISION_ID  = B.DIVISION_ID                        
                                          AND X.BOD_ID       = B.BOD_ID )  
                                 END ) AS INCOTERMS     
                         ,B.FROM_SITE                        
                         ,B.BOD_ID                         
                         ,B.TRANSPORT_MODE                        
                         ,B.MEASURE                         
                         ,B.YYYYMMDD                        
                         ,B.ALLOCATION_QTY         AS QTY                        
                     FROM 
                      SCP_PLN_SHIPMENT_PLAN B WITH (NOLOCK)                   
                     WHERE 1 = 1                        
                       AND B.DIVISION_ID         = @p_division_id                      
                       AND B.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd                          
                       AND B.PLAN_TYPE           = @p_plan_type                        
                       AND B.SEQ                 = @p_seq       
                       AND B.DIVISION_ID         is not null
                     AND B.MEASURE               = 'SHIP_REQ'                         
                     AND B.SEMI_YN               = 'N'           
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
            INSERT INTO #tmp_SCP_ANL_SHIPMENT_PLAN_FG                        
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
--                         ,B.INCOTERMS       
                         --, (SELECT TOP 1 X.INCOTERMS                      
                         --      FROM SCP_MST_BOD_V X WITH(NOLOCK)                        
                         --     WHERE X.DIVISION_ID  = B.DIVISION_ID                        
                         --       AND X.BOD_ID       = B.BOD_ID )     AS INCOTERMS
						 -- PJ20209643 (20210716) : SCP_MST_BOD_V에서 SCP_MST_BOD_N_V로 변경
                          , (CASE WHEN B.INCOTERMS <> '-'  AND  B.INCOTERMS IS NOT NULL THEN B.INCOTERMS
                                 ELSE (SELECT TOP 1 X.INCOTERMS                      
                                         FROM SCP_MST_BOD_N_V X WITH(NOLOCK)                        
                                        WHERE X.DIVISION_ID  = B.DIVISION_ID                        
                                          AND X.BOD_ID       = B.BOD_ID )  
                                 END ) AS INCOTERMS 

                         ,B.FROM_SITE                        
                         ,B.BOD_ID                         
                         ,B.TRANSPORT_MODE                        
                         ,B.MEASURE                 
                         ,B.YYYYMMDD                        
                         ,A.ALLOCATION_QTY         AS QTY                        
                     FROM DBO.SCP_PLN_SHIPMENT_PLAN_PEGGING A WITH (NOLOCK)                         
                     LEFT OUTER JOIN  SCP_PLN_SHIPMENT_PLAN B WITH (NOLOCK)                   
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
                     AND B.MEASURE               = 'SHIP_PLAN'                
                     AND B.SEMI_YN               = 'N'                      
                     --AND A.ENG_DEMAND_ID        <> 'UNPEGGING' 
                     WHERE 1 = 1                        
                       AND A.DIVISION_ID         = @p_division_id                       
                       AND A.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd                          
                       AND A.PLAN_TYPE           = @p_plan_type                        
                       AND A.SEQ                 = @p_seq                            
                       AND B.DIVISION_ID         is not null           
                       --AND A.ENG_DEMAND_ID        <> 'UNPEGGING' 

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
          -- PJ20244573 LGES SCM SCP 생산모델 기반 공급계획 수립체계 구성 
		  -- 1-3. SHIP_PLAN 입력 (FG) : 동일 Group의 Ship Plan 없는 item에 대하여 재고/생산계획 존재 시 0으로 추가             
          --      (SHIP_PLAN, SHIP_PLAN_AMEND)
          -------------------------------------------------------------------------------------------------------------
          DECLARE @X_INT        INT   =1;              
          DECLARE @X_MEASURE    NVARCHAR(100);              
              
          WHILE @X_INT < 3
          BEGIN              
                          
               SELECT @X_MEASURE = ( CASE @X_INT WHEN 1 THEN 'SHIP_PLAN'               
                                                 WHEN 2 THEN 'SHIP_PLAN_AMEND'             
                                     END);         
                                
                INSERT INTO #tmp_SCP_ANL_SHIPMENT_PLAN_FG                        
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
                      ,ORIGIN_FROM_DIVISION_ID    
                      ,ORIGIN_TO_DIVISION_ID    
                      ,ELECTRODE_TYPE              
                      ,QTY                        
                      )                             
               SELECT                    
                      SUB.DIVISION_ID                         
                     ,SUB.PLAN_START_YYYYMMDD                 
                     ,SUB.PLAN_TYPE                           
                     ,SUB.SEQ                                 
                     ,SUB.OPERATION_GROUP                     
                     ,SUB.PROJECT_CODE                        
                     ,SUB.ITEM_ID                             
                     ,SUB.TO_SITE                             
                     ,SUB.INCOTERMS                           
                     ,SUB.FROM_SITE                           
                     ,SUB.BOD_ID                              
                     ,SUB.MEASURE                                  
                     ,SUB.YYYYMMDD                             
                     ,SUB.ORIGIN_FROM_DIVISION_ID    
                     ,SUB.ORIGIN_TO_DIVISION_ID    
                     ,SUB.ELECTRODE_TYPE                       
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
                              ,FROM_SITE                        
                              ,BOD_ID                        
                              ,@X_MEASURE AS MEASURE               
                              ,YYYYMMDD              
                              ,ORIGIN_FROM_DIVISION_ID    
                              ,ORIGIN_TO_DIVISION_ID    
                              ,ELECTRODE_TYPE     
                         FROM                
                              (  -- 365 DAYS              
                                 SELECT C.BASIS_YYYYMMDD AS YYYYMMDD                  
                                   FROM SCM_SYS_CALENDAR_M    C WITH(NOLOCK)                 
                                  WHERE 1=1              
                                    AND C.BASIS_YYYYMMDD >= @p_plan_start_yyyymmdd   
									AND C.BASIS_YYYYMMDD <  @v_pet_date  
                              ) A,                
                              (                
                                 SELECT DISTINCT               
                                        X.DIVISION_ID                        
                                       ,X.PLAN_START_YYYYMMDD                        
                                       ,X.PLAN_TYPE                        
                                       ,X.SEQ                        
                                       ,X.OPERATION_GROUP                        
                                       ,X.PROJECT_CODE        
                                       ,ISNULL(gr2.item_id, X.ITEM_ID) AS ITEM_ID                   
                                       --,X.ITEM_ID                          
                                       ,X.BOD_ID                       
                                       ,X.FROM_SITE                         
                                       ,X.TO_SITE                        
                                       ,X.INCOTERMS              
                                       ,X.ORIGIN_FROM_DIVISION_ID    
                                       ,X.ORIGIN_TO_DIVISION_ID    
                                       ,X.ELECTRODE_TYPE               
                                  FROM #tmp_SCP_ANL_SHIPMENT_PLAN_FG X WITH(NOLOCK)        
                       
								   -- 20240615 PJ20244573 동일 GROUP Item 추가
									LEFT JOIN ( 
												SELECT division_id, project_code, item_id, group_id
												FROM   SCP_MST_ITEM_GROUP_DETAIL  WITH (NOLOCK)
												WHERE  1=1 --division_id = '40' 
												AND    valid_yn    = 'Y'
												AND    ISNULL(group_id, '') <> ''
											   ) gr
									ON   x.division_id  = gr.division_id
									AND  x.project_code = gr.project_code 
									AND  x.item_id      = gr.item_id 
                       
								   -- 20240615 PJ20244573 동일 GROUP Item 추가
									LEFT JOIN ( 
												SELECT division_id, project_code, item_id, group_id
												FROM   SCP_MST_ITEM_GROUP_DETAIL  WITH (NOLOCK)
												WHERE  1=1 --division_id = '40' 
												AND    valid_yn    = 'Y'
												AND    ISNULL(group_id, '') <> ''
											   ) gr2
									ON   gr.division_id = gr2.division_id
									AND  gr.group_id    = gr2.group_id   

					                --  재고/생산계획 존재 : From Site / Item 기준
									LEFT JOIN (									
											   SELECT DISTINCT scm_site_id, item_id
											   FROM   SCP_ANL_PRODUCTION_PLAN p WITH(NOLOCK)  
											   WHERE  1=1           
											   AND    p.DIVISION_ID         = @p_division_id
											   AND    p.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
											   AND    p.PLAN_TYPE           = @p_plan_type
											   AND    p.seq                 = @p_seq
											   AND    p.MEASURE IN ( 'PROD_PLAN_AMEND'   )
											   AND    p.qty <> 0
											  UNION						   
											   SELECT DISTINCT SUBSTRING(sp.SITE_ID, 1, CHARINDEX('~', sp.SITE_ID)-1) AS SCM_SITE_ID, sp.ITEM_ID
											   FROM   SCP_PLN_TH_ENG_STOCK_PLAN sp WITH(NOLOCK)        
											   WHERE  1=1 
											   AND    sp.master_id = @p_master_id
											   AND    sp.plan_id   = @p_engine_plan_id
									          )  sm
									ON   x.from_site = sm.scm_site_id
									AND  gr2.item_id = sm.item_id    -- 동일 GROUP Item 기준
									
                                 WHERE 1=1           
								  AND  X.MEASURE = @X_MEASURE -- 동일 Measure 존재 정보 대상
								  AND  ISNULL(sm.scm_site_id, '') <> '' -- 동일 GROUP Item 기준 재고/생산계획 존재 시 생성
  
                              ) B                
                    ) SUB                
                    WHERE 1=1                
                      AND NOT EXISTS (                
                                       SELECT 'X'                
                                         FROM #tmp_SCP_ANL_SHIPMENT_PLAN_FG Z WITH(NOLOCK)                
                                        WHERE 1=1                
                                          AND Z.DIVISION_ID              = SUB.DIVISION_ID                        
                                          AND Z.PLAN_START_YYYYMMDD      = SUB.PLAN_START_YYYYMMDD                    
                                          AND Z.PLAN_TYPE                = SUB.PLAN_TYPE                          
                                          AND Z.SEQ                      = SUB.SEQ                                
                                          AND Z.OPERATION_GROUP          = SUB.OPERATION_GROUP  
                                          AND Z.PROJECT_CODE             = SUB.PROJECT_CODE                       
                                          AND Z.ITEM_ID                  = SUB.ITEM_ID                            
                                          AND Z.BOD_ID                   = SUB.BOD_ID                            
                                          AND Z.FROM_SITE                = SUB.FROM_SITE                            
                                          AND Z.TO_SITE                  = SUB.TO_SITE                            
                                          AND Z.INCOTERMS                = SUB.INCOTERMS                          
                                          AND Z.MEASURE                  = @X_MEASURE                        
                                          AND Z.YYYYMMDD                 = SUB.YYYYMMDD                
                                          AND Z.ORIGIN_FROM_DIVISION_ID  = SUB.ORIGIN_FROM_DIVISION_ID           
                                          AND Z.ORIGIN_TO_DIVISION_ID    = SUB.ORIGIN_TO_DIVISION_ID           
                                          AND Z.ELECTRODE_TYPE           = SUB.ELECTRODE_TYPE                 
                                     );              
                                                                     
                          
               SET @X_INT = @X_INT + 1;              
                  
           END              
        
        
            -------------------------------------------------------------------------------------------------------------                        
            -- 2-1. WH_IN 입력 FG : SCP_ANL_PROBLEM_REPORT_PEGGING        
            -------------------------------------------------------------------------------------------------------------                         
            INSERT INTO #tmp_SCP_ANL_SHIPMENT_PLAN_FG                        
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
                          from scp_anl_problem_report_pegging a WITH (nolock)        
                          where 1=1        
                            AND a.division_id            = @p_division_id                  
                            AND a.plan_start_yyyymmdd    = @p_plan_start_yyyymmdd          
                            AND a.plan_type              = @p_plan_type                    
                            AND a.seq                    = @p_seq                                
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
            -- 2-2. WH_IN 입력 FG : SCP_PLN_SHIPMENT_PLAN_PEGGING        
            -------------------------------------------------------------------------------------------------------------                         
            INSERT INTO #tmp_SCP_ANL_SHIPMENT_PLAN_FG                        
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
                         ,B.PLAN_START_YYYYMMDD                                           
                         ,B.PLAN_TYPE                        
                         ,B.SEQ                          
                         ,B.OPERATION_GROUP                        
                         ,A.PROJECT_CODE                        
                         ,B.ITEM_ID                        
                         ,B.TO_SITE                    
--                         ,A.INCOTERMS       
                         --, ( SELECT TOP 1 X.INCOTERMS                      
                         --      FROM SCP_MST_BOD_V X WITH(NOLOCK)                        
                         --     WHERE X.DIVISION_ID  = B.DIVISION_ID                        
                         --       AND X.BOD_ID       = B.BOD_ID )     AS INCOTERMS         
						 -- PJ20209643 (20210716) : SCP_MST_BOD_V에서 SCP_MST_BOD_N_V로 변경
                          , (CASE WHEN B.INCOTERMS <> '-'  AND  B.INCOTERMS IS NOT NULL THEN B.INCOTERMS
                                 ELSE (SELECT TOP 1 X.INCOTERMS                      
                                         FROM SCP_MST_BOD_N_V X WITH(NOLOCK)                        
                                        WHERE X.DIVISION_ID  = B.DIVISION_ID                        
                                          AND X.BOD_ID       = B.BOD_ID )  
                                 END ) AS INCOTERMS 
                         ,B.FROM_SITE                        
                         ,B.BOD_ID                         
                         ,B.TRANSPORT_MODE                        
                         ,'WH_IN' AS MEASURE                 
                         ,CONVERT(NVARCHAR(8), B.END_TIME,112) AS YYYYMMDD                 
                         ,A.ALLOCATION_QTY         AS QTY                        
                     FROM DBO.SCP_PLN_SHIPMENT_PLAN_PEGGING A WITH (NOLOCK)                         
                   LEFT OUTER JOIN  SCP_PLN_SHIPMENT_PLAN B WITH (NOLOCK)                   
                     ON 0 = 0                
                     AND A.DIVISION_ID           = B.DIVISION_ID                        
                     AND A.PLAN_START_YYYYMMDD   = B.PLAN_START_YYYYMMDD                
                     AND A.PLAN_TYPE             = B.PLAN_TYPE                          
                     AND A.SEQ                   = B.SEQ                               
                     AND A.ORDER_ID              = B.ORDER_ID                 
                  --   AND A.ENG_DEMAND_ID         = B.ENG_DEMAND_ID                
                     AND A.DIVISION_ID           = @p_division_id                    
                     AND A.PLAN_START_YYYYMMDD   = @p_plan_start_yyyymmdd                        
                     AND A.PLAN_TYPE             = @p_plan_type                      
                     AND A.SEQ                   = @p_seq                          
                     AND B.MEASURE               = 'SHIP_PLAN'                         
                     AND B.SEMI_YN               = 'N'                          
                     -- 2024.11.28 E20241127-000766 [SCP_ANL_SHIPMENT_PLAN_FG] 테이블에 Unpegging Demand [WH_IN] 메져 값 추가로 주석 처리 AND A.ENG_DEMAND_ID        <> 'UNPEGGING' 
--                     AND B.ENG_DEMAND_ID        <> 'UNPEGGING' 
              WHERE 1 = 1                        
                       AND A.DIVISION_ID         = @p_division_id                    
                       AND A.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd                        
                       AND A.PLAN_TYPE           = @p_plan_type                      
                       AND A.SEQ                 = @p_seq                      
                       AND B.DIVISION_ID         is not null          
                       -- 2024.11.28 E20241127-000766 [SCP_ANL_SHIPMENT_PLAN_FG] 테이블에 Unpegging Demand [WH_IN] 메져 값 추가로 주석 처리 AND A.ENG_DEMAND_ID        <> 'UNPEGGING' 
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
           INSERT INTO #tmp_SCP_ANL_SHIPMENT_PLAN_FG                        
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
                 SELECT A.DIVISION_ID                                       
                       ,A.PLAN_START_YYYYMMDD                               
                       ,A.PLAN_TYPE                                         
                       ,A.SEQ                                               
                       ,A.OPERATION_GROUP                                   
                       ,A.PROJECT_CODE         
                       -- 20240605 PJ20244573 : From Item 기준
                       ,A.ATTRIBUTE1 AS ITEM_ID                                      
                       --,A.ITEM_ID                                           
                       ,A.SALES_SITE_ID         AS TO_SITE                  
                       ,A.INCOTERMS                                         
                       ,(CASE WHEN A.DIVISION_ID = '40' AND A.OPERATION_GROUP = 'A' THEN  PND.CELL_PLANT_SITE_ID ELSE '-' END)	AS FROM_SITE    --셀생산지 수집 (KSK, 250402)
                       ,'-'                     AS BOD_ID                   
                       ,'ALLOCATION'            AS MEASURE                  
                       ,A.YYYYMMDD                                          
                       --,SUM(ISNULL(A.ALLOCATION_QTY,0))  AS QTY   
					   ,SUM(ISNULL(ROUND(A.ALLOCATION_QTY,0),0))  AS QTY    -- 2025-03-11 kimcd DM RTF 수량 불일치 조치
                  FROM SCP_PLN_ALLOCATION A  WITH(NOLOCK)      
				  INNER JOIN SCP_PLN_NET_DEMAND_V  PND
					ON  PND.[MASTER_ID]      = A.[MASTER_ID]
					AND PND.[OUT_VERSION_ID] = A.[OUT_VERSION_ID]
					AND PND.[ENG_DEMAND_ID]  = A.[ENG_DEMAND_ID]  				  
                 WHERE 0 = 0          
                   AND A.DIVISION_ID         = @p_division_id                        
                   AND A.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd                
                   AND A.PLAN_TYPE           = @p_plan_type                          
                    AND A.SEQ                 = @p_seq       
                  GROUP BY              
                       A.DIVISION_ID              
                      , A.PLAN_START_YYYYMMDD              
                      , A.PLAN_TYPE              
                      ,A.SEQ              
                      ,A.OPERATION_GROUP              
                      ,A.PROJECT_CODE    
                       -- 20240605 PJ20244573 : From Item 기준
                       ,A.ATTRIBUTE1                 
                      --,ITEM_ID              
                      ,A.SALES_SITE_ID              
                      ,A.INCOTERMS              
                      ,(CASE WHEN A.DIVISION_ID = '40' AND A.OPERATION_GROUP = 'A' THEN PND.CELL_PLANT_SITE_ID ELSE '-' END)          
                      ,A.YYYYMMDD              
            -------------------------------------------------------------------------------------------------------------                           
            -- 5. MKT_FCST 입력 FG                           
           -------------------------------------------------------------------------------------------------------------     
            IF OBJECT_ID('tempdb..#TMP_SCP_PLN_NET_DEMAND_V') IS NOT NULL                          
              DROP TABLE #TMP_SCP_PLN_NET_DEMAND_V     
    
               
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
						,A.CELL_PLANT_SITE_ID
                    INTO #TMP_SCP_PLN_NET_DEMAND_V                      
                    FROM SCP_PLN_NET_DEMAND_V A  WITH (NOLOCK)         
                   WHERE ISNUMERIC(A.SEQ)        = 1                        
                     AND A.DIVISION_ID           = @p_division_id                          
                     AND A.PLAN_START_YYYYMMDD   = @p_plan_start_yyyymmdd                          
                     AND A.PLAN_TYPE             = @p_plan_type                          
                     AND A.SEQ                   = @p_seq               
                     AND A.master_id             = @p_master_id                  
                     AND A.eng_plan_id           = @p_engine_plan_id 
				 
                 INSERT INTO #tmp_SCP_ANL_SHIPMENT_PLAN_FG           
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
                        ,(CASE WHEN DIVISION_ID = '40' AND C.OPERATION_GROUP = 'A' THEN A.cell_plant_site_id ELSE  '-'  END) AS FROM_SITE --셀생산지 수집 (KSK, 250402)                         
                        , '-'                                                       AS BOD_ID                          
                        ,'MKT_FCST'                                                 AS MEASURE                          
                        ,A.YYYYMMDD                          
                        ,SUM(A.SPLIT_QTY)     
                    FROM #TMP_SCP_PLN_NET_DEMAND_V A  WITH (NOLOCK)         
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
						,(CASE WHEN A.DIVISION_ID = '40'   AND C.OPERATION_GROUP = 'A'  THEN A.cell_plant_site_id ELSE  '-'  END)      						
						--, A.cell_plant_site_id
                        ,A.YYYYMMDD     			
                        ;                          
              
            -------------------------------------------------------------------------------------------------------------                         
            -- 5. SHIP_PLAN_AMEND 입력 FG                         
            -------------------------------------------------------------------------------------------------------------                         
              INSERT INTO #tmp_SCP_ANL_SHIPMENT_PLAN_FG                        
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
              SELECT DIVISION_ID                                              
                  ,PLAN_START_YYYYMMDD                                       
                  ,PLAN_TYPE                                                 
                  ,SEQ                                                       
                  ,OPERATION_GROUP                                           
                  ,ISNULL(PROJECT_CODE,'-') AS PROJECT_CODE                  
                  ,ITEM_ID                                                   
                  ,TO_SITE                                                   
                  ,INCOTERMS                                                 
                  ,FROM_SITE                                                 
                  ,BOD_ID                                                    
                 ,'SHIP_PLAN_AMEND' AS MEASURE                               
                  ,YYYYMMDD                                                  
                  ,QTY                                                       
              FROM #tmp_SCP_ANL_SHIPMENT_PLAN_FG  WITH(NOLOCK)       
              WHERE MEASURE ='SHIP_PLAN'                  
                            
          -------------------------------------------------------------------------------------------------------------                         
          -- 6. WH_IN_TOTAL 입력 FG  = SUM(WH_IN) + INTRANSIT                       
          -------------------------------------------------------------------------------------------------------------                         
          /*          
                 INSERT INTO #tmp_SCP_ANL_SHIPMENT_PLAN_FG                        
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
              SELECT DIVISION_ID                                      
                    ,PLAN_START_YYYYMMDD                              
                    ,PLAN_TYPE                                        
                    ,SEQ                   --SEQ                  
                    ,OPERATION_GROUP                                  
                    ,PROJECT_CODE                                     
                    ,ITEM_ID                                          
                    ,TO_SITE                                      
                    ,INCOTERMS                                        
                    ,'-'                  AS FROM_SITE                
                    ,'-'         AS BOD_ID               
                    ,'WH_IN_TOTAL'        AS MEASURE                  
                    ,YYYYMMDD                                         
                    ,SUM(ISNULL(QTY,0))                               
               FROM #tmp_SCP_ANL_SHIPMENT_PLAN_FG  WITH(NOLOCK)                  
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
          IF @p_division_id <> '40'  -- MEASURE ='BALANCE'
			  BEGIN           
				  SET @X_INT        = 1;              
				  SET @X_MEASURE    = '';              
              
				  WHILE @X_INT < 3              
				  BEGIN              
                          
					   SELECT @X_MEASURE = ( CASE @X_INT WHEN 1 THEN 'MKT_FCST'               
														 WHEN 2 THEN 'ALLOCATION'               
														-- WHEN 3 THEN 'WH_IN_TOTAL'               
											 END);              
                                                   
                                
						INSERT INTO #tmp_SCP_ANL_SHIPMENT_PLAN_FG                        
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
							  SUB.DIVISION_ID                         
							 ,SUB.PLAN_START_YYYYMMDD                 
							 ,SUB.PLAN_TYPE                           
							 ,SUB.SEQ                                 
							 ,SUB.OPERATION_GROUP                     
							 ,SUB.PROJECT_CODE                        
							 ,SUB.ITEM_ID                             
							 ,SUB.TO_SITE                             
							 ,SUB.INCOTERMS                           
							 ,SUB.FROM_SITE                           
							 ,SUB.BOD_ID                              
							 ,SUB.MEASURE                                  
							 ,SUB.YYYYMMDD                             
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
									  (  -- 365 DAYS              
										 SELECT C.BASIS_YYYYMMDD AS YYYYMMDD                  
										   FROM SCM_SYS_CALENDAR_M    C WITH(NOLOCK)                 
										  WHERE 1=1              
											AND C.BASIS_YYYYMMDD >= @p_plan_start_yyyymmdd     
									
											-- * 2021.05.10   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 플랜 대응 - start
											--AND C.BASIS_YYYYMMDD <  CONVERT(VARCHAR,DATEADD(D,364,CONVERT(DATETIME,@p_plan_start_yyyymmdd,112)),112)   
											--
											AND C.BASIS_YYYYMMDD <  @v_pet_date  
											-- * 2021.05.10   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 플랜 대응 - 둥
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
										  FROM #tmp_SCP_ANL_SHIPMENT_PLAN_FG X WITH(NOLOCK)                
										 WHERE 1=1              
  
									  ) B                
							) SUB                
							WHERE 1=1                
							  AND NOT EXISTS (                
											   SELECT 'X'                
												 FROM #tmp_SCP_ANL_SHIPMENT_PLAN_FG Z WITH(NOLOCK)                
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
                  
				   END;
			  END;
		  ELSE -- IF @p_division_id <> '40'  -- MEASURE ='BALANCE' 40만 수행  2025.04.01   KSK	NET_DEMAND의 CELL_PLANT_SITE_ID(셀생산지)를 (MKT_FCST, RTF, BALANCE) 의 FROM_SITE 추가
		      BEGIN
				  SET @X_INT        = 1;              
				  SET @X_MEASURE    = '';              
              
				  WHILE @X_INT < 3              
				  BEGIN              
                          
					   SELECT @X_MEASURE = ( CASE @X_INT WHEN 1 THEN 'MKT_FCST'               
														 WHEN 2 THEN 'ALLOCATION'
											 END);
                                                   
                                
						INSERT INTO #tmp_SCP_ANL_SHIPMENT_PLAN_FG                        
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
					   SELECT                    
							  SUB.DIVISION_ID                         
							 ,SUB.PLAN_START_YYYYMMDD                 
							 ,SUB.PLAN_TYPE                           
							 ,SUB.SEQ                                 
							 ,SUB.OPERATION_GROUP                     
							 ,SUB.PROJECT_CODE                        
							 ,SUB.ITEM_ID                             
							 ,SUB.TO_SITE                             
							 ,SUB.INCOTERMS                           
							 ,SUB.FROM_SITE                           
							 ,SUB.BOD_ID                              
							 ,SUB.MEASURE                                  
							 ,SUB.YYYYMMDD                             
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
									  ,FROM_SITE                        
									  ,'-'        AS BOD_ID                        
									  ,@X_MEASURE AS MEASURE               
									  ,YYYYMMDD              
								 FROM                
									  (  -- 365 DAYS              
										 SELECT C.BASIS_YYYYMMDD AS YYYYMMDD                  
										   FROM SCM_SYS_CALENDAR_M    C WITH(NOLOCK)                 
										  WHERE 1=1              
											AND C.BASIS_YYYYMMDD >= @p_plan_start_yyyymmdd     
											AND C.BASIS_YYYYMMDD <  @v_pet_date  
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
											   ,FROM_SITE
											   ,INCOTERMS              
										  FROM #tmp_SCP_ANL_SHIPMENT_PLAN_FG X WITH(NOLOCK)                
										 WHERE MEASURE IN  ( 'ALLOCATION', 'MKT_FCST' )
										   AND MEASURE != @X_MEASURE
									  ) B                
							) SUB                
							WHERE 1=1                
							  AND NOT EXISTS (                
											   SELECT 'X'                
												 FROM #tmp_SCP_ANL_SHIPMENT_PLAN_FG Z WITH(NOLOCK)                
												WHERE 1=1                
												  AND Z.DIVISION_ID              = SUB.DIVISION_ID                        
												  AND Z.PLAN_START_YYYYMMDD      = SUB.PLAN_START_YYYYMMDD                    
												  AND Z.PLAN_TYPE                = SUB.PLAN_TYPE                          
												  AND Z.SEQ    = SUB.SEQ                                
												  AND Z.OPERATION_GROUP          = SUB.OPERATION_GROUP  
												  AND Z.PROJECT_CODE             = SUB.PROJECT_CODE                       
												  AND Z.ITEM_ID                  = SUB.ITEM_ID                            
												  AND Z.TO_SITE                  = SUB.TO_SITE
												  AND Z.FROM_SITE                = SUB.FROM_SITE
												  AND Z.INCOTERMS                = SUB.INCOTERMS                          
												  AND Z.MEASURE                  = @X_MEASURE                        
												  AND Z.YYYYMMDD                 = SUB.YYYYMMDD                
											 );              
                                                                     
                          
					   SET @X_INT = @X_INT + 1;              
                  
				   END;

			  END;  -- IF @p_division_id <> '40'  -- MEASURE ='BALANCE' 40만 수행
                                        
			
          -------------------------------------------------------------------------------------------------------------                         
          -- 7-2. MEASURE별 BUCKET일자별 0 채우기                    
          -------------------------------------------------------------------------------------------------------------                                  
              
            INSERT INTO #tmp_SCP_ANL_SHIPMENT_PLAN_FG                        
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
                  SUB.DIVISION_ID                          
                 ,SUB.PLAN_START_YYYYMMDD                          
                 ,SUB.PLAN_TYPE                                    
                 ,SUB.SEQ                                          
                 ,SUB.OPERATION_GROUP                              
                 ,SUB.PROJECT_CODE                                 
                 ,SUB.ITEM_ID            
                 ,SUB.TO_SITE                                      
                 ,SUB.INCOTERMS                                    
                 ,SUB.FROM_SITE                                    
                 ,SUB.BOD_ID                        
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
                          (  -- 365 DAYS              
                             SELECT C.BASIS_YYYYMMDD AS YYYYMMDD                  
                               FROM SCM_SYS_CALENDAR_M    C WITH(NOLOCK)                 
                              WHERE 1=1              
                                AND C.BASIS_YYYYMMDD >= @p_plan_start_yyyymmdd      
								
								-- * 2021.05.10   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 플랜 대응 - start
                                --AND C.BASIS_YYYYMMDD <  CONVERT(VARCHAR,DATEADD(D,364,CONVERT(DATETIME,@p_plan_start_yyyymmdd,112)),112)  
								--
								AND C.BASIS_YYYYMMDD <  @v_pet_date  
								-- * 2021.05.10   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 플랜 대응 - end
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
                              FROM #tmp_SCP_ANL_SHIPMENT_PLAN_FG X WITH(NOLOCK)                
                             WHERE 1=1              
                          ) B                
                ) SUB                
                WHERE 1=1                
                  AND NOT EXISTS (                
                                   SELECT 'X'                
                                     FROM #tmp_SCP_ANL_SHIPMENT_PLAN_FG Z WITH(NOLOCK)                
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
          -- BLANCE
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
					,FROM_SITE    --셀생산지관련(KSK,250407)
                    ,YYYYMMDD           
                  --,ORIGIN_FROM_DIVISION_ID    
                  --,ORIGIN_TO_DIVISION_ID    
                  --,ELECTRODE_TYPE         
              INTO #Z  
              FROM #tmp_SCP_ANL_SHIPMENT_PLAN_FG WITH(NOLOCK)               
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
				  ,FROM_SITE   
                  ,YYYYMMDD       
                  ,OPERATION_GROUP     
                --,ORIGIN_FROM_DIVISION_ID    
                --,ORIGIN_TO_DIVISION_ID    
                --,ELECTRODE_TYPE           
  
  
          -- WH_IN_BALANCE
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
              FROM #tmp_SCP_ANL_SHIPMENT_PLAN_FG WITH(NOLOCK)               
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
                          from scp_pln_plant_onhand with(nolock)      
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
                          from scp_pln_sales_onhand with(nolock)      
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
             FROM SCP_PLN_SALES_ONHAND  WITH (NOLOCK)        
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
            --DROP INDEX #tmp_SCP_ANL_SHIPMENT_PLAN_FG.IX01_#tmp_SCP_ANL_SHIPMENT_PLAN_FG            
            CREATE CLUSTERED INDEX [IX01_#tmp_SCP_ANL_SHIPMENT_PLAN_FG] ON #tmp_SCP_ANL_SHIPMENT_PLAN_FG            
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
  
                                    
              INSERT INTO #tmp_SCP_ANL_SHIPMENT_PLAN_FG                    
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
                       , FROM_SITE      --셀생산지관련수집(KSK, 250407)      
                       , '-' AS BOD_ID            
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
                           FROM #tmp_SCP_ANL_SHIPMENT_PLAN_FG X WITH(NOLOCK)               
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
						   AND X.FROM_SITE			= Z.FROM_SITE
                           --AND X.ORIGIN_FROM_DIVISION_ID   = Z.ORIGIN_FROM_DIVISION_ID          
                           --AND X.ORIGIN_TO_DIVISION_ID     = Z.ORIGIN_TO_DIVISION_ID          
                           --AND X.ELECTRODE_TYPE            = Z.ELECTRODE_TYPE        
                           AND X.YYYYMMDD             <= Z.YYYYMMDD              
                         )     AS PSI_BOH_QTY               
                 FROM #Z AS Z WITH(NOLOCK)               
                WHERE 1=1   

          /*
          -------------------------------------------------------------------------------------------------------------                         
          -- 8.3 BALANCE 입력(소형(40)일 경우)  월별 BALANCE 적용
          ------------------------------------------------------------------------------------------------------------    
          IF @p_division_id = '40'  -- MEASURE ='BALANCE'
            BEGIN 
                  UPDATE XX        
                  SET XX.QTY   = ISNULL((YY.ALLOCATION_SUM_MONTH + MKT_FCST_SUM_MONTH), 0)
                  FROM #tmp_SCP_ANL_SHIPMENT_PLAN_FG XX with (nolock)        
                  INNER JOIN  (        
                                 SELECT DISTINCT DIVISION_ID,PLAN_START_YYYYMMDD,PLAN_TYPE,SEQ,PROJECT_CODE,ITEM_ID,TO_SITE,INCOTERMS,'BALANCE' AS MEASURE,YYYYMMDD        
                                 ,(SUM((CASE WHEN MEASURE ='ALLOCATION' THEN ISNULL(QTY,0) ELSE 0 END))  
                                        OVER (PARTITION BY PROJECT_CODE,ITEM_ID,TO_SITE,INCOTERMS,SUBSTRING(YYYYMMDD,1,6) ORDER BY PROJECT_CODE,ITEM_ID,TO_SITE,INCOTERMS,YYYYMMDD))       AS ALLOCATION_SUM_MONTH
                                 ,(SUM((CASE WHEN MEASURE ='MKT_FCST'   THEN ISNULL(QTY,0) ELSE 0 END))  
                                        OVER (PARTITION BY PROJECT_CODE,ITEM_ID,TO_SITE,INCOTERMS,SUBSTRING(YYYYMMDD,1,6) ORDER BY PROJECT_CODE,ITEM_ID,TO_SITE,INCOTERMS,YYYYMMDD) * -1)  AS MKT_FCST_SUM_MONTH
                                 FROM #tmp_SCP_ANL_SHIPMENT_PLAN_FG X with (nolock)         
                                 WHERE 0 = 0       
                                 AND  X.MEASURE in ('ALLOCATION','MKT_FCST')  
                             ) YY        
                         ON  XX.DIVISION_ID             = YY.DIVISION_ID                
                         AND XX.PLAN_START_YYYYMMDD     = YY.PLAN_START_YYYYMMDD        
                         AND XX.PLAN_TYPE               = YY.PLAN_TYPE                  
                         AND XX.SEQ           = YY.SEQ                        
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
            -- FN_GET_SCP_ANL_BOH_QTY](division_id ,plan_start_yyyymmdd, plan_type, seq, to_site , item_id,from_yyyymmdd) , 1) as int) as boh              
          IF @p_division_id <> '40'  -- MEASURE ='BALANCE'
            BEGIN           
                INSERT INTO #tmp_SCP_ANL_SHIPMENT_PLAN_FG                    
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
                                ISNULL( SUM(CASE MEASURE WHEN 'MKT_FCST' THEN -1 * ISNULL(QTY,0)              
                                                          WHEN 'WH_IN' THEN   ISNULL(QTY,0)            
                                                  ELSE 0.0              
                                      END),0)               
                            FROM #tmp_SCP_ANL_SHIPMENT_PLAN_FG X WITH(NOLOCK)               
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
                                AND Y.ITEM_ID             = BOH.ITEM_ID      
                  WHERE 1=1 ;            
              END              
           -------------------------------------------------------------------------------------------------------------                           
            -- 10. MKT_FCST ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID,ELECTRODE_TYPE UPDATE    
            -------------------------------------------------------------------------------------------------------------                           
             UPDATE X    
               SET X.ORIGIN_FROM_DIVISION_ID = ISNULL(Y.DIVISION_ID,'')    
              FROM #tmp_SCP_ANL_SHIPMENT_PLAN_FG X WITH (NOLOCK)
					INNER JOIN SCM_MST_DIVISION DM WITH(NOLOCK)  -- 2023.03.29 HM JV 가상 사업부 추가 대응
							ON DM.DIVISION_ID = X.DIVISION_ID
						   AND DM.VALID_YN	  = 'Y'
              LEFT OUTER JOIN DBO.SCM_MST_SITE Y  WITH (NOLOCK)       -- from   PLANT_SITE_ID    
                           ON 0 = 0  
--                          AND Y.SITE_TYPE   = 'PLANT'        
                          -- 2023.03.29 AND (CASE WHEN X.DIVISION_ID IN ('EE', 'EE_UC') THEN '0' ELSE X.DIVISION_ID END ) = (CASE WHEN X.DIVISION_ID IN ('EE', 'EE_UC') THEN '0' ELSE Y.DIVISION_ID END )  -- 2022.03.22 KSW JV GM 반영 EE_UC 추가 - 0 --> '0' 변경
						  AND Y.DIVISION_ID = CASE WHEN DM.ATTRIBUTE3 = 'EE' -- 2023.03.29 HM JV 가상 사업부 추가 대응
												   THEN Y.DIVISION_ID
												   ELSE X.DIVISION_ID
											   END 
                          AND Y.SCM_SITE_ID  = REPLACE(X.FROM_SITE,'-S','')  
                          AND Y.VALID_YN ='Y'       
    
            UPDATE X    
               SET X.ORIGIN_TO_DIVISION_ID = ISNULL(Y.DIVISION_ID,'')    
              FROM #tmp_SCP_ANL_SHIPMENT_PLAN_FG X WITH (NOLOCK)    
					INNER JOIN SCM_MST_DIVISION DM WITH(NOLOCK)  -- 2023.03.29 HM JV 가상 사업부 추가 대응
							ON DM.DIVISION_ID = X.DIVISION_ID
						   AND DM.VALID_YN	  = 'Y'
              --LEFT OUTER JOIN DBO.SCM_MST_SITE Y  WITH (NOLOCK)       -- to   SALES_SITE_ID 
                   LEFT OUTER JOIN (SELECT MIN(DIVISION_ID) DIVISION_ID, SCM_SITE_ID, VALID_YN
				                    FROM   DBO.SCM_MST_SITE  WITH (NOLOCK)       -- to   SITE_ID
									WHERE  valid_yn = 'Y'
									GROUP BY SCM_SITE_ID, VALID_YN
								   ) Y     
                           ON 0 = 0  
--                          AND Y.SITE_TYPE   = 'PLANT'        
                          -- 2023.03.29 AND (CASE WHEN X.DIVISION_ID IN ('EE', 'EE_UC') THEN '0' ELSE X.DIVISION_ID END ) = (CASE WHEN X.DIVISION_ID IN ('EE', 'EE_UC') THEN '0' ELSE Y.DIVISION_ID END )  -- 2022.03.22 KSW JV GM 반영 EE_UC 추가 - 0 --> '0' 변경
 						  AND Y.DIVISION_ID = CASE WHEN DM.ATTRIBUTE3 = 'EE' -- 2023.03.29 HM JV 가상 사업부 추가 대응
												   THEN Y.DIVISION_ID
												   ELSE X.DIVISION_ID
											   END 
                          AND Y.SCM_SITE_ID  = REPLACE(X.TO_SITE,'-S','')  
                          AND Y.VALID_YN ='Y'          
                              
            UPDATE X    
               SET X.ELECTRODE_TYPE = ISNULL(Y.ELECTRODE_TYPE,''), X.OPERATION_GROUP = Y.OPERATION_GROUP    
              FROM #tmp_SCP_ANL_SHIPMENT_PLAN_FG X WITH (NOLOCK)    
              INNER JOIN DBO.SCP_MST_FINAL_ITEM_V Y  WITH (NOLOCK)           
                    ON 0 = 0        
                   AND X.DIVISION_ID      = @p_division_id  
                   AND X.ITEM_ID          = Y.ITEM_ID        
                   
          
                                                                           
          -------------------------------------------------------------------------------------------------------------                         
          -- 11. SCP_ANL_SHIPMENT_PLAN_FG 삭제                         
          -------------------------------------------------------------------------------------------------------------              
            --DELETE FROM SCP_ANL_SHIPMENT_PLAN_FG                            
            --WHERE DIVISION_ID = @p_division_id AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd AND PLAN_TYPE = @p_plan_type AND SEQ = @p_seq        
            -- 소형(40) 삭제시 속도 계선.
            -- SELECT @@ROWCOUNT  
            -- 1000 [1043::PR::2][07:23]
            -- 10000 [1043::PR::2][10:12]
            -- 100000 [1043::PR::2][05:38]
            --WHILE @@ROWCOUNT > 0  -- 상단의 UPDATE문 @@ROWCOUNT
            --BEGIN
            --  DELETE TOP (10000)
            --  FROM SCP_ANL_SHIPMENT_PLAN_FG                            
            --  WHERE DIVISION_ID = @p_division_id AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd AND PLAN_TYPE = @p_plan_type AND SEQ = @p_seq        
            --END

			-- 2021.11.11 튜닝개선안에 따른 삭제방식 변경
			BEGIN TRAN
				WHILE(1 = 1)
				BEGIN
				  DELETE TOP (10000)
				  FROM dbo.SCP_ANL_SHIPMENT_PLAN_FG                            
				  WHERE DIVISION_ID = @p_division_id AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd AND PLAN_TYPE = @p_plan_type AND SEQ = @p_seq;

				  IF(@@ROWCOUNT = 0)
				  BEGIN
				   BREAK;
				  END
				END                
			COMMIT

          -------------------------------------------------------------------------------------------------------------                           
          -- 12. SCP_ANL_SHIPMENT_PLAN_FG 입력                           
          -------------------------------------------------------------------------------------------------------------       
          INSERT INTO /* PR_SCP_ANL_SHIPMENT_PLAN_FG */                         
                      dbo.SCP_ANL_SHIPMENT_PLAN_FG                          
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
                      FROM #tmp_SCP_ANL_SHIPMENT_PLAN_FG WITH (NOLOCK)                          
                     WHERE 1=1    
					 -- * 2021.05.10   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 플랜 대응 - start
                     --AND YYYYMMDD < CONVERT(VARCHAR,DATEADD(D,364,CONVERT(DATETIME,@p_plan_start_yyyymmdd,112)),112)       
					 --
					 AND YYYYMMDD < @v_pet_date    
					 -- * 2021.05.10   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 플랜 대응 - end

                     GROUP BY  DIVISION_ID                          
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
        
        -----------------------------------------------------------
        -- 임시테이블 삭제
        -----------------------------------------------------------
        IF OBJECT_ID('tempdb..#tmp_SCP_ANL_SHIPMENT_PLAN_FG') IS NOT NULL
            DROP TABLE #tmp_SCP_ANL_SHIPMENT_PLAN_FG
            
        IF OBJECT_ID('tempdb..#TMP_SCP_PLN_NET_DEMAND_V') IS NOT NULL
            DROP TABLE #TMP_SCP_PLN_NET_DEMAND_V
            
        IF OBJECT_ID('tempdb..#Z') IS NOT NULL
            DROP TABLE #Z
            
        IF OBJECT_ID('tempdb..#Y') IS NOT NULL
            DROP TABLE #Y
            
        IF OBJECT_ID('tempdb..#BOH') IS NOT NULL
            DROP TABLE #BOH 
                               
        -- TXN LOG                        
        SET @v_log_type     = N'TXN';          
        SET @n_log_count    = @@ROWCOUNT;                        
        SET @v_log_message  = N'INSERT INTO '+@v_table_id;                        
        SET @v_description  = N'Process Complete...' + ':' + CONVERT(CHAR(8), @d_event_date, 112);                        
        SET @d_event_date   = SYSDATETIME();                        
                        
        EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name                        
                                  ,@p_log_type      = @v_log_type                        
                                  ,@p_log_count     = @n_log_count                         
                                  ,@p_log_message   = @v_log_message                  
                                  ,@p_description   = @v_description                         
                                  ,@p_event_date    = @d_event_date                         
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
    -- 임시 운영반영시에 주석처리 할것.                
     SET @v_exec_time  =  REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +                 
                          REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))                 
                
                    
    -- 종료 LOG                        
    SET @v_log_type     = N'END';                        
    SET @v_log_message  = N'########## END of procedure ##########';                        
    SET @v_description  = N'[' + @p_master_id + ']['+@p_engine_plan_id+'][' + @v_exec_time + ']';    
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
                        
  END;          

