CREATE   PROCEDURE dbo.PR_ETL_TRUNCATE_TABLE
    @p_database sysname = NULL,
    @p_schema   sysname,
    @p_table_name sysname
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @etl nvarchar(400) = QUOTENAME(@p_schema)+N'.'+QUOTENAME(@p_table_name);
    IF OBJECT_ID(@etl,'U') IS NULL
        THROW 50001, N'ETL staging table not found', 1;
    DECLARE @stgName sysname = CASE WHEN @p_table_name LIKE N'ETL[_]%'
                                    THEN N'STG_'+SUBSTRING(@p_table_name,5,200)
                                    ELSE N'STG_'+@p_table_name END;
    DECLARE @stg nvarchar(400) = QUOTENAME(@p_schema)+N'.'+QUOTENAME(@stgName);
    IF OBJECT_ID(@stg,'U') IS NULL
    BEGIN
        DECLARE @c nvarchar(max) = N'SELECT TOP 0 * INTO '+@stg+N' FROM '+@etl;
        EXEC sp_executesql @c;
    END
    DECLARE @i nvarchar(max) = N'INSERT INTO '+@stg+N' SELECT * FROM '+@etl;
    EXEC sp_executesql @i;
    DECLARE @t nvarchar(max) = N'TRUNCATE TABLE '+@etl;
    EXEC sp_executesql @t;
END