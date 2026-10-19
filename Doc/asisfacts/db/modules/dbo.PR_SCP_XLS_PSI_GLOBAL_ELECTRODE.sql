/*      
 * Program ID   : PR_SCP_XLS_PSI_GLOBAL_ELECTRODE       
 * Description  : PR_SCP_XLS_CREATE_DATA 에서 호출함.      
 * OutTable     :      
 * Execute      : 
    -- DELETE FROM SCM_SYS_LOG_BATCH where CREATED_BY ='kth'
      EXEC PR_SCP_XLS_PSI_GLOBAL_ELECTRODE
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
 
    SELECT * FROM SCM_SYS_LOG_BATCH  where PROGRAM_NAME ='PR_SCP_XLS_PSI_GLOBAL_ELECTRODE' order by CREATION_DATE desc

 * Program History      
 *===================================================================================================      
 *   Date       In Charge      Description      
 *===================================================================================================      
 * 2019.07.29   KTH         Initial Release [PJ20189106] 전지.GSCM 고도화 이행
 * 2019.09.26   KTH          1. 조립 계획 숫자는 Cell 수량으로 BOM을 환산하지 않도록 하여 출력
                             2. 조립 계획의 From Site가 달라 발생하는 중복 현상 발생
                             3. 전극 Site의 재고 뿐만아니라 조립 Site에도 해당 재고 표기
                             4. 전극 계획 조정 DB의 Prod Plan(Amend) Measure 추가
 * 2019.10.02   KTH          전극 (PROD_PLAN)로직 변경 
 * 2019.10.08   KTH          전극 (PROD_PLAN)로직 TACK_TIME의 LINE_ID 추가
 * 2019.12.13   KTH          전체 로직 변경으로 재개발
 * 2019.12.20   KTH          SALES 로직 추가
 * 2019.12.23   KTH          PRODUCTION 로직 추가
 * 2020.01.02   KTH          INVENTORY 로직 추가
 * 2020.01.08   KTH          #Rn 테이블 변경
 * 2020.01.17   KTH          ETC 로직 추가
 * 2020.01.20   KTH          코드명 대신 코드로 보여주는 걸로 변경
 * 2020.02.06   KTH          ESS 외주 Line별 생산 Target 관련 OSP_YN로직 수정(SCM_MST_LINE_SN --> SCM_MST_LINE_V 변경)
 * 2020.02.06   KTH          ETC_RATE 로직 반영
 * 2020.02.11   KTH          'PROD_TACT_TIME','PROD_WORKING_TIME' MEASURE 추가 (JUMBO_MIN)
 * 2020.02.13   KTH          ETC_RATE(Conversion Rate) 로직 반영
 * 2020.02.14   KTH          SCM_QTY --> CONVERT_QTY 
 * 2020.02.18   KTH          TACT_TIME 계산식 변경 (1/E.TACT_TIME * 60 /E.TACT_TIME) 
 * 2020.02.20   KTH          SCP_ANL_TACT_TIME UPDATE로직 추가
 * 2020.02.24   KTH          TACT TIME 로직 변경(40이고, EA 일 경우 원통형 (CASE WHEN ATTRIBUTE1 ='EA' THEN ATTRIBUTE3 ELSE TACT_TIME END ))
 * 2020.02.25   KTH          Conversion Rate(ETC_RATE) 로직 수정
 * 2020.02.26   KTH          MEASURE(Y_SUM) 추가, 광폭여부 MEASURE_VALUE2_LABEL 반영
 * 2020.02.27   KTH          ETC_YIELD 보정(중복 제거 및 '-' 데이터 삭제)
 * 2020.03.09   KTH          ETC_YIELD 로직 수정
 * 2020.03.12   KTH          SCM_MST_YIELD_SN 사용하는 ETC_YIELD 추가
 * 2020.03.16   KTH          [C20200311-000310] 전극 시뮬레이터 생산Line 기준 - Tact Time 등록 기준으로 변경 - PROD_PLAN_AMEND 에는 없으나, TACT TIME에는 있는 LINE ID 추가
 * 2020.03.16   KTH          TACT_TIME 로직 변경 SCP_ANL_TACT_TIME --> (SCP_MST_TACT_TIME/SCP_MST_TACT_TIME_EXCEPT)
 * 2020.03.25   KTH          P_SUM MEASURE 추가
 * 2020.03.30   KTH          TACT_TIME_EXCEPT Yield 로직 반영 
 * 2020.04.01   KTH          ETC_YIELD 로직 변경
 * 2020.04.07   KTH          [C20200323-000351] GSCM 전극 simulator 내 BOH 조회 기능 수정 개선의 건
 * 2020.04.09   KTH          [C20200408-000376] 시뮬레이터 생산계획 창 미표시의 건
 * 2020.04.18   KTH          ETC_RATE 공란계산 오류 수정
 * 2020.04.27   KTH          TACT_TIME ATTRIBUTE3,ATTRIBUTE4 계산 로직 변경
 * 2020.05.11   KTH          PROD_TACT_TIME,PROD_WORKING_TIME, 각각 단위 JB/M, M 추가
 * 2020.05.19   KTH          SCP_XLS_PSI_GLOBAL_ELECTRODE_BOM 기준으로 INVENTORY_BOH UPDATE 로직 반영
 * 2020.06.01   KTH          생산라인 입력 추가 기능(XLS_KEY1 생성로직 변경 XLS_KEY1*1000 )
 * 2020.06.04   KTH          INVENTORY_BOH 생성로직 변경 ITEM_ID --> ELEC_ITEM_ID
 * 2020.06.15   KTH          ETC_LT NULL 처리 추가
 * 2020.07.02   KSW          전지 공급 대응력 향상을 위한 SCM 관리 체계 개선 - DIO 기준/최소 컬럼추가, GAP_PRE_GRO_DIO, GAP_PRE_MIN_DIO Measure 추가     
 * 2020.07.13   KSW          전지 공급 대응력 향상을 위한 SCM 관리 체계 개선 - DIO 수정 관련 - 기준/최소 쿼리에서 YYYYMM -> YYYYQ 으로 변경
 * 2020.07.28   KSW          [C20200311-000310] CSR 처리로직에서 누락되는 Case 보완 :: ANL (#PSI_GLOBAL_LINE의 소스가 되는...) 에서 PROD_PLAN_AMEND 자체가 없을 경우
 * 2021.05.10   KSW          PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - (LT 고도화 과제) SCP_MST_BOD --> SCP_MST_BOD_V 으로 변경
 * 2021.06.14   KSW          PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 대응
                             - 구 버전에서 PIVOT 생성단계 이후 단계를 호출하는 로직으로 분리함 (+26주 구간별 생성 :: 중장기 구현시 컬럼 및 행 SIZE 제약 해결)
							 - 실제로는 364 + 364 플랜 DATA 가 생성됨
 * 2021.07.13   KSW          C20210702-000348 - 전극 시뮬레이터 내 BOH 보류재고 반영 로직 수정 요청의 건 - 전극 보류 재고 Measure 추가
 * 2021.11.15   KSW          튜닝개선적용
 * 2021.11.22   KSW          튜닝개선 2차 적용
 * 2022.03.21   KSW          GM JV 반영
 * 2023.03.13   HRK			[PJ20230691R] LGES SCM 역량 강화 위한 SCP 개선과제 이행 
 *							 - SCP_XLS_PSI_GLOBAL_ELECTRODE_BOM(BOH) 테이블 PK 컬럼 추가 반영 (ELEC_DIVISION_ID : EE/EE_UC) 
 * 2023.05.08	KSK			[PJ20230691] SCM 역량 강화 위한 SCP 개선과제 이행 (ESHM JV 사업부 지원)
 * 2025.09.22	KSK			[E20250901-000049] 최적화 엔진을 적용한 신규 전극 Simulator 개선, 고도화 요청(Semi Ship Plan 조회 안됨 조치 필요)
  */    


CREATE PROCEDURE [dbo].[PR_SCP_XLS_PSI_GLOBAL_ELECTRODE]
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
    ---- , @p_debug       INT OUTPUT      
)       
AS        
  BEGIN      
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;      
    SET NOCOUNT ON;      
    SET XACT_ABORT ON;      
    SET ANSI_WARNINGS OFF;      
      
    -- LOG 용 변수 설정      
    DECLARE @v_batch_user   NVARCHAR(150) = N'SCP_batch';        
    SET @v_batch_user                     = @p_user_id      
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SCP_XLS_PSI_GLOBAL_ELECTRODE';      
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...      
    DECLARE @n_log_count    INTEGER = 0;      
    DECLARE @v_log_message  NVARCHAR(1000);      
    DECLARE @v_description  NVARCHAR(500);    
    DECLARE @v_table_id     NVARCHAR(150) = N'SCM_SYS_LOG_BATCH';   
    DECLARE @d_event_date   DATETIME;      
  
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

    DECLARE @p_program_id   NVARCHAR(30) = 'XLSPSI05'          
    DECLARE @p_to_yyyymmdd  VARCHAR(8)   =  ''		--CONVERT(VARCHAR(8), DATEADD(day, 728, @p_plan_start_yyyymmdd), 112)
    DECLARE @p_cutoff_date  VARCHAR(8)   =  CONVERT(VARCHAR(8), DATEADD(day,  -1, @p_plan_start_yyyymmdd), 112)

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
	            SELECT M.COLUMN_NAME, M.COLUMN_LABEL_NAME,M.SMALL_CLASS_LABEL_NAME,M.SORT_ORDER_NO,ATTRIBUTE1 AS GUBUN
              INTO #MEASURE
  	          FROM SCM_MST_SHEET_MEASURE M WITH(NOLOCK)
	            WHERE M.PROGRAM_ID      = @p_program_id
	              AND M.VALID_YN        = 'Y'

            -------------------------------------------------------------------------------------------------------------         
            --  임시테이블 생성
            -------------------------------------------------------------------------------------------------------------     
              IF OBJECT_ID('tempdb..#PSI_GLOBAL') IS NOT NULL      
	              DROP TABLE #PSI_GLOBAL;        

	            CREATE TABLE #PSI_GLOBAL (
                DIVISION_ID             NVARCHAR(030)   NOT NULL,
	              CELL_TYPE_GROUP_CODE    NVARCHAR(1)     NULL,
	              NICK_NAME               NVARCHAR(200)   NULL,
                ELECTRODE_TYPE          NVARCHAR(30)    NULL,
                ITEM_ID                 NVARCHAR(50)    NULL,
                FROM_SITE_ID            NVARCHAR(30)    NULL,
                FROM_SITE_DESCRIPTION   NVARCHAR(150)   NULL,
                TO_SITE_ID              NVARCHAR(30)    NULL,
                TO_SITE_DESCRIPTION     NVARCHAR(150)   NULL,
                LT_WEEK                 INT             NULL,
                CONVERT_QTY_CELL        NUMERIC(20, 10) NULL,
                PROD_LINE               NVARCHAR(50)    NULL,
                PSI_TYPE                NVARCHAR(10)    NULL,   -- 추가
	              MEASURE                 NVARCHAR(50)    NULL,
                MEASURE_LABEL	          NVARCHAR(150)	  NULL,   -- 추가
                MEASURE_VALUE1          NVARCHAR(50)    NULL,   -- 변경
                MEASURE_VALUE1_LABEL	  NVARCHAR(150)	  NULL,   -- 추가
                MEASURE_VALUE2          NVARCHAR(50)    NULL,   -- 추가
                MEASURE_VALUE2_LABEL	  NVARCHAR(150)	  NULL,   -- 추가
                UNIT                    NVARCHAR(100)   NULL,   -- 추가
                CELL_ITEM_ID            NVARCHAR(50)    NULL,
                BOH                     NUMERIC(20,10)  NULL,
                QTY				              NUMERIC(20,10)  NULL,
                YYYYMMDD                NVARCHAR(008)   NULL,
                SORT_ORDER_NO           INT             NULL,
                ORIGIN_FROM_DIVISION_ID	NVARCHAR(30)    NULL,
                ORIGIN_TO_DIVISION_ID	  NVARCHAR(30)    NULL,
                ATTRIBUTE1			        NVARCHAR(150)   NULL,       
                ATTRIBUTE7			        NVARCHAR(150)   NULL,   -- Sale SCP_MST_MODEL_ALLOCATION 구분용
                ATTRIBUTE8			        NVARCHAR(150)   NULL,   -- SORT NO 
		            ATTRIBUTE9			        NVARCHAR(150)   NULL    -- OPERATION_ID
	            );

            -------------------------------------------------------------------------------------------------------------------------         
            -- 조립계획 (SHIP_PLAN)  SCP_ANL_PSI_PRODUCTION 테이블에서 PSI_TYPE='S'
            -------------------------------------------------------------------------------------------------------------------------
            -------------------------------------------------------------------------------------------------------------------------         
            -- 전극에 반영될 최종 PLAN 대상 임시테이블 새성
            -------------------------------------------------------------------------------------------------------------------------

	        IF OBJECT_ID('tempdb..#tmp_SCM_MST_LINE_V') IS NOT NULL	
	            DROP TABLE #tmp_SCM_MST_LINE_V       
				
			SELECT DISTINCT LINE_ID, LINE_NAME into #tmp_SCM_MST_LINE_V from SCM_MST_LINE_V


             IF OBJECT_ID('tempdb..#PLAN_CYCLE') IS NOT NULL      
	              DROP TABLE #PLAN_CYCLE;  

                SELECT *
                  INTO #PLAN_CYCLE
                  FROM (
                        SELECT       
                              M.PLAN_CYCLE
                              ,P.PLAN_NAME AS PLAN_START_YYYYMMDD
                              ,P.PLAN_ID
                              ,M.MODELING_ID
                              ,D.PLAN_SEQ
                              ,D.PLAN_TYPE
                              ,D.DIVISION_ID+'::'+M.PLAN_CYCLE AS MASTER_ID
                              ,D.DIVISION_ID
                              ,P.PLAN_ID+'::'+D.PLAN_TYPE+'::'+CONVERT(VARCHAR,D.PLAN_SEQ) AS ENG_PLAN_ID
       
                              ,D.UI_DISPLAY_YN
                              ,D.ACTIVE_FLAG
                              ,D.PLAN_STATUS
                              ,D.CREATION_DATE
                              ,ROW_NUMBER() OVER(PARTITION BY  D.DIVISION_ID
                                                    ORDER BY  D.DIVISION_ID
                                                            ,P.PLAN_NAME DESC
                                                            ,(CASE D.PLAN_TYPE  WHEN 'PR' THEN '1' 
                                                                                WHEN 'MA' THEN '2' 
                                                                                WHEN 'SE' THEN '3' 
                                                                                WHEN 'FN' THEN '4' ELSE '0' END) DESC
                                                            ,D.PLAN_SEQ  DESC
                                                            ,D.CREATION_DATE DESC) AS RN
                              ,D.CONFIRM_FLAG
                              ,D.CONFIRM_DATE
                        FROM SCM_MST_PLAN_DETAIL D WITH(NOLOCK),        
                              SCM_MST_PLAN        P WITH(NOLOCK),        
                            SCM_MST_MODELING    M WITH(NOLOCK)        
                        WHERE 1=1        
                          AND M.MODELING_ID   = D.MODELING_ID        
                          AND M.DIVISION_ID   = D.DIVISION_ID        
                          AND M.MODELING_ID   = D.MODELING_ID        
                          AND P.DIVISION_ID   = D.DIVISION_ID        
                          AND P.PLAN_CYCLE    = M.PLAN_CYCLE        
                          AND P.PLAN_ID       = D.PLAN_ID     
                          AND P.PLAN_CYCLE    ='WEEKLY'
						  AND dbo.FN_IS_DIVISION(@p_division_id, 'ELECTRODE',  D.DIVISION_ID) =1
                          AND D.PLAN_STATUS   ='1'
                    ) XX
                  WHERE XX.RN = 1
                  
            INSERT INTO #PSI_GLOBAL
               SELECT DISTINCT  X.DIVISION_ID
                      ,NULL   AS CELL_TYPE_GROUP_CODE
                      ,(SELECT TOP 1 NICK_NAME 
                                FROM SCP_MST_FINAL_ITEM B  WITH (NOLOCK)
                              WHERE 0 = 0
                                AND B.ITEM_ID = V.CHILD_ITEM_ID
                              ) AS NICK_NAME
                      ,X.ELECTRODE_TYPE
                      ,V.CHILD_ITEM_ID      AS ITEM_ID
                      ,Y.ELEC_PLANT_SITE_ID AS FROM_SITE     -- Supply_Site
                      ,NULL                 AS FROM_SITE_DESCRIPTION
                      ,X.SCM_SITE_ID        AS TO_SITE
                      ,NULL                 AS TO_SITE_DESCRIPTION
                      ,NULL                 AS LT_WEEK
                      ,NULL                 AS CONVERT_QTY_CELL
                      ,X.LINE_ID            AS PROD_LINE
                      ,'Sale'               AS PSI_TYPE
                      --,'SHIP_PLAN'        AS MEASURE 
                      --,'SHIP_PLAN'        AS MEASURE_LABEL
                      ,M.COLUMN_NAME        AS MEASURE 
                      ,M.COLUMN_LABEL_NAME  AS MEASURE_LABEL
                      ,X.LINE_ID            AS MEASURE_VALUE1
                      ,ISNULL((SELECT TOP 1 Y.LINE_NAME FROM #tmp_SCM_MST_LINE_V Y WITH (NOLOCK) WHERE Y.LINE_ID = X.LINE_ID), '-') AS MEASURE_VALUE1_LABEL   
                      ,Y.CELL_ITEM_ID       AS MEASURE_VALUE2
                      ,Y.CELL_ITEM_ID       AS MEASURE_VALUE2_LABEL
                      ,'CELL'               AS UNIT
                      ,Y.CELL_ITEM_ID       AS CELL_ITEM_ID
                      ,NULL                 AS BOH
                      ,X.QTY      
                      ,X.YYYYMMDD
                      ,M.SORT_ORDER_NO      AS SORT_ORDER_NO
                      ,X.ORIGIN_DIVISION_ID AS ORIGIN_FROM_DIVISION_ID
                      ,NULL                 AS ORIGIN_TO_DIVISION_ID
                      , 'S'                 AS ATTRIBUTE1		
                      , '1'                 AS ATTRIBUTE7
                      , '2'                 AS ATTRIBUTE8 -- 전체 정렬
			                , X.ATTRIBUTE9	
                    FROM SCP_ANL_PRODUCTION_PLAN X WITH (NOLOCK)		-- 튜닝개선 - #PLAN_CYCLE 을 먼저 조인
                    INNER JOIN #PLAN_CYCLE Z  WITH (NOLOCK)
                      ON X.DIVISION_ID          = Z.DIVISION_ID
                     AND X.PLAN_START_YYYYMMDD  = Z.PLAN_START_YYYYMMDD
                     AND X.PLAN_TYPE            = Z.PLAN_TYPE
                     AND X.SEQ                  = Z.PLAN_SEQ
                    LEFT OUTER JOIN SCP_MST_MODEL_ALLOCATION Y WITH (NOLOCK)
                      ON 0 = 0
                      AND X.DIVISION_ID = Y.DIVISION_ID
                      AND X.SCM_SITE_ID = Y.CELL_PLANT_SITE_ID
                      AND X.ITEM_ID     = Y.CELL_ITEM_ID
                      AND X.LINE_ID     = Y.CELL_LINE_ID
                      AND X.YYYYMMDD    = Y.YYYYMMDD
                      AND Y.VALID_YN    ='Y'
                    LEFT OUTER JOIN SCM_MST_MODEL_FINAL_ITEM_BOM_V V WITH (NOLOCK)
                      ON 0 = 0
                     AND V.MODEL_ID            =  X.ITEM_ID 
                     AND V.PLANT_ID            = LEFT(X.SCM_SITE_ID,4)
                     AND V.OPERATION_GROUP_ID  = 'E'
--                   AND V.ELECTRODE_TYPE      = 'CATHODE'
                    --INNER JOIN #PLAN_CYCLE Z  WITH (NOLOCK)
                    --  ON X.DIVISION_ID          = Z.DIVISION_ID
                    -- AND X.PLAN_START_YYYYMMDD  = Z.PLAN_START_YYYYMMDD
                    -- AND X.PLAN_TYPE            = Z.PLAN_TYPE
                    -- AND X.SEQ                  = Z.PLAN_SEQ
                    INNER JOIN #MEASURE M WITH(NOLOCK)	
                       ON M.COLUMN_NAME          IN ('SHIP_PLAN')
                    WHERE  0 = 0
                      AND X.MEASURE             ='PROD_PLAN_AMEND'  

                  

			---- START E20250901-000049 Semi Ship Plan 조회 안됨 조치 필요
   --         INSERT INTO #PSI_GLOBAL
   --            SELECT DISTINCT  X.DIVISION_ID
   --                   ,NULL   AS CELL_TYPE_GROUP_CODE
			--		  -- , (SELECT TOP 1 ITEM_ID FROM  SCP_MST_FINAL_ITEM B  WITH (NOLOCK) WHERE B.ITEM_ID = X.ITEM_ID) AS NICK_NAME
			--		  , B.NICK_NAME
   --                   ,X.ELECTRODE_TYPE
   --                   , X.ITEM_ID
   --                   , X.FROM_SITE
   --                   ,NULL                 AS FROM_SITE_DESCRIPTION
   --                   ,X.TO_SITE       -- AS TO_SITE
   --                   ,NULL                 AS TO_SITE_DESCRIPTION
   --                   ,NULL                 AS LT_WEEK
   --                   ,NULL                 AS CONVERT_QTY_CELL
   --                   ,'-'            AS PROD_LINE
   --                   ,'Sale'               AS PSI_TYPE
   --                   ,'SHIP_PLAN'        AS MEASURE 
   --                   ,'SHIP PLAN'		  AS MEASURE_LABEL
   --                   ,'-'            AS MEASURE_VALUE1
   --                   ,'-' AS MEASURE_VALUE1_LABEL   
   --                   ,B.CELL_ITEM_ID       AS MEASURE_VALUE2
   --                   ,B.CELL_ITEM_ID       AS MEASURE_VALUE2_LABEL
   --                   ,'CELL'               AS UNIT
   --                   ,B.CELL_ITEM_ID       AS CELL_ITEM_ID
   --                   ,NULL                 AS BOH
   --                   ,X.QTY      
   --                   ,X.YYYYMMDD
   --                   ,M.SORT_ORDER_NO      AS SORT_ORDER_NO
   --                   ,X.ORIGIN_FROM_DIVISION_ID AS ORIGIN_FROM_DIVISION_ID
   --                   ,X.ORIGIN_TO_DIVISION_ID                                        
			--		  , 'S'                 AS ATTRIBUTE1		
   --                   , '1'                 AS ATTRIBUTE7
   --                   , '2'                 AS ATTRIBUTE8 -- 전체 정렬
			--                , X.ATTRIBUTE9	
			--		FROM SCP_ANL_SHIPMENT_PLAN_SEMI X WITH(NOLOCK) 
			--		INNER JOIN #MEASURE M WITH(NOLOCK)	ON M.COLUMN_NAME       = 'SHIP_PLAN'
			--		LEFT JOIN SCP_MST_FINAL_ITEM B  WITH (NOLOCK)
			--			ON B.DIVISION_ID = X.ORIGIN_FROM_DIVISION_ID
			--			AND B.ITEM_ID = X.ITEM_ID
			--		WHERE 1=1
			--		AND X.DIVISION_ID = @p_division_id
			--		AND X.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
			--		AND X.PLAN_TYPE = @p_plan_type
			--	    AND X.SEQ					        =  @p_seq
		 --           AND X.YYYYMMDD BETWEEN @p_plan_start_yyyymmdd AND @p_to_yyyymmdd		         
   --                 AND X.MEASURE =  'SHIP_PLAN'			
			--	-- END E20250901-000049 Semi Ship Plan 조회 안됨 조치 필요



              -- SCP_MST_MODEL_ALLOCATION VALID_YN이 Y인 data가 2건 이상일때
              IF OBJECT_ID('tempdb..#SCP_MST_MODEL_ALLOCATION_MULTI') IS NOT NULL      
	              DROP TABLE #SCP_MST_MODEL_ALLOCATION_MULTI;

                 SELECT *
                  INTO #SCP_MST_MODEL_ALLOCATION_MULTI
                  FROM (
                      SELECT DIVISION_ID,CELL_ITEM_ID,CELL_PLANT_SITE_ID,CELL_LINE_ID,ELEC_PLANT_SITE_ID,YYYYMMDD
                      ,ROW_NUMBER() OVER(PARTITION BY DIVISION_ID,CELL_ITEM_ID,CELL_PLANT_SITE_ID,CELL_LINE_ID,YYYYMMDD ORDER BY ELEC_PLANT_SITE_ID) AS Rn
                      FROM SCP_MST_MODEL_ALLOCATION A WITH (NOLOCK)
                  WHERE 0 = 0
                     AND VALID_YN ='Y'
                  ) XX
                  WHERE 0 = 0
                  AND XX.rn > 1


               INSERT INTO #PSI_GLOBAL
               SELECT X.DIVISION_ID
                      ,X.CELL_TYPE_GROUP_CODE
                      ,X.NICK_NAME
                      ,X.ELECTRODE_TYPE
                      ,X.ITEM_ID
                      ,P.PLANT_SITE_ID          AS FROM_SITE_ID     -- Supply_Site
                      ,X.FROM_SITE_DESCRIPTION
                      ,X.TO_SITE_ID
                      ,X.TO_SITE_DESCRIPTION
                      ,X.LT_WEEK
                      ,X.CONVERT_QTY_CELL
                      ,X.PROD_LINE
                      ,X.PSI_TYPE
                      ,X.MEASURE 
                      ,X.MEASURE_LABEL
                      ,X.MEASURE_VALUE1
                      ,X.MEASURE_VALUE1_LABEL
                      ,X.MEASURE_VALUE2
                      ,X.MEASURE_VALUE2_LABEL
                      ,X.UNIT
                      ,X.CELL_ITEM_ID
                      ,X.BOH
                      ,X.QTY      
                      ,X.YYYYMMDD
                      ,X.SORT_ORDER_NO
                      ,X.ORIGIN_FROM_DIVISION_ID
                      ,X.ORIGIN_TO_DIVISION_ID
                      ,X.ATTRIBUTE1		
                      , '2'             AS ATTRIBUTE7
                      ,X.ATTRIBUTE8
			                ,X.ATTRIBUTE9	
                    FROM #PSI_GLOBAL X WITH (NOLOCK)
                    INNER JOIN #SCP_MST_MODEL_ALLOCATION_MULTI M WITH (NOLOCK)
                      ON X.DIVISION_ID  = M.DIVISION_ID
                     AND X.CELL_ITEM_ID = M.CELL_ITEM_ID
                     AND X.TO_SITE_ID   = M.CELL_PLANT_SITE_ID
                     AND X.PROD_LINE    = M.CELL_LINE_ID
                     AND X.YYYYMMDD     = M.YYYYMMDD  
                    INNER JOIN SCM_MST_SITE_ITEM_PRIORITY P WITH (NOLOCK)
                      ON 0 = 0
                     AND P.DIVISION_ID  = X.DIVISION_ID
                     AND P.ITEM_ID      = X.ITEM_ID            
                     AND X.YYYYMMDD     >= P.FROM_YYYYMMDD 
                     AND X.YYYYMMDD     <= P.TO_YYYYMMDD
                     AND P.PRIORITY      = '1'

                     
                 UPDATE X
                   SET X.ELECTRODE_TYPE = (SELECT TOP 1  ELECTRODE_TYPE
                                             FROM SCP_MST_FINAL_ITEM A WITH (NOLOCK)
                                 WHERE A.DIVISION_ID       = X.DIVISION_ID
                                              AND A.ITEM_ID           = X.ITEM_ID
                                              AND A.OPERATION_GROUP_ID= 'E'
                                          )
                  FROM #PSI_GLOBAL X				  
                 --WHERE OPERATION_GROUP   = 'P'
                 ;

                 -- Y가 1건인 DATA중 ALLOCATION 값이 2건 이상으로 반영된 DATA 삭제
                 DELETE FROM  X
                 FROM #PSI_GLOBAL X WITH (NOLOCK)
                    INNER JOIN #SCP_MST_MODEL_ALLOCATION_MULTI M WITH (NOLOCK)
                      ON X.DIVISION_ID  = M.DIVISION_ID
                     AND X.CELL_ITEM_ID = M.CELL_ITEM_ID
                     AND X.TO_SITE_ID   = M.CELL_PLANT_SITE_ID
                     AND X.PROD_LINE    = M.CELL_LINE_ID
                     AND X.YYYYMMDD     = M.YYYYMMDD 
                 WHERE X.ATTRIBUTE7 = '1'   -- Y가 1인건

                 -- 중복제거
                  DELETE TBL FROM
	                (
	                        SELECT
	                               ROW_NUMBER() OVER (PARTITION BY DIVISION_ID,NICK_NAME,ELECTRODE_TYPE,ITEM_ID,FROM_SITE_ID,TO_SITE_ID,PROD_LINE,CELL_ITEM_ID,MEASURE,YYYYMMDD
                                 ORDER BY ATTRIBUTE1) AS ROWNUM
--                                 ,*
	                        FROM #PSI_GLOBAL
	                ) AS TBL
	                WHERE TBL.ROWNUM > 1


 
            -------------------------------------------------------------------------------------------------------------------------         
            --전극 AMEND (PROD_PLAN_AMEND)  SCP_ANL_PRODUCTION_PLAN 에서 MEASURE ='PROD_PLAN_AMEND'  
            -------------------------------------------------------------------------------------------------------------------------
            -- INSERT INTO #PSI_GLOBAL              
             IF OBJECT_ID('tempdb..#PSI_GLOBAL_LINE') IS NOT NULL      
                DROP TABLE #PSI_GLOBAL_LINE;

               SELECT A.DIVISION_ID
                      ,NULL AS CELL_TYPE_GROUP_CODE
                      ,(SELECT TOP 1 NICK_NAME 
                          FROM SCP_MST_FINAL_ITEM B  WITH (NOLOCK)
                         WHERE 0 = 0
                           AND B.ITEM_ID = A.ITEM_ID
                        )                 AS NICK_NAME
                      ,A.ELECTRODE_TYPE
                      ,A.ITEM_ID          AS ITEM_ID
                      ,A.SCM_SITE_ID      AS FROM_SITE_ID
                      ,NULL               AS FROM_SITE_DESCRIPTION
                      ,'-'                AS TO_SITE_ID
                      ,NULL               AS TO_SITE_DESCRIPTION
                      ,NULL               AS LT_WEEK
                      ,NULL               AS CONVERT_QTY_CELL
                      ,LINE_ID            AS PROD_LINE
                      ,'Production'       AS PSI_TYPE
                      ,M.COLUMN_NAME      AS MEASURE 
                      ,M.COLUMN_LABEL_NAME  AS MEASURE_LABEL
                      ,A.LINE_ID          AS MEASURE_VALUE1
                      ,ISNULL((SELECT TOP 1 Y.LINE_NAME FROM #tmp_SCM_MST_LINE_V Y WITH (NOLOCK) WHERE Y.LINE_ID = A.LINE_ID), '-') AS MEASURE_VALUE1_LABEL  
                      ,NULL               AS MEASURE_VALUE2
                      ,NULL               AS MEASURE_VALUE2_LABEL
                      ,'CELL'             AS UNIT
                      ,A.ITEM_ID          AS CELL_ITEM_ID
                      ,NULL               AS BOH
                      ,QTY      
                      ,A.YYYYMMDD
                      ,M.SORT_ORDER_NO    AS SORT_ORDER_NO
                      ,ORIGIN_DIVISION_ID AS ORIGIN_FROM_DIVISION_ID
                      ,''                 AS ORIGIN_TO_DIVISION_ID
                      , 'P'               AS ATTRIBUTE1				
                      , NULL              AS ATTRIBUTE7
                      , '4'               AS ATTRIBUTE8
			                , A.OPERATION_ID      AS ATTRIBUTE9							
                  INTO #PSI_GLOBAL_LINE
                  FROM SCP_ANL_PRODUCTION_PLAN A WITH (NOLOCK)
                 INNER JOIN #MEASURE M WITH(NOLOCK)	
                    ON M.COLUMN_NAME          IN ('PROD_PLAN_AMEND')
                  WHERE 0 = 0
                    AND A.DIVISION_ID         = @p_division_id
                    AND A.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
                    AND A.PLAN_TYPE           = @p_plan_type
                    AND A.SEQ                 = @p_seq
                    AND A.YYYYMMDD            >=  @p_plan_start_yyyymmdd
		                AND A.YYYYMMDD            <=   @p_to_yyyymmdd  --말일포함(KSK, 20240814)
                    AND A.MEASURE             = M.COLUMN_NAME
--                    AND A.ITEM_ID             = @p_item_id
                    AND A.OPERATION_GROUP    ='E'


            
                
            -------------------------------------------------------------------------------------------------------------         
            -- ITEM_ID별 TACT TIME 조회
            -------------------------------------------------------------------------------------------------------------      
            
            IF OBJECT_ID('tempdb..#tmp_SCM_SYS_CALENDAR_M') IS NOT NULL	
	              DROP TABLE #tmp_SCM_SYS_CALENDAR_M

                SELECT C.BASIS_YYYYMMDD AS YYYYMMDD      
                      ,'QTY' + REPLICATE('0', 3 - LEN(ROW_NUMBER() OVER(ORDER BY BASIS_YYYYMMDD) )) + CONVERT(NVARCHAR,ROW_NUMBER() OVER(ORDER BY BASIS_YYYYMMDD)) AS YYYYMMDD_COLUMN
                  INTO #tmp_SCM_SYS_CALENDAR_M
                  FROM SCM_SYS_CALENDAR_M    C WITH(NOLOCK)     
                WHERE 1=1  
                  AND C.BASIS_YYYYMMDD >= @p_plan_start_yyyymmdd
                  AND C.BASIS_YYYYMMDD <=  @p_to_yyyymmdd	  --말일포함(KSK, 20240814)	
				  -- CONVERT(VARCHAR,DATEADD(D,364,CONVERT(DATETIME,@p_plan_start_yyyymmdd,112)),112)  -- PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 플랜 대응


            IF OBJECT_ID('tempdb..#tmp_SCP_MST_TACT_TIME') IS NOT NULL	
	              DROP TABLE #tmp_SCP_MST_TACT_TIME

            IF OBJECT_ID('tempdb..#tmp_SCP_ANL_TACT_TIME_1') IS NOT NULL	
	              DROP TABLE #tmp_SCP_ANL_TACT_TIME_1

            IF OBJECT_ID('tempdb..#tmp_SCP_ANL_TACT_TIME_2') IS NOT NULL	
	              DROP TABLE #tmp_SCP_ANL_TACT_TIME_2

                SELECT T.DIVISION_ID
                        ,T.PLANT_SITE_ID
                        ,T.OPERATION_ID
                        ,T.LINE_ID
                        ,T.ITEM_ID
                        ,T.ITEM_UOM
                        ,T.TACT_TIME
                        ,YYYYMMDD
                        ,YYYYMMDD_COLUMN
                        ,'Y' AS YN
                        ,'Y' AS USE_YN
                        ,AA.ATTRIBUTE3
                        ,T.ATTRIBUTE1 AS ATTRIBUTE4
				INTO #tmp_SCP_ANL_TACT_TIME_1
                FROM SCP_MST_TACT_TIME T WITH(NOLOCK)
                LEFT OUTER JOIN (SELECT MAX(ATTRIBUTE3) AS ATTRIBUTE3, ITEM_ID, LINE_ID
                                    FROM SCP_ANL_TACT_TIME A WITH (NOLOCK)
                                    WHERE 0 = 0
                                    AND ATTRIBUTE3 IS NOT NULL
                                    GROUP BY ITEM_ID,LINE_ID
                                    ) AA
                    ON T.ITEM_ID = AA.ITEM_ID
                    AND T.LINE_ID = AA.LINE_ID
                CROSS APPLY #tmp_SCM_SYS_CALENDAR_M Y WITH (NOLOCK)
                WHERE 1=1
                    AND T.VALID_YN   = 'Y'
                    AND T.ITEM_ID IN (SELECT ITEM_ID FROM #PSI_GLOBAL  WITH (NOLOCK))
        --        AND S.OSP_YN     <> 'Y'
		;

                SELECT DIVISION_ID
                        ,PLANT_SITE_ID AS SCM_SITE_ID
                        ,OPERATION_ID
                        ,X.LINE_ID
                        ,X.ITEM_ID
                        ,AA.ITEM_UOM
                        ,(CASE USE_YN WHEN 'N' THEN 0.0 ELSE TACT_TIME END) AS TACT_TIME
                        ,YYYYMMDD
                        ,YYYYMMDD_COLUMN
                        ,'N' AS YN
                        ,USE_YN
                        ,AA.ATTRIBUTE3
                        ,(SELECT TOP 1 A.ATTRIBUTE1 FROM SCP_MST_TACT_TIME A WITH (NOLOCK) WHERE A.ITEM_ID = X.ITEM_ID AND A.LINE_ID = X.LINE_ID ) AS ATTRIBUTE4
				INTO #tmp_SCP_ANL_TACT_TIME_2
                FROM SCP_MST_TACT_TIME_EXCEPT X WITH(NOLOCK)
                LEFT OUTER JOIN (SELECT MAX(ATTRIBUTE1) AS ITEM_UOM, MAX(ATTRIBUTE3) AS ATTRIBUTE3, ITEM_ID, LINE_ID
                                    FROM SCP_ANL_TACT_TIME A WITH (NOLOCK)
                                WHERE 0 = 0
                                    AND ATTRIBUTE3 IS NOT NULL
                                    GROUP BY ITEM_ID, LINE_ID
                                    ) AA
                    ON X.ITEM_ID = AA.ITEM_ID
                    AND X.LINE_ID = AA.LINE_ID
					AND X.USE_YN = 'Y'
                CROSS APPLY #tmp_SCM_SYS_CALENDAR_M Y WITH (NOLOCK)
                WHERE 0 = 0
                    AND Y.YYYYMMDD >= TACT_TIME_START_DATE
                    AND Y.YYYYMMDD <= TACT_TIME_END_DATE
                    AND X.ITEM_ID IN (SELECT ITEM_ID FROM #PSI_GLOBAL  WITH (NOLOCK))
					;


              SELECT DIVISION_ID,PLANT_SITE_ID,OPERATION_ID,LINE_ID,ITEM_ID,TACT_TIME,YYYYMMDD,YYYYMMDD_COLUMN,ITEM_UOM
                    ,(CASE WHEN LEN(RTRIM(LTRIM(ATTRIBUTE3))) = 0 THEN 0 ELSE CONVERT(numeric (20,10),ATTRIBUTE3) END ) AS ATTRIBUTE3
                    ,(CASE WHEN LEN(RTRIM(LTRIM(ATTRIBUTE4))) = 0 THEN 0 ELSE CONVERT(numeric (20,10),ATTRIBUTE4) END ) AS ATTRIBUTE4
                INTO #tmp_SCP_MST_TACT_TIME
                FROM (
                      SELECT X.DIVISION_ID,PLANT_SITE_ID,OPERATION_ID,LINE_ID,ITEM_ID,TACT_TIME,YYYYMMDD,YYYYMMDD_COLUMN
                            ,YN
                            ,USE_YN
                            ,ITEM_UOM,X.ATTRIBUTE3,X.ATTRIBUTE4
                            ,ROW_NUMBER() OVER (PARTITION BY X.DIVISION_ID,PLANT_SITE_ID,OPERATION_ID,LINE_ID,ITEM_ID,YYYYMMDD ORDER BY YN) AS Rn
                            ,ISNULL((SELECT COUNT(LS.ACTIVE_FLAG) 
                                      FROM SCM_MST_LINE_SN LS 
												              WHERE 0 = 0
                                        --AND LS.COMPANY_ID   = B.COMPANY_ID 
                                        AND LS.DIVISION_ID  = X.DIVISION_ID 
                                        --AND LS.SITE_ID      = B.PLANT_SITE_ID 
                                        AND LS.PLANT_ID     = B.PLANT_ID 
												                AND LS.OPERATION_ID = X.OPERATION_ID 
                                        AND LS.LINE_ID      = X.LINE_ID 
                                        AND LS.ACTIVE_FLAG='Y'), 0) ACTIVE_CNT
                      FROM
                      (
                --       SELECT T.DIVISION_ID
                --              ,T.PLANT_SITE_ID
                --              ,T.OPERATION_ID
                --              ,T.LINE_ID
                --              ,T.ITEM_ID
                --              ,T.ITEM_UOM
                --              ,T.TACT_TIME
                --              ,YYYYMMDD
                --              ,YYYYMMDD_COLUMN
                --              ,'Y' AS YN
                --              ,'Y' AS USE_YN
                --              ,AA.ATTRIBUTE3
                --              ,T.ATTRIBUTE1 AS ATTRIBUTE4
                --        FROM SCP_MST_TACT_TIME T WITH(NOLOCK)
                --        LEFT OUTER JOIN (SELECT MAX(ATTRIBUTE3) AS ATTRIBUTE3, ITEM_ID, LINE_ID
                --                           FROM SCP_ANL_TACT_TIME A WITH (NOLOCK)
                --                          WHERE 0 = 0
                --                            AND ATTRIBUTE3 IS NOT NULL
                --                         GROUP BY ITEM_ID,LINE_ID
                --                         ) AA
                --          ON T.ITEM_ID = AA.ITEM_ID
                --         AND T.LINE_ID = AA.LINE_ID
                --        CROSS APPLY #tmp_SCM_SYS_CALENDAR_M Y WITH (NOLOCK)
                --        WHERE 1=1
                --          AND T.VALID_YN   = 'Y'
                --          AND T.ITEM_ID IN (SELECT ITEM_ID FROM #PSI_GLOBAL  WITH (NOLOCK))
                ----        AND S.OSP_YN     <> 'Y'
                
					  SELECT * FROM #tmp_SCP_ANL_TACT_TIME_1
                      UNION ALL

       --                SELECT DIVISION_ID
       --                       ,PLANT_SITE_ID AS SCM_SITE_ID
       --                       ,OPERATION_ID
       --                       ,X.LINE_ID
       --                       ,X.ITEM_ID
       --                       ,AA.ITEM_UOM
       --                       ,(CASE USE_YN WHEN 'N' THEN 0.0 ELSE TACT_TIME END) AS TACT_TIME
       --                       ,YYYYMMDD
       --                       ,YYYYMMDD_COLUMN
       --                       ,'N' AS YN
       --                       ,USE_YN
       --                       ,AA.ATTRIBUTE3
       --                       ,(SELECT TOP 1 A.ATTRIBUTE1 FROM SCP_MST_TACT_TIME A WITH (NOLOCK) WHERE A.ITEM_ID = X.ITEM_ID AND A.LINE_ID = X.LINE_ID ) AS ATTRIBUTE4
       --                 FROM SCP_MST_TACT_TIME_EXCEPT X WITH(NOLOCK)
       --                 LEFT OUTER JOIN (SELECT MAX(ATTRIBUTE1) AS ITEM_UOM, MAX(ATTRIBUTE3) AS ATTRIBUTE3, ITEM_ID, LINE_ID
       --                                   FROM SCP_ANL_TACT_TIME A WITH (NOLOCK)
       --                                 WHERE 0 = 0
       --                                   AND ATTRIBUTE3 IS NOT NULL
       --                                  GROUP BY ITEM_ID, LINE_ID
       --                                  ) AA
       --                   ON X.ITEM_ID = AA.ITEM_ID
       --                  AND X.LINE_ID = AA.LINE_ID
						 --AND X.USE_YN = 'Y'
       --                 CROSS APPLY #tmp_SCM_SYS_CALENDAR_M Y WITH (NOLOCK)
       --                 WHERE 0 = 0
       --                   AND Y.YYYYMMDD >= TACT_TIME_START_DATE
       --                   AND Y.YYYYMMDD <= TACT_TIME_END_DATE
       --                   AND X.ITEM_ID IN (SELECT ITEM_ID FROM #PSI_GLOBAL  WITH (NOLOCK))

					  SELECT * FROM #tmp_SCP_ANL_TACT_TIME_2
                      ) X
                       INNER JOIN SCM_MST_SITE B WITH(NOLOCK)
                        ON X.DIVISION_ID = B.DIVISION_ID 
                       AND X.PLANT_SITE_ID = B.SCM_SITE_ID			 
                ) XX

                WHERE Rn = 1
                  AND ITEM_ID IN (SELECT ITEM_ID FROM #PSI_GLOBAL  WITH (NOLOCK))
                  AND USE_YN = 'Y'
                  ANd ACTIVE_CNT > 0


              
            -------------------------------------------------------------------------------------------------------------         
            -- [C20200408-000376] 시뮬레이터 생산계획 창 미표시의 건
            -- 생산(PROD_PLAN_AMEND)가 1건도 없을 경우 TACT_TIME LINE 추가 
            -------------------------------------------------------------------------------------------------------------
            INSERT INTO #PSI_GLOBAL_LINE
              SELECT  DISTINCT  @p_division_id AS DIVISION_ID					-- 2022.03.21 GM JV 반영	'EE' --> @p_division_id			
			                        , X.CELL_TYPE_GROUP_CODE						
			                        , X.NICK_NAME		
                              , X.ELECTRODE_TYPE
			                        , X.ITEM_ID										
			                        , X.FROM_SITE_ID  AS FROM_SITE_ID
                              , NULL          AS FROM_SITE_DESCRIPTION
                              , '-'           AS TO_SITE_ID
                              , NULL          AS TO_SITE_DESCRIPTION
			                        , '0'           AS LT_WEEK										
			                        , '0'           AS CONVERT_QTY_CELL									
			                        , '-'           AS PROD_LINE 										
			                        , 'Production'  AS PSI_TYPE
                              , M.COLUMN_NAME AS MEASURE
                              , M.COLUMN_LABEL_NAME  AS MEASURE_LABEL
                              , '-' AS MEASURE_VALUE1
                              , '-' AS MEASURE_VALUE1_LABEL
                              , NULL          AS MEASURE_VALUE2
                              , NULL          AS MEASURE_VALUE2_LABEL
                              , 'CELL'        AS UNIT
                              , X.ITEM_ID     AS CELL_ITEM_ID
                              , NULL          AS BOH
                              , 0             AS QTY
						                  , X.YYYYMMDD	
			                        , M.SORT_ORDER_NO								
                              , X.DIVISION_ID          AS ORIGIN_FROM_DIVISION_ID
                              , ''          AS ORIGIN_TO_DIVISION_ID
                              , 'P' AS ATTRIBUTE1
                              , NULL AS ATTRIBUTE7
                              ,'4'  AS ATTRIBUTE8
			                        , 'X'          AS ATTRIBUTE9										
              FROM #PSI_GLOBAL X WITH(NOLOCK)
              CROSS APPLY #MEASURE M WITH (NOLOCK)                                 
              WHERE 1=1          
                AND M.COLUMN_NAME IN ('PROD_PLAN_AMEND')  -- PROD_PLAN_AMEND  PROD_PLAN_TOTAL
                AND X.ITEM_ID NOT IN (
                                       SELECT ITEM_ID
                                        FROM #PSI_GLOBAL_LINE X WITH (NOLOCK)
  
                  )
                AND X.FROM_SITE_ID IS NOT NULL
				;



            -------------------------------------------------------------------------------------------------------------         
            -- [C20200311-000310] LINE_ID 추가  ( PROD_PLAN_AMEND 에 라인은 없으나, TACT TIME에는 있는 LINE ID 추가)
            -------------------------------------------------------------------------------------------------------------            
            -- 'PROD_PLAN_AMEND'의 LINE_ID 종류 별 추가 
               INSERT INTO #PSI_GLOBAL_LINE
                SELECT DISTINCT X.DIVISION_ID
                      ,X.CELL_TYPE_GROUP_CODE
                      ,X.NICK_NAME
                      ,X.ELECTRODE_TYPE
                      ,X.ITEM_ID
                      ,X.FROM_SITE_ID
                      ,X.FROM_SITE_DESCRIPTION
                      ,X.TO_SITE_ID
                      ,X.TO_SITE_DESCRIPTION
                      ,X.LT_WEEK
                      ,X.CONVERT_QTY_CELL
                      ,Y.LINE_ID AS PROD_LINE   --
                      ,X.PSI_TYPE
                      ,X.MEASURE 
                      ,X.MEASURE_LABEL
                      ,Y.LINE_ID          AS MEASURE_VALUE1   --
                      ,ISNULL((SELECT TOP 1 A.LINE_NAME FROM #tmp_SCM_MST_LINE_V A WITH (NOLOCK) WHERE A.LINE_ID = Y.LINE_ID), '-') AS MEASURE_VALUE1_LABEL    --
                      ,X.MEASURE_VALUE2
                      ,X.MEASURE_VALUE2_LABEL
                      ,X.UNIT
                      ,X.CELL_ITEM_ID
                      ,X.BOH
                      ,0 AS QTY      
                      ,Y.YYYYMMDD --
                      ,X.SORT_ORDER_NO      -- 
                      ,X.ORIGIN_FROM_DIVISION_ID
                      ,X.ORIGIN_TO_DIVISION_ID
                      ,X.ATTRIBUTE1				
                      ,X.ATTRIBUTE7
                      ,X.ATTRIBUTE8
			                ,(CASE WHEN ATTRIBUTE9 ='X' THEN Y.OPERATION_ID  ELSE X.ATTRIBUTE9 END ) AS  ATTRIBUTE9	
                      FROM #PSI_GLOBAL_LINE X WITH (NOLOCK) 
                      CROSS APPLY #tmp_SCP_MST_TACT_TIME Y  WITH (NOLOCK)
                      WHERE 0 = 0
                        AND X.ORIGIN_FROM_DIVISION_ID = Y.DIVISION_ID 
                        --AND X.ATTRIBUTE9              = Y.OPERATION_ID 
					              AND X.FROM_SITE_ID            = Y.PLANT_SITE_ID 
					              --AND X.PROD_LINE               = Y.LINE_ID 
                        AND X.ITEM_ID                 = Y.ITEM_ID 
					              AND X.YYYYMMDD                = Y.YYYYMMDD
                        AND X.MEASURE                 IN  ('PROD_PLAN_AMEND')
                        
                        AND NOT EXISTS (                
                                            SELECT 'X'                
                                              FROM #PSI_GLOBAL_LINE Z WITH(NOLOCK)                
                                             WHERE 1=1                
                                               AND Z.ORIGIN_FROM_DIVISION_ID  = X.DIVISION_ID                
                                               AND Z.ITEM_ID                  = X.ITEM_ID              
                                               AND Z.MEASURE                  = X.MEASURE 
                                               AND Z.FROM_SITE_ID             = X.FROM_SITE_ID
                                               AND Z.PROD_LINE                = X.PROD_LINE
                                               AND Z.YYYYMMDD                 = X.YYYYMMDD
                                               AND Z.MEASURE                  IN ('PROD_PLAN_AMEND')
                                               )
                  


                  -- LINE_ID가 '-' 인 PROD_PLAN_AMEND가 없는 데이터 삭제
                --DELETE FROM #PSI_GLOBAL_LINE
                --WHERE PROD_LINE ='-'
                --  AND MEASURE ='PROD_PLAN_AMEND'

            -------------------------------------------------------------------------------------------------------------         
            -- [C20200311-000310] CSR 처리로직에서 누락되는 Case 보완 :: ANL (#PSI_GLOBAL_LINE의 소스가 되는...) 에서 PROD_PLAN_AMEND 자체가 없을 경우 - start 
            -------------------------------------------------------------------------------------------------------------
      --         INSERT INTO #PSI_GLOBAL_LINE
			   -- SELECT *
				  --FROM (
						--SELECT DISTINCT 'EE'      AS DIVISION_ID
						--	  ,NULL               AS CELL_TYPE_GROUP_CODE
						--	  ,(SELECT TOP 1 NICK_NAME 
						--		  FROM SCP_MST_FINAL_ITEM B  WITH (NOLOCK)
						--		 WHERE 0 = 0
						--		   AND B.ITEM_ID = X.ITEM_ID
						--		)                 AS NICK_NAME
						--	  ,(SELECT TOP 1 ELECTRODE_TYPE 
						--		  FROM SCP_MST_FINAL_ITEM B  WITH (NOLOCK)
						--		 WHERE 0 = 0
						--		   AND B.ITEM_ID = X.ITEM_ID
						--		)                 AS ELECTRODE_TYPE
						--	  ,X.ITEM_ID
						--	  ,X.PLANT_SITE_ID    AS FROM_SITE_ID
						--	  ,NULL               AS FROM_SITE_DESCRIPTION
						--	  ,'-'                AS TO_SITE
						--	  ,NULL               AS TO_SITE_DESCRIPTION
						--	  ,NULL               AS LT_WEEK
						--	  ,NULL               AS CONVERT_QTY_CELL
						--	  ,X.LINE_ID          AS PROD_LINE
						--	  ,'Production'       AS PSI_TYPE
						--	  ,'PROD_PLAN_AMEND'  AS MEASURE 
						--	  ,(SELECT TOP 1 M.COLUMN_LABEL_NAME
  				--				  FROM SCM_MST_SHEET_MEASURE M WITH(NOLOCK)
						--			WHERE M.PROGRAM_ID      = 'XLSPSI05'
						--			  AND M.COLUMN_NAME     ='PROD_PLAN_AMEND'
						--			  AND M.VALID_YN        = 'Y') AS MEASURE_LABEL
						--	  ,X.LINE_ID          AS MEASURE_VALUE1   --
						--	  ,ISNULL((SELECT TOP 1 A.LINE_NAME FROM SCM_MST_LINE_V A WITH (NOLOCK) WHERE A.LINE_ID = X.LINE_ID), '-') AS MEASURE_VALUE1_LABEL    --
						--	  ,NULL               AS MEASURE_VALUE2
						--	  ,NULL               AS MEASURE_VALUE2_LABEL
						--	  ,'CELL'             AS UNIT
						--	  ,X.ITEM_ID          AS CELL_ITEM_ID
						--	  ,NULL               AS BOH
						--	  ,0                  AS QTY      
						--	  ,X.YYYYMMDD
						--	  ,(SELECT TOP 1 M.SORT_ORDER_NO
  				--				  FROM SCM_MST_SHEET_MEASURE M WITH(NOLOCK)
						--			WHERE M.PROGRAM_ID      = 'XLSPSI05'
						--			  AND M.COLUMN_NAME     ='PROD_PLAN_AMEND'
						--			  AND M.VALID_YN        = 'Y') AS SORT_ORDER_NO  
						--	  ,X.DIVISION_ID      AS ORIGIN_FROM_DIVISION_ID
						--	  ,''                 AS ORIGIN_TO_DIVISION_ID
						--	  ,'P'                AS ATTRIBUTE1				
						--	  ,NULL               AS ATTRIBUTE7
						--	  ,'4'                AS ATTRIBUTE8
						--	  ,X.OPERATION_ID     AS  ATTRIBUTE9

						--	  -- #tmp_SCP_MST_TACT_TIME 쿼리를 변형 - #PSI_GLOBAL 의 ITEM_ID 조건대신 PLANT_ID 로 변경
						--	  FROM (SELECT DIVISION_ID,PLANT_SITE_ID,OPERATION_ID,LINE_ID,ITEM_ID,TACT_TIME,YYYYMMDD--,YYYYMMDD_COLUMN,ITEM_UOM
						--					,(CASE WHEN LEN(RTRIM(LTRIM(ATTRIBUTE3))) = 0 THEN 0 ELSE CONVERT(numeric (20,10),ATTRIBUTE3) END ) AS ATTRIBUTE3
						--					,(CASE WHEN LEN(RTRIM(LTRIM(ATTRIBUTE4))) = 0 THEN 0 ELSE CONVERT(numeric (20,10),ATTRIBUTE4) END ) AS ATTRIBUTE4
						--				FROM (
						--					  SELECT X.DIVISION_ID,PLANT_SITE_ID,OPERATION_ID,LINE_ID,ITEM_ID,TACT_TIME,YYYYMMDD--,YYYYMMDD_COLUMN
						--							,YN
						--							,USE_YN
						--							,ITEM_UOM,X.ATTRIBUTE3,X.ATTRIBUTE4
						--							,ROW_NUMBER() OVER (PARTITION BY X.DIVISION_ID,PLANT_SITE_ID,OPERATION_ID,LINE_ID,ITEM_ID,YYYYMMDD ORDER BY YN) AS Rn
						--							,ISNULL((SELECT COUNT(LS.ACTIVE_FLAG) 
						--									  FROM SCM_MST_LINE_SN LS 
						--															  WHERE 0 = 0
						--										--AND LS.COMPANY_ID   = B.COMPANY_ID 
						--										AND LS.DIVISION_ID  = X.DIVISION_ID 
						--										--AND LS.SITE_ID      = B.PLANT_SITE_ID 
						--										AND LS.PLANT_ID     = B.PLANT_ID 
						--																AND LS.OPERATION_ID = X.OPERATION_ID 
						--										AND LS.LINE_ID      = X.LINE_ID 
						--										AND LS.ACTIVE_FLAG='Y'), 0) ACTIVE_CNT
						--					  FROM
						--					  (
						--					   SELECT T.DIVISION_ID
						--							  ,T.PLANT_SITE_ID
						--							  ,T.OPERATION_ID
						--							  ,T.LINE_ID
						--							  ,T.ITEM_ID
						--							  ,T.ITEM_UOM
						--							  ,T.TACT_TIME
						--							  ,YYYYMMDD
						--							  --,YYYYMMDD_COLUMN
						--							  ,'Y' AS YN
						--							  ,'Y' AS USE_YN
						--							  ,AA.ATTRIBUTE3
						--							  ,T.ATTRIBUTE1 AS ATTRIBUTE4
						--						FROM SCP_MST_TACT_TIME T WITH(NOLOCK)
						--						LEFT OUTER JOIN (SELECT MAX(ATTRIBUTE3) AS ATTRIBUTE3, ITEM_ID, LINE_ID
						--										  FROM SCP_ANL_TACT_TIME A WITH (NOLOCK)
						--										WHERE 0 = 0
						--										  AND ATTRIBUTE3 IS NOT NULL
						--										 GROUP BY ITEM_ID,LINE_ID
						--										 ) AA
						--						  ON T.ITEM_ID = AA.ITEM_ID
						--						 AND T.LINE_ID = AA.LINE_ID
						--						--CROSS APPLY #tmp_SCM_SYS_CALENDAR_M Y WITH (NOLOCK)
						--						CROSS APPLY (
						--									  SELECT @p_plan_start_yyyymmdd AS YYYYMMDD
						--									   UNION ALL
						--									  SELECT CONVERT(VARCHAR(8), DATEADD(day, 364, @p_plan_start_yyyymmdd), 112) AS YYYYMMDD
						--									) Y
						--						WHERE 1=1
						--						  AND T.VALID_YN   = 'Y'
						--						  AND T.PLANT_SITE_ID IN (SELECT DISTINCT FROM_SITE_ID FROM #PSI_GLOBAL  WITH (NOLOCK))
						--				--        AND S.OSP_YN     <> 'Y'
                

						--					  UNION ALL

						--					   SELECT DIVISION_ID
						--							  ,PLANT_SITE_ID AS SCM_SITE_ID
						--							  ,OPERATION_ID
						--							  ,X.LINE_ID
						--							  ,X.ITEM_ID
						--							  ,AA.ITEM_UOM
						--							  ,(CASE USE_YN WHEN 'N' THEN 0.0 ELSE TACT_TIME END) AS TACT_TIME
						--							  ,YYYYMMDD
						--							  --,YYYYMMDD_COLUMN
						--							  ,'N' AS YN
						--							  ,USE_YN
						--							  ,AA.ATTRIBUTE3
						--							  ,(SELECT TOP 1 A.ATTRIBUTE1 FROM SCP_MST_TACT_TIME A WITH (NOLOCK) WHERE A.ITEM_ID = X.ITEM_ID AND A.LINE_ID = X.LINE_ID ) AS ATTRIBUTE4
						--						FROM SCP_MST_TACT_TIME_EXCEPT X WITH(NOLOCK)
						--						LEFT OUTER JOIN (SELECT MAX(ATTRIBUTE1) AS ITEM_UOM, MAX(ATTRIBUTE3) AS ATTRIBUTE3, ITEM_ID, LINE_ID
						--										  FROM SCP_ANL_TACT_TIME A WITH (NOLOCK)
						--										WHERE 0 = 0
						--										 GROUP BY ITEM_ID, LINE_ID
						--										 ) AA
						--						  ON X.ITEM_ID = AA.ITEM_ID
						--						 AND X.LINE_ID = AA.LINE_ID
						--						--CROSS APPLY #tmp_SCM_SYS_CALENDAR_M Y WITH (NOLOCK)
						--						CROSS APPLY (
						--									  SELECT @p_plan_start_yyyymmdd AS YYYYMMDD
						--									   UNION ALL
						--									  SELECT CONVERT(VARCHAR(8), DATEADD(day, 364, @p_plan_start_yyyymmdd), 112) AS YYYYMMDD
						--									) Y
						--						WHERE 0 = 0
						--						  AND Y.YYYYMMDD >= TACT_TIME_START_DATE
						--						  AND Y.YYYYMMDD <= TACT_TIME_END_DATE
						--						  AND X.PLANT_SITE_ID IN (SELECT DISTINCT FROM_SITE_ID FROM #PSI_GLOBAL  WITH (NOLOCK))
						--					  ) X
						--					   INNER JOIN SCM_MST_SITE B WITH(NOLOCK)
						--						ON X.DIVISION_ID = B.DIVISION_ID 
						--					   AND X.PLANT_SITE_ID = B.SCM_SITE_ID			 
						--				) XX

						--				WHERE Rn = 1
						--				  AND PLANT_SITE_ID IN (SELECT DISTINCT FROM_SITE_ID FROM #PSI_GLOBAL  WITH (NOLOCK))
						--				  AND USE_YN = 'Y'
						--				  ANd ACTIVE_CNT > 0) X
						--	  WHERE 0 = 0
						--	 ) XX   ;
      --      -- [C20200311-000310] CSR 처리로직에서 누락되는 Case 보완 :: ANL (#PSI_GLOBAL_LINE의 소스가 되는...) 에서 PROD_PLAN_AMEND 자체가 없을 경우 - end

				IF OBJECT_ID('tempdb..#tmp_FROM_SITE_ID') IS NOT NULL      
				    DROP TABLE #tmp_FROM_SITE_ID

			    SELECT DISTINCT FROM_SITE_ID INTO #tmp_FROM_SITE_ID FROM #PSI_GLOBAL  WITH (NOLOCK)

               INSERT INTO #PSI_GLOBAL_LINE
			    SELECT *
				  FROM (
						SELECT DISTINCT @p_division_id      AS DIVISION_ID			-- 2022.03.21 GM JV 반영	'EE' --> @p_division_id
							  ,NULL               AS CELL_TYPE_GROUP_CODE
							  ,(SELECT TOP 1 NICK_NAME 
								  FROM SCP_MST_FINAL_ITEM B  WITH (NOLOCK)
								 WHERE 0 = 0
								   AND B.ITEM_ID = X.ITEM_ID
								)                 AS NICK_NAME
							  ,(SELECT TOP 1 ELECTRODE_TYPE 
								  FROM SCP_MST_FINAL_ITEM B  WITH (NOLOCK)
								 WHERE 0 = 0
								   AND B.ITEM_ID = X.ITEM_ID
								)                 AS ELECTRODE_TYPE
							  ,X.ITEM_ID
							  ,X.PLANT_SITE_ID    AS FROM_SITE_ID
							  ,NULL               AS FROM_SITE_DESCRIPTION
							  ,'-'                AS TO_SITE
							  ,NULL               AS TO_SITE_DESCRIPTION
							  ,NULL               AS LT_WEEK
							  ,NULL               AS CONVERT_QTY_CELL
							  ,X.LINE_ID          AS PROD_LINE
							  ,'Production'       AS PSI_TYPE
							  ,'PROD_PLAN_AMEND'  AS MEASURE 
							  ,(SELECT TOP 1 M.COLUMN_LABEL_NAME
  								  FROM SCM_MST_SHEET_MEASURE M WITH(NOLOCK)
									WHERE M.PROGRAM_ID      = 'XLSPSI05'
									  AND M.COLUMN_NAME     ='PROD_PLAN_AMEND'
									  AND M.VALID_YN        = 'Y') AS MEASURE_LABEL
							  ,X.LINE_ID          AS MEASURE_VALUE1   --
							  ,ISNULL((SELECT TOP 1 A.LINE_NAME FROM #tmp_SCM_MST_LINE_V A WITH (NOLOCK) WHERE A.LINE_ID = X.LINE_ID), '-') AS MEASURE_VALUE1_LABEL    --
							  ,NULL               AS MEASURE_VALUE2
							  ,NULL               AS MEASURE_VALUE2_LABEL
							  ,'CELL'             AS UNIT
							  ,X.ITEM_ID          AS CELL_ITEM_ID
							  ,NULL               AS BOH
							  ,0                  AS QTY      
							  ,Y.YYYYMMDD
							  ,(SELECT TOP 1 M.SORT_ORDER_NO
  								  FROM SCM_MST_SHEET_MEASURE M WITH(NOLOCK)
									WHERE M.PROGRAM_ID      = 'XLSPSI05'
									  AND M.COLUMN_NAME     ='PROD_PLAN_AMEND'
									  AND M.VALID_YN        = 'Y') AS SORT_ORDER_NO  
							  ,X.DIVISION_ID      AS ORIGIN_FROM_DIVISION_ID
							  ,''                 AS ORIGIN_TO_DIVISION_ID
							  ,'P'                AS ATTRIBUTE1				
							  ,NULL               AS ATTRIBUTE7
							  ,'4'                AS ATTRIBUTE8
							  ,X.OPERATION_ID     AS  ATTRIBUTE9

							  -- #tmp_SCP_MST_TACT_TIME 쿼리를 변형 - #PSI_GLOBAL 의 ITEM_ID 조건대신 PLANT_ID 로 변경
							  FROM (SELECT DIVISION_ID,PLANT_SITE_ID,OPERATION_ID,LINE_ID,ITEM_ID
										FROM (
											  SELECT X.DIVISION_ID,PLANT_SITE_ID,OPERATION_ID,LINE_ID,ITEM_ID
											  FROM
											  (
											   SELECT T.DIVISION_ID
													  ,T.PLANT_SITE_ID
													  ,T.OPERATION_ID
													  ,T.LINE_ID
													  ,T.ITEM_ID
												FROM SCP_MST_TACT_TIME T WITH(NOLOCK)
												LEFT OUTER JOIN (SELECT MAX(ATTRIBUTE3) AS ATTRIBUTE3, ITEM_ID, LINE_ID
																  FROM SCP_ANL_TACT_TIME A WITH (NOLOCK)
																WHERE 0 = 0
																  AND ATTRIBUTE3 IS NOT NULL
																 GROUP BY ITEM_ID,LINE_ID
																 ) AA
												  ON T.ITEM_ID = AA.ITEM_ID
												 AND T.LINE_ID = AA.LINE_ID
												WHERE 1=1
												  AND T.VALID_YN   = 'Y'
												  AND T.PLANT_SITE_ID IN (SELECT DISTINCT FROM_SITE_ID FROM #tmp_FROM_SITE_ID  WITH (NOLOCK))     
												  AND T.OPERATION_ID = 'E2000'			-- 2021.11.19 KSW 후공정 제외												  
											  UNION ALL
											   SELECT DIVISION_ID
													  ,PLANT_SITE_ID AS SCM_SITE_ID
													  ,OPERATION_ID
													  ,X.LINE_ID
													  ,X.ITEM_ID
												FROM SCP_MST_TACT_TIME_EXCEPT X WITH(NOLOCK)
												LEFT OUTER JOIN (SELECT MAX(ATTRIBUTE1) AS ITEM_UOM, MAX(ATTRIBUTE3) AS ATTRIBUTE3, ITEM_ID, LINE_ID
																  FROM SCP_ANL_TACT_TIME A WITH (NOLOCK)
																WHERE 0 = 0
																  AND ATTRIBUTE3 IS NOT NULL
																 GROUP BY ITEM_ID, LINE_ID
																 ) AA
												  ON X.ITEM_ID = AA.ITEM_ID
												 AND X.LINE_ID = AA.LINE_ID
												WHERE 0 = 0
												  AND X.PLANT_SITE_ID IN (SELECT DISTINCT FROM_SITE_ID FROM #tmp_FROM_SITE_ID  WITH (NOLOCK))
												  AND X.USE_YN = 'Y'		--<<< 너무 많아서 제한
												  AND X.OPERATION_ID = 'E2000'			-- 2021.11.19 KSW 후공정 제외
											  ) X
											   INNER JOIN SCM_MST_SITE B WITH(NOLOCK)
												ON X.DIVISION_ID = B.DIVISION_ID 
											   AND X.PLANT_SITE_ID = B.SCM_SITE_ID			 
										) XX
									) X,
									(
										SELECT @p_plan_start_yyyymmdd AS YYYYMMDD
										UNION ALL
										SELECT CONVERT(VARCHAR(8), DATEADD(day, 364, @p_plan_start_yyyymmdd), 112) AS YYYYMMDD
									) Y
							  WHERE 0 = 0
							    AND X.OPERATION_ID = 'E2000'			-- 2021.11.19 KSW 후공정 제외
							 ) XX
							 ;
            -- [C20200311-000310] CSR 처리로직에서 누락되는 Case 보완 :: ANL (#PSI_GLOBAL_LINE의 소스가 되는...) 에서 PROD_PLAN_AMEND 자체가 없을 경우 - end



            INSERT INTO #PSI_GLOBAL
            SELECT 
                       X.DIVISION_ID
                      ,X.CELL_TYPE_GROUP_CODE
                      ,X.NICK_NAME
                      ,X.ELECTRODE_TYPE
                      ,X.ITEM_ID
                      ,X.FROM_SITE_ID
                      ,X.FROM_SITE_DESCRIPTION
                      ,X.TO_SITE_ID
                      ,X.TO_SITE_DESCRIPTION
                      ,X.LT_WEEK
                      ,X.CONVERT_QTY_CELL
                      ,X.PROD_LINE
                      ,X.PSI_TYPE
                      ,X.MEASURE 
                      ,X.MEASURE_LABEL
                      ,X.MEASURE_VALUE1
                      ,X.MEASURE_VALUE1_LABEL  
                      ,X.MEASURE_VALUE2
                      ,X.MEASURE_VALUE2_LABEL
                      ,X.UNIT
                      ,X.CELL_ITEM_ID
                      ,X.BOH
                      ,SUM(QTY) AS QTY      
                      ,X.YYYYMMDD
                      ,X.SORT_ORDER_NO      
                      ,X.ORIGIN_FROM_DIVISION_ID
                      ,X.ORIGIN_TO_DIVISION_ID
                      ,X.ATTRIBUTE1				
                      ,X.ATTRIBUTE7
                      ,X.ATTRIBUTE8
			                ,X.ATTRIBUTE9	
                      FROM #PSI_GLOBAL_LINE X  WITH (NOLOCK)
              GROUP BY X.DIVISION_ID
                      ,X.CELL_TYPE_GROUP_CODE
                      ,X.NICK_NAME
                      ,X.ELECTRODE_TYPE
                      ,X.ITEM_ID
                      ,X.FROM_SITE_ID
                      ,X.FROM_SITE_DESCRIPTION
                      ,X.TO_SITE_ID
                      ,X.TO_SITE_DESCRIPTION
                      ,X.LT_WEEK
                      ,X.CONVERT_QTY_CELL
                      ,X.PROD_LINE
                      ,X.PSI_TYPE
                      ,X.MEASURE 
                      ,X.MEASURE_LABEL
                      ,X.MEASURE_VALUE1
                      ,X.MEASURE_VALUE1_LABEL  
                      ,X.MEASURE_VALUE2
                      ,X.MEASURE_VALUE2_LABEL
                      ,X.UNIT
                      ,X.CELL_ITEM_ID
                      ,X.BOH
--                      ,0 AS QTY      
                      ,X.YYYYMMDD
                      ,X.SORT_ORDER_NO      -- ??
                      ,X.ORIGIN_FROM_DIVISION_ID
                      ,X.ORIGIN_TO_DIVISION_ID
                      ,X.ATTRIBUTE1				
                      ,X.ATTRIBUTE7
                      ,X.ATTRIBUTE8
			          ,X.ATTRIBUTE9	




            -------------------------------------------------------------------------------------------------------------------------         
            -- TACT TIME, WORKING TIME 추가
            -------------------------------------------------------------------------------------------------------------------------   
            INSERT #PSI_GLOBAL
              SELECT            X.DIVISION_ID								
			                        , X.CELL_TYPE_GROUP_CODE						
			                        , X.NICK_NAME		
                              , X.ELECTRODE_TYPE
			                        , X.ITEM_ID										
			                        , X.FROM_SITE_ID
                              , X.FROM_SITE_DESCRIPTION
                              , X.TO_SITE_ID
                              , X.TO_SITE_DESCRIPTION
			                        , X.LT_WEEK										
			                        , X.CONVERT_QTY_CELL									
			                        , X.PROD_LINE 										
			                        , X.PSI_TYPE
                              , M.COLUMN_NAME AS MEASURE
                              , M.COLUMN_LABEL_NAME       AS MEASURE_LABEL
                              , X.MEASURE_VALUE1
                              , X.MEASURE_VALUE1_LABEL
                              , X.MEASURE_VALUE2
                              , X.MEASURE_VALUE2_LABEL
                              , X.UNIT
                              , X.CELL_ITEM_ID
                              , X.BOH
                              , 0             AS QTY
						                  , X.YYYYMMDD	
			                        , M.SORT_ORDER_NO								
                              , X.ORIGIN_FROM_DIVISION_ID
                              , X.ORIGIN_TO_DIVISION_ID
                              , X.ATTRIBUTE1
                              , X.ATTRIBUTE7
                              , X.ATTRIBUTE8
			                        , X.ATTRIBUTE9										
              FROM #PSI_GLOBAL X WITH(NOLOCK)
              CROSS APPLY #MEASURE M WITH (NOLOCK)                                 
              WHERE 1=1          
                AND M.COLUMN_NAME IN ('PROD_TACT_TIME','PROD_WORKING_TIME')  
                AND X.MEASURE = 'PROD_PLAN_AMEND'




            -------------------------------------------------------------------------------------------------------------------------         
            -- WORKING TIME, TACT TIME 
            -------------------------------------------------------------------------------------------------------------------------

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

               

             --   UPDATE X
             --   SET X.QTY = D.WORKING_TIME
             --   FROM #PSI_GLOBAL X  WITH (NOLOCK)
             --   INNER JOIN #LINE_WORKINGTIME_BY_LOSS D  WITH (NOLOCK)
             --     ON  X.ORIGIN_FROM_DIVISION_ID   = D.DIVISION_ID 
             --     AND X.ATTRIBUTE9    = D.OPERATION_ID 
					        --AND X.FROM_SITE_ID  = D.SCM_SITE_ID 
					        --AND X.PROD_LINE     = D.LINE_ID 
					        --AND X.YYYYMMDD      = D.YYYYMMDD
             --     AND X.MEASURE       = 'PROD_WORKING_TIME'


				MERGE INTO #PSI_GLOBAL AS X
				USING (SELECT A.DIVISION_ID								
			                  , A.CELL_TYPE_GROUP_CODE						
			                  , A.NICK_NAME		
                              , A.ELECTRODE_TYPE
			                  , A.ITEM_ID										
			                  , A.FROM_SITE_ID
                              , A.FROM_SITE_DESCRIPTION
                              , A.TO_SITE_ID
                              , A.TO_SITE_DESCRIPTION
			                  , A.LT_WEEK										
			                  , A.CONVERT_QTY_CELL									
			                  , A.LINE_ID                 AS PROD_LINE 										
			                  , A.PSI_TYPE
                              , M.COLUMN_NAME             AS MEASURE
                              , M.COLUMN_LABEL_NAME       AS MEASURE_LABEL
                              , A.MEASURE_VALUE1
                              , A.MEASURE_VALUE1_LABEL
                              , A.MEASURE_VALUE2
                              , A.MEASURE_VALUE2_LABEL
                              , A.UNIT
                              , A.CELL_ITEM_ID
                              , A.BOH
                              , A.WORKING_TIME            AS QTY
						      , A.YYYYMMDD	
			                  , M.SORT_ORDER_NO								
                              , A.ORIGIN_FROM_DIVISION_ID
                              , A.ORIGIN_TO_DIVISION_ID
                              , A.ATTRIBUTE1
                              , A.ATTRIBUTE7
                              , A.ATTRIBUTE8
			                  , A.OPERATION_ID           AS ATTRIBUTE9		
						FROM (SELECT X.*, D.LINE_ID, D.WORKING_TIME, D.OPERATION_ID
						        FROM #PSI_GLOBAL X  WITH (NOLOCK)
								INNER JOIN #LINE_WORKINGTIME_BY_LOSS D  WITH (NOLOCK)
								ON  X.ORIGIN_FROM_DIVISION_ID   = D.DIVISION_ID 
								AND X.ATTRIBUTE9    = D.OPERATION_ID 
								AND X.FROM_SITE_ID  = D.SCM_SITE_ID 
								AND X.PROD_LINE     = D.LINE_ID 
								AND X.YYYYMMDD      = D.YYYYMMDD
								AND X.MEASURE       = 'PROD_WORKING_TIME'
						     ) A,
						     (SELECT * FROM #MEASURE WITH (NOLOCK) WHERE COLUMN_NAME = 'PROD_WORKING_TIME') M
					   WHERE 1 = 1
				      ) AS Y
				ON  X.ORIGIN_FROM_DIVISION_ID   = Y.DIVISION_ID 
                AND X.ATTRIBUTE9                = Y.ATTRIBUTE9 
				AND X.FROM_SITE_ID              = Y.FROM_SITE_ID 
				AND X.PROD_LINE                 = Y.PROD_LINE 
				AND X.YYYYMMDD                  = Y.YYYYMMDD
                AND X.MEASURE                   = 'PROD_WORKING_TIME'
				WHEN MATCHED  THEN
				UPDATE
				   SET X.QTY = ISNULL(Y.QTY,0)
				WHEN NOT MATCHED  THEN
				INSERT (
						  DIVISION_ID								
			            , CELL_TYPE_GROUP_CODE						
			            , NICK_NAME		
                        , ELECTRODE_TYPE
			            , ITEM_ID										
			            , FROM_SITE_ID
                        , FROM_SITE_DESCRIPTION
                        , TO_SITE_ID
                        , TO_SITE_DESCRIPTION
			            , LT_WEEK										
			            , CONVERT_QTY_CELL									
			            , PROD_LINE										
			            , PSI_TYPE
                        , MEASURE
                        , MEASURE_LABEL
                        , MEASURE_VALUE1
                        , MEASURE_VALUE1_LABEL
                        , MEASURE_VALUE2
                        , MEASURE_VALUE2_LABEL
                        , UNIT
                        , CELL_ITEM_ID
                        , BOH
                        , QTY
						, YYYYMMDD	
			            , SORT_ORDER_NO								
                        , ORIGIN_FROM_DIVISION_ID
                        , ORIGIN_TO_DIVISION_ID
                        , ATTRIBUTE1
                        , ATTRIBUTE7
                        , ATTRIBUTE8
			            , ATTRIBUTE9
				       )
				VALUES (
						  Y.DIVISION_ID								
			            , Y.CELL_TYPE_GROUP_CODE						
			            , Y.NICK_NAME		
                        , Y.ELECTRODE_TYPE
			            , Y.ITEM_ID										
			            , Y.FROM_SITE_ID
                        , Y.FROM_SITE_DESCRIPTION
                        , Y.TO_SITE_ID
                        , Y.TO_SITE_DESCRIPTION
			            , Y.LT_WEEK										
			            , Y.CONVERT_QTY_CELL									
			            , Y.PROD_LINE										
			            , Y.PSI_TYPE
                        , Y.MEASURE
                        , Y.MEASURE_LABEL
                        , Y.MEASURE_VALUE1
                        , Y.MEASURE_VALUE1_LABEL
                        , Y.MEASURE_VALUE2
                        , Y.MEASURE_VALUE2_LABEL
                        , Y.UNIT
                        , Y.CELL_ITEM_ID
                        , Y.BOH
                        , Y.QTY
						, Y.YYYYMMDD	
			            , Y.SORT_ORDER_NO								
                        , Y.ORIGIN_FROM_DIVISION_ID
                        , Y.ORIGIN_TO_DIVISION_ID
                        , Y.ATTRIBUTE1
                        , Y.ATTRIBUTE7
                        , Y.ATTRIBUTE8
			            , Y.ATTRIBUTE9
				       );




                 
               -- JUMBO_MIN
               -- 40 파우치 
               -- 40 원통형 (CASE WHEN ATTRIBUTE1 ='EA' THEN ATTRIBUTE3 ELSE TACT_TIME END ) --> ANL_TACT_TIME에서 반영
      --         UPDATE X
      --          SET X.QTY = (CASE WHEN /* E.OPERATION_GROUP_ID='E' AND */ E.TACT_TIME IS NOT NULL AND E.ATTRIBUTE4 IS NOT NULL 
      --                            THEN (1
      --                                  /ISNULL(NULLIF(E.TACT_TIME,0),1) * 60
      --                                  /ISNULL(NULLIF(CONVERT(DECIMAL, E.ATTRIBUTE4),0),1)										
						--				  )
      --                            ELSE NULL END) 
      --          FROM #PSI_GLOBAL X  WITH (NOLOCK)
      --          INNER JOIN #tmp_SCP_MST_TACT_TIME E  WITH (NOLOCK)
      --            ON  X.ORIGIN_FROM_DIVISION_ID = E.DIVISION_ID 
      --            AND X.ATTRIBUTE9              = E.OPERATION_ID 
			   --   AND X.FROM_SITE_ID            = E.PLANT_SITE_ID 
				  --AND X.PROD_LINE               = E.LINE_ID 
      --            AND X.ITEM_ID                 = E.ITEM_ID 
				  --AND X.YYYYMMDD                = E.YYYYMMDD
      --            AND X.MEASURE                 = 'PROD_TACT_TIME'


				MERGE INTO #PSI_GLOBAL AS X
				USING (SELECT A.DIVISION_ID								
			                  , A.CELL_TYPE_GROUP_CODE						
			                  , A.NICK_NAME		
                              , A.ELECTRODE_TYPE
			                  , A.ITEM_ID										
			                  , A.FROM_SITE_ID
                              , A.FROM_SITE_DESCRIPTION
                              , A.TO_SITE_ID
                              , A.TO_SITE_DESCRIPTION
			                  , A.LT_WEEK										
			                  , A.CONVERT_QTY_CELL									
			                  , A.LINE_ID                 AS PROD_LINE 										
			                  , A.PSI_TYPE
                              , M.COLUMN_NAME             AS MEASURE
                              , M.COLUMN_LABEL_NAME       AS MEASURE_LABEL
                              , A.MEASURE_VALUE1
                              , A.MEASURE_VALUE1_LABEL
                              , A.MEASURE_VALUE2
                              , A.MEASURE_VALUE2_LABEL
                              , A.UNIT
                              , A.CELL_ITEM_ID
                              , A.BOH
                              , VAL                       AS QTY
						      , A.YYYYMMDD	
			                  , M.SORT_ORDER_NO								
                              , A.ORIGIN_FROM_DIVISION_ID
                              , A.ORIGIN_TO_DIVISION_ID
                              , A.ATTRIBUTE1
                              , A.ATTRIBUTE7
                              , A.ATTRIBUTE8
			                  , A.OPERATION_ID           AS ATTRIBUTE9		
						FROM (SELECT X.*, E.OPERATION_ID, E.LINE_ID,
						             (CASE WHEN /* E.OPERATION_GROUP_ID='E' AND */ E.TACT_TIME IS NOT NULL AND E.ATTRIBUTE4 IS NOT NULL 
										  THEN (1
												/ISNULL(NULLIF(E.TACT_TIME,0),1) * 60
												/ISNULL(NULLIF(CONVERT(DECIMAL, E.ATTRIBUTE4),0),1)										
												  )
										  ELSE NULL END) AS VAL
						        FROM #PSI_GLOBAL X  WITH (NOLOCK)
							INNER JOIN #tmp_SCP_MST_TACT_TIME E  WITH (NOLOCK)
								ON  X.ORIGIN_FROM_DIVISION_ID = E.DIVISION_ID 
								AND X.ATTRIBUTE9              = E.OPERATION_ID 
								AND X.FROM_SITE_ID            = E.PLANT_SITE_ID 
								AND X.PROD_LINE               = E.LINE_ID 
								AND X.ITEM_ID                 = E.ITEM_ID 
								AND X.YYYYMMDD                = E.YYYYMMDD
								AND X.MEASURE                 = 'PROD_TACT_TIME'
						     ) A,
						     (SELECT * FROM #MEASURE WITH (NOLOCK) WHERE COLUMN_NAME = 'PROD_TACT_TIME') M
					   WHERE 1 = 1
				      ) AS Y
				ON  X.ORIGIN_FROM_DIVISION_ID   = Y.DIVISION_ID 
                AND X.ATTRIBUTE9                = Y.ATTRIBUTE9 
				AND X.FROM_SITE_ID              = Y.FROM_SITE_ID 
				AND X.PROD_LINE                 = Y.PROD_LINE 
				AND X.YYYYMMDD                  = Y.YYYYMMDD
                AND X.MEASURE                   = 'PROD_TACT_TIME'
				WHEN MATCHED  THEN
				UPDATE
				   SET X.QTY = ISNULL(Y.QTY,0)
				WHEN NOT MATCHED  THEN
				INSERT (
						  DIVISION_ID								
			            , CELL_TYPE_GROUP_CODE						
			            , NICK_NAME		
                        , ELECTRODE_TYPE
			            , ITEM_ID										
			            , FROM_SITE_ID
                        , FROM_SITE_DESCRIPTION
                        , TO_SITE_ID
                        , TO_SITE_DESCRIPTION
			            , LT_WEEK										
			            , CONVERT_QTY_CELL									
			            , PROD_LINE										
			            , PSI_TYPE
                        , MEASURE
                        , MEASURE_LABEL
                        , MEASURE_VALUE1
                        , MEASURE_VALUE1_LABEL
                        , MEASURE_VALUE2
                        , MEASURE_VALUE2_LABEL
                        , UNIT
                        , CELL_ITEM_ID
                        , BOH
                        , QTY
						, YYYYMMDD	
			            , SORT_ORDER_NO								
                        , ORIGIN_FROM_DIVISION_ID
                        , ORIGIN_TO_DIVISION_ID
                        , ATTRIBUTE1
                        , ATTRIBUTE7
                        , ATTRIBUTE8
			            , ATTRIBUTE9
				       )
				VALUES (
						  Y.DIVISION_ID								
			            , Y.CELL_TYPE_GROUP_CODE						
			            , Y.NICK_NAME		
                        , Y.ELECTRODE_TYPE
			            , Y.ITEM_ID										
			            , Y.FROM_SITE_ID
                        , Y.FROM_SITE_DESCRIPTION
                        , Y.TO_SITE_ID
                        , Y.TO_SITE_DESCRIPTION
			            , Y.LT_WEEK										
			            , Y.CONVERT_QTY_CELL									
			            , Y.PROD_LINE										
			            , Y.PSI_TYPE
                        , Y.MEASURE
                        , Y.MEASURE_LABEL
                        , Y.MEASURE_VALUE1
                        , Y.MEASURE_VALUE1_LABEL
                        , Y.MEASURE_VALUE2
                        , Y.MEASURE_VALUE2_LABEL
                        , Y.UNIT
                        , Y.CELL_ITEM_ID
                        , Y.BOH
                        , Y.QTY
						, Y.YYYYMMDD	
			            , Y.SORT_ORDER_NO								
                        , Y.ORIGIN_FROM_DIVISION_ID
                        , Y.ORIGIN_TO_DIVISION_ID
                        , Y.ATTRIBUTE1
                        , Y.ATTRIBUTE7
                        , Y.ATTRIBUTE8
			            , Y.ATTRIBUTE9
				       );


            -------------------------------------------------------------------------------------------------------------------------         
            -- 대상 ITEM_ID 추출
            -------------------------------------------------------------------------------------------------------------------------   
              IF OBJECT_ID('tempdb..#ITEM_ID') IS NOT NULL	
	              DROP TABLE #ITEM_ID              
                
              SELECT DISTINCT
                     DIVISION_ID		     
                    ,CELL_TYPE_GROUP_CODE	   
                    ,NICK_NAME		     
                    ,ELECTRODE_TYPE			       
                    ,ITEM_ID			       
                    ,@p_plan_start_yyyymmdd AS YYYYMMDD			    
                    ,FROM_SITE_ID
              INTO #ITEM_ID
              FROM #PSI_GLOBAL WITH (NOLOCK) 
              WHERE 0 = 0
              GROUP BY
                     DIVISION_ID		     
                    ,CELL_TYPE_GROUP_CODE	   
                    ,NICK_NAME		     
                    ,ELECTRODE_TYPE			       
                    ,ITEM_ID			       
                    ,FROM_SITE_ID


            
            -------------------------------------------------------------------------------------------------------------------------         
            -- TOTAL 추가
            -------------------------------------------------------------------------------------------------------------------------   
            
            INSERT #PSI_GLOBAL
              SELECT  DISTINCT  X.DIVISION_ID								
			                        , X.CELL_TYPE_GROUP_CODE						
			                        , X.NICK_NAME		
                              , X.ELECTRODE_TYPE
			                        , X.ITEM_ID										
			                        , X.FROM_SITE_ID  AS FROM_SITE_ID
                              , NULL          AS FROM_SITE_DESCRIPTION
                              , '-'           AS TO_SITE_ID
                              , NULL          AS TO_SITE_DESCRIPTION
			                        , '0'           AS LT_WEEK										
			                        , '0'           AS CONVERT_QTY_CELL									
			                        , '-'           AS PROD_LINE 										
			                        ,(CASE M.COLUMN_NAME  WHEN  'SHIP_PLAN_TOTAL'         THEN 'Sale' 
                                                    WHEN  'Y_SUM'                   THEN 'Sale' 
                                                    WHEN  'PROD_PLAN_TOTAL'         THEN 'Production'
                                                    WHEN  'P_SUM'                   THEN 'Production'
                                                    WHEN  'INVENTORY_BALANCE_TOTAL' THEN 'Inventory'
                                                    WHEN  'INVENTORY_TOTAL'         THEN 'Inventory'
                                ELSE NULL END)          AS PSI_TYPE
                              , M.COLUMN_NAME AS MEASURE
                              , M.COLUMN_LABEL_NAME  AS MEASURE_LABEL
                              , M.COLUMN_NAME AS MEASURE_VALUE1
                              , M.COLUMN_LABEL_NAME AS MEASURE_VALUE1_LABEL
                              , NULL          AS MEASURE_VALUE2
                              , NULL          AS MEASURE_VALUE2_LABEL
                              , 'CELL'        AS UNIT
                              , NULL          AS CELL_ITEM_ID
                              , NULL          AS BOH
                              , 0             AS QTY
						                  , X.YYYYMMDD	
			                        , M.SORT_ORDER_NO								
                              , NULL          AS ORIGIN_FROM_DIVISION_ID
                              , NULL          AS ORIGIN_TO_DIVISION_ID
                              , M.COLUMN_NAME AS ATTRIBUTE1
                              , NULL AS ATTRIBUTE7
                              ,(CASE M.COLUMN_NAME  WHEN  'SHIP_PLAN_TOTAL'         THEN '1'
                                                    WHEN  'Y_SUM'                   THEN '1' 
                                                    WHEN  'PROD_PLAN_TOTAL'         THEN '3'
                                                    WHEN  'P_SUM'                   THEN '3'
                                                    WHEN  'INVENTORY_BALANCE_TOTAL' THEN '8'
                                                    WHEN  'INVENTORY_TOTAL'         THEN '9'
                                ELSE '0' END) AS ATTRIBUTE8
			                        , NULL          AS ATTRIBUTE9										
              FROM #ITEM_ID X WITH(NOLOCK)
              CROSS APPLY #MEASURE M WITH (NOLOCK)                                 
              WHERE 1=1          
                AND M.COLUMN_NAME IN ('SHIP_PLAN_TOTAL','PROD_PLAN_TOTAL','INVENTORY_TOTAL','INVENTORY_BALANCE_TOTAL','Y_SUM','P_SUM')



                -- DIVISION_ID 중복제거 --> 'EE'로 통일 해야 함.
                  DELETE TBL FROM
	                (
	                        SELECT
	                               ROW_NUMBER() OVER (PARTITION BY FROM_SITE_ID,NICK_NAME,ITEM_ID,ATTRIBUTE8,PROD_LINE,SORT_ORDER_NO,TO_SITE_ID,CELL_ITEM_ID,YYYYMMDD
                                 ORDER BY ATTRIBUTE1) AS ROWNUM
--                                 ,*
	                        FROM #PSI_GLOBAL
                        WHERE MEASURE LIKE '%TOTAL'
	                ) AS TBL
	                WHERE TBL.ROWNUM > 1


                   DELETE TBL FROM
	                (
	                        SELECT
	                               ROW_NUMBER() OVER (PARTITION BY FROM_SITE_ID,NICK_NAME,ITEM_ID,ATTRIBUTE8,PROD_LINE,SORT_ORDER_NO,TO_SITE_ID,CELL_ITEM_ID,YYYYMMDD
                                 ORDER BY ATTRIBUTE1) AS ROWNUM
--                                 ,*
	                        FROM #PSI_GLOBAL
                        WHERE MEASURE = 'Y_SUM'
	                ) AS TBL
	                WHERE TBL.ROWNUM > 1


                   DELETE TBL FROM
	                (
	                        SELECT
	                               ROW_NUMBER() OVER (PARTITION BY FROM_SITE_ID,NICK_NAME,ITEM_ID,ATTRIBUTE8,PROD_LINE,SORT_ORDER_NO,TO_SITE_ID,CELL_ITEM_ID,YYYYMMDD
                                 ORDER BY ATTRIBUTE1) AS ROWNUM
-- ,*
	                        FROM #PSI_GLOBAL
                        WHERE MEASURE = 'P_SUM'
	                ) AS TBL
	                WHERE TBL.ROWNUM > 1



            -------------------------------------------------------------------------------------------------------------------------         
            -- DIO 추가
            -------------------------------------------------------------------------------------------------------------------------   
            
            INSERT #PSI_GLOBAL
              SELECT  DISTINCT  X.DIVISION_ID								
			                        , X.CELL_TYPE_GROUP_CODE						
			                        , X.NICK_NAME		
                              , X.ELECTRODE_TYPE
			                        , X.ITEM_ID										
			                        , X.FROM_SITE_ID  AS FROM_SITE_ID
                              , NULL          AS FROM_SITE_DESCRIPTION
                              , '-'           AS TO_SITE_ID
                              , NULL          AS TO_SITE_DESCRIPTION
			                        , '0'           AS LT_WEEK										
			                        , '0'           AS CONVERT_QTY_CELL									
			                        , '-'           AS PROD_LINE 										
			                        , 'Inventory'   AS PSI_TYPE
                              , M.COLUMN_NAME AS MEASURE
                              , M.COLUMN_LABEL_NAME       AS MEASURE_LABEL
                              , M.COLUMN_NAME             AS MEASURE_VALUE1
                              , M.SMALL_CLASS_LABEL_NAME  AS MEASURE_VALUE1_LABEL
                              , '0'  AS MEASURE_VALUE2
                              , '0'  AS MEASURE_VALUE2_LABEL
                              , N'일'          AS UNIT
                              , NULL          AS CELL_ITEM_ID
                              , NULL          AS BOH
                              , 0             AS QTY
						                  , X.YYYYMMDD	
			                        , M.SORT_ORDER_NO								
                              , NULL          AS ORIGIN_FROM_DIVISION_ID
                              , NULL          AS ORIGIN_TO_DIVISION_ID
                              , M.COLUMN_NAME AS ATTRIBUTE1
                              , NULL AS ATTRIBUTE7
                              ,(CASE M.COLUMN_NAME WHEN  'INVENTORY_PRE_DIO'       THEN '11'
                                                   WHEN  'INVENTORY_STD_DIO'       THEN '12'
												   WHEN  'GAP_PRE_GRO_DIO'         THEN '12.1'
												   WHEN  'GAP_PRE_MIN_DIO'         THEN '12.2'
                                ELSE '0' END) AS ATTRIBUTE8
			                        , NULL          AS ATTRIBUTE9										
              FROM #ITEM_ID X WITH(NOLOCK)
              CROSS APPLY #MEASURE M WITH (NOLOCK)                                 
              WHERE 1=1          
                AND M.COLUMN_NAME IN ('INVENTORY_PRE_DIO','INVENTORY_STD_DIO','GAP_PRE_GRO_DIO','GAP_PRE_MIN_DIO')           


                -- DIVISION_ID 중복제거 --> 'EE'로 통일 해야 함.
                  DELETE TBL FROM
	                (
	                        SELECT
	                               ROW_NUMBER() OVER (PARTITION BY FROM_SITE_ID,NICK_NAME,ITEM_ID,ATTRIBUTE8,PROD_LINE,SORT_ORDER_NO,TO_SITE_ID,CELL_ITEM_ID,YYYYMMDD
                                 ORDER BY ATTRIBUTE1) AS ROWNUM
--                                 ,*
	                        FROM #PSI_GLOBAL
                        WHERE MEASURE LIKE '%DIO'
	                ) AS TBL
	                WHERE TBL.ROWNUM > 1
                

             /*
                    IF OBJECT_ID('tempdb..##MEASURE') IS NOT NULL	
	                    DROP TABLE ##MEASURE
                    IF OBJECT_ID('tempdb..##PSI_GLOBAL') IS NOT NULL	
	                    DROP TABLE ##PSI_GLOBAL
                    IF OBJECT_ID('tempdb..##PSI_GLOBAL_LINE') IS NOT NULL	
	                    DROP TABLE ##PSI_GLOBAL_LINE
                    IF OBJECT_ID('tempdb..##tmp_SCP_MST_TACT_TIME') IS NOT NULL	
	                    DROP TABLE ##tmp_SCP_MST_TACT_TIME

                    SELECT *   INTO ##MEASURE                      FROM #MEASURE
                    SELECT *   INTO ##PSI_GLOBAL                   FROM #PSI_GLOBAL
                    SELECT *   INTO ##PSI_GLOBAL_LINE              FROM #PSI_GLOBAL_LINE
                    SELECT *   INTO ##tmp_SCP_MST_TACT_TIME        FROM #tmp_SCP_MST_TACT_TIME
                    
                    */
                  



            -------------------------------------------------------------------------------------------------------------------------         
            -- 전극 재고 추가
            -------------------------------------------------------------------------------------------------------------------------   
            IF OBJECT_ID('tempdb..#ITEM_ID_FROM_SITE_ID') IS NOT NULL	
	            DROP TABLE #ITEM_ID_FROM_SITE_ID  

             SELECT DISTINCT
                    @p_division_id AS  DIVISION_ID		  -- 2022.03.21 GM JV 반영	'EE' --> @p_division_id   
                    ,CELL_TYPE_GROUP_CODE	   
                    ,NICK_NAME		     
                    ,ELECTRODE_TYPE			       
                    ,ITEM_ID			       
                    ,FROM_SITE_ID
                    ,@p_plan_start_yyyymmdd AS YYYYMMDD	
              INTO #ITEM_ID_FROM_SITE_ID
              FROM #PSI_GLOBAL WITH (NOLOCK) 
              WHERE 0 = 0
              AND FROM_SITE_ID <> '-'
              GROUP BY
                     DIVISION_ID		     
                    ,CELL_TYPE_GROUP_CODE	   
                    ,NICK_NAME		     
                    ,ELECTRODE_TYPE			       
                    ,ITEM_ID			  
                    ,FROM_SITE_ID

            

              INSERT #PSI_GLOBAL
              SELECT  DISTINCT  @p_division_id AS DIVISION_ID			-- 2022.03.21 GM JV 반영	'EE' --> @p_division_id					
			                        , NULL AS CELL_TYPE_GROUP_CODE						
			                        , Y.NICK_NAME		
                              , Y.ELECTRODE_TYPE
			                        , Y.ITEM_ID										
			                        , Y.FROM_SITE_ID  AS FROM_SITE_ID
                              , NULL            AS FROM_SITE_DESCRIPTION
                              , '-'             AS TO_SITE_ID
                              , NULL            AS TO_SITE_DESCRIPTION
			                        , '0'             AS LT_WEEK										
			                        , '0'             AS CONVERT_QTY_CELL									
			                        , '-'             AS PROD_LINE 		
                              , 'Inventory'     AS PSI_TYPE
			                        , M.COLUMN_NAME   AS MEASURE
                              , M.COLUMN_LABEL_NAME   AS MEASURE_LABEL
                              , X.TO_SITE_ID    AS MEASURE_VALUE1
                              , X.TO_SITE_ID    AS MEASURE_VALUE1_LABEL   
                              , SUM(CASE WHEN X.AVAILABLE_DATE < convert(date, @p_plan_start_yyyymmdd) THEN X.CONVERT_QTY ELSE 0 END)  AS MEASURE_VALUE2
                              , SUM(CASE WHEN X.AVAILABLE_DATE < convert(date, @p_plan_start_yyyymmdd) THEN X.CONVERT_QTY ELSE 0 END)  AS MEASURE_VALUE2_LABEL
                              , 'CELL'          AS UNIT
                              , NULL            AS CELL_ITEM_ID
                              , SUM(CASE WHEN X.AVAILABLE_DATE < convert(date, @p_plan_start_yyyymmdd) THEN X.CONVERT_QTY ELSE 0 END) AS BOH
                              , 0    AS QTY
						                  , Y.YYYYMMDD
			                        , M.SORT_ORDER_NO								
                              , NULL AS ORIGIN_FROM_DIVISION_ID
                              , NULL AS ORIGIN_TO_DIVISION_ID
                              , M.COLUMN_NAME AS ATTRIBUTE1		
                              , NULL AS ATTRIBUTE7
                              ,'10'  AS ATTRIBUTE8
			                        , NULL          AS ATTRIBUTE9			
              FROM SCP_XLS_PSI_GLOBAL_ELECTRODE_BOM X WITH(NOLOCK) 
              LEFT OUTER JOIN #ITEM_ID_FROM_SITE_ID Y WITH(NOLOCK)  
              ON  0 = 0
--              AND X.DIVISION_ID = Y.DIVISION_ID
              AND X.FROM_SITE_ID  = Y.FROM_SITE_ID
              AND X.ELEC_ITEM_ID  = Y.ITEM_ID
              CROSS APPLY #MEASURE M WITH (NOLOCK)                                 
              WHERE X.ELEC_DIVISION_ID = @p_division_id -- [PJ20230691R] LGES SCM 역량 강화 위한 SCP 개선과제 이행 - ELECTRODE_BOM(BOH) 테이블 PK 컬럼 추가 반영 (ELEC_DIVISION_ID : EE/EE_UC)        
                AND M.COLUMN_NAME IN ('INVENTORY_BOH')     
             GROUP BY  Y.NICK_NAME		
                              , Y.ELECTRODE_TYPE
			                        , Y.ITEM_ID										
			                        , Y.FROM_SITE_ID  
			                        , M.COLUMN_NAME   
                              , X.TO_SITE_ID    
						                  , Y.YYYYMMDD
			                        , M.SORT_ORDER_NO								
                              , M.COLUMN_NAME
                              , M.COLUMN_LABEL_NAME

            -------------------------------------------------------------------------------------------------------------------------         
            -- [C20200323-000351] GSCM 전극 simulator 내 BOH 조회 기능 수정 개선의 건
            -- 전극 재고가 없을 경우 FROM SITE로 반영하고 INVENTORY_BOH 강제 추가
            -------------------------------------------------------------------------------------------------------------------------   
            
            INSERT #PSI_GLOBAL
            SELECT 
                @p_division_id AS DIVISION_ID			-- 2022.03.21 GM JV 반영	'EE' --> @p_division_id
                ,CELL_TYPE_GROUP_CODE	
                ,NICK_NAME	
                ,ELECTRODE_TYPE	
                ,ITEM_ID	
                ,FROM_SITE_ID	
                ,FROM_SITE_DESCRIPTION	
                ,TO_SITE_ID	
                ,TO_SITE_DESCRIPTION	
                ,LT_WEEK	
                ,CONVERT_QTY_CELL	
                ,PROD_LINE	
                ,PSI_TYPE	
                ,'INVENTORY_BOH' AS MEASURE	
                ,'BOH' AS MEASURE_LABEL	
                ,FROM_SITE_ID AS MEASURE_VALUE1	
                ,FROM_SITE_ID AS MEASURE_VALUE1_LABEL	
                ,'0' AS MEASURE_VALUE2	
                ,'0' AS MEASURE_VALUE2_LABEL	
                ,UNIT	
                ,CELL_ITEM_ID	
                ,'0' AS BOH	
                ,'0' AS QTY	
                ,YYYYMMDD	
                ,'200' AS SORT_ORDER_NO	
                ,ORIGIN_FROM_DIVISION_ID	
                ,ORIGIN_TO_DIVISION_ID	
                ,'INVENTORY_BOH' AS ATTRIBUTE1	
                ,ATTRIBUTE7	
                ,'10' AS ATTRIBUTE8	
                ,ATTRIBUTE9
                FROM #PSI_GLOBAL WITH (NOLOCK)  
                WHERE 0 = 0
                AND MEASURE = 'INVENTORY_TOTAL'
                AND FROM_SITE_ID IS NOT NULL
                AND ITEM_ID IN (
                                -- INVENTORY_BOH 가 존재하지 않는 ITEM_ID
                                SELECT DISTINCT ITEM_ID
                                FROM #PSI_GLOBAL WITH (NOLOCK)  
                                WHERE 0 = 0
                                EXCEPT 
                                SELECT DISTINCT ITEM_ID
                                FROM #PSI_GLOBAL WITH (NOLOCK)  
                                WHERE 0 = 0
                                AND MEASURE = 'INVENTORY_BOH'
                                )

            -------------------------------------------------------------------------------------------------------------------------         
			-- C20210702-000348 - 전극 시뮬레이터 내 BOH 보류재고 반영 로직 수정 요청의 건
            -- 전극 보류 재고 Measure 추가 - start
            -------------------------------------------------------------------------------------------------------------------------   
			-- 전극 보류 재고 Measure 추가
              INSERT #PSI_GLOBAL
              SELECT  DISTINCT  @p_division_id AS DIVISION_ID							-- 2022.03.21 GM JV 반영	'EE' --> @p_division_id	
			                        , NULL     AS CELL_TYPE_GROUP_CODE						
			                        , Y.NICK_NAME		
                              , Y.ELECTRODE_TYPE
			                        , Y.ITEM_ID										
			                        , Y.FROM_SITE_ID  AS FROM_SITE_ID
                              , NULL            AS FROM_SITE_DESCRIPTION
                              , '-'             AS TO_SITE_ID
                              , NULL            AS TO_SITE_DESCRIPTION
			                        , '0'             AS LT_WEEK										
			                        , '0'             AS CONVERT_QTY_CELL									
			                        , '-'             AS PROD_LINE 		
                              , 'Inventory'     AS PSI_TYPE
			                        , M.COLUMN_NAME   AS MEASURE
                              , M.COLUMN_LABEL_NAME   AS MEASURE_LABEL
                              , 'INVENTORY_HOLD' AS MEASURE_VALUE1		-- X.TO_SITE_ID    AS MEASURE_VALUE1		-- to_site 구분없음
                              , 'SUM' AS MEASURE_VALUE1_LABEL	        -- X.TO_SITE_ID    AS MEASURE_VALUE1_LABEL	-- to_site 구분없음   
                              , SUM(CASE WHEN X.AVAILABLE_DATE >= convert(date, @p_plan_start_yyyymmdd) THEN X.CONVERT_QTY ELSE 0 END)  AS MEASURE_VALUE2
                              , SUM(CASE WHEN X.AVAILABLE_DATE >= convert(date, @p_plan_start_yyyymmdd) THEN X.CONVERT_QTY ELSE 0 END)  AS MEASURE_VALUE2_LABEL
                              , 'CELL'          AS UNIT
                              , NULL            AS CELL_ITEM_ID
                              , SUM(CASE WHEN X.AVAILABLE_DATE >= convert(date, @p_plan_start_yyyymmdd) THEN X.CONVERT_QTY ELSE 0 END) AS BOH
                              , 0    AS QTY
						                  , Y.YYYYMMDD
			                        , M.SORT_ORDER_NO								
                              , NULL AS ORIGIN_FROM_DIVISION_ID
                              , NULL AS ORIGIN_TO_DIVISION_ID
                              , M.COLUMN_NAME AS ATTRIBUTE1		
                              , NULL AS ATTRIBUTE7
                              ,'11'  AS ATTRIBUTE8
			                        , NULL          AS ATTRIBUTE9			
              FROM SCP_XLS_PSI_GLOBAL_ELECTRODE_BOM X WITH(NOLOCK)
              LEFT OUTER JOIN #ITEM_ID_FROM_SITE_ID Y WITH(NOLOCK)  
              ON  0 = 0
--              AND X.DIVISION_ID = Y.DIVISION_ID
              AND X.FROM_SITE_ID  = Y.FROM_SITE_ID
              AND X.ELEC_ITEM_ID  = Y.ITEM_ID
              CROSS APPLY #MEASURE M WITH (NOLOCK)                                 
              WHERE X.ELEC_DIVISION_ID = @p_division_id -- [PJ20230691R] LGES SCM 역량 강화 위한 SCP 개선과제 이행 - ELECTRODE_BOM(BOH) 테이블 PK 컬럼 추가 반영 (ELEC_DIVISION_ID : EE/EE_UC)        
                AND M.COLUMN_NAME IN ('INVENTORY_HOLD')     
             GROUP BY  Y.NICK_NAME		
                              , Y.ELECTRODE_TYPE
			                        , Y.ITEM_ID										
			                        , Y.FROM_SITE_ID  
			                        , M.COLUMN_NAME   
                              --, X.TO_SITE_ID    -- to_site 구분없음
						                  , Y.YYYYMMDD
			                        , M.SORT_ORDER_NO								
                              , M.COLUMN_NAME
                              , M.COLUMN_LABEL_NAME

			-- 전극 보류 재고 Measure 강제추가 (보류재고가 없는 모델)
            INSERT #PSI_GLOBAL
            SELECT 
                @p_division_id    AS DIVISION_ID			-- 2022.03.21 GM JV 반영	'EE' --> @p_division_id
                ,CELL_TYPE_GROUP_CODE	
                ,NICK_NAME	
                ,ELECTRODE_TYPE	
                ,ITEM_ID	
                ,FROM_SITE_ID	
                ,FROM_SITE_DESCRIPTION	
                ,TO_SITE_ID	
                ,TO_SITE_DESCRIPTION	
                ,LT_WEEK	
                ,CONVERT_QTY_CELL	
                ,PROD_LINE	
                ,PSI_TYPE	
                ,'INVENTORY_HOLD' AS MEASURE	
                ,N'보류재고'      AS MEASURE_LABEL	
                ,'INVENTORY_HOLD' AS MEASURE_VALUE1
                ,'SUM'            AS MEASURE_VALUE1_LABEL 
                ,'0' AS MEASURE_VALUE2	
                ,'0' AS MEASURE_VALUE2_LABEL	
                ,UNIT	
                ,CELL_ITEM_ID	
                ,'0' AS BOH	
                ,'0' AS QTY	
                ,YYYYMMDD	
                ,'250' AS SORT_ORDER_NO	
                ,ORIGIN_FROM_DIVISION_ID	
                ,ORIGIN_TO_DIVISION_ID	
                ,'INVENTORY_HOLD' AS ATTRIBUTE1	
                ,ATTRIBUTE7	
                ,'11' AS ATTRIBUTE8	
                ,ATTRIBUTE9
                FROM #PSI_GLOBAL WITH (NOLOCK)  
                WHERE 0 = 0
                AND MEASURE = 'INVENTORY_TOTAL'
                AND FROM_SITE_ID IS NOT NULL
                AND ITEM_ID IN (
                                -- INVENTORY_BOH 가 존재하지 않는 ITEM_ID
                                SELECT DISTINCT ITEM_ID
                                FROM #PSI_GLOBAL WITH (NOLOCK)  
                                WHERE 0 = 0
                                EXCEPT 
                                SELECT DISTINCT ITEM_ID
                                FROM #PSI_GLOBAL WITH (NOLOCK)  
                                WHERE 0 = 0
                                AND MEASURE = 'INVENTORY_HOLD'
                                )

			-- 전극 보류 재고 Measure 추가 - end
			



             -------------------------------------------------------------------------------------------------------------------------         
            -- ETC 추가 
            -------------------------------------------------------------------------------------------------------------------------   
            -- ETC_YIELD 추가 Sale 항목의 SITE_ID와 ITEM_ID를 가져온다.
            -------------------------------------------------------------------------------------------------------------------------   
            INSERT #PSI_GLOBAL
            SELECT  DISTINCT  X.DIVISION_ID								
			                        , X.CELL_TYPE_GROUP_CODE						
			                        , X.NICK_NAME		
                              , X.ELECTRODE_TYPE
			                        , X.ITEM_ID										
			                        , X.FROM_SITE_ID  AS FROM_SITE_ID
                              , NULL          AS FROM_SITE_DESCRIPTION
                              , '-'           AS TO_SITE_ID
                              , NULL          AS TO_SITE_DESCRIPTION
			                        , '0'           AS LT_WEEK										
			                        , '0'           AS CONVERT_QTY_CELL									
			                        , '-'           AS PROD_LINE 										
			                        , 'ETC'           AS PSI_TYPE
                              , M.COLUMN_NAME   AS MEASURE
                              , M.COLUMN_LABEL_NAME   AS MEASURE_LABEL
                              , X.TO_SITE_ID  AS MEASURE_VALUE1
                              , ISNULL((SELECT TOP 1 M.SITE_DESCRIPTION FROM SCM_MST_SITE M  WITH (NOLOCK) WHERE M.SCM_SITE_ID = X.TO_SITE_ID), '-')  AS MEASURE_VALUE1_LABEL 
                              , X.CELL_ITEM_ID  AS MEASURE_VALUE2
                              , X.CELL_ITEM_ID  AS MEASURE_VALUE2_LABEL
                              , '%'           AS UNIT
                              , NULL          AS CELL_ITEM_ID
                              , NULL          AS BOH
                              , 0             AS QTY
						                  , X.YYYYMMDD	
			                        , M.SORT_ORDER_NO								
                              , NULL          AS ORIGIN_FROM_DIVISION_ID
                              , NULL          AS ORIGIN_TO_DIVISION_ID
                              , M.COLUMN_NAME AS ATTRIBUTE1
                              , NULL AS ATTRIBUTE7
                              ,'13' AS ATTRIBUTE8
			                        , NULL          AS ATTRIBUTE9		
            FROM #PSI_GLOBAL X WITH (NOLOCK)
            INNER JOIN #MEASURE M WITH(NOLOCK)	
                  ON M.COLUMN_NAME          IN ('ETC_YIELD')
                WHERE 0 = 0
                    AND X.PSI_TYPE     = 'Sale'      
                    AND X.FROM_SITE_ID IS NOT NULL
                    AND X.MEASURE <> 'SHIP_PLAN_TOTAL'
            UNION ALL
            SELECT  DISTINCT  X.DIVISION_ID								
			                        , X.CELL_TYPE_GROUP_CODE						
			                        , X.NICK_NAME		
                              , X.ELECTRODE_TYPE
			                        , X.ITEM_ID										
			                        , X.FROM_SITE_ID  AS FROM_SITE_ID
                              , NULL            AS FROM_SITE_DESCRIPTION
                              , '-'             AS TO_SITE_ID
                              , NULL            AS TO_SITE_DESCRIPTION
			                        , '0'             AS LT_WEEK										
			                        , '0'             AS CONVERT_QTY_CELL									
			                        , '-'             AS PROD_LINE 										
			                        , 'ETC'           AS PSI_TYPE
                              , M.COLUMN_NAME   AS MEASURE
                              , M.COLUMN_LABEL_NAME   AS MEASURE
                              , X.FROM_SITE_ID  AS MEASURE_VALUE1
                              , ISNULL((SELECT TOP 1 M.SITE_DESCRIPTION FROM SCM_MST_SITE M  WITH (NOLOCK) WHERE M.SCM_SITE_ID = X.FROM_SITE_ID), '-')  AS MEASURE_VALUE1_LABEL 
                              , X.ITEM_ID       AS MEASURE_VALUE2
                              , X.ITEM_ID       AS MEASURE_VALUE2_LABEL
                              , '%'             AS UNIT
                              , NULL            AS CELL_ITEM_ID
                              , NULL            AS BOH
                              , 0               AS QTY
						                  , X.YYYYMMDD	
			                        , M.SORT_ORDER_NO								
                              , NULL          AS ORIGIN_FROM_DIVISION_ID
                              , NULL          AS ORIGIN_TO_DIVISION_ID
                              , M.COLUMN_NAME AS ATTRIBUTE1
                              , NULL AS ATTRIBUTE7
                              ,'13' AS ATTRIBUTE8
			                        , NULL          AS ATTRIBUTE9		
            FROM #PSI_GLOBAL X WITH (NOLOCK)
            INNER JOIN #MEASURE M WITH(NOLOCK)	
                  ON M.COLUMN_NAME          IN ('ETC_YIELD')
                WHERE 0 = 0
                    AND X.PSI_TYPE     = 'Sale'      
                    AND X.FROM_SITE_ID IS NOT NULL
                    AND X.MEASURE <> 'SHIP_PLAN_TOTAL'          
            
             

            -------------------------------------------------------------------------------------------------------------------------   
            -- 'ETC_RATE' 추가 
            -------------------------------------------------------------------------------------------------------------------------

            INSERT #PSI_GLOBAL
              SELECT  DISTINCT  X.DIVISION_ID								
			                        , X.CELL_TYPE_GROUP_CODE						
			                        , X.NICK_NAME		
                              , X.ELECTRODE_TYPE
			                        , X.ITEM_ID										
			                        , X.FROM_SITE_ID  AS FROM_SITE_ID
                              , NULL          AS FROM_SITE_DESCRIPTION
                              , '-'           AS TO_SITE_ID
                              , NULL          AS TO_SITE_DESCRIPTION
			                        , '0'           AS LT_WEEK										
			                        , '0'           AS CONVERT_QTY_CELL									
			                        , '-'           AS PROD_LINE 										
			                        , 'ETC'          AS PSI_TYPE
                              , M.COLUMN_NAME AS MEASURE
                              , M.COLUMN_LABEL_NAME  AS MEASURE_LABEL
                              , M.COLUMN_NAME AS MEASURE_VALUE1
                              , M.COLUMN_NAME AS MEASURE_VALUE1_LABEL
                              , ''            AS MEASURE_VALUE2
                              , ''            AS MEASURE_VALUE2_LABEL
                              , 'Cell/M'      AS UNIT
                              , NULL          AS CELL_ITEM_ID
                              , NULL          AS BOH
                              , 0             AS QTY
						                  , X.YYYYMMDD	
			                        , M.SORT_ORDER_NO								
                              , NULL          AS ORIGIN_FROM_DIVISION_ID
                              , NULL          AS ORIGIN_TO_DIVISION_ID
                              , M.COLUMN_NAME AS ATTRIBUTE1
                              , NULL AS ATTRIBUTE7
                              ,'14' AS ATTRIBUTE8
			                        , NULL          AS ATTRIBUTE9										
              FROM #ITEM_ID X WITH(NOLOCK)
              CROSS APPLY #MEASURE M WITH (NOLOCK)                                 
              WHERE 1=1          
                AND M.COLUMN_NAME IN ('ETC_RATE')           


                -- DIVISION_ID 중복제거 --> 'EE'로 통일 해야 함.
                  DELETE TBL FROM
	                (
	                        SELECT
	                               ROW_NUMBER() OVER (PARTITION BY FROM_SITE_ID,NICK_NAME,ITEM_ID,ATTRIBUTE8,PROD_LINE,SORT_ORDER_NO,TO_SITE_ID,CELL_ITEM_ID,YYYYMMDD
                                 ORDER BY ATTRIBUTE1) AS ROWNUM
--                                 ,*
	                        FROM #PSI_GLOBAL
                        WHERE MEASURE IN ('ETC_RATE')     
	                ) AS TBL
	                WHERE TBL.ROWNUM > 1

                 


            -------------------------------------------------------------------------------------------------------------------------   
            -- 'ETC_RATE' 추가 
            -- 1. Conversion Rate 추가 
            -- - Slitting Lane이 여러개 있을 경우 Max값 처리
            -- - Item UOM이 EA : 원통형 
            --              빈값 - 플랜트 내에서 있는 것이 있으면 있는 것을 우선으로 함
            --              플랜트 내에서 동일한 것이 없을 경우 Item 전체에서 있는 것을 우선으로 함
            --              아에 없는 경우에는 1로 처리
            --              숫자가 = 숫자가 다를경우 Max값
            --              M : 파우치 
            -------------------------------------------------------------------------------------------------------------------------
            IF OBJECT_ID('tempdb..#SCP_MST_TACT_TIME_ETC_RATE')    IS NOT NULL	
		            DROP TABLE #SCP_MST_TACT_TIME_ETC_RATE
                -- TACT TIME 입력시 ATTRIBUTE1에 공란이 들어는 경우가 있어서 추가 함
                SELECT DIVISION_ID
                      ,ITEM_ID
                      ,PLANT_SITE_ID
                      ,LINE_ID
                      ,ITEM_UOM
                      ,UOM_CONVERT_VALUE
                      ,(CASE WHEN LEN(RTRIM(LTRIM(ATTRIBUTE1))) = 0 THEN 0 ELSE CONVERT(NUMERIC (20,10),ATTRIBUTE1) END ) AS ATTRIBUTE1
                INTO #SCP_MST_TACT_TIME_ETC_RATE
                FROM SCP_MST_TACT_TIME
               WHERE 0 = 0
                 AND ITEM_ID IN (SELECT  ITEM_ID
                                      FROM #PSI_GLOBAL X  WITH (NOLOCK)-- 소형 CELL
                                      WHERE MEASURE = 'ETC_RATE'
                                    )


            IF OBJECT_ID('tempdb..#ETC_RATE')    IS NOT NULL	
		            DROP TABLE #ETC_RATE

               SELECT C.SEGMENT1 AS PLANT_SITE_ID
                      ,A.ITEM_ID
                      ,MIN(ISNULL(A.ATTRIBUTE1,1)
                          --/ISNULL(NULLIF(CONVERT(NUMERIC,C.ATTRIBUTE1),0),1)
						               /(CASE WHEN C.ATTRIBUTE1 = ''                            THEN 1.0 
                                  WHEN CONVERT(NUMERIC (20,10),C.ATTRIBUTE1) = 0    THEN 1.0 
								                  WHEN C.ATTRIBUTE1 IS NULL                       THEN 1.0 ELSE CONVERT(NUMERIC (20,10),C.ATTRIBUTE1) END)
                          * D.CONVERT_QTY_CELL 
                          * (CASE WHEN A.ITEM_UOM ='EA' THEN A.UOM_CONVERT_VALUE ELSE 1 END) 
                          ) AS ABC
	                  ,A.DIVISION_ID
                    ,A.ITEM_UOM
                INTO #ETC_RATE
                FROM #SCP_MST_TACT_TIME_ETC_RATE A WITH(NOLOCK)
               INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C WITH (NOLOCK)
                  ON 0 = 0
                 AND C.LOOKUP_TYPE   = 'ELECTRODE_LINE_WIDE_RATE'
                 AND A.PLANT_SITE_ID = C.SEGMENT1
                 AND A.LINE_ID       = C.SEGMENT4
               INNER JOIN SCP_MST_FINAL_ITEM D WITH (NOLOCK)
                  ON A.DIVISION_ID   = D.DIVISION_ID
                  AND A.ITEM_ID      = D.ITEM_ID
               WHERE 0 = 0
                 AND A.ITEM_ID IN (SELECT  ITEM_ID
                                      FROM #PSI_GLOBAL X  WITH (NOLOCK)-- 소형 CELL
                                      WHERE MEASURE = 'ETC_RATE'
                                    )
              GROUP BY C.SEGMENT1
	                    ,A.DIVISION_ID
                      ,A.ITEM_ID
                      ,A.ITEM_UOM

               UPDATE X
                  SET  X.MEASURE_VALUE2         = Y.ABC
                      ,X.MEASURE_VALUE2_LABEL   = Y.ABC
                FROM #PSI_GLOBAL X  WITH (NOLOCK)
               INNER JOIN #ETC_RATE Y  WITH (NOLOCK)
                  ON X.ITEM_ID      = Y.ITEM_ID
                 AND X.FROM_SITE_ID = Y.PLANT_SITE_ID
                WHERE X.MEASURE     ='ETC_RATE'
                  
            -------------------------------------------------------------------------------------------------------------------------   
            -- 'ETC_LT' 추가 
            -------------------------------------------------------------------------------------------------------------------------
       
                INSERT #PSI_GLOBAL
                SELECT  DISTINCT  @p_division_id AS DIVISION_ID		-- 2022.03.21 GM JV 반영	'EE' --> @p_division_id						
			                            , NULL   AS CELL_TYPE_GROUP_CODE						
			                            , X.NICK_NAME		
                                  , X.ELECTRODE_TYPE
			                            , X.ITEM_ID										
			                            , X.FROM_SITE_ID  AS FROM_SITE_ID
                                  , NULL          AS FROM_SITE_DESCRIPTION
                                  , '-'           AS TO_SITE_ID
                                  , NULL          AS TO_SITE_DESCRIPTION
			                            , '0'           AS LT_WEEK										
			                            , '0'           AS CONVERT_QTY_CELL									
			                            , '-'           AS PROD_LINE 										
			                            , 'ETC'           AS PSI_TYPE
                                  , M.COLUMN_NAME   AS MEASURE
                                  , M.COLUMN_LABEL_NAME   AS MEASURE_LABEL
                                  , X.TO_SITE_ID  AS MEASURE_VALUE1
                                  , X.TO_SITE_ID   AS MEASURE_VALUE1_LABEL  
                                  , NULL          AS MEASURE_VALUE2
                                  , NULL          AS MEASURE_VALUE2_LABEL  
                                  , N'주'           AS UNIT
                                  , NULL          AS CELL_ITEM_ID
                                  , NULL          AS BOH
                                  , 0             AS QTY
						                      , X.YYYYMMDD	
			                            , M.SORT_ORDER_NO								
                                  , NULL          AS ORIGIN_FROM_DIVISION_ID
                                  , NULL          AS ORIGIN_TO_DIVISION_ID
                                  , M.COLUMN_NAME AS ATTRIBUTE1
                                  , NULL AS ATTRIBUTE7
                                  ,'15' AS ATTRIBUTE8
			                            , NULL          AS ATTRIBUTE9		
                FROM #PSI_GLOBAL X WITH (NOLOCK)
                INNER JOIN #MEASURE M WITH(NOLOCK)	
                      ON M.COLUMN_NAME     IN ('ETC_LT')
                WHERE 0 = 0
                  AND X.PSI_TYPE     = 'Sale'      
                  AND X.MEASURE      <> 'SHIP_PLAN_TOTAL'
                GROUP BY  X.NICK_NAME		
                                  , X.ELECTRODE_TYPE
			                            , X.ITEM_ID										
			                            , X.FROM_SITE_ID  
			                            , M.COLUMN_NAME   
                                  , X.TO_SITE_ID    
						                      , X.YYYYMMDD
			                            , M.SORT_ORDER_NO								
                                  , M.COLUMN_NAME
                                  , M.COLUMN_LABEL_NAME




            -------------------------------------------------------------------------------------------------------------         
            -- CELL 환산수량
            -------------------------------------------------------------------------------------------------------------         
            UPDATE X
              SET X.QTY    = (CASE WHEN MEASURE NOT LIKE 'SHIP%' THEN (ISNULL(X.QTY,0.00) 
                                                                                            *  (CASE WHEN MEASURE ='PROD_PLAN_AMEND' THEN ISNULL(Y.CONVERT_QTY_CELL,1) ELSE 1 END) )
                                   ELSE ISNULL(X.QTY,0.00) END )    -- CELL 환산수량      
                  ,X.CONVERT_QTY_CELL = ISNULL(Y.CONVERT_QTY_CELL,1)
              FROM #PSI_GLOBAL X WITH (NOLOCK)
              INNER JOIN  SCP_MST_FINAL_ITEM Y WITH (NOLOCK)   
              ON 0 = 0
              AND Y.ITEM_ID         = X.ITEM_ID 
              AND Y.OPERATION_GROUP ='E'
              --AND Y.CONVERT_QTY_CELL IS NOT NULL        


            
             -------------------------------------------------------------------------------------------------------------------------         
            -- CELL_TYPE_GROUP_CODE UPDATE
            ------------------------------------------------------------------------------------------------------------------------- 
             UPDATE X
                SET X.CELL_TYPE_GROUP_CODE =
                        ( CASE SUBSTRING(X.CELL_ITEM_ID,3,1)  WHEN 'R' THEN 'R'
                                                              WHEN 'C' THEN 'C'
                                                              WHEN 'S' THEN 'C'
                                                              WHEN 'P' THEN 'P'
                                                              WHEN 'F' THEN 'P'
                                                              WHEN 'N' THEN 'P'
                                                              WHEN 'E' THEN 'P'
                                                              ELSE '' END )
               FROM #PSI_GLOBAL X  WITH (NOLOCK)




            -------------------------------------------------------------------------------------------------------------------------   
            -- 'ETC_YIELD' 추가 YIELD 반영  TACT_TIME_EXCEPT Yield 로직 추가
            -------------------------------------------------------------------------------------------------------------

--                 DELETE TBL FROM
--	                (
--	                        SELECT
--	                               ROW_NUMBER() OVER (PARTITION BY FROM_SITE_ID,NICK_NAME,ITEM_ID,ATTRIBUTE8,PROD_LINE,SORT_ORDER_NO,TO_SITE_ID,CELL_ITEM_ID,YYYYMMDD
--                                 ORDER BY ATTRIBUTE1) AS ROWNUM
----                                 ,*
--	                        FROM #PSI_GLOBAL
--                        WHERE MEASURE IN ('ETC_YIELD')     
--	                ) AS TBL
--	                WHERE TBL.ROWNUM > 1



		
			-- 2021.04.30 KSW PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전으로 신규생성 - start
			-- 1 YEAR VS 2 YEAR 간 ROW 불일치하므로 0 값 생성
			INSERT #PSI_GLOBAL
			    SELECT 	  A.DIVISION_ID								
						, A.CELL_TYPE_GROUP_CODE						
						, A.NICK_NAME		
						, A.ELECTRODE_TYPE
						, A.ITEM_ID										
						, A.FROM_SITE_ID
						, A.FROM_SITE_DESCRIPTION
						, A.TO_SITE_ID
						, A.TO_SITE_DESCRIPTION
						, A.LT_WEEK										
						, A.CONVERT_QTY_CELL									
						, A.PROD_LINE 										
						, A.PSI_TYPE
						, A.MEASURE
						, A.MEASURE_LABEL
						, A.MEASURE_VALUE1
						, A.MEASURE_VALUE1_LABEL  
						, A.MEASURE_VALUE2
						, A.MEASURE_VALUE2_LABEL  
						, A.UNIT
						, A.CELL_ITEM_ID
						, A.BOH
						, A.QTY
						, B.YYYYMMDD	
						, A.SORT_ORDER_NO								
						, A.ORIGIN_FROM_DIVISION_ID
						, A.ORIGIN_TO_DIVISION_ID
						, A.ATTRIBUTE1
						, A.ATTRIBUTE7
						, A.ATTRIBUTE8
						, A.ATTRIBUTE9
				  FROM (
						SELECT    DISTINCT
								  X.DIVISION_ID								
								, X.CELL_TYPE_GROUP_CODE						
								, X.NICK_NAME		
								, X.ELECTRODE_TYPE
								, X.ITEM_ID										
								, X.FROM_SITE_ID
								, X.FROM_SITE_DESCRIPTION
								, X.TO_SITE_ID
								, X.TO_SITE_DESCRIPTION
								, X.LT_WEEK										
								, X.CONVERT_QTY_CELL									
								, X.PROD_LINE 										
								, X.PSI_TYPE
								, X.MEASURE
								, X.MEASURE_LABEL
								, X.MEASURE_VALUE1
								, X.MEASURE_VALUE1_LABEL  
								, X.MEASURE_VALUE2
								, X.MEASURE_VALUE2_LABEL  
								, X.UNIT
								, X.CELL_ITEM_ID
								, 0 AS BOH
								, 0 AS QTY	
								, X.SORT_ORDER_NO								
								, X.ORIGIN_FROM_DIVISION_ID
								, X.ORIGIN_TO_DIVISION_ID
								, X.ATTRIBUTE1
								, X.ATTRIBUTE7
								, X.ATTRIBUTE8
								, X.ATTRIBUTE9			   
						 FROM #PSI_GLOBAL X WITH (NOLOCK)
				       ) A,
					   (SELECT CONVERT(VARCHAR(8), DATEADD(day, 364, @p_plan_start_yyyymmdd), 112) AS YYYYMMDD
					     UNION ALL
						SELECT @p_plan_start_yyyymmdd AS YYYYMMDD
					   ) B
					   --(  -- 728 DAYS      
        --                SELECT C.BASIS_YYYYMMDD AS YYYYMMDD          
        --                  FROM SCM_SYS_CALENDAR_M    C WITH(NOLOCK)         
        --                 WHERE 1=1      
        --                   AND C.BASIS_YYYYMMDD > @p_plan_start_yyyymmdd       -- 엔진시작일 제외
        --                   AND C.BASIS_YYYYMMDD <  @p_to_yyyymmdd  
        --               ) B
				;
			-- 2021.04.30 KSW PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전으로 신규생성 - end 



            -------------------------------------------------------------------------------------------------------
			-- TACT TIME UPDATE 에 필요한 임시 테이블 생성
			-- #tmp_SCP_MST_TACT_TIME 를 사용하지 않는 이유는 현 시점에서 ITEM_ID 가 더 많기 때문
			-------------------------------------------------------------------------------------------------------
            IF OBJECT_ID('tempdb..#tmp_ITEM_ID') IS NOT NULL	
	              DROP TABLE #tmp_ITEM_ID

			SELECT DISTINCT ITEM_ID
			  INTO #tmp_ITEM_ID
			  FROM #PSI_GLOBAL WITH (NOLOCK)
			 ;


            IF OBJECT_ID('tempdb..#tmp_SCP_MST_TACT_TIME_2') IS NOT NULL	
	              DROP TABLE #tmp_SCP_MST_TACT_TIME_2

            IF OBJECT_ID('tempdb..#tmp_SCP_ANL_TACT_TIME_21') IS NOT NULL	
	              DROP TABLE #tmp_SCP_ANL_TACT_TIME_21

            IF OBJECT_ID('tempdb..#tmp_SCP_ANL_TACT_TIME_22') IS NOT NULL	
	              DROP TABLE #tmp_SCP_ANL_TACT_TIME_22

				SELECT T.DIVISION_ID
						,T.PLANT_SITE_ID
						,T.OPERATION_ID
						,T.LINE_ID
						,T.ITEM_ID
						,T.ITEM_UOM
						,T.TACT_TIME
						,YYYYMMDD
						,YYYYMMDD_COLUMN
						,'Y' AS YN
						,'Y' AS USE_YN
						,AA.ATTRIBUTE3
						,T.ATTRIBUTE1 AS ATTRIBUTE4
				INTO #tmp_SCP_ANL_TACT_TIME_21
				FROM SCP_MST_TACT_TIME T WITH(NOLOCK)
				LEFT OUTER JOIN (SELECT MAX(ATTRIBUTE3) AS ATTRIBUTE3, ITEM_ID, LINE_ID
								   FROM SCP_ANL_TACT_TIME A WITH (NOLOCK)
								  WHERE 0 = 0
									AND ATTRIBUTE3 IS NOT NULL
							      GROUP BY ITEM_ID,LINE_ID
						        ) AA
					ON T.ITEM_ID = AA.ITEM_ID
					AND T.LINE_ID = AA.LINE_ID
				CROSS APPLY #tmp_SCM_SYS_CALENDAR_M Y WITH (NOLOCK)
				WHERE 1=1
					AND T.VALID_YN   = 'Y'
					AND T.ITEM_ID IN (SELECT ITEM_ID FROM #tmp_ITEM_ID  WITH (NOLOCK))
		--        AND S.OSP_YN     <> 'Y'
		;

                SELECT DIVISION_ID
                        ,PLANT_SITE_ID AS SCM_SITE_ID
                        ,OPERATION_ID
                        ,X.LINE_ID
                        ,X.ITEM_ID
                        ,AA.ITEM_UOM
                        ,(CASE USE_YN WHEN 'N' THEN 0.0 ELSE TACT_TIME END) AS TACT_TIME
                        ,YYYYMMDD
                        ,YYYYMMDD_COLUMN
                        ,'N' AS YN
                        ,USE_YN
                        ,AA.ATTRIBUTE3
                        ,(SELECT TOP 1 A.ATTRIBUTE1 FROM SCP_MST_TACT_TIME A WITH (NOLOCK) WHERE A.ITEM_ID = X.ITEM_ID AND A.LINE_ID = X.LINE_ID ) AS ATTRIBUTE4
				INTO #tmp_SCP_ANL_TACT_TIME_22
                FROM SCP_MST_TACT_TIME_EXCEPT X WITH(NOLOCK)
                LEFT OUTER JOIN (SELECT MAX(ATTRIBUTE1) AS ITEM_UOM, MAX(ATTRIBUTE3) AS ATTRIBUTE3, ITEM_ID, LINE_ID
                                   FROM SCP_ANL_TACT_TIME A WITH (NOLOCK)
                                  WHERE 0 = 0
                                    AND ATTRIBUTE3 IS NOT NULL
                                  GROUP BY ITEM_ID, LINE_ID
                                ) AA
                    ON X.ITEM_ID = AA.ITEM_ID
                    AND X.LINE_ID = AA.LINE_ID
					AND X.USE_YN = 'Y'
                CROSS APPLY #tmp_SCM_SYS_CALENDAR_M Y WITH (NOLOCK)
                WHERE 0 = 0
                    AND Y.YYYYMMDD >= TACT_TIME_START_DATE
                    AND Y.YYYYMMDD <= TACT_TIME_END_DATE
                    AND X.ITEM_ID IN (SELECT ITEM_ID FROM #tmp_ITEM_ID  WITH (NOLOCK))
				;

              SELECT DIVISION_ID,PLANT_SITE_ID,OPERATION_ID,LINE_ID,ITEM_ID,TACT_TIME,YYYYMMDD,YYYYMMDD_COLUMN,ITEM_UOM
                    ,(CASE WHEN LEN(RTRIM(LTRIM(ATTRIBUTE3))) = 0 THEN 0 ELSE CONVERT(numeric (20,10),ATTRIBUTE3) END ) AS ATTRIBUTE3
                    ,(CASE WHEN LEN(RTRIM(LTRIM(ATTRIBUTE4))) = 0 THEN 0 ELSE CONVERT(numeric (20,10),ATTRIBUTE4) END ) AS ATTRIBUTE4
                INTO #tmp_SCP_MST_TACT_TIME_2
                FROM (
                      SELECT X.DIVISION_ID,PLANT_SITE_ID,OPERATION_ID,LINE_ID,ITEM_ID,TACT_TIME,YYYYMMDD,YYYYMMDD_COLUMN
                            ,YN
                            ,USE_YN
                            ,ITEM_UOM,X.ATTRIBUTE3,X.ATTRIBUTE4
                            ,ROW_NUMBER() OVER (PARTITION BY X.DIVISION_ID,PLANT_SITE_ID,OPERATION_ID,LINE_ID,ITEM_ID,YYYYMMDD ORDER BY YN) AS Rn
                            ,ISNULL((SELECT COUNT(LS.ACTIVE_FLAG) 
                                      FROM SCM_MST_LINE_SN LS 
												              WHERE 0 = 0
                                        --AND LS.COMPANY_ID   = B.COMPANY_ID 
                                        AND LS.DIVISION_ID  = X.DIVISION_ID 
                                        --AND LS.SITE_ID      = B.PLANT_SITE_ID 
                                        AND LS.PLANT_ID     = B.PLANT_ID 
												                AND LS.OPERATION_ID = X.OPERATION_ID 
                                        AND LS.LINE_ID      = X.LINE_ID 
                                        AND LS.ACTIVE_FLAG='Y'), 0) ACTIVE_CNT
                      FROM
                      (
                --       SELECT T.DIVISION_ID
                --              ,T.PLANT_SITE_ID
                --              ,T.OPERATION_ID
                --              ,T.LINE_ID
                --              ,T.ITEM_ID
                --              ,T.ITEM_UOM
                --              ,T.TACT_TIME
                --              ,YYYYMMDD
                --              ,YYYYMMDD_COLUMN
                --              ,'Y' AS YN
                --              ,'Y' AS USE_YN
                --              ,AA.ATTRIBUTE3
                --              ,T.ATTRIBUTE1 AS ATTRIBUTE4
                --        FROM SCP_MST_TACT_TIME T WITH(NOLOCK)
                --        LEFT OUTER JOIN (SELECT MAX(ATTRIBUTE3) AS ATTRIBUTE3, ITEM_ID, LINE_ID
                --                          FROM SCP_ANL_TACT_TIME A WITH (NOLOCK)
                --                        WHERE 0 = 0
                --                          AND ATTRIBUTE3 IS NOT NULL
                --                         GROUP BY ITEM_ID,LINE_ID
                --                         ) AA
                --          ON T.ITEM_ID = AA.ITEM_ID
                --         AND T.LINE_ID = AA.LINE_ID
                --        CROSS APPLY #tmp_SCM_SYS_CALENDAR_M Y WITH (NOLOCK)
                --        WHERE 1=1
                --          AND T.VALID_YN   = 'Y'
                --          AND T.ITEM_ID IN (SELECT ITEM_ID FROM #tmp_ITEM_ID  WITH (NOLOCK))
                ----        AND S.OSP_YN     <> 'Y'
                
					  SELECT * FROM #tmp_SCP_ANL_TACT_TIME_21

                      UNION ALL

       --                SELECT DIVISION_ID
       --                       ,PLANT_SITE_ID AS SCM_SITE_ID
       --                       ,OPERATION_ID
       --                       ,X.LINE_ID
       --                       ,X.ITEM_ID
       --                       ,AA.ITEM_UOM
       --                       ,(CASE USE_YN WHEN 'N' THEN 0.0 ELSE TACT_TIME END) AS TACT_TIME
       --                       ,YYYYMMDD
       --                       ,YYYYMMDD_COLUMN
       --                       ,'N' AS YN
       --                       ,USE_YN
       --                       ,AA.ATTRIBUTE3
       --                       ,(SELECT TOP 1 A.ATTRIBUTE1 FROM SCP_MST_TACT_TIME A WITH (NOLOCK) WHERE A.ITEM_ID = X.ITEM_ID AND A.LINE_ID = X.LINE_ID ) AS ATTRIBUTE4
       --                 FROM SCP_MST_TACT_TIME_EXCEPT X WITH(NOLOCK)
       --                 LEFT OUTER JOIN (SELECT MAX(ATTRIBUTE1) AS ITEM_UOM, MAX(ATTRIBUTE3) AS ATTRIBUTE3, ITEM_ID, LINE_ID
       --                                   FROM SCP_ANL_TACT_TIME A WITH (NOLOCK)
       --                                 WHERE 0 = 0
       --                                   AND ATTRIBUTE3 IS NOT NULL
       --                                  GROUP BY ITEM_ID, LINE_ID
       --                                  ) AA
       --                   ON X.ITEM_ID = AA.ITEM_ID
       --                  AND X.LINE_ID = AA.LINE_ID
						 --AND X.USE_YN = 'Y'
       --                 CROSS APPLY #tmp_SCM_SYS_CALENDAR_M Y WITH (NOLOCK)
       --                 WHERE 0 = 0
       --                   AND Y.YYYYMMDD >= TACT_TIME_START_DATE
       --                   AND Y.YYYYMMDD <= TACT_TIME_END_DATE
       --                   AND X.ITEM_ID IN (SELECT ITEM_ID FROM #tmp_ITEM_ID  WITH (NOLOCK))

					   SELECT * FROM #tmp_SCP_ANL_TACT_TIME_22
                      ) X
                       INNER JOIN SCM_MST_SITE B WITH(NOLOCK)
                        ON X.DIVISION_ID = B.DIVISION_ID 
                       AND X.PLANT_SITE_ID = B.SCM_SITE_ID	
					   
                ) XX

                WHERE Rn = 1
                  AND ITEM_ID IN (SELECT ITEM_ID FROM #tmp_ITEM_ID  WITH (NOLOCK))
                  AND USE_YN = 'Y'
                  ANd ACTIVE_CNT > 0
				  ;



			-- 2021.04.30 KSW PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전으로 신규생성
            --  구 버전에서 PIVOT 생성단계 이후 단계를 호출하는 로직으로 분리함 (1 YEAR 구간별 생성 :: 중장기 구현시 컬럼 및 행 SIZE 제약 해결)
			--

			-- 동일 플랜의 구 data 삭제
			DELETE FROM SCP_XLS_PSI_GLOBAL_ELECTRODE
                    WHERE DIVISION_ID = @p_division_id ;
					-- AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd AND PLAN_TYPE = @p_plan_type AND SEQ = @p_seq  


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

			EXEC @rows = PR_SCP_XLS_PSI_GLOBAL_ELECTRODE_S        @p_plan_cycle             = @p_plan_cycle          
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
																;
            IF (@rows < 0)  GOTO _RETURN_ERR_CODE  
			
			IF @v_bp_flag = 'Y'
			BEGIN
				-- 2 YEAR PIVOT data 생성
				SET @p_create_from_yyyymmdd = CONVERT(VARCHAR(8), DATEADD(day, 1, @p_create_to_yyyymmdd), 112);
				SET @p_create_to_yyyymmdd   = CONVERT(VARCHAR(8), DATEADD(day, 363, @p_create_from_yyyymmdd), 112);

				EXEC @rows = PR_SCP_XLS_PSI_GLOBAL_ELECTRODE_S        @p_plan_cycle             = @p_plan_cycle          
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

              IF OBJECT_ID('tempdb..#ITEM_ID') IS NOT NULL      
	              DROP TABLE #ITEM_ID;   

              IF OBJECT_ID('tempdb..#SCP_MST_MODEL_ALLOCATION_MULTI') IS NOT NULL      
	              DROP TABLE #SCP_MST_MODEL_ALLOCATION_MULTI;

                
              IF OBJECT_ID('tempdb..#ITEM_ID_FROM_SITE_ID') IS NOT NULL      
	              DROP TABLE #ITEM_ID_FROM_SITE_ID;       

              IF OBJECT_ID('tempdb..#ETC_RATE')    IS NOT NULL	
		            DROP TABLE #ETC_RATE
                

              IF OBJECT_ID('tempdb..#BOM_LT')    IS NOT NULL	
		            DROP TABLE #BOM_LT

                
             IF OBJECT_ID('tempdb..#SCP_XLS_PSI_GLOBAL_ELECTRODE') IS NOT NULL      
	              DROP TABLE #SCP_XLS_PSI_GLOBAL_ELECTRODE;              

            IF OBJECT_ID('tempdb..#SCM_MST_BOM_SN') IS NOT NULL      
                DROP TABLE #SCM_MST_BOM_SN;  


             IF OBJECT_ID('tempdb..#YIELD_GROUP') IS NOT NULL      
                DROP TABLE #YIELD_GROUP;  

            IF OBJECT_ID('tempdb..#ETC_YIELD') IS NOT NULL      
                DROP TABLE #ETC_YIELD;  

            IF OBJECT_ID('tempdb..#ETC_YIELD_PIVOT') IS NOT NULL      
                DROP TABLE #ETC_YIELD_PIVOT;  
                
             IF OBJECT_ID('tempdb..#Rn')  IS NOT NULL       
		            DROP TABLE #Rn

             IF OBJECT_ID('tempdb..#CALENDAR') IS NOT NULL      
	              DROP TABLE #CALENDAR; 

             IF OBJECT_ID('tempdb..#HEADER')   IS NOT NULL
	              DROP TABLE #HEADER           
				  
			 IF OBJECT_ID('tempdb..#tmp_SCP_MST_DIO')   IS NOT NULL    -- DIO 기준/최소 관련
	              DROP TABLE #tmp_SCP_MST_DIO       

            -------------------------------------------------------------------------------------------------------------         
            -- WORKING_TIME UPDATE pivot 테이블 생성   
            ------------------------------------------------------------------------------------------------------------- 
               IF OBJECT_ID('tempdb..#PROD_WORKING_TIME_PIVOT') IS NOT NULL	
	              DROP TABLE #PROD_WORKING_TIME_PIVOT

            -------------------------------------------------------------------------------------------------------------         
            -- TACT TIME UPDATE pivot 테이블 생성   
            ------------------------------------------------------------------------------------------------------------- 
               IF OBJECT_ID('tempdb..#PROD_TACT_TIME_PIVOT') IS NOT NULL	
	              DROP TABLE #PROD_TACT_TIME_PIVOT

            IF OBJECT_ID('tempdb..#tmp_SCM_SYS_CALENDAR_M_2') IS NOT NULL	
	              DROP TABLE #tmp_SCM_SYS_CALENDAR_M_2

			-- TACT TIME UPDATE 에 필요한 ITEM_ID 테이블 생성
            IF OBJECT_ID('tempdb..#tmp_ITEM_ID') IS NOT NULL	
	              DROP TABLE #tmp_ITEM_ID

            IF OBJECT_ID('tempdb..#tmp_SCP_MST_TACT_TIME_2') IS NOT NULL	
	              DROP TABLE #tmp_SCP_MST_TACT_TIME_2

			IF OBJECT_ID('tempdb..#tmp_FROM_SITE_ID') IS NOT NULL      
				DROP TABLE #tmp_FROM_SITE_ID

            IF OBJECT_ID('tempdb..#tmp_SCP_ANL_TACT_TIME_1') IS NOT NULL	
	              DROP TABLE #tmp_SCP_ANL_TACT_TIME_1

            IF OBJECT_ID('tempdb..#tmp_SCP_ANL_TACT_TIME_2') IS NOT NULL	
	              DROP TABLE #tmp_SCP_ANL_TACT_TIME_2

            IF OBJECT_ID('tempdb..#tmp_SCP_ANL_TACT_TIME_1') IS NOT NULL	
	              DROP TABLE #tmp_SCP_ANL_TACT_TIME_21

            IF OBJECT_ID('tempdb..#tmp_SCP_ANL_TACT_TIME_2') IS NOT NULL	
	              DROP TABLE #tmp_SCP_ANL_TACT_TIME_22

	        IF OBJECT_ID('tempdb..#tmp_SCM_MST_LINE_V') IS NOT NULL	
	            DROP TABLE #tmp_SCM_MST_LINE_V   

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
      
  
  
     SET @v_exec_time  =  REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +     
                          REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))     
       
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
  
  


