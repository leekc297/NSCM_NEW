
/*
 * PROGRAM ID   : SSP0022_GET_REQUEST_DETAIL
 * DESCRIPTION  : 전극 SHIPMENT REQUEST
 * PROGRAM HISTORY
 *===================================================================================================
 *   DATE       IN CHARGE		DESCRIPTION
 *===================================================================================================
 * 2020-05-14   KIMYONGHO		신규추가
 * 2020-09-21   KIMYONGHO		SSP INCOTERMS 변경 작업
 * 2021/09/02   KIMYONGHO       -> SCP_MST_BOD_N_V 변경
 */
CREATE PROCEDURE [dbo].[SSP0022_GET_REQUEST_DETAIL]
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
	,@P_REQUESTOR_ID		NVARCHAR(MAX)
	,@P_PROGRAM_ID			NVARCHAR(MAX) = 'SSP0022' 
	,@P_SHEET_NAME			NVARCHAR(MAX) = 'Shipment Request Detail'
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


	SET @mDqry = @mDQry + 'SELECT									' + char(10);	
	SET @mDqry = @mDQry + '	A.TO_DIVISION_ID		 AS DIVISION_ID	' + char(10);
	SET @mDqry = @mDQry + '	, A.FROM_DIVISION_ID	 AS ORIGIN_DIVISION_ID	' + char(10);
	SET @mDqry = @mDQry + '	, A.BOD_ID 							' + char(10);
	SET @mDqry = @mDQry + '	, A.MODEL_ID							' + char(10);
	SET @mDqry = @mDQry + '	, A.ITEM_ID 							' + char(10);
	SET @mDqry = @mDQry + '	, I.ITEM_ID_NICK_NAME	AS NICK_NAME		' + char(10);
	SET @mDqry = @mDQry + '	, A.TO_PLANT_ID		AS PLANT_ID	 	' + char(10);
	SET @mDqry = @mDQry + '	, A.TO_SITE			AS SCM_SITE_ID 	' + char(10);
	SET @mDqry = @mDQry + '	, A.FROM_SITE							' + char(10);
	SET @mDqry = @mDQry + '	, A.TO_SITE							' + char(10);
	SET @mDqry = @mDQry + '	, A.ETD_DATE							' + char(10);
	SET @mDqry = @mDQry + '	, CONVERT(VARCHAR(10),   CONVERT(DATETIME, A.ETA_DATE,112), 23) AS SHIPMENT_DATE		' + char(10);
	SET @mDqry = @mDQry + '	, A.QTY				AS SHIPMENT_QTY		' + char(10);
	--* 2020-09-21   KIMYONGHO		SSP INCOTERMS 변경 작업
	--SET @mDqry = @mDQry + '	, V.INCOTERMS							' + char(10);
	SET @mDqry = @mDQry + '	, V.SSP_INCOTERMS AS INCOTERMS			' + char(10);
	SET @mDqry = @mDQry + '	, V.TRANSPORT_MODE						' + char(10);
	SET @mDqry = @mDQry + '  , CASE WHEN ISNULL(I.ELECTRODE_POST_OPER_LT,0) >  ISNULL(TD.SHIP_FROZEN,0)																																											' + char(10);									
	SET @mDqry = @mDQry + '  		THEN  																																																				' + char(10);
	SET @mDqry = @mDQry + '  			CONVERT(CHAR(10), DATEADD(DD, ISNULL(DATEDIFF(DD, '''+@P_PLAN_START_YYYYMMDD+''', [dbo].[FN_GET_SSP_ETA_DATE](A.FROM_DIVISION_ID, A.BOD_ID, CONVERT(CHAR(8),DATEADD(DD,ISNULL(I.ELECTRODE_POST_OPER_LT,0) + 0, '''+@P_PLAN_START_YYYYMMDD+'''),112))) ,0) , '''+@P_PLAN_START_YYYYMMDD+'''), 23) 		' + char(10);
	SET @mDqry = @mDQry + '  																																																							' + char(10);
	SET @mDqry = @mDQry + '  		ELSE																																																					' + char(10);
	SET @mDqry = @mDQry + '  			CONVERT(CHAR(10), DATEADD(DD, ISNULL(DATEDIFF(DD, '''+@P_PLAN_START_YYYYMMDD+''', [dbo].[FN_GET_SSP_ETA_DATE](A.FROM_DIVISION_ID, A.BOD_ID, CONVERT(CHAR(8),DATEADD(DD,ISNULL(TD.SHIP_FROZEN,0) + 0, '''+@P_PLAN_START_YYYYMMDD+'''),112))) ,0)  , '''+@P_PLAN_START_YYYYMMDD+'''), 23) 	' + char(10);
	SET @mDqry = @mDQry + '  		END AS CONFIRM_DAY																																																		' + char(10);

	SET @mDqry = @mDQry + ' , CASE WHEN ISNULL(I.ELECTRODE_POST_OPER_LT,0) >  ISNULL(TD.SHIP_FROZEN,0)																																											' + char(10);
  	SET @mDqry = @mDQry + '	THEN  																																																						 ' + char(10);		
  	SET @mDqry = @mDQry + '		CASE WHEN CONVERT(CHAR(10), DATEADD(DD, ISNULL(DATEDIFF(DD, '''+@P_PLAN_START_YYYYMMDD+''', [dbo].[FN_GET_SSP_ETA_DATE](A.FROM_DIVISION_ID, A.BOD_ID, CONVERT(CHAR(8),DATEADD(DD,ISNULL(I.ELECTRODE_POST_OPER_LT,0) + 0, '''+@P_PLAN_START_YYYYMMDD+'''),112))) ,0) , '''+@P_PLAN_START_YYYYMMDD+'''), 23)	 <=  CONVERT(VARCHAR(10),   CONVERT(DATETIME, A.ETA_DATE,112), 23) THEN ''Y'' ELSE ''N'' END 		' + char(10);																																																				
  	SET @mDqry = @mDQry + '	ELSE																																																																		' + char(10);
  	SET @mDqry = @mDQry + '		CASE WHEN CONVERT(CHAR(10), DATEADD(DD, ISNULL(DATEDIFF(DD, '''+@P_PLAN_START_YYYYMMDD+''', [dbo].[FN_GET_SSP_ETA_DATE](A.FROM_DIVISION_ID, A.BOD_ID, CONVERT(CHAR(8),DATEADD(DD,ISNULL(TD.SHIP_FROZEN,0) + 0, '''+@P_PLAN_START_YYYYMMDD+'''),112))) ,0)  , '''+@P_PLAN_START_YYYYMMDD+'''), 23) 	 <=  CONVERT(VARCHAR(10),   CONVERT(DATETIME, A.ETA_DATE,112), 23) THEN ''Y'' ELSE ''N'' END	' + char(10);																																																			
  	SET @mDqry = @mDQry + '	END AS EDIT_FLAG																																																																' + char(10);
	SET @mDqry = @mDQry+'         , CASE WHEN ISNULL(C.USERNAME,'''') <> '''' THEN C.USERNAME + ''('' + A.LAST_UPDATED_BY + '')'' ELSE ISNULL(A.LAST_UPDATED_BY,''-'') END AS REQUESTOR			'+CHAR(10);
	SET @mDqry = @mDQry + '  		, A.LAST_UPDATE_DATE AS REQUEST_DATE																																																		' + char(10);
	SET @mDqry = @mDQry + 'FROM SSP_ANL_SHIP_REQ_EE A WITH(NOLOCK)					' + char(10);
	SET @mDqry = @mDQry + '	LEFT OUTER JOIN SSP_MST_SITE_ITEM_EE_V I WITH(NOLOCK)		' + char(10);																					
	SET @mDqry = @mDQry + '		ON A.FROM_DIVISION_ID = I.DIVISION_ID				' + char(10);																					
	SET @mDqry = @mDQry + '		AND A.FROM_SITE = I.SCM_SITE_ID				' + char(10);																					
	SET @mDqry = @mDQry + '		AND A.ITEM_ID = I.ITEM_ID						' + char(10);					
	IF @P_NON_CHK != 'Y'
		BEGIN
			SET @mDqry =@mDqry+'		 JOIN SSP_MST_MODEL_USER_EE MMU WITH(NOLOCK)								' + CHAR(10);
			SET @mDqry =@mDqry+'		   ON MMU.DIVISION_ID = A.TO_DIVISION_ID								' + CHAR(10) ;
			SET @mDqry =@mDqry+'		  AND MMU.TO_SITE     = A.TO_SITE										' + CHAR(10) ;
			SET @mDqry =@mDqry+'		  AND MMU.ITEM_ID     = A.ITEM_ID										' + CHAR(10) ;
			SET @mDqry =@mDqry+'		  AND MMU.VALID_YN    = ''Y''											' + CHAR(10) ;
			SET @mDqry =@mDqry+'		  AND (( MMU.USER_ID IN (SELECT CASE WHEN ''' + @P_MY_MODEL_CHK + ''' = ''Y'' THEN ''' + @P_USER_ID + ''' ELSE ''X'' END				' + char(10) ;
			SET @mDqry =@mDqry+'								  UNION 																										' + char(10) ;
			SET @mDqry =@mDqry+'								 SELECT CASE WHEN ''' + @P_DELEGATE_CHK + ''' = ''Y'' THEN USER_ID ELSE ''X'' END								' + char(10) ;
			SET @mDqry =@mDqry+'								   FROM SSP_MST_DELEGATE WHERE VALID_YN = ''Y'' AND DELEGATEE_ID = ''' + @P_USER_ID + ''' GROUP BY USER_ID) 	' + char(10) ;
			SET @mDqry =@mDqry+'					OR MMU.PART_LEADER = CASE WHEN ''' + @P_PART_LEADER_CHK + ''' = ''Y'' THEN ''' + @P_USER_ID + ''' ELSE ''X'' END			' + char(10) ;
			SET @mDqry =@mDqry+'					OR MMU.TEAM_LEADER = CASE WHEN ''' + @P_TEAM_LEADER_CHK + ''' = ''Y'' THEN ''' + @P_USER_ID + ''' ELSE ''X'' END))			' + char(10) ;
		END
	SET @mDqry = @mDQry + 'JOIN SCP_MST_BOD_N_V V WITH(NOLOCK)											' + char(10);
	SET @mDqry = @mDQry + '	ON V.DIVISION_ID = A.FROM_DIVISION_ID							' + char(10);
	SET @mDqry = @mDQry + '	AND V.BOD_ID = A.BOD_ID										' + char(10);
	SET @mDqry = @mDQry + '	AND V.FROM_SITE = A.FROM_SITE										' + char(10);
	SET @mDqry = @mDQry + '	AND V.TO_SITE = A.TO_SITE										' + char(10);
	SET @mDqry = @mDQry + 'LEFT OUTER JOIN SCM_MST_SITE TD WITH(NOLOCK)						' + char(10);
	SET @mDqry = @mDQry + '	ON A.FROM_DIVISION_ID	= TD.DIVISION_ID							' + char(10);
	SET @mDqry = @mDQry + '	AND V.FROM_SITE	= TD.SCM_SITE_ID							' + char(10);
	SET @mDqry = @mDQry + 'LEFT OUTER JOIN (SELECT UserID, UserName FROM TB_FX_User WITH(NOLOCK)) C     '+CHAR(10);
	SET @mDQry = @mDQry + '  ON A.LAST_UPDATED_BY = C.UserID								'+CHAR(10);
	SET @mDqry = @mDQry + 'WHERE A.TO_DIVISION_ID = '''+@P_DIVISION_ID+'''					' + char(10);
	SET @mDqry = @mDQry + ' AND A.TO_COMPANY_ID = '''+@P_COMPANY_ID+'''					' + char(10);
	SET @mDqry = @mDQry + ' AND A.ETA_DATE >= '''+ @p_from_yyyymmdd +'''	AND A.ETA_DATE <= '''+ @p_to_yyyymmdd +'''					' + char(10);
	SET @mDqry = @mDQry + ' AND V.BOD_VALID_YN =''Y''										' + char(10);

	IF ( @P_PLANT_ID     IS NOT NULL AND @P_PLANT_ID    != ''  ) 
			SET @mDQry = @mDQry + ' 	AND A.TO_PLANT_ID       IN ('''+ @P_PLANT_ID     +''')		 ' + char(10);	
	
	IF ( @P_ITEM_ID     IS NOT NULL AND @P_ITEM_ID    != ''  ) 
			SET @mDQry = @mDQry + ' 	AND A.ITEM_ID       IN ('''+ @P_ITEM_ID     +''')		 ' + char(10);	
	
	IF ( @P_MODEL_ID     IS NOT NULL AND @P_MODEL_ID    != ''  ) 
			SET @mDQry = @mDQry + ' 	AND A.MODEL_ID      IN ('''+ @P_MODEL_ID     +''')		 ' + char(10);	
	
	IF ( @P_NICK_NAME     IS NOT NULL AND @P_NICK_NAME    != ''  ) 
			SET @mDQry = @mDQry + ' 	AND I.ITEM_ID_NICK_NAME      IN ('''+ @P_NICK_NAME     +''')		 ' + char(10);	
	
	IF ( @P_CELL_TYPE     IS NOT NULL AND @P_CELL_TYPE    != ''  ) 
			SET @mDQry = @mDQry + ' 	AND I.CELL_TYPE_GROUP_CODE       IN ('''+ @P_CELL_TYPE     +''')		 ' + char(10);	
	
	IF ( @P_LOT_ID     IS NOT NULL AND @P_LOT_ID    != ''  ) 
			SET @mDQry = @mDQry + ' 	AND A.LOT_ID      IN ('''+ @P_LOT_ID     +''')		 ' + char(10);	
	
	IF ( @P_REQUESTOR_ID     IS NOT NULL AND @P_REQUESTOR_ID    != ''  )
		BEGIN
			SET @mDQry = @mDQry + ' 					AND  A.LAST_UPDATED_BY       IN (															' + char(10);
			SET @mDQry = @mDQry + '													SELECT DISTINCT TT1.UserID FROM (						' + char(10);
			SET @mDQry = @mDQry + '													(SELECT UserID FROM TB_FX_User							' + char(10);
			SET @mDQry = @mDQry + '													WHERE 1 = 1												' + char(10);
			SET @mDQry = @mDQry + '													AND UserName		IN (N''' + @P_REQUESTOR_ID + ''')			' + char(10);
			SET @mDQry = @mDQry + '													UNION ALL												' + char(10);
			SET @mDQry = @mDQry + '													SELECT UserID FROM TB_FX_User							' + char(10);
			SET @mDQry = @mDQry + '													WHERE 1 = 1												' + char(10);
			SET @mDQry = @mDQry + '													AND UserID		IN (''' + @P_REQUESTOR_ID + '''))) TT1			' + char(10);
			SET @mDQry = @mDQry + '												)															' + char(10);
		END
	
	SET @mDqry = @mDQry + 'ORDER BY  A.FROM_SITE, A.MODEL_ID, A.TO_SITE, A.ITEM_ID, A.ETA_DATE ASC				' + char(10);

															
	print @mDqry;

	EXEC(@mDqry);
	;
																				

END
