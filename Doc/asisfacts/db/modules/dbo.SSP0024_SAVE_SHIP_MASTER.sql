/*
 * Program ID   : SSP0024_SAVE_SHIP_MASTER
 * Description  : Shipment Master(Electrode) 저장
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2020/04/20   khj79			[PJ20199555] 공급 대응력 향상을 위한 자재재공 수급 점검 체계 개선
 */
CREATE PROCEDURE [dbo].[SSP0024_SAVE_SHIP_MASTER]
	  @p_active_flag				NVARCHAR(MAX)
	, @p_division_id				NVARCHAR(MAX)
	, @p_plant_site_code			NVARCHAR(MAX)
	, @p_material_id				NVARCHAR(MAX)
	, @p_electrode_post_oper_code	NVARCHAR(MAX)
	, @p_pc_roll_length				NVARCHAR(MAX)
	, @p_package_type_code			NVARCHAR(MAX)
	, @p_steelcrate_per_cut			NVARCHAR(MAX)
	, @p_box_per_cut				NVARCHAR(MAX)
	, @p_steelrack_per_cut			NVARCHAR(MAX)
	, @p_dom_exp_type_code			NVARCHAR(MAX)
	, @p_factory_id					NVARCHAR(MAX)
	, @p_remarks					NVARCHAR(MAX)
	, @p_created_by					NVARCHAR(MAX)
	, @p_creation_date				NVARCHAR(MAX)
	, @p_last_updated_by			NVARCHAR(MAX)
AS

BEGIN
	SET NOCOUNT ON;

	--SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	--DECLARE @DEBUG_MODE NVARCHAR(20) ='FALSE';
	--DECLARE @DEBUG_MODE NVARCHAR(20) ='TRUE';

	DECLARE @recv_active_flag			NVARCHAR(MAX);
	SET @recv_active_flag = @p_active_flag;

	DECLARE @v_active_flag				NVARCHAR(MAX) = NULL;
	DECLARE @v_division_id				NVARCHAR(MAX) = NULL;
	DECLARE @v_plant_site_code 			NVARCHAR(MAX) = NULL;
	DECLARE @v_material_id				NVARCHAR(MAX) = NULL;
	DECLARE @v_electrode_post_oper_code	NVARCHAR(MAX) = NULL;
	DECLARE @v_pc_roll_length			NVARCHAR(MAX) = NULL;
	DECLARE @v_package_type_code		NVARCHAR(MAX) = NULL;
	DECLARE @v_steelcrate_per_cut		NVARCHAR(MAX) = NULL;
	DECLARE @v_box_per_cut				NVARCHAR(MAX) = NULL;
	DECLARE @v_steelrack_per_cut		NVARCHAR(MAX) = NULL;
	DECLARE @v_dom_exp_type_code		NVARCHAR(MAX) = NULL;
	DECLARE @v_factory_id				NVARCHAR(MAX) = NULL;
	DECLARE @v_remarks					NVARCHAR(MAX) = NULL;
	DECLARE @v_created_by				NVARCHAR(MAX) = NULL;
	DECLARE @v_creation_date			NVARCHAR(MAX) = NULL;
	DECLARE @v_last_updated_by			NVARCHAR(MAX) = NULL;

	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^' 
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;

	-- 이력 저장 용 변수 설정
	DECLARE @n_history_seq	INTEGER;
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SSP0024_SAVE_SHIP_MASTER';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	-- 예외처리 변수 설정
	DECLARE @v_err_code  INTEGER;
	DECLARE @v_err_message  NVARCHAR(4000)='';

	/********************************************************************************
	* 임시테이블만들기
	********************************************************************************/
	--IF OBJECT_ID('tempdb..#TblDynamic_SSP0024') IS NOT NULL	
	--	DROP TABLE #TblDynamic_SSP0024
	;

	--CREATE TABLE #TblDynamic_SSP0024 (
	--	active_flag					NVARCHAR(1),
	--	division_id					NVARCHAR(30),
	--	plant_site_id				NVARCHAR(30),
	--	item_id						NVARCHAR(50),
	--	electrode_post_oper_code	NVARCHAR(20),
	--	pc_roll_length				BIGINT,
	--	steelcrate_per_cut			BIGINT,
	--	box_per_cut					BIGINT,
	--	steelrack_per_cut			BIGINT,
	--	dom_exp_type_code			NVARCHAR(20),
	--	factory_id					NVARCHAR(20),
	--	remarks						NVARCHAR(4000)
	--);

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
				SET @v_active_flag				= [dbo].[SCM_ARR_SPL_VAL](@p_active_flag			 , @v_delimiter, @mst_loop_cnt) ;
				SET @v_division_id				= [dbo].[SCM_ARR_SPL_VAL](@p_division_id			 , @v_delimiter, @mst_loop_cnt) ;
				SET @v_plant_site_code			= [dbo].[SCM_ARR_SPL_VAL](@p_plant_site_code		 , @v_delimiter, @mst_loop_cnt) ;
				SET @v_material_id				= [dbo].[SCM_ARR_SPL_VAL](@p_material_id			 , @v_delimiter, @mst_loop_cnt) ;
				SET @v_electrode_post_oper_code	= [dbo].[SCM_ARR_SPL_VAL](@p_electrode_post_oper_code, @v_delimiter, @mst_loop_cnt) ;
				SET @v_pc_roll_length			= [dbo].[SCM_ARR_SPL_VAL](@p_pc_roll_length			 , @v_delimiter, @mst_loop_cnt) ;
				SET @v_steelcrate_per_cut		= [dbo].[SCM_ARR_SPL_VAL](@p_steelcrate_per_cut		 , @v_delimiter, @mst_loop_cnt) ;
				SET @v_package_type_code		= [dbo].[SCM_ARR_SPL_VAL](@p_package_type_code		 , @v_delimiter, @mst_loop_cnt) ;
				SET @v_box_per_cut				= [dbo].[SCM_ARR_SPL_VAL](@p_box_per_cut			 , @v_delimiter, @mst_loop_cnt) ;
				SET @v_steelrack_per_cut		= [dbo].[SCM_ARR_SPL_VAL](@p_steelrack_per_cut		 , @v_delimiter, @mst_loop_cnt) ;
				SET @v_dom_exp_type_code		= [dbo].[SCM_ARR_SPL_VAL](@p_dom_exp_type_code		 , @v_delimiter, @mst_loop_cnt) ;
				SET @v_factory_id				= [dbo].[SCM_ARR_SPL_VAL](@p_factory_id				 , @v_delimiter, @mst_loop_cnt) ;
				SET @v_remarks					= [dbo].[SCM_ARR_SPL_VAL](@p_remarks				 , @v_delimiter, @mst_loop_cnt) ;
				SET @v_created_by				= [dbo].[SCM_ARR_SPL_VAL](@p_created_by				 , @v_delimiter, @mst_loop_cnt) ;
				SET @v_creation_date			= [dbo].[SCM_ARR_SPL_VAL](@p_creation_date			 , @v_delimiter, @mst_loop_cnt) ;
				SET @v_last_updated_by			= [dbo].[SCM_ARR_SPL_VAL](@p_last_updated_by		 , @v_delimiter, @mst_loop_cnt) ;
			END

			-- LOOP 파라미터 출력 DEBUG용
			BEGIN		
				PRINT '===============================================';
				PRINT '@v_active_flag              = ''' +@v_active_flag                      +'''';
				PRINT '@v_division_id              = ''' +@v_division_id                      +'''';
				PRINT '@v_plant_site_code          = ''' +@v_plant_site_code                  +'''';
				PRINT '@v_material_id              = ''' +@v_material_id                      +'''';
				PRINT '@v_electrode_post_oper_code = ''' +@v_electrode_post_oper_code         +'''';
				PRINT '@v_pc_roll_length           = ''' +@v_pc_roll_length                   +'''';
				PRINT '@v_steelcrate_per_cut       = ''' +@v_steelcrate_per_cut               +'''';
				PRINT '@v_package_type_code        = ''' +@v_package_type_code                +'''';
				PRINT '@v_box_per_cut              = ''' +@v_box_per_cut                      +'''';
				PRINT '@v_steelrack_per_cut        = ''' +@v_steelrack_per_cut                +'''';
				PRINT '@v_dom_exp_type_code        = ''' +@v_dom_exp_type_code                +'''';
				PRINT '@v_factory_id               = ''' +@v_factory_id                       +'''';
				PRINT '@v_remarks                  = ''' +@v_remarks                          +'''';
				PRINT '@v_last_updated_by          = ''' +@v_last_updated_by                  +'''';
				PRINT '@mst_loop_cnt               = ''' +CONVERT(VARCHAR(10), @mst_loop_cnt) +'''';
			END;

			--이력저장
			BEGIN
				SET @n_history_seq = NEXT VALUE FOR SEQ1_SSP_MST_SHIP_MASTER_EE_H
				
				INSERT	INTO  SSP_MST_SHIP_MASTER_EE_H (
								HISTORY_SEQ      , DIVISION_ID       , SCM_SITE_ID      , ITEM_ID        , ELECTRODE_POST_OPER_CODE
							  , PC_ROLL_LENGTH   , STEELCRATE_PER_CUT, PACKAGE_TYPE_CODE, BOX_PER_CUT    , STEELRACK_PER_CUT
							  , DOM_EXP_TYPE_CODE, FACTORY_ID        , REMARKS
							  , CREATED_BY       , CREATION_DATE     , LAST_UPDATED_BY  , LAST_UPDATE_DATE, HISTORY_CREATION_DATE)
				VALUES  
							(
								@n_history_seq      , @v_division_id       , @v_plant_site_code  , @v_material_id, @v_electrode_post_oper_code
							  , @v_pc_roll_length   , @v_steelcrate_per_cut, @v_package_type_code, @v_box_per_cut, @v_steelrack_per_cut
							  , @v_dom_exp_type_code, @v_factory_id        , @v_remarks
							  , @v_created_by       , @v_creation_date     , @v_last_updated_by  , SYSDATETIME() , SYSDATETIME()
							);
			END

			--데이터 저장
			IF @mst_loop_cnt > 0
				BEGIN
					MERGE INTO SSP_MST_SHIP_MASTER_EE A
					USING (
							SELECT 
									 @v_division_id					as division_id
								   , @v_plant_site_code				as scm_site_id
								   , @v_material_id					as item_id
								   , @v_electrode_post_oper_code	as electrode_post_oper_code
								   , @v_pc_roll_length				as pc_roll_length
								   , @v_steelcrate_per_cut			as steelcrate_per_cut
								   , @v_package_type_code			as package_type
								   , @v_box_per_cut					as box_per_cut
								   , @v_steelrack_per_cut			as steelrack_per_cut
								   , @v_dom_exp_type_code			as dom_exp_type_code
								   , @v_factory_id					as factory_id
								   , @v_remarks						as remarks
							) B
					ON(
									a.division_id = b.division_id
								AND a.scm_site_id = b.scm_site_id
								AND a.item_id	  = b.item_id
						)
					WHEN MATCHED THEN
							UPDATE SET 	
								ELECTRODE_POST_OPER_CODE = @v_electrode_post_oper_code
							  , PC_ROLL_LENGTH			 = CAST(@v_pc_roll_length     as int)
							  , STEELCRATE_PER_CUT		 = CAST(@v_steelcrate_per_cut as int)
							  , PACKAGE_TYPE_CODE		 = @v_package_type_code
							  , BOX_PER_CUT				 = CAST(@v_box_per_cut       as numeric(20,2))
							  , STEELRACK_PER_CUT		 = CAST(@v_steelrack_per_cut as numeric(10,2))
							  , DOM_EXP_TYPE_CODE		 = @v_dom_exp_type_code
							  , FACTORY_ID				 = @v_factory_id
							  , REMARKS					 = @v_remarks
							  , LAST_UPDATED_BY			 = @v_last_updated_by
							  , LAST_UPDATE_DATE		 = sysdatetime()
					                
					WHEN NOT MATCHED THEN
					INSERT	(	
								DIVISION_ID       , SCM_SITE_ID      , ITEM_ID        , ELECTRODE_POST_OPER_CODE, PC_ROLL_LENGTH
							  , STEELCRATE_PER_CUT, PACKAGE_TYPE_CODE, BOX_PER_CUT    , STEELRACK_PER_CUT       , DOM_EXP_TYPE_CODE
							  , FACTORY_ID        , REMARKS
							  , CREATED_BY        , CREATION_DATE    , LAST_UPDATED_BY, LAST_UPDATE_DATE
							)
					VALUES  (
					 			@v_division_id       , @v_plant_site_code  , @v_material_id, @v_electrode_post_oper_code, @v_pc_roll_length
							  , @v_steelcrate_per_cut, @v_package_type_code, @v_box_per_cut, @v_steelrack_per_cut       , @v_dom_exp_type_code
							  , @v_factory_id        , @v_remarks
							  , @v_created_by        , SYSDATETIME()       , @v_created_by , SYSDATETIME()
							);
					
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
					SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
				END
			ELSE
				BEGIN
					SELECT 'N' AS result_code;
					SELECT @v_err_message AS ERR_MESSAGE ;
				END

		END CATCH;
	END
;

