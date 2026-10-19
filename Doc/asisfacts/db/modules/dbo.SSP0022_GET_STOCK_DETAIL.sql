
/*
 * PROGRAM ID   : SSP0022_GET_STOCK_DETAIL
 * DESCRIPTION  : 전극 SHIPMENT REQUEST
 * PROGRAM HISTORY
 *===================================================================================================
 *   DATE       IN CHARGE		DESCRIPTION
 *===================================================================================================
 * 2020-05-14   KIMYONGHO		신규추가
 * 2020-07-21   juhlee   		Pallet id 추가  
 * 2020-07-21   KIMYONGHO   		'ELECTRODE_SHIP_STORAGE'  재고 집계 제외 대상 추가

 */
CREATE PROCEDURE [dbo].[SSP0022_GET_STOCK_DETAIL]
	@P_DIVISION_ID			VARCHAR(10)
	,@P_COMPANY_ID			NVARCHAR(100)
	,@P_PLAN_START_YYYYMMDD	NVARCHAR(8)
	,@P_FROM_YYYYMMDD		NVARCHAR(8)
	,@P_TO_YYYYMMDD		NVARCHAR(8)
	,@P_PLANT_ID			NVARCHAR(MAX)
	,@P_CELL_TYPE			NVARCHAR(MAX)
	,@P_LOT_ID			NVARCHAR(MAX)
	,@P_ITEM_ID			NVARCHAR(MAX)
	,@P_MODEL_ID			NVARCHAR(MAX)
	,@P_NICK_NAME			NVARCHAR(MAX)
	,@P_USER_ID			NVARCHAR(MAX)
	,@P_PROGRAM_ID			NVARCHAR(MAX) = 'SSP0022' 
	,@P_SHEET_NAME			NVARCHAR(MAX) = 'Stock Detail'
	,@P_REAL_FLAG			CHAR(1)
	,@P_NON_CHK			CHAR(1)
	,@P_MY_MODEL_CHK		CHAR(1)
	,@P_DELEGATE_CHK		CHAR(1)
	,@P_PART_LEADER_CHK		CHAR(1)
	,@P_TEAM_LEADER_CHK		CHAR(1)
AS  
  
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @mDQry NVARCHAR(MAX)='';

	SET @mDqry = @mDQry + '	SELECT T0.DIVISION_ID																													' + char(10);
	SET @mDqry = @mDQry + '		, T0.PLANT_ID																														' + char(10);
	SET @mDqry = @mDQry + '		, ISNULL(T1.CELL_TYPE,''-'') AS CELL_TYPE																									' + char(10);
	SET @mDqry = @mDQry + '		, T1.MODEL_ID																														' + char(10);
	SET @mDqry = @mDQry + '		, T0.ITEM_ID																														' + char(10);
	SET @mDqry = @mDQry + '		, T1.ITEM_ID_NICK_NAME AS NICK_NAME																									' + char(10);
	SET @mDqry = @mDQry + '		, T0.VERSION																														' + char(10);
	SET @mDqry = @mDQry + '		, CONVERT(decimal(5,2),T1.LANE) AS LANE																									' + char(10);
	SET @mDqry = @mDQry + '		, T0.LOT_ID																														' + char(10);
	SET @mDqry = @mDQry + '		, T0.PALLET_ID																														' + char(10);
	--SET @mDqry = @mDQry + '		, T0.STORAGE_ID  + ''(''+T2.STORAGE_DESCRIPTION+'')'' AS STORAGE_ID	'																			 + char(10);
	SET @mDqry = @mDQry + '		, T0.STORAGE_ID  AS STORAGE_ID																										' + char(10);
	SET @mDqry = @mDqry + '		, T0.OPERATION_ID									 AS OPERATION_ID																	'+ CHAR(10);
	SET @mDqry = @mDQry + '		, B.SEGMENT2 AS CHANGE_STATUS																											' + char(10);
	-- FLOOR - > CEILING 으로 변경 KIMYONGHO 2020-09-03
	SET @mDqry = @mDQry + '		, CEILING(T0.IWMS_QTY)							      AS IWMS_QTY_UOM																	' + char(10);
	SET @mDqry = @mDQry + '		, CEILING(T0.IWMS_QTY * ISNULL(T1.CONVERT_TO_PCM,  1))		 AS IWMS_QTY_PCM																	' + char(10);
	SET @mDqry = @mDQry + '		, CEILING(T0.GMES_QTY)							      AS GMES_QTY_UOM																	' + char(10);
	SET @mDqry = @mDQry + '		, CEILING(T0.GMES_QTY * ISNULL(T1.CONVERT_TO_PCM,  1))		 AS GMES_QTY_PCM																	' + char(10);
	SET @mDqry = @mDQry + '		, CEILING(T0.OWMS_QTY)							      AS OWMS_QTY_UOM																	' + char(10);
	SET @mDqry = @mDQry + '		, CEILING(T0.OWMS_QTY * ISNULL(T1.CONVERT_TO_PCM,  1))		 AS OWMS_QTY_PCM																	' + char(10);
	SET @mDqry = @mDQry + '		, CEILING(T0.TOT_QTY)								 AS TOTAL_QTY_UOM																	' + char(10);
	SET @mDqry = @mDQry + '		, CEILING(T0.TOT_QTY * ISNULL(T1.CONVERT_TO_PCM,  1))		 AS TOTAL_QTY_PCM																	' + char(10);
	SET @mDqry = @mDQry + '		, T0.AVAILABLE_YN																													' + char(10);
	SET @mDqry = @mDQry + '		, T0.IWMS_HOLD_YN																													' + char(10);
	SET @mDqry = @mDQry + '		, T0.GMES_HOLD_YN AS MES_HOLD_YN																										' + char(10);
	SET @mDqry = @mDQry + '		, T0.QMS_HOLD_YN																													' + char(10);
	SET @mDqry = @mDQry + '		, T0.OWMS_HOLD_YN																													' + char(10);														
	--SET @mDqry = @mDQry + '		--, CONVERT(VARCHAR(10),   CONVERT(DATETIME, CASE  T0.EXPIRATION_DATE WHEN '' THEN NULL ELSE  T0.EXPIRATION_DATE END ,112), 23) AS EXPIRATION_DATE			' + char(10);
	SET @mDqry = @mDQry + '		, T0.EXPIRATION_DATE																												' + char(10);
	SET @mDqry = @mDQry + '		, T0.PACKAGE_TYPE AS PACKAGE_TYPE_CODE																									' + char(10);
	SET @mDqry = @mDQry + '	FROM SSP_ANL_STOCK_EE_C T0 WITH(NOLOCK)																										' + char(10);
	IF @P_NON_CHK != 'Y'
		BEGIN
			SET @mDqry =@mDqry+'		 JOIN SSP_MST_MODEL_USER_EE MMU WITH(NOLOCK)								' + CHAR(10);
			SET @mDqry =@mDqry+'		   ON MMU.DIVISION_ID = T0.DIVISION_ID									' + CHAR(10) ;
			SET @mDqry =@mDqry+'		  AND MMU.TO_SITE   = T0.FROM_SITE									' + CHAR(10) ;
			SET @mDqry =@mDqry+'		  AND MMU.ITEM_ID     = T0.ITEM_ID										' + CHAR(10) ;
			SET @mDqry =@mDqry+'		  AND MMU.VALID_YN    = ''Y''											' + CHAR(10) ;
			SET @mDqry =@mDqry+'		  AND (( MMU.USER_ID IN (SELECT CASE WHEN ''' + @P_MY_MODEL_CHK + ''' = ''Y'' THEN ''' + @P_USER_ID + ''' ELSE ''X'' END				' + char(10) ;
			SET @mDqry =@mDqry+'								  UNION 																										' + char(10) ;
			SET @mDqry =@mDqry+'								 SELECT CASE WHEN ''' + @P_DELEGATE_CHK + ''' = ''Y'' THEN USER_ID ELSE ''X'' END								' + char(10) ;
			SET @mDqry =@mDqry+'								   FROM SSP_MST_DELEGATE WHERE VALID_YN = ''Y'' AND DELEGATEE_ID = ''' + @P_USER_ID + ''' GROUP BY USER_ID) 	' + char(10) ;
			SET @mDqry =@mDqry+'					OR MMU.PART_LEADER = CASE WHEN ''' + @P_PART_LEADER_CHK + ''' = ''Y'' THEN ''' + @P_USER_ID + ''' ELSE ''X'' END			' + char(10) ;
			SET @mDqry =@mDqry+'					OR MMU.TEAM_LEADER = CASE WHEN ''' + @P_TEAM_LEADER_CHK + ''' = ''Y'' THEN ''' + @P_USER_ID + ''' ELSE ''X'' END))			' + char(10) ;
		END
	SET @mDqry = @mDQry + '	LEFT OUTER JOIN SSP_MST_SITE_ITEM_EE_V T1 WITH(NOLOCK)																							' + char(10);
	SET @mDqry = @mDQry + '		ON T0.DIVISION_ID = T1.ASSY_DIVISION_ID																									' + char(10);
	SET @mDqry = @mDQry + '		AND T0.FROM_SITE = T1.ASSY_SCM_SITE_ID																									' + char(10);
	SET @mDqry = @mDQry + '		AND T0.ITEM_ID = T1.ITEM_ID																											' + char(10);
	SET @mDqry = @mDQry + '	LEFT OUTER JOIN SCM_MST_SLOC T2 WITH(NOLOCK)																									' + char(10);
	SET @mDqry = @mDQry + '		ON T0.PLANT_ID = T2.PLANT_ID																											' + char(10);
	SET @mDqry = @mDQry + '		AND T0.STORAGE_ID = T2.STORAGE_ID																										' + char(10);
	SET @mDqry = @mDQry + '		AND T0.DIVISION_ID = T2.DIVISION_ID 																									' + char(10);
	SET @mDqry = @mDQry + '	JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B	WITH(NOLOCK)																									' + char(10);
	SET @mDqry = @mDQry + '		ON LOOKUP_TYPE = ''MES_CHANGE_STATUS''																									' + char(10);
	SET @mDqry = @mDQry + '		AND B.VALID_YN    = ''Y''																											' + char(10);
	SET @mDqry = @mDQry + '		AND B.SEGMENT1 = T0.CHANGE_STATUS																										' + char(10);
	SET @mDqry = @mDQry + '	WHERE  T0.PLAN_START_YYYYMMDD  = ''' +@P_PLAN_START_YYYYMMDD  + '''																				' + char(10);
	SET @mDqry = @mDQry + '	AND T0.TYPE = ''A''																														' + char(10);
	SET @mDqry = @mDQry + '	AND T0.DIVISION_ID = '''+@P_DIVISION_ID +'''																									' + char(10);
	SET @mDqry = @mDQry + '	AND T0.COMPANY_ID  = '''+@P_COMPANY_ID	 +'''																								' + char(10);
	/*  2020-07-21   KIMYONGHO   		'ELECTRODE_SHIP_STORAGE'  재고 집계 제외 대상 추가  보류*/
	--SET @mDQry = @mDQry + '	AND NOT EXISTS ( SELECT 1   																												' + char(10);	
	--SET @mDQry = @mDQry + '				  FROM SCM_ADM_LOOKUP_MASTER_DETAIL L																							' + char(10);	
	--SET @mDQry = @mDQry + '				  WHERE 1=1																												' + char(10);	
	--SET @mDQry = @mDQry + '				  AND L.LOOKUP_TYPE =  ''ELECTRODE_SHIP_STORAGE''																					' + char(10);	
	--SET @mDQry = @mDQry + '				  AND L.SEGMENT4    =  ''R''																									' + char(10);	
	--SET @mDQry = @mDQry + '				  AND L.VALID_YN    =  ''Y''																									' + char(10);
	--SET @mDQry = @mDQry + '				  AND L.ATTRIBUTE2  =  T0.DIVISION_ID																							' + char(10);	
	--SET @mDQry = @mDQry + '				  AND L.SEGMENT2    =  T0.FROM_SITE																							' + char(10);	
	--SET @mDQry = @mDQry + '				  AND L.ATTRIBUTE3	=  T0.PLANT_ID																								' + char(10);	
	--SET @mDQry = @mDQry + '				  AND L.SEGMENT3	=  T0.STORAGE_ID																							' + char(10);		
	--SET @mDQry = @mDQry + '				)																														' + char(10);
	
	IF ( @P_PLANT_ID     IS NOT NULL AND @P_PLANT_ID    != ''  ) 
			SET @mDQry = @mDQry + ' 	AND SUBSTRING(T0.FROM_SITE,1,4)       IN ('''+ @P_PLANT_ID     +''')		 ' + char(10);	
	
	IF ( @P_ITEM_ID     IS NOT NULL AND @P_ITEM_ID    != ''  ) 
			SET @mDQry = @mDQry + ' 	AND T0.ITEM_ID       IN ('''+ @P_ITEM_ID     +''')		 ' + char(10);	
	
	IF ( @P_MODEL_ID     IS NOT NULL AND @P_MODEL_ID    != ''  ) 
			SET @mDQry = @mDQry + ' 	AND T1.MODEL_ID      IN ('''+ @P_MODEL_ID     +''')		 ' + char(10);	
	
	IF ( @P_NICK_NAME     IS NOT NULL AND @P_NICK_NAME    != ''  ) 
			SET @mDQry = @mDQry + ' 	AND T1.ITEM_ID_NICK_NAME      IN ('''+ @P_NICK_NAME     +''')		 ' + char(10);	
	
	IF ( @P_CELL_TYPE     IS NOT NULL AND @P_CELL_TYPE    != ''  ) 
			SET @mDQry = @mDQry + ' 	AND T1.CELL_TYPE_GROUP_CODE       IN ('''+ @P_CELL_TYPE     +''')		 ' + char(10);	
	
	IF ( @P_LOT_ID     IS NOT NULL AND @P_LOT_ID    != ''  ) 
			SET @mDQry = @mDQry + ' 	AND T0.LOT_ID      IN ('''+ @P_LOT_ID     +''')		 ' + char(10);	

	SET @mDqry = @mDQry + '	ORDER BY T0.PLANT_ID, T1.MODEL_ID, T0.ITEM_ID, T0.LOT_ID		' + char(10);	
	
	
	print @mDqry;

	EXEC(@mDqry);
	;
	--SET @mDqry = @mDQry + '	AND ((@P_PLANT_ID IS NULL OR @P_PLANT_ID ='') OR SUBSTRING(T0.FROM_SITE,1,4) IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@P_PLANT_ID , ',')))						' + char(10);
	--SET @mDqry = @mDQry + '	AND ((@P_ITEM_ID IS NULL OR @P_ITEM_ID ='' ) OR T0.ITEM_ID IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@P_ITEM_ID, ','))) 										' + char(10);
	--SET @mDqry = @mDQry + '	AND (( @P_CELL_TYPE IS NULL OR @P_CELL_TYPE ='')	OR T1.CELL_TYPE_GROUP_CODE  IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@P_CELL_TYPE , ',')))						' + char(10);
	--SET @mDqry = @mDQry + '	AND ((@P_LOT_ID IS NULL OR @P_LOT_ID ='') OR T0.LOT_ID IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@P_LOT_ID , ',')))											' + char(10);
	--SET @mDqry = @mDQry + '	ORDER BY T0.PLANT_ID, T1.MODEL_ID, T0.ITEM_ID, T0.LOT_ID																						' + char(10);

END
