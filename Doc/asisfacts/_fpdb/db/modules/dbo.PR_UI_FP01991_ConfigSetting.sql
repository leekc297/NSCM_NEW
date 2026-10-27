

/*
 * Program ID   : FP01991_ConfigSetting
 * Description  : Config Setting 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2022/05/02    KSI		   Initial Release : GSCM(FP) Config Setting 
 *
 */

CREATE PROCEDURE [dbo].[PR_UI_FP01991_ConfigSetting]

@p_sys_type			NVARCHAR(MAX) = '',  
@p_sys_flag			NVARCHAR(MAX)= '',
@p_sys_gubun			NVARCHAR(MAX)= '',  
@p_user_id			NVARCHAR(MAX)= '',
@in_columns           NVARCHAR(MAX)= '',
@in_row               NVARCHAR(MAX)= '',
@opt_none             NVARCHAR(5) = 'N'


 

WITH EXEC AS CALLER
AS
BEGIN
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
SET NOCOUNT ON; 
SET XACT_ABORT ON;
SET NOCOUNT ON;



DECLARE @v_user_id    NVARCHAR(MAX)


DECLARE @p_instance_id    NVARCHAR(MAX) = ''
DECLARE @p_category_id    NVARCHAR(MAX) = ''
DECLARE @p_key_id		  NVARCHAR(MAX) = ''

DECLARE @p_OLD_key_id		  NVARCHAR(MAX) = ''
DECLARE @p_OLD_PART_ID		  NVARCHAR(MAX) = ''
DECLARE @p_OLD_KEY_VALUE	  NVARCHAR(MAX) = ''

DECLARE @p_CONFIG_SET_ID  NVARCHAR(MAX) = 'LG_CHEM'
DECLARE @p_PART_ID		  NVARCHAR(MAX) = ''
DECLARE @p_KEY_VALUE	  NVARCHAR(MAX) = ''
DECLARE @p_VALUE_TYPE	  NVARCHAR(MAX) = ''
DECLARE @p_KEY_PRIORITY	  NVARCHAR(MAX) = ''
DECLARE @p_TOLERANCE	  NVARCHAR(MAX) = ''
DECLARE @p_TOLERANCE_UOM  NVARCHAR(MAX) = ''
DECLARE @p_VIEW_FLAG	  NVARCHAR(MAX) = ''
DECLARE @p_USE_YN		  NVARCHAR(MAX) = ''
DECLARE @p_DESCRIPTION	  NVARCHAR(MAX) = ''



DECLARE @v_instance_id    NVARCHAR(MAX) = ''
DECLARE @v_category_id    NVARCHAR(MAX) = ''
DECLARE @v_key_id		  NVARCHAR(MAX) = ''

DECLARE @v_OLD_key_id		  NVARCHAR(MAX) = ''
DECLARE @v_OLD_PART_ID		  NVARCHAR(MAX) = ''
DECLARE @v_OLD_KEY_VALUE	  NVARCHAR(MAX) = ''

DECLARE @v_CONFIG_SET_ID  NVARCHAR(MAX) = ''
DECLARE @v_PART_ID		  NVARCHAR(MAX) = ''
DECLARE @v_KEY_VALUE	  NVARCHAR(MAX) = ''
DECLARE @v_VALUE_TYPE	  NVARCHAR(MAX) = ''
DECLARE @v_KEY_PRIORITY	  NVARCHAR(MAX) = ''
DECLARE @v_TOLERANCE	  NVARCHAR(MAX) = ''
DECLARE @v_TOLERANCE_UOM  NVARCHAR(MAX) = ''
DECLARE @v_VIEW_FLAG	  NVARCHAR(MAX) = ''
DECLARE @v_USE_YN		  NVARCHAR(MAX) = ''
DECLARE @v_DESCRIPTION	  NVARCHAR(MAX) = ''

DECLARE @v_pSql           NVARCHAR(MAX) =''


DECLARE @max_loop_cnt	        INTEGER = 0
DECLARE @mst_loop_cnt	        INTEGER = 0

DECLARE @v_delimiter            NVARCHAR(1)
DECLARE @v_sub_delimiter        NVARCHAR(1)

DECLARE @tmp_column             NVARCHAR(MAX) = ''

--DECLARE BASE PARAMETER START
DECLARE @runstart          datetime
DECLARE @runend            datetime
DECLARE @v_Err             NVARCHAR(max)
DECLARE @v_Log             NVARCHAR(max) 
DECLARE @v_proc_name       NVARCHAR(100) = 'PR_UI_FP01991_ConfigSetting'

--DECLARE @v_dSql                 NVARCHAR(MAX)=''

SET @v_delimiter            = '^'  
SET @v_sub_delimiter        = '|'  
SET @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@in_columns, @v_delimiter) 	

--print @in_row;


WHILE @mst_loop_cnt < @max_loop_cnt
BEGIN --START WHILE
    SET @mst_loop_cnt = @mst_loop_cnt + 1;        
    SET @tmp_column   = [dbo].[SCM_ARR_SPL_VAL]( @in_columns, @v_delimiter, @mst_loop_cnt);

    IF @tmp_column = 'INSTANCE_ID' 
    BEGIN
        SET @p_instance_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row        ,@v_delimiter, @mst_loop_cnt);			
    END 
	ELSE IF @tmp_column = 'CATEGORY_ID' 
    BEGIN
        SET @p_category_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row        ,@v_delimiter, @mst_loop_cnt);			
    END 
    ELSE IF @tmp_column = 'KEY_ID' 
    BEGIN
        SET @p_key_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row    ,@v_delimiter, @mst_loop_cnt);
    END 
	---------------------
	ELSE IF @tmp_column = 'PART_ID' 
    BEGIN
        SET @p_PART_ID =  [dbo].[SCM_ARR_SPL_VAL]( @in_row    ,@v_delimiter, @mst_loop_cnt);
    END 
	ELSE IF @tmp_column = 'KEY_VALUE' 
    BEGIN
        SET @p_KEY_VALUE =  [dbo].[SCM_ARR_SPL_VAL]( @in_row    ,@v_delimiter, @mst_loop_cnt);
    END 
	ELSE IF @tmp_column = 'VALUE_TYPE' 
    BEGIN
        SET @p_VALUE_TYPE =  [dbo].[SCM_ARR_SPL_VAL]( @in_row    ,@v_delimiter, @mst_loop_cnt);
    END 
	ELSE IF @tmp_column = 'KEY_PRIORITY' 
    BEGIN
        SET @p_KEY_PRIORITY	 =  [dbo].[SCM_ARR_SPL_VAL]( @in_row    ,@v_delimiter, @mst_loop_cnt);
    END 
	ELSE IF @tmp_column = 'TOLERANCE' 
    BEGIN
        SET @p_TOLERANCE =  [dbo].[SCM_ARR_SPL_VAL]( @in_row    ,@v_delimiter, @mst_loop_cnt);
    END 
	ELSE IF @tmp_column = 'TOLERANCE_UOM' 
    BEGIN
        SET @p_TOLERANCE_UOM  =  [dbo].[SCM_ARR_SPL_VAL]( @in_row    ,@v_delimiter, @mst_loop_cnt);
    END 
	ELSE IF @tmp_column = 'VIEW_FLAG' 
    BEGIN
        SET @p_VIEW_FLAG =  [dbo].[SCM_ARR_SPL_VAL]( @in_row    ,@v_delimiter, @mst_loop_cnt);
    END 
	ELSE IF @tmp_column = 'USE_YN' 
    BEGIN
        SET @p_USE_YN =  [dbo].[SCM_ARR_SPL_VAL]( @in_row    ,@v_delimiter, @mst_loop_cnt);
    END 
	ELSE IF @tmp_column = 'DESCRIPTION' 
    BEGIN
        SET @p_DESCRIPTION =  [dbo].[SCM_ARR_SPL_VAL]( @in_row    ,@v_delimiter, @mst_loop_cnt);
    END 
	ELSE IF @tmp_column = 'OLD_KEY_ID' 
    BEGIN
        SET @p_OLD_key_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row    ,@v_delimiter, @mst_loop_cnt);
    END 
	ELSE IF @tmp_column = 'OLD_PART_ID' 
    BEGIN
        SET @p_OLD_PART_ID	 =  [dbo].[SCM_ARR_SPL_VAL]( @in_row    ,@v_delimiter, @mst_loop_cnt);
    END 
	ELSE IF @tmp_column = 'OLD_KEY_VALUE' 
    BEGIN
        SET @p_OLD_KEY_VALUE =  [dbo].[SCM_ARR_SPL_VAL]( @in_row    ,@v_delimiter, @mst_loop_cnt);
    END 

END

BEGIN 
       SELECT @v_instance_id      = '''' + @p_instance_id + ''''      , @v_category_id    = '''' + @p_category_id + ''''
            , @v_key_id      = '''' + @p_key_id + '''' 
			------------------
			, @v_CONFIG_SET_ID  = '''' + @p_CONFIG_SET_ID + '''' 
			, @v_PART_ID		= '''' + @p_PART_ID		  + '''' 
			, @v_KEY_VALUE	    = '''' + @p_KEY_VALUE	  + '''' 
			, @v_VALUE_TYPE	    = '''' + @p_VALUE_TYPE	  + '''' 
			, @v_KEY_PRIORITY	= '''' + @p_KEY_PRIORITY  + '''' 
			, @v_TOLERANCE	    = '''' + @p_TOLERANCE	  + '''' 
			, @v_TOLERANCE_UOM  = '''' + @p_TOLERANCE_UOM + '''' 
			, @v_VIEW_FLAG	    = '''' + @p_VIEW_FLAG	  + '''' 
			, @v_DESCRIPTION	= '''' + @p_DESCRIPTION	  + '''' 
			, @v_USE_YN		= '''' + @p_USE_YN	  + '''' 
			, @v_user_id		= '''' + @p_user_id	  + '''' 
			, @v_OLD_key_id		= '''' + @p_OLD_key_id	  + '''' 
			, @v_OLD_PART_ID		= '''' + @p_OLD_PART_ID	  + '''' 
			, @v_OLD_KEY_VALUE		= '''' + @p_OLD_KEY_VALUE	  + '''' 
END

IF @p_sys_flag = 'SELECT_MAIN'
BEGIN
	SELECT @v_pSql = ''

    SELECT @v_pSql += '  SELECT A.CONFIG_SET_ID, A.INSTANCE_ID, A.CATEGORY_ID, A.KEY_ID, A.PART_ID, A.KEY_VALUE ' + char(10)
    SELECT @v_pSql += '        ,A.VALUE_TYPE, A.KEY_PRIORITY ' + char(10)
    SELECT @v_pSql += '        ,A.TOLERANCE, A.TOLERANCE_UOM ' + char(10)
    SELECT @v_pSql += '        ,A.VIEW_FLAG ' + char(10)
    SELECT @v_pSql += '        ,A.USE_YN ' + char(10)
    SELECT @v_pSql += '        ,A.DESCRIPTION ' + char(10)
    SELECT @v_pSql += '        ,A.OLD_KEY_ID, A.OLD_PART_ID, A.OLD_KEY_VALUE ' + char(10)
    SELECT @v_pSql += '        FROM   FP_INSTANCE_CONFIG_M A ' + char(10)
    SELECT @v_pSql += '        WHERE  A.CONFIG_SET_ID = ''LG_CHEM'' ' + char(10)
	IF(LEN(@p_instance_id) > 0 )
	BEGIN 
		 SELECT @v_pSql += '        AND    A.INSTANCE_ID   = ' + @v_instance_id + char(10)
	END
   	IF(LEN(@p_category_id) > 0 )
	BEGIN 
		 SELECT @v_pSql += '        AND    A.CATEGORY_ID   = ' + @v_category_id + char(10)
	END
    IF(LEN(@p_key_id) > 0 )
	BEGIN 
		 SELECT @v_pSql += '        AND    UPPER(A.KEY_ID) LIKE ''%' + UPPER(@p_key_id) + '%'' ' + char(10)
	END
    
    SELECT @v_pSql += '        ORDER BY A.INSTANCE_ID, A.CATEGORY_ID, A.KEY_ID, A.KEY_PRIORITY ' + char(10)
    
	

END
ELSE IF @p_sys_flag = 'INSERT_MAIN_CHECK'
BEGIN
	SELECT @v_pSql = ''
	SELECT @v_pSql += 'SELECT  ' + char(10)
    SELECT @v_pSql += 'CASE  ' + char(10)
    SELECT @v_pSql += '    WHEN EXISTS( ' + char(10)
    SELECT @v_pSql += '         SELECT 1  ' + char(10)
    SELECT @v_pSql += '         FROM FP_INSTANCE_CONFIG_M ' + char(10)
    SELECT @v_pSql += '         WHERE INSTANCE_ID = ' + @v_instance_id + char(10)
	SELECT @v_pSql += '		 AND  CATEGORY_ID = ' + @v_category_id + char(10)
	SELECT @v_pSql += '		 AND  KEY_ID = ' + @v_key_id  + char(10)
	SELECT @v_pSql += '		 AND  KEY_VALUE = ' + @v_KEY_VALUE  + char(10)
	SELECT @v_pSql += '		 AND  CONFIG_SET_ID = ' + @v_CONFIG_SET_ID + char(10)
	SELECT @v_pSql += '		 AND  PART_ID = ' + @v_PART_ID + ') ' + char(10)
    SELECT @v_pSql += '    THEN ''DUPLICITY''  ' + char(10)
    SELECT @v_pSql += '    ELSE ''SUCCESS''  ' + char(10)
    SELECT @v_pSql += ' END as RESULT  ' + char(10)

END
ELSE IF @p_sys_flag = 'INSERT_MAIN'
BEGIN
	SELECT @v_pSql = ''
	SELECT @v_pSql += ' BEGIN TRAN ' + char(10)

	SELECT @v_pSql += '  INSERT INTO FP_INSTANCE_CONFIG_M ' + char(10)
	SELECT @v_pSql += '   ( CONFIG_SET_ID ' + char(10)
	SELECT @v_pSql += '    ,INSTANCE_ID ' + char(10)
	SELECT @v_pSql += '    ,CATEGORY_ID ' + char(10)
	SELECT @v_pSql += '    ,KEY_ID ' + char(10)
	SELECT @v_pSql += '    ,PART_ID ' + char(10)
	SELECT @v_pSql += '    ,KEY_VALUE ' + char(10)
	SELECT @v_pSql += '    ,VALUE_TYPE ' + char(10)
	SELECT @v_pSql += '    ,KEY_PRIORITY ' + char(10)
	SELECT @v_pSql += '    ,TOLERANCE ' + char(10)
	SELECT @v_pSql += '    ,TOLERANCE_UOM ' + char(10)
	SELECT @v_pSql += '    ,VIEW_FLAG ' + char(10)
	SELECT @v_pSql += '    ,USE_YN ' + char(10)
	SELECT @v_pSql += '    ,DESCRIPTION ' + char(10)
	SELECT @v_pSql += '    ,INSERT_ID ' + char(10)
	SELECT @v_pSql += '    ,INSERT_TIME ' + char(10)
	SELECT @v_pSql += '    ,UPDATE_ID ' + char(10)
	SELECT @v_pSql += '    ,UPDATE_TIME ' + char(10)
	SELECT @v_pSql += '    ,OLD_KEY_ID ' + char(10)
	SELECT @v_pSql += '    ,OLD_PART_ID ' + char(10)
	SELECT @v_pSql += '    ,OLD_KEY_VALUE ' + char(10)

	SELECT @v_pSql += '     ) VALUES ( ' + char(10)
	SELECT @v_pSql +=       @v_CONFIG_SET_ID + char(10) 
	SELECT @v_pSql += '    ,N' + @v_instance_id + char(10)
	SELECT @v_pSql += '    ,N' + @v_category_id + char(10)
	SELECT @v_pSql += '    ,N' + @v_key_id  + char(10)
	SELECT @v_pSql += '    ,N' + @v_PART_ID + char(10)
	SELECT @v_pSql += '    ,N' + @v_KEY_VALUE + char(10)
	SELECT @v_pSql += '    ,N' + @v_VALUE_TYPE + char(10)
	SELECT @v_pSql += '    ,N' + @v_KEY_PRIORITY + char(10)
	SELECT @v_pSql += '    ,N' + @v_TOLERANCE + char(10)
	SELECT @v_pSql += '    ,N' + @v_TOLERANCE_UOM + char(10)
	SELECT @v_pSql += '    ,N' + @v_VIEW_FLAG + char(10)
	SELECT @v_pSql += '    ,N' + @v_USE_YN + char(10)
	SELECT @v_pSql += '    ,N' + @v_DESCRIPTION + char(10)
	SELECT @v_pSql += '    ,' + @v_user_id + char(10)
	SELECT @v_pSql += '    ,dbo.sysdate1() ' + char(10)
	SELECT @v_pSql += '    ,' + @v_user_id + char(10)
	SELECT @v_pSql += '    ,dbo.sysdate1()' + char(10)
	SELECT @v_pSql += '    ,N' + @v_key_id  + char(10)
	SELECT @v_pSql += '    ,N' + @v_PART_ID + char(10)
	SELECT @v_pSql += '    ,N' + @v_KEY_VALUE + char(10)
	SELECT @v_pSql += '    );' + char(10)
	SELECT @v_pSql += '    commit ' + char(10)	
END
ELSE IF @p_sys_flag = 'DELETE_MAIN'
BEGIN
	SELECT @v_pSql = ''
	SELECT @v_pSql += '     BEGIN TRAN ' + char(10)
	SELECT @v_pSql += '     DELETE FROM FP_INSTANCE_CONFIG_M ' + char(10)
	SELECT @v_pSql += '     WHERE  CONFIG_SET_ID  = ' + @v_CONFIG_SET_ID + char(10)
	SELECT @v_pSql += '     AND    INSTANCE_ID    = ' + @v_INSTANCE_ID + char(10)
	SELECT @v_pSql += '     AND    CATEGORY_ID    = ' + @v_CATEGORY_ID + char(10)
	SELECT @v_pSql += '     AND    KEY_ID         = ' + @v_KEY_ID + char(10)
	SELECT @v_pSql += '     AND    PART_ID        = ' + @v_PART_ID + char(10)
	SELECT @v_pSql += '     AND    KEY_VALUE      = ' + @v_KEY_VALUE + char(10)
	SELECT @v_pSql += '    commit ' + char(10)

	
END
ELSE IF @p_sys_flag = 'UPDATE_MAIN'
BEGIN
	SELECT @v_pSql = ''
	SELECT @v_pSql += '     BEGIN TRAN ' + char(10)
	SELECT @v_pSql += '		UPDATE FP_INSTANCE_CONFIG_M SET  ' + char(10);
	SELECT @v_pSql += '		VALUE_TYPE     = '+ @v_VALUE_TYPE + char(10);

	SELECT @v_pSql += '		,KEY_ID   = '+  @v_key_id + char(10);
	SELECT @v_pSql += '		,PART_ID   = '+  @v_PART_ID + char(10);
	SELECT @v_pSql += '		,KEY_VALUE   = '+  @v_KEY_VALUE + char(10);

	SELECT @v_pSql += '		,OLD_KEY_ID   = '+  @v_key_id + char(10);
	SELECT @v_pSql += '		,OLD_PART_ID   = '+  @v_PART_ID + char(10);
	SELECT @v_pSql += '		,OLD_KEY_VALUE   = '+  @v_KEY_VALUE + char(10);


	IF(LEN(@p_KEY_PRIORITY) > 0 )
	BEGIN 
		SELECT @v_pSql += '		,KEY_PRIORITY   = '+  @p_KEY_PRIORITY + char(10);
	END
	ELSE
	BEGIN
		SELECT @v_pSql += '		,KEY_PRIORITY   = null' + char(10);
	END


	IF(LEN(@p_TOLERANCE) > 0 )
	BEGIN 
		SELECT @v_pSql += '		,TOLERANCE      = '+ @p_TOLERANCE + char(10);
	END
	ELSE
	BEGIN
		SELECT @v_pSql += '		,TOLERANCE      = null' + char(10);
	END

	
	
	SELECT @v_pSql += '		,TOLERANCE_UOM  = '+ @v_TOLERANCE_UOM + char(10);
	SELECT @v_pSql += '		,VIEW_FLAG      = ' + @v_VIEW_FLAG + char(10);
	SELECT @v_pSql += '		,USE_YN      = ' + @v_USE_YN + char(10);
	SELECT @v_pSql += '		,DESCRIPTION    = ' + @v_DESCRIPTION+ char(10);
	SELECT @v_pSql += '		,UPDATE_ID      = ' + @v_user_id +char(10);
	SELECT @v_pSql += '		,UPDATE_TIME    = dbo.sysdate1()' +  char(10);
	SELECT @v_pSql += '		WHERE  CONFIG_SET_ID  = ' + @v_CONFIG_SET_ID + char(10);
	SELECT @v_pSql += '		AND    INSTANCE_ID    = ' + @v_instance_id  + char(10);
	SELECT @v_pSql += '		AND    CATEGORY_ID    = ' + @v_category_id + char(10);
	SELECT @v_pSql += '		AND    KEY_ID         = ' + @v_OLD_key_id + char(10);
	SELECT @v_pSql += '		AND    PART_ID        = ' + @v_OLD_PART_ID + char(10);
	SELECT @v_pSql += '		AND    KEY_VALUE      = ' + @v_OLD_KEY_VALUE + char(10);


	
	SELECT @v_pSql += ' COMMIT ' + char(10)
END

ELSE IF @p_sys_flag = 'SELECT_INSTANCE'
BEGIN
	SELECT @v_pSql += '	SELECT A.INSTANCE_ID AS CODE, A.INSTANCE_ID AS NAME' + char(10);
	SELECT @v_pSql += '	FROM   FP_INSTANCE_CONFIG_M A' + char(10);
	SELECT @v_pSql += '	WHERE  A.CONFIG_SET_ID  = ''LG_CHEM''' + char(10);
	SELECT @v_pSql += '	GROUP BY A.INSTANCE_ID' + char(10);
	SELECT @v_pSql += '	ORDER BY A.INSTANCE_ID' + char(10);
END
ELSE IF @p_sys_flag = 'SELECT_CATEGORY'
BEGIN
	SELECT @v_pSql += '	SELECT A.CATEGORY_ID AS CODE, A.CATEGORY_ID AS NAME' + char(10);
	SELECT @v_pSql += '	FROM   FP_INSTANCE_CONFIG_M A ' + char(10);
	SELECT @v_pSql += '	WHERE  A.CONFIG_SET_ID  = ''LG_CHEM'' ' + char(10);
	SELECT @v_pSql += '	GROUP BY A.CATEGORY_ID' + char(10);
	SELECT @v_pSql += '	ORDER BY A.CATEGORY_ID' + char(10);
END


--------------------------------------go------------------------------------------------------------------------------------------------------------------------
IF @p_sys_type = 'SQL'
BEGIN
    -- return SQL Query Source
    select @v_pSql as [QUERY_VALUE]
	--select @v_pSql;
END 
ELSE 
BEGIN
	SET @runstart = GetDate()

	BEGIN TRY
		BEGIN TRAN
		-- run dynamic sql
			exec sp_executesql @v_pSql
		COMMIT TRAN
	END 
		
	TRY
		BEGIN CATCH
			ROLLBACK
			SET @runend = GetDate()
			exec PR_UI_SQL_LOG @v_proc_name,  @p_user_id,'','',@v_pSql,'rollback error',@runstart, @runend
		END CATCH

		SET @runend = GetDate()
	-- Record sql query
	exec PR_UI_SQL_LOG @v_proc_name,  @p_user_id,'','',@v_pSql,'select',@runstart, @runend
END

    
	--IF @p_sys_type <> 'SQL'
	--SELECT 'SUCCESS' AS result_code,  @max_loop_cnt AS result_cnt	

END

