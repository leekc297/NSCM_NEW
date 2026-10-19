CREATE   PROCEDURE dbo.PR_ETL_CREATE_TABLE
    @p_database sysname = NULL,
    @p_schema   sysname,
    @p_table_name sysname,
    @p_columns_ddl nvarchar(max)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @full nvarchar(400) = QUOTENAME(@p_schema)+N'.'+QUOTENAME(@p_table_name);
    IF OBJECT_ID(@full,'U') IS NULL
    BEGIN
        DECLARE @sql nvarchar(max) = N'CREATE TABLE '+@full+N' ('+@p_columns_ddl+N')';
        EXEC sp_executesql @sql;
    END
END