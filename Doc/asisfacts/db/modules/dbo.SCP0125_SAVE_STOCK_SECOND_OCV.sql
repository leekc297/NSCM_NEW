
/*
 * Program ID   : SCP0125_SAVE_STOCK_SECOND_OCV
 * Description  : STOCK(2nd OCV) 등록,수정 
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2025/10/29   mrchois			PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - Initial Release
 *
 */
CREATE PROCEDURE [dbo].[SCP0125_SAVE_STOCK_SECOND_OCV]

	-- Add the parameters for the stored procedure here
	@p_active_flag			NVARCHAR(MAX),
	@p_division_id			NVARCHAR(MAX), 
	@p_stock_type			NVARCHAR(MAX), 
	@p_cutoff_yyyymmdd		NVARCHAR(MAX), 
	@p_item_id				NVARCHAR(MAX), 
	@p_plant_id				NVARCHAR(MAX), 
	@p_operation_id			NVARCHAR(MAX), 
	@p_second_ocv_time		NVARCHAR(MAX),
	@p_second_ocv_date		NVARCHAR(MAX), 
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
	DECLARE @v_item_id				NVARCHAR(MAX);
	DECLARE @v_plant_id				NVARCHAR(MAX);
	DECLARE @v_operation_id			NVARCHAR(MAX);
	DECLARE @v_second_ocv_time		NVARCHAR(MAX);
	DECLARE @v_second_ocv_date		NVARCHAR(MAX);
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
	SET @v_item_id				= NULL;
	SET @v_plant_id				= NULL;
	SET @v_operation_id			= NULL;
	SET @v_second_ocv_time		= NULL;
	SET @v_second_ocv_date		= NULL;
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
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0125_SAVE_STOCK_SECOND_OCV';
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
				SET @v_item_id = [dbo].[SCM_ARR_SPL_VAL](@p_item_id, @v_delimiter , @mst_loop_cnt) ;   
				SET @v_plant_id = [dbo].[SCM_ARR_SPL_VAL](@p_plant_id, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_operation_id	 = [dbo].[SCM_ARR_SPL_VAL](@p_operation_id	, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_second_ocv_time	 = [dbo].[SCM_ARR_SPL_VAL](@p_second_ocv_time	, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_second_ocv_date = [dbo].[SCM_ARR_SPL_VAL](@p_second_ocv_date, @v_delimiter , @mst_loop_cnt) ;   
				SET @v_qty = [dbo].[SCM_ARR_SPL_VAL](@p_qty, @v_delimiter , @mst_loop_cnt) ;	
				SET @v_chg_qty = [dbo].[SCM_ARR_SPL_VAL](@p_chg_qty, @v_delimiter , @mst_loop_cnt) ;
				SET @v_chg_rsn = [dbo].[SCM_ARR_SPL_VAL](@p_chg_rsn, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_chg_type = [dbo].[SCM_ARR_SPL_VAL](@p_chg_type, @v_delimiter , @mst_loop_cnt) ;

			END



			IF(@v_active_flag = 'I')
			BEGIN

				INSERT INTO SCP_OPMZ_INV_SECOND_OCV
				(
					  DIVISION_ID
					, CUTOFF_YYYYMMDD
					, STOCK_TYPE
					, ITEM_ID
					, PLANT_ID
					, OPERATION_ID
					, SECOND_OCV_TIME
					, SECOND_OCV_DATE
					, QTY
					, CHG_QTY
					, CHG_RSN
					, CHG_TYPE
					, CREATED_BY
					, CREATION_DATE
					, LAST_UPDATED_BY
					, LAST_UPDATE_DATE
				 )
				 VALUES
				 (
					  @v_division_id
					, @v_cutoff_yyyymmdd
					, @v_stock_type
					, @v_item_id
					, @v_plant_id
					, @v_operation_id
					, @v_second_ocv_time
					, @v_second_ocv_date
					, CASE WHEN @v_qty = '' THEN NULL ELSE @v_qty END
					, @v_chg_qty
					, @v_chg_rsn
					, @v_chg_type
					, @v_last_updated_by
					, GETDATE()
					, @v_last_updated_by
					, GETDATE()
				 )

			END
			ELSE IF( @v_active_flag ='M' )
			BEGIN

				UPDATE SCP_OPMZ_INV_SECOND_OCV
				SET CHG_QTY				= @v_chg_qty
					, CHG_RSN			= @v_chg_rsn
					, LAST_UPDATED_BY	= @v_last_updated_by 
					, LAST_UPDATE_DATE	= SYSDATETIME()
				WHERE DIVISION_ID		= @v_division_id
				AND STOCK_TYPE			= @v_stock_type
				AND CUTOFF_YYYYMMDD		= @v_cutoff_yyyymmdd
				AND ITEM_ID				= @v_item_id
				AND plant_id			= @v_plant_id
				AND operation_id		= @v_operation_id
				AND second_ocv_time		= @v_second_ocv_time
				AND second_ocv_date		= @v_second_ocv_date
				;

			END
			ELSE IF(@v_active_flag ='D')
			BEGIN
				
				DELETE SCP_OPMZ_INV_SECOND_OCV
				WHERE DIVISION_ID		= @v_division_id
				AND STOCK_TYPE			= @v_stock_type
				AND CUTOFF_YYYYMMDD		= @v_cutoff_yyyymmdd
				AND ITEM_ID				= @v_item_id
				AND plant_id			= @v_plant_id
				AND operation_id		= @v_operation_id
				AND second_ocv_time		= @v_second_ocv_time
				AND second_ocv_date		= @v_second_ocv_date

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






