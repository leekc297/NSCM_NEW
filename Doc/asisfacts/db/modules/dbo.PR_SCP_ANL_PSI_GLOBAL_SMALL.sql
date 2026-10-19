                             
                             
/*                      
 * Program ID   : PR_SCP_ANL_PSI_GLOBAL_SMALL                        
 * Description  : PR_SCP_ANL_CREATE_DATA 에서 호출함.                      
 * OutTable     :                      
 * Execute      : 
                 DELETE FROM SCM_SYS_LOG_BATCH WHERE PROGRAM_NAME ='PR_SCP_ANL_PSI_GLOBAL_SMALL' AND CREATED_BY = 'KTH' 
                  
                 EXEC PR_SCP_ANL_PSI_GLOBAL_SMALL
                   @p_plan_cycle          = 'WEEKLY'
                 , @p_plan_start_yyyymmdd = '20181112'
                 , @p_plan_id             = '1052'
                 , @p_modeling_id         = '1'
                 , @p_seq                 = '1'
                 , @p_plan_type           = 'PR'
                 , @p_master_id           = '40::WEEKLY'
                 , @p_division_id         = '40'
                 , @p_engine_plan_id      = '1052::PR::1'
                 , @p_user_id             = 'KTH'
 
                 SELECT * FROM SCM_SYS_LOG_BATCH  WITH (NOLOCK)  WHERE PROGRAM_NAME ='PR_SCP_ANL_PSI_GLOBAL_SMALL' AND CREATED_BY = 'KTH'  order by CREATION_DATE desc 
                  
 * Program History                      
 *===================================================================================================                      
 *   Date       In Charge      Description                      
 *===================================================================================================                      
 * 2018.11.26   KTH         Initial Release PJ20170278 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트    
 * 2018.12.05   KTH         ATTRIBUTE9 조건 변경
 * 2018.12.14   KTH         MEASURE 삭제로직 반영
 * 2019.04.19   KTH         ATTRIBUTE2(ACTIVATE_PROGRESS, MODEL_INVENTORY) 추가
 * 2019.06.19   KTH         [CSR ID:4018125] Global PSI(Small) 내 Packer 셀 재고 행 추가 요청 - PACK SITE CELL 재고 'MODEL_INVENTORY' 추가 
 * 2021.03.26   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 :: 0 값 삭제처리 추가
 * 2021.05.10   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 플랜 대응
 * 2021.07.16   sclee.lee   PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) : scp_mst_bod_v에서 scp_mst_bod_n_v로 변경
 * 2021.11.11   sclee.lee   튜닝개선안에 따른 일부 쿼리 변경
 * 2022.03.23	KSW			GM JV 반영 :: 81_UC, EE_UC  추가
 * 2023.03.29	HRK			PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 대응
 * 2023.07.21	HRK			PJ20230691  LGES SCM 역량 강화 위한 SCP 개선과제 이행 : 활성화코드 분리 대응
 *                          ------------------------------------------------
 *							(사내TCO)  CP.TCO  > CA2.TCO > CA1
 *							(사외TCO)  CP.TCO  > CP      > CA1
 *							(일반)     CP      > CA1 
 *                          ------------------------------------------------
 *							* 공통적용 i  :  FROM SITE의 Plant가 Cell Plant인 경우만 해당, Pack창고 Cell 재고는 대상 아님.
 *							* 공통적용 ii :  FROM SITE 외주(osp_yn = 'Y') 제외
 *                          ------------------------------------------------
 *							1. BOH/EOH(Model_Inventory) CA2 또는 CA1으로 통합 합산 적재
 *								  - 사내TCO 모델: CP.TCO -> CA2   
 *								  - 사외TCO 모델: CP     -> CA1  
 *								  - 일반    모델: CP     -> CA1  
 *							2. 사외TCO 모델의 CP를 제외하고 CP(TCO포함) 모델 전구간 0인 데이터 삭제 
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
 * 2023.08.03	HRK			PJ20230692 SCM 역량 강화 위한 SCP 개선과제 이행 Phase2 : 외주TCO 모델 출하정보로 생산정보 강제 생성한 Production 정보 제외
 *							(TCO : 사외 -> 사내 물류창고(P), CP : 사내 Plant -> 사외(P)) 
 *						     구분 방법 : PSI_VALUE값에 line이 아닌 사이트 정보가 있는 데이터
 * 2025.06.26   KIMCD       PJ2024A332 독립적 Planning 체계 및 Master Validation UI 구축
 *                          1. DIO 계산 오류 보완
 *                          2. 재고기준
 *                             1) 공장내 재고 기준으로 Inventroy 구성 - Packer 재고 제외 함
 *                             2) 공장내 재고 중 생산창고/ oWMS Measure구분 하여 표기
 *                          3. Prodtype –FN /PR  2 형태 유지
 *                          4. Sales RTF 기준으로 진행 함
 *
 *                          UI 수정 필요 항목
 *                          1. 조회 조건 버킷은 monthly  / Weekly / daily 유지 
 *                          2. From site 선택 후에는  - Material [ 전체 / 선택 ] 가능 토록 변경 
 *                          3. 조회 구간 52주 , 12개월 표시
 * 2025.09.03   kimcd       PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산  : 
 *                          활성화 후 공정 Cell이 존재하는 경우  Cell 정보를  활성화 후 공정 Cell로 설정
 *                          활성화 후 공정 Cell 수요 정보 추가
 * 2025.09.21   kimcd       PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산  : 
 *                          소형 사업부 신규 공정 반영에 따른 Cell 제품, Cell Assy 정보 형성 과정 보완
 */
                    
CREATE PROCEDURE [dbo].[PR_SCP_ANL_PSI_GLOBAL_SMALL]
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
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SCP_ANL_PSI_GLOBAL_SMALL';                        
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...                        
    DECLARE @n_log_count    INTEGER = 0;                        
    DECLARE @v_log_message  NVARCHAR(1000);                        
    DECLARE @v_description  NVARCHAR(500);            
    DECLARE @v_table_id     NVARCHAR(150) = N'PR_SCP_ANL_PSI_GLOBAL_SMALL';                         
    DECLARE @d_event_date   DATETIME;                        
                        
  -- 시작 LOG                        
    SET @v_log_type     = N'START';                        
    SET @v_log_message  = N'########## Start of procedure ##########';                        
    SET @v_description  = @v_program_name + ':' + N' PR_SCP_ANL_PSI_GLOBAL_SMALL INSERT LOGIC';                        
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

    -- 364 일
    DECLARE @v_DD    NVARCHAR(8) = CONVERT(VARCHAR,DATEADD(D,364,CONVERT(DATETIME,@p_plan_start_yyyymmdd,112)),112)    

	-- * 2021.05.10   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 플랜 대응 - start
	DECLARE @v_pet_date		NVARCHAR(12) = '';

	--  Plan End Date
	SELECT @v_pet_date = p.horizon_end_date
	FROM   dbo.scm_mst_plan p WITH(NOLOCK)
	WHERE  p.division_id = @p_division_id
	AND    p.plan_id     = @p_plan_id ;

	SET @v_DD = CONVERT(VARCHAR(8), DATEADD(DAY, 1, CONVERT(DATETIME, @v_pet_date, 112)), 112);
	-- * 2021.05.10   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 플랜 대응 - end
                        
    BEGIN TRY                        
      BEGIN                        
        --BEGIN TRAN TX_PG                       
          -------------------------------------------------------------------------------------------------------------                         
          -- 0. temp 테이블 생성 : Measure까지 생성후 마지막에 한번에 입력하기 위해서                        
          -------------------------------------------------------------------------------------------------------------                         
          IF OBJECT_ID('tempdb..#tmp_SCP_ANL_PSI_GLOBAL_SMALL') IS NOT NULL                        
              DROP TABLE #tmp_SCP_ANL_PSI_GLOBAL_SMALL

		  IF OBJECT_ID('tempdb..#tmp_SCP_ANL_PSI_GLOBAL_SMALL2') IS NOT NULL
			  DROP TABLE #tmp_SCP_ANL_PSI_GLOBAL_SMALL2
                        
            CREATE TABLE #tmp_SCP_ANL_PSI_GLOBAL_SMALL(                        
              DIVISION_ID             NVARCHAR(30)    NOT NULL,
	            PLAN_START_YYYYMMDD     NVARCHAR(8)     NOT NULL,
	            PLAN_TYPE               NVARCHAR(50)    NOT NULL,
	            SEQ                     BIGINT          NOT NULL,
	            OPERATION_GROUP         NVARCHAR(10)    NOT NULL,
          --	PROJECT_CODE            NVARCHAR(50)    NOT NULL,
	            ITEM_ID                 NVARCHAR(50)    NOT NULL,
              CELL_ITEM_ID            NVARCHAR(150)   NULL,     
	            TO_SITE                 NVARCHAR(30)    NULL,
              TO_BOH_QTY              NUMERIC(20, 10) NULL,     
	            INCOTERMS               NVARCHAR(10)    NULL,
	            FROM_SITE               NVARCHAR(30)    NULL,
              FROM_BOH_QTY            NUMERIC(20, 10) NULL,     
	            BOD_ID                  NVARCHAR(150)   NULL,
	            TRANSPORT_MODE_LINE     NVARCHAR(50)    NULL,         
	            MEASURE                 NVARCHAR(50)    NULL,
	            YYYYMMDD                NVARCHAR(8)     NULL,
	            QTY                     NUMERIC(20, 10) NULL,
--            CELL_QTY_PER_PACK       NUMERIC(20, 10) NULL,     -- cell qty/pack 컬럼 신청해야 함. ( 기존에 유사한 CELL_REQ_QTY_PER_PACK 있음)

              ATTRIBUTE1              NVARCHAR(150)   NULL,     -- 입력 테이블 flag 임시 SCP_ANL_SHIPMENT_PLAN_SEMI / SCP_ANL_PSI_PRODUCTION / SCP_ANL_SHIPMENT_PLAN_FG         
              ATTRIBUTE2              NVARCHAR(150)   NULL,     -- BOH ATTRIBUTE2(ACTIVATE_PROGRESS, MODEL_INVENTORY) 추가 
			  ATTRIBUTE3			  NVARCHAR(150)   NULL,		-- 활성화코드 분리 대응 (CP/CA 통합 합산 적용 구분-검증을 위해)
			  ATTRIBUTE4              NVARCHAR(150)   NULL,     -- 2025.06.26   KIMCD       PJ2024A332 독립적 Planning 체계 및 Master Validation UI 구축
              ATTRIBUTE9              NVARCHAR(150)   NULL,     -- operaton_id 추가
              ATTRIBUTE10             NVARCHAR(150)   NULL,     -- 정렬 추가
            );

            --2021.11.11 튜닝개선안에 따른 쿼리구문 추가                        
			CREATE TABLE #tmp_SCP_ANL_PSI_GLOBAL_SMALL2(                        
			  DIVISION_ID             NVARCHAR(30)    NOT NULL,
				PLAN_START_YYYYMMDD     NVARCHAR(8)     NOT NULL,
				PLAN_TYPE               NVARCHAR(50)    NOT NULL,
				SEQ                     BIGINT          NOT NULL,
				OPERATION_GROUP         NVARCHAR(10)    NOT NULL,
		  --	PROJECT_CODE            NVARCHAR(50)    NOT NULL,
				ITEM_ID                 NVARCHAR(50)    NOT NULL,
			  CELL_ITEM_ID            NVARCHAR(150)   NULL,     
				TO_SITE                 NVARCHAR(30)    NULL,
			  TO_BOH_QTY              NUMERIC(20, 10) NULL,     
				INCOTERMS               NVARCHAR(10)    NULL,
				FROM_SITE               NVARCHAR(30)    NULL,
			  FROM_BOH_QTY            NUMERIC(20, 10) NULL,     
				BOD_ID                  NVARCHAR(150)   NULL,
				TRANSPORT_MODE_LINE     NVARCHAR(50)    NULL,         
				MEASURE                 NVARCHAR(50)    NULL,
				YYYYMMDD                NVARCHAR(8)     NULL,
				QTY                     NUMERIC(20, 10) NULL,
--            CELL_QTY_PER_PACK       NUMERIC(20, 10) NULL,     -- cell qty/pack 컬럼 신청해야 함. ( 기존에 유사한 CELL_REQ_QTY_PER_PACK 있음)

			  ATTRIBUTE1              NVARCHAR(150)   NULL,     -- 입력 테이블 flag 임시 SCP_ANL_SHIPMENT_PLAN_SEMI / SCP_ANL_PSI_PRODUCTION / SCP_ANL_SHIPMENT_PLAN_FG         
			  ATTRIBUTE2              NVARCHAR(150)   NULL,     -- BOH ATTRIBUTE2(ACTIVATE_PROGRESS, MODEL_INVENTORY) 추가 
			  ATTRIBUTE3			  NVARCHAR(150)   NULL,		-- 활성화코드 분리 대응 (CP/CA 통합 합산 적용 구분-검증을 위해)
			  ATTRIBUTE4              NVARCHAR(150)   NULL,     -- 2025.06.26   KIMCD       PJ2024A332 독립적 Planning 체계 및 Master Validation UI 구축
			                                                    -- cell item class name 추가
			  ATTRIBUTE9              NVARCHAR(150)   NULL,     -- operaton_id 추가
			  ATTRIBUTE10             NVARCHAR(150)   NULL,     -- 정렬 추가
			);
           
           
           /*   MEASURE 정리

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
		
                        MODEL_INVENTORY       SCP_ANL_PSI_PRODUCTION	 -- ( 'CHAR', 'A_MOVE_WH','A_OUT_WH')
                            --  1.5.CHAR     : 특성완료 A~002    'CHAR'     /CATEGORY/QTY  : AND B.OPERATION_GROUP ='A'   AND A.SITE_ID like '%002'     
				       	    --  1.6.A_OUT_WH : 출하창고 A~003    'A_OUT_WH' /CATEGORY/QTY  : AND B.OPERATION_GROUP ='A'   AND A.SITE_ID like '%003'       
    Formation Progress  ACTIVATE_PROGRESS     SCP_ANL_PSI_PRODUCTION	 -- ( 'ASSM','FORMED')
			                --  1.4.ASSM     : ASSM            'ASSM'      /CATEGORY/QTY  : AND B.OPERATION_GROUP ='A'  AND A.SITE_ID like '%-A~***'    
				       	    --  1.8. FORMED              'FORMED'/CATEGORY/SUM(ISNULL(A.QTY,0)) : AND B.OPERATION_GROUP ='A' AND A.SITE_ID like '%A~001'  
                        DIO                   계산(ACTIVATE_PROGRESS+MODEL_INVENTORY - WH_IN) 
    Char. Available     CHAR_AVAILABLE        SCP_ANL_PSI_PRODUCTION	 -- 'FORMED' 특성 가능 수량. EOH
    Char. Completed     ACTIVATE_COMPLETED    SCP_ANL_PSI_PRODUCTION	 -- F6000 공정으로 구분. 셀 특성완료 생산계획=F6000 생산계획
	
		
              PRODUCTION            로직
      */
       
          -------------------------------------------------------------------------------------------------------------                                             
          -- 0.1 CALENDAR 생성 (속도 계선)
          -------------------------------------------------------------------------------------------------------------                           
          SELECT C.BASIS_YYYYMMDD AS YYYYMMDD
            INTO #YYYYMMDD
            FROM SCM_SYS_CALENDAR_M    C WITH(NOLOCK)         
          WHERE 1=1      
            AND C.BASIS_YYYYMMDD >= @p_plan_start_yyyymmdd       
            AND C.BASIS_YYYYMMDD <  @v_DD    
                                    
          -------------------------------------------------------------------------------------------------------------                                             
          -- 1. SEMI 입력   TO SITE TRANSPORT_MODE
          -------------------------------------------------------------------------------------------------------------                           
            INSERT INTO #tmp_SCP_ANL_PSI_GLOBAL_SMALL
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
            INSERT INTO #tmp_SCP_ANL_PSI_GLOBAL_SMALL
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
--                      ,A.TO_SITE                 
                      ,(CASE  WHEN A.PSI_TYPE ='P' THEN '' ELSE  A.TO_SITE  END) AS TO_SITE
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
        --                      ,A.TO_SITE                 
                              ,(CASE  WHEN A.PSI_TYPE ='P' THEN '' ELSE  A.TO_SITE  END) 
                              ,A.FROM_SITE            
                              ,(CASE  WHEN A.PSI_TYPE ='P' THEN  A.PSI_VALUE ELSE NULL END )       
                              ,(CASE  WHEN A.PSI_TYPE ='P' THEN  'PRODUCTION'
                                      WHEN A.PSI_TYPE ='I' AND A.PSI_VALUE  IN ('ACTIVATE_PROGRESS','CHAR_AVAILABLE','MODEL_INVENTORY','ACTIVATE_COMPLETED') THEN  A.PSI_VALUE 
                                ELSE '-' END )  
                              ,A.YYYYMMDD                
         
          -------------------------------------------------------------------------------------------------------------                                        
          -- 3. FG 입력   FROM SITE TRANSPORT_MODE
          -------------------------------------------------------------------------------------------------------------                           
            INSERT INTO #tmp_SCP_ANL_PSI_GLOBAL_SMALL
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
                       AND A.MEASURE              NOT IN ('SHIP_PLAN_AMEND')
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
                    --,A.QTY                     
--                    ,NULL AS TRANSPORT_MODE_LINE    


          -------------------------------------------------------------------------------------------------------------                                             
          -- PACK SITE CELL 재고 'MODEL_INVENTORY' 추가  
          -- 정렬을 위한 ATTRIBUTE10 ='2' 추가
          -------------------------------------------------------------------------------------------------------------  
          INSERT INTO #tmp_SCP_ANL_PSI_GLOBAL_SMALL
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

          -------------------------------------------------------------------------------------------------------------                                             
          -- 2025.06.26   KIMCD       PJ2024A332 독립적 Planning 체계 및 Master Validation UI 구축
		  -- owms 재고 구분하여 정보 입력 MEASURE 'OWMS_MODEL_INVENTORY' 추가  
          -- 정렬을 위한 ATTRIBUTE10 ='3' 추가
          -------------------------------------------------------------------------------------------------------------  
          INSERT INTO #tmp_SCP_ANL_PSI_GLOBAL_SMALL
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
                ,OPERATION_GROUP
                ,ITEM_ID     
                ,NULL                     AS CELL_ITEM_ID
                ,''                       AS TO_SITE                 
                ,NULL                     AS TO_BOH_QTY              
                ,NULL                     AS INCOTERMS               
                ,SITE_ID                  AS FROM_SITE               
                ,NULL                     AS FROM_BOH_QTY        
                ,'-'                      AS BOD_ID                  
                ,NULL                     AS TRANSPORT_MODE_LINE 
                ,'OWMS_MODEL_INVENTORY'   AS MEASURE           --- OWMS 창고 재고
                ,YYYYMMDD                
                ,SUM(ISNULL(PSI_EOH_QTY,0))  AS PSI_BOH_QTY    
                ,'CELL_WH'                AS ATTRIBUTE1     
                ,'3'                      AS ATTRIBUTE10
           FROM SCP_PLN_PLANT_ONHAND A WITH(NOLOCK)     
          WHERE DIVISION_ID               = @P_DIVISION_ID              
            AND PLAN_START_YYYYMMDD       = @P_PLAN_START_YYYYMMDD      
            AND PLAN_TYPE                 = @P_PLAN_TYPE                
            AND SEQ                       = @P_SEQ                  
            AND OPERATION_GROUP           = 'A'
            AND STOCK_TYPE               IN ('A_MOVE_WH','A_OUT_WH')
          GROUP BY  A.DIVISION_ID             
                   ,A.PLAN_START_YYYYMMDD     
                   ,A.PLAN_TYPE               
                   ,A.SEQ                     
                   ,A.OPERATION_GROUP         
                   ,A.ITEM_ID                 
                   ,A.SITE_ID
                   ,A.YYYYMMDD;

          -------------------------------------------------------------------------------------------------------------                                             
          -- 2025.06.26   KIMCD       PJ2024A332 독립적 Planning 체계 및 Master Validation UI 구축
		  -- 사내 Cell 수량 계산 MEASURE 'INCP_MODEL_INVENTORY' 추가  
          -- 정렬을 위한 ATTRIBUTE10 ='3' 추가
          -------------------------------------------------------------------------------------------------------------  
          INSERT INTO #tmp_SCP_ANL_PSI_GLOBAL_SMALL
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
          SELECT A.DIVISION_ID      
                ,A.PLAN_START_YYYYMMDD      
                ,A.PLAN_TYPE      
                ,A.SEQ      
                ,A.OPERATION_GROUP
                ,A.ITEM_ID     
                ,NULL                     AS CELL_ITEM_ID
                ,''                       AS TO_SITE                 
                ,NULL                     AS TO_BOH_QTY              
                ,NULL                     AS INCOTERMS               
                ,A.FROM_SITE               
                ,NULL                     AS FROM_BOH_QTY        
                ,'-'                      AS BOD_ID                  
                ,NULL                     AS TRANSPORT_MODE_LINE 
                ,'INCP_MODEL_INVENTORY'   AS MEASURE           --- 사내 창고 재고
                ,A.YYYYMMDD                
                ,ISNULL(A.QTY,0) - ISNULL(B.QTY,0) AS QTY    
                ,'CELL_WH'                AS ATTRIBUTE1     
                ,'3'                      AS ATTRIBUTE10
           FROM #tmp_SCP_ANL_PSI_GLOBAL_SMALL A WITH(NOLOCK)     
		        LEFT OUTER JOIN #tmp_SCP_ANL_PSI_GLOBAL_SMALL B WITH(NOLOCK)     
				      ON A.DIVISION_ID         = B.DIVISION_ID
                     AND A.PLAN_START_YYYYMMDD = B.PLAN_START_YYYYMMDD
                     AND A.PLAN_TYPE           = B.PLAN_TYPE
                     AND A.SEQ                 = B.SEQ
                     AND A.OPERATION_GROUP     = B.OPERATION_GROUP
                     AND A.ITEM_ID             = B.ITEM_ID
                     AND A.FROM_SITE           = B.FROM_SITE
                     AND A.YYYYMMDD            = B.YYYYMMDD
				     AND B.MEASURE             = 'OWMS_MODEL_INVENTORY'
				     AND B.ATTRIBUTE1          = 'CELL_WH'
          WHERE A.DIVISION_ID         = @P_DIVISION_ID              
            AND A.PLAN_START_YYYYMMDD = @P_PLAN_START_YYYYMMDD      
            AND A.PLAN_TYPE           = @P_PLAN_TYPE                
            AND A.SEQ                 = @P_SEQ                  
            AND A.OPERATION_GROUP     = 'A'
            AND A.MEASURE             = 'MODEL_INVENTORY'
            AND A.ATTRIBUTE1          = 'SCP_ANL_PSI_PRODUCTION';


			 ---------------------------------------------------------------------------------------------------------------------  
			 -- BEGIN 2023.07.28 활성화코드 분리 대응 -- Cell Product EOH(Model Inventory)를 Cell Assy로 합산 적용 
			 ---------------------------------------------------------------------------------------------------------------------   
			 print  convert(varchar(30), getdate(), 121) + N'### stp1. 활성화코드 분리에 따른 대상 Cell 모델 Parent/Child 추출' 
			 ---------------------------------------------------------------------------------------------------------------------   
			IF OBJECT_ID('TEMPDB..#TMP_CELL_BOM_40') IS NOT NULL
				DROP TABLE #TMP_CELL_BOM_40;
			IF OBJECT_ID('TEMPDB..#TMP_TARGET_TO_CONVERT') IS NOT NULL
				DROP TABLE #TMP_TARGET_TO_CONVERT;

			SELECT B.COMPANY_ID
				  ,B.PLANT_ID
				  ,B.MODEL_ID
				  ,B.PARENT_ITEM_ID
				  ,B.CHILD_ITEM_ID
				  ,B.CONCATENATE_ITEM
				  ,FP.TCO_CELL_YN	AS TCO_CELL_YN_P
				  ,FC.TCO_CELL_YN	AS TCO_CELL_YN_C
				  ,FP.ATTRIBUTE8	AS CELL_TYPE_P
				  ,FC.ATTRIBUTE8	AS CELL_TYPE_C
				  ,FP.FLOW_ID		AS FLOW_ID_P
				  ,FC.FLOW_ID		AS FLOW_ID_C
			 INTO #TMP_CELL_BOM_40
			 FROM SCM_MST_BOM_SN B WITH(NOLOCK)
				  INNER JOIN SCP_MST_FINAL_ITEM FC WITH(NOLOCK)	-- Child
						  ON FC.DIVISION_ID = B.DIVISION_ID
						 AND FC.ITEM_ID		= B.CHILD_ITEM_ID 
						 AND FC.OPERATION_GROUP = 'A' -- Cell 
				  INNER JOIN SCP_MST_FINAL_ITEM FP WITH(NOLOCK)	-- Parent 
						  ON FP.DIVISION_ID = B.DIVISION_ID
						 AND FP.ITEM_ID		= B.PARENT_ITEM_ID 
						 AND FP.OPERATION_GROUP = 'A' -- Cell 
			WHERE 1=1
			  AND B.DIVISION_ID = '40' -- 소형 
			;

			-- 2025.09.21   kimcd       PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산  : 
            --                          소형 사업부 신규 공정 반영에 따른 Cell 제품, Cell Assy 정보 형성 과정 보완
		    INSERT INTO #TMP_CELL_BOM_40
			SELECT B.COMPANY_ID
				  ,B.PLANT_ID
				  ,B.MODEL_ID
				  ,B.MODEL_ID AS PARENT_ITEM_ID
				  ,B.CHILD_ITEM_ID
				  ,B.CONCATENATE_ITEM
				  ,FM.TCO_CELL_YN	AS TCO_CELL_YN_P
				  ,FC.TCO_CELL_YN	AS TCO_CELL_YN_C
				  ,FM.ATTRIBUTE8	AS CELL_TYPE_P
				  ,FC.ATTRIBUTE8	AS CELL_TYPE_C
				  ,FM.FLOW_ID		AS FLOW_ID_P
				  ,FC.FLOW_ID		AS FLOW_ID_C
			 FROM SCM_MST_BOM_SN B WITH(NOLOCK)
				  INNER JOIN SCP_MST_FINAL_ITEM FC WITH(NOLOCK)	-- Child
						  ON FC.DIVISION_ID = B.DIVISION_ID
						 AND FC.ITEM_ID		= B.CHILD_ITEM_ID 
						 AND FC.OPERATION_GROUP = 'A' -- Cell 
				  INNER JOIN SCM_MST_ITEM_SN FP WITH(NOLOCK)	-- Parent
						  ON FP.COMPANY_ID  = B.COMPANY_ID
						 AND FP.DIVISION_ID = B.DIVISION_ID
						 AND FP.SITE_ID     = B.SITE_ID
						 AND FP.ITEM_ID		= B.PARENT_ITEM_ID 
				  INNER JOIN SCM_MST_ITEM_CLASS_M FPC WITH(NOLOCK)	-- Parent Item Class
						  ON FP.ITEM_CLASS  = FPC.CLASS_ID
						 AND FPC.SCP_EXC_YN = 'Y'
				  INNER JOIN SCP_MST_FINAL_ITEM FM WITH(NOLOCK)	-- Model
						  ON FM.DIVISION_ID = B.DIVISION_ID
						 AND FM.ITEM_ID		= B.MODEL_ID 
						 AND FM.OPERATION_GROUP = 'A' -- Cell 
			WHERE 1=1
			  AND B.DIVISION_ID = '40' -- 소형 
			  AND B.PARENT_ITEM_ID != '*'
			  AND NOT EXISTS (SELECT TOP 1 1
			                  FROM   #TMP_CELL_BOM_40 CB
			                  WHERE  CB.COMPANY_ID     = B.COMPANY_ID
				                AND  CB.PLANT_ID       = B.PLANT_ID
				                AND  CB.MODEL_ID       = B.MODEL_ID
				                AND  CB.PARENT_ITEM_ID = B.MODEL_ID
				                AND  CB.CHILD_ITEM_ID  = B.CHILD_ITEM_ID);


			SELECT PLANT_ID
				  ,PARENT_ITEM_ID
				  ,MIN(CHILD_ITEM_ID)  AS CHILD_ITEM_ID
				  ,MIN(TCO_CELL_YN_P)  AS TCO_CELL_YN_P
				  ,MIN(TCO_CELL_YN_C)  AS TCO_CELL_YN_C
				  ,MIN(CELL_TYPE_P  )  AS CELL_TYPE_P  
				  ,MIN(CELL_TYPE_C  )  AS CELL_TYPE_C  
			  INTO #TMP_TARGET_TO_CONVERT
			FROM (
					-- TCO/CP > TCO/CA2
					SELECT DISTINCT 
							PLANT_ID
						  , PARENT_ITEM_ID
						  , CHILD_ITEM_ID
						  , TCO_CELL_YN_P
						  , TCO_CELL_YN_C
						  , CELL_TYPE_P
						  , CELL_TYPE_C
					 FROM #TMP_CELL_BOM_40 B WITH(NOLOCK)
					WHERE 1=1
					  AND TCO_CELL_YN_P = 'Y'
					  AND CELL_TYPE_P   = 'CP'
					  AND TCO_CELL_YN_C = 'Y'
					  AND CELL_TYPE_C   = 'CA2'
					UNION ALL
					-- CP > CA1 
					SELECT DISTINCT 
							PLANT_ID
						  , PARENT_ITEM_ID
						  , CHILD_ITEM_ID
						  , TCO_CELL_YN_P
						  , TCO_CELL_YN_C
						  , CELL_TYPE_P
						  , CELL_TYPE_C
					  FROM #TMP_CELL_BOM_40 B WITH(NOLOCK)
					WHERE 1=1
					  AND TCO_CELL_YN_P = 'N'
					  AND CELL_TYPE_P   = 'CP'
					  AND TCO_CELL_YN_C = 'N'
					  AND CELL_TYPE_C   = 'CA1'
				) AS TG
			WHERE 1=1
			GROUP BY PLANT_ID
					,PARENT_ITEM_ID
		;

         ---------------------------------------------------------------------------------------------------------------------   
		 print  convert(varchar(30), getdate(), 121) + N'### stp2. 대상 Cell Product Model Inventory 데이터 추출' 
		 ---------------------------------------------------------------------------------------------------------------------   
        	IF OBJECT_ID('tempdb..#tgt_CELL_PRODUCT_MODEL_INVENTORY') IS NOT NULL 
				DROP TABLE #tgt_CELL_PRODUCT_MODEL_INVENTORY ;

			SELECT PG.*
				  ,FS.PLANT_ID
				  ,TG.CHILD_ITEM_ID AS CELL_ASSY 
			 INTO #tgt_CELL_PRODUCT_MODEL_INVENTORY  
			 FROM #tmp_SCP_ANL_PSI_GLOBAL_SMALL PG WITH(NOLOCK)
				  INNER JOIN SCM_MST_SITE FS WITH(NOLOCK)		-- 7월은 국내만 적용  
						  ON FS.DIVISION_ID		= PG.DIVISION_ID
						 AND FS.SCM_SITE_ID		= PG.FROM_SITE
						 AND FS.SITE_TYPE		= 'PLANT'
						 AND FS.OPERATION_GROUP = 'A'		-- Cell 창고 (Pack창고 Cell은 대상 아님) 
						 AND FS.OSP_YN			= 'N'		-- OSP제외
				   INNER JOIN #TMP_TARGET_TO_CONVERT TG
						  ON TG.PLANT_ID		= FS.PLANT_ID
						 AND TG.PARENT_ITEM_ID	= PG.ITEM_ID
			WHERE 1=1
			  AND PG.MEASURE				 IN ('INCP_MODEL_INVENTORY', 'MODEL_INVENTORY', 'OWMS_MODEL_INVENTORY') 
          -------------------------------------------------------------------------------------------------------------                                             
          -- 2025.06.26   KIMCD       PJ2024A332 독립적 Planning 체계 및 Master Validation UI 구축
		  -- 'MODEL_INVENTORY'에 'INCP_MODEL_INVENTORY', 'OWMS_MODEL_INVENTORY' 유형 추가
          -------------------------------------------------------------------------------------------------------------  


         ---------------------------------------------------------------------------------------------------------------------   
		 print  convert(varchar(30), getdate(), 121) + N'### stp3. Cell Product Model Inventory 데이터 삭제' 
		 ---------------------------------------------------------------------------------------------------------------------   
			DELETE X 
			 FROM #tmp_SCP_ANL_PSI_GLOBAL_SMALL X WITH(NOLOCK)
			WHERE 1=1
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
							-- NULL 또는 빈문자열 AND TGT.CELL_ITEM_ID			= X.CELL_ITEM_ID
							-- NULL 또는 빈문자열 AND TGT.TO_SITE				= X.TO_SITE
							-- NULL 또는 빈문자열 AND TGT.INCOTERMS				= X.INCOTERMS
							-- NULL 또는 빈문자열 AND TGT.BOD_ID				= X.BOD_ID
							-- NULL 또는 빈문자열 AND TGT.TRANSPORT_MODE_LINE	= X.TRANSPORT_MODE_LINE
						  )
					;
         ---------------------------------------------------------------------------------------------------------------------   
		 print  convert(varchar(30), getdate(), 121) + N'### stp4. Cell Product Model Inventory 대상 데이터 Cell Assy에 합산 적용 (UPDATE / INSERT)' 
         ---------------------------------------------------------------------------------------------------------------------   
			MERGE INTO #tmp_SCP_ANL_PSI_GLOBAL_SMALL AS TGT
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
			 -- NULL 또는 빈문자열 AND TGT.CELL_ITEM_ID			= SRC.CELL_ITEM_ID -- NULL (대상이 아닌 Pack Site 셀을 제외하고 모두 NULL임) 
			 -- NULL 또는 빈문자열 AND TGT.TO_SITE				= SRC.TO_SITE
			 -- NULL 또는 빈문자열 AND TGT.INCOTERMS			= SRC.INCOTERMS
			 -- NULL 또는 빈문자열 AND TGT.BOD_ID				= SRC.BOD_ID
			 -- NULL 또는 빈문자열 AND TGT.TRANSPORT_MODE_LINE	= SRC.TRANSPORT_MODE_LINE
			
			WHEN MATCHED THEN
				 UPDATE SET TGT.QTY				= TGT.QTY			+ SRC.QTY
						   ,TGT.FROM_BOH_QTY	= TGT.FROM_BOH_QTY	+ SRC.FROM_BOH_QTY
						   ,TGT.TO_BOH_QTY		= TGT.TO_BOH_QTY	+ SRC.TO_BOH_QTY
						   ,TGT.ATTRIBUTE3	    = 'UPDATE :: ' + CONVERT (NVARCHAR(40), TGT.QTY) + ' :: ' + CONVERT (NVARCHAR(40), SRC.QTY) 

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
					   ,ATTRIBUTE3
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
					,SRC.ATTRIBUTE2
					,'INSERT' --- SRC.ATTRIBUTE3 
					,SRC.ATTRIBUTE9
					,SRC.ATTRIBUTE10
					)
					;

          ---------------------------------------------------------------------------------------------------------------------  
		  print  convert(varchar(30), getdate(), 121) + N'END Cell Product EOH(Model Inventory)를 Cell Assy로 합산 적용' 
          ---------------------------------------------------------------------------------------------------------------------  
		 -- END 2023.07.28 활성화코드 분리 대응 -- Cell Product EOH(Model Inventory)를 Cell Assy로 합산 적용 
         ---------------------------------------------------------------------------------------------------------------------   

         -------------------------------------------------------------------------------------------------------------                                     
          -- 4. SEMI 추가 로직 : WH_IN
          -------------------------------------------------------------------------------------------------------------   
            INSERT INTO #tmp_SCP_ANL_PSI_GLOBAL_SMALL
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
                        ,MAX(OPERATION_GROUP)                        
                        ,ITEM_ID                        
                        ,NULL AS CELL_ITEM_ID   
                        ,TO_SITE        
                        ,NULL AS TO_BOH_QTY                   
                        ,'-' AS INCOTERMS                        
                        ,FROM_SITE      
                        ,NULL AS FROM_BOH_QTY                   
                        ,'-'   AS BOD_ID                        
                        ,TRANSPORT_MODE_LINE            -- NULL 후 UPDATE ?     
                        ,MEASURE                        
                        ,YYYYMMDD                       
                        ,SUM(QTY)       
                        ,'WH_IN'
                  FROM (      
                        SELECT                          
                              B.DIVISION_ID                        
                             ,B.PLAN_START_YYYYMMDD                      -- plan주의 월요일  ,dbo.FN_GET_BUCKET_YYYYMMDD(0)                         
                             ,B.PLAN_TYPE                        
                             ,B.SEQ                          
                             ,B.OPERATION_GROUP                        
                             ,B.ITEM_ID                        
                             ,NULL AS CELL_ITEM_ID
                             ,B.TO_SITE   
                             ,B.INCOTERMS       
                             ,B.FROM_SITE                        
                             ,B.BOD_ID                         
                             ,NULL AS TRANSPORT_MODE_LINE            -- NULL 후 UPDATE ?
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
                           AND B.SEMI_YN = 'Y'      
                           AND A.INCOTERMS          <> '-'    -- 임시처리 
                           AND B.INCOTERMS          <> '-'    -- 임시처리 
                        WHERE 1 = 1                        
                           AND A.DIVISION_ID         = @p_division_id                       
                           AND A.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd                           
                           AND A.PLAN_TYPE           = @p_plan_type                         
                           AND A.SEQ                 = @p_seq                             
                           AND B.DIVISION_ID         is not null  
                           AND B.INCOTERMS          <> '-'    -- 임시처리
                           AND A.INCOTERMS          <> '-'    -- 임시처리  
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
--                      ,NULL --TRANSPORT_MODE_LINE            -- NULL 후 UPDATE ?                        
                      ;            

             -------------------------------------------------------------------------------------------------------------                                             
             -- 2025.06.26   KIMCD       PJ2024A332 독립적 Planning 체계 및 Master Validation UI 구축
		     -- WH_IN Cell 품목의 DIO 계산 개선을 위해서 Cell 하위 반제품 갱신 수행
             -------------------------------------------------------------------------------------------------------------  
			 UPDATE PG
			 SET    PG.ITEM_ID = TG.CHILD_ITEM_ID
			 FROM #tmp_SCP_ANL_PSI_GLOBAL_SMALL PG WITH(NOLOCK)
				  INNER JOIN SCM_MST_SITE FS WITH(NOLOCK)		-- 7월은 국내만 적용  
						  ON FS.DIVISION_ID		= PG.DIVISION_ID
						 AND FS.SCM_SITE_ID		= PG.FROM_SITE
						 AND FS.SITE_TYPE		= 'PLANT'
						 AND FS.OPERATION_GROUP = 'A'		-- Cell 창고 (Pack창고 Cell은 대상 아님) 
						 AND FS.OSP_YN			= 'N'		-- OSP제외
				   INNER JOIN #TMP_TARGET_TO_CONVERT TG
						  ON TG.PLANT_ID		= FS.PLANT_ID
						 AND TG.PARENT_ITEM_ID	= PG.ITEM_ID
             WHERE PG.ATTRIBUTE1 <> 'CELL' 
			 AND   PG.ATTRIBUTE1 <> 'CELL_WH' 
             AND   PG.FROM_SITE  <> '-' 
             AND   PG.MEASURE     = 'WH_IN'
             AND   PG.OPERATION_GROUP = 'A'
             AND   PG.ATTRIBUTE1 IN  ('SCP_ANL_SHIPMENT_PLAN_FG', 'WH_IN');

             -------------------------------------------------------------------------------------------------------------
             -- 2025.09.03   kimcd       PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산
             --                          활성화 후 공정 Cell 수요 정보 추가 시작
			 -------------------------------------------------------------------------------------------------------------
			 INSERT INTO #tmp_SCP_ANL_PSI_GLOBAL_SMALL
                      (  DIVISION_ID             
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
             SELECT    A.DIVISION_ID             
                      ,A.PLAN_START_YYYYMMDD     
                      ,A.PLAN_TYPE               
                      ,A.SEQ                     
                      ,A.OPERATION_GROUP         
                      ,B.CHILD_ITEM_ID  AS ITEM_ID        
                      ,NULL             AS CELL_ITEM_ID          
                      ,A.FROM_SITE      AS TO_SITE
                      ,NULL             AS TO_BOH_QTY              
                      ,'-'              AS INCOTERMS               
                      ,A.FROM_SITE
                      ,NULL             AS FROM_BOH_QTY            
                      ,'-'              AS BOD_ID                  
					  ,'-'              AS TRANSPORT_MODE_LINE
                      ,'WH_IN'          AS MEASURE 
                      ,A.YYYYMMDD                
                      ,SUM(A.QTY)       AS QTY                     
                      ,'WH_IN'          AS ATTRIBUTE1
                      FROM SCP_ANL_PSI_PRODUCTION A WITH (NOLOCK)
					      INNER  JOIN ( SELECT B.PARENT_ITEM_ID, MAX(B.CHILD_ITEM_ID) AS CHILD_ITEM_ID
										FROM   #TMP_CELL_BOM_40  B
										WHERE  B.CELL_TYPE_P = 'CA2'
										AND    B.CELL_TYPE_C = 'CA1'
										GROUP  BY B.PARENT_ITEM_ID ) B
								ON  A.ITEM_ID = B.PARENT_ITEM_ID
						  INNER JOIN SCM_MST_SITE FS WITH(NOLOCK)
								  ON FS.DIVISION_ID		= A.DIVISION_ID
								 AND FS.SCM_SITE_ID		= A.FROM_SITE
								 AND FS.SITE_TYPE		= 'PLANT'
								 AND FS.OPERATION_GROUP = 'A'		-- Cell 창고 (Pack창고 Cell은 대상 아님) 
								 AND FS.OSP_YN			= 'N'		-- OSP제외
                      WHERE 1 = 1                    
                         AND A.DIVISION_ID          = @p_division_id
                         AND A.PLAN_START_YYYYMMDD  = @p_plan_start_yyyymmdd
                         AND A.PLAN_TYPE            = @p_plan_type
                         AND A.SEQ                  = @p_seq
                         AND A.PSI_TYPE             = 'P'
                         AND A.PSI_VALUE           <> 'DIO'  
                         AND A.PSI_VALUE           <> 'ISSUM' 
                     GROUP BY  A.DIVISION_ID
                              ,A.PLAN_START_YYYYMMDD
                              ,A.PLAN_TYPE
                              ,A.SEQ
                              ,A.OPERATION_GROUP
                              ,B.CHILD_ITEM_ID
                              ,A.FROM_SITE
                              ,A.YYYYMMDD
             -------------------------------------------------------------------------------------------------------------
             -- 2025.09.03   kimcd       PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산
             --                          활성화 후 공정 Cell 수요 정보 추가 끝
			 -------------------------------------------------------------------------------------------------------------


          -------------------------------------------------------------------------------------------------------------                                             
       -- 5. MKT_FCST 0 채워 넣기
          -------------------------------------------------------------------------------------------------------------  

          CREATE CLUSTERED INDEX IX01_#tmp_SCP_ANL_PSI_GLOBAL_SMALL ON #tmp_SCP_ANL_PSI_GLOBAL_SMALL            
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


            INSERT INTO /* CHECK1*/ #tmp_SCP_ANL_PSI_GLOBAL_SMALL  WITH (TABLOCK) 
                      (
                         DIVISION_ID             
                        ,PLAN_START_YYYYMMDD     
                        ,PLAN_TYPE               
                        ,SEQ                     
                        ,OPERATION_GROUP         
                        ,ITEM_ID         
                        ,CELL_ITEM_ID     
                        ,TO_SITE                 
                        --,TO_BOH_QTY              
                        ,INCOTERMS               
                        ,FROM_SITE               
                        --,FROM_BOH_QTY            
                        ,BOD_ID                  
                        ,TRANSPORT_MODE_LINE 
                        ,MEASURE                 
                        ,YYYYMMDD                
                        ,QTY                     
                        --,CELL_ITEM_ID            
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
                         
        --                        ,TO_BOH_QTY 
                         , '-' AS INCOTERMS
                         , FROM_SITE    
        --                        ,FROM_BOH_QTY  
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
--                                  ,BOD_ID     
        --                          ,MEASURE    
                                  ,YYYYMMDD    
                                  ,NULL AS TRANSPORT_MODE_LINE
                             FROM        
                                  #YYYYMMDD A,        
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
--                                           ,BOD_ID    
        --                                   ,MEASURE    
                                           ,NULL AS TRANSPORT_MODE_LINE
                                      FROM #tmp_SCP_ANL_PSI_GLOBAL_SMALL X WITH(NOLOCK)        
                                     WHERE 1=1      
                                       AND ATTRIBUTE1 = 'SCP_ANL_SHIPMENT_PLAN_SEMI'
                                  ) B        
                        ) SUB        
                        WHERE 1=1        
                          AND NOT EXISTS (        
                                           SELECT 'X'        
                                              FROM #tmp_SCP_ANL_PSI_GLOBAL_SMALL Z WITH(NOLOCK)        
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
--                                              AND Z.BOD_ID                   = SUB.BOD_ID                                     
        --                                      AND Z.MEASURE                  = SUB.MEASURE                                    
                                              AND Z.YYYYMMDD                 = SUB.YYYYMMDD       
                                              --AND Z.TRANSPORT_MODE_LINE           = SUB.TRANSPORT_MODE_LINE                         
                                         );          
                                         
          INSERT INTO /* CHECK2*/ #tmp_SCP_ANL_PSI_GLOBAL_SMALL  WITH (TABLOCK) 
                      (
                         DIVISION_ID             
                        ,PLAN_START_YYYYMMDD     
                        ,PLAN_TYPE               
                        ,SEQ                     
                        ,OPERATION_GROUP         
                        ,ITEM_ID         
                        ,CELL_ITEM_ID                 
                        ,TO_SITE                 
                        --,TO_BOH_QTY              
                        ,INCOTERMS               
                        ,FROM_SITE               
                        --,FROM_BOH_QTY            
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
                         
        --                        ,TO_BOH_QTY 
                         , '-' AS INCOTERMS
                         , FROM_SITE    
        --                        ,FROM_BOH_QTY  
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
--                                  ,BOD_ID     
                                  ,'WH_IN' AS MEASURE    
                                  ,YYYYMMDD    
                                  ,NULL AS TRANSPORT_MODE_LINE
                             FROM        
                                  #YYYYMMDD A,        
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
--                                           ,BOD_ID    
                                           ,MEASURE    
                                           ,NULL AS TRANSPORT_MODE_LINE
                                      FROM #tmp_SCP_ANL_PSI_GLOBAL_SMALL X WITH(NOLOCK)        
                                     WHERE 1=1      
                                       AND ATTRIBUTE1 = 'SCP_ANL_SHIPMENT_PLAN_SEMI'
                                       AND MEASURE    = 'WH_IN'
                                  ) B        
                        ) SUB        
                        WHERE 1=1        
                          AND NOT EXISTS (        
                                           SELECT 'X'        
                                             FROM #tmp_SCP_ANL_PSI_GLOBAL_SMALL Z WITH(NOLOCK)        
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
--                                              AND Z.BOD_ID                   = SUB.BOD_ID                                     
                                              AND Z.MEASURE                  = SUB.MEASURE                                    
                                              AND Z.YYYYMMDD                 = SUB.YYYYMMDD       
                                              --AND Z.TRANSPORT_MODE_LINE   = SUB.TRANSPORT_MODE_LINE      
                                         );          

         INSERT INTO /* CHECK2*/ #tmp_SCP_ANL_PSI_GLOBAL_SMALL  WITH (TABLOCK) 
                      (
                         DIVISION_ID             
                        ,PLAN_START_YYYYMMDD     
                        ,PLAN_TYPE               
                        ,SEQ                     
                        ,OPERATION_GROUP         
                        ,ITEM_ID         
                        ,CELL_ITEM_ID                 
                        ,TO_SITE                 
                        --,TO_BOH_QTY              
                        ,INCOTERMS               
                        ,FROM_SITE               
                        --,FROM_BOH_QTY            
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
                         
        --                        ,TO_BOH_QTY 
                         , '-' AS INCOTERMS
                         , FROM_SITE    
        --                        ,FROM_BOH_QTY  
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
--                                  ,BOD_ID     
                                  ,'WH_IN' AS MEASURE    
                                  ,YYYYMMDD    
                                  ,NULL AS TRANSPORT_MODE_LINE
                             FROM        
                                  #YYYYMMDD A,        
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
--                                           ,BOD_ID    
                                           ,MEASURE    
                                           ,NULL AS TRANSPORT_MODE_LINE
                                      FROM #tmp_SCP_ANL_PSI_GLOBAL_SMALL X WITH(NOLOCK)        
                                     WHERE 1=1      
                                       AND ATTRIBUTE1 = 'WH_IN'
                                       AND MEASURE    = 'WH_IN'
                                  ) B        
                        ) SUB        
                        WHERE 1=1        
                          AND NOT EXISTS (        
                                           SELECT 'X'        
                                             FROM #tmp_SCP_ANL_PSI_GLOBAL_SMALL Z WITH(NOLOCK)        
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
--                                              AND Z.BOD_ID                   = SUB.BOD_ID                                     
                                              AND Z.MEASURE                  = SUB.MEASURE                                    
                                              AND Z.YYYYMMDD                 = SUB.YYYYMMDD       
                                              --AND Z.TRANSPORT_MODE_LINE           = SUB.TRANSPORT_MODE_LINE                         
                                         );   

          --2021.11.11 튜닝개선안에 따른 인덱스 삭제
          drop INDEX IX01_#tmp_SCP_ANL_PSI_GLOBAL_SMALL ON #tmp_SCP_ANL_PSI_GLOBAL_SMALL

          -------------------------------------------------------------------------------------------------------------                                   
          -- 6. UPDATE   ( BOH, TRANSPORT MODE)  SEMI (TO_SITE TRANS_MODE / FROM_SITE BOH), FG (FROM_SITE TRANS_MODE /  TO_SITE BOH)
          -------------------------------------------------------------------------------------------------------------      
          -------------------------------------------------------------------------------------------------------------                                  
          -- 6.1 -- SCP_PLN_SALES_ONHAND BOH 임시테이블 추출
          -------------------------------------------------------------------------------------------------------------       
          
 		  print  convert(varchar(30), getdate(), 121) + N'#BOH - Start ' 

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
          -- 6.2 -- SCP_PLN_PLANT_ONHAND BOH 임시테이블 추출
          ------------------------------------------------------------------------------------------------------------- 
          UNION
		  -------------------------------------------------------------------------------------------------------------
		  -- 2023.07.28 활성화 코드 대응 : Cell창고 Cell Product 재고를 Cell Assy 재고로 치환 
		  -------------------------------------------------------------------------------------------------------------
			SELECT PO.DIVISION_ID
				  ,PO.PLAN_START_YYYYMMDD
				  ,PO.PLAN_TYPE 
				  ,PO.SEQ
				  ,PO.SITE_ID
				  ,CASE WHEN FS.OPERATION_GROUP = 'A' AND FS.SITE_TYPE = 'PLANT'	-- CELL 창고
							 AND FS.OSP_YN = 'N'									-- 외주 제외 
				             AND CA.CHILD_ITEM_ID IS NOT NULL						-- 대상 정보 존재
						THEN CA.CHILD_ITEM_ID										-- 대상인 경우 Cell Product를 Cell Assy 정보로 치환
						ELSE PO.ITEM_ID
					END		 AS ITEM_ID
				  ,ISNULL(SUM(PO.PSI_BOH_QTY),0) AS PSI_BOH_QTY
             FROM SCP_PLN_PLANT_ONHAND  PO WITH(NOLOCK)  
				  INNER JOIN SCM_MST_SITE FS WITH(NOLOCK)
						  ON FS.DIVISION_ID = PO.DIVISION_ID
						 AND FS.SCM_SITE_ID = PO.SITE_ID
				   LEFT JOIN #TMP_TARGET_TO_CONVERT CA
						  ON CA.PLANT_ID		= FS.PLANT_ID
						 AND CA.PARENT_ITEM_ID	= PO.ITEM_ID
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
				  ,CASE WHEN FS.OPERATION_GROUP = 'A' AND FS.SITE_TYPE = 'PLANT'	-- CELL 창고
							 AND FS.OSP_YN = 'N'									-- 외주 제외 
				             AND CA.CHILD_ITEM_ID IS NOT NULL						-- 대상 정보 존재
						THEN CA.CHILD_ITEM_ID										-- 대상인 경우 Cell Product를 Cell Assy 정보로 치환
						ELSE PO.ITEM_ID
					END
		/* 2023.07.28 변경전 소스
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
			2023.07.28 변경전 소스 */
            ) X
  		  print  convert(varchar(30), getdate(), 121) + N'#BOH - End ' 

         -------------------------------------------------------------------------------------------------------------                                              
          -- 6.3  FROM_BOH_QTY,TO_BOH_QTY 계산
          ------------------------------------------------------------------------------------------------------------- 
            UPDATE X
               SET X.FROM_BOH_QTY = ISNULL(BOH.PSI_BOH_QTY,0)
               FROM #tmp_SCP_ANL_PSI_GLOBAL_SMALL X WITH (NOLOCK)
               LEFT OUTER JOIN #BOH AS BOH WITH (NOLOCK)   
                ON 0 = 0
                AND X.DIVISION_ID          = BOH.DIVISION_ID      
                AND X.PLAN_START_YYYYMMDD  = BOH.PLAN_START_YYYYMMDD      
                AND X.PLAN_TYPE            = BOH.PLAN_TYPE      
                AND X.SEQ                  = BOH.SEQ      
                AND X.FROM_SITE            = BOH.SITE_ID      
                AND X.ITEM_ID              = BOH.ITEM_ID    


              /*
            UPDATE X
               SET X.ATTRIBUTE2 = ISNULL(BOH.PSI_BOH_QTY,0)
               FROM #tmp_SCP_ANL_PSI_GLOBAL_SMALL X WITH (NOLOCK)
               LEFT OUTER JOIN #BOH AS BOH WITH (NOLOCK)   
                ON 0 = 0
                AND X.DIVISION_ID          = BOH.DIVISION_ID      
                AND X.PLAN_START_YYYYMMDD  = BOH.PLAN_START_YYYYMMDD      
                AND X.PLAN_TYPE            = BOH.PLAN_TYPE      
                AND X.SEQ                  = BOH.SEQ      
                AND X.TO_SITE              = BOH.SITE_ID      
                AND X.ITEM_ID              = BOH.ITEM_ID  
                AND X.MEASURE              = 'MODEL_INVENTORY'
                AND X.OPERATION_GROUP      = 'A'
                */
            
            /*
                ACTIVATE_PROGRESS	  Formation Progress
                MODEL_INVENTORY	    Model Inventory
              */

              UPDATE X
               SET X.ATTRIBUTE2 = ISNULL(BOH.PSI_BOH_QTY,0)
               FROM #tmp_SCP_ANL_PSI_GLOBAL_SMALL X WITH (NOLOCK)
               INNER JOIN #BOH AS BOH WITH (NOLOCK)   
                ON 0 = 0
                AND X.DIVISION_ID          = BOH.DIVISION_ID      
                AND X.PLAN_START_YYYYMMDD  = BOH.PLAN_START_YYYYMMDD      
                AND X.PLAN_TYPE            = BOH.PLAN_TYPE      
                AND X.SEQ                  = BOH.SEQ      
                AND X.FROM_SITE            = BOH.SITE_ID      
                AND X.ITEM_ID              = BOH.ITEM_ID    
                WHERE 0 = 0
                AND X.MEASURE              = 'MODEL_INVENTORY'

               
/*

          UPDATE X
               SET X.ATTRIBUTE2 = ISNULL(BOH.PSI_BOH_QTY,0)
               FROM #tmp_SCP_ANL_PSI_GLOBAL_SMALL X WITH (NOLOCK)
               LEFT OUTER JOIN #BOH AS BOH WITH (NOLOCK)   
                ON 0 = 0
                AND X.DIVISION_ID          = BOH.DIVISION_ID      
                AND X.PLAN_START_YYYYMMDD  = BOH.PLAN_START_YYYYMMDD      
                AND X.PLAN_TYPE            = BOH.PLAN_TYPE      
                AND X.SEQ                  = BOH.SEQ      
                AND X.FROM_SITE            = BOH.SITE_ID      
                AND X.ITEM_ID              = BOH.ITEM_ID  
                AND X.MEASURE              = 'MODEL_INVENTORY'
--                AND X.OPERATION_GROUP      = 'P'
*/
            UPDATE X
               SET X.ATTRIBUTE2 = ISNULL(BOH.PSI_BOH_QTY,0)
               FROM #tmp_SCP_ANL_PSI_GLOBAL_SMALL X WITH (NOLOCK)
               INNER JOIN ( SELECT DIVISION_ID      
                                       ,PLAN_START_YYYYMMDD      
                                       ,PLAN_TYPE      
                                       ,SEQ      
                                       ,SITE_ID      
                                       ,ITEM_ID     
                                       ,SUM(ISNULL(PSI_BOH_QTY,0)) AS     PSI_BOH_QTY    
                                   FROM SCP_PLN_PLANT_ONHAND WITH(NOLOCK)        
                                  WHERE DIVISION_ID               = @P_DIVISION_ID             
                                    AND PLAN_START_YYYYMMDD       = @P_PLAN_START_YYYYMMDD     
                                    AND PLAN_TYPE                 = @P_PLAN_TYPE               
                                    AND SEQ                       = @P_SEQ                     
                                    AND YYYYMMDD                  = @P_PLAN_START_YYYYMMDD 
                                    AND STOCK_TYPE                = 'FOR_STOCKPLAN'
                                  GROUP by DIVISION_ID      
                                          ,PLAN_START_YYYYMMDD      
                                          ,PLAN_TYPE      
                                          ,SEQ      
                                          ,SITE_ID      
                                          ,ITEM_ID  
                                ) BOH --WITH (NOLOCK)   
                ON  0 = 0
                AND X.DIVISION_ID          = BOH.DIVISION_ID
                AND X.PLAN_START_YYYYMMDD  = BOH.PLAN_START_YYYYMMDD      
                AND X.PLAN_TYPE            = BOH.PLAN_TYPE      
                AND X.SEQ                  = BOH.SEQ      
                AND X.FROM_SITE            = BOH.SITE_ID      
                AND X.ITEM_ID              = BOH.ITEM_ID  
              WHERE 0 = 0
                AND X.MEASURE              = 'ACTIVATE_PROGRESS'
                AND X.OPERATION_GROUP      = 'A'


          -------------------------------------------------------------------------------------------------------------                                         
          -- 6.4  CELL_ITEM_ID UPDATE
          ------------------------------------------------------------------------------------------------------------- 
                -- PACK 일경우 
                /*
                UPDATE X
                   SET X.CELL_ITEM_ID      = ( SELECT TOP 1 CHILD_ITEM_ID
                                               FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V AS Y WITH (NOLOCK)
                                              WHERE Y.DIVISION_ID        = X.DIVISION_ID
                                                AND Y.MODEL_ID           = X.ITEM_ID
                                                AND Y.OPERATION_GROUP_ID = 'A')
                 FROM #tmp_SCP_ANL_PSI_GLOBAL_SMALL X WITH (NOLOCK)
                 WHERE OPERATION_GROUP   = 'P'
                 ;

                -- CELL 일경우 
              UPDATE X
                SET X.CELL_ITEM_ID      = X.ITEM_ID
                FROM #tmp_SCP_ANL_PSI_GLOBAL_SMALL X WITH (NOLOCK)
                WHERE 0 = 0
                  AND X.OPERATION_GROUP   = 'A'
                ;
                */

                UPDATE X
                   SET X.CELL_ITEM_ID      = Y.CELL_LIST
                 FROM #tmp_SCP_ANL_PSI_GLOBAL_SMALL X WITH (NOLOCK)
                 JOIN SCP_MST_FINAL_ITEM_V Y WITH (NOLOCK)
                 ON 0 = 0
                 AND X.ITEM_ID          = Y.ITEM_ID
                 AND X.OPERATION_GROUP  = Y.OPERATION_GROUP
                 AND Y.CELL_LIST        IS NOT NULL
                 ;

                -------------------------------------------------------------------------------------------------------------
                -- 2025.06.26   KIMCD       PJ2024A332 독립적 Planning 체계 및 Master Validation UI 구축
		        -- CA1 품목은 바로 상위 품목으로 변경
                -------------------------------------------------------------------------------------------------------------  
				-- 2025.09.03   kimcd       PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산  : 
                --                          활성화 후 공정 Cell이 존재하는 경우  Cell 정보를  활성화 후 공정 Cell로 설정
				/*                          Cell 제품으로 추가 갱신 막음
                UPDATE X
                   SET X.CELL_ITEM_ID   = Y.PARENT_ITEM_ID
                 FROM #tmp_SCP_ANL_PSI_GLOBAL_SMALL X WITH (NOLOCK)
                      INNER JOIN #TMP_CELL_BOM_40 Y WITH (NOLOCK)
                      ON  0 = 0
                      AND X.ITEM_ID     = Y.CHILD_ITEM_ID
					  AND TCO_CELL_YN_P = 'N'
					  AND CELL_TYPE_P   = 'CP'
					  AND TCO_CELL_YN_C = 'N'
					  AND CELL_TYPE_C   = 'CA1';

                -- 2025.06.26   KIMCD       PJ2024A332 독립적 Planning 체계 및 Master Validation UI 구축*/
                  
          -------------------------------------------------------------------------------------------------------------                            
          -- 7. 'MKT_FCST'로 / RTF(ALLOCATION) / Balance 0 채워 넣기
          ------------------------------------------------------------------------------------------------------------- 
                                                     
            INSERT INTO /* CHECK3*/ #tmp_SCP_ANL_PSI_GLOBAL_SMALL  WITH (TABLOCK)
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
               FROM #tmp_SCP_ANL_PSI_GLOBAL_SMALL WITH (NOLOCK) 
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
               FROM #tmp_SCP_ANL_PSI_GLOBAL_SMALL WITH (NOLOCK) 
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
                     ,'0' AS ATTRIBUTE1              
               FROM #tmp_SCP_ANL_PSI_GLOBAL_SMALL WITH (NOLOCK) 
              WHERE 1=1      
               AND ATTRIBUTE1   = 'SCP_ANL_SHIPMENT_PLAN_SEMI'
               AND MEASURE      = 'MKT_FCST'
               AND TO_SITE      <> '-' -- 생산제외

          -------------------------------------------------------------------------------------------------------------                                       
          -- 8. TRANSPORT_MODE_LINE UPDATE
          -------------------------------------------------------------------------------------------------------------  
          -- TRANSPORT_MODE
          -- PJ20209643 (20210716) : scp_mst_bod_v에서 scp_mst_bod_n_v로 변경
            UPDATE X
               SET X.TRANSPORT_MODE_LINE = Y.TRANSPORT_MODE
              FROM #tmp_SCP_ANL_PSI_GLOBAL_SMALL X WITH (NOLOCK)
              INNER JOIN scp_mst_bod_n_v Y WITH (NOLOCK)  
              ON 0 = 0
              AND X.DIVISION_ID  = Y.DIVISION_ID 
              AND X.BOD_ID       = Y.BOD_ID 
              AND X.FROM_SITE    = Y.FROM_SITE	 
              AND X.MEASURE      <> 'PRODUCTION'
              AND X.BOD_ID       <> '-'
          

            DELETE FROM #tmp_SCP_ANL_PSI_GLOBAL_SMALL WHERE  MEASURE IN ('MKT_FCST','ALLOCATION','BALANCE') AND TO_SITE ='-'  -- 생산제외

--             SELECT * FROM #tmp_SCP_ANL_PSI_GLOBAL_SMALL  WITH (NOLOCK) WHERE ITEM_ID ='MCP275292A10' AND MEASURE ='WH_IN'
--                return
          -------------------------------------------------------------------------------------------------------------
          -- 2025.06.26   KIMCD       PJ2024A332 독립적 Planning 체계 및 Master Validation UI 구축
		  -- 'WH_IN','ACTIVATE_PROGRESS','MODEL_INVENTORY','INCP_MODEL_INVENTORY','OWMS_MODEL_INVENTORY', PRODUCTION, CHAR_AVAILABLE 합산 시작. 일단 제외 ACTIVATE_COMPLETED 
          -------------------------------------------------------------------------------------------------------------  
		  INSERT INTO #tmp_SCP_ANL_PSI_GLOBAL_SMALL
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
			   ,ATTRIBUTE3
			   ,ATTRIBUTE4
               ,ATTRIBUTE9
               ,ATTRIBUTE10
               )
		  SELECT A.DIVISION_ID      
                ,A.PLAN_START_YYYYMMDD      
                ,A.PLAN_TYPE      
                ,A.SEQ      
                ,A.OPERATION_GROUP
                ,IC.CLASS_NAME  AS ITEM_ID     
                ,IC.CLASS_NAME  AS CELL_ITEM_ID
                ,''                       AS TO_SITE                 
                ,SUM(A.TO_BOH_QTY)        AS TO_BOH_QTY
                ,NULL                     AS INCOTERMS               
                ,A.FROM_SITE               
                ,SUM(A.FROM_BOH_QTY)      AS FROM_BOH_QTY
                ,'-'                      AS BOD_ID                  
                ,NULL                     AS TRANSPORT_MODE_LINE 
                ,A.MEASURE
                ,A.YYYYMMDD
                ,SUM(A.QTY)               AS QTY
                ,MAX(A.ATTRIBUTE1)        AS ATTRIBUTE1
				,MAX(A.ATTRIBUTE3)        AS ATTRIBUTE3
				,IC.CLASS_NAME            AS ATTRIBUTE4
				,MAX(A.ATTRIBUTE9)        AS ATTRIBUTE9
                ,'4'                      AS ATTRIBUTE10
           FROM #tmp_SCP_ANL_PSI_GLOBAL_SMALL A WITH(NOLOCK)    
				  INNER JOIN SCM_MST_SITE FS WITH(NOLOCK)		-- 7월은 국내만 적용  
						  ON FS.DIVISION_ID		= A.DIVISION_ID
						 AND FS.SCM_SITE_ID		= A.FROM_SITE
						 AND FS.SITE_TYPE		= 'PLANT'
						 AND FS.OPERATION_GROUP = 'A'		-- Cell 창고 (Pack창고 Cell은 대상 아님) 
						 AND FS.OSP_YN			= 'N'		-- OSP제외
  				 INNER JOIN SCP_MST_FINAL_ITEM FI WITH(NOLOCK)
						 ON FI.DIVISION_ID		= A.DIVISION_ID
						AND FI.ITEM_ID			= A.CELL_ITEM_ID
				 INNER JOIN SCM_MST_ITEM_CLASS_SN IC WITH(NOLOCK)
						 ON FI.ITEM_CLASS		= IC.CLASS_ID
          WHERE A.DIVISION_ID         = @P_DIVISION_ID              
            AND A.PLAN_START_YYYYMMDD = @P_PLAN_START_YYYYMMDD      
            AND A.PLAN_TYPE           = @P_PLAN_TYPE                
            AND A.SEQ                 = @P_SEQ
			AND A.OPERATION_GROUP     = 'A'
            AND A.MEASURE            IN ('ACTIVATE_PROGRESS','CHAR_AVAILABLE','INCP_MODEL_INVENTORY','MODEL_INVENTORY','OWMS_MODEL_INVENTORY','PRODUCTION','WH_IN')
			GROUP BY A.DIVISION_ID,A.PLAN_START_YYYYMMDD,A.PLAN_TYPE,A.SEQ,A.OPERATION_GROUP,IC.CLASS_NAME,A.FROM_SITE,A.MEASURE,A.YYYYMMDD;


		/* 초기 재고 갱신 */
		 UPDATE A
		    SET A.FROM_BOH_QTY = ISNULL(BOH.PSI_BOH_QTY,0) 
			FROM #tmp_SCP_ANL_PSI_GLOBAL_SMALL A
               LEFT OUTER JOIN ( SELECT BOH.DIVISION_ID      
                                       ,BOH.PLAN_START_YYYYMMDD      
                                       ,BOH.PLAN_TYPE      
                                       ,BOH.SEQ      
                                       ,BOH.SITE_ID
				                       ,IC.CLASS_NAME
				                       ,SUM(BOH.PSI_BOH_QTY) AS PSI_BOH_QTY
			                       FROM #BOH AS BOH WITH(NOLOCK)
                                        INNER JOIN #TMP_CELL_BOM_40 Y WITH (NOLOCK)
                                            ON  0 = 0
                                            AND BOH.ITEM_ID   = Y.CHILD_ITEM_ID
					                        AND CELL_TYPE_P   = 'CP'
					                    INNER JOIN SCP_MST_FINAL_ITEM FI WITH(NOLOCK)
					                  	    ON  FI.DIVISION_ID		= BOH.DIVISION_ID
					                  	    AND FI.ITEM_ID			= Y.PARENT_ITEM_ID
				                        INNER JOIN SCM_MST_ITEM_CLASS_SN IC WITH(NOLOCK)
						                    ON FI.ITEM_CLASS		= IC.CLASS_ID
								 GROUP BY BOH.DIVISION_ID      
                                         ,BOH.PLAN_START_YYYYMMDD      
                                         ,BOH.PLAN_TYPE      
                                         ,BOH.SEQ      
                                         ,BOH.SITE_ID
				                         ,IC.CLASS_NAME				                   
				                   ) AS BOH   
                ON 0 = 0
                AND A.DIVISION_ID          = BOH.DIVISION_ID      
                AND A.PLAN_START_YYYYMMDD  = BOH.PLAN_START_YYYYMMDD      
                AND A.PLAN_TYPE            = BOH.PLAN_TYPE      
                AND A.SEQ                  = BOH.SEQ      
                AND A.FROM_SITE            = BOH.SITE_ID      
                AND A.ITEM_ID              = BOH.CLASS_NAME
		  WHERE A.DIVISION_ID         = @P_DIVISION_ID              
            AND A.PLAN_START_YYYYMMDD = @P_PLAN_START_YYYYMMDD      
            AND A.PLAN_TYPE           = @P_PLAN_TYPE                
            AND A.SEQ                 = @P_SEQ
			AND A.OPERATION_GROUP     = 'A'
            AND A.MEASURE            IN ('ACTIVATE_PROGRESS','CHAR_AVAILABLE','INCP_MODEL_INVENTORY','MODEL_INVENTORY','OWMS_MODEL_INVENTORY','PRODUCTION','WH_IN')
		    AND A.ITEM_ID             = A.CELL_ITEM_ID
        	AND	A.CELL_ITEM_ID        = A.ATTRIBUTE4
		    AND A.ATTRIBUTE10         = '4';

          -------------------------------------------------------------------------------------------------------------
          -- 2025.06.26   KIMCD       PJ2024A332 독립적 Planning 체계 및 Master Validation UI 구축
		  -- 'WH_IN','ACTIVATE_PROGRESS','MODEL_INVENTORY','INCP_MODEL_INVENTORY','OWMS_MODEL_INVENTORY', PRODUCTION 합산 종료. 일단 제외 ACTIVATE_COMPLETED
          -------------------------------------------------------------------------------------------------------------  

          -------------------------------------------------------------------------------------------------------------                     
          -- 9. DIO 생성                     
          -------------------------------------------------------------------------------------------------------------          
          -------------------------------------------------------------------------------------------------------------                 
          -- 9.1. DIO 임시 테이블 생성          GROUPING 확인, CELL_ITEM_ID
          -------------------------------------------------------------------------------------------------------------                 
          IF OBJECT_ID('tempdb..#tmp_SCP_ANL_PSI_GLOBAL_SMALL_DIO') IS NOT NULL                
              DROP TABLE #tmp_SCP_ANL_PSI_GLOBAL_SMALL_DIO                
                
            CREATE TABLE #tmp_SCP_ANL_PSI_GLOBAL_SMALL_DIO                
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
                
          
          INSERT INTO #tmp_SCP_ANL_PSI_GLOBAL_SMALL_DIO   WITH (TABLOCK)        
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
                   ,FROM_SITE          
                   ,ITEM_ID        
                   ,CELL_ITEM_ID  
                   ,YYYYMMDD          
                   ,MAX(FROM_BOH_QTY) AS FROM_BOH_QTY     
                   ,MAX(TO_BOH_QTY) AS TO_BOH_QTY    
                   ,SUM((CASE MEASURE WHEN 'WH_IN'              THEN ROUND(P.QTY,1) ELSE 0 END )) AS OUT_QTY          
                   ,SUM((CASE MEASURE WHEN 'ACTIVATE_PROGRESS'  THEN ROUND(P.QTY,1) ELSE 0 END)) AS FORMATION_QTY         
                   ,SUM((CASE MEASURE WHEN 'MODEL_INVENTORY'    THEN ROUND(P.QTY,1) ELSE 0 END)) AS EOH_QTY          
                   , 0          
              FROM #tmp_SCP_ANL_PSI_GLOBAL_SMALL P WITH(NOLOCK)          
             WHERE 1=1          
             AND ATTRIBUTE1 <> 'CELL' 
			 AND ATTRIBUTE1 <> 'CELL_WH'   -- 2025.06.26   KIMCD       PJ2024A332 독립적 Planning 체계 및 Master Validation UI 구축
		                                   -- 'CELL_WH' 조건 추가
             AND FROM_SITE <> '-'
            GROUP BY  DIVISION_ID, FROM_SITE,ITEM_ID,CELL_ITEM_ID,YYYYMMDD--,FROM_BOH_QTY,TO_BOH_QTY             
            ORDER BY  DIVISION_ID, FROM_SITE,ITEM_ID,CELL_ITEM_ID,YYYYMMDD--,FROM_BOH_QTY,TO_BOH_QTY             ;       
            
         -- DIO 보정로직 추가
         /*
          DELETE FROM #tmp_SCP_ANL_PSI_GLOBAL_SMALL_DIO
--        SELECT X.FROM_SITE , X.ITEM_ID , X.CELL_ITEM_ID  
               FROM #tmp_SCP_ANL_PSI_GLOBAL_SMALL_DIO X 
                 JOIN (
                        SELECT FROM_SITE          
                              ,ITEM_ID       
                              ,CELL_ITEM_ID   
                          FROM #tmp_SCP_ANL_PSI_GLOBAL_SMALL_DIO  WITH(NOLOCK)          
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
         -- 9.2. DIO 누적합계와 전일누적합계를  생성         #Tbl_DIO                                                                                                 
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
                         from #tmp_SCP_ANL_PSI_GLOBAL_SMALL_DIO P WITH(NOLOCK)          
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
         -- 9.3.구하고자 하는 재고일수의 일자를 기준으로 이후 일자의 OUT값의 누적값중 현재 재고값보다 최초로 큰값을 구함.          
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
--                        ,(A.OUT_QTY_SUM  + A.EOH_QTY )            
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
                            ISNULL((DATEDIFF(DD,CONVERT(DATETIME,A.YYYYMMDD ,112),CONVERT(DATETIME,((SELECT TOP 1 YYYYMMDD           
                                                                                     FROM #Tbl_DIO X  WITH (NOLOCK)          
                                                                                    WHERE X.FROM_SITE = A.FROM_SITE           
                                                                                       AND X.ITEM_ID   = A.ITEM_ID   
                                                                                    AND X.CELL_ITEM_ID   = A.CELL_ITEM_ID            
                                                                                       AND X.YYYYMMDD  > A.YYYYMMDD           
                                                                                       AND (A.OUT_QTY_SUM  + A.EOH_QTY + A.FORMATION_QTY ) <= X.OUT_QTY_SUM           
                                                                                     )),112))),999)          
                       END)                                                                   
                                                                                      AS DD          
            INTO #Tbl_SCP_ANL_PSI_GLOBAL_SMALL_DIO          
            FROM #Tbl_DIO A WITH (NOLOCK)            
          
         -------------------------------------------------------------------------------------------------------------         
         -- 9.4. #tmp_SCP_ANL_PSI_PRODUCTION 입력          
         -- 'I'   AS PSI_TYPE                             
         -- 'DIO' AS PSI_VALUE                                           
         -- ROUND(DD-1) + (OUT_QTY/TOT_QTY),2)          
         -- SET @V_INV_DAY = ROUND( (@V_DAY-1) + (@C_EOH_QTY / @V_QTY) , 2)  -- QTY             
         -------------------------------------------------------------------------------------------------------------                   

         INSERT INTO  /* DIO */ #tmp_SCP_ANL_PSI_GLOBAL_SMALL   WITH (TABLOCK)               
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
                    ,X.CELL_ITEM_ID AS CELL_ITEM_ID             -- update
                    ,'-'  AS TO_SITE   
                    ,0    AS TO_BOH_QTY                  -- update 
                    ,'-' AS INCOTERMS
                    ,X.FROM_SITE         
                    ,FROM_BOH_QTY
                    ,NULL AS BOD_ID
--                       ,'I'   AS PSI_TYPE     
                    ,'DIO' AS MEASURE                 
                    ,X.YYYYMMDD                
                    , (CASE WHEN X.DD = 0 THEN 0 ELSE X.DD END) AS QTY                       
                    ,'-' AS TRANSPORT_MODE_LINE          
                    ,'DIO' AS ATTRIBUTE1   
              FROM #Tbl_SCP_ANL_PSI_GLOBAL_SMALL_DIO X WITH(NOLOCK)                
              INNER JOIN SCP_MST_FINAL_ITEM_V Y WITH (NOLOCK)                
                      ON 0 = 0            
                     AND X.ITEM_ID      = Y.ITEM_ID  
--                     AND X.CELL_ITEM_ID      = Y.CELL_ITEM_ID           
                   WHERE 1 = 1                
                         AND FROM_SITE <>'-'  
			 UNION
             SELECT  @P_DIVISION_ID                          
                    ,@P_PLAN_START_YYYYMMDD                  
                    ,@P_PLAN_TYPE                            
                    ,@P_SEQ                                  
                    ,'A' AS OPERATION_GROUP        
                    ,X.ITEM_ID           
                    ,X.CELL_ITEM_ID AS CELL_ITEM_ID             -- update
                    ,'-'  AS TO_SITE   
                    ,0    AS TO_BOH_QTY                  -- update 
                    ,'-' AS INCOTERMS
                    ,X.FROM_SITE         
                    ,X.FROM_BOH_QTY
                    ,NULL AS BOD_ID
                    ,'DIO' AS MEASURE                 
                    ,X.YYYYMMDD                
                    , (CASE WHEN X.DD = 0 THEN 0 ELSE X.DD END) AS QTY                       
                    ,'-' AS TRANSPORT_MODE_LINE          
                    ,'DIO' AS ATTRIBUTE1   
             FROM #Tbl_SCP_ANL_PSI_GLOBAL_SMALL_DIO X WITH(NOLOCK)                
				 INNER JOIN SCM_MST_ITEM_CLASS_SN IC WITH(NOLOCK)
						 ON X.ITEM_ID		= IC.CLASS_NAME
             WHERE 1 = 1                
			 AND   X.FROM_SITE <>'-' ;          
                
          
           UPDATE X
              SET X.ATTRIBUTE9 = SUBSTRING(Y.FLOW_ID,1,5)
              FROM #tmp_SCP_ANL_PSI_GLOBAL_SMALL X WITH (NOLOCK)
				   INNER JOIN SCM_MST_DIVISION DM WITH(NOLOCK)	-- 2023.03.29 HM JV 가상 사업부 추가 대응 
						   ON DM.DIVISION_ID = X.DIVISION_ID 
						  AND DM.VALID_YN	 = 'Y'
              INNER JOIN SCP_MST_FINAL_ITEM  Y WITH (NOLOCK)
              ON 0 = 0
              AND X.ITEM_ID     = Y.ITEM_ID
			  AND Y.DIVISION_ID = CASE WHEN DM.ATTRIBUTE3 = 'EE' -- 2023.03.29 HM JV 가상 사업부 추가 대응 
									   THEN Y.DIVISION_ID
									   ELSE X.DIVISION_ID
								 END 
              -- 2023.03.29 AND (CASE WHEN X.DIVISION_ID IN ('EE', 'EE_UC') THEN '0' ELSE X.DIVISION_ID END ) = (CASE WHEN X.DIVISION_ID IN ('EE', 'EE_UC') THEN '0' ELSE Y.DIVISION_ID END )    -- 2022.03.23	KSW	GM JV 반영 :: EE_UC  추가, 0 --> '0'


           UPDATE X
              SET X.ATTRIBUTE9 = Y.PLANT_ID
              FROM #tmp_SCP_ANL_PSI_GLOBAL_SMALL X WITH (NOLOCK)
              INNER JOIN SCM_MST_SITE Y WITH(NOLOCK)
              ON 0 = 0
              AND Y.DIVISION_ID = X.DIVISION_ID
              AND Y.SCM_SITE_ID = X.FROM_SITE
              AND Y.OSP_YN      = 'Y'

              
          -------------------------------------------------------------------------------------------------------------                                       
          -- 10. 정렬순서 입력 PACK/TCO/CELL(1/2/3)
          -------------------------------------------------------------------------------------------------------------   
          -- PACK
              UPDATE X
                  SET X.ATTRIBUTE10      = '1'
                FROM #tmp_SCP_ANL_PSI_GLOBAL_SMALL X WITH (NOLOCK)
                WHERE OPERATION_GROUP   = 'P'
                ;
          -- CELL
              UPDATE X
                SET X.ATTRIBUTE10      = '3'
              FROM #tmp_SCP_ANL_PSI_GLOBAL_SMALL X WITH (NOLOCK)
              WHERE OPERATION_GROUP   = 'A'

          ---- TCO_CELL 일경우 
          --    UPDATE X
          --    SET X.ATTRIBUTE10      = '2'
          --    FROM #tmp_SCP_ANL_PSI_GLOBAL_SMALL X WITH (NOLOCK)
          --    INNER JOIN SCP_MST_FINAL_ITEM Y WITH (NOLOCK) 
          --      ON 0 = 0
          --      AND '40'                = Y.DIVISION_ID
          --      AND X.ITEM_ID           = Y.ITEM_ID
          --      AND X.OPERATION_GROUP   = 'A'
          --      AND Y.TCO_CELL_YN       = 'Y'

          -- PACK SITE CELL 재고인 경우 일경우 
              UPDATE X
              SET X.ATTRIBUTE10      = '2'
              FROM #tmp_SCP_ANL_PSI_GLOBAL_SMALL X WITH (NOLOCK)
              WHERE 0 = 0
                AND X.OPERATION_GROUP   = 'A'
                AND X.ATTRIBUTE1        ='CELL'

 			 INSERT INTO #tmp_SCP_ANL_PSI_GLOBAL_SMALL2
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
				   ,TRANSPORT_MODE_LINE
				   ,MEASURE            
				   ,YYYYMMDD           
				   ,QTY                
				   ,ATTRIBUTE1           
				   ,ATTRIBUTE2 
				   ,ATTRIBUTE3	-- 2023.07.28 활성화코드 분리 대응
				   ,ATTRIBUTE4  -- 2025.06.26 KIMCD PJ2024A332 독립적 Planning 체계 및 Master Validation UI 구축. cell item class name 추가
				   ,ATTRIBUTE9           
				   ,(CASE WHEN OPERATION_GROUP   = 'P' THEN '1'
						 WHEN OPERATION_GROUP   = 'A' AND ATTRIBUTE1 = 'CELL' THEN '2' 
						 WHEN OPERATION_GROUP   = 'A' AND ATTRIBUTE1 <> 'CELL' THEN '3' 
						 ELSE ATTRIBUTE10 
					END) AS ATTRIBUTE10
               FROM #tmp_SCP_ANL_PSI_GLOBAL_SMALL X WITH (NOLOCK)          

          -------------------------------------------------------------------------------------------------------------                                       
          -- SCP_ANL_PSI_GLOBAL_SMALL 삭제                         
          -------------------------------------------------------------------------------------------------------------  
/*
            DELETE FROM #tmp_SCP_ANL_PSI_GLOBAL_SMALL  WHERE 0 = 0 AND ATTRIBUTE1  = '0'    -- ALLOCATION / BALANCE
            DELETE FROM #tmp_SCP_ANL_PSI_GLOBAL_SMALL  WHERE 0 = 0 AND ATTRIBUTE1  = 'SCP_ANL_SHIPMENT_PLAN_SEMI'  AND MEASURE ='MKT_FCST'     -- MKT_FCST
--           DELETE FROM #tmp_SCP_ANL_PSI_GLOBAL_SMALL  WHERE 0 = 0 AND ATTRIBUTE10 = '3'                           AND MEASURE ='WH_IN_BALANCE'-- WH_IN_BALANCE
            DELETE A FROM #tmp_SCP_ANL_PSI_GLOBAL_SMALL A  WITH (NOLOCK)
               INNER JOIN SCM_MST_SITE B WITH (NOLOCK)
                       ON B.SCM_SITE_ID = A.TO_SITE
                      AND A.DIVISION_ID = B.DIVISION_ID
                      AND B.OSP_YN = 'Y'
                    WHERE 0 = 0
                     AND A.ATTRIBUTE10  = '3'                           
                     AND MEASURE ='WH_IN_BALANCE';
*/

            DELETE FROM #tmp_SCP_ANL_PSI_GLOBAL_SMALL2  WHERE 0 = 0 AND ATTRIBUTE1  = '0'    -- ALLOCATION / BALANCE
            DELETE FROM #tmp_SCP_ANL_PSI_GLOBAL_SMALL2  WHERE 0 = 0 AND ATTRIBUTE1  = 'SCP_ANL_SHIPMENT_PLAN_SEMI'  AND MEASURE ='MKT_FCST'     -- MKT_FCST
--           DELETE FROM #tmp_SCP_ANL_PSI_GLOBAL_SMALL  WHERE 0 = 0 AND ATTRIBUTE10 = '3'                           AND MEASURE ='WH_IN_BALANCE'-- WH_IN_BALANCE
            DELETE A FROM #tmp_SCP_ANL_PSI_GLOBAL_SMALL2 A  WITH (NOLOCK)
               INNER JOIN SCM_MST_SITE B WITH (NOLOCK)
                       ON B.SCM_SITE_ID = A.TO_SITE
                      AND A.DIVISION_ID = B.DIVISION_ID
                      AND B.OSP_YN = 'Y'
                    WHERE 0 = 0
                     AND A.ATTRIBUTE10  = '3'                           
                     AND MEASURE ='WH_IN_BALANCE';

            /*
            DELETE FROM #tmp_SCP_ANL_PSI_GLOBAL_SMALL  
            WHERE 0 = 0 
            AND ATTRIBUTE10 = '2'                           
            AND MEASURE  IN ( 'ACTIVATE_COMPLETED', 'CHAR_AVAILABLE','ACTIVATE_PROGRESS')   -- TCO 셀    
            */

/*
            DELETE FROM #tmp_SCP_ANL_PSI_GLOBAL_SMALL  
            FROM #tmp_SCP_ANL_PSI_GLOBAL_SMALL X WITH (NOLOCK)
              INNER JOIN SCP_MST_FINAL_ITEM Y WITH (NOLOCK) 
                ON 0 = 0
                AND '40'                = Y.DIVISION_ID
                AND X.ITEM_ID           = Y.ITEM_ID
                AND X.OPERATION_GROUP   = 'A'
                AND Y.TCO_CELL_YN       = 'Y'
                AND MEASURE  IN ( 'ACTIVATE_COMPLETED', 'CHAR_AVAILABLE','ACTIVATE_PROGRESS')   -- TCO 셀
*/

            DELETE X
			FROM #tmp_SCP_ANL_PSI_GLOBAL_SMALL2 X WITH (NOLOCK)
              INNER JOIN SCP_MST_FINAL_ITEM Y WITH (NOLOCK) 
                ON 0 = 0
                AND '40'                = Y.DIVISION_ID
                AND X.ITEM_ID           = Y.ITEM_ID
                AND X.OPERATION_GROUP   = 'A'
                AND Y.TCO_CELL_YN       = 'Y'
                AND MEASURE  IN ( 'ACTIVATE_COMPLETED', 'CHAR_AVAILABLE','ACTIVATE_PROGRESS')   -- TCO 셀


		-------------------------------------------------------------------------------------------------------------                                       
        -- PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : 활성화코드 분리 대응
		-- 2023.07.28 Cell Product 생산관련 measure 전구간 0인 데이터 삭제     
		-------------------------------------------------------------------------------------------------------------  
  		print  convert(varchar(30), getdate(), 121) + N'#tmp_TARGET_TO_DELETE - Start ' 
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
		FROM #tmp_SCP_ANL_PSI_GLOBAL_SMALL2  PG WITH(NOLOCK)   
			 INNER JOIN SCM_MST_SITE FS WITH(NOLOCK)
					 ON FS.DIVISION_ID		= PG.DIVISION_ID
					AND FS.SCM_SITE_ID		= PG.FROM_SITE 
					AND FS.OPERATION_GROUP	= 'A'		-- Cell 창고 
					AND FS.OSP_YN			= 'N'		-- 외주 제외 
			 INNER JOIN #TMP_TARGET_TO_CONVERT TG WITH(NOLOCK)
					 on TG.PLANT_ID			= FS.PLANT_ID
					AND TG.PARENT_ITEM_ID	= PG.ITEM_ID 
		WHERE 1=1
		  AND PG.DIVISION_ID			= @p_division_id               
		  AND PG.PLAN_START_YYYYMMDD	= @p_plan_start_yyyymmdd       
		  AND PG.PLAN_TYPE				= @p_plan_type                 
		  AND PG.SEQ					= @p_seq          
		  AND PG.OPERATION_GROUP		= 'A' -- Cell  품목 
		  AND (ISNULL(PG.TO_SITE,'-') = '-' OR RTRIM(PG.TO_SITE) = '') 
		  AND PG.MEASURE in ( 'PRODUCTION', 'ACTIVATE_COMPLETED', 'CHAR_AVAILABLE', 'ACTIVATE_PROGRESS' ,'MODEL_INVENTORY' ,'DIO', 'INCP_MODEL_INVENTORY', 'OWMS_MODEL_INVENTORY') -- 생산관련 measure 
          -------------------------------------------------------------------------------------------------------------
          -- 2025.06.26   KIMCD       PJ2024A332 독립적 Planning 체계 및 Master Validation UI 구축
		  -- 'INCP_MODEL_INVENTORY', 'OWMS_MODEL_INVENTORY' 유형 추가
          -------------------------------------------------------------------------------------------------------------
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

  	   print  convert(varchar(30), getdate(), 121) + N'Delete #tmp_SCP_ANL_PSI_GLOBAL_SMALL2 - 전구간0인 cp 생산 measure' ;
	   DELETE TGT
	    FROM  #tmp_SCP_ANL_PSI_GLOBAL_SMALL2  AS TGT
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
					   AND ISNULL(D.CELL_ITEM_ID		,'-')	= ISNULL(TGT.CELL_ITEM_ID		,'-')  
					   AND ISNULL(D.TRANSPORT_MODE_LINE	,'-')	= ISNULL(TGT.TRANSPORT_MODE_LINE,'-')
					   AND ISNULL(D.INCOTERMS			,'-')	= ISNULL(TGT.INCOTERMS			,'-')
					   AND ISNULL(D.BOD_ID				,'-')	= ISNULL(TGT.BOD_ID				,'-')
					   )

  	   print  convert(varchar(30), getdate(), 121) + N'Delete #tmp_SCP_ANL_PSI_GLOBAL_SMALL2 - 전구간0인 cp 생산 measure-End' ;

		-- Begin 2023.08.03 외주 TCO 모델 출하정보로 도착지 생산 정보 생성한 데이터 삭제 (Production  및 해당 production 으로 인해 생성된 생산 관련 measure들) 
  		print  convert(varchar(30), getdate(), 121) + N'#tmp_OSP_CELL_TARGET_TO_DELETE - Start ' 
        IF OBJECT_ID('tempdb..#tmp_OSP_CELL_TARGET_TO_DELETE') IS NOT NULL
           DROP TABLE #tmp_OSP_CELL_TARGET_TO_DELETE  ;

		 SELECT DISTINCT FROM_SITE, ITEM_ID, S.OSP_YN
		   INTO #tmp_OSP_CELL_TARGET_TO_DELETE
	     FROM SCP_ANL_PSI_PRODUCTION A WITH (NOLOCK)
			   INNER JOIN SCM_MST_SITE S WITH(NOLOCK) 
					  ON S.DIVISION_ID = A.DIVISION_ID
					 AND S.SCM_SITE_ID = A.PSI_VALUE	-- 라인이 아닌 사이트 정보가 있는 건 (PSI PRODUCTION에서 추가한 데이터)
					 AND A.PSI_TYPE    = 'P'			-- 생산 
          WHERE 1 = 1                    
             AND A.DIVISION_ID           = @p_division_id                    
             AND A.PLAN_START_YYYYMMDD   = @p_plan_start_yyyymmdd                 
             AND A.PLAN_TYPE             = @p_plan_type                    
             AND A.SEQ                   = @p_seq      
             AND A.PSI_VALUE             <> 'DIO'  
             AND A.PSI_VALUE             <> 'ISSUM' 
			;
				
			DELETE TGT
		    FROM  #tmp_SCP_ANL_PSI_GLOBAL_SMALL2  AS TGT
				 INNER JOIN #tmp_OSP_CELL_TARGET_TO_DELETE TD
						 ON TD.FROM_SITE	= TGT.FROM_SITE
						AND TD.ITEM_ID		= TGT.ITEM_ID
				 INNER JOIN SCP_MST_FINAL_ITEM FI WITH(NOLOCK)
						 ON FI.DIVISION_ID		= TGT.DIVISION_ID
						AND FI.ITEM_ID			= TGT.ITEM_ID 
						AND FI.OPERATION_GROUP	= 'A'
						AND FI.ATTRIBUTE8		= 'CP' -- 외주TCO.CP 또는 사내CP
		   WHERE 1=1
			  AND TGT.MEASURE in ( 'PRODUCTION', 'ACTIVATE_COMPLETED', 'CHAR_AVAILABLE', 'ACTIVATE_PROGRESS' ,'MODEL_INVENTORY' ,'DIO', 'INCP_MODEL_INVENTORY', 'OWMS_MODEL_INVENTORY') -- 생산관련 measure 
			;
          -------------------------------------------------------------------------------------------------------------
          -- 2025.06.26   KIMCD       PJ2024A332 독립적 Planning 체계 및 Master Validation UI 구축
		  -- 'INCP_MODEL_INVENTORY', 'OWMS_MODEL_INVENTORY' 유형 추가
          -------------------------------------------------------------------------------------------------------------
		-- End 2023.08.03 외주 TCO 모델 출하정보로 도착지 생산 정보 생성한 데이터 삭제 (Production  및 해당 production 으로 인해 생성된 생산 관련 measure들) 

			UPDATE TGT
			SET    ATTRIBUTE4 = IC.CLASS_NAME
		    FROM  #tmp_SCP_ANL_PSI_GLOBAL_SMALL2  AS TGT
				 INNER JOIN SCP_MST_FINAL_ITEM FI WITH(NOLOCK)
						 ON FI.DIVISION_ID		= TGT.DIVISION_ID
						AND FI.ITEM_ID			= TGT.CELL_ITEM_ID
				 INNER JOIN SCM_MST_ITEM_CLASS_SN IC WITH(NOLOCK)
						 ON FI.ITEM_CLASS		= IC.CLASS_ID
			WHERE 1=1
			;
			-- 합산 정보에 ATTRIBUTE4로 갱신. 정렬 순서도 변경
			UPDATE TGT
			SET    ATTRIBUTE4  = TGT.CELL_ITEM_ID
			      ,ATTRIBUTE10 = '4'
		    FROM  #tmp_SCP_ANL_PSI_GLOBAL_SMALL2  AS TGT
				 INNER JOIN SCM_MST_ITEM_CLASS_SN IC WITH(NOLOCK)
						 ON IC.CLASS_NAME		= TGT.CELL_ITEM_ID
			WHERE 1=1
			;
          -------------------------------------------------------------------------------------------------------------
          -- 2025.06.26   KIMCD       PJ2024A332 독립적 Planning 체계 및 Master Validation UI 구축
		  -- CELL ITEM CLASS NAME 갱신 추가
          -------------------------------------------------------------------------------------------------------------
          -------------------------------------------------------------------------------------------------------------                                       
          -- 10. SCP_ANL_PSI_GLOBAL_SMALL 삭제                         
          -------------------------------------------------------------------------------------------------------------              
            -- 속도 계선
            
            --PRINT '[' + CONVERT(VARCHAR(100), GETDATE(),120) + ']'
            --SELECT 1
            --WHILE @@ROWCOUNT > 0  -- UPDATE  @@ROWCOUNT
            --BEGIN
            --  DELETE TOP (1000)
            --  FROM SCP_ANL_PSI_GLOBAL_SMALL             
            --  WHERE DIVISION_ID = @p_division_id AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd AND PLAN_TYPE = @p_plan_type AND SEQ = @p_seq        
            --END

			-- 2021.11.11 튜닝개선안에 따른 삭제구분 변경
            WHILE(1 = 1)
            BEGIN
              DELETE TOP (10000)
              FROM dbo.SCP_ANL_PSI_GLOBAL_SMALL             
              WHERE DIVISION_ID = @p_division_id AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd AND PLAN_TYPE = @p_plan_type AND SEQ = @p_seq;

              IF(@@ROWCOUNT = 0)
              BEGIN
               BREAK;
              END
            END
            --PRINT '[' + CONVERT(VARCHAR(100), GETDATE(),120) + ']'
            -- [40][1054::PR::1][35:45] 10000
            -- [40][1054::PR::1][33:28] 1000    [40][1054::PR::1][60:08]
            -- [40][1054::PR::1][25:54] 500

            -- TRUNCATE TABLE SCP_ANL_PSI_GLOBAL_SMALL    -- [40][1052::PR::1][06:57]
            -- sp_spaceused SCP_ANL_PSI_GLOBAL_SMALL      -- 2519503
          -------------------------------------------------------------------------------------------------------------                            
          -- 11. SCP_ANL_PSI_GLOBAL_SMALL 입력                           
          -------------------------------------------------------------------------------------------------------------                      
          INSERT INTO /* SCP_ANL_PSI_GLOBAL_SMALL */  dbo.SCP_ANL_PSI_GLOBAL_SMALL          WITH (TABLOCK)                 
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
					  ,ATTRIBUTE3 -- 2023.07.28 활성화코드 분리 대응
					  ,ATTRIBUTE4 -- 2025.06.26   KIMCD       PJ2024A332 독립적 Planning 체계 및 Master Validation UI 구축 CELL ITEM CLASS NAME 추가
                      ,ATTRIBUTE9              
                      ,ATTRIBUTE10
                       )                          

-- KSW 2021-03-24 PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 :: 0 값 삭제처리 추가 - start
-- OLD
                    --SELECT                
                    --       DIVISION_ID             
                    --      ,PLAN_START_YYYYMMDD     
                    --      ,PLAN_TYPE               
                    --      ,SEQ                     
                    --      ,OPERATION_GROUP         
                    --      ,ITEM_ID     
                    --      ,CELL_ITEM_ID              
                    --      ,ISNULL(TO_SITE,'')
                    --      ,TO_BOH_QTY              
                    --      ,ISNULL(INCOTERMS, '-')   
                    --      ,FROM_SITE               
                    --      ,FROM_BOH_QTY            
                    --      ,ISNULL(BOD_ID,'-')                    
                    --      ,ISNULL(TRANSPORT_MODE_LINE,'-') 
                    --      ,MEASURE                 
                    --      ,YYYYMMDD                
                    --      ,SUM(ISNULL(QTY,0)) AS QTY                                             
                    --      ,@v_batch_user AS CREATED_BY                          
                    --      ,GETDATE()     AS CREATION_DATE                          
                    --      ,@v_batch_user AS LAST_UPDATED_BY                          
                    --      ,GETDATE()     AS LAST_UPDATED_BY        
                    --      ,ATTRIBUTE1          
                    --      ,ATTRIBUTE2
                    --      ,ATTRIBUTE9   
                    --      ,ATTRIBUTE10
                    --  FROM #tmp_SCP_ANL_PSI_GLOBAL_SMALL WITH (NOLOCK)                          
                    -- WHERE 1=1                          
                    -- AND YYYYMMDD < @v_DD     
                    -- AND CELL_ITEM_ID IS NOT NULL   
                    -- AND MEASURE <> '-'
                    -- GROUP BY 
                    --       DIVISION_ID             
                    --      ,PLAN_START_YYYYMMDD     
                    --      ,PLAN_TYPE               
                    --      ,SEQ                     
                    --      ,OPERATION_GROUP         
                    --      ,ITEM_ID    
                    --      ,CELL_ITEM_ID                 
                    --      ,TO_SITE                 
                    --      ,TO_BOH_QTY              
                    --      ,ISNULL(INCOTERMS, '-')             
                    --      ,FROM_SITE               
                    --      ,FROM_BOH_QTY            
                    --      ,ISNULL(BOD_ID,'-')                  
                    --      ,ISNULL(TRANSPORT_MODE_LINE,'-')    
                    --      ,MEASURE                 
                    --      ,YYYYMMDD              
                    --      ,ATTRIBUTE1  
                    --      ,ATTRIBUTE2
                    --      ,ATTRIBUTE9 
                    --      ,ATTRIBUTE10
                    --      ;
			SELECT   DT.DIVISION_ID             
					,DT.PLAN_START_YYYYMMDD     
					,DT.PLAN_TYPE               
					,DT.SEQ                     
					,DT.OPERATION_GROUP         
					,DT.ITEM_ID     
					,DT.CELL_ITEM_ID              
					,DT.TO_SITE
					,DT.TO_BOH_QTY              
					,DT.INCOTERMS
					,DT.FROM_SITE               
					,DT.FROM_BOH_QTY            
					,DT.BOD_ID               
					,DT.TRANSPORT_MODE_LINE
					,DT.MEASURE                 
					,DT.YYYYMMDD    
					,SUM(DT.QTY)   AS QTY                                             
					,@v_batch_user AS CREATED_BY                          
					,GETDATE()     AS CREATION_DATE                          
					,@v_batch_user AS LAST_UPDATED_BY                          
					,GETDATE()     AS LAST_UPDATED_DATE        
					,DT.ATTRIBUTE1          
					,DT.ATTRIBUTE2
					,MAX(DT.ATTRIBUTE3)	AS ATTRIBUTE3 -- 2023.07.28 활성화코드 분리 대응
					,MAX(DT.ATTRIBUTE4) AS ATTRIBUTE4 -- 2025.06.26   KIMCD       PJ2024A332 독립적 Planning 체계 및 Master Validation UI 구축 CELL ITEM CLASS NAME 추가
					,DT.ATTRIBUTE9   
					,DT.ATTRIBUTE10
			  FROM (
					SELECT   ZZ.DIVISION_ID             
							,ZZ.PLAN_START_YYYYMMDD     
							,ZZ.PLAN_TYPE               
							,ZZ.SEQ                     
							,ZZ.OPERATION_GROUP         
							,ZZ.ITEM_ID     
							,ZZ.CELL_ITEM_ID              
							,ZZ.TO_SITE
							,ZZ.TO_BOH_QTY              
							,ZZ.INCOTERMS
							,ZZ.FROM_SITE               
							,ZZ.FROM_BOH_QTY            
							,ZZ.BOD_ID               
							,ZZ.TRANSPORT_MODE_LINE
							,ZZ.MEASURE                 
							,(CASE WHEN ZZ.QTY = 0.0 THEN ZZ.PLAN_START_YYYYMMDD ELSE ZZ.YYYYMMDD END) AS YYYYMMDD    
							,ZZ.QTY                                                  
							,ZZ.ATTRIBUTE1          
							,ZZ.ATTRIBUTE2
							,ZZ.ATTRIBUTE3  -- 2023.07.28 활성화코드 분리 대응
							,ZZ.ATTRIBUTE4  -- 2025.06.26   KIMCD       PJ2024A332 독립적 Planning 체계 및 Master Validation UI 구축 CELL ITEM CLASS NAME 추가
							,ZZ.ATTRIBUTE9   
							,ZZ.ATTRIBUTE10
					  FROM (
							SELECT                
								   DIVISION_ID             
								  ,PLAN_START_YYYYMMDD     
								  ,PLAN_TYPE               
								  ,SEQ                     
								  ,OPERATION_GROUP         
								  ,ITEM_ID     
								  ,CELL_ITEM_ID              
								  ,ISNULL(TO_SITE,'')     AS TO_SITE
								  ,TO_BOH_QTY              
								  ,ISNULL(INCOTERMS, '-') AS INCOTERMS
								  ,FROM_SITE               
								  ,FROM_BOH_QTY            
								  ,ISNULL(BOD_ID,'-')     AS BOD_ID                  
								  ,ISNULL(TRANSPORT_MODE_LINE,'-')  AS TRANSPORT_MODE_LINE
								  ,MEASURE                 
								  ,YYYYMMDD                
								  ,SUM(ISNULL(QTY,0)) AS QTY                                                    
								  ,ATTRIBUTE1          
								  ,ATTRIBUTE2
								  ,MAX(ATTRIBUTE3)	 AS ATTRIBUTE3  -- 2023.07.28 활성화코드 분리 대응
								  ,MAX(ATTRIBUTE4)   AS ATTRIBUTE4  -- 2025.06.26   KIMCD       PJ2024A332 독립적 Planning 체계 및 Master Validation UI 구축 CELL ITEM CLASS NAME 추가
								  ,ATTRIBUTE9   
								  ,ATTRIBUTE10
							  --FROM #tmp_SCP_ANL_PSI_GLOBAL_SMALL WITH (NOLOCK)
							  FROM #tmp_SCP_ANL_PSI_GLOBAL_SMALL2 WITH (NOLOCK)
							 WHERE 1=1                          
							 AND YYYYMMDD < @v_DD     
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
						   ) ZZ
			       ) DT
				GROUP BY 
					DT.DIVISION_ID             
					,DT.PLAN_START_YYYYMMDD     
					,DT.PLAN_TYPE               
					,DT.SEQ                     
					,DT.OPERATION_GROUP         
					,DT.ITEM_ID    
					,DT.CELL_ITEM_ID                 
					,DT.TO_SITE                 
					,DT.TO_BOH_QTY              
					,DT.INCOTERMS
					,DT.FROM_SITE               
					,DT.FROM_BOH_QTY            
					,DT.BOD_ID                
					,DT.TRANSPORT_MODE_LINE
					,DT.MEASURE                 
					,DT.YYYYMMDD              
					,DT.ATTRIBUTE1  
					,DT.ATTRIBUTE2
					,DT.ATTRIBUTE9 
					,DT.ATTRIBUTE10
                          ;

-- KSW 2021-03-24 PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 :: 0 값 삭제처리 추가 - end

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
        IF OBJECT_ID('tempdb..#tmp_SCP_ANL_PSI_GLOBAL_SMALL') IS NOT NULL
            DROP TABLE #tmp_SCP_ANL_PSI_GLOBAL_SMALL

        IF OBJECT_ID('tempdb..#tmp_SCP_ANL_PSI_GLOBAL_SMALL2') IS NOT NULL
		    DROP TABLE #tmp_SCP_ANL_PSI_GLOBAL_SMALL2
            
        IF OBJECT_ID('tempdb..#YYYYMMDD') IS NOT NULL
            DROP TABLE #YYYYMMDD
            
        IF OBJECT_ID('tempdb..#BOH') IS NOT NULL
            DROP TABLE #BOH
            
        IF OBJECT_ID('tempdb..#tmp_SCP_ANL_PSI_GLOBAL_SMALL_DIO') IS NOT NULL
            DROP TABLE #tmp_SCP_ANL_PSI_GLOBAL_SMALL_DIO
            
        IF OBJECT_ID('tempdb..#Tbl_DIO') IS NOT NULL
            DROP TABLE #Tbl_DIO
            
        IF OBJECT_ID('tempdb..#Tbl_SCP_ANL_PSI_GLOBAL_SMALL_DIO') IS NOT NULL
            DROP TABLE #Tbl_SCP_ANL_PSI_GLOBAL_SMALL_DIO        
                        
		-- begin 2023.07.28 활성화코드 분리 대응 
		IF OBJECT_ID('TEMPDB..#TMP_CELL_BOM_40') IS NOT NULL
			DROP TABLE #TMP_CELL_BOM_40;
		IF OBJECT_ID('TEMPDB..#TMP_TARGET_TO_CONVERT') IS NOT NULL
			DROP TABLE #TMP_TARGET_TO_CONVERT;
        IF OBJECT_ID('tempdb..#tgt_CELL_PRODUCT_MODEL_INVENTORY') IS NOT NULL 
			DROP TABLE #tgt_CELL_PRODUCT_MODEL_INVENTORY ;
		IF OBJECT_ID('tempdb..#tmp_TARGET_TO_DELETE') IS NOT NULL
		   DROP TABLE #tmp_TARGET_TO_DELETE  ;
		-- end 2023.07.28 활성화코드 분리 대응 

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

   
