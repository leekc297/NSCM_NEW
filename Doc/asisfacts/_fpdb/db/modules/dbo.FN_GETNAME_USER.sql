CREATE FUNCTION [dbo].[FN_GETNAME_USER]
(@str1 nvarchar(MAX))
RETURNS nvarchar(MAX)
WITH EXEC AS CALLER
AS
BEGIN
DECLARE @retVal nvarchar(max);

	set @retVal = (select USER_NAME from TH_UIS_USER_DETAIL where USER_ID = @str1 group by USER_NAME)

	RETURN @retVal;
END
