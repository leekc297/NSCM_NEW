CREATE FUNCTION [dbo].[FN_GETNAME_DIVISION]
(@str1 nvarchar(MAX), @str2 nvarchar(MAX))
RETURNS nvarchar(MAX)
WITH EXEC AS CALLER
AS
BEGIN
DECLARE @retVal nvarchar(max);

	set @retVal = (select DIVISION_NAME from SCM_DIVISION_M where COMPANY_ID = @str1 and DIVISION_ID = @str2 group by DIVISION_NAME)

	RETURN @retVal;
END
