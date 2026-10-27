create FUNCTION [dbo].[fn_greatest_float](@first as float, @second as float)
returns float
begin
    if @first is null or @second is null
        return null
    if @first > @second
        return @first
    return @second
end
