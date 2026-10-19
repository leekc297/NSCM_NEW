CREATE  procedure testproc as 
begin


	update aaa 
	set prog_stat = 99
	-- select top 10 *
	from  scp_mst_capa_version  with(nolock)-- #temp 
	where 1=2

end;
