


/*
 * Program ID   : SCM_SSP_GET_ORDER_CONFIRM
 * Description  : SSP Order 변경시 2분 이후 수량 재변경 LOCK 기능
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2023/03/16   jilee			Initial Release SSP Order 변경시 2분 이후 수량 재변경 LOCK 기능
     
 */

CREATE PROCEDURE [dbo].[SCM_SSP_CHECK_CONFIRM_CHANGETIME_DE]
     @p_confirm_id					NVARCHAR(MAX)

AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @v_confirm_id			    NVARCHAR(MAX)
	DECLARE @v_chk						INT
	DECLARE @v_title					NVARCHAR(MAX) = ''
	DECLARE @v_remarks					NVARCHAR(MAX)
	DECLARE @v_remarks2					NVARCHAR(MAX)
	DECLARE @v_remarks3					NVARCHAR(MAX)

	DECLARE @v_chk_interval					INT

	SET @v_chk						= 0;
	SET @v_remarks					= NULL;
	SET @v_remarks2					= NULL;
	SET @v_remarks3					= NULL;
	--SET @v_chk_interval             = 0;

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCM_SSP_CHECK_CONFIRM_CHANGETIME_DE';
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
		
		SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_confirm_id, @v_delimiter);
		WHILE LEN(@p_confirm_id) > 0 AND @mst_loop_cnt < @max_loop_cnt
		BEGIN

			SET @mst_loop_cnt = @mst_loop_cnt + 1;			

			-- 각 컬럼들에 대한 스플릿처리로직 스타트
			BEGIN
				SET @v_confirm_id	= dbo.SCM_ARR_SPL_VAL( @p_confirm_id,				@v_delimiter, @mst_loop_cnt );				
				
				SET @v_chk          = 0;
				SET @v_chk_interval = 1;

				SELECT @v_chk = COUNT(*)  
				FROM SSP_ANL_SHIP_CONFIRM c with(nolock) 
				WHERE c.CONFIRM_ID = @v_confirm_id;

				IF @v_chk > 0
				BEGIN
					SELECT TOP 1 @v_chk_interval = CASE WHEN DATEDIFF(MI,ISNULL(c.LAST_UPDATE_DATE,2),GETDATE()) >= 2 THEN 1 ELSE 0 END
					FROM SSP_ANL_SHIP_CONFIRM c with(nolock) 
					WHERE c.CONFIRM_ID = @v_confirm_id
					ORDER BY LAST_UPDATE_DATE desc;
				END		

				-- @v_chk > 0          : 해당 Confirm 변경 이력이 1회 이상 있는 경우
				-- @v_chk_interval = 0 : 가장 최근에 변경Confirm 이 2분 이내인 경우 
				IF @v_chk > 0 AND @v_chk_interval = 0
				BEGIN				
			
					SELECT 'X' AS result_code, @v_chk AS CHK1, @v_chk_interval AS CHK2;

					SET @v_log_type = 'END';
					SET @v_log_message = '########## END of procedure ##########';
					SET @v_description = 'X ' +  @v_confirm_id;
					SET @d_event_date = SYSDATETIME();
					EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

					RETURN;

				END

			END;

		END;--While End		

		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
					
		-- 결과코드, 결과 카운트 반환
		SELECT  'S' AS result_code;

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
