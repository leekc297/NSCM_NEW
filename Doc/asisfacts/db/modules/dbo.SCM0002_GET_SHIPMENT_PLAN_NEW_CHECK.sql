


/*
 * Program ID   : SCM0002_GET_SHIPMENT_PLAN_NEW_CHECK
 * Description  : Shipment Plan FG/SEMI New 입력 Validation 체크
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2019/07/10	YHW				[CSR ID:4043582] GSCM - Shipment Plan FG / SEMI "New" 버튼 생성 요청 건
 *
 */
CREATE PROCEDURE [dbo].[SCM0002_GET_SHIPMENT_PLAN_NEW_CHECK]
	 @p_division_id			NVARCHAR(MAX)
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
	,@p_transport_mode		NVARCHAR(MAX)
	,@p_prgram_id			NVARCHAR(MAX)
AS

BEGIN

	/********************************************************************************      
	* 임시테이블만들기 - 조회조건 테이블      
	********************************************************************************/ 
	-- 신규입력(다건)     
	IF OBJECT_ID('tempdb..#TblDynamic_SCM0002_ShpimentPlanNewChk') IS NOT NULL
	DROP TABLE #TblDynamic_SCM0002_ShpimentPlanNewChk;    

	-- FG/SEMI 기존입력건
	IF OBJECT_ID('tempdb..#TblDynamic_SCM0002_ShpimentPlan') IS NOT NULL
	DROP TABLE #TblDynamic_SCM0002_ShpimentPlan;   

	-- 중복입력건
	IF OBJECT_ID('tempdb..#TblDynamic_SCM0002_ShpimentPlanDup') IS NOT NULL
	DROP TABLE #TblDynamic_SCM0002_ShpimentPlanDup;   

	CREATE TABLE #TblDynamic_SCM0002_ShpimentPlanNewChk (
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
		,TRANSPORT_MODE			NVARCHAR(150)
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
	);

	CREATE TABLE #TblDynamic_SCM0002_ShpimentPlanDup (
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
		,TRANSPORT_MODE			NVARCHAR(150)
	);


	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^' 
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;

	DECLARE @recv_division_id		NVARCHAR(MAX);
	SET @recv_division_id = NULL;		
	SET @recv_division_id = @p_division_id;

	DECLARE @result_dup			INTEGER = 0; 

	DECLARE @v_project_code		NVARCHAR(50);
	DECLARE @v_item_id			NVARCHAR(50);
	DECLARE @v_to_site			NVARCHAR(30);
	DECLARE @v_incoterms		NVARCHAR(10);
	DECLARE @v_from_site		NVARCHAR(30);
	DECLARE @v_bod_id			NVARCHAR(150);
	DECLARE @v_transport_mode	NVARCHAR(150);

	SET @v_project_code = NULL;
	SET @v_item_id = NULL;
	SET @v_to_site = NULL;
	SET @v_incoterms = NULL;
	SET @v_from_site = NULL;
	SET @v_bod_id = NULL;
	SET @v_transport_mode = NULL;

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCM0002_GET_SHIPMENT_PLAN_NEW_CHECK';
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
				SET @v_transport_mode	= [dbo].[SCM_ARR_SPL_VAL](@p_transport_mode,	@v_delimiter, @mst_loop_cnt) ; 
			END
			;

			INSERT INTO #TblDynamic_SCM0002_ShpimentPlanNewChk
			SELECT @p_division_id
					, @p_plan_start_yyyymmdd
					, @p_plan_type
					, @p_seq
					, @p_operation_group
					, @v_project_code
					, @v_item_id
					, @v_to_site
					, @v_incoterms
					, @v_from_site
					, @v_bod_id
					, @v_transport_mode
			;

		END

		--SELECT * FROM #TblDynamic_SCM0002_ShpimentPlanNewChk

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
			FROM SCP_ANL_SHIPMENT_PLAN_FG WITH(NOLOCK)
			WHERE DIVISION_ID = @p_division_id
			AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
			AND PLAN_TYPE = @p_plan_type
			AND SEQ = @p_seq
			AND BIZ_TYPE = @p_operation_group
			AND MEASURE IN ('SHIP_PLAN_AMEND')
			AND YYYYMMDD = @p_plan_start_yyyymmdd
			;

			INSERT INTO #TblDynamic_SCM0002_ShpimentPlanDup
			SELECT A.*
			FROM #TblDynamic_SCM0002_ShpimentPlanNewChk A
			JOIN #TblDynamic_SCM0002_ShpimentPlan B ON A.PROJECT_CODE = B.PROJECT_CODE
													AND A.ITEM_ID = B.ITEM_ID
													AND A.TO_SITE = B.TO_SITE
													AND A.INCOTERMS = B.INCOTERMS
													AND A.FROM_SITE = B.FROM_SITE
													AND A.BOD_ID = B.BOD_ID
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
			FROM SCP_ANL_SHIPMENT_PLAN_SEMI WITH(NOLOCK)
			WHERE DIVISION_ID = @p_division_id
			AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
			AND PLAN_TYPE = @p_plan_type
			AND SEQ = @p_seq
			AND OPERATION_GROUP = @p_operation_group
			AND MEASURE IN ('SHIP_PLAN_AMEND')
			AND YYYYMMDD = @p_plan_start_yyyymmdd
			;

			INSERT INTO #TblDynamic_SCM0002_ShpimentPlanDup
			SELECT A.*
			FROM #TblDynamic_SCM0002_ShpimentPlanNewChk A
			JOIN #TblDynamic_SCM0002_ShpimentPlan B ON A.ITEM_ID = B.ITEM_ID
													AND A.FROM_SITE = B.FROM_SITE
													AND A.BOD_ID = B.BOD_ID
			;

		END

		--SELECT * FROM #TblDynamic_SCM0002_ShpimentPlan

		SET @result_dup = ( SELECT COUNT(*) FROM #TblDynamic_SCM0002_ShpimentPlanDup ) ;

		IF @result_dup>0
			BEGIN
				IF(@p_prgram_id='FG')
					SELECT TOP(1) 'D' AS RESULT_CODE, ITEM_ID+' / '+FROM_SITE+' / '+TO_SITE+' / '+INCOTERMS+' / '+TRANSPORT_MODE AS MSG FROM #TblDynamic_SCM0002_ShpimentPlanDup
				ELSE
					SELECT TOP(1) 'D' AS RESULT_CODE, ITEM_ID+' / '+FROM_SITE++' / '+TRANSPORT_MODE AS MSG FROM #TblDynamic_SCM0002_ShpimentPlanDup
			END		
		ELSE
			BEGIN
				SELECT 'S' AS RESULT_CODE, '' AS MSG
			END		

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



	IF OBJECT_ID('tempdb..#TblDynamic_SCM0002_ShpimentPlanNewChk') IS NOT NULL
	DROP TABLE #TblDynamic_SCM0002_ShpimentPlanNewChk;    

	IF OBJECT_ID('tempdb..#TblDynamic_SCM0002_ShpimentPlan') IS NOT NULL
	DROP TABLE #TblDynamic_SCM0002_ShpimentPlan;   

	IF OBJECT_ID('tempdb..#TblDynamic_SCM0002_ShpimentPlanDup') IS NOT NULL
	DROP TABLE #TblDynamic_SCM0002_ShpimentPlanDup;   


END









