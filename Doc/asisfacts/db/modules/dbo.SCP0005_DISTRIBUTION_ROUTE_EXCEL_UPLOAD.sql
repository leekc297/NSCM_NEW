


/*
 * Program ID   : SCP0005_DISTRIBUTION_ROUTE_EXCEL_UPLOAD
 * Description  : SCP0005_DISTRIBUTION_ROUTE_EXCEL_UPLOAD
 * Program History
 *===========================================================================================================
 *   Date       In Charge		Description
 *===========================================================================================================
 * 2019.08.01	AYJ				[CSR ID:4030199] SSP Distribution route엑셀 업로드를 통한 신규등록/수정기능 구현
 *
 */

  CREATE PROCEDURE [dbo].[SCP0005_DISTRIBUTION_ROUTE_EXCEL_UPLOAD]
	@p_cnt                          NVARCHAR(MAX),
	@p_route_id                     NVARCHAR(MAX),
	@p_lt_type                      NVARCHAR(MAX),
	@p_from_country                 NVARCHAR(MAX),
	@p_from_city                    NVARCHAR(MAX),
	@p_transport_mode               NVARCHAR(MAX),
	@p_priority                     NVARCHAR(MAX),
	@p_days_mon                     NVARCHAR(MAX),
	@p_days_tue                     NVARCHAR(MAX),
	@p_days_wed                     NVARCHAR(MAX),
	@p_days_thu                     NVARCHAR(MAX),
	@p_days_fri                     NVARCHAR(MAX),
	@p_days_sat                     NVARCHAR(MAX),
	@p_days_sun                     NVARCHAR(MAX),
	@p_d_port_name                  NVARCHAR(MAX),
	@p_d_country                    NVARCHAR(MAX),
	@p_d_port_code                  NVARCHAR(MAX),
	@p_a_port_name                  NVARCHAR(MAX),
	@p_a_country                    NVARCHAR(MAX),
	@p_a_port_code                  NVARCHAR(MAX),
	@p_shipping_company             NVARCHAR(MAX),
	@p_to_country                   NVARCHAR(MAX),
	@p_to_city                      NVARCHAR(MAX),
	@p_ship_doc_preparation_date    NVARCHAR(MAX),
	@p_lt_departure_inland          NVARCHAR(MAX),
	@p_lt_wait_shipping             NVARCHAR(MAX),
	@p_lt_voyage                    NVARCHAR(MAX),
	@p_lt_lay_off_clearance         NVARCHAR(MAX),
	@p_lt_arrival_inland            NVARCHAR(MAX),
	@p_OneSegmentCost               NVARCHAR(MAX),
	@p_TwoSegmentCost               NVARCHAR(MAX),
	@p_ThreeSegmentCost             NVARCHAR(MAX),
	@p_valid_yn                     NVARCHAR(MAX),
	@p_user_id                      NVARCHAR(MAX)	

AS

BEGIN
    SET NOCOUNT ON;
	DECLARE @v_program_id			NVARCHAR(40) = 'SCP0005';
	DECLARE @v_sheet_name			NVARCHAR(40) = 'Distribution Route';
	DECLARE @v_working_time			datetime =sysdatetime();
	
	DECLARE @v_route_id             NVARCHAR(MAX);
	DECLARE @v_from_city_name       NVARCHAR(MAX);
	DECLARE @v_to_city_name         NVARCHAR(MAX);
	DECLARE @v_transport_mode       NVARCHAR(MAX);
	DECLARE @v_days_mon			    NVARCHAR(MAX);
	DECLARE @v_days_tue			    NVARCHAR(MAX);
	DECLARE @v_days_wed			    NVARCHAR(MAX);
	DECLARE @v_days_thu			    NVARCHAR(MAX);
	DECLARE @v_days_fri			    NVARCHAR(MAX);
	DECLARE @v_days_sat			    NVARCHAR(MAX);
	DECLARE @v_days_sun			    NVARCHAR(MAX);

	DECLARE @v_chk					INT;
	SET @v_chk = 0;
	DECLARE @v_cnt					INT;
	SET @v_cnt = convert(int, @p_cnt);

	DECLARE @Query					NVARCHAR(MAX);
	DECLARE @Column_Query			NVARCHAR(MAX);
	DECLARE @v_data_dup				NVARCHAR(MAX);
	DECLARE @v_data_dup_cnt			INT=0;
	SET @Query = '';
	SET @Column_Query = '';
	SET @v_from_city_name           = NULL;
	SET @v_to_city_name             = NULL;
	SET @v_days_mon					= @p_days_mon;
	SET @v_days_tue					= @p_days_tue;
	SET @v_days_wed					= @p_days_wed;
	SET @v_days_thu					= @p_days_thu;
	SET @v_days_fri					= @p_days_fri;
	SET @v_days_sat					= @p_days_sat;
	SET @v_days_sun					= @p_days_sun;
	SET @v_transport_mode           = @p_transport_mode;
	SET @v_route_id					= @p_route_id;

	IF (@p_transport_mode = 'FERRY') SET @v_transport_mode = 'FRY'
	IF (@p_transport_mode = 'TRUCK') SET @v_transport_mode = 'TRK'

	IF (@v_days_mon = 'N') SET @v_days_mon = ''
	IF (@v_days_tue = 'N') SET @v_days_tue = ''
	IF (@v_days_wed = 'N') SET @v_days_wed = ''
	IF (@v_days_thu = 'N') SET @v_days_thu = ''
	IF (@v_days_fri = 'N') SET @v_days_fri = ''
	IF (@v_days_sat = 'N') SET @v_days_sat = ''
	IF (@v_days_sun = 'N') SET @v_days_sun = ''

	--LOG 변수
	DECLARE @v_program_name NVARCHAR(150) = 'SCP0005_DISTRIBUTION_ROUTE_EXCEL_UPLOAD';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	-- 예외처리 변수 설정
	DECLARE @v_err_code  INTEGER;
	DECLARE @v_err_message  NVARCHAR(4000)='';

--	BEGIN TRAN;
--	BEGIN TRY
	BEGIN TRY
	BEGIN TRAN
	

		--DATA SAVE

		--//LOG START///////////////////////////////////////////////--
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		--//////////////////////////////////////////////////////////--

		BEGIN

			--from_city_name 가져오기
			SELECT @v_from_city_name = CITY_NAME
			FROM SCM_MST_CITY WITH(NOLOCK)
			WHERE  VALID_YN = 'Y'
			AND	   COUNTRY = @p_from_country
			AND	   CITY = @p_from_city

			--v_to_city_name 구하기
			SELECT @v_to_city_name = CITY_NAME
			FROM SCM_MST_CITY WITH(NOLOCK)
			WHERE  VALID_YN = 'Y'
			AND	   COUNTRY = @p_to_country
			AND	   CITY = @p_to_city

			--이력저장
			IF (@p_route_id = NULL) SET @v_route_id = 0

			EXEC [PR_SCP_MST_DISTRIBUTION_ROUTE_HIST]   @v_route_id	 
													,@p_from_country			        
													,@p_from_city				          
													,@v_from_city_name		        
													,@v_transport_mode	        
													,@p_priority					        
													,@v_days_mon					        
													,@v_days_tue					        
													,@v_days_wed					        
													,@v_days_thu					        
													,@v_days_fri					        
													,@v_days_sat					        
													,@v_days_sun					        
													,@p_d_country				          
													,@p_d_port_code			          
													,@p_d_port_name			          
													,@p_a_country				          
													,@p_a_port_code			          
													,@p_a_port_name			          
													,@p_shipping_company	        
													,@p_to_country				        
													,@p_to_city					          
													,@v_to_city_name			        
													,@p_ship_doc_preparation_date	
													,@p_lt_departure_inland	      
													,@p_lt_wait_shipping			    
													,@p_lt_voyage				          
													,@p_lt_lay_off_clearance	    
													,@p_lt_arrival_inland		      
													,@p_valid_yn					        
													,@p_user_id				        
													,@v_working_time		          
													,@p_user_id
													,@p_lt_type    
													,@p_OneSegmentCost
													,@p_TwoSegmentCost
													,@p_ThreeSegmentCost


			SELECT @v_chk = COUNT(*) 
			FROM SCP_MST_DISTRIBUTION_ROUTE
			WHERE 1 = 1
			  AND ROUTE_ID = @p_route_id;

			IF(@v_chk > 0)
			BEGIN
				UPDATE SCP_MST_DISTRIBUTION_ROUTE
				SET
					LT_TYPE						= UPPER(@p_lt_type)	
					,FROM_COUNTRY					= UPPER(@p_from_country)
					,FROM_CITY						= UPPER(@p_from_city)
					,TRANSPORT_MODE					= UPPER(@v_transport_mode)
					,PRIORITY						= @p_priority
					,DAYS_MON						= UPPER(@v_days_mon)
					,DAYS_TUE						= UPPER(@v_days_tue)
					,DAYS_WED						= UPPER(@v_days_wed)
					,DAYS_THU						= UPPER(@v_days_thu)
					,DAYS_FRI						= UPPER(@v_days_fri)
					,DAYS_SAT						= UPPER(@v_days_sat)
					,DAYS_SUN						= UPPER(@v_days_sun)
					,D_PORT_NAME					= @p_d_port_name
					,D_COUNTRY						= @p_d_country					
					,D_PORT_CODE					= @p_d_port_code
					,A_PORT_NAME					= @p_a_port_name
					,A_COUNTRY						= @p_a_country
					,A_PORT_CODE					= @p_a_port_code
					,SHIPPING_COMPANY				= @p_shipping_company
					,TO_COUNTRY						= UPPER(@p_to_country)
					,TO_CITY						= UPPER(@p_to_city)
					,SHIP_DOC_PREPARATION_DATE		= @p_ship_doc_preparation_date
					,LT_DEPARTURE_INLAND			= @p_lt_departure_inland
					,LT_WAIT_SHIPPING				= @p_lt_wait_shipping
					,lt_voyage						= @p_lt_voyage
					,LT_LAY_OFF_CLEARANCE			= @p_lt_lay_off_clearance
					,LT_ARRIVAL_INLAND				= @p_lt_arrival_inland
					,VALID_YN						= UPPER(@p_valid_yn)
					,LAST_UPDATED_BY				= @p_user_id
					,LAST_UPDATE_DATE				= @v_working_time
					,ATTRIBUTE1						= @p_OneSegmentCost
					,ATTRIBUTE2						= @p_TwoSegmentCost
					,ATTRIBUTE3						= @p_ThreeSegmentCost
				WHERE 1 = 1
				  AND ROUTE_ID = @p_route_id;
			END

			ELSE

			BEGIN
				SET @v_route_id = NEXT VALUE FOR SEQ1_SCP_MST_DISTRIBUTION_ROUTE;

				INSERT INTO SCP_MST_DISTRIBUTION_ROUTE
				(
					ROUTE_ID
					,LT_TYPE
					,FROM_COUNTRY
					,FROM_CITY
					,TRANSPORT_MODE
					,PRIORITY
					,DAYS_MON
					,DAYS_TUE
					,DAYS_WED
					,DAYS_THU
					,DAYS_FRI
					,DAYS_SAT
					,DAYS_SUN
					,D_PORT_NAME
					,D_COUNTRY
					,D_PORT_CODE
					,A_PORT_NAME
					,A_COUNTRY
					,A_PORT_CODE
					,SHIPPING_COMPANY
					,TO_COUNTRY
					,TO_CITY
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
					,ATTRIBUTE1
					,ATTRIBUTE2
					,ATTRIBUTE3
				)
				VALUES
				(
					@v_route_id
					,UPPER(@p_lt_type)
					,UPPER(@p_from_country)                 
					,UPPER(@p_from_city)                    
					,UPPER(@v_transport_mode)               
                    ,@p_priority                     
					,UPPER(@v_days_mon)                     
					,UPPER(@v_days_tue)                    
					,UPPER(@v_days_wed)                     
					,UPPER(@v_days_thu)                     
					,UPPER(@v_days_fri)                     
					,UPPER(@v_days_sat)                     
					,UPPER(@v_days_sun)                     
					,@p_d_port_name                  
					,@p_d_country                    
					,@p_d_port_code                  
					,@p_a_port_name                  
					,@p_a_country                    
					,@p_a_port_code                  
					,@p_shipping_company             
					,UPPER(@p_to_country)                   
					,UPPER(@p_to_city)                      
					,@p_ship_doc_preparation_date    
					,@p_lt_departure_inland          
					,@p_lt_wait_shipping             
					,@p_lt_voyage                    
					,@p_lt_lay_off_clearance         
					,@p_lt_arrival_inland            
					,UPPER(@p_valid_yn) 
					,@p_user_id
					,@v_working_time 
					,@p_user_id
					,@v_working_time
					,@p_OneSegmentCost
					,@p_TwoSegmentCost
					,@p_ThreeSegmentCost
				);
			END

		END;			
		--COMMIT TRAN;

		IF @v_cnt = 1
		BEGIN
			SET @Query = '';
			SET @Query = @Query + ' INSERT INTO SCM_ADM_EXCEL_UPLOAD ' + CHAR(10);
			SET @Query = @Query + ' ( ' + CHAR(10);
			SET @Query = @Query + '		UPLOAD_ID, ' + CHAR(10);
			SET @Query = @Query + '		PROGRAM_ID,			SHEET_NAME,				UPLOAD_STATUS_CODE, ' + CHAR(10);
			SET @Query = @Query + '		CREATED_BY,			CREATION_DATE,			LAST_UPDATED_BY,			LAST_UPDATE_DATE,	' + CHAR(10);
			SET @Query = @Query + '		ATTRIBUTE1,			ATTRIBUTE2,				ATTRIBUTE3,					ATTRIBUTE4,			' + CHAR(10);
			SET @Query = @Query + '		ATTRIBUTE5,			ATTRIBUTE6,				ATTRIBUTE7,					ATTRIBUTE8,			' + CHAR(10);
			SET @Query = @Query + '		ATTRIBUTE9,			ATTRIBUTE10,			ATTRIBUTE11,				ATTRIBUTE12,		' + CHAR(10);
			SET @Query = @Query + '		ATTRIBUTE13,		ATTRIBUTE14,			ATTRIBUTE15,				ATTRIBUTE16,		' + CHAR(10);
			SET @Query = @Query + '		ATTRIBUTE17,		ATTRIBUTE18,			ATTRIBUTE19,				ATTRIBUTE20,		' + CHAR(10);
			SET @Query = @Query + '		ATTRIBUTE21,		ATTRIBUTE22,			ATTRIBUTE23,				ATTRIBUTE24,		' + CHAR(10);
			SET @Query = @Query + '		ATTRIBUTE25,		ATTRIBUTE26,			ATTRIBUTE27,				ATTRIBUTE28,		' + CHAR(10);
			SET @Query = @Query + '		ATTRIBUTE29,        ATTRIBUTE30,            ATTRIBUTE31,                ATTRIBUTE32         ' + CHAR(10);
			SET @Query = @Query + ' ) ' + CHAR(10);
			SET @Query = @Query + ' VALUES ' + CHAR(10);
			SET @Query = @Query + ' ( ' + CHAR(10);
			SET @Query = @Query + '		' + CONVERT(NVARCHAR(100), NEXT VALUE FOR SEQ1_SCM_ADM_EXCEL_UPLOAD) + ', ' + CHAR(10);
			SET @Query = @Query + '		''' + @v_program_id + ''', ''' + @v_sheet_name + ''', ''@TITLE'', ' + CHAR(10);
			SET @Query = @Query + '		''' + @p_user_id + ''', ''' + CONVERT(NVARCHAR(50), @v_working_time) + ''', ''' + @p_user_id + ''', ''' + CONVERT(NVARCHAR(50), @v_working_time) + ''',' + CHAR(10);
			SET @Query = @Query + '		''Route Id'', ''L/T Type'', ''From Country'', ''From City'', ''Trans Mode'', ''Priority'',' + CHAR(10);
			SET @Query = @Query + '		''MON'', ''TUE'', ''WED'', ''THU'', ''FRI'', ''SAT'', ''SUN'', ''D Port Name'', ''D Port Country'', ''D Port Code'',' + CHAR(10);
			SET @Query = @Query + '		''A Port Name'', ''A Port Country'', ''A Port Code'', ''Forwarder'', ''To Country'', ''To City'', ''Shipping Document Preparation Date'',' + CHAR(10);
			SET @Query = @Query + '		''Departure Inland'', ''Waiting For Shipping'', ''Voyage'', ''Lay Off/Customs Clearance'', ''Arrival Inland'', ''Valid'',' + CHAR(10);
			SET @Query = @Query + '		''Pick Up Cost'', ''Freight Cost'', ''Delivery Cost''' + CHAR(10);
			SET @Query = @Query + ' ) ' + CHAR(10);
			EXEC(@Query);

		END
		
		SET @Query = '';
		SET @Query = @Query + ' INSERT INTO SCM_ADM_EXCEL_UPLOAD ' + CHAR(10);
		SET @Query = @Query + ' ( ' + CHAR(10);
		SET @Query = @Query + '		UPLOAD_ID, ' + CHAR(10);
		SET @Query = @Query + '		PROGRAM_ID,			SHEET_NAME,				UPLOAD_STATUS_CODE, ' + CHAR(10);
		SET @Query = @Query + '		CREATED_BY,			CREATION_DATE,			LAST_UPDATED_BY,			LAST_UPDATE_DATE,	' + CHAR(10);
		SET @Query = @Query + '		ATTRIBUTE1,			ATTRIBUTE2,				ATTRIBUTE3,					ATTRIBUTE4,			' + CHAR(10);
		SET @Query = @Query + '		ATTRIBUTE5,			ATTRIBUTE6,				ATTRIBUTE7,					ATTRIBUTE8,			' + CHAR(10);
		SET @Query = @Query + '		ATTRIBUTE9,			ATTRIBUTE10,			ATTRIBUTE11,				ATTRIBUTE12,		' + CHAR(10);
		SET @Query = @Query + '		ATTRIBUTE13,		ATTRIBUTE14,			ATTRIBUTE15,				ATTRIBUTE16,		' + CHAR(10);
		SET @Query = @Query + '		ATTRIBUTE17,		ATTRIBUTE18,			ATTRIBUTE19,				ATTRIBUTE20,		' + CHAR(10);
		SET @Query = @Query + '		ATTRIBUTE21,		ATTRIBUTE22,			ATTRIBUTE23,				ATTRIBUTE24,		' + CHAR(10);
		SET @Query = @Query + '		ATTRIBUTE25,		ATTRIBUTE26,			ATTRIBUTE27,				ATTRIBUTE28,		' + CHAR(10);
		SET @Query = @Query + '		ATTRIBUTE29,        ATTRIBUTE30,            ATTRIBUTE31,                ATTRIBUTE32         ' + CHAR(10);
		SET @Query = @Query + ' ) ' + CHAR(10);
		SET @Query = @Query + ' VALUES ' + CHAR(10);
		SET @Query = @Query + ' ( ' + CHAR(10);
		SET @Query = @Query + '		' + CONVERT(NVARCHAR(100), NEXT VALUE FOR SEQ1_SCM_ADM_EXCEL_UPLOAD) + ', ' + CHAR(10);
		SET @Query = @Query + '		''' + @v_program_id + ''', ''' + @v_sheet_name + ''', ''SUCCESS'', ' + CHAR(10);
		SET @Query = @Query + '		''' + @p_user_id + ''', CONVERT(DATETIME, ''' + CONVERT(NVARCHAR(50), @v_working_time) + '''), ''' + @p_user_id + ''', ''' + CONVERT(NVARCHAR(50), @v_working_time) + ''', ' + CHAR(10);
		SET @Query = @Query + '		''' + @v_route_id + ''', ''' + @p_lt_type + ''', ''' + @p_from_country + ''', ''' + @p_from_city + ''', ''' + @v_transport_mode + ''',' + CHAR(10);
		SET @Query = @Query + '		''' + @p_priority + ''', ''' + @v_days_mon + ''', ''' + @v_days_tue + ''', ''' + @v_days_wed + ''', ''' + @v_days_thu + ''',' + CHAR(10);
		SET @Query = @Query + '		''' + @v_days_fri + ''', ''' + @v_days_sat + ''', ''' + @v_days_sun + ''', ''' + @p_d_port_name + ''', ''' + @p_d_country + ''',' + CHAR(10);
		SET @Query = @Query + '		''' + @p_d_port_code + ''', ''' + @p_a_port_name + ''', ''' + @p_a_country + ''', ''' + @p_a_port_code + ''', ''' + @p_shipping_company + ''',' + CHAR(10);
		SET @Query = @Query + '		''' + @p_to_country + ''', ''' + @p_to_city + ''', ''' + @p_ship_doc_preparation_date + ''', ''' + @p_lt_departure_inland + ''',' + CHAR(10);
		SET @Query = @Query + '		''' + @p_lt_wait_shipping + ''', ''' + @p_lt_voyage + ''', ''' + @p_lt_lay_off_clearance + ''', ''' + @p_lt_arrival_inland + ''',' + CHAR(10);
		SET @Query = @Query + '		''' + @p_valid_yn + ''', ''' + @p_OneSegmentCost + ''', ''' + @p_TwoSegmentCost + ''', ''' + @p_ThreeSegmentCost + '''' + CHAR(10);
		SET @Query = @Query + ' ) ' + CHAR(10);
		EXEC(@Query);

		SET @v_data_dup_cnt  =0;
		-- PRIORITY 중복체크
		SELECT @v_data_dup_cnt = COUNT(*) 
			FROM SCP_MST_DISTRIBUTION_ROUTE
		WHERE FROM_COUNTRY     = UPPER(@p_from_country)
			AND FROM_CITY        = UPPER(@p_from_city)
			AND PRIORITY         = @p_priority
			AND TO_COUNTRY       = UPPER(@p_to_country)
			AND TO_CITY          = UPPER(@p_to_city)
		;

		IF( @v_data_dup_cnt>1) 
			BEGIN
				SET @v_err_code    = 99010 ; 
				SET @v_err_message = 'Priority Duplicate';
				THROW @v_err_code, @v_err_message , 1; --예외발생
			END;

		--//LOG END///////////////////////////////////////////////--
		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;	
		--/////////////////////////////////////////////////////////--

		COMMIT TRAN;

		SELECT  'S' AS result_code;

	END TRY
	BEGIN CATCH
		BEGIN
			ROLLBACK TRAN; --입력 데이타 롤백 처리

			SET @Query = '';
			SET @Query = @Query + ' INSERT INTO SCM_ADM_EXCEL_UPLOAD ' + CHAR(10);
			SET @Query = @Query + ' ( ' + CHAR(10);
			SET @Query = @Query + '		UPLOAD_ID, ' + CHAR(10);
			SET @Query = @Query + '		PROGRAM_ID,			SHEET_NAME,				UPLOAD_STATUS_CODE, ' + CHAR(10);
			SET @Query = @Query + '		CREATED_BY,			CREATION_DATE,			LAST_UPDATED_BY,			LAST_UPDATE_DATE,		' + CHAR(10);
			SET @Query = @Query + '		ATTRIBUTE1,			ATTRIBUTE2,				ATTRIBUTE3,					ATTRIBUTE4,				' + CHAR(10);
			SET @Query = @Query + '		ATTRIBUTE5,			ATTRIBUTE6,				ATTRIBUTE7,					ATTRIBUTE8,				' + CHAR(10);
			SET @Query = @Query + '		ATTRIBUTE9,			ATTRIBUTE10,			ATTRIBUTE11,				ATTRIBUTE12,			' + CHAR(10);
			SET @Query = @Query + '		ATTRIBUTE13,		ATTRIBUTE14,			ATTRIBUTE15,				ATTRIBUTE16,			' + CHAR(10);
			SET @Query = @Query + '		ATTRIBUTE17,		ATTRIBUTE18,			ATTRIBUTE19,				ATTRIBUTE20,			' + CHAR(10);
			SET @Query = @Query + '		ATTRIBUTE21,		ATTRIBUTE22,			ATTRIBUTE23,				ATTRIBUTE24,			' + CHAR(10);
			SET @Query = @Query + '		ATTRIBUTE25,		ATTRIBUTE26,			ATTRIBUTE27,				ATTRIBUTE28,			' + CHAR(10);
			SET @Query = @Query + '		ATTRIBUTE29,        ATTRIBUTE30,            ATTRIBUTE31,                ATTRIBUTE32             ' + CHAR(10);
			SET @Query = @Query + ' ) ' + CHAR(10);
			SET @Query = @Query + ' VALUES ' + CHAR(10);
			SET @Query = @Query + ' ( ' + CHAR(10);
			SET @Query = @Query + '		' + CONVERT(NVARCHAR(100), NEXT VALUE FOR SEQ1_SCM_ADM_EXCEL_UPLOAD) + ', ' + CHAR(10);
			SET @Query = @Query + '		''' + @v_program_id + ''', ''' + @v_sheet_name + ''', ''ERROR'', ' + CHAR(10);
			SET @Query = @Query + '		''' + @p_user_id + ''', CONVERT(DATETIME, ''' + CONVERT(NVARCHAR(50), @v_working_time) + '''), ''' + @p_user_id + ''', ''' + CONVERT(NVARCHAR(50), @v_working_time) + ''', ' + CHAR(10);
			SET @Query = @Query + '		''' + @v_route_id + ''', ''' + @p_lt_type + ''', ''' + @p_from_country + ''', ''' + @p_from_city + ''', ''' + @v_transport_mode + ''',' + CHAR(10);
			SET @Query = @Query + '		''' + @p_priority + ''', ''' + @v_days_mon + ''', ''' + @v_days_tue + ''', ''' + @v_days_wed + ''', ''' + @v_days_thu + ''',' + CHAR(10);
			SET @Query = @Query + '		''' + @v_days_fri + ''', ''' + @v_days_sat + ''', ''' + @v_days_sun + ''', ''' + @p_d_port_name + ''', ''' + @p_d_country + ''',' + CHAR(10);
			SET @Query = @Query + '		''' + @p_d_port_code + ''', ''' + @p_a_port_name + ''', ''' + @p_a_country + ''', ''' + @p_a_port_code + ''', ''' + @p_shipping_company + ''',' + CHAR(10);
			SET @Query = @Query + '		''' + @p_to_country + ''', ''' + @p_to_city + ''', ''' + @p_ship_doc_preparation_date + ''', ''' + @p_lt_departure_inland + ''',' + CHAR(10);
			SET @Query = @Query + '		''' + @p_lt_wait_shipping + ''', ''' + @p_lt_voyage + ''', ''' + @p_lt_lay_off_clearance + ''', ''' + @p_lt_arrival_inland + ''',' + CHAR(10);
			SET @Query = @Query + '		''' + @p_valid_yn + ''', ''' + @p_OneSegmentCost + ''', ''' + @p_TwoSegmentCost + ''', ''' + @p_ThreeSegmentCost + '''' + CHAR(10);
			SET @Query = @Query + ' ) ' + CHAR(10);

			EXEC(@Query);

			SELECT 'F' AS result_code;

			IF( @v_err_code IS NULL OR @v_err_code ='')
				SET @v_err_code= ERROR_NUMBER() ;
			IF( @v_err_message IS NULL OR @v_err_message ='') 
				SET @v_err_message=  ERROR_MESSAGE();
			   		
			-- error코드, errror 메시지 반환
			SELECT  @v_err_code			AS err_code
					,@v_err_message		AS err_message
			; 

		END
	END CATCH;
			  
END;	

