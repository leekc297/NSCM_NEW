

/*
 * Program ID   : SCP0020_SAVE_TACT_TIME_OSP
 * Description  : Tact Time Packer 등록, 수정
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2020/02/04   yhw				Initial Release [] 전지 GSCM(SCP) 운영 - [C20200116-000114] ESS 외주 Packer Line 계획 수립
 *
 */
CREATE PROCEDURE [dbo].[SCP0020_SAVE_TACT_TIME_OSP]
	 @p_active_flag        NVARCHAR(MAX)
	,@p_division_id        NVARCHAR(MAX)
	,@p_plant_site_id      NVARCHAR(MAX)
	,@p_item_id            NVARCHAR(MAX)
	,@p_operation_id       NVARCHAR(MAX)
	,@p_line_id            NVARCHAR(MAX)
	,@p_priority           NVARCHAR(MAX)
	,@p_tact_time          NVARCHAR(MAX)
	,@p_yield              NVARCHAR(MAX)
	,@p_valid_yn           NVARCHAR(MAX)
	,@p_daily_capacity     NVARCHAR(MAX)
	,@p_user_id            NVARCHAR(MAX)
	,@debug_mode           NVARCHAR(1) ='F'
AS

BEGIN

	SET NOCOUNT ON;
	
	DECLARE @v_working_time     datetime =sysdatetime();     
	DECLARE @recv_active_flag	NVARCHAR(MAX);
	SET @recv_active_flag = NULL;		
	SET @recv_active_flag = @p_active_flag;


	DECLARE @v_active_flag        NVARCHAR(MAX);
	DECLARE @v_division_id        NVARCHAR(MAX);
	DECLARE @v_plant_site_id      NVARCHAR(MAX);
	DECLARE @v_item_id            NVARCHAR(MAX);
	DECLARE @v_operation_id       NVARCHAR(MAX);
	DECLARE @v_line_id            NVARCHAR(MAX);
	DECLARE @v_priority           NVARCHAR(MAX);
	DECLARE @v_tact_time          NVARCHAR(MAX);
	DECLARE @v_yield              NVARCHAR(MAX);
	DECLARE @v_valid_yn           NVARCHAR(MAX);
	DECLARE @v_daily_capacity	  NVARCHAR(MAX);

	DECLARE @v_created_by        NVARCHAR(MAX);
	DECLARE @v_creation_date     datetime	;
	DECLARE @v_last_updated_by   NVARCHAR(MAX);
	DECLARE @v_last_update_date  datetime	;

	--DECLARE @v_input_status			NVARCHAR(MAX) ;
	--DECLARE @v_item_uom				NVARCHAR(MAX) ;
	--DECLARE @v_uom_convert_value    NVARCHAR(MAX) ;
	--DECLARE @v_lane_qty				NVARCHAR(MAX) ;
	--DECLARE @v_transport_mode    NVARCHAR(100) = ''; --에러반환용

	SET @v_created_by       = @p_user_id;
	SET @v_creation_date    = @v_working_time;
	SET @v_last_updated_by  = @p_user_id
	SET @v_last_update_date = @v_working_time

	SET @v_active_flag   = NULL;
	SET @v_division_id   = NULL;
	SET @v_plant_site_id = NULL;
	SET @v_item_id       = NULL;
	SET @v_operation_id  = NULL;
	SET @v_line_id       = NULL;
	SET @v_priority      = NULL;
	SET @v_tact_time     = NULL;
	SET @v_yield         = NULL;
	SET @v_valid_yn      = NULL;
	SET @v_daily_capacity = NULL;




	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^' 
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0020_SAVE_TACT_TIME_OSP';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;


	DECLARE @v_data_dup_cnt  INT=0;
	DECLARE @v_data_dup_priority_cnt  INT=0;
	
	-- 예외처리 변수 설정
	DECLARE @v_err_code  INTEGER;
	DECLARE @v_err_message  NVARCHAR(4000)='';

	/********************************************************************************
	* 임시테이블만들기
	********************************************************************************/
	-- Validation 체크용
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0020_TMP') IS NOT NULL	
		DROP TABLE #TblDynamicPivot_SCP0020_TMP
	;
	-- 저장용
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0020_SAVE_TMP') IS NOT NULL	
		DROP TABLE #TblDynamicPivot_SCP0020_SAVE_TMP
	;

	CREATE TABLE #TblDynamicPivot_SCP0020_TMP (
			 DIVISION_ID		NVARCHAR(30)
			,PLANT_SITE_ID		NVARCHAR(30)
			,ITEM_ID			NVARCHAR(50)
			,OPERATION_ID		NVARCHAR(30)
			,LINE_ID			NVARCHAR(50)
		);

	CREATE TABLE #TblDynamicPivot_SCP0020_SAVE_TMP (
			 DIVISION_ID		NVARCHAR(30)
			,PLANT_SITE_ID		NVARCHAR(30)
			,ITEM_ID			NVARCHAR(50)
			,OPERATION_ID		NVARCHAR(30)
			,LINE_ID			NVARCHAR(50)
			,PRIORITY			INT
			,TACT_TIME			NUMERIC(20,10)
			,YIELD				NUMERIC(20,10)
			,DAILY_CAPACITY		NUMERIC(20,10)
			,VALID_YN			NVARCHAR(1)
			,ATTRIBUTE1			NVARCHAR(150)
		);

	-- Validation용 전체 데이터 조회
	INSERT INTO #TblDynamicPivot_SCP0020_TMP
	SELECT DIVISION_ID, PLANT_SITE_ID, ITEM_ID, OPERATION_ID, LINE_ID
	FROM SCP_MST_TACT_TIME_OSP WITH(NOLOCK)
	;
	
	-- 트렌젝션 시작
	BEGIN TRAN;

	BEGIN TRY

			-- 시작 LOG
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


		-- 프로시저 LOOP 길이를 판단
		SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_active_flag, @v_delimiter);    

		
		WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt
		BEGIN    
				
			-- @mst_loop_cnt 1증가
			SET @mst_loop_cnt = @mst_loop_cnt + 1;			

			-- 각 컬럼들에 대한 스플릿처리로직 스타트
			BEGIN

				SET @v_active_flag    = dbo.SCM_ARR_SPL_VAL(@p_active_flag  , @v_delimiter, @mst_loop_cnt ) ;
				SET @v_division_id    = dbo.SCM_ARR_SPL_VAL(@p_division_id  , @v_delimiter, @mst_loop_cnt ) ;
				SET @v_plant_site_id  = dbo.SCM_ARR_SPL_VAL(@p_plant_site_id, @v_delimiter, @mst_loop_cnt ) ;
				SET @v_item_id        = dbo.SCM_ARR_SPL_VAL(@p_item_id      , @v_delimiter, @mst_loop_cnt ) ;
				SET @v_operation_id   = dbo.SCM_ARR_SPL_VAL(@p_operation_id , @v_delimiter, @mst_loop_cnt ) ;
				SET @v_line_id        = dbo.SCM_ARR_SPL_VAL(@p_line_id      , @v_delimiter, @mst_loop_cnt ) ;
				SET @v_priority       = dbo.SCM_ARR_SPL_VAL(@p_priority     , @v_delimiter, @mst_loop_cnt ) ;
				SET @v_tact_time      = dbo.SCM_ARR_SPL_VAL(@p_tact_time    , @v_delimiter, @mst_loop_cnt ) ;
				SET @v_yield          = dbo.SCM_ARR_SPL_VAL(@p_yield        , @v_delimiter, @mst_loop_cnt ) ;
				SET @v_valid_yn       = dbo.SCM_ARR_SPL_VAL(@p_valid_yn     , @v_delimiter, @mst_loop_cnt ) ;
				SET @v_daily_capacity = dbo.SCM_ARR_SPL_VAL(@p_daily_capacity     , @v_delimiter, @mst_loop_cnt ) ;
			END;

			SET @v_yield= (case when  @v_yield ='' or  @v_yield =null then null else convert(float, @v_yield)/100 end) ;        

			-- LOOP 파라미터 출력 DEBUG용			
			IF (@debug_mode ='T') 
			BEGIN		
				PRINT '===============================================';			
				PRINT '@mst_loop_cnt     = ' + CONVERT(VARCHAR,@mst_loop_cnt)   ;
				PRINT '@v_active_flag   = ''' + @v_active_flag   + '''' ;
				PRINT '@v_division_id   = ''' + @v_division_id   + '''' ;
				PRINT '@v_plant_site_id = ''' + @v_plant_site_id + '''' ;
				PRINT '@v_item_id       = ''' + @v_item_id       + '''' ;
				PRINT '@v_operation_id  = ''' + @v_operation_id  + '''' ;
				PRINT '@v_line_id       = ''' + @v_line_id       + '''' ;
				PRINT '@v_priority      = ''' + @v_priority      + '''' ;
				PRINT '@v_tact_time     = ''' + @v_tact_time     + '''' ;
				PRINT '@v_yield         = ''' + @v_yield         + '''' ;
				PRINT '@v_valid_yn      = ''' + @v_valid_yn      + '''' ;
				PRINT '@v_daily_capacity      = ''' + @v_daily_capacity      + '''' ;
			END;

			--Validation용
			/*
			INSERT INTO #TblDynamicPivot_SCP0020_TMP
			SELECT @v_division_id, @v_plant_site_id, @v_item_id, @v_operation_id, @v_line_id
			;
			*/

			--입력/수정/삭제용
			INSERT INTO #TblDynamicPivot_SCP0020_SAVE_TMP
			SELECT @v_division_id, @v_plant_site_id, @v_item_id, @v_operation_id, @v_line_id
				   , @v_priority, @v_tact_time, @v_yield, @v_daily_capacity, @v_valid_yn
				   , @v_active_flag
			;
			
		END -- END OF STMT. WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt


		---- 1. 중복체크
		DELETE A
		FROM #TblDynamicPivot_SCP0020_TMP A
		JOIN #TblDynamicPivot_SCP0020_SAVE_TMP B ON A.DIVISION_ID		= B.DIVISION_ID
												AND A.PLANT_SITE_ID		= B.PLANT_SITE_ID
												AND A.ITEM_ID			= B.ITEM_ID
												AND A.OPERATION_ID		= B.OPERATION_ID
												AND A.LINE_ID			= B.LINE_ID
												AND B.ATTRIBUTE1 = 'D'
		;

		INSERT INTO #TblDynamicPivot_SCP0020_TMP
		SELECT DIVISION_ID, PLANT_SITE_ID, ITEM_ID, OPERATION_ID, LINE_ID
		FROM #TblDynamicPivot_SCP0020_SAVE_TMP
		WHERE ATTRIBUTE1 = 'I'
		;


		SELECT @v_data_dup_cnt = COUNT(*)
		FROM (
			SELECT A.DIVISION_ID, A.PLANT_SITE_ID, A.ITEM_ID, A.OPERATION_ID, A.LINE_ID
					, (SELECT COUNT(B.DIVISION_ID) AS CNT  FROM #TblDynamicPivot_SCP0020_TMP B
														  WHERE B.DIVISION_ID=A.DIVISION_ID
															AND B.PLANT_SITE_ID=A.PLANT_SITE_ID
															AND B.ITEM_ID=A.ITEM_ID
															AND B.OPERATION_ID=A.OPERATION_ID
															AND B.LINE_ID=A.LINE_ID) AS CNT
			FROM #TblDynamicPivot_SCP0020_TMP A
		) A WHERE A.CNT>1
		;

		IF( @v_data_dup_cnt>0) 
			BEGIN
				SET @v_err_code    = 99010 ; 
				SET @v_err_message = N'이미 존재하는 데이타 입니다.';

				SELECT TOP 1 
					@v_division_id=A.DIVISION_ID, 
					@v_plant_site_id=A.PLANT_SITE_ID, 
					@v_item_id=A.ITEM_ID, 
					@v_line_id=A.LINE_ID
				FROM (
					SELECT A.DIVISION_ID, A.PLANT_SITE_ID, A.ITEM_ID, A.OPERATION_ID, A.LINE_ID
							, (SELECT COUNT(B.DIVISION_ID) AS CNT  FROM #TblDynamicPivot_SCP0020_TMP B
																  WHERE B.DIVISION_ID=A.DIVISION_ID
																	AND B.PLANT_SITE_ID=A.PLANT_SITE_ID
																	AND B.ITEM_ID=A.ITEM_ID
																	AND B.OPERATION_ID=A.OPERATION_ID
																	AND B.LINE_ID=A.LINE_ID) AS CNT
					FROM #TblDynamicPivot_SCP0020_TMP A
				) A WHERE A.CNT>1
				;

				THROW  @v_err_code, @v_err_message , 1; --예외발생
			END; 

		---- 2. 삭제 행 Except 삭제
		INSERT INTO SCP_MST_TACT_TIME_EXCEPT_OSP_H
			(history_seq
			,division_id
			,plant_site_id
			,item_id
			,operation_id
			,line_id
			,tact_time_start_date
			,tact_time_end_date
			,tact_time
			,yield
			,DAILY_CAPACITY
			,except_comment
			,use_yn
			,created_by
			,creation_date
			,last_updated_by
			,last_update_date
			,history_creation_date
			,ATTRIBUTE1)
		SELECT (NEXT VALUE FOR SEQ1_SCP_MST_TACT_TIME_EXCEPT_OSP_H),
				A.DIVISION_ID, 
				A.PLANT_SITE_ID, 
				A.ITEM_ID, 
				A.OPERATION_ID,
				A.LINE_ID,
				A.tact_time_start_date,
				A.tact_time_end_date,
				A.tact_time , 
				A.yield , 
				A.DAILY_CAPACITY, 
				A.except_comment ,
				A.use_yn,
				@v_created_by , 
				@d_event_date, 
				@v_created_by,	
				@d_event_date ,
				@d_event_date ,
				B.ATTRIBUTE1
		FROM SCP_MST_TACT_TIME_EXCEPT_OSP A WITH(NOLOCK)
		JOIN #TblDynamicPivot_SCP0020_SAVE_TMP B ON A.DIVISION_ID=B.DIVISION_ID
												 AND A.PLANT_SITE_ID=B.PLANT_SITE_ID
												 AND A.ITEM_ID=B.ITEM_ID
												 AND A.OPERATION_ID=B.OPERATION_ID
												 AND A.LINE_ID=B.LINE_ID
												 AND B.ATTRIBUTE1='D'
		;


		DELETE A
		FROM SCP_MST_TACT_TIME_EXCEPT_OSP A
		JOIN #TblDynamicPivot_SCP0020_SAVE_TMP B ON A.DIVISION_ID		= B.DIVISION_ID
												AND A.PLANT_SITE_ID		= B.PLANT_SITE_ID
												AND A.ITEM_ID			= B.ITEM_ID
												AND A.OPERATION_ID		= B.OPERATION_ID
												AND A.LINE_ID			= B.LINE_ID
												AND B.ATTRIBUTE1 = 'D'
		;

		---- 3. Tact Time 히스토리 생성
		INSERT INTO SCP_MST_TACT_TIME_OSP_H
			(history_seq
			,division_id
			,plant_site_id
			,item_id
			,operation_id
			,line_id
			,PRIORITY
			,TACT_TIME
			,YIELD
			,DAILY_CAPACITY
			,VALID_YN
			,created_by
			,creation_date
			,last_updated_by
			,last_update_date
			,history_creation_date
			,ATTRIBUTE1)
		SELECT (NEXT VALUE FOR SEQ1_SCP_MST_TACT_TIME_OSP_H),
				A.DIVISION_ID, 
				A.PLANT_SITE_ID, 
				A.ITEM_ID, 
				A.OPERATION_ID,
				A.LINE_ID,
				A.PRIORITY,
				A.TACT_TIME,
				A.YIELD , 
				A.DAILY_CAPACITY , 
				A.VALID_YN ,
				@v_created_by , 
				@d_event_date, 
				@v_created_by,	
				@d_event_date ,
				@d_event_date ,
				A.ATTRIBUTE1
		FROM #TblDynamicPivot_SCP0020_SAVE_TMP A WITH(NOLOCK)
		;

		---- 4. Tact Time 삭제
		DELETE A
		FROM SCP_MST_TACT_TIME_OSP A
		JOIN #TblDynamicPivot_SCP0020_SAVE_TMP B ON A.DIVISION_ID		= B.DIVISION_ID
												AND A.PLANT_SITE_ID		= B.PLANT_SITE_ID
												AND A.ITEM_ID			= B.ITEM_ID
												AND A.OPERATION_ID		= B.OPERATION_ID
												AND A.LINE_ID			= B.LINE_ID
												AND B.ATTRIBUTE1 = 'D'
		;

		---- 5. Tact Time 입력
		INSERT INTO SCP_MST_TACT_TIME_OSP
		(DIVISION_ID,	PLANT_SITE_ID,	ITEM_ID,			OPERATION_ID,	LINE_ID
		 ,PRIORITY,		TACT_TIME,		YIELD,				DAILY_CAPACITY, VALID_YN
		 ,CREATED_BY,	CREATION_DATE,	LAST_UPDATED_BY,	LAST_UPDATE_DATE)
		SELECT 
			DIVISION_ID,	PLANT_SITE_ID,	ITEM_ID,		OPERATION_ID,	LINE_ID
			,PRIORITY,		TACT_TIME,		YIELD,			DAILY_CAPACITY, VALID_YN
			,@v_created_by, @d_event_date,	@v_created_by,	@d_event_date
		FROM #TblDynamicPivot_SCP0020_SAVE_TMP
		WHERE ATTRIBUTE1 = 'I'
		;

		---- 6. Tact Time 수정
		UPDATE A
		SET A.PRIORITY = B.PRIORITY
			, A.TACT_TIME = B.TACT_TIME
			, A.YIELD	= B.YIELD
			, A.DAILY_CAPACITY = B.DAILY_CAPACITY
			, A.LAST_UPDATED_BY = @v_created_by
			, A.LAST_UPDATE_DATE = @d_event_date
		FROM SCP_MST_TACT_TIME_OSP A WITH(NOLOCK)
		JOIN #TblDynamicPivot_SCP0020_SAVE_TMP B WITH(NOLOCK) ON A.DIVISION_ID		= B.DIVISION_ID
												AND A.PLANT_SITE_ID		= B.PLANT_SITE_ID
												AND A.ITEM_ID			= B.ITEM_ID
												AND A.OPERATION_ID		= B.OPERATION_ID
												AND A.LINE_ID			= B.LINE_ID
												AND B.ATTRIBUTE1 = 'M'
		;

		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		COMMIT TRAN;			
		
		-- 결과코드, 결과 카운트 반환
		SELECT  'S' AS result_code,  @mst_loop_cnt AS result_cnt ;

	END TRY

	BEGIN CATCH 
		BEGIN
			if (xact_state() <> 0) ROLLBACK TRAN; --입력 데이타 롤백 처리
						
			IF( @v_err_code IS NULL OR @v_err_code ='')
				SET @v_err_code= ERROR_NUMBER() ;

			IF( @v_err_message IS NULL OR @v_err_message ='') 
				BEGIN
					SET @v_err_message=  ERROR_MESSAGE();

					INSERT INTO scm_sys_log_batch (program_name,log_type,log_count,log_message,description,event_date,creation_date,created_by,last_update_date,last_updated_by)
					VALUES (ERROR_PROCEDURE(),'ERROR',NULL,ERROR_MESSAGE(),NULL,SYSDATETIME(),SYSDATETIME(),ERROR_PROCEDURE(),SYSDATETIME(),ERROR_PROCEDURE());
				END

			--IF @@TRANCOUNT > 0
			--  COMMIT WORK;
					  
			-- error코드, errror 메시지 반환
			SELECT 'F' AS result_code;

			/* 에러 메시지, 에러 데이터  반환   */	
			SELECT  @v_err_code			AS err_code
				   ,@v_err_message		AS err_message
				   ,@v_division_id   AS DIVISION_ID  
				   ,@v_plant_site_id AS PLANT_SITE_ID
				   ,@v_item_id       AS ITEM_ID      
				   ,@v_line_id       AS LINE_ID      
			; 

		END;
	END CATCH;

	-- Validation 체크용
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0020_TMP') IS NOT NULL	
		DROP TABLE #TblDynamicPivot_SCP0020_TMP
	;
	-- 저장용
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0020_SAVE_TMP') IS NOT NULL	
		DROP TABLE #TblDynamicPivot_SCP0020_SAVE_TMP
	;
END


