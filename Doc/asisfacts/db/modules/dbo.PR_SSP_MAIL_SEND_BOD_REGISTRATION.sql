/*
 * Program ID   : PR_SSP_MAIL_SEND_BOD_REGISTRATION
 * Description  : MAIL 발송 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021-06-18	KIMYONGHO	   신규추가
 */
CREATE PROCEDURE [dbo].[PR_SSP_MAIL_SEND_BOD_REGISTRATION]

	-- Add the parameters for the stored procedure here
	@p_category_id				int

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON;

	DECLARE @v_result		NVARCHAR(MAX);
	DECLARE @v_result2		NVARCHAR(MAX);
	DECLARE @v_result3		NVARCHAR(MAX);
	DECLARE @v_result4		NVARCHAR(MAX);
	DECLARE @v_result5		NVARCHAR(MAX);
	DECLARE @v_to_mail		NVARCHAR(max);
	DECLARE @v_head_cont	NVARCHAR(max);
	DECLARE @v_body_cont	NVARCHAR(max);
	DECLARE @v_body_cont_temp	NVARCHAR(max);
	DECLARE @TABLE_BODY            NVARCHAR(MAX)
	DECLARE @MAIL_RECEIVER_LIST    NVARCHAR(4000)

	DECLARE @v_use_type_code        NVARCHAR(10);
	DECLARE @v_segment1             NVARCHAR(100);
	DECLARE @v_segment2             NVARCHAR(100);
	DECLARE @v_segment3             NVARCHAR(100);
	DECLARE @v_segment4             NVARCHAR(100);
	DECLARE @v_segment5             NVARCHAR(100);
	DECLARE @v_segment6             NVARCHAR(100);
	DECLARE @v_segment7             NVARCHAR(100);
	DECLARE @v_segment8             NVARCHAR(100);
	DECLARE @v_segment9             NVARCHAR(100);
	DECLARE @v_segment10            NVARCHAR(100);
	DECLARE @v_column1              NVARCHAR(100);
	DECLARE @v_column2              NVARCHAR(100);
	DECLARE @v_column3              NVARCHAR(100);
	DECLARE @v_column4              NVARCHAR(100);
	DECLARE @v_column5              NVARCHAR(100);
	DECLARE @v_column6              NVARCHAR(100);
	DECLARE @v_column7              NVARCHAR(100);
	DECLARE @v_column8              NVARCHAR(100);
	DECLARE @v_column9              NVARCHAR(100);
	DECLARE @v_column10             NVARCHAR(100);
	DECLARE @v_user_id              NVARCHAR(40);
	DECLARE @v_user_name            NVARCHAR(40);
	DECLARE @v_mobile_phone         NVARCHAR(50);
	DECLARE @v_language_code        NVARCHAR(50);
	DECLARE @v_email_addr           NVARCHAR(100);
	DECLARE @v_from_mail            NVARCHAR(100);
	DECLARE @v_from_phone           NVARCHAR(100);
	DECLARE @v_phone_addr           NVARCHAR(100);
	DECLARE @v_mail_title           NVARCHAR(100);
	DECLARE @v_user_cnt             INT;
	DECLARE @v_rank                 NVARCHAR(MAX);
	DECLARE @v_body_contents        NVARCHAR(MAX);
	DECLARE @v_message              NVARCHAR(MAX);
	DECLARE @v_detail_flag          NVARCHAR(1);
	DECLARE @v_sql_long_text        NVARCHAR(MAX);
	DECLARE @v_check				INT;
	DECLARE @v_sql_yn				NVARCHAR(1);
	DECLARE @v_receiver_temp	    NVARCHAR(150);

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SSP_MAIL_SEND_BOD_REGISTRATION';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	/********************************************************************************
	* 임시테이블만들기
	********************************************************************************/
	--IF EXISTS (SELECT * FROM tempdb.sys.sysobjects WHERE name like '#TblMailSendBatch%')
	--	   DROP TABLE #TblMailSendBatch
	IF OBJECT_ID('tempdb..#TblMailSendBatch') IS NOT NULL	
			DROP TABLE #TblMailSendBatch;
 
	CREATE TABLE #TblMailSendBatch (
			 use_type_code		NVARCHAR(10)
			,user_id			NVARCHAR(150) 
		   , user_name			NVARCHAR(300)
		   , email_addr			NVARCHAR(300)
		   , mobile_phone		NVARCHAR(60)
		   , language_code		NVARCHAR(200)
		   , segment1			NVARCHAR(100)
		   , segment2			NVARCHAR(100)
		   , segment3			NVARCHAR(100)
		   , segment4			NVARCHAR(100)
		   , segment5			NVARCHAR(100)
		   --, segment6			NVARCHAR(100)
		   --, segment7			NVARCHAR(100)
		   --, segment8			NVARCHAR(100)
		   --, segment9			NVARCHAR(100)
		   --, segment10			NVARCHAR(100)
		   , column1			NVARCHAR(100)
		   , column2			NVARCHAR(100)
		   , column3			NVARCHAR(100)
		   , column4			NVARCHAR(100)
		   , column5			NVARCHAR(100)
		   --, column6			NVARCHAR(100)
		   --, column7			NVARCHAR(100)
		   --, column8			NVARCHAR(100)
		   --, column9			NVARCHAR(100)
		   --, column10			NVARCHAR(100)
		   , mail_title			NVARCHAR(100)
		   , body_contents		NVARCHAR(max)
		   , sql_long_text   	NVARCHAR(max)
		   , user_cnt			int
		   , rank				NVARCHAR(max)
	);

	BEGIN			
		SELECT @v_result= result
				--,@v_result2 = result2
				--,@v_result3 = result3
				--,@v_result5 = result4
		FROM DBO.FN_SCM_ADM_GET_MAIL_SQL(@p_category_id);
	END
	

	--EXEC @v_result;

	SET @v_result4 = ''
	SET @v_result4 = @v_result4+'  SELECT DISTINCT z.* '+CHAR(10)
	SET @v_result4 = @v_result4+'     ,COUNT(user_id) over ( PARTITION BY  user_id ) user_cnt '+CHAR(10)
	SET @v_result4 = @v_result4+'      ,dense_rank() over( PARTITION BY  user_id ORDER BY user_id, segment1, segment2, segment3, segment4, segment5) rank '+CHAR(10)
	SET @v_result4 = @v_result4+'  FROM ( '+CHAR(10)
	SET @v_result4 = @v_result4+'  SELECT x.use_type_code '+CHAR(10)
	SET @v_result4 = @v_result4+'      , y.user_id '+CHAR(10)
	SET @v_result4 = @v_result4+'      , y.user_name '+CHAR(10)
	SET @v_result4 = @v_result4+'      , y.email_addr '+CHAR(10)
	SET @v_result4 = @v_result4+'      , y.mobile_phone '+CHAR(10)
	SET @v_result4 = @v_result4+'      ,x.language_code '+CHAR(10)
	SET @v_result4 = @v_result4+'      ,y.segment1 '+CHAR(10)
	SET @v_result4 = @v_result4+'      ,y.segment2 '+CHAR(10)
	SET @v_result4 = @v_result4+'      ,y.segment3 '+CHAR(10)
	SET @v_result4 = @v_result4+'      ,y.segment4 '+CHAR(10)
	SET @v_result4 = @v_result4+'      ,y.segment5 '+CHAR(10)
	SET @v_result4 = @v_result4+'      ,y.column1 '+CHAR(10)
	SET @v_result4 = @v_result4+'      ,y.column2 '+CHAR(10)
	SET @v_result4 = @v_result4+'      ,y.column3 '+CHAR(10)
	SET @v_result4 = @v_result4+'      ,y.column4 '+CHAR(10)
	SET @v_result4 = @v_result4+'      ,y.column5 '+CHAR(10)
	SET @v_result4 = @v_result4+'      ,x.mail_title '+CHAR(10)
	SET @v_result4 = @v_result4+'      ,x.body_contents '+CHAR(10)
	SET @v_result4 = @v_result4+'      ,x.sql_long_text '+CHAR(10)
	SET @v_result4 = @v_result4+'  FROM ('+@v_result+') y, '+CHAR(10)
	SET @v_result4 = @v_result4+'      ( SELECT a.use_type_code '+CHAR(10)
	SET @v_result4 = @v_result4+'              ,c.user_id '+CHAR(10)
	SET @v_result4 = @v_result4+'              ,e.UserName as user_name '+CHAR(10)
	SET @v_result4 = @v_result4+'              ,e.Email as email_addr '+CHAR(10)
	SET @v_result4 = @v_result4+'              ,e.CellPhoneNum as mobile_phone '+CHAR(10)
	SET @v_result4 = @v_result4+'              ,b.language_code '+CHAR(10)
	SET @v_result4 = @v_result4+'              ,b.mail_title '+CHAR(10)
	SET @v_result4 = @v_result4+'              ,d.SEGMENT3       header_contents '+CHAR(10)
	SET @v_result4 = @v_result4+'  			,CASE A.USE_TYPE_CODE WHEN ''MAIL'' THEN replace(b.message_content,char(10),''<br><br>'') '+CHAR(10)
	SET @v_result4 = @v_result4+'  			                      WHEN ''SMS'' THEN b.message_content END body_contents '+CHAR(10)
	SET @v_result4 = @v_result4+'              ,d.SEGMENT3      foot_contents '+CHAR(10)
	SET @v_result4 = @v_result4+'              ,a.SQL_LONG_TEXT '+CHAR(10)
	SET @v_result4 = @v_result4+'          FROM SCM_ADM_RECIPIENT_LIST a WITH(NOLOCK) '+CHAR(10)
	SET @v_result4 = @v_result4+'              INNER JOIN SCM_ADM_RECIPIENT_MESSAGE b WITH(NOLOCK) ON a.CATEGORY_ID = B.CATEGORY_ID '+CHAR(10)
	SET @v_result4 = @v_result4+'              LEFT OUTER JOIN SCM_ADM_RECIPIENT_ASSIGN c WITH(NOLOCK) ON B.CATEGORY_ID = C.CATEGORY_ID  '+CHAR(10)
	SET @v_result4 = @v_result4+'              INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL d WITH(NOLOCK) ON D.SEGMENT1 = B.LANGUAGE_CODE AND D.LOOKUP_TYPE = ''MAIL_HEADER_FOOT'' AND D.VALID_YN = ''Y''  '+CHAR(10)
	SET @v_result4 = @v_result4+'              LEFT OUTER JOIN TB_FX_User e WITH(NOLOCK) ON B.LANGUAGE_CODE = E.Language AND C.USER_ID = E.UserID '+CHAR(10)
	SET @v_result4 = @v_result4+'          WHERE a.category_id   = ' +convert(nvarchar,@p_category_id)+CHAR(10)
	SET @v_result4 = @v_result4+'              AND a.VALID_YN = ''Y'' '+CHAR(10)
	SET @v_result4 = @v_result4+'          ) x '+CHAR(10)
	SET @v_result4 = @v_result4+'      WHERE x.language_code = y.language_code   '+CHAR(10)

	SET @v_result4 = @v_result4+'     union all   '+CHAR(10)

	SET @v_result4 = @v_result4+'  SELECT x.use_type_code '+CHAR(10)
	SET @v_result4 = @v_result4+'      , x.user_id '+CHAR(10)
	SET @v_result4 = @v_result4+'      , x.user_name '+CHAR(10)
	SET @v_result4 = @v_result4+'      , x.email_addr '+CHAR(10)
	SET @v_result4 = @v_result4+'      , x.mobile_phone '+CHAR(10)
	SET @v_result4 = @v_result4+'      ,x.language_code '+CHAR(10)
	SET @v_result4 = @v_result4+'      ,y.segment1 '+CHAR(10)
	SET @v_result4 = @v_result4+'      ,y.segment2 '+CHAR(10)
	SET @v_result4 = @v_result4+'      ,y.segment3 '+CHAR(10)
	SET @v_result4 = @v_result4+'      ,y.segment4 '+CHAR(10)
	SET @v_result4 = @v_result4+'      ,y.segment5 '+CHAR(10)
	SET @v_result4 = @v_result4+'      ,y.column1 '+CHAR(10)
	SET @v_result4 = @v_result4+'      ,y.column2 '+CHAR(10)
	SET @v_result4 = @v_result4+'      ,y.column3 '+CHAR(10)
	SET @v_result4 = @v_result4+'      ,y.column4 '+CHAR(10)
	SET @v_result4 = @v_result4+'      ,y.column5 '+CHAR(10)
	SET @v_result4 = @v_result4+'      ,x.mail_title '+CHAR(10)
	SET @v_result4 = @v_result4+'      ,x.body_contents '+CHAR(10)
	SET @v_result4 = @v_result4+'      ,x.sql_long_text '+CHAR(10)
	SET @v_result4 = @v_result4+'  FROM ('+@v_result+') y, '+CHAR(10)
	SET @v_result4 = @v_result4+'      ( SELECT a.use_type_code '+CHAR(10)
	SET @v_result4 = @v_result4+'              ,c.user_id '+CHAR(10)
	SET @v_result4 = @v_result4+'              ,e.UserName as user_name '+CHAR(10)
	SET @v_result4 = @v_result4+'              ,e.Email as email_addr '+CHAR(10)
	SET @v_result4 = @v_result4+'              ,e.CellPhoneNum as mobile_phone '+CHAR(10)
	SET @v_result4 = @v_result4+'              ,b.language_code '+CHAR(10)
	SET @v_result4 = @v_result4+'              ,b.mail_title '+CHAR(10)
	SET @v_result4 = @v_result4+'              ,d.SEGMENT3       header_contents '+CHAR(10)
	SET @v_result4 = @v_result4+'  			,CASE A.USE_TYPE_CODE WHEN ''MAIL'' THEN replace(b.message_content,char(10),''<br><br>'') '+CHAR(10)
	SET @v_result4 = @v_result4+'  			                      WHEN ''SMS'' THEN b.message_content END body_contents '+CHAR(10)
	SET @v_result4 = @v_result4+'              ,d.SEGMENT3      foot_contents '+CHAR(10)
	SET @v_result4 = @v_result4+'              ,a.SQL_LONG_TEXT '+CHAR(10)
	SET @v_result4 = @v_result4+'          FROM SCM_ADM_RECIPIENT_LIST a WITH(NOLOCK) '+CHAR(10)
	SET @v_result4 = @v_result4+'              INNER JOIN SCM_ADM_RECIPIENT_MESSAGE b WITH(NOLOCK) ON a.CATEGORY_ID = B.CATEGORY_ID '+CHAR(10)
	SET @v_result4 = @v_result4+'              LEFT OUTER JOIN SCM_ADM_RECIPIENT_ASSIGN c WITH(NOLOCK) ON B.CATEGORY_ID = C.CATEGORY_ID  '+CHAR(10)
	SET @v_result4 = @v_result4+'              INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL d WITH(NOLOCK) ON D.SEGMENT1 = B.LANGUAGE_CODE AND D.LOOKUP_TYPE = ''MAIL_HEADER_FOOT'' AND D.VALID_YN = ''Y''  '+CHAR(10)
	SET @v_result4 = @v_result4+'              LEFT OUTER JOIN TB_FX_User e WITH(NOLOCK) ON B.LANGUAGE_CODE = E.Language AND C.USER_ID = E.UserID '+CHAR(10)
	SET @v_result4 = @v_result4+'          WHERE a.category_id   = ' +convert(nvarchar,@p_category_id)+CHAR(10)
	SET @v_result4 = @v_result4+'              AND a.VALID_YN = ''Y'' '+CHAR(10)
	SET @v_result4 = @v_result4+'          ) x '+CHAR(10)
	SET @v_result4 = @v_result4+'      WHERE x.language_code = y.language_code   '+CHAR(10)


	SET @v_result4 = @v_result4+'      ) z order by user_id '+CHAR(10)


	

	
	BEGIN				
		DECLARE @POS INT =1;
		DECLARE @LEN INT =LEN(@v_result4);
		WHILE @POS <= @LEN
			BEGIN
				PRINT SUBSTRING(@v_result4,@POS,4000);
				SET @POS = @POS+4000;
			END;
	END;

	INSERT INTO #TblMailSendBatch
	exec (@v_result4)


	--SELECT * FROM #TblMailSendBatch;
	--return;
	
	DECLARE CUR_SEND CURSOR FOR
	SELECT * FROM #TblMailSendBatch
	ORDER BY user_id

	BEGIN TRY
			-- 시작 LOG
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		
		SET @v_check = 0
		SET @v_body_cont = ''
		SET @v_body_cont_temp = ''
		SET @v_receiver_temp = ''

		OPEN CUR_SEND;
		FETCH NEXT FROM CUR_SEND INTO @v_use_type_code, @v_user_id, @v_user_name, @v_email_addr, @v_mobile_phone, @v_language_code
			                , @v_segment1, @v_segment2, @v_segment3, @v_segment4, @v_segment5
							--, @v_segment6, @v_segment7, @v_segment8, @v_segment9, @v_segment10,
							, @v_column1, @v_column2, @v_column3, @v_column4, @v_column5
							--, @v_column6, @v_column7, @v_column8, @v_column9, @v_column10
							, @v_mail_title
							, @v_body_contents, @v_sql_long_text, @v_user_cnt, @v_rank;

		WHILE @@FETCH_STATUS = 0
			BEGIN
				IF @v_use_type_code = 'MAIL'
					BEGIN
						SET @v_to_mail = @v_user_id+'@lgensol.com'

						--SET @v_to_mail = 'crjung@lgespartner.com'
						
						IF ISNULL(@v_sql_long_text,'') != ''
							BEGIN	
								
								SET @v_receiver_temp = @v_to_mail	
								--SET @v_receiver_temp ='kimyh8848@lgespartner.com'

									
								SET @v_sql_yn = 'Y'
								IF @v_check = 0
									BEGIN
										SET @v_head_cont = ''
										SET @v_head_cont = @v_head_cont+ '<tr>'

										IF ISNULL(@v_column1, '') != ''
											BEGIN
												SET @v_head_cont = @v_head_cont+ '<th>' + @v_column1 + '</th>'
											END
										IF ISNULL(@v_column2, '') != ''
											BEGIN
												SET @v_head_cont = @v_head_cont+ '<th>' + @v_column2 + '</th>'
											END
										IF ISNULL(@v_column3, '') != ''
											BEGIN
												SET @v_head_cont = @v_head_cont+ '<th>' + @v_column3 + '</th>'
											END
										IF ISNULL(@v_column4, '') != ''
											BEGIN
												SET @v_head_cont = @v_head_cont+ '<th>' + @v_column4 + '</th>'
											END
										IF ISNULL(@v_column5, '') != ''
											BEGIN
												SET @v_head_cont = @v_head_cont+ '<th>' + @v_column5 + '</th>'
											END

										SET @v_head_cont = @v_head_cont+ '</tr>'
										SET @v_check = @v_check + 1
									END
								
								SET @v_body_cont = @v_body_cont+ '<tr>'

								IF ISNULL(@v_column1, '') != ''
									BEGIN
										SET @v_body_cont = @v_body_cont+ '<td align=''Center''>' + REPLACE(ISNULL(@v_segment1,''), CHAR(10),' ') + '</td>'
									END
								IF ISNULL(@v_column2, '') != ''
									BEGIN
										SET @v_body_cont = @v_body_cont+ '<td align=''Center''>' + REPLACE(ISNULL(@v_segment2,''), CHAR(10),' ') + '</td>'
									END
								IF ISNULL(@v_column3, '') != ''
									BEGIN
										SET @v_body_cont = @v_body_cont+ '<td align=''Center''>' + REPLACE(ISNULL(@v_segment3,''), CHAR(10),' ') + '</td>'
									END
								IF ISNULL(@v_column4, '') != ''
									BEGIN
										SET @v_body_cont = @v_body_cont+ '<td align=''Center''>' + REPLACE(ISNULL(@v_segment4,''), CHAR(10),' ') + '</td>'
									END
								IF ISNULL(@v_column5, '') != ''
									BEGIN
										SET @v_body_cont = @v_body_cont+ '<td align=''Center''>' + REPLACE(ISNULL(@v_segment5,''), CHAR(10),' ') + '</td>'
									END

								SET @v_body_cont = @v_body_cont+ '</tr>'




								IF ISNULL(@v_column1, '') != ''
									BEGIN
										SET @v_body_cont_temp = @v_body_cont_temp+ '<td align=''Center''>' + REPLACE(ISNULL(@v_segment1,''), CHAR(10),' ') + '</td>'
									END
								IF ISNULL(@v_column2, '') != ''
									BEGIN
										SET @v_body_cont_temp = @v_body_cont_temp+ '<td align=''Center''>' + REPLACE(ISNULL(@v_segment2,''), CHAR(10),' ') + '</td>'
									END
								IF ISNULL(@v_column3, '') != ''
									BEGIN
										SET @v_body_cont_temp = @v_body_cont_temp+ '<td align=''Center''>' + REPLACE(ISNULL(@v_segment3,''), CHAR(10),' ') + '</td>'
									END
								IF ISNULL(@v_column4, '') != ''
									BEGIN
										SET @v_body_cont_temp = @v_body_cont_temp+ '<td align=''Center''>' + REPLACE(ISNULL(@v_segment4,''), CHAR(10),' ') + '</td>'
									END
								IF ISNULL(@v_column5, '') != ''
									BEGIN
										SET @v_body_cont_temp = @v_body_cont_temp+ '<td align=''Center''>' + REPLACE(ISNULL(@v_segment5,''), CHAR(10),' ') + '</td>'
									END

								SET @v_body_cont_temp = @v_body_cont_temp+ '<tr>'
								
							END
						END 

						BEGIN								
							IF LEN(@v_head_cont) > 0
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
																			'<b>' + REPLACE(ISNULL(@v_body_contents, ''), CHAR(10), '<br>') + '</b>' +
																			'<div id="divBody" style="width: 100%; overflow-x: auto; overflow-y: auto; font-size: 9pt; line-break: auto;">'    +   
																		'<table style=''border-top:2px solid #c8294b; width:1450px;''>
																		<thead>' + ISNULL(@v_head_cont,'') +'</thead>
																		<tbody>' + ISNULL(@v_body_cont, '') + '</tbody>
																		</div>
																	</body>
															</html>';

									SET @v_body_contents = ''
									SET @v_check = 0
									SET @v_body_cont = ''

								END
						END

						-- 메일 발송
						EXEC SCM_ADM_MAIL_SEND
								'jooyong026@lgespartner.com'--개발용
								--@v_receiver_temp
								,@v_mail_title
								,@TABLE_BODY
								,'Y'
								;
											

						--MAIL 발송 LOG 저장
						EXEC SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG @v_use_type_code
										,@p_category_id
										,@v_segment1
										,@v_segment2
										,@v_segment3
										,@v_segment4
										,@v_segment5
										,@v_segment6
										,@v_segment7
										,@v_segment8
										,@v_segment9
										,@v_segment10
										,'' --p_send_pgm
										,@v_receiver_temp;

				FETCH NEXT FROM CUR_SEND INTO @v_use_type_code, @v_user_id, @v_user_name, @v_email_addr, @v_mobile_phone, @v_language_code
								, @v_segment1, @v_segment2, @v_segment3, @v_segment4, @v_segment5
								--, @v_segment6, @v_segment7, @v_segment8, @v_segment9, @v_segment10
								, @v_column1, @v_column2, @v_column3, @v_column4, @v_column5
								--, @v_column6, @v_column7, @v_column8, @v_column9, @v_column10
								, @v_mail_title
								, @v_body_contents, @v_sql_long_text, @v_user_cnt, @v_rank
				
			END
		CLOSE CUR_SEND;
		DEALLOCATE CUR_SEND;

		--BEGIN
		--	IF LEN(@v_head_cont) > 0
		--		BEGIN
		--			SET @TABLE_BODY = ''
		--			SET @TABLE_BODY = ' <html>
		--						<head>
		--								<title>Untitled Document</title>
		--								<style>
		--									* {margin:0;padding:0;}
		--									body {font-family:Malgun Gothic, Arial, Helvetica, sans-serif;font-size:12px;line-height:1.8;color:#333333;}
		--									table {border-collapse:collapse;width:100%;}
		--									table th {background:#f5f5f5;border-bottom:1px solid #e1e1e1;}
		--									table td {background:#fff;border-right:1px solid #e1e1e1;border-left:1px solid #e1e1e1;border-bottom:1px solid #e1e1e1;}
		--									table tbody th {border-left:1px solid #e1e1e1;text-align:right;padding:6px 8px;font-size:12px}
		--									table tbody td {padding:6px 8px;font-size:12px}
		--									table thead th {text-align:center;padding:3px;border-right:1px solid #e1e1e1;border-left:1px solid #e1e1e1; border-bottom:1px solid #d1d1d1;font-size:12px}
		--									.hori-table table thead td {text-align:center;padding:3px;}  
		--									.hori-table table tbody td {text-align:center;padding:3px;}
		--									.vertical-table, .hori-table {margin-bottom:20px;}
		--								</style>
		--								</head>
		--								<body>' +'</br>'+
		--										'<b>' + REPLACE(ISNULL(@v_body_contents, ''), CHAR(10), '<br>') + '</b>' +
		--										'<div id="divBody" style="width: 100%; overflow-x: auto; overflow-y: auto; font-size: 9pt; line-break: auto;">'    +   
		--									'<table style=''border-top:2px solid #c8294b; width:1450px;''>
		--									<thead>' + ISNULL(@v_head_cont,'') +'</thead>
		--									<tbody>' + ISNULL(@v_body_cont_temp, '') + '</tbody>
		--									</div>
		--								</body>
		--						</html>';
					
		--			-- 메일 발송
		--			EXEC SCM_ADM_MAIL_SEND
		--						--@v_to_mail
		--				    'kimyh8848@lgespartner.com'
		--					,@v_mail_title
		--					,@TABLE_BODY
		--					,'Y'
		--					;
		--			SET @v_body_contents = ''
		--			SET @v_check = 0
		--			SET @v_body_cont_temp = ''

		--			--MAIL 발송 LOG 저장
		--			EXEC SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG @v_use_type_code
		--							,@p_category_id
		--							,@v_segment1
		--							,@v_segment2
		--							,@v_segment3
		--							,@v_segment4
		--							,@v_segment5
		--							,@v_segment6
		--							,@v_segment7
		--							,@v_segment8
		--							,@v_segment9
		--							,@v_segment10
		--							,'' --p_send_pgm
		--							,'kimyh8848@lgespartner.com' --@v_to_mail;
		--		END
		--END

		--IF EXISTS (SELECT * FROM tempdb.sys.sysobjects WHERE name like '#TblMailSendBatch%')
		--   DROP TABLE #TblMailSendBatch
		IF OBJECT_ID('tempdb..#TblMailSendBatch') IS NOT NULL	
			DROP TABLE #TblMailSendBatch;

		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	END TRY

	BEGIN CATCH
		CLOSE CUR_SEND;
		DEALLOCATE CUR_SEND;
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

		BEGIN
			DECLARE @v_error_message NVARCHAR(1000);
			SET @v_error_message = SUBSTRING(ERROR_MESSAGE(),1,1000);

			--MAIL 발송 LOG 저장
				EXEC SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG 'ERROR'
				              ,@p_category_id
							  ,'MAIN ERROR' 
							  ,''
							  ,''
							  ,''
							  ,''
							  ,''
							  ,''
							  ,''
							  ,''
							  ,''
							  ,@v_error_message --p_send_pgm
							  ,'';
		IF @@TRANCOUNT > 0
			COMMIT WORK;
		END
		-- error코드, errror 메시지 반환
		SELECT 'F' AS result_code;
		SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
	END CATCH;
END






