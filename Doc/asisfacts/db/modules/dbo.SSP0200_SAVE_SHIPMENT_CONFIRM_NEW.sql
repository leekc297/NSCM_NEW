
/*
 * Program ID   : SSP0200_SAVE_SHIPMENT_CONFIRM_NEW
 * Description  : Shipment Request NEW 저장
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 * 2021/06/07	KIMYONGHO		신규추가
 * 2021/10/18   SHINMYUNGSU	   SSP_ANL_SHIP_CONFIRM의 ERP_ATTR1~3 항목 추가
 * 2023/02/06   jilee   	   PR_DM_SSP_CONFIRM_SYNC 동기화 추가
 * 2023/05/08   jilee          @v_plan_start_yyyymmdd 누락시 현재 날짜로 삽입
 * 2025/08/18   chkim.68       [E20250821-001308] -- to_company_id를 from_site에 따라 to_company_id가 다르게 적용되는 예외를 적용 (scm_site_company_exception)
							FN_GET_SSP_SITE_INFO -> [FN_GET_SSP_SITE_INFO_EXCEPTION] 
							   SSP_SITE_INFO를 이용하여 scm_site_company를 획득하도록 공통화
 * 2026/05/11   강주용       E20260514-001358 TO_ shipto / soldto 없는 경우 출하 금지
 * 2026/10/15	강주용		[EXXXXXX-XXXXXXXX] 판가 벨리데이션 제거
 *===================================================================================================
 */
CREATE PROCEDURE [dbo].[SSP0200_SAVE_SHIPMENT_CONFIRM_NEW]
	@p_active_flag					NVARCHAR(MAX)
	,@p_division_id					NVARCHAR(MAX)
	,@p_from_site					NVARCHAR(MAX)
	,@p_to_site						NVARCHAR(MAX)
	,@p_project_code40				NVARCHAR(MAX)
	,@p_project_code				NVARCHAR(MAX)
	,@p_fcst_type					NVARCHAR(MAX)
	,@p_item_id						NVARCHAR(MAX)
	,@p_shipment_date				NVARCHAR(MAX)
	,@p_shipment_qty				NVARCHAR(MAX)	
	,@p_incoterms					NVARCHAR(MAX)
	,@p_transport_mode				NVARCHAR(MAX)
	,@p_lt							NVARCHAR(MAX)
	,@p_etd							NVARCHAR(MAX)
	,@p_eta							NVARCHAR(MAX)
	,@p_route_id					NVARCHAR(MAX)
	,@p_bod_id						NVARCHAR(MAX)
	,@p_d_country					NVARCHAR(MAX)
	,@p_d_port_code					NVARCHAR(MAX)
	,@p_a_conuntry					NVARCHAR(MAX)
	,@p_a_port_code					NVARCHAR(MAX)
	,@p_to_country					NVARCHAR(MAX)
	,@p_to_city						NVARCHAR(MAX)
	,@p_remarks						NVARCHAR(MAX)
	,@p_remarks2					NVARCHAR(MAX)
	,@p_remarks3					NVARCHAR(MAX)
	,@p_user_id						NVARCHAR(MAX)
	,@p_time_zone					NVARCHAR(MAX)

	/**** 20211018   SHINMYUNGSU   항목추가   ************/
	,@p_erp_attr1					NVARCHAR(MAX)
	,@p_erp_attr2					NVARCHAR(MAX)
	,@p_erp_attr3					NVARCHAR(MAX)
	/*********************************************************/
	--,@p_new_yn 추가 필요함

AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	
	DECLARE @recv_active_flag		NVARCHAR(MAX);
	SET @recv_active_flag = NULL;		
	SET @recv_active_flag = @p_active_flag;

	DECLARE @v_active_flag				NVARCHAR(MAX);
	DECLARE @v_division_id				NVARCHAR(MAX)
	--DECLARE @v_confirm_id				NVARCHAR(MAX)
	DECLARE @v_shipment_qty				NVARCHAR(MAX)
	DECLARE @v_shipment_date			NVARCHAR(MAX)
	DECLARE @v_new_bod_id				NVARCHAR(MAX)
	DECLARE @v_new_etd_date				NVARCHAR(MAX)
	DECLARE @v_new_eta_date				NVARCHAR(MAX)
	DECLARE @v_new_route_id				NVARCHAR(MAX)
	DECLARE @v_new_incoterms			NVARCHAR(MAX)
	DECLARE @v_new_transport_mode		NVARCHAR(MAX)
	DECLARE @v_new_d_contry				NVARCHAR(MAX)
	DECLARE @v_new_d_port_code			NVARCHAR(MAX)
	DECLARE @v_new_a_country			NVARCHAR(MAX)
	DECLARE @v_new_a_port_code			NVARCHAR(MAX)
	DECLARE @v_new_customer_lt			NVARCHAR(MAX)
	DECLARE @v_new_to_country			NVARCHAR(MAX)
	DECLARE @v_new_to_city				NVARCHAR(MAX)

	DECLARE @v_remarks					NVARCHAR(MAX)
	DECLARE @v_remarks2					NVARCHAR(MAX)
	DECLARE @v_remarks3					NVARCHAR(MAX)

	DECLARE @v_new_confirm_id			NVARCHAR(max);
	DECLARE @v_plan_start_yyyymmdd		NVARCHAR(MAX);
	DECLARE @v_seq						NVARCHAR(MAX);

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
	DECLARE @v_eta						NVARCHAR(MAX);
	DECLARE @v_etd						NVARCHAR(MAX);

	DECLARE @v_last_update_date			datetime;

	--DECLARE @v_sales_price_check_cnt    INTEGER = 0;	[EXXXXXX-XXXXXXXX] 판가 벨리데이션 제거
	--DECLARE @v_mkt_fcst_check_cnt		INTEGER = 0;	[EXXXXXX-XXXXXXXX] 판가 벨리데이션 제거


	DECLARE @v_operation_group			NVARCHAR(MAX);
	DECLARE @v_electrode_yn				NVARCHAR(MAX);
	DECLARE @v_origin_from_division_id	NVARCHAR(MAX);
	DECLARE @v_origin_to_division_id	NVARCHAR(MAX);

	DECLARE @v_from_site				NVARCHAR(MAX);
	DECLARE @v_to_site					NVARCHAR(MAX);
	DECLARE @v_project_code_40			NVARCHAR(MAX);
	DECLARE @v_project_code				NVARCHAR(MAX);
	DECLARE @v_fcst_type				NVARCHAR(MAX);
	DECLARE @v_item_id					NVARCHAR(MAX);

	/**** 20211018   SHINMYUNGSU   항목추가   ****************/
	DECLARE @v_erp_attr1				NVARCHAR(MAX)
	DECLARE @v_erp_attr2				NVARCHAR(MAX)
	DECLARE @v_erp_attr3				NVARCHAR(MAX)
	/*********************************************************/
	-- start E20260514-001358 TO_ shipto / soldto 없는 경우 출하 금지
	DECLARE @v_division_id_or nvarchar(max) = ''--		   = V.DIVISION_ID 
	DECLARE @v_new_bod_id_or nvarchar(max) = ''--	   = V.BOD_ID 
	DECLARE @v_from_site_or nvarchar(max) = ''--		   = V.FROM_SITE
	DECLARE @v_to_site_or nvarchar(max) = ''	--		   = V.TO_SITE 
	DECLARE @v_new_incoterms_or nvarchar(max) = ''--      = V.SSP_INCOTERMS
	DECLARE @v_new_transport_mode_or nvarchar(max) = ''-- = V.TRANSPORT_MODE
	DECLARE @v_new_route_id_or nvarchar(max) = ''	  -- = V.ROUTE_ID 
	DECLARE @v_new_d_contry_or nvarchar(max) = ''	  -- = V.D_COUNTRY        
	DECLARE @v_new_d_port_code_or nvarchar(max) = ''  --  = V.D_PORT_CODE      
	DECLARE @v_new_a_country_or nvarchar(max) = ''    --  = V.A_COUNTRY        
	DECLARE @v_new_a_port_code_or nvarchar(max) = ''  --  = V.A_PORT_CODE      
	DECLARE @v_new_customer_lt_or nvarchar(max) = ''  --  = V.LT_TOTAL      
	DECLARE @v_new_to_country_or nvarchar(max) = ''   --  = V.TO_COUNTRY       
	DECLARE @v_new_to_city_or nvarchar(max) = ''--		   = V.TO_CITY
	-- end E20260514-001358 TO_ shipto / soldto 없는 경우 출하 금지

	
	SET @v_from_site_type			= NULL
	SET @v_from_site_plant_id		= NULL
	SET @v_from_site_vendor_id		= NULL
	SET @v_from_site_company_id		= NULL
	SET @v_from_site_soldto_code	= NULL
	SET @v_from_site_shipto_code	= NULL

	SET @v_to_site_type				= NULL
	SET @v_to_site_plant_id			= NULL
	SET @v_to_site_vendor_id		= NULL
	SET @v_to_site_company_id		= NULL
	SET @v_to_site_soldto_code		= NULL
	SET @v_to_site_shipto_code		= NULL
	SET @v_eta						= NULL
	SET @v_etd						= NULL

	--SET @v_sales_price_check_cnt	= 0	[EXXXXXX-XXXXXXXX] 판가 벨리데이션 제거
	--SET @v_mkt_fcst_check_cnt		= 0	[EXXXXXX-XXXXXXXX] 판가 벨리데이션 제거


	SET @v_operation_group			= NULL
	SET @v_electrode_yn				= NULL
	SET @v_origin_from_division_id	= NULL
	SET @v_origin_to_division_id	= NULL


	SET @v_from_site				= NULL
	SET @v_to_site					= NULL
	SET @v_project_code_40			= NULL
	SET @v_project_code				= NULL
	SET @v_fcst_type				= NULL
	SET @v_item_id					= NULL

	/**** 20211018   SHINMYUNGSU   항목추가   ****************/
	SET @v_erp_attr1				= null;
	SET @v_erp_attr2				= null;
	SET @v_erp_attr3				= null;
	/*********************************************************/

	--SET @v_last_update_date    = SYSDATETIME();

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SSP0200_SAVE_SHIPMENT_CONFIRM_NEW';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;	

	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^' 
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;

	-- validation 변수 설정
	DECLARE @v_val_code  INT=0;
	
	----트렌젝션 시작
	--BEGIN TRAN TX_SH

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
					SET @v_active_flag			= dbo.SCM_ARR_SPL_VAL( @p_active_flag		, @v_delimiter, @mst_loop_cnt );
					SET @v_division_id			= dbo.SCM_ARR_SPL_VAL( @p_division_id		, @v_delimiter, @mst_loop_cnt );
					SET @v_from_site			= dbo.SCM_ARR_SPL_VAL( @p_from_site			, @v_delimiter, @mst_loop_cnt );
					SET @v_to_site				= dbo.SCM_ARR_SPL_VAL( @p_to_site			, @v_delimiter, @mst_loop_cnt );
					SET @v_project_code_40		= dbo.SCM_ARR_SPL_VAL( @p_project_code40	, @v_delimiter, @mst_loop_cnt );
					SET @v_project_code			= dbo.SCM_ARR_SPL_VAL( @p_project_code		, @v_delimiter, @mst_loop_cnt );
					SET @v_fcst_type			= dbo.SCM_ARR_SPL_VAL( @p_fcst_type			, @v_delimiter, @mst_loop_cnt );
					SET @v_item_id				= dbo.SCM_ARR_SPL_VAL( @p_item_id			, @v_delimiter, @mst_loop_cnt );
					SET @v_shipment_date		= dbo.SCM_ARR_SPL_VAL( @p_shipment_date		, @v_delimiter, @mst_loop_cnt );
					SET @v_shipment_qty			= dbo.SCM_ARR_SPL_VAL( @p_shipment_qty		, @v_delimiter, @mst_loop_cnt );
					SET @v_new_incoterms		= dbo.SCM_ARR_SPL_VAL( @p_incoterms			, @v_delimiter, @mst_loop_cnt );
					SET @v_new_transport_mode	= dbo.SCM_ARR_SPL_VAL( @p_transport_mode	, @v_delimiter, @mst_loop_cnt );
					SET @v_new_customer_lt		= dbo.SCM_ARR_SPL_VAL( @p_lt				, @v_delimiter, @mst_loop_cnt );
					SET @v_new_etd_date			= dbo.SCM_ARR_SPL_VAL( @p_etd				, @v_delimiter, @mst_loop_cnt );
					SET @v_new_eta_date			= dbo.SCM_ARR_SPL_VAL( @p_eta				, @v_delimiter, @mst_loop_cnt );
					SET @v_new_route_id			= dbo.SCM_ARR_SPL_VAL( @p_route_id			, @v_delimiter, @mst_loop_cnt );
					SET @v_new_bod_id			= dbo.SCM_ARR_SPL_VAL( @p_bod_id			, @v_delimiter, @mst_loop_cnt );
					SET @v_new_d_contry			= dbo.SCM_ARR_SPL_VAL( @p_d_country			, @v_delimiter, @mst_loop_cnt );
					SET @v_new_d_port_code		= dbo.SCM_ARR_SPL_VAL( @p_d_port_code		, @v_delimiter, @mst_loop_cnt );
					SET @v_new_a_country		= dbo.SCM_ARR_SPL_VAL( @p_a_conuntry		, @v_delimiter, @mst_loop_cnt );
					SET @v_new_a_port_code		= dbo.SCM_ARR_SPL_VAL( @p_a_port_code		, @v_delimiter, @mst_loop_cnt );				
					SET @v_new_to_country		= dbo.SCM_ARR_SPL_VAL( @p_to_country		, @v_delimiter, @mst_loop_cnt );
					SET @v_new_to_city			= dbo.SCM_ARR_SPL_VAL( @p_to_city			, @v_delimiter, @mst_loop_cnt );
					SET @v_remarks				= dbo.SCM_ARR_SPL_VAL( @p_remarks			, @v_delimiter, @mst_loop_cnt );
					SET @v_remarks2				= dbo.SCM_ARR_SPL_VAL( @p_remarks2			, @v_delimiter, @mst_loop_cnt );
					SET @v_remarks3				= dbo.SCM_ARR_SPL_VAL( @p_remarks3			, @v_delimiter, @mst_loop_cnt );

					/**** 20211018   SHINMYUNGSU   항목추가   ******************************************************************/
					SET @v_erp_attr1			= dbo.SCM_ARR_SPL_VAL( @p_erp_attr1			, @v_delimiter, @mst_loop_cnt );
					SET @v_erp_attr2			= dbo.SCM_ARR_SPL_VAL( @p_erp_attr2			, @v_delimiter, @mst_loop_cnt );
					SET @v_erp_attr3			= dbo.SCM_ARR_SPL_VAL( @p_erp_attr3			, @v_delimiter, @mst_loop_cnt );
					/***********************************************************************************************************/
				END;
-------------------------------------------------------------------------------------------
				--SELECT TRANSPORT_MODE CODE  
			 --    ,TRANSPORT_MODE NAME
				-- ,BOD_ID
				--,ROUTE_ID 
				--,SSP_INCOTERMS         AS INCOTERMS
				--,D_COUNTRY        
				--,D_PORT_CODE      
				--,A_COUNTRY        
				--,A_PORT_CODE      
				--,LT_TOTAL      
				--,LT_TOTAL_ORIGIN	-- 전극 출하계획 대응 컬럼 추가 
				--,TO_COUNTRY       
				--,TO_CITY          
				--FROM scp_mst_bod_n_v  WITH(NOLOCK)   -- scp_mst_bod_n_v  WITH(NOLOCK) 
				--WHERE 1=1 
				--AND division_id = @v_division_id
				--AND from_site = @v_from_site
				--AND to_site = @v_to_site
				--AND TRANSPORT_MODE = @v_new_transport_mode
				--AND ssp_incoterms = @v_new_incoterms
				--AND bod_valid_yn = 'Y'
				--order by priority
				--;
				
			SET @v_division_id_or =@v_division_id
			SET @v_new_bod_id_or = @v_new_bod_id
			SET @v_from_site_or = @v_from_site
			SET @v_to_site_or = @v_to_site
			SET @v_new_incoterms_or   = @v_new_incoterms
			SET @v_new_transport_mode_or = @v_new_transport_mode
			SET @v_new_route_id_or= @v_new_route_id
			SET @v_new_d_contry_or	= @v_new_d_contry
			SET @v_new_d_port_code_or  = @v_new_d_port_code
			SET @v_new_a_country_or   = @v_new_a_country
			SET @v_new_a_port_code_or  = @v_new_a_port_code
			SET @v_new_customer_lt_or = @v_new_customer_lt
			SET @v_new_to_country_or   = @v_new_to_country
			SET @v_new_to_city_or	= @v_new_to_city

				SELECT TOP 1
					 @v_division_id		   = V.DIVISION_ID 
					,@v_new_bod_id		   = V.BOD_ID 
					,@v_from_site		   = V.FROM_SITE
					,@v_to_site			   = V.TO_SITE 
					,@v_new_incoterms      = V.SSP_INCOTERMS
					,@v_new_transport_mode = V.TRANSPORT_MODE
					,@v_new_route_id	   = V.ROUTE_ID 
					,@v_new_d_contry	   = V.D_COUNTRY        
					,@v_new_d_port_code    = V.D_PORT_CODE      
					,@v_new_a_country      = V.A_COUNTRY        
					,@v_new_a_port_code    = V.A_PORT_CODE      
					,@v_new_customer_lt    = V.LT_TOTAL      
					,@v_new_to_country     = V.TO_COUNTRY       
					,@v_new_to_city		   = V.TO_CITY

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
									--FROM scp_mst_bod_n_v WITH(NOLOCK) 
									FROM SCP_MST_BOD_N_V WITH(NOLOCK) 
									WHERE DIVISION_ID = @v_division_id
									AND   FROM_SITE   = @v_from_site
									AND   TO_SITE   = @v_to_site
									AND	  TRANSPORT_MODE = @v_new_transport_mode
									AND	  ssp_incoterms = @v_new_incoterms
									AND   BOD_VALID_YN ='Y'				
									AND   FROM_YYYYMMDD <= @v_shipment_date
									AND   TO_YYYYMMDD >= @v_shipment_date

								)  B 
		
				   )  V

					JOIN ( SELECT DISTINCT DIVISION_ID , ITEM_ID , BOD_ID 
						   FROM   SCP_MST_BOD_ITEM  WITH(NOLOCK)   -- SCP_MST_BOD_ITEM A WITH(NOLOCK) 
						   WHERE  DIVISION_ID =   @v_division_id
						   AND    ITEM_ID  = @v_item_id 
						  )   A
					  ON A.DIVISION_ID  = V.DIVISION_ID 
					 AND A.BOD_ID       = V.BOD_ID

				WHERE 1=1
				  AND V.division_id = @v_division_id
				  AND V.from_site = @v_from_site
				  AND V.to_site = @v_to_site
				  AND V.TRANSPORT_MODE = @v_new_transport_mode
				  AND V.ssp_incoterms = @v_new_incoterms
				  AND V.bod_valid_yn = 'Y'
				order by V.PRIORITY


				IF ( (@v_division_id			= '' OR @v_division_id IS NULL				)
					OR (@v_new_bod_id			= '' OR @v_new_bod_id IS  NULL				)
					OR (@v_from_site			= '' OR @v_from_site IS NULL		   		)
					OR (@v_to_site				= '' OR @v_to_site IS NULL			   		)
					OR (@v_new_incoterms		= '' OR @v_new_incoterms IS NULL			)
					OR (@v_new_transport_mode	= '' OR @v_new_transport_mode IS NULL		)
					OR (@v_new_route_id			= '' OR @v_new_route_id IS NULL				)
					OR (@v_new_d_contry			= '' OR @v_new_d_contry IS NULL	 			)
					OR (@v_new_d_port_code		= '' OR @v_new_d_port_code IS NULL	  		)
					OR (@v_new_a_country		= '' OR @v_new_a_country IS NULL	  		)
					OR (@v_new_a_port_code		= '' OR @v_new_a_port_code IS NULL	 		)
					OR (@v_new_customer_lt		= '' OR @v_new_customer_lt IS NULL	 		)
					OR (@v_new_to_country		= '' OR @v_new_to_country IS NULL			)
					OR (@v_new_to_city			= '' OR @v_new_to_city IS NULL				)
					)
					BEGIN
						
						SELECT 'X' AS result_code;
						SET @v_log_type = 'END';
						SET @v_log_message = '########## END of procedure ##########';
						--SET @v_description = 'Confrim_ID : ' + @v_new_confirm_id + ' / Time Zone : ' + @v_tmp_fn_time_zone + ' / Seq : ' + @v_tmp_seq_confirm;
						SET @d_event_date = SYSDATETIME();
						
						EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

						RETURN;
						
					END 
------------------------------------------------------------------------------------------


				SELECT  @v_origin_from_division_id =  DIVISION_ID  
					   ,@v_operation_group		   =  OPERATION_GROUP
				FROM SCM_MST_SITE WITH(NOLOCK) 
				WHERE SCM_SITE_ID  = @v_from_site 
				AND   DIVISION_ID =  @v_division_id
				AND   VALID_YN  = 'Y'
				;

				IF @v_project_code = '-'
					BEGIN
						SET @v_project_code = '';
					END		

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
						-- AND   SITE_TYPE  = 'PLANT'
						 ;
				
					END   

				DECLARE @v_cnt_item_id	INT =0;
				SET @v_cnt_item_id = ISNULL((
										select COUNT(DIVISION_ID) from (
												SELECT distinct
													D.DIVISION_ID
												FROM [SCM_MST_SITE_ITEM]			I WITH(NOLOCK)	     
												JOIN [SCM_MST_DIVISION]			D WITH(NOLOCK) ON I.DIVISION_ID  = D.DIVISION_ID
												JOIN [SCM_MST_SITE]				S WITH(NOLOCK) ON I.DIVISION_ID  = S.DIVISION_ID AND I.SCM_SITE_ID  = S.SCM_SITE_ID	
												JOIN [SCM_MST_ITEM_SN]			T WITH(NOLOCK) ON I.DIVISION_ID  = T.DIVISION_ID AND I.ITEM_ID      = T.ITEM_ID  
												LEFT OUTER JOIN [SCM_MST_PROJECT] P WITH(NOLOCK) ON I.DIVISION_ID  = P.DIVISION_ID AND I.PROJECT_CODE = P.PROJECT_CODE
												WHERE 1=1
												AND CASE WHEN @v_division_id = 'ALL' THEN 'ALL' ELSE I.DIVISION_ID END IN (SELECT token FROM dbo.String_Split(@v_division_id  ,','))
												--AND CASE WHEN p_to_site = 'ALL' THEN 'ALL' ELSE I.SCM_SITE_ID END IN (SELECT token FROM dbo.String_Split(p_to_site  ,','))
												AND I.PROJECT_CODE LIKE '%' + @v_project_code + '%' 
												AND (      I.ITEM_ID   LIKE '%' + @v_item_id + '%' 
														OR T.ITEM_NAME LIKE '%' + @v_item_id + '%'
														OR T.NICK_NAME LIKE '%' + @v_item_id + '%')
									
																	)a
									  ),0);

				-- VALIDATION 체크
				-- 1:해당 MODEL 있음
				-- 0:해당 MODEL 없음
				--SET @v_cnt_item_id = 1;

				IF @v_cnt_item_id > 0
					SET @v_val_code = 1;
				ELSE 
					SET @v_val_code = 0;

				IF( @v_val_code = 1)
				BEGIN

					SET @v_description = '';
					SET @d_event_date = SYSDATETIME();
					DECLARE @v_tmp_fn_time_zone NVARCHAR(8);
					DECLARE @v_tmp_seq_confirm	NVARCHAR(20);
					SET @v_tmp_fn_time_zone = CONVERT(VARCHAR(8), [dbo].[FN_MULTY_TIME](@p_time_zone), 112);
					SET @v_tmp_seq_confirm = CONVERT(NVARCHAR, NEXT VALUE FOR SEQ1_SSP_ANL_SHIP_CONFIRM_ID);
					SET @v_new_confirm_id = 'C'+@v_tmp_fn_time_zone + RIGHT('000000' + @V_TMP_SEQ_CONFIRM,6)
					--//====================================================================================================================================
					SELECT @v_plan_start_yyyymmdd = ISNULL(MAX(PLAN_START_YYYYMMDD), CONVERT(VARCHAR(8), GETDATE(), 112))
							,@v_seq                 = ISNULL(MAX(PLAN_SEQ), '1')
					FROM   SSP_PLAN_VERSION_V with(nolock)
					WHERE  PLAN_TYPE    = 'SP'
					AND    DIVISION_ID  = @v_division_id 
					AND    CONFIRM_FLAG = 'Y'
					AND    PLAN_START_YYYYMMDD = (SELECT MAX(PLAN_START_YYYYMMDD)
										FROM SSP_PLAN_VERSION_V T with(nolock)
										WHERE T.DIVISION_ID = @v_division_id 
										AND   T.plan_type  = 'SP'
										AND   T.CONFIRM_FLAG = 'Y');			

					-- [E20250821-001308] begin 대체코드 -- TO_COMPANY_ID를 FROM_SITE에 따라 다르게 적용하는 예외를 적용
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
					-- [E20250821-001308] end 대체코드

					-- [E20250821-001308] 주석 구코드
					-- start E20260514-001358 TO_ shipto / soldto 없는 경우 출하 금지
					-- shipto, soldto validation
					IF(isnull(@v_to_site_soldto_code,'') = '' OR  isnull(@v_to_site_shipto_code,'') = '')
					BEGIN
						if(isnull(@v_to_site_soldto_code,'') = '')
							select 'X' as result_code, 'no soldto code' as reason_id, @v_division_id_or as division_id, @v_to_site_or as to_site
						else if(isnull(@v_to_site_shipto_code,'') = '')
							select 'X' as result_code, 'no shipto code' as reason_id, @v_division_id_or as division_id, @v_to_site_or as to_site
						SET @v_log_type = 'END';
						SET @v_log_message = '########## ' + isnull(@v_division_id_or,'')+' ' +isnull(@v_to_site_or,'')
						+ isnull(@v_to_site_shipto_code,'') + ' ' +isnull(@v_to_site_soldto_code,'') + ' ' +' Error END of procedure ##########';
						SET @d_event_date = SYSDATETIME();
						EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

					RETURN;
					-- end E20260514-001358 TO_ shipto / soldto 없는 경우 출하 금지
				END

					--SELECT @v_from_site_type = (CASE WHEN FS.SITE_TYPE = 'SALES' THEN 'A' WHEN FS.SITE_TYPE = 'PLANT' AND FS.OSP_YN = 'N' THEN 'B' 
					--								 WHEN FS.SITE_TYPE = 'PLANT' AND FS.OSP_YN = 'Y' THEN 'C'  END) 
					--	, @v_from_site_plant_id = FS.LOGISTIC_PLANT_ID 
					--	, @v_from_site_vendor_id = (CASE WHEN FS.SITE_TYPE = 'PLANT' AND FS.OSP_YN = 'Y' THEN FS.PLANT_ID  END)  
					--	, @v_from_site_company_id = FS.COMPANY_ID
					--FROM SCM_MST_SITE FS  WITH(NOLOCK)
					--WHERE  FS.DIVISION_ID = CASE WHEN @v_division_id = 'EE' THEN @v_origin_from_division_id ELSE @v_origin_from_division_id END
					--  AND FS.SCM_SITE_ID = @v_from_site 
					--  AND FS.VALID_YN    = 'Y' 
			
					--SELECT @v_from_site_soldto_code = FC.SOLDTO_CODE   
					--	, @v_from_site_shipto_code = FC.SHIPTO_CODE   
					--FROM SCM_MST_SITE_CUSTOMER FC  WITH(NOLOCK)
					--WHERE FC.DIVISION_ID = CASE WHEN @v_division_id = 'EE' THEN @v_origin_from_division_id ELSE @v_origin_from_division_id END
					--  AND FC.SCM_SITE_ID = @v_from_site
					--  AND FC.VALID_YN    = 'Y'
					--  AND FC.REP_YN      = 'Y'
			
					--SELECT @v_to_site_type = CASE WHEN TS.SITE_TYPE = 'SALES' THEN 'A' -- Sales Site' -- FROM_SITE_TYPE
					--			WHEN TS.SITE_TYPE = 'PLANT' AND TS.OSP_YN = 'N' THEN 'B' -- Factory Site
					--			WHEN TS.SITE_TYPE = 'PLANT' AND TS.OSP_YN = 'Y' THEN 'C' -- Packer
					--		END                                                                            
					--	, @v_to_site_plant_id = TS.LOGISTIC_PLANT_ID
					--	, @v_to_site_vendor_id = CASE WHEN TS.SITE_TYPE = 'PLANT' AND TS.OSP_YN = 'Y' THEN TS.PLANT_ID END
					--	, @v_to_site_company_id = TS.COMPANY_ID             
					--FROM SCM_MST_SITE TS  WITH(NOLOCK)
					--WHERE TS.DIVISION_ID = CASE WHEN @v_division_id = 'EE' THEN @v_origin_from_division_id ELSE @v_origin_to_division_id END
					--  AND TS.SCM_SITE_ID = @v_to_site
					--  AND TS.VALID_YN    = 'Y' 

					--SELECT @v_to_site_soldto_code = TC.SOLDTO_CODE
					--	, @v_to_site_shipto_code = TC.SHIPTO_CODE
					--FROM SCM_MST_SITE_CUSTOMER TC  WITH(NOLOCK)
					--WHERE TC.DIVISION_ID = CASE WHEN @v_division_id = 'EE' THEN @v_origin_from_division_id ELSE @v_origin_to_division_id END
					--  AND TC.SCM_SITE_ID = @v_to_site
					--  AND TC.VALID_YN    = 'Y' 
					--  AND TC.REP_YN      = 'Y'
			
					--mkt owner select
					IF @v_division_id = '40'
						BEGIN
							DECLARE @prj_cnt int = 0;

							SET @prj_cnt = (SELECT COUNT(PROJECT_CODE) CNT
											FROM SCM_MST_SITE_ITEM with(nolock)
											WHERE DIVISION_ID = @v_division_id
												AND SCM_SITE_ID = @v_to_site
												AND ITEM_ID = @v_item_id
												AND PROJECT_CODE = @v_project_code_40
										)
							;

							IF (@prj_cnt=0)
							BEGIN
								SELECT top 1 @v_project_code = project_code
								FROM SCM_MST_SITE_ITEM with(nolock)
								WHERE DIVISION_ID = @v_division_id
								  AND SCM_SITE_ID = @v_to_site
								  AND ITEM_ID = @v_item_id
								;	
							END

						END
					/*
					-- START [EXXXXXX-XXXXXXXX] 판가 확인하지 않음.
					/*
					판가 입력 정보 조회 
					52주 구간 전부에 입력이 안되어있으면 신규 생성 불가 
					현재 SSP는 내/외수를 구분하지 않기 때문에 DOM_EXP 타입을 'DOM'로 강제로 설정 후 처리하였음(한개로 처리하기 위해서)
					*/
					SELECT  @v_sales_price_check_cnt = COUNT(*)  FROM 
					(
						SELECT DISTINCT division_id, project_code, scm_site_id, plant_site_id, item_id,  measure, 'DOM' AS DOM_EXP, fcst_type,incoterms,  count(*)  AS CNT
						FROM SCM_MST_FUTURE_PRICE A WITH(NOLOCK)
						INNER JOIN SCM_SYS_CALENDAR_M B
						ON A.YYYYMMDD = B.BASIS_YYYYMMDD
						AND B.DAYOFWEEK = 'MON'
						LEFT JOIN (
									SELECT MIN(BASIS_START_DATE) BASIS_START_DATE,    MAX(BASIS_END_DATE) AS BASIS_END_DATE
										FROM [DBO].[SCM_SYS_CALENDAR_M] M WITH(NOLOCK) 
											WHERE M.BASIS_YYYYMMDD BETWEEN CONVERT(CHAR(8), DATEADD(DD, -7, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)  --당주 월요일부터
																	   AND CONVERT(CHAR(8), DATEADD(WW, 12, CONVERT(CHAR(8), DATEADD(DD, -7, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)),112)  -- 12주후 월요일까지			
									) M
						ON 1=1
						WHERE 1=1
						AND A.DIVISION_ID	= @v_division_id
						AND A.PROJECT_CODE	= CASE WHEN @v_division_id = '40' THEN @v_project_code_40 ELSE @v_project_code END
						AND A.SCM_SITE_ID   = @v_to_site
						--AND A.PLANT_SITE_ID = CASE WHEN @p_division_id = '81' THEN @p_from_site ELSE '' END
						AND A.ITEM_ID		= @v_item_id
						AND A.FCST_TYPE		= @v_fcst_type
						AND A.INCOTERMS		= @v_new_incoterms
						AND A.MEASURE		= 'KRW'				
						--AND A.DOM_EXP		= @p_dom_exp
						AND A.FCST_TYPE NOT IN (  SELECT SEGMENT2
													FROM SCM_ADM_LOOKUP_MASTER_DETAIL MST with(nolock)
													WHERE 1=1
													AND MST.LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE'
													AND MST.SEGMENT1     = 'FCST_TYPE'
													AND VALID_YN        = 'Y' 
													) 

						AND A.yyyymmdd BETWEEN m.BASIS_START_DATE AND m.BASIS_END_DATE
						--and a.yyyymmdd >= ''
						GROUP BY division_id, project_code, scm_site_id, plant_site_id, item_id,  measure, dom_exp,fcst_type,incoterms
						HAVING COUNT(*) = 13
					) XX
					;

					IF @v_sales_price_check_cnt > 1
						SET @v_sales_price_check_cnt = 1;

					-- 해당 LOOKUP 등록 정보는 판가입력 정보를 Check 하지 않음.
					SELECT @v_mkt_fcst_check_cnt = COUNT(*) 
					FROM SCM_ADM_LOOKUP_MASTER_DETAIL MST with(nolock)
					WHERE 1=1
					AND MST.LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE'
					AND MST.SEGMENT1    = 'FCST_TYPE'
					AND VALID_YN        = 'Y' 
					AND SEGMENT2		= @v_fcst_type
					;

					-- 법인간 거래이면 판가입력 정보를 Check 하지 않음.
					IF (@v_from_site_type = 'B' AND @v_to_site_type = 'B' ) OR (@v_from_site_type = 'B' AND @v_to_site_type = 'C' ) OR (@v_from_site_type = 'C' AND @v_to_site_type = 'C' ) OR (@v_from_site_type = 'C' AND @v_to_site_type = 'B' )
						SET @v_sales_price_check_cnt  =  1;

					print @v_sales_price_check_cnt;
					-- 판가 정보없고, 법인간 거래가 아니거나, LOOKUP에 등록된 FCST_TYPE이 아니면 RETURN
					IF @v_sales_price_check_cnt = 1
						SET @v_sales_price_check_cnt  =  1;
					ELSE
						IF @v_mkt_fcst_check_cnt = 1 
							BEGIN
								SET @v_sales_price_check_cnt  =  1;
							END 
						ELSE
							BEGIN
								SELECT  'F' AS result_code;
								SET @v_log_type = 'END';
								SET @v_log_message = '########## END of procedure ##########';
								--SET @v_description = 'Confrim_ID : ' + @v_new_confirm_id + ' / Time Zone : ' + @v_tmp_fn_time_zone + ' / Seq : ' + @v_tmp_seq_confirm;
								SET @d_event_date = SYSDATETIME();
						
								EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
								RETURN;
							END 
					-- END [EXXXXXX-XXXXXXXX] 판가 확인하지 않음.
					*/ 

					SET @v_shipment_date = REPLACE(SUBSTRING(@v_shipment_date,1,10),'-','')
					SET @v_new_etd_date = REPLACE(SUBSTRING(@v_shipment_date,1,10),'-','')
					--SET @p_eta = REPLACE(SUBSTRING(@p_eta,1,10),'-','')
					SET @v_eta = [dbo].[FN_GET_SSP_ETA_DATE](@v_division_id, @v_new_bod_id, @v_shipment_date) 
					SET @v_etd = [dbo].[FN_GET_SSP_ETD_DATE](@v_division_id, @v_new_bod_id, @v_shipment_date) 

					SET @v_last_update_date    = SYSDATETIME();

					IF @v_project_code = '' OR @v_project_code IS NULL
					BEGIN
						SET @v_project_code = '-';
					END		


					INSERT INTO SSP_ANL_SHIP_CONFIRM(
									CONFIRM_ID ,SHIPMENT_STATUS ,DIVISION_ID ,PLAN_START_YYYYMMDD ,PLAN_TYPE ,SEQ ,ITEM_ID ,FROM_SITE ,TO_SITE
										,YYYYMMDD ,PLANNED_QTY ,QTY ,BOD_ID ,ROUTE_ID ,BIZ_TYPE ,PROJECT_CODE ,FCST_TYPE ,FCST_ETD_DATE
										,FCST_ETA_DATE ,ETD_DATE ,ETA_DATE ,INCOTERMS ,TRANSPORT_MODE ,D_COUNTRY ,D_PORT_CODE ,A_COUNTRY
										,A_PORT_CODE ,CUSTOMER_LT ,TO_COUNTRY ,TO_CITY ,FROM_SITE_TYPE ,FROM_SITE_PLANT_ID ,FROM_SITE_VENDOR_ID
										,FROM_SITE_SOLDTO_CODE ,FROM_SITE_SHIPTO_CODE ,FROM_SITE_COMPANY_ID ,TO_SITE_TYPE ,TO_SITE_PLANT_ID
										,TO_SITE_VENDOR_ID ,TO_SITE_SOLDTO_CODE ,TO_SITE_SHIPTO_CODE ,TO_SITE_COMPANY_ID  ,CHANGE_TYPE
										,CREATED_BY ,CREATION_DATE ,LAST_UPDATED_BY ,LAST_UPDATE_DATE,REMARKS,REMARKS2,REMARKS3
										,ELECTRODE_YN ,ORIGIN_FROM_DIVISION_ID ,ORIGIN_TO_DIVISION_ID ,BEFORE_QTY ,CHECK_NEED_YN ,REQUESTOR	, ATTRIBUTE10
										/**** 20211018   SHINMYUNGSU   항목추가   ************/
										,ERP_ATTR1, ERP_ATTR2, ERP_ATTR3
										/*********************************************************/
						) VALUES
						(
									@v_new_confirm_id, 'C', @v_division_id, @v_plan_start_yyyymmdd, 'SP', @v_seq, @v_item_id, @v_from_site, @v_to_site
									,@v_shipment_date, 0, @v_shipment_qty, @v_new_bod_id, @v_new_route_id, @v_operation_group, CASE WHEN @v_division_id = '40' THEN @v_project_code_40 ELSE @v_project_code END, @v_fcst_type, @v_new_etd_date
									,@v_eta, @v_new_etd_date, @v_eta, @v_new_incoterms, @v_new_transport_mode, @v_new_d_contry, @v_new_d_port_code, @v_new_a_country
									,@v_new_a_port_code, @v_new_customer_lt, @v_new_to_country, @v_new_to_city, @v_from_site_type, @v_from_site_plant_id, @v_from_site_vendor_id
									,@v_from_site_soldto_code, @v_from_site_shipto_code, @v_from_site_company_id, @v_to_site_type, @v_to_site_plant_id
									,@v_to_site_vendor_id, @v_to_site_soldto_code, @v_to_site_shipto_code, @v_to_site_company_id, 'N'
									,@p_user_id, @v_last_update_date, @p_user_id, @v_last_update_date, @v_remarks, @v_remarks2, @v_remarks3
									,@v_electrode_yn, @v_origin_from_division_id, @v_origin_to_division_id, 0, 'Y', @p_user_id	, 'I'
									/**** 20211018   SHINMYUNGSU   항목추가   ************/
									,@v_erp_attr1, @v_erp_attr2, @v_erp_attr3
									/*********************************************************/
						);	

                    -- 230226 jilee DM Confirm 동기화 추가
                    EXEC PR_DM_SSP_CONFIRM_SYNC @v_division_id, @v_new_confirm_id;

					---- 결과코드, 결과 카운트 반환
					--SELECT  'S' AS result_code, @v_new_confirm_id as ConfrimID ;
			
					--SET @v_log_type = 'END';
					--SET @v_log_message = '########## END of procedure ##########';
					--SET @v_description = 'Confrim_ID : ' + @v_new_confirm_id + ' / Time Zone : ' + @v_tmp_fn_time_zone + ' / Seq : ' + @v_tmp_seq_confirm;
					--SET @d_event_date = SYSDATETIME();
					--EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
					

					 --IF @@TRANCOUNT > 0
						--  BEGIN
						--	COMMIT TRAN TX_SH;
						--  END;       

				
				END
				ELSE IF	( @v_val_code = 0)
					SELECT  'N' AS result_code;
		
			END

			-- 결과코드, 결과 카운트 반환
			SELECT  'S' AS result_code, @v_new_confirm_id as ConfrimID ;
			
			SET @v_log_type = 'END';
			SET @v_log_message = '########## END of procedure ##########';
			SET @v_description = 'Confrim_ID : ' + @v_new_confirm_id + ' / Time Zone : ' + @v_tmp_fn_time_zone + ' / Seq : ' + @v_tmp_seq_confirm;
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


		END TRY	
	 BEGIN CATCH 
		BEGIN
			if (xact_state() <> 0) ROLLBACK TRAN; --입력 데이타 롤백 처리
			 --IF @@TRANCOUNT > 0
				--BEGIN
				--  ROLLBACK TRAN TX_SH
				--END;
						
           	INSERT INTO scm_sys_log_batch (program_name,log_type,log_count,log_message,description,event_date,creation_date,created_by,last_update_date,last_updated_by)
			VALUES (ERROR_PROCEDURE(),'ERROR',NULL,ERROR_MESSAGE(),NULL,SYSDATETIME(),SYSDATETIME(),ERROR_PROCEDURE(),SYSDATETIME(),ERROR_PROCEDURE());

			--IF @@TRANCOUNT > 0
			--  COMMIT WORK;
					  

			-- error코드, errror 메시지 반환
			SELECT 'F' AS result_code;
		END;
	END CATCH;
END
