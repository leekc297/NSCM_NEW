
/*
 * Program ID   : SCP0125_SAVE_STOCK_ADJ
 * Description  : STOCK 조정 등록,수정 
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2025/07/07   mrchois			PJ2024A332R 독립적 Planning 체계 및 Master Validation UI 구축 - Initial Release
 * 2025/07/16   mrchois			PJ2024A332R 독립적 Planning 체계 및 Master Validation UI 구축 - 삭제기능 추가
 * 2025/09/24   mrchois			PJ20257329  최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - Plant 재고 조회에 전극Plant 대상 LOCATION_CODE 제외 처리
 *
 */
CREATE PROCEDURE [dbo].[SCP0125_SAVE_STOCK_ADJ]

	-- Add the parameters for the stored procedure here
	@p_active_flag			NVARCHAR(MAX),
	@p_division_id			NVARCHAR(MAX), 
	@p_stock_type			NVARCHAR(MAX), 
	@p_cutoff_yyyymmdd		NVARCHAR(MAX), 
	@p_project_code			NVARCHAR(MAX),  
	@p_item_id				NVARCHAR(MAX), 
	@p_incoterms			NVARCHAR(MAX), 
	@p_from_site_id			NVARCHAR(MAX), 
	@p_scm_site_id			NVARCHAR(MAX),
	@p_location_code		NVARCHAR(MAX),			--[PJ20257329]Plant 재고 조회에 전극Plant 대상 LOCATION_CODE 제외 처리(2025-09-24)
	@p_line_id				NVARCHAR(MAX),
	@p_before_degas			NVARCHAR(MAX),
	@p_inv_date				NVARCHAR(MAX), 
	@p_qty					NVARCHAR(MAX), 
	@p_chg_qty				NVARCHAR(MAX), 
	@p_chg_rsn				NVARCHAR(MAX), 
	@p_chg_type				NVARCHAR(MAX), 
	@p_user_id				NVARCHAR(MAX)

AS

BEGIN

	SET NOCOUNT ON;

	DECLARE @v_working_time			DATETIME =sysdatetime();
	DECLARE @recv_active_flag		NVARCHAR(MAX);
	SET @recv_active_flag = NULL;		
	SET @recv_active_flag = @p_active_flag;

	DECLARE @v_active_flag			NVARCHAR(MAX);
	DECLARE @v_division_id			NVARCHAR(MAX);
	DECLARE @v_stock_type			NVARCHAR(MAX);
	DECLARE @v_cutoff_yyyymmdd		NVARCHAR(MAX);
	DECLARE @v_project_code			NVARCHAR(MAX);
	DECLARE @v_item_id				NVARCHAR(MAX);
	DECLARE @v_incoterms			NVARCHAR(MAX);
	DECLARE @v_from_site_id			NVARCHAR(MAX);
	DECLARE @v_scm_site_id			NVARCHAR(MAX);
	DECLARE @v_location_code		NVARCHAR(MAX);		--[PJ20257329]Plant 재고 조회에 전극Plant 대상 LOCATION_CODE 제외 처리(2025-09-24)
	DECLARE @v_line_id				NVARCHAR(MAX);
	DECLARE @v_before_degas			NVARCHAR(MAX);
	DECLARE @v_inv_date				NVARCHAR(MAX);
	DECLARE @v_qty					NVARCHAR(MAX);
	DECLARE @v_chg_qty				NVARCHAR(MAX);
	DECLARE @v_chg_rsn				NVARCHAR(MAX);
	DECLARE @v_chg_type				NVARCHAR(MAX);
	DECLARE @v_user_id				NVARCHAR(MAX);

	DECLARE @v_last_updated_by	NVARCHAR(MAX);
	
	SET @v_active_flag			= NULL;	
	SET @v_division_id			= NULL;
	SET @v_stock_type			= NULL;	
	SET @v_cutoff_yyyymmdd		= NULL;
	SET @v_project_code			= NULL;
	SET @v_item_id				= NULL;
	SET @v_incoterms			= NULL;
	SET @v_from_site_id			= NULL;
	SET @v_scm_site_id			= NULL;	
	SET @v_location_code		= NULL;					--[PJ20257329]Plant 재고 조회에 전극Plant 대상 LOCATION_CODE 제외 처리(2025-09-24)
	SET @v_line_id				= NULL;	
	SET @v_before_degas			= NULL;	
	SET @v_inv_date				= NULL;
	SET @v_qty					= NULL;
	SET @v_chg_qty				= NULL;
	SET @v_chg_rsn				= NULL;
	SET @v_chg_type				= NULL;
	SET @v_last_updated_by	= NULL;

	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^' 

	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;
		
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0125_SAVE_STOCK_ADJ';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	DECLARE @v_data_dup_cnt  INT=0;


	-- 예외처리 변수 설정
	DECLARE @v_err_code  INTEGER;
	DECLARE @v_err_message  NVARCHAR(4000)='';

	SET @v_last_updated_by  = @p_user_id

	

	BEGIN TRY

		-- 트렌젝션 시작
		BEGIN TRAN;

		-- 시작 LOG
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		
		-- 프로시저 LOOP 길이를 판단
		SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_active_flag, @v_delimiter);   

		WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt
		BEGIN

			SET @mst_loop_cnt = @mst_loop_cnt + 1;

			-- 각 컬럼들에 대한 스플릿처리로직 스타트
			BEGIN

				SET @v_active_flag = [dbo].[SCM_ARR_SPL_VAL](@p_active_flag, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_division_id = [dbo].[SCM_ARR_SPL_VAL](@p_division_id, @v_delimiter , @mst_loop_cnt) ;   
				SET @v_stock_type = [dbo].[SCM_ARR_SPL_VAL](@p_stock_type, @v_delimiter , @mst_loop_cnt) ;	
				SET @v_cutoff_yyyymmdd = [dbo].[SCM_ARR_SPL_VAL](@p_cutoff_yyyymmdd, @v_delimiter , @mst_loop_cnt) ;
				SET @v_project_code = [dbo].[SCM_ARR_SPL_VAL](@p_project_code, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_item_id = [dbo].[SCM_ARR_SPL_VAL](@p_item_id, @v_delimiter , @mst_loop_cnt) ;   
				SET @v_incoterms = [dbo].[SCM_ARR_SPL_VAL](@p_incoterms, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_from_site_id	 = [dbo].[SCM_ARR_SPL_VAL](@p_from_site_id	, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_scm_site_id	 = [dbo].[SCM_ARR_SPL_VAL](@p_scm_site_id	, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_location_code	= [dbo].[SCM_ARR_SPL_VAL](@p_location_code	, @v_delimiter , @mst_loop_cnt) ;	--[PJ20257329]Plant 재고 조회에 전극Plant 대상 LOCATION_CODE 제외 처리(2025-09-24)
				SET @v_line_id			= [dbo].[SCM_ARR_SPL_VAL](@p_line_id	, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_before_degas		= [dbo].[SCM_ARR_SPL_VAL](@p_before_degas	, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_inv_date = [dbo].[SCM_ARR_SPL_VAL](@p_inv_date, @v_delimiter , @mst_loop_cnt) ;   
				SET @v_qty = [dbo].[SCM_ARR_SPL_VAL](@p_qty, @v_delimiter , @mst_loop_cnt) ;	
				SET @v_chg_qty = [dbo].[SCM_ARR_SPL_VAL](@p_chg_qty, @v_delimiter , @mst_loop_cnt) ;
				SET @v_chg_rsn = [dbo].[SCM_ARR_SPL_VAL](@p_chg_rsn, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_chg_type = [dbo].[SCM_ARR_SPL_VAL](@p_chg_type, @v_delimiter , @mst_loop_cnt) ;

			END



			IF(@v_active_flag = 'I')
			BEGIN

				INSERT INTO SCP_OPMZ_INV_ADJ
				(
					   DIVISION_ID
					   ,SRCE_DIVS_CD
					   ,CUTOFF_YYYYMMDD
					   ,STOCK_TYPE
					   ,PROJECT_CODE
					   ,ITEM_ID
					   ,FCST_TYPE
					   ,INCOTERMS
					   ,FROM_SITE_ID
					   ,SCM_SITE_ID
					   ,LOCATION_CODE			--[PJ20257329]Plant 재고 조회에 전극Plant 대상 LOCATION_CODE 제외 처리(2025-09-24)
					   ,LINE_ID
					   ,BEFORE_DEGAS
					   ,INV_DATE
					   ,QTY
					   ,CHG_QTY
					   ,CHG_RSN
					   ,CHG_TYPE
					   ,CREATED_BY
					   ,CREATION_DATE
					   ,LAST_UPDATED_BY
					   ,LAST_UPDATE_DATE
				 )
				 VALUES
				 (
					   @v_division_id
					   ,@v_stock_type		--SRCE_DIVS_CD
					   ,@v_cutoff_yyyymmdd
					   ,@v_stock_type
					   ,@v_project_code
					   ,@v_item_id
					   ,'-'					--FCST_TYPE
					   ,@v_incoterms
					   ,@v_from_site_id
					   ,@v_scm_site_id
					   ,@v_location_code		--[PJ20257329]Plant 재고 조회에 전극Plant 대상 LOCATION_CODE 제외 처리(2025-09-24)
					   ,@v_line_id
					   ,@v_before_degas
					   ,@v_inv_date
					   ,CASE WHEN @v_qty = '' THEN NULL ELSE @v_qty END
					   ,@v_chg_qty
					   ,@v_chg_rsn
					   ,@v_chg_type
					   ,@v_last_updated_by
					   ,GETDATE()
					   ,@v_last_updated_by
					   ,GETDATE()
				 )

			END
			ELSE IF( @v_active_flag ='M' )
			BEGIN

				UPDATE SCP_OPMZ_INV_ADJ
				SET CHG_QTY				= @v_chg_qty
					, CHG_RSN			= @v_chg_rsn
					, LAST_UPDATED_BY	= @v_last_updated_by 
					, LAST_UPDATE_DATE	= SYSDATETIME()
				WHERE DIVISION_ID		= @v_division_id
				AND STOCK_TYPE			= @v_stock_type
				AND CUTOFF_YYYYMMDD		= @v_cutoff_yyyymmdd
				AND PROJECT_CODE		= @v_project_code
				AND ITEM_ID				= @v_item_id
				AND INCOTERMS			= @v_incoterms
				AND FROM_SITE_ID		= @v_from_site_id
				AND SCM_SITE_ID			= @v_scm_site_id
				AND LOCATION_CODE		= @v_location_code		--[PJ20257329]Plant 재고 조회에 전극Plant 대상 LOCATION_CODE 제외 처리(2025-09-24)
				AND LINE_ID				= @v_line_id
				AND BEFORE_DEGAS		= @v_before_degas
				AND INV_DATE			= @v_inv_date
				;

			END
			--삭제기능 추가 (2025-07-16)
			ELSE IF(@v_active_flag ='D')
			BEGIN
				
				DELETE SCP_OPMZ_INV_ADJ
				WHERE DIVISION_ID		= @v_division_id
				AND STOCK_TYPE			= @v_stock_type
				AND CUTOFF_YYYYMMDD		= @v_cutoff_yyyymmdd
				AND PROJECT_CODE		= @v_project_code
				AND ITEM_ID				= @v_item_id
				AND INCOTERMS			= @v_incoterms
				AND FROM_SITE_ID		= @v_from_site_id
				AND SCM_SITE_ID			= @v_scm_site_id
				AND LOCATION_CODE		= @v_location_code		--[PJ20257329]Plant 재고 조회에 전극Plant 대상 LOCATION_CODE 제외 처리(2025-09-24)
				AND LINE_ID				= @v_line_id
				AND BEFORE_DEGAS		= @v_before_degas
				AND INV_DATE			= @v_inv_date

			END

		END

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
		IF (XACT_STATE() <> 0) ROLLBACK TRAN; --입력 데이타 롤백 처리
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

			--IF @@TRANCOUNT > 0
			--	COMMIT WORK;

		END;

		-- error코드, errror 메시지 반환
		SELECT 'F' AS result_code;
		SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
	END CATCH;
END






