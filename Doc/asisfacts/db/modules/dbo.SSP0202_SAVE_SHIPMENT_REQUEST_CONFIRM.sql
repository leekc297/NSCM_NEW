



/*
 * Program ID   : SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM
 * Description  : Shipment Change Request Confirm Save
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/04/20   ygkim          Initial Release [PJ20182279] 전지본부 출하계획 시스템 구축 프로젝트
 * 2018/05/29   ygkim			create date, last update date 시간 변경
 * 2018/06/11   ygkim			PR_SSP_ANL_SHIP_CONFIRM_HIST 저장 로직 수정
 * 2018/06/28   ygkim			SSP_ANL_SHIP_PLAN 테이블 체크 조건 Confirm ID 추가
 *								SSP_ANL_SHIP_PLAN 테이블 PROJECT_CODE, FCST_TYPE 조회조건 제거
 * 2018/07/02   ygkim			SSP_ANL_SHIP_PLAN 저장 로직 수정
 * 2018/07/05   ygkim			SSP_ANL_SHIP_PLAN 체크 조건 변경
 * 2018/07/10   ygkim			SSP_ANL_SHIP_CONFIRM Attribute1 수정 추가
 * 2018/07/20   ygkim			Confirm 일 경우 SSP_ANL_SHIP_PLAN 테이블에 기존 날짜 데이터 지우고 Insert 하는 로직 추가
 * 2018/08/09   ygkim			Plan 일 경우 Confirm 테이블에 넣는 로직 수정
 * 2018/09/03   ygkim			Division 'EE' 추가로 인한 쿼리 수정
 * 2018/10/08   ygkim		    Change Type Plan 일 경우 Status 'C' -> 'P'로 변경으로 인한 수정
 * 2018/10/10   ygkim			SSP_ANL_SHIP_CONFIRM_CHG_REQ_de 가져오는 조건 변경
 * 2018/10/12   ygkim           신규 일 경우에는 ERP 4개 컬럼 NULL로 넣어준다.
 * 2018/10/15   ygkim			Change Type New 로직 추가
 * 2018/10/16   ygkim			승인 일 경우 PR_SSP_ANL_SHIP_UPDATE_BOH_VAL 프로시저 호출 파라미터 yyyymmdd 수정
 * 2019/04/04	ayj			    [PJ20189106] 전지.GSCM 고도화 이행- 소형 컬럼추가
 * 2019/07/15	mcTheJ			[CSR ID:4044806] Model PIC 담당자 위임 기능 추가 - 위임자 결재 추가
 * 2019/10/02	ayj				PLAN TB 미사용으로 인한 주석
 * 2019/10/29	ayj				FCST_ETA_DATE, ETA_DATE 저장 값 수정(출발일 기준 항차를 고려한 ETA_DATE 계산)
 * 2021/01/07   KIMYONGHO       [C20201223-000448] MKT FCST - SSP Sync
 * 2021/01/12   KIMYONGHO       [C20201223-000448] MKT FCST - SSP Sync 운영이관 검증 단계에서 처리 지연 현상으로 END LOG 이후 호출로 조정함.
 * 2021/03/05   KIMYONGHO       SCS I/F 추가
 * 2021/04/08   KIMYONGHO       [C20210406-000222] MKT FCST - SSP Sync DIVISION_ID parameter 변경

 --SCS I/F
 */

CREATE PROCEDURE [dbo].[SSP0202_SAVE_SHIPMENT_REQUEST_CONFIRM]
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
	
	SET @v_division_id = null
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
	
	SET @v_chk = 0
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM';
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
			begin
				UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ
				   SET CHANGE_REQ_STATUS = @p_change_status
					  ,APPROVAL_TIME = @v_last_update_date--[dbo].[FN_MULTY_TIME](@p_time_zone)
					  ,REJECT_REASON = @p_reject_reason
					  ,LAST_UPDATED_BY = @p_last_updated_by
					  ,LAST_UPDATE_DATE = @v_last_update_date--[dbo].[FN_MULTY_TIME](@p_time_zone)
				WHERE CHANGE_REQ_NO = @p_change_request_no;
			end
			else
			begin
				UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ
				   SET CHANGE_REQ_STATUS = @p_change_status
					  ,APPROVAL_TIME = @v_last_update_date--[dbo].[FN_MULTY_TIME](@p_time_zone)
					  ,REJECT_REASON = @p_reject_reason
					  ,DELEGATEE_USER = @p_delegatee
					  ,DELEGATEE_DEPT = @p_delegatee_dept
					  ,LAST_UPDATED_BY = @p_last_updated_by
					  ,LAST_UPDATE_DATE = @v_last_update_date--[dbo].[FN_MULTY_TIME](@p_time_zone)
				WHERE CHANGE_REQ_NO = @p_change_request_no;
			end;
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
												,DOM_EXP
												,ERP_ATTR1
												,ERP_ATTR2
												,ERP_ATTR3
												,ERP_ATTR4
												,ERP_ATTR5
											FROM SSP_ANL_SHIP_CONFIRM A with(nolock)
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
 																		  ELSE NULL  END) END    AS PACKAGE_QTY
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
												,A.TO_SITE_TYPE
												,A.TO_SITE_PLANT_ID
												,A.TO_SITE_VENDOR_ID
												,A.TO_SITE_SOLDTO_CODE
												,A.TO_SITE_SHIPTO_CODE
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
											FROM SSP_ANL_SHIP_CONFIRM  A  with(nolock)
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

							----이력저장
							--EXEC [dbo].[PR_SSP_ANL_SHIP_CONFIRM_HIST] @p_change_request_no, 'C', @v_new_confirm_id, @v_new_etd_date,@v_new_eta_date,@v_new_qty,@v_new_ship_date,@v_new_yn
							--										,@v_new_bod_id,@v_new_route_id,@v_new_incoterms, @v_new_d_contry, @v_new_d_port_code, @v_new_a_country,@v_new_a_port_code
							--										,@v_new_to_country,@v_new_to_city,@v_new_lt_day, @v_new_transport_mode
							--										,@p_last_updated_by,@p_time_zone
						
							--20191002 PLAN TB 미사용으로 인한 주석 시작
							/*
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
								--FROM SSP_ANL_SHIP_CONFIRM_CHG_REQ_de a
								FROM SSP_ANL_SHIP_CONFIRM a
								WHERE A.CONFIRM_ID = @v_new_confirm_id
								
								SELECT @v_plan_start_yyyymmdd = MAX(PLAN_START_YYYYMMDD)
									  ,@v_seq                 = MAX(PLAN_SEQ)
								FROM   SSP_PLAN_VERSION_V
								WHERE  PLAN_TYPE    = 'SP'
								AND    DIVISION_ID  = @n_division_id 
								AND    CONFIRM_FLAG = 'Y'
								AND    PLAN_START_YYYYMMDD = (SELECT MAX(PLAN_START_YYYYMMDD)
													FROM SSP_PLAN_VERSION_V T
													WHERE T.DIVISION_ID = @n_division_id 
													AND   T.plan_type  = 'SP'
													AND   T.CONFIRM_FLAG = 'Y');
								
								IF @p_change_type = 'P'
									BEGIN
											SELECT @v_chk = COUNT(*)
											FROM SSP_ANL_SHIP_PLAN A
											WHERE A.DIVISION_ID = @n_division_id
											  AND A.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
											  AND A.PLAN_TYPE = 'SP'
											  AND A.SEQ = @v_seq
											  AND A.ITEM_ID = @n_item_id
											  AND A.FROM_SITE = @n_from_site
											  AND A.TO_SITE = @n_to_site
											  AND A.YYYYMMDD = @n_yyyymmdd
											  --AND A.BOD_ID = @n_bod_id
											  --AND A.PROJECT_CODE = @n_project_code
											  --AND A.FCST_TYPE = @n_fcst_type
											  --AND A.INCOTERMS = @n_incoterms
											  --AND A.TRANSPORT_MODE = @n_transport_mode
											  AND MEASURE in ('SHIP_CONFIRM', 'SHIP_PLAN')
											 -- AND A.CONFIRM_FLAG = 'Y' -- Plan 일 경우 둘다 삭제
											  --AND A.CONFIRM_ID = @v_new_confirm_id
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
														--AND BOD_ID = @n_bod_id
														--AND PROJECT_CODE = @n_project_code
														--AND FCST_TYPE = @n_fcst_type
														--AND INCOTERMS = @n_incoterms
														--AND TRANSPORT_MODE = @n_transport_mode
														AND MEASURE in ('SHIP_CONFIRM', 'SHIP_PLAN')
														--AND CONFIRM_FLAG = 'Y' -- Plan 일 경우 둘다 삭제
														--AND CONFIRM_ID = @v_new_confirm_id
														;
												END
									END
								ELSE
									BEGIN
											SELECT @v_chk = COUNT(*)
											FROM SSP_ANL_SHIP_PLAN A
											WHERE A.DIVISION_ID = @n_division_id
											  AND A.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
											  AND A.PLAN_TYPE = 'SP'
											  AND A.SEQ = @v_seq
											  AND A.ITEM_ID = @n_item_id
											  AND A.FROM_SITE = @n_from_site
											  AND A.TO_SITE = @n_to_site
											  AND A.YYYYMMDD = @n_yyyymmdd
											  --AND A.BOD_ID = @n_bod_id
											  --AND A.PROJECT_CODE = @n_project_code
											  --AND A.FCST_TYPE = @n_fcst_type
											  --AND A.INCOTERMS = @n_incoterms
											  --AND A.TRANSPORT_MODE = @n_transport_mode
											  AND MEASURE in ('SHIP_CONFIRM', 'SHIP_PLAN')
											  AND A.CONFIRM_FLAG = 'Y' -- Confrim ID가 없는건 삭제하지 않음
											  --AND A.CONFIRM_ID = @v_new_confirm_id
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
														--AND BOD_ID = @n_bod_id
														--AND PROJECT_CODE = @n_project_code
														--AND FCST_TYPE = @n_fcst_type
														--AND INCOTERMS = @n_incoterms
														--AND TRANSPORT_MODE = @n_transport_mode
														AND MEASURE in ('SHIP_CONFIRM', 'SHIP_PLAN')
														AND CONFIRM_FLAG = 'Y' -- Confrim ID가 없는건 삭제하지 않음
														--AND CONFIRM_ID = @v_new_confirm_id
														;
												END
									END
								
								/*
								IF @p_change_type = 'P' -- Plan 일 경우 기존 날짜는 수량을 0으로 업데이트한다.
									BEGIN
										SELECT @n_ori_division_id = DIVISION_ID
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
										FROM SSP_ANL_SHIP_CONFIRM_CHG_REQ_de a
										WHERE A.CONFIRM_ID = @v_new_confirm_id;

										UPDATE SSP_ANL_SHIP_PLAN
											SET QTY = 0
												,LAST_UPDATED_BY = @p_last_updated_by
												,LAST_UPDATE_DATE = @v_last_update_date
										WHERE DIVISION_ID = @n_ori_division_id
											AND PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
											AND PLAN_TYPE = 'SP'
											AND SEQ = @v_seq
											AND ITEM_ID = @n_ori_item_id
											AND FROM_SITE = @n_ori_from_site
											AND TO_SITE = @n_ori_to_site
											AND YYYYMMDD = @n_ori_yyyymmdd
											--AND BOD_ID = @n_ori_bod_id
											AND PROJECT_CODE = @n_ori_project_code
											AND FCST_TYPE = @n_ori_fcst_type
											--AND INCOTERMS = @n_ori_incoterms
											--AND TRANSPORT_MODE = @n_ori_transport_mode
											AND MEASURE in ('SHIP_CONFIRM', 'SHIP_PLAN')
											AND CONFIRM_FLAG = 'N'
									END
									*/
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
										FROM SSP_ANL_SHIP_CONFIRM_CHG_REQ_de a
										WHERE A.CONFIRM_ID = @v_new_confirm_id
										  AND A.VALID_YN = 'Y'
										ORDER BY LAST_UPDATE_DATE desc;

										SET @v_chk = 0;

										SELECT @v_chk = COUNT(*)
										FROM SSP_ANL_SHIP_PLAN A
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
																  ,@p_last_updated_by CREATED_BY
																  ,@v_last_update_date--[dbo].[FN_MULTY_TIME](@p_time_zone) CREATION_DATE
																  ,@p_last_updated_by LAST_UPDATED_BY
																  ,@v_last_update_date--[dbo].[FN_MULTY_TIME](@p_time_zone) LAST_UPDATE_DATE
																  ,ELECTRODE_YN
																  ,ELECTRODE_TYPE
																  ,ORIGIN_FROM_DIVISION_ID
																  ,ORIGIN_TO_DIVISION_ID
															FROM SSP_ANL_SHIP_CONFIRM A
															WHERE A.CONFIRM_ID in (SELECT CONFIRM_ID
																				FROM SSP_ANL_SHIP_CONFIRM
																				WHERE DIVISION_ID = @n_ori_division_id
																				  AND ITEM_ID = @n_ori_item_id
																				  AND FROM_SITE = @n_ori_from_site
																				  AND TO_SITE = @n_ori_to_site
																				  AND YYYYMMDD = @n_ori_yyyymmdd
																				  AND CHANGE_TYPE = 'C'
																				  --AND BOD_ID = @v_new_bod_id
																				  --AND INCOTERMS = @v_new_incoterms
																				  --AND TRANSPORT_MODE = @v_new_transport_mode
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
																  ,@p_last_updated_by CREATED_BY
																  ,@v_last_update_date--[dbo].[FN_MULTY_TIME](@p_time_zone) CREATION_DATE
																  ,@p_last_updated_by LAST_UPDATED_BY
																  ,@v_last_update_date--[dbo].[FN_MULTY_TIME](@p_time_zone) LAST_UPDATE_DATE
																  ,ELECTRODE_YN
																  ,ELECTRODE_TYPE
																  ,ORIGIN_FROM_DIVISION_ID
																  ,ORIGIN_TO_DIVISION_ID
															FROM SSP_ANL_SHIP_CONFIRM A
															WHERE A.CONFIRM_ID in (SELECT CONFIRM_ID
																				FROM SSP_ANL_SHIP_CONFIRM
																				WHERE  DIVISION_ID = @n_ori_division_id
																				  AND ITEM_ID = @n_ori_item_id
																				  AND FROM_SITE = @n_ori_from_site
																				  AND TO_SITE = @n_ori_to_site
																				  AND YYYYMMDD = @n_ori_yyyymmdd
																				  AND CHANGE_TYPE = 'C'
																				  --AND BOD_ID = @v_new_bod_id
																				  --AND INCOTERMS = @v_new_incoterms
																				  --AND TRANSPORT_MODE = @v_new_transport_mode
																				  )
												END
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
												  ,@p_last_updated_by CREATED_BY
												  ,@v_last_update_date--[dbo].[FN_MULTY_TIME](@p_time_zone) CREATION_DATE
												  ,@p_last_updated_by LAST_UPDATED_BY
												  ,@v_last_update_date--[dbo].[FN_MULTY_TIME](@p_time_zone) LAST_UPDATE_DATE
												  ,ELECTRODE_YN
												  ,ELECTRODE_TYPE
												  ,ORIGIN_FROM_DIVISION_ID
												  ,ORIGIN_TO_DIVISION_ID
											FROM SSP_ANL_SHIP_CONFIRM A
											WHERE A.CONFIRM_ID in (SELECT CONFIRM_ID
																FROM SSP_ANL_SHIP_CONFIRM
																WHERE DIVISION_ID = @n_division_id
																  AND ITEM_ID = @n_item_id
																  AND FROM_SITE = @n_from_site
																  AND TO_SITE = @n_to_site
																  AND YYYYMMDD = @v_new_ship_date
																  AND CHANGE_TYPE = 'C'
																  --AND BOD_ID = @v_new_bod_id
																  --AND INCOTERMS = @v_new_incoterms
																  --AND TRANSPORT_MODE = @v_new_transport_mode
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
												  ,@p_last_updated_by CREATED_BY
												  ,@v_last_update_date--[dbo].[FN_MULTY_TIME](@p_time_zone) CREATION_DATE
												  ,@p_last_updated_by LAST_UPDATED_BY
												  ,@v_last_update_date--[dbo].[FN_MULTY_TIME](@p_time_zone) LAST_UPDATE_DATE
												  ,ELECTRODE_YN
												  ,ELECTRODE_TYPE
												  ,ORIGIN_FROM_DIVISION_ID
												  ,ORIGIN_TO_DIVISION_ID
											FROM SSP_ANL_SHIP_CONFIRM A
											WHERE A.CONFIRM_ID in (SELECT CONFIRM_ID
																FROM SSP_ANL_SHIP_CONFIRM
																WHERE DIVISION_ID = @n_division_id
																  AND ITEM_ID = @n_item_id
																  AND FROM_SITE = @n_from_site
																  AND TO_SITE = @n_to_site
																  AND YYYYMMDD = @v_new_ship_date
																  AND CHANGE_TYPE = 'C'
																  --AND BOD_ID = @v_new_bod_id
																  --AND INCOTERMS = @v_new_incoterms
																  --AND TRANSPORT_MODE = @v_new_transport_mode
																  )
								END
							*/
							--20191002 PLAN TB 미사용으로 인한 주석 끝
						END
				END
			
				--이력저장
				EXEC [dbo].[PR_SSP_ANL_SHIP_CONFIRM_HIST] @p_change_request_no,@p_last_updated_by,@p_time_zone
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

				--20191002 PLAN TB 미사용으로 인한 주석 시작
				/*
				SELECT @p_yyyymmdd = yyyymmdd
				FROM(
					SELECT top 1 case when YYYYMMDD > NEW_YYYYMMDD then NEW_YYYYMMDD else YYYYMMDD end yyyymmdd
					FROM SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE with(nolock)
					WHERE CHANGE_REQ_NO = @p_change_request_no
					ORDER BY YYYYMMDD, NEW_YYYYMMDD
				) a

				EXEC PR_SSP_ANL_SHIP_UPDATE_BOH_VAL @p_division_id, @p_item_id, @p_from_site, @p_yyyymmdd, @p_last_updated_by         
				*/
				--20191002 PLAN TB 미사용으로 인한 주석 끝

				--메일 발송
				EXEC SCM_SSP_MAIL_SEND @p_change_request_no, @p_change_status

				--SCS I/F
				EXEC [dbo].[PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_SCS] 'B' , @p_change_request_no
				;
				
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
		IF @p_change_status = 'A' --변경확정
			EXEC PR_DM_SSP_CONFIRM_SYNC @p_division_id, @p_new_confirm_id;


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
