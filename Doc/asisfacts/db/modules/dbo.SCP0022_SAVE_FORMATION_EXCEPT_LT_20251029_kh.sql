



/*
 * Program ID   : [[SCP0022_SAVE_FORMATION_EXCEPT_LT]]
 * Description  : 활성화 LT 구간별 등록, 수정, 삭제
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2025/09/22   KH 	            Initial Release  PJ20257329    최적화 Planning Input Constraint UI 개발 및 Master Validation 확산
 *
 */
CREATE PROCEDURE [dbo].[SCP0022_SAVE_FORMATION_EXCEPT_LT_20251029_kh]
	  @p_active_flag 			NVARCHAR(MAX)
	, @p_division_id			NVARCHAR(MAX)
	, @p_plant_site_id			NVARCHAR(MAX)
	, @p_item_id				NVARCHAR(MAX)
	, @p_formation_start_date	NVARCHAR(MAX)
	, @p_formation_end_date		NVARCHAR(MAX)
	, @p_lt_formation   		NVARCHAR(MAX)
	, @p_add_lt_formation   	NVARCHAR(MAX)
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
	DECLARE @v_lt_formation			NVARCHAR(MAX) = null;
	DECLARE @v_add_lt_formation		NVARCHAR(MAX) = null;
	DECLARE @v_comment				NVARCHAR(MAX) = null;
	DECLARE @v_created_by			NVARCHAR(MAX) = null;
	DECLARE @v_last_updated_by	    NVARCHAR(MAX) = null;

	DECLARE @v_attribute1			NVARCHAR(MAX) = null;
	DECLARE @v_attribute2			NVARCHAR(MAX) = null;
	DECLARE @v_attribute3			NVARCHAR(MAX) = null;
	DECLARE @v_attribute4			NVARCHAR(MAX) = null;
	DECLARE @v_attribute5			NVARCHAR(MAX) = null;
	DECLARE @v_attribute6			NVARCHAR(MAX) = null;
	DECLARE @v_attribute7			NVARCHAR(MAX) = null;
	DECLARE @v_attribute8			NVARCHAR(MAX) = null;
	DECLARE @v_attribute9			NVARCHAR(MAX) = null;
	DECLARE @v_attribute10			NVARCHAR(MAX) = null;
	
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
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0022_SAVE_FORMATION_EXCEPT_LT';
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
				SET @v_active_flag           = dbo.SCM_ARR_SPL_VAL( @p_active_flag          , @v_delimiter, @mst_loop_cnt );
				SET @v_division_id           = dbo.SCM_ARR_SPL_VAL( @p_division_id          , @v_delimiter, @mst_loop_cnt );
				SET @v_plant_site_id         = dbo.SCM_ARR_SPL_VAL( @p_plant_site_id        , @v_delimiter, @mst_loop_cnt );
				SET @v_item_id			     = dbo.SCM_ARR_SPL_VAL( @p_item_id              , @v_delimiter, @mst_loop_cnt );
				SET @v_formation_start_date  = dbo.SCM_ARR_SPL_VAL( @p_formation_start_date , @v_delimiter, @mst_loop_cnt );
				SET @v_formation_end_date    = dbo.SCM_ARR_SPL_VAL( @p_formation_end_date   , @v_delimiter, @mst_loop_cnt );
				SET @v_lt_formation  	     = dbo.SCM_ARR_SPL_VAL( @p_lt_formation         , @v_delimiter, @mst_loop_cnt );
				SET @v_add_lt_formation  	 = dbo.SCM_ARR_SPL_VAL( @p_add_lt_formation     , @v_delimiter, @mst_loop_cnt );
				SET @v_comment				 = dbo.SCM_ARR_SPL_VAL( @p_comment              , @v_delimiter, @mst_loop_cnt );
				SET @v_org_division_id       = dbo.SCM_ARR_SPL_VAL( @p_org_division_id      , @v_delimiter, @mst_loop_cnt );
				SET @v_org_plant_site_id     = dbo.SCM_ARR_SPL_VAL( @p_org_plant_site_id    , @v_delimiter, @mst_loop_cnt );
				SET @v_org_item_id           = dbo.SCM_ARR_SPL_VAL( @p_org_item_id          , @v_delimiter, @mst_loop_cnt );
				SET @v_org_start_date        = dbo.SCM_ARR_SPL_VAL( @p_org_start_date       , @v_delimiter, @mst_loop_cnt );
				SET @v_org_end_date          = dbo.SCM_ARR_SPL_VAL( @p_org_end_date         , @v_delimiter, @mst_loop_cnt );

				SET @v_attribute1             = dbo.SCM_ARR_SPL_VAL( ''                     , @v_delimiter, @mst_loop_cnt );
				SET @v_attribute2             = dbo.SCM_ARR_SPL_VAL( ''                     , @v_delimiter, @mst_loop_cnt );
				SET @v_attribute3             = dbo.SCM_ARR_SPL_VAL( ''                     , @v_delimiter, @mst_loop_cnt );
				SET @v_attribute4             = dbo.SCM_ARR_SPL_VAL( ''                     , @v_delimiter, @mst_loop_cnt );
				SET @v_attribute5             = dbo.SCM_ARR_SPL_VAL( ''                     , @v_delimiter, @mst_loop_cnt );
				SET @v_attribute6             = dbo.SCM_ARR_SPL_VAL( ''                     , @v_delimiter, @mst_loop_cnt );
				SET @v_attribute7             = dbo.SCM_ARR_SPL_VAL( ''                     , @v_delimiter, @mst_loop_cnt );
				SET @v_attribute8             = dbo.SCM_ARR_SPL_VAL( ''                     , @v_delimiter, @mst_loop_cnt );
				SET @v_attribute9             = dbo.SCM_ARR_SPL_VAL( ''                     , @v_delimiter, @mst_loop_cnt );
				SET @v_attribute10            = dbo.SCM_ARR_SPL_VAL( ''                     , @v_delimiter, @mst_loop_cnt );

				--PRINT '6';
				--PRINT ' @v_valid_yn ='+ ISNULL(@v_valid_yn,'') ;
			END;

						-- LOOP 파라미터 출력 DEBUG용			
			IF (@debug_mode ='T') 
			BEGIN		
				PRINT '=================LOOP VARS==============================';			
				PRINT ' @v_active_flag          = ''' + @v_active_flag          + '''' ;
				PRINT ' @v_division_id          = ''' + @v_division_id          + '''' ;
				PRINT ' @v_plant_site_id        = ''' + @v_plant_site_id        + '''' ;
				PRINT ' @v_item_id				= ''' + @v_item_id           + '''' ;
				PRINT ' @v_formation_start_date = ''' + @v_formation_start_date      + '''' ;
				PRINT ' @v_formation_end_date   = ''' + @v_formation_end_date        + '''' ;
				PRINT ' @v_lt_formation 	    = ''' + @v_lt_formation		   + '''' ;
				PRINT ' @v_add_lt_formation		= ''' + @v_add_lt_formation		   + '''' ;
				PRINT ' @v_comment			    = ''' + @v_comment			   + '''' ;
				PRINT ' @v_org_division_id      = ''' + @v_org_division_id      + '''' ;
				PRINT ' @v_org_plant_site_id    = ''' + @v_org_plant_site_id    + '''' ;
				PRINT ' @v_org_item_id          = ''' + @v_org_item_id       + '''' ;
				PRINT ' @v_org_start_date       = ''' + @v_org_start_date  + '''' ;
				PRINT ' @v_org_end_date         = ''' + @v_org_end_date    + '''' ;
			END;
			 
			--데이터 저장
			IF @mst_loop_cnt > 0 		
			IF @v_active_flag != 'D'	
				BEGIN
				
					--declare @dYield numeric(20,10) = convert(numeric(20,4) , @v_formation_yield);
					declare @dLT numeric(20,10) = convert(int , @v_lt_formation);
					declare @dAddLT numeric(20,10) = convert(int , @v_add_lt_formation);
					declare @dtCurrent datetime = SYSDATETIME();

					
					/**** 날짜 중복 체크 ****/
					DECLARE @cnt INTEGER;
					SELECT @cnt = COUNT(1)
					FROM SCP_OPMZ_MST_FORMATION_EXCEPT_LT x
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
					/**** 날ㅉ 중복 체크 END ***/

					MERGE INTO SCP_OPMZ_MST_FORMATION_EXCEPT_LT a
					USING (
							SELECT 
									 @v_org_division_id		AS division_id
									,@v_org_plant_site_id	AS plant_site_id
									,@v_org_item_id			AS item_id
									,@v_org_start_date      AS formation_start_date
									,@v_org_end_date	    AS formation_end_date
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
							,lt_formation   	     = CASE WHEN ISNULL(@v_lt_formation,    '')='' THEN 0 ELSE   convert(int, @v_lt_formation)  end
							,add_lt_formation   	 = CASE WHEN ISNULL(@v_add_lt_formation,'')='' THEN NULL ELSE   convert(int, @v_add_lt_formation)  end
							,except_comment      = @v_comment
							,last_updated_by	 = @p_last_updated_by
							,last_update_date	 = @dtCurrent
					WHEN NOT MATCHED THEN							                                             
						INSERT 	   ( division_id                    
									,plant_site_id                  
									,item_id                     
									,formation_start_date                   
									,formation_end_date
									,lt_formation
									,add_lt_formation
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
									,CASE WHEN ISNULL(@v_lt_formation,        '')='' THEN 0 ELSE   convert(int, @v_lt_formation) END
									,CASE WHEN ISNULL(@v_add_lt_formation,    '')='' THEN NULL ELSE   convert(int, @v_add_lt_formation) END
									,@v_comment
									,@p_created_by
									,@dtCurrent
									,@p_last_updated_by 
									,@dtCurrent
									);

					declare @p_creation_date datetime =  SYSDATETIME();

					EXEC [dbo].[PR_SCP_MST_FORMATION_EXCEPT_LT_HIST]
						@v_division_id , @v_plant_site_id , @v_item_id , @v_formation_start_date , @v_formation_end_date ,
						@v_lt_formation, @v_add_lt_formation, @v_comment , @p_created_by , @p_last_updated_by	, @dtCurrent,
						@v_attribute1, @v_attribute2, @v_attribute3, @v_attribute4, @v_attribute5,
						@v_attribute6, @v_attribute7, @v_attribute8, @v_attribute9, @v_attribute10 
						
					;

				END;
			ELSE IF @v_active_flag = 'D'
				BEGIN
					DELETE FROM SCP_OPMZ_MST_FORMATION_EXCEPT_LT
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



