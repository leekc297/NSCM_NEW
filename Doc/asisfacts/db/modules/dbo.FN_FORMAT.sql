
/*
 * Program ID   : [FN_FORMAT_TEXT]                                                             
 * Description  :  닷넷의	String.Format 유사함수
 * ex : 
		select   dbo.FN_FORMAT_TEXT('select  ''{0}'', {1}, {2}',  'AAA', 2, 3, default, default)
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2024/04/17  KSK			Initial Release 
 *                                                                                                  
*/
CREATE function [dbo].[FN_FORMAT]
(
    @String  nvarchar(max),
    @P0  sql_variant ,
    @P1  sql_variant ,
    @P2  sql_variant ,
	@P3  sql_variant ,
	@P4  sql_variant = NULL
)
returns nvarchar(max)
as
begin 
	if @P0 is not null set @String = replace(@String, '{0}',  cast(@P0 as Nvarchar(4000)))
	if @P1 is not null set @String = replace(@String, '{1}',  cast(@P1 as Nvarchar(4000)))
	if @P2 is not null set @String = replace(@String, '{2}',  cast(@P2 as Nvarchar(4000)))
	if @P3 is not null set @String = replace(@String, '{3}',  cast(@P3 as Nvarchar(4000)))
	if @P4 is not null set @String = replace(@String, '{4}',  cast(@P4 as Nvarchar(4000)))
	return @String;
end

