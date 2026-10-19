

/*
 * Program ID   : SSP0028_GET_DELIVERY_TRACKING_LT
 * Description  : Delivery Tracking LT
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2022/09/13   PARKTAEHAK		신규추가
 * 2023-08-09   vadabi3         BOD Validation Report) UI 개선 
 * 2023/08/23   vadabi3		    개발DB 이슈로 백업본으로 복구
*/

CREATE PROCEDURE [dbo].[SSP0028_GET_DELIVERY_TRACKING_LT]

    @p_division_id      NVARCHAR(10),
	@p_from_yyyymmdd  NVARCHAR(8),
    @p_to_yyyymmdd    NVARCHAR(8),	
	@p_from_site      NVARCHAR(MAX),
	@p_to_site      NVARCHAR(MAX),
	@p_PIVOT_yyyymm    NVARCHAR(MAX),
	@p_from_country      NVARCHAR(MAX),
	@p_to_country      NVARCHAR(MAX),
	@p_from_city      NVARCHAR(MAX),
	@p_to_city      NVARCHAR(MAX),
	@p_from_area      NVARCHAR(MAX),
	@p_to_area      NVARCHAR(MAX)
AS
BEGIN

  SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @mDQry1 NVARCHAR(MAX)='';
	DECLARE @mDQry2 NVARCHAR(MAX)='';
	DECLARE @mDqry3 NVARCHAR(MAX)='';	
	DECLARE @mDqry4 NVARCHAR(MAX)='';	
	
	DECLARE  @v_from_site NVARCHAR(MAX)='';
	DECLARE  @v_to_site NVARCHAR(MAX)='';	
	DECLARE  @v_from_country NVARCHAR(MAX)='';
	DECLARE  @v_to_country NVARCHAR(MAX)='';	
	DECLARE  @v_from_city NVARCHAR(MAX)='';
	DECLARE  @v_to_city NVARCHAR(MAX)='';	

	--IN 조건으로 데이터를 가져옴
	SET @v_from_site = [dbo].FN_GET_IN_STR(@p_from_site);
	SET @v_to_site = [dbo].FN_GET_IN_STR(@p_to_site);	
	SET @v_from_country = [dbo].FN_GET_IN_STR(@p_from_country);
	SET @v_to_country = [dbo].FN_GET_IN_STR(@p_to_country);	
	SET @v_from_city = [dbo].FN_GET_IN_STR(@p_from_city);
	SET @v_to_city = [dbo].FN_GET_IN_STR(@p_to_city);	

	SET @mDqry1 = @mDQry1 + ' WITH LD AS (																																					' + char(10);
	SET @mDqry1 = @mDQry1 + '			SELECT E.DIVISION_ID 																																' + char(10);
	SET @mDqry1 = @mDqry1 + '				  ,T.COMPANY_ID  																																' + char(10);
	SET @mDqry1 = @mDqry1 + '				  ,B.FROM_SITE 																																	' + char(10);
	SET @mDqry1 = @mDqry1 + '				  ,B.TO_SITE 																																	' + char(10);
	SET @mDqry1 = @mDqry1 + '				  ,T.SHIPMENT_NO 																																' + char(10);
	SET @mDqry1 = @mDqry1 + '				  ,D.D_PORT_CODE  																																' + char(10);
	SET @mDqry1 = @mDqry1 + '				  ,D.A_PORT_CODE  																																' + char(10);
	SET @mDqry1 = @mDqry1 + '				  ,D.FROM_CITY 																																	' + char(10);
	SET @mDqry1 = @mDqry1 + '				  ,D.TO_CITY 																																	' + char(10);
	SET @mDqry1 = @mDqry1 + '				  ,D.TRANSPORT_MODE			 																													' + char(10);		
	SET @mDqry1 = @mDqry1 + '				  ,substring(E.EXFACTORY_DATE,0,7) as Y_YEAR -- ,E.EXFACTORY_DATE																				' + char(10);	
	SET @mDqry1 = @mDqry1 + '				  ,E.EXFACTORY_DATE																																 ' + char(10);
	SET @mDqry1 = @mDqry1 + '				  ,B.BOD_ID  ' + char(10);
	SET @mDqry1 = @mDqry1 + '				  ,B.ROUTE_ID  ' + char(10);
	SET @mDqry1 = @mDqry1 + '			      --,B.INCOTERMS  ' + char(10);
	SET @mDqry1 = @mDqry1 + '				  ,B.ATTRIBUTE1 AS SSP_INCOTERMS ' + char(10);
	SET @mDqry1 = @mDqry1 + '				  ,T.CARRIER  ' + char(10);
	SET @mDqry1 = @mDqry1 + '				  ,S.VMI_YN ' + char(10);
	SET @mDqry1 = @mDqry1 + '				  ,T.INLAND_ATD ' + char(10);
	SET @mDqry1 = @mDqry1 + '				  ,T.POL_ATA ' + char(10);
	SET @mDqry1 = @mDqry1 + '				  ,T.POL_ATD ' + char(10);
	SET @mDqry1 = @mDqry1 + '				  ,T.POD_ATA ' + char(10);
	SET @mDqry1 = @mDqry1 + '				  ,T.POD_ATD ' + char(10);
	SET @mDqry1 = @mDqry1 + '				  ,T.VMI_ATA ' + char(10);
	SET @mDqry1 = @mDqry1 + '				  ,T.VMI_ATD ' + char(10);
	SET @mDqry1 = @mDqry1 + '				  ,T.F_DEST_ATA ' + char(10);
	SET @mDqry1 = @mDqry1 + '				  ,D.LT_DEPARTURE_INLAND	AS NDR1  --기준L/T 1 (조회시점)   --기준L/T(현재시점) ' + char(10);
	SET @mDqry1 = @mDqry1 + '				  ,D.LT_WAIT_SHIPPING		AS NDR2  --기준L/T 2 (조회시점) ' + char(10);
	SET @mDqry1 = @mDqry1 + '				  ,D.LT_VOYAGE				AS NDR3  --기준L/T 3 (조회시점) ' + char(10);
	SET @mDqry1 = @mDqry1 + '				  ,D.LT_LAY_OFF_CLEARANCE	AS NDR4  --기준L/T 4 (조회시점) ' + char(10);
	SET @mDqry1 = @mDqry1 + '				  ,D.LT_ARRIVAL_INLAND		AS NDR5  --기준L/T 5 (조회시점)     ' + char(10);
	SET @mDqry1 = @mDqry1 + '				  ,E.LT_DEPARTURE_INLAND	AS DR1   --기준L/T 1 (계획시점)   --기준L/T(과거계획평균) ' + char(10);
	SET @mDqry1 = @mDqry1 + '				  ,E.LT_WAIT_SHIPPING		AS DR2   --기준L/T 2 (계획시점) ' + char(10);
	SET @mDqry1 = @mDqry1 + '				  ,E.LT_VOYAGE				AS DR3   --기준L/T 3 (계획시점) ' + char(10);
	SET @mDqry1 = @mDqry1 + '				  ,E.LT_LAY_OFF_CLEARANCE	AS DR4   --기준L/T 4 (계획시점) ' + char(10);
	SET @mDqry1 = @mDqry1 + '				  ,E.LT_ARRIVAL_INLAND		AS DR5   --기준L/T 5 (계획시점) ' + char(10);
	SET @mDqry1 = @mDqry1 + '				  ,CASE WHEN ISDATE(T.INLAND_ATD) = 1	AND ISDATE(T.POL_ATA) = 1 THEN CONVERT(nvarchar, DATEDIFF(DD, T.INLAND_ATD, T.POL_ATA)) ELSE NULL END AS TTL1 ' + char(10);
	SET @mDqry1 = @mDqry1 + '				  ,CASE WHEN ISDATE(T.POL_ATA) = 1		AND ISDATE(T.POL_ATD) = 1 THEN CONVERT(nvarchar, DATEDIFF(DD, T.POL_ATA, T.POL_ATD))	ELSE NULL END AS TTL2 ' + char(10);
	SET @mDqry1 = @mDqry1 + '				  ,CASE WHEN ISDATE(T.POL_ATD) = 1		AND ISDATE(T.POD_ATA) = 1 THEN CONVERT(nvarchar, DATEDIFF(DD, T.POL_ATD, T.POD_ATA))	ELSE NULL END AS TTL3 ' + char(10);
	SET @mDqry1 = @mDqry1 + '				  ,CASE WHEN ISDATE(T.POD_ATA) = 1		AND ISDATE(T.POD_ATD) = 1 THEN CONVERT(nvarchar, DATEDIFF(DD, T.POD_ATA, T.POD_ATD))	ELSE NULL END AS TTL4 ' + char(10);
	SET @mDqry1 = @mDqry1 + '				  ,CASE WHEN ISDATE(T.POD_ATD) = 1		AND IIF(S.VMI_YN = ''Y'', ISDATE(T.VMI_ATA), ISDATE(T.F_DEST_ATA))  = 1  ' + char(10);
	SET @mDqry1 = @mDqry1 + '						THEN CONVERT(nvarchar, DATEDIFF(DD, T.POD_ATD, IIF(S.VMI_YN = ''Y'', T.VMI_ATA, T.F_DEST_ATA))) ' + char(10);
	SET @mDqry1 = @mDqry1 + '						ELSE NULL END AS TTL5 ' + char(10);
	SET @mDqry1 = @mDqry1 + '				  ,E.CONFIRM_ID ' + char(10);

	SET @mDqry1 = @mDqry1 + '				  ,FR.ATTRIBUTE1 AS POL_AREA ' + char(10);-----------------------------
	SET @mDqry1 = @mDqry1 + '				  ,TZ.ATTRIBUTE1 AS POD_AREA  ' + char(10);----------------------------

	SET @mDqry1 = @mDqry1 + '			  FROM SSP_DNM_DELIVERY_TRACKING_V AS T ' + char(10);
	SET @mDqry1 = @mDqry1 + '				   JOIN ( ' + char(10);
	SET @mDqry1 = @mDqry1 + '						SELECT CN.DIVISION_ID ' + char(10);
	SET @mDqry1 = @mDqry1 + '							  ,CN.FROM_SITE_COMPANY_ID AS COMPANY_ID ' + char(10);
	SET @mDqry1 = @mDqry1 + '							  ,EX.SHIPMENT_NO ' + char(10);
	SET @mDqry1 = @mDqry1 + '							  ,CN.CONFIRM_ID ' + char(10);
	SET @mDqry1 = @mDqry1 + '							  ,CN.BOD_ID ' + char(10);
	SET @mDqry1 = @mDqry1 + '							  ,CN.ITEM_ID ' + char(10);
	SET @mDqry1 = @mDqry1 + '							  ,EX.EXFACTORY_DATE ' + char(10);
	SET @mDqry1 = @mDqry1 + '							  ,RT.LT_DEPARTURE_INLAND ' + char(10);
	SET @mDqry1 = @mDqry1 + '							  ,RT.LT_WAIT_SHIPPING ' + char(10);
	SET @mDqry1 = @mDqry1 + '							  ,RT.LT_VOYAGE ' + char(10);
	SET @mDqry1 = @mDqry1 + '							  ,RT.LT_LAY_OFF_CLEARANCE ' + char(10);
	SET @mDqry1 = @mDqry1 + '							  ,RT.LT_ARRIVAL_INLAND ' + char(10);
	SET @mDqry1 = @mDqry1 + '						  FROM ( ' + char(10);
	SET @mDqry1 = @mDqry1 + '							   SELECT X.ATTRIBUTE3 AS SHIPMENT_NO ' + char(10);
	SET @mDqry1 = @mDqry1 + '									 ,MAX(X.CONFIRM_ID) AS CONFIRM_ID  ' + char(10);---------------
	SET @mDqry1 = @mDqry1 + '									 ,MAX(SYSTEM_EXFACTORY_DATE) AS EXFACTORY_DATE ' + char(10);
	SET @mDqry1 = @mDqry1 + '								 FROM SCM_DNM_EXFACTORY_RESULT AS X WITH(NOLOCK) ' + char(10);
	SET @mDqry1 = @mDqry1 + '									  JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK) ' + char(10);
	SET @mDqry1 = @mDqry1 + '								   ON L.LOOKUP_TYPE = ''ERP_SSP_TYPE'' -- LOOKUP에 등록된 공정만  ' + char(10);
	SET @mDqry1 = @mDqry1 + '								  AND L.VALID_YN = ''Y'' ' + char(10);
	SET @mDqry1 = @mDqry1 + '								  AND X.VALID_YN = ''Y'' ' + char(10);
	SET @mDqry1 = @mDqry1 + '								  AND L.SEGMENT1    = X.SSP_TYPE ' + char(10);
	SET @mDqry1 = @mDqry1 + '								WHERE 1 = 1 ' + char(10);
	SET @mDqry1 = @mDqry1 + '								  AND X.ATTRIBUTE3 IS NOT NULL ' + char(10);
	SET @mDqry1 = @mDqry1 + '								  AND X.DIVISION_ID = ''' +@p_division_id + '''                   --@DIVISION ' + char(10);
	SET @mDqry1 = @mDqry1 + '								  AND X.SYSTEM_EXFACTORY_DATE BETWEEN ''' +@p_from_yyyymmdd + '''   AND ''' +@p_to_yyyymmdd + '''  --@기간조건 ' + char(10);
	SET @mDqry1 = @mDqry1 + '								  AND X.EXFACTORY_STATUS NOT IN (''D10'',''D90'') ' + char(10);
	SET @mDqry1 = @mDqry1 + '								  AND X.CONFIRM_ID LIKE ''C%'' ' + char(10);
	SET @mDqry1 = @mDqry1 + '								GROUP BY X.ATTRIBUTE3 ' + char(10);
	SET @mDqry1 = @mDqry1 + '							 ' + char(10);
	SET @mDqry1 = @mDqry1 + '							   ) AS EX ' + char(10);
	SET @mDqry1 = @mDqry1 + '							   JOIN SSP_ANL_SHIP_CONFIRM AS CN  WITH(NOLOCK) ' + char(10);
	SET @mDqry1 = @mDqry1 + '							ON EX.CONFIRM_ID = CN.CONFIRM_ID ' + char(10);
	SET @mDqry1 = @mDqry1 + '							   JOIN SSP_ANL_SHIP_CONFIRM_ROUTE AS RT WITH(NOLOCK) ' + char(10);
	SET @mDqry1 = @mDqry1 + '							ON CN.CONFIRM_ID = RT.CONFIRM_ID ' + char(10);
	SET @mDqry1 = @mDqry1 + '						) AS E ' + char(10);
	print @mDqry1
	SET @mDqry2 = @mDqry2 + '				ON T.COMPANY_ID = E.COMPANY_ID ' + char(10);
	SET @mDqry2 = @mDqry2 + '			   AND T.SHIPMENT_NO = E.SHIPMENT_NO ' + char(10);
	SET @mDqry2 = @mDqry2 + '				   JOIN SCP_MST_BOD AS B  ' + char(10);
	SET @mDqry2 = @mDqry2 + '				ON E.BOD_ID = B.BOD_ID ' + char(10);
	SET @mDqry2 = @mDqry2 + '				   JOIN SCM_MST_SITE AS S ' + char(10);
	SET @mDqry2 = @mDqry2 + '				ON B.division_id = S.DIVISION_ID ' + char(10);
	SET @mDqry2 = @mDqry2 + '			   AND B.to_site = S.SCM_SITE_ID ' + char(10);
	SET @mDqry2 = @mDqry2 + '				   JOIN SCP_MST_DISTRIBUTION_ROUTE AS D ' + char(10);
	SET @mDqry2 = @mDqry2 + '				ON B.ROUTE_ID = D.ROUTE_ID ' + char(10);
	SET @mDqry2 = @mDqry2 + '				   LEFT OUTER JOIN dbo.SCM_MST_PORT AS FR ' + char(10);
	--SET @mDqry = @mDQry + '				ON D.FROM_COUNTRY = FR.COUNTRY' + char(10);-------------------------------
	SET @mDqry2 = @mDqry2 + '				ON D.D_COUNTRY = FR.COUNTRY' + char(10);-------------------------------
	SET @mDqry2 = @mDqry2 + '			   AND D.D_PORT_CODE  = FR.PORT_CODE' + char(10);
	SET @mDqry2 = @mDqry2 + '				   LEFT OUTER JOIN dbo.SCM_MST_PORT AS TZ ----권역정보' + char(10);
	--SET @mDqry = @mDQry + '				ON D.FROM_COUNTRY = TZ.COUNTRY ' + char(10);------------------------------
	SET @mDqry2 = @mDqry2 + '				ON D.A_COUNTRY=TZ.COUNTRY '+ char(10);------------------------------
	SET @mDqry2 = @mDqry2 + '			   AND D.A_PORT_CODE  = TZ.PORT_CODE ' + char(10);
	SET @mDqry2 = @mDqry2 + '			 WHERE 1 = 1 ' + char(10);		
	
	IF ( @v_from_site   IS NOT NULL AND @v_from_site    != '') SET @mDqry2 = @mDqry2 + ' 					AND  B.from_site     IN ('+ @v_from_site   +')    '+char(10); 
	IF ( @v_to_site     IS NOT NULL AND @v_to_site    != '') SET @mDqry2 = @mDqry2 + ' 					AND  B.to_site		 IN ('+ @v_to_site   +')      '+char(10); 
	
	IF ( @p_from_area   IS NOT NULL AND @p_from_area    != '') SET @mDqry2 = @mDqry2 + ' 					AND  FR.ATTRIBUTE1 =N'''+@p_from_area+'''   '+char(10); 
	IF ( @p_to_area     IS NOT NULL AND @p_to_area    != '') SET @mDqry2 = @mDqry2 + ' 					AND  TZ.ATTRIBUTE1	=N'''+@p_to_area+'''    '+char(10); 

	IF ( @v_from_country   IS NOT NULL AND @v_from_country    != '') SET @mDqry2 = @mDqry2 + ' 					AND  D.FROM_COUNTRY     IN ('+ @v_from_country   +')    '+char(10); 
	IF ( @v_to_country     IS NOT NULL AND @v_to_country    != '') SET @mDqry2 = @mDqry2 + ' 					AND  D.TO_COUNTRY		 IN ('+ @v_to_country   +')      '+char(10); 

	IF ( @v_from_city   IS NOT NULL AND @v_from_city    != '') SET @mDqry2 = @mDqry2 + ' 					AND  D.FROM_CITY     IN ('+ @v_from_city   +')    '+char(10); 
	IF ( @v_to_city     IS NOT NULL AND @v_to_city    != '') SET @mDqry2 = @mDqry2 + ' 					AND  D.TO_CITY		 IN ('+ @v_to_city   +')      '+char(10); 

	SET @mDqry2 = @mDqry2 + '			) ' + char(10);	

	print @mDqry2

SET @mDqry3 = @mDqry3 + 'select * from' + char(10);
SET @mDqry3 = @mDqry3 + '(' + char(10);
SET @mDqry3 = @mDqry3 + 'select ' + char(10);
SET @mDqry3 = @mDqry3 + '		     LD.DIVISION_ID' + char(10);
SET @mDqry3 = @mDqry3 + '			,LD.DIVISION_ID AS DIVISIONID' + char(10);
SET @mDqry3 = @mDqry3 + '			,LD.FROM_SITE' + char(10);
SET @mDqry3 = @mDqry3 + '			,LD.TO_SITE' + char(10);
SET @mDqry3 = @mDqry3 + '			,LD.POL_AREA' + char(10);
SET @mDqry3 = @mDqry3 + '			,LD.POD_AREA' + char(10);
SET @mDqry3 = @mDqry3 + '			,LD.D_PORT_CODE' + char(10); 
SET @mDqry3 = @mDqry3 + '			,LD.A_PORT_CODE' + char(10);
SET @mDqry3 = @mDqry3 + '			,LD.FROM_CITY' + char(10);
SET @mDqry3 = @mDqry3 + '			,LD.TO_CITY' + char(10);
SET @mDqry3 = @mDqry3 + '			,LD.TRANSPORT_MODE' + char(10);
SET @mDqry3 = @mDqry3 + '			,LD.BOD_ID' + char(10);
SET @mDqry3 = @mDqry3 + '			,LD.ROUTE_ID' + char(10);
SET @mDqry3 = @mDqry3 + '			,LD.SSP_INCOTERMS' + char(10);
SET @mDqry3 = @mDqry3 + '			,COUNT(LD.SHIPMENT_NO) AS SHIPMENTCOUNT' + char(10);
SET @mDqry3 = @mDqry3 + '' + char(10);
SET @mDqry3 = @mDqry3 + '			,AVG(LD.NDR1) AS NDR1' + char(10);
SET @mDqry3 = @mDqry3 + '			,AVG(LD.NDR2) AS NDR2' + char(10);
SET @mDqry3 = @mDqry3 + '			,AVG(LD.NDR3) AS NDR3' + char(10);
SET @mDqry3 = @mDqry3 + '			,AVG(LD.NDR4) AS NDR4' + char(10);
SET @mDqry3 = @mDqry3 + '			,AVG(LD.NDR5) AS NDR5' + char(10);
SET @mDqry3 = @mDqry3 + '' + char(10);
SET @mDqry3 = @mDqry3 + '			,AVG(LD.DR1) AS DR1' + char(10);
SET @mDqry3 = @mDqry3 + '			,AVG(LD.DR2) AS DR2' + char(10);
SET @mDqry3 = @mDqry3 + '			,AVG(LD.DR3) AS DR3' + char(10);
SET @mDqry3 = @mDqry3 + '			,AVG(LD.DR4) AS DR4' + char(10);
SET @mDqry3 = @mDqry3 + '			,AVG(LD.DR5) AS DR5' + char(10);
SET @mDqry3 = @mDqry3 + '' + char(10);
SET @mDqry3 = @mDqry3 + '			,AVG(convert(decimal,LD.TTL1)) AS TTL1_AVG' + char(10);
SET @mDqry3 = @mDqry3 + '			,MAX(convert(decimal,LD.TTL1)) AS TTL1_MAX' + char(10);
SET @mDqry3 = @mDqry3 + '			,MIN(convert(decimal,LD.TTL1)) AS TTL1_MIN' + char(10);
SET @mDqry3 = @mDqry3 + '' + char(10);
SET @mDqry3 = @mDqry3 + '			,AVG(convert(decimal,LD.TTL2)) AS TTL2_AVG' + char(10);
SET @mDqry3 = @mDqry3 + '			,MAX(convert(decimal,LD.TTL2)) AS TTL2_MAX' + char(10);
SET @mDqry3 = @mDqry3 + '			,MIN(convert(decimal,LD.TTL2)) AS TTL2_MIN' + char(10);
SET @mDqry3 = @mDqry3 + '' + char(10);
SET @mDqry3 = @mDqry3 + '			,AVG(convert(decimal,LD.TTL3)) AS TTL3_AVG' + char(10);
SET @mDqry3 = @mDqry3 + '			,MAX(convert(decimal,LD.TTL3)) AS TTL3_MAX' + char(10);
SET @mDqry3 = @mDqry3 + '			,MIN(convert(decimal,LD.TTL3)) AS TTL3_MIN' + char(10);
SET @mDqry3 = @mDqry3 + '' + char(10);
SET @mDqry3 = @mDqry3 + '			,AVG(convert(decimal,LD.TTL4)) AS TTL4_AVG' + char(10);
SET @mDqry3 = @mDqry3 + '			,MAX(convert(decimal,LD.TTL4)) AS TTL4_MAX' + char(10);
SET @mDqry3 = @mDqry3 + '			,MIN(convert(decimal,LD.TTL4)) AS TTL4_MIN' + char(10);
SET @mDqry3 = @mDqry3 + '' + char(10);
SET @mDqry3 = @mDqry3 + '			,AVG(convert(decimal,LD.TTL5)) AS TTL5_AVG' + char(10);
SET @mDqry3 = @mDqry3 + '			,MAX(convert(decimal,LD.TTL5)) AS TTL5_MAX' + char(10);
SET @mDqry3 = @mDqry3 + '			,MIN(convert(decimal,LD.TTL5)) AS TTL5_MIN' + char(10);
SET @mDqry3 = @mDqry3 + '		,LD.Y_YEAR			' + char(10);

SET @mDqry3 = @mDqry3 + '		from LD' + char(10);
SET @mDqry3 = @mDqry3 + '' + char(10);
SET @mDqry3 = @mDqry3 + '		group by ' + char(10);
SET @mDqry3 = @mDqry3 + '		  LD.DIVISION_ID' + char(10);
SET @mDqry3 = @mDqry3 + '		  ,LD.FROM_SITE' + char(10);
SET @mDqry3 = @mDqry3 + '		  ,LD.TO_SITE' + char(10);
SET @mDqry3 = @mDqry3 + '		  ,LD.POL_AREA' + char(10);
SET @mDqry3 = @mDqry3 + '		  ,LD.POD_AREA' + char(10);
SET @mDqry3 = @mDqry3 + '		  ,LD.D_PORT_CODE' + char(10);
SET @mDqry3 = @mDqry3 + '		  ,LD.A_PORT_CODE' + char(10);
SET @mDqry3 = @mDqry3 + '		  ,LD.FROM_CITY' + char(10);
SET @mDqry3 = @mDqry3 + '		  ,LD.TO_CITY' + char(10);
SET @mDqry3 = @mDqry3 + '		  ,LD.TRANSPORT_MODE' + char(10);
SET @mDqry3 = @mDqry3 + '		  ,LD.BOD_ID' + char(10);
SET @mDqry3 = @mDqry3 + '		  ,LD.ROUTE_ID' + char(10);
SET @mDqry3 = @mDqry3 + '		  ,LD.SSP_INCOTERMS	' + char(10);
SET @mDqry3 = @mDqry3 + '		  ,LD.Y_YEAR	' + char(10);				
SET @mDqry3 = @mDqry3 + '' + char(10);
SET @mDqry3 = @mDqry3 + '	) AS LD2	' + char(10);
SET @mDqry3 = @mDqry3 + '' + char(10);
SET @mDqry3 = @mDqry3 + '	pivot( MIN(DIVISION_ID) FOR Y_YEAR IN ( '+ @p_PIVOT_yyyymm +' )  ) AS PP' + char(10);
SET @mDqry3 = @mDqry3 + '' + char(10);
--SET @mDqry3 = @mDqry3 + '	order by DIVISIONID,FROM_SITE,TO_SITE,D_PORT_CODE,A_PORT_CODE,FROM_CITY,TO_CITY,TRANSPORT_MODE,SSP_INCOTERMS,BOD_ID' + char(10);
SET @mDqry3 = @mDqry3 + '	order by BOD_ID' + char(10);


	print @mDqry3;


EXEC (@mDQry1+@mDqry2+@mDqry3);

SET @mDqry4 = @mDqry4 + 'select ' + char(10);
SET @mDqry4 = @mDqry4 + '			LD.BOD_ID' + char(10);
SET @mDqry4 = @mDqry4 + '			,COUNT(LD.SHIPMENT_NO) AS SHIPMENTCOUNT' + char(10);
SET @mDqry4 = @mDqry4 + '			,COUNT(LD.SHIPMENT_NO) * 2 AS CONTAINER_COUNT' + char(10);
SET @mDqry4 = @mDqry4 + '		    ' + char(10);
SET @mDqry4 = @mDqry4 + '		from LD' + char(10);
SET @mDqry4 = @mDqry4 + '' + char(10);
SET @mDqry4 = @mDqry4 + '		group by ' + char(10);
SET @mDqry4 = @mDqry4 + '		  LD.DIVISION_ID' + char(10);
SET @mDqry4 = @mDqry4 + '		  ,LD.FROM_SITE' + char(10);
SET @mDqry4 = @mDqry4 + '		  ,LD.TO_SITE' + char(10);

SET @mDqry4 = @mDqry4 + '		  ,LD.POL_AREA' + char(10);
SET @mDqry4 = @mDqry4 + '		  ,LD.POD_AREA' + char(10);

SET @mDqry4 = @mDqry4 + '		  ,LD.D_PORT_CODE' + char(10);
SET @mDqry4 = @mDqry4 + '		  ,LD.A_PORT_CODE' + char(10);
SET @mDqry4 = @mDqry4 + '		  ,LD.FROM_CITY' + char(10);
SET @mDqry4 = @mDqry4 + '		  ,LD.TO_CITY' + char(10);
SET @mDqry4 = @mDqry4 + '		  ,LD.TRANSPORT_MODE' + char(10);
SET @mDqry4 = @mDqry4 + '		  ,LD.BOD_ID' + char(10);
SET @mDqry4 = @mDqry4 + '		  ,LD.ROUTE_ID' + char(10);
SET @mDqry4 = @mDqry4 + '		  ,LD.SSP_INCOTERMS	' + char(10);			
SET @mDqry4 = @mDqry4 + '' + char(10);

SET @mDqry4 = @mDqry4 + '	order by LD.BOD_ID' + char(10);

EXEC (@mDQry1+@mDqry2+@mDqry4);



END
