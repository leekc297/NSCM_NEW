
/*============================================================================================================================
 * Program ID   : PR_DM_CHECK_BEFOREHAND_SMS_SEND
 * Description  : DM 배치작업 선감지 모니터링
 * Program History
 *============================================================================================================================
 *   Date       In Charge    Description
 *============================================================================================================================
 * 2024.07.22   JSSBAE		[E20240712-001681]_DM 컷오프 선감지 모니터링 프로세스 반영 신규생성
 * 2025.06.04	JSSBAE		[E20250529-001289]_DM 장애 대응 개선을 위한 시스템 개선
 *============================================================================================================================
	● 모니터링 대상 List
	-------------------------------------------------  -------------------------------------------------	--------------------------------------------------------------------------
	BATCH JOB NAME										사유													전송기준
	-------------------------------------------------  -------------------------------------------------	--------------------------------------------------------------------------
	JOB.PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING_TUE_81_2		MKT FCST CUTOFF 정상 작동	(81, 81_ST, 81_HM)			해당 시점에 JOB로그가 찍히지 않는다면 문자발송
	JOB.PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING_TUE_81_UC		MKT FCST CUTOFF 정상 작동	(81_UC)						해당 시점에 JOB로그가 찍히지 않는다면 문자발송
	JOB.PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING_TUE_TOTAL		MKT FCST CUTOFF 정상 작동	(82, 40)					해당 시점에 JOB로그가 찍히지 않는다면 문자발송
	JOB.PR_DM_PLN_SALES_PLAN_WEEKLY_ROLLING_40			SALES PLAN CUTOFF 정상 작동 40						해당 시점에 JOB로그가 찍히지 않는다면 문자발송
	JOB.PR_DM_PLN_SALES_PLAN_WEEKLY_ROLLING_81			SALES PLAN CUTOFF 정상 작동 81						해당 시점에 JOB로그가 찍히지 않는다면 문자발송
	JOB.PR_DM_PLN_SALES_PLAN_WEEKLY_ROLLING_81_HM		SALES PLAN CUTOFF 정상 작동 81_HM						해당 시점에 JOB로그가 찍히지 않는다면 문자발송
	JOB.PR_DM_PLN_SALES_PLAN_WEEKLY_ROLLING_81_ST		SALES PLAN CUTOFF 정상 작동 81_ST						해당 시점에 JOB로그가 찍히지 않는다면 문자발송
	JOB.PR_DM_PLN_SALES_PLAN_WEEKLY_ROLLING_81_UC		SALES PLAN CUTOFF 정상 작동 81_UC						해당 시점에 JOB로그가 찍히지 않는다면 문자발송
	JOB.PR_DM_PLN_SALES_PLAN_WEEKLY_ROLLING_82			SALES PLAN CUTOFF 정상 작동 82						해당 시점에 JOB로그가 찍히지 않는다면 문자발송
	JOB.PR_DM_DNM_SALES_RESULT							Sales Result 반영(to DM)								해당 시점에 JOB로그가 찍히지 않는다면 문자발송
	JOB_RFC.매출 실적 정보								ERP Sales Result 수신								해당 시점에 JOB로그가 찍히지 않는다면 문자발송
	JOB_RFC.판매법인(G260) 재고							판매법인(G260) 재고									해당 시점에 JOB로그가 찍히지 않는다면 문자발송
	JOB_RFC.DM_VMI_재고 입출고 실적						VMI 재고 입출고 실적									해당 시점에 JOB로그가 찍히지 않는다면 문자발송
	JOB.PR_DM_PLN_XIF_ERP_MDF_TO_DM_MDF_RESULT			전지사업본부 MDF(판매장려금) 실적 정보					해당 시점에 JOB로그가 찍히지 않는다면 문자발송
	-------------------------------------------------  -------------------------------------------------	--------------------------------------------------------------------------
	● 문자 발송 대상 LIST
	DM : 카테고리 102
============================================================================================================================*/

CREATE PROCEDURE [dbo].[PR_DM_CHECK_BEFOREHAND_SMS_SEND]
	@p_category_id				int
  , @p_system_name				varchar(10)
AS

BEGIN 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON;
	
	------------------------------------------------------------------------------------------------------- 
	-- 대상건 Fetch 변수
	------------------------------------------------------------------------------------------------------- 
	DECLARE @v_job_name				NVARCHAR(150);
	DECLARE @v_job_description		NVARCHAR(150);
	DECLARE @v_job_event_tm			DATETIME;
	DECLARE @v_code					NVARCHAR(150);
	DECLARE @v_text					NVARCHAR(MAX);
	
	------------------------------------------------------------------------------------------------------- 
	-- LOG 용 변수 설정
	------------------------------------------------------------------------------------------------------- 
    DECLARE @v_program_name			NVARCHAR(150) = 'PR_DM_CHECK_BEFOREHAND_SMS_SEND';
    DECLARE @v_log_type				NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count			INTEGER = 0;
    DECLARE @v_log_message			NVARCHAR(1000);
    DECLARE @v_description			NVARCHAR(500);
    DECLARE @d_event_date			DATETIME;
	
	------------------------------------------------------------------------------------------------------- 
	-- 시작 LOG (START)
	------------------------------------------------------------------------------------------------------- 
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	------------------------------------------------------------------------------------------------------- 
	-- 시작 LOG (END)
	------------------------------------------------------------------------------------------------------- 
	
    BEGIN TRY
		BEGIN
		------------------------------------------------------------------------------------------------------- 
		-- 임시TB 삭제하고 시작한다.
		------------------------------------------------------------------------------------------------------- 			
		IF OBJECT_ID (N'tempdb..#TEMP_DAYINFO', N'U') IS NOT NULL 
			DROP TABLE #TEMP_DAYINFO
		IF OBJECT_ID (N'tempdb..#TEMP_CHECKED', N'U') IS NOT NULL 
			DROP TABLE #TEMP_CHECKED		
		IF OBJECT_ID (N'tempdb..#TMP_DM_CHECK_BEFOREHAND', N'U') IS NOT NULL 
			DROP TABLE #TMP_DM_CHECK_BEFOREHAND
				
		------------------------------------------------------------------------------------------------------- 
		--당일 날짜가 어떤날짜인지 데이터 추출
		------------------------------------------------------------------------------------------------------- 
		SELECT DAYOFWEEK AS DAYOFWEEKS
		INTO #TEMP_DAYINFO
		FROM [dbo].[SCM_SYS_CALENDAR_M] WITH (NOLOCK)
		WHERE BASIS_YYYYMMDD = CONVERT(VARCHAR(8), GETDATE(), 112)
	
		------------------------------------------------------------------------------------------------------- 
		--현재시점 모니터링 해야되는 대상 추출(5분에 한번씩 도는 배치이므로, 10분전 데이터를 가지고와서 비교한다.)
		------------------------------------------------------------------------------------------------------- 
		SELECT SEGMENT2 AS JOB_NAMES
				, SEGMENT3 AS DAYOFWEEKS
				, SEGMENT4 AS TIMES
				, DESCRIPTION AS SMS_MESSAGE
		INTO #TEMP_CHECKED
		FROM [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] WITH (NOLOCK)
		WHERE LOOKUP_TYPE = 'DM_CHECKED_BEFOREHAND'			
		AND SEGMENT1 = CASE WHEN @p_system_name = '' OR @p_system_name = 'ALL' THEN SEGMENT1 ELSE @p_system_name END --[E20250529-001289]_ALL인경우는 시스템과 관계없이 타도록 수정
		--AND SEGMENT1 = @p_system_name --[E20250529-001289]_기존 소스 주석처리
		AND (SEGMENT3 = 'ALL' OR SEGMENT3 IN (SELECT DAYOFWEEKS FROM #TEMP_DAYINFO))
		AND VALID_YN = 'Y'
		AND CAST(SEGMENT4 AS INT)+5 BETWEEN CAST(REPLACE(LEFT(CONVERT(VARCHAR,DATEADD(MINUTE, -5, GETDATE()), 108),5), ':', '')AS INT) 
										AND CAST(REPLACE(LEFT(CONVERT(VARCHAR,GETDATE(), 108),5), ':', '')AS INT)

		------------------------------------------------------------------------------------------------------- 
		--현재 기준으로 모니터링이 필요한 대상 데이터가 없는 경우에는 넘어간다
		------------------------------------------------------------------------------------------------------- 
		IF (SELECT COUNT(*) FROM #TEMP_CHECKED) > 0
		BEGIN
			--JOB이 실행되고 있는 이력을 확인한다. 	
			SELECT W.JOB_NAMES AS JOB_NAME, SMS_MESSAGE
			INTO #TMP_DM_CHECK_BEFOREHAND
			FROM (  SELECT JOB_NAMES, DAYOFWEEKS, TIMES, SMS_MESSAGE
					FROM #TEMP_CHECKED ) W
			WHERE NOT EXISTS ( SELECT J.NAME AS JOB_NAME, H.RUN_STATUS, H.RUN_DATE, H.RUN_TIME, MSDB.DBO.AGENT_DATETIME(RUN_DATE, RUN_TIME) AS RUN_DATE_TIME
								FROM MSDB.DBO.SYSJOBS j WITH (NOLOCK)
								JOIN MSDB.DBO.SYSJOBHISTORY H WITH (NOLOCK)
									ON J.JOB_ID = H.JOB_ID 
								WHERE W.JOB_NAMES = J.NAME
								AND H.RUN_DATE = CONVERT(VARCHAR(8), GETDATE(), 112)
								AND CAST(REPLACE(LEFT(CONVERT(VARCHAR,MSDB.DBO.AGENT_DATETIME(RUN_DATE, RUN_TIME), 108),5), ':', '')AS INT) BETWEEN W.TIMES-5 AND W.TIMES+5)

			DECLARE CUR_DM_CHECK_LOG SCROLL CURSOR FOR
			SELECT JOB_NAME, SMS_MESSAGE FROM #TMP_DM_CHECK_BEFOREHAND

			BEGIN
				OPEN CUR_DM_CHECK_LOG;
				FETCH NEXT FROM CUR_DM_CHECK_LOG INTO @v_job_name, @v_job_description;			
			END
				
			WHILE @@FETCH_STATUS = 0
			BEGIN
				BEGIN
					SET @v_text = ''
					SET @v_code = @p_category_id
					SET @v_text = @v_job_description

					EXEC SCM_ADM_SMS_SEND_BATCH @v_code, @v_text
				END
			
				FETCH NEXT FROM CUR_DM_CHECK_LOG INTO @v_job_name, @v_job_description
			END
				
			CLOSE CUR_DM_CHECK_LOG;  
			DEALLOCATE CUR_DM_CHECK_LOG;

		END
		END	
    END TRY
	------------------------------------------------------------------------------------------------------------------------------
    BEGIN CATCH	
		SET @v_log_type = 'ERROR';
		SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
		SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE())
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
    END CATCH;
	------------------------------------------------------------------------------------------------------------------------------
	SET @v_log_type = 'END';
	SET @v_log_message = '########## END of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
END
	