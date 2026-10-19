

CREATE FUNCTION dbo.FN_SPLIT_VAL
(
    @InputStr  NVARCHAR(MAX),
    @Delimiter NVARCHAR(10),
    @Position  INT
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
    DECLARE @Result   NVARCHAR(MAX) = NULL;
    DECLARE @DelimLen INT = LEN(@Delimiter);
    DECLARE @Idx      INT = 1;
    DECLARE @Start    INT = 1;
    DECLARE @End      INT;

    WHILE @Idx <= @Position
    BEGIN
        SET @End = CHARINDEX(@Delimiter, @InputStr, @Start);

        IF @End = 0
        BEGIN
            IF @Idx = @Position
                SET @Result = SUBSTRING(@InputStr, @Start, LEN(@InputStr) - @Start + 1);
            ELSE
                SET @Result = NULL;  -- Position이 범위를 초과한 경우
            BREAK;
        END

        IF @Idx = @Position
        BEGIN
            SET @Result = SUBSTRING(@InputStr, @Start, @End - @Start);
            BREAK;
        END

        SET @Start = @End + @DelimLen;
        SET @Idx = @Idx + 1;
    END

    RETURN @Result;
END