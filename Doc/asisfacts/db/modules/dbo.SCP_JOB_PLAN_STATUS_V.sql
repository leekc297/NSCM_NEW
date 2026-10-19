--DROP VIEW SCP_JOB_PLAN_STATUS 

CREATE VIEW [dbo].[SCP_JOB_PLAN_STATUS_V]
AS

/**        
  * PROJECT       : LG CHEM SCP PRJ.        
  * VIEW NAME     : SCP_JOB_PLAN_STATUS_V      
  * DESCRIPTION   : 개발 편의성을 위한 SCP 엔진 실행주기 조회용 뷰
  *               : 도구>>옵션>>환경>키보드>쿼리바로가기>CTL+7 에 등록하여 사용중
  *                 SELECT * FROM SCP_JOB_PLAN_STATUS_V  WITH (NOLOCK) ORDER BY ORD,FREQ_INTERVAL, FREQUENCY, JOBNAME
  * PROGRAM HISTORY        
  *--------------------------------------------------------------        
  *  DATE      IN CHARGE           DESCRIPTION        
  *--------------------------------------------------------------        
  * 2018-06-01  KTH     신규생성      
  */        

--  select * from SCM_SYS_LOG_BATCH  WITH (NOLOCK) WHERE LOG_TYPE ='ERROR' order by creation_date desc


SELECT * 
FROM (
    SELECT
        jobs.name as jobname
       , CASE convert(nvarchar(3),freq_type,3)
          WHEN  4 THEN N'실행주기 : ' + CAST(freq_interval AS VARCHAR(3)) + N' 일(s) 매일,    '
          WHEN  8 THEN N'실행주기 : ' + CAST(freq_recurrence_factor AS VARCHAR(3))
                      + N' 주(s) 매주'
                      + CASE WHEN freq_interval &  1 =  1 THEN N'일'   ELSE '' END
                      + CASE WHEN freq_interval &  2 =  2 THEN N', 월' ELSE '' END
                      + CASE WHEN freq_interval &  4 =  4 THEN N', 화' ELSE '' END
                      + CASE WHEN freq_interval &  8 =  8 THEN N', 수' ELSE '' END
                      + CASE WHEN freq_interval & 16 = 16 THEN N', 목' ELSE '' END
                      + CASE WHEN freq_interval & 32 = 32 THEN N', 금' ELSE '' END
                      + CASE WHEN freq_interval & 64 = 64 THEN N', 토' ELSE '' END
          WHEN 16 THEN N'하루 한번 ' + CAST(freq_interval AS VARCHAR(3))
                       + N' 모든 '
                       + CAST(freq_recurrence_factor AS VARCHAR(3)) + N' 월(S)'
          WHEN 32 THEN N'발생 '
                       + CASE freq_relative_interval
                          WHEN  1 THEN N'첫째'
                          WHEN  2 THEN N'둘째'
                          WHEN  4 THEN N'셋째'
                          WHEN  8 THEN N'넷째'
                          WHEN 16 THEN N'마지막'
                         END
                       + ' '
                       + CASE freq_interval
                          WHEN  1 THEN N'일'
                          WHEN  2 THEN N'월'
                          WHEN  3 THEN N'화'
                          WHEN  4 THEN N'수'
                          WHEN  5 THEN N'목'
                          WHEN  6 THEN N'금'
                          WHEN  7 THEN N'토'
                          WHEN  8 THEN N'일'
                          WHEN  9 THEN N'평일'
                          WHEN 10 THEN N'주말'
                         END
                       + N' 모든 ' + CAST(freq_recurrence_factor AS VARCHAR(3))
                       + N' 월(s)'
        END --AS Recurrence
         + CASE convert(nvarchar(3),freq_subday_type,3) 
          WHEN 1 THEN N' '
                + STUFF(
                   STUFF(RIGHT('000000' + CAST(active_start_time AS VARCHAR(6)), 6)
                                  , 3, 0, ':')
                              , 6, 0, ':')
          WHEN 2 THEN N'주기적 발생 '
                      + CAST(freq_subday_interval AS VARCHAR(3)) + N' 초(s) 간격 '
                      + STUFF(
                     STUFF(RIGHT('000000' + CAST(active_start_time AS VARCHAR(6)), 6)
                                  , 3, 0, ':')
                              , 6, 0, ':')
                      + ' & '
                      + STUFF(
                      STUFF(RIGHT('000000' + CAST(active_end_time AS VARCHAR(6)), 6)
                                  , 3, 0, ':')
                              , 6, 0, ':')
          WHEN 4 THEN N'주기적 발생 '
                      + CAST(freq_subday_interval AS VARCHAR(3)) + N' 분(s) 간격 '
                      + STUFF(
                     STUFF(RIGHT('000000' + CAST(active_start_time AS VARCHAR(6)), 6)
                                  , 3, 0, ':')
                              , 6, 0, ':')
                      + ' & '
                      + STUFF(
                      STUFF(RIGHT('000000' + CAST(active_end_time AS VARCHAR(6)), 6)
                                  , 3, 0, ':')
                              , 6, 0, ':')
          WHEN 8 THEN N'주기적 발생 '
                      + CAST(freq_subday_interval AS VARCHAR(3)) + N' 시간(s) 간격 '
                      + STUFF(
                      STUFF(RIGHT('000000' + CAST(active_start_time AS VARCHAR(6)), 6)
                                  , 3, 0, ':')
                              , 6, 0, ':')
                      + ' & '
                      + STUFF(
                      STUFF(RIGHT('000000' + CAST(active_end_time AS VARCHAR(6)), 6)
                                  , 3, 0, ':')
                              , 6, 0, ':')
        END Frequency
              , description
          , d.command 
      , CASE  convert(nvarchar(3),sSCH.enabled)
          WHEN 1 THEN N'Y'
          WHEN 0 THEN N'N'
        END AS IsEnabled
      , CASE
          WHEN convert(nvarchar(3),freq_type,3) =  64           THEN N'SQL Server 시작 시 마다'
          WHEN convert(nvarchar(3),freq_type,3) = 128           THEN N'서버가 유휴 할때마다'
          WHEN convert(nvarchar(3),freq_type,3) IN (4,8,16,32)  THEN N'되풀이'
          WHEN convert(nvarchar(3),freq_type,3)  = 1            THEN N'한번만'
        END ScheduleType
      , CASE convert(nvarchar(3),freq_type,3)
          WHEN   1 THEN N'1번'
          WHEN   4 THEN N'매일'
          WHEN   8 THEN N'매주'
          WHEN  16 THEN N'매월'
          WHEN  32 THEN N'매월'
          WHEN  64 THEN N'SQL Server 시작 시 마다'
          WHEN 128 THEN N'서버가 유휴 할때마다'
        END Occurrence
   
    
      , sSCH.date_created AS ScheduleCreatedOn
      , sSCH.date_modified AS ScheduleLastModifiedOn
      , freq_interval
      , (CASE WHEN jobs.name LIKE '%PRE%'   THEN 1
              WHEN jobs.name LIKE '%MAIN%'  THEN 2
              WHEN jobs.name LIKE '%SEMI%'  THEN 3
              WHEN jobs.name LIKE '%FINAL%' THEN 4
              ELSE 9 END ) AS ord
   FROM
      msdb.dbo.sysjobschedules as sJOBSCH with(nolock)
      LEFT OUTER JOIN msdb.dbo.sysschedules AS sSCH with(nolock) ON sJOBSCH.schedule_id = sSCH.schedule_id
      LEFT OUTER JOIN msdb.dbo.sysjobs as jobs WITH(NOLOCK) ON sJOBSCH.job_id=jobs.job_id
      INNER JOIN msdb.dbo.sysjobsteps D ON  jobs.job_id = D.job_id
  WHERE 0 = 0
  AND  jobs.name LIKE 'JOB.SCMPROD_PLAN%'
  --AND  jobs.name NOT LIKE '%SUPPLY%'
  AND  jobs.name NOT LIKE '%ID%'
) X
--ORDER BY ord,freq_interval, frequency, jobname

