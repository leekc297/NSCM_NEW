/*
 * Program ID   : SCM0016_GET_BATCH_LOG_HIST
 * Description  : 일자별 BATCH LOG 정보 조회(최근 100개)
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/03/02   PJS   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * ex)
 * exec SCM0016_GET_BATCH_LOG_HIST @p_job_id='{4B46F507-0745-468E-AD76-0A5EC082910B}'
 */

CREATE PROCEDURE [dbo].[SCM0016_GET_BATCH_LOG_HIST]
  @p_job_id NVARCHAR(MAX)
AS
BEGIN
		
		
	SELECT t.*
	  FROM (
	  SELECT
			[job_id]
		  , CASE WHEN c.[run_date] IS NULL OR c.[run_time] IS NULL THEN NULL
				 ELSE convert(varchar, CAST( CAST(c.[run_date] AS CHAR(8)) + ' '  + STUFF( STUFF(RIGHT('000000' + CAST(c.[run_time] AS VARCHAR(6)),  6), 3, 0, ':'), 6, 0, ':') AS DATETIME),120)
			END AS [run_date]	  
		  , c.[run_status]
		  , DBO.FN_GET_LOOKUP_CODE_DESC('JOB_RUN_STATUS',c.[run_status]) AS [run_status_name]
		  , STUFF(STUFF(RIGHT('000000' + CAST(c.[run_duration] AS VARCHAR(6)),  6) , 3, 0, ':') , 6, 0, ':')   AS [run_duration] --[LastRunDuration (HH:MM:SS)]
		  , [message] AS run_status_message
		  , ROW_NUMBER() OVER (	PARTITION BY [job_id] ORDER BY [run_date] DESC, [run_time] DESC  ) AS RowNumber
		FROM [msdb].[dbo].[sysjobhistory] c
		WHERE [step_id] = 0
		--AND job_id ='{4B46F507-0745-468E-AD76-0A5EC082910B}'
		AND job_id =@p_job_id
		   ) t
	where t.RowNumber <=100
	order by RowNumber	   
   ;
END
