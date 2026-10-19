/*
 * Program ID   : SCM0016_GET_BATCH_LOG
 * Description  : BATCH LOG(JOB SCHEDULE) 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/03/02   PJS   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * ex)
 * exec SCM0016_GET_BATCH_LOG
 */

CREATE PROCEDURE [dbo].[SCM0016_GET_BATCH_LOG]
  @p_run_status		NVARCHAR(MAX) =''
AS
BEGIN
		
	SELECT
		  a.[job_id] AS [job_id]
		, a.[name] AS [job_name]
		, a.[description] AS [job_description]
		, CASE a.[enabled] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END AS [is_enabled]
		--, a.[date_created] AS [JobCreatedOn]
		--, a.[date_modified] AS [JobLastModifiedOn]
		--, d.[name] AS [OriginatingServerName]
		, e.[step_id] AS [step_id]
		, e.[step_name] AS [step_name]
		, CASE WHEN f.[schedule_uid] IS NULL THEN 'No' ELSE 'Yes' END AS [is_scheduled]
		, f.[schedule_uid] AS [schedule_uid]
		, f.[name] AS [schedule_name]
		, CASE WHEN c.[run_date] IS NULL OR c.[run_time] IS NULL THEN NULL
			   ELSE convert(varchar, CAST( CAST(c.[run_date] AS CHAR(8)) + ' '  + STUFF( STUFF(RIGHT('000000' + CAST(c.[run_time] AS VARCHAR(6)),  6), 3, 0, ':'), 6, 0, ':') AS DATETIME),120)
		  END AS [run_date]
		, c.[run_status]
		, DBO.FN_GET_LOOKUP_CODE_DESC('JOB_RUN_STATUS',c.[run_status]) AS [run_status_name]
		, STUFF(STUFF(RIGHT('000000' + CAST(c.[run_duration] AS VARCHAR(6)),  6) , 3, 0, ':') , 6, 0, ':')   AS [run_duration] --[LastRunDuration (HH:MM:SS)]
		, c.[message] AS [run_status_message]
		, CASE b.[NextRunDate]  WHEN 0 THEN NULL
			ELSE convert(varchar, CAST( CAST(b.[NextRunDate] AS CHAR(8)) + ' ' + STUFF( STUFF(RIGHT('000000' + CAST(b.[NextRunTime] AS VARCHAR(6)),  6), 3, 0, ':'), 6, 0, ':') AS DATETIME),120)
		  END AS [next_run_date]

	 FROM [msdb].[dbo].[sysjobs] AS a
		  LEFT JOIN (
					SELECT
						  [job_id]
						, [schedule_id]
						, MIN([next_run_date]) AS [NextRunDate]
						, MIN([next_run_time]) AS [NextRunTime]
					FROM [msdb].[dbo].[sysjobschedules]
					GROUP BY [job_id],[schedule_id]
				  ) AS b ON a.[job_id] = b.[job_id]
		  LEFT JOIN (
					SELECT
						[job_id]
						, [run_date]
						, [run_time]
						, [run_status]
						, [run_duration]
						, [message]
						, ROW_NUMBER() OVER ( PARTITION BY [job_id]	ORDER BY [run_date] DESC, [run_time] DESC  ) AS RowNumber
					FROM [msdb].[dbo].[sysjobhistory]
					WHERE [step_id] = 0
				) AS c ON a.[job_id] = c.[job_id] AND c.[RowNumber] = 1
		  LEFT JOIN [msdb].[sys].[servers]             AS d    ON a.[originating_server_id] = d.[server_id]
		  LEFT JOIN [msdb].[dbo].[sysjobsteps]         AS e   ON a.[job_id]                = e.[job_id] AND a.[start_step_id] = e.[step_id]
		  LEFT JOIN [msdb].[dbo].[sysschedules]        AS f    ON b.[schedule_id]        = f.[schedule_id]
	WHERE f.[schedule_uid] IS NOT NULL
	  AND a.[enabled] ='1'  -- '0'
	  AND ( (@p_run_status IS NULL OR  @p_run_status ='') OR ( c.[run_status]  IN (SELECT token FROM dbo.String_Split(@p_run_status	,',')) ) )
	ORDER BY [job_name]
   ;
END
