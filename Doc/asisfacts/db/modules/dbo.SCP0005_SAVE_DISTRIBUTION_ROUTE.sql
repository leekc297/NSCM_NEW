/*
 * Program ID   : SCP0005_SAVE_DISTRIBUTION_ROUTE
 * Description  : Distribution Route 등록, 수정, 삭제
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/03/08   pjs   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/04/05   PJS   소문자 입력시 대문자로 변환하여 저장
 * 2019/02/12   YHW   [CSR ID:3907873] SSP Distribution route/BOD상 'L/T TYPE'컬럼 추가요청
 *
 */
CREATE PROCEDURE [dbo].[SCP0005_SAVE_DISTRIBUTION_ROUTE]
	 @p_active_flag				   NVARCHAR(MAX)
	,@p_route_id                   NVARCHAR(MAX)
	,@p_from_country               NVARCHAR(MAX)
	,@p_from_city                  NVARCHAR(MAX)
	,@p_from_city_name             NVARCHAR(MAX)
	,@p_transport_mode             NVARCHAR(MAX)
	,@p_priority                   NVARCHAR(MAX)
	,@p_days_mon                   NVARCHAR(MAX)
	,@p_days_tue                   NVARCHAR(MAX)
	,@p_days_wed                   NVARCHAR(MAX)
	,@p_days_thu                   NVARCHAR(MAX)
	,@p_days_fri                   NVARCHAR(MAX)
	,@p_days_sat                   NVARCHAR(MAX)
	,@p_days_sun                   NVARCHAR(MAX)
	,@p_d_country                  NVARCHAR(MAX)
	,@p_d_port_code                NVARCHAR(MAX)
	,@p_d_port_name                NVARCHAR(MAX)
	,@p_a_country                  NVARCHAR(MAX)
	,@p_a_port_code                NVARCHAR(MAX)
	,@p_a_port_name                NVARCHAR(MAX)
	,@p_shipping_company           NVARCHAR(MAX)
	,@p_to_country                 NVARCHAR(MAX)
	,@p_to_city                    NVARCHAR(MAX)
	,@p_to_city_name               NVARCHAR(MAX)
	,@p_ship_doc_preparation_date  NVARCHAR(MAX)
	,@p_lt_departure_inland        NVARCHAR(MAX)
	,@p_lt_wait_shipping           NVARCHAR(MAX)
	,@p_lt_voyage				   NVARCHAR(MAX)
	,@p_lt_lay_off_clearance       NVARCHAR(MAX)
	,@p_lt_arrival_inland          NVARCHAR(MAX)
	,@p_user_id                    NVARCHAR(MAX)
	,@p_valid_yn                   NVARCHAR(MAX)
	,@p_lt_type					   NVARCHAR(MAX)

	,@p_OneSegmentCost              NVARCHAR(MAX)--
	,@p_TwoSegmentCost              NVARCHAR(MAX)--
	,@p_ThreeSegmentCost            NVARCHAR(MAX)--

	,@debug_mode            	   NVARCHAR(1) ='F'
AS

BEGIN

	SET NOCOUNT ON;


	--SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	--DECLARE @DEBUG_MODE NVARCHAR(20) ='FALSE';
	--DECLARE @DEBUG_MODE NVARCHAR(20) ='TRUE';

	DECLARE @recv_active_flag		NVARCHAR(MAX);
	SET @recv_active_flag = NULL;		
	SET @recv_active_flag = @p_active_flag;

	DECLARE @v_active_flag		  		  NVARCHAR(MAX);
	DECLARE @v_route_id                   NVARCHAR(MAX);
	DECLARE @v_from_country               NVARCHAR(MAX);
	DECLARE @v_from_city                  NVARCHAR(MAX);
	DECLARE @v_from_city_name             NVARCHAR(MAX);
	DECLARE @v_transport_mode             NVARCHAR(MAX);
	DECLARE @v_priority                   NVARCHAR(MAX);
	DECLARE @v_days_mon                   NVARCHAR(MAX);
	DECLARE @v_days_tue                   NVARCHAR(MAX);
	DECLARE @v_days_wed                   NVARCHAR(MAX);
	DECLARE @v_days_thu                   NVARCHAR(MAX);
	DECLARE @v_days_fri                   NVARCHAR(MAX);
	DECLARE @v_days_sat                   NVARCHAR(MAX);
	DECLARE @v_days_sun                   NVARCHAR(MAX);
	DECLARE @v_d_country                  NVARCHAR(MAX);
	DECLARE @v_d_port_code                NVARCHAR(MAX);
	DECLARE @v_d_port_name                NVARCHAR(MAX);
	DECLARE @v_a_country                  NVARCHAR(MAX);
	DECLARE @v_a_port_code                NVARCHAR(MAX);
	DECLARE @v_a_port_name                NVARCHAR(MAX);
	DECLARE @v_shipping_company           NVARCHAR(MAX);
	DECLARE @v_to_country                 NVARCHAR(MAX);
	DECLARE @v_to_city                    NVARCHAR(MAX);
	DECLARE @v_to_city_name               NVARCHAR(MAX);
	DECLARE @v_ship_doc_preparation_date  NVARCHAR(MAX);
	DECLARE @v_lt_departure_inland        NVARCHAR(MAX);
	DECLARE @v_lt_wait_shipping           NVARCHAR(MAX);
	DECLARE @v_lt_voyage                  NVARCHAR(MAX);
	DECLARE @v_lt_lay_off_clearance       NVARCHAR(MAX);
	DECLARE @v_lt_arrival_inland          NVARCHAR(MAX);
	DECLARE @v_user_id                    NVARCHAR(MAX);
	DECLARE @v_valid_yn                   NVARCHAR(MAX);
	DECLARE @v_lt_type                    NVARCHAR(MAX);
	DECLARE @v_creation_date              datetime;

	DECLARE @v_OneSegmentCost             NVARCHAR(MAX); ---
	DECLARE @v_TwoSegmentCost             NVARCHAR(MAX);---
	DECLARE @v_ThreeSegmentCost           NVARCHAR(MAX);---

	SET @v_active_flag				  = NULL;
	SET @v_route_id                   = NULL;
	SET @v_from_country               = NULL;
	SET @v_from_city                  = NULL;
	SET @v_from_city_name             = NULL;
	SET @v_transport_mode             = NULL;
	SET @v_priority                   = NULL;
	SET @v_days_mon                   = NULL;
	SET @v_days_tue                   = NULL;
	SET @v_days_wed                   = NULL;
	SET @v_days_thu                   = NULL;
	SET @v_days_fri                   = NULL;
	SET @v_days_sat                   = NULL;
	SET @v_days_sun                   = NULL;
	SET @v_d_country                  = NULL;
	SET @v_d_port_code                = NULL;
	SET @v_d_port_name                = NULL;
	SET @v_a_country                  = NULL;
	SET @v_a_port_code                = NULL;
	SET @v_a_port_name                = NULL;
	SET @v_shipping_company           = NULL;
	SET @v_to_country                 = NULL;
	SET @v_to_city                    = NULL;
	SET @v_to_city_name               = NULL;
	SET @v_ship_doc_preparation_date  = NULL;
	SET @v_lt_departure_inland        = NULL;
	SET @v_lt_wait_shipping           = NULL;
	SET @v_lt_voyage                  = NULL;
	SET @v_lt_lay_off_clearance       = NULL;
	SET @v_lt_arrival_inland          = NULL;
	SET @v_user_id                    = NULL;
	SET @v_valid_yn					  = NULL;
	SET @v_lt_type					  = NULL;
	SET @v_creation_date         = SYSDATETIME();

	SET @v_OneSegmentCost             = NULL;  ---
	SET @v_TwoSegmentCost             = NULL;---
	SET @v_ThreeSegmentCost           = NULL;---
	 
	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^' 
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0005_SAVE_DISTRIBUTION_ROUTE';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;


	DECLARE @v_data_dup_cnt  INT=0;
	
	-- 예외처리 변수 설정
	DECLARE @v_err_code  INTEGER;
	DECLARE @v_err_message  NVARCHAR(4000)='';
	BEGIN TRAN;

	BEGIN TRY

		--PRINT '1';

			-- 시작 LOG
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		--PRINT '2';
		-- 프로시저 LOOP 길이를 판단
		SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_active_flag, @v_delimiter);    

		
		
		WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt
		BEGIN    
				
			-- @mst_loop_cnt 1증가
			SET @mst_loop_cnt = @mst_loop_cnt + 1;			

			-- 각 컬럼들에 대한 스플릿처리로직 스타트
			BEGIN

				SET @v_active_flag				  = dbo.SCM_ARR_SPL_VAL( @p_active_flag				  , @v_delimiter, @mst_loop_cnt );
				SET @v_route_id                   = dbo.SCM_ARR_SPL_VAL( @p_route_id                  , @v_delimiter, @mst_loop_cnt );
				SET @v_from_country               = dbo.SCM_ARR_SPL_VAL( @p_from_country              , @v_delimiter, @mst_loop_cnt );
				SET @v_from_city                  = dbo.SCM_ARR_SPL_VAL( @p_from_city                 , @v_delimiter, @mst_loop_cnt );
				SET @v_from_city_name             = dbo.SCM_ARR_SPL_VAL( @p_from_city_name            , @v_delimiter, @mst_loop_cnt );
				SET @v_transport_mode             = dbo.SCM_ARR_SPL_VAL( @p_transport_mode            , @v_delimiter, @mst_loop_cnt );
				SET @v_priority                   = dbo.SCM_ARR_SPL_VAL( @p_priority                  , @v_delimiter, @mst_loop_cnt );
				SET @v_days_mon                   = dbo.SCM_ARR_SPL_VAL( @p_days_mon                  , @v_delimiter, @mst_loop_cnt );
				SET @v_days_tue                   = dbo.SCM_ARR_SPL_VAL( @p_days_tue                  , @v_delimiter, @mst_loop_cnt );
				SET @v_days_wed                   = dbo.SCM_ARR_SPL_VAL( @p_days_wed                  , @v_delimiter, @mst_loop_cnt );
				SET @v_days_thu                   = dbo.SCM_ARR_SPL_VAL( @p_days_thu                  , @v_delimiter, @mst_loop_cnt );
				SET @v_days_fri                   = dbo.SCM_ARR_SPL_VAL( @p_days_fri                  , @v_delimiter, @mst_loop_cnt );
				SET @v_days_sat                   = dbo.SCM_ARR_SPL_VAL( @p_days_sat                  , @v_delimiter, @mst_loop_cnt );
				SET @v_days_sun                   = dbo.SCM_ARR_SPL_VAL( @p_days_sun                  , @v_delimiter, @mst_loop_cnt );
				SET @v_d_country                  = dbo.SCM_ARR_SPL_VAL( @p_d_country                 , @v_delimiter, @mst_loop_cnt );
				SET @v_d_port_code                = dbo.SCM_ARR_SPL_VAL( @p_d_port_code               , @v_delimiter, @mst_loop_cnt );
				SET @v_d_port_name                = dbo.SCM_ARR_SPL_VAL( @p_d_port_name               , @v_delimiter, @mst_loop_cnt );
				SET @v_a_country                  = dbo.SCM_ARR_SPL_VAL( @p_a_country                 , @v_delimiter, @mst_loop_cnt );
				SET @v_a_port_code                = dbo.SCM_ARR_SPL_VAL( @p_a_port_code               , @v_delimiter, @mst_loop_cnt );
				SET @v_a_port_name                = dbo.SCM_ARR_SPL_VAL( @p_a_port_name               , @v_delimiter, @mst_loop_cnt );
				SET @v_shipping_company           = dbo.SCM_ARR_SPL_VAL( @p_shipping_company          , @v_delimiter, @mst_loop_cnt );
				SET @v_to_country                 = dbo.SCM_ARR_SPL_VAL( @p_to_country                , @v_delimiter, @mst_loop_cnt );
				SET @v_to_city                    = dbo.SCM_ARR_SPL_VAL( @p_to_city                   , @v_delimiter, @mst_loop_cnt );
				SET @v_to_city_name               = dbo.SCM_ARR_SPL_VAL( @p_to_city_name              , @v_delimiter, @mst_loop_cnt );
				SET @v_ship_doc_preparation_date  = dbo.SCM_ARR_SPL_VAL( @p_ship_doc_preparation_date , @v_delimiter, @mst_loop_cnt );
				SET @v_lt_departure_inland        = dbo.SCM_ARR_SPL_VAL( @p_lt_departure_inland       , @v_delimiter, @mst_loop_cnt );
				SET @v_lt_wait_shipping           = dbo.SCM_ARR_SPL_VAL( @p_lt_wait_shipping          , @v_delimiter, @mst_loop_cnt );
				SET @v_lt_voyage                  = dbo.SCM_ARR_SPL_VAL( @p_lt_voyage                 , @v_delimiter, @mst_loop_cnt );
				SET @v_lt_lay_off_clearance       = dbo.SCM_ARR_SPL_VAL( @p_lt_lay_off_clearance      , @v_delimiter, @mst_loop_cnt );
				SET @v_lt_arrival_inland          = dbo.SCM_ARR_SPL_VAL( @p_lt_arrival_inland         , @v_delimiter, @mst_loop_cnt );
				SET @v_user_id                    = dbo.SCM_ARR_SPL_VAL( @p_user_id                   , @v_delimiter, @mst_loop_cnt );
				SET @v_valid_yn                   = dbo.SCM_ARR_SPL_VAL( @p_valid_yn                  , @v_delimiter, @mst_loop_cnt );
				SET @v_lt_type                    = dbo.SCM_ARR_SPL_VAL( @p_lt_type                  , @v_delimiter, @mst_loop_cnt );

				SET @v_OneSegmentCost             = dbo.SCM_ARR_SPL_VAL( @p_OneSegmentCost           , @v_delimiter, @mst_loop_cnt );  ---
				SET @v_TwoSegmentCost             = dbo.SCM_ARR_SPL_VAL( @p_TwoSegmentCost           , @v_delimiter, @mst_loop_cnt );----
				SET @v_ThreeSegmentCost           = dbo.SCM_ARR_SPL_VAL( @p_ThreeSegmentCost          , @v_delimiter, @mst_loop_cnt );----


				--set @v_valid_yn = isnull(@v_valid_yn,'N');
						--PRINT '6';
						--PRINT ' @v_valid_yn ='+ ISNULL(@v_valid_yn,'') ;
			END;

			-- LOOP 파라미터 출력 DEBUG용			
			IF (@debug_mode ='T') 
			BEGIN		
				PRINT '=====================INPUT==========================';			
				--PRINT '@v_data_dup_cnt = ' +CONVERT(VARCHAR,@v_data_dup_cnt);
				PRINT '@v_active_flag               = ' + @v_active_flag                ;
				PRINT '@v_route_id                  = ' + @v_route_id                   ;
				PRINT '@v_from_country              = ' + @v_from_country               ;
				PRINT '@v_from_city                 = ' + @v_from_city                  ;
				PRINT '@v_from_city_name            = ' + @v_from_city_name             ;
				PRINT '@v_transport_mode            = ' + @v_transport_mode             ;
				PRINT '@v_priority                  = ' + @v_priority                   ;
				PRINT '@v_days_mon                  = ' + @v_days_mon                   ;
				PRINT '@v_days_tue                  = ' + @v_days_tue                   ;
				PRINT '@v_days_wed                  = ' + @v_days_wed                   ;
				PRINT '@v_days_thu                  = ' + @v_days_thu                   ;
				PRINT '@v_days_fri                  = ' + @v_days_fri                   ;
				PRINT '@v_days_sat                  = ' + @v_days_sat                   ;
				PRINT '@v_days_sun                  = ' + @v_days_sun                   ;
				PRINT '@v_d_country                 = ' + @v_d_country                  ;
				PRINT '@v_d_port_code               = ' + @v_d_port_code                ;
				PRINT '@v_d_port_name               = ' + @v_d_port_name                ;
				PRINT '@v_a_country                 = ' + @v_a_country                  ;
				PRINT '@v_a_port_code               = ' + @v_a_port_code                ;
				PRINT '@v_a_port_name               = ' + @v_a_port_name                ;
				PRINT '@v_shipping_company          = ' + @v_shipping_company           ;
				PRINT '@v_to_country                = ' + @v_to_country                 ;
				PRINT '@v_to_city                   = ' + @v_to_city                    ;
				PRINT '@v_to_city_name              = ' + @v_to_city_name               ;
				PRINT '@v_ship_doc_preparation_date = ' + @v_ship_doc_preparation_date  ;
				PRINT '@v_lt_departure_inland       = ' + @v_lt_departure_inland        ;
				PRINT '@v_lt_wait_shipping          = ' + @v_lt_wait_shipping           ;
				PRINT '@v_lt_voyage                 = ' + @v_lt_voyage           ;
				PRINT '@v_lt_lay_off_clearance      = ' + @v_lt_lay_off_clearance       ;
				PRINT '@v_lt_arrival_inland         = ' + @v_lt_arrival_inland          ;
				PRINT '@v_user_id                   = ' + @v_user_id                    ;
				PRINT '@v_valid_yn                  = ' + @v_valid_yn                   ;
				PRINT '@v_lt_type                   = ' + @v_lt_type                    ;

			END;

			--PRINT 'LOC_1';
		   --이력저장
			EXEC [PR_SCP_MST_DISTRIBUTION_ROUTE_HIST]   @v_route_id					          
													,@v_from_country			        
													,@v_from_city				          
													,@v_from_city_name		        
													,@v_transport_mode		        
													,@v_priority					        
													,@v_days_mon					        
													,@v_days_tue					        
													,@v_days_wed					        
													,@v_days_thu					        
													,@v_days_fri					        
													,@v_days_sat					        
													,@v_days_sun					        
													,@v_d_country				          
													,@v_d_port_code			          
													,@v_d_port_name			          
													,@v_a_country				          
													,@v_a_port_code			          
													,@v_a_port_name			          
													,@v_shipping_company	        
													,@v_to_country				        
													,@v_to_city					          
													,@v_to_city_name			        
													,@v_ship_doc_preparation_date	
													,@v_lt_departure_inland	      
													,@v_lt_wait_shipping			    
													,@v_lt_voyage				          
													,@v_lt_lay_off_clearance	    
													,@v_lt_arrival_inland		      
													,@v_valid_yn					        
													,@v_user_id				        
													,@v_creation_date		          
													,@v_user_id	        
													,@v_lt_type
													,@v_OneSegmentCost--
													,@v_TwoSegmentCost--
													,@v_ThreeSegmentCost--
			--PRINT 'LOC_2';
			--데이터 저장
			IF @mst_loop_cnt > 0 			
				BEGIN		

					-- 수정
					IF( @v_active_flag ='M') 
						BEGIN						
							
							UPDATE dbo.scp_mst_distribution_route                            
							SET    from_country              = UPPER(@v_from_country)               
								 , from_city                 = UPPER(@v_from_city)                  
								 --, from_city_name            = @v_from_city_name             
								 , transport_mode            = @v_transport_mode             
								 , priority                  = @v_priority                   
								 , days_mon                  = @v_days_mon                   
								 , days_tue                  = @v_days_tue                   
								 , days_wed                  = @v_days_wed                   
								 , days_thu                  = @v_days_thu                   
								 , days_fri                  = @v_days_fri                   
								 , days_sat                  = @v_days_sat                   
								 , days_sun                  = @v_days_sun                   
								 , d_country                 = @v_d_country                  
								 , d_port_code               = @v_d_port_code                
								 , d_port_name               = @v_d_port_name                
								 , a_country                 = @v_a_country                  
								 , a_port_code               = @v_a_port_code                
								 , a_port_name               = @v_a_port_name                
								 , shipping_company          = @v_shipping_company           
								 , to_country                = UPPER(@v_to_country)                 
								 , to_city                   = UPPER(@v_to_city)                    
								 --, to_city_name              = @v_to_city_name               
								 , ship_doc_preparation_date = @v_ship_doc_preparation_date
								 --, lt_departure_inland       = (case when isnull(@v_lt_departure_inland,'')='' then 0 else  @v_lt_departure_inland end)       
								 --, lt_wait_shipping          = (case when isnull(@v_lt_wait_shipping,'')='' then 0 else  @v_lt_wait_shipping end)                  
								 --, lt_voyage				 = (case when isnull(@v_lt_voyage,'')='' then 0 else  @v_lt_voyage end)            
								 --, lt_lay_off_clearance      = (case when isnull(@v_lt_lay_off_clearance,'')='' then 0 else  @v_lt_lay_off_clearance end)        
								 --, lt_arrival_inland         = (case when isnull(@v_lt_arrival_inland,'')='' then 0 else  @v_lt_arrival_inland end)           
								 , lt_departure_inland       = @v_lt_departure_inland        
								 , lt_wait_shipping          = @v_lt_wait_shipping           
								 , lt_voyage				 = @v_lt_voyage           
								 , lt_lay_off_clearance      = @v_lt_lay_off_clearance       
								 , lt_arrival_inland         = @v_lt_arrival_inland          
								 , valid_yn                  = @v_valid_yn
								 , last_updated_by           = @v_user_id                            
								 , last_update_date          =  sysdatetime()          
								 , LT_TYPE					 = @v_lt_type           
								 
								 ,ATTRIBUTE1 =@v_OneSegmentCost--
								 ,ATTRIBUTE2 =@v_TwoSegmentCost--
								 ,ATTRIBUTE3 =@v_ThreeSegmentCost--
							WHERE route_id =   @v_route_id      
							;   
							--PRINT 'LOC_3';                                     							  
						END;
					ELSE IF(@v_active_flag ='I') 
						BEGIN
                                
							SET @v_route_id= NEXT VALUE FOR SEQ1_SCP_MST_DISTRIBUTION_ROUTE;
                            	        
							INSERT
							INTO   dbo.SCP_MST_DISTRIBUTION_ROUTE
								   (
										 ROUTE_ID
										,FROM_COUNTRY
										,FROM_CITY
										--,FROM_CITY_NAME
										,TRANSPORT_MODE
										,PRIORITY
										,DAYS_MON
										,DAYS_TUE
										,DAYS_WED
										,DAYS_THU
										,DAYS_FRI
										,DAYS_SAT
										,DAYS_SUN
										,D_COUNTRY
										,D_PORT_CODE
										,D_PORT_NAME
										,A_COUNTRY
										,A_PORT_CODE
										,A_PORT_NAME
										,SHIPPING_COMPANY
										,TO_COUNTRY
										,TO_CITY
										--,TO_CITY_NAME
										,SHIP_DOC_PREPARATION_DATE
										,LT_DEPARTURE_INLAND
										,LT_WAIT_SHIPPING
										,lt_voyage
										,LT_LAY_OFF_CLEARANCE
										,LT_ARRIVAL_INLAND
										,VALID_YN
										,CREATED_BY
										,CREATION_DATE
										,LAST_UPDATED_BY
										,LAST_UPDATE_DATE
										,LT_TYPE
										,ATTRIBUTE1--
										,ATTRIBUTE2--
										,ATTRIBUTE3--
								   )
								   VALUES
								   (     --(select isnull(max(ROUTE_ID),0)+1 from SCP_MST_DISTRIBUTION_ROUTE) --@v_route_id 
										 @v_route_id
								        ,UPPER(@v_from_country)
										,UPPER(@v_from_city  )                 
										--,@v_from_city_name              
										,@v_transport_mode              
										,@v_priority                    
										,@v_days_mon                    
										,@v_days_tue                    
										,@v_days_wed                    
										,@v_days_thu                    
										,@v_days_fri                    
										,@v_days_sat                    
										,@v_days_sun                    
										,@v_d_country                   
										,@v_d_port_code                 
										,@v_d_port_name                 
										,@v_a_country                   
										,@v_a_port_code                 
										,@v_a_port_name                 
										,@v_shipping_company            
										,UPPER(@v_to_country)
										,UPPER(@v_to_city   )                  
										--,@v_to_city_name                
										,@v_ship_doc_preparation_date
										--,(case when isnull(@v_lt_departure_inland,'')='' then 0 else  @v_lt_departure_inland end)          
										--,(case when isnull(@v_lt_wait_shipping,'')='' then 0 else  @v_lt_wait_shipping end)            
										--,(case when isnull(@v_lt_voyage,'')='' then 0 else  @v_lt_voyage end)            
										--,(case when isnull(@v_lt_lay_off_clearance,'')='' then 0 else  @v_lt_lay_off_clearance end)        
										--,(case when isnull(@v_lt_arrival_inland,'')='' then 0 else  @v_lt_arrival_inland end)           
										,@v_lt_departure_inland         
										,@v_lt_wait_shipping            
										,@v_lt_voyage            
										,@v_lt_lay_off_clearance        
										,@v_lt_arrival_inland           
										,@v_valid_yn
										,@v_user_id                            
								 		, sysdatetime()  										
										,@v_user_id                            
								 		, sysdatetime()  	
										,@v_lt_type			
										,@v_OneSegmentCost--
										,@v_TwoSegmentCost--
										,@v_ThreeSegmentCost--

								   )     
								;
								--PRINT 'LOC_4';
						END;
					ELSE IF(@v_active_flag ='D')
						BEGIN
							DELETE FROM dbo.SCP_MST_DISTRIBUTION_ROUTE
							WHERE route_id =   @v_route_id      
							;     
						END; 	
				END  -- END OF STMT. IF( @mst_loop_cnt > 0 )			
			
		END -- END OF STMT. WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt


		/* 중복체크 */
		DECLARE @mst_loop_cnt_chk INT=0;

		WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt_chk < @max_loop_cnt
		BEGIN    
				
			-- @mst_loop_cnt 1증가
			SET @mst_loop_cnt_chk = @mst_loop_cnt_chk + 1;			

			-- 각 컬럼들에 대한 스플릿처리로직 스타트
			BEGIN

				SET @v_active_flag				  = dbo.SCM_ARR_SPL_VAL( @p_active_flag				  , @v_delimiter, @mst_loop_cnt_chk );
				SET @v_route_id                   = dbo.SCM_ARR_SPL_VAL( @p_route_id                  , @v_delimiter, @mst_loop_cnt_chk );
				SET @v_from_country               = dbo.SCM_ARR_SPL_VAL( @p_from_country              , @v_delimiter, @mst_loop_cnt_chk );
				SET @v_from_city                  = dbo.SCM_ARR_SPL_VAL( @p_from_city                 , @v_delimiter, @mst_loop_cnt_chk );
				SET @v_from_city_name             = dbo.SCM_ARR_SPL_VAL( @p_from_city_name            , @v_delimiter, @mst_loop_cnt_chk );
				SET @v_transport_mode             = dbo.SCM_ARR_SPL_VAL( @p_transport_mode            , @v_delimiter, @mst_loop_cnt_chk );
				SET @v_priority                   = dbo.SCM_ARR_SPL_VAL( @p_priority                  , @v_delimiter, @mst_loop_cnt_chk );
				SET @v_days_mon                   = dbo.SCM_ARR_SPL_VAL( @p_days_mon                  , @v_delimiter, @mst_loop_cnt_chk );
				SET @v_days_tue                   = dbo.SCM_ARR_SPL_VAL( @p_days_tue                  , @v_delimiter, @mst_loop_cnt_chk );
				SET @v_days_wed                   = dbo.SCM_ARR_SPL_VAL( @p_days_wed                  , @v_delimiter, @mst_loop_cnt_chk );
				SET @v_days_thu                   = dbo.SCM_ARR_SPL_VAL( @p_days_thu                  , @v_delimiter, @mst_loop_cnt_chk );
				SET @v_days_fri                   = dbo.SCM_ARR_SPL_VAL( @p_days_fri                  , @v_delimiter, @mst_loop_cnt_chk );
				SET @v_days_sat                   = dbo.SCM_ARR_SPL_VAL( @p_days_sat                  , @v_delimiter, @mst_loop_cnt_chk );
				SET @v_days_sun                   = dbo.SCM_ARR_SPL_VAL( @p_days_sun                  , @v_delimiter, @mst_loop_cnt_chk );
				SET @v_d_country                  = dbo.SCM_ARR_SPL_VAL( @p_d_country                 , @v_delimiter, @mst_loop_cnt_chk );
				SET @v_d_port_code                = dbo.SCM_ARR_SPL_VAL( @p_d_port_code               , @v_delimiter, @mst_loop_cnt_chk );
				SET @v_d_port_name                = dbo.SCM_ARR_SPL_VAL( @p_d_port_name               , @v_delimiter, @mst_loop_cnt_chk );
				SET @v_a_country                  = dbo.SCM_ARR_SPL_VAL( @p_a_country                 , @v_delimiter, @mst_loop_cnt_chk );
				SET @v_a_port_code                = dbo.SCM_ARR_SPL_VAL( @p_a_port_code               , @v_delimiter, @mst_loop_cnt_chk );
				SET @v_a_port_name                = dbo.SCM_ARR_SPL_VAL( @p_a_port_name               , @v_delimiter, @mst_loop_cnt_chk );
				SET @v_shipping_company           = dbo.SCM_ARR_SPL_VAL( @p_shipping_company          , @v_delimiter, @mst_loop_cnt_chk );
				SET @v_to_country                 = dbo.SCM_ARR_SPL_VAL( @p_to_country                , @v_delimiter, @mst_loop_cnt_chk );
				SET @v_to_city                    = dbo.SCM_ARR_SPL_VAL( @p_to_city                   , @v_delimiter, @mst_loop_cnt_chk );
				SET @v_to_city_name               = dbo.SCM_ARR_SPL_VAL( @p_to_city_name              , @v_delimiter, @mst_loop_cnt_chk );
				SET @v_ship_doc_preparation_date  = dbo.SCM_ARR_SPL_VAL( @p_ship_doc_preparation_date , @v_delimiter, @mst_loop_cnt_chk );
				SET @v_lt_departure_inland        = dbo.SCM_ARR_SPL_VAL( @p_lt_departure_inland       , @v_delimiter, @mst_loop_cnt_chk );
				SET @v_lt_wait_shipping           = dbo.SCM_ARR_SPL_VAL( @p_lt_wait_shipping          , @v_delimiter, @mst_loop_cnt_chk );
				SET @v_lt_voyage                  = dbo.SCM_ARR_SPL_VAL( @p_lt_voyage                 , @v_delimiter, @mst_loop_cnt_chk );
				SET @v_lt_lay_off_clearance       = dbo.SCM_ARR_SPL_VAL( @p_lt_lay_off_clearance      , @v_delimiter, @mst_loop_cnt_chk );
				SET @v_lt_arrival_inland          = dbo.SCM_ARR_SPL_VAL( @p_lt_arrival_inland         , @v_delimiter, @mst_loop_cnt_chk );
				SET @v_user_id                    = dbo.SCM_ARR_SPL_VAL( @p_user_id                   , @v_delimiter, @mst_loop_cnt_chk );
				SET @v_valid_yn                   = dbo.SCM_ARR_SPL_VAL( @p_valid_yn                  , @v_delimiter, @mst_loop_cnt_chk );
				SET @v_lt_type                    = dbo.SCM_ARR_SPL_VAL( @p_lt_type                   , @v_delimiter, @mst_loop_cnt_chk );

				SET @v_OneSegmentCost             = dbo.SCM_ARR_SPL_VAL( @p_OneSegmentCost           , @v_delimiter, @mst_loop_cnt_chk );  ---
				SET @v_TwoSegmentCost             = dbo.SCM_ARR_SPL_VAL( @p_TwoSegmentCost           , @v_delimiter, @mst_loop_cnt_chk );  ----
				SET @v_ThreeSegmentCost           = dbo.SCM_ARR_SPL_VAL( @p_ThreeSegmentCost         , @v_delimiter, @mst_loop_cnt_chk );  ----


				--set @v_valid_yn = isnull(@v_valid_yn,'N');
						--PRINT '6';
						--PRINT ' @v_valid_yn ='+ ISNULL(@v_valid_yn,'') ;
			END;

			-- LOOP 파라미터 출력 DEBUG용			
			IF (@debug_mode ='T') 
			BEGIN		
				PRINT '=====================DUP CHECK==========================';			
				--PRINT '@v_data_dup_cnt = ' +CONVERT(VARCHAR,@v_data_dup_cnt);
				PRINT '@v_active_flag               = ' + @v_active_flag                ;
				PRINT '@v_route_id                  = ' + @v_route_id                   ;
				PRINT '@v_from_country              = ' + @v_from_country               ;
				PRINT '@v_from_city                 = ' + @v_from_city                  ;
				PRINT '@v_from_city_name            = ' + @v_from_city_name             ;
				PRINT '@v_transport_mode            = ' + @v_transport_mode             ;
				PRINT '@v_priority                  = ' + @v_priority                   ;
				PRINT '@v_days_mon                  = ' + @v_days_mon                   ;
				PRINT '@v_days_tue                  = ' + @v_days_tue                   ;
				PRINT '@v_days_wed                  = ' + @v_days_wed                   ;
				PRINT '@v_days_thu                  = ' + @v_days_thu                   ;
				PRINT '@v_days_fri                  = ' + @v_days_fri                   ;
				PRINT '@v_days_sat                  = ' + @v_days_sat                   ;
				PRINT '@v_days_sun                  = ' + @v_days_sun                   ;
				PRINT '@v_d_country                 = ' + @v_d_country                  ;
				PRINT '@v_d_port_code               = ' + @v_d_port_code                ;
				PRINT '@v_d_port_name               = ' + @v_d_port_name                ;
				PRINT '@v_a_country                 = ' + @v_a_country                  ;
				PRINT '@v_a_port_code               = ' + @v_a_port_code                ;
				PRINT '@v_a_port_name               = ' + @v_a_port_name                ;
				PRINT '@v_shipping_company          = ' + @v_shipping_company           ;
				PRINT '@v_to_country                = ' + @v_to_country                 ;
				PRINT '@v_to_city                   = ' + @v_to_city                    ;
				PRINT '@v_to_city_name              = ' + @v_to_city_name               ;
				PRINT '@v_ship_doc_preparation_date = ' + @v_ship_doc_preparation_date  ;
				PRINT '@v_lt_departure_inland       = ' + @v_lt_departure_inland        ;
				PRINT '@v_lt_wait_shipping          = ' + @v_lt_wait_shipping           ;
				PRINT '@v_lt_voyage                 = ' + @v_lt_voyage           ;
				PRINT '@v_lt_lay_off_clearance      = ' + @v_lt_lay_off_clearance       ;
				PRINT '@v_lt_arrival_inland         = ' + @v_lt_arrival_inland          ;
				PRINT '@v_user_id                   = ' + @v_user_id                    ;
				PRINT '@v_valid_yn                  = ' + @v_valid_yn                   ;
				PRINT '@v_lt_type                   = ' + @v_lt_type                    ;

			END;

			SET @v_data_dup_cnt  =0;
			-- PRIORITY 중복체크
			SELECT @v_data_dup_cnt = COUNT(*) 
			 FROM SCP_MST_DISTRIBUTION_ROUTE
			WHERE FROM_COUNTRY     = UPPER(@v_from_country)
			  AND FROM_CITY        = UPPER(@v_from_city)
			  AND PRIORITY         = @v_priority
			  AND TO_COUNTRY       = UPPER(@v_to_country)
			  AND TO_CITY          = UPPER(@v_to_city)
			;
			IF( @v_data_dup_cnt>1) 
				BEGIN
					SET @v_err_code    = 99020 ; 
					SET @v_err_message = 'DUP PRIORITY.';
					THROW @v_err_code, @v_err_message , 1; --예외발생
									 
				END;

			SET @v_data_dup_cnt  =0;
			-- 데이타 중복체크
			SELECT @v_data_dup_cnt = COUNT(*) 
			 FROM SCP_MST_DISTRIBUTION_ROUTE
			WHERE FROM_COUNTRY     = UPPER(@v_from_country)
			  AND FROM_CITY        = UPPER(@v_from_city)
			  AND TRANSPORT_MODE   = @v_transport_mode  
			  AND D_COUNTRY        = @v_d_country       
			  AND D_PORT_CODE      = @v_d_port_code     
			  AND D_PORT_NAME      = @v_d_port_name     
			  AND A_COUNTRY        = @v_a_country       
			  AND A_PORT_CODE      = @v_a_port_code     
			  AND A_PORT_NAME      = @v_a_port_name     
			  AND SHIPPING_COMPANY = @v_shipping_company
			  AND TO_COUNTRY       = UPPER(@v_to_country)
			  AND TO_CITY          = UPPER(@v_to_city)
			  AND LT_TYPE		   = @v_lt_type
			;
									
			IF( @v_data_dup_cnt>1) 
				BEGIN
					SET @v_err_code    = 99010 ; 
					SET @v_err_message = 'DUP DATA.';
					THROW @v_err_code, @v_err_message , 1; --예외발생
									 
				END;

		END -- END OF STMT. WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt_chk < @max_loop_cnt


		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		COMMIT ;			
		
		-- 결과코드, 결과 카운트 반환
		SELECT  'S' AS result_code,  @mst_loop_cnt AS result_cnt ;

	END TRY

	BEGIN CATCH 
		BEGIN
			ROLLBACK; --입력 데이타 롤백 처리
						
			INSERT INTO scm_sys_log_batch (program_name,log_type,log_count,log_message,description,event_date,creation_date,created_by,last_update_date,last_updated_by)
			VALUES (ERROR_PROCEDURE(),'ERROR',NULL,ERROR_MESSAGE(),NULL,SYSDATETIME(),SYSDATETIME(),ERROR_PROCEDURE(),SYSDATETIME(),ERROR_PROCEDURE());

			IF @@TRANCOUNT > 0
			  COMMIT WORK;
					  

			-- error코드, errror 메시지 반환
			SELECT 'F' AS result_code;

			IF( @v_err_code IS NULL OR @v_err_code ='')
				SET @v_err_code= ERROR_NUMBER() ;
			IF( @v_err_message IS NULL OR @v_err_message ='') 
				SET @v_err_message=  ERROR_MESSAGE();
						
			/* 에러 메시지, 에러 데이터  반환   */	
			SELECT  @v_err_code			AS err_code
				   ,@v_err_message		AS err_message
				   ,@v_route_id         AS route_id            
				   ,@v_from_country     AS from_country        
				   ,@v_from_city        AS from_city           
				   ,@v_from_city_name   AS from_city_name      
				   ,@v_transport_mode   AS transport_mode      
				   ,@v_d_country        AS d_country           
				   ,@v_d_port_code      AS d_port_code         
				   ,@v_d_port_name      AS d_port_name         
				   ,@v_a_country        AS a_country           
				   ,@v_a_port_code      AS a_port_code         
				   ,@v_a_port_name      AS a_port_name         
				   ,@v_shipping_company AS shipping_company    
				   ,@v_to_country       AS to_country          
				   ,@v_to_city          AS to_city             
				   ,@v_to_city_name     AS to_city_name        
				   ,@v_lt_type			AS lt_type
				    ,@v_OneSegmentCost    AS OneSegmentCost
				   ,@v_TwoSegmentCost    AS TwoSegmentCost
				   ,@v_ThreeSegmentCost  AS ThreeSegmentCost
		
		END;
	END CATCH;
END
