
/*
 * Program ID   : PR_LONGTIME_CHK_SMS_SEND
 * Description  : 장기수행작업 체크 및 SMS 전송
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2020/08/13   KSW            장기수행작업 체크 및 SMS 전송
 * 2020/08/25   KSW            장기수행 체크 예외처리 (LOOKUP 등록건 예외처리)
 * 2020/09/22   KSW            프로시저 이름이 긴 경우 오류가 발생하므로 MSG 길이를 80 byte 제한
 * 2024/11/25   kimcd          기본 30분 초과 시간 초과 작업별 초과 시간 조정하여 작업 중요도 전송. 수신자 level 관리
 *
 */
CREATE PROCEDURE [dbo].[PR_LONGTIME_CHK_SMS_SEND]

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
	DECLARE @n_def_check_tm     INTEGER = 30;		-- check time (min) :: START 이후 수행시간
	DECLARE @n_check_tm         INTEGER;
	DECLARE @n_longtm_fetch_sts INTEGER;
	DECLARE @n_proc_cnt         INTEGER;

	-- 대상건 Fetch 변수
	DECLARE @v_pgm_name         NVARCHAR(150);
	DECLARE @v_pgm_log_type     NVARCHAR(150);
	DECLARE @v_pgm_event_tm     DATETIME;
	DECLARE @v_pgm_run_time     NUMERIC;-- 2024-11-25 kimcd 작업 경과 시간 추가
	DECLARE @v_pgm_c_time       INTEGER;-- 2024-11-25 kimcd 기준 시간 추가

	DECLARE @v_message_content  NVARCHAR(4000);
	DECLARE @v_sms_phone		NVARCHAR(50);
	DECLARE @v_sms_send_phone	NVARCHAR(50);
	DECLARE @v_use_type_code    NVARCHAR(10);
	DECLARE @v_module_code		NVARCHAR(30);
	DECLARE @v_receiver_level	INT; -- 2024-11-25 kimcd 수신자 level 추가

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_LONGTIME_CHK_SMS_SEND';
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
	* 장기수행작업 SMS 를 보낼 대상을 추출하기 위해서 임시테이블만들기
	********************************************************************************/
	IF EXISTS (SELECT * FROM tempdb.sys.sysobjects WHERE name = '#tmp_SCP_LONGTM_CHECK')
		   DROP TABLE #tmp_SCP_LONGTM_CHECK
 
	CREATE TABLE #tmp_SCP_LONGTM_CHECK (
			 C_PROGRAM_NAME	    NVARCHAR(150),
			 C_LOG_TYPE			NVARCHAR(30),
			 C_EVENT_DATE		DATETIME,
			 C_RUN_TIME         NUMERIC,   -- 2024-11-25 kimcd 작업 경과 시간 추가
			 C_TIME             INTEGER    -- 2024-11-25 kimcd 기준 시간 추가
	);

	---------------------------------------------------------------------------------
	-- 장기수행 체크 예외처리 (LOOKUP 등록건 예외처리) 추가 :: 2020.08.25 KSW - start
	---------------------------------------------------------------------------------
	-- 이하 주석처리
	--INSERT INTO #tmp_SCP_LONGTM_CHECK
	--SELECT W.PROGRAM_NAME, W.LOG_TYPE, MAX(W.EVENT_DATE) AS EVENT_DATE
	--  FROM (
	--		SELECT PROGRAM_NAME, LOG_TYPE, EVENT_DATE
	--		  FROM [dbo].[SCM_SYS_LOG_BATCH] WITH (NOLOCK)
	--		 WHERE DATEDIFF ( d , EVENT_DATE , getdate() ) < 1
	--		   AND LOG_TYPE = 'START'
	--	   ) W
	-- WHERE NOT EXISTS ( SELECT 1 FROM [dbo].[SCM_SYS_LOG_BATCH] X WITH (NOLOCK)
	--					 WHERE W.PROGRAM_NAME = X.PROGRAM_NAME
	--					   AND W.EVENT_DATE <= X.EVENT_DATE
	--					   AND X.LOG_TYPE IN ( 'END', 'ERROR' )
	--				  )
	--   AND DATEDIFF ( mi , EVENT_DATE , getdate() ) > @n_check_tm
 --    GROUP BY W.PROGRAM_NAME, W.LOG_TYPE
	-- ;
	 WITH JOB AS ( SELECT SEGMENT1   AS PROC_NAME
	                     ,ATTRIBUTE1 AS C_TIME
	               FROM   [DBO].[SCM_ADM_LOOKUP_MASTER_DETAIL] AMD WITH(NOLOCK)
	               WHERE  AMD.[LOOKUP_TYPE] = 'SCM_LONG_TEMP_JOB'
				   AND    AMD.VALID_YN      = 'Y'
		           )  -- 2024-11-25 kimcd 작업 기준 시간 조회 추가
	 INSERT INTO #tmp_SCP_LONGTM_CHECK
	 SELECT W.PROGRAM_NAME, W.LOG_TYPE, MAX(W.EVENT_DATE) AS EVENT_DATE, MAX(DATEDIFF ( mi , EVENT_DATE , getdate() )) AS RUN_TIME  -- 2024-11-25 kimcd 작업 경과 시간 추가
	       ,ISNULL( (SELECT CONVERT(NUMERIC, JOB.C_TIME) AS C_TIME FROM JOB WHERE JOB.PROC_NAME = W.PROGRAM_NAME), @n_check_tm)  AS C_TIME -- 2024-11-25 kimcd 기준 시간 추가
	  FROM (
			SELECT PROGRAM_NAME, LOG_TYPE, EVENT_DATE
			  FROM [dbo].[SCM_SYS_LOG_BATCH] WITH (NOLOCK)
			 WHERE DATEDIFF ( d , EVENT_DATE , getdate() ) < 1
			   AND LOG_TYPE = 'START'
			   AND NOT PROGRAM_NAME IN (SELECT SEGMENT2 AS PROGRAM_NM
										 FROM dbo.SCM_ADM_LOOKUP_MASTER_DETAIL WITH (NOLOCK)  
										WHERE LOOKUP_TYPE  ='LONGTIME_SMS_EXCEPT_LIST'
										  AND VALID_YN ='Y')
		   ) W
	 WHERE NOT EXISTS ( SELECT 1 FROM [dbo].[SCM_SYS_LOG_BATCH] X WITH (NOLOCK)
						 WHERE W.PROGRAM_NAME = X.PROGRAM_NAME
						   AND W.EVENT_DATE <= X.EVENT_DATE
						   AND X.LOG_TYPE IN ( 'END', 'ERROR' )
					  )
	   AND DATEDIFF ( mi , EVENT_DATE , getdate() ) > ISNULL( (SELECT CONVERT(NUMERIC, JOB.C_TIME) AS C_TIME FROM JOB WHERE JOB.PROC_NAME = W.PROGRAM_NAME), @n_check_tm)
	   -- 2024-11-25 kimcd 작업 기준 시간으로 조회 조건 추가
     GROUP BY W.PROGRAM_NAME, W.LOG_TYPE
	 ;
	---------------------------------------------------------------------------------
	-- 장기수행 체크 예외처리 (LOOKUP 등록건 예외처리) 추가 :: 2020.08.25 KSW - end
	---------------------------------------------------------------------------------
	
	BEGIN
		DECLARE CUR_LONGTM_LOG CURSOR FOR
		SELECT * FROM #tmp_SCP_LONGTM_CHECK
	END


	/********************************************************************************
	* SMS 대상자 임시테이블만들기
	********************************************************************************/
	IF EXISTS (SELECT * FROM tempdb.sys.sysobjects WHERE name = '#tmp_TblSmsSendBatch')
		   DROP TABLE #tmp_TblSmsSendBatch
 
	CREATE TABLE #tmp_TblSmsSendBatch (
			 message_content	NVARCHAR(4000),
			 sms_phone			NVARCHAR(50),
			 use_type_code		NVARCHAR(10),
			 module_code		NVARCHAR(30),
			 receiver_level		INT -- 2024-11-25 kimcd 수신자 level 추가
	);

	SET @v_result = ''
	SET @v_result = @v_result+'        SELECT b.message_content '+CHAR(10)
	SET @v_result = @v_result+'              ,c.sms_phone '+CHAR(10)
	SET @v_result = @v_result+'              ,a.use_type_code '+CHAR(10)
	SET @v_result = @v_result+'              ,a.module_code '+CHAR(30)
	SET @v_result = @v_result+'              ,c.receiver_level '+CHAR(30)  -- 2024-11-25 kimcd 수신자 level 추가
	SET @v_result = @v_result+'          FROM SCM_ADM_RECIPIENT_LIST a '+CHAR(10)
	SET @v_result = @v_result+'         INNER JOIN SCM_ADM_RECIPIENT_MESSAGE b '+CHAR(10)
	SET @v_result = @v_result+'            ON a.CATEGORY_ID = b.CATEGORY_ID  '+CHAR(10)
	SET @v_result = @v_result+'         INNER JOIN SCM_ADM_RECIPIENT_SMS_ASSIGN c WITH(NOLOCK)  '+CHAR(10)
	SET @v_result = @v_result+'            ON a.CATEGORY_ID = c.CATEGORY_ID '+CHAR(10)
	SET @v_result = @v_result+'         WHERE a.CATEGORY_ID =' +convert(nvarchar,@p_category_id)+CHAR(10)
	SET @v_result = @v_result+'              AND a.VALID_YN = ''Y'' '+CHAR(10)

	INSERT INTO #tmp_TblSmsSendBatch
	exec (@v_result)
	
	DECLARE CUR_LM_SEND SCROLL CURSOR FOR
	SELECT * FROM #tmp_TblSmsSendBatch

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
		
		OPEN CUR_LONGTM_LOG;
		FETCH NEXT FROM CUR_LONGTM_LOG INTO @v_pgm_name, @v_pgm_log_type, @v_pgm_event_tm, @v_pgm_run_time, @v_pgm_c_time; -- 2024-11-25 kimcd 작업 경과 시간 추가;
		
		SET @n_longtm_fetch_sts = @@FETCH_STATUS;		-- 이중 loop 를 사용하므로 장기실행 미완료 건에 대한 fetch status 를 보관한다.

		SET @n_proc_cnt = 0;

		-- 장기수행 미완료 건을 Fetch 해서 순차처리한다.
		SET @v_log_type = 'TXN';
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_message = 'Start Long time process';
        SET @v_description = 'sms category / check time(min) ... ' + ' / ' + CONVERT(VARCHAR, @p_category_id) + ' / ' + CONVERT(VARCHAR, @p_check_tm) ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;   


		WHILE @n_longtm_fetch_sts = 0
			BEGIN

				--select @v_pgm_name, @v_pgm_log_type, @v_pgm_event_tm;

				-- 현재 Fetch 된 미완료건을 SMS 대상자 모두에게 전송한다.
				IF @n_proc_cnt = 0
					OPEN CUR_LM_SEND;

				IF @n_proc_cnt = 9
					FETCH FIRST FROM CUR_LM_SEND INTO @v_message_content, @v_sms_phone, @v_use_type_code, @v_module_code, @v_receiver_level; -- 2024-11-25 kimcd 수신자 level 추가
				ELSE
					FETCH NEXT FROM CUR_LM_SEND INTO @v_message_content, @v_sms_phone, @v_use_type_code, @v_module_code, @v_receiver_level; -- 2024-11-25 kimcd 수신자 level 추가

				SET @n_proc_cnt = 1;

				WHILE @@FETCH_STATUS = 0
					BEGIN
				        IF @v_receiver_level IS NULL OR @v_receiver_level = '' OR @v_receiver_level = 1 
						   OR ( @v_receiver_level = 2 AND @v_pgm_run_time > @v_pgm_c_time * 2) 
						   OR ( @v_receiver_level = 3 AND @v_pgm_run_time > @v_pgm_c_time * 3)
						BEGIN -- 2024-11-25 kimcd 수신자 level별 전송 구분 추가
						    BEGIN
						    	IF ISNULL(@p_longtm_msg,'') != ''
						    		SET @v_message_content = LEFT('[' +@v_module_code+ ']'+@p_longtm_msg+' '+@v_message_content, 79)
						    	ELSE
						    		SET @v_message_content = LEFT('[' +@v_module_code+ ']PNM:'+@v_pgm_name+' '+@v_message_content + ' RUN :' + CONVERT(NVARCHAR(30),@v_pgm_run_time), 79) -- 2024-11-25 kimcd 작업 경과 시간 추가;
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
					    END;

						FETCH NEXT FROM CUR_LM_SEND INTO @v_message_content, @v_sms_phone, @v_use_type_code, @v_module_code, @v_receiver_level; -- 2024-11-25 kimcd 수신자 level 추가

					END

				SET @n_proc_cnt = 9;

				-- 다음 미완료 건을 Fetch 한다.
				FETCH NEXT FROM CUR_LONGTM_LOG INTO @v_pgm_name, @v_pgm_log_type, @v_pgm_event_tm, @v_pgm_run_time, @v_pgm_c_time; -- 2024-11-25 kimcd 작업 경과 시간 추가;

				SET @n_longtm_fetch_sts = @@FETCH_STATUS;		-- 이중 loop 를 사용하므로 장기실행 미완료 건에 대한 fetch status 를 보관한다.

			END -- 장기수행 미완료건 loop end.

		-- 장기수행 미완료건 커서해제
		CLOSE CUR_LONGTM_LOG;
		DEALLOCATE CUR_LONGTM_LOG;

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
		CLOSE CUR_LONGTM_LOG;
		DEALLOCATE CUR_LONGTM_LOG;

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