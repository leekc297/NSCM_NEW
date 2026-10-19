
/*
 * Program ID   : SSP0002_DELETE_SHIPMENT_REQUEST_DRAFTING
 * Description  : Shipment Change Request 작성중 삭제
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/04/18   ygkim          Initial Release [PJ20182279] 전지본부 출하계획 시스템 구축 프로젝트
 * 2018/05/29   ygkim			create date, last update date 시간 변경
 * 2018/06/01   ygkim			ERP 에러일 경우 로직 수정
 * 2018/07/10   ygkim			@p_if_send_flag, @p_change_type 파라미터 추가
 * 2018/10/08   ygkim           Change Type Plan 일 경우 Status 'C' -> 'P'로 변경
 * 2018/10/15   ygkim			Change Typte New 로직 추가
 */

CREATE PROCEDURE [dbo].[SSP0002_DELETE_SHIPMENT_REQUEST_DRAFTING]
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

	DECLARE @v_confirm_id			NVARCHAR(MAX)
	DECLARE @v_chk					INT
	DECLARE @v_last_update_date     datetime;

	SET @v_confirm_id = null
	SET @v_chk = 0
	SET @v_last_update_date    = SYSDATETIME();

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SSP0002_DELETE_SHIPMENT_REQUEST_DRAFTING';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;	

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
		
		--SSP_ANL_SHIP_CONFIRM SHIPMENT_STATUS, CHANGE_REQ_NO UPDATE
		-- 프로시저 LOOP 길이를 판단
		SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_confirm_id, @v_delimiter);    
		--SELECT    @max_loop_cnt;
		--	WHILE LEN(@p_active_flag) > 0
		WHILE LEN(@p_confirm_id) > 0 AND @mst_loop_cnt < @max_loop_cnt
		BEGIN
			SET @mst_loop_cnt = @mst_loop_cnt + 1;

			BEGIN  
				SET @v_confirm_id = [dbo].[SCM_ARR_SPL_VAL](@p_confirm_id, @v_delimiter , @mst_loop_cnt) ;    
			END
			
			IF @mst_loop_cnt > 0 
				/*
					@p_del_flag = 'D' 화면에서 Delete 할 경우
					              'E' ERP 에러일 경우
								  'D_E' Delete ERP 에러일 경우
				*/
				IF @p_del_flag = 'D'
					BEGIN
						IF @p_change_type = 'C'
							BEGIN
								UPDATE SSP_ANL_SHIP_CONFIRM
									   SET SHIPMENT_STATUS = 'C'
										  ,CHANGE_REQ_NO = NULL
										  ,ATTRIBUTE1 = NULL
										  ,LAST_UPDATED_BY = @p_last_updated_by
										  ,LAST_UPDATE_DATE = @v_last_update_date--[dbo].[FN_MULTY_TIME](@p_time_zone)
									WHERE CONFIRM_ID = @v_confirm_id;
							END
						ELSE IF @p_change_type = 'N'
							BEGIN
								DELETE SSP_ANL_SHIP_CONFIRM
									WHERE CONFIRM_ID = @v_confirm_id;
							END
						ELSE
							BEGIN
								UPDATE SSP_ANL_SHIP_CONFIRM
									SET SHIPMENT_STATUS = 'P'
										,CHANGE_REQ_NO = NULL
										,ATTRIBUTE1 = NULL
										,LAST_UPDATED_BY = @p_last_updated_by
										,LAST_UPDATE_DATE = @v_last_update_date--[dbo].[FN_MULTY_TIME](@p_time_zone)
								WHERE ATTRIBUTE1 = @v_confirm_id;
							END

						BEGIN
							UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ_de
							  SET VALID_YN = 'N'
								 ,ATTRIBUTE1 = 'Y'
								 ,LAST_UPDATED_BY = @p_last_updated_by
								 ,LAST_UPDATE_DATE = @v_last_update_date--[dbo].[FN_MULTY_TIME](@p_time_zone)
							WHERE CONFIRM_ID = @v_confirm_id
							  AND CHANGE_REQ_NO = @p_change_request_no;
						END

						BEGIN
							SELECT @v_chk = COUNT(*) 
							FROM SSP_ANL_SHIP_CONFIRM_CHG_REQ_de WITH(NOLOCK)
							WHERE CHANGE_REQ_NO = @p_change_request_no
							  AND VALID_YN = 'Y';

							IF @v_chk = 0
								BEGIN
									UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ
										SET VALID_YN = 'N'
										   ,LAST_UPDATED_BY = @p_last_updated_by
										   ,LAST_UPDATE_DATE = @v_last_update_date--[dbo].[FN_MULTY_TIME](@p_time_zone)
									WHERE CHANGE_REQ_NO = @p_change_request_no
								END
						END
					END
				ELSE IF @p_del_flag = 'E'
					BEGIN
						BEGIN
						UPDATE SSP_ANL_SHIP_CONFIRM
							   SET SHIPMENT_STATUS = 'C'
								  ,CHANGE_REQ_NO = NULL
								  ,LAST_UPDATED_BY = @p_last_updated_by
								  ,LAST_UPDATE_DATE = @v_last_update_date--[dbo].[FN_MULTY_TIME](@p_time_zone)
							WHERE CONFIRM_ID = @v_confirm_id;
						END

						BEGIN
							DELETE SSP_ANL_SHIP_CONFIRM_CHG_REQ_de
							WHERE CONFIRM_ID = @v_confirm_id
							  AND CHANGE_REQ_NO = @p_change_request_no;
						END

						BEGIN
							SELECT @v_chk = COUNT(*) 
							FROM SSP_ANL_SHIP_CONFIRM_CHG_REQ_de WITH(NOLOCK)
							WHERE CHANGE_REQ_NO = @p_change_request_no
							  AND VALID_YN = 'Y';

							IF @v_chk = 0
								BEGIN
									DELETE SSP_ANL_SHIP_CONFIRM_CHG_REQ
									WHERE CHANGE_REQ_NO = @p_change_request_no
								END
						END
					END
				ELSE
					BEGIN
						BEGIN
						UPDATE SSP_ANL_SHIP_CONFIRM
							   SET SHIPMENT_STATUS = 'D'
								  ,CHANGE_REQ_NO = @p_change_request_no
								  ,LAST_UPDATED_BY = @p_last_updated_by
								  ,LAST_UPDATE_DATE = @v_last_update_date--[dbo].[FN_MULTY_TIME](@p_time_zone)
							WHERE CONFIRM_ID = @v_confirm_id;
						END

						BEGIN
							UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ_de
							  SET VALID_YN = 'Y'
								 ,LAST_UPDATED_BY = @p_last_updated_by
								 ,LAST_UPDATE_DATE = @v_last_update_date--[dbo].[FN_MULTY_TIME](@p_time_zone)
							WHERE CONFIRM_ID = @v_confirm_id
							  AND CHANGE_REQ_NO = @p_change_request_no;
						END

						BEGIN
							SELECT @v_chk = COUNT(*) 
							FROM SSP_ANL_SHIP_CONFIRM_CHG_REQ_de WITH(NOLOCK)
							WHERE CHANGE_REQ_NO = @p_change_request_no
							  AND VALID_YN = 'N';

							IF @v_chk = 0
								BEGIN
									UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ
										SET VALID_YN = 'Y'
										   ,LAST_UPDATED_BY = @p_last_updated_by
										   ,LAST_UPDATE_DATE = @v_last_update_date--[dbo].[FN_MULTY_TIME](@p_time_zone)
									WHERE CHANGE_REQ_NO = @p_change_request_no
								END
						END
					END
		END

		BEGIN
			IF @p_del_flag = 'D' and @p_if_send_flag = 'Y'
				EXEC PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH 'D', @p_change_request_no
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

		  END;

		  -- error코드, errror 메시지 반환
		  SELECT 'F' AS result_code;
		  SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
		END CATCH;
END
