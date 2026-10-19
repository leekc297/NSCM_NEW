

/*
 * Program ID   : SSP0013_SAVE_SHIPMENT_REQUEST_DRAFTING
 * Description  : Shipment Plan Change 작성중 저장
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/10/10   ygkim          Initial Release [PJ20182279] 전지본부 출하계획 시스템 구축 프로젝트
 * 2019/04/03	AYJ				[PJ20189106] 전지.GSCM 고도화 이행  REMARKS, REMARKS 컬럼 추가
 * 2019/04/30	AYJ				[PJ20189106] 전지.GSCM 고도화 이행  REQUESTOR 컬럼 변경
 * 2019/05/07	AYJ				[PJ20189106] 전지.GSCM 고도화 이행  REMARKS3 컬럼 추가
 */

CREATE PROCEDURE [dbo].[SSP0013_SAVE_SHIPMENT_REQUEST_DRAFTING_Backup]
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
	,@p_edit_main			NVARCHAR(MAX)
	,@p_edit_remark			NVARCHAR(MAX)
	,@p_user_id				NVARCHAR(MAX)
	,@p_user_dept_id		NVARCHAR(MAX)
	,@p_electrode_yn		NVARCHAR(MAX) = ''
	,@p_electrode_type		NVARCHAR(MAX) = ''
	,@p_origin_from_division_id     NVARCHAR(MAX) = ''
	,@p_origion_to_division_id		NVARCHAR(MAX) = ''

	,@p_remarks				NVARCHAR(MAX)
	,@p_remarks2			NVARCHAR(MAX)
	,@p_remarks3			NVARCHAR(MAX)
AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @recv_active_flag		NVARCHAR(MAX);
	SET @recv_active_flag = NULL;		
	SET @recv_active_flag = @p_active_flag;

	DECLARE @v_max_req_no	NVARCHAR(40);

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
	DECLARE @v_edit_main			NVARCHAR(MAX)
	DECLARE @v_edit_remark			NVARCHAR(MAX)
	DECLARE @v_create_date			DATETIME;
	DECLARE @v_chk					INT
	DECLARE @v_title				NVARCHAR(MAX)
	DECLARE @v_change_reason_code	NVARCHAR(MAX)
	DECLARE @v_change_reason_detail	NVARCHAR(MAX)

	DECLARE @v_electrode_yn				NVARCHAR(MAX)
	DECLARE @v_electrode_type			NVARCHAR(MAX)
	DECLARE @v_origin_from_division_id	NVARCHAR(MAX)
	DECLARE @v_origion_to_division_id	NVARCHAR(MAX)

	DECLARE @v_remarks				NVARCHAR(MAX)
	DECLARE @v_remarks2				NVARCHAR(MAX)
	DECLARE @v_remarks3				NVARCHAR(MAX)

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
	SET @v_edit_main			= NULL;	
	SET @v_edit_remark			= NULL;	
	SET @v_chk					= 0;

	SET @v_electrode_yn				= NULL;	
	SET @v_electrode_type			= NULL;	
	SET @v_origin_from_division_id	= NULL;	
	SET @v_origion_to_division_id	= NULL;	

	SET @v_remarks				= NULL;
	SET @v_remarks2				= NULL;
	SET @v_remarks3				= NULL;

	SET @v_title				= N'Change on the Shipment Plan Adjustment screen';	
	SET @v_change_reason_code	= 'C00';	
	SET @v_change_reason_detail	= N'change on the Shipment Plan Adjustment screen';	

	SET @v_create_date    = SYSDATETIME();

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SSP0013_SAVE_SHIPMENT_REQUEST_DRAFTING';
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
				SET @v_edit_main    = dbo.SCM_ARR_SPL_VAL( @p_edit_main     , @v_delimiter, @mst_loop_cnt );
				SET @v_edit_remark    = dbo.SCM_ARR_SPL_VAL( @p_edit_remark     , @v_delimiter, @mst_loop_cnt );

				SET @v_electrode_yn    = dbo.SCM_ARR_SPL_VAL( @p_electrode_yn     , @v_delimiter, @mst_loop_cnt );
				SET @v_electrode_type    = dbo.SCM_ARR_SPL_VAL( @p_electrode_type     , @v_delimiter, @mst_loop_cnt );
				SET @v_origin_from_division_id    = dbo.SCM_ARR_SPL_VAL( @p_origin_from_division_id     , @v_delimiter, @mst_loop_cnt );
				SET @v_origion_to_division_id    = dbo.SCM_ARR_SPL_VAL( @p_origion_to_division_id     , @v_delimiter, @mst_loop_cnt );

				SET @v_remarks    = dbo.SCM_ARR_SPL_VAL( @p_remarks     , @v_delimiter, @mst_loop_cnt );
				SET @v_remarks2    = dbo.SCM_ARR_SPL_VAL( @p_remarks2     , @v_delimiter, @mst_loop_cnt );
				SET @v_remarks3    = dbo.SCM_ARR_SPL_VAL( @p_remarks3     , @v_delimiter, @mst_loop_cnt );

			END;

			IF @v_edit_main = 'Y'
				BEGIN
					IF @v_chk = 0
						BEGIN
							SET @v_max_req_no = 'R'+CONVERT(VARCHAR(8), @v_create_date, 112) + RIGHT('000000' + CONVERT(NVARCHAR, NEXT VALUE FOR SEQ1_SSP_ANL_SHIP_CHG_REQ_NO),6)
							
							INSERT INTO SSP_ANL_SHIP_CONFIRM_CHG_REQ
									(CHANGE_REQ_NO
									,CHANGE_TYPE
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
								  , 'A'
								  , 'A'
								  , @v_division_id
								  , '-'
								  , @v_title
								  , @p_user_id
								  , @p_user_dept_id
								  , @v_create_date
								  , @p_user_id
								  , @p_user_dept_id
								  , @v_create_date
								  , @v_change_reason_code
								  , @v_change_reason_detail
								  , NULL
								  ,'Y'
								  , @p_user_id
								  , @v_create_date--[dbo].[FN_MULTY_TIME](@p_time_zone)
								  , @p_user_id
								  , @v_create_date--[dbo].[FN_MULTY_TIME](@p_time_zone)
								  , @v_electrode_yn
								  , @v_electrode_type
								  , @v_origin_from_division_id
								  , @v_origion_to_division_id
							);
							SET @v_chk = 1;
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
							)
							SELECT @v_max_req_no CHANGE_REQ_NO
									,CONFIRM_ID
									,'N' NEW_YN
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
									,@v_shipment_date NEW_YYYYMMDD
									,@v_shipment_qty NEW_QTY
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
									,@v_new_customer_lt NEW_CUSTOMER_LT
									,@v_new_to_country NEW_TO_COUNTRY
									,@v_new_to_city NEW_TO_CITY 	
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
									,'Y'
									,'N'
									,@p_user_id CREATED_BY
									,@v_create_date--[dbo].[FN_MULTY_TIME](@p_time_zone) CREATION_DATE
									,@p_user_id LAST_UPDATED_BY
									,@v_create_date--[dbo].[FN_MULTY_TIME](@p_time_zone) LAST_UPDATE_DATE
									,ELECTRODE_YN
									,ELECTRODE_TYPE
									,ORIGIN_FROM_DIVISION_ID
									,ORIGIN_TO_DIVISION_ID
									,@v_remarks
									,@v_remarks2
									,@v_remarks3
									,REQUESTOR
								FROM SSP_ANL_SHIP_CONFIRM A
								WHERE CONFIRM_ID = @v_confirm_id;
					
				END
		END

		IF @v_chk > 0 
			BEGIN
				--출하확정변경시 ERP 전송 이터 테이블 저장 B: 변경확정
				EXEC PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH 'B', @v_max_req_no
			END

		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
					
		-- 결과코드, 결과 카운트 반환
		SELECT  'S' AS result_code, @v_max_req_no Request_no ;
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

