create FUNCTION [dbo].[fn_length_varchar](@s varchar(max))
returns int
as 
begin
  return len(replace(@s, ' ', '.'))
end
