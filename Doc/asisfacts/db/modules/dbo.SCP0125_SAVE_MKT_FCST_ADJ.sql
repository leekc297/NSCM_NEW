
/*
 * Program ID   : SCP0125_SAVE_MKT_FCST_ADJ
 * Description  : MKT FCST 등록,수정, 삭제
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2025/07/04   mrchois			PJ2024A332R 독립적 Planning 체계 및 Master Validation UI 구축 - Initial Release
 * 2025/07/16   mrchois			PJ2024A332R 독립적 Planning 체계 및 Master Validation UI 구축 - 삭제기능 추가
 *
 */
CREATE PROCEDURE [dbo].[SCP0125_SAVE_MKT_FCST_ADJ]

	-- Add the parameters for the stored procedure here
	@p_active_flag			NVARCHAR(MAX),
	@p_division_id			NVARCHAR(MAX), 
	@p_version_no			NVARCHAR(MAX), 
	@p_cutoff_yyyymmdd		NVARCHAR(MAX), 
	@p_project_code			NVARCHAR(MAX),  
	@p_sales_site_id		NVARCHAR(MAX), 
	@p_item_id				NVARCHAR(MAX), 
	@p_fcst_type			NVARCHAR(MAX), 
	@p_incoterms			NVARCHAR(MAX), 
	@p_plant_site_id		NVARCHAR(MAX), 
	@p_cell_prod_site_id	NVARCHAR(MAX), 
	@p_due_date				NVARCHAR(MAX), 
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
	DECLARE @v_version_no			NVARCHAR(MAX);
	DECLARE @v_cutoff_yyyymmdd		NVARCHAR(MAX);
	DECLARE @v_project_code			NVARCHAR(MAX);
	DECLARE @v_sales_site_id		NVARCHAR(MAX);
	DECLARE @v_item_id				NVARCHAR(MAX);
	DECLARE @v_fcst_type			NVARCHAR(MAX);
	DECLARE @v_incoterms			NVARCHAR(MAX);
	DECLARE @v_plant_site_id		NVARCHAR(MAX);
	DECLARE @v_cell_prod_site_id	NVARCHAR(MAX);
	DECLARE @v_due_date				NVARCHAR(MAX);
	DECLARE @v_qty					NVARCHAR(MAX);
	DECLARE @v_chg_qty				NVARCHAR(MAX);
	DECLARE @v_chg_rsn				NVARCHAR(MAX);
	DECLARE @v_chg_type				NVARCHAR(MAX);
	DECLARE @v_user_id				NVARCHAR(MAX);

	DECLARE @v_last_updated_by	NVARCHAR(MAX);
	
	SET @v_active_flag			= NULL;	
	SET @v_division_id			= NULL;
	SET @v_version_no			= NULL;	
	SET @v_cutoff_yyyymmdd		= NULL;
	SET @v_project_code			= NULL;
	SET @v_sales_site_id		= NULL;	
	SET @v_item_id				= NULL;
	SET @v_fcst_type			= NULL;	
	SET @v_incoterms			= NULL;
	SET @v_plant_site_id		= NULL;
	SET @v_cell_prod_site_id	= NULL;	
	SET @v_due_date				= NULL;
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
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0125_SAVE_MKT_FCST_ADJ';
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
				SET @v_version_no = [dbo].[SCM_ARR_SPL_VAL](@p_version_no, @v_delimiter , @mst_loop_cnt) ;	
				SET @v_cutoff_yyyymmdd = [dbo].[SCM_ARR_SPL_VAL](@p_cutoff_yyyymmdd, @v_delimiter , @mst_loop_cnt) ;
				SET @v_project_code = [dbo].[SCM_ARR_SPL_VAL](@p_project_code, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_sales_site_id	 = [dbo].[SCM_ARR_SPL_VAL](@p_sales_site_id	, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_item_id = [dbo].[SCM_ARR_SPL_VAL](@p_item_id, @v_delimiter , @mst_loop_cnt) ;   
				SET @v_fcst_type = [dbo].[SCM_ARR_SPL_VAL](@p_fcst_type, @v_delimiter , @mst_loop_cnt) ;
				SET @v_incoterms = [dbo].[SCM_ARR_SPL_VAL](@p_incoterms, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_plant_site_id	 = [dbo].[SCM_ARR_SPL_VAL](@p_plant_site_id	, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_cell_prod_site_id = [dbo].[SCM_ARR_SPL_VAL](@p_cell_prod_site_id, @v_delimiter , @mst_loop_cnt) ;	
				SET @v_due_date = [dbo].[SCM_ARR_SPL_VAL](@p_due_date, @v_delimiter , @mst_loop_cnt) ;   
				SET @v_qty = [dbo].[SCM_ARR_SPL_VAL](@p_qty, @v_delimiter , @mst_loop_cnt) ;	
				SET @v_chg_qty = [dbo].[SCM_ARR_SPL_VAL](@p_chg_qty, @v_delimiter , @mst_loop_cnt) ;
				SET @v_chg_rsn = [dbo].[SCM_ARR_SPL_VAL](@p_chg_rsn, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_chg_type = [dbo].[SCM_ARR_SPL_VAL](@p_chg_type, @v_delimiter , @mst_loop_cnt) ;

			END



			IF(@v_active_flag = 'I')
			BEGIN

				IF (@v_chg_rsn = 'New')
				BEGIN 
					/***** 중복체크 *****/
					DECLARE @cnt INTEGER;
					SET @cnt = 0;

					SELECT @cnt = COUNT(*)
					FROM DM_PLN_NET_DEMAND  WITH(NOLOCK)
					WHERE DIVISION_ID = @v_division_id
					AND VERSION_NO = @v_version_no
					AND CUTOFF_YYYYMMDD		= @v_cutoff_yyyymmdd
					AND PROJECT_CODE		= @v_project_code
					AND SCM_SITE_ID			= @v_sales_site_id
					AND ITEM_ID				= @v_item_id
					AND FCST_TYPE			= @v_fcst_type
					AND INCOTERMS			= @v_incoterms
					AND PLANT_SITE_ID		= @v_plant_site_id
					AND CELL_PROD_SITE_ID	= @v_cell_prod_site_id
					AND YYYYMMDD			= @v_due_date

					IF(@cnt > 0)
					BEGIN
						SET @v_err_code    = 99010 ; 
						SET @v_err_message = N' 신규 입력 데이터 중 중복된 데이터가 있습니다.';
						THROW  @v_err_code, @v_err_message , 1; --예외발생
					END
					/***** 중복체크 *****/
				END

				INSERT INTO SCP_OPMZ_DMD_ADJ
				(
					   DIVISION_ID
					   ,VERSION_NO
					   ,CUTOFF_YYYYMMDD
					   ,PROJECT_CODE
					   ,SCM_SITE_ID
					   ,ITEM_ID
					   ,FCST_TYPE
					   ,INCOTERMS
					   ,PLANT_SITE_ID
					   ,CELL_PROD_SITE_ID
					   ,DUE_DATE
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
					   ,@v_version_no
					   ,@v_cutoff_yyyymmdd
					   ,@v_project_code
					   ,@v_sales_site_id
					   ,@v_item_id
					   ,@v_fcst_type
					   ,@v_incoterms
					   ,@v_plant_site_id
					   ,@v_cell_prod_site_id
					   ,@v_due_date
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

				UPDATE SCP_OPMZ_DMD_ADJ
				SET CHG_QTY				= @v_chg_qty
					, CHG_RSN			= @v_chg_rsn
					, LAST_UPDATED_BY	= @v_last_updated_by 
					, LAST_UPDATE_DATE	= SYSDATETIME()
				WHERE DIVISION_ID		= @v_division_id
				AND VERSION_NO			= @v_version_no
				AND CUTOFF_YYYYMMDD		= @v_cutoff_yyyymmdd
				AND PROJECT_CODE		= @v_project_code
				AND SCM_SITE_ID			= @v_sales_site_id
				AND ITEM_ID				= @v_item_id
				AND FCST_TYPE			= @v_fcst_type
				AND INCOTERMS			= @v_incoterms
				AND PLANT_SITE_ID		= @v_plant_site_id
				AND CELL_PROD_SITE_ID	= @v_cell_prod_site_id
				AND DUE_DATE			= @v_due_date
				;

			END
			--삭제기능 추가 (2025-07-16)
			ELSE IF(@v_active_flag ='D')
			BEGIN
				
				DELETE SCP_OPMZ_DMD_ADJ
				WHERE DIVISION_ID		= @v_division_id
				AND VERSION_NO			= @v_version_no
				AND CUTOFF_YYYYMMDD		= @v_cutoff_yyyymmdd
				AND PROJECT_CODE		= @v_project_code
				AND SCM_SITE_ID			= @v_sales_site_id
				AND ITEM_ID				= @v_item_id
				AND FCST_TYPE			= @v_fcst_type
				AND INCOTERMS			= @v_incoterms
				AND PLANT_SITE_ID		= @v_plant_site_id
				AND CELL_PROD_SITE_ID	= @v_cell_prod_site_id
				AND DUE_DATE			= @v_due_date

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






