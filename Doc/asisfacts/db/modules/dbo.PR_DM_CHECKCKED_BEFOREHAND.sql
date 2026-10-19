
/*
 * Program ID   : PR_DM_CHECKCKED_BEFOREHAND
 * Description  : DM 배치작업 선감지 모니터링
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2024.07.22   JSSBAE			[E20240712-001681]_DM 컷오프 선감지 모니터링 프로세스 반영 신규생성
 *===================================================================================================
 	● 대상 List
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
*/

CREATE PROCEDURE [dbo].[PR_DM_CHECKCKED_BEFOREHAND]
AS

BEGIN 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON;

	-- 처리용 변수 설정
	DECLARE @v_result				NVARCHAR(MAX);
	DECLARE @n_checked_fetch_sts	INTEGER;
	DECLARE @n_proc_cnt				INTEGER;
	DECLARE @p_longtm_msg			NVARCHAR(MAX) = '';

	-- 대상건 Fetch 변수
	DECLARE @v_pgm_name				NVARCHAR(150);
	DECLARE @v_pgm_log_type			NVARCHAR(150);
	DECLARE @v_pgm_event_tm			NVARCHAR(30);

	DECLARE @v_message_content		NVARCHAR(4000);
	DECLARE @v_sms_phone			NVARCHAR(50);
	DECLARE @v_sms_send_phone		NVARCHAR(50);
	DECLARE @v_use_type_code		NVARCHAR(10);
	DECLARE @v_module_code			NVARCHAR(30);

	-- LOG 용 변수 설정
    DECLARE @v_program_name			NVARCHAR(150) = 'PR_DM_CHECKCKED_BEFOREHAND';
    DECLARE @v_log_type				NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count			INTEGER = 0;
    DECLARE @v_log_message			NVARCHAR(1000);
    DECLARE @v_description			NVARCHAR(500);
    DECLARE @d_event_date			DATETIME;
	
	--------------------------------------------------------------------------------------------------
	-- 실행되야 하는 배치가 정상실행 되지 않은 경우 SMS 를 보낼 대상을 추출하기 위해서 임시테이블만들기
	--------------------------------------------------------------------------------------------------
	IF OBJECT_ID (N'tempdb..#TMP_DM_CHECK', N'U') IS NOT NULL 
			DROP TABLE #TMP_DM_CHECK

	CREATE TABLE #TMP_DM_CHECK
	( C_JOB_NAMES		    NVARCHAR(150)
	, C_SMS_MESSAGE			NVARCHAR(30) );
	
	------------------------------------------------------------------------------------------------------- 
	-- 현재 시점 기준 모니터링 해야되는 데이터 대상 추출
	------------------------------------------------------------------------------------------------------- 
	IF OBJECT_ID (N'tempdb..#TEMP_DAYINFO', N'U') IS NOT NULL 
		DROP TABLE #TEMP_DAYINFO

	IF OBJECT_ID (N'tempdb..#TEMP_CHECKED_BEFOREHAND', N'U') IS NOT NULL 
		DROP TABLE #TEMP_CHECKED_BEFOREHAND
		
	--당일 날짜가 어떤날짜인지 데이터 추출
	SELECT DAYOFWEEK AS DAYOFWEEKS
	INTO #TEMP_DAYINFO
	FROM [dbo].[SCM_SYS_CALENDAR_M] WITH (NOLOCK)
	WHERE BASIS_YYYYMMDD = CONVERT(VARCHAR(8), GETDATE(), 112)
	
	SELECT *
	FROM [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] WITH (NOLOCK)
	WHERE LOOKUP_TYPE = 'DM_CHECKED_BEFOREHAND'

	SELECT CAST(REPLACE(LEFT(CONVERT(VARCHAR,DATEADD(MINUTE, -10, GETDATE()), 108),5), ':', '')AS INT)
		 , CAST(REPLACE(LEFT(CONVERT(VARCHAR,GETDATE(), 108),5), ':', '')AS INT)

	--현재시점 모니터링 해야되는 대상 추출
	SELECT SEGMENT1 AS JOB_NAMES
		 , SEGMENT2 AS DAYOFWEEKS
		 --실제시간보다 5분정도 딜레이 타임을 줘서, 배치실행 5분 후로 데이터 비교 시간을 갖는다.
		 , CAST(SEGMENT3 AS INT)+ 5 AS TIMES
		 , DESCRIPTION AS SMS_MESSAGE
	INTO #TEMP_CHECKED_BEFOREHAND
	FROM [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] WITH (NOLOCK)
	WHERE LOOKUP_TYPE = 'DM_CHECKED_BEFOREHAND'
	AND (SEGMENT2 = 'ALL' OR SEGMENT2 IN (SELECT DAYOFWEEKS FROM #TEMP_DAYINFO))
	AND VALID_YN = 'Y'
	AND CAST(SEGMENT3 AS INT)+5 BETWEEN CAST(REPLACE(LEFT(CONVERT(VARCHAR,DATEADD(MINUTE, -10, GETDATE()), 108),5), ':', '')AS INT) 
								  AND CAST(REPLACE(LEFT(CONVERT(VARCHAR,GETDATE(), 108),5), ':', '')AS INT)
						
	--현재 JOB 정보를 확인한다. 	
	SELECT W.JOB_NAMES, W.SMS_MESSAGE
	--INTO #TMP_DM_CHECK
	FROM (  SELECT JOB_NAMES, DAYOFWEEKS, TIMES, SMS_MESSAGE
			FROM #TEMP_CHECKED_BEFOREHAND ) W
	WHERE NOT EXISTS ( SELECT J.NAME AS JOB_NAME, H.RUN_STATUS, H.RUN_DATE, H.RUN_TIME, MSDB.DBO.AGENT_DATETIME(RUN_DATE, RUN_TIME) AS RUN_DATE_TIME
					   FROM MSDB.DBO.SYSJOBS j WITH (NOLOCK)
					   JOIN MSDB.DBO.SYSJOBHISTORY H WITH (NOLOCK)
						 ON J.JOB_ID = H.JOB_ID 
					   WHERE W.JOB_NAMES = J.NAME
					   AND H.RUN_DATE = CONVERT(VARCHAR(8), GETDATE(), 112)
					   AND CAST(REPLACE(LEFT(CONVERT(VARCHAR,MSDB.DBO.AGENT_DATETIME(RUN_DATE, RUN_TIME), 108),5), ':', '')AS INT) BETWEEN W.TIMES-5 AND W.TIMES+5)

	
	BEGIN
		DECLARE CUR_DM_CHECK_LOG CURSOR FOR
		SELECT * FROM #TMP_DM_CHECK
	END
	
	---------------------------------------------------------------------------------
	--SMS 대상자 임시테이블만들기
	---------------------------------------------------------------------------------
	IF OBJECT_ID (N'tempdb..#TMP_DM_SMS_CHECK', N'U') IS NOT NULL 
		DROP TABLE #TMP_DM_SMS_CHECK
 
	SELECT B.MESSAGE_CONTENT
		 , C.SMS_PHONE
		 , A.USE_TYPE_CODE
		 , A.MODULE_CODE
	INTO #TMP_DM_SMS_CHECK
	FROM SCM_ADM_RECIPIENT_LIST A WITH (NOLOCK)
	INNER JOIN SCM_ADM_RECIPIENT_MESSAGE B WITH (NOLOCK)
			ON A.CATEGORY_ID = B.CATEGORY_ID
	INNER JOIN SCM_ADM_RECIPIENT_SMS_ASSIGN C WITH (NOLOCK)
			ON A.CATEGORY_ID = C.CATEGORY_ID
	WHERE A.CATEGORY_ID = '99'
	AND A.VALID_YN = 'Y'
		
	DECLARE CUR_LM_SEND SCROLL CURSOR FOR
	SELECT MESSAGE_CONTENT, SMS_PHONE, USE_TYPE_CODE, MODULE_CODE FROM #TMP_DM_SMS_CHECK
	
	---------------------------------------------------------------------------------
	--메인 처리시작
	---------------------------------------------------------------------------------
	BEGIN TRY
		-- SP 시작 LOG
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		
		OPEN CUR_DM_CHECK_LOG;
		FETCH NEXT FROM CUR_DM_CHECK_LOG INTO @v_pgm_name, @v_pgm_event_tm;

		SET @n_checked_fetch_sts = @@FETCH_STATUS;		-- 이중 loop 를 사용하므로 장기실행 미완료 건에 대한 fetch status 를 보관한다.

		SET @n_proc_cnt = 0;

		-- 장기수행 미완료 건을 Fetch 해서 순차처리한다.
		SET @v_log_type = 'TXN';
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_message = N'문제발생 전 선감지';
        SET @v_description = N'배치가 정상적으로 실행되지 않음' ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date; 

		WHILE @n_checked_fetch_sts = 0
			BEGIN

				IF @n_proc_cnt = 0
					OPEN CUR_LM_SEND;

				IF @n_proc_cnt = 9
					FETCH FIRST FROM CUR_LM_SEND INTO @v_message_content, @v_sms_phone, @v_use_type_code, @v_module_code; 
				ELSE
					FETCH NEXT FROM CUR_LM_SEND INTO @v_message_content, @v_sms_phone, @v_use_type_code, @v_module_code;

				SET @n_proc_cnt = 1;

				WHILE @@FETCH_STATUS = 0
					BEGIN			
					
						BEGIN
							IF ISNULL(@p_longtm_msg,'') != ''
								SET @v_message_content = LEFT('[' +@v_module_code+ ']'+@p_longtm_msg+' '+@v_message_content, 79)
							ELSE
								SET @v_message_content = LEFT('[' +@v_module_code+ ']PNM:'+@v_pgm_name+' '+@v_message_content, 79)
						END
				
						SET @v_sms_send_phone = ''
						SET @v_sms_send_phone = '01099999999'

						INSERT INTO XIF_IFS_SMS_DATA_SN
						(IF_TYPE, IF_ID, IF_INS_DATE, IF_FLAG, TR_SENDSTAT, TR_MSGTYPE, TR_PHONE, TR_CALLBACK, TR_MSG)
						VALUES 
						('S', 'OFP0_OSMS_SMS', GETDATE(), 'N', '0', '0', @v_sms_phone, @v_sms_send_phone, @v_message_content)

						--SMS 발송 LOG 저장
						EXEC SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG @v_use_type_code
										,'99'
										,@v_sms_phone
										,@v_message_content
										,''
										,''
										,''
										,''
										,''
										,''
										,''
										,''
										,'' --p_send_pgm
										,@v_sms_phone;

						--select @v_use_type_code, @p_category_id, @v_sms_phone, @v_message_content;

						FETCH NEXT FROM CUR_LM_SEND INTO @v_message_content, @v_sms_phone, @v_use_type_code, @v_module_code

					END

				SET @n_proc_cnt = 9;

				-- 다음 미완료 건을 Fetch 한다.
				FETCH NEXT FROM CUR_DM_CHECK_LOG INTO @v_pgm_name, @v_pgm_log_type, @v_pgm_event_tm;

				SET @n_checked_fetch_sts = @@FETCH_STATUS;		-- 이중 loop 를 사용하므로 장기실행 미완료 건에 대한 fetch status 를 보관한다.

			END -- 장기수행 미완료건 loop end.

		-- 장기수행 미완료건 커서해제
		CLOSE CUR_DM_CHECK_LOG;
		DEALLOCATE CUR_DM_CHECK_LOG;

		-- SMS 대상자 커서해제
		IF @n_proc_cnt > 0
		    CLOSE CUR_LM_SEND;

		DEALLOCATE CUR_LM_SEND;

		-- 임시 테이블 삭제
		IF EXISTS (SELECT * FROM tempdb.sys.sysobjects WHERE name = '#tmp_SCP_LONGTM_CHECK')
		   DROP TABLE #tmp_SCP_LONGTM_CHECK

		IF EXISTS (SELECT * FROM tempdb.sys.sysobjects WHERE name = '#tmp_TblSmsSendBatch')
		   DROP TABLE #tmp_TblSmsSendBatch

		-- SP 종료 log.
		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	END TRY

	-- error catch...
	BEGIN CATCH
		-- cursor 를 해제한다.
		CLOSE CUR_DM_CHECK_LOG;
		DEALLOCATE CUR_DM_CHECK_LOG;

		CLOSE CUR_LM_SEND;
		DEALLOCATE CUR_LM_SEND;

		BEGIN

			SET @v_log_type = 'ERROR';
			SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
			SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE())
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		END;	

		-- error코드, errror 메시지 반환
		SELECT 'F' AS result_code;
		SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
	END CATCH;

END
