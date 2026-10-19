
/****************************************************************************
* PROJECT           : LGES SCM
* PROCEDURE NAME    : PR_SCP_OPT_ENG_DATA_DELETE
* DESCRIPTION       : Table Backup 및 Data Purge용 프로시저.
* PROGRAM HISTORY
*--------------------------------------------------------------
*  DATE         IN CHARGE           DESCRIPTION
*--------------------------------------------------------------
* 2025.02.27    Philsu Park         Initial Release.
****************************************************************************/
CREATE PROCEDURE [dbo].[PR_SCP_OPT_ENG_DATA_DELETE]
     /* @p_mst_table               NVARCHAR(100)
    ,@p_hst_table               NVARCHAR(100)
    ,@p_before_days             NVARCHAR(10) */
AS 
BEGIN

	------------------------------------------------------------------------  
    -- Procedure 기본조건.
	------------------------------------------------------------------------
	SET XACT_ABORT ON;
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	------------------------------------------------------------------------  

    /* 250226_Master변경이력 확인 prototype. */
    /* DECLARE @v_sql NVARCHAR(MAX);
    DECLARE @v_select NVARCHAR(MAX);
    DECLARE @v_where NVARCHAR(MAX);
    DECLARE @v_where2 NVARCHAR(MAX);
    DECLARE @db_schema NVARCHAR(50);
    DECLARE @v_mst_table NVARCHAR(100) = @p_mst_table;
    DECLARE @v_hst_table NVARCHAR(100) = @p_hst_table;
    DECLARE @newline NVARCHAR(2) = CHAR(13)+CHAR(10);
    DECLARE @date_add nvarchar(100) = CONCAT('-', @p_before_days);  --탐색구간. Parameter 로 처리.
    
    DECLARE @mst_col nvarchar(100);
    DECLARE @hst_col nvarchar(100);
    DECLARE @sort_order INTEGER;
    DECLARE @data_type nvarchar(20);
    DECLARE @pk_flag nvarchar(2);
    DECLARE @num_flag nvarchar(2);
    DECLARE @date_flag nvarchar(2);
    DECLARE @user_flag nvarchar(2);
    DECLARE @col_name nvarchar(100);



    SET @v_select       = '';
    SET @v_where        = 'WHERE   1=1' + @newline;
    SET @v_where2       = '' + @newline;
    -- SET @v_mst_table    = 'SCM_TACT_TIME_M';  -- Main + Hist 는 Pair로 관리 필요할 듯.. 그게 아니면 hist 찾는 Rule 이 있어야 함.
    -- SET @v_hst_table    = 'HIS_TACT_TIME_M';


    SET @v_sql          = N'SELECT   [SELECT] FROM [TB_MST] AS M WITH(NOLOCK)' + @newline;
    SET @v_sql          = @v_sql + N'LEFT OUTER JOIN [TB_HST] AS H WITH(NOLOCK)' + @newline;
    SET @v_sql          = @v_sql + N'    ON  1=1' + @newline;


        -- #temp Drop.
        IF OBJECT_ID (N'tempdb..#KEY_COLS', N'U') IS NOT NULL 		DROP TABLE #KEY_COLS;

        -- 00. Table의 Schema 정보 확인.
        BEGIN
            SELECT  TOP 1 @db_schema = CONCAT('[', MST.TABLE_CATALOG, '].', '[', MST.TABLE_SCHEMA, '].')
            FROM    (     
                    SELECT    C.TABLE_CATALOG
                            , C.TABLE_SCHEMA
                            , C.TABLE_NAME
                    FROM    [LGCE_SCMDEV].INFORMATION_SCHEMA.TABLES C WITH(NOLOCK)
                    WHERE   1=1
                    AND     C.TABLE_NAME    = @v_mst_table
                    UNION 
                    SELECT    C.TABLE_CATALOG
                            , C.TABLE_SCHEMA
                            , C.TABLE_NAME
                    FROM    [LGCE_FPDEV].INFORMATION_SCHEMA.COLUMNS C WITH(NOLOCK)
                    WHERE   1=1
                    AND     C.TABLE_NAME    = @v_mst_table
                    UNION 
                    SELECT    C.TABLE_CATALOG
                            , C.TABLE_SCHEMA
                            , C.TABLE_NAME
                    FROM    [LGCE_FPDEV_TR].INFORMATION_SCHEMA.COLUMNS C WITH(NOLOCK)
                    WHERE   1=1
                    AND     C.TABLE_NAME    = @v_mst_table
                ) MST

        END

        -- 01. KEY COLUMN 정보를 찾는다.
        BEGIN
            SELECT    MST_COL
                    , HST_COL
                    , SORT_ORDER
                    , DATA_TYPE
                    , PK_FLAG
                    , NUM_FLAG
                    , DATE_FLAG
                    , USER_FLAG
                    , COL_NAME
            INTO    #KEY_COLS
            FROM (     
                    SELECT    CONCAT('M.', C.COLUMN_NAME)                   AS MST_COL
                            , CONCAT('H.', C.COLUMN_NAME)                   AS HST_COL
                            , C.ORDINAL_POSITION                            AS SORT_ORDER
                            , C.DATA_TYPE                                   AS DATA_TYPE
                            , IIF(ISNULL(K.COLUMN_NAME, '') = '', 'N', 'Y') AS PK_FLAG
                            , CASE WHEN C.DATA_TYPE IN (N'NUMERIC', N'INT', N'DECIMAL', N'SMALLINT', N'FLOAT', N'BIGINT')   THEN 'Y'
                                ELSE 'N' END AS NUM_FLAG
                            , CASE WHEN (CHARINDEX('UPDATE', C.COLUMN_NAME) > 0 AND DATA_TYPE = 'DATETIME')                 THEN 'Y'
                                ELSE 'N' END AS DATE_FLAG
                            , CASE WHEN (CHARINDEX('UPDATE', C.COLUMN_NAME) > 0 AND DATA_TYPE != 'DATETIME')                THEN 'Y'
                                ELSE 'N' END AS USER_FLAG
                            , C.COLUMN_NAME                                 AS COL_NAME
                    -- INTO    #KEY_COLS
                    FROM    [LGCE_SCMDEV].INFORMATION_SCHEMA.COLUMNS C WITH(NOLOCK)
                    LEFT OUTER JOIN [LGCE_SCMDEV].INFORMATION_SCHEMA.KEY_COLUMN_USAGE K WITH(NOLOCK)
                        ON  1=1 
                        AND C.TABLE_NAME    = K.TABLE_NAME
                        AND C.COLUMN_NAME   = K.COLUMN_NAME
                    WHERE   1=1
                    AND     C.TABLE_NAME    = @v_mst_table
                    UNION 
                    SELECT    CONCAT('M.', C.COLUMN_NAME)                   AS MST_COL
                            , CONCAT('H.', C.COLUMN_NAME)                   AS HST_COL
                            , C.ORDINAL_POSITION                            AS SORT_ORDER
                            , C.DATA_TYPE                                   AS DATA_TYPE
                            , IIF(ISNULL(K.COLUMN_NAME, '') = '', 'N', 'Y') AS PK_FLAG
                            , CASE WHEN C.DATA_TYPE IN (N'NUMERIC', N'INT', N'DECIMAL', N'SMALLINT', N'FLOAT', N'BIGINT')   THEN 'Y'
                                ELSE 'N' END AS NUM_FLAG
                            , CASE WHEN (CHARINDEX('UPDATE', C.COLUMN_NAME) > 0 AND DATA_TYPE = 'DATETIME')                 THEN 'Y'
                                ELSE 'N' END AS DATE_FLAG
                            , CASE WHEN (CHARINDEX('UPDATE', C.COLUMN_NAME) > 0 AND DATA_TYPE != 'DATETIME')                THEN 'Y'
                                ELSE 'N' END AS USER_FLAG
                            , C.COLUMN_NAME                                 AS COL_NAME
                    FROM    [LGCE_FPDEV].INFORMATION_SCHEMA.COLUMNS C WITH(NOLOCK)
                    LEFT OUTER JOIN [LGCE_FPDEV].INFORMATION_SCHEMA.KEY_COLUMN_USAGE K WITH(NOLOCK)
                        ON  1=1 
                        AND C.TABLE_NAME    = K.TABLE_NAME
                        AND C.COLUMN_NAME   = K.COLUMN_NAME
                    WHERE   1=1
                    AND     C.TABLE_NAME    = @v_mst_table
                    UNION 
                    SELECT    CONCAT('M.', C.COLUMN_NAME)                   AS MST_COL
                            , CONCAT('H.', C.COLUMN_NAME)                   AS HST_COL
                            , C.ORDINAL_POSITION                            AS SORT_ORDER
                            , C.DATA_TYPE                                   AS DATA_TYPE
                            , IIF(ISNULL(K.COLUMN_NAME, '') = '', 'N', 'Y') AS PK_FLAG
                            , CASE WHEN C.DATA_TYPE IN (N'NUMERIC', N'INT', N'DECIMAL', N'SMALLINT', N'FLOAT', N'BIGINT')   THEN 'Y'
                                ELSE 'N' END AS NUM_FLAG
                            , CASE WHEN (CHARINDEX('UPDATE', C.COLUMN_NAME) > 0 AND DATA_TYPE = 'DATETIME')                 THEN 'Y'
                                ELSE 'N' END AS DATE_FLAG
                            , CASE WHEN (CHARINDEX('UPDATE', C.COLUMN_NAME) > 0 AND DATA_TYPE != 'DATETIME')                THEN 'Y'
                                ELSE 'N' END AS USER_FLAG
                            , C.COLUMN_NAME                                 AS COL_NAME
                    FROM    [LGCE_FPDEV_TR].INFORMATION_SCHEMA.COLUMNS C WITH(NOLOCK)
                    LEFT OUTER JOIN [LGCE_FPDEV_TR].INFORMATION_SCHEMA.KEY_COLUMN_USAGE K WITH(NOLOCK)
                        ON  1=1 
                        AND C.TABLE_NAME    = K.TABLE_NAME
                        AND C.COLUMN_NAME   = K.COLUMN_NAME
                    WHERE   1=1
                    AND     C.TABLE_NAME    = @v_mst_table
                ) MST

        END

        -- 02. Key Column을 Cursor로 선언.
        DECLARE COL_CURSOR CURSOR FOR
        SELECT  *
        FROM    #KEY_COLS
        ORDER BY PK_FLAG DESC, NUM_FLAG DESC, DATE_FLAG DESC, SORT_ORDER
        ;

        -- 03. 커서 열기
        OPEN COL_CURSOR;

        -- 04. 커서에서 컬럼을 순차적으로 가져와서 동적쿼리 구문 생성.
        FETCH NEXT FROM COL_CURSOR INTO @mst_col, @hst_col, @sort_order, @data_type, @pk_flag, @num_flag, @date_flag, @user_flag, @col_name
        WHILE @@FETCH_STATUS = 0
        BEGIN
            
            -- 2.1 Key Column SELECT 구문 추가
            IF (@pk_flag = 'Y')
            BEGIN
                SET @v_select = @v_select + IIF(LEN(@v_select) = 0, N'', N'     , ') + @mst_col + @newline;
            END

            -- 2.2 수량 Column SELECT 구문 추가(수량 컬럼 각각)
            IF (@num_flag = 'Y')
            BEGIN
                SET @v_select = @v_select + IIF(LEN(@v_select) = 0, N'', N'     , ') + @mst_col + N'    AS MST_' + @col_name + @newline;
                SET @v_select = @v_select + IIF(LEN(@v_select) = 0, N'', N'     , ') + @hst_col + N'    AS HST_' + @col_name + @newline;
            END

            -- 2.3 Main, Hist JOIN 구문 추가
            IF (@pk_flag = 'Y')
            BEGIN
                SET @v_sql = @v_sql + N'    AND ' + @mst_col + N'   = ' + @hst_col + @newline;
            END

            -- 2.4 제약 조건절 구문 추가: 수량컬럼이 다수인 경우, OR 절 형태로 처리해서 묶어줘야 함.
            IF (@num_flag = 'Y')
            BEGIN
                IF (@v_where2 = '' + @newline)
                    SET @v_where2 = @v_where2 + N'       ' + @mst_col + N'   != ISNULL(' + @hst_col + N', 0)'+ @newline;
                ELSE
                    SET @v_where2 = @v_where2 + N'    OR ' + @mst_col + N'   != ISNULL(' + @hst_col + N', 0)'+ @newline;
            END

            -- 2.5 날짜 조건(+조회) 추가. 구간은 data_add 변수로 처리.
            IF (@date_flag = 'Y')
            BEGIN
                SET @v_select = @v_select + IIF(LEN(@v_select) = 0, N'', N'     , ') + @mst_col + N'    AS MST_' + @col_name + @newline;
                SET @v_select = @v_select + IIF(LEN(@v_select) = 0, N'', N'     , ') + @hst_col + N'    AS HST_' + @col_name + @newline;
                SET @v_where = @v_where + N'    AND ' + @mst_col + N'   >= CURRENT_TIMESTAMP ' + @date_add + @newline;
                SET @v_where = @v_where + N'    AND ISNULL(' + @hst_col + N', CURRENT_TIMESTAMP)   >= CURRENT_TIMESTAMP ' + @date_add + @newline;
            END

            -- 2.5 날짜 조건(+조회) 추가. 구간은 data_add 변수로 처리.
            IF (@user_flag = 'Y')
            BEGIN
                SET @v_select = @v_select + IIF(LEN(@v_select) = 0, N'', N'     , ') + @mst_col + N'    AS MST_' + @col_name + @newline;
                SET @v_select = @v_select + IIF(LEN(@v_select) = 0, N'', N'     , ') + @hst_col + N'    AS HST_' + @col_name + @newline;
            END

            FETCH NEXT FROM COL_CURSOR INTO @mst_col, @hst_col, @sort_order, @data_type, @pk_flag, @num_flag, @date_flag, @user_flag, @col_name
        END

        -- Loop 끝나면 Cursor 닫고 할당 초기화.
        CLOSE COL_CURSOR;
        DEALLOCATE COL_CURSOR;

        IF OBJECT_ID (N'tempdb..#KEY_COLS', N'U') IS NOT NULL 		DROP TABLE #KEY_COLS;

        -- Replace, 구문 합치기.
        SET @v_sql = REPLACE(@v_sql, '[SELECT]', @v_select);
        SET @v_sql = REPLACE(@v_sql, '[TB_MST]', CONCAT(@db_schema, @v_mst_table));
        SET @v_sql = REPLACE(@v_sql, '[TB_HST]', CONCAT(@db_schema, @v_hst_table));
        IF (@v_where2 != '' + @newline)
            SET @v_where2 = 'AND ( ' + @v_where2 + ')';
        SET @v_sql = @v_sql + @v_where + @v_where2;

        PRINT @v_sql; */
    -- EXEC sp_executesql @v_sql; -- 바로 결과값만 확인 필요하면 execution.

    

END;
