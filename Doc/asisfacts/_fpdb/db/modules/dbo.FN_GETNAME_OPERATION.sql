CREATE FUNCTION [dbo].[FN_GETNAME_OPERATION]
(@str1 nvarchar(MAX), @str2 nvarchar(MAX), @str3 nvarchar(MAX), @str4 nvarchar(MAX), @str5 nvarchar(MAX), @str6 nvarchar(MAX))
RETURNS nvarchar(MAX)
WITH EXEC AS CALLER
AS
BEGIN
DECLARE @retVal nvarchar(max);

	set @retVal = (select TOP 1 OPERATION_NAME from SCM_OPERATION_M where COMPANY_ID = @str1 and DIVISION_ID = @str2 and SITE_ID = @str3 and OPERATION_ID = @str6 group by OPERATION_NAME)

	RETURN @retVal;
END
