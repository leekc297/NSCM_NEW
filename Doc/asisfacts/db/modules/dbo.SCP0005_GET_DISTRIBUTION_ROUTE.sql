/*
 * Program ID   : [SCP0005_GET_DISTRIBUTION_ROUTE]
 * Description  : Distribution Route 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/03/07   PJS		Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
   2018/04/05   PJS		소문자 입력시 대문자로 변환하여 조회, 도시코드 LIKE 검색기능 추가
   2018/06/14   PJS		transport_mode 코드명 조회로 변경
   2018/06/14   PJS		transport_mode,transport_mode_name  코드, 코드명 조회로 명칭 분리
   2019/02/12	YHW		[CSR ID:3907873] SSP Distribution route/BOD상 'L/T TYPE'컬럼 추가요청

 * 실행예제)
  EXEC SCP0005_GET_DISTRIBUTION_ROUTE @p_from_country='',@p_from_city='KR',@p_to_country='', @p_to_city='', @p_transport_mode='',@p_valid_yn=''
 */
CREATE PROCEDURE [dbo].[SCP0005_GET_DISTRIBUTION_ROUTE]
 (
	 @p_from_country  	NVARCHAR(MAX)
  	,@p_from_city		NVARCHAR(MAX)  
	,@p_to_country		NVARCHAR(MAX)
	,@p_to_city			NVARCHAR(MAX)
	,@p_transport_mode	NVARCHAR(MAX)		
	,@p_valid_yn    	NVARCHAR(1)
 )
AS
BEGIN
	
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;	
	SET NOCOUNT ON;		 

	-- Distribution Route확인
	SELECT route_id,from_country,from_city
		  ,(SELECT CITY_NAME FROM SCM_MST_CITY WHERE COUNTRY = from_country AND CITY =from_city) AS from_city_name
		  --,transport_mode as transport_mode_code
		  ,transport_mode as transport_mode
		  ,dbo.FN_GET_LOOKUP_CODE_DESC ('TRANSPORT_MODE_CODE' , transport_mode ) AS transport_mode_name 
		  ,priority,days_mon,days_tue,days_wed,days_thu,days_fri,days_sat,days_sun
	      ,case when len(days) >3 then left(days,len(days)-1) else days end as days
		  ,d_country,d_port_code,d_port_name,a_country,a_port_code,a_port_name,shipping_company,to_country,to_city
		  ,(SELECT CITY_NAME FROM SCM_MST_CITY WHERE COUNTRY = to_country AND CITY =to_city) AS to_city_name
		  ,ship_doc_preparation_date,lt_departure_inland,lt_wait_shipping,lt_voyage,lt_lay_off_clearance,lt_arrival_inland
		  ,lt_sum,valid_yn
		  ,t.created_by
		  ,t.creation_date
		  ,t.last_updated_by
		  ,t.last_update_date
		  ,t.lt_type
		  ,t.ATTRIBUTE1 AS One_SEGMENT_COST--
		 ,t.ATTRIBUTE2 AS Two_SEGMENT_COST--
		  ,t.ATTRIBUTE3 AS Three_SEGMENT_COST--
	  FROM(
			SELECT a.route_id
				 ,a.from_country
				 ,a.from_city
				 ,a.transport_mode
				 ,a.priority
				 ,a.days_mon
				 ,a.days_tue
				 ,a.days_wed
				 ,a.days_thu
				 ,a.days_fri
				 ,a.days_sat
				 ,a.days_sun
				 ,(CASE WHEN ISNULL(a.days_mon,'') ='Y' THEN 'Mon, ' ELSE '' END )+
				  (CASE WHEN ISNULL(a.days_tue,'') ='Y' THEN 'Tue, ' ELSE '' END )+
				  (CASE WHEN ISNULL(a.days_wed,'') ='Y' THEN 'Wed, ' ELSE '' END )+
				  (CASE WHEN ISNULL(a.days_thu,'') ='Y' THEN 'Thu, ' ELSE '' END )+
				  (CASE WHEN ISNULL(a.days_fri,'') ='Y' THEN 'Fri, ' ELSE '' END )+
				  (CASE WHEN ISNULL(a.days_sat,'') ='Y' THEN 'Sat, ' ELSE '' END )+
				  (CASE WHEN ISNULL(a.days_sun,'') ='Y' THEN 'Sun, ' ELSE '' END ) AS days		 
				 ,a.d_country
				 ,a.d_port_code
				 ,a.d_port_name
				 ,a.a_country
				 ,a.a_port_code
				 ,a.a_port_name
				 ,a.shipping_company
				 ,a.to_country
				 ,a.to_city
				 --,a.to_city_name
				 ,a.ship_doc_preparation_date
				 ,a.lt_departure_inland
				 ,a.lt_wait_shipping
				 ,a.lt_voyage
				 ,a.lt_lay_off_clearance
				 ,a.lt_arrival_inland
				 ,ISNULL(a.lt_departure_inland,0)+ISNULL(a.lt_wait_shipping,0)+ISNULL(a.lt_voyage,0)+ISNULL(a.lt_lay_off_clearance,0)+ISNULL(a.lt_arrival_inland,0) AS lt_sum
				 , a.valid_yn
				 ,a.created_by
				 ,a.creation_date
				 ,a.last_updated_by
				 ,a.last_update_date
				 ,a.lt_type
				 ,a.ATTRIBUTE1--
			     ,a.ATTRIBUTE2--
		    	 ,a.ATTRIBUTE3 --
			FROM   dbo.SCP_MST_DISTRIBUTION_ROUTE a
			WHERE 1=1
			  AND ( ( @p_transport_mode IS NULL OR @p_transport_mode ='' ) OR a.transport_mode IN (SELECT token FROM dbo.String_Split(@p_transport_mode,',')) )
			  AND ( ( @p_valid_yn IS NULL OR @p_valid_yn ='' ) OR a.valid_yn = @p_valid_yn)
	  ) T
	  WHERE 1=1
			  AND ( ( @p_from_country IS NULL OR @p_from_country ='' ) OR T.from_country = UPPER(@p_from_country) )
			  AND ( ( @p_from_city    IS NULL OR @p_from_city    ='' ) OR T.from_city    LIKE  UPPER(@p_from_city) +'%')
			  AND ( ( @p_to_country   IS NULL OR @p_to_country   ='' ) OR T.to_country   = UPPER(@p_to_country) )
			  AND ( ( @p_to_city      IS NULL OR @p_to_city      ='' ) OR T.to_city      LIKE  UPPER(@p_to_city) +'%')
	  ORDER BY from_country,from_city, TO_COUNTRY, TO_CITY, PRIORITY
END

