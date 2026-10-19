
/*
 * Program ID   : [SCP0110_SAVE_MODEL_LIST]
 * Description  : Model List의 GROUP 지정(수정)
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2024/05/24   mrchois    PJ20244573 LGES SCM SCP 생산모델 기반 공급계획 수립체계 구성
 
 */

 CREATE PROCEDURE [dbo].[SCP0110_SAVE_MODEL_LIST]
 
	-- Add the parameters for the stored procedure here
	@p_active_flag			NVARCHAR(MAX)
	,@p_division_id			NVARCHAR(MAX)
	,@p_project_code		NVARCHAR(MAX)
	,@p_item_id				NVARCHAR(MAX)
	,@p_group_id			NVARCHAR(MAX)
	,@p_user_id            NVARCHAR(MAX)

AS
BEGIN

	SET NOCOUNT ON; 

	DECLARE @v_working_time			DATETIME =sysdatetime();
	DECLARE @recv_active_flag		NVARCHAR(MAX);
	SET @recv_active_flag = NULL;		
	SET @recv_active_flag = @p_active_flag;

	DECLARE @v_active_flag			NVARCHAR(MAX);
	DECLARE @v_division_id			NVARCHAR(MAX);
	DECLARE @v_project_code			NVARCHAR(MAX);
	DECLARE @v_item_id				NVARCHAR(MAX);
	DECLARE @v_group_id				NVARCHAR(MAX);
	DECLARE @v_last_updated_by		NVARCHAR(MAX);

	SET @v_active_flag		= NULL;
	SET @v_division_id		= NULL;
	SET @v_project_code		= NULL;
	SET @v_item_id			= NULL;
	SET @v_group_id			= NULL;
	SET @v_last_updated_by	= NULL;

	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^' 

	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0110_SAVE_MODEL_LIST';
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
					SET @v_project_code = [dbo].[SCM_ARR_SPL_VAL](@p_project_code, @v_delimiter , @mst_loop_cnt) ;
					SET @v_item_id = [dbo].[SCM_ARR_SPL_VAL](@p_item_id, @v_delimiter , @mst_loop_cnt) ;     
					SET @v_group_id = [dbo].[SCM_ARR_SPL_VAL](@p_group_id, @v_delimiter , @mst_loop_cnt) ;   

				END

				-- GROUP 중복체크(Project 가 다른 아이템을 서로 한 개 Group으로 지정 불가)
				SELECT @v_data_dup_cnt = COUNT(*) 			
				  FROM SCP_MST_ITEM_GROUP_DETAIL WITH(NOLOCK)
				 WHERE DIVISION_ID	= @v_division_id
				   AND PROJECT_CODE	!= @v_project_code
				   AND GROUP_ID		= @v_group_id
				 ;

				IF(@v_data_dup_cnt>0) 
				BEGIN
					SET @v_err_code    = 99010 ; 
					SET @v_err_message = N'복수의 Project를 같은 그룹으로 지정 할 수 없습니다. ';
					THROW  @v_err_code, @v_err_message , 1; --예외발생
				END;

				--데이터 저장
				IF @mst_loop_cnt > 0
				BEGIN

					--공백일 경우 NULL로 변경 -> 정렬때문에
					IF(@v_group_id = '')
						SET @v_group_id =NULL

					-- GROUP_ID 수정					
					IF(@v_active_flag ='M') 
					BEGIN
						UPDATE SCP_MST_ITEM_GROUP_DETAIL
						   SET GROUP_ID			= @v_group_id     
							  ,LAST_UPDATED_BY  = @v_last_updated_by 
							  ,LAST_UPDATE_DATE = SYSDATETIME()
						WHERE DIVISION_ID		= @v_division_id     
						  AND PROJECT_CODE		= @v_project_code    
						  AND ITEM_ID			= @v_item_id 
						;
					END

				END;-- END OF STMT. IF(@mst_loop_cnt > 0)

			END;-- END OF STMT. WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt
			
			SET @v_log_type = 'END';
			SET @v_log_message = '########## END of procedure ##########';
			SET @v_description = '';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			
			-- 결과코드, 결과 카운트 반환
			SELECT  'S' AS result_code,  @max_loop_cnt AS result_cnt ;

		END TRY

		BEGIN CATCH
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

			IF @@TRANCOUNT > 0
			  COMMIT WORK;
		  END;

		  -- error코드, errror 메시지 반환
		  SELECT 'F' AS result_code;
		  SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
		END CATCH;
END