
/*
 * Program ID   : SCP0126_SAVE_DAILY_CAPA
 * Description  : Daily Capa 등록, 수정, 삭제 처리
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2025/08/07   mrchois			PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - Initial Release
 *
 */
CREATE PROCEDURE [dbo].[SCP0126_SAVE_DAILY_CAPA]

	-- Add the parameters for the stored procedure here
	@p_active_flag			NVARCHAR(MAX),
	@p_division_id			NVARCHAR(MAX), 
	@p_plant_id				NVARCHAR(MAX), 
	@p_line_id				NVARCHAR(MAX), 
	@p_operation_id			NVARCHAR(MAX), 
	@p_item_id				NVARCHAR(MAX), 
	@p_yyyymm				NVARCHAR(MAX), 

	@p_capa					NVARCHAR(MAX), 
	@p_m_min				NVARCHAR(MAX), 
	@p_lane					NVARCHAR(MAX),  
	@p_wide_yn				NVARCHAR(MAX),
	@p_prdn_oper_rt			NVARCHAR(MAX),  
	@p_valid_yn				NVARCHAR(MAX),

	@p_pre_division_id		NVARCHAR(MAX), 
	@p_pre_plant_id			NVARCHAR(MAX), 
	@p_pre_line_id			NVARCHAR(MAX), 
	@p_pre_operation_id		NVARCHAR(MAX),   
	@p_pre_item_id			NVARCHAR(MAX), 
	@p_pre_yyyymm			NVARCHAR(MAX), 

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
	DECLARE @v_plant_id				NVARCHAR(MAX);
	DECLARE @v_line_id				NVARCHAR(MAX);
	DECLARE @v_operation_id			NVARCHAR(MAX);
	DECLARE @v_item_id				NVARCHAR(MAX);
	DECLARE @v_yyyymm				NVARCHAR(MAX);
	DECLARE @v_capa					NVARCHAR(MAX);
	DECLARE @v_m_min				NVARCHAR(MAX);
	DECLARE @v_lane					NVARCHAR(MAX);
	DECLARE @v_wide_yn				NVARCHAR(MAX);
	DECLARE @v_prdn_oper_rt			NVARCHAR(MAX);
	DECLARE @v_valid_yn				NVARCHAR(MAX);

	DECLARE @v_pre_division_id		NVARCHAR(MAX);
	DECLARE @v_pre_plant_id			NVARCHAR(MAX);
	DECLARE @v_pre_line_id			NVARCHAR(MAX);
	DECLARE @v_pre_operation_id		NVARCHAR(MAX);
	DECLARE @v_pre_item_id			NVARCHAR(MAX);
	DECLARE @v_pre_yyyymm			NVARCHAR(MAX);

	DECLARE @v_last_updated_by		NVARCHAR(MAX);
	
	SET @v_active_flag			= NULL;	
	SET @v_division_id			= NULL;
	SET @v_plant_id				= NULL;	
	SET @v_line_id				= NULL;
	SET @v_operation_id			= NULL;	
	SET @v_item_id				= NULL;
	SET @v_yyyymm				= NULL;
	SET @v_capa					= NULL;	
	SET @v_m_min				= NULL;
	SET @v_lane					= NULL;
	SET @v_wide_yn				= NULL;
	SET @v_prdn_oper_rt			= NULL;
	SET @v_valid_yn				= NULL;
	SET @v_last_updated_by		= NULL;

	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^' 

	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;
		
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0126_SAVE_DAILY_CAPA';
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
				SET @v_plant_id = [dbo].[SCM_ARR_SPL_VAL](@p_plant_id, @v_delimiter , @mst_loop_cnt) ;	
				SET @v_line_id = [dbo].[SCM_ARR_SPL_VAL](@p_line_id, @v_delimiter , @mst_loop_cnt) ;
				SET @v_operation_id = [dbo].[SCM_ARR_SPL_VAL](@p_operation_id, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_item_id	 = [dbo].[SCM_ARR_SPL_VAL](@p_item_id	, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_yyyymm = [dbo].[SCM_ARR_SPL_VAL](@p_yyyymm, @v_delimiter , @mst_loop_cnt) ;  
				
				SET @v_capa = [dbo].[SCM_ARR_SPL_VAL](@p_capa, @v_delimiter , @mst_loop_cnt) ;
				SET @v_m_min = [dbo].[SCM_ARR_SPL_VAL](@p_m_min, @v_delimiter , @mst_loop_cnt) ;
				SET @v_lane = [dbo].[SCM_ARR_SPL_VAL](@p_lane, @v_delimiter , @mst_loop_cnt) ;
				SET @v_wide_yn = [dbo].[SCM_ARR_SPL_VAL](@p_wide_yn, @v_delimiter , @mst_loop_cnt) ;
				SET @v_prdn_oper_rt = [dbo].[SCM_ARR_SPL_VAL](@p_prdn_oper_rt, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_valid_yn = [dbo].[SCM_ARR_SPL_VAL](@p_valid_yn, @v_delimiter , @mst_loop_cnt) ;

				SET @v_pre_division_id = [dbo].[SCM_ARR_SPL_VAL](@p_pre_division_id, @v_delimiter , @mst_loop_cnt) ;   
				SET @v_pre_plant_id = [dbo].[SCM_ARR_SPL_VAL](@p_pre_plant_id, @v_delimiter , @mst_loop_cnt) ;	
				SET @v_pre_line_id = [dbo].[SCM_ARR_SPL_VAL](@p_pre_line_id, @v_delimiter , @mst_loop_cnt) ;
				SET @v_pre_operation_id = [dbo].[SCM_ARR_SPL_VAL](@p_pre_operation_id, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_pre_item_id	 = [dbo].[SCM_ARR_SPL_VAL](@p_pre_item_id	, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_pre_yyyymm	 = [dbo].[SCM_ARR_SPL_VAL](@p_pre_yyyymm	, @v_delimiter , @mst_loop_cnt) ; 

			END

			IF (ISNULL(@v_prdn_oper_rt, '') = '')
				SET @v_prdn_oper_rt = NULL;

			--신규입력
			IF(@v_active_flag = 'I')
			BEGIN

				/***** 중복체크 *****/
				DECLARE @cnt INTEGER;
				SET @cnt = 0;

				SELECT @cnt = COUNT(*)
				FROM SCP_OPMZ_DDLY_CAPA  WITH(NOLOCK)
				WHERE DIVISION_ID	= @v_division_id
				AND PLANT_ID		= @v_plant_id
				AND LINE_ID			= @v_line_id
				AND OPERATION_ID	= @v_operation_id
				AND ITEM_ID			= @v_item_id
				AND YYYYMM			= @v_yyyymm

				IF(@cnt > 0)
				BEGIN

					SET @v_err_code    = 99010 ; 
					SET @v_err_message = N' 신규 입력 데이터 중 중복된 데이터가 있습니다.';
					THROW  @v_err_code, @v_err_message , 1; --예외발생
				END
				/***** 중복체크 *****/


				INSERT INTO SCP_OPMZ_DDLY_CAPA
				(
					  DIVISION_ID
					, PLANT_ID
					, LINE_ID
					, OPERATION_ID
					, ITEM_ID
					, YYYYMM
					, CAPA
					, M_MIN
					, LANE
					, WIDE_YN
					, PRDN_OPER_RT
					, VALID_YN
					, CREATED_BY
					, CREATION_DATE
					, LAST_UPDATED_BY
					, LAST_UPDATE_DATE
				)			
				VALUES
				(
					  @v_division_id
					, @v_plant_id
					, @v_line_id
					, @v_operation_id
					, @v_item_id
					, @v_yyyymm
					, CONVERT(numeric, @v_capa)
					, @v_m_min
					, @v_lane
					, @v_wide_yn
					--, CASE WHEN ISNULL(@v_prdn_oper_rt, '') = '' THEN @v_prdn_oper_rt ELSE CONVERT(numeric, @v_prdn_oper_rt) END
					, @v_prdn_oper_rt
					, @v_valid_yn
					, @v_last_updated_by
					, GETDATE()
					, @v_last_updated_by
					, GETDATE()
				)

			END
			--수정
			ELSE IF( @v_active_flag ='M' )
			BEGIN

				UPDATE SCP_OPMZ_DDLY_CAPA
				SET   CAPA				= CONVERT(numeric, @v_capa)		--변경된 값
					, M_MIN				= @v_m_min
					, LANE				= @v_lane
					, WIDE_YN			= @v_wide_yn
					--, PRDN_OPER_RT		= CASE WHEN ISNULL(@v_prdn_oper_rt, '') = '' THEN @v_prdn_oper_rt ELSE CONVERT(numeric, @v_prdn_oper_rt) END
					, PRDN_OPER_RT		= @v_prdn_oper_rt
					, VALID_YN			= @v_valid_yn
					, LAST_UPDATED_BY	= @v_last_updated_by
					, LAST_UPDATE_DATE	= GETDATE()
				WHERE DIVISION_ID		= @v_pre_division_id	--이전 Key값
				AND PLANT_ID			= @v_pre_plant_id
				AND LINE_ID				= @v_pre_line_id
				AND OPERATION_ID		= @v_pre_operation_id
				AND ITEM_ID				= @v_pre_item_id
				AND YYYYMM				= @v_pre_yyyymm
				;

			END
			--삭제
			ELSE IF(@v_active_flag ='D')
			BEGIN
				
				DELETE SCP_OPMZ_DDLY_CAPA
				WHERE DIVISION_ID		= @v_pre_division_id	--이전 Key값
				AND PLANT_ID			= @v_pre_plant_id
				AND LINE_ID				= @v_pre_line_id
				AND OPERATION_ID		= @v_pre_operation_id
				AND ITEM_ID				= @v_pre_item_id
				AND YYYYMM				= @v_pre_yyyymm
				;

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






