
/*
 * PROGRAM ID   : SSP0026_GET_RESULT_DETAIL
 * DESCRIPTION  : Packer SHIPMENT RESULT
 * PROGRAM HISTORY
 *===================================================================================================
 *   DATE       IN CHARGE		DESCRIPTION
 *===================================================================================================
 * 2020-08-13   KIMYONGHO		신규추가
 * 2020-09-25   KIMYONGHO		FROM SITE,  SITE_DESCRIPTION 추가
 * 2020-10-13   KIMYONGHO		Plant Site, Salse Site 다중 선택 조회 가능 하도록 변경
 * 2021-11-29   SMS		        Ship to 추가
 */
CREATE PROCEDURE [dbo].[SSP0026_GET_RESULT_DETAIL]
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

	DECLARE @v_plan_start_date		 [NVARCHAR](8);
	DECLARE @v_plan_end_date			 [NVARCHAR](8);
	DECLARE @v_cutoff_date		      [NVARCHAR](8);
	DECLARE @v_plan_start_yyyymmdd   [NVARCHAR](8);
	DECLARE @IF_GROUP_NO             [NVARCHAR](50)   = FORMAT(CURRENT_TIMESTAMP, 'yyyyMMddHHmmss');

	SET @v_plan_start_yyyymmdd = CONVERT(CHAR(8), GETDATE(), 112);
	SET @v_plan_start_date = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112);

	SELECT @v_plan_end_date = BASIS_END_DATE
	FROM   SCM_SYS_CALENDAR_M
	WHERE  BASIS_YYYYMMDD = CONVERT(VARCHAR, DATEADD(D, 64, CONVERT(DATETIME, @v_plan_start_date ,112)) ,112)
	
	SET @v_cutoff_date = CONVERT(VARCHAR, DATEADD(D, -1, CONVERT(DATETIME, @v_plan_start_date ,112)) ,112)

	SET @mDqry = @mDQry + 'SELECT									' + char(10);	
	SET @mDqry = @mDQry + '	  A.DIVISION_ID		 AS DIVISION_ID	' + char(10);
	SET @mDqry = @mDQry + '	, A.ITEM_ID			AS MODEL_ID 							' + char(10);
	SET @mDqry = @mDQry + '	, I.NICK_NAME	AS NICK_NAME		' + char(10);
	SET @mDqry = @mDQry + '	, A.SCM_SITE_ID AS FROM_SITE							' + char(10);
	SET @mDqry = @mDQry + '	, TE.SITE_DESCRIPTION					' + char(10);
	SET @mDqry = @mDQry + '	, A.TO_SITE							' + char(10);
	SET @mDqry = @mDQry + '	, CONVERT(VARCHAR(10),   CONVERT(DATETIME, A.SHIP_DATE,112), 23) AS YYYYMMDD		' + char(10);
	SET @mDqry = @mDQry + '	, A.SHIP_QTY				AS QTY		' + char(10);
	SET @mDqry = @mDQry+  '  , CASE WHEN ISNULL(C.USERNAME,'''') <> '''' THEN C.USERNAME + ''('' + A.LAST_UPDATED_BY + '')'' ELSE ISNULL(A.LAST_UPDATED_BY,''-'') END AS LAST_UPDATED_BY'+CHAR(10);
	SET @mDqry = @mDQry + '  , A.LAST_UPDATE_DATE AS LAST_UPDATED_DATE																					' + char(10);

	SET @mDqry = @mDQry + '  , A.ATTRIBUTE4 AS SHIP_TO																					' + char(10);
	SET @mDqry = @mDQry + '  , SH.SHIPTO_DESCRIPTION																					' + char(10);

	SET @mDqry = @mDQry + 'FROM SCM_DNM_SCS_SHIP_RESULT A					' + char(10);
	SET @mDqry = @mDQry + 'JOIN SCP_MST_FINAL_ITEM I WITH(NOLOCK)		' + char(10);																					
	SET @mDqry = @mDQry + '		ON A.DIVISION_ID = I.DIVISION_ID				' + char(10);																																								
	SET @mDqry = @mDQry + '		AND A.ITEM_ID = I.ITEM_ID						' + char(10);
	SET @mDqry = @mDQry + 'LEFT OUTER JOIN SCM_MST_SITE EC  WITH(NOLOCK)						' + char(10);	
	SET @mDqry = @mDQry + '   ON EC.DIVISION_ID = A.DIVISION_ID								' + char(10);
	SET @mDqry = @mDQry + '   AND EC.SCM_SITE_ID = A.TO_SITE								' + char(10);
	SET @mDqry = @mDQry + '	 AND EC.VALID_YN = ''Y''										' + char(10);
	SET @mDqry = @mDQry + 'LEFT OUTER JOIN SCM_MST_SITE TE  WITH(NOLOCK)						' + char(10);	
	SET @mDqry = @mDQry + '   ON TE.DIVISION_ID = A.DIVISION_ID								' + char(10);
	SET @mDqry = @mDQry + '   AND TE.SCM_SITE_ID = A.SCM_SITE_ID								' + char(10);
	SET @mDqry = @mDQry + '	 AND TE.VALID_YN = ''Y''										' + char(10);
	SET @mDqry = @mDQry + 'LEFT OUTER JOIN (SELECT UserID, UserName FROM TB_FX_User WITH(NOLOCK)) C     '+CHAR(10);
	SET @mDQry = @mDQry + '  ON A.LAST_UPDATED_BY = C.UserID								'+CHAR(10);
	SET @mDqry = @mDQry + '	AND A.DIVISION_ID = '''+@p_division_id+'''					' + char(10);

	--20211129  SMS  추가  Shipto Description																	
	SET @mDqry = @mDQry + 'LEFT OUTER JOIN (SELECT DIVISION_ID, SHIPTO_CODE, MAX(SHIPTO_DESCRIPTION) AS SHIPTO_DESCRIPTION FROM SCM_MST_CUSTOMER WITH(NOLOCK)     '+CHAR(10);
	SET @mDqry = @mDQry + ' WHERE DIVISION_ID = ''40'' GROUP BY DIVISION_ID, SHIPTO_CODE) SH     '+CHAR(10);
	SET @mDQry = @mDQry + '  ON A.DIVISION_ID = SH.DIVISION_ID								'+CHAR(10);
	SET @mDqry = @mDQry + '	AND A.ATTRIBUTE4 = SH.SHIPTO_CODE					' + char(10);

	SET @mDqry = @mDQry + ' WHERE A.DIVISION_ID = '''+@p_division_id+'''					' + char(10);
	--SET @mDqry = @mDQry + '   AND A.CUTOFF_DATE = '''+ @v_cutoff_date +'''				' + char(10);
	SET @mDqry = @mDQry + '   AND A.SHIP_DATE >= '''+ @p_from_yyyymmdd +'''	AND A.SHIP_DATE <= '''+ @p_to_yyyymmdd +'''					' + char(10);

	--* 2020-10-13   KIMYONGHO		Plant Site, Salse Site 다중 선택 조회 가능 하도록 변경
	IF ( @p_plant_site_id     IS NOT NULL AND @p_plant_site_id    != ''  ) 
			--SET @mDQry = @mDQry + ' 	AND A.FROM_SITE      IN ('''+ @p_plant_site_id     +''')		 ' + char(10);	
			SET @mDQry = @mDQry + ' 	AND (( ''' + @p_plant_site_id + '''   IS NULL OR ''' + @p_plant_site_id + ''' ='''')   OR A.SCM_SITE_ID	  IN (SELECT TOKEN FROM DBO.STRING_SPLIT('''+@p_plant_site_id+''' , '','')))		 ' + char(10);	

	IF ( @p_scm_site_id     IS NOT NULL AND @p_scm_site_id    != ''  ) 
			--SET @mDQry = @mDQry + ' 	AND A.TO_SITE      IN ('''+ @p_scm_site_id     +''')		 ' + char(10);	
			SET @mDQry = @mDQry + ' 	AND (( ''' + @p_scm_site_id + '''   IS NULL OR ''' + @p_scm_site_id + ''' ='''')   OR A.TO_SITE	  IN (SELECT TOKEN FROM DBO.STRING_SPLIT('''+@p_scm_site_id+''' , '','')))		 ' + char(10);	

	IF ( @p_item_id     IS NOT NULL AND @p_item_id    != ''  ) 
			SET @mDQry = @mDQry + ' 	AND (( ''' + @p_item_id + '''   IS NULL OR ''' + @p_item_id + ''' ='''')   OR A.ITEM_ID	  IN (SELECT TOKEN FROM DBO.STRING_SPLIT('''+@p_item_id+''' , '','')))		 ' + char(10);	

	IF (@p_customer IS NOT NULL AND @p_customer !='')
			SET @mDQry = @mDQry+'	AND (( '''+@p_customer+'''   IS NULL OR '''+@p_customer+''' ='''')   OR EC.SOLDTO_CUSTOMER	  IN (SELECT TOKEN FROM DBO.STRING_SPLIT('''+@p_customer+''' , '','')))      ' + char(10);	        

	IF ( @p_nick_name     IS NOT NULL AND @p_nick_name    != ''  ) 
			SET @mDQry = @mDQry + ' 	AND I.NICK_NAME      IN ('''+ @p_nick_name     +''')		 ' + char(10);	
	-- 20211110	SHINMYUNGSU	SHIP_DATE로 정렬
	--SET @mDqry = @mDQry + 'ORDER BY  A.SCM_SITE_ID, A.ITEM_ID, A.TO_SITE, A.SHIP_DATE ASC				' + char(10);
	SET @mDqry = @mDQry + 'ORDER BY  A.SHIP_DATE, A.SCM_SITE_ID, A.ITEM_ID, A.TO_SITE  ASC				' + char(10);

	PRINT 	@mDqry													
	EXEC(@mDqry);
	;
																				

END
