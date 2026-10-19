

/*=====================================================================================================
Procedure Name : SYS_TABLE_INFO
Version        : 1.0
Description    : DB 내에 있는 테이블 일괄 조회
How to Excute  : EXEC SYS_TABLE_INFO 'NERP_CONV_MASTER'
[History]
 1.5김준규 2025-03-05  타사이트에서 사용하는 것 참조 변경함
======================================================================================================*/
CREATE PROCEDURE [dbo].[SYS_TABLE_INFO] (
    @P_TABLE_NAME   NVARCHAR(100)
)
AS BEGIN

    SET NOCOUNT ON;
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED; -- TABLE Lock 적용 하지 않음.

/*
    WITH V_SYS_TABLE_INFO AS (
    SELECT D.COLORDER                AS COLUMN_IDX            -- Column Index
         , A.NAME                    AS TABLE_NAME            -- Table Name
         , C.VALUE                   AS TABLE_DESC     -- Table Description
         , D.NAME                    AS COLUMN_NAME           -- Column Name
         , E.VALUE                   AS COLUMN_DESC    -- Column Description
         , F.DATA_TYPE               AS TYPE                  -- Column Type
         , F.CHARACTER_MAXIMUM_LENGTH  AS LENGTH                -- Column Length
         , CASE WHEN F.NUMERIC_PRECISION IS NOT NULL THEN F.DATA_TYPE + '('+CONVERT(VARCHAR,F.NUMERIC_PRECISION)+','+CONVERT(VARCHAR,ISNULL(F.NUMERIC_SCALE,0))+')'
                WHEN F.CHARACTER_MAXIMUM_LENGTH IS NOT NULL THEN F.DATA_TYPE +'('+CONVERT(VARCHAR,F.CHARACTER_MAXIMUM_LENGTH)+')'
                ELSE F.DATA_TYPE
            END                      AS TYPE_LENGTH
         , F.IS_NULLABLE             AS IS_NULLABLE           -- Column Nullable
         , F.COLLATION_NAME          AS COLLATION_NAME        -- Column Collaction Name
         , CASE WHEN K.COLUMN_NAME IS NOT NULL THEN 'PK' ELSE '' END AS PK
         , ISNULL(F.COLUMN_DEFAULT,'') AS COLUMN_DEFAULT
      FROM SYSOBJECTS A WITH (NOLOCK)
      INNER JOIN SYSUSERS B WITH (NOLOCK)        ON A.UID = B.UID
      INNER JOIN SYSCOLUMNS D WITH (NOLOCK)        ON D.ID = A.ID
      INNER JOIN INFORMATION_SCHEMA.COLUMNS F WITH (NOLOCK)
         ON A.NAME = F.TABLE_NAME
        AND D.NAME = F.COLUMN_NAME
       LEFT OUTER JOIN SYS.EXTENDED_PROPERTIES C WITH (NOLOCK)
         ON C.MAJOR_ID = A.ID
        AND C.MINOR_ID = 0
        AND C.NAME = 'MS_Description'
       LEFT OUTER JOIN SYS.EXTENDED_PROPERTIES E WITH (NOLOCK)
         ON E.MAJOR_ID = D.ID
        AND E.MINOR_ID = D.COLID
        AND E.NAME = 'MS_Description'
       LEFT OUTER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE K WITH(NOLOCK)
         ON A.NAME = K.TABLE_NAME
        AND D.NAME = K.COLUMN_NAME

      WHERE 1=1
        AND A.TYPE = 'U'
    )
    SELECT
         COLUMN_IDX
        ,TABLE_NAME
        ,TABLE_DESC
        ,COLUMN_NAME
        ,COLUMN_DESC
        ,UPPER(REPLACE(REPLACE(TYPE_LENGTH,'-1','MAX'),'()','') ) AS TYPE_LENGTH
        ,REPLACE(PK,'PK','Y') AS PK
        ,IS_NULLABLE
        ,TYPE
        ,(CASE WHEN CONVERT(VARCHAR,LENGTH) = '-1' THEN 'MAX' ELSE CONVERT(VARCHAR,LENGTH) END) AS LENGTH
        ,COLLATION_NAME
        ,COLUMN_DEFAULT
    FROM V_SYS_TABLE_INFO A WITH(NOLOCK)
    WHERE A.TABLE_NAME LIKE @P_TABLE_NAME
    OR A.TABLE_NAME IN (SELECT Z.VALUE FROM string_split(@P_TABLE_NAME,',') Z)
    ORDER BY TABLE_NAME, COLUMN_IDX
    ;
*/

/*
    SELECT A.TABLE_NAME,
           C.VALUE AS TABLE_COMMENT,
           AA.COLUMN_ID,
           A.COLUMN_NAME,
           B.VALUE AS COLUM_COMMENT,
           case when isnull(a.CHARACTER_MAXIMUM_LENGTH,'-') <  > '-' then UPPER(a.DATA_TYPE)+'('+convert(nvarchar(10),a.CHARACTER_MAXIMUM_LENGTH)+')'
                when UPPER(a.DATA_TYPE) = 'NUMERIC' then UPPER(a.DATA_TYPE)+'('+
                                                         ISNULL(CAST(A.CHARACTER_MAXIMUM_LENGTH AS VARCHAR),
                                                                CAST(A.NUMERIC_PRECISION AS VARCHAR) + ',' +
                                                                CAST(A.NUMERIC_SCALE AS VARCHAR))+')'
            else UPPER(a.DATA_TYPE) end data_type,
           case when d.COLUMN_NAME is not null then 'PK' else '' END as pk,
           CASE WHEN A.IS_NULLABLE = 'YES' THEN 'NULL' ELSE 'NOT NULL' END  AS "NULL 허용" ,
           A.DATA_TYPE,
           ISNULL(CAST(A.CHARACTER_MAXIMUM_LENGTH AS VARCHAR),
                      CAST(A.NUMERIC_PRECISION AS VARCHAR) + ',' +
                      CAST(A.NUMERIC_SCALE AS VARCHAR)) AS COLUMN_LENGTH,
           A.COLUMN_DEFAULT
    FROM INFORMATION_SCHEMA.COLUMNS A WITH(NOLOCK)
    LEFT OUTER JOIN
           SYS.ALL_COLUMNS AA WITH(NOLOCK)
       ON AA.OBJECT_ID = object_id(A.TABLE_NAME)
       AND AA.NAME = A.COLUMN_NAME
    LEFT OUTER JOIN (
           SELECT
               tbl.name AS TBL_NM , col.name AS COL_NM, ep.value
           FROM
               SYS.EXTENDED_PROPERTIES ep
           JOIN
               SYS.COLUMNS col ON ep.major_id = col.object_id AND ep.minor_id = col.column_id
           JOIN
               SYS.TABLES tbl ON col.object_id = tbl.object_id
           WHERE
               ep.class_desc = 'OBJECT_OR_COLUMN'
               AND ep.name = 'MS_Description'
           ) B
           ON B.TBL_NM = A.TABLE_NAME
           AND B.COL_NM = A.COLUMN_NAME
    LEFT OUTER JOIN
          (SELECT object_id(objname) AS TABLE_ID,
                      VALUE
          FROM ::FN_LISTEXTENDEDPROPERTY
              (NULL, 'User','dbo','table',
                  NULL, NULL, NULL)
               WHERE name = 'MS_Description'
          ) C
       ON object_id(A.TABLE_NAME) = C.TABLE_ID
    LEFT OUTER JOIN ( SELECT d.TABLE_NAME,d.COLUMN_NAME
                      FROM   INFORMATION_SCHEMA.KEY_COLUMN_USAGE D WITH(NOLOCK)
                      JOIN   sys.key_constraints kc
                      ON     kc.type = 'PK'
                      AND    kc.name = d.CONSTRAINT_NAME
                     ) D
       ON     1=1
       AND    d.TABLE_NAME  = a.TABLE_NAME
       AND    d.COLUMN_NAME = a.COLUMN_NAME
    --WHERE A.TABLE_NAME LIKE  '%BOD%'
    --WHERE a.COLUMN_NAME = 'ASC_LT_MT'
    --WHERE A.TABLE_NAME  = 'TB_CPRDL_SPRD_BOM_H'
    WHERE A.TABLE_NAME LIKE @P_TABLE_NAME
    --AND A.COLUMN_DEFAULT IS NOT NULL
    ORDER BY A.TABLE_NAME, A.ORDINAL_POSITION
*/

    -- 대상 객체 정보 변수 선언
    DECLARE @ObjectName NVARCHAR(128) = @P_TABLE_NAME;
    IF LEFT(@ObjectName,1) = '[' 
  	BEGIN
  	    SET @ObjectName = SUBSTRING(@ObjectName,2,LEN(@ObjectName)-1);
  	END	
    IF RIGHT(@ObjectName,1) = ']' 
  	BEGIN
  	    SET @ObjectName = SUBSTRING(@ObjectName,1,LEN(@ObjectName)-1);
  	END	
    DECLARE @BaseObjectName NVARCHAR(128);
    DECLARE @BaseSchemaName NVARCHAR(128);
    DECLARE @BaseDatabaseName NVARCHAR(128);
    DECLARE @BaseServerName NVARCHAR(128);
    DECLARE @FullObjectName NVARCHAR(MAX);
    DECLARE @SQL NVARCHAR(MAX);

    -- SYNONYM인지 확인
    IF EXISTS (SELECT 1 FROM sys.synonyms WHERE name = @ObjectName)
    BEGIN
        -- SYNONYM의 참조 대상 정보 가져오기
        SELECT
            @FullObjectName = base_object_name
        FROM sys.synonyms
        WHERE name = @ObjectName;

        -- 참조 대상 파싱 (서버, 데이터베이스, 스키마, 객체)
        SET @BaseServerName = PARSENAME(@FullObjectName, 4);
        SET @BaseDatabaseName = PARSENAME(@FullObjectName, 3);
        SET @BaseSchemaName = PARSENAME(@FullObjectName, 2);
        SET @BaseObjectName = PARSENAME(@FullObjectName, 1);
    END
    ELSE
    BEGIN
        -- SYNONYM이 아니면 현재 데이터베이스 내의 테이블/뷰로 처리
        SET @BaseServerName = NULL;
        SET @BaseDatabaseName = DB_NAME();
        SET @BaseSchemaName = SCHEMA_NAME();
        SET @BaseObjectName = @ObjectName;
    END

    -- 동적 SQL 생성
    IF @BaseServerName IS NOT NULL AND @BaseDatabaseName IS NOT NULL
    BEGIN
        -- 다른 서버/데이터베이스를 참조하는 SYNONYM의 경우
        SET @SQL = '
SELECT
    ' + QUOTENAME(@BaseServerName,'''') + ' AS BaseServerName,
    ' + QUOTENAME(@BaseDatabaseName,'''') + ' AS BaseDBName,
    t.name AS TableName,
    tc.value AS TableComment,
    c.column_id AS ColumnID,
    c.name AS ColumnName,
    ep.value AS ColumnComment,
    CONCAT(
        t2.name,
        CASE
            WHEN t2.name IN (''NUMERIC'', ''DECIMAL'') THEN ''('' + CAST(c.precision AS NVARCHAR) + '','' + CAST(c.scale AS NVARCHAR) + '')''
            WHEN t2.name IN (''NVARCHAR'', ''NCHAR'') AND c.max_length > 0 THEN ''('' + CASE WHEN c.max_length = -1 THEN ''MAX'' ELSE CAST(c.max_length/2 AS NVARCHAR) END + '')''
            WHEN t2.name IN (''VARCHAR'' , ''CHAR'' ) AND c.max_length > 0 THEN ''('' + CASE WHEN c.max_length = -1 THEN ''MAX'' ELSE CAST(c.max_length   AS NVARCHAR) END + '')''
            ELSE ''''
        END
    ) AS ConcatenatedDataType,
    --CASE WHEN i.is_primary_key = 1 THEN ''PK'' ELSE NULL END AS PrimaryKey,
    CASE WHEN pk.primarykey = 1 THEN ''PK'' ELSE NULL END AS PrimaryKey,
    CASE WHEN c.is_nullable = 1 THEN ''NULL'' ELSE ''NOT NULL'' END AS Nullable,
    t2.name AS DataType,
    CASE
        WHEN t2.name IN (''NVARCHAR'', ''NCHAR'') THEN
            CASE WHEN c.max_length = -1 THEN ''MAX'' ELSE CAST(c.max_length/2 AS NVARCHAR) END
        WHEN t2.name IN (''VARCHAR'' , ''CHAR'' ) THEN
            CASE WHEN c.max_length = -1 THEN ''MAX'' ELSE CAST(c.max_length   AS NVARCHAR) END
        WHEN t2.name IN (''NUMERIC'', ''DECIMAL'') THEN CAST(c.precision AS NVARCHAR) + '','' + CAST(c.scale AS NVARCHAR)
        ELSE NULL
    END AS Length,
    dc.definition AS DefaultValue,
    -- IDENTITY 컬럼
    CASE
        WHEN c.is_identity = 1 THEN
            CONCAT(''IDENTITY('', CAST(IDENT_SEED( OBJECT_NAME(c.object_id, DB_ID(''' + @BaseDatabaseName + ''')) ) AS NVARCHAR), '','', CAST(IDENT_INCR( OBJECT_NAME(c.object_id, DB_ID(''' + @BaseDatabaseName + ''')) ) AS NVARCHAR), '')'')
        ELSE NULL
    END AS IdentitySpec,
    create_date=convert(date,o.create_date),
    modify_date=convert(date,o.modify_date)
FROM ' + QUOTENAME(@BaseServerName) + '.' + QUOTENAME(@BaseDatabaseName) + '.sys.columns AS c
INNER JOIN ' + QUOTENAME(@BaseServerName) + '.' + QUOTENAME(@BaseDatabaseName) + '.sys.types AS t2
    ON c.user_type_id = t2.user_type_id
LEFT JOIN ' + QUOTENAME(@BaseServerName) + '.' + QUOTENAME(@BaseDatabaseName) + '.sys.tables AS t
    ON c.object_id = t.object_id
LEFT JOIN ' + QUOTENAME(@BaseServerName) + '.' + QUOTENAME(@BaseDatabaseName) + '.sys.extended_properties AS ep
    ON c.object_id = ep.major_id AND c.column_id = ep.minor_id AND ep.name = ''MS_Description''
LEFT JOIN ' + QUOTENAME(@BaseServerName) + '.' + QUOTENAME(@BaseDatabaseName) + '.sys.extended_properties AS tc
    ON c.object_id = tc.major_id AND tc.minor_id = 0 AND tc.name = ''MS_Description''
LEFT JOIN ' + QUOTENAME(@BaseServerName) + '.' + QUOTENAME(@BaseDatabaseName) + '.sys.default_constraints AS dc
    ON c.default_object_id = dc.object_id
-- PRIMARY KEY
OUTER APPLY (
    SELECT DISTINCT 1 AS PrimaryKey
    FROM ' + QUOTENAME(@BaseServerName) + '.' + QUOTENAME(@BaseDatabaseName) + '.sys.index_columns ic
    INNER JOIN ' + QUOTENAME(@BaseServerName) + '.' + QUOTENAME(@BaseDatabaseName) + '.sys.indexes i
        ON ic.object_id = i.object_id AND ic.index_id = i.index_id
    WHERE i.is_primary_key = 1 AND ic.object_id = c.object_id AND ic.column_id = c.column_id
) pk
LEFT JOIN ' + QUOTENAME(@BaseServerName) + '.'+ QUOTENAME(@BaseDatabaseName) + '.sys.objects AS o
    ON c.object_id = o.object_id
WHERE OBJECT_NAME(c.object_id, DB_ID(''' + @BaseDatabaseName + ''')) = ' + QUOTENAME(@BaseObjectName, '''') + '
ORDER BY c.column_id;
';
    END
    ELSE IF @BaseDatabaseName IS NOT NULL
    BEGIN
        -- 현재 데이터베이스의 테이블/뷰 또는 SYNONYM의 경우
        SET @SQL = '
SELECT
    ' + QUOTENAME(@BaseDatabaseName,'''') + ' AS BaseDBName,
    t.name AS TableName,
    tc.value AS TableComment,
    c.column_id AS ColumnID,
    c.name AS ColumnName,
    ep.value AS ColumnComment,
    CONCAT(
        t2.name,
        CASE
            WHEN t2.name IN (''NUMERIC'', ''DECIMAL'') THEN ''('' + CAST(c.precision AS NVARCHAR) + '','' + CAST(c.scale AS NVARCHAR) + '')''
            WHEN t2.name IN (''NVARCHAR'', ''NCHAR'') AND c.max_length > 0 THEN ''('' + CASE WHEN c.max_length = -1 THEN ''MAX'' ELSE CAST(c.max_length/2 AS NVARCHAR) END + '')''
            WHEN t2.name IN (''VARCHAR'' , ''CHAR'' ) AND c.max_length > 0 THEN ''('' + CASE WHEN c.max_length = -1 THEN ''MAX'' ELSE CAST(c.max_length   AS NVARCHAR) END + '')''
            ELSE ''''
        END
    ) AS ConcatenatedDataType,
    --CASE WHEN i.is_primary_key = 1 THEN ''PK'' ELSE NULL END AS PrimaryKey,
    CASE WHEN pk.primarykey = 1 THEN ''PK'' ELSE NULL END AS PrimaryKey,
    CASE WHEN c.is_nullable = 1 THEN ''NULL'' ELSE ''NOT NULL'' END AS Nullable,
    t2.name AS DataType,
    CASE
        WHEN t2.name IN (''NVARCHAR'', ''NCHAR'') THEN
            CASE WHEN c.max_length = -1 THEN ''MAX'' ELSE CAST(c.max_length/2 AS NVARCHAR) END
        WHEN t2.name IN (''VARCHAR'' , ''CHAR'' ) THEN
            CASE WHEN c.max_length = -1 THEN ''MAX'' ELSE CAST(c.max_length   AS NVARCHAR) END
        WHEN t2.name IN (''NUMERIC'', ''DECIMAL'') THEN CAST(c.precision AS NVARCHAR) + '','' + CAST(c.scale AS NVARCHAR)
        ELSE NULL
    END AS Length,
    dc.definition AS DefaultValue,
    -- IDENTITY 컬럼
    CASE
        WHEN c.is_identity = 1 THEN
            CONCAT(''IDENTITY('', CAST(IDENT_SEED( OBJECT_NAME(c.object_id, DB_ID(''' + @BaseDatabaseName + ''')) ) AS NVARCHAR), '','', CAST(IDENT_INCR( OBJECT_NAME(c.object_id, DB_ID(''' + @BaseDatabaseName + ''')) ) AS NVARCHAR), '')'')
        ELSE NULL
    END AS IdentitySpec,
    create_date=convert(date,o.create_date),
    modify_date=convert(date,o.modify_date)
FROM ' + QUOTENAME(@BaseDatabaseName) + '.sys.columns AS c
INNER JOIN ' + QUOTENAME(@BaseDatabaseName) + '.sys.types AS t2
    ON c.user_type_id = t2.user_type_id
LEFT JOIN ' + QUOTENAME(@BaseDatabaseName) + '.sys.tables AS t
    ON c.object_id = t.object_id
LEFT JOIN ' + QUOTENAME(@BaseDatabaseName) + '.sys.extended_properties AS ep
    ON c.object_id = ep.major_id AND c.column_id = ep.minor_id AND ep.name = ''MS_Description''
LEFT JOIN ' + QUOTENAME(@BaseDatabaseName) + '.sys.extended_properties AS tc
    ON c.object_id = tc.major_id AND tc.minor_id = 0 AND tc.name = ''MS_Description''
LEFT JOIN ' + QUOTENAME(@BaseDatabaseName) + '.sys.default_constraints AS dc
    ON c.default_object_id = dc.object_id
--LEFT JOIN ' + QUOTENAME(@BaseDatabaseName) + '.sys.index_columns ic
--    ON c.object_id = ic.object_id AND c.column_id = ic.column_id
--LEFT JOIN ' + QUOTENAME(@BaseDatabaseName) + '.sys.indexes i
--    ON ic.object_id = i.object_id AND ic.index_id = i.index_id
-- PRIMARY KEY
OUTER APPLY (
    SELECT DISTINCT 1 AS PrimaryKey
    FROM ' + QUOTENAME(@BaseDatabaseName) + '.sys.index_columns ic
    INNER JOIN ' + QUOTENAME(@BaseDatabaseName) + '.sys.indexes i
        ON ic.object_id = i.object_id AND ic.index_id = i.index_id
    WHERE i.is_primary_key = 1 AND ic.object_id = c.object_id AND ic.column_id = c.column_id
) pk
LEFT JOIN ' + QUOTENAME(@BaseDatabaseName) + '.sys.objects AS o
    ON c.object_id = o.object_id
WHERE OBJECT_NAME(c.object_id, DB_ID(''' + @BaseDatabaseName + ''')) = ' + QUOTENAME(@BaseObjectName, '''') + '
ORDER BY c.column_id;
';
    END
    ELSE
    BEGIN
        -- 오류 처리: 참조 대상이 확��되지 않음
        RAISERROR('The specified object could not be found or is not accessible.', 16, 1);
        RETURN;
    END

    --4000자 넘으면 에러발생
    --PRINT 'len @SQL :' + convert(varchar(50),len(@SQL));
    --PRINT @SQL;
    -- 동적 SQL 실행
    EXEC sp_executesql @SQL;

    -- 데이터 쿼리 SN = 동의어(SYNONYM), U = 테이블(사용자 정의USER_TABLE), V = 보기(VIEW)
    IF EXISTS(SELECT 1 FROM SYS.objects o WHERE O.name = @BaseObjectName AND O.type IN ('SN','U','V')) BEGIN
        SET @SQL = 'SELECT TOP 5000 * FROM ' + QUOTENAME(@BaseObjectName) + ' with(nolock);';
        --PRINT @SQL;
        -- 동적 SQL 실행
        EXEC sp_executesql @SQL;
        END
    ELSE BEGIN
        SET @SQL = 'SELECT VALUE = ''Object NOT Found'' ';
        --PRINT @SQL;
        -- 동적 SQL 실행
        EXEC sp_executesql @SQL;
        END

    -- 소스 쿼리
    SET @SQL = '
        SELECT B.NAME        AS REF_NAME
              ,B.TYPE_DESC   AS REF_TYPE
              ,A.DEFINITION  AS CONTENTS
              ,LENGTH_CTN    = FORMAT(LEN(A.DEFINITION), ''##,##0'')
        FROM   SYS.SQL_MODULES  A WITH (NOLOCK),
               SYS.OBJECTS      B WITH (NOLOCK)
        WHERE  A.OBJECT_ID    = B.OBJECT_ID
        AND    B.NAME        < > ' + QUOTENAME(@BaseObjectName,'''') + '
        AND    DEFINITION LIKE ''%[^a-zA-Z0-9_]' + REPLACE(REPLACE(QUOTENAME(@BaseObjectName),']',''),'[','') + '[^a-zA-Z0-9_]%''
        ORDER BY 1;'

    --PRINT @SQL;
    -- 동적 SQL 실행
    EXEC sp_executesql @SQL;

END