CREATE FUNCTION [dbo].[FN_GETNAME_FACTORY]
(@str1 nvarchar(MAX), @str2 nvarchar(MAX), @str3 nvarchar(MAX), @str4 nvarchar(MAX))
RETURNS nvarchar(MAX)
WITH EXEC AS CALLER
AS
BEGIN
DECLARE @retVal nvarchar(max);

	set @retVal = (select FACTORY_NAME from SCM_FACTORY_M where COMPANY_ID = @str1 and DIVISION_ID = @str2 and SITE_ID = @str3 and FACTORY_ID = @str4 group by FACTORY_NAME)

	RETURN @retVal;
END
