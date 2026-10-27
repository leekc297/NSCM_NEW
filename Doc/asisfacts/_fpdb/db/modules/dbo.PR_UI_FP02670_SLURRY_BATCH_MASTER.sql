

/*
 * Program ID   : PR_UI_FP02670_SLURRY_BATCH_MASTER
 * Description  : Slurry Batch Master
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/06/14   CYS				Initial Release UI통합
 */

CREATE PROCEDURE [dbo].[PR_UI_FP02670_SLURRY_BATCH_MASTER]
  @p_sys_type			NVARCHAR(MAX),  
  @p_sys_flag			NVARCHAR(MAX),
  @p_sys_gubun			NVARCHAR(MAX),  
  @p_user_id			NVARCHAR(MAX),

  @p_division_id		NVARCHAR(MAX),
  @p_site_id			NVARCHAR(MAX),
  @p_plant_id			NVARCHAR(MAX),
  @p_factory_id			NVARCHAR(MAX),
  @p_operation_id		NVARCHAR(MAX),
  @p_item_id			NVARCHAR(MAX),
  @p_nick_name			NVARCHAR(MAX)
  
AS 
BEGIN
	
    SET NOCOUNT ON;

	DECLARE @v_proc_name	nvarchar(100) = 'PR_UI_FP02670_SLURRY_BATCH_MASTER';
	DECLARE @runstart		datetime;
	DECLARE @runend			datetime;
	DECLARE @v_dSql			nvarchar(MAX)='';
	
	BEGIN

		SET	@v_dSql = ''
		SELECT @v_dSql += N'	SELECT 	A3.COMPANY_ID,A3.DIVISION_ID,A3.SITE_ID,A3.PLANT_ID,A3.FACTORY_ID																				' + char(10)
		SELECT @v_dSql += N'		    ,A3.ITEM_ID,A3.OPERATION_ID                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'		  	,CASE WHEN A3.BATCH_RATIO_ID IS NULL THEN ''-'' ELSE CASE WHEN A3.ITEM_ID=A3.BATCH_RATIO_ID THEN ''-'' ELSE A3.BATCH_RATIO_ID END END AS RATIO_ID   ' + char(10)
		SELECT @v_dSql += N'		  	,C.BATCH_LOT_SIZE,CASE WHEN C.LOT_SIZE_UOM IS NULL THEN ''KG'' ELSE C.LOT_SIZE_UOM END AS LOT_SIZE_UOM                                            ' + char(10)
		SELECT @v_dSql += N'		  	,C.TAT,CASE WHEN C.TAT_UOM IS NULL THEN ''MINUTE'' ELSE C.TAT_UOM END AS TAT_UOM                                                                  ' + char(10)
		SELECT @v_dSql += N'		  	,CASE WHEN C.ACTIVE_FLAG IS NULL THEN ''Y'' ELSE C.ACTIVE_FLAG END AS ACTIVE_FLAG                                                                 ' + char(10)
		SELECT @v_dSql += N'		  	,C.UPDATE_ID,CONVERT(VARCHAR,C.UPDATE_TIME,112) AS UPDATE_TIME                                                                                  ' + char(10)
		SELECT @v_dSql += N'		  	,ISNULL(A3.NICK_NAME,''-'') AS NICK_NAME                                                                                                          ' + char(10)
		SELECT @v_dSql += N'		  	,C.GPLM_BATCH_LOT_SIZE, ''0'' AS _GPLMCHK                                                                                                         ' + char(10)
		SELECT @v_dSql += N'		  	,A3.PROD_VERSION_TYPE                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'		  	,(CASE WHEN R.FACTORY_ID IS NULL THEN ''N'' ELSE ''Y'' END) AS EDIT_YN                                                                              ' + char(10)
		SELECT @v_dSql += N'	FROM 	(                                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'				SELECT	A2.COMPANY_ID,A2.DIVISION_ID,A2.SITE_ID,A2.PLANT_ID,A2.FACTORY_ID                                                                   ' + char(10)
		SELECT @v_dSql += N'					    ,A2.ITEM_ID,A2.OPERATION_ID,A2.BATCH_RATIO_ID,A2.NICK_NAME                                                                          ' + char(10)
		SELECT @v_dSql += N'					    ,A2.PROD_VERSION_TYPE                                                                                                               ' + char(10)
		SELECT @v_dSql += N'				FROM 	(                                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'							SELECT DISTINCT A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID,A.FACTORY_ID                                                    ' + char(10)
		SELECT @v_dSql += N'							      ,A.ITEM_ID,A.OPERATION_ID,PD.BATCH_ID AS BATCH_RATIO_ID,I.NICK_NAME                                                       ' + char(10)
		SELECT @v_dSql += N'							      ,BB.PROD_VERSION_TYPE                                                                                                     ' + char(10)
		SELECT @v_dSql += N'							FROM 	SCM_ITEM_LINE_ASSIGN_M A WITH(NOLOCK)                                                                                   ' + char(10)
		SELECT @v_dSql += N'									LEFT OUTER JOIN SCM_BATCH_M PD WITH(NOLOCK)                                                                             ' + char(10)
		SELECT @v_dSql += N'									ON    A.COMPANY_ID      = PD.COMPANY_ID                                                                                 ' + char(10)
		SELECT @v_dSql += N'									AND   A.DIVISION_ID     = PD.DIVISION_ID                                                                                ' + char(10)
		SELECT @v_dSql += N'									AND   A.SITE_ID         = PD.SITE_ID                                                                                    ' + char(10)
		SELECT @v_dSql += N'									AND   A.PLANT_ID        = PD.PLANT_ID                                                                                   ' + char(10)
		SELECT @v_dSql += N'									AND   A.ITEM_ID         = PD.ITEM_ID                                                                                    ' + char(10)
		SELECT @v_dSql += N'									JOIN SCM_ITEM_M I WITH(NOLOCK)                                                                                          ' + char(10)
		SELECT @v_dSql += N'									ON    A.COMPANY_ID      = I.COMPANY_ID                                                                                  ' + char(10)
		SELECT @v_dSql += N'									AND   A.DIVISION_ID     = I.DIVISION_ID                                                                                 ' + char(10)
		SELECT @v_dSql += N'									AND   A.SITE_ID         = I.SITE_ID                                                                                     ' + char(10)
		SELECT @v_dSql += N'									AND   A.ITEM_ID         = I.ITEM_ID                                                                                     ' + char(10)
		SELECT @v_dSql += N'									AND   I.ACTIVE_FLAG     = ''Y''                                                                                           ' + char(10)
		SELECT @v_dSql += N'									JOIN SCM_ITEM_CLASS_M PDC WITH(NOLOCK)                                                                                  ' + char(10)
		SELECT @v_dSql += N'									ON    I.ITEM_CLASS      = PDC.CLASS_ID                                                                                  ' + char(10)
		SELECT @v_dSql += N'									AND   PDC.LEVEL_2_CODE  = ''ASL''                                                                                         ' + char(10)
		SELECT @v_dSql += N'									AND   PDC.USE_FLAG      = ''Y''                                                                                           ' + char(10)
		SELECT @v_dSql += N'									INNER JOIN SCM_LINE_M BB WITH(NOLOCK)                                                                                   ' + char(10)
		SELECT @v_dSql += N'									ON    A.COMPANY_ID      = BB.COMPANY_ID                                                                                 ' + char(10)
		SELECT @v_dSql += N'									AND   A.DIVISION_ID     = BB.DIVISION_ID                                                                                ' + char(10)
		SELECT @v_dSql += N'									AND   A.SITE_ID         = BB.SITE_ID                                                                                    ' + char(10)
		SELECT @v_dSql += N'									AND   A.PLANT_ID        = BB.PLANT_ID                                                                                   ' + char(10)
		SELECT @v_dSql += N'									AND   A.FACTORY_ID      = BB.FACTORY_ID                                                                                 ' + char(10)
		SELECT @v_dSql += N'									AND   A.OPERATION_ID    = BB.OPERATION_ID                                                                               ' + char(10)
		SELECT @v_dSql += N'									AND   A.LINE_ID         = BB.LINE_ID                                                                                    ' + char(10)
		SELECT @v_dSql += N'									AND   A.ELECTRODE_TYPE  = BB.ELECTRODE_TYPE                                                                             ' + char(10)
		SELECT @v_dSql += N'									AND   BB.ACTIVE_FLAG    = ''Y''                                                                                           ' + char(10)
		SELECT @v_dSql += N'									AND   BB.PROD_VERSION_TYPE IS NOT NULL                                                                                  ' + char(10)
		SELECT @v_dSql += N'							WHERE A.MONTH >= LEFT(CONVERT(VARCHAR,GETDATE(),112),8)                                                                         ' + char(10)
		SELECT @v_dSql += N'							AND   A.ACTIVE_FLAG = ''Y''                                                                                                       ' + char(10)
		SELECT @v_dSql += N'							AND   EXISTS (                                                                                                                  ' + char(10)
		SELECT @v_dSql += N'											SELECT 1                                                                                                        ' + char(10)
		SELECT @v_dSql += N'											FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)                                                                       ' + char(10)
		SELECT @v_dSql += N'											WHERE  A.COMPANY_ID   = B.COMPANY_ID                                                                            ' + char(10)
		SELECT @v_dSql += N'											AND    A.DIVISION_ID  = B.DIVISION_ID                                                                           ' + char(10)
		SELECT @v_dSql += N'											AND    A.SITE_ID      = B.SITE_ID                                                                               ' + char(10)
		SELECT @v_dSql += N'											AND    A.PLANT_ID     = B.PLANT_ID                                                                              ' + char(10)
		SELECT @v_dSql += N'											AND    A.FACTORY_ID   = B.FACTORY_ID                                                                            ' + char(10)
		SELECT @v_dSql += N'											AND    A.OPERATION_ID = B.OPERATION_ID                                                                          ' + char(10)
		SELECT @v_dSql += N'											AND    B.USER_ID      = '''+ @p_user_id +'''                                                                               ' + char(10)
		SELECT @v_dSql += N'										)                                                                                                                   ' + char(10)
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		SELECT @v_dSql += N'							AND   A.OPERATION_ID=''E0500''                                                                                                    ' + char(10)
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_item_id)) + char(10)
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('I.NICK_NAME' , 'LIKE', @p_nick_name)) + char(10)
		SELECT @v_dSql += N'		                                                                                                                                                    ' + char(10)
		SELECT @v_dSql += N'					) A2                                                                                                                                    ' + char(10)
		SELECT @v_dSql += N'			) A3                                                                                                                                            ' + char(10)
		SELECT @v_dSql += N'			LEFT OUTER JOIN SCM_ITEM_EQUIP_RATE_BATCH_M C WITH(NOLOCK)                                                                                      ' + char(10)
		SELECT @v_dSql += N'			ON    A3.COMPANY_ID   = C.COMPANY_ID                                                                                                            ' + char(10)
		SELECT @v_dSql += N'			AND   A3.DIVISION_ID  = C.DIVISION_ID                                                                                                           ' + char(10)
		SELECT @v_dSql += N'			AND   A3.SITE_ID      = C.SITE_ID                                                                                                               ' + char(10)
		SELECT @v_dSql += N'			AND   A3.PLANT_ID     = C.PLANT_ID                                                                                                              ' + char(10)
		SELECT @v_dSql += N'			AND   A3.FACTORY_ID   = C.FACTORY_ID                                                                                                            ' + char(10)
		SELECT @v_dSql += N'			AND   A3.OPERATION_ID = C.OPERATION_ID                                                                                                          ' + char(10)
		SELECT @v_dSql += N'			AND   A3.ITEM_ID      = C.ITEM_ID                                                                                                               ' + char(10)
		SELECT @v_dSql += N'			AND   A3.PROD_VERSION_TYPE = C.PROD_VERSION_TYPE                                                                                                ' + char(10)
		SELECT @v_dSql += N'			INNER JOIN SCM_OPERATION_M OP WITH(NOLOCK)                                                                                                      ' + char(10)
		SELECT @v_dSql += N'			ON    A3.COMPANY_ID   = OP.COMPANY_ID                                                                                                           ' + char(10)
		SELECT @v_dSql += N'			AND   A3.DIVISION_ID  = OP.DIVISION_ID                                                                                                          ' + char(10)
		SELECT @v_dSql += N'			AND   A3.SITE_ID      = OP.SITE_ID                                                                                                              ' + char(10)
		SELECT @v_dSql += N'			AND   A3.OPERATION_ID = OP.OPERATION_ID                                                                                                         ' + char(10)
		SELECT @v_dSql += N'			LEFT OUTER JOIN (                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'								SELECT DISTINCT R.COMPANY_ID, R.DIVISION_ID, R.SITE_ID, R.PLANT_ID, R.FACTORY_ID, R.OPERATION_ID                            ' + char(10)
		SELECT @v_dSql += N'								FROM   FP_USER_ROLE_INFO_V R WITH(NOLOCK)                                                                                   ' + char(10)
		SELECT @v_dSql += N'								WHERE  R.USER_ID   = '''+ @p_user_id +'''                                                                                              ' + char(10)
		SELECT @v_dSql += N'								AND    R.SAVE_FLAG = ''Y''                                                                                                    ' + char(10)
		SELECT @v_dSql += N'			) R                                                                                                                                             ' + char(10)
		SELECT @v_dSql += N'			ON   A3.COMPANY_ID   = R.COMPANY_ID                                                                                                             ' + char(10)
		SELECT @v_dSql += N'			AND  A3.DIVISION_ID  = R.DIVISION_ID                                                                                                            ' + char(10)
		SELECT @v_dSql += N'			AND  A3.SITE_ID      = R.SITE_ID                                                                                                                ' + char(10)
		SELECT @v_dSql += N'			AND  A3.PLANT_ID     = R.PLANT_ID                                                                                                               ' + char(10)
		SELECT @v_dSql += N'			AND  A3.FACTORY_ID   = R.FACTORY_ID                                                                                                             ' + char(10)
		SELECT @v_dSql += N'			AND  A3.OPERATION_ID = R.OPERATION_ID                                                                                                           ' + char(10)
		SELECT @v_dSql += N'	WHERE OP.CAPA_TYPE=''BATCH''                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'	ORDER BY A3.DIVISION_ID,A3.SITE_ID,A3.PLANT_ID,A3.FACTORY_ID,A3.OPERATION_ID,A3.ITEM_ID,A3.BATCH_RATIO_ID                                               ' + char(10)
			
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
		exec PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_sys_flag,'',@v_dSql,'SELECT',@runstart, @runend
    END
	
  
END

