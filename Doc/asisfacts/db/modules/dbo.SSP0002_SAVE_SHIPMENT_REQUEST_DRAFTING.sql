/*
 * Program ID   : SSP0002_SAVE_SHIPMENT_REQUEST_DRAFTING
 * Description  : Shipment Change Request 작성중 저장
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/04/16   ygkim           Initial Release [PJ20182279] 전지본부 출하계획 시스템 구축 프로젝트
 * 2018/05/29   ygkim		  create date, last update date 시간 변경
 * 2018/07/10   ygkim		  Change Type 추가로 인한 수정
 * 2018/08/30   ygkim		  Division 'EE' 추가로 인한 쿼리 수정
 * 2018/10/11   ygkim		  SSP_ANL_SHIP_CONFIRM_CHG_REQ 저장 로직 수정
 * 2018/10/15   ygkim		  Change Type New 로직 추가
 * 2019/02/14   hwyoon		  [CSR:3927951] REQUEST DETAIL 입력 시 ETD, ETA L/T(DAY)기준으로 재셋팅
 * 2019/04/04	ayj			  [PJ20189106] 전지.GSCM 고도화 이행- 소형 컬럼추가
 * 2019/10/29	ayj			  FCST_ETA_DATE, ETA_DATE 저장 값 수정(출발일 기준 항차를 고려한 ETA_DATE 계산)
 * 2019/11/29	KIMYONGHO	       [CSR:C20191127-000026] Shipment Change Reqeust 자가승인 기능 제한 요청 件 
 * 2020/02/18	KIMYONGHO	       Shipment Change Reqeust 자가승인 기능 제한 요청 件 로직 변경 -> Model pic 담당자 , scm pi admin, admin만 결재자로 지정 가능
 * 2020/03/13	KIMYONGHO	       [C20200312-000078] SSP Planner 권한 보유한 사람에 한해서 Shipment Model PIC로 타부서에서 결재자 변경 가능 기능 
 * 2024/05/07	hsbang	       테이블 SSP_ANL_SHIP_CONFIRM_CHG_REQ_de에 STATUS_DETAIL 입력(hsbang, 20240507)
 */

CREATE PROCEDURE [dbo].[SSP0002_SAVE_SHIPMENT_REQUEST_DRAFTING]
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
	DECLARE @v_DefaultGroupId		NVARCHAR(MAX);

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

	SET @v_last_update_date    = SYSDATETIME();

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SSP0002_SAVE_SHIPMENT_REQUEST_DRAFTING';
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
						
		SET @v_max_no = NULL;

		SET @v_chg_req_chk = 0;

		SELECT @v_chg_req_chk = isnull(COUNT(*),0)
		FROM SSP_ANL_SHIP_CONFIRM_CHG_REQ A WITH(NOLOCK)
		WHERE A.CHANGE_REQ_NO = @p_change_req_no

		SET @v_DefaultGroupId = '';

		SELECT @v_DefaultGroupId = ISNULL(DefaultGroupID,NULL)
		FROM TB_FX_User WITH(NOLOCK)
		WHERE USERID = @p_approval_id

		IF @v_chg_req_chk = 0
			BEGIN
				--SET @v_max_req_no = 'R'+CONVERT(VARCHAR(8), [dbo].[FN_MULTY_TIME](@p_time_zone), 112) + RIGHT('000000' + CONVERT(NVARCHAR, NEXT VALUE FOR SEQ1_SSP_ANL_SHIP_CHG_REQ_NO),6)
				SET @v_max_req_no = 'R'+CONVERT(VARCHAR(8), @v_last_update_date, 112) + RIGHT('000000' + CONVERT(NVARCHAR, NEXT VALUE FOR SEQ1_SSP_ANL_SHIP_CHG_REQ_NO),6)

			END
				
		IF ISNULL(@p_change_req_no, '') != ''
			BEGIN
				SET @v_max_req_no = @p_change_req_no
			END
		
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
			SET @v_item_id = NULL;

			SELECT @v_item_id = ITEM_ID
			FROM SSP_ANL_SHIP_CONFIRM WITH(NOLOCK)
			WHERE CONFIRM_ID = @v_main_confirm_id;
				
			-- **자가 승인 제한 건 반영 **
			-- MY MODEL 확인		
			SELECT @v_myModel_chk = @v_myModel_chk + COUNT(*)
			FROM SSP_MST_MODEL_USER A WITH(NOLOCK)
			JOIN SCM_MST_SSO_USER_INFO B WITH(NOLOCK) ON A.USER_ID = B.USER_ID
			LEFT JOIN SCM_MST_SSO_DEPT_INFO C WITH(NOLOCK) ON B.DEPT_ID = C.DEPT_ID
			WHERE A.DIVISION_ID= @p_division_id
			AND A.FROM_SITE	= @p_from_site
			AND A.ITEM_ID	= @v_item_id
			AND A.VALID_YN	= 'Y'
			AND A.USER_ID = @p_approval_id;
		END
		
		SET @mst_loop_cnt = 0;
			
		WHILE LEN(@p_main_confirm_id) > 0 AND @mst_loop_cnt < @max_loop_cnt
		BEGIN
			SET @mst_loop_cnt = @mst_loop_cnt + 1;
			SET @v_main_confirm_id = [dbo].[SCM_ARR_SPL_VAL](@p_main_confirm_id, @v_delimiter , @mst_loop_cnt) ;  
			BEGIN  
				-- 'ADMIN', 'SCM PI Admin' 권한 확인
				
				--IF @p_request_id = @p_approval_id 
				--	BEGIN
				--		IF @v_myModel_chk = 0 		
				--			BEGIN
				--				IF @p_auth != 'ADMIN' AND @p_auth != 'SCM PI Admin'
				--					THROW 60001, 'Unauthorized', 1;  -- ERROR 발생 시켜 UI에서 사용함 				
				--			END
				--	END

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
			
			IF @mst_loop_cnt > 0 
			BEGIN
				IF @p_change_type = 'P'
					BEGIN
							
						SET @v_chk = 0;
						SELECT @v_chk = CASE WHEN ISNULL(ATTRIBUTE1,'') = '' OR ATTRIBUTE1 IS NULL THEN 0 ELSE 1 END
						FROM SSP_ANL_SHIP_CONFIRM WITH(NOLOCK)
						WHERE CONFIRM_ID = @v_main_confirm_id;
							
						IF @v_chk = 0
							BEGIN
								SET @p_new_confirm_id = 'C'+CONVERT(VARCHAR(8), GETDATE(), 112) + RIGHT('000000' + CONVERT(NVARCHAR, NEXT VALUE FOR SEQ1_SSP_ANL_SHIP_CONFIRM_ID),6)
								UPDATE SSP_ANL_SHIP_CONFIRM
									SET SHIPMENT_STATUS = @p_ship_status
										,CHANGE_REQ_NO = @v_max_req_no
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
								,CHANGE_REQ_NO = @v_max_req_no
								,LAST_UPDATED_BY = @p_last_updated_by
								,LAST_UPDATE_DATE = @v_last_update_date--[dbo].[FN_MULTY_TIME](@p_time_zone)
						WHERE CONFIRM_ID = @v_main_confirm_id;
					END
			END
		END
		--Shipment Request Info Insert(SSP_ANL_SHIP_CONFIRM_CHG_REQ)
		BEGIN			
			MERGE INTO [dbo].[SSP_ANL_SHIP_CONFIRM_CHG_REQ] A
			USING (
					SELECT 
						@v_max_req_no	as change_req_no
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
					VALUES (	@v_max_req_no
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
		
		

		--SSP_ANL_SHIP_CONFIRM_CHG_REQ_de INSERT, UPDATE
		BEGIN
			SET @max_loop_cnt = 0
			SET @mst_loop_cnt = 0

			SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_confirm_id, @v_delimiter);    
			--SELECT    @max_loop_cnt;
			--	WHILE LEN(@p_active_flag) > 0
			WHILE LEN(@p_confirm_id) > 0 AND @mst_loop_cnt < @max_loop_cnt
			BEGIN
				SET @mst_loop_cnt = @mst_loop_cnt + 1;
				
				BEGIN  
					SET @v_confirm_id = [dbo].[SCM_ARR_SPL_VAL](@p_confirm_id, @v_delimiter , @mst_loop_cnt) ;  

					SET @v_new_bod_id = [dbo].[SCM_ARR_SPL_VAL](@p_new_bod_id, @v_delimiter , @mst_loop_cnt) ;  
					SET @v_new_route_id = [dbo].[SCM_ARR_SPL_VAL](@p_new_route_id, @v_delimiter , @mst_loop_cnt) ;  
					SET @v_new_incoterms = [dbo].[SCM_ARR_SPL_VAL](@p_new_incoterms, @v_delimiter , @mst_loop_cnt) ;  
					SET @v_new_d_contry = [dbo].[SCM_ARR_SPL_VAL](@p_new_d_contry, @v_delimiter , @mst_loop_cnt) ;  
					SET @v_new_d_port_code = [dbo].[SCM_ARR_SPL_VAL](@p_new_d_port_code, @v_delimiter , @mst_loop_cnt) ;  
					SET @v_new_a_country = [dbo].[SCM_ARR_SPL_VAL](@p_new_a_country, @v_delimiter , @mst_loop_cnt) ;  
					SET @v_new_a_port_code = [dbo].[SCM_ARR_SPL_VAL](@p_new_a_port_code, @v_delimiter , @mst_loop_cnt) ;  
					SET @v_new_to_country = [dbo].[SCM_ARR_SPL_VAL](@p_new_to_country, @v_delimiter , @mst_loop_cnt) ;  
					SET @v_new_to_city = [dbo].[SCM_ARR_SPL_VAL](@p_new_to_city, @v_delimiter , @mst_loop_cnt) ;  
					SET @v_new_lt_day = [dbo].[SCM_ARR_SPL_VAL](@p_new_lt_day, @v_delimiter , @mst_loop_cnt) ; 

					SET @v_new_etd_date = [dbo].[SCM_ARR_SPL_VAL](@p_new_etd_date, @v_delimiter , @mst_loop_cnt) ;  
					SET @v_new_eta_date = [dbo].[SCM_ARR_SPL_VAL](@p_new_eta_date, @v_delimiter , @mst_loop_cnt) ;  
					SET @v_new_transport_mode = [dbo].[SCM_ARR_SPL_VAL](@p_new_transport_mode, @v_delimiter , @mst_loop_cnt) ;  

					SET @v_new_ship_date = [dbo].[SCM_ARR_SPL_VAL](@p_new_ship_date, @v_delimiter , @mst_loop_cnt) ;  
					SET @v_new_qty = [dbo].[SCM_ARR_SPL_VAL](@p_new_qty, @v_delimiter , @mst_loop_cnt) ;  
					SET @v_new_yn = [dbo].[SCM_ARR_SPL_VAL](@p_new_yn, @v_delimiter , @mst_loop_cnt) ; 
					
					SET @v_remarks = [dbo].[SCM_ARR_SPL_VAL](@p_remarks, @v_delimiter , @mst_loop_cnt) ;
					SET @v_remarks2 = [dbo].[SCM_ARR_SPL_VAL](@p_remarks2, @v_delimiter , @mst_loop_cnt) ;
					SET @v_remarks3 = [dbo].[SCM_ARR_SPL_VAL](@p_remarks3, @v_delimiter , @mst_loop_cnt) ; 
				END
			
				IF @mst_loop_cnt > 0 
					BEGIN
						SET @v_chk = 0;

						IF ISNULL(@v_new_qty, '') = '' OR @v_new_qty IS NULL
							BEGIN
								SET @v_new_qty = NULL
							END

						IF ISNULL(@v_new_ship_date, '') = '' OR @v_new_ship_date IS NULL
							BEGIN
								SET @v_new_ship_date = ''
							END

						IF ISNULL(@v_remarks, '') = '' OR @v_remarks IS NULL
							BEGIN
								SET @v_remarks = NULL
							END

						IF ISNULL(@v_remarks2, '') = '' OR @v_remarks2 IS NULL
							BEGIN
								SET @v_remarks2 = NULL
							END

						IF ISNULL(@v_remarks3, '') = '' OR @v_remarks3 IS NULL
							BEGIN
								SET @v_remarks3 = NULL
							END

						SELECT @v_chk = COUNT(*)
						FROM SSP_ANL_SHIP_CONFIRM_CHG_REQ_de A WITH(NOLOCK)
						WHERE A.change_req_no  = @v_max_req_no
							AND A.confirm_id = @v_confirm_id;
							
						SET @v_new_etd_date = REPLACE(SUBSTRING(@v_new_etd_date,1,10),'-','')
						--SET @v_new_eta_date = REPLACE(SUBSTRING(@v_new_eta_date,1,10),'-','')
						SET @v_new_ship_date = REPLACE(SUBSTRING(@v_new_ship_date,1,10),'-','')

						/* 2019.02.14 etd:shipdate, eta:etd+lt_day로 셋팅*/
						IF ISNULL(@v_new_ship_date,'')!='' and LEN(@v_new_ship_date)=8 and ISNULL(@v_new_lt_day,'')!='' and LEN(@v_new_lt_day)>0
							BEGIN
								SET @v_new_etd_date = @v_new_ship_date
								;
								--SET @v_new_eta_date = convert(VARCHAR(8), dateadd(dd, convert(int, @v_new_lt_day), convert(datetime,@v_new_etd_date)),112)
								
							END

						/* 2019.10.29 출발일 기준 항차를 고려한 ETA_DATE 계산*/
						SET @v_new_eta_date = [dbo].[FN_GET_SSP_ETA_DATE](@p_division_id, @v_new_bod_id, @v_new_ship_date) 
												
						IF ISNULL(@p_new_confirm_id,'') != '' and @p_change_type = 'C'
							BEGIN
								SET @v_chk = 0
							END
						
						IF @p_change_type = 'N'
							BEGIN
								SELECT @v_chk = COUNT(*)
								FROM SSP_ANL_SHIP_CONFIRM_CHG_REQ_de A WITH(NOLOCK)
								WHERE A.change_req_no  = @v_max_req_no
									AND A.confirm_id = @p_new_confirm_id;
							END

						IF @v_chk > 0
							BEGIN
								UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ_de 
									SET  NEW_YYYYMMDD					= @v_new_ship_date
										,NEW_QTY						= @v_new_qty
										,NEW_ETD_DATE					= @v_new_etd_date
										,NEW_ETA_DATE					= @v_new_eta_date
										,NEW_TRANSPORT_MODE				= @v_new_transport_mode
										,NEW_BOD_ID						= @v_new_bod_id
										,NEW_ROUTE_ID					= @v_new_route_id
										,NEW_INCOTERMS					= @v_new_incoterms
										,NEW_D_COUNTRY					= @v_new_d_contry
										,NEW_D_PORT_CODE				= @v_new_d_port_code
										,NEW_A_COUNTRY					= @v_new_a_country
										,NEW_A_PORT_CODE				= @v_new_a_port_code
										,NEW_TO_COUNTRY					= @v_new_to_country
										,NEW_TO_CITY					= @v_new_to_city
										,NEW_CUSTOMER_LT				=@v_new_lt_day
										,VALID_YN						= 'Y'
										,ATTRIBUTE1						= 'N'
										,ATTRIBUTE2						= @p_change_status -- STATUS_DETAIL 입력(hsbang, 20240507)
										,LAST_UPDATED_BY			= @p_last_updated_by		   
										,LAST_UPDATE_DATE			= @v_last_update_date--[dbo].[FN_MULTY_TIME](@p_time_zone)
										,REMARKS						= @v_remarks
										,REMARKS2						= @v_remarks2
										,REMARKS3						= @v_remarks3
										/*----------------------------------------------------------------------------------------
											2020.06.30 : KBK
											I/F 추가요청으로 인하여 컬럼 추가 전극에서만 사용. DDL 표준을 맞추기 위하여 추가함 
										------------------------------------------------------------------------------------------*/
										,PACKAGE_QTY = CASE WHEN A.ELECTRODE_YN = 'N' THEN @v_new_qty
														 ELSE CEILING(CASE WHEN B.PACKAGE_TYPE_CODE = 'BX' THEN CEILING(@v_new_qty * isnull(B.CONVERT_TO_PC_ROLL_LENGTH ,1) ) * isnull(B.BOX_PER_CUT ,1)
 																			WHEN B.PACKAGE_TYPE_CODE = 'SC' THEN CEILING(@v_new_qty * isnull(B.CONVERT_TO_PC_ROLL_LENGTH ,1) ) * isnull(B.STEELCRATE_PER_CUT ,1)
 																			WHEN B.PACKAGE_TYPE_CODE = 'SR' THEN CEILING(@v_new_qty * isnull(B.CONVERT_TO_PC_ROLL_LENGTH ,1) ) * isnull(B.STEELRACK_PER_CUT ,1)
 																		ELSE NULL  END) END
								FROM SSP_ANL_SHIP_CONFIRM_CHG_REQ_de A with(nolock) 
								LEFT OUTER JOIN SSP_MST_SITE_ITEM_EE_V B with(nolock)
									ON  B.DIVISION_ID = A.DIVISION_ID 
									AND B.SCM_SITE_ID = A.FROM_SITE 
									AND B.ITEM_ID     = A.ITEM_ID 
								WHERE change_req_no  = @v_max_req_no
								  AND confirm_id = @v_confirm_id
								  AND new_yn = @v_new_yn;	
							END
						ELSE
							BEGIN
							--더블클릭으로 행추가											
								IF @v_new_yn = 'N'
									BEGIN
										INSERT SSP_ANL_SHIP_CONFIRM_CHG_REQ_de
											(	CHANGE_REQ_NO
											   ,CONFIRM_ID
											   ,NEW_YN
											   ,DIVISION_ID
											   ,ITEM_ID
											   ,FROM_SITE
											   ,TO_SITE
											   ,YYYYMMDD
											   ,QTY
											   ,BOD_ID
											   ,ROUTE_ID
											   ,BIZ_TYPE
											   ,PROJECT_CODE
											   ,FCST_TYPE
											   ,FCST_ETD_DATE
											   ,FCST_ETA_DATE
												,ETD_DATE
												,ETA_DATE
												,INCOTERMS
												,TRANSPORT_MODE
												,D_COUNTRY
												,D_PORT_CODE
												,A_COUNTRY
												,A_PORT_CODE
												,CUSTOMER_LT
												,TO_COUNTRY
												,TO_CITY
												,NEW_YYYYMMDD
												,NEW_QTY
												,NEW_BOD_ID
												,NEW_ROUTE_ID
												,NEW_ETD_DATE
												,NEW_ETA_DATE
												,NEW_INCOTERMS
												,NEW_TRANSPORT_MODE
												,NEW_D_COUNTRY
												,NEW_D_PORT_CODE
												,NEW_A_COUNTRY
												,NEW_A_PORT_CODE
												,NEW_CUSTOMER_LT
												,NEW_TO_COUNTRY
												,NEW_TO_CITY
												,FROM_SITE_TYPE
												,FROM_SITE_PLANT_ID
												,FROM_SITE_VENDOR_ID
												,FROM_SITE_SOLDTO_CODE
												,FROM_SITE_SHIPTO_CODE
												,FROM_SITE_COMPANY_ID
												,TO_SITE_TYPE
												,TO_SITE_PLANT_ID
												,TO_SITE_VENDOR_ID
												,TO_SITE_SOLDTO_CODE
												,TO_SITE_SHIPTO_CODE
												,TO_SITE_COMPANY_ID
												,ERP_SO_NO
												,ERP_SO_ITEM_NO
												,ERP_DO_NO
												,ERP_STATUS
												,VALID_YN
												,ATTRIBUTE1
												,ATTRIBUTE2
												,CREATED_BY
												,CREATION_DATE
												,LAST_UPDATED_BY
												,LAST_UPDATE_DATE
												,ELECTRODE_YN
												,ELECTRODE_TYPE
												,ORIGIN_FROM_DIVISION_ID
												,ORIGIN_TO_DIVISION_ID
												,REMARKS
												,REMARKS2
												,REMARKS3
												,REQUESTOR
												/*----------------------------------------------------------------------------------------
													2020.06.30 : KBK
													I/F 추가요청으로 인하여 컬럼 추가 전극에서만 사용. DDL 표준을 맞추기 위하여 추가함 
												------------------------------------------------------------------------------------------*/
												,PACKAGE_TYPE
												,FACTORY_ID
												,PACKAGE_QTY
												,DOM_EXP
												,ERP_ATTR1
												,ERP_ATTR2
												,ERP_ATTR3
												,ERP_ATTR4
												,ERP_ATTR5
											)
											SELECT @v_max_req_no CHANGE_REQ_NO
												 ,A.CONFIRM_ID
												 ,@v_new_yn NEW_YN
												 ,A.DIVISION_ID
												 ,A.ITEM_ID
												 ,A.FROM_SITE
												 ,A.TO_SITE
												 ,A.YYYYMMDD
												 ,A.QTY
												 ,A.BOD_ID
												 ,A.ROUTE_ID
												 ,A.BIZ_TYPE
												 ,A.PROJECT_CODE
												 ,A.FCST_TYPE
												 ,A.FCST_ETD_DATE
												 ,A.FCST_ETA_DATE	
												 ,A.ETD_DATE
												 ,A.ETA_DATE
												,A.INCOTERMS
												,A.TRANSPORT_MODE
												,A.D_COUNTRY
												,A.D_PORT_CODE
												,A.A_COUNTRY	
												,A.A_PORT_CODE
												,A.CUSTOMER_LT
												,A.TO_COUNTRY
												,A.TO_CITY
												,@v_new_ship_date NEW_YYYYMMDD
												,@v_new_qty NEW_QTY
												,@v_new_bod_id NEW_BOD_ID
												,@v_new_route_id NEW_ROUTE_ID
												,@v_new_etd_date NEW_ETD_DATE
												,@v_new_eta_date NEW_ETA_DATE
												,@v_new_incoterms NEW_INCOTERMS
												,@v_new_transport_mode NEW_TRANSPORT_MODE
												,@v_new_d_contry NEW_D_COUNTRY
												,@v_new_d_port_code NEW_D_PORT_CODE
												,@v_new_a_country NEW_A_COUNTRY	
												,@v_new_a_port_code NEW_A_PORT_CODE
												,@v_new_lt_day NEW_CUSTOMER_LT
												,@v_new_to_country NEW_TO_COUNTRY
												,@v_new_to_city NEW_TO_CITY 	
												,A.FROM_SITE_TYPE	
												,A.FROM_SITE_PLANT_ID	
												,A.FROM_SITE_VENDOR_ID
												,A.FROM_SITE_SOLDTO_CODE
												,A.FROM_SITE_SHIPTO_CODE	
												,A.FROM_SITE_COMPANY_ID
												,A.TO_SITE_TYPE
												,A.TO_SITE_PLANT_ID
												,A.TO_SITE_VENDOR_ID
												,A.TO_SITE_SOLDTO_CODE
												,A.TO_SITE_SHIPTO_CODE	
												,A.TO_SITE_COMPANY_ID
												,A.ERP_SO_NO
												,A.ERP_SO_ITEM_NO
												,A.ERP_DO_NO
												,A.ERP_STATUS
												,'Y'
												,'N'
												,@p_change_status -- STATUS_DETAIL 입력(hsbang, 20240507)
												,@p_last_updated_by CREATED_BY
												,@v_last_update_date--[dbo].[FN_MULTY_TIME](@p_time_zone) CREATION_DATE
												,@p_last_updated_by LAST_UPDATED_BY
												,@v_last_update_date--[dbo].[FN_MULTY_TIME](@p_time_zone) LAST_UPDATE_DATE
												,A.ELECTRODE_YN
												,A.ELECTRODE_TYPE
												,A.ORIGIN_FROM_DIVISION_ID
												,A.ORIGIN_TO_DIVISION_ID
												,@v_remarks 
												,@v_remarks2 
												,@v_remarks3 
												,A.REQUESTOR 
												/*----------------------------------------------------------------------------------------
													2020.06.30 : KBK
													I/F 추가요청으로 인하여 컬럼 추가 전극에서만 사용. DDL 표준을 맞추기 위하여 추가함 
												------------------------------------------------------------------------------------------*/
												,A.PACKAGE_TYPE_CODE
												,A.FACTORY_ID
												,CASE WHEN A.ELECTRODE_YN = 'N' THEN @v_new_qty
												 ELSE CEILING(CASE WHEN B.PACKAGE_TYPE_CODE = 'BX' THEN CEILING(@v_new_qty * isnull(B.CONVERT_TO_PC_ROLL_LENGTH ,1) ) * isnull(B.BOX_PER_CUT ,1)
 																   WHEN B.PACKAGE_TYPE_CODE = 'SC' THEN CEILING(@v_new_qty * isnull(B.CONVERT_TO_PC_ROLL_LENGTH ,1) ) * isnull(B.STEELCRATE_PER_CUT ,1)
 																   WHEN B.PACKAGE_TYPE_CODE = 'SR' THEN CEILING(@v_new_qty * isnull(B.CONVERT_TO_PC_ROLL_LENGTH ,1) ) * isnull(B.STEELRACK_PER_CUT ,1)
 															  ELSE NULL  END) END  AS PACKAGE_QTY
												,DOM_EXP
												,ERP_ATTR1
												,ERP_ATTR2
												,ERP_ATTR3
												,ERP_ATTR4
												,ERP_ATTR5
											FROM SSP_ANL_SHIP_CONFIRM A (NOLOCK)
												LEFT OUTER JOIN SSP_MST_SITE_ITEM_EE_V B with(nolock)
													ON  B.DIVISION_ID = A.DIVISION_ID 
													AND B.SCM_SITE_ID = A.FROM_SITE 
													AND B.ITEM_ID     = A.ITEM_ID 
											WHERE CONFIRM_ID = @v_confirm_id;
									END
							--add date버튼으로 행추가
								ELSE
									BEGIN		
										IF @p_change_type = 'N'
											BEGIN		
												SET @v_qty = null
											END	
										ELSE
											BEGIN		
												SET @v_qty = @v_new_qty
											END					
										INSERT SSP_ANL_SHIP_CONFIRM_CHG_REQ_de
											(	CHANGE_REQ_NO ,CONFIRM_ID ,NEW_YN ,DIVISION_ID ,ITEM_ID ,FROM_SITE ,TO_SITE
												,YYYYMMDD ,QTY ,BOD_ID ,ROUTE_ID ,BIZ_TYPE ,PROJECT_CODE ,FCST_TYPE ,FCST_ETD_DATE
												,FCST_ETA_DATE ,ETD_DATE ,ETA_DATE ,INCOTERMS ,TRANSPORT_MODE ,D_COUNTRY ,D_PORT_CODE
												,A_COUNTRY ,A_PORT_CODE ,CUSTOMER_LT ,TO_COUNTRY ,TO_CITY ,NEW_YYYYMMDD ,NEW_QTY
												,NEW_BOD_ID ,NEW_ROUTE_ID ,NEW_ETD_DATE ,NEW_ETA_DATE ,NEW_INCOTERMS ,NEW_TRANSPORT_MODE
												,NEW_D_COUNTRY ,NEW_D_PORT_CODE ,NEW_A_COUNTRY ,NEW_A_PORT_CODE ,NEW_CUSTOMER_LT
												,NEW_TO_COUNTRY ,NEW_TO_CITY ,FROM_SITE_TYPE ,FROM_SITE_PLANT_ID ,FROM_SITE_VENDOR_ID
												,FROM_SITE_SOLDTO_CODE ,FROM_SITE_SHIPTO_CODE ,FROM_SITE_COMPANY_ID ,TO_SITE_TYPE
												,TO_SITE_PLANT_ID ,TO_SITE_VENDOR_ID ,TO_SITE_SOLDTO_CODE ,TO_SITE_SHIPTO_CODE
												,TO_SITE_COMPANY_ID ,ERP_SO_NO ,ERP_SO_ITEM_NO ,ERP_DO_NO ,ERP_STATUS ,VALID_YN
												,ATTRIBUTE1 ,ATTRIBUTE2, CREATED_BY ,CREATION_DATE ,LAST_UPDATED_BY ,LAST_UPDATE_DATE
												,ELECTRODE_YN
												,ELECTRODE_TYPE
												,ORIGIN_FROM_DIVISION_ID
												,ORIGIN_TO_DIVISION_ID
												,REMARKS
												,REMARKS2
												,REMARKS3
												,REQUESTOR
												/*----------------------------------------------------------------------------------------
													2020.06.30 : KBK
													I/F 추가요청으로 인하여 컬럼 추가 전극에서만 사용. DDL 표준을 맞추기 위하여 추가함 
												------------------------------------------------------------------------------------------*/
												,PACKAGE_TYPE
												,FACTORY_ID
												,PACKAGE_QTY
												,DOM_EXP
												,ERP_ATTR1
												,ERP_ATTR2
												,ERP_ATTR3
												,ERP_ATTR4
												,ERP_ATTR5
											)
											SELECT @v_max_req_no CHANGE_REQ_NO
												,@p_new_confirm_id CONFIRM_ID
												,@v_new_yn NEW_YN
												,A.DIVISION_ID
												,A.ITEM_ID
												,A.FROM_SITE
												,A.TO_SITE
												,@v_new_ship_date YYYYMMDD
												,@v_qty QTY
												,@v_new_bod_id BOD_ID
												,@v_new_route_id ROUTE_ID
												,A.BIZ_TYPE
												,A.PROJECT_CODE
												,A.FCST_TYPE
												,A.FCST_ETD_DATE
												,A.FCST_ETA_DATE	
												,@v_new_etd_date ETD_DATE
												,@v_new_eta_date ETA_DATE
												,@v_new_incoterms INCOTERMS
												,@v_new_transport_mode TRANSPORT_MODE
												,@v_new_d_contry D_COUNTRY
												,@v_new_d_port_code D_PORT_CODE
												,@v_new_a_country A_COUNTRY	
												,@v_new_a_port_code A_PORT_CODE
												,@v_new_lt_day CUSTOMER_LT
												,@v_new_to_country TO_COUNTRY
												,@v_new_to_city TO_CITY
												,@v_new_ship_date NEW_YYYYMMDD
												,@v_new_qty NEW_QTY
												,@v_new_bod_id NEW_BOD_ID
												,@v_new_route_id NEW_ROUTE_ID
												,@v_new_etd_date NEW_ETD_DATE
												,@v_new_eta_date NEW_ETA_DATE
												,@v_new_incoterms NEW_INCOTERMS
												,@v_new_transport_mode NEW_TRANSPORT_MODE
												,@v_new_d_contry NEW_D_COUNTRY
												,@v_new_d_port_code NEW_D_PORT_CODE
												,@v_new_a_country NEW_A_COUNTRY	
												,@v_new_a_port_code NEW_A_PORT_CODE
												,@v_new_lt_day NEW_CUSTOMER_LT
												,@v_new_to_country NEW_TO_COUNTRY
												,@v_new_to_city NEW_TO_CITY 	
												,A.FROM_SITE_TYPE	
												,A.FROM_SITE_PLANT_ID	
												,A.FROM_SITE_VENDOR_ID
												,A.FROM_SITE_SOLDTO_CODE
												,A.FROM_SITE_SHIPTO_CODE	
												,A.FROM_SITE_COMPANY_ID
												,A.TO_SITE_TYPE
												,A.TO_SITE_PLANT_ID
												,A.TO_SITE_VENDOR_ID
												,A.TO_SITE_SOLDTO_CODE
												,A.TO_SITE_SHIPTO_CODE	
												,A.TO_SITE_COMPANY_ID
												,A.ERP_SO_NO
												,A.ERP_SO_ITEM_NO
												,A.ERP_DO_NO
												,A.ERP_STATUS
												,'Y'
												,'N'
												,@p_change_status
												,@p_last_updated_by CREATED_BY
												,@v_last_update_date--[dbo].[FN_MULTY_TIME](@p_time_zone) CREATION_DATE
												,@p_last_updated_by LAST_UPDATED_BY
												,@v_last_update_date--[dbo].[FN_MULTY_TIME](@p_time_zone) LAST_UPDATE_DATE
												,A.ELECTRODE_YN
												,A.ELECTRODE_TYPE
												,A.ORIGIN_FROM_DIVISION_ID
												,A.ORIGIN_TO_DIVISION_ID
												,@v_remarks 
												,@v_remarks2 
												,@v_remarks3 
												,A.REQUESTOR 
												/*----------------------------------------------------------------------------------------
													2020.06.30 : KBK
													I/F 추가요청으로 인하여 컬럼 추가 전극에서만 사용. DDL 표준을 맞추기 위하여 추가함 
												------------------------------------------------------------------------------------------*/
												,A.PACKAGE_TYPE_CODE
												,A.FACTORY_ID
												,CASE WHEN A.ELECTRODE_YN = 'N' THEN @v_new_qty
												 ELSE CEILING(CASE WHEN B.PACKAGE_TYPE_CODE = 'BX' THEN CEILING(@v_new_qty * isnull(B.CONVERT_TO_PC_ROLL_LENGTH ,1) ) * isnull(B.BOX_PER_CUT ,1)
 																   WHEN B.PACKAGE_TYPE_CODE = 'SC' THEN CEILING(@v_new_qty * isnull(B.CONVERT_TO_PC_ROLL_LENGTH ,1) ) * isnull(B.STEELCRATE_PER_CUT ,1)
 																   WHEN B.PACKAGE_TYPE_CODE = 'SR' THEN CEILING(@v_new_qty * isnull(B.CONVERT_TO_PC_ROLL_LENGTH ,1) ) * isnull(B.STEELRACK_PER_CUT ,1)
 															  ELSE NULL  END) END  AS PACKAGE_QTY
												,A.DOM_EXP
												,A.ERP_ATTR1
												,A.ERP_ATTR2
												,A.ERP_ATTR3
												,A.ERP_ATTR4
												,A.ERP_ATTR5
											FROM SSP_ANL_SHIP_CONFIRM A WITH(NOLOCK)
												LEFT OUTER JOIN SSP_MST_SITE_ITEM_EE_V B with(nolock)
													ON  B.DIVISION_ID = A.DIVISION_ID 
													AND B.SCM_SITE_ID = A.FROM_SITE 
													AND B.ITEM_ID     = A.ITEM_ID 
											WHERE CONFIRM_ID = @v_confirm_id;	
									END
							END
					END
			END

		END

		COMMIT;

		IF @p_change_status = 'Q'
		--출하확정변경시 ERP 전송 이터 테이블 저장 C: 변경요청
			BEGIN
				--메일 발송
				 EXEC SCM_SSP_MAIL_SEND @v_max_req_no, @p_change_status
			END
		
		IF @p_change_status = 'D'
			BEGIN
				IF @p_if_send_flag = 'Y'
					EXEC PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH 'C', @v_max_req_no
			END
				
		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = @v_last_update_date;--[dbo].[FN_MULTY_TIME](@p_time_zone);
		EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			
		-- 결과코드, 결과 카운트 반환
		SELECT  'S' AS result_code, @v_max_req_no Request_no ;

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
