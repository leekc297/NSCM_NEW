

/*
 * Program ID   : PR_UI_FP00517_DOMESTIC_MODEL_MASTER
 * Description  : DOMESTIC MODEL MASTER
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/02/03   CYS				Initial Release UI통합
 */

CREATE PROCEDURE [dbo].[PR_UI_FP00517_DOMESTIC_MODEL_MASTER]
  @p_sys_type			NVARCHAR(MAX),  
  @p_sys_flag			NVARCHAR(MAX),
  @p_sys_gubun			NVARCHAR(MAX),  
  @p_user_id			NVARCHAR(MAX),

  @p_division_id		NVARCHAR(MAX),
  @p_site_id			NVARCHAR(MAX),
  @p_active				NVARCHAR(MAX),
  @p_item_id			NVARCHAR(MAX)

AS 
BEGIN
	
    SET NOCOUNT ON;

	DECLARE @v_proc_name	nvarchar(100) = 'PR_UI_FP00517_DOMESTIC_MODEL_MASTER';
	DECLARE @runstart		datetime;
	DECLARE @runend			datetime;
	DECLARE @v_dSql			nvarchar(MAX)='';
	
	BEGIN

		SET	@v_dSql = ''
		SET @v_dSql += '	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID 									' + char(10);
		SET @v_dSql += '	   , A.ITEM_ID, ISNULL(PD.NICK_NAME,''-'') AS NICK_NAME                         ' + char(10);
		SET @v_dSql += '	   , A.DEFAULT_MARKET                                                           ' + char(10);
		SET @v_dSql += '	   , A.ACTIVE_FLAG                                                              ' + char(10);
		SET @v_dSql += '	   , A.UPDATE_ID, CONVERT(VARCHAR, A.UPDATE_TIME, 20) AS UPDATE_TIME            ' + char(10);
		SET @v_dSql += '	   , A.PRODUCTION_TYPE                                                          ' + char(10);
		SET @v_dSql += '	   , (CASE WHEN R.COMPANY_ID IS NULL THEN ''N'' ELSE ''Y'' END) AS EDIT_YN      ' + char(10);
		SET @v_dSql += '	FROM   SCM_MODEL_MARKET_M A WITH(NOLOCK)                                        ' + char(10);
		SET @v_dSql += '	INNER JOIN SCM_ITEM_M PD WITH(NOLOCK)                                           ' + char(10);
		SET @v_dSql += '	ON  A.COMPANY_ID  = PD.COMPANY_ID                                               ' + char(10);
		SET @v_dSql += '	AND A.DIVISION_ID = PD.DIVISION_ID                                              ' + char(10);
		SET @v_dSql += '	AND A.SITE_ID     = PD.SITE_ID                                                  ' + char(10);
		SET @v_dSql += '	AND A.ITEM_ID     = PD.ITEM_ID                                                  ' + char(10);
		SET @v_dSql += '	LEFT OUTER JOIN (                                                               ' + char(10);
		SET @v_dSql += '	   SELECT DISTINCT R.COMPANY_ID, R.DIVISION_ID, R.SITE_ID                       ' + char(10);
		SET @v_dSql += '	   FROM   FP_USER_ROLE_INFO_V R WITH(NOLOCK)                                    ' + char(10);
		SET @v_dSql += '	   WHERE  R.USER_ID   = '''+ @p_user_id +'''                                    ' + char(10);
		SET @v_dSql += '	   AND    R.SAVE_FLAG = ''Y''                                                   ' + char(10);
		SET @v_dSql += '	) R                                                                             ' + char(10);
		SET @v_dSql += '	ON   A.COMPANY_ID   = R.COMPANY_ID                                              ' + char(10);
		SET @v_dSql += '	AND  A.DIVISION_ID  = R.DIVISION_ID                                             ' + char(10);
		SET @v_dSql += '	AND  A.SITE_ID      = R.SITE_ID                                                 ' + char(10);
		SET @v_dSql += '	WHERE EXISTS (                                                                  ' + char(10);
		SET @v_dSql += '	    SELECT 1                                                                    ' + char(10);
		SET @v_dSql += '	    FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)                                   ' + char(10);
		SET @v_dSql += '	    WHERE  A.COMPANY_ID   = B.COMPANY_ID                                        ' + char(10);
		SET @v_dSql += '	    AND    A.DIVISION_ID  = B.DIVISION_ID                                       ' + char(10);
		SET @v_dSql += '	    AND    A.SITE_ID      = B.SITE_ID                                           ' + char(10);
		SET @v_dSql += '	    AND    B.USER_ID      = '''+ @p_user_id +'''                                ' + char(10);
		SET @v_dSql += '	)                                                                               ' + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_item_id)) + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ACTIVE_FLAG' , 'EQ', @p_active)) + char(10);
		SET @v_dSql += '	ORDER BY A.DIVISION_ID, A.SITE_ID, A.ITEM_ID                                    ' + char(10);

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

