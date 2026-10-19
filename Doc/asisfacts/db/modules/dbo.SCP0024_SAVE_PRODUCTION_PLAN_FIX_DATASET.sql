


/*
 * Program ID   : SCP0024_SAVE_PRODUCTION_PLAN_FIX_DATASET
 * Description  : PRODUCTION_PLAN_FIX 일괄등록/수정
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2019/06/07   YHW				[CSR ID:4010290] SCP UI 생산/출하 계획 저장속도 개선
 * 2021/10/20   KMJ				[PJ20209642] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - 속도 개선을 위한 변경
 * 2022/04/29   chaan			81_UC, EE_UC 추가로 DIVSION 크기 확장
 * 2025/11/11   hrkim			[PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 
 *									- ESS 가상 라인 계획으로 매핑된 JV 라인 계획 동기화 저장 (ESS 가상 -> JV Real 단방향 저장) 
 *
 */
CREATE PROCEDURE [dbo].[SCP0024_SAVE_PRODUCTION_PLAN_FIX_DATASET]
	 @SCP0013			AS DBO.SCP0013       READONLY
AS

BEGIN

	SET NOCOUNT ON;

	DECLARE @max_loop_cnt		NVARCHAR(50);

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0024_SAVE_PRODUCTION_PLAN_FIX_DATASET';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	-- 실행시간 확인용    
    DECLARE @v_start_time   DATETIME     = SYSDATETIME();    
    DECLARE @v_exec_time    NVARCHAR(10) = ''--'00:00';   

	/********************************************************************************
	* 임시테이블만들기
	********************************************************************************/
	IF OBJECT_ID('tempdb..#TblDynamic_SCP0013Fix') IS NOT NULL	
		DROP TABLE #TblDynamic_SCP0013Fix
	;

	CREATE TABLE #TblDynamic_SCP0013Fix (
		p_active_flag			nvarchar(1),
        p_division_id           NVARCHAR(30),
		p_plan_start_yyyymmdd	nvarchar(8),	-- 2021.10.18 : 주차 fix 를 위한 컬럼 추가
		p_plan_type				nvarchar(2),	-- 2021.10.18 : 주차 fix 를 위한 컬럼 추가
		p_seq					nvarchar(10),	-- 2021.10.18 : 주차 fix 를 위한 컬럼 추가
		p_operation_group		nvarchar(1),
		p_scm_site_id			nvarchar(100),
		p_item_id				nvarchar(100),
		p_line_id				nvarchar(50),
		p_operation_id			nvarchar(100),
		p_measure				nvarchar(50),
		p_yyyymmdd				nvarchar(8),
		p_qty					nvarchar(200),
		p_fix_reason			nvarchar(100),
		p_origin_division_id	nvarchar(30),
		p_electrode_type		nvarchar(50),
		p_user_id				nvarchar(100),
		p_bucket_type			nvarchar(10),
		FIX_ID					nvarchar(20)
	);

	BEGIN TRY
			-- 시작 LOG
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		/* 2025.11.11 PJ2025F254 변경전 쿼리 - Begin 
		-- PJ2025F254 변경전 INSERT INTO #TblDynamic_SCP0013Fix
		-- PJ2025F254 변경전 SELECT p_active_flag,
		-- PJ2025F254 변경전 		p_division_id,
		-- PJ2025F254 변경전 		p_plan_start_yyyymmdd,	-- 2021.10.18 : 주차 fix 를 위한 컬럼 추가
		-- PJ2025F254 변경전 		p_plan_type,			-- 2021.10.18 : 주차 fix 를 위한 컬럼 추가
		-- PJ2025F254 변경전 		p_seq,					-- 2021.10.18 : 주차 fix 를 위한 컬럼 추가
		-- PJ2025F254 변경전 		p_operation_group,
		-- PJ2025F254 변경전 		p_scm_site_id,
		-- PJ2025F254 변경전 		p_item_id,
		-- PJ2025F254 변경전 		p_line_id,
		-- PJ2025F254 변경전 		p_operation_id,
		-- PJ2025F254 변경전 		p_measure,
		-- PJ2025F254 변경전 		p_yyyymmdd,
		-- PJ2025F254 변경전 		ISNULL(p_qty, 0) AS p_qty,
		-- PJ2025F254 변경전 		p_fix_reason,
		-- PJ2025F254 변경전 		p_origin_division_id,
		-- PJ2025F254 변경전 		p_electrode_type,
		-- PJ2025F254 변경전 		p_user_id,
		-- PJ2025F254 변경전 		p_bucket_type,
		-- PJ2025F254 변경전 		''
		-- PJ2025F254 변경전 FROM @SCP0013
		-- PJ2025F254 변경전 ;
		2025.11.11 PJ2025F254 변경전 쿼리 - End */

		------------------------------------------------------------------------------------------------------------------------------------------------------- 
		--### Start : [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : ESS 가상 라인 계획으로 매핑된 JV 라인 계획 동기화 저장 (ESS 가상 -> JV Real 단방향 저장) 
		-------------------------------------------------------------------------------------------------------------------------------------------------------
		print  convert(varchar(30), getdate(), 121) + N' JV/ESS 라인 및 scm site 매핑 정보 추출' 
		------------------------------------------------------------------------------------------------------------  
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
		WHERE 1=1 ;
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
		------------------------------------------------------------------------------------------------------------  
		print  convert(varchar(30), getdate(), 121) + N' 파라미터 Type 값 임시테이블에 저장'
		-- 기존 대상에서 ESS 가상 line에 매핑된 JV Real Line은 제외 : 단방향 수정 (ESS가상 -> JV) 
		------------------------------------------------------------------------------------------------------------  
		INSERT INTO #TblDynamic_SCP0013Fix
		SELECT  PR.p_active_flag,
				PR.p_division_id,
				PR.p_plan_start_yyyymmdd,
				PR.p_plan_type,
				PR.p_seq,
				PR.p_operation_group,
				PR.p_scm_site_id,
				PR.p_item_id,
				PR.p_line_id,
				PR.p_operation_id,
				PR.p_measure,
				PR.p_yyyymmdd,
				ISNULL(PR.p_qty, 0) AS p_qty,
				PR.p_fix_reason,
				PR.p_origin_division_id,
				PR.p_electrode_type,
				PR.p_user_id,
				PR.p_bucket_type,
				''
		FROM @SCP0013 PR 
			  LEFT  JOIN #JV_ESS_SCM_SITE_MAP SM 
					  ON SM.RP_DIVISION_ID	= PR.P_DIVISION_ID
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
		;
		------------------------------------------------------------------------------------------------------------  
		print  convert(varchar(30), getdate(), 121) + N'  ESS 가상 line에 매핑된 JV Real Line 정보 추가' 
		------------------------------------------------------------------------------------------------------------  
		INSERT INTO #TblDynamic_SCP0013Fix
		SELECT  PR.p_active_flag,
				LM.RL_DIVISION_ID			AS P_DIVISION_ID,
				PR.p_plan_start_yyyymmdd,
				PV.PLAN_TYPE				AS p_plan_type,
				PV.PLAN_SEQ					AS p_seq,
				PR.p_operation_group,
				SM.RP_SCM_SITE_ID			AS P_SCM_SITE_ID,
				PR.p_item_id,
				LM.RL_LINE_ID				AS P_LINE_ID,
				PR.p_operation_id,
				PR.p_measure,
				PR.p_yyyymmdd,
				ISNULL(PR.p_qty, 0) AS p_qty,
				PR.p_fix_reason,
				LM.RL_DIVISION_ID			AS p_origin_division_id,
				PR.p_electrode_type,
				PR.p_user_id,
				PR.p_bucket_type,
				''
		 FROM @SCP0013 PR 
			 INNER JOIN #JV_ESS_SCM_SITE_MAP SM 
					 ON SM.VP_DIVISION_ID		= PR.P_DIVISION_ID
					AND SM.VP_SCM_SITE_ID		= PR.P_SCM_SITE_ID
			 INNER JOIN #JV_ESS_LINE_MAP LM
					 ON LM.VL_DIVISION_ID		= PR.P_DIVISION_ID
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

		-- 주 SUM fix 처리  시 0 -> scp_anl_production_plan 값으로 수정
		UPDATE X
		   SET X.P_QTY = T.QTY
		  FROM #TblDynamic_SCP0013Fix X
		  JOIN SCP_ANL_PRODUCTION_PLAN T WITH(NOLOCK)
		    ON T.DIVISION_ID			= X.P_DIVISION_ID
		   AND T.PLAN_START_YYYYMMDD	= X.P_PLAN_START_YYYYMMDD
		   AND T.PLAN_TYPE				= X.P_PLAN_TYPE
		   AND T.SEQ					= X.P_SEQ
		   AND T.OPERATION_GROUP		= X.P_OPERATION_GROUP
		   AND T.SCM_SITE_ID			= X.P_SCM_SITE_ID
		   AND T.ITEM_ID				= X.P_ITEM_ID
		   AND T.LINE_ID				= X.P_LINE_ID
		   AND T.OPERATION_ID			= X.P_OPERATION_ID
		   --AND T.MEASURE				= X.P_MEASURE
		   AND T.YYYYMMDD				= X.P_YYYYMMDD
		   AND T.MEASURE = 'PROD_PLAN_AMEND'
		   AND X.P_BUCKET_TYPE = 'WEEKLY'
		;

		--수정 Row
		SET @max_loop_cnt = convert(nvarchar(50), ISNULL((
									SELECT COUNT(*) 
									FROM #TblDynamic_SCP0013Fix  
								  ),0))
		;

		-- 입력,수정모드 결정
		UPDATE #TblDynamic_SCP0013Fix
		SET p_active_flag = ''
		WHERE p_active_flag !='D'


		-- 수정모드
		UPDATE B
		SET B.p_active_flag = 'M'
			, B.FIX_ID = A.FIX_ID
		FROM SCP_ANL_PRODUCTION_PLAN_FIX A, #TblDynamic_SCP0013Fix B
		WHERE 1=1
			AND A.division_id     = B.p_division_id
			AND A.operation_group = B.p_operation_group
			AND A.scm_site_id     = B.p_scm_site_id
			AND A.item_id         = B.p_item_id
			AND A.line_id         = B.p_line_id
			AND A.operation_id    = B.p_operation_id
			AND A.yyyymmdd        = B.p_yyyymmdd
			AND ISNULL(NULLIF(A.ELECTRODE_TYPE,''),'-')  = ISNULL(NULLIF(B.p_electrode_type,''),'-')    
			AND B.p_active_flag !='D'
		;

		--입력모드
		UPDATE #TblDynamic_SCP0013Fix
		SET p_active_flag = 'I'
		WHERE p_active_flag = ''
		;

		--입력대상 데이타 FIX_ID 채번
		UPDATE #TblDynamic_SCP0013Fix
		SET FIX_ID = CAST( (NEXT VALUE FOR SEQ1_SCP_ANL_PRODUCTION_PLAN_FIX) AS NVARCHAR )
		WHERE p_active_flag = 'I'
		;

		UPDATE #TblDynamic_SCP0013Fix
		SET FIX_ID = 'F' + p_yyyymmdd + REPLICATE('0', 11 - LEN(FIX_ID)) + FIX_ID
		WHERE p_active_flag = 'I'
		;

		--수량 Null 처리
		UPDATE #TblDynamic_SCP0013Fix
		SET p_qty=NULL
		WHERE ISNULL(p_qty,'') = ''
		;

		--1. 입력
		INSERT INTO DBO.SCP_ANL_PRODUCTION_PLAN_FIX (	
			FIX_ID	
			,DIVISION_ID
			,OPERATION_GROUP
			,SCM_SITE_ID
			,ITEM_ID
			,LINE_ID
			,OPERATION_ID
			,YYYYMMDD
			,QTY
			,FIX_REASON
			,ORIGIN_DIVISION_ID
			,ELECTRODE_TYPE
			,CREATED_BY
			,CREATION_DATE
			,LAST_UPDATED_BY
			,LAST_UPDATE_DATE
		)
		SELECT FIX_ID
			  ,p_division_id 
			  ,p_operation_group
			  ,p_scm_site_id
			  ,p_item_id
			  ,p_line_id
			  ,p_operation_id
			  ,p_yyyymmdd
			  ,p_qty
			  ,p_fix_reason
			  ,p_origin_division_id
			  ,p_electrode_type
			  ,p_user_id
			  ,@d_event_date
			  ,p_user_id
			  ,@d_event_date
		FROM #TblDynamic_SCP0013Fix
		WHERE p_active_flag = 'I'
		;


		--2. 수정
		UPDATE A
		SET A.qty			    = B.p_qty
			,A.fix_reason	    = B.p_fix_reason
			,A.last_updated_by  = B.p_user_id
			,A.last_update_date = @d_event_date
		FROM SCP_ANL_PRODUCTION_PLAN_FIX A, #TblDynamic_SCP0013Fix B
		WHERE 1=1
		AND A.division_id     = B.p_division_id
		AND A.operation_group = B.p_operation_group
		AND A.scm_site_id     = B.p_scm_site_id
		AND A.item_id         = B.p_item_id
		AND A.line_id         = B.p_line_id
		AND A.operation_id    = B.p_operation_id
		AND A.yyyymmdd        = B.p_yyyymmdd
		AND ISNULL(NULLIF(A.ELECTRODE_TYPE,''),'-')  = ISNULL(NULLIF(B.p_electrode_type,''),'-')
		AND B.p_active_flag IN ('M')
		;

		--3. Fix History
		-- 2021.10.20 : 주차 fix UI 에서 fix 처리 시 0 으로 전달. 임시 테이블로 이력 테이블 생성 
		DECLARE @SCP0013_HIST	AS DBO.SCP0013;

		INSERT INTO @SCP0013_HIST
		(
			p_division_id, 
			p_operation_group, 
			p_scm_site_id, 
			p_item_id,
			p_line_id,
			p_operation_id,
			p_yyyymmdd,
			p_qty,
			p_origin_division_id,
			p_electrode_type,
			p_user_id, 
			p_active_flag
		)
		SELECT
			p_division_id, 
			p_operation_group, 
			p_scm_site_id, 
			p_item_id,
			p_line_id,
			p_operation_id,
			p_yyyymmdd,
			p_qty,
			p_origin_division_id,
			p_electrode_type,
			p_user_id, 
			p_active_flag
		FROM #TblDynamic_SCP0013Fix
		;

		EXEC [PR_SCP_ANL_PRODUCTION_PLAN_FIX_HIST_DATASET] @SCP0013_HIST;

		--4. 삭제
		DELETE A
		FROM SCP_ANL_PRODUCTION_PLAN_FIX A, #TblDynamic_SCP0013Fix B
		WHERE A.division_id     = B.p_division_id
		AND A.operation_group	= B.p_operation_group
		AND A.scm_site_id		= B.p_scm_site_id
		AND A.item_id			= B.p_item_id
		AND A.line_id			= B.p_line_id
		AND A.operation_id		= B.p_operation_id
		AND A.yyyymmdd			= B.p_yyyymmdd
		AND ISNULL(NULLIF(A.ELECTRODE_TYPE,''),'-')  = ISNULL(NULLIF(B.p_electrode_type,''),'-')
		AND B.p_active_flag			= 'D'
		;

		SET @v_exec_time  =  REPLICATE('0', 2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +     
							 REPLICATE('0', 2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))    
		;

		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description  = N'[' + @v_exec_time + ']';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		-- 결과코드, 결과 카운트 반환
		SELECT  'S' AS result_code,  @max_loop_cnt AS result_cnt ;

		
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
		  SELECT 'F' AS result_code, '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE() AS err_message ;

		END CATCH;
	END

	IF OBJECT_ID('tempdb..#TblDynamic_SCP0013Fix') IS NOT NULL	
		DROP TABLE #TblDynamic_SCP0013Fix
	;







