/*
 * Program ID   : SSP0200_SAVE_SHIPMENT_REQUEST_COMPLETE
 * Description  : Shipment Change Request 작성중 저장
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/06/03   KIMYONGHO      최초작성
 * 2024/05/08   hsbang         SSP_ANL_SHIP_CONFIRM_CHG_REQ Status Insert(hsbang, 2024.05.08)
 * 2024/05/09   jilee          Unauthorized 부분 주석
 */

CREATE PROCEDURE [dbo].[SSP0200_SAVE_SHIPMENT_REQUEST_COMPLETE]
	 @p_division_id			NVARCHAR(MAX)
	,@p_from_site			NVARCHAR(MAX)
	,@p_title				NVARCHAR(MAX)
	,@p_request_id			NVARCHAR(MAX)
	,@p_request_dept_id		NVARCHAR(MAX)
	,@p_approval_id			NVARCHAR(MAX)
	,@p_approval_dept_id	NVARCHAR(MAX)
	,@p_change_reason		NVARCHAR(MAX)
	,@p_reason_detail		NVARCHAR(MAX)
	,@p_last_updated_by     NVARCHAR(MAX)	
	,@p_main_confirm_id		NVARCHAR(MAX)
	,@p_confirm_id			NVARCHAR(MAX)
	,@p_new_confirm_id		NVARCHAR(MAX)

	,@p_new_bod_id			NVARCHAR(MAX)
	,@p_new_route_id		NVARCHAR(MAX)
	,@p_new_incoterms		NVARCHAR(MAX)
	,@p_new_d_contry		NVARCHAR(MAX)
	,@p_new_d_port_code		NVARCHAR(MAX)
	,@p_new_a_country		NVARCHAR(MAX)
	,@p_new_a_port_code		NVARCHAR(MAX)
	,@p_new_to_country		NVARCHAR(MAX)
	,@p_new_to_city			NVARCHAR(MAX)
	,@p_new_lt_day			NVARCHAR(MAX)

	,@p_change_status		NVARCHAR(MAX)

	,@p_new_etd_date		NVARCHAR(MAX)
	,@p_new_eta_date		NVARCHAR(MAX)
	,@p_new_transport_mode	NVARCHAR(MAX)

	,@p_ship_status			NVARCHAR(MAX)
	,@p_change_req_no		NVARCHAR(MAX)
	,@p_new_ship_date		NVARCHAR(MAX)
	,@p_new_qty				NVARCHAR(MAX)
	,@p_new_yn				NVARCHAR(MAX)
	,@p_time_zone			NVARCHAR(MAX)
	,@p_if_send_flag        NVARCHAR(MAX) = 'Y'
	,@p_change_type         NVARCHAR(MAX) = 'C'
	,@p_plan_confirm_id     NVARCHAR(MAX)

	,@p_electrode_yn		NVARCHAR(MAX) = ''
	,@p_electrode_type		NVARCHAR(MAX) = ''
	,@p_origin_from_division_id     NVARCHAR(MAX) = ''
	,@p_origion_to_division_id		NVARCHAR(MAX) = ''

	,@p_remarks				NVARCHAR(MAX)
	,@p_remarks2			NVARCHAR(MAX)
	,@p_remarks3			NVARCHAR(MAX)
	,@p_requestor			NVARCHAR(MAX)
	,@p_auth			    NVARCHAR(MAX)
AS
BEGIN
	SET NOCOUNT ON; 
	--SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	--SET XACT_ABORT ON;

	DECLARE @v_max_no		NVARCHAR(6);
	DECLARE @v_max_req_no	NVARCHAR(40);

	DECLARE @v_division_id			NVARCHAR(MAX);
	DECLARE @v_from_site			NVARCHAR(MAX);
	DECLARE @v_change_req_no		NVARCHAR(MAX);

	DECLARE @v_main_confirm_id		NVARCHAR(MAX);
	DECLARE @v_confirm_id			NVARCHAR(MAX);

	DECLARE @v_new_bod_id			NVARCHAR(MAX);
	DECLARE @v_new_route_id			NVARCHAR(MAX);
	DECLARE @v_new_incoterms		NVARCHAR(MAX);
	DECLARE @v_new_d_contry			NVARCHAR(MAX);
	DECLARE @v_new_d_port_code		NVARCHAR(MAX);
	DECLARE @v_new_a_country		NVARCHAR(MAX);
	DECLARE @v_new_a_port_code		NVARCHAR(MAX);
	DECLARE @v_new_to_country		NVARCHAR(MAX);
	DECLARE @v_new_to_city			NVARCHAR(MAX);
	DECLARE @v_new_lt_day			NVARCHAR(MAX);

	DECLARE @v_new_etd_date			NVARCHAR(MAX);
	DECLARE @v_new_eta_date			NVARCHAR(MAX);
	DECLARE @v_new_transport_mode	NVARCHAR(MAX);

	DECLARE @v_new_ship_date		NVARCHAR(MAX);
	DECLARE @v_new_qty				NVARCHAR(MAX);
	DECLARE @v_qty					NVARCHAR(MAX);
	DECLARE @v_new_yn				NVARCHAR(MAX);
	DECLARE @v_chk					INT;
	DECLARE @v_chg_req_chk			INT;
	DECLARE @v_myModel_chk			INT;
	DECLARE @v_auth_chk				INT;

	
	DECLARE @v_last_update_date     datetime;

	DECLARE @v_remarks				NVARCHAR(MAX);
	DECLARE @v_remarks2				NVARCHAR(MAX);
	DECLARE @v_remarks3				NVARCHAR(MAX);

	/*권한 체크용 변수*/
	DECLARE @v_item_id				NVARCHAR(MAX);
	DECLARE @v_item_id_temp			NVARCHAR(MAX);
	DECLARE @v_item_id_temp2			NVARCHAR(MAX);
	DECLARE @v_DefaultGroupId		NVARCHAR(MAX);

	DECLARE @v_model_pic			NVARCHAR(MAX);
	DECLARE @v_model_pic_temp		NVARCHAR(MAX);
	DECLARE @v_model_pic_temp2		NVARCHAR(MAX);


	SET @v_main_confirm_id = NULL;
	SET @v_confirm_id = NULL;

	SET @v_new_bod_id			= NULL;
	SET @v_new_route_id			= NULL;
	SET @v_new_incoterms		= NULL;
	SET @v_new_d_contry			= NULL;
	SET @v_new_d_port_code		= NULL;	
	SET @v_new_a_country		= NULL;	
	SET @v_new_a_port_code		= NULL;	
	SET @v_new_to_country		= NULL;	
	SET @v_new_to_city			= NULL;	
	SET @v_new_lt_day			= NULL;

	SET @v_new_etd_date = NULL;
	SET @v_new_eta_date = NULL;
	SET @v_new_transport_mode = NULL;

	SET @v_new_ship_date = NULL;
	SET @v_new_qty = NULL;
	SET @v_qty = NULL;
	SET @v_new_yn = NULL;
	SET @v_max_req_no = NULL;

	SET @v_remarks = NULL;
	SET @v_remarks2 = NULL;
	SET @v_remarks3 = NULL;

	SET @v_model_pic			     = NULL;
	SET @v_model_pic_temp		     = NULL;
	SET @v_model_pic_temp2		     = NULL;


	SET @v_item_id_temp				 = NULL;
	SET @v_item_id_temp2				 = NULL;


	SET @v_last_update_date    = SYSDATETIME();

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SSP0200_SAVE_SHIPMENT_REQUEST_COMPLETE';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;	

	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^' 
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;
	

	BEGIN TRAN;
	BEGIN TRY
			-- 시작 LOG
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();--[dbo].[FN_MULTY_TIME](@p_time_zone);
		EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
						
		SET @v_DefaultGroupId = '';

		SELECT @v_DefaultGroupId = ISNULL(DefaultGroupID,NULL)
		FROM TB_FX_User WITH(NOLOCK)
		WHERE USERID = @p_approval_id

		
		--SSP_ANL_SHIP_CONFIRM SHIPMENT_STATUS, CHANGE_REQ_NO UPDATE
		-- 프로시저 LOOP 길이를 판단
		SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_main_confirm_id, @v_delimiter);    
		--SELECT    @max_loop_cnt;
		--	WHILE LEN(@p_active_flag) > 0
		SET @v_myModel_chk = 0;
		
		WHILE LEN(@p_main_confirm_id) > 0 AND @mst_loop_cnt < @max_loop_cnt
		BEGIN
			SET @mst_loop_cnt = @mst_loop_cnt + 1;
			
			SET @v_main_confirm_id = [dbo].[SCM_ARR_SPL_VAL](@p_main_confirm_id, @v_delimiter , @mst_loop_cnt) ;
			SET @v_division_id = [dbo].[SCM_ARR_SPL_VAL](@p_division_id, @v_delimiter , @mst_loop_cnt) ;
			SET @v_from_site = [dbo].[SCM_ARR_SPL_VAL](@p_from_site, @v_delimiter , @mst_loop_cnt) ;
			SET @v_item_id = NULL;

			SELECT @v_item_id = ITEM_ID
			FROM SSP_ANL_SHIP_CONFIRM with(nolock)
			WHERE CONFIRM_ID = @v_main_confirm_id;


			SELECT @v_model_pic = USER_ID
			 FROM SSP_MST_MODEL_USER with(nolock)
			 WHERE ITEM_ID = @v_item_id
			   AND FROM_SITE = @v_from_site
			 ;

		    SET @v_model_pic_temp = @v_model_pic;
			SET @v_item_id_temp	  = @v_item_id;

			-- 다중 변경 시 동일 PIC만 변경 가능
			IF @v_model_pic_temp <> @v_model_pic_temp2
			BEGIN
				print '#';
				THROW 60001, 'UnModelPic', 1;  -- ERROR 발생 시켜 UI에서 사용함 	
			END


			-- 다중 변경 시 동일 아이템만 변경 가능
			--IF @v_item_id_temp <> @v_item_id_temp2
			--BEGIN
			--	print '#';
			--	THROW 60001, 'UnModelItem', 1;  -- ERROR 발생 시켜 UI에서 사용함 	
			--END



			SET @v_model_pic_temp2 = @v_model_pic_temp; 
			SET @v_item_id_temp2   = @v_item_id_temp;


			-- **자가 승인 제한 건 반영 **
			-- MY MODEL 확인		
			SELECT @v_myModel_chk = @v_myModel_chk + COUNT(*)
			FROM SSP_MST_MODEL_USER A WITH(NOLOCK)
			JOIN SCM_MST_SSO_USER_INFO B WITH(NOLOCK) ON A.USER_ID = B.USER_ID
			LEFT JOIN SCM_MST_SSO_DEPT_INFO C WITH(NOLOCK) ON B.DEPT_ID = C.DEPT_ID
			WHERE A.DIVISION_ID= @v_division_id
			AND A.FROM_SITE	= @v_from_site
			AND A.ITEM_ID	= @v_item_id
			AND A.VALID_YN	= 'Y'
			AND A.USER_ID = @p_approval_id;
		END
		

		SET @mst_loop_cnt = 0;
			
		WHILE LEN(@p_main_confirm_id) > 0 AND @mst_loop_cnt < @max_loop_cnt
		BEGIN
			SET @mst_loop_cnt = @mst_loop_cnt + 1;
			SET @v_main_confirm_id = [dbo].[SCM_ARR_SPL_VAL](@p_main_confirm_id, @v_delimiter , @mst_loop_cnt) ;  
			SET @v_division_id = [dbo].[SCM_ARR_SPL_VAL](@p_division_id, @v_delimiter , @mst_loop_cnt) ;
			SET @v_from_site = [dbo].[SCM_ARR_SPL_VAL](@p_from_site, @v_delimiter , @mst_loop_cnt) ;

			SET @v_change_req_no = [dbo].[SCM_ARR_SPL_VAL](@p_change_req_no, @v_delimiter , @mst_loop_cnt) ;

			/*
			BEGIN  

				/*GSCM 접속자의 'ADMIN', 'SCM PI Admin' 권한 확인 및 결재자의 권한 확인
				   1.요청자와 승인자가 동일할때 My model일 경우만 승인자 지정 가능
				   2.요청자와 승인자가 동일하지 않을때 My model 또는 SSP Planner 권한만 승인자 지정 가능
				   3.GSCM 접속자의 권한이 'ADMIN', 'SCM PI Admin' 일 경우 승인자 임의 지정 가능
				   
				*/
				IF @p_request_id = @p_approval_id 
					BEGIN
						IF @v_myModel_chk = 0 
							BEGIN
								IF @p_auth != 'ADMIN' AND @p_auth != 'SCM PI Admin'
									THROW 60001, 'Unauthorized', 1;  -- ERROR 발생 시켜 UI에서 사용함 	
							END	
					END
				ELSE IF @p_approval_id != ''
					BEGIN
						IF @v_myModel_chk = 0 
							BEGIN
								IF @v_DefaultGroupId != 'SSP Planner'
									BEGIN
										--IF @p_auth != 'ADMIN' AND @p_auth != 'SCM PI Admin'
										IF @v_DefaultGroupId != 'ADMIN' AND @v_DefaultGroupId != 'SCM PI Admin'
											THROW 60001, 'Unauthorized', 1;  -- ERROR 발생 시켜 UI에서 사용함 	
									END

									
							END	
					END

			END
			*/

			IF @mst_loop_cnt > 0 
				BEGIN
					IF @p_change_type = 'P'
						BEGIN
							
							SET @v_chk = 0;
							SELECT @v_chk = CASE WHEN ISNULL(ATTRIBUTE1,'') = '' OR ATTRIBUTE1 IS NULL THEN 0 ELSE 1 END
							FROM SSP_ANL_SHIP_CONFIRM with(nolock)
							WHERE CONFIRM_ID = @v_main_confirm_id;
							
							IF @v_chk = 0
								BEGIN
									SET @p_new_confirm_id = 'C'+CONVERT(VARCHAR(8), GETDATE(), 112) + RIGHT('000000' + CONVERT(NVARCHAR, NEXT VALUE FOR SEQ1_SSP_ANL_SHIP_CONFIRM_ID),6)
									UPDATE SSP_ANL_SHIP_CONFIRM
										SET SHIPMENT_STATUS = @p_ship_status
											,CHANGE_REQ_NO = @v_change_req_no
											,ATTRIBUTE1 = @p_new_confirm_id
											,LAST_UPDATED_BY = @p_last_updated_by
											,LAST_UPDATE_DATE = @v_last_update_date--[dbo].[FN_MULTY_TIME](@p_time_zone)
									WHERE CONFIRM_ID = @v_main_confirm_id;
								END
							ELSE
								BEGIN
									UPDATE SSP_ANL_SHIP_CONFIRM
										SET SHIPMENT_STATUS = @p_ship_status
											,LAST_UPDATED_BY = @p_last_updated_by
											,LAST_UPDATE_DATE = @v_last_update_date--[dbo].[FN_MULTY_TIME](@p_time_zone)
									WHERE CONFIRM_ID = @v_main_confirm_id;
								END
						END
					ELSE
						BEGIN
							UPDATE SSP_ANL_SHIP_CONFIRM
							   SET SHIPMENT_STATUS = @p_ship_status
								  ,CHANGE_REQ_NO = @v_change_req_no
								  ,LAST_UPDATED_BY = @p_last_updated_by
								  ,LAST_UPDATE_DATE = @v_last_update_date--[dbo].[FN_MULTY_TIME](@p_time_zone)
							WHERE CONFIRM_ID = @v_main_confirm_id;
						END

				    --SSP_ANL_SHIP_CONFIRM_CHG_REQ Status Insert(hsbang, 2024.05.08)
					BEGIN							
						UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE
							SET ATTRIBUTE2 = @p_change_status
								,LAST_UPDATED_BY = @p_last_updated_by
								,LAST_UPDATE_DATE = @v_last_update_date
						WHERE CHANGE_REQ_NO = @v_change_req_no
						AND CONFIRM_ID      = @v_main_confirm_id
						;
					END
						
					--Shipment Request Info Insert(SSP_ANL_SHIP_CONFIRM_CHG_REQ)
					BEGIN			
						MERGE INTO [dbo].[SSP_ANL_SHIP_CONFIRM_CHG_REQ] A
						USING (
								SELECT 
									@v_change_req_no	as change_req_no
								) B
						ON(
									A.change_req_no  = B.change_req_no
							)
						WHEN MATCHED THEN
								UPDATE SET 
										CHANGE_REQ_STATUS			= @p_change_status
										,REQUEST_TITLE				= @p_title
										,APPROVAL_USER				= @p_approval_id
										,APPROVAL_DEPT				= @p_approval_dept_id
										,CHANGE_REASON_CODE			= @p_change_reason
										,CHANGE_REASON_DETAIL		= @p_reason_detail
										,LAST_UPDATED_BY			= @p_last_updated_by		   
										,LAST_UPDATE_DATE			= @v_last_update_date--[dbo].[FN_MULTY_TIME](@p_time_zone)	
										,REQUEST_TIME               = @v_last_update_date
						WHEN NOT MATCHED THEN
								INSERT (	CHANGE_REQ_NO
										,CHANGE_REQ_STATUS
										,DIVISION_ID
										,FROM_SITE
										,REQUEST_TITLE
										,REQUEST_USER
										,REQUEST_DEPT
										,REQUEST_TIME
										,APPROVAL_USER
										,APPROVAL_DEPT
										,APPROVAL_TIME
										,CHANGE_REASON_CODE
										,CHANGE_REASON_DETAIL
										,REJECT_REASON
										,VALID_YN
										,CHANGE_TYPE
										,CREATED_BY
										,CREATION_DATE
										,LAST_UPDATED_BY
										,LAST_UPDATE_DATE
										,ELECTRODE_YN
										,ELECTRODE_TYPE
										,ORIGIN_FROM_DIVISION_ID
										,ORIGIN_TO_DIVISION_ID
									)
								VALUES (	@v_change_req_no
										  , @p_ship_status
										  , @p_division_id
										  , @p_from_site
										  , @p_title
										  , @p_request_id
										  , @p_request_dept_id
										  , @v_last_update_date--[dbo].[FN_MULTY_TIME](@p_time_zone)
										  , @p_approval_id
										  , @p_approval_dept_id
										  , NULL
										  , @p_change_reason
										  , @p_reason_detail
										  , NULL
										  ,'Y'
										  , @p_change_type
										  , @p_last_updated_by
										  , @v_last_update_date--[dbo].[FN_MULTY_TIME](@p_time_zone)
										  , @p_last_updated_by
										  , @v_last_update_date--[dbo].[FN_MULTY_TIME](@p_time_zone)
										  , substring(@p_electrode_yn,0, CHARINDEX('^',@p_electrode_yn)) --@p_electrode_yn
										  , substring(@p_electrode_type,0, CHARINDEX('^',@p_electrode_type)) --@p_electrode_type
										  , substring(@p_origin_from_division_id,0, CHARINDEX('^',@p_origin_from_division_id)) --@p_origin_from_division_id
										  , substring(@p_origion_to_division_id,0, CHARINDEX('^',@p_origion_to_division_id)) --@p_origion_to_division_id
									);
					END


				END
		END
	
		COMMIT;

		IF @p_change_status = 'Q'
		--출하확정변경시 ERP 전송 이터 테이블 저장 C: 변경요청
			BEGIN
				--메일 발송
				 EXEC SCM_SSP_MAIL_SEND @v_change_req_no, @p_change_status
			END
	
		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();--[dbo].[FN_MULTY_TIME](@p_time_zone);
		EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			
		-- 결과코드, 결과 카운트 반환
		SELECT  'S' AS result_code, @v_change_req_no Request_no ;

	 END TRY

	 BEGIN CATCH

		  ROLLBACK TRAN; --입력 데이타 롤백 처리

		  IF ERROR_NUMBER() != 60001  -- 자가 승인 제한건은 ERROR 로그 처리 안함.
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

				--IF @@TRANCOUNT > 0
				  --COMMIT WORK;
			  END;
		
		    -- error코드, errror 메시지 반환
			  SELECT 'F' AS result_code;
			  SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
		
		END CATCH;
END
