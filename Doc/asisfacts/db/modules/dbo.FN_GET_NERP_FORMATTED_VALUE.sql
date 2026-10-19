


-- =============================================
-- Program:      FN_GET_NERP_FORMATTED_VALUE
-- Author:       김준규
-- Create date:  2025-06-05
-- Description:  NERP) 컨버전시 ISNULL 할 경우에 Default 값을 사용하기 위힘
-- How to Execute: SELECT dbo.FN_GET_NERP_FORMATTED_VALUE('TABLE_NAME','COLUMN_NAME')
-- ==========================================================================================
-- 2025-07-25       김준규       NERP) NERP) 컨버전시 ISNULL 할 경우에 Default 값을 사용하기 위힘
---------------------------------------------------------------------------------------------
CREATE FUNCTION [dbo].[FN_GET_NERP_FORMATTED_VALUE]
(
    @P_TableName SYSNAME,
    @P_ColumnName SYSNAME,
    @P_Cols_YN VARCHAR(1) = 'N'
)
RETURNS NVARCHAR(256)
AS
BEGIN
    DECLARE @DataType SYSNAME;
    DECLARE @DefaultExp NVARCHAR(100);
    DECLARE @ResultExpr NVARCHAR(256);

    -- 시스템 뷰를 직접 조인하여 데이터 타입 조회
    SELECT @DataType = TYPE_NAME(c.user_type_id)
    FROM sys.columns c
    JOIN sys.objects o ON c.object_id = o.object_id
    JOIN sys.schemas s ON o.schema_id = s.schema_id
    WHERE s.name = COALESCE(PARSENAME(@P_TableName, 2), 'dbo') -- 스키마명 (기본 dbo)
      AND o.name = PARSENAME(@P_TableName, 1) -- 테이블명
      AND c.name = @P_ColumnName;

    -- 기본값 설정: 데이터 타입별로 구분
    IF @DataType IS NULL
        SET @DefaultExp = N'''INVALID_COLUMN'''
    ELSE IF @DataType LIKE '%char%' OR @DataType LIKE '%text%'
        SET @DefaultExp = N'''__NULL__'''
    ELSE IF @DataType IN ('int', 'bigint', 'smallint', 'tinyint', 'decimal', 'numeric', 'float', 'real', 'money', 'smallmoney')
        SET @DefaultExp = N'0'
    ELSE IF @DataType IN ('bit')
        SET @DefaultExp = N'0'
    ELSE IF @DataType IN ('datetime', 'smalldatetime', 'date', 'datetime2', 'datetimeoffset', 'time')
        SET @DefaultExp = N'''1900-01-01'''
    ELSE IF @DataType IN ('uniqueidentifier')
        SET @DefaultExp = N'''00000000-0000-0000-0000-000000000000'''
    ELSE IF @DataType IN ('binary', 'varbinary', 'image')
        SET @DefaultExp = N'''__NULL__'''  -- 또는 0x0
    ELSE
        SET @DefaultExp = '''UNSUPPORTED'''

    -- @P_Cols_YN 파라미터에 따라 결과 생성
    IF UPPER(@P_Cols_YN) = 'N'
        SET @ResultExpr = @DefaultExp  -- 컬럼명 없이 기본값만 반환
    ELSE
        SET @ResultExpr = 'ISNULL(' + QUOTENAME(@P_ColumnName) + ', ' + @DefaultExp + ')'  -- 기존 형식 유지

    RETURN @ResultExpr;
END
