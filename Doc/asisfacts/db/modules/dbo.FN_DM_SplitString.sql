CREATE FUNCTION dbo.FN_DM_SplitString(@String NVARCHAR(MAX), @Delimiter NVARCHAR(MAX))
RETURNS @ReturnTable TABLE (Id INT IDENTITY(1, 1), Value NVARCHAR(MAX)) AS

BEGIN
	DECLARE @Value NVARCHAR(MAX)
	DECLARE @Pos INT

	SET @String = @String + @Delimiter
	SET @Pos = CHARINDEX(@Delimiter, @String, 1)

	WHILE @Pos <> 0
	BEGIN
		SET @Value = LTRIM(RTRIM(LEFT(@String, @Pos - 1)))

		INSERT INTO @ReturnTable (Value)
		SELECT @Value

		SET @String = RIGHT(@String, LEN(@String) - @Pos - LEN(@Delimiter) + 1)
		SET @Pos = CHARINDEX(@Delimiter, @String, 1)
	END

	RETURN
END