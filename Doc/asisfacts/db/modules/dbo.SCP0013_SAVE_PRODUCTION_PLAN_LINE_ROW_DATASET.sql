


/*
 * Program ID   : [SCP0013_SAVE_PRODUCTION_PLAN_LINE_ROW_DATASET]
 * Description  : Production Plan의 Line "Prod. Plan(Amend)" Measure저장(Type Table 저장방식)
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2019/01/22	YHW				Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2019/02/21	YHW				[CSR ID:3929450] Supply(Plan Line, FG, SEMI) 수정 시 Fix 데이터 저장로직 개선
 * 2019/06/07	YHW				[CSR ID:4010290] SCP UI 생산/출하 계획 저장속도 개선
 * 2020/02/18	hwyoon			OUTPUT 수량 0 삭제 후 처리로직 추가
 * 2021/10/20   KMJ			    PJ2020964 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - UI 속도 개선으로 대응, 주 SUM 대응
 * 2022/04/29   chaan			81_UC, EE_UC 추가로 DIVSION 크기 확장
 * 2025/11/11   hrkim			[PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 
 *									- ESS 가상 라인 계획으로 매핑된 JV 라인 계획 동기화 저장 (ESS 가상 -> JV Real 단방향 저장) 
 *									- @SCP0013 파라미터를 @SCP0013_WITH_JV_LINE로 대체 생성 사용
 */
CREATE PROCEDURE [dbo].[SCP0013_SAVE_PRODUCTION_PLAN_LINE_ROW_DATASET]
	 @SCP0013			AS DBO.SCP0013       READONLY
AS

BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

	--DECLARE @v_created_by       NVARCHAR(MAX)='hwwoonins';
	--DECLARE @v_creation_date    datetime =SYSDATETIME(); 
	--DECLARE @v_last_updated_by  NVARCHAR(MAX)='hwwoonins';
	
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0013_SAVE_PRODUCTION_PLAN_LINE_ROW_DATASET';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;


	--DECLARE @v_data_dup_cnt  INT=0;
	
	-- 예외처리 변수 설정
	DECLARE @v_err_code  INTEGER;
	DECLARE @v_err_message  NVARCHAR(4000)='';
	
	-- 트렌젝션 시작
	BEGIN TRAN;


          -- 실행시간 확인용    
    DECLARE @v_start_time   DATETIME     = SYSDATETIME();    
    DECLARE @v_exec_time    NVARCHAR(10) = ''--'00:00';    

	-- BUCKET 확인
	DECLARE @v_bucket_type NVARCHAR(10) = '';
	DECLARE @v_from_yyyymmdd NVARCHAR(8) = '';
	DECLARE @v_to_yyyymmdd NVARCHAR(8) = '';

	DECLARE @SCP0013_WITH_JV_LINE	AS DBO.SCP0013;	-- [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : @SCP0013 + ESS 가상 라인에 매핑된 JV 라인 정보 

	BEGIN TRY

		-- 시작 LOG
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();

		EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		IF OBJECT_ID('tempdb..#TblDynamic_SCP0013_TEMP') IS NOT NULL	
			DROP TABLE #TblDynamic_SCP0013_TEMP;
		IF OBJECT_ID('tempdb..#TblDynamic_SCP0013') IS NOT NULL	
			DROP TABLE #TblDynamic_SCP0013;

			CREATE TABLE #TblDynamic_SCP0013 (				
				A						NVARCHAR(1)
				, P_ACTIVE_FLAG			NVARCHAR(1)
--chaan				, P_DIVISION_ID			NVARCHAR(2)
				, P_DIVISION_ID			NVARCHAR(30)--chaan
				, P_PLAN_START_YYYYMMDD	NVARCHAR(8)
				, P_PLAN_TYPE			NVARCHAR(2)
				, P_SEQ					NVARCHAR(10)
				, P_OPERATION_GROUP		NVARCHAR(1)
				, P_SCM_SITE_ID			NVARCHAR(100)
				, P_ITEM_ID				NVARCHAR(100)
				, P_LINE_ID				NVARCHAR(50)
				, P_OPERATION_ID		NVARCHAR(100)
				, P_MEASURE				NVARCHAR(100)
				, P_YYYYMMDD			NVARCHAR(8)
				, P_QTY					NVARCHAR(200)
				, P_USER_ID				NVARCHAR(100)
				, P_FIX					NVARCHAR(1)
				, P_LOC_FLAG			NVARCHAR(1)
				, P_PROGRAM_ID			NVARCHAR(200)
--chaan				, P_ORIGIN_DIVISION_ID	NVARCHAR(2)
				, P_ORIGIN_DIVISION_ID	NVARCHAR(30)--chaan
				, P_ELECTRODE_TYPE		NVARCHAR(50)
				, P_BUCKET_TYPE			NVARCHAR(10)
			);

		------------------------------------------------------------------------------------------------------------------------------------------------------- 
		--### Start : [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : ESS 가상 라인 계획으로 매핑된 JV 라인 계획 동기화 저장 (ESS 가상 -> JV Real 단방향 저장) 
		------------------------------------------------------------------------------------------------------------  
		print  convert(varchar(30), getdate(), 121) + N' JV/ESS 라인 및 scm site 매핑 정보 추출' 
		-------------------------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID('TEMPDB..#JV_ESS_LINE_MAP')		IS NOT NULL DROP TABLE #JV_ESS_LINE_MAP
		IF OBJECT_ID('TEMPDB..#JV_ESS_SCM_SITE_MAP')	IS NOT NULL DROP TABLE #JV_ESS_SCM_SITE_MAP
		SELECT VL_COMPANY_ID
			  ,VL_DIVISION_ID
			  ,VL_SITE_ID
			  ,VL_PLANT_ID
			  ,VL_FACTORY_ID
			  ,VL_LINE_ID
			  ,RL_COMPANY_ID
			  ,RL_DIVISION_ID
			  ,RL_SITE_ID
			  ,RL_PLANT_ID
			  ,RL_FACTORY_ID
			  ,RL_LINE_ID
		 INTO #JV_ESS_LINE_MAP
		 FROM FN_GET_JV_REAL_ESS_VIRTUAL_LINE_MAP() 

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
		------------------------------------------------------------------------------------------------------------  
		print  convert(varchar(30), getdate(), 121) + N' 파라미터로 받은 값 ' 
		------------------------------------------------------------------------------------------------------------  
		-- 파라미터로 받은 값에서 ESS 가상 라인에 매핑된 JV 라인은 제외함 (단방향 수정 : ESS 가상 -> JV Real 라인)
		------------------------------------------------------------------------------------------------------------  
		INSERT INTO @SCP0013_WITH_JV_LINE (
				A
			   ,P_ACTIVE_FLAG
			   ,P_DIVISION_ID
			   ,P_PLAN_START_YYYYMMDD
			   ,P_PLAN_TYPE
			   ,P_SEQ
			   ,P_OPERATION_GROUP
			   ,P_SCM_SITE_ID
			   ,P_ITEM_ID
			   ,P_LINE_ID
			   ,P_OPERATION_ID
			   ,P_MEASURE
			   ,P_YYYYMMDD
			   ,P_QTY
			   ,P_FIX_REASON
			   ,P_USER_ID
			   ,P_FIX
			   ,P_LOC_FLAG
			   ,P_PROGRAM_ID
			   ,DEBUG_MODE
			   ,P_ORIGIN_DIVISION_ID
			   ,P_ELECTRODE_TYPE
			   ,P_BUCKET_TYPE
			   ,P_FROM_YYYYMMDD
			   ,P_TO_YYYYMMDD )
		SELECT  PR.A
			   ,PR.P_ACTIVE_FLAG
			   ,PR.P_DIVISION_ID
			   ,PR.P_PLAN_START_YYYYMMDD
			   ,PR.P_PLAN_TYPE
			   ,PR.P_SEQ
			   ,PR.P_OPERATION_GROUP
			   ,PR.P_SCM_SITE_ID
			   ,PR.P_ITEM_ID
			   ,PR.P_LINE_ID
			   ,PR.P_OPERATION_ID
			   ,PR.P_MEASURE
			   ,PR.P_YYYYMMDD
			   ,PR.P_QTY
			   ,PR.P_FIX_REASON
			   ,PR.P_USER_ID
			   ,PR.P_FIX
			   ,PR.P_LOC_FLAG
			   ,PR.P_PROGRAM_ID
			   ,PR.DEBUG_MODE
			   ,PR.P_ORIGIN_DIVISION_ID
			   ,PR.P_ELECTRODE_TYPE
			   ,PR.P_BUCKET_TYPE
			   ,PR.P_FROM_YYYYMMDD
			   ,PR.P_TO_YYYYMMDD
		 FROM @SCP0013 PR 
			  LEFT  JOIN #JV_ESS_SCM_SITE_MAP SM 
					  ON SM.RP_DIVISION_ID = PR.P_DIVISION_ID
					 AND SM.RP_SCM_SITE_ID	= PR.P_SCM_SITE_ID
			  LEFT  JOIN #JV_ESS_LINE_MAP LM
					  ON LM.RL_DIVISION_ID	= PR.P_DIVISION_ID
					 AND LM.RL_LINE_ID		= PR.P_LINE_ID 
					 AND LM.RL_COMPANY_ID	= SM.RP_COMPANY_ID
					 AND LM.RL_DIVISION_ID	= SM.RP_DIVISION_ID
					 AND LM.RL_SITE_ID		= SM.RP_SITE_ID
					 AND LM.RL_PLANT_ID		= SM.RP_PLANT_ID
		WHERE 1=1
		  AND LM.RL_DIVISION_ID IS NULL	-- ESS 가상 line에 매핑된 JV Real Line은 제외  (단방향 수정 ESS가상 -> JV) 

		------------------------------------------------------------------------------------------------------------  
		print  convert(varchar(30), getdate(), 121) + N'  ESS 가상 line에 매핑된 JV Real Line 정보 추가' 
		------------------------------------------------------------------------------------------------------------  
		INSERT INTO @SCP0013_WITH_JV_LINE (
				A
			   ,P_ACTIVE_FLAG
			   ,P_DIVISION_ID
			   ,P_PLAN_START_YYYYMMDD
			   ,P_PLAN_TYPE
			   ,P_SEQ
			   ,P_OPERATION_GROUP
			   ,P_SCM_SITE_ID
			   ,P_ITEM_ID
			   ,P_LINE_ID
			   ,P_OPERATION_ID
			   ,P_MEASURE
			   ,P_YYYYMMDD
			   ,P_QTY
			   ,P_FIX_REASON
			   ,P_USER_ID
			   ,P_FIX
			   ,P_LOC_FLAG
			   ,P_PROGRAM_ID
			   ,DEBUG_MODE
			   ,P_ORIGIN_DIVISION_ID
			   ,P_ELECTRODE_TYPE
			   ,P_BUCKET_TYPE
			   ,P_FROM_YYYYMMDD
			   ,P_TO_YYYYMMDD )
		SELECT  PR.A
			   ,PR.P_ACTIVE_FLAG
			   ,LM.RL_DIVISION_ID			AS P_DIVISION_ID
			   ,PR.P_PLAN_START_YYYYMMDD
			   ,PV.PLAN_TYPE				AS P_PLAN_TYPE
			   ,PV.PLAN_SEQ					AS P_SEQ
			   ,PR.P_OPERATION_GROUP
			   ,SM.RP_SCM_SITE_ID			AS P_SCM_SITE_ID
			   ,PR.P_ITEM_ID
			   ,LM.RL_LINE_ID				AS P_LINE_ID
			   ,PR.P_OPERATION_ID
			   ,PR.P_MEASURE
			   ,PR.P_YYYYMMDD
			   ,PR.P_QTY
			   ,PR.P_FIX_REASON
			   ,PR.P_USER_ID
			   ,PR.P_FIX
			   ,PR.P_LOC_FLAG
			   ,PR.P_PROGRAM_ID
			   ,PR.DEBUG_MODE
			   ,LM.RL_DIVISION_ID			AS P_ORIGIN_DIVISION_ID
			   ,PR.P_ELECTRODE_TYPE
			   ,PR.P_BUCKET_TYPE
			   ,PR.P_FROM_YYYYMMDD
			   ,PR.P_TO_YYYYMMDD
		 FROM @SCP0013 PR 
			  INNER JOIN #JV_ESS_SCM_SITE_MAP SM 
					  ON SM.VP_DIVISION_ID	= PR.P_DIVISION_ID
					 AND SM.VP_SCM_SITE_ID	= PR.P_SCM_SITE_ID
			  INNER JOIN #JV_ESS_LINE_MAP LM
					  ON LM.VL_DIVISION_ID	    = PR.P_DIVISION_ID
					 AND LM.VL_LINE_ID			= PR.P_LINE_ID 
					 AND LM.VL_COMPANY_ID		= SM.VP_COMPANY_ID
					 AND LM.VL_DIVISION_ID		= SM.VP_DIVISION_ID
					 AND LM.VL_SITE_ID			= SM.VP_SITE_ID
					 AND LM.VL_PLANT_ID			= SM.VP_PLANT_ID
			  INNER JOIN #DIVISION_LAST_PLAN_INFO PV
					  ON PV.DIVISION_ID			= LM.RL_DIVISION_ID
					 AND PV.PLAN_START_YYYYMMDD	= PR.P_PLAN_START_YYYYMMDD
		WHERE 1=1
		------------------------------------------------------------------------------------------------------------------------------ 
		--### End : [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : ESS 가상 라인 계획으로 매핑된 JV 라인 계획 동기화 저장 (ESS 가상 -> JV Real 단방향 저장) 
		------------------------------------------------------------------------------------------------------------------------------

		-- BUCKET TYPE에 따라 분기
		SELECT DISTINCT
			@v_from_yyyymmdd = P_FROM_YYYYMMDD
			, @v_to_yyyymmdd = P_TO_YYYYMMDD
			, @v_bucket_type = P_BUCKET_TYPE
		FROM @SCP0013_WITH_JV_LINE	--  [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : @SCP0013를 @SCP0013_WITH_JV_LINE로 대체
		;

		IF @v_bucket_type = 'WEEKLY'
		BEGIN

			-- 주 SUM QTY -> DAY QTY 변환
			WITH BB AS (

				SELECT
					BASIS_YYYYMM + ISO_WEEK AS WEEK_NAME
					, COUNT(BASIS_YYYYMM) AS DAY_CNT
				FROM SCM_SYS_CALENDAR_M A WITH(NOLOCK)	
				WHERE (BASIS_YYYYMM + ISO_WEEK) IN (
					SELECT P_YYYYMMDD FROM @SCP0013_WITH_JV_LINE	--  [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : @SCP0013를 @SCP0013_WITH_JV_LINE로 대체
				)
				AND BASIS_YYYYMMDD BETWEEN @v_from_yyyymmdd AND @v_to_yyyymmdd
				GROUP BY BASIS_YYYYMM, ISO_WEEK

			),
			CC AS (

				SELECT
					P_DIVISION_ID			
					, P_PLAN_START_YYYYMMDD	
					, P_PLAN_TYPE			
					, P_SEQ					
					, P_OPERATION_GROUP		
					, P_SCM_SITE_ID			
					, P_ITEM_ID				
					, P_LINE_ID				
					, P_OPERATION_ID		
					, P_MEASURE				
					, P_YYYYMMDD AS WEEK_NAME
					, (A.P_QTY / B.DAY_CNT) AS DAY_QTY
					, (A.P_QTY % B.DAY_CNT) AS DAY_EX
				FROM @SCP0013_WITH_JV_LINE	A --  [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : @SCP0013를 @SCP0013_WITH_JV_LINE로 대체
				JOIN BB B
				ON A.P_YYYYMMDD = B.WEEK_NAME

			),
			DD AS (

				SELECT
					BASIS_YYYYMM + ISO_WEEK AS WEEK_NAME
					, BASIS_YYYYMMDD AS DAY_NAME
					, RANK() OVER (PARTITION BY BASIS_YYYYMM + ISO_WEEK ORDER BY BASIS_YYYYMMDD) AS DAY_CNT
				FROM SCM_SYS_CALENDAR_M A WITH(NOLOCK)	
				WHERE (BASIS_YYYYMM + ISO_WEEK) IN (
					SELECT P_YYYYMMDD FROM @SCP0013_WITH_JV_LINE	--  [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : @SCP0013를 @SCP0013_WITH_JV_LINE로 대체
				)
				AND BASIS_YYYYMMDD BETWEEN @v_from_yyyymmdd AND @v_to_yyyymmdd
				GROUP BY BASIS_YYYYMM, ISO_WEEK, BASIS_YYYYMMDD
			
			)
			SELECT
				CC.P_DIVISION_ID			
				, CC.P_PLAN_START_YYYYMMDD	
				, CC.P_PLAN_TYPE			
				, CC.P_SEQ					
				, CC.P_OPERATION_GROUP		
				, CC.P_SCM_SITE_ID			
				, CC.P_ITEM_ID				
				, CC.P_LINE_ID				
				, CC.P_OPERATION_ID		
				, CC.P_MEASURE				
				, DD.WEEK_NAME
				, DD.DAY_NAME
				, IIF(ISNULL(BB.DAY_CNT, 0)=0, CC.DAY_QTY, CC.DAY_QTY+CC.DAY_EX) AS QTY
			INTO #TblDynamic_SCP0013_TEMP
			FROM CC 
			JOIN DD ON CC.WEEK_NAME = DD.WEEK_NAME
			LEFT JOIN BB ON DD.WEEK_NAME = BB.WEEK_NAME AND DD.DAY_CNT = BB.DAY_CNT
			;

			INSERT INTO #TblDynamic_SCP0013
			SELECT DISTINCT
				A.A
				, A.P_ACTIVE_FLAG
				, A.P_DIVISION_ID
				, A.P_PLAN_START_YYYYMMDD
				, A.P_PLAN_TYPE
				, A.P_SEQ
				, A.P_OPERATION_GROUP
				, A.P_SCM_SITE_ID
				, A.P_ITEM_ID
				, A.P_LINE_ID
				, A.P_OPERATION_ID
				, A.P_MEASURE
				, B.DAY_NAME AS P_YYYYMMDD
				, B.QTY AS P_QTY
				, A.P_USER_ID
				, A.P_FIX
				, A.P_LOC_FLAG
				, A.P_PROGRAM_ID
				, A.P_ORIGIN_DIVISION_ID
				, A.P_ELECTRODE_TYPE
				, A.P_BUCKET_TYPE
			FROM @SCP0013_WITH_JV_LINE A	-- [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : @SCP0013를 @SCP0013_WITH_JV_LINE로 대체
			JOIN #TblDynamic_SCP0013_TEMP B
			ON A.P_DIVISION_ID			= B.P_DIVISION_ID
			AND A.P_PLAN_START_YYYYMMDD	= B.P_PLAN_START_YYYYMMDD	
			AND A.P_PLAN_TYPE			= B.P_PLAN_TYPE			
			AND A.P_SEQ					= B.P_SEQ					
			AND A.P_OPERATION_GROUP		= B.P_OPERATION_GROUP		
			AND A.P_SCM_SITE_ID			= B.P_SCM_SITE_ID			
			AND A.P_ITEM_ID				= B.P_ITEM_ID				
			AND A.P_LINE_ID				= B.P_LINE_ID				
			AND A.P_OPERATION_ID		= B.P_OPERATION_ID		
			AND A.P_MEASURE				= B.P_MEASURE
			AND A.P_YYYYMMDD			= B.WEEK_NAME
			;


		END
		
		ELSE	-- DAILY
		BEGIN

			INSERT INTO #TblDynamic_SCP0013
			SELECT 
				A.A
				, A.P_ACTIVE_FLAG
				, A.P_DIVISION_ID
				, A.P_PLAN_START_YYYYMMDD
				, A.P_PLAN_TYPE
				, A.P_SEQ
				, A.P_OPERATION_GROUP
				, A.P_SCM_SITE_ID
				, A.P_ITEM_ID
				, A.P_LINE_ID
				, A.P_OPERATION_ID
				, A.P_MEASURE
				, A.P_YYYYMMDD
				, A.P_QTY
				, A.P_USER_ID
				, A.P_FIX
				, A.P_LOC_FLAG
				, A.P_PROGRAM_ID
				, A.P_ORIGIN_DIVISION_ID
				, A.P_ELECTRODE_TYPE
				, A.P_BUCKET_TYPE
			FROM @SCP0013_WITH_JV_LINE	A -- [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : @SCP0013를 @SCP0013_WITH_JV_LINE로 대체
			;

		END
		;


		--수정
		UPDATE A
		SET A.QTY = B.p_qty
			, a.LAST_UPDATE_DATE = getdate()
			, a.LAST_UPDATED_BY = b.p_user_id
		FROM scp_anl_production_plan A, #TblDynamic_SCP0013 B
		WHERE A.DIVISION_ID        = B.p_division_id          
		AND A.PLAN_START_YYYYMMDD  = B.p_plan_start_yyyymmdd
		AND A.PLAN_TYPE            = B.p_plan_type
		AND A.SEQ                  = B.p_seq
		AND A.OPERATION_GROUP      = B.p_operation_group
		AND A.SCM_SITE_ID          = B.p_scm_site_id
		AND A.ITEM_ID              = B.p_item_id
		AND A.LINE_ID              = B.p_line_id
		AND A.OPERATION_ID         = B.p_operation_id
		AND A.MEASURE              = B.p_measure
		AND A.YYYYMMDD             = B.p_yyyymmdd
		AND ISNULL(NULLIF(A.ELECTRODE_TYPE,''),'-')  = ISNULL(NULLIF(B.p_electrode_type,''),'-')
		;


		--이력저장
		DECLARE @SCP0013_HIST	AS DBO.SCP0013;

		INSERT INTO @SCP0013_HIST
		(
			p_division_id, 
			p_plan_start_yyyymmdd, 
			p_plan_type,  
			p_seq, 
			p_operation_group,
			p_scm_site_id, 
			p_item_id, 
			p_line_id, 
			p_operation_id, 
			p_measure, 
			p_yyyymmdd, 
			p_qty, 
			p_origin_division_id, 
			p_electrode_type, 
			p_user_id
		)
		SELECT
			p_division_id, 
			p_plan_start_yyyymmdd, 
			p_plan_type,  
			p_seq, 
			p_operation_group,
			p_scm_site_id, 
			p_item_id, 
			p_line_id, 
			p_operation_id, 
			p_measure, 
			p_yyyymmdd, 
			p_qty, 
			p_origin_division_id, 
			p_electrode_type, 
			p_user_id
		FROM #TblDynamic_SCP0013
		;

		EXEC [dbo].[PR_SCP_ANL_PRODUCTION_PLAN_HIST_DATASET] @SCP0013_HIST;


		--Fix Data 수정
		UPDATE A
		SET A.QTY = B.p_qty
			, a.LAST_UPDATE_DATE = getdate()
			, a.LAST_UPDATED_BY = b.p_user_id
		FROM SCP_ANL_PRODUCTION_PLAN_FIX A, #TblDynamic_SCP0013 B
		WHERE A.DIVISION_ID          = B.p_division_id          
		AND A.OPERATION_GROUP      = B.p_operation_group
		AND A.SCM_SITE_ID          = B.p_scm_site_id
		AND A.ITEM_ID              = B.p_item_id
		AND A.LINE_ID              = B.p_line_id
		AND A.OPERATION_ID         = B.p_operation_id
		AND A.YYYYMMDD             = B.p_yyyymmdd
		AND ISNULL(NULLIF(A.ELECTRODE_TYPE,''),'-')  = ISNULL(NULLIF(B.p_electrode_type,''),'-')
		--AND B.p_fix='Y'

		--Fix 이력저장
		EXEC [dbo].[PR_SCP_ANL_PRODUCTION_PLAN_FIX_HIST_DATASET] @SCP0013_HIST;

		
		-- 임시 운영반영시에 주석처리 할것.    
		SET @v_exec_time  =  REPLICATE('0', 2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +     
							 REPLICATE('0', 2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))    

		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description  = N'[' + @v_exec_time + ']';   
		SET @d_event_date = SYSDATETIME();
		
		EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		COMMIT TRAN;			
		
		------------------------------------------------------------------------------------------------------------  
		--### Start : [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : 임시테이블 정리 
		------------------------------------------------------------------------------------------------------------  
		IF OBJECT_ID('TEMPDB..#JV_ESS_LINE_MAP')		IS NOT NULL DROP TABLE #JV_ESS_LINE_MAP
		IF OBJECT_ID('TEMPDB..#JV_ESS_SCM_SITE_MAP')	IS NOT NULL DROP TABLE #JV_ESS_SCM_SITE_MAP
		------------------------------------------------------------------------------------------------------------  
		--### End : [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : 임시테이블 정리 
		------------------------------------------------------------------------------------------------------------  

		-- 결과코드, 결과 카운트 반환
		SELECT  'S' AS result_code,  1 AS result_cnt ;

	END TRY

	BEGIN CATCH 
		BEGIN
			--if (xact_state() <> 0) ROLLBACK TRAN; --입력 데이타 롤백 처리
						
			INSERT INTO scm_sys_log_batch (program_name,log_type,log_count,log_message,description,event_date,creation_date,created_by,last_update_date,last_updated_by)
			VALUES (ERROR_PROCEDURE(),'ERROR',NULL,ERROR_MESSAGE(),NULL,SYSDATETIME(),SYSDATETIME(),ERROR_PROCEDURE(),SYSDATETIME(),ERROR_PROCEDURE());

			--IF @@TRANCOUNT > 0
			--  COMMIT WORK;
					  

			-- error코드, errror 메시지 반환
			--SELECT 'F' AS result_code;

			IF( @v_err_code IS NULL OR @v_err_code ='')
				SET @v_err_code= ERROR_NUMBER() ;
			IF( @v_err_message IS NULL OR @v_err_message ='') 
				SET @v_err_message=  ERROR_MESSAGE();
						
			/* 에러 메시지, 에러 데이터  반환   */	
			SELECT  @v_err_code			AS err_code
				   ,@v_err_message		AS err_message
				     
			; 
		END;
	END CATCH;
END




