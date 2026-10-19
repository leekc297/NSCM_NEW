



/*
 * Program ID   : SCM0002_SAVE_SHIPMENT_PLAN_NEW
 * Description  : Shipment Plan FG/SEMI New 입력
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2019/07/11	YHW				[CSR ID:4043582] GSCM - Shipment Plan FG / SEMI "New" 버튼 생성 요청 건
 * 2021/07/26   khj79           [PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - 중장기 프로젝트(기간82주로 연장)
 * 2025/11/11   hrkim			[PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 
 *									: ESS 가상 사이트 계획을 매핑된 JV 사이트 계획으로 동기화 저장 (ESS 가상 -> JV Real 단방향 저장) 
 *										- TO Site 정보는 그대로 가져간다. (BOD_ID는 매핑이 안되면 '-')
 *								  - 2025.12.16 동기화 대상 데이터 from/to 사이트와 무관하게 origin from/to division_id 컬럼 division_id와 같은 값으로 저장(81_ST) : 김춘동 책임님 
 *								  - 2025.12.23 동기화 데이터 생성시 BOD_ID 매핑이 안되는 경우 ESS 가상 사이트 BOD_ID 유지 
 *
 */
CREATE PROCEDURE [dbo].[SCM0002_SAVE_SHIPMENT_PLAN_NEW]
	 @p_division_id		NVARCHAR(MAX)
	,@p_plan_start_yyyymmdd	NVARCHAR(MAX)
	,@p_plan_type			NVARCHAR(MAX)
	,@p_seq					NVARCHAR(MAX)
	,@p_operation_group		NVARCHAR(MAX)
	,@p_project_code		NVARCHAR(MAX)
	,@p_item_id				NVARCHAR(MAX)
	,@p_to_site				NVARCHAR(MAX)
	,@p_incoterms			NVARCHAR(MAX)
	,@p_from_site			NVARCHAR(MAX)
	,@p_bod_id				NVARCHAR(MAX)
	,@p_origin_from_division_id		NVARCHAR(MAX)
	,@p_origin_to_division_id		NVARCHAR(MAX)
	,@p_electrode_type		NVARCHAR(MAX)
	,@p_prgram_id			NVARCHAR(MAX)
	,@p_user_id				NVARCHAR(MAX)
AS

BEGIN

	/********************************************************************************      
	* 임시테이블만들기
	********************************************************************************/ 
	-- 신규입력(다건)     
	IF OBJECT_ID('tempdb..#TblDynamic_SCM0002_ShpimentPlanNew') IS NOT NULL
	DROP TABLE #TblDynamic_SCM0002_ShpimentPlanNew;    

	-- FG/SEMI 기존입력건
	IF OBJECT_ID('tempdb..#TblDynamic_SCM0002_ShpimentPlan') IS NOT NULL
	DROP TABLE #TblDynamic_SCM0002_ShpimentPlan; 

	CREATE TABLE #TblDynamic_SCM0002_ShpimentPlanNew (
		DIVISION_ID				NVARCHAR(30)	
		,PLAN_START_YYYYMMDD	NVARCHAR(8)	
		,PLAN_TYPE				NVARCHAR(50)
		,SEQ					NVARCHAR(30)	
		,OPERATION_GROUP		NVARCHAR(30)
		,PROJECT_CODE			NVARCHAR(50)
		,ITEM_ID				NVARCHAR(50)
		,TO_SITE				NVARCHAR(30)
		,INCOTERMS				NVARCHAR(10)
		,FROM_SITE				NVARCHAR(30)
		,BOD_ID					NVARCHAR(150)
		,ORIGIN_FROM_DIVISION_ID	NVARCHAR(30)
		,ORIGIN_TO_DIVISION_ID	NVARCHAR(30)
		,ELECTRODE_TYPE			NVARCHAR(30)
		,MEASURE				NVARCHAR(50)
	);

	CREATE TABLE #TblDynamic_SCM0002_ShpimentPlan (
		DIVISION_ID				NVARCHAR(30)	
		,PLAN_START_YYYYMMDD	NVARCHAR(8)	
		,PLAN_TYPE				NVARCHAR(50)
		,SEQ					NVARCHAR(30)	
		,OPERATION_GROUP		NVARCHAR(30)
		,PROJECT_CODE			NVARCHAR(50)
		,ITEM_ID				NVARCHAR(50)
		,TO_SITE				NVARCHAR(30)
		,INCOTERMS				NVARCHAR(10)
		,FROM_SITE				NVARCHAR(30)
		,BOD_ID					NVARCHAR(150)
		,MEASURE				NVARCHAR(50)
	);

	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^' 
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;

	DECLARE @recv_division_id		NVARCHAR(MAX);
	SET @recv_division_id = NULL;		
	SET @recv_division_id = @p_division_id;

	-- 중장기 개발 : 52주 => 82주 변경
	DECLARE @v_daily_plan_period INT = 0;

	SELECT @v_daily_plan_period = ISNULL(DAILY_PLAN_PERIOD,52)
	  FROM [dbo].[SCM_MST_DIVISION] WITH(NOLOCK)	
	 WHERE DIVISION_ID = @p_division_id
	;

	DECLARE @p_plan_end_yyyymmdd NVARCHAR(8);
	--SET @p_plan_end_yyyymmdd = CONVERT(CHAR(8),DATEADD( YEAR, 1, CONVERT(DATETIME, @p_plan_start_yyyymmdd,112)), 112)
	SET @p_plan_end_yyyymmdd = CONVERT(CHAR(8),DATEADD( DD, (@v_daily_plan_period * 7 ) -1, CONVERT(DATETIME, @p_plan_start_yyyymmdd,112)), 112);
	-- 중장기 개발 : 52주 => 82주 변경 끝

	DECLARE @v_project_code		NVARCHAR(50);
	DECLARE @v_item_id			NVARCHAR(50);
	DECLARE @v_to_site			NVARCHAR(30);
	DECLARE @v_incoterms		NVARCHAR(10);
	DECLARE @v_from_site		NVARCHAR(30);
	DECLARE @v_bod_id			NVARCHAR(150);
	DECLARE @v_origin_from_division_id	NVARCHAR(30);
	DECLARE @v_origin_to_division_id	NVARCHAR(30);
	DECLARE @v_electrode_type	NVARCHAR(30);

	SET @v_project_code = NULL;
	SET @v_item_id = NULL;
	SET @v_to_site = NULL;
	SET @v_incoterms = NULL;
	SET @v_from_site = NULL;
	SET @v_bod_id = NULL;
	SET @v_origin_from_division_id = NULL;
	SET @v_origin_to_division_id = NULL;
	SET @v_electrode_type = NULL;

	-- LOG 용 변수 설정
	DECLARE @v_program_name NVARCHAR(150) = 'SCM0002_SAVE_SHIPMENT_PLAN_NEW';
	DECLARE @v_log_type     NVARCHAR(30);
	DECLARE @n_log_count    INTEGER = 0;
	DECLARE @v_log_message  NVARCHAR(1000);
	DECLARE @v_description  NVARCHAR(500);
	DECLARE @d_event_date   DATETIME;


	BEGIN TRY

		-- 시작 LOG
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		-- 프로시저 LOOP 길이를 판단
		SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_item_id, @v_delimiter);    

		------------------------------------------------------------------------------------------------------------------------------------------------------- 
		--### Start : [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : ESS 가상 라인 계획으로 매핑된 JV 라인 계획 동기화 저장 (ESS 가상 -> JV Real 단방향 저장) 
		-------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' JV/ESS scm site 매핑 정보 추출' 
		-------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#JV_ESS_SCM_SITE_MAP') IS NOT NULL DROP TABLE #JV_ESS_SCM_SITE_MAP;
		SELECT VP_COMPANY_ID
			  ,VP_DIVISION_ID
			  ,VP_SITE_ID
			  ,VP_PLANT_ID
			  ,VP_SCM_SITE_ID
			  ,RP_COMPANY_ID
			  ,RP_DIVISION_ID
			  ,RP_SITE_ID
			  ,RP_PLANT_ID
			  ,RP_SCM_SITE_ID
		 INTO #JV_ESS_SCM_SITE_MAP
		 FROM FN_GET_JV_REAL_ESS_VIRTUAL_SITE_MAP () 
		 WHERE 1=1;
		------------------------------------------------------------------------------------------------------------  
		print  convert(varchar(30), getdate(), 121) + N' DIVISION 주차별 최종 수행 Plan 버전 정보 ' 
		-- ESS 가상 라인 매핑 JV division의 동기화 대상 버전 정보 확인을 위한 데이터
		-- Final Plan은 수정 대상에서 제외 ? 
		------------------------------------------------------------------------------------------------------------  
		IF OBJECT_ID('TEMPDB..#DIVISION_LAST_PLAN_INFO') IS NOT NULL DROP TABLE #DIVISION_LAST_PLAN_INFO;
		;WITH SCP_PLAN_INFO AS (
			SELECT PD.DIVISION_ID
				 , PM.PLAN_NAME			AS PLAN_START_YYYYMMDD
				 , PD.PLAN_TYPE
				 , PD.PLAN_SEQ
				 , PM.HORIZON_END_DATE	
				 , PD.PLAN_STATUS
				 , PD.INPUT_START_DATE 
				 , ROW_NUMBER()	OVER (PARTITION BY PD.DIVISION_ID
												 , PM.PLAN_NAME
										 ORDER  BY CASE WHEN PD.PLAN_TYPE = 'PR' THEN 4
														WHEN PD.PLAN_TYPE = 'MA' THEN 3
														WHEN PD.PLAN_TYPE = 'SE' THEN 2
														WHEN PD.PLAN_TYPE = 'FN' THEN 1
														ELSE 0
												   END
												  ,PD.PLAN_SEQ DESC
												  ,PD.INPUT_START_DATE DESC ) AS RN
			 FROM SCM_MST_PLAN PM WITH(NOLOCK)
				  INNER JOIN SCM_MST_PLAN_DETAIL PD WITH(NOLOCK)
						  ON PD.DIVISION_ID = PM.DIVISION_ID
						 AND PD.PLAN_ID		= PM.PLAN_ID
						 AND PD.PLAN_STATUS	= 1
				  INNER JOIN SCM_MST_DIVISION DM WITH(NOLOCK)
						  ON DM.DIVISION_ID	= PM.DIVISION_ID 
						 AND DM.ATTRIBUTE3 != 'EE'
			WHERE 1=1 
			  AND PM.PLAN_CYCLE = 'WEEKLY'
			  AND PM.PLAN_NAME	>= CONVERT(NVARCHAR(8), DATEADD(DAY, -20, GETDATE()) , 112)
		)
		SELECT DIVISION_ID
			  ,PLAN_START_YYYYMMDD
			  ,PLAN_TYPE
			  ,PLAN_SEQ
			  ,HORIZON_END_DATE
			  ,PLAN_STATUS
			  ,INPUT_START_DATE
			  ,RN
		  INTO #DIVISION_LAST_PLAN_INFO
		 FROM SCP_PLAN_INFO
		WHERE 1=1
		  AND RN = 1 
		  AND PLAN_TYPE != 'FN' -- Final plan 대상에서 제외 
		  ;
		------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' BOD 및 BOD ITEM 정보' 
		------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#BOD_ITEM') IS NOT NULL DROP TABLE #BOD_ITEM
		;WITH BOD_ITEM AS ( 
			SELECT  BD.DIVISION_ID
				   ,BD.FROM_SITE
				   ,BD.TO_SITE
				   ,BD.INCOTERMS
				   ,BI.ITEM_ID
				   ,BD.BOD_ID
				   ,ROW_NUMBER() OVER (PARTITION BY BD.DIVISION_ID
												   ,BD.FROM_SITE
												   ,BD.TO_SITE
												   ,BD.INCOTERMS
												   ,BI.ITEM_ID
										   ORDER BY BD.PRIORITY 
												   ,BI.PRIORITY
												   ,BD.ATTRIBUTE3 DESC
												   ,BI.TO_YYYYMMDD DESC 
												   ,BD.LAST_UPDATE_DATE DESC )	AS RN 
			  FROM SCP_MST_BOD BD WITH(NOLOCK)
				   INNER JOIN SCP_MST_BOD_ITEM BI WITH(NOLOCK)
						   ON BI.BOD_ID			= BD.BOD_ID
						  AND BI.VALID_YN		= 'Y'
						  AND BI.TO_YYYYMMDD	>= CONVERT(NVARCHAR(8), DATEADD(DAY, -7, GETDATE()) , 112)
			 WHERE 1=1
			   AND BD.ATTRIBUTE3 > CONVERT(NVARCHAR(8), DATEADD(DAY, -7, GETDATE()) , 112)
			   AND BD.VALID_YN	= 'Y'
			   AND EXISTS (SELECT TOP 1 'X'
							 FROM #JV_ESS_SCM_SITE_MAP SM 
							WHERE SM.RP_DIVISION_ID = BD.DIVISION_ID
							  AND SM.RP_SCM_SITE_ID	= BD.FROM_SITE )
		)
		SELECT DIVISION_ID
			  ,FROM_SITE
			  ,TO_SITE
			  ,INCOTERMS
			  ,ITEM_ID
			  ,BOD_ID
			  ,RN
		 INTO #BOD_ITEM
		 FROM BOD_ITEM 
		WHERE RN = 1 
		------------------------------------------------------------------------------------------------------------------------------------------------------- 
		--### End : [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : ESS 가상 라인 계획으로 매핑된 JV 라인 계획 동기화 저장 (ESS 가상 -> JV Real 단방향 저장) 
		-------------------------------------------------------------------------------------------------------------------------------------------------------

		/*** 1. 신규건 MEASURE별 입력데이터 정리   *****/
		WHILE LEN(@recv_division_id) > 0 AND @mst_loop_cnt < @max_loop_cnt
		BEGIN
			
			-- @mst_loop_cnt 1증가
			SET @mst_loop_cnt = @mst_loop_cnt + 1;

			-- 각 컬럼들에 대한 스플릿처리로직 스타트
			BEGIN
				SET @v_project_code		= [dbo].[SCM_ARR_SPL_VAL](@p_project_code,		@v_delimiter, @mst_loop_cnt) ;    
				SET @v_item_id			= [dbo].[SCM_ARR_SPL_VAL](@p_item_id,			@v_delimiter, @mst_loop_cnt) ; 
				SET @v_to_site			= [dbo].[SCM_ARR_SPL_VAL](@p_to_site,			@v_delimiter, @mst_loop_cnt) ; 
				SET @v_incoterms		= [dbo].[SCM_ARR_SPL_VAL](@p_incoterms,			@v_delimiter, @mst_loop_cnt) ;    
				SET @v_from_site		= [dbo].[SCM_ARR_SPL_VAL](@p_from_site,			@v_delimiter, @mst_loop_cnt) ; 
				SET @v_bod_id			= [dbo].[SCM_ARR_SPL_VAL](@p_bod_id,			@v_delimiter, @mst_loop_cnt) ; 
				SET @v_origin_from_division_id	= [dbo].[SCM_ARR_SPL_VAL](@p_origin_from_division_id,	@v_delimiter, @mst_loop_cnt) ; 
				SET @v_origin_to_division_id	= [dbo].[SCM_ARR_SPL_VAL](@p_origin_to_division_id,		@v_delimiter, @mst_loop_cnt) ; 
				SET @v_electrode_type			= [dbo].[SCM_ARR_SPL_VAL](@p_electrode_type,			@v_delimiter, @mst_loop_cnt) ; 
			END
			;

			INSERT INTO #TblDynamic_SCM0002_ShpimentPlanNew
			SELECT A.*, B.MEASURE
			FROM (
			SELECT @p_division_id				AS DIVISION_ID
					, @p_plan_start_yyyymmdd	AS PLAN_START_YYYYMMDD
					, @p_plan_type				AS PLAN_TYPE
					, @p_seq					AS SEQ
					, @p_operation_group		AS OPERATION_GROUP
					, @v_project_code			AS PROJECT_CODE
					, @v_item_id				AS ITEM_ID
					, @v_to_site				AS TO_SITE
					, @v_incoterms				AS INCOTERMS
					, @v_from_site				AS FROM_SITE
					, @v_bod_id					AS BOD_ID
					, @v_origin_from_division_id	AS ORIGIN_FROM_DIVISION_ID
					, @v_origin_to_division_id		AS ORIGIN_TO_DIVISION_ID
					, ISNULL(@v_electrode_type,'')	AS ELECTRODE_TYPE
				  ) A
			CROSS JOIN (SELECT 'SHIP_REQ' AS MEASURE
						UNION 
						SELECT 'SHIP_PLAN' AS MEASURE
						UNION 
						SELECT 'SHIP_PLAN_AMEND' AS MEASURE) B
		;

		END

		------------------------------------------------------------------------------------------------------------------------------------------------------- 
		--### Start : [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : ESS 가상 사이트에 매핑된 JV 사이트 계획 추가  
		-- SEMI인 경우만 추가
		------------------------------------------------------------------------------------------------------------------------------------------------------- 
		INSERT INTO #TblDynamic_SCM0002_ShpimentPlanNew 
		SELECT
			 SM.RP_DIVISION_ID		AS DIVISION_ID				
			,TG.PLAN_START_YYYYMMDD		
			,PV.PLAN_TYPE			AS PLAN_TYPE					
			,PV.PLAN_SEQ			AS SEQ						
			,TG.OPERATION_GROUP			
			,TG.PROJECT_CODE				
			,TG.ITEM_ID					
			,TG.TO_SITE					
			,TG.INCOTERMS					
			,SM.RP_SCM_SITE_ID							AS FROM_SITE					
			,ISNULL(ISNULL(BI.BOD_ID, TG.BOD_ID), '-')	AS BOD_ID	-- 2025.12.23 bod_id 매핑이 안되는 경우 ESS가상 사이트 기준 BOD_ID 유지						
			,SM.RP_DIVISION_ID		AS ORIGIN_FROM_DIVISION_ID	
			,SM.RP_DIVISION_ID		AS ORIGIN_TO_DIVISION_ID		-- 2025.12.16 division_id와 같은 값으로
			,TG.ELECTRODE_TYPE				
			,TG.MEASURE					
		 FROM #TblDynamic_SCM0002_ShpimentPlanNew TG 
			  INNER JOIN #JV_ESS_SCM_SITE_MAP SM
					  ON SM.VP_DIVISION_ID	= TG.DIVISION_ID

					 AND SM.VP_SCM_SITE_ID	= TG.FROM_SITE
			  INNER JOIN #DIVISION_LAST_PLAN_INFO PV
					  ON PV.DIVISION_ID			= SM.RP_DIVISION_ID
					 AND PV.PLAN_START_YYYYMMDD	= TG.PLAN_START_YYYYMMDD
			  LEFT  JOIN #BOD_ITEM BI
					  ON BI.DIVISION_ID		= SM.RP_DIVISION_ID
					 AND BI.FROM_SITE		= SM.RP_SCM_SITE_ID
					 AND BI.TO_SITE			= TG.TO_SITE			
					 AND BI.INCOTERMS		= TG.INCOTERMS
					 AND BI.ITEM_ID			= TG.ITEM_ID 
		WHERE 1=1
		  AND @p_prgram_id != 'FG'  -- FG 제외 
		------------------------------------------------------------------------------------------------------------------------------------------------------- 
		--### End : [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : ESS 가상 사이트에 매핑된 JV 사이트 계획 추가
		------------------------------------------------------------------------------------------------------------------------------------------------------- 

		/*** 2. 기존 Plan에 입력되있는 MEASURE 선별 삭제 *****/
		IF(@p_prgram_id='FG')
			BEGIN
				INSERT INTO #TblDynamic_SCM0002_ShpimentPlan
				SELECT DISTINCT DIVISION_ID
								, PLAN_START_YYYYMMDD
								, PLAN_TYPE
								, SEQ
								, BIZ_TYPE AS OPERATION_GROUP
								, PROJECT_CODE
								, ITEM_ID
								, TO_SITE
								, INCOTERMS
								, FROM_SITE
								, BOD_ID
								, MEASURE
				FROM SCP_ANL_SHIPMENT_PLAN_FG WITH(NOLOCK)
				WHERE DIVISION_ID = @p_division_id
				AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
				AND PLAN_TYPE = @p_plan_type
				AND SEQ = @p_seq
				AND BIZ_TYPE = @p_operation_group
				AND MEASURE IN ('SHIP_REQ', 'SHIP_PLAN', 'SHIP_PLAN_AMEND')
				AND YYYYMMDD = @p_plan_start_yyyymmdd
				;
		
				DELETE A
				FROM #TblDynamic_SCM0002_ShpimentPlanNew A
				JOIN #TblDynamic_SCM0002_ShpimentPlan B ON A.PROJECT_CODE = B.PROJECT_CODE
														AND A.ITEM_ID = B.ITEM_ID
														AND A.TO_SITE = B.TO_SITE
														AND A.INCOTERMS = B.INCOTERMS
														AND A.FROM_SITE = B.FROM_SITE
														AND A.BOD_ID = B.BOD_ID
														AND A.MEASURE = B.MEASURE
				;
		

			END
		ELSE
			BEGIN
				/* 
				-- 2025.11.13 [PJ2025F254] 변경전 쿼리 Start -------------------------- 
				-- PJ2025F254 변경전  INSERT INTO #TblDynamic_SCM0002_ShpimentPlan
				-- PJ2025F254 변경전  SELECT DISTINCT DIVISION_ID
				-- PJ2025F254 변경전  				, PLAN_START_YYYYMMDD
				-- PJ2025F254 변경전  				, PLAN_TYPE
				-- PJ2025F254 변경전  				, SEQ
				-- PJ2025F254 변경전  				, OPERATION_GROUP
				-- PJ2025F254 변경전  				, '-' PROJECT_CODE
				-- PJ2025F254 변경전  				, ITEM_ID
				-- PJ2025F254 변경전  				, '-' TO_SITE
				-- PJ2025F254 변경전  				, '-' INCOTERMS
				-- PJ2025F254 변경전  				, FROM_SITE
				-- PJ2025F254 변경전  				, BOD_ID
				-- PJ2025F254 변경전  				, MEASURE
				-- PJ2025F254 변경전  FROM SCP_ANL_SHIPMENT_PLAN_SEMI WITH(NOLOCK)
				-- PJ2025F254 변경전  WHERE DIVISION_ID = @p_division_id
				-- PJ2025F254 변경전  AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
				-- PJ2025F254 변경전  AND PLAN_TYPE = @p_plan_type
				-- PJ2025F254 변경전  AND SEQ = @p_seq
				-- PJ2025F254 변경전  AND OPERATION_GROUP = @p_operation_group
				-- PJ2025F254 변경전  AND MEASURE IN ('SHIP_REQ', 'SHIP_PLAN', 'SHIP_PLAN_AMEND')
				-- PJ2025F254 변경전  AND YYYYMMDD = @p_plan_start_yyyymmdd
				-- PJ2025F254 변경전  ;
				-- PJ2025F254 변경전  
				-- PJ2025F254 변경전  DELETE A
				-- PJ2025F254 변경전  FROM #TblDynamic_SCM0002_ShpimentPlanNew A
				-- PJ2025F254 변경전  JOIN #TblDynamic_SCM0002_ShpimentPlan B ON A.ITEM_ID = B.ITEM_ID
				-- PJ2025F254 변경전  										AND A.FROM_SITE = B.FROM_SITE
				-- PJ2025F254 변경전  										AND A.BOD_ID = B.BOD_ID
				-- PJ2025F254 변경전  										AND A.MEASURE = B.MEASURE
				-- PJ2025F254 변경전  ;
				-- 2025.11.13 [PJ2025F254] 변경전 쿼리 End -------------------------- 
				*/

				------------------------------------------------------------------------------------------------------------------------------------------------------- 
				--### Start : [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : 기 등록된 데이터 처리 대상에서 삭제 
				------------------------------------------------------------------------------------------------------------------------------------------------------- 
				DELETE NW 
				 FROM #TblDynamic_SCM0002_ShpimentPlanNew NW  
					  INNER JOIN SCP_ANL_SHIPMENT_PLAN_SEMI TG WITH(NOLOCK)  -- DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP, ITEM_ID, FROM_SITE, BOD_ID, MEASURE, YYYYMMDD	 
							  ON TG.DIVISION_ID = NW.DIVISION_ID
							 AND TG.PLAN_START_YYYYMMDD	= NW.PLAN_START_YYYYMMDD
							 AND TG.PLAN_TYPE			= NW.PLAN_TYPE
							 AND TG.SEQ					= NW.SEQ
							 AND TG.OPERATION_GROUP		= NW.OPERATION_GROUP
							 AND TG.ITEM_ID				= NW.ITEM_ID
							 AND TG.FROM_SITE			= NW.FROM_SITE
							 AND TG.BOD_ID				= NW.BOD_ID
							 AND TG.MEASURE				= NW.MEASURE
				WHERE 1=1;
				------------------------------------------------------------------------------------------------------------------------------------------------------- 
				--### End : [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : 기 등록된 데이터 처리 대상에서 삭제 
				------------------------------------------------------------------------------------------------------------------------------------------------------- 

			END
	
		/*** 3. Shipment Plan FG/SEMI 입력 *****/
		SET @d_event_date = SYSDATETIME();

		IF(@p_prgram_id='FG')
			BEGIN
			
				-- 본 테이블 입력
				INSERT INTO SCP_ANL_SHIPMENT_PLAN_FG
				(DIVISION_ID,				PLAN_START_YYYYMMDD,	PLAN_TYPE,		SEQ,			BIZ_TYPE
				 ,PROJECT_CODE,				ITEM_ID,				TO_SITE,		INCOTERMS,		FROM_SITE
				 ,BOD_ID,					MEASURE,				YYYYMMDD,		QTY,			ORIGIN_FROM_DIVISION_ID
				 ,ORIGIN_TO_DIVISION_ID,	ELECTRODE_TYPE,			CREATED_BY,		CREATION_DATE,	LAST_UPDATED_BY
				 ,LAST_UPDATE_DATE)
				SELECT A.DIVISION_ID
					   , A.PLAN_START_YYYYMMDD
					   , A.PLAN_TYPE
					   , A.SEQ
					   , A.OPERATION_GROUP AS BIZ_TYPE
					   , A.PROJECT_CODE
					   , A.ITEM_ID
					   , A.TO_SITE
					   , A.INCOTERMS
					   , A.FROM_SITE
					   , A.BOD_ID
					   , A.MEASURE
					   , B.basis_yyyymmdd AS YYYYMMDD
					   , 0 AS QTY
					   , A.ORIGIN_FROM_DIVISION_ID
					   , A.ORIGIN_TO_DIVISION_ID
					   , A.ELECTRODE_TYPE
					   , @p_user_id
					   , @d_event_date
					   , @p_user_id
					   , @d_event_date
				FROM #TblDynamic_SCM0002_ShpimentPlanNew A
				CROSS JOIN (SELECT basis_yyyymmdd			
							FROM scm_sys_calendar_m WITH(NOLOCK)			
							WHERE basis_yyyymmdd  >= @p_plan_start_yyyymmdd			
							AND basis_yyyymmdd  <  @p_plan_end_yyyymmdd	) B
				;

				-- History 입력
				INSERT INTO SCP_ANL_SHIPMENT_PLAN_FG_H
				(HISTORY_SEQ,				DIVISION_ID,			PLAN_START_YYYYMMDD,	PLAN_TYPE,		SEQ
				 ,BIZ_TYPE,					PROJECT_CODE,			ITEM_ID,				TO_SITE,		INCOTERMS
				 ,FROM_SITE,				BOD_ID,					MEASURE,				YYYYMMDD,		QTY
				 ,ORIGIN_FROM_DIVISION_ID,	ORIGIN_TO_DIVISION_ID,	ELECTRODE_TYPE,			CREATED_BY,		CREATION_DATE
				 ,LAST_UPDATED_BY,			LAST_UPDATE_DATE,		HISTORY_CREATION_DATE)
				SELECT (NEXT VALUE FOR SEQ1_SCP_ANL_SHIPMENT_PLAN_FG_H)
					   , A.DIVISION_ID
					   , A.PLAN_START_YYYYMMDD
					   , A.PLAN_TYPE
					   , A.SEQ
					   , A.OPERATION_GROUP AS BIZ_TYPE
					   , A.PROJECT_CODE
					   , A.ITEM_ID
					   , A.TO_SITE
					   , A.INCOTERMS
					   , A.FROM_SITE
					   , A.BOD_ID
					   , A.MEASURE
					   , B.basis_yyyymmdd AS YYYYMMDD
					   , 0 AS QTY
					   , A.ORIGIN_FROM_DIVISION_ID
					   , A.ORIGIN_TO_DIVISION_ID
					   , A.ELECTRODE_TYPE
					   , @p_user_id
					   , @d_event_date
					   , @p_user_id
					   , @d_event_date
					   , @d_event_date
				FROM #TblDynamic_SCM0002_ShpimentPlanNew A
				CROSS JOIN (SELECT basis_yyyymmdd			
							FROM scm_sys_calendar_m WITH(NOLOCK)			
							WHERE basis_yyyymmdd  >= @p_plan_start_yyyymmdd			
							AND basis_yyyymmdd  <  @p_plan_end_yyyymmdd	) B
				;

			END
		ELSE
			BEGIN

				-- 본 테이블 입력
				INSERT INTO SCP_ANL_SHIPMENT_PLAN_SEMI
				(DIVISION_ID,	PLAN_START_YYYYMMDD,	PLAN_TYPE,					SEQ,					OPERATION_GROUP
				 ,ITEM_ID,		FROM_SITE,				BOD_ID,						MEASURE,				YYYYMMDD
				 ,TO_SITE,		QTY,					ORIGIN_FROM_DIVISION_ID,	ORIGIN_TO_DIVISION_ID,	ELECTRODE_TYPE
				 ,CREATED_BY,	CREATION_DATE,			LAST_UPDATED_BY,			LAST_UPDATE_DATE)
				SELECT A.DIVISION_ID
					   , A.PLAN_START_YYYYMMDD
					   , A.PLAN_TYPE
					   , A.SEQ
					   , A.OPERATION_GROUP
					   , A.ITEM_ID
					   , A.FROM_SITE
					   , A.BOD_ID
					   , A.MEASURE
					   , B.basis_yyyymmdd AS YYYYMMDD
					   , A.TO_SITE
					   , 0 AS QTY
					   , A.ORIGIN_FROM_DIVISION_ID
					   , A.ORIGIN_TO_DIVISION_ID
					   , A.ELECTRODE_TYPE
					   , @p_user_id
					   , @d_event_date
					   , @p_user_id
					   , @d_event_date
				FROM #TblDynamic_SCM0002_ShpimentPlanNew A
				CROSS JOIN (SELECT basis_yyyymmdd			
							FROM scm_sys_calendar_m WITH(NOLOCK)			
							WHERE basis_yyyymmdd  >= @p_plan_start_yyyymmdd			
							AND basis_yyyymmdd  <  @p_plan_end_yyyymmdd	) B
				;

				-- History 입력
				INSERT INTO SCP_ANL_SHIPMENT_PLAN_SEMI_H
				(HISTORY_SEQ,					DIVISION_ID,	PLAN_START_YYYYMMDD,	PLAN_TYPE,					SEQ
				 ,OPERATION_GROUP,				ITEM_ID,		FROM_SITE,				TO_SITE,					BOD_ID
				 ,MEASURE,						YYYYMMDD,		QTY,					ORIGIN_FROM_DIVISION_ID,	ORIGIN_TO_DIVISION_ID
				 ,ELECTRODE_TYPE,				CREATED_BY,		CREATION_DATE,			LAST_UPDATED_BY,			LAST_UPDATE_DATE
				 ,HISTORY_CREATION_DATE)
				SELECT (NEXT VALUE FOR SEQ1_SCP_ANL_SHIPMENT_PLAN_SEMI_H)
					   , A.DIVISION_ID
					   , A.PLAN_START_YYYYMMDD
					   , A.PLAN_TYPE
					   , A.SEQ
					   , A.OPERATION_GROUP
					   , A.ITEM_ID
					   , A.FROM_SITE
					   , A.TO_SITE
					   , A.BOD_ID
					   , A.MEASURE
					   , B.basis_yyyymmdd AS YYYYMMDD
					   , 0 AS QTY
					   , A.ORIGIN_FROM_DIVISION_ID
					   , A.ORIGIN_TO_DIVISION_ID
					   , A.ELECTRODE_TYPE
					   , @p_user_id
					   , @d_event_date
					   , @p_user_id
					   , @d_event_date
					   , @d_event_date
				FROM #TblDynamic_SCM0002_ShpimentPlanNew A
				CROSS JOIN (SELECT basis_yyyymmdd			
							FROM scm_sys_calendar_m WITH(NOLOCK)			
							WHERE basis_yyyymmdd  >= @p_plan_start_yyyymmdd			
							AND basis_yyyymmdd  <  @p_plan_end_yyyymmdd	) B
				;
			END


		SELECT 'S' AS RESULT_CODE, '' AS MSG

		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	END TRY

	BEGIN CATCH
			BEGIN
			INSERT INTO scm_sys_log_batch (program_name
											,log_type
											,log_count
											,log_message
											,description
											,event_date
											,creation_date
											,created_by
											,last_update_date
											,last_updated_by)
			VALUES (ERROR_PROCEDURE()
					,'ERROR'
					,NULL
					,ERROR_MESSAGE()
					,NULL
					,SYSDATETIME()
					,SYSDATETIME()
					,ERROR_PROCEDURE()
					,SYSDATETIME()
					,ERROR_PROCEDURE());

			IF @@TRANCOUNT > 0
				COMMIT WORK;
			END;

			-- error코드, errror 메시지 반환
			SELECT 'F' AS result_code, '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE() AS ERR_MESSAGE ;
			--SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
		END CATCH;



	IF OBJECT_ID('tempdb..#TblDynamic_SCM0002_ShpimentPlanNew') IS NOT NULL
	DROP TABLE #TblDynamic_SCM0002_ShpimentPlanNew;    

	IF OBJECT_ID('tempdb..#TblDynamic_SCM0002_ShpimentPlan') IS NOT NULL
	DROP TABLE #TblDynamic_SCM0002_ShpimentPlan;  

	IF OBJECT_ID('TEMPDB..#JV_ESS_SCM_SITE_MAP')		IS NOT NULL DROP TABLE #JV_ESS_SCM_SITE_MAP			-- [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : 임시테이블 정리
	IF OBJECT_ID('TEMPDB..#DIVISION_LAST_PLAN_INFO')	IS NOT NULL DROP TABLE #DIVISION_LAST_PLAN_INFO;	-- [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : 임시테이블 정리
	IF OBJECT_ID('TEMPDB..#BOD_ITEM')					IS NOT NULL DROP TABLE #BOD_ITEM					-- [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : 임시테이블 정리

END









