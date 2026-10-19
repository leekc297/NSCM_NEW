
/*
 * Program ID   : SCP0123_SAVE_PLAN_CTRL_ACTV_RUN
 * Description  : Activity 실행 등록
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2025/05/12   mrchois			PJ2024A332R 독립적 Planning 체계 및 Master Validation UI 구축 - Initial Release
 * 2025/06/11   mrchois			PJ2024A332R 독립적 Planning 체계 및 Master Validation UI 구축 - Plan Out Review and Amend 분리 실행 추가
 * 2025/06/25   mrchois			PJ2024A332R 독립적 Planning 체계 및 Master Validation UI 구축 - A009  Ship Plan Semi Cut-Off (To Packer) 여러번 Cut-off 가능하도록 변경
 * 2025/08/18   mrchois			PJ20257329  최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - Plan Out Review and Amend 분리 실행 (EE) 추가
 * 2025/09/01   mrchois			PJ20257329  최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - 일단위 Plan date 운영(81_UC, EE_UC), A009-Ship Plan Semi Cut-Off (To Packer) 호출 시 Plan Group 넘기도록
 * 2025/09/19   mrchois			PJ20257329  최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - A004, A005 여러번 I/F 가능하도록 변경
 *
 */
CREATE PROCEDURE [dbo].[SCP0123_SAVE_PLAN_CTRL_ACTV_RUN]

	-- Add the parameters for the stored procedure here
	@p_division_id				NVARCHAR(50),
	@p_plan_start_yyyymmdd		NVARCHAR(8), 
	@p_prs_cd					NVARCHAR(30), 
	@p_plan_gr_id				NVARCHAR(30), 
	@p_actv_cd					NVARCHAR(30), 
	@p_plan_id					NVARCHAR(50), 
	@p_user_id					NVARCHAR(200)

AS

BEGIN

	SET NOCOUNT ON;

	DECLARE @v_working_time			DATETIME =sysdatetime();

	DECLARE @v_active_flag		NVARCHAR(MAX);
	DECLARE @v_stat_cd			NVARCHAR(50);
	
	SET @v_active_flag		= NULL;
		
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0123_SAVE_PLAN_CTRL_ACTV_RUN';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	DECLARE @v_data_dup_cnt  INT=0;


	-- 예외처리 변수 설정
	DECLARE @v_err_code  INTEGER;
	DECLARE @v_err_message  NVARCHAR(4000)='';

	-- 시작 LOG
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


	-- 트렌젝션 시작
	BEGIN TRAN;

	BEGIN TRY
		
		--Plan Out Review and Amend 실행시
		IF(@p_actv_cd = 'A004')
		BEGIN
			
			IF(CHARINDEX('81', @p_division_id) > 0)	--자동차
			BEGIN

				----------------------------------------------------------------------------------------------------------
				print  convert(varchar(30), getdate(), 121) + N'Plan Out Review and Amend 실행 - PR_SCP_OPT_ENG_OUTPUT_TRANS_ANL  ' + @p_plan_id + ', ' + @p_plan_start_yyyymmdd
				----------------------------------------------------------------------------------------------------------
				EXEC PR_SCP_OPT_ENG_OUTPUT_TRANS_ANL @p_plan_id , @p_plan_start_yyyymmdd;

			END
			ELSE IF(@p_division_id = '40')	-- 소형
			BEGIN

				----------------------------------------------------------------------------------------------------------
				print  convert(varchar(30), getdate(), 121) + N'Plan Out Review and Amend 실행 - PR_SCP_OPT_ENG_OUTPUT_TRANS_ANL_SMALL  ' + @p_plan_id + ', ' + @p_plan_start_yyyymmdd
				----------------------------------------------------------------------------------------------------------
				EXEC PR_SCP_OPT_ENG_OUTPUT_TRANS_ANL_SMALL @p_plan_id , @p_plan_start_yyyymmdd;
			END
			--[PJ20257329] Plan Out Review and Amend 분리 실행 (EE) 추가(2025-08-18) START
			ELSE IF(@p_division_id = 'EE')	-- EE
			BEGIN

				----------------------------------------------------------------------------------------------------------
				print  convert(varchar(30), getdate(), 121) + N'Plan Out Review and Amend 실행 - PR_SCP_OPT_ENG_OUTPUT_TRANS_ANL_EE  ' + @p_plan_id + ', ' + @p_plan_start_yyyymmdd
				----------------------------------------------------------------------------------------------------------
				EXEC PR_SCP_OPT_ENG_OUTPUT_TRANS_ANL_EE @p_plan_id , @p_plan_start_yyyymmdd;
			END
			--[PJ20257329] Plan Out Review and Amend 분리 실행 (EE) 추가(2025-08-18) END
			--[PJ20257329] 일단위 Plan date 운영(81_UC, EE_UC)(2025-09-01) START
			ELSE IF(@p_division_id = '82')	-- ESS
			BEGIN

				----------------------------------------------------------------------------------------------------------
				print  convert(varchar(30), getdate(), 121) + N'Plan Out Review and Amend 실행 - PR_SCP_OPT_ENG_OUTPUT_TRANS_ANL_ESS  ' + @p_plan_id + ', ' + @p_plan_start_yyyymmdd
				----------------------------------------------------------------------------------------------------------
				EXEC PR_SCP_OPT_ENG_OUTPUT_TRANS_ANL_ESS @p_plan_id , @p_plan_start_yyyymmdd;
			END
			ELSE IF(@p_division_id = '81_UC')	-- 81_UC
			BEGIN

				----------------------------------------------------------------------------------------------------------
				print  convert(varchar(30), getdate(), 121) + N'Plan Out Review and Amend 실행 - PR_SCP_OPT_ENG_OUTPUT_TRANS_ANL_GM_A  ' + @p_plan_id + ', ' + @p_plan_start_yyyymmdd
				----------------------------------------------------------------------------------------------------------
				EXEC PR_SCP_OPT_ENG_OUTPUT_TRANS_ANL_GM_A @p_plan_id , @p_plan_start_yyyymmdd;
			END
			ELSE IF(@p_division_id = 'EE_UC')	-- EE_UC
			BEGIN

				----------------------------------------------------------------------------------------------------------
				print  convert(varchar(30), getdate(), 121) + N'Plan Out Review and Amend 실행 - PR_SCP_OPT_ENG_OUTPUT_TRANS_ANL_GM_EE  ' + @p_plan_id + ', ' + @p_plan_start_yyyymmdd
				----------------------------------------------------------------------------------------------------------
				EXEC PR_SCP_OPT_ENG_OUTPUT_TRANS_ANL_GM_EE @p_plan_id , @p_plan_start_yyyymmdd;
			END
			--[PJ20257329] 일단위 Plan date 운영(81_UC, EE_UC)(2025-09-01) END

		END

		--FP Target I/F 실행시
		IF(@p_actv_cd = 'A005')
		BEGIN
			
			----------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N'FP Target I/F 실행 - PR_SCP_OPT_ENG_OUTPUT_FP_PROD_TARGET ' + @p_plan_id + ', ' + @p_plan_start_yyyymmdd
			----------------------------------------------------------------------------------------------------------
			EXEC PR_SCP_OPT_ENG_OUTPUT_FP_PROD_TARGET @p_plan_id , @p_plan_start_yyyymmdd;

		END

		--소형 Shipment SEMI Snapshot 실행시
		IF(@p_actv_cd = 'A009')
		BEGIN
			
			----------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N'소형 Shipment SEMI Snapshot 실행 - PR_SCP_OPT_ENG_INPUT_SHIPMENT_SNAPSHOT ' + @p_plan_id + ', ' + @p_division_id + ', ' + @p_plan_start_yyyymmdd + ', ' + @p_plan_gr_id
			----------------------------------------------------------------------------------------------------------
			EXEC PR_SCP_OPT_ENG_INPUT_SHIPMENT_SNAPSHOT @p_plan_id, @p_division_id, @p_plan_start_yyyymmdd, @p_plan_gr_id;	--[PJ20257329] A009-Ship Plan Semi Cut-Off (To Packer) 호출 시 Plan Group 넘기도록(2025-09-03)


			--소형 Shipment SEMI Snapshot 재실행인 경우, LAST_UPDATE_DATE만 업데이트 START (2025-06-25)
			DECLARE @CNT INT;
			SET @CNT = 0;

			SELECT @CNT = COUNT(*)
			FROM SCP_OPMZ_PLAN_CTRL_ACTV_RUN_M WITH(NOLOCK)
			WHERE 1=1
			AND PLAN_START_YYYYMMDD	= @p_plan_start_yyyymmdd
			AND OPMZ_PRS_CD				= @p_prs_cd
			AND OPMZ_PLAN_GR_ID			= @p_plan_gr_id
			AND OPMZ_ACTV_CD			= @p_actv_cd

			IF (@CNT > 0)
			BEGIN

				UPDATE SCP_OPMZ_PLAN_CTRL_ACTV_RUN_M
				SET LAST_UPDATE_DATE		= SYSDATETIME()
				  , LAST_UPDATED_BY			= @p_user_id
				WHERE PLAN_START_YYYYMMDD	= @p_plan_start_yyyymmdd
				AND OPMZ_PRS_CD				= @p_prs_cd
				AND OPMZ_PLAN_GR_ID			= @p_plan_gr_id
				AND OPMZ_ACTV_CD			= @p_actv_cd


				SET @v_log_type = 'END';
				SET @v_log_message = '########## END of procedure ##########';
				SET @v_description = '';
				SET @d_event_date = SYSDATETIME();
				EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			
				COMMIT TRAN;
			
				-- 결과코드, 결과 카운트 반환
				SELECT  'S' AS result_code,  '1' AS result_cnt ;

				RETURN;

			END
			--소형 Shipment SEMI Snapshot 재실행인 경우, LAST_UPDATE_DATE만 업데이트 END (2025-06-25)

		END

		--[PJ20257329] A004, A005 여러번 I/F 가능하도록 변경 (2025-09-19) START
		IF (@p_actv_cd = 'A004' OR @p_actv_cd = 'A005')
		BEGIN
			
			DECLARE @CNT45 INT;
			SET @CNT45 = 0;

			SELECT @CNT45 = COUNT(*)
			FROM SCP_OPMZ_PLAN_CTRL_ACTV_RUN_M WITH(NOLOCK)
			WHERE 1=1
			AND DIVISION_ID				= @p_division_id
			AND PLAN_START_YYYYMMDD		= @p_plan_start_yyyymmdd
			AND OPMZ_PRS_CD				= @p_prs_cd
			AND OPMZ_PLAN_GR_ID			= @p_plan_gr_id
			AND OPMZ_ACTV_CD			= @p_actv_cd
			AND OPMZ_PLAN_ID			= @p_plan_id

			IF (@CNT45 > 0)
			BEGIN

				UPDATE SCP_OPMZ_PLAN_CTRL_ACTV_RUN_M
				SET LAST_UPDATE_DATE		= SYSDATETIME()
				  , LAST_UPDATED_BY			= @p_user_id
				WHERE 1=1
				AND DIVISION_ID				= @p_division_id
				AND PLAN_START_YYYYMMDD		= @p_plan_start_yyyymmdd
				AND OPMZ_PRS_CD				= @p_prs_cd
				AND OPMZ_PLAN_GR_ID			= @p_plan_gr_id
				AND OPMZ_ACTV_CD			= @p_actv_cd
				AND OPMZ_PLAN_ID			= @p_plan_id


				SET @v_log_type = 'END';
				SET @v_log_message = '########## END of procedure ##########';
				SET @v_description = '';
				SET @d_event_date = SYSDATETIME();
				EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			
				COMMIT TRAN;
			
				-- 결과코드, 결과 카운트 반환
				SELECT  'S' AS result_code,  '1' AS result_cnt ;

				RETURN;

			END

		END 
		--[PJ20257329] A0005 여러번 I/F 가능하도록 변경 (2025-09-19) END

		--Engine Run 인 경우는 'W'를 등록
		IF(@p_actv_cd = 'A003')
		BEGIN
			SET @v_stat_cd = 'W'
		END
		ELSE
		BEGIN
			SET @v_stat_cd = 'C'
		END

		
		INSERT INTO SCP_OPMZ_PLAN_CTRL_ACTV_RUN_M
		(
			PLAN_START_YYYYMMDD
			, OPMZ_PRS_CD
			, OPMZ_PLAN_GR_ID
			, OPMZ_ACTV_CD
			, OPMZ_PLAN_ID
			, OPMZ_ACTV_RUN_STAT_CD
			, DIVISION_ID
			, CREATED_BY
			, CREATION_DATE
			, LAST_UPDATED_BY
			, LAST_UPDATE_DATE
		)
		VALUES
		(
			@p_plan_start_yyyymmdd
			, @p_prs_cd
			, @p_plan_gr_id
			, @p_actv_cd
			, @p_plan_id
			, @v_stat_cd
			, @p_division_id
			, @p_user_id
			, SYSDATETIME()
			, @p_user_id
			, SYSDATETIME()
		);


		IF(@p_plan_id <> '-')
		BEGIN

			--최종실행한 Activity의 Plan id를 변경
			UPDATE SCP_OPMZ_PLAN_CTRL_ACTV_M
			SET LTST_RUN_OPMZ_PLAN_ID	= @p_plan_id
			  , LAST_UPDATE_DATE		= SYSDATETIME()
			WHERE PLAN_START_YYYYMMDD	= @p_plan_start_yyyymmdd
			AND OPMZ_PRS_CD				= @p_prs_cd
			AND OPMZ_PLAN_GR_ID			= @p_plan_gr_id
			AND OPMZ_ACTV_CD			= @p_actv_cd

		END


		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			
		COMMIT TRAN;
			
		-- 결과코드, 결과 카운트 반환
		SELECT  'S' AS result_code,  '1' AS result_cnt ;

	END TRY
	BEGIN CATCH

        IF ERROR_MESSAGE() NOT IN (
            'I/F not executed because PLAN_TYPE is FN.',
            ' Order Production data to interface.'
        )
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
        END


		IF @@TRANCOUNT > 0
			COMMIT WORK;

		-- error코드, errror 메시지 반환
		SELECT 'F' AS result_code;
		SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
	END CATCH;
END






