/*
 * Program ID   : PR_SCP_MST_DISTRIBUTION_ROUTE_HIST
 * Description  : Distribution Route Master History 
 * Program History
 *===================================================================================================
 *   Date       In Charge			Description
 *===================================================================================================
 * 2018.03.12   byunghunjung		Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2019.02.12	hwyoon				[CSR ID:3907873] SSP Distribution route/BOD상 'L/T TYPE'컬럼 추가요청
 * 
 */
CREATE PROCEDURE [dbo].[PR_SCP_MST_DISTRIBUTION_ROUTE_HIST]

@p_route_id						NVARCHAR(MAX),
@p_from_country					NVARCHAR(MAX),
@p_from_city					NVARCHAR(MAX),
@p_from_city_name				NVARCHAR(MAX),
@p_transport_mode				NVARCHAR(MAX),
@p_priority						NVARCHAR(MAX),
@p_days_mon						NVARCHAR(MAX),
@p_days_tue						NVARCHAR(MAX),
@p_days_wed						NVARCHAR(MAX),
@p_days_thu						NVARCHAR(MAX),
@p_days_fri						NVARCHAR(MAX),
@p_days_sat						NVARCHAR(MAX),
@p_days_sun						NVARCHAR(MAX),
@p_d_country					NVARCHAR(MAX),
@p_d_port_code					NVARCHAR(MAX),
@p_d_port_name					NVARCHAR(MAX),
@p_a_country					NVARCHAR(MAX),
@p_a_port_code					NVARCHAR(MAX),
@p_a_port_name					NVARCHAR(MAX),
@p_shipping_company				NVARCHAR(MAX),
@p_to_country					NVARCHAR(MAX),
@p_to_city						NVARCHAR(MAX),
@p_to_city_name					NVARCHAR(MAX),
@p_ship_doc_preparation_date	NVARCHAR(MAX),
@p_lt_departure_inland			NVARCHAR(MAX),
@p_lt_wait_shipping				NVARCHAR(MAX),
@p_lt_voyage				    NVARCHAR(MAX),
@p_lt_lay_off_clearance			NVARCHAR(MAX),
@p_lt_arrival_inland			NVARCHAR(MAX),
@p_valid_yn						NVARCHAR(MAX),
@p_created_by					NVARCHAR(MAX),
@p_creation_date				DATETIME,
@p_last_updated_by				NVARCHAR(MAX),
@p_lt_type						NVARCHAR(MAX),

@p_OneSegmentCost			    NVARCHAR(MAX),--
@p_TwoSegmentCost				NVARCHAR(MAX),--
@p_ThreeSegmentCost				NVARCHAR(MAX)--

AS

BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

	DECLARE @n_history_seq	INTEGER;
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_MST_DISTRIBUTION_ROUTE_HIST';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

			  
	SET @n_history_seq = NEXT VALUE FOR SEQ1_SCP_MST_DISTRIBUTION_ROUTE_H
				   
	INSERT	INTO  SCP_MST_DISTRIBUTION_ROUTE_H(									   
					history_seq,route_id,from_country,from_city
					--,from_city_name
					,transport_mode,priority
					,days_mon,days_tue,days_wed,days_thu,days_fri,days_sat,days_sun
					,d_country,d_port_code,d_port_name,a_country,a_port_code,a_port_name,shipping_company
					,to_country,to_city
					--,to_city_name
					,ship_doc_preparation_date
					,lt_departure_inland,lt_wait_shipping,lt_voyage,lt_lay_off_clearance,lt_arrival_inland,VALID_YN
					, created_by,creation_date,last_updated_by,last_update_date, history_creation_date, lt_type,
					ATTRIBUTE1, --
					ATTRIBUTE2, --
					ATTRIBUTE3--
					)
	VALUES  
				(
					@n_history_seq, @p_route_id,@p_from_country,@p_from_city
					--,@p_from_city_name
					,@p_transport_mode,@p_priority
					,@p_days_mon,@p_days_tue,@p_days_wed,@p_days_thu,@p_days_fri,@p_days_sat,@p_days_sun
					,@p_d_country,@p_d_port_code,@p_d_port_name,@p_a_country,@p_a_port_code,@p_a_port_name,@p_shipping_company
					,@p_to_country,@p_to_city
					--,@p_to_city_name
					,@p_ship_doc_preparation_date
				, @p_lt_departure_inland,@p_lt_wait_shipping,@p_lt_voyage,@p_lt_lay_off_clearance,@p_lt_arrival_inland,@p_valid_yn
				, @p_created_by,@p_creation_date,@p_last_updated_by,SYSDATETIME(),SYSDATETIME(), @p_lt_type,
				@p_OneSegmentCost,--
				@p_TwoSegmentCost,--
				@p_ThreeSegmentCost--
				);
				
			

		
	END;





