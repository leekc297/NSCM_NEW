SELECT j.name job, j.enabled, s.name sched, s.freq_type, s.freq_interval, s.freq_subday_type, s.freq_subday_interval, s.active_start_time
FROM msdb.dbo.sysjobs j LEFT JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id LEFT JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
WHERE j.name IN ('JOB.PR_DM_DNM_SALES_RESULT') OR j.name LIKE N'JOB_RFC.매출%'
