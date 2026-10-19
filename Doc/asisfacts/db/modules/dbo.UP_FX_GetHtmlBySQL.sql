/*
 * Program ID   : UP_FX_GetHtmlBySQL
 * Description  : SQL 쿼리 결과를 HTML로 변환 해서 리턴한다
 * Program History
 *===================================================================================================
 * Date         In Charge       Description
 *===================================================================================================
   2023/11/24   chaan           V1.1.1  Initialize
 */


--CREATE PROCEDURE [dbo].[UP_FX_GetHtmlBySQL]
CREATE PROCEDURE [dbo].[UP_FX_GetHtmlBySQL]
(
      @p_sql					NVARCHAR(MAX)     = N''
    , @p_header_col_pre         NVARCHAR(MAX)     = N'COLUMN'
    , @p_data_col_pre           NVARCHAR(MAX)     = N'SEGMENT'
    , @p_html                   NVARCHAR(MAX)     = N''         OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;


    --DECLARE @p_header_col_pre           NVARCHAR(MAX) = N'COLUMN';
    --DECLARE @p_data_col_pre             NVARCHAR(MAX) = N'SEGMENT';
    --DECLARE @p_html                     NVARCHAR(MAX) = N'';

    --DECLARE @p_sql					    NVARCHAR(MAX) = N'
    --    SELECT TOP 100 PERCENT
    --              ''''                                AS USER_ID
    --            , ''''                                AS USER_NAME
    --            , ''''                                AS MOBILE_PHONE
    --            , ''''                                AS EMAIL_ADDR
    --            , ''KO''                              AS LANGUAGE_CODE
    --            , ''Production Model''                AS COLUMN1
    --            , ''Cell Nickname''                   AS COLUMN2
    --            , ''Replacement  code''               AS COLUMN3
    --            , ''Product level1''                  AS COLUMN4
    --            , ''Product level2''                  AS COLUMN5
    --            , ''Product level3''                  AS COLUMN6
    --            , ''GPLM Cell Conversion factor''     AS COLUMN7
    --            , ''Discontinuation of SCP''          AS COLUMN8
    --            , ''Prototype''                       AS COLUMN9
    --            , ''Biz Type''                        AS COLUMN10
    --            , ''End Customer''                    AS COLUMN11
    --            , ''Marketing department''            AS COLUMN12
    --            , ''ID''                              AS COLUMN13
    --            , ''Name''                            AS COLUMN14
    --            , ITEM_ID                           AS SEGMENT1
    --            , GROUP_CODE1                       AS SEGMENT2
    --            , LEVEL2_CODE                       AS SEGMENT3
    --            , GROUP_CODE6                       AS SEGMENT4
    --            , GROUP_CODE7                       AS SEGMENT5
    --            , GROUP_CODE5                       AS SEGMENT6
    --            , CELL_CF                           AS SEGMENT7
    --            , ATTRIBUTE7                        AS SEGMENT8
    --            , STATUS_PROTOTYPE                  AS SEGMENT9
    --            , BASIC_FINISHED_PRODUCT            AS SEGMENT10
    --            , BASIC_END_CUSTOMER                AS SEGMENT11
    --            , MKT_DEPT                          AS SEGMENT12
    --            , PIC_ID                            AS SEGMENT13
    --            , PIC_NAME                          AS SEGMENT14
    --    FROM    dbo.FN_SCP0080_GET_GROUP_CODE_MANAGEMENT_TABLE
    --            (
    --                  ''81''
    --                , ''''
    --                , ''''
    --                , ''''
    --                , ''N''
    --                , ''N''
    --                , ''N''
    --                , ''N''
    --                , ''''
    --                , ''F''
    --            )
    --    WHERE   1=1
    --        AND STATUS_MASS = ''Y''
    --        AND (   
    --               GROUP_CODE1        = ''''  --81:GROUP_CODE1, 82:GROUP_CODE8
    --            OR ATTRIBUTE7         = ''Y'' --Discontinuation of SCP
    --            OR STATUS_PROTOTYPE   = ''Y'' --Prototype
    --            )
    --    ORDER BY ITEM_ID';




    DECLARE @v_sql_whole NVARCHAR(MAX) = N'
        IF OBJECT_ID (N''tempdb..#Tbl_UP_FX_GetHtmlBySQL'', N''U'') IS NOT NULL
		    DROP TABLE #Tbl_UP_FX_GetHtmlBySQL

	    SELECT	*
	    INTO	#Tbl_UP_FX_GetHtmlBySQL
	    FROM	(@p_sql) A

        BEGIN--header begin-------------------------------------------------------------------------------------------------------------------
            DECLARE @v_header_col_values            NVARCHAR(MAX) = '''';
            DECLARE @v_curr_header_col_name         NVARCHAR(MAX) = '''';
            

	        DECLARE CUR_HEADERS CURSOR FOR
	            SELECT  NAME
                FROM    tempdb.sys.columns
	            WHERE   1=1
		            AND OBJECT_ID = OBJECT_ID(''tempdb..#Tbl_UP_FX_GetHtmlBySQL'')
		            AND NAME LIKE ''@p_header_col_pre%''
	            ORDER BY COLUMN_ID

		    OPEN CUR_HEADERS;
		    FETCH NEXT FROM CUR_HEADERS INTO @v_curr_header_col_name

		    WHILE @@FETCH_STATUS = 0
		    BEGIN
                DECLARE @v_curr_sql_header  NVARCHAR(MAX) = N'''';
                DECLARE @v_col_value        NVARCHAR(MAX) = N'''';
    
                SET @v_curr_sql_header = ''SELECT TOP 1 @v_col_value = '' + @v_curr_header_col_name + '' FROM #Tbl_UP_FX_GetHtmlBySQL''

                EXEC sys.sp_executesql @v_curr_sql_header, N''@v_col_value NVARCHAR(MAX) OUTPUT'', @v_col_value=@v_col_value OUTPUT

                SET @v_header_col_values = @v_header_col_values + ''<th style="color: white; background: SlateGray">'' + @v_col_value + ''</th>''

                --print @v_col_value

			    FETCH NEXT FROM CUR_HEADERS INTO @v_curr_header_col_name
		    END
		
		    CLOSE CUR_HEADERS;
		    DEALLOCATE CUR_HEADERS;

	        SET @v_header_col_values = ''<tr>'' + @v_header_col_values + ''</tr>'';
        END--header end-----------------------------------------------------------------------------------------------------------------------


        BEGIN--data begin---------------------------------------------------------------------------------------------------------------------
            DECLARE @v_data_col_values            NVARCHAR(MAX) = '''';

            SELECT  @v_data_col_values = COALESCE(@v_data_col_values + '', '''''''', '', '''') + ''['' + NAME + ''] AS ''''td''''''
            FROM    tempdb.sys.columns 
            WHERE   OBJECT_ID = OBJECT_ID(''tempdb..#Tbl_UP_FX_GetHtmlBySQL'')
		        AND NAME LIKE ''@p_data_col_pre%''
            ORDER BY COLUMN_ID;

            IF LEFT(@v_data_col_values, 2) = '', ''
            BEGIN
                SET @v_data_col_values = SUBSTRING(@v_data_col_values, 3, LEN(@v_data_col_values) - 2);
            END

            SET @v_data_col_values = ''SET @p_html = CAST(( SELECT '' + @v_data_col_values + '' FROM #Tbl_UP_FX_GetHtmlBySQL  FOR XML PATH(''''tr''''), ELEMENTS XSINIL) AS NVARCHAR(MAX))''

            EXEC sys.sp_executesql @v_data_col_values, N''@p_html nvarchar(MAX) OUTPUT'', @p_html=@p_html OUTPUT
        END--data end-------------------------------------------------------------------------------------------------------------------------

        SET @p_html = @v_header_col_values + @p_html;'

    SET @v_sql_whole    = REPLACE(@v_sql_whole, '@p_sql',               @p_sql);
    SET @v_sql_whole    = REPLACE(@v_sql_whole, '@p_header_col_pre',    @p_header_col_pre);
    SET @v_sql_whole    = REPLACE(@v_sql_whole, '@p_data_col_pre',      @p_data_col_pre);

    --exec debug_log @v_sql_whole;return;


    EXEC sys.sp_executesql @v_sql_whole, N'@p_html NVARCHAR(MAX) OUTPUT', @p_html=@p_html OUTPUT

    --exec debug_log @p_html;
END