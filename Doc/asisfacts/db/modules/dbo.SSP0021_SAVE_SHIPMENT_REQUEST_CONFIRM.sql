/*
 * Program ID   : SSP0021_SAVE_SHIPMENT_REQUEST_CONFIRM
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
 * 2019/10/02	ayj				PLAN TB 미사용으로 인한 주석
 * 2019/10/29	ayj				FCST_ETA_DATE, ETA_DATE 저장 값 수정(출발일 기준 항차를 고려한 ETA_DATE 계산)
 * 2019/11/26	KIMYONGHO		메일 전송 변경 JOB.SCM_SSP_ADJUST_MAIL_SEND_BATCH -> PR_SSP_MAIL_SEND_ADJUST_MST
 * 2020/06/23	khj79			ETD_DATE, FCST_ETD_DATE 를 YYYYMMDD 와 같은 날짜로 변경 되도록 수정
 * 2021/01/07   KIMYONGHO		[C20201223-000448] MKT FCST - SSP Sync
 * 2021/01/12   KIMYONGHO		[C20201223-000448] MKT FCST - SSP Sync 운영이관 검증 단계에서 처리 지연 현상으로 END LOG 이후 호출로 조정함.
 * 2021/01/12   KIMYONGHO		SCS I/F 추가
 * 2021/09/02   KIMYONGHO       SCP_MST_BOD_v -> SCP_MST_BOD_N_V 변경
 * 2021/10/18   KIMYONGHO	  [C20211001-000241][SCM PI팀] Shipment Plan (Auto ESS) 기능 개선 의건
 * 2024/02/23   jilee           폴란드 WA 법인 변경건 전체 내역 송부
 * 2024/06/10   jilee           Plan 하단 신규 건 Change Req 정보 입력
 * 2024/10/01   KHJ             NERP_SSP
 --
 */

CREATE PROCEDURE [dbo].[SSP0021_SAVE_SHIPMENT_REQUEST_CONFIRM]
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
	
	DECLARE @v_plan_start_yyyymmdd  NVARCHAR(MAX);
	DECLARE @v_seq					NVARCHAR(MAX);
	
	DECLARE @v_edit_main		    NVARCHAR(MAX);

	DECLARE @v_planned_qty              INT;
	DECLARE @v_change_req_no			NVARCHAR(MAX);
	DECLARE @v_yyyymmdd					NVARCHAR(MAX);

	DECLARE @v_division_id_temp		         NVARCHAR(MAX);
	DECLARE @v_new_bod_id_temp		         NVARCHAR(MAX);
	DECLARE @v_from_site_temp		         NVARCHAR(MAX);
	DECLARE @v_to_site_temp			         NVARCHAR(MAX);
	DECLARE @v_item_id_temp	   				 NVARCHAR(MAX);
	DECLARE @v_new_incoterms_temp            NVARCHAR(MAX);
	DECLARE @v_new_transport_mode_temp       NVARCHAR(MAX);
	DECLARE @v_new_route_id_temp			 NVARCHAR(MAX);  
	DECLARE @v_new_d_contry_temp			 NVARCHAR(MAX);      
	DECLARE @v_new_d_port_code_temp          NVARCHAR(MAX);  
	DECLARE @v_new_a_country_temp            NVARCHAR(MAX);  
	DECLARE @v_new_a_port_code_temp          NVARCHAR(MAX);  
	DECLARE @v_new_customer_lt_temp          NVARCHAR(MAX);
	DECLARE @v_new_to_country_temp           NVARCHAR(MAX);  
	DECLARE @v_new_to_city_temp		         NVARCHAR(MAX);

	DECLARE @v_new_confirm_id				 NVARCHAR(max);
	DECLARE @v_infseqno						 nvarchar(14);	
	DECLARE @v_last_confirm_date			 nvarchar(8);	

	DECLARE @v_chk_req				INT;

	DECLARE @v_max_req_no				     NVARCHAR(40);
	DECLARE @v_user_dept_id				     NVARCHAR(50);

	DECLARE @v_electrode_yn				     NVARCHAR(MAX);
	DECLARE @v_electrode_type			     NVARCHAR(MAX);
	DECLARE @v_origin_from_division_id	     NVARCHAR(MAX);
	DECLARE @v_origion_to_division_id	     NVARCHAR(MAX);

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

	SET @v_planned_qty				= 0;
	SET @v_change_req_no			= null;
	SET @v_edit_main				= null;

	SET @v_create_date    = SYSDATETIME();

	SET @v_chk_req = 0;

	SET @v_user_dept_id				= null;

	SET @v_electrode_yn				= null;	
	SET @v_electrode_type			= null;	
	SET @v_origin_from_division_id	= null;	
	SET @v_origion_to_division_id	= null;	

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SSP0021_SAVE_SHIPMENT_REQUEST_CONFIRM';
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


				SELECT @v_from_site_temp = FROM_SITE
					 ,@v_to_site_temp	 = TO_SITE
					 ,@v_item_id_temp	 = ITEM_ID
				FROM SSP_ANL_SHIP_CONFIRM (NOLOCK) 
				WHERE CONFIRM_ID = @v_confirm_id;
			END;

			SELECT TOP 1
					 @v_division_id_temp			= V.DIVISION_ID 
					,@v_new_bod_id_temp				= V.BOD_ID 
					,@v_from_site_temp				= V.FROM_SITE
					,@v_to_site_temp				= V.TO_SITE 
					,@v_new_incoterms_temp			= V.SSP_INCOTERMS
					,@v_new_transport_mode_temp		= V.TRANSPORT_MODE
					,@v_new_route_id_temp			= V.ROUTE_ID 
					,@v_new_d_contry_temp			= V.D_COUNTRY        
					,@v_new_d_port_code_temp		= V.D_PORT_CODE      
					,@v_new_a_country_temp			= V.A_COUNTRY        
					,@v_new_a_port_code_temp		= V.A_PORT_CODE      
					,@v_new_customer_lt_temp		= V.LT_TOTAL      
					,@v_new_to_country_temp			= V.TO_COUNTRY       
					,@v_new_to_city_temp			= V.TO_CITY

					--  V.DIVISION_ID 
					--, V.BOD_ID 
					--, V.FROM_SITE
					--, V.TO_SITE 
					--, V.SSP_INCOTERMS
					--, V.TRANSPORT_MODE
					--, V.ROUTE_ID 
					--, V.D_COUNTRY        
					--, V.D_PORT_CODE      
					--, V.A_COUNTRY        
					--, V.A_PORT_CODE      
					--, V.LT_TOTAL      
					--, V.TO_COUNTRY       
					--, V.TO_CITY

				FROM    (
							SELECT   DISTINCT B.DIVISION_ID , B.BOD_ID , B.FROM_SITE, B.TO_SITE , B.SSP_INCOTERMS, B.TRANSPORT_MODE
									,B.ROUTE_ID, B.D_COUNTRY, B.D_PORT_CODE, B.A_COUNTRY, B.A_PORT_CODE, B.LT_TOTAL, B.LT_TOTAL_ORIGIN, B.TO_COUNTRY, B.TO_CITY , B.PRIORITY, B.bod_valid_yn
							FROM (
									SELECT DIVISION_ID 
									,      BOD_ID
									,      FROM_SITE
									,      TO_SITE 
									,      SSP_INCOTERMS		AS SSP_INCOTERMS
									,      TRANSPORT_MODE 			
									,      SHIP_LT_TOTAL_ORIGIN  AS SHIP_LT_TOTAL 
									,	   ROUTE_ID
									,      d_country
									,      d_port_code
									,      a_country
									,      a_port_code
									,      lt_total
									,      LT_TOTAL_ORIGIN 
									,	   to_country
									,      to_city
									,      PRIORITY 			
									,      bod_valid_yn
									FROM SCP_MST_BOD_N_V WITH(NOLOCK) 
									--FROM SCP_MST_BOD_V WITH(NOLOCK)
									WHERE DIVISION_ID	 = @v_division_id
									AND   FROM_SITE		 = @v_from_site_temp
									AND   TO_SITE		 = @v_to_site_temp
									AND	  TRANSPORT_MODE = @v_new_transport_mode
									AND	  ssp_incoterms  = @v_new_incoterms
									AND   BOD_VALID_YN	 = 'Y'				
									AND   FROM_YYYYMMDD <= @v_shipment_date
									AND   TO_YYYYMMDD >= @v_shipment_date

								)  B 
		
				   )  V

					JOIN ( SELECT DISTINCT DIVISION_ID , ITEM_ID , BOD_ID 
						   FROM   SCP_MST_BOD_ITEM  WITH(NOLOCK)   -- SCP_MST_BOD_ITEM A WITH(NOLOCK) 
						   WHERE  DIVISION_ID =   @v_division_id
						   AND    ITEM_ID  = @v_item_id_temp 
						  )   A
					  ON A.DIVISION_ID  = V.DIVISION_ID 
					 AND A.BOD_ID       = V.BOD_ID

				WHERE 1=1
				  AND V.division_id = @v_division_id
				  AND V.from_site = @v_from_site_temp 
				  AND V.to_site = @v_to_site_temp 
				  AND V.TRANSPORT_MODE = @v_new_transport_mode
				  AND V.ssp_incoterms = @v_new_incoterms
				  AND V.bod_valid_yn = 'Y'
				order by V.PRIORITY


				--print @v_division_id_temp			  ;
				--print @v_new_bod_id_temp			  ;
				--print @v_from_site_temp				  ;
				--print @v_to_site_temp				  ;
				--print @v_new_incoterms_temp			  ;
				--print @v_new_transport_mode_temp	  ;
				--print @v_new_route_id_temp			  ;
				--print @v_new_d_contry_temp			  ;
				--print @v_new_d_port_code_temp		  ;
				--print @v_new_a_country_temp			  ;
				--print @v_new_a_port_code_temp		  ;
				--print @v_new_customer_lt_temp		  ;
				--print @v_new_to_country_temp		  ;
				--print @v_new_to_city_temp			  ;


				IF ( (  @v_division_id_temp			= '' or @v_division_id_temp IS NULL				)
					OR (@v_new_bod_id_temp			= '' or @v_new_bod_id_temp IS NULL				)
					OR (@v_from_site_temp			= '' or @v_from_site_temp IS NULL		   		)
					OR (@v_to_site_temp				= '' or @v_to_site_temp IS NULL			   		)
					OR (@v_new_incoterms_temp		= '' or @v_new_incoterms_temp IS NULL			)
					OR (@v_new_transport_mode_temp	= '' or @v_new_transport_mode_temp IS NULL		)
					OR (@v_new_route_id_temp		= '' or @v_new_route_id_temp IS NULL			)
					OR (@v_new_d_contry_temp		= '' or @v_new_d_contry_temp IS NULL	 		)
					OR (@v_new_d_port_code_temp		= '' or @v_new_d_port_code_temp IS NULL	  		)
					OR (@v_new_a_country_temp		= '' or @v_new_a_country_temp IS NULL	  		)
					OR (@v_new_a_port_code_temp		= '' or @v_new_a_port_code_temp IS NULL	 		)
					OR (@v_new_customer_lt_temp		= '' or @v_new_customer_lt_temp IS NULL	 		)
					OR (@v_new_to_country_temp		= '' or @v_new_to_country_temp IS NULL			)
					OR (@v_new_to_city_temp			= '' or @v_new_to_city_temp IS NULL				)
					)
					BEGIN
					
			
						SELECT 'X' AS result_code, NULL AS Request_no;

						SET @v_log_type = 'END';
						SET @v_log_message = '########## END of procedure ##########';
						SET @v_description = '';
						SET @d_event_date = SYSDATETIME();
						EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

						RETURN;

					END
			IF @v_active_flag <> 'I'
			BEGIN
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
				SET @v_shipment_date = REPLACE(SUBSTRING(@v_shipment_date,1,10),'-','')
				--SET @v_new_eta_date = REPLACE(SUBSTRING(@v_new_eta_date,1,10),'-','')

				/* 2019.10.29 출발일 기준 항차를 고려한 ETA_DATE 계산*/
				SET @v_new_eta_date = [dbo].[FN_GET_SSP_ETA_DATE](@v_division_id, @v_new_bod_id_temp, @v_shipment_date) 

				IF @v_edit_main = 'Y'
					BEGIN
						SET @v_check_need_yn = 'Y'
					END	
			
				/* 2020.06.23 ETD_DATE, FCST_ETD_DATE 를 YYYYMMDD 와 같은 날짜로 변경 되도록 수정 */
				UPDATE SSP_ANL_SHIP_CONFIRM
					SET YYYYMMDD = @v_shipment_date
						,QTY = @v_shipment_qty
						,BEFORE_QTY = @v_before_qty
						,BOD_ID = @v_new_bod_id_temp
						,ROUTE_ID = @v_new_route_id_temp
						,INCOTERMS = @v_new_incoterms_temp
						,D_COUNTRY = @v_new_d_contry_temp
						,D_PORT_CODE = @v_new_d_port_code_temp
						,A_COUNTRY = @v_new_a_country_temp
						,A_PORT_CODE = @v_new_a_port_code_temp
						,TO_COUNTRY = @v_new_to_country_temp
						,TO_CITY = @v_new_to_city_temp
						,TRANSPORT_MODE = @v_new_transport_mode_temp
						,ETD_DATE = @v_shipment_date			-- @v_new_etd_date
						,ETA_DATE = @v_new_eta_date
						,FCST_ETD_DATE = @v_shipment_date		-- @v_new_etd_date
						,FCST_ETA_DATE = @v_new_eta_date
						,CUSTOMER_LT = @v_new_customer_lt_temp
						,REMARKS = @v_remarks
						,REMARKS2 = @v_remarks2
						,REMARKS3 = @v_remarks3
						,CHECK_NEED_YN = @v_check_need_yn
						,LAST_UPDATED_BY = @p_user_id
						,LAST_UPDATE_DATE = @v_create_date
				WHERE CONFIRM_ID = @v_confirm_id;

				IF @v_edit_main = 'Y'
				
					SELECT TOP 1 
						@v_change_req_no = CHANGE_REQ_NO
					FROM SSP_ANL_SHIP_CONFIRM_CHG_REQ_de a WITH(NOLOCK)
					WHERE A.CONFIRM_ID = @v_confirm_id
						AND A.VALID_YN = 'Y'
					ORDER BY LAST_UPDATE_DATE desc;

				IF len(@v_change_req_no) > 0
				BEGIN
					--이력저장
					EXEC [dbo].[PR_SSP_ANL_SHIP_CONFIRM_HIST] @v_change_req_no,@p_user_id,''
					;
					--SCS I/F
					IF @v_division_id = '82'
					BEGIN
						EXEC [dbo].[PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_SCS] 'B' , @v_change_req_no
						;
					END;

					SELECT @Mail_CHK = COUNT(*) FROM SSP_MST_SEND_MAIL_REQ WITH(NOLOCK) WHERE CHANGE_REQ_NO = @v_change_req_no;
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
				;

			END;
			
			/*2020-07-24 KIMYONGHO 신규생성 기능 추가*/
			IF @v_active_flag = 'I'
			BEGIN

				--SELECT @v_infseqno = CONVERT(CHAR(8),GETDATE(),112) + RIGHT( '00000'+ CONVERT(VARCHAR,ISNULL(MAX(RIGHT(IFSEQNO,6)),0)+1 ) ,6)
				--FROM XIF_ERP_SHIP_PLAN_CONFIRM_S_SN
				--WHERE IFSEQNO LIKE CONVERT(CHAR(8),GETDATE(),112) +'%' ;

				SELECT @v_infseqno = CONVERT(CHAR(8),GETDATE(),112) + RIGHT( '000000'+ CONVERT(nvarchar,NEXT VALUE FOR DBO.SEQ1_XIF_ERP_IFSEQNO) ,6);

				-- 확정구간 마지막 일자( 현재일 기준 + 9 = PLANS_START_YYYYMMDD + 10)
				SET @v_last_confirm_date =  CONVERT ( VARCHAR(8), GETDATE() + 9 , 112) ;

				SET @v_description = '';
				SET @d_event_date = SYSDATETIME();--[dbo].[FN_MULTY_TIME](@p_time_zone);
				EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
				
				-- NEW CONFIRM 생성 CHECK 확인==========================================================================================
				DECLARE @v_tmp_fn_time_zone NVARCHAR(8);
				DECLARE @v_tmp_seq_confirm	NVARCHAR(20);
				SET @v_tmp_fn_time_zone = CONVERT(VARCHAR(8), [dbo].[FN_MULTY_TIME](NULL), 112);
				SET @v_tmp_seq_confirm = CONVERT(NVARCHAR, NEXT VALUE FOR SEQ1_SSP_ANL_SHIP_CONFIRM_ID);
				SET @v_new_confirm_id = 'C'+@v_tmp_fn_time_zone + RIGHT('000000' + @V_TMP_SEQ_CONFIRM,6)
				--//====================================================================================================================================

				SELECT  @v_plan_start_yyyymmdd  = MAX(PLAN_START_YYYYMMDD)
						, @v_seq                  = MAX(PLAN_SEQ)
					FROM SSP_PLAN_VERSION_V
					WHERE PLAN_TYPE    = 'SP'
					AND DIVISION_ID  = @V_division_id 
					AND CONFIRM_FLAG = 'Y'
					AND PLAN_START_YYYYMMDD = (SELECT MAX(PLAN_START_YYYYMMDD)
									FROM SSP_PLAN_VERSION_V T
									WHERE T.DIVISION_ID = @V_division_id 
									AND   T.plan_type  = 'SP'
									AND   T.CONFIRM_FLAG = 'Y');


				IF @v_plan_start_yyyymmdd IS NULL
				BEGIN
					SET @v_plan_start_yyyymmdd = CONVERT(VARCHAR(8), CONVERT(DATETIME, GETDATE()), 112);
					SET @v_seq = 1;
				END



				SET @v_qty = 0;
				SET @v_before_qty = 0;

				SELECT @v_qty = QTY, @v_before_qty = BEFORE_QTY
				FROM SSP_ANL_SHIP_CONFIRM WITH(NOLOCK)
				WHERE CONFIRM_ID = @v_confirm_id

				IF @v_qty != @v_shipment_qty * 1
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
				SET @v_shipment_date = REPLACE(SUBSTRING(@v_shipment_date,1,10),'-','')

				/* 2019.10.29 출발일 기준 항차를 고려한 ETA_DATE 계산*/
				SET @v_new_eta_date = [dbo].[FN_GET_SSP_ETA_DATE](@v_division_id, @v_new_bod_id_temp, @v_shipment_date) 

				IF @v_edit_main = 'Y'
					BEGIN
						SET @v_check_need_yn = 'Y'
					END	
				------------------------------------------------------------------------------------------------------------- 
				-- 1. SHIP_CONFIRM 입력 : 출하확정 SSP_ANL_SHIP_CONFIRM
				-- 신규 건만 생성
				------------------------------------------------------------------------------------------------------------- 

				INSERT INTO SSP_ANL_SHIP_CONFIRM(
					CONFIRM_ID ,SHIPMENT_STATUS ,DIVISION_ID ,PLAN_START_YYYYMMDD ,PLAN_TYPE ,SEQ ,ITEM_ID ,FROM_SITE ,TO_SITE
					,YYYYMMDD ,PLANNED_QTY ,QTY ,BOD_ID ,ROUTE_ID ,BIZ_TYPE ,PROJECT_CODE ,FCST_TYPE ,FCST_ETD_DATE
					,FCST_ETA_DATE ,ETD_DATE ,ETA_DATE ,INCOTERMS ,TRANSPORT_MODE ,D_COUNTRY ,D_PORT_CODE ,A_COUNTRY
					,A_PORT_CODE ,CUSTOMER_LT ,TO_COUNTRY ,TO_CITY ,FROM_SITE_TYPE ,FROM_SITE_PLANT_ID ,FROM_SITE_VENDOR_ID
					,FROM_SITE_SOLDTO_CODE ,FROM_SITE_SHIPTO_CODE ,FROM_SITE_COMPANY_ID ,TO_SITE_TYPE ,TO_SITE_PLANT_ID
					,TO_SITE_VENDOR_ID ,TO_SITE_SOLDTO_CODE ,TO_SITE_SHIPTO_CODE ,TO_SITE_COMPANY_ID  ,CHANGE_TYPE
					,CREATED_BY ,CREATION_DATE ,LAST_UPDATED_BY ,LAST_UPDATE_DATE
					,ELECTRODE_YN ,ORIGIN_FROM_DIVISION_ID ,ORIGIN_TO_DIVISION_ID, REQUESTOR ,BEFORE_QTY ,CHECK_NEED_YN	,PACKAGE_TYPE_CODE, FACTORY_ID, ELECTRODE_TYPE
					,PACKAGE_QTY
					,DOM_EXP
					,REMARKS, REMARKS2, REMARKS3
					,ATTRIBUTE10
				) 
					
				SELECT @v_new_confirm_id, 'C', A.DIVISION_ID, @v_plan_start_yyyymmdd, 'SP', @v_seq, A.ITEM_ID, A.FROM_SITE, A.TO_SITE
					, @v_shipment_date, 0, @v_shipment_qty * 1, @v_new_bod_id_temp, @v_new_route_id_temp, A.BIZ_TYPE,  A.PROJECT_CODE, A.FCST_TYPE, @v_shipment_date
					, @v_new_eta_date, @v_shipment_date, @v_new_eta_date, @v_new_incoterms_temp, @v_new_transport_mode_temp, @v_new_d_contry_temp, @v_new_d_port_code_temp, @v_new_a_country_temp
					, @v_new_a_port_code_temp, @v_new_customer_lt_temp, @v_new_to_country_temp, @v_new_to_city_temp, A.FROM_SITE_TYPE , A.FROM_SITE_PLANT_ID , A.FROM_SITE_VENDOR_ID
					, A.FROM_SITE_SOLDTO_CODE , A.FROM_SITE_SHIPTO_CODE , A.FROM_SITE_COMPANY_ID 
					, dbo.FN_GET_SSP_SITE_INFO_EXCEPTION(@v_division_id,A.FROM_SITE, A.TO_SITE, 'SITE_TYPE')
					, A.TO_SITE_PLANT_ID
					, A.TO_SITE_VENDOR_ID , A.TO_SITE_SOLDTO_CODE , A.TO_SITE_SHIPTO_CODE 
					, dbo.FN_GET_SSP_SITE_INFO_EXCEPTION(@v_division_id,A.FROM_SITE, A.TO_SITE, 'COMPANY_ID')
					, 'C'
					, @p_user_id ,@v_create_date ,@p_user_id ,@v_create_date
					, A.ELECTRODE_YN , A.ORIGIN_FROM_DIVISION_ID , A.ORIGIN_TO_DIVISION_ID,@p_user_id  ,0 ,'Y', A.PACKAGE_TYPE_CODE, A.FACTORY_ID, A.ELECTRODE_TYPE
					, CEILING(CASE WHEN E.PACKAGE_TYPE_CODE = 'BX' THEN CEILING(@v_shipment_qty * isnull(E.CONVERT_TO_PC_ROLL_LENGTH ,1) ) * isnull(E.BOX_PER_CUT ,1)
 													WHEN E.PACKAGE_TYPE_CODE = 'SC' THEN CEILING(@v_shipment_qty * isnull(E.CONVERT_TO_PC_ROLL_LENGTH ,1) ) * isnull(E.STEELCRATE_PER_CUT ,1)
 													WHEN E.PACKAGE_TYPE_CODE = 'SR' THEN CEILING(@v_shipment_qty * isnull(E.CONVERT_TO_PC_ROLL_LENGTH ,1) ) * isnull(E.STEELRACK_PER_CUT ,1)
 												ELSE NULL  END)
					, A.DOM_EXP
					, @v_remarks, @v_remarks2, @v_remarks3
					, NULL
				FROM SSP_ANL_SHIP_CONFIRM A WITH(NOLOCK)
				LEFT OUTER JOIN SSP_MST_SITE_ITEM_EE_V E WITH(NOLOCK) 
						ON A.DIVISION_ID = (CASE WHEN A.BIZ_TYPE = 'E' THEN E.DIVISION_ID ELSE  E.ASSY_DIVISION_ID END)
					AND A.FROM_SITE        = (CASE WHEN A.BIZ_TYPE = 'E' THEN E.SCM_SITE_ID ELSE  E.ASSY_SCM_SITE_ID END)
					AND A.ITEM_ID          = E.ITEM_ID

				WHERE CONFIRM_ID = @v_confirm_id

				;

				------------------------------------------------------------------------------------------------------------- 
				-- 2. SHIP_CONFIRM HISTORY 입력 : 출하확정 SSP_ANL_SHIP_CONFIRM_H
				-- 신규 건만 생성
				------------------------------------------------------------------------------------------------------------- 

				INSERT INTO SSP_ANL_SHIP_CONFIRM_H (
				HISTORY_SEQ
				,CONFIRM_ID
				,CHANGE_TYPE
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
				,ERP_SO_NO
				,ERP_SO_ITEM_NO
				,ERP_DO_NO
				,ERP_STATUS
				,CREATED_BY
				,CREATION_DATE
				,LAST_UPDATED_BY
				,LAST_UPDATE_DATE
				,HISTORY_CREATION_DATE
				,ELECTRODE_YN            
				,ELECTRODE_TYPE				   
				,ORIGIN_FROM_DIVISION_ID	
				,ORIGIN_TO_DIVISION_ID	
				,BEFORE_QTY             
				,REMARKS   
				,CHECK_NEED_YN  
				)
					SELECT NEXT VALUE FOR  SEQ1_SSP_ANL_SHIP_CONFIRM_H  -- HISTORY_SEQ
				,CONFIRM_ID
				,CHANGE_TYPE
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
				,NULL -- CHANGE_REQ_NO
				,NULL -- ERP_SO_NO
				,NULL -- ERP_SO_ITEM_NO
				,NULL -- ERP_DO_NO
				,NULL -- ERP_STATUS
				,@p_user_id    -- CREATED_BY
				,@v_create_date  -- CREATION_DATE
				,@p_user_id    -- LAST_UPDATED_BY
				,@v_create_date  -- LAST_UPDATE_DATE
				,@v_create_date  -- HISTORY_CREATION_DATE
				,ELECTRODE_YN            
				,ELECTRODE_TYPE				   
				,ORIGIN_FROM_DIVISION_ID	
				,ORIGIN_TO_DIVISION_ID
				,BEFORE_QTY             
				,REMARKS   
				,CHECK_NEED_YN  					
				FROM SSP_ANL_SHIP_CONFIRM WITH (NOLOCK)
				WHERE  1=1			
				AND CONFIRM_ID = @v_new_confirm_id
				;


				INSERT INTO XIF_ERP_SHIP_PLAN_CONFIRM_S_SN
				( 
				 IFSEQNO
				,CONFIRM_ID
				,SHIPMENT_STATUS
				,LAST_CONFIRM_DATE
				,VERSION_TYPE
				,SALES_COMPANY_ID
				,DIVISION_ID
				,ITEM_ID
				,FROM_SITE
				,TO_SITE
				,YYYYMMDD
				,QTY
				,BOD_ID
				,ROUTE_ID
				,OPERATION_GROUP
				,BIZ_TYPE
				,PROJECT_CODE
				,FCST_TYPE
				,FCST_ETD_DATE
				,FCST_ETA_DATE
				,ETD_DATE
				,ETA_DATE
				,INCOTERMS
				,INCOTERMS2
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
				,BUILDING
				,REMARK
				,CUSTOMER_REQ
				,CHANGE_CODE
				,CHANGE_CODE_NAME
				,REQUESTOR
				,TRANSFER_FLAG
				,TRANSFER_DATE
				,CREATED_BY
				,CREATION_DATE
				,LAST_UPDATED_BY
				,LAST_UPDATE_DATE
				,ATTRIBUTE1
				,ATTRIBUTE2
				,ATTRIBUTE3
				,ATTRIBUTE4
				,ATTRIBUTE5
				,ATTRIBUTE6
				,ATTRIBUTE7
				,ATTRIBUTE8
				,ATTRIBUTE9
				,ATTRIBUTE10
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
				SELECT 
					 A.IFSEQNO
					,A.CONFIRM_ID
					,A.SHIPMENT_STATUS
					,A.LAST_CONFIRM_DATE
					,A.VERSION_TYPE
					,ISNULL(X1.NEW_VALUE1, A.SALES_COMPANY_ID)		AS SALES_COMPANY_ID
					--,A.DIVISION_ID
					,A.DIVISION_ID
					,A.ITEM_ID
					,ISNULL(X2.NEW_VALUE1, A.FROM_SITE)				AS FROM_SITE
					,ISNULL(X3.NEW_VALUE1, A.TO_SITE)				AS TO_SITE
					,A.YYYYMMDD
					,A.QTY
					,A.BOD_ID
					,A.ROUTE_ID
					,A.OPERATION_GROUP
					,A.BIZ_TYPE
					,A.PROJECT_CODE
					,A.FCST_TYPE
					,A.FCST_ETD_DATE
					,A.FCST_ETA_DATE
					,A.ETD_DATE
					,A.ETA_DATE
					,A.INCOTERMS
					,A.INCOTERMS2
					,A.TRANSPORT_MODE
					,A.D_COUNTRY
					,A.D_PORT_CODE
					,A_COUNTRY
					,A_PORT_CODE
					,A.CUSTOMER_LT
					,A.TO_COUNTRY
					,A.TO_CITY
					,A.FROM_SITE_TYPE
					,ISNULL(X4.NEW_VALUE1, A.FROM_SITE_PLANT_ID)		AS FROM_SITE_PLANT_ID
					,ISNULL(X5.NEW_VALUE1, A.FROM_SITE_VENDOR_ID)		AS FROM_SITE_VENDOR_ID
					,ISNULL(X6.NEW_VALUE1, A.FROM_SITE_SOLDTO_CODE)		AS FROM_SITE_SOLDTO_CODE
					,ISNULL(X7.NEW_VALUE1, A.FROM_SITE_SHIPTO_CODE)		AS FROM_SITE_SHIPTO_CODE
					,ISNULL(X8.NEW_VALUE1, A.FROM_SITE_COMPANY_ID)		AS FROM_SITE_COMPANY_ID
					,A.TO_SITE_TYPE
					,ISNULL(X9.NEW_VALUE1, A.TO_SITE_PLANT_ID)			AS TO_SITE_PLANT_ID
					,ISNULL(X10.NEW_VALUE1, A.TO_SITE_VENDOR_ID)		AS TO_SITE_VENDOR_ID
					,ISNULL(X11.NEW_VALUE1, A.TO_SITE_SOLDTO_CODE)		AS TO_SITE_SOLDTO_CODE
					,ISNULL(X12.NEW_VALUE1, A.TO_SITE_SHIPTO_CODE)		AS TO_SITE_SHIPTO_CODE
					,ISNULL(X13.NEW_VALUE1, A.TO_SITE_COMPANY_ID)		AS TO_SITE_COMPANY_ID
					,A.BUILDING
					,A.REMARK
					,A.CUSTOMER_REQ
					,A.CHANGE_CODE
					,A.CHANGE_CODE_NAME
					,A.REQUESTOR
					,A.TRANSFER_FLAG
					,A.TRANSFER_DATE
					,A.CREATED_BY
					,A.CREATION_DATE
					,A.LAST_UPDATED_BY
					,A.LAST_UPDATE_DATE
					,A.ATTRIBUTE1
					,A.ATTRIBUTE2
					,A.ATTRIBUTE3
					,A.ATTRIBUTE4
					,A.ATTRIBUTE5
					,A.ATTRIBUTE6
					,A.ATTRIBUTE7
					,A.ATTRIBUTE8
					,A.ATTRIBUTE9
					,A.ATTRIBUTE10
					/*----------------------------------------------------------------------------------------
						2020.06.30 : KBK
						I/F 추가요청으로 인하여 컬럼 추가 전극에서만 사용. DDL 표준을 맞추기 위하여 추가함 
					------------------------------------------------------------------------------------------*/
					,A.PACKAGE_TYPE_CODE 
					,A.FACTORY_ID
					,A.PACKAGE_QTY
					,A.DOM_EXP
					,NULL       AS ERP_ATTR1
					,NULL       AS ERP_ATTR2
					,NULL       AS ERP_ATTR3
					,A.TO_SITE_PLANT_ID AS ERP_ATTR4-- ERP_ATTR4-- NERP에서 원본 정보 참고용 (2025-04-23)
					,NULL       AS ERP_ATTR5
				FROM
				(
					SELECT 
							 A.IFSEQNO
							,A.CONFIRM_ID
							,A.SHIPMENT_STATUS
							,A.LAST_CONFIRM_DATE
							,A.VERSION_TYPE
							,A.SALES_COMPANY_ID
							--,A.DIVISION_ID
							,D.ATTRIBUTE3 AS DIVISION_ID
							,A.ITEM_ID
							,A.FROM_SITE
							,A.TO_SITE
							,A.YYYYMMDD
							,A.QTY
							,A.BOD_ID
							,A.ROUTE_ID
							,A.OPERATION_GROUP
							,A.BIZ_TYPE
							,A.PROJECT_CODE
							,A.FCST_TYPE
							,A.FCST_ETD_DATE
							,A.FCST_ETA_DATE
							,A.ETD_DATE
							,A.ETA_DATE
							,A.INCOTERMS
							,A.INCOTERMS2
							,A.TRANSPORT_MODE
							,A.D_COUNTRY
							,A.D_PORT_CODE
							,A_COUNTRY
							,A_PORT_CODE
							,A.CUSTOMER_LT
							,A.TO_COUNTRY
							,A.TO_CITY
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
							,A.BUILDING
							,A.REMARK
							,A.CUSTOMER_REQ
							,A.CHANGE_CODE
							,A.CHANGE_CODE_NAME
							,A.REQUESTOR
							,A.TRANSFER_FLAG
							,A.TRANSFER_DATE
							,A.CREATED_BY
							,A.CREATION_DATE
							,A.LAST_UPDATED_BY
							,A.LAST_UPDATE_DATE
							,A.ATTRIBUTE1
							,A.ATTRIBUTE2
							,A.ATTRIBUTE3
							,A.ATTRIBUTE4
							,A.ATTRIBUTE5
							,A.ATTRIBUTE6
							,A.ATTRIBUTE7
							,A.ATTRIBUTE8
							,A.ATTRIBUTE9
							,A.ATTRIBUTE10
							/*----------------------------------------------------------------------------------------
								2020.06.30 : KBK
								I/F 추가요청으로 인하여 컬럼 추가 전극에서만 사용. DDL 표준을 맞추기 위하여 추가함 
							------------------------------------------------------------------------------------------*/
							,E.PACKAGE_TYPE_CODE 
							,E.FACTORY_ID
							,CEILING(CASE WHEN E.PACKAGE_TYPE_CODE = 'BX' THEN CEILING(A.QTY * isnull(E.CONVERT_TO_PC_ROLL_LENGTH ,1) ) * isnull(E.BOX_PER_CUT ,1)
 											WHEN E.PACKAGE_TYPE_CODE = 'SC' THEN CEILING(A.QTY * isnull(E.CONVERT_TO_PC_ROLL_LENGTH ,1) ) * isnull(E.STEELCRATE_PER_CUT ,1)
 											WHEN E.PACKAGE_TYPE_CODE = 'SR' THEN CEILING(A.QTY * isnull(E.CONVERT_TO_PC_ROLL_LENGTH ,1) ) * isnull(E.STEELRACK_PER_CUT ,1)
 								ELSE ISNULL(A.QTY,0)  END)		AS PACKAGE_QTY
							,E.DOM_EXP_TYPE AS DOM_EXP
					FROM   (
							SELECT 
								@v_infseqno  AS  IFSEQNO -- IFSEQNO
								,A.CONFIRM_ID
								,'A'  AS  SHIPMENT_STATUS  -- I_PLGB  A: 확정  
								,@v_last_confirm_date   AS LAST_CONFIRM_DATE -- I_DATE  확정구간 마지막 일자 
								,'B' AS VERSION_TYPE  -- B:NEW/A:OLD 
								,ISNULL(C.ATTRIBUTE2, B.ATTRIBUTE2)  AS SALES_COMPANY_ID
								,CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END  AS DIVISION_ID
								,A.ITEM_ID AS ITEM_ID
								,A.FROM_SITE
								,A.TO_SITE
								,A.YYYYMMDD
								,A.QTY
								,A.BOD_ID
								,A.ROUTE_ID
								,A.BIZ_TYPE AS OPERATION_GROUP
								,A.BIZ_TYPE
								,CASE WHEN A.PROJECT_CODE IS NULL OR A.PROJECT_CODE ='' OR A.PROJECT_CODE ='-' THEN 'TBD' ELSE A.PROJECT_CODE END   AS PROJECT_CODE
								,A.FCST_TYPE
								,A.FCST_ETD_DATE
								,A.FCST_ETA_DATE
								,A.ETD_DATE
								,A.ETA_DATE
								,A.INCOTERMS    AS INCOTERMS
								,NULL AS INCOTERMS2
								,A.TRANSPORT_MODE
								,A.D_COUNTRY
								,A.D_PORT_CODE
								,A.A_COUNTRY
								,A.A_PORT_CODE
								,A.CUSTOMER_LT
								,A.TO_COUNTRY
								,A.TO_CITY
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
								,NULL AS BUILDING
								,NULL AS REMARK
								,NULL AS CUSTOMER_REQ
								,NULL AS CHANGE_CODE
								,NULL AS CHANGE_CODE_NAME
								,A.REQUESTOR AS REQUESTOR
								,'N'					 AS TRANSFER_FLAG
								,GETDATE()				 AS TRANSFER_DATE
								,A.LAST_UPDATED_BY       AS CREATED_BY
								,GETDATE()				 AS CREATION_DATE
								,A.LAST_UPDATED_BY       AS LAST_UPDATED_BY
								,GETDATE()				 AS LAST_UPDATE_DATE
								,NULL AS ATTRIBUTE1
								,NULL AS ATTRIBUTE2
								,NULL AS ATTRIBUTE3
								,NULL AS ATTRIBUTE4
								,NULL AS ATTRIBUTE5
								,NULL AS ATTRIBUTE6
								,NULL AS ATTRIBUTE7
								,NULL AS ATTRIBUTE8
								,NULL AS ATTRIBUTE9
								,A.ELECTRODE_YN AS ATTRIBUTE10
							FROM SSP_ANL_SHIP_CONFIRM A WITH(NOLOCK)
								 LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL  B WITH(NOLOCK) 
								 ON   B.LOOKUP_TYPE = 'CELL_SHIP_FROM_TO' 
								 AND  B.VALID_YN   = 'Y'
								 AND  B.SEGMENT1 = A.FROM_SITE_COMPANY_ID 
								 AND  B.SEGMENT3 = A.FROM_SITE
								 AND  B.SEGMENT4 = A.TO_SITE_COMPANY_ID 
								 AND  B.SEGMENT5 = A.TO_SITE 
								 LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL  C WITH(NOLOCK) 
								 ON   C.LOOKUP_TYPE = 'ELECTRODE_SHIP_FROM_TO' 
								 AND  C.VALID_YN   = 'Y'
								 AND  C.SEGMENT1 = A.FROM_SITE_COMPANY_ID 
								 AND  C.SEGMENT3 = A.FROM_SITE
								 AND  C.SEGMENT4 = A.TO_SITE_COMPANY_ID 
								 AND  C.ATTRIBUTE1 = A.TO_SITE 
							WHERE 1=1 
							AND   A.CONFIRM_ID      =  @v_new_confirm_id
							AND   ISNULL(A.QTY,0) <> 0  -- 0은IF 제외 
						   ) A
						   JOIN SCM_MST_DIVISION AS D WITH(NOLOCK)
							ON A.DIVISION_ID   = D.DIVISION_ID
							LEFT OUTER JOIN SSP_MST_SITE_ITEM_EE_V E WITH(NOLOCK)
							ON A.DIVISION_ID = (CASE WHEN A.BIZ_TYPE = 'E' THEN E.DIVISION_ID ELSE  E.ASSY_DIVISION_ID END)
						AND A.FROM_SITE        = (CASE WHEN A.BIZ_TYPE = 'E' THEN E.SCM_SITE_ID ELSE  E.ASSY_SCM_SITE_ID END)
						AND A.ITEM_ID          = E.ITEM_ID
					WHERE  1 = 1
				) A
				LEFT OUTER JOIN NERP_CONV_MASTER X1 WITH(NOLOCK) ON X1.CODETYPE = 'COMPANY_ID'	AND A.SALES_COMPANY_ID = X1.OLD_VALUE1
				LEFT OUTER JOIN NERP_CONV_MASTER X2 WITH(NOLOCK) ON X2.CODETYPE = 'SCP_SITE_ID' AND A.FROM_SITE = X2.OLD_VALUE1
				LEFT OUTER JOIN NERP_CONV_MASTER X3 WITH(NOLOCK) ON X3.CODETYPE = 'SCP_SITE_ID' AND A.TO_SITE = X3.OLD_VALUE1
				LEFT OUTER JOIN NERP_CONV_MASTER X4 WITH(NOLOCK) ON X4.CODETYPE = 'PLANT_ID'	AND A.FROM_SITE_PLANT_ID = X4.OLD_VALUE1
				LEFT OUTER JOIN NERP_CONV_MASTER X5 WITH(NOLOCK) ON X5.CODETYPE = 'VENDOR_ID'	AND A.FROM_SITE_VENDOR_ID = X5.OLD_VALUE1
				LEFT OUTER JOIN NERP_CONV_MASTER X6 WITH(NOLOCK) ON X6.CODETYPE = 'END_CUSTOMER_ID' AND A.FROM_SITE_SOLDTO_CODE = X6.OLD_VALUE1
				LEFT OUTER JOIN NERP_CONV_MASTER X7 WITH(NOLOCK) ON X7.CODETYPE = 'END_CUSTOMER_ID' AND A.FROM_SITE_SHIPTO_CODE = X7.OLD_VALUE1
				LEFT OUTER JOIN NERP_CONV_MASTER X8 WITH(NOLOCK) ON X8.CODETYPE = 'COMPANY_ID' AND A.FROM_SITE_COMPANY_ID = X8.OLD_VALUE1
				LEFT OUTER JOIN NERP_CONV_MASTER X9 WITH(NOLOCK) ON X9.CODETYPE = 'PLANT_ID'	AND A.TO_SITE_PLANT_ID = X9.OLD_VALUE1
				LEFT OUTER JOIN NERP_CONV_MASTER X10 WITH(NOLOCK) ON X10.CODETYPE = 'VENDOR_ID'	AND A.TO_SITE_VENDOR_ID = X10.OLD_VALUE1
				LEFT OUTER JOIN NERP_CONV_MASTER X11 WITH(NOLOCK) ON X11.CODETYPE = 'END_CUSTOMER_ID' AND A.TO_SITE_SOLDTO_CODE = X11.OLD_VALUE1
				LEFT OUTER JOIN NERP_CONV_MASTER X12 WITH(NOLOCK) ON X12.CODETYPE = 'END_CUSTOMER_ID' AND A.TO_SITE_SHIPTO_CODE = X12.OLD_VALUE1
				LEFT OUTER JOIN NERP_CONV_MASTER X13 WITH(NOLOCK) ON X13.CODETYPE = 'COMPANY_ID' AND  A.TO_SITE_COMPANY_ID = X13.OLD_VALUE1

				;

				-- MKT FCST - SSP Sync 신규 생성 건 대상
				EXEC PR_DM_SSP_CONFIRM_SYNC @p_division_id, @v_new_confirm_id;

				--SET @v_confirm_id = @v_new_confirm_id;

				-- 240610 jilee 신규 건 Change Req 정보 입력
				IF @v_chk_req = 0
				BEGIN
					SET @v_max_req_no = 'R'+CONVERT(VARCHAR(8), @v_create_date, 112) + RIGHT('000000' + CONVERT(NVARCHAR, NEXT VALUE FOR SEQ1_SSP_ANL_SHIP_CHG_REQ_NO),6)

					SELECT @v_user_dept_id = DEPT_ID FROM TB_FX_USER WITH(NOLOCK) WHERE USERID = @p_user_id
					
					SELECT 	@v_electrode_yn = ELECTRODE_YN,
					        @v_electrode_type = ELECTRODE_TYPE,
							@v_origin_from_division_id = ORIGIN_FROM_DIVISION_ID,
							@v_origion_to_division_id = ORIGIN_TO_DIVISION_ID
							FROM SSP_ANL_SHIP_CONFIRM A WITH(NOLOCK)
							WHERE CONFIRM_ID = @v_new_confirm_id;

					INSERT INTO SSP_ANL_SHIP_CONFIRM_CHG_REQ
					(
						CHANGE_REQ_NO,				CHANGE_TYPE,					CHANGE_REQ_STATUS,				DIVISION_ID,
						FROM_SITE,					REQUEST_TITLE,					REQUEST_USER,					REQUEST_DEPT,
						REQUEST_TIME,				APPROVAL_USER,					APPROVAL_DEPT,					APPROVAL_TIME,
						CHANGE_REASON_CODE,			CHANGE_REASON_DETAIL,			REJECT_REASON,					VALID_YN,
						CREATED_BY,					CREATION_DATE,					LAST_UPDATED_BY,				LAST_UPDATE_DATE,
						ELECTRODE_YN,				ELECTRODE_TYPE,					ORIGIN_FROM_DIVISION_ID,		ORIGIN_TO_DIVISION_ID
					)
					VALUES 
					(	
						@v_max_req_no,				'A',							'A',							@v_division_id, 
						@v_from_site_temp,			'New Adjustment' ,				@p_user_id,						@v_user_dept_id, 
						@v_create_date,				@p_user_id,						@v_user_dept_id,				@v_create_date, 						
						'T07',                     'T07',		                    NULL,							'Y', 
						@p_user_id,					@v_create_date,					@p_user_id,						@v_create_date, 
						@v_electrode_yn,			@v_electrode_type,				@v_origin_from_division_id,		@v_origion_to_division_id
					);
					--Request_No값 각기(단일) 생성
					SET @v_chk_req = 1;
				END;

				IF ISNULL(@v_shipment_qty, '') = '' OR @v_shipment_qty IS NULL
				BEGIN
					SET @v_shipment_qty = NULL
				END

				IF ISNULL(@v_shipment_date, '') = '' OR @v_shipment_date IS NULL
				BEGIN
					SET @v_shipment_date = ''
				END

				SET @v_new_etd_date = REPLACE(SUBSTRING(@v_new_etd_date,1,10),'-','')
				--SET @v_new_eta_date = REPLACE(SUBSTRING(@v_new_eta_date,1,10),'-','')
				SET @v_shipment_date = REPLACE(SUBSTRING(@v_shipment_date,1,10),'-','')

				/* 2019.09.04 etd:shipdate, eta:etd+lt_day로 셋팅*/
				IF ISNULL(@v_shipment_date,'')!='' and LEN(@v_shipment_date)=8 and ISNULL(@v_new_customer_lt,'')!='' and LEN(@v_new_customer_lt)>0
					BEGIN
						SET @v_new_etd_date = @v_shipment_date
						;
						--SET @v_new_eta_date = convert(VARCHAR(8), dateadd(dd, convert(int, @v_new_customer_lt), convert(datetime,@v_new_etd_date)),112)
						;
					END

				/* 2019.10.29 출발일 기준 항차를 고려한 ETA_DATE 계산*/
				SET @v_new_eta_date = [dbo].[FN_GET_SSP_ETA_DATE](@p_division_id, @v_new_bod_id_temp, @v_shipment_date) 

				INSERT SSP_ANL_SHIP_CONFIRM_CHG_REQ_de
				(	
					CHANGE_REQ_NO,								CONFIRM_ID,							NEW_YN,										DIVISION_ID,
					ITEM_ID,									FROM_SITE,							TO_SITE,									YYYYMMDD,
					QTY,										BOD_ID,								ROUTE_ID,									BIZ_TYPE,
					PROJECT_CODE,								FCST_TYPE,							FCST_ETD_DATE,								FCST_ETA_DATE,
					ETD_DATE,									ETA_DATE,							INCOTERMS,									TRANSPORT_MODE,
					D_COUNTRY,									D_PORT_CODE,						A_COUNTRY,									A_PORT_CODE,
					CUSTOMER_LT,								TO_COUNTRY,							TO_CITY,									NEW_YYYYMMDD,
					NEW_QTY,									NEW_BOD_ID,							NEW_ROUTE_ID,								NEW_ETD_DATE,
					NEW_ETA_DATE,								NEW_INCOTERMS,						NEW_TRANSPORT_MODE,							NEW_D_COUNTRY,
					NEW_D_PORT_CODE,							NEW_A_COUNTRY,						NEW_A_PORT_CODE,							NEW_CUSTOMER_LT,
					NEW_TO_COUNTRY,								NEW_TO_CITY,						FROM_SITE_TYPE,								FROM_SITE_PLANT_ID,
					FROM_SITE_VENDOR_ID,						FROM_SITE_SOLDTO_CODE,				FROM_SITE_SHIPTO_CODE,						FROM_SITE_COMPANY_ID,
					TO_SITE_TYPE,								TO_SITE_PLANT_ID,					TO_SITE_VENDOR_ID,							TO_SITE_SOLDTO_CODE,
					TO_SITE_SHIPTO_CODE,						TO_SITE_COMPANY_ID,					ERP_SO_NO,									ERP_SO_ITEM_NO,
					ERP_DO_NO,									ERP_STATUS,							VALID_YN,									ATTRIBUTE1,
					CREATED_BY,									CREATION_DATE,						LAST_UPDATED_BY,							LAST_UPDATE_DATE,
					ELECTRODE_YN,								ELECTRODE_TYPE,						ORIGIN_FROM_DIVISION_ID,					ORIGIN_TO_DIVISION_ID,
					REMARKS,									REMARKS2,							REMARKS3,									REQUESTOR,
					ATTRIBUTE2
				)
				SELECT 
					@v_max_req_no CHANGE_REQ_NO					,CONFIRM_ID							,'Y' NEW_YN									,DIVISION_ID
					,ITEM_ID									,FROM_SITE							,TO_SITE									,YYYYMMDD
					,QTY										,BOD_ID								,ROUTE_ID									,BIZ_TYPE
					,PROJECT_CODE								,FCST_TYPE							,FCST_ETD_DATE								,FCST_ETA_DATE	
					,ETD_DATE									,ETA_DATE							,INCOTERMS									,TRANSPORT_MODE
					,D_COUNTRY									,D_PORT_CODE						,A_COUNTRY									,A_PORT_CODE
					,CUSTOMER_LT								,TO_COUNTRY							,TO_CITY									,@v_shipment_date NEW_YYYYMMDD
					,@v_shipment_qty NEW_QTY					,@v_new_bod_id_temp NEW_BOD_ID		,@v_new_route_id_temp NEW_ROUTE_ID			,@v_new_etd_date NEW_ETD_DATE
					,@v_new_eta_date NEW_ETA_DATE				,@v_new_incoterms NEW_INCOTERMS		,@v_new_transport_mode NEW_TRANSPORT_MODE	,@v_new_d_contry NEW_D_COUNTRY
					,@v_new_d_port_code_temp NEW_D_PORT_CODE	,@v_new_a_country_temp NEW_A_COUNTRY ,@v_new_a_port_code_temp NEW_A_PORT_CODE	,@v_new_customer_lt_temp NEW_CUSTOMER_LT
					,@v_new_to_country_temp NEW_TO_COUNTRY		,@v_new_to_city_temp NEW_TO_CITY 	,FROM_SITE_TYPE								,FROM_SITE_PLANT_ID	
					,FROM_SITE_VENDOR_ID						,FROM_SITE_SOLDTO_CODE				,FROM_SITE_SHIPTO_CODE						,FROM_SITE_COMPANY_ID
					,TO_SITE_TYPE								,TO_SITE_PLANT_ID					,TO_SITE_VENDOR_ID							,TO_SITE_SOLDTO_CODE
					,TO_SITE_SHIPTO_CODE						,TO_SITE_COMPANY_ID					,ERP_SO_NO									,ERP_SO_ITEM_NO
					,ERP_DO_NO									,ERP_STATUS							,'Y'										,'N'
					,@p_user_id CREATED_BY						,@v_create_date						,@p_user_id LAST_UPDATED_BY					,@v_create_date--[dbo].[FN_MULTY_TIME](@p_time_zone) LAST_UPDATE_DATE
					,ELECTRODE_YN								,ELECTRODE_TYPE						,ORIGIN_FROM_DIVISION_ID					,ORIGIN_TO_DIVISION_ID
					,@v_remarks									,@v_remarks2						,@v_remarks3								,REQUESTOR
					,'A'		
					
				FROM SSP_ANL_SHIP_CONFIRM A WITH(NOLOCK)
				WHERE CONFIRM_ID = @v_new_confirm_id;

			END --@v_active_flag = 'I' END

		END --end of while loop
				
		--240223 jilee 폴란드 WA 법인 변경건 전체 내역 송부
		IF (LEN(@v_confirm_id) > 0 )
		BEGIN
			IF (
		    SELECT SEGMENT1 --company id
			FROM SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK) WHERE 1=1
			AND L.LOOKUP_TYPE = 'SSP_PLN_FP_SHIP_TARGET_WA' 
			AND L.VALID_YN = 'Y'
			) =
			(
			SELECT c.FROM_SITE_COMPANY_ID 
			FROM SSP_ANL_SHIP_CONFIRM c WITH(NOLOCK) WHERE 1=1
			AND c.CONFIRM_ID = @v_confirm_id
			)
		    BEGIN
				EXEC PR_SSP_PLN_FP_SHIP_TARGET_WA
		    END	
		END		

		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
					
		-- 결과코드, 결과 카운트 반환
		SELECT  'S' AS result_code,  @max_loop_cnt AS result_cnt, isnull(@v_change_req_no,'') AS change_req_no  ;

		-- [C20201223-000448] MKT FCST - SSP Sync
		EXEC PR_DM_SSP_CONFIRM_SYNC @p_division_id, @p_confirm_id;
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
