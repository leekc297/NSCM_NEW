

/*
 * Program ID   : PR_UI_FP00210_BOM
 * Description  : BOM
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/02/23   CYS				Initial Release UI통합
 */

CREATE PROCEDURE [dbo].[PR_UI_FP00210_BOM]
  @p_sys_type			NVARCHAR(MAX),  
  @p_sys_flag			NVARCHAR(MAX),
  @p_sys_gubun			NVARCHAR(MAX),  
  @p_user_id			NVARCHAR(MAX),

  @p_company_id			NVARCHAR(MAX),
  @p_division_id		NVARCHAR(MAX),
  @p_site_id			NVARCHAR(MAX),
  @p_plant_id			NVARCHAR(MAX),
  @p_item_id			NVARCHAR(MAX),
  @p_nick_name			NVARCHAR(MAX),
  @p_child_item_id		NVARCHAR(MAX),
  @p_child_nick_name	NVARCHAR(MAX)

AS 
BEGIN
	
    SET NOCOUNT ON;

	DECLARE @v_proc_name	nvarchar(100) = 'PR_UI_FP00210_BOM';
	DECLARE @runstart		datetime;
	DECLARE @runend			datetime;
	DECLARE @v_dSql			nvarchar(MAX)='';
	
	BEGIN
		
		SET	@v_dSql = ''

		IF @p_sys_flag = 'MAIN'
			BEGIN
				
				SET @v_dSql += '	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, 																		' + char(10)
				SET @v_dSql += '	     A.PARENT_ITEM_ID, A.CHILD_ITEM_ID, A.BOM_VERSION_ID, A.KEY_DATE,                                                           ' + char(10)
				SET @v_dSql += '	     A.BOM_VERSION_LINE AS BOM_VERSION_TYPE, A.PARENT_QTY, A.PARENT_UOM, A.CHILD_QTY, A.CHILD_UOM,                              ' + char(10)
				SET @v_dSql += '	     A.ALT_ID, A.ALT_PRIORITY, A.ALT_RATE, A.ECO_CODE,                                                                          ' + char(10)
				SET @v_dSql += '	     CONVERT(VARCHAR, A.EFF_START_DATE, 112) EFF_START_DATE,                                                                    ' + char(10)
				SET @v_dSql += '	     CONVERT(VARCHAR, A.EFF_END_DATE, 112) EFF_END_DATE,                                                                        ' + char(10)
				SET @v_dSql += '	     A.ACTIVE_FLAG, A.INSERT_ID, A.INSERT_TIME, A.UPDATE_ID, A.UPDATE_TIME, A.STANDARD_FLAG,                                    ' + char(10)
				SET @v_dSql += '	     B.ITEM_NAME AS PARENT_ITEM_NAME,                                                                                           ' + char(10)
				SET @v_dSql += '	     B2.ITEM_NAME AS CHILD_ITEM_NAME,                                                                                           ' + char(10)
				SET @v_dSql += '	     ISNULL(B.NICK_NAME,''-'') AS PARENT_NICK_NAME, ISNULL(B2.NICK_NAME,''-'') AS CHILD_NICK_NAME                               ' + char(10)
				SET @v_dSql += '	FROM   SCM_BOM_M A WITH(NOLOCK), SCM_ITEM_M B WITH(NOLOCK), SCM_ITEM_M B2 WITH(NOLOCK), SCM_ITEM_CLASS_M IC WITH(NOLOCK)        ' + char(10)
				SET @v_dSql += '	WHERE A.COMPANY_ID     = B.COMPANY_ID                                                                                           ' + char(10)
				SET @v_dSql += '	AND   A.DIVISION_ID    = B.DIVISION_ID                                                                                          ' + char(10)
				SET @v_dSql += '	AND   A.SITE_ID        = B.SITE_ID                                                                                              ' + char(10)
				SET @v_dSql += '	AND   A.PARENT_ITEM_ID = B.ITEM_ID                                                                                              ' + char(10)
				SET @v_dSql += '	AND   A.COMPANY_ID     = B2.COMPANY_ID                                                                                          ' + char(10)
				SET @v_dSql += '	AND   A.DIVISION_ID    = B2.DIVISION_ID                                                                                         ' + char(10)
				SET @v_dSql += '	AND   A.SITE_ID        = B2.SITE_ID                                                                                             ' + char(10)
				SET @v_dSql += '	AND   A.CHILD_ITEM_ID  = B2.ITEM_ID                                                                                             ' + char(10)
				SET @v_dSql += '	AND   B2.ITEM_CLASS    = IC.CLASS_ID                                                                                            ' + char(10)
				SET @v_dSql += '	AND   IC.USE_FLAG      = ''Y''                                                                                                  ' + char(10)
				SET @v_dSql += '	AND   A.STANDARD_FLAG  = ''Y''                                                                                                  ' + char(10)
				SET @v_dSql += '	AND   A.ACTIVE_FLAG    = ''Y''                                                                                                  ' + char(10)
				SET @v_dSql += '	AND   B.ACTIVE_FLAG    = ''Y''                                                                                                  ' + char(10)
				SET @v_dSql += '	AND   B2.ACTIVE_FLAG   = ''Y''                                                                                                  ' + char(10)
				SET @v_dSql += '	--AND   CONVERT(VARCHAR, A.EFF_START_DATE, 112) <= CONVERT(VARCHAR, dbo.SYSDATE1(), 112)                                        ' + char(10)
				SET @v_dSql += '	AND   CONVERT(VARCHAR, A.EFF_END_DATE, 112) > CONVERT(VARCHAR, dbo.SYSDATE1(), 112)                                             ' + char(10)
				SET @v_dSql += '	AND   EXISTS (                                                                                                                  ' + char(10)
				SET @v_dSql += '	    SELECT 1                                                                                                                    ' + char(10)
				SET @v_dSql += '	    FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)                                                                                   ' + char(10)
				SET @v_dSql += '	    WHERE  A.COMPANY_ID  = B.COMPANY_ID                                                                                         ' + char(10)
				SET @v_dSql += '	    AND    A.DIVISION_ID = B.DIVISION_ID                                                                                        ' + char(10)
				SET @v_dSql += '	    AND    A.SITE_ID     = B.SITE_ID                                                                                            ' + char(10)
				SET @v_dSql += '	    AND    A.PLANT_ID    = B.PLANT_ID                                                                                           ' + char(10)
				SET @v_dSql += '	    AND    B.USER_ID     = '''+ @p_user_id +'''                                                                                 ' + char(10)
				SET @v_dSql += '	)                                                                                                                               ' + char(10)
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PARENT_ITEM_ID' , 'LIKE', @p_item_id)) + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.CHILD_ITEM_ID' , 'LIKE', @p_child_item_id)) + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.NICK_NAME' , 'LIKE', @p_nick_name)) + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B2.NICK_NAME' , 'LIKE', @p_child_nick_name)) + char(10);
				SET @v_dSql += '	ORDER BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.PARENT_ITEM_ID, A.CHILD_ITEM_ID, A.BOM_VERSION_ID, A.KEY_DATE    ' + char(10)

			END
		ELSE IF @p_sys_flag = 'SUB'
			BEGIN
				
				SET @v_dSql += '	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID,												' + char(10)
				SET @v_dSql += '	     A.PARENT_ITEM_ID, A.CHILD_ITEM_ID, A.BOM_VERSION_ID, A.KEY_DATE,                                   ' + char(10)
				SET @v_dSql += '	     A.BOM_VERSION_LINE AS BOM_VERSION_TYPE, A.PARENT_QTY, A.PARENT_UOM, A.CHILD_QTY, A.CHILD_UOM,      ' + char(10)
				SET @v_dSql += '	     A.ALT_ID, A.ALT_PRIORITY, A.ALT_RATE, A.ECO_CODE,                                                  ' + char(10)
				SET @v_dSql += '	     CONVERT(VARCHAR, A.EFF_START_DATE, 112) EFF_START_DATE,                                            ' + char(10)
				SET @v_dSql += '	     CONVERT(VARCHAR, A.EFF_END_DATE, 112) EFF_END_DATE,                                                ' + char(10)
				SET @v_dSql += '	     A.ACTIVE_FLAG, A.INSERT_ID, A.INSERT_TIME, A.UPDATE_ID, A.UPDATE_TIME, A.STANDARD_FLAG,            ' + char(10)
				SET @v_dSql += '	     B.ITEM_NAME AS PARENT_ITEM_NAME,                                                                   ' + char(10)
				SET @v_dSql += '	     B2.ITEM_NAME AS CHILD_ITEM_NAME,                                                                   ' + char(10)
				SET @v_dSql += '	     ISNULL(B.NICK_NAME,''-'') AS PARENT_NICK_NAME, ISNULL(B2.NICK_NAME,''-'') AS CHILD_NICK_NAME       ' + char(10)
				SET @v_dSql += '	FROM  SCM_BOM_M A WITH(NOLOCK)                                                                          ' + char(10)
				SET @v_dSql += '		, SCM_ITEM_M B WITH(NOLOCK)                                                                         ' + char(10)
				SET @v_dSql += '		, SCM_ITEM_M B2 WITH(NOLOCK)                                                                        ' + char(10)
				SET @v_dSql += '		, SCM_ITEM_CLASS_M IC WITH(NOLOCK)                                                                  ' + char(10)
				SET @v_dSql += '	WHERE A.COMPANY_ID     = B.COMPANY_ID                                                                   ' + char(10)
				SET @v_dSql += '	AND   A.DIVISION_ID    = B.DIVISION_ID                                                                  ' + char(10)
				SET @v_dSql += '	AND   A.SITE_ID        = B.SITE_ID                                                                      ' + char(10)
				SET @v_dSql += '	AND   A.PARENT_ITEM_ID = B.ITEM_ID                                                                      ' + char(10)
				SET @v_dSql += '	AND   A.COMPANY_ID     = B2.COMPANY_ID                                                                  ' + char(10)
				SET @v_dSql += '	AND   A.DIVISION_ID    = B2.DIVISION_ID                                                                 ' + char(10)
				SET @v_dSql += '	AND   A.SITE_ID        = B2.SITE_ID                                                                     ' + char(10)
				SET @v_dSql += '	AND   A.CHILD_ITEM_ID  = B2.ITEM_ID                                                                     ' + char(10)
				SET @v_dSql += '	AND   B2.ITEM_CLASS    = IC.CLASS_ID                                                                    ' + char(10)
				SET @v_dSql += '	AND   IC.USE_FLAG      = ''Y''                                                                          ' + char(10)
				SET @v_dSql += '	AND   A.ACTIVE_FLAG    = ''Y''                                                                          ' + char(10)
				SET @v_dSql += '	AND   B.ACTIVE_FLAG    = ''Y''                                                                          ' + char(10)
				SET @v_dSql += '	AND   B2.ACTIVE_FLAG   = ''Y''                                                                          ' + char(10)
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.COMPANY_ID' , 'EQ', @p_company_id)) + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PARENT_ITEM_ID' , 'EQ', @p_item_id)) + char(10);
				SET @v_dSql += '	AND   CONVERT(VARCHAR, A.EFF_START_DATE, 112) <= CONVERT(VARCHAR, dbo.SYSDATE1(), 112)                  ' + char(10)
				SET @v_dSql += '	AND   CONVERT(VARCHAR, A.EFF_END_DATE, 112) > CONVERT(VARCHAR, dbo.SYSDATE1(), 112)                     ' + char(10)
				SET @v_dSql += '	ORDER BY A.PARENT_ITEM_ID, A.BOM_VERSION_ID, A.STANDARD_FLAG DESC                                       ' + char(10)

			END
		ELSE IF @p_sys_flag = 'SUB_ALL'
			BEGIN
				
				SET @v_dSql += '	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, 												' + char(10)
				SET @v_dSql += '	     A.PARENT_ITEM_ID, A.CHILD_ITEM_ID, A.BOM_VERSION_ID, A.KEY_DATE,                                   ' + char(10)
				SET @v_dSql += '	     A.BOM_VERSION_LINE AS BOM_VERSION_TYPE, A.PARENT_QTY, A.PARENT_UOM, A.CHILD_QTY, A.CHILD_UOM,      ' + char(10)
				SET @v_dSql += '	     A.ALT_ID, A.ALT_PRIORITY, A.ALT_RATE, A.ECO_CODE,                                                  ' + char(10)
				SET @v_dSql += '	     CONVERT(VARCHAR, A.EFF_START_DATE, 112) EFF_START_DATE,                                            ' + char(10)
				SET @v_dSql += '	     CONVERT(VARCHAR, A.EFF_END_DATE, 112) EFF_END_DATE,                                                ' + char(10)
				SET @v_dSql += '	     A.ACTIVE_FLAG, A.INSERT_ID, A.INSERT_TIME, A.UPDATE_ID, A.UPDATE_TIME, A.STANDARD_FLAG,            ' + char(10)
				SET @v_dSql += '	     B.ITEM_NAME AS PARENT_ITEM_NAME,                                                                   ' + char(10)
				SET @v_dSql += '	     B2.ITEM_NAME AS CHILD_ITEM_NAME,                                                                   ' + char(10)
				SET @v_dSql += '	     ISNULL(B.NICK_NAME,''-'') AS PARENT_NICK_NAME, ISNULL(B2.NICK_NAME,''-'') AS CHILD_NICK_NAME       ' + char(10)
				SET @v_dSql += '	FROM  SCM_BOM_M A WITH(NOLOCK)                                                                          ' + char(10)
				SET @v_dSql += '		, SCM_ITEM_M B WITH(NOLOCK)                                                                         ' + char(10)
				SET @v_dSql += '		, SCM_ITEM_M B2 WITH(NOLOCK)                                                                        ' + char(10)
				SET @v_dSql += '		, SCM_ITEM_CLASS_M IC WITH(NOLOCK)                                                                  ' + char(10)
				SET @v_dSql += '	WHERE A.COMPANY_ID = B.COMPANY_ID                                                                       ' + char(10)
				SET @v_dSql += '	AND   A.DIVISION_ID = B.DIVISION_ID                                                                     ' + char(10)
				SET @v_dSql += '	AND   A.SITE_ID = B.SITE_ID                                                                             ' + char(10)
				SET @v_dSql += '	AND   A.PARENT_ITEM_ID = B.ITEM_ID                                                                      ' + char(10)
				SET @v_dSql += '	AND   A.COMPANY_ID = B2.COMPANY_ID                                                                      ' + char(10)
				SET @v_dSql += '	AND   A.DIVISION_ID = B2.DIVISION_ID                                                                    ' + char(10)
				SET @v_dSql += '	AND   A.SITE_ID = B2.SITE_ID                                                                            ' + char(10)
				SET @v_dSql += '	AND   A.CHILD_ITEM_ID = B2.ITEM_ID                                                                      ' + char(10)
				SET @v_dSql += '	and   b2.item_class = ic.class_id                                                                       ' + char(10)
				SET @v_dSql += '	and   ic.use_flag = ''Y''                                                                               ' + char(10)
				SET @v_dSql += '	AND   A.ACTIVE_FLAG = ''Y''                                                                             ' + char(10)
				SET @v_dSql += '	AND   B.ACTIVE_FLAG = ''Y''                                                                             ' + char(10)
				SET @v_dSql += '	AND   B2.ACTIVE_FLAG = ''Y''                                                                            ' + char(10)
				SET @v_dSql += '	AND   A.STANDARD_FLAG = ''Y''                                                                           ' + char(10)
				SET @v_dSql += '	AND   CONVERT(VARCHAR, A.EFF_START_DATE, 112) <= CONVERT(VARCHAR, dbo.SYSDATE1(), 112)                  ' + char(10)
				SET @v_dSql += '	AND   CONVERT(VARCHAR, A.EFF_END_DATE, 112) > CONVERT(VARCHAR, dbo.SYSDATE1(), 112)                     ' + char(10)
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PARENT_ITEM_ID' , 'LIKE', @p_item_id)) + char(10)
				SET @v_dSql += '	ORDER BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                                             ' + char(10)
				SET @v_dSql += '			, A.PARENT_ITEM_ID, A.CHILD_ITEM_ID, A.BOM_VERSION_ID, A.KEY_DATE                               ' + char(10)

			END
		ELSE IF @p_sys_flag = 'BOM_VIEW'
			BEGIN

				SET @v_dSql += '	SELECT 	AA.DIVISION_ID, AA.SITE_ID, AA.MODEL_ID AS MODEL_ID, P.NICK_NAME     					' + char(10)
				SET @v_dSql += '	    	, AA.PARENT_ITEM_ID                                                                     ' + char(10)
				SET @v_dSql += '	    	, (                                                                                     ' + char(10)
				SET @v_dSql += '	    		SELECT TOP 1 AP.ITEM_CLASS_NAME                                                     ' + char(10)
				SET @v_dSql += '	    		FROM SCM_ITEM_M AP WITH(NOLOCK)                                                     ' + char(10)
				SET @v_dSql += '	    		WHERE AP.ITEM_ID = AA.PARENT_ITEM_ID                                                ' + char(10)
				SET @v_dSql += '	    	  ) AS CATEGORY_NAME                                                                    ' + char(10)
				SET @v_dSql += '	    	, AA.CHILD_ITEM_ID, C.SPEC AS DESCRIPTION, C.ITEM_NAME AS SPEC                          ' + char(10)
				SET @v_dSql += '	    	, AA.ACCUMULATED_CHILD_QTY AS QTY, C.ITEM_UOM, C.ACTIVE_FLAG                            ' + char(10)
				SET @v_dSql += '	    	, CONVERT(DATE,GETDATE()) AS DATE                                                       ' + char(10)
				SET @v_dSql += '	FROM   ( 	                                                                                    ' + char(10)
				SET @v_dSql += '				SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, MODEL_ID                         ' + char(10)
				SET @v_dSql += '						, MAX( CASE WHEN PARENT_ITEM_ID = ''*'' THEN MODEL_ID                       ' + char(10)
				SET @v_dSql += '															  ELSE PARENT_ITEM_ID                   ' + char(10)
				SET @v_dSql += '							   END ) AS PARENT_ITEM_ID                                              ' + char(10)
				SET @v_dSql += '						, CHILD_ITEM_ID                                                             ' + char(10)
				SET @v_dSql += '						, SUM(ACCUMULATED_CHILD_QTY) AS ACCUMULATED_CHILD_QTY						' + char(10)		
				SET @v_dSql += '				        , MAX(CHILD_DIVISION_ID) AS CHILD_DIVISION_ID                               ' + char(10)
				SET @v_dSql += '				        , MAX(CHILD_SITE_ID) AS CHILD_SITE_ID                                       ' + char(10)
				SET @v_dSql += '				        , MAX(CHILD_COMPANY_ID)  AS CHILD_COMPANY_ID					            ' + char(10)
				SET @v_dSql += '		  		 FROM   SCM_MODEL_COMP_TEMP A  WITH(NOLOCK)                                         ' + char(10)
				SET @v_dSql += '		  		 WHERE  ALT_PRIORITY = ''Y''                                                        ' + char(10)
				--SET @v_dSql += '	AND     a.CHILD_ITEM_ID         like ''AJRJR0%''                                                            ' + char(10)
				SET @v_dSql += '		  		 AND    PLANT_ID = ( SELECT MAX(B.PLANT_ID)                                         ' + char(10)
				SET @v_dSql += '		  		                     FROM   SCM_MODEL_COMP_TEMP B  WITH(NOLOCK)                     ' + char(10)
				SET @v_dSql += '									 WHERE 	A.COMPANY_ID  = B.COMPANY_ID                            ' + char(10)
				SET @v_dSql += '									 AND    A.DIVISION_ID = B.DIVISION_ID                           ' + char(10)
				SET @v_dSql += '									 AND    A.SITE_ID     = B.SITE_ID                               ' + char(10)
				SET @v_dSql += '									 AND    A.MODEL_ID    = B.MODEL_ID                              ' + char(10)
				SET @v_dSql += '									)                                                               ' + char(10)
				SET @v_dSql += '		  		 GROUP  BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, MODEL_ID, CHILD_ITEM_ID      ' + char(10)
				SET @v_dSql += '			) AA,                                                                                   ' + char(10)
				SET @v_dSql += '			SCM_ITEM_M P  WITH(NOLOCK),                                                             ' + char(10)
				SET @v_dSql += '			SCM_ITEM_M C  WITH(NOLOCK)                                                              ' + char(10)
				SET @v_dSql += '	WHERE   AA.DIVISION_ID       = P.DIVISION_ID                                                    ' + char(10)
				SET @v_dSql += '	AND     AA.SITE_ID           = P.SITE_ID                                                        ' + char(10)
				SET @v_dSql += '	AND     AA.MODEL_ID          = P.ITEM_ID                                                        ' + char(10)
				SET @v_dSql += '	AND     AA.CHILD_DIVISION_ID = C.DIVISION_ID                                                    ' + char(10)
				SET @v_dSql += '	AND     AA.CHILD_SITE_ID     = C.SITE_ID                                                        ' + char(10)
				SET @v_dSql += '	AND     AA.CHILD_ITEM_ID     = C.ITEM_ID                                                        ' + char(10)
				SET @v_dSql += '	AND     AA.MODEL_ID         != AA.CHILD_ITEM_ID                                                 ' + char(10)
				SET @v_dSql += '	AND     C.ITEM_TYPE         != ''H''                                                            ' + char(10)
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('AA.DIVISION_ID' , 'EQ', @p_division_id)) + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('AA.SITE_ID' , 'EQ', @p_site_id)) + char(10);
				SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('AA.PLANT_ID' , 'EQ', @p_plant_id)) + char(10);
				--SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('AA.PARENT_ITEM_ID' , 'LIKE', @p_item_id)) + char(10);
				--SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('AA.CHILD_ITEM_ID' , 'LIKE', @p_child_item_id)) + char(10);
				--SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.NICK_NAME' , 'LIKE', @p_nick_name)) + char(10);
				--SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B2.NICK_NAME' , 'LIKE', @p_child_nick_name)) + char(10);
				SET @v_dSql += '	ORDER BY 1,2,3,7                                                                                ' + char(10)

			END
		
		
	END
	
	IF @p_sys_type = 'SQL' --OR @p_sys_flag = 'BOM_VIEW'
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

