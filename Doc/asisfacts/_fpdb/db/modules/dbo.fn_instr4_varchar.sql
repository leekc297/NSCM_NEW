CREATE FUNCTION [dbo].[fn_instr4_varchar](@str1 as varchar(max), @str2 as varchar(max), @pos as int, @occurrence as int)
returns int
begin
    if( @str1 is NULL) or (@str2 is NULL) or (@pos is NULL) or (@pos = 0) or (@occurrence is NULL) or ( @occurrence < 1 )
        return NULL

    if( @pos < 0 )
    begin 
        while( ([dbo].[fn_length_varchar](@str2)-@pos-1) <= [dbo].[fn_length_varchar](@str1) )
        begin

            if( substring(@str1, [dbo].[fn_length_varchar](@str1) + @pos + 1, [dbo].[fn_length_varchar](@str2)) = @str2 )
            begin
                select @occurrence = @occurrence-1
                if @occurrence < 1
                    return [dbo].[fn_length_varchar](@str1) + @pos + 1
            end
            select @pos = @pos-1
        end
        return 0
    end
   
    select @pos = @pos-1
    while @occurrence > 0
    begin
        set @pos = charindex(@str2, @str1, @pos+1)
        if @pos = 0
            return 0
        select @occurrence = @occurrence-1
    end
    return @pos
end
