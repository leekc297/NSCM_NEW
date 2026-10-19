


                             
/*                      
 * Program ID   : PR_SCP_ANL_PSI_GLOBAL                        
 * Description  : PR_SCP_ANL_CREATE_DATA 에서 호출함.                      
 * OutTable     :                      
 * Execute      : 
                  DELETE FROM SCM_SYS_LOG_BATCH WHERE PROGRAM_NAME ='PR_SCP_ANL_PSI_GLOBAL' AND CREATED_BY = 'KTH' 
                  EXEC PR_SCP_ANL_PSI_GLOBAL
                     @p_plan_cycle          = 'WEEKLY'
                   , @p_plan_start_yyyymmdd = '20180903'
                   , @p_plan_id             = '1042'
                   , @p_modeling_id         = '2'
                   , @p_seq                 = '1'
                   , @p_plan_type           = 'SE'
                   , @p_master_id           = '81::WEEKLY'
                   , @p_division_id         = '81'
                   , @p_engine_plan_id      = '1042::SE::1'
                   , @p_user_id             = 'KTH'

                 SELECT * FROM SCM_SYS_LOG_BATCH  WITH (NOLOCK)  WHERE PROGRAM_NAME ='PR_SCP_ANL_PSI_GLOBAL' AND CREATED_BY = 'KTH'  order by CREATION_DATE desc 
                  
 * Program History                      
 *===================================================================================================                      
 *   Date       In Charge      Description                      
 *===================================================================================================                      
 * 2018.09.06   KTH         Initial Release PJ20170278 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트        
 * 2018.09.18   KTH         BALANCE, WH_IN MEASURE 로직 변경         
 * 2018.11.08   KTH         'MODEL_INVENTORY','ACTIVATE_COMPLETED' 로직 변경, BOH 로직 변경        
 * 2018.11.09   YYDOK       FROM BOH, TO BOH UPDATE로직 수정
 * 2018.11.13   YYDOK       WH_IN_BALANCE 추가
 * 2018.11.19   KTH         DIO 추가, Operation_ID(ATTRIBUTE9) 추가
 * 2018.11.29   KTH         CELL_ITEM_ID 컬럼사이즈 변경(50 --> 150), ISSUM  제외 조건 추가
 * 2018.12.05   KTH         ATTRIBUTE9 조건 변경
 * 2018.12.06   KTH         WH_IN_BLANCE 계산로직 변경
 * 2018.12.10   KTH         WH_IN 해상재고 추가
 * 2018.12.11   KTH         BALANCE,WH_IN_BALANCE 로직 변경
 * 2018.12.12   KTH         PACKE SITE CELL 재고 ('MODEL_INVENTORY' 추가) 주석 처리
 * 2018.12.13   KTH         Balance(WH_IN) INTRANSIT 반영('INTRANSIT' 추가)  <-- 진행후 ROLLBACK 함
 * 2018.12.14   KTH         MEASURE 삭제로직 반영
 * 2018.12.17   KTH         MEASURE 삭제로직 수정
 * 2018.12.19   KTH         PACKE SITE CELL 재고 ('MODEL_INVENTORY' 추가) 반영
 * 2019.01.03   KTH         해상재고 반영 (WH_IN) 수정
 * 2019.01.16   KTH         TEMPDB TABLE DROP 로직 추가, DIO 로직 변경 
 * 2019.06.18   KTH         82추가(FROM_SITE NULL 오류 수정)
 * 2021.05.10   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 플랜 대응
 * 2021.07.16   sclee       PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) : scp_mst_bod_v에서 scp_mst_bod_n_v로 변경
 * 2021.10.12   KSW         PJ20214997 LGES SCP 신규 Biz, 공정 추가에 따른 모델링 개선 - MEB biz. 적용
 * 2021.11.04   KSW         전진검사 BOH 추가 --> PI 에서 더 이상 진행하지 않으므로 주석처리
 * 2021.11.11   sclee.lee   튜닝개선안에 따른 일부 쿼리 변경 및 집계시 Pegging 물량 포함하도록 변경
 * 2022.03.15   hrkim       PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 : SAFETY_STOCK measure 추가
 * 2022.03.23	KSW			GM JV 반영 :: 81_UC  추가
 * 2023.03.29	hrkim		PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 대응
 * 2023.06.08	hrkim		PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : 활성화코드 분리 대응
 *									1. 대표 Cell Item Id : Cell Product 기준으로 Update
 * 2023.06.20	hrkim		PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : 활성화코드 분리 대응
 *									2. Cell Product의 Model Inventory를 Cell Assy기준으로 합산
 *										- Pack창고 Cell 재고는 제외 (attribute1 != 'CELL')
 *										- From Site가 국내인 경우만 (company_id = 'C100' - 7월 임시조건) 
 * 2023.06.26	hrkim		PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : 활성화코드 분리 대응
 *									3. Cell 창고의 Cell Product를 Cell Assy 재고로 치환 
 * 2023.06.29	hrkim		PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : 활성화코드 분리 대응
 * 									4. Cell창고 Cell Product 생산관련 measure 전구간 0인 데이터 삭제 (2023년 7월은 국내만, 8월부터 전체 법인)
 * 									------------------------------------------
 * 									 대상 measure 
 * 									------------------------------------------
 * 									PRODUCTION				Production
 * 									ACTIVATE_COMPLETED		Char. Completed
 * 									CHAR_AVAILABLE			Char. Available
 * 									ACTIVATE_PROGRESS		Formation Progress
 * 									MODEL_INVENTORY			Model Inventory
 * 									DIO						DIO
 * 									------------------------------------------
 * 2023/07/17	hrkim		PJ20230691 LGES SCM 역량 강화 위한 SCP 개선과제 이행 : 활성화코드 분리 대응 (8월 해외 오픈 대응) 
 * 2023/07/26	hrkim		PJ20230691 LGES SCM 역량 강화 위한 SCP 개선과제 이행 : SCP_MST_CELL_PROD_ASSY_MAP 참조시 Valid_yn = 'Y' 조건 추가
 * 2025.08.29	YMH			CSR E20250829-001508 실행계획개선 (속도개선)
 * 2026.05.22	ymh			E20260331-000738 82사업부 MA Plan 수행 시 속도지연
 */                    
                    
                        
CREATE PROCEDURE [dbo].[PR_SCP_ANL_PSI_GLOBAL]
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
    SET     @v_batch_user = @p_user_id                        
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SCP_ANL_PSI_GLOBAL';                        
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...                        
    DECLARE @n_log_count    INTEGER = 0;                        
    DECLARE @v_log_message  NVARCHAR(1000);                        
    DECLARE @v_description  NVARCHAR(500);            
    DECLARE @v_table_id     NVARCHAR(150) = N'PR_SCP_ANL_PSI_GLOBAL';                         
    DECLARE @d_event_date   DATETIME;                        
                        
  -- 시작 LOG                        
    SET @v_log_type     = N'START';                        
    SET @v_log_message  = N'########## Start of procedure ##########';                        
    SET @v_description  = @v_program_name + ':' + N' PR_SCP_ANL_PSI_GLOBAL INSERT LOGIC';                        
    SET @d_event_date   = SYSDATETIME();                        
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
        --BEGIN TRAN TX_PG                       
          -------------------------------------------------------------------------------------------------------------                         
          -- 0. temp 테이블 생성 : Measure까지 생성후 마지막에 한번에 입력하기 위해서                        
          -------------------------------------------------------------------------------------------------------------                         
          IF OBJECT_ID('tempdb..#tmp_SCP_ANL_PSI_GLOBAL') IS NOT NULL                        
              DROP TABLE #tmp_SCP_ANL_PSI_GLOBAL                        
                        
            CREATE TABLE #tmp_SCP_ANL_PSI_GLOBAL(                        
              DIVISION_ID             NVARCHAR(30)    NOT NULL,
	            PLAN_START_YYYYMMDD     NVARCHAR(8)     NOT NULL,
	            PLAN_TYPE               NVARCHAR(50)    NOT NULL,
	            SEQ                     BIGINT          NOT NULL,
	            OPERATION_GROUP         NVARCHAR(10)    NOT NULL,
          --	PROJECT_CODE            NVARCHAR(50)    NOT NULL,
	            ITEM_ID                 NVARCHAR(50)    NOT NULL,
              CELL_ITEM_ID            NVARCHAR(150)   NULL,       -- cell item id  기존에 있음
	            TO_SITE                 NVARCHAR(30)    NULL,
              TO_BOH_QTY              NUMERIC(20, 10) NULL,     -- 컬럼 신청 해야 함.
	            INCOTERMS               NVARCHAR(10)    NULL,
	            FROM_SITE               NVARCHAR(30)    NULL,
              FROM_BOH_QTY            NUMERIC(20, 10) NULL,     -- 컬럼 신청 해야 함.
	            BOD_ID                  NVARCHAR(150)   NULL,
	            TRANSPORT_MODE_LINE     NVARCHAR(50)    NULL,         
	            MEASURE                 NVARCHAR(50)    NULL,
	            YYYYMMDD                NVARCHAR(8)     NULL,
	            QTY                     NUMERIC(20, 10) NULL,
              ATTRIBUTE1              NVARCHAR(150)   NULL,     -- 입력 테이블 flag 임시 SCP_ANL_SHIPMENT_PLAN_SEMI / SCP_ANL_PSI_PRODUCTION / SCP_ANL_SHIPMENT_PLAN_FG         
              ATTRIBUTE2              NVARCHAR(150)   NULL,     -- PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 : SAFETY_STOCK measure 추가 : 안전재고일수/기간
              ATTRIBUTE9              NVARCHAR(150)   NULL,     -- operaton_id 추가
              ATTRIBUTE10             NVARCHAR(150)   NULL     -- 정렬
            );                        
           
           
           /*---------------------------------------------------------- 
              MEASURE 정리
              MKT_FCST              SCP_ANL_SHIPMENT_PLAN_FG		
              ALLOCATION            SCP_ANL_SHIPMENT_PLAN_FG		
              BALANCE               SCP_ANL_SHIPMENT_PLAN_FG		
              WH_IN                 SCP_ANL_SHIPMENT_PLAN_FG		
              SHIP_REQ              SCP_ANL_SHIPMENT_PLAN_FG		
              SHIP_PLAN             SCP_ANL_SHIPMENT_PLAN_FG		
              WH_IN_BALANCE         SCP_ANL_SHIPMENT_PLAN_FG		
		
              SHIP_PLAN             SCP_ANL_SHIPMENT_PLAN_SEMI	
              SHIP_REQ	            SCP_ANL_SHIPMENT_PLAN_SEMI	

              ALLOCATION            '0' 채움
              BALANCE               '0' 채움
              MKT_FCST              '0' 채움
              WH_IN                 로직 추가
		
              MODEL_INVENTORY       SCP_ANL_PSI_PRODUCTION	
              ACTIVATE_PROGRESS     SCP_ANL_PSI_PRODUCTION	
              CHAR_AVAILABLE        SCP_ANL_PSI_PRODUCTION	
              ACTIVATE_COMPLETED    SCP_ANL_PSI_PRODUCTION	
		
              PRODUCTION            로직
              WH_IN                 '해상재고'
              MODEL_INVENTORY       'CELL'  -- PACKE SITE CELL dio
            ----------------------------------------------------------*/
       
          
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
          -- 1. SEMI 입력   TO SITE TRANSPORT_MODE
          -------------------------------------------------------------------------------------------------------------                           
            INSERT INTO #tmp_SCP_ANL_PSI_GLOBAL
                      (
                         DIVISION_ID             
                        ,PLAN_START_YYYYMMDD     
                        ,PLAN_TYPE               
                        ,SEQ                     
                        ,OPERATION_GROUP         
                        ,ITEM_ID  
                        ,CELL_ITEM_ID                 
                        ,TO_SITE                 
                        ,TO_BOH_QTY              
                        ,INCOTERMS               
                        ,FROM_SITE               
                        ,FROM_BOH_QTY            
                        ,BOD_ID                  
                        ,TRANSPORT_MODE_LINE
                        ,MEASURE                 
                        ,YYYYMMDD                
                        ,QTY                     
                        ,ATTRIBUTE1         
                      )
            SELECT  
                   A.DIVISION_ID             
                  ,A.PLAN_START_YYYYMMDD     
                  ,A.PLAN_TYPE               
                  ,A.SEQ                     
                  ,A.OPERATION_GROUP         
                  ,A.ITEM_ID    
                  ,NULL AS CELL_ITEM_ID             
                  ,A.TO_SITE                 
                  ,NULL AS TO_BOH_QTY              
                  ,NULL AS INCOTERMS               
                  ,A.FROM_SITE               
                  ,NULL AS FROM_BOH_QTY            
                  ,A.BOD_ID                  
                  ,NULL AS TRANSPORT_MODE_LINE    
                  ,A.MEASURE                 
                  ,A.YYYYMMDD                
                  ,A.QTY               
                  ,'SCP_ANL_SHIPMENT_PLAN_SEMI'
              FROM SCP_ANL_SHIPMENT_PLAN_SEMI A WITH (NOLOCK) 
              WHERE 1 = 1                    
                AND A.DIVISION_ID           = @p_division_id                    
                AND A.PLAN_START_YYYYMMDD   = @p_plan_start_yyyymmdd                 
                AND A.PLAN_TYPE             = @p_plan_type                    
                AND A.SEQ                   = @p_seq          
                AND A.MEASURE               IN ('SHIP_PLAN','SHIP_REQ')

          -------------------------------------------------------------------------------------------------------------                         
          -- 2. PSI 입력   
          -------------------------------------------------------------------------------------------------------------                           
            INSERT INTO #tmp_SCP_ANL_PSI_GLOBAL
                      (
                         DIVISION_ID             
                        ,PLAN_START_YYYYMMDD     
                        ,PLAN_TYPE               
                        ,SEQ                     
                        ,OPERATION_GROUP         
                        ,ITEM_ID     
                        ,CELL_ITEM_ID            
                        ,TO_SITE                 
                        ,TO_BOH_QTY              
                        ,INCOTERMS               
                        ,FROM_SITE               
                        ,FROM_BOH_QTY            
                        ,BOD_ID                  
                        ,TRANSPORT_MODE_LINE 
                        ,MEASURE                 
                        ,YYYYMMDD                
                        ,QTY         
                        ,ATTRIBUTE1      
						-- PJ20214997 LGES SCP 신규 Biz, 공정 추가에 따른 모델링 개선 - MEB biz. 적용
						,ATTRIBUTE9
                      )
                      /*
                      I	MODEL_INVENTORY
                      I	ACTIVATE_PROGRESS
                      I	CHAR_AVAILABLE
                      I	ACTIVATE_COMPLETED
                      */
                SELECT  
                       A.DIVISION_ID             
                      ,A.PLAN_START_YYYYMMDD     
                      ,A.PLAN_TYPE               
                      ,A.SEQ                     
                      ,A.OPERATION_GROUP         
                      ,A.ITEM_ID        
                      ,NULL AS CELL_ITEM_ID          
                      ,A.TO_SITE                 
                      ,NULL AS TO_BOH_QTY              
                      ,NULL AS INCOTERMS               
                      ,A.FROM_SITE               
                      ,NULL AS FROM_BOH_QTY            
                      ,NULL AS BOD_ID                  
                      ,(CASE  WHEN A.PSI_TYPE ='P' THEN  A.PSI_VALUE ELSE NULL END )    AS TRANSPORT_MODE_LINE  
                      ,(CASE  WHEN A.PSI_TYPE ='P' THEN  'PRODUCTION'
                              WHEN A.PSI_TYPE ='I' AND A.PSI_VALUE  IN ('ACTIVATE_PROGRESS','CHAR_AVAILABLE','MODEL_INVENTORY','ACTIVATE_COMPLETED') THEN  A.PSI_VALUE 
                        ELSE '-' END )    AS MEASURE 
                      ,A.YYYYMMDD                
                      ,SUM(A.QTY) AS QTY                     
                      ,'SCP_ANL_PSI_PRODUCTION'
					  -- PJ20214997 LGES SCP 신규 Biz, 공정 추가에 따른 모델링 개선 - MEB biz. 적용
					  ,A.ATTRIBUTE9
                      FROM SCP_ANL_PSI_PRODUCTION A WITH (NOLOCK) 
                      WHERE 1 = 1                    
                         AND A.DIVISION_ID           = @p_division_id                    
                         AND A.PLAN_START_YYYYMMDD   = @p_plan_start_yyyymmdd                 
                         AND A.PLAN_TYPE             = @p_plan_type                    
                         AND A.SEQ                   = @p_seq      
                         AND A.PSI_VALUE             <> 'DIO'  
                         AND A.PSI_VALUE             <> 'ISSUM'  
                     GROUP BY  A.DIVISION_ID             
                      ,A.PLAN_START_YYYYMMDD     
                      ,A.PLAN_TYPE               
                      ,A.SEQ                     
                      ,A.OPERATION_GROUP         
                      ,A.ITEM_ID                 
                      ,A.TO_SITE                 
                      ,A.FROM_SITE            
                      ,(CASE  WHEN A.PSI_TYPE ='P' THEN  A.PSI_VALUE ELSE NULL END )       
                      ,(CASE  WHEN A.PSI_TYPE ='P' THEN  'PRODUCTION'
                              WHEN A.PSI_TYPE ='I' AND A.PSI_VALUE  IN ('ACTIVATE_PROGRESS','CHAR_AVAILABLE','MODEL_INVENTORY','ACTIVATE_COMPLETED') THEN  A.PSI_VALUE 
                        ELSE '-' END )  
                      ,A.YYYYMMDD       
					  -- PJ20214997 LGES SCP 신규 Biz, 공정 추가에 따른 모델링 개선 - MEB biz. 적용
					  ,A.ATTRIBUTE9
         
          -------------------------------------------------------------------------------------------------------------                                        
          -- 3. FG 입력   FROM SITE TRANSPORT_MODE
          -------------------------------------------------------------------------------------------------------------                           
            INSERT INTO #tmp_SCP_ANL_PSI_GLOBAL
                      (
                         DIVISION_ID             
                        ,PLAN_START_YYYYMMDD     
                        ,PLAN_TYPE               
                        ,SEQ                   
                        ,OPERATION_GROUP         
                        ,ITEM_ID                 
                        ,CELL_ITEM_ID
                        ,TO_SITE                 
                        ,TO_BOH_QTY              
                        ,INCOTERMS               
                        ,FROM_SITE               
                        ,FROM_BOH_QTY            
                        ,BOD_ID                  
                        ,TRANSPORT_MODE_LINE 
                        ,MEASURE                 
                        ,YYYYMMDD                
                        ,QTY         
                        ,ATTRIBUTE1         
                      )

                SELECT  --DISTINCT   -- PROJECT CODE 중복이 있으므로
                     A.DIVISION_ID             
                    ,A.PLAN_START_YYYYMMDD     
                    ,A.PLAN_TYPE               
                    ,A.SEQ                     
                    ,A.BIZ_TYPE AS OPERATION_GROUP
                    ,A.ITEM_ID                 
                    ,NULL AS CELL_ITEM_ID      
                    ,A.TO_SITE                 
                    ,NULL AS TO_BOH_QTY              
                    ,A.INCOTERMS               
                    ,A.FROM_SITE               
                    ,NULL AS FROM_BOH_QTY            
                    ,A.BOD_ID                  
                    ,NULL AS TRANSPORT_MODE_LINE    
                    ,A.MEASURE
                    ,A.YYYYMMDD                
                    ,SUM(A.QTY) AS QTY                     
                    ,'SCP_ANL_SHIPMENT_PLAN_FG'
                    FROM SCP_ANL_SHIPMENT_PLAN_FG A WITH (NOLOCK) 
                    WHERE 1 = 1                    
                       AND A.DIVISION_ID           = @p_division_id                    
                       AND A.PLAN_START_YYYYMMDD   = @p_plan_start_yyyymmdd                 
                       AND A.PLAN_TYPE             = @p_plan_type                    
                       AND A.SEQ                   = @p_seq     
                       AND A.MEASURE              NOT IN ('SHIP_PLAN_AMEND', 'WH_IN_BALANCE')
                    GROUP BY  A.DIVISION_ID             
                    ,A.PLAN_START_YYYYMMDD     
                    ,A.PLAN_TYPE               
                    ,A.SEQ                     
                    ,A.BIZ_TYPE 
                    ,A.ITEM_ID                 
                    ,A.TO_SITE                 
                    ,A.INCOTERMS               
                    ,A.FROM_SITE     
                    ,A.BOD_ID          
                    ,A.MEASURE
                    ,A.YYYYMMDD                


          -------------------------------------------------------------------------------------------------------------                                     
          -- 4. SEMI 추가 로직 : WH_IN
          -------------------------------------------------------------------------------------------------------------   

            INSERT INTO #tmp_SCP_ANL_PSI_GLOBAL
                      (
                         DIVISION_ID             
                        ,PLAN_START_YYYYMMDD     
                        ,PLAN_TYPE               
                        ,SEQ                     
                        ,OPERATION_GROUP         
                        ,ITEM_ID                 
                        ,CELL_ITEM_ID 
                        ,TO_SITE                 
                        ,TO_BOH_QTY              
                        ,INCOTERMS               
                        ,FROM_SITE               
                        ,FROM_BOH_QTY        
                        ,BOD_ID                  
                        ,TRANSPORT_MODE_LINE 
                        ,MEASURE                 
                        ,YYYYMMDD                
                        ,QTY          
                        ,ATTRIBUTE1         
                      )

                  SELECT DIVISION_ID                        
                        ,PLAN_START_YYYYMMDD                        
                        ,PLAN_TYPE                        
                        ,SEQ                        
                        ,MAX(OPERATION_GROUP)       AS OPERATION_GROUP                 
                        ,ITEM_ID                        
                        ,NULL AS CELL_ITEM_ID   
                        ,TO_SITE        
                        ,NULL AS TO_BOH_QTY                   
                        ,'-' AS INCOTERMS                        
                        ,FROM_SITE      
                        ,NULL AS FROM_BOH_QTY                   
                        ,'-'   AS BOD_ID                        
                        ,TRANSPORT_MODE_LINE        
                        ,MEASURE                        
                        ,YYYYMMDD                       
                        ,SUM(QTY) AS QTY      
                        ,'WH_IN' AS ATTRIBUTE1
--                  INTO #WH_IN
                  FROM (      
                        SELECT                          
                              B.DIVISION_ID                        
                             ,B.PLAN_START_YYYYMMDD    
                             ,B.PLAN_TYPE                        
                             ,B.SEQ                          
                             ,B.OPERATION_GROUP                        
                             ,B.ITEM_ID                        
                             ,NULL AS CELL_ITEM_ID
                             ,B.TO_SITE   
                             ,B.INCOTERMS       
                             ,B.FROM_SITE                        
                             ,B.BOD_ID                         
                             ,NULL AS TRANSPORT_MODE_LINE   
                             ,'WH_IN' AS MEASURE                 
                             ,CONVERT(NVARCHAR(8), B.END_TIME,112) AS YYYYMMDD                 
                             ,A.ALLOCATION_QTY         AS QTY        
                         FROM DBO.SCP_PLN_SHIPMENT_PLAN_PEGGING A WITH (NOLOCK)
                         LEFT OUTER HASH JOIN  SCP_PLN_SHIPMENT_PLAN B WITH (NOLOCK)
                         --LEFT OUTER JOIN  SCP_PLN_SHIPMENT_PLAN B WITH (NOLOCK)                     
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
                         AND B.SEMI_YN = 'Y'      
                         --AND A.INCOTERMS          <> '-'   20211111 집계시 Pegging 물량 포함
                         --AND B.INCOTERMS          <> '-'   20211111 집계시 Pegging 물량 포함 
                        WHERE 1 = 1                        
                           AND A.DIVISION_ID         = @p_division_id                       
                           AND A.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd                           
                           AND A.PLAN_TYPE           = @p_plan_type                         
                           AND A.SEQ                 = @p_seq
						   AND ISNULL(B.DIVISION_ID, '') <> ''
                           --AND B.INCOTERMS          <> '-' 20211111 집계시 Pegging 물량 포함
                           --AND A.INCOTERMS          <> '-' 20211111 집계시 Pegging 물량 포함
                      ) X                        
                 GROUP BY                        
                       DIVISION_ID                        
                      ,PLAN_START_YYYYMMDD                        
                      ,PLAN_TYPE                        
                      ,SEQ                        
                      ,ITEM_ID                        
                      ,TO_SITE                        
                      ,INCOTERMS                        
                      ,FROM_SITE  
                      ,TRANSPORT_MODE_LINE                      
                      ,MEASURE                        
                      ,YYYYMMDD     
                      ;            


          -------------------------------------------------------------------------------------------------------------                                             
          -- PACK SITE CELL 재고 'MODEL_INVENTORY' 추가  
          -- 정렬을 위한 ATTRIBUTE10 ='2' 추가
          -------------------------------------------------------------------------------------------------------------  
          INSERT INTO #tmp_SCP_ANL_PSI_GLOBAL
                      (
                         DIVISION_ID             
                        ,PLAN_START_YYYYMMDD     
                        ,PLAN_TYPE               
                        ,SEQ                     
                        ,OPERATION_GROUP         
                        ,ITEM_ID                 
                        ,CELL_ITEM_ID 
                        ,TO_SITE                 
                        ,TO_BOH_QTY              
                        ,INCOTERMS               
                        ,FROM_SITE               
                        ,FROM_BOH_QTY        
                        ,BOD_ID                  
                        ,TRANSPORT_MODE_LINE 
                        ,MEASURE                 
                        ,YYYYMMDD                
                        ,QTY          
                        ,ATTRIBUTE1
                        ,ATTRIBUTE10         
                      )

           SELECT DIVISION_ID      
                  ,PLAN_START_YYYYMMDD      
                  ,PLAN_TYPE      
                  ,SEQ      
                  ,'A'                      AS OPERATION_GROUP
                  ,ITEM_ID     
                  ,ITEM_ID                  AS CELL_ITEM_ID
                  ,'-'                      AS TO_SITE                 
                  ,NULL                     AS TO_BOH_QTY              
                  ,'-'                      AS INCOTERMS               
                  ,SITE_ID                  AS FROM_SITE               
                  ,NULL                     AS FROM_BOH_QTY        
                  ,'-'                      AS BOD_ID                  
                  ,NULL                     AS TRANSPORT_MODE_LINE 
                  ,'MODEL_INVENTORY'        AS MEASURE           --- PACK SITE CELL 재고
                  ,YYYYMMDD                
                  ,(ISNULL(PSI_EOH_QTY,0))  AS PSI_BOH_QTY    
                  ,'CELL'                   AS ATTRIBUTE1     
                  ,'2'                      AS ATTRIBUTE10
             FROM SCP_PLN_PLANT_ONHAND WITH(NOLOCK)     
            WHERE DIVISION_ID               = @P_DIVISION_ID              
              AND PLAN_START_YYYYMMDD       = @P_PLAN_START_YYYYMMDD      
              AND PLAN_TYPE                 = @P_PLAN_TYPE                
              AND SEQ                       = @P_SEQ                  
              AND OPERATION_GROUP           ='A'
--             AND ITEM_ID                   = @p_item_id   
              AND SITE_ID                 LIKE '%-P'
              AND STOCK_TYPE                 = 'A_PACK'    

         ---------------------------------------------------------------------------------------------------------------------  
		 -- begin 2023.06.20 활성화코드 분리 대응 : Cell Product의 Model Inventory 변환 적용 
		 -- ### 6. Cell Product의 Model Inventory 변환 적용 
		 -- Cell Product Model Inventory를 Cell Assy Model Inventory와 변환 합산 (Model Inventory는 Cell Assy 기준으로 적재)
		 -- Pack창고의 Cell Product는 제외함. 
		 -- 2023년7월은 한시적으로 국내 법인만 적용 (From Site 법인 : C100을 제한) 
         ---------------------------------------------------------------------------------------------------------------------   
		 ---### 6.0 Cell Product기준 Cell Assy 정보 추출 -> Model Inventory 및 #BOH 추출시 참조 예정  
         ---------------------------------------------------------------------------------------------------------------------   
		IF OBJECT_ID('TEMPDB..#tmp_CellAssy_INFO') IS NOT NULL 
			DROP TABLE #tmp_CellAssy_INFO;

		SELECT M.DIVISION_ID
			  ,M.PLANT_ID
			  ,M.ITEM_ID_ASSY
			  ,M.ITEM_ID_PROD
			  ,ROW_NUMBER() OVER (PARTITION BY M.DIVISION_ID
											  ,M.ITEM_ID_PROD
											  ,M.PLANT_ID
									  ORDER BY M.VALID_YN DESC
											  ,M.CELL_TYPE
											  ,M.ITEM_ID_ASSY) PRIORITY_1ST
			  ,ROW_NUMBER() OVER (PARTITION BY M.DIVISION_ID
											  ,M.ITEM_ID_PROD
									  ORDER BY M.VALID_YN DESC 
											  ,M.CELL_TYPE
											  ,M.ITEM_ID_ASSY) PRIORITY_2ND
			  ,ROW_NUMBER() OVER (PARTITION BY M.ITEM_ID_PROD
									  ORDER BY M.VALID_YN DESC 
											  ,M.CELL_TYPE
											  ,M.ITEM_ID_ASSY) PRIORITY_3RD
		 INTO #tmp_CellAssy_INFO
		 FROM SCP_MST_CELL_PROD_ASSY_MAP M WITH(NOLOCK)
		WHERE 1=1
		  AND M.VALID_YN = 'Y' -- 2023/7/26 추가

         ---------------------------------------------------------------------------------------------------------------------   
		 ---### 6.1 -- 대상 Cell Product Model Inventory 데이터 추출 
         ---------------------------------------------------------------------------------------------------------------------   
			IF OBJECT_ID('tempdb..#tgt_CELL_PRODUCT_MODEL_INVENTORY') IS NOT NULL 
				DROP TABLE #tgt_CELL_PRODUCT_MODEL_INVENTORY ;

			SELECT PG.*
				  ,FS.PLANT_ID
				  ,ISNULL(ISNULL(CA1.ITEM_ID_ASSY, CA2.ITEM_ID_ASSY), CA3.ITEM_ID_ASSY) AS CELL_ASSY 
			 INTO #tgt_CELL_PRODUCT_MODEL_INVENTORY  
			 FROM #tmp_SCP_ANL_PSI_GLOBAL PG WITH(NOLOCK)
				  INNER JOIN SCP_MST_FINAL_ITEM_V FI WITH(NOLOCK)
						  ON FI.ITEM_ID = PG.ITEM_ID
						 AND FI.CELL_TYPE = 'CP' -- Cell Product 
				  INNER JOIN SCM_MST_SITE FS WITH(NOLOCK)		-- 7월은 국내만 적용  
						  ON FS.DIVISION_ID		= PG.DIVISION_ID
						 AND FS.SCM_SITE_ID		= PG.FROM_SITE
						 AND FS.SITE_TYPE		= 'PLANT'
						 AND FS.OPERATION_GROUP = 'A'		-- Cell 창고 (Pack창고 Cell은 대상 아님) 
						 AND FS.OSP_YN			= 'N'
				   LEFT JOIN #tmp_CellAssy_INFO CA1
						  ON CA1.DIVISION_ID	= PG.DIVISION_ID
						 AND CA1.ITEM_ID_PROD	= PG.ITEM_ID
						 AND CA1.PLANT_ID		= FS.PLANT_ID
						 AND CA1.PRIORITY_1ST	= 1 
				   LEFT JOIN #tmp_CellAssy_INFO CA2
						  ON CA2.DIVISION_ID	= PG.DIVISION_ID
						 AND CA2.ITEM_ID_PROD	= PG.ITEM_ID
						 AND CA2.PRIORITY_2ND	= 1 
				   LEFT JOIN #tmp_CellAssy_INFO CA3
						  ON CA3.ITEM_ID_PROD	= PG.ITEM_ID
						 AND CA3.PRIORITY_3RD	= 1 
			WHERE 1=1
			  AND PG.OPERATION_GROUP		= 'A'	-- Cell 모델
			  AND PG.MEASURE				= 'MODEL_INVENTORY'

         ---------------------------------------------------------------------------------------------------------------------   
		 ---### 6.2 Cell Product Model Inventory 데이터 삭제 
         ---------------------------------------------------------------------------------------------------------------------   
			DELETE X 
			 FROM #tmp_SCP_ANL_PSI_GLOBAL X WITH(NOLOCK)
			WHERE 1=1
			  AND X.MEASURE = 'MODEL_INVENTORY'
			  AND EXISTS (SELECT TOP 1 1
						   FROM #tgt_CELL_PRODUCT_MODEL_INVENTORY TGT
						  WHERE 1=1
							AND TGT.CELL_ASSY IS NOT NULL 
							AND TGT.PLAN_START_YYYYMMDD = X.PLAN_START_YYYYMMDD
							AND TGT.PLAN_TYPE			= X.PLAN_TYPE
							AND TGT.SEQ					= X.SEQ
							AND TGT.DIVISION_ID			= X.DIVISION_ID
							AND TGT.OPERATION_GROUP		= X.OPERATION_GROUP
							AND TGT.ITEM_ID				= X.ITEM_ID  -- Cell Product
							AND TGT.FROM_SITE			= X.FROM_SITE
							AND TGT.MEASURE				= X.MEASURE
							AND TGT.YYYYMMDD			= X.YYYYMMDD
							-- NULL AND TGT.CELL_ITEM_ID		= X.CELL_ITEM_ID
							-- NULL AND TGT.TO_SITE				= X.TO_SITE
							-- NULL AND TGT.INCOTERMS			= X.INCOTERMS
							-- NULL AND TGT.BOD_ID				= X.BOD_ID
							-- NULL AND TGT.TRANSPORT_MODE_LINE	= X.TRANSPORT_MODE_LINE
						  )

         ---------------------------------------------------------------------------------------------------------------------   
		 ---### 6.3 Cell Product Model Inventory 대상 데이터 Cell Assy에 합산 적용 (UPDATE / INSERT)  
         ---------------------------------------------------------------------------------------------------------------------   
			MERGE INTO #tmp_SCP_ANL_PSI_GLOBAL AS TGT
			USING (
					SELECT   PLAN_START_YYYYMMDD
							,PLAN_TYPE			
							,SEQ				
							,DIVISION_ID		
							,OPERATION_GROUP	
							,CELL_ASSY			AS ITEM_ID			
							,NULL				AS CELL_ITEM_ID -- 아래 로직에서 Cell Product로 일괄 Update됨. (SCP_ANL_PSI_PRODUCTION 'MODEL_INVENTORY'참조시  cell _item_id를 null로 넣고 있음) 		
							,TO_SITE			
							,INCOTERMS			
							,FROM_SITE			
							,BOD_ID				
							,TRANSPORT_MODE_LINE
							,MEASURE			
							,YYYYMMDD
							,SUM(QTY)			AS QTY
							,SUM(FROM_BOH_QTY)	AS FROM_BOH_QTY
							,SUM(TO_BOH_QTY)	AS TO_BOH_QTY
							,MAX(ATTRIBUTE1)	AS ATTRIBUTE1
							,MAX(ATTRIBUTE2)	AS ATTRIBUTE2
							,MAX(ATTRIBUTE9)	AS ATTRIBUTE9
							,MAX(ATTRIBUTE10)	AS ATTRIBUTE10
					 FROM #tgt_CELL_PRODUCT_MODEL_INVENTORY  
					WHERE 1=1
					  AND CELL_ASSY IS NOT NULL
					GROUP BY PLAN_START_YYYYMMDD
							,PLAN_TYPE			
							,SEQ				
							,DIVISION_ID		
							,OPERATION_GROUP	
							,CELL_ASSY	
							,TO_SITE			
							,INCOTERMS			
							,FROM_SITE			
							,BOD_ID				
							,TRANSPORT_MODE_LINE
							,MEASURE			
							,YYYYMMDD
				  ) AS SRC
			  ON 1=1
			 AND TGT.PLAN_START_YYYYMMDD	= SRC.PLAN_START_YYYYMMDD
			 AND TGT.PLAN_TYPE				= SRC.PLAN_TYPE
			 AND TGT.SEQ					= SRC.SEQ
			 AND TGT.DIVISION_ID			= SRC.DIVISION_ID
			 AND TGT.OPERATION_GROUP		= SRC.OPERATION_GROUP
			 AND TGT.ITEM_ID				= SRC.ITEM_ID
			 AND TGT.FROM_SITE				= SRC.FROM_SITE
			 AND TGT.MEASURE				= SRC.MEASURE
			 AND TGT.YYYYMMDD				= SRC.YYYYMMDD
			 -- NULL AND TGT.CELL_ITEM_ID			= SRC.CELL_ITEM_ID -- NULL (대상이 아닌 Pack Site 셀을 제외하고 모두 NULL임) 
			 -- NULL AND TGT.TO_SITE				= SRC.TO_SITE
			 -- NULL AND TGT.INCOTERMS				= SRC.INCOTERMS
			 -- NULL AND TGT.BOD_ID					= SRC.BOD_ID
			 -- NULL AND TGT.TRANSPORT_MODE_LINE	= SRC.TRANSPORT_MODE_LINE
			
			WHEN MATCHED THEN
				 UPDATE SET TGT.QTY				= TGT.QTY			+ SRC.QTY
						   ,TGT.FROM_BOH_QTY	= TGT.FROM_BOH_QTY	+ SRC.FROM_BOH_QTY
						   ,TGT.TO_BOH_QTY		= TGT.TO_BOH_QTY	+ SRC.TO_BOH_QTY
						   ,TGT.ATTRIBUTE2	    = 'UPDATE :: ' + CONVERT (NVARCHAR(40), TGT.QTY) + ' :: ' + CONVERT (NVARCHAR(40), SRC.QTY) 

			WHEN NOT MATCHED  THEN 
				INSERT (
						PLAN_START_YYYYMMDD
					   ,PLAN_TYPE			
					   ,SEQ				
					   ,DIVISION_ID		
					   ,OPERATION_GROUP	
					   ,ITEM_ID			
					   ,CELL_ITEM_ID		
					   ,TO_SITE			
					   ,INCOTERMS			
					   ,FROM_SITE			
					   ,BOD_ID				
					   ,TRANSPORT_MODE_LINE
					   ,MEASURE			
					   ,YYYYMMDD			
					   ,QTY
					   ,FROM_BOH_QTY
					   ,TO_BOH_QTY
					   ,ATTRIBUTE1
					   ,ATTRIBUTE2
					   ,ATTRIBUTE9
					   ,ATTRIBUTE10
					)
			 VALUES (
					 SRC.PLAN_START_YYYYMMDD
					,SRC.PLAN_TYPE			
					,SRC.SEQ				
					,SRC.DIVISION_ID		
					,SRC.OPERATION_GROUP	
					,SRC.ITEM_ID			
					,SRC.CELL_ITEM_ID		
					,SRC.TO_SITE			
					,SRC.INCOTERMS			
					,SRC.FROM_SITE			
					,SRC.BOD_ID				
					,SRC.TRANSPORT_MODE_LINE
					,SRC.MEASURE			
					,SRC.YYYYMMDD			
					,SRC.QTY
					,SRC.FROM_BOH_QTY
					,SRC.TO_BOH_QTY
					,SRC.ATTRIBUTE1
					,'INSERT' --- SRC.ATTRIBUTE2 
					,SRC.ATTRIBUTE9
					,SRC.ATTRIBUTE10
					)
					;
         ---------------------------------------------------------------------------------------------------------------------                                             
		 -- end 2023.06.20 활성화코드 분리 대응 : Cell Product의 Model Inventory 변환 적용 
         ---------------------------------------------------------------------------------------------------------------------                                             

          -------------------------------------------------------------------------------------------------------------                                             
          -- 8. 해상재고 반영 (WH_IN)
          -------------------------------------------------------------------------------------------------------------  

                 SELECT 
                        DIVISION_ID 
                        ,PLAN_START_YYYYMMDD
                        ,PLAN_TYPE
                        ,SEQ
                        ,OPERATION_GROUP
                        ,ITEM_ID
                        ,CELL_ITEM_ID
                        ,TO_SITE
                        ,TO_BOH_QTY
                        ,INCOTERMS
                        ,FROM_SITE
                        ,FROM_BOH_QTY
                        ,BOD_ID
                        ,TRANSPORT_MODE_LINE
                        ,MEASURE
                        ,YYYYMMDD
                        ,SUM(QTY) AS QTY
                        ,ATTRIBUTE1
                        INTO #INT
                        FROM (
                               SELECT                          
                                      @P_DIVISION_ID            AS DIVISION_ID
                                      ,@P_PLAN_START_YYYYMMDD   AS PLAN_START_YYYYMMDD
                                      ,@P_PLAN_TYPE             AS PLAN_TYPE 
                                      ,@P_SEQ                   AS SEQ 
                                      ,C.OPERATION_GROUP                        
                                      ,A.ITEM_ID                        
                                      ,NULL AS CELL_ITEM_ID
                                      ,(SUBSTRING(site_id, 1, DBO.FN_CHARINDEX_REV(site_id, '~', 0)-1))  AS TO_SITE   
                                      ,NULL AS TO_BOH_QTY
                                      ,CONVERT(NVARCHAR(10),'') AS INCOTERMS       
                                      ,(SUBSTRING(lot_id, DBO.FN_CHARINDEX_REV(lot_id, '::', 0)+2,100)) AS FROM_SITE   
                                      ,NULL AS FROM_BOH_QTY                     
                                      ,NULL AS BOD_ID                         
                                      ,NULL AS TRANSPORT_MODE_LINE            -- NULL 후 UPDATE ?
                                      ,'WH_IN' AS MEASURE                 
                                      ,CONVERT(NVARCHAR(8), A.RECEIVING_DTTM,112) AS YYYYMMDD                 
                                      ,(A.QTY)         AS QTY        
                                      ,'WH_IN'  AS  ATTRIBUTE1 
                  --                INTO #INT
                                  FROM DBO.TH_ENG_STOCK_PLAN_SN A WITH (NOLOCK)             
                                  INNER JOIN DBO.SCP_MST_FINAL_ITEM_V C  WITH (NOLOCK)           
                                      ON 0 = 0
                  --                 AND A.DIVISION_ID  = @p_division_id       
                                     AND A.ITEM_ID      = C.ITEM_ID                                               
                                WHERE 1 = 1                        
                                    AND A.MASTER_ID        = @p_master_id                    
                                    AND A.PLAN_ID          = @p_engine_plan_id    
--                                    AND A.ITEM_ID          = @p_item_id
                                    AND A.DESCR            = 'INT'       
                              ) X
                        GROUP BY DIVISION_ID 
                        ,PLAN_START_YYYYMMDD
                        ,PLAN_TYPE
                        ,SEQ
                        ,OPERATION_GROUP
                        ,ITEM_ID
                        ,CELL_ITEM_ID
                        ,TO_SITE
                        ,TO_BOH_QTY
                        ,INCOTERMS
                        ,FROM_SITE
                        ,FROM_BOH_QTY
                        ,BOD_ID
                        ,TRANSPORT_MODE_LINE
                        ,MEASURE
                        ,YYYYMMDD
                        --,QTY
                        ,ATTRIBUTE1
                        ;


              UPDATE X
                SET X.QTY = (ISNULL(X.QTY,0) + ISNULL(Y.QTY,0))
                FROM #tmp_SCP_ANL_PSI_GLOBAL X  WITH (NOLOCK)
                INNER JOIN #INT Y  WITH (NOLOCK)
                ON X.ITEM_ID     = Y.ITEM_ID                        
                AND X.TO_SITE    = Y.TO_SITE   
                AND X.FROM_SITE  = Y.FROM_SITE
                AND X.YYYYMMDD   = Y.YYYYMMDD 
                AND X.MEASURE    = Y.MEASURE
                AND X.MEASURE    = 'WH_IN'
                AND X.ATTRIBUTE1 = 'WH_IN'

            --DECLARE @p_item_id nvarchar(20) =  'ACPN1030U-B1'  -- 'ACEN1063I-A3' 
            --SELECT * FROM    #tmp_SCP_ANL_PSI_GLOBAL  WITH (NOLOCK) WHERE ITEM_ID =@p_item_id AND MEASURE    = 'WH_IN' AND YYYYMMDD =@p_plan_start_yyyymmdd order by YYYYMMDD

            MERGE INTO #tmp_SCP_ANL_PSI_GLOBAL AS X  
            USING (SELECT DIVISION_ID
                          ,PLAN_START_YYYYMMDD
                          ,PLAN_TYPE
                          ,SEQ
                          ,OPERATION_GROUP
                         ,ITEM_ID
                         ,CELL_ITEM_ID
                         ,TO_SITE
                         ,TO_BOH_QTY
                         ,INCOTERMS
                         ,FROM_SITE
                         ,FROM_BOH_QTY
                         ,BOD_ID
                         ,TRANSPORT_MODE_LINE
                         ,MEASURE
                         ,YYYYMMDD
                         ,QTY
                    FROM #INT
--                  WHERE QTY > 0 
                  ) AS Y
            ON 0 = 0
            AND X.TO_SITE     = Y.TO_SITE 
            AND X.FROM_SITE   = Y.FROM_SITE 
            AND X.ITEM_ID     = Y.ITEM_ID
            AND X.YYYYMMDD    = Y.YYYYMMDD 
            AND X.MEASURE     = Y.MEASURE


            WHEN NOT MATCHED  THEN 
              INSERT (
                        DIVISION_ID
                       ,PLAN_START_YYYYMMDD
                       ,PLAN_TYPE
                       ,SEQ
                       ,OPERATION_GROUP
                       ,ITEM_ID
                       ,CELL_ITEM_ID
                       ,TO_SITE
                       ,TO_BOH_QTY
                       ,INCOTERMS
                       ,FROM_SITE
                       ,FROM_BOH_QTY
                       ,BOD_ID
                       ,TRANSPORT_MODE_LINE
                       ,MEASURE
                       ,YYYYMMDD
                       ,QTY
                       ,ATTRIBUTE1
                    )
             VALUES (
                     DIVISION_ID
                    ,PLAN_START_YYYYMMDD
                    ,PLAN_TYPE
                    ,SEQ
                    ,OPERATION_GROUP
                    ,ITEM_ID
                    ,CELL_ITEM_ID
                    ,TO_SITE
                    ,TO_BOH_QTY
                    ,'-'            -- AS INCOTERMS
                    ,FROM_SITE
                    ,FROM_BOH_QTY
                    ,'-'            -- AS BOD_ID
                    ,TRANSPORT_MODE_LINE
                    ,MEASURE
                    ,YYYYMMDD
                    ,QTY
                    ,'WH_IN'        --AS ATTRIBUTE1
                    )
                    ;

                      
          -------------------------------------------------------------------------------------------------------------                                             
          -- 7. MKT_FCST 0 채워 넣기
          -------------------------------------------------------------------------------------------------------------  

          CREATE CLUSTERED INDEX [IX01_#tmp_SCP_ANL_PSI_GLOBAL] ON #tmp_SCP_ANL_PSI_GLOBAL            
            (            
             --  DIVISION_ID,             
             --  PLAN_START_YYYYMMDD,
             --  PLAN_TYPE,
             --  SEQ,
             --  OPERATION_GROUP,
             --  ITEM_ID,
             --  TO_SITE,
             ----INCOTERMS,
             --  FROM_SITE,
             --  BOD_ID,
             ----MEASURE,
             --  YYYYMMDD,
             --  ORIGIN_FROM_DIVISION_ID,
             --  ORIGIN_TO_DIVISION_ID,
             --  TRANSPORT_MODE_LINE,
               ATTRIBUTE1     
              );             


            INSERT INTO #tmp_SCP_ANL_PSI_GLOBAL /* CHECK*/
                      (
                         DIVISION_ID             
                        ,PLAN_START_YYYYMMDD     
                        ,PLAN_TYPE               
                        ,SEQ                     
                        ,OPERATION_GROUP         
                        ,ITEM_ID         
                        ,CELL_ITEM_ID                 
                        ,TO_SITE                 
                        ,INCOTERMS               
                        ,FROM_SITE               
                        ,BOD_ID                  
                        ,TRANSPORT_MODE_LINE 
                        ,MEASURE                 
                        ,YYYYMMDD                
                        ,QTY                     
                        ,ATTRIBUTE1         
                      )
                 SELECT            
                          SUB.DIVISION_ID               
                         ,SUB.PLAN_START_YYYYMMDD       
                         ,SUB.PLAN_TYPE                 
                         ,SUB.SEQ                
                         ,SUB.OPERATION_GROUP           
                         ,SUB.ITEM_ID    
                         ,SUB.CELL_ITEM_ID
                         ,SUB.TO_SITE    
                         , '-' AS INCOTERMS
                         , FROM_SITE    
                         ,'-' AS BOD_ID    
                         ,SUB.TRANSPORT_MODE_LINE
                         ,'MKT_FCST' AS MEASURE    
                         ,SUB.YYYYMMDD     
                         ,0   AS QTY         
                         ,'SCP_ANL_SHIPMENT_PLAN_SEMI' AS  ATTRIBUTE1                   
                    FROM         
                        (        
                            SELECT         
                                   DIVISION_ID                
                                  ,PLAN_START_YYYYMMDD                
                                  ,PLAN_TYPE                
                                  ,SEQ                
                                  ,OPERATION_GROUP                
                                  ,ITEM_ID     
                                  ,CELL_ITEM_ID     
                                  ,FROM_SITE    
                                  ,TO_SITE    
        --                          ,MEASURE    
                                  ,YYYYMMDD    
                                  ,NULL AS TRANSPORT_MODE_LINE
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
                                           ,ITEM_ID  
                                           ,CELL_ITEM_ID     
                                           ,FROM_SITE    
                                           ,TO_SITE    
        --                                   ,MEASURE    
                                           ,NULL AS TRANSPORT_MODE_LINE
                                      FROM #tmp_SCP_ANL_PSI_GLOBAL X WITH(NOLOCK)        
                                     WHERE 1=1      
                                       AND ATTRIBUTE1 = 'SCP_ANL_SHIPMENT_PLAN_SEMI'
                                  ) B        
                        ) SUB        
                        WHERE 1=1        
                          AND NOT EXISTS (        
                                           SELECT 'X'        
                                             FROM #tmp_SCP_ANL_PSI_GLOBAL Z WITH(NOLOCK)        
                                            WHERE 1=1        
                                              AND Z.DIVISION_ID              = SUB.DIVISION_ID                                
                                              AND Z.PLAN_START_YYYYMMDD      = SUB.PLAN_START_YYYYMMDD                        
                                              AND Z.PLAN_TYPE                = SUB.PLAN_TYPE                                  
                                              AND Z.SEQ                      = SUB.SEQ 
          
                                              AND Z.OPERATION_GROUP          = SUB.OPERATION_GROUP                            
                                              AND Z.ITEM_ID                  = SUB.ITEM_ID     
                                              AND Z.CELL_ITEM_ID             = SUB.CELL_ITEM_ID
                                              AND Z.TO_SITE                  = SUB.TO_SITE                                    
             
                                              AND Z.FROM_SITE                = SUB.FROM_SITE                                  
        --                                      AND Z.MEASURE                  = SUB.MEASURE                                    
                                              AND Z.YYYYMMDD                 = SUB.YYYYMMDD       
                                         );          

            INSERT INTO #tmp_SCP_ANL_PSI_GLOBAL /* CHECK*/
                        (
                           DIVISION_ID             
                          ,PLAN_START_YYYYMMDD     
                          ,PLAN_TYPE               
                          ,SEQ                     
                          ,OPERATION_GROUP         
                          ,ITEM_ID         
                          ,CELL_ITEM_ID                 
                          ,TO_SITE                 
                          ,INCOTERMS               
                          ,FROM_SITE               
                          ,BOD_ID                  
                          ,TRANSPORT_MODE_LINE 
                          ,MEASURE                 
                          ,YYYYMMDD                
                          ,QTY                     
                          ,ATTRIBUTE1         
                        )

                    SELECT            
                            SUB.DIVISION_ID               
                           ,SUB.PLAN_START_YYYYMMDD       
                           ,SUB.PLAN_TYPE                 
                           ,SUB.SEQ                
                           ,SUB.OPERATION_GROUP           
                           ,SUB.ITEM_ID    
                           ,SUB.CELL_ITEM_ID
                           ,SUB.TO_SITE    
                           , '-' AS INCOTERMS
                           , FROM_SITE    
                           ,'-' AS BOD_ID    
                           ,SUB.TRANSPORT_MODE_LINE
                           ,'WH_IN' AS MEASURE    
                           ,SUB.YYYYMMDD     
                           ,0   AS QTY         
                           ,'SCP_ANL_SHIPMENT_PLAN_SEMI' AS  ATTRIBUTE1                   
                      FROM         
                          (        
                              SELECT         
                                     DIVISION_ID                
                                    ,PLAN_START_YYYYMMDD                
                                    ,PLAN_TYPE                
                                    ,SEQ                
                                    ,OPERATION_GROUP                
                                    ,ITEM_ID     
                                    ,CELL_ITEM_ID     
                                    ,FROM_SITE    
                                    ,TO_SITE    
                                    ,'WH_IN' AS MEASURE    
                              ,YYYYMMDD    
                                    ,NULL AS TRANSPORT_MODE_LINE
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
                                             ,ITEM_ID  
                                             ,CELL_ITEM_ID     
                                             ,FROM_SITE    
                                             ,TO_SITE    
                                             ,MEASURE    
                                             ,NULL AS TRANSPORT_MODE_LINE
                                        FROM #tmp_SCP_ANL_PSI_GLOBAL X WITH(NOLOCK)        
                                       WHERE 1=1      
                                         AND ATTRIBUTE1 = 'SCP_ANL_SHIPMENT_PLAN_SEMI'
                                         AND MEASURE    = 'WH_IN'
                                    ) B        
                          ) SUB        
                          WHERE 1=1        
                            AND NOT EXISTS (        
                                             SELECT 'X'        
                                               FROM #tmp_SCP_ANL_PSI_GLOBAL Z WITH(NOLOCK)        
                                              WHERE 1=1        
                                                AND Z.DIVISION_ID              = SUB.DIVISION_ID                                
                                                AND Z.PLAN_START_YYYYMMDD      = SUB.PLAN_START_YYYYMMDD                        
                                                AND Z.PLAN_TYPE                = SUB.PLAN_TYPE                                  
                                                AND Z.SEQ                      = SUB.SEQ 
                                                                                     
                                                AND Z.OPERATION_GROUP          = SUB.OPERATION_GROUP                            
                                                AND Z.ITEM_ID                  = SUB.ITEM_ID     
                                                AND Z.CELL_ITEM_ID             = SUB.CELL_ITEM_ID
                                                AND Z.TO_SITE                  = SUB.TO_SITE                                    
             
                                                AND Z.FROM_SITE                = SUB.FROM_SITE                                  
                                                AND Z.MEASURE                  = SUB.MEASURE                                    
                                                AND Z.YYYYMMDD                 = SUB.YYYYMMDD       
                 
             );          


             INSERT INTO #tmp_SCP_ANL_PSI_GLOBAL /* CHECK*/
                        (
                           DIVISION_ID             
                          ,PLAN_START_YYYYMMDD     
                          ,PLAN_TYPE               
                          ,SEQ                     
                          ,OPERATION_GROUP         
                          ,ITEM_ID         
                          ,CELL_ITEM_ID                 
                          ,TO_SITE                 
                          ,INCOTERMS               
                          ,FROM_SITE               
                          ,BOD_ID                  
                          ,TRANSPORT_MODE_LINE 
                          ,MEASURE                 
                          ,YYYYMMDD                
                          ,QTY                     
                          ,ATTRIBUTE1         
                        )

                    SELECT            
                            SUB.DIVISION_ID               
                           ,SUB.PLAN_START_YYYYMMDD       
                           ,SUB.PLAN_TYPE                 
                           ,SUB.SEQ                
                           ,SUB.OPERATION_GROUP           
                           ,SUB.ITEM_ID    
                           ,SUB.CELL_ITEM_ID
                           ,SUB.TO_SITE    
                           , '-' AS INCOTERMS
                           , FROM_SITE    
                           ,'-' AS BOD_ID    
                           ,SUB.TRANSPORT_MODE_LINE
                           ,'WH_IN' AS MEASURE    
                           ,SUB.YYYYMMDD     
                           ,0   AS QTY         
                           ,'WH_IN' AS  ATTRIBUTE1                   
                      FROM         
                          (        
                              SELECT         
                                     DIVISION_ID                
                                    ,PLAN_START_YYYYMMDD                
                                    ,PLAN_TYPE                
                                    ,SEQ                
                                    ,OPERATION_GROUP                
                                    ,ITEM_ID     
                                    ,CELL_ITEM_ID     
                                    ,FROM_SITE    
                                    ,TO_SITE    
                                    ,'WH_IN' AS MEASURE    
                              ,YYYYMMDD    
                                    ,NULL AS TRANSPORT_MODE_LINE
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
                                             ,ITEM_ID  
                                             ,CELL_ITEM_ID     
                                             ,FROM_SITE    
                                             ,TO_SITE    
                                             ,MEASURE    
                                             ,NULL AS TRANSPORT_MODE_LINE
                                        FROM #tmp_SCP_ANL_PSI_GLOBAL X WITH(NOLOCK)        
                                       WHERE 1=1      
                                         AND ATTRIBUTE1 = 'WH_IN'
                                         AND MEASURE    = 'WH_IN'
                                    ) B        
                          ) SUB        
                          WHERE 1=1        
                            AND NOT EXISTS (        
                                             SELECT 'X'        
                                               FROM #tmp_SCP_ANL_PSI_GLOBAL Z WITH(NOLOCK)        
                                              WHERE 1=1        
                                                AND Z.DIVISION_ID              = SUB.DIVISION_ID                                
                                                AND Z.PLAN_START_YYYYMMDD      = SUB.PLAN_START_YYYYMMDD                        
                                                AND Z.PLAN_TYPE                = SUB.PLAN_TYPE                                  
                                                AND Z.SEQ                      = SUB.SEQ 
                                                                                     
                                                AND Z.OPERATION_GROUP          = SUB.OPERATION_GROUP                            
                                                AND Z.ITEM_ID                  = SUB.ITEM_ID     
                                                AND Z.CELL_ITEM_ID             = SUB.CELL_ITEM_ID
                                                AND Z.TO_SITE                  = SUB.TO_SITE                                    
             
                                                AND Z.FROM_SITE                = SUB.FROM_SITE                                  
                                                AND Z.MEASURE                  = SUB.MEASURE                                    
                                                AND Z.YYYYMMDD                 = SUB.YYYYMMDD       
                                              );          

                                                                       

                   
          -------------------------------------------------------------------------------------------------------------                                   
          -- 9. UPDATE   ( BOH, TRANSPORT MODE)  SEMI (TO_SITE TRANS_MODE / FROM_SITE BOH), FG (FROM_SITE TRANS_MODE /  TO_SITE BOH)
          -------------------------------------------------------------------------------------------------------------      
          -------------------------------------------------------------------------------------------------------------                                  
          -- 9.1 -- SCP_PLN_SALES_ONHAND BOH 임시테이블 추출
          -------------------------------------------------------------------------------------------------------------       
          
          SELECT *
          INTO #BOH
          FROM (                              
            SELECT DIVISION_ID      
                 ,PLAN_START_YYYYMMDD      
                 ,PLAN_TYPE      
                 ,SEQ      
                 ,SITE_ID      
                 ,ITEM_ID      
                 ,PSI_BOH_QTY       
             FROM SCP_PLN_SALES_ONHAND  WITH (NOLOCK)        
            WHERE 0 = 0  
              and division_id               = @P_DIVISION_ID               
              and plan_start_yyyymmdd       = @P_PLAN_START_YYYYMMDD       
              and plan_type                 = @P_PLAN_TYPE                 
              and seq                       = @P_SEQ                       
              and yyyymmdd                  = @P_PLAN_START_YYYYMMDD           
          -------------------------------------------------------------------------------------------------------------                                    
          -- 9.2 -- SCP_PLN_PLANT_ONHAND BOH 임시테이블 추출
          ------------------------------------------------------------------------------------------------------------- 
          UNION
		  -------------------------------------------------------------------------------------------------------------
		  -- 2023.06.26 활성화 코드 대응 : Cell창고 Cell Product 재고를 Cell Assy 재고로 치환 
		  -------------------------------------------------------------------------------------------------------------
			SELECT PO.DIVISION_ID
				  ,PO.PLAN_START_YYYYMMDD
				  ,PO.PLAN_TYPE 
				  ,PO.SEQ
				  ,PO.SITE_ID
				  ,CASE WHEN FS.OPERATION_GROUP = 'A' AND FS.SITE_TYPE = 'PLANT'	-- CELL 창고
							 AND FS.OSP_YN = 'N'
				             AND (CA1.ITEM_ID_ASSY IS NOT NULL OR 
								  CA2.ITEM_ID_ASSY IS NOT NULL OR 
								  CA3.ITEM_ID_ASSY IS NOT NULL)						-- Cell Assy 매핑정보가 존재하는 CP
						THEN ISNULL(ISNULL(CA1.ITEM_ID_ASSY, CA2.ITEM_ID_ASSY), CA3.ITEM_ID_ASSY)   -- Cell Product를 Cell Assy 정보로 치환
						ELSE PO.ITEM_ID
					END		AS ITEM_ID
				  ,ISNULL(SUM(PO.PSI_BOH_QTY),0) AS PSI_BOH_QTY
             FROM SCP_PLN_PLANT_ONHAND  PO WITH(NOLOCK)  
				  INNER JOIN SCM_MST_SITE FS WITH(NOLOCK)   -- sp_helpindex SCM_MST_SITE 
						  ON FS.DIVISION_ID = PO.DIVISION_ID
						 AND FS.SCM_SITE_ID = PO.SITE_ID
				   LEFT JOIN #tmp_CellAssy_INFO CA1
						  ON CA1.DIVISION_ID	= PO.DIVISION_ID
						 AND CA1.ITEM_ID_PROD	= PO.ITEM_ID
						 AND CA1.PLANT_ID		= FS.PLANT_ID
						 AND CA1.PRIORITY_1ST	= 1 
				   LEFT JOIN #tmp_CellAssy_INFO CA2
						  ON CA2.DIVISION_ID	= PO.DIVISION_ID
						 AND CA2.ITEM_ID_PROD	= PO.ITEM_ID
						 AND CA2.PRIORITY_2ND	= 1 
				   LEFT JOIN #tmp_CellAssy_INFO CA3
						  ON CA3.ITEM_ID_PROD	= PO.ITEM_ID
						 AND CA3.PRIORITY_3RD	= 1 
            WHERE PO.DIVISION_ID           = @P_DIVISION_ID        
              AND PO.PLAN_START_YYYYMMDD   = @P_PLAN_START_YYYYMMDD 
              AND PO.PLAN_TYPE             = @P_PLAN_TYPE             
              AND PO.SEQ                   = @P_SEQ                   
              AND PO.YYYYMMDD              = PLAN_START_YYYYMMDD
              AND PO.STOCK_TYPE            NOT IN ( 'ASSM','FOR_STOCKPLAN','FORMING','FORMED','CHARING')   --셀 특성완료이전 제외  
		 GROUP BY  PO.DIVISION_ID
				  ,PO.PLAN_START_YYYYMMDD
				  ,PO.PLAN_TYPE 
				  ,PO.SEQ
				  ,PO.SITE_ID
				  ,CASE WHEN FS.OPERATION_GROUP = 'A' AND FS.SITE_TYPE = 'PLANT'
							 AND FS.OSP_YN = 'N'
				             AND (CA1.ITEM_ID_ASSY IS NOT NULL OR 
								  CA2.ITEM_ID_ASSY IS NOT NULL OR 
								  CA3.ITEM_ID_ASSY IS NOT NULL)
						THEN ISNULL(ISNULL(CA1.ITEM_ID_ASSY, CA2.ITEM_ID_ASSY), CA3.ITEM_ID_ASSY)
						ELSE PO.ITEM_ID
					END				
		/* 2023.06.26 변경전 소스
            select DIVISION_ID      
                 ,PLAN_START_YYYYMMDD      
                 ,PLAN_TYPE      
                 ,SEQ      
                 ,SITE_ID      
                 ,ITEM_ID     
                 ,SUM(ISNULL(PSI_BOH_QTY,0)) as     PSI_BOH_QTY    
             FROM SCP_PLN_PLANT_ONHAND WITH(NOLOCK)        
            WHERE DIVISION_ID               = @P_DIVISION_ID           
              AND PLAN_START_YYYYMMDD       = @P_PLAN_START_YYYYMMDD   
              AND PLAN_TYPE                 = @P_PLAN_TYPE             
              AND SEQ                       = @P_SEQ                   
              AND YYYYMMDD                  = @P_PLAN_START_YYYYMMDD   
              AND STOCK_TYPE                NOT IN ( 'ASSM','FOR_STOCKPLAN','FORMING','FORMED','CHARING')   --셀 특성완료이전 제외     
            GROUP by DIVISION_ID      
                    ,PLAN_START_YYYYMMDD      
                    ,PLAN_TYPE      
                    ,SEQ      
                    ,SITE_ID      
                    ,ITEM_ID  
				*/
            ) X

-- PI 에서 더 이상 진행하지 않으므로 주석처리
		 -- -- 변경후
			--SELECT -- 전진검사 BOH 추가후 중복방지
			--		DIVISION_ID
			--	   ,PLAN_START_YYYYMMDD
			--	   ,PLAN_TYPE
			--	   ,SEQ
			--	   ,SITE_ID
			--	   ,ITEM_ID
			--	   ,SUM(PSI_BOH_QTY) AS PSI_BOH_QTY
			--  FROM (SELECT DIVISION_ID      
			--			 ,PLAN_START_YYYYMMDD      
			--			 ,PLAN_TYPE      
			--			 ,SEQ      
			--			 ,SITE_ID      
			--			 ,ITEM_ID      
			--			 ,PSI_BOH_QTY       
			--		 FROM SCP_PLN_SALES_ONHAND  WITH (NOLOCK)        
			--		WHERE 0 = 0  
			--		  and division_id               = @P_DIVISION_ID               
			--		  and plan_start_yyyymmdd       = @P_PLAN_START_YYYYMMDD       
			--		  and plan_type                 = @P_PLAN_TYPE                 
			--		  and seq                       = @P_SEQ                       
			--		  and yyyymmdd                  = @P_PLAN_START_YYYYMMDD           
			--	  -------------------------------------------------------------------------------------------------------------                                    
			--	  -- 9.2 -- SCP_PLN_PLANT_ONHAND BOH 임시테이블 추출
			--	  ------------------------------------------------------------------------------------------------------------- 
			--	  UNION
			--		select DIVISION_ID      
			--			 ,PLAN_START_YYYYMMDD      
			--			 ,PLAN_TYPE      
			--			 ,SEQ      
			--			 ,SITE_ID      
			--			 ,ITEM_ID     
			--			 ,SUM(ISNULL(PSI_BOH_QTY,0)) as     PSI_BOH_QTY    
			--		 FROM SCP_PLN_PLANT_ONHAND WITH(NOLOCK)        
			--		WHERE DIVISION_ID               = @P_DIVISION_ID           
			--		  AND PLAN_START_YYYYMMDD       = @P_PLAN_START_YYYYMMDD   
			--		  AND PLAN_TYPE                 = @P_PLAN_TYPE             
			--		  AND SEQ                       = @P_SEQ                   
			--		  AND YYYYMMDD                  = @P_PLAN_START_YYYYMMDD   
			--		  AND STOCK_TYPE                NOT IN ( 'ASSM','FOR_STOCKPLAN','FORMING','FORMED','CHARING')   --셀 특성완료이전 제외     
			--		GROUP by DIVISION_ID      
			--				,PLAN_START_YYYYMMDD      
			--				,PLAN_TYPE      
			--				,SEQ      
			--				,SITE_ID      
			--				,ITEM_ID  

			--	  -- 전진검사 BOH 추가 -- 2021.11.03 - ENG_STOCK_PLAN
			--	  UNION
			--		select @P_DIVISION_ID AS DIVISION_ID      
			--			 ,@P_PLAN_START_YYYYMMDD AS PLAN_START_YYYYMMDD      
			--			 ,@P_PLAN_TYPE AS PLAN_TYPE      
			--			 ,@P_SEQ AS SEQ      
			--			 ,SUBSTRING(SITE_ID,1,(CASE WHEN CHARINDEX('~', SITE_ID) = 0  THEN LEN(SITE_ID) ELSE CHARINDEX('~', SITE_ID)  -1 END)) AS SITE_ID
			--			 ,ITEM_ID     
			--			 ,SUM(ISNULL(QTY,0)) as     PSI_BOH_QTY    
			--		 FROM SCP_PLN_TH_ENG_STOCK_PLAN WITH(NOLOCK)        
			--		WHERE MASTER_ID                 = @p_master_id           
			--		  AND PLAN_ID                   = @p_engine_plan_id   
			--		  AND (ISNULL(INSP_TYPE, '') IN ('INSP_COM', 'INSP_PRE', 'INSP_HOLD') OR DESCR LIKE '%HOLD')
			--		  AND RECEIVING_DTTM <= @v_pet_date		-- 플랜구간만
			--		GROUP by SUBSTRING(SITE_ID,1,(CASE WHEN CHARINDEX('~', SITE_ID) = 0  THEN LEN(SITE_ID) ELSE CHARINDEX('~', SITE_ID)  -1 END))      
			--				,ITEM_ID  
			--				, DESCR
			--			 , INSP_TYPE
 		--	       ) A
			--GROUP BY DIVISION_ID
			--	   ,PLAN_START_YYYYMMDD
			--	   ,PLAN_TYPE
			--	   ,SEQ
			--	   ,SITE_ID
			--	   ,ITEM_ID
   --         ) X
		 -- -- 전진검사 BOH 추가 -- 2021.11.03 - END


          -------------------------------------------------------------------------------------------------------------                                              
          -- 9.3  WH_IN_BALANCE 기준 정보 추출
          --      WH_IN_BALANCE 입력(to site기준의 BOH + 특정일자까지 누적 Fcst qty * (-1) + 특정일자까지 누적 WH_IN total 누적수량 )            
          -------------------------------------------------------------------------------------------------------------        

           SELECT   DISTINCT              
                     DIVISION_ID                        
                    ,PLAN_START_YYYYMMDD                        
                    ,PLAN_TYPE                        
                    ,SEQ                
                    ,OPERATION_GROUP            
                    ,ITEM_ID      
                    ,CELL_ITEM_ID                  
                    ,TO_SITE                        
                    ,INCOTERMS AS INCOTERMS              
                    ,YYYYMMDD   
                    ,TO_BOH_QTY      
                    ,FROM_BOH_QTY
                    ,MIN(FROM_SITE) AS FROM_SITE
              INTO #Y  
              FROM #tmp_SCP_ANL_PSI_GLOBAL WITH(NOLOCK)               
              WHERE 1=1               
                AND MEASURE            IN ('MKT_FCST','WH_IN')      
                AND ATTRIBUTE1 <> 'WH_IN'   
                GROUP BY              
                   DIVISION_ID                        
                  ,PLAN_START_YYYYMMDD                        
                  ,PLAN_TYPE                        
                  ,SEQ         
                  ,OPERATION_GROUP               
                  ,ITEM_ID              
                  ,CELL_ITEM_ID                        
                  ,TO_SITE                        
                  ,INCOTERMS              
                  ,YYYYMMDD       
                  ,TO_BOH_QTY      
                  ,FROM_BOH_QTY   


                INSERT INTO #tmp_SCP_ANL_PSI_GLOBAL                    
                        (                        
                          DIVISION_ID             
                        ,PLAN_START_YYYYMMDD     
                        ,PLAN_TYPE               
                        ,SEQ                     
                        ,OPERATION_GROUP         
                        ,ITEM_ID                 
                        ,CELL_ITEM_ID 
                        ,TO_SITE                 
                        ,TO_BOH_QTY              
                        ,INCOTERMS               
                        ,FROM_SITE               
                        ,FROM_BOH_QTY        
                        ,BOD_ID                  
                        ,TRANSPORT_MODE_LINE 
                        ,MEASURE                 
                        ,YYYYMMDD                
                        ,QTY          
                        ,ATTRIBUTE1                 
                          )    

                  SELECT                  
                         Y.DIVISION_ID             
                        ,Y.PLAN_START_YYYYMMDD     
                        ,Y.PLAN_TYPE               
                        ,Y.SEQ                     
                        ,Y.OPERATION_GROUP         
                        ,Y.ITEM_ID                 
                        ,Y.CELL_ITEM_ID 
                        ,Y.TO_SITE                 
                        ,Y.TO_BOH_QTY              
                        ,Y.INCOTERMS           
                        ,Y.FROM_SITE              
                        ,Y.FROM_BOH_QTY        
                        ,'-' AS BOD_ID                   
                        ,NULL AS  TRANSPORT_MODE_LINE 
                        ,'WH_IN_BALANCE' AS MEASURE                 
                        ,Y.YYYYMMDD                
                        ,( SELECT              
                                ISNULL( SUM(CASE MEASURE WHEN 'MKT_FCST'  THEN -1 * ISNULL(QTY,0)              
                                                         WHEN 'WH_IN'     THEN      ISNULL(QTY,0)              
                                                  ELSE 0.0              
                                      END),0)   AS QTY 
                            FROM #tmp_SCP_ANL_PSI_GLOBAL X WITH(NOLOCK)               
                          WHERE 1=1              
                            AND X.DIVISION_ID          = Y.DIVISION_ID              
                            AND X.PLAN_START_YYYYMMDD  = Y.PLAN_START_YYYYMMDD                       
                            AND X.PLAN_TYPE            = Y.PLAN_TYPE              
                            AND X.SEQ                  = Y.SEQ              
                            AND X.ITEM_ID              = Y.ITEM_ID              
--                            AND X.CELL_ITEM_ID         = Y.CELL_ITEM_ID              
                            AND X.TO_SITE              = Y.TO_SITE 
--                            AND X.FROM_SITE            = Y.FROM_SITE              
                            AND X.INCOTERMS            = Y.INCOTERMS              
                            AND X.MEASURE              IN ('MKT_FCST','WH_IN')              
                            AND X.YYYYMMDD             <= Y.YYYYMMDD              
                          )  + ISNULL(BOH.PSI_BOH_QTY,0) AS PSI_BOH_QTY       
                      ,   NULL AS  ATTRIBUTE1   
                    FROM #Y AS Y WITH (NOLOCK)       
                    LEFT OUTER JOIN #BOH AS BOH WITH (NOLOCK)   
                                ON Y.DIVISION_ID          = BOH.DIVISION_ID      
                                AND Y.PLAN_START_YYYYMMDD  = BOH.PLAN_START_YYYYMMDD      
                                AND Y.PLAN_TYPE            = BOH.PLAN_TYPE      
                                AND Y.SEQ                  = BOH.SEQ      
                                AND Y.TO_SITE              = BOH.SITE_ID      
                                AND Y.ITEM_ID              = BOH.ITEM_ID      
                  WHERE 1=1 ;    
          -------------------------------------------------------------------------------------------------------------                                              
          -- 9.4  FROM_BOH_QTY,TO_BOH_QTY 계산
          ------------------------------------------------------------------------------------------------------------- 
               UPDATE X
               SET X.FROM_BOH_QTY = ISNULL(BOH.PSI_BOH_QTY,0)
               FROM #tmp_SCP_ANL_PSI_GLOBAL X WITH (NOLOCK)
               LEFT OUTER JOIN #BOH AS BOH WITH (NOLOCK)   
                ON 0 = 0
                AND X.DIVISION_ID          = BOH.DIVISION_ID      
                AND X.PLAN_START_YYYYMMDD  = BOH.PLAN_START_YYYYMMDD      
                AND X.PLAN_TYPE            = BOH.PLAN_TYPE      
                AND X.SEQ                  = BOH.SEQ      
                AND X.FROM_SITE            = BOH.SITE_ID      
                AND X.ITEM_ID              = BOH.ITEM_ID    

               UPDATE X
               SET X.TO_BOH_QTY = ISNULL(BOH.PSI_BOH_QTY,0)
               FROM #tmp_SCP_ANL_PSI_GLOBAL X WITH (NOLOCK)
               LEFT OUTER JOIN #BOH AS BOH WITH (NOLOCK)   
                ON 0 = 0
                AND X.DIVISION_ID          = BOH.DIVISION_ID      
                AND X.PLAN_START_YYYYMMDD  = BOH.PLAN_START_YYYYMMDD      
                AND X.PLAN_TYPE            = BOH.PLAN_TYPE      
                AND X.SEQ                  = BOH.SEQ      
                AND X.TO_SITE              = BOH.SITE_ID      
                AND X.ITEM_ID              = BOH.ITEM_ID    

          -------------------------------------------------------------------------------------------------------------                                         
          -- 9.5  CELL_ITEM_ID UPDATE
          ------------------------------------------------------------------------------------------------------------- 
                -- PACK 일경우 
                -- E20260331-000738 82사업부 MA Plan 수행 시 속도지연 주석처리
                /*
                UPDATE X
                   SET CELL_ITEM_ID      = ( SELECT TOP 1 CHILD_ITEM_ID
                                               FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V AS Y WITH (NOLOCK)
                                              WHERE Y.DIVISION_ID        = X.DIVISION_ID
                                                AND Y.MODEL_ID           = X.ITEM_ID
												AND Y.CELL_TYPE			 = 'CP'		-- 2023.06.08 활성화코드 분리 대응(Cell Product 조건 추가)
                                                AND Y.OPERATION_GROUP_ID = 'A')
                FROM #tmp_SCP_ANL_PSI_GLOBAL X
                 WHERE OPERATION_GROUP   = 'P'
                 ;
                */
                -- E20260331-000738 82사업부 MA Plan 수행 시 속도지연 개선로직 시작
                ;
                with model_child_item_id as
                (
                        SELECT Y.DIVISION_ID , MODEL_ID , MIN(CHILD_ITEM_ID) AS CHILD_ITEM_ID
                        FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V AS Y WITH (NOLOCK)
					    WHERE Y.DIVISION_ID = @p_division_id
					    AND Y.CELL_TYPE			 = 'CP'		-- 활성화코드 분리 대응(CELL PRODUCT 조건 추가) :: 2023.06.15 , KSK
					    AND Y.OPERATION_GROUP_ID = 'A'
					    GROUP BY Y.DIVISION_ID , MODEL_ID
                )
				UPDATE X
					SET X.CELL_ITEM_ID      = Y.CHILD_ITEM_ID
				FROM #tmp_SCP_ANL_PSI_GLOBAL X
					JOIN model_child_item_id AS Y 
					ON Y.DIVISION_ID        = X.DIVISION_ID
					AND Y.MODEL_ID           = X.ITEM_ID
                WHERE OPERATION_GROUP   = 'P';
                -- E20260331-000738 82사업부 MA Plan 수행 시 속도지연 개선로직 끝


                 -- CELL 일경우 -- 2023.06.08 활성화코드 분리 대응 - 변경후 쿼리 
				;WITH CP_INFO AS (
					SELECT M.DIVISION_ID
						  ,M.PLANT_ID
						  ,M.ITEM_ID_ASSY
						  ,M.ITEM_ID_PROD
						  ,ROW_NUMBER() OVER (PARTITION BY M.DIVISION_ID
														  ,M.ITEM_ID_ASSY
														  ,M.PLANT_ID
												  ORDER BY M.VALID_YN DESC 
														  ,M.ITEM_ID_PROD) PRIORITY_1ST
						  ,ROW_NUMBER() OVER (PARTITION BY M.DIVISION_ID
														  ,M.ITEM_ID_ASSY
												  ORDER BY M.VALID_YN DESC 
														  ,M.ITEM_ID_PROD) PRIORITY_2ND
						  ,ROW_NUMBER() OVER (PARTITION BY M.ITEM_ID_ASSY
												  ORDER BY M.VALID_YN DESC 
														  ,M.ITEM_ID_PROD) PRIORITY_3RD
					 FROM SCP_MST_CELL_PROD_ASSY_MAP M WITH(NOLOCK)
					WHERE 1=1
					  AND M.VALID_YN = 'Y' -- 2023/7/25 추가
				)
				 UPDATE X
					SET X.CELL_ITEM_ID      = CASE WHEN F.CELL_TYPE LIKE 'CA%'
												   THEN ISNULL(ISNULL(ISNULL(C1.ITEM_ID_PROD, C2.ITEM_ID_PROD),C3.ITEM_ID_PROD), X.ITEM_ID)
												   ELSE X.ITEM_ID
											  END 
				  FROM #tmp_SCP_ANL_PSI_GLOBAL X WITH (NOLOCK)
					   INNER JOIN SCP_MST_FINAL_ITEM_V F WITH(NOLOCK)  
							   ON 1=1
							  AND F.ITEM_ID			= X.ITEM_ID
					   LEFT  JOIN SCM_MST_SITE FS WITH(NOLOCK)
							   ON FS.DIVISION_ID = X.DIVISION_ID
							  AND FS.SCM_SITE_ID = X.FROM_SITE
							  AND FS.SITE_TYPE   = 'PLANT'
					   LEFT  JOIN CP_INFO C1
							   ON C1.DIVISION_ID	= X.DIVISION_ID
							  AND C1.PLANT_ID		= FS.PLANT_ID
							  AND C1.ITEM_ID_ASSY	= X.ITEM_ID
							  AND C1.PRIORITY_1ST	= 1
					   LEFT  JOIN CP_INFO C2
							   ON C2.DIVISION_ID	= X.DIVISION_ID
							  AND C2.ITEM_ID_ASSY	= X.ITEM_ID
							  AND C2.PRIORITY_2ND	= 1
					   LEFT  JOIN CP_INFO C3
							   ON C3.ITEM_ID_ASSY	= X.ITEM_ID
							  AND C3.PRIORITY_3RD	= 1
				 WHERE 0 = 0
				   AND X.OPERATION_GROUP   = 'A'

			  /* begin  2023.06.08 활성화코드 분리 대응 - 변경전 소스 주석 처리 
               -- CELL 일경우 
                UPDATE X
                  SET X.CELL_ITEM_ID      = X.ITEM_ID
                  FROM #tmp_SCP_ANL_PSI_GLOBAL X WITH (NOLOCK)
                  WHERE 0 = 0
                    AND X.OPERATION_GROUP   = 'A'
				end  2023.06.08 활성화코드 분리 대응 - 변경전 소스 주석 처리 */

			----------------------------------------------------
			-- PJ20214997 LGES SCP 신규 Biz, 공정 추가에 따른 모델링 개선 - MEB biz. 적용 - CELL_ITEM_ID update - start
			----------------------------------------------------
			UPDATE X
               SET X.CELL_ITEM_ID = Z.CELL_ITEM_ID
              FROM #tmp_SCP_ANL_PSI_GLOBAL X WITH (NOLOCK)
			INNER JOIN (SELECT distinct z.model_id as item_id, z.child_item_id as cell_item_id, z.accumulated_child_qty as cell_qty_pack, y.module_id, y.module_qty_pack
						  FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V z WITH(NOLOCK),
							   ( SELECT x.DIVISION_ID, x.model_id, x.child_item_id as module_id, x.child_qty as module_qty_pack
								   FROM dbo.scm_mst_bom_sn_V x WITH(NOLOCK)	--2021-03-09	SCP 대치 BOM 적용
										INNER JOIN dbo.scm_mst_item_sn i WITH(NOLOCK)
										ON  x.child_division_id = i.division_id
										AND x.child_item_id     = i.item_id
										AND I.FLOW_ID = 'P5200'
										AND x.child_company_id  = i.company_id -- A002 빈강 추가 따른 조건 추가
										AND x.child_site_id     = i.site_id
										AND i.active_flag       = 'Y'        
										AND x.DIVISION_ID       = @p_division_id --  CSR E20250829-001508 실행계획개선 (속도개선)
								  WHERE 1=1
								) Y
						 WHERE z.DIVISION_ID        = Y.DIVISION_ID
							AND z.MODEL_ID           = Y.model_id
							AND z.CELL_TYPE			 = 'CP' -- 2023.06.08 활성화코드 분리 대응(Cell Product 조건 추가)
							AND z.OPERATION_GROUP_ID = 'A'
							AND z.DIVISION_ID       = @p_division_id --  CSR E20250829-001508 실행계획개선 (속도개선)
					   ) Z
				 ON X.ITEM_ID    = Z.MODULE_ID
			  WHERE X.ATTRIBUTE9 = 'P5200'
			;
			-- PJ20214997 LGES SCP 신규 Biz, 공정 추가에 따른 모델링 개선 - MEB biz. 적용 - CELL_ITEM_ID update - end
                          
          -------------------------------------------------------------------------------------------------------------                            
          -- 10. 'MKT_FCST'로 / RTF(ALLOCATION) / Balance 0 채워 넣기
          ------------------------------------------------------------------------------------------------------------- 
                                                   
            INSERT INTO #tmp_SCP_ANL_PSI_GLOBAL
               (
               DIVISION_ID             
               ,PLAN_START_YYYYMMDD     
               ,PLAN_TYPE               

               ,SEQ                     
               ,OPERATION_GROUP         
               ,ITEM_ID                
               ,CELL_ITEM_ID             
               ,TO_SITE                 
               ,TO_BOH_QTY              
               ,INCOTERMS               
               ,FROM_SITE               
               ,FROM_BOH_QTY            
               ,BOD_ID                  
               ,MEASURE                 
               ,YYYYMMDD                
               ,QTY                     
               ,TRANSPORT_MODE_LINE          
               ,ATTRIBUTE1              
               )
             
               SELECT DIVISION_ID             
                     ,PLAN_START_YYYYMMDD     
                     ,PLAN_TYPE               
                     ,SEQ                     
                     ,OPERATION_GROUP         
                     ,ITEM_ID      
                     ,CELL_ITEM_ID                     
                     ,TO_SITE                 
                     ,TO_BOH_QTY              
                     ,INCOTERMS               
                     ,FROM_SITE               
                     ,FROM_BOH_QTY            
                     ,BOD_ID                  
                     ,'ALLOCATION' AS MEASURE                 
                     ,YYYYMMDD                
                     ,0 as QTY               
                     ,TRANSPORT_MODE_LINE          
                     ,'0'  AS ATTRIBUTE1              
               FROM #tmp_SCP_ANL_PSI_GLOBAL WITH (NOLOCK) 
              WHERE 1=1      
               AND ATTRIBUTE1   = 'SCP_ANL_SHIPMENT_PLAN_SEMI'
               AND MEASURE      = 'MKT_FCST'
               AND TO_SITE      <> '-' -- 생산제외
              UNION ALL
                SELECT DIVISION_ID             
                     ,PLAN_START_YYYYMMDD     
                     ,PLAN_TYPE               
                     ,SEQ                     
                     ,OPERATION_GROUP         
                     ,ITEM_ID      
                     ,CELL_ITEM_ID                     
                     ,TO_SITE                 
                     ,TO_BOH_QTY              
                     ,INCOTERMS               
                     ,FROM_SITE               
                     ,FROM_BOH_QTY            
                     ,BOD_ID                  
                     ,'BALANCE' AS MEASURE                 
                     ,YYYYMMDD                
                     ,0 as QTY                     
                     ,TRANSPORT_MODE_LINE          
                     ,'0' AS ATTRIBUTE1              
               FROM #tmp_SCP_ANL_PSI_GLOBAL WITH (NOLOCK) 
              WHERE 1=1      
               AND ATTRIBUTE1   = 'SCP_ANL_SHIPMENT_PLAN_SEMI'
               AND MEASURE      = 'MKT_FCST'
               AND TO_SITE      <> '-' -- 생산제외
             UNION ALL
                SELECT DIVISION_ID             
                     ,PLAN_START_YYYYMMDD     
                     ,PLAN_TYPE               
                     ,SEQ                     
                     ,OPERATION_GROUP         
                     ,ITEM_ID      
                     ,CELL_ITEM_ID                     
                     ,TO_SITE                 
                     ,TO_BOH_QTY              
                     ,INCOTERMS               
                     ,FROM_SITE               
                     ,FROM_BOH_QTY            
                     ,BOD_ID                  
                     ,'WH_IN_BALANCE' AS MEASURE                 
                     ,YYYYMMDD                
                     ,0 as QTY                     
                     ,TRANSPORT_MODE_LINE          
                     ,NULL AS ATTRIBUTE1              
               FROM #tmp_SCP_ANL_PSI_GLOBAL WITH (NOLOCK) 
              WHERE 1=1      
               AND ATTRIBUTE1   = 'SCP_ANL_SHIPMENT_PLAN_SEMI'
               AND MEASURE      = 'MKT_FCST'
               AND TO_SITE      <> '-' -- 생산제외


          -------------------------------------------------------------------------------------------------------------                                       
          -- 11. TRANSPORT_MODE_LINE UPDATE
          -------------------------------------------------------------------------------------------------------------  
          -- TRANSPORT_MODE
          -- PJ20209643 (20210716) : scp_mst_bod_v에서 scp_mst_bod_n_v로 변경
            UPDATE X
               SET X.TRANSPORT_MODE_LINE = Y.TRANSPORT_MODE
              FROM #tmp_SCP_ANL_PSI_GLOBAL X WITH (NOLOCK)
              INNER JOIN scp_mst_bod_n_v Y WITH (NOLOCK)
               ON 0 = 0
              AND X.DIVISION_ID  = Y.DIVISION_ID 
              AND X.BOD_ID       = Y.BOD_ID 
              AND X.FROM_SITE    = Y.FROM_SITE	 
              AND X.MEASURE      <> 'PRODUCTION'
              AND X.BOD_ID       <> '-'
          

            DELETE FROM #tmp_SCP_ANL_PSI_GLOBAL WHERE  MEASURE IN ('MKT_FCST','ALLOCATION','BALANCE','WH_IN_BALANCE') AND TO_SITE ='-'  -- 생산제외

          -------------------------------------------------------------------------------------------------------------                     
          -- 12. DIO 생성    
          -------------------------------------------------------------------------------------------------------------          
          -------------------------------------------------------------------------------------------------------------                 
          -- 12.1. DIO 임시 테이블 생성          GROUPING 확인, CELL_ITEM_ID
          -------------------------------------------------------------------------------------------------------------                 
          IF OBJECT_ID('tempdb..#tmp_SCP_ANL_PSI_GLOBAL_DIO') IS NOT NULL                
              DROP TABLE #tmp_SCP_ANL_PSI_GLOBAL_DIO                
                
            CREATE TABLE #tmp_SCP_ANL_PSI_GLOBAL_DIO                
            (           
              DIVISION_ID   NVARCHAR(10) NOT NULL,             
              FROM_SITE     NVARCHAR(50) NOT NULL,          
              ITEM_ID       NVARCHAR(50) NOT NULL, 
              CELL_ITEM_ID  NVARCHAR(50) NULL,          
              YYYYMMDD      NVARCHAR(8)  NOT NULL,     
              FROM_BOH_QTY  NUMERIC(30,10),          
              TO_BOH_QTY    NUMERIC(30,10),               
              OUT_QTY       NUMERIC(30,10),          
              FORMATION_QTY NUMERIC(30,10),    
              EOH_QTY       NUMERIC(30,10),                        
              INV_DAY       NUMERIC(30,10)                 
            );                
                
          
            INSERT INTO #tmp_SCP_ANL_PSI_GLOBAL_DIO          
            (   DIVISION_ID           
               ,FROM_SITE             
               ,ITEM_ID       
               ,CELL_ITEM_ID        
               ,YYYYMMDD     
               ,FROM_BOH_QTY     
               ,TO_BOH_QTY    
               ,OUT_QTY               
               ,FORMATION_QTY
               ,EOH_QTY  
               ,INV_DAY               
             )          
            SELECT DIVISION_ID          
                   ,ISNULL(FROM_SITE,'') AS FROM_SITE
                   ,ITEM_ID        
                   ,CELL_ITEM_ID  
                   ,YYYYMMDD          
                   ,MAX(FROM_BOH_QTY) AS FROM_BOH_QTY     
                   ,MAX(TO_BOH_QTY) AS TO_BOH_QTY    
                   ,SUM((CASE MEASURE WHEN 'SHIP_PLAN'          THEN ROUND(P.QTY,1) ELSE 0 END )) AS OUT_QTY          
                   ,SUM((CASE MEASURE WHEN 'ACTIVATE_PROGRESS'  THEN ROUND(P.QTY,1) ELSE 0 END)) AS FORMATION_QTY         
                   ,SUM((CASE MEASURE WHEN 'MODEL_INVENTORY'    THEN ROUND(P.QTY,1) ELSE 0 END)) AS EOH_QTY          
                   , 0          
              FROM #tmp_SCP_ANL_PSI_GLOBAL P WITH(NOLOCK)          
             WHERE 1=1          
             AND ATTRIBUTE1 <> 'CELL' 
             AND FROM_SITE <> '-' 
            GROUP BY  DIVISION_ID, FROM_SITE,ITEM_ID,CELL_ITEM_ID,YYYYMMDD
            ORDER BY  DIVISION_ID, FROM_SITE,ITEM_ID,CELL_ITEM_ID,YYYYMMDD
            ;
            
            --SELECT * FROM #tmp_SCP_ANL_PSI_GLOBAL  WITH (NOLOCK) WHERE ITEM_ID ='APRSAKANG-A1'  AND YYYYMMDD ='20190114'
            --SELECT * FROM #tmp_SCP_ANL_PSI_GLOBAL_DIO WITH (NOLOCK) WHERE ITEM_ID ='APRSAKANG-A1'  AND YYYYMMDD ='20190114'
            --return;
          /*  
          -- DIO 보정로직 추가
          DELETE FROM #tmp_SCP_ANL_PSI_GLOBAL_DIO
--        SELECT X.FROM_SITE , X.ITEM_ID , X.CELL_ITEM_ID  
               FROM #tmp_SCP_ANL_PSI_GLOBAL_DIO X 
                 JOIN (
                        SELECT FROM_SITE          
                              ,ITEM_ID       
                              ,CELL_ITEM_ID   
                          FROM #tmp_SCP_ANL_PSI_GLOBAL_DIO  WITH(NOLOCK)          
                          WHERE 1=1          
                          GROUP BY FROM_SITE,ITEM_ID,CELL_ITEM_ID--,YYYYMMDD     
                          HAVING 0 = 0
                          AND FROM_SITE <> '-'
                          AND SUM(EOH_QTY)  = 0
                          AND SUM(FORMATION_QTY) = 0 
                    ) Y 
              ON 0 = 0
              AND X.FROM_SITE     = Y.FROM_SITE
              AND X.ITEM_ID       = Y.ITEM_ID
              AND X.CELL_ITEM_ID  = Y.CELL_ITEM_ID             
          */      
         -------------------------------------------------------------------------------------------------------------           
         -- 12.2. DIO 누적합계와 전일누적합계를  생성         #Tbl_DIO                                                                                                 
         -------------------------------------------------------------------------------------------------------------           
         SELECT  YYYYMMDD          
                ,FROM_SITE          
                ,ITEM_ID 
                ,CELL_ITEM_ID   
                ,FROM_BOH_QTY     
                ,TO_BOH_QTY       
                ,OUT_QTY          
                ,FORMATION_QTY          
                ,EOH_QTY   
                ,OUT_QTY_SUM        
                ,LAG((CASE WHEN OUT_QTY_SUM < 0 THEN 0 ELSE OUT_QTY_SUM END),1,0) OVER (PARTITION BY FROM_SITE,ITEM_ID,CELL_ITEM_ID ORDER BY YYYYMMDD) LAG_OUT_QTY_SUM  -- 전일 누적합계          
          INTO #Tbl_DIO      
          FROM (          
                         
                SELECT FROM_SITE          
                      ,ITEM_ID    
                      ,CELL_ITEM_ID      
                      ,YYYYMMDD         
                       ,MAX(FROM_BOH_QTY) AS FROM_BOH_QTY     
                       ,MAX(TO_BOH_QTY) AS TO_BOH_QTY 
                      ,SUM((CASE WHEN OUT_QTY < 0 THEN 0 ELSE OUT_QTY END)) AS OUT_QTY          
                      ,SUM((CASE WHEN FORMATION_QTY < 0 THEN 0 ELSE FORMATION_QTY END)) AS FORMATION_QTY    
                      ,SUM((CASE WHEN EOH_QTY < 0 THEN 0 ELSE EOH_QTY END)) AS EOH_QTY          
                      ,ROUND(SUM((CASE WHEN OUT_QTY < 0 THEN 0 ELSE OUT_QTY END)) OVER(PARTITION BY FROM_SITE,ITEM_ID ORDER BY FROM_SITE,ITEM_ID,CELL_ITEM_ID,YYYYMMDD),2) AS OUT_QTY_SUM  -- 누적합계          
                FROM (          
                       -- FROM_SITE,ITEM_ID,YYYYMMDD 기준으로 중복이 존재 ?          
                        SELECT FROM_SITE          
                              ,ITEM_ID       
                              ,CELL_ITEM_ID   
                              ,YYYYMMDD         
                              ,MAX(FROM_BOH_QTY) AS FROM_BOH_QTY     
                              ,MAX(TO_BOH_QTY) AS TO_BOH_QTY     
                              ,SUM(OUT_QTY) AS OUT_QTY           
                              ,SUM(FORMATION_QTY) AS FORMATION_QTY          
                              ,SUM(EOH_QTY) AS EOH_QTY          
                         from #tmp_SCP_ANL_PSI_GLOBAL_DIO P WITH(NOLOCK)          
                         WHERE 1=1          
                         GROUP BY FROM_SITE,ITEM_ID,CELL_ITEM_ID,YYYYMMDD          
                   ) SUB          
                  GROUP BY FROM_SITE          
                          ,ITEM_ID 
                          ,CELL_ITEM_ID         
                          ,YYYYMMDD          
                          ,SUB.OUT_QTY          
                          ,SUB.FORMATION_QTY
                          ,SUB.EOH_QTY        
                ) AA          
          
         -------------------------------------------------------------------------------------------------------------           
         -- 12.3.구하고자 하는 재고일수의 일자를 기준으로 이후 일자의 OUT값의 누적값중 현재 재고값보다 최초로 큰값을 구함.          
         --                                   A. (OUT_QTY_SUM + EOH_QTY) 값과 X.OUT_QTY_SUM 비교          
         -------------------------------------------------------------------------------------------------------------          
          
          SELECT @p_division_id AS DIVISION_ID          
                ,YYYYMMDD            
                ,FROM_SITE           
                ,ITEM_ID 
                ,CELL_ITEM_ID     
                ,FROM_BOH_QTY     
                ,TO_BOH_QTY      
                ,OUT_QTY          
                ,EOH_QTY          
                ,OUT_QTY_SUM          
                , (SELECT TOP 1 YYYYMMDD           
                     FROM #Tbl_DIO X WITH (NOLOCK)          
                    WHERE X.FROM_SITE = A.FROM_SITE           
                      AND X.ITEM_ID   = A.ITEM_ID   
                      AND X.CELL_ITEM_ID   = A.CELL_ITEM_ID            
                      AND X.YYYYMMDD  > A.YYYYMMDD           
                      AND (A.OUT_QTY_SUM  + A.EOH_QTY + A.FORMATION_QTY ) <= X.OUT_QTY_SUM           
                    ) AS INV_YYYYMMDD          
          
                 ,(CASE WHEN EOH_QTY = 0.0 AND FORMATION_QTY = 0.0 THEN 0.0           
                       ELSE           
                            ISNULL((DATEDIFF(DD
                                            ,CONVERT(DATETIME,A.YYYYMMDD ,112)
                                            ,CONVERT(DATETIME,((SELECT TOP 1 YYYYMMDD           
                                                                 FROM #Tbl_DIO X  WITH (NOLOCK)          
                                                                WHERE X.FROM_SITE = A.FROM_SITE           
                                                                   AND X.ITEM_ID   = A.ITEM_ID   
                                                                   AND X.CELL_ITEM_ID   = A.CELL_ITEM_ID            
                                                                   AND X.YYYYMMDD  > A.YYYYMMDD           
                                                                   AND (A.OUT_QTY_SUM  + A.EOH_QTY + A.FORMATION_QTY ) <= X.OUT_QTY_SUM           
                                                                )),112))),999)          
                       END) AS DD          
            INTO #Tbl_SCP_ANL_PSI_GLOBAL_DIO          
            FROM #Tbl_DIO A WITH (NOLOCK)            

         -------------------------------------------------------------------------------------------------------------         
         -- 12.4. #tmp_SCP_ANL_PSI_PRODUCTION 입력          
         --       'I'   AS PSI_TYPE                             
         --       'DIO' AS PSI_VALUE                                           
         --       ROUND(DD-1) + (OUT_QTY/TOT_QTY),2)          
         --       SET @V_INV_DAY = ROUND( (@V_DAY-1) + (@C_EOH_QTY / @V_QTY) , 2)  -- QTY             
         -------------------------------------------------------------------------------------------------------------                   

             INSERT INTO  #tmp_SCP_ANL_PSI_GLOBAL                 
                          ( DIVISION_ID                
                           ,PLAN_START_YYYYMMDD                
                           ,PLAN_TYPE                
                           ,SEQ                
                           ,OPERATION_GROUP                
                           ,ITEM_ID     
                           ,CELL_ITEM_ID   -- 
                           ,TO_SITE     
                           ,TO_BOH_QTY
                           ,INCOTERMS
                           ,FROM_SITE         
                           ,FROM_BOH_QTY
                           ,BOD_ID
                           ,MEASURE                 
                           ,YYYYMMDD                
                           ,QTY                     
                           ,TRANSPORT_MODE_LINE          
                           ,ATTRIBUTE1  
                           )       
                
                 SELECT  @P_DIVISION_ID                          
                        ,@P_PLAN_START_YYYYMMDD                  
                        ,@P_PLAN_TYPE                            
                        ,@P_SEQ                                  
                        ,Y.OPERATION_GROUP        
                        ,X.ITEM_ID           
                        ,X.CELL_ITEM_ID AS CELL_ITEM_ID   
                        ,'-'  AS TO_SITE   
                        ,TO_BOH_QTY       
                        ,'-' AS INCOTERMS
                        ,X.FROM_SITE         
                        ,FROM_BOH_QTY
                        ,NULL AS BOD_ID
                        ,'DIO' AS MEASURE                 
                        ,X.YYYYMMDD                
                        , (CASE WHEN X.DD = 0 THEN 0 ELSE X.DD END) AS QTY                       
                        ,'-' AS TRANSPORT_MODE_LINE          
                        ,'DIO' AS ATTRIBUTE1   
                  FROM #Tbl_SCP_ANL_PSI_GLOBAL_DIO X WITH(NOLOCK)                
                  INNER JOIN SCP_MST_FINAL_ITEM_V Y WITH (NOLOCK)                
                          ON 0 = 0            
                         AND X.ITEM_ID      = Y.ITEM_ID  
    --                     AND X.CELL_ITEM_ID      = Y.CELL_ITEM_ID           
                 WHERE 1 = 1                
                 AND FROM_SITE <>'-'  
                 ;          
                
          -------------------------------------------------------------------------------------------------------------                                       
          -- 13. 보정(UI 정렬 조건, 공정코드)
          ------------------------------------------------------------------------------------------------------------- 
              UPDATE X
              SET X.ATTRIBUTE9 = SUBSTRING(Y.FLOW_ID,1,5)
              FROM #tmp_SCP_ANL_PSI_GLOBAL X WITH (NOLOCK)
				   -- PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 대응
				   INNER JOIN SCM_MST_DIVISION D WITH(NOLOCK)
						   ON D.DIVISION_ID = X.DIVISION_ID
						  AND D.ATTRIBUTE3 = '81' 
						  AND D.VALID_YN   = 'Y'
              INNER JOIN SCP_MST_FINAL_ITEM  Y WITH (NOLOCK)
              ON 0 = 0
              AND X.ITEM_ID   = Y.ITEM_ID
              --AND '81'        = Y.DIVISION_ID   -- Global은 81만
			  --2023.03.29 AND Y.DIVISION_ID IN ('81', '81_UC')	--2022.03.23	KSW			GM JV 반영 :: 81_UC  추가
			  ;


             UPDATE X
                SET X.ATTRIBUTE9 = Y.PLANT_ID
               FROM #tmp_SCP_ANL_PSI_GLOBAL X WITH (NOLOCK)
              INNER JOIN SCM_MST_SITE Y WITH(NOLOCK)
              ON 0 = 0
              AND Y.DIVISION_ID = X.DIVISION_ID
              AND Y.SCM_SITE_ID = X.FROM_SITE
              AND Y.OSP_YN      = 'Y'


              -- BALANCE, WH_IN_BALANCE 를 '0'으로 UPDATE
              SELECT S.SCM_SITE_ID
               INTO #SCM_SITE_ID
               FROM SCM_MST_SITE S WITH (NOLOCK)
				   -- PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 대응
				   INNER JOIN SCM_MST_DIVISION D WITH(NOLOCK)
						   ON D.DIVISION_ID = S.DIVISION_ID
						  AND D.ATTRIBUTE3	= '81' 
						  AND D.VALID_YN	= 'Y'
              WHERE S.SITE_TYPE   ='PLANT'
                AND S.OSP_YN      ='N'           -- 외주제외
                --AND DIVISION_ID ='81'     -- Global은 81만
				--2023.03.29 AND DIVISION_ID IN ('81', '81_UC')	--2022.03.23	KSW			GM JV 반영 :: 81_UC  추가
				;

              UPDATE X
                SET X.QTY = 0
                FROM #tmp_SCP_ANL_PSI_GLOBAL X WITH (NOLOCK)
                WHERE 0 = 0
                  AND MEASURE           IN ('BALANCE','WH_IN_BALANCE')
                  AND TO_SITE           IN (SELECT SCM_SITE_ID FROM #SCM_SITE_ID WITH (NOLOCK))
                  AND FROM_SITE         IN (SELECT SCM_SITE_ID FROM #SCM_SITE_ID WITH (NOLOCK))
                  AND OPERATION_GROUP   ='A'
                  AND QTY > 0.0

             UPDATE X
                SET X.ATTRIBUTE10     = '1'
                FROM #tmp_SCP_ANL_PSI_GLOBAL X WITH (NOLOCK)
               WHERE 0 = 0
                AND X.OPERATION_GROUP = 'P'

            UPDATE X
                SET X.ATTRIBUTE10     = '3'
                FROM #tmp_SCP_ANL_PSI_GLOBAL X WITH (NOLOCK)
               WHERE 0 = 0
                AND X.OPERATION_GROUP = 'A'
                AND X.ATTRIBUTE10     IS NULL
--                AND X.ATTRIBUTE10     <> '2'

            -- FROM_BOH_QTY를 TO_BOH_QTY로 
            /*
            UPDATE X
                SET X.TO_BOH_QTY = X.FROM_BOH_QTY
                FROM #tmp_SCP_ANL_PSI_GLOBAL X WITH (NOLOCK)
               WHERE 0 = 0
                AND X.ATTRIBUTE1  ='CELL'

            UPDATE X
                SET X.FROM_BOH_QTY = 0
                FROM #tmp_SCP_ANL_PSI_GLOBAL X WITH (NOLOCK)
               WHERE 0 = 0
                AND X.ATTRIBUTE1  ='CELL'
            */

          -------------------------------------------------------------------------------------------------------------                                       
          --  SCP_ANL_PSI_GLOBAL 삭제                         
          -------------------------------------------------------------------------------------------------------------         
          /*
          ALLOCATION  	0
          BALANCE	      0
          MKT_FCST	    SCP_ANL_SHIPMENT_PLAN_SEMI
          WH_IN_BALANCE	NULL
          */     

            DELETE FROM  #tmp_SCP_ANL_PSI_GLOBAL  WHERE 0 = 0 AND  ATTRIBUTE1   = '0'                                                       -- ALLOCATION / BALANCE
            DELETE FROM  #tmp_SCP_ANL_PSI_GLOBAL  WHERE 0 = 0 AND  ATTRIBUTE1   = 'SCP_ANL_SHIPMENT_PLAN_SEMI'  AND MEASURE ='MKT_FCST'     -- MKT_FCST
             DELETE A FROM #tmp_SCP_ANL_PSI_GLOBAL A  WITH (NOLOCK)
               INNER JOIN SCM_MST_SITE B WITH (NOLOCK)
                       ON B.SCM_SITE_ID = A.TO_SITE
                      AND A.DIVISION_ID = B.DIVISION_ID
                      AND B.OSP_YN = 'Y'
                    WHERE 0 = 0
                     AND A.ATTRIBUTE10  = '3'                           
                     AND MEASURE ='WH_IN_BALANCE'
        ;


		-------------------------------------------------------------------------------------------------------------                                       
        -- PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : 활성화코드 분리 대응
		-- 2023.06.29 Cell Product 생산관련 measure 전구간 0인 데이터 삭제     
		-- 2023년 7월은 국내만, 8월부터 전체 법인
        -------------------------------------------------------------------------------------------------------------  
        IF OBJECT_ID('tempdb..#tmp_TARGET_TO_DELETE') IS NOT NULL
           DROP TABLE #tmp_TARGET_TO_DELETE  ;

		SELECT PG.DIVISION_ID
			 , PG.PLAN_START_YYYYMMDD
			 , PG.PLAN_TYPE
			 , PG.SEQ
			 , PG.OPERATION_GROUP
			 , PG.ITEM_ID
			 , PG.CELL_ITEM_ID
			 , PG.TO_SITE
			 , PG.INCOTERMS
			 , PG.FROM_SITE
			 , PG.BOD_ID
			 , PG.TRANSPORT_MODE_LINE
			 , PG.MEASURE 
			 , ISNULL(SUM(PG.QTY),0)			AS TOTAL_QTY
			 , COUNT(DISTINCT ISNULL(PG.QTY,0))	AS QTY_CNT 
		INTO #tmp_TARGET_TO_DELETE
		FROM #tmp_SCP_ANL_PSI_GLOBAL  PG WITH(NOLOCK)   
			 INNER JOIN SCM_MST_SITE FS WITH(NOLOCK)
					 ON FS.DIVISION_ID		= PG.DIVISION_ID
					AND FS.SCM_SITE_ID		= PG.FROM_SITE 
					AND FS.OPERATION_GROUP	= 'A'		-- Cell 창고 
					AND FS.OSP_YN			= 'N'		-- 외주 제외 
			 INNER JOIN SCP_MST_FINAL_ITEM FI WITH(NOLOCK)
					 on FI.DIVISION_ID		= PG.DIVISION_ID
					AND FI.ITEM_ID			= PG.ITEM_ID 
					AND FI.ATTRIBUTE8		= 'CP'		-- Cell Product 
		WHERE 1=1
		  AND PG.DIVISION_ID			= @p_division_id               
		  AND PG.PLAN_START_YYYYMMDD	= @p_plan_start_yyyymmdd       
		  AND PG.PLAN_TYPE				= @p_plan_type                 
		  AND PG.SEQ					= @p_seq          
		  AND PG.OPERATION_GROUP		= 'A' -- Cell  품목 
		  AND (ISNULL(PG.TO_SITE,'-') = '-' OR RTRIM(PG.TO_SITE) = '') 
		  AND PG.MEASURE in ( 'PRODUCTION', 'ACTIVATE_COMPLETED', 'CHAR_AVAILABLE', 'ACTIVATE_PROGRESS' ,'MODEL_INVENTORY' ,'DIO') -- 생산관련 measure 
		  AND EXISTS (SELECT TOP 1 M.ITEM_ID_PROD
						FROM SCP_MST_CELL_PROD_ASSY_MAP M with(nolock)
					   WHERE 1=1
					     AND M.VALID_YN = 'Y' -- 2023/7/26 추가
						 AND M.ITEM_ID_PROD = PG.ITEM_ID)  -- Cell Assy 매핑정보가 존재하는 Cell Product 
		GROUP BY  PG.DIVISION_ID
				, PG.PLAN_START_YYYYMMDD
				, PG.PLAN_TYPE
				, PG.SEQ
				, PG.OPERATION_GROUP
				, PG.ITEM_ID
				, PG.CELL_ITEM_ID
				, PG.TO_SITE
				, PG.INCOTERMS
				, PG.FROM_SITE
				, PG.BOD_ID
				, PG.TRANSPORT_MODE_LINE
				, PG.MEASURE  
		HAVING ISNULL(SUM(PG.QTY),0)			= 0
		   AND COUNT(DISTINCT ISNULL(PG.QTY,0)) = 1 
		   ;

		   DELETE TGT
		    FROM  #tmp_SCP_ANL_PSI_GLOBAL  AS TGT
		   WHERE 1=1
		     AND (ISNULL(TGT.TO_SITE,'-') = '-' OR RTRIM(TGT.TO_SITE) = '')
		     AND EXISTS (SELECT 1
						  FROM #tmp_TARGET_TO_DELETE D
						 WHERE 1=1
						   AND D.DIVISION_ID			= TGT.DIVISION_ID
						   AND D.PLAN_START_YYYYMMDD	= TGT.PLAN_START_YYYYMMDD
						   AND D.PLAN_TYPE				= TGT.PLAN_TYPE
						   AND D.SEQ					= TGT.SEQ
						   AND D.OPERATION_GROUP		= TGT.OPERATION_GROUP
						   AND D.ITEM_ID				= TGT.ITEM_ID
						   AND D.FROM_SITE				= TGT.FROM_SITE
						   AND D.MEASURE				= TGT.MEASURE
						   AND ISNULL(D.CELL_ITEM_ID		,'') = ISNULL(TGT.CELL_ITEM_ID			,'') 
						   AND ISNULL(D.INCOTERMS			,'') = ISNULL(TGT.INCOTERMS			    ,'') 
						   AND ISNULL(D.BOD_ID				,'') = ISNULL(TGT.BOD_ID				,'') 
						   AND ISNULL(D.TRANSPORT_MODE_LINE	,'') = ISNULL(TGT.TRANSPORT_MODE_LINE	,'') 
						   )

		-------------------------------------------------------------------------------------------------------------                                       
        -- 14. PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 : SAFETY_STOCK measure 추가                   
        -------------------------------------------------------------------------------------------------------------  
        IF OBJECT_ID('tempdb..#SAFETY_STOCK_TGT') IS NOT NULL
           DROP TABLE #SAFETY_STOCK_TGT  ;

		WITH DAYS_SAFETY_STOCK AS (
			-- DIVISION/SALES SITE/ITEM별 안전재고일수
			SELECT MS.SCM_SITE_ID					AS SALES_SITE_ID
				  ,LD.SEGMENT3						AS ITEM_ID
				  ,CONVERT(INT, MAX(LD.SEGMENT4))	AS DAYS
				  ,MAX(LD.SEGMENT4)					AS DAYS_NVAR
			 FROM SCM_MST_SITE MS WITH(NOLOCK)
				  INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LD WITH(NOLOCK)
						  ON LD.LOOKUP_TYPE =  'DAYS_SAFETY_STOCK'
						 AND LD.SEGMENT1	= MS.DIVISION_ID
						 AND LD.SEGMENT2	= MS.SCM_SITE_ID
						 AND ISNUMERIC(LD.SEGMENT4) = 1
						 AND LD.VALID_YN	= 'Y'
			WHERE MS.SITE_TYPE = 'SALES'
			  AND MS.VALID_YN	 = 'Y'
			  AND MS.VMI_YN		 = 'Y'
			  AND MS.DIVISION_ID = @p_division_id
			GROUP BY MS.SCM_SITE_ID
					,LD.SEGMENT3
			HAVING CONVERT(INT, MAX(LD.SEGMENT4)) > 0 
		)
		SELECT A.DIVISION_ID             
              ,A.PLAN_START_YYYYMMDD     
              ,A.PLAN_TYPE               
              ,A.SEQ                     
              ,A.OPERATION_GROUP         
              ,A.ITEM_ID     
              ,A.CELL_ITEM_ID              
              ,A.TO_SITE                 
              ,A.TO_BOH_QTY              
              ,ISNULL(A.INCOTERMS, '-')				AS INCOTERMS
              ,ISNULL(A.FROM_SITE,'')				AS FROM_SITE               
              ,A.FROM_BOH_QTY            
              ,ISNULL(A.BOD_ID,'-')					AS BOD_ID                  
              ,ISNULL(A.TRANSPORT_MODE_LINE,'-')	AS TRANSPORT_MODE_LINE
              ,A.YYYYMMDD 
			  ,A.ATTRIBUTE1
			  ,A.ATTRIBUTE9
			  ,A.ATTRIBUTE10
			  ,DSS.DAYS
			  ,DSS.DAYS_NVAR
			  ,CONVERT(NVARCHAR(10), DATEADD(DAY,		 1, CONVERT(DATE, YYYYMMDD)), 112) AS FROM_YMD
			  ,CONVERT(NVARCHAR(10), DATEADD(DAY, DSS.DAYS, CONVERT(DATE, YYYYMMDD)), 112) AS TO_YMD
              ,ISNULL(A.QTY, 0)															   AS QTY    
		  INTO #SAFETY_STOCK_TGT
          FROM #tmp_SCP_ANL_PSI_GLOBAL  A WITH (NOLOCK)  
		       INNER JOIN DAYS_SAFETY_STOCK   DSS
					   ON DSS.SALES_SITE_ID = A.TO_SITE
					  AND DSS.ITEM_ID		= A.ITEM_ID
         WHERE 1=1     
		   AND A.YYYYMMDD < @v_pet_date     
		   AND A.CELL_ITEM_ID IS NOT NULL   
           AND A.MEASURE = 'MKT_FCST'
		;

		INSERT INTO #tmp_SCP_ANL_PSI_GLOBAL
                          ( DIVISION_ID                
                           ,PLAN_START_YYYYMMDD                
                           ,PLAN_TYPE                
                           ,SEQ                
                           ,OPERATION_GROUP                
                           ,ITEM_ID     
                           ,CELL_ITEM_ID 
                           ,TO_SITE     
                           ,TO_BOH_QTY
                           ,INCOTERMS
                           ,FROM_SITE         
                           ,FROM_BOH_QTY
                           ,BOD_ID
                           ,TRANSPORT_MODE_LINE          
                           ,MEASURE                 
                           ,YYYYMMDD                
                           ,QTY 
						   ,ATTRIBUTE1
						   ,ATTRIBUTE2
						   ,ATTRIBUTE9
						   ,ATTRIBUTE10
                           )       
		SELECT S.DIVISION_ID
			  ,S.PLAN_START_YYYYMMDD
			  ,S.PLAN_TYPE
			  ,S.SEQ
			  ,S.OPERATION_GROUP
			  ,S.ITEM_ID
			  ,S.CELL_ITEM_ID
			  ,S.TO_SITE
			  ,S.TO_BOH_QTY
			  ,S.INCOTERMS
			  ,S.FROM_SITE
			  ,S.FROM_BOH_QTY
			  ,S.BOD_ID
			  ,S.TRANSPORT_MODE_LINE
			  ,'SAFETY_STOCK'									AS MEASURE
			  ,S.YYYYMMDD
			  ,ISNULL(SUM(T.QTY), 0)							AS QTY
			  ,MAX(S.ATTRIBUTE1)								AS ATTRIBUTE1
			  ,MAX(S.DAYS_NVAR + '::'+S.FROM_YMD+'::'+S.TO_YMD) AS ATTRIBUTE2 
			  ,MAX(S.ATTRIBUTE9)								AS ATTRIBUTE9
			  ,MAX(S.ATTRIBUTE10)								AS ATTRIBUTE10
		 FROM #SAFETY_STOCK_TGT S  WITH(NOLOCK)
			  LEFT JOIN #SAFETY_STOCK_TGT T WITH(NOLOCK)
					 ON T.DIVISION_ID		  = S.DIVISION_ID
					AND T.PLAN_START_YYYYMMDD = S.PLAN_START_YYYYMMDD
					AND T.PLAN_TYPE			  = S.PLAN_TYPE
					AND T.SEQ				  = S.SEQ
					AND T.OPERATION_GROUP	  = S.OPERATION_GROUP
					AND T.ITEM_ID			  = S.ITEM_ID
					AND T.CELL_ITEM_ID		  = S.CELL_ITEM_ID
					AND T.TO_SITE			  = S.TO_SITE
					AND T.INCOTERMS			  = S.INCOTERMS
					AND T.FROM_SITE			  = S.FROM_SITE
					AND T.BOD_ID			  = S.BOD_ID
					AND T.TRANSPORT_MODE_LINE = S.TRANSPORT_MODE_LINE
					AND T.QTY > 0
					AND T.YYYYMMDD  BETWEEN S.FROM_YMD AND S.TO_YMD
		WHERE 1=1
		GROUP BY S.DIVISION_ID
				,S.PLAN_START_YYYYMMDD
				,S.PLAN_TYPE
				,S.SEQ
				,S.OPERATION_GROUP
				,S.ITEM_ID
				,S.CELL_ITEM_ID
				,S.TO_SITE
				,S.TO_BOH_QTY
				,S.INCOTERMS
				,S.FROM_SITE
				,S.FROM_BOH_QTY
				,S.BOD_ID
				,S.TRANSPORT_MODE_LINE
				,S.YYYYMMDD
				;

          -------------------------------------------------------------------------------------------------------------                                       
          -- 15. SCP_ANL_PSI_GLOBAL 삭제                         
          -------------------------------------------------------------------------------------------------------------              
            --DELETE FROM SCP_ANL_PSI_GLOBAL                            
            --WHERE DIVISION_ID = @p_division_id AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd AND PLAN_TYPE = @p_plan_type AND SEQ = @p_seq                        

			-- 2021.11.11 튜닝개선안에 따른 삭제방식 변경
			BEGIN TRAN
				WHILE(1 = 1)
				BEGIN
				  DELETE TOP (10000)
				  FROM dbo.SCP_ANL_PSI_GLOBAL                            
				  WHERE DIVISION_ID = @p_division_id AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd AND PLAN_TYPE = @p_plan_type AND SEQ = @p_seq;

				  IF(@@ROWCOUNT = 0)
				  BEGIN
				   BREAK;
				  END
				END
			COMMIT	
                                  
          -------------------------------------------------------------------------------------------------------------                            
          -- 16. SCP_ANL_PSI_GLOBAL 입력                           
          -------------------------------------------------------------------------------------------------------------                      
		    BEGIN TRAN -- 2021.11.11 튜닝개선안에 따른 추가
            INSERT INTO /* SCP_ANL_PSI_GLOBAL */  dbo.SCP_ANL_PSI_GLOBAL                          
                     (                          
                       DIVISION_ID             
                      ,PLAN_START_YYYYMMDD     
                      ,PLAN_TYPE               
                      ,SEQ                     
                      ,OPERATION_GROUP         
                      ,ITEM_ID    
                      ,CELL_ITEM_ID                
                      ,TO_SITE                 
                      ,TO_BOH_QTY              
                      ,INCOTERMS               
                      ,FROM_SITE               
                      ,FROM_BOH_QTY            
                      ,BOD_ID                  
                      ,TRANSPORT_MODE_LINE            
                      ,MEASURE                 
                      ,YYYYMMDD                
                      ,QTY                     
                      ,CREATED_BY                          
                      ,CREATION_DATE                          
                      ,LAST_UPDATED_BY                          
                      ,LAST_UPDATE_DATE    
                      ,ATTRIBUTE1
					  ,ATTRIBUTE2
                      ,ATTRIBUTE9 
                      ,ATTRIBUTE10             
                       )                          
                    SELECT                
                           DIVISION_ID             
                          ,PLAN_START_YYYYMMDD     
                          ,PLAN_TYPE               
                          ,SEQ                     
                          ,OPERATION_GROUP         
                          ,ITEM_ID     
                          ,CELL_ITEM_ID              
                          ,TO_SITE                 
                          ,TO_BOH_QTY              
                          ,ISNULL(INCOTERMS, '-') 
                          ,ISNULL(FROM_SITE,'') AS FROM_SITE               
                          ,FROM_BOH_QTY            
                          ,ISNULL(BOD_ID,'-')                    
                          ,ISNULL(TRANSPORT_MODE_LINE,'-') 
                          ,MEASURE                 
                          ,YYYYMMDD                
                          ,SUM(ISNULL(QTY,0)) AS QTY                                             
                          ,@v_batch_user AS CREATED_BY                          
                          ,GETDATE()     AS CREATION_DATE                          
                          ,@v_batch_user AS LAST_UPDATED_BY                          
                          ,GETDATE()     AS LAST_UPDATED_BY        
                          ,ATTRIBUTE1 
						  ,ATTRIBUTE2
                          ,ATTRIBUTE9   
                          ,ATTRIBUTE10      
                      FROM #tmp_SCP_ANL_PSI_GLOBAL WITH (NOLOCK)                          
                     WHERE 1=1     
					 
					 -- * 2021.05.10   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 플랜 대응 - start
                     --AND YYYYMMDD < CONVERT(VARCHAR,DATEADD(D,364,CONVERT(DATETIME,@p_plan_start_yyyymmdd,112)),112)     
					 --
					 AND YYYYMMDD < @v_pet_date     
					 -- * 2021.05.10   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 플랜 대응 - end

                     AND CELL_ITEM_ID IS NOT NULL   
                     AND MEASURE <> '-'
                     GROUP BY 
                           DIVISION_ID             
                          ,PLAN_START_YYYYMMDD     
                          ,PLAN_TYPE               
                          ,SEQ                     
                          ,OPERATION_GROUP         
                          ,ITEM_ID    
                          ,CELL_ITEM_ID                 
                          ,TO_SITE                 
                          ,TO_BOH_QTY              
                          ,ISNULL(INCOTERMS, '-')             
                          ,FROM_SITE               
                          ,FROM_BOH_QTY            
                          ,ISNULL(BOD_ID,'-')                  
                          ,ISNULL(TRANSPORT_MODE_LINE,'-')    
                          ,MEASURE                 
                          ,YYYYMMDD              
                          ,ATTRIBUTE1  
						  ,ATTRIBUTE2
                          ,ATTRIBUTE9 
                          ,ATTRIBUTE10
			COMMIT -- 2021.11.11 튜닝개선안에 따른 추가
			;


          -------------------------------------------------------------------------------------------------------------
          -- TEMPDB TABLE DROP
          -------------------------------------------------------------------------------------------------------------                         
          IF OBJECT_ID('tempdb..#tmp_SCP_ANL_PSI_GLOBAL') IS NOT NULL                        
              DROP TABLE #tmp_SCP_ANL_PSI_GLOBAL     

          IF OBJECT_ID('tempdb..#tmp_SCP_ANL_PSI_GLOBAL_DIO') IS NOT NULL                
              DROP TABLE #tmp_SCP_ANL_PSI_GLOBAL_DIO                

        -----------------------------------------------------------                        
        -- 실행 Logic END --                        
        -----------------------------------------------------------                        
        --IF @@TRANCOUNT > 0                        
        --  BEGIN                        
        --    COMMIT TRAN TX_PG;                        
        --  END;      
        
        -----------------------------------------------------------
        -- 임시테이블 삭제
        -----------------------------------------------------------                      
          IF OBJECT_ID('tempdb..#tmp_SCP_ANL_PSI_GLOBAL') IS NOT NULL
              DROP TABLE #tmp_SCP_ANL_PSI_GLOBAL

          IF OBJECT_ID('tempdb..#tmp_SCP_ANL_PSI_GLOBAL_DIO') IS NOT NULL
              DROP TABLE #tmp_SCP_ANL_PSI_GLOBAL_DIO

          IF OBJECT_ID('tempdb..#INT') IS NOT NULL
              DROP TABLE #INT

          IF OBJECT_ID('tempdb..#BOH') IS NOT NULL
              DROP TABLE #BOH

          IF OBJECT_ID('tempdb..#Y') IS NOT NULL
              DROP TABLE #Y

          IF OBJECT_ID('tempdb..#Tbl_DIO') IS NOT NULL
              DROP TABLE #Tbl_DIO

          IF OBJECT_ID('tempdb..#SCM_SITE_ID') IS NOT NULL
              DROP TABLE #SCM_SITE_ID  
                        
          IF OBJECT_ID('tempdb..#SAFETY_STOCK_TGT') IS NOT NULL
              DROP TABLE #SAFETY_STOCK_TGT  
                        
          IF OBJECT_ID('tempdb..#tgt_CELL_PRODUCT_MODEL_INVENTORY') IS NOT NULL -- 2023.06.20 활성화코드 분리 대응
              DROP TABLE #tgt_CELL_PRODUCT_MODEL_INVENTORY  
		  IF OBJECT_ID('tempdb..#tmp_TARGET_TO_DELETE') IS NOT NULL
			  DROP TABLE #tmp_TARGET_TO_DELETE  ;
		  IF OBJECT_ID('TEMPDB..#tmp_CellAssy_INFO') IS NOT NULL 
			  DROP TABLE #tmp_CellAssy_INFO;

        -- TXN LOG                        
        SET @v_log_type     = N'TXN';          
        SET @n_log_count    = @@ROWCOUNT;                        
        SET @v_log_message  = N'INSERT INTO '+@v_table_id;                        
        SET @v_description  = N'Process Complete...' + ':' + CONVERT(CHAR(8), @d_event_date, 112);                        
        SET @d_event_date   = SYSDATETIME();                        
                        
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
      --    ROLLBACK TRAN TX_PG                        
      --  END;                        
                              
      -- ERROR LOG                        
      SET @v_log_type     = N'ERROR';                        
      SET @v_log_message  = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));                        
      SET @v_description  = @v_program_name + N'ERROR_LINE : ' + STR(ERROR_LINE());                        
      SET @d_event_date   = SYSDATETIME();                        
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
    SET @v_log_type     = N'END';                        
    SET @v_log_message  = N'########## END of procedure ##########';                        
    SET @v_description  = N'['+@p_master_id+']['+@p_engine_plan_id+'][' + @v_exec_time + ']';                  
    SET @d_event_date   =  SYSDATETIME()  ;                        

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

  

  
