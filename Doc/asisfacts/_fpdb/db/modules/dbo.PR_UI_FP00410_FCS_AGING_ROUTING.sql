

/*
 * Program ID   : PR_UI_FP00410_FCS_AGING_ROUTING
 * Description  : FCS Aging Routing
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/01/15   CYS				Initial Release UI통합
 */

CREATE PROCEDURE [dbo].[PR_UI_FP00410_FCS_AGING_ROUTING]
  
  @p_sys_type			NVARCHAR(MAX),  
  @p_sys_flag			NVARCHAR(MAX),
  @p_sys_gubun			NVARCHAR(MAX),  
  @p_user_id			NVARCHAR(MAX),
  @p_division_lt		NVARCHAR(MAX),
  @p_site_id			NVARCHAR(MAX),
  @p_plant_lt			NVARCHAR(MAX),
  @p_factory_lt			NVARCHAR(MAX),
  @p_route_type			NVARCHAR(MAX),
  @p_route_id			NVARCHAR(MAX),
  @p_item_id			NVARCHAR(MAX),
  @p_nick_name			NVARCHAR(MAX)

AS 
BEGIN
	
    SET NOCOUNT ON;
	
	DECLARE @v_proc_name	nvarchar(100) = 'PR_UI_FP00410_FCS_AGING_ROUTING';
	DECLARE @runstart		datetime;
	DECLARE @runend			datetime;
	DECLARE @v_dSql			nvarchar(MAX)='';

	BEGIN

		SET	@v_dSql = ''
		SET @v_dSql += '	SELECT A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID,A.FACTORY_ID               					' + char(10)
		SET @v_dSql += '			,A.ITEM_ID                                                                                  ' + char(10)
		SET @v_dSql += '			,A.ROUTE_ID                                                                                 ' + char(10)
		SET @v_dSql += '			,A.LINE_ID                                                                                  ' + char(10)
		SET @v_dSql += '			,A.OPERATION_ID                                                                             ' + char(10)
		SET @v_dSql += '			,A.OPERATION_SEQ                                                                            ' + char(10)
		SET @v_dSql += '			,A.OPERATION_STEP                                                                           ' + char(10)
		SET @v_dSql += '			,A.ROUTE_TYPE                                                                               ' + char(10)
		SET @v_dSql += '			,A.PROCESSING_TIME                                                                          ' + char(10)
		SET @v_dSql += '			,A.ROUTE_DESCRIPTION                                                                        ' + char(10)
		SET @v_dSql += '			,A.OPERATION_NAME                                                                           ' + char(10)
		SET @v_dSql += '			,ISNULL(B.NICK_NAME,''-'') AS NICK_NAME                                                     ' + char(10)
		SET @v_dSql += '			,ISNULL(C.CODE_NAME, A.DEFAULT_FLAG) AS DEFAULT_FLAG                                        ' + char(10)
		SET @v_dSql += '			,A.DEFAULT_ROUTE                                                                            ' + char(10)
		SET @v_dSql += '			,A.STANDARD_LT                                                                              ' + char(10)
		SET @v_dSql += '			,A.EXTRA_LIMIT_TIME                                                                         ' + char(10)
		SET @v_dSql += '	FROM	SCM_AGING_ITEM_FLOW_M A WITH(NOLOCK)                                                        ' + char(10)
		SET @v_dSql += '			LEFT OUTER JOIN (                                                                           ' + char(10)
		SET @v_dSql += '								SELECT DISTINCT AC.ATTRIBUTE2 AS CODE_ID, AC.ATTRIBUTE3 AS CODE_NAME    ' + char(10)
		SET @v_dSql += '								FROM   SCM_SYS_LOOKUP_VALUE AC(NOLOCK)                                  ' + char(10)
		SET @v_dSql += '								WHERE  AC.LOOKUP_TYPE_CODE = ''FORMATION_ROUTE_TYPE_MAPPING''           ' + char(10)
		SET @v_dSql += '							) C                                                                         ' + char(10)
		SET @v_dSql += '			ON A.DEFAULT_FLAG = C.CODE_ID                                                               ' + char(10)
		SET @v_dSql += '			, SCM_ITEM_M B WITH(NOLOCK)                                                                 ' + char(10)
		SET @v_dSql += '	WHERE  A.COMPANY_ID   = B.COMPANY_ID                                                                ' + char(10)
		SET @v_dSql += '	AND    A.DIVISION_ID  = B.DIVISION_ID                                                               ' + char(10)
		SET @v_dSql += '	AND    A.SITE_ID      = B.SITE_ID                                                                   ' + char(10)
		SET @v_dSql += '	AND    A.ITEM_ID      = B.ITEM_ID                                                                   ' + char(10)
		SET @v_dSql += '	AND    B.ACTIVE_FLAG  = ''Y''                                                                       ' + char(10)
		SET @v_dSql += '	AND    EXISTS	(                                                                                   ' + char(10)
		SET @v_dSql += '						SELECT 1                                                                        ' + char(10)
		SET @v_dSql += '						FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)                                       ' + char(10)
		SET @v_dSql += '						WHERE  A.COMPANY_ID   = B.COMPANY_ID                                            ' + char(10)
		SET @v_dSql += '						AND    A.DIVISION_ID  = B.DIVISION_ID                                           ' + char(10)
		SET @v_dSql += '						AND    A.SITE_ID      = B.SITE_ID                                               ' + char(10)
		SET @v_dSql += '						AND    A.PLANT_ID     = B.PLANT_ID                                              ' + char(10)
		SET @v_dSql += '						AND    A.FACTORY_ID   = B.FACTORY_ID                                            ' + char(10)
		SET @v_dSql += '						AND    B.USER_ID      = '''+@p_user_id+'''                                      ' + char(10)
		SET @v_dSql += '					)                                                                                   ' + char(10)
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_lt)) + char(10)
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_lt)) + char(10)
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_lt)) + char(10)
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ROUTE_TYPE' , 'EQ', @p_route_type)) + char(10)
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ROUTE_ID' , 'EQ', @p_route_id)) + char(10)
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_item_id)) + char(10)
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.NICK_NAME' , 'LIKE', @p_nick_name)) + char(10)
		SET	@v_dSql += '	ORDER BY A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID,A.ROUTE_TYPE,A.OPERATION_SEQ,A.OPERATION_STEP	' + char(10)
	
	END

	IF @p_sys_type = 'SQL'
    BEGIN
		exec PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_sys_flag,'',@v_dSql, @p_sys_type, @runstart, @runend
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

