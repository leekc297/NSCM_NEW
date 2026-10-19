
/*
 * PROGRAM ID   : SSP0026_GET_REQUEST_DETAIL_PACK
 * DESCRIPTION  : Packer SHIPMENT REQUEST
 * PROGRAM HISTORY
 *===================================================================================================
 *   DATE       IN CHARGE		DESCRIPTION
 *===================================================================================================
 * 2020-10-07   KIMYONGHO		신규추가
 * 2020-10-13   KIMYONGHO		Plant Site, Salse Site 다중 선택 조회 가능 하도록 변경
 * 2021/09/02   KIMYONGHO      SCP_MST_BOD_v -> SCP_MST_BOD_N_V 변경
 * 2021/11/01   SMS             Shipment Date로 정렬
 */
CREATE PROCEDURE [dbo].[SSP0026_GET_REQUEST_DETAIL_PACK]
	@p_sheet_name     NVARCHAR(10),
	@p_division_id    NVARCHAR(30),
	@p_team_id        NVARCHAR(MAX),
	@p_customer       NVARCHAR(MAX),
	@p_scm_site_id    NVARCHAR(MAX),
	@p_plant_site_id  NVARCHAR(MAX),
	@p_project_code   NVARCHAR(MAX),
	@p_item_id        NVARCHAR(MAX),
	@p_from_yyyymmdd  NVARCHAR(8),
	@p_to_yyyymmdd    NVARCHAR(8),
	@p_nick_name	   NVARCHAR(MAX),
	@p_requestor_id   NVARCHAR(MAX),
	@p_created_by	   NVARCHAR(MAX),
	@debug_mode       NVARCHAR(1)='F'
AS  
  
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;



	DECLARE @mDQry NVARCHAR(MAX)='';


	SET @mDqry = @mDQry + 'SELECT																						' + char(10);	
	SET @mDqry = @mDQry + '	  A.DIVISION_ID		 AS DIVISION_ID															' + char(10);
	SET @mDqry = @mDQry + '	,  CASE WHEN A.CONFIRM_ID IS NULL THEN ''Plan'' ELSE ''Confirm'' END		 AS STATUS		' + char(10);
	SET @mDqry = @mDQry + '	, isnull(A.REQUEST_ID,A.CONFIRM_ID)		 AS REQUEST_ID															' + char(10);
	SET @mDqry = @mDQry + '	, A.BOD_ID 																					' + char(10);
	SET @mDqry = @mDQry + '	, A.ITEM_ID		AS MODEL_ID																				' + char(10);
	SET @mDqry = @mDQry + '	, I.NICK_NAME	AS NICK_NAME																' + char(10);
	SET @mDqry = @mDQry + '	, V.FROM_SITE																				' + char(10);
	SET @mDqry = @mDQry + '	, TE.SITE_DESCRIPTION																		' + char(10);
	SET @mDqry = @mDQry + '	, V.TO_SITE																					' + char(10);
	SET @mDqry = @mDQry + '	, TD.SOLDTO_CODE																			' + char(10);
	SET @mDqry = @mDQry + '	, A.SHIPTO_CODE																				' + char(10);
	SET @mDqry = @mDQry + '	, TC.SHIPTO_DESCRIPTION AS SHIPTO_NAME														' + char(10);
	SET @mDqry = @mDQry + '	, CONVERT(VARCHAR(10),   CONVERT(DATETIME, A.YYYYMMDD,112), 23) AS YYYYMMDD					' + char(10);
	SET @mDqry = @mDQry + '	, A.QTY				AS QTY																	' + char(10);
	-- 20201223 incoterms 변경 작업 modify KIMYONGHO
	SET @mDqry = @mDQry + '	, V.SSP_INCOTERMS		AS INCOTERMS														' + char(10);
	SET @mDqry = @mDQry + '	, V.TRANSPORT_MODE	 AS TR_MODE																' + char(10);
	SET @mDqry = @mDQry+'    , A.FCST_TYPE			AS FCST_TYPE														' + CHAR(10);			
	SET @mDqry = @mDQry + '	, A.ORDER_TYPE_DETAIL																		' + char(10);
	SET @mDqry = @mDQry + '	, A.REMARK																					' + char(10);
	SET @mDqry = @mDQry+  '  , CASE WHEN ISNULL(C.USERNAME,'''') <> '''' THEN C.USERNAME + ''('' + A.LAST_UPDATED_BY + '')'' ELSE ISNULL(A.LAST_UPDATED_BY,''-'') END AS LAST_UPDATED_BY	' + CHAR(10);
	SET @mDqry = @mDQry + '  , A.LAST_UPDATE_DATE AS LAST_UPDATED_DATE																														' + char(10);
	SET @mDqry = @mDQry+  '  , CASE WHEN A.CONFIRM_ID IS NULL THEN CASE WHEN convert(varchar(8), GETDATE() + TE.SHIP_FROZEN , 112)  <  CONVERT(VARCHAR(10),   CONVERT(DATETIME, A.YYYYMMDD,112), 23) THEN ''Y'' ELSE ''N'' END ELSE ''N'' END AS EDIT_FLAG	' + char(10);	
	SET @mDqry = @mDQry+  '  , EC.SOLDTO_CUSTOMER AS END_CUSTOMER																															' + char(10);	
	SET @mDqry = @mDQry + '  , DBO.FN_GET_SSP_MKT_OWNER_NAME (SI.OWNER, '','', ''KO'') AS MKT_OWMER                                                                                         ' + char(10);
	SET @mDqry = @mDQry + '  , CONVERT(VARCHAR(10),   CONVERT(DATETIME, [dbo].[FN_GET_SSP_ETD_DATE] (A.DIVISION_ID, A.BOD_ID, A.YYYYMMDD),112), 23)  AS ETD_DATE                            ' + char(10);                                                    
	SET @mDqry = @mDQry + '  , CONVERT(VARCHAR(10),   CONVERT(DATETIME, [dbo].[FN_GET_SSP_ETA_DATE] (A.DIVISION_ID, A.BOD_ID, A.YYYYMMDD),112), 23)  AS ETA_DATE                            ' + char(10);             
	SET @mDqry = @mDQry + '  , CONVERT(VARCHAR(10),   CONVERT(DATETIME, [dbo].[FN_GET_SSP_EXPECTED_SHIP_DATE] (A.DIVISION_ID, A.BOD_ID, A.YYYYMMDD),112), 23) AS EXPECTED_SHIP_DATE                                                            ' + char(10);
	SET @mDqry = @mDQry + '  , V.LT_TOTAL_SSP AS LT_TOTAL                                                                           ' + char(10);
	SET @mDqry = @mDQry + '  , h.CHANGE_REQ_NO AS CHANGE_REQ_NO                                                                     ' + char(10);
	SET @mDqry = @mDQry + '  , CASE WHEN ''KO'' = ''KO'' THEN U2.UserName ELSE U2.UserName_E END + ''('' + mu.user_id + '')'' model_user    ' + char(10);
	SET @mDqry = @mDQry + '  , ISNULL(A.ATTRIBUTE3,''-'') AS ATTRIBUTE3    ' + char(10);
	SET @mDqry = @mDQry + '  , ISNULL(A.ATTRIBUTE4,''-'') AS ATTRIBUTE4    ' + char(10);
	SET @mDqry = @mDQry + '  , ISNULL(A.ATTRIBUTE5,''-'') AS ATTRIBUTE5    ' + char(10);
	SET @mDqry = @mDQry + '  , ISNULL(A.ATTRIBUTE6,''-'') AS ATTRIBUTE6    ' + char(10);
	SET @mDqry = @mDQry + 'FROM [DBO].[SSP_ANL_SHIP_REQ_P] A WITH(NOLOCK)														    ' + char(10);
-- ******************************************************************************************************************************************************
	SET @mDqry = @mDQry + 'JOIN SCP_MST_FINAL_ITEM I WITH(NOLOCK)																	' + char(10);																					
	SET @mDqry = @mDQry + '		ON A.DIVISION_ID = I.DIVISION_ID																	' + char(10);																																								
	SET @mDqry = @mDQry + '		AND A.ITEM_ID = I.ITEM_ID																			' + char(10);					
	SET @mDqry = @mDQry + 'JOIN SCP_MST_BOD_N_V V WITH(NOLOCK)																		' + char(10);
	SET @mDqry = @mDQry + '	ON V.DIVISION_ID = A.DIVISION_ID																		' + char(10);
	SET @mDqry = @mDQry + '	AND V.BOD_ID = A.BOD_ID																					' + char(10);
	
	SET @mDqry = @mDQry + 'LEFT OUTER JOIN SCM_MST_SITE_CUSTOMER TD WITH(NOLOCK)													' + char(10);
	SET @mDqry = @mDQry + '	ON A.DIVISION_ID	= TD.DIVISION_ID																	' + char(10);
	SET @mDqry = @mDQry + '	AND V.TO_SITE		= TD.SCM_SITE_ID																	' + char(10);
	SET @mDqry = @mDQry + '	AND A.SHIPTO_CODE	= TD.SHIPTO_CODE																	' + char(10);
	SET @mDqry = @mDQry + '	AND TD.REP_YN	= ''Y''																					' + char(10);
	SET @mDqry = @mDQry + '	AND TD.VALID_YN	= ''Y''																					' + char(10);
	
	--SET @mDqry = @mDQry + 'LEFT OUTER JOIN SCM_MST_CUSTOMER TC  WITH(NOLOCK)														' + char(10);	
	--SET @mDqry = @mDQry + '   ON A.DIVISION_ID = TC.DIVISION_ID																	' + char(10);
	--SET @mDqry = @mDQry + '   AND TD.SOLDTO_CODE = TC.SOLDTO_CODE																' + char(10);
	--SET @mDqry = @mDQry + '   AND A.SHIPTO_CODE = TC.SHIPTO_CODE																' + char(10);
	
	-- 현재 소형 외주 Packer 출하 지시의 경우 SOLDTO_CODE는 관리하지 않아 JOIN시 SOLDTO_CODE가 분할될수있어 제외 변경 처리 Modify by KIMYONGHO
	SET @mDqry = @mDQry + 'LEFT OUTER JOIN (SELECT DISTINCT DIVISION_ID,SHIPTO_CODE, SHIPTO_DESCRIPTION, VALID_YN FROM SCM_MST_CUSTOMER WITH(NOLOCK)) TC ' + char(10);	
	SET @mDqry = @mDQry + '   ON A.DIVISION_ID = TC.DIVISION_ID																	' + char(10);
	SET @mDqry = @mDQry + '   AND A.SHIPTO_CODE = TC.SHIPTO_CODE																' + char(10);
	SET @mDqry = @mDQry + '   AND TC.VALID_YN = ''Y''																			' + char(10);
	
	SET @mDqry = @mDQry + 'LEFT OUTER JOIN SCM_MST_SITE TE  WITH(NOLOCK)														' + char(10);	
	SET @mDqry = @mDQry + '   ON TE.DIVISION_ID = A.DIVISION_ID																	' + char(10);
	SET @mDqry = @mDQry + '   AND TE.SCM_SITE_ID = V.FROM_SITE																	' + char(10);
	SET @mDqry = @mDQry + '	 AND TE.VALID_YN = ''Y''																			' + char(10);
	SET @mDqry = @mDQry + 'LEFT OUTER JOIN SCM_MST_SITE EC  WITH(NOLOCK)														' + char(10);	
	SET @mDqry = @mDQry + '   ON EC.DIVISION_ID = A.DIVISION_ID																	' + char(10);
	SET @mDqry = @mDQry + '   AND EC.SCM_SITE_ID = V.TO_SITE																	' + char(10);
	SET @mDqry = @mDQry + '	 AND EC.VALID_YN = ''Y''																			' + char(10);
	SET @mDqry = @mDQry + 'LEFT OUTER JOIN (SELECT UserID, UserName FROM TB_FX_User WITH(NOLOCK)) C								' + CHAR(10);
	SET @mDQry = @mDQry + '  ON A.LAST_UPDATED_BY = C.UserID																	' + CHAR(10);
	SET @mDqry = @mDQry + '	AND A.DIVISION_ID = '''+@p_division_id+'''															' + char(10);
	SET @mDqry = @mDQry + ' AND V.BOD_VALID_YN =''Y''																			' + char(10);
--	SET @mDqry = @mDQry + ' WHERE A.QTY > 0																				' + char(10);
	SET @mDqry = @mDQry + 'LEFT OUTER JOIN (SELECT DIVISION_ID, SCM_SITE_ID, ITEM_ID, OWNER, MAX(PROJECT_CODE) AS PROJECT_CODE FROM SCM_MST_SITE_ITEM WITH(NOLOCK) GROUP BY DIVISION_ID, SCM_SITE_ID, ITEM_ID,OWNER ) SI					' + char(10);
	SET @mDqry = @mDQry + ' 			 ON SI.DIVISION_ID  = A.DIVISION_ID								AND SI.SCM_SITE_ID  = V.TO_SITE								' + char(10);
	SET @mDqry = @mDQry + ' 										AND SI.ITEM_ID		= A.ITEM_ID								' + char(10);
	SET @mDqry = @mDQry + ' 										AND SI.PROJECT_CODE = EC.SOLDTO_CUSTOMER					' + char(10);

	--SET @mDqry = @mDQry + 'LEFT OUTER JOIN SCM_MST_SITE_ITEM SI WITH(NOLOCK) ON SI.DIVISION_ID  = A.DIVISION_ID					' + char(10);
	--SET @mDqry = @mDQry + ' 										AND SI.SCM_SITE_ID  = V.TO_SITE								' + char(10);
	--SET @mDqry = @mDQry + ' 										AND SI.ITEM_ID		= A.ITEM_ID								' + char(10);
	--SET @mDqry = @mDQry + ' 										AND SI.PROJECT_CODE = EC.SOLDTO_CUSTOMER					' + char(10);
	SET @mDqry = @mDQry + ' LEFT OUTER JOIN (SELECT CONFIRM_ID, CHANGE_REQ_NO FROM(								' + char(10);
	SET @mDqry = @mDQry + ' 	  	SELECT CONFIRM_ID ,CHANGE_REQ_NO								' + char(10);
	SET @mDqry = @mDQry + ' 	  		  ,ROW_NUMBER() OVER(PARTITION BY CONFIRM_ID ORDER BY CHANGE_REQ_NO DESC) NUM								' + char(10);
	SET @mDqry = @mDQry + ' 	  	FROM SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE								' + char(10);
	SET @mDqry = @mDQry + ' 	  	WHERE VALID_YN = ''Y''								' + char(10);
	SET @mDqry = @mDQry + ' 	  ) A WHERE NUM = 1) h on h.confirm_id = a.confirm_id								' + char(10);
	SET @mDqry = @mDQry + ' LEFT OUTER JOIN SSP_MST_MODEL_USER mu on mu.division_id = a.division_id and mu.from_site = V.from_site and mu.item_id = a.ITEM_ID and mu.valid_yn = ''Y''                                                                                                              ' + char(10);
	SET @mDqry = @mDQry + ' LEFT OUTER JOIN TB_FX_User U2 ON mu.user_id = u2.UserID AND U2.UseYN = ''Y''                                             ' + char(10);
	SET @mDqry = @mDQry + '   WHERE A.DIVISION_ID = '''+@p_division_id+'''														' + char(10);
	SET @mDqry = @mDQry + '   AND A.YYYYMMDD >= '''+ @p_from_yyyymmdd +'''	AND A.YYYYMMDD <= '''+ @p_to_yyyymmdd +'''			' + char(10);
	SET @mDqry = @mDQry + '   AND A.YYYYMMDD >= '''+ @p_from_yyyymmdd +'''	AND A.YYYYMMDD <= '''+ @p_to_yyyymmdd +'''			' + char(10);
	SET @mDqry = @mDQry + '   AND A.QTY > 0			' + char(10);

	--* 2020-10-13   KIMYONGHO		Plant Site, Salse Site 다중 선택 조회 가능 하도록 변경
	IF ( @p_plant_site_id     IS NOT NULL AND @p_plant_site_id    != ''  ) 
			--SET @mDQry = @mDQry + ' 	AND A.FROM_SITE      IN ('''+ @p_plant_site_id     +''')		 ' + char(10);	
			SET @mDQry = @mDQry + ' 	AND (( ''' + @p_plant_site_id + '''   IS NULL OR ''' + @p_plant_site_id + ''' ='''')   OR V.FROM_SITE	  IN (SELECT TOKEN FROM DBO.STRING_SPLIT('''+@p_plant_site_id+''' , '','')))		 ' + char(10);	

	IF ( @p_scm_site_id     IS NOT NULL AND @p_scm_site_id    != ''  ) 
			--SET @mDQry = @mDQry + ' 	AND A.TO_SITE      IN ('''+ @p_scm_site_id     +''')		 ' + char(10);	
			SET @mDQry = @mDQry + ' 	AND (( ''' + @p_scm_site_id + '''   IS NULL OR ''' + @p_scm_site_id + ''' ='''')   OR V.TO_SITE	  IN (SELECT TOKEN FROM DBO.STRING_SPLIT('''+@p_scm_site_id+''' , '','')))		 ' + char(10);	

	IF ( @p_item_id     IS NOT NULL AND @p_item_id    != ''  ) 
			SET @mDQry = @mDQry + ' 	AND (( ''' + @p_item_id + '''   IS NULL OR ''' + @p_item_id + ''' ='''')   OR A.ITEM_ID	  IN (SELECT TOKEN FROM DBO.STRING_SPLIT('''+@p_item_id+''' , '','')))		 ' + char(10);	

	IF (@p_customer IS NOT NULL AND @p_customer !='')
			SET @mDQry = @mDQry+'	AND (( '''+@p_customer+'''   IS NULL OR '''+@p_customer+''' ='''')   OR EC.SOLDTO_CUSTOMER	  IN (SELECT TOKEN FROM DBO.STRING_SPLIT('''+@p_customer+''' , '','')))      ' + char(10);	        

	IF ( @p_nick_name     IS NOT NULL AND @p_nick_name    != ''  ) 
			SET @mDQry = @mDQry + ' 	AND I.NICK_NAME      IN ('''+ @p_nick_name     +''')			' + char(10);	
	
	IF ( @p_requestor_id  IS NOT NULL AND @p_requestor_id    != ''  )
		BEGIN
			SET @mDQry = @mDQry + ' 					AND  A.LAST_UPDATED_BY       IN (																' + char(10);
			SET @mDQry = @mDQry + '													SELECT DISTINCT TT1.UserID FROM (								' + char(10);
			SET @mDQry = @mDQry + '													(SELECT UserID FROM TB_FX_User								' + char(10);
			SET @mDQry = @mDQry + '													WHERE 1 = 1												' + char(10);
			SET @mDQry = @mDQry + '													AND UserName		IN (N''' + @p_requestor_id + ''')				' + char(10);
			SET @mDQry = @mDQry + '													UNION ALL													' + char(10);
			SET @mDQry = @mDQry + '													SELECT UserID FROM TB_FX_User									' + char(10);
			SET @mDQry = @mDQry + '													WHERE 1 = 1												' + char(10);
			SET @mDQry = @mDQry + '													AND UserID		IN (''' + @p_requestor_id + '''))) TT1			' + char(10);
			SET @mDQry = @mDQry + '												)															' + char(10);
		END
	
--	SET @mDqry = @mDQry + 'ORDER BY V.FROM_SITE, A.ITEM_ID, V.TO_SITE, A.SHIPTO_CODE, A.YYYYMMDD ASC 													' + char(10);
	SET @mDqry = @mDQry + 'ORDER BY A.YYYYMMDD, V.FROM_SITE, A.ITEM_ID, V.TO_SITE, A.SHIPTO_CODE ASC 													' + char(10);

	PRINT @mDqry	
	
	EXEC(@mDqry);
	;
																				

END
