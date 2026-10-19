
CREATE PROCEDURE dbo._parse_col_block_to_ddl
    @proc_name  NVARCHAR(256),
    @temp_name  NVARCHAR(256),
    @temp_type  NVARCHAR(20),
    @col_block  NVARCHAR(MAX),
    @source_tbl NVARCHAR(256),
    @oracle_ddl NVARCHAR(MAX) OUTPUT,
    @col_count  INT OUTPUT
AS
BEGIN
    SET @oracle_ddl = NULL; SET @col_count = 0

    DECLARE @clean NVARCHAR(128) = REPLACE(REPLACE(@temp_name, '#', ''), '@', '')
    DECLARE @gtt NVARCHAR(128) = 'GT_' + UPPER(LEFT(@proc_name, 4)) + '_' + UPPER(@clean)
    IF LEN(@gtt) > 30 SET @gtt = LEFT(@gtt, 30)

    SET @oracle_ddl = 'CREATE GLOBAL TEMPORARY TABLE ' + @gtt + CHAR(10) + '(' + CHAR(10)

    -- 줄바꿈 → 공백, 연속공백 정리
    SET @col_block = REPLACE(REPLACE(@col_block, CHAR(13), ''), CHAR(10), ' ')
    WHILE CHARINDEX('  ', @col_block) > 0
        SET @col_block = REPLACE(@col_block, '  ', ' ')
    SET @col_block = LTRIM(RTRIM(@col_block))

    -- 괄호 깊이 추적하며 콤마 분리
    DECLARE @remaining NVARCHAR(MAX) = @col_block
    DECLARE @one_col NVARCHAR(2000), @depth INT, @i INT, @comma_pos INT, @ch NCHAR(1)

    WHILE LEN(@remaining) > 0
    BEGIN
        SET @depth = 0; SET @comma_pos = 0; SET @i = 1
        WHILE @i <= LEN(@remaining)
        BEGIN
            SET @ch = SUBSTRING(@remaining, @i, 1)
            IF @ch = '(' SET @depth = @depth + 1
            IF @ch = ')' SET @depth = @depth - 1
            IF @ch = ',' AND @depth = 0 BEGIN SET @comma_pos = @i; BREAK END
            SET @i = @i + 1
        END

        IF @comma_pos > 0
        BEGIN
            SET @one_col = LTRIM(RTRIM(SUBSTRING(@remaining, 1, @comma_pos - 1)))
            SET @remaining = LTRIM(SUBSTRING(@remaining, @comma_pos + 1, LEN(@remaining)))
        END
        ELSE
        BEGIN
            SET @one_col = LTRIM(RTRIM(@remaining))
            SET @remaining = ''
        END

        IF @one_col = '' CONTINUE

        -- CONSTRAINT/PRIMARY KEY/INDEX/UNIQUE/CHECK skip
        IF UPPER(LEFT(@one_col, 10)) IN ('CONSTRAINT','PRIMARY KE','UNIQUE IND','INDEX ','CHECK ')
            CONTINUE
        IF UPPER(@one_col) LIKE 'CONSTRAINT%' OR UPPER(@one_col) LIKE 'PRIMARY%'
            OR UPPER(@one_col) LIKE 'INDEX%' OR UPPER(@one_col) LIKE 'UNIQUE%'
            CONTINUE

        -- -- 주석 줄 제거
        IF LEFT(LTRIM(@one_col), 2) = '--' CONTINUE

        -- IDENTITY(...) 제거
        DECLARE @id_pos INT = CHARINDEX('IDENTITY', UPPER(@one_col))
        IF @id_pos > 0
        BEGIN
            DECLARE @id_end INT = CHARINDEX(')', @one_col, @id_pos)
            IF @id_end > 0
                SET @one_col = LEFT(@one_col, @id_pos - 1) + SUBSTRING(@one_col, @id_end + 1, LEN(@one_col))
            ELSE
                SET @one_col = LEFT(@one_col, @id_pos - 1)
        END

        -- DEFAULT 제거
        SET @one_col = CASE WHEN CHARINDEX(' DEFAULT ', UPPER(@one_col)) > 0
            THEN LEFT(@one_col, CHARINDEX(' DEFAULT ', UPPER(@one_col)) - 1)
            ELSE @one_col END

        -- NOT NULL / NULL 제거
        SET @one_col = REPLACE(REPLACE(@one_col, ' NOT NULL', ''), ' not null', '')
        IF UPPER(RIGHT(RTRIM(@one_col), 5)) = ' NULL'
            SET @one_col = LEFT(RTRIM(@one_col), LEN(RTRIM(@one_col)) - 5)
        SET @one_col = LTRIM(RTRIM(@one_col))
        -- 대괄호 제거
        SET @one_col = REPLACE(REPLACE(@one_col, '[', ''), ']', '')

        IF @one_col = '' CONTINUE

        -- 컬럼명/타입 분리
        DECLARE @sp INT = CHARINDEX(' ', @one_col)
        IF @sp = 0 CONTINUE

        DECLARE @col_name NVARCHAR(256) = LEFT(@one_col, @sp - 1)
        DECLARE @type_str NVARCHAR(256) = LTRIM(SUBSTRING(@one_col, @sp + 1, LEN(@one_col)))

        -- MSSQL → Oracle 타입 변환
        DECLARE @base NVARCHAR(50) = @type_str, @size NVARCHAR(50) = ''
        IF CHARINDEX('(', @type_str) > 0
        BEGIN
            SET @base = LTRIM(RTRIM(LEFT(@type_str, CHARINDEX('(', @type_str) - 1)))
            SET @size = SUBSTRING(@type_str, CHARINDEX('(', @type_str), LEN(@type_str))
        END

        DECLARE @o_type NVARCHAR(200) = CASE LOWER(@base)
            WHEN 'int' THEN 'NUMBER(10)' WHEN 'bigint' THEN 'NUMBER(19)'
            WHEN 'smallint' THEN 'NUMBER(5)' WHEN 'tinyint' THEN 'NUMBER(3)'
            WHEN 'bit' THEN 'NUMBER(1)' WHEN 'money' THEN 'NUMBER(19,4)'
            WHEN 'float' THEN 'BINARY_DOUBLE' WHEN 'real' THEN 'BINARY_FLOAT'
            WHEN 'datetime' THEN 'DATE' WHEN 'datetime2' THEN 'TIMESTAMP'
            WHEN 'smalldatetime' THEN 'DATE' WHEN 'date' THEN 'DATE'
            WHEN 'text' THEN 'CLOB' WHEN 'ntext' THEN 'CLOB'
            WHEN 'image' THEN 'BLOB' WHEN 'xml' THEN 'CLOB'
            WHEN 'uniqueidentifier' THEN 'VARCHAR2(36)'
            ELSE NULL
        END

        IF @o_type IS NULL
        BEGIN
            IF LOWER(@base) IN ('varchar','nvarchar')
                SET @o_type = CASE WHEN @size IN ('(max)','(MAX)') THEN 'VARCHAR2(4000 CHAR)'
                    WHEN @size <> '' THEN 'VARCHAR2' + REPLACE(@size, ')', ' CHAR)')
                    ELSE 'VARCHAR2(4000 CHAR)' END
            ELSE IF LOWER(@base) IN ('char','nchar')
                SET @o_type = 'CHAR' + ISNULL(NULLIF(@size,''), '(1)')
            ELSE IF LOWER(@base) IN ('decimal','numeric')
                SET @o_type = 'NUMBER' + ISNULL(NULLIF(@size,''), '')
            ELSE IF LOWER(@base) = 'varbinary'
                SET @o_type = CASE WHEN @size IN ('(max)','(MAX)') THEN 'BLOB'
                    ELSE 'RAW' + ISNULL(NULLIF(@size,''), '(200)') END
            ELSE
                SET @o_type = 'VARCHAR2(4000 CHAR)'
        END

        SET @col_count = @col_count + 1
        IF @col_count > 1 SET @oracle_ddl = @oracle_ddl + ',' + CHAR(10)
        SET @oracle_ddl = @oracle_ddl + '    ' + LEFT(UPPER(@col_name) + SPACE(30), 30) + ' ' + @o_type
    END

    IF @col_count = 0 BEGIN SET @oracle_ddl = NULL; RETURN END

    SET @oracle_ddl = @oracle_ddl + CHAR(10) + ') ON COMMIT PRESERVE ROWS;'
END
