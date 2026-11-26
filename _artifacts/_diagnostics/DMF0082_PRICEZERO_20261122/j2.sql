SELECT j.name job, j.enabled, st.step_id, st.step_name, LEFT(st.command,300) cmd FROM msdb.dbo.sysjobs j JOIN msdb.dbo.sysjobsteps st ON st.job_id=j.job_id WHERE st.command LIKE '%SALES_RESULT%'
