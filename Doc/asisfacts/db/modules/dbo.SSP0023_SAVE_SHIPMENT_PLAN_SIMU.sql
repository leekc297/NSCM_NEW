
/*
 * PROGRAM ID   : SSP0023_SAVE_SHIPMENT_PLAN_SIMU
 * DESCRIPTION  : 전극 SHIPMENT PLAN(Electrode) - SIMULATION 저장
 * PROGRAM HISTORY
 *===================================================================================================
 *   DATE       IN CHARGE		DESCRIPTION
 *===================================================================================================
 * 2020-04-28   khj79			[PJ20199555] 공급 대응력 향상을 위한 자재재공 수급 점검 체계 개선  최초 작성
 * 2020-06-29   khj79			SSP_ANL_SHIP_PLAN_SIMU_EE 저장 시 사용자 입력 값 저장 되도록 수정
 * EX > 
 */
CREATE PROCEDURE [dbo].[SSP0023_SAVE_SHIPMENT_PLAN_SIMU]
	  @p_active_flag			NVARCHAR(MAX)
	, @p_division_id			NVARCHAR(MAX)
	, @p_company_id				NVARCHAR(MAX)
	, @p_plant_id				NVARCHAR(MAX)
	, @p_scm_site_id			NVARCHAR(MAX)
	, @p_model_id				NVARCHAR(MAX)
	, @p_item_id				NVARCHAR(MAX)
	, @p_npc_item_id			NVARCHAR(MAX)
	, @p_yyyymmdd				NVARCHAR(MAX)
	, @p_qty					NVARCHAR(MAX)
	, @p_plan_start_yyyymmdd	NVARCHAR(MAX)
	, @p_measure				NVARCHAR(MAX)
	, @p_last_updated_by		NVARCHAR(MAX)
	, @p_electrode_type			NVARCHAR(MAX)
AS

BEGIN
	SET NOCOUNT ON;

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	--DECLARE @DEBUG_MODE NVARCHAR(20) ='FALSE';
	--DECLARE @DEBUG_MODE NVARCHAR(20) ='TRUE';

	DECLARE @recv_active_flag		NVARCHAR(MAX);
	SET @recv_active_flag = @p_active_flag;

	declare @v_active_flag			NVARCHAR(MAX) = null;
	declare @v_division_id			NVARCHAR(MAX) = null;
	declare @v_company_id			NVARCHAR(MAX) = null;
	declare @v_plant_id				NVARCHAR(MAX) = null;
	declare @v_scm_site_id			NVARCHAR(MAX) = null;
	declare @v_model_id				NVARCHAR(MAX) = null;
	declare @v_item_id				NVARCHAR(MAX) = null;
	declare @v_npc_item_id			NVARCHAR(MAX) = null;
	declare @v_yyyymmdd				NVARCHAR(MAX) = null;
	declare @v_qty					NVARCHAR(MAX) = null;
	declare @v_plan_start_yyyymmdd	NVARCHAR(MAX) = null;
	declare @v_measure				NVARCHAR(MAX) = null;
	declare @v_last_updated_by		NVARCHAR(MAX) = null;
	declare @v_electrode_type		NVARCHAR(MAX) = null;

	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^' 
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;

	-- SIMULATION 저장 용 변수 설정
	DECLARE @n_simu_seq	INTEGER;
	
	-- QTY_TO_PCM, QTY_TO_CELL 용 변수 설정
	DECLARE @v_sql         NVARCHAR(MAX);
	DECLARE @v_qty_to_pcm  NVARCHAR(30) = null;
	DECLARE @v_qty_to_cell NVARCHAR(30) = null;

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SSP0023_SAVE_SHIPMENT_PALN_SIMU';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	-- 예외처리 변수 설정
	DECLARE @v_err_code  INTEGER;
	DECLARE @v_err_message  NVARCHAR(4000)='';

	-- 트렌젝션 시작
	BEGIN TRAN;

	BEGIN TRY

		-- 시작 LOG
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		-- 프로시저 LOOP 길이를 판단
		SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_active_flag, @v_delimiter);

		SET @mst_loop_cnt = 0;

		WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt
		BEGIN    
			--PRINT '3';
			-- @mst_loop_cnt 1증가
			SET @mst_loop_cnt = @mst_loop_cnt + 1;

			-- 각 컬럼들에 대한 스플릿처리로직 스타트
			BEGIN
				SET @v_division_id			= [dbo].[SCM_ARR_SPL_VAL](@p_division_id			, @v_delimiter, @mst_loop_cnt);
				SET @v_company_id			= [dbo].[SCM_ARR_SPL_VAL](@p_company_id				, @v_delimiter, @mst_loop_cnt);
				SET @v_plant_id				= [dbo].[SCM_ARR_SPL_VAL](@p_plant_id				, @v_delimiter, @mst_loop_cnt);
				SET @v_scm_site_id			= [dbo].[SCM_ARR_SPL_VAL](@p_scm_site_id			, @v_delimiter, @mst_loop_cnt);
				SET @v_model_id				= [dbo].[SCM_ARR_SPL_VAL](@p_model_id				, @v_delimiter, @mst_loop_cnt);
				SET @v_item_id				= [dbo].[SCM_ARR_SPL_VAL](@p_item_id				, @v_delimiter, @mst_loop_cnt);
				SET @v_yyyymmdd				= [dbo].[SCM_ARR_SPL_VAL](@p_yyyymmdd				, @v_delimiter, @mst_loop_cnt);
				SET @v_qty					= [dbo].[SCM_ARR_SPL_VAL](@p_qty					, @v_delimiter, @mst_loop_cnt);
				SET @v_plan_start_yyyymmdd	= [dbo].[SCM_ARR_SPL_VAL](@p_plan_start_yyyymmdd	, @v_delimiter, @mst_loop_cnt);
				SET @v_measure				= [dbo].[SCM_ARR_SPL_VAL](@p_measure				, @v_delimiter, @mst_loop_cnt);
				SET @v_last_updated_by		= [dbo].[SCM_ARR_SPL_VAL](@p_last_updated_by		, @v_delimiter, @mst_loop_cnt);
				SET @v_electrode_type		= [dbo].[SCM_ARR_SPL_VAL](@p_electrode_type			, @v_delimiter, @mst_loop_cnt);
			END

			-- LOOP 파라미터 출력 DEBUG용
			BEGIN		
				PRINT '===============================================';
				PRINT '@v_active_flag         = ''' +@v_active_flag            +'''';
				PRINT '@v_company_id          = ''' +@v_company_id             +'''';
				PRINT '@v_plant_id            = ''' +@v_plant_id               +'''';
				PRINT '@v_scm_site_id         = ''' +@v_scm_site_id            +'''';
				PRINT '@v_model_id            = ''' +@v_model_id               +'''';
				PRINT '@v_item_id             = ''' +@v_item_id                +'''';
				PRINT '@v_yyyymmdd            = ''' +@v_yyyymmdd               +'''';
				PRINT '@v_qty                 = ''' +@v_qty                    +'''';
				PRINT '@v_qty_to_cell         = ''' +@v_qty_to_cell            +'''';
				PRINT '@v_plan_start_yyyymmdd = ''' +@v_plan_start_yyyymmdd    +'''';
				PRINT '@v_measure             = ''' +@v_measure                +'''';
				PRINT '@v_last_updated_by     = ''' +@v_last_updated_by        +'''';
				PRINT '@v_electrode_type      = ''' +@v_electrode_type         +'''';

				PRINT '@mst_loop_cnt               = ''' +CONVERT(VARCHAR(10), @mst_loop_cnt) +'''';
			END;

			--// QTY_TO_PCM , QTY_TO_CELL 구하기
			SET @v_sql =          ' SELECT @v_qty_to_pcm  = ISNULL(' + @v_qty +' * ISNULL(F.CONVERT_TO_PCM , 1),0) '
			SET @v_sql = @v_sql + '      , @v_qty_to_cell = ISNULL(' + @v_qty +' * ISNULL(F.CONVERT_TO_CELL, 1),0) '
			SET @v_sql = @v_sql + '   FROM SSP_MST_SITE_ITEM_EE_V F WITH(NOLOCK)'
			SET @v_sql = @v_sql + '  WHERE 1 = 1 '
			SET @v_sql = @v_sql + '    AND F.DIVISION_ID = ''' + @v_division_id + ''''
			SET @v_sql = @v_sql + '    AND F.SCM_SITE_ID = ''' + @v_scm_site_id + ''''
			SET @v_sql = @v_sql + '    AND F.ITEM_ID     = ''' + @v_item_id + ''''

			PRINT @v_sql
			
			EXEC sp_executesql @v_sql, N'@v_qty_to_pcm nvarchar(max) output, @v_qty_to_cell nvarchar(max) output' , @v_qty_to_pcm OUTPUT, @v_qty_to_cell OUTPUT;


			--print @v_qty_to_pcm
			--print @v_qty_to_cell

			--데이터 저장
			IF @mst_loop_cnt > 0
				BEGIN
					
					--// SIMULATION 저장
					SET @n_simu_seq = NEXT VALUE FOR SEQ1_SSP_ANL_SHIP_PLAN_SIMU_EE

					INSERT	INTO SSP_ANL_SHIP_PLAN_SIMU_EE (
							  SEQ        , COMPANY_ID         , DIVISION_ID    , PLANT_ID        , SCM_SITE_ID
							, MODEL_ID   , ITEM_ID            , NPC_ITEM_ID    , YYYYMMDD        , QTY
							, QTY_TO_CELL, PLAN_START_YYYYMMDD
							, CREATED_BY , CREATION_DATE      , LAST_UPDATED_BY, LAST_UPDATE_DATE
						)
					SELECT @n_simu_seq          ,  COMPANY_ID        , DIVISION_ID, PLANT_ID, SCM_SITE_ID
							, MODEL_ID          , ITEM_ID            , NPC_ITEM_ID, YYYYMMDD, @v_qty
							, @v_qty_to_cell    , PLAN_START_YYYYMMDD
							, @v_last_updated_by, SYSDATETIME()      , @v_last_updated_by, SYSDATETIME()
					 FROM SSP_ANL_SHIP_PLAN_EE E WITH(NOLOCK)
					WHERE 1 = 1
					  AND plan_start_yyyymmdd = @v_plan_start_yyyymmdd
					  AND company_id          = @v_company_id
					  AND division_id         = @v_division_id
					  AND plant_id            = @v_plant_id
					  AND scm_site_id         = @v_scm_site_id
					  AND model_id            = @v_model_id
					  AND item_id             = @v_item_id
					  AND e.measure           = @v_measure
					  and e.yyyymmdd          = @v_yyyymmdd
					  ;

					MERGE INTO SSP_ANL_SHIP_PLAN_EE A
					USING (
							SELECT 
									 @v_plan_start_yyyymmdd	as plan_start_yyyymmdd
								   , @v_company_id			as company_id
								   , @v_division_id			as division_id
								   , @v_plant_id			as plant_id
								   , @v_scm_site_id			as scm_site_id
								   , @v_model_id			as model_id
								   , @v_item_id				as item_id
								   , @v_measure				as measure
								   , @v_yyyymmdd			as yyyymmdd
							) B
					ON(
								a.plan_start_yyyymmdd = b.plan_start_yyyymmdd
							and a.company_id          = b.company_id
							and a.division_id         = b.division_id
							and a.plant_id            = b.plant_id
							and a.scm_site_id         = b.scm_site_id
							and a.model_id            = b.model_id
							and a.item_id             = b.item_id
							and a.measure             = b.measure
							and a.yyyymmdd            = b.yyyymmdd
						)
					WHEN MATCHED THEN
							UPDATE SET 
								QTY				= @v_qty
							  , QTY_TO_PCM		= @v_qty_to_pcm
							  , QTY_TO_CELL		= @v_qty_to_cell
							  , LAST_UPDATED_BY	= @v_last_updated_by
							  , LAST_UPDATE_DATE= sysdatetime()
					                
					WHEN NOT MATCHED THEN
					INSERT	(	
								PLAN_START_YYYYMMDD, COMPANY_ID    , DIVISION_ID    , PLANT_ID        , SCM_SITE_ID
							  , MODEL_ID           , ITEM_ID       , NPC_ITEM_ID    , MEASURE_TYPE    , MEASURE
							  , YYYYMMDD           , QTY           , QTY_TO_PCM     , QTY_TO_CELL     , FROM_DIVISION_ID
							  , FROM_SITE          , TO_DIVISION_ID, TO_SITE        , BOD_ID          , ELECTRODE_TYPE
							  , ETD_DATE           , ETA_DATE
							  , CREATED_BY         , CREATION_DATE , LAST_UPDATED_BY, LAST_UPDATE_DATE
							)
					VALUES  (
					 			@v_plan_start_yyyymmdd, @v_company_id, @v_division_id , @v_plant_id   , @v_scm_site_id
							  , @v_model_id           , @v_item_id   , NULL           ,'P'            , @v_measure
							  , @v_yyyymmdd           , @v_qty       ,  @v_qty_to_pcm , @v_qty_to_cell, '-'
							  , '-'                   , '-'          , '-'            , '-'           , @v_electrode_type
							  , '-'                   , '-'
							  , @v_last_updated_by        , SYSDATETIME()       , @v_last_updated_by , SYSDATETIME()
							)
					;
					
				END  -- END OF STMT. IF( @mst_loop_cnt > 0 )
			
		END -- END OF STMT. WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt

		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			
		COMMIT TRAN;

		-- 결과코드, 결과 카운트 반환
		SELECT  'S' AS result_code,  @max_loop_cnt AS result_cnt ;

	END TRY

	BEGIN CATCH 

		  if (xact_state() <> 0) ROLLBACK TRAN; --입력 데이타 롤백 처리

		  BEGIN
			INSERT INTO scm_sys_log_batch (program_name,log_type,log_count,log_message,description,event_date,creation_date,created_by,last_update_date,last_updated_by)
			VALUES (ERROR_PROCEDURE(),'ERROR',NULL,ERROR_MESSAGE(),NULL,SYSDATETIME(),SYSDATETIME(),ERROR_PROCEDURE(),SYSDATETIME(),ERROR_PROCEDURE());

			--IF @@TRANCOUNT > 0
			--  COMMIT WORK;
		  END;

		  -- error코드, errror 메시지 반환
			IF( @v_err_message IS NULL OR @v_err_message ='')
				BEGIN
					SELECT 'F' AS result_code;
					SELECT '' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
				END
			ELSE
				BEGIN
					SELECT 'N' AS result_code;
					SELECT @v_err_message AS ERR_MESSAGE ;
				END

		END CATCH;
	END
;

