CREATE FUNCTION [dbo].[FN_GETNAME_PLANT]
(@str1 nvarchar(MAX), @str2 nvarchar(MAX), @str3 nvarchar(MAX), @str4 nvarchar(MAX))
RETURNS nvarchar(MAX)
WITH EXEC AS CALLER
AS
BEGIN
DECLARE @retVal nvarchar(max);

	set @retVal = (select PLANT_NAME from SCM_PLANT_M where COMPANY_ID = @str1 and DIVISION_ID = @str2 and SITE_ID = @str3 and PLANT_ID = @str4 group by PLANT_NAME)
 
	RETURN @retVal;
END
