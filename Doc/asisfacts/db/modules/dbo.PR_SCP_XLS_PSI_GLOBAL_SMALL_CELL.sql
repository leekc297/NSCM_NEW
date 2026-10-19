
  
/*      
 * Program ID   : PR_SCP_XLS_PSI_GLOBAL_SMALL_CELL        
 * Description  : PR_SCP_XLS_CREATE_DATA 에서 호출함.      
 * OutTable     :      
 * Execute      : 
    -- DELETE FROM SCM_SYS_LOG_BATCH where CREATED_BY ='kth'
    EXEC PR_SCP_XLS_PSI_GLOBAL_SMALL_CELL
                                 @p_plan_cycle          = 'WEEKLY'
                               , @p_plan_start_yyyymmdd = '20190107'
                               , @p_plan_id             = '1060'
                               , @p_modeling_id         = '2'
                               , @p_seq                 = '1'
                               , @p_plan_type           = 'PR'
                               , @p_master_id           = '81::WEEKLY'
                               , @p_division_id         = '81'
                               , @p_engine_plan_id      = '1060::PR::1'
                               , @p_user_id             = 'KTH' 
    SELECT * FROM SCM_SYS_LOG_BATCH  where PROGRAM_NAME ='PR_SCP_XLS_PSI_GLOBAL_SMALL_CELL' order by CREATION_DATE desc

 * Program History      
 *===================================================================================================      
 *   Date       In Charge      Description      
 *===================================================================================================      
 * 2019.03.07   KTH         Initial Release PJ20170278 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트  
 * 2019.03.13   KTH         소스를 PLN에서 ANL로 변경
 * 2019.03.20   KTH         TACT TIME 변경시 변경된 ITEM_ID에 한해서 재실행 로직 반영, @p_update 추가
                            Line 추가 로직 변경 
 * 2019.03.22   KTH         신규 추가된 Line Load율 반영로직 추가
 * 2019.05.13   KTH         SHORT_DEMAND에_대하여_CELL_SHIP_REQ_생성방안
                            SHIP_REQ_PACK 또는 SHIP_REQ_CELL 에 계산함.
 * 2019.05.14   KTH         CELL_FORM_HOLD	  Form Hold
 * 2019.05.21   KTH         LINE LOAD율 로직 변경
 * 2019.05.24   KTH         LT_WEEK   반올림 로직 반영 (3보다 크면 1추 추가)
 * 2019.06.04   KTH         SHORT_DEMAND에_대하여_CELL_SHIP_REQ_로직 수정
 * 2019.06.10   KTH         YIELD 수정 (PLANT_SITE_ID 조건 추가)
 * 2019.06.11   KTH         SHORT_DEMAND에_대하여_CELL_SHIP_REQ_생성방안 로직 수정
                            (SHIP_REQ_PACK_SHORT,SHIP_REQ_CELL_SHORT MEASURE 추가)
                             주석처리 AND PROBLEM_DESCR       IN ( 'CAPA. SHORT(PET)','PREFER NO RESOURCE')
 * 2019.06.12   KTH         Line Load율 로직 변경
 * 2019.06.18   KTH         엔진 생산없이 TACT_TIME만 존재하는 ITEM_ID 추가 로직 반영
 * 2019.06.19   KTH         CELL_FORM_HOLD  SITE_ID GROUP 조건 수정
 * 2019.07.05   KTH         LT_WEEK   올림 로직 수정
 * 2019.07.30   KTH         SHIP_REQ_CELL,SHIP_REQ_PACK :'SHIP_PLAN_AMEND'-->'SHIP_REQ' 로 변경
 * 2019.07.31   KTH         SHIP_REQ_PACK은 'SHIP_REQ' --> 'SHIP_PLAN_AMEND' 로 변경
 *                          LT로직 변경
 * 2019.09.02   KTH         LT 로직 변경(CELL_ITEM_ID 중 LT큰 값으로 계산)
 * 2019.09.03   KTH         [CSR ID:4073270] Global PSI의 Pack Ship REQ 기반의 Cell Simulator Ship REQ 생성
                            SHIP_REQ_PACK로직 변경
                            (SCP_ANL_PSI_GLOBAL_SMALL의 PACK 'SHIP_REQ'에 기초재고 차감후 CELL BOM 반영후(CELL 재고 차감) CELL, LT 추가 한 값)
 * 2019.10.29   KTH         SHIP_REQ_PACK로직 수정
 * 2019.11.18   KTH         SSP_MODIFY_YIELD가 0이거나 1 이면, 0이나 1을 제외한 SSP_MODIFY_YIELD의 평균값
                            YIELD가 0일 경우는, 0이나 1을 제외한 소형 전체 SSP_MODIFY_YIELD의 평균값
 * 2019.11.20   KTH         SHIP_REQ_PACK @p_plan_start_yyyymmdd 보다 적은 일자일 경우 SUM반영 로직 추가
 * 2019.11.25   KTH         LT DAY 값을 ATTRIBUTE3에 반영, MEASURE명칭 수정(BOFORE_BOXING --> BEFORE_BOXING)
 * 2020.01.07   KTH         #Rn 테이블 변경
 * 2020.02.06   KTH         ESS 외주 Line별 생산 Target 관련 OSP_YN로직 수정
 * 2020.05.12   KTH         [C20200422-000361] GSCM 시스템의 보류재고 감안한 계획 수립을 위한 시물레이션 변경 요청
 * 2020.07.06   KSW         전지 공급 대응력 향상을 위한 SCM 관리 체계 개선 - DIO 수정 관련
 * 2020.07.13   KSW         전지 공급 대응력 향상을 위한 SCM 관리 체계 개선 - DIO 수정 관련 - 기준/최소 쿼리에서 YYYYMM -> YYYYQ 으로 변경
 * 2021-05-25   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 플랜 대응
 * 2021.08.25   KSW         PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 - SCP_MST_BOD_V --> SCP_MST_BOD_N_V
 * 2025.08.01   hrkim	    PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 : Cell 완성 공정 하드코딩 변경
 */    

--DROP PROC dbo.PR_SCP_XLS_PSI_GLOBAL_SMALL_CELL
CREATE PROCEDURE [dbo].[PR_SCP_XLS_PSI_GLOBAL_SMALL_CELL]
(       
      @p_plan_cycle           NVARCHAR(0150)        
    , @p_plan_start_yyyymmdd  NVARCHAR(0008)        
    , @p_plan_id              NVARCHAR(4000)        
    , @p_modeling_id          NVARCHAR(4000)        
    , @p_seq                  NVARCHAR(4000)        
    , @p_plan_type            NVARCHAR(4000)        
    , @p_master_id            NVARCHAR(4000)        
    , @p_division_id          NVARCHAR(0030)        
    , @p_engine_plan_id       NVARCHAR(4000)        
    , @p_update               NVARCHAR(4000)  = 'N'
    , @p_user_id              NVARCHAR(0150)  = 'SCP_batch'        
    ---- , @p_debug       INT OUTPUT      
)       
AS        
  BEGIN      
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;      
    SET NOCOUNT ON;      
    SET XACT_ABORT ON;      
    --SET ANSI_WARNINGS OFF;      
	SET ANSI_WARNINGS ON;     
    SET ANSI_NULLS ON;
      
    -- LOG 용 변수 설정      
    DECLARE @v_batch_user   NVARCHAR(150) = N'SCP_batch';        
    SET @v_batch_user                     = @p_user_id      
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SCP_XLS_PSI_GLOBAL_SMALL_CELL';      
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...      
    DECLARE @n_log_count    INTEGER = 0;      
    DECLARE @v_log_message  NVARCHAR(1000);      
    DECLARE @v_description  NVARCHAR(500);    
    DECLARE @v_table_id     NVARCHAR(150) = N'SCM_SYS_LOG_BATC';   
    DECLARE @d_event_date   DATETIME;   
       
	------------------------------------------------------------------------------------------------------------------
	-- [PJ20257329] 2025.08.01  Cell 완성 공정 하드코딩 변경
	print  convert(varchar(30), getdate(), 121) + N' SCP Cell Final 공정 정보 - Cell Packaging/Assembly' 
	------------------------------------------------------------------------------------------------------------------
	IF OBJECT_ID('TEMPDB..#SCP_CELL_FINAL_OPERATION') IS NOT NULL DROP TABLE #SCP_CELL_FINAL_OPERATION
	SELECT DISTINCT SEGMENT1 AS OPERATION_ID
	  INTO #SCP_CELL_FINAL_OPERATION
	  FROM SCM_ADM_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
	 WHERE 1=1
	   AND LK.LOOKUP_TYPE = 'SCP_PLAN_OPERATION'
	   AND LK.SEGMENT3	  = 'A'	 -- 공정그룹 (Cell)
	   AND LK.ATTRIBUTE1  = 'Y'	 -- Final Operation
	------------------------------------------------------------------------------------------------------------------

  
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

    DECLARE @p_program_id   NVARCHAR(30) = 'XLSPSI03'          
    DECLARE @p_to_yyyymmdd  VARCHAR(8)   = ''		--CONVERT(VARCHAR(8), DATEADD(day, 728, @p_plan_start_yyyymmdd), 112)
    DECLARE @p_cutoff_date  VARCHAR(8)   =  CONVERT(VARCHAR(8), DATEADD(day,  -1, @p_plan_start_yyyymmdd), 112)

    DECLARE @v_Max_xls_key1 INTEGER = 0;  -- @p_update가 'Y' 일경우  전체 xls_key1 MAX

    IF @p_update = 'Y'
      BEGIN
        SELECT @v_Max_xls_key1 = ISNULL(MAX(xls_key1),0) +1
          FROM SCP_XLS_PSI_GLOBAL_SMALL_CELL  WITH (NOLOCK)
      END

    --DECLARE @debug_mode            NVARCHAR(30) = 'T'
        BEGIN TRY        
          BEGIN        

			-------------------------------------------------------------------------------------------------------------
			-- PLAN 기간설정 - 2021.11.19
			-------------------------------------------------------------------------------------------------------------
		  	SELECT @p_to_yyyymmdd = p.horizon_end_date
			FROM   dbo.scm_mst_plan p WITH(NOLOCK)
			WHERE  p.division_id = @p_division_id
			AND    p.plan_id     = (SELECT max(plan_id) FROM dbo.scm_mst_plan p WITH(NOLOCK) WHERE division_id = @p_division_id and plan_id < 9999)
			AND    p.plan_cycle  = 'WEEKLY' 
			;	

            -------------------------------------------------------------------------------------------------------------         
            -- MEASURE 정보
            -------------------------------------------------------------------------------------------------------------              
	            IF OBJECT_ID('tempdb..#MEASURE') IS NOT NULL	
	              DROP TABLE #MEASURE

	            /* MEASURE 세팅값 추출 */ 
--              INSERT INTO #MEASURE
	            SELECT M.COLUMN_NAME, M.COLUMN_LABEL_NAME,M.SORT_ORDER_NO,(CASE WHEN ATTRIBUTE1 ='GROUP' THEN 'G' ELSE 'C' END) AS DIV
              INTO #MEASURE
  	          FROM SCM_MST_SHEET_MEASURE M WITH(NOLOCK)
	            WHERE M.PROGRAM_ID      = @p_program_id
	              AND M.VALID_YN        = 'Y'


            -------------------------------------------------------------------------------------------------------------         
            -- 기준 ITEM_ID 생성
            -------------------------------------------------------------------------------------------------------------              

              IF OBJECT_ID('tempdb..#ITEM_ID') IS NOT NULL                  
              DROP TABLE #ITEM_ID  

              -- 최종 CELL ITEM별 MEASURE를 한벌만들 대상추출 
              SELECT @p_division_id AS DIVISION_ID, SUB.CELL_ITEM_ID, @p_plan_start_yyyymmdd AS YYYYMMDD 
              INTO #ITEM_ID
              FROM
              ( 
                -- 팩에 공급할 셀 출하요청
                SELECT DISTINCT (CASE WHEN Y.TCO_CELL_YN = 'Y' THEN Y.ATTRIBUTE1 ELSE A.ITEM_ID END ) AS CELL_ITEM_ID
                FROM SCP_ANL_SHIPMENT_PLAN_SEMI A WITH(NOLOCK)	
                     INNER JOIN SCP_MST_FINAL_ITEM Y WITH(NOLOCK)
                             ON 0 = 0
                            AND A.DIVISION_ID = Y.DIVISION_ID
                            AND A.ITEM_ID     = Y.ITEM_ID
	                WHERE A.DIVISION_ID			    =  @p_division_id
		              AND A.PLAN_START_YYYYMMDD	  =  @p_plan_start_yyyymmdd
		              AND A.PLAN_TYPE				      =  @p_plan_type
		              AND A.SEQ					          =  @p_seq
		              AND A.YYYYMMDD             >=  @p_plan_start_yyyymmdd
		              AND A.YYYYMMDD             <   @p_to_yyyymmdd
                  AND A.MEASURE              =  'SHIP_PLAN_AMEND' --
                  AND A.TO_SITE           LIKE '%-P'
                  AND A.OPERATION_GROUP       = 'A'
                UNION 
                -- 셀 판매를 위한 출하요청
                SELECT DISTINCT (CASE WHEN Y.TCO_CELL_YN = 'Y' THEN Y.ATTRIBUTE1 ELSE A.ITEM_ID END ) AS CELL_ITEM_ID
                FROM SCP_ANL_SHIPMENT_PLAN_FG A WITH(NOLOCK)	
                  INNER JOIN SCP_MST_FINAL_ITEM Y WITH(NOLOCK)
                         ON 0 = 0
                        AND A.DIVISION_ID = Y.DIVISION_ID
                        AND A.ITEM_ID     = Y.ITEM_ID
	                INNER JOIN SCM_MST_SITE S WITH (NOLOCK)
                      ON A.DIVISION_ID			  = S.DIVISION_ID
                      AND S.SITE_TYPE         ='SALES'
                      AND A.TO_SITE           = S.SCM_SITE_ID
	                WHERE A.DIVISION_ID			    =  @p_division_id
		              AND A.PLAN_START_YYYYMMDD	  =  @p_plan_start_yyyymmdd
		              AND A.PLAN_TYPE				      =  @p_plan_type
		              AND A.SEQ					          =  @p_seq
		              AND A.YYYYMMDD             >=  @p_plan_start_yyyymmdd
		              AND A.YYYYMMDD             <   @p_to_yyyymmdd
                  AND A.MEASURE              =  'SHIP_REQ' --'SHIP_PLAN_AMEND' 
                  AND A.BIZ_TYPE             = 'A'
                ) SUB
                ;

                IF @p_update = 'Y'
                BEGIN
                  DELETE FROM #ITEM_ID  
                  WHERE CELL_ITEM_ID NOT IN (SELECT DISTINCT ITEM_ID FROM SCP_XLS_CELL_PROD_Line_V WITH (NOLOCK) )
                END
                  

            -------------------------------------------------------------------------------------------------------------         
            -- #PSI_GLOBAL_SMALL_CELL  TEMP 테이블 생성
            -------------------------------------------------------------------------------------------------------------     
              IF OBJECT_ID('tempdb..#PSI_GLOBAL_SMALL_CELL') IS NOT NULL      
	              DROP TABLE #PSI_GLOBAL_SMALL_CELL;        

	            CREATE TABLE #PSI_GLOBAL_SMALL_CELL (
					DIVISION_ID		      NVARCHAR(060)	
                ,CELL_TYPE_GROUP_CODE NVARCHAR(1)
                ,CELL_ITEM_ID			    NVARCHAR(100)
		        ,MEASURE			        NVARCHAR(100)
                ,COLUMN_LABEL_NAME	  NVARCHAR(300)
                ,SITE_ID			        NVARCHAR(060)
                ,PROD_LINE            NVARCHAR(50)
                ,YIELD			          NUMERIC(20,10)
                ,LT_WEEK      		    INT
                ,BOH  			          NUMERIC(20,10)
		        ,YYYYMMDD			        NVARCHAR(010)
--		        ,QTY				          NUMERIC(20,10)
		        ,QTY				          BIGINT
		        ,SORT_ORDER_NO		    INT		            
                ,ATTRIBUTE1			      NVARCHAR(150)
		        ,ATTRIBUTE9			      NVARCHAR(150)   -- OPERATION_ID
	            );


              
            -------------------------------------------------------------------------------------------------------------------------         
            -- MEASURE 추가 공통
            /*
                SHIP_REQ_TOTAL	    Ship Req Total	             10	  TOTAL	      CALC
                SHIP_REQ_PACK	      Ship Req Pack	               20	  TOTAL	      DB
                SHIP_REQ_PACK_SHORT Ship Req(Pack Short)	       25	  TOTAL	      DB
                SHIP_REQ_CELL	      Ship Req Cell	               30	  TOTAL	      DB
                SHIP_REQ_CELL_SHORT	    Ship Req(Cell Short)     35	  TOTAL	      DB
                RTF	                RTF	                         40	  TOTAL	      CALC
                GAP	                GAP	                         50	  TOTAL	      CALC
                INVENTORY	          INVENTORY	                   60	  TOTAL	      CALC
                SHIP_AVAILABLE	    Ship Available	             70	  TOTAL	      DB,CALC
                BOXING_COMPLETE     Boxing Complete	             80	  TOTAL	      CALC
                BEFORE_BOXING	      Before Boxing	               90	  TOTAL	      DB,CALC

                CELL_FORM_HOLD	    Form Hold                    95	  TOTAL	      DB,CALC
                
                ETA_PAST	          Boxing Complette ETA(Past)	100	  TOTAL	      DB
                ETA_PROD	          Boxing Complette ETA(Prod)	110	  TOTAL	      CALC
                DIO	                DIO	                        120	  TOTAL	      CALC
                PROD_TOTAL	        Production(Total)	          200	  SITE	      CALC
            */
            -------------------------------------------------------------------------------------------------------------------------
 
            -- MEASURE SET 생성
            INSERT #PSI_GLOBAL_SMALL_CELL
            SELECT  DISTINCT            
                    SUB.DIVISION_ID								
			            , Y.CELL_TYPE_GROUP_CODE						
			            , SUB.CELL_ITEM_ID							
			            , SUB.MEASURE
                  , SUB.COLUMN_LABEL_NAME
			            , '' AS SITE_ID										
			            , '' AS PROD_LINE									
			            , 0 AS YIELD 										
			            , 0 AS LT_WEEK 
                  , 0 AS BOH										
			            , A.YYYYMMDD	
                  , 0    AS QTY
			            , SUB.SORT_ORDER_NO		
                  , '' AS ATTRIBUTE1										
			            , '' AS ATTRIBUTE9										
                     FROM                 
                      (  -- 364 DAYS      
                                     SELECT C.BASIS_YYYYMMDD AS YYYYMMDD          
                                       FROM SCM_SYS_CALENDAR_M    C WITH(NOLOCK)         
                                      WHERE 1=1      
                                        AND C.BASIS_YYYYMMDD >= @p_plan_start_yyyymmdd       
                                        AND C.BASIS_YYYYMMDD <  @p_to_yyyymmdd  
                                  ) A,  
                         (              
                            SELECT  DISTINCT  X.DIVISION_ID								
			                                      , X.CELL_ITEM_ID							
                                            , M.COLUMN_NAME AS MEASURE
                                            , M.COLUMN_LABEL_NAME			
			                                      , M.SORT_ORDER_NO				
                                            , X.YYYYMMDD
                                FROM #ITEM_ID X WITH(NOLOCK)  
                                LEFT OUTER JOIN #MEASURE M WITH (NOLOCK) 
                                ON DIV ='C'
                         ) SUB                
                       INNER JOIN SCP_MST_FINAL_ITEM Y WITH(NOLOCK)
                               ON 0 = 0
                              AND SUB.DIVISION_ID   = Y.DIVISION_ID
                              AND SUB.CELL_ITEM_ID  = Y.ITEM_ID                                   

                WHERE 1=1        
--                AND CELL_ITEM_ID IN ('MCR485780B10')
                --          AND NOT EXISTS (        
                --                           SELECT 'X'        
                --                             FROM #ITEM_ID Z WITH(NOLOCK)        
                --                            WHERE 1=1        
                --                              AND Z.DIVISION_ID              = SUB.DIVISION_ID                                
                --                              AND Z.ITEM_ID                  = SUB.ITEM_ID     
                --                              AND Z.YYYYMMDD                 = SUB.YYYYMMDD       
                --                         );          

           -------------------------------------------------------------------------------------------------------------------------
           -- SHIP_REQ_PACK DATA 반영
           -------------------------------------------------------------------------------------------------------------------------
            
           
            IF OBJECT_ID('tempdb..#SCP_ANL_PSI_GLOBAL_SMALL_REQ_PACK') IS NOT NULL      
	            DROP TABLE #SCP_ANL_PSI_GLOBAL_SMALL_REQ_PACK; 

                SELECT  A.DIVISION_ID
                      ,A.CELL_ITEM_ID
                      ,A.ITEM_ID
                      ,A.FROM_SITE
                      ,A.TO_SITE
                      ,A.TRANSPORT_MODE_LINE
                      ,A.BOD_ID
                      ,A.FROM_BOH_QTY
                      ,NULL AS LT_TOTAL
                      ,A.YYYYMMDD
                      ,CONVERT(BIGINT, A.QTY) AS QTY
                      ,CONVERT(BIGINT, SUM(QTY) OVER (PARTITION BY A.CELL_ITEM_ID,A.ITEM_ID, A.FROM_SITE ORDER BY A.YYYYMMDD))  AS ACC_QTY
                      ,A.MEASURE
                      ,CONVERT(BIGINT, (SUM(QTY) OVER (PARTITION BY A.CELL_ITEM_ID,A.ITEM_ID, A.FROM_SITE ORDER BY A.YYYYMMDD)  - ISNULL(A.FROM_BOH_QTY,0)) )   AS ACC_QTY_FROM_BOH_QTY
                      ,CONVERT(BIGINT, 0.0) AS CELL_QTY_PACK 
                      , CONVERT(BIGINT, 0.0) AS ACC_QTY_FROM_BOH_QTY_CELL
                      ,(CASE WHEN (SUM(QTY) OVER (PARTITION BY A.CELL_ITEM_ID,A.ITEM_ID, A.FROM_SITE ORDER BY A.YYYYMMDD)  - A.FROM_BOH_QTY) > 0 THEN YYYYMMDD ELSE NULL END) AS DT
                      , CONVERT(BIGINT, 0.0) AS QTY_ACC_SUM
                      , CONVERT(BIGINT, 0.0) AS R_QTY
                      , CONVERT(BIGINT, 0.0) AS CELL_QTY
                INTO #SCP_ANL_PSI_GLOBAL_SMALL_REQ_PACK 
                FROM SCP_ANL_PSI_GLOBAL_SMALL A WITH (NOLOCK)
                WHERE A.DIVISION_ID			    =  @p_division_id
		              AND A.PLAN_START_YYYYMMDD =  @p_plan_start_yyyymmdd
		              AND A.PLAN_TYPE				    =  @p_plan_type
		              AND A.SEQ					        =  @p_seq
		              AND A.YYYYMMDD           >=  @p_plan_start_yyyymmdd
		              AND A.YYYYMMDD            <  @p_to_yyyymmdd
                  AND A.MEASURE             = 'SHIP_REQ'
                  AND A.OPERATION_GROUP     = 'P'
--                  AND A.CELL_ITEM_ID        = @p_item_id                          

                  UPDATE A
                  SET A.CELL_QTY_PACK = CONVERT(NVARCHAR(50), CEILING(V.ACCUMULATED_CHILD_QTY))
                      ,A.ACC_QTY_FROM_BOH_QTY_CELL = A.ACC_QTY_FROM_BOH_QTY * CONVERT(NVARCHAR(50), CEILING(V.ACCUMULATED_CHILD_QTY))
                  FROM #SCP_ANL_PSI_GLOBAL_SMALL_REQ_PACK A WITH (NOLOCK)					
                  INNER JOIN DBO.SCM_MST_MODEL_FINAL_ITEM_BOM_V V WITH (NOLOCK)					
                    ON V.DIVISION_ID         = A.DIVISION_ID 
                   AND V.MODEL_ID            = A.ITEM_ID
                   AND V.CHILD_ITEM_ID       = A.CELL_ITEM_ID
                   AND V.OPERATION_GROUP_ID  = 'A'

                  DELETE FROM #SCP_ANL_PSI_GLOBAL_SMALL_REQ_PACK
                  WHERE DT IS NULL
             
                  -- 11396 = 7860 + 3536
                  UPDATE X
                  SET  X.R_QTY        = (CASE WHEN ACC_QTY_FROM_BOH_QTY  - QTY <= 0 THEN  ACC_QTY_FROM_BOH_QTY
                                              WHEN ACC_QTY_FROM_BOH_QTY  - QTY > 0 THEN  QTY 
                                              ELSE 0 END)
                      ,X.CELL_QTY     = (CASE WHEN ACC_QTY_FROM_BOH_QTY  - QTY <= 0 THEN  ACC_QTY_FROM_BOH_QTY
                                              WHEN ACC_QTY_FROM_BOH_QTY  - QTY > 0 THEN  QTY 
                                              ELSE 0 END) * ISNULL(CELL_QTY_PACK,1)
                      ,X.QTY_ACC_SUM  = ACC_QTY_FROM_BOH_QTY - QTY
                  FROM #SCP_ANL_PSI_GLOBAL_SMALL_REQ_PACK X WITH (NOLOCK)

            IF OBJECT_ID('tempdb..#SCP_MST_BOD_V') IS NOT NULL      
	            DROP TABLE #SCP_MST_BOD_V; 

                SELECT DISTINCT X.DIVISION_ID,X.FROM_SITE,X.TO_SITE,X.INCOTERMS,X.TRANSPORT_MODE,X.LT_TOTAL, X.BOD_ID
                INTO #SCP_MST_BOD_V
                FROM SCP_MST_BOD_N_V  X WITH (NOLOCK)		-- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 - SCP_MST_BOD_V --> SCP_MST_BOD_N_V
                WHERE DIVISION_ID = @p_division_id

            IF OBJECT_ID('tempdb..#SCP_ANL_PSI_GLOBAL_SMALL_PACK_LT') IS NOT NULL      
	            DROP TABLE #SCP_ANL_PSI_GLOBAL_SMALL_PACK_LT; 

               SELECT A.DIVISION_ID
                      ,A.PLAN_START_YYYYMMDD
                      ,A.PLAN_TYPE
                      ,A.SEQ
                      --,A.OPERATION_GROUP
                      ,A.ITEM_ID
                      ,A.CELL_ITEM_ID
                      ,A.TO_SITE
                      ,A.FROM_SITE
                      --,A.FROM_BOH_QTY
                      ,ISNULL(B.LT_TOTAL,0) AS  LT_TOTAL
                      --,A.BOD_ID
                      --,A.TRANSPORT_MODE_LINE
                      --,A.MEASURE
                INTO #SCP_ANL_PSI_GLOBAL_SMALL_PACK_LT
                FROM SCP_ANL_PSI_GLOBAL_SMALL A WITH (NOLOCK)
                  LEFT OUTER JOIN #SCP_MST_BOD_V B WITH (NOLOCK)			
                      ON 0 = 0 	
                      AND A.DIVISION_ID  = B.DIVISION_ID 	
                      AND A.BOD_ID       = B.BOD_ID  	
                      AND A.TO_SITE      = B.TO_SITE
                      AND A.FROM_SITE    = B.FROM_SITE  
                    WHERE A.DIVISION_ID			    =  @p_division_id
		                  AND A.PLAN_START_YYYYMMDD =  @p_plan_start_yyyymmdd
		                  AND A.PLAN_TYPE				    =  @p_plan_type
		                  AND A.SEQ					        =  @p_seq
		                  AND A.YYYYMMDD            =  @p_plan_start_yyyymmdd
		              --     AND A.YYYYMMDD            <  @p_to_yyyymmdd
                      AND A.MEASURE             = 'SHIP_REQ'
                      AND A.OPERATION_GROUP     = 'A'
--                      AND A.CELL_ITEM_ID        = @p_item_id


            -- FROM SITE가 여러개 일 경우는 ?
              UPDATE X
                 SET X.LT_TOTAL = ISNULL(Y.LT_TOTAL,0) 
                FROM #SCP_ANL_PSI_GLOBAL_SMALL_REQ_PACK X WITH (NOLOCK)
               INNER JOIN #SCP_ANL_PSI_GLOBAL_SMALL_PACK_LT Y  WITH (NOLOCK)
                  ON 0 = 0
                 AND X.CELL_ITEM_ID  = Y.CELL_ITEM_ID
              -- AND X.ITEM_ID       = Y.ITEM_ID
                 AND X.FROM_SITE     = Y.TO_SITE


                 UPDATE X
                 SET X.LT_TOTAL = 0
                 FROM #SCP_ANL_PSI_GLOBAL_SMALL_REQ_PACK X WITH (NOLOCK)
                 WHERE X.LT_TOTAL IS NULL

            IF OBJECT_ID('tempdb..#SCP_ANL_PSI_GLOBAL_SMALL_PACK_INVERNTORY') IS NOT NULL      
	            DROP TABLE #SCP_ANL_PSI_GLOBAL_SMALL_PACK_INVERNTORY; 

              SELECT DIVISION_ID
                      ,PLAN_START_YYYYMMDD
                      ,PLAN_TYPE
                      ,SEQ
                      ,OPERATION_GROUP
                      ,ITEM_ID
                      ,CELL_ITEM_ID
                      ,TO_SITE
                      ,FROM_SITE
                      ,FROM_BOH_QTY
                      ,BOD_ID
                      ,TRANSPORT_MODE_LINE
                      ,MEASURE
              INTO #SCP_ANL_PSI_GLOBAL_SMALL_PACK_INVERNTORY
              FROM SCP_ANL_PSI_GLOBAL_SMALL A WITH (NOLOCK)
                  WHERE A.DIVISION_ID			    =  @p_division_id
		                AND A.PLAN_START_YYYYMMDD =  @p_plan_start_yyyymmdd
		                AND A.PLAN_TYPE				    =  @p_plan_type
		                AND A.SEQ					        =  @p_seq
		                AND A.YYYYMMDD            =  @p_plan_start_yyyymmdd
		            --     AND A.YYYYMMDD            <  @p_to_yyyymmdd
                    AND A.MEASURE             = 'MODEL_INVENTORY'
                    AND A.OPERATION_GROUP     = 'A'
--                    AND A.CELL_ITEM_ID        = @p_item_id                                        

           
            IF OBJECT_ID('tempdb..#tmp_SCP_ANL_PSI_GLOBAL_SMALL_PACK') IS NOT NULL                  
              DROP TABLE #tmp_SCP_ANL_PSI_GLOBAL_SMALL_PACK  

                 SELECT XXX.DIVISION_ID
                      ,XXX.CELL_ITEM_ID
                      ,XXX.FROM_SITE
                      ,XXX.YYYYMMDD AS REQ_YYYYMMDD
                      ,XXX.MEASURE
                      ,XXX.CELL_QTY
                      ,XXX.ACC_CELL_QTY
                      ,XXX.FROM_BOH_QTY
                      ,XXX.ACC_CELL_QTY_FROM_BOH_QTY 
                      ,(CASE  WHEN XXX.CELL_QTY = 0                 THEN 0
                              WHEN ACC_CELL_QTY_FROM_BOH_QTY = 0    THEN 0
                              WHEN ACC_CELL_QTY_FROM_BOH_QTY < 0    THEN 0
                              WHEN ACC_CELL_QTY_FROM_BOH_QTY > 0    THEN (CASE  WHEN XXX.CELL_QTY = XXX.ACC_CELL_QTY  THEN XXX.ACC_CELL_QTY_FROM_BOH_QTY
                                                                                WHEN XXX.CELL_QTY < XXX.ACC_CELL_QTY  THEN (CASE WHEN XXX.CELL_QTY > XXX.ACC_CELL_QTY_FROM_BOH_QTY THEN XXX.ACC_CELL_QTY_FROM_BOH_QTY 
                                                                                                                                  ELSE XXX.CELL_QTY END ) 
                                                                                WHEN XXX.CELL_QTY > XXX.ACC_CELL_QTY  THEN 0
                                                                          ELSE 0 END) 
                             ELSE 0 END) AS REQ_QTY
                  INTO #tmp_SCP_ANL_PSI_GLOBAL_SMALL_PACK
                  FROM (
 
                       SELECT XX.DIVISION_ID
                          ,XX.CELL_ITEM_ID
                          --,X.ITEM_ID
                          ,XX.FROM_SITE
                          --,X.TO_SITE
                          --,X.BOD_ID
                          ,XX.YYYYMMDD
                          ,XX.MEASURE
                          ,XX.CELL_QTY
                          ,SUM(XX.CELL_QTY) OVER (PARTITION BY XX.CELL_ITEM_ID, XX.FROM_SITE ORDER BY XX.YYYYMMDD) AS ACC_CELL_QTY
                          ,XX.FROM_BOH_QTY
                          ,SUM(XX.CELL_QTY) OVER (PARTITION BY XX.CELL_ITEM_ID, XX.FROM_SITE ORDER BY XX.YYYYMMDD) - ISNULL(XX.FROM_BOH_QTY,0) AS ACC_CELL_QTY_FROM_BOH_QTY 
                      FROM (
                             SELECT X.DIVISION_ID
                                ,X.CELL_ITEM_ID
                                --,X.ITEM_ID
                                ,X.FROM_SITE
                                --,X.TO_SITE
                                ,X.TRANSPORT_MODE_LINE
                                --,X.BOD_ID
                                ,X.LT_TOTAL
                                ,X.DT
                                ,CONVERT(NVARCHAR, (DATEADD(DAY, - X.LT_TOTAL, X.DT)),112) AS YYYYMMDD
                                ,X.MEASURE
                                ,SUM(X.CELL_QTY) AS CELL_QTY
                                ,Y.FROM_BOH_QTY
                            FROM #SCP_ANL_PSI_GLOBAL_SMALL_REQ_PACK X WITH (NOLOCK)
                            INNER JOIN #SCP_ANL_PSI_GLOBAL_SMALL_PACK_INVERNTORY Y WITH (NOLOCK)
                            ON 0 = 0
                            AND X.Division_id = Y.DIVISION_ID
                            AND X.CELL_ITEM_ID = Y.CELL_ITEM_ID
            --                AND X.ITEM_ID = Y.ITEM_ID
                            AND X.FROM_SITE = Y.FROM_SITE
                          GROUP BY 
                          X.DIVISION_ID
                                ,X.CELL_ITEM_ID
                                --,X.ITEM_ID
                                ,X.FROM_SITE
                                --,X.TO_SITE
                                ,X.TRANSPORT_MODE_LINE
                                --,X.BOD_ID
                                ,Y.FROM_BOH_QTY
                                ,X.LT_TOTAL
                                ,X.DT
                                ,CONVERT(NVARCHAR, (DATEADD(DAY, - X.LT_TOTAL, X.DT)),112)
                                ,X.MEASURE
                                ,Y.FROM_BOH_QTY 
                    ) XX
                  ) XXX


              /*
                  SELECT DISTINCT XX.DIVISION_ID
                  ,XX.CELL_ITEM_ID
                  --,XX.ITEM_ID
                  ,XX.FROM_SITE
                  ,XX.TO_SITE
                  ,XX.TRANSPORT_MODE_LINE
                  ,XX.BOD_ID
                  ,XX.FROM_BOH_QTY
                  ,XX.LT_TOTAL
                  ,XX.CELL_QTY_PACK 
                  ,XX.MEASURE
                  --,XX.ACC_SUM
                  ,XX.PACK_BOH
                  --,XX.CELL_QTY
                  ,XX.ACC_CELL_QTY
                  ,XX.DT
                  ,(CASE  WHEN CELL_QTY  = 0 THEN  0
--                          WHEN CELL_QTY - PACK_BOH > 0 THEN  CELL_QTY - PACK_BOH
                          WHEN ACC_CELL_QTY_FROM_BOH_QTY  - CELL_QTY <= 0 THEN  ACC_CELL_QTY_FROM_BOH_QTY
                          WHEN ACC_CELL_QTY_FROM_BOH_QTY  - CELL_QTY > 0  THEN  CELL_QTY
                          ELSE 0 END) AS REQ_QTY
                  ,(CASE  WHEN YYYYMMDD < @p_plan_start_yyyymmdd THEN @p_plan_start_yyyymmdd 
                          ELSE YYYYMMDD END ) AS REQ_YYYYMMDD
                 INTO #tmp_SCP_ANL_PSI_GLOBAL_SMALL_PACK
                 FROM (
                     SELECT X.DIVISION_ID
                        ,X.CELL_ITEM_ID
                       -- ,X.ITEM_ID
                        ,X.FROM_SITE
                        ,X.TO_SITE
                        ,X.TRANSPORT_MODE_LINE
                        ,X.BOD_ID
                        ,Y.FROM_BOH_QTY
                        ,X.LT_TOTAL
                        ,X.DT
                        ,CONVERT(NVARCHAR, (DATEADD(DAY, - X.LT_TOTAL, X.DT)),112) AS YYYYMMDD
                        ,X.MEASURE
                        ,X.CELL_QTY
                        ,SUM(X.CELL_QTY) OVER (PARTITION BY X.CELL_ITEM_ID, X.FROM_SITE  ORDER BY X.DT) AS ACC_CELL_QTY
                        ,Y.FROM_BOH_QTY AS PACK_BOH
                        ,SUM(X.CELL_QTY) OVER (PARTITION BY X.CELL_ITEM_ID, X.FROM_SITE  ORDER BY X.DT)  - ISNULL(Y.FROM_BOH_QTY,0)  AS ACC_CELL_QTY_FROM_BOH_QTY 
                        , 0 AS QTY_ACC_SUM
                        , 0 AS R_QTY
                        , 0 AS CELL_QTY_PACK
                    FROM #SCP_ANL_PSI_GLOBAL_SMALL_REQ_PACK X WITH (NOLOCK)
                    INNER JOIN #SCP_ANL_PSI_GLOBAL_SMALL_PACK_INVERNTORY Y WITH (NOLOCK)
                    ON 0 = 0
                    AND X.Division_id = Y.DIVISION_ID
                    AND X.CELL_ITEM_ID = Y.CELL_ITEM_ID
    --                AND X.ITEM_ID = Y.ITEM_ID
                    AND X.FROM_SITE = Y.FROM_SITE
                 ) XX
--                GROUP BY X.DIVISION_ID
--                    ,X.CELL_ITEM_ID
--                   -- ,X.ITEM_ID
--                    ,X.FROM_SITE
--                    ,X.TO_SITE
--                    ,X.TRANSPORT_MODE_LINE
--                    ,X.BOD_ID
--                    ,Y.FROM_BOH_QTY
--                    ,X.LT_TOTAL
--                    ,X.DT
--                    ,CONVERT(NVARCHAR, (DATEADD(DAY, - X.LT_TOTAL, X.DT)),112) 
--                    ,X.MEASURE
--                    ,X.CELL_QTY
----                    ,SUM(X.CELL_QTY) OVER (PARTITION BY X.CELL_ITEM_ID, X.FROM_SITE  ORDER BY X.DT) AS ACC_CELL_QTY
--                    ,Y.FROM_BOH_QTY 
--                    --,SUM(X.CELL_QTY) OVER (PARTITION BY X.CELL_ITEM_ID, X.FROM_SITE  ORDER BY X.DT)  - ISNULL(Y.FROM_BOH_QTY,0)  AS ACC_CELL_QTY_FROM_BOH_QTY 
--                    --, 0 AS QTY_ACC_SUM
--                    --, 0 AS R_QTY
--                    --, 0 AS CELL_QTY_PACK
              WHERE 0 = 0
              */

           IF OBJECT_ID('tempdb..#tmp_SHIP_REQ_PACK') IS NOT NULL                  
              DROP TABLE #tmp_SHIP_REQ_PACK  

              SELECT  A.DIVISION_ID
                    , A.CELL_ITEM_ID
                    , A.REQ_YYYYMMDD AS YYYYMMDD
                    , SUM(ISNULL(CASE WHEN A.REQ_QTY < 0 THEN 0 
--                                      WHEN A.REQ_QTY < 0 THEN 0 
                                      ELSE A.REQ_QTY END ,0)) AS QTY
                    , 'SHIP_REQ_PACK' AS MEASURE 
                INTO #tmp_SHIP_REQ_PACK
                FROM #tmp_SCP_ANL_PSI_GLOBAL_SMALL_PACK A WITH (NOLOCK)
                GROUP BY A.DIVISION_ID
                        ,A.CELL_ITEM_ID
                        ,A.REQ_YYYYMMDD 
          
            -- @p_plan_start_yyyymmdd 보다 적은 일자일 경우 SUM을 반영한다.
            UPDATE A
               SET A.QTY = ISNULL(A.QTY,0) + ISNULL(B.QTY,0)
              FROM #tmp_SHIP_REQ_PACK A WITH (NOLOCK)
              INNER JOIN (
                            SELECT DIVISION_ID
                                  ,CELL_ITEM_ID
                                  ,SUM(QTY) AS QTY
                                  ,@p_plan_start_yyyymmdd AS YYYYMMDD
                            FROM #tmp_SHIP_REQ_PACK                        WITH (NOLOCK)
                            WHERE 0 = 0
                            --AND CELL_ITEM_ID ='MCP395890A10'
                            AND YYYYMMDD < @p_plan_start_yyyymmdd
                            GROUP BY DIVISION_ID
                                  ,CELL_ITEM_ID
                          ) B
               ON  A.DIVISION_ID   = B.DIVISION_ID 
               AND A.CELL_ITEM_ID = B.CELL_ITEM_ID
               AND A.YYYYMMDD     = B.YYYYMMDD



            UPDATE X
               SET X.QTY            = ISNULL(Y.QTY,0)
               FROM #PSI_GLOBAL_SMALL_CELL X  WITH (NOLOCK)
               INNER JOIN #tmp_SHIP_REQ_PACK Y WITH (NOLOCK)
                ON  0 = 0
               AND X.DIVISION_ID  = Y.DIVISION_ID
               AND X.MEASURE      = Y.MEASURE       
               AND X.MEASURE      = 'SHIP_REQ_PACK'
               AND X.CELL_ITEM_ID = Y.CELL_ITEM_ID
               AND X.YYYYMMDD     = Y.YYYYMMDD

            --   SELECT * INTO ##PSI_GLOBAL_SMALL_CELL                         FROM #PSI_GLOBAL_SMALL_CELL                        WITH (NOLOCK)
            --   SELECT * INTO ##SCP_ANL_PSI_GLOBAL_SMALL_REQ_PACK             FROM #SCP_ANL_PSI_GLOBAL_SMALL_REQ_PACK            WITH (NOLOCK)
            --   SELECT * INTO ##tmp_SHIP_REQ_PACK                             FROM #tmp_SHIP_REQ_PACK                            WITH (NOLOCK)
            --   SELECT * INTO ##SCP_ANL_PSI_GLOBAL_SMALL_PACK_INVERNTORY      FROM #SCP_ANL_PSI_GLOBAL_SMALL_PACK_INVERNTORY     WITH (NOLOCK)
            --   SELECT * INTO ##SCP_MST_BOD_V                                 FROM #SCP_MST_BOD_V                                WITH (NOLOCK)
            --   SELECT * INTO ##tmp_SCP_ANL_PSI_GLOBAL_SMALL_PACK             FROM #tmp_SCP_ANL_PSI_GLOBAL_SMALL_PACK            WITH (NOLOCK)
            

            --return;                         
            /*
            SELECT * FROM #tmp_SCP_ANL_PSI_GLOBAL_SMALL_PACK WITH (NOLOCK)
            WHERE CELL_ITEM_ID ='MCP595490A10'
            ORDER BY REQ_YYYYMMDD
            

            SELECT * FROM #tmp_SHIP_REQ_PACK WITH (NOLOCK)
            WHERE CELL_ITEM_ID ='MCP595490A10'
            ORDER BY YYYYMMDD

            SELECT * FROM #PSI_GLOBAL_SMALL_CELL WITH (NOLOCK)
            WHERE CELL_ITEM_ID ='MCP595490A10'
            ORDER BY YYYYMMDD
            --SELECT 17982.0000000000 + 18252.0000000000 + 28347.0000000000

            --return;
            */

            --SELECT * FROM #tmp_SHIP_REQ_PACK WITH (NOLOCK)
            --WHERE CELL_ITEM_ID ='MCP595490A10'
            --ORDER BY YYYYMMDD
            --return;

           -------------------------------------------------------------------------------------------------------------------------
           -- SHIP_REQ_CELL DATA 반영
           -------------------------------------------------------------------------------------------------------------------------
               IF OBJECT_ID('tempdb..#tmp_SHIP_REQ_CELL') IS NOT NULL                  
              DROP TABLE #tmp_SHIP_REQ_CELL  

              SELECT  A.DIVISION_ID
                    , (CASE WHEN Y.TCO_CELL_YN = 'Y' THEN Y.ATTRIBUTE1 ELSE A.ITEM_ID END ) AS CELL_ITEM_ID
                    , A.YYYYMMDD
                    , SUM(ISNULL(A.QTY,0)) AS QTY
                    ,'SHIP_REQ_CELL' AS MEASURE 
                INTO #tmp_SHIP_REQ_CELL
                FROM SCP_ANL_SHIPMENT_PLAN_FG A WITH(NOLOCK)	
                INNER JOIN SCP_MST_FINAL_ITEM Y WITH(NOLOCK)
                        ON 0 = 0
                       AND A.DIVISION_ID = Y.DIVISION_ID
                       AND A.ITEM_ID     = Y.ITEM_ID
                INNER JOIN SCM_MST_SITE S WITH (NOLOCK)
                    ON A.DIVISION_ID			  = S.DIVISION_ID
                    AND S.SITE_TYPE         ='SALES'
                    AND A.TO_SITE           = S.SCM_SITE_ID
	              WHERE A.DIVISION_ID			    =  @p_division_id
		            AND A.PLAN_START_YYYYMMDD	  =  @p_plan_start_yyyymmdd
		            AND A.PLAN_TYPE				      =  @p_plan_type
		            AND A.SEQ					          =  @p_seq
		            AND A.YYYYMMDD             >=  @p_plan_start_yyyymmdd
		            AND A.YYYYMMDD             <   @p_to_yyyymmdd
                AND A.MEASURE              =  'SHIP_REQ'-- 'SHIP_PLAN_AMEND' --'SHIP_REQ'
                AND A.BIZ_TYPE             = 'A'
              GROUP BY A.DIVISION_ID			
			              , (CASE WHEN Y.TCO_CELL_YN = 'Y' THEN Y.ATTRIBUTE1 ELSE A.ITEM_ID END )		
			              , A.YYYYMMDD
                    ;        
              

               UPDATE X
               SET X.QTY            = ISNULL(Y.QTY,0)
               FROM #PSI_GLOBAL_SMALL_CELL X  WITH (NOLOCK)
               INNER JOIN #tmp_SHIP_REQ_CELL Y WITH (NOLOCK)
                ON  0 = 0
               AND X.DIVISION_ID        = Y.DIVISION_ID
               AND X.MEASURE            = Y.MEASURE 
               AND X.MEASURE            = 'SHIP_REQ_CELL'
               AND X.CELL_ITEM_ID       = Y.CELL_ITEM_ID
               AND X.YYYYMMDD           = Y.YYYYMMDD
           ;

           -------------------------------------------------------------------------------------------------------------------------
           -- SHORT_DEMAND에_대하여_CELL_SHIP_REQ_생성방안
           -- SHIP_REQ_PACK 또는 SHIP_REQ_CELL 에 계산함.
           -------------------------------------------------------------------------------------------------------------------------

		  IF OBJECT_ID('tempdb..#SHORT_DEMAND_QTY') IS NOT NULL                  
              DROP TABLE #SHORT_DEMAND_QTY  ;

           WITH XXX AS
            (
              SELECT SUB.ITEM_ID, SUB.SALES_SITE_ID,SUB.INCOTERMS,SUB.YYYYMMDD,SUB.PLANT_SITE_ID,FLOOR(SUB.SHORT_QTY) AS SHORT_QTY,
                     F.OPERATION_GROUP, --F.TCO_CELL_YN,
                     F.ATTRIBUTE1 AS CELL_ITEM_ID,
                     (  SELECT TOP 1 ISNULL(LT_TOTAL,0)
                          FROM [dbo].[SCP_MST_BOD_N_V] V WITH (NOLOCK)		-- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 - SCP_MST_BOD_V --> SCP_MST_BOD_N_V
                         WHERE V.DIVISION_ID    =@p_division_id
                           AND V.FROM_SITE      =SUB.PLANT_SITE_ID
                           AND V.TO_SITE        =SUB.SALES_SITE_ID
                           AND V.INCOTERMS      =SUB.INCOTERMS  
                           AND V.BOD_VALID_YN   ='Y'
                           AND V.ROUTE_VALID_YN ='Y' ) AS BOD_LT1,
                     (  SELECT TOP 1 PLANT_SITE_ID
                          FROM [dbo].[SCM_MST_SITE_ITEM_PRIORITY] X WITH(NOLOCK)
                         WHERE X.ITEM_ID        =F.ATTRIBUTE1
                           AND X.DIVISION_ID    =@p_division_id
                           AND X.VALID_YN       ='Y'
                         ORDER BY PRIORITY ASC ) AS CELL_SITE_ID,
                     (  SELECT TOP 1 ISNULL(LT_TOTAL,0)
                          FROM [dbo].[SCP_MST_BOD_N_V] V WITH (NOLOCK)		-- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 - SCP_MST_BOD_V --> SCP_MST_BOD_N_V
                         WHERE V.DIVISION_ID    =@p_division_id
                           AND V.FROM_SITE      =(  SELECT TOP 1 PLANT_SITE_ID
                                                      FROM [dbo].[SCM_MST_SITE_ITEM_PRIORITY] X WITH(NOLOCK)
                                                     WHERE X.ITEM_ID        =F.ATTRIBUTE1
                                                       AND X.DIVISION_ID    =@p_division_id
                                                       AND X.VALID_YN       ='Y'
                                                     ORDER BY PRIORITY ASC )
                           AND V.TO_SITE        =SUB.PLANT_SITE_ID
                           AND V.BOD_VALID_YN   ='Y'
                           AND V.ROUTE_VALID_YN ='Y' ) AS BOD_LT2,
                  /*    ( SELECT TOP 1 ISNULL(CELL_TO_TCO_TOTAL_BOD_LT,0)
                          FROM SCP_MST_CELL_TCO_RELATION_V X
                         WHERE X.CELL_ITEM_ID = F.ATTRIBUTE1
                       ) AS BOD_LT3, */
                      ( SELECT TOP 1 B.ACCUMULATED_CHILD_QTY
                          FROM [dbo].[SCM_MST_MODEL_FINAL_ITEM_BOM_V] B WITH (NOLOCK)
                         WHERE B.MODEL_ID      = SUB.ITEM_ID
                           AND B.CHILD_ITEM_ID = F.ATTRIBUTE1
                       ) AS BOM_QTY
                FROM (
                       SELECT 
                             ITEM_ID, SALES_SITE_ID,INCOTERMS,YYYYMMDD,PLANT_SITE_ID,
                             SUM(PROBLEM_QTY) AS SHORT_QTY
                        FROM SCP_PLN_PROBLEM_REPORT_V P  WITH (NOLOCK)
                       WHERE 1=1
                         and DIVISION_ID         =  @p_division_id
                         AND PLAN_START_YYYYMMDD =  @p_plan_start_yyyymmdd
                         AND PLAN_TYPE           =  @p_plan_type
                         AND SEQ                 =  @p_seq
                         AND PROBLEM_TYPE        =  'UNPLAN'
--                         AND PROBLEM_DESCR       IN ( 'CAPA. SHORT(PET)','PREFER NO RESOURCE')
                       GROUP BY ITEM_ID, SALES_SITE_ID,INCOTERMS,YYYYMMDD,PLANT_SITE_ID  
                       ) SUB
                     --INNER JOIN SCP_MST_FINAL_ITEM F WITH(NOLOCK)
                     --      ON SUB.ITEM_ID       = F.ITEM_ID
                     --      AND F.DIVISION_ID    =@p_division_id
                     INNER JOIN (SELECT A.*
                                 FROM  (
                                        SELECT F.DIVISION_ID, F.ITEM_ID, F.OPERATION_GROUP, FC.ITEM_ID AS ATTRIBUTE1
                                             , ROW_NUMBER() OVER (PARTITION BY F.DIVISION_ID, F.ITEM_ID ORDER BY FC.ITEM_ID) ROW_NUM 
                                        FROM SCP_MST_FINAL_ITEM F WITH(NOLOCK)
                                        INNER JOIN SCP_MST_FINAL_ITEM FC WITH(NOLOCK)
                                              ON  F.DIVISION_ID = FC.DIVISION_ID
                                              AND F.ATTRIBUTE1  LIKE '%' + FC.ITEM_ID + '%'
                                        WHERE  F.DIVISION_ID    = @p_division_id
                                        AND    F.ATTRIBUTE1     LIKE '%,%'

                                        UNION

                                        SELECT F.DIVISION_ID, F.ITEM_ID, F.OPERATION_GROUP, F.ATTRIBUTE1, 1 AS ROW_NUM
                                        FROM SCP_MST_FINAL_ITEM F WITH(NOLOCK)
                                        WHERE  F.DIVISION_ID  = @p_division_id
                                        AND    F.ATTRIBUTE1   NOT LIKE '%,%'
                                       ) A
                                 WHERE  A.ROW_NUM = 1
                                ) F
                           ON  SUB.ITEM_ID      = F.ITEM_ID
                           AND F.DIVISION_ID    = @p_division_id
            ) 

            SELECT OPERATION_GROUP,
                   CELL_ITEM_ID, 
                   (CASE WHEN CONVERT(VARCHAR,DATEADD(D,ISNULL(BOD_LT1,0)*-1 + ISNULL(BOD_LT2,0)*-1 ,CONVERT(DATETIME,YYYYMMDD,112)),112)  < @p_plan_start_yyyymmdd 
                         THEN @p_plan_start_yyyymmdd ELSE CONVERT(VARCHAR,DATEADD(D,ISNULL(BOD_LT1,0)*-1 + ISNULL(BOD_LT2,0)*-1 ,CONVERT(DATETIME,YYYYMMDD,112)),112) 
                         END ) AS SHIP_REQ_YYYYMMDD,

                   SUM((SHORT_QTY * ISNULL(BOM_QTY,1))) AS REQ_QTY
              INTO #SHORT_DEMAND_QTY
              FROM XXX    WITH (NOLOCK)
            GROUP BY OPERATION_GROUP,
                   CELL_ITEM_ID, 
                   (CASE WHEN CONVERT(VARCHAR,DATEADD(D,ISNULL(BOD_LT1,0)*-1 + ISNULL(BOD_LT2,0)*-1 ,CONVERT(DATETIME,YYYYMMDD,112)),112)  < @p_plan_start_yyyymmdd 
                         THEN @p_plan_start_yyyymmdd ELSE CONVERT(VARCHAR,DATEADD(D,ISNULL(BOD_LT1,0)*-1 + ISNULL(BOD_LT2,0)*-1 ,CONVERT(DATETIME,YYYYMMDD,112)),112) 
                         END ) 

            UPDATE X
               SET X.QTY            =  ISNULL(Y.REQ_QTY,0)
               FROM #PSI_GLOBAL_SMALL_CELL X  WITH (NOLOCK)
               INNER JOIN #SHORT_DEMAND_QTY Y WITH (NOLOCK)
                ON  0 = 0
               --AND X.DIVISION_ID  = Y.DIVISION_ID
               --AND X.MEASURE      = Y.MEASURE       
               AND X.MEASURE          = 'SHIP_REQ_PACK_SHORT'
               AND X.CELL_ITEM_ID     = Y.CELL_ITEM_ID
               AND X.YYYYMMDD         = Y.SHIP_REQ_YYYYMMDD
               AND Y.OPERATION_GROUP  = 'P'

            UPDATE X
               SET X.QTY            = ISNULL(Y.REQ_QTY,0)
               FROM #PSI_GLOBAL_SMALL_CELL X  WITH (NOLOCK)
               INNER JOIN #SHORT_DEMAND_QTY Y WITH (NOLOCK)
                ON  0 = 0
               --AND X.DIVISION_ID        = Y.DIVISION_ID
               --AND X.MEASURE            = Y.MEASURE 
               AND X.MEASURE            = 'SHIP_REQ_CELL_SHORT'
               AND X.CELL_ITEM_ID       = Y.CELL_ITEM_ID
               AND X.YYYYMMDD           = Y.SHIP_REQ_YYYYMMDD
               AND Y.OPERATION_GROUP    = 'A'



            -------------------------------------------------------------------------------------------------------------         
            -- TACT TIME TEMP 생성  -- ESS 외주 Line별 생산 Target 관련 OSP_YN로직 수정
            -------------------------------------------------------------------------------------------------------------            
             IF OBJECT_ID('tempdb..#tmp_SCP_MST_TACT_TIME') IS NOT NULL	
	              DROP TABLE #tmp_SCP_MST_TACT_TIME
             
             SELECT * 
             INTO #tmp_SCP_MST_TACT_TIME
             FROM 
             (
                SELECT DIVISION_ID,PLANT_SITE_ID,ITEM_ID,OPERATION_ID,LINE_ID,YIELD 
                FROM SCP_MST_TACT_TIME WITH(NOLOCK)
                WHERE DIVISION_ID =@p_division_id
                -- AND OPERATION_ID IN ('P9500','P5500')
                UNION ALL
                SELECT DIVISION_ID,PLANT_SITE_ID,ITEM_ID,OPERATION_ID,LINE_ID,YIELD 
                FROM SCP_MST_TACT_TIME_OSP WITH(NOLOCK)
                WHERE DIVISION_ID =@p_division_id
              -- AND OPERATION_ID IN ('P9500','P5500')
              ) X

           -------------------------------------------------------------------------------------------------------------------------
            /* 생산
                PROD	            Production	                210	  SITE,LINE	  DB
                PROD_LOAD	        Load Rate	                  220	  SITE,LINE	  DB
            */
            -------------------------------------------------------------------------------------------------------------------------
              INSERT #PSI_GLOBAL_SMALL_CELL
              SELECT A.DIVISION_ID			
                    , Y.CELL_TYPE_GROUP_CODE
                    , A.ITEM_ID AS CELL_ITEM_ID										
                    , 'PROD' AS MEASURE		
                    , 'Production' AS COLUMN_LABEL_NAME													
			              , A.SCM_SITE_ID		
                    , A.LINE_ID AS PROD_LINE
                    , 0 AS YIELD
                    , 0 AS LT_WEEK
			              , 0 AS BOH
			              , A.YYYYMMDD        AS YYYYMMDD				
                    , ISNULL(A.QTY,0)     AS QTY  
			              , '210' AS SORT_ORDER_NO	
--                    , ISNULL(A.ATTRIBUTE1,'') AS ATTRIBUTE1
                    , A.ATTRIBUTE1
			              , A.OPERATION_ID AS ATTRIBUTE9										
	                 FROM SCP_ANL_PRODUCTION_PLAN A WITH(NOLOCK)	
						-- [PJ20257329] 2025.08.01 Cell 완성 공정 하드코딩 변경 - Start 
						  INNER HASH JOIN #SCP_CELL_FINAL_OPERATION CO
									   ON CO.OPERATION_ID = A.OPERATION_ID 
						-- [PJ20257329] 2025.08.01 Cell 완성 공정 하드코딩 변경 - End 
                  INNER JOIN SCP_MST_FINAL_ITEM Y WITH(NOLOCK)
                          ON 0 = 0
                         AND A.DIVISION_ID = Y.DIVISION_ID
                         AND A.ITEM_ID     = Y.ITEM_ID
	                WHERE A.DIVISION_ID			    =  @p_division_id
		              AND A.PLAN_START_YYYYMMDD	  =  @p_plan_start_yyyymmdd
		              AND A.PLAN_TYPE				      =  @p_plan_type
		              AND A.SEQ					          =  @p_seq
		              AND A.YYYYMMDD             >=  @p_plan_start_yyyymmdd
		              AND A.YYYYMMDD             <   @p_to_yyyymmdd
                  AND A.MEASURE              =  'PROD_PLAN_AMEND'
                  AND A.OPERATION_GROUP       = 'A'
                  -- [PJ20257329] 2025.08.01  변경전 AND A.OPERATION_ID         IN ( 'A3000','A9000')
                  AND Y.TCO_CELL_YN          = 'N'

               UNION 
               -- TACT_TIME에 존재하는 ITEM_ID PROD MEASURE 추가 
                   SELECT DISTINCT A.DIVISION_ID,Y.CELL_TYPE_GROUP_CODE,A.ITEM_ID
                   , 'PROD' AS MEASURE		
                   , 'Production' AS COLUMN_LABEL_NAME													
                   ,A.PLANT_SITE_ID AS SCM_SITE_ID
                   ,A.LINE_ID AS PROD_LINE
                   , 0 AS YIELD
                   , 0 AS LT_WEEK
			             , 0 AS BOH
                   , C.BASIS_YYYYMMDD AS YYYYMMDD				
                   , 0     AS QTY  
			             , '210' AS SORT_ORDER_NO	
--                    , ISNULL(A.ATTRIBUTE1,'') AS ATTRIBUTE1
                    , NULL AS ATTRIBUTE1
			              , A.OPERATION_ID AS ATTRIBUTE9	
                  FROM #tmp_SCP_MST_TACT_TIME A WITH (NOLOCK)
						-- [PJ20257329] 2025.08.01 Cell 완성 공정 하드코딩 변경 - Start 
						  INNER HASH JOIN #SCP_CELL_FINAL_OPERATION CO
									   ON CO.OPERATION_ID = A.OPERATION_ID 
						-- [PJ20257329] 2025.08.01 Cell 완성 공정 하드코딩 변경 - End 
                  INNER JOIN SCM_SYS_CALENDAR_M    C WITH(NOLOCK)         
                      ON 1=1      
                     AND C.BASIS_YYYYMMDD >= @p_plan_start_yyyymmdd       
                     AND C.BASIS_YYYYMMDD <  @p_to_yyyymmdd  
                   INNER JOIN SCP_MST_FINAL_ITEM Y WITH(NOLOCK)
                      ON 0 = 0
                     AND A.DIVISION_ID = Y.DIVISION_ID
                     AND A.ITEM_ID     = Y.ITEM_ID
                  WHERE 0 = 0
                  AND A.DIVISION_ID = '40'
                  -- [PJ20257329] 2025.08.01  변경전 AND A.OPERATION_ID         IN ( 'A3000','A9000')
                  AND Y.TCO_CELL_YN          = 'N'
                  AND A.ITEM_ID IN (SELECT DISTINCT CELL_ITEM_ID 
                                    FROM #PSI_GLOBAL_SMALL_CELL WITH (NOLOCK) 
                                  );

                  CREATE NONCLUSTERED INDEX tmp_idx_2 on #PSI_GLOBAL_SMALL_CELL(DIVISION_ID, CELL_TYPE_GROUP_CODE,CELL_ITEM_ID, MEASURE, SITE_ID, YIELD, LT_WEEK, BOH, YYYYMMDD);

                  INSERT #PSI_GLOBAL_SMALL_CELL
                  SELECT  DISTINCT            
                          X.DIVISION_ID								
			                  , X.CELL_TYPE_GROUP_CODE						
                        , X.CELL_ITEM_ID
			                  , M.COLUMN_NAME AS MEASURE
                        , M.COLUMN_LABEL_NAME		
			                  , X.SITE_ID										
			                  , X.PROD_LINE									
			                  , 0 AS YIELD
                        , 0 AS LT_WEEK
                        , 0 AS BOH									
			                  , X.YYYYMMDD	
                        , 0    AS QTY
			                  , '220' AS SORT_ORDER_NO				
--                        , ISNULL(X.ATTRIBUTE1,'') AS ATTRIBUTE1										
                        , X.ATTRIBUTE1
			                  , X.ATTRIBUTE9	
                    FROM #PSI_GLOBAL_SMALL_CELL X WITH(NOLOCK)     
                     CROSS APPLY  #MEASURE M WITH (NOLOCK) 
                          WHERE 1=1          
                            AND M.DIV             ='G'
                            AND X.MEASURE         = 'PROD'     
--                            AND M.COLUMN_NAME     = 'PROD_LOAD'           
                            AND NOT EXISTS (                
                                            SELECT 'X'                
                                              FROM #PSI_GLOBAL_SMALL_CELL Z WITH(NOLOCK)                
                                              WHERE 1=1                
                                                AND Z.DIVISION_ID          = X.DIVISION_ID                
                                                AND Z.CELL_TYPE_GROUP_CODE = X.CELL_TYPE_GROUP_CODE                
                                                AND Z.CELL_ITEM_ID         = X.CELL_ITEM_ID       
                                                AND Z.MEASURE              = X.MEASURE 
                                                AND Z.SITE_ID              = X.SITE_ID   
                                                AND Z.YIELD     = X.YIELD          
                                                AND Z.LT_WEEK              = X.LT_WEEK                
                                                AND Z.BOH                  = X.BOH   
                                                AND Z.YYYYMMDD             = X.YYYYMMDD          
                                                AND Z.ATTRIBUTE1						=	X.ATTRIBUTE1					
			                                          AND Z.ATTRIBUTE9						=	X.ATTRIBUTE9					
                                          )      

                    AND M.COLUMN_NAME   <> 'PROD'
                
                IF @p_update = 'Y'
                BEGIN
                  DELETE FROM #PSI_GLOBAL_SMALL_CELL  
                  WHERE CELL_ITEM_ID NOT IN (SELECT DISTINCT ITEM_ID FROM SCP_XLS_CELL_PROD_Line_V WITH (NOLOCK) )
                END

                

            

            -------------------------------------------------------------------------------------------------------------         
            -- PROD, PROD_LOAD 0 채움
            -------------------------------------------------------------------------------------------------------------

             IF OBJECT_ID('tempdb..#MST_TACT_TIME') IS NOT NULL	
	              DROP TABLE #MST_TACT_TIME
                
                SELECT *
                INTO #MST_TACT_TIME
                FROM 
                  (
                  SELECT DISTINCT DIVISION_ID,PLANT_SITE_ID,LINE_ID,ITEM_ID
                  FROM #tmp_SCP_MST_TACT_TIME A WITH (NOLOCK)
						-- [PJ20257329] 2025.08.01 Cell 완성 공정 하드코딩 변경 - Start 
						  INNER HASH JOIN #SCP_CELL_FINAL_OPERATION CO
									   ON CO.OPERATION_ID = A.OPERATION_ID 
						-- [PJ20257329] 2025.08.01 Cell 완성 공정 하드코딩 변경 - End 
                  WHERE 0 = 0
                  AND DIVISION_ID = '40'
                  -- [PJ20257329] 2025.08.01  변경전 AND OPERATION_ID         IN ( 'A3000','A9000')
                  AND ITEM_ID IN (SELECT DISTINCT CELL_ITEM_ID 
                                    FROM #PSI_GLOBAL_SMALL_CELL WITH (NOLOCK) 
                                   WHERE  0 = 0
                                     AND DIVISION_ID  = '40'
                                     AND MEASURE      = 'PROD'
                                  )
--                  UNION 
--                  SELECT DISTINCT DIVISION_ID,PLANT_SITE_ID,'-' AS LINE_ID,ITEM_ID   -- DAILY_CAPA_QTY
--                  --SELECT * 
--                  FROM SCP_MST_OUTSOURCING_CAPA WITH (NOLOCK)
--                  WHERE 0 = 0
--                  AND DIVISION_ID = '40'
--                  AND ITEM_ID IN (SELECT DISTINCT CELL_ITEM_ID 
--                                    FROM #PSI_GLOBAL_SMALL_CELL WITH (NOLOCK) 
--                                   WHERE  0 = 0
--                                     AND DIVISION_ID  = '40'
----                                     AND MEASURE      = 'PROD'
--                                  )
                  ) AS X

            -------------------------------------------------------------------------------------------------------------         
            -- Line Load 율 로직 작업중
            -------------------------------------------------------------------------------------------------------------
            IF OBJECT_ID('tempdb..#LINE_WORKINGTIME_BY_LOSS') IS NOT NULL      
	              DROP TABLE #LINE_WORKINGTIME_BY_LOSS;   
                --Working Time 추출
		            SELECT DIVISION_ID
			               , PLANT_SITE_ID AS SCM_SITE_ID
			               , OPERATION_ID
			               , LINE_ID
			               , YYYYMMDD
			               , WORKING_TIME
		            INTO #LINE_WORKINGTIME_BY_LOSS
		            FROM dbo.FN_LINE_WORKINGTIME_BY_LOSS(@p_division_id, @p_plan_start_yyyymmdd, @p_to_yyyymmdd, '')
		            ;


              IF OBJECT_ID('tempdb..#LineLoad') IS NOT NULL      
	              DROP TABLE #LineLoad;   

			          SELECT /*DISTINCT */
						          A.DIVISION_ID
					          , A.SCM_SITE_ID AS SITE_ID
                    , A.OPERATION_GROUP
		                , A.OPERATION_ID
		                , A.LINE_ID AS PROD_LINE
					          , 'PROD_LOAD' AS MEASURE
--                    , CASE WHEN D.WORKING_TIME <= 0.0 THEN 0 ELSE ISNULL( ( ( ROUND(SUM(A.QTY * (E.TACT_TIME/60)),0) / D.WORKING_TIME ) ) ,0 ) *100  END AS QTY
                    , CASE WHEN D.WORKING_TIME <= 0.0 THEN 0 ELSE ISNULL( ROUND(SUM(CONVERT(BIGINT, A.QTY * (E.TACT_TIME/60))),0)  ,0.0 ) *100  END AS QTY		-- 20241103 21자리 이상 OVERFLOW 에러방지
					          , ISNULL(ROUND(SUM(A.QTY * (E.TACT_TIME/60)),0), 0) AS CAPA_TACT
					          , ISNULL( D.WORKING_TIME ,0 ) AS WORKING_TIME
                    , A.YYYYMMDD AS YYYYMMDD
                    , C.ISO_YYYYWW AS ISO_YYYYWW
                    ,'WQTY' + REPLICATE('0', 2 - LEN(DENSE_RANK()  OVER(PARTITION BY  A.LINE_ID ORDER BY C.ISO_YYYYWW) )) + CONVERT(NVARCHAR,DENSE_RANK()  OVER(PARTITION BY  A.LINE_ID ORDER BY C.ISO_YYYYWW))  AS WEEK_COLUMN
                INTO #LineLoad
			          FROM SCP_ANL_PRODUCTION_PLAN A WITH (NOLOCK)
                INNER JOIN SCM_SYS_CALENDAR_M C   WITH (NOLOCK)
                        ON A.YYYYMMDD = C.BASIS_YYYYMMDD
			          LEFT OUTER JOIN #LINE_WORKINGTIME_BY_LOSS D  WITH (NOLOCK)
                     ON   A.DIVISION_ID   = D.DIVISION_ID 
                      AND A.OPERATION_ID  = D.OPERATION_ID 
					            AND A.SCM_SITE_ID   = D.SCM_SITE_ID 
					            AND A.LINE_ID       = D.LINE_ID 
					            AND A.YYYYMMDD      = D.YYYYMMDD
			          LEFT OUTER JOIN SCP_ANL_TACT_TIME E WITH(NOLOCK)	
                      ON A.DIVISION_ID    = E.DIVISION_ID 
                     AND A.OPERATION_ID   = E.OPERATION_ID 
				             AND A.SCM_SITE_ID    = E.SCM_SITE_ID  
				             AND A.LINE_ID        = E.LINE_ID 
                     AND A.ITEM_ID        = E.ITEM_ID 
				             AND A.YYYYMMDD       = E.YYYYMMDD
			          WHERE 1=1 
                   AND A.DIVISION_ID         = @p_division_id
                  AND A.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
                  AND A.PLAN_TYPE           = @p_plan_type
                  AND A.SEQ                 = @p_seq
			            AND A.YYYYMMDD           >= @p_plan_start_yyyymmdd
	                AND A.YYYYMMDD           <  @p_to_yyyymmdd
	                AND A.MEASURE             = 'PROD_PLAN_AMEND'
                  AND A.OPERATION_GROUP     = 'A'
              GROUP BY A.DIVISION_ID, A.SCM_SITE_ID ,A.OPERATION_ID ,A.LINE_ID, A.YYYYMMDD, D.WORKING_TIME,  C.ISO_YYYYWW,A.OPERATION_GROUP


                
              UPDATE X
              SET X.QTY       = Y.QTY
              FROM #PSI_GLOBAL_SMALL_CELL X  WITH (NOLOCK)
              INNER JOIN #LineLoad  Y WITH (NOLOCK)
              ON 0 = 0
              AND X.DIVISION_ID   = Y.DIVISION_ID
		          AND X.YYYYMMDD      = Y.YYYYMMDD
              AND X.SITE_ID       = Y.SITE_ID
              AND X.PROD_LINE     = Y.PROD_LINE
              AND X.MEASURE       = Y.MEASURE 
              AND Y.MEASURE       ='PROD_LOAD'  


                     
            -------------------------------------------------------------------------------------------------------------         
            -- BOH 반영(SCP_XLS_BOH)
            -------------------------------------------------------------------------------------------------------------         
               IF OBJECT_ID('tempdb..#BOH') IS NOT NULL	
	                DROP TABLE #BOH

                   SELECT X.CELL_ITEM_ID,
                           CONVERT(VARCHAR,X.AFTER_DTTM,112) AS YYYYMMDD,
                           SUM(X.AFTER_QTY) AS QTY,
                           (CASE WHEN CONVERT(VARCHAR,X.AFTER_DTTM,112) < @p_plan_start_yyyymmdd THEN 'SHIP_AVAILABLE' ELSE 'ETA_PAST' END) AS MEASURE
                    INTO #BOH
                    FROM 
                    (
                    SELECT --SUB.*,
                            CELL_ITEM_ID,
                           ( CASE WHEN (OSP_YN='N' AND LOC='***' AND  TCO_CELL_YN='N' AND DESCR LIKE 'WH%') THEN QTY * FORMATION_TOTAL_YIELD ELSE QTY END) AS AFTER_QTY,
                           ( CASE WHEN (OSP_YN='N' AND LOC='***' AND  TCO_CELL_YN='N' AND DESCR LIKE 'WH%' AND TCO_EXIST_YN ='Y' ) --활성화 LT+ TOTAL TCO LT
                                  THEN DATEADD(D,TOTAL_LT_FORMATION+CELL_TO_TCO_TOTAL_BOD_LT,RECEIVING_DTTM) 
                                  WHEN (OSP_YN='N' AND LOC='***' AND  TCO_CELL_YN='N' AND DESCR LIKE 'WH%' AND TCO_EXIST_YN ='N' ) --활성화 LT
                                  THEN DATEADD(D,TOTAL_LT_FORMATION,RECEIVING_DTTM) 
                                  WHEN (OSP_YN='N' AND LOC='001' AND  TCO_CELL_YN='N' AND DESCR LIKE 'FOR%' AND TCO_EXIST_YN ='Y' ) --TOTAL TCO LT
                                  THEN DATEADD(D,CELL_TO_TCO_TOTAL_BOD_LT,RECEIVING_DTTM)  
                                  WHEN (OSP_YN='N' AND LOC='001' AND  TCO_CELL_YN='N' AND DESCR LIKE 'FOR%' AND TCO_EXIST_YN ='N' ) --
                                  THEN RECEIVING_DTTM 
                                  WHEN (OSP_YN='N' AND LOC='001' AND  TCO_CELL_YN='N' AND DESCR LIKE 'WH%' AND TCO_EXIST_YN ='Y' ) --TOTAL TCO LT
                                  THEN DATEADD(D,CELL_TO_TCO_TOTAL_BOD_LT,RECEIVING_DTTM) 
                                  WHEN (OSP_YN='N' AND LOC='001' AND  TCO_CELL_YN='N' AND DESCR LIKE 'WH%' AND TCO_EXIST_YN ='N' ) --
                                  THEN RECEIVING_DTTM 
                                  WHEN (OSP_YN='N' AND LOC='002' AND  TCO_CELL_YN='N' AND DESCR LIKE 'WH%' AND TCO_EXIST_YN ='Y' ) --TOTAL TCO LT
                                  THEN DATEADD(D,CELL_TO_TCO_TOTAL_BOD_LT,RECEIVING_DTTM) 
                                  WHEN (OSP_YN='N' AND LOC='002' AND  TCO_CELL_YN='N' AND DESCR LIKE 'WH%' AND TCO_EXIST_YN ='N' ) --
                                  THEN RECEIVING_DTTM 
                                  WHEN (OSP_YN='N' AND LOC='003' AND  TCO_CELL_YN='N' AND DESCR LIKE 'WH%' AND TCO_EXIST_YN ='Y' ) --
                                  THEN RECEIVING_DTTM
                                  WHEN (OSP_YN='N' AND LOC='003' AND  TCO_CELL_YN='N' AND DESCR LIKE 'WH%' AND TCO_EXIST_YN ='N' ) --
                                  THEN RECEIVING_DTTM
                                  WHEN (OSP_YN='Y' AND LOC='***' AND  TCO_CELL_YN='N' AND DESCR LIKE 'INT%' AND TCO_EXIST_YN ='Y' ) --TCO_TO_CELL_BOD_LT
                                  THEN DATEADD(D,TCO_TO_CELL_BOD_LT,RECEIVING_DTTM) 
                                  WHEN (OSP_YN='Y' AND LOC='***' AND  TCO_CELL_YN='N' AND DESCR LIKE 'WH%' AND TCO_EXIST_YN ='Y' ) --TCO_TO_CELL_BOD_LT
                                  THEN DATEADD(D,TCO_TO_CELL_BOD_LT,RECEIVING_DTTM) 
                                  WHEN (OSP_YN='Y' AND LOC='***' AND  TCO_CELL_YN='Y' AND DESCR LIKE 'WH%' ) --TCO_TO_CELL_BOD_LT
                                  THEN DATEADD(D,TCO_TO_CELL_BOD_LT,RECEIVING_DTTM) 
                                  WHEN (OSP_YN='N' AND LOC='002' AND  TCO_CELL_YN='Y' AND DESCR LIKE 'INT%' ) --
                                  THEN RECEIVING_DTTM 
                                  WHEN (OSP_YN='N' AND LOC='002' AND  TCO_CELL_YN='Y' AND DESCR LIKE 'WH%' ) --
                                  THEN RECEIVING_DTTM 
                                  WHEN (OSP_YN='N' AND LOC='003' AND  TCO_CELL_YN='Y' AND DESCR LIKE 'WH%' ) --
                                  THEN RECEIVING_DTTM 
                             ELSE RECEIVING_DTTM
                             END 
                           ) AS AFTER_DTTM
                      FROM SCP_XLS_BOH_SMALL_CELL AS SUB
                      WHERE DIVISION_ID           = @p_division_id
                        AND PLAN_START_YYYYMMDD   = @p_plan_start_yyyymmdd
                        AND PLAN_TYPE             = @p_plan_type
                        AND SEQ                   = @p_seq
                        --AND DESCR             NOT IN ('FOR_HOLD','WH_HOLD')
                        -- [C20200422-000361] GSCM 시스템의 보류재고 감안한 계획 수립을 위한 시물레이션 변경 요청
                    ) X
                    GROUP BY X.CELL_ITEM_ID,
                            CONVERT(VARCHAR,X.AFTER_DTTM,112)


                UPDATE X
                  SET X.BOH = ISNULL(Y.QTY,0)
                 FROM #PSI_GLOBAL_SMALL_CELL X WITH (NOLOCK)
                 INNER JOIN #BOH Y WITH (NOLOCK)   
                  ON 0 = 0
                  --AND X.DIVISION_ID          = Y.DIVISION_ID      
                  --AND X.PLAN_START_YYYYMMDD  = Y.PLAN_START_YYYYMMDD      
                  --AND X.PLAN_TYPE            = Y.PLAN_TYPE      
                  --AND X.SEQ                  = Y.SEQ      
                  AND X.CELL_ITEM_ID         = Y.CELL_ITEM_ID    
                  AND X.MEASURE              = Y.MEASURE      
                  AND Y.MEASURE              =  'SHIP_AVAILABLE'


                  UPDATE X
                  SET X.QTY = ISNULL(Y.QTY,0)
                 FROM #PSI_GLOBAL_SMALL_CELL X WITH (NOLOCK)
                 INNER JOIN #BOH Y WITH (NOLOCK)   
                  ON 0 = 0
                  --AND X.DIVISION_ID          = Y.DIVISION_ID      
                  --AND X.PLAN_START_YYYYMMDD  = Y.PLAN_START_YYYYMMDD      
                  --AND X.PLAN_TYPE            = Y.PLAN_TYPE      
                  --AND X.SEQ                  = Y.SEQ      
                  AND X.YYYYMMDD             = Y.YYYYMMDD
                  AND X.CELL_ITEM_ID         = Y.CELL_ITEM_ID    
                  AND X.MEASURE              = Y.MEASURE      
                  AND Y.MEASURE              =  'ETA_PAST'

                 IF OBJECT_ID('tempdb..#BOH_HOLD') IS NOT NULL	
	                DROP TABLE #BOH_HOLD

                   SELECT X.CELL_ITEM_ID,
                           CONVERT(VARCHAR,X.AFTER_DTTM,112) AS YYYYMMDD,
                           SUM(X.AFTER_QTY) AS QTY,
                           (CASE WHEN CONVERT(VARCHAR,X.AFTER_DTTM,112) < @p_plan_start_yyyymmdd THEN 'SHIP_AVAILABLE' ELSE 'ETA_PAST' END) AS MEASURE
                    INTO #BOH_HOLD
                    FROM 
                    (
                    SELECT --SUB.*,
                            CELL_ITEM_ID,
                           ( CASE WHEN (OSP_YN='N' AND LOC='***' AND  TCO_CELL_YN='N' AND DESCR LIKE 'WH%') THEN QTY * FORMATION_TOTAL_YIELD ELSE QTY END) AS AFTER_QTY,
                           ( CASE WHEN (OSP_YN='N' AND LOC='***' AND  TCO_CELL_YN='N' AND DESCR LIKE 'WH%' AND TCO_EXIST_YN ='Y' ) --활성화 LT+ TOTAL TCO LT
                                  THEN DATEADD(D,TOTAL_LT_FORMATION+CELL_TO_TCO_TOTAL_BOD_LT,RECEIVING_DTTM) 
                                  WHEN (OSP_YN='N' AND LOC='***' AND  TCO_CELL_YN='N' AND DESCR LIKE 'WH%' AND TCO_EXIST_YN ='N' ) --활성화 LT
                                  THEN DATEADD(D,TOTAL_LT_FORMATION,RECEIVING_DTTM) 
                                  WHEN (OSP_YN='N' AND LOC='001' AND  TCO_CELL_YN='N' AND DESCR LIKE 'FOR%' AND TCO_EXIST_YN ='Y' ) --TOTAL TCO LT
                                  THEN DATEADD(D,CELL_TO_TCO_TOTAL_BOD_LT,RECEIVING_DTTM)  
                                  WHEN (OSP_YN='N' AND LOC='001' AND  TCO_CELL_YN='N' AND DESCR LIKE 'FOR%' AND TCO_EXIST_YN ='N' ) --
                                  THEN RECEIVING_DTTM 
                                  WHEN (OSP_YN='N' AND LOC='001' AND  TCO_CELL_YN='N' AND DESCR LIKE 'WH%' AND TCO_EXIST_YN ='Y' ) --TOTAL TCO LT
                                  THEN DATEADD(D,CELL_TO_TCO_TOTAL_BOD_LT,RECEIVING_DTTM) 
                                  WHEN (OSP_YN='N' AND LOC='001' AND  TCO_CELL_YN='N' AND DESCR LIKE 'WH%' AND TCO_EXIST_YN ='N' ) --
                                  THEN RECEIVING_DTTM 
                                  WHEN (OSP_YN='N' AND LOC='002' AND  TCO_CELL_YN='N' AND DESCR LIKE 'WH%' AND TCO_EXIST_YN ='Y' ) --TOTAL TCO LT
                                  THEN DATEADD(D,CELL_TO_TCO_TOTAL_BOD_LT,RECEIVING_DTTM) 
                                  WHEN (OSP_YN='N' AND LOC='002' AND  TCO_CELL_YN='N' AND DESCR LIKE 'WH%' AND TCO_EXIST_YN ='N' ) --
                                  THEN RECEIVING_DTTM 
                                  WHEN (OSP_YN='N' AND LOC='003' AND  TCO_CELL_YN='N' AND DESCR LIKE 'WH%' AND TCO_EXIST_YN ='Y' ) --
                                  THEN RECEIVING_DTTM
                                  WHEN (OSP_YN='N' AND LOC='003' AND  TCO_CELL_YN='N' AND DESCR LIKE 'WH%' AND TCO_EXIST_YN ='N' ) --
                                  THEN RECEIVING_DTTM
                                  WHEN (OSP_YN='Y' AND LOC='***' AND  TCO_CELL_YN='N' AND DESCR LIKE 'INT%' AND TCO_EXIST_YN ='Y' ) --TCO_TO_CELL_BOD_LT
                                  THEN DATEADD(D,TCO_TO_CELL_BOD_LT,RECEIVING_DTTM) 
                                  WHEN (OSP_YN='Y' AND LOC='***' AND  TCO_CELL_YN='N' AND DESCR LIKE 'WH%' AND TCO_EXIST_YN ='Y' ) --TCO_TO_CELL_BOD_LT
                                  THEN DATEADD(D,TCO_TO_CELL_BOD_LT,RECEIVING_DTTM) 
                                  WHEN (OSP_YN='Y' AND LOC='***' AND  TCO_CELL_YN='Y' AND DESCR LIKE 'WH%' ) --TCO_TO_CELL_BOD_LT
                                  THEN DATEADD(D,TCO_TO_CELL_BOD_LT,RECEIVING_DTTM) 
                                  WHEN (OSP_YN='N' AND LOC='002' AND  TCO_CELL_YN='Y' AND DESCR LIKE 'INT%' ) --
                                  THEN RECEIVING_DTTM 
                                  WHEN (OSP_YN='N' AND LOC='002' AND  TCO_CELL_YN='Y' AND DESCR LIKE 'WH%' ) --
                                  THEN RECEIVING_DTTM 
                                  WHEN (OSP_YN='N' AND LOC='003' AND  TCO_CELL_YN='Y' AND DESCR LIKE 'WH%' ) --
                                  THEN RECEIVING_DTTM 
                             ELSE RECEIVING_DTTM
                             END 
                           ) AS AFTER_DTTM
                      FROM SCP_XLS_BOH_SMALL_CELL AS SUB
                      WHERE DIVISION_ID           = @p_division_id
                        AND PLAN_START_YYYYMMDD   = @p_plan_start_yyyymmdd
                        AND PLAN_TYPE             = @p_plan_type
                        AND SEQ                   = @p_seq
                        AND DESCR             NOT IN ('FOR_HOLD','WH_HOLD')
                        -- [C20200422-000361] GSCM 시스템의 보류재고 감안한 계획 수립을 위한 시물레이션 변경 요청
                    ) X
                    GROUP BY X.CELL_ITEM_ID,
                            CONVERT(VARCHAR,X.AFTER_DTTM,112)


                  -- ETA_PAST QTY의 엔진시작일자 보다 큰 일자의 SUM
                  UPDATE X
                  SET X.BOH = Z.QTY
                 FROM #PSI_GLOBAL_SMALL_CELL X WITH (NOLOCK)
                 INNER JOIN 
                            (
                              SELECT CELL_ITEM_ID, SUM(ISNULL(Y.QTY,0)) AS QTY
                              FROM #BOH_HOLD Y WITH (NOLOCK)   
                              WHERE 0 = 0
                                AND Y.MEASURE = 'ETA_PAST'
                              GROUP BY CELL_ITEM_ID
                            ) Z
                  ON 0 = 0
                  AND X.CELL_ITEM_ID         = Z.CELL_ITEM_ID  
                  AND X.MEASURE              =  'BEFORE_BOXING'

            -------------------------------------------------------------------------------------------------------------         
            -- CELL_FORM_HOLD_UNDER 추가  
            -- [C20200422-000361] GSCM 시스템의 보류재고 감안한 계획 수립을 위한 시물레이션 변경 요청
            ------------------------------------------------------------------------------------------------------------- 

            IF OBJECT_ID('tempdb..#PLN_TH_ENG_STOCK_PLAN_FOR_HOLD') IS NOT NULL	
	                DROP TABLE #PLN_TH_ENG_STOCK_PLAN_FOR_HOLD

              SELECT SUBSTRING(A.MASTER_ID,1,2) AS DIVISION_ID
                      ,SUBSTRING(A.SITE_ID, 1, CHARINDEX('~',A.SITE_ID)-1)              AS FROM_SITE                               
                      ,A.ITEM_ID                                 
                      , CONVERT(NVARCHAR, A.RECEIVING_DTTM,112)  AS YYYYMMDD
                      ,SUM(ISNULL(A.QTY,0))   AS QTY                                                  
                INTO #PLN_TH_ENG_STOCK_PLAN_FOR_HOLD
                FROM SCP_PLN_TH_ENG_STOCK_PLAN A WITH(NOLOCK)                   
                 WHERE 1 = 1           
                  AND A.MASTER_ID   = @p_master_id                    
                  AND A.PLAN_ID     = @p_engine_plan_id                    
                  AND A.LOT_ID LIKE 'FOR%'
                  AND A.DESCR       = 'FOR_HOLD'
                GROUP BY                     
                       SUBSTRING(A.MASTER_ID,1,2)                          
                      ,SUBSTRING(A.SITE_ID, 1, CHARINDEX('~',A.SITE_ID)-1)      
                      ,A.ITEM_ID                                 
                      , CONVERT(NVARCHAR, A.RECEIVING_DTTM,112) 


                 UPDATE X
                    SET X.QTY = Z.QTY
                   FROM #PSI_GLOBAL_SMALL_CELL X  WITH (NOLOCK)
                   INNER JOIN (
                                SELECT ITEM_ID
                                    ,(CASE WHEN UNHOLD_EXP_DATE <= @p_plan_start_yyyymmdd THEN @p_plan_start_yyyymmdd ELSE UNHOLD_EXP_DATE END ) AS YYYYMMDD
	                                  ,SUM(QTY) AS QTY
                                FROM   SCM_DNM_STOCK_AGING_V WITH(NOLOCK)
                                WHERE  CUTOFF_DATE = @p_cutoff_date
                                --AND  DIVISION_ID = '40' 
                                --AND  ITEM_ID = 'MCCE121501A3' 
                                AND  WIPHOLD_YN = 'Y'
                                AND  UNHOLD_EXP_DATE                 IS NOT NULL
                                GROUP BY ITEM_ID
                                    ,(CASE WHEN UNHOLD_EXP_DATE <= @p_plan_start_yyyymmdd THEN @p_plan_start_yyyymmdd ELSE UNHOLD_EXP_DATE END )
                             )  Z 
                      ON X.CELL_ITEM_ID = Z.ITEM_ID                        
--                     AND X.SITE_ID      = Z.FROM_SITE
                     AND X.YYYYMMDD     = Z.YYYYMMDD
                     AND X.MEASURE      = 'CELL_FORM_HOLD_UNDER'

                /*
                 UPDATE X
                    SET X.QTY = Z.QTY
                   FROM #PSI_GLOBAL_SMALL_CELL X  WITH (NOLOCK)
                   INNER JOIN (SELECT ITEM_ID, SUM(Y.QTY) AS QTY, Y.YYYYMMDD
                                 FROM #PLN_TH_ENG_STOCK_PLAN_FOR_HOLD Y  WITH (NOLOCK)
--                                WHERE YYYYMMDD = @p_plan_start_yyyymmdd
                                GROUP BY ITEM_ID, YYYYMMDD
                             )  Z 
                      ON X.CELL_ITEM_ID = Z.ITEM_ID                        
--                     AND X.SITE_ID      = Z.FROM_SITE
                     AND X.YYYYMMDD     = Z.YYYYMMDD
                     AND X.MEASURE      = 'CELL_FORM_HOLD_UNDER'
                  */


                  UPDATE X
                    SET X.QTY = Z.QTY
                   FROM #PSI_GLOBAL_SMALL_CELL X  WITH (NOLOCK)
                   INNER JOIN (SELECT ITEM_ID, SUM(Y.QTY) AS QTY, Y.YYYYMMDD
                                 FROM #PLN_TH_ENG_STOCK_PLAN_FOR_HOLD Y  WITH (NOLOCK)
--                                WHERE YYYYMMDD = @p_plan_start_yyyymmdd
                                GROUP BY ITEM_ID, YYYYMMDD
                             )  Z 
                      ON X.CELL_ITEM_ID = Z.ITEM_ID                        
--                     AND X.SITE_ID      = Z.FROM_SITE
                     AND X.YYYYMMDD     = Z.YYYYMMDD
                     AND X.MEASURE      = 'CELL_FORM_HOLD_UNDER_AVAILABLE'



                  -- BOH
                  UPDATE X
                    SET X.BOH = Z.QTY
                   FROM #PSI_GLOBAL_SMALL_CELL X  WITH (NOLOCK)
                   INNER JOIN (SELECT ITEM_ID, SUM(Y.QTY) AS QTY
                                 FROM #PLN_TH_ENG_STOCK_PLAN_FOR_HOLD Y  WITH (NOLOCK)
                                GROUP BY ITEM_ID
                             )  Z 
                      ON X.CELL_ITEM_ID = Z.ITEM_ID                        
                     AND X.MEASURE      = 'CELL_FORM_HOLD_UNDER'

            -------------------------------------------------------------------------------------------------------------         
            -- CELL_FORM_HOLD_AFTER 추가
            -- [C20200422-000361] GSCM 시스템의 보류재고 감안한 계획 수립을 위한 시물레이션 변경 요청
            ------------------------------------------------------------------------------------------------------------- 

            IF OBJECT_ID('tempdb..#PLN_TH_ENG_STOCK_PLAN_FOR_WH_HOLD') IS NOT NULL	
	                DROP TABLE #PLN_TH_ENG_STOCK_PLAN_FOR_WH_HOLD

              SELECT SUBSTRING(A.MASTER_ID,1,2) AS DIVISION_ID
                      ,SUBSTRING(A.SITE_ID, 1, CHARINDEX('~',A.SITE_ID)-1)              AS FROM_SITE                               
                      ,A.ITEM_ID                                 
                      , CONVERT(NVARCHAR, A.RECEIVING_DTTM,112)  AS YYYYMMDD
                      ,SUM(ISNULL(A.QTY,0))   AS QTY                                                  
                INTO #PLN_TH_ENG_STOCK_PLAN_FOR_WH_HOLD
                FROM SCP_PLN_TH_ENG_STOCK_PLAN A WITH(NOLOCK)                   
                 WHERE 1 = 1           
                  AND A.MASTER_ID   = @p_master_id                    
                  AND A.PLAN_ID     = @p_engine_plan_id                    
                  --AND A.LOT_ID LIKE 'FOR%'
                  AND A.DESCR       = 'WH_HOLD'
                GROUP BY                     
                       SUBSTRING(A.MASTER_ID,1,2)                          
                      ,SUBSTRING(A.SITE_ID, 1, CHARINDEX('~',A.SITE_ID)-1)      
                      ,A.ITEM_ID                                 
                      , CONVERT(NVARCHAR, A.RECEIVING_DTTM,112) 

                 UPDATE X
                    SET X.QTY = Z.QTY
                   FROM #PSI_GLOBAL_SMALL_CELL X  WITH (NOLOCK)
                   INNER JOIN (SELECT ITEM_ID, SUM(Y.QTY) AS QTY, Y.YYYYMMDD
                                 FROM #PLN_TH_ENG_STOCK_PLAN_FOR_WH_HOLD Y  WITH (NOLOCK)
--                                WHERE YYYYMMDD = @p_plan_start_yyyymmdd
                                GROUP BY ITEM_ID, YYYYMMDD
                             )  Z 
                      ON X.CELL_ITEM_ID = Z.ITEM_ID                        
--                     AND X.SITE_ID      = Z.FROM_SITE
                     AND X.YYYYMMDD     = Z.YYYYMMDD
                     AND X.MEASURE      = 'CELL_FORM_HOLD_AFTER'
                  
                  -- BOH
                  UPDATE X
                    SET X.BOH = Z.QTY
                   FROM #PSI_GLOBAL_SMALL_CELL X  WITH (NOLOCK)
                   INNER JOIN (SELECT ITEM_ID, SUM(Y.QTY) AS QTY
                                 FROM #PLN_TH_ENG_STOCK_PLAN_FOR_WH_HOLD Y  WITH (NOLOCK)
                                GROUP BY ITEM_ID
                             )  Z 
                      ON X.CELL_ITEM_ID = Z.ITEM_ID                        
                     AND X.MEASURE      = 'CELL_FORM_HOLD_AFTER'


			-- 2021-05-25   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 플랜 대응
			--  구 버전에서 PIVOT 생성단계 이후 단계를 호출하는 로직으로 분리함 (1 YEAR 구간별 생성 :: 중장기 구현시 컬럼 및 행 SIZE 제약 해결)
			--
			-- 동일 플랜의 구 data 삭제

			-------------------------------------------------------------------------------------------------------------         
            --  삭제 후 입력
            -------------------------------------------------------------------------------------------------------------
            IF @p_update ='Y'
              BEGIN
                DELETE FROM SCP_XLS_PSI_GLOBAL_SMALL_CELL                            
                      WHERE DIVISION_ID = @p_division_id 
                      AND CELL_ITEM_ID IN (SELECT DISTINCT ITEM_ID FROM SCP_XLS_CELL_PROD_Line_V WITH (NOLOCK) )
              END
            ELSE
              BEGIN
                DELETE FROM SCP_XLS_PSI_GLOBAL_SMALL_CELL                            
                    WHERE DIVISION_ID = @p_division_id -- AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd AND PLAN_TYPE = @p_plan_type AND SEQ = @p_seq                        
              END

			DECLARE @rows INT;  
			DECLARE @p_create_from_yyyymmdd  NVARCHAR(0008);
			DECLARE @p_create_to_yyyymmdd    NVARCHAR(0008);

			--  Plan End Date
			DECLARE @v_pet_date		NVARCHAR(12) = '';
			DECLARE @v_bp_flag		NVARCHAR(8) = '';
			DECLARE @v_bp_days		INT = 0;
			DECLARE @v_bp_plan_end_yyyymmdd NVARCHAR(0008) = '';

			SELECT @v_pet_date = p.horizon_end_date,
				   @v_bp_flag  = (case when DATEDIFF(DAY, p.plan_name, p.horizon_end_date) > 364 then 'Y' else 'N' end),
				   @v_bp_days  = (case when DATEDIFF(DAY, p.plan_name, p.horizon_end_date) > 364 then DATEDIFF(DAY, p.plan_name, p.horizon_end_date) - 363 else 0 end)
			FROM   dbo.scm_mst_plan p WITH(NOLOCK)
			WHERE  p.division_id = @p_division_id
			AND    p.plan_id     = (SELECT max(plan_id) FROM dbo.scm_mst_plan p WITH(NOLOCK) WHERE division_id = @p_division_id and plan_id < 9999)
			;

			SET @p_create_from_yyyymmdd = @p_plan_start_yyyymmdd;
			SET @p_create_to_yyyymmdd   = CONVERT(VARCHAR(8), DATEADD(day, 363, @p_create_from_yyyymmdd), 112);

			EXEC @rows = PR_SCP_XLS_PSI_GLOBAL_SMALL_CELL_S       @p_plan_cycle             = @p_plan_cycle          
                                                                , @p_plan_start_yyyymmdd    = @p_plan_start_yyyymmdd          
                                                                , @p_plan_id                = @p_plan_id          
                                                                , @p_modeling_id            = @p_modeling_id          
                                                                , @p_seq                    = @p_seq          
                                                                , @p_plan_type              = @p_plan_type          
                                                                , @p_master_id              = @p_master_id          
                                                                , @p_division_id            = @p_division_id          
                                                                , @p_engine_plan_id         = @p_engine_plan_id        
																, @p_update                 = @p_update
																, @p_create_from_yyyymmdd   = @p_create_from_yyyymmdd
																, @p_create_to_yyyymmdd     = @p_create_to_yyyymmdd
                                                                , @p_user_id                = @v_batch_user
																;
            IF (@rows < 0)  GOTO _RETURN_ERR_CODE
			
			IF @v_bp_flag = 'Y'
			BEGIN
				-- 2 YEAR PIVOT DATS 생성
				SET @p_create_from_yyyymmdd = CONVERT(VARCHAR(8), DATEADD(day, 1, @p_create_to_yyyymmdd), 112);
				SET @p_create_to_yyyymmdd   = CONVERT(VARCHAR(8), DATEADD(day, 363, @p_create_from_yyyymmdd), 112);

				EXEC @rows = PR_SCP_XLS_PSI_GLOBAL_SMALL_CELL_S       @p_plan_cycle             = @p_plan_cycle          
																	, @p_plan_start_yyyymmdd    = @p_plan_start_yyyymmdd          
																	, @p_plan_id                = @p_plan_id          
																	, @p_modeling_id            = @p_modeling_id          
																	, @p_seq                    = @p_seq          
																	, @p_plan_type              = @p_plan_type          
																	, @p_master_id              = @p_master_id          
																	, @p_division_id            = @p_division_id          
																	, @p_engine_plan_id         = @p_engine_plan_id      
																	, @p_update                 = @p_update
																	, @p_create_from_yyyymmdd   = @p_create_from_yyyymmdd
																	, @p_create_to_yyyymmdd     = @p_create_to_yyyymmdd
																	, @p_user_id                = @v_batch_user
																	;
				IF (@rows < 0)  GOTO _RETURN_ERR_CODE
			END
                         
            -------------------------------------------------------------------------------------------------------------         
            -- 임시 TEMP  테이블 DROP  
            -------------------------------------------------------------------------------------------------------------
              IF OBJECT_ID('tempdb..#MEASURE')    IS NOT NULL	
		            DROP TABLE #MEASURE

              IF OBJECT_ID('tempdb..#ITEM_ID') IS NOT NULL                  
                DROP TABLE #ITEM_ID  

              IF OBJECT_ID('tempdb..#PSI_GLOBAL_SMALL_CELL') IS NOT NULL       
		            DROP TABLE #PSI_GLOBAL_SMALL_CELL     

              IF OBJECT_ID('tempdb..#tmp_SHIP_REQ_PACK') IS NOT NULL                  
                DROP TABLE #tmp_SHIP_REQ_PACK  

              IF OBJECT_ID('tempdb..#tmp_SHIP_REQ_CELL') IS NOT NULL                  
                DROP TABLE #tmp_SHIP_REQ_CELL  

              IF OBJECT_ID('tempdb..#LINE_WORKINGTIME_BY_LOSS') IS NOT NULL      
	              DROP TABLE #LINE_WORKINGTIME_BY_LOSS;  

              IF OBJECT_ID('tempdb..#LineLoad')   IS NOT NULL
	              DROP TABLE #LineLoad

	            IF OBJECT_ID('tempdb..#BOH')        IS NOT NULL       
		            DROP TABLE #BOH

              IF OBJECT_ID('tempdb..#SCP_XLS_PSI_GLOBAL_SMALL_CELL') IS NOT NULL	
	              DROP TABLE #SCP_XLS_PSI_GLOBAL_SMALL_CELL

              IF OBJECT_ID('tempdb..#Rn') IS NOT NULL	
	              DROP TABLE #Rn

              IF OBJECT_ID('tempdb..#CALENDAR') IS NOT NULL	
	              DROP TABLE #CALENDAR

              IF OBJECT_ID('tempdb..#HEADER') IS NOT NULL	
	              DROP TABLE #HEADER

              IF OBJECT_ID('tempdb..#LineLoad_Pivot') IS NOT NULL	
	              DROP TABLE #LineLoad_Pivot

              IF OBJECT_ID('tempdb..#LineLoad_WEEK') IS NOT NULL	
	              DROP TABLE #LineLoad_WEEK



			  IF OBJECT_ID('tempdb..#SHORT_DEMAND_QTY') IS NOT NULL                  
				  DROP TABLE #SHORT_DEMAND_QTY  ;	            
                
        -----------------------------------------------------------      
        -- 실행 Logic END --      
        -----------------------------------------------------------      
        --IF @@TRANCOUNT > 0      
        --  BEGIN      
        --    COMMIT TRAN T1;      
        --  END;             
      
      
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
      
  
-- 임시 운영반영시에 주석처리 할것.    
     SET @v_exec_time  =  REPLICATE('0', 2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +     
                          REPLICATE('0', 2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))     
       
    -- 종료 LOG          
    SET @v_log_type     = N'END';          
    SET @v_log_message  = N'########## END of procedure ##########';          
    SET @v_description  = N'['+@p_master_id+']['+@p_engine_plan_id+'][' + @v_exec_time + ']';                
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
