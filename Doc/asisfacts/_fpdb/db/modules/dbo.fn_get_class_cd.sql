CREATE FUNCTION [dbo].[fn_get_class_cd]
(@source_text nvarchar(50),@class_level integer )
RETURNS nvarchar(10)
WITH EXEC AS CALLER
AS
BEGIN
	declare @class_text nvarchar(50)
	declare @cal_text nvarchar(50)
	declare @from_index integer
	declare @to_index integer

	select @from_index = CHARINDEX('[',@source_text)
	select @to_index   = CHARINDEX(']',@source_text)

	if @from_index = 0
	     return ''
     
	if @to_index = 0
	     return '' 

	select @class_text =  substring(@source_text, @from_index+1, @to_index-@from_index-1)

	if @class_level = 1 
		select @cal_text =  substring(@class_text,1,1)
	else if @class_level = 2 
		select @cal_text =  substring(@class_text,2,2)
	else if @class_level = 3 
		select @cal_text =  substring(@class_text,4,2)
	else if @class_level = 4 
		select @cal_text = substring(@class_text,6,2)
	else if @class_level = 0 
		select @cal_text = @class_text

    return @cal_text

END
