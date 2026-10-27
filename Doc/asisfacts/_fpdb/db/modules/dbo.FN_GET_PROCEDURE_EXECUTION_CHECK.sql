
-- ================================================================================================
-- Program ID          : 
-- Program Name        : PROCEDURE_EXECUTION_CHECK
-- Param               : procedure name
--                       
-- Batch Period        : 
-- Description         : 프로시저 중복실행 방지를 위한 로직
--                       
--
-- Source System       : 
-- Destination System  : FP SDB
-- Source Table        : 
-- Destination Table   : 
-- Create(Update) Date : 
-- Author              : FP Pjt.  
-- Version             : 1.0
-- ================================================================================================

CREATE FUNCTION [dbo].[FN_GET_PROCEDURE_EXECUTION_CHECK]
(
    @p_procname    NVARCHAR(500)
)
RETURNS INT --NVARCHAR(150)
AS

BEGIN

	declare @return_cnt INT = 0;

	select @return_cnt = count(*)
	--object_name(st.objectid) as ProcName , *
	  from sys.sysprocesses as qs 
	       CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) st 
	       JOIN SYS.OBJECTS as o
	    on st.objectid = o.object_id
	   and o.type = 'P'
	 where object_name(st.objectid) is not null
	--and qs.status = 'runnable'
	   and o.name = @p_procname

	/*
	select @return_cnt = count(*)
	-- object_name(st.objectid) as ProcName, 0.name, * 
	from
	(
	SELECT * FROM sys.dm_exec_requests 
	where sql_handle is not null
	) a 
	CROSS APPLY  sys.dm_exec_sql_text(a.sql_handle) st 
	join SYS.OBJECTS as o
	on st.objectid = o.object_id
	and o.type = 'P'
	--and a.status = 'running'
	and o.name = @p_procname
	*/


	RETURN @return_cnt

END
