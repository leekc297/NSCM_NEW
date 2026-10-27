

/*
 * Program ID   : PR_UI_FP02550_OPERATION_BOD
 * Description  : Slurry Batch Master
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/06/18   CYS				Initial Release UI통합
 */

CREATE PROCEDURE [dbo].[PR_UI_FP02550_OPERATION_BOD]
  @p_sys_type			NVARCHAR(MAX),  
  @p_sys_flag			NVARCHAR(MAX),
  @p_sys_gubun			NVARCHAR(MAX),  
  @p_user_id			NVARCHAR(MAX),

  @p_company_id			NVARCHAR(MAX),
  @p_division_id		NVARCHAR(MAX),
  @p_site_id			NVARCHAR(MAX),
  @p_plant_id			NVARCHAR(MAX),
  @p_factory_id			NVARCHAR(MAX),
  @p_operation_id		NVARCHAR(MAX),
  @p_item_id			NVARCHAR(MAX),
  @p_nick_name			NVARCHAR(MAX),
  @p_model_type			NVARCHAR(MAX),
  @p_line_attr			NVARCHAR(MAX)
AS 
BEGIN
	
    SET NOCOUNT ON;

	DECLARE @v_proc_name	nvarchar(100) = 'PR_UI_FP02550_OPERATION_BOD';
	DECLARE @runstart		datetime;
	DECLARE @runend			datetime;
	DECLARE @v_dSql			nvarchar(MAX)='';
	
	BEGIN

		SET	@v_dSql = ''

		IF @p_sys_flag = 'MAIN' BEGIN
			
			SELECT @v_dSql += N'	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID,         										' + char(10)
			SELECT @v_dSql += N'	     A.MODEL_TYPE, A.LINE_ATTR_1,                                                                                                       ' + char(10)
			SELECT @v_dSql += N'	     BB.OPERATION_LOT_SIZE, BB.MIN_LOT_SIZE,BB.LOT_SIZE_UOM,                                                                            ' + char(10)
			SELECT @v_dSql += N'	     BB.TRANSFER_LOT_SIZE, BB.TRANSFER_LOT_SIZE_UOM,                                                                                    ' + char(10)
			SELECT @v_dSql += N'	     BB.PRECEDE_PRODUCING_TERM, ISNULL(BB.PRECEDE_PRODUCING_TERM_UOM,''DAY'') AS PRECEDE_PRODUCING_TERM_UOM,                            ' + char(10)
			SELECT @v_dSql += N'	     BB.BUFFER_TIME, ISNULL(BB.BUFFER_TIME_UOM,''MINUTE'') AS BUFFER_TIME_UOM, BB.TAT, ISNULL(BB.TAT_UOM,''MINUTE'') AS TAT_UOM,        ' + char(10)
			SELECT @v_dSql += N'	--             A.INITIAL_PRODUCING_LEAD_TIME, ISNULL(A.INITIAL_PRODUCING_LEAD_TIME_UOM,''DAY'') AS INITIAL_PRODUCING_LEAD_TIME_UOM,     ' + char(10)
			SELECT @v_dSql += N'	     BB.OPERATION_LEAD_TIME, BB.OPERATION_LEAD_TIME_UOM,                                                                                ' + char(10)
			SELECT @v_dSql += N'	     BB.TOLERANCE, BB.TOLERANCE_UOM,                                                                                                    ' + char(10)
			SELECT @v_dSql += N'	     (CASE WHEN BB.ACTIVE_FLAG IS NULL THEN ''Y'' ELSE BB.ACTIVE_FLAG END) AS ACTIVE_FLAG,                                              ' + char(10)
			SELECT @v_dSql += N'	     (CASE WHEN R.FACTORY_ID IS NULL THEN ''N'' ELSE ''Y'' END) AS EDIT_YN                                                              ' + char(10)
			SELECT @v_dSql += N'	FROM   SCM_OPERATION_MOVE_2_V A WITH(NOLOCK)                                                                                            ' + char(10)
			SELECT @v_dSql += N'	LEFT OUTER JOIN SCM_OPERATION_MOVE_M BB WITH(NOLOCK)                                                                                    ' + char(10)
			SELECT @v_dSql += N'	ON    A.COMPANY_ID    = BB.COMPANY_ID                                                                                                   ' + char(10)
			SELECT @v_dSql += N'	AND   A.DIVISION_ID   = BB.DIVISION_ID                                                                                                  ' + char(10)
			SELECT @v_dSql += N'	AND   A.SITE_ID       = BB.SITE_ID                                                                                                      ' + char(10)
			SELECT @v_dSql += N'	AND   A.PLANT_ID      = BB.PLANT_ID                                                                                                     ' + char(10)
			SELECT @v_dSql += N'	AND   A.FACTORY_ID    = BB.FACTORY_ID                                                                                                   ' + char(10)
			SELECT @v_dSql += N'	AND   A.OPERATION_ID  = BB.OPERATION_ID                                                                                                 ' + char(10)
			SELECT @v_dSql += N'	AND   A.MODEL_TYPE    = BB.MODEL_TYPE                                                                                                   ' + char(10)
			SELECT @v_dSql += N'	AND   A.LINE_ATTR_1   = BB.LINE_ATTR_1                                                                                                  ' + char(10)
			SELECT @v_dSql += N'	LEFT OUTER JOIN (                                                                                                                       ' + char(10)
			SELECT @v_dSql += N'	   SELECT DISTINCT R.COMPANY_ID, R.DIVISION_ID, R.SITE_ID, R.PLANT_ID, R.FACTORY_ID, R.OPERATION_ID                                     ' + char(10)
			SELECT @v_dSql += N'	   FROM   FP_USER_ROLE_INFO_V R WITH(NOLOCK)                                                                                            ' + char(10)
			SELECT @v_dSql += N'	   WHERE  R.USER_ID   = '''+ @p_user_id +'''                                                                                                       ' + char(10)
			SELECT @v_dSql += N'	   AND    R.SAVE_FLAG = ''Y''                                                                                                           ' + char(10)
			SELECT @v_dSql += N'	) R                                                                                                                                     ' + char(10)
			SELECT @v_dSql += N'	ON   A.COMPANY_ID   = R.COMPANY_ID                                                                                                      ' + char(10)
			SELECT @v_dSql += N'	AND  A.DIVISION_ID  = R.DIVISION_ID                                                                                                     ' + char(10)
			SELECT @v_dSql += N'	AND  A.SITE_ID      = R.SITE_ID                                                                                                         ' + char(10)
			SELECT @v_dSql += N'	AND  A.PLANT_ID     = R.PLANT_ID                                                                                                        ' + char(10)
			SELECT @v_dSql += N'	AND  A.FACTORY_ID   = R.FACTORY_ID                                                                                                      ' + char(10)
			SELECT @v_dSql += N'	AND  A.OPERATION_ID = R.OPERATION_ID                                                                                                    ' + char(10)
			SELECT @v_dSql += N'	WHERE  EXISTS (                                                                                                                         ' + char(10)
			SELECT @v_dSql += N'	    SELECT 1                                                                                                                            ' + char(10)
			SELECT @v_dSql += N'	    FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)                                                                                           ' + char(10)
			SELECT @v_dSql += N'	    WHERE  A.COMPANY_ID   = B.COMPANY_ID                                                                                                ' + char(10)
			SELECT @v_dSql += N'	    AND    A.DIVISION_ID  = B.DIVISION_ID                                                                                               ' + char(10)
			SELECT @v_dSql += N'	    AND    A.SITE_ID      = B.SITE_ID                                                                                                   ' + char(10)
			SELECT @v_dSql += N'	    AND    A.PLANT_ID     = B.PLANT_ID                                                                                                  ' + char(10)
			SELECT @v_dSql += N'	    AND    A.FACTORY_ID   = B.FACTORY_ID                                                                                                ' + char(10)
			SELECT @v_dSql += N'	    AND    A.OPERATION_ID = B.OPERATION_ID                                                                                              ' + char(10)
			SELECT @v_dSql += N'	    AND    B.USER_ID      = '''+ @p_user_id +'''                                                                                                   ' + char(10)
			SELECT @v_dSql += N'	)                                                                                                                                       ' + char(10)
			SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
			SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
			SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
			SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
			SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
			SELECT @v_dSql += N'	ORDER BY A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, OPERATION_ID                                                               ' + char(10)

		END ELSE IF @p_sys_flag = 'SUB'  BEGIN
			
			SELECT @v_dSql += N'	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID									' + char(10)	
			SELECT @v_dSql += N'	    ,A.OPERATION_ID                                                                                     ' + char(10)
			SELECT @v_dSql += N'	    ,A.MODEL_TYPE, A.LINE_ATTR_1                                                                        ' + char(10)
			SELECT @v_dSql += N'	    ,A.ITEM_ID, B.NICK_NAME                                                                             ' + char(10)
			SELECT @v_dSql += N'	    ,A.OPERATION_LOT_SIZE                                                                               ' + char(10)
			SELECT @v_dSql += N'	    ,A.MIN_LOT_SIZE                                                                                     ' + char(10)
			SELECT @v_dSql += N'	    ,A.LOT_SIZE_UOM                                                                                     ' + char(10)
			SELECT @v_dSql += N'		,A.TRANSFER_LOT_SIZE, A.TRANSFER_LOT_SIZE_UOM		                                                ' + char(10)
			SELECT @v_dSql += N'	    ,A.PRECEDE_PRODUCING_TERM, A.PRECEDE_PRODUCING_TERM_UOM                                             ' + char(10)
			SELECT @v_dSql += N'	    ,A.BUFFER_TIME, A.BUFFER_TIME_UOM                                                                   ' + char(10)
			SELECT @v_dSql += N'	    ,A.TAT                                                                                              ' + char(10)
			SELECT @v_dSql += N'	    ,A.TAT_UOM                                                                                          ' + char(10)
			SELECT @v_dSql += N'	    ,A.OPERATION_LEAD_TIME, A.OPERATION_LEAD_TIME_UOM                                                   ' + char(10)
			SELECT @v_dSql += N'	    ,A.TOLERANCE, A.TOLERANCE_UOM                                                                       ' + char(10)
			SELECT @v_dSql += N'	    ,A.INITIAL_PRODUCING_LEAD_TIME, A.INITIAL_PRODUCING_LEAD_TIME_UOM                                   ' + char(10)
			SELECT @v_dSql += N'	    ,A.TAT_FLAG                                                                                         ' + char(10)
			SELECT @v_dSql += N'	    ,A.ACTIVE_FLAG                                                                                      ' + char(10)
			SELECT @v_dSql += N'	    ,A.DESCRIPTION                                                                                      ' + char(10)
			SELECT @v_dSql += N'	    ,(CASE WHEN R.FACTORY_ID IS NULL THEN ''N'' ELSE ''Y'' END) AS EDIT_YN                              ' + char(10)
			SELECT @v_dSql += N'	FROM   SCM_ITEM_FLOW_EXCEPT_M A WITH(NOLOCK)                                                            ' + char(10)
			SELECT @v_dSql += N'	LEFT OUTER JOIN (                                                                                       ' + char(10)
			SELECT @v_dSql += N'	   SELECT DISTINCT R.COMPANY_ID, R.DIVISION_ID, R.SITE_ID, R.PLANT_ID, R.FACTORY_ID, R.OPERATION_ID     ' + char(10)
			SELECT @v_dSql += N'	   FROM   FP_USER_ROLE_INFO_V R WITH(NOLOCK)                                                            ' + char(10)
			SELECT @v_dSql += N'	   WHERE  R.USER_ID   = '''+ @p_user_id +'''                                                                       ' + char(10)
			SELECT @v_dSql += N'	   AND    R.SAVE_FLAG = ''Y''                                                                           ' + char(10)
			SELECT @v_dSql += N'	) R                                                                                                     ' + char(10)
			SELECT @v_dSql += N'	ON     A.COMPANY_ID   = R.COMPANY_ID                                                                    ' + char(10)
			SELECT @v_dSql += N'	AND    A.DIVISION_ID  = R.DIVISION_ID                                                                   ' + char(10)
			SELECT @v_dSql += N'	AND    A.SITE_ID      = R.SITE_ID                                                                       ' + char(10)
			SELECT @v_dSql += N'	AND    A.PLANT_ID     = R.PLANT_ID                                                                      ' + char(10)
			SELECT @v_dSql += N'	AND    A.FACTORY_ID   = R.FACTORY_ID                                                                    ' + char(10)
			SELECT @v_dSql += N'	AND    A.OPERATION_ID = R.OPERATION_ID                                                                  ' + char(10)
			SELECT @v_dSql += N'	, SCM_ITEM_M B WITH(NOLOCK)                                                                             ' + char(10)
			SELECT @v_dSql += N'	WHERE  A.COMPANY_ID   = B.COMPANY_ID                                                                    ' + char(10)
			SELECT @v_dSql += N'	AND    A.DIVISION_ID  = B.DIVISION_ID                                                                   ' + char(10)
			SELECT @v_dSql += N'	AND    A.SITE_ID      = B.SITE_ID                                                                       ' + char(10)
			SELECT @v_dSql += N'	AND    A.ITEM_ID      = B.ITEM_ID                                                                       ' + char(10)
			SELECT @v_dSql += N'	AND    B.ACTIVE_FLAG  = ''Y''                                                                           ' + char(10)
			SELECT @v_dSql += N'	AND    A.COMPANY_ID   = '''+ @p_company_id +'''                                                                  ' + char(10)
			SELECT @v_dSql += N'	AND    A.DIVISION_ID  = '''+ @p_division_id +'''                                                                   ' + char(10)
			SELECT @v_dSql += N'	AND    A.SITE_ID      = '''+ @p_site_id +'''                                                            ' + char(10)
			SELECT @v_dSql += N'	AND    A.PLANT_ID     = '''+ @p_plant_id +'''                                                                 ' + char(10)
			SELECT @v_dSql += N'	AND    A.FACTORY_ID   = '''+ @p_factory_id +'''                                                             ' + char(10)
			SELECT @v_dSql += N'	AND    A.OPERATION_ID = '''+ @p_operation_id +'''                                                               ' + char(10)
			SELECT @v_dSql += N'	AND    A.MODEL_TYPE   = '''+ @p_model_type +'''                                                               ' + char(10)
			SELECT @v_dSql += N'	AND    A.LINE_ATTR_1  = '''+ @p_line_attr +'''                                                                  ' + char(10)
			SELECT @v_dSql += N'	ORDER BY A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.ITEM_ID                                            ' + char(10)

		END ELSE IF @p_sys_flag = 'SUB_ALL'  BEGIN
			
			SELECT @v_dSql += N'	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID									' + char(10)							
			SELECT @v_dSql += N'	    ,A.ITEM_ID, B.NICK_NAME                                                                             ' + char(10)
			SELECT @v_dSql += N'	    ,A.OPERATION_ID                                                                                     ' + char(10)
			SELECT @v_dSql += N'	    ,A.OPERATION_LOT_SIZE                                                                               ' + char(10)
			SELECT @v_dSql += N'	    ,A.MIN_LOT_SIZE                                                                                     ' + char(10)
			SELECT @v_dSql += N'	    ,A.LOT_SIZE_UOM                                                                                     ' + char(10)
			SELECT @v_dSql += N'	    ,A.BUFFER_TIME, A.BUFFER_TIME_UOM                                                                   ' + char(10)
			SELECT @v_dSql += N'	    ,A.TAT                                                                                              ' + char(10)
			SELECT @v_dSql += N'	    ,A.TAT_UOM                                                                                          ' + char(10)
			SELECT @v_dSql += N'	    ,A.TAT_FLAG                                                                                         ' + char(10)
			SELECT @v_dSql += N'	    ,A.PRECEDE_PRODUCING_TERM, A.PRECEDE_PRODUCING_TERM_UOM                                             ' + char(10)
			SELECT @v_dSql += N'	    ,A.INITIAL_PRODUCING_LEAD_TIME, A.INITIAL_PRODUCING_LEAD_TIME_UOM                                   ' + char(10)
			SELECT @v_dSql += N'		      ,A.TRANSFER_LOT_SIZE, ISNULL(A.TRANSFER_LOT_SIZE_UOM,''MINUTE'') AS TRANSFER_LOT_SIZE_UOM     ' + char(10)
			SELECT @v_dSql += N'	    ,A.ACTIVE_FLAG                                                                                      ' + char(10)
			SELECT @v_dSql += N'	    ,A.DESCRIPTION                                                                                      ' + char(10)
			SELECT @v_dSql += N'	    ,A.OPERATION_LEAD_TIME, A.OPERATION_LEAD_TIME_UOM                                                   ' + char(10)
			SELECT @v_dSql += N'	    ,A.TOLERANCE, A.TOLERANCE_UOM                                                                       ' + char(10)
			SELECT @v_dSql += N'	    ,A.MODEL_TYPE, A.LINE_ATTR_1                                                                        ' + char(10)
			SELECT @v_dSql += N'	    ,(CASE WHEN R.FACTORY_ID IS NULL THEN ''N'' ELSE ''Y'' END) AS EDIT_YN                              ' + char(10)
			SELECT @v_dSql += N'	FROM   SCM_ITEM_FLOW_EXCEPT_M A WITH(NOLOCK)                                                            ' + char(10)
			SELECT @v_dSql += N'	LEFT OUTER JOIN (                                                                                       ' + char(10)
			SELECT @v_dSql += N'	   SELECT DISTINCT R.COMPANY_ID, R.DIVISION_ID, R.SITE_ID, R.PLANT_ID, R.FACTORY_ID, R.OPERATION_ID     ' + char(10)
			SELECT @v_dSql += N'	   FROM   FP_USER_ROLE_INFO_V R WITH(NOLOCK)                                                            ' + char(10)
			SELECT @v_dSql += N'	   WHERE  R.USER_ID   = '''+ @p_user_id +'''                                                                       ' + char(10)
			SELECT @v_dSql += N'	   AND    R.SAVE_FLAG = ''Y''                                                                           ' + char(10)
			SELECT @v_dSql += N'	) R                                                                                                     ' + char(10)
			SELECT @v_dSql += N'	ON     A.COMPANY_ID   = R.COMPANY_ID                                                                    ' + char(10)
			SELECT @v_dSql += N'	AND    A.DIVISION_ID  = R.DIVISION_ID                                                                   ' + char(10)
			SELECT @v_dSql += N'	AND    A.SITE_ID      = R.SITE_ID                                                                       ' + char(10)
			SELECT @v_dSql += N'	AND    A.PLANT_ID     = R.PLANT_ID                                                                      ' + char(10)
			SELECT @v_dSql += N'	AND    A.FACTORY_ID   = R.FACTORY_ID                                                                    ' + char(10)
			SELECT @v_dSql += N'	AND    A.OPERATION_ID = R.OPERATION_ID                                                                  ' + char(10)
			SELECT @v_dSql += N'	, SCM_ITEM_M B WITH(NOLOCK)                                                                             ' + char(10)
			SELECT @v_dSql += N'	WHERE  A.COMPANY_ID  = B.COMPANY_ID                                                                     ' + char(10)
			SELECT @v_dSql += N'	AND    A.DIVISION_ID = B.DIVISION_ID                                                                    ' + char(10)
			SELECT @v_dSql += N'	AND    A.SITE_ID     = B.SITE_ID                                                                        ' + char(10)
			SELECT @v_dSql += N'	AND    A.ITEM_ID     = B.ITEM_ID                                                                        ' + char(10)
			SELECT @v_dSql += N'	AND    B.ACTIVE_FLAG = ''Y''                                                                            ' + char(10)
			SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
			SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
			SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
			SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
			SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
			SELECT @v_dSql += N'	ORDER BY A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.ITEM_ID                                            ' + char(10)

		END

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

