

/*
 * PROGRAM ID   : SSP0028_GET_DELIVERY_TRACKING_LT COPY => SCP0102_GET_BOD_VALIDATION_REPORT
 * DESCRIPTION  : DELIVERY TRACKING LT
 * PROGRAM HISTORY
 *===================================================================================================
 *   DATE       IN CHARGE		DESCRIPTION
 *===================================================================================================
 * 2022/09/13   PARKTAEHAK		PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 신규추가
 * 2023-08-09   VADABI3         PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 BOD VALIDATION REPORT) UI 개선 - ROUTE_ID
 * 2023/08/23   VADABI3		    PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 개발DB 이슈로 백업본으로 복구
 * 2023/09/01   VADABI3		    PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 BOD VALIDATION REPORT) UI 개선 - ROUTE_ID
 * 2023/11/26   jahn1502		TTL1 ~ TTL5 => TTL12, TTL3, TTL45 로 변경 및 TTL12 계산로직 변경

 ----------------------------------------------------------------------------------------------------

 EXEC SCP0102_GET_BOD_VALIDATION_REPORT 
 @P_DIVISION_ID='81'
 , @P_FROM_YYYYMMDD='20230401'
 , @P_TO_YYYYMMDD='20230630'
 , @P_FROM_SITE=''
 , @P_TO_SITE=''
 , @P_PIVOT_YYYYMM='[202304],[202305],[202306]'
 , @P_FROM_COUNTRY=''
 , @P_TO_COUNTRY=''
 , @P_FROM_CITY=''
 , @P_TO_CITY=''
 , @P_FROM_AREA=''
 , @P_TO_AREA=''



  EXEC SCP0102_GET_BOD_VALIDATION_REPORT 
  @P_DIVISION_ID='40'
  , @P_FROM_YYYYMMDD='20230101'
  , @P_TO_YYYYMMDD='20231006'
  , @P_FROM_SITE='G182-A'
  , @P_TO_SITE=''
  , @P_PIVOT_YYYYMM='[202301],[202302],[202303],[202304],[202305],[202306],[202307],[202308],[202309],[202310]'
  , @P_FROM_COUNTRY=''
  , @P_TO_COUNTRY=''
  , @P_FROM_CITY=''
  , @P_TO_CITY=''
  , @P_FROM_AREA=''
  , @P_TO_AREA=''

EXCEPTION : ?????? 'AND' ?????? ?????? ??????????????.
?????? 'AND' ?????? ?????? ??????????????.




*/

CREATE PROCEDURE [dbo].[SCP0102_GET_BOD_VALIDATION_REPORT]

    @P_DIVISION_ID      NVARCHAR(10),
	@P_FROM_YYYYMMDD	NVARCHAR(8),
    @P_TO_YYYYMMDD		NVARCHAR(8),	
	@P_FROM_SITE		NVARCHAR(MAX),
	@P_TO_SITE			NVARCHAR(MAX),
	@P_PIVOT_YYYYMM		NVARCHAR(MAX),
	@P_FROM_COUNTRY     NVARCHAR(MAX),
	@P_TO_COUNTRY		NVARCHAR(MAX),
	@P_FROM_CITY		NVARCHAR(MAX),
	@P_TO_CITY			NVARCHAR(MAX),
	@P_FROM_AREA		NVARCHAR(MAX),
	@P_TO_AREA			NVARCHAR(MAX)

AS
BEGIN

    SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @MDQRY1 NVARCHAR(MAX)='';
	DECLARE @MDQRY2 NVARCHAR(MAX)='';
	DECLARE @MDQRY3 NVARCHAR(MAX)='';	
	DECLARE @MDQRY4 NVARCHAR(MAX)='';	
	
	DECLARE  @V_FROM_SITE NVARCHAR(MAX)='';
	DECLARE  @V_TO_SITE NVARCHAR(MAX)='';	
	DECLARE  @V_FROM_COUNTRY NVARCHAR(MAX)='';
	DECLARE  @V_TO_COUNTRY NVARCHAR(MAX)='';	
	DECLARE  @V_FROM_CITY NVARCHAR(MAX)='';
	DECLARE  @V_TO_CITY NVARCHAR(MAX)='';	

	--IN 조건으로 데이터를 가져옴
	SET @V_FROM_SITE = [DBO].FN_GET_IN_STR(@P_FROM_SITE);
	SET @V_TO_SITE = [DBO].FN_GET_IN_STR(@P_TO_SITE);	
	SET @V_FROM_COUNTRY = [DBO].FN_GET_IN_STR(@P_FROM_COUNTRY);
	SET @V_TO_COUNTRY = [DBO].FN_GET_IN_STR(@P_TO_COUNTRY);	
	SET @V_FROM_CITY = [DBO].FN_GET_IN_STR(@P_FROM_CITY);
	SET @V_TO_CITY = [DBO].FN_GET_IN_STR(@P_TO_CITY);	




			
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
					--,MAX(SYSTEM_EXFACTORY_DATE) AS EXFACTORY_DATE
					,MAX(PLANT_ISSUE_DATE) AS EXFACTORY_DATE
				FROM SCM_DNM_EXFACTORY_RESULT AS X WITH(NOLOCK) 													
				JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK) 													
				ON L.LOOKUP_TYPE = 'ERP_SSP_TYPE' -- LOOKUP에 등록된 공정만  									
				AND L.VALID_YN = 'Y' 																			
				AND X.VALID_YN = 'Y' 																			
				AND L.SEGMENT1    = X.SSP_TYPE 																	
			WHERE 1 = 1 																						
				AND X.ATTRIBUTE3 IS NOT NULL 																		
				AND X.DIVISION_ID = '' +@P_DIVISION_ID + ''                   --@DIVISION						
				--AND X.SYSTEM_EXFACTORY_DATE BETWEEN '' +@P_FROM_YYYYMMDD + ''   AND '' +@P_TO_YYYYMMDD + '' 
				AND X.PLANT_ISSUE_DATE BETWEEN '' +@P_FROM_YYYYMMDD + ''   AND '' +@P_TO_YYYYMMDD + '' 
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
	SET @MDQRY1 = @MDQRY1 + ' WITH LD AS (																																					' + CHAR(10);



	-- TTL 추가
	SET @MDQRY1 = @MDQRY1 + 'SELECT DATA.*		' + CHAR(10);
	--SET @MDQRY1 = @MDQRY1 + ' , CASE  WHEN TRANSPORT_MODE = ''TRK'' THEN ISNULL(CONVERT(INT, TTL1),0) + ISNULL(CONVERT(INT,TTL2),0) + ISNULL(CONVERT(INT,TTL3),0) + ISNULL(CONVERT(INT, TTL4),0) + ISNULL(CONVERT(INT, TTL5),0) ' + CHAR(10);
	--SET @MDQRY1 = @MDQRY1 + '         WHEN TTL1 IS NULL THEN NULL' + CHAR(10);
	--SET @MDQRY1 = @MDQRY1 + ' 	      WHEN TTL2 IS NULL THEN NULL' + CHAR(10);
	--SET @MDQRY1 = @MDQRY1 + ' 	      WHEN TTL3 IS NULL THEN NULL' + CHAR(10);
	--SET @MDQRY1 = @MDQRY1 + ' 	      WHEN TTL4 IS NULL THEN NULL' + CHAR(10);
	--SET @MDQRY1 = @MDQRY1 + ' 	      WHEN TTL5 IS NULL THEN NULL' + CHAR(10);	
	--SET @MDQRY1 = @MDQRY1 + '         ELSE ISNULL(CONVERT(INT, TTL1),0) + ISNULL(CONVERT(INT,TTL2),0) + ISNULL(CONVERT(INT,TTL3),0) + ISNULL(CONVERT(INT, TTL4),0) + ISNULL(CONVERT(INT, TTL5),0) 	' + CHAR(10);
	--SET @MDQRY1 = @MDQRY1 + '         END AS TTL	 ' + CHAR(10);	  -- 20230901																																																				
	SET @MDQRY1 = @MDQRY1 + ' FROM (		' + CHAR(10);
	
	
	SET @MDQRY1 = @MDQRY1 + '			SELECT E.DIVISION_ID 																																' + CHAR(10);
	SET @MDQRY1 = @MDQRY1 + '				  ,T.COMPANY_ID  																																' + CHAR(10);
	SET @MDQRY1 = @MDQRY1 + '				  ,B.FROM_SITE 																																	' + CHAR(10);
	SET @MDQRY1 = @MDQRY1 + '				  ,B.TO_SITE 																																	' + CHAR(10);
	SET @MDQRY1 = @MDQRY1 + '				  ,T.SHIPMENT_NO 																																' + CHAR(10);
	SET @MDQRY1 = @MDQRY1 + '				  ,D.D_PORT_CODE  																																' + CHAR(10);
	SET @MDQRY1 = @MDQRY1 + '				  ,D.A_PORT_CODE  																																' + CHAR(10);
	SET @MDQRY1 = @MDQRY1 + '				  ,D.FROM_CITY 																																	' + CHAR(10);
	SET @MDQRY1 = @MDQRY1 + '				  ,D.TO_CITY 																																	' + CHAR(10);
	SET @MDQRY1 = @MDQRY1 + '				  ,D.TRANSPORT_MODE			 																													' + CHAR(10);		
	SET @MDQRY1 = @MDQRY1 + '				  ,SUBSTRING(E.EXFACTORY_DATE,0,7) AS Y_YEAR -- ,E.EXFACTORY_DATE																				' + CHAR(10);	
	SET @MDQRY1 = @MDQRY1 + '				  ,E.EXFACTORY_DATE																																 ' + CHAR(10);
	SET @MDQRY1 = @MDQRY1 + '				  ,B.BOD_ID  ' + CHAR(10);
	SET @MDQRY1 = @MDQRY1 + '				  ,B.ROUTE_ID  ' + CHAR(10);
	SET @MDQRY1 = @MDQRY1 + '			      --,B.INCOTERMS  ' + CHAR(10);
	SET @MDQRY1 = @MDQRY1 + '				  ,B.ATTRIBUTE1 AS SSP_INCOTERMS ' + CHAR(10);
	SET @MDQRY1 = @MDQRY1 + '				  ,T.CARRIER  ' + CHAR(10);
	SET @MDQRY1 = @MDQRY1 + '				  ,S.VMI_YN ' + CHAR(10);
	SET @MDQRY1 = @MDQRY1 + '				  ,T.INLAND_ATD ' + CHAR(10);
	SET @MDQRY1 = @MDQRY1 + '				  ,T.POL_ATA ' + CHAR(10);
	SET @MDQRY1 = @MDQRY1 + '				  ,T.POL_ATD ' + CHAR(10);
	SET @MDQRY1 = @MDQRY1 + '				  ,T.POD_ATA ' + CHAR(10);
	SET @MDQRY1 = @MDQRY1 + '				  ,T.POD_ATD ' + CHAR(10);
	SET @MDQRY1 = @MDQRY1 + '				  ,T.VMI_ATA ' + CHAR(10);
	SET @MDQRY1 = @MDQRY1 + '				  ,T.VMI_ATD ' + CHAR(10);
	SET @MDQRY1 = @MDQRY1 + '				  ,T.F_DEST_ATA ' + CHAR(10);
	SET @MDQRY1 = @MDQRY1 + '				  ,D.LT_DEPARTURE_INLAND	AS NDR1  --기준L/T 1 (조회시점)   --기준L/T(현재시점) ' + CHAR(10);
	SET @MDQRY1 = @MDQRY1 + '				  ,D.LT_WAIT_SHIPPING		AS NDR2  --기준L/T 2 (조회시점) ' + CHAR(10);
	SET @MDQRY1 = @MDQRY1 + '				  ,D.LT_VOYAGE				AS NDR3  --기준L/T 3 (조회시점) ' + CHAR(10);
	SET @MDQRY1 = @MDQRY1 + '				  ,D.LT_LAY_OFF_CLEARANCE	AS NDR4  --기준L/T 4 (조회시점) ' + CHAR(10);
	SET @MDQRY1 = @MDQRY1 + '				  ,D.LT_ARRIVAL_INLAND		AS NDR5  --기준L/T 5 (조회시점)     ' + CHAR(10);
	SET @MDQRY1 = @MDQRY1 + '				  ,E.LT_DEPARTURE_INLAND	AS DR1   --기준L/T 1 (계획시점)   --기준L/T(과거계획평균) ' + CHAR(10);
	SET @MDQRY1 = @MDQRY1 + '				  ,E.LT_WAIT_SHIPPING		AS DR2   --기준L/T 2 (계획시점) ' + CHAR(10);
	SET @MDQRY1 = @MDQRY1 + '				  ,E.LT_VOYAGE				AS DR3   --기준L/T 3 (계획시점) ' + CHAR(10);
	SET @MDQRY1 = @MDQRY1 + '				  ,E.LT_LAY_OFF_CLEARANCE	AS DR4   --기준L/T 4 (계획시점) ' + CHAR(10);
	SET @MDQRY1 = @MDQRY1 + '				  ,E.LT_ARRIVAL_INLAND		AS DR5   --기준L/T 5 (계획시점) ' + CHAR(10);
	SET @MDQRY1 = @MDQRY1 + '				  ,CASE WHEN ISDATE(T.INLAND_ATD) = 1	AND ISDATE(T.POL_ATA) = 1 THEN CONVERT(NVARCHAR, DATEDIFF(DD, T.INLAND_ATD, T.POL_ATA)) ELSE NULL END AS TTL1 ' + CHAR(10);
	SET @MDQRY1 = @MDQRY1 + '				  ,CASE WHEN ISDATE(T.POL_ATA) = 1		AND ISDATE(T.POL_ATD) = 1 THEN CONVERT(NVARCHAR, DATEDIFF(DD, T.POL_ATA, T.POL_ATD))	ELSE NULL END AS TTL2 ' + CHAR(10);
	SET @MDQRY1 = @MDQRY1 + '				  ,CASE WHEN ISDATE(T.POL_ATD) = 1		AND ISDATE(T.POD_ATA) = 1 THEN CONVERT(NVARCHAR, DATEDIFF(DD, T.POL_ATD, T.POD_ATA))	ELSE NULL END AS TTL3 ' + CHAR(10);
	SET @MDQRY1 = @MDQRY1 + '				  ,CASE WHEN ISDATE(T.POD_ATA) = 1		AND ISDATE(T.POD_ATD) = 1 THEN CONVERT(NVARCHAR, DATEDIFF(DD, T.POD_ATA, T.POD_ATD))	ELSE NULL END AS TTL4 ' + CHAR(10);
	--SET @MDQRY1 = @MDQRY1 + '				  ,CASE WHEN ISDATE(T.POD_ATD) = 1		AND IIF(S.VMI_YN = ''Y'', ISDATE(T.VMI_ATA), ISDATE(T.F_DEST_ATA))  = 1		' + CHAR(10);
	--SET @MDQRY1 = @MDQRY1 + '						THEN CONVERT(NVARCHAR, DATEDIFF(DD, T.POD_ATD, IIF(S.VMI_YN = ''Y'', T.VMI_ATA, T.F_DEST_ATA)))				' + CHAR(10);
	--SET @MDQRY1 = @MDQRY1 + '						ELSE NULL END AS TTL5																						' + CHAR(10);
    SET @MDQRY1 = @MDQRY1 + '             , CASE 																																										' + CHAR(10);	
	SET @MDQRY1 = @MDQRY1 + '              WHEN S.VMI_YN = ''Y'' AND ISDATE(TX.F_DEST_ATA_DATE) = 1			AND ISDATE(TX.POD_ATD_DATE) = 1 THEN CONVERT(NVARCHAR, DATEDIFF(DD,TX.POD_ATD_DATE,TX.F_DEST_ATA_DATE))		' + CHAR(10);	
	SET @MDQRY1 = @MDQRY1 + '              WHEN S.VMI_YN = ''Y'' AND ISDATE(ISNULL(TX.ZFCY2ATA, '''')) = 1	AND ISDATE(TX.POD_ATD_DATE) = 1 THEN CONVERT(NVARCHAR, DATEDIFF(DD,TX.POD_ATD_DATE,ISNULL(TX.ZFCY2ATA, '''')))	' + CHAR(10);	
	SET @MDQRY1 = @MDQRY1 + '              WHEN S.VMI_YN = ''N'' AND ISDATE(TX.F_DEST_ATA_DATE) = 1			AND ISDATE(TX.POD_ATD_DATE) = 1 THEN CONVERT(NVARCHAR, DATEDIFF(DD,TX.POD_ATD_DATE,TX.F_DEST_ATA_DATE))		' + CHAR(10);	
	SET @MDQRY1 = @MDQRY1 + '              ELSE NULL 																																									' + CHAR(10);	
	SET @MDQRY1 = @MDQRY1 + '              END	AS TTL5																																									' + CHAR(10);	  -- TTL5 재정의 : VMI_YN Y여도, F_DEST_ATA 값이 있으면 F_DEST_ATA - POD_ATD 값을 TTL5로 삼음
	SET @MDQRY1 = @MDQRY1 + '				  ,CASE WHEN ISDATE(T.INLAND_ATD) = 1 AND ISDATE(TX.F_DEST_ATA_DATE) = 1 THEN CONVERT(NVARCHAR, DATEDIFF(DD, T.INLAND_ATD, TX.F_DEST_ATA_DATE)) ELSE NULL END AS TTL		' + CHAR(10);	  -- Transport Mode와 무관하게 Lead Time은 FDEST과 PI Date로 계산 (2025-01-09 최정훈 수정)
	SET @MDQRY1 = @MDQRY1 + '				  ,E.CONFIRM_ID 																									' + CHAR(10);

	SET @MDQRY1 = @MDQRY1 + '				  ,FR.ATTRIBUTE1 AS POL_AREA 																						' + CHAR(10);-----------------------------
	SET @MDQRY1 = @MDQRY1 + '				  ,TZ.ATTRIBUTE1 AS POD_AREA  																						' + CHAR(10);----------------------------

	SET @MDQRY1 = @MDQRY1 + '			  FROM SSP_DNM_DELIVERY_TRACKING_V AS T 																				' + CHAR(10);
	SET @MDQRY1 = @MDQRY1 + '				   JOIN #TMP_CONFIRM  AS E 																							' + CHAR(10);

	SET @MDQRY2 = @MDQRY2 + '				ON T.COMPANY_ID = E.COMPANY_ID ' + CHAR(10);
	SET @MDQRY2 = @MDQRY2 + '			   AND T.SHIPMENT_NO = E.SHIPMENT_NO ' + CHAR(10);
	SET @MDQRY2 = @MDQRY2 + '			  JOIN SCP_MST_BOD AS B  ' + CHAR(10);
	SET @MDQRY2 = @MDQRY2 + '				ON E.BOD_ID = B.BOD_ID ' + CHAR(10);
	SET @MDQRY2 = @MDQRY2 + '			  JOIN SCM_MST_SITE AS S ' + CHAR(10);
	SET @MDQRY2 = @MDQRY2 + '				ON B.DIVISION_ID = S.DIVISION_ID ' + CHAR(10);
	SET @MDQRY2 = @MDQRY2 + '			   AND B.TO_SITE = S.SCM_SITE_ID ' + CHAR(10);
	SET @MDQRY2 = @MDQRY2 + '			  JOIN SCP_MST_DISTRIBUTION_ROUTE AS D ' + CHAR(10);
	SET @MDQRY2 = @MDQRY2 + '				ON B.ROUTE_ID = D.ROUTE_ID ' + CHAR(10);
	SET @MDQRY2 = @MDQRY2 + '  LEFT OUTER JOIN DBO.SCM_MST_PORT AS FR ' + CHAR(10);
  --SET @MDQRY = @MDQRY + '				ON D.FROM_COUNTRY = FR.COUNTRY' + CHAR(10);-------------------------------
	SET @MDQRY2 = @MDQRY2 + '				ON D.D_COUNTRY = FR.COUNTRY' + CHAR(10);-------------------------------
	SET @MDQRY2 = @MDQRY2 + '			   AND D.D_PORT_CODE  = FR.PORT_CODE' + CHAR(10);
	SET @MDQRY2 = @MDQRY2 + '  LEFT OUTER JOIN DBO.SCM_MST_PORT AS TZ ----권역정보' + CHAR(10);
  --SET @MDQRY = @MDQRY + '				ON D.FROM_COUNTRY = TZ.COUNTRY ' + CHAR(10);------------------------------
	SET @MDQRY2 = @MDQRY2 + '				ON D.A_COUNTRY=TZ.COUNTRY '+ CHAR(10);------------------------------
	SET @MDQRY2 = @MDQRY2 + '			   AND D.A_PORT_CODE  = TZ.PORT_CODE ' + CHAR(10);
	
	SET @MDQRY2 = @MDQRY2 + '   LEFT JOIN [DBO].[SCM_DNM_DELIVERY_TRACKING] AS TX WITH(NOLOCK)' + CHAR(10);
	SET @MDQRY2 = @MDQRY2 + '   ON T.COMPANY_ID = TX.COMPANY_ID' + CHAR(10);
    SET @MDQRY2 = @MDQRY2 + '   AND T.SHIPMENT_NO = TX.SHIPMENT_NO' + CHAR(10);
	
	
	
	SET @MDQRY2 = @MDQRY2 + '			 WHERE 1 = 1 ' + CHAR(10);		
	
		
	
	IF ( @V_FROM_SITE   IS NOT NULL AND @V_FROM_SITE    != '')			SET @MDQRY2 =@MDQRY2 + ' 					AND  B.FROM_SITE		IN ('+ @V_FROM_SITE   +')		'+CHAR(10); 
	IF ( @V_TO_SITE     IS NOT NULL AND @V_TO_SITE    != '')			SET @MDQRY2 =@MDQRY2 + ' 					AND  B.TO_SITE			IN ('+ @V_TO_SITE   +')			'+CHAR(10); 
																				 
	IF ( @P_FROM_AREA   IS NOT NULL AND @P_FROM_AREA    != '')			SET @MDQRY2 =@MDQRY2 + ' 					AND  FR.ATTRIBUTE1		=N'''+@P_FROM_AREA+'''			'+CHAR(10); 
	IF ( @P_TO_AREA     IS NOT NULL AND @P_TO_AREA    != '')			SET @MDQRY2 =@MDQRY2 + ' 					AND  TZ.ATTRIBUTE1		=N'''+@P_TO_AREA+'''			'+CHAR(10); 
																				 
	IF ( @V_FROM_COUNTRY   IS NOT NULL AND @V_FROM_COUNTRY    != '')	SET @MDQRY2 =@MDQRY2 + ' 					AND  D.FROM_COUNTRY     IN ('+ @V_FROM_COUNTRY   +')    '+CHAR(10); 
	IF ( @V_TO_COUNTRY     IS NOT NULL AND @V_TO_COUNTRY    != '')		SET @MDQRY2 =@MDQRY2 + ' 					AND  D.TO_COUNTRY		IN ('+ @V_TO_COUNTRY   +')      '+CHAR(10); 
																				 
	IF ( @V_FROM_CITY   IS NOT NULL AND @V_FROM_CITY    != '')			SET @MDQRY2 =@MDQRY2 + ' 					AND  D.FROM_CITY		IN ('+ @V_FROM_CITY   +')		'+CHAR(10); 
	IF ( @V_TO_CITY     IS NOT NULL AND @V_TO_CITY    != '')			SET @MDQRY2 =@MDQRY2 + ' 					AND  D.TO_CITY			IN ('+ @V_TO_CITY   +')			'+CHAR(10); 
	SET @MDQRY2 = @MDQRY2 + '			) AS DATA ' + CHAR(10);	
	SET @MDQRY2 = @MDQRY2 + '			) ' + CHAR(10);	


-------------------------------------------------------------------------------------------------------------------------------
-- TABLE 0 : MAIN
-------------------------------------------------------------------------------------------------------------------------------		
SET @MDQRY3 = @MDQRY3 + '
SELECT * 
FROM
(
SELECT 
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

			,AVG(LD.NDR1 + LD.NDR2) AS NDR12
			,AVG(LD.NDR3) AS NDR3
			,AVG(LD.NDR4 + LD.NDR5) AS NDR45

			,AVG(LD.DR1 + LD.DR2) AS DR12
			,AVG(LD.DR3) AS DR3
			,AVG(LD.DR4 + LD.DR5) AS DR45

			,AVG(CONVERT(DECIMAL,LD.TTL1)+CONVERT(DECIMAL,LD.TTL2)) AS TTL12_AVG
			,MAX(CONVERT(DECIMAL,LD.TTL1))+MAX(CONVERT(DECIMAL,LD.TTL2)) AS TTL12_MAX
			,MIN(CONVERT(DECIMAL,LD.TTL1))+MIN(CONVERT(DECIMAL,LD.TTL2)) AS TTL12_MIN

			,AVG(CONVERT(DECIMAL,LD.TTL3)) AS TTL3_AVG
			,MAX(CONVERT(DECIMAL,LD.TTL3)) AS TTL3_MAX
			,MIN(CONVERT(DECIMAL,LD.TTL3)) AS TTL3_MIN

			,AVG(CONVERT(DECIMAL,LD.TTL4)+CONVERT(DECIMAL,LD.TTL5)) AS TTL45_AVG
			,MAX(CONVERT(DECIMAL,LD.TTL4)+CONVERT(DECIMAL,LD.TTL5)) AS TTL45_MAX
			,MIN(CONVERT(DECIMAL,LD.TTL4)+CONVERT(DECIMAL,LD.TTL5)) AS TTL45_MIN

			,AVG(CONVERT(DECIMAL,LD.TTL)) AS TTL_AVG
			,MAX(CONVERT(DECIMAL,LD.TTL)) AS TTL_MAX
			,MIN(CONVERT(DECIMAL,LD.TTL)) AS TTL_MIN

		,LD.Y_YEAR			

		FROM LD

		GROUP BY 
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

	PIVOT( MIN(DIVISION_ID) FOR Y_YEAR IN ( '+ @P_PIVOT_YYYYMM +' )  ) AS PP
ORDER BY BOD_ID
'

	
				DECLARE @POS INT =1;
				SET @POS =1;
				DECLARE @LEN INT =LEN(@MDQRY1 + @MDQRY2 + @MDQRY3);
				WHILE @POS <= @LEN
				BEGIN
					PRINT SUBSTRING(@MDQRY1 + @MDQRY2 + @MDQRY3,@POS,4000);
					SET @POS = @POS+4000;
				END;
	


--SET @MDQRY3 = @MDQRY3 + '	ORDER BY DIVISIONID,FROM_SITE,TO_SITE,D_PORT_CODE,A_PORT_CODE,FROM_CITY,TO_CITY,TRANSPORT_MODE,SSP_INCOTERMS,BOD_ID
EXEC (@MDQRY1 + @MDQRY2 + @MDQRY3);


-------------------------------------------------------------------------------------------------------------------------------
-- TABLE 1 : SHIPMENTCOUNT, CONTAINER_COUNT
-------------------------------------------------------------------------------------------------------------------------------		
DECLARE @MDQRY5 NVARCHAR(MAX) = ''

SET @MDQRY5 = @MDQRY5 + '     SELECT 
									 LD.BOD_ID
									,COUNT(DISTINCT LD.SHIPMENT_NO) AS SHIPMENTCOUNT
									,COUNT(DISTINCT T.CONTAINER_NO) AS CONTAINER_COUNT
									,LD.COMPANY_ID
									,LD.ROUTE_ID
								FROM LD
							LEFT JOIN SCM_DNM_DELIVERY_TRACKING T ON LD.COMPANY_ID = T.COMPANY_ID AND LD.SHIPMENT_NO = T.SHIPMENT_NO
							GROUP BY 
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
					  ORDER BY LD.BOD_ID'

EXEC (@MDQRY1 + @MDQRY2 + @MDQRY5);


-------------------------------------------------------------------------------------------------------------------------------
-- TABLE 2 : CI 80
-------------------------------------------------------------------------------------------------------------------------------		
EXEC (@MDQRY1 + @MDQRY2 + ' 

, W_DATA AS
(
	SELECT BOD_ID
	, Y_YEAR
	, AVG(CONVERT(NUMERIC(13,6), TTL) )  AS AVG
	, AVG(CONVERT(NUMERIC(13,6), TTL1))  AS AVG1
	, AVG(CONVERT(NUMERIC(13,6), TTL2))  AS AVG2
	, AVG(CONVERT(NUMERIC(13,6), TTL3))  AS AVG3
	, AVG(CONVERT(NUMERIC(13,6), TTL4))  AS AVG4
	, AVG(CONVERT(NUMERIC(13,6), TTL5))  AS AVG5

	, CONVERT(NUMERIC(13,6), STDEV(CONVERT(INTEGER, TTL) ))  AS TTL_STDEV 
	, CONVERT(NUMERIC(13,6), STDEV(CONVERT(INTEGER, TTL1)))  AS TTL1_STDEV
	, CONVERT(NUMERIC(13,6), STDEV(CONVERT(INTEGER, TTL2)))  AS TTL2_STDEV
	, CONVERT(NUMERIC(13,6), STDEV(CONVERT(INTEGER, TTL3)))  AS TTL3_STDEV
	, CONVERT(NUMERIC(13,6), STDEV(CONVERT(INTEGER, TTL4)))  AS TTL4_STDEV
	, CONVERT(NUMERIC(13,6), STDEV(CONVERT(INTEGER, TTL5)))  AS TTL5_STDEV
				
	, COUNT(TTL )    AS TTL_CNT
	, COUNT(TTL1)    AS TTL1_CNT
	, COUNT(TTL2)    AS TTL2_CNT
	, COUNT(TTL3)    AS TTL3_CNT
	, COUNT(TTL4)    AS TTL4_CNT
	, COUNT(TTL5)    AS TTL5_CNT

	FROM LD
	GROUP BY BOD_ID, Y_YEAR
)

	SELECT BOD_ID
		  ,Y_YEAR
		  ,AVG
		  ,AVG1 + AVG2 AS AVG12
		  ,AVG3
		  ,AVG4 + AVG5 AS AVG45

		  , TTL_STDEV 
		  , TTL1_STDEV + TTL2_STDEV AS  TTL12_STDEV
		  , TTL3_STDEV
		  , TTL4_STDEV + TTL5_STDEV AS TTL45_STDEV
		  
		  , TTL_CNT
		  , TTL1_CNT + TTL2_CNT AS TTL12_CNT
		  , TTL3_CNT
		  , TTL4_CNT + TTL5_CNT AS TTL45_CNT

		, TCI_TTL
		, TCI_TTL1 + TCI_TTL2 AS TCI_TTL12
		, TCI_TTL3
		, TCI_TTL4 + TCI_TTL5 AS TCI_TTL45

		  ,CASE WHEN CI_TTL_DOWN  IS NULL THEN '''' ELSE CONCAT(CI_TTL_DOWN , '' ~ '', CI_TTL_UP ) END AS CI_TTL
		  ,CASE WHEN CI_TTL1_DOWN IS NULL THEN '''' ELSE CONCAT(CI_TTL1_DOWN, '' ~ '', CI_TTL2_UP) END AS CI_TTL12
		  ,CASE WHEN CI_TTL3_DOWN IS NULL THEN '''' ELSE CONCAT(CI_TTL3_DOWN, '' ~ '', CI_TTL3_UP) END AS CI_TTL3
		  ,CASE WHEN CI_TTL4_DOWN IS NULL THEN '''' ELSE CONCAT(CI_TTL4_DOWN, '' ~ '', CI_TTL5_UP) END AS CI_TTL45


FROM
(
	SELECT BOD_ID
		  ,Y_YEAR
		  ,AVG
		  ,AVG1
		  ,AVG2
		  ,AVG3
		  ,AVG4
		  ,AVG5

		  , TTL_STDEV 
		  , TTL1_STDEV
		  , TTL2_STDEV
		  , TTL3_STDEV
		  , TTL4_STDEV
		  , TTL5_STDEV
		  
		  , TTL_CNT
		  , TTL1_CNT
		  , TTL2_CNT
		  , TTL3_CNT
		  , TTL4_CNT
		  , TTL5_CNT

		  ,CONVERT(INTEGER, CEILING(AVG + TCI_TTL )) AS CI_TTL_UP
		  ,CONVERT(INTEGER, CEILING(AVG1 + TCI_TTL1)) AS CI_TTL1_UP
		  ,CONVERT(INTEGER, CEILING(AVG2 + TCI_TTL2)) AS CI_TTL2_UP
		  ,CONVERT(INTEGER, CEILING(AVG3 + TCI_TTL3)) AS CI_TTL3_UP
		  ,CONVERT(INTEGER, CEILING(AVG4 + TCI_TTL4)) AS CI_TTL4_UP
		  ,CONVERT(INTEGER, CEILING(AVG5 + TCI_TTL5)) AS CI_TTL5_UP
													 
		  ,CONVERT(INTEGER, ROUND(AVG - TCI_TTL , 0, 1)) AS CI_TTL_DOWN
		  ,CONVERT(INTEGER, ROUND(AVG1 - TCI_TTL1, 0, 1)) AS CI_TTL1_DOWN
		  ,CONVERT(INTEGER, ROUND(AVG2 - TCI_TTL2, 0, 1)) AS CI_TTL2_DOWN
		  ,CONVERT(INTEGER, ROUND(AVG3 - TCI_TTL3, 0, 1)) AS CI_TTL3_DOWN
		  ,CONVERT(INTEGER, ROUND(AVG4 - TCI_TTL4, 0, 1)) AS CI_TTL4_DOWN
		  ,CONVERT(INTEGER, ROUND(AVG5 - TCI_TTL5, 0, 1)) AS CI_TTL5_DOWN

			  , TCI_TTL
			  , TCI_TTL1
			  , TCI_TTL2
			  , TCI_TTL3
			  , TCI_TTL4
			  , TCI_TTL5

	FROM
	(
		SELECT 	*
			  , CONVERT(NUMERIC(13,6) ,DBO.FN_GET_SCP_CONFIDENCE(0.2, TTL_STDEV , TTL_CNT) ) AS TCI_TTL
			  , CONVERT(NUMERIC(13,6) ,DBO.FN_GET_SCP_CONFIDENCE(0.2, TTL1_STDEV, TTL1_CNT)) AS TCI_TTL1
			  , CONVERT(NUMERIC(13,6) ,DBO.FN_GET_SCP_CONFIDENCE(0.2, TTL2_STDEV, TTL2_CNT)) AS TCI_TTL2
			  , CONVERT(NUMERIC(13,6) ,DBO.FN_GET_SCP_CONFIDENCE(0.2, TTL3_STDEV, TTL3_CNT)) AS TCI_TTL3
			  , CONVERT(NUMERIC(13,6) ,DBO.FN_GET_SCP_CONFIDENCE(0.2, TTL4_STDEV, TTL4_CNT)) AS TCI_TTL4
			  , CONVERT(NUMERIC(13,6) ,DBO.FN_GET_SCP_CONFIDENCE(0.2, TTL5_STDEV, TTL5_CNT)) AS TCI_TTL5

		FROM W_DATA

	)  DATA2
) DATA3
ORDER BY BOD_ID, Y_YEAR
');


-------------------------------------------------------------------------------------------------------------------------------
-- TABLE 3 : 검증 
-------------------------------------------------------------------------------------------------------------------------------	
EXEC (@MDQRY1 + @MDQRY2 + ' 

SELECT BOD_ID
      ,Y_YEAR
	  , TTL1
	  , TTL2
	  , TTL3
	  , TTL4
	  , TTL5
	  , TTL
FROM LD
WHERE BOD_ID = ''10163''
ORDER BY BOD_ID, Y_YEAR
');


END
