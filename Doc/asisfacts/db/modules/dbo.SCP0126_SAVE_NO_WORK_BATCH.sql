
/*
 * Program ID   : SCP0126_SAVE_NO_WORK_BATCH
 * Description  : No Work 일괄등록
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2025/10/13   mrchois			PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - Initial Release
 * 2025/11/05   mrchois			PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - Line Type 추가, 전극사업부의 원 사업부 판단을 위해 수정
 * 2025/12/04   mrchois			PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - Week 단위 조회 및 입력 방식 추가
 * 2026/06/29	ymh				E20260624-000826 OPT CAPA → No Work UI 컬럼 추가 요청 (2026-06-29)
 * 2026/10/08	ymh				E20260929-000580 비조업 로직 수정 요청의 건(OPT CAPA - No Work)
 */
CREATE PROCEDURE [dbo].[SCP0126_SAVE_NO_WORK_BATCH]

	-- Add the parameters for the stored procedure here
	@p_division_id			NVARCHAR(MAX), 
	@p_line_id				NVARCHAR(MAX),
	@p_start_date			nvarchar(8), 
	@p_end_date				nvarchar(8), 
	@p_seq					nvarchar(MAX),
	@p_off_time				NVARCHAR(MAX), 
	@p_type					NVARCHAR(MAX),			-- E20260624-000826 OPT CAPA → No Work UI 컬럼 추가 요청 (2026-06-29)
	@p_desc					NVARCHAR(MAX),		
	@p_user_id				NVARCHAR(MAX)

AS

BEGIN

	SET NOCOUNT ON;

	DECLARE @v_working_time		DATETIME =sysdatetime();
	DECLARE @recv_seq			NVARCHAR(MAX);
	SET @recv_seq = NULL;		
	SET @recv_seq = @p_seq;


	DECLARE @v_startdate		DATETIME;
    DECLARE @v_enddate			DATETIME;
	SET @v_startdate = CONVERT(DATE, @p_start_date);
	SET @v_enddate = CONVERT(DATE, @p_end_date);

	DECLARE @v_plant			NVARCHAR(MAX);
	DECLARE @v_line				NVARCHAR(MAX);
	DECLARE @v_seq				NVARCHAR(MAX);
	DECLARE @v_off_time			NVARCHAR(MAX);
	DECLARE @v_type				NVARCHAR(MAX);		-- E20260624-000826 OPT CAPA → No Work UI 컬럼 추가 요청 (2026-06-29)
	DECLARE @v_desc				NVARCHAR(MAX);
	DECLARE @v_last_updated_by	NVARCHAR(MAX);


	SET @v_seq					= NULL;	
	SET @v_off_time				= NULL;
	SET @v_type					= NULL;				-- E20260624-000826 OPT CAPA → No Work UI 컬럼 추가 요청 (2026-06-29)
	SET @v_desc					= NULL;	

	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^' 

	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;

	SET @v_last_updated_by		= NULL;
		
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0126_SAVE_NO_WORK_BATCH';
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
		
		DECLARE @cnt INTEGER;
		SET @cnt = 0;

		IF OBJECT_ID('TEMPDB..#PatternWeek') IS NOT NULL
		BEGIN 
			DROP TABLE  #PatternWeek;
		END;		

		IF OBJECT_ID('TEMPDB..#PatternData') IS NOT NULL
		BEGIN 
			DROP TABLE  #PatternData;
		END;

		IF OBJECT_ID('TEMPDB..#DateRange') IS NOT NULL
		BEGIN 
			DROP TABLE  #DateRange;
		END;

		IF OBJECT_ID('TEMPDB..#PatternTemp') IS NOT NULL
		BEGIN 
			DROP TABLE  #PatternTemp;
		END;

		-- 1. 임시 테이블 생성
		CREATE TABLE #DateRange (
			NO_WORK_DATE DATE
		);

		CREATE TABLE #PatternWeek (
			SEQ				INT,	-- E20260929-000580 SEQ PK 제외
			OFF_TIME		NUMERIC(20,10),		--[PJ20257329] Week 단위 조회 및 입력 방식 추가 (2025-12-04)
			[TYPE]			NVARCHAR(100),		-- E20260624-000826 OPT CAPA → No Work UI 컬럼 추가 요청 (2026-06-29)
		    [DESC]			NVARCHAR(200)
		);

		CREATE TABLE #PatternTemp (
			NO_WORK_DATE	DATE,
			SEQ				INT,
			OFF_TIME		NUMERIC(20,10),		--[PJ20257329] Week 단위 조회 및 입력 방식 추가 (2025-12-04)
			[TYPE]			NVARCHAR(100),		-- E20260624-000826 OPT CAPA → No Work UI 컬럼 추가 요청 (2026-06-29)
			[DESC]			NVARCHAR(200)
		);

		CREATE TABLE #PatternData (
			DIVISION_ID		NVARCHAR(50),
			PLANT_ID		NVARCHAR(50),
			OPERATION_ID	NVARCHAR(50),
			LINE_ID			NVARCHAR(50),
			NO_WORK_DATE	NVARCHAR(8),
			OFF_TIME		NUMERIC(20,10)		--[PJ20257329] Week 단위 조회 및 입력 방식 추가 (2025-12-04)
		);

		-- E20260929-000580 주단위 입력이 가능해야하니 @max_loop_cnt 를 사용하여 처리하면 안된다.
		SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_seq, @v_delimiter);
		
		

		WHILE LEN(@recv_seq) > 0 AND @mst_loop_cnt < @max_loop_cnt
		BEGIN

			SET @mst_loop_cnt = @mst_loop_cnt + 1;

			-- 각 컬럼들에 대한 스플릿처리로직 스타트
			BEGIN

				SET @v_seq = [dbo].[SCM_ARR_SPL_VAL](@p_seq, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_off_time = [dbo].[SCM_ARR_SPL_VAL](@p_off_time, @v_delimiter , @mst_loop_cnt) ;    
				SET @v_type = [dbo].[SCM_ARR_SPL_VAL](@p_type, @v_delimiter , @mst_loop_cnt) ; -- E20260624-000826 OPT CAPA → No Work UI 컬럼 추가 요청 (2026-06-29)
				SET @v_desc = [dbo].[SCM_ARR_SPL_VAL](@p_desc, @v_delimiter , @mst_loop_cnt) ;

			END

			INSERT INTO #PatternWeek
			(
				  SEQ
				, OFF_TIME
				, [TYPE]						-- E20260624-000826 OPT CAPA → No Work UI 컬럼 추가 요청 (2026-06-29)
				, [DESC]
			)			
			VALUES
			(
				  @v_seq
				, @v_off_time
				, @v_type						-- E20260624-000826 OPT CAPA → No Work UI 컬럼 추가 요청 (2026-06-29)
				, @v_desc
			)

		END

		-- 시작 날짜부터 종료 날짜까지의 모든 날짜 생성
		;WITH DateRange AS (
			SELECT @v_startdate AS OperationDate
			UNION ALL
			SELECT DATEADD(DAY, 1, OperationDate)
			FROM DateRange
			WHERE DATEADD(DAY, 1, OperationDate) <= @v_enddate
		)
		INSERT INTO #DateRange
		SELECT *
		FROM DateRange
		OPTION (MAXRECURSION 0) -- 재귀 호출 제한 해제

		-- E20260929-000580 테스트
		/*
		SELECT * FROM #DateRange ORDER BY 1
		*/

		DECLARE @WEEK_CNT INT = 0
		SELECT @WEEK_CNT = MAX(SEQ) FROM  #PatternWeek 

		PRINT CONCAT('@WEEK_CNT',@WEEK_CNT)

		INSERT INTO #PatternTemp
		SELECT 
			d.NO_WORK_DATE,
			p.SEQ,
			p.OFF_TIME,
			p.[TYPE],
			-- (DATEDIFF(DAY, @v_startdate, d.NO_WORK_DATE) % @WEEK_CNT + 1) -- E20260929-000580 테스트
			p.[DESC]
		FROM #DateRange d
		CROSS APPLY (
			SELECT SEQ, OFF_TIME, [TYPE],[DESC]
			FROM #PatternWeek
			WHERE SEQ = (DATEDIFF(DAY, @v_startdate, d.NO_WORK_DATE) % @WEEK_CNT + 1)
			AND OFF_TIME > 0
		) p

		-- E20260929-000580 테스트
		--SELECT * FROM  #PatternTemp ORDER BY 1

		--[PJ20257329] 전극사업부의 원 사업부 판단을 위해 수정 (2025-11-05) START
		--전극사업부의 원 사업부 조회용
		IF OBJECT_ID('TEMPDB..#division_info') IS NOT NULL
		BEGIN 
			DROP TABLE  #division_info;
		END;

		select d.division_id
				 , r.division_id	as org_division_id 
				 , d.attribute3		as division_dv
		into #division_info
		from scm_mst_division d with(nolock)
		inner join scm_mst_division r with(nolock)
			on d.attribute4 = r.attribute4
			and ( (d.attribute3 != 'EE' and d.division_id = r.division_id)
				or
				(d.attribute3 = 'EE'  and r.attribute3 != 'EE') 
			) 
		where 1=1
			and d.valid_yn = 'Y'
			and r.valid_yn = 'Y'
		--[PJ20257329] 전극사업부의 원 사업부 판단을 위해 수정 (2025-11-05) END

		--일괄저장할 조건정보 삭제
		DELETE SCP_OPMZ_NO_WORK
		 WHERE DIVISION_ID = @p_division_id
		   AND LINE_ID IN (SELECT token FROM dbo.String_Split(@p_line_id  ,','))
		   AND NO_WORK_DATE BETWEEN @p_start_date AND @p_end_date
		   AND ISNULL(ATTRIBUTE1, '') != 'Y'	-- FIX : 'Y'가 아닌 정보 삭제대상

		-- Line정보와 패턴정보 크로스 조회후 입력
		-- E20260929-000580 컬럼추가.
		INSERT INTO SCP_OPMZ_NO_WORK
		(
		  [DIVISION_ID], [PLANT_ID], [LINE_ID], [OPERATION_ID], [NO_WORK_DATE], [OFF_TIME], [DESC], [VALID_YN]
		, [ATTRIBUTE1], [ATTRIBUTE2], [ATTRIBUTE3], [ATTRIBUTE4], [ATTRIBUTE5]
		, [ATTRIBUTE6], [ATTRIBUTE7], [ATTRIBUTE8], [ATTRIBUTE9], [ATTRIBUTE10]
		, [CREATED_BY], [CREATION_DATE], [LAST_UPDATED_BY], [LAST_UPDATE_DATE], [LINE_TYPE], [TYPE]
		)
		SELECT X.DIVISION_ID
			 , X.PLANT_ID
			 , X.LINE_ID
			 , X.OPERATION_ID
			 , REPLACE(X.NO_WORK_DATE, '-','')
			 , CONVERT(INT, ROUND(CONVERT(NUMERIC(20,10) , X.OFF_TIME) * 86400, 1))		--소수점 1자리에서 반올림		--[PJ20257329] Week 단위 조회 및 입력 방식 추가 (2025-12-04)
			 , X.[DESC]
			 , 'Y'		-- VALID_YN
			 , ''		-- ATTRIBUTE1 AS FIX
			 , NULL		-- ATTRIBUTE2 AS TYPE -- E20260624-000826 OPT CAPA → No Work UI 컬럼 추가 요청 (2026-06-29) -- E20260929-000580 attribute2 -> tyup 으로 변경
			 , NULL		-- ATTRIBUTE3
			 , NULL		-- ATTRIBUTE4
			 , NULL		-- ATTRIBUTE5
			 , NULL		-- ATTRIBUTE6
			 , NULL		-- ATTRIBUTE7
			 , NULL		-- ATTRIBUTE8
			 , NULL		-- ATTRIBUTE9
			 , NULL		-- ATTRIBUTE10
			 , @v_last_updated_by
			 , GETDATE()
			 , @v_last_updated_by
			 , GETDATE()
			 , '-'		-- LINE_TYPE	[PJ20257329] Line Type 추가 (2025-11-05)
			 , X.[TYPE] -- E20260929-000580 attribute2 -> tyup 으로 변경
		FROM (
			SELECT a.*, b.ATTRIBUTE1
			FROM (
				SELECT l.*, REPLACE(p.NO_WORK_DATE, '-','') AS NO_WORK_DATE, p.OFF_TIME
				, p.[TYPE] -- E20260624-000826 OPT CAPA → No Work UI 컬럼 추가 요청 (2026-06-29)
				, p.[DESC]
				FROM (
					--[PJ20257329] 전극사업부의 원 사업부 판단을 위해 수정 (2025-11-05) START
					--전극사업부의 원 사업부 판단을 위해 
					select @p_division_id  AS division_id
						 , l.plant_id
						 , l.operation_id
						 , l.line_id
					  from scm_mst_line_sn l with(nolock)
					 inner join scm_mst_factory_sn f with(nolock)
						on f.company_id = l.company_id
					   and f.factory_id = l.factory_id 
					  LEFT JOIN scm_adm_lookup_master_detail ld WITH(NOLOCK)
					    ON ld.LOOKUP_TYPE = 'OPMZ_PLAN_OPERATION' AND ld.valid_yn = 'Y' AND ld.SEGMENT1 = @p_division_id
				     inner join #division_info d 
						on l.division_id = d.org_division_id
					   AND l.OPERATION_ID = ld.SEGMENT2	--사업부별 표시할 Operation 지정
					 where 1=1
					   and l.line_id IN (SELECT token FROM dbo.String_Split(@p_line_id  ,','))
					 group by l.plant_id
						 , l.operation_id
						 , l.line_id

					--select l.division_id
					--	 , l.plant_id
					--	 , l.operation_id
					--	 , l.line_id
					--  from scm_mst_line_sn l with(nolock)
					-- inner join scm_mst_factory_sn f with(nolock)
					--	on f.company_id = l.company_id
					--   and f.factory_id = l.factory_id 
					-- where 1=1
					--   and l.active_flag =  'Y'
					--   and exists (select *
					--				 from scm_adm_lookup_master_detail  op with(nolock)
					--				where 1=1
					--				  and op.lookup_type = 'OPMZ_PLAN_OPERATION'
					--				  and op.valid_yn = 'Y'
					--				  and op.segment1 = l.division_id
					--				  and op.segment2 = l.operation_id
					--				) 
					--   and l.division_id = @p_division_id
					--   and l.line_id IN (SELECT token FROM dbo.String_Split(@p_line_id  ,','))
					-- group by l.division_id
					--	 , l.plant_id
					--	 , l.operation_id
					--	 , l.line_id
					--[PJ20257329] 전극사업부의 원 사업부 판단을 위해 수정 (2025-11-05) END
				) l
				CROSS APPLY (
					SELECT NO_WORK_DATE, SEQ, OFF_TIME
					, [TYPE]	-- E20260624-000826 OPT CAPA → No Work UI 컬럼 추가 요청 (2026-06-29)
					, [DESC] 
					FROM #PatternTemp
				) p
			) a
			left JOIN SCP_OPMZ_NO_WORK b
				ON b.DIVISION_ID = a.DIVISION_ID 
				AND b.PLANT_ID = a.PLANT_ID 
				AND b.LINE_ID = a.LINE_ID
				AND b.OPERATION_ID = a.OPERATION_ID
				AND b.NO_WORK_DATE = a.NO_WORK_DATE
				AND ISNULL(b.ATTRIBUTE1, '') = 'Y'	
		) X
		WHERE ISNULL(X.ATTRIBUTE1, '') != 'Y'		--SCP_OPMZ_NO_WORK에서 FIX(ATTRIBUTE1)가 'Y 정보 반영제외



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






