


CREATE VIEW [dbo].[SCP_MST_BOD_DW_V] AS
/*
 * Program ID   : SCP_MST_BOD_DW_V
 * Description  : BOD : DW용
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2022.04.28   KSG            Initial Release : PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 : GM JV
 * 2023.04.04   HRK			   PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 대응
 * 
 */

  SELECT -- PJ20230691R HM JV 대응  CASE WHEN DIVISION_ID = '81_UC' THEN '81' ELSE DIVISION_ID END AS DIVISION_ID
	     D.ATTRIBUTE3 AS DIVISION_ID	-- PJ20230691R HM JV 가상 사업부 추가 대응
       , B.BOD_ID
       , B.BOD_TYPE
       , B.FROM_SITE
       , B.D_COUNTRY
       , B.D_PORT_CODE
       , B.A_COUNTRY
       , B.A_PORT_CODE
       , B.TO_COUNTRY
       , B.TO_CITY
       , B.HUB_SLOC
       , B.TO_SITE
       , B.INCOTERMS
       , B.SSP_INCOTERMS
       , B.TRANSPORT_MODE
       , B.ROUTE_ID
       , B.PRIORITY
       , B.DAYS_MON
       , B.DAYS_TUE
       , B.DAYS_WED
       , B.DAYS_THU
       , B.DAYS_FRI
       , B.DAYS_SAT
       , B.DAYS_SUN
       , B.SAFETY_STOCK
       , B.LT_DEPARTURE_INLAND
       , B.LT_WAIT_SHIPPING
       , B.LT_VOYAGE
       , B.LT_LAY_OFF_CLEARANCE
       , B.LT_ARRIVAL_INLAND
       , B.LT_TOTAL
       , B.SHIP_LT_TOTAL
       , B.BOD_VALID_YN
       , B.ROUTE_VALID_YN
       , B.LT_TYPE
       , B.LT_TOTAL_ORIGIN
       , B.SHIP_LT_TOTAL_ORIGIN
       , B.LT_TOTAL_SSP
       , B.SHIP_LT_TOTAL_SSP
       , B.BEFORE_LT
       , B.AFTER_LT
       , B.ORG_LT_TOTAL
       , B.ORG_SHIP_LT_TOTAL
       , B.ORG_LT_TOTAL_SSP
       , B.ADD_AFTER_LT_TOTAL
       , B.SEGMENT3
       , B.SSP_SEGMENT3
       , B.FROM_YYYYMMDD
       , B.TO_YYYYMMDD
	   , B.DIVISION_ID AS SCM_DIVISION_ID
  FROM   SCP_MST_BOD_V B WITH(NOLOCK)
		 INNER JOIN SCM_MST_DIVISION D WITH(NOLOCK)  -- PJ20230691R HM JV 가상 사업부 추가 대응
				 ON D.DIVISION_ID = B.DIVISION_ID 
				AND D.VALID_YN	  = 'Y'
  ;

