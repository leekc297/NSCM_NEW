
/*
 * Program ID   : SCP0121_SAVE_PLAN_GROUP_POPUP
 * Description  : Plan Group 등록,수정 
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2025/04/25   mrchois			PJ2024A332R 독립적 Planning 체계 및 Master Validation UI 구축 - Initial Release
 * 2025/06/05   mrchois			PJ2024A332R 독립적 Planning 체계 및 Master Validation UI 구축 - Target 대상, Onwer 정보 추가
 *
 */
CREATE PROCEDURE [dbo].[SCP0121_SAVE_PLAN_GROUP_POPUP]

	-- Add the parameters for the stored procedure here
	@p_active_flag		NVARCHAR(MAX),
	@p_division_id		NVARCHAR(MAX),
	@p_plan_gr_id		NVARCHAR(MAX), 
	@p_plan_gr_name		NVARCHAR(MAX), 
	@p_plan_gr_desc		NVARCHAR(MAX), 
	@p_tgt_divs_cd		NVARCHAR(MAX), 
	@p_owner			NVARCHAR(MAX), 
	@p_owner_name		NVARCHAR(MAX), 
	@p_valid_yn			NVARCHAR(MAX), 
	@p_user_id			NVARCHAR(MAX)

AS

BEGIN

	SET NOCOUNT ON;

	DECLARE @v_working_time			DATETIME =sysdatetime();
	DECLARE @recv_active_flag		NVARCHAR(MAX);
	SET @recv_active_flag = NULL;		
	SET @recv_active_flag = @p_active_flag;

	DECLARE @v_active_flag		NVARCHAR(MAX);
	DECLARE @v_plan_gr_id		NVARCHAR(MAX);
	DECLARE @v_plan_gr_name		NVARCHAR(MAX);
	DECLARE @v_plan_gr_desc		NVARCHAR(MAX);
	DECLARE @v_tgt_divs_cd		NVARCHAR(MAX);
	DECLARE @v_owner			NVARCHAR(MAX);
	DECLARE @v_owner_name		NVARCHAR(MAX);
	DECLARE @v_valid_yn			NVARCHAR(MAX);
	DECLARE @v_last_updated_by	NVARCHAR(MAX);
	DECLARE @v_plan_gr_cnt		INT;
	
	SET @v_active_flag		= NULL;
	SET @v_plan_gr_id		= NULL;		
	SET @v_plan_gr_name		= NULL;
	SET @v_plan_gr_desc		= NULL;
	SET @v_tgt_divs_cd		= NULL;
	SET @v_owner			= NULL;
	SET @v_owner_name		= NULL;
	SET @v_valid_yn			= NULL;
	SET @v_last_updated_by	= NULL;
	SET @v_plan_gr_cnt	= 0;

	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^' 

	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;
		
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0121_SAVE_PLAN_GROUP_POPUP';
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

	-- 트렌젝션 시작
	BEGIN TRAN;

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
				SET @v_plan_gr_id = [dbo].[SCM_ARR_SPL_VAL](@p_plan_gr_id, @v_delimiter , @mst_loop_cnt) ;	
				SET @v_plan_gr_name = [dbo].[SCM_ARR_SPL_VAL](@p_plan_gr_name, @v_delimiter , @mst_loop_cnt) ;  
				SET @v_plan_gr_desc = [dbo].[SCM_ARR_SPL_VAL](@p_plan_gr_desc, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_tgt_divs_cd = [dbo].[SCM_ARR_SPL_VAL](@p_tgt_divs_cd, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_owner = [dbo].[SCM_ARR_SPL_VAL](@p_owner, @v_delimiter , @mst_loop_cnt) ;
				SET @v_owner_name = [dbo].[SCM_ARR_SPL_VAL](@p_owner_name, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_valid_yn = [dbo].[SCM_ARR_SPL_VAL](@p_valid_yn, @v_delimiter , @mst_loop_cnt) ; 

			END

			IF(@v_active_flag = 'I')
			BEGIN

				SELECT  @v_plan_gr_cnt = count(OPMZ_PLAN_GR_ID) FROM SCP_OPMZ_PLAN_GR_M

				IF(@v_plan_gr_cnt > 0)
				BEGIN
					
					--Plan Group Id 채번
					SELECT @v_plan_gr_id = 'PG' + RIGHT('0000' + CAST(CAST(MAX(SUBSTRING(OPMZ_PLAN_GR_ID, 3,4)) AS INT) + 1 AS VARCHAR), 4) FROM SCP_OPMZ_PLAN_GR_M

				END
				ELSE
				BEGIN
					--Plan Group Id 채번
					SET @v_plan_gr_id = 'PG0001'
				END

			END 

			--HISTORY INSERT
			EXEC SCP0121_SCP_OPMZ_PLAN_GR_M_HIST @v_plan_gr_id, @v_plan_gr_name, @v_plan_gr_desc, @v_tgt_divs_cd, @v_owner, @v_owner_name, @p_division_id, @v_valid_yn, @v_last_updated_by, @d_event_date, @v_last_updated_by ;

			IF(@v_active_flag = 'I')
			BEGIN
				
				INSERT INTO SCP_OPMZ_PLAN_GR_M
				(
					OPMZ_PLAN_GR_ID
					, OPMZ_PLAN_GR_NAME
					, OPMZ_PLAN_GR_DESC
					, OPMZ_TGT_DIVS_CD
					, DIVISION_ID
					, OWNR_LST_CTN
					, VALID_YN
					, ATTRIBUTE1	--owner name
					, CREATED_BY
					, CREATION_DATE
					, LAST_UPDATED_BY
					, LAST_UPDATE_DATE
				)
				VALUES
				(
					@v_plan_gr_id
					, @v_plan_gr_name
					, @v_plan_gr_desc
					, @v_tgt_divs_cd
					, @p_division_id
					, @v_owner
					, @v_valid_yn
					, @v_owner_name
					, @v_last_updated_by
					, SYSDATETIME()
					, @v_last_updated_by
					, SYSDATETIME()
				);

			END
			ELSE IF( @v_active_flag ='M' )
			BEGIN

				UPDATE SCP_OPMZ_PLAN_GR_M
				SET OPMZ_PLAN_GR_NAME		= @v_plan_gr_name
					, OPMZ_PLAN_GR_DESC		= @v_plan_gr_desc	
					, OPMZ_TGT_DIVS_CD		= @v_tgt_divs_cd	
					, OWNR_LST_CTN			= @v_owner	
					, VALID_YN				= @v_valid_yn	
					, ATTRIBUTE1			= @v_owner_name		--owner name
					, LAST_UPDATED_BY		= @v_last_updated_by 
					, LAST_UPDATE_DATE		= SYSDATETIME()
				WHERE OPMZ_PLAN_GR_ID		= @v_plan_gr_id
				;

			END

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






