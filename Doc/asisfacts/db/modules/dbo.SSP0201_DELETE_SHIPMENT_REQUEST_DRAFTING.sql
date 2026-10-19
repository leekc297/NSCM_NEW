

/*
 * Program ID   : SSP0200_DELETE_SHIPMENT_REQUEST_DRAFTING
 * Description  : Shipment Plan Change 작성중 삭제
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/10/10   KIMYONGHO      최초작성
 */

CREATE PROCEDURE [dbo].[SSP0201_DELETE_SHIPMENT_REQUEST_DRAFTING]
	-- @p_change_request_no	NVARCHAR(MAX)
	--,@p_status				NVARCHAR(MAX)
	--,@p_user_id				NVARCHAR(MAX)
	 @p_confirm_id			NVARCHAR(MAX)	
	,@p_change_request_no	NVARCHAR(MAX)
	,@p_del_flag			NVARCHAR(MAX) = 'D'
	,@p_last_updated_by		NVARCHAR(MAX)
	,@p_time_zone			NVARCHAR(MAX)
	,@p_if_send_flag        NVARCHAR(MAX) = 'Y'
	,@p_change_type			NVARCHAR(MAX) = 'C'
AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @v_last_update_date     datetime;

	SET @v_last_update_date    = SYSDATETIME();

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SSP0200_DELETE_SHIPMENT_REQUEST_DRAFTING';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;	


	DECLARE @V_change_request_no	NVARCHAR(MAX)
	DECLARE @v_confirm_id			NVARCHAR(MAX)

	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^' 
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;

	-- 트렌젝션 시작

	BEGIN TRY
			-- 시작 LOG
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = @v_last_update_date;--[dbo].[FN_MULTY_TIME](@p_time_zone);
		EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


		SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_change_request_no, @v_delimiter);
		WHILE LEN(@p_change_request_no) > 0 AND @mst_loop_cnt < @max_loop_cnt
		BEGIN
			SET @mst_loop_cnt = @mst_loop_cnt + 1;			

			-- 각 컬럼들에 대한 스플릿처리로직 스타트
			BEGIN
				
				SET @v_change_request_no						= dbo.SCM_ARR_SPL_VAL( @p_change_request_no,					@v_delimiter, @mst_loop_cnt );
				SET @v_confirm_id								= dbo.SCM_ARR_SPL_VAL( @p_confirm_id,							@v_delimiter, @mst_loop_cnt );		
			END;


			update SSP_ANL_SHIP_CONFIRM_CHG_REQ
			   set VALID_YN = 'N'
				  ,LAST_UPDATED_BY = @p_last_updated_by
				  ,LAST_UPDATE_DATE = @v_last_update_date
			WHERE CHANGE_REQ_NO = @v_change_request_no;

			update SSP_ANL_SHIP_CONFIRM_CHG_REQ_de
			   set VALID_YN = 'N'
				  ,LAST_UPDATED_BY = @p_last_updated_by
				  ,LAST_UPDATE_DATE = @v_last_update_date
			WHERE CHANGE_REQ_NO = @v_change_request_no;


			UPDATE SSP_ANL_SHIP_CONFIRM
				SET SHIPMENT_STATUS = 'C'
					,CHANGE_REQ_NO = NULL
					,ATTRIBUTE1 = NULL
					,LAST_UPDATED_BY = @p_last_updated_by
					,LAST_UPDATE_DATE = @v_last_update_date--[dbo].[FN_MULTY_TIME](@p_time_zone)
			WHERE CONFIRM_ID IN (
				SELECT CONFIRM_ID 
				FROM  SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE WITH(NOLOCK)
				WHERE CHANGE_REQ_NO = @v_change_request_no
			)
			;

			
			DELETE FROM SSP_ANL_SHIP_CONFIRM
			WHERE CONFIRM_ID  --= @v_confirm_id;
					
			IN (
				SELECT CONFIRM_ID 
				FROM  SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE WITH(NOLOCK)
				WHERE CHANGE_REQ_NO = @v_change_request_no
			)
			AND CHANGE_TYPE = 'N'
			;

			IF @p_del_flag = 'D' and @p_if_send_flag = 'Y'
					EXEC PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_PACKER 'D', @v_change_request_no --, @v_confirm_id
		END;

		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		
		-- 결과코드, 결과 카운트 반환
		SELECT  'S' AS result_code ;
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

		  END;

		  -- error코드, errror 메시지 반환
		  SELECT 'F' AS result_code;
		  SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
		END CATCH;
END

