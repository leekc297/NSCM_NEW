


/*
 * Program ID   : SCP0053_SAVE_SCP_BOM
 * Description  : SCP BOM 수정
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/03/27   PJG				Initial Release (PJ20209642 Digital SCM Level.3 달성을 위한 개선)
 * 2022-07-25   jahn1501        PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - SCPYN 설정값이 동시 반영되도록 Plant Id 조건 제외.
 * 2022-10-25   jahn1501   		PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - p_si_alt_priority, p_si_scp_yn parameter 추가
 * 2025-08-14   twinlove        PJ20257329   최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - OPT YN추가
 */
CREATE PROCEDURE [dbo].[SCP0053_SAVE_SCP_BOM]
	 @p_active_flag        NVARCHAR(MAX)
	,@p_division_id        NVARCHAR(MAX)
	,@p_plant_cd           NVARCHAR(MAX)
	,@p_model_id           NVARCHAR(MAX)
	,@p_parent_item_id     NVARCHAR(MAX)
	,@p_child_item_id      NVARCHAR(MAX)
	,@p_alt_id             NVARCHAR(MAX)
	,@p_eff_start_date     NVARCHAR(MAX)
	,@p_eff_end_date       NVARCHAR(MAX)
	,@p_eco_code           NVARCHAR(MAX)
	,@p_scp_yn             NVARCHAR(MAX)
	,@p_si_alt_priority    NVARCHAR(MAX)
	,@p_si_scp_yn          NVARCHAR(MAX)
	--,@p_opt_yn			   NVARCHAR(MAX)    --  PJ20257329   최적화 Planning Input Constraint UI 개발 및 Master Validation 확산
	,@p_user_id            NVARCHAR(MAX)
	,@debug_mode           NVARCHAR(1) ='F'
AS

BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	
	DECLARE @v_working_time     datetime =sysdatetime();     
	DECLARE @recv_active_flag	NVARCHAR(MAX);
	SET @recv_active_flag = NULL;		
	SET @recv_active_flag = @p_active_flag;


	DECLARE @v_active_flag        NVARCHAR(MAX);
	DECLARE @v_division_id        NVARCHAR(MAX);
	DECLARE @v_plant_cd           NVARCHAR(MAX);
	DECLARE @v_model_id           NVARCHAR(MAX);
	DECLARE @v_parent_item_id     NVARCHAR(MAX);
	DECLARE @v_child_item_id      NVARCHAR(MAX);
	DECLARE @v_alt_id             NVARCHAR(MAX);
	DECLARE @v_eff_start_date     NVARCHAR(MAX);
	DECLARE @v_eff_end_date       NVARCHAR(MAX);
	DECLARE @v_eco_code           NVARCHAR(MAX);
	DECLARE @v_scp_yn             NVARCHAR(MAX);
	DECLARE @v_si_alt_priority    NVARCHAR(MAX);
	DECLARE @v_si_scp_yn          NVARCHAR(MAX);
	--DECLARE @v_opt_yn             NVARCHAR(MAX);   --  PJ20257329   최적화 Planning Input Constraint UI 개발 및 Master Validation 확산

	DECLARE @v_created_by         NVARCHAR(MAX);
	DECLARE @v_creation_date      datetime	;
	DECLARE @v_last_updated_by    NVARCHAR(MAX);
	DECLARE @v_last_update_date   datetime	;

	DECLARE @v_input_status		  NVARCHAR(MAX) ;

	--SET @v_created_by       = @p_user_id;

	SET @v_creation_date    = @v_working_time;
	SET @v_last_updated_by  = @p_user_id
	SET @v_last_update_date = @v_working_time

	SET @v_active_flag    = NULL;
	SET @v_division_id    = NULL;
	SET @v_plant_cd       = NULL;
	SET @v_model_id       = NULL;
	SET @v_parent_item_id = NULL;
	SET @v_child_item_id  = NULL;
	SET @v_alt_id         = NULL;
	SET @v_eff_start_date = NULL;
	SET @v_eff_end_date   = NULL;
	SET @v_eco_code       = NULL;
	SET @v_scp_yn         = NULL;
	SET @v_si_alt_priority   = NULL;
	SET @v_si_scp_yn         = NULL;
	--SET @v_opt_yn			 = NULL;          --  PJ20257329   최적화 Planning Input Constraint UI 개발 및 Master Validation 확산

	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^' 
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = '[SCP0053_SAVE_SCP_BOM]';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	-- 예외처리 변수 설정
	DECLARE @v_err_code  INTEGER;
	DECLARE @v_err_message  NVARCHAR(4000)='';
	
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
				SET @v_active_flag    = dbo.SCM_ARR_SPL_VAL(@p_active_flag    , @v_delimiter, @mst_loop_cnt ) ;
				SET @v_division_id    = dbo.SCM_ARR_SPL_VAL(@p_division_id    , @v_delimiter, @mst_loop_cnt ) ;
				SET @v_plant_cd       = dbo.SCM_ARR_SPL_VAL(@p_plant_cd       , @v_delimiter, @mst_loop_cnt ) ;
				SET @v_model_id       = dbo.SCM_ARR_SPL_VAL(@p_model_id       , @v_delimiter, @mst_loop_cnt ) ;
				SET @v_parent_item_id = dbo.SCM_ARR_SPL_VAL(@p_parent_item_id , @v_delimiter, @mst_loop_cnt ) ;
				SET @v_child_item_id  = dbo.SCM_ARR_SPL_VAL(@p_child_item_id  , @v_delimiter, @mst_loop_cnt ) ;
				SET @v_alt_id         = dbo.SCM_ARR_SPL_VAL(@p_alt_id         , @v_delimiter, @mst_loop_cnt ) ;
				SET @v_eff_start_date = dbo.SCM_ARR_SPL_VAL(@p_eff_start_date , @v_delimiter, @mst_loop_cnt ) ;
				SET @v_eff_end_date   = dbo.SCM_ARR_SPL_VAL(@p_eff_end_date   , @v_delimiter, @mst_loop_cnt ) ;
				--SET @v_eff_start_date = CONVERT(DATETIME, dbo.SCM_ARR_SPL_VAL(@p_eff_start_date , @v_delimiter, @mst_loop_cnt )) ;
				--SET @v_eff_end_date   = CONVERT(DATETIME, dbo.SCM_ARR_SPL_VAL(@p_eff_end_date   , @v_delimiter, @mst_loop_cnt )) ;
				SET @v_eco_code       = dbo.SCM_ARR_SPL_VAL(@p_eco_code       , @v_delimiter, @mst_loop_cnt ) ;
				SET @v_scp_yn         = dbo.SCM_ARR_SPL_VAL(@p_scp_yn         , @v_delimiter, @mst_loop_cnt ) ;
				SET @v_si_alt_priority		= dbo.SCM_ARR_SPL_VAL(@p_si_alt_priority   , @v_delimiter, @mst_loop_cnt ) ;   --  PJ20257329   최적화 Planning Input Constraint UI 개발 및 Master Validation 확산
				SET @v_si_scp_yn         	= dbo.SCM_ARR_SPL_VAL(@p_si_scp_yn         , @v_delimiter, @mst_loop_cnt ) ;   --  PJ20257329   최적화 Planning Input Constraint UI 개발 및 Master Validation 확산
				--SET @v_opt_yn         		= dbo.SCM_ARR_SPL_VAL(@p_opt_yn			   , @v_delimiter, @mst_loop_cnt ) ;   --  PJ20257329   최적화 Planning Input Constraint UI 개발 및 Master Validation 확산
			END;

			-- LOOP 파라미터 출력 DEBUG용			
			IF (@debug_mode ='T') 
			BEGIN		
				PRINT '===============================================';			
				PRINT '@mst_loop_cnt      = ' + CONVERT(VARCHAR,@mst_loop_cnt)   ;
				PRINT '@v_active_flag     = ''' + @v_active_flag     + '''' ;
				PRINT '@v_division_id     = ''' + @v_division_id     + '''' ;
				PRINT '@v_plant_cd        = ''' + @v_plant_cd        + '''' ;
				PRINT '@v_model_id        = ''' + @v_model_id        + '''' ;
				PRINT '@v_parent_item_id  = ''' + @v_parent_item_id  + '''' ;
				PRINT '@v_child_item_id   = ''' + @v_child_item_id   + '''' ;
				PRINT '@v_alt_id          = ''' + @v_alt_id          + '''' ;
				PRINT '@v_eff_start_date  = ''' + @v_eff_start_date  + '''' ;
				PRINT '@v_eff_end_date    = ''' + @v_eff_end_date    + '''' ;
				PRINT '@v_eco_code        = ''' + @v_eco_code        + '''' ;
				PRINT '@v_scp_yn          = ''' + @v_scp_yn          + '''' ;
				PRINT '@v_si_alt_priority			= ''' + @v_si_alt_priority    + '''' ;
				PRINT '@v_si_scp_yn          		= ''' + @v_si_scp_yn          + '''' ;
				--PRINT '@v_opt_yn          		    = ''' + @v_opt_yn          + '''' ;
			END;

		   --이력저장
			EXEC [dbo].PR_SCM_MST_ALTER_BOM_H
						 @v_division_id  
						,@v_plant_cd
						,@v_model_id      
						,@v_parent_item_id 
						,@v_child_item_id      
						,@v_alt_id     
						,@v_eff_start_date
						,@v_eff_end_date
						,@v_eco_code
						,@v_scp_yn
						,@v_si_alt_priority
						,@v_si_scp_yn
						--,@v_opt_yn                  --  PJ20257329   최적화 Planning Input Constraint UI 개발 및 Master Validation 확산
						,@v_creation_date
						,@v_last_updated_by

			--데이터 저장
			IF @mst_loop_cnt > 0 			
				BEGIN		
					IF( @v_active_flag ='M') 
						BEGIN
							UPDATE dbo.SCM_MST_ALTER_BOM                 
							   SET SCP_PLAN_YN		= @v_scp_yn
							     , ATTRIBUTE11		= @v_si_alt_priority
							     , ATTRIBUTE12		= @v_si_scp_yn
								 --, ATTRIBUTE13      = @v_opt_yn          --  PJ20257329   최적화 Planning Input Constraint UI 개발 및 Master Validation 확산
 							 WHERE DIVISION_ID      = @v_division_id     
							   --AND PLANT_ID         = @v_plant_cd
							   AND PARENT_ITEM_ID   = @v_parent_item_id   
							   AND CHILD_ITEM_ID    = @v_child_item_id         
							  ;
						END ;
				END  -- END OF STMT. IF( @mst_loop_cnt > 0 )			
			
		END -- END OF STMT. WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt

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
						
			INSERT INTO scm_sys_log_batch (program_name,log_type,log_count,log_message,description,event_date,creation_date,created_by,last_update_date,last_updated_by)
			VALUES (ERROR_PROCEDURE(),'ERROR',NULL,ERROR_MESSAGE(),NULL,SYSDATETIME(),SYSDATETIME(),ERROR_PROCEDURE(),SYSDATETIME(),ERROR_PROCEDURE());

			-- error코드, errror 메시지 반환
			SELECT 'F' AS result_code;

			IF( @v_err_code IS NULL OR @v_err_code ='')
				SET @v_err_code= ERROR_NUMBER() ;
			IF( @v_err_message IS NULL OR @v_err_message ='') 
				SET @v_err_message=  ERROR_MESSAGE();
			   						
			/* 에러 메시지, 에러 데이터  반환   */	
			SELECT  @v_err_code			AS err_code
				   ,@v_err_message		AS err_message
				   ,@v_division_id      AS DIVISION_ID  
				   ,@v_plant_cd         AS PLANT_CD
				   ,@v_parent_item_id   AS PARENT_ITEM_ID
				   ,@v_child_item_id    AS CHILD_ITEM_ID
				   ,@v_scp_yn           AS SCP_YN
			; 
		END;
	END CATCH;
END
