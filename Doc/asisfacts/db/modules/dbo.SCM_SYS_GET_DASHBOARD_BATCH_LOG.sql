/*
 * Program ID   : SCM_SYS_GET_DASHBOARD_BATCH_LOG
 * Description  : Dashboard용 BATCH LOG(JOB SCHEDULE) 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2025.08.04   kjiyoon		Initial Release
 */

CREATE PROCEDURE [dbo].[SCM_SYS_GET_DASHBOARD_BATCH_LOG]
  @P_YYYYMMDD NVARCHAR(8) = NULL
AS
BEGIN

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	--DECLARE @V_DATE DATETIME;

	--IF @P_YYYYMMDD IS NULL
	--	SET @V_DATE = CONVERT(DATETIME, FORMAT(GETDATE(), 'yyyyMMdd'))
	--ELSE
	--	SET @V_DATE = CONVERT(DATETIME, @P_YYYYMMDD)

		
	--PRINT @V_DATE

	--#TEMP_BASE_DATA
	WITH W_TOTAL_LOG AS (
	---------------------------------------------------------------------------------------------
	--공통 LOG
	---------------------------------------------------------------------------------------------
	SELECT SYSTEM = CASE WHEN CHARINDEX('SCM', A.PROGRAM_NAME) > 0 AND CHARINDEX('ADM', A.PROGRAM_NAME) > 0 THEN 'SCM'
						WHEN CHARINDEX('DM', A.PROGRAM_NAME) > 0 and a.PROGRAM_NAME not like '%addMy%' and a.PROGRAM_NAME not like '%admin%' THEN 'DM'
						WHEN CHARINDEX('OPT', A.PROGRAM_NAME) > 0 THEN 'OPT'
						WHEN CHARINDEX('SCP', A.PROGRAM_NAME) > 0 THEN 'SCP'
						WHEN CHARINDEX('SSP', A.PROGRAM_NAME) > 0 THEN 'SSP'
						WHEN CHARINDEX('RFC', A.PROGRAM_NAME) > 0 THEN 'RFC'
						WHEN CHARINDEX('SCM', A.PROGRAM_NAME) > 0 THEN 'SCM'
						WHEN CHARINDEX('FP', A.PROGRAM_NAME) > 0 THEN 'FP'
						WHEN CHARINDEX('XIF', A.PROGRAM_NAME) > 0 THEN 'INF'
						WHEN CHARINDEX('ERP', A.PROGRAM_NAME) > 0 THEN 'ERP'
						WHEN CHARINDEX('FN', A.PROGRAM_NAME) > 0 THEN 'FN'
						ELSE 'COMMON'
						END
		, A.PROGRAM_NAME
		, A.LOG_TYPE
		, A.LOG_COUNT
		, A.LOG_MESSAGE
		, A.DESCRIPTION
		, FORMAT(A.EVENT_DATE, 'yyyy-MM-dd hh:mm:ss') AS EVENT_DATE
		, FORMAT(A.CREATION_DATE, 'yyyy-MM-dd hh:mm:ss') AS CREATION_DATE
		, A.CREATED_BY
		, FORMAT(A.LAST_UPDATE_DATE, 'yyyy-MM-dd hh:mm:ss') AS LAST_UPDATE_DATE
		, A.LAST_UPDATED_BY
		, A.ATTRIBUTE1
		, A.ATTRIBUTE2
		, A.ATTRIBUTE3
		, A.ATTRIBUTE4
		, A.ATTRIBUTE5
		, A.ATTRIBUTE6
		, A.ATTRIBUTE7
		, A.ATTRIBUTE8
		, A.ATTRIBUTE9
		, A.ATTRIBUTE10
	FROM DBO.SCM_SYS_LOG_BATCH A WITH(NOLOCK)
	WHERE A.LOG_TYPE IN ( 'ERROR'  ,'EXCEPTION' )
	AND A.LAST_UPDATE_DATE > GETDATE() - 30
	UNION ALL
	---------------------------------------------------------------------------------------------
	--최적화 엔진 LOG
	---------------------------------------------------------------------------------------------
	SELECT 'OPT' AS SYSTEM
		  , A.PROGRAM_NAME
		  , A.STATUS_CODE AS LOG_TYPE
		  , NULL AS LOG_COUNT
		  , A.MESSAGE_TEXT AS LOG_MESSAGE
		  , NULL AS DESCRIPTION
		  , A.LOG_DATE AS EVENT_DATE
		  , A.INSERT_TIME AS CREATION_DATE
		  , A.INSERT_ID AS CREATED_BY
		  , A.UPDATE_TIME AS LAST_UPDATE_DATE
		  , A.UPDATE_ID AS LAST_UPDATED_BY
		  , CONCAT(N'SYSTEM_TYPE_CODE : ', A.SYSTEM_TYPE_CODE) AS ATTRIBUTE1
		  , CONCAT(N'PLAN_ID : ', A.PLAN_ID) AS ATTRIBUTE2
		  , CONCAT(N'SORT_ORDER_NO : ', A.SORT_ORDER_NO) AS ATTRIBUTE3
		  , CONCAT(N'PARAMETER_VALUE : ', A.PARAMETER_VALUE) AS ATTRIBUTE4
		  , NULL AS ATTRIBUTE5
		  , NULL AS ATTRIBUTE6
		  , NULL AS ATTRIBUTE7
		  , NULL AS ATTRIBUTE8
		  , NULL AS ATTRIBUTE9
		  , NULL AS ATTRIBUTE10
	  FROM OPTENG_SCP.DBO.SCP_OPT_ENG_ENGINE_DATA_CREATE_L_N A WITH(NOLOCK)
	 WHERE A.STATUS_CODE IN ( 'ERROR'  ,'EXCEPTION' )
	   AND A.LOG_DATE > GETDATE() - 30)
	SELECT A.SYSTEM
		 , A.PROGRAM_NAME
		 , A.LOG_TYPE
		 , 0 AS LOG_COUNT
		 , A.LOG_MESSAGE
		 , A.DESCRIPTION
		 , A.EVENT_DATE
		 , A.CREATION_DATE
		 , A.CREATED_BY
		 , A.LAST_UPDATE_DATE
		 , A.LAST_UPDATED_BY
		 , A.ATTRIBUTE1
		 , A.ATTRIBUTE2
		 , A.ATTRIBUTE3
		 , A.ATTRIBUTE4
		 , A.ATTRIBUTE5
		 , A.ATTRIBUTE6
		 , A.ATTRIBUTE7
		 , A.ATTRIBUTE8
		 , A.ATTRIBUTE9
		 , A.ATTRIBUTE10
	  INTO #TEMP_BASE_DATA
	  FROM W_TOTAL_LOG  A
	; 

	--#TEMP_FREQ_ERR_LIST
	SELECT DISTINCT X.PROGRAM_NAME
	  INTO #TEMP_FREQ_ERR_LIST
	  FROM #TEMP_BASE_DATA X
	  WHERE X.CREATION_DATE BETWEEN GETDATE() - 8 AND GETDATE() - 1;

	-----------------------------------------------------------------------
	--OUTPUT1. LOG LIST(24H)
	-----------------------------------------------------------------------
	SELECT *
		 , CASE WHEN ( SELECT COUNT(1) FROM #TEMP_FREQ_ERR_LIST Z WHERE Z.PROGRAM_NAME = X.PROGRAM_NAME ) = 0 THEN 'NEW' ELSE NULL END  NEW_ERROR , 'LAST_24' LAST_1DAY
	  FROM #TEMP_BASE_DATA X
	  WHERE X.CREATION_DATE > GETDATE() - 1
	  ORDER BY CREATION_DATE DESC;
  
	-----------------------------------------------------------------------
	--OUTPUT2. LOG LIST(30 DAYS)
	-----------------------------------------------------------------------
	 SELECT CONVERT( VARCHAR, CONVERT(DATE, X.CREATION_DATE) , 112) DATES
		  , SUM( CASE WHEN X.[SYSTEM] = 'SSP' THEN 1 ELSE 0 END ) AS SSP
		  , SUM( CASE WHEN X.[SYSTEM] = 'DM' THEN 1 ELSE 0 END ) AS DM
		  , SUM( CASE WHEN X.[SYSTEM] = 'SCP' THEN 1 ELSE 0 END ) AS SCP
		  , SUM( CASE WHEN X.[SYSTEM] = 'SCM' THEN 1 ELSE 0 END ) AS SCM
		  , SUM( CASE WHEN X.[SYSTEM] = 'FP' THEN 1 ELSE 0 END ) AS FP
		  , SUM( CASE WHEN X.[SYSTEM] = 'XIF' THEN 1 ELSE 0 END ) AS XIF
	  FROM #TEMP_BASE_DATA X
	  WHERE X.CREATION_DATE > GETDATE() - 30
	GROUP BY CONVERT( VARCHAR, CONVERT(DATE, X.CREATION_DATE) , 112);
	
	-----------------------------------------------------------------------
	--OUTPUT3. Plan Log
	-----------------------------------------------------------------------
	WITH RawData AS (
	select  SYSTEM = substring( SEGMENT2, charindex('[',SEGMENT2) + 1 , charindex(']',SEGMENT2) - charindex('[',SEGMENT2) - 1 ),
			--case when SEGMENT2 like '%plan start%'  or SEGMENT2 like '%plan end%'  or SEGMENT2 like '%plan Error%' or  SEGMENT2 like N'%장기%'  then substring( SEGMENT2, charindex('[',SEGMENT2) + 1 , charindex(']',SEGMENT2) - charindex('[',SEGMENT2) - 1 )
			--	 else NULL 
			--	 end type0,  
			case when SEGMENT2 like '%plan start%' then 'Plan Start'
				 when SEGMENT2 like '%plan end%' then 'Plan End'
				 when SEGMENT2 like '%plan Error%' then 'Plan Error'
				 when SEGMENT2 like N'%장기%' then 'Long Run'
				 else 'ETC'
				 end  Start_End,  --type1,  
			case when SEGMENT2 like '%plan start%' then substring( SEGMENT2, charindex(']',SEGMENT2) + 1 , charindex('plan',SEGMENT2) - charindex(']',SEGMENT2) - 1 )
				 when SEGMENT2 like '%plan end%' then substring( SEGMENT2, charindex(']',SEGMENT2) + 1 , charindex('/',SEGMENT2) - charindex(']',SEGMENT2) - 1 )
				 when SEGMENT2 like '%plan Error%' then  substring( SEGMENT2, charindex(']',SEGMENT2) + 1 , charindex('plan',SEGMENT2) - charindex(']',SEGMENT2) - 1 )
				 when SEGMENT2 like N'%장기%' then 'Long Run'
				 else 'ETC' 
				 end  Run_Option, --type2,
			case when SEGMENT2 like '%plan start%' then substring(SEGMENT2,6,2)
				 when SEGMENT2 like '%plan end%' then substring(SEGMENT2,6,2)
				 when SEGMENT2 like '%plan Error%' then  substring(SEGMENT2,6,2)
				 when SEGMENT2 like N'%장기%' then 'Long Run'
				 else 'ETC' 
				 end Division_ID     
			,SEGMENT2, SEND_DATE
--	into #RawData
	  from (select a.SEGMENT2, a.SEND_DATE
	--		select *
			from SCM_ADM_SMS_MAIL_SEND_LOG a  WITH(NOLOCK)
			where a.USE_TYPE_CODE = 'SMS' 
			and a.CATEGORY_ID in ('17','18','20')  -- 17:'Plan Start', 18:'Plan End', 20:'Plan Error', '70':장기수행
			and a.CREATION_DATE >= ( SELECT DATEADD(wk, DATEDIFF(wk, 0, getdate()), 0) ) -- @From_Date
			and a.CREATION_DATE <  ( SELECT DATEADD(wk, DATEDIFF(wk, 0, getdate()+7), 0) ) -- @To_Date
			and a.DISPATCH_SERIAL_NO = (select min(b.DISPATCH_SERIAL_NO) 
										from SCM_ADM_SMS_MAIL_SEND_LOG b  WITH(NOLOCK)
									   where b.segment2 = a.segment2
										 and b.category_id = a.category_id
										 AND b.SEND_DATE >= DATEADD(s,-1, a.SEND_DATE)
										 AND b.SEND_DATE <= DATEADD(s,1, a.SEND_DATE)	)	
			) sms_log
	--  where sms_log.send_no = 1 
--	  order by Division_ID, send_date
	),
	Starts AS (
	   --  'start' 이벤트만 선택하고 시간 순서대로 정렬합니다.
		SELECT SYSTEM,	Start_End,	Run_Option,	Division_ID,	SEGMENT2,	SEND_DATE
		--into #Starts
		FROM RawData
		WHERE Start_End = 'Plan Start'
	),
	Events AS (
	   --  'start' 이벤트만 선택하고 시간 순서대로 정렬합니다.
		SELECT SYSTEM,	Start_End,	Run_Option,	Division_ID,	SEGMENT2,	SEND_DATE
		--into #Events
		FROM RawData
		WHERE Start_End in ('Plan Error', 'Plan End')
	)
	,RawData_last AS (
		select  SYSTEM = substring( SEGMENT2, charindex('[',SEGMENT2) + 1 , charindex(']',SEGMENT2) - charindex('[',SEGMENT2) - 1 ),
				--case when SEGMENT2 like '%plan start%'  or SEGMENT2 like '%plan end%'  or SEGMENT2 like '%plan Error%' or  SEGMENT2 like N'%장기%'  then substring( SEGMENT2, charindex('[',SEGMENT2) + 1 , charindex(']',SEGMENT2) - charindex('[',SEGMENT2) - 1 )
				--	 else NULL 
				--	 end type0,  
				case when SEGMENT2 like '%plan start%' then 'Plan Start'
					 when SEGMENT2 like '%plan end%' then 'Plan End'
					 when SEGMENT2 like '%plan Error%' then 'Plan Error'
					 when SEGMENT2 like N'%장기%' then 'Long Run'
					 else 'ETC'
					 end  Start_End,  --type1,  
				case when SEGMENT2 like '%plan start%' then substring( SEGMENT2, charindex(']',SEGMENT2) + 1 , charindex('plan',SEGMENT2) - charindex(']',SEGMENT2) - 1 )
					 when SEGMENT2 like '%plan end%' then substring( SEGMENT2, charindex(']',SEGMENT2) + 1 , charindex('/',SEGMENT2) - charindex(']',SEGMENT2) - 1 )
					 when SEGMENT2 like '%plan Error%' then  substring( SEGMENT2, charindex(']',SEGMENT2) + 1 , charindex('plan',SEGMENT2) - charindex(']',SEGMENT2) - 1 )
					 when SEGMENT2 like N'%장기%' then 'Long Run'
					 else 'ETC' 
					 end  Run_Option, --type2,
				case when SEGMENT2 like '%plan start%' then substring(SEGMENT2,6,2)
					 when SEGMENT2 like '%plan end%' then substring(SEGMENT2,6,2)
					 when SEGMENT2 like '%plan Error%' then  substring(SEGMENT2,6,2)
					 when SEGMENT2 like N'%장기%' then 'Long Run'
					 else 'ETC' 
					 end Division_ID     
				,SEGMENT2, SEND_DATE
	--	into #RawData
		  from (select a.SEGMENT2, a.SEND_DATE
		--		select *
				from SCM_ADM_SMS_MAIL_SEND_LOG a  WITH(NOLOCK)
				where a.USE_TYPE_CODE = 'SMS' 
				and a.CATEGORY_ID in ('17','18','20')  -- 17:'Plan Start', 18:'Plan End', 20:'Plan Error', '70':장기수행
				and a.CREATION_DATE >= ( SELECT DATEADD(wk, DATEDIFF(wk, 0, getdate()-7), 0) ) -- @From_Date
				and a.CREATION_DATE <  ( SELECT DATEADD(wk, DATEDIFF(wk, 0, getdate()), 0) ) -- @To_Date        
				and a.DISPATCH_SERIAL_NO = (select min(b.DISPATCH_SERIAL_NO) 
								from SCM_ADM_SMS_MAIL_SEND_LOG b  WITH(NOLOCK)
							   where b.segment2 = a.segment2
								 and b.category_id = a.category_id
								 AND b.SEND_DATE >= DATEADD(s,-1, a.SEND_DATE)
								 AND b.SEND_DATE <= DATEADD(s,1, a.SEND_DATE)	)	
				) sms_log
		--  where sms_log.send_no = 1 
	--	  order by Division_ID, send_date
	),
	Starts_last AS (
	   --  'start' 이벤트만 선택하고 시간 순서대로 정렬합니다.
		SELECT SYSTEM,	Start_End,	Run_Option,	Division_ID,	SEGMENT2,	SEND_DATE
		--into #Starts
		FROM RawData_last
		WHERE Start_End = 'Plan Start'
	),
	Events_last AS (
	   --  'start' 이벤트만 선택하고 시간 순서대로 정렬합니다.
		SELECT SYSTEM,	Start_End,	Run_Option,	Division_ID,	SEGMENT2,	SEND_DATE
		--into #Events
		FROM RawData_last
		WHERE Start_End in ('Plan Error', 'Plan End')
	)
	--CC=charindex('::',Run_Option), --
	--SELECT *,  DIVISION_ID = LEFT( Run_Option, charindex('::',Run_Option)-1),
	select 'This Week' types , System, Run_Option, LEFT(Run_Option, charindex('::',Run_Option)-1) AS Division_ID, RIGHT(RTRIM(Run_Option),2) AS Plan_Type, Start_time, case when End_Time is null then Error_Occur_Time else End_Time end as End_Time, Error_Occur_Time, 
		   datediff(mi, Start_time, isnull(End_Time, Error_Occur_Time) ) AS 'Run_Time(Min)' , datename(weekday, Start_time) week_day
		   , case when End_Time is not null then 'END' when End_Time is null and Error_Occur_Time is not null then 'ERROR' else 'RUNNING' end run_status
	FROM (
			select SYSTEM,	Start_End,	Run_Option,	Division_ID,	SEGMENT2,	SEND_DATE as Start_time,
					-- START시간 이후에 발생한 가장 가까운 ERROR 시간을 찾습니다.
					(SELECT TOP 1 e_err.SEND_DATE
					 FROM Events e_err
					 WHERE e_err.SYSTEM = s.SYSTEM
					   AND e_err.Start_End = 'Plan Error'
					   AND e_err.Run_Option = s.Run_Option
					   AND e_err.SEND_DATE > s.SEND_DATE
					   -- START시간과 다음 START시간 사이의 ERROR만 고려 (오버랩 방지)
					   AND e_err.SEND_DATE < ISNULL((SELECT MIN(s2.SEND_DATE) FROM Starts s2 WHERE s2.SYSTEM = s.SYSTEM AND s2.Run_Option = s.Run_Option AND s2.SEND_DATE > s.SEND_DATE), dateadd(d, 1, s.SEND_DATE))  --dateadd(d, 1, JG.SEND_DATE)
					 ORDER BY e_err.SEND_DATE ASC) AS Error_Occur_TIME,
					-- START시간 이후에 발생한 가장 가까운 END 시간을 찾습니다.
					(SELECT TOP 1 e_end.SEND_DATE
					 FROM Events e_end
					 WHERE e_end.SYSTEM = s.SYSTEM
					   AND e_end.Start_End = 'Plan End'
					   AND e_end.Run_Option = s.Run_Option
					   AND e_end.SEND_DATE > s.SEND_DATE
					   -- START시간과 다음 START시간 사이의 END만 고려 (오버랩 방지)
					   AND e_end.SEND_DATE < ISNULL((SELECT MIN(s2.SEND_DATE) FROM Starts s2 WHERE s2.SYSTEM = s.SYSTEM AND s2.Run_Option = s.Run_Option AND s2.SEND_DATE > s.SEND_DATE), dateadd(d, 1, s.SEND_DATE))
					 ORDER BY e_end.SEND_DATE ASC) AS END_TIME	 
			FROM Starts s
			 ) Z
	-- ORDER BY Z.Start_time
	UNION ALL 
	select 'Last Week' types , System, Run_Option, LEFT(Run_Option, charindex('::',Run_Option)-1) AS Division_ID, RIGHT(RTRIM(Run_Option),2) AS Plan_Type, Start_time,  case when End_Time is null then Error_Occur_Time else End_Time end as End_Time, Error_Occur_Time, 
		   datediff(mi, Start_time, isnull(End_Time, Error_Occur_Time) ) AS 'Run_Time(Min)' , datename(weekday, Start_time) week_day
		   , case when End_Time is not null then 'END' when End_Time is null and Error_Occur_Time is not null then 'ERROR' else 'RUNNING' end run_status
	FROM (
			select SYSTEM,	Start_End,	Run_Option,	Division_ID,	SEGMENT2,	SEND_DATE as Start_time,
					-- START시간 이후에 발생한 가장 가까운 ERROR 시간을 찾습니다.
					(SELECT TOP 1 e_err.SEND_DATE
					 FROM Events_last e_err
					 WHERE e_err.SYSTEM = s.SYSTEM
					   AND e_err.Start_End = 'Plan Error'
					   AND e_err.Run_Option = s.Run_Option
					   AND e_err.SEND_DATE > s.SEND_DATE
					   -- START시간과 다음 START시간 사이의 ERROR만 고려 (오버랩 방지)
					   AND e_err.SEND_DATE < ISNULL((SELECT MIN(s2.SEND_DATE) FROM Starts_last s2 WHERE s2.SYSTEM = s.SYSTEM AND s2.Run_Option = s.Run_Option AND s2.SEND_DATE > s.SEND_DATE), dateadd(d, 1, s.SEND_DATE))  --dateadd(d, 1, JG.SEND_DATE)
					 ORDER BY e_err.SEND_DATE ASC) AS Error_Occur_TIME,
					-- START시간 이후에 발생한 가장 가까운 END 시간을 찾습니다.
					(SELECT TOP 1 e_end.SEND_DATE
					 FROM Events_last e_end
					 WHERE e_end.SYSTEM = s.SYSTEM
					   AND e_end.Start_End = 'Plan End'
					   AND e_end.Run_Option = s.Run_Option
					   AND e_end.SEND_DATE > s.SEND_DATE
					   -- START시간과 다음 START시간 사이의 END만 고려 (오버랩 방지)
					   AND e_end.SEND_DATE < ISNULL((SELECT MIN(s2.SEND_DATE) FROM Starts_last s2 WHERE s2.SYSTEM = s.SYSTEM AND s2.Run_Option = s.Run_Option AND s2.SEND_DATE > s.SEND_DATE), dateadd(d, 1, s.SEND_DATE))
					 ORDER BY e_end.SEND_DATE ASC) AS END_TIME	 
			FROM Starts_last s
			 ) Z
	;
	
	-----------------------------------------------------------------------
	--OUTPUT4. SMS 발송 로그
	-----------------------------------------------------------------------
	WITH W_SMS_LIST AS (
	SELECT CASE WHEN CHARINDEX('SCM', A.SEGMENT2) > 0 AND CHARINDEX('ADM', A.SEGMENT2) > 0 THEN 'SCM'
						WHEN CHARINDEX('DM', A.SEGMENT2) > 0 and a.SEGMENT2 not like '%addMy%' and a.SEGMENT2 not like '%admin%' THEN 'DM'
						WHEN CHARINDEX('OPT', A.SEGMENT2) > 0 THEN 'OPT'
						WHEN CHARINDEX('SCP', A.SEGMENT2) > 0 THEN 'SCP'
						WHEN CHARINDEX('SSP', A.SEGMENT2) > 0 THEN 'SSP'
						WHEN CHARINDEX('RFC', A.SEGMENT2) > 0 THEN 'RFC'
						WHEN CHARINDEX('SCM', A.SEGMENT2) > 0 THEN 'SCM'
						WHEN CHARINDEX('FP', A.SEGMENT2) > 0 THEN 'FP'
						WHEN CHARINDEX('XIF', A.SEGMENT2) > 0 THEN 'INF'
						WHEN CHARINDEX('ERP', A.SEGMENT2) > 0 THEN 'ERP'
						WHEN CHARINDEX('FN', A.SEGMENT2) > 0 THEN 'FN'
						ELSE 'COMMON'
						END AS SYSTEM
		 , MIN(A.SEND_DATE) AS SEND_DATE
		 , A.SEGMENT2
	  FROM DBO.SCM_ADM_SMS_MAIL_SEND_LOG A WITH(NOLOCK)
	  JOIN DBO.SCM_ADM_RECIPIENT_LIST	 B WITH(NOLOCK)
		ON (A.USE_TYPE_CODE = B.USE_TYPE_CODE
		AND A.CATEGORY_ID	= B.CATEGORY_ID
		AND B.VALID_YN		= 'Y'
		AND B.CATEGORY_DESC LIKE '%ERROR%')
	 WHERE 1=1
	   AND A.USE_TYPE_CODE  = 'SMS'
	   AND A.SEND_DATE		>= GETDATE() - 8
	 GROUP BY FORMAT(A.SEND_DATE, 'yyyy-MM-dd'), A.SEGMENT2
	)
	SELECT A.SYSTEM
		 , FORMAT(A.SEND_DATE, 'yyyy-MM-dd hh:mm:ss') AS SEND_DATE
		 , A.SEGMENT2
		 , IIF(B.SEGMENT2 IS NULL, 'NEW', NULL) NEW_ERROR
	  FROM W_SMS_LIST A
	  LEFT JOIN W_SMS_LIST B
	    ON (B.SEGMENT2 = A.SEGMENT2
	   AND B.SEND_DATE BETWEEN GETDATE() - 8 AND GETDATE() -1)
	 WHERE 1=1
	   AND A.SEND_DATE > GETDATE() - 1
	 ORDER BY A.SEND_DATE DESC;

END
