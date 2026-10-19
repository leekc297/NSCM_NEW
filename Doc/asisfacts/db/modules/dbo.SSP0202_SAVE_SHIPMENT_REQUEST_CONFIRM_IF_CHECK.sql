



/*
 * Program ID   : SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK
 * Description  : Shipment Change Request Confirm Interface Check
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/05/23   ygkim          Initial Release [PJ20182279] 전지본부 출하계획 시스템 구축 프로젝트
 * 2018/05/29   ygkim			event_date 시간 변경
 * 2018/07/10   ygkim			@p_change_type 파라미터 추가
 */

CREATE PROCEDURE [dbo].[SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK]
	 @p_change_request_no	NVARCHAR(MAX)
	,@p_change_status		NVARCHAR(MAX)
	,@p_time_zone			NVARCHAR(MAX)
	,@p_change_type			NVARCHAR(MAX) = 'C'
AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @v_status       NVARCHAR(10)

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
	
	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^' 
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;

	SET @v_status = NULL
	-- 트렌젝션 시작

	BEGIN TRY
			-- 시작 LOG
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();--[dbo].[FN_MULTY_TIME](@p_time_zone);
		EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
				
		IF @p_change_status = 'A' --변경확정
			BEGIN
				IF @p_change_type = 'C'
					BEGIN
						SET @v_status = 'B'
					END
				ELSE
					BEGIN
						SET @v_status = 'A'
					END				

				--출하확정변경시 ERP 전송 이터 테이블 저장 B: 변경확정,C: 변경요청, D: 변경 Reject
				EXEC PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_PACKER @v_status, @p_change_request_no
			END 
		ELSE --변경 Reject
			BEGIN
			    UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ_de
					  SET ATTRIBUTE1 = 'Y'
					     --,LAST_UPDATED_BY = @p_last_updated_by
						 --,LAST_UPDATE_DATE = [dbo].[FN_MULTY_TIME](@p_time_zone)
					WHERE CHANGE_REQ_NO = @p_change_request_no
					  AND VALID_YN = 'Y';

				--출하확정변경시 ERP 전송 이터 테이블 저장 B: 변경확정,C: 변경요청, D: 변경 Reject
				EXEC PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_PACKER 'D', @p_change_request_no
			END 

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

			IF @@TRANCOUNT > 0
			  COMMIT WORK;
		  END;

		  -- error코드, errror 메시지 반환
		  SELECT 'F' AS result_code;
		  SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
		END CATCH;
END
