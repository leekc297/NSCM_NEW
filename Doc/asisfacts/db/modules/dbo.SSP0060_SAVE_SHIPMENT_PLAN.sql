

/*
 * Program ID   : [SSP0060_SAVE_SHIPMENT_PLAN]
 * Description  : Shipment PLAN 수정
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2024/06/05   hsbang		   Initial Release
 */
CREATE PROCEDURE [dbo].[SSP0060_SAVE_SHIPMENT_PLAN]
	 @p_active_flag		     NVARCHAR(MAX)
	,@p_division_id          NVARCHAR(MAX)
	,@p_company_id           NVARCHAR(MAX)
	,@p_from_site            NVARCHAR(MAX)
	,@p_item_id              NVARCHAR(MAX)
	,@p_to_site              NVARCHAR(MAX)
	,@p_transport_mode       NVARCHAR(MAX)
	,@p_incoterms            NVARCHAR(MAX)
	,@p_fcst_type            NVARCHAR(MAX)
	,@p_plan_start_yyyymmdd  NVARCHAR(MAX)
	,@p_yyyymmdd             NVARCHAR(MAX)
	,@p_shipment_qty         NVARCHAR(MAX)
	,@p_user_id              NVARCHAR(MAX)
	,@p_user_dept_id		 NVARCHAR(MAX)
	,@debug_mode			 NVARCHAR(1) ='F'
AS

BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @recv_active_flag			NVARCHAR(MAX);
	DECLARE @v_max_req_no				NVARCHAR(40);
	DECLARE @v_active_flag				NVARCHAR(MAX);
	DECLARE @v_division_id				NVARCHAR(MAX)
	DECLARE @v_confirm_id				NVARCHAR(MAX)
	DECLARE @v_yyyymmdd					NVARCHAR(MAX)
	DECLARE @v_shipment_qty				numeric(20, 10)
	DECLARE @v_new_shipment_qty			numeric(20, 10)
	DECLARE @v_old_shipment_qty			numeric(20, 10)
	DECLARE @v_from_site				NVARCHAR(MAX)
	DECLARE @v_to_site					NVARCHAR(MAX)
	DECLARE @v_project_code				NVARCHAR(MAX)
	DECLARE @v_item_id					NVARCHAR(MAX)
	DECLARE @v_bod_id				NVARCHAR(MAX)
	DECLARE @v_etd_date				NVARCHAR(MAX)
	DECLARE @v_eta_date				NVARCHAR(MAX)
	DECLARE @v_route_id				NVARCHAR(MAX)
	DECLARE @v_transport_mode		NVARCHAR(MAX)
	DECLARE @v_incoterms			NVARCHAR(MAX)
	DECLARE @v_fcst_type			NVARCHAR(MAX)
	DECLARE @v_d_contry				NVARCHAR(MAX)
	DECLARE @v_d_port_code			NVARCHAR(MAX)
	DECLARE @v_a_country			NVARCHAR(MAX)
	DECLARE @v_a_port_code			NVARCHAR(MAX)
	DECLARE @v_customer_lt			NVARCHAR(MAX)
	DECLARE @v_to_country			NVARCHAR(MAX)
	DECLARE @v_to_city				NVARCHAR(MAX)
	DECLARE @v_edit_main				NVARCHAR(MAX)
	DECLARE @v_edit_remark				NVARCHAR(MAX)
	DECLARE @v_create_date				DATETIME;
	DECLARE @v_chk						INT
	DECLARE @v_title					NVARCHAR(MAX)
	DECLARE @v_electrode_yn				NVARCHAR(MAX)
	DECLARE @v_electrode_type			NVARCHAR(MAX)
	DECLARE @v_origin_from_division_id	NVARCHAR(MAX)
	DECLARE @v_origion_to_division_id	NVARCHAR(MAX)
	DECLARE @v_remarks					NVARCHAR(MAX)
	DECLARE @v_remarks2					NVARCHAR(MAX)
	DECLARE @v_remarks3					NVARCHAR(MAX)
	DECLARE @v_change_reason_code		NVARCHAR(MAX)
	DECLARE @v_change_reason_detail		NVARCHAR(MAX)
	DECLARE @v_origin_to_division_id NVARCHAR(MAX);
	DECLARE @v_from_site_type			NVARCHAR(MAX);
	DECLARE @v_from_site_plant_id       NVARCHAR(MAX);
	DECLARE @v_from_site_vendor_id      NVARCHAR(MAX);
	DECLARE @v_from_site_company_id		NVARCHAR(MAX);
	DECLARE @v_from_site_soldto_code	NVARCHAR(MAX);
	DECLARE @v_from_site_shipto_code	NVARCHAR(MAX);
	DECLARE @v_to_site_type				NVARCHAR(MAX);
	DECLARE @v_to_site_plant_id			NVARCHAR(MAX);
	DECLARE @v_to_site_vendor_id		NVARCHAR(MAX);
	DECLARE @v_to_site_company_id		NVARCHAR(MAX);
	DECLARE @v_to_site_soldto_code		NVARCHAR(MAX);
	DECLARE @v_to_site_shipto_code		NVARCHAR(MAX);
	DECLARE @v_operation_group			NVARCHAR(MAX);
	DECLARE @v_package_type_code		NVARCHAR(MAX);
	DECLARE @v_package_qty				numeric(20, 10)

	DECLARE @v_division_id_temp		         NVARCHAR(MAX)
	DECLARE @v_confirm_id_temp		         NVARCHAR(MAX)
	DECLARE @v_bod_id_temp		         NVARCHAR(MAX)
	DECLARE @v_from_site_temp		         NVARCHAR(MAX)
	DECLARE @v_to_site_temp			         NVARCHAR(MAX)
	DECLARE @v_incoterms_temp            NVARCHAR(MAX)
	DECLARE @v_transport_mode_temp       NVARCHAR(MAX)
	DECLARE @v_route_id_temp			 NVARCHAR(MAX)  
	DECLARE @v_d_contry_temp			 NVARCHAR(MAX)      
	DECLARE @v_d_port_code_temp          NVARCHAR(MAX)  
	DECLARE @v_a_country_temp            NVARCHAR(MAX)  
	DECLARE @v_a_port_code_temp          NVARCHAR(MAX)  
	DECLARE @v_customer_lt_temp          NVARCHAR(MAX)
	DECLARE @v_to_country_temp           NVARCHAR(MAX)  
	DECLARE @v_to_city_temp		         NVARCHAR(MAX)
	DECLARE @v_shipment_qty_temp		numeric(20, 10)
	DECLARE @v_lot_size					numeric(20, 10)
	DECLARE @v_add_qty					numeric(20, 10)

	DECLARE @v_model_pic			         NVARCHAR(MAX)
	DECLARE @v_model_pic_temp		         NVARCHAR(MAX)

	--DECLARE @v_company_id              NVARCHAR(50);

	SET @recv_active_flag			= NULL;		
	SET @recv_active_flag			= @p_active_flag;
	SET @v_active_flag				= NULL;
	SET @v_division_id				= @p_division_id;
	SET @v_confirm_id				= NULL;
	SET @v_shipment_qty				= 0;
	SET @v_old_shipment_qty			= 0;
	SET @v_lot_size					= 0;
	SET @v_add_qty					= 0;
	
	SET @v_yyyymmdd				= NULL;
	SET @v_from_site			= NULL;
	SET @v_to_site				= NULL;
	SET @v_project_code			= NULL;
	SET @v_item_id				= NULL;
	SET @v_bod_id				= NULL;
	SET @v_route_id				= NULL;
	SET @v_etd_date				= NULL;
	SET @v_eta_date				= NULL;
	SET @v_incoterms			= NULL;
	SET @v_transport_mode		= NULL;
	SET @v_d_contry				= NULL;
	SET @v_d_port_code			= NULL;	
	SET @v_a_country			= NULL;	
	SET @v_a_port_code			= NULL;	
	SET @v_customer_lt			= '0';
	SET @v_to_country			= NULL;	
	SET @v_to_city				= NULL;	
	SET @v_edit_main				= NULL;	
	SET @v_edit_remark				= NULL;	
	SET @v_chk						= 0;
	SET @v_electrode_yn				= NULL;	
	SET @v_electrode_type			= NULL;	
	SET @v_origin_from_division_id	= NULL;	
	SET @v_origion_to_division_id	= NULL;	
	SET @v_remarks					= NULL;
	SET @v_remarks2					= NULL;
	SET @v_remarks3					= NULL;
	SET @v_change_reason_code		= NULL;
	SET @v_change_reason_detail		= NULL;
	SET @v_create_date				= SYSDATETIME();
	SET @v_electrode_yn				= null;
    SET @v_electrode_type			= null;
    SET @v_origin_from_division_id	= null;
    SET @v_origin_to_division_id	= null;

	SET @v_from_site_type			= NULL;
	SET @v_from_site_plant_id		= NULL;
	SET @v_from_site_vendor_id		= NULL;
	SET @v_from_site_company_id		= NULL;
	SET @v_from_site_soldto_code	= NULL;
	SET @v_from_site_shipto_code	= NULL;
										  
	SET @v_to_site_type				= NULL;
	SET @v_to_site_plant_id			= NULL;
	SET @v_to_site_vendor_id		= NULL;
	SET @v_to_site_company_id		= NULL;
	SET @v_to_site_soldto_code		= NULL;
	SET @v_to_site_shipto_code		= NULL;
	SET @v_operation_group			= NULL;
	SET @v_package_type_code		= NULL;
	SET @v_package_qty				= 0;
	--SET @v_company_id               = NULL;

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SSP0060_SAVE_SHIPMENT_PLAN';
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

		SET @v_title						= 'Change on Shipment Plan Qty';

		SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_active_flag, @v_delimiter);
		WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt
		BEGIN
			SET @mst_loop_cnt = @mst_loop_cnt + 1;			

			-- 각 컬럼들에 대한 스플릿처리로직 스타트
			BEGIN

				SET @v_active_flag					= dbo.SCM_ARR_SPL_VAL( @p_active_flag,				@v_delimiter, @mst_loop_cnt );
				--SET @v_division_id					= dbo.SCM_ARR_SPL_VAL( @p_division_id,				@v_delimiter, @mst_loop_cnt );
				SET @v_from_site					= dbo.SCM_ARR_SPL_VAL( @p_from_site,				@v_delimiter, @mst_loop_cnt );
				SET @v_item_id						= dbo.SCM_ARR_SPL_VAL( @p_item_id,					@v_delimiter, @mst_loop_cnt );
				SET @v_to_site						= dbo.SCM_ARR_SPL_VAL( @p_to_site,					@v_delimiter, @mst_loop_cnt );
				SET @v_transport_mode				= dbo.SCM_ARR_SPL_VAL( @p_transport_mode,					@v_delimiter, @mst_loop_cnt );
				SET @v_incoterms					= dbo.SCM_ARR_SPL_VAL( @p_incoterms,					@v_delimiter, @mst_loop_cnt );
				SET @v_fcst_type					= dbo.SCM_ARR_SPL_VAL( @p_fcst_type,					@v_delimiter, @mst_loop_cnt );
				--SET @v_plan_start_yyyymmdd			= dbo.SCM_ARR_SPL_VAL( @p_plan_start_yyyymmdd,					@v_delimiter, @mst_loop_cnt );
				SET @v_yyyymmdd						= dbo.SCM_ARR_SPL_VAL( @p_yyyymmdd,					@v_delimiter, @mst_loop_cnt );
				SET @v_new_shipment_qty				= dbo.SCM_ARR_SPL_VAL( @p_shipment_qty,				@v_delimiter, @mst_loop_cnt );
				/*
				IF @v_change_reason_code = '' OR @v_change_reason_code IS NULL
				BEGIN
					SET @v_change_reason_code	= 'T07';
				END;
				
				IF @v_change_reason_detail	= '' OR @v_change_reason_detail IS NULL
				BEGIN
					SET @v_change_reason_detail	= NULL;	
				END;
				*/
			END;

			-- 기존 shipment_qty
			SELECT @v_old_shipment_qty = ISNULL(SUM([QTY]), 0)
				,  @v_confirm_id_temp = MAX([CONFIRM_ID])	   
			FROM SSP_ANL_SHIP_CONFIRM T0 WITH (NOLOCK)
			WHERE 1 = 1
			AND T0.change_type  = 'C'
			AND T0.BIZ_TYPE  <> 'E'
			--AND (SHIPMENT_STATUS IS NOT NULL AND T0.SHIPMENT_STATUS = 'C' AND T0.ERP_STATUS IS NULL OR T0.ERP_STATUS != 'C')
			AND T0.qty >  0
			AND T0.division_id  = @p_division_id  
			AND T0.FROM_SITE_COMPANY_ID = @p_company_id
			--AND T0.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd 
			AND T0.yyyymmdd = @v_yyyymmdd
			AND ((@v_from_site		IS NULL OR @v_from_site			='' ) OR T0.from_site		IN (SELECT token FROM dbo.String_Split(@v_from_site, ',')))
			AND ((@v_item_id		IS NULL OR @v_item_id			='' ) OR T0.item_id			IN (SELECT token FROM dbo.String_Split(@v_item_id  , ','))) 
			AND ((@v_to_site		IS NULL OR @v_to_site			='' ) OR T0.TO_SITE			IN (SELECT token FROM dbo.String_Split(@v_to_site  , ','))) 
			AND ((@v_transport_mode IS NULL OR @v_transport_mode	='' ) OR T0.TRANSPORT_MODE  IN (SELECT token FROM dbo.String_Split(@v_transport_mode  , ','))) 
			AND ((@v_incoterms		IS NULL OR @v_incoterms			='' ) OR T0.INCOTERMS		IN (SELECT token FROM dbo.String_Split(@v_incoterms  , ','))) 
			AND ((@v_fcst_type		IS NULL OR @v_fcst_type			='' ) OR T0.FCST_TYPE		IN (SELECT token FROM dbo.String_Split(@v_fcst_type  , ','))) 
			;

			SELECT TOP 1
							 @v_division_id_temp			= V.DIVISION_ID 
							,@v_bod_id_temp				= V.BOD_ID 
							,@v_from_site_temp				= V.FROM_SITE
							,@v_to_site_temp				= V.TO_SITE 
							,@v_incoterms_temp			= V.SSP_INCOTERMS
							,@v_transport_mode_temp		= V.TRANSPORT_MODE
							,@v_route_id_temp			= V.ROUTE_ID 
							,@v_d_contry_temp			= V.D_COUNTRY        
							,@v_d_port_code_temp		= V.D_PORT_CODE      
							,@v_a_country_temp			= V.A_COUNTRY        
							,@v_a_port_code_temp		= V.A_PORT_CODE      
							,@v_customer_lt_temp		= V.LT_TOTAL      
							,@v_to_country_temp			= V.TO_COUNTRY       
							,@v_to_city_temp			= V.TO_CITY
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
										AND   FROM_SITE		 = @v_from_site
										AND   TO_SITE		 = @v_to_site
										AND	  TRANSPORT_MODE = @v_transport_mode
										AND	  ssp_incoterms  = @v_incoterms
										AND   BOD_VALID_YN	 = 'Y'				
										AND   FROM_YYYYMMDD <= @v_yyyymmdd
										AND   TO_YYYYMMDD >= @v_yyyymmdd

									)  B 
		
						)  V

						JOIN ( SELECT DISTINCT DIVISION_ID , ITEM_ID , BOD_ID 
								FROM   SCP_MST_BOD_ITEM  WITH(NOLOCK)   -- SCP_MST_BOD_ITEM A WITH(NOLOCK) 
								WHERE  DIVISION_ID = @v_division_id
								AND    ITEM_ID	  = @v_item_id 
								)   A
							ON A.DIVISION_ID  = V.DIVISION_ID 
							AND A.BOD_ID       = V.BOD_ID

					WHERE 1=1
						AND V.division_id = @v_division_id
						AND V.from_site = @v_from_site
						AND V.to_site = @v_to_site
						AND V.TRANSPORT_MODE = @v_transport_mode
						AND V.ssp_incoterms = @v_incoterms
						AND V.bod_valid_yn = 'Y'
					order by V.PRIORITY

					/*
					print @v_division_id_temp			  ;
					print @v_bod_id_temp			  ;
					print @v_from_site_temp				  ;
					print @v_to_site_temp				  ;
					print @v_incoterms_temp			  ;
					print @v_transport_mode_temp	  ;
					print @v_route_id_temp			  ;
					print @v_d_contry_temp			  ;
					print @v_d_port_code_temp		  ;
					print @v_a_country_temp			  ;
					print @v_a_port_code_temp		  ;
					print @v_customer_lt_temp		  ;
					print @v_to_country_temp		  ;100
					print @v_to_city_temp			  ;
					*/
					
					IF ( (  @v_division_id_temp			= '' or @v_division_id_temp IS NULL				)
						OR (@v_bod_id_temp			= '' or @v_bod_id_temp IS NULL				)
						OR (@v_from_site_temp			= '' or @v_from_site_temp IS NULL		   		)
						OR (@v_to_site_temp				= '' or @v_to_site_temp IS NULL			   		)
						OR (@v_incoterms_temp		= '' or @v_incoterms_temp IS NULL			)
						OR (@v_transport_mode_temp	= '' or @v_transport_mode_temp IS NULL		)
						OR (@v_route_id_temp		= '' or @v_route_id_temp IS NULL			)
						OR (@v_d_contry_temp		= '' or @v_d_contry_temp IS NULL	 		)
						OR (@v_d_port_code_temp		= '' or @v_d_port_code_temp IS NULL	  		)
						OR (@v_a_country_temp		= '' or @v_a_country_temp IS NULL	  		)
						OR (@v_a_port_code_temp		= '' or @v_a_port_code_temp IS NULL	 		)
						OR (@v_customer_lt_temp		= '' or @v_customer_lt_temp IS NULL	 		)
						OR (@v_to_country_temp		= '' or @v_to_country_temp IS NULL			)
						OR (@v_to_city_temp			= '' or @v_to_city_temp IS NULL				)
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
					
			
			--select '0', @v_old_shipment_qty, @v_new_shipment_qty;
			/*1) 감량 시
			     1. d/o 발행 수량 이상으로만 변경 가능하다
				 2. S/O 발행하지 않은 계획부터 감량한다. S/O 번호가 높은 것 먼저 감량
				 3. 모두 S/O 발행되었을 경우, CONFIRM ID 번호가 높은 것 먼저 감량
				 */
			IF (@v_old_shipment_qty > @v_new_shipment_qty)
			BEGIN
				SET @v_shipment_qty_temp	= @v_old_shipment_qty - @v_new_shipment_qty;

				IF CURSOR_STATUS('global','CUR_M') >= -1
				BEGIN
					IF CURSOR_STATUS('global','CUR_M') > -1
					BEGIN
						CLOSE CUR_M;
					END

					DEALLOCATE CUR_M;
				END

				IF @v_chk = 0
				BEGIN
					SET @v_max_req_no = 'R'+CONVERT(VARCHAR(8), @v_create_date, 112) + RIGHT('000000' + CONVERT(NVARCHAR, NEXT VALUE FOR SEQ1_SSP_ANL_SHIP_CHG_REQ_NO),6)

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
						@v_max_req_no,				'C',							'Q',							@v_division_id, 
						@v_from_site,				@v_title,						@p_user_id,						@p_user_dept_id, 
						@v_create_date,				@p_user_id,						@p_user_dept_id,				@v_create_date, 
						@v_change_reason_code,		@v_change_reason_detail,		NULL,							'N', 
						@p_user_id,					@v_create_date,					@p_user_id,						@v_create_date, 
						@v_electrode_yn,			@v_electrode_type,				@v_origin_from_division_id,		@v_origion_to_division_id
					);
					--Request_No값 각기(단일) 생성
					SET @v_chk = 1;
					--select '1', @p_division_id, @p_company_id, @v_yyyymmdd, @v_from_site, @v_item_id, @v_to_site, @v_transport_mode, @v_incoterms, @v_fcst_type;
				END;

				DECLARE CUR_M CURSOR FOR
					SELECT [CONFIRM_ID]
						  ,[QTY]
						  ,[BOD_ID]
						  ,[ROUTE_ID]
						  ,CONVERT(VARCHAR(10),		CONVERT(DATETIME, [ETD_DATE],112), 23) AS NEW_ETA
						  ,CONVERT(VARCHAR(10),		CONVERT(DATETIME, [ETA_DATE],112), 23) AS NEW_ETD
						  ,[D_COUNTRY]
						  ,[D_PORT_CODE]
						  ,[A_COUNTRY]
						  ,[A_PORT_CODE]
						  ,[CUSTOMER_LT]
						  ,[TO_COUNTRY]
						  ,[TO_CITY]
						  ,[ELECTRODE_YN]
						  ,[ELECTRODE_TYPE]
						  ,[ORIGIN_FROM_DIVISION_ID]
						  ,[ORIGIN_TO_DIVISION_ID]
						  ,[REMARKS]
						  ,[REMARKS2]
						  ,[REMARKS3]
					FROM SSP_ANL_SHIP_CONFIRM T0 WITH (NOLOCK)
					WHERE 1 = 1
					AND T0.change_type  = 'C'
					AND T0.BIZ_TYPE  <> 'E'
					AND (SHIPMENT_STATUS IS NOT NULL AND T0.SHIPMENT_STATUS = 'C' AND T0.ERP_STATUS IS NULL OR T0.ERP_STATUS != 'C')
					AND T0.qty >  0
					AND T0.division_id  = @p_division_id  
					AND T0.FROM_SITE_COMPANY_ID = @p_company_id
					--AND T0.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd 
					AND T0.yyyymmdd = @v_yyyymmdd
					AND ((@v_from_site		IS NULL OR @v_from_site			='' ) OR T0.from_site		IN (SELECT token FROM dbo.String_Split(@v_from_site, ',')))
					AND ((@v_item_id		IS NULL OR @v_item_id			='' ) OR T0.item_id			IN (SELECT token FROM dbo.String_Split(@v_item_id  , ','))) 
					AND ((@v_to_site		IS NULL OR @v_to_site			='' ) OR T0.TO_SITE			IN (SELECT token FROM dbo.String_Split(@v_to_site  , ','))) 
					AND ((@v_transport_mode IS NULL OR @v_transport_mode	='' ) OR T0.TRANSPORT_MODE  IN (SELECT token FROM dbo.String_Split(@v_transport_mode  , ','))) 
					AND ((@v_incoterms		IS NULL OR @v_incoterms			='' ) OR T0.INCOTERMS		IN (SELECT token FROM dbo.String_Split(@v_incoterms  , ','))) 
					AND ((@v_fcst_type		IS NULL OR @v_fcst_type			='' ) OR T0.FCST_TYPE		IN (SELECT token FROM dbo.String_Split(@v_fcst_type  , ','))) 
					--S/O 발행하지 않은 계획부터 감량한다. S/O 번호가 높은 것 먼저 감량, 모두 S/O 발행되었을 경우, CONFIRM ID 번호가 높은 것 먼저 감량
					ORDER BY (CASE WHEN T0.ERP_SO_NO IS NULL THEN 0 ELSE 1 END)
						  , T0.ERP_SO_NO DESC, T0.CONFIRM_ID DESC 
					;
				OPEN CUR_M;
				FETCH NEXT FROM CUR_M INTO @v_confirm_id, @v_shipment_qty, @v_bod_id
									   , @v_route_id, @v_etd_date, @v_eta_date
									   , @v_d_contry, @v_d_port_code, @v_a_country, @v_a_port_code, @v_customer_lt
									   , @v_to_country, @v_to_city, @v_electrode_yn, @v_electrode_type, @v_origin_from_division_id, @v_origion_to_division_id
									   , @v_remarks, @v_remarks2, @v_remarks3;

				WHILE @@FETCH_STATUS = 0
				BEGIN
					--select '2', @p_division_id, @p_company_id, @v_yyyymmdd, @v_from_site, @v_item_id, @v_to_site, @v_transport_mode, @v_incoterms, @v_fcst_type;
					--select '31', @v_shipment_qty, @v_shipment_qty_temp;
					IF (@v_shipment_qty_temp = 0) BREAK;

					IF (@v_shipment_qty <= @v_shipment_qty_temp)
					BEGIN
						SET @v_shipment_qty_temp = @v_shipment_qty_temp - @v_shipment_qty; --8795
						SET @v_shipment_qty = 0; -- 새로입력
					END
					ELSE
					BEGIN
						SET @v_shipment_qty = @v_shipment_qty - @v_shipment_qty_temp;						
						SET @v_shipment_qty_temp = 0;
					END
				 
					--select '32', @v_shipment_qty, @v_shipment_qty_temp;

					SET @v_etd_date = REPLACE(SUBSTRING(@v_etd_date,1,10),'-','');
					
					/* 2019.09.04 etd:shipdate, eta:etd+lt_day로 셋팅*/
					IF ISNULL(@v_yyyymmdd,'')!='' and LEN(@v_yyyymmdd)=8 and ISNULL(@v_customer_lt,'')!='' and LEN(@v_customer_lt)>0
					BEGIN
						SET @v_etd_date = @v_yyyymmdd
						;
						--SET @v_eta_date = convert(VARCHAR(8), dateadd(dd, convert(int, @v_customer_lt), convert(datetime,@v_etd_date)),112)
						;
					END
					
					/* 2019.10.29 출발일 기준 항차를 고려한 ETA_DATE 계산*/
					SET @v_eta_date = [dbo].[FN_GET_SSP_ETA_DATE](@p_division_id, @v_bod_id_temp, @v_yyyymmdd) 				
					
					INSERT SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE
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
						ATTRIBUTE2,
						CREATED_BY,									CREATION_DATE,						LAST_UPDATED_BY,							LAST_UPDATE_DATE,
						ELECTRODE_YN,								ELECTRODE_TYPE,						ORIGIN_FROM_DIVISION_ID,					ORIGIN_TO_DIVISION_ID,
						REMARKS,									REMARKS2,							REMARKS3,									REQUESTOR
					)
					SELECT 
						@v_max_req_no CHANGE_REQ_NO					,CONFIRM_ID							,'N' NEW_YN									,DIVISION_ID
						,ITEM_ID									,FROM_SITE							,TO_SITE									,YYYYMMDD
						,QTY										,BOD_ID								,ROUTE_ID									,BIZ_TYPE
						,PROJECT_CODE								,FCST_TYPE							,FCST_ETD_DATE								,FCST_ETA_DATE	
						,ETD_DATE									,ETA_DATE							,INCOTERMS									,TRANSPORT_MODE
						,D_COUNTRY									,D_PORT_CODE						,A_COUNTRY									,A_PORT_CODE
						,CUSTOMER_LT								,TO_COUNTRY							,TO_CITY									,@v_yyyymmdd NEW_YYYYMMDD
						,@v_shipment_qty NEW_QTY					,@v_bod_id_temp NEW_BOD_ID			,@v_route_id_temp NEW_ROUTE_ID				,@v_etd_date NEW_ETD_DATE
						,@v_eta_date NEW_ETA_DATE					,@v_incoterms_temp NEW_INCOTERMS	,@v_transport_mode_temp NEW_TRANSPORT_MODE	,@v_d_contry_temp NEW_D_COUNTRY
						,@v_d_port_code_temp NEW_D_PORT_CODE		,@v_a_country_temp NEW_A_COUNTRY	,@v_a_port_code_temp NEW_A_PORT_CODE		,@v_customer_lt_temp NEW_CUSTOMER_LT
						,@v_to_country_temp NEW_TO_COUNTRY			,@v_to_city_temp NEW_TO_CITY 		,FROM_SITE_TYPE								,FROM_SITE_PLANT_ID	
						,FROM_SITE_VENDOR_ID						,FROM_SITE_SOLDTO_CODE				,FROM_SITE_SHIPTO_CODE						,FROM_SITE_COMPANY_ID
						,TO_SITE_TYPE								,TO_SITE_PLANT_ID					,TO_SITE_VENDOR_ID							,TO_SITE_SOLDTO_CODE
						,TO_SITE_SHIPTO_CODE						,TO_SITE_COMPANY_ID					,ERP_SO_NO									,ERP_SO_ITEM_NO
						,ERP_DO_NO									,ERP_STATUS							,'N'										,'N'
						,'A'
						,@p_user_id CREATED_BY						,@v_create_date						,@p_user_id LAST_UPDATED_BY					,@v_create_date--[dbo].[FN_MULTY_TIME](@p_time_zone) LAST_UPDATE_DATE
						,ELECTRODE_YN								,ELECTRODE_TYPE						,ORIGIN_FROM_DIVISION_ID					,ORIGIN_TO_DIVISION_ID
						,@v_remarks									,@v_remarks2						,@v_remarks3								,@p_user_id					
					FROM SSP_ANL_SHIP_CONFIRM A WITH(NOLOCK)
					WHERE CONFIRM_ID = @v_confirm_id;
					
					FETCH NEXT FROM CUR_M INTO @v_confirm_id, @v_shipment_qty, @v_bod_id
									   , @v_route_id, @v_etd_date, @v_eta_date
									   , @v_d_contry, @v_d_port_code, @v_a_country, @v_a_port_code, @v_customer_lt
									   , @v_to_country, @v_to_city, @v_electrode_yn, @v_electrode_type, @v_origin_from_division_id, @v_origion_to_division_id
									   , @v_remarks, @v_remarks2, @v_remarks3;
				END

				CLOSE CUR_M;
				DEALLOCATE CUR_M;
			END
			/* 2) 증량인 경우
			      1. 수량 입력 시, SHIPMENT LOT SIZE 만큼 쪼개서 CONFIRM ID 발행
			*/
			ELSE IF (@v_old_shipment_qty < @v_new_shipment_qty)			
			BEGIN
				SET @v_shipment_qty_temp = @v_new_shipment_qty - @v_old_shipment_qty -- 증가수량
				;
				--PRINT @v_shipment_qty, @v_old_shipment_qty + '/' + @v_new_shipment_qty + '/' + @v_shipment_qty_temp;

				IF @v_chk = 0
				BEGIN
					SET @v_max_req_no = 'R'+CONVERT(VARCHAR(8), @v_create_date, 112) + RIGHT('000000' + CONVERT(NVARCHAR, NEXT VALUE FOR SEQ1_SSP_ANL_SHIP_CHG_REQ_NO),6)

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
						@v_max_req_no,				'C',							'Q',							@v_division_id, 
						@v_from_site,				@v_title,						@p_user_id,						@p_user_dept_id, 
						@v_create_date,				@p_user_id,						@p_user_dept_id,				@v_create_date, 
						@v_change_reason_code,		@v_change_reason_detail,		NULL,							'N', 
						@p_user_id,					@v_create_date,					@p_user_id,						@v_create_date, 
						@v_electrode_yn,			@v_electrode_type,				@v_origin_from_division_id,		@v_origion_to_division_id
					);
					--select '3', @p_division_id, @p_company_id, @v_yyyymmdd, @v_from_site, @v_item_id, @v_to_site, @v_transport_mode, @v_incoterms, @v_fcst_type;
					--Request_No값 각기(단일) 생성
					SET @v_chk = 1;
				END;
				
				SET @v_etd_date = REPLACE(SUBSTRING(@v_etd_date,1,10),'-','');
					
				/* 2019.09.04 etd:shipdate, eta:etd+lt_day로 셋팅*/
				IF ISNULL(@v_yyyymmdd,'')!='' and LEN(@v_yyyymmdd)=8 and ISNULL(@v_customer_lt,'')!='' and LEN(@v_customer_lt)>0
				BEGIN
					SET @v_etd_date = @v_yyyymmdd
					;
					--SET @v_eta_date = convert(VARCHAR(8), dateadd(dd, convert(int, @v_customer_lt), convert(datetime,@v_etd_date)),112)
					;
				END
					
				/* 2019.10.29 출발일 기준 항차를 고려한 ETA_DATE 계산*/
				SET @v_eta_date = [dbo].[FN_GET_SSP_ETA_DATE](@p_division_id, @v_bod_id_temp, @v_yyyymmdd) 				

				SELECT  @v_origin_from_division_id =  DIVISION_ID  
						,@v_operation_group		   =  OPERATION_GROUP
				FROM dbo.SCM_MST_SITE WITH(NOLOCK) 
				WHERE SCM_SITE_ID  = @v_from_site 
				AND   DIVISION_ID =  @v_division_id
				AND   VALID_YN  = 'Y'
				;

				SELECT TOP 1 @v_project_code = PROJECT_CODE
				FROM dbo.SCM_MST_SITE_ITEM WITH(NOLOCK)
				WHERE DIVISION_ID = @v_division_id
				AND   SCM_SITE_ID = @v_to_site
				AND   ITEM_ID = @v_item_id
				;

				SELECT @v_package_type_code = E.PACKAGE_TYPE_CODE
					,  @v_package_qty = CEILING(CASE WHEN E.PACKAGE_TYPE_CODE = 'BX' THEN CEILING(@v_shipment_qty_temp * CAST(isnull(E.CONVERT_TO_PC_ROLL_LENGTH ,1) AS numeric(20,10)) ) * isnull(E.BOX_PER_CUT ,1)
 													WHEN E.PACKAGE_TYPE_CODE = 'SC' THEN CEILING(@v_shipment_qty_temp * CAST(isnull(E.CONVERT_TO_PC_ROLL_LENGTH ,1) AS numeric(20,10)) ) * isnull(E.STEELCRATE_PER_CUT ,1)
 													WHEN E.PACKAGE_TYPE_CODE = 'SR' THEN CEILING(@v_shipment_qty_temp * CAST(isnull(E.CONVERT_TO_PC_ROLL_LENGTH ,1) AS numeric(20,10)) ) * isnull(E.STEELRACK_PER_CUT ,1)
 												ELSE NULL  END)
				FROM dbo.SSP_MST_SITE_ITEM_EE_V E WITH(NOLOCK) 
				WHERE E.DIVISION_ID = @v_division_id
				AND E.SCM_SITE_ID   = @v_from_site
				AND E.ITEM_ID       = @v_item_id
				;

				IF @v_operation_group <> 'E'
				BEGIN
						SET @v_electrode_yn = 'N'
						SET @v_origin_to_division_id = @v_origin_from_division_id ;
				END   
				ELSE
				BEGIN 
						SET  @v_electrode_yn = 'Y'

						SELECT  @v_origin_to_division_id =  DIVISION_ID  
						FROM SCM_MST_SITE WITH(NOLOCK) 
						WHERE SCM_SITE_ID  = @v_to_site 
						AND   VALID_YN  = 'Y'
						;
				END   

				DECLARE @tmp_division_id NVARCHAR(100) = ''
	
				SELECT @tmp_division_id = @v_origin_from_division_id 
				SELECT @v_from_site_type 		= dbo.FN_GET_SSP_SITE_INFO(@tmp_division_id, @v_from_site, 'SITE_TYPE')
				SELECT @v_from_site_plant_id  = dbo.FN_GET_SSP_SITE_INFO(@tmp_division_id, @v_from_site, 'PLANT_ID')
				SELECT @v_from_site_vendor_id = dbo.FN_GET_SSP_SITE_INFO(@tmp_division_id, @v_from_site, 'VENDOR_ID')
				SELECT @v_from_site_company_id = dbo.FN_GET_SSP_SITE_INFO(@tmp_division_id, @v_from_site, 'COMPANY_ID')
				SELECT @v_from_site_soldto_code = dbo.FN_GET_SSP_SITE_INFO(@tmp_division_id, @v_from_site, 'SOLDTO_CODE')
				SELECT @v_from_site_shipto_code = dbo.FN_GET_SSP_SITE_INFO(@tmp_division_id, @v_from_site, 'SHIPTO_CODE')
			
				SELECT @tmp_division_id = CASE WHEN @v_division_id = 'EE' THEN @v_origin_from_division_id ELSE @v_origin_to_division_id END
				SELECT @v_to_site_type 		= dbo.FN_GET_SSP_SITE_INFO_EXCEPTION(@tmp_division_id,@v_from_site, @v_to_site, 'SITE_TYPE')
				SELECT @v_to_site_plant_id  = dbo.FN_GET_SSP_SITE_INFO(@tmp_division_id, @v_to_site, 'PLANT_ID')
				SELECT @v_to_site_vendor_id = dbo.FN_GET_SSP_SITE_INFO(@tmp_division_id, @v_to_site, 'VENDOR_ID')
				SELECT @v_to_site_company_id = dbo.FN_GET_SSP_SITE_INFO_EXCEPTION(@tmp_division_id,@v_from_site, @v_to_site, 'COMPANY_ID')
				SELECT @v_to_site_soldto_code = dbo.FN_GET_SSP_SITE_INFO(@tmp_division_id, @v_to_site, 'SOLDTO_CODE')
				SELECT @v_to_site_shipto_code = dbo.FN_GET_SSP_SITE_INFO(@tmp_division_id, @v_to_site, 'SHIPTO_CODE')


				--SELECT @v_from_site_type = (CASE WHEN FS.SITE_TYPE = 'SALES' THEN 'A' WHEN FS.SITE_TYPE = 'PLANT' AND FS.OSP_YN = 'N' THEN 'B' 
				--									WHEN FS.SITE_TYPE = 'PLANT' AND FS.OSP_YN = 'Y' THEN 'C'  
				--							END) 
				--	, @v_from_site_plant_id = FS.LOGISTIC_PLANT_ID 
				--	, @v_from_site_vendor_id = (CASE WHEN FS.SITE_TYPE = 'PLANT' AND FS.OSP_YN = 'Y' THEN FS.PLANT_ID  END)  
				--	, @v_from_site_company_id = FS.COMPANY_ID
				--FROM SCM_MST_SITE FS  WITH(NOLOCK)
				--WHERE  FS.DIVISION_ID = CASE WHEN @v_division_id = 'EE' THEN @v_origin_from_division_id ELSE @v_origin_from_division_id END
				--	AND FS.SCM_SITE_ID = @v_from_site 
				--	AND FS.VALID_YN    = 'Y' 
				--;

				--SELECT @v_to_site_type = CASE WHEN TS.SITE_TYPE = 'SALES' THEN 'A' -- Sales Site' -- FROM_SITE_TYPE
				--								WHEN TS.SITE_TYPE = 'PLANT' AND TS.OSP_YN = 'N' THEN 'B' -- Factory Site
				--								WHEN TS.SITE_TYPE = 'PLANT' AND TS.OSP_YN = 'Y' THEN 'C' -- Packer
				--							END                                                                            
				--	, @v_to_site_plant_id = TS.LOGISTIC_PLANT_ID
				--	, @v_to_site_vendor_id = CASE WHEN TS.SITE_TYPE = 'PLANT' AND TS.OSP_YN = 'Y' THEN TS.PLANT_ID END
				--	, @v_to_site_company_id = TS.COMPANY_ID             
				--FROM SCM_MST_SITE TS  WITH(NOLOCK)
				--WHERE TS.DIVISION_ID = CASE WHEN @v_division_id = 'EE' THEN @v_origin_from_division_id ELSE @v_origin_to_division_id END
				--	AND TS.SCM_SITE_ID = @v_to_site
				--	AND TS.VALID_YN    = 'Y' 
				--;

				--SELECT @v_to_site_soldto_code = TC.SOLDTO_CODE
				--	, @v_to_site_shipto_code = TC.SHIPTO_CODE
				--FROM SCM_MST_SITE_CUSTOMER TC  WITH(NOLOCK)
				--WHERE TC.DIVISION_ID = CASE WHEN @v_division_id = 'EE' THEN @v_origin_from_division_id ELSE @v_origin_to_division_id END
				--	AND TC.SCM_SITE_ID = @v_to_site
				--	AND TC.VALID_YN    = 'Y' 
				--	AND TC.REP_YN      = 'Y'
				--;

				SELECT @v_lot_size = L.LOT_SIZE
				FROM dbo.SCP_MST_SHIPMENT_LOT_SIZE L WITH(NOLOCK)
				WHERE L.DIVISION_ID  = @v_division_id
				AND L.FROM_SITE      = @v_from_site
				AND L.TO_SITE        = @v_to_site
				AND L.ITEM_ID        = @v_item_id   
				AND L.TRANSPORT_MODE = @v_transport_mode_temp
				AND L.VALID_YN       = 'Y'
				AND L.SPLIT_YN       = 'Y' -- 분할대상인것만 분할(2018.12.18) 
				;

				IF (ISNULL(@v_lot_size, 0) > 0) -- 분할 대상인 경우
				BEGIN
					-- 1) 수량입력 가능한 Confirm ID 순으로 Lot Size 만큼 수량 보정
					DECLARE CUR_M CURSOR FOR
					SELECT [CONFIRM_ID]
						  ,[QTY]
						  ,[BOD_ID]
						  ,[ROUTE_ID]
						  ,CONVERT(VARCHAR(10),		CONVERT(DATETIME, [ETD_DATE],112), 23) AS NEW_ETA
						  ,CONVERT(VARCHAR(10),		CONVERT(DATETIME, [ETA_DATE],112), 23) AS NEW_ETD
						  ,[D_COUNTRY]
						  ,[D_PORT_CODE]
						  ,[A_COUNTRY]
						  ,[A_PORT_CODE]
						  ,[CUSTOMER_LT]
						  ,[TO_COUNTRY]
						  ,[TO_CITY]
						  ,[ELECTRODE_YN]
						  ,[ELECTRODE_TYPE]
						  ,[ORIGIN_FROM_DIVISION_ID]
						  ,[ORIGIN_TO_DIVISION_ID]
						  ,[REMARKS]
						  ,[REMARKS2]
						  ,[REMARKS3]
					FROM SSP_ANL_SHIP_CONFIRM T0 WITH (NOLOCK)
					WHERE 1 = 1
					AND T0.change_type  = 'C'
					AND T0.BIZ_TYPE  <> 'E'
					AND (SHIPMENT_STATUS IS NOT NULL AND T0.SHIPMENT_STATUS = 'C' AND T0.ERP_STATUS IS NULL OR T0.ERP_STATUS != 'C')
					AND T0.qty >  0
					AND T0.division_id  = @p_division_id  
					AND T0.FROM_SITE_COMPANY_ID = @p_company_id
					--AND T0.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd 
					AND T0.yyyymmdd = @v_yyyymmdd
					AND ((@v_from_site		IS NULL OR @v_from_site			='' ) OR T0.from_site		IN (SELECT token FROM dbo.String_Split(@v_from_site, ',')))
					AND ((@v_item_id		IS NULL OR @v_item_id			='' ) OR T0.item_id			IN (SELECT token FROM dbo.String_Split(@v_item_id  , ','))) 
					AND ((@v_to_site		IS NULL OR @v_to_site			='' ) OR T0.TO_SITE			IN (SELECT token FROM dbo.String_Split(@v_to_site  , ','))) 
					AND ((@v_transport_mode IS NULL OR @v_transport_mode	='' ) OR T0.TRANSPORT_MODE  IN (SELECT token FROM dbo.String_Split(@v_transport_mode  , ','))) 
					AND ((@v_incoterms		IS NULL OR @v_incoterms			='' ) OR T0.INCOTERMS		IN (SELECT token FROM dbo.String_Split(@v_incoterms  , ','))) 
					AND ((@v_fcst_type		IS NULL OR @v_fcst_type			='' ) OR T0.FCST_TYPE		IN (SELECT token FROM dbo.String_Split(@v_fcst_type  , ','))) 
					--S/O 발행하지 않은 계획부터 감량한다. S/O 번호가 낮은 것 먼저 감량, 모두 S/O 발행되었을 경우, CONFIRM ID 번호가 낮은것 먼저 감량
					ORDER BY (CASE WHEN T0.ERP_SO_NO IS NULL THEN 0 ELSE 1 END)
						  , T0.ERP_SO_NO ASC, T0.CONFIRM_ID ASC
					;
					OPEN CUR_M;
					FETCH NEXT FROM CUR_M INTO @v_confirm_id, @v_shipment_qty, @v_bod_id
										   , @v_route_id, @v_etd_date, @v_eta_date
										   , @v_d_contry, @v_d_port_code, @v_a_country, @v_a_port_code, @v_customer_lt
										   , @v_to_country, @v_to_city, @v_electrode_yn, @v_electrode_type, @v_origin_from_division_id, @v_origion_to_division_id
										   , @v_remarks, @v_remarks2, @v_remarks3;

					WHILE @@FETCH_STATUS = 0
					BEGIN
						IF (@v_shipment_qty_temp = 0) BREAK;

						IF (@v_shipment_qty_temp >= @v_lot_size - @v_shipment_qty) --@v_shipment_qty_temp(10) , (Lot Size:1050 - Qty : 950) : 100
						BEGIN
							SET @v_shipment_qty_temp = @v_shipment_qty_temp - (@v_lot_size - @v_shipment_qty); 
							SET @v_shipment_qty = @v_lot_size;
						END
						ELSE
						BEGIN
							SET @v_shipment_qty = @v_shipment_qty + @v_shipment_qty_temp
							SET @v_shipment_qty_temp = 0
						END

						SET @v_etd_date = REPLACE(SUBSTRING(@v_etd_date,1,10),'-','');
					
						/* 2019.09.04 etd:shipdate, eta:etd+lt_day로 셋팅*/
						IF ISNULL(@v_yyyymmdd,'')!='' and LEN(@v_yyyymmdd)=8 and ISNULL(@v_customer_lt,'')!='' and LEN(@v_customer_lt)>0
						BEGIN
							SET @v_etd_date = @v_yyyymmdd
							;
						END
					
						/* 2019.10.29 출발일 기준 항차를 고려한 ETA_DATE 계산*/
						SET @v_eta_date = [dbo].[FN_GET_SSP_ETA_DATE](@p_division_id, @v_bod_id_temp, @v_yyyymmdd) 				
					
						INSERT SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE
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
							ATTRIBUTE2,
							CREATED_BY,									CREATION_DATE,						LAST_UPDATED_BY,							LAST_UPDATE_DATE,
							ELECTRODE_YN,								ELECTRODE_TYPE,						ORIGIN_FROM_DIVISION_ID,					ORIGIN_TO_DIVISION_ID,
							REMARKS,									REMARKS2,							REMARKS3,									REQUESTOR
						)
						SELECT 
							@v_max_req_no CHANGE_REQ_NO					,CONFIRM_ID							,'N' NEW_YN									,DIVISION_ID
							,ITEM_ID									,FROM_SITE							,TO_SITE									,YYYYMMDD
							,QTY										,BOD_ID								,ROUTE_ID									,BIZ_TYPE
							,PROJECT_CODE								,FCST_TYPE							,FCST_ETD_DATE								,FCST_ETA_DATE	
							,ETD_DATE									,ETA_DATE							,INCOTERMS									,TRANSPORT_MODE
							,D_COUNTRY									,D_PORT_CODE						,A_COUNTRY									,A_PORT_CODE
							,CUSTOMER_LT								,TO_COUNTRY							,TO_CITY									,@v_yyyymmdd NEW_YYYYMMDD
							,@v_shipment_qty  NEW_QTY					,@v_bod_id_temp NEW_BOD_ID			,@v_route_id_temp NEW_ROUTE_ID				,@v_etd_date NEW_ETD_DATE
							,@v_eta_date NEW_ETA_DATE					,@v_incoterms_temp NEW_INCOTERMS	,@v_transport_mode_temp NEW_TRANSPORT_MODE	,@v_d_contry_temp NEW_D_COUNTRY
							,@v_d_port_code_temp NEW_D_PORT_CODE		,@v_a_country_temp NEW_A_COUNTRY	,@v_a_port_code_temp NEW_A_PORT_CODE		,@v_customer_lt_temp NEW_CUSTOMER_LT
							,@v_to_country_temp NEW_TO_COUNTRY			,@v_to_city_temp NEW_TO_CITY 		,FROM_SITE_TYPE								,FROM_SITE_PLANT_ID	
							,FROM_SITE_VENDOR_ID						,FROM_SITE_SOLDTO_CODE				,FROM_SITE_SHIPTO_CODE						,FROM_SITE_COMPANY_ID
							,TO_SITE_TYPE								,TO_SITE_PLANT_ID					,TO_SITE_VENDOR_ID							,TO_SITE_SOLDTO_CODE
							,TO_SITE_SHIPTO_CODE						,TO_SITE_COMPANY_ID					,ERP_SO_NO									,ERP_SO_ITEM_NO
							,ERP_DO_NO									,ERP_STATUS							,'N'									,'N'
							,'A'
							,@p_user_id CREATED_BY						,@v_create_date						,@p_user_id LAST_UPDATED_BY					,@v_create_date--[dbo].[FN_MULTY_TIME](@p_time_zone) LAST_UPDATE_DATE
							,ELECTRODE_YN								,ELECTRODE_TYPE						,ORIGIN_FROM_DIVISION_ID					,ORIGIN_TO_DIVISION_ID
							,@v_remarks									,@v_remarks2						,@v_remarks3								,@p_user_id					
						FROM SSP_ANL_SHIP_CONFIRM A WITH(NOLOCK)
						WHERE CONFIRM_ID = @v_confirm_id;
					
						FETCH NEXT FROM CUR_M INTO @v_confirm_id, @v_shipment_qty, @v_bod_id
										   , @v_route_id, @v_etd_date, @v_eta_date
										   , @v_d_contry, @v_d_port_code, @v_a_country, @v_a_port_code, @v_customer_lt
										   , @v_to_country, @v_to_city, @v_electrode_yn, @v_electrode_type, @v_origin_from_division_id, @v_origion_to_division_id
										   , @v_remarks, @v_remarks2, @v_remarks3;
					END

					CLOSE CUR_M;
					DEALLOCATE CUR_M;

					-- 2) 기존 Confrim ID에 모두 입력후 입력할 수량이 남은 경우 LOT SIZE 만큼 분활하여 신규 생성
					IF (@v_shipment_qty_temp > 0)
					BEGIN
						INSERT SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE
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
							ATTRIBUTE2,
							CREATED_BY,									CREATION_DATE,						LAST_UPDATED_BY,							LAST_UPDATE_DATE,
							ELECTRODE_YN,								ELECTRODE_TYPE,						ORIGIN_FROM_DIVISION_ID,					ORIGIN_TO_DIVISION_ID,
							REMARKS,									REMARKS2,							REMARKS3,									REQUESTOR
						)
						SELECT 
							@v_max_req_no CHANGE_REQ_NO					,'C'+ CONVERT(VARCHAR(8), GETDATE(), 112) + RIGHT('000000' + CONVERT(NVARCHAR, NEXT VALUE FOR SEQ1_SSP_ANL_SHIP_CONFIRM_ID),6) AS CONFIRM_ID							
							,'N' NEW_YN									,@v_division_id
							,@v_item_id									,@v_from_site						,@v_to_site									,@v_yyyymmdd
							,0 AS QTY									,@v_bod_id_temp						,@v_route_id_temp							,@v_operation_group
							,@v_project_code							,@v_fcst_type						,@v_yyyymmdd								,@v_eta_date
							,@v_yyyymmdd								,@v_eta_date						,@v_incoterms_temp							,@v_transport_mode_temp
							,@v_d_contry_temp							,@v_d_port_code_temp				,@v_a_country_temp							,@v_a_port_code_temp
							,@v_customer_lt_temp						,@v_to_country_temp					,@v_to_city_temp							,@v_yyyymmdd NEW_YYYYMMDD
							,CASE WHEN  @v_shipment_qty_temp <= ISNULL(L.LOT_SIZE ,@v_shipment_qty_temp) THEN  @v_shipment_qty_temp 
								ELSE  
								CASE WHEN  @v_shipment_qty_temp / (ISNULL(L.LOT_SIZE ,@v_shipment_qty_temp) * C.SEQ) >= 1 THEN ISNULL(L.LOT_SIZE ,@v_shipment_qty_temp)
								ELSE @v_shipment_qty_temp % (ISNULL(L.LOT_SIZE ,@v_shipment_qty_temp)*(C.SEQ-1))
								END 
								END NEW_QTY					
							,@v_bod_id_temp NEW_BOD_ID					,@v_route_id_temp NEW_ROUTE_ID		,@v_etd_date NEW_ETD_DATE
							,@v_eta_date NEW_ETA_DATE					,@v_incoterms_temp NEW_INCOTERMS	,@v_transport_mode_temp NEW_TRANSPORT_MODE	,@v_d_contry_temp NEW_D_COUNTRY
							,@v_d_port_code_temp NEW_D_PORT_CODE		,@v_a_country_temp NEW_A_COUNTRY	,@v_a_port_code_temp NEW_A_PORT_CODE		,@v_customer_lt_temp NEW_CUSTOMER_LT
							,@v_to_country_temp NEW_TO_COUNTRY			,@v_to_city_temp NEW_TO_CITY 		,@v_from_site_type							,@v_from_site_plant_id	
							,@v_from_site_vendor_id						,@v_from_site_soldto_code			,@v_from_site_shipto_code					,@v_from_site_company_id
							,@v_to_site_type							,@v_to_site_plant_id				,@v_to_site_vendor_id						,@v_to_site_soldto_code
							,@v_to_site_shipto_code						,@v_to_site_company_id				,NULL										,NULL
							,@v_package_type_code						,NULL								,'N'										,'N'
							,'A'
							,@p_user_id CREATED_BY						,@v_create_date						,@p_user_id LAST_UPDATED_BY					,@v_create_date--[dbo].[FN_MULTY_TIME](@p_time_zone) LAST_UPDATE_DATE
							,@v_electrode_yn							,@v_electrode_type					,@v_origin_from_division_id					,@v_origin_to_division_id
							,@v_remarks									,@v_remarks2						,@v_remarks3								,@p_user_id				
						FROM (SELECT @v_division_id	AS DIVISION_ID
								,	@v_from_site	AS FROM_SITE
								,	@v_to_site		AS TO_SITE
								,	@v_item_id		AS ITEM_ID
								,	@v_transport_mode_temp AS TRANSPORT_MODE
								) AS A
						LEFT OUTER JOIN SCP_MST_SHIPMENT_LOT_SIZE L WITH(NOLOCK)
						ON L.DIVISION_ID     = A.DIVISION_ID 
						AND L.FROM_SITE      = A.FROM_SITE
						AND L.TO_SITE        = A.TO_SITE
						AND L.ITEM_ID        = A.ITEM_ID   
						AND L.TRANSPORT_MODE = A.TRANSPORT_MODE
						AND L.VALID_YN       = 'Y'
						AND L.SPLIT_YN       = 'Y' -- 분할대상인것만 분할(2018.12.18) 
						JOIN SSP_MST_PARTIAL_SEQ C WITH(NOLOCK) -- LOT SIZE별 행 생성을 위한 기초테이블 
						ON C.SEQ <= CEILING(@v_shipment_qty_temp/ISNULL(L.LOT_SIZE ,@v_shipment_qty_temp))
					END
				END
				ELSE	--분할 대상이 아닌 경우
				BEGIN
					INSERT SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE
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
						ATTRIBUTE2,
						CREATED_BY,									CREATION_DATE,						LAST_UPDATED_BY,							LAST_UPDATE_DATE,
						ELECTRODE_YN,								ELECTRODE_TYPE,						ORIGIN_FROM_DIVISION_ID,					ORIGIN_TO_DIVISION_ID,
						REMARKS,									REMARKS2,							REMARKS3,									REQUESTOR
					)
					SELECT 
						@v_max_req_no CHANGE_REQ_NO					,'C'+ CONVERT(VARCHAR(8), GETDATE(), 112) + RIGHT('000000' + CONVERT(NVARCHAR, NEXT VALUE FOR SEQ1_SSP_ANL_SHIP_CONFIRM_ID),6) AS CONFIRM_ID							
						,'N' NEW_YN									,@v_division_id
						,@v_item_id									,@v_from_site						,@v_to_site									,@v_yyyymmdd
						,0 AS QTY									,@v_bod_id_temp						,@v_route_id_temp							,@v_operation_group
						,@v_project_code							,@v_fcst_type						,@v_yyyymmdd								,@v_eta_date
						,@v_yyyymmdd								,@v_eta_date						,@v_incoterms_temp							,@v_transport_mode_temp
						,@v_d_contry_temp							,@v_d_port_code_temp				,@v_a_country_temp							,@v_a_port_code_temp
						,@v_customer_lt_temp						,@v_to_country_temp					,@v_to_city_temp							,@v_yyyymmdd NEW_YYYYMMDD
						,@v_shipment_qty_temp	NEW_QTY					
						,@v_bod_id_temp			NEW_BOD_ID			,@v_route_id_temp	NEW_ROUTE_ID	,@v_etd_date			NEW_ETD_DATE
						,@v_eta_date			NEW_ETA_DATE		,@v_incoterms_temp	NEW_INCOTERMS	,@v_transport_mode_temp NEW_TRANSPORT_MODE	,@v_d_contry_temp NEW_D_COUNTRY
						,@v_d_port_code_temp	NEW_D_PORT_CODE		,@v_a_country_temp	NEW_A_COUNTRY	,@v_a_port_code_temp	NEW_A_PORT_CODE		,@v_customer_lt_temp NEW_CUSTOMER_LT
						,@v_to_country_temp		NEW_TO_COUNTRY		,@v_to_city_temp	NEW_TO_CITY 	,@v_from_site_type							,@v_from_site_plant_id	
						,@v_from_site_vendor_id						,@v_from_site_soldto_code			,@v_from_site_shipto_code					,@v_from_site_company_id
						,@v_to_site_type							,@v_to_site_plant_id				,@v_to_site_vendor_id						,@v_to_site_soldto_code
						,@v_to_site_shipto_code						,@v_to_site_company_id				,NULL										,NULL
						,@v_package_type_code						,NULL								,'N'										,'N'
						,'A'
						,@p_user_id CREATED_BY						,@v_create_date						,@p_user_id LAST_UPDATED_BY					,@v_create_date--[dbo].[FN_MULTY_TIME](@p_time_zone) LAST_UPDATE_DATE
						,@v_electrode_yn							,@v_electrode_type					,@v_origin_from_division_id					,@v_origin_to_division_id
						,@v_remarks									,@v_remarks2						,@v_remarks3								,@p_user_id		
					;
				END
			END

			-- 감량또는 증량 제외한 Confirm ID 외 수정가능한 Confirm 데이터를 SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE 테이블에 입력
			IF (@v_old_shipment_qty != @v_new_shipment_qty)
			BEGIN
				INSERT SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE
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
					ATTRIBUTE2,
					CREATED_BY,									CREATION_DATE,						LAST_UPDATED_BY,							LAST_UPDATE_DATE,
					ELECTRODE_YN,								ELECTRODE_TYPE,						ORIGIN_FROM_DIVISION_ID,					ORIGIN_TO_DIVISION_ID,
					REMARKS,									REMARKS2,							REMARKS3,									REQUESTOR
				)
				SELECT 
					@v_max_req_no CHANGE_REQ_NO					,A.CONFIRM_ID							
					,'N' NEW_YN									,A.DIVISION_ID
					,A.ITEM_ID									,A.FROM_SITE						,A.TO_SITE									,A.YYYYMMDD
					,A.QTY 										,A.BOD_ID							,A.ROUTE_ID									,A.BIZ_TYPE
					,A.PROJECT_CODE								,A.FCST_TYPE						,A.FCST_ETD_DATE							,A.FCST_ETA_DATE	
					,A.ETD_DATE									,A.ETA_DATE							,A.INCOTERMS								,A.TRANSPORT_MODE
					,A.D_COUNTRY								,A.D_PORT_CODE						,A.A_COUNTRY								,A.A_PORT_CODE
					,A.CUSTOMER_LT								,A.TO_COUNTRY						,A.TO_CITY									,A.YYYYMMDD AS NEW_YYYYMMDD
					,A.QTY NEW_QTY								,A.BOD_ID AS NEW_BOD_ID				,A.ROUTE_ID AS NEW_ROUTE_ID					,A.ETD_DATE AS NEW_ETD_DATE
					,A.ETD_DATE AS NEW_ETA_DATE					,A.INCOTERMS AS NEW_INCOTERMS		,A.TRANSPORT_MODE AS NEW_TRANSPORT_MODE		,A.D_COUNTRY AS NEW_D_COUNTRY
					,A.D_PORT_CODE AS NEW_D_PORT_CODE			,A.A_COUNTRY AS NEW_A_COUNTRY		,A.A_PORT_CODE AS NEW_A_PORT_CODE			,A.CUSTOMER_LT AS NEW_CUSTOMER_LT
					,A.TO_COUNTRY AS NEW_TO_COUNTRY				,A.TO_CITY AS NEW_TO_CITY 			,A.FROM_SITE_TYPE							,A.FROM_SITE_PLANT_ID	
					,A.FROM_SITE_VENDOR_ID						,A.FROM_SITE_SOLDTO_CODE			,A.FROM_SITE_SHIPTO_CODE					,A.FROM_SITE_COMPANY_ID
					,A.TO_SITE_TYPE								,A.TO_SITE_PLANT_ID					,A.TO_SITE_VENDOR_ID						,A.TO_SITE_SOLDTO_CODE
					,A.TO_SITE_SHIPTO_CODE						,A.TO_SITE_COMPANY_ID				,A.ERP_SO_NO								,A.ERP_SO_ITEM_NO
					,A.ERP_DO_NO								,A.ERP_STATUS						,'N'									,'N'
					,'A'
					,@p_user_id CREATED_BY						,@v_create_date						,@p_user_id LAST_UPDATED_BY					,@v_create_date--[dbo].[FN_MULTY_TIME](@p_time_zone) LAST_UPDATE_DATE
					,A.ELECTRODE_YN								,A.ELECTRODE_TYPE					,A.ORIGIN_FROM_DIVISION_ID					,A.ORIGIN_TO_DIVISION_ID
					,@v_remarks									,@v_remarks2						,@v_remarks3								,@p_user_id					
				FROM dbo.SSP_ANL_SHIP_CONFIRM A WITH (NOLOCK)
				WHERE 1 = 1
				AND A.change_type  = 'C'
				AND A.BIZ_TYPE  <> 'E'
				AND (SHIPMENT_STATUS IS NOT NULL AND A.SHIPMENT_STATUS = 'C' AND A.ERP_STATUS IS NULL OR A.ERP_STATUS != 'C')
				AND A.qty >  0
				AND A.division_id  = @p_division_id  
				AND A.FROM_SITE_COMPANY_ID = @p_company_id
				--AND T0.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd 
				AND A.yyyymmdd = @v_yyyymmdd
				AND ((@v_from_site		IS NULL OR @v_from_site			='' ) OR A.from_site		IN (SELECT token FROM dbo.String_Split(@v_from_site, ',')))
				AND ((@v_item_id		IS NULL OR @v_item_id			='' ) OR A.item_id			IN (SELECT token FROM dbo.String_Split(@v_item_id  , ','))) 
				AND ((@v_to_site		IS NULL OR @v_to_site			='' ) OR A.TO_SITE			IN (SELECT token FROM dbo.String_Split(@v_to_site  , ','))) 
				AND ((@v_transport_mode IS NULL OR @v_transport_mode	='' ) OR A.TRANSPORT_MODE   IN (SELECT token FROM dbo.String_Split(@v_transport_mode  , ','))) 
				AND ((@v_incoterms		IS NULL OR @v_incoterms			='' ) OR A.INCOTERMS		IN (SELECT token FROM dbo.String_Split(@v_incoterms  , ','))) 
				AND ((@v_fcst_type		IS NULL OR @v_fcst_type			='' ) OR A.FCST_TYPE		IN (SELECT token FROM dbo.String_Split(@v_fcst_type  , ','))) 
				AND NOT EXISTS (SELECT 'X' 
								FROM dbo.SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE AS B WITH(NOLOCK) 
								WHERE B.CHANGE_REQ_NO = @v_max_req_no
								AND   B.CONFIRM_ID = A.CONFIRM_ID
								)
				;
			END
		END
		--EXEC PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH 'C', @v_max_req_no;
			
		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
					
		-- 결과코드, 결과 카운트 반환
		SELECT  'S' AS result_code,  @max_loop_cnt AS result_cnt;
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
