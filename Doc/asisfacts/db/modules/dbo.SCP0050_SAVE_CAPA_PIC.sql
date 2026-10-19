
/*
 * Program ID   : SCP0050_SAVE_CAPA_PIC
 * Description  : MDM Auth Management
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2020/07/20   khj79          [PJ20199555] 공급 대응력 향상을 위한 자재재공 수급 점검 체계 개선 - 최초작성
 * 2021/01/26   khj79          [PJ20199555] MERGE USING 문에 ELECTRODE TYPE 추가
 * 2021/03/08   khj79          PIC 사용자(USER_4 , USER_ 5) 추가

 */
 
CREATE PROCEDURE [dbo].[SCP0050_SAVE_CAPA_PIC]
	  @p_active_flag		NVARCHAR(MAX)
	, @p_company_id			NVARCHAR(MAX)
	, @p_division_id		NVARCHAR(MAX)
	, @p_site_id			NVARCHAR(MAX)
	, @p_plant_id			NVARCHAR(MAX)
	, @p_factory_id			NVARCHAR(MAX)
	, @p_operation_id		NVARCHAR(MAX)
	, @p_line_id			NVARCHAR(MAX)
	, @p_electrode_type		NVARCHAR(MAX)
	, @p_loss_code			NVARCHAR(MAX)
	, @p_user_id_1			NVARCHAR(MAX)
	, @p_user_id_2			NVARCHAR(MAX)
	, @p_user_id_3			NVARCHAR(MAX)
	, @p_user_id_4			NVARCHAR(MAX)
	, @p_user_id_5			NVARCHAR(MAX)
	, @p_user_id_6			NVARCHAR(MAX)
	, @p_user_id_7			NVARCHAR(MAX)
	, @p_user_id_8			NVARCHAR(MAX)
	, @p_user_id_9			NVARCHAR(MAX)
	, @p_user_id_10			NVARCHAR(MAX)
	, @p_update_id			NVARCHAR(MAX)

AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @recv_active_flag		NVARCHAR(MAX);
	SET @recv_active_flag = NULL;
	SET @recv_active_flag = @p_active_flag;

	
	DECLARE @v_active_flag		NVARCHAR(10) = NULL;
	DECLARE @v_company_id		NVARCHAR(30) = NULL;
	DECLARE @v_division_id		NVARCHAR(30) = NULL;
	DECLARE @v_site_id			NVARCHAR(30) = NULL;
	DECLARE @v_plant_id			NVARCHAR(30) = NULL;
	DECLARE @v_factory_id		NVARCHAR(30) = NULL;
	DECLARE @v_operation_id		NVARCHAR(30) = NULL;
	DECLARE @v_line_id			NVARCHAR(30) = NULL;
	DECLARE @v_electrode_type	NVARCHAR(30) = NULL;
	DECLARE @v_loss_code		NVARCHAR(30) = NULL;
	DECLARE @v_user_id_1		NVARCHAR(30) = NULL;
	DECLARE @v_user_id_2		NVARCHAR(30) = NULL;
	DECLARE @v_user_id_3		NVARCHAR(30) = NULL;
	DECLARE @v_user_id_4		NVARCHAR(30) = NULL;
	DECLARE @v_user_id_5		NVARCHAR(30) = NULL;
	DECLARE @v_user_id_6		NVARCHAR(30) = NULL;
	DECLARE @v_user_id_7		NVARCHAR(30) = NULL;
	DECLARE @v_user_id_8		NVARCHAR(30) = NULL;
	DECLARE @v_user_id_9		NVARCHAR(30) = NULL;
	DECLARE @v_user_id_10		NVARCHAR(30) = NULL;
	DECLARE @v_update_id		NVARCHAR(30) = NULL;

	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^'
	DECLARE @max_loop_cnt		INTEGER = 0;
	DECLARE @mst_loop_cnt		INTEGER = 0;
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0050_SAVE_CAPA_PIC';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	-- 시작 LOG
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	-- 트렌젝션 시작
	BEGIN TRAN;

	BEGIN TRY
		-- 프로시저 LOOP 길이를 판단
		SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_active_flag, @v_delimiter);    

		WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt
		BEGIN    	
			-- @mst_loop_cnt 1증가
			SET @mst_loop_cnt = @mst_loop_cnt + 1;

			-- 각 컬럼들에 대한 스플릿처리로직 스타트
			BEGIN
				SET @v_active_flag		= [dbo].[SCM_ARR_SPL_VAL](@p_active_flag	, @v_delimiter , @mst_loop_cnt) ;
				SET @v_company_id		= [dbo].[SCM_ARR_SPL_VAL](@p_company_id		, @v_delimiter , @mst_loop_cnt) ;
				SET @v_division_id		= [dbo].[SCM_ARR_SPL_VAL](@p_division_id	, @v_delimiter , @mst_loop_cnt) ;
				SET @v_site_id			= [dbo].[SCM_ARR_SPL_VAL](@p_site_id		, @v_delimiter , @mst_loop_cnt) ;
				SET @v_plant_id			= [dbo].[SCM_ARR_SPL_VAL](@P_plant_id		, @v_delimiter , @mst_loop_cnt) ;
				SET @v_factory_id		= [dbo].[SCM_ARR_SPL_VAL](@p_factory_id		, @v_delimiter , @mst_loop_cnt) ;
				SET @v_operation_id		= [dbo].[SCM_ARR_SPL_VAL](@p_operation_id	, @v_delimiter , @mst_loop_cnt) ;
				SET @v_line_id			= [dbo].[SCM_ARR_SPL_VAL](@p_line_id		, @v_delimiter , @mst_loop_cnt) ;
				SET @v_electrode_type	= [dbo].[SCM_ARR_SPL_VAL](@p_electrode_type	, @v_delimiter , @mst_loop_cnt) ;
				SET @v_loss_code		= [dbo].[SCM_ARR_SPL_VAL](@p_loss_code		, @v_delimiter , @mst_loop_cnt) ;
				SET @v_user_id_1		= [dbo].[SCM_ARR_SPL_VAL](@p_user_id_1		, @v_delimiter , @mst_loop_cnt) ;
				SET @v_user_id_2		= [dbo].[SCM_ARR_SPL_VAL](@p_user_id_2		, @v_delimiter , @mst_loop_cnt) ;
				SET @v_user_id_3		= [dbo].[SCM_ARR_SPL_VAL](@p_user_id_3		, @v_delimiter , @mst_loop_cnt) ;
				SET @v_user_id_4		= [dbo].[SCM_ARR_SPL_VAL](@p_user_id_4		, @v_delimiter , @mst_loop_cnt) ;
				SET @v_user_id_5		= [dbo].[SCM_ARR_SPL_VAL](@p_user_id_5		, @v_delimiter , @mst_loop_cnt) ;
				SET @v_user_id_6		= [dbo].[SCM_ARR_SPL_VAL](@p_user_id_6		, @v_delimiter , @mst_loop_cnt) ;
				SET @v_user_id_7		= [dbo].[SCM_ARR_SPL_VAL](@p_user_id_7		, @v_delimiter , @mst_loop_cnt) ;
				SET @v_user_id_8		= [dbo].[SCM_ARR_SPL_VAL](@p_user_id_8		, @v_delimiter , @mst_loop_cnt) ;
				SET @v_user_id_9		= [dbo].[SCM_ARR_SPL_VAL](@p_user_id_9		, @v_delimiter , @mst_loop_cnt) ;
				SET @v_user_id_10		= [dbo].[SCM_ARR_SPL_VAL](@p_user_id_10		, @v_delimiter , @mst_loop_cnt) ;
				SET @v_update_id		= [dbo].[SCM_ARR_SPL_VAL](@p_update_id		, @v_delimiter , @mst_loop_cnt) ;
			END

			--데이터 저장
			IF @mst_loop_cnt > 0
			BEGIN
				MERGE INTO SCM_MASTER_MANAGER_M_SN M
				USING (
						SELECT
							  @v_company_id		AS COMPANY_ID
							, @v_division_id	AS DIVISION_ID
							, @v_site_id		AS SITE_ID
							, @v_plant_id		AS PLANT_ID
							, @v_factory_id		AS FACTORY_ID
							, @v_operation_id	AS OPERATION_ID
							, @v_line_id		AS LINE_ID
							, @v_electrode_type	AS ELECTRODE_TYPE
							, @v_loss_code		AS LOSS_CODE
						) B
						 ON M.COMPANY_ID		= B.COMPANY_ID
						AND M.DIVISION_ID		= B.DIVISION_ID
						AND M.SITE_ID			= B.SITE_ID
						AND M.PLANT_ID			= B.PLANT_ID
						AND M.FACTORY_ID		= B.FACTORY_ID
						AND M.OPERATION_ID		= B.OPERATION_ID
						AND M.LINE_ID			= B.LINE_ID
						AND M.ELECTRODE_TYPE	= B.ELECTRODE_TYPE
						AND M.LOSS_CODE			= B.LOSS_CODE
					

				WHEN MATCHED THEN
					UPDATE SET
						  USER_ID_1		= @v_user_id_1
						, USER_ID_2		= @v_user_id_2
						, USER_ID_3		= @v_user_id_3
						, USER_ID_4		= @v_user_id_4
						, USER_ID_5		= @v_user_id_5
						, USER_ID_6		= @v_user_id_6
						, USER_ID_7		= @v_user_id_7
						, USER_ID_8		= @v_user_id_8
						, USER_ID_9		= @v_user_id_9
						, USER_ID_10	= @v_user_id_10
						, UPDATE_ID		= @v_update_id
						, UPDATE_TIME	= sysdatetime()

				WHEN NOT MATCHED THEN
					INSERT	(		
								  COMPANY_ID
								, DIVISION_ID
								, SITE_ID
								, PLANT_ID
								, FACTORY_ID
								, OPERATION_ID
								, LINE_ID
								, ELECTRODE_TYPE
								, LOSS_CODE
								, USER_ID_1
								, USER_ID_2
								, USER_ID_3
								, USER_ID_4
								, USER_ID_5
								, USER_ID_6
								, USER_ID_7
								, USER_ID_8
								, USER_ID_9
								, USER_ID_10
								, INSERT_ID
								, INSERT_TIME
								, UPDATE_ID
								, UPDATE_TIME
							)
					VALUES  (
					 			  @v_company_id
								, @v_division_id
								, @v_site_id
								, @v_plant_id
								, @v_factory_id
								, @v_operation_id
								, @v_line_id
								, @v_electrode_type
								, @v_loss_code
								, @v_user_id_1
								, @v_user_id_2
								, @v_user_id_3
								, @v_user_id_4
								, @v_user_id_5
								, @v_user_id_6
								, @v_user_id_7
								, @v_user_id_8
								, @v_user_id_9
								, @v_user_id_10
								, @v_update_id
								, SYSDATETIME()
								, @v_update_id
								, SYSDATETIME()
							);

							END  -- END OF STMT. IF( @mst_loop_cnt > 0 )
			
		END -- END OF STMT. WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt
		
			
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

		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	END

