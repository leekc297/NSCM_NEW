


/*
 * Program ID   : SCM0019_SAVE_SCP_INTERFACE_BLOCKING
 * Description  : Plan 타겟 설정 수정
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2019/01/25	hwyoon			Initial Release [PS02199094B] GSCM(DM/SCP) SM운영/유지보수
 */
CREATE PROCEDURE [dbo].[SCM0019_SAVE_SCP_INTERFACE_BLOCKING]
	 @p_active_flag			NVARCHAR(MAX)
	,@p_division_id			NVARCHAR(MAX)
	,@p_plan_start_yyyymmdd	NVARCHAR(MAX)
	,@p_fp_target_yn 		NVARCHAR(MAX)
	,@p_mrp_target_yn 		NVARCHAR(MAX)
	,@p_dm_rtf_yn 			NVARCHAR(MAX)
AS

BEGIN

	SET NOCOUNT ON;

	DECLARE @recv_active_flag		NVARCHAR(MAX);
	SET @recv_active_flag = NULL;		
	SET @recv_active_flag = @p_active_flag;
	
	DECLARE @v_active_flag			NVARCHAR(MAX);
	DECLARE @v_division_id			NVARCHAR(MAX);
	DECLARE @v_plan_start_yyyymmdd	NVARCHAR(MAX);
	DECLARE @v_fp_target_yn			NVARCHAR(MAX);
	DECLARE @v_mrp_target_yn		NVARCHAR(MAX);
	DECLARE @v_dm_rtf_yn			NVARCHAR(MAX);

	SET @v_active_flag = NULL;
	SET @v_division_id = NULL;
	SET @v_plan_start_yyyymmdd = NULL;
	SET @v_fp_target_yn = NULL;
	SET @v_mrp_target_yn = NULL;
	SET @v_dm_rtf_yn = NULL;

	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^' 
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCM0019_SAVE_SCP_INTERFACE_BLOCKING';
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

		-- 프로시저 LOOP 길이를 판단
		SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_active_flag, @v_delimiter);    

		WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt
		BEGIN    

			SET @mst_loop_cnt = @mst_loop_cnt + 1;			

			-- 각 컬럼들에 대한 스플릿처리로직 스타트
			BEGIN
				SET @v_active_flag			= [dbo].[SCM_ARR_SPL_VAL](@p_active_flag	, @v_delimiter , @mst_loop_cnt) ;    
				SET @v_division_id			= [dbo].[SCM_ARR_SPL_VAL](@p_division_id	, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_plan_start_yyyymmdd	= [dbo].[SCM_ARR_SPL_VAL](@p_plan_start_yyyymmdd	, @v_delimiter , @mst_loop_cnt) ;    
				SET @v_fp_target_yn			= [dbo].[SCM_ARR_SPL_VAL](@p_fp_target_yn	, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_mrp_target_yn		= [dbo].[SCM_ARR_SPL_VAL](@p_mrp_target_yn	, @v_delimiter , @mst_loop_cnt) ; 				   				
				SET @v_dm_rtf_yn			= [dbo].[SCM_ARR_SPL_VAL](@p_dm_rtf_yn		, @v_delimiter , @mst_loop_cnt) ;    
			END

			--데이터 저장
			IF @mst_loop_cnt > 0 			
				BEGIN	
					
					IF( @v_active_flag ='M') 
						BEGIN
							UPDATE SCP_PLN_INTERFACE_YN
							   SET FP_TARGET_YN		= @v_fp_target_yn
								   , MRP_TARGET_YN	= @v_mrp_target_yn
								   , DM_RTF_YN		= @v_dm_rtf_yn
							 WHERE DIVISION_ID = @v_division_id
							   AND PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
							;
						END

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
		  END;

		  -- error코드, errror 메시지 반환
		  SELECT 'F' AS result_code;
		  SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
		END CATCH;
	END


