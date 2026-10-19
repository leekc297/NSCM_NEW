
CREATE FUNCTION [dbo].[UF_FX_Split]
(
   @String		VARCHAR(MAX)
  ,@Separator	CHAR(1) = ','
)
RETURNS @SplitTable TABLE
(
	Pos			INT,
	Element		VARCHAR(1000)
)
AS
BEGIN
	DECLARE @Num	INT;
	SELECT @Num = 1;
	DECLARE @NUMS TABLE(n INT NOT NULL);

	WHILE @Num < LEN(@String) + 1 
	BEGIN
		INSERT INTO @NUMS(n) VALUES(@Num)
		SET @Num = @Num + 1
	END;

	INSERT INTO @SplitTable
	SELECT n - LEN(REPLACE(LEFT(s, n), @Separator, '')) + 1 as pos, 
		   SUBSTRING(s, n, CHARINDEX(@Separator, s + @Separator, n) - n) as element
	FROM (SELECT @String as s) as A
	INNER JOIN @NUMS
		    ON n <= LEN(s)
		   AND SUBSTRING(@Separator + s, n, 1) = @Separator;

	RETURN;
END




