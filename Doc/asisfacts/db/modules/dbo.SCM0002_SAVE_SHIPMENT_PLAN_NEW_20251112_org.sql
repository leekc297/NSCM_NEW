



/*
 * Program ID   : SCM0002_SAVE_SHIPMENT_PLAN_NEW
 * Description  : Shipment Plan FG/SEMI New 입력
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2019/07/11	YHW				[CSR ID:4043582] GSCM - Shipment Plan FG / SEMI "New" 버튼 생성 요청 건
 * 2021/07/26   khj79          [PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - 중장기 프로젝트(기간82주로 연장)
 *
 */
CREATE PROCEDURE [dbo].[SCM0002_SAVE_SHIPMENT_PLAN_NEW_20251112_org]
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
				INSERT INTO #TblDynamic_SCM0002_ShpimentPlan
				SELECT DISTINCT DIVISION_ID
								, PLAN_START_YYYYMMDD
								, PLAN_TYPE
								, SEQ
								, OPERATION_GROUP
								, '-' PROJECT_CODE
								, ITEM_ID
								, '-' TO_SITE
								, '-' INCOTERMS
								, FROM_SITE
								, BOD_ID
								, MEASURE
				FROM SCP_ANL_SHIPMENT_PLAN_SEMI WITH(NOLOCK)
				WHERE DIVISION_ID = @p_division_id
				AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
				AND PLAN_TYPE = @p_plan_type
				AND SEQ = @p_seq
				AND OPERATION_GROUP = @p_operation_group
				AND MEASURE IN ('SHIP_REQ', 'SHIP_PLAN', 'SHIP_PLAN_AMEND')
				AND YYYYMMDD = @p_plan_start_yyyymmdd
				;
		
				DELETE A
				FROM #TblDynamic_SCM0002_ShpimentPlanNew A
				JOIN #TblDynamic_SCM0002_ShpimentPlan B ON A.ITEM_ID = B.ITEM_ID
														AND A.FROM_SITE = B.FROM_SITE
														AND A.BOD_ID = B.BOD_ID
														AND A.MEASURE = B.MEASURE
				;

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


END









