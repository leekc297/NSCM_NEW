
/*===================================================================================================
 * Program ID   : PR_ERROR_CHK_SMS_SEND
 * Description  : 오류작업 체크 및 SMS 전송
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2020/08/13   KSW				오류작업 체크 및 SMS 전송
 * 2020/09/22   KSW				프로시저 이름이 긴 경우 오류가 발생하므로 MSG 길이를 80 byte 제한
 * 2025/05/29	JSSBAE			[E20250529-001289]_DM 장애 대응 개선을 위한 시스템 개선
 *==================================================================================================*/
 
CREATE PROCEDURE [dbo].[PR_ERROR_CHK_SMS_SEND]

	-- Add the parameters for the stored procedure here
	@p_category_id				int,
	@p_longtm_msg				NVARCHAR(MAX) = '',
	@p_check_tm                 int

AS

BEGIN 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON;

	-- 처리용 변수 설정
	DECLARE @v_result			NVARCHAR(MAX);
	--DECLARE @n_def_check_tm     INTEGER = 5;		-- check time (min) :: 현시간 이전 시간 ; --[E20250529-001289]_시간변경 과거 소스 주석처리
	DECLARE @n_def_check_tm     INTEGER = 6;		-- check time (min) :: 현시간 이전 시간 --[E20250529-001289]_시간변경:6분으로 (JOB이 5분단위로 돌기때문에 놓치는 건이 발생함)
	DECLARE @n_check_tm         INTEGER;
	DECLARE @n_longtm_fetch_sts INTEGER;
	DECLARE @n_proc_cnt         INTEGER;

	-- 대상건 Fetch 변수
	DECLARE @v_pgm_name         NVARCHAR(150);
	DECLARE @v_pgm_log_type     NVARCHAR(150);
	DECLARE @v_pgm_event_tm     DATETIME;

	DECLARE @v_message_content  NVARCHAR(4000);
	DECLARE @v_sms_phone		NVARCHAR(50);
	DECLARE @v_sms_send_phone	NVARCHAR(50);
	DECLARE @v_use_type_code    NVARCHAR(10);
	DECLARE @v_module_code		NVARCHAR(30);

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_ERROR_CHK_SMS_SEND';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	BEGIN
		IF (@p_check_tm > 0)
			SET @n_check_tm = @p_check_tm
		ELSE
			SET @n_check_tm = @n_def_check_tm
	END

	/********************************************************************************
	* 오류작업 SMS 를 보낼 대상을 추출하기 위해서 임시테이블만들기
	********************************************************************************/
	IF EXISTS (SELECT * FROM tempdb.sys.sysobjects WHERE name = '#tmp_SCP_ERROR_CHECK')
		   DROP TABLE #tmp_SCP_ERROR_CHECK
 
	CREATE TABLE #tmp_SCP_ERROR_CHECK (
			 C_PROGRAM_NAME	    NVARCHAR(150),
			 C_LOG_TYPE			NVARCHAR(30),
			 C_EVENT_DATE		DATETIME
	);

	INSERT INTO #tmp_SCP_ERROR_CHECK
	SELECT PROGRAM_NAME, LOG_TYPE, MAX(EVENT_DATE) AS EVENT_DATE
      FROM [dbo].[SCM_SYS_LOG_BATCH] WITH (NOLOCK)
     WHERE 1=1
       AND DATEDIFF ( mi , EVENT_DATE , getdate() ) < @n_check_tm
       AND LOG_TYPE = 'ERROR'
     GROUP BY PROGRAM_NAME, LOG_TYPE
	 ;	
	---------------------------------------------------------------------------------------------
	--[E20250529-001289]_JOB에서 오류가 나는 경우에도 SMS 발송을 진행한다. START
	---------------------------------------------------------------------------------------------	 
	INSERT INTO #tmp_SCP_ERROR_CHECK
	SELECT T.PROGRAM_NAME, T.LOG_TYPE, MAX(T.EVENT_DATE) AS EVENT_DATE
	FROM (	SELECT JOB.NAME AS PROGRAM_NAME, 'ERROR' AS LOG_TYPE
				 , msdb.dbo.agent_datetime(run_date, run_time) as EVENT_DATE
			FROM  [msdb].[dbo].[sysjobhistory] HS
			INNER JOIN [msdb].[dbo].[sysjobs] JOB ON HS.JOB_ID = JOB.JOB_ID
			INNER JOIN  sys.sql_logins LOGI ON JOB.OWNER_SID = LOGI.SID
			WHERE   HS.RUN_STATUS = 0
			AND		LOGI.DEFAULT_DATABASE_NAME <> 'LGCE_LOGIPROD'
			AND     HS.STEP_ID > 0 ) T
     WHERE 1=1
     AND DATEDIFF ( MI, T.EVENT_DATE, GETDATE()) < @n_check_tm
     AND T.LOG_TYPE = 'ERROR'
     GROUP BY PROGRAM_NAME, LOG_TYPE
	 ;		 		
	---------------------------------------------------------------------------------------------
	--[E20250529-001289]_JOB에서 오류가 나는 경우에도 SMS 발송을 진행한다. END
	---------------------------------------------------------------------------------------------

	BEGIN
		DECLARE CUR_ERROR_LOG CURSOR FOR
		SELECT * FROM #tmp_SCP_ERROR_CHECK
	END


	/********************************************************************************
	* SMS 대상자 임시테이블만들기
	********************************************************************************/
	IF EXISTS (SELECT * FROM tempdb.sys.sysobjects WHERE name = '#tmp_TblErrSmsSendBatch')
		   DROP TABLE #tmp_TblErrSmsSendBatch
 
	CREATE TABLE #tmp_TblErrSmsSendBatch (
			 message_content	NVARCHAR(4000),
			 sms_phone			NVARCHAR(50),
			 use_type_code		NVARCHAR(10),
			 module_code		NVARCHAR(30)
	);

	SET @v_result = ''
	SET @v_result = @v_result+'        SELECT b.message_content '+CHAR(10)
	SET @v_result = @v_result+'              ,c.sms_phone '+CHAR(10)
	SET @v_result = @v_result+'              ,a.use_type_code '+CHAR(10)
	SET @v_result = @v_result+'              ,a.module_code '+CHAR(30)
	SET @v_result = @v_result+'          FROM SCM_ADM_RECIPIENT_LIST a '+CHAR(10)
	SET @v_result = @v_result+'         INNER JOIN SCM_ADM_RECIPIENT_MESSAGE b '+CHAR(10)
	SET @v_result = @v_result+'            ON a.CATEGORY_ID = b.CATEGORY_ID  '+CHAR(10)
	SET @v_result = @v_result+'         INNER JOIN SCM_ADM_RECIPIENT_SMS_ASSIGN c WITH(NOLOCK)  '+CHAR(10)
	SET @v_result = @v_result+'            ON a.CATEGORY_ID = c.CATEGORY_ID '+CHAR(10)
	SET @v_result = @v_result+'         WHERE a.CATEGORY_ID =' +convert(nvarchar,@p_category_id)+CHAR(10)
	SET @v_result = @v_result+'              AND a.VALID_YN = ''Y'' '+CHAR(10)

	INSERT INTO #tmp_TblErrSmsSendBatch
	exec (@v_result)
	
	DECLARE CUR_ERLM_SEND SCROLL CURSOR FOR
	SELECT * FROM #tmp_TblErrSmsSendBatch

	/********************************************************************************
	메인 처리시작
	********************************************************************************/
	BEGIN TRY
		-- SP 시작 LOG
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		
		OPEN CUR_ERROR_LOG;
		FETCH NEXT FROM CUR_ERROR_LOG INTO @v_pgm_name, @v_pgm_log_type, @v_pgm_event_tm;

		SET @n_longtm_fetch_sts = @@FETCH_STATUS;		-- 이중 loop 를 사용하므로 장기실행 미완료 건에 대한 fetch status 를 보관한다.

		SET @n_proc_cnt = 0;

		-- 장기수행 미완료 건을 Fetch 해서 순차처리한다.
		SET @v_log_type = 'TXN';
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_message = 'Error process check';
        SET @v_description = 'sms category / check time(min) ... ' + ' / ' + CONVERT(VARCHAR, @p_category_id) + ' / ' + CONVERT(VARCHAR, @p_check_tm) ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;   


		WHILE @n_longtm_fetch_sts = 0
			BEGIN

				--select @v_pgm_name, @v_pgm_log_type, @v_pgm_event_tm;

				-- 현재 Fetch 된 미완료건을 SMS 대상자 모두에게 전송한다.
				IF @n_proc_cnt = 0
					OPEN CUR_ERLM_SEND;

				IF @n_proc_cnt = 9
					FETCH FIRST FROM CUR_ERLM_SEND INTO @v_message_content, @v_sms_phone, @v_use_type_code, @v_module_code; 
				ELSE
					FETCH NEXT FROM CUR_ERLM_SEND INTO @v_message_content, @v_sms_phone, @v_use_type_code, @v_module_code;

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
										,@p_category_id
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

						SET @v_message_content = '';

						FETCH NEXT FROM CUR_ERLM_SEND INTO @v_message_content, @v_sms_phone, @v_use_type_code, @v_module_code

					END

				SET @n_proc_cnt = 9;

				-- 다음 미완료 건을 Fetch 한다.
				FETCH NEXT FROM CUR_ERROR_LOG INTO @v_pgm_name, @v_pgm_log_type, @v_pgm_event_tm;

				SET @n_longtm_fetch_sts = @@FETCH_STATUS;		-- 이중 loop 를 사용하므로 장기실행 미완료 건에 대한 fetch status 를 보관한다.

			END -- 장기수행 미완료건 loop end.

		-- 장기수행 미완료건 커서해제
		CLOSE CUR_ERROR_LOG;
		DEALLOCATE CUR_ERROR_LOG;

		-- SMS 대상자 커서해제
		IF @n_proc_cnt > 0
		    CLOSE CUR_ERLM_SEND;

		DEALLOCATE CUR_ERLM_SEND;

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
		CLOSE CUR_ERROR_LOG;
		DEALLOCATE CUR_ERROR_LOG;

		CLOSE CUR_ERLM_SEND;
		DEALLOCATE CUR_ERLM_SEND;

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
