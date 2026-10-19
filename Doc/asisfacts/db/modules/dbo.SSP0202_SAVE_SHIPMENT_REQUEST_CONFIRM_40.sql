




/*
 * Program ID   : SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_40
 * Description  : Shipment Change Request Confirm Save_40
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2019/03/19   AYJ            Initial Release [PJ20182279] 전지본부 출하계획 시스템 구축 프로젝트
 * 2019/07/15	mcTheJ		   [CSR ID:4044806] Model PIC 담당자 위임 기능 추가 - 위임자 결재 추가
 * 2019/10/29	ayj			   FCST_ETA_DATE, ETA_DATE 저장 값 수정(출발일 기준 항차를 고려한 ETA_DATE 계산)
 * 2021/01/07   KIMYONGHO      [C20201223-000448] MKT FCST - SSP Sync
 * 2021/01/12   KIMYONGHO       [C20201223-000448] MKT FCST - SSP Sync 운영이관 검증 단계에서 처리 지연 현상으로 END LOG 이후 호출로 조정함.
 * 2021/01/12   KIMYONGHO       [C20201223-000448] MKT FCST - SSP Sync CONFIRM_ID parameter 변경
 * 2021/04/08   KIMYONGHO       [C20210406-000222] MKT FCST - SSP Sync DIVISION_ID parameter 변경
 */

CREATE PROCEDURE [dbo].[SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM_40]
	 @p_change_request_no	NVARCHAR(MAX)
	,@p_change_status		NVARCHAR(MAX)
	,@p_reject_reason		NVARCHAR(MAX)

	,@p_division_id			NVARCHAR(MAX)
	,@p_item_id				NVARCHAR(MAX)
	,@p_from_site			NVARCHAR(MAX)
	,@p_yyyymmdd			NVARCHAR(MAX)

	,@p_confirm_id			NVARCHAR(MAX)
	,@p_new_confirm_id		NVARCHAR(MAX)
	,@p_new_etd_date		NVARCHAR(MAX)
	,@p_new_eta_date		NVARCHAR(MAX)
	,@p_new_qty				NVARCHAR(MAX)
	,@p_new_ship_date		NVARCHAR(MAX)
	,@p_new_yn				NVARCHAR(MAX)

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
	,@p_new_transport_mode	NVARCHAR(MAX)

	,@p_last_updated_by		NVARCHAR(MAX)
	,@p_time_zone			NVARCHAR(MAX)
	,@p_change_type			NVARCHAR(MAX)

	,@p_remarks				NVARCHAR(MAX)
	,@p_remarks2			NVARCHAR(MAX)
	,@p_remarks3			NVARCHAR(MAX)

	,@p_delegatee			NVARCHAR(MAX)
	,@p_delegatee_dept		NVARCHAR(MAX)
	,@p_shipto_code			NVARCHAR(MAX)
AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @v_division_id			NVARCHAR(MAX)
	DECLARE @v_confirm_id			NVARCHAR(MAX)
	DECLARE @v_new_confirm_id		NVARCHAR(MAX)
	DECLARE @v_new_etd_date			NVARCHAR(MAX)
	DECLARE @v_new_eta_date			NVARCHAR(MAX)
	DECLARE @v_new_qty				NVARCHAR(MAX)
	DECLARE @v_new_ship_date		NVARCHAR(MAX)
	DECLARE @v_new_yn				NVARCHAR(MAX)

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
	DECLARE @v_new_transport_mode	NVARCHAR(MAX);

	DECLARE @n_division_id			NVARCHAR(MAX);
	DECLARE @n_plan_start_yyyymmdd	NVARCHAR(MAX);
	DECLARE @n_plan_type			NVARCHAR(MAX);
	DECLARE @n_seq					NVARCHAR(MAX);
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
	DECLARE @n_max_seq				NVARCHAR(MAX);
	DECLARE @n_last_update_date		NVARCHAR(MAX);
	DECLARE @v_plan_start_yyyymmdd  NVARCHAR(MAX);
	DECLARE @v_seq					NVARCHAR(MAX);

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

	DECLARE @v_chk					INT
	DECLARE @v_last_update_date     datetime;

	DECLARE @v_remarks					NVARCHAR(MAX);
	DECLARE @v_remarks2					NVARCHAR(MAX);
	DECLARE @v_remarks3					NVARCHAR(MAX);

	DECLARE @v_shipto_code		    NVARCHAR(MAX);

	DECLARE @IF_GROUP_NO				 [NVARCHAR](50)   = FORMAT(CURRENT_TIMESTAMP, 'yyyyMMddHHmmss');

	SET @v_confirm_id = null
	SET @v_confirm_id = null
	SET @v_new_confirm_id = null
	SET @v_new_etd_date = null
	SET @v_new_eta_date = null
	SET @v_new_qty = null
	SET @v_new_ship_date = null
	SET @v_new_yn = null

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
	SET @v_new_transport_mode = NULL;

	SET @n_division_id				= null;
	SET @n_plan_start_yyyymmdd		= null;
	SET @n_plan_type				= null;
	SET @n_seq						= null;
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
	SET @n_max_seq					= null;
	SET @n_last_update_date			= null;
	SET @v_last_update_date    = SYSDATETIME();

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

	SET @v_remarks					= null;
	SET @v_remarks2					= null;
	SET @v_remarks3					= null;

	SET @v_shipto_code				= null;

	
	SET @v_chk = 0
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_40';
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


		BEGIN
			IF LEN(ISNULL(@p_delegatee, '')) = 0
			BEGIN
				UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ
				   SET CHANGE_REQ_STATUS = @p_change_status
					  ,APPROVAL_TIME = @v_last_update_date--[dbo].[FN_MULTY_TIME](@p_time_zone)
					  ,REJECT_REASON = @p_reject_reason
					  ,LAST_UPDATED_BY = @p_last_updated_by
					  ,LAST_UPDATE_DATE = @v_last_update_date--[dbo].[FN_MULTY_TIME](@p_time_zone)
				WHERE CHANGE_REQ_NO = @p_change_request_no;
			END
			ELSE
			BEGIN
				UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ
				   SET CHANGE_REQ_STATUS = @p_change_status
					  ,APPROVAL_TIME = @v_last_update_date--[dbo].[FN_MULTY_TIME](@p_time_zone)
					  ,REJECT_REASON = @p_reject_reason
					  ,DELEGATEE_USER = @p_delegatee
					  ,DELEGATEE_DEPT = @p_delegatee_dept
					  ,LAST_UPDATED_BY = @p_last_updated_by
					  ,LAST_UPDATE_DATE = @v_last_update_date--[dbo].[FN_MULTY_TIME](@p_time_zone)
				WHERE CHANGE_REQ_NO = @p_change_request_no;
			END

			
		END

		IF @p_change_status = 'A'
			BEGIN
				SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_confirm_id, @v_delimiter);    
				--SELECT    @max_loop_cnt;
				--	WHILE LEN(@p_active_flag) > 0
				WHILE LEN(@p_confirm_id) > 0 AND @mst_loop_cnt < @max_loop_cnt
				BEGIN
					SET @mst_loop_cnt = @mst_loop_cnt + 1;

					BEGIN  
						SET @v_division_id = [dbo].[SCM_ARR_SPL_VAL](@p_division_id, @v_delimiter , @mst_loop_cnt) ;  
						SET @v_confirm_id = [dbo].[SCM_ARR_SPL_VAL](@p_confirm_id, @v_delimiter , @mst_loop_cnt) ;  
						SET @v_new_confirm_id = [dbo].[SCM_ARR_SPL_VAL](@p_new_confirm_id, @v_delimiter , @mst_loop_cnt) ;  
						SET @v_new_etd_date = [dbo].[SCM_ARR_SPL_VAL](@p_new_etd_date, @v_delimiter , @mst_loop_cnt) ;  
						SET @v_new_eta_date = [dbo].[SCM_ARR_SPL_VAL](@p_new_eta_date, @v_delimiter , @mst_loop_cnt) ;  
						SET @v_new_qty = [dbo].[SCM_ARR_SPL_VAL](@p_new_qty, @v_delimiter , @mst_loop_cnt) ;  
						SET @v_new_ship_date = [dbo].[SCM_ARR_SPL_VAL](@p_new_ship_date, @v_delimiter , @mst_loop_cnt) ; 
						SET @v_new_yn = [dbo].[SCM_ARR_SPL_VAL](@p_new_yn, @v_delimiter , @mst_loop_cnt) ; 

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
						SET @v_new_transport_mode = [dbo].[SCM_ARR_SPL_VAL](@p_new_transport_mode, @v_delimiter , @mst_loop_cnt) ; 

						SET @v_remarks = [dbo].[SCM_ARR_SPL_VAL](@p_remarks, @v_delimiter , @mst_loop_cnt) ; 
						SET @v_remarks2 = [dbo].[SCM_ARR_SPL_VAL](@p_remarks2, @v_delimiter , @mst_loop_cnt) ; 
						SET @v_remarks3 = [dbo].[SCM_ARR_SPL_VAL](@p_remarks3, @v_delimiter , @mst_loop_cnt) ; 
						SET @v_shipto_code   = dbo.SCM_ARR_SPL_VAL( @p_shipto_code     , @v_delimiter, @mst_loop_cnt );
					END
			
					IF @mst_loop_cnt > 0 
						BEGIN
							SET @v_new_etd_date = REPLACE(SUBSTRING(@v_new_etd_date,1,10),'-','')
							--SET @v_new_eta_date = REPLACE(SUBSTRING(@v_new_eta_date,1,10),'-','')
							SET @v_new_ship_date = REPLACE(SUBSTRING(@v_new_ship_date,1,10),'-','')

							/* 2019.10.29 출발일 기준 항차를 고려한 ETA_DATE 계산*/
							--2021.04.08 [C20210406-000222]  @P_division_id - > @v_division_id
							SET @v_new_eta_date = [dbo].[FN_GET_SSP_ETA_DATE](@v_division_id, @v_new_bod_id, @v_new_ship_date) 
							
							SET @v_chk = 0;	
																			
							IF @v_new_yn = 'Y'
								BEGIN
									-- SSP0200 에서 사용 시  @p_change_type = 'N' 변경
									SET @p_change_type ='N'; 
									IF @p_change_type = 'C'
										BEGIN
										--SSP_ANL_SHIP_CONFIRM table insert
										INSERT INTO SSP_ANL_SHIP_CONFIRM(
												CONFIRM_ID
												,SHIPMENT_STATUS
												,DIVISION_ID
												,PLAN_START_YYYYMMDD
												,PLAN_TYPE
												,SEQ
												,ITEM_ID
												,FROM_SITE
												,TO_SITE
												,YYYYMMDD
												,PLANNED_QTY
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
												,CHANGE_REQ_NO
												,ERP_SO_NO			--신규 일 경우에는 ERP 4개 컬럼 NULL로 넣어준다.
												,ERP_SO_ITEM_NO
												,ERP_DO_NO
												,ERP_STATUS
												,CHANGE_TYPE
												,CREATED_BY
												,CREATION_DATE
												,LAST_UPDATED_BY
												,LAST_UPDATE_DATE
												,ELECTRODE_YN
												,ELECTRODE_TYPE
												,ORIGIN_FROM_DIVISION_ID
												,ORIGIN_TO_DIVISION_ID
												,BEFORE_QTY
												,CHECK_NEED_YN
												,REMARKS
												,REMARKS2
												,REMARKS3
												/*----------------------------------------------------------------------------------------
													2020.06.30 : KBK
													I/F 추가요청으로 인하여 컬럼 추가 전극에서만 사용. DDL 표준을 맞추기 위하여 추가함 
												------------------------------------------------------------------------------------------*/
												,PACKAGE_TYPE_CODE
												,FACTORY_ID
												,PACKAGE_QTY
												,DOM_EXP
												,ERP_ATTR1
												,ERP_ATTR2
												,ERP_ATTR3
												,ERP_ATTR4
												,ERP_ATTR5
										) SELECT @v_new_confirm_id CONFIRM_ID
												,'C' SHIPMENT_STATUS
												,A.DIVISION_ID
												,A.PLAN_START_YYYYMMDD
												,A.PLAN_TYPE
												,A.SEQ
												,A.ITEM_ID
												,A.FROM_SITE
												,A.TO_SITE
												,@v_new_ship_date YYYYMMDD
												,0 PLANNED_QTY
												,@v_new_qty QTY
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
												,TO_SITE_SHIPTO_CODE as TO_SITE_SHIPTO_CODE -- A.TO_SITE_SHIPTO_CODE
												,A.TO_SITE_COMPANY_ID
												,null CHANGE_REQ_NO
												,null ERP_SO_NO			--신규 일 경우에는 ERP 4개 컬럼 NULL로 넣어준다.
												,null ERP_SO_ITEM_NO
												,null ERP_DO_NO
												,null ERP_STATUS
												,'C'
												,@p_last_updated_by CREATED_BY
												,@v_last_update_date--[dbo].[FN_MULTY_TIME](@p_time_zone) CREATION_DATE
												,@p_last_updated_by LAST_UPDATED_BY
												,@v_last_update_date--[dbo].[FN_MULTY_TIME](@p_time_zone) LAST_UPDATE_DATE
												,A.ELECTRODE_YN
												,A.ELECTRODE_TYPE
												,A.ORIGIN_FROM_DIVISION_ID
												,A.ORIGIN_TO_DIVISION_ID
												,0 BEFORE_QTY
												,'Y' CHECK_NEED_YN
												,@v_remarks
												,@v_remarks2
												,@v_remarks3
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
											FROM SSP_ANL_SHIP_CONFIRM A  with(nolock)
												LEFT OUTER JOIN SSP_MST_SITE_ITEM_EE_V B with(nolock)
													ON  B.DIVISION_ID = A.DIVISION_ID 
													AND B.SCM_SITE_ID = A.FROM_SITE 
													AND B.ITEM_ID     = A.ITEM_ID 
											WHERE CONFIRM_ID = @v_confirm_id;
										END
									ELSE IF @p_change_type = 'N'
										BEGIN	
											SET @v_chk = 0;
											SELECT @v_chk = count(*)
											FROM SSP_ANL_SHIP_CONFIRM with(nolock)
											WHERE CONFIRM_ID = @v_new_confirm_id;

											IF @v_chk > 0
												BEGIN
													UPDATE SSP_ANL_SHIP_CONFIRM
														SET CHANGE_TYPE = 'C'
															,SHIPMENT_STATUS = 'C'
															,CHANGE_REQ_NO = null
															,YYYYMMDD = @v_new_ship_date
															,QTY = @v_new_qty
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
															,CUSTOMER_LT = @v_new_lt_day
															,BEFORE_QTY = 0
															,CHECK_NEED_YN = 'Y'
															,LAST_UPDATED_BY = @p_last_updated_by
															,LAST_UPDATE_DATE = @v_last_update_date--[dbo].[FN_MULTY_TIME](@p_time_zone)
															,REMARKS		= @v_remarks
															,REMARKS2		= @v_remarks2
															,REMARKS3		= @v_remarks3
															,TO_SITE_SHIPTO_CODE = @v_shipto_code
															/*----------------------------------------------------------------------------------------
																2020.06.30 : KBK
																I/F 추가요청으로 인하여 컬럼 추가 전극에서만 사용. DDL 표준을 맞추기 위하여 추가함 
															------------------------------------------------------------------------------------------*/
															,PACKAGE_QTY = CASE WHEN A.ELECTRODE_YN = 'N' THEN @v_new_qty
																			 ELSE CEILING(CASE WHEN B.PACKAGE_TYPE_CODE = 'BX' THEN CEILING(@v_new_qty * isnull(B.CONVERT_TO_PC_ROLL_LENGTH ,1) ) * isnull(B.BOX_PER_CUT ,1)
 																								WHEN B.PACKAGE_TYPE_CODE = 'SC' THEN CEILING(@v_new_qty * isnull(B.CONVERT_TO_PC_ROLL_LENGTH ,1) ) * isnull(B.STEELCRATE_PER_CUT ,1)
 																								WHEN B.PACKAGE_TYPE_CODE = 'SR' THEN CEILING(@v_new_qty * isnull(B.CONVERT_TO_PC_ROLL_LENGTH ,1) ) * isnull(B.STEELRACK_PER_CUT ,1)
 																							ELSE NULL  END) END
													FROM SSP_ANL_SHIP_CONFIRM A with(nolock) 
													LEFT OUTER JOIN SSP_MST_SITE_ITEM_EE_V B with(nolock)
														ON  B.DIVISION_ID = A.DIVISION_ID 
														AND B.SCM_SITE_ID = A.FROM_SITE 
														AND B.ITEM_ID     = A.ITEM_ID 
													WHERE CONFIRM_ID = @v_new_confirm_id
												END
											ELSE
												BEGIN
													INSERT INTO SSP_ANL_SHIP_CONFIRM(
															CONFIRM_ID
															,SHIPMENT_STATUS
															,DIVISION_ID
															,PLAN_START_YYYYMMDD
															,PLAN_TYPE
															,SEQ
															,ITEM_ID
															,FROM_SITE
															,TO_SITE
															,YYYYMMDD
															,PLANNED_QTY
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
															,CHANGE_REQ_NO
															,ERP_SO_NO			--신규 일 경우에는 ERP 4개 컬럼 NULL로 넣어준다.
															,ERP_SO_ITEM_NO
															,ERP_DO_NO
															,ERP_STATUS
															,CHANGE_TYPE
															,CREATED_BY
															,CREATION_DATE
															,LAST_UPDATED_BY
															,LAST_UPDATE_DATE
															,ELECTRODE_YN
															,ELECTRODE_TYPE
															,ORIGIN_FROM_DIVISION_ID
															,ORIGIN_TO_DIVISION_ID
															,BEFORE_QTY
															,CHECK_NEED_YN
															,REMARKS
															,REMARKS2
															,REMARKS3
															/*----------------------------------------------------------------------------------------
																2020.06.30 : KBK
																I/F 추가요청으로 인하여 컬럼 추가 전극에서만 사용. DDL 표준을 맞추기 위하여 추가함 
															------------------------------------------------------------------------------------------*/
															,PACKAGE_TYPE_CODE
															,FACTORY_ID
															,PACKAGE_QTY
															,DOM_EXP
															,ERP_ATTR1
															,ERP_ATTR2
															,ERP_ATTR3
															,ERP_ATTR4
															,ERP_ATTR5
													) SELECT @v_new_confirm_id CONFIRM_ID
															,'C' SHIPMENT_STATUS
															,A.DIVISION_ID
															,A.PLAN_START_YYYYMMDD
															,A.PLAN_TYPE
															,A.SEQ
															,A.ITEM_ID
															,A.FROM_SITE
															,A.TO_SITE
															,@v_new_ship_date YYYYMMDD
															,0 PLANNED_QTY
															,@v_new_qty QTY
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
															,null CHANGE_REQ_NO
															,null ERP_SO_NO			--신규 일 경우에는 ERP 4개 컬럼 NULL로 넣어준다.
															,null ERP_SO_ITEM_NO
															,null ERP_DO_NO
															,null ERP_STATUS
															,'C'
															,@p_last_updated_by CREATED_BY
															,@v_last_update_date--[dbo].[FN_MULTY_TIME](@p_time_zone) CREATION_DATE
															,@p_last_updated_by LAST_UPDATED_BY
															,@v_last_update_date--[dbo].[FN_MULTY_TIME](@p_time_zone) LAST_UPDATE_DATE
															,A.ELECTRODE_YN
															,A.ELECTRODE_TYPE
															,A.ORIGIN_FROM_DIVISION_ID
															,A.ORIGIN_TO_DIVISION_ID
															,0 BEFORE_QTY
															,'Y' CHECK_NEED_YN
															,@v_remarks
															,@v_remarks2
															,@v_remarks3
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
														FROM SSP_ANL_SHIP_CONFIRM A  with(nolock)
															LEFT OUTER JOIN SSP_MST_SITE_ITEM_EE_V B with(nolock)
																ON  B.DIVISION_ID = A.DIVISION_ID 
																AND B.SCM_SITE_ID = A.FROM_SITE 
																AND B.ITEM_ID     = A.ITEM_ID 
														WHERE CONFIRM_ID = @v_confirm_id;
												END
												-- SSP0200 에서 사용 시  @p_change_type = 'N' 변경 후 다시 'C' 변경
												SET @p_change_type ='c'; 
										END									
									ELSE
										BEGIN
										
										SET @v_planned_qty = 0;

										SELECT @v_planned_qty = PLANNED_QTY
										FROM SSP_ANL_SHIP_CONFIRM WITH(NOLOCK)
										WHERE ATTRIBUTE1 = @v_new_confirm_id;										  
											
											--SSP_ANL_SHIP_CONFIRM table insert
										INSERT INTO SSP_ANL_SHIP_CONFIRM(
												CONFIRM_ID
												,SHIPMENT_STATUS
												,DIVISION_ID
												,PLAN_START_YYYYMMDD
												,PLAN_TYPE
												,SEQ
												,ITEM_ID
												,FROM_SITE
												,TO_SITE
												,YYYYMMDD
												,PLANNED_QTY
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
												,CHANGE_REQ_NO
												,ERP_SO_NO			--신규 일 경우에는 ERP 4개 컬럼 NULL로 넣어준다.
												,ERP_SO_ITEM_NO
												,ERP_DO_NO
												,ERP_STATUS
												,CHANGE_TYPE
												,CREATED_BY
												,CREATION_DATE
												,LAST_UPDATED_BY
												,LAST_UPDATE_DATE
												,ELECTRODE_YN
												,ELECTRODE_TYPE
												,ORIGIN_FROM_DIVISION_ID
												,ORIGIN_TO_DIVISION_ID
												,BEFORE_QTY
												,CHECK_NEED_YN
												,REMARKS
												,REMARKS2
												,REMARKS3
												/*----------------------------------------------------------------------------------------
													2020.06.30 : KBK
													I/F 추가요청으로 인하여 컬럼 추가 전극에서만 사용. DDL 표준을 맞추기 위하여 추가함 
												------------------------------------------------------------------------------------------*/
												,PACKAGE_TYPE_CODE
												,FACTORY_ID
												,PACKAGE_QTY
												,DOM_EXP
												,ERP_ATTR1
												,ERP_ATTR2
												,ERP_ATTR3
												,ERP_ATTR4
												,ERP_ATTR5
										) SELECT @v_new_confirm_id CONFIRM_ID
												,'C' SHIPMENT_STATUS
												,A.DIVISION_ID
												,A.PLAN_START_YYYYMMDD
												,A.PLAN_TYPE
												,A.SEQ
												,A.ITEM_ID
												,A.FROM_SITE
												,A.TO_SITE
												,@v_new_ship_date YYYYMMDD
												,@v_planned_qty PLANNED_QTY
												,@v_new_qty QTY
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
												,A.FROM_SITE_TYPE
												,A.FROM_SITE_PLANT_ID
												,A.FROM_SITE_VENDOR_ID
												,A.FROM_SITE_SOLDTO_CODE
												,A.FROM_SITE_SHIPTO_CODE
												,A.FROM_SITE_COMPANY_ID
												,TO_SITE_TYPE
												,A.TO_SITE_PLANT_ID
												,A.TO_SITE_VENDOR_ID
												,A.TO_SITE_SOLDTO_CODE
												,TO_SITE_SHIPTO_CODE AS TO_SITE_SHIPTO_CODE --A.TO_SITE_SHIPTO_CODE
												,A.TO_SITE_COMPANY_ID
												,null CHANGE_REQ_NO
												,null ERP_SO_NO
												,null ERP_SO_ITEM_NO
												,null ERP_DO_NO
												,null ERP_STATUS
												,'C'
												,@p_last_updated_by CREATED_BY
												,@v_last_update_date--[dbo].[FN_MULTY_TIME](@p_time_zone) CREATION_DATE
												,@p_last_updated_by LAST_UPDATED_BY
												,@v_last_update_date--[dbo].[FN_MULTY_TIME](@p_time_zone) LAST_UPDATE_DATE
												,A.ELECTRODE_YN
												,A.ELECTRODE_TYPE
												,A.ORIGIN_FROM_DIVISION_ID
												,A.ORIGIN_TO_DIVISION_ID
												,A.QTY BEFORE_QTY
												,'Y' CHECK_NEED_YN
												,@v_remarks
												,@v_remarks2
												,@v_remarks3
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
											FROM SSP_ANL_SHIP_CONFIRM  A with(nolock)
												LEFT OUTER JOIN SSP_MST_SITE_ITEM_EE_V B with(nolock)
													ON  B.DIVISION_ID = A.DIVISION_ID 
													AND B.SCM_SITE_ID = A.FROM_SITE 
													AND B.ITEM_ID     = A.ITEM_ID 
											WHERE ATTRIBUTE1 = @v_confirm_id;

											UPDATE SSP_ANL_SHIP_CONFIRM
												SET SHIPMENT_STATUS = 'P'
													,CHANGE_REQ_NO = null
													,QTY = 0
													,BEFORE_QTY = QTY
													,CHECK_NEED_YN = 'Y'
													,LAST_UPDATED_BY = @p_last_updated_by
													,LAST_UPDATE_DATE = @v_last_update_date--[dbo].[FN_MULTY_TIME](@p_time_zone)
													,PACKAGE_QTY = 0
											WHERE ATTRIBUTE1 = @v_new_confirm_id
										END
								END						
							ELSE
								BEGIN
									--SSP_ANL_SHIP_CONFIRM update
									UPDATE SSP_ANL_SHIP_CONFIRM
										SET SHIPMENT_STATUS = 'C'
											,CHANGE_REQ_NO = null
											,YYYYMMDD = @v_new_ship_date
											,QTY = @v_new_qty
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
											,FCST_ETD_DATE = @v_new_etd_date
											,FCST_ETA_DATE = @v_new_eta_date
											,CUSTOMER_LT = @v_new_lt_day
											,BEFORE_QTY = QTY
											,CHECK_NEED_YN = 'Y'
											,LAST_UPDATED_BY = @p_last_updated_by
											,LAST_UPDATE_DATE = @v_last_update_date--[dbo].[FN_MULTY_TIME](@p_time_zone)
											,TO_SITE_SHIPTO_CODE = @v_shipto_code
											,REMARKS		= @v_remarks
											,REMARKS2		= @v_remarks2
											,REMARKS3		= @v_remarks3
											/*----------------------------------------------------------------------------------------
												2020.06.30 : KBK
												I/F 추가요청으로 인하여 컬럼 추가 전극에서만 사용. DDL 표준을 맞추기 위하여 추가함 
											------------------------------------------------------------------------------------------*/
											,PACKAGE_QTY = CASE WHEN A.ELECTRODE_YN = 'N' THEN @v_new_qty
															 ELSE CEILING(CASE WHEN B.PACKAGE_TYPE_CODE = 'BX' THEN CEILING(@v_new_qty * isnull(B.CONVERT_TO_PC_ROLL_LENGTH ,1) ) * isnull(B.BOX_PER_CUT ,1)
 																				WHEN B.PACKAGE_TYPE_CODE = 'SC' THEN CEILING(@v_new_qty * isnull(B.CONVERT_TO_PC_ROLL_LENGTH ,1) ) * isnull(B.STEELCRATE_PER_CUT ,1)
 																				WHEN B.PACKAGE_TYPE_CODE = 'SR' THEN CEILING(@v_new_qty * isnull(B.CONVERT_TO_PC_ROLL_LENGTH ,1) ) * isnull(B.STEELRACK_PER_CUT ,1)
 																			ELSE NULL  END) END
									FROM SSP_ANL_SHIP_CONFIRM A with(nolock) 
									LEFT OUTER JOIN SSP_MST_SITE_ITEM_EE_V B with(nolock)
										ON  B.DIVISION_ID = A.DIVISION_ID 
										AND B.SCM_SITE_ID = A.FROM_SITE 
										AND B.ITEM_ID     = A.ITEM_ID 
									WHERE CONFIRM_ID = @v_new_confirm_id
								END


								IF @p_change_type = 'C' -- Confirm 일 경우에는 날짜가 변경되면 기존것도 지우고 다시 넣는다.
									BEGIN
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
										FROM SSP_ANL_SHIP_CONFIRM_CHG_REQ_de a WITH(NOLOCK)
										WHERE A.CONFIRM_ID = @v_new_confirm_id
										  AND A.VALID_YN = 'Y'
										ORDER BY LAST_UPDATE_DATE desc;

										SET @v_chk = 0;
									END

						END
				END

				------------------ SSP_ANL_SHIP_PLAN_PACK_REQ  테이블 UPDATE해야하는지 확인 필요 --------------------------------------

				--MERGE SSP_ANL_SHIP_PLAN_PACK_REQ AS A 
				--USING (
				--SELECT 
				--	   C.DIVISION_ID
				--	 , C.ITEM_ID 
				--	 , C.FROM_SITE
				--	 , C.TO_SITE
				--	 , C.TO_SITE_SHIPTO_CODE
				--	 , C.YYYYMMDD
				--	 , C.BOD_ID
				--	 , C.QTY
				--	 , C.CONFIRM_ID
				--	 , C.INCOTERMS
				--	 , C.TRANSPORT_MODE				
				--	 , C.CREATION_DATE
				--	 , C.LAST_UPDATED_BY
				--	 , C.LAST_UPDATE_DATE
				--	 , C.ATTRIBUTE1
				--	 , C.ATTRIBUTE2
				--	 , C.ATTRIBUTE3
				--	 , C.ATTRIBUTE4
				--	 , C.ATTRIBUTE5
				--	 , C.ATTRIBUTE6
				--	 , C.ATTRIBUTE7
				--	 , C.ATTRIBUTE8
				--	 , C.ATTRIBUTE9
				--	 , C.ATTRIBUTE10
				--FROM SSP_ANL_SHIP_CONFIRM C WITH(NOLOCK)
				--LEFT OUTER JOIN SCM_MST_SITE MS WITH(NOLOCK)
				--  ON C.DIVISION_ID = MS.DIVISION_ID
				--  AND C.FROM_SITE = MS.SCM_SITE_ID
				--WHERE 1=1
				-- AND C.DIVISION_ID		= '40' 
				-- AND MS.OPERATION_GROUP = 'P'
				-- AND MS.OSP_YN			= 'Y'
				-- AND C.CONFIRM_ID LIKE 'R%'
				--) AS B 
				--ON (A.REQUEST_ID = B.CONFIRM_ID ) 
				
				--WHEN MATCHED THEN 
				--UPDATE SET   QTY		  = B.QTY --CEILING(@v_new_qty)
				--	, YYYYMMDD			  = B.YYYYMMDD --@v_new_ship_date
				--	, SHIPTO_CODE		  = B.TO_SITE_SHIPTO_CODE --@v_shipto_code
				--	, INCOTERMS			  = B.INCOTERMS --@v_new_incoterms
				--	, TRANSPORT_MODE	  = B.TRANSPORT_MODE --@v_new_transport_mode
				--	, LAST_UPDATED_BY     = B.LAST_UPDATED_BY --@p_last_updated_by
				--	, LAST_UPDATE_DATE    = B.LAST_UPDATE_DATE --@v_last_update_date

				--WHEN NOT MATCHED THEN 
				--	INSERT
				--	(
				--		 DIVISION_ID
				--		 , MODEL_TYPE
				--		 , MODEL_ID
				--		 , FROM_SITE
				--		 , TO_SITE
				--		 , SHIPTO_CODE
				--		 , YYYYMMDD
				--		 , BOD_ID
				--		 , QTY
				--		 , REQUEST_ID
				--		 , CONFIRM_ID
				--		 , INCOTERMS
				--		 , TRANSPORT_MODE
				--		 , ORDER_TYPE_DETAIL
				--		 , REMARK
				--		 , CREATED_BY
				--		 , CREATION_DATE
				--		 , LAST_UPDATED_BY
				--		 , LAST_UPDATE_DATE
				--		 , ATTRIBUTE1
				--		 , ATTRIBUTE2
				--		 , ATTRIBUTE3
				--		 , ATTRIBUTE4
				--		 , ATTRIBUTE5
				--		 , ATTRIBUTE6
				--		 , ATTRIBUTE7
				--		 , ATTRIBUTE8
				--		 , ATTRIBUTE9
				--		 , ATTRIBUTE10
				--	) VALUES
				--	(
				--	   B.DIVISION_ID
				--	 , '-' 
				--	 , B.ITEM_ID 
				--	 , B.FROM_SITE
				--	 , B.TO_SITE
				--	 , B.TO_SITE_SHIPTO_CODE
				--	 , B.YYYYMMDD
				--	 , B.BOD_ID
				--	 , B.QTY
				--	 , NULL
				--	 , B.CONFIRM_ID
				--	 , B.INCOTERMS
				--	 , B.TRANSPORT_MODE
				--	 , '-'
				--	 , '-'
				--	 , B.LAST_UPDATED_BY
				--	 , B.CREATION_DATE
				--	 , B.LAST_UPDATED_BY
				--	 , B.LAST_UPDATE_DATE
				--	 , B.ATTRIBUTE1
				--	 , B.ATTRIBUTE2
				--	 , B.ATTRIBUTE3
				--	 , B.ATTRIBUTE4
				--	 , B.ATTRIBUTE5
				--	 , B.ATTRIBUTE6
				--	 , B.ATTRIBUTE7
				--	 , B.ATTRIBUTE8
				--	 , B.ATTRIBUTE9
				--	 , B.ATTRIBUTE10
				--	)
				--	 ;


				----UPDATE SSP_ANL_SHIP_PLAN_PACK_REQ
				----SET   QTY				  = CEILING(@v_new_qty)
				----	, YYYYMMDD			  = @v_new_ship_date
				----	, SHIPTO_CODE		  = @v_shipto_code
				----	, INCOTERMS			  = @v_new_incoterms
				----	, TRANSPORT_MODE	  = @v_new_transport_mode
				----	, LAST_UPDATED_BY     = @p_last_updated_by
				----	, LAST_UPDATE_DATE    = @v_last_update_date
				----WHERE 1=1
				----  AND CONFIRM_ID = @v_confirm_id;

				--INSERT INTO SSP_ANL_SHIP_PLAN_PACK_REQ_H (
				--	   HISTORY_SEQ
				--	 , DIVISION_ID
				--	 , MODEL_TYPE
				--	 , MODEL_ID
				--	 , FROM_SITE
				--	 , TO_SITE
				--	 , SHIPTO_CODE
				--	 , YYYYMMDD
				--	 , BOD_ID
				--	 , QTY
				--	 , REQUEST_ID
				--	 , CONFIRM_ID
				--	 , INCOTERMS
				--	 , TRANSPORT_MODE
				--	 , ORDER_TYPE_DETAIL
				--	 , REMARK
				--	 , CREATED_BY
				--	 , CREATION_DATE
				--	 , LAST_UPDATED_BY
				--	 , LAST_UPDATE_DATE
				--	 , ATTRIBUTE1
				--	 , ATTRIBUTE2
				--	 , ATTRIBUTE3
				--	 , ATTRIBUTE4
				--	 , ATTRIBUTE5
				--	 , ATTRIBUTE6
				--	 , ATTRIBUTE7
				--	 , ATTRIBUTE8
				--	 , ATTRIBUTE9
				--	 , ATTRIBUTE10
				--	   )
				--SELECT NEXT VALUE FOR SEQ1_SSP_ANL_SHIP_PACKER_REQ_H   AS HISTORY_SEQ
				--	 , A.DIVISION_ID
				--	 , A.MODEL_TYPE
				--	 , A.MODEL_ID
				--	 , A.FROM_SITE
				--	 , A.TO_SITE
				--	 , A.SHIPTO_CODE
				--	 , A.YYYYMMDD
				--	 , A.BOD_ID
				--	 , A.QTY
				--	 , A.REQUEST_ID
				--	 , A.CONFIRM_ID
				--	 , A.INCOTERMS
				--	 , A.TRANSPORT_MODE
				--	 , A.ORDER_TYPE_DETAIL
				--	 , A.REMARK
				--	 , A.CREATED_BY
				--	 , A.CREATION_DATE
				--	 , A.LAST_UPDATED_BY
				--	 , A.LAST_UPDATE_DATE
				--	 , A.ATTRIBUTE1
				--	 , A.ATTRIBUTE2
				--	 , A.ATTRIBUTE3
				--	 , A.ATTRIBUTE4
				--	 , A.ATTRIBUTE5
				--	 , A.ATTRIBUTE6
				--	 , A.ATTRIBUTE7
				--	 , A.ATTRIBUTE8
				--	 , A.ATTRIBUTE9
				--	 , A.ATTRIBUTE10
				--FROM   SSP_ANL_SHIP_PLAN_PACK_REQ  A WITH(NOLOCK)	
				--WHERE  1 = 1
				-- AND CONFIRM_ID = @v_confirm_id;

				-- INSERT INTO XIF_SCS_PACK_SHIP_PLAN_S_SN (
				--	   IF_SEQ           
				--	 , IF_TYPE          
				--	 , IF_ID            
				--	 , IF_INS_DATE      
				--	 , IF_FLAG          
				--	 , PACKER_CODE      
				--	 , DIVISION_ID      
				--	 , PLAN_VERSION   
				--	 , PACK_MODEL_CODE  
				--	 , NICK_NAME 
				--	 , TARGET_ORDER
				--	 , SSP_CNFM
				--	 , SALES_SITE
				--	 , SHIP_TO
				--	 , SHIP_TO_NAME
				--	 , TRANSPORT_MODE
				--	 , INCOTERMS
				--	 , SHIP_PLAN_DATE 
				--	 , SHIP_PLAN_QTY 
				--	 , COMMENT
				--	 , ATTR_01           
				--	 , ATTR_02           
				--	 , ATTR_03           
				--	 , ATTR_04           
				--	 , ATTR_05           
				--	 , ATTR_06           
				--	 , ATTR_07           
				--	 , ATTR_08           
				--	 , ATTR_09           
				--	 , ATTR_10 
				--	 , ORDER_TYPE_DETAIL
				--	 )
				--SELECT 'OSCM' + CONVERT(VARCHAR,GETDATE(),12) + DBO.FN_ZERO_LPAD(CONVERT(VARCHAR,NEXT VALUE FOR DBO.SEQ1_XIF_SCS),10)  AS IF_SEQ
				--	 , N'I'         AS IF_TYPE          
				--	 , N'OSCM_OSCS_SCS_PACK_SHIP_PLAN'  AS IF_ID            
				--	 , GETDATE()    AS IF_INS_DATE      
				--	 , 'N'          AS IF_FLAG          
				--	 , A.FROM_SITE  AS PACKER_CODE      
				--	 , A.DIVISION_ID AS DIVISION_ID      
				--	 , CONVERT(VARCHAR(8), CONVERT(DATETIME, getdate()), 112)    AS PLAN_VERSION   
				--	 , A.ITEM_ID    AS PACK_MODEL_CODE  
				--	 , [dbo].[FN_GET_ITEM_NICKNAME](A.DIVISION_ID, A.ITEM_ID)  AS NICK_NAME 
				--	 , N'O'          AS TARGET_ORDER
				--	 , N'-'			 AS SSP_CNFM
				--	 , A.TO_SITE     AS SALES_SITE
				--	 , A.TO_SITE_SHIPTO_CODE AS SHIP_TO
				--	-- , [dbo].[FN_GET_SITE_CUSTOMER_INFO](B.DIVISION_ID, B.TO_SITE,'SHIPTO_CODE')	AS SHIP_TO
				--	 , [dbo].[FN_GET_SITE_CUSTOMER_INFO](A.DIVISION_ID, A.TO_SITE,'SHIPTO_DESCRIPTION')	AS SHIP_TO_NAME
				--	 , A.TRANSPORT_MODE
				--	 , A.INCOTERMS
				--	 , A.YYYYMMDD    AS SHIP_PLAN_DATE 
				--	 , A.QTY         AS SHIP_PLAN_QTY 
				--	 , NULL								AS COMMENT
				--	 , A.DIVISION_ID + '_' + @v_plan_start_yyyymmdd + '_' + @IF_GROUP_NO	AS ATTR_01           
				--	 , NULL								AS ATTR_02           
				--	 , NULL								AS ATTR_03           
				--	 , NULL								AS ATTR_04           
				--	 , NULL								AS ATTR_05           
				--	 , NULL								AS ATTR_06           
				--	 , NULL								AS ATTR_07           
				--	 , NULL								AS ATTR_08           
				--	 , NULL								AS ATTR_09           
				--	 , A.CONFIRM_ID						AS ATTR_10
				--	 , '-'				AS ORDER_TYPE_DETAIL
				--FROM SSP_ANL_SHIP_CONFIRM A WITH(NOLOCK)
				--WHERE  1 = 1
				-- AND CONFIRM_ID = @v_confirm_id;

				----------------------------------------------------------------------------------------------------------------------
			
				--이력저장
				EXEC [dbo].[PR_SSP_ANL_SHIP_CONFIRM_HIST] @p_change_request_no,@p_last_updated_by,@p_time_zone

				-- 
				
			END
		ELSE
			BEGIN
				IF @p_change_type = 'C'
					BEGIN
						--SSP_ANL_SHIP_CONFIRM update
						UPDATE SSP_ANL_SHIP_CONFIRM
							SET SHIPMENT_STATUS = 'C'
								,CHANGE_REQ_NO = null
								,ATTRIBUTE1 = null
								,LAST_UPDATED_BY = @p_last_updated_by
								,LAST_UPDATE_DATE = @v_last_update_date--[dbo].[FN_MULTY_TIME](@p_time_zone)
						WHERE CHANGE_REQ_NO = @p_change_request_no;
					END
				ELSE IF @p_change_type = 'N'
					BEGIN
						--SSP_ANL_SHIP_CONFIRM update
						DELETE SSP_ANL_SHIP_CONFIRM
						WHERE CHANGE_REQ_NO = @p_change_request_no;
					END
				ELSE
					BEGIN
						--SSP_ANL_SHIP_CONFIRM update
						UPDATE SSP_ANL_SHIP_CONFIRM
							SET SHIPMENT_STATUS = 'P'
								,CHANGE_REQ_NO = null
								,ATTRIBUTE1 = null
								,LAST_UPDATED_BY = @p_last_updated_by
								,LAST_UPDATE_DATE = @v_last_update_date--[dbo].[FN_MULTY_TIME](@p_time_zone)
						WHERE CHANGE_REQ_NO = @p_change_request_no;
					END
			END

		IF @p_change_status = 'A' --변경확정
			BEGIN
				--SET @p_yyyymmdd = REPLACE(SUBSTRING(@p_yyyymmdd,1,10),'-','')

				SELECT @p_yyyymmdd = yyyymmdd
				FROM(
					SELECT top 1 case when YYYYMMDD > NEW_YYYYMMDD then NEW_YYYYMMDD else YYYYMMDD end yyyymmdd
					FROM SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE with(nolock)
					WHERE CHANGE_REQ_NO = @p_change_request_no
					ORDER BY YYYYMMDD, NEW_YYYYMMDD
				) a
     
				--메일 발송
				EXEC SCM_SSP_MAIL_SEND @p_change_request_no, @p_change_status

				
			END 
		ELSE --변경 Reject
			BEGIN
				--메일 발송
				 EXEC SCM_SSP_MAIL_SEND @p_change_request_no, @p_change_status
			END 

		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		
		-- 결과코드, 결과 카운트 반환
		SELECT  'S' AS result_code ;

		-- [C20201223-000448] MKT FCST - SSP Sync
		--IF @p_change_status = 'A' --변경 확정시에만 호출 하도록 변경
		--	EXEC PR_DM_SSP_CONFIRM_SYNC @p_division_id, @p_new_confirm_id;

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
