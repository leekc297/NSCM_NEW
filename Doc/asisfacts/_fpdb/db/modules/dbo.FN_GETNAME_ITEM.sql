CREATE FUNCTION [dbo].[FN_GETNAME_ITEM]
(@str1 nvarchar(MAX), @str2 nvarchar(MAX), @str3 nvarchar(MAX))
RETURNS nvarchar(MAX)
WITH EXEC AS CALLER
AS
BEGIN
DECLARE @retVal nvarchar(max);

	set @retVal = (select ITEM_NAME from SCM_ITEM_M where COMPANY_ID = @str1 and DIVISION_ID = @str2 and ITEM_ID = @str3 group by ITEM_NAME)

	RETURN @retVal;
END
