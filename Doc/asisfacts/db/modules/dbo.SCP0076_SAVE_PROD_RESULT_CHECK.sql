


/*
 * Program ID   : SCP0076_SAVE_PROD_RESULT_CHECK
 * Description  : 출하실적 점검 Report
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2021.12.01   KDW			[PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.3) - 최초작성
 */
CREATE PROCEDURE [dbo].[SCP0076_SAVE_PROD_RESULT_CHECK]
	  @p_active_flag			NVARCHAR(4000)
	, @p_plan_start_yyyymmdd	NVARCHAR(4000)
	, @p_plan_week				NVARCHAR(4000)
	, @p_operation_group		NVARCHAR(4000)
	, @p_division_id			NVARCHAR(4000)
	, @p_cell_type_gr			NVARCHAR(4000)
	, @p_plant_id				NVARCHAR(4000)
	, @p_model_type_gr			NVARCHAR(4000)
	, @p_reason_code			NVARCHAR(4000)
	, @p_reason_description		NVARCHAR(MAX)
	, @p_created_by				NVARCHAR(4000)
AS

BEGIN

	SET NOCOUNT ON;

	DECLARE @recv_active_flag		NVARCHAR(MAX);
	SET @recv_active_flag = NULL;		
	SET @recv_active_flag = @p_active_flag;

	DECLARE @v_active_flag			NVARCHAR(001)
	DECLARE @v_plan_start_yyyymmdd	NVARCHAR(008)
	DECLARE @v_plan_week			NVARCHAR(010)
	DECLARE @v_operation_group		NVARCHAR(020)
	DECLARE @v_division_id			NVARCHAR(010)
	DECLARE @v_cell_type_gr			NVARCHAR(010)
	DECLARE @v_plant_id				NVARCHAR(010)
	DECLARE @v_model_type_gr		NVARCHAR(030)
	DECLARE @v_to_scm_site_id		NVARCHAR(030)
	DECLARE @v_reason_code			NVARCHAR(030)
	DECLARE @v_reason_description	NVARCHAR(4000)
	DECLARE @v_created_by			NVARCHAR(100)

	SET @v_active_flag			= NULL;
	SET @v_plan_start_yyyymmdd	= NULL;
	SET @v_plan_week			= NULL;
	SET @v_operation_group		= NULL;
	SET @v_division_id			= NULL;
	SET @v_cell_type_gr			= NULL;
	SET @v_plant_id				= NULL;
	SET @v_model_type_gr		= NULL;
	SET @v_to_scm_site_id		= NULL;
	SET @v_reason_code			= NULL;
	SET @v_reason_description	= NULL;
	SET @v_created_by			= NULL;

	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^' 
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0076_SAVE_PROD_RESULT_CHECK';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	-- 트렌젝션 시작
	BEGIN TRAN;

	BEGIN TRY

			-- 시작 LOG
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		--PRINT '2';
		-- 프로시저 LOOP 길이를 판단
		SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_active_flag, @v_delimiter);    

		WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt
		BEGIN    

			-- @mst_loop_cnt 1증가
			SET @mst_loop_cnt = @mst_loop_cnt + 1;			

			-- 각 컬럼들에 대한 스플릿처리로직 스타트
			BEGIN
				SET @v_active_flag			= [dbo].[SCM_ARR_SPL_VAL](@p_active_flag			, @v_delimiter , @mst_loop_cnt) ;
				SET @v_plan_start_yyyymmdd	= [dbo].[SCM_ARR_SPL_VAL](@p_plan_start_yyyymmdd	, @v_delimiter , @mst_loop_cnt) ;
				SET @v_plan_week			= [dbo].[SCM_ARR_SPL_VAL](@p_plan_week				, @v_delimiter , @mst_loop_cnt) ;
				SET @v_operation_group		= [dbo].[SCM_ARR_SPL_VAL](@p_operation_group		, @v_delimiter , @mst_loop_cnt) ;
				SET @v_division_id			= [dbo].[SCM_ARR_SPL_VAL](@p_division_id			, @v_delimiter , @mst_loop_cnt) ;
				SET @v_cell_type_gr			= [dbo].[SCM_ARR_SPL_VAL](@p_cell_type_gr			, @v_delimiter , @mst_loop_cnt) ;
				SET @v_plant_id				= [dbo].[SCM_ARR_SPL_VAL](@p_plant_id				, @v_delimiter , @mst_loop_cnt) ;
				SET @v_model_type_gr		= [dbo].[SCM_ARR_SPL_VAL](@p_model_type_gr			, @v_delimiter , @mst_loop_cnt) ;
				SET @v_reason_code			= [dbo].[SCM_ARR_SPL_VAL](@p_reason_code			, @v_delimiter , @mst_loop_cnt) ;
				SET @v_reason_description	= [dbo].[SCM_ARR_SPL_VAL](@p_reason_description		, @v_delimiter , @mst_loop_cnt) ;
				SET @v_created_by			= [dbo].[SCM_ARR_SPL_VAL](@p_created_by				, @v_delimiter , @mst_loop_cnt) ;
			END

			--데이터 저장
			IF @mst_loop_cnt > 0 			
				BEGIN		

					MERGE INTO SCP_RPT_PRODUCTION T
					 USING ( SELECT @v_plan_start_yyyymmdd	AS plan_start_yyyymmdd
								  , @v_plan_week			AS plan_week
								  , @v_division_id			AS division_id
								  , @v_cell_type_gr			AS cell_type_gr
								  , @v_operation_group		AS operation_group
								  , @v_plant_id				AS plant_id
								  , @v_model_type_gr		AS model_type_gr
								  , @v_reason_code			AS reason_code
								  , @v_reason_description	AS reason_description
								  , @v_created_by			AS created_by
							) A
					   ON T.PLAN_START_YYYYMMDD = A.PLAN_START_YYYYMMDD
					  AND T.PLAN_WEEK			= A.PLAN_WEEK
					  AND T.DIVISION_ID			= A.DIVISION_ID
					  AND T.CELL_TYPE_GR		= A.CELL_TYPE_GR
					  AND T.OPERATION_GROUP		= A.OPERATION_GROUP
					  AND T.PLANT_ID			= A.PLANT_ID
					  AND T.MODEL_TYPE_GR		= A.MODEL_TYPE_GR

					 WHEN MATCHED THEN
					 UPDATE SET
							T.REASON_CODE			= A.REASON_CODE
					      , T.REASON_DESCRIPTION	= A.REASON_DESCRIPTION
						  , T.LAST_UPDATED_BY		= A.CREATED_BY
						  , T.LAST_UPDATE_DATE		= SYSDATETIME()

					--WHEN NOT MATCHED THEN
					--INSERT 
					--(
					--)
					--VALUES
					--(
					--)
					;		
	
				END  -- END OF STMT. IF( @mst_loop_cnt > 0 )			
			
		END -- END OF STMT. WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt

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

		  if (xact_state() <> 0) ROLLBACK TRAN; --입력 데이타 롤백 처리

		  BEGIN
			INSERT INTO scm_sys_log_batch (program_name,log_type,log_count,log_message,description,event_date,creation_date,created_by,last_update_date,last_updated_by)
			VALUES (ERROR_PROCEDURE(),'ERROR',NULL,ERROR_MESSAGE(),NULL,SYSDATETIME(),SYSDATETIME(),ERROR_PROCEDURE(),SYSDATETIME(),ERROR_PROCEDURE());

			--IF @@TRANCOUNT > 0
			--  COMMIT WORK;
		  END;

		  -- error코드, errror 메시지 반환
		  SELECT 'F' AS result_code;
		  SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
		END CATCH;
	END


