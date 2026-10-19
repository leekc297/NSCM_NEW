

/*      
 * Program ID   : PR_SCP_XLS_PSI_GLOBAL        
 * Description  : PR_SCP_XLS_CREATE_DATA 에서 호출함.      
 * OutTable     :      
 * Execute      : 

      EXEC PR_SCP_XLS_PSI_GLOBAL
               @p_plan_cycle          = 'WEEKLY'
             , @p_plan_start_yyyymmdd = '20190325'
             , @p_plan_id             = '1071'
             , @p_modeling_id         = '2'
             , @p_seq                 = '1'
             , @p_plan_type           = 'PR'
             , @p_master_id           = '81::WEEKLY'
             , @p_division_id         = '81'
             , @p_engine_plan_id      = '1071::PR::1'
             , @p_user_id             = 'KTH'
 
    SELECT * FROM SCM_SYS_LOG_BATCH  where PROGRAM_NAME ='PR_SCP_XLS_PSI_GLOBAL' order by CREATION_DATE desc

 * Program History      
 *===================================================================================================      
 *   Date       In Charge      Description      
 *===================================================================================================      
 * 2019.01.08   KTH         Initial Release PJ20170278 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트  
 * 2019.01.23   KTH         TRANSPORT_MODE 반영
 * 2019.02.11   KTH         PROJECT_CODE 추가 
 * 2019.02.20   KTH         INCOTERMS 추가
 * 2019.04.01   KTH         WEEK로직으로 변경
 * 2019.04.10   KTH         LINE LOAD율 로직 변경
 * 2019.04.17   KTH         SHIP_PLAN, CELL_FORM_PROGRESS,CELL_FOR_FORM_END  로직 변경
 * 2019.04.18   KTH         SHIP_PLAN 수정
 * 2019.04.22   KTH         SHIP_PLAN이 없을 경우 로직 반영
 * 2019.04.24   YYDOK       BOH 수량오류수정.=> XLS_BOH활용으로 통일
 * 2019.04.25   KTH         YIELD 추가
 * 2019.04.30   KTH         DIO 계산용 MEASURE 추가(MKT_FCST_TOTAL,ALLOCATION_TOTAL,EOH_TOTAL,MKT_FCST_DIO,ALLOCATION_DIO)
 * 2019.05.14   KTH         CELL_FORM_HOLD 추가 
 * 2019.05.28   KTH         PACK공장 CELL 재고 로직 변경
 * 2019.05.29   KTH         LINE_ID 추가 로직 수정
 * 2019.06.03   KTH         BOD LT (SHIP_PLAN/SEMI_SHIP_PLAN) : BOD L/T 계산시 1~7일 구간은 반올림, 이후 구간은 올림 처리
 * 2019.06.05   KTH         TRANSPORT 모드 추가 로직 변경(SEMI_SHIP_PLAN)
 * 2019.06.10   KTH         YIELD 수정 (PLANT_SITE_ID 조건 추가)
 * 2019.06.12   KTH         Line Load율 로직 변경
 * 2019.06.26   KTH         MKT_FCST_PACK_TOTAL,MKT_FCST_CELL_TOTAL 추가
 * 2019.06.27   KTH         PACK_PROD MEASURE에 YIELD 추가
 * 2019.07.03   KTH         TRANSPORT_MODE 추가시 SUB.TRANSPORT_MODE  IS NOT NULL 조건 추가
 * 2019.07.09   KTH         YIELD(CELL_CHAR_AVAILABLE) 로직 변경 (CASE WHEN Y.SSP_MODIFY_YIELD > 0.0 THEN Y.SSP_MODIFY_YIELD ELSE Y.FORMATION_TOTAL_YIELD END)
 * 2019.07.10   KTH         INTRANSIT 계산시 INCOTERMS 도 구분하여 계산하는 로직 추가
 * 2019.08.23   KTH         FG FROM SITE와 WH_IN만 MEASURE 있는 경우 누락되는 로직 수정
 * 2019.09.05   KTH         SEMI SEMI_SHIP_PLAN없이 해상재고만 있는 경우 누락되는 로직 수정
 * 2019.09.17   KTH         SEMI_SHIP_PLAN BOD_ID 없이 생성되는 중복 오류 보정
 * 2019.11.12   KTH         PACK_BOH 로직 변경(MODEL_INVENTORY 생성부분 삭제) 
 * 2020.01.07   KTH         #Rn 테이블 변경
 * 2020.02.06   KTH         ESS 외주 Line별 생산 Target 관련 OSP_YN로직 수정
 * 2020.03.17   KTH         LT 로직 변경(SCM_MST_SITE_ITEM.SCP_VMI_LT)
 * 2020.03.23   KTH         [전지 공급 대응력 향상을 위한 RTF 적확도 개선] - Hold VMI 대기 재고 Visibility 강화
 * 2020.03.31   KTH         CELL_PROD LT로직 변경
 * 2020.06.26   KTH         [전지 공급 대응력 향상을 위한 RTF 적확도 개선] : GSCM 시스템의 보류재고 감안한 계획 수립을 위한 시뮬레이션 변경 요청(자동차, ESS)
 * 2020.06.25   KTH         전지 공급 대응력 향상을 위한 SCM 관리 체계 개선 - DIO 수정 관련, 2020.07.02 KSW 보완
 * 2020.07.13   KSW         전지 공급 대응력 향상을 위한 SCM 관리 체계 개선 - DIO 수정 관련 - 기준/최소 쿼리에서 YYYYMM -> YYYYQ 으로 변경
 * 2020.07.14   KSW         생산계획이 존재하지 않을경우 CELL 재고관련 Measure 가 누락되는 Case 보완
 * 2020.09.03   KSW         SEMI 첫날 수량이 0값으로 되는 오류수정 - 해상재고 union 할 때 SCP_ANL_SHIPMENT_PLAN_SEMI 건 제외 (중복발생으로 후행삭제 로직에서 삭제되는 문제점 보완)
 * 2021.05.20   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 대응
                            - 구 버전에서 PIVOT 생성단계 이후 단계를 호출하는 로직으로 분리함 (+26주 구간별 생성 :: 중장기 구현시 컬럼 및 행 SIZE 제약 해결)
							- 실제로는 364 + 364 플랜 DATA 가 생성됨
 * 2021.05.27   KSW         NICK NAME 누락오류 수정
 * 2021.06.28   KSW         PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - CAPA Line Assign(Tact Time) 에 따른 출하/생산계획 추가
 * 2021.08.10   KSW         PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 - CAPA. 형교환 입력(Load Ratio 표시) 및 저장기능 구현
 * 2021.08.10   KSW         capa. 적용기준 변경
 * 2021.08.17   KSW         CAPA Line Assign(Tact Time) 에 따른 출하/생산계획 추가 - PRIORITY 조건 추가
 * 2021.08.25   KSW         CAPA Line Assign(Tact Time) 에 따른 생산계획 추가 - SCM_MST_SITE_ITEM_PRIORITY From/To YYYYMMDD 조건변경
 * 2021.08.26   KSW         PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 - SCP_MST_BOD_V --> SCP_MST_BOD_N_V
 * 2021.09.08   KSW         PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 - PACK BOH (Hold, Wait for Inspection, Expected Inspection date) 추가
 * 2021.10.19   KSW         PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 [추가개선] - Pack BOH 수량에서 Hold 수량제외
 * 2021.10.26   KSW         튜닝개선안 반영
 * 2021.11.03   KSW         Pack BOH(Expected Inspection date) - PACK_BOH_EXP_INSP_DATE measure 중복오류수정
 * 2022.07.29   KSW         DIO Report에서 사용되는 GRO_STD_DIO, MIN_STD_DIO 으로 대체
 * 2022.08.30   KSW			Cell 재고 개선건
 *							1) PACK_CELL_BOH	Cell BOH measure 에서 HOLD 수량제외
 *							2) Cell BOH(Hold) new measure 에 주차별 표시, FROM_BOH_QTY 에 (플랜범위이전 + 플랜범위초과) 영역의 수량 표시
 *							3) CELL_FORM_HOLD_AFTER	After Form. Hold Release measure 에서 FROM_BOH_QTY 에 (플랜범위이전 + 플랜범위초과) 영역의 수량 표시
 * 2022.10.14	KSW			불필요한 생산계획 생성을 차단
 * 2022.10.19   KSW			Memo measure 추가
 * 2022.12.05	KSW			Line assign 조건변경
 * 2023.07.01 KSK/DHJ		PJ20230691  SCM 역량 강화 위한 SCP 개선과제 이행 : 활성화 분리
 * 2024.05.08 KSK				E20240507-000511 (구간별 BOD LT 개선을 위한 SIMULATOR 로직 변경)  
 * 2024.07.04 KSK				라인정보 가져올때 ACTIVE_FLAG 유효성('Y') 체크  
 * 2024.08.14 KSK				이동계획의 말일자 데이터 누락 수정 
 * 2025.02.03 KSK				INTRANSIT_ETA와 SEMI_INTRANSIT_ETA 메저추가시  SITE_TYPE조건을 추가함
 * 2025.04.22 KIMCD			#LineLoad 형성용 조회문에 HASH JOIN 추가
 * 2025.04.23 KSK				디버그 파라미터 추가
 * 2025.04.30 KSK				멀티구간 BOD 로직수정
 * 2025.07.09 KSK				멀티구간 BOD 로직보완(BOD_VALID_YN, ROUTE VALID)
 * 2025.08.29 YMH           CSR E20250829-001508 실행계획개선 (속도개선)
 */    
--DROP PROC dbo.PR_SCP_XLS_PSI_GLOBAL

CREATE PROCEDURE [dbo].[PR_SCP_XLS_PSI_GLOBAL]
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
    , @p_is_debug			bit		= 0		-- 0:	RELEASE    , 1 : DEBUG
	, @P_CELL				  NVARCHAR(50) = NULL	    -- 디버그용 셀
	, @P_TO_SITE			NVARCHAR(50) = NULL   -- 디버그용 도착지
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
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SCP_XLS_PSI_GLOBAL';      
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
	IF @p_is_debug  = 0 
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

    DECLARE @p_program_id   NVARCHAR(30) = 'XLSPSI01'          
    DECLARE @p_to_yyyymmdd  VARCHAR(8)   = ''		--CONVERT(VARCHAR(8), DATEADD(day, 728, @p_plan_start_yyyymmdd), 112)
    DECLARE @p_cutoff_date  VARCHAR(8)   =  CONVERT(VARCHAR(8), DATEADD(day,  -1, @p_plan_start_yyyymmdd), 112)

    --DECLARE @debug_mode            NVARCHAR(30) = 'T'
        BEGIN TRY        
			-------------------------------------------------------------------------------------------------------------
			-- PLAN 기간설정 - 2021.11.19
			-------------------------------------------------------------------------------------------------------------
			DECLARE @v_bp_flag		NVARCHAR(8) = '';

		  	SELECT @p_to_yyyymmdd = p.horizon_end_date,
				   @v_bp_flag  = (case when DATEDIFF(DAY, p.plan_name, p.horizon_end_date) > 364 then 'Y' else 'N' end)
			FROM   dbo.scm_mst_plan p WITH(NOLOCK)
			WHERE  p.division_id = @p_division_id
			AND    p.plan_id     = (SELECT max(plan_id) FROM dbo.scm_mst_plan p WITH(NOLOCK) WHERE division_id = @p_division_id and plan_id < 9999)
			AND    p.plan_cycle  = 'WEEKLY' 
			;	

			IF @v_bp_flag = 'Y'
			BEGIN
				-- 중장기일 경우 104주차로 변경
				SET @p_to_yyyymmdd = CONVERT(VARCHAR(8), DATEADD(day, 363, (CONVERT(VARCHAR(8), DATEADD(day, 364, @p_plan_start_yyyymmdd), 112))), 112);
			END

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

            -------------------------------------------------------------------------------------------------------------------------         
            -- SHIP_PLAN (FG) (팩,셀 공통) - MKT_FCST, SHIP_PLAN
            -------------------------------------------------------------------------------------------------------------------------
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
                  ,ISNULL((SELECT TOP 1 TRANSPORT_MODE FROM SCP_MST_BOD_N_V C where 0 = 0 and C.division_id =A.division_id AND A.BOD_ID = C.BOD_ID AND A.FROM_SITE = C.FROM_SITE	),'-') AS TRANSPORT_MODE
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
                 --INNER JOIN SCM_SYS_CALENDAR_M  C  WITH(NOLOCK) 
                 --   ON A.YYYYMMDD           = C.BASIS_YYYYMMDD				
                 INNER JOIN #MEASURE M WITH(NOLOCK)	
                    ON M.COLUMN_NAME          IN ('SHIP_PLAN','MKT_FCST')
                    AND A.MEASURE             = M.COLUMN_NAME
                 WHERE A.DIVISION_ID			    =  @p_division_id
		                AND A.PLAN_START_YYYYMMDD	=  @p_plan_start_yyyymmdd
		                AND A.PLAN_TYPE				    =  @p_plan_type
		                AND A.SEQ					        =  @p_seq
		                AND A.YYYYMMDD            >=  @p_plan_start_yyyymmdd
		                AND A.YYYYMMDD            <=   @p_to_yyyymmdd           --말일포함 (KSK, 20240814)
                    AND A.MEASURE             IN ('SHIP_PLAN','MKT_FCST')         
					-- 중복값 수정이 안되는 현상 발생하여 제거함 : KSK, 2023-07-10
					--AND PROJECT_CODE != '-'

			IF @p_is_debug = 1 BEGIN 
				SELECT '279' AS "#PSI_GLOBAL", * FROM   #PSI_GLOBAL WHERE YYYYMMDD= @p_plan_start_yyyymmdd 
				AND ITEM_ID = @P_CELL  AND MEASURE = 'SHIP_PLAN' AND TO_SITE = @P_TO_SITE		
			END
            -------------------------------------------------------------------------------------------------------------------------         
            -- SHIP_PLAN (FG) (팩,셀 공통) - WH_IN
            -------------------------------------------------------------------------------------------------------------------------

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
                  ,ISNULL((SELECT TOP 1 TRANSPORT_MODE FROM SCP_MST_BOD_N_V C where 0 = 0 and C.division_id =A.division_id AND A.BOD_ID = C.BOD_ID AND A.FROM_SITE = C.FROM_SITE	),'-') AS TRANSPORT_MODE
                  , '-'              AS PROD_LINE
			            , M.COLUMN_NAME AS MEASURE												-- SHIP_PLAN FG
			            , A.YYYYMMDD        AS YYYYMMDD				
                  , ISNULL(QTY,0)     AS QTY  -- 기존 INTRANSIT 무시하고 모두 0
			            , M.SORT_ORDER_NO									
			            , M.COLUMN_LABEL_NAME							
			            , A.BOD_ID						
                  , 'SCP_ANL_SHIPMENT_PLAN_FG' AS ATTRIBUTE1										
			            , A.ATTRIBUTE9										
	               FROM SCP_ANL_SHIPMENT_PLAN_FG A WITH(NOLOCK)	
                 --INNER JOIN SCM_SYS_CALENDAR_M  C  WITH(NOLOCK) 
                 --   ON A.YYYYMMDD           = C.BASIS_YYYYMMDD				
                 INNER JOIN #MEASURE M WITH(NOLOCK)	
                    ON M.COLUMN_NAME          IN ('WHIN')
                    AND A.MEASURE             = 'WH_IN' --(CASE WHEN M.COLUMN_NAME ='WHIN' THEN 'WH_IN' ELSE M.COLUMN_NAME END )
                 WHERE A.DIVISION_ID			    =  @p_division_id
		                AND A.PLAN_START_YYYYMMDD	=  @p_plan_start_yyyymmdd
		                AND A.PLAN_TYPE				    =  @p_plan_type
		                AND A.SEQ					        =  @p_seq
		                AND A.YYYYMMDD            >=  @p_plan_start_yyyymmdd
		                AND A.YYYYMMDD            <=   @p_to_yyyymmdd          --말일포함 (KSK, 20240814)         
                    AND A.MEASURE             IN ('WH_IN')            



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
                       --INNER JOIN SCM_SYS_CALENDAR_M  C  WITH(NOLOCK) 
                       --   ON A.YYYYMMDD           = C.BASIS_YYYYMMDD				
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
                         AND A.LINE_ID              <> '-'
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



            -------------------------------------------------------------------------------------------------------------------------      
			-- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2)
            -- PACK_PROD, CELL_PROD - CAPA Line Assign(Tact Time) 에 따른 출하/생산계획 추가
            -------------------------------------------------------------------------------------------------------------------------    
			IF OBJECT_ID('tempdb..#LINE_ASSIGN') IS NOT NULL	
				DROP TABLE #LINE_ASSIGN
			IF OBJECT_ID('tempdb..#LINE_ASSIGN_ORG') IS NOT NULL	
				DROP TABLE #LINE_ASSIGN_ORG
	
			SELECT DISTINCT
						TM.DIVISION_ID
					, TM.PLANT_ID AS FROM_SITE_ID
					, TM.LINE_ID
					, TM.ITEM_ID
					, TM.OPERATION_ID
					, TM.COMPANY_ID
					, TM.SITE_ID
					, TM.FACTORY_ID
					, TM.ELECTRODE_TYPE
				INTO #LINE_ASSIGN_ORG
				FROM  SCM_MST_ITEM_LINE_ASSIGN_SN AN WITH (NOLOCK)
						,SCM_MST_TACT_TIME_SN TM WITH (NOLOCK)
				WHERE 1 = 1 
				--AND AN.UPDATE_TIME >= convert(char(8), dateadd(D, -2, getdate()), 112)	-- 2022.11.03 주석해제 :: 불필요 생산계획 생성방지에 따른 최신 PRIORITY 값이 반영되지 않는 현상 개선
				AND AN.DIVISION_ID       = @p_division_id
				AND TM.DIVISION_ID		= AN.DIVISION_ID
				AND TM.COMPANY_ID		= AN.COMPANY_ID
				AND TM.SITE_ID			= AN.SITE_ID
				AND TM.PLANT_ID			= AN.PLANT_ID
				AND TM.FACTORY_ID		= AN.FACTORY_ID
				AND TM.OPERATION_ID		= AN.OPERATION_ID
				AND TM.LINE_ID			= AN.LINE_ID
				AND TM.ELECTRODE_TYPE	= AN.ELECTRODE_TYPE
				AND TM.ITEM_ID			= AN.ITEM_ID
				AND TM.DAILY_CAPA       > 0.0
				AND AN.MONTH            >= LEFT(convert(char(8), getdate(), 112), 6)		-- 2021.08.10 capa. 적용기준 변경
				AND NOT AN.PRIORITY     IN (9, 8)	-- 2022.10.25 미적용기준을 변경
				;
		
		/* 활성화 상태 블록 - 배포보류
			SELECT DISTINCT
						TM.DIVISION_ID
					, TM.PLANT_ID AS FROM_SITE_ID
					, TM.LINE_ID
					, TM.ITEM_ID
					, TM.OPERATION_ID
					, TM.COMPANY_ID
					, TM.SITE_ID
					, TM.FACTORY_ID
					, TM.ELECTRODE_TYPE
				INTO #LINE_ASSIGN_ORG
				FROM  SCM_MST_ITEM_LINE_ASSIGN_SN AN WITH (NOLOCK)
				INNER JOIN SCM_MST_TACT_TIME_SN TM WITH (NOLOCK) 
					ON  TM.DIVISION_ID		= AN.DIVISION_ID
					AND TM.COMPANY_ID		= AN.COMPANY_ID
					AND TM.SITE_ID			= AN.SITE_ID
					AND TM.PLANT_ID			= AN.PLANT_ID
					AND TM.FACTORY_ID		= AN.FACTORY_ID
					AND TM.OPERATION_ID		= AN.OPERATION_ID
					AND TM.LINE_ID			= AN.LINE_ID
					AND TM.ELECTRODE_TYPE	= AN.ELECTRODE_TYPE
					AND TM.ITEM_ID			= AN.ITEM_ID
			  INNER JOIN SCM_LINE_M_SN LM WITH (NOLOCK) 
					ON  LM.DIVISION_ID		= AN.DIVISION_ID
					AND LM.COMPANY_ID		= AN.COMPANY_ID
					AND LM.SITE_ID			= AN.SITE_ID
					AND LM.PLANT_ID			= AN.PLANT_ID
					AND LM.FACTORY_ID		= AN.FACTORY_ID
					AND LM.OPERATION_ID		= AN.OPERATION_ID
					AND LM.LINE_ID			= AN.LINE_ID
					AND LM.ELECTRODE_TYPE	= AN.ELECTRODE_TYPE
				WHERE 1 = 1 
				--AND AN.UPDATE_TIME >= convert(char(8), dateadd(D, -2, getdate()), 112)	-- 2022.11.03 주석해제 :: 불필요 생산계획 생성방지에 따른 최신 PRIORITY 값이 반영되지 않는 현상 개선
				AND AN.DIVISION_ID       = @p_division_id				
				AND TM.DAILY_CAPA       > 0.0
				AND AN.MONTH            >= LEFT(convert(char(8), getdate(), 112), 6)		-- 2021.08.10 capa. 적용기준 변경
				AND NOT AN.PRIORITY     IN (9, 8)	-- 2022.10.25 미적용기준을 변경
				AND LM.ACTIVE_FLAG = 'Y'  --'2024.07.04 활성화 상태 체크 (KSK)
				; */

			-------------------------
			-- 출하/생산계획 추가대상 건 확인
			-------------------------
			SELECT DISTINCT
				   X.DIVISION_ID, X.PLANT_ID, X.ITEM_ID, X.LINE_ID, X.MODEL_ID, X.CHILD_ITEM_ID, X.OPERATION_ID, X.OPERATION_GROUP_ID,
				   X.COMPANY_ID, X.SITE_ID, X.FACTORY_ID, X.ELECTRODE_TYPE,
				   (CASE WHEN X.ITEM_ID = X.CHILD_ITEM_ID THEN 'R' ELSE 'S' END) AS ITEM_TYPE
			  INTO #LINE_ASSIGN
			  FROM (
					SELECT  V1.DIVISION_ID, V1.PLANT_ID, A.ITEM_ID, A.LINE_ID, V1.MODEL_ID, V1.CHILD_ITEM_ID, A.OPERATION_ID, V1.OPERATION_GROUP_ID,
							A.COMPANY_ID, A.SITE_ID, A.FACTORY_ID, A.ELECTRODE_TYPE
					  FROM #LINE_ASSIGN_ORG A WITH (NOLOCK),
						   SCM_MST_MODEL_FINAL_ITEM_BOM_V V1 WITH (NOLOCK)	-- PACK 기준으로 종속된 CELL 까지
					 WHERE V1.DIVISION_ID         =  A.DIVISION_ID
					   AND V1.PLANT_ID            =  A.FROM_SITE_ID
					   AND V1.MODEL_ID            =  A.ITEM_ID   
					   AND V1.OPERATION_GROUP_ID  <> 'E'
					 UNION ALL
					SELECT  V2.DIVISION_ID, V2.PLANT_ID, A.ITEM_ID, A.LINE_ID, V2.MODEL_ID, V2.CHILD_ITEM_ID, A.OPERATION_ID, V2.OPERATION_GROUP_ID,
							A.COMPANY_ID, A.SITE_ID, A.FACTORY_ID, A.ELECTRODE_TYPE
					  FROM #LINE_ASSIGN_ORG A WITH (NOLOCK),
						   SCM_MST_MODEL_FINAL_ITEM_BOM_V V2 WITH (NOLOCK)	-- CELL 단독
					 WHERE V2.DIVISION_ID         =  A.DIVISION_ID
					   AND V2.PLANT_ID            =  A.FROM_SITE_ID
					   AND V2.MODEL_ID            =  A.ITEM_ID
					   AND V2.CHILD_ITEM_ID       =  A.ITEM_ID
					   AND V2.OPERATION_GROUP_ID  = 'A'
				   ) X	   
				   , SCP_MST_FINAL_ITEM Z WITH (NOLOCK)
			where  1 = 1
			   AND Z.DIVISION_ID        = @p_division_id
			   AND Z.FCST_YN            = 'Y'
			   AND X.DIVISION_ID        = Z.DIVISION_ID
			   AND X.ITEM_ID            = Z.ITEM_ID
			   AND X.OPERATION_GROUP_ID = Z.OPERATION_GROUP
			   and x.OPERATION_ID       = Z.FLOW_ID
			   ;

            -----------
			-- 출하계획
			-----------
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
                  ,ISNULL((SELECT TOP 1 TRANSPORT_MODE FROM SCP_MST_BOD_N_V C where 0 = 0 and C.division_id =A.division_id AND A.BOD_ID = C.BOD_ID AND A.FROM_SITE = C.FROM_SITE	),'-') AS TRANSPORT_MODE
                  , '-'              AS PROD_LINE
			            , A.MEASURE												-- SHIP_PLAN FG
			            , A.YYYYMMDD        AS YYYYMMDD				
                  , ISNULL(QTY,0)     AS QTY  -- 기존 INTRANSIT 무시하고 모두 0
			            , M.SORT_ORDER_NO									
			            , M.COLUMN_LABEL_NAME							
			            , A.BOD_ID						
                  , 'SCP_ANL_SHIPMENT_PLAN_FG' AS ATTRIBUTE1										
			            , A.ATTRIBUTE9										
	               FROM (SELECT  DISTINCT 
				                 P.DIVISION_ID
				                ,LN.CHILD_ITEM_ID AS ITEM_ID
								,Y.SH_FG          AS BIZ_TYPE
								,P.PROJECT_CODE
								,P.SALES_SITE_ID  AS TO_SITE
								,P.PLANT_SITE_ID  AS FROM_SITE
								,@p_plan_start_yyyymmdd AS YYYYMMDD
								,B.INCOTERMS
								,B.BOD_ID
								,'SHIP_PLAN' AS MEASURE
								,0           AS QTY
								,NULL        AS ATTRIBUTE9
							FROM SCM_MST_SITE_ITEM_PRIORITY P WITH (NOLOCK),
								#LINE_ASSIGN LN WITH (NOLOCK),
								(SELECT DISTINCT 
										ITEM_ID, MEASURE, BIZ_TYPE AS SH_FG, INCOTERMS, TO_SITE
									FROM SCP_ANL_SHIPMENT_PLAN_FG WITH(NOLOCK)	-- MKT_FCST 존재할 경우만
									WHERE DIVISION_ID         = @p_division_id
									AND PLAN_START_YYYYMMDD   = @p_plan_start_yyyymmdd
									AND PLAN_TYPE             = @p_plan_type
									AND SEQ                   = @p_seq
									AND MEASURE               = 'MKT_FCST'
								) Y,
								SCP_MST_BOD_N_V B WITH (NOLOCK)		-- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 - SCP_MST_BOD_V --> SCP_MST_BOD_N_V
							WHERE P.DIVISION_ID  = LN.DIVISION_ID
							AND P.ITEM_ID      = LN.CHILD_ITEM_ID            
							AND LEFT(P.PLANT_SITE_ID, 4) = LN.PLANT_ID
							-- CAPA Line Assign(Tact Time) 에 따른 생산계획 추가 - SCM_MST_SITE_ITEM_PRIORITY From/To YYYYMMDD 조건변경 - start
							-- 변경전
							--AND P.FROM_YYYYMMDD <= @p_plan_start_yyyymmdd
							--AND P.TO_YYYYMMDD   >= @p_plan_start_yyyymmdd
							--
							-- 변경후
							AND P.FROM_YYYYMMDD <= @p_to_yyyymmdd
							-- CAPA Line Assign(Tact Time) 에 따른 생산계획 추가 - SCM_MST_SITE_ITEM_PRIORITY From/To YYYYMMDD 조건변경 - end
							-- PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 [추가개선] - PRIORITY --> VALID_YN 으로 교체
							--AND P.PRIORITY     = '1'
							AND P.VALID_YN     = 'Y'
							AND Y.ITEM_ID      = P.ITEM_ID
							--AND Y.MEASURE = 'MKT_FCST'		--IN ('MKT_FCST', 'SHIP_REQ')
							AND Y.SH_FG        = LN.operation_group_id		--
							AND B.DIVISION_ID  = LN.DIVISION_ID  
							AND B.FROM_SITE    = P.PLANT_SITE_ID
							AND B.TO_SITE      = P.SALES_SITE_ID
							AND  B.BOD_TYPE     = 'SALES' 
							AND B.BOD_VALID_YN = 'Y'
							AND B.INCOTERMS    = Y.INCOTERMS
							AND B.TO_SITE      = Y.TO_SITE
							AND NOT EXISTS (SELECT 1
											  FROM SCP_ANL_SHIPMENT_PLAN_FG WITH (NOLOCK)	-- 출하계획 존재시 제외
											 WHERE DIVISION_ID = @p_division_id
											   AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
											   AND PLAN_TYPE   = @p_plan_type
											   AND SEQ         = @p_seq
											   AND FROM_SITE   = P.PLANT_SITE_ID
											   AND ITEM_ID     = LN.CHILD_ITEM_ID
											   AND BOD_ID      = B.BOD_ID
											   AND MEASURE     = 'SHIP_PLAN'
											   -- 중복값 수정이 안되는 현상 발생하여 제거함 : KSK, 2023-07-10
											   -- AND PROJECT_CODE != '-'
											   ) 
							) A				
                 INNER JOIN (SELECT M.COLUMN_NAME, M.COLUMN_LABEL_NAME,M.SORT_ORDER_NO,(CASE WHEN ATTRIBUTE1 ='PACK' THEN 'P' WHEN ATTRIBUTE1 ='CELL' THEN 'A'  ELSE 'C' END) AS DIV, ATTRIBUTE2 AS GUBUN
							--INTO #MEASURE
  							FROM SCM_MST_SHEET_MEASURE M WITH(NOLOCK)
							WHERE M.PROGRAM_ID      = @p_program_id
								AND M.VALID_YN        = 'Y') M		
                    ON M.COLUMN_NAME          IN ('SHIP_PLAN','MKT_FCST')
                    AND A.MEASURE             = M.COLUMN_NAME 		   

			IF @p_is_debug = 1 SELECT '560' AS "#PSI_GLOBAL", * FROM   #PSI_GLOBAL WHERE YYYYMMDD= @p_plan_start_yyyymmdd
					AND ITEM_ID = @P_CELL  AND MEASURE = 'SHIP_PLAN' AND TO_SITE = @P_TO_SITE	
			-----------
			-- 생산계획
			-----------
            INSERT INTO #PSI_GLOBAL
               SELECT  
                        X.DIVISION_ID             
                      , LEFT(X.OPERATION_ID, 1) AS OPERATION_GROUP_ID         
                      , '' AS CELL_ITEM_ID          
                      , X.ITEM_ID        
                      , '-' AS  TO_SITE	
                      , '-' AS PROJECT_CODE
                      , 0 AS TO_BOH_QTY        
                      , 0 AS FROM_BOH_QTY	      
                      , '-' AS INCOTERMS           
                      , X.SCM_SITE_ID  AS FROM_SITE
                      , '-'        AS TRANSPORT_MODE
                      , X.LINE_ID   AS PROD_LINE                       
                      , M.COLUMN_NAME AS MEASURE
                      , X.YYYYMMDD                
                      , 0 AS QTY                
                      , M.SORT_ORDER_NO									
			          , M.COLUMN_LABEL_NAME							
			          ,  '-' AS BOD_ID						
                      , 'SCP_ANL_PRODUCTION_PLAN' AS ATTRIBUTE1										
			          , X.OPERATION_ID AS ATTRIBUTE9	                      					
                  FROM (SELECT  DISTINCT			-- LINE ASSIGN + DAILY CAPA + PACK 에 대한 CELL ITEM
								X.DIVISION_ID
							  , S.SCM_SITE_ID
							  , X.ITEM_ID
							  , X.LINE_ID
							  --, X.MODEL_ID
							  --, X.CHILD_ITEM_ID
							  , X.OPERATION_ID
							  , @p_plan_start_yyyymmdd AS YYYYMMDD
						  FROM (
								SELECT DISTINCT
										TM.DIVISION_ID
									  , TM.PLANT_ID
									  , TM.LINE_ID
									  , TM.ITEM_ID
									  , TM.OPERATION_ID 
									  , AN.OPERATION_GROUP_ID
								  FROM #LINE_ASSIGN AN WITH (NOLOCK),
									   SCM_MST_TACT_TIME_SN TM WITH (NOLOCK)
								 WHERE AN.ITEM_TYPE         = 'R'
								   AND TM.DIVISION_ID		= AN.DIVISION_ID
								   AND TM.COMPANY_ID		= AN.COMPANY_ID
								   AND TM.SITE_ID			= AN.SITE_ID
								   AND TM.PLANT_ID			= AN.PLANT_ID
								   AND TM.FACTORY_ID		= AN.FACTORY_ID
								   AND TM.OPERATION_ID		= AN.OPERATION_ID
								   AND TM.LINE_ID			= AN.LINE_ID
								   AND TM.ELECTRODE_TYPE	= AN.ELECTRODE_TYPE
								   AND TM.ITEM_ID			= AN.ITEM_ID
								 UNION ALL
								SELECT DISTINCT
										TM.DIVISION_ID
									  , TM.PLANT_ID
									  , TM.LINE_ID
									  , TM.ITEM_ID
									  , TM.OPERATION_ID 
									  , AN.OPERATION_GROUP_ID
								  FROM #LINE_ASSIGN AN WITH (NOLOCK),
									   SCM_MST_TACT_TIME_SN TM WITH (NOLOCK)
								 WHERE AN.ITEM_TYPE         = 'S'
								   AND TM.DIVISION_ID		= AN.DIVISION_ID
								   AND TM.COMPANY_ID		= AN.COMPANY_ID
								   AND TM.SITE_ID			= AN.SITE_ID
								   AND TM.PLANT_ID			= AN.PLANT_ID
								   AND TM.FACTORY_ID		= AN.FACTORY_ID
								   AND TM.OPERATION_ID	= AN.OPERATION_ID
								   AND TM.LINE_ID			= AN.LINE_ID
								   AND TM.ELECTRODE_TYPE	= AN.ELECTRODE_TYPE
								   AND TM.ITEM_ID			= AN.CHILD_ITEM_ID
								   AND LEFT(TM.OPERATION_ID, 1) = 'A'
							   ) X,
							 --  (SELECT DISTINCT 
								--	   ITEM_ID, MEASURE, BIZ_TYPE AS SH_FG
								--  FROM SCP_ANL_SHIPMENT_PLAN_FG WITH(NOLOCK)	-- MKT_FCST 존재할 경우만
								-- WHERE DIVISION_ID         = @p_division_id
								--   AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
								--   AND PLAN_TYPE           = @p_plan_type
								--   AND SEQ                 = @p_seq
								--   AND MEASURE             = 'MKT_FCST'
								-- UNION ALL
								--SELECT DISTINCT 
								--	   ITEM_ID, MEASURE, 'A' AS SH_FG
								--  FROM SCP_ANL_SHIPMENT_PLAN_SEMI WITH(NOLOCK)
								-- WHERE DIVISION_ID         = @p_division_id
								--   AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
								--   AND PLAN_TYPE           = @p_plan_type
								--   AND SEQ                 = @p_seq
								--   AND MEASURE             IN ( 'MKT_FCST', 'SHIP_REQ' )
							 --  ) Y,
							   (SELECT DIVISION_ID, SCM_SITE_ID, SITE_DESCRIPTION, OPERATION_GROUP
								  FROM SCM_MST_SITE WITH (NOLOCK)
								  WHERE DIVISION_ID = @p_division_id
							   ) S
						 WHERE 1 = 1
						   --AND Y.ITEM_ID = X.ITEM_ID
						   --AND Y.MEASURE = 'MKT_FCST'			--= (CASE WHEN LEFT(X.OPERATION_ID, 1) = 'P' THEN 'MKT_FCST' ELSE 'SHIP_REQ' END)
						   --AND Y.SH_FG   = LEFT(X.OPERATION_ID, 1)
						   AND S.OPERATION_GROUP = X.OPERATION_GROUP_ID
						   AND LEFT(S.SCM_SITE_ID, 4) = X.PLANT_ID
						   AND NOT EXISTS (SELECT 1
										  FROM SCP_ANL_PRODUCTION_PLAN WITH (NOLOCK)	-- 생산계획 존재시 제외
										 WHERE DIVISION_ID = @p_division_id
										   AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
										   AND PLAN_TYPE   = @p_plan_type
										   AND SEQ         = @p_seq
										   AND SCM_SITE_ID = S.SCM_SITE_ID
										   AND ITEM_ID     = X.ITEM_ID
										   AND LINE_ID     = X.LINE_ID
										   AND MEASURE     = 'PROD_PLAN_AMEND')) X 
                       --INNER JOIN SCM_SYS_CALENDAR_M  C  WITH(NOLOCK) 
                       --   ON X.YYYYMMDD           = C.BASIS_YYYYMMDD				
                       INNER JOIN (SELECT M.COLUMN_NAME, M.COLUMN_LABEL_NAME,M.SORT_ORDER_NO,(CASE WHEN ATTRIBUTE1 ='PACK' THEN 'P' WHEN ATTRIBUTE1 ='CELL' THEN 'A'  ELSE 'C' END) AS DIV, ATTRIBUTE2 AS GUBUN
								  --INTO #MEASURE
  								  FROM SCM_MST_SHEET_MEASURE M WITH(NOLOCK)
									WHERE M.PROGRAM_ID      = @p_program_id
									  AND M.VALID_YN        = 'Y') M	
                          ON M.COLUMN_NAME          IN ('PACK_PROD','CELL_PROD')
                          AND (CASE  WHEN LEFT(X.OPERATION_ID, 1) = 'P' THEN 'PACK_PROD' 
                                     WHEN LEFT(X.OPERATION_ID, 1) = 'A' THEN 'CELL_PROD'
                                     ELSE '-' END )  = M.COLUMN_NAME
                      WHERE 1 = 1                 

            -----------         
            -- SHIP_PLAN (SEMI)  -- SEMI_SHIP_PLAN
            -----------
            INSERT INTO #PSI_GLOBAL
                     SELECT   A.DIVISION_ID								
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
	                         FROM (SELECT  LN.DIVISION_ID
							              ,LN.CHILD_ITEM_ID AS ITEM_ID
										  ,B.FROM_SITE
										  ,B.TO_SITE
										  ,B.BOD_ID								  
										  ,@p_plan_start_yyyymmdd AS YYYYMMDD
										  ,'SEMI_SHIP_PLAN' AS MEASURE
										  ,LN.OPERATION_GROUP_ID AS OPERATION_GROUP
										  ,0 AS QTY
										  ,NULL        AS ATTRIBUTE9
									  FROM #LINE_ASSIGN LN WITH (NOLOCK),
										   SCP_MST_BOD_N_V B WITH (NOLOCK)		-- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 - SCP_MST_BOD_V --> SCP_MST_BOD_N_V
									 WHERE LN.OPERATION_GROUP_ID = 'A'
									   AND B.DIVISION_ID  = LN.DIVISION_ID  
									   AND LEFT(B.FROM_SITE, 4) = LN.PLANT_ID
									   AND B.TO_SITE      = (select DISTINCT LN.PLANT_ID + '-P'
															  from SCM_MST_MODEL_FINAL_ITEM_BOM_V V WITH (NOLOCK)
															 where V.MODEL_ID = LN.CHILD_ITEM_ID
															   and V.PLANT_ID = LN.PLANT_ID
															   and V.OPERATION_GROUP_ID  = 'A'
															   and V.electrode_type = '')
									   AND B.BOD_TYPE     = 'PLANT'
									   AND B.BOD_VALID_YN = 'Y'
									   AND NOT EXISTS (SELECT 1
														  FROM SCP_ANL_SHIPMENT_PLAN_SEMI WITH (NOLOCK)	-- SEMI 출하계획 존재시 제외
														 WHERE DIVISION_ID = @p_division_id
														   AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
														   AND PLAN_TYPE   = @p_plan_type
														   AND SEQ         = @p_seq
														   AND FROM_SITE   = B.TO_SITE
														   AND ITEM_ID     = LN.CHILD_ITEM_ID
														   AND BOD_ID      = B.BOD_ID
														   AND MEASURE     = 'SHIP_PLAN') ) A					
                           INNER JOIN  (SELECT M.COLUMN_NAME, M.COLUMN_LABEL_NAME,M.SORT_ORDER_NO,(CASE WHEN ATTRIBUTE1 ='PACK' THEN 'P' WHEN ATTRIBUTE1 ='CELL' THEN 'A'  ELSE 'C' END) AS DIV, ATTRIBUTE2 AS GUBUN
										--INTO #MEASURE
  										FROM SCM_MST_SHEET_MEASURE M WITH(NOLOCK)
										WHERE M.PROGRAM_ID      = @p_program_id
											AND M.VALID_YN        = 'Y') M	
                              ON M.COLUMN_NAME          IN ('SEMI_SHIP_PLAN')
                              AND (CASE A.MEASURE WHEN  'SHIP_PLAN' THEN 'SEMI_SHIP_PLAN' ELSE A.MEASURE  END)              = M.COLUMN_NAME
                           WHERE 1 = 1
						   AND A.ITEM_ID IN (SELECT DISTINCT ITEM_ID
											  FROM SCP_ANL_SHIPMENT_PLAN_FG WITH (NOLOCK)	-- 출하계획 존재시 제외
											 WHERE DIVISION_ID         = @p_division_id
											   AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
											   AND PLAN_TYPE           = @p_plan_type
											   AND SEQ         = @p_seq
											   AND FROM_SITE   = A.FROM_SITE
											   AND ITEM_ID     = A.ITEM_ID
											   AND BOD_ID      = A.BOD_ID
											   AND MEASURE     = 'MKT_FCST') 
						   ;
			-- CAPA Line Assign(Tact Time) 에 따른 생산계획 추가 - end				

					IF OBJECT_ID('TEMPDB..#ANL_SHIPMENT_PLAN_FG') IS NOT NULL 
						DROP TABLE #ANL_SHIPMENT_PLAN_FG

                      SELECT * 
                      INTO #ANL_SHIPMENT_PLAN_FG
                      FROM #PSI_GLOBAL WITH (NOLOCK)
                      WHERE ATTRIBUTE1 = 'SCP_ANL_SHIPMENT_PLAN_FG'

					IF OBJECT_ID('TEMPDB..#ANL_PRODUCTION_PLAN') IS NOT NULL 
						DROP TABLE #ANL_PRODUCTION_PLAN

                      SELECT * 
                      INTO #ANL_PRODUCTION_PLAN
                      FROM #PSI_GLOBAL WITH (NOLOCK)
                      WHERE ATTRIBUTE1 = 'SCP_ANL_PRODUCTION_PLAN'

            -------------------------------------------------------------------------------------------------------------------------         
            -- SHIP_PLAN (SEMI)  -- SEMI_SHIP_PLAN
            -------------------------------------------------------------------------------------------------------------------------
              INSERT INTO #PSI_GLOBAL
                SELECT  X.DIVISION_ID
                       ,X.OPERATION_GROUP
                       ,X.CELL_ITEM_ID
                       ,X.ITEM_ID
                       ,X.TO_SITE
                       ,X.PROJECT_CODE
                       ,X.TO_BOH_QTY
                       ,X.FROM_BOH_QTY
                       ,X.INCOTERMS
                       ,X.FROM_SITE
                       ,X.TRANSPORT_MODE
                       ,X.PROD_LINE
                       ,X.MEASURE
                       ,X.YYYYMMDD
                       ,X.QTY
                       ,X.SORT_ORDER_NO
                       ,X.COLUMN_LABEL_NAME
                       ,MAX(X.BOD_ID) AS BOD_ID   --
                       ,X.ATTRIBUTE1
                       ,X.ATTRIBUTE9
                FROM (

                     SELECT   A.DIVISION_ID								
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

                           INNER JOIN #MEASURE M WITH(NOLOCK)	
                              ON M.COLUMN_NAME          IN ('SEMI_SHIP_PLAN')
                              AND (CASE A.MEASURE WHEN  'SHIP_PLAN' THEN 'SEMI_SHIP_PLAN' ELSE A.MEASURE  END)              = M.COLUMN_NAME
                           WHERE A.DIVISION_ID			    =  @p_division_id
		                          AND A.PLAN_START_YYYYMMDD	=  @p_plan_start_yyyymmdd
		                          AND A.PLAN_TYPE				    =  @p_plan_type
		                          AND A.SEQ					        =  @p_seq
		                          AND A.YYYYMMDD            >=  @p_plan_start_yyyymmdd
		                          AND A.YYYYMMDD            <=   @p_to_yyyymmdd        --말일포함 (KSK, 20240814)  
                              AND A.MEASURE             IN ('SHIP_PLAN')      

                    -- SEMI SEMI_SHIP_PLAN없이 해상재고만 있는 경우 누락되는 로직 수정
                    UNION 
                      SELECT DISTINCT          
                                   @p_division_id            AS DIVISION_ID
                                  ,C.OPERATION_GROUP          
                                  , '' AS CELL_ITEM_ID							
                                  ,A.ITEM_ID                        
                                  ,(SUBSTRING(SITE_ID, 1, DBO.FN_CHARINDEX_REV(SITE_ID, '~', 0)-1))  AS TO_SITE   
                                  , '-' AS PROJECT_CODE
                                  , 0   AS TO_BOH_QTY										
			                            , 0   AS FROM_BOH_QTY									
                                  ,'-'  AS INCOTERMS
                                  ,(SUBSTRING(LOT_ID, DBO.FN_CHARINDEX_REV(LOT_ID, '::', 0)+2,100)) AS FROM_SITE   
                                  ,'SEA' AS TRANSPORT_MODE    -- 해상재고 강제로 'SEA'
                                  , '-'              AS PROD_LINE
                                  , 'SEMI_SHIP_PLAN' AS MEASURE			
                                  , @p_plan_start_yyyymmdd AS YYYYMMDD                 
        --                                ,CONVERT(NVARCHAR(8), A.RECEIVING_DTTM,112) AS YYYYMMDD                 
                                  ,0      AS QTY        
                                  , '360' AS SORT_ORDER_NO									
			                      , 'Semi Ship Plan' AS COLUMN_LABEL_NAME							
			                      , '-'   AS BOD_ID			-- 
                                  ,'SCP_ANL_SHIPMENT_PLAN_SEMI'  AS  ATTRIBUTE1 
                                  , NULL  AS ATTRIBUTE9						
                              FROM DBO.TH_ENG_STOCK_PLAN_SN A WITH (NOLOCK)             
                             INNER JOIN DBO.SCP_MST_FINAL_ITEM_V C  WITH (NOLOCK)           
                                ON 0 = 0
                               AND A.ITEM_ID      = C.ITEM_ID                                               
                             WHERE 1 = 1         
                               AND A.MASTER_ID        = @p_master_id                    
                               AND A.PLAN_ID          = @p_engine_plan_id    
                               AND A.DESCR            = 'INT'       
							   --AND LEFT(A.SITE_ID, 6) = (SELECT TOP 1 S.SCM_SITE_ID FROM SCM_MST_SITE S WITH(NOLOCK) WHERE S.PLANT_ID = LEFT(A.SITE_ID, 6) AND S.PLANT_ID IS NOT NULL)		-- 2021.11.16 SEMI PACK 출하계획생성오류 수정
                                --AND A.ITEM_ID          = 'ACPN1034U-A1'

							   -->>> KSW 2020.09.03 SCP_ANL_SHIPMENT_PLAN_SEMI 건 제외 (중복발생으로 후행삭제 로직에서 삭제되는 문제점 보완) start
							   AND NOT A.ITEM_ID IN (SELECT ITEM_ID 
							                          FROM SCP_ANL_SHIPMENT_PLAN_SEMI WITH (NOLOCK) 
													 WHERE DIVISION_ID			=  @p_division_id
													   AND PLAN_START_YYYYMMDD	=  @p_plan_start_yyyymmdd
													   AND PLAN_TYPE		    =  @p_plan_type
													   AND SEQ					=  @p_seq
													   AND YYYYMMDD             >=  @p_plan_start_yyyymmdd
													   AND YYYYMMDD             <=   @p_to_yyyymmdd       --말일포함 (KSK, 20240814)   
													   AND MEASURE              IN ('SHIP_PLAN'))
							   -->>> KSW 2020.09.03 SCP_ANL_SHIPMENT_PLAN_SEMI 건 제외 (중복발생으로 후행삭제 로직에서 삭제되는 문제점 보완) end

                        ) X

                        GROUP BY X.DIVISION_ID
                               ,X.OPERATION_GROUP
                               ,X.CELL_ITEM_ID
                               ,X.ITEM_ID
                               ,X.TO_SITE
                               ,X.PROJECT_CODE
                               ,X.TO_BOH_QTY
                               ,X.FROM_BOH_QTY
                               ,X.INCOTERMS
                               ,X.FROM_SITE
                               ,X.TRANSPORT_MODE
                               ,X.PROD_LINE
                               ,X.MEASURE
                               ,X.YYYYMMDD
                               ,X.QTY
                               ,X.SORT_ORDER_NO
                               ,X.COLUMN_LABEL_NAME
                               ,X.ATTRIBUTE1
                               ,X.ATTRIBUTE9
							   

                      SELECT * 
                      INTO #ANL_SHIPMENT_PLAN_SEMI
                      FROM #PSI_GLOBAL WITH (NOLOCK)
                      WHERE ATTRIBUTE1 = 'SCP_ANL_SHIPMENT_PLAN_SEMI'

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
                                      , 'CELL_CHAR_PLAN'     AS MEASURE                    -- ACTIVATE_COMPLETED
                                      , YYYYMMDD                                
                                      , 0 AS QTY
                                      , '440' AS SORT_ORDER_NO									
			                                , 'Char. Plan' AS COLUMN_LABEL_NAME							
			                                ,  '-' AS BOD_ID						
                                      , '' AS ATTRIBUTE1										
			                                , '' AS ATTRIBUTE9							
                                 FROM #ANL_PRODUCTION_PLAN  A WITH (NOLOCK)
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
                                      , 'CELL_CHAR_PLAN'     AS MEASURE                    -- ACTIVATE_COMPLETED
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

                    GROUP BY 
                               X.DIVISION_ID        
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
--                        , X.PROD_LINE         
                             , X.MEASURE           
                             , X.YYYYMMDD          
                             --, MAX(X.QTY) AS QTY
                             , X.SORT_ORDER_NO			
                             , X.COLUMN_LABEL_NAME	
                             , X.BOD_ID						
                             --, X.ATTRIBUTE1				
                             --, X.ATTRIBUTE9	

            
                      SELECT * 
                      INTO #SCP_PLN_PRODUCTION_PLAN
                      FROM #PSI_GLOBAL WITH (NOLOCK)
                      WHERE ATTRIBUTE1 = 'SCP_PLN_PRODUCTION_PLAN'



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
                    ,BOD_ID				       
                    --,ATTRIBUTE1			     
                    --,ATTRIBUTE9					     

IF @p_is_debug = 1 SELECT '1119' AS #ITEM_ID, * FROM   #ITEM_ID WHERE YYYYMMDD= @p_plan_start_yyyymmdd
								AND ITEM_ID = @P_CELL  AND MEASURE = 'SHIP_PLAN' AND TO_SITE = @P_TO_SITE				                                     

              
               IF OBJECT_ID('tempdb..#PSI_GLOBAL_AUTO') IS NOT NULL      
	              DROP TABLE #PSI_GLOBAL_AUTO;        

	              CREATE TABLE #PSI_GLOBAL_AUTO (
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
		            ,BOD_ID				     NVARCHAR(300)
                  ,ATTRIBUTE1			      NVARCHAR(150)
		              ,ATTRIBUTE9			      NVARCHAR(150)   -- OPERATION_ID
	              );

            -------------------------------------------------------------------------------------------------------------------------         
            -- MEASURE 추가 : ITEM_ID별 (MKT_FCST_PACK_TOTAL)
            -------------------------------------------------------------------------------------------------------------------------
            INSERT #PSI_GLOBAL_AUTO
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

IF @p_is_debug = 1 SELECT '1180' AS #PSI_GLOBAL_AUTO_1180, * FROM   #PSI_GLOBAL_AUTO WHERE YYYYMMDD= @p_plan_start_yyyymmdd
								AND ITEM_ID = @P_CELL  AND MEASURE = 'SHIP_PLAN' AND TO_SITE = @P_TO_SITE					

            -------------------------------------------------------------------------------------------------------------------------         
            -- MEASURE 추가 : PACK TO SITE별 (ALLOCATION, GAP_FCST_RTF, WH_IN_BALANCE, TO_SITE_BOH, TO_SITE_EOH, WHIN_TOTAL)
            -------------------------------------------------------------------------------------------------------------------------
            INSERT #PSI_GLOBAL_AUTO
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
                AND M.DIV       ='C'  AND M.GUBUN       = 'TO' --ALLOCATION/FCST_RTF_ACC/FCST_RTF_GAP/MKT_FCST/TO_SITE_BOH/TO_SITE_EOH/WHIN_BALANCE/WHIN_TOTAL
                AND X.MEASURE   = 'MKT_FCST'
IF @p_is_debug = 1 SELECT '1212' AS #PSI_GLOBAL_AUTO_1212, * FROM   #PSI_GLOBAL_AUTO WHERE YYYYMMDD= @p_plan_start_yyyymmdd
								AND ITEM_ID = @P_CELL  AND MEASURE = 'SHIP_PLAN' AND TO_SITE = @P_TO_SITE					

            -------------------------------------------------------------------------------------------------------------------------         
            -- MEASURE 추가 : PACK FROM SITE별 (WHIN,INTRANSIT,INTRANSIT_ETA,SHIP_PLAN_ETD,SHIP_PLAN_PLANT)
            -------------------------------------------------------------------------------------------------------------------------
            INSERT #PSI_GLOBAL_AUTO
              SELECT  DISTINCT  X.DIVISION_ID								
			                        , X.OPERATION_GROUP						
			                        , X.CELL_ITEM_ID							
			                        , X.ITEM_ID										
			                        , X.TO_SITE
                              , (CASE WHEN M.COLUMN_NAME   = 'SHIP_PLAN' THEN X.PROJECT_CODE ELSE '-' END) AS PROJECT_CODE
			                        , X.TO_BOH_QTY										
			                        , X.FROM_BOH_QTY									
			                        , X.INCOTERMS 										
			                        , X.FROM_SITE 										
                              , (CASE WHEN M.COLUMN_NAME   = 'SHIP_PLAN' THEN X.TRANSPORT_MODE ELSE '-' END) AS TRANSPORT_MODE
                              , X.PROD_LINE
			                        , M.COLUMN_NAME AS MEASURE
						                  , X.YYYYMMDD	
                              , 0    AS QTY
			                        , M.SORT_ORDER_NO								
			                        , M.COLUMN_LABEL_NAME							
			                        , (CASE WHEN M.COLUMN_NAME = 'SHIP_PLAN' THEN BOD_ID  ELSE '-' END) AS BOD_ID
                              , X.ATTRIBUTE1										
			                        , X.ATTRIBUTE9										
              FROM #ITEM_ID X WITH(NOLOCK)     
              CROSS APPLY #MEASURE M WITH (NOLOCK)                                 
              WHERE 1=1          
                AND M.DIV       ='C' AND M.GUBUN     = 'FROM' --INTRANSIT/INTRANSIT_ETA/SHIP_PLAN/SHIP_PLAN_ETA/SHIP_PLAN_PLANT/WHIN
				AND M.COLUMN_NAME <> 'WHIN'	     --KSK(250430, 멀티구간 BOD)				 
                AND X.MEASURE   IN ( 'SHIP_PLAN')

IF @p_is_debug = 1 SELECT '1247' AS #PSI_GLOBAL_AUTO_1246, * FROM   #PSI_GLOBAL_AUTO WHERE YYYYMMDD= @p_plan_start_yyyymmdd
								AND ITEM_ID = @P_CELL  AND TO_SITE = @P_TO_SITE	 --AND MEASURE = 'SHIP_PLAN'

			  INSERT #PSI_GLOBAL_AUTO
              SELECT  DISTINCT  X.DIVISION_ID								
			                        , X.OPERATION_GROUP						
			                        , X.CELL_ITEM_ID							
			                        , X.ITEM_ID										
			                        , X.TO_SITE
                              ,'-' AS PROJECT_CODE
			                        , X.TO_BOH_QTY										
			                        , X.FROM_BOH_QTY									
			                        , X.INCOTERMS 										
			                        , X.FROM_SITE 										
                              , '-' AS TRANSPORT_MODE
                              , X.PROD_LINE
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
                AND M.DIV       ='C' AND M.GUBUN     = 'FROM' --INTRANSIT/INTRANSIT_ETA/SHIP_PLAN/SHIP_PLAN_ETA/SHIP_PLAN_PLANT/WHIN
				AND M.COLUMN_NAME = 'WHIN'   
                AND X.MEASURE   IN (  'WHIN')

IF @p_is_debug = 1 SELECT '1278' AS #PSI_GLOBAL_AUTO_1246, * FROM   #PSI_GLOBAL_AUTO WHERE YYYYMMDD= @p_plan_start_yyyymmdd 	
								AND ITEM_ID = @P_CELL  AND TO_SITE = @P_TO_SITE	 AND MEASURE = 'SHIP_PLAN'	

			-- 2022.10.19   KSW			Memo measure 추가 :: SHIP_PLAN_MEMO measure 생성 - START
            INSERT #PSI_GLOBAL_AUTO
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
                AND M.GUBUN     = 'FROM'
                AND X.MEASURE   = 'SHIP_PLAN'
				AND M.COLUMN_NAME = 'SHIP_PLAN_MEMO'
				;
			-- 2022.10.19   KSW			Memo measure 추가 :: SHIP_PLAN_MEMO measure 생성 - END
IF @p_is_debug = 1 SELECT '1312' AS #PSI_GLOBAL_AUTO, * FROM   #PSI_GLOBAL_AUTO WHERE YYYYMMDD= @p_plan_start_yyyymmdd
								AND ITEM_ID = @P_CELL  AND MEASURE = 'SHIP_PLAN' AND TO_SITE = @P_TO_SITE	
            -------------------------------------------------------------------------------------------------------------------------         
            -- MEASURE 추가 : PACK FROM SITE별 (PACK_BOH,PACK_EOH,PACK_PROD,PACK_PROD_LOAD,PACK_CELL_BOH,PACK_CELL_EOH) 
            -------------------------------------------------------------------------------------------------------------------------
            INSERT #PSI_GLOBAL_AUTO
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
                              , (CASE WHEN M.COLUMN_NAME  IN ( 'PACK_BOH','CELL_BOH','PACK_EOH','CELL_EOH', 'PACK_BOH_HOLD', 'PACK_BOH_WAIT_FOR_INSP', 'PACK_BOH_EXP_INSP_DATE')  THEN '-' ELSE X.PROD_LINE END) AS PROD_LINE		-- PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 - 전진검사
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
				-- 전진검사 MEASURE 는 대상 모델만 추가
				AND (CASE WHEN M.COLUMN_NAME IN ('PACK_BOH_WAIT_FOR_INSP', 'PACK_BOH_EXP_INSP_DATE') THEN 
				               (CASE WHEN ISNULL((SELECT DISTINCT ITEM_ID
											  FROM SCP_MST_OPERATION_LT C WITH (NOLOCK)
											 WHERE C.DIVISION_ID = '81'
											   AND C.SCM_SITE_ID = X.FROM_SITE
											   AND C.ITEM_ID     = X.ITEM_ID
											   AND C.LT_OPERATION = 'PRE_INSP'
											   AND C.ATTRIBUTE1   = 'Y'
										   ), 'N') = 'N' THEN 'N' ELSE 'Y'
							    END) ELSE 'Y'
				     END) = 'Y'


            /*
            -------------------------------------------------------------------------------------------------------------------------        
            -- MEASURE 추가 : CELL_ITEM_ID별 (MKT_FCST_CELL_TOTAL)
            -------------------------------------------------------------------------------------------------------------------------
            INSERT #PSI_GLOBAL_AUTO
              SELECT  DISTINCT  X.DIVISION_ID								
			                        , 'A' OPERATION_GROUP						
			                        , X.CELL_ITEM_ID							
			                        , '-' AS ITEM_ID
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
                              , 'MKT_FCST_CELL_TOTAL' AS ATTRIBUTE1										
			                        , X.ATTRIBUTE9										
              FROM #ITEM_ID X WITH(NOLOCK)     
              CROSS APPLY #MEASURE M WITH (NOLOCK)                                 
              WHERE 1=1          
                AND M.DIV       ='C' 
                AND M.GUBUN       = 'CELL_ITEM_ID'
                AND X.MEASURE     = 'MKT_FCST'
            --    AND X.OPERATION_GROUP ='A'
            */

            -------------------------------------------------------------------------------------------------------------------------         
            -- MEASURE 추가 : CELL TO   SITE별 (SEMI_WHIN_TOTAL) 
            -- MEASURE 추가 : CELL FROM SITE별 (SEMI_WHIN,SEMI_INTRANSIT,SEMI_INTRANSIT_ETA,SEMI_SHIP_PLAN_ETA,SEMI_SHIP_PLAN) 
            -------------------------------------------------------------------------------------------------------------------------
            INSERT #PSI_GLOBAL_AUTO
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
                              , (CASE WHEN M.COLUMN_NAME   IN ('SEMI_SHIP_PLAN','SEMI_SHIP_PLAN_MEMO') THEN X.TRANSPORT_MODE ELSE '-' END) AS TRANSPORT_MODE		-- 2022.10.19   KSW			Memo measure 추가 :: IN 으로 변경하고 SEMI_SHIP_PLAN_MEMO 추가
                              , X.PROD_LINE
			                        , M.COLUMN_NAME AS MEASURE
						                  , X.YYYYMMDD	
                              , 0    AS QTY
			                        , M.SORT_ORDER_NO								
			                        , M.COLUMN_LABEL_NAME							
			                        , (CASE WHEN M.COLUMN_NAME IN ('SEMI_SHIP_PLAN','SEMI_SHIP_PLAN_MEMO') THEN X.BOD_ID  ELSE '-' END) AS BOD_ID		-- 2022.10.19   KSW			Memo measure 추가 :: IN 으로 변경하고 SEMI_SHIP_PLAN_MEMO 추가
                              , X.ATTRIBUTE1
                              , X.ATTRIBUTE9										
              FROM #ITEM_ID X WITH(NOLOCK)     
              CROSS APPLY #MEASURE M WITH (NOLOCK)                                 
              WHERE 1=1          
                AND M.DIV       ='A' 
                AND M.GUBUN     = 'FROM'
                AND M.COLUMN_NAME LIKE 'SEMI%'
                AND X.MEASURE   = 'SEMI_SHIP_PLAN'
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
                AND X.MEASURE   = 'SEMI_SHIP_PLAN'
                AND X.OPERATION_GROUP   = 'A'

				IF @p_is_debug = 1 SELECT '1457' AS #PSI_GLOBAL_AUTO, * FROM   #PSI_GLOBAL_AUTO WHERE YYYYMMDD= @p_plan_start_yyyymmdd
					AND ITEM_ID = @P_CELL  AND MEASURE = 'SHIP_PLAN' AND TO_SITE = @P_TO_SITE	

                
            -------------------------------------------------------------------------------------------------------------------------         
            -- MEASURE 추가 : CELL FROM SITE별 (CELL_BOH,CELL_EOH,CELL_SHIP_PLAN_TOTAL,CELL_CHAR_PLAN
            --                                 ,CELL_CHAR_AVAILABLE,CELL_FORM_PROGRESS,CELL_FORM_HOLD,CELL_FOR_FORM_END,CELL_PROD_FORM_END
            -------------------------------------------------------------------------------------------------------------------------
            INSERT #PSI_GLOBAL_AUTO
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
                              , '-' AS  PROD_LINE
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
                AND M.COLUMN_NAME NOT IN ('CELL_PROD','CELL_PROD_LOAD', 'CELL_PROD_MEMO')		-- 2022.10.19   KSW			Memo measure 추가

            -------------------------------------------------------------------------------------------------------------------------         
            -- MEASURE 추가 : CELL FROM SITE별 (CELL_PROD,CELL_PROD_LOAD) 
            -------------------------------------------------------------------------------------------------------------------------

               INSERT #PSI_GLOBAL_AUTO
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
                              , X.ATTRIBUTE1										
			                        , X.ATTRIBUTE9										
              FROM #ITEM_ID X WITH(NOLOCK)     
              CROSS APPLY #MEASURE M WITH (NOLOCK)                                 
              WHERE 1=1          
                AND M.DIV       ='A' 
                AND M.GUBUN     = 'FROM'
                AND X.OPERATION_GROUP   = 'A'
                AND M.COLUMN_NAME IN ('CELL_PROD','CELL_PROD_LOAD', 'CELL_PROD_MEMO')		-- 2022.10.19   KSW			Memo measure 추가
                AND X.PROD_LINE <> '-'


			
            -------------------------------------------------------------------------------------------------------------------------         
            -- MEASURE 0 추가 : 
            -------------------------------------------------------------------------------------------------------------------------
        --        INSERT #PSI_GLOBAL_AUTO
        --        SELECT  DIVISION_ID		   
        --               ,OPERATION_GROUP	 
        --               ,CELL_ITEM_ID		   
        --               ,ITEM_ID			     
        --               ,TO_SITE			     
        --               ,PROJECT_CODE      
        --               ,TO_BOH_QTY			   
        --               ,FROM_BOH_QTY		   
        --               ,INCOTERMS			   
        --               ,FROM_SITE			   
        --               ,TRANSPORT_MODE    
        --               ,PROD_LINE         
        --               ,MEASURE			     
        --               , Y.YYYYMMDD     
        --               ,'0' AS QTY				       
        --               ,SORT_ORDER_NO		 
        --               ,COLUMN_LABEL_NAME	
        --               ,BOD_ID				     
        --               ,ATTRIBUTE1			   
        --               ,ATTRIBUTE9			   
        --         FROM #PSI_GLOBAL_AUTO X WITH (NOLOCK)
        --         CROSS APPLY 
        --         (  -- 364 DAYS      
        --               SELECT C.BASIS_YYYYMMDD AS YYYYMMDD          
        --                FROM SCM_SYS_CALENDAR_M    C WITH(NOLOCK)         
        --               WHERE 1=1      
        --               --AND C.BASIS_YYYYMMDD > @p_plan_start_yyyymmdd       -- 엔진시작일 제외
        --               --AND C.BASIS_YYYYMMDD <  @p_to_yyyymmdd  
					   --AND C.BASIS_YYYYMMDD IN ( @p_plan_start_yyyymmdd, CONVERT(VARCHAR(8), DATEADD(day, 364, @p_plan_start_yyyymmdd), 112))
        --          ) Y
        --        WHERE 0 = 0

		-- 중복생성으로 인한 수량중복을 방지하기 위해서 임시작업 테이블에 저장
				IF OBJECT_ID('tempdb..#tmp_PSI_GLOBAL_AUTO') IS NOT NULL	
						DROP TABLE #tmp_PSI_GLOBAL_AUTO		

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
				 INTO #tmp_PSI_GLOBAL_AUTO
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
				         FROM #PSI_GLOBAL_AUTO WITH (NOLOCK)
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

				BEGIN
					-- 0 값(플랜시작일자만)이 추가된 작업용 테이블의 DATA 를 #PSI_GLOBAL_AUTO 으로 복제
					DELETE #PSI_GLOBAL_AUTO;
					INSERT #PSI_GLOBAL_AUTO
				    SELECT *
					  FROM #tmp_PSI_GLOBAL_AUTO X WITH (NOLOCK)
				END

               IF OBJECT_ID('tempdb..#tmp_PSI_GLOBAL_AUTO') IS NOT NULL      
	              DROP TABLE #tmp_PSI_GLOBAL_AUTO; 




                 -- MKT_FCST
--                UPDATE X
--                SET X.QTY = Y.QTY
--                FROM #PSI_GLOBAL_AUTO X  WITH (NOLOCK)
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

				MERGE INTO #PSI_GLOBAL_AUTO AS X
				USING (SELECT DIVISION_ID
							,OPERATION_GROUP
							,CELL_ITEM_ID	
							,ITEM_ID
							,TO_SITE
							, '-'               AS PROJECT_CODE			-- 중복방지							
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


    --            UPDATE X
    --            SET X.QTY = Y.QTY
    --            FROM #PSI_GLOBAL_AUTO X  WITH (NOLOCK)
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
				--AND X.BOD_ID          = Y.BOD_ID			-- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 BOD_ID 추가
    --            AND X.MEASURE         = 'SHIP_PLAN'

				MERGE INTO #PSI_GLOBAL_AUTO AS X
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
						WHERE MEASURE         = 'SHIP_PLAN' 
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
                AND X.MEASURE         = 'SHIP_PLAN'
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

		IF @p_is_debug = 1 SELECT '1883' AS #PSI_GLOBAL_AUTO, * FROM   #PSI_GLOBAL_AUTO WHERE YYYYMMDD= @p_plan_start_yyyymmdd
					AND ITEM_ID = @P_CELL  AND MEASURE = 'SHIP_PLAN' AND TO_SITE = @P_TO_SITE	



				MERGE INTO #PSI_GLOBAL_AUTO AS X
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
				


				MERGE INTO #PSI_GLOBAL_AUTO AS X
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


                -- PRODUCTION
                --UPDATE X
                --SET X.QTY = Y.QTY
                --FROM #PSI_GLOBAL_AUTO X  WITH (NOLOCK)
                --INNER JOIN #SCP_PLN_PRODUCTION_PLAN Y  WITH (NOLOCK)
                --ON 0 = 0
                --AND X.TO_SITE   = Y.TO_SITE
                --AND X.FROM_SITE = Y.FROM_SITE
                --AND X.MEASURE   = Y.MEASURE
                --AND X.YYYYMMDD  = Y.YYYYMMDD
                --AND X.ITEM_ID   = Y.ITEM_ID
                --AND X.PROD_LINE = Y.PROD_LINE

				MERGE INTO #PSI_GLOBAL_AUTO AS X
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



            -------------------------------------------------------------------------------------------------------------         
            -- INTRANSIT 반영
            -------------------------------------------------------------------------------------------------------------
                  SELECT 
                        X.DIVISION_ID 
                        ,PLAN_START_YYYYMMDD
                        ,PLAN_TYPE
                        ,SEQ
                        ,X.OPERATION_GROUP
                        ,ITEM_ID
                        ,INCOTERMS
                        ,TO_SITE
                        ,FROM_SITE
                        --,MEASURE
                        ,YYYYMMDD
                        ,SUM(QTY) AS QTY
                        , X.ATTRIBUTE1
						-- TODO : SALES와 PLANT로 분리하여 처리토록
						, SITE_TYPE
                  INTO #INTRANSIT
                  FROM (
                          SELECT                          
                                 @p_division_id            AS DIVISION_ID
                                ,@p_plan_start_yyyymmdd   AS PLAN_START_YYYYMMDD
                                ,@p_plan_type             AS PLAN_TYPE 
                                ,@p_seq                   AS SEQ 
                                ,C.OPERATION_GROUP                        
                                ,A.ITEM_ID                        
                                ,dbo.FN_SCM_SPLIT(A.SITE_ID, 2,'~') AS INCOTERMS
                                ,(SUBSTRING(SITE_ID, 1, DBO.FN_CHARINDEX_REV(SITE_ID, '~', 0)-1))  AS TO_SITE   
                                ,(SUBSTRING(LOT_ID, DBO.FN_CHARINDEX_REV(LOT_ID, '::', 0)+2,100)) AS FROM_SITE   
                                ,CONVERT(NVARCHAR(8), A.RECEIVING_DTTM,112) AS YYYYMMDD                 
                                ,(A.QTY)     AS QTY        
                                ,'TH_ENG_STOCK_PLAN_SN'  AS  ATTRIBUTE1 
                            FROM DBO.TH_ENG_STOCK_PLAN_SN A WITH (NOLOCK)             
                            INNER JOIN DBO.SCP_MST_FINAL_ITEM_V C  WITH (NOLOCK)           
                               ON 0 = 0
                               AND A.ITEM_ID      = C.ITEM_ID                                               
                            WHERE 1 = 1         
                              AND A.MASTER_ID        = @p_master_id                     
                              AND A.PLAN_ID          = @p_engine_plan_id    
                              AND A.DESCR            = 'INT'    
							  --AND LEFT(A.SITE_ID, 6) = (SELECT TOP 1 S.SCM_SITE_ID FROM SCM_MST_SITE S WITH(NOLOCK) WHERE S.PLANT_ID = LEFT(A.SITE_ID, 6) AND S.PLANT_ID IS NOT NULL)		-- 2021.11.16 SEMI PACK 출하계획생성오류 수정							 
                          ) X
					LEFT JOIN DBO.SCM_MST_SITE S WITH (NOLOCK)	   -- 250105(KSK) PLAN_TYPE 추가
						ON S.DIVISION_ID = X.DIVISION_ID
						AND S.SCM_SITE_ID = X.TO_SITE			
                    GROUP BY X.DIVISION_ID 
                    ,PLAN_START_YYYYMMDD
                    ,PLAN_TYPE
                    ,SEQ
                    ,X.OPERATION_GROUP
                    ,ITEM_ID
                    ,INCOTERMS
                    ,TO_SITE
					, S.SITE_TYPE
                    ,FROM_SITE
                    --,MEASURE
                    ,YYYYMMDD
                    , X.ATTRIBUTE1
                    ;

                 -- SEMI_INTRANSIT_ETA  --> SEMI_INTRANSIT,
                 -- INTRANSIT_ETA       --> INTRANSIT
                 
                 --UPDATE X
                 --   SET X.QTY = ISNULL(Y.QTY,0)
                 --  FROM #PSI_GLOBAL_AUTO X  WITH (NOLOCK)
                 --  INNER JOIN #INTRANSIT Y  WITH (NOLOCK)
                 --     ON X.ITEM_ID    = Y.ITEM_ID  
                 --    AND X.INCOTERMS  = Y.INCOTERMS
                 --    AND X.TO_SITE    = Y.TO_SITE   
                 --    AND X.FROM_SITE  = Y.FROM_SITE
                 --    AND X.YYYYMMDD   = Y.YYYYMMDD 
                 --    AND X.MEASURE    = 'INTRANSIT_ETA'

				MERGE INTO #PSI_GLOBAL_AUTO AS X
				USING (SELECT A.DIVISION_ID
							,A.OPERATION_GROUP
							,''              AS CELL_ITEM_ID	
							,A.ITEM_ID
							,A.TO_SITE
							,'-'             AS PROJECT_CODE
							,0               AS TO_BOH_QTY
							,0               AS FROM_BOH_QTY
							,A.INCOTERMS
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
					   AND A.SITE_TYPE = 'SALES'
						GROUP BY A.DIVISION_ID
							,A.OPERATION_GROUP
							,A.ITEM_ID
							,A.TO_SITE
							,A.INCOTERMS
							,A.FROM_SITE
							,A.YYYYMMDD
							,B.SORT_ORDER_NO
							,B.COLUMN_LABEL_NAME
				      ) AS Y
				ON  X.ITEM_ID    = Y.ITEM_ID  
                AND X.INCOTERMS  = Y.INCOTERMS
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

				IF @P_IS_DEBUG = 1  SELECT  2383  RNO,   GETDATE() - @d_event_date  ELAPSED  

                 --UPDATE X
                 --   SET X.QTY = ISNULL(Y.QTY,0)
                 --  FROM #PSI_GLOBAL_AUTO X  WITH (NOLOCK)
                 --  INNER JOIN #INTRANSIT Y  WITH (NOLOCK)
                 --     ON X.ITEM_ID    = Y.ITEM_ID                        
                 --    AND X.TO_SITE    = Y.TO_SITE   
                 --    AND X.FROM_SITE  = Y.FROM_SITE
                 --    AND X.YYYYMMDD   = Y.YYYYMMDD 
                 --    AND X.MEASURE    = 'SEMI_INTRANSIT_ETA'          
				-- 2022.05.17 중복오류 수정 
				MERGE INTO #PSI_GLOBAL_AUTO AS X
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
					  FROM (
							SELECT A.DIVISION_ID
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
								AND A.SITE_TYPE = 'PLANT'
								GROUP BY A.DIVISION_ID
									,A.OPERATION_GROUP
									,A.ITEM_ID
									,A.TO_SITE
									,A.INCOTERMS
									,A.FROM_SITE
									,A.YYYYMMDD
									,B.SORT_ORDER_NO
									,B.COLUMN_LABEL_NAME
								) XX
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


                 --UPDATE X
                 --   SET X.FROM_BOH_QTY = Z.FROM_BOH_QTY
                 --  FROM #PSI_GLOBAL_AUTO X  WITH (NOLOCK)
                 --  INNER JOIN (SELECT ITEM_ID, FROM_SITE,TO_SITE,INCOTERMS, SUM(Y.QTY) AS FROM_BOH_QTY
                 --                FROM #INTRANSIT Y
                 --               GROUP BY ITEM_ID, FROM_SITE,TO_SITE,INCOTERMS
                 --            )  Z 
                 --     ON X.ITEM_ID    = Z.ITEM_ID
                 --    AND X.INCOTERMS  = Z.INCOTERMS
                 --    AND X.FROM_SITE  = Z.FROM_SITE
                 --    AND X.TO_SITE    = Z.TO_SITE
                 --    AND X.MEASURE    = 'INTRANSIT'

			 IF @P_IS_DEBUG = 1  SELECT  2534  RNO,   GETDATE() - @d_event_date  ELAPSED


				MERGE INTO #PSI_GLOBAL_AUTO AS X
				USING (SELECT A.DIVISION_ID
							,A.OPERATION_GROUP
							,''              AS CELL_ITEM_ID	
							,A.ITEM_ID
							,A.TO_SITE
							,'-'             AS PROJECT_CODE
							,0               AS TO_BOH_QTY
							,SUM(QTY)        AS FROM_BOH_QTY
							,A.INCOTERMS
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
							,A.INCOTERMS
							,A.FROM_SITE
							,B.SORT_ORDER_NO
							,B.COLUMN_LABEL_NAME
				      ) AS Y
				ON  X.ITEM_ID    = Y.ITEM_ID  
                AND X.INCOTERMS  = Y.INCOTERMS
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
						,@p_plan_start_yyyymmdd
						,Y.QTY
						,Y.SORT_ORDER_NO
						,Y.COLUMN_LABEL_NAME
						,Y.BOD_ID
						,Y.ATTRIBUTE1
				       );

		IF @P_IS_DEBUG = 1  BEGIN 
			SELECT  2620  RNO,   GETDATE() - @d_event_date  ELAPSED			
		END

                 --UPDATE X
                 --   SET X.FROM_BOH_QTY = Z.FROM_BOH_QTY
                 --  FROM #PSI_GLOBAL_AUTO X  WITH (NOLOCK)
                 --  INNER JOIN (SELECT ITEM_ID, FROM_SITE,TO_SITE, SUM(Y.QTY) AS FROM_BOH_QTY
                 --                FROM #INTRANSIT Y
                 --               GROUP BY ITEM_ID, FROM_SITE,TO_SITE
                 --            )  Z 
                 --     ON X.ITEM_ID    = Z.ITEM_ID                        
                 --    AND X.FROM_SITE  = Z.FROM_SITE
                 --    AND X.TO_SITE    = Z.TO_SITE
                 --    AND X.MEASURE    = 'SEMI_INTRANSIT'
				-- 중복오류 수정 :: 2022.05.17
				MERGE INTO #PSI_GLOBAL_AUTO AS X
				USING (SELECT DIVISION_ID
							,OPERATION_GROUP
							,CELL_ITEM_ID	
							,ITEM_ID
							,TO_SITE
							,PROJECT_CODE
							,TO_BOH_QTY
							,SUM(FROM_BOH_QTY)        AS FROM_BOH_QTY
							,INCOTERMS
							,FROM_SITE
							,TRANSPORT_MODE
							,PROD_LINE
							,MEASURE
							,QTY
							,SORT_ORDER_NO
							,COLUMN_LABEL_NAME
							,BOD_ID
							,ATTRIBUTE1
						FROM (
								SELECT A.DIVISION_ID
										,A.OPERATION_GROUP
										,''              AS CELL_ITEM_ID	
										,A.ITEM_ID
										,A.TO_SITE
										,'-'             AS PROJECT_CODE
										,0               AS TO_BOH_QTY
										,SUM(QTY)        AS FROM_BOH_QTY
										,'-'             AS INCOTERMS
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
										,A.INCOTERMS
										,A.FROM_SITE
										,B.SORT_ORDER_NO
										,B.COLUMN_LABEL_NAME
							) XX
							GROUP BY DIVISION_ID
							,OPERATION_GROUP
							,CELL_ITEM_ID	
							,ITEM_ID
							,TO_SITE
							,PROJECT_CODE
							,TO_BOH_QTY
							,INCOTERMS
							,FROM_SITE
							,TRANSPORT_MODE
							,PROD_LINE
							,MEASURE
							,QTY
							,SORT_ORDER_NO
							,COLUMN_LABEL_NAME
							,BOD_ID
							,ATTRIBUTE1
				      ) AS Y
				ON  X.ITEM_ID    = Y.ITEM_ID  
                AND X.INCOTERMS  = Y.INCOTERMS
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
						,@p_plan_start_yyyymmdd
						,Y.QTY
						,Y.SORT_ORDER_NO
						,Y.COLUMN_LABEL_NAME
						,Y.BOD_ID
						,Y.ATTRIBUTE1
				       );

		IF @P_IS_DEBUG = 1  BEGIN 
			SELECT  2759  RNO,   GETDATE() - @d_event_date  ELAPSED			
		END

            -------------------------------------------------------------------------------------------------------------         
            -- CELL_FOR_FORM_END
            -------------------------------------------------------------------------------------------------------------  
            IF OBJECT_ID('tempdb..#PLN_TH_ENG_STOCK_PLAN') IS NOT NULL	
	                DROP TABLE #PLN_TH_ENG_STOCK_PLAN

              SELECT SUBSTRING(A.MASTER_ID,1,2) AS DIVISION_ID
                      ,SUBSTRING(A.SITE_ID, 1, CHARINDEX('~',A.SITE_ID)-1)  AS FROM_SITE
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
                      ,SUBSTRING(A.SITE_ID, 1, CHARINDEX('~',A.SITE_ID)-1)      
                      ,A.ITEM_ID                                 
                      , CONVERT(NVARCHAR, A.RECEIVING_DTTM,112)   
                      , DESCR


                 --UPDATE X
                 --   SET X.QTY = ISNULL(Z.QTY,0)
                 --  FROM #PSI_GLOBAL_AUTO X  WITH (NOLOCK)
                 --  INNER JOIN (SELECT ITEM_ID,FROM_SITE,YYYYMMDD, SUM(Y.QTY) AS QTY
                 --               FROM #PLN_TH_ENG_STOCK_PLAN Y WITH (NOLOCK)
                 --              WHERE DESCR LIKE 'FOR%'
                 --              GROUP BY ITEM_ID,FROM_SITE,YYYYMMDD
                 --             ) Z  
                 --     ON X.ITEM_ID    = Z.ITEM_ID                        
                 --    AND X.FROM_SITE  = Z.FROM_SITE
                 --    AND X.YYYYMMDD   = Z.YYYYMMDD 
                 --    AND X.MEASURE    = 'CELL_FOR_FORM_END'

				MERGE INTO #PSI_GLOBAL_AUTO AS X
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

				UPDATE #PSI_GLOBAL_AUTO
				   SET ATTRIBUTE1 = '',
				       ATTRIBUTE9 = ''
				 WHERE MEASURE    = 'CELL_FOR_FORM_END'
				   ;

		IF @P_IS_DEBUG = 1  BEGIN 
			SELECT  2886  RNO,   GETDATE() - @d_event_date  ELAPSED			
		END

            -------------------------------------------------------------------------------------------------------------         
            -- CELL_FORM_PROGRESS 
            -------------------------------------------------------------------------------------------------------------  

--                 UPDATE X
--                    SET X.FROM_BOH_QTY = Z.FROM_BOH_QTY
--                   FROM #PSI_GLOBAL_AUTO X  WITH (NOLOCK)
--                   INNER JOIN (SELECT ITEM_ID, FROM_SITE, SUM(Y.QTY) AS FROM_BOH_QTY
--                                 FROM #PLN_TH_ENG_STOCK_PLAN Y  WITH (NOLOCK)
--                                WHERE DESCR ='FOR'
----                                WHERE YYYYMMDD = @p_plan_start_yyyymmdd
--                                GROUP BY ITEM_ID, FROM_SITE
--                             )  Z 
--                      ON X.ITEM_ID    = Z.ITEM_ID                        
--                     AND X.FROM_SITE  = Z.FROM_SITE
--                     AND X.MEASURE    = 'CELL_FORM_PROGRESS'


				MERGE INTO #PSI_GLOBAL_AUTO AS X
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
				ON   X.DIVISION_ID = Y.DIVISION_ID
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

		IF @P_IS_DEBUG = 1  BEGIN 
			SELECT  2980  RNO,   GETDATE() - @d_event_date  ELAPSED			
		END
			-------------------------------------------------------------------------------------------------------------
			-- PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 - PACK BOH (Hold, Wait for Inspection, Expected Inspection date) 추가 - start
			-------------------------------------------------------------------------------------------------------------
            IF OBJECT_ID('tempdb..#PLN_TH_ENG_STOCK_PLAN_INSP') IS NOT NULL	
	                DROP TABLE #PLN_TH_ENG_STOCK_PLAN_INSP

              SELECT SUBSTRING(A.MASTER_ID,1,2) AS DIVISION_ID
                      ,SUBSTRING(A.SITE_ID, 1, CHARINDEX('~',A.SITE_ID)-1)  AS FROM_SITE
                      ,A.ITEM_ID                                 
                      ,CONVERT(NVARCHAR, A.RECEIVING_DTTM,112)  AS YYYYMMDD
                      ,SUM(ISNULL(A.QTY,0))   AS QTY     
					  ,A.DESCR
                      ,A.INSP_TYPE
                INTO #PLN_TH_ENG_STOCK_PLAN_INSP
                FROM SCP_PLN_TH_ENG_STOCK_PLAN A WITH(NOLOCK)                   
                 WHERE 1 = 1           
                  AND A.MASTER_ID   = @p_master_id                    
                  AND A.PLAN_ID     = @p_engine_plan_id                    
                GROUP BY                     
                       SUBSTRING(A.MASTER_ID,1,2)                          
                      ,SUBSTRING(A.SITE_ID, 1, CHARINDEX('~',A.SITE_ID)-1)      
                      ,A.ITEM_ID                                 
                      , CONVERT(NVARCHAR, A.RECEIVING_DTTM,112)   
					  ,A.DESCR
                      , INSP_TYPE

			-- PACK BOH (Hold), 전진검사 HOLD + 전진검사 이외 HOLD
            --     UPDATE X
            --        SET X.QTY = ISNULL(Z.QTY,0)
            --       FROM #PSI_GLOBAL_AUTO X  WITH (NOLOCK)
            --       INNER JOIN (SELECT ITEM_ID, FROM_SITE,YYYYMMDD, SUM(Y.QTY) AS QTY
            --                    FROM #PLN_TH_ENG_STOCK_PLAN_INSP Y WITH (NOLOCK)
            --                   WHERE (INSP_TYPE = 'INSP_HOLD' OR DESCR LIKE '%HOLD')
							     --AND NOT INSP_TYPE = 'INSP_PRE'
            --                   GROUP BY ITEM_ID, FROM_SITE,YYYYMMDD
            --                  ) Z  
            --          ON X.ITEM_ID    = Z.ITEM_ID                        
            --         AND X.FROM_SITE  = Z.FROM_SITE
            --         AND X.YYYYMMDD   = Z.YYYYMMDD 
            --         AND X.MEASURE    = 'PACK_BOH_HOLD'

				MERGE INTO #PSI_GLOBAL_AUTO AS X
				USING (SELECT @p_division_id AS DIVISION_ID
							,'P'             AS OPERATION_GROUP
							,A.ITEM_ID
							,'-'             AS TO_SITE
							,'-'             AS PROJECT_CODE
							,0               AS TO_BOH_QTY
							,0               AS FROM_BOH_QTY
							,'-'             AS INCOTERMS
							,A.FROM_SITE
							,'-'             AS TRANSPORT_MODE
							,'-'             AS PROD_LINE
							,'PACK_BOH_HOLD' AS MEASURE
							,A.YYYYMMDD
							,ISNULL(A.QTY,0) AS QTY
							,B.SORT_ORDER_NO
							,B.COLUMN_LABEL_NAME
							,'-'            AS BOD_ID
							,'SCP_ANL_PRODUCTION_PLAN' AS ATTRIBUTE1		--  중복방지
							,ISNULL((SELECT TOP 1 ATTRIBUTE9 FROM #PSI_GLOBAL_AUTO WHERE ITEM_ID = A.ITEM_ID AND MEASURE IN ('PACK_PROD', 'CELL_PROD') AND ATTRIBUTE9 IS NOT NULL), '') AS ATTRIBUTE9
						FROM (SELECT ITEM_ID, FROM_SITE, YYYYMMDD, SUM(Y.QTY) AS QTY
                                FROM #PLN_TH_ENG_STOCK_PLAN_INSP Y WITH (NOLOCK)
                               WHERE (INSP_TYPE = 'INSP_HOLD' OR DESCR LIKE '%HOLD')
							     AND NOT INSP_TYPE = 'INSP_PRE'
								 AND (SELECT TOP 1 OPERATION_GROUP FROM #PSI_GLOBAL_AUTO WHERE ITEM_ID = Y.ITEM_ID AND MEASURE = 'PACK_PROD') = 'P'			-- CELL 이 함께 존재하므로 CELL을 제외한다.
                               GROUP BY ITEM_ID, FROM_SITE,YYYYMMDD
							 ) A,
						     (SELECT * FROM #MEASURE WITH (NOLOCK) WHERE COLUMN_NAME = 'PACK_BOH_HOLD') B
				      ) AS Y
				ON  X.ITEM_ID    = Y.ITEM_ID  
                AND X.FROM_SITE  = Y.FROM_SITE
                AND X.YYYYMMDD   = Y.YYYYMMDD 
                AND X.MEASURE    = 'PACK_BOH_HOLD'
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
		IF @P_IS_DEBUG = 1  BEGIN 
			SELECT  3103  RNO,   GETDATE() - @d_event_date  ELAPSED			
		END

			-- Pack BOH(Expected Inspection date)
                 --UPDATE X
                 --   SET X.QTY = ISNULL(Z.QTY,0)
                 --  FROM #PSI_GLOBAL_AUTO X  WITH (NOLOCK)
                 --  INNER JOIN (SELECT ITEM_ID, FROM_SITE,YYYYMMDD, SUM(Y.QTY) AS QTY
                 --               FROM #PLN_TH_ENG_STOCK_PLAN_INSP Y WITH (NOLOCK)
                 --              WHERE INSP_TYPE = 'INSP_PRE'
                 --              GROUP BY ITEM_ID, FROM_SITE,YYYYMMDD
                 --             ) Z  
                 --     ON X.ITEM_ID    = Z.ITEM_ID                        
                 --    AND X.FROM_SITE  = Z.FROM_SITE
                 --    AND X.YYYYMMDD   = Z.YYYYMMDD 
                 --    AND X.MEASURE    = 'PACK_BOH_EXP_INSP_DATE'

				MERGE INTO #PSI_GLOBAL_AUTO AS X
				USING (SELECT @p_division_id AS DIVISION_ID
							,'P'             AS OPERATION_GROUP
							,A.ITEM_ID
							,'-'             AS TO_SITE
							,'-'             AS PROJECT_CODE
							,0               AS TO_BOH_QTY
							,0               AS FROM_BOH_QTY
							,'-'             AS INCOTERMS
							,A.FROM_SITE
							,'-'             AS TRANSPORT_MODE
							,'-'             AS PROD_LINE
							,'PACK_BOH_EXP_INSP_DATE' AS MEASURE
							,A.YYYYMMDD
							,ISNULL(A.QTY,0) AS QTY
							,B.SORT_ORDER_NO
							,B.COLUMN_LABEL_NAME
							,'-'            AS BOD_ID
						FROM (SELECT ITEM_ID, FROM_SITE, YYYYMMDD, SUM(Y.QTY) AS QTY
                                FROM #PLN_TH_ENG_STOCK_PLAN_INSP Y WITH (NOLOCK)
                               WHERE INSP_TYPE = 'INSP_PRE'
                               GROUP BY ITEM_ID, FROM_SITE,YYYYMMDD
							 ) A,
						     (SELECT * FROM #MEASURE WITH (NOLOCK) WHERE COLUMN_NAME = 'PACK_BOH_EXP_INSP_DATE') B
				      ) AS Y
				ON  X.ITEM_ID    = Y.ITEM_ID  
                AND X.FROM_SITE  = Y.FROM_SITE
                AND X.YYYYMMDD   = Y.YYYYMMDD 
                AND X.MEASURE    = 'PACK_BOH_EXP_INSP_DATE'
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

		IF @p_is_debug = 1  BEGIN 
			SELECT '3193' AS #PSI_GLOBAL_AUTO, * FROM   #PSI_GLOBAL_AUTO WHERE YYYYMMDD= @p_plan_start_yyyymmdd
					AND ITEM_ID = @P_CELL  AND MEASURE = 'SHIP_PLAN' AND TO_SITE = @P_TO_SITE	
			SELECT  3196  RNO,   GETDATE() - @d_event_date  ELAPSED			
		END

			-- Pack BOH(Expected Inspection date) - PACK_BOH_EXP_INSP_DATE measure 중복오류수정 - start
				UPDATE #PSI_GLOBAL_AUTO
				   SET ATTRIBUTE1 = '',
				       ATTRIBUTE9 = ''
				 WHERE MEASURE    = 'PACK_BOH_EXP_INSP_DATE'
				   ;
			-- Pack BOH(Expected Inspection date) - PACK_BOH_EXP_INSP_DATE measure 중복오류수정 - end

			-- PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 - PACK BOH (Hold, Wait for Inspection, Expected Inspection date) 추가 - end

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


		IF @P_IS_DEBUG = 1  BEGIN 
			SELECT  3228  RNO,   GETDATE() - @d_event_date  ELAPSED			
		END
                 --UPDATE X
                 --   SET X.QTY = Z.QTY
                 --  FROM #PSI_GLOBAL_AUTO X  WITH (NOLOCK)
                 --  INNER JOIN #tmp_SCM_DNM_STOCK_AGING_V  Z 
                 --     ON X.ITEM_ID    = Z.ITEM_ID                        
                 --    AND X.FROM_SITE  = Z.FROM_SITE
                 --    AND X.YYYYMMDD   = Z.YYYYMMDD
                 --    AND X.MEASURE    = 'CELL_FORM_HOLD_UNDER'

				MERGE INTO #PSI_GLOBAL_AUTO AS X
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
					     AND A.YYYYMMDD BETWEEN @p_plan_start_yyyymmdd AND @p_to_yyyymmdd		-- 플랜구간만 유효 :: 2022.08.30   KSW			Cell 재고 개선건
				      ) AS Y
				ON  X.ITEM_ID    = Y.ITEM_ID  
                AND X.FROM_SITE  = Y.FROM_SITE
                AND X.YYYYMMDD   = Y.YYYYMMDD
                AND X.MEASURE    = 'CELL_FORM_HOLD_UNDER'
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
	IF @p_is_debug = 1 BEGIN
		SELECT '3277' AS #PSI_GLOBAL_AUTO, * FROM   #PSI_GLOBAL_AUTO WHERE YYYYMMDD= @p_plan_start_yyyymmdd
		AND ITEM_ID = @P_CELL  AND MEASURE = 'SHIP_PLAN' AND TO_SITE = @P_TO_SITE	
		SELECT  3318  RNO,   GETDATE() - @d_event_date  ELAPSED		
	END


				UPDATE #PSI_GLOBAL_AUTO
				   SET ATTRIBUTE1 = 'SCP_PLN_PRODUCTION_PLAN',
				       ATTRIBUTE9 = 'F6000'
				 WHERE MEASURE    = 'CELL_FORM_HOLD_UNDER'
				  -- 아래조건 전체를 'CELL_FORM_HOLD_UNDER'메저의   AND 조건으로 설정
				   AND ( ISNULL(ATTRIBUTE1, '') = '' OR ISNULL(ATTRIBUTE9, '') = '' )
				   ;

                  -- BOH

                 
                 -- 보류중 해제일자가 없는수량
                  --UPDATE X
                  --  SET X.FROM_BOH_QTY = Z.QTY
                  -- FROM #PSI_GLOBAL_AUTO X  WITH (NOLOCK)
                  -- INNER JOIN (SELECT FROM_SITE, ITEM_ID, SUM(Y.QTY) AS QTY
                  --               FROM #PLN_TH_ENG_STOCK_PLAN Y  WITH (NOLOCK)
                  --              WHERE DESCR ='FOR_HOLD'
                  --              GROUP BY FROM_SITE, ITEM_ID
                  --           )  Z 
                  --    ON X.ITEM_ID    = Z.ITEM_ID      
                  --   AND X.FROM_SITE  = Z.FROM_SITE
                  --   AND X.MEASURE    = 'CELL_FORM_HOLD_UNDER'

				MERGE INTO #PSI_GLOBAL_AUTO AS X
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
						--FROM (SELECT FROM_SITE, ITEM_ID, SUM(Y.QTY) AS FROM_BOH_QTY
      --                           FROM #PLN_TH_ENG_STOCK_PLAN Y  WITH (NOLOCK)
      --                          WHERE DESCR ='FOR_HOLD'
      --                          GROUP BY FROM_SITE, ITEM_ID
						--	 ) A,
						FROM (SELECT FROM_SITE, ITEM_ID, SUM(Y.QTY) AS FROM_BOH_QTY
						        FROM #tmp_SCM_DNM_STOCK_AGING_V Y  WITH (NOLOCK)
							   WHERE (Y.YYYYMMDD    < @p_plan_start_yyyymmdd	
								      OR Y.YYYYMMDD > @p_to_yyyymmdd)			-- (플랜범위이전 + 플랜범위초과) 영역 :: 2022.08.30   KSW			Cell 재고 개선건
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
		IF @P_IS_DEBUG = 1  BEGIN 
			SELECT  3422  RNO,   GETDATE() - @d_event_date  ELAPSED			
		END

-- 2022.08.30   KSW			Cell 재고 개선건 - 주석처리
    --              -- 보류중 해제일자가 없는수량
    --              -- BOH
    --              --UPDATE X
    --              --  SET X.FROM_BOH_QTY = X.FROM_BOH_QTY - Z.QTY
    --              -- FROM #PSI_GLOBAL_AUTO X  WITH (NOLOCK)
    --              -- INNER JOIN ( 
    --              --           SELECT FROM_SITE, ITEM_ID, SUM(Y.QTY) AS QTY
    --              --               FROM #tmp_SCM_DNM_STOCK_AGING_V Y  WITH (NOLOCK)
    --              --              GROUP BY FROM_SITE, ITEM_ID
    --              --              ) Z 
    --              --    ON X.ITEM_ID    = Z.ITEM_ID      
    --              --   AND X.FROM_SITE  = Z.FROM_SITE
    --              --   AND X.MEASURE    = 'CELL_FORM_HOLD_UNDER'
                 
				--MERGE INTO #PSI_GLOBAL_AUTO AS X
				--USING (SELECT @p_division_id AS DIVISION_ID
				--			,'A'             AS OPERATION_GROUP
				--			,A.ITEM_ID
				--			,'-'             AS TO_SITE
				--			,'-'             AS PROJECT_CODE
				--			,0               AS TO_BOH_QTY
				--			,ISNULL(A.QTY,0) AS FROM_BOH_QTY
				--			,'-'             AS INCOTERMS
				--			,A.FROM_SITE
				--			,'-'             AS TRANSPORT_MODE
				--			,'-'             AS PROD_LINE
				--			,'CELL_FORM_HOLD_UNDER' AS MEASURE
				--			,0               AS QTY
				--			,B.SORT_ORDER_NO
				--			,B.COLUMN_LABEL_NAME
				--			,'-'            AS BOD_ID
				--		FROM (SELECT FROM_SITE, ITEM_ID, SUM(Y.QTY) AS QTY
    --                             FROM #tmp_SCM_DNM_STOCK_AGING_V Y  WITH (NOLOCK)
    --                            GROUP BY FROM_SITE, ITEM_ID) A,
				--		     (SELECT * FROM #MEASURE WITH (NOLOCK) WHERE COLUMN_NAME = 'CELL_FORM_HOLD_UNDER') B
				--	   WHERE A.FROM_SITE IS NOT NULL
				--      ) AS Y
				--ON  X.ITEM_ID    = Y.ITEM_ID  
    --            AND X.FROM_SITE  = Y.FROM_SITE
    --            AND X.MEASURE    = 'CELL_FORM_HOLD_UNDER'
				--WHEN MATCHED  THEN
				--UPDATE
				--   SET X.FROM_BOH_QTY = X.FROM_BOH_QTY - Y.FROM_BOH_QTY
				--WHEN NOT MATCHED  THEN
				--INSERT (
				--		 DIVISION_ID
				--		,OPERATION_GROUP	
				--		,ITEM_ID
				--		,TO_SITE
				--		,PROJECT_CODE
				--		,TO_BOH_QTY
				--		,FROM_BOH_QTY
				--		,INCOTERMS
				--		,FROM_SITE
				--		,TRANSPORT_MODE
				--		,PROD_LINE
				--		,MEASURE
				--		,YYYYMMDD
				--		,QTY
				--		,SORT_ORDER_NO
				--		,COLUMN_LABEL_NAME
				--		,BOD_ID
				--       )
				--VALUES (
				--		 Y.DIVISION_ID
				--		,Y.OPERATION_GROUP
				--		,Y.ITEM_ID
				--		,Y.TO_SITE
				--		,Y.PROJECT_CODE
				--		,Y.TO_BOH_QTY
				--		,Y.FROM_BOH_QTY
				--		,Y.INCOTERMS
				--		,Y.FROM_SITE
				--		,Y.TRANSPORT_MODE
				--		,Y.PROD_LINE
				--		,Y.MEASURE
				--		,@p_plan_start_yyyymmdd
				--		,Y.QTY
				--		,Y.SORT_ORDER_NO
				--		,Y.COLUMN_LABEL_NAME
				--		,Y.BOD_ID
				--       );

                  
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

                  --aging에서 hold 수량중 available_date or 예상해제일 늦은날짜 기준
                  --UPDATE X
                  --  SET X.QTY = Z.QTY
                  -- FROM #PSI_GLOBAL_AUTO X  WITH (NOLOCK)
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

				MERGE INTO #PSI_GLOBAL_AUTO AS X
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

				UPDATE #PSI_GLOBAL_AUTO
				   SET ATTRIBUTE1 = 'SCP_PLN_PRODUCTION_PLAN',
				       ATTRIBUTE9 = 'F6000'
				 WHERE MEASURE    = 'CELL_FORM_HOLD_UNDER_AVAILABLE'
				   -- 특정메저에서만 작동하도록 괄호조건 추가(KSK, 2024-05-21)
				   AND ( ISNULL(ATTRIBUTE1, '') = '' OR ISNULL(ATTRIBUTE9, '') = '' )
				   ;

		IF @P_IS_DEBUG = 1  BEGIN 
			SELECT  3627  RNO,   GETDATE() - @d_event_date  ELAPSED			
		END
            -------------------------------------------------------------------------------------------------------------         
            -- CELL_FORM_HOLD_AFTER 추가
            -- [전지 공급 대응력 향상을 위한 RTF 적확도 개선] : GSCM 시스템의 보류재고 감안한 계획 수립을 위한 시뮬레이션 변경 요청(자동차, ESS)
            ------------------------------------------------------------------------------------------------------------- 



                 --UPDATE X
                 --   SET X.QTY = Z.QTY
                 --  FROM #PSI_GLOBAL_AUTO X  WITH (NOLOCK)
                 --  INNER JOIN (SELECT ITEM_ID, FROM_SITE, SUM(Y.QTY) AS QTY, Y.YYYYMMDD
                 --                FROM #PLN_TH_ENG_STOCK_PLAN Y  WITH (NOLOCK)
                 --                WHERE DESCR ='WH_HOLD'
                 --               GROUP BY ITEM_ID, FROM_SITE, YYYYMMDD
                 --            )  Z 
                 --     ON X.ITEM_ID    = Z.ITEM_ID                        
                 --    AND X.FROM_SITE  = Z.FROM_SITE
                 --    AND X.YYYYMMDD   = Z.YYYYMMDD
                 --    AND X.MEASURE    = 'CELL_FORM_HOLD_AFTER'
 
				MERGE INTO #PSI_GLOBAL_AUTO AS X
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
						FROM (SELECT ITEM_ID, FROM_SITE, SUM(Y.QTY) AS QTY, Y.YYYYMMDD
                                 FROM #PLN_TH_ENG_STOCK_PLAN Y  WITH (NOLOCK)
                                 WHERE DESCR ='WH_HOLD'
								   AND (SELECT OPERATION_GROUP FROM SCM_MST_SITE WITH (NOLOCK) WHERE SCM_SITE_ID = Y.FROM_SITE) = 'A'		-- CELL 생산 사이트 한정
								   AND Y.YYYYMMDD BETWEEN @p_plan_start_yyyymmdd AND @p_to_yyyymmdd		-- 플랜구간만 유효 :: 2022.08.30   KSW			Cell 재고 개선건
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

                  -- -- 보류중 해제일자가 없는수량
                  --UPDATE X
                  --  SET X.FROM_BOH_QTY = Z.QTY
                  -- FROM #PSI_GLOBAL_AUTO X  WITH (NOLOCK)
                  -- INNER JOIN (SELECT ITEM_ID, FROM_SITE, SUM(Y.QTY) AS QTY
                  --               FROM #PLN_TH_ENG_STOCK_PLAN Y  WITH (NOLOCK)
                  --              WHERE DESCR ='WH_HOLD'
                  --              GROUP BY ITEM_ID,FROM_SITE
                  --           )  Z 
                  --    ON X.ITEM_ID    = Z.ITEM_ID       
                  --   AND X.FROM_SITE  = Z.FROM_SITE
                  --   AND X.MEASURE    = 'CELL_FORM_HOLD_AFTER'

		IF @P_IS_DEBUG = 1  BEGIN 
			SELECT  3739  RNO,   GETDATE() - @d_event_date  ELAPSED			
		END

				MERGE INTO #PSI_GLOBAL_AUTO AS X
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
						FROM (SELECT ITEM_ID, FROM_SITE, SUM(Y.QTY) AS FROM_BOH_QTY
                                 FROM #PLN_TH_ENG_STOCK_PLAN Y  WITH (NOLOCK)
                                WHERE DESCR ='WH_HOLD'
								   AND (SELECT OPERATION_GROUP FROM SCM_MST_SITE WITH (NOLOCK) WHERE SCM_SITE_ID = Y.FROM_SITE) = 'A'		-- CELL 생산 사이트 한정
								   AND (Y.YYYYMMDD    < @p_plan_start_yyyymmdd	
								       OR Y.YYYYMMDD > @p_to_yyyymmdd)			-- (플랜범위이전 + 플랜범위초과) 영역 :: 2022.08.30   KSW			Cell 재고 개선건
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

				UPDATE #PSI_GLOBAL_AUTO
				   SET ATTRIBUTE1 = '',
				       ATTRIBUTE9 = ''
				 WHERE MEASURE    = 'CELL_FORM_HOLD_AFTER'
				   ;
       
		IF @P_IS_DEBUG = 1  BEGIN 
			SELECT  3822  RNO,   GETDATE() - @d_event_date  ELAPSED			
		END
            ------------------------------------------------------------------------------------------------------------- 
			-- * 2022.08.30   KSW			Cell 재고 개선건
			-- *							2) Cell BOH(Hold) new measure 에 주차별 표시, FROM_BOH_QTY 에 (플랜범위이전 + 플랜범위초과) 영역의 수량 표시 -- start
            ------------------------------------------------------------------------------------------------------------- 
			-- PACK_CELL_BOH 가 존재하는 모델을 참고로 해서 PACK_CELL_BOH_HOLD MEASURE 생성
				INSERT #PSI_GLOBAL_AUTO (
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
				SELECT 	 DISTINCT Y.DIVISION_ID
						,Y.OPERATION_GROUP
						,Y.ITEM_ID
						,Y.TO_SITE
						,Y.PROJECT_CODE
						,Y.TO_BOH_QTY
						,Y.FROM_BOH_QTY
						,Y.INCOTERMS
						,Y.FROM_SITE
						,Y.TRANSPORT_MODE
						,'-'					AS PROD_LINE
						,'PACK_CELL_BOH_HOLD'	AS MEASURE
						,Y.YYYYMMDD
						,0				AS QTY
						,B.SORT_ORDER_NO + 5	AS SORT_ORDER_NO
						,'Cell BOH(Hold)'		AS COLUMN_LABEL_NAME
						,Y.BOD_ID
				  FROM #PSI_GLOBAL_AUTO Y WITH (NOLOCK)
				  INNER JOIN (SELECT * FROM #MEASURE WITH (NOLOCK) WHERE COLUMN_NAME = 'PACK_CELL_BOH') B
				     ON 1 = 1
				 WHERE Y.MEASURE    = 'PACK_CELL_BOH'
				 ;

		IF @P_IS_DEBUG = 1  BEGIN 
			SELECT  3873  RNO,   GETDATE() - @d_event_date  ELAPSED			
		END
			-- Cell BOH(Hold) new measure 에 주차별 표시
				MERGE INTO #PSI_GLOBAL_AUTO AS X
				USING (SELECT @p_division_id AS DIVISION_ID
							,'P'             AS OPERATION_GROUP
							,A.ITEM_ID
							,'-'             AS TO_SITE
							,'-'             AS PROJECT_CODE
							,0               AS TO_BOH_QTY
							,0               AS FROM_BOH_QTY
							,'-'             AS INCOTERMS
							,A.FROM_SITE
							,'-'             AS TRANSPORT_MODE
							,'-'             AS PROD_LINE
							,'PACK_CELL_BOH_HOLD'	AS MEASURE
							,A.YYYYMMDD
							,ISNULL(A.QTY,0)		AS QTY
							,B.SORT_ORDER_NO + 5	AS SORT_ORDER_NO
							,'Cell BOH(Hold)'		AS COLUMN_LABEL_NAME
							,'-'            AS BOD_ID
						FROM (SELECT ITEM_ID, FROM_SITE, SUM(Y.QTY) AS QTY, Y.YYYYMMDD
                                 FROM #PLN_TH_ENG_STOCK_PLAN Y  WITH (NOLOCK)
                                 WHERE DESCR ='WH_HOLD'
								   AND (SELECT OPERATION_GROUP FROM SCM_MST_SITE WITH (NOLOCK) WHERE SCM_SITE_ID = Y.FROM_SITE) = 'P'		-- PACK 생산 사이트 한정
								   AND Y.YYYYMMDD BETWEEN @p_plan_start_yyyymmdd AND @p_to_yyyymmdd		-- 플랜구간만 유효
                                GROUP BY ITEM_ID, FROM_SITE, YYYYMMDD
                             )  A,
						     (SELECT * FROM #MEASURE WITH (NOLOCK) WHERE COLUMN_NAME = 'PACK_CELL_BOH') B
					   WHERE A.FROM_SITE IS NOT NULL
				      ) AS Y
				ON  X.ITEM_ID    = Y.ITEM_ID  
                AND X.FROM_SITE  = Y.FROM_SITE
                AND X.YYYYMMDD   = Y.YYYYMMDD
                AND X.MEASURE    = 'PACK_CELL_BOH_HOLD'
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

		IF @P_IS_DEBUG = 1  BEGIN 
			SELECT  3952  RNO,   GETDATE() - @d_event_date  ELAPSED			
		END

			-- FROM_BOH_QTY 에 (플랜범위이전 + 플랜범위초과) 영역의 수량 표시
				MERGE INTO #PSI_GLOBAL_AUTO AS X
				USING (SELECT @p_division_id AS DIVISION_ID
							,'P'             AS OPERATION_GROUP
							,A.ITEM_ID
							,'-'             AS TO_SITE
							,'-'             AS PROJECT_CODE
							,0               AS TO_BOH_QTY
							,A.FROM_BOH_QTY
							,'-'             AS INCOTERMS
							,A.FROM_SITE
							,'-'             AS TRANSPORT_MODE
							,'-'             AS PROD_LINE
							,'PACK_CELL_BOH_HOLD'	AS MEASURE
							,0						AS QTY
							,B.SORT_ORDER_NO + 5	AS SORT_ORDER_NO
							,'Cell BOH(Hold)'		AS COLUMN_LABEL_NAME
							,'-'            AS BOD_ID
						FROM (SELECT ITEM_ID, FROM_SITE, SUM(Y.QTY) AS FROM_BOH_QTY
                                 FROM #PLN_TH_ENG_STOCK_PLAN Y  WITH (NOLOCK)
                                WHERE DESCR ='WH_HOLD'
								  AND (SELECT OPERATION_GROUP FROM SCM_MST_SITE WITH (NOLOCK) WHERE SCM_SITE_ID = Y.FROM_SITE) = 'P'		-- PACK 생산 사이트 한정
								  AND (Y.YYYYMMDD    < @p_plan_start_yyyymmdd	
								       OR Y.YYYYMMDD > @p_to_yyyymmdd)			-- (플랜범위이전 + 플랜범위초과) 영역
                                GROUP BY ITEM_ID,FROM_SITE
                             )  A,
						     (SELECT * FROM #MEASURE WITH (NOLOCK) WHERE COLUMN_NAME = 'PACK_CELL_BOH') B
					   WHERE A.FROM_SITE IS NOT NULL
				      ) AS Y
				ON  X.ITEM_ID    = Y.ITEM_ID  
                AND X.FROM_SITE  = Y.FROM_SITE
                AND X.MEASURE    = 'PACK_CELL_BOH_HOLD'
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

				UPDATE #PSI_GLOBAL_AUTO
				   SET ATTRIBUTE1 = '',
				       ATTRIBUTE9 = ''
				 WHERE MEASURE    = 'PACK_CELL_BOH_HOLD'
				   ;
			-- *							2) Cell BOH(Hold) new measure 에 주차별 표시, FROM_BOH_QTY 에 (플랜범위이전 + 플랜범위초과) 영역의 수량 표시 -- end
			------------------------------------------------------------------------------------------------------------- 
	IF @p_is_debug = 1 BEGIN 	
		SELECT '3978' AS #PSI_GLOBAL_AUTO, * FROM   #PSI_GLOBAL_AUTO WHERE YYYYMMDD= @p_plan_start_yyyymmdd
						AND ITEM_ID = @P_CELL  AND MEASURE = 'SHIP_PLAN' AND TO_SITE = @P_TO_SITE	
		SELECT  4040  RNO,   GETDATE() - @d_event_date  ELAPSED		
	END

            -------------------------------------------------------------------------------------------------------------         
            -- LT 계산용 테이블 생성   
            -------------------------------------------------------------------------------------------------------------         
             IF OBJECT_ID('tempdb..#SCP_MST_BOD_V') IS NOT NULL      
	                DROP TABLE #SCP_MST_BOD_V; 

                SELECT DISTINCT X.DIVISION_ID,X.FROM_SITE,X.TO_SITE,X.INCOTERMS,X.TRANSPORT_MODE,X.LT_TOTAL, X.BOD_ID
					, CEILING(LT_TOTAL/7.0) AS LT_TOTAL_BY_WEEK
                INTO #SCP_MST_BOD_V
                FROM SCP_MST_BOD_N_V  X WITH (NOLOCK)		-- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 - SCP_MST_BOD_V --> SCP_MST_BOD_N_V
                WHERE DIVISION_ID =@p_division_id
				 
         
            -----------------------------------------------------------------------------------------------------------------                                         
            ---- PACK공장 CELL 재고 UPDATE
            --------------------------------------------------------------------------------------------------------------- 
                -- PACK 일경우 

                UPDATE X
                   SET	CELL_ITEM_ID      = ( SELECT TOP 1 CHILD_ITEM_ID
                                               FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V AS Y WITH (NOLOCK)
                                              WHERE Y.DIVISION_ID        = X.DIVISION_ID
											    AND Y.MODEL_ID           = X.ITEM_ID
                                                AND Y.CELL_TYPE			 = 'CP'		-- 활성화코드 분리 대응(Cell Product 조건 추가) :: 2023.06.15 , KSK
                                                AND Y.OPERATION_GROUP_ID = 'A')
                FROM #PSI_GLOBAL_AUTO X
                 WHERE OPERATION_GROUP   = 'P';
                

               --  CELL 일경우 -- 활성화코드 분리 대응(Cell Product 조건 추가) :: 2023.06.15 , KSK - START 
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
				  FROM #PSI_GLOBAL_AUTO X WITH (NOLOCK)
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
				   AND X.OPERATION_GROUP   = 'A' ;

			------------------------------------------------------------------------------------------------------------------------------
			--  PJ20214997 LGES SCP 신규 Biz, 공정 추가에 따른 모델링 개선 - MEB biz. 적용 - CELL_ITEM_ID update, 2023.06.15, KSK - start
			------------------------------------------------------------------------------------------------------------------------------
			UPDATE X
               SET X.CELL_ITEM_ID = Z.CELL_ITEM_ID
              FROM #PSI_GLOBAL_AUTO X WITH (NOLOCK)
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
										AND x.DIVISION_ID       = @p_division_id -- CSR E20250829-001508 로직 속도개선
								  WHERE 1=1
								) Y
						 WHERE z.DIVISION_ID         = Y.DIVISION_ID
							AND z.MODEL_ID           = Y.model_id
							AND z.CELL_TYPE			 = 'CP' -- 2023.06.08 활성화코드 분리 대응(Cell Product 조건 추가)
							AND z.OPERATION_GROUP_ID = 'A'
							AND z.DIVISION_ID        = @p_division_id -- CSR E20250829-001508 로직 속도개선
					   ) Z
				 ON X.ITEM_ID    = Z.MODULE_ID
			  WHERE X.ATTRIBUTE9 = 'P5200'

		IF @P_IS_DEBUG = 1  BEGIN 
			SELECT  4148  RNO,   GETDATE() - @d_event_date  ELAPSED			
		END
		
-- 주석처리 : 2022.10.14 - 불필요한 생산계획 생성을 차단
			------------------------------------------------------
			---- PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화
   --         -- KSW 2021.07.29 형교환 - MODEL_CHANGE 추가 - start
   --          INSERT INTO #PSI_GLOBAL_AUTO
	  --          SELECT DISTINCT A.DIVISION_ID								
			--              , A.OPERATION_GROUP						
			--              , A.CELL_ITEM_ID							
			--              , A.ITEM_ID										
			--              , '-' AS TO_SITE
   --                 , A.PROJECT_CODE
			--              , A.TO_BOH_QTY										
			--              , A.FROM_BOH_QTY									
			--              , '-' AS INCOTERMS 										
			--              , A.FROM_SITE 										
   --                 , '-' AS TRANSPORT_MODE
   --                 , Y.LINE_ID AS PROD_LINE
			--              , A.MEASURE												
			--              , A.YYYYMMDD	
   --                 , 0 AS QTY
			--              , A.SORT_ORDER_NO									
			--              , A.COLUMN_LABEL_NAME							
			--              , A.BOD_ID						
   --                 , A.ATTRIBUTE1										
			--              , A.ATTRIBUTE9										
	  --          FROM #PSI_GLOBAL_AUTO A WITH(NOLOCK)
	  --          CROSS APPLY (
			--				SELECT DIVISION_ID,PLANT_SITE_ID,ITEM_ID,OPERATION_ID,LINE_ID,YIELD 
			--				FROM SCP_MST_TACT_TIME WITH(NOLOCK)
			--				WHERE DIVISION_ID =@p_division_id
			--				UNION ALL
			--				SELECT DIVISION_ID,PLANT_SITE_ID,ITEM_ID,OPERATION_ID,LINE_ID,YIELD 
			--				FROM SCP_MST_TACT_TIME_OSP WITH(NOLOCK)
			--				WHERE DIVISION_ID =@p_division_id
			--			  ) Y
		 --           WHERE 0 = 0
   --                   AND A.DIVISION_ID   = Y.DIVISION_ID
   --                   AND A.ITEM_ID       = Y.ITEM_ID
   --                   AND A.FROM_SITE     = Y.PLANT_SITE_ID
   --                   AND A.MEASURE       IN  ('CELL_PROD','PACK_PROD')
			--		  AND A.PROD_LINE     <> '-'
			--		  AND Y.LINE_ID       <> '-'
			--		  AND NOT EXISTS (                
			--							SELECT 'X'                
			--							FROM #PSI_GLOBAL_AUTO Z WITH(NOLOCK)                
			--							WHERE 1=1                
			--							AND Z.DIVISION_ID          = A.DIVISION_ID                
			--							AND Z.CELL_ITEM_ID         = A.CELL_ITEM_ID    
			--							AND Z.ITEM_ID              = A.ITEM_ID              
			--							AND Z.MEASURE              = A.MEASURE 
			--							AND Z.FROM_SITE            = Y.PLANT_SITE_ID
			--							AND Z.PROD_LINE            = Y.LINE_ID
			--							AND Z.MEASURE              IN ('CELL_PROD','PACK_PROD')
			--						)
   --         -- KSW 2021.07.29 형교환 - MODEL_CHANGE 추가 - start
			------------------------------------------------------



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
					, M.TIME_TERM		-- 형교환(Model Change)
                    ,'WQTY' + REPLICATE('0', 2 - LEN(DENSE_RANK()  OVER(PARTITION BY  A.LINE_ID ORDER BY C.ISO_YYYYWW) )) + CONVERT(NVARCHAR,DENSE_RANK()  OVER(PARTITION BY  A.LINE_ID ORDER BY C.ISO_YYYYWW))  AS WEEK_COLUMN
                INTO #LineLoad
			          FROM SCP_ANL_PRODUCTION_PLAN A WITH (NOLOCK)
                INNER HASH JOIN SCM_SYS_CALENDAR_M C   WITH (NOLOCK)
                        ON A.YYYYMMDD = C.BASIS_YYYYMMDD
			          LEFT OUTER HASH JOIN #LINE_WORKINGTIME_BY_LOSS D  WITH (NOLOCK)
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
				-- PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 - CAPA. 형교환 입력(Load Ratio 표시) 및 저장기능 구현
				-- 형교환(Model Change) 적용 - start
				  LEFT OUTER HASH JOIN SCM_WORK_CALENDAR_M_SN M  WITH (NOLOCK)
				    ON A.DIVISION_ID           = M.DIVISION_ID
					AND LEFT(A.SCM_SITE_ID, 4) = M.PLANT_ID
					AND A.OPERATION_ID         = M.OPERATION_ID
					AND convert(datetime, A.YYYYMMDD)             = M.WORK_DATE
					AND A.LINE_ID              = M.LINE_ID
					AND M.LOSS_CODE            = 'XC031'
				-- 형교환(Model Change) 적용 - end
			          WHERE 1=1 
                   AND A.DIVISION_ID         = @p_division_id
                  AND A.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
                  AND A.PLAN_TYPE           = @p_plan_type
                  AND A.SEQ                 = @p_seq
			            AND A.YYYYMMDD           >= @p_plan_start_yyyymmdd
	                AND A.YYYYMMDD           <=  @p_to_yyyymmdd --말일포함(KSK, 20240814)
--	                AND A.MEASURE             IN ('CELL_PROD','PACK_PROD')
                  AND A.MEASURE             IN ('PROD_PLAN_AMEND')                  
              GROUP BY A.DIVISION_ID, A.SCM_SITE_ID ,A.OPERATION_ID ,A.LINE_ID, A.YYYYMMDD, D.WORKING_TIME,  C.ISO_YYYYWW,A.OPERATION_GROUP
                      ,(CASE WHEN A.MEASURE = 'PROD_PLAN_AMEND' AND  A.OPERATION_GROUP ='P' THEN 'PACK_PROD_LOAD' WHEN A.MEASURE = 'PROD_PLAN_AMEND' AND  A.OPERATION_GROUP ='A'  THEN 'CELL_PROD_LOAD' END ) 
					  , M.TIME_TERM		-- 형교환(Model Change)
					  ;-- 2025.04.22 KIMCD HASH JOIN 3곳 추가

		IF @P_IS_DEBUG = 1  BEGIN 
			SELECT  4289  RNO,   GETDATE() - @d_event_date  ELAPSED			
		END

             INSERT INTO #PSI_GLOBAL_AUTO
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
	            FROM #PSI_GLOBAL_AUTO A WITH(NOLOCK)
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
IF @p_is_debug = 1 BEGIN 
	SELECT '4257' AS #PSI_GLOBAL_AUTO, * FROM   #PSI_GLOBAL_AUTO WHERE YYYYMMDD= @p_plan_start_yyyymmdd
	AND ITEM_ID = @P_CELL  AND MEASURE = 'SHIP_PLAN' AND TO_SITE = @P_TO_SITE	
	SELECT  4328  RNO,   GETDATE() - @d_event_date  ELAPSED		
END

---------------- E20240507-000511 (구간별 BOD LT 개선을 위한 SIMULATOR 로직 변경)  ---------START
				INSERT INTO #PSI_GLOBAL_AUTO
					SELECT 
							B.DIVISION_ID
							,  F.OPERATION_GROUP  
							, ISNULL(F.CELL_ITEM_ID, M.ITEM_ID)  AS CELL_ITEM_ID
							, M.ITEM_ID
							, B.to_site

							, '-'  AS PROJECT_CODE
							, 0 AS TO_BOH_QTY
							, 0 AS FROM_BOH_QTY
							, B.incoterms
							, B.from_site
							, B.transport_mode

							, '-' AS PROD_LINE
							,  'SHIP_PLAN' AS MEASURE
							, @p_plan_start_yyyymmdd AS YYYYMMDD
							, 0 AS QTY
							, MS.SORT_ORDER_NO
							, MS.COLUMN_LABEL_NAME
							, B.bod_id

							 ,'SCP_ANL_SHIPMENT_PLAN_FG'  AS  ATTRIBUTE1 
                             , NULL  AS ATTRIBUTE9	
					  FROM [dbo].[SCP_MST_BOD_N_V] B
					  INNER JOIN SCP_MST_BOD_ITEM AS M  WITH (NOLOCK)
						ON  B.DIVISION_ID  = M.DIVISION_ID
							AND B.BOD_ID = M.BOD_ID
							AND M.VALID_YN = 'Y' AND B.bod_valid_yn = 'Y' AND B.ROUTE_VALID_YN = 'Y' -- KSK,250709
					  INNER JOIN SCP_MST_FINAL_ITEM F 
						 ON M.DIVISION_ID = F.DIVISION_ID
							AND M.ITEM_ID = F.ITEM_ID
							AND F.OPERATION_GROUP = 'A'
							AND F.ATTRIBUTE8 = 'CP'
					  INNER JOIN #MEASURE MS WITH(NOLOCK)	
						 ON MS.COLUMN_NAME = 'SHIP_PLAN'
					  INNER JOIN  #PSI_GLOBAL_AUTO S
					    ON  S.DIVISION_ID = M.DIVISION_ID
						AND S.YYYYMMDD = @p_plan_start_yyyymmdd
						AND S.MEASURE = 'SHIP_PLAN'
						AND S.ITEM_ID = M.ITEM_ID
						AND S.FROM_SITE = B.FROM_SITE
						AND S.TO_SITE = B.TO_SITE
						AND ( S.INCOTERMS = B.incoterms OR S.INCOTERMS = '-')
						AND S.INCOTERMS = B.INCOTERMS
						AND S.BOD_ID <> '-'				
			       WHERE  1 = 1				   
				   AND B.DIVISION_ID = @p_division_id		
				   AND B.FROM_YYYYMMDD <= @p_to_yyyymmdd
				   AND B.TO_YYYYMMDD   >= @p_plan_start_yyyymmdd	
				   AND B.BOD_TYPE = 'SALES'
				   AND  B.TRANSPORT_MODE  <> 'AIR'	  
				  AND B.BOD_ID NOT IN (SELECT DISTINCT BOD_ID FROM #PSI_GLOBAL_AUTO)  -- KSK (250430, 멀티구간 BOD)				 

		IF @P_IS_DEBUG = 1  BEGIN 
			SELECT  4387  RNO,   GETDATE() - @d_event_date  ELAPSED			
		END
				-- 반제품
				INSERT INTO #PSI_GLOBAL_AUTO
					SELECT 
							B.DIVISION_ID
							,  F.OPERATION_GROUP  
							, ISNULL(F.CELL_ITEM_ID, M.ITEM_ID ) AS CELL_ITEM_ID
							, M.ITEM_ID
							, B.to_site

							, '-'  AS PROJECT_CODE
							, 0 AS TO_BOH_QTY
							, 0 AS FROM_BOH_QTY
							, B.incoterms
							, B.from_site
							, B.transport_mode

							, '-' AS PROD_LINE
							,  'SEMI_SHIP_PLAN' AS MEASURE
							, @p_plan_start_yyyymmdd AS YYYYMMDD
							, 0 AS QTY
							, MS.SORT_ORDER_NO
							, MS.COLUMN_LABEL_NAME
							, B.bod_id

							 ,'SCP_ANL_SHIPMENT_PLAN_SEMI'  AS  ATTRIBUTE1 
                             , NULL  AS ATTRIBUTE9	
					  FROM [dbo].[SCP_MST_BOD_N_V] B
					  INNER JOIN SCP_MST_BOD_ITEM AS M  WITH (NOLOCK)
						ON  B.DIVISION_ID  = M.DIVISION_ID
							AND B.BOD_ID = M.BOD_ID
							AND M.VALID_YN = 'Y' AND B.bod_valid_yn = 'Y' AND B.ROUTE_VALID_YN = 'Y' -- KSK,250709
					  INNER JOIN SCP_MST_FINAL_ITEM F 
						 ON M.DIVISION_ID = F.DIVISION_ID
							AND M.ITEM_ID = F.ITEM_ID
							AND F.OPERATION_GROUP = 'A'
							AND F.ATTRIBUTE8 = 'CP'
					  INNER JOIN #MEASURE MS WITH(NOLOCK)	
						 ON MS.COLUMN_NAME = 'SEMI_SHIP_PLAN'
					  INNER JOIN  #PSI_GLOBAL_AUTO S
					    ON  S.DIVISION_ID = M.DIVISION_ID
						AND S.YYYYMMDD = @p_plan_start_yyyymmdd
						AND S.MEASURE = 'SEMI_SHIP_PLAN'
						AND S.ITEM_ID = M.ITEM_ID
						AND S.FROM_SITE = B.FROM_SITE
						AND S.TO_SITE = B.TO_SITE
						AND ( S.INCOTERMS = B.incoterms OR S.INCOTERMS = '-')
						AND S.INCOTERMS = B.INCOTERMS
						AND S.BOD_ID <> '-'				
			       WHERE  1 = 1
				   AND B.DIVISION_ID = @p_division_id		
				   AND B.FROM_YYYYMMDD <= @p_to_yyyymmdd
				   AND B.TO_YYYYMMDD   >= @p_plan_start_yyyymmdd	
				   AND B.BOD_TYPE = 'PLANT'
				   AND  B.TRANSPORT_MODE  <> 'AIR'	  
				  AND B.BOD_ID NOT IN (SELECT DISTINCT BOD_ID FROM #PSI_GLOBAL_AUTO)
----------- E20240507-000511 (구간별 BOD LT 개선을 위한 SIMULATOR 로직 변경)  -------- END 		


		IF @P_IS_DEBUG = 1  BEGIN 
			SELECT  4448  RNO,   GETDATE() - @d_event_date  ELAPSED			
		END
			----------------------------------------------------
			-- PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화
            -- KSW 2021.07.29 형교환 - MODEL_CHANGE 추가 - start
			INSERT #PSI_GLOBAL_AUTO
              SELECT  DISTINCT  X.DIVISION_ID								
			                        , X.OPERATION_GROUP						
			                        , X.CELL_ITEM_ID							
			                        , X.ITEM_ID										
			                        , '-' AS TO_SITE
                              , '-' AS PROJECT_CODE
			                    , 0 AS TO_BOH_QTY										
			                        , 0 AS FROM_BOH_QTY									
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
                              , X.ATTRIBUTE1										
			                        , X.ATTRIBUTE9										
              FROM (SELECT  DISTINCT
			                DIVISION_ID
			               ,OPERATION_GROUP
						   ,CELL_ITEM_ID
						   ,ITEM_ID
						   ,FROM_SITE
						   ,PROD_LINE
						   ,MEASURE
						   ,YYYYMMDD
						   ,ATTRIBUTE1
						   ,ATTRIBUTE9
			          FROM #PSI_GLOBAL_AUTO WITH(NOLOCK)
					 WHERE MEASURE    IN ('PACK_PROD', 'CELL_PROD')
					   AND PROD_LINE   <> '-'
				   ) X     
              CROSS APPLY #MEASURE M WITH (NOLOCK)                                 
              WHERE 1=1          
			    AND X.MEASURE    IN ('PACK_PROD', 'CELL_PROD')
                AND M.GUBUN       = 'FROM'
                AND M.COLUMN_NAME = (CASE WHEN X.MEASURE = 'PACK_PROD' THEN 'PACK_MODEL_CHANGE' ELSE 'CELL_MODEL_CHANGE'END)
                AND X.PROD_LINE   <> '-'
				;

IF @p_is_debug = 1 BEGIN 
		SELECT '4418' AS #PSI_GLOBAL_AUTO, * FROM   #PSI_GLOBAL_AUTO WHERE YYYYMMDD= @p_plan_start_yyyymmdd
							AND ITEM_ID = @P_CELL  AND MEASURE = 'SHIP_PLAN' AND TO_SITE = @P_TO_SITE	
		SELECT  4501  RNO,   GETDATE() - @d_event_date  ELAPSED		
END

			DELETE FROM #PSI_GLOBAL_AUTO
			 WHERE MEASURE    IN ('PACK_MODEL_CHANGE', 'CELL_MODEL_CHANGE')
			   AND PROD_LINE   = '-'
			   ;
			-- KSW 2021.07.29 형교환 - MODEL_CHANGE 추가 - end        
			
			-- KSW 2021.07.29 형교환 - start
            UPDATE X
            SET X.QTY = ISNULL(B.TIME_TERM, 0)
            FROM #PSI_GLOBAL_AUTO X  WITH (NOLOCK)
            INNER JOIN SCM_WORK_CALENDAR_M_SN B  WITH (NOLOCK)
            ON 0 = 0
            AND X.DIVISION_ID        = B.DIVISION_ID
            AND LEFT(X.FROM_SITE, 4) = B.PLANT_ID
            AND X.attribute9   = B.OPERATION_ID
            AND X.YYYYMMDD     = B.WORK_DATE
            AND X.PROD_LINE    = B.LINE_ID
			AND B.LOSS_CODE    = 'XC031'
			WHERE X.MEASURE   IN ('PACK_MODEL_CHANGE', 'CELL_MODEL_CHANGE') 
			-- KSW 2021.07.29 형교환 - end
			----------------------------------------------------

	IF @p_is_debug = 1 BEGIN  
		SELECT '4442' AS #PSI_GLOBAL_AUTO, * FROM   #PSI_GLOBAL_AUTO WHERE YYYYMMDD= @p_plan_start_yyyymmdd 
						AND ITEM_ID = @P_CELL  AND MEASURE = 'SHIP_PLAN' AND TO_SITE = @P_TO_SITE	
		SELECT  4529  RNO,   GETDATE() - @d_event_date  ELAPSED		
		RETURN ;
	END
		


			-- 2021.04.30 KSW PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전으로 신규생성
            --  구 버전에서 PIVOT 생성단계 이후 단계를 호출하는 로직으로 분리함 (1 YEAR 구간별 생성 :: 중장기 구현시 컬럼 및 행 SIZE 제약 해결)
			
			-- 동일 플랜의 구 data 삭제
			IF @p_is_debug = 0
			DELETE FROM SCP_XLS_PSI_GLOBAL                            
                    WHERE DIVISION_ID = @p_division_id ; -- AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd AND PLAN_TYPE = @p_plan_type AND SEQ = @p_seq


			DECLARE @rows INT;  
			DECLARE @p_create_from_yyyymmdd  NVARCHAR(0008);
			DECLARE @p_create_to_yyyymmdd    NVARCHAR(0008);

			--  Plan End Date
			DECLARE @v_pet_date		NVARCHAR(12) = '';
			SET @v_bp_flag			= '';
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
			IF @p_is_debug = 0
			EXEC @rows = PR_SCP_XLS_PSI_GLOBAL_S                  @p_plan_cycle             = @p_plan_cycle          
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
																--, @p_is_debug			= @p_is_debug
																;
            IF (@rows < 0)  GOTO _RETURN_ERR_CODE
			
			--PRINT 'PR_SCP_XLS_PSI_GLOBAL_S START'

			IF @v_bp_flag = 'Y'
			BEGIN 
				-- 2 YEAR PIVOT data 생성
				SET @p_create_from_yyyymmdd = CONVERT(VARCHAR(8), DATEADD(day, 1, @p_create_to_yyyymmdd), 112);
				SET @p_create_to_yyyymmdd   = CONVERT(VARCHAR(8), DATEADD(day, 363, @p_create_from_yyyymmdd), 112);
				IF @p_is_debug = 0
				EXEC @rows = PR_SCP_XLS_PSI_GLOBAL_S                  @p_plan_cycle             = @p_plan_cycle          
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
																	--, @p_is_debug			= @p_is_debug
																	;
				IF (@rows < 0)  GOTO _RETURN_ERR_CODE

			END

			--PRINT '임시 TEMP  테이블 DROP'
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

              IF OBJECT_ID('tempdb..#PSI_GLOBAL_AUTO') IS NOT NULL      
	              DROP TABLE #PSI_GLOBAL_AUTO;        
                
              IF OBJECT_ID('tempdb..#INTRANSIT')  IS NOT NULL       
		            DROP TABLE #INTRANSIT

              IF OBJECT_ID('tempdb..#PLN_TH_ENG_STOCK_PLAN') IS NOT NULL	
	              DROP TABLE #PLN_TH_ENG_STOCK_PLAN

              IF OBJECT_ID('tempdb..#PLN_TH_ENG_STOCK_PLAN_FOR_HOLD') IS NOT NULL	
	              DROP TABLE #PLN_TH_ENG_STOCK_PLAN_FOR_HOLD

              IF OBJECT_ID('tempdb..#PLN_TH_ENG_STOCK_PLAN_FOR_WH_HOLD') IS NOT NULL	
	                DROP TABLE #PLN_TH_ENG_STOCK_PLAN_FOR_WH_HOLD

              IF OBJECT_ID('tempdb..#SCP_MST_BOD_V') IS NOT NULL      
	              DROP TABLE #SCP_MST_BOD_V; 

              IF OBJECT_ID('tempdb..#LineLoad')   IS NOT NULL
	              DROP TABLE #LineLoad              

              IF OBJECT_ID('tempdb..#LineLoad_WEEK_PIVOT')   IS NOT NULL
	              DROP TABLE #LineLoad_WEEK_PIVOT              

              IF OBJECT_ID('tempdb..#TRANSPORT_MODE') IS NOT NULL      
	              DROP TABLE #TRANSPORT_MODE;

              IF OBJECT_ID('tempdb..#SCP_XLS_PSI_GLOBAL_AUTO_MODEL_INVENTORY') IS NOT NULL      
	              DROP TABLE #SCP_XLS_PSI_GLOBAL_AUTO_MODEL_INVENTORY;                  
              
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

			   -- PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 [추가개선] - HOLD 가 포함되지 않음 - PACK HOLD 만 해당
               IF OBJECT_ID('tempdb..#BOH_NHOLD') IS NOT NULL	
	                DROP TABLE #BOH_NHOLD

	            IF OBJECT_ID('tempdb..#SCP_XLS_PSI_GLOBAL_AUTO') IS NOT NULL       
		            DROP TABLE #SCP_XLS_PSI_GLOBAL_AUTO    

               IF OBJECT_ID('tempdb..#tmp_SCP_MST_TACT_TIME') IS NOT NULL	
	              DROP TABLE #tmp_SCP_MST_TACT_TIME

			   -------------------------------------------------------------------------------------------------------------------------      
			   -- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2)
			   -- PACK_PROD, CELL_PROD - CAPA Line Assign(Tact Time) 에 따른 출하/생산계획 추가 - 임시테이블 삭제
			   -------------------------------------------------------------------------------------------------------------------------    
			   IF OBJECT_ID('tempdb..#LINE_ASSIGN') IS NOT NULL	
					DROP TABLE #LINE_ASSIGN

			   IF OBJECT_ID('tempdb..#LINE_ASSIGN_ORG') IS NOT NULL	
					DROP TABLE #LINE_ASSIGN_ORG

			   -- MODULE 의 상위 모델을 찾기위한 temp 테이블
               IF OBJECT_ID('tempdb..#temp_MODEL_INFO') IS NOT NULL      
	              DROP TABLE #temp_MODEL_INFO; 

				-------------------------------------------------------------------------------------------------------------
				-- PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 - PACK BOH (Hold, Wait for Inspection, Expected Inspection date) 추가
				-------------------------------------------------------------------------------------------------------------
				IF OBJECT_ID('tempdb..#PLN_TH_ENG_STOCK_PLAN_INSP') IS NOT NULL	
						DROP TABLE #PLN_TH_ENG_STOCK_PLAN_INSP
										
						
				-- 중복생성으로 인한 수량중복을 방지하기 위해서 임시작업 테이블에 저장
				IF OBJECT_ID('tempdb..#tmp_PSI_GLOBAL_AUTO') IS NOT NULL	
						DROP TABLE #tmp_PSI_GLOBAL_AUTO		

              IF OBJECT_ID('tempdb..#tmp_SCP_MST_DIO_OLD') IS NOT NULL	
	              DROP TABLE #tmp_SCP_MST_DIO_OLD

              IF OBJECT_ID('tempdb..#tmp_SCP_MST_DIO') IS NOT NULL	
	              DROP TABLE #tmp_SCP_MST_DIO

              IF OBJECT_ID('tempdb..#tmp_NICK_NAME') IS NOT NULL	
	              DROP TABLE #tmp_NICK_NAME

		
        -----------------------------------------------------------      
        -- 실행 Logic END --      
        -----------------------------------------------------------      
        --IF @@TRANCOUNT > 0      
        --  BEGIN      
        --    COMMIT TRAN ;      
        --  END;             
       
	     --PRINT '완료 로깅 시작'
      
        -- TXN LOG      
        SET @v_log_type     = N'TXN';        
        SET @n_log_count    = @@ROWCOUNT;      
        SET @v_log_message  = N'INSERT INTO '+@v_table_id;      
        SET @v_description  = N'Process Complete...' + ':' + CONVERT(CHAR(8), @d_event_date, 112);      
        SET @d_event_date   = SYSDATETIME();            
	    IF @p_is_debug  = 0
        EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
                                  ,@p_log_type      = @v_log_type      
                                  ,@p_log_count     = @n_log_count       
                                  ,@p_log_message   = @v_log_message       
                                  ,@p_description   = @v_description       
                                  ,@p_event_date    = @d_event_date       
                                  ,@p_user_id       = @v_batch_user      
                                  ;            
		 --PRINT '완료'     
    END TRY      
      
    BEGIN CATCH      
      --IF @@TRANCOUNT > 0      
      --  BEGIN      
      --    ROLLBACK TRAN T1      
      --  END;      
            
      -- ERROR LOG      
	   --PRINT @@ERROR    
	   --PRINT ERROR_MESSAGE();    
	   --PRINT  ERROR_LINE();   

      SET @v_log_type     = N'ERROR';      
      SET @v_log_message  = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));      
      SET @v_description  = @v_program_name + N'ERROR_LINE : ' + STR(ERROR_LINE());      
      SET @d_event_date   = SYSDATETIME();    
	  IF @p_is_debug  = 0 
      EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
                                ,@p_log_type      = @v_log_type      
                                ,@p_log_count     = @n_log_count       
                                ,@p_log_message  = @v_log_message       
                                ,@p_description   = @v_description       
                                ,@p_event_date    = @d_event_date       
                                ,@p_user_id       = @v_batch_user      
                                ;        
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
	IF @p_is_debug  = 0
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
  
  




