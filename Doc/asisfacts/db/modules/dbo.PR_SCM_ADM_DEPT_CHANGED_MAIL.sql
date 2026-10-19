
/*
 * Program ID   : PR_SCM_ADM_DEPT_CHANGED_MAIL
 * Description  : 부서변경으로 인한 권한삭제 메일 전송
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2023.02.20   FP Pjt.        [E20230216-000381]권한 보유자의 소속변경(부서이동)시 권한삭제 예정 안내 메일 전송(유예기간 15일)
 * 2023.03.07   FP Pjt.        메일 제목에 영문 추가
 */


CREATE PROCEDURE [dbo].[PR_SCM_ADM_DEPT_CHANGED_MAIL]
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
    SET NOCOUNT ON;

	-- 변수 설정
	DECLARE @v_user_id          NVARCHAR(30);   -- 사용자ID
	DECLARE @v_user_name        NVARCHAR(150);  -- 사용자명
	DECLARE @v_remain_day       NVARCHAR(30);   -- 권한회수까지 남은 일수
	DECLARE @v_mail_receiver    NVARCHAR(30);   -- 메일 수신자
	DECLARE @v_mail_subject     NVARCHAR(200);  -- 메일 제목
	DECLARE @v_mail_body        NVARCHAR(MAX);  -- 메일 내용
	DECLARE @v_mail_send_cnt    INT = 1;        -- 메일 전송 카운트
	DECLARE @v_profile_name     nvarchar(50);

	DECLARE @v_to_mail              NVARCHAR(MAX);
	DECLARE @v_mail_title			NVARCHAR(MAX);
	DECLARE @v_body_text1			NVARCHAR(MAX);
	DECLARE @v_body_text2			NVARCHAR(MAX);
	DECLARE @v_body_text3			NVARCHAR(MAX);
	DECLARE @v_body_text4			NVARCHAR(MAX);
	DECLARE @v_table_col		    NVARCHAR(MAX);
	DECLARE @v_table_row			NVARCHAR(MAX);
	DECLARE @TABLE_BODY				NVARCHAR(MAX);

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCM_ADM_DEPT_CHANGED_MAIL';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	DECLARE @INX		INT	= 0;
    DECLARE @MAX_NUM	INT	= 0;
	DECLARE @TAB		TABLE
	(
	    ROWNUM	    INT,
		[GROUP_ID] [nvarchar](20) NOT NULL,
		[DIVISION_ID] [nvarchar](30) NOT NULL,
		[APPROVAL_RESULT] [nvarchar](10) NULL,
		[APPROVAL_ID] [nvarchar](150) NULL,
		[APPROVAL_NAME] [nvarchar](150) NULL,
		[APPROVED_DATE] [nvarchar](150) NULL
	);

	--  메일 내용 설정
	SET @v_mail_subject  = N'부서변경으로 인한 GSCM 시스템 권한 삭제 안내(Guidance on the deletion of GSCM system authority due to department changes)';

	BEGIN TRY
		-- 시작 LOG
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


		DECLARE CUR_CHANGED CURSOR FOR
			SELECT DISTINCT V.USER_ID
				 , V.USER_NAME
				 , V.REMAIN_DAYS 
			  FROM dbo.SCM_ADM_DEPT_CHANGED_V AS V
			 WHERE 1 = 1
			   AND V.ELAPSED_DAYS IN (0, 1, 5, 10)

		OPEN CUR_CHANGED;
			FETCH NEXT FROM CUR_CHANGED
			INTO @v_user_id, @v_user_name, @v_remain_day

			WHILE (@@FETCH_STATUS = 0)  
			BEGIN
			    
				DELETE FROM @TAB;

				INSERT INTO @TAB (ROWNUM, GROUP_ID, DIVISION_ID, APPROVAL_RESULT, APPROVAL_ID, APPROVAL_NAME, APPROVED_DATE)
			    SELECT ROW_NUMBER() OVER (ORDER BY V.GROUP_ID, V.DIVISION_ID ) AS ROWNUM
				     , V.GROUP_ID
				     , V.DIVISION_ID 
					 , V.APPROVAL_RESULT
					 , V.APPROVAL_ID
					 , V.APPROVAL_NAME
					 , V.APPROVED_DATE
			      FROM dbo.SCM_ADM_DEPT_CHANGED_V AS V
			     WHERE 1 = 1
				   AND V.USER_ID = @v_user_id
				 ORDER BY 
				       GROUP_ID
				     , DIVISION_ID


				IF @v_remain_day > 0 
				BEGIN
					SET @v_body_text1 = N'부서변경으로 인하여 ' + @v_user_name + N'님의 아래 GSCM권한이 ' + @v_remain_day + N'일내로 회수될 예정입니다.'
					SET @v_body_text3 = 'Your SCM authority will be deleted in ' + @v_remain_day + ' days due to change your department.'
				END
				ELSE
				BEGIN
					SET @v_body_text1 = N'부서변경으로 인하여 ' + @v_user_name + N'님의 아래 GSCM권한이 즉시 회수될 예정입니다.'
					SET @v_body_text3 = 'Your SCM authority will be deleted immediately due to change your department.'
				END

				SET @v_body_text2 = N'권한유지를 원하신다면 시스템을 통해 재 신청해 주세요. 권한 신청관련 문의사항 있으시면 SCM PI팀으로 연락주시기 바랍니다.'
				SET @v_body_text4 = 'If you want to last your authority, please register authority request. If you have any questions about authority request, please contact the SCM PI Team.'


				SET @v_table_col = '';
				SET @v_table_col = @v_table_col + '<tr style="text-align:center">'
				SET @v_table_col = @v_table_col + '<th>' + 'Authority'		+ '</th>'
				SET @v_table_col = @v_table_col + '<th>' + 'Division'			+ '</th>'
				SET @v_table_col = @v_table_col + '<th>' + 'Approval Result'	+ '</th>'
				SET @v_table_col = @v_table_col + '<th>' + 'Approval User'	+ '</th>'
				SET @v_table_col = @v_table_col + '<th>' + 'Approved Date'	+ '</th>'
				SET @v_table_col = @v_table_col + '</tr>'

				SET @v_table_row = ''

				SELECT @INX			= 1
					  ,@MAX_NUM		= COUNT(*)
				  FROM @TAB

				DECLARE @t_group_id			NVARCHAR(20);
				DECLARE @t_division_id		NVARCHAR(30);
				DECLARE @t_approval_result	NVARCHAR(10);
				DECLARE @t_approval_id	    NVARCHAR(150);
				DECLARE @t_approval_name    NVARCHAR(150);
				DECLARE @t_approved_date	NVARCHAR(150);

				WHILE @INX <= @MAX_NUM
				BEGIN 

					SELECT @t_group_id			= GROUP_ID
						 , @t_division_id		= DIVISION_ID
						 , @t_approval_result	= APPROVAL_RESULT
						 , @t_approval_id	    = APPROVAL_ID
						 , @t_approval_name	    = APPROVAL_NAME
						 , @t_approved_date	    = APPROVED_DATE
					  FROM @TAB 
					 WHERE ROWNUM = @INX

					-- select * from @tab where rownum = @inx;
					SET @t_approval_name = @t_approval_name + '(' + @t_approval_id + ')'
					
					SET @v_table_row = @v_table_row+ '<tr style="text-align:center">'
					SET @v_table_row = @v_table_row+ '<td>' + REPLACE(ISNULL(@t_group_id,''), CHAR(10),' ')			+ '</td>'
					SET @v_table_row = @v_table_row+ '<td>' + REPLACE(ISNULL(@t_division_id,''), CHAR(10),' ')		+ '</td>'
					SET @v_table_row = @v_table_row+ '<td>' + REPLACE(ISNULL(@t_approval_result,''), CHAR(10),' ')	+ '</td>'
					SET @v_table_row = @v_table_row+ '<td>' + REPLACE(ISNULL(@t_approval_name,''), CHAR(10),' ')	+ '</td>'
					SET @v_table_row = @v_table_row+ '<td>' + REPLACE(ISNULL(@t_approved_date,''), CHAR(10),' ')	+ '</td>'
					SET @v_table_row = @v_table_row+ '</tr>'

					SET @INX = @INX + 1

				END


				SET @TABLE_BODY = ''
				SET @TABLE_BODY = ' <html>
							<head>
							<title>Untitled Document</title>
							<style>
								* {margin:0;padding:0;}
								body {font-family:Malgun Gothic, Arial, Helvetica, sans-serif;font-size:12px;line-height:1.8;color:#333333;}
								table {border-collapse:collapse;width:100%;}
								table th {background:#f5f5f5;border-bottom:1px solid #e1e1e1;}
								table td {background:#fff;border-right:1px solid #e1e1e1;border-left:1px solid #e1e1e1;border-bottom:1px solid #e1e1e1;}
								table tbody th {border-left:1px solid #e1e1e1;text-align:center;padding:6px 8px;font-size:12px}
								table tbody td {padding:6px 8px;font-size:12px}
								table thead th {text-align:center;padding:3px;border-right:1px solid #e1e1e1;border-left:1px solid #e1e1e1; border-bottom:1px solid #d1d1d1;font-size:12px}
								.hori-table table thead td {text-align:center;padding:3px;}  
								.hori-table table tbody td {text-align:center;padding:3px;}
								.vertical-table, .hori-table {margin-bottom:20px;}
							</style>
							</head>
							<body>' 
								+ '<br />'
								+ '<b>' + REPLACE(ISNULL(@v_body_text1, ''), CHAR(10), '<br />') + '</b>' 
								+ '<br />' 
								+ '<b>' + REPLACE(ISNULL(@v_body_text2, ''), CHAR(10), '<br />') + '</b>' 
								+ '<br />' 
								+ '<br />'
								+ '<b>' + REPLACE(ISNULL(@v_body_text3, ''), CHAR(10), '<br />') + '</b>' 
								+ '<br />' 
								+ '<b>' + REPLACE(ISNULL(@v_body_text4, ''), CHAR(10), '<br />') + '</b>' 
								+ '<br />' 
								+ '<br />'
								+ '<br />'
								+ '<div><table style=''border-top:2px solid #c8294b; width:750px;''>
									<thead>' + ISNULL(@v_table_col, '') + '</thead>
									<tbody>' + ISNULL(@v_table_row, '') + '</tbody>
								   </div>
							</body>
					</html>'


					SET @v_mail_receiver = @v_user_id + '@lgensol.com'; -- 실제 사용자
					--SET @v_mail_receiver = @v_user_id + '@lgespartner.com'; -- 실제 사용자
					--SET @v_mail_receiver = 'crjung@lgespartner.com'; -- 실제 사용자

					IF @v_mail_send_cnt % 10 = 0		--10건 전송시마다
					BEGIN
						WAITFOR DELAY '00:00:05'		-- 5초 딜레이
						PRINT N'메일 전송 대기 중 입니다.';
					END

					SET @v_mail_body = @TABLE_BODY

					-- 메일 전송
					SELECT @v_profile_name = IIF(db_name() = 'LGCE_SCMDEV', 'GSCM_MAIL_PROD', 'GSCM_MAIL_TEST');

					EXEC msdb.dbo.sp_send_dbmail
					     @profile_name		= @v_profile_name
					   , @recipients		= @v_mail_receiver
					   , @subject			= @v_mail_subject
					   , @body				= @v_mail_body
					   , @body_format		= 'html';

					-- 메일 전송 카운트 증가
					SET @v_mail_send_cnt = @v_mail_send_cnt + 1;

				FETCH NEXT FROM CUR_CHANGED
				INTO @v_user_id, @v_user_name, @v_remain_day
			END

		-- CURSOR 종료	
		CLOSE CUR_CHANGED;
		DEALLOCATE CUR_CHANGED;
		
		-- 종료 LOG
		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;  

	END TRY

	-- CATCH 실행
	BEGIN CATCH
		CLOSE CUR_CHANGED;
		DEALLOCATE CUR_CHANGED;

		BEGIN

			SET @v_description = @v_program_name + N'ERROR_LINE : ' + STR(ERROR_LINE());

			INSERT INTO scm_sys_log_batch (
			       PROGRAM_NAME
				 , LOG_TYPE
				 , LOG_COUNT
				 , LOG_MESSAGE
				 , DESCRIPTION
				 , EVENT_DATE
				 , CREATION_DATE
				 , CREATED_BY
				 , LAST_UPDATE_DATE
	             , LAST_UPDATED_BY)
			VALUES (ERROR_PROCEDURE()
				 , 'ERROR'
				 , NULL
				 , ERROR_MESSAGE()
				 , @v_description
				 , SYSDATETIME()
				 , SYSDATETIME()
				 , ERROR_PROCEDURE()
				 , SYSDATETIME()
				 , ERROR_PROCEDURE());

			IF @@TRANCOUNT > 0
				COMMIT WORK;

		END;

		-- error코드, errror 메시지 반환
		SELECT 'F' AS result_code;
		SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
	END CATCH;
 
END
