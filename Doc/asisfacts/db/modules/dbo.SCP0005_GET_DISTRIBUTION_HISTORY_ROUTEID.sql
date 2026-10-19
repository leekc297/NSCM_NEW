/*
 * Program ID   : [SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID]
 * Description  : Distribution Route ID 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2023/09/02   vadabi3		Initial Release 
------------------------------------------------------------------------------------------------------
  EXEC SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID '1599'
 */
CREATE PROCEDURE [dbo].[SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID]
 (
	 @p_route_id  	NVARCHAR(MAX)
 )
AS
BEGIN
	
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;	
	SET NOCOUNT ON;		 


	SELECT route_id
	       ,from_country
	       ,from_city
		  ,(SELECT CITY_NAME FROM SCM_MST_CITY WHERE COUNTRY = from_country AND CITY =from_city) AS from_city_name
		  ,transport_mode as transport_mode
		  ,dbo.FN_GET_LOOKUP_CODE_DESC ('TRANSPORT_MODE_CODE' , transport_mode ) AS transport_mode_name 
		  ,priority
		  ,days_mon
		  ,days_tue
		  ,days_wed
		  ,days_thu
		  ,days_fri
		  ,days_sat
		  ,days_sun
	      ,case 
		  when len(days) >3 then left(days,len(days)-1) 
		  else days 
		  end as days
		  ,d_country
		  ,d_port_code
		  ,d_port_name
		  ,a_country
		  ,a_port_code
		  ,a_port_name
		  ,shipping_company
		  ,to_country,to_city
		  ,(SELECT CITY_NAME FROM SCM_MST_CITY WHERE COUNTRY = to_country AND CITY =to_city) AS to_city_name
		  ,ship_doc_preparation_date
		  ,lt_departure_inland
		  ,lt_wait_shipping
		  ,lt_voyage
		  ,lt_lay_off_clearance
		  ,lt_arrival_inland
		  ,lt_sum,valid_yn
		  ,t.created_by
		  ,t.creation_date
		  ,t.last_updated_by
		  ,t.last_update_date
		 -- ,t.lt_type
		  ,t.ATTRIBUTE1 AS One_SEGMENT_COST--
		  ,t.ATTRIBUTE2 AS Two_SEGMENT_COST--
		  ,t.ATTRIBUTE3 AS Three_SEGMENT_COST--

	  FROM(
			
			SELECT 
			    HISTORY_SEQ
				, ROUTE_ID
				, FROM_COUNTRY
				, FROM_CITY
				, TRANSPORT_MODE
				, PRIORITY
				, DAYS_MON
				, DAYS_TUE
				, DAYS_WED
				, DAYS_THU
				, DAYS_FRI
				, DAYS_SAT
				, DAYS_SUN

				 ,(CASE WHEN ISNULL(a.days_mon,'') ='Y' THEN 'Mon, ' ELSE '' END )+
				  (CASE WHEN ISNULL(a.days_tue,'') ='Y' THEN 'Tue, ' ELSE '' END )+
				  (CASE WHEN ISNULL(a.days_wed,'') ='Y' THEN 'Wed, ' ELSE '' END )+
				  (CASE WHEN ISNULL(a.days_thu,'') ='Y' THEN 'Thu, ' ELSE '' END )+
				  (CASE WHEN ISNULL(a.days_fri,'') ='Y' THEN 'Fri, ' ELSE '' END )+
				  (CASE WHEN ISNULL(a.days_sat,'') ='Y' THEN 'Sat, ' ELSE '' END )+
				  (CASE WHEN ISNULL(a.days_sun,'') ='Y' THEN 'Sun, ' ELSE '' END ) AS days		


				, D_COUNTRY
				, D_PORT_CODE
				, D_PORT_NAME
				, A_COUNTRY
				, A_PORT_CODE
				, A_PORT_NAME
				, SHIPPING_COMPANY
				, TO_COUNTRY
				, TO_CITY
				, SHIP_DOC_PREPARATION_DATE
				, LT_DEPARTURE_INLAND
				, LT_WAIT_SHIPPING
				, LT_VOYAGE
				, LT_LAY_OFF_CLEARANCE
				, LT_ARRIVAL_INLAND
				 ,ISNULL(a.lt_departure_inland,0)+ISNULL(a.lt_wait_shipping,0)+ISNULL(a.lt_voyage,0)+ISNULL(a.lt_lay_off_clearance,0)+ISNULL(a.lt_arrival_inland,0) AS lt_sum

				, VALID_YN
				, CREATED_BY
				, CREATION_DATE
				, LAST_UPDATED_BY
				, LAST_UPDATE_DATE
				, ATTRIBUTE1
				, ATTRIBUTE2
				, ATTRIBUTE3
				, ATTRIBUTE4
				, ATTRIBUTE5
				, ATTRIBUTE6
				, ATTRIBUTE7
				, ATTRIBUTE8
				, ATTRIBUTE9
				, ATTRIBUTE10
				, HISTORY_CREATION_DATE

			FROM   dbo.SCP_MST_DISTRIBUTION_ROUTE_H a
			WHERE 1=1
              AND  a.route_id = @p_route_id
	  ) T
	  WHERE 1=1
	  ORDER BY from_country,from_city, TO_COUNTRY, TO_CITY, PRIORITY





END

