



/*      
 * Program ID   : PR_SCP_XLS_PSI_GLOBAL_ESS        
 * Description  : PR_SCP_XLS_CREATE_DATA 에서 호출함.      
 * OutTable     :      
 * Execute      : 
    -- DELETE FROM SCM_SYS_LOG_BATCH where CREATED_BY ='kth'

      EXEC PR_SCP_XLS_PSI_GLOBAL_ESS
               @p_plan_cycle          = 'WEEKLY'
             , @p_plan_start_yyyymmdd = '20250217'
             , @p_plan_id             = '1379'
             , @p_modeling_id         = '3'
             , @p_seq                 = '2'
             , @p_plan_type           = 'FN'
             , @p_master_id           = '82::WEEKLY'
             , @p_division_id         = '82'
             , @p_engine_plan_id      = '1379::FN::2'
             , @p_user_id             = 'KSK'
			 , @p_is_debug		   =  1
 
    SELECT * FROM SCM_SYS_LOG_BATCH  where PROGRAM_NAME ='PR_SCP_XLS_PSI_GLOBAL_ESS' order by CREATION_DATE desc

 * Program History      
 *===================================================================================================      
 *   Date       In Charge      Description      
 *===================================================================================================      
 * 2019.06.27   KTH         Initial Release [PJ20189106] 전지.GSCM 고도화 이행
 * 2019.07.16   KTH         ATTRIBUTE2에 LT(일) 추가 주별/일별 LT를 보여주기 위해서
 * 2019.08.28   KTH         SHIP_REQ_PACK_TOTAL,SHIP_REQ_CELL_TOTAL, SHIP_REQ, SEMI_SHIP_REQ 추가
 * 2019.08.29   KTH         PROJECT_CODE 추가('-' --> PROJECT_CODE)
 * 2019.08.30   KTH         SEMI_PACK_PROD_CELL FROM_SITE 수정('-' --> FROM_SITE표기)
 * 2019.12.04   KTH         CELL_PROD, CELL_PROD_LOAD에서 PROD_LINE이 '-'인 데이터 삭제 로직 추가
 * 2020.01.07   KTH         #Rn 테이블 변경
 * 2020.01.16   KTH         PROJECT NAME 반영 ATTRIBUTE8 반영 
 * 2020.02.06   KTH         ESS 외주 Line별 생산 Target 관련 OSP_YN로직 수정
 * 2020.02.19   KTH         YIELD 로직 변경 (CASE WHEN Y.SSP_MODIFY_YIELD > 0.0 THEN Y.SSP_MODIFY_YIELD ELSE Y.FORMATION_TOTAL_YIELD END)
 * 2020.02.19   KTH         PACK/CELL 분리 작업 반영  XLSPSI04 -> XLSPSI14 
 * 2020.02.26   KTH         CELL_TACT_TIME, CELL_WORKING_TIME 로직 추가
 * 2020.02.28   KTH         PACK_WORKING_TIME, CELL_WORKING_TIME 수정
 * 2020.03.03   KTH         PACK_BOH 로직 수정(SCP_ANL_PSI_GLOBAL.QTY --> SCP_ANL_PSI_GLOBAL.FROM_BOH_QTY)
 * 2020.06.26   KTH         [전지 공급 대응력 향상을 위한 RTF 적확도 개선] : GSCM 시스템의 보류재고 감안한 계획 수립을 위한 시뮬레이션 변경 요청(자동차, ESS)
 * 2020.07.02   KSW         전지 공급 대응력 향상을 위한 SCM 관리 체계 개선 - DIO 기준/최소 Gap Measure 추가
 * 2020.07.13   KSW         전지 공급 대응력 향상을 위한 SCM 관리 체계 개선 - DIO 수정 관련 - 기준/최소 쿼리에서 YYYYMM -> YYYYQ 으로 변경
 * 2020.07.14   KSW         생산계획이 존재하지 않을경우 CELL 재고관련 Measure 가 누락되는 Case 보완
 * 2020.08.20   KSW         생산계획이 없거나 출하계획도 없는 경우 Pack 재고정보(PACK_BOH, PACK_EOH) Measure 추가
 * 2020.09.01   KSW         생산계획이 없거나 출하계획도 없는 경우 Pack 재고정보(PACK_BOH, PACK_EOH) Measure 추가 ==> Operation id 에서 '_P' 를 삭제 (Pack Load Ratio 정렬오류)
 * 2021.05.25   KSW         NICK_NAME 누락방지
 * 2021.06.03   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 대응
                            - 구 버전에서 PIVOT 생성단계 이후 단계를 호출하는 로직으로 분리함 (+26주 구간별 생성 :: 중장기 구현시 컬럼 및 행 SIZE 제약 해결)
							- 실제로는 364 + 364 플랜 DATA 가 생성됨
 * 2021.08.23   KSW         PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 - SCP_MST_BOD_V --> SCP_MST_BOD_N_V
 * 2021.11.12   KSW         튜닝개선 - 0값 제거 및 쿼리재조정
 * 2021.12.22   KSW			DC link. Pack Semi 계획에 관련 measure 생성로직 추가
 * 2022.05.12   KSW         복수 BOD 수립관련건 적용
 * 2024.07.01	KSK		    PJ20230691  SCM 역량 강화 위한 SCP 개선과제 이행 : 활성화 분리
 * 2022.11.14	KJH		    SEMI_SHIP_PLAN이 없을 경우 SEMI_WHIN 안나옴 ==> SEMI_INTRANSIT_ETA가 있을 경우  SEMI_WHIN를 추가함.
 * 2025.01.16	KSK		    이력테이블 생성(3주차 까지)
 * 2025.04.17	KSK		    디버그 파라미터 추가
 * 2025.04.18	KSK		    셀제품의 셀특성화 정보 누락방지 
 * 2025.08.11	KSK		    디버그용 파라미터(@p_is_debug ) 추가,[E20250805-000724] ess 사업부 시뮬레이터 특정 모델 저장 안되는 이슈
 * 2025.09.02	kimcd		속도 개선 HASH 추가
 * 2026.05.22	ymh			E20260331-000738 82사업부 MA Plan 수행 시 속도지연
 */    


CREATE PROCEDURE [dbo].[PR_SCP_XLS_PSI_GLOBAL_ESS]
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
    , @p_user_id              NVARCHAR(0150)  = 'SCP_batch'        
	, @p_is_debug				 bit	= 0				--0 : RELEASE, 1 : DEBUG  (KSK, 250417)
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
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SCP_XLS_PSI_GLOBAL_ESS';      
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...      
    DECLARE @n_log_count    INTEGER = 0;      
    DECLARE @v_log_message  NVARCHAR(1000);      
    DECLARE @v_description  NVARCHAR(500);    
    DECLARE @v_table_id     NVARCHAR(150) = N'SCM_SYS_LOG_BATC';   
    DECLARE @d_event_date   DATETIME;      
  
  -- 시작 LOG      
    SET @v_log_type     = N'START';      
    SET @v_log_message  = N'########## Start of procedure ##########';      
    SET @v_description  = @v_program_name + ':' + N'INSERT LOGIC';      
    SET @d_event_date   = SYSDATETIME();      
	IF @p_is_debug = 0
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

    DECLARE @p_program_id		NVARCHAR(30) = 'XLSPSI14'          
    DECLARE @p_to_yyyymmdd  VARCHAR(8)   =  ''	---CONVERT(VARCHAR(8), DATEADD(day, 728, @p_plan_start_yyyymmdd), 112)		-- PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 대응
    DECLARE @p_cutoff_date		VARCHAR(8)   =  CONVERT(VARCHAR(8), DATEADD(day,  -1, @p_plan_start_yyyymmdd), 112)	
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
	            SELECT M.COLUMN_NAME, M.COLUMN_LABEL_NAME,M.SORT_ORDER_NO,(CASE WHEN ATTRIBUTE1 ='PACK' THEN 'P' WHEN ATTRIBUTE1 ='CELL' THEN 'A'  ELSE 'C' END) AS DIV, ATTRIBUTE2 AS GUBUN
              INTO #MEASURE
  	          FROM SCM_MST_SHEET_MEASURE M WITH(NOLOCK)
	            WHERE M.PROGRAM_ID      = @p_program_id
	              AND M.VALID_YN        = 'Y'

			 IF @P_IS_DEBUG = 1 SELECT '#MEASURE' #MEASURE,  * FROM #MEASURE

            -------------------------------------------------------------------------------------------------------------         
            --  데이터 이관 ('MKT_FCST','SHIP_PLAN','PRODUCTION')
            -------------------------------------------------------------------------------------------------------------     
              IF OBJECT_ID('tempdb..#PSI_GLOBAL') IS NOT NULL      
	              DROP TABLE #PSI_GLOBAL;        

	            CREATE TABLE #PSI_GLOBAL (
		             DIVISION_ID		      NVARCHAR(060)	
		            ,OPERATION_GROUP	    NVARCHAR(060)
		            ,CELL_ITEM_ID		      NVARCHAR(100)	
		            ,ITEM_ID			        NVARCHAR(100)
		            ,TO_SITE			        NVARCHAR(060)
                ,PROJECT_CODE         NVARCHAR(050)     -- FG 때문에 추가
		            ,TO_BOH_QTY			      numeric(20,10)    --BIGINT
		            ,FROM_BOH_QTY		      numeric(20,10)    -- BIGINT
		            ,INCOTERMS			      NVARCHAR(20)
		            ,FROM_SITE			      NVARCHAR(60)
                ,TRANSPORT_MODE       NVARCHAR(50)
                ,PROD_LINE            NVARCHAR(50)
		            ,MEASURE			        NVARCHAR(100)
		            ,YYYYMMDD			        NVARCHAR(010)
		            ,QTY				          NUMERIC(20,10)
		            ,SORT_ORDER_NO		    INT
		            ,COLUMN_LABEL_NAME	  NVARCHAR(300)
		            ,BOD_ID				        NVARCHAR(300)
                ,ATTRIBUTE1			      NVARCHAR(150)
		            ,ATTRIBUTE9			      NVARCHAR(150)   -- OPERATION_ID
	            );

---- 단위처리시간 추출 --
--print N'position_1 measure 임시정보 및 #PSI_GLOBAL temp 생성'
--print REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +     
--      REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))     
--set @v_start_time = SYSDATETIME();
---- 단위처리시간 추출 --

            -------------------------------------------------------------------------------------------------------------------------         
            -- SHIP_PLAN (FG) (팩,셀 공통) - MKT_FCST, SHIP_PLAN
            -------------------------------------------------------------------------------------------------------------------------
			-- E20260331-000738 82사업부 MA Plan 수행 시 속도지연 기존로직 주석처리 시작
			/* 
            INSERT INTO #PSI_GLOBAL
                SELECT A.DIVISION_ID								
			            , A.BIZ_TYPE						
			            , '' AS CELL_ITEM_ID							
			            , A.ITEM_ID										
			            , ISNULL(NULLIF(A.TO_SITE, '') , '-') TO_SITE		
                  , A.PROJECT_CODE
			            , 0 AS TO_BOH_QTY										
			            , 0 AS FROM_BOH_QTY									
			            , A.INCOTERMS 										
			            , A.FROM_SITE 										
                  -- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 - SCP_MST_BOD_V --> SCP_MST_BOD_N_V
				  ,ISNULL((SELECT TOP 1 TRANSPORT_MODE FROM SCP_MST_BOD_N_V C WITH(NOLOCK) where 0 = 0 and C.division_id =A.division_id AND A.BOD_ID = C.BOD_ID AND A.FROM_SITE = C.FROM_SITE	),'-') AS TRANSPORT_MODE
                  , '-'              AS PROD_LINE
			            , A.MEASURE												-- SHIP_PLAN FG
			            , A.YYYYMMDD        AS YYYYMMDD				
                  , ISNULL(QTY,0)     AS QTY  -- 기존 INTRANSIT 무시하고 모두 0
			            , M.SORT_ORDER_NO									
			            , M.COLUMN_LABEL_NAME							
			            , A.BOD_ID						
                  , 'SCP_ANL_SHIPMENT_PLAN_FG' AS ATTRIBUTE1										
			            , A.ATTRIBUTE9										
	               FROM SCP_ANL_SHIPMENT_PLAN_FG A WITH(NOLOCK)	
                 INNER JOIN SCM_SYS_CALENDAR_M  C  WITH(NOLOCK) 
                    ON A.YYYYMMDD           = C.BASIS_YYYYMMDD				
                INNER JOIN #MEASURE M WITH(NOLOCK)	
                    ON M.COLUMN_NAME          IN ('SHIP_PLAN','MKT_FCST','SHIP_REQ')
                    AND A.MEASURE             = M.COLUMN_NAME
                 WHERE A.DIVISION_ID			    =  @p_division_id
		                AND A.PLAN_START_YYYYMMDD	=  @p_plan_start_yyyymmdd
		                AND A.PLAN_TYPE				    =  @p_plan_type
		                AND A.SEQ					        =  @p_seq
		                AND A.YYYYMMDD            >=  @p_plan_start_yyyymmdd
		                AND A.YYYYMMDD            <   @p_to_yyyymmdd
		                --AND A.YYYYMMDD            <=   @p_to_yyyymmdd  --말일포함(KSK, 20240814, 운영배포보류)             
                    AND A.MEASURE             IN ('SHIP_PLAN','MKT_FCST','SHIP_REQ')  
			*/
			-- E20260331-000738 82사업부 MA Plan 수행 시 속도지연 기존로직 주석처리 끝

			-- E20260331-000738 82사업부 MA Plan 수행 시 속도지연 신규로직 시작
			IF OBJECT_ID('tempdb..#BOD_TRANSPORT') IS NOT NULL
				DROP TABLE #BOD_TRANSPORT;

			SELECT 
				 B.DIVISION_ID
				,B.BOD_ID
				,B.FROM_SITE
				,MIN(B.TRANSPORT_MODE) AS TRANSPORT_MODE   -- TOP 1과 동일 효과
			INTO #BOD_TRANSPORT
			FROM SCP_MST_BOD_N_V B WITH(NOLOCK)
			WHERE B.DIVISION_ID = @p_division_id
			GROUP BY 
				 B.DIVISION_ID
				,B.BOD_ID
				,B.FROM_SITE;

			CREATE CLUSTERED INDEX CX_BOD_TRANSPORT 
				ON #BOD_TRANSPORT (DIVISION_ID, BOD_ID, FROM_SITE);

			-- Step 2: #MEASURE 필터링 (SHIP_PLAN, MKT_FCST, SHIP_REQ만 미리 필터)
			IF OBJECT_ID('tempdb..#MEASURE_FILTERED') IS NOT NULL
				DROP TABLE #MEASURE_FILTERED;

			WITH MEASURE AS (
			SELECT 
				 M.COLUMN_NAME
				,M.COLUMN_LABEL_NAME
				,M.SORT_ORDER_NO
			--SELECT M.*
			FROM #MEASURE M WITH(NOLOCK)
			WHERE M.COLUMN_NAME IN ('SHIP_PLAN','MKT_FCST','SHIP_REQ')
			)
			SELECT M.COLUMN_NAME
				,M.COLUMN_LABEL_NAME
				,M.SORT_ORDER_NO
			INTO #MEASURE_FILTERED
			FROM  MEASURE M
			;

			CREATE CLUSTERED INDEX CX_MEASURE_FILTERED 
			ON #MEASURE_FILTERED (COLUMN_NAME);

			INSERT INTO #PSI_GLOBAL
            SELECT A.DIVISION_ID								
			        , A.BIZ_TYPE						
			        , '' AS CELL_ITEM_ID							
			        , A.ITEM_ID										
			        , ISNULL(NULLIF(A.TO_SITE, '') , '-') TO_SITE		
					, A.PROJECT_CODE
			        , 0 AS TO_BOH_QTY										
			        , 0 AS FROM_BOH_QTY									
			        , A.INCOTERMS 										
			        , A.FROM_SITE 										
                -- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 - SCP_MST_BOD_V --> SCP_MST_BOD_N_V
					, ISNULL(BT.TRANSPORT_MODE, '-')                                 AS TRANSPORT_MODE
					, '-'              AS PROD_LINE
			        , A.MEASURE												-- SHIP_PLAN FG
			        , A.YYYYMMDD        AS YYYYMMDD				
					, ISNULL(QTY,0)     AS QTY  -- 기존 INTRANSIT 무시하고 모두 0
			        , M.SORT_ORDER_NO									
			        , M.COLUMN_LABEL_NAME							
			        , A.BOD_ID						
					, 'SCP_ANL_SHIPMENT_PLAN_FG' AS ATTRIBUTE1										
			        , A.ATTRIBUTE9										
	            FROM SCP_ANL_SHIPMENT_PLAN_FG A WITH(NOLOCK)	
					INNER JOIN SCM_SYS_CALENDAR_M  C  WITH(NOLOCK) 
                    ON A.YYYYMMDD           = C.BASIS_YYYYMMDD				
					INNER JOIN #MEASURE_FILTERED M WITH(NOLOCK)	
                    ON M.COLUMN_NAME          IN ('SHIP_PLAN','MKT_FCST','SHIP_REQ')
                    AND A.MEASURE             = M.COLUMN_NAME
					LEFT JOIN #BOD_TRANSPORT BT WITH(NOLOCK)
					ON  BT.DIVISION_ID = A.DIVISION_ID
					AND BT.BOD_ID      = A.BOD_ID
					AND BT.FROM_SITE   = A.FROM_SITE
			WHERE A.DIVISION_ID         = @p_division_id
				AND A.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
				AND A.PLAN_TYPE           = @p_plan_type
				AND A.SEQ                 = @p_seq
				AND A.YYYYMMDD            >= @p_plan_start_yyyymmdd
				AND A.YYYYMMDD            < @p_to_yyyymmdd
				AND A.MEASURE             IN ('SHIP_PLAN','MKT_FCST','SHIP_REQ')
			OPTION (
				 LOOP JOIN                -- Hash Match 금지 → 메모리 그랜트 제거
				,MAXDOP 1                 -- 병렬처리 금지 → MEMORY_ALLOCATION_EXT 대기 제거
				,OPTIMIZE FOR UNKNOWN     -- 파라미터 스니핑 방지 (상수 하드코딩 불필요)
										  -- 옵티마이저가 통계 기반 평균값으로 실행계획 수립
										  -- → 특정 파라미터값에 종속된 실행계획 고착 방지
			);


			-- E20260331-000738 82사업부 MA Plan 수행 시 속도지연 신규로직 끝


			IF @P_IS_DEBUG = 1 SELECT '233' AS "#PSI_GLOBAL", * FROM #PSI_GLOBAL WHERE  @p_plan_start_yyyymmdd = YYYYMMDD 


		-- E20260331-000738 82사업부 MA Plan 수행 시 속도지연
        SET @v_log_message = N'########## INSERT #PSI_GLOBAL ##########';
        SET @v_description = @v_program_name + ':' + N' MEASURE SHIP_PLAN / MKT_FCST / SHIP_REQ ';
        SET @d_event_date = SYSDATETIME();
		EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
								  ,@p_log_type      =  N'TXN'
								  ,@p_log_count     = 0       
								  ,@p_log_message   = @v_log_message       
								  ,@p_description   = @v_description       
								  ,@p_event_date    = @d_event_date       
								  ,@p_user_id       = @v_batch_user      
                                  ;    


---- 단위처리시간 추출 --
--print N'position_2 #PSI_GLOBAL temp에 SHIP_PLAN data 추가'
--print REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +     
--      REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))     
--set @v_start_time = SYSDATETIME();
---- 단위처리시간 추출 --

            -------------------------------------------------------------------------------------------------------------------------         
            -- 복수 BOD 수립관련건 적용 :: 2022.04.18
            ------------------------------------------------------------------------------------------------------------------------- start

            IF OBJECT_ID('tempdb..#BOD_OTHER_SHIP_PLAN') IS NOT NULL
				DROP TABLE #BOD_OTHER_SHIP_PLAN
				;

	            CREATE TABLE #BOD_OTHER_SHIP_PLAN (
		             DIVISION_ID		      NVARCHAR(060)	
		            ,OPERATION_GROUP	    NVARCHAR(060)
		            ,CELL_ITEM_ID		      NVARCHAR(100)	
		            ,ITEM_ID			        NVARCHAR(100)
		            ,TO_SITE			        NVARCHAR(060)
                ,PROJECT_CODE         NVARCHAR(050)     -- FG 때문에 추가
		            ,TO_BOH_QTY			      numeric(20,10)    --BIGINT
		            ,FROM_BOH_QTY		      numeric(20,10)    -- BIGINT
		            ,INCOTERMS			      NVARCHAR(20)
		            ,FROM_SITE			      NVARCHAR(60)
                ,TRANSPORT_MODE       NVARCHAR(50)
                ,PROD_LINE            NVARCHAR(50)
		            ,MEASURE			        NVARCHAR(100)
		            ,YYYYMMDD			        NVARCHAR(010)
		            ,QTY				          NUMERIC(20,10)
		            ,SORT_ORDER_NO		    INT
		            ,COLUMN_LABEL_NAME	  NVARCHAR(300)
		            ,BOD_ID				        NVARCHAR(300)
                ,ATTRIBUTE1			      NVARCHAR(150)
		            ,ATTRIBUTE9			      NVARCHAR(150)   -- OPERATION_ID
	            );

            INSERT INTO #BOD_OTHER_SHIP_PLAN
            SELECT    X.DIVISION_ID								
			        , X.OPERATION_GROUP AS BIZ_TYPE						
			        , '' AS CELL_ITEM_ID							
			        , X.ITEM_ID										
			        , ISNULL(NULLIF(X.TO_SITE, '') , '-') TO_SITE		
					, X.PROJECT_CODE
			        , 0 AS TO_BOH_QTY										
			        , 0 AS FROM_BOH_QTY									
			        , X.INCOTERMS 										
			        , X.FROM_SITE 										
					, TRANSPORT_MODE
					, '-'              AS PROD_LINE
			        , 'SHIP_PLAN' AS MEASURE												-- SHIP_PLAN FG
			        , @p_plan_start_yyyymmdd      AS YYYYMMDD				
					, 0     AS QTY   
			        , M.SORT_ORDER_NO									
			        , M.COLUMN_LABEL_NAME							
			        , X.BOD_ID						
					, 'SCP_ANL_SHIPMENT_PLAN_FG' AS ATTRIBUTE1										
			        , X.ATTRIBUTE9	
			  FROM (SELECT DISTINCT   A.DIVISION_ID
									, A.OPERATION_GROUP
									, A.ITEM_ID
									, A.FROM_SITE
									, A.TO_SITE
									, A.ATTRIBUTE9
									, B.TRANSPORT_MODE
									, B.INCOTERMS
									, B.BOD_ID
									, A.PROJECT_CODE
					  FROM (SELECT  DISTINCT 
									DIVISION_ID
								   ,ITEM_ID
								   ,FROM_SITE
								   ,OPERATION_GROUP
								   ,TO_SITE
								   ,INCOTERMS
								   ,TRANSPORT_MODE
								   ,ATTRIBUTE9
								   ,PROJECT_CODE
							  FROM SCP_XLS_PSI_GLOBAL_ESS A WITH (NOLOCK)
							 WHERE MEASURE             = 'SHIP_PLAN'
							   AND OPERATION_GROUP     = 'P'
							   AND ITEM_ID IN (SELECT DISTINCT ITEM_ID					-- 2022.05.24 :: 복수 bod 생성오류수정
											  FROM SCM_MST_FINAL_ITEM_V with (nolock)
											 WHERE DIVISION_ID = @p_division_id
											   AND OPERATION_GROUP_ID = 'P'
											   AND DC_YN = 'Y')
							) A
					 LEFT OUTER JOIN SCP_MST_BOD_N_V B WITH (NOLOCK)
					  ON A.DIVISION_ID = B.division_id
					 AND A.FROM_SITE = B.from_site
					 AND A.TO_SITE   = B.to_site
					 AND A.INCOTERMS = B.INCOTERMS
					 AND B.BOD_TYPE        = 'SALES'
					 AND B.TRANSPORT_MODE <> 'AIR'
					 AND B.BOD_VALID_YN = 'Y'
					 AND B.to_yyyymmdd >= @p_plan_start_yyyymmdd
					 AND NOT EXISTS (SELECT 1
										FROM SCP_ANL_SHIPMENT_PLAN_FG WITH (NOLOCK)	-- 출하계획 존재시 제외
										WHERE DIVISION_ID = @p_division_id
										AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
										AND PLAN_TYPE   = @p_plan_type
										AND SEQ         = @p_seq
										AND FROM_SITE   = A.FROM_SITE
										AND ITEM_ID     = A.ITEM_ID
										AND BOD_ID      = B.BOD_ID
										AND MEASURE     = 'SHIP_PLAN') 
					) X
			 LEFT OUTER JOIN SCM_MST_SITE_ITEM_PRIORITY P WITH (NOLOCK)
			 ON P.DIVISION_ID = X.DIVISION_ID
			 AND P.ITEM_ID    = X.ITEM_ID
			 AND P.PLANT_SITE_ID = X.FROM_SITE
			 AND P.VALID_YN     = 'Y'
			 AND P.FROM_YYYYMMDD <= @p_to_yyyymmdd
			INNER JOIN #MEASURE M WITH(NOLOCK)	
             ON M.COLUMN_NAME = 'SHIP_PLAN'
			WHERE X.TRANSPORT_MODE  IS NOT NULL  
			 ;


			-- E20260331-000738 82사업부 MA Plan 수행 시 속도지연
			SET @v_log_message = N'########## INSERT #BOD_OTHER_SHIP_PLAN ##########';
			SET @v_description = @v_program_name + ':' + N' MEASURE SHIP_PLAN ';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
									  ,@p_log_type      =  N'TXN'
									  ,@p_log_count     = 0       
									  ,@p_log_message   = @v_log_message       
									  ,@p_description   = @v_description       
									  ,@p_event_date    = @d_event_date       
									  ,@p_user_id       = @v_batch_user      
									  ;    

			 INSERT INTO #PSI_GLOBAL
			 SELECT *
			   FROM #BOD_OTHER_SHIP_PLAN WITH (NOLOCK)
			   ;
			------------------------------------------------------------------------------------------------------------------------- end


            -------------------------------------------------------------------------------------------------------------------------         
            -- PACK_PROD, CELL_PROD (SCP_ANL_PRODUCTION_PLAN)   
            -------------------------------------------------------------------------------------------------------------------------              

            INSERT INTO #PSI_GLOBAL
               SELECT  
                        A.DIVISION_ID             
                      , A.OPERATION_GROUP         
                      , '' AS CELL_ITEM_ID          
                      , A.ITEM_ID        
                      , '-' AS  TO_SITE	
                      , '-' AS PROJECT_CODE
                      , 0 AS TO_BOH_QTY        
                      , 0 AS FROM_BOH_QTY	      
                      , '-' AS INCOTERMS           
                      , A.SCM_SITE_ID  AS FROM_SITE
                      , '-'        AS TRANSPORT_MODE
                      , A.LINE_ID   AS PROD_LINE                       
                      , M.COLUMN_NAME AS MEASURE
                      , A.YYYYMMDD                
                      , SUM(A.QTY) AS QTY                
                      , M.SORT_ORDER_NO									
			                , M.COLUMN_LABEL_NAME							
			                ,  '-' AS BOD_ID						
                      , 'SCP_ANL_PRODUCTION_PLAN' AS ATTRIBUTE1										
			                , OPERATION_ID AS ATTRIBUTE9	                      					
                      FROM SCP_ANL_PRODUCTION_PLAN A WITH (NOLOCK) 
                       INNER JOIN SCM_SYS_CALENDAR_M  C  WITH(NOLOCK) 
                          ON A.YYYYMMDD           = C.BASIS_YYYYMMDD				
                       INNER JOIN #MEASURE M WITH(NOLOCK)	
                          ON M.COLUMN_NAME          IN ('PACK_PROD','CELL_PROD')
                          AND (CASE  WHEN A.MEASURE ='PROD_PLAN_AMEND' AND A.OPERATION_GROUP = 'P' THEN 'PACK_PROD' 
                                     WHEN A.MEASURE ='PROD_PLAN_AMEND' AND A.OPERATION_GROUP = 'A' THEN 'CELL_PROD'
                                     ELSE '-' END )  = M.COLUMN_NAME
                      WHERE 1 = 1                    
                         AND A.DIVISION_ID           = @p_division_id                    
                         AND A.PLAN_START_YYYYMMDD   = @p_plan_start_yyyymmdd                 
                         AND A.PLAN_TYPE             = @p_plan_type                    
                         AND A.SEQ                   = @p_seq      
--                         AND A.LINE_ID              <> '-'
                     GROUP BY   A.DIVISION_ID             
                      , A.OPERATION_GROUP         
                      , A.ITEM_ID        
                      , A.SCM_SITE_ID  
                      , A.LINE_ID   
                      , M.COLUMN_NAME  
                      , A.YYYYMMDD                
                      , M.SORT_ORDER_NO									
			                , M.COLUMN_LABEL_NAME							
			                , A.OPERATION_ID			


			-- E20260331-000738 82사업부 MA Plan 수행 시 속도지연
			SET @v_log_message = N'########## INSERT #BOD_OTHER_SHIP_PLAN ##########';
			SET @v_description = @v_program_name + ':' + N' MEASURE PACK_PROD, CELL_PROD (SCP_ANL_PRODUCTION_PLAN)    ';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
									  ,@p_log_type      =  N'TXN'
									  ,@p_log_count     = 0       
									  ,@p_log_message   = @v_log_message       
									  ,@p_description   = @v_description       
									  ,@p_event_date    = @d_event_date       
									  ,@p_user_id       = @v_batch_user      
									  ;   


            SELECT * 
            INTO #ANL_SHIPMENT_PLAN_FG
            FROM #PSI_GLOBAL WITH (NOLOCK)
            WHERE ATTRIBUTE1 = 'SCP_ANL_SHIPMENT_PLAN_FG'

            SELECT * 
            INTO #ANL_PRODUCTION_PLAN
            FROM #PSI_GLOBAL WITH (NOLOCK)
            WHERE ATTRIBUTE1 = 'SCP_ANL_PRODUCTION_PLAN'

---- 단위처리시간 추출 --
--print N'position_3 #PSI_GLOBAL temp에 PROD data 추가'
--print REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +     
--      REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))     
--set @v_start_time = SYSDATETIME();
---- 단위처리시간 추출 --


            -------------------------------------------------------------------------------------------------------------------------         
            -- SHIP_PLAN (SEMI)  -- SEMI_SHIP_PLAN
            -------------------------------------------------------------------------------------------------------------------------

              INSERT INTO #PSI_GLOBAL
                SELECT A.DIVISION_ID								
			            , A.OPERATION_GROUP						
			            , '' AS CELL_ITEM_ID							
			            , A.ITEM_ID										
			            , ISNULL(NULLIF(A.TO_SITE, '') , '-') TO_SITE		
                  , '-' AS PROJECT_CODE
			            , 0 AS TO_BOH_QTY										
			            , 0 AS FROM_BOH_QTY									
			            , '-' AS INCOTERMS 										
			            , A.FROM_SITE 										
                  -- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 - SCP_MST_BOD_V --> SCP_MST_BOD_N_V
				  ,ISNULL((SELECT TOP 1 TRANSPORT_MODE FROM SCP_MST_BOD_N_V C where 0 = 0 and C.division_id =A.division_id AND A.BOD_ID = C.BOD_ID AND A.FROM_SITE = C.FROM_SITE	),'-') AS TRANSPORT_MODE
                  , '-'              AS PROD_LINE
			            , M.COLUMN_NAME  AS MEASURE											
			            , A.YYYYMMDD        AS YYYYMMDD				
                  , ISNULL(QTY,0)     AS QTY  -- 기존 INTRANSIT 무시하고 모두 0
			            , M.SORT_ORDER_NO									
			            , M.COLUMN_LABEL_NAME							
			            , A.BOD_ID						
                  , 'SCP_ANL_SHIPMENT_PLAN_SEMI' AS ATTRIBUTE1										
			            , A.ATTRIBUTE9						
	               FROM SCP_ANL_SHIPMENT_PLAN_SEMI A WITH(NOLOCK)	
                 INNER JOIN SCM_SYS_CALENDAR_M  C  WITH(NOLOCK) 
                    ON A.YYYYMMDD           = C.BASIS_YYYYMMDD				
                 INNER JOIN #MEASURE M WITH(NOLOCK)	
                    ON M.COLUMN_NAME          IN ('SEMI_SHIP_PLAN','SEMI_SHIP_REQ')
                    AND (CASE A.MEASURE WHEN  'SHIP_PLAN' THEN 'SEMI_SHIP_PLAN' 
                                        WHEN  'SHIP_REQ'  THEN 'SEMI_SHIP_REQ' 
                                        ELSE A.MEASURE  END)              = M.COLUMN_NAME
                 WHERE A.DIVISION_ID			    =  @p_division_id
		                AND A.PLAN_START_YYYYMMDD	=  @p_plan_start_yyyymmdd
		                AND A.PLAN_TYPE				    =  @p_plan_type
		                AND A.SEQ					        =  @p_seq
		                AND A.YYYYMMDD            >=  @p_plan_start_yyyymmdd
		                AND A.YYYYMMDD            <   @p_to_yyyymmdd        
		                --AND A.YYYYMMDD            <=   @p_to_yyyymmdd      --말일포함(KSK, 20240814, 운영배포보류)  
                    AND A.MEASURE             IN ('SHIP_PLAN','SHIP_REQ')      
--                    AND A.ITEM_ID             IN ('ACEN1052U-A1','APRSAKANG-A1','APRSAKANG-B1' ) 

			
			-- E20260331-000738 82사업부 MA Plan 수행 시 속도지연
			SET @v_log_message = N'########## INSERT #BOD_OTHER_SHIP_PLAN ##########';
			SET @v_description = @v_program_name + ':' + N' MEASURE SHIP_PLAN (SEMI)  -- SEMI_SHIP_PLAN  ';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
									  ,@p_log_type      =  N'TXN'
									  ,@p_log_count     = 0       
									  ,@p_log_message   = @v_log_message       
									  ,@p_description   = @v_description       
									  ,@p_event_date    = @d_event_date       
									  ,@p_user_id       = @v_batch_user      
									  ;   

			--SELECT '#PSI_GLOBAL' TN , * FROM #PSI_GLOBAL--TEST



	        IF OBJECT_ID('tempdb..#ANL_SHIPMENT_PLAN_SEMI') IS NOT NULL
				DROP TABLE #ANL_SHIPMENT_PLAN_SEMI
				;

                   
            SELECT * 
            INTO #ANL_SHIPMENT_PLAN_SEMI
            FROM #PSI_GLOBAL WITH (NOLOCK)
            WHERE ATTRIBUTE1 = 'SCP_ANL_SHIPMENT_PLAN_SEMI'

---- 단위처리시간 추출 --
--print N'position_4 #PSI_GLOBAL temp에 SEMI ship plan data 추가'
--print REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +     
--      REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))     
--set @v_start_time = SYSDATETIME();
---- 단위처리시간 추출 --

            -------------------------------------------------------------------------------------------------------------------------         
            -- CELL_CHAR_PLAN (SCP_PLN_PRODUCTION_PLAN)   ACTIVATE_COMPLETED --> CELL_CHAR_PLAN
            -------------------------------------------------------------------------------------------------------------------------  

            INSERT INTO #PSI_GLOBAL
            SELECT X.DIVISION_ID                             
                      , X.OPERATION_GROUP         
                      , X.CELL_ITEM_ID          
                      , X.ITEM_ID        
                      , X.TO_SITE	
                      , X.PROJECT_CODE
                      , X.TO_BOH_QTY        
                      , X.FROM_BOH_QTY	      
                      , X.INCOTERMS           
                      , X.FROM_SITE                         
                      , X.TRANSPORT_MODE
                      , MAX(X.PROD_LINE)
                      , X.MEASURE                    
                      , X.YYYYMMDD                                
                      , MAX(X.QTY) AS QTY
                      , X.SORT_ORDER_NO									
			                , X.COLUMN_LABEL_NAME							
			                , X.BOD_ID						
                      , MAX(X.ATTRIBUTE1) AS ATTRIBUTE1
			                , MAX(X.ATTRIBUTE9)	 AS ATTRIBUTE9
                  FROM 
                      (

                        SELECT    A.DIVISION_ID                             
                                , A.OPERATION_GROUP         
                                , '' AS CELL_ITEM_ID          
                                , A.ITEM_ID        
                                , '-' AS  TO_SITE	
                                , '-' AS PROJECT_CODE
                                , 0 AS TO_BOH_QTY        
                                , 0 AS FROM_BOH_QTY	      
                                , '-' AS INCOTERMS           
                                , A.SITE_ID                AS FROM_SITE                         
                                , '-'        AS TRANSPORT_MODE
                                , '-'                       AS PROD_LINE         
                                , 'CELL_CHAR_PLAN'     AS MEASURE                    -- ACTIVATE_COMPLETED
                                , CONVERT(VARCHAR(8),A.END_TIME,112)   AS YYYYMMDD                                
                                , SUM(ISNULL(A.COMPLETE_QTY,0))  AS QTY
                                , M.SORT_ORDER_NO									
			                          , M.COLUMN_LABEL_NAME							
			                          ,  '-' AS BOD_ID						
                                , 'SCP_PLN_PRODUCTION_PLAN' AS ATTRIBUTE1										
			                          , A.OPERATION_ID AS ATTRIBUTE9										
                          FROM SCP_PLN_PRODUCTION_PLAN A WITH(NOLOCK)             
                           INNER JOIN #MEASURE M WITH(NOLOCK)	
                         ON M.COLUMN_NAME          IN ('CELL_CHAR_PLAN')
                         WHERE 1 = 1                    
                           AND A.DIVISION_ID           = @p_division_id                    
                           AND A.PLAN_START_YYYYMMDD   = @p_plan_start_yyyymmdd                 
                           AND A.PLAN_TYPE             = @p_plan_type                    
                           AND A.SEQ                   = @p_seq                    
                           AND A.OPERATION_ID          = 'F6000'                    
                        GROUP BY A.DIVISION_ID   
                                , A.OPERATION_GROUP         
                                , A.ITEM_ID        
                                , A.SITE_ID                
                                , CONVERT(VARCHAR(8),A.END_TIME,112)                                  
                                , M.SORT_ORDER_NO									
			                          , M.COLUMN_LABEL_NAME							
			                          , OPERATION_ID 

                          UNION 
                                SELECT DISTINCT A.DIVISION_ID                             
                                      , A.OPERATION_GROUP         
                                      , '' AS CELL_ITEM_ID          
                                      , A.ITEM_ID        
                                      , '-' AS  TO_SITE	
                                      , '-' AS PROJECT_CODE
                                      , 0 AS TO_BOH_QTY        
                                      , 0 AS FROM_BOH_QTY	      
                                      , '-' AS INCOTERMS           
                                      , A.FROM_SITE                         
                                      , '-'        AS TRANSPORT_MODE
                                      , '-'                       AS PROD_LINE         
                                      , 'CELL_CHAR_PLAN'     AS MEASURE          -- ACTIVATE_COMPLETED
                                      , YYYYMMDD                                
                                      , 0 AS QTY
                                      , '440' AS SORT_ORDER_NO									
			                                , 'Char. Plan' AS COLUMN_LABEL_NAME							
			                                ,  '-' AS BOD_ID						
                                      , '' AS ATTRIBUTE1										
			                                , '' AS ATTRIBUTE9							
                                 FROM #ANL_PRODUCTION_PLAN  A WITH (NOLOCK)
                                WHERE 0 = 0
						UNION --KSK(250418)
                        SELECT    A.DIVISION_ID                             
                                , A.OPERATION_GROUP         
                                , '' AS CELL_ITEM_ID          
                                , CPA.ITEM_ID_PROD    AS CELL_ITEM_ID --CELL    
                                , '-' AS  TO_SITE	
                                , '-' AS PROJECT_CODE
                                , 0 AS TO_BOH_QTY        
                                , 0 AS FROM_BOH_QTY	      
                                , '-' AS INCOTERMS           
                                , A.SITE_ID                AS FROM_SITE                         
                                , '-'        AS TRANSPORT_MODE
                                , '-'                       AS PROD_LINE         
                                , 'CELL_CHAR_PLAN'     AS MEASURE                    -- ACTIVATE_COMPLETED
                                , CONVERT(VARCHAR(8),A.END_TIME,112)   AS YYYYMMDD                                
                                , SUM(ISNULL(A.COMPLETE_QTY,0))  AS QTY
                                , M.SORT_ORDER_NO									
			                          , M.COLUMN_LABEL_NAME							
			                          ,  '-' AS BOD_ID						
                                , 'SCP_PLN_PRODUCTION_PLAN' AS ATTRIBUTE1										
			                          , A.OPERATION_ID AS ATTRIBUTE9										
                          FROM SCP_PLN_PRODUCTION_PLAN A WITH(NOLOCK)             
                           INNER JOIN #MEASURE M WITH(NOLOCK)	
                               ON M.COLUMN_NAME          IN ('CELL_CHAR_PLAN')
							INNER JOIN SCM_MST_SITE MS WITH(NOLOCK)
								ON  MS.DIVISION_ID = A.DIVISION_ID
								AND MS.SCM_SITE_ID  =  A.SITE_ID
							INNER JOIN [SCP_MST_CELL_PROD_ASSY_MAP] CPA WITH(NOLOCK)
								ON   CPA.DIVISION_ID = MS.DIVISION_ID
								AND  CPA.PLANT_ID = MS.PLANT_ID
								AND  CPA.ITEM_ID_ASSY = A.ITEM_ID
                         WHERE 1 = 1                    
                           AND A.DIVISION_ID           = @p_division_id                    
                           AND A.PLAN_START_YYYYMMDD   = @p_plan_start_yyyymmdd                 
                           AND A.PLAN_TYPE             = @p_plan_type                    
                           AND A.SEQ                   = @p_seq                    
                           AND A.OPERATION_ID          = 'F6000'       
                        GROUP BY A.DIVISION_ID   
                                , A.OPERATION_GROUP         
                                , CPA.ITEM_ID_PROD        
                                , A.SITE_ID                
                                , CONVERT(VARCHAR(8),A.END_TIME,112)                                  
                                , M.SORT_ORDER_NO									
			                          , M.COLUMN_LABEL_NAME							
			                          , OPERATION_ID 

                          UNION  --KSK(250418)
                                SELECT DISTINCT A.DIVISION_ID                             
                                      , A.OPERATION_GROUP         
                                      , '' AS CELL_ITEM_ID          
                                      , CPA.ITEM_ID_PROD AS CELL_ITEM_ID --CELL       
                                      , '-' AS  TO_SITE	
                                      , '-' AS PROJECT_CODE
                                      , 0 AS TO_BOH_QTY        
                                      , 0 AS FROM_BOH_QTY	      
                                      , '-' AS INCOTERMS           
                                      , A.FROM_SITE                         
                                      , '-'        AS TRANSPORT_MODE
                                      , '-'                       AS PROD_LINE         
                                      , 'CELL_CHAR_PLAN'     AS MEASURE          -- ACTIVATE_COMPLETED
                                      , YYYYMMDD                                
                                      , 0 AS QTY
                                      , '440' AS SORT_ORDER_NO									
			                                , 'Char. Plan' AS COLUMN_LABEL_NAME							
			                                ,  '-' AS BOD_ID						
                                      , '' AS ATTRIBUTE1										
			                                , '' AS ATTRIBUTE9							
                                 FROM #ANL_PRODUCTION_PLAN  A WITH (NOLOCK)
								INNER JOIN SCM_MST_SITE MS WITH(NOLOCK)
									ON  MS.DIVISION_ID = A.DIVISION_ID
									AND MS.SCM_SITE_ID  =  A.FROM_SITE
								INNER JOIN [SCP_MST_CELL_PROD_ASSY_MAP] CPA WITH(NOLOCK)
									ON   CPA.DIVISION_ID = MS.DIVISION_ID
									AND  CPA.PLANT_ID = MS.PLANT_ID
									AND  CPA.ITEM_ID_ASSY = A.ITEM_ID
                                WHERE 0 = 0	
								-- KSW : 생산계획이 존재하지 않을경우 CELL 재고관련 Measure 가 누락되는 Case 보완 - Start
							UNION 
                                SELECT DISTINCT A.DIVISION_ID                             
                                      , A.OPERATION_GROUP         
                                      , '' AS CELL_ITEM_ID          
                                      , A.ITEM_ID        
                                      , '-' AS  TO_SITE	
                                      , '-' AS PROJECT_CODE
                                      , 0 AS TO_BOH_QTY        
                                      , 0 AS FROM_BOH_QTY	      
                                      , '-' AS INCOTERMS           
                                      , A.FROM_SITE                         
                                      , '-'        AS TRANSPORT_MODE
                                      , '-'                       AS PROD_LINE         
                                      , 'CELL_CHAR_PLAN'     AS MEASURE          -- ACTIVATE_COMPLETED
                                      , YYYYMMDD                                
                                      , 0 AS QTY
                                      , '440' AS SORT_ORDER_NO									
			                                , 'Char. Plan' AS COLUMN_LABEL_NAME							
			                                ,  '-' AS BOD_ID						
                                      , '' AS ATTRIBUTE1										
			                                , '' AS ATTRIBUTE9							
                                 FROM #ANL_SHIPMENT_PLAN_SEMI A WITH (NOLOCK)
								 WHERE 0 = 0
								 -- KSW : 생산계획이 존재하지 않을경우 CELL 재고관련 Measure 가 누락되는 Case 보완 - End
                      ) X
					WHERE  X.ITEM_ID IS NOT NULL
                    GROUP BY 
                               DIVISION_ID        
                             , OPERATION_GROUP                
                             , CELL_ITEM_ID      
                             , ITEM_ID        
                             , TO_SITE	
                             , PROJECT_CODE
                             , TO_BOH_QTY        
                             , FROM_BOH_QTY	    
                             , INCOTERMS         
                             , FROM_SITE         
                             , TRANSPORT_MODE
--                        , PROD_LINE         
                             , MEASURE           
                             , YYYYMMDD          
                             , SORT_ORDER_NO			
                             , COLUMN_LABEL_NAME	
                             , BOD_ID						
                    --,ATTRIBUTE1			     
                    --,ATTRIBUTE9


			IF @P_IS_DEBUG = 1 SELECT '697_#PSI_GLOBAL' AS "#PSI_GLOBAL",  * FROM #PSI_GLOBAL WHERE QTY >0
			IF @P_IS_DEBUG = 1 RETURN ;

			-- E20260331-000738 82사업부 MA Plan 수행 시 속도지연
			SET @v_log_message = N'########## INSERT #BOD_OTHER_SHIP_PLAN ##########';
			SET @v_description = @v_program_name + ':' + N' CELL_CHAR_PLAN (SCP_PLN_PRODUCTION_PLAN)   ACTIVATE_COMPLETED --> CELL_CHAR_PLAN  ';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
									  ,@p_log_type      =  N'TXN'
									  ,@p_log_count     = 0       
									  ,@p_log_message   = @v_log_message       
									  ,@p_description   = @v_description       
									  ,@p_event_date    = @d_event_date       
									  ,@p_user_id       = @v_batch_user      
									  ;  



            SELECT * 
            INTO #SCP_PLN_PRODUCTION_PLAN
            FROM #PSI_GLOBAL WITH (NOLOCK)
            WHERE ATTRIBUTE1 = 'SCP_PLN_PRODUCTION_PLAN'
		
---- 단위처리시간 추출 --
--print N'position_5 #PSI_GLOBAL temp에 CELL_CHAR_PLAN data 추가'
--print REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +     
--      REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))     
--set @v_start_time = SYSDATETIME();
---- 단위처리시간 추출 --


            -------------------------------------------------------------------------------------------------------------------------         
            -- 대상 ITEM_ID 추출
            -------------------------------------------------------------------------------------------------------------------------   

              SELECT DISTINCT
                     DIVISION_ID		     
						,OPERATION_GROUP	   
						,CELL_ITEM_ID		     
						,ITEM_ID			       
						,TO_SITE			       
						,PROJECT_CODE        
						,MAX(TO_BOH_QTY) AS TO_BOH_QTY
						,MAX(FROM_BOH_QTY) AS FROM_BOH_QTY
						,INCOTERMS			     
						,FROM_SITE			     
						,TRANSPORT_MODE      
						,PROD_LINE           
						,MEASURE			       
						,@p_plan_start_yyyymmdd AS YYYYMMDD			       
						,MAX(QTY) AS QTY				         
						,SORT_ORDER_NO		   
						,COLUMN_LABEL_NAME	 
						,BOD_ID				       
						,MAX(ATTRIBUTE1) AS ATTRIBUTE1			     
						,MAX(ATTRIBUTE9) AS ATTRIBUTE9			     		     
                  INTO #ITEM_ID
				  FROM #PSI_GLOBAL WITH (NOLOCK) 				
				  WHERE 0 = 0
				  GROUP BY
						 DIVISION_ID		     
						,OPERATION_GROUP	   
						,CELL_ITEM_ID		     
						,ITEM_ID			       
						,TO_SITE			       
						,PROJECT_CODE        
						,INCOTERMS			     
						,FROM_SITE			     
						,TRANSPORT_MODE      
						,PROD_LINE           
						,MEASURE			       
						,SORT_ORDER_NO		   
						,COLUMN_LABEL_NAME	 
						,BOD_ID		;		       

			-- E20260331-000738 82사업부 MA Plan 수행 시 속도지연
			SET @v_log_message = N'########## INTO #ITEM_ID ##########';
			SET @v_description = @v_program_name + ':' + N' INTO #ITEM_ID  ';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
									  ,@p_log_type      =  N'TXN'
									  ,@p_log_count     = 0       
									  ,@p_log_message   = @v_log_message       
									  ,@p_description   = @v_description       
									  ,@p_event_date    = @d_event_date       
									  ,@p_user_id       = @v_batch_user      
									  ;  

                    --,ATTRIBUTE1			     
                    --,ATTRIBUTE9	
								
			IF @P_IS_DEBUG = 1 BEGIN SELECT '800_ITEM_ID' AS  "#ITEM_ID" , * FROM "#ITEM_ID"  ;END


              
               IF OBJECT_ID('tempdb..#PSI_GLOBAL_ESS') IS NOT NULL      
	              DROP TABLE #PSI_GLOBAL_ESS;        

	              CREATE TABLE #PSI_GLOBAL_ESS (
		               DIVISION_ID		      NVARCHAR(060)	
		              ,OPERATION_GROUP	    NVARCHAR(060)
		              ,CELL_ITEM_ID		      NVARCHAR(100)	
		              ,ITEM_ID			        NVARCHAR(100)
		              ,TO_SITE			        NVARCHAR(060)
                  ,PROJECT_CODE         NVARCHAR(050)     -- FG 때문에 추가
		              ,TO_BOH_QTY			      numeric(20,10)    --BIGINT
		              ,FROM_BOH_QTY		      numeric(20,10)    -- BIGINT
		              ,INCOTERMS			      NVARCHAR(20)
		              ,FROM_SITE			      NVARCHAR(60)
                  ,TRANSPORT_MODE       NVARCHAR(50)
                  ,PROD_LINE            NVARCHAR(50)
		              ,MEASURE			        NVARCHAR(100)
		              ,YYYYMMDD			        NVARCHAR(010)
		              ,QTY				          NUMERIC(20,10)
		              ,SORT_ORDER_NO		    INT
		              ,COLUMN_LABEL_NAME	  NVARCHAR(300)
		              ,BOD_ID				        NVARCHAR(300)
                  ,ATTRIBUTE1			      NVARCHAR(150)
		              ,ATTRIBUTE9			      NVARCHAR(150)   -- OPERATION_ID
	              );

---- 단위처리시간 추출 --
--print N'position_6 #ITEM_ID temp 및 #PSI_GLOBAL_ESS temp create'
--print REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +     
--      REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))     
--set @v_start_time = SYSDATETIME();
---- 단위처리시간 추출 --

            -------------------------------------------------------------------------------------------------------------------------         
            -- MEASURE 추가 : ITEM_ID별 (MKT_FCST_PACK_TOTAL)
            -------------------------------------------------------------------------------------------------------------------------
            INSERT #PSI_GLOBAL_ESS
              SELECT  DISTINCT  X.DIVISION_ID								
			                        , X.OPERATION_GROUP						
			                        , X.CELL_ITEM_ID							
			                        , X.ITEM_ID										
			                        , '-' AS TO_SITE
                              , '-' AS PROJECT_CODE
			                        , '0' AS TO_BOH_QTY										
			                        , '0' AS FROM_BOH_QTY									
			                        , '-' AS INCOTERMS 										
			                        , '-' AS FROM_SITE 										
                              , '-' AS TRANSPORT_MODE
                              , '-' AS PROD_LINE
			                        , M.COLUMN_NAME AS MEASURE
						                  , X.YYYYMMDD	
                              , 0    AS QTY
			                        , M.SORT_ORDER_NO								
			                        , M.COLUMN_LABEL_NAME							
			                        , '-' AS BOD_ID						
                              , 'MKT_FCST_PACK_TOTAL' AS ATTRIBUTE1										
			                        , X.ATTRIBUTE9										
              FROM #ITEM_ID X WITH(NOLOCK)     
              CROSS APPLY #MEASURE M WITH (NOLOCK)                                 
              WHERE 1=1          
                AND M.DIV       ='C' 
                AND M.GUBUN       = 'ITEM_ID'
                AND X.MEASURE   = 'MKT_FCST'
                AND X.OPERATION_GROUP ='P'


			-- E20260331-000738 82사업부 MA Plan 수행 시 속도지연
			SET @v_log_message = N'########## INSERT #PSI_GLOBAL_ESS ##########';
			SET @v_description = @v_program_name + ':' + N' MEASURE 추가 : ITEM_ID별 (MKT_FCST_PACK_TOTAL) ';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
									  ,@p_log_type      =  N'TXN'
									  ,@p_log_count     = 0       
									  ,@p_log_message   = @v_log_message       
									  ,@p_description   = @v_description       
									  ,@p_event_date    = @d_event_date       
									  ,@p_user_id       = @v_batch_user      
									  ;  


-- -- 단위처리시간 추출 --
--print N'position_7 #PSI_GLOBAL_ESS temp 에 MKT_FCST_PACK_TOTAL 추가'
--print REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +     
--      REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))     
--set @v_start_time = SYSDATETIME();
---- 단위처리시간 추출 --


             -------------------------------------------------------------------------------------------------------------------------         
            -- MEASURE 추가 : ITEM_ID별 (SHIP_REQ_PACK_TOTAL)
            -------------------------------------------------------------------------------------------------------------------------
            INSERT #PSI_GLOBAL_ESS
              SELECT  DISTINCT  X.DIVISION_ID								
			                        , X.OPERATION_GROUP						
			                        , X.CELL_ITEM_ID							
			                        , X.ITEM_ID										
			                        , '-' AS TO_SITE
                              , '-' AS PROJECT_CODE
			                        , '0' AS TO_BOH_QTY										
			                        , '0' AS FROM_BOH_QTY									
			                        , '-' AS INCOTERMS 										
			                        , '-' AS FROM_SITE 										
                              , '-' AS TRANSPORT_MODE
                              , '-' AS PROD_LINE
			                        , M.COLUMN_NAME AS MEASURE
						                  , X.YYYYMMDD	
                              , 0    AS QTY
			                        , M.SORT_ORDER_NO								
			                        , M.COLUMN_LABEL_NAME							
			                        , '-' AS BOD_ID						
                              , 'SHIP_REQ_PACK_TOTAL' AS ATTRIBUTE1										
			                        , X.ATTRIBUTE9										
              FROM #ITEM_ID X WITH(NOLOCK)     
              CROSS APPLY #MEASURE M WITH (NOLOCK)                                 
              WHERE 1=1          
                AND M.DIV       ='C' 
                AND M.GUBUN       = 'ITEM_ID'
                AND X.MEASURE   = 'SHIP_REQ_PACK_TOTAL'
                AND X.OPERATION_GROUP ='P'

			-- E20260331-000738 82사업부 MA Plan 수행 시 속도지연
			SET @v_log_message = N'########## INSERT #PSI_GLOBAL_ESS ##########';
			SET @v_description = @v_program_name + ':' + N' MEASURE 추가 : ITEM_ID별 (SHIP_REQ_PACK_TOTAL) ';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
									  ,@p_log_type      =  N'TXN'
									  ,@p_log_count     = 0       
									  ,@p_log_message   = @v_log_message       
									  ,@p_description   = @v_description       
									  ,@p_event_date    = @d_event_date       
									  ,@p_user_id       = @v_batch_user      
									  ;  


-- -- 단위처리시간 추출 --
--print N'position_8 #PSI_GLOBAL_ESS temp 에 SHIP_REQ_PACK_TOTAL 추가'
--print REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +     
--      REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))     
--set @v_start_time = SYSDATETIME();
---- 단위처리시간 추출 --


            -------------------------------------------------------------------------------------------------------------------------         
            -- MEASURE 추가 : PACK TO SITE별 (ALLOCATION, GAP_FCST_RTF, WH_IN_BALANCE, TO_SITE_BOH, TO_SITE_EOH, WHIN_TOTAL)
            -------------------------------------------------------------------------------------------------------------------------
            INSERT #PSI_GLOBAL_ESS
              SELECT  DISTINCT  X.DIVISION_ID								
			                        , X.OPERATION_GROUP						
			                        , X.CELL_ITEM_ID							
			                        , X.ITEM_ID										
			                        , X.TO_SITE
                            , '-' AS PROJECT_CODE
			                        , X.TO_BOH_QTY										
			                        , X.FROM_BOH_QTY									
			                        , X.INCOTERMS 										
			                        , X.FROM_SITE 										
                              , X.TRANSPORT_MODE
                              , X.PROD_LINE
			                        , M.COLUMN_NAME AS MEASURE
						                  , X.YYYYMMDD	
                              , 0    AS QTY
			                        , M.SORT_ORDER_NO								
			                        , M.COLUMN_LABEL_NAME							
			                        , X.BOD_ID						
                              , X.ATTRIBUTE1										
			                        , X.ATTRIBUTE9										
              FROM #ITEM_ID X WITH(NOLOCK)     
              CROSS APPLY #MEASURE M WITH (NOLOCK)                                 
              WHERE 1=1          
                AND M.DIV       ='C' 
                AND M.GUBUN       = 'TO'
                AND X.MEASURE   = 'MKT_FCST'

			-- E20260331-000738 82사업부 MA Plan 수행 시 속도지연
			SET @v_log_message = N'########## INSERT #PSI_GLOBAL_ESS ##########';
			SET @v_description = @v_program_name + ':' + N' MEASURE 추가 : PACK TO SITE별 (ALLOCATION, GAP_FCST_RTF, WH_IN_BALANCE, TO_SITE_BOH, TO_SITE_EOH, WHIN_TOTAL) ';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
									  ,@p_log_type      =  N'TXN'
									  ,@p_log_count     = 0       
									  ,@p_log_message   = @v_log_message       
									  ,@p_description   = @v_description       
									  ,@p_event_date    = @d_event_date       
									  ,@p_user_id       = @v_batch_user      
									  ;  


-- -- 단위처리시간 추출 --
--print N'position_9 #PSI_GLOBAL_ESS temp 에 ALLOCATION, GAP_FCST_RTF, WH_IN_BALANCE, TO_SITE_BOH, TO_SITE_EOH, WHIN_TOTAL 추가'
--print REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +     
--      REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))     
--set @v_start_time = SYSDATETIME();
---- 단위처리시간 추출 --

                 

            -------------------------------------------------------------------------------------------------------------------------         
            -- MEASURE 추가 : PACK FROM SITE별 (WHIN,INTRANSIT,INTRANSIT_ETA,SHIP_PLAN_ETD,SHIP_PLAN_PLANT)
            -------------------------------------------------------------------------------------------------------------------------
            INSERT #PSI_GLOBAL_ESS
              SELECT  DISTINCT  X.DIVISION_ID								
			                        , X.OPERATION_GROUP						
			                        , X.CELL_ITEM_ID							
			                        , X.ITEM_ID										
                              ,(CASE WHEN M.COLUMN_NAME   IN ('PACK_SHIP_PLAN_TOTAL','CELL_SHIP_PLAN_TOTAL')  THEN '-'                                      
                                      ELSE X.TO_SITE END) AS TO_SITE
                              , (CASE WHEN M.COLUMN_NAME   = 'SHIP_PLAN'    THEN X.PROJECT_CODE 
                                      WHEN M.COLUMN_NAME   = 'SHIP_REQ'     THEN X.PROJECT_CODE 
                                      WHEN M.COLUMN_NAME   = 'PLAN_REQ_GAP' THEN X.PROJECT_CODE 
                                      ELSE '-' END) AS PROJECT_CODE
			                        , X.TO_BOH_QTY										
			                        , X.FROM_BOH_QTY									
                              ,(CASE WHEN M.COLUMN_NAME   IN ('PACK_SHIP_PLAN_TOTAL','CELL_SHIP_PLAN_TOTAL')  THEN '-'                                      
                                      ELSE X.INCOTERMS END) AS INCOTERMS
			                        , X.FROM_SITE 										
                              , (CASE WHEN M.COLUMN_NAME   = 'SHIP_PLAN'  THEN X.TRANSPORT_MODE 
                                      WHEN M.COLUMN_NAME   = 'SHIP_REQ'   THEN X.TRANSPORT_MODE 
                                      --WHEN M.COLUMN_NAME   = 'PLAN_REQ_GAP' THEN X.PROJECT_CODE 
                                      ELSE '-' END) AS TRANSPORT_MODE
                              , X.PROD_LINE
			                        , M.COLUMN_NAME AS MEASURE
						                  , X.YYYYMMDD	
                              , 0    AS QTY
			                        , M.SORT_ORDER_NO								
			                        , M.COLUMN_LABEL_NAME							
			                        , (CASE WHEN M.COLUMN_NAME = 'SHIP_PLAN'  THEN X.BOD_ID  
                                      WHEN M.COLUMN_NAME = 'SHIP_REQ'   THEN X.BOD_ID  
                                      ELSE '-' END) AS BOD_ID 
                              , X.ATTRIBUTE1										
			                        , X.ATTRIBUTE9										
              FROM #ITEM_ID X WITH(NOLOCK)     
              CROSS APPLY #MEASURE M WITH (NOLOCK)                                 
              WHERE 1=1          
                AND M.DIV       ='C' 
                AND M.GUBUN     = 'FROM'
                AND X.MEASURE   = 'SHIP_PLAN'

	IF @P_IS_DEBUG = 1  SELECT '961' AS  #PSI_GLOBAL_ESS , * FROM #PSI_GLOBAL_ESS WHERE YYYYMMDD = @P_PLAN_START_YYYYMMDD 

			-- E20260331-000738 82사업부 MA Plan 수행 시 속도지연
			SET @v_log_message = N'########## INSERT #PSI_GLOBAL_ESS ##########';
			SET @v_description = @v_program_name + ':' + N' MEASURE 추가 : PACK FROM SITE별 (WHIN,INTRANSIT,INTRANSIT_ETA,SHIP_PLAN_ETD,SHIP_PLAN_PLANT) ';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
									  ,@p_log_type      =  N'TXN'
									  ,@p_log_count     = 0       
									  ,@p_log_message   = @v_log_message       
									  ,@p_description   = @v_description       
									  ,@p_event_date    = @d_event_date       
									  ,@p_user_id       = @v_batch_user      
									  ;  



-- -- 단위처리시간 추출 --
--print N'position_10 #PSI_GLOBAL_ESS temp 에 WHIN,INTRANSIT,INTRANSIT_ETA,SHIP_PLAN_ETD,SHIP_PLAN_PLANT 추가'
--print REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +     
--      REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))     
--set @v_start_time = SYSDATETIME();
---- 단위처리시간 추출 --


            -------------------------------------------------------------------------------------------------------------------------         
            -- MEASURE 추가 : PACK FROM SITE별 (PACK_BOH,PACK_EOH,PACK_PROD,PACK_PROD_LOAD,PACK_CELL_BOH,PACK_CELL_EOH) 
            -------------------------------------------------------------------------------------------------------------------------
            INSERT #PSI_GLOBAL_ESS
              SELECT  DISTINCT  X.DIVISION_ID								
			                        , X.OPERATION_GROUP						
			                        , X.CELL_ITEM_ID							
			                        , X.ITEM_ID										
			                        , X.TO_SITE
                              , X.PROJECT_CODE
			                        , X.TO_BOH_QTY										
			                        , X.FROM_BOH_QTY									
			                        , X.INCOTERMS 										
			                        , X.FROM_SITE 										
                              , (CASE WHEN M.COLUMN_NAME  IN ( 'PACK_BOH','CELL_BOH','PACK_EOH','CELL_EOH')  THEN X.TRANSPORT_MODE ELSE '-' END) AS TRANSPORT_MODE
                              , (CASE WHEN M.COLUMN_NAME  IN ( 'PACK_BOH','CELL_BOH','PACK_EOH','CELL_EOH')  THEN '-' ELSE X.PROD_LINE END) AS PROD_LINE
			                        , M.COLUMN_NAME AS MEASURE
						                  , X.YYYYMMDD	
                              , 0    AS QTY
			                        , M.SORT_ORDER_NO								
			                        , M.COLUMN_LABEL_NAME							
			                        , (CASE WHEN M.COLUMN_NAME IN ( 'PACK_BOH','CELL_BOH','PACK_EOH','CELL_EOH') THEN X.BOD_ID  ELSE '-' END) AS BOD_ID 
                              , X.ATTRIBUTE1										
			                        , X.ATTRIBUTE9										
              FROM #ITEM_ID X WITH(NOLOCK)     
              CROSS APPLY #MEASURE M WITH (NOLOCK)                                 
              WHERE 1=1          
                AND M.DIV       ='P' 
                AND M.GUBUN     = 'FROM'
                AND X.MEASURE   = 'PACK_PROD'
                AND X.OPERATION_GROUP   = 'P'


			-- E20260331-000738 82사업부 MA Plan 수행 시 속도지연
			SET @v_log_message = N'########## INSERT #PSI_GLOBAL_ESS ##########';
			SET @v_description = @v_program_name + ':' + N' MEASURE 추가 : PACK FROM SITE별 (PACK_BOH,PACK_EOH,PACK_PROD,PACK_PROD_LOAD,PACK_CELL_BOH,PACK_CELL_EOH)  ';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
									  ,@p_log_type      =  N'TXN'
									  ,@p_log_count     = 0       
									  ,@p_log_message   = @v_log_message       
									  ,@p_description   = @v_description       
									  ,@p_event_date    = @d_event_date       
									  ,@p_user_id       = @v_batch_user      
									  ;  
            
             --IF OBJECT_ID('tempdb##MEASURE')        IS NOT NULL       
		           -- DROP TABLE ##MEASURE
             --   SELECT * INTO ##MEASURE  FROM #MEASURE WITH (NOLOCK)

             --IF OBJECT_ID('tempdb##ITEM_ID')        IS NOT NULL       
		           -- DROP TABLE ##ITEM_ID
             --   SELECT * INTO ##ITEM_ID  FROM #ITEM_ID WITH (NOLOCK)

             -- RETURN;

-- -- 단위처리시간 추출 --
--print N'position_11 #PSI_GLOBAL_ESS temp 에 PACK_BOH,PACK_EOH,PACK_PROD,PACK_PROD_LOAD,PACK_CELL_BOH,PACK_CELL_EOH 추가'
--print REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +     
--      REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))     
--set @v_start_time = SYSDATETIME();
---- 단위처리시간 추출 --

			 ------------------------------------------------------------------------------------------------------------------------- start
			 -- 생산계획이 없거나 출하계획도 없는 경우 Pack 재고정보(PACK_BOH, PACK_EOH) Measure 추가 :: KSW / 2020.08.20 
			 -- 전 처리에서 생성된 ITEM_ID 에 대한 PACK BOH/EOH 이외에 SCP_XLS_BOH 에 존재하는 재고정보가 표시되도록 보완
			 -------------------------------------------------------------------------------------------------------------------------
            INSERT #PSI_GLOBAL_ESS
              SELECT  DISTINCT  X.DIVISION_ID								
			                  , X.OPERATION_GROUP						
			                  , X.CELL_ITEM_ID							
			                  , X.ITEM_ID										
			                  , '-'                       AS TO_SITE
                              , '-'                       AS PROJECT_CODE
			                  , 0	                      AS TO_BOH_QTY									
			                  , 0	                      AS FROM_BOH_QTY				
			                  , '-'                       AS INCOTERMS										
			                  , X.FROM_SITE 										
                              , '-'                       AS TRANSPORT_MODE
                              , '-'                       AS PROD_LINE
			                  , M.COLUMN_NAME             AS MEASURE
						      , X.YYYYMMDD	
                              , (CASE WHEN M.COLUMN_NAME = 'PACK_BOH' THEN X.QTY ELSE 0 END) AS QTY  --0                         AS QTY
			                  , M.SORT_ORDER_NO								
			                  , M.COLUMN_LABEL_NAME							
			                  , '-'                       AS BOD_ID 
                              , 'SCP_ANL_PRODUCTION_PLAN' AS ATTRIBUTE1										
			                  --, X.FROM_SITE               AS ATTRIBUTE9		
			                  , (CASE WHEN PATINDEX('%-%', X.FROM_SITE) > 0 THEN LEFT(X.FROM_SITE, PATINDEX('%-%', X.FROM_SITE) - 1) ELSE X.FROM_SITE END) AS ATTRIBUTE9										
              FROM (
					SELECT A.DIVISION_ID
					      ,B.OPERATION_GROUP
					      ,B.CELL_LIST		AS CELL_ITEM_ID
						  ,A.SCM_SITE_ID	AS FROM_SITE
						  ,A.ITEM_ID
						  ,A.QTY
						  ,A.PLAN_START_YYYYMMDD AS YYYYMMDD
						  ,'-'              AS TRANSPORT_MODE
					  FROM (
							SELECT DIVISION_ID
								,PLAN_START_YYYYMMDD
								,PLAN_TYPE
								,SEQ
								,SCM_SITE_ID
								,INCOTERMS
								,ITEM_ID
								,SUM(QTY)        AS QTY 
							  FROM SCP_XLS_BOH WITH (NOLOCK)
							 WHERE DIVISION_ID               = @p_division_id
							   AND PLAN_START_YYYYMMDD       = @p_plan_start_yyyymmdd
							   AND PLAN_TYPE                 = @p_plan_type
							   AND SEQ                       = @p_seq
							   AND ISNULL(ORIGIN_ITEM_ID,'') = ''
							   AND NOT ITEM_ID + '|' + SCM_SITE_ID IN (SELECT DISTINCT ITEM_ID + '|' + FROM_SITE
																		 FROM #PSI_GLOBAL_ESS WITH (NOLOCK)
																		WHERE MEASURE = 'PACK_BOH')
							   AND NOT ITEM_ID IN (SELECT DISTINCT CELL_ITEM_ID
													 FROM #PSI_GLOBAL_ESS WITH (NOLOCK)
													WHERE MEASURE = 'PACK_BOH')
							   AND INCOTERMS = ''
							GROUP BY DIVISION_ID
									,PLAN_START_YYYYMMDD
									,PLAN_TYPE
									,SEQ
									,SCM_SITE_ID
									,INCOTERMS
									,ITEM_ID
						   ) A, DBO.SCP_MST_FINAL_ITEM_V B WITH (NOLOCK)
					 WHERE B.ITEM_ID = A.ITEM_ID
					   AND B.OPERATION_GROUP = 'P'
                   ) X
              CROSS APPLY #MEASURE M WITH (NOLOCK)                            
              WHERE 1=1          
                AND M.DIV       ='P' 
                AND M.GUBUN     = 'FROM'
				AND M.COLUMN_NAME IN ('PACK_BOH', 'PACK_EOH')
				 ;


			-- E20260331-000738 82사업부 MA Plan 수행 시 속도지연
			SET @v_log_message = N'########## INSERT #PSI_GLOBAL_ESS ##########';
			SET @v_description = @v_program_name + ':' + N' 생산계획이 없거나 출하계획도 없는 경우 Pack 재고정보(PACK_BOH, PACK_EOH) Measure 추가  ';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
									  ,@p_log_type      =  N'TXN'
									  ,@p_log_count     = 0       
									  ,@p_log_message   = @v_log_message       
									  ,@p_description   = @v_description       
									  ,@p_event_date    = @d_event_date       
									  ,@p_user_id       = @v_batch_user      
									  ;  


			 -------------------------------------------------------------------------------------------------------------------------
			 -- 생산계획이 없거나 출하계획도 없는 경우 Pack 재고정보(PACK_BOH, PACK_EOH) Measure 추가 :: KSW / 2020.08.20
			 ------------------------------------------------------------------------------------------------------------------------- end

-- -- 단위처리시간 추출 --
--print N'position_12 #PSI_GLOBAL_ESS temp 에 PACK_BOH, PACK_EOH 재고정보 추가'
--print REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +     
--      REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))     
--set @v_start_time = SYSDATETIME();
---- 단위처리시간 추출 --


            -------------------------------------------------------------------------------------------------------------------------         
            -- MEASURE 추가 : CELL TO   SITE별 (SEMI_WHIN_TOTAL) 
            -- MEASURE 추가 : CELL FROM SITE별 (SEMI_WHIN,SEMI_INTRANSIT,SEMI_INTRANSIT_ETA,SEMI_SHIP_PLAN_ETA,SEMI_SHIP_PLAN) 
            -------------------------------------------------------------------------------------------------------------------------
            INSERT #PSI_GLOBAL_ESS
              SELECT  DISTINCT  X.DIVISION_ID								
			                        , X.OPERATION_GROUP						
			                        , X.CELL_ITEM_ID							
			                        , X.ITEM_ID										
			                        , X.TO_SITE
                              , X.PROJECT_CODE
			                        , X.TO_BOH_QTY										
			                        , X.FROM_BOH_QTY									
			                        , X.INCOTERMS 										
			                        , X.FROM_SITE
                              , (CASE WHEN M.COLUMN_NAME   = 'SEMI_SHIP_PLAN' THEN X.TRANSPORT_MODE 
                                      WHEN M.COLUMN_NAME   = 'SEMI_SHIP_REQ'  THEN X.TRANSPORT_MODE 
                                      ELSE '-' END) AS TRANSPORT_MODE
                              , X.PROD_LINE
			                        , M.COLUMN_NAME AS MEASURE
						                  , X.YYYYMMDD	
                              , 0    AS QTY
			                        , M.SORT_ORDER_NO								
			                        , M.COLUMN_LABEL_NAME							
			                        , (CASE WHEN M.COLUMN_NAME = 'SEMI_SHIP_PLAN' THEN X.BOD_ID  
                                      WHEN M.COLUMN_NAME = 'SEMI_SHIP_REQ'  THEN X.BOD_ID  
                                      ELSE '-' END) AS BOD_ID 
                              , X.ATTRIBUTE1
                              , X.ATTRIBUTE9										
              FROM #ITEM_ID X WITH(NOLOCK)     
              CROSS APPLY #MEASURE M WITH (NOLOCK)                                 
              WHERE 1=1          
                AND M.DIV       ='A' 
                AND M.GUBUN     = 'FROM'
                AND M.COLUMN_NAME LIKE 'SEMI%'
                AND X.MEASURE   IN ('SEMI_SHIP_PLAN','SEMI_SHIP_REQ')
                AND X.OPERATION_GROUP   = 'A'
            -- SEMI_WHIN_TOTAL
            UNION ALL
                SELECT  DISTINCT  X.DIVISION_ID								
			                        , X.OPERATION_GROUP						
			                        , X.CELL_ITEM_ID							
			                        , X.ITEM_ID										
			                        , X.TO_SITE
                              , '-' AS PROJECT_CODE
			                        , X.TO_BOH_QTY										
			                        , X.FROM_BOH_QTY									
			                        , '-' AS INCOTERMS 										
			                        , '-' AS FROM_SITE 										
--                              , (CASE M.COLUMN_NAME WHEN 'SEMI_PACK_PROD_CELL' THEN FROM_SITE ELSE '-' END) AS FROM_SITE
                              , '-' AS TRANSPORT_MODE
                              , '-' AS PROD_LINE
			                        , M.COLUMN_NAME AS MEASURE
						                  , X.YYYYMMDD	
                              , 0    AS QTY
			                        , M.SORT_ORDER_NO								
			                        , M.COLUMN_LABEL_NAME							
			                        , '-' AS BOD_ID 
                              , X.ATTRIBUTE1										
			                        , X.ATTRIBUTE9										
              FROM #ITEM_ID X WITH(NOLOCK)     
              CROSS APPLY #MEASURE M WITH (NOLOCK)                                 
              WHERE 1=1          
                AND M.DIV       ='A' 
                AND M.GUBUN     = 'TO'
                AND M.COLUMN_NAME LIKE 'SEMI%'
                AND X.MEASURE   IN ('SEMI_SHIP_PLAN','SEMI_SHIP_REQ')
                AND X.OPERATION_GROUP   = 'A'

		
			-- E20260331-000738 82사업부 MA Plan 수행 시 속도지연
			SET @v_log_message = N'########## INSERT #PSI_GLOBAL_ESS ##########';
			SET @v_description = @v_program_name + ':' + N' MEASURE 추가 : CELL TO   SITE별 (SEMI_WHIN_TOTAL)   ';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
									  ,@p_log_type      =  N'TXN'
									  ,@p_log_count     = 0       
									  ,@p_log_message   = @v_log_message       
									  ,@p_description   = @v_description       
									  ,@p_event_date    = @d_event_date       
									  ,@p_user_id       = @v_batch_user      
									  ;  


            -------------------------------------------------------------------------------------------------------------------------         
            -- DC Link. 적용 : Pack 영역에서 Semi 관련 measure 가 표시되도록 추가한다. (DC link 만)
            -- MEASURE 추가 : CELL FROM SITE별 (SEMI_WHIN,SEMI_INTRANSIT,SEMI_INTRANSIT_ETA,SEMI_SHIP_PLAN_ETA,SEMI_SHIP_PLAN) 
			-- 2021.12.22   KSW			DC link. Pack Semi 계획에 관련 measure 생성로직 추가
            -------------------------------------------------------------------------------------------------------------------------
            INSERT #PSI_GLOBAL_ESS
              SELECT  DISTINCT  X.DIVISION_ID								
			                        , X.OPERATION_GROUP						
			                        , X.CELL_ITEM_ID							
			                        , X.ITEM_ID										
			                        , X.TO_SITE
                              , X.PROJECT_CODE
			                        , X.TO_BOH_QTY										
			                        , X.FROM_BOH_QTY									
			                        , X.INCOTERMS 										
			                        , X.FROM_SITE
                              , (CASE WHEN M.COLUMN_NAME   = 'SEMI_SHIP_PLAN' THEN X.TRANSPORT_MODE 
                                      WHEN M.COLUMN_NAME   = 'SEMI_SHIP_REQ'  THEN X.TRANSPORT_MODE 
                                      ELSE '-' END) AS TRANSPORT_MODE
                              , X.PROD_LINE
			                        , M.COLUMN_NAME AS MEASURE
						                  , X.YYYYMMDD	
                              , 0    AS QTY
			                        , M.SORT_ORDER_NO								
			                        , M.COLUMN_LABEL_NAME							
			                        , (CASE WHEN M.COLUMN_NAME = 'SEMI_SHIP_PLAN' THEN X.BOD_ID  
                                      WHEN M.COLUMN_NAME = 'SEMI_SHIP_REQ'  THEN X.BOD_ID  
                                      ELSE '-' END) AS BOD_ID 
                              , X.ATTRIBUTE1
                              , X.ATTRIBUTE9										   
			  FROM (SELECT DISTINCT X.*
					  FROM #ITEM_ID X WITH (NOLOCK)
					  -- 2025.09.02	kimcd	속도 개선 HASH 추가
					INNER HASH JOIN (SELECT distinct z.model_id as item_id, z.child_item_id as cell_item_id, z.accumulated_child_qty as cell_qty_pack, y.module_id, y.module_qty_pack
								  FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V z WITH(NOLOCK),
									   ( SELECT x.DIVISION_ID, x.model_id, x.child_item_id as module_id, x.child_qty as module_qty_pack
										   FROM dbo.scm_mst_bom_sn_V x WITH(NOLOCK)	--2021-03-09	SCP 대치 BOM 적용
												INNER JOIN dbo.scm_mst_item_sn i WITH(NOLOCK)
												ON  x.child_division_id = i.division_id
												AND x.child_item_id     = i.item_id
												--AND I.FLOW_ID = 'P5200'
												AND x.child_company_id  = i.company_id -- A002 빈강 추가 따른 조건 추가
												AND x.child_site_id     = i.site_id
												AND i.active_flag       = 'Y'           
										  WHERE 1=1
										) Y
								 WHERE z.DIVISION_ID        = Y.DIVISION_ID
									AND z.MODEL_ID           = Y.model_id
									AND z.OPERATION_GROUP_ID = 'P'
							   ) Z
						 ON X.OPERATION_GROUP    = 'P'
						AND Z.MODULE_ID IN (SELECT DISTINCT ITEM_ID 
											  FROM SCM_MST_FINAL_ITEM_V with (nolock)
											 WHERE DIVISION_ID = @p_division_id
											   AND OPERATION_GROUP_ID = 'P'
											   AND DC_YN = 'Y')
						--AND Z.MODULE_ID = 'ETD1529A5A22'  --성능과부화 회피코드....delete DHJ 07/19/2023
						AND X.ITEM_ID   = Z.cell_item_id	
						AND X.ITEM_ID   <> Z.ITEM_ID
						AND X.MEASURE   IN ('SEMI_SHIP_PLAN','SEMI_SHIP_REQ')
			       ) X
              CROSS APPLY #MEASURE M WITH (NOLOCK)                                 
              WHERE 1=1          
                AND M.DIV       ='A' 
                AND M.GUBUN     = 'FROM'
                AND M.COLUMN_NAME LIKE 'SEMI%'
                AND X.MEASURE   IN ('SEMI_SHIP_PLAN','SEMI_SHIP_REQ')
                AND X.OPERATION_GROUP   = 'P'		-- << Semi 는 'A' 이지만 DC link 는 'P'
				;
			
			IF @P_IS_DEBUG = 1 SELECT '1254_#ITEM_ID' AS  #ITEM_ID , * FROM #ITEM_ID 

			-- E20260331-000738 82사업부 MA Plan 수행 시 속도지연
			SET @v_log_message = N'########## INSERT #PSI_GLOBAL_ESS ##########';
			SET @v_description = @v_program_name + ':' + N' MEASURE 추가 : CELL FROM SITE별 (SEMI_WHIN,SEMI_INTRANSIT,SEMI_INTRANSIT_ETA,SEMI_SHIP_PLAN_ETA,SEMI_SHIP_PLAN)    ';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
									  ,@p_log_type      =  N'TXN'
									  ,@p_log_count     = 0       
									  ,@p_log_message   = @v_log_message       
									  ,@p_description   = @v_description       
									  ,@p_event_date    = @d_event_date       
									  ,@p_user_id       = @v_batch_user      
									  ;  

            -------------------------------------------------------------------------------------------------------------------------         
            -- MEASURE 추가 : CELL FROM SITE별 (CELL_BOH,CELL_EOH,CELL_SHIP_PLAN_TOTAL,CELL_CHAR_PLAN
            --                                 ,CELL_CHAR_AVAILABLE,CELL_FORM_PROGRESS,CELL_FORM_HOLD,CELL_FOR_FORM_END,CELL_PROD_FORM_END
            -------------------------------------------------------------------------------------------------------------------------
            INSERT #PSI_GLOBAL_ESS
              SELECT  DISTINCT  X.DIVISION_ID								
			                        , X.OPERATION_GROUP						
			                        , X.CELL_ITEM_ID							
			                        , X.ITEM_ID										
			                        , '-' AS TO_SITE
                              , '-' AS PROJECT_CODE
			                        , X.TO_BOH_QTY										
			                        , X.FROM_BOH_QTY									
			                        , '-' AS INCOTERMS 										
			                        , X.FROM_SITE 										
                              , '-' AS  TRANSPORT_MODE
                              , '-' AS PROD_LINE
--                              , (CASE WHEN M.COLUMN_NAME ='CELL_TACT_TIME' THEN PROD_LINE ELSE  '-' END ) AS PROD_LINE
			                        , M.COLUMN_NAME AS MEASURE
						                  , X.YYYYMMDD	
                              , 0    AS QTY
			                        , M.SORT_ORDER_NO								
			                        , M.COLUMN_LABEL_NAME							
			                        , '-'  AS BOD_ID 
                              , X.ATTRIBUTE1										
			                        , X.ATTRIBUTE9										
              FROM #ITEM_ID X WITH(NOLOCK)     
              CROSS APPLY #MEASURE M WITH (NOLOCK)                                 
              WHERE 1=1          
                AND M.DIV       ='A' 
                AND M.GUBUN     = 'FROM'
                AND M.COLUMN_NAME LIKE 'CELL%'
                AND X.MEASURE   = 'CELL_CHAR_PLAN'
                AND X.OPERATION_GROUP   = 'A'
                AND M.COLUMN_NAME NOT IN ('CELL_PROD','CELL_PROD_LOAD','CELL_TACT_TIME','CELL_WORKING_TIME')

			-- E20260331-000738 82사업부 MA Plan 수행 시 속도지연
			SET @v_log_message = N'########## INSERT #PSI_GLOBAL_ESS ##########';
			SET @v_description = @v_program_name + ':' + N'  MEASURE 추가 : CELL FROM SITE별 (CELL_BOH,CELL_EOH,CELL_SHIP_PLAN_TOTAL,CELL_CHAR_PLAN    ';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
									  ,@p_log_type      =  N'TXN'
									  ,@p_log_count     = 0       
									  ,@p_log_message   = @v_log_message       
									  ,@p_description   = @v_description       
									  ,@p_event_date    = @d_event_date       
									  ,@p_user_id       = @v_batch_user      
									  ;  


---- 단위처리시간 추출 --
--print N'position_14 #PSI_GLOBAL_ESS temp 에 CELL  measure 추가'
--print REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +     
--      REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))     
--set @v_start_time = SYSDATETIME();
---- 단위처리시간 추출 --


               

			   IF @P_IS_DEBUG = 1 SELECT '1303' AS  "#PSI_GLOBAL_ESS" , * FROM #PSI_GLOBAL_ESS WHERE YYYYMMDD = @P_PLAN_START_YYYYMMDD 

            -------------------------------------------------------------------------------------------------------------------------         
            -- MEASURE 추가 : CELL FROM SITE별 (CELL_PROD,CELL_PROD_LOAD) 
            -------------------------------------------------------------------------------------------------------------------------

               INSERT #PSI_GLOBAL_ESS
              SELECT  DISTINCT  X.DIVISION_ID								
			                        , X.OPERATION_GROUP						
			                        , X.CELL_ITEM_ID							
			                        , X.ITEM_ID										
			                        , '-' AS TO_SITE
                              , '-' AS PROJECT_CODE
			                        , X.TO_BOH_QTY										
			                        , X.FROM_BOH_QTY									
			                        , '-' AS INCOTERMS 										
			                        , X.FROM_SITE 										
                              , '-' AS  TRANSPORT_MODE
                              , X.PROD_LINE
			                        , M.COLUMN_NAME AS MEASURE
						                  , X.YYYYMMDD	
                              , 0    AS QTY
			                        , M.SORT_ORDER_NO								
			                        , M.COLUMN_LABEL_NAME							
			                        , '-'  AS BOD_ID 
                              , (CASE WHEN M.COLUMN_NAME ='CELL_TACT_TIME' THEN 'X' ELSE X.ATTRIBUTE1 END) AS ATTRIBUTE1
			                        , X.ATTRIBUTE9										
              FROM #ITEM_ID X WITH(NOLOCK)     
              CROSS APPLY #MEASURE M WITH (NOLOCK)                                 
              WHERE 1=1          
                AND M.DIV       ='A' 
                AND M.GUBUN     = 'FROM'
                AND X.OPERATION_GROUP   = 'A'
                AND M.COLUMN_NAME IN ('CELL_PROD','CELL_PROD_LOAD','CELL_TACT_TIME')
                AND X.PROD_LINE <> '-'

			-- E20260331-000738 82사업부 MA Plan 수행 시 속도지연
			SET @v_log_message = N'########## INSERT #PSI_GLOBAL_ESS ##########';
			SET @v_description = @v_program_name + ':' + N'  MEASURE 추가 : CELL FROM SITE별 (CELL_PROD,CELL_PROD_LOAD)    ';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
									  ,@p_log_type      =  N'TXN'
									  ,@p_log_count     = 0       
									  ,@p_log_message   = @v_log_message       
									  ,@p_description   = @v_description       
									  ,@p_event_date    = @d_event_date       
									  ,@p_user_id       = @v_batch_user      
									  ;  

---- 단위처리시간 추출 --
--print N'position_15 #PSI_GLOBAL_ESS temp 에 CELL_PROD,CELL_PROD_LOAD  measure 추가'
--print REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +     
--      REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))     
--set @v_start_time = SYSDATETIME();
---- 단위처리시간 추출 --


            -------------------------------------------------------------------------------------------------------------         
            -- TACT TIME TEMP 생성  -- ESS 외주 Line별 생산 Target 관련 OSP_YN로직 수정
            -------------------------------------------------------------------------------------------------------------     
			-- 튜닝 -- PR_SCP_XLS_PSI_GLOBAL_ESS_S 에서 이동
             IF OBJECT_ID('tempdb..#tmp_SCP_MST_TACT_TIME') IS NOT NULL	
	              DROP TABLE #tmp_SCP_MST_TACT_TIME
             
             SELECT * 
             INTO #tmp_SCP_MST_TACT_TIME
             FROM 
             (
                SELECT DIVISION_ID,PLANT_SITE_ID,ITEM_ID,OPERATION_ID,LINE_ID,YIELD, TACT_TIME
                FROM SCP_MST_TACT_TIME WITH(NOLOCK)
                WHERE DIVISION_ID =@p_division_id
                -- AND OPERATION_ID IN ('P9500','P5500')
                UNION ALL
                SELECT DIVISION_ID,PLANT_SITE_ID,ITEM_ID,OPERATION_ID,LINE_ID,YIELD, TACT_TIME 
                FROM SCP_MST_TACT_TIME_OSP WITH(NOLOCK)
                WHERE DIVISION_ID =@p_division_id
              -- AND OPERATION_ID IN ('P9500','P5500')
              ) X



				INSERT INTO #PSI_GLOBAL_ESS (
						 DIVISION_ID
						,OPERATION_GROUP
						,CELL_ITEM_ID	
						,ITEM_ID
						,TO_SITE
						,PROJECT_CODE
						,TO_BOH_QTY
						,FROM_BOH_QTY
						,INCOTERMS
						,FROM_SITE
						,TRANSPORT_MODE
						,PROD_LINE
						,MEASURE
						,YYYYMMDD
						,QTY
						,SORT_ORDER_NO
						,COLUMN_LABEL_NAME
						,BOD_ID
						,ATTRIBUTE1
						,ATTRIBUTE9
				       )
						SELECT A.DIVISION_ID
							,RIGHT(PLANT_SITE_ID, 1) AS OPERATION_GROUP
							,''                      AS CELL_ITEM_ID	
							,A.ITEM_ID
							,'-'                     AS TO_SITE
							,'-'                     AS PROJECT_CODE
							,0                       AS TO_BOH_QTY
							,0                       AS FROM_BOH_QTY
							,'-'                     AS INCOTERMS
							,A.PLANT_SITE_ID         AS FROM_SITE
							,'-'                     AS TRANSPORT_MODE
							,LINE_ID                 AS PROD_LINE
							,B.COLUMN_NAME           AS MEASURE
							,@p_plan_start_yyyymmdd  AS YYYYMMDD
							,0                       AS QTY
							,B.SORT_ORDER_NO
							,COLUMN_LABEL_NAME
							,'-'                       AS BOD_ID
							,'SCP_ANL_PRODUCTION_PLAN' AS ATTRIBUTE1
							,A.OPERATION_ID            AS ATTRIBUTE9
						FROM #tmp_SCP_MST_TACT_TIME A WITH (NOLOCK),
						     #MEASURE B WITH (NOLOCK)
					   WHERE RIGHT(A.PLANT_SITE_ID, 1) = 'P' 
					     AND B.COLUMN_NAME IN ('PACK_WORKING_TIME', 'PACK_DIO', 'PACK_PROD_LOAD_TOTAL', 'PACK_PROD_TOTAL', 'PACK_TACT_TIME', 'CELL_TACT_TIME')
				       ;

			-- E20260331-000738 82사업부 MA Plan 수행 시 속도지연
			SET @v_log_message = N'########## INSERT #PSI_GLOBAL_ESS ##########';
			SET @v_description = @v_program_name + ':' + N'  TACT TIME TEMP 생성  -- ESS 외주 Line별 생산 Target 관련 OSP_YN로직 수정    ';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
									  ,@p_log_type      =  N'TXN'
									  ,@p_log_count     = 0       
									  ,@p_log_message   = @v_log_message       
									  ,@p_description   = @v_description       
									  ,@p_event_date    = @d_event_date       
									  ,@p_user_id       = @v_batch_user      
									  ;  

                
---- 단위처리시간 추출 --
--print N'position_15_1 #PSI_GLOBAL_ESS temp 에 TECT TIME에 의한 생산 LINE 추가'
--print REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +     
--      REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))     
--set @v_start_time = SYSDATETIME();
---- 단위처리시간 추출 --


                INSERT #PSI_GLOBAL_ESS
                 SELECT X.DIVISION_ID								
			                , X.OPERATION_GROUP						
			                , X.CELL_ITEM_ID							
			                , X.ITEM_ID										
			                , '-' AS TO_SITE
                      , '-' AS PROJECT_CODE
			                , X.TO_BOH_QTY										
			                , X.FROM_BOH_QTY									
			                , '-' AS INCOTERMS 										
			                , X.FROM_SITE 										
                      , '-' AS  TRANSPORT_MODE
                      , X.PROD_LINE
			                , X.MEASURE
						          , E.YYYYMMDD	
                      , E.TACT_TIME    AS QTY
			                , X.SORT_ORDER_NO								
			                , X.COLUMN_LABEL_NAME							
			                , '-'  AS BOD_ID 
                      , 'O' AS ATTRIBUTE1
			                , X.ATTRIBUTE9				
                FROM #PSI_GLOBAL_ESS X WITH (NOLOCK)
                INNER JOIN SCP_ANL_TACT_TIME E WITH(NOLOCK)	
                      ON X.DIVISION_ID    = E.DIVISION_ID 
                     AND X.ATTRIBUTE9     = E.OPERATION_ID 
				             AND X.FROM_SITE      = E.SCM_SITE_ID  
				             AND X.PROD_LINE      = E.LINE_ID 
                     AND X.ITEM_ID        = E.ITEM_ID 
				             --AND A.YYYYMMDD       = E.YYYYMMDD
                     AND X.YYYYMMDD       <= E.YYYYMMDD
                WHERE 0 = 0
                     AND X.MEASURE        ='CELL_TACT_TIME'
                     AND E.YYYYMMDD           >= @p_plan_start_yyyymmdd
                     AND E.YYYYMMDD           <  @p_to_yyyymmdd
	                 --AND E.YYYYMMDD           <=  @p_to_yyyymmdd   --말일포함(KSK, 20240814, 운영배포보류)          
                     
                     --IF OBJECT_ID('tempdb..##PSI_GLOBAL') IS NOT NULL	
	                    --DROP TABLE ##PSI_GLOBAL

                     --SELECT * INTO ##PSI_GLOBAL FROM #PSI_GLOBAL WITH (NOLOCK)

                     --IF OBJECT_ID('tempdb..##PSI_GLOBAL_ESS') IS NOT NULL	
	                    --DROP TABLE ##PSI_GLOBAL_ESS

                     --SELECT * INTO ##PSI_GLOBAL_ESS  FROM #PSI_GLOBAL_ESS WITH (NOLOCK)
                     --return;
                
---- 단위처리시간 추출 --
--print N'position_15-2 #PSI_GLOBAL_ESS temp 에 CELL_TACT_TIME update'
--print REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +     
--      REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))     
--set @v_start_time = SYSDATETIME();
---- 단위처리시간 추출 --

			-- E20260331-000738 82사업부 MA Plan 수행 시 속도지연
			SET @v_log_message = N'########## INSERT #PSI_GLOBAL_ESS ##########';
			SET @v_description = @v_program_name + ':' + N'  CELL_TACT_TIME    ';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
									  ,@p_log_type      =  N'TXN'
									  ,@p_log_count     = 0       
									  ,@p_log_message   = @v_log_message       
									  ,@p_description   = @v_description       
									  ,@p_event_date    = @d_event_date       
									  ,@p_user_id       = @v_batch_user      
									  ;  



            -------------------------------------------------------------------------------------------------------------------------         
            -- MEASURE 0 추가 : 
            -------------------------------------------------------------------------------------------------------------------------
                --INSERT #PSI_GLOBAL_ESS
                --SELECT  DIVISION_ID		   
                --       ,OPERATION_GROUP	 
                --       ,CELL_ITEM_ID		   
                --       ,ITEM_ID			     
                --       ,TO_SITE			     
                --       ,PROJECT_CODE      
                --       ,TO_BOH_QTY			   
                --       ,FROM_BOH_QTY		   
                --       ,INCOTERMS			   
                --       ,FROM_SITE			   
                --       ,TRANSPORT_MODE    
                --       ,PROD_LINE         
                --       ,MEASURE			     
                --       , Y.YYYYMMDD     
                --       ,'0' AS QTY				       
                --       ,SORT_ORDER_NO		 
                --       ,COLUMN_LABEL_NAME	
                --       ,BOD_ID				     
                --       ,ATTRIBUTE1			   
                --       ,ATTRIBUTE9			   
                -- FROM #PSI_GLOBAL_ESS X WITH (NOLOCK)
                -- CROSS APPLY 
                -- (  -- 364 DAYS      
                --       SELECT C.BASIS_YYYYMMDD AS YYYYMMDD          
                --        FROM SCM_SYS_CALENDAR_M    C WITH(NOLOCK)         
                --       WHERE 1=1      
                --       AND C.BASIS_YYYYMMDD > @p_plan_start_yyyymmdd       -- 엔진시작일 제외
                --       AND C.BASIS_YYYYMMDD <  @p_to_yyyymmdd  
                --  ) Y
                --WHERE 0 = 0


		-- 중복생성으로 인한 수량중복을 방지하기 위해서 임시작업 테이블에 저장
				IF OBJECT_ID('tempdb..#tmp_PSI_GLOBAL_ESS') IS NOT NULL	
						DROP TABLE #tmp_PSI_GLOBAL_ESS		

        -- 0 값을 플랜시작일자만 추가한다. - 모든 item 의 모든 measure
                SELECT  DIVISION_ID		   
                       ,OPERATION_GROUP	 
                       ,CELL_ITEM_ID		   
                       ,ITEM_ID			     
                       ,TO_SITE			     
                       ,PROJECT_CODE      
                       ,TO_BOH_QTY			   
                       ,FROM_BOH_QTY		   
                       ,INCOTERMS			   
                       ,FROM_SITE			   
                       ,TRANSPORT_MODE    
                       ,PROD_LINE         
                       ,MEASURE			     
                       , Y.YYYYMMDD     
                       ,'0' AS QTY				       
                       ,SORT_ORDER_NO		 
                       ,COLUMN_LABEL_NAME	
                       ,BOD_ID				     
                       ,ATTRIBUTE1			   
                       ,ATTRIBUTE9		
				 INTO #tmp_PSI_GLOBAL_ESS
                 FROM (SELECT DISTINCT
				                DIVISION_ID		   
							   ,OPERATION_GROUP	 
							   ,CELL_ITEM_ID		   
							   ,ITEM_ID			     
							   ,TO_SITE			     
							   ,PROJECT_CODE      
							   ,TO_BOH_QTY			   
							   ,FROM_BOH_QTY		   
							   ,INCOTERMS			   
							   ,FROM_SITE			   
							   ,TRANSPORT_MODE    
							   ,PROD_LINE         
							   ,MEASURE	         			       
							   ,SORT_ORDER_NO		 
							   ,COLUMN_LABEL_NAME	
							   ,BOD_ID				     
							   ,ATTRIBUTE1			   
							   ,ATTRIBUTE9		
				         FROM #PSI_GLOBAL_ESS WITH (NOLOCK)
					  ) X
                 CROSS APPLY 
                 (  -- 364 DAYS      
					SELECT DISTINCT YYYYMMDD
					  FROM (
						   --SELECT YYYYMMDD          
							--FROM #PSI_GLOBAL    C WITH(NOLOCK)         
						   --UNION ALL
						   SELECT @p_plan_start_yyyymmdd AS YYYYMMDD
						   UNION ALL
						   SELECT CONVERT(VARCHAR(8), DATEADD(day, 364, @p_plan_start_yyyymmdd), 112) AS YYYYMMDD
						  ) X
                  ) Y
                WHERE 0 = 0
				;

				IF @P_IS_DEBUG = 1 BEGIN SELECT '1592' AS  #tmp_PSI_GLOBAL_ESS , * FROM #tmp_PSI_GLOBAL_ESS  END


				-- 0 값(플랜시작일자만)이 추가된 작업용 테이블의 DATA 를 #PSI_GLOBAL_ESS 으로 복제
				DELETE #PSI_GLOBAL_ESS;

				INSERT #PSI_GLOBAL_ESS
			    SELECT *
				  FROM #tmp_PSI_GLOBAL_ESS X WITH (NOLOCK)
				;

               IF OBJECT_ID('tempdb..#tmp_PSI_GLOBAL_ESS') IS NOT NULL      
	              DROP TABLE #tmp_PSI_GLOBAL_ESS; 
			
				--SELECT  '#ESS_#TMP' TN, * FROM  #PSI_GLOBAL_ESS ;RETURN -1   --TEST

			-- E20260331-000738 82사업부 MA Plan 수행 시 속도지연
			SET @v_log_message = N'########## INSERT #PSI_GLOBAL_ESS ##########';
			SET @v_description = @v_program_name + ':' + N'  0 값(플랜시작일자만)이 추가된 작업용 테이블의 DATA 를 #PSI_GLOBAL_ESS 으로 복제    ';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
									  ,@p_log_type      =  N'TXN'
									  ,@p_log_count     = 0       
									  ,@p_log_message   = @v_log_message       
									  ,@p_description   = @v_description       
									  ,@p_event_date    = @d_event_date       
									  ,@p_user_id       = @v_batch_user      
									  ;  




---- 단위처리시간 추출 --
--print N'position_16 #PSI_GLOBAL_ESS temp 에 0 값 추가'
--print REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +     
--      REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))     
--set @v_start_time = SYSDATETIME();
---- 단위처리시간 추출 --


                 -- MKT_FCST
--                UPDATE X
--                SET X.QTY = Y.QTY
--                FROM #PSI_GLOBAL_ESS X  WITH (NOLOCK)
--                INNER JOIN 
--                (SELECT ITEM_ID, TO_SITE, MEASURE, INCOTERMS, YYYYMMDD, SUM(QTY) AS QTY
--                  FROM #ANL_SHIPMENT_PLAN_FG   WITH (NOLOCK)
--                  GROUP BY ITEM_ID,TO_SITE, MEASURE, INCOTERMS,YYYYMMDD
--                 ) Y 
--                ON 0 = 0
--                AND X.TO_SITE         = Y.TO_SITE
----                AND X.FROM_SITE       = Y.FROM_SITE
--                AND X.MEASURE         = Y.MEASURE
--                AND X.ITEM_ID         = Y.ITEM_ID
--                AND X.YYYYMMDD        = Y.YYYYMMDD
--                AND X.INCOTERMS       = Y.INCOTERMS
----                AND X.TRANSPORT_MODE  = Y.TRANSPORT_MODE
----                AND X.PROJECT_CODE    = Y.PROJECT_CODE
--                AND X.MEASURE         = 'MKT_FCST'                  
				
				

				MERGE INTO #PSI_GLOBAL_ESS AS X
				USING (SELECT DIVISION_ID
							,OPERATION_GROUP
							,CELL_ITEM_ID	
							,ITEM_ID
							,TO_SITE
							,'-'               AS PROJECT_CODE			-- 중복방지
							,TO_BOH_QTY
							,FROM_BOH_QTY
							,INCOTERMS
							,FROM_SITE
							,TRANSPORT_MODE
							,PROD_LINE
							,MEASURE
							,YYYYMMDD
							,SUM(QTY) AS QTY
							,SORT_ORDER_NO
							,COLUMN_LABEL_NAME
							,BOD_ID
							,ATTRIBUTE1
							,ATTRIBUTE9
						FROM #ANL_SHIPMENT_PLAN_FG WITH (NOLOCK)
						WHERE MEASURE         = 'MKT_FCST' 
						GROUP BY DIVISION_ID
							,OPERATION_GROUP
							,CELL_ITEM_ID	
							,ITEM_ID
							,TO_SITE
							,TO_BOH_QTY
							,FROM_BOH_QTY
							,INCOTERMS
							,FROM_SITE
							,TRANSPORT_MODE
							,PROD_LINE
							,MEASURE
							,YYYYMMDD
							,SORT_ORDER_NO
							,COLUMN_LABEL_NAME
							,BOD_ID
							,ATTRIBUTE1
							,ATTRIBUTE9
				      ) AS Z
				ON 0 = 0
				AND X.OPERATION_GROUP = Z.OPERATION_GROUP
				AND X.ITEM_ID         = Z.ITEM_ID
				AND X.TO_SITE         = Z.TO_SITE
				AND X.PROJECT_CODE    = Z.PROJECT_CODE
				AND X.INCOTERMS       = Z.INCOTERMS
				AND X.MEASURE         = Z.MEASURE
				AND X.YYYYMMDD        = Z.YYYYMMDD
				WHEN MATCHED  THEN
				UPDATE
				   SET X.QTY = Z.QTY
				WHEN NOT MATCHED  THEN
				INSERT (
						 DIVISION_ID
						,OPERATION_GROUP
						,CELL_ITEM_ID	
						,ITEM_ID
						,TO_SITE
						,PROJECT_CODE
						,TO_BOH_QTY
						,FROM_BOH_QTY
						,INCOTERMS
						,FROM_SITE
						,TRANSPORT_MODE
						,PROD_LINE
						,MEASURE
						,YYYYMMDD
						,QTY
						,SORT_ORDER_NO
						,COLUMN_LABEL_NAME
						,BOD_ID
						,ATTRIBUTE1
						,ATTRIBUTE9
				       )
				VALUES (
						 Z.DIVISION_ID
						,Z.OPERATION_GROUP
						,Z.CELL_ITEM_ID	
						,Z.ITEM_ID
						,Z.TO_SITE
						,Z.PROJECT_CODE
						,Z.TO_BOH_QTY
						,Z.FROM_BOH_QTY
						,Z.INCOTERMS
						,Z.FROM_SITE
						,Z.TRANSPORT_MODE
						,Z.PROD_LINE
						,Z.MEASURE
						,Z.YYYYMMDD
						,Z.QTY
						,Z.SORT_ORDER_NO
						,Z.COLUMN_LABEL_NAME
						,Z.BOD_ID
						,Z.ATTRIBUTE1
						,Z.ATTRIBUTE9
				       );

			-- E20260331-000738 82사업부 MA Plan 수행 시 속도지연
			SET @v_log_message = N'########## INSERT #PSI_GLOBAL_ESS ##########';
			SET @v_description = @v_program_name + ':' + N'  MKT_FCST    ';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
									  ,@p_log_type      =  N'TXN'
									  ,@p_log_count     = 0       
									  ,@p_log_message   = @v_log_message       
									  ,@p_description   = @v_description       
									  ,@p_event_date    = @d_event_date       
									  ,@p_user_id       = @v_batch_user      
									  ;  

---- 단위처리시간 추출 --
--print N'position_17 #PSI_GLOBAL_ESS temp 에 MKT_FCST update'
--print REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +     
--      REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))     
--set @v_start_time = SYSDATETIME();
---- 단위처리시간 추출 --

    --            UPDATE X
    --            SET X.QTY = Y.QTY
    --            FROM #PSI_GLOBAL_ESS X  WITH (NOLOCK)
    --            INNER JOIN #ANL_SHIPMENT_PLAN_FG Y  WITH (NOLOCK)
    --            ON 0 = 0
    --            AND X.TO_SITE         = Y.TO_SITE
    --            AND X.FROM_SITE       = Y.FROM_SITE
    --            AND X.MEASURE         = Y.MEASURE
    --            AND X.ITEM_ID         = Y.ITEM_ID
    --            AND X.YYYYMMDD        = Y.YYYYMMDD
    --            AND X.INCOTERMS       = Y.INCOTERMS
    --            AND X.TRANSPORT_MODE  = Y.TRANSPORT_MODE
    --            AND X.PROJECT_CODE    = Y.PROJECT_CODE
    --            AND X.MEASURE         IN ('SHIP_PLAN','SHIP_REQ')
				--AND X.BOD_ID          = Y.BOD_ID					-- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 BOD_ID 추가

				MERGE INTO #PSI_GLOBAL_ESS AS X
				USING (SELECT DIVISION_ID
							,OPERATION_GROUP
							,CELL_ITEM_ID	
							,ITEM_ID
							,TO_SITE
							,PROJECT_CODE			-- 중복방지
							,TO_BOH_QTY
							,FROM_BOH_QTY
							,INCOTERMS
							,FROM_SITE
							,TRANSPORT_MODE
							,PROD_LINE
							,MEASURE
							,YYYYMMDD
							,SUM(QTY) AS QTY
							,SORT_ORDER_NO
							,COLUMN_LABEL_NAME
							,BOD_ID
							,ATTRIBUTE1
							,ATTRIBUTE9
						FROM #ANL_SHIPMENT_PLAN_FG WITH (NOLOCK)
						WHERE MEASURE         IN ('SHIP_PLAN','SHIP_REQ') 
						GROUP BY DIVISION_ID
							,OPERATION_GROUP
							,CELL_ITEM_ID	
							,ITEM_ID
							,TO_SITE
							,PROJECT_CODE
							,TO_BOH_QTY
							,FROM_BOH_QTY
							,INCOTERMS
							,FROM_SITE
							,TRANSPORT_MODE
							,PROD_LINE
							,MEASURE
							,YYYYMMDD
							,SORT_ORDER_NO
							,COLUMN_LABEL_NAME
							,BOD_ID
							,ATTRIBUTE1
							,ATTRIBUTE9
				      ) AS Z
				ON 0 = 0
                AND X.TO_SITE         = Z.TO_SITE
                AND X.FROM_SITE       = Z.FROM_SITE
                AND X.MEASURE         = Z.MEASURE
                AND X.ITEM_ID         = Z.ITEM_ID
                AND X.YYYYMMDD        = Z.YYYYMMDD
                AND X.INCOTERMS       = Z.INCOTERMS
                AND X.TRANSPORT_MODE  = Z.TRANSPORT_MODE
                AND X.PROJECT_CODE    = Z.PROJECT_CODE
				AND X.BOD_ID          = Z.BOD_ID			-- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 BOD_ID 추가
				WHEN MATCHED  THEN
				UPDATE
				   SET X.QTY = Z.QTY
				WHEN NOT MATCHED  THEN
				INSERT (
						 DIVISION_ID
						,OPERATION_GROUP
						,CELL_ITEM_ID	
						,ITEM_ID
						,TO_SITE
						,PROJECT_CODE
						,TO_BOH_QTY
						,FROM_BOH_QTY
						,INCOTERMS
						,FROM_SITE
						,TRANSPORT_MODE
						,PROD_LINE
						,MEASURE
						,YYYYMMDD
						,QTY
						,SORT_ORDER_NO
						,COLUMN_LABEL_NAME
						,BOD_ID
						,ATTRIBUTE1
						,ATTRIBUTE9
				       )
				VALUES (
						 Z.DIVISION_ID
						,Z.OPERATION_GROUP
						,Z.CELL_ITEM_ID	
						,Z.ITEM_ID
						,Z.TO_SITE
						,Z.PROJECT_CODE
						,Z.TO_BOH_QTY
						,Z.FROM_BOH_QTY
						,Z.INCOTERMS
						,Z.FROM_SITE
						,Z.TRANSPORT_MODE
						,Z.PROD_LINE
						,Z.MEASURE
						,Z.YYYYMMDD
						,Z.QTY
						,Z.SORT_ORDER_NO
						,Z.COLUMN_LABEL_NAME
						,Z.BOD_ID
						,Z.ATTRIBUTE1
						,Z.ATTRIBUTE9
				       );
					   
					IF @P_IS_DEBUG = 1  SELECT '1853_PSI_GLOBAL' AS  "#PSI_GLOBAL_ESS" , * FROM #PSI_GLOBAL_ESS WHERE YYYYMMDD = @P_PLAN_START_YYYYMMDD 

			-- E20260331-000738 82사업부 MA Plan 수행 시 속도지연
			SET @v_log_message = N'########## INSERT #PSI_GLOBAL_ESS ##########';
			SET @v_description = @v_program_name + ':' + N'  SHIP_PLAN ,  SHIP_REQ    ';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
									  ,@p_log_type      =  N'TXN'
									  ,@p_log_count     = 0       
									  ,@p_log_message   = @v_log_message       
									  ,@p_description   = @v_description       
									  ,@p_event_date    = @d_event_date       
									  ,@p_user_id       = @v_batch_user      
									  ;  
					 

---- 단위처리시간 추출 --
--print N'position_18 #PSI_GLOBAL_ESS temp 에 SHIP_PLAN, SHIP_REQ update'
--print REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +     
--      REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))     
--set @v_start_time = SYSDATETIME();
---- 단위처리시간 추출 --


                -- PACK_PROD
--                UPDATE X
--                SET X.QTY = Y.QTY
--                FROM #PSI_GLOBAL_ESS X  WITH (NOLOCK)
--                INNER JOIN #ANL_PRODUCTION_PLAN Y  WITH (NOLOCK)
--                ON 0 = 0
--                AND X.TO_SITE   = Y.TO_SITE
--                AND X.FROM_SITE = Y.FROM_SITE
--                AND X.MEASURE   = Y.MEASURE
--                AND X.YYYYMMDD  = Y.YYYYMMDD
--                AND X.ITEM_ID   = Y.ITEM_ID
--                AND X.PROD_LINE = Y.PROD_LINE
----                AND X.TRANSPORT_MODE  = Y.TRANSPORT_MODE


				MERGE INTO #PSI_GLOBAL_ESS AS X
				USING (SELECT DIVISION_ID
							,OPERATION_GROUP
							,CELL_ITEM_ID	
							,ITEM_ID
							,TO_SITE
							,PROJECT_CODE
							,TO_BOH_QTY
							,FROM_BOH_QTY
							,INCOTERMS
							,FROM_SITE
							,TRANSPORT_MODE
							,PROD_LINE
							,MEASURE
							,YYYYMMDD
							,SUM(QTY) AS QTY
							,SORT_ORDER_NO
							,COLUMN_LABEL_NAME
							,BOD_ID
							,ATTRIBUTE1
							,ATTRIBUTE9
						FROM #ANL_PRODUCTION_PLAN WITH (NOLOCK)
						GROUP BY DIVISION_ID
							,OPERATION_GROUP
							,CELL_ITEM_ID	
							,ITEM_ID
							,TO_SITE
							,PROJECT_CODE
							,TO_BOH_QTY
							,FROM_BOH_QTY
							,INCOTERMS
							,FROM_SITE
							,TRANSPORT_MODE
							,PROD_LINE
							,MEASURE
							,YYYYMMDD
							,SORT_ORDER_NO
							,COLUMN_LABEL_NAME
							,BOD_ID
							,ATTRIBUTE1
							,ATTRIBUTE9
				      ) AS Z
				ON 0 = 0
                AND X.OPERATION_GROUP = Z.OPERATION_GROUP
				AND X.ITEM_ID   = Z.ITEM_ID
				AND X.TO_SITE   = Z.TO_SITE
                AND X.FROM_SITE = Z.FROM_SITE
                AND X.MEASURE   = Z.MEASURE
                AND X.YYYYMMDD  = Z.YYYYMMDD                
                AND X.PROD_LINE = Z.PROD_LINE
				WHEN MATCHED  THEN
				UPDATE
				   SET X.QTY = Z.QTY
				WHEN NOT MATCHED  THEN
				INSERT (
						 DIVISION_ID
						,OPERATION_GROUP
						,CELL_ITEM_ID	
						,ITEM_ID
						,TO_SITE
						,PROJECT_CODE
						,TO_BOH_QTY
						,FROM_BOH_QTY
						,INCOTERMS
						,FROM_SITE
						,TRANSPORT_MODE
						,PROD_LINE
						,MEASURE
						,YYYYMMDD
						,QTY
						,SORT_ORDER_NO
						,COLUMN_LABEL_NAME
						,BOD_ID
						,ATTRIBUTE1
						,ATTRIBUTE9
				       )
				VALUES (
						 Z.DIVISION_ID
						,Z.OPERATION_GROUP
						,Z.CELL_ITEM_ID	
						,Z.ITEM_ID
						,Z.TO_SITE
						,Z.PROJECT_CODE
						,Z.TO_BOH_QTY
						,Z.FROM_BOH_QTY
						,Z.INCOTERMS
						,Z.FROM_SITE
						,Z.TRANSPORT_MODE
						,Z.PROD_LINE
						,Z.MEASURE
						,Z.YYYYMMDD
						,Z.QTY
						,Z.SORT_ORDER_NO
						,Z.COLUMN_LABEL_NAME
						,Z.BOD_ID
						,Z.ATTRIBUTE1
						,Z.ATTRIBUTE9
				       );

					   IF @P_IS_DEBUG = 1  SELECT '1978_PSI_GLOBAL' AS  "#PSI_GLOBAL_ESS" , * FROM #PSI_GLOBAL_ESS WHERE YYYYMMDD = @P_PLAN_START_YYYYMMDD 					 

			-- E20260331-000738 82사업부 MA Plan 수행 시 속도지연
			SET @v_log_message = N'########## INSERT #PSI_GLOBAL_ESS ##########';
			SET @v_description = @v_program_name + ':' + N'  from #ANL_PRODUCTION_PLAN    ';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
									  ,@p_log_type      =  N'TXN'
									  ,@p_log_count     = 0       
									  ,@p_log_message   = @v_log_message       
									  ,@p_description   = @v_description       
									  ,@p_event_date    = @d_event_date       
									  ,@p_user_id       = @v_batch_user      
									  ; 


---- 단위처리시간 추출 --
--print N'position_19 #PSI_GLOBAL_ESS temp 에 PACK_PROD update'
--print REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +     
--      REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))     
--set @v_start_time = SYSDATETIME();
---- 단위처리시간 추출 --


              -- SEMI_SHIP_PLAN
    --            UPDATE X
    --            SET X.QTY = Y.QTY
    --            FROM #PSI_GLOBAL_ESS X  WITH (NOLOCK)
    --            INNER JOIN #ANL_SHIPMENT_PLAN_SEMI Y  WITH (NOLOCK)
    --            ON 0 = 0
    --            AND X.TO_SITE   = Y.TO_SITE
    --            AND X.FROM_SITE = Y.FROM_SITE
    --            AND X.MEASURE   = Y.MEASURE
    --            AND X.YYYYMMDD  = Y.YYYYMMDD
    --            AND X.ITEM_ID   = Y.ITEM_ID
    --            AND X.TRANSPORT_MODE  = Y.TRANSPORT_MODE
				--AND X.BOD_ID          = Y.BOD_ID					-- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 BOD_ID 추가

				MERGE INTO #PSI_GLOBAL_ESS AS X
				USING (SELECT DIVISION_ID
							,OPERATION_GROUP
							,CELL_ITEM_ID	
							,ITEM_ID
							,TO_SITE
							,PROJECT_CODE
							,TO_BOH_QTY
							,FROM_BOH_QTY
							,INCOTERMS
							,FROM_SITE
							,TRANSPORT_MODE
							,PROD_LINE
							,MEASURE
							,YYYYMMDD
							,SUM(QTY) AS QTY
							,SORT_ORDER_NO
							,COLUMN_LABEL_NAME
							,BOD_ID
							,ATTRIBUTE1
							,ATTRIBUTE9
						FROM #ANL_SHIPMENT_PLAN_SEMI WITH (NOLOCK)
						GROUP BY DIVISION_ID
							,OPERATION_GROUP
							,CELL_ITEM_ID	
							,ITEM_ID
							,TO_SITE
							,PROJECT_CODE
							,TO_BOH_QTY
							,FROM_BOH_QTY
							,INCOTERMS
							,FROM_SITE
							,TRANSPORT_MODE
							,PROD_LINE
							,MEASURE
							,YYYYMMDD
							,SORT_ORDER_NO
							,COLUMN_LABEL_NAME
							,BOD_ID
							,ATTRIBUTE1
							,ATTRIBUTE9
				      ) AS Z
				ON 0 = 0
                AND X.OPERATION_GROUP = Z.OPERATION_GROUP
				AND X.ITEM_ID   = Z.ITEM_ID
				AND X.TO_SITE   = Z.TO_SITE
                AND X.FROM_SITE = Z.FROM_SITE
                AND X.MEASURE   = Z.MEASURE
                AND X.YYYYMMDD  = Z.YYYYMMDD                
                AND X.TRANSPORT_MODE  = Z.TRANSPORT_MODE
				AND X.BOD_ID          = Z.BOD_ID
				WHEN MATCHED  THEN
				UPDATE
				   SET X.QTY = Z.QTY
				WHEN NOT MATCHED  THEN
				INSERT (
						 DIVISION_ID
						,OPERATION_GROUP
						,CELL_ITEM_ID	
						,ITEM_ID
						,TO_SITE
						,PROJECT_CODE
						,TO_BOH_QTY
						,FROM_BOH_QTY
						,INCOTERMS
						,FROM_SITE
						,TRANSPORT_MODE
						,PROD_LINE
						,MEASURE
						,YYYYMMDD
						,QTY
						,SORT_ORDER_NO
						,COLUMN_LABEL_NAME
						,BOD_ID
						,ATTRIBUTE1
						,ATTRIBUTE9
				       )
				VALUES (
						 Z.DIVISION_ID
						,Z.OPERATION_GROUP
						,Z.CELL_ITEM_ID	
						,Z.ITEM_ID
						,Z.TO_SITE
						,Z.PROJECT_CODE
						,Z.TO_BOH_QTY
						,Z.FROM_BOH_QTY
						,Z.INCOTERMS
						,Z.FROM_SITE
						,Z.TRANSPORT_MODE
						,Z.PROD_LINE
						,Z.MEASURE
						,Z.YYYYMMDD
						,Z.QTY
						,Z.SORT_ORDER_NO
						,Z.COLUMN_LABEL_NAME
						,Z.BOD_ID
						,Z.ATTRIBUTE1
						,Z.ATTRIBUTE9
				       );
				IF @P_IS_DEBUG = 1  SELECT '2101_PSI_GLOBAL' AS  "#PSI_GLOBAL_ESS" , * FROM #PSI_GLOBAL_ESS WHERE YYYYMMDD = @P_PLAN_START_YYYYMMDD 		
				
			-- E20260331-000738 82사업부 MA Plan 수행 시 속도지연
			SET @v_log_message = N'########## INSERT #PSI_GLOBAL_ESS ##########';
			SET @v_description = @v_program_name + ':' + N'  from #ANL_SHIPMENT_PLAN_SEMI    ';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
									  ,@p_log_type      =  N'TXN'
									  ,@p_log_count     = 0       
									  ,@p_log_message   = @v_log_message       
									  ,@p_description   = @v_description       
									  ,@p_event_date    = @d_event_date       
									  ,@p_user_id       = @v_batch_user      
									  ; 



---- 단위처리시간 추출 --
--print N'position_20 #PSI_GLOBAL_ESS temp 에 SEMI_SHIP_PLAN update'
--print REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +     
--      REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))     
--set @v_start_time = SYSDATETIME();
---- 단위처리시간 추출 --



                -- PRODUCTION
                --UPDATE X
                --SET X.QTY = Y.QTY
                --FROM #PSI_GLOBAL_ESS X  WITH (NOLOCK)
                --INNER JOIN #SCP_PLN_PRODUCTION_PLAN Y  WITH (NOLOCK)
                --ON 0 = 0
                --AND X.TO_SITE   = Y.TO_SITE
                --AND X.FROM_SITE = Y.FROM_SITE
                --AND X.MEASURE   = Y.MEASURE
                --AND X.YYYYMMDD  = Y.YYYYMMDD
                --AND X.ITEM_ID   = Y.ITEM_ID
                --AND X.PROD_LINE = Y.PROD_LINE


				MERGE INTO #PSI_GLOBAL_ESS AS X
				USING (SELECT DIVISION_ID
							,OPERATION_GROUP
							,CELL_ITEM_ID	
							,ITEM_ID
							,TO_SITE
							,PROJECT_CODE
							,TO_BOH_QTY
							,FROM_BOH_QTY
							,INCOTERMS
							,FROM_SITE
							,TRANSPORT_MODE
							,PROD_LINE
							,MEASURE
							,YYYYMMDD
							,SUM(QTY) AS QTY
							,SORT_ORDER_NO
							,COLUMN_LABEL_NAME
							,BOD_ID
							,ATTRIBUTE1
							,ATTRIBUTE9
						FROM #SCP_PLN_PRODUCTION_PLAN WITH (NOLOCK)
						GROUP BY DIVISION_ID
							,OPERATION_GROUP
							,CELL_ITEM_ID	
							,ITEM_ID
							,TO_SITE
							,PROJECT_CODE
							,TO_BOH_QTY
							,FROM_BOH_QTY
							,INCOTERMS
							,FROM_SITE
							,TRANSPORT_MODE
							,PROD_LINE
							,MEASURE
							,YYYYMMDD
							,SORT_ORDER_NO
							,COLUMN_LABEL_NAME
							,BOD_ID
							,ATTRIBUTE1
							,ATTRIBUTE9
				      ) AS Z
				ON 0 = 0
                AND X.OPERATION_GROUP = Z.OPERATION_GROUP
				AND X.ITEM_ID   = Z.ITEM_ID
				AND X.TO_SITE   = Z.TO_SITE
                AND X.FROM_SITE = Z.FROM_SITE
                AND X.MEASURE   = Z.MEASURE
                AND X.YYYYMMDD  = Z.YYYYMMDD                
                AND X.PROD_LINE = Z.PROD_LINE
				WHEN MATCHED  THEN
				UPDATE
				   SET X.QTY = Z.QTY
				WHEN NOT MATCHED  THEN
				INSERT (
						 DIVISION_ID
						,OPERATION_GROUP
						,CELL_ITEM_ID	
						,ITEM_ID
						,TO_SITE
						,PROJECT_CODE
						,TO_BOH_QTY
						,FROM_BOH_QTY
						,INCOTERMS
						,FROM_SITE
						,TRANSPORT_MODE
						,PROD_LINE
						,MEASURE
						,YYYYMMDD
						,QTY
						,SORT_ORDER_NO
						,COLUMN_LABEL_NAME
						,BOD_ID
						,ATTRIBUTE1
						,ATTRIBUTE9
				       )
				VALUES (
						 Z.DIVISION_ID
						,Z.OPERATION_GROUP
						,Z.CELL_ITEM_ID	
						,Z.ITEM_ID
						,Z.TO_SITE
						,Z.PROJECT_CODE
						,Z.TO_BOH_QTY
						,Z.FROM_BOH_QTY
						,Z.INCOTERMS
						,Z.FROM_SITE
						,Z.TRANSPORT_MODE
						,Z.PROD_LINE
						,Z.MEASURE
						,Z.YYYYMMDD
						,Z.QTY
						,Z.SORT_ORDER_NO
						,Z.COLUMN_LABEL_NAME
						,Z.BOD_ID
						,Z.ATTRIBUTE1
						,Z.ATTRIBUTE9
				       );

					IF @P_IS_DEBUG = 1  SELECT '2226_PSI_GLOBAL' AS  "#PSI_GLOBAL_ESS" , * FROM #PSI_GLOBAL_ESS WHERE YYYYMMDD = @P_PLAN_START_YYYYMMDD 		

			-- E20260331-000738 82사업부 MA Plan 수행 시 속도지연
			SET @v_log_message = N'########## INSERT #PSI_GLOBAL_ESS ##########';
			SET @v_description = @v_program_name + ':' + N'  from #SCP_PLN_PRODUCTION_PLAN    ';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
									  ,@p_log_type      =  N'TXN'
									  ,@p_log_count     = 0       
									  ,@p_log_message   = @v_log_message       
									  ,@p_description   = @v_description       
									  ,@p_event_date    = @d_event_date       
									  ,@p_user_id       = @v_batch_user      
									  ; 


---- 단위처리시간 추출 --
--print N'position_21 #PSI_GLOBAL_ESS temp 에 PRODUCTION update'
--print REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +     
--      REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))     
--set @v_start_time = SYSDATETIME();
---- 단위처리시간 추출 --


            -------------------------------------------------------------------------------------------------------------         
            -- INTRANSIT 반영
            -------------------------------------------------------------------------------------------------------------
                  SELECT 
                        DIVISION_ID 
                        ,PLAN_START_YYYYMMDD
                        ,PLAN_TYPE
                        ,SEQ
                        ,OPERATION_GROUP
                        ,ITEM_ID
                        ,TO_SITE
                        ,FROM_SITE
                        --,MEASURE
                        ,YYYYMMDD
                        ,SUM(QTY) AS QTY
                        ,ATTRIBUTE1
                        INTO #INTRANSIT
                  FROM (
                          SELECT                          
                                 @P_DIVISION_ID            AS DIVISION_ID
                                ,@P_PLAN_START_YYYYMMDD   AS PLAN_START_YYYYMMDD
                                ,@P_PLAN_TYPE             AS PLAN_TYPE 
                                ,@P_SEQ                   AS SEQ 
                                ,C.OPERATION_GROUP                        
                                ,A.ITEM_ID                        
                                ,(SUBSTRING(SITE_ID, 1, DBO.FN_CHARINDEX_REV(SITE_ID, '~', 0)-1))  AS TO_SITE   
                                ,(SUBSTRING(LOT_ID, DBO.FN_CHARINDEX_REV(LOT_ID, '::', 0)+2,100)) AS FROM_SITE   
                                ,CONVERT(NVARCHAR(8), A.RECEIVING_DTTM,112) AS YYYYMMDD                 
                                ,(A.QTY)         AS QTY        
                                ,'TH_ENG_STOCK_PLAN_SN'  AS  ATTRIBUTE1 
                            FROM DBO.TH_ENG_STOCK_PLAN_SN A WITH (NOLOCK)             
                            INNER JOIN DBO.SCP_MST_FINAL_ITEM_V C  WITH (NOLOCK)           
                               ON 0 = 0
                               AND A.ITEM_ID      = C.ITEM_ID                                               
                            WHERE 1 = 1         
                              AND A.MASTER_ID        = @p_master_id                    
                              AND A.PLAN_ID          = @p_engine_plan_id    
                              AND A.DESCR            = 'INT'       
                          ) X
                    GROUP BY DIVISION_ID 
                    ,PLAN_START_YYYYMMDD
                    ,PLAN_TYPE
                    ,SEQ
                    ,OPERATION_GROUP
                    ,ITEM_ID
                    ,TO_SITE
                    ,FROM_SITE
                    --,MEASURE
                    ,YYYYMMDD
                    ,ATTRIBUTE1
                    ;

			-- E20260331-000738 82사업부 MA Plan 수행 시 속도지연
			SET @v_log_message = N'########## into #INTRANSIT ##########';
			SET @v_description = @v_program_name + ':' + N'  into #INTRANSIT    ';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
									  ,@p_log_type      =  N'TXN'
									  ,@p_log_count     = 0       
									  ,@p_log_message   = @v_log_message       
									  ,@p_description   = @v_description       
									  ,@p_event_date    = @d_event_date       
									  ,@p_user_id       = @v_batch_user      
									  ; 

                 -- SEMI_INTRANSIT_ETA  --> SEMI_INTRANSIT,
                 -- INTRANSIT_ETA       --> INTRANSIT
                 
                 --UPDATE X
                 --   SET X.QTY = ISNULL(Y.QTY,0)
                 --  FROM #PSI_GLOBAL_ESS X  WITH (NOLOCK)
                 --  INNER JOIN #INTRANSIT Y  WITH (NOLOCK)
                 --     ON X.ITEM_ID    = Y.ITEM_ID                        
                 --    AND X.TO_SITE    = Y.TO_SITE   
                 --    AND X.FROM_SITE  = Y.FROM_SITE
                 --    AND X.YYYYMMDD   = Y.YYYYMMDD 
                 --    AND X.MEASURE    = 'INTRANSIT_ETA'


				MERGE INTO #PSI_GLOBAL_ESS AS X
				USING (SELECT A.DIVISION_ID
							,A.OPERATION_GROUP
							,''              AS CELL_ITEM_ID	
							,A.ITEM_ID
							,A.TO_SITE
							,'-'             AS PROJECT_CODE
							,0               AS TO_BOH_QTY
							,0               AS FROM_BOH_QTY
							--,A.INCOTERMS
							,A.FROM_SITE
							,'-'             AS TRANSPORT_MODE
							,'-'             AS PROD_LINE
							,'INTRANSIT_ETA' AS MEASURE
							,A.YYYYMMDD
							,SUM(QTY) AS QTY
							,B.SORT_ORDER_NO
							,B.COLUMN_LABEL_NAME
							,'-'            AS BOD_ID
							,'SCP_ANL_SHIPMENT_PLAN_FG'  AS ATTRIBUTE1
						FROM #INTRANSIT A WITH (NOLOCK),
						     (SELECT * FROM #MEASURE WITH (NOLOCK) WHERE COLUMN_NAME = 'INTRANSIT_ETA') B
					   WHERE 1 = 1
						GROUP BY A.DIVISION_ID
							,A.OPERATION_GROUP
							,A.ITEM_ID
							,A.TO_SITE
							--,A.INCOTERMS
							,A.FROM_SITE
							,A.YYYYMMDD
							,B.SORT_ORDER_NO
							,B.COLUMN_LABEL_NAME
				      ) AS Y
				ON  X.ITEM_ID    = Y.ITEM_ID  
                --AND X.INCOTERMS  = Y.INCOTERMS
                AND X.TO_SITE    = Y.TO_SITE   
                AND X.FROM_SITE  = Y.FROM_SITE
                AND X.YYYYMMDD   = Y.YYYYMMDD 
                AND X.MEASURE    = 'INTRANSIT_ETA'
				WHEN MATCHED  THEN
				UPDATE
				   SET X.QTY = ISNULL(Y.QTY,0)
				WHEN NOT MATCHED  THEN
				INSERT (
						 DIVISION_ID
						,OPERATION_GROUP
						,CELL_ITEM_ID	
						,ITEM_ID
						,TO_SITE
						,PROJECT_CODE
						,TO_BOH_QTY
						,FROM_BOH_QTY
						--,INCOTERMS
						,FROM_SITE
						,TRANSPORT_MODE
						,PROD_LINE
						,MEASURE
						,YYYYMMDD
						,QTY
						,SORT_ORDER_NO
						,COLUMN_LABEL_NAME
						,BOD_ID
						,ATTRIBUTE1
				       )
				VALUES (
						 Y.DIVISION_ID
						,Y.OPERATION_GROUP
						,Y.CELL_ITEM_ID	
						,Y.ITEM_ID
						,Y.TO_SITE
						,Y.PROJECT_CODE
						,Y.TO_BOH_QTY
						,Y.FROM_BOH_QTY
						--,Y.INCOTERMS
						,Y.FROM_SITE
						,Y.TRANSPORT_MODE
						,Y.PROD_LINE
						,Y.MEASURE
						,Y.YYYYMMDD
						,Y.QTY
						,Y.SORT_ORDER_NO
						,Y.COLUMN_LABEL_NAME
						,Y.BOD_ID
						,Y.ATTRIBUTE1
				       );

				IF @P_IS_DEBUG = 1 BEGIN SELECT '2388_PSI_GLOBAL' AS  "#PSI_GLOBAL_ESS" , * FROM #PSI_GLOBAL_ESS WHERE YYYYMMDD = @P_PLAN_START_YYYYMMDD END

			-- E20260331-000738 82사업부 MA Plan 수행 시 속도지연
			SET @v_log_message = N'########## merge into #PSI_GLOBAL_ESS ##########';
			SET @v_description = @v_program_name + ':' + N'  INTRANSIT_ETA    ';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
									  ,@p_log_type      =  N'TXN'
									  ,@p_log_count     = 0       
									  ,@p_log_message   = @v_log_message       
									  ,@p_description   = @v_description       
									  ,@p_event_date    = @d_event_date       
									  ,@p_user_id       = @v_batch_user      
									  ; 
				 
				MERGE INTO #PSI_GLOBAL_ESS AS X
				USING (SELECT A.DIVISION_ID
							,A.OPERATION_GROUP
							,''              AS CELL_ITEM_ID	
							,A.ITEM_ID
							,A.TO_SITE
							,'-'             AS PROJECT_CODE
							,0               AS TO_BOH_QTY
							,0               AS FROM_BOH_QTY
							,'-'             AS INCOTERMS
							,A.FROM_SITE
							,'-'             AS TRANSPORT_MODE
							,'-'             AS PROD_LINE
							,'SEMI_INTRANSIT_ETA' AS MEASURE
							,A.YYYYMMDD
							,SUM(QTY) AS QTY
							,B.SORT_ORDER_NO
							,B.COLUMN_LABEL_NAME
							,'-'            AS BOD_ID
							,'SCP_ANL_SHIPMENT_PLAN_SEMI'   AS ATTRIBUTE1
						FROM #INTRANSIT A WITH (NOLOCK),
						     (SELECT * FROM #MEASURE WITH (NOLOCK) WHERE COLUMN_NAME = 'SEMI_INTRANSIT_ETA') B
					   WHERE 1 = 1
						GROUP BY A.DIVISION_ID
							,A.OPERATION_GROUP
							,A.ITEM_ID
							,A.TO_SITE
							--,A.INCOTERMS
							,A.FROM_SITE
							,A.YYYYMMDD
							,B.SORT_ORDER_NO
							,B.COLUMN_LABEL_NAME
				      ) AS Y
				ON  X.ITEM_ID    = Y.ITEM_ID  
                AND X.TO_SITE    = Y.TO_SITE   
                AND X.FROM_SITE  = Y.FROM_SITE
                AND X.YYYYMMDD   = Y.YYYYMMDD 
                AND X.MEASURE    = 'SEMI_INTRANSIT_ETA' 
				WHEN MATCHED  THEN
				UPDATE
				   SET X.QTY = ISNULL(Y.QTY,0)
				WHEN NOT MATCHED  THEN
				INSERT (
						 DIVISION_ID
						,OPERATION_GROUP
						,CELL_ITEM_ID	
						,ITEM_ID
						,TO_SITE
						,PROJECT_CODE
						,TO_BOH_QTY
						,FROM_BOH_QTY
						,INCOTERMS
						,FROM_SITE
						,TRANSPORT_MODE
						,PROD_LINE
						,MEASURE
						,YYYYMMDD
						,QTY
						,SORT_ORDER_NO
						,COLUMN_LABEL_NAME
						,BOD_ID
						,ATTRIBUTE1
				       )
				VALUES (
						 Y.DIVISION_ID
						,Y.OPERATION_GROUP
						,Y.CELL_ITEM_ID	
						,Y.ITEM_ID
						,Y.TO_SITE
						,Y.PROJECT_CODE
						,Y.TO_BOH_QTY
						,Y.FROM_BOH_QTY
						,Y.INCOTERMS
						,Y.FROM_SITE
						,Y.TRANSPORT_MODE
						,Y.PROD_LINE
						,Y.MEASURE
						,Y.YYYYMMDD
						,Y.QTY
						,Y.SORT_ORDER_NO
						,Y.COLUMN_LABEL_NAME
						,Y.BOD_ID
						,Y.ATTRIBUTE1
				       );
					   
					   IF @P_IS_DEBUG = 1  SELECT '2476_PSI_GLOBAL' AS  "#PSI_GLOBAL_ESS" , * FROM #PSI_GLOBAL_ESS WHERE YYYYMMDD = @P_PLAN_START_YYYYMMDD 

			-- E20260331-000738 82사업부 MA Plan 수행 시 속도지연
			SET @v_log_message = N'########## merge into #PSI_GLOBAL_ESS ##########';
			SET @v_description = @v_program_name + ':' + N'  SEMI_INTRANSIT_ETA    ';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
									  ,@p_log_type      =  N'TXN'
									  ,@p_log_count     = 0       
									  ,@p_log_message   = @v_log_message       
									  ,@p_description   = @v_description       
									  ,@p_event_date    = @d_event_date       
									  ,@p_user_id       = @v_batch_user      
									  ; 


				MERGE INTO #PSI_GLOBAL_ESS AS X
				USING (SELECT A.DIVISION_ID
							,A.OPERATION_GROUP
							,''              AS CELL_ITEM_ID	
							,A.ITEM_ID
							,A.TO_SITE
							,'-'             AS PROJECT_CODE
							,0               AS TO_BOH_QTY
							,SUM(QTY)        AS FROM_BOH_QTY
							--,A.INCOTERMS
							,A.FROM_SITE
							,'-'             AS TRANSPORT_MODE
							,'-'             AS PROD_LINE
							,'INTRANSIT'     AS MEASURE
							,0               AS QTY
							,B.SORT_ORDER_NO
							,B.COLUMN_LABEL_NAME
							,'-'            AS BOD_ID
							,'SCP_ANL_SHIPMENT_PLAN_FG'  AS ATTRIBUTE1
						FROM #INTRANSIT A WITH (NOLOCK),
						     (SELECT * FROM #MEASURE WITH (NOLOCK) WHERE COLUMN_NAME = 'INTRANSIT') B
					   WHERE 1 = 1
						GROUP BY A.DIVISION_ID
							,A.OPERATION_GROUP
							,A.ITEM_ID
							,A.TO_SITE
							--,A.INCOTERMS
							,A.FROM_SITE
							,B.SORT_ORDER_NO
							,B.COLUMN_LABEL_NAME
				      ) AS Y
				ON  X.ITEM_ID    = Y.ITEM_ID  
                --AND X.INCOTERMS  = Y.INCOTERMS
                AND X.FROM_SITE  = Y.FROM_SITE
                AND X.TO_SITE    = Y.TO_SITE
                AND X.MEASURE    = 'INTRANSIT'
				WHEN MATCHED  THEN
				UPDATE
				   SET X.FROM_BOH_QTY = ISNULL(Y.FROM_BOH_QTY,0)
				WHEN NOT MATCHED  THEN
				INSERT (
						 DIVISION_ID
						,OPERATION_GROUP
						,CELL_ITEM_ID	
						,ITEM_ID
						,TO_SITE
						,PROJECT_CODE
						,TO_BOH_QTY
						,FROM_BOH_QTY
						--,INCOTERMS
						,FROM_SITE
						,TRANSPORT_MODE
						,PROD_LINE
						,MEASURE
						,YYYYMMDD
						,QTY
						,SORT_ORDER_NO
						,COLUMN_LABEL_NAME
						,BOD_ID
						,ATTRIBUTE1
				       )
				VALUES (
						 Y.DIVISION_ID
						,Y.OPERATION_GROUP
						,Y.CELL_ITEM_ID	
						,Y.ITEM_ID
						,Y.TO_SITE
						,Y.PROJECT_CODE
						,Y.TO_BOH_QTY
						,Y.FROM_BOH_QTY
						--,Y.INCOTERMS
						,Y.FROM_SITE
						,Y.TRANSPORT_MODE
						,Y.PROD_LINE
						,Y.MEASURE
						,@p_plan_start_yyyymmdd
						,Y.QTY
						,Y.SORT_ORDER_NO
						,Y.COLUMN_LABEL_NAME
						,Y.BOD_ID
						,Y.ATTRIBUTE1
				       );


				IF @P_IS_DEBUG = 1  SELECT '2562_PSI_GLOBAL' AS  "#PSI_GLOBAL_ESS" , * FROM #PSI_GLOBAL_ESS WHERE YYYYMMDD = @P_PLAN_START_YYYYMMDD 

			-- E20260331-000738 82사업부 MA Plan 수행 시 속도지연
			SET @v_log_message = N'########## merge into #PSI_GLOBAL_ESS ##########';
			SET @v_description = @v_program_name + ':' + N'  SCP_ANL_SHIPMENT_PLAN_FG INTRANSIT    ';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
									  ,@p_log_type      =  N'TXN'
									  ,@p_log_count     = 0       
									  ,@p_log_message   = @v_log_message       
									  ,@p_description   = @v_description       
									  ,@p_event_date    = @d_event_date       
									  ,@p_user_id       = @v_batch_user      
									  ; 


				MERGE INTO #PSI_GLOBAL_ESS AS X
				USING (SELECT A.DIVISION_ID
							,A.OPERATION_GROUP
							,''              AS CELL_ITEM_ID	
							,A.ITEM_ID
							,A.TO_SITE
							,'-'             AS PROJECT_CODE
							,0               AS TO_BOH_QTY
							,SUM(QTY)        AS FROM_BOH_QTY
							--,'-'             AS INCOTERMS
							,A.FROM_SITE
							,'-'             AS TRANSPORT_MODE
							,'-'             AS PROD_LINE
							,'SEMI_INTRANSIT'     AS MEASURE
							,0               AS QTY
							,B.SORT_ORDER_NO
							,B.COLUMN_LABEL_NAME
							,'-'            AS BOD_ID
							,'SCP_ANL_SHIPMENT_PLAN_SEMI'   AS ATTRIBUTE1
						FROM #INTRANSIT A WITH (NOLOCK),
						     (SELECT * FROM #MEASURE WITH (NOLOCK) WHERE COLUMN_NAME = 'SEMI_INTRANSIT') B
					   WHERE 1 = 1
						GROUP BY A.DIVISION_ID
							,A.OPERATION_GROUP
							,A.ITEM_ID
							,A.TO_SITE
							--,A.INCOTERMS
							,A.FROM_SITE
							,B.SORT_ORDER_NO
							,B.COLUMN_LABEL_NAME
				      ) AS Y
				ON  X.ITEM_ID    = Y.ITEM_ID  
                --AND X.INCOTERMS  = Y.INCOTERMS
                AND X.FROM_SITE  = Y.FROM_SITE
                AND X.TO_SITE    = Y.TO_SITE
                AND X.MEASURE    = 'SEMI_INTRANSIT'
				WHEN MATCHED  THEN
				UPDATE
				   SET X.FROM_BOH_QTY = ISNULL(Y.FROM_BOH_QTY,0)
				WHEN NOT MATCHED  THEN
				INSERT (
						 DIVISION_ID
						,OPERATION_GROUP
						,CELL_ITEM_ID	
						,ITEM_ID
						,TO_SITE
						,PROJECT_CODE
						,TO_BOH_QTY
						,FROM_BOH_QTY
						--,INCOTERMS
						,FROM_SITE
						,TRANSPORT_MODE
						,PROD_LINE
						,MEASURE
						,YYYYMMDD
						,QTY
						,SORT_ORDER_NO
						,COLUMN_LABEL_NAME
						,BOD_ID
						,ATTRIBUTE1
				       )
				VALUES (
						 Y.DIVISION_ID
						,Y.OPERATION_GROUP
						,Y.CELL_ITEM_ID	
						,Y.ITEM_ID
						,Y.TO_SITE
						,Y.PROJECT_CODE
						,Y.TO_BOH_QTY
						,Y.FROM_BOH_QTY
						--,Y.INCOTERMS
						,Y.FROM_SITE
						,Y.TRANSPORT_MODE
						,Y.PROD_LINE
						,Y.MEASURE
						,@p_plan_start_yyyymmdd
						,Y.QTY
						,Y.SORT_ORDER_NO
						,Y.COLUMN_LABEL_NAME
						,Y.BOD_ID
						,Y.ATTRIBUTE1
				       );



				IF @P_IS_DEBUG = 1  SELECT '2650_PSI_GLOBAL' AS  "#PSI_GLOBAL_ESS" , * FROM #PSI_GLOBAL_ESS WHERE YYYYMMDD = @P_PLAN_START_YYYYMMDD 

			-- E20260331-000738 82사업부 MA Plan 수행 시 속도지연
			SET @v_log_message = N'########## merge into #PSI_GLOBAL_ESS ##########';
			SET @v_description = @v_program_name + ':' + N'  SCP_ANL_SHIPMENT_PLAN_SEMI SEMI_INTRANSIT    ';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
									  ,@p_log_type      =  N'TXN'
									  ,@p_log_count     = 0       
									  ,@p_log_message   = @v_log_message       
									  ,@p_description   = @v_description       
									  ,@p_event_date    = @d_event_date       
									  ,@p_user_id       = @v_batch_user      
									  ; 


-- 20231114. SEMI_SHIP_PLAN이 없어 SEMI_WHIN이 누락되는 현상 발생.
-- SEMI_INTRANSIT_ETA가 있는 것에 한해서 강제로 생성함.

				INSERT INTO #PSI_GLOBAL_ESS
				SELECT A.DIVISION_ID, A.OPERATION_GROUP, A.CELL_ITEM_ID, A.ITEM_ID, A.TO_SITE, A.PROJECT_CODE
						, 0 AS TO_BOH_QTY 
						, 0 AS FROM_BOH_QTY
						, A.INCOTERMS, A.FROM_SITE, A.TRANSPORT_MODE, A.PROD_LINE
						, 'SEMI_WHIN' AS MEASURE
						, @p_plan_start_yyyymmdd AS YYYYMMDD
						, 0 AS QTY
						, 320 AS SORT_ORDER_NO
						, 'Semi WH In' AS COLUMN_LABEL_NAME
						, BOD_ID
						, 'SCP_ANL_SHIPMENT_PLAN_SEMI' AS ATTRIBUTE1
						, ATTRIBUTE9
				FROM #PSI_GLOBAL_ESS A WITH (NOLOCK)
				WHERE DIVISION_ID = @p_division_id
				AND   OPERATION_GROUP = 'A'
				AND   MEASURE = 'SEMI_INTRANSIT_ETA'
				AND   NOT EXISTS (
									SELECT *
									FROM #PSI_GLOBAL_ESS B WITH (NOLOCK)
									WHERE B.DIVISION_ID = @p_division_id
									AND   B.OPERATION_GROUP = 'A'
									AND   B.MEASURE = 'SEMI_WHIN' 
									AND   A.ITEM_ID = B.ITEM_ID
									AND   A.TO_SITE = B.TO_SITE
									AND   A.INCOTERMS = B.INCOTERMS
									AND   A.FROM_SITE = B.FROM_SITE
									AND   A.TRANSPORT_MODE = B.TRANSPORT_MODE
				)


			-- E20260331-000738 82사업부 MA Plan 수행 시 속도지연
			SET @v_log_message = N'########## merge into #PSI_GLOBAL_ESS ##########';
			SET @v_description = @v_program_name + ':' + N'  #PSI_GLOBAL_ESS Semi WH In    ';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
									  ,@p_log_type      =  N'TXN'
									  ,@p_log_count     = 0       
									  ,@p_log_message   = @v_log_message       
									  ,@p_description   = @v_description       
									  ,@p_event_date    = @d_event_date       
									  ,@p_user_id       = @v_batch_user      
									  ; 



---- 단위처리시간 추출 --
--print N'position_22 #PSI_GLOBAL_ESS temp 에 INTRANSIT update'
--print REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +     
--      REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))     
--set @v_start_time = SYSDATETIME();
---- 단위처리시간 추출 --


           -------------------------------------------------------------------------------------------------------------         
            -- CELL_FOR_FORM_END
            -------------------------------------------------------------------------------------------------------------  
            IF OBJECT_ID('tempdb..#PLN_TH_ENG_STOCK_PLAN') IS NOT NULL	
	                DROP TABLE #PLN_TH_ENG_STOCK_PLAN

              SELECT SUBSTRING(A.MASTER_ID,1,2) AS DIVISION_ID
                      --,SUBSTRING(A.SITE_ID, 1, CHARINDEX('~',A.SITE_ID)-1)  AS FROM_SITE
					  ,CASE WHEN CHARINDEX('~',A.SITE_ID) = 0 THEN A.SITE_ID ELSE SUBSTRING(A.SITE_ID, 1, CHARINDEX('~',A.SITE_ID)-1) END AS FROM_SITE   -- 2020-08-11 KSW ~ 없는 data 존재
                      ,A.ITEM_ID                                 
                      ,CONVERT(NVARCHAR, A.RECEIVING_DTTM,112)  AS YYYYMMDD
                      ,SUM(ISNULL(A.QTY,0))   AS QTY             
                      ,A.DESCR
                INTO #PLN_TH_ENG_STOCK_PLAN
                FROM SCP_PLN_TH_ENG_STOCK_PLAN A WITH(NOLOCK)                   
                 WHERE 1 = 1           
                  AND A.MASTER_ID   = @p_master_id                    
                  AND A.PLAN_ID     = @p_engine_plan_id                    
--                  AND A.LOT_ID LIKE 'FOR%'
                GROUP BY                     
                       SUBSTRING(A.MASTER_ID,1,2)                          
                      --,SUBSTRING(A.SITE_ID, 1, CHARINDEX('~',A.SITE_ID)-1)      
					  ,CASE WHEN CHARINDEX('~',A.SITE_ID) = 0 THEN A.SITE_ID ELSE SUBSTRING(A.SITE_ID, 1, CHARINDEX('~',A.SITE_ID)-1) END     -- 2020-08-11 KSW ~ 없는 data 존재
                      ,A.ITEM_ID                                 
                      , CONVERT(NVARCHAR, A.RECEIVING_DTTM,112)   
                      , DESCR


			-- E20260331-000738 82사업부 MA Plan 수행 시 속도지연
			SET @v_log_message = N'########## into #PLN_TH_ENG_STOCK_PLAN ##########';
			SET @v_description = @v_program_name + ':' + N'  from SCP_PLN_TH_ENG_STOCK_PLAN Semi WH In    ';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
									  ,@p_log_type      =  N'TXN'
									  ,@p_log_count     = 0       
									  ,@p_log_message   = @v_log_message       
									  ,@p_description   = @v_description       
									  ,@p_event_date    = @d_event_date       
									  ,@p_user_id       = @v_batch_user      
									  ; 


                 --UPDATE X
                 --   SET X.QTY = ISNULL(Z.QTY,0)
                 --  FROM #PSI_GLOBAL_ESS X  WITH (NOLOCK)
                 --  INNER JOIN (SELECT ITEM_ID,FROM_SITE,YYYYMMDD, SUM(Y.QTY) AS QTY
                 --               FROM #PLN_TH_ENG_STOCK_PLAN Y WITH (NOLOCK)
                 --              WHERE DESCR LIKE 'FOR%'
                 --              GROUP BY ITEM_ID,FROM_SITE,YYYYMMDD
                 --             ) Z  
                 --     ON X.ITEM_ID    = Z.ITEM_ID                        
                 --    AND X.FROM_SITE  = Z.FROM_SITE
                 --    AND X.YYYYMMDD   = Z.YYYYMMDD 
                 --    AND X.MEASURE    = 'CELL_FOR_FORM_END'

				MERGE INTO #PSI_GLOBAL_ESS AS X
				USING (SELECT @p_division_id AS DIVISION_ID
							,'A'             AS OPERATION_GROUP
							,A.ITEM_ID
							,'-'             AS TO_SITE
							,'-'             AS PROJECT_CODE
							,0               AS TO_BOH_QTY
							,0               AS FROM_BOH_QTY
							,'-'             AS INCOTERMS
							,A.FROM_SITE
							,'-'             AS TRANSPORT_MODE
							,'-'             AS PROD_LINE
							,'CELL_FOR_FORM_END' AS MEASURE
							,A.YYYYMMDD
							,ISNULL(A.QTY,0) AS QTY
							,B.SORT_ORDER_NO
							,B.COLUMN_LABEL_NAME
							,'-'            AS BOD_ID
							,''        AS ATTRIBUTE1			-- 중복방지
							,''        AS ATTRIBUTE9			-- 중복방지
						FROM (SELECT ITEM_ID, FROM_SITE, YYYYMMDD, SUM(Y.QTY) AS QTY
                                FROM #PLN_TH_ENG_STOCK_PLAN Y WITH (NOLOCK)
                               WHERE DESCR LIKE 'FOR%'
                               GROUP BY ITEM_ID,FROM_SITE,YYYYMMDD
							 ) A,
						     (SELECT * FROM #MEASURE WITH (NOLOCK) WHERE COLUMN_NAME = 'CELL_FOR_FORM_END') B
				      ) AS Y
				ON  X.ITEM_ID    = Y.ITEM_ID  
                AND X.FROM_SITE  = Y.FROM_SITE
                AND X.YYYYMMDD   = Y.YYYYMMDD 
                AND X.MEASURE    = 'CELL_FOR_FORM_END'
				WHEN MATCHED  THEN
				UPDATE
				   SET X.QTY = ISNULL(Y.QTY,0)
				WHEN NOT MATCHED  THEN
				INSERT (
						 DIVISION_ID
						,OPERATION_GROUP	
						,ITEM_ID
						,TO_SITE
						,PROJECT_CODE
						,TO_BOH_QTY
						,FROM_BOH_QTY
						,INCOTERMS
						,FROM_SITE
						,TRANSPORT_MODE
						,PROD_LINE
						,MEASURE
						,YYYYMMDD
						,QTY
						,SORT_ORDER_NO
						,COLUMN_LABEL_NAME
						,BOD_ID
						,ATTRIBUTE1
						,ATTRIBUTE9
				       )
				VALUES (
						 Y.DIVISION_ID
						,Y.OPERATION_GROUP
						,Y.ITEM_ID
						,Y.TO_SITE
						,Y.PROJECT_CODE
						,Y.TO_BOH_QTY
						,Y.FROM_BOH_QTY
						,Y.INCOTERMS
						,Y.FROM_SITE
						,Y.TRANSPORT_MODE
						,Y.PROD_LINE
						,Y.MEASURE
						,Y.YYYYMMDD
						,Y.QTY
						,Y.SORT_ORDER_NO
						,Y.COLUMN_LABEL_NAME
						,Y.BOD_ID
						,Y.ATTRIBUTE1
						,Y.ATTRIBUTE9
				       );


				UPDATE #PSI_GLOBAL_ESS
				   SET ATTRIBUTE1 = '',
				       ATTRIBUTE9 = ''
				 WHERE MEASURE    = 'CELL_FOR_FORM_END'
				   ;

				IF @P_IS_DEBUG = 1 BEGIN SELECT '2822_PSI_GLOBAL' AS  "#PSI_GLOBAL_ESS" , * FROM #PSI_GLOBAL_ESS WHERE YYYYMMDD = @P_PLAN_START_YYYYMMDD END

			-- E20260331-000738 82사업부 MA Plan 수행 시 속도지연
			SET @v_log_message = N'########## merge into ##PSI_GLOBAL_ESS ##########';
			SET @v_description = @v_program_name + ':' + N'  measure CELL_FOR_FORM_END ';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
									  ,@p_log_type      =  N'TXN'
									  ,@p_log_count     = 0       
									  ,@p_log_message   = @v_log_message       
									  ,@p_description   = @v_description       
									  ,@p_event_date    = @d_event_date       
									  ,@p_user_id       = @v_batch_user      
									  ; 
				
---- 단위처리시간 추출 --
--print N'position_23 #PSI_GLOBAL_ESS temp 에 CELL_FOR_FORM_END update'
--print REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +     
--      REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))     
--set @v_start_time = SYSDATETIME();
---- 단위처리시간 추출 --


            -------------------------------------------------------------------------------------------------------------         
            -- CELL_FORM_PROGRESS 
            -------------------------------------------------------------------------------------------------------------  

--                 UPDATE X
--                    SET X.FROM_BOH_QTY = Z.FROM_BOH_QTY
--                   FROM #PSI_GLOBAL_ESS X  WITH (NOLOCK)
--                   INNER JOIN (SELECT ITEM_ID, FROM_SITE, SUM(Y.QTY) AS FROM_BOH_QTY
--                                 FROM #PLN_TH_ENG_STOCK_PLAN Y  WITH (NOLOCK)
--                                WHERE DESCR ='FOR'
----                                WHERE YYYYMMDD = @p_plan_start_yyyymmdd
--                                GROUP BY ITEM_ID, FROM_SITE
--                             )  Z 
--                      ON X.ITEM_ID    = Z.ITEM_ID                        
--                     AND X.FROM_SITE  = Z.FROM_SITE
--                     AND X.MEASURE    = 'CELL_FORM_PROGRESS'


				MERGE INTO #PSI_GLOBAL_ESS AS X
				USING (SELECT @p_division_id AS DIVISION_ID
							,'A'             AS OPERATION_GROUP
							,A.ITEM_ID
							,'-'             AS TO_SITE
							,'-'             AS PROJECT_CODE
							,0               AS TO_BOH_QTY
							,A.FROM_BOH_QTY
							,'-'             AS INCOTERMS
							,A.FROM_SITE
							,'-'             AS TRANSPORT_MODE
							,'-'             AS PROD_LINE
							,'CELL_FORM_PROGRESS' AS MEASURE
							,0               AS QTY
							,B.SORT_ORDER_NO
							,B.COLUMN_LABEL_NAME
							,'-'             AS BOD_ID
						FROM (SELECT ITEM_ID, FROM_SITE, SUM(Y.QTY) AS FROM_BOH_QTY
                                 FROM #PLN_TH_ENG_STOCK_PLAN Y  WITH (NOLOCK)
                                WHERE DESCR ='FOR'
--                                WHERE YYYYMMDD = @p_plan_start_yyyymmdd
                                GROUP BY ITEM_ID, FROM_SITE
							 ) A,
						     (SELECT * FROM #MEASURE WITH (NOLOCK) WHERE COLUMN_NAME = 'CELL_FORM_PROGRESS') B
				      ) AS Y
			    -- 누락버그수정 :: 2023.07.02, KSK
				ON  X.DIVISION_ID = Y.DIVISION_ID
				AND X.ITEM_ID    = Y.ITEM_ID  
                AND X.FROM_SITE  = Y.FROM_SITE
                AND X.MEASURE    = 'CELL_FORM_PROGRESS'
				WHEN MATCHED  THEN
				UPDATE
				   SET X.FROM_BOH_QTY = ISNULL(Y.FROM_BOH_QTY,0)
				WHEN NOT MATCHED  THEN
				INSERT (
						 DIVISION_ID
						,OPERATION_GROUP	
						,ITEM_ID
						,TO_SITE
						,PROJECT_CODE
						,TO_BOH_QTY
						,FROM_BOH_QTY
						,INCOTERMS
						,FROM_SITE
						,TRANSPORT_MODE
						,PROD_LINE
						,MEASURE
						,YYYYMMDD
						,QTY
						,SORT_ORDER_NO
						,COLUMN_LABEL_NAME
						,BOD_ID
				       )
				VALUES (
						 Y.DIVISION_ID
						,Y.OPERATION_GROUP
						,Y.ITEM_ID
						,Y.TO_SITE
						,Y.PROJECT_CODE
						,Y.TO_BOH_QTY
						,Y.FROM_BOH_QTY
						,Y.INCOTERMS
						,Y.FROM_SITE
						,Y.TRANSPORT_MODE
						,Y.PROD_LINE
						,Y.MEASURE
						,@p_plan_start_yyyymmdd
						,Y.QTY
						,Y.SORT_ORDER_NO
						,Y.COLUMN_LABEL_NAME
						,Y.BOD_ID
				       );

			-- E20260331-000738 82사업부 MA Plan 수행 시 속도지연
			SET @v_log_message = N'########## merge into #PSI_GLOBAL_ESS ##########';
			SET @v_description = @v_program_name + ':' + N'  measure CELL_FORM_PROGRESS ';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
									  ,@p_log_type      =  N'TXN'
									  ,@p_log_count     = 0       
									  ,@p_log_message   = @v_log_message       
									  ,@p_description   = @v_description       
									  ,@p_event_date    = @d_event_date       
									  ,@p_user_id       = @v_batch_user      
									  ; 

---- 단위처리시간 추출 --
--print N'position_24 #PSI_GLOBAL_ESS temp 에 CELL_FORM_PROGRESS update'
--print REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +     
--      REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))     
--set @v_start_time = SYSDATETIME();
---- 단위처리시간 추출 --


            -------------------------------------------------------------------------------------------------------------         
            -- CELL_FORM_HOLD_UNDER 추가  
            -- [전지 공급 대응력 향상을 위한 RTF 적확도 개선] : GSCM 시스템의 보류재고 감안한 계획 수립을 위한 시뮬레이션 변경 요청(자동차, ESS)
            ------------------------------------------------------------------------------------------------------------- 

            IF OBJECT_ID('tempdb..#tmp_SCM_DNM_STOCK_AGING_V') IS NOT NULL	
	                DROP TABLE #tmp_SCM_DNM_STOCK_AGING_V

            SELECT SCM_SITE_ID AS FROM_SITE, ITEM_ID
                  ,(CASE WHEN UNHOLD_EXP_DATE <= @p_plan_start_yyyymmdd THEN @p_plan_start_yyyymmdd ELSE CONVERT(NVARCHAR, UNHOLD_EXP_DATE,112) END ) AS YYYYMMDD
	                ,SUM(QTY) AS QTY
              INTO  #tmp_SCM_DNM_STOCK_AGING_V
              FROM   SCM_DNM_STOCK_AGING_V WITH(NOLOCK)
              WHERE  CUTOFF_DATE = @p_cutoff_date
              AND  WIPHOLD_YN = 'Y'
              AND  UNHOLD_EXP_DATE                 IS NOT NULL
              GROUP BY SCM_SITE_ID,ITEM_ID
                  ,(CASE WHEN UNHOLD_EXP_DATE <= @p_plan_start_yyyymmdd THEN @p_plan_start_yyyymmdd ELSE CONVERT(NVARCHAR, UNHOLD_EXP_DATE,112) END )


			-- E20260331-000738 82사업부 MA Plan 수행 시 속도지연
			SET @v_log_message = N'########## into #tmp_SCM_DNM_STOCK_AGING_V ##########';
			SET @v_description = @v_program_name + ':' + N'  measure CELL_FORM_PROGRESS ';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
									  ,@p_log_type      =  N'TXN'
									  ,@p_log_count     = 0       
									  ,@p_log_message   = @v_log_message       
									  ,@p_description   = @v_description       
									  ,@p_event_date    = @d_event_date       
									  ,@p_user_id       = @v_batch_user      
									  ; 

                 --UPDATE X
                 --   SET X.QTY = Z.QTY
                 --  FROM #PSI_GLOBAL_ESS X  WITH (NOLOCK)
                 --  INNER JOIN #tmp_SCM_DNM_STOCK_AGING_V  Z 
                 --     ON X.ITEM_ID    = Z.ITEM_ID                        
                 --    AND X.FROM_SITE  = Z.FROM_SITE
                 --    AND X.YYYYMMDD   = Z.YYYYMMDD
                 --    AND X.MEASURE    = 'CELL_FORM_HOLD_UNDER'

				MERGE INTO #PSI_GLOBAL_ESS AS X
				USING (SELECT @p_division_id AS DIVISION_ID
							,'A'             AS OPERATION_GROUP
							,A.ITEM_ID
							,'-'             AS TO_SITE
							,'-'             AS PROJECT_CODE
							,0               AS TO_BOH_QTY
							,0               AS FROM_BOH_QTY
							,'-'             AS INCOTERMS
							,A.FROM_SITE
							,'-'             AS TRANSPORT_MODE
							,'-'             AS PROD_LINE
							,'CELL_FORM_HOLD_UNDER' AS MEASURE
							,A.YYYYMMDD
							,ISNULL(A.QTY,0) AS QTY
							,B.SORT_ORDER_NO
							,B.COLUMN_LABEL_NAME
							,'-'            AS BOD_ID
							,'SCP_PLN_PRODUCTION_PLAN'        AS ATTRIBUTE1			-- 중복방지
							,'F6000'                          AS ATTRIBUTE9			-- 중복방지
						FROM #tmp_SCM_DNM_STOCK_AGING_V A  WITH (NOLOCK),
						     (SELECT * FROM #MEASURE WITH (NOLOCK) WHERE COLUMN_NAME = 'CELL_FORM_HOLD_UNDER') B
					   WHERE A.FROM_SITE IS NOT NULL
				      ) AS Y
				ON  X.ITEM_ID    = Y.ITEM_ID  
                AND X.FROM_SITE  = Y.FROM_SITE
                AND X.YYYYMMDD   = Y.YYYYMMDD
                AND X.MEASURE    = 'CELL_FORM_HOLD_UNDER'
				WHEN MATCHED  THEN
				UPDATE
				   SET X.QTY        = ISNULL(Y.QTY,0)
				WHEN NOT MATCHED  THEN
				INSERT (
						 DIVISION_ID
						,OPERATION_GROUP	
						,ITEM_ID
						,TO_SITE
						,PROJECT_CODE
						,TO_BOH_QTY
						,FROM_BOH_QTY
						,INCOTERMS
						,FROM_SITE
						,TRANSPORT_MODE
						,PROD_LINE
						,MEASURE
						,YYYYMMDD
						,QTY
						,SORT_ORDER_NO
						,COLUMN_LABEL_NAME
						,BOD_ID
						,ATTRIBUTE1
						,ATTRIBUTE9
				       )
				VALUES (
						 Y.DIVISION_ID
						,Y.OPERATION_GROUP
						,Y.ITEM_ID
						,Y.TO_SITE
						,Y.PROJECT_CODE
						,Y.TO_BOH_QTY
						,Y.FROM_BOH_QTY
						,Y.INCOTERMS
						,Y.FROM_SITE
						,Y.TRANSPORT_MODE
						,Y.PROD_LINE
						,Y.MEASURE
						,Y.YYYYMMDD
						,Y.QTY
						,Y.SORT_ORDER_NO
						,Y.COLUMN_LABEL_NAME
						,Y.BOD_ID
						,Y.ATTRIBUTE1
						,Y.ATTRIBUTE9
				       );

				IF @P_IS_DEBUG = 1 BEGIN SELECT '3037_PSI_GLOBAL' AS  "#PSI_GLOBAL_ESS" , * FROM #PSI_GLOBAL_ESS WHERE YYYYMMDD = @P_PLAN_START_YYYYMMDD END


				UPDATE #PSI_GLOBAL_ESS
				   SET ATTRIBUTE1 = 'SCP_PLN_PRODUCTION_PLAN',
				       ATTRIBUTE9 = 'F6000'
				 WHERE MEASURE    = 'CELL_FORM_HOLD_UNDER'
				   AND ISNULL(ATTRIBUTE1, '') = '' OR ISNULL(ATTRIBUTE9, '') = ''
				   ;


			-- E20260331-000738 82사업부 MA Plan 수행 시 속도지연
			SET @v_log_message = N'########## into #PSI_GLOBAL_ESS  ##########';
			SET @v_description = @v_program_name + ':' + N'  from #tmp_SCM_DNM_STOCK_AGING_V ';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
									  ,@p_log_type      =  N'TXN'
									  ,@p_log_count     = 0       
									  ,@p_log_message   = @v_log_message       
									  ,@p_description   = @v_description       
									  ,@p_event_date    = @d_event_date       
									  ,@p_user_id       = @v_batch_user      
									  ; 


                  -- BOH

                 
                 -- 보류중 해제일자가 없는수량
                  --UPDATE X
                  --  SET X.FROM_BOH_QTY = Z.QTY
                  -- FROM #PSI_GLOBAL_ESS X  WITH (NOLOCK)
                  -- INNER JOIN (SELECT FROM_SITE, ITEM_ID, SUM(Y.QTY) AS QTY
                  --               FROM #PLN_TH_ENG_STOCK_PLAN Y  WITH (NOLOCK)
                  --              WHERE DESCR ='FOR_HOLD'
                  --              GROUP BY FROM_SITE, ITEM_ID
                  --           )  Z 
                  --    ON X.ITEM_ID    = Z.ITEM_ID      
                  --   AND X.FROM_SITE  = Z.FROM_SITE
                  --   AND X.MEASURE    = 'CELL_FORM_HOLD_UNDER'


				MERGE INTO #PSI_GLOBAL_ESS AS X
				USING (SELECT @p_division_id AS DIVISION_ID
							,'A'             AS OPERATION_GROUP
							,A.ITEM_ID
							,'-'             AS TO_SITE
							,'-'             AS PROJECT_CODE
							,0               AS TO_BOH_QTY
							,A.FROM_BOH_QTY
							,'-'             AS INCOTERMS
							,A.FROM_SITE
							,'-'             AS TRANSPORT_MODE
							,'-'             AS PROD_LINE
							,'CELL_FORM_HOLD_UNDER' AS MEASURE
							,0               AS QTY
							,B.SORT_ORDER_NO
							,B.COLUMN_LABEL_NAME
							,'-'            AS BOD_ID
						FROM (SELECT FROM_SITE, ITEM_ID, SUM(Y.QTY) AS FROM_BOH_QTY
                                 FROM #PLN_TH_ENG_STOCK_PLAN Y  WITH (NOLOCK)
                                WHERE DESCR ='FOR_HOLD'
                                GROUP BY FROM_SITE, ITEM_ID
							 ) A,
						     (SELECT * FROM #MEASURE WITH (NOLOCK) WHERE COLUMN_NAME = 'CELL_FORM_HOLD_UNDER') B
				      ) AS Y
				ON  X.ITEM_ID    = Y.ITEM_ID  
                AND X.FROM_SITE  = Y.FROM_SITE
                AND X.MEASURE    = 'CELL_FORM_HOLD_UNDER'
				WHEN MATCHED  THEN
				UPDATE
				   SET X.FROM_BOH_QTY = ISNULL(Y.FROM_BOH_QTY,0)
				WHEN NOT MATCHED  THEN
				INSERT (
						 DIVISION_ID
						,OPERATION_GROUP	
						,ITEM_ID
						,TO_SITE
						,PROJECT_CODE
						,TO_BOH_QTY
						,FROM_BOH_QTY
						,INCOTERMS
						,FROM_SITE
						,TRANSPORT_MODE
						,PROD_LINE
						,MEASURE
						,YYYYMMDD
						,QTY
						,SORT_ORDER_NO
						,COLUMN_LABEL_NAME
						,BOD_ID
				       )
				VALUES (
						 Y.DIVISION_ID
						,Y.OPERATION_GROUP
						,Y.ITEM_ID
						,Y.TO_SITE
						,Y.PROJECT_CODE
						,Y.TO_BOH_QTY
						,Y.FROM_BOH_QTY
						,Y.INCOTERMS
						,Y.FROM_SITE
						,Y.TRANSPORT_MODE
						,Y.PROD_LINE
						,Y.MEASURE
						,@p_plan_start_yyyymmdd
						,Y.QTY
						,Y.SORT_ORDER_NO
						,Y.COLUMN_LABEL_NAME
						,Y.BOD_ID
				       );

					   IF @P_IS_DEBUG = 1 BEGIN SELECT '3137_PSI_GLOBAL' AS  "#PSI_GLOBAL_ESS" , * FROM #PSI_GLOBAL_ESS WHERE YYYYMMDD = @P_PLAN_START_YYYYMMDD END


			-- E20260331-000738 82사업부 MA Plan 수행 시 속도지연
			SET @v_log_message = N'########## into #PSI_GLOBAL_ESS  ##########';
			SET @v_description = @v_program_name + ':' + N'  from CELL_FORM_HOLD_UNDER ';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
									  ,@p_log_type      =  N'TXN'
									  ,@p_log_count     = 0       
									  ,@p_log_message   = @v_log_message       
									  ,@p_description   = @v_description       
									  ,@p_event_date    = @d_event_date       
									  ,@p_user_id       = @v_batch_user      
									  ; 


                  -- 보류중 해제일자가 없는수량
                      -- BOH
                  --UPDATE X
                  --  SET X.FROM_BOH_QTY = X.FROM_BOH_QTY - Z.QTY
                  -- FROM #PSI_GLOBAL_ESS X  WITH (NOLOCK)
                  -- INNER JOIN ( 
                  --           SELECT FROM_SITE, ITEM_ID, SUM(Y.QTY) AS QTY
                  --               FROM #tmp_SCM_DNM_STOCK_AGING_V Y  WITH (NOLOCK)
                  --              GROUP BY FROM_SITE, ITEM_ID
                  --              ) Z 
                  --    ON X.ITEM_ID    = Z.ITEM_ID      
                  --   AND X.FROM_SITE  = Z.FROM_SITE
                  --   AND X.MEASURE    = 'CELL_FORM_HOLD_UNDER'

				MERGE INTO #PSI_GLOBAL_ESS AS X
				USING (SELECT @p_division_id AS DIVISION_ID
							,'A'             AS OPERATION_GROUP
							,A.ITEM_ID
							,'-'             AS TO_SITE
							,'-'             AS PROJECT_CODE
							,0               AS TO_BOH_QTY
							,ISNULL(A.QTY,0) AS FROM_BOH_QTY
							,'-'             AS INCOTERMS
							,A.FROM_SITE
							,'-'             AS TRANSPORT_MODE
							,'-'             AS PROD_LINE
							,'CELL_FORM_HOLD_UNDER' AS MEASURE
							,0               AS QTY
							,B.SORT_ORDER_NO
							,B.COLUMN_LABEL_NAME
							,'-'            AS BOD_ID
						FROM (SELECT FROM_SITE, ITEM_ID, SUM(Y.QTY) AS QTY
                                 FROM #tmp_SCM_DNM_STOCK_AGING_V Y  WITH (NOLOCK)
                                GROUP BY FROM_SITE, ITEM_ID) A,
						     (SELECT * FROM #MEASURE WITH (NOLOCK) WHERE COLUMN_NAME = 'CELL_FORM_HOLD_UNDER') B
					   WHERE A.FROM_SITE IS NOT NULL
				      ) AS Y
				ON  X.ITEM_ID    = Y.ITEM_ID  
                AND X.FROM_SITE  = Y.FROM_SITE
                AND X.MEASURE    = 'CELL_FORM_HOLD_UNDER'
				WHEN MATCHED  THEN
				UPDATE
				   SET X.FROM_BOH_QTY = X.FROM_BOH_QTY - Y.FROM_BOH_QTY
				WHEN NOT MATCHED  THEN
				INSERT (
						 DIVISION_ID
						,OPERATION_GROUP	
						,ITEM_ID
						,TO_SITE
						,PROJECT_CODE
						,TO_BOH_QTY
						,FROM_BOH_QTY
						,INCOTERMS
						,FROM_SITE
						,TRANSPORT_MODE
						,PROD_LINE
						,MEASURE
						,YYYYMMDD
						,QTY
						,SORT_ORDER_NO
						,COLUMN_LABEL_NAME
						,BOD_ID
				       )
				VALUES (
						 Y.DIVISION_ID
						,Y.OPERATION_GROUP
						,Y.ITEM_ID
						,Y.TO_SITE
						,Y.PROJECT_CODE
						,Y.TO_BOH_QTY
						,Y.FROM_BOH_QTY
						,Y.INCOTERMS
						,Y.FROM_SITE
						,Y.TRANSPORT_MODE
						,Y.PROD_LINE
						,Y.MEASURE
						,@p_plan_start_yyyymmdd
						,Y.QTY
						,Y.SORT_ORDER_NO
						,Y.COLUMN_LABEL_NAME
						,Y.BOD_ID
				       );

                   IF @P_IS_DEBUG = 1 BEGIN SELECT '3222_PSI_GLOBAL' AS  "#PSI_GLOBAL_ESS" , * FROM #PSI_GLOBAL_ESS WHERE YYYYMMDD = @P_PLAN_START_YYYYMMDD END


			-- E20260331-000738 82사업부 MA Plan 수행 시 속도지연
			SET @v_log_message = N'########## into #PSI_GLOBAL_ESS  ##########';
			SET @v_description = @v_program_name + ':' + N'  measure CELL_FORM_HOLD_UNDER ';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
									  ,@p_log_type      =  N'TXN'
									  ,@p_log_count     = 0       
									  ,@p_log_message   = @v_log_message       
									  ,@p_description   = @v_description       
									  ,@p_event_date    = @d_event_date       
									  ,@p_user_id       = @v_batch_user      
									  ; 

---- 단위처리시간 추출 --
--print N'position_25 #PSI_GLOBAL_ESS temp 에 hold 재고 update'
--print REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +     
--      REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))     
--set @v_start_time = SYSDATETIME();
---- 단위처리시간 추출 --


                  
            IF OBJECT_ID('tempdb..#tmp_SCM_DNM_STOCK_AGING_V2') IS NOT NULL	
	                DROP TABLE #tmp_SCM_DNM_STOCK_AGING_V2

                   SELECT SCM_SITE_ID AS FROM_SITE, ITEM_ID
                  ,(CASE WHEN AVAILABLE_DATE <= @p_plan_start_yyyymmdd THEN @p_plan_start_yyyymmdd ELSE CONVERT(NVARCHAR, AVAILABLE_DATE,112) END ) AS YYYYMMDD
	                ,SUM(QTY) AS QTY
                  INTO  #tmp_SCM_DNM_STOCK_AGING_V2
                  FROM   SCM_DNM_STOCK_AGING_V WITH(NOLOCK)
                  WHERE  CUTOFF_DATE = @p_cutoff_date
                  AND  WIPHOLD_YN = 'Y'
                  --AND  UNHOLD_EXP_DATE                 IS NOT NULL
                  GROUP BY SCM_SITE_ID,ITEM_ID
                      ,(CASE WHEN AVAILABLE_DATE <= @p_plan_start_yyyymmdd THEN @p_plan_start_yyyymmdd ELSE CONVERT(NVARCHAR, AVAILABLE_DATE,112) END )


			-- E20260331-000738 82사업부 MA Plan 수행 시 속도지연
			SET @v_log_message = N'########## into #tmp_SCM_DNM_STOCK_AGING_V2  ##########';
			SET @v_description = @v_program_name + ':' + N'  from SCM_DNM_STOCK_AGING_V ';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
									  ,@p_log_type      =  N'TXN'
									  ,@p_log_count     = 0       
									  ,@p_log_message   = @v_log_message       
									  ,@p_description   = @v_description       
									  ,@p_event_date    = @d_event_date       
									  ,@p_user_id       = @v_batch_user      
									  ; 

                  --aging에서 hold 수량중 available_date or 예상해제일 늦은날짜 기준
                  --UPDATE X
                  --  SET X.QTY = Z.QTY
                  -- FROM #PSI_GLOBAL_ESS X  WITH (NOLOCK)
                  -- INNER JOIN (SELECT ITEM_ID, FROM_SITE, SUM(Y.QTY) AS QTY, Y.YYYYMMDD
                  --               FROM #tmp_SCM_DNM_STOCK_AGING_V2 Y  WITH (NOLOCK)
                  --              WHERE 0 = 0 
                  --              --AND DESCR ='WH_HOLD'
                  --              GROUP BY ITEM_ID,FROM_SITE,Y.YYYYMMDD
                  --           )  Z 
                  --    ON X.ITEM_ID    = Z.ITEM_ID       
                  --   AND X.FROM_SITE  = Z.FROM_SITE
                  --   AND X.YYYYMMDD   = Z.YYYYMMDD
                  --   AND X.MEASURE    = 'CELL_FORM_HOLD_UNDER_AVAILABLE'

				MERGE INTO #PSI_GLOBAL_ESS AS X
				USING (SELECT @p_division_id AS DIVISION_ID
							,'A'             AS OPERATION_GROUP
							,A.ITEM_ID
							,'-'             AS TO_SITE
							,'-'             AS PROJECT_CODE
							,0               AS TO_BOH_QTY
							,0               AS FROM_BOH_QTY
							,'-'             AS INCOTERMS
							,A.FROM_SITE
							,'-'             AS TRANSPORT_MODE
							,'-'             AS PROD_LINE
							,'CELL_FORM_HOLD_UNDER_AVAILABLE' AS MEASURE
							,A.YYYYMMDD
							,ISNULL(A.QTY,0) AS QTY
							,B.SORT_ORDER_NO
							,B.COLUMN_LABEL_NAME
							,'-'            AS BOD_ID
							,'SCP_PLN_PRODUCTION_PLAN'        AS ATTRIBUTE1			-- 중복방지
							,'F6000'                          AS ATTRIBUTE9			-- 중복방지
						FROM (SELECT ITEM_ID, FROM_SITE, SUM(Y.QTY) AS QTY, Y.YYYYMMDD
                                 FROM #tmp_SCM_DNM_STOCK_AGING_V2 Y  WITH (NOLOCK)
                                WHERE 0 = 0 
                                --AND DESCR ='WH_HOLD'
                                GROUP BY ITEM_ID,FROM_SITE,Y.YYYYMMDD
                             )  A,
						     (SELECT * FROM #MEASURE WITH (NOLOCK) WHERE COLUMN_NAME = 'CELL_FORM_HOLD_UNDER_AVAILABLE') B
					   WHERE A.FROM_SITE IS NOT NULL
				      ) AS Y
				ON  X.ITEM_ID    = Y.ITEM_ID  
                AND X.FROM_SITE  = Y.FROM_SITE
                AND X.YYYYMMDD   = Y.YYYYMMDD
                AND X.MEASURE    = 'CELL_FORM_HOLD_UNDER_AVAILABLE'
				WHEN MATCHED  THEN
				UPDATE
				   SET X.QTY        = ISNULL(Y.QTY,0)
				WHEN NOT MATCHED  THEN
				INSERT (
						 DIVISION_ID
						,OPERATION_GROUP	
						,ITEM_ID
						,TO_SITE
						,PROJECT_CODE
						,TO_BOH_QTY
						,FROM_BOH_QTY
						,INCOTERMS
						,FROM_SITE
						,TRANSPORT_MODE
						,PROD_LINE
						,MEASURE
						,YYYYMMDD
						,QTY
						,SORT_ORDER_NO
						,COLUMN_LABEL_NAME
						,BOD_ID
						,ATTRIBUTE1
						,ATTRIBUTE9
				       )
				VALUES (
						 Y.DIVISION_ID
						,Y.OPERATION_GROUP
						,Y.ITEM_ID
						,Y.TO_SITE
						,Y.PROJECT_CODE
						,Y.TO_BOH_QTY
						,Y.FROM_BOH_QTY
						,Y.INCOTERMS
						,Y.FROM_SITE
						,Y.TRANSPORT_MODE
						,Y.PROD_LINE
						,Y.MEASURE
						,Y.YYYYMMDD
						,Y.QTY
						,Y.SORT_ORDER_NO
						,Y.COLUMN_LABEL_NAME
						,Y.BOD_ID
						,Y.ATTRIBUTE1
						,Y.ATTRIBUTE9
				       );

				IF @P_IS_DEBUG = 1 BEGIN SELECT '3242_PSI_GLOBAL' AS  "#PSI_GLOBAL_ESS" , * FROM #PSI_GLOBAL_ESS WHERE YYYYMMDD = @P_PLAN_START_YYYYMMDD END

				UPDATE #PSI_GLOBAL_ESS
				   SET ATTRIBUTE1 = 'SCP_PLN_PRODUCTION_PLAN',
				       ATTRIBUTE9 = 'F6000'
				 WHERE MEASURE    = 'CELL_FORM_HOLD_UNDER_AVAILABLE'
				   AND ISNULL(ATTRIBUTE1, '') = '' OR ISNULL(ATTRIBUTE9, '') = ''
				   ;


			-- E20260331-000738 82사업부 MA Plan 수행 시 속도지연
			SET @v_log_message = N'########## merge into #tmp_SCM_DNM_STOCK_AGING_V2  ##########';
			SET @v_description = @v_program_name + ':' + N'  measure CELL_FORM_HOLD_UNDER_AVAILABLE ';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
									  ,@p_log_type      =  N'TXN'
									  ,@p_log_count     = 0       
									  ,@p_log_message   = @v_log_message       
									  ,@p_description   = @v_description       
									  ,@p_event_date    = @d_event_date       
									  ,@p_user_id       = @v_batch_user      
									  ; 

---- 단위처리시간 추출 --
--print N'position_26 #PSI_GLOBAL_ESS temp 에 hold 재고 2 update'
--print REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +     
--      REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))     
--set @v_start_time = SYSDATETIME();
---- 단위처리시간 추출 --



            -------------------------------------------------------------------------------------------------------------         
            -- CELL_FORM_HOLD_AFTER 추가
            -- [전지 공급 대응력 향상을 위한 RTF 적확도 개선] : GSCM 시스템의 보류재고 감안한 계획 수립을 위한 시뮬레이션 변경 요청(자동차, ESS)
            ------------------------------------------------------------------------------------------------------------- 



                 --UPDATE X
                 --   SET X.QTY = Z.QTY
                 --  FROM #PSI_GLOBAL_ESS X  WITH (NOLOCK)
                 --  INNER JOIN (SELECT ITEM_ID, FROM_SITE, SUM(Y.QTY) AS QTY, Y.YYYYMMDD
                 --                FROM #PLN_TH_ENG_STOCK_PLAN Y  WITH (NOLOCK)
                 --                WHERE DESCR ='WH_HOLD'
                 --               GROUP BY ITEM_ID, FROM_SITE, YYYYMMDD
                 --            )  Z 
                 --     ON X.ITEM_ID    = Z.ITEM_ID                        
                 --    AND X.FROM_SITE  = Z.FROM_SITE
                 --    AND X.YYYYMMDD   = Z.YYYYMMDD
                 --    AND X.MEASURE    = 'CELL_FORM_HOLD_AFTER'
 
				MERGE INTO #PSI_GLOBAL_ESS AS X
				USING (SELECT @p_division_id AS DIVISION_ID
							,'A'             AS OPERATION_GROUP
							,A.ITEM_ID
							,'-'             AS TO_SITE
							,'-'             AS PROJECT_CODE
							,0               AS TO_BOH_QTY
							,0               AS FROM_BOH_QTY
							,'-'             AS INCOTERMS
							,A.FROM_SITE
							,'-'             AS TRANSPORT_MODE
							,'-'             AS PROD_LINE
							,'CELL_FORM_HOLD_AFTER' AS MEASURE
							,A.YYYYMMDD
							,ISNULL(A.QTY,0) AS QTY
							,B.SORT_ORDER_NO
							,B.COLUMN_LABEL_NAME
							,'-'            AS BOD_ID
							,''             AS ATTRIBUTE1			-- 중복방지
							,''             AS ATTRIBUTE9			-- 중복방지
						FROM (SELECT ITEM_ID, FROM_SITE, SUM(Y.QTY) AS QTY, Y.YYYYMMDD
                                 FROM #PLN_TH_ENG_STOCK_PLAN Y  WITH (NOLOCK)
                                 WHERE DESCR ='WH_HOLD'
								   AND (SELECT OPERATION_GROUP FROM SCM_MST_SITE WITH (NOLOCK) WHERE SCM_SITE_ID = Y.FROM_SITE) = 'A'		-- CELL 생산 사이트 한정
                                GROUP BY ITEM_ID, FROM_SITE, YYYYMMDD
                             )  A,
						     (SELECT * FROM #MEASURE WITH (NOLOCK) WHERE COLUMN_NAME = 'CELL_FORM_HOLD_AFTER') B
					   WHERE A.FROM_SITE IS NOT NULL
				      ) AS Y
				ON  X.ITEM_ID    = Y.ITEM_ID  
                AND X.FROM_SITE  = Y.FROM_SITE
                AND X.YYYYMMDD   = Y.YYYYMMDD
                AND X.MEASURE    = 'CELL_FORM_HOLD_AFTER'
				WHEN MATCHED  THEN
				UPDATE
				   SET X.QTY = ISNULL(Y.QTY,0)
				WHEN NOT MATCHED  THEN
				INSERT (
						 DIVISION_ID
						,OPERATION_GROUP	
						,ITEM_ID
						,TO_SITE
						,PROJECT_CODE
						,TO_BOH_QTY
						,FROM_BOH_QTY
						,INCOTERMS
						,FROM_SITE
						,TRANSPORT_MODE
						,PROD_LINE
						,MEASURE
						,YYYYMMDD
						,QTY
						,SORT_ORDER_NO
						,COLUMN_LABEL_NAME
						,BOD_ID
				       )
				VALUES (
						 Y.DIVISION_ID
						,Y.OPERATION_GROUP
						,Y.ITEM_ID
						,Y.TO_SITE
						,Y.PROJECT_CODE
						,Y.TO_BOH_QTY
						,Y.FROM_BOH_QTY
						,Y.INCOTERMS
						,Y.FROM_SITE
						,Y.TRANSPORT_MODE
						,Y.PROD_LINE
						,Y.MEASURE
						,Y.YYYYMMDD
						,Y.QTY
						,Y.SORT_ORDER_NO
						,Y.COLUMN_LABEL_NAME
						,Y.BOD_ID
				       ); 

					     IF @P_IS_DEBUG = 1 BEGIN SELECT '3455_PSI_GLOBAL' AS  "#PSI_GLOBAL_ESS" , * FROM #PSI_GLOBAL_ESS WHERE YYYYMMDD = @P_PLAN_START_YYYYMMDD END

                  
			-- E20260331-000738 82사업부 MA Plan 수행 시 속도지연
			SET @v_log_message = N'########## merge into #PSI_GLOBAL_ESS  ##########';
			SET @v_description = @v_program_name + ':' + N'  measure CELL_FORM_HOLD_AFTER ';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
									  ,@p_log_type      =  N'TXN'
									  ,@p_log_count     = 0       
									  ,@p_log_message   = @v_log_message       
									  ,@p_description   = @v_description       
									  ,@p_event_date    = @d_event_date       
									  ,@p_user_id       = @v_batch_user      
									  ; 

                  -- -- 보류중 해제일자가 없는수량
                  --UPDATE X
                  --  SET X.FROM_BOH_QTY = Z.QTY
                  -- FROM #PSI_GLOBAL_ESS X  WITH (NOLOCK)
                  -- INNER JOIN (SELECT ITEM_ID, FROM_SITE, SUM(Y.QTY) AS QTY
                  --               FROM #PLN_TH_ENG_STOCK_PLAN Y  WITH (NOLOCK)
                  --              WHERE DESCR ='WH_HOLD'
                  --              GROUP BY ITEM_ID,FROM_SITE
                  --           )  Z 
                  --    ON X.ITEM_ID    = Z.ITEM_ID       
                  --   AND X.FROM_SITE  = Z.FROM_SITE
                  --   AND X.MEASURE    = 'CELL_FORM_HOLD_AFTER'

				MERGE INTO #PSI_GLOBAL_ESS AS X
				USING (SELECT @p_division_id AS DIVISION_ID
							,'A'             AS OPERATION_GROUP
							,A.ITEM_ID
							,'-'             AS TO_SITE
							,'-'             AS PROJECT_CODE
							,0               AS TO_BOH_QTY
							,A.FROM_BOH_QTY
							,'-'             AS INCOTERMS
							,A.FROM_SITE
							,'-'             AS TRANSPORT_MODE
							,'-'             AS PROD_LINE
							,'CELL_FORM_HOLD_AFTER' AS MEASURE
							,0               AS QTY
							,B.SORT_ORDER_NO
							,B.COLUMN_LABEL_NAME
							,'-'            AS BOD_ID
							,''             AS ATTRIBUTE1			-- 중복방지
							,''             AS ATTRIBUTE9			-- 중복방지
						FROM (SELECT ITEM_ID, FROM_SITE, SUM(Y.QTY) AS FROM_BOH_QTY
                                 FROM #PLN_TH_ENG_STOCK_PLAN Y  WITH (NOLOCK)
                                WHERE DESCR ='WH_HOLD'
                                GROUP BY ITEM_ID,FROM_SITE
                             )  A,
						     (SELECT * FROM #MEASURE WITH (NOLOCK) WHERE COLUMN_NAME = 'CELL_FORM_HOLD_AFTER') B
					   WHERE A.FROM_SITE IS NOT NULL
				      ) AS Y
				ON  X.ITEM_ID    = Y.ITEM_ID  
                AND X.FROM_SITE  = Y.FROM_SITE
                AND X.MEASURE    = 'CELL_FORM_HOLD_AFTER'
				WHEN MATCHED  THEN
				UPDATE
				   SET X.FROM_BOH_QTY = ISNULL(Y.FROM_BOH_QTY, 0)
				WHEN NOT MATCHED  THEN
				INSERT (
						 DIVISION_ID
						,OPERATION_GROUP	
						,ITEM_ID
						,TO_SITE
						,PROJECT_CODE
						,TO_BOH_QTY
						,FROM_BOH_QTY
						,INCOTERMS
						,FROM_SITE
						,TRANSPORT_MODE
						,PROD_LINE
						,MEASURE
						,YYYYMMDD
						,QTY
						,SORT_ORDER_NO
						,COLUMN_LABEL_NAME
						,BOD_ID
				       )
				VALUES (
						 Y.DIVISION_ID
						,Y.OPERATION_GROUP
						,Y.ITEM_ID
						,Y.TO_SITE
						,Y.PROJECT_CODE
						,Y.TO_BOH_QTY
						,Y.FROM_BOH_QTY
						,Y.INCOTERMS
						,Y.FROM_SITE
						,Y.TRANSPORT_MODE
						,Y.PROD_LINE
						,Y.MEASURE
						,@p_plan_start_yyyymmdd
						,Y.QTY
						,Y.SORT_ORDER_NO
						,Y.COLUMN_LABEL_NAME
						,Y.BOD_ID
				       ); 

				IF @P_IS_DEBUG = 1 BEGIN SELECT '3544_PSI_GLOBAL' AS  "#PSI_GLOBAL_ESS" , * FROM #PSI_GLOBAL_ESS WHERE YYYYMMDD = @P_PLAN_START_YYYYMMDD END

				UPDATE #PSI_GLOBAL_ESS
				   SET ATTRIBUTE1 = '',
				       ATTRIBUTE9 = ''
				 WHERE MEASURE    = 'CELL_FORM_HOLD_AFTER'
				   ;


			-- E20260331-000738 82사업부 MA Plan 수행 시 속도지연
			SET @v_log_message = N'########## merge into #PSI_GLOBAL_ESS  ##########';
			SET @v_description = @v_program_name + ':' + N'  from #PLN_TH_ENG_STOCK_PLAN  CELL_FORM_HOLD_AFTER ';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
									  ,@p_log_type      =  N'TXN'
									  ,@p_log_count     = 0       
									  ,@p_log_message   = @v_log_message       
									  ,@p_description   = @v_description       
									  ,@p_event_date    = @d_event_date       
									  ,@p_user_id       = @v_batch_user      
									  ; 

                     
            -------------------------------------------------------------------------------------------------------------         
            -- LT 계산용 테이블 생성   
            -------------------------------------------------------------------------------------------------------------         
             IF OBJECT_ID('tempdb..#SCP_MST_BOD_V') IS NOT NULL      
	                DROP TABLE #SCP_MST_BOD_V; 

                SELECT DISTINCT X.DIVISION_ID,X.FROM_SITE,X.TO_SITE,X.INCOTERMS,X.TRANSPORT_MODE,X.LT_TOTAL, X.BOD_ID, CEILING(LT_TOTAL/7.0) AS LT_TOTAL_BY_WEEK
                INTO #SCP_MST_BOD_V
                FROM SCP_MST_BOD_N_V  X WITH (NOLOCK)		-- BOD L/T 2단계 - SCP_MST_BOD_V --> SCP_MST_BOD_N_V
                WHERE DIVISION_ID =@p_division_id

			-- E20260331-000738 82사업부 MA Plan 수행 시 속도지연
			SET @v_log_message = N'##########  into #SCP_MST_BOD_V  ##########';
			SET @v_description = @v_program_name + ':' + N' into #SCP_MST_BOD_V ';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
									  ,@p_log_type      =  N'TXN'
									  ,@p_log_count     = 0       
									  ,@p_log_message   = @v_log_message       
									  ,@p_description   = @v_description       
									  ,@p_event_date    = @d_event_date       
									  ,@p_user_id       = @v_batch_user      
									  ; 
         
            ---------------------------------------------------------------------------------------------------------------                                         
            -- PACK공장 CELL 재고 UPDATE
            ------------------------------------------------------------------------------------------------------------- 
                 -- PACK 일경우 
				-- E20260331-000738 82사업부 MA Plan 수행 시 속도지연 주석처리 
				/*
                UPDATE X
                   SET	CELL_ITEM_ID      = ( SELECT TOP 1 CHILD_ITEM_ID
                                               FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V AS Y WITH (NOLOCK)
                                              WHERE Y.DIVISION_ID        = X.DIVISION_ID
											    AND Y.MODEL_ID           = X.ITEM_ID
                                                AND Y.CELL_TYPE			 = 'CP'		-- 활성화코드 분리 대응(Cell Product 조건 추가. 2023.06.15, KSK
                                                AND Y.OPERATION_GROUP_ID = 'A')
                FROM #PSI_GLOBAL_ESS X
                 WHERE OPERATION_GROUP   = 'P';
                 ;
				*/
				-- E20260331-000738 82사업부 MA Plan 수행 시 속도지연 개선로직 시작
				 ;
				with model_child_item_id as
				(
					SELECT Y.DIVISION_ID , MODEL_ID , MIN(CHILD_ITEM_ID) AS CHILD_ITEM_ID FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V AS Y WITH(NOLOCK)
					WHERE Y.DIVISION_ID = @p_division_id
					AND Y.CELL_TYPE			 = 'CP'		-- 활성화코드 분리 대응(CELL PRODUCT 조건 추가) :: 2023.06.15 , KSK
					AND Y.OPERATION_GROUP_ID = 'A'
					GROUP BY Y.DIVISION_ID , MODEL_ID
				)
				UPDATE X
					SET X.CELL_ITEM_ID      = Y.CHILD_ITEM_ID
				FROM #PSI_GLOBAL_ESS X
					JOIN model_child_item_id AS Y 
					ON Y.DIVISION_ID        = X.DIVISION_ID
					AND Y.MODEL_ID           = X.ITEM_ID
                WHERE OPERATION_GROUP   = 'P';
				-- E20260331-000738 82사업부 MA Plan 수행 시 속도지연 개선로직 끝



			-- E20260331-000738 82사업부 MA Plan 수행 시 속도지연
			SET @v_log_message = N'##########  update #PSI_GLOBAL_ESS ##########';
			SET @v_description = @v_program_name + ':' + N' PACK공장 CELL 재고 UPDATE ';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
									  ,@p_log_type      =  N'TXN'
									  ,@p_log_count     = 0       
									  ,@p_log_message   = @v_log_message       
									  ,@p_description   = @v_description       
									  ,@p_event_date    = @d_event_date       
									  ,@p_user_id       = @v_batch_user      
									  ; 


				 -- CELL 일경우 -- 활성화코드 분리 대응(Cell Product 조건 추가. 2023.06.15, KSK- start
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
				)
				 UPDATE X
					SET X.CELL_ITEM_ID      = CASE WHEN F.CELL_TYPE LIKE 'CA%'
												   THEN ISNULL(ISNULL(ISNULL(C1.ITEM_ID_PROD, C2.ITEM_ID_PROD),C3.ITEM_ID_PROD), X.ITEM_ID)
												   ELSE X.ITEM_ID
											  END 
				  FROM #PSI_GLOBAL_ESS X WITH (NOLOCK)
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
				 -- CELL 일경우 -- 활성화코드 분리 대응(Cell Product 조건 추가. 2023.06.15, KSK - end

			-- E20260331-000738 82사업부 MA Plan 수행 시 속도지연
			SET @v_log_message = N'##########  update #PSI_GLOBAL_ESS ##########';
			SET @v_description = @v_program_name + ':' + N' CELL 일경우 -- 활성화코드 분리 대응(Cell Product 조건 추가. ';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
									  ,@p_log_type      =  N'TXN'
									  ,@p_log_count     = 0       
									  ,@p_log_message   = @v_log_message       
									  ,@p_description   = @v_description       
									  ,@p_event_date    = @d_event_date       
									  ,@p_user_id       = @v_batch_user      
									  ; 


				 IF @P_IS_DEBUG = 1 BEGIN SELECT '3630_PSI_GLOBAL' AS  "#PSI_GLOBAL_ESS" , * FROM #PSI_GLOBAL_ESS WHERE YYYYMMDD = @P_PLAN_START_YYYYMMDD END
            -------------------------------------------------------------------------------------------------------------         
            -- LINE_TOTAL_LOAD_ENGINE (TACT_TIME,WORKING_TIME)  
            -------------------------------------------------------------------------------------------------------------
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
		            FROM dbo.FN_LINE_WORKINGTIME_BY_LOSS(@p_division_id, @p_plan_start_yyyymmdd, @p_to_yyyymmdd, '' )
		            ;

			-- E20260331-000738 82사업부 MA Plan 수행 시 속도지연
			SET @v_log_message = N'##########  into #LINE_WORKINGTIME_BY_LOSS ##########';
			SET @v_description = @v_program_name + ':' + N' into #LINE_WORKINGTIME_BY_LOSS ';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
									  ,@p_log_type      =  N'TXN'
									  ,@p_log_count     = 0       
									  ,@p_log_message   = @v_log_message       
									  ,@p_description   = @v_description       
									  ,@p_event_date    = @d_event_date       
									  ,@p_user_id       = @v_batch_user      
									  ; 

                UPDATE X
                SET X.QTY = D.WORKING_TIME
                FROM #PSI_GLOBAL_ESS X  WITH (NOLOCK)
                INNER JOIN #LINE_WORKINGTIME_BY_LOSS D  WITH (NOLOCK)
                  ON  X.DIVISION_ID   = D.DIVISION_ID 
                  AND X.ATTRIBUTE9    = D.OPERATION_ID 
					        AND X.FROM_SITE     = D.SCM_SITE_ID 
					        AND X.PROD_LINE     = D.LINE_ID 
					        AND X.YYYYMMDD      = D.YYYYMMDD
                  AND X.MEASURE       IN ('PACK_WORKING_TIME','CELL_WORKING_TIME')

			-- E20260331-000738 82사업부 MA Plan 수행 시 속도지연
			SET @v_log_message = N'##########  update #LINE_WORKINGTIME_BY_LOSS ##########';
			SET @v_description = @v_program_name + ':' + N' update #LINE_WORKINGTIME_BY_LOSS ';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
									  ,@p_log_type      =  N'TXN'
									  ,@p_log_count     = 0       
									  ,@p_log_message   = @v_log_message       
									  ,@p_description   = @v_description       
									  ,@p_event_date    = @d_event_date       
									  ,@p_user_id       = @v_batch_user      
									  ;                 

	              IF OBJECT_ID('tempdb..#LineLoad') IS NOT NULL      
	                DROP TABLE #LineLoad;  
  	
                SELECT /*DISTINCT */
						          A.DIVISION_ID
					          , A.SCM_SITE_ID 
                    , A.OPERATION_GROUP
		                , A.OPERATION_ID
		                , A.LINE_ID
                    , (CASE WHEN A.MEASURE = 'PROD_PLAN_AMEND' AND  A.OPERATION_GROUP ='P' THEN 'PACK_PROD_LOAD' WHEN A.MEASURE = 'PROD_PLAN_AMEND' AND  A.OPERATION_GROUP ='A'  THEN 'CELL_PROD_LOAD' END ) AS MEASURE
                    , CASE WHEN D.WORKING_TIME <= 0.0 THEN 0 ELSE ISNULL( ( ( ROUND(SUM(A.QTY * (E.TACT_TIME/60)),0) / D.WORKING_TIME ) ) ,0 ) *100  END AS QTY
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
	                --AND A.YYYYMMDD           <=  @p_to_yyyymmdd --말일포함(KSK, 20240814, 운영배포보류)
--	                AND A.MEASURE             IN ('CELL_PROD','PACK_PROD')
                  AND A.MEASURE             IN ('PROD_PLAN_AMEND')                  
              GROUP BY A.DIVISION_ID, A.SCM_SITE_ID ,A.OPERATION_ID ,A.LINE_ID, A.YYYYMMDD, D.WORKING_TIME,  C.ISO_YYYYWW,A.OPERATION_GROUP
                      ,(CASE WHEN A.MEASURE = 'PROD_PLAN_AMEND' AND  A.OPERATION_GROUP ='P' THEN 'PACK_PROD_LOAD' WHEN A.MEASURE = 'PROD_PLAN_AMEND' AND  A.OPERATION_GROUP ='A'  THEN 'CELL_PROD_LOAD' END ) 
			
			IF @P_IS_DEBUG = 1 BEGIN SELECT '3672_LINE_LOAD' AS  #LineLoad , * FROM #LineLoad WHERE YYYYMMDD = @P_PLAN_START_YYYYMMDD END						
			 
			IF @P_IS_DEBUG = 1 BEGIN SELECT '3674_PSI_GLOBAL_ESS' AS  "#PSI_GLOBAL_ESS" , * FROM #PSI_GLOBAL_ESS WHERE YYYYMMDD = @P_PLAN_START_YYYYMMDD END

			-- E20260331-000738 82사업부 MA Plan 수행 시 속도지연
			SET @v_log_message = N'##########  into #LineLoad ##########';
			SET @v_description = @v_program_name + ':' + N' into #LineLoad ';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
									  ,@p_log_type      =  N'TXN'
									  ,@p_log_count     = 0       
									  ,@p_log_message   = @v_log_message       
									  ,@p_description   = @v_description       
									  ,@p_event_date    = @d_event_date       
									  ,@p_user_id       = @v_batch_user      
									  ;      



             INSERT INTO #PSI_GLOBAL_ESS
	            SELECT DISTINCT A.DIVISION_ID								
			              , A.OPERATION_GROUP						
			              , A.CELL_ITEM_ID							
			              , A.ITEM_ID										
			              , '-' AS TO_SITE
                    , A.PROJECT_CODE
			              , A.TO_BOH_QTY										
			              , A.FROM_BOH_QTY									
			              , '-' AS INCOTERMS 										
			              , A.FROM_SITE 										
                    , '-' AS TRANSPORT_MODE
                    , A.PROD_LINE
			              , B.MEASURE												
			              , A.YYYYMMDD	
                    , B.QTY
			              , M.SORT_ORDER_NO									
			              , M.COLUMN_LABEL_NAME							
			              , A.BOD_ID						
                    , A.ATTRIBUTE1										
			              , A.ATTRIBUTE9										
	            FROM #PSI_GLOBAL_ESS A WITH(NOLOCK)
	            INNER JOIN #LineLoad B WITH(NOLOCK)
		            ON  A.DIVISION_ID         = B.DIVISION_ID
		            AND A.OPERATION_GROUP     = B.OPERATION_GROUP
		            AND A.FROM_SITE           = B.SCM_SITE_ID
		            AND A.ATTRIBUTE9          = B.OPERATION_ID
		            AND A.PROD_LINE           = B.LINE_ID
		            AND A.YYYYMMDD            = B.YYYYMMDD
             INNER JOIN #MEASURE M  WITH (NOLOCK)
                ON B.MEASURE   = M.COLUMN_NAME
	            ;           
			
				IF @P_IS_DEBUG = 1 SELECT '3781_PSI_GLOBAL_ESS' AS  "#PSI_GLOBAL_ESS" , * FROM #PSI_GLOBAL_ESS WHERE YYYYMMDD = @P_PLAN_START_YYYYMMDD

			-- E20260331-000738 82사업부 MA Plan 수행 시 속도지연
			SET @v_log_message = N'##########  into #PSI_GLOBAL_ESS ##########';
			SET @v_description = @v_program_name + ':' + N' INNER JOIN #LineLoad ';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
									  ,@p_log_type      =  N'TXN'
									  ,@p_log_count     = 0       
									  ,@p_log_message   = @v_log_message       
									  ,@p_description   = @v_description       
									  ,@p_event_date    = @d_event_date       
									  ,@p_user_id       = @v_batch_user      
									  ;    
				

---- 단위처리시간 추출 --
--print N'position_27 #PSI_GLOBAL_ESS temp 에 LT update'
--print REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +     
--      REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))     
--set @v_start_time = SYSDATETIME();
---- 단위처리시간 추출 --


            
			-- 2021.06.03 KSW PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전으로 신규생성
            --  구 버전에서 PIVOT 생성단계 이후 단계를 호출하는 로직으로 분리함 (1 YEAR 구간별 생성 :: 중장기 구현시 컬럼 및 행 SIZE 제약 해결)
		
		 -- 이력정보 START -------------------------------------------------------------------------------------------------		 
			--최근3주차  이력일자 
	        DECLARE @v_hist_date			NVARCHAR(8) = CONVERT(VARCHAR(8), DATEADD(day,  -2 * 7, @p_plan_start_yyyymmdd), 112)	
	        IF EXISTS (SELECT 1 FROM  SCP_XLS_PSI_GLOBAL_ESS_H  WITH (NOLOCK) 
							WHERE PLAN_START_YYYYMMDD < @v_hist_date) 
			BEGIN
				-- 최근 3주차 이전데어터는 삭제
				DELETE FROM SCP_XLS_PSI_GLOBAL_ESS_H
				WHERE PLAN_START_YYYYMMDD < @v_hist_date	;

				SET @v_description  =  'DELETE HISTORY DONE BEFORE ' +  @v_hist_date ;      
				SET @d_event_date = SYSDATETIME()   
				IF @p_is_debug = 0
				EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
							,@p_log_type      = 'END'      
                            ,@p_log_count     = 1
                            ,@p_log_message   =  N'########## END of procedure ##########'       
                            ,@p_description   = @v_description       
                            ,@p_event_date    =   @d_event_date
                            ,@p_user_id       = @v_batch_user      
                            ;   
			END

			--현재플랜과 동일한 이력 데이터 초기화
			DELETE FROM SCP_XLS_PSI_GLOBAL_ESS_H
            WHERE DIVISION_ID = @p_division_id 			
			AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd AND PLAN_TYPE = @p_plan_type AND SEQ = @p_seq


			--저장플랜과 동일한 이력데이터 초기화
			DELETE H 
			FROM SCP_XLS_PSI_GLOBAL_ESS_H H WITH (NOLOCK)
			INNER JOIN  SCP_XLS_PSI_GLOBAL_ESS E WITH (NOLOCK)
				ON H.DIVISION_ID = E.DIVISION_ID
				AND 	H.PLAN_START_YYYYMMDD = E.PLAN_START_YYYYMMDD AND H.PLAN_TYPE = E.PLAN_TYPE AND H.SEQ = E.SEQ

			 -- 저장 플랜의 백업본 저장
			INSERT SCP_XLS_PSI_GLOBAL_ESS_H SELECT * FROM SCP_XLS_PSI_GLOBAL_ESS WITH(NOLOCK)
			-- 이력정보  ----------------------------------------------------------------------------------------- END

			-- 사업부별 현재 데이터 삭제
			IF @P_IS_DEBUG = 0
				DELETE FROM SCP_XLS_PSI_GLOBAL_ESS                            
				WHERE DIVISION_ID = @p_division_id ;

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

			

			IF @P_IS_DEBUG = 0 
			EXEC @rows = PR_SCP_XLS_PSI_GLOBAL_ESS_S              @p_plan_cycle             = @p_plan_cycle          
                                                                , @p_plan_start_yyyymmdd    = @p_plan_start_yyyymmdd          
                                                                , @p_plan_id                = @p_plan_id          
                                                                , @p_modeling_id            = @p_modeling_id          
                                                                , @p_seq                    = @p_seq          
                                                                , @p_plan_type              = @p_plan_type          
                                                                , @p_master_id              = @p_master_id          
                                                                , @p_division_id            = @p_division_id          
                                                                , @p_engine_plan_id         = @p_engine_plan_id           
																, @p_create_from_yyyymmdd   = @p_create_from_yyyymmdd
																, @p_create_to_yyyymmdd     = @p_create_to_yyyymmdd
                                                                , @p_user_id                = @v_batch_user
																, @p_is_debug					= @p_is_debug
																;
            IF (@rows < 0)  GOTO _RETURN_ERR_CODE
			
			IF @v_bp_flag = 'Y'
			BEGIN

			  --2년차 사업계획을 위한 1년차 키백업(KSK)
				IF @p_plan_start_yyyymmdd = @p_create_from_yyyymmdd 
				BEGIN
					PRINT '1 YEAR #XLS_KEYS PREPARE'
					IF OBJECT_ID('tempDB..#XLS_KEYS') IS NOT NULL DROP TABLE #XLS_KEYS
					select PLAN_START_YYYYMMDD,  PLAN_TYPE, SEQ, CREATE_FROM_YYYYMMDD, DIVISION_ID
						, OPERATION_GROUP, CELL_ITEM_ID, ITEM_ID, TO_SITE,  PROJECT_CODE
						, INCOTERMS, FROM_SITE, TRANSPORT_MODE, PROD_LINE, BOD_ID, MEASURE
						, XLS_KEY1
					into #XLS_KEYS
					from SCP_XLS_PSI_GLOBAL_ESS Y  WITH (NOLOCK)												
					where  Y.CREATE_FROM_YYYYMMDD  = @p_create_from_yyyymmdd ;	
					
					--SELECT '#XLS_KEYS' TN , * FROM #XLS_KEYS --TEST
				END		 

				-- 2 YEAR PIVOT data 생성
				SET @p_create_from_yyyymmdd = CONVERT(VARCHAR(8), DATEADD(day, 1, @p_create_to_yyyymmdd), 112);
				SET @p_create_to_yyyymmdd   = CONVERT(VARCHAR(8), DATEADD(day, 363, @p_create_from_yyyymmdd), 112);



				EXEC @rows = PR_SCP_XLS_PSI_GLOBAL_ESS_S              @p_plan_cycle             = @p_plan_cycle          
																	, @p_plan_start_yyyymmdd    = @p_plan_start_yyyymmdd          
																	, @p_plan_id                = @p_plan_id          
																	, @p_modeling_id            = @p_modeling_id          
																	, @p_seq                    = @p_seq          
																	, @p_plan_type              = @p_plan_type          
																	, @p_master_id              = @p_master_id          
																	, @p_division_id            = @p_division_id          
																	, @p_engine_plan_id         = @p_engine_plan_id           
																	, @p_create_from_yyyymmdd   = @p_create_from_yyyymmdd
																	, @p_create_to_yyyymmdd     = @p_create_to_yyyymmdd
																	, @p_user_id                = @v_batch_user
																	, @p_is_debug					= @p_is_debug
																	;
				IF (@rows < 0)  GOTO _RETURN_ERR_CODE
			END

            -------------------------------------------------------------------------------------------------------------         
            -- 임시 TEMP  테이블 DROP  
            -------------------------------------------------------------------------------------------------------------
	            IF OBJECT_ID('tempdb..#MEASURE')    IS NOT NULL	
		            DROP TABLE #MEASURE

              IF OBJECT_ID('tempdb..#PSI_GLOBAL') IS NOT NULL      
	              DROP TABLE #PSI_GLOBAL;       
                
              IF OBJECT_ID('tempdb..#ANL_SHIPMENT_PLAN_FG') IS NOT NULL      
	              DROP TABLE #ANL_SHIPMENT_PLAN_FG;       
                
              IF OBJECT_ID('tempdb..#ANL_PRODUCTION_PLAN') IS NOT NULL      
	              DROP TABLE #ANL_PRODUCTION_PLAN;       
                
              IF OBJECT_ID('tempdb..#ANL_SHIPMENT_PLAN_SEMI') IS NOT NULL      
	              DROP TABLE #ANL_SHIPMENT_PLAN_SEMI;       
                
              IF OBJECT_ID('tempdb..#SCP_PLN_PRODUCTION_PLAN') IS NOT NULL      
	              DROP TABLE #SCP_PLN_PRODUCTION_PLAN;        

              IF OBJECT_ID('tempdb..#ITEM_ID') IS NOT NULL      
	              DROP TABLE #ITEM_ID;        

              IF OBJECT_ID('tempdb..#PSI_GLOBAL_ESS') IS NOT NULL      
	              DROP TABLE #PSI_GLOBAL_ESS;        
                
              IF OBJECT_ID('tempdb..#INTRANSIT')  IS NOT NULL       
		            DROP TABLE #INTRANSIT

              IF OBJECT_ID('tempdb..#SCP_MST_BOD_V') IS NOT NULL      
	              DROP TABLE #SCP_MST_BOD_V; 

              IF OBJECT_ID('tempdb..#LineLoad')   IS NOT NULL
	              DROP TABLE #LineLoad              

              IF OBJECT_ID('tempdb..#LineLoad_WEEK_PIVOT')   IS NOT NULL
	              DROP TABLE #LineLoad_WEEK_PIVOT              

              IF OBJECT_ID('tempdb..#TRANSPORT_MODE') IS NOT NULL      
	              DROP TABLE #TRANSPORT_MODE;

              IF OBJECT_ID('tempdb..#SCP_XLS_PSI_GLOBAL_ESS_MODEL_INVENTORY') IS NOT NULL      
	              DROP TABLE #SCP_XLS_PSI_GLOBAL_ESS_MODEL_INVENTORY;                  
              
              IF OBJECT_ID('tempdb..#Rn') IS NOT NULL	
	              DROP TABLE #Rn

              IF OBJECT_ID('tempdb..#CALENDAR') IS NOT NULL	
	              DROP TABLE #CALENDAR

              IF OBJECT_ID('tempdb..#HEADER') IS NOT NULL	
	               DROP TABLE #HEADER

              IF OBJECT_ID('tempdb..#PLN_PLANT_ONHAND')  IS NOT NULL       
		            DROP TABLE #PLN_PLANT_ONHAND                

	            IF OBJECT_ID('tempdb..#BOH')        IS NOT NULL       
		            DROP TABLE #BOH

	            IF OBJECT_ID('tempdb..#SCP_XLS_PSI_GLOBAL_ESS') IS NOT NULL       
		            DROP TABLE #SCP_XLS_PSI_GLOBAL_ESS

              IF OBJECT_ID('tempdb..#tmp_SCP_MST_TACT_TIME') IS NOT NULL	
	              DROP TABLE #tmp_SCP_MST_TACT_TIME

           IF OBJECT_ID('tempdb..#PROD_TACT_TIME_PIVOT') IS NOT NULL
	              DROP TABLE #PROD_TACT_TIME_PIVOT	

           IF OBJECT_ID('tempdb..#BOD_OTHER_SHIP_PLAN') IS NOT NULL
	              DROP TABLE #BOD_OTHER_SHIP_PLAN

			IF OBJECT_ID('tempDB..#XLS_KEYS') IS NOT NULL 			
				DROP TABLE #XLS_KEYS

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
      IF @p_is_debug = 0
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
	  IF @p_is_debug = 0
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
    SET @v_description  = N'['+@p_master_id+']['+@p_engine_plan_id+'][' + @v_exec_time + ']';                
    SET @d_event_date   = SYSDATETIME()  ;     
	IF @p_is_debug = 0
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
  

