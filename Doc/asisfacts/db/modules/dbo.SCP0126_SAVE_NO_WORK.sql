
/*
 * Program ID   : SCP0126_SAVE_NO_WORK
 * Description  : No Work 등록, 수정, 삭제 처리
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2025/07/25   mrchois			PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - Initial Release
 * 2025/10/13   mrchois			PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - 비조업 일괄입력 기능 추가
 * 2025/11/05   mrchois			PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - Line Type 추가
 * 2025/12/04   mrchois			PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - Week 단위 조회 및 입력 방식 추가
 * 2026/06/29	ymh				E20260624-000826 OPT CAPA → No Work UI 컬럼 추가 요청 (2026-06-29)
 * 2026/10/08	ymh				E20260929-000580 비조업 로직 수정 요청의 건(OPT CAPA - No Work)
 *
 */
CREATE PROCEDURE [dbo].[SCP0126_SAVE_NO_WORK]

	-- Add the parameters for the stored procedure here
	@p_active_flag			NVARCHAR(MAX),
	@p_division_id			NVARCHAR(MAX), 
	@p_plant_id				NVARCHAR(MAX), 
	@p_line_id				NVARCHAR(MAX), 
	@p_operation_id			NVARCHAR(MAX),  
	@p_line_type			NVARCHAR(MAX),  --[PJ20257329] Line Type 추가 (2025-11-05)
	@p_no_work_date			NVARCHAR(MAX), 
	@p_off_time				NVARCHAR(MAX), 
	@p_type					NVARCHAR(MAX),  -- E20260624-000826 OPT CAPA → No Work UI 컬럼 추가 요청 (2026-06-29)
	@p_desc					NVARCHAR(MAX), 
	@p_valid_yn				NVARCHAR(MAX), 
	@p_fix					NVARCHAR(MAX),	--[PJ20257329] 비조업 일괄입력 기능 추가 (2025-10-13)
	@p_pre_division_id		NVARCHAR(MAX), 
	@p_pre_plant_id			NVARCHAR(MAX), 
	@p_pre_line_id			NVARCHAR(MAX), 
	@p_pre_operation_id		NVARCHAR(MAX),  
	@p_pre_line_type		NVARCHAR(MAX),	--[PJ20257329] Line Type 추가 (2025-11-05)
	@p_pre_no_work_date		NVARCHAR(MAX), 
	@p_pre_type				NVARCHAR(MAX),  -- E20260929-000580 추가.
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
	DECLARE @v_line_type			NVARCHAR(MAX);		--[PJ20257329] Line Type 추가 (2025-11-05)
	DECLARE @v_no_work_date			NVARCHAR(MAX);
	DECLARE @v_off_time				NVARCHAR(MAX);
	DECLARE @v_type					NVARCHAR(MAX);		-- E20260624-000826 OPT CAPA → No Work UI 컬럼 추가 요청 (2026-06-29)
	DECLARE @v_desc					NVARCHAR(MAX);
	DECLARE @v_valid_yn				NVARCHAR(MAX);
	DECLARE @v_fix					NVARCHAR(MAX);		--[PJ20257329] 비조업 일괄입력 기능 추가 (2025-10-13)
	DECLARE @v_pre_division_id			NVARCHAR(MAX);
	DECLARE @v_pre_plant_id				NVARCHAR(MAX);
	DECLARE @v_pre_line_id				NVARCHAR(MAX);
	DECLARE @v_pre_operation_id			NVARCHAR(MAX);
	DECLARE @v_pre_line_type			NVARCHAR(MAX);	--[PJ20257329] Line Type 추가 (2025-11-05)
	DECLARE @v_pre_no_work_date			NVARCHAR(MAX);
	DECLARE @v_pre_type					NVARCHAR(MAX); -- E20260929-000580

	DECLARE @v_last_updated_by	NVARCHAR(MAX);
	
	SET @v_active_flag			= NULL;	
	SET @v_division_id			= NULL;
	SET @v_plant_id				= NULL;	
	SET @v_line_id				= NULL;
	SET @v_operation_id			= NULL;	
	SET @v_line_type			= NULL;		--[PJ20257329] Line Type 추가 (2025-11-05)
	SET @v_no_work_date			= NULL;
	SET @v_off_time				= NULL;
	SET @v_type					= NULL;		-- E20260624-000826 OPT CAPA → No Work UI 컬럼 추가 요청 (2026-06-29)	
	SET @v_desc					= NULL;	
	SET @v_valid_yn				= NULL;
	SET @v_fix					= NULL;		--[PJ20257329] 비조업 일괄입력 기능 추가 (2025-10-13)
	SET @v_last_updated_by		= NULL;

	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^' 

	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;
		
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0126_SAVE_NO_WORK';
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
				SET @v_line_type = [dbo].[SCM_ARR_SPL_VAL](@p_line_type, @v_delimiter , @mst_loop_cnt) ;	--[PJ20257329] Line Type 추가 (2025-11-05)
				SET @v_no_work_date	 = [dbo].[SCM_ARR_SPL_VAL](@p_no_work_date	, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_off_time = [dbo].[SCM_ARR_SPL_VAL](@p_off_time, @v_delimiter , @mst_loop_cnt) ;   
				SET @v_type = [dbo].[SCM_ARR_SPL_VAL](@p_type, @v_delimiter , @mst_loop_cnt) ;
				SET @v_desc = [dbo].[SCM_ARR_SPL_VAL](@p_desc, @v_delimiter , @mst_loop_cnt) ;
				SET @v_valid_yn = [dbo].[SCM_ARR_SPL_VAL](@p_valid_yn, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_fix = [dbo].[SCM_ARR_SPL_VAL](@p_fix, @v_delimiter , @mst_loop_cnt) ;	--[PJ20257329] 비조업 일괄입력 기능 추가 (2025-10-13)
				SET @v_pre_division_id = [dbo].[SCM_ARR_SPL_VAL](@p_pre_division_id, @v_delimiter , @mst_loop_cnt) ;   
				SET @v_pre_plant_id = [dbo].[SCM_ARR_SPL_VAL](@p_pre_plant_id, @v_delimiter , @mst_loop_cnt) ;	
				SET @v_pre_line_id = [dbo].[SCM_ARR_SPL_VAL](@p_pre_line_id, @v_delimiter , @mst_loop_cnt) ;
				SET @v_pre_operation_id = [dbo].[SCM_ARR_SPL_VAL](@p_pre_operation_id, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_pre_line_type = [dbo].[SCM_ARR_SPL_VAL](@p_pre_line_type, @v_delimiter , @mst_loop_cnt) ;	--[PJ20257329] Line Type 추가 (2025-11-05)
				SET @v_pre_no_work_date	 = [dbo].[SCM_ARR_SPL_VAL](@p_pre_no_work_date	, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_pre_type	 = [dbo].[SCM_ARR_SPL_VAL](@p_pre_type	, @v_delimiter , @mst_loop_cnt) ;  -- E20260929-000580				

			END


			--삭제가 아닌 경우, 중복체크
			IF (@v_active_flag <> 'D')
			BEGIN 
				/***** 중복체크 *****/
				DECLARE @cnt INTEGER;
				SET @cnt = 0;

				SELECT @cnt = COUNT(*)
				FROM SCP_OPMZ_NO_WORK  WITH(NOLOCK)
				WHERE DIVISION_ID	= @v_division_id
				AND PLANT_ID		= @v_plant_id
				AND LINE_ID			= @v_line_id
				AND OPERATION_ID	= @v_operation_id
				AND LINE_TYPE		= @v_line_type		--[PJ20257329] Line Type 추가 (2025-11-05)
				AND	[TYPE]			= IIF(ISNULL(@v_type,'')='','-',@v_type)	-- E20260929-000580  중복체크시 TYPE컬럼 반영.
				AND NO_WORK_DATE	= @v_no_work_date

				IF(@cnt > 0)
				BEGIN

					IF (@v_active_flag = 'I')
					BEGIN

						SET @v_err_code    = 99010 ; 
						SET @v_err_message = N' 신규 입력 데이터 중 중복된 데이터가 있습니다.';
						THROW  @v_err_code, @v_err_message , 1; --예외발생
					END
					ELSE
					BEGIN
						--Key값이 변경된 경우만 중복 판단
						IF (@v_division_id != @v_pre_division_id OR @v_plant_id != @v_pre_plant_id OR @v_line_id != @v_pre_line_id
							OR @v_operation_id != @v_pre_operation_id OR @v_line_type != @v_pre_line_type OR @v_no_work_date != @v_pre_no_work_date --[PJ20257329] Line Type 추가 (2025-11-05)
							OR @v_type != @v_pre_type -- E20260929-000580 키중복 체크시 TYPE(사유) 추가.
							)	
						BEGIN
							SET @v_err_code    = 99010 ; 
							SET @v_err_message = N'수정한 데이터 중 중복된 데이터가 있습니다.';
							THROW  @v_err_code, @v_err_message , 1; --예외발생
						END

					END 
				END


			END

			--신규입력
			IF(@v_active_flag = 'I')
			BEGIN

				INSERT INTO SCP_OPMZ_NO_WORK
				(
					DIVISION_ID
					, PLANT_ID
					, LINE_ID
					, OPERATION_ID
					, LINE_TYPE			--[PJ20257329] Line Type 추가 (2025-11-05)
					, NO_WORK_DATE
					, OFF_TIME
					, [DESC]
					, VALID_YN
					, ATTRIBUTE1		--[PJ20257329] 비조업 일괄입력 기능 추가 (2025-10-13)
					, [TYPE]			-- E20260624-000826 OPT CAPA → No Work UI 컬럼 추가 요청 (2026-06-29)
					, CREATED_BY
					, CREATION_DATE
					, LAST_UPDATED_BY
					, LAST_UPDATE_DATE
				)			
				VALUES
				(
					@v_division_id
					,@v_plant_id
					,@v_line_id
					,@v_operation_id
					,@v_line_type		--[PJ20257329] Line Type 추가 (2025-11-05)
					,@v_no_work_date
					,CONVERT(INT, ROUND(CONVERT(NUMERIC(20,10) , @v_off_time) * 86400, 1))		--소수점 1자리에서 반올림		--[PJ20257329] Week 단위 조회 및 입력 방식 추가 (2025-12-04)
					,@v_desc
					,@v_valid_yn
					,@v_fix				--[PJ20257329] 비조업 일괄입력 기능 추가 (2025-10-13)
					,@v_type			-- E20260624-000826 OPT CAPA → No Work UI 컬럼 추가 요청 (2026-06-29)
					,@v_last_updated_by
					,GETDATE()
					,@v_last_updated_by
					,GETDATE()
				)

			END
			--수정
			ELSE IF( @v_active_flag ='M' )
			BEGIN

				UPDATE SCP_OPMZ_NO_WORK
				SET   DIVISION_ID		= @v_division_id		--변경된 값
					, PLANT_ID			= @v_plant_id
					, LINE_ID			= @v_line_id
					, OPERATION_ID		= @v_operation_id
					, LINE_TYPE			= @v_line_type			--[PJ20257329] Line Type 추가 (2025-11-05)
					, NO_WORK_DATE		= @v_no_work_date
					, OFF_TIME			= CONVERT(INT, ROUND(CONVERT(NUMERIC(20,10) , @v_off_time) * 86400, 1))		--소수점 1자리에서 반올림		--[PJ20257329] Week 단위 조회 및 입력 방식 추가 (2025-12-04)
					, [DESC]			= @v_desc
					, VALID_YN			= @v_valid_yn
					, ATTRIBUTE1		= @v_fix				--[PJ20257329] 비조업 일괄입력 기능 추가 (2025-10-13)
					, [TYPE]			= @v_type				-- E20260624-000826 OPT CAPA → No Work UI 컬럼 추가 요청 (2026-06-29) / -- E20260929-000580 ATTRIBUTE2 -> TYPE 으로 변경
					, LAST_UPDATED_BY	= @v_last_updated_by
					, LAST_UPDATE_DATE	= GETDATE()
				WHERE DIVISION_ID		= @v_pre_division_id	--이전 Key값
				AND PLANT_ID			= @v_pre_plant_id
				AND LINE_ID				= @v_pre_line_id
				AND OPERATION_ID		= @v_pre_operation_id
				AND LINE_TYPE			= @v_pre_line_type		--[PJ20257329] Line Type 추가 (2025-11-05)
				AND NO_WORK_DATE		= @v_pre_no_work_date
				AND [TYPE]				= @v_pre_type			-- E20260929-000580 ATTRIBUTE2 -> TYPE 으로 변경
				;

			END
			--삭제
			ELSE IF(@v_active_flag ='D')
			BEGIN
				
				DELETE SCP_OPMZ_NO_WORK
				WHERE DIVISION_ID		= @v_pre_division_id
				AND PLANT_ID			= @v_pre_plant_id
				AND LINE_ID				= @v_pre_line_id
				AND OPERATION_ID		= @v_pre_operation_id
				AND LINE_TYPE			= @v_line_type			--[PJ20257329] Line Type 추가 (2025-11-05)
				AND	[TYPE]				= IIF(ISNULL(@v_type,'')='','-',@v_type)	-- E20260929-000580 ATTRIBUTE2 -> TYPE 으로 변경
				AND NO_WORK_DATE		= @v_pre_no_work_date

			END

		END



		-- E20260929-000580 로직 시작
		-- 모든 데이터 입력 완료후 입력데이터 기반으로 유효성 검사후 오류발생시 롤백진행.
		-- 1. 여기서 롤백하면 START , END 모두 남지 않고 ERROR 만 남는것으로 보이는데 그러면 괜찮은지?
		-- 2. 저장시 정상 저장 , 롤백시 정상롤백 확인.
		DECLARE @sum INTEGER;
		SET @mst_loop_cnt = 0
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
				SET @v_line_type = [dbo].[SCM_ARR_SPL_VAL](@p_line_type, @v_delimiter , @mst_loop_cnt) ;	--[PJ20257329] Line Type 추가 (2025-11-05)
				SET @v_no_work_date	 = [dbo].[SCM_ARR_SPL_VAL](@p_no_work_date	, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_off_time = [dbo].[SCM_ARR_SPL_VAL](@p_off_time, @v_delimiter , @mst_loop_cnt) ;   
				SET @v_type = [dbo].[SCM_ARR_SPL_VAL](@p_type, @v_delimiter , @mst_loop_cnt) ;
				SET @v_desc = [dbo].[SCM_ARR_SPL_VAL](@p_desc, @v_delimiter , @mst_loop_cnt) ;
				SET @v_valid_yn = [dbo].[SCM_ARR_SPL_VAL](@p_valid_yn, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_fix = [dbo].[SCM_ARR_SPL_VAL](@p_fix, @v_delimiter , @mst_loop_cnt) ;	--[PJ20257329] 비조업 일괄입력 기능 추가 (2025-10-13)
				SET @v_pre_division_id = [dbo].[SCM_ARR_SPL_VAL](@p_pre_division_id, @v_delimiter , @mst_loop_cnt) ;   
				SET @v_pre_plant_id = [dbo].[SCM_ARR_SPL_VAL](@p_pre_plant_id, @v_delimiter , @mst_loop_cnt) ;	
				SET @v_pre_line_id = [dbo].[SCM_ARR_SPL_VAL](@p_pre_line_id, @v_delimiter , @mst_loop_cnt) ;
				SET @v_pre_operation_id = [dbo].[SCM_ARR_SPL_VAL](@p_pre_operation_id, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_pre_line_type = [dbo].[SCM_ARR_SPL_VAL](@p_pre_line_type, @v_delimiter , @mst_loop_cnt) ;	--[PJ20257329] Line Type 추가 (2025-11-05)
				SET @v_pre_no_work_date	 = [dbo].[SCM_ARR_SPL_VAL](@p_pre_no_work_date	, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_pre_type	 = [dbo].[SCM_ARR_SPL_VAL](@p_pre_type	, @v_delimiter , @mst_loop_cnt) ;  -- E20260929-000580				

				
				SET @sum = 0;

				SELECT @sum = SUM(OFF_TIME)
				FROM SCP_OPMZ_NO_WORK  WITH(NOLOCK)
				WHERE DIVISION_ID	= @v_division_id
				AND PLANT_ID		= @v_plant_id
				AND LINE_ID			= @v_line_id
				AND OPERATION_ID	= @v_operation_id
				AND LINE_TYPE		= @v_line_type		--[PJ20257329] Line Type 추가 (2025-11-05)
				AND NO_WORK_DATE	= @v_no_work_date

				/***** OFF TIME 하루 체크 *****/
				IF (@sum > 86400)
				BEGIN
					SET @v_err_code    = 99010 ; 
					SET @v_err_message = N'입력 데이터의 Off Time이 하루(1)를 초과합니다.';
					THROW  @v_err_code, @v_err_message , 1; --예외발생
				END
				/***** OFF TIME 하루 체크 *****/

			END
		END
		-- E20260929-000580 로직 끝

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






