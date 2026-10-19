CREATE FUNCTION [dbo].[FN_GET_CHECK_LOG_RUN_TIME]
(
    @prog_name     nvarchar(max)     
	,@chk_date int = 20
)
RETURNS TABLE
AS
RETURN
(

SELECT PROGRAM_NAME , EVENT_DATE , EVENT_DATE_END , DATEDIFF(MINUTE,EVENT_DATE,EVENT_DATE_END) AS [RUN_TIME(M)] FROM
(
	select  
	(
		select TOP 1 EVENT_DATE from scm_sys_log_batch t2 WITH(NOLOCK)
		where 1 = 1 
		AND t2.PROGRAM_NAME = @prog_name
		AND T2.LOG_TYPE = 'END'
		AND T.EVENT_DATE <= T2.EVENT_DATE
		ORDER BY T2.EVENT_DATE ASC
	) AS EVENT_DATE_END
	, EVENT_DATE , PROGRAM_NAME 
	from scm_sys_log_batch t WITH(NOLOCK)
	where 1 = 1 
	AND t.PROGRAM_NAME = @prog_name
	and convert(char(8), event_date, 112) >= convert(char(8), getdate()-@chk_date, 112)
	AND LOG_TYPE = 'START'
) AS LIST
--ORDER BY EVENT_DATE DESC
)