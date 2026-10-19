                      
/*                    
 * Program ID   : PR_SCP_ANL_PSI_ELECTRODE                      
 * Description  : PR_SCP_ANL_CREATE_DATA 에서 호출함.                    
 * OutTable     :                    
 * Execute      : EXEC PR_SCP_ANL_PSI_ELECTRODE
                                                   @p_plan_cycle          = 'WEEKLY'
                                                 , @p_plan_start_yyyymmdd = '20181008'
                                                 , @p_plan_id             = '1047'
                                                 , @p_modeling_id         = '4'
                                                 , @p_seq                 = '1'
                                                 , @p_plan_type           = 'SE'
                                                 , @p_master_id           = 'EE::WEEKLY'
                                                 , @p_division_id         = 'EE'
                                                 ,@p_engine_plan_id      = '1047::SE::1'
                                                 , @p_user_id             = 'KTH'  
 * Program History                    
 *===================================================================================================                    
 *   Date       In Charge      Description                    
 *===================================================================================================                    
 * 2018.10.04   KTH         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트                     
 * 2018.11.05   KTH         TCO_CELL_YN 로직 반영
 * 2019.01.28   KTH         외주PACKER의 업체코드 조회 로직 수정
 * 2021-05-10   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 플랜 대응
 * 2022.03.23	KSW			GM JV 반영 :: EE_UC  추가
 * 2022.06.27   sclee.lee   PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 - isuzu관련 조회구문 변경
 * 2023.03.29	hrkim		PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 대응
 */                    
                     
CREATE PROCEDURE [dbo].[PR_SCP_ANL_PSI_ELECTRODE]              
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
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SCP_ANL_PSI_ELECTRODE';            
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...            
    DECLARE @n_log_count    INTEGER = 0;            
    DECLARE @v_log_message  NVARCHAR(1000);            
    DECLARE @v_description  NVARCHAR(500);          
    DECLARE @v_table_id     NVARCHAR(150) = N'SCM_SYS_LOG_BATC';         
    DECLARE @d_event_date   DATETIME;            
       
  -- 시작 LOG            
    SET @v_log_type = N'START';            
    SET @v_log_message = N'########## Start of procedure ##########';            
    SET @v_description = @v_program_name + ':' + N' PR_SCP_ANL_PSI_ELECTRODE INSERT LOGIC';            
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
	
	-- * 2021-05-10   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 플랜 대응 - start
	-- CONVERT(VARCHAR,DATEADD(D,@p_bp_plan_days,CONVERT(DATETIME,@p_plan_start_yyyymmdd,112)),112)
	--
	DECLARE @v_pet_date		NVARCHAR(12) = '';

	--  Plan End Date
	SELECT @v_pet_date = p.horizon_end_date
	FROM   dbo.scm_mst_plan p WITH(NOLOCK)
	WHERE  p.division_id = @p_division_id
	AND    p.plan_id     = @p_plan_id ;

	SET @v_pet_date = CONVERT(VARCHAR(8), DATEADD(DAY, 1, CONVERT(DATETIME, @v_pet_date, 112)), 112)
    -- * 2021-05-10   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 플랜 대응 - end
                
    BEGIN TRY                    
      BEGIN                    
--        BEGIN TRAN TX_PSI1                    
          -------------------------------------------------------------------------------------------------------------                     
          -- 0. temp 테이블 생성 : Measure까지 생성후 마지막에 한번에 입력하기 위해서                    
          -------------------------------------------------------------------------------------------------------------                     
          IF OBJECT_ID('tempdb..#tmp_SCP_ANL_PSI_ELECTRODE') IS NOT NULL                    
            DROP TABLE #tmp_SCP_ANL_PSI_ELECTRODE                    
                    
            CREATE TABLE #tmp_SCP_ANL_PSI_ELECTRODE                    
            (                    
              DIVISION_ID               nvarchar(030)                        
             ,PLAN_START_YYYYMMDD       nvarchar(008)                        
             ,PLAN_TYPE                 nvarchar(050)                        
             ,SEQ                       bigint                              
             ,OPERATION_GROUP           nvarchar(010)                        
             ,FROM_SITE                 nvarchar(030)                        
             ,ITEM_ID                   nvarchar(050)                         
             ,BOH                       numeric(20, 10)                                   
             ,PSI_TYPE                  nvarchar(001)    -- S,P,I                    
             ,PSI_VALUE                 nvarchar(100)    -- S: TO_SITE, P: PROD_LINE, I: MODEL_INVENTORY / ACTIVATE_COMPLETED(활성화완료) / ACTIVATE_PROGRESS(활성화진행중)                    
             ,TO_SITE                   nvarchar(030)                        
             ,PROD_LINE                 nvarchar(050)                        
             ,YYYYMMDD                  nvarchar(008)                    
             ,QTY                       numeric(20, 10)         
             ,CELL_QTY                  numeric(20, 10)  -- CELL_QTY 
             ,INVENTORY_TYPE            nvarchar(050)                 
             ,ORIGIN_FROM_DIVISION_ID   nvarchar(030)     
             ,ORIGIN_TO_DIVISION_ID     nvarchar(030)     
             ,ELECTRODE_TYPE            nvarchar(030)            
             ,TO_SITE_ORG               nvarchar(030)   -- TO_SITE가 '-' 일 경우 ORIGIN_TO_DIVISION_ID 를 찾기 위해서    
--             ,TO_SITE_TYPE              NVARCHAR(10)    -- TO_SITE의 SITE_TYPE
             ,ATTRIBUTE1                numeric(20, 10) -- CONVERT_QTY_CELL
             ,ATTRIBUTE7                nvarchar(150)   --- TCO_CELL_YN 추가 
            );                    
                    
                    
            -------------------------------------------------------------------------------------------------------------                     
            -- 1 SHIPMENT 입력 - SPI_TYPE ='S'                    
            -------------------------------------------------------------------------------------------------------------          
              INSERT INTO #tmp_SCP_ANL_PSI_ELECTRODE                    
                  (                    
                   DIVISION_ID                              
                  ,PLAN_START_YYYYMMDD                      
                  ,PLAN_TYPE                               
                  ,SEQ 
                  ,OPERATION_GROUP                          
                  ,FROM_SITE                                
                  ,ITEM_ID                                  
                  ,PSI_TYPE                                 
                  ,PSI_VALUE                                
                  ,TO_SITE                                  
                  ,PROD_LINE                                
                  ,YYYYMMDD                                 
                  ,QTY                                      
                  ,INVENTORY_TYPE        
                  ,ORIGIN_FROM_DIVISION_ID             
                  ,ORIGIN_TO_DIVISION_ID           
                  ,ELECTRODE_TYPE       
                  ,TO_SITE_ORG        
                   )                    
    
                  SELECT                     
                       A.DIVISION_ID                             
                      ,A.PLAN_START_YYYYMMDD                                       
                      ,A.PLAN_TYPE                               
                      ,A.SEQ                                     
                      ,A.OPERATION_GROUP                         
                      ,A.FROM_SITE         AS FROM_SITE                    
                      ,A.ITEM_ID                                 
                      ,'S'                 AS PSI_TYPE            -- S,P,I                    
                      ,A.TO_SITE           AS PSI_VALUE                    
                      ,A.TO_SITE           AS TO_SITE                    
                      ,''                  AS PROD_LINE          
                      ,A.YYYYMMDD                       
                      ,SUM(ISNULL(A.COMPLETE_QTY,0)) AS QTY                                                  
                      ,''                  AS INVENTORY_TYPE          --재고구분        
                      ,A.ORIGIN_FROM_DIVISION_ID             
                      ,A.ORIGIN_TO_DIVISION_ID           
                      ,A.ELECTRODE_TYPE              
                      ,A.TO_SITE             
                 FROM SCP_PLN_SHIPMENT_PLAN A    WITH (NOLOCK)                
                WHERE 1 = 1                    
                  AND A.DIVISION_ID         = @p_division_id                    
                  AND A.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd                    
                  AND A.PLAN_TYPE           = @p_plan_type                    
                  AND A.SEQ                 = @p_seq                    
--                  AND A.ITEM_ID             ='ECE0630N1-02'    
             GROUP BY                     
                     A.DIVISION_ID                             
                    ,A.PLAN_START_YYYYMMDD                     
                    ,A.PLAN_TYPE                               
                    ,A.SEQ                                     
                    ,A.OPERATION_GROUP                         
                    ,A.FROM_SITE                      
                    ,A.ITEM_ID                                 
                    ,A.TO_SITE                    
                    ,A.YYYYMMDD             
                    ,A.ORIGIN_FROM_DIVISION_ID             
                    ,A.ORIGIN_TO_DIVISION_ID           
                    ,A.ELECTRODE_TYPE       
                    ;                    
    
            -------------------------------------------------------------------------------------------------------------                     
            -- 2 PRODUCTION 입력 - SPI_TYPE ='P'                    
            -------------------------------------------------------------------------------------------------------------                     
                    
              INSERT INTO #tmp_SCP_ANL_PSI_ELECTRODE                    
             (                    
           DIVISION_ID                              
                  ,PLAN_START_YYYYMMDD                      
                  ,PLAN_TYPE                                
                  ,SEQ                                      
                  ,OPERATION_GROUP                          
                  ,FROM_SITE                                
                  ,ITEM_ID                                  
                  ,PSI_TYPE                                 
                  ,PSI_VALUE                                
                  ,TO_SITE                                  
                  ,PROD_LINE                                
                  ,YYYYMMDD                                 
                  ,QTY                                      
                  ,INVENTORY_TYPE              
                  ,ORIGIN_FROM_DIVISION_ID             
                  ,ORIGIN_TO_DIVISION_ID           
                  ,ELECTRODE_TYPE      
                  ,ATTRIBUTE7
                   )                    
              SELECT                     
                     A.DIVISION_ID                             
                    ,A.PLAN_START_YYYYMMDD                     
                    ,A.PLAN_TYPE                               
                    ,A.SEQ                                     
                    ,A.OPERATION_GROUP                         
                    ,A.SITE_ID              AS FROM_SITE                    
                    ,A.ITEM_ID                                 
                    ,'P'                    AS PSI_TYPE            -- S,P,I                    
                    ,A.RESOURCE_ID          AS PSI_VALUE                    
                    ,''                     AS TO_SITE                    
                    ,A.RESOURCE_ID          AS PROD_LINE                    
                    ,CONVERT(NVARCHAR(8), A.END_TIME,112)  AS YYYYMMDD                    
                    ,SUM(ISNULL(A.COMPLETE_QTY,0))   AS QTY                                                  
                    ,''                     AS INVENTORY_TYPE          --재고구분        
                    ,A.ORIGIN_DIVISION_ID   AS  ORIGIN_FROM_DIVISION_ID          
                    ,''                     AS ORIGIN_TO_DIVISION_ID           
                    ,A.ELECTRODE_TYPE          
                    ,A.ATTRIBUTE7
              FROM SCP_PLN_PRODUCTION_PLAN A    WITH (NOLOCK)                
              WHERE 1 = 1                    
                AND A.DIVISION_ID            = @p_division_id                    
                AND A.PLAN_START_YYYYMMDD    = @p_plan_start_yyyymmdd                    
                AND A.PLAN_TYPE              = @p_plan_type                    
                AND A.SEQ                    = @p_seq                    
                AND ( LEFT(A.operation_id,5) IN (--LOOKUP_TYPE 'SCP_PLAN_OPERATION' 에 정의된 공정만 조회            
                                                    SELECT segment1 AS OPERATION_ID            
                                                             FROM scm_adm_lookup_master_detail WITH(NOLOCK)               
                                                            WHERE lookup_type = 'SCP_PLAN_OPERATION' 
                                                 )            
                      OR            
                          A.operation_id     IN (--외주PACKER의 업체코드            
                                                    SELECT PLANT_ID  AS OPERATION_ID            
                                                    FROM SCM_MST_SITE WITH(NOLOCK)                  
                                                   WHERE 1=1            
--                                                     AND DIVISION_ID = A.division_id 
                                                    AND SITE_TYPE   = 'PLANT'            
                                                    AND OSP_YN      = 'Y'              
                                                )             
                      -- PJ20216891	
                      -- ISUZU item
                      OR (
                          LEFT(A.operation_id,5) = 'P5000'
                          AND EXISTS (
                                      SELECT 1
                                        FROM dbo.SCM_MST_FINAL_ITEM_V A1 WITH(NOLOCK)
                                       INNER JOIN dbo.SCP_MST_FINAL_ITEM_V B1 WITH(NOLOCK) ON A1.ITEM_ID = B1.ITEM_ID
                                       WHERE A1.ITEM_ID = A.ITEM_ID
                                         AND A1.IS_YN = 'Y'
                                     )
                         )
                             )            
                AND A.OPERATION_ID NOT IN ('F1000','F6000') --활성화공정제외      
            GROUP BY                     
                     A.DIVISION_ID                             
                    ,A.PLAN_START_YYYYMMDD                     
                    ,A.PLAN_TYPE                               
                    ,A.SEQ                                     
                    ,A.OPERATION_GROUP                         
                    ,A.SITE_ID                      
                    ,A.ITEM_ID                                 
                    ,A.RESOURCE_ID                    
                    ,CONVERT(NVARCHAR(8), A.END_TIME,112)               
                    ,A.ORIGIN_DIVISION_ID             
                    ,A.ELECTRODE_TYPE         
                    ,A.ATTRIBUTE7       
                    ;                    
            -------------------------------------------------------------------------------------------------------------                     
            -- 3. STOCK 입력 - SPI_TYPE ='I'                    
            -------------------------------------------------------------------------------------------------------------                     
            -- I    ACTIVATE_COMPLETED  C   활성화 완료                    
            -- I    ACTIVATE_PROGRESS   P   활성화 진행중                    
            -- I    MODEL_INVENTORY     I                       
            -------------------------------------------------------------------------------------------------------------                  
      
              INSERT INTO #tmp_SCP_ANL_PSI_ELECTRODE                    
                  (                    
                   DIVISION_ID                              
                  ,PLAN_START_YYYYMMDD                      
                  ,PLAN_TYPE                                
                  ,SEQ                                      
                  ,OPERATION_GROUP                          
                  ,FROM_SITE                            
                  ,ITEM_ID                                  
                  ,PSI_TYPE                                 
                  ,PSI_VALUE                                
                  ,TO_SITE                                  
                  ,PROD_LINE                                
                  ,YYYYMMDD                                 
                  ,QTY                                      
                  ,INVENTORY_TYPE           
                  ,ORIGIN_FROM_DIVISION_ID             
                  ,ORIGIN_TO_DIVISION_ID           
                  ,ELECTRODE_TYPE         
                  )                
            -------------------------------------------------------------------------------------------------------------                     
            -- 3.1 전극,팩 EOH 재고                   
            -------------------------------------------------------------------------------------------------------------             
        
         
              SELECT                     
                       A.DIVISION_ID                             
                      ,A.PLAN_START_YYYYMMDD                     
                      ,A.PLAN_TYPE                               
                      ,A.SEQ                                     
                      ,A.OPERATION_GROUP                         
                      ,A.SITE_ID              AS FROM_SITE                               
                      ,A.ITEM_ID                                 
                      ,'I'                    AS PSI_TYPE            -- S,P,I                    
                      ,'MODEL_INVENTORY'      AS PSI_VALUE                    
                    ,''                     AS TO_SITE                    
                      ,''                     AS PROD_LINE                               
                      ,A.YYYYMMDD                                
                      ,SUM(ISNULL(A.PSI_EOH_QTY,0))    AS QTY                                                  
                      ,'I'                    AS INVENTORY_TYPE          --재고구분             
                      ,A.ORIGIN_DIVISION_ID             
                      ,''                     AS ORIGIN_TO_DIVISION_ID           
                      ,A.ELECTRODE_TYPE             
                FROM SCP_PLN_PLANT_ONHAND A WITH(NOLOCK)                    
               WHERE 1 = 1                    
                 AND A.DIVISION_ID           = @p_division_id                    
                 AND A.PLAN_START_YYYYMMDD   = @p_plan_start_yyyymmdd                    
                 AND A.PLAN_TYPE             = @p_plan_type                    
                 AND A.SEQ                   = @p_seq              
                 AND A.SITE_ID               NOT LIKE '%-A' --CELL PLANT제외       
                 AND A.OPERATION_GROUP       <> 'A' --CELL PLANT제외                     
               GROUP BY                     
                       A.DIVISION_ID                             
                      ,A.PLAN_START_YYYYMMDD                     
                      ,A.PLAN_TYPE                               
                      ,A.SEQ                                     
                      ,A.OPERATION_GROUP                         
                      ,A.SITE_ID                      
                      ,A.ITEM_ID                              
                      ,A.YYYYMMDD        
                      ,A.ORIGIN_DIVISION_ID             
                      ,A.ELECTRODE_TYPE                     
               UNION ALL                    
           -------------------------------------------------------------------------------------------------------------                     
           -- 3.2 셀 EOH 특성완료재고(MODEL INVENTORY)=CHAR                
           -------------------------------------------------------------------------------------------------------------                
                
                SELECT A.DIVISION_ID                             
                      ,A.PLAN_START_YYYYMMDD                     
                      ,A.PLAN_TYPE                               
                      ,A.SEQ                                     
                      ,A.OPERATION_GROUP                         
                      ,A.SITE_ID              AS FROM_SITE                               
                      ,A.ITEM_ID                                 
                      ,'I'                    AS PSI_TYPE            -- S,P,I                    
                      ,'MODEL_INVENTORY'      AS PSI_VALUE                    
                      ,''                     AS TO_SITE                    
                      ,''                     AS PROD_LINE                               
                      ,A.YYYYMMDD                                
                      ,SUM(ISNULL(A.PSI_EOH_QTY,0))   AS QTY                                                  
                      ,'I'                    AS INVENTORY_TYPE          --재고구분      
                      ,A.ORIGIN_DIVISION_ID             
                      ,''                     AS ORIGIN_TO_DIVISION_ID           
                      ,A.ELECTRODE_TYPE                    
                FROM SCP_PLN_PLANT_ONHAND A WITH(NOLOCK)                    
               WHERE 1 = 1                 
                 AND A.DIVISION_ID           = @p_division_id                    
                 AND A.PLAN_START_YYYYMMDD   = @p_plan_start_yyyymmdd                    
                 AND A.PLAN_TYPE             = @p_plan_type                    
                 AND A.SEQ                   = @p_seq                    
                 AND A.STOCK_TYPE            IN ( 'CHAR', 'A_MOVE_WH','A_OUT_WH')                   
               GROUP BY                     
                       A.DIVISION_ID                             
                      ,A.PLAN_START_YYYYMMDD                     
                      ,A.PLAN_TYPE                               
                      ,A.SEQ                                     
                      ,A.OPERATION_GROUP                         
                      ,A.SITE_ID                      
                      ,A.ITEM_ID                              
                      ,A.YYYYMMDD         
                      ,A.ORIGIN_DIVISION_ID             
                      ,A.ELECTRODE_TYPE                           
              UNION ALL            
                         
           -------------------------------------------------------------------------------------------------------------                     
           -- 3.3 셀 특성완료 생산계획=F6000 생산계획                  
           -------------------------------------------------------------------------------------------------------------                
                SELECT A.DIVISION_ID                             
                      ,A.PLAN_START_YYYYMMDD                     
                      ,A.PLAN_TYPE                               
                      ,A.SEQ                                     
                      ,A.OPERATION_GROUP                         
                      ,A.SITE_ID                AS FROM_SITE                         
                      ,A.ITEM_ID                                 
                      ,'I'                      AS PSI_TYPE            -- S,P,I                    
                      ,'ACTIVATE_COMPLETED'     AS PSI_VALUE                    
                      ,''                       AS TO_SITE                    
                      ,''                       AS PROD_LINE                               
                      ,CONVERT(VARCHAR(8),A.END_TIME,112)   AS YYYYMMDD                                
--                      ,ROUND(SUM(ISNULL(A.COMPLETE_QTY,0)),0)  AS QTY                       
                      ,SUM(ISNULL(A.COMPLETE_QTY,0))  AS QTY                                                  
                      ,'C'                      AS INVENTORY_TYPE          --재고구분            
                       ,A.ORIGIN_DIVISION_ID             
                      ,''                       AS ORIGIN_TO_DIVISION_ID           
                      ,A.ELECTRODE_TYPE             
                FROM SCP_PLN_PRODUCTION_PLAN A WITH(NOLOCK)                    
               WHERE 1 = 1                    
                 AND A.DIVISION_ID           = @p_division_id                    
                 AND A.PLAN_START_YYYYMMDD   = @p_plan_start_yyyymmdd                 
                 AND A.PLAN_TYPE             = @p_plan_type                    
                 AND A.SEQ                   = @p_seq                    
                 AND A.OPERATION_ID          = 'F6000'                    
               GROUP BY                     
                      A.DIVISION_ID                                                   
                     ,A.PLAN_START_YYYYMMDD                     
                     ,A.PLAN_TYPE                               
                     ,A.SEQ                                     
                     ,A.OPERATION_GROUP                         
                     ,A.SITE_ID                      
                     ,A.ITEM_ID                              
                     ,CONVERT(VARCHAR(8),A.END_TIME,112)          
                     ,A.ORIGIN_DIVISION_ID             
                     ,A.ELECTRODE_TYPE                       
              UNION ALL        
           -------------------------------------------------------------------------------------------------------------        
           -- 3.4 셀 해당일자의 CHAR_AVAILABLE  (특성완료)= ('FORMED')         
           -------------------------------------------------------------------------------------------------------------                
                SELECT A.DIVISION_ID                             
                      ,A.PLAN_START_YYYYMMDD                     
                      ,A.PLAN_TYPE                               
                      ,A.SEQ                                     
                      ,A.OPERATION_GROUP                         
                      ,A.SITE_ID              AS FROM_SITE                               
                      ,A.ITEM_ID                                 
                      ,'I'                    AS PSI_TYPE            -- S,P,I                    
                      ,'CHAR_AVAILABLE'       AS PSI_VALUE                    
                      ,''                     AS TO_SITE                    
                      ,''                     AS PROD_LINE                               
                      ,A.YYYYMMDD     
                      ,SUM(ISNULL(A.PSI_EOH_QTY,0))   AS QTY                                                  
                      ,'P'                    AS INVENTORY_TYPE          --재고구분      
                      ,A.ORIGIN_DIVISION_ID             
                      ,''                     AS ORIGIN_TO_DIVISION_ID           
                      ,A.ELECTRODE_TYPE                           
                FROM SCP_PLN_PLANT_ONHAND A WITH(NOLOCK)                   
                 WHERE 1 = 1           
                  AND A.DIVISION_ID           = @p_division_id                    
                  AND A.PLAN_START_YYYYMMDD   = @p_plan_start_yyyymmdd                    
                  AND A.PLAN_TYPE             = @p_plan_type                    
                  AND A.SEQ                   = @p_seq                    
                  AND A.STOCK_TYPE            = 'FORMED'                    
                GROUP BY                     
                       A.DIVISION_ID                             
                      ,A.PLAN_START_YYYYMMDD                     
                      ,A.PLAN_TYPE                               
                      ,A.SEQ                                     
                      ,A.OPERATION_GROUP                         
                      ,A.SITE_ID                      
                      ,A.ITEM_ID                              
                      ,A.YYYYMMDD                 
                      ,A.ORIGIN_DIVISION_ID             
                      ,A.ELECTRODE_TYPE                
      
                UNION ALL      
           -------------------------------------------------------------------------------------------------------------                     
           -- 3.4 셀 해당일자의 활성화진행중(특성완료전)= ('ASSM','FORMING','FORMED','CHARING','FOR_STOCKPLAN')                   
           -------------------------------------------------------------------------------------------------------------                
                SELECT A.DIVISION_ID                             
                      ,A.PLAN_START_YYYYMMDD                     
                      ,A.PLAN_TYPE                               
                      ,A.SEQ                                     
                      ,A.OPERATION_GROUP                         
                      ,A.SITE_ID              AS FROM_SITE                               
                      ,A.ITEM_ID                                 
                      ,'I'                    AS PSI_TYPE            -- S,P,I                    
                      ,'ACTIVATE_PROGRESS'    AS PSI_VALUE                    
                      ,''                     AS TO_SITE                    
                      ,''                     AS PROD_LINE                               
                      ,A.YYYYMMDD                                
                      ,SUM(ISNULL(A.PSI_EOH_QTY,0))   AS QTY                                                  
                      ,'P'                    AS INVENTORY_TYPE          --재고구분          
                      ,A.ORIGIN_DIVISION_ID             
                      ,''                     AS ORIGIN_TO_DIVISION_ID           
                      ,A.ELECTRODE_TYPE                       
                FROM SCP_PLN_PLANT_ONHAND A WITH(NOLOCK)                   
                 WHERE 1 = 1           
                  AND A.DIVISION_ID           = @p_division_id                    
                  AND A.PLAN_START_YYYYMMDD   = @p_plan_start_yyyymmdd                    
                  AND A.PLAN_TYPE             = @p_plan_type                    
                  AND A.SEQ                   = @p_seq                    
                  AND A.STOCK_TYPE            IN ( 'ASSM','FORMING','FORMED','CHARING','FOR_STOCKPLAN' )                    
                GROUP BY                     
                       A.DIVISION_ID                             
                      ,A.PLAN_START_YYYYMMDD              
                      ,A.PLAN_TYPE                               
                      ,A.SEQ                       
                      ,A.OPERATION_GROUP                         
                      ,A.SITE_ID                      
                      ,A.ITEM_ID                              
                      ,A.YYYYMMDD                   
                      ,A.ORIGIN_DIVISION_ID             
                      ,A.ELECTRODE_TYPE              
--                order by ITEM_ID, YYYYMMDD                  
                      ;                         
                
         -------------------------------------------------------------------------------------------------------------                     
          -- 3.5 SCP_ANL_PSI_PRODUCTION MEASURE별 짝 맞추기 데이타 입력                     
          -------------------------------------------------------------------------------------------------------------                
           /*                
            * 재고 또는 생산이 존재하지만, 출하가 존재하지 않는 경우 0으로 SHIPMENT MEASURE 생성                
            */                           
           INSERT INTO  #tmp_SCP_ANL_PSI_ELECTRODE                 
                      ( DIVISION_ID                
                       ,PLAN_START_YYYYMMDD                
                       ,PLAN_TYPE                
                       ,SEQ                
                       ,OPERATION_GROUP                
                       ,FROM_SITE                
                       ,ITEM_ID                
                       ,PSI_TYPE                
                       ,PSI_VALUE                
                       ,YYYYMMDD                
--                       ,ELECTRODE_TYPE                
                       ,QTY                
                       ,TO_SITE                
                       ,PROD_LINE                
                       ,INVENTORY_TYPE                
             
                       )                
                SELECT  DIVISION_ID                
                       ,PLAN_START_YYYYMMDD                
                       ,PLAN_TYPE                
                       ,SEQ                
                       ,OPERATION_GROUP                
                       ,FROM_SITE                
                       ,ITEM_ID                
                       ,'S'    AS PSI_TYPE                
                       ,''     AS PSI_VALUE                
                       ,YYYYMMDD                
                      -- ,ELECTRODE_TYPE                
                       ,0.0   AS QTY                
                       ,''    AS TO_SITE                
                       ,''    AS PROD_LINE                
                       ,''    AS INVENTORY_TYPE                
                  FROM                
                       (                
                          SELECT CONVERT(VARCHAR(8),START_DTTM,112) AS YYYYMMDD             
                            FROM TH_ENG_BUCKET_INFO_SN WITH(NOLOCK)                  
                           WHERE PLAN_ID    = @p_engine_plan_id --'1022::PR::1'                  
                            AND MASTER_ID   = @p_master_id      -- '81::WEEKLY'                
                       ) A,                
                       (                
                         SELECT DISTINCT DIVISION_ID,PLAN_START_YYYYMMDD,PLAN_TYPE,SEQ,OPERATION_GROUP,FROM_SITE,ITEM_ID--,ELECTRODE_TYPE                
                           FROM #tmp_SCP_ANL_PSI_ELECTRODE X WITH(NOLOCK)                
                          WHERE 1=1                
                            AND DIVISION_ID         = @p_division_id--'81'                
                            AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd--'20180416'                
                            AND PLAN_TYPE           = @p_plan_type--'PR'          
                            AND SEQ                 = @p_seq --1                
                            AND PSI_TYPE            IN ( 'I','P')                
                           -- AND INVENTORY_TYPE      IN ('I','C','P')                
                            AND NOT EXISTS (                
                                           SELECT 'X'                
                                             FROM #tmp_SCP_ANL_PSI_ELECTRODE Z WITH(NOLOCK)                
                                            WHERE 1=1                
                                              AND Z.DIVISION_ID         = X.DIVISION_ID                
                                              AND Z.PLAN_START_YYYYMMDD = X.PLAN_START_YYYYMMDD                
                                              AND Z.PLAN_TYPE           = X.PLAN_TYPE                
                                              AND Z.SEQ                 = X.SEQ                
                                              AND Z.PSI_TYPE            = 'S'                
                                              AND Z.ITEM_ID             = X.ITEM_ID                
                                              AND Z.FROM_SITE           = X.FROM_SITE                
                                           )                
                       ) B;                  
                
           /*                
            * 재고 또는 출하가  존재하지만, 생산이  존재하지 않는 경우 0으로 PRODUCTION MEASURE 생성                
            */                             
           INSERT INTO  #tmp_SCP_ANL_PSI_ELECTRODE                 
                      ( DIVISION_ID                
                       ,PLAN_START_YYYYMMDD                
                       ,PLAN_TYPE                
                       ,SEQ                
                       ,OPERATION_GROUP                
                       ,FROM_SITE                
                       ,ITEM_ID                
                       ,PSI_TYPE                
                       ,PSI_VALUE                
                       ,YYYYMMDD                
--                       ,ELECTRODE_TYPE                
                       ,QTY                
                       ,TO_SITE                
                       ,PROD_LINE                
                       ,INVENTORY_TYPE                
              
                       )                
                SELECT  DIVISION_ID                
                       ,PLAN_START_YYYYMMDD                
                       ,PLAN_TYPE                
                       ,SEQ                
                       ,OPERATION_GROUP                
                       ,FROM_SITE                
                       ,ITEM_ID                
                       ,'P'    AS PSI_TYPE                
                       ,''     AS PSI_VALUE                
                       ,YYYYMMDD                
--                       ,ELECTRODE_TYPE                
                       ,0.0   AS QTY                
                       ,''    AS TO_SITE                
                       ,''    AS PROD_LINE                
                       ,''    AS INVENTORY_TYPE                
              
                  FROM                
                       (                
                          SELECT CONVERT(VARCHAR(8),START_DTTM,112) AS YYYYMMDD                  
                            FROM TH_ENG_BUCKET_INFO_SN WITH(NOLOCK)                  
                           WHERE PLAN_ID        = @p_engine_plan_id   --'1022::PR::1'                  
                            AND MASTER_ID       = @p_master_id        --'82::WEEKLY'                
                       ) A,                
                       (                
                         SELECT DISTINCT DIVISION_ID,PLAN_START_YYYYMMDD,PLAN_TYPE,SEQ,OPERATION_GROUP,FROM_SITE,ITEM_ID--,ELECTRODE_TYPE                
                           FROM #tmp_SCP_ANL_PSI_ELECTRODE X WITH(NOLOCK)                
                          WHERE 1=1                
                            AND DIVISION_ID         = @p_division_id          --'81'                
                            AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd  --'20180416'                
                            AND PLAN_TYPE           = @p_plan_type            --'PR'                
                            AND SEQ                 = @p_seq                  --1                
                            AND PSI_TYPE            IN ( 'I','S' )                
                            -- AND INVENTORY_TYPE      IN ('I','C','P')                
                            AND NOT EXISTS (                
                                           SELECT 'X'                
                                             FROM #tmp_SCP_ANL_PSI_ELECTRODE Z WITH(NOLOCK)                
                                            WHERE 1=1                
                                              AND Z.DIVISION_ID         = X.DIVISION_ID                
                                              AND Z.PLAN_START_YYYYMMDD = X.PLAN_START_YYYYMMDD                
                                              AND Z.PLAN_TYPE           = X.PLAN_TYPE                
                                              AND Z.SEQ                 = X.SEQ                
                                              AND Z.PSI_TYPE            = 'P'                
                                              AND Z.ITEM_ID             = X.ITEM_ID                
                                              AND Z.FROM_SITE           = X.FROM_SITE                
                                           )                
                       ) B;                
                
           /*                
            * 출하가  존재하지만, 특정일자구간에 출하가 존재하지않는 경우 화면에 표현될 수 있도록 0으로 출하정보생성                
            */                            
           INSERT INTO  #tmp_SCP_ANL_PSI_ELECTRODE                 
                      ( DIVISION_ID                
                       ,PLAN_START_YYYYMMDD                
                       ,PLAN_TYPE                
                       ,SEQ                
                       ,OPERATION_GROUP                
                       ,FROM_SITE                
                       ,ITEM_ID                
                       ,PSI_TYPE                
                       ,PSI_VALUE                
                       ,YYYYMMDD              
--                       ,ELECTRODE_TYPE                
                       ,QTY                
                       ,TO_SITE                
                       ,PROD_LINE                
                       ,INVENTORY_TYPE       
                       ,TO_SITE_ORG             
             
                       )                
                SELECT  DIVISION_ID                
                       ,PLAN_START_YYYYMMDD                
                       ,PLAN_TYPE                
                       ,SEQ                
                       ,OPERATION_GROUP                
                       ,FROM_SITE                
                       ,ITEM_ID                
                       ,PSI_TYPE                
                       ,PSI_VALUE                
                       ,YYYYMMDD                
--                       ,ELECTRODE_TYPE                
                       ,0.0   AS QTY                
                       ,''    AS TO_SITE                
                       ,''    AS PROD_LINE                
                       ,''    AS INVENTORY_TYPE                
                       ,TO_SITE    
            FROM                 
                (                
                    SELECT                 
                           B.PSI_VALUE,DIVISION_ID,PLAN_START_YYYYMMDD,PLAN_TYPE,SEQ,OPERATION_GROUP,FROM_SITE,ITEM_ID,PSI_TYPE,A.YYYYMMDD--,ELECTRODE_TYPE        
                           ,TO_SITE            
                     FROM                
                          (                
                             SELECT CONVERT(VARCHAR(8),START_DTTM,112) AS YYYYMMDD                  
                               FROM TH_ENG_BUCKET_INFO_SN WITH(NOLOCK)                  
                              WHERE PLAN_ID         = @p_engine_plan_id   --'1022::PR::1'                  
                               AND MASTER_ID        = @p_master_id        --'81::WEEKLY'                
                          ) A,                
                          (                
                            SELECT DISTINCT PSI_VALUE,DIVISION_ID,PLAN_START_YYYYMMDD,PLAN_TYPE,SEQ,OPERATION_GROUP,FROM_SITE,ITEM_ID,PSI_TYPE--,ELECTRODE_TYPE                
                                , TO_SITE    
                              FROM #tmp_SCP_ANL_PSI_ELECTRODE X WITH(NOLOCK)                
                             WHERE 1=1                
                               AND DIVISION_ID         = @p_division_id         --'81'                
                               AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd --'20180416'                
                               AND PLAN_TYPE           = @p_plan_type           --'PR'                
                               AND SEQ                 = @p_seq                 --1                
                               AND PSI_TYPE            = 'S'                
                               AND PSI_VALUE       <> ''                
                          ) B                
                ) SUB                
                WHERE 1=1                
                  AND NOT EXISTS (                
                                   SELECT 'X'                
                                     FROM #tmp_SCP_ANL_PSI_ELECTRODE Z WITH(NOLOCK)                
                                    WHERE 1=1                
                                      AND Z.DIVISION_ID         = SUB.DIVISION_ID                
                                      AND Z.PLAN_START_YYYYMMDD = SUB.PLAN_START_YYYYMMDD                
                                      AND Z.PLAN_TYPE           = SUB.PLAN_TYPE                
                                      AND Z.SEQ                 = SUB.SEQ                
                                      AND Z.PSI_TYPE            = SUB.PSI_TYPE                
                    AND Z.ITEM_ID             = SUB.ITEM_ID                
                                      AND Z.FROM_SITE           = SUB.FROM_SITE                
                                      AND Z.PSI_VALUE           = SUB.PSI_VALUE                
                                      AND Z.YYYYMMDD            = SUB.YYYYMMDD                
                                      AND Z.TO_SITE             = SUB.TO_SITE         
                                 );             
                                       
                
           /*                
            * 생산이 존재하지만, 특정일자구간에 생산계획이 존재하지않는 경우 화면에 표현될 수 있도록 0으로 생산정보생성                
            */         
           INSERT INTO  #tmp_SCP_ANL_PSI_ELECTRODE                 
                      ( DIVISION_ID                
                       ,PLAN_START_YYYYMMDD                
                       ,PLAN_TYPE                
                       ,SEQ                
                       ,OPERATION_GROUP                
                        ,FROM_SITE                
                       ,ITEM_ID                
                       ,PSI_TYPE                
                       ,PSI_VALUE                
                       ,YYYYMMDD                
--                       ,ELECTRODE_TYPE                
                       ,QTY                
                       ,TO_SITE                
                       ,PROD_LINE                
                       ,INVENTORY_TYPE                
             
                       )                
                SELECT  DIVISION_ID                
                       ,PLAN_START_YYYYMMDD                
                       ,PLAN_TYPE                
                       ,SEQ                
                       ,OPERATION_GROUP                
                       ,FROM_SITE                
                       ,ITEM_ID                
                       ,PSI_TYPE                
                       ,PSI_VALUE                
                       ,YYYYMMDD                
--        ,ELECTRODE_TYPE                
                       ,0.0   AS QTY                
                       ,''    AS TO_SITE                
                       ,''    AS PROD_LINE                
                       ,''    AS INVENTORY_TYPE                
                                  
            FROM                
                (                
                    SELECT                 
                           B.PSI_VALUE,DIVISION_ID,PLAN_START_YYYYMMDD,PLAN_TYPE,SEQ,OPERATION_GROUP,FROM_SITE,ITEM_ID,PSI_TYPE,A.YYYYMMDD--,ELECTRODE_TYPE                
                     FROM                
                          (                
                             SELECT CONVERT(VARCHAR(8),START_DTTM,112) AS YYYYMMDD                  
                               FROM TH_ENG_BUCKET_INFO_SN WITH(NOLOCK)                  
                              WHERE PLAN_ID       = @p_engine_plan_id   --'1021::PR::1'                  
                               AND MASTER_ID      = @p_master_id        --'81::WEEKLY'                
                          ) A,            
                          (         
                            SELECT DISTINCT PSI_VALUE,DIVISION_ID,PLAN_START_YYYYMMDD,PLAN_TYPE,SEQ,OPERATION_GROUP,FROM_SITE,ITEM_ID,PSI_TYPE--,ELECTRODE_TYPE                
                              FROM #tmp_SCP_ANL_PSI_ELECTRODE X WITH(NOLOCK)                
                             WHERE 1=1                
                               AND DIVISION_ID         = @p_division_id         --'81'                
                               AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd --'20180416'                
                               AND PLAN_TYPE           = @p_plan_type           --'PR'                
                               AND SEQ          = @p_seq                 --1                
                               AND PSI_TYPE            = 'P'                
                               AND PSI_VALUE           <> ''                
                          ) B                
                ) SUB                
                WHERE 1=1                
                  AND NOT EXISTS (                
                                   SELECT 'X'                
                                     FROM #tmp_SCP_ANL_PSI_ELECTRODE Z WITH(NOLOCK)                
                                    WHERE 1=1                
                                      AND Z.DIVISION_ID         = SUB.DIVISION_ID                
                                      AND Z.PLAN_START_YYYYMMDD = SUB.PLAN_START_YYYYMMDD                
                                   AND Z.PLAN_TYPE           = SUB.PLAN_TYPE                
                                      AND Z.SEQ                 = SUB.SEQ              
                                      AND Z.PSI_TYPE            = SUB.PSI_TYPE                
                                      AND Z.ITEM_ID             = SUB.ITEM_ID                
                                      AND Z.FROM_SITE           = SUB.FROM_SITE                
                                      AND Z.PSI_VALUE           = SUB.PSI_VALUE                
                                      AND Z.YYYYMMDD            = SUB.YYYYMMDD                
                                 );                
                
           /*                
            * 셀에 대하여 특정기간에 활성화완료계획이 존재하지 않으면, 0으로 특성완료 계획데이타 생성                
            */                                                   
          INSERT INTO  #tmp_SCP_ANL_PSI_ELECTRODE                 
                      ( DIVISION_ID                
                       ,PLAN_START_YYYYMMDD                
                       ,PLAN_TYPE                
                       ,SEQ                
                        ,OPERATION_GROUP                
                       ,FROM_SITE                
                       ,ITEM_ID                
                       ,PSI_TYPE                
                       ,PSI_VALUE                
                       ,YYYYMMDD                
--                       ,ELECTRODE_TYPE                
                       ,QTY                
                       ,TO_SITE                
                       ,PROD_LINE                
                       ,INVENTORY_TYPE                
                       )                                                 
                SELECT  DIVISION_ID                
                       ,PLAN_START_YYYYMMDD                
                       ,PLAN_TYPE                
                       ,SEQ                
                       ,OPERATION_GROUP                
                       ,FROM_SITE                
                       ,ITEM_ID                
                       ,'I'                  AS PSI_TYPE                
                       ,'ACTIVATE_COMPLETED' AS PSI_VALUE                
                       ,YYYYMMDD                
--                       ,ELECTRODE_TYPE                
                       ,0.0   AS QTY                
                       ,''    AS TO_SITE                
                       ,''    AS PROD_LINE                
                       ,'C'    AS INVENTORY_TYPE                
                 FROM                 
                     (                
                         SELECT                 
                                DIVISION_ID,PLAN_START_YYYYMMDD,PLAN_TYPE,SEQ,OPERATION_GROUP,FROM_SITE,ITEM_ID,A.YYYYMMDD--,ELECTRODE_TYPE                
                          FROM                
                               (                
                                  SELECT CONVERT(VARCHAR(8),START_DTTM,112) AS YYYYMMDD             
                                    FROM TH_ENG_BUCKET_INFO_SN WITH(NOLOCK)                  
                                   WHERE PLAN_ID        = @p_engine_plan_id     --'1021::PR::1'                     
                                    AND MASTER_ID       = @p_master_id          --'81::WEEKLY'                          
                               ) A,                
                               (                
                                 SELECT DISTINCT DIVISION_ID,PLAN_START_YYYYMMDD,PLAN_TYPE,SEQ,OPERATION_GROUP,FROM_SITE,ITEM_ID--,ELECTRODE_TYPE                
                                   FROM #tmp_SCP_ANL_PSI_ELECTRODE X WITH(NOLOCK)                
                                  WHERE 1=1                
                                    AND DIVISION_ID         = @p_division_id          --'81'                                     
                                    AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd  --'20180416'                       
                                    AND PLAN_TYPE           = @p_plan_type            --'PR'                                       
                                    AND SEQ                 = @p_seq                  --1                                               
                                    AND OPERATION_GROUP     = 'A'                
                              ) B                
                     ) SUB                
                     WHERE 1=1                
                       AND NOT EXISTS (                
                                        SELECT 'X'                
                                          FROM #tmp_SCP_ANL_PSI_ELECTRODE Z WITH(NOLOCK)                
                                         WHERE 1=1                
                                           AND Z.DIVISION_ID         = SUB.DIVISION_ID                
                                           AND Z.PLAN_START_YYYYMMDD = SUB.PLAN_START_YYYYMMDD                
                                           AND Z.PLAN_TYPE           = SUB.PLAN_TYPE                
                                           AND Z.SEQ                 = SUB.SEQ                
                                           AND Z.PSI_TYPE            = 'I'                
                                           AND Z.ITEM_ID             = SUB.ITEM_ID                
                                           AND Z.FROM_SITE           = SUB.FROM_SITE                
                                           AND Z.PSI_VALUE           = 'ACTIVATE_COMPLETED'                
                                           AND Z.YYYYMMDD            = SUB.YYYYMMDD                
                                      );                
                
           /*                
            * 셀에 대하여 특정기간에 활성화진행중 수량이 이 존재하지 않으면, 0으로 활성화진행중 데이타 생성                
            */                 

          INSERT INTO  #tmp_SCP_ANL_PSI_ELECTRODE                 
                      ( DIVISION_ID                
                       ,PLAN_START_YYYYMMDD                
                       ,PLAN_TYPE                
                       ,SEQ                
                       ,OPERATION_GROUP                
                       ,FROM_SITE                
                       ,ITEM_ID                
                       ,PSI_TYPE                
                       ,PSI_VALUE                
                       ,YYYYMMDD                
--                       ,ELECTRODE_TYPE                
                       ,QTY                
                       ,TO_SITE                
                       ,PROD_LINE                
                       ,INVENTORY_TYPE                
                       )                 
                SELECT  DIVISION_ID                
                       ,PLAN_START_YYYYMMDD                
                       ,PLAN_TYPE                
                       ,SEQ           
                       ,OPERATION_GROUP                
                       ,FROM_SITE                
                       ,ITEM_ID                
                       ,'I'                  AS PSI_TYPE                
                      ,'ACTIVATE_PROGRESS' AS PSI_VALUE                
                       ,YYYYMMDD                
--                       ,ELECTRODE_TYPE                
                       ,0.0   AS QTY                
                       ,''    AS TO_SITE                
                       ,''    AS PROD_LINE                
                       ,'P'    AS INVENTORY_TYPE                
            
                 FROM                 
                     (                
                         SELECT                 
                                DIVISION_ID,PLAN_START_YYYYMMDD,PLAN_TYPE,SEQ,OPERATION_GROUP,FROM_SITE,ITEM_ID,A.YYYYMMDD--,ELECTRODE_TYPE                
                          FROM                
                        (                
                                  SELECT CONVERT(VARCHAR(8),START_DTTM,112) AS YYYYMMDD                  
                                    FROM TH_ENG_BUCKET_INFO_SN WITH(NOLOCK)                  
                                   WHERE PLAN_ID        = @p_engine_plan_id     --'1021::PR::1'                     
                                    AND MASTER_ID       = @p_master_id          --'81::WEEKLY'                          
                               ) A,                
                               (                
                                 SELECT DISTINCT DIVISION_ID,PLAN_START_YYYYMMDD,PLAN_TYPE,SEQ,OPERATION_GROUP,FROM_SITE,ITEM_ID--,ELECTRODE_TYPE                
                                   FROM #tmp_SCP_ANL_PSI_ELECTRODE X WITH(NOLOCK)                
                                  WHERE 1=1                
                                    AND DIVISION_ID         = @p_division_id          --'81'                                     
                                    AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd  --'20180416'                       
                                    AND PLAN_TYPE           = @p_plan_type            --'PR'                                       
                                    AND SEQ                 = @p_seq                  --1                                               
                                    AND OPERATION_GROUP     = 'A'                
                              ) B                
                     ) SUB                
                     WHERE 1=1                
                       AND NOT EXISTS (                
                                        SELECT 'X'                
                                          FROM #tmp_SCP_ANL_PSI_ELECTRODE Z WITH(NOLOCK)                
                                         WHERE 1=1                
                                           AND Z.DIVISION_ID         = SUB.DIVISION_ID                
                                           AND Z.PLAN_START_YYYYMMDD = SUB.PLAN_START_YYYYMMDD                
                                           AND Z.PLAN_TYPE           = SUB.PLAN_TYPE                
                                           AND Z.SEQ                 = SUB.SEQ                
                                           AND Z.PSI_TYPE            = 'I'                
                                           AND Z.ITEM_ID             = SUB.ITEM_ID                
                                           AND Z.FROM_SITE           = SUB.FROM_SITE                
                                           AND Z.PSI_VALUE           = 'ACTIVATE_PROGRESS'                
                                           AND Z.YYYYMMDD            = SUB.YYYYMMDD                
                                      );                              
                                                               
                            
           /*                
            * WEEKLY 구간의 EOH에 대해서 엔진에서 나오지 않은 날짜에 대하여 데이타생성                
            */                                                    
                
           INSERT INTO  #tmp_SCP_ANL_PSI_ELECTRODE       
                      ( DIVISION_ID                
                       ,PLAN_START_YYYYMMDD                
                       ,PLAN_TYPE                
                       ,SEQ                
                       ,OPERATION_GROUP                
                       ,FROM_SITE                
                       ,ITEM_ID                
                       ,PSI_TYPE                
                       ,PSI_VALUE                
                       ,YYYYMMDD                
--                       ,ELECTRODE_TYPE                
                       ,QTY                
                       ,TO_SITE                
                       ,PROD_LINE                
                       ,INVENTORY_TYPE                
                       )                
              SELECT  A.DIVISION_ID                
                       ,A.PLAN_START_YYYYMMDD                
                       ,A.PLAN_TYPE                
                       ,A.SEQ                
                       ,A.OPERATION_GROUP                
                       ,A.FROM_SITE                
                       ,A.ITEM_ID                
                       ,A.PSI_TYPE                
                       ,A.PSI_VALUE                
                       ,B.BASIS_YYYYMMDD AS YYYYMMDD                
--                       ,A.ELECTRODE_TYPE                
                       ,A.QTY                
                       ,''    AS TO_SITE                
                       ,''    AS PROD_LINE                
                       ,'I'   AS INVENTORY_TYPE                
                  FROM                
                                (                
                                 SELECT X.*                
                                   FROM #tmp_SCP_ANL_PSI_ELECTRODE X WITH(NOLOCK)                
                                  WHERE 1=1                
                                    AND X.DIVISION_ID         = @p_master_id            --'81'                                     
                                    AND X.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd  --'20180416'                       
                                    AND X.PLAN_TYPE           = @p_plan_type            --'PR'                                       
                                    AND X.SEQ                 = @p_seq                  --1                                               
                                    AND X.PSI_TYPE            = 'I'                
                                    AND X.INVENTORY_TYPE      = 'I'                
                                    AND X.YYYYMMDD IN ( SELECT CONVERT(VARCHAR,START_DTTM,112)                 
                                                        FROM TH_ENG_BUCKET_INFO_SN WITH(NOLOCK)                  
                                                       WHERE PLAN_ID      = @p_engine_plan_id   --'1022::PR::1'           
                                                         AND MASTER_ID    = @p_master_id        --'81::WEEKLY'                 
                                                         AND BUCKET_TYPE  = 'WEEK' )                
                                  ) A,                
                                  (                
                                   SELECT CONVERT(VARCHAR,B.START_DTTM,112) AS YYYYMMDD,C.BASIS_YYYYMMDD                
                                   FROM TH_ENG_BUCKET_INFO_SN B WITH(NOLOCK),                
      SCM_SYS_CALENDAR_M    C WITH(NOLOCK)                  
                                  WHERE 1=1                
                                    AND B.PLAN_ID         = @p_engine_plan_id    --'1022::PR::1'                  
                                    AND B.MASTER_ID       = @p_master_id         --'81::WEEKLY'                
                                    AND C.BASIS_YYYYMMDD  > CONVERT(VARCHAR,B.START_DTTM,112)                
                                    AND C.BASIS_YYYYMMDD  < CONVERT(VARCHAR,B.END_DTTM,112)                
                                    AND B.BUCKET_TYPE     = 'WEEK'                
                                  ) B                
                WHERE 1=1                
                 AND A.YYYYMMDD = B.YYYYMMDD                
                                 ;                
                                                           
           -------------------------------------------------------------------------------------------------------------                     
           -- 4. 로직 보정  ACTIVATE_PROGRESS,MODEL_INVENTORY WEEK 값이 없는 경우 일별 값을 0으로 추가           
           -------------------------------------------------------------------------------------------------------------        
            
                  --ALTER TABLE #tmp_SCP_ANL_PSI_ELECTRODE            
                  --ADD PARTIAL_WEEK_NAME nvarchar(10),PARTIAL_YN nvarchar(1),BASIS_START_DATE nvarchar(8),BASIS_END_DATE nvarchar(8)            
                               
                 INSERT INTO  #tmp_SCP_ANL_PSI_ELECTRODE                 
                      ( DIVISION_ID                
                       ,PLAN_START_YYYYMMDD                
                       ,PLAN_TYPE                
                       ,SEQ                
                       ,OPERATION_GROUP                
                       ,FROM_SITE                
                       ,ITEM_ID                
                       ,PSI_TYPE                
                       ,PSI_VALUE                
                       ,YYYYMMDD                
--                       ,ELECTRODE_TYPE                
                       ,QTY                
                       ,TO_SITE                
                       ,PROD_LINE                
                       ,INVENTORY_TYPE                
            
                       )                 
                SELECT  DIVISION_ID                
                       ,PLAN_START_YYYYMMDD                
                       ,PLAN_TYPE                
                       ,SEQ                
                       ,OPERATION_GROUP                
                       ,FROM_SITE                
                       ,ITEM_ID                
                       ,'I'                  AS PSI_TYPE                
                       ,'ACTIVATE_PROGRESS' AS PSI_VALUE                
                       ,YYYYMMDD                
--                       ,ELECTRODE_TYPE                
                       ,0.0   AS QTY                
                       ,''    AS TO_SITE                
                       ,''    AS PROD_LINE                
                       ,'P'    AS INVENTORY_TYPE                
                 FROM                 
                     (                
                         SELECT                 
                                DIVISION_ID,PLAN_START_YYYYMMDD,PLAN_TYPE,SEQ,OPERATION_GROUP,FROM_SITE,ITEM_ID,A.YYYYMMDD--,A.PARTIAL_WEEK_NAME, A.PARTIAL_YN,A.BASIS_START_DATE, A.BASIS_END_DATE            
                          FROM                
                               (                
                                 SELECT C.BASIS_YYYYMMDD AS YYYYMMDD --,C.PARTIAL_WEEK_NAME, C.PARTIAL_YN,C.BASIS_START_DATE, C.BASIS_END_DATE            
                                   FROM SCM_SYS_CALENDAR_M    C WITH(NOLOCK)                   
                                  WHERE 1=1                
                                    AND C.BASIS_YYYYMMDD >= @p_plan_start_yyyymmdd   
									
									-- * 2021-05-10   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 플랜 대응 - start
                                    --AND C.BASIS_YYYYMMDD <  CONVERT(VARCHAR,DATEADD(D,364,CONVERT(DATETIME,@p_plan_start_yyyymmdd,112)),112)      
									--
									AND C.BASIS_YYYYMMDD <  @v_pet_date  
									-- * 2021-05-10   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 플랜 대응 - end
            
                               ) A,                
                               (                
                                 SELECT DISTINCT DIVISION_ID,PLAN_START_YYYYMMDD,PLAN_TYPE,SEQ,OPERATION_GROUP,FROM_SITE,ITEM_ID--,ELECTRODE_TYPE                
                                   FROM #tmp_SCP_ANL_PSI_ELECTRODE X WITH(NOLOCK)                
                                  WHERE 1=1                
                                    AND DIVISION_ID         = @p_division_id          --'81'                                     
                                    AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd  --'20180416'                       
                                    AND PLAN_TYPE           = @p_plan_type            --'PR'                                       
                                    AND SEQ                 = @p_seq                  --1                                               
                                    AND OPERATION_GROUP     = 'A'                
--                         AND PSI_VALUE           = 'ACTIVATE_PROGRESS'            
                              ) B                
                     ) SUB                
                     WHERE 1=1                
                       AND NOT EXISTS (                
                                   SELECT 'X'                
                                          FROM #tmp_SCP_ANL_PSI_ELECTRODE Z WITH(NOLOCK)                
                                         WHERE 1=1                
                                           AND Z.DIVISION_ID         = SUB.DIVISION_ID                
                                           AND Z.PLAN_START_YYYYMMDD = SUB.PLAN_START_YYYYMMDD                
                                           AND Z.PLAN_TYPE           = SUB.PLAN_TYPE                
                                           AND Z.SEQ                 = SUB.SEQ                
                                           AND Z.PSI_TYPE            = 'I'                
                                           AND Z.ITEM_ID             = SUB.ITEM_ID                
                                           AND Z.FROM_SITE           = SUB.FROM_SITE                
                                           AND Z.PSI_VALUE           = 'ACTIVATE_PROGRESS'                
                                           AND Z.YYYYMMDD            = SUB.YYYYMMDD                
                                      );                
                                                               
               INSERT INTO  #tmp_SCP_ANL_PSI_ELECTRODE                 
                      ( DIVISION_ID                
                       ,PLAN_START_YYYYMMDD                
                       ,PLAN_TYPE                
                       ,SEQ                
                       ,OPERATION_GROUP                
                       ,FROM_SITE                
                       ,ITEM_ID                
                       ,PSI_TYPE                
                       ,PSI_VALUE                
                       ,YYYYMMDD                
--                       ,ELECTRODE_TYPE                
                       ,QTY                
                       ,TO_SITE                
                       ,PROD_LINE                
                       ,INVENTORY_TYPE                
                                   
                      )                 
                SELECT  DIVISION_ID                
                       ,PLAN_START_YYYYMMDD                
                      ,PLAN_TYPE                
                       ,SEQ                
                       ,OPERATION_GROUP                
                       ,FROM_SITE                
                       ,ITEM_ID                
                       ,'I'                  AS PSI_TYPE                
                       ,'MODEL_INVENTORY' AS PSI_VALUE                
                       ,YYYYMMDD                
--                       ,ELECTRODE_TYPE                
                       ,0.0   AS QTY                
                       ,''    AS TO_SITE                
                       ,''    AS PROD_LINE                
                       ,'I'    AS INVENTORY_TYPE                
            
                 FROM                 
                     (                
                         SELECT                 
                                DIVISION_ID,PLAN_START_YYYYMMDD,PLAN_TYPE,SEQ,OPERATION_GROUP,FROM_SITE,ITEM_ID,A.YYYYMMDD--,A.PARTIAL_WEEK_NAME, A.PARTIAL_YN,A.BASIS_START_DATE, A.BASIS_END_DATE            
                          FROM                
                               (                
                                 SELECT C.BASIS_YYYYMMDD AS YYYYMMDD --,C.PARTIAL_WEEK_NAME, C.PARTIAL_YN,C.BASIS_START_DATE, C.BASIS_END_DATE            
                                   FROM SCM_SYS_CALENDAR_M    C WITH(NOLOCK)         
                                  WHERE 1=1                
                                    AND C.BASIS_YYYYMMDD >= @p_plan_start_yyyymmdd        
									
									-- * 2021-05-10   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 플랜 대응 - start
                                    --AND C.BASIS_YYYYMMDD <  CONVERT(VARCHAR,DATEADD(D,364,CONVERT(DATETIME,@p_plan_start_yyyymmdd,112)),112)  
									--
									AND C.BASIS_YYYYMMDD <  @v_pet_date 
									-- * 2021-05-10   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 플랜 대응 - end
            
                               ) A,                
                               (                
                                 SELECT DISTINCT DIVISION_ID,PLAN_START_YYYYMMDD,PLAN_TYPE,SEQ,OPERATION_GROUP,FROM_SITE,ITEM_ID--,ELECTRODE_TYPE                
                                   FROM #tmp_SCP_ANL_PSI_ELECTRODE X WITH(NOLOCK)                
                                  WHERE 1=1                
                                    AND DIVISION_ID         = @p_division_id          --'81'                                     
                                    AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd  --'20180416'                       
                                    AND PLAN_TYPE           = @p_plan_type            --'PR'                                       
                                    AND SEQ                 = @p_seq                  --1                                               
                                    --AND OPERATION_GROUP     = 'A'                
--                                    AND PSI_VALUE           = 'MODEL_INVENTORY'            
                              ) B                
                     ) SUB                
                     WHERE 1=1                
                       AND NOT EXISTS (                
                                        SELECT 'X'                
                                          FROM #tmp_SCP_ANL_PSI_ELECTRODE Z WITH(NOLOCK)                
                                         WHERE 1=1                
                                           AND Z.DIVISION_ID         = SUB.DIVISION_ID                
                                           AND Z.PLAN_START_YYYYMMDD = SUB.PLAN_START_YYYYMMDD                
                                           AND Z.PLAN_TYPE           = SUB.PLAN_TYPE                
                                           AND Z.SEQ                 = SUB.SEQ                
                                           AND Z.PSI_TYPE            = 'I'                
                                           AND Z.ITEM_ID             = SUB.ITEM_ID                
                                           AND Z.FROM_SITE           = SUB.FROM_SITE                
                                           AND Z.PSI_VALUE           = 'MODEL_INVENTORY'                
                                           AND Z.YYYYMMDD            = SUB.YYYYMMDD                
                                      );                
                                                             
          
           -- 전체 내역에서 일별 bucket에서 NULL을 0으로 채우기          
          
           INSERT INTO  #tmp_SCP_ANL_PSI_ELECTRODE                 
                      ( DIVISION_ID                
                       ,PLAN_START_YYYYMMDD                
                       ,PLAN_TYPE                
                       ,SEQ                
                       ,OPERATION_GROUP                
                       ,FROM_SITE                
                       ,ITEM_ID                
                       ,PSI_TYPE                
                       ,PSI_VALUE                
                       ,YYYYMMDD                
--                       ,ELECTRODE_TYPE                
                       ,QTY                
                       ,TO_SITE                
                       ,PROD_LINE                
                       ,INVENTORY_TYPE                
            
                       )          
                
                SELECT  DISTINCT            
                        DIVISION_ID                
                       ,PLAN_START_YYYYMMDD                
                       ,PLAN_TYPE                
                       ,SEQ                
                       ,OPERATION_GROUP                
                       ,FROM_SITE                
                       ,ITEM_ID                
                       ,PSI_TYPE                
                       ,PSI_VALUE                
                       ,YYYYMMDD                
--                       ,ELECTRODE_TYPE                
                       ,0.0   AS QTY                
                       ,NULL AS TO_SITE                
                       ,NULL AS PROD_LINE                
                       ,NULL AS INVENTORY_TYPE                
                 FROM                 
                     (                
                         SELECT                 
                                DIVISION_ID,PLAN_START_YYYYMMDD,PLAN_TYPE,SEQ,OPERATION_GROUP,FROM_SITE,ITEM_ID,A.YYYYMMDD--,A.PARTIAL_WEEK_NAME, A.PARTIAL_YN,A.BASIS_START_DATE, A.BASIS_END_DATE            
                                 ,PSI_TYPE,PSI_VALUE,TO_SITE,PROD_LINE,INVENTORY_TYPE          
                          FROM                
                      (                
                                 SELECT C.BASIS_YYYYMMDD AS YYYYMMDD --,C.PARTIAL_WEEK_NAME, C.PARTIAL_YN,C.BASIS_START_DATE, C.BASIS_END_DATE            
                                   FROM SCM_SYS_CALENDAR_M    C WITH(NOLOCK)                   
                                  WHERE 1=1                
                                    AND C.BASIS_YYYYMMDD >= @p_plan_start_yyyymmdd        
									
									-- * 2021-05-10   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 플랜 대응 - start
                                    --AND C.BASIS_YYYYMMDD <  CONVERT(VARCHAR,DATEADD(D,364,CONVERT(DATETIME,@p_plan_start_yyyymmdd,112)),112)   
									--
									AND C.BASIS_YYYYMMDD <  @v_pet_date
									-- * 2021-05-10   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 플랜 대응 - end

                                    --AND C.BASIS_YYYYMMDD >= (          
                                    --       SELECT MIN(START_DTTM)           
                                    --      FROM TH_ENG_BUCKET_INFO_SN           
                                    --      WHERE PLAN_ID   = @p_engine_plan_id   -- 2018-08-20 00:00:00.000           
                                    --      AND BUCKET_TYPE = 'DAY'          
                                    --      )            
            
                               ) A,                
                               (                
                                 SELECT DISTINCT DIVISION_ID,PLAN_START_YYYYMMDD,PLAN_TYPE,SEQ,OPERATION_GROUP,FROM_SITE,ITEM_ID--,ELECTRODE_TYPE                
                                        ,PSI_TYPE,PSI_VALUE,TO_SITE,PROD_LINE,INVENTORY_TYPE          
                                   FROM #tmp_SCP_ANL_PSI_ELECTRODE X WITH(NOLOCK)                
                                  WHERE 1=1                
                                    AND DIVISION_ID         = @p_division_id          --'81'                                     
                                    AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd  --'20180416'                       
                                    AND PLAN_TYPE           = @p_plan_type            --'PR'                                       
                                    AND SEQ                 = @p_seq                  --1                                               
--                                    AND OPERATION_GROUP     = 'A'                
--                                    AND PSI_VALUE           = 'ACTIVATE_PROGRESS'            
                              ) B                
                     ) SUB                
                     WHERE 1=1                
                       AND NOT EXISTS (                
                                        SELECT 'X'                
                                          FROM #tmp_SCP_ANL_PSI_ELECTRODE Z WITH(NOLOCK)                
                                         WHERE 1=1                
                                           AND Z.DIVISION_ID         = SUB.DIVISION_ID                
                                           AND Z.PLAN_START_YYYYMMDD = SUB.PLAN_START_YYYYMMDD                
                                           AND Z.PLAN_TYPE           = SUB.PLAN_TYPE                
                                           AND Z.SEQ                 = SUB.SEQ                
                                           AND Z.PSI_TYPE            = SUB.PSI_TYPE                
                                           AND Z.ITEM_ID             = SUB.ITEM_ID          
                                           AND Z.FROM_SITE           = SUB.FROM_SITE                
                                           AND Z.PSI_VALUE           = SUB.PSI_VALUE                
                                           AND Z.YYYYMMDD            = SUB.YYYYMMDD                
                                           --AND Z.TO_SITE             = SUB.TO_SITE          
                                           --AND Z.PROD_LINE           = SUB.PROD_LINE          
                                           --AND Z.INVENTORY_TYPE      = SUB.INVENTORY_TYPE          
                                      )            
                                          
                                               
           -------------------------------------------------------------------------------------------------------------                     
           --5. Model inventory Balance  보정        
           --    1)팩,전극        : 전일 EOH – 출하sum + 생산sum        
           --    2)일반 CELL      : 전일 EOH – 출하sum + Activate Completed   (일반 CELL)  
           --      소형후공정 CELL: 전일 EOH – 출하sum + PSI_TYPE ='P'   (소형후공정 CELL)    
           --                                            OPERATION_GROUP ='A' AND SUBSTRING(ITEM_ID,1,2) IN ('MI','MD','MT')   
           --    대상구간: 전구간 일자별로 생성         
           -------------------------------------------------------------------------------------------------------------                    
               -- BOH 임시 테이블 생선        
               SELECT  SITE_ID  ,ITEM_ID, SUM(ISNULL(PSI_BOH_QTY,0)) AS BOH        
                INTO #BOH        
                FROM SCP_PLN_PLANT_ONHAND WITH(NOLOCK)                      
               WHERE DIVISION_ID               = @P_DIVISION_ID          
                 AND STOCK_TYPE           NOT IN ( 'ASSM','FOR_STOCKPLAN','FORMING','FORMED','CHARING','A_MOVE_WH')   --셀 특성완료이전 제외           
                 AND PLAN_START_YYYYMMDD       = @P_PLAN_START_YYYYMMDD           
                 AND PLAN_TYPE                 = @P_PLAN_TYPE           
                 AND SEQ                       = @P_SEQ          
                 --AND SITE_ID                   = @P_SCM_SITE_ID            
                 --AND ITEM_ID                   = @P_ITEM_ID            
                 AND YYYYMMDD                  = @P_PLAN_START_YYYYMMDD        
               GROUP BY SITE_ID  ,ITEM_ID        
        
              -- 임시테이블 BOH 반영         
              UPDATE X          
                 SET X.BOH = Y.BOH        
                FROM #tmp_SCP_ANL_PSI_ELECTRODE X with (nolock)          
                JOIN #BOH Y with (nolock)        
                  ON 0 = 0           
                 AND X.FROM_SITE        = Y.SITE_ID          
                 AND X.ITEM_ID          = Y.ITEM_ID          

             -- MODEL_INVENTORY UPDATE    
             UPDATE XX        
                SET XX.QTY   = (CASE  WHEN YY.OPERATION_GROUP  = 'A' THEN ((CASE WHEN (YY.DIVISION_ID = '40' AND XX.ATTRIBUTE7 ='Y'  ) THEN  AC_SUM_TCOCELL ELSE  AC_SUM END)  - S_SUM)         
                                      WHEN YY.OPERATION_GROUP <> 'A' THEN ( P_SUM - S_SUM)         
                                      ELSE 0 END)        
                FROM #tmp_SCP_ANL_PSI_ELECTRODE XX with (nolock)        
                INNER JOIN  (        
                                SELECT DISTINCT DIVISION_ID,PLAN_START_YYYYMMDD,PLAN_TYPE,SEQ        
                                  , OPERATION_GROUP,FROM_SITE,ITEM_ID,'MODEL_INVENTORY' AS PSI_VALUE,YYYYMMDD        
                               , SUM((CASE  WHEN PSI_TYPE ='S' 
                                            THEN ISNULL(QTY,0) ELSE 0 END)) OVER(PARTITION BY FROM_SITE,ITEM_ID ORDER BY FROM_SITE,ITEM_ID,YYYYMMDD)  AS S_SUM         
                               , SUM((CASE  WHEN PSI_TYPE ='P' AND OPERATION_GROUP <> 'A' 
                                            THEN ISNULL(QTY,0) ELSE 0 END)) OVER(PARTITION BY FROM_SITE,ITEM_ID ORDER BY FROM_SITE,ITEM_ID,YYYYMMDD) + ISNULL(BOH,0) AS P_SUM        
                               , SUM((CASE  WHEN PSI_TYPE ='I' AND OPERATION_GROUP  = 'A' AND  PSI_VALUE ='ACTIVATE_COMPLETED'             
                                            THEN ISNULL(QTY,0) ELSE 0 END)) OVER(PARTITION BY FROM_SITE,ITEM_ID ORDER BY FROM_SITE,ITEM_ID,YYYYMMDD) + ISNULL(BOH,0) AS AC_SUM      
                               --, SUM((CASE  WHEN PSI_TYPE ='P' AND OPERATION_GROUP  = 'A' AND  SUBSTRING(ITEM_ID,1,2) IN ('MI','MD','MT')  
                               --             THEN ISNULL(QTY,0) ELSE 0 END)) OVER(PARTITION BY FROM_SITE,ITEM_ID ORDER BY FROM_SITE,ITEM_ID,YYYYMMDD) + ISNULL(BOH,0) AS AC_SUM_TCOCELL
                               , SUM((CASE  WHEN PSI_TYPE ='P' AND OPERATION_GROUP  = 'A' AND  X.ATTRIBUTE7 ='Y'                           
                                            THEN ISNULL(QTY,0) ELSE 0 END)) OVER(PARTITION BY FROM_SITE,ITEM_ID ORDER BY FROM_SITE,ITEM_ID,YYYYMMDD) + ISNULL(BOH,0) AS AC_SUM_TCOCELL
                               FROM #tmp_SCP_ANL_PSI_ELECTRODE X with (nolock)         
                               WHERE 0 = 0               
                           ) YY        
                       ON  XX.DIVISION_ID              = YY.DIVISION_ID                
                       AND XX.PLAN_START_YYYYMMDD      = YY.PLAN_START_YYYYMMDD        
                       AND XX.PLAN_TYPE                = YY.PLAN_TYPE                  
                       AND XX.SEQ                      = YY.SEQ                        
                       AND XX.OPERATION_GROUP          = YY.OPERATION_GROUP            
                       AND XX.FROM_SITE                = YY.FROM_SITE                    
          AND XX.ITEM_ID                  = YY.ITEM_ID                    
                       AND XX.YYYYMMDD                 = YY.YYYYMMDD        
                       AND XX.PSI_VALUE                = YY.PSI_VALUE        

          -------------------------------------------------------------------------------------------------------------                     
          -- 7. DIO 생성                     
          -------------------------------------------------------------------------------------------------------------          
          -------------------------------------------------------------------------------------------------------------                 
          -- 7.1. DIO 임시 테이블 생성          
          -------------------------------------------------------------------------------------------------------------                 
          IF OBJECT_ID('tempdb..#tmp_SCP_ANL_PSI_PRODUCTION_DIO') IS NOT NULL                
              DROP TABLE #tmp_SCP_ANL_PSI_PRODUCTION_DIO                
                
            CREATE TABLE #tmp_SCP_ANL_PSI_PRODUCTION_DIO                
            (           
              DIVISION_ID  NVARCHAR(10) NOT NULL,             
              FROM_SITE    NVARCHAR(50) NOT NULL,          
              ITEM_ID      NVARCHAR(50) NOT NULL,          
              YYYYMMDD     NVARCHAR(8)  NOT NULL,          
              OUT_QTY      NUMERIC(30,10),          
              EOH_QTY      NUMERIC(30,10),          
              INV_DAY      NUMERIC(30,10)                 
            );                
                
          
            INSERT INTO #tmp_SCP_ANL_PSI_PRODUCTION_DIO          
            (   DIVISION_ID           
               ,FROM_SITE             
               ,ITEM_ID               
               ,YYYYMMDD              
               ,OUT_QTY               
               ,EOH_QTY               
               ,INV_DAY               
             )          
            SELECT DIVISION_ID          
                   ,FROM_SITE          
                   ,ITEM_ID          
                   ,YYYYMMDD          
                   ,SUM((CASE PSI_TYPE WHEN 'S' THEN ROUND(P.QTY,1) ELSE 0 END )) AS OUT_QTY          
                   ,SUM((CASE PSI_VALUE WHEN 'MODEL_INVENTORY' THEN ROUND(P.QTY,1) ELSE 0 END)) AS EOH_QTY          
                   , 0          
              FROM #tmp_SCP_ANL_PSI_ELECTRODE P WITH(NOLOCK)          
             WHERE 1=1          
               --AND P.DIVISION_ID         = @P_DIVISION_ID         --'81'          
               --AND P.PLAN_START_YYYYMMDD = @P_PLAN_START_YYYYMMDD --'20180507'          
               --AND P.PLAN_TYPE           = @P_PLAN_TYPE           --'MA'          
               --AND P.SEQ                 = @P_SEQ                 --4          
               -- AND P.ITEM_ID             ='ACEN1059I-A1'          
               -- AND P.FROM_SITE           ='A040-A'          
            GROUP BY  DIVISION_ID, FROM_SITE,ITEM_ID,YYYYMMDD          
            ORDER BY  DIVISION_ID, FROM_SITE,ITEM_ID,YYYYMMDD;             
                    
         -------------------------------------------------------------------------------------------------------------           
         -- 7.2. DIO 누적합계와 전일누적합계를  생성         #Tbl_DIO                                                                                                 
         -------------------------------------------------------------------------------------------------------------           
         SELECT  YYYYMMDD          
                ,FROM_SITE          
                ,ITEM_ID          
                ,OUT_QTY          
                ,OUT_QTY_SUM          
                ,LAG((CASE WHEN OUT_QTY_SUM < 0 THEN 0 ELSE OUT_QTY_SUM END),1,0) OVER (PARTITION BY FROM_SITE,ITEM_ID ORDER BY YYYYMMDD) LAG_OUT_QTY_SUM  -- 전일 누적합계          
                ,EOH_QTY   
          INTO #Tbl_DIO          
          FROM (          
                         
                SELECT FROM_SITE          
                      ,ITEM_ID          
                      ,YYYYMMDD          
                      ,SUM((CASE WHEN OUT_QTY < 0 THEN 0 ELSE OUT_QTY END)) AS OUT_QTY          
                      ,SUM((CASE WHEN EOH_QTY < 0 THEN 0 ELSE EOH_QTY END)) AS EOH_QTY          
                      ,ROUND(SUM((CASE WHEN OUT_QTY < 0 THEN 0 ELSE OUT_QTY END)) OVER(PARTITION BY FROM_SITE,ITEM_ID ORDER BY FROM_SITE,ITEM_ID,YYYYMMDD),2) AS OUT_QTY_SUM  -- 누적합계          
                FROM (          
                        -- FROM_SITE,ITEM_ID,YYYYMMDD 기준으로 중복이 존재 ?          
                        SELECT FROM_SITE          
                              ,ITEM_ID          
                              ,YYYYMMDD          
                              ,SUM(OUT_QTY) AS OUT_QTY           
                              ,SUM(EOH_QTY) AS EOH_QTY          
                         from #tmp_SCP_ANL_PSI_PRODUCTION_DIO P WITH(NOLOCK)          
                         WHERE 1=1          
                           --AND P.FROM_SITE           = 'A040-A'          
                           --AND P.ITEM_ID             = 'ACEN1059I-A1'          
                           --AND P.PSI_TYPE            = 'S'          
                           --AND P.YYYYMMDD            >  '20180514'          
                         GROUP BY FROM_SITE,ITEM_ID,YYYYMMDD          
                      ) SUB          
                  GROUP BY FROM_SITE          
                          ,ITEM_ID          
                          ,YYYYMMDD          
                          ,SUB.OUT_QTY          
                          ,SUB.EOH_QTY                  
                ) AA          
          
         -------------------------------------------------------------------------------------------------------------           
         -- 7.3.구하고자 하는 재고일수의 일자를 기준으로 이후 일자의 OUT값의 누적값중 현재 재고값보다 최초로 큰값을 구함.          
         --                                   A. (OUT_QTY_SUM + EOH_QTY) 값과 X.OUT_QTY_SUM 비교          
         -------------------------------------------------------------------------------------------------------------          
          
          SELECT @p_division_id AS DIVISION_ID          
                ,YYYYMMDD            
                ,FROM_SITE           
                ,ITEM_ID           
                ,OUT_QTY          
                ,EOH_QTY          
                ,OUT_QTY_SUM          
--                        ,(A.OUT_QTY_SUM  + A.EOH_QTY )            
                , (SELECT TOP 1 YYYYMMDD           
                    FROM #Tbl_DIO X WITH (NOLOCK)          
                    WHERE X.FROM_SITE = A.FROM_SITE           
                      AND X.ITEM_ID   = A.ITEM_ID            
                      AND X.YYYYMMDD  > A.YYYYMMDD           
                      AND (A.OUT_QTY_SUM  + A.EOH_QTY ) <= X.OUT_QTY_SUM           
                    ) AS INV_YYYYMMDD          
          
                 ,(CASE WHEN EOH_QTY = 0.0 THEN 0.0           
                       ELSE           
                            ISNULL((DATEDIFF(DD,CONVERT(DATETIME,A.YYYYMMDD ,112),CONVERT(DATETIME,((SELECT TOP 1 YYYYMMDD           
                                                                                                     FROM #Tbl_DIO X  WITH (NOLOCK)          
                                                                                                     WHERE X.FROM_SITE = A.FROM_SITE           
                                                                                                       AND X.ITEM_ID   = A.ITEM_ID            
                                                                                                       AND X.YYYYMMDD  > A.YYYYMMDD           
                                                  AND (A.OUT_QTY_SUM  + A.EOH_QTY ) <= X.OUT_QTY_SUM           
                                                                                                     )),112))),999)          
                       END)                                                                   
                                                                                      AS DD          
            INTO #Tbl_SCP_ANL_PSI_PRODUCTION_DIO          
            FROM #Tbl_DIO A WITH (NOLOCK)                            
                
                    
         -------------------------------------------------------------------------------------------------------------           
         -- 7.4. #tmp_SCP_ANL_PSI_PRODUCTION 입력          
         -- 'I'   AS PSI_TYPE                             
         -- 'DIO' AS PSI_VALUE                                           
         -- ROUND(DD-1) + (OUT_QTY/TOT_QTY),2)          
         -- SET @V_INV_DAY = ROUND( (@V_DAY-1) + (@C_EOH_QTY / @V_QTY) , 2)  -- QTY             
         -------------------------------------------------------------------------------------------------------------                   
          
         INSERT INTO  #tmp_SCP_ANL_PSI_ELECTRODE                 
                      ( DIVISION_ID                
                       ,PLAN_START_YYYYMMDD                
                       ,PLAN_TYPE                
                       ,SEQ                
                       ,OPERATION_GROUP                
                       ,FROM_SITE                
                       ,ITEM_ID                
                       ,PSI_TYPE                
                       ,PSI_VALUE                
                       ,YYYYMMDD                
--                       ,ELECTRODE_TYPE                
                       ,QTY                
                       ,TO_SITE                
                       ,PROD_LINE                
                       ,INVENTORY_TYPE      
                       ,ORIGIN_FROM_DIVISION_ID             
                       ,ORIGIN_TO_DIVISION_ID           
                       ,ELECTRODE_TYPE              
                       )          
               
             SELECT @P_DIVISION_ID                          
                   ,@P_PLAN_START_YYYYMMDD                  
                   ,@P_PLAN_TYPE                            
                   ,@P_SEQ                                  
                   ,Y.OPERATION_GROUP                      
                   ,X.FROM_SITE                
                   ,X.ITEM_ID                              
                   ,'I'   AS PSI_TYPE                             
                   ,'DIO' AS PSI_VALUE                            
                   ,X.YYYYMMDD                             
--                   , X.DD AS INV_DAY          
                   , (CASE WHEN X.DD = 0 THEN 0 ELSE X.DD END) AS QTY          
                   ,''  AS TO_SITE                
                   ,''  AS PROD_LINE               
                   ,''  AS INVENTORY_TYPE       
                   ,''  AS ORIGIN_FROM_DIVISION_ID             
                   ,''  AS ORIGIN_TO_DIVISION_ID                  
                   ,Y.ELECTRODE_TYPE     
              FROM #Tbl_SCP_ANL_PSI_PRODUCTION_DIO X WITH(NOLOCK)                
              INNER JOIN SCP_MST_FINAL_ITEM_V Y WITH (NOLOCK)                
                      ON 0 = 0            
                     AND X.ITEM_ID      = Y.ITEM_ID           
             WHERE 1 = 1                
             ;          
                
          -------------------------------------------------------------------------------------------------------------                     
          -- 8. 전체 DIVISION_ID, FROM_SITE,ITEM_ID별 QTY가 0 인 데이터  삭제                     
          --------------------------------------------------------------------------------------------------------------        
                          
          DELETE X      
          --SELECT *      
           FROM #tmp_SCP_ANL_PSI_ELECTRODE X WITH (NOLOCK)      
           JOIN (      
                SELECT DISTINCT DIVISION_ID      
                      , FROM_SITE      
                      , ITEM_ID      
                      , SUM(ISNULL(QTY,0)) OVER(PARTITION BY DIVISION_ID, FROM_SITE,ITEM_ID ORDER BY DIVISION_ID, FROM_SITE,ITEM_ID) AS flag      
                  FROM #tmp_SCP_ANL_PSI_ELECTRODE A WITH (NOLOCK)      
                 WHERE 0 = 0      
                 GROUP BY DIVISION_ID      
                        , FROM_SITE      
                        , ITEM_ID      
                        , QTY      
                ) Y      
          ON 0 = 0      
          AND X.DIVISION_ID = Y.DIVISION_ID      
          AND X.ITEM_ID     = Y.ITEM_ID      
          AND X.FROM_SITE   = Y.FROM_SITE      
          AND Y.flag = 0      
               
          -------------------------------------------------------------------------------------------------------------                     
          -- 9. ORIGIN_FROM_DIVISION_ID,ORIGIN_TO_DIVISION_ID 반영    
          --------------------------------------------------------------------------------------------------------------     
          UPDATE X    
               SET X.ORIGIN_FROM_DIVISION_ID = Y.DIVISION_ID    
              FROM #tmp_SCP_ANL_PSI_ELECTRODE X WITH (NOLOCK)   
				  -- PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 대응
				  INNER JOIN SCM_MST_DIVISION  DM WITH(NOLOCK) 
						  ON DM.DIVISION_ID = X.DIVISION_ID
						 AND DM.VALID_YN	= 'Y'
              LEFT OUTER JOIN DBO.SCM_MST_SITE Y  WITH (NOLOCK)       -- from   PLANT_SITE_ID    
                           ON 0 = 0    
--                          AND Y.SITE_TYPE   = 'PLANT'        
                          -- 2023.03.29 AND (CASE WHEN X.DIVISION_ID IN  ('EE', 'EE_UC') THEN '0' ELSE X.DIVISION_ID END ) = (CASE WHEN X.DIVISION_ID IN  ('EE', 'EE_UC') THEN '0' ELSE Y.DIVISION_ID END )    -- 2022.03.23	KSW	GM JV 반영 :: EE_UC  추가, 0 --> '0'
						  AND Y.DIVISION_ID = CASE WHEN DM.ATTRIBUTE3 = 'EE'  -- PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 대응
												   THEN Y.DIVISION_ID
												   ELSE X.DIVISION_ID
											  END 
                          AND Y.SCM_SITE_ID  = REPLACE(X.FROM_SITE,'-S','')    
                          AND Y.VALID_YN ='Y'       
    
            UPDATE X    
               SET X.ORIGIN_TO_DIVISION_ID = Y.DIVISION_ID    
              FROM #tmp_SCP_ANL_PSI_ELECTRODE X WITH (NOLOCK)    
				  -- PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 대응
				  INNER JOIN SCM_MST_DIVISION  DM WITH(NOLOCK) 
						  ON DM.DIVISION_ID = X.DIVISION_ID
						 AND DM.VALID_YN	= 'Y'
              --LEFT OUTER JOIN DBO.SCM_MST_SITE Y  WITH (NOLOCK)       -- to   SALES_SITE_ID    
                   LEFT OUTER JOIN (SELECT MIN(DIVISION_ID) DIVISION_ID, SCM_SITE_ID, VALID_YN
				                    FROM   DBO.SCM_MST_SITE  WITH (NOLOCK)       -- to   SITE_ID
									WHERE  valid_yn = 'Y'
									GROUP BY SCM_SITE_ID, VALID_YN
								   ) Y  
                           ON 0 = 0    
--                          AND Y.SITE_TYPE   = 'PLANT'        
                          -- 2023.03.29 AND (CASE WHEN X.DIVISION_ID IN  ('EE', 'EE_UC') THEN '0' ELSE X.DIVISION_ID END ) = (CASE WHEN X.DIVISION_ID IN  ('EE', 'EE_UC') THEN '0' ELSE Y.DIVISION_ID END )		-- 2022.03.23	KSW	GM JV 반영 :: EE_UC  추가, 0 --> '0'   
						  AND Y.DIVISION_ID = CASE WHEN DM.ATTRIBUTE3 = 'EE'  -- PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 대응
												   THEN Y.DIVISION_ID
												   ELSE X.DIVISION_ID
											  END 
                          AND Y.SCM_SITE_ID  = REPLACE(X.TO_SITE_ORG,'-S','')    
                          AND Y.VALID_YN ='Y'              
  
            UPDATE X  
               SET X.ORIGIN_TO_DIVISION_ID = X.DIVISION_ID  
              FROM #tmp_SCP_ANL_PSI_ELECTRODE X WITH (NOLOCK) 
				   -- PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 대응
				   INNER JOIN SCM_MST_DIVISION DM WITH(NOLOCK) 
						   ON DM.DIVISION_ID = X.DIVISION_ID
						  AND DM.ATTRIBUTE3 != 'EE'
						  AND DM.VALID_YN	 = 'Y'
            WHERE 0 = 0  
            AND X.PSI_TYPE = 'S'   
            -- 2023.03.29 AND X.DIVISION_ID NOT IN ('EE', 'EE_UC')		-- 2022.03.23	KSW	GM JV 반영 :: EE_UC  추가 <-- X.DIVISION_ID <> 'EE'

           

          -------------------------------------------------------------------------------------------------------------                 
          -- 10. SHIP_REQ_CELL_QTY,SHIP_PLAN_CELL_QTY,SHIP_PLAN_AMEND_CELL_QTY  추가 (전극,셀)    
          -------------------------------------------------------------------------------------------------------------    
         -- DIO는 환산비율을 적용하지 않음.

           UPDATE X
              SET X.CELL_QTY    = (CASE WHEN X.PSI_VALUE ='DIO' THEN ISNULL(X.QTY,0.00)  ELSE ISNULL(X.QTY,0.00) * ISNULL(Y.CONVERT_QTY_CELL,1) END),   -- CELL 환산수량       
                  X.ATTRIBUTE1  = ISNULL(Y.CONVERT_QTY_CELL,1)
              FROM #tmp_SCP_ANL_PSI_ELECTRODE X WITH (NOLOCK)
              INNER JOIN  SCP_MST_FINAL_ITEM Y WITH (NOLOCK)   
              ON 0 = 0
              AND Y.ITEM_ID                 = X.ITEM_ID 
              AND X.ORIGIN_FROM_DIVISION_ID = Y.DIVISION_ID


          -------------------------------------------------------------------------------------------------------------                     
          -- 11. SCP_ANL_PSI_PRODUCTION 삭제                     
          --------------------------------------------------------------------------------------------------------------                      
            DELETE FROM SCP_ANL_PSI_ELECTRODE                      
            WHERE DIVISION_ID = @p_division_id AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd AND PLAN_TYPE = @p_plan_type AND SEQ = @p_seq                    
  ;          
                               
          -------------------------------------------------------------------------------------------------------------                     
          -- 12. SCP_ANL_PSI_PRODUCTION 입력                     
          --------------------------------------------------------------------------------------------------------------                    
          INSERT INTO /* PR_SCP_ANL_PSI_ELECTRODE */ dbo.SCP_ANL_PSI_ELECTRODE                    
                (                    
                   DIVISION_ID                              
                  ,PLAN_START_YYYYMMDD                      
                  ,PLAN_TYPE                                
                  ,SEQ                                      
                  ,OPERATION_GROUP                          
                  ,FROM_SITE                                
                  ,ITEM_ID                                  
                  ,PSI_TYPE                                 
                  ,PSI_VALUE                                
                  ,TO_SITE                                  
                  ,PROD_LINE                                
                  ,YYYYMMDD                                                 
                  ,QTY                                      
                  ,CELL_QTY
                  ,INVENTORY_TYPE                 
                  ,ORIGIN_FROM_DIVISION_ID        
                  ,ORIGIN_TO_DIVISION_ID        
                  ,ELECTRODE_TYPE                  
                  ,CREATED_BY                               
                  ,CREATION_DATE                            
                  ,LAST_UPDATED_BY                          
                  ,LAST_UPDATE_DATE    
                  ,ATTRIBUTE1                    
                  ,ATTRIBUTE7
                )                    


              SELECT                  
                    X.DIVISION_ID                              
                   ,X.PLAN_START_YYYYMMDD                      
                   ,X.PLAN_TYPE                                
                   ,X.SEQ                                      
                   ,X.OPERATION_GROUP                          
                   ,X.FROM_SITE                    
                   ,X.ITEM_ID                                  
                   ,X.PSI_TYPE                                 
                   ,X.PSI_VALUE                                
                   ,X.TO_SITE                    
                   --,(CASE WHEN X.DIVISION_ID ='40' AND X.PSI_TYPE = 'S' THEN '-' ELSE X.PSI_VALUE END) AS PSI_VALUE
                   --,(CASE WHEN X.DIVISION_ID ='40' AND X.PSI_TYPE = 'S' THEN '-' ELSE X.TO_SITE   END) AS TO_SITE
                   ,X.PROD_LINE                                
                   ,X.YYYYMMDD                                 
                   ,SUM(X.QTY) AS QTY
                   ,SUM(X.CELL_QTY) AS CELL_QTY
                   ,X.INVENTORY_TYPE                    
                   ,X.ORIGIN_FROM_DIVISION_ID        
                   ,ISNULL(X.ORIGIN_TO_DIVISION_ID,'') AS     ORIGIN_TO_DIVISION_ID    
                   ,Y.ELECTRODE_TYPE                 
--                   ,X.ELECTRODE_TYPE                 
                   ,@v_batch_user AS CREATED_BY                    
   ,GETDATE()     AS CREATION_DATE                    
                   ,@v_batch_user AS LAST_UPDATED_BY                    
                   ,GETDATE()     AS LAST_UPDATED_BY       
                   ,X.ATTRIBUTE1             
                   ,X.ATTRIBUTE7
              FROM #tmp_SCP_ANL_PSI_ELECTRODE X WITH (NOLOCK)                    
              INNER JOIN SCP_MST_FINAL_ITEM_V Y  WITH (NOLOCK)                    
                      ON 0 = 0    
                     AND X.ITEM_ID      = Y.ITEM_ID                                  
             WHERE 1 = 1 
				-- * 2021-05-10   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 플랜 대응 - start
               --AND X.YYYYMMDD < CONVERT(VARCHAR,DATEADD(D,364,CONVERT(DATETIME,@p_plan_start_yyyymmdd,112)),112)   
			   --
			   AND X.YYYYMMDD < @v_pet_date  
			   -- * 2021-05-10   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 플랜 대응 - end

             GROUP BY
                    X.DIVISION_ID                              
                   ,X.PLAN_START_YYYYMMDD                      
                   ,X.PLAN_TYPE                                
                   ,X.SEQ                                      
                   ,X.OPERATION_GROUP                          
                   ,X.FROM_SITE                    
                   ,X.ITEM_ID                                  
                   ,X.PSI_TYPE                                 
                   ,X.PSI_VALUE                                
                   ,X.TO_SITE                    
                   --,(CASE WHEN X.DIVISION_ID ='40' AND X.PSI_TYPE = 'S' THEN '-' ELSE X.PSI_VALUE END) 
                   --,(CASE WHEN X.DIVISION_ID ='40' AND X.PSI_TYPE = 'S' THEN '-' ELSE X.TO_SITE   END) 
                   ,X.PROD_LINE                                
                   ,X.YYYYMMDD                                 
--                   ,SUM(X.QTY) AS QTY
                   ,X.INVENTORY_TYPE                    
                   ,X.ORIGIN_FROM_DIVISION_ID        
                   ,ISNULL(X.ORIGIN_TO_DIVISION_ID,'') 
                   ,Y.ELECTRODE_TYPE       
                   ,X.ATTRIBUTE1 
                   ,X.ATTRIBUTE7
             ;    
                                   
        -----------------------------------------------------------                    
        -- 실행 Logic END --                    
        -----------------------------------------------------------                    
        --IF @@TRANCOUNT > 0                    
        --  BEGIN                    
        --    COMMIT TRAN TX_PSI1;                    
        --  END;          
        
        -----------------------------------------------------------
        -- 임시테이블 삭제
        -----------------------------------------------------------
        IF OBJECT_ID('tempdb..#tmp_SCP_ANL_PSI_ELECTRODE') IS NOT NULL
            DROP TABLE #tmp_SCP_ANL_PSI_ELECTRODE
            
        IF OBJECT_ID('tempdb..#BOH') IS NOT NULL
            DROP TABLE #BOH
            
        IF OBJECT_ID('tempdb..#tmp_SCP_ANL_PSI_PRODUCTION_DIO') IS NOT NULL
            DROP TABLE #tmp_SCP_ANL_PSI_PRODUCTION_DIO
            
        IF OBJECT_ID('tempdb..#Tbl_DIO') IS NOT NULL
            DROP TABLE #Tbl_DIO
                    
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
      --  BEGIN            ROLLBACK TRAN TX_PSI1                    
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
                    
--     임시 운영반영시에 주석처리 할것.                
     SET @v_exec_time  =  REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +                 
                          REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))                 
                
    -- 종료 LOG                    
    SET @v_log_type = N'END';                    
    SET @v_log_message = N'########## END of procedure ##########';                    
    SET @v_description = N'['+@p_master_id+']['+@p_engine_plan_id+'][' + @v_exec_time + ']';                  
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
      
     
      
