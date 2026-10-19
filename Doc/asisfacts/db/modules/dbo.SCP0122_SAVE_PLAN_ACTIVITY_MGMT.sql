
/*
 * Program ID   : SCP0122_SAVE_PLAN_ACTIVITY_MGMT
 * Description  : Plan Activity 등록,수정 
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2025/04/29   mrchois			PJ2024A332R 독립적 Planning 체계 및 Master Validation UI 구축 - Initial Release
 * 2025/06/18   mrchois			PJ2024A332R 독립적 Planning 체계 및 Master Validation UI 구축 - 삭제 기능 추가
 *
 */
CREATE PROCEDURE [dbo].[SCP0122_SAVE_PLAN_ACTIVITY_MGMT]

	-- Add the parameters for the stored procedure here
	@p_active_flag		NVARCHAR(MAX),
	@p_prs_cd			NVARCHAR(MAX), 
	@p_plan_gr_id		NVARCHAR(MAX), 
	@p_actv_cd			NVARCHAR(MAX), 
	@p_actv_seq			NVARCHAR(MAX),  
	@p_pre_actv_cd		NVARCHAR(MAX), 
	@p_user_id			NVARCHAR(MAX)

AS

BEGIN

	SET NOCOUNT ON;

	DECLARE @v_working_time			DATETIME =sysdatetime();
	DECLARE @recv_active_flag		NVARCHAR(MAX);
	SET @recv_active_flag = NULL;		
	SET @recv_active_flag = @p_active_flag;

	DECLARE @v_active_flag		NVARCHAR(MAX);
	DECLARE @v_prs_cd			NVARCHAR(MAX);
	DECLARE @v_plan_gr_id		NVARCHAR(MAX);
	DECLARE @v_actv_cd			NVARCHAR(MAX);
	DECLARE @v_actv_seq			NVARCHAR(MAX);
	DECLARE @v_pre_actv_cd		NVARCHAR(MAX);

	DECLARE @v_last_updated_by	NVARCHAR(MAX);
	
	SET @v_active_flag		= NULL;	
	SET @v_prs_cd			= NULL;
	SET @v_plan_gr_id		= NULL;	
	SET @v_actv_cd			= NULL;
	SET @v_actv_seq			= NULL;
	SET @v_pre_actv_cd		= NULL;
	SET @v_last_updated_by	= NULL;

	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^' 

	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;
		
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0122_SAVE_PLAN_ACTIVITY_MGMT';
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
				SET @v_prs_cd = [dbo].[SCM_ARR_SPL_VAL](@p_prs_cd, @v_delimiter , @mst_loop_cnt) ;   
				SET @v_plan_gr_id = [dbo].[SCM_ARR_SPL_VAL](@p_plan_gr_id, @v_delimiter , @mst_loop_cnt) ;	
				SET @v_actv_cd = [dbo].[SCM_ARR_SPL_VAL](@p_actv_cd, @v_delimiter , @mst_loop_cnt) ;
				SET @v_actv_seq = [dbo].[SCM_ARR_SPL_VAL](@p_actv_seq, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_pre_actv_cd = [dbo].[SCM_ARR_SPL_VAL](@p_pre_actv_cd, @v_delimiter , @mst_loop_cnt) ; 

			END

			--HISTORY INSERT
			EXEC SCP0122_SCP_OPMZ_PLAN_GR_ACTV_HIST @v_prs_cd, @v_plan_gr_id, @v_actv_cd, @v_actv_seq, 'Y', @v_last_updated_by, @d_event_date, @v_last_updated_by ;

			IF(@v_active_flag = 'I')
			BEGIN

				INSERT INTO SCP_OPMZ_PLAN_GR_ACTV_M
				(
					OPMZ_PRS_CD
					, OPMZ_PLAN_GR_ID
					, OPMZ_ACTV_CD
					, OPMZ_ACTV_SEQ
					, VALID_YN
					, CREATED_BY
					, CREATION_DATE
					, LAST_UPDATED_BY
					, LAST_UPDATE_DATE
				)
				VALUES
				(
					@v_prs_cd
					, @v_plan_gr_id
					, @v_actv_cd
					, @v_actv_seq
					, 'Y'
					, @v_last_updated_by
					, SYSDATETIME()
					, @v_last_updated_by
					, SYSDATETIME()
				);

			END
			ELSE IF( @v_active_flag ='M' )
			BEGIN

				UPDATE SCP_OPMZ_PLAN_GR_ACTV_M
				SET OPMZ_ACTV_CD		= @v_actv_cd
					, OPMZ_ACTV_SEQ		= CAST(@v_actv_seq AS INT)
					, LAST_UPDATED_BY	= @v_last_updated_by 
					, LAST_UPDATE_DATE	= SYSDATETIME()
				WHERE OPMZ_PRS_CD		= @v_prs_cd
				AND OPMZ_PLAN_GR_ID		= @v_plan_gr_id
				AND OPMZ_ACTV_CD		= @v_pre_actv_cd
				;

			END
			ELSE IF( @v_active_flag ='D' )
			BEGIN

				DELETE SCP_OPMZ_PLAN_GR_ACTV_M
				WHERE OPMZ_PRS_CD		= @v_prs_cd
				AND OPMZ_PLAN_GR_ID		= @v_plan_gr_id
				AND OPMZ_ACTV_CD		= @v_pre_actv_cd
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






