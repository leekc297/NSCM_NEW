


/*
 * Program ID   : SCP0022_SAVE_FORMATION
 * Description  : Formation 등록, 수정, 삭제
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/03/14   kyh				Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/06/18	kyh				신규 컬럼 추가. @p_Add_LT_Formation
 * 2109/04/08	yhw				[CSR:]GSCM 고도화 - Formation 수율 필드 추가, 기능개선
 * 2019/04/11	AYJ				SSP_MODIFY_YIELD 컬럼 추가
 */
CREATE PROCEDURE [dbo].[SCP0022_SAVE_FORMATION_20251029_ORG]
	  @p_active_flag 			NVARCHAR(MAX)
	, @p_division_id			NVARCHAR(MAX)
	, @p_plant_site_id			NVARCHAR(MAX)
	, @p_item_id				NVARCHAR(MAX)
	, @p_Lf_Formation			NVARCHAR(MAX)
	, @p_Add_LT_Formation		NVARCHAR(MAX)
	, @p_formation_yield		NVARCHAR(MAX)	
	, @p_char_yield				NVARCHAR(MAX)	
	, @p_formation_total_yield	NVARCHAR(MAX)	
	, @p_created_by				NVARCHAR(MAX)
	, @p_last_updated_by		NVARCHAR(MAX)
	, @p_user_modify_yield		NVARCHAR(MAX)
AS

BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

	DECLARE @recv_active_flag		NVARCHAR(MAX);
	SET @recv_active_flag = NULL;		
	SET @recv_active_flag = @p_active_flag;

	DECLARE @v_active_flag 				NVARCHAR(MAX) = null;
	DECLARE @v_division_id				NVARCHAR(MAX) = null;
	DECLARE @v_plant_site_id			NVARCHAR(MAX) = null;
	DECLARE @v_item_id					NVARCHAR(MAX) = null;
	DECLARE @v_Lf_Formation				NVARCHAR(MAX) = null;
	DECLARE @v_Add_LT_Formation			NVARCHAR(MAX) = null;
	DECLARE @v_formation_yield			NVARCHAR(MAX) = null;
	DECLARE @v_char_yield				NVARCHAR(MAX) = null;
	DECLARE @v_formation_total_yield	NVARCHAR(MAX) = null;
	DECLARE @v_created_by				NVARCHAR(MAX) = null;
	DECLARE @v_last_updated_by			NVARCHAR(MAX) = null;
	DECLARE @v_user_modify_yield			NVARCHAR(MAX) = null;

	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^' 
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0022_SAVE_Formation';
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
		SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_active_flag, @v_delimiter);    
		
		WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt
		BEGIN    
				
			-- @mst_loop_cnt 1증가
			SET @mst_loop_cnt = @mst_loop_cnt + 1;			

			-- 각 컬럼들에 대한 스플릿처리로직 스타트
			BEGIN
				SET @v_active_flag				= dbo.SCM_ARR_SPL_VAL( @p_active_flag	    , @v_delimiter, @mst_loop_cnt );
				SET @v_division_id				= dbo.SCM_ARR_SPL_VAL( @p_division_id       , @v_delimiter, @mst_loop_cnt );
				SET @v_plant_site_id			= dbo.SCM_ARR_SPL_VAL( @p_plant_site_id     , @v_delimiter, @mst_loop_cnt );
				SET @v_item_id					= dbo.SCM_ARR_SPL_VAL( @p_item_id     , @v_delimiter, @mst_loop_cnt );
				SET @v_Lf_Formation				= dbo.SCM_ARR_SPL_VAL( @p_Lf_Formation     , @v_delimiter, @mst_loop_cnt );
				SET @v_Add_LT_Formation			= dbo.SCM_ARR_SPL_VAL( @p_Add_LT_Formation     , @v_delimiter, @mst_loop_cnt );
				SET @v_formation_yield			= dbo.SCM_ARR_SPL_VAL( @p_formation_yield     , @v_delimiter, @mst_loop_cnt );
				SET @v_char_yield				= dbo.SCM_ARR_SPL_VAL( @p_char_yield     , @v_delimiter, @mst_loop_cnt );
				SET @v_formation_total_yield    = dbo.SCM_ARR_SPL_VAL( @p_formation_total_yield     , @v_delimiter, @mst_loop_cnt );
				SET @v_user_modify_yield		= dbo.SCM_ARR_SPL_VAL( @p_user_modify_yield     , @v_delimiter, @mst_loop_cnt );

				--PRINT '6';
				--PRINT ' @v_valid_yn ='+ ISNULL(@v_valid_yn,'') ;
			END;

			declare @p_creation_date datetime =  SYSDATETIME();

		   --이력저장
			EXEC [dbo].[PR_SCP_MST_FORMATION_HIST] 
				@v_division_id, @v_plant_site_id, @v_item_id , @v_Lf_Formation , @v_Add_LT_Formation, @v_formation_yield ,@v_char_yield , @v_formation_total_yield , 
				@p_created_by, @p_last_updated_by , @p_creation_date, @v_user_modify_yield
			;
			
			--데이터 저장
			IF @mst_loop_cnt > 0
			BEGIN
				MERGE INTO SCP_MST_FORMATION A
				USING (
					SELECT 
						  @v_division_id as division_id
						, @v_plant_site_id as plant_site_id
						, @v_item_id as item_id
				) B
				ON(
						A.division_id = B.division_id
					AND A.plant_site_id = B.plant_site_id
					AND A.item_id = B.item_id
				)
				WHEN MATCHED THEN
					UPDATE SET 
						  lt_formation			= @v_Lf_Formation
						, ATTRIBUTE1			= @v_Add_LT_Formation
						, formation_yield		= CASE WHEN ISNULL(@v_formation_yield,'')='' THEN null ELSE (convert(float , @v_formation_yield) / 100) end
						, CHAR_YIELD			= CASE WHEN ISNULL(@v_char_yield,'')='' THEN null ELSE (convert(float , @v_char_yield) / 100)  end
						, FORMATION_TOTAL_YIELD	= CASE WHEN ISNULL(@v_formation_total_yield,'')='' THEN null ELSE (convert(float , @v_formation_total_yield) / 100) end
						, last_updated_by		= @p_last_updated_by
						, last_update_date		= sysdatetime()
						, SSP_MODIFY_YIELD		= CASE WHEN ISNULL(@v_user_modify_yield,'')='' THEN null ELSE (convert(float , @v_user_modify_yield) / 100) end
				WHEN NOT MATCHED THEN							                                             
					INSERT 	   (
						  division_id                    
						, plant_site_id                  
						, ITEM_ID
						, LT_FORMATION
						, FORMATION_YIELD
						, CHAR_YIELD
						, FORMATION_TOTAL_YIELD
						, created_by
						, creation_date                  
						, last_updated_by                
						, last_update_date
						, ATTRIBUTE1
						, SSP_MODIFY_YIELD
					)                   
					VALUES (
						  @v_division_id     
						, @v_plant_site_id   
						, @v_item_id
						, @v_Lf_Formation
						, CASE WHEN ISNULL(@v_formation_yield,'')='' THEN null ELSE (convert(float , @v_formation_yield) / 100) end
						, CASE WHEN ISNULL(@v_char_yield,'')='' THEN null ELSE (convert(float , @v_char_yield) / 100)  end
						, CASE WHEN ISNULL(@v_formation_total_yield,'')='' THEN null ELSE (convert(float , @v_formation_total_yield) / 100) end
						, @p_created_by
						, sysdatetime()
						, @p_last_updated_by 
						, sysdatetime()
						, @v_Add_LT_Formation
						, CASE WHEN ISNULL(@v_user_modify_yield,'')='' THEN null ELSE (convert(float , @v_user_modify_yield) / 100) end
					);
			END
		END -- END OF STMT. WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt

		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		COMMIT TRAN;			
		
		---- 결과코드, 결과 카운트 반환
		--SELECT  'S' AS result_code,  @mst_loop_cnt AS result_cnt ;

	END TRY

	BEGIN CATCH 
		BEGIN
			if (xact_state() <> 0) ROLLBACK TRAN; --입력 데이타 롤백 처리
						
			INSERT INTO scm_sys_log_batch (program_name,log_type,log_count,log_message,description,event_date,creation_date,created_by,last_update_date,last_updated_by)
			VALUES (ERROR_PROCEDURE(),'ERROR',NULL,ERROR_MESSAGE(),NULL,SYSDATETIME(),SYSDATETIME(),ERROR_PROCEDURE(),SYSDATETIME(),ERROR_PROCEDURE());

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
				     
			; 
		END;
	END CATCH;
END


