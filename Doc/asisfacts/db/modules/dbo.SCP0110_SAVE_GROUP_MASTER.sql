
/*
 * Program ID   : SCP0110_SAVE_GROUP_MASTER
 * Description  : GROUP 등록,수정
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2024/05/24   mrchois    PJ20244573 LGES SCM SCP 생산모델 기반 공급계획 수립체계 구성
 * 2025-08-14   twinlove   PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - Only Stock(Y/N) 추가 attribute1에 저장
 
 */

 CREATE PROCEDURE [dbo].[SCP0110_SAVE_GROUP_MASTER]
 
	-- Add the parameters for the stored procedure here
	@p_active_flag			NVARCHAR(MAX)
	,@p_division_id			NVARCHAR(MAX)
	,@p_operation_group		NVARCHAR(MAX)
	,@p_group_id			NVARCHAR(MAX)
	,@p_group_name			NVARCHAR(MAX)
	,@p_valid_yn			NVARCHAR(MAX)
	,@p_user_id				NVARCHAR(MAX)
	,@p_only_stock			NVARCHAR(MAX)   -- PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산

AS
BEGIN

	SET NOCOUNT ON; 

	DECLARE @v_working_time			DATETIME =sysdatetime();
	DECLARE @recv_active_flag		NVARCHAR(MAX);
	SET @recv_active_flag = NULL;		
	SET @recv_active_flag = @p_active_flag;

	DECLARE @v_active_flag			NVARCHAR(MAX);
	DECLARE @v_division_id			NVARCHAR(MAX);
	DECLARE @v_operation_group		NVARCHAR(MAX);
	DECLARE @v_group_id				NVARCHAR(MAX);
	DECLARE @v_group_name			NVARCHAR(MAX);
	DECLARE @v_valid_yn				NVARCHAR(MAX);
	DECLARE @v_created_by			NVARCHAR(MAX);
	DECLARE @v_last_updated_by		NVARCHAR(MAX);
	DECLARE @v_only_stock			NVARCHAR(MAX);   -- PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산

	SET @v_active_flag		= NULL;
	SET @v_division_id		= NULL;
	SET @v_operation_group	= NULL;
	SET @v_group_id			= NULL;
	SET @v_group_name		= NULL;
	SET @v_valid_yn			= NULL;
	SET @v_created_by		= NULL;
	SET @v_last_updated_by	= NULL;
	SET @v_only_stock		= NULL;  -- PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산

	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^' 

	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0110_SAVE_GROUP_MASTER';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	DECLARE @v_data_dup_cnt  INT=0;

	-- 예외처리 변수 설정
	DECLARE @v_err_code  INTEGER;
	DECLARE @v_err_message  NVARCHAR(4000)='';

	SET @v_created_by       = @p_user_id;
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
					SET @v_operation_group = [dbo].[SCM_ARR_SPL_VAL](@p_operation_group, @v_delimiter , @mst_loop_cnt) ;     
					SET @v_group_id = [dbo].[SCM_ARR_SPL_VAL](@p_group_id, @v_delimiter , @mst_loop_cnt) ;    
					SET @v_group_name = [dbo].[SCM_ARR_SPL_VAL](@p_group_name, @v_delimiter , @mst_loop_cnt) ;
					SET @v_valid_yn = [dbo].[SCM_ARR_SPL_VAL](@p_valid_yn, @v_delimiter , @mst_loop_cnt) ;
					SET @v_only_stock = [dbo].[SCM_ARR_SPL_VAL](@p_only_stock, @v_delimiter , @mst_loop_cnt) ;  -- PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산

				END

				IF(@v_active_flag !='D')
				BEGIN

					-- GROUP NAME 중복체크
					SELECT @v_data_dup_cnt = COUNT(*) 			
					  FROM SCP_MST_ITEM_GROUP WITH(NOLOCK)
					 WHERE DIVISION_ID   = @v_division_id
					   AND GROUP_NAME = @v_group_name
					   AND NOT (DIVISION_ID = @v_division_id   -- PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산
					        AND GROUP_ID = @v_group_id)        -- PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산
					 ;

					IF(@v_data_dup_cnt>0) 
					BEGIN
						SET @v_err_code    = 99010 ; 
						SET @v_err_message = N'이미 존재하는 Group Name 입니다.';
						THROW  @v_err_code, @v_err_message , 1; --예외발생
					END;

				END;
				

				--데이터 저장
				IF @mst_loop_cnt > 0
				BEGIN

					-- GROUP_NAME 수정					
					IF(@v_active_flag ='M') 
					BEGIN
						UPDATE SCP_MST_ITEM_GROUP
						   SET GROUP_NAME		= @v_group_name     
							  ,OPERATION_GROUP  = @v_operation_group 
							  ,ATTRIBUTE1       = @v_only_stock          -- PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산
							  ,LAST_UPDATED_BY  = @v_last_updated_by 
							  ,LAST_UPDATE_DATE = SYSDATETIME()
						WHERE DIVISION_ID		= @v_division_id     
						  AND GROUP_ID			= @v_group_id 
						;
					END
					ELSE IF( @v_active_flag ='I' )
					BEGIN

						-- GROUP_ID 채번값 구하기
						DECLARE @MAX_NUM VARCHAR(5)
						-- 내부번호를 위한 카운트 설정-- 키값에 'G'에 0으로 4자리 채우고 1씩 증가시킴?
						SELECT @MAX_NUM = CAST(CAST(MAX(SUBSTRING(GROUP_ID,2,5)) AS INT) +1 AS VARCHAR) FROM SCP_MST_ITEM_GROUP WITH(NOLOCK)
						SELECT @v_group_id = 'G'+ REPLICATE('0',5-LEN(@MAX_NUM)) + @MAX_NUM

						INSERT INTO SCP_MST_ITEM_GROUP
						(
							DIVISION_ID
							,OPERATION_GROUP
							,GROUP_ID
							,GROUP_NAME
							,VALID_YN
							,ATTRIBUTE1      -- PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산
							,created_by
							,creation_date
						)
						VALUES
						(
							@v_division_id
							,@v_operation_group
							,@v_group_id
							,@v_group_name
							,@v_valid_yn
							,@v_only_stock    -- PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산
							,@v_created_by
							,SYSDATETIME()
						);
					
					END
					ELSE IF( @v_active_flag ='D' )
					BEGIN

						--Group 삭제 시 Group - model Mapping 정보 삭제
						UPDATE SCP_MST_ITEM_GROUP_DETAIL
						   SET GROUP_ID			= NULL   
							  ,LAST_UPDATED_BY  = @v_last_updated_by 
							  ,LAST_UPDATE_DATE = SYSDATETIME()
						 WHERE DIVISION_ID		= @v_division_id     
						   AND GROUP_ID			= @v_group_id 
						;

						DELETE FROM SCP_MST_ITEM_GROUP 
					     WHERE DIVISION_ID		= @v_division_id
						   AND GROUP_ID			= @v_group_id
						;

					END;

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