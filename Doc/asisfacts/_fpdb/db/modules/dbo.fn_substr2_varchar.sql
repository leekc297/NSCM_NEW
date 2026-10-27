CREATE FUNCTION [dbo].[fn_substr2_varchar](@src as varchar(max), @pos as int)
returns varchar(max)
begin
    declare 
        @strlen as int

    if( @src is NULL) or (@pos is NULL )
        return NULL;
    select @strlen=[dbo].[fn_length_varchar](@src)
    if abs(@pos) > @strlen
        return NULL;

    if @pos = 0 
        select @pos = 1

    if @pos > 0 
    begin
        return substring(@src, @pos, @strlen-@pos+1)
    end    
    return substring(@src, @strlen + @pos+1, -@pos)

end
