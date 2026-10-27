

/*
 * Program ID   : PR_UI_FP02320_PANCAKE_MASTER
 * Description  : Pancake Master
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021-03-25   CYS				Initial Release UI통합
 */

CREATE PROCEDURE [dbo].[PR_UI_FP02320_PANCAKE_MASTER_KSI]
  
  @p_sys_type			NVARCHAR(MAX),  
  @p_sys_flag			NVARCHAR(MAX),
  @p_sys_gubun			NVARCHAR(MAX),  
  @p_user_id			NVARCHAR(MAX),
  @p_division_id		NVARCHAR(MAX),
  @p_site_id			NVARCHAR(MAX),
  @p_plant_id			NVARCHAR(MAX),
  @p_factory_id			NVARCHAR(MAX),
  @p_item_id			NVARCHAR(MAX),
  @p_nick_name			NVARCHAR(MAX),
  @p_bucket_from		NVARCHAR(100),
  @p_bucket_to			NVARCHAR(100),
  @p_active_flag		NVARCHAR(MAX)
  
AS 
BEGIN
	
    SET NOCOUNT ON;
	
	DECLARE @v_proc_name	nvarchar(100) = 'PR_UI_FP02320_PANCAKE_MASTER';
	DECLARE @runstart		datetime;
	DECLARE @runend			datetime;
	DECLARE @v_dSql			nvarchar(MAX)='';

	BEGIN
	
		SET	@v_dSql = ''

		SET @v_dSql += '	SELECT 	A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID,A.FACTORY_ID,A.ITEM_ID																					' + char(10)
		SET @v_dSql += '		    ,ISNULL(PD.NICK_NAME, ''-'') AS NICK_NAME                                                                                                               ' + char(10)
		SET @v_dSql += '		    ,A.LANE_QTY, A.SLIT_WIDTH , A.MAIN_LANE_QTY, A.SUB_LANE_QTY	,A.PATTERN_QTY, A.HALF_SLIT_FLAG                                                                               ' + char(10)
		SET @v_dSql += '		    ,A.DESCRIPTION,A.ACTIVE_FLAG                                                                                                               ' + char(10)
		SET @v_dSql += '		    ,A.PROD_VERSION_TYPE                                                                                                                                    ' + char(10)
		SET @v_dSql += '		  	,CASE WHEN PD.ITEM_NAME IS NULL THEN ''Invalid Item Id : '' + A.ITEM_ID ELSE PD.ITEM_NAME END AS ITEM_NAME                                              ' + char(10)
		SET @v_dSql += '		    ,CASE WHEN A.PATTERN_QTY IS NULL OR A.PATTERN_QTY = 0 THEN A.LANE_QTY                                                                                   ' + char(10)
		SET @v_dSql += '		          ELSE A.PATTERN_QTY * A.LANE_QTY END LANE                                                                                                          ' + char(10)
		SET @v_dSql += '		    ,PD.COATED_LENGTH	,PD.UNCOATED_LENGTH, ISNULL(PD.LENGTH_UOM,''mm'') AS LENGTH_UOM                                                                     ' + char(10)
		SET @v_dSql += '		    ,A.PC_ROLL_LENGTH, A.PC_ROLL_LENGTH_UOM                                                                                                                 ' + char(10)
		
		SET @v_dSql += '		    ,A.PROD_VERSION_TYPE AS PROD_VERSION_TYPE_ORG                                                                                                           ' + char(10)
		SET @v_dSql += '		    , CASE WHEN COUNT(PROD_VERSION_TYPE) OVER ( PARTITION BY A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID,A.FACTORY_ID,A.ITEM_ID,A.LANE_QTY              ' + char(10)
		SET @v_dSql += '		    											 ORDER BY A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID,A.FACTORY_ID,A.ITEM_ID,A.LANE_QTY                 ' + char(10)
		SET @v_dSql += '		    											) < 2 AND A.FACTORY_ID = ''E7''  THEN ''Y'' ELSE ''N'' END AS PROD_EDIT                                     ' + char(10)
		SET @v_dSql += '		    -- 작업의뢰서 등록 품번은 입력불가능								                                                                                    ' + char(10)
		SET @v_dSql += '		    , (CASE WHEN R.FACTORY_ID IS NULL OR A.UPDATE_ID = ''PR_XIF_PLM_CONVERSION_RATE_R'' THEN ''N'' ELSE ''Y'' END) EDIT_YN                                        ' + char(10)
		
		SET @v_dSql += '			,A.GPLM_JUMBO_ROLL_LENGTH  ' + char(10)
		SET @v_dSql += '			, A.GPLM_PC_ROLL_LENGTH, A.JUMBO_ROLL_LENGTH, A.PC_ROLL_LENGTH ' + char(10)
		SET @v_dSql += '			,J2.PANCAKE ' + char(10)
		SET @v_dSql += '			,J3.ROLLCAKE ' + char(10)

		SET @v_dSql += '		    , A.UPDATE_ID, CONVERT(VARCHAR,A.UPDATE_TIME,20) AS UPDATE_TIME                                                                                   ' + char(10)
		SET @v_dSql += '	FROM 	SCM_ITEM_LANE_M A WITH(NOLOCK)                                                                                                                          ' + char(10)
		SET @v_dSql += '			LEFT OUTER HASH JOIN (                                                                                                                                  ' + char(10)
		SET @v_dSql += '								   SELECT DISTINCT R.COMPANY_ID, R.DIVISION_ID, R.SITE_ID, R.PLANT_ID, R.FACTORY_ID                                                 ' + char(10)
		SET @v_dSql += '								   FROM   FP_USER_ROLE_INFO_V R WITH(NOLOCK)                                                                                        ' + char(10)
		SET @v_dSql += '								   WHERE  R.USER_ID   = '''+ @p_user_id + '''                                                                                                   ' + char(10)
		SET @v_dSql += '								   AND    R.SAVE_FLAG = ''Y''                                                                                                       ' + char(10)
		SET @v_dSql += '			) R                                                                                                                                                     ' + char(10)
		SET @v_dSql += '			ON   A.COMPANY_ID   = R.COMPANY_ID                                                                                                                      ' + char(10)
		SET @v_dSql += '			AND  A.DIVISION_ID  = R.DIVISION_ID                                                                                                                     ' + char(10)
		SET @v_dSql += '			AND  A.SITE_ID      = R.SITE_ID                                                                                                                         ' + char(10)
		SET @v_dSql += '			AND  A.PLANT_ID     = R.PLANT_ID                                                                                                                        ' + char(10)
		SET @v_dSql += '			AND  A.FACTORY_ID   = R.FACTORY_ID                                                                                                                      ' + char(10)
		
		SET @v_dSql += '			LEFT JOIN SCM_ITEM_M PD WITH(NOLOCK)                                                                                                                    ' + char(10)
		SET @v_dSql += '			ON  A.COMPANY_ID=PD.COMPANY_ID                                                                                                                          ' + char(10)
		SET @v_dSql += '			AND A.DIVISION_ID=PD.DIVISION_ID                                                                                                                        ' + char(10)
		SET @v_dSql += '			AND A.SITE_ID=PD.SITE_ID                                                                                                                                ' + char(10)
		SET @v_dSql += '			AND A.ITEM_ID=PD.ITEM_ID                                                                                                                                ' + char(10)
		
		
	SET @v_dSql += '	LEFT JOIN 			 ' + char(10)
	SET @v_dSql += '	( select S_Pan.COMPANY_ID, S_Pan.DIVISION_ID, S_Pan.SITE_ID, S_Pan.PLANT_ID, S_Pan.FACTORY_ID, S_Pan.ITEM_ID, S_Pan.QTY,  S_Pan.LOT_COUNT,   ' + char(10)
	SET @v_dSql += '		(FORMAT(S_Pan.QTY / S_Pan.LOT_COUNT  , ''##0.###'')) as PANCAKE ' + char(10)
	SET @v_dSql += '			from  ' + char(10)
	SET @v_dSql += '			( ' + char(10)
	SET @v_dSql += '				 select MAX(COMPANY_ID) as COMPANY_ID, MAX(DIVISION_ID) as DIVISION_ID, MAX(SITE_ID) as SITE_ID, ' + char(10)
	SET @v_dSql += '				 MAX(PLANT_ID) as PLANT_ID, MAX(FACTORY_ID) as FACTORY_ID, MAX(ITEM_ID) as ITEM_ID, ' + char(10)
	SET @v_dSql += '				 FORMAT(SUM(QTY), ''##0.###'') as QTY, SUM(LOT_COUNT)as LOT_COUNT, MAX(OPERATION_ID) as OPERATION_ID   ' + char(10)
	SET @v_dSql += '				 from SCM_STOCK_H_V  ' + char(10)

	--	SELECT @v_dSql += '       where    CONVERT(VARCHAR, CUTOFF_DATE, 112) BETWEEN ' +  @v_bucket_from + ' AND ' +  @v_bucket_to + char(10)

	SET @v_dSql += '				 where CUTOFF_DATE BETWEEN ''' + @p_bucket_from + ''' and ''' + @p_bucket_to + '''' + char(10)
	--SET @v_dSql += '				 where CUTOFF_DATE BETWEEN '2022-04-01' and '2022-04-02'   ' + char(10)
	SET @v_dSql += '				 AND OPERATION_ID  > ''E4000''  ' + char(10)
	SET @v_dSql += '				 AND QTY IS NOT NULL ' + char(10)
	SET @v_dSql += '				 AND LOT_COUNT IS NOT NULL ' + char(10)
	SET @v_dSql += '				 group by COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ITEM_ID  ' + char(10)
	SET @v_dSql += '			 ) as S_Pan ) as J2 ON 1=1                                                                                                               ' + char(10)
	SET @v_dSql += '	AND  A.COMPANY_ID   = J2.COMPANY_ID                                                                                                                  ' + char(10)     
	SET @v_dSql += '	AND  A.DIVISION_ID  = J2.DIVISION_ID                                                                                                                 ' + char(10)     
	SET @v_dSql += '	AND  A.SITE_ID      = J2.SITE_ID                                                                                                                     ' + char(10)     
	SET @v_dSql += '	AND  A.PLANT_ID     = J2.PLANT_ID     ' + char(10)
	SET @v_dSql += '	AND  A.FACTORY_ID     = J2.FACTORY_ID     ' + char(10)
	SET @v_dSql += '	AND  A.ITEM_ID     = J2.ITEM_ID     ' + char(10)
	SET @v_dSql += '	LEFT JOIN 	 ' + char(10)
	SET @v_dSql += '	( select S_ROLL.COMPANY_ID, S_ROLL.DIVISION_ID, S_ROLL.SITE_ID, S_ROLL.PLANT_ID, S_ROLL.FACTORY_ID, S_ROLL.ITEM_ID, S_ROLL.QTY,  S_ROLL.LOT_COUNT,   ' + char(10)
	SET @v_dSql += '	(FORMAT(S_ROLL.QTY / S_ROLL.LOT_COUNT  , ''##0.###'')) as ROLLCAKE	 '+ char(10)
	SET @v_dSql += '	from '+ char(10)
	SET @v_dSql += '	( '+ char(10)
	SET @v_dSql += '		 select MAX(COMPANY_ID) as COMPANY_ID, MAX(DIVISION_ID) as DIVISION_ID, MAX(SITE_ID) as SITE_ID, '+ char(10)
	SET @v_dSql += '		 MAX(PLANT_ID) as PLANT_ID, MAX(FACTORY_ID) as FACTORY_ID, MAX(ITEM_ID) as ITEM_ID, '+ char(10)
	SET @v_dSql += '		 FORMAT(SUM(QTY), ''##0.###'') as QTY, SUM(LOT_COUNT)as LOT_COUNT, MAX(OPERATION_ID) as OPERATION_ID  '+ char(10)
	SET @v_dSql += '		 from SCM_STOCK_H_V '+ char(10)
	SET @v_dSql += '				 where CUTOFF_DATE BETWEEN ''' + @p_bucket_from + ''' and ''' + @p_bucket_to + '''' + char(10)
	--SET @v_dSql += '		 where CUTOFF_DATE BETWEEN '2022-04-01' and '2022-04-02'  '+ char(10)
	SET @v_dSql += '		 AND OPERATION_ID  <= ''E4000'' '+ char(10)
	SET @v_dSql += '		 group by COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ITEM_ID '+ char(10)
	SET @v_dSql += '	 ) as S_ROLL where S_ROLL.QTY IS NOT NULL AND S_ROLL.LOT_COUNT IS NOT NULL) as J3 '+ char(10)
	SET @v_dSql += '	 ON 1=1                                                                                                 '+ char(10)             
	SET @v_dSql += '	AND  A.COMPANY_ID   = J3.COMPANY_ID                                                                     '+ char(10)                                                 
	SET @v_dSql += '	AND  A.DIVISION_ID  = J3.DIVISION_ID                                                                    '+ char(10)                                                 
	SET @v_dSql += '	AND  A.SITE_ID      = J3.SITE_ID                                                                        '+ char(10)                                                 
	SET @v_dSql += '	AND  A.PLANT_ID     = J3.PLANT_ID    '+ char(10)
	SET @v_dSql += '	AND  A.FACTORY_ID   = J3.FACTORY_ID    '+ char(10)
	SET @v_dSql += '	AND  A.ITEM_ID      = J3.ITEM_ID    '+ char(10)
		
		
		
		
		
		
		
		
		
		
		
		
		SET @v_dSql += '	WHERE 1=1                                                                                                                                                       ' + char(10)
		SET @v_dSql += '	AND   PD.ACTIVE_FLAG = ''Y''                                                                                                                                    ' + char(10)
		SET @v_dSql += '	AND    EXISTS (                                                                                                                                                 ' + char(10)
		SET @v_dSql += '				    SELECT 1                                                                                                                                        ' + char(10)
		SET @v_dSql += '				    FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)                                                                                                       ' + char(10)
		SET @v_dSql += '				    WHERE  A.COMPANY_ID  = B.COMPANY_ID                                                                                                             ' + char(10)
		SET @v_dSql += '				    AND    A.DIVISION_ID = B.DIVISION_ID                                                                                                            ' + char(10)
		SET @v_dSql += '				    AND    A.SITE_ID     = B.SITE_ID                                                                                                                ' + char(10)
		SET @v_dSql += '				    AND    A.PLANT_ID    = B.PLANT_ID                                                                                                               ' + char(10)
		SET @v_dSql += '				    AND    A.FACTORY_ID  = B.FACTORY_ID                                                                                                             ' + char(10)
		SET @v_dSql += '				    AND    B.USER_ID     = '''+ @p_user_id + '''                                                                                                                ' + char(10)
		SET @v_dSql += '				)                                                                                                                                                   ' + char(10)
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_item_id)) + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('PD.NICK_NAME' , 'LIKE', @p_nick_name)) + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ACTIVE_FLAG' , 'EQ', @p_active_flag)) + char(10);
		SET @v_dSql += '	ORDER BY A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, A.LANE_QTY                                                                              ' + char(10)
	
	END

	IF @p_sys_type = 'SQL'
		BEGIN
			select @v_dSql as [QUERY_VALUE]
		END ELSE BEGIN
			SET @runstart = GetDate()
			BEGIN TRY
				 BEGIN TRAN
					 exec sp_executesql @v_dSql
				 COMMIT TRAN
			END TRY
			BEGIN CATCH
				 ROLLBACK
			END CATCH
			SET @runend = GetDate()
			exec PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_sys_flag,'',@v_dSql, @p_sys_type, @runstart, @runend
		END


		--	SELECT @v_dSql += '       	AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN ' +  @v_bucket_from + ' AND ' +  @v_bucket_to + char(10)

		----back up
		--	SET	@v_dSql = ''
		--SET @v_dSql += '	SELECT 	A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID,A.FACTORY_ID,A.ITEM_ID																					' + char(10)
		--SET @v_dSql += '		    ,ISNULL(PD.NICK_NAME, ''-'') AS NICK_NAME                                                                                                               ' + char(10)
		--SET @v_dSql += '		    ,A.LANE_QTY, A.SLIT_WIDTH , A.MAIN_LANE_QTY, A.SUB_LANE_QTY	,A.PATTERN_QTY, A.HALF_SLIT_FLAG                                                                               ' + char(10)
		--SET @v_dSql += '		    ,A.DESCRIPTION,A.ACTIVE_FLAG                                                                                                               ' + char(10)
		--SET @v_dSql += '		    ,A.PROD_VERSION_TYPE                                                                                                                                    ' + char(10)
		--SET @v_dSql += '		  	,CASE WHEN PD.ITEM_NAME IS NULL THEN ''Invalid Item Id : '' + A.ITEM_ID ELSE PD.ITEM_NAME END AS ITEM_NAME                                              ' + char(10)
		--SET @v_dSql += '		    ,CASE WHEN A.PATTERN_QTY IS NULL OR A.PATTERN_QTY = 0 THEN A.LANE_QTY                                                                                   ' + char(10)
		--SET @v_dSql += '		          ELSE A.PATTERN_QTY * A.LANE_QTY END LANE                                                                                                          ' + char(10)
		--SET @v_dSql += '		    ,PD.COATED_LENGTH	,PD.UNCOATED_LENGTH, ISNULL(PD.LENGTH_UOM,''mm'') AS LENGTH_UOM                                                                     ' + char(10)
		--SET @v_dSql += '		    ,A.PC_ROLL_LENGTH, A.PC_ROLL_LENGTH_UOM                                                                                                                 ' + char(10)
		
		--SET @v_dSql += '		    ,A.PROD_VERSION_TYPE AS PROD_VERSION_TYPE_ORG                                                                                                           ' + char(10)
		--SET @v_dSql += '		    , CASE WHEN COUNT(PROD_VERSION_TYPE) OVER ( PARTITION BY A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID,A.FACTORY_ID,A.ITEM_ID,A.LANE_QTY              ' + char(10)
		--SET @v_dSql += '		    											 ORDER BY A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID,A.FACTORY_ID,A.ITEM_ID,A.LANE_QTY                 ' + char(10)
		--SET @v_dSql += '		    											) < 2 AND A.FACTORY_ID = ''E7''  THEN ''Y'' ELSE ''N'' END AS PROD_EDIT                                     ' + char(10)
		--SET @v_dSql += '		    -- 작업의뢰서 등록 품번은 입력불가능								                                                                                    ' + char(10)
		--SET @v_dSql += '		    , (CASE WHEN R.FACTORY_ID IS NULL OR A.UPDATE_ID = ''PR_XIF_PLM_CONVERSION_RATE_R'' THEN ''N'' ELSE ''Y'' END) EDIT_YN                                        ' + char(10)
		--SET @v_dSql += '		    , A.UPDATE_ID, CONVERT(VARCHAR,A.UPDATE_TIME,20) AS UPDATE_TIME                                                                                   ' + char(10)
		--SET @v_dSql += '	FROM 	SCM_ITEM_LANE_M A WITH(NOLOCK)                                                                                                                          ' + char(10)
		--SET @v_dSql += '			LEFT OUTER HASH JOIN (                                                                                                                                  ' + char(10)
		--SET @v_dSql += '								   SELECT DISTINCT R.COMPANY_ID, R.DIVISION_ID, R.SITE_ID, R.PLANT_ID, R.FACTORY_ID                                                 ' + char(10)
		--SET @v_dSql += '								   FROM   FP_USER_ROLE_INFO_V R WITH(NOLOCK)                                                                                        ' + char(10)
		--SET @v_dSql += '								   WHERE  R.USER_ID   = '''+ @p_user_id + '''                                                                                                   ' + char(10)
		--SET @v_dSql += '								   AND    R.SAVE_FLAG = ''Y''                                                                                                       ' + char(10)
		--SET @v_dSql += '			) R                                                                                                                                                     ' + char(10)
		--SET @v_dSql += '			ON   A.COMPANY_ID   = R.COMPANY_ID                                                                                                                      ' + char(10)
		--SET @v_dSql += '			AND  A.DIVISION_ID  = R.DIVISION_ID                                                                                                                     ' + char(10)
		--SET @v_dSql += '			AND  A.SITE_ID      = R.SITE_ID                                                                                                                         ' + char(10)
		--SET @v_dSql += '			AND  A.PLANT_ID     = R.PLANT_ID                                                                                                                        ' + char(10)
		--SET @v_dSql += '			AND  A.FACTORY_ID   = R.FACTORY_ID                                                                                                                      ' + char(10)
		--SET @v_dSql += '			LEFT JOIN SCM_ITEM_M PD WITH(NOLOCK)                                                                                                                    ' + char(10)
		--SET @v_dSql += '			ON  A.COMPANY_ID=PD.COMPANY_ID                                                                                                                          ' + char(10)
		--SET @v_dSql += '			AND A.DIVISION_ID=PD.DIVISION_ID                                                                                                                        ' + char(10)
		--SET @v_dSql += '			AND A.SITE_ID=PD.SITE_ID                                                                                                                                ' + char(10)
		--SET @v_dSql += '			AND A.ITEM_ID=PD.ITEM_ID                                                                                                                                ' + char(10)
		--SET @v_dSql += '	WHERE 1=1                                                                                                                                                       ' + char(10)
		--SET @v_dSql += '	AND   PD.ACTIVE_FLAG = ''Y''                                                                                                                                    ' + char(10)
		--SET @v_dSql += '	AND    EXISTS (                                                                                                                                                 ' + char(10)
		--SET @v_dSql += '				    SELECT 1                                                                                                                                        ' + char(10)
		--SET @v_dSql += '				    FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)                                                                                                       ' + char(10)
		--SET @v_dSql += '				    WHERE  A.COMPANY_ID  = B.COMPANY_ID                                                                                                             ' + char(10)
		--SET @v_dSql += '				    AND    A.DIVISION_ID = B.DIVISION_ID                                                                                                            ' + char(10)
		--SET @v_dSql += '				    AND    A.SITE_ID     = B.SITE_ID                                                                                                                ' + char(10)
		--SET @v_dSql += '				    AND    A.PLANT_ID    = B.PLANT_ID                                                                                                               ' + char(10)
		--SET @v_dSql += '				    AND    A.FACTORY_ID  = B.FACTORY_ID                                                                                                             ' + char(10)
		--SET @v_dSql += '				    AND    B.USER_ID     = '''+ @p_user_id + '''                                                                                                                ' + char(10)
		--SET @v_dSql += '				)                                                                                                                                                   ' + char(10)
		--SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10);
		--SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10);
		--SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10);
		--SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10);
		--SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_item_id)) + char(10);
		--SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('PD.NICK_NAME' , 'LIKE', @p_nick_name)) + char(10);
		--SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ACTIVE_FLAG' , 'EQ', @p_active_flag)) + char(10);
		--SET @v_dSql += '	ORDER BY A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, A.LANE_QTY                 
		----back up




		-----------
	--	SELECT 	A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID,A.FACTORY_ID,A.ITEM_ID																					
	--	    ,ISNULL(PD.NICK_NAME, '-') AS NICK_NAME                                                                                                               
	--	    ,A.LANE_QTY, A.SLIT_WIDTH , A.MAIN_LANE_QTY, A.SUB_LANE_QTY	,A.PATTERN_QTY, A.HALF_SLIT_FLAG                                                                               
	--	    ,A.DESCRIPTION,A.ACTIVE_FLAG                                                                                                               
	--	    ,A.PROD_VERSION_TYPE                                                                                                                                    
	--	  	,CASE WHEN PD.ITEM_NAME IS NULL THEN 'Invalid Item Id : ' + A.ITEM_ID ELSE PD.ITEM_NAME END AS ITEM_NAME                                              
	--	    ,CASE WHEN A.PATTERN_QTY IS NULL OR A.PATTERN_QTY = 0 THEN A.LANE_QTY                                                                                   
	--	          ELSE A.PATTERN_QTY * A.LANE_QTY END LANE                                                                                                          
	--	    ,PD.COATED_LENGTH	,PD.UNCOATED_LENGTH, ISNULL(PD.LENGTH_UOM,'mm') AS LENGTH_UOM                                                                     
	--	    ,A.PC_ROLL_LENGTH, A.PC_ROLL_LENGTH_UOM                                                                                                                 
	--	    ,A.PROD_VERSION_TYPE AS PROD_VERSION_TYPE_ORG                                                                                                           
	--	    , CASE WHEN COUNT(PROD_VERSION_TYPE) OVER ( PARTITION BY A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID,A.FACTORY_ID,A.ITEM_ID,A.LANE_QTY              
	--	    											 ORDER BY A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID,A.FACTORY_ID,A.ITEM_ID,A.LANE_QTY                 
	--	    											) < 2 AND A.FACTORY_ID = 'E7'  THEN 'Y' ELSE 'N' END AS PROD_EDIT                                     
	--	    , (CASE WHEN R.FACTORY_ID IS NULL OR A.UPDATE_ID = 'PR_XIF_PLM_CONVERSION_RATE_R' THEN 'N' ELSE 'Y' END) EDIT_YN                                        
		    
	--		,A.GPLM_JUMBO_ROLL_LENGTH 
	--		, A.GPLM_PC_ROLL_LENGTH, A.JUMBO_ROLL_LENGTH, A.PC_ROLL_LENGTH
	--		,J2.PANCAKE
	--		,J3.ROLLCAKE
	--		, A.UPDATE_ID, CONVERT(VARCHAR,A.UPDATE_TIME,20) AS UPDATE_TIME                                                                                   
	--FROM 	SCM_ITEM_LANE_M A WITH(NOLOCK)                                                                                                                          
	--		LEFT OUTER HASH JOIN (                                                                                                                                  
	--							   SELECT DISTINCT R.COMPANY_ID, R.DIVISION_ID, R.SITE_ID, R.PLANT_ID, R.FACTORY_ID                                                 
	--							   FROM   FP_USER_ROLE_INFO_V R WITH(NOLOCK)                                                                                        
	--							   WHERE  R.USER_ID   = 'lgda106'                                                                                                   
	--							   AND    R.SAVE_FLAG = 'Y'                                                                                                       
	--		) R                                                                                                                                                     
	--		ON   A.COMPANY_ID   = R.COMPANY_ID                                                                                                                      
	--		AND  A.DIVISION_ID  = R.DIVISION_ID                                                                                                                     
	--		AND  A.SITE_ID      = R.SITE_ID                                                                                                                         
	--		AND  A.PLANT_ID     = R.PLANT_ID                                                          

                                                              
	--		AND  A.FACTORY_ID   = R.FACTORY_ID                                                                                                                      
	--		LEFT JOIN SCM_ITEM_M PD WITH(NOLOCK)                                                                                                                    
	--		ON  A.COMPANY_ID=PD.COMPANY_ID                                                                                                                          
	--		AND A.DIVISION_ID=PD.DIVISION_ID                                                                                                                        
	--		AND A.SITE_ID=PD.SITE_ID                                                                                                                                
	--		AND A.ITEM_ID=PD.ITEM_ID             
			
	--		LEFT JOIN 			
	--		( select S_Pan.COMPANY_ID, S_Pan.DIVISION_ID, S_Pan.SITE_ID, S_Pan.PLANT_ID, S_Pan.FACTORY_ID, S_Pan.ITEM_ID, S_Pan.QTY,  S_Pan.LOT_COUNT,  
	--			(FORMAT(S_Pan.QTY / S_Pan.LOT_COUNT  , '##0.###')) as PANCAKE
		
	--				from 
	--				(
	--					 select MAX(COMPANY_ID) as COMPANY_ID, MAX(DIVISION_ID) as DIVISION_ID, MAX(SITE_ID) as SITE_ID,
	--					 MAX(PLANT_ID) as PLANT_ID, MAX(FACTORY_ID) as FACTORY_ID, MAX(ITEM_ID) as ITEM_ID,
	--					 FORMAT(SUM(QTY), '##0.###') as QTY, SUM(LOT_COUNT)as LOT_COUNT, MAX(OPERATION_ID) as OPERATION_ID  

	--					 from SCM_STOCK_H_V 
	--					 where CUTOFF_DATE BETWEEN '2022-04-01' and '2022-04-02'  
	--					 AND OPERATION_ID  > 'E4000' 
	--					 AND QTY IS NOT NULL
	--					 AND LOT_COUNT IS NOT NULL
	--					 group by COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ITEM_ID 
	--				 ) as S_Pan ) as J2 ON 1=1                                                                                                              
	--		AND  A.COMPANY_ID   = J2.COMPANY_ID                                                                                                                      
	--		AND  A.DIVISION_ID  = J2.DIVISION_ID                                                                                                                     
	--		AND  A.SITE_ID      = J2.SITE_ID                                                                                                                         
	--		AND  A.PLANT_ID     = J2.PLANT_ID    
	--		AND  A.FACTORY_ID     = J2.FACTORY_ID    
	--		AND  A.ITEM_ID     = J2.ITEM_ID    


	--		LEFT JOIN 
			
	--		( select S_ROLL.COMPANY_ID, S_ROLL.DIVISION_ID, S_ROLL.SITE_ID, S_ROLL.PLANT_ID, S_ROLL.FACTORY_ID, S_ROLL.ITEM_ID, S_ROLL.QTY,  S_ROLL.LOT_COUNT,  
	--		(FORMAT(S_ROLL.QTY / S_ROLL.LOT_COUNT  , '##0.###')) as ROLLCAKE
		
	--		from 
	--		(
	--			 select MAX(COMPANY_ID) as COMPANY_ID, MAX(DIVISION_ID) as DIVISION_ID, MAX(SITE_ID) as SITE_ID,
	--			 MAX(PLANT_ID) as PLANT_ID, MAX(FACTORY_ID) as FACTORY_ID, MAX(ITEM_ID) as ITEM_ID,
	--			 FORMAT(SUM(QTY), '##0.###') as QTY, SUM(LOT_COUNT)as LOT_COUNT, MAX(OPERATION_ID) as OPERATION_ID  

	--			 from SCM_STOCK_H_V 
	--			 where CUTOFF_DATE BETWEEN '2022-04-01' and '2022-04-02'  
	--			 AND OPERATION_ID  <= 'E4000' 

	--			 group by COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ITEM_ID 
	--		 ) as S_ROLL where S_ROLL.QTY IS NOT NULL AND S_ROLL.LOT_COUNT IS NOT NULL) as J3 
	--		 ON 1=1                                                                                                              
	--		AND  A.COMPANY_ID   = J3.COMPANY_ID                                                                                                                      
	--		AND  A.DIVISION_ID  = J3.DIVISION_ID                                                                                                                     
	--		AND  A.SITE_ID      = J3.SITE_ID                                                                                                                         
	--		AND  A.PLANT_ID     = J3.PLANT_ID    
	--		AND  A.FACTORY_ID   = J3.FACTORY_ID    
	--		AND  A.ITEM_ID      = J3.ITEM_ID    

	--WHERE 1=1                                                                                                                                                       
	--AND   PD.ACTIVE_FLAG = 'Y'                                                                                                                                    
	--AND    EXISTS (                                                                                                                                                 
	--			    SELECT 1                                                                                                                                        
	--			    FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)                                                                                                       
	--			    WHERE  A.COMPANY_ID  = B.COMPANY_ID                                                                                                             
	--			    AND    A.DIVISION_ID = B.DIVISION_ID                                                                                                            
	--			    AND    A.SITE_ID     = B.SITE_ID                                                                                                                
	--			    AND    A.PLANT_ID    = B.PLANT_ID                                                                                                               
	--			    AND    A.FACTORY_ID  = B.FACTORY_ID                                                                                                             
	--			    AND    B.USER_ID     = 'lgda106'                                                                                                                
	--			)                                                                                                                                                   

 --AND A.DIVISION_ID IN (N'40',N'81',N'82') 

 --AND A.SITE_ID IN (N'A001',N'A002',N'A003',N'A004') 

 --AND A.PLANT_ID IN (N'A010',N'A011',N'A040',N'A041',N'A050',N'F030',N'G182',N'G183',N'G184',N'G382',N'G383',N'G388',N'G451',N'G452',N'G481',N'G482',N'G631',N'G632',N'G634') 

 --AND A.FACTORY_ID IN (N'A1',N'A2',N'A3',N'A4',N'A5',N'A6',N'A7',N'A8',N'A9',N'AA',N'AC',N'E2',N'E3',N'E4',N'E5',N'E6',N'E7',N'E9',N'EA',N'EB',N'EC',N'ED',N'EE',N'EF',N'EG',N'EH',N'EJ',N'EK',N'M1',N'M2',N'M4',N'M5',N'M6',N'M7',N'M8',N'M9',N'P1',N'P2',N'P4',N'P5',N'P6',N'P7',N'P8',N'PA',N'PB',N'PC',N'S2',N'S3',N'S4') 



	--ORDER BY A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, A.LANE_QTY      


		-------------















END

