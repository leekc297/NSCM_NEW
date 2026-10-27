create function [dbo].[FN_greatest] (@str1 nvarchar(max),@str2 nvarchar(max))
RETURNS nvarchar(max)
BEGIN

	DECLARE @retVal nvarchar(max);

	set @retVal = (select case when @str1<=@str2 then @str2 else @str1 end as retVal)

	RETURN @retVal;
END;
