
/*
 * Program ID   : SCP0078_GET_GSCM_VOC_MAIL_SEND
 * Description  : GSCM system VOC 알림 MAIL 발송
 *                SCM_AUTH_REQ_MAIL_SEND 참조
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2022/02/18   vadabi3	   [C20210310-000519] 최초작성 
 * 2022/08/24   vadabi3	   단계 제외 (RECEIPT, REVIEW)
 ----------------------------------------------------------------------------------------------------
 EXEC SCP0078_GET_GSCM_VOC_MAIL_SEND   'M', @p_voc_no='1000000013' , @p_voc_step ='CLASSIFY'	
 EXEC SCP0078_GET_GSCM_VOC_MAIL_SEND   'M', @p_voc_no='1000000013' , @p_voc_step ='REVIEW'	
 */
--CREATE PROCEDURE [dbo].[SCP0078_GET_GSCM_VOC_MAIL_SEND]
CREATE PROCEDURE [dbo].[SCP0078_GET_GSCM_VOC_MAIL_SEND]
	@p_active_flag				nvarchar(MAX) ,
	@p_voc_no					nvarchar(max) ,
	@p_voc_step					nvarchar(MAX) 
AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON;
	
	/********************************************************************************
	* DECLARE
	********************************************************************************/
	-- MAIL 용 변수 설정
	DECLARE @v_to_mail              NVARCHAR(MAX);
	DECLARE @v_to_mail_create       NVARCHAR(MAX);
	DECLARE @v_to_mail_create_cnt   INTEGER = 0;
	DECLARE @v_server_real           NVARCHAR(MAX);
	--------------------------------------------------------------------------------
	SET @v_server_real = 'REAL';
	SELECT @v_server_real = dbo.FN_GET_LOOKUP_CODE_DESC('VOC_MAILING', 'RUNSERVER' ) 

	DECLARE @v_mail_title			NVARCHAR(MAX);
	DECLARE @v_body_contents		NVARCHAR(MAX);
	DECLARE @v_body_text			NVARCHAR(MAX);
	DECLARE @v_body_title			NVARCHAR(MAX);
	DECLARE @v_head_cont		    NVARCHAR(MAX);
	DECLARE @v_a_body_contents		NVARCHAR(MAX);
	DECLARE @TABLE_BODY				NVARCHAR(MAX);
	DECLARE @p_html_yn				NVARCHAR(1);
	--------------------------------------------------------------------------------
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0078_GET_GSCM_VOC_MAIL_SEND';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
	--------------------------------------------------------------------------------
	-- VOC 용 변수 설정
    DECLARE @v_voc_type					NVARCHAR(MAX);
	DECLARE @v_division_id				NVARCHAR(MAX);
	DECLARE @v_voc_name					NVARCHAR(MAX);
	DECLARE @v_voc_detail				NVARCHAR(MAX);
	DECLARE @v_request_date				NVARCHAR(MAX);
	DECLARE @v_classify_status			NVARCHAR(MAX);
	DECLARE @v_receipt_status			NVARCHAR(MAX);
	DECLARE @v_review_status			NVARCHAR(MAX);
	DECLARE @v_priority_status			NVARCHAR(MAX);
	DECLARE @v_dev_status				NVARCHAR(MAX);
	DECLARE @v_test_status				NVARCHAR(MAX);
	DECLARE @v_finish_status			NVARCHAR(MAX);
	DECLARE @v_request_user_id			NVARCHAR(MAX);
	DECLARE @v_scm_pi_uesr_id			NVARCHAR(MAX);
	DECLARE @v_scm_solution_uesr_id		NVARCHAR(MAX);
	DECLARE @v_csr_no					NVARCHAR(MAX);
	DECLARE @v_voc_step					NVARCHAR(MAX);




	/********************************************************************************
	* 시작 LOG
	********************************************************************************/
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = @p_voc_no;
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


	/********************************************************************************
	* VOC_DATA
	********************************************************************************/
					SELECT @v_voc_type				= A.VOC_TYPE	
					      ,@v_division_id			= dbo.FN_GET_LOOKUP_CODE_DESC('VOC_DIVISION', A.ATTRIBUTE1 )  	
 						  ,@v_voc_name				= A.VOC_NAME	
 						  ,@v_voc_detail			= A.VOC_DETAIL
 						  ,@v_request_date			= CONVERT(CHAR(19), REQUEST_DATE, 20)

			              ,@v_classify_status		= dbo.FN_GET_LOOKUP_CODE_DESC('VOC_STATUS', A.CLASSIFY_STATUS ) 
						  ,@v_receipt_status        = dbo.FN_GET_LOOKUP_CODE_DESC('VOC_STATUS', A.RECEIPT_STATUS  ) 
						  ,@v_review_status         = dbo.FN_GET_LOOKUP_CODE_DESC('VOC_STATUS', A.REVIEW_STATUS   ) 
						  ,@v_priority_status       = dbo.FN_GET_LOOKUP_CODE_DESC('VOC_STATUS', A.PRIORITY_STATUS ) 
						  ,@v_dev_status            = dbo.FN_GET_LOOKUP_CODE_DESC('VOC_STATUS', A.DEV_STATUS      ) 
						  ,@v_test_status           = dbo.FN_GET_LOOKUP_CODE_DESC('VOC_STATUS', A.TEST_STATUS     ) 
						  ,@v_finish_status         = dbo.FN_GET_LOOKUP_CODE_DESC('VOC_STATUS', A.FINISH_STATUS   ) 


 						  ,@v_request_user_id		= D.USER_NAME 	
 						  ,@v_scm_pi_uesr_id		= E.USER_NAME 
 						  ,@v_scm_solution_uesr_id	= F.USER_NAME 
 						  ,@v_csr_no				= CSR_NO	
 					  FROM dbo.SCM_ADM_SYS_VOC A WITH(NOLOCK) 	
 		   LEFT OUTER JOIN SCM_MST_SSO_USER_INFO D WITH(NOLOCK) ON A.REQUEST_USER_ID      = D.USER_ID	
 		   LEFT OUTER JOIN SCM_MST_SSO_USER_INFO E WITH(NOLOCK) ON A.SCM_PI_USER_ID       = E.USER_ID	
 		   LEFT OUTER JOIN SCM_MST_SSO_USER_INFO F WITH(NOLOCK) ON A.SCM_SOLUTION_USER_ID = F.USER_ID	
 					 WHERE VOC_NO = @p_voc_no	
	;


			SELECT @v_voc_step = CASE 
								 WHEN @p_voc_step = 'CREATE' THEN N'등록' 
			                     ELSE dbo.FN_GET_LOOKUP_CODE_DESC('VOC_STEP', @p_voc_step ) 
								 END 

	/********************************************************************************
	* Mail Cointent
	********************************************************************************/	
	SET @v_a_body_contents = ''
	SET @v_body_text = ''
	SET @v_head_cont = '';
	SET @v_head_cont = @v_head_cont+ '<tr>'
	--SET @v_head_cont = @v_head_cont+ '<th rowspan=2>' + 'NO' + '</th>'
	SET @v_head_cont = @v_head_cont+ '<th rowspan=2>' + N'과제 구분' + '</th>'
	SET @v_head_cont = @v_head_cont+ '<th rowspan=2>' + N'사업부' + '</th>'
	SET @v_head_cont = @v_head_cont+ '<th rowspan=2>' + N'과제명' + '</th>'
	SET @v_head_cont = @v_head_cont+ '<th rowspan=2>' + N'요청일' + '</th>'
	SET @v_head_cont = @v_head_cont+ '<th colspan=5>' + N'단계' + '</th>'
	SET @v_head_cont = @v_head_cont+ '<th colspan=3>' + 'PIC' + '</th>'
	SET @v_head_cont = @v_head_cont+ '<th rowspan=2>' + 'CSR NO' + '</th>'
	SET @v_head_cont = @v_head_cont+ '</tr>'

	SET @v_head_cont = @v_head_cont+ '<tr>'
	SET @v_head_cont = @v_head_cont+ '<th>' + N'구체화' + '</th>'
	--SET @v_head_cont = @v_head_cont+ '<th>' + N'과제 접수/협의' + '</th>'
	--SET @v_head_cont = @v_head_cont+ '<th>' + N'개발 검토' + '</th>'
	--SET @v_head_cont = @v_head_cont+ '<th>' + N'우선순위<br>완료예정일 검토' + '</th>'
	SET @v_head_cont = @v_head_cont+ '<th>' + N'개발 검토' + '</th>'
	SET @v_head_cont = @v_head_cont+ '<th>' + N'개발' + '</th>'
	SET @v_head_cont = @v_head_cont+ '<th>' + N'Test' + '</th>'
	SET @v_head_cont = @v_head_cont+ '<th>' + N'완료' + '</th>'
	SET @v_head_cont = @v_head_cont+ '<th>' + N'발의자' + '</th>'
	SET @v_head_cont = @v_head_cont+ '<th>' + 'SCM SOLUTION' + '</th>'
	SET @v_head_cont = @v_head_cont+ '<th>' + 'SCM PI' + '</th>'
	SET @v_head_cont = @v_head_cont+ '</tr>'



	--------------------------------------------------------------------------------
	SET @v_a_body_contents = @v_a_body_contents+ '<tr align=center>'
	--SET @v_a_body_contents = @v_a_body_contents+ '<td>' + REPLACE(ISNULL(@p_voc_no,'')					, CHAR(10),' ') + '</td>'
	SET @v_a_body_contents = @v_a_body_contents+ '<td>' + REPLACE(ISNULL(@v_voc_type,'')				, CHAR(10),' ') + '</td>'
	SET @v_a_body_contents = @v_a_body_contents+ '<td>' + REPLACE(ISNULL(@v_division_id,'')				, CHAR(10),' ') + '</td>'
	SET @v_a_body_contents = @v_a_body_contents+ '<td align=left>' + REPLACE(ISNULL(@v_voc_name,'')		, CHAR(10),' ') + '</td>'
	SET @v_a_body_contents = @v_a_body_contents+ '<td>' + REPLACE(ISNULL(@v_request_date,'')			, CHAR(10),' ') + '</td>'

	SET @v_a_body_contents = @v_a_body_contents+ '<td witdh=80>' + REPLACE(ISNULL(@v_classify_status,'')	, CHAR(10),' ') + '</td>'
	--SET @v_a_body_contents = @v_a_body_contents+ '<td witdh=80>' + REPLACE(ISNULL(@v_receipt_status,'')		, CHAR(10),' ') + '</td>'
	--SET @v_a_body_contents = @v_a_body_contents+ '<td witdh=80>' + REPLACE(ISNULL(@v_review_status,'')		, CHAR(10),' ') + '</td>'
	SET @v_a_body_contents = @v_a_body_contents+ '<td witdh=100>' + REPLACE(ISNULL(@v_priority_status,'')	, CHAR(10),' ') + '</td>'
	SET @v_a_body_contents = @v_a_body_contents+ '<td witdh=80>' + REPLACE(ISNULL(@v_dev_status,'')			, CHAR(10),' ') + '</td>'
	SET @v_a_body_contents = @v_a_body_contents+ '<td witdh=80>' + REPLACE(ISNULL(@v_test_status,'')		, CHAR(10),' ') + '</td>'
	SET @v_a_body_contents = @v_a_body_contents+ '<td witdh=80>' + REPLACE(ISNULL(@v_finish_status,'')		, CHAR(10),' ') + '</td>'

	SET @v_a_body_contents = @v_a_body_contents+ '<td>' + REPLACE(ISNULL(@v_request_user_id,'')			, CHAR(10),' ') + '</td>'
	SET @v_a_body_contents = @v_a_body_contents+ '<td>' + REPLACE(ISNULL(@v_scm_solution_uesr_id,'')	, CHAR(10),' ') + '</td>'
	SET @v_a_body_contents = @v_a_body_contents+ '<td>' + REPLACE(ISNULL(@v_scm_pi_uesr_id,'')			, CHAR(10),' ') + '</td>'
	SET @v_a_body_contents = @v_a_body_contents+ '<td>' + REPLACE(ISNULL(@v_csr_no,'')					, CHAR(10),' ') + '</td>'	
	SET @v_a_body_contents = @v_a_body_contents+ '</tr>'


	/********************************************************************************
	* @v_to_mail
	********************************************************************************/	
	SELECT @v_to_mail = dbo.FN_GET_LOOKUP_CODE_DESC('VOC_MAILING', 'RECIVER' ) 
		  ,@v_mail_title = dbo.FN_GET_LOOKUP_CODE_DESC('VOC_MAILING', 'MAIL_TITLE' ) 
		  ,@v_body_title = dbo.FN_GET_LOOKUP_CODE_DESC('VOC_MAILING', 'MAIL_BODY_TITLE' ) 

    

	---------------------------------------------------------------------------------------
	-- SCM_ADM_LOOKUP_MASTER_DETAIL > SEGMENT2 100글자 까지만 가능 -> 조치까지 직접 셋팅 => VOC_MAILING_RECIVER 사용
	---------------------------------------------------------------------------------------
	--select @v_to_mail = 'vadabi3@lgespartner.com;yongseokyoon@lgensol.com';
	SELECT @v_to_mail = STUFF((SELECT ';' + SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'VOC_MAILING_RECIVER' AND VALID_YN = 'Y' FOR XML PATH('')), 1, 1, '')



	---------------------------------------------------------------------------------------
		      -- 등록자도 메일링에 추가 한다
			  -- 사용자아이디로 메일주소 확보방법 없음 => @lgensol.com 붙여서 사용 => 예외여부 확인
		      SELECT @v_to_mail_create =  D.USER_ID + '@lgensol.com'
 		        FROM dbo.SCM_ADM_SYS_VOC A WITH(NOLOCK) 	
     LEFT OUTER JOIN SCM_MST_SSO_USER_INFO D WITH(NOLOCK) ON A.REQUEST_USER_ID      = D.USER_ID	
		       WHERE VOC_NO = @p_voc_no	
			   
	---------------------------------------------------------------------------------------
	-- 등록자 메일이 이미 RECIVER 에 포함되어 있는지 체크
     SELECT @v_to_mail_create_cnt = count(*)
		   FROM DBO.SCM_ADM_LOOKUP_MASTER_DETAIL C WITH(NOLOCK)
		  WHERE C.LOOKUP_TYPE   = 'VOC_MAILING_RECIVER'
		    AND C.VALID_YN = 'Y'
			AND SEGMENT2 = @v_to_mail_create
					
	---------------------------------------------------------------------------------------
	-- 20220503 개발서버에서는 발의자에 메일 발송 하지 않음
	IF @v_to_mail_create_cnt = 0 AND @v_server_real != 'DEV'
		BEGIN
		SET @v_to_mail = @v_to_mail + ';'+ @v_to_mail_create;
		END

	-- 20220506 개발서버에서는 Mail Title 에 개발 표시
	IF @v_server_real = 'DEV'
		BEGIN
		SET @v_mail_title = concat(@v_mail_title, N' - [개발서버]');
		END


		
	---------------------------------------------------------------------------------------  
		SET @v_log_type = 'RUN';
		SET @v_log_message = '########## @v_to_mail ##########';
		SET @v_description = concat(@v_to_mail , ', v_to_mail_create_cnt = ', @v_to_mail_create_cnt, ', v_server_real = ', @v_server_real) ;
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;





	/********************************************************************************
	* @@v_mail_title
	********************************************************************************/	
	SET @v_mail_title = replace(@v_mail_title, '@@p_voc_no'		, @v_voc_name);
	SET @v_mail_title = replace(@v_mail_title, '@@v_voc_step'	, @v_voc_step);
	SET @v_body_title = replace(@v_body_title, '@@p_voc_no'		, @v_voc_name);
	SET @v_body_title = replace(@v_body_title, '@@v_voc_step'	, @v_voc_step);





	/********************************************************************************
	* @@@v_body_title
	********************************************************************************/
	--SET @v_body_title = @v_body_text+ N'GSCM SCP VOC - No = ' + @p_voc_no + ', [' + @v_voc_step + N'] 단계 완료 되어 공지 메일 드립니다.'; 
	--SET @v_body_title = @v_body_text+ N'GSCM SCP VOC - No = ' + @p_voc_no + ', ' + @v_voc_step; 
	SET @TABLE_BODY		= ''
	SET @TABLE_BODY		= ' <html>
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
										'<b>' + REPLACE(ISNULL(@v_body_title, ''), CHAR(10), '<br>') + '</b>'+
										'<b>' + REPLACE(ISNULL(@v_body_text, '') , CHAR(10), '<br>') + '</b>' +
										'<table style=''border-top:2px solid #c8294b; width:1400px;''>
											<thead>' + ISNULL(@v_head_cont,'') +'</thead>
											<tbody>' + ISNULL(@v_a_body_contents, '') + '</tbody>
										</table>
								</body>
							</html>'



	BEGIN TRY
	/********************************************************************************
	* 메일 발송
	********************************************************************************/
	    --SET @v_to_mail		= 'vadabi3@lgespartner.com;yongseokyoon@lgensol.com';
	    --SET @v_to_mail		= 'vadabi3@lgespartner.com';
		--SET @v_mail_title		= N'GSCM SCP VOC 알림 - No = ' + @p_voc_no + ', [' + @v_voc_step + N'] 단계 완료'; 
		--SET @v_mail_title		= N'GSCM SCP VOC 알림 - No = ' + @p_voc_no; 
		SET @v_body_contents	= @TABLE_BODY
		SET @p_html_yn			= 'Y'

		EXEC SCM_ADM_MAIL_SEND
				 @v_to_mail
				,@v_mail_title
				,@v_body_contents
				,@p_html_yn
	
	/********************************************************************************
	* END LOG
	********************************************************************************/

		IF LEN(@v_body_contents) > 100
			BEGIN
				SET @v_body_contents = SUBSTRING(@v_body_contents,1,100);
			END

		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = @v_body_title;
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	END TRY


	BEGIN CATCH
		BEGIN
		/********************************************************************************
		* CATCH LOG
		********************************************************************************/
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

END

