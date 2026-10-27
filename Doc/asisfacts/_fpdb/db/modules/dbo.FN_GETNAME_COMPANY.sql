CREATE FUNCTION [dbo].[FN_GETNAME_COMPANY]
(@str1 nvarchar(MAX))
RETURNS nvarchar(MAX)
WITH EXEC AS CALLER
AS
BEGIN
DECLARE @retVal nvarchar(max);

	set @retVal = (select COMPANY_NAME from SCM_COMPANY_M where COMPANY_ID = @str1 group by COMPANY_NAME)

	RETURN @retVal;
END
