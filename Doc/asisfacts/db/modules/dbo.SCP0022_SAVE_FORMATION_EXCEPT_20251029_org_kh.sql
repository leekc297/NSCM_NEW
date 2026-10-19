



/*
 * Program ID   : [SCP0019_SAVE_WORKING_TIME]
 * Description  : Working Time 등록, 수정, 삭제
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2018/03/14   pjs				Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/05/28	hwyoon			except 시트 삭제로직 추가
 * 2019/04/08	hwyoon			[CSR:]GSCM 고도화 - Formation 수율 필드 추가, 기능개선
 * 2025/09/22   KH 	            PJ20257329    최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - 날짜중복체크 추가
 *
 */
CREATE PROCEDURE [dbo].[SCP0022_SAVE_FORMATION_EXCEPT_20251029_org_kh]
	  @p_active_flag 			NVARCHAR(MAX)
	, @p_division_id			NVARCHAR(MAX)
	, @p_plant_site_id			NVARCHAR(MAX)
	, @p_item_id				NVARCHAR(MAX)
	, @p_formation_start_date	NVARCHAR(MAX)
	, @p_formation_end_date		NVARCHAR(MAX)
	, @p_formation_yield		NVARCHAR(MAX)
	, @p_char_yield				NVARCHAR(MAX)
	, @p_formation_total_yield	NVARCHAR(MAX)
	, @p_comment				NVARCHAR(MAX)
	, @p_created_by				NVARCHAR(MAX)
	, @p_last_updated_by		NVARCHAR(MAX)
	, @p_org_division_id		NVARCHAR(MAX)
	, @p_org_plant_site_id		NVARCHAR(MAX)
	, @p_org_item_id			NVARCHAR(MAX)
	, @p_org_start_date			NVARCHAR(MAX)
	, @p_org_end_date			NVARCHAR(MAX)
	,@debug_mode          NVARCHAR(1) ='F'

AS

BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

	DECLARE @recv_active_flag		NVARCHAR(MAX);
	SET @recv_active_flag = @p_active_flag

	declare @v_active_flag			NVARCHAR(MAX) = null;
	DECLARE @v_division_id			NVARCHAR(MAX) = null;
	DECLARE @v_plant_site_id		NVARCHAR(MAX) = null;
	DECLARE @v_item_id				NVARCHAR(MAX) = null;
	DECLARE @v_formation_start_date	NVARCHAR(MAX) = null;
	DECLARE @v_formation_end_date	NVARCHAR(MAX) = null;
	DECLARE @v_formation_yield		NVARCHAR(MAX) = null;
	DECLARE @v_char_yield			NVARCHAR(MAX) = null;
	DECLARE @v_formation_total_yield	NVARCHAR(MAX) = null;
	DECLARE @v_comment				NVARCHAR(MAX) = null;
	DECLARE @v_created_by			NVARCHAR(MAX) = null;
	DECLARE @v_last_updated_by	    NVARCHAR(MAX) = null;
	
	-- 수정시 필요한 pk원본 값 2018-04-09 추가 pjs
	DECLARE @v_org_division_id		NVARCHAR(MAX) = NULL;
	DECLARE @v_org_plant_site_id	NVARCHAR(MAX) = NULL;
	DECLARE @v_org_item_id			NVARCHAR(MAX) = NULL;
	DECLARE @v_org_start_date		NVARCHAR(MAX) = NULL;
	DECLARE @v_org_end_date			NVARCHAR(MAX) = NULL;

	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^' 
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0022_SAVE_FORMATION_EXCEPT';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	DECLARE @v_data_dup_cnt  INT=0;
	
	-- 예외처리 변수 설정
	DECLARE @v_err_code  INTEGER;
	DECLARE @v_err_message  NVARCHAR(4000)='';
	
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
				SET @v_active_flag      = dbo.SCM_ARR_SPL_VAL( @p_active_flag       , @v_delimiter, @mst_loop_cnt );
				SET @v_division_id      = dbo.SCM_ARR_SPL_VAL( @p_division_id       , @v_delimiter, @mst_loop_cnt );
				SET @v_plant_site_id    = dbo.SCM_ARR_SPL_VAL( @p_plant_site_id     , @v_delimiter, @mst_loop_cnt );
				SET @v_item_id			= dbo.SCM_ARR_SPL_VAL( @p_item_id           , @v_delimiter, @mst_loop_cnt );
				SET @v_formation_start_date  = dbo.SCM_ARR_SPL_VAL( @p_formation_start_date     , @v_delimiter, @mst_loop_cnt );
				SET @v_formation_end_date    = dbo.SCM_ARR_SPL_VAL( @p_formation_end_date     , @v_delimiter, @mst_loop_cnt );
				SET @v_formation_yield	= dbo.SCM_ARR_SPL_VAL( @p_formation_yield     , @v_delimiter, @mst_loop_cnt );
				SET @v_char_yield	= dbo.SCM_ARR_SPL_VAL( @p_char_yield     , @v_delimiter, @mst_loop_cnt );
				SET @v_formation_total_yield	= dbo.SCM_ARR_SPL_VAL( @p_formation_total_yield     , @v_delimiter, @mst_loop_cnt );
				SET @v_comment				= dbo.SCM_ARR_SPL_VAL( @p_comment , @v_delimiter, @mst_loop_cnt );
				SET @v_org_division_id     = dbo.SCM_ARR_SPL_VAL( @p_org_division_id     , @v_delimiter, @mst_loop_cnt );
				SET @v_org_plant_site_id   = dbo.SCM_ARR_SPL_VAL( @p_org_plant_site_id   , @v_delimiter, @mst_loop_cnt );
				SET @v_org_item_id      = dbo.SCM_ARR_SPL_VAL( @p_org_item_id      , @v_delimiter, @mst_loop_cnt );
				SET @v_org_start_date = dbo.SCM_ARR_SPL_VAL( @p_org_start_date , @v_delimiter, @mst_loop_cnt );
				SET @v_org_end_date   = dbo.SCM_ARR_SPL_VAL( @p_org_end_date   , @v_delimiter, @mst_loop_cnt );

				--PRINT '6';
				--PRINT ' @v_valid_yn ='+ ISNULL(@v_valid_yn,'') ;
			END;

						-- LOOP 파라미터 출력 DEBUG용			
			IF (@debug_mode ='T') 
			BEGIN		
				PRINT '=================LOOP VARS==============================';			
				PRINT ' @v_active_flag         = ''' + @v_active_flag          + '''' ;
				PRINT ' @v_division_id         = ''' + @v_division_id          + '''' ;
				PRINT ' @v_plant_site_id       = ''' + @v_plant_site_id        + '''' ;
				PRINT ' @v_item_id				= ''' + @v_item_id           + '''' ;
				PRINT ' @v_formation_start_date = ''' + @v_formation_start_date      + '''' ;
				PRINT ' @v_formation_end_date   = ''' + @v_formation_end_date        + '''' ;
				PRINT ' @v_formation_yield	   = ''' + @v_formation_yield		   + '''' ;
				PRINT ' @v_char_yield			= ''' + @v_char_yield		   + '''' ;
				PRINT ' @v_formation_total_yield	   = ''' + @v_formation_total_yield		   + '''' ;
				PRINT ' @v_comment			   = ''' + @v_comment			   + '''' ;
				PRINT ' @v_org_division_id     = ''' + @v_org_division_id      + '''' ;
				PRINT ' @v_org_plant_site_id   = ''' + @v_org_plant_site_id    + '''' ;
				PRINT ' @v_org_item_id      = ''' + @v_org_item_id       + '''' ;
				PRINT ' @v_org_start_date = ''' + @v_org_start_date  + '''' ;
				PRINT ' @v_org_end_date   = ''' + @v_org_end_date    + '''' ;
			END;

			--데이터 저장
			IF @mst_loop_cnt > 0 		
			IF @v_active_flag != 'D'	
				BEGIN
				
				   -- [PJ20257329] 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - START 
					/**** 날짜 중복 체크 ****/
					DECLARE @cnt INTEGER;
					SELECT @cnt = COUNT(1)
					FROM SCP_MST_FORMATION_EXCEPT x
					WHERE DIVISION_ID	= @v_division_id
					AND plant_site_id   = @v_plant_site_id
					AND item_id	        = @v_item_id
					AND NOT ( @v_formation_end_date   < x.formation_start_date OR @v_formation_start_date > x.formation_end_date )
					AND NOT (x.formation_start_date = @v_org_start_date AND X.formation_end_date = @v_org_end_date ) -- 기존 값
 
					IF(@cnt > 0)
					BEGIN
						SET @v_err_code    = 99010 ; 
						SET @v_err_message = N' 입력 데이터 중 날짜가 중복되는 데이터가 있습니다.';
						THROW  @v_err_code, @v_err_message , 1; --예외발생
					END
					/**** 날짜 중복 체크 END ***/
					-- [PJ20257329] 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - END

					--declare @dYield numeric(20,10) = convert(numeric(20,4) , @v_formation_yield);
					declare @dYield numeric(20,10) = convert(numeric(20,4) , convert(float , @v_formation_yield) / 100);
					declare @dcharY numeric(20,10) = convert(numeric(20,4) , convert(float , @v_char_yield) / 100);
					declare @dtotalY numeric(20,10) = convert(numeric(20,4) , convert(float , @v_formation_total_yield) / 100);
					declare @dtCurrent datetime = SYSDATETIME();

					MERGE INTO SCP_MST_FORMATION_EXCEPT a
					USING (
							SELECT 
										@v_org_division_id		AS division_id
									,@v_org_plant_site_id	AS plant_site_id
									,@v_org_item_id			AS item_id
									,@v_org_start_date AS formation_start_date
									,@v_org_end_date	AS formation_end_date
							) b
					ON(
							a.division_id			= b.division_id
						AND a.plant_site_id			= b.plant_site_id
						AND a.item_id				= b.item_id
						AND a.formation_start_date	= b.formation_start_date
						AND a.formation_end_date	= b.formation_end_date
					)
					WHEN MATCHED THEN
						UPDATE SET
								formation_start_date	 = @v_formation_start_date
							,formation_end_date		 = @v_formation_end_date
							,formation_yield		 = CASE WHEN ISNULL(@v_formation_yield,'')='' THEN null ELSE (convert(numeric(20,4) , convert(float , @v_formation_yield) / 100)) end
							,CHAR_YIELD				 = CASE WHEN ISNULL(@v_char_yield,'')='' THEN null ELSE (convert(numeric(20,4) , convert(float , @v_char_yield) / 100)) end
							,FORMATION_TOTAL_YIELD	 = CASE WHEN ISNULL(@v_formation_total_yield,'')='' THEN null ELSE (convert(numeric(20,4) , convert(float , @v_formation_total_yield) / 100)) end
							,except_comment      = @v_comment
							,last_updated_by	 = @p_last_updated_by
							,last_update_date	 = @dtCurrent
					WHEN NOT MATCHED THEN							                                             
						INSERT 	   ( division_id                    
									,plant_site_id                  
									,item_id                     
									,formation_start_date                   
									,formation_end_date
									,formation_yield
									,CHAR_YIELD
									,FORMATION_TOTAL_YIELD
									,except_comment
									,created_by                     
									,creation_date                  
									,last_updated_by
									,last_update_date               
									)                   
								VALUES                                  
									(@v_division_id     
									,@v_plant_site_id   
									,@v_item_id      
									,@v_formation_start_date    
									,@v_formation_end_date
									,CASE WHEN ISNULL(@v_formation_yield,'')='' THEN null ELSE (convert(numeric(20,4) , convert(float , @v_formation_yield) / 100)) end
									,CASE WHEN ISNULL(@v_char_yield,'')='' THEN null ELSE (convert(numeric(20,4) , convert(float , @v_char_yield) / 100)) end
									,CASE WHEN ISNULL(@v_formation_total_yield,'')='' THEN null ELSE (convert(numeric(20,4) , convert(float , @v_formation_total_yield) / 100)) end
									,@v_comment
									,@p_created_by
									,@dtCurrent
									,@p_last_updated_by 
									,@dtCurrent
									);

					declare @p_creation_date datetime =  SYSDATETIME();

					EXEC [dbo].[PR_SCP_MST_FORMATION_EXCEPT_HIST]
						@v_division_id , @v_plant_site_id , @v_item_id , @v_formation_start_date , @v_formation_end_date ,
						@v_formation_yield , @v_char_yield , @v_formation_total_yield , @v_comment , @p_created_by , @p_last_updated_by	, @dtCurrent
					;

				END;
			ELSE IF @v_active_flag = 'D'
				BEGIN
					DELETE FROM SCP_MST_FORMATION_EXCEPT
						  WHERE division_id				= @v_org_division_id
							AND plant_site_id			= @v_org_plant_site_id
							AND item_id					= @v_org_item_id
							AND formation_start_date	= @v_org_start_date
							AND formation_end_date		= @v_org_end_date
				END;
			
		END -- END OF STMT. WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt

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
				   ,@v_formation_start_date  AS formation_start_date
				   ,@v_formation_end_date    AS formation_end_date
			; 
		END;
	END CATCH;
END



