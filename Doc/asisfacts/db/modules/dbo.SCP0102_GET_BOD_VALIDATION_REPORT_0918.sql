

/*
 * Program ID   : SSP0028_GET_DELIVERY_TRACKING_LT COPY => SCP0102_GET_BOD_VALIDATION_REPORT_0918
 * Description  : Delivery Tracking LT
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2022/09/13   PARKTAEHAK		신규추가
 * 2023-08-09   vadabi3         BOD Validation Report) UI 개선 - ROUTE_ID
 * 2023/08/23   vadabi3		    개발DB 이슈로 백업본으로 복구
 * 2023/09/01   vadabi3		    BOD Validation Report) UI 개선 - ROUTE_ID
 ----------------------------------------------------------------------------------------------------

 EXEC SCP0102_GET_BOD_VALIDATION_REPORT_0918
 @p_division_id='81'
 , @p_from_yyyymmdd='20230401'
 , @p_to_yyyymmdd='20230630'
 , @p_from_site=''
 , @p_to_site=''
 , @p_PIVOT_yyyymm='[202304],[202305],[202306]'
 , @p_from_country=''
 , @p_to_country=''
 , @p_from_city=''
 , @p_to_city='MXMEX'
 , @p_from_area=''
 , @p_to_area=''



  EXEC SCP0102_GET_BOD_VALIDATION_REPORT 
  @p_division_id='40'
  , @p_from_yyyymmdd='20230101'
  , @p_to_yyyymmdd='20231006'
  , @p_from_site='G182-A'
  , @p_to_site=''
  , @p_PIVOT_yyyymm='[202301],[202302],[202303],[202304],[202305],[202306],[202307],[202308],[202309],[202310]'
  , @p_from_country=''
  , @p_to_country=''
  , @p_from_city=''
  , @p_to_city=''
  , @p_from_area=''
  , @p_to_area=''

EXCEPTION : ?????? 'AND' ?????? ?????? ??????????????.
?????? 'AND' ?????? ?????? ??????????????.




*/

CREATE PROCEDURE [dbo].[SCP0102_GET_BOD_VALIDATION_REPORT_0918]

    @p_division_id      NVARCHAR(10),
	@p_from_yyyymmdd	NVARCHAR(8),
    @p_to_yyyymmdd		NVARCHAR(8),	
	@p_from_site		NVARCHAR(MAX),
	@p_to_site			NVARCHAR(MAX),
	@p_PIVOT_yyyymm		NVARCHAR(MAX),
	@p_from_country     NVARCHAR(MAX),
	@p_to_country		NVARCHAR(MAX),
	@p_from_city		NVARCHAR(MAX),
	@p_to_city			NVARCHAR(MAX),
	@p_from_area		NVARCHAR(MAX),
	@p_to_area			NVARCHAR(MAX)
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




			
-------------------------------------------------------------------------------------------------------------------------------
-- #TMP_CONFIRM
-------------------------------------------------------------------------------------------------------------------------------		
	IF OBJECT_ID('TEMPDB..#TMP_CONFIRM') IS NOT NULL
		DROP TABLE #TMP_CONFIRM;	

	IF OBJECT_ID('TEMPDB..#TMP_LD') IS NOT NULL
		DROP TABLE TMP_LD;	


	  SELECT CN.DIVISION_ID 																						
			,CN.FROM_SITE_COMPANY_ID AS COMPANY_ID 																
			,EX.SHIPMENT_NO 																						
			,CN.CONFIRM_ID 																						
			,CN.BOD_ID 																							
			,CN.ITEM_ID 																							
			,EX.EXFACTORY_DATE 																					
			,RT.LT_DEPARTURE_INLAND 																				
			,RT.LT_WAIT_SHIPPING 																					
			,RT.LT_VOYAGE 																						
			,RT.LT_LAY_OFF_CLEARANCE 																				
			,RT.LT_ARRIVAL_INLAND 	
		INTO #TMP_CONFIRM 																			
		FROM ( 																									
			SELECT X.ATTRIBUTE3 AS SHIPMENT_NO 																	
					,MAX(X.CONFIRM_ID) AS CONFIRM_ID  																
					,MAX(SYSTEM_EXFACTORY_DATE) AS EXFACTORY_DATE 													
				FROM SCM_DNM_EXFACTORY_RESULT AS X WITH(NOLOCK) 													
				JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK) 													
				ON L.LOOKUP_TYPE = 'ERP_SSP_TYPE' -- LOOKUP에 등록된 공정만  									
				AND L.VALID_YN = 'Y' 																			
				AND X.VALID_YN = 'Y' 																			
				AND L.SEGMENT1    = X.SSP_TYPE 																	
			WHERE 1 = 1 																						
				AND X.ATTRIBUTE3 IS NOT NULL 																		
				AND X.DIVISION_ID = '' +@p_division_id + ''                   --@DIVISION						
				AND X.SYSTEM_EXFACTORY_DATE BETWEEN '' +@p_from_yyyymmdd + ''   AND '' +@p_to_yyyymmdd + '' 
				AND X.EXFACTORY_STATUS NOT IN ('D10','D90') 													
				AND X.CONFIRM_ID LIKE 'C%' 																		
			GROUP BY X.ATTRIBUTE3 																					 																										
			) AS EX 																								
		JOIN SSP_ANL_SHIP_CONFIRM AS CN  WITH(NOLOCK) 															
		ON EX.CONFIRM_ID = CN.CONFIRM_ID 																		
		JOIN SSP_ANL_SHIP_CONFIRM_ROUTE AS RT WITH(NOLOCK) 														
		ON CN.CONFIRM_ID = RT.CONFIRM_ID 	
		
		
			
					
			
-------------------------------------------------------------------------------------------------------------------------------
-- WITH LD
-------------------------------------------------------------------------------------------------------------------------------	
	SET @mDqry1 = @mDQry1 + ' WITH LD AS (																																					' + char(10);



	-- TTL 추가
	SET @mDqry1 = @mDQry1 + 'SELECT DATA.*		' + char(10);
	SET @mDqry1 = @mDQry1 + ' , CASE  WHEN TRANSPORT_MODE = ''TRK'' THEN ISNULL(CONVERT(INT, TTL1),0) + ISNULL(CONVERT(INT,TTL2),0) + ISNULL(CONVERT(INT,TTL3),0) + ISNULL(CONVERT(INT, TTL4),0) + ISNULL(CONVERT(INT, TTL5),0) ' + char(10);
	SET @mDqry1 = @mDQry1 + '         WHEN TTL1 IS NULL THEN NULL' + char(10);
	SET @mDqry1 = @mDQry1 + ' 	      WHEN TTL2 IS NULL THEN NULL' + char(10);
	SET @mDqry1 = @mDQry1 + ' 	      WHEN TTL3 IS NULL THEN NULL' + char(10);
	SET @mDqry1 = @mDQry1 + ' 	      WHEN TTL4 IS NULL THEN NULL' + char(10);
	SET @mDqry1 = @mDQry1 + ' 	      WHEN TTL5 IS NULL THEN NULL' + char(10);	
	SET @mDqry1 = @mDQry1 + '         ELSE ISNULL(CONVERT(INT, TTL1),0) + ISNULL(CONVERT(INT,TTL2),0) + ISNULL(CONVERT(INT,TTL3),0) + ISNULL(CONVERT(INT, TTL4),0) + ISNULL(CONVERT(INT, TTL5),0) 	' + char(10);
	SET @mDqry1 = @mDQry1 + '         END AS TTL	 ' + char(10);	  -- 20230901																																																				
	SET @mDqry1 = @mDQry1 + ' FROM (		' + char(10);
	
	
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
	--SET @mDqry1 = @mDqry1 + '				  ,CASE WHEN ISDATE(T.POD_ATD) = 1		AND IIF(S.VMI_YN = ''Y'', ISDATE(T.VMI_ATA), ISDATE(T.F_DEST_ATA))  = 1		' + char(10);
	--SET @mDqry1 = @mDqry1 + '						THEN CONVERT(nvarchar, DATEDIFF(DD, T.POD_ATD, IIF(S.VMI_YN = ''Y'', T.VMI_ATA, T.F_DEST_ATA)))				' + char(10);
	--SET @mDqry1 = @mDqry1 + '						ELSE NULL END AS TTL5																						' + char(10);
    SET @mDqry1 = @mDQry1 + '             , CASE 																																										' + char(10);	
	SET @mDqry1 = @mDQry1 + '              WHEN S.VMI_YN = ''Y'' AND ISDATE(TX.F_DEST_ATA_DATE) = 1			AND ISDATE(TX.POD_ATD_DATE) = 1 THEN CONVERT(nvarchar, DATEDIFF(DD,TX.POD_ATD_DATE,TX.F_DEST_ATA_DATE))		' + char(10);	
	SET @mDqry1 = @mDQry1 + '              WHEN S.VMI_YN = ''Y'' AND ISDATE(ISNULL(TX.ZFCY2ATA, '''')) = 1	AND ISDATE(TX.POD_ATD_DATE) = 1 THEN CONVERT(nvarchar, DATEDIFF(DD,TX.POD_ATD_DATE,ISNULL(TX.ZFCY2ATA, '''')))	' + char(10);	
	SET @mDqry1 = @mDQry1 + '              WHEN S.VMI_YN = ''N'' AND ISDATE(TX.F_DEST_ATA_DATE) = 1			AND ISDATE(TX.POD_ATD_DATE) = 1 THEN CONVERT(nvarchar, DATEDIFF(DD,TX.POD_ATD_DATE,TX.F_DEST_ATA_DATE))		' + char(10);	
	SET @mDqry1 = @mDQry1 + '              ELSE NULL 																																									' + char(10);	
	SET @mDqry1 = @mDQry1 + '              END	AS TTL5																																									' + char(10);	  -- TTL5 재정의 : VMI_YN Y여도, F_DEST_ATA 값이 있으면 F_DEST_ATA - POD_ATD 값을 TTL5로 삼음
	SET @mDqry1 = @mDqry1 + '				  ,E.CONFIRM_ID 																									' + char(10);

	SET @mDqry1 = @mDqry1 + '				  ,FR.ATTRIBUTE1 AS POL_AREA 																						' + char(10);-----------------------------
	SET @mDqry1 = @mDqry1 + '				  ,TZ.ATTRIBUTE1 AS POD_AREA  																						' + char(10);----------------------------
	SET @mDqry1 = @mDqry1 + '				  ,TX.CONTAINER_NO																						            ' + char(10);----------------------------

	SET @mDqry1 = @mDqry1 + '			  FROM SSP_DNM_DELIVERY_TRACKING_V AS T 																				' + char(10);
	SET @mDqry1 = @mDqry1 + '				   JOIN #TMP_CONFIRM  AS E 																							' + char(10);

	SET @mDqry2 = @mDqry2 + '				ON T.COMPANY_ID = E.COMPANY_ID ' + char(10);
	SET @mDqry2 = @mDqry2 + '			   AND T.SHIPMENT_NO = E.SHIPMENT_NO ' + char(10);
	SET @mDqry2 = @mDqry2 + '			  JOIN SCP_MST_BOD AS B  ' + char(10);
	SET @mDqry2 = @mDqry2 + '				ON E.BOD_ID = B.BOD_ID ' + char(10);
	SET @mDqry2 = @mDqry2 + '			  JOIN SCM_MST_SITE AS S ' + char(10);
	SET @mDqry2 = @mDqry2 + '				ON B.division_id = S.DIVISION_ID ' + char(10);
	SET @mDqry2 = @mDqry2 + '			   AND B.to_site = S.SCM_SITE_ID ' + char(10);
	SET @mDqry2 = @mDqry2 + '			  JOIN SCP_MST_DISTRIBUTION_ROUTE AS D ' + char(10);
	SET @mDqry2 = @mDqry2 + '				ON B.ROUTE_ID = D.ROUTE_ID ' + char(10);
	SET @mDqry2 = @mDqry2 + '  LEFT OUTER JOIN dbo.SCM_MST_PORT AS FR ' + char(10);
  --SET @mDqry = @mDQry + '				ON D.FROM_COUNTRY = FR.COUNTRY' + char(10);-------------------------------
	SET @mDqry2 = @mDqry2 + '				ON D.D_COUNTRY = FR.COUNTRY' + char(10);-------------------------------
	SET @mDqry2 = @mDqry2 + '			   AND D.D_PORT_CODE  = FR.PORT_CODE' + char(10);
	SET @mDqry2 = @mDqry2 + '  LEFT OUTER JOIN dbo.SCM_MST_PORT AS TZ ----권역정보' + char(10);
  --SET @mDqry = @mDQry + '				ON D.FROM_COUNTRY = TZ.COUNTRY ' + char(10);------------------------------
	SET @mDqry2 = @mDqry2 + '				ON D.A_COUNTRY=TZ.COUNTRY '+ char(10);------------------------------
	SET @mDqry2 = @mDqry2 + '			   AND D.A_PORT_CODE  = TZ.PORT_CODE ' + char(10);
	
	SET @mDqry2 = @mDqry2 + '   LEFT JOIN [dbo].[SCM_DNM_DELIVERY_TRACKING] AS TX with(nolock)' + char(10);
	SET @mDqry2 = @mDqry2 + '   ON T.COMPANY_ID = TX.COMPANY_ID' + char(10);
    SET @mDqry2 = @mDqry2 + '   AND T.SHIPMENT_NO = TX.SHIPMENT_NO' + char(10);
	
	
	
	SET @mDqry2 = @mDqry2 + '			 WHERE 1 = 1 ' + char(10);		
	
		
	
	IF ( @v_from_site   IS NOT NULL AND @v_from_site    != '')			SET @mDqry2 =@mDqry2 + ' 					AND  B.from_site		IN ('+ @v_from_site   +')		'+char(10); 
	IF ( @v_to_site     IS NOT NULL AND @v_to_site    != '')			SET @mDqry2 =@mDqry2 + ' 					AND  B.to_site			IN ('+ @v_to_site   +')			'+char(10); 
																				 
	IF ( @p_from_area   IS NOT NULL AND @p_from_area    != '')			SET @mDqry2 =@mDqry2 + ' 					AND  FR.ATTRIBUTE1		=N'''+@p_from_area+'''			'+char(10); 
	IF ( @p_to_area     IS NOT NULL AND @p_to_area    != '')			SET @mDqry2 =@mDqry2 + ' 					AND  TZ.ATTRIBUTE1		=N'''+@p_to_area+'''			'+char(10); 
																				 
	IF ( @v_from_country   IS NOT NULL AND @v_from_country    != '')	SET @mDqry2 =@mDqry2 + ' 					AND  D.FROM_COUNTRY     IN ('+ @v_from_country   +')    '+char(10); 
	IF ( @v_to_country     IS NOT NULL AND @v_to_country    != '')		SET @mDqry2 =@mDqry2 + ' 					AND  D.TO_COUNTRY		IN ('+ @v_to_country   +')      '+char(10); 
																				 
	IF ( @v_from_city   IS NOT NULL AND @v_from_city    != '')			SET @mDqry2 =@mDqry2 + ' 					AND  D.FROM_CITY		IN ('+ @v_from_city   +')		'+char(10); 
	IF ( @v_to_city     IS NOT NULL AND @v_to_city    != '')			SET @mDqry2 =@mDqry2 + ' 					AND  D.TO_CITY			IN ('+ @v_to_city   +')			'+char(10); 
	SET @mDqry2 = @mDqry2 + '			) AS DATA ' + char(10);	
	SET @mDqry2 = @mDqry2 + '			) ' + char(10);	
-------------------------------------------------------------------------------------------------------------------------------
-- LD group
-------------------------------------------------------------------------------------------------------------------------------	
SET @mDqry3 = @mDqry3 + '
select * 
from
(
select 
		     LD.DIVISION_ID
			,LD.DIVISION_ID AS DIVISIONID
			,LD.FROM_SITE
			,LD.TO_SITE
			,LD.POL_AREA
			,LD.POD_AREA
			,LD.D_PORT_CODE 
			,LD.A_PORT_CODE
			,LD.FROM_CITY
			,LD.TO_CITY
			,LD.TRANSPORT_MODE
			,LD.BOD_ID
			,LD.ROUTE_ID
			,LD.SSP_INCOTERMS
			,COUNT(LD.SHIPMENT_NO) AS SHIPMENTCOUNT

			,AVG(LD.NDR1) AS NDR1
			,AVG(LD.NDR2) AS NDR2
			,AVG(LD.NDR3) AS NDR3
			,AVG(LD.NDR4) AS NDR4
			,AVG(LD.NDR5) AS NDR5

			,AVG(LD.DR1) AS DR1
			,AVG(LD.DR2) AS DR2
			,AVG(LD.DR3) AS DR3
			,AVG(LD.DR4) AS DR4
			,AVG(LD.DR5) AS DR5

			,AVG(convert(decimal,LD.TTL1)) AS TTL1_AVG
			,MAX(convert(decimal,LD.TTL1)) AS TTL1_MAX
			,MIN(convert(decimal,LD.TTL1)) AS TTL1_MIN
		    --,STDEV(convert(decimal,LD.TTL1)) AS TTL1_STDEV
		    --,STDEV(convert(decimal,LD.TTL1)) AS TTL1_AVG_CI_80

			,AVG(convert(decimal,LD.TTL2)) AS TTL2_AVG
			,MAX(convert(decimal,LD.TTL2)) AS TTL2_MAX
			,MIN(convert(decimal,LD.TTL2)) AS TTL2_MIN
		    --,STDEV(convert(decimal,LD.TTL2)) AS TTL2_STDEV
		    --,STDEV(convert(decimal,LD.TTL2)) AS TTL2_AVG_CI_80

			,AVG(convert(decimal,LD.TTL3)) AS TTL3_AVG
			,MAX(convert(decimal,LD.TTL3)) AS TTL3_MAX
			,MIN(convert(decimal,LD.TTL3)) AS TTL3_MIN
		    --,STDEV(convert(decimal,LD.TTL3)) AS TTL3_STDEV
		    --,STDEV(convert(decimal,LD.TTL3)) AS TTL3_AVG_CI_80

			,AVG(convert(decimal,LD.TTL4)) AS TTL4_AVG
			,MAX(convert(decimal,LD.TTL4)) AS TTL4_MAX
			,MIN(convert(decimal,LD.TTL4)) AS TTL4_MIN
		    --,STDEV(convert(decimal,LD.TTL4)) AS TTL4_STDEV
		    --,STDEV(convert(decimal,LD.TTL4)) AS  TTL4_AVG_CI_80

			,AVG(convert(decimal,LD.TTL5)) AS TTL5_AVG
			,MAX(convert(decimal,LD.TTL5)) AS TTL5_MAX
			,MIN(convert(decimal,LD.TTL5)) AS TTL5_MIN
		    --,STDEV(convert(decimal,LD.TTL5)) AS TTL5_STDEV
		    --,STDEV(convert(decimal,LD.TTL5)) AS TTL5_AVG_CI_80

			,AVG(convert(decimal,LD.TTL)) AS TTL_AVG
			,MAX(convert(decimal,LD.TTL)) AS TTL_MAX
			,MIN(convert(decimal,LD.TTL)) AS TTL_MIN

		,LD.Y_YEAR			

		from LD

		group by 
		   LD.DIVISION_ID
		  ,LD.FROM_SITE
		  ,LD.TO_SITE
		  ,LD.POL_AREA
		  ,LD.POD_AREA
		  ,LD.D_PORT_CODE
		  ,LD.A_PORT_CODE
		  ,LD.FROM_CITY
		  ,LD.TO_CITY
		  ,LD.TRANSPORT_MODE
		  ,LD.BOD_ID
		  ,LD.ROUTE_ID
		  ,LD.SSP_INCOTERMS	
		  ,LD.Y_YEAR					

	) AS LD2	

	pivot( MIN(DIVISION_ID) FOR Y_YEAR IN ( '+ @p_PIVOT_yyyymm +' )  ) AS PP
order by BOD_ID
'

	
				DECLARE @POS INT =1;
				SET @POS =1;
				DECLARE @LEN INT =LEN(@mDqry1 + @mDqry2 + @mDqry3);
				WHILE @POS <= @LEN
				BEGIN
					PRINT SUBSTRING(@mDqry1 + @mDqry2 + @mDqry3,@POS,4000);
					SET @POS = @POS+4000;
				END;
	


--SET @mDqry3 = @mDqry3 + '	order by DIVISIONID,FROM_SITE,TO_SITE,D_PORT_CODE,A_PORT_CODE,FROM_CITY,TO_CITY,TRANSPORT_MODE,SSP_INCOTERMS,BOD_ID
EXEC (@mDqry1 + @mDqry2 + @mDqry3);


-------------------------------------------------------------------------------------------------------------------------------
-- LD) SHIPMENTCOUNT, CONTAINER_COUNT
-------------------------------------------------------------------------------------------------------------------------------	
DECLARE @mDqry5 NVARCHAR(MAX) = ''

SET @mDqry5 = @mDqry5 + '     select 
									 LD.BOD_ID
									,COUNT(DISTINCT LD.SHIPMENT_NO) AS SHIPMENTCOUNT
									,COUNT(DISTINCT T.CONTAINER_NO) AS CONTAINER_COUNT
									,LD.COMPANY_ID
									,LD.ROUTE_ID
								from LD
							LEFT JOIN SCM_DNM_DELIVERY_TRACKING T ON LD.COMPANY_ID = T.COMPANY_ID AND LD.SHIPMENT_NO = T.SHIPMENT_NO
							group by 
							   LD.COMPANY_ID
							  ,LD.DIVISION_ID
							  ,LD.FROM_SITE
							  ,LD.TO_SITE
							  ,LD.POL_AREA
							  ,LD.POD_AREA
							  ,LD.D_PORT_CODE
							  ,LD.A_PORT_CODE
							  ,LD.FROM_CITY
							  ,LD.TO_CITY
							  ,LD.TRANSPORT_MODE
							  ,LD.BOD_ID
							  ,LD.ROUTE_ID
							  ,LD.SSP_INCOTERMS			
					  order by LD.BOD_ID'

EXEC (@mDqry1 + @mDqry2 + @mDqry5);



EXEC (@mDqry1 + @mDqry2 + ' 

, w_data as
(
	SELECT BOD_ID
	, y_year
	, avg(convert(NUMERIC(13,6), ttl) )  as avg
	, avg(convert(NUMERIC(13,6), ttl1))  as avg1
	, avg(convert(NUMERIC(13,6), ttl2))  as avg2
	, avg(convert(NUMERIC(13,6), ttl3))  as avg3
	, avg(convert(NUMERIC(13,6), ttl4))  as avg4
	, avg(convert(NUMERIC(13,6), ttl5))  as avg5

	, convert(NUMERIC(13,6), stdev(convert(integer, ttl) ))  as TTL_STDEV 
	, convert(NUMERIC(13,6), stdev(convert(integer, ttl1)))  as TTL1_STDEV
	, convert(NUMERIC(13,6), stdev(convert(integer, ttl2)))  as TTL2_STDEV
	, convert(NUMERIC(13,6), stdev(convert(integer, ttl3)))  as TTL3_STDEV
	, convert(NUMERIC(13,6), stdev(convert(integer, ttl4)))  as TTL4_STDEV
	, convert(NUMERIC(13,6), stdev(convert(integer, ttl5)))  as TTL5_STDEV
				
	, convert(NUMERIC(13,6), COUNT(convert(integer, ttl) ))  as TTL_CNT
	, convert(NUMERIC(13,6), COUNT(convert(integer, ttl1)))  as TTL1_CNT
	, convert(NUMERIC(13,6), COUNT(convert(integer, ttl2)))  as TTL2_CNT
	, convert(NUMERIC(13,6), COUNT(convert(integer, ttl3)))  as TTL3_CNT
	, convert(NUMERIC(13,6), COUNT(convert(integer, ttl4)))  as TTL4_CNT
	, convert(NUMERIC(13,6), COUNT(convert(integer, ttl5)))  as TTL5_CNT

	FROM LD
	WHERE BOD_ID = ''10163''
	GROUP BY BOD_ID, y_year
)

select data2.BOD_ID
	  ,data2.y_year

	  ,CONVERT(numeric(10,0), avg + CI_TTL)  as CI_TTL_UP
	  ,CONVERT(numeric(10,0), avg + CI_TTL1) as CI_TTL1_UP
	  ,CONVERT(numeric(10,0), avg + CI_TTL2) as CI_TTL2_UP
	  ,CONVERT(numeric(10,0), avg + CI_TTL3) as CI_TTL3_UP
	  ,CONVERT(numeric(10,0), avg + CI_TTL4) as CI_TTL4_UP
	  ,CONVERT(numeric(10,0), avg + CI_TTL5) as CI_TTL5_UP

	  ,CONVERT(numeric(10,0), avg - CI_TTL)  as CI_TTL_DOWN
	  ,CONVERT(numeric(10,0), avg - CI_TTL1) as CI_TTL1_DOWN
	  ,CONVERT(numeric(10,0), avg - CI_TTL2) as CI_TTL2_DOWN
	  ,CONVERT(numeric(10,0), avg - CI_TTL3) as CI_TTL3_DOWN
	  ,CONVERT(numeric(10,0), avg - CI_TTL4) as CI_TTL4_DOWN
	  ,CONVERT(numeric(10,0), avg - CI_TTL5) as CI_TTL5_DOWN
	  ,CI_TTL
	  ,CI_TTL1
	  ,CI_TTL2
	  ,CI_TTL3
	  ,CI_TTL4
	  ,CI_TTL5
from
(
	SELECT 	*
	      , CONVERT(numeric(10,1) ,1.2 *  abs(1-TTL_STDEV  / 2) / TTL_CNT)  AS CI_TTL
	      , CONVERT(numeric(10,1) ,1.2 *  abs(1-TTL1_STDEV / 2) / TTL1_CNT) AS CI_TTL1
	      , CONVERT(numeric(10,1) ,1.2 *  abs(1-TTL2_STDEV / 2) / TTL2_CNT) AS CI_TTL2
	      , CONVERT(numeric(10,1) ,1.2 *  abs(1-TTL3_STDEV / 2) / TTL3_CNT) AS CI_TTL3
	      , CONVERT(numeric(10,1) ,1.2 *  abs(1-TTL4_STDEV / 2) / TTL4_CNT) AS CI_TTL4
	      , CONVERT(numeric(10,1) ,1.2 *  abs(1-TTL5_STDEV / 2) / TTL5_CNT) AS CI_TTL5
	from w_data

)  data2


');



EXEC (@mDqry1 + @mDqry2 + ' 
SELECT  BOD_ID
	, y_year
	, exfactory_date
	, SHIPMENT_NO
	, container_no
	, TTL
	, TTL1
	, TTL2
	, TTL3
	, TTL4
	, TTL5
FROM LD
	WHERE BOD_ID = ''10163''

order by exfactory_date
');


END
