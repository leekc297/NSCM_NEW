/*
 * Program ID   : SCM0016_GET_BATCH_STEP_INFO
 * Description  : JOB SCHEDULE STEP 정보 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/03/02   PJS   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * ex)
 * exec SCM0016_GET_BATCH_STEP_INFO @p_job_id='{4B46F507-0745-468E-AD76-0A5EC082910B}'
 */

CREATE PROCEDURE [dbo].[SCM0016_GET_BATCH_STEP_INFO]
  @p_job_id NVARCHAR(MAX)
AS
BEGIN
		
		
	SELECT
		  a.[job_id] AS [job_id]
		, a.[name] AS [job_name]
		, e.[step_uid] AS [step_uid]
		, e.[step_id] AS [step_id]
		, e.[step_name] AS [step_name]
		, CASE e.[subsystem]
			WHEN 'ActiveScripting' THEN 'ActiveX Script'
			WHEN 'CmdExec' THEN 'Operating system (CmdExec)'
			WHEN 'PowerShell' THEN 'PowerShell'
			WHEN 'Distribution' THEN 'Replication Distributor'
			WHEN 'Merge' THEN 'Replication Merge'
			WHEN 'QueueReader' THEN 'Replication Queue Reader'
			WHEN 'Snapshot' THEN 'Replication Snapshot'
			WHEN 'LogReader' THEN 'Replication Transaction-Log Reader'
			WHEN 'ANALYSISCOMMAND' THEN 'SQL Server Analysis Services Command'
			WHEN 'ANALYSISQUERY' THEN 'SQL Server Analysis Services Query'
			WHEN 'SSIS' THEN 'SQL Server Integration Services Package'
			WHEN 'TSQL' THEN 'Transact-SQL script (T-SQL)'
			ELSE e.subsystem
		  END AS [step_type]
		--, [sPROX].[name] AS [RunAs]
		--, e.[database_name] AS [Database]
		, e.[command] AS [exec_command]
		, CASE e.[on_success_action]
			WHEN 1 THEN 'Quit the job reporting success'
			WHEN 2 THEN 'Quit the job reporting failure'
			WHEN 3 THEN 'Go to the next step'
			WHEN 4 THEN 'Go to Step: '
						+ QUOTENAME(CAST(e.[on_success_step_id] AS VARCHAR(3)))
						+ ' '
						+ [sOSSTP].[step_name]
		  END AS [on_success_action]
		, e.[retry_attempts] AS [retry_attempts]
		, e.[retry_interval] AS [retry_interval] -- [retry_interval (Minutes)]
		, CASE e.[on_fail_action]
			WHEN 1 THEN 'Quit the job reporting success'
			WHEN 2 THEN 'Quit the job reporting failure'
			WHEN 3 THEN 'Go to the next step'
			WHEN 4 THEN 'Go to Step: '
						+ QUOTENAME(CAST(e.[on_fail_step_id] AS VARCHAR(3)))
						+ ' '
						+ [sOFSTP].[step_name]
		  END AS [on_failure_action]
	FROM [msdb].[dbo].[sysjobsteps] AS e
		 INNER JOIN [msdb].[dbo].[sysjobs]     AS a    ON e.[job_id]             = a.[job_id]
		 LEFT  JOIN [msdb].[dbo].[sysjobsteps] AS [sOSSTP]  ON e.[job_id]             = [sOSSTP].[job_id]
														   AND e.[on_success_step_id] = [sOSSTP].[step_id]
		 LEFT  JOIN [msdb].[dbo].[sysjobsteps] AS [sOFSTP]  ON e.[job_id]             = [sOFSTP].[job_id]
														   AND e.[on_fail_step_id]    = [sOFSTP].[step_id]
	   --  LEFT JOIN [msdb].[dbo].[sysproxies] AS [sPROX]     ON e.[proxy_id]           = [sPROX].[proxy_id]
	where 1=1
	  and a.job_id =@p_job_id	 
	ORDER BY [job_name], [step_id]
   ;
END
