CREATE function [dbo].[FN_least] (@str1 nvarchar(max),@str2 nvarchar(max))
RETURNS nvarchar(max)
BEGIN

	DECLARE @retVal nvarchar(max);

	set @retVal = (select case when @str1<=@str2 then @str1 else @str2 end as retVal)

	RETURN @retVal;
END;
