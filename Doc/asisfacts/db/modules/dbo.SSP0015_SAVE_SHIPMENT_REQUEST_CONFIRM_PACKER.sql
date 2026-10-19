/*
 * Program ID   : SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_PACKER
 * Description  : Shipment Request Confirm 저장
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2021/09/22   KIMYONGHO		최초작성
 * 2022/01/04   KIMYONGHO	    ITEM 코드 11자리까지 동일하면 유효한 BOD ITEM
 * 2024/10/01   KHJ             NERP_SSP
 */

CREATE PROCEDURE [dbo].[SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_PACKER]
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
	,@p_shipto_code			NVARCHAR(MAX)
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
	DECLARE @v_shipto_code		    NVARCHAR(MAX);

	
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

	DECLARE @IF_GROUP_NO				 [NVARCHAR](50)   = FORMAT(CURRENT_TIMESTAMP, 'yyyyMMddHHmmss');

	DECLARE @v_new_confirm_id				 NVARCHAR(max);
	DECLARE @v_infseqno						 nvarchar(20);	
	DECLARE @v_last_confirm_date			 nvarchar(8);	

	--//메일관련 변수////////////////////////////////
	DECLARE @v_grp_change_req			NVARCHAR(20);
	DECLARE @Mail_Flag					INT;
	DECLARE @Mail_CHK					INT;
	SET @Mail_Flag = 0;
	SET @Mail_CHK = 0;
	SET @v_grp_change_req = 'G'+ REPLACE(REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR(23), SYSDATETIME(), 21), '-', ''), ':', ''), '.', ''), ' ', '');
	--///////////////////////////////////////////////
	SET @Mail_Flag = 0;
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
	SET @v_shipto_code				= null;

	

	SET @v_create_date    = SYSDATETIME();

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_40';
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
		

		--IF OBJECT_ID('tempdb..#TblDynamic_SSP0015_40_STD') IS NOT NULL	
		--	DROP TABLE #TblDynamic_SSP0015_40_STD;

		---- SSP_ANL_SHIP_PLAN_40 의 데이터 생성 시점이 달라 최신 생성 날짜를 조회한다.
		--SELECT DISTINCT
		--		DIVISION_ID
		--		, FROM_SITE
		--		, PLAN_START_YYYYMMDD
		--	INTO #TblDynamic_SSP0015_40_STD     -- 기준 데이터 저장
		--	FROM(
		--		SELECT SP.DIVISION_ID
		--				, SP.FROM_SITE
		--				, SP.PLAN_START_YYYYMMDD
		--				, RANK() OVER(PARTITION BY SP.FROM_SITE ORDER BY SP.PLAN_START_YYYYMMDD DESC) AS RANK
		--			FROM SSP_ANL_SHIP_PLAN_40 SP WITH(NOLOCK)
		--			WHERE SP.DIVISION_ID    = '40'
		--			AND SP.PLAN_START_YYYYMMDD >= CONVERT(VARCHAR(8) ,GETDATE() -1,112)  -- 전일
		--			AND SP.PLAN_START_YYYYMMDD <= CONVERT(VARCHAR(8) ,GETDATE() ,112)    -- 당일
		--			AND SP.QTY > 0
		--		) A
		--	WHERE RANK = 1
		--;
		
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
				SET @v_shipto_code    = dbo.SCM_ARR_SPL_VAL( @p_shipto_code     , @v_delimiter, @mst_loop_cnt );

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

					JOIN ( SELECT DISTINCT 
							A.DIVISION_ID 
							, V.FROM_SITE
							, CASE WHEN ISNULL(B.PACKER_ITEM_ID_SUFFIX,'') = '' THEN A.ITEM_ID ELSE ISNULL(STUFF(A.ITEM_ID,12,1, B.PACKER_ITEM_ID_SUFFIX), A.ITEM_ID)  END  AS ITEM_ID 
							, A.BOD_ID 
						   FROM   SCP_MST_BOD_ITEM  A WITH(NOLOCK) 
						   INNER JOIN SCP_MST_BOD_N_V V WITH(NOLOCK) 
							 ON A.DIVISION_ID =  V.DIVISION_ID
							AND A.BOD_ID	  =  V.BOD_ID
						   INNER JOIN SCM_MST_SITE	B
							 ON B.DIVISION_ID = V.DIVISION_ID
							AND B.SCM_SITE_ID = V.FROM_SITE
						   WHERE  A.DIVISION_ID =   @v_division_id
							 AND  B.OSP_YN		= 'Y'
						     AND CASE WHEN ISNULL(B.PACKER_ITEM_ID_SUFFIX,'') = '' THEN A.ITEM_ID ELSE ISNULL(STUFF(A.ITEM_ID,12,1, B.PACKER_ITEM_ID_SUFFIX), A.ITEM_ID) END =  @v_item_id_temp 						     
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

				IF @v_qty != CEILING(@v_shipment_qty)
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
				--SET @v_new_eta_date = REPLACE(SUBSTRING(@v_new_eta_date,1,10),'-','')
				SET @v_shipment_date = REPLACE(SUBSTRING(@v_shipment_date,1,10),'-','')

				/* 2019.09.04 etd:shipdate, eta:etd+lt_day로 셋팅*/
	--			IF ISNULL(@v_shipment_date,'')!='' and LEN(@v_shipment_date)=8 and ISNULL(@v_new_customer_lt,'')!='' and LEN(@v_new_customer_lt)>0
	--				BEGIN
	--					SET @v_new_etd_date = @v_shipment_date
	--					;
	--					SET @v_new_eta_date = convert(VARCHAR(8), dateadd(dd, convert(int, @v_new_customer_lt), convert(datetime,@v_new_etd_date)),112)
	--					;
	--				END

				/* 2019.10.29 출발일 기준 항차를 고려한 ETA_DATE 계산*/
				SET @v_new_eta_date = [dbo].[FN_GET_SSP_ETA_DATE](@v_division_id, @v_new_bod_id_temp, @v_shipment_date) 

				IF @v_edit_main = 'Y'
					BEGIN
						SET @v_check_need_yn = 'Y'
					END	

				/* 2020.06.23 ETD_DATE, FCST_ETD_DATE 를 YYYYMMDD 와 같은 날짜로 변경 되도록 수정 */
				UPDATE SSP_ANL_SHIP_CONFIRM
					SET YYYYMMDD = @v_shipment_date
						,QTY = CEILING(@v_shipment_qty)
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
						,TO_SITE_SHIPTO_CODE = @v_shipto_code
						,CHECK_NEED_YN = @v_check_need_yn
						,LAST_UPDATED_BY = @p_user_id
						,LAST_UPDATE_DATE = @v_create_date
				WHERE CONFIRM_ID = @v_confirm_id;

			END;
			/*2020-07-24 KIMYONGHO 신규생성 기능 추가*/
			IF @v_active_flag = 'I'
			BEGIN

				SELECT @v_infseqno =  CONVERT(VARCHAR,GETDATE(),12) + dbo.FN_ZERO_LPAD(CONVERT(VARCHAR,NEXT VALUE FOR dbo.SEQ1_XIF_SCS),10);
				--FROM XIF_ERP_PACK_SHIP_PLAN_S_SN
				--WHERE IFSEQNO LIKE CONVERT(CHAR(8),GETDATE(),112) +'%' ;

				-- 확정구간 마지막 일자( 현재일 기준 + 9 = PLANS_START_YYYYMMDD + 10)
				SET @v_last_confirm_date =  CONVERT ( VARCHAR(8), GETDATE() + 9 , 112) ;
				SET @v_description = '';
				SET @d_event_date = SYSDATETIME();--[dbo].[FN_MULTY_TIME](@p_time_zone);
				EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
				
				-- NEW CONFIRM 생성 CHECK 확인==========================================================================================
				DECLARE @v_tmp_fn_time_zone NVARCHAR(8);
				DECLARE @v_tmp_seq_confirm	NVARCHAR(20);
				SET @v_tmp_fn_time_zone = CONVERT(VARCHAR(8), [dbo].[FN_MULTY_TIME](NULL), 112);
				--SET @v_tmp_seq_confirm = CONVERT(NVARCHAR, NEXT VALUE FOR SEQ1_SSP_ANL_SHIP_CONFIRM_ID);
				--SET @v_new_confirm_id = 'R'+@v_tmp_fn_time_zone + RIGHT('000000' + @V_TMP_SEQ_CONFIRM,6)

				SET @v_new_confirm_id = 'R'+ CONVERT(VARCHAR(8), GETDATE(), 112) + RIGHT('000000' + CONVERT(NVARCHAR, NEXT VALUE FOR SEQ1_SSP_ANL_SHIP_PACKER_REQ_ID),6)
				--//====================================================================================================================================

				SELECT  @v_plan_start_yyyymmdd  = MAX(PLAN_START_YYYYMMDD)
					 , @v_seq                  = MAX(PLAN_SEQ)
				  FROM [dbo].[SSP_PLAN_VERSION_V]
				 WHERE PLAN_TYPE    = 'SP'
				   AND DIVISION_ID  = @V_division_id 
				   AND CONFIRM_FLAG = 'Y'
				   AND PLAN_START_YYYYMMDD = (SELECT MAX(PLAN_START_YYYYMMDD)
									FROM [dbo].[SSP_PLAN_VERSION_V] T
									WHERE T.DIVISION_ID = @V_division_id 
									AND   T.plan_type  = 'SP'
									AND   T.CONFIRM_FLAG = 'Y');



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
					, A.FROM_SITE_SOLDTO_CODE , A.FROM_SITE_SHIPTO_CODE , A.FROM_SITE_COMPANY_ID , A.TO_SITE_TYPE , A.TO_SITE_PLANT_ID
					, A.TO_SITE_VENDOR_ID , A.TO_SITE_SOLDTO_CODE , A.TO_SITE_SHIPTO_CODE , A.TO_SITE_COMPANY_ID  , 'C'
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


				INSERT INTO XIF_ERP_PACK_SHIP_PLAN_S_SN
				( 
				  IF_SEQ
				,IF_TYPE
				,IF_ID
				,IF_INS_DATE
				,IF_FLAG
				,IF_SND_DATE
				,IFSEQNO
				,PACKER_CODE
				,DIVISION_ID
				--,PLAN_VERSION
				,PACK_MODEL_CODE
				,NICK_NAME
				--,TARGET_ORDER
				,SSP_CNFM
				,SOLD_TO
				--,SOLD_TO_NAME
				,SALES_SITE
				,SHIP_TO
				--,SHIP_TO_NAME
				,TRANSPORT_MODE
				,INCOTERMS
				,SHIP_PLAN_DATE
				,SHIP_PLAN_QTY
				,COMMENT
				,ORDER_TYPE_DETAIL
				--  20211125
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
				--
				)
				SELECT
					'OERP' + CONVERT(VARCHAR,GETDATE(),12) + dbo.FN_ZERO_LPAD(CONVERT(VARCHAR,NEXT VALUE FOR dbo.SEQ1_XIF_SCS),10)   AS IF_SEQ
					,'I'
					,'OSCM_OERP_PACK_SHIP_PLAN'
					,getdate()
					,'N'
					,NULL
					,@v_infseqno
					,ISNULL(X1.NEW_VALUE1, A.FROM_SITE)				AS FROM_SITE
					,A.DIVISION_ID
					 
					,ITEM_ID
					,A.NICK_NAME
					,A.CONFIRM_ID
					,ISNULL(X3.NEW_VALUE1, A.TO_SITE_SOLDTO_CODE)	AS TO_SITE_SOLDTO_CODE
					,ISNULL(X2.NEW_VALUE1, A.TO_SITE)				AS TO_SITE
					,ISNULL(X4.NEW_VALUE1, A.TO_SITE_SHIPTO_CODE)	AS TO_SITE_SHIPTO_CODE
					
					,A.TRANSPORT_MODE
					,A.INCOTERMS
					,A.YYYYMMDD
					,A.QTY
					,A.REMARK
					,A.ORDER_TYPE_DETAIL 	
					,NULL   --ATTRIBUTE1
					,NULL	  --ATTRIBUTE2
					, ATTR_03    --Model PIC   
					, ATTR_04    --MTK_OWNER       
					,NULL	  --ATTRIBUTE5
					,NULL	  --ATTRIBUTE6
					,NULL	  --ATTRIBUTE7
					,NULL	  --ATTRIBUTE8
					,NULL	  --ATTRIBUTE9
					,NULL	  --ATTRIBUTE10
				FROM
				(
					SELECT 
						   X.FROM_SITE
						  ,X.DIVISION_ID
					 
						  ,ITEM_ID
						  ,[dbo].[FN_GET_ITEM_NICKNAME]( X.DIVISION_ID, X.ITEM_ID)  AS NICK_NAME
						  ,X.CONFIRM_ID
						  ,X.TO_SITE_SOLDTO_CODE

						  ,X.TO_SITE
						  ,X.TO_SITE_SHIPTO_CODE
					
						  ,X.TRANSPORT_MODE
						  ,X.INCOTERMS
						  ,X.YYYYMMDD
						  ,X.QTY
						  ,X.REMARK
						  ,X.ORDER_TYPE_DETAIL 
						 , ATTR_03    --Model PIC   
						 , ATTR_04    --MTK_OWNER 
					FROM (

							SELECT   -- NEW
									 A.CONFIRM_ID
									,'B'                AS VERSION_TYPE   -- B:NEW/A:OLD 
									--,ISNULL(L.ATTRIBUTE2, B.ATTRIBUTE2)    AS SALES_COMPANY_ID
									,A.DIVISION_ID							
									,A.ITEM_ID
									,A.FROM_SITE
									,A.TO_SITE
									,A.YYYYMMDD      AS YYYYMMDD
									,A.YYYYMMDD      AS YYYYMMDD_LAST
									,ISNULL(A.QTY,0) AS QTY
									,A.BOD_ID        AS BOD_ID 
									,A.TRANSPORT_MODE
									,A.INCOTERMS
									,A.ROUTE_ID      AS ROUTE_ID  
									,'P'             AS OPERATION_GROUP
									,A.BIZ_TYPE
									,A.PROJECT_CODE

									--,D.FCST_TYPE	20211125
									,ISNULL(LK.SEGMENT2, A.FCST_TYPE) AS ORDER_TYPE_DETAIL
									------
							
									,A.TO_SITE_SOLDTO_CODE
									,A.TO_SITE_SHIPTO_CODE
								
									-- ERP I/F 추가(BUILDING, REMARK, CUSTOMER_REQ, CHANGE_CODE, CHANGE_CODE_NAME, REQUESTOR ) 
									,A.REMARKS   AS BUILDING
									,A.REMARKS2  AS REMARK
									,A.REMARKS3  AS CUSTOMER_REQ
									,NULL		 AS CHANGE_CODE
								
									/*----------------------------------------------------------------------------------------
										2020.06.30 : KBK
										I/F 추가요청으로 인하여 컬럼 추가 전극에서만 사용. DDL 표준을 맞추기 위하여 추가함 
									------------------------------------------------------------------------------------------*/
							
									-- 20211125 
									, U2.UserName + '(' + MU.USER_ID + ')'					AS ATTR_03    --Model PIC   
									, DBO.FN_GET_SSP_MKT_OWNER_NAME (SI.OWNER, '', 'KO')	AS ATTR_04    --MTK_OWNER       
									--

							FROM  SSP_ANL_SHIP_CONFIRM A    WITH(NOLOCK) 
					
								-- 20211125 
								 LEFT OUTER JOIN SCM_MST_SITE_ITEM AS SI WITH(NOLOCK)
								 ON A.DIVISION_ID					= SI.DIVISION_ID
								 AND A.TO_SITE						= SI.SCM_SITE_ID
								 AND A.ITEM_ID						= SI.ITEM_ID
								 AND A.PROJECT_CODE					= SI.PROJECT_CODE

								 LEFT OUTER JOIN SSP_MST_MODEL_USER AS MU WITH(NOLOCK)
								 ON A.DIVISION_ID = MU.DIVISION_ID
								 AND A.FROM_SITE = MU.FROM_SITE
								 AND A.ITEM_ID = MU.ITEM_ID
								 AND MU.VALID_YN = 'Y'

								 LEFT OUTER JOIN TB_FX_User as U2 with(nolock) 
								 ON mu.user_id = u2.UserID 
								 AND U2.UseYN = 'Y'

								 LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL AS LK WITH(NOLOCK)
								 ON LK.LOOKUP_TYPE = 'SALES_TYPE_CODE'
								 AND LK.VALID_YN	= 'Y'
								 AND A.FCST_TYPE	= LK.SEGMENT1
								--
							WHERE 1=1
							AND   A.CONFIRM_ID = @v_new_confirm_id  
							AND   ISNULL(A.QTY,0) <> 0  -- 신규생성경우 0은 제외 
					) X
					-- 2020-08-24 11:19:51
					-- [요청] 사급 Cell 출하 관련 Packer Master 생성 및 ERP Data 수정 요청
					-- 2020-08-24  kimbl1
					LEFT OUTER JOIN SCM_MST_SITE FS  WITH(NOLOCK)
								ON  FS.DIVISION_ID = X.DIVISION_ID 
								AND FS.SCM_SITE_ID = X.FROM_SITE 
								AND FS.VALID_YN    = 'Y' 
					LEFT OUTER JOIN SCM_MST_SITE TS  WITH(NOLOCK)
								ON  TS.DIVISION_ID = X.DIVISION_ID 
								AND TS.SCM_SITE_ID = X.TO_SITE 
								AND TS.VALID_YN    = 'Y' 
					WHERE 1 = 1
				) A
				LEFT OUTER JOIN NERP_CONV_MASTER X1 WITH(NOLOCK) ON X1.CODETYPE = 'SCP_SITE_ID'	AND A.FROM_SITE = X1.OLD_VALUE1
				LEFT OUTER JOIN NERP_CONV_MASTER X2 WITH(NOLOCK) ON X2.CODETYPE = 'END_CUSTOMER_ID' AND A.TO_SITE = X2.OLD_VALUE1
				LEFT OUTER JOIN NERP_CONV_MASTER X3 WITH(NOLOCK) ON X3.CODETYPE = 'END_CUSTOMER_ID' AND A.TO_SITE_SOLDTO_CODE = X3.OLD_VALUE1
				LEFT OUTER JOIN NERP_CONV_MASTER X4 WITH(NOLOCK) ON X4.CODETYPE = 'END_CUSTOMER_ID'	AND A.TO_SITE_SHIPTO_CODE = X4.OLD_VALUE1

				;


				INSERT INTO XIF_SCS_PACK_SHIP_PLAN_S_SN (
					   IF_SEQ           
					 , IF_TYPE          
					 , IF_ID            
					 , IF_INS_DATE      
					 , IF_FLAG          
					 , PACKER_CODE      
					 , DIVISION_ID      
					 , PLAN_VERSION   
					 , PACK_MODEL_CODE  
					 , NICK_NAME 
					 , TARGET_ORDER
					 , SSP_CNFM
					 , SALES_SITE
					 , SHIP_TO
					 , SHIP_TO_NAME
					 , TRANSPORT_MODE
					 , INCOTERMS
					 , SHIP_PLAN_DATE 
					 , SHIP_PLAN_QTY 
					 , COMMENT
					 , ATTR_01           
					 , ATTR_02           
					 , ATTR_03           
					 , ATTR_04           
					 , ATTR_05           
					 , ATTR_06           
					 , ATTR_07           
					 , ATTR_08           
					 , ATTR_09           
					 , ATTR_10 
					 , ORDER_TYPE_DETAIL
					 )
				SELECT
					 'OSCM' + CONVERT(VARCHAR,GETDATE(),12) + DBO.FN_ZERO_LPAD(CONVERT(VARCHAR,NEXT VALUE FOR DBO.SEQ1_XIF_SCS),10)  AS IF_SEQ
					, N'I'         AS IF_TYPE          
					, N'OSCM_OSCS_SCS_PACK_SHIP_PLAN'  AS IF_ID            
					, GETDATE()    AS IF_INS_DATE      
					, 'N'          AS IF_FLAG          
					, ISNULL(X1.NEW_VALUE1, A.PACKER_CODE)			AS PACKER_CODE     
					, A.DIVISION_ID      
					, A.PLAN_VERSION   
					, A.PACK_MODEL_CODE  
					, A.NICK_NAME 
					, N'O'          AS TARGET_ORDER
					, A.SSP_CNFM
					, A.SALES_SITE
					, A.SHIP_TO
					, A.SHIP_TO_NAME
					, A.TRANSPORT_MODE
					, A.INCOTERMS
					, A.SHIP_PLAN_DATE 
					, A.SHIP_PLAN_QTY 
					/* 20211102  SMS  수정  ****************************************************/
--					 , NULL								AS COMMENT
					, A.COMMENT
					/****************************************************************************************************/					        
					, A.ATTR_01           
					, NULL								AS ATTR_02           
					/* 20211102  SMS  수정  ****************************************************/
--					 , NULL								AS ATTR_03    
					, A.ATTR_03      --Model PIC   				
--					 , NULL								AS ATTR_04           
					, A.ATTR_04		--MTK_OWNER       
				/****************************************************************************************************/					        
					, NULL								AS ATTR_05           
					, NULL								AS ATTR_06           
					, NULL								AS ATTR_07           
					, NULL								AS ATTR_08           
					, NULL								AS ATTR_09           
					, A.ATTR_10
					, A.FCST_TYPE       --ORDER_TYPE_DETAIL
				FROM
				(
					SELECT 
							  A.FROM_SITE  AS PACKER_CODE      
							, A.DIVISION_ID AS DIVISION_ID      
							, CONVERT(VARCHAR(8), CONVERT(DATETIME, getdate()), 112)    AS PLAN_VERSION   
							, A.ITEM_ID    AS PACK_MODEL_CODE  
							, [dbo].[FN_GET_ITEM_NICKNAME](A.DIVISION_ID, A.ITEM_ID)  AS NICK_NAME 
							, A.CONFIRM_ID			 AS SSP_CNFM
							, A.TO_SITE     AS SALES_SITE
							, A.TO_SITE_SHIPTO_CODE AS SHIP_TO
							, [dbo].[FN_GET_SITE_CUSTOMER_INFO](A.DIVISION_ID, A.TO_SITE,'SHIPTO_DESCRIPTION')	AS SHIP_TO_NAME
							, A.TRANSPORT_MODE	AS TRANSPORT_MODE
							, A.INCOTERMS		AS	INCOTERMS
							, A.YYYYMMDD    AS SHIP_PLAN_DATE 
							, A.QTY         AS SHIP_PLAN_QTY 
							/* 20211102  SMS  수정  ****************************************************/
	--					 , NULL								AS COMMENT
							, A.REMARKS						AS COMMENT
							/****************************************************************************************************/					        
							, A.DIVISION_ID + '_' + @v_plan_start_yyyymmdd + '_' + @IF_GROUP_NO	AS ATTR_01           
							/* 20211102  SMS  수정  ****************************************************/
	--					 , NULL								AS ATTR_03    
							, U2.UserName + '(' + MU.USER_ID + ')'					AS ATTR_03      --Model PIC   				
	--					 , NULL								AS ATTR_04           
							, DBO.FN_GET_SSP_MKT_OWNER_NAME (SI.OWNER, '', 'KO')	AS ATTR_04		--MTK_OWNER       
						/****************************************************************************************************/	
							, A.CONFIRM_ID						AS ATTR_10
						/* 20211102  SMS  수정 *******************************************************************************/
	--					 , '-'				AS ORDER_TYPE_DETAIL
							, ISNULL(LK.SEGMENT2, A.FCST_TYPE) AS FCST_TYPE       --ORDER_TYPE_DETAIL
						/****************************************************************************************************/
					FROM SSP_ANL_SHIP_CONFIRM A WITH(NOLOCK)
					/* 20211102  SMS  추가 *****************/
							LEFT OUTER JOIN (SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
 							FROM(																						
 								SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID									
 									,ROW_NUMBER() over(partition by DIVISION_ID, SCM_SITE_ID, ITEM_ID order by PROJECT_CODE) num	
 							FROM scm_mst_site_item																				
 							) a WHERE num = 1) g on g.DIVISION_ID =  (CASE WHEN a.DIVISION_ID = 'EE' THEN a.ORIGIN_TO_DIVISION_ID ELSE a.DIVISION_ID END) and g.SCM_SITE_ID = a.TO_SITE and g.ITEM_ID = a.ITEM_ID	
							LEFT OUTER JOIN SCM_MST_SITE_ITEM AS SI WITH(NOLOCK)
						ON A.DIVISION_ID					= SI.DIVISION_ID
						AND A.TO_SITE						= SI.SCM_SITE_ID
						AND A.ITEM_ID						= SI.ITEM_ID
						AND G.PROJECT_CODE					= SI.PROJECT_CODE
							LEFT OUTER JOIN SSP_MST_MODEL_USER AS MU WITH(NOLOCK)
						ON A.DIVISION_ID = MU.DIVISION_ID
						AND A.FROM_SITE = MU.FROM_SITE
						AND A.ITEM_ID = MU.ITEM_ID
						AND MU.VALID_YN = 'Y'
							LEFT OUTER JOIN TB_FX_User as U2 with(nolock) 
						ON mu.user_id = u2.UserID 
	   					AND U2.UseYN = 'Y'
							LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL AS LK WITH(NOLOCK)
						ON LK.LOOKUP_TYPE = 'SALES_TYPE_CODE'
						AND LK.VALID_YN	= 'Y'
						AND A.FCST_TYPE	= LK.SEGMENT1
					/****************************************************************************************************/
					WHERE  1 = 1
					AND   A.CONFIRM_ID = @v_new_confirm_id  
					AND   ISNULL(A.QTY,0) <> 0  -- 신규생성경우 0은 제외 
			) A
			LEFT OUTER JOIN NERP_CONV_MASTER X1 WITH(NOLOCK) ON X1.CODETYPE = 'SCP_SITE_ID'	AND A.PACKER_CODE = X1.OLD_VALUE1
			
				-- MKT FCST - SSP Sync 신규 생성 건 대상
				--EXEC PR_DM_SSP_CONFIRM_SYNC @p_division_id, @v_new_confirm_id;

				--SET @v_confirm_id =  @v_new_confirm_id;
			END


		
			IF @v_edit_main = 'Y'
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
							, @v_change_req_no = CHANGE_REQ_NO
					FROM SSP_ANL_SHIP_CONFIRM_CHG_REQ_de a WITH(NOLOCK)
					WHERE A.CONFIRM_ID = @v_confirm_id
					  AND A.VALID_YN = 'Y'
					ORDER BY LAST_UPDATE_DATE desc;

				



		
				END
				IF len(@v_change_req_no) > 0
				BEGIN
					--이력저장
					EXEC [dbo].[PR_SSP_ANL_SHIP_CONFIRM_HIST] @v_change_req_no,@p_user_id,''
					;

					


					SELECT @Mail_CHK = COUNT(*) FROM SSP_MST_SEND_MAIL_REQ WITH(NOLOCK) WHERE CHANGE_REQ_NO = @v_change_req_no;
					
					IF @Mail_CHK = 0
					BEGIN
						--메일전송
						INSERT INTO SSP_MST_SEND_MAIL_REQ (CHANGE_REQ_NO, TRANSFER_FLAG, GRP_CHANGE_REQ)
						VALUES (@v_change_req_no, 'N', @v_grp_change_req);

						SET @Mail_Flag = 1;
					END;
					
				END
				
		END;
		
		--IF @Mail_Flag = 1
		--BEGIN
		--	EXEC [dbo].[PR_SSP_MAIL_SEND_ADJUST_MST] @v_grp_change_req
		--	;

		--END;

		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
					
		-- 결과코드, 결과 카운트 반환
		SELECT  'S' AS result_code,  @max_loop_cnt AS result_cnt, isnull(@v_change_req_no,'') AS change_req_no  ;

	

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
