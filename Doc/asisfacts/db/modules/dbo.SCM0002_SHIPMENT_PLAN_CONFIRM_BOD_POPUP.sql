

/*
 * Program ID   : SCM0002_SHIPMENT_PLAN_CONFIRM_BOD_POPUP
 * Description  : Shipment Plan Confrim Detail
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/06/12   ygkim   Initial Release [PJ20182279] 전지본부 출하계획 시스템 구축 프로젝트
 * 2018/08/06   ygkim	Lead Time 관련 컬럼 추가

 */

CREATE PROCEDURE [dbo].[SCM0002_SHIPMENT_PLAN_CONFIRM_BOD_POPUP]
	 @p_division_id			NVARCHAR(MAX)
	,@p_bod					NVARCHAR(MAX)


AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SELECT B.BOD_ID
		,B.DIVISION_ID 
		,B.FROM_SITE
		,(SELECT CITY_NAME FROM SCM_MST_CITY C WITH(NOLOCK) WHERE C.COUNTRY = D.FROM_COUNTRY AND C.CITY =D.FROM_CITY) AS FROM_CITY_NAME 
		,D.FROM_COUNTRY
		,D.FROM_CITY
		,B.TO_SITE 
		,(SELECT CITY_NAME FROM SCM_MST_CITY C WITH(NOLOCK) WHERE C.COUNTRY = D.TO_COUNTRY AND C.CITY = D.TO_CITY) AS TO_CITY_NAME 
		,D.TO_COUNTRY
		,D.TO_CITY 
		,B.TRANSPORT_MODE
		,B.LT_TOTAL
		,D.D_PORT_NAME
		,B.D_COUNTRY
		,B.D_PORT_CODE
		,D.A_PORT_NAME
		,B.A_COUNTRY
		,B.A_PORT_CODE
		,B.DAYS_MON
		,B.DAYS_TUE
		,B.DAYS_WED
		,B.DAYS_THU
		,B.DAYS_FRI
		,B.DAYS_SAT
		,B.DAYS_SUN
		,B.lt_departure_inland
		,B.lt_wait_shipping
		,B.lt_voyage
		,B.lt_lay_off_clearance
		,B.lt_arrival_inland
		,ISNULL(B.lt_departure_inland,0)+ISNULL(B.lt_wait_shipping,0)+ISNULL(B.lt_voyage,0)+ISNULL(B.lt_lay_off_clearance,0)+ISNULL(B.lt_arrival_inland,0) AS lt_sum
	FROM SCP_MST_BOD_V B WITH(NOLOCK)
	   JOIN  SCP_MST_DISTRIBUTION_ROUTE D WITH(NOLOCK) 
		 ON  D.ROUTE_ID = B.ROUTE_ID
	WHERE 1=1
	AND  B.DIVISION_ID = @p_division_id
	AND  B.BOD_ID = @p_bod
	AND  B.BOD_VALID_YN = 'Y'
	AND  B.ROUTE_VALID_YN = 'Y'
END

