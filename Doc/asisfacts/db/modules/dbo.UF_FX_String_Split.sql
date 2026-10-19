Create FUNCTION [dbo].[UF_FX_String_Split] ( @Str NVARCHAR(MAX) ,@Delim VARCHAR(1) ) 
RETURNS @RtnValue TABLE ( nr INT IDENTITY(1, 1) ,token NVARCHAR(MAX) ) 
AS 
BEGIN
  DECLARE @Idx INT
  DECLARE @FoundIdx INT 
  SET @Idx = 1
  SET @FoundIdx = CHARINDEX(@Delim, @Str)
  WHILE (@FoundIdx > 0)
  BEGIN 
    INSERT INTO @RtnValue (token)
    SELECT LTRIM(RTRIM(SUBSTRING(@Str, 1, @FoundIdx - 1))) 
    SET @Str = SUBSTRING(@Str, @FoundIdx + 1, len(@str) - @FoundIdx)
    SET @Idx = @Idx + 1 
    SET @FoundIdx = CHARINDEX(@Delim, @Str)
  END
  INSERT INTO @RtnValue (token)
  SELECT LTRIM(RTRIM(@Str)) 

  RETURN
END 
