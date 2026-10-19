

/*
 * Program ID   : SSP0013_SAVE_SHIPMENT_REQUEST_CONFIRM
 * Description  : Shipment Request Confirm 저장
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/10/10   ygkim          Initial Release [PJ20182279] 전지본부 출하계획 시스템 구축 프로젝트
 */

CREATE PROCEDURE [dbo].[SSP0013_SAVE_SHIPMENT_REQUEST_CONFIRM_CHECK]
     @p_active_flag			NVARCHAR(MAX)
	,@p_confirm_id			NVARCHAR(MAX)
	,@p_check_need_yn		NVARCHAR(MAX)
	,@p_user_id				NVARCHAR(MAX)
	,@p_change_req_no		NVARCHAR(MAX)
AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @recv_active_flag		NVARCHAR(MAX);
	SET @recv_active_flag = NULL;		
	SET @recv_active_flag = @p_active_flag;

	DECLARE @v_active_flag			NVARCHAR(MAX);
	DECLARE @v_confirm_id			NVARCHAR(MAX)
	DECLARE @v_check_need_yn		NVARCHAR(MAX)
	DECLARE @v_qty					INT
	DECLARE @v_create_date			DATETIME;

	SET @v_active_flag			= NULL;
	SET @v_confirm_id			= NULL;
	SET @v_check_need_yn		= NULL;

	SET @v_create_date    = SYSDATETIME();

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SSP0013_SAVE_SHIPMENT_REQUEST_CONFIRM_CHECK';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;	

	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^' 
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;

	BEGIN TRY
			-- 시작 LOG
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		
		SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_active_flag, @v_delimiter);    
		
		WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt
		BEGIN   
			-- @mst_loop_cnt 1증가
			SET @mst_loop_cnt = @mst_loop_cnt + 1;			

			-- 각 컬럼들에 대한 스플릿처리로직 스타트
			BEGIN
				--SET @v_active_flag		= dbo.SCM_ARR_SPL_VAL( @p_active_flag	    , @v_delimiter, @mst_loop_cnt );
				SET @v_confirm_id    = dbo.SCM_ARR_SPL_VAL( @p_confirm_id     , @v_delimiter, @mst_loop_cnt );
				SET @v_check_need_yn    = dbo.SCM_ARR_SPL_VAL( @p_check_need_yn     , @v_delimiter, @mst_loop_cnt );
			END;
			
			SET @v_qty = 0;

			SELECT @v_qty = count(*)
			FROM SSP_ANL_SHIP_CONFIRM WITH(NOLOCK)
			WHERE CONFIRM_ID = @v_confirm_id
			
			IF @v_qty > 0
				BEGIN
					UPDATE SSP_ANL_SHIP_CONFIRM
						SET CHECK_NEED_YN = @v_check_need_yn
							,LAST_UPDATED_BY = @p_user_id
							,LAST_UPDATE_DATE = @v_create_date
					WHERE CONFIRM_ID = @v_confirm_id;
				END;
		END;

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
		  SELECT 'F' AS result_code, '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE() AS ERR_MESSAGE ;
		END CATCH;
END

