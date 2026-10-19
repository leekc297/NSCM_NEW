
/*
 * Program ID   : SSP0018_PRODUCTION_PLAN_OSP
 * Description  : SSP0018_GET_PRODUCTION_PLAN_OSP
 * Program History
 *===========================================================================================================
 *   Date       In Charge		Description
 *===========================================================================================================
 * 2019/04/30	MCTHEJ			[PJ20189106] 전지.GSCM 고도화 이행- GET PRODUCTION PLAN OSP UPLOAD
 */
                        
 CREATE PROCEDURE [dbo].[SSP0018_GET_PRODUCTION_PLAN_OSP]
	@p_division_id			NVARCHAR(60),
	@p_from_site			NVARCHAR(60),
	@p_item_id				NVARCHAR(100),
	@p_from_yyyymmdd		NVARCHAR(MAX),
	@p_to_yyyymmdd			NVARCHAR(MAX),
	@p_user_id				NVARCHAR(150),
	@p_program_id			NVARCHAR(MAX) = 'SSP0018' ,
	@p_sheet_name			NVARCHAR(MAX) = 'Production Plan(OSP)'
AS

BEGIN
    SET NOCOUNT ON;
	
	DECLARE @mQuery NVARCHAR(MAX);
	DECLARE @mEXEC NVARCHAR(MAX);

	-- PIVOIT 대상 날짜문자열 생성
	SET @mQuery = '';
	
	SELECT  @mQuery = @mQuery+','+ CASE WHEN CHARINDEX('M_', yyyymmdd) =1 THEN  'SUM(CASE WHEN yyyymm   = RIGHT('''+yyyymmdd+''',6) THEN QTY END ) AS ' + yyyymmdd
										WHEN CHARINDEX('W_', yyyymmdd) =1 THEN  'SUM(CASE WHEN iso_week = RIGHT('''+yyyymmdd+''',6) THEN  QTY  END ) AS ' + yyyymmdd
										WHEN CHARINDEX('D_', yyyymmdd) =1 THEN  'SUM(CASE WHEN yyyymmdd = '''+yyyymmdd+''' THEN  QTY  END ) AS ' + yyyymmdd
									END +''+CHAR(10)
	FROM ( 
		SELECT 'W_'+a.basis_yyyymm + a.iso_week AS yyyymmdd        
			, a.basis_start_date + CONVERT(CHAR(2), 21) AS sort_order_no
			FROM [dbo].[scm_sys_calendar_m] a
		WHERE a.basis_yyyymmdd  BETWEEN @p_from_yyyymmdd AND @p_to_yyyymmdd
		GROUP BY a.basis_yyyymm, a.iso_week, a.basis_start_date
		UNION ALL
		SELECT 'M_'+a.basis_yyyymm  AS yyyymmdd
				,MIN(a.basis_start_date) + CONVERT(CHAR(2), '01') AS sort_order_no
			FROM [dbo].[scm_sys_calendar_m] a
			WHERE a.basis_yyyymmdd  BETWEEN @p_from_yyyymmdd AND @p_to_yyyymmdd
		GROUP BY a.basis_yyyymm, a.month_name		
		UNION ALL
		SELECT 'D_'+a.basis_yyyymmdd   AS yyyymmdd      
				, a.basis_yyyymmdd + CONVERT(CHAR(2), 31) AS sort_order_no
			FROM [dbo].[scm_sys_calendar_m] a
			WHERE a.basis_yyyymmdd  BETWEEN @p_from_yyyymmdd AND @p_to_yyyymmdd
		GROUP BY a.basis_yyyymmdd		
	) AS A
	ORDER BY sort_order_no  ;
	
	--select @mQuery;

	IF( LEN(@mQuery)>0)
	BEGIN
		SET @mQuery = LEFT(@mQuery, LEN(@mQuery) - 1);

		SET @mEXEC = '';

		SET @mEXEC = @mEXEC + '		SELECT																																					'+CHAR(10);
		SET @mEXEC = @mEXEC + '			T0.DIVISION_ID,		T0.SCM_SITE_ID AS PLANT_SITE,		T0.ITEM_ID,                                                                                                    '+CHAR(10);
		SET @mEXEC = @mEXEC + '			(SELECT TOP 1 isnull(NULLIF(NICK_NAME,''''),''-'') FROM DBO.SCM_MST_ITEM_SN T1 WITH(NOLOCK) WHERE 1=1 AND T1.ITEM_ID = T0.item_id) as nick_name    '+CHAR(10);
		SET @mEXEC = @mEXEC + '		'+@mQuery	;
		SET @mEXEC = @mEXEC + '		FROM (                                                                                                              '+CHAR(10);	
		SET @mEXEC = @mEXEC + '			SELECT ' + CHAR(10);
		SET @mEXEC = @mEXEC + '				T2.DIVISION_ID,		T2.SCM_SITE_ID,		T2.ITEM_ID, ' + CHAR(10);
		SET @mEXEC = @mEXEC + '				''D_'' + T2.YYYYMMDD AS YYYYMMDD, T3.basis_yyyymm AS yyyymm, RIGHT(T3.basis_yyyymm, 4)+T3.iso_week AS iso_week, T2.QTY ' + CHAR(10);
		SET @mEXEC = @mEXEC + '			FROM SSP_ANL_PROD_PLAN_OSP T2 WITH(NOLOCK) ' + CHAR(10);
		SET @mEXEC = @mEXEC + '			INNER JOIN SCM_SYS_CALENDAR_M T3 WITH(NOLOCK) ON T2.YYYYMMDD = T3.basis_yyyymmdd' + CHAR(10);
		SET @mEXEC = @mEXEC + '			WHERE 1 = 1                                                                                                                                             '+CHAR(10);
		SET @mEXEC = @mEXEC + '			AND T2.YYYYMMDD >= ''' + @p_from_yyyymmdd + '''                                                                                                            ' + char(10) ;
		SET @mEXEC = @mEXEC + '			AND T2.YYYYMMDD <= ''' + @p_to_yyyymmdd + '''																											' + char(10) ;
		iF ( @p_division_id IS NOT NULL AND @p_division_id    != '') SET @mEXEC = @mEXEC + '	AND T2.DIVISION_ID IN (''' + @p_division_id + ''')'+char(10);                     
		IF ( @p_from_site   IS NOT NULL AND @p_from_site    != '') SET @mEXEC = @mEXEC + '	AND  T2.FROM_SITE IN (''' + @p_from_site + ''')'+char(10);                     
		IF ( @p_item_id     IS NOT NULL AND @p_item_id    != ''  ) SET @mEXEC = @mEXEC + ' 	AND  T2.ITEM_ID IN (''' + @p_item_id + ''')'+char(10);                     
		SET @mEXEC = @mEXEC + '		) T0 ' + CHAR(10);
		SET @mEXEC = @mEXEC + '		GROUP BY T0.DIVISION_ID, T0.SCM_SITE_ID, T0.ITEM_ID ' + CHAR(10);
		SET @mEXEC = @mEXEC + '		ORDER BY T0.DIVISION_ID, T0.SCM_SITE_ID, T0.ITEM_ID ' + CHAR(10);
		
		
		--SELECT @mEXEC;
		EXEC(@mEXEC);
	END;
	
	  
END;	
