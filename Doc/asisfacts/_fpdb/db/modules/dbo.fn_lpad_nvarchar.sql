CREATE FUNCTION [dbo].[fn_lpad_nvarchar](
    @left as nvarchar(max), 
    @n as int, 
    @pad as nvarchar(max) = ' ')
returns nvarchar(max)
begin

    return [dbo].[fn_pad_nvarchar](1, @left, @n, @pad)
end
