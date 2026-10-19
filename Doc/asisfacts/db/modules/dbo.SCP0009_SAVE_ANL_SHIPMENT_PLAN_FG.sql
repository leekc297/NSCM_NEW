
/*
 * Program ID   : SCP0009_SAVE_ANL_SHIPMENT_PLAN_FG
 * Description  : ANL SHIPMENT PLAN FG save
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2018/04		kyh				Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/05/29   kyh				값 수정시 fix값까지 갱신
 * 2018/07/19	kyh				신규 컬럼 추가 조회. (ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID, ELECTRODE_TYPE)
 * 2019/02/20	hwyoon			[CSR ID:3929450] Supply(Plan Line, FG, SEMI) 수정 시 Fix 데이터 저장로직 개선
 */
CREATE PROCEDURE [dbo].[SCP0009_SAVE_ANL_SHIPMENT_PLAN_FG]
	 @p_active_flag				NVARCHAR(MAX)
	,@p_division_id				NVARCHAR(MAX)
	,@p_plan_start_yyyymmdd		NVARCHAR(MAX)
	,@p_plan_type				NVARCHAR(MAX)
	,@p_seq						NVARCHAR(MAX)
	,@p_biz_type				NVARCHAR(MAX)
	,@p_project_code			NVARCHAR(MAX)
	,@p_item_id					NVARCHAR(MAX)
	,@p_to_site					NVARCHAR(MAX)
	,@p_incoterms				NVARCHAR(MAX)
	,@p_from_site				NVARCHAR(MAX)
	,@p_bod_id					NVARCHAR(MAX)
	,@p_measure					NVARCHAR(MAX)
	,@p_yyyymmdd				NVARCHAR(MAX)
	,@p_qty						NVARCHAR(MAX)
	,@p_origin_from_division_id		NVARCHAR(MAX)
	,@p_origin_to_division_id		NVARCHAR(MAX)
	,@p_electrode_type			NVARCHAR(MAX)
	,@p_created_by				NVARCHAR(150) 
	,@p_last_updated_by			NVARCHAR(150)
	,@p_time_zone				NVARCHAR(MAX)
	,@p_first_row				CHAR(1)
	,@p_last_row				CHAR(1)
AS

BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	DECLARE @recv_active_flag	NVARCHAR(MAX);
	SET @recv_active_flag = @p_active_flag;

	DECLARE @v_creation_date		datetime;		-- timezone에 따른 저장위해서

	DECLARE @v_transport_mode    NVARCHAR(100) = ''; --에러반환용

	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^' 
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0009_SAVE_ANL_SHIPMENT_PLAN_FG';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	-- 예외처리 변수 설정
	DECLARE @v_err_code  INTEGER;
	DECLARE @v_err_message  NVARCHAR(4000)='';
	
	SET @v_creation_date    = [dbo].[FN_MULTY_TIME](@p_time_zone); 

	-- 트렌젝션 시작
	BEGIN TRAN;
	BEGIN TRY

		-- 시작 LOG
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();

		IF @p_first_row = 'Y'
		BEGIN
			EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END
		
		BEGIN    
			DECLARE	@nQty INT = NULL;
			
			set @nQty = cast(@p_qty as int)

			IF( @p_active_flag ='M' OR @p_active_flag = 'I' ) 
			BEGIN
				-- 공백에 입력하는건 시트엔 M으로 처리해도, 실제 INSERT나 마찬가지일듯
				IF EXISTS (
					SELECT TOP 1 DIVISION_ID FROM SCP_ANL_SHIPMENT_PLAN_FG
					WHERE DIVISION_ID      = @p_division_id
						AND PLAN_START_YYYYMMDD			= @p_plan_start_yyyymmdd
						AND PLAN_TYPE					= @p_plan_type
						AND SEQ							= @p_seq
						AND BIZ_TYPE					= @p_biz_type
						AND PROJECT_CODE				= @p_project_code
						AND ITEM_ID						= @p_item_id
						AND TO_SITE						= @p_to_site
						AND INCOTERMS					= @p_incoterms
						AND FROM_SITE					= @p_from_site
						AND BOD_ID						= @p_bod_id
						AND MEASURE						= @p_measure
						AND YYYYMMDD					= @p_yyyymmdd
						AND ORIGIN_FROM_DIVISION_ID		= @p_origin_from_division_id
						AND ORIGIN_TO_DIVISION_ID		= @p_origin_to_division_id
						AND ELECTRODE_TYPE				= @p_electrode_type
				)
				BEGIN
					UPDATE dbo.SCP_ANL_SHIPMENT_PLAN_FG                 
					SET
						QTY					= @nQty
						,LAST_UPDATED_BY	= @p_last_updated_by 
						,LAST_UPDATE_DATE	= @v_creation_date
					WHERE DIVISION_ID		= @p_division_id
						AND PLAN_START_YYYYMMDD	= @p_plan_start_yyyymmdd
						AND PLAN_TYPE	= @p_plan_type
						AND SEQ			= @p_seq
						AND BIZ_TYPE		= @p_biz_type
						AND PROJECT_CODE	= @p_project_code
						AND ITEM_ID         = @p_item_id
						AND TO_SITE			= @p_to_site
						AND INCOTERMS		= @p_incoterms
						AND FROM_SITE		= @p_from_site
						AND BOD_ID			= @p_bod_id
						AND MEASURE			= @p_measure
						AND YYYYMMDD		= @p_yyyymmdd
						AND ORIGIN_FROM_DIVISION_ID		= @p_origin_from_division_id
						AND ORIGIN_TO_DIVISION_ID		= @p_origin_to_division_id
						AND ELECTRODE_TYPE		= @p_electrode_type
					;
				END
				ELSE
				BEGIN
					INSERT INTO dbo.SCP_ANL_SHIPMENT_PLAN_FG
						(DIVISION_ID
						,PLAN_START_YYYYMMDD
						,PLAN_TYPE
						,SEQ
						,BIZ_TYPE
						,PROJECT_CODE
						,ITEM_ID
						,TO_SITE
						,INCOTERMS
						,FROM_SITE
						,BOD_ID
						,MEASURE
						,YYYYMMDD
						,QTY
						,ORIGIN_FROM_DIVISION_ID
						,ORIGIN_TO_DIVISION_ID
						,ELECTRODE_TYPE
						,CREATED_BY
						,CREATION_DATE
						,LAST_UPDATED_BY
						,LAST_UPDATE_DATE
					)
					VALUES
						(@p_division_id  
						,@p_plan_start_yyyymmdd
						,@p_plan_type
						,@p_seq
						,@p_biz_type		
						,@p_project_code	
						,@p_item_id		
						,@p_to_site		
						,@p_incoterms	
						,@p_from_site	
						,@p_bod_id		
						,@p_measure
						,@p_yyyymmdd		
						, @nQty
						,@p_origin_from_division_id
						,@p_origin_to_division_id
						,@p_electrode_type
						,@p_created_by
						,@v_creation_date
						,@p_last_updated_by
						,@v_creation_date
					);
				END;
			end;	
			ELSE IF(@p_active_flag ='D')
			BEGIN
				DELETE FROM dbo.SCP_ANL_SHIPMENT_PLAN_FG 
				WHERE DIVISION_ID					= @p_division_id
					AND PLAN_START_YYYYMMDD			= @p_plan_start_yyyymmdd
					AND PLAN_TYPE					= @p_plan_type
					AND SEQ							= @p_seq
					AND BIZ_TYPE					= @p_biz_type
					AND PROJECT_CODE				= @p_project_code
					AND ITEM_ID						= @p_item_id
					AND TO_SITE						= @p_to_site
					AND INCOTERMS					= @p_incoterms
					AND FROM_SITE					= @p_from_site
					AND BOD_ID						= @p_bod_id
					AND MEASURE						= @p_measure
					AND YYYYMMDD					= @p_yyyymmdd
					AND ORIGIN_FROM_DIVISION_ID		= @p_origin_from_division_id
					AND ORIGIN_TO_DIVISION_ID		= @p_origin_to_division_id
					AND ELECTRODE_TYPE				= @p_electrode_type
			END;

			DECLARE @v_fix_id 			NVARCHAR(MAX);
			DECLARE @v_fix_reason		NVARCHAR(MAX);

			SELECT
				@v_fix_id = FIX_ID , @v_fix_reason = fix_reason
			FROM SCP_ANL_SHIPMENT_PLAN_FIX A
			WHERE 1=1
				AND division_id     = @p_division_id
				and BIZ_TYPE		= @p_biz_type
				and ITEM_ID			= @p_item_id
				and TO_SITE         = @p_to_site
				and FROM_SITE       = @p_from_site
				and PROJECT_CODE    = @p_project_code
				and INCOTERMS		= @p_incoterms
				and BOD_ID			= @p_bod_id
				and yyyymmdd        = @p_yyyymmdd
				AND ORIGIN_FROM_DIVISION_ID		= @p_origin_from_division_id
				AND ORIGIN_TO_DIVISION_ID		= @p_origin_to_division_id
				--AND ELECTRODE_TYPE		= @p_electrode_type
				AND ISNULL(NULLIF(ELECTRODE_TYPE,''),'-') = ISNULL(NULLIF(@p_electrode_type,''),'-')
			;

			IF @v_fix_id is not null
			BEGIN
				UPDATE SCP_ANL_SHIPMENT_PLAN_FIX
				SET qty					= @nQty
					,last_updated_by	= @p_last_updated_by
					,last_update_date	= @v_creation_date
				WHERE 1=1
					AND division_id     = @p_division_id
					and BIZ_TYPE		= @p_biz_type
					and ITEM_ID			= @p_item_id
					and TO_SITE         = @p_to_site
					and FROM_SITE       = @p_from_site
					and PROJECT_CODE    = @p_project_code
					and INCOTERMS		= @p_incoterms
					and BOD_ID			= @p_bod_id
					and yyyymmdd        = @p_yyyymmdd
					AND ORIGIN_FROM_DIVISION_ID		= @p_origin_from_division_id
					AND ORIGIN_TO_DIVISION_ID		= @p_origin_to_division_id
					--AND ELECTRODE_TYPE		= @p_electrode_type
					AND ISNULL(NULLIF(ELECTRODE_TYPE,''),'-') = ISNULL(NULLIF(@p_electrode_type,''),'-')
				;
				
				EXEC [PR_SCP_ANL_SHIPMENT_PLAN_FG_FIX_HIST]
					 @v_fix_id
					,@p_division_id
					,@p_biz_type
					,@p_item_id
					,@p_to_site
					,@p_from_site
					,@p_project_code
					,@p_incoterms
					,@p_bod_id
					,@p_yyyymmdd
					,@nQty
					,@p_origin_from_division_id
					,@p_origin_to_division_id
					,@p_electrode_type
					,@v_fix_reason
					,@p_last_updated_by
					,@d_event_date
					,@p_last_updated_by
				;

			END

			--이력저장
			EXEC [dbo].[PR_SCP_ANL_SHIPMENT_PLAN_FG_HIST]
				@p_division_id  		,
				@p_plan_start_yyyymmdd	,
				@p_plan_type			,
				@p_seq					,
				@p_biz_type				,
				@p_project_code			,
				@p_item_id				,
				@p_to_site				,
				@p_incoterms			,
				@p_from_site			,
				@p_bod_id				,
				@p_measure				,
				@p_yyyymmdd				,
				@nQty					,
				@p_origin_from_division_id	,
				@p_origin_to_division_id	,
				@p_electrode_type		,
				@p_created_by			,
				@p_last_updated_by
			;
			
			commit;
		END

		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		IF @p_last_row = 'Y'
		BEGIN
			EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END
		
		-- 결과코드, 결과 카운트 반환
		SELECT  'S' AS result_code,  @mst_loop_cnt AS result_cnt ;

	END TRY

	BEGIN CATCH 
		BEGIN
			if (xact_state() <> 0) ROLLBACK TRAN; --입력 데이타 롤백 처리
						
			INSERT INTO scm_sys_log_batch (program_name,log_type,log_count,log_message,description,event_date,creation_date,created_by,last_update_date,last_updated_by)
			VALUES (ERROR_PROCEDURE(),'ERROR',NULL,ERROR_MESSAGE(),NULL,SYSDATETIME(),SYSDATETIME(),ERROR_PROCEDURE(),SYSDATETIME(),ERROR_PROCEDURE());

			--IF @@TRANCOUNT > 0
			--  COMMIT WORK;

			-- error코드, errror 메시지 반환
			SELECT 'F' AS result_code , 0 as result_cnt ;

			IF( @v_err_code IS NULL OR @v_err_code ='')
				SET @v_err_code= ERROR_NUMBER() ;
			IF( @v_err_message IS NULL OR @v_err_message ='') 
				SET @v_err_message=  ERROR_MESSAGE();
			   						
			/* 에러 메시지, 에러 데이터  반환   */
			SELECT  @v_err_code			AS err_code
				   ,@v_err_message		AS err_message
				   ,@p_division_id		AS DIVISION_ID  
				   ,@p_biz_type			as BIZ_TYPE
				   ,@p_project_code		as PROJECT_CODE
				   ,@p_item_id			AS ITEM_ID
				   ,@p_to_site			AS TO_SITE
				   ,@p_incoterms		AS INCOTERMS
				   ,@p_from_site		AS FROM_SITE
				   ,@p_bod_id			AS BOD_ID
				   ,@p_measure			AS MEASURE
				   ,@p_yyyymmdd			AS YYYYMMDD
				   ,@p_qty				as qty
				   , error_line()
			; 

		END;
	END CATCH;
END
