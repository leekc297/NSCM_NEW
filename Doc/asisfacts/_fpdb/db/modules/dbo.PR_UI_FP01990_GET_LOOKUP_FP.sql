

/*
 * Program ID   : FP01990_GET_LOOKUP_FP
 * Description  : FP Lookup Master 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2022/04/21   KSI			   Initial Release : GSCM(FP) LOOK UP 
 *
 */

CREATE PROCEDURE [dbo].[PR_UI_FP01990_GET_LOOKUP_FP]

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

DECLARE @p_lookup_type_code    NVARCHAR(MAX) = ''
DECLARE @p_lookup_group   NVARCHAR(MAX) = ''
DECLARE @p_lookup_description   NVARCHAR(MAX) = ''

DECLARE @p_system_type_code   NVARCHAR(MAX) = ''
DECLARE @p_active_flag		NVARCHAR(100) = ''

DECLARE @p_segment1   NVARCHAR(MAX) = ''
DECLARE @p_segment2   NVARCHAR(MAX) = ''
DECLARE @p_segment3   NVARCHAR(MAX) = ''
DECLARE @p_segment4   NVARCHAR(MAX) = ''
DECLARE @p_segment5   NVARCHAR(MAX) = ''

DECLARE @p_segment1_key   NVARCHAR(MAX) = ''
DECLARE @p_segment2_key   NVARCHAR(MAX) = ''
DECLARE @p_segment3_key   NVARCHAR(MAX) = ''
DECLARE @p_segment4_key   NVARCHAR(MAX) = ''
DECLARE @p_segment5_key   NVARCHAR(MAX) = ''


DECLARE @p_ATTRIBUTE1   NVARCHAR(MAX) = ''
DECLARE @p_ATTRIBUTE2   NVARCHAR(MAX) = ''
DECLARE @p_ATTRIBUTE3   NVARCHAR(MAX) = ''
DECLARE @p_ATTRIBUTE4   NVARCHAR(MAX) = ''
DECLARE @p_ATTRIBUTE5   NVARCHAR(MAX) = ''
DECLARE @p_ATTRIBUTE6   NVARCHAR(MAX) = ''
DECLARE @p_ATTRIBUTE7   NVARCHAR(MAX) = ''
DECLARE @p_ATTRIBUTE8   NVARCHAR(MAX) = ''
DECLARE @p_ATTRIBUTE9   NVARCHAR(MAX) = ''
DECLARE @p_ATTRIBUTE10   NVARCHAR(MAX) = ''
DECLARE @p_ATTRIBUTE11   NVARCHAR(MAX) = ''
DECLARE @p_ATTRIBUTE12   NVARCHAR(MAX) = ''
DECLARE @p_ATTRIBUTE13   NVARCHAR(MAX) = ''
DECLARE @p_ATTRIBUTE14   NVARCHAR(MAX) = ''
DECLARE @p_ATTRIBUTE15   NVARCHAR(MAX) = ''

DECLARE @p_VALUE_DESCRIPTION   NVARCHAR(MAX) = ''
DECLARE @p_SORT_ORDER   NVARCHAR(MAX) = ''


DECLARE @v_lookup_type_code     NVARCHAR(MAX) = ''
DECLARE @v_lookup_group			NVARCHAR(MAX) = ''
DECLARE @v_lookup_description   NVARCHAR(MAX) = ''
DECLARE @v_system_type_code     NVARCHAR(MAX) = ''

DECLARE @v_active_flag		    NVARCHAR(100) = ''

DECLARE @v_segment1				NVARCHAR(MAX) = ''
DECLARE @v_segment2				NVARCHAR(MAX) = ''
DECLARE @v_segment3				NVARCHAR(MAX) = ''
DECLARE @v_segment4				NVARCHAR(MAX) = ''
DECLARE @v_segment5				NVARCHAR(MAX) = ''

DECLARE @v_segment1_key			NVARCHAR(MAX) = ''
DECLARE @v_segment2_key			NVARCHAR(MAX) = ''
DECLARE @v_segment3_key			NVARCHAR(MAX) = ''
DECLARE @v_segment4_key			NVARCHAR(MAX) = ''
DECLARE @v_segment5_key			NVARCHAR(MAX) = ''

DECLARE @v_ATTRIBUTE1			NVARCHAR(MAX) = ''
DECLARE @v_ATTRIBUTE2			NVARCHAR(MAX) = ''
DECLARE @v_ATTRIBUTE3			NVARCHAR(MAX) = ''
DECLARE @v_ATTRIBUTE4			NVARCHAR(MAX) = ''
DECLARE @v_ATTRIBUTE5			NVARCHAR(MAX) = ''
DECLARE @v_ATTRIBUTE6			NVARCHAR(MAX) = ''
DECLARE @v_ATTRIBUTE7			NVARCHAR(MAX) = ''
DECLARE @v_ATTRIBUTE8			NVARCHAR(MAX) = ''
DECLARE @v_ATTRIBUTE9			NVARCHAR(MAX) = ''
DECLARE @v_ATTRIBUTE10			NVARCHAR(MAX) = ''
DECLARE @v_ATTRIBUTE11			NVARCHAR(MAX) = ''
DECLARE @v_ATTRIBUTE12			NVARCHAR(MAX) = ''
DECLARE @v_ATTRIBUTE13			NVARCHAR(MAX) = ''
DECLARE @v_ATTRIBUTE14			NVARCHAR(MAX) = ''
DECLARE @v_ATTRIBUTE15			NVARCHAR(MAX) = ''

DECLARE @v_VALUE_DESCRIPTION    NVARCHAR(MAX) = ''
DECLARE @v_SORT_ORDER           NVARCHAR(MAX) = ''

DECLARE @v_pSql                 NVARCHAR(MAX) =''


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
DECLARE @v_proc_name       NVARCHAR(100) = 'PR_UI_FP01990_GET_LOOKUP_FP'

--DECLARE @v_dSql                 NVARCHAR(MAX)=''

SET @v_delimiter            = '^'  
SET @v_sub_delimiter        = '|'  
SET @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@in_columns, @v_delimiter) 	

--print @in_row;


WHILE @mst_loop_cnt < @max_loop_cnt
BEGIN --START WHILE
    SET @mst_loop_cnt = @mst_loop_cnt + 1;        
    SET @tmp_column   = [dbo].[SCM_ARR_SPL_VAL]( @in_columns, @v_delimiter, @mst_loop_cnt);

    IF @tmp_column = 'LOOKUP_TYPE_CODE' 
    BEGIN
        SET @p_lookup_type_code =  [dbo].[SCM_ARR_SPL_VAL]( @in_row        ,@v_delimiter, @mst_loop_cnt);			
    END 
	ELSE IF @tmp_column = 'LOOKUP_DESCRIPTION' 
    BEGIN
        SET @p_lookup_description =  [dbo].[SCM_ARR_SPL_VAL]( @in_row        ,@v_delimiter, @mst_loop_cnt);			
    END 
    ELSE IF @tmp_column = 'LOOKUP_GROUP' 
    BEGIN
        SET @p_lookup_group =  [dbo].[SCM_ARR_SPL_VAL]( @in_row    ,@v_delimiter, @mst_loop_cnt);
    END 
	ELSE IF @tmp_column = 'SYSTEM_TYPE_CODE' 
    BEGIN
        SET @p_system_type_code =  [dbo].[SCM_ARR_SPL_VAL]( @in_row    ,@v_delimiter, @mst_loop_cnt);
    END 
	ELSE IF @tmp_column = 'ACTIVE_FLAG' 
    BEGIN
        SET @p_active_flag =  [dbo].[SCM_ARR_SPL_VAL]( @in_row    ,@v_delimiter, @mst_loop_cnt);
    END 
	ELSE IF @tmp_column = 'SEGMENT1' 
    BEGIN
        SET @p_segment1 =  [dbo].[SCM_ARR_SPL_VAL]( @in_row    ,@v_delimiter, @mst_loop_cnt);
    END 
	ELSE IF @tmp_column = 'SEGMENT2' 
    BEGIN
        SET @p_segment2 =  [dbo].[SCM_ARR_SPL_VAL]( @in_row    ,@v_delimiter, @mst_loop_cnt);
    END 
	ELSE IF @tmp_column = 'SEGMENT3' 
    BEGIN
        SET @p_segment3 =  [dbo].[SCM_ARR_SPL_VAL]( @in_row    ,@v_delimiter, @mst_loop_cnt);
    END 
	ELSE IF @tmp_column = 'SEGMENT4' 
    BEGIN
        SET @p_segment4 =  [dbo].[SCM_ARR_SPL_VAL]( @in_row    ,@v_delimiter, @mst_loop_cnt);
    END 
	ELSE IF @tmp_column = 'SEGMENT5' 
    BEGIN
        SET @p_segment5 =  [dbo].[SCM_ARR_SPL_VAL]( @in_row    ,@v_delimiter, @mst_loop_cnt);
    END 

	ELSE IF @tmp_column = 'SEGMENT1_KEY' 
    BEGIN
        SET @p_segment1_key =  [dbo].[SCM_ARR_SPL_VAL]( @in_row    ,@v_delimiter, @mst_loop_cnt);
    END 
	ELSE IF @tmp_column = 'SEGMENT2_KEY' 
    BEGIN
        SET @p_segment2_key =  [dbo].[SCM_ARR_SPL_VAL]( @in_row    ,@v_delimiter, @mst_loop_cnt);
    END 
	ELSE IF @tmp_column = 'SEGMENT3_KEY' 
    BEGIN
        SET @p_segment3_key =  [dbo].[SCM_ARR_SPL_VAL]( @in_row    ,@v_delimiter, @mst_loop_cnt);
    END 
	ELSE IF @tmp_column = 'SEGMENT4_KEY' 
    BEGIN
        SET @p_segment4_key =  [dbo].[SCM_ARR_SPL_VAL]( @in_row    ,@v_delimiter, @mst_loop_cnt);
    END 
	ELSE IF @tmp_column = 'SEGMENT5_KEY' 
    BEGIN
        SET @p_segment5_key =  [dbo].[SCM_ARR_SPL_VAL]( @in_row    ,@v_delimiter, @mst_loop_cnt);
    END 


	ELSE IF @tmp_column = 'ATTRIBUTE1' 
    BEGIN
        SET @p_ATTRIBUTE1 =  [dbo].[SCM_ARR_SPL_VAL]( @in_row    ,@v_delimiter, @mst_loop_cnt);
    END 
	ELSE IF @tmp_column = 'ATTRIBUTE2' 
    BEGIN
        SET @p_ATTRIBUTE2 =  [dbo].[SCM_ARR_SPL_VAL]( @in_row    ,@v_delimiter, @mst_loop_cnt);
    END 	
	ELSE IF @tmp_column = 'ATTRIBUTE3' 
    BEGIN
        SET @p_ATTRIBUTE3 =  [dbo].[SCM_ARR_SPL_VAL]( @in_row    ,@v_delimiter, @mst_loop_cnt);
    END 	
	ELSE IF @tmp_column = 'ATTRIBUTE4' 
    BEGIN
        SET @p_ATTRIBUTE4 =  [dbo].[SCM_ARR_SPL_VAL]( @in_row    ,@v_delimiter, @mst_loop_cnt);
    END 
	ELSE IF @tmp_column = 'ATTRIBUTE5' 
    BEGIN
        SET @p_ATTRIBUTE5 =  [dbo].[SCM_ARR_SPL_VAL]( @in_row    ,@v_delimiter, @mst_loop_cnt);
    END 	
	ELSE IF @tmp_column = 'ATTRIBUTE6' 
    BEGIN
        SET @p_ATTRIBUTE6 =  [dbo].[SCM_ARR_SPL_VAL]( @in_row    ,@v_delimiter, @mst_loop_cnt);
    END 	

	ELSE IF @tmp_column = 'ATTRIBUTE7' 
    BEGIN
        SET @p_ATTRIBUTE7 =  [dbo].[SCM_ARR_SPL_VAL]( @in_row    ,@v_delimiter, @mst_loop_cnt);
    END 
	ELSE IF @tmp_column = 'ATTRIBUTE8' 
    BEGIN
        SET @p_ATTRIBUTE8 =  [dbo].[SCM_ARR_SPL_VAL]( @in_row    ,@v_delimiter, @mst_loop_cnt);
    END 	
	ELSE IF @tmp_column = 'ATTRIBUTE9' 
    BEGIN
        SET @p_ATTRIBUTE9 =  [dbo].[SCM_ARR_SPL_VAL]( @in_row    ,@v_delimiter, @mst_loop_cnt);
    END 	

	ELSE IF @tmp_column = 'ATTRIBUTE10' 
    BEGIN
        SET @p_ATTRIBUTE10 =  [dbo].[SCM_ARR_SPL_VAL]( @in_row    ,@v_delimiter, @mst_loop_cnt);
    END 
	ELSE IF @tmp_column = 'ATTRIBUTE11' 
    BEGIN
        SET @p_ATTRIBUTE11 =  [dbo].[SCM_ARR_SPL_VAL]( @in_row    ,@v_delimiter, @mst_loop_cnt);
    END 	
	ELSE IF @tmp_column = 'ATTRIBUTE12' 
    BEGIN
        SET @p_ATTRIBUTE12 =  [dbo].[SCM_ARR_SPL_VAL]( @in_row    ,@v_delimiter, @mst_loop_cnt);
    END 	

	ELSE IF @tmp_column = 'ATTRIBUTE13' 
    BEGIN
        SET @p_ATTRIBUTE13 =  [dbo].[SCM_ARR_SPL_VAL]( @in_row    ,@v_delimiter, @mst_loop_cnt);
    END 
	ELSE IF @tmp_column = 'ATTRIBUTE14' 
    BEGIN
        SET @p_ATTRIBUTE14 =  [dbo].[SCM_ARR_SPL_VAL]( @in_row    ,@v_delimiter, @mst_loop_cnt);
    END 	
	ELSE IF @tmp_column = 'ATTRIBUTE15' 
    BEGIN
        SET @p_ATTRIBUTE15 =  [dbo].[SCM_ARR_SPL_VAL]( @in_row    ,@v_delimiter, @mst_loop_cnt);
    END 
	ELSE IF @tmp_column = 'SORT_ORDER' 
    BEGIN
        SET @p_SORT_ORDER =  [dbo].[SCM_ARR_SPL_VAL]( @in_row    ,@v_delimiter, @mst_loop_cnt);
    END 
	ELSE IF @tmp_column = 'VALUE_DESCRIPTION' 
    BEGIN
        SET @p_VALUE_DESCRIPTION =  [dbo].[SCM_ARR_SPL_VAL]( @in_row    ,@v_delimiter, @mst_loop_cnt);
    END 

END

BEGIN 
       SELECT @v_lookup_type_code      = '''' + @p_lookup_type_code + ''''      , @v_lookup_group    = '''' + @p_lookup_group + ''''
            , @v_system_type_code      = '''' + @p_system_type_code + ''''      , @v_active_flag     = '''' + @p_active_flag + ''''
            , @v_segment1              = '''' + @p_segment1 + ''''              , @v_segment2        = '''' + @p_segment2 + ''''
            , @v_segment3              = '''' + @p_segment3 + ''''              , @v_segment4        = '''' + @p_segment4 + ''''
            , @v_segment5              = '''' + @p_segment5 + ''''				, @v_user_id        = '''' + @p_user_id + ''''
			, @v_lookup_description              = '''' + @p_lookup_description + ''''	

			, @v_VALUE_DESCRIPTION       = '''' + @p_VALUE_DESCRIPTION + ''''	
			, @v_SORT_ORDER              = '''' + @p_SORT_ORDER + ''''	

			, @v_ATTRIBUTE1              = '''' + @p_ATTRIBUTE1 + ''''				, @v_ATTRIBUTE2        = '''' + @p_ATTRIBUTE2 + ''''
			, @v_ATTRIBUTE3              = '''' + @p_ATTRIBUTE3 + ''''				, @v_ATTRIBUTE4        = '''' + @p_ATTRIBUTE4 + ''''
			, @v_ATTRIBUTE5              = '''' + @p_ATTRIBUTE5 + ''''				, @v_ATTRIBUTE6        = '''' + @p_ATTRIBUTE6 + ''''
			, @v_ATTRIBUTE7              = '''' + @p_ATTRIBUTE7 + ''''				, @v_ATTRIBUTE8        = '''' + @p_ATTRIBUTE8 + ''''
            
			, @v_ATTRIBUTE9              = '''' + @p_ATTRIBUTE9 + ''''				, @v_ATTRIBUTE10        = '''' + @p_ATTRIBUTE10 + ''''
			, @v_ATTRIBUTE11              = '''' + @p_ATTRIBUTE11 + ''''				, @v_ATTRIBUTE12        = '''' + @p_ATTRIBUTE12 + ''''
			, @v_ATTRIBUTE13              = '''' + @p_ATTRIBUTE13 + ''''				, @v_ATTRIBUTE14        = '''' + @p_ATTRIBUTE14 + ''''
			, @v_ATTRIBUTE15              = '''' + @p_ATTRIBUTE15 + ''''		
			
			, @v_segment1_key              = '''' + @p_segment1_key + ''''				, @v_segment2_key        = '''' + @p_segment2_key + ''''
			, @v_segment3_key              = '''' + @p_segment3_key + ''''				, @v_segment4_key        = '''' + @p_segment4_key + ''''
			, @v_segment5_key              = '''' + @p_segment5_key + ''''	

END

IF @p_sys_flag = 'SELECT_MAIN'
BEGIN
	SELECT @v_pSql = ''

    SELECT @v_pSql += '  SELECT A.LOOKUP_TYPE_CODE, A.LOOKUP_TYPE_CODE AS ORG_LOOKUP_TYPE_CODE ' + char(10)
    SELECT @v_pSql += '        ,A.LOOKUP_DESCRIPTION ' + char(10)
    SELECT @v_pSql += '        ,A.SYSTEM_TYPE_CODE ' + char(10)
    SELECT @v_pSql += '        ,A.ACTIVE_FLAG ' + char(10)
    SELECT @v_pSql += '        ,A.SEGMENT1 ' + char(10)
    SELECT @v_pSql += '        ,A.SEGMENT2 ' + char(10)
    SELECT @v_pSql += '        ,A.SEGMENT3 ' + char(10)
    SELECT @v_pSql += '        ,A.SEGMENT4 ' + char(10)
    SELECT @v_pSql += '        ,A.SEGMENT5 ' + char(10)
    SELECT @v_pSql += '        ,A.CREATE_USER_ID ' + char(10)
    SELECT @v_pSql += '        ,CONVERT(VARCHAR, A.CREATE_DATE, 120) AS CREATE_DATE ' + char(10)
    SELECT @v_pSql += '        ,A.MODIFY_USER_ID ' + char(10)
    SELECT @v_pSql += '        ,ISNULL(CONVERT(VARCHAR, A.MODIFY_DATE, 120),CONVERT(VARCHAR, A.CREATE_DATE, 120)) AS MODIFY_DATE ' + char(10)
    SELECT @v_pSql += '        ,A.ATTRIBUTE1 ' + char(10)
    SELECT @v_pSql += '        ,A.ATTRIBUTE2 ' + char(10)
    SELECT @v_pSql += '        ,A.ATTRIBUTE3 ' + char(10)
    SELECT @v_pSql += '        ,A.ATTRIBUTE4	' + char(10)
    SELECT @v_pSql += '        ,A.ATTRIBUTE5	' + char(10)
    SELECT @v_pSql += '        ,A.ATTRIBUTE6	' + char(10)
    SELECT @v_pSql += '        ,A.ATTRIBUTE7	' + char(10)
    SELECT @v_pSql += '        ,A.ATTRIBUTE8	' + char(10)
    SELECT @v_pSql += '        ,A.ATTRIBUTE9	' + char(10)
    SELECT @v_pSql += '        ,A.ATTRIBUTE10	' + char(10)
    SELECT @v_pSql += '        ,A.ATTRIBUTE11	' + char(10)
    SELECT @v_pSql += '        ,A.ATTRIBUTE12	' + char(10)
    SELECT @v_pSql += '        ,A.ATTRIBUTE13	' + char(10)
    SELECT @v_pSql += '        ,A.ATTRIBUTE14	' + char(10)
    SELECT @v_pSql += '        ,A.ATTRIBUTE15	' + char(10)
    SELECT @v_pSql += '  FROM   SCM_SYS_LOOKUP_TYPE_M A  ' + char(10)
    SELECT @v_pSql += '  WHERE  1 = 1  ' + char(10)
	IF(LEN(@p_lookup_type_code) > 0 )
	BEGIN 
		SELECT @v_pSql += '		AND UPPER(A.LOOKUP_TYPE_CODE) LIKE (N''%' + @p_lookup_type_code +  '%'') '+ char(10)
	END
	IF(@p_active_flag <> 'ALL')
	BEGIN
		IF(LEN(@p_active_flag) > 0 )
		BEGIN 
			SELECT @v_pSql += '  AND A.ACTIVE_FLAG =N' + @v_active_flag + char(10)
		END
	END

	
	IF(LEN(@p_segment1) > 0 )
	BEGIN 
		SELECT @v_pSql += '  AND UPPER(A.SEGMENT1) LIKE (N''%' + @p_segment1+ '%'') ' + char(10)
	END
	IF(LEN(@p_segment2) > 0 )
	BEGIN 
		SELECT @v_pSql += '  AND UPPER(A.SEGMENT2) LIKE (N''%' + @p_segment2+ '%'') ' + char(10)
	END
	IF(LEN(@p_segment3) > 0 )
	BEGIN 
		SELECT @v_pSql += '  AND UPPER(A.SEGMENT3) LIKE (N''%' + @p_segment3+ '%'') ' + char(10)
	END
    IF(LEN(@p_segment4) > 0 )
	BEGIN 
		SELECT @v_pSql += '  AND UPPER(A.SEGMENT4) LIKE (N''%' + @p_segment4+ '%'') ' + char(10)
	END
	IF(LEN(@p_segment5) > 0 )
	BEGIN 
		SELECT @v_pSql += '  AND UPPER(A.SEGMENT5) LIKE (N''%' + @p_segment5+ '%'') ' + char(10)
	END

    --SELECT @v_pSql += '  AND UPPER(A.SEGMENT2) LIKE '%' + ISNULL(CAST(UPPER(@p_segment2) AS NVARCHAR(MAX)), '') + '%'   ' + char(10)
    --SELECT @v_pSql += '  AND UPPER(A.SEGMENT3) LIKE '%' + ISNULL(CAST(UPPER(@p_segment3) AS NVARCHAR(MAX)), '') + '%'   ' + char(10)
    --SELECT @v_pSql += '  AND UPPER(A.SEGMENT4) LIKE '%' + ISNULL(CAST(UPPER(@p_segment4) AS NVARCHAR(MAX)), '') + '%'   ' + char(10)
    --SELECT @v_pSql += '  AND UPPER(A.SEGMENT5) LIKE '%' + ISNULL(CAST(UPPER(@p_segment5) AS NVARCHAR(MAX)), '') + '%'   ' + char(10)    
    --SELECT @v_pSql += '  AND A.SYSTEM_TYPE_CODE = @p_system_type_code  ' + char(10)

	SELECT @v_pSql += '  ORDER BY A.LOOKUP_TYPE_CODE, A.SYSTEM_TYPE_CODE    ' + char(10)
END
ELSE IF @p_sys_flag = 'INSERT_MAIN'
BEGIN
	SELECT @v_pSql = ''
	SELECT @v_pSql += '     BEGIN TRAN ' + char(10)
	SELECT @v_pSql += '     INSERT INTO SCM_SYS_LOOKUP_TYPE_M ( ' + char(10)
	SELECT @v_pSql += '     LOOKUP_TYPE_CODE ' + char(10)
	SELECT @v_pSql += '    ,LOOKUP_DESCRIPTION ' + char(10)
	SELECT @v_pSql += '    ,SYSTEM_TYPE_CODE ' + char(10)
	SELECT @v_pSql += '    ,ACTIVE_FLAG ' + char(10)
	SELECT @v_pSql += '    ,SEGMENT1 ' + char(10)
	SELECT @v_pSql += '    ,SEGMENT2 ' + char(10)
	SELECT @v_pSql += '    ,SEGMENT3 ' + char(10)
	SELECT @v_pSql += '    ,SEGMENT4 ' + char(10)
	SELECT @v_pSql += '    ,SEGMENT5 ' + char(10)
	SELECT @v_pSql += '    ,CREATE_USER_ID ' + char(10)
	SELECT @v_pSql += '    ,CREATE_DATE ' + char(10)
	SELECT @v_pSql += '    ,MODIFY_USER_ID ' + char(10)
	SELECT @v_pSql += '    ,MODIFY_DATE ' + char(10)

	
	SELECT @v_pSql += '    ,ATTRIBUTE1 ' + char(10)

	SELECT @v_pSql += '    ,ATTRIBUTE2 ' + char(10)

	SELECT @v_pSql += '    ,ATTRIBUTE3 ' + char(10)

	SELECT @v_pSql += '    ,ATTRIBUTE4 ' + char(10)

	SELECT @v_pSql += '    ,ATTRIBUTE5 ' + char(10)

	SELECT @v_pSql += '    ,ATTRIBUTE6 ' + char(10)

	SELECT @v_pSql += '    ,ATTRIBUTE7 ' + char(10)

	SELECT @v_pSql += '    ,ATTRIBUTE8 ' + char(10)

	SELECT @v_pSql += '    ,ATTRIBUTE9 ' + char(10)

	SELECT @v_pSql += '    ,ATTRIBUTE10 ' + char(10)

	SELECT @v_pSql += '    ,ATTRIBUTE11 ' + char(10)

	SELECT @v_pSql += '    ,ATTRIBUTE12 ' + char(10)

	SELECT @v_pSql += '    ,ATTRIBUTE13 ' + char(10)

	SELECT @v_pSql += '    ,ATTRIBUTE14 ' + char(10)

	SELECT @v_pSql += '    ,ATTRIBUTE15 ' + char(10)

	

	SELECT @v_pSql += ' ) VALUES ( ' + char(10)
	SELECT @v_pSql += '     N'+  @v_lookup_type_code + char(10)
	SELECT @v_pSql += '    ,N'+  @v_lookup_description + char(10)
	SELECT @v_pSql += '    ,N' + @v_system_type_code + char(10)
	SELECT @v_pSql += '    ,N' + @v_active_flag + char(10)
	SELECT @v_pSql += '    ,N' + @v_segment1 + char(10)
	SELECT @v_pSql += '    ,N' + @v_segment2 + char(10)
	SELECT @v_pSql += '    ,N' + @v_segment3 + char(10)
	SELECT @v_pSql += '    ,N' + @v_segment4 + char(10)
	SELECT @v_pSql += '    ,N' + @v_segment5 + char(10)
	SELECT @v_pSql += '    ,N' + @v_user_id + char(10)
	SELECT @v_pSql += '    ,dbo.sysdate1() ' + char(10)
	SELECT @v_pSql += '    ,' + @v_user_id + char(10)
	SELECT @v_pSql += '    ,dbo.sysdate1() ' + char(10)	


	IF(LEN(@p_ATTRIBUTE1) > 0)
	BEGIN
		SELECT @v_pSql += '    ,N'+ @v_ATTRIBUTE1  + char(10)
	END
	ELSE
	BEGIN
		SELECT @v_pSql += '		, NULL' + char(10);
	END

	IF(LEN(@p_ATTRIBUTE2) > 0)
	BEGIN
		SELECT @v_pSql += '    ,N' + @v_ATTRIBUTE2  + char(10)
	END
	ELSE
	BEGIN
		SELECT @v_pSql += '		, NULL' + char(10);
	END

	IF(LEN(@p_ATTRIBUTE3) > 0)
	BEGIN
		SELECT @v_pSql += '    ,N' + @v_ATTRIBUTE3  + char(10)
	END
	ELSE
	BEGIN
		SELECT @v_pSql += '		, NULL' + char(10);
	END

	IF(LEN(@p_ATTRIBUTE4) > 0)
	BEGIN
		SELECT @v_pSql += '    ,N' + @v_ATTRIBUTE4  + char(10)
	END
	ELSE
	BEGIN
		SELECT @v_pSql += '		, NULL' + char(10);
	END

	IF(LEN(@p_ATTRIBUTE5) > 0)
	BEGIN
		SELECT @v_pSql += '    ,N' + @v_ATTRIBUTE5  + char(10)
	END
	ELSE
	BEGIN
		SELECT @v_pSql += '		, NULL' + char(10);
	END

	IF(LEN(@p_ATTRIBUTE6) > 0)
	BEGIN
		SELECT @v_pSql += '    ,N' + @v_ATTRIBUTE6  + char(10)
	END
	ELSE
	BEGIN
		SELECT @v_pSql += '		, NULL' + char(10);
	END

	IF(LEN(@p_ATTRIBUTE7) > 0)
	BEGIN
		SELECT @v_pSql += '    ,N' + @v_ATTRIBUTE7  + char(10)
	END
	ELSE
	BEGIN
		SELECT @v_pSql += '		, NULL' + char(10);
	END

	IF(LEN(@p_ATTRIBUTE8) > 0)
	BEGIN
		SELECT @v_pSql += '    ,N' + @v_ATTRIBUTE8  + char(10)
	END
	ELSE
	BEGIN
		SELECT @v_pSql += '		, NULL' + char(10);
	END

	IF(LEN(@p_ATTRIBUTE9) > 0)
	BEGIN
		SELECT @v_pSql += '    ,N' + @v_ATTRIBUTE9  + char(10)
	END
	ELSE
	BEGIN
		SELECT @v_pSql += '		, NULL' + char(10);
	END

	IF(LEN(@p_ATTRIBUTE10) > 0)
	BEGIN
		SELECT @v_pSql += '    ,N' + @v_ATTRIBUTE10  + char(10)
	END
	ELSE
	BEGIN
		SELECT @v_pSql += '		, NULL' + char(10);
	END

	IF(LEN(@p_ATTRIBUTE11) > 0)
	BEGIN
		SELECT @v_pSql += '    ,N' + @v_ATTRIBUTE11  + char(10)
	END
	ELSE
	BEGIN
		SELECT @v_pSql += '		, NULL' + char(10);
	END

	IF(LEN(@p_ATTRIBUTE12) > 0)
	BEGIN
		SELECT @v_pSql += '    ,N' + @v_ATTRIBUTE12  + char(10)
	END
	ELSE
	BEGIN
		SELECT @v_pSql += '		, NULL' + char(10);
	END

	IF(LEN(@p_ATTRIBUTE13) > 0)
	BEGIN
		SELECT @v_pSql += '    ,N' + @v_ATTRIBUTE13  + char(10)
	END
	ELSE
	BEGIN
		SELECT @v_pSql += '		, NULL' + char(10);
	END

	IF(LEN(@p_ATTRIBUTE14) > 0)
	BEGIN
		SELECT @v_pSql += '    ,N' + @v_ATTRIBUTE14  + char(10)
	END
	ELSE
	BEGIN
		SELECT @v_pSql += '		, NULL' + char(10);
	END

	IF(LEN(@p_ATTRIBUTE15) > 0)
	BEGIN
		SELECT @v_pSql += '    ,N' + @v_ATTRIBUTE15  + char(10)
	END
	ELSE
	BEGIN
		SELECT @v_pSql += '		, NULL' + char(10);
	END


	SELECT @v_pSql += ' ); ' + char(10)
	SELECT @v_pSql += ' COMMIT ' + char(10)
END
ELSE IF @p_sys_flag = 'DELETE_MAIN'
BEGIN
	SELECT @v_pSql = ''
	SELECT @v_pSql += '     BEGIN TRAN ' + char(10)
	SELECT @v_pSql += '     DELETE FROM SCM_SYS_LOOKUP_TYPE_M WHERE' + char(10)
	SELECT @v_pSql += '     LOOKUP_TYPE_CODE ' + char(10)
	SELECT @v_pSql += '    = N' + @v_lookup_type_code + char(10)
	SELECT @v_pSql += ' COMMIT ' + char(10)

	SELECT @v_pSql += '     BEGIN TRAN ' + char(10)
	SELECT @v_pSql += '     DELETE FROM SCM_SYS_LOOKUP_VALUE WHERE' + char(10)
	SELECT @v_pSql += '     LOOKUP_TYPE_CODE ' + char(10)
	SELECT @v_pSql += '    = N' + @v_lookup_type_code + char(10)
	SELECT @v_pSql += ' COMMIT ' + char(10)


END
ELSE IF @p_sys_flag = 'UPDATE_MAIN'
BEGIN
	SELECT @v_pSql = ''
	SELECT @v_pSql += '     BEGIN TRAN ' + char(10)
	SELECT @v_pSql += '		UPDATE SCM_SYS_LOOKUP_TYPE_M SET  ' + char(10);
	SELECT @v_pSql += '		LOOKUP_TYPE_CODE = N' + @v_lookup_type_code  + char(10);
	SELECT @v_pSql += '		,LOOKUP_DESCRIPTION = N' + @v_lookup_description + char(10);
	SELECT @v_pSql += '		,SYSTEM_TYPE_CODE = ' + '''FP''' + char(10);
	SELECT @v_pSql += '		,ACTIVE_FLAG = ' + @v_active_flag + char(10);
	SELECT @v_pSql += '		,SEGMENT1 = N' + @v_segment1 + char(10);
	SELECT @v_pSql += '		,SEGMENT2 = N' + @v_segment2  + char(10);
	SELECT @v_pSql += '		,SEGMENT3 = N' + @v_segment3  + char(10);
	SELECT @v_pSql += '		,SEGMENT4 = N' + @v_segment4  + char(10);
	SELECT @v_pSql += '		,SEGMENT5 = N' + @v_segment5  + char(10);
	
	IF(LEN(@p_ATTRIBUTE1) > 0)
	BEGIN
		SELECT @v_pSql += '		,ATTRIBUTE1 = N' + @v_ATTRIBUTE1  + char(10);
	END
	ELSE
	BEGIN
		SELECT @v_pSql += '		,ATTRIBUTE1 = NULL' + char(10);
	END
	
	IF(LEN(@p_ATTRIBUTE2) > 0)
	BEGIN
		SELECT @v_pSql += '		,ATTRIBUTE2 = N' + @v_ATTRIBUTE2  + char(10);
	END
	ELSE
	BEGIN
		SELECT @v_pSql += '		,ATTRIBUTE2 = NULL' + char(10);
	END
	
	IF(LEN(@p_ATTRIBUTE3) > 0)
	BEGIN
		SELECT @v_pSql += '		,ATTRIBUTE3 = N' + @v_ATTRIBUTE3  + char(10);
	END
	ELSE
	BEGIN
		SELECT @v_pSql += '		,ATTRIBUTE3 = NULL' + char(10);
	END		
	
	IF(LEN(@p_ATTRIBUTE4) > 0)
	BEGIN
		SELECT @v_pSql += '		,ATTRIBUTE4 = N' + @v_ATTRIBUTE4  + char(10);
	END
	ELSE
	BEGIN
		SELECT @v_pSql += '		,ATTRIBUTE4 = NULL' + char(10);
	END	

	IF(LEN(@p_ATTRIBUTE5) > 0)
	BEGIN
		SELECT @v_pSql += '		,ATTRIBUTE5 = N' + @v_ATTRIBUTE5  + char(10);
	END
	ELSE
	BEGIN
		SELECT @v_pSql += '		,ATTRIBUTE5 = NULL' + char(10);
	END

	IF(LEN(@p_ATTRIBUTE6) > 0)
	BEGIN
		SELECT @v_pSql += '		,ATTRIBUTE6 = N' + @v_ATTRIBUTE6  + char(10);
	END
	ELSE
	BEGIN
		SELECT @v_pSql += '		,ATTRIBUTE6 = NULL' + char(10);
	END

	IF(LEN(@p_ATTRIBUTE7) > 0)
	BEGIN
		SELECT @v_pSql += '		,ATTRIBUTE7 = N' + @v_ATTRIBUTE7  + char(10);
	END
	ELSE
	BEGIN
		SELECT @v_pSql += '		,ATTRIBUTE7 = NULL' + char(10);
	END
	
	IF(LEN(@p_ATTRIBUTE8) > 0)
	BEGIN
		SELECT @v_pSql += '		,ATTRIBUTE8 = N' + @v_ATTRIBUTE8  + char(10);
	END
	ELSE
	BEGIN
		SELECT @v_pSql += '		,ATTRIBUTE8 = NULL' + char(10);
	END

	IF(LEN(@p_ATTRIBUTE9) > 0)
	BEGIN
		SELECT @v_pSql += '		,ATTRIBUTE9 = N' + @v_ATTRIBUTE9  + char(10);
	END
	ELSE
	BEGIN
		SELECT @v_pSql += '		,ATTRIBUTE9 = NULL' + char(10);
	END
	
	IF(LEN(@p_ATTRIBUTE10) > 0)
	BEGIN
		SELECT @v_pSql += '		,ATTRIBUTE10 = N' + @v_ATTRIBUTE10  + char(10);
	END
	ELSE
	BEGIN
		SELECT @v_pSql += '		,ATTRIBUTE10 = NULL' + char(10);
	END
	
	IF(LEN(@p_ATTRIBUTE11) > 0)
	BEGIN
		SELECT @v_pSql += '		,ATTRIBUTE11 = N' + @v_ATTRIBUTE11  + char(10);
	END
	ELSE
	BEGIN
		SELECT @v_pSql += '		,ATTRIBUTE11 = NULL' + char(10);
	END
	
	IF(LEN(@p_ATTRIBUTE12) > 0)
	BEGIN
		SELECT @v_pSql += '		,ATTRIBUTE12 = N' + @v_ATTRIBUTE12  + char(10);
	END
	ELSE
	BEGIN
		SELECT @v_pSql += '		,ATTRIBUTE12 = NULL' + char(10);
	END	

	IF(LEN(@p_ATTRIBUTE13) > 0)
	BEGIN
		SELECT @v_pSql += '		,ATTRIBUTE13 = N' + @v_ATTRIBUTE13  + char(10);
	END
	ELSE
	BEGIN
		SELECT @v_pSql += '		,ATTRIBUTE13 = NULL' + char(10);
	END

	
	
	IF(LEN(@p_ATTRIBUTE14) > 0)
	BEGIN
		SELECT @v_pSql += '		,ATTRIBUTE14 = N' + @v_ATTRIBUTE14  + char(10);
	END
	ELSE
	BEGIN
		SELECT @v_pSql += '		,ATTRIBUTE14 = NULL' + char(10);
	END

	IF(LEN(@p_ATTRIBUTE15) > 0)
	BEGIN
		SELECT @v_pSql += '		,ATTRIBUTE15 = N' + @v_ATTRIBUTE15  + char(10);
	END
	ELSE
	BEGIN
		SELECT @v_pSql += '		,ATTRIBUTE15 = NULL' + char(10);
	END



	SELECT @v_pSql += '		,MODIFY_DATE = dbo.SYSDATE1() ' + char(10);
	SELECT @v_pSql += '		,MODIFY_USER_ID = ' + @v_user_id + char(10);
	SELECT @v_pSql += '		WHERE LOOKUP_TYPE_CODE = N' + @v_lookup_type_code + char(10);
	SELECT @v_pSql += ' COMMIT ' + char(10)
END

ELSE IF @p_sys_flag = 'SELECT_MAIN_DETAIL'
BEGIN
	SELECT @v_pSql = ''
	SELECT @v_pSql += ' 	select a.lookup_type_code as LOOKUP_TYPE_CODE																			   ' + char(10)
    SELECT @v_pSql += '         ,a.segment1 as SEGMENT1, a.segment2 as SEGMENT2 ,a.segment3 as SEGMENT3,a.segment4 as SEGMENT4, a.segment5 as SEGMENT5  ' + char(10)
    SELECT @v_pSql += '         ,a.segment1 as SEGMENT1_KEY																		   ' + char(10)
    SELECT @v_pSql += '         ,a.segment2 as SEGMENT2_KEY																		   ' + char(10)
    SELECT @v_pSql += '         ,a.segment3 as SEGMENT3_KEY																		   ' + char(10)
    SELECT @v_pSql += '         ,a.segment4 as SEGMENT4_KEY																		   ' + char(10)
    SELECT @v_pSql += '         ,a.segment5 as SEGMENT5_KEY																		   ' + char(10)
    SELECT @v_pSql += '         ,a.sort_order as SORT_ORDER																					   ' + char(10)
    SELECT @v_pSql += '         ,a.active_flag	as 	ACTIVE_FLAG																			   ' + char(10)
    SELECT @v_pSql += '         ,a.value_description as VALUE_DESCRIPTION																			   ' + char(10)
    SELECT @v_pSql += '         ,a.create_user_id																				   ' + char(10)
    SELECT @v_pSql += '         ,a.create_date																					   ' + char(10)
    SELECT @v_pSql += '         ,a.modify_user_id																				   ' + char(10)
    SELECT @v_pSql += '         ,ISNULL(CONVERT(VARCHAR, A.MODIFY_DATE, 120),CONVERT(VARCHAR, A.CREATE_DATE, 120)) AS MODIFY_DATE  ' + char(10)
    SELECT @v_pSql += '         ,a.attribute1 as ATTRIBUTE1,a.attribute2 as ATTRIBUTE2,a.attribute3 as ATTRIBUTE3,a.attribute4 as ATTRIBUTE4,a.attribute5 as ATTRIBUTE5	' + char(10)
    SELECT @v_pSql += '         ,a.attribute6 as ATTRIBUTE6 ,a.attribute7 as ATTRIBUTE7,a.attribute8 as ATTRIBUTE8,a.attribute9 as ATTRIBUTE9,a.attribute10 as ATTRIBUTE10	' + char(10)
    SELECT @v_pSql += '         ,a.attribute11 as ATTRIBUTE11,a.attribute12 as ATTRIBUTE12,a.attribute13 as ATTRIBUTE13,a.attribute14 as ATTRIBUTE14,a.attribute15  as ATTRIBUTE15	' + char(10)
    SELECT @v_pSql += '         ,a.plant_id																							' + char(10)
    SELECT @v_pSql += '   from   scm_sys_lookup_value a																				' + char(10)
    SELECT @v_pSql += '   where  a.lookup_type_code =N' + @v_lookup_type_code + char(10)
    
    SELECT @v_pSql += '   order by SORT_ORDER,SEGMENT1,SEGMENT2,SEGMENT3,SEGMENT4,SEGMENT5								' + char(10)
END

ELSE IF @p_sys_flag = 'INSERT_MAIN_DETAIL'
BEGIN
	SELECT @v_pSql = ''
	SELECT @v_pSql += '     BEGIN TRAN ' + char(10)
	SELECT @v_pSql += '     INSERT INTO SCM_SYS_LOOKUP_VALUE ( ' + char(10)	
	SELECT @v_pSql += '    LOOKUP_TYPE_CODE ' + char(10)
	SELECT @v_pSql += '    ,SEGMENT1 ' + char(10)
	SELECT @v_pSql += '    ,SEGMENT2 ' + char(10)
	SELECT @v_pSql += '    ,SEGMENT3 ' + char(10)
	SELECT @v_pSql += '    ,SEGMENT4 ' + char(10)
	SELECT @v_pSql += '    ,SEGMENT5 ' + char(10)
	IF(LEN(@p_SORT_ORDER) > 0)
	BEGIN
		SELECT @v_pSql += '    ,SORT_ORDER ' + char(10)
	END
	
	SELECT @v_pSql += '    ,ACTIVE_FLAG ' + char(10)
	SELECT @v_pSql += '    ,VALUE_DESCRIPTION ' + char(10)

	SELECT @v_pSql += '    ,CREATE_USER_ID ' + char(10)
	SELECT @v_pSql += '    ,CREATE_DATE ' + char(10)
	SELECT @v_pSql += '    ,MODIFY_USER_ID ' + char(10)
	SELECT @v_pSql += '    ,MODIFY_DATE ' + char(10)

	SELECT @v_pSql += '    ,ATTRIBUTE1 ' + char(10)

	SELECT @v_pSql += '    ,ATTRIBUTE2 ' + char(10)

	SELECT @v_pSql += '    ,ATTRIBUTE3 ' + char(10)

	SELECT @v_pSql += '    ,ATTRIBUTE4 ' + char(10)

	SELECT @v_pSql += '    ,ATTRIBUTE5 ' + char(10)

	SELECT @v_pSql += '    ,ATTRIBUTE6 ' + char(10)

	SELECT @v_pSql += '    ,ATTRIBUTE7 ' + char(10)

	SELECT @v_pSql += '    ,ATTRIBUTE8 ' + char(10)

	SELECT @v_pSql += '    ,ATTRIBUTE9 ' + char(10)

	SELECT @v_pSql += '    ,ATTRIBUTE10 ' + char(10)

	SELECT @v_pSql += '    ,ATTRIBUTE11 ' + char(10)

	SELECT @v_pSql += '    ,ATTRIBUTE12 ' + char(10)

	SELECT @v_pSql += '    ,ATTRIBUTE13 ' + char(10)

	SELECT @v_pSql += '    ,ATTRIBUTE14 ' + char(10)

	SELECT @v_pSql += '    ,ATTRIBUTE15 ' + char(10)


	--SELECT @v_pSql += '    ,PLANT_ID ' + char(10)
	SELECT @v_pSql += ' ) VALUES ( ' + char(10)
	SELECT @v_pSql += '     N'+  @v_lookup_type_code + char(10)
	SELECT @v_pSql += '    ,N' + @v_segment1 + char(10)
	SELECT @v_pSql += '    ,N' + @v_segment2 + char(10)
	SELECT @v_pSql += '    ,N' + @v_segment3 + char(10)
	SELECT @v_pSql += '    ,N' + @v_segment4 + char(10)
	SELECT @v_pSql += '    ,N' + @v_segment5 + char(10)
	IF(LEN(@p_SORT_ORDER) > 0)
	BEGIN
		SELECT @v_pSql += '    ,N' + @v_SORT_ORDER + char(10)
	END	
	SELECT @v_pSql += '    ,' + @v_active_flag + char(10)

	IF(LEN(@p_VALUE_DESCRIPTION) > 0)
	BEGIN
		SELECT @v_pSql += '    ,N'+  @v_VALUE_DESCRIPTION + char(10)
	END
	ELSE
	BEGIN
		SELECT @v_pSql += '		, NULL' + char(10);
	END
	
	
	
	SELECT @v_pSql += '    ,' + @v_user_id + char(10)
	SELECT @v_pSql += '    ,dbo.sysdate1() ' + char(10)
	SELECT @v_pSql += '    ,' + @v_user_id + char(10)
	SELECT @v_pSql += '    ,dbo.sysdate1() ' + char(10)

	IF(LEN(@p_ATTRIBUTE1) > 0)
	BEGIN
		SELECT @v_pSql += '    ,N'+ @v_ATTRIBUTE1  + char(10)
	END
	ELSE
	BEGIN
		SELECT @v_pSql += '		, NULL' + char(10);
	END


	IF(LEN(@p_ATTRIBUTE2) > 0)
	BEGIN
		SELECT @v_pSql += '    ,N' + @v_ATTRIBUTE2  + char(10)
	END
	ELSE
	BEGIN
		SELECT @v_pSql += '		, NULL' + char(10);
	END

	IF(LEN(@p_ATTRIBUTE3) > 0)
	BEGIN
		SELECT @v_pSql += '    ,N' + @v_ATTRIBUTE3  + char(10)
	END
	ELSE
	BEGIN
		SELECT @v_pSql += '		, NULL' + char(10);
	END


	IF(LEN(@p_ATTRIBUTE4) > 0)
	BEGIN
		SELECT @v_pSql += '    ,N' + @v_ATTRIBUTE4  + char(10)
	END
	ELSE
	BEGIN
		SELECT @v_pSql += '		, NULL' + char(10);
	END


	IF(LEN(@p_ATTRIBUTE5) > 0)
	BEGIN
		SELECT @v_pSql += '    ,N' + @v_ATTRIBUTE5  + char(10)
	END
	ELSE
	BEGIN
		SELECT @v_pSql += '		, NULL' + char(10);
	END

	IF(LEN(@p_ATTRIBUTE6) > 0)
	BEGIN
		SELECT @v_pSql += '    ,N' + @v_ATTRIBUTE6  + char(10)
	END
	ELSE
	BEGIN
		SELECT @v_pSql += '		, NULL' + char(10);
	END


	IF(LEN(@p_ATTRIBUTE7) > 0)
	BEGIN
		SELECT @v_pSql += '    ,N' + @v_ATTRIBUTE7  + char(10)
	END
	ELSE
	BEGIN
		SELECT @v_pSql += '		, NULL' + char(10);
	END


	IF(LEN(@p_ATTRIBUTE8) > 0)
	BEGIN
		SELECT @v_pSql += '    ,N' + @v_ATTRIBUTE8  + char(10)
	END
	ELSE
	BEGIN
		SELECT @v_pSql += '		, NULL' + char(10);
	END

	IF(LEN(@p_ATTRIBUTE9) > 0)
	BEGIN
		SELECT @v_pSql += '    ,N' + @v_ATTRIBUTE9  + char(10)
	END
	ELSE
	BEGIN
		SELECT @v_pSql += '		, NULL' + char(10);
	END

	IF(LEN(@p_ATTRIBUTE10) > 0)
	BEGIN
		SELECT @v_pSql += '    ,N' + @v_ATTRIBUTE10  + char(10)
	END
	ELSE
	BEGIN
		SELECT @v_pSql += '		, NULL' + char(10);
	END


	IF(LEN(@p_ATTRIBUTE11) > 0)
	BEGIN
		SELECT @v_pSql += '    ,N' + @v_ATTRIBUTE11  + char(10)
	END
	ELSE
	BEGIN
		SELECT @v_pSql += '		, NULL' + char(10);
	END


	IF(LEN(@p_ATTRIBUTE12) > 0)
	BEGIN
		SELECT @v_pSql += '    ,N' + @v_ATTRIBUTE12  + char(10)
	END
	ELSE
	BEGIN
		SELECT @v_pSql += '		, NULL' + char(10);
	END


	IF(LEN(@p_ATTRIBUTE13) > 0)
	BEGIN
		SELECT @v_pSql += '    ,N' + @v_ATTRIBUTE13  + char(10)
	END
	ELSE
	BEGIN
		SELECT @v_pSql += '		, NULL' + char(10);
	END


	IF(LEN(@p_ATTRIBUTE14) > 0)
	BEGIN
		SELECT @v_pSql += '    ,N' + @v_ATTRIBUTE14  + char(10)
	END
	ELSE
	BEGIN
		SELECT @v_pSql += '		, NULL' + char(10);
	END


	IF(LEN(@p_ATTRIBUTE15) > 0)
	BEGIN
		SELECT @v_pSql += '    ,N' + @v_ATTRIBUTE15  + char(10)
	END
	ELSE
	BEGIN
		SELECT @v_pSql += '		, NULL' + char(10);
	END	
	
	--SELECT @v_pSql += '    ,#PLANT_ID# ' + char(10)
	SELECT @v_pSql += ' ); ' + char(10)
	SELECT @v_pSql += ' COMMIT ' + char(10)
END

ELSE IF @p_sys_flag = 'UPDATE_MAIN_DETAIL'
BEGIN
	

	SELECT @v_pSql = ''
	SELECT @v_pSql += '     BEGIN TRAN ' + char(10)
	SELECT @v_pSql += '		UPDATE SCM_SYS_LOOKUP_VALUE SET  ' + char(10);
	SELECT @v_pSql += '		MODIFY_USER_ID = ' + @v_user_id + char(10);
	SELECT @v_pSql += '		,MODIFY_DATE = dbo.SYSDATE1() ' + char(10);	
	SELECT @v_pSql += '		,SEGMENT1 = N' + @v_segment1 + char(10);
	SELECT @v_pSql += '		,SEGMENT2 = N' + @v_segment2  + char(10);
	SELECT @v_pSql += '		,SEGMENT3 = N' + @v_segment3  + char(10);	

	SELECT @v_pSql += '		,SEGMENT4 = N' + @v_segment4  + char(10);
	SELECT @v_pSql += '		,SEGMENT5 = N' + @v_segment5  + char(10);



	IF(LEN(@p_ATTRIBUTE1) > 0)
	BEGIN
		SELECT @v_pSql += '		,ATTRIBUTE1 = N' + @v_ATTRIBUTE1  + char(10);
	END
	ELSE
	BEGIN
		SELECT @v_pSql += '		,ATTRIBUTE1 = NULL' + char(10);
	END
	
	IF(LEN(@p_ATTRIBUTE2) > 0)
	BEGIN
		SELECT @v_pSql += '		,ATTRIBUTE2 = N' + @v_ATTRIBUTE2  + char(10);
	END
	ELSE
	BEGIN
		SELECT @v_pSql += '		,ATTRIBUTE2 = NULL' + char(10);
	END
	
	IF(LEN(@p_ATTRIBUTE3) > 0)
	BEGIN
		SELECT @v_pSql += '		,ATTRIBUTE3 = N' + @v_ATTRIBUTE3  + char(10);
	END
	ELSE
	BEGIN
		SELECT @v_pSql += '		,ATTRIBUTE3 = NULL' + char(10);
	END		
	
	IF(LEN(@p_ATTRIBUTE4) > 0)
	BEGIN
		SELECT @v_pSql += '		,ATTRIBUTE4 = N' + @v_ATTRIBUTE4  + char(10);
	END
	ELSE
	BEGIN
		SELECT @v_pSql += '		,ATTRIBUTE4 = NULL' + char(10);
	END	

	IF(LEN(@p_ATTRIBUTE5) > 0)
	BEGIN
		SELECT @v_pSql += '		,ATTRIBUTE5 = N' + @v_ATTRIBUTE5  + char(10);
	END
	ELSE
	BEGIN
		SELECT @v_pSql += '		,ATTRIBUTE5 = NULL' + char(10);
	END

	IF(LEN(@p_ATTRIBUTE6) > 0)
	BEGIN
		SELECT @v_pSql += '		,ATTRIBUTE6 = N' + @v_ATTRIBUTE6  + char(10);
	END
	ELSE
	BEGIN
		SELECT @v_pSql += '		,ATTRIBUTE6 = NULL' + char(10);
	END

	IF(LEN(@p_ATTRIBUTE7) > 0)
	BEGIN
		SELECT @v_pSql += '		,ATTRIBUTE7 = N' + @v_ATTRIBUTE7  + char(10);
	END
	ELSE
	BEGIN
		SELECT @v_pSql += '		,ATTRIBUTE7 = NULL' + char(10);
	END
	
	IF(LEN(@p_ATTRIBUTE8) > 0)
	BEGIN
		SELECT @v_pSql += '		,ATTRIBUTE8 = N' + @v_ATTRIBUTE8  + char(10);
	END
	ELSE
	BEGIN
		SELECT @v_pSql += '		,ATTRIBUTE8 = NULL' + char(10);
	END

	IF(LEN(@p_ATTRIBUTE9) > 0)
	BEGIN
		SELECT @v_pSql += '		,ATTRIBUTE9 = N' + @v_ATTRIBUTE9  + char(10);
	END
	ELSE
	BEGIN
		SELECT @v_pSql += '		,ATTRIBUTE9 = NULL' + char(10);
	END
	
	IF(LEN(@p_ATTRIBUTE10) > 0)
	BEGIN
		SELECT @v_pSql += '		,ATTRIBUTE10 = N' + @v_ATTRIBUTE10  + char(10);
	END
	ELSE
	BEGIN
		SELECT @v_pSql += '		,ATTRIBUTE10 = NULL' + char(10);
	END
	
	IF(LEN(@p_ATTRIBUTE11) > 0)
	BEGIN
		SELECT @v_pSql += '		,ATTRIBUTE11 = N' + @v_ATTRIBUTE11  + char(10);
	END
	ELSE
	BEGIN
		SELECT @v_pSql += '		,ATTRIBUTE11 = NULL' + char(10);
	END
	
	IF(LEN(@p_ATTRIBUTE12) > 0)
	BEGIN
		SELECT @v_pSql += '		,ATTRIBUTE12 = N' + @v_ATTRIBUTE12  + char(10);
	END
	ELSE
	BEGIN
		SELECT @v_pSql += '		,ATTRIBUTE12 = NULL' + char(10);
	END	

	IF(LEN(@p_ATTRIBUTE13) > 0)
	BEGIN
		SELECT @v_pSql += '		,ATTRIBUTE13 = N' + @v_ATTRIBUTE13  + char(10);
	END
	ELSE
	BEGIN
		SELECT @v_pSql += '		,ATTRIBUTE13 = NULL' + char(10);
	END

	
	
	IF(LEN(@p_ATTRIBUTE14) > 0)
	BEGIN
		SELECT @v_pSql += '		,ATTRIBUTE14 = N' + @v_ATTRIBUTE14  + char(10);
	END
	ELSE
	BEGIN
		SELECT @v_pSql += '		,ATTRIBUTE14 = NULL' + char(10);
	END

	IF(LEN(@p_ATTRIBUTE15) > 0)
	BEGIN
		SELECT @v_pSql += '		,ATTRIBUTE15 = N' + @v_ATTRIBUTE15  + char(10);
	END
	ELSE
	BEGIN
		SELECT @v_pSql += '		,ATTRIBUTE15 = NULL' + char(10);
	END


	
	IF(LEN(@p_active_flag) > 0)
	BEGIN
		SELECT @v_pSql += '		,ACTIVE_FLAG = ' + @v_active_flag + char(10);
	END
	
	IF(LEN(@p_VALUE_DESCRIPTION) > 0)
	BEGIN
		SELECT @v_pSql += '		,VALUE_DESCRIPTION = N' + @v_VALUE_DESCRIPTION + char(10);
	END
	ELSE
	BEGIN
		SELECT @v_pSql += '		,VALUE_DESCRIPTION = NULL' + char(10);
	END

	

	IF(LEN(@p_SORT_ORDER) > 0)
	BEGIN
		SELECT @v_pSql += '		,SORT_ORDER = ' + @p_SORT_ORDER + char(10);
	END
	ELSE
	BEGIN
		SELECT @v_pSql += '		,SORT_ORDER = null' + char(10);
	END

	SELECT @v_pSql += '		WHERE LOOKUP_TYPE_CODE = N' + @v_lookup_type_code + char(10);

	IF(LEN(@p_segment1_key) > 0)
	BEGIN
		SELECT @v_pSql += '		AND  SEGMENT1 = N' + @v_segment1_key + char(10);
	END
	
	IF(LEN(@p_segment2_key) > 0)
	BEGIN
		SELECT @v_pSql += '		AND  SEGMENT2 = N' + @v_segment2_key + char(10);
	END

	IF(LEN(@p_segment3_key) > 0)
	BEGIN
		SELECT @v_pSql += '		AND  SEGMENT3 = N' + @v_segment3_key + char(10);
	END

	IF(LEN(@p_segment4_key) > 0)
	BEGIN
		SELECT @v_pSql += '		AND  SEGMENT4 = N' + @v_segment4_key + char(10);
	END

	IF(LEN(@p_segment5_key) > 0)
	BEGIN
		SELECT @v_pSql += '		AND  SEGMENT5 = N' + @v_segment5_key + char(10);
	END

	
	
	
	
	

	SELECT @v_pSql += ' COMMIT ' + char(10)
END

ELSE IF @p_sys_flag = 'DELETE_MAIN_DETAIL'
BEGIN
	SELECT @v_pSql = ''
	SELECT @v_pSql += '     BEGIN TRAN ' + char(10)
	SELECT @v_pSql += '     DELETE FROM SCM_SYS_LOOKUP_VALUE WHERE' + char(10)
	SELECT @v_pSql += '     LOOKUP_TYPE_CODE ' + char(10)
	SELECT @v_pSql += '    = N' + @v_lookup_type_code + char(10)
	SELECT @v_pSql += '		AND  SEGMENT1 = N' + @v_segment1 + char(10);
	SELECT @v_pSql += '		AND  SEGMENT2 = N' + @v_segment2 + char(10);
	SELECT @v_pSql += '		AND  SEGMENT3 = N' + @v_segment3 + char(10);
	SELECT @v_pSql += '		AND  SEGMENT4 = N' + @v_segment4 + char(10);
	SELECT @v_pSql += '		AND  SEGMENT5 = N' + @v_segment5 + char(10);

	SELECT @v_pSql += ' COMMIT ' + char(10)
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

    
END

