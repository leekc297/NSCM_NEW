

/*
 * Program ID   : PR_UI_FP02320_PANCAKE_MASTER
 * Description  : Pancake Master
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021-03-25   CYS				Initial Release UI통합
 * 2022-04-11   KSI				pan&roll cake column add
 * 2023/04/18   KCH             SCM_STOCK_H -> SCM_STOCK_H_V 뷰로 변경
 */

CREATE PROCEDURE [dbo].[PR_UI_FP02320_PANCAKE_MASTER]
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
  @p_bucket_from		NVARCHAR(MAX),
  @p_bucket_to			NVARCHAR(MAX),
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

		SET @v_dSql += '   select Main.COMPANY_ID,Main.DIVISION_ID,Main.SITE_ID,Main.PLANT_ID,Main.FACTORY_ID,Main.ITEM_ID   ' + char(10)
		SET @v_dSql += '		,ISNULL(PD.NICK_NAME, ''-'') AS NICK_NAME 																			 ' + char(10)
		SET @v_dSql += '		,Main.LANE_QTY, Main.SLIT_WIDTH , Main.MAIN_LANE_QTY, Main.SUB_LANE_QTY	,Main.PATTERN_QTY, Main.HALF_SLIT_FLAG		 ' + char(10)
		SET @v_dSql += '		,Main.DESCRIPTION,Main.ACTIVE_FLAG                                                                                   ' + char(10)                             
		SET @v_dSql += '		,Main.PROD_VERSION_TYPE  																							 ' + char(10)
		SET @v_dSql += '		,CASE WHEN PD.ITEM_NAME IS NULL THEN ''Invalid Item Id : '' + Main.ITEM_ID ELSE PD.ITEM_NAME END AS ITEM_NAME  		 ' + char(10)
		SET @v_dSql += '		,CASE WHEN Main.PATTERN_QTY IS NULL OR Main.PATTERN_QTY = 0 THEN Main.LANE_QTY                                       ' + char(10)                                             
		SET @v_dSql += '		ELSE Main.PATTERN_QTY * Main.LANE_QTY END LANE   																	 ' + char(10)
		SET @v_dSql += '		,PD.COATED_LENGTH	,PD.UNCOATED_LENGTH, ISNULL(PD.LENGTH_UOM,''mm'') AS LENGTH_UOM   								 ' + char(10)
		SET @v_dSql += '		,Main.PC_ROLL_LENGTH_UOM                                                                                             ' + char(10)                     
		SET @v_dSql += '		,Main.PROD_VERSION_TYPE AS PROD_VERSION_TYPE_ORG 																	 ' + char(10)
		SET @v_dSql += '		,Main.PROD_EDIT																										 ' + char(10)
		SET @v_dSql += '		,(CASE WHEN R.FACTORY_ID IS NULL OR Main.UPDATE_ID = ''PR_XIF_PLM_CONVERSION_RATE_R'' THEN ''N'' ELSE ''Y'' END) EDIT_YN   ' + char(10)  
		SET @v_dSql += '		,Main.GPLM_JUMBO_ROLL_LENGTH  											   ' + char(10)
		SET @v_dSql += '		,Main.GPLM_PC_ROLL_LENGTH, Main.JUMBO_ROLL_LENGTH, Main.PC_ROLL_LENGTH 	   ' + char(10)
		SET @v_dSql += '		,Main.ROLLCAKE 															   ' + char(10)
		SET @v_dSql += '		,Main.PANCAKE 															   ' + char(10)
		SET @v_dSql += '		,Main.UPDATE_ID, CONVERT(VARCHAR,Main.UPDATE_TIME,20) AS UPDATE_TIME 	   ' + char(10)
		SET @v_dSql += '  from (	   ' + char(10)




		SET @v_dSql += '			SELECT 	Temp.COMPANY_ID,Temp.DIVISION_ID,Temp.SITE_ID,Temp.PLANT_ID,Temp.FACTORY_ID,Temp.ITEM_ID																					' + char(10)
		
		SET @v_dSql += '		    ,Temp.LANE_QTY, Temp.SLIT_WIDTH , Temp.MAIN_LANE_QTY, Temp.SUB_LANE_QTY	,Temp.PATTERN_QTY, Temp.HALF_SLIT_FLAG                                                                               ' + char(10)
		SET @v_dSql += '		    ,Temp.DESCRIPTION,Temp.ACTIVE_FLAG                                                                                                               ' + char(10)
		SET @v_dSql += '		    ,Temp.PROD_VERSION_TYPE                                                                                                                                    ' + char(10)
		
		SET @v_dSql += '		    ,CASE WHEN Temp.PATTERN_QTY IS NULL OR Temp.PATTERN_QTY = 0 THEN Temp.LANE_QTY                                                                                   ' + char(10)
		SET @v_dSql += '		          ELSE Temp.PATTERN_QTY * Temp.LANE_QTY END LANE                                                                                                          ' + char(10)
		
		SET @v_dSql += '		    , Temp.PC_ROLL_LENGTH_UOM                                                                                                                 ' + char(10)
		
		SET @v_dSql += '		    ,Temp.PROD_VERSION_TYPE AS PROD_VERSION_TYPE_ORG                                                                                                           ' + char(10)
		SET @v_dSql += '		    , CASE WHEN COUNT(PROD_VERSION_TYPE) OVER ( PARTITION BY Temp.COMPANY_ID,Temp.DIVISION_ID,Temp.SITE_ID,Temp.PLANT_ID,Temp.FACTORY_ID,Temp.ITEM_ID,Temp.LANE_QTY              ' + char(10)
		SET @v_dSql += '		    											 ORDER BY Temp.COMPANY_ID,Temp.DIVISION_ID,Temp.SITE_ID,Temp.PLANT_ID,Temp.FACTORY_ID,Temp.ITEM_ID,Temp.LANE_QTY                 ' + char(10)
		SET @v_dSql += '		    											) <  2 AND Temp.FACTORY_ID = ''E7''  THEN ''Y'' ELSE ''N'' END AS PROD_EDIT                                     ' + char(10)
		SET @v_dSql += '		    -- 작업의뢰서 등록 품번은 입력불가능								                                                                                    ' + char(10)
		
		SET @v_dSql += '			,Temp.GPLM_JUMBO_ROLL_LENGTH  ' + char(10)
		SET @v_dSql += '			, Temp.GPLM_PC_ROLL_LENGTH, Temp.JUMBO_ROLL_LENGTH, Temp.PC_ROLL_LENGTH ' + char(10)
		SET @v_dSql += '			,compl.ROLLCAKE ' + char(10)
		SET @v_dSql += '			,compl.PANCAKE ' + char(10)
		SET @v_dSql += '		    , Temp.UPDATE_ID, CONVERT(VARCHAR,Temp.UPDATE_TIME,20) AS UPDATE_TIME                                                                                   ' + char(10)
		


		SET @v_dSql += '			FROM  ( 	SELECT 	*  FROM SCM_ITEM_LANE_M A WITH(NOLOCK) 	    ' + char(10)
		SET @v_dSql += '			where  	1=1 													' + char(10)

		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('DIVISION_ID' , 'EQ', @p_division_id)) + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('SITE_ID' , 'EQ', @p_site_id)) + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('PLANT_ID' , 'EQ', @p_plant_id)) + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('FACTORY_ID' , 'EQ', @p_factory_id)) + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('ITEM_ID' , 'LIKE', @p_item_id)) + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('ACTIVE_FLAG' , 'EQ', @p_active_flag)) + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('PROD_VERSION_TYPE' , 'EQ', @p_bucket_to)) + char(10);

		SET @v_dSql += '			) as Temp     ' + char(10)



		SET @v_dSql += '			LEFT JOIN 			 ' + char(10)
		SET @v_dSql += '			(    ' + char(10)
		SET @v_dSql += '				select uni_all.COMPANY_ID, uni_all.DIVISION_ID, uni_all.SITE_ID,	uni_all.PLANT_ID, uni_all.FACTORY_ID, uni_all.ITEM_ID,	MAX(uni_all.PANCAKE) as PANCAKE, MAX(uni_all.ROLLCAKE) as 	ROLLCAKE  from (   ' + char(10)
		SET @v_dSql += '				select S_Pan.COMPANY_ID, S_Pan.DIVISION_ID, S_Pan.SITE_ID, S_Pan.PLANT_ID, S_Pan.FACTORY_ID, S_Pan.ITEM_ID, S_Pan.QTY,  S_Pan.LOT_COUNT,   ' + char(10)
		SET @v_dSql += '				(FORMAT(S_Pan.QTY / S_Pan.LOT_COUNT  , ''##0.###'')) as PANCAKE, null as ROLLCAKE ' + char(10)
		SET @v_dSql += '				from  ' + char(10)
		SET @v_dSql += '				( ' + char(10)
		SET @v_dSql += '					 select MAX(COMPANY_ID) as COMPANY_ID, MAX(DIVISION_ID) as DIVISION_ID, MAX(SITE_ID) as SITE_ID, ' + char(10)
		SET @v_dSql += '					 MAX(PLANT_ID) as PLANT_ID, MAX(FACTORY_ID) as FACTORY_ID, MAX(ITEM_ID) as ITEM_ID, ' + char(10)
		SET @v_dSql += '					 FORMAT(SUM(QTY), ''##0.###'') as QTY, SUM(LOT_COUNT)as LOT_COUNT, MAX(OPERATION_ID) as OPERATION_ID   ' + char(10)
		SET @v_dSql += '					 from SCM_STOCK_H_V  ' + char(10)

		SET @v_dSql += '					 where CUTOFF_DATE = ''' + @p_bucket_from + '''' + char(10)	

		SET @v_dSql += '					 AND FP_APPLY_OPERATION_ID  = ''E4000''  ' + char(10)
		SET @v_dSql += '					 AND QTY IS NOT NULL ' + char(10)
		SET @v_dSql += '					 AND LOT_COUNT IS NOT NULL ' + char(10)
		SET @v_dSql += '					 group by COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ITEM_ID  ' + char(10)
		SET @v_dSql += '				 ) as S_Pan where S_Pan.QTY IS NOT NULL AND S_Pan.LOT_COUNT IS NOT NULL       ' + char(10)
		
		SET @v_dSql += '				UNION ALL ' + char(10)     

		
		SET @v_dSql += '				select S_ROLL.COMPANY_ID, S_ROLL.DIVISION_ID, S_ROLL.SITE_ID, S_ROLL.PLANT_ID, S_ROLL.FACTORY_ID, S_ROLL.ITEM_ID, S_ROLL.QTY,  S_ROLL.LOT_COUNT,   ' + char(10)
		SET @v_dSql += '				null as PANCAKE, (FORMAT(S_ROLL.QTY / S_ROLL.LOT_COUNT  , ''##0.###'')) as ROLLCAKE	 '+ char(10)
		SET @v_dSql += '				from '+ char(10)
		SET @v_dSql += '				( '+ char(10)
		SET @v_dSql += '					 select MAX(COMPANY_ID) as COMPANY_ID, MAX(DIVISION_ID) as DIVISION_ID, MAX(SITE_ID) as SITE_ID, '+ char(10)
		SET @v_dSql += '					 MAX(PLANT_ID) as PLANT_ID, MAX(FACTORY_ID) as FACTORY_ID, MAX(ITEM_ID) as ITEM_ID, '+ char(10)
		SET @v_dSql += '					 FORMAT(SUM(QTY), ''##0.###'') as QTY, SUM(LOT_COUNT)as LOT_COUNT, MAX(OPERATION_ID) as OPERATION_ID  '+ char(10)
		SET @v_dSql += '					 from SCM_STOCK_H_V '+ char(10)
		
		SET @v_dSql += '							 where CUTOFF_DATE = ''' + @p_bucket_from + '''' + char(10)	

		SET @v_dSql += '					 AND FP_APPLY_OPERATION_ID  <  ''E4000'' '+ char(10)
		SET @v_dSql += '					 group by COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ITEM_ID '+ char(10)
		SET @v_dSql += '					) as S_ROLL where S_ROLL.QTY IS NOT NULL AND S_ROLL.LOT_COUNT IS NOT NULL '+ char(10)
		
		SET @v_dSql += '				) as uni_all    group by COMPANY_ID,	DIVISION_ID,	SITE_ID,	PLANT_ID,	FACTORY_ID,	ITEM_ID '+ char(10)
		SET @v_dSql += '			)    ' + char(10)
		
		SET @v_dSql += '			as compl ON 1=1                                                                                                                 ' + char(10)     
		
		SET @v_dSql += '			AND  Temp.COMPANY_ID   = compl.COMPANY_ID 	' + char(10)     
		SET @v_dSql += '			AND  Temp.DIVISION_ID  = compl.DIVISION_ID    ' + char(10)     
		
		SET @v_dSql += '			AND  Temp.SITE_ID      = compl.SITE_ID  ' + char(10)     
		
		SET @v_dSql += '			AND  Temp.PLANT_ID     = compl.PLANT_ID     ' + char(10)
		
		SET @v_dSql += '			AND  Temp.FACTORY_ID     = compl.FACTORY_ID     ' + char(10)
		
		SET @v_dSql += '			AND  Temp.ITEM_ID     = compl.ITEM_ID     ' + char(10)				

		SET @v_dSql += '	) as Main  ' + char(10)
		
		
		SET @v_dSql += '	LEFT OUTER HASH JOIN (                                                                                                                                  ' + char(10)
		SET @v_dSql += '								   SELECT DISTINCT R.COMPANY_ID, R.DIVISION_ID, R.SITE_ID, R.PLANT_ID, R.FACTORY_ID                                                 ' + char(10)
		SET @v_dSql += '								   FROM   FP_USER_ROLE_INFO_V R WITH(NOLOCK)                                                                                        ' + char(10)
		SET @v_dSql += '								   WHERE  R.USER_ID   = '''+ @p_user_id + '''                                                                                                   ' + char(10)
		SET @v_dSql += '								   AND    R.SAVE_FLAG = ''Y''                                                                                                       ' + char(10)
		SET @v_dSql += '		) R                                                                                                                                                     ' + char(10)
		SET @v_dSql += '		ON   Main.COMPANY_ID   = R.COMPANY_ID                                                                                                                      ' + char(10)
		SET @v_dSql += '		AND  Main.DIVISION_ID  = R.DIVISION_ID                                                                                                                     ' + char(10)
		SET @v_dSql += '		AND  Main.SITE_ID      = R.SITE_ID                                                                                                                         ' + char(10)
		SET @v_dSql += '		AND  Main.PLANT_ID     = R.PLANT_ID                                                                                                                        ' + char(10)
		SET @v_dSql += '		AND  Main.FACTORY_ID   = R.FACTORY_ID                                                                                                                      ' + char(10)
		
		SET @v_dSql += '		LEFT JOIN SCM_ITEM_M PD WITH(NOLOCK)                                                                                                                    ' + char(10)
		SET @v_dSql += '		ON  Main.COMPANY_ID=PD.COMPANY_ID                                                                                                                          ' + char(10)
		SET @v_dSql += '		AND Main.DIVISION_ID=PD.DIVISION_ID                                                                                                                        ' + char(10)
		SET @v_dSql += '		AND Main.SITE_ID=PD.SITE_ID                                                                                                                                ' + char(10)
		SET @v_dSql += '		AND Main.ITEM_ID=PD.ITEM_ID                                                                                                                                ' + char(10)
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('PD.NICK_NAME' , 'LIKE', @p_nick_name)) + char(10);
	
		SET @v_dSql += '	WHERE 1=1                                                                                                                                                       ' + char(10)
		SET @v_dSql += '	AND   PD.ACTIVE_FLAG = ''Y''                                                                                                                                    ' + char(10)
		SET @v_dSql += '	AND    EXISTS (                                                                                                                                                 ' + char(10)
		SET @v_dSql += '				    SELECT 1                                                                                                                                        ' + char(10)
		SET @v_dSql += '				    FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)                                                                                                       ' + char(10)
		SET @v_dSql += '				    WHERE  Main.COMPANY_ID  = B.COMPANY_ID                                                                                                             ' + char(10)
		SET @v_dSql += '				    AND    Main.DIVISION_ID = B.DIVISION_ID                                                                                                            ' + char(10)
		SET @v_dSql += '				    AND    Main.SITE_ID     = B.SITE_ID                                                                                                                ' + char(10)
		SET @v_dSql += '				    AND    Main.PLANT_ID    = B.PLANT_ID                                                                                                               ' + char(10)
		SET @v_dSql += '				    AND    Main.FACTORY_ID  = B.FACTORY_ID                                                                                                             ' + char(10)
		SET @v_dSql += '				    AND    B.USER_ID     = '''+ @p_user_id + '''                                                                                                                ' + char(10)
		SET @v_dSql += '				)                                                                                                                                                   ' + char(10)
		--SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('Main.DIVISION_ID' , 'EQ', @p_division_id)) + char(10);
		--SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('Main.SITE_ID' , 'EQ', @p_site_id)) + char(10);
		--SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('Main.PLANT_ID' , 'EQ', @p_plant_id)) + char(10);
		--SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('Main.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10);
		--SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('Main.ITEM_ID' , 'LIKE', @p_item_id)) + char(10);
		--SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('PD.NICK_NAME' , 'LIKE', @p_nick_name)) + char(10);
		--SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('Main.ACTIVE_FLAG' , 'EQ', @p_active_flag)) + char(10);
		--SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('Main.PROD_VERSION_TYPE' , 'EQ', @p_bucket_to)) + char(10);
		SET @v_dSql += '	ORDER BY Main.DIVISION_ID, Main.SITE_ID, Main.PLANT_ID, Main.FACTORY_ID, Main.ITEM_ID, PROD_VERSION_TYPE, Main.LANE_QTY                                                                              ' + char(10)
	
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


END

