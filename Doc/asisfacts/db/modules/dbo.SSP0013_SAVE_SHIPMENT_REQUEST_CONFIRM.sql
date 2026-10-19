

/*
 * Program ID   : SSP0013_SAVE_SHIPMENT_REQUEST_CONFIRM
 * Description  : Shipment Request Confirm 저장
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2018/10/10   ygkim			Initial Release [PJ20182279] 전지본부 출하계획 시스템 구축 프로젝트
 * 2018/11/16	hwyoon			변경등록 후 메일 전송
 * 2019/03/14	AYJ				[PJ20189106] 전지.GSCM 고도화 이행  REMARKS2 컬럼 추가
 * 2019/04/30	AYJ			    [PJ20189106] 전지.GSCM 고도화 이행  REQUESTOR 컬럼 제거
 * 2019/05/07	AYJ				[PJ20189106] 전지.GSCM 고도화 이행  REMARKS3 컬럼 추가
 * 2019/05/30	mcTheJ			[PJ20189106] 전지.GSCM 고도화 이행  CHANGE_REASON 추가로 인한 메일 SEND 수정
 * 2019/11/26	KIMYONGHO		메일 전송 변경 JOB.SCM_SSP_ADJUST_MAIL_SEND_BATCH -> PR_SSP_MAIL_SEND_ADJUST_MST
 */

CREATE PROCEDURE [dbo].[SSP0013_SAVE_SHIPMENT_REQUEST_CONFIRM]
     @p_active_flag			NVARCHAR(MAX)
	,@p_division_id			NVARCHAR(MAX)
	,@p_confirm_id			NVARCHAR(MAX)
	,@p_shipment_qty		NVARCHAR(MAX)
	,@p_shipment_date		NVARCHAR(MAX)
	,@p_new_bod_id			NVARCHAR(MAX)
	,@p_new_route_id		NVARCHAR(MAX)
	,@p_new_etd_date		NVARCHAR(MAX)
	,@p_new_eta_date		NVARCHAR(MAX)
	,@p_new_incoterms		NVARCHAR(MAX)
	,@p_new_transport_mode	NVARCHAR(MAX)
	,@p_new_d_contry		NVARCHAR(MAX)
	,@p_new_d_port_code		NVARCHAR(MAX)
	,@p_new_a_country		NVARCHAR(MAX)
	,@p_new_a_port_code		NVARCHAR(MAX)
	,@p_new_customer_lt		NVARCHAR(MAX)
	,@p_new_to_country		NVARCHAR(MAX)
	,@p_new_to_city			NVARCHAR(MAX)
	,@p_remarks				NVARCHAR(MAX)
	,@p_remarks2			NVARCHAR(MAX)
	,@p_remarks3			NVARCHAR(MAX)
	,@p_user_id				NVARCHAR(MAX)
	,@p_check_need_yn		NVARCHAR(MAX)
	,@p_edit_main			NVARCHAR(MAX)
AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @mQuery NVARCHAR(MAX);
	DECLARE @mEXEC NVARCHAR(MAX);

	DECLARE @recv_active_flag		NVARCHAR(MAX);
	SET @recv_active_flag = NULL;		
	SET @recv_active_flag = @p_active_flag;

	DECLARE @v_active_flag			NVARCHAR(MAX);
	DECLARE @v_division_id			NVARCHAR(MAX)
	DECLARE @v_confirm_id			NVARCHAR(MAX)
	DECLARE @v_shipment_qty			NVARCHAR(MAX)
	DECLARE @v_shipment_date		NVARCHAR(MAX)
	DECLARE @v_new_bod_id			NVARCHAR(MAX)
	DECLARE @v_new_etd_date			NVARCHAR(MAX)
	DECLARE @v_new_eta_date			NVARCHAR(MAX)
	DECLARE @v_new_route_id			NVARCHAR(MAX)
	DECLARE @v_new_incoterms		NVARCHAR(MAX)
	DECLARE @v_new_transport_mode	NVARCHAR(MAX)
	DECLARE @v_new_d_contry			NVARCHAR(MAX)
	DECLARE @v_new_d_port_code		NVARCHAR(MAX)
	DECLARE @v_new_a_country		NVARCHAR(MAX)
	DECLARE @v_new_a_port_code		NVARCHAR(MAX)
	DECLARE @v_new_customer_lt		NVARCHAR(MAX)
	DECLARE @v_new_to_country		NVARCHAR(MAX)
	DECLARE @v_new_to_city			NVARCHAR(MAX)
	DECLARE @v_create_date			DATETIME;
	DECLARE @v_before_qty			INT
	DECLARE @v_qty					INT
	DECLARE @v_remarks				NVARCHAR(MAX)
	DECLARE @v_remarks2				NVARCHAR(MAX)
	DECLARE @v_remarks3				NVARCHAR(MAX)
	DECLARE @v_check_need_yn		NVARCHAR(MAX)

	DECLARE @n_division_id			NVARCHAR(MAX);
	DECLARE @n_item_id				NVARCHAR(MAX);
	DECLARE @n_from_site			NVARCHAR(MAX);
	DECLARE @n_to_site				NVARCHAR(MAX);
	DECLARE @n_yyyymmdd				NVARCHAR(MAX);
	DECLARE @n_bod_id				NVARCHAR(MAX);
	DECLARE @n_project_code			NVARCHAR(MAX);
	DECLARE @n_fcst_type			NVARCHAR(MAX);
	DECLARE @n_incoterms			NVARCHAR(MAX);
	DECLARE @n_transport_mode		NVARCHAR(MAX);
	DECLARE @n_confirm_id			NVARCHAR(MAX);
	DECLARE @v_plan_start_yyyymmdd  NVARCHAR(MAX);
	DECLARE @v_seq					NVARCHAR(MAX);
	DECLARE @v_chk					INT
	DECLARE @v_edit_main		    NVARCHAR(MAX);

	DECLARE @n_ori_division_id			NVARCHAR(MAX);
	DECLARE @n_ori_item_id				NVARCHAR(MAX);
	DECLARE @n_ori_from_site			NVARCHAR(MAX);
	DECLARE @n_ori_to_site				NVARCHAR(MAX);
	DECLARE @n_ori_yyyymmdd				NVARCHAR(MAX);
	DECLARE @n_ori_bod_id				NVARCHAR(MAX);
	DECLARE @n_ori_project_code			NVARCHAR(MAX);
	DECLARE @n_ori_fcst_type			NVARCHAR(MAX);
	DECLARE @n_ori_incoterms			NVARCHAR(MAX);
	DECLARE @n_ori_transport_mode		NVARCHAR(MAX);
	DECLARE @n_ori_confirm_id			NVARCHAR(MAX);
	DECLARE @v_planned_qty              INT;
	DECLARE @v_change_req_no			NVARCHAR(MAX);
	DECLARE @v_yyyymmdd					NVARCHAR(MAX);

	--//메일관련 변수////////////////////////////////
	DECLARE @v_grp_change_req			NVARCHAR(20);
	DECLARE @Mail_Flag					INT;
	DECLARE @Mail_CHK					INT;
	SET @Mail_Flag = 0;
	SET @Mail_CHK = 0;
	SET @v_grp_change_req = 'G'+ REPLACE(REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR(23), SYSDATETIME(), 21), '-', ''), ':', ''), '.', ''), ' ', '');
	--///////////////////////////////////////////////

	SET @v_active_flag = NULL;
	SET @v_division_id			= NULL;
	SET @v_confirm_id			= NULL;
	SET @v_shipment_qty			= NULL;
	SET @v_shipment_date		= NULL;
	SET @v_new_bod_id			= NULL;
	SET @v_new_route_id			= NULL;
	SET @v_new_etd_date			= NULL;
	SET @v_new_eta_date			= NULL;
	SET @v_new_incoterms		= NULL;
	SET @v_new_transport_mode	= NULL;
	SET @v_new_d_contry			= NULL;
	SET @v_new_d_port_code		= NULL;	
	SET @v_new_a_country		= NULL;	
	SET @v_new_a_port_code		= NULL;	
	SET @v_new_customer_lt		= NULL;
	SET @v_new_to_country		= NULL;	
	SET @v_new_to_city			= NULL;	
	SET @v_remarks				= NULL;
	SET @v_remarks2				= NULL;
	SET @v_remarks3				= NULL;
	SET @v_check_need_yn		= NULL;

	SET @n_division_id				= null;
	SET @n_item_id					= null;
	SET @n_from_site				= null;
	SET @n_to_site					= null;
	SET @n_yyyymmdd					= null;
	SET @n_bod_id					= null;
	SET @n_project_code				= null;
	SET @n_fcst_type				= null;
	SET @n_incoterms				= null;
	SET @n_transport_mode			= null;
	SET @n_confirm_id				= null;
	SET @v_chk = 0

	SET @n_ori_division_id			= null;
	SET @n_ori_item_id				= null;
	SET @n_ori_from_site			= null;
	SET @n_ori_to_site				= null;
	SET @n_ori_yyyymmdd				= null;
	SET @n_ori_bod_id				= null;
	SET @n_ori_project_code			= null;
	SET @n_ori_fcst_type			= null;
	SET @n_ori_incoterms			= null;
	SET @n_ori_transport_mode		= null;
	SET @n_ori_confirm_id			= null;
	SET @v_planned_qty				= 0;
	SET @v_change_req_no			= null;
	SET @v_edit_main				= null;

	SET @v_create_date    = SYSDATETIME();

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SSP0013_SAVE_SHIPMENT_REQUEST_CONFIRM';
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
				SET @v_active_flag		= dbo.SCM_ARR_SPL_VAL( @p_active_flag	    , @v_delimiter, @mst_loop_cnt );
				SET @v_division_id      = dbo.SCM_ARR_SPL_VAL( @p_division_id       , @v_delimiter, @mst_loop_cnt );
				SET @v_confirm_id    = dbo.SCM_ARR_SPL_VAL( @p_confirm_id     , @v_delimiter, @mst_loop_cnt );
				SET @v_shipment_qty    = dbo.SCM_ARR_SPL_VAL( @p_shipment_qty     , @v_delimiter, @mst_loop_cnt );
				SET @v_shipment_date    = dbo.SCM_ARR_SPL_VAL( @p_shipment_date     , @v_delimiter, @mst_loop_cnt );
				SET @v_new_bod_id    = dbo.SCM_ARR_SPL_VAL( @p_new_bod_id     , @v_delimiter, @mst_loop_cnt );
				SET @v_new_etd_date    = dbo.SCM_ARR_SPL_VAL( @p_new_etd_date     , @v_delimiter, @mst_loop_cnt );
				SET @v_new_eta_date    = dbo.SCM_ARR_SPL_VAL( @p_new_eta_date     , @v_delimiter, @mst_loop_cnt );
				SET @v_new_route_id    = dbo.SCM_ARR_SPL_VAL( @p_new_route_id     , @v_delimiter, @mst_loop_cnt );
				SET @v_new_incoterms    = dbo.SCM_ARR_SPL_VAL( @p_new_incoterms     , @v_delimiter, @mst_loop_cnt );
				SET @v_new_transport_mode    = dbo.SCM_ARR_SPL_VAL( @p_new_transport_mode     , @v_delimiter, @mst_loop_cnt );
				SET @v_new_d_contry    = dbo.SCM_ARR_SPL_VAL( @p_new_d_contry     , @v_delimiter, @mst_loop_cnt );
				SET @v_new_d_port_code    = dbo.SCM_ARR_SPL_VAL( @p_new_d_port_code     , @v_delimiter, @mst_loop_cnt );
				SET @v_new_a_country    = dbo.SCM_ARR_SPL_VAL( @p_new_a_country     , @v_delimiter, @mst_loop_cnt );
				SET @v_new_a_port_code    = dbo.SCM_ARR_SPL_VAL( @p_new_a_port_code     , @v_delimiter, @mst_loop_cnt );
				SET @v_new_customer_lt    = dbo.SCM_ARR_SPL_VAL( @p_new_customer_lt     , @v_delimiter, @mst_loop_cnt );
				SET @v_new_to_country    = dbo.SCM_ARR_SPL_VAL( @p_new_to_country     , @v_delimiter, @mst_loop_cnt );
				SET @v_new_to_city    = dbo.SCM_ARR_SPL_VAL( @p_new_to_city     , @v_delimiter, @mst_loop_cnt );
				SET @v_remarks    = dbo.SCM_ARR_SPL_VAL( @p_remarks     , @v_delimiter, @mst_loop_cnt );
				SET @v_remarks2    = dbo.SCM_ARR_SPL_VAL( @p_remarks2     , @v_delimiter, @mst_loop_cnt );
				SET @v_remarks3    = dbo.SCM_ARR_SPL_VAL( @p_remarks3     , @v_delimiter, @mst_loop_cnt );
				SET @v_check_need_yn    = dbo.SCM_ARR_SPL_VAL( @p_check_need_yn     , @v_delimiter, @mst_loop_cnt );
				SET @v_edit_main    = dbo.SCM_ARR_SPL_VAL( @p_edit_main     , @v_delimiter, @mst_loop_cnt );
			END;
			
			SET @v_qty = 0;
			SET @v_before_qty = 0;

			SELECT @v_qty = QTY, @v_before_qty = BEFORE_QTY
			FROM SSP_ANL_SHIP_CONFIRM WITH(NOLOCK)
			WHERE CONFIRM_ID = @v_confirm_id

			IF @v_qty != @v_shipment_qty
				BEGIN
					SET @v_before_qty = @v_qty;
				END
			
			IF ISNULL(@v_shipment_qty, '') = '' OR @v_shipment_qty IS NULL
				BEGIN
					SET @v_shipment_qty = NULL
				END

			IF ISNULL(@v_shipment_date, '') = '' OR @v_shipment_date IS NULL
				BEGIN
					SET @v_shipment_date = ''
				END
			SET @v_new_etd_date = REPLACE(SUBSTRING(@v_new_etd_date,1,10),'-','')
			SET @v_new_eta_date = REPLACE(SUBSTRING(@v_new_eta_date,1,10),'-','')
			SET @v_shipment_date = REPLACE(SUBSTRING(@v_shipment_date,1,10),'-','')

			IF @v_edit_main = 'Y'
				BEGIN
					SET @v_check_need_yn = 'Y'
				END	

			UPDATE SSP_ANL_SHIP_CONFIRM
				SET YYYYMMDD = @v_shipment_date
					,QTY = @v_shipment_qty
					,BEFORE_QTY = @v_before_qty
					,BOD_ID = @v_new_bod_id
					,ROUTE_ID = @v_new_route_id
					,INCOTERMS = @v_new_incoterms
					,D_COUNTRY = @v_new_d_contry
					,D_PORT_CODE = @v_new_d_port_code
					,A_COUNTRY = @v_new_a_country
					,A_PORT_CODE = @v_new_a_port_code
					,TO_COUNTRY = @v_new_to_country
					,TO_CITY = @v_new_to_city
					,TRANSPORT_MODE = @v_new_transport_mode
					,ETD_DATE = @v_new_etd_date
					,ETA_DATE = @v_new_eta_date
					,CUSTOMER_LT = @v_new_customer_lt
					,REMARKS = @v_remarks
					,REMARKS2 = @v_remarks2
					,REMARKS3 = @v_remarks3
					,CHECK_NEED_YN = @v_check_need_yn
					,LAST_UPDATED_BY = @p_user_id
					,LAST_UPDATE_DATE = @v_create_date
			WHERE CONFIRM_ID = @v_confirm_id;

			IF @v_edit_main = 'Y'
				BEGIN
					SELECT @n_division_id = DIVISION_ID
							, @n_item_id = ITEM_ID
							, @n_from_site = FROM_SITE
							, @n_to_site = TO_SITE
							, @n_yyyymmdd = YYYYMMDD
							, @n_bod_id = BOD_ID
							, @n_project_code = PROJECT_CODE
							, @n_fcst_type = FCST_TYPE
							, @n_incoterms = INCOTERMS
							, @n_transport_mode = TRANSPORT_MODE
							, @n_confirm_id = CONFIRM_ID
					FROM SSP_ANL_SHIP_CONFIRM a WITH(NOLOCK)
					WHERE A.CONFIRM_ID = @v_confirm_id
								
					SELECT @v_plan_start_yyyymmdd = MAX(PLAN_START_YYYYMMDD)
							,@v_seq                 = MAX(PLAN_SEQ)
					FROM   SSP_PLAN_VERSION_V WITH(NOLOCK)
					WHERE  PLAN_TYPE    = 'SP'
					AND    DIVISION_ID  = @n_division_id 
					AND    CONFIRM_FLAG = 'Y'
					AND    PLAN_START_YYYYMMDD = (SELECT MAX(PLAN_START_YYYYMMDD)
										FROM SSP_PLAN_VERSION_V T
										WHERE T.DIVISION_ID = @n_division_id 
										AND   T.plan_type  = 'SP'
										AND   T.CONFIRM_FLAG = 'Y');
					
					SET @v_chk = 0;	

					SELECT @v_chk = COUNT(*)
					FROM SSP_ANL_SHIP_PLAN A WITH(NOLOCK)
					WHERE A.DIVISION_ID = @n_division_id
						AND A.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
						AND A.PLAN_TYPE = 'SP'
						AND A.SEQ = @v_seq
						AND A.ITEM_ID = @n_item_id
						AND A.FROM_SITE = @n_from_site
						AND A.TO_SITE = @n_to_site
						AND A.YYYYMMDD = @n_yyyymmdd
						AND MEASURE in ('SHIP_CONFIRM', 'SHIP_PLAN')
						AND A.CONFIRM_FLAG = 'Y'
						;
					 -- SSP_ANL_SHIP_PLAN MEASURE SHIP_PLAN, SHIP_CONFIRM 이 있을 경우 Delete, Insert	 
					IF 	@v_chk > 0 
						BEGIN 										
							DELETE FROM SSP_ANL_SHIP_PLAN
							WHERE DIVISION_ID = @n_division_id
								AND PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
								AND PLAN_TYPE = 'SP'
								AND SEQ = @v_seq
								AND ITEM_ID = @n_item_id
								AND FROM_SITE = @n_from_site
								AND TO_SITE = @n_to_site
								AND YYYYMMDD = @n_yyyymmdd
								AND MEASURE in ('SHIP_CONFIRM', 'SHIP_PLAN')
								AND CONFIRM_FLAG = 'Y' 
								;
						END

					SELECT TOP 1 @n_ori_division_id = DIVISION_ID
							, @n_ori_item_id = ITEM_ID
							, @n_ori_from_site = FROM_SITE
							, @n_ori_to_site = TO_SITE
							, @n_ori_yyyymmdd = YYYYMMDD
							, @n_ori_bod_id = BOD_ID
							, @n_ori_project_code = PROJECT_CODE
							, @n_ori_fcst_type = FCST_TYPE
							, @n_ori_incoterms = INCOTERMS
							, @n_ori_transport_mode = TRANSPORT_MODE
							, @n_ori_confirm_id = CONFIRM_ID
							, @v_change_req_no = CHANGE_REQ_NO
					FROM SSP_ANL_SHIP_CONFIRM_CHG_REQ_de a WITH(NOLOCK)
					WHERE A.CONFIRM_ID = @v_confirm_id
					  AND A.VALID_YN = 'Y'
					ORDER BY LAST_UPDATE_DATE desc;

					SET @v_chk = 0;

					SELECT @v_chk = COUNT(*)
					FROM SSP_ANL_SHIP_PLAN A WITH(NOLOCK)
					WHERE A.DIVISION_ID = @n_ori_division_id
						AND A.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
						AND A.PLAN_TYPE = 'SP'
						AND A.SEQ = @v_seq
						AND A.ITEM_ID = @n_ori_item_id
						AND A.FROM_SITE = @n_ori_from_site
						AND A.TO_SITE = @n_ori_to_site
						AND A.YYYYMMDD = @n_ori_yyyymmdd
						AND MEASURE in ('SHIP_CONFIRM', 'SHIP_PLAN')
						AND A.CONFIRM_FLAG = 'Y' -- Confrim ID가 없는건 삭제하지 않음
						;

					IF 	@v_chk > 0 and @n_yyyymmdd <> @n_ori_yyyymmdd
						BEGIN 										
							DELETE FROM SSP_ANL_SHIP_PLAN
							WHERE DIVISION_ID = @n_ori_division_id
								AND PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
								AND PLAN_TYPE = 'SP'
								AND SEQ = @v_seq
								AND ITEM_ID = @n_ori_item_id
								AND FROM_SITE = @n_ori_from_site
								AND TO_SITE = @n_ori_to_site
								AND YYYYMMDD = @n_ori_yyyymmdd
								AND MEASURE in ('SHIP_CONFIRM', 'SHIP_PLAN')
								AND CONFIRM_FLAG = 'Y' -- Confrim ID가 없는건 삭제하지 않음
								;

								BEGIN
								INSERT INTO SSP_ANL_SHIP_PLAN(
												DIVISION_ID      
												,PLAN_START_YYYYMMDD
												,PLAN_TYPE       
												,SEQ             
												,ITEM_ID         
												,FROM_SITE       
												,TO_SITE         
												,MEASURE         
												,YYYYMMDD        
												,BOD_ID          
												,QTY             
												,ROUTE_ID        
												,INCOTERMS       
												,TRANSPORT_MODE  
												,BIZ_TYPE        
												,PROJECT_CODE    
												,FCST_TYPE       
												,FCST_ETD_DATE   
												,FCST_ETA_DATE   
												,ETD_DATE        
												,ETA_DATE        
												,CONFIRM_FLAG    
												,CONFIRM_ID      
												,CREATED_BY      
												,CREATION_DATE   
												,LAST_UPDATED_BY 
												,LAST_UPDATE_DATE
												,ELECTRODE_YN
												,ELECTRODE_TYPE
												,ORIGIN_FROM_DIVISION_ID
												,ORIGIN_TO_DIVISION_ID)
										SELECT A.DIVISION_ID
												,@v_plan_start_yyyymmdd PLAN_START_YYYYMMDD
												,A.PLAN_TYPE
												,@v_seq SEQ
												,A.ITEM_ID
												,A.FROM_SITE
												,A.TO_SITE
												,'SHIP_CONFIRM' MEASURE
												,YYYYMMDD
												,BOD_ID
												,QTY
												,ROUTE_ID
												,INCOTERMS
												,TRANSPORT_MODE
												,A.BIZ_TYPE
												,A.PROJECT_CODE
												,A.FCST_TYPE
												,A.FCST_ETD_DATE
												,A.FCST_ETA_DATE
												,ETD_DATE
												,ETA_DATE
												,'Y' CONFIRM_FLAG
												,A.CONFIRM_ID CONFIRM_ID
												,@p_user_id CREATED_BY
												,@v_create_date--[dbo].[FN_MULTY_TIME](@p_time_zone) CREATION_DATE
												,@p_user_id LAST_UPDATED_BY
												,@v_create_date--[dbo].[FN_MULTY_TIME](@p_time_zone) LAST_UPDATE_DATE
												,ELECTRODE_YN
												,ELECTRODE_TYPE
												,ORIGIN_FROM_DIVISION_ID
												,ORIGIN_TO_DIVISION_ID
										FROM SSP_ANL_SHIP_CONFIRM A WITH(NOLOCK)
										WHERE A.CONFIRM_ID in (SELECT CONFIRM_ID
															FROM SSP_ANL_SHIP_CONFIRM WITH(NOLOCK)
															WHERE DIVISION_ID = @n_ori_division_id
																AND ITEM_ID = @n_ori_item_id
																AND FROM_SITE = @n_ori_from_site
																AND TO_SITE = @n_ori_to_site
																AND YYYYMMDD = @n_ori_yyyymmdd
																AND CHANGE_TYPE = 'C'
																)
							END

							--MEASURE SHIP_PLAN INSERT
							BEGIN
								INSERT INTO SSP_ANL_SHIP_PLAN(
													DIVISION_ID      
												,PLAN_START_YYYYMMDD
												,PLAN_TYPE       
												,SEQ             
												,ITEM_ID         
												,FROM_SITE       
												,TO_SITE         
												,MEASURE         
												,YYYYMMDD        
												,BOD_ID          
												,QTY             
												,ROUTE_ID        
												,INCOTERMS       
												,TRANSPORT_MODE  
												,BIZ_TYPE        
												,PROJECT_CODE    
												,FCST_TYPE       
												,FCST_ETD_DATE   
												,FCST_ETA_DATE   
												,ETD_DATE        
												,ETA_DATE        
												,CONFIRM_FLAG    
												,CONFIRM_ID      
												,CREATED_BY      
												,CREATION_DATE   
												,LAST_UPDATED_BY 
												,LAST_UPDATE_DATE
												,ELECTRODE_YN
												,ELECTRODE_TYPE
												,ORIGIN_FROM_DIVISION_ID
												,ORIGIN_TO_DIVISION_ID)
										SELECT A.DIVISION_ID
												,@v_plan_start_yyyymmdd PLAN_START_YYYYMMDD
												,A.PLAN_TYPE
												,@v_seq SEQ
												,A.ITEM_ID
												,A.FROM_SITE
												,A.TO_SITE
												,'SHIP_PLAN' MEASURE
												,YYYYMMDD
												,BOD_ID
												,A.PLANNED_QTY QTY
												,ROUTE_ID
												,INCOTERMS
												,TRANSPORT_MODE
												,A.BIZ_TYPE
												,A.PROJECT_CODE
												,A.FCST_TYPE
												,A.FCST_ETD_DATE
												,A.FCST_ETA_DATE
												,ETD_DATE
												,ETA_DATE
												,'Y' CONFIRM_FLAG
												,A.CONFIRM_ID CONFIRM_ID
												,@p_user_id CREATED_BY
												,@v_create_date--[dbo].[FN_MULTY_TIME](@p_time_zone) CREATION_DATE
												,@p_user_id LAST_UPDATED_BY
												,@v_create_date--[dbo].[FN_MULTY_TIME](@p_time_zone) LAST_UPDATE_DATE
												,ELECTRODE_YN
												,ELECTRODE_TYPE
												,ORIGIN_FROM_DIVISION_ID
												,ORIGIN_TO_DIVISION_ID
										FROM SSP_ANL_SHIP_CONFIRM A WITH(NOLOCK)
										WHERE A.CONFIRM_ID in (SELECT CONFIRM_ID
															FROM SSP_ANL_SHIP_CONFIRM WITH(NOLOCK)
															WHERE  DIVISION_ID = @n_ori_division_id
																AND ITEM_ID = @n_ori_item_id
																AND FROM_SITE = @n_ori_from_site
																AND TO_SITE = @n_ori_to_site
																AND YYYYMMDD = @n_ori_yyyymmdd
																AND CHANGE_TYPE = 'C'
																)
							END
						END

					--MEASURE SHIP_CONFIRM INSERT
						BEGIN
							INSERT INTO SSP_ANL_SHIP_PLAN(
											 DIVISION_ID      
											,PLAN_START_YYYYMMDD
											,PLAN_TYPE       
											,SEQ             
											,ITEM_ID         
											,FROM_SITE       
											,TO_SITE         
											,MEASURE         
											,YYYYMMDD        
											,BOD_ID          
											,QTY             
											,ROUTE_ID        
											,INCOTERMS       
											,TRANSPORT_MODE  
											,BIZ_TYPE        
											,PROJECT_CODE    
											,FCST_TYPE       
											,FCST_ETD_DATE   
											,FCST_ETA_DATE   
											,ETD_DATE        
											,ETA_DATE        
											,CONFIRM_FLAG    
											,CONFIRM_ID      
											,CREATED_BY      
											,CREATION_DATE   
											,LAST_UPDATED_BY 
											,LAST_UPDATE_DATE
											,ELECTRODE_YN
											,ELECTRODE_TYPE
											,ORIGIN_FROM_DIVISION_ID
											,ORIGIN_TO_DIVISION_ID)
									SELECT A.DIVISION_ID
											,@v_plan_start_yyyymmdd PLAN_START_YYYYMMDD
											,A.PLAN_TYPE
											,@v_seq SEQ
											,A.ITEM_ID
											,A.FROM_SITE
											,A.TO_SITE
											,'SHIP_CONFIRM' MEASURE
											,YYYYMMDD
											,BOD_ID
											,QTY
											,ROUTE_ID
											,INCOTERMS
											,TRANSPORT_MODE
											,A.BIZ_TYPE
											,A.PROJECT_CODE
											,A.FCST_TYPE
											,A.FCST_ETD_DATE
											,A.FCST_ETA_DATE
											,ETD_DATE
											,ETA_DATE
											,'Y' CONFIRM_FLAG
											,A.CONFIRM_ID CONFIRM_ID
											,@p_user_id CREATED_BY
											,@v_create_date--[dbo].[FN_MULTY_TIME](@p_time_zone) CREATION_DATE
											,@p_user_id LAST_UPDATED_BY
											,@v_create_date--[dbo].[FN_MULTY_TIME](@p_time_zone) LAST_UPDATE_DATE
											,ELECTRODE_YN
											,ELECTRODE_TYPE
											,ORIGIN_FROM_DIVISION_ID
											,ORIGIN_TO_DIVISION_ID
									FROM SSP_ANL_SHIP_CONFIRM A WITH(NOLOCK)
									WHERE A.CONFIRM_ID in (SELECT CONFIRM_ID
														FROM SSP_ANL_SHIP_CONFIRM WITH(NOLOCK)
														WHERE DIVISION_ID = @n_division_id
															AND ITEM_ID = @n_item_id
															AND FROM_SITE = @n_from_site
															AND TO_SITE = @n_to_site
															AND YYYYMMDD = @v_shipment_date
															AND CHANGE_TYPE = 'C'
															)
						END

						--MEASURE SHIP_PLAN INSERT
						BEGIN
							INSERT INTO SSP_ANL_SHIP_PLAN(
												DIVISION_ID      
											,PLAN_START_YYYYMMDD
											,PLAN_TYPE       
											,SEQ             
											,ITEM_ID         
											,FROM_SITE       
											,TO_SITE         
											,MEASURE         
											,YYYYMMDD        
											,BOD_ID          
											,QTY             
											,ROUTE_ID        
											,INCOTERMS       
											,TRANSPORT_MODE  
											,BIZ_TYPE        
											,PROJECT_CODE    
											,FCST_TYPE       
											,FCST_ETD_DATE   
											,FCST_ETA_DATE   
											,ETD_DATE        
											,ETA_DATE        
											,CONFIRM_FLAG    
											,CONFIRM_ID      
											,CREATED_BY      
											,CREATION_DATE   
											,LAST_UPDATED_BY 
											,LAST_UPDATE_DATE
											,ELECTRODE_YN
											,ELECTRODE_TYPE
											,ORIGIN_FROM_DIVISION_ID
											,ORIGIN_TO_DIVISION_ID)
									SELECT A.DIVISION_ID
											,@v_plan_start_yyyymmdd PLAN_START_YYYYMMDD
											,A.PLAN_TYPE
											,@v_seq SEQ
											,A.ITEM_ID
											,A.FROM_SITE
											,A.TO_SITE
											,'SHIP_PLAN' MEASURE
											,YYYYMMDD
											,BOD_ID
											,A.PLANNED_QTY QTY
											,ROUTE_ID
											,INCOTERMS
											,TRANSPORT_MODE
											,A.BIZ_TYPE
											,A.PROJECT_CODE
											,A.FCST_TYPE
											,A.FCST_ETD_DATE
											,A.FCST_ETA_DATE
											,ETD_DATE
											,ETA_DATE
											,'Y' CONFIRM_FLAG
											,A.CONFIRM_ID CONFIRM_ID
											,@p_user_id CREATED_BY
											,@v_create_date--[dbo].[FN_MULTY_TIME](@p_time_zone) CREATION_DATE
											,@p_user_id LAST_UPDATED_BY
											,@v_create_date--[dbo].[FN_MULTY_TIME](@p_time_zone) LAST_UPDATE_DATE
											,ELECTRODE_YN
											,ELECTRODE_TYPE
											,ORIGIN_FROM_DIVISION_ID
											,ORIGIN_TO_DIVISION_ID
									FROM SSP_ANL_SHIP_CONFIRM A WITH(NOLOCK)
									WHERE A.CONFIRM_ID in (SELECT CONFIRM_ID
														FROM SSP_ANL_SHIP_CONFIRM WITH(NOLOCK)
														WHERE DIVISION_ID = @n_division_id
															AND ITEM_ID = @n_item_id
															AND FROM_SITE = @n_from_site
															AND TO_SITE = @n_to_site
															AND YYYYMMDD = @v_shipment_date
															AND CHANGE_TYPE = 'C'
															)
						END
				
					SELECT @v_yyyymmdd = yyyymmdd
					FROM(
						SELECT top 1 case when YYYYMMDD > NEW_YYYYMMDD then NEW_YYYYMMDD else YYYYMMDD end yyyymmdd
						FROM SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE with(nolock)
						WHERE CONFIRM_ID = @v_confirm_id
						ORDER BY YYYYMMDD, NEW_YYYYMMDD
					) a

					EXEC PR_SSP_ANL_SHIP_UPDATE_BOH_VAL @v_division_id, @n_item_id, @n_from_site, @v_yyyymmdd, @v_create_date
				
				END
				IF len(@v_change_req_no) > 0
				BEGIN
					--이력저장
					EXEC [dbo].[PR_SSP_ANL_SHIP_CONFIRM_HIST] @v_change_req_no,@p_user_id,''
					;
					SELECT @Mail_CHK = COUNT(*) FROM SSP_MST_SEND_MAIL_REQ WHERE CHANGE_REQ_NO = @v_change_req_no;
					IF @Mail_CHK = 0
					BEGIN
					--메일전송
						INSERT INTO SSP_MST_SEND_MAIL_REQ (CHANGE_REQ_NO, TRANSFER_FLAG, GRP_CHANGE_REQ)
						VALUES (@v_change_req_no, 'N', @v_grp_change_req);

						SET @Mail_Flag = 1;
					END;
				END;
		END;

		IF @Mail_Flag = 1
		BEGIN	
			EXEC [dbo].[PR_SSP_MAIL_SEND_ADJUST_MST] @v_grp_change_req
		END;
		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		
		-- 결과코드, 결과 카운트 반환
		SELECT  'S' AS result_code,  @max_loop_cnt AS result_cnt, isnull(@v_change_req_no,'') AS change_req_no;
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

