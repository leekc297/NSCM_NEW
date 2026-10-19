
CREATE PROCEDURE dbo.PR_EXTRACT_TEMP_TABLE_DDL
    @p_proc_name NVARCHAR(256) = NULL
AS
BEGIN
    SET NOCOUNT ON

    -- ============================================================
    -- 기존 결과 정리
    -- ============================================================
    IF @p_proc_name IS NULL
        TRUNCATE TABLE dbo.SCM_CONV_GTT_DDL
    ELSE
        DELETE FROM dbo.SCM_CONV_GTT_DDL WHERE PROC_NAME LIKE @p_proc_name

    -- ============================================================
    -- 대상 프로시저 루프
    -- ============================================================
    DECLARE @cur_proc NVARCHAR(256), @src NVARCHAR(MAX)

    DECLARE proc_cur CURSOR LOCAL FAST_FORWARD FOR
        SELECT o.name, m.definition
        FROM sys.sql_modules m
        JOIN sys.objects o ON m.object_id = o.object_id
        WHERE o.type IN ('P','FN','IF','TF')
          AND m.definition IS NOT NULL
          AND (@p_proc_name IS NULL OR o.name LIKE @p_proc_name)
        ORDER BY o.name

    OPEN proc_cur
    FETCH NEXT FROM proc_cur INTO @cur_proc, @src

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- ========================================================
        -- 1) CREATE TABLE #xxx (...) 파싱
        -- ========================================================
        DECLARE @pos INT = 1, @hash_pos INT, @name_end INT, @paren_start INT
        DECLARE @depth INT, @end_pos INT
        DECLARE @temp_name NVARCHAR(256), @col_block NVARCHAR(MAX)

        WHILE 1=1
        BEGIN
            SET @pos = CHARINDEX('CREATE TABLE #', @src, @pos)
            IF @pos = 0 BREAK

            SET @hash_pos = CHARINDEX('#', @src, @pos)
            SET @name_end = @hash_pos + 1
            WHILE @name_end <= LEN(@src) AND SUBSTRING(@src, @name_end, 1) LIKE '[A-Za-z0-9_]'
                SET @name_end = @name_end + 1
            SET @temp_name = SUBSTRING(@src, @hash_pos, @name_end - @hash_pos)

            SET @paren_start = CHARINDEX('(', @src, @name_end)
            IF @paren_start = 0 OR @paren_start - @name_end > 50 BEGIN SET @pos = @name_end; CONTINUE END

            SET @depth = 1; SET @end_pos = @paren_start + 1
            WHILE @end_pos <= LEN(@src) AND @depth > 0
            BEGIN
                IF SUBSTRING(@src, @end_pos, 1) = '(' SET @depth = @depth + 1
                IF SUBSTRING(@src, @end_pos, 1) = ')' SET @depth = @depth - 1
                SET @end_pos = @end_pos + 1
            END

            SET @col_block = SUBSTRING(@src, @paren_start + 1, @end_pos - @paren_start - 2)

            -- 중복 체크 (같은 이름 skip)
            IF NOT EXISTS (SELECT 1 FROM dbo.SCM_CONV_GTT_DDL WHERE PROC_NAME = @cur_proc AND TEMP_NAME = @temp_name)
            BEGIN
                DECLARE @ddl1 NVARCHAR(MAX), @cnt1 INT
                EXEC dbo._parse_col_block_to_ddl @cur_proc, @temp_name, 'CREATE_TABLE', @col_block, NULL, @ddl1 OUTPUT, @cnt1 OUTPUT

                IF @ddl1 IS NOT NULL
                    INSERT INTO dbo.SCM_CONV_GTT_DDL (PROC_NAME, TEMP_NAME, TEMP_TYPE, ORACLE_DDL, COL_COUNT)
                    VALUES (@cur_proc, @temp_name, 'CREATE_TABLE', @ddl1, @cnt1)
            END

            SET @pos = @end_pos
        END

        -- ========================================================
        -- 2) DECLARE @xxx TABLE (...) 파싱
        -- ========================================================
        SET @pos = 1
        WHILE 1=1
        BEGIN
            SET @pos = CHARINDEX('DECLARE @', @src, @pos)
            IF @pos = 0 BREAK

            -- TABLE 키워드 확인
            DECLARE @chunk NVARCHAR(500) = UPPER(SUBSTRING(@src, @pos, 500))
            IF CHARINDEX(' TABLE', @chunk) = 0 OR CHARINDEX(' TABLE', @chunk) > 100
            BEGIN SET @pos = @pos + 9; CONTINUE END

            DECLARE @at_pos INT = CHARINDEX('@', @src, @pos)
            SET @name_end = @at_pos + 1
            WHILE @name_end <= LEN(@src) AND SUBSTRING(@src, @name_end, 1) LIKE '[A-Za-z0-9_]'
                SET @name_end = @name_end + 1
            SET @temp_name = SUBSTRING(@src, @at_pos, @name_end - @at_pos)

            -- 이름과 TABLE 사이에 다른 타입이 있으면 skip (DECLARE @v INT 등)
            DECLARE @between NVARCHAR(200) = UPPER(LTRIM(SUBSTRING(@src, @name_end, CHARINDEX(' TABLE', @chunk) + @pos - @name_end)))
            IF LTRIM(@between) <> '' AND LTRIM(@between) <> 'TABLE'
            BEGIN SET @pos = @name_end; CONTINUE END

            DECLARE @table_kw INT = CHARINDEX('TABLE', UPPER(@src), @name_end)
            IF @table_kw = 0 BEGIN SET @pos = @name_end; CONTINUE END

            SET @paren_start = CHARINDEX('(', @src, @table_kw)
            IF @paren_start = 0 OR @paren_start - @table_kw > 30 BEGIN SET @pos = @table_kw + 5; CONTINUE END

            SET @depth = 1; SET @end_pos = @paren_start + 1
            WHILE @end_pos <= LEN(@src) AND @depth > 0
            BEGIN
                IF SUBSTRING(@src, @end_pos, 1) = '(' SET @depth = @depth + 1
                IF SUBSTRING(@src, @end_pos, 1) = ')' SET @depth = @depth - 1
                SET @end_pos = @end_pos + 1
            END

            SET @col_block = SUBSTRING(@src, @paren_start + 1, @end_pos - @paren_start - 2)

            IF NOT EXISTS (SELECT 1 FROM dbo.SCM_CONV_GTT_DDL WHERE PROC_NAME = @cur_proc AND TEMP_NAME = @temp_name)
            BEGIN
                DECLARE @ddl2 NVARCHAR(MAX), @cnt2 INT
                EXEC dbo._parse_col_block_to_ddl @cur_proc, @temp_name, 'DECLARE_TABLE', @col_block, NULL, @ddl2 OUTPUT, @cnt2 OUTPUT

                IF @ddl2 IS NOT NULL
                    INSERT INTO dbo.SCM_CONV_GTT_DDL (PROC_NAME, TEMP_NAME, TEMP_TYPE, ORACLE_DDL, COL_COUNT)
                    VALUES (@cur_proc, @temp_name, 'DECLARE_TABLE', @ddl2, @cnt2)
            END

            SET @pos = @end_pos
        END

        -- ========================================================
        -- 3) SELECT [TOP N] * INTO #xxx FROM table
        -- ========================================================
        SET @pos = 1
        WHILE 1=1
        BEGIN
            SET @pos = CHARINDEX(' INTO #', @src, @pos)
            IF @pos = 0 BREAK

            SET @hash_pos = CHARINDEX('#', @src, @pos)
            SET @name_end = @hash_pos + 1
            WHILE @name_end <= LEN(@src) AND SUBSTRING(@src, @name_end, 1) LIKE '[A-Za-z0-9_]'
                SET @name_end = @name_end + 1
            SET @temp_name = SUBSTRING(@src, @hash_pos, @name_end - @hash_pos)

            -- 이미 처리됨?
            IF EXISTS (SELECT 1 FROM dbo.SCM_CONV_GTT_DDL WHERE PROC_NAME = @cur_proc AND TEMP_NAME = @temp_name)
            BEGIN SET @pos = @name_end; CONTINUE END

            -- FROM 이후 테이블명 추출
            DECLARE @from_pos INT = CHARINDEX('FROM', UPPER(@src), @name_end)
            IF @from_pos = 0 OR @from_pos - @name_end > 100 BEGIN SET @pos = @name_end; CONTINUE END

            DECLARE @tbl_start INT = @from_pos + 4
            WHILE @tbl_start <= LEN(@src) AND SUBSTRING(@src, @tbl_start, 1) IN (' ', CHAR(9), CHAR(10), CHAR(13))
                SET @tbl_start = @tbl_start + 1

            -- dbo. / [dbo]. 제거
            IF UPPER(SUBSTRING(@src, @tbl_start, 4)) = 'DBO.'
                SET @tbl_start = @tbl_start + 4
            IF SUBSTRING(@src, @tbl_start, 6) = '[dbo].'
                SET @tbl_start = @tbl_start + 6

            -- [name] 대괄호 제거
            IF SUBSTRING(@src, @tbl_start, 1) = '['
                SET @tbl_start = @tbl_start + 1

            DECLARE @tbl_end INT = @tbl_start
            WHILE @tbl_end <= LEN(@src) AND SUBSTRING(@src, @tbl_end, 1) LIKE '[A-Za-z0-9_]'
                SET @tbl_end = @tbl_end + 1
            DECLARE @source_tbl NVARCHAR(256) = SUBSTRING(@src, @tbl_start, @tbl_end - @tbl_start)

            -- #TEMP이면 skip (실제 테이블만 대상)
            IF LEFT(@source_tbl, 1) = '#' BEGIN SET @pos = @tbl_end; CONTINUE END

            -- INFORMATION_SCHEMA에서 컬럼 조회
            IF @source_tbl <> '' AND EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = @source_tbl)
            BEGIN
                DECLARE @ddl3 NVARCHAR(MAX), @cnt3 INT = 0
                DECLARE @clean NVARCHAR(128) = REPLACE(@temp_name, '#', '')
                DECLARE @gtt3 NVARCHAR(128) = 'GT_' + UPPER(LEFT(@cur_proc, 4)) + '_' + UPPER(@clean)
                IF LEN(@gtt3) > 30 SET @gtt3 = LEFT(@gtt3, 30)

                SET @ddl3 = 'CREATE GLOBAL TEMPORARY TABLE ' + @gtt3 + CHAR(10) + '(' + CHAR(10)

                DECLARE @c_name NVARCHAR(256), @c_type NVARCHAR(50), @c_len INT, @c_prec INT, @c_scale INT, @o_type NVARCHAR(200)

                DECLARE si_cur CURSOR LOCAL FAST_FORWARD FOR
                    SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, NUMERIC_PRECISION, NUMERIC_SCALE
                    FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = @source_tbl ORDER BY ORDINAL_POSITION

                OPEN si_cur
                FETCH NEXT FROM si_cur INTO @c_name, @c_type, @c_len, @c_prec, @c_scale

                WHILE @@FETCH_STATUS = 0
                BEGIN
                    SET @cnt3 = @cnt3 + 1

                    -- 타입 변환
                    SET @o_type = CASE LOWER(@c_type)
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
                        IF LOWER(@c_type) IN ('varchar','nvarchar')
                            SET @o_type = CASE WHEN @c_len = -1 OR @c_len > 4000 THEN 'VARCHAR2(4000 CHAR)'
                                               ELSE 'VARCHAR2(' + CAST(@c_len AS VARCHAR) + ' CHAR)' END
                        ELSE IF LOWER(@c_type) IN ('char','nchar')
                            SET @o_type = 'CHAR(' + CAST(ISNULL(@c_len,1) AS VARCHAR) + ')'
                        ELSE IF LOWER(@c_type) IN ('decimal','numeric')
                            SET @o_type = 'NUMBER' + CASE WHEN @c_prec IS NOT NULL AND @c_scale IS NOT NULL
                                THEN '(' + CAST(@c_prec AS VARCHAR) + ',' + CAST(@c_scale AS VARCHAR) + ')'
                                WHEN @c_prec IS NOT NULL THEN '(' + CAST(@c_prec AS VARCHAR) + ')' ELSE '' END
                        ELSE IF LOWER(@c_type) = 'varbinary'
                            SET @o_type = CASE WHEN @c_len = -1 THEN 'BLOB' ELSE 'RAW(' + CAST(@c_len AS VARCHAR) + ')' END
                        ELSE
                            SET @o_type = 'VARCHAR2(4000 CHAR)'
                    END

                    IF @cnt3 > 1 SET @ddl3 = @ddl3 + ',' + CHAR(10)
                    SET @ddl3 = @ddl3 + '    ' + LEFT(UPPER(@c_name) + SPACE(30), 30) + ' ' + @o_type

                    FETCH NEXT FROM si_cur INTO @c_name, @c_type, @c_len, @c_prec, @c_scale
                END
                CLOSE si_cur; DEALLOCATE si_cur

                SET @ddl3 = @ddl3 + CHAR(10) + ') ON COMMIT PRESERVE ROWS;'

                INSERT INTO dbo.SCM_CONV_GTT_DDL (PROC_NAME, TEMP_NAME, TEMP_TYPE, SOURCE_TABLE, ORACLE_DDL, COL_COUNT)
                VALUES (@cur_proc, @temp_name, 'SELECT_INTO', @source_tbl, @ddl3, @cnt3)
            END

            SET @pos = @tbl_end
        END

        FETCH NEXT FROM proc_cur INTO @cur_proc, @src
    END
    CLOSE proc_cur; DEALLOCATE proc_cur

    -- 결과 출력
    SELECT PROC_NAME, TEMP_NAME, TEMP_TYPE, SOURCE_TABLE, COL_COUNT, ORACLE_DDL
    FROM dbo.SCM_CONV_GTT_DDL
    WHERE (@p_proc_name IS NULL OR PROC_NAME LIKE @p_proc_name)
    ORDER BY PROC_NAME, SEQ

    PRINT CAST(@@ROWCOUNT AS VARCHAR) + '건 완료'
END
