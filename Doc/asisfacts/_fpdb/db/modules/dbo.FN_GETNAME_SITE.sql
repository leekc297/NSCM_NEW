CREATE FUNCTION [dbo].[FN_GETNAME_SITE]
(@str1 nvarchar(MAX), @str2 nvarchar(MAX), @str3 nvarchar(MAX))
RETURNS nvarchar(MAX)
WITH EXEC AS CALLER
AS
BEGIN
DECLARE @retVal nvarchar(max);

	set @retVal = (select SITE_NAME from SCM_SITE_M where COMPANY_ID = @str1 and SITE_ID = @str3 group by SITE_NAME)

	RETURN @retVal;
END
