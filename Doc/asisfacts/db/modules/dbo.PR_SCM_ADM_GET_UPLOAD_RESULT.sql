/*
 * Program ID   : PR_SCM_ADM_GET_UPLOAD_RESULT
 * Description  : PSI UPLOAD RESULT INFO 
 * Program History
 *===========================================================================================================
 *   Date       In Charge      Description
 *===========================================================================================================
 * 2017. 12. 15    SongDH     Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 *
 */

CREATE PROCEDURE [dbo].[PR_SCM_ADM_GET_UPLOAD_RESULT]
	@p_program_id		NVARCHAR(40),
	@p_sheet_name		NVARCHAR(150),
	@p_created_by		NVARCHAR(150)  --, @p_debug         NVARCHAR(MAX) OUTPUT
AS

BEGIN
    DECLARE @v_sql_text    AS NVARCHAR(MAX);
    DECLARE @v_columns     AS NVARCHAR(MAX);
    DECLARE @v_column_cnt  AS INTEGER;
    DECLARE @v_cnt         AS INTEGER;  

	SET NOCOUNT ON;
	
	SELECT @v_column_cnt = A.OPTION_ATTRIBUTE_COLUMN_NUMBER
    FROM   [dbo].[SCM_ADM_EXCEL_COLUMNS] A WITH(NOLOCK)	
    WHERE  PROGRAM_ID = @p_program_id 
	AND    SHEET_NAME = @p_sheet_name;

	--SELECT 'Success'                                                               AS SUCCESS_TITLE
	--	 , COUNT(CASE WHEN T.UPLOAD_STATUS_CODE = 'SUCCESS' THEN T.PROGRAM_ID END) AS SUCCESS_COUNT
 --        , 'Error'                                                                 AS ERROR_TITLE
	--	 , COUNT(CASE WHEN T.UPLOAD_STATUS_CODE = 'ERROR' THEN T.PROGRAM_ID END)   AS ERROR_COUNT
 --        , 'Total'                                                                 AS TOTAL_TITLE
 --        , COUNT(T.PROGRAM_ID)                                                     AS TOTAL_COUNT
 --   FROM   [dbo].[SCM_ADM_EXCEL_UPLOAD] T WITH(NOLOCK)	
 --   WHERE  T.PROGRAM_ID    = @p_program_id 
	--AND    T.SHEET_NAME    = @p_sheet_name 
	--AND    T.CREATED_BY    = @p_created_by
 --   AND    T.CREATION_DATE = ( SELECT MAX(X.CREATION_DATE)
 --                               FROM   [dbo].[SCM_ADM_EXCEL_UPLOAD] X WITH(NOLOCK)	
 --                               WHERE  X.PROGRAM_ID = @p_program_id 
	--							AND    X.SHEET_NAME = @p_sheet_name 
	--							AND    X.CREATED_BY = @p_created_by )
 --   AND    T.UPLOAD_STATUS_CODE IN ('SUCCESS','ERROR');

	-- Error Detail
	SET @v_columns = '';
    SET @v_cnt = 1;
    
	WHILE (@v_cnt <= @v_column_cnt)
	BEGIN
	    IF @v_columns = ''
		    SET @v_columns = ' ATTRIBUTE' + CONVERT(NVARCHAR, @v_cnt);
		ELSE
            SET @v_columns = @v_columns + ', ATTRIBUTE' + CONVERT(NVARCHAR, @v_cnt);

        SET @v_cnt = @v_cnt+1;
    END;

	BEGIN
    SET @v_columns = @v_columns + ', MESSAGE_TEXT';
    --SET @v_columns = SUBSTRING(@v_columns, 1, 2);
	END;

    SET @v_sql_text = '
    SELECT ''Success''                                                               AS SUCCESS_TITLE
		 , COUNT(CASE WHEN T.UPLOAD_STATUS_CODE = ''SUCCESS'' THEN T.PROGRAM_ID END) AS SUCCESS_COUNT
         , ''Error''                                                                 AS ERROR_TITLE
		 , COUNT(CASE WHEN T.UPLOAD_STATUS_CODE = ''ERROR'' THEN T.PROGRAM_ID END)   AS ERROR_COUNT
         , ''Total''                                                                 AS TOTAL_TITLE
         , COUNT(T.PROGRAM_ID)                                                     AS TOTAL_COUNT
    FROM   [dbo].[SCM_ADM_EXCEL_UPLOAD] T WITH(NOLOCK)	
    WHERE  T.PROGRAM_ID    = ''' + @p_program_id + '''  
	AND    T.SHEET_NAME    = ''' + @p_sheet_name + '''  
	AND    T.CREATED_BY    = ''' + @p_created_by + ''' 
    AND    T.CREATION_DATE = ( SELECT MAX(X.CREATION_DATE)
                                FROM   [dbo].[SCM_ADM_EXCEL_UPLOAD] X WITH(NOLOCK)	
                                WHERE  X.PROGRAM_ID = ''' + @p_program_id + '''  
								AND    X.SHEET_NAME = ''' + @p_sheet_name + '''  
								AND    X.CREATED_BY = ''' + @p_created_by + '''  )
    AND    T.UPLOAD_STATUS_CODE IN (''SUCCESS'',''ERROR'')
	
	
	SELECT ' + @v_columns + '
    FROM   [dbo].[SCM_ADM_EXCEL_UPLOAD] T WITH(NOLOCK)	
    WHERE  T.PROGRAM_ID = ''' + @p_program_id + ''' 
	AND    T.SHEET_NAME = ''' + @p_sheet_name + ''' 
    AND    T.CREATED_BY = ''' + @p_created_by + '''
    AND    T.CREATION_DATE  = ( SELECT MAX(X.CREATION_DATE)
                                FROM   [dbo].[SCM_ADM_EXCEL_UPLOAD] X WITH(NOLOCK)	
                                WHERE  X.PROGRAM_ID = ''' + @p_program_id + ''' 
								AND    X.SHEET_NAME = ''' + @p_sheet_name + ''' 
								AND    X.CREATED_BY = ''' + @p_created_by + ''' )
    AND    T.UPLOAD_STATUS_CODE    = ''ERROR'''
    ;
    
	--SET @p_debug = @v_columns;
	--RETURN @p_debug;

	EXEC SP_EXECUTESQL @v_sql_text;
/*	
---- xml확인할경우
 SELECT CONVERT(TEXT, @v_sql_text)
 FOR XML PATH('')--,ROOT('x')  
 */
END;						




