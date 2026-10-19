


/*
 * Program ID   : [SCP0020_SAVE_TACT_TIME_EXCEPT]
 * Description  : TACT Time Except 등록, 수정, 삭제
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/05/10   pjs				Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/05/28   hwyoon			사용여부(use_yn) 컬럼 조회 추가
 * 2018/05/28	hwyoon			except 시트 삭제로직 추가
 * 2020/02/12	hwyoon			[C20200116-000114] ESS 외주 Packer Line 계획 수립 - 버그수정
 *
 */
CREATE PROCEDURE [dbo].[SCP0020_SAVE_TACT_TIME_EXCEPT]
	 @p_active_flag          NVARCHAR(MAX)    
	,@p_division_id          NVARCHAR(MAX)
	,@p_plant_site_id        NVARCHAR(MAX)
	,@p_item_id              NVARCHAR(MAX)
	,@p_operation_id         NVARCHAR(MAX)
	,@p_line_id              NVARCHAR(MAX)
	,@p_tact_time_start_date NVARCHAR(MAX)
	,@p_tact_time_end_date   NVARCHAR(MAX)
	,@p_tact_time            NVARCHAR(MAX)
	,@p_yield                NVARCHAR(MAX)
	,@p_except_comment       NVARCHAR(MAX)
	,@p_use_yn				 NVARCHAR(MAX)
	,@p_user_id              NVARCHAR(MAX)

	-- 수정시 필요한 pk원본 값 2018-04-09 추가 pjs
	,@p_org_division_id          NVARCHAR(MAX)
	,@p_org_plant_site_id        NVARCHAR(MAX)
	,@p_org_item_id              NVARCHAR(MAX)
	,@p_org_operation_id         NVARCHAR(MAX)
	,@p_org_line_id              NVARCHAR(MAX)
	,@p_org_tact_time_start_date NVARCHAR(MAX)
	,@p_org_tact_time_end_date   NVARCHAR(MAX)

	,@debug_mode          NVARCHAR(1) ='F'

AS

BEGIN

	SET NOCOUNT ON;
	

	DECLARE @recv_active_flag		NVARCHAR(MAX);
	SET @recv_active_flag = @p_active_flag

	DECLARE @v_active_flag              NVARCHAR(MAX) = NULL;
	DECLARE @v_division_id              NVARCHAR(MAX) = NULL;
	DECLARE @v_plant_site_id            NVARCHAR(MAX) = NULL;
	DECLARE @v_item_id                  NVARCHAR(MAX) = NULL;
	DECLARE @v_operation_id             NVARCHAR(MAX) = NULL;
	DECLARE @v_line_id                  NVARCHAR(MAX) = NULL;
	DECLARE @v_tact_time_start_date     NVARCHAR(MAX) = NULL;
	DECLARE @v_tact_time_end_date       NVARCHAR(MAX) = NULL;
	DECLARE @v_tact_time                NVARCHAR(MAX) = NULL;
	DECLARE @v_yield                    NVARCHAR(MAX) = NULL;
	DECLARE @v_except_comment           NVARCHAR(MAX) = NULL;
	DECLARE @v_use_yn					NVARCHAR(MAX) = NULL;
	DECLARE @v_created_by               NVARCHAR(MAX) = @p_user_id;
	DECLARE @v_last_updated_by	        NVARCHAR(MAX) = @p_user_id;

	DECLARE @v_org_division_id          NVARCHAR(MAX) = NULL;
	DECLARE @v_org_plant_site_id        NVARCHAR(MAX) = NULL;
	DECLARE @v_org_item_id              NVARCHAR(MAX) = NULL;
	DECLARE @v_org_operation_id         NVARCHAR(MAX) = NULL;
	DECLARE @v_org_line_id              NVARCHAR(MAX) = NULL;
	DECLARE @v_org_tact_time_start_date NVARCHAR(MAX) = NULL;
	DECLARE @v_org_tact_time_end_date   NVARCHAR(MAX) = NULL;

	DECLARE @v_delimiter NVARCHAR(1)='^' ;
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0020_SAVE_TACT_TIME_EXCEPT';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	DECLARE @v_data_dup_cnt  INT=0;
	
	-- 예외처리 변수 설정
	DECLARE @v_err_code  INTEGER;
	DECLARE @v_err_message  NVARCHAR(4000)='';


	/********************************************************************************
	* 임시테이블만들기
	********************************************************************************/
	IF OBJECT_ID('tempdb..#TblDynamic_SCP0020') IS NOT NULL	
		DROP TABLE #TblDynamic_SCP0020 
	;

	CREATE TABLE #TblDynamic_SCP0020 (
		active_flag	nvarchar(1),
		division_id	nvarchar(30),
		plant_site_id	nvarchar(30),
		item_id		nvarchar(50),
		operation_id	nvarchar(30),
		line_id		nvarchar(50),
		tact_time_start_date	nvarchar(8),
		tact_time_end_date	nvarchar(8),
		tact_time			nvarchar(50),
		yield				nvarchar(50),
		except_comment	nvarchar(100),
		use_yn			nvarchar(1),
		org_division_id	nvarchar(30),
		org_plant_site_id	nvarchar(30),
		org_item_id		nvarchar(50),
		org_operation_id	nvarchar(30),
		org_line_id		nvarchar(50),
		org_tact_time_start_date	nvarchar(8),
		org_tact_time_end_date	nvarchar(8)
	);
	
	-- 트렌젝션 시작
	BEGIN TRAN;

	BEGIN TRY

		--PRINT '1';
		-- 시작 LOG
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		--PRINT '2';
		-- 프로시저 LOOP 길이를 판단
		SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_active_flag , @v_delimiter);    
		

		WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt
		BEGIN    
				
			-- @mst_loop_cnt 1증가
			SET @mst_loop_cnt = @mst_loop_cnt + 1;			

			-- 각 컬럼들에 대한 스플릿처리로직 스타트
			BEGIN

				SET @v_active_flag              = dbo.SCM_ARR_SPL_VAL( @p_active_flag             , @v_delimiter, @mst_loop_cnt );
				SET @v_division_id              = dbo.SCM_ARR_SPL_VAL( @p_division_id             , @v_delimiter, @mst_loop_cnt );
				SET @v_plant_site_id            = dbo.SCM_ARR_SPL_VAL( @p_plant_site_id           , @v_delimiter, @mst_loop_cnt );
				SET @v_item_id                  = dbo.SCM_ARR_SPL_VAL( @p_item_id                 , @v_delimiter, @mst_loop_cnt );
				SET @v_operation_id             = dbo.SCM_ARR_SPL_VAL( @p_operation_id            , @v_delimiter, @mst_loop_cnt );
				SET @v_line_id                  = dbo.SCM_ARR_SPL_VAL( @p_line_id                 , @v_delimiter, @mst_loop_cnt );
				SET @v_tact_time_start_date     = dbo.SCM_ARR_SPL_VAL( @p_tact_time_start_date    , @v_delimiter, @mst_loop_cnt );
				SET @v_tact_time_end_date       = dbo.SCM_ARR_SPL_VAL( @p_tact_time_end_date      , @v_delimiter, @mst_loop_cnt );
				SET @v_tact_time                = dbo.SCM_ARR_SPL_VAL( @p_tact_time               , @v_delimiter, @mst_loop_cnt );
				SET @v_yield                    = dbo.SCM_ARR_SPL_VAL( @p_yield                   , @v_delimiter, @mst_loop_cnt );
				SET @v_except_comment           = dbo.SCM_ARR_SPL_VAL( @p_except_comment          , @v_delimiter, @mst_loop_cnt );
				SET @v_use_yn					= dbo.SCM_ARR_SPL_VAL( @p_use_yn				  , @v_delimiter, @mst_loop_cnt );
				SET @v_org_division_id          = dbo.SCM_ARR_SPL_VAL( @p_org_division_id         , @v_delimiter, @mst_loop_cnt );
				SET @v_org_plant_site_id        = dbo.SCM_ARR_SPL_VAL( @p_org_plant_site_id       , @v_delimiter, @mst_loop_cnt );
				SET @v_org_item_id              = dbo.SCM_ARR_SPL_VAL( @p_org_item_id             , @v_delimiter, @mst_loop_cnt );
				SET @v_org_operation_id         = dbo.SCM_ARR_SPL_VAL( @p_org_operation_id        , @v_delimiter, @mst_loop_cnt );
				SET @v_org_line_id              = dbo.SCM_ARR_SPL_VAL( @p_org_line_id             , @v_delimiter, @mst_loop_cnt );
				SET @v_org_tact_time_start_date = dbo.SCM_ARR_SPL_VAL( @p_org_tact_time_start_date, @v_delimiter, @mst_loop_cnt );
				SET @v_org_tact_time_end_date   = dbo.SCM_ARR_SPL_VAL( @p_org_tact_time_end_date  , @v_delimiter, @mst_loop_cnt );

				--PRINT '6';
				--PRINT ' @v_valid_yn ='+ ISNULL(@v_valid_yn,'') ;
			END;

						-- LOOP 파라미터 출력 DEBUG용			
			IF (@debug_mode ='T') 
			BEGIN		
				PRINT '=================LOOP VARS==============================';			
				PRINT ' @mst_loop_cnt               = '''+ @mst_loop_cnt                +'''';
				PRINT ' @v_active_flag              = '''+ @v_active_flag               +'''';
				PRINT ' @v_division_id              = '''+ @v_division_id               +'''';
				PRINT ' @v_plant_site_id            = '''+ @v_plant_site_id             +'''';
				PRINT ' @v_item_id                  = '''+ @v_item_id                   +'''';
				PRINT ' @v_operation_id             = '''+ @v_operation_id              +'''';
				PRINT ' @v_line_id                  = '''+ @v_line_id                   +'''';
				PRINT ' @v_tact_time_start_date     = '''+ @v_tact_time_start_date      +'''';
				PRINT ' @v_tact_time_end_date       = '''+ @v_tact_time_end_date        +'''';
				PRINT ' @v_tact_time                = '''+ @v_tact_time                 +'''';
				PRINT ' @v_yield                    = '''+ @v_yield                     +'''';
				PRINT ' @v_except_comment           = '''+ @v_except_comment            +'''';
				PRINT ' @v_use_yn					= '''+ @v_use_yn					+'''';
				PRINT ' @v_org_division_id          = '''+ @v_org_division_id           +'''';
				PRINT ' @v_org_plant_site_id        = '''+ @v_org_plant_site_id         +'''';
				PRINT ' @v_org_item_id              = '''+ @v_org_item_id               +'''';
				PRINT ' @v_org_operation_id         = '''+ @v_org_operation_id          +'''';
				PRINT ' @v_org_line_id              = '''+ @v_org_line_id               +'''';
				PRINT ' @v_org_tact_time_start_date = '''+ @v_org_tact_time_start_date  +'''';
				PRINT ' @v_org_tact_time_end_date   = '''+ @v_org_tact_time_end_date    +'''';
			END;


			INSERT INTO #TblDynamic_SCP0020
			SELECT @v_active_flag			AS active_flag
					, @v_division_id		AS division_id
					, @v_plant_site_id		AS plant_site_id
					, @v_item_id			AS item_id
					, @v_operation_id		AS operation_id
					, @v_line_id			AS line_id
					, @v_tact_time_start_date	AS tact_time_start_date
					, @v_tact_time_end_date		AS tact_time_end_date
					, @v_tact_time			AS tact_time
					, @v_yield				AS yield
					, @v_except_comment		AS except_comment
					, @v_use_yn				AS use_yn
					, @v_org_division_id	AS org_division_id
					, @v_org_plant_site_id	AS org_plant_site_id
					, @v_org_item_id		AS org_item_id
					, @v_org_operation_id	AS org_operation_id
					, @v_org_line_id		AS org_line_id
					, @v_org_tact_time_start_date	AS org_tact_time_start_date
					, @v_org_tact_time_end_date		AS org_tact_time_end_date
			;
			
		END -- END OF STMT. WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt


		IF @mst_loop_cnt > 0
			BEGIN

				-- D 삭제
				DELETE A
				FROM SCP_MST_TACT_TIME_EXCEPT A, #TblDynamic_SCP0020 B
				WHERE A.division_id				= B.org_division_id
				AND A.plant_site_id				= B.org_plant_site_id
				AND A.item_id					= B.org_item_id
				AND A.operation_id				= B.org_operation_id
				AND A.line_id					= B.org_line_id
				AND A.tact_time_start_date		= B.org_tact_time_start_date
				AND A.tact_time_end_date		= B.org_tact_time_end_date
				AND B.active_flag				= 'D'
				;

				-- M 수정
				UPDATE A
				SET A.tact_time_start_date	= B.tact_time_start_date        
					,A.tact_time_end_date	= B.tact_time_end_date          
					,A.tact_time			= convert(float, B.tact_time)
					,A.yield				= convert(float, B.yield )/100
					,A.except_comment		= B.except_comment              
					,A.use_yn				= B.use_yn              
					,A.last_updated_by		= @p_user_id
					,A.last_update_date		= @d_event_date
				FROM SCP_MST_TACT_TIME_EXCEPT A WITH(NOLOCK)
				JOIN #TblDynamic_SCP0020 B WITH(NOLOCK) ON A.division_id		= B.org_division_id
														AND A.plant_site_id		= B.org_plant_site_id
														AND A.item_id			= B.org_item_id
														AND A.operation_id		= B.org_operation_id
														AND A.line_id			= B.org_line_id
														AND A.tact_time_start_date	= B.org_tact_time_start_date
														AND A.tact_time_end_date	= B.org_tact_time_end_date
														AND B.active_flag IN ('I','M')
				;

				-- I 입력
				INSERT INTO SCP_MST_TACT_TIME_EXCEPT
				(division_id                       
				,plant_site_id                     
				,item_id                           
				,operation_id                      
				,line_id                           
				,tact_time_start_date              
				,tact_time_end_date                
				,tact_time                         
				,yield                             
				,except_comment  
				,use_yn                  
				,created_by                        
				,creation_date                     
				,last_updated_by                   
				,last_update_date)
				SELECT 
					B.division_id                       
					,B.plant_site_id                     
					,B.item_id                           
					,B.operation_id                      
					,B.line_id                           
					,B.tact_time_start_date              
					,B.tact_time_end_date                
					,convert(float, B.tact_time)                         
					,convert(float, B.yield)/100                             
					,B.except_comment
					,B.use_yn                    
					,@p_user_id                        
					,@d_event_date                     
					,@p_user_id                   
					,@d_event_date 
				FROM #TblDynamic_SCP0020 B WITH(NOLOCK)
				WHERE 1=1
				AND B.active_flag IN ('I','M')
				AND NOT EXISTS (SELECT 'X' 
								FROM SCP_MST_TACT_TIME_EXCEPT A WITH(NOLOCK)
								WHERE 1=1
								AND A.division_id		= B.division_id
								AND A.plant_site_id		= B.plant_site_id
								AND A.item_id			= B.item_id
								AND A.operation_id		= B.operation_id
								AND A.line_id			= B.line_id
								AND A.tact_time_start_date	= B.tact_time_start_date
								AND A.tact_time_end_date	= B.tact_time_end_date)
				;

				-- History
				INSERT INTO SCP_MST_TACT_TIME_EXCEPT_H
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
					,except_comment
					,use_yn
					,created_by
					,creation_date
					,last_updated_by
					,last_update_date
					,history_creation_date)
				SELECT (NEXT VALUE FOR SEQ1_SCP_MST_TACT_TIME_EXCEPT_H),
						B.division_id, 
						B.plant_site_id, 
						B.item_id, 
						B.operation_id,
						B.line_id,
						B.tact_time_start_date,
						B.tact_time_end_date,
						B.tact_time , 
						B.yield , 
						B.except_comment ,
						B.use_yn,
						@p_user_id , 
						@d_event_date, 
						@p_user_id,	
						SYSDATETIME() ,
						SYSDATETIME() 
				FROM #TblDynamic_SCP0020 B
				;

			END


		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		--PRINT 'COMMIT'
		COMMIT TRAN;			
		
		-- 결과코드, 결과 카운트 반환
		SELECT  'S' AS result_code,  @mst_loop_cnt AS result_cnt ;

	END TRY

	BEGIN CATCH 
		BEGIN
			if (xact_state() <> 0) ROLLBACK TRAN; --입력 데이타 롤백 처리
						
			INSERT INTO scm_sys_log_batch (program_name,log_type,log_count,log_message,description,event_date,creation_date,created_by,last_update_date,last_updated_by)
			VALUES (@v_program_name,'ERROR',NULL,ERROR_MESSAGE(),NULL,SYSDATETIME(),SYSDATETIME(),ERROR_PROCEDURE(),SYSDATETIME(),ERROR_PROCEDURE());

			--IF @@TRANCOUNT > 0
			--  COMMIT WORK;					  

			-- error코드, errror 메시지 반환
			SELECT 'F' AS result_code;

			IF( @v_err_code IS NULL OR @v_err_code ='')
				SET @v_err_code= ERROR_NUMBER() ;
			IF( @v_err_message IS NULL OR @v_err_message ='') 
				SET @v_err_message=  ERROR_MESSAGE();
						
			/* 에러 메시지, 에러 데이터  반환   */	
			SELECT  @v_err_code			AS err_code
				   ,@v_err_message		AS err_message
				   --,@v_tact_time_start_date AS tact_time_start_date
				   --,@v_tact_time_end_date   AS tact_time_end_date
				   ,'' AS tact_time_start_date
				   ,'' AS tact_time_end_date
			; 
		END;
	END CATCH;

	IF OBJECT_ID('tempdb..#TblDynamic_SCP0020') IS NOT NULL	
		DROP TABLE #TblDynamic_SCP0020 
	;

END



