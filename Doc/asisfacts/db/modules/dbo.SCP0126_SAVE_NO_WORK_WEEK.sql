
/*
 * Program ID   : SCP0126_SAVE_NO_WORK_WEEK
 * Description  : No Work Week 등록
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2025/12/04   mrchois			PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - Initial Release
 * 2026/06/29	ymh				E20260624-000826 OPT CAPA → No Work UI 컬럼 추가 요청 (2026-06-29)
 * 2026/10/08	ymh				E20260929-000580 비조업 로직 수정 요청의 건(OPT CAPA - No Work)
 *
 */
CREATE PROCEDURE [dbo].[SCP0126_SAVE_NO_WORK_WEEK]

	-- Add the parameters for the stored procedure here
	@p_active_flag			NVARCHAR(MAX),
	@p_division_id			NVARCHAR(MAX), 
	@p_plant_id				NVARCHAR(MAX), 
	@p_line_id				NVARCHAR(MAX), 
	@p_operation_id			NVARCHAR(MAX),  
	@p_line_type			NVARCHAR(MAX), 
	@p_week_name			nvarchar(MAX), 
	@p_off_time				NVARCHAR(MAX), 
	@p_type					NVARCHAR(MAX),  -- E20260624-000826 OPT CAPA → No Work UI 컬럼 추가 요청 (2026-06-29)
	@p_desc					NVARCHAR(MAX), 
	@p_pre_division_id		NVARCHAR(MAX),	-- E20260929-000580 중복체크를 위해 추가.
	@p_pre_plant_id			NVARCHAR(MAX),  -- E20260929-000580 중복체크를 위해 추가.
	@p_pre_line_id			NVARCHAR(MAX),  -- E20260929-000580 중복체크를 위해 추가.
	@p_pre_operation_id		NVARCHAR(MAX),  -- E20260929-000580 중복체크를 위해 추가.
	@p_pre_line_type		NVARCHAR(MAX),	-- E20260929-000580 중복체크를 위해 추가.
	@p_pre_week_name		NVARCHAR(MAX),  -- E20260929-000580 중복체크를 위해 추가.
	@p_pre_type				NVARCHAR(MAX),  -- E20260929-000580 중복체크를 위해 추가.
	@p_user_id				NVARCHAR(MAX)

AS

BEGIN

	SET NOCOUNT ON;

	DECLARE @recv_seq			NVARCHAR(MAX);
	SET @recv_seq = NULL;		
	SET @recv_seq = @p_division_id;

	DECLARE @v_active_flag		NVARCHAR(MAX);
	DECLARE @v_division_id		NVARCHAR(MAX);
	DECLARE @v_plant_id			NVARCHAR(MAX);
	DECLARE @v_line_id			NVARCHAR(MAX);
	DECLARE @v_operation_id		NVARCHAR(MAX);
	DECLARE @v_line_type		NVARCHAR(MAX);
	DECLARE @v_week_name		NVARCHAR(MAX);
	DECLARE @v_week_start_date	NVARCHAR(MAX);
	DECLARE @v_week_end_date	NVARCHAR(MAX);
	DECLARE @v_off_time			NVARCHAR(MAX);
	DECLARE @v_type				NVARCHAR(MAX); -- E20260624-000826 OPT CAPA → No Work UI 컬럼 추가 요청 (2026-06-29)
	DECLARE @v_desc				NVARCHAR(MAX);
	DECLARE @v_last_updated_by	NVARCHAR(MAX);

	DECLARE @v_pre_division_id			NVARCHAR(MAX); -- E20260929-000580 추가
	DECLARE @v_pre_plant_id				NVARCHAR(MAX); -- E20260929-000580 추가
	DECLARE @v_pre_line_id				NVARCHAR(MAX); -- E20260929-000580 추가
	DECLARE @v_pre_operation_id			NVARCHAR(MAX); -- E20260929-000580 추가
	DECLARE @v_pre_line_type			NVARCHAR(MAX); -- E20260929-000580 추가
	DECLARE @v_pre_week_name			NVARCHAR(MAX); -- E20260929-000580 추가
	DECLARE @v_pre_type					NVARCHAR(MAX); -- E20260929-000580 추가

	-- E20260929-000580 로그
	PRINT CONCAT(N'넘어온 파라미터',@v_type)

	--SET @v_seq					= NULL;	
	SET @v_off_time				= NULL;
	SET @v_desc					= NULL;	
	
	SET @v_active_flag			= NULL;
	SET @v_division_id			= NULL;
	SET @v_plant_id				= NULL;	
	SET @v_line_id				= NULL;
	SET @v_operation_id			= NULL;	
	SET @v_line_type			= NULL;	
	SET @v_week_name			= NULL;	
	SET @v_week_start_date		= NULL;
	SET @v_week_end_date		= NULL;	
	SET @v_off_time				= NULL;
	SET @v_type					= NULL;			-- E20260624-000826 OPT CAPA → No Work UI 컬럼 추가 요청 (2026-06-29)
	SET @v_desc					= NULL;	
	SET @v_last_updated_by		= NULL;

	



	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^' 

	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;

	SET @v_last_updated_by		= NULL;
		
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0126_SAVE_NO_WORK_WEEK';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	DECLARE @v_data_dup_cnt  INT=0;

	DECLARE @f_apply_off_time	numeric(20,10);
	DECLARE @f_fix_off_time		numeric(20,10);
	DECLARE @f_off_time			numeric(20,10);
	DECLARE @off_time			int;

	DECLARE @startdate			DATETIME;
    DECLARE @enddate			DATETIME;
    DECLARE @no_work_date		DATETIME;

	DECLARE @cnt INTEGER;
	SET @cnt = 0;

	-- E20260929-000580
	DECLARE @dsum INTEGER;
	SET @dsum = 0;
	

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

		SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_division_id, @v_delimiter);

		-- E20260929-000580 넘어온 정보기준 전체 삭제로직 마무리 하고 입력로직 진행.
		WHILE LEN(@recv_seq) > 0 AND @mst_loop_cnt < @max_loop_cnt
		BEGIN
			SET @mst_loop_cnt = @mst_loop_cnt + 1;

			-- 각 컬럼들에 대한 스플릿처리로직 스타트
			BEGIN

				SET @v_active_flag = [dbo].[SCM_ARR_SPL_VAL](@p_active_flag, @v_delimiter , @mst_loop_cnt) ;
				SET @v_division_id = [dbo].[SCM_ARR_SPL_VAL](@p_division_id, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_plant_id = [dbo].[SCM_ARR_SPL_VAL](@p_plant_id, @v_delimiter , @mst_loop_cnt) ;   
				SET @v_line_id = [dbo].[SCM_ARR_SPL_VAL](@p_line_id, @v_delimiter , @mst_loop_cnt) ;   
				SET @v_operation_id = [dbo].[SCM_ARR_SPL_VAL](@p_operation_id, @v_delimiter , @mst_loop_cnt) ;
				SET @v_line_type = [dbo].[SCM_ARR_SPL_VAL](@p_line_type, @v_delimiter , @mst_loop_cnt) ;
				SET @v_week_name = [dbo].[SCM_ARR_SPL_VAL](@p_week_name, @v_delimiter , @mst_loop_cnt) ;
				SET @v_off_time = [dbo].[SCM_ARR_SPL_VAL](@p_off_time, @v_delimiter , @mst_loop_cnt) ;    
				SET @v_type = [dbo].[SCM_ARR_SPL_VAL](@p_type, @v_delimiter , @mst_loop_cnt) ; -- E20260624-000826 OPT CAPA → No Work UI 컬럼 추가 요청 (2026-06-29)
				SET @v_desc = [dbo].[SCM_ARR_SPL_VAL](@p_desc, @v_delimiter , @mst_loop_cnt) ;

				SET @v_pre_division_id = [dbo].[SCM_ARR_SPL_VAL](@p_pre_division_id, @v_delimiter , @mst_loop_cnt) ;   
				SET @v_pre_plant_id = [dbo].[SCM_ARR_SPL_VAL](@p_pre_plant_id, @v_delimiter , @mst_loop_cnt) ;	
				SET @v_pre_line_id = [dbo].[SCM_ARR_SPL_VAL](@p_pre_line_id, @v_delimiter , @mst_loop_cnt) ;
				SET @v_pre_operation_id = [dbo].[SCM_ARR_SPL_VAL](@p_pre_operation_id, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_pre_line_type = [dbo].[SCM_ARR_SPL_VAL](@p_pre_line_type, @v_delimiter , @mst_loop_cnt) ;	--[PJ20257329] Line Type 추가 (2025-11-05)
				SET @v_pre_week_name	 = [dbo].[SCM_ARR_SPL_VAL](@p_pre_week_name	, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_pre_type	 = [dbo].[SCM_ARR_SPL_VAL](@p_pre_type	, @v_delimiter , @mst_loop_cnt) ; 
				


			END

			-- E20260929-000580 
			PRINT CONCAT('@v_week_name',@v_week_name)
			PRINT CONCAT('@v_pre_week_name',@v_pre_week_name)

			--Week Name 유효성 체크
			SELECT @cnt = COUNT(*)
			FROM SCM_SYS_CALENDAR_M
			WHERE 1=1
			  AND ISO_YYYYWW = @v_week_name

			IF(@cnt > 0)
			BEGIN
				
				--해당 주차의 시작일과 종료일 조회
				SELECT @v_week_start_date = MIN(BASIS_START_DATE), @v_week_end_date = MAX(BASIS_END_DATE)
				FROM SCM_SYS_CALENDAR_M
				WHERE ISO_YYYYWW = @v_week_name

			END
			ELSE
			BEGIN
				SET @v_err_code    = 99010 ; 
				SET @v_err_message = N' 유효한 Week Name이 아닙니다.';
				THROW  @v_err_code, @v_err_message , 1; --예외발생
			END

			-- 기간내 해당하는 타입중 Fix된 정보를 제외하고 삭제
			-- 타입 변경없이 모든 라인 날짜를 반영한다. UI 에서 제공이 가능한지?
			print CONCAT(N'삭제 변수','@v_division_id',@v_division_id,'@@v_plant_id',@v_plant_id,'@@v_line_id',@v_line_id,'@@v_operation_id',@v_operation_id)
			DELETE SCP_OPMZ_NO_WORK
			WHERE DIVISION_ID		= @v_division_id
			  AND PLANT_ID			= @v_plant_id
			  AND LINE_ID			= @v_line_id
			  AND OPERATION_ID		= @v_operation_id
			  AND LINE_TYPE			= @v_line_type
			  AND NO_WORK_DATE BETWEEN @v_week_start_date AND @v_week_end_date
			  AND ISNULL(ATTRIBUTE1, '') <> 'Y'	
			-- E20260929-000580 로그
			print N'삭제 완료'

			--삭제가 아닌 경우, 중복체크
			IF (@v_active_flag <> 'D')
			BEGIN 
				/***** 중복체크 *****/
				DECLARE @dup_cnt INTEGER;
				SET @dup_cnt = 0;

				SELECT @dup_cnt = COUNT(*)
				FROM SCP_OPMZ_NO_WORK  WITH(NOLOCK)				
				WHERE DIVISION_ID		= @v_division_id
				  AND PLANT_ID			= @v_plant_id
				  AND LINE_ID			= @v_line_id
				  AND OPERATION_ID		= @v_operation_id
				  AND LINE_TYPE			= @v_line_type
				  AND NO_WORK_DATE		BETWEEN @v_week_start_date AND @v_week_end_date
				  AND [TYPE]			= @v_type
				  AND ISNULL(ATTRIBUTE1, '') <> 'Y'	

				IF(@dup_cnt > 0)
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
							OR @v_operation_id != @v_pre_operation_id OR @v_line_type != @v_pre_line_type OR @v_week_name != @v_pre_week_name
							OR @v_type != @v_pre_type
						)	--[PJ20257329] Line Type 추가 (2025-11-05)
						BEGIN
							SET @v_err_code    = 99010 ; 
							SET @v_err_message = N'수정한 데이터 중 중복된 데이터가 있습니다.';
							THROW  @v_err_code, @v_err_message , 1; --예외발생
						END
					END 
				END
			END


		END 



		-- E20260929-000580 입력로직 재수행.
		SET @mst_loop_cnt = 0
		WHILE LEN(@recv_seq) > 0 AND @mst_loop_cnt < @max_loop_cnt
		BEGIN

			-- E20260929-000580 로그
			print N'--------------------------------------------------------------------행 변경'
			SET @mst_loop_cnt = @mst_loop_cnt + 1;

			-- 각 컬럼들에 대한 스플릿처리로직 스타트
			BEGIN

				SET @v_active_flag = [dbo].[SCM_ARR_SPL_VAL](@p_active_flag, @v_delimiter , @mst_loop_cnt) ;
				SET @v_division_id = [dbo].[SCM_ARR_SPL_VAL](@p_division_id, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_plant_id = [dbo].[SCM_ARR_SPL_VAL](@p_plant_id, @v_delimiter , @mst_loop_cnt) ;   
				SET @v_line_id = [dbo].[SCM_ARR_SPL_VAL](@p_line_id, @v_delimiter , @mst_loop_cnt) ;   
				SET @v_operation_id = [dbo].[SCM_ARR_SPL_VAL](@p_operation_id, @v_delimiter , @mst_loop_cnt) ;
				SET @v_line_type = [dbo].[SCM_ARR_SPL_VAL](@p_line_type, @v_delimiter , @mst_loop_cnt) ;
				SET @v_week_name = [dbo].[SCM_ARR_SPL_VAL](@p_week_name, @v_delimiter , @mst_loop_cnt) ;
				SET @v_off_time = [dbo].[SCM_ARR_SPL_VAL](@p_off_time, @v_delimiter , @mst_loop_cnt) ;    
				SET @v_type = [dbo].[SCM_ARR_SPL_VAL](@p_type, @v_delimiter , @mst_loop_cnt) ; -- E20260624-000826 OPT CAPA → No Work UI 컬럼 추가 요청 (2026-06-29)
				SET @v_desc = [dbo].[SCM_ARR_SPL_VAL](@p_desc, @v_delimiter , @mst_loop_cnt) ;

			END

			--Week Name 유효성 체크
			SELECT @cnt = COUNT(*)
			FROM SCM_SYS_CALENDAR_M
			WHERE 1=1
			  AND ISO_YYYYWW = @v_week_name

			IF(@cnt > 0)
			BEGIN
				
				--해당 주차의 시작일과 종료일 조회
				SELECT @v_week_start_date = MIN(BASIS_START_DATE), @v_week_end_date = MAX(BASIS_END_DATE)
				FROM SCM_SYS_CALENDAR_M
				WHERE ISO_YYYYWW = @v_week_name
			END
			ELSE
			BEGIN
				SET @v_err_code    = 99010 ; 
				SET @v_err_message = N' 유효한 Week Name이 아닙니다.';
				THROW  @v_err_code, @v_err_message , 1; --예외발생
			END


			

			--삭제시 다음처리 패스
			IF(@v_active_flag = 'D') CONTINUE;

			/* E20260929-000580 구간 전체 FIX 정보 체크로직 제거, 하루 MAX 1일까지 반영하고 날짜 넘어가면 스톱 */
			/*
			-- E20260929-000580 구간내 FIX 정보는 TYPE 상관없이 체크
			SELECT @cnt = COUNT(*)
			FROM SCP_OPMZ_NO_WORK WITH(NOLOCK)
			WHERE DIVISION_ID		= @v_division_id
			  AND PLANT_ID			= @v_plant_id
			  AND LINE_ID			= @v_line_id
			  AND OPERATION_ID		= @v_operation_id
			  AND LINE_TYPE			= @v_line_type
			  AND NO_WORK_DATE BETWEEN @v_week_start_date AND @v_week_end_date
			  AND ISNULL(ATTRIBUTE1, '') = 'Y'	

			--2. 기간내 Fix된 Off time(day) 구하기
			-- E20260929-000580 구간내 FIX 정보는 TYPE 상관없이 체크
			IF(@cnt > 0)
			BEGIN
				
				SELECT @f_fix_off_time = CONVERT(NUMERIC(20,10) , SUM(OFF_TIME) / 86400.0000000000, 10)
				FROM SCP_OPMZ_NO_WORK WITH(NOLOCK)
				WHERE DIVISION_ID		= @v_division_id
				  AND PLANT_ID			= @v_plant_id
				  AND LINE_ID			= @v_line_id
				  AND OPERATION_ID		= @v_operation_id
				  AND LINE_TYPE			= @v_line_type
				  AND NO_WORK_DATE BETWEEN @v_week_start_date AND @v_week_end_date
				  AND ISNULL(ATTRIBUTE1, '') = 'Y'	
				GROUP BY DIVISION_ID, PLANT_ID, LINE_ID, OPERATION_ID, LINE_TYPE

			END
			ELSE
			BEGIN
				SET @f_fix_off_time = 0.0; 
			END
			*/

			--Weekly 입력된 Off time(day)
			SET  @f_off_time = CONVERT(NUMERIC(20,10) , @v_off_time, 10)

			-- E20260929-000580 기 설정된 FIX 정보 0 고정.
			SET @f_fix_off_time = 0.0; 


			--3. 입력된 Off time(day) > Fix된 Off time(day) 일 경우, 남은 Off time(day) 설정
			
			PRINT CONCAT('@f_off_time',@f_off_time) -- E20260929-000580 로그
			PRINT CONCAT('@f_fix_off_time',@f_fix_off_time) -- E20260929-000580 로그
			IF (@f_off_time > @f_fix_off_time)
			BEGIN
				
				
				--실제 적용 off time(day)
				SET @f_apply_off_time = @f_off_time - @f_fix_off_time
				PRINT CONCAT('@f_apply_off_time',@f_apply_off_time) -- E20260929-000580 로그

				SET @startdate = CONVERT(DATE, @v_week_start_date);
				SET @enddate = CONVERT(DATE, @v_week_end_date);
				SET @no_work_date = @enddate;
				
				print concat(N'넘어온 처리중 타입 @v_type:' ,@v_type) -- E20260929-000580 로그

				--4. 마지막 일자(일요일)부터 역순으로 순차적으로 86400(1 day)설정
				WHILE @no_work_date >= @startdate
				BEGIN

					-- E20260929-000580 로그
					print N'--------------------------------------------------------------------날짜 변경'
					print concat(N'넘어온 처리날짜 @no_work_date:' ,FORMAT(@no_work_date, 'yyyyMMdd'))

					--비조업 day가 0보다 적으면 중지
					IF (@f_apply_off_time <= 0.0) BREAK;

					SET @cnt= 0;
					SET @dsum=0;

					-- E20260929-000580 FIX CNT 로직 제거.
					/*
					SELECT @cnt = COUNT(*)
					FROM SCP_OPMZ_NO_WORK WITH(NOLOCK)
					WHERE DIVISION_ID			= @v_division_id
					  AND PLANT_ID				= @v_plant_id
					  AND LINE_ID				= @v_line_id
					  AND OPERATION_ID			= @v_operation_id
					  AND LINE_TYPE				= @v_line_type
					  AND NO_WORK_DATE			= @no_work_date
					  AND ISNULL(ATTRIBUTE1, '') = 'Y'	
					*/ 

					-- E20260929-000580 처리하려고 하는 TYPE의 FIX 가 없을때
					SELECT @cnt = COUNT(*)
					FROM SCP_OPMZ_NO_WORK WITH(NOLOCK)
					WHERE DIVISION_ID			= @v_division_id
					  AND PLANT_ID				= @v_plant_id
					  AND LINE_ID				= @v_line_id
					  AND OPERATION_ID			= @v_operation_id
					  AND LINE_TYPE				= @v_line_type
					  AND NO_WORK_DATE			= @no_work_date
					  AND TYPE					= @v_type
					  AND ISNULL(ATTRIBUTE1, '') = 'Y'	

					
					-- E20260929-000580 로그
					print concat(N'넘어온 타입의 처리날짜 fix 갯수:' ,@cnt)
					
					-- E20260929-000580 동일 타입 FIX 존재시 날짜 넘김.
					IF(@cnt = 0)
					BEGIN

						-- E20260929-000580 해당일자에 fix포함 TYPE전체 off_type 구하기.
						SELECT @dsum = ISNULL(SUM(OFF_TIME),0)
						FROM SCP_OPMZ_NO_WORK WITH(NOLOCK)
						WHERE DIVISION_ID			= @v_division_id
						  AND PLANT_ID				= @v_plant_id
						  AND LINE_ID				= @v_line_id
						  AND OPERATION_ID			= @v_operation_id
						  AND LINE_TYPE				= @v_line_type
						  AND NO_WORK_DATE			= @no_work_date
						GROUP BY DIVISION_ID, PLANT_ID, LINE_ID, OPERATION_ID, LINE_TYPE 

						-- E20260929-000580 로그
						print concat(N'넘어온 처리날짜 DSUM:' ,@dsum)

						-- E20260929-000580 입력가능한 시간 비교.
						IF(CONVERT(INT, ROUND(@f_apply_off_time * 86400, 1)) > (86400 - @dsum))
					    BEGIN
							-- E20260929-000580 로그
							PRINT N'입력가능한 시간 비교 CASE 1'
							--비조업 day가 1보다 큰 경우, 1day만큼 저장
							SET @off_time = (86400 - @dsum);
							SET @f_apply_off_time = @f_apply_off_time - CONVERT(NUMERIC(20,10) , (86400 - @dsum) / 86400.0000000000, 10);

						END
						ELSE
					    BEGIN
							-- E20260929-000580 로그
							PRINT N'입력가능한 시간 비교 CASE 2'
							--남은 시간 저장
							SET @off_time = CONVERT(INT, ROUND(@f_apply_off_time * 86400, 1));	-- 소수점 1자리 반올림
							SET @f_apply_off_time = 0.0;
						END

						
						-- 저장로그
						-- E20260929-000580 로그
						PRINT N'저장전'
						PRINT CONCAT('@v_type',@v_type)
						PRINT CONCAT('@off_time',@off_time)
						PRINT CONCAT('@f_apply_off_time',@f_apply_off_time) -- 남은시간.
						
						-- E20260929-000580 계산된 값이 0보다 클때만 저장.
						IF(@off_time > 0)
						BEGIN

							-- E20260929-000580 로그
							PRINT N'저장수행'
							PRINT CONCAT('@v_type',@v_type)
							PRINT CONCAT('@off_time',@off_time)
							PRINT CONCAT('@f_apply_off_time',@f_apply_off_time) -- 남은시간.
							

							INSERT INTO SCP_OPMZ_NO_WORK
							(
								DIVISION_ID
								, PLANT_ID
								, LINE_ID
								, OPERATION_ID
								, LINE_TYPE 
								, NO_WORK_DATE
								, OFF_TIME
								, [DESC]
								, ATTRIBUTE9	--weekly  Desc
								, VALID_YN
								, ATTRIBUTE1 
								, [TYPE]	-- E20260624-000826 OPT CAPA → No Work UI 컬럼 추가 요청 (2026-06-29) DAY ATTRIBUTE2 , WEEK ATTRIBUTE3 , E20260929-000580 ATTRIBUTE3 ->  [TYPE] 으로 변경.
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
								,@v_line_type 
								,FORMAT(@no_work_date, 'yyyyMMdd')
								,@off_time
								,@v_desc
								,@v_desc
								,'Y'
								,''
								,@v_type		-- E20260624-000826 OPT CAPA → No Work UI 컬럼 추가 요청 (2026-06-29)
								,@v_last_updated_by
								,GETDATE()
								,@v_last_updated_by
								,GETDATE()
							)
						END
						
					END

					SET @no_work_date = DATEADD(day, -1, @no_work_date);

				END	--4. 마지막 일자(일요일)부터 역순으로 순차적으로 86400(1 day)설정 END

			END	--3. 입력된 Off time(day) - Fix된 Off time(day) > 0 일 경우, 남은 Off time(day) 설정 END

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






