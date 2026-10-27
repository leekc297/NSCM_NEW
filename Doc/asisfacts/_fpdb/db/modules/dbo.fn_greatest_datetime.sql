create FUNCTION [dbo].[fn_greatest_datetime](@first as datetime, @second as datetime)
returns datetime
begin
    if @first is null or @second is null
        return null
    if @first > @second
        return @first
    return @second
end
