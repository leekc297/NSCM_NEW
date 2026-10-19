

/*
 * Program ID   : SSP0028_GET_DELIVERY_TRACKING_LT_DETAIL Copy => SCP0102_GET_BOD_VALIDATION_REPORT_DETAIL
 * Description  : Delivery Tracking LT
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2022/09/13   PARKTAEHAK		PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 신규추가
 * 2023-08-09   vadabi3         PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 BOD Validation Report) UI 개선 
 * 2023/08/23   vadabi3		    PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 개발DB 이슈로 백업본으로 복구
 * 2023/09/04   vadabi3		    PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 Detail 항목 추가
 * 2023/09/05   vadabi3		    PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 TTL Total
 * 2023/09/05   vadabi3		    PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 NDR
 * 2023/09/05   vadabi3		    PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 GAB
 * 2023/09/06   vadabi3		    PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 ETD
 * 2023/09/11   vadabi3		    PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 TTL5
 * 2023/10/16   vadabi3		    PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 GAP / TRK / TTL INCOTERMS 개선
 * 2023/10/27   vadabi3		    PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 ZLANDATA
 * 2023/10/27   vadabi3		    PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 POL_ATD_DATE
 * 2023/11/02   vadabi3		    PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 Inland ATD
 * 2024/11/29   jahn1502		TTL1 ~ TTL5 => TTL12, TTL3, TTL45 로 변경 및 TTL12 계산로직 변경
 * 2025/02/03   mrchois			PJ20249346 LGES SCP 개선과제 이행 - TTL45 계산로직 변경

------------------------------------------------------------------------------------------------------
 EXEC SCP0102_GET_BOD_VALIDATION_REPORT_DETAIL
 @p_division_id='40'
 , @p_from_yyyymmdd='20210907'
 , @p_to_yyyymmdd='20231007'
 , @p_from_site='G182-A'
 , @p_to_site='JMBS_PL_GWC'
 , @p_bod_id='2683'
 , @p_route_id ='3503'
 , @p_exfactory_from_yyyymmdd=''
 , @p_exfactory_to_yyyymmdd=''
 , @p_fdest_from_yyyymmdd=''
 , @p_fdest_to_yyyymmdd=''
 , @p_from_country=''
 , @p_to_country=''
 , @p_from_city='CNNKG'
 , @p_to_city='PLGIL'
 , @p_from_area=''
 , @p_to_area=''

*/

CREATE PROCEDURE [dbo].[SCP0102_GET_BOD_VALIDATION_REPORT_DETAIL]

    @p_division_id      NVARCHAR(10),
	@p_from_yyyymmdd  NVARCHAR(8),
    @p_to_yyyymmdd    NVARCHAR(8),	
	@p_from_site      NVARCHAR(MAX),
	@p_to_site      NVARCHAR(MAX),
	@p_bod_id      NVARCHAR(MAX),
	@p_route_id      NVARCHAR(MAX),
	@p_exfactory_from_yyyymmdd  NVARCHAR(8),
    @p_exfactory_to_yyyymmdd    NVARCHAR(8),
    @p_fdest_from_yyyymmdd  NVARCHAR(8),
    @p_fdest_to_yyyymmdd    NVARCHAR(8),

	@p_from_country NVARCHAR(MAX),
	@p_to_country NVARCHAR(MAX),
	@p_from_city NVARCHAR(MAX),
	@p_to_city NVARCHAR(MAX),
	@p_from_area NVARCHAR(MAX),
	@p_to_area NVARCHAR(MAX)
AS
BEGIN

  SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @mDQry1 NVARCHAR(MAX)='';
	DECLARE @mDQry2 NVARCHAR(MAX)='';

	DECLARE  @v_from_country NVARCHAR(MAX)='';
	DECLARE  @v_to_country NVARCHAR(MAX)='';	
	DECLARE  @v_from_city NVARCHAR(MAX)='';
	DECLARE  @v_to_city NVARCHAR(MAX)='';	

	SET @v_from_country = [dbo].FN_GET_IN_STR(@p_from_country);
	SET @v_to_country = [dbo].FN_GET_IN_STR(@p_to_country);	
	SET @v_from_city = [dbo].FN_GET_IN_STR(@p_from_city);
	SET @v_to_city = [dbo].FN_GET_IN_STR(@p_to_city);	

	SET @mDqry1 = @mDQry1 + ' SELECT INFO.DIVISION_ID ' + char(10);
	SET @mDqry1 = @mDQry1 + ' 	 , INFO.SHIPMENT_NO ' + char(10);
	SET @mDqry1 = @mDQry1 + ' 	 , INFO.CNTR_NO ' + char(10);
	SET @mDqry1 = @mDQry1 + ' 	 , INFO.BOD_ID ' + char(10);
	SET @mDqry1 = @mDQry1 + ' 	 , INFO.ROUTE_ID ' + char(10);
	SET @mDqry1 = @mDQry1 + ' 	 , INFO.FROM_SITE ' + char(10);
	SET @mDqry1 = @mDQry1 + ' 	 , INFO.TO_SITE ' + char(10);
	SET @mDqry1 = @mDQry1 + ' 	 , INFO.FROM_CITY ' + char(10);
	SET @mDqry1 = @mDQry1 + ' 	 , INFO.TO_CITY ' + char(10);
	SET @mDqry1 = @mDQry1 + ' 	 , INFO.POL_PORT ' + char(10);
	SET @mDqry1 = @mDQry1 + ' 	 , INFO.POD_PORT ' + char(10);
	SET @mDqry1 = @mDQry1 + ' 	 , INFO.F_DEST_CODE ' + char(10);
	SET @mDqry1 = @mDQry1 + ' 	 , INFO.INCOTERMS ' + char(10);
	SET @mDqry1 = @mDQry1 + ' 	 , INFO.CARRIER ' + char(10);
	--SET @mDqry1 = @mDQry1 + ' 	 , INFO.INLAND_ATD ' + char(10);
	SET @mDqry1 = @mDQry1 + ' 	 , INFO.POL_ATA ' + char(10);
	SET @mDqry1 = @mDQry1 + ' 	 , INFO.POL_ATD ' + char(10);
	SET @mDqry1 = @mDQry1 + ' 	 , INFO.POD_ATA ' + char(10);
	SET @mDqry1 = @mDQry1 + ' 	 , INFO.POD_ATD ' + char(10);
	SET @mDqry1 = @mDQry1 + ' 	 , INFO.VMI_ATA ' + char(10);
	SET @mDqry1 = @mDQry1 + ' 	 , INFO.VMI_ATD ' + char(10);
	SET @mDqry1 = @mDQry1 + ' 	 , INFO.F_DEST_ATA ' + char(10);
	SET @mDqry1 = @mDQry1 + ' 	 , INFO.CONFIRM_ID ' + char(10);
	SET @mDqry1 = @mDQry1 + ' 	 , INFO.NDR1 ' + char(10);
	SET @mDqry1 = @mDQry1 + ' 	 , INFO.NDR2 ' + char(10);
	SET @mDqry1 = @mDQry1 + ' 	 , INFO.NDR3 ' + char(10);
	SET @mDqry1 = @mDQry1 + ' 	 , INFO.NDR4 ' + char(10);
	SET @mDqry1 = @mDQry1 + ' 	 , INFO.NDR5 ' + char(10);
	SET @mDqry1 = @mDQry1 + ' 	 , INFO.NDR ' + char(10);
	SET @mDqry1 = @mDQry1 + ' 	 , INFO.GAP1 ' + char(10);
	SET @mDqry1 = @mDQry1 + ' 	 , INFO.GAP2 ' + char(10);
	SET @mDqry1 = @mDQry1 + ' 	 , INFO.GAP3 ' + char(10);
	SET @mDqry1 = @mDQry1 + ' 	 , INFO.GAP4 ' + char(10);
	SET @mDqry1 = @mDQry1 + ' 	 , INFO.GAP5 ' + char(10);
	SET @mDqry1 = @mDQry1 + ' 	 , INFO.TTL12 ' + char(10);
	--SET @mDqry1 = @mDQry1 + ' 	 , INFO.TTL1 + INFO.TTL2 AS TTL12 ' + char(10);
	SET @mDqry1 = @mDQry1 + ' 	 , INFO.TTL3 ' + char(10);
	--SET @mDqry1 = @mDQry1 + ' 	 , INFO.TTL4 + INFO.TTL5 AS TTL45 ' + char(10);
	SET @mDqry1 = @mDQry1 + ' 	 , INFO.TTL45 ' + char(10);	-- TTL45 계산로직 변경 추가 (2025-02-03 mrchois)
	SET @mDqry1 = @mDQry1 + ' 	 , INFO.TTL ' + char(10);
	SET @mDqry1 = @mDQry1 + ' 	 , INFO.DR1 ' + char(10);
	SET @mDqry1 = @mDQry1 + ' 	 , INFO.DR2 ' + char(10);
	SET @mDqry1 = @mDQry1 + ' 	 , INFO.DR3 ' + char(10);
	SET @mDqry1 = @mDQry1 + ' 	 , INFO.DR4 ' + char(10);
	SET @mDqry1 = @mDQry1 + ' 	 , INFO.DR5 ' + char(10);
	SET @mDqry1 = @mDQry1 + ' 	 , INFO.DRTTL ' + char(10);
	SET @mDqry1 = @mDQry1 + ' 	 , INFO.TTL_INCOTERMS ' + char(10);
	SET @mDqry1 = @mDQry1 + ' 	 , INFO.DRTTL_INCOTERMS ' + char(10);
	SET @mDqry1 = @mDQry1 + ' 	 , INFO.NDR_INCOTERMS ' + char(10);
	SET @mDqry1 = @mDQry1 + ' 	 , INFO.POL_AREA ' + char(10);
	SET @mDqry1 = @mDQry1 + ' 	 , INFO.POD_AREA  ' + char(10);
	SET @mDqry1 = @mDQry1 + ' 	 , INFO.EXFACTORY  ' + char(10);
	--SET @mDqry1 = @mDQry1 + ' 	 , INFO.EXFACTORY AS INLAND_ATD ' + char(10);
	SET @mDqry1 = @mDQry1 + ' 	 , INFO.PLANT_ISSUE AS INLAND_ATD ' + char(10);
	SET @mDqry1 = @mDQry1 + ' 	 , INFO.POL_ETA      ' + char(10);
	SET @mDqry1 = @mDQry1 + ' 	 , INFO.POD_ETA   ' + char(10);
	SET @mDqry1 = @mDQry1 + ' 	 , INFO.VMI_ETA   ' + char(10);
	SET @mDqry1 = @mDQry1 + ' 	 , INFO.F_DEST_ETA   ' + char(10);
	SET @mDqry1 = @mDQry1 + ' 	 , INFO.POL_ETD       ' + char(10);
	SET @mDqry1 = @mDQry1 + ' 	 , INFO.POD_ETD   ' + char(10);
	SET @mDqry1 = @mDQry1 + ' 	 , INFO.VMI_ETD   ' + char(10);
	SET @mDqry1 = @mDQry1 + ' 	 , INFO.GAP ' + char(10);
	SET @mDqry1 = @mDQry1 + ' 	 , INFO.GAP1_NDR ' + char(10);
	SET @mDqry1 = @mDQry1 + ' 	 , INFO.GAP2_NDR ' + char(10);
	SET @mDqry1 = @mDQry1 + ' 	 , INFO.GAP3_NDR ' + char(10);
	SET @mDqry1 = @mDQry1 + ' 	 , INFO.GAP4_NDR ' + char(10);
	SET @mDqry1 = @mDQry1 + ' 	 , INFO.GAP5_NDR ' + char(10);
	SET @mDqry1 = @mDQry1 + ' 	 , INFO.GAP_NDR ' + char(10);
	SET @mDqry1 = @mDQry1 + ' 	 , INFO.GAP_INCOTERMS ' + char(10);
	SET @mDqry1 = @mDQry1 + ' 	 , INFO.GAP_NDR_INCOTERMS ' + char(10);
	SET @mDqry1 = @mDQry1 + ' 	 , INFO.INCOTERMS_SSP ' + char(10);
	SET @mDqry1 = @mDQry1 + ' 	 , INFO.TRANSPORT_MODE ' + char(10);
	SET @mDqry1 = @mDQry1 + ' FROM ( ' + char(10);
	SET @mDqry1 = @mDQry1 + ' SELECT LIST.*' + char(10);
	----------------------------------------------------------------------------------------------------
	SET @mDqry1 = @mDQry1 + ', CASE WHEN TRANSPORT_MODE = ''TRK'' ' + char(10);
	SET @mDqry1 = @mDQry1 + '       THEN TTL - DRTTL ' + char(10);
	SET @mDqry1 = @mDQry1 + '       ELSE GAP1+GAP2+GAP3+GAP4+GAP5 ' + char(10);
	SET @mDqry1 = @mDQry1 + '       END AS GAP ' + char(10);
	----------------------------------------------------------------------------------------------------
	SET @mDqry1 = @mDQry1 + '      , TTL1 - NDR1 						AS GAP1_NDR ' + char(10);
	SET @mDqry1 = @mDQry1 + '      , TTL2 - NDR2 						AS GAP2_NDR ' + char(10);
	SET @mDqry1 = @mDQry1 + '      , TTL3 - NDR3 						AS GAP3_NDR ' + char(10);
	SET @mDqry1 = @mDQry1 + '      , TTL4 - NDR4 						AS GAP4_NDR ' + char(10);
	SET @mDqry1 = @mDQry1 + '      , TTL5 - NDR5 						AS GAP5_NDR ' + char(10);
	SET @mDqry1 = @mDQry1 + '      , TTL -  NDR                         AS GAP_NDR  ' + char(10);


	-- GAP INCOTERMS ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    SET @mDqry1 = @mDQry1 + ' , CASE  WHEN INCOTERMS = ''A01''  THEN 0																																							 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN INCOTERMS = ''Z01''  THEN 0																																							 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN INCOTERMS = ''Z04''  THEN 0																																							 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN INCOTERMS = ''EXW''  THEN 0																																							 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN INCOTERMS = ''FCA''  AND  GAP1 IS NULL  THEN NULL 																																	 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN INCOTERMS = ''FAS''  AND  GAP1 IS NULL  THEN NULL 																																	 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN INCOTERMS = ''FOB''  AND (GAP1 IS NULL OR GAP2 IS NULL )  THEN NULL 																												 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN INCOTERMS = ''CFR''  AND (GAP1 IS NULL OR GAP2 IS NULL )  THEN NULL 																												 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN INCOTERMS = ''CIF''  AND (GAP1 IS NULL OR GAP2 IS NULL )  THEN NULL 																												 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN INCOTERMS = ''CIP''  AND (GAP1 IS NULL OR GAP2 IS NULL )  THEN NULL 																												 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN INCOTERMS = ''CPT''  AND (GAP1 IS NULL OR GAP2 IS NULL )  THEN NULL 																												 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN INCOTERMS = ''Z02''  AND (GAP1 IS NULL OR GAP2 IS NULL OR GAP3 IS NULL OR GAP4 IS NULL OR GAP5 IS NULL )   THEN NULL 																 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN INCOTERMS = ''DAT''  AND (GAP1 IS NULL OR GAP2 IS NULL OR GAP3 IS NULL OR GAP4 IS NULL OR GAP5 IS NULL )   THEN NULL 																 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN INCOTERMS = ''DAP''  AND (GAP1 IS NULL OR GAP2 IS NULL OR GAP3 IS NULL OR GAP4 IS NULL OR GAP5 IS NULL )   THEN NULL 																 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN INCOTERMS = ''DDP''  AND (GAP1 IS NULL OR GAP2 IS NULL OR GAP3 IS NULL OR GAP4 IS NULL OR GAP5 IS NULL )   THEN NULL 																 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN INCOTERMS = ''DDU''  AND (GAP1 IS NULL OR GAP2 IS NULL OR GAP3 IS NULL OR GAP4 IS NULL OR GAP5 IS NULL )   THEN NULL 																 ' + char(10);
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	SET @mDqry1 = @mDQry1 + '		  WHEN INCOTERMS = ''FCA''  THEN CONVERT(INT, GAP1)																																		 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN INCOTERMS = ''FAS''  THEN CONVERT(INT, GAP1)																																		 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN INCOTERMS = ''FOB''  THEN ISNULL(CONVERT(INT, GAP1),0) + ISNULL(CONVERT(INT,GAP2),0)																								 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN INCOTERMS = ''CFR''  THEN ISNULL(CONVERT(INT, GAP1),0) + ISNULL(CONVERT(INT,GAP2),0)																								 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN INCOTERMS = ''CIF''  THEN ISNULL(CONVERT(INT, GAP1),0) + ISNULL(CONVERT(INT,GAP2),0)																								 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN INCOTERMS = ''CIP''  THEN ISNULL(CONVERT(INT, GAP1),0) + ISNULL(CONVERT(INT,GAP2),0)																								 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN INCOTERMS = ''CPT''  THEN ISNULL(CONVERT(INT, GAP1),0) + ISNULL(CONVERT(INT,GAP2),0)																								 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN INCOTERMS = ''Z02''  THEN ISNULL(CONVERT(INT, GAP1),0) + ISNULL(CONVERT(INT,GAP2),0) + ISNULL(CONVERT(INT,GAP3),0) + ISNULL(CONVERT(INT, GAP4),0) + ISNULL(CONVERT(INT, GAP5),0) 	 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN INCOTERMS = ''DAT''  THEN ISNULL(CONVERT(INT, GAP1),0) + ISNULL(CONVERT(INT,GAP2),0) + ISNULL(CONVERT(INT,GAP3),0) + ISNULL(CONVERT(INT, GAP4),0) + ISNULL(CONVERT(INT, GAP5),0) 	 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN INCOTERMS = ''DAP''  THEN ISNULL(CONVERT(INT, GAP1),0) + ISNULL(CONVERT(INT,GAP2),0) + ISNULL(CONVERT(INT,GAP3),0) + ISNULL(CONVERT(INT, GAP4),0) + ISNULL(CONVERT(INT, GAP5),0) 	 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN INCOTERMS = ''DDP''  THEN ISNULL(CONVERT(INT, GAP1),0) + ISNULL(CONVERT(INT,GAP2),0) + ISNULL(CONVERT(INT,GAP3),0) + ISNULL(CONVERT(INT, GAP4),0) + ISNULL(CONVERT(INT, GAP5),0) 	 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN INCOTERMS = ''DDU''  THEN ISNULL(CONVERT(INT, GAP1),0) + ISNULL(CONVERT(INT,GAP2),0) + ISNULL(CONVERT(INT,GAP3),0) + ISNULL(CONVERT(INT, GAP4),0) + ISNULL(CONVERT(INT, GAP5),0) 	 ' + char(10);
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	SET @mDqry1 = @mDQry1 + '         WHEN TRANSPORT_MODE = ''TRK''  AND INCOTERMS = ''EXW''  THEN 0																															    ' + char(10);
	SET @mDqry1 = @mDQry1 + '         WHEN TRANSPORT_MODE = ''TRK''  AND (GAP1 IS NULL AND GAP2 IS NULL AND GAP3 IS NULL AND GAP4 IS NULL AND GAP5 IS NULL ) THEN NULL																	' + char(10);
	SET @mDqry1 = @mDQry1 + '         WHEN TRANSPORT_MODE = ''TRK''  THEN ISNULL(CONVERT(INT, GAP1),0) + ISNULL(CONVERT(INT,GAP2),0) + ISNULL(CONVERT(INT,GAP3),0) + ISNULL(CONVERT(INT, GAP4),0) + ISNULL(CONVERT(INT, GAP5),0)	' + char(10);
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	SET @mDqry1 = @mDQry1 + '		  WHEN (GAP1 IS NULL OR GAP2 IS NULL OR GAP3 IS NULL OR GAP4 IS NULL OR GAP5 IS NULL ) THEN NULL	' + char(10);
	SET @mDqry1 = @mDQry1 + '         ELSE 0		' + char(10);
	SET @mDqry1 = @mDQry1 + '        END AS GAP_INCOTERMS	 ' + char(10); -- LOOKUP INCOTERMS : 20230905																																					 
		
		
	-- GAP NDR INCOTERMS ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	SET @mDqry1 = @mDQry1 + ' , CASE  WHEN INCOTERMS = ''A01''  THEN 0																																						 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN INCOTERMS = ''Z01''  THEN 0																																						 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN INCOTERMS = ''Z04''  THEN 0																																						 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN INCOTERMS = ''EXW''  THEN 0																																						 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN INCOTERMS = ''FCA''  AND  TTL1 IS NULL OR NDR1 IS NULL  THEN NULL 																												 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN INCOTERMS = ''FAS''  AND  TTL1 IS NULL OR NDR1 IS NULL  THEN NULL 																												 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN INCOTERMS = ''FOB''  AND (TTL1 IS NULL OR TTL2 IS NULL 
	                                                              OR NDR1 IS NULL OR NDR2 IS NULL) THEN NULL 																												 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN INCOTERMS = ''CFR''  AND (TTL1 IS NULL OR TTL2 IS NULL 
	                                                              OR NDR1 IS NULL OR NDR2 IS NULL) THEN NULL 																												 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN INCOTERMS = ''CIF''  AND (TTL1 IS NULL OR TTL2 IS NULL 
	                                                              OR NDR1 IS NULL OR NDR2 IS NULL) THEN NULL 																												 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN INCOTERMS = ''CIP''  AND (TTL1 IS NULL OR TTL2 IS NULL 
	                                                              OR NDR1 IS NULL OR NDR2 IS NULL) THEN NULL 																												 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN INCOTERMS = ''CPT''  AND (TTL1 IS NULL OR TTL2 IS NULL 
	                                                              OR NDR1 IS NULL OR NDR2 IS NULL) THEN NULL 																												 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN INCOTERMS = ''Z02''  AND (TTL1 IS NULL OR TTL2 IS NULL OR TTL3 IS NULL OR TTL4 IS NULL OR TTL5 IS NULL 
																 OR  NDR1 IS NULL OR NDR2 IS NULL OR NDR3 IS NULL OR NDR4 IS NULL OR NDR5 IS NULL )   THEN NULL 			 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN INCOTERMS = ''DAT''  AND (TTL1 IS NULL OR TTL2 IS NULL OR TTL3 IS NULL OR TTL4 IS NULL OR TTL5 IS NULL 
																 OR  NDR1 IS NULL OR NDR2 IS NULL OR NDR3 IS NULL OR NDR4 IS NULL OR NDR5 IS NULL )   THEN NULL 			 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN INCOTERMS = ''DAP''  AND (TTL1 IS NULL OR TTL2 IS NULL OR TTL3 IS NULL OR TTL4 IS NULL OR TTL5 IS NULL 
																 OR  NDR1 IS NULL OR NDR2 IS NULL OR NDR3 IS NULL OR NDR4 IS NULL OR NDR5 IS NULL )   THEN NULL 			 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN INCOTERMS = ''DDP''  AND (TTL1 IS NULL OR TTL2 IS NULL OR TTL3 IS NULL OR TTL4 IS NULL OR TTL5 IS NULL 
																 OR  NDR1 IS NULL OR NDR2 IS NULL OR NDR3 IS NULL OR NDR4 IS NULL OR NDR5 IS NULL )   THEN NULL 			 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN INCOTERMS = ''DDU''  AND (TTL1 IS NULL OR TTL2 IS NULL OR TTL3 IS NULL OR TTL4 IS NULL OR TTL5 IS NULL 
																 OR  NDR1 IS NULL OR NDR2 IS NULL OR NDR3 IS NULL OR NDR4 IS NULL OR NDR5 IS NULL )   THEN NULL 			 ' + char(10);
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	SET @mDqry1 = @mDQry1 + '		  WHEN INCOTERMS = ''FCA''  THEN CONVERT(INT, TTL1 - NDR1)																																		 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN INCOTERMS = ''FAS''  THEN CONVERT(INT, TTL1 - NDR1)																																		 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN INCOTERMS = ''FOB''  THEN ISNULL(CONVERT(INT, TTL1 - NDR1),0) + ISNULL(CONVERT(INT,TTL2 - NDR2),0)																								 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN INCOTERMS = ''CFR''  THEN ISNULL(CONVERT(INT, TTL1 - NDR1),0) + ISNULL(CONVERT(INT,TTL2 - NDR2),0)																								 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN INCOTERMS = ''CIF''  THEN ISNULL(CONVERT(INT, TTL1 - NDR1),0) + ISNULL(CONVERT(INT,TTL2 - NDR2),0)																								 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN INCOTERMS = ''CIP''  THEN ISNULL(CONVERT(INT, TTL1 - NDR1),0) + ISNULL(CONVERT(INT,TTL2 - NDR2),0)																								 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN INCOTERMS = ''CPT''  THEN ISNULL(CONVERT(INT, TTL1 - NDR1),0) + ISNULL(CONVERT(INT,TTL2 - NDR2),0)																								 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN INCOTERMS = ''Z02''  THEN ISNULL(CONVERT(INT, TTL1 - NDR1),0) + ISNULL(CONVERT(INT,TTL2 - NDR2),0) + ISNULL(CONVERT(INT,TTL3 - NDR3),0) + ISNULL(CONVERT(INT, TTL4 - NDR4),0) + ISNULL(CONVERT(INT, TTL5 - NDR5),0)  ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN INCOTERMS = ''DAT''  THEN ISNULL(CONVERT(INT, TTL1 - NDR1),0) + ISNULL(CONVERT(INT,TTL2 - NDR2),0) + ISNULL(CONVERT(INT,TTL3 - NDR3),0) + ISNULL(CONVERT(INT, TTL4 - NDR4),0) + ISNULL(CONVERT(INT, TTL5 - NDR5),0)  ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN INCOTERMS = ''DAP''  THEN ISNULL(CONVERT(INT, TTL1 - NDR1),0) + ISNULL(CONVERT(INT,TTL2 - NDR2),0) + ISNULL(CONVERT(INT,TTL3 - NDR3),0) + ISNULL(CONVERT(INT, TTL4 - NDR4),0) + ISNULL(CONVERT(INT, TTL5 - NDR5),0)  ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN INCOTERMS = ''DDP''  THEN ISNULL(CONVERT(INT, TTL1 - NDR1),0) + ISNULL(CONVERT(INT,TTL2 - NDR2),0) + ISNULL(CONVERT(INT,TTL3 - NDR3),0) + ISNULL(CONVERT(INT, TTL4 - NDR4),0) + ISNULL(CONVERT(INT, TTL5 - NDR5),0)  ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN INCOTERMS = ''DDU''  THEN ISNULL(CONVERT(INT, TTL1 - NDR1),0) + ISNULL(CONVERT(INT,TTL2 - NDR2),0) + ISNULL(CONVERT(INT,TTL3 - NDR3),0) + ISNULL(CONVERT(INT, TTL4 - NDR4),0) + ISNULL(CONVERT(INT, TTL5 - NDR5),0)  ' + char(10);
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	SET @mDqry1 = @mDQry1 + '         WHEN TRANSPORT_MODE = ''TRK''  AND INCOTERMS = ''EXW''  THEN 0																															    ' + char(10);
	SET @mDqry1 = @mDQry1 + '         WHEN TRANSPORT_MODE = ''TRK''  AND (    TTL1 IS NULL 
	                                                                      AND TTL2 IS NULL
																		  AND TTL3 IS NULL 
																		  AND TTL4 IS NULL 
																		  AND TTL5 IS NULL 
																		  AND NDR1 IS NULL 
	                                                                      AND NDR2 IS NULL 
																		  AND NDR3 IS NULL 
																		  AND NDR4 IS NULL 
																		  AND NDR5 IS NULL 
																		  ) THEN NULL							' + char(10);
	SET @mDqry1 = @mDQry1 + '         WHEN TRANSPORT_MODE = ''TRK''  THEN ISNULL(CONVERT(INT, TTL1 - NDR1),0) 
																		+ ISNULL(CONVERT(INT, TTL2 - NDR2),0) 
																		+ ISNULL(CONVERT(INT, TTL3 - NDR3),0) 
																		+ ISNULL(CONVERT(INT, TTL4 - NDR4),0) 
																		+ ISNULL(CONVERT(INT, TTL5 - NDR5),0)	' + char(10);
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	SET @mDqry1 = @mDQry1 + '		  WHEN  (TTL1 IS NULL OR TTL2 IS NULL OR TTL3 IS NULL OR TTL4 IS NULL OR TTL5 IS NULL 
										OR   NDR1 IS NULL OR NDR2 IS NULL OR NDR3 IS NULL OR NDR4 IS NULL OR NDR5 IS NULL )   THEN NULL 			 ' + char(10);
	SET @mDqry1 = @mDQry1 + '         ELSE 0		' + char(10);
	SET @mDqry1 = @mDQry1 + '        END AS GAP_NDR_INCOTERMS	 ' + char(10); -- LOOKUP INCOTERMS : 20230905	

	--SET @mDqry1 = @mDQry1 + '       ,INCOTERMS_SSP ' + char(10);
	--SET @mDqry1 = @mDQry1 + '       ,TRANSPORT_MODE ' + char(10);	
	SET @mDqry1 = @mDqry1 + '  FROM ( ' + char(10);
	----------------------------------------------------------------------------------------------------
	SET @mDqry1 = @mDQry1 + ' SELECT DIVISION_ID ' + char(10);
    SET @mDqry1 = @mDQry1 + '       ,DATA.COMPANY_ID' + char(10);
    SET @mDqry1 = @mDQry1 + '       ,DATA.SHIPMENT_NO' + char(10);
    SET @mDqry1 = @mDQry1 + '       ,CNTR_NO' + char(10);
    SET @mDqry1 = @mDQry1 + '       ,BOD_ID' + char(10);
	SET @mDqry1 = @mDQry1 + '       ,ROUTE_ID' + char(10);
	SET @mDqry1 = @mDQry1 + '       ,FROM_SITE' + char(10);
	SET @mDqry1 = @mDQry1 + '       ,TO_SITE' + char(10);
	SET @mDqry1 = @mDQry1 + '       ,FROM_CITY' + char(10);
	SET @mDqry1 = @mDQry1 + '       ,TO_CITY' + char(10);
	SET @mDqry1 = @mDQry1 + '       ,DATA.POL AS POL_PORT' + char(10);
	SET @mDqry1 = @mDQry1 + '       ,DATA.POD AS POD_PORT' + char(10);
	SET @mDqry1 = @mDQry1 + '       ,DATA.F_DEST_PORT_CODE AS F_DEST_CODE' + char(10);
	SET @mDqry1 = @mDQry1 + '       ,DATA.INCOTERMS' + char(10);
	SET @mDqry1 = @mDQry1 + '       ,DATA.CARRIER' + char(10);
	SET @mDqry1 = @mDQry1 + '       ,INLAND_ATD ' + char(10);
    SET @mDqry1 = @mDQry1 + '       ,POL_ATA ' + char(10);
    SET @mDqry1 = @mDQry1 + '       ,POL_ATD' + char(10);
    SET @mDqry1 = @mDQry1 + '       ,POD_ATA' + char(10);
    SET @mDqry1 = @mDQry1 + '       ,POD_ATD' + char(10);
    SET @mDqry1 = @mDQry1 + '       ,VMI_ATA  ---허부 ATA ?  ' + char(10);
    SET @mDqry1 = @mDQry1 + '       ,VMI_ATD ---허부 ATD ?' + char(10);
    SET @mDqry1 = @mDQry1 + '       ,F_DEST_ATA' + char(10);
	SET @mDqry1 = @mDQry1 + '       ,confirm_id' + char(10);
	-- NDR1 ---------------------------------------------------------------------------------------------
	SET @mDqry1 = @mDQry1 + '       , NDR1	     ' + char(10);
	SET @mDqry1 = @mDQry1 + '       , NDR2		 ' + char(10);
	SET @mDqry1 = @mDQry1 + '       , NDR3		 ' + char(10);
	SET @mDqry1 = @mDQry1 + '       , NDR4		 ' + char(10);
	SET @mDqry1 = @mDQry1 + '       , NDR5		 ' + char(10);
	SET @mDqry1 = @mDQry1 + '       , NDR		 ' + char(10);
	-- GAP ---------------------------------------------------------------------------------------------
	SET @mDqry1 = @mDQry1 + '	,CONVERT(INT,CASE WHEN ISDATE(INLAND_ATD)=1 AND ISDATE(POL_ATA) = 1 THEN CONVERT(nvarchar, DATEDIFF(DD, INLAND_ATD,POL_ATA)) ELSE NULL END)  - DR1		AS GAP1   ' + char(10);--GAP1 Column 추가(덕원)	-- INT형으로 자료형 변환(덕원)
	SET @mDqry1 = @mDQry1 + '	,CONVERT(INT,CASE WHEN ISDATE(POL_ATA) = 1  AND ISDATE(POL_ATD) = 1 THEN CONVERT(nvarchar, DATEDIFF(DD, POL_ATA,   POL_ATD)) ELSE NULL END)  - DR2		AS GAP2	  ' + char(10);--GAP2 Column 추가(덕원) -- INT형으로 자료형 변환(덕원)
	SET @mDqry1 = @mDQry1 + '	,CONVERT(INT,CASE WHEN ISDATE(POL_ATD) = 1  AND ISDATE(POD_ATA) = 1 THEN CONVERT(nvarchar, DATEDIFF(DD, POL_ATD,   POD_ATA)) ELSE NULL END)  - DR3		AS GAP3   ' + char(10);--GAP3 Column 추가(덕원) -- INT형으로 자료형 변환(덕원)
	SET @mDqry1 = @mDQry1 + '	,CONVERT(INT,CASE WHEN ISDATE(POD_ATA) = 1  AND ISDATE(POD_ATD) = 1 THEN CONVERT(nvarchar, DATEDIFF(DD, POD_ATA,   POD_ATD)) ELSE NULL END)  - DR4		AS GAP4   ' + char(10);--GAP4 Column 추가(덕원) -- INT형으로 자료형 변환(덕원)
	SET @mDqry1 = @mDQry1 + '	,CONVERT(INT,																																					  ' + char(10)
    SET @mDqry1 = @mDQry1 + '	    CASE 																																						  ' + char(10)
	SET @mDqry1 = @mDQry1 + '		WHEN VMI_YN = ''Y'' AND ISDATE(F_DEST_ATA) = 1 AND ISDATE(POD_ATD) = 1 THEN CONVERT(nvarchar, DATEDIFF(DD,POD_ATD,F_DEST_ATA))								  ' + char(10)
	SET @mDqry1 = @mDQry1 + '		WHEN VMI_YN = ''Y'' AND ISDATE(VMI_ATA)    = 1 AND ISDATE(POD_ATD) = 1 THEN CONVERT(nvarchar, DATEDIFF(DD,POD_ATD,VMI_ATA))									  ' + char(10)
	SET @mDqry1 = @mDQry1 + '		WHEN VMI_YN = ''N'' AND ISDATE(F_DEST_ATA) = 1 AND ISDATE(POD_ATD) = 1 THEN CONVERT(nvarchar, DATEDIFF(DD,POD_ATD,F_DEST_ATA))								  ' + char(10)
	SET @mDqry1 = @mDQry1 + '		ELSE NULL 																																					  ' + char(10)
	SET @mDqry1 = @mDQry1 + '		END) - DR5																																			 AS GAP5	  ' + char(10) -- GAP5 재정의 : TTL5 로직 재정의와 연계(덕원)
    -- TTL ---------------------------------------------------------------------------------------------
	SET @mDqry1 = @mDQry1 + '       ,TTL1' + char(10);
	SET @mDqry1 = @mDQry1 + '       ,TTL2' + char(10);
	SET @mDqry1 = @mDQry1 + '       ,TTL12' + char(10);
	SET @mDqry1 = @mDQry1 + '       ,TTL3' + char(10);
	SET @mDqry1 = @mDQry1 + '       ,TTL4' + char(10);
	SET @mDqry1 = @mDQry1 + '       ,TTL5' + char(10);
	SET @mDqry1 = @mDQry1 + '       ,TTL45' + char(10);	-- TTL45 계산로직 변경 추가 (2025-02-03 mrchois)
	/*SET @mDqry1 = @mDQry1 + ' , CASE  WHEN TRANSPORT_MODE = ''TRK''  
									   AND DATA.INCOTERMS = ''EXW''  	
									  THEN 0     ' + char(10);
	SET @mDqry1 = @mDQry1 + '         WHEN TRANSPORT_MODE = ''TRK''  
	                                   AND TTL1 IS NULL 
									   AND TTL2 IS NULL 
									   AND TTL3 IS NULL 
									   AND TTL4 IS NULL 
									   AND TTL5 IS NULL 
									  THEN NULL  ' + char(10);
	SET @mDqry1 = @mDQry1 + '         WHEN TRANSPORT_MODE = ''TRK'' THEN ISNULL(CONVERT(INT, TTL1),0) + ISNULL(CONVERT(INT,TTL2),0) + ISNULL(CONVERT(INT,TTL3),0) + ISNULL(CONVERT(INT, TTL4),0) + ISNULL(CONVERT(INT, TTL5),0) ' + char(10);
	SET @mDqry1 = @mDQry1 + '         WHEN TTL1 IS NULL THEN NULL' + char(10);
	SET @mDqry1 = @mDQry1 + ' 	      WHEN TTL2 IS NULL THEN NULL' + char(10);
	SET @mDqry1 = @mDQry1 + ' 	      WHEN TTL3 IS NULL THEN NULL' + char(10);
	SET @mDqry1 = @mDQry1 + ' 	      WHEN TTL4 IS NULL THEN NULL' + char(10);
	SET @mDqry1 = @mDQry1 + ' 	      WHEN TTL5 IS NULL THEN NULL' + char(10);	
	SET @mDqry1 = @mDQry1 + '         ELSE ISNULL(CONVERT(INT, TTL1),0) + ISNULL(CONVERT(INT,TTL2),0) + ISNULL(CONVERT(INT,TTL3),0) + ISNULL(CONVERT(INT, TTL4),0) + ISNULL(CONVERT(INT, TTL5),0) 	' + char(10);
	SET @mDqry1 = @mDQry1 + '         END AS TTL	 ' + char(10);*/	  -- 20230901	
	SET @mDqry1 = @mDQry1 + ' 	    ,CASE WHEN F_DEST_ATA IS NOT NULL AND F_DEST_ATA <> '''' THEN CONVERT(nvarchar, DATEDIFF(DD,INLAND_ATD,F_DEST_ATA)) ELSE 0 END AS TTL ' + char(10); --변경 F_DEST_ATA - PI 오형선선임 2024.12
    -- DR ---------------------------------------------------------------------------------------------
	SET @mDqry1 = @mDQry1 + '       ,DR1' + char(10);
	SET @mDqry1 = @mDQry1 + '       ,DR2' + char(10);
	SET @mDqry1 = @mDQry1 + '       ,DR3' + char(10);
	SET @mDqry1 = @mDQry1 + '       ,DR4' + char(10);
	SET @mDqry1 = @mDQry1 + '       ,DR5' + char(10);
	SET @mDqry1 = @mDQry1 + '       ,ISNULL(CONVERT(INT, DR1),0) + ISNULL(CONVERT(INT,DR2),0) + ISNULL(CONVERT(INT,DR3),0) + ISNULL(CONVERT(INT, DR4),0) + ISNULL(CONVERT(INT, DR5),0)	AS DRTTL									' + char(10);
	

	-- TTL INCOTERMS ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	SET @mDqry1 = @mDQry1 + '  ,CASE  WHEN DATA.INCOTERMS = ''A01''  THEN 0																																							 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN DATA.INCOTERMS = ''Z01''  THEN 0																																							 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN DATA.INCOTERMS = ''Z04''  THEN 0																																							 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN DATA.INCOTERMS = ''EXW''  THEN 0																																							 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN DATA.INCOTERMS = ''FCA''  AND  TTL1 IS NULL  THEN NULL 																																	 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN DATA.INCOTERMS = ''FAS''  AND  TTL1 IS NULL  THEN NULL 																																	 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN DATA.INCOTERMS = ''FOB''  AND (TTL1 IS NULL OR TTL2 IS NULL )  THEN NULL 																												 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN DATA.INCOTERMS = ''CFR''  AND (TTL1 IS NULL OR TTL2 IS NULL )  THEN NULL 																												 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN DATA.INCOTERMS = ''CIF''  AND (TTL1 IS NULL OR TTL2 IS NULL )  THEN NULL 																												 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN DATA.INCOTERMS = ''CIP''  AND (TTL1 IS NULL OR TTL2 IS NULL )  THEN NULL 																												 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN DATA.INCOTERMS = ''CPT''  AND (TTL1 IS NULL OR TTL2 IS NULL )  THEN NULL 																												 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN DATA.INCOTERMS = ''Z02''  AND (TTL1 IS NULL OR TTL2 IS NULL OR TTL3 IS NULL OR TTL4 IS NULL OR TTL5 IS NULL )   THEN NULL 																 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN DATA.INCOTERMS = ''DAT''  AND (TTL1 IS NULL OR TTL2 IS NULL OR TTL3 IS NULL OR TTL4 IS NULL OR TTL5 IS NULL )   THEN NULL 																 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN DATA.INCOTERMS = ''DAP''  AND (TTL1 IS NULL OR TTL2 IS NULL OR TTL3 IS NULL OR TTL4 IS NULL OR TTL5 IS NULL )   THEN NULL 																 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN DATA.INCOTERMS = ''DDP''  AND (TTL1 IS NULL OR TTL2 IS NULL OR TTL3 IS NULL OR TTL4 IS NULL OR TTL5 IS NULL )   THEN NULL 																 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN DATA.INCOTERMS = ''DDU''  AND (TTL1 IS NULL OR TTL2 IS NULL OR TTL3 IS NULL OR TTL4 IS NULL OR TTL5 IS NULL )   THEN NULL 																 ' + char(10);
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	SET @mDqry1 = @mDQry1 + '		  WHEN DATA.INCOTERMS = ''FCA''  THEN CONVERT(INT, TTL1)																																		 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN DATA.INCOTERMS = ''FAS''  THEN CONVERT(INT, TTL1)																																		 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN DATA.INCOTERMS = ''FOB''  THEN ISNULL(CONVERT(INT, TTL1),0) + ISNULL(CONVERT(INT,TTL2),0)																								 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN DATA.INCOTERMS = ''CFR''  THEN ISNULL(CONVERT(INT, TTL1),0) + ISNULL(CONVERT(INT,TTL2),0)																								 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN DATA.INCOTERMS = ''CIF''  THEN ISNULL(CONVERT(INT, TTL1),0) + ISNULL(CONVERT(INT,TTL2),0)																								 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN DATA.INCOTERMS = ''CIP''  THEN ISNULL(CONVERT(INT, TTL1),0) + ISNULL(CONVERT(INT,TTL2),0)																								 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN DATA.INCOTERMS = ''CPT''  THEN ISNULL(CONVERT(INT, TTL1),0) + ISNULL(CONVERT(INT,TTL2),0)																								 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN DATA.INCOTERMS = ''Z02''  THEN ISNULL(CONVERT(INT, TTL1),0) + ISNULL(CONVERT(INT,TTL2),0) + ISNULL(CONVERT(INT,TTL3),0) + ISNULL(CONVERT(INT, TTL4),0) + ISNULL(CONVERT(INT, TTL5),0) 	 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN DATA.INCOTERMS = ''DAT''  THEN ISNULL(CONVERT(INT, TTL1),0) + ISNULL(CONVERT(INT,TTL2),0) + ISNULL(CONVERT(INT,TTL3),0) + ISNULL(CONVERT(INT, TTL4),0) + ISNULL(CONVERT(INT, TTL5),0) 	 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN DATA.INCOTERMS = ''DAP''  THEN ISNULL(CONVERT(INT, TTL1),0) + ISNULL(CONVERT(INT,TTL2),0) + ISNULL(CONVERT(INT,TTL3),0) + ISNULL(CONVERT(INT, TTL4),0) + ISNULL(CONVERT(INT, TTL5),0) 	 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN DATA.INCOTERMS = ''DDP''  THEN ISNULL(CONVERT(INT, TTL1),0) + ISNULL(CONVERT(INT,TTL2),0) + ISNULL(CONVERT(INT,TTL3),0) + ISNULL(CONVERT(INT, TTL4),0) + ISNULL(CONVERT(INT, TTL5),0) 	 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN DATA.INCOTERMS = ''DDU''  THEN ISNULL(CONVERT(INT, TTL1),0) + ISNULL(CONVERT(INT,TTL2),0) + ISNULL(CONVERT(INT,TTL3),0) + ISNULL(CONVERT(INT, TTL4),0) + ISNULL(CONVERT(INT, TTL5),0) 	 ' + char(10);
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	SET @mDqry1 = @mDQry1 + '         WHEN TRANSPORT_MODE = ''TRK''  AND DATA.INCOTERMS = ''EXW''  THEN 0																															' + char(10);
	SET @mDqry1 = @mDQry1 + '         WHEN TRANSPORT_MODE = ''TRK''  AND (TTL1 IS NULL AND TTL2 IS NULL AND TTL3 IS NULL AND TTL4 IS NULL AND TTL5 IS NULL ) THEN NULL																	' + char(10);
	SET @mDqry1 = @mDQry1 + '         WHEN TRANSPORT_MODE = ''TRK''  THEN ISNULL(CONVERT(INT, TTL1),0) + ISNULL(CONVERT(INT,TTL2),0) + ISNULL(CONVERT(INT,TTL3),0) + ISNULL(CONVERT(INT, TTL4),0) + ISNULL(CONVERT(INT, TTL5),0)	' + char(10);
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	SET @mDqry1 = @mDQry1 + '		  WHEN (TTL1 IS NULL OR TTL2 IS NULL OR TTL3 IS NULL OR TTL4 IS NULL OR TTL5 IS NULL ) THEN NULL	' + char(10);
	SET @mDqry1 = @mDQry1 + '         ELSE 0		' + char(10);
	SET @mDqry1 = @mDQry1 + '        END AS TTL_INCOTERMS	 ' + char(10); -- LOOKUP INCOTERMS : 20230905
	
		


	-- DRTTL INCOTERMS ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	SET @mDqry1 = @mDQry1 + ', CASE   WHEN DATA.INCOTERMS = ''A01''  THEN 0																																						 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN DATA.INCOTERMS = ''Z01''  THEN 0																																						 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN DATA.INCOTERMS = ''Z04''  THEN 0																																						 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN DATA.INCOTERMS = ''EXW''  THEN 0																																						 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN DATA.INCOTERMS = ''FCA''  AND  DR1 IS NULL  THEN NULL 																																 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN DATA.INCOTERMS = ''FAS''  AND  DR1 IS NULL  THEN NULL 																																 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN DATA.INCOTERMS = ''FOB''  AND (DR1 IS NULL OR DR2 IS NULL )  THEN NULL 																												 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN DATA.INCOTERMS = ''CFR''  AND (DR1 IS NULL OR DR2 IS NULL )  THEN NULL 																												 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN DATA.INCOTERMS = ''CIF''  AND (DR1 IS NULL OR DR2 IS NULL )  THEN NULL 																												 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN DATA.INCOTERMS = ''CIP''  AND (DR1 IS NULL OR DR2 IS NULL )  THEN NULL 																												 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN DATA.INCOTERMS = ''CPT''  AND (DR1 IS NULL OR DR2 IS NULL )  THEN NULL 																												 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN DATA.INCOTERMS = ''Z02''  AND (DR1 IS NULL OR DR2 IS NULL OR DR3 IS NULL OR DR4 IS NULL OR DR5 IS NULL )   THEN NULL 																 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN DATA.INCOTERMS = ''DAT''  AND (DR1 IS NULL OR DR2 IS NULL OR DR3 IS NULL OR DR4 IS NULL OR DR5 IS NULL )   THEN NULL 																 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN DATA.INCOTERMS = ''DAP''  AND (DR1 IS NULL OR DR2 IS NULL OR DR3 IS NULL OR DR4 IS NULL OR DR5 IS NULL )   THEN NULL 																 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN DATA.INCOTERMS = ''DDP''  AND (DR1 IS NULL OR DR2 IS NULL OR DR3 IS NULL OR DR4 IS NULL OR DR5 IS NULL )   THEN NULL 																 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN DATA.INCOTERMS = ''DDU''  AND (DR1 IS NULL OR DR2 IS NULL OR DR3 IS NULL OR DR4 IS NULL OR DR5 IS NULL )   THEN NULL 																 ' + char(10);
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	SET @mDqry1 = @mDQry1 + '		  WHEN DATA.INCOTERMS = ''FCA''  THEN CONVERT(INT, DR1)																																		 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN DATA.INCOTERMS = ''FAS''  THEN CONVERT(INT, DR1)																																		 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN DATA.INCOTERMS = ''FOB''  THEN ISNULL(CONVERT(INT, DR1),0) + ISNULL(CONVERT(INT,DR2),0)																								 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN DATA.INCOTERMS = ''CFR''  THEN ISNULL(CONVERT(INT, DR1),0) + ISNULL(CONVERT(INT,DR2),0)																								 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN DATA.INCOTERMS = ''CIF''  THEN ISNULL(CONVERT(INT, DR1),0) + ISNULL(CONVERT(INT,DR2),0)																								 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN DATA.INCOTERMS = ''CIP''  THEN ISNULL(CONVERT(INT, DR1),0) + ISNULL(CONVERT(INT,DR2),0)																								 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN DATA.INCOTERMS = ''CPT''  THEN ISNULL(CONVERT(INT, DR1),0) + ISNULL(CONVERT(INT,DR2),0)																								 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN DATA.INCOTERMS = ''Z02''  THEN ISNULL(CONVERT(INT, DR1),0) + ISNULL(CONVERT(INT,DR2),0) + ISNULL(CONVERT(INT,DR3),0) + ISNULL(CONVERT(INT, DR4),0) + ISNULL(CONVERT(INT, DR5),0) 	 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN DATA.INCOTERMS = ''DAT''  THEN ISNULL(CONVERT(INT, DR1),0) + ISNULL(CONVERT(INT,DR2),0) + ISNULL(CONVERT(INT,DR3),0) + ISNULL(CONVERT(INT, DR4),0) + ISNULL(CONVERT(INT, DR5),0) 	 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN DATA.INCOTERMS = ''DAP''  THEN ISNULL(CONVERT(INT, DR1),0) + ISNULL(CONVERT(INT,DR2),0) + ISNULL(CONVERT(INT,DR3),0) + ISNULL(CONVERT(INT, DR4),0) + ISNULL(CONVERT(INT, DR5),0) 	 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN DATA.INCOTERMS = ''DDP''  THEN ISNULL(CONVERT(INT, DR1),0) + ISNULL(CONVERT(INT,DR2),0) + ISNULL(CONVERT(INT,DR3),0) + ISNULL(CONVERT(INT, DR4),0) + ISNULL(CONVERT(INT, DR5),0) 	 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN DATA.INCOTERMS = ''DDU''  THEN ISNULL(CONVERT(INT, DR1),0) + ISNULL(CONVERT(INT,DR2),0) + ISNULL(CONVERT(INT,DR3),0) + ISNULL(CONVERT(INT, DR4),0) + ISNULL(CONVERT(INT, DR5),0) 	 ' + char(10);
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	SET @mDqry1 = @mDQry1 + '         WHEN TRANSPORT_MODE = ''TRK''  AND DATA.INCOTERMS = ''EXW''  THEN 0																														 ' + char(10);
	SET @mDqry1 = @mDQry1 + '         WHEN TRANSPORT_MODE = ''TRK''  AND (DR1 IS NULL AND DR2 IS NULL AND DR3 IS NULL AND DR4 IS NULL AND DR5 IS NULL ) THEN NULL																	 ' + char(10);
	SET @mDqry1 = @mDQry1 + '         WHEN TRANSPORT_MODE = ''TRK''  THEN ISNULL(CONVERT(INT, DR1),0) + ISNULL(CONVERT(INT,DR2),0) + ISNULL(CONVERT(INT,DR3),0) + ISNULL(CONVERT(INT, DR4),0) + ISNULL(CONVERT(INT, DR5),0)		 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN (DR1 IS NULL OR DR2 IS NULL OR DR3 IS NULL OR DR4 IS NULL OR DR5 IS NULL ) THEN NULL	' + char(10);
	SET @mDqry1 = @mDQry1 + '         ELSE 0		' + char(10);
	SET @mDqry1 = @mDQry1 + '        END AS DRTTL_INCOTERMS	 ' + char(10); -- LOOKUP INCOTERMS : 20230905




	-- NDR INCOTERMS ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	SET @mDqry1 = @mDQry1 + ' , CASE  WHEN DATA.INCOTERMS = ''A01''  THEN 0																																							 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN DATA.INCOTERMS = ''Z01''  THEN 0																																							 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN DATA.INCOTERMS = ''Z04''  THEN 0																																							 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN DATA.INCOTERMS = ''EXW''  THEN 0																																							 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN DATA.INCOTERMS = ''FCA''  AND  NDR1 IS NULL  THEN NULL 																																	 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN DATA.INCOTERMS = ''FAS''  AND  NDR1 IS NULL  THEN NULL 																																	 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN DATA.INCOTERMS = ''FOB''  AND (NDR1 IS NULL OR NDR2 IS NULL )  THEN NULL 																												 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN DATA.INCOTERMS = ''CFR''  AND (NDR1 IS NULL OR NDR2 IS NULL )  THEN NULL 																												 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN DATA.INCOTERMS = ''CIF''  AND (NDR1 IS NULL OR NDR2 IS NULL )  THEN NULL 																												 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN DATA.INCOTERMS = ''CIP''  AND (NDR1 IS NULL OR NDR2 IS NULL )  THEN NULL 																												 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN DATA.INCOTERMS = ''CPT''  AND (NDR1 IS NULL OR NDR2 IS NULL )  THEN NULL 																												 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN DATA.INCOTERMS = ''Z02''  AND (NDR1 IS NULL OR NDR2 IS NULL OR NDR3 IS NULL OR NDR4 IS NULL OR NDR5 IS NULL )   THEN NULL 																 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN DATA.INCOTERMS = ''DAT''  AND (NDR1 IS NULL OR NDR2 IS NULL OR NDR3 IS NULL OR NDR4 IS NULL OR NDR5 IS NULL )   THEN NULL 																 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN DATA.INCOTERMS = ''DAP''  AND (NDR1 IS NULL OR NDR2 IS NULL OR NDR3 IS NULL OR NDR4 IS NULL OR NDR5 IS NULL )   THEN NULL 																 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN DATA.INCOTERMS = ''DDP''  AND (NDR1 IS NULL OR NDR2 IS NULL OR NDR3 IS NULL OR NDR4 IS NULL OR NDR5 IS NULL )   THEN NULL 																 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN DATA.INCOTERMS = ''DDU''  AND (NDR1 IS NULL OR NDR2 IS NULL OR NDR3 IS NULL OR NDR4 IS NULL OR NDR5 IS NULL )   THEN NULL 																 ' + char(10);
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	SET @mDqry1 = @mDQry1 + '		  WHEN DATA.INCOTERMS = ''FCA''  THEN CONVERT(INT, NDR1)																																		 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN DATA.INCOTERMS = ''FAS''  THEN CONVERT(INT, NDR1)																																		 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN DATA.INCOTERMS = ''FOB''  THEN ISNULL(CONVERT(INT, NDR1),0) + ISNULL(CONVERT(INT,NDR2),0)																								 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN DATA.INCOTERMS = ''CFR''  THEN ISNULL(CONVERT(INT, NDR1),0) + ISNULL(CONVERT(INT,NDR2),0)																								 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN DATA.INCOTERMS = ''CIF''  THEN ISNULL(CONVERT(INT, NDR1),0) + ISNULL(CONVERT(INT,NDR2),0)																								 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN DATA.INCOTERMS = ''CIP''  THEN ISNULL(CONVERT(INT, NDR1),0) + ISNULL(CONVERT(INT,NDR2),0)																								 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN DATA.INCOTERMS = ''CPT''  THEN ISNULL(CONVERT(INT, NDR1),0) + ISNULL(CONVERT(INT,NDR2),0)																								 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN DATA.INCOTERMS = ''Z02''  THEN ISNULL(CONVERT(INT, NDR1),0) + ISNULL(CONVERT(INT,NDR2),0) + ISNULL(CONVERT(INT,NDR3),0) + ISNULL(CONVERT(INT, NDR4),0) + ISNULL(CONVERT(INT, NDR5),0) 	 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN DATA.INCOTERMS = ''DAT''  THEN ISNULL(CONVERT(INT, NDR1),0) + ISNULL(CONVERT(INT,NDR2),0) + ISNULL(CONVERT(INT,NDR3),0) + ISNULL(CONVERT(INT, NDR4),0) + ISNULL(CONVERT(INT, NDR5),0) 	 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN DATA.INCOTERMS = ''DAP''  THEN ISNULL(CONVERT(INT, NDR1),0) + ISNULL(CONVERT(INT,NDR2),0) + ISNULL(CONVERT(INT,NDR3),0) + ISNULL(CONVERT(INT, NDR4),0) + ISNULL(CONVERT(INT, NDR5),0) 	 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN DATA.INCOTERMS = ''DDP''  THEN ISNULL(CONVERT(INT, NDR1),0) + ISNULL(CONVERT(INT,NDR2),0) + ISNULL(CONVERT(INT,NDR3),0) + ISNULL(CONVERT(INT, NDR4),0) + ISNULL(CONVERT(INT, NDR5),0) 	 ' + char(10);
	SET @mDqry1 = @mDQry1 + '		  WHEN DATA.INCOTERMS = ''DDU''  THEN ISNULL(CONVERT(INT, NDR1),0) + ISNULL(CONVERT(INT,NDR2),0) + ISNULL(CONVERT(INT,NDR3),0) + ISNULL(CONVERT(INT, NDR4),0) + ISNULL(CONVERT(INT, NDR5),0) 	 ' + char(10);
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	SET @mDqry1 = @mDQry1 + '         WHEN TRANSPORT_MODE = ''TRK''  AND DATA.INCOTERMS = ''EXW''  THEN 0																															' + char(10);
	SET @mDqry1 = @mDQry1 + '         WHEN TRANSPORT_MODE = ''TRK''  AND (NDR1 IS NULL AND NDR2 IS NULL AND NDR3 IS NULL AND NDR4 IS NULL AND NDR5 IS NULL ) THEN NULL																' + char(10);
	SET @mDqry1 = @mDQry1 + '         WHEN TRANSPORT_MODE = ''TRK''  THEN ISNULL(CONVERT(INT, NDR1),0) + ISNULL(CONVERT(INT,NDR2),0) + ISNULL(CONVERT(INT,NDR3),0) + ISNULL(CONVERT(INT, NDR4),0) + ISNULL(CONVERT(INT, NDR5),0)	' + char(10);
    ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	SET @mDqry1 = @mDQry1 + '		  WHEN (NDR1 IS NULL OR NDR2 IS NULL OR NDR3 IS NULL OR NDR4 IS NULL OR NDR5 IS NULL ) THEN NULL	' + char(10);
	SET @mDqry1 = @mDQry1 + '         ELSE 0		' + char(10);
	SET @mDqry1 = @mDQry1 + '        END AS NDR_INCOTERMS	 ' + char(10); -- LOOKUP INCOTERMS : 20230905

    -- POL_AREA ---------------------------------------------------------------------------------------------	
	SET @mDqry1 = @mDQry1 + '       ,POL_AREA' + char(10);
	SET @mDqry1 = @mDQry1 + '       ,POD_AREA' + char(10);
	SET @mDqry1 = @mDQry1 + '       ,SUBSTRING(EXFACTORY_DATE,0,9) AS EXFACTORY' + char(10);
	SET @mDqry1 = @mDQry1 + '       ,SUBSTRING(PLANT_ISSUE_DATE,0,9) AS PLANT_ISSUE' + char(10);
	SET @mDqry1 = @mDQry1 + '       ------------------------------------------------------------------------------' + char(10);
	SET @mDqry1 = @mDQry1 + '       ,DT.ZLANDETA     AS POL_ETA     ' + char(10);
	SET @mDqry1 = @mDQry1 + '       ,DT.POD_ETA_DATE AS POD_ETA ' + char(10);
	SET @mDqry1 = @mDQry1 + '       ,DT.ZFCY2ETA	 AS VMI_ETA ' + char(10);
	SET @mDqry1 = @mDQry1 + '       ,DT.F_DEST_ETA_DATE AS F_DEST_ETA ' + char(10);
	SET @mDqry1 = @mDQry1 + '       ------------------------------------------------------------------------------' + char(10);
	SET @mDqry1 = @mDQry1 + '       ,DT.ZLANDETD		AS POL_ETD     ' + char(10);
	SET @mDqry1 = @mDQry1 + '       ,DT.POD_ETD_DATE	AS POD_ETD ' + char(10);
	SET @mDqry1 = @mDQry1 + '       ,DT.ZFCY2ETD	    AS VMI_ETD ' + char(10);
	SET @mDqry1 = @mDQry1 + '       ,INCOTERMS_SSP ' + char(10);
	SET @mDqry1 = @mDQry1 + '       ,TRANSPORT_MODE ' + char(10);	
    -- ---------------------------------------------------------------------------------------------	
    SET @mDqry1 = @mDQry1 + '   FROM (' + char(10);
    SET @mDqry1 = @mDQry1 + '        SELECT E.DIVISION_ID   ' + char(10);
    SET @mDqry1 = @mDQry1 + '              ,E.COMPANY_ID ' + char(10);
    SET @mDqry1 = @mDQry1 + '              ,E.SHIPMENT_NO ' + char(10);
    SET @mDqry1 = @mDQry1 + '              ,T.CONTAINER_NO AS CNTR_NO' + char(10);
    SET @mDqry1 = @mDQry1 + '              ,B.BOD_ID' + char(10);
	SET @mDqry1 = @mDQry1 + '              ,B.route_id' + char(10);
	SET @mDqry1 = @mDQry1 + '              ,B.from_site' + char(10);
	SET @mDqry1 = @mDQry1 + '              ,B.to_site' + char(10);
	SET @mDqry1 = @mDQry1 + '              ,D.FROM_CITY' + char(10);
	SET @mDqry1 = @mDQry1 + '              ,D.TO_CITY' + char(10);
	SET @mDqry1 = @mDQry1 + '              ,T.POL ' + char(10);
	SET @mDqry1 = @mDQry1 + '              ,T.POD ' + char(10);
	SET @mDqry1 = @mDQry1 + '              ,T.F_DEST_PORT_CODE' + char(10);
	SET @mDqry1 = @mDQry1 + '              ,B.INCOTERMS AS INCOTERMS' + char(10);
	SET @mDqry1 = @mDQry1 + '              ,B.attribute1 AS INCOTERMS_SSP' + char(10);
	SET @mDqry1 = @mDQry1 + '              ,T.CARRIER' + char(10);
	--SET @mDqry1 = @mDQry1 + '              ,T.ZLANDATD AS INLAND_ATD ' + char(10);
	SET @mDqry1 = @mDQry1 + '              ,PLANT_ISSUE_DATE AS INLAND_ATD ' + char(10);	-- BOD Detail 쪽에 [Inland ATD] 필드값을 [PI Date] 로 수정요청 (2025-01-21 mrchois)
    SET @mDqry1 = @mDQry1 + '              ,T.ZLANDATA AS POL_ATA ' + char(10);		-- ATTRIBUTE3 -> ZLANDATA
    SET @mDqry1 = @mDQry1 + '              ,T.POL_ATD_DATE AS POL_ATD' + char(10);  -- POL_ATD_DATE -> ZLANDATD -> POL_ATD_DATE
    SET @mDqry1 = @mDQry1 + '              ,T.POD_ATA_DATE AS POD_ATA' + char(10);
    SET @mDqry1 = @mDQry1 + '              ,T.POD_ATD_DATE AS POD_ATD' + char(10);
    SET @mDqry1 = @mDQry1 + '              ,ISNULL(T.ZFCY2ATA, '''')    AS VMI_ATA  ' + char(10);
    SET @mDqry1 = @mDQry1 + '              ,ISNULL(T.ZFCY2ATD, '''')    AS VMI_ATD' + char(10);
    SET @mDqry1 = @mDQry1 + '              ,T.F_DEST_ATA_DATE AS F_DEST_ATA' + char(10);
	-----------------------------------------------------------------------------------------------
	SET @mDqry1 = @mDQry1 + '			    , D.LT_DEPARTURE_INLAND		AS NDR1	 ' + char(10);
	SET @mDqry1 = @mDQry1 + '			    , D.LT_WAIT_SHIPPING		AS NDR2	 ' + char(10);
	SET @mDqry1 = @mDQry1 + '			    , D.LT_VOYAGE				AS NDR3	 ' + char(10);
	SET @mDqry1 = @mDQry1 + '			    , D.LT_LAY_OFF_CLEARANCE	AS NDR4	 ' + char(10);
	SET @mDqry1 = @mDQry1 + '			    , D.LT_ARRIVAL_INLAND		AS NDR5	 ' + char(10);
	SET @mDqry1 = @mDQry1 + '			    ,  D.LT_DEPARTURE_INLAND			 ' + char(10);
	SET @mDqry1 = @mDQry1 + '			     + D.LT_WAIT_SHIPPING				 ' + char(10);
	SET @mDqry1 = @mDQry1 + '			     + D.LT_VOYAGE						 ' + char(10);
	SET @mDqry1 = @mDQry1 + '			     + D.LT_LAY_OFF_CLEARANCE			 ' + char(10);
	SET @mDqry1 = @mDQry1 + '			     + D.LT_ARRIVAL_INLAND		AS NDR	 ' + char(10);	
	-----------------------------------------------------------------------------------------------
    SET @mDqry1 = @mDQry1 + '              ,CASE WHEN ISDATE(T.ATTRIBUTE2)   = 1 AND ISDATE(T.ATTRIBUTE3)   = 1 THEN CONVERT(nvarchar, DATEDIFF(DD, T.ATTRIBUTE2, T.ATTRIBUTE3))		ELSE NULL END AS TTL1' + char(10);	
    SET @mDqry1 = @mDQry1 + '              ,CASE WHEN ISDATE(T.ATTRIBUTE3)   = 1 AND ISDATE(T.POL_ATD_DATE) = 1 THEN CONVERT(nvarchar, DATEDIFF(DD, T.ATTRIBUTE3, T.POL_ATD_DATE))		ELSE NULL END AS TTL2' + char(10);
    SET @mDqry1 = @mDQry1 + '              ,CASE WHEN T.POL_ATD_DATE IS NOT NULL AND T.POL_ATD_DATE <> '''' THEN CONVERT(NVARCHAR, DATEDIFF(DD, EXFACTORY_DATE, T.POL_ATD_DATE))		ELSE NULL END AS TTL12' + char(10);
	SET @mDqry1 = @mDQry1 + '              ,CASE WHEN ISDATE(T.POL_ATD_DATE) = 1 AND ISDATE(T.POD_ATA_DATE) = 1 THEN CONVERT(nvarchar, DATEDIFF(DD, T.POL_ATD_DATE, T.POD_ATA_DATE))	ELSE NULL END AS TTL3' + char(10);
    SET @mDqry1 = @mDQry1 + '              ,CASE WHEN ISDATE(T.POD_ATA_DATE) = 1 AND ISDATE(T.POD_ATD_DATE) = 1 THEN CONVERT(nvarchar, DATEDIFF(DD, T.POD_ATA_DATE, T.POD_ATD_DATE))	ELSE NULL END AS TTL4' + char(10);
    --SET @mDqry1 = @mDQry1 + '              ,CASE WHEN ISDATE(T.POD_ATD_DATE) = 1 AND IIF(S.VMI_YN = ''Y'', ISDATE(ISNULL(T.ZFCY2ATA, '''')), ISDATE(T.F_DEST_ATA_DATE))  = 1 ' + char(10);
    --SET @mDqry1 = @mDQry1 + '                    THEN CONVERT(nvarchar, DATEDIFF(DD, T.POD_ATD_DATE, IIF(S.VMI_YN = ''Y'', ISNULL(T.ZFCY2ATA, ''''), T.F_DEST_ATA_DATE)))' + char(10);
    --SET @mDqry1 = @mDQry1 + '                    ELSE NULL END AS TTL5' + char(10);
	SET @mDqry1 = @mDQry1 + '              ,CONVERT(INT,																																								' + char(10);	
	SET @mDqry1 = @mDQry1 + '              CASE 																																										' + char(10);	
	SET @mDqry1 = @mDQry1 + '              WHEN S.VMI_YN = ''Y'' AND ISDATE(T.F_DEST_ATA_DATE) = 1			AND ISDATE(T.POD_ATD_DATE) = 1 THEN CONVERT(nvarchar, DATEDIFF(DD,T.POD_ATD_DATE,T.F_DEST_ATA_DATE))		' + char(10);	
	SET @mDqry1 = @mDQry1 + '              WHEN S.VMI_YN = ''Y'' AND ISDATE(ISNULL(T.ZFCY2ATA, '''')) = 1	AND ISDATE(T.POD_ATD_DATE) = 1 THEN CONVERT(nvarchar, DATEDIFF(DD,T.POD_ATD_DATE,ISNULL(T.ZFCY2ATA, '''')))	' + char(10);	
	SET @mDqry1 = @mDQry1 + '              WHEN S.VMI_YN = ''N'' AND ISDATE(T.F_DEST_ATA_DATE) = 1			AND ISDATE(T.POD_ATD_DATE) = 1 THEN CONVERT(nvarchar, DATEDIFF(DD,T.POD_ATD_DATE,T.F_DEST_ATA_DATE))		' + char(10);	
	SET @mDqry1 = @mDQry1 + '              ELSE NULL 																																									' + char(10);	
	SET @mDqry1 = @mDQry1 + '              END																																											' + char(10);	
	SET @mDqry1 = @mDQry1 + '              ) AS TTL5																																									' + char(10);	  -- TTL5 재정의 : VMI_YN Y여도, F_DEST_ATA 값이 있으면 F_DEST_ATA - POD_ATD 값을 TTL5로 삼음
	SET @mDqry1 = @mDQry1 + '              , CASE WHEN ISDATE(T.POD_ATA_DATE) = 1 AND ISDATE(T.F_DEST_ATA_DATE) = 1 THEN CONVERT(nvarchar, DATEDIFF(DD, T.POD_ATA_DATE, T.F_DEST_ATA_DATE))	ELSE NULL END AS TTL45		' + char(10);	  -- TTL45 계산로직 변경 추가 (2025-02-03 mrchois)


    SET @mDqry1 = @mDQry1 + '              ,E.CONFIRM_ID' + char(10);
	SET @mDqry1 = @mDQry1 + '              ,E.LT_DEPARTURE_INLAND		AS DR1   --기준L/T 1 (계획시점)' + char(10);
    SET @mDqry1 = @mDQry1 + '              ,E.LT_WAIT_SHIPPING			AS DR2   --기준L/T 2 (계획시점)' + char(10);
    SET @mDqry1 = @mDQry1 + '              ,E.LT_VOYAGE					AS DR3   --기준L/T 3 (계획시점)' + char(10);
    SET @mDqry1 = @mDQry1 + '              ,E.LT_LAY_OFF_CLEARANCE		AS DR4   --기준L/T 4 (계획시점)' + char(10);
    SET @mDqry1 = @mDQry1 + '              ,E.LT_ARRIVAL_INLAND			AS DR5   --기준L/T 5 (계획시점)' + char(10);
	SET @mDqry1 = @mDQry1 + '              ,FR.ATTRIBUTE1				AS POL_AREA' + char(10);
	SET @mDqry1 = @mDQry1 + '              ,TZ.ATTRIBUTE1				AS POD_AREA' + char(10);
	SET @mDqry1 = @mDQry1 + '              ,EXFACTORY_DATE' + char(10);
	SET @mDqry1 = @mDQry1 + '              ,PLANT_ISSUE_DATE' + char(10);
	SET @mDqry1 = @mDQry1 + '              ,S.VMI_YN' + char(10);
	SET @mDqry1 = @mDQry1 + '              ,D.TRANSPORT_MODE ' + char(10);
    SET @mDqry1 = @mDqry1 + '          FROM (' + char(10);
    SET @mDqry1 = @mDqry1 + '               SELECT CN.DIVISION_ID' + char(10);
    SET @mDqry1 = @mDqry1 + '              ,CN.FROM_SITE_COMPANY_ID AS COMPANY_ID' + char(10);
    SET @mDqry1 = @mDqry1 + '              ,EX.SHIPMENT_NO' + char(10);
    SET @mDqry1 = @mDqry1 + '              ,CN.CONFIRM_ID' + char(10);
    SET @mDqry1 = @mDqry1 + '              ,CN.BOD_ID' + char(10);
    SET @mDqry1 = @mDqry1 + '              ,CN.ITEM_ID' + char(10);
    SET @mDqry1 = @mDqry1 + '              ,EX.EXFACTORY_DATE' + char(10);
    SET @mDqry1 = @mDqry1 + '              ,EX.PLANT_ISSUE_DATE' + char(10);
    SET @mDqry1 = @mDqry1 + '              ,RT.LT_DEPARTURE_INLAND' + char(10);
    SET @mDqry1 = @mDqry1 + '              ,RT.LT_WAIT_SHIPPING' + char(10);
    SET @mDqry1 = @mDqry1 + '              ,RT.LT_VOYAGE' + char(10);
    SET @mDqry1 = @mDqry1 + '              ,RT.LT_LAY_OFF_CLEARANCE' + char(10);
    SET @mDqry1 = @mDqry1 + '              ,RT.LT_ARRIVAL_INLAND' + char(10);
    SET @mDqry1 = @mDqry1 + '          FROM (' + char(10);
    SET @mDqry1 = @mDqry1 + '               SELECT X.ATTRIBUTE3 AS SHIPMENT_NO' + char(10);
    SET @mDqry1 = @mDqry1 + '                     ,MAX(X.CONFIRM_ID) AS CONFIRM_ID ' + char(10);-------------
    SET @mDqry1 = @mDqry1 + '                     ,MAX(SYSTEM_EXFACTORY_DATE) AS EXFACTORY_DATE' + char(10);
    SET @mDqry1 = @mDqry1 + '                     ,MAX(PLANT_ISSUE_DATE) AS PLANT_ISSUE_DATE' + char(10);
    SET @mDqry1 = @mDqry1 + '                 FROM SCM_DNM_EXFACTORY_RESULT AS X WITH(NOLOCK)' + char(10);
    SET @mDqry1 = @mDqry1 + '                      JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)' + char(10);
    SET @mDqry1 = @mDqry1 + '                   ON L.LOOKUP_TYPE = ''ERP_SSP_TYPE'' -- LOOKUP에 등록된 공정만 ' + char(10);
    SET @mDqry1 = @mDqry1 + '                  AND L.VALID_YN = ''Y'' ' + char(10);
    SET @mDqry1 = @mDqry1 + '                  AND X.VALID_YN = ''Y'' ' + char(10);
    SET @mDqry1 = @mDqry1 + '                  AND L.SEGMENT1    = X.SSP_TYPE' + char(10);
    SET @mDqry1 = @mDqry1 + '                WHERE 1 = 1' + char(10);
    SET @mDqry1 = @mDqry1 + '                  AND X.ATTRIBUTE3 IS NOT NULL' + char(10);
    SET @mDqry1 = @mDqry1 + '                  AND X.DIVISION_ID = '''+@p_division_id+''' ' + char(10);

	IF ( @p_from_yyyymmdd   IS NOT NULL AND @p_from_yyyymmdd    != '') SET @mDqry1 = @mDqry1 + ' AND X.SYSTEM_EXFACTORY_DATE BETWEEN '''+@p_from_yyyymmdd+'''  AND '''+@p_to_yyyymmdd+'''   '+char(10);     

	IF ( @p_exfactory_from_yyyymmdd   IS NOT NULL AND @p_exfactory_from_yyyymmdd   != '') SET @mDqry1 = @mDqry1 + ' AND X.SYSTEM_EXFACTORY_DATE BETWEEN '''+@p_exfactory_from_yyyymmdd+'''  AND '''+@p_exfactory_to_yyyymmdd+'''  '+char(10); 

    SET @mDqry1 = @mDqry1 + '                  AND X.EXFACTORY_STATUS NOT IN (''D10'',''D90'')' + char(10);
    SET @mDqry1 = @mDqry1 + '                  AND X.CONFIRM_ID LIKE ''C%'' ' + char(10);
    SET @mDqry1 = @mDqry1 + '                GROUP BY X.ATTRIBUTE3' + char(10);
    SET @mDqry1 = @mDqry1 + '              ) AS EX' + char(10);
    SET @mDqry1 = @mDqry1 + '              JOIN SSP_ANL_SHIP_CONFIRM AS CN  WITH(NOLOCK)' + char(10);
    SET @mDqry1 = @mDqry1 + '           ON EX.CONFIRM_ID = CN.CONFIRM_ID' + char(10);
    SET @mDqry1 = @mDqry1 + '              JOIN SSP_ANL_SHIP_CONFIRM_ROUTE AS RT WITH(NOLOCK)' + char(10);
    SET @mDqry1 = @mDqry1 + '           ON CN.CONFIRM_ID = RT.CONFIRM_ID' + char(10);
    SET @mDqry1 = @mDqry1 + '     ) AS E' + char(10);
    SET @mDqry1 = @mDqry1 + '      JOIN SCP_MST_BOD AS B ' + char(10);
    SET @mDqry1 = @mDqry1 + '   ON E.BOD_ID = B.BOD_ID' + char(10);
    SET @mDqry1 = @mDqry1 + '     JOIN SCM_MST_SITE AS S' + char(10);
    SET @mDqry1 = @mDqry1 + '   ON B.division_id = S.DIVISION_ID' + char(10);
    SET @mDqry1 = @mDqry1 + '   AND B.to_site = S.SCM_SITE_ID' + char(10);
	SET @mDqry1 = @mDqry1 + '       JOIN SCP_MST_DISTRIBUTION_ROUTE AS D with(nolock) ' + char(10);
	SET @mDqry1 = @mDqry1 + '    ON B.ROUTE_ID = D.ROUTE_ID' + char(10);
	SET @mDqry1 = @mDqry1 + '      JOIN [dbo].[SCM_DNM_DELIVERY_TRACKING] AS T with(nolock)' + char(10);
	SET @mDqry1 = @mDqry1 + '   ON E.COMPANY_ID = T.COMPANY_ID' + char(10);
    SET @mDqry1 = @mDqry1 + '   AND E.SHIPMENT_NO = T.SHIPMENT_NO' + char(10);
    SET @mDqry1 = @mDqry1 + ' 	  LEFT OUTER JOIN dbo.SCM_MST_PORT AS FR' + char(10);
    SET @mDqry1 = @mDqry1 + '    ON D.D_COUNTRY = FR.COUNTRY' + char(10);
    SET @mDqry1 = @mDqry1 + '   AND D.D_PORT_CODE  = FR.PORT_CODE' + char(10);
    SET @mDqry1 = @mDqry1 + '       LEFT OUTER JOIN dbo.SCM_MST_PORT AS TZ' + char(10);
    SET @mDqry1 = @mDqry1 + '    ON D.A_COUNTRY = TZ.COUNTRY' + char(10);
    SET @mDqry1 = @mDqry1 + '   AND D.A_PORT_CODE  = TZ.PORT_CODE' + char(10);
    SET @mDqry1 = @mDqry1 + '  WHERE 1=1' + char(10);

	IF ( @p_from_site   IS NOT NULL AND @p_from_site    != '') SET @mDqry1 = @mDqry1 + ' 					AND  B.FROM_SITE =  '''+@p_from_site+'''   '+char(10); 
	IF ( @p_to_site   IS NOT NULL AND @p_to_site    != '') SET @mDqry1 = @mDqry1 + ' 					AND  B.TO_SITE =  '''+@p_to_site+'''   '+char(10); 

	IF ( @p_bod_id   IS NOT NULL AND @p_bod_id    != '') SET @mDqry1 = @mDqry1 + ' 					AND  B.BOD_ID =  '''+@p_bod_id+'''   '+char(10); 			

	IF ( @p_route_id   IS NOT NULL AND @p_route_id    != '') SET @mDqry1 = @mDqry1 + ' 					AND B.ROUTE_ID = '''+@p_route_id+'''   '+char(10); 

	IF ( @p_fdest_from_yyyymmdd   IS NOT NULL AND @p_fdest_from_yyyymmdd   != '') SET @mDqry1 = @mDqry1 + ' AND T.F_DEST_ATA_DATE BETWEEN '''+@p_fdest_from_yyyymmdd+'''  AND '''+@p_fdest_to_yyyymmdd+'''  '+char(10); 

	IF ( @v_from_country   IS NOT NULL AND @v_from_country    != '') SET @mDqry1 = @mDqry1  + ' 					AND  D.FROM_COUNTRY     IN ('+ @v_from_country   +')    '+char(10); 
	IF ( @v_to_country     IS NOT NULL AND @v_to_country    != '')	 SET @mDqry1 = @mDqry1  + ' 					AND  D.TO_COUNTRY		 IN ('+ @v_to_country   +')      '+char(10); 
																		 
	IF ( @v_from_city   IS NOT NULL AND @v_from_city    != '')		 SET @mDqry1 = @mDqry1  + ' 					AND  D.FROM_CITY     IN ('+ @v_from_city   +')    '+char(10); 
	IF ( @v_to_city     IS NOT NULL AND @v_to_city    != '')		 SET @mDqry1 = @mDqry1  + ' 					AND  D.TO_CITY		 IN ('+ @v_to_city   +')      '+char(10); 
																		
	IF ( @p_from_area   IS NOT NULL AND @p_from_area    != '')		 SET @mDqry1 = @mDqry1  + ' 					AND  FR.ATTRIBUTE1 =N'''+@p_from_area+'''   '+char(10); 
	IF ( @p_to_area     IS NOT NULL AND @p_to_area    != '')		 SET @mDqry1 = @mDqry1  + ' 					AND  TZ.ATTRIBUTE1	=N'''+@p_to_area+'''    '+char(10); 
		
    SET @mDqry1 = @mDqry1 + '   ) AS DATA' + char(10);

	SET @mDqry1 = @mDqry1 + ' LEFT JOIN SCM_DNM_DELIVERY_TRACKING DT ON DT.CONTAINER_NO = DATA.CNTR_NO    ' + char(10);
	SET @mDqry1 = @mDqry1 + ' 									   AND DT.SHIPMENT_NO = DATA.SHIPMENT_NO  ' + char(10);
	SET @mDqry1 = @mDqry1 + ' 									   AND DT.COMPANY_ID = DATA.COMPANY_ID    ' + char(10);
    SET @mDqry1 = @mDqry1 + ') AS LIST ' + char(10);
    SET @mDqry1 = @mDqry1 + ') AS INFO ' + char(10);
    SET @mDqry1 = @mDqry1 + '  ORDER BY INFO.SHIPMENT_NO, INFO.CNTR_NO ' + char(10); 


				DECLARE @POS INT =1;
				SET @POS =1;
				DECLARE @LEN INT =LEN(@mDqry1);
				WHILE @POS <= @LEN
				BEGIN
					PRINT SUBSTRING(@mDqry1,@POS,4000);
					SET @POS = @POS+4000;
				END;

	EXEC (@mDQry1);

END
