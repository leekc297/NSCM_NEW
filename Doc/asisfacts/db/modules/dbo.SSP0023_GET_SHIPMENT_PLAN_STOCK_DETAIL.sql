
/*
 * PROGRAM ID   : SSP0023_GET_SHIPMENT_PLAN_STOCK_DETAIL
 * DESCRIPTION  : 전극 SHIPMENT PLAN(Electrode) STOCK DETAIL
 * PROGRAM HISTORY
 *===================================================================================================
 *   DATE       IN CHARGE		DESCRIPTION
 *===================================================================================================
 * 2020-06-03   khj79			[PJ20199555] 공급 대응력 향상을 위한 자재재공 수급 점검 체계 개선  최초 작성
 * 2020-06-30   khj79			[PJ20199555] 공급 대응력 향상을 위한 자재재공 수급 점검 체계 개선 - operation_id ,iWMS Qty, IWMS Hold YN 추가 , 
								storage_id 변경 (변경 전 : SL.STORAGE_DESCRIPTION + ''('' + SC.STORAGE_ID+'')''	AS STORAGE_ID	)
 * 2020-07-09   khj79			[PJ20199555] 공급 대응력 향상을 위한 자재재공 수급 점검 체계 개선 - NICK_NAME 조회 조건 추가
 * 2020-07-21   juhlee   		Pallet id 추가 
 * 2020-07-21   KIMYONGHO   		'ELECTRODE_SHIP_STORAGE'  재고 집계 제외 대상 추가 
 * EX > EXEC SSP0023_GET_SHIPMENT_PLAN_STOCK_DETAIL @P_DIVISION_ID='40', @P_COMPANY_ID ='C100', @P_FROM_SITE='', @P_PLAN_START_YYYYMMDD='20200603'
		, @P_ITEM_ID= 'APCAN0023A', @P_NICK_NAME = '' , @P_LOT_ID= '', @P_USER_ID= 'khj79', @P_PROGRAM_ID='SSP0023', @P_SHEET_NAME='Stock Detail'
		, @P_MY_MODEL_CHK='Y', @P_DELEGATEE_CHK = 'N', @P_PART_LEADER_CHK = 'N', @P_TEAM_LEADER_CHK = 'N', @P_NON_CHK = 'N'
 
 */
CREATE PROCEDURE [dbo].[SSP0023_GET_SHIPMENT_PLAN_STOCK_DETAIL]
	  @P_DIVISION_ID			VARCHAR(10)
	, @P_COMPANY_ID				NVARCHAR(100)
	, @P_FROM_SITE				NVARCHAR(100)
	, @P_PLAN_START_YYYYMMDD	NVARCHAR(8)
	, @P_ITEM_ID				NVARCHAR(30)
	, @P_NICK_NAME				NVARCHAR(30)
	, @P_LOT_ID					NVARCHAR(30)
	, @P_USER_ID				NVARCHAR(MAX)
	, @P_PROGRAM_ID				NVARCHAR(10) = 'SSP0023' 
	, @P_SHEET_NAME				NVARCHAR(20) = 'Stock Detail'
	, @P_MY_MODEL_CHK			CHAR(1)
	, @P_DELEGATEE_CHK			CHAR(1)
	, @P_PART_LEADER_CHK		CHAR(1)
	, @P_TEAM_LEADER_CHK		CHAR(1)
	, @P_NON_CHK				CHAR(1)
AS  
  
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @MEXEC				NVARCHAR(MAX);

	SET  @MEXEC  ='';
	SET @MEXEC = @MEXEC+'	SELECT SC.DIVISION_ID																' + CHAR(10);
	SET @MEXEC = @MEXEC+'		, SC.PLANT_ID																	' + CHAR(10);
	SET @MEXEC = @MEXEC+'		, IE.MODEL_ID																	' + CHAR(10);
	SET @MEXEC = @MEXEC+'		, SC.ITEM_ID																	' + CHAR(10);
	SET @MEXEC = @MEXEC+'		, IE.ITEM_ID_NICK_NAME									AS NICK_NAME			' + CHAR(10);
	SET @MEXEC = @MEXEC+'		, SC.VERSION																	' + CHAR(10);
	SET @MEXEC = @MEXEC+'		, CONVERT(decimal(5,2),IE.LANE)							AS LANE					' + CHAR(10);
	SET @MEXEC = @MEXEC+'		, SC.LOT_ID																		' + CHAR(10);
	SET @MEXEC = @MEXEC+'		, SC.PALLET_ID																	' + CHAR(10);
	SET @MEXEC = @MEXEC+'		, SC.STORAGE_ID											AS STORAGE_ID			' + CHAR(10);
	SET @MEXEC = @MEXEC+'		, SC.OPERATION_ID										AS OPERATION_ID			' + CHAR(10);
	SET @MEXEC = @MEXEC+'		, LM.SEGMENT2											AS CHANGE_STATUS		' + CHAR(10);
	SET @MEXEC = @MEXEC+'		, SC.FROM_SITE																	' + CHAR(10);
	-- FLOOR - > CEILING 으로 변경 KIMYONGHO 2020-09-03
	SET @MEXEC = @MEXEC+'		, CEILING(SC.IWMS_QTY)									AS IWMS_QTY_UOM			' + CHAR(10);
	SET @MEXEC = @MEXEC+'		, CEILING(SC.IWMS_QTY * ISNULL(IE.CONVERT_TO_PCM,  1))	AS IWMS_QTY_PCM			' + CHAR(10);
	SET @MEXEC = @MEXEC+'		, CEILING(SC.GMES_QTY)									AS GMES_QTY_UOM			' + CHAR(10);
	SET @MEXEC = @MEXEC+'		, CEILING(SC.GMES_QTY * ISNULL(IE.CONVERT_TO_PCM,  1))	AS GMES_QTY_PCM			' + CHAR(10);
	SET @MEXEC = @MEXEC+'		, CEILING(SC.OWMS_QTY)									AS OWMS_QTY_UOM			' + CHAR(10);
	SET @MEXEC = @MEXEC+'		, CEILING(SC.OWMS_QTY * ISNULL(IE.CONVERT_TO_PCM,  1))	AS OWMS_QTY_PCM			' + CHAR(10);
	SET @MEXEC = @MEXEC+'		, CEILING(SC.TOT_QTY)										AS TOTAL_QTY_UOM		' + CHAR(10);
	SET @MEXEC = @MEXEC+'		, CEILING(SC.TOT_QTY  * ISNULL(IE.CONVERT_TO_PCM,  1))	AS TOTAL_QTY_PCM		' + CHAR(10);
	SET @MEXEC = @MEXEC+'		, SC.AVAILABLE_YN																' + CHAR(10);
	SET @MEXEC = @MEXEC+'		, SC.IWMS_HOLD_YN																' + CHAR(10);
	SET @MEXEC = @MEXEC+'		, SC.QMS_HOLD_YN																' + CHAR(10);
	SET @MEXEC = @MEXEC+'		, SC.GMES_HOLD_YN										AS MES_HOLD_YN			' + CHAR(10);
	SET @MEXEC = @MEXEC+'		, SC.OWMS_HOLD_YN																' + CHAR(10);
	SET @MEXEC = @MEXEC+'		, SC.EXPIRATION_DATE															' + CHAR(10);
	SET @MEXEC = @MEXEC+'		, SC.PACKAGE_TYPE										AS PACKAGE_TYPE_CODE	' + CHAR(10);
	SET @MEXEC = @MEXEC+'	 FROM SSP_ANL_STOCK_EE_C SC WITH(NOLOCK)											' + CHAR(10);

	IF @P_NON_CHK != 'Y'
		BEGIN
			SET @mEXEC = @mEXEC+'		 JOIN SSP_MST_MODEL_USER MMU WITH(NOLOCK)								' + CHAR(10);
			SET @mEXEC = @mEXEC+'		   ON MMU.DIVISION_ID = SC.DIVISION_ID									' + CHAR(10) ;
			SET @mEXEC = @mEXEC+'		  AND MMU.FROM_SITE   = SC.FROM_SITE									' + CHAR(10) ;
			SET @mEXEC = @mEXEC+'		  AND MMU.ITEM_ID     = SC.ITEM_ID										' + CHAR(10) ;
			SET @mEXEC = @mEXEC+'		  AND MMU.VALID_YN    = ''Y''											' + CHAR(10) ;
			SET @mEXEC = @mEXEC+'		  AND (( MMU.USER_ID IN (SELECT CASE WHEN ''' + @P_MY_MODEL_CHK + ''' = ''Y'' THEN ''' + @P_USER_ID + ''' ELSE ''X'' END				' + char(10) ;
			SET @mEXEC = @mEXEC+'								  UNION 																										' + char(10) ;
			SET @mEXEC = @mEXEC+'								 SELECT CASE WHEN ''' + @P_DELEGATEE_CHK + ''' = ''Y'' THEN USER_ID ELSE ''X'' END								' + char(10) ;
			SET @mEXEC = @mEXEC+'								   FROM SSP_MST_DELEGATE WHERE VALID_YN = ''Y'' AND DELEGATEE_ID = ''' + @P_USER_ID + ''' GROUP BY USER_ID) 	' + char(10) ;
			SET @mEXEC = @mEXEC+'					OR MMU.PART_LEADER = CASE WHEN ''' + @P_PART_LEADER_CHK + ''' = ''Y'' THEN ''' + @P_USER_ID + ''' ELSE ''X'' END			' + char(10) ;
			SET @mEXEC = @mEXEC+'					OR MMU.TEAM_LEADER = CASE WHEN ''' + @P_TEAM_LEADER_CHK + ''' = ''Y'' THEN ''' + @P_USER_ID + ''' ELSE ''X'' END))			' + char(10) ;
		END

	SET @MEXEC = @MEXEC+'	 LEFT OUTER JOIN SSP_MST_SITE_ITEM_EE_V IE WITH(NOLOCK)								' + CHAR(10);
	SET @MEXEC = @MEXEC+'	   ON SC.DIVISION_ID = IE.DIVISION_ID												' + CHAR(10);
	SET @MEXEC = @MEXEC+'	  AND SC.FROM_SITE   = IE.SCM_SITE_ID												' + CHAR(10);

	SET @MEXEC = @MEXEC+'	  AND SC.ITEM_ID     = IE.ITEM_ID													' + CHAR(10);

	SET @MEXEC = @MEXEC+'	 LEFT OUTER JOIN SCM_MST_SLOC SL WITH(NOLOCK)										' + CHAR(10);
	SET @MEXEC = @MEXEC+'	   ON SC.PLANT_ID   = SL.PLANT_ID													' + CHAR(10);
	SET @MEXEC = @MEXEC+'	  AND SC.STORAGE_ID = SL.STORAGE_ID													' + CHAR(10);
	SET @MEXEC = @MEXEC+'	  AND SC.DIVISION_ID = SL.DIVISION_ID												' + CHAR(10);

	SET @MEXEC = @MEXEC+'	 JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LM WITH(NOLOCK)												' + CHAR(10);
	SET @MEXEC = @MEXEC+'	   ON LOOKUP_TYPE = ''MES_CHANGE_STATUS''											' + CHAR(10);
	SET @MEXEC = @MEXEC+'	  AND LM.VALID_YN = ''Y''															' + CHAR(10);
	SET @MEXEC = @MEXEC+'	  AND LM.SEGMENT1 = SC.CHANGE_STATUS												' + CHAR(10);

	SET @MEXEC = @MEXEC+'	WHERE 1 = 1																			' + CHAR(10);
	SET @MEXEC = @MEXEC+'	  AND SC.TYPE = ''E''																' + CHAR(10);

	--/*  2020-07-21   KIMYONGHO   		'ELECTRODE_SHIP_STORAGE'  재고 집계 제외 대상 추가  보류*/
	--SET @MEXEC = @MEXEC + '	  AND NOT EXISTS ( SELECT 1   																											' + char(10);	
	--SET @MEXEC = @MEXEC + '					 FROM SCM_ADM_LOOKUP_MASTER_DETAIL L																						' + char(10);	
	--SET @MEXEC = @MEXEC + '					WHERE 1=1																												' + char(10);	
	--SET @MEXEC = @MEXEC + '					  AND L.LOOKUP_TYPE =  ''ELECTRODE_SHIP_STORAGE''																				' + char(10);	
	--SET @MEXEC = @MEXEC + '					  AND L.SEGMENT4    =  ''P''																								' + char(10);	
	--SET @MEXEC = @MEXEC + '					  AND L.VALID_YN    =  ''Y''																								' + char(10);
	--SET @MEXEC = @MEXEC + '					  AND L.ATTRIBUTE1  =  SC.DIVISION_ID																						' + char(10);	
	--SET @MEXEC = @MEXEC + '					  AND L.SEGMENT1    =  SC.FROM_SITE																						' + char(10);	
	----SET @MEXEC = @MEXEC + '					  AND L.ATTRIBUTE5	=  T0.PLANT_ID																							' + char(10);	 PLANT MISS MATCH
	--SET @MEXEC = @MEXEC + '					  AND L.SEGMENT3	=  SC.STORAGE_ID																						' + char(10);		
	--SET @MEXEC = @MEXEC + '				   )																														' + char(10);

	IF ( @P_PLAN_START_YYYYMMDD IS NOT NULL	AND @P_PLAN_START_YYYYMMDD	!= ''  )
		SET @MEXEC = @MEXEC+'	AND SC.PLAN_START_YYYYMMDD	= ''' + @P_PLAN_START_YYYYMMDD	+ '''	' + CHAR(10);

	IF ( @P_DIVISION_ID IS NOT NULL			AND @P_DIVISION_ID	!= ''  )
		SET @MEXEC = @MEXEC+'	AND SC.DIVISION_ID			= ''' + @P_DIVISION_ID			+ '''	' + CHAR(10);

	IF ( @P_COMPANY_ID IS NOT NULL			AND @P_COMPANY_ID	!= ''  )
		SET @MEXEC = @MEXEC+'	AND SC.COMPANY_ID			= ''' + @P_COMPANY_ID			+ '''	' + CHAR(10);

	IF ( @P_FROM_SITE IS NOT NULL			AND @P_FROM_SITE	!= ''  )
		SET @MEXEC = @MEXEC+'	AND SC.FROM_SITE			= ''' + @P_FROM_SITE			+ '''	' + CHAR(10);

	IF ( @P_ITEM_ID IS NOT NULL				AND @P_ITEM_ID	!= ''  )
		SET @MEXEC = @MEXEC+'	AND SC.ITEM_ID				= ''' + @P_ITEM_ID				+ '''	' + CHAR(10);

	IF ( @P_NICK_NAME IS NOT NULL				AND @P_NICK_NAME	!= ''  )
		SET @MEXEC = @MEXEC+'	AND IE.ITEM_ID_NICK_NAME	= ''' + @P_NICK_NAME			+ '''	' + CHAR(10);

	IF ( @P_LOT_ID IS NOT NULL				AND @P_LOT_ID	!= ''  )
		SET @MEXEC = @MEXEC+'	AND SC.LOT_ID				= ''' + @P_LOT_ID				+ '''	' + CHAR(10);
	  
	SET @MEXEC = @MEXEC+'	ORDER BY SC.PLANT_ID, IE.MODEL_ID, SC.ITEM_ID, SC.LOT_ID				' + CHAR(10);

	print @mexec;

	EXEC(@MEXEC);
	;
END




