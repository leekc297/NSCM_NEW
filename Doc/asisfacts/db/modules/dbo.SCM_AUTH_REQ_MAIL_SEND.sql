
/*
 * Program ID   : SCM_AUTH_REQ_MAIL_SEND
 * Description  : GSCM 권한 요청 알림 MAIL 발송
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/03/11   KIMYONGHO	   [C20210310-000519] 최초작성 
 */
create PROCEDURE [dbo].[SCM_AUTH_REQ_MAIL_SEND]

	 @p_user_id		 nvarchar(max)
	
AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON;
	
	DECLARE @v_to_mail              NVARCHAR(MAX);
	DECLARE @v_category_id			INT;
	DECLARE @v_approval_id			NVARCHAR(MAX);
	DECLARE @v_request_id			NVARCHAR(MAX);
	DECLARE @v_request_name			NVARCHAR(MAX);
	DECLARE @v_group_id				NVARCHAR(MAX);
	DECLARE @v_mail_title			NVARCHAR(MAX);
	DECLARE @v_body_contents		NVARCHAR(MAX);

	DECLARE @v_body_text			NVARCHAR(MAX);
	DECLARE @v_head_cont		    NVARCHAR(MAX);
	DECLARE @v_a_body_contents		NVARCHAR(MAX);
	DECLARE @TABLE_BODY				NVARCHAR(MAX);
	DECLARE @p_html_yn				NVARCHAR(1);
	
	DECLARE @v_division_id			NVARCHAR(30);
	DECLARE @v_dept_description		NVARCHAR(MAX);
	DECLARE @v_approval_result		NVARCHAR(MAX);

	DECLARE @v_request_date			NVARCHAR(50);
	DECLARE @v_last_update_date		NVARCHAR(50);
	DECLARE @v_last_update_by		NVARCHAR(MAX);

	SET @v_to_mail              = null;
	SET @v_category_id			= 0;
	SET @v_approval_id			= null;
	SET @v_request_id			= null;
	SET @v_mail_title			= null;
	SET @v_body_contents		= null;

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCM_AUTH_REQ_MAIL_SEND';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	--계산용 변수
	DECLARE @chk INT=0; -- 쿼리결과 총 건수

	--DECLARE @i INT=1;	-- LOOP용
	DECLARE @mailChkCnt INT = 0;

	--임시테이블 생성
	IF OBJECT_ID('tempdb..#TblSCMAuthReqMailSend') IS NOT NULL
		DROP TABLE #TblSCMAuthReqMailSend 

	
	SET @v_category_id = 74;
	
	/********************************************************************************
	* 권한 요청 건 상세 내용 
	********************************************************************************/
	--SELECT @v_request_id		= A.USER_ID
	--	  ,@v_request_name		= A.UserName
	--	  ,@v_dept_description	= A.SEGMENT2
	--	  ,@v_approval_id		= A.SEGMENT3
	--	  ,@v_group_id			= A.GROUP_ID
	--	  ,@v_division_id		= A.DIVISION_ID
	--	  ,@v_request_date		= A.CREATION_DATE
	--	  ,@v_approval_relsult	= A.APPROVAL_RESULT
	--	  ,@v_mail_title		= B.MAIL_TITLE
	--	  ,@v_body_contents		= B.body_contents

	SELECT A.USER_ID
		  , A.UserName
		  , A.DEPT_NAME_KO
		  , A.SEGMENT3
		  , A.GROUP_ID
		  , A.DIVISION_ID
		  , A.CREATION_DATE
		  , A.APPROVAL_RESULT
		  , B.MAIL_TITLE
		  , B.body_contents
		  ,	ROW_NUMBER() OVER (ORDER BY A.USER_ID, A.GROUP_ID , A.DIVISION_ID, A.APPROVAL_RESULT) AS ROWNUM
	INTO #TblSCMAuthReqMailSend
	FROM(
			SELECT A.USER_ID, U.UserName, DP.DEPT_NAME_KO, SEGMENT3, A.GROUP_ID, A.DIVISION_ID, A.CREATION_DATE, A.APPROVAL_RESULT, 'KO' language
			FROM SCM_MST_AUTH_REQUEST A
			INNER JOIN TB_FX_User U 
				ON A.USER_ID = U.UserID AND U.UseYN = 'Y'
			INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL  B 
				ON A.GROUP_ID = B.SEGMENT1 
				AND B.LOOKUP_TYPE = 'AUTH_REQ_MAIL_SEND' 
				AND B.VALID_YN = 'Y'
			LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO DP ON DP.DEPT_ID = U.DEPT_ID

			WHERE A.USER_ID = @p_user_id
			  AND A.APPROVAL_RESULT = 'REQUESTING'
		) A ,
		(
			SELECT a.use_type_code 
				,c.user_id
				,e.UserName as user_name 
				,e.Email as email_addr 
				,e.CellPhoneNum as mobile_phone 
				,b.language_code 
				,b.mail_title 
				,d.SEGMENT3       header_contents 
				,CASE A.USE_TYPE_CODE WHEN 'MAIL' THEN replace(b.message_content,char(10),'<br><br>') 
										WHEN 'SMS' THEN b.message_content END body_contents 
				,d.SEGMENT3      foot_contents
				,a.SQL_LONG_TEXT
			FROM SCM_ADM_RECIPIENT_LIST  a WITH(NOLOCK)
				INNER JOIN SCM_ADM_RECIPIENT_MESSAGE b ON a.CATEGORY_ID = B.CATEGORY_ID
				LEFT OUTER JOIN SCM_ADM_RECIPIENT_ASSIGN  c ON B.CATEGORY_ID = C.CATEGORY_ID  
				INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL  d ON D.SEGMENT1 = B.LANGUAGE_CODE AND D.LOOKUP_TYPE = 'MAIL_HEADER_FOOT' AND D.VALID_YN = 'Y' 
				LEFT OUTER JOIN TB_FX_User e ON B.LANGUAGE_CODE = E.Language AND C.USER_ID = E.UserID 
			WHERE a.category_id   = convert(nvarchar,'74')
				AND a.VALID_YN = 'Y' 
		) B
		WHERE A.language = B.LANGUAGE_CODE
		;



	SELECT @chk = COUNT(*)
	FROM #TblSCMAuthReqMailSend
	;


	/********************************************************************************
	* 출하 계획 요청 건 상세 내용 테이블 만들기
	********************************************************************************/	
	
	SET @v_head_cont = '';
	SET @v_head_cont = @v_head_cont+ '<tr>'
	SET @v_head_cont = @v_head_cont+ '<th rowspan=''2''>' + 'User ID' + '</th>'
	SET @v_head_cont = @v_head_cont+ '<th rowspan=''2''>' + 'User Name' + '</th>'
	SET @v_head_cont = @v_head_cont+ '<th rowspan=''2''>' + 'Department' + '</th>'
	SET @v_head_cont = @v_head_cont+ '<th rowspan=''2''>' + 'Authority' + '</th>'
	SET @v_head_cont = @v_head_cont+ '<th rowspan=''2''>' + 'Div' + '</th>'
	SET @v_head_cont = @v_head_cont+ '<th rowspan=''2''>' + 'Request Date' + '</th>'
	SET @v_head_cont = @v_head_cont+ '<th rowspan=''2''>' + 'Approval Result' + '</th>'
	SET @v_head_cont = @v_head_cont+ '</tr>'

	SET @v_a_body_contents = ''
	SET @v_body_text = ''

	SET @mailChkCnt = @mailChkCnt + 1; -- 한 행 FETCH시 마다 +1


	SELECT @v_request_id		= USER_ID
		  ,@v_request_name		= UserName
		  ,@v_dept_description	= DEPT_NAME_KO
		  ,@v_approval_id		= SEGMENT3
		  ,@v_group_id			= GROUP_ID
		  ,@v_division_id		= DIVISION_ID
		  ,@v_request_date		= CREATION_DATE
		  ,@v_approval_result	= APPROVAL_RESULT
		  ,@v_mail_title		= MAIL_TITLE
		  ,@v_body_contents		= body_contents
	FROM #TblSCMAuthReqMailSend 
	WHERE ROWNUM=@mailChkCnt
	;

	----WHILE @@FETCH_STATUS = 0
	WHILE @mailChkCnt <= @chk+1
		BEGIN

			IF @mailChkCnt=1
				BEGIN
					SET @v_body_text = @v_body_text+ 'Requested by : '+@v_request_name+'('+@v_request_id+')' + ' Last request Date : '+@v_request_date+'</br></br>'
				END

			IF (@mailChkCnt=@chk+1)
				BEGIN

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
													table tbody th {border-left:1px solid #e1e1e1;text-align:right;padding:6px 8px;font-size:12px}
													table tbody td {padding:6px 8px;font-size:12px}
													table thead th {text-align:center;padding:3px;border-right:1px solid #e1e1e1;border-left:1px solid #e1e1e1; border-bottom:1px solid #d1d1d1;font-size:12px}
													.hori-table table thead td {text-align:center;padding:3px;}  
													.hori-table table tbody td {text-align:center;padding:3px;}
													.vertical-table, .hori-table {margin-bottom:20px;}
												</style>
												</head>
												<body>' +'</br>'+
														'<b>' + REPLACE(ISNULL(@v_body_contents, ''), CHAR(10), '<br>') + '</b>' + '</br>'+ '</br>'+
														'<b>' + REPLACE(ISNULL(@v_body_text, ''), CHAR(10), '<br>') + '</b>' +
				--										'<div id="divBody" style="width: 100%; overflow-x: auto; overflow-y: auto; font-size: 9pt; line-break: auto;">'    + '</br>'+   
													'<table style=''border-top:2px solid #c8294b; width:900px;''>
													<thead>' + ISNULL(@v_head_cont,'') +'</thead>
													<tbody>' + ISNULL(@v_a_body_contents, '') + '</tbody>
													</div>
												</body>
										</html>'
				END

		SET @v_a_body_contents = @v_a_body_contents+ '<tr>'
		SET @v_a_body_contents = @v_a_body_contents+ '<td>' + REPLACE(ISNULL(@v_request_id,''), CHAR(10),' ') + '</td>'
		SET @v_a_body_contents = @v_a_body_contents+ '<td>' + REPLACE(ISNULL(@v_request_name,''), CHAR(10),' ') + '</td>'
		SET @v_a_body_contents = @v_a_body_contents+ '<td>' + REPLACE(ISNULL(@v_dept_description,''), CHAR(10),' ') + '</td>'
		SET @v_a_body_contents = @v_a_body_contents+ '<td>' + REPLACE(ISNULL(@v_group_id,''), CHAR(10),' ') + '</td>'
		SET @v_a_body_contents = @v_a_body_contents+ '<td>' + REPLACE(ISNULL(@v_division_id,''), CHAR(10),' ') + '</td>'
		SET @v_a_body_contents = @v_a_body_contents+ '<td>' + REPLACE(ISNULL(@v_request_date,''), CHAR(10),' ') + '</td>'
		SET @v_a_body_contents = @v_a_body_contents+ '<td>' + REPLACE(ISNULL(@v_approval_result,''), CHAR(10),' ') + '</td>'	
		SET @v_a_body_contents = @v_a_body_contents+ '</tr>'

		SET @mailChkCnt = @mailChkCnt + 1;

		SELECT @v_request_id	= USER_ID
		  ,@v_request_name		= UserName
		  ,@v_dept_description	= DEPT_NAME_KO
		  ,@v_approval_id		= SEGMENT3
		  ,@v_group_id			= GROUP_ID
		  ,@v_division_id		= DIVISION_ID
		  ,@v_request_date		= CREATION_DATE
		  ,@v_approval_result	= APPROVAL_RESULT
		  ,@v_mail_title		= MAIL_TITLE
		  ,@v_body_contents		= body_contents
		FROM #TblSCMAuthReqMailSend 
		WHERE ROWNUM=@mailChkCnt
		;
				
	END;

	BEGIN TRY
			-- 시작 LOG
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = @p_user_id;
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


		SET @v_to_mail = @v_approval_id --+ '@lgensol.com'
		--SET @v_to_mail = 'kimyh8848@lgespartner.com'


		SET @v_body_contents = @TABLE_BODY
		SET @p_html_yn = 'Y'

		-- 메일 발송
		EXEC SCM_ADM_MAIL_SEND
				@v_to_mail
				,@v_mail_title
				,@v_body_contents
				,@p_html_yn
				;

		--///////////////////////////////////////////////////////////////////////////////////////////////////

		IF LEN(@v_body_contents) > 100
			BEGIN
				SET @v_body_contents = SUBSTRING(@v_body_contents,1,100);
			END

		--MAIL 발송 LOG 저장
		--EXEC SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG 'MAIL'
		--				,@v_category_id
		--				,@v_mail_title
		--				,@v_body_contents
		--				,''
		--				,''
		--				,''
		--				,''
		--				,''
		--				,''
		--				,''
		--				,''
		--				,'' --p_send_pgm
		--				,@v_to_mail;

		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	END TRY

	BEGIN CATCH
		BEGIN

		INSERT INTO scm_sys_log_batch (program_name
										,log_type
										,log_count
										,log_message
										,description
										,event_date
										,creation_date
										,created_by
										,last_update_date
										,last_updated_by)
		VALUES (ERROR_PROCEDURE()
				,'ERROR'
				,NULL
				,ERROR_MESSAGE()
				,NULL
				,SYSDATETIME()
				,SYSDATETIME()
				,ERROR_PROCEDURE()
				,SYSDATETIME()
				,ERROR_PROCEDURE());

		IF @@TRANCOUNT > 0
			COMMIT WORK;
		END;
				
		-- error코드, errror 메시지 반환
		SELECT 'F' AS result_code;
		SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
	END CATCH;

	--임시테이블 삭제
	IF OBJECT_ID('tempdb..#TblSCMAuthReqMailSend') IS NOT NULL
		DROP TABLE #TblSCMAuthReqMailSend
END







