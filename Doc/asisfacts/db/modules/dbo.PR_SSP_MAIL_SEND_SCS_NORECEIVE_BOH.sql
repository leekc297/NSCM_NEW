


/*
 * Program ID   : PR_SSP_MAIL_SEND_SCS_NORECEIVE_BOH
 * Description  : PR_SSP_MAIL_SEND_SCS_NORECEIVE_BOH
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/12/02   SHINMYUNGSU	   최초 작성  PR_SSP_MAIL_SEND_SCS_NOTRECEIVE_BOH
 */
CREATE PROCEDURE [dbo].[PR_SSP_MAIL_SEND_SCS_NORECEIVE_BOH] 
--	@p_language					NVARCHAR(MAX)

AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @p_language		NVARCHAR(MAX) = 'KO';
	-- LOG 용 변수 설정	
	DECLARE @v_program_name		NVARCHAR(150) = 'PR_SSP_MAIL_SEND_SCS_NORECEIVE_BOH';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

   /********************************************************************************
	* 임시테이블만들기
	********************************************************************************/
	DECLARE @v_cutoff_date		NVARCHAR(MAX)='';
	DECLARE @v_division_id		NVARCHAR(MAX) = '40';
	DECLARE @v_operation_group  NVARCHAR(MAX) = 'P';
	DECLARE @v_dis_cutoff_date  NVARCHAR(MAX);
	DECLARE @v_dead_line        NVARCHAR(MAX);

	-- 메일관련 변수들
	DECLARE @v_send_cnt    		    INT;				-- 메일보내는 루프 카운드
	DECLARE @v_send_tmpcnt    	    INT;				-- 메일보내는 루프 카운드 tmp
	DECLARE @v_head_cont		NVARCHAR(max);
	DECLARE @v_body_cont		NVARCHAR(max);
	DECLARE @v_mail_title       NVARCHAR(100);
	DECLARE @v_body_contents    NVARCHAR(MAX);

	DECLARE @v_packer		    NVARCHAR(100);
	DECLARE @v_packer_code		NVARCHAR(100);
	DECLARE @v_model_pic		NVARCHAR(MAX);
	DECLARE @v_mail_receiver	NVARCHAR(100);
	DECLARE @v_to_mail			NVARCHAR(max);
	DECLARE @TABLE_BODY			NVARCHAR(MAX);

	SET @v_cutoff_date   = CONVERT(VARCHAR, DATEADD(D, -1, GETDATE()) ,112) ; 
	SET @v_dis_cutoff_date = CONVERT(NVARCHAR, ( DBO.FN_CHAR_TO_DATE(@v_cutoff_date) ), 23 ); 
	SET @v_dead_line = CONVERT(NVARCHAR, ( DBO.FN_CHAR_TO_DATE(CONVERT(VARCHAR, GETDATE() ,112)) ), 23 ) + ' 16:00 KR Time';

	IF OBJECT_ID('TEMPDB..#TMP_RESULT_TABLE_1') IS NOT NULL	
		DROP TABLE #TMP_RESULT_TABLE_1;

	IF OBJECT_ID('TEMPDB..#TMP_RESULT_TABLE_2') IS NOT NULL	
		DROP TABLE #TMP_RESULT_TABLE_2;

	IF OBJECT_ID('TEMPDB..##TMP_MAILSEND_TABLE_P') IS NOT NULL	
		DROP TABLE #TMP_MAILSEND_TABLE_P;

	IF OBJECT_ID('TEMPDB..##TMP_MAILSEND_TABLE') IS NOT NULL	
		DROP TABLE #TMP_MAILSEND_TABLE;

	-- 원본 데이터 저장
	CREATE TABLE #TMP_RESULT_TABLE_1
	(
		  PACKER			NVARCHAR(100)
		, PACKER_CODE		NVARCHAR(30)
		, MODEL_PIC			NVARCHAR(100)
		, USER_ID		    NVARCHAR(30)
	);

	CREATE TABLE #TMP_RESULT_TABLE_2
	(
		  PACKER			NVARCHAR(100)
		, PACKER_CODE		NVARCHAR(30)
		, MODEL_PIC			NVARCHAR(MAX)
		, MAIL_RECEIVER	    NVARCHAR(30)
	);
	CREATE TABLE #TMP_MAILSEND_TABLE_P
	(
		  PACKER			NVARCHAR(50)
		, PACKER_CODE		NVARCHAR(30)
		, MODEL_PIC			NVARCHAR(MAX)
		, MAIL_RECEIVER	    NVARCHAR(30)
	);
	CREATE TABLE #TMP_MAILSEND_TABLE
	(
		  RECEIVER_NUM		INT
		, PACKER			NVARCHAR(50)
		, PACKER_CODE		NVARCHAR(30)
		, MODEL_PIC			NVARCHAR(MAX)
		, MAIL_RECEIVER	    NVARCHAR(30)
	);
	BEGIN TRY	

	--//시작 LOG
			SET @v_log_type = 'START';
			SET @v_log_message = '########## Start of procedure ##########';
			SET @v_description = '';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			--//LOG END

		-- 원본 데이터를 만든다...
		INSERT INTO #TMP_RESULT_TABLE_1
		(
		  PACKER			
		, PACKER_CODE		
		, MODEL_PIC			
		, USER_ID		    
		)

		SELECT 
			XXX.SITE_DESCRIPTION
	       , XXX.FROM_SITE 
		   , XXX.PIC
		   , XXX.USER_ID 
		FROM
		(
			SELECT   ISNULL(dbo.fn_get_scm_site_description('40', MODEL_PIC.FROM_SITE ), MODEL_PIC.FROM_SITE) AS SITE_DESCRIPTION
				   , MODEL_PIC.FROM_SITE 
				   , MODEL_PIC.MODEL
				   , MODEL_PIC.PIC
				   , MODEL_PIC.USER_ID 
				   , ISNULL(SCS_STOCK.QTY, 0) AS QTY
			FROM
			(
				SELECT FROM_SITE
					  ,ITEM_ID AS MODEL
					  ,case when @p_language = 'KO' then u.UserName + '(' + a.USER_ID + ')' else u.UserName_E + '(' + a.USER_ID + ')' end AS PIC
					  ,a.USER_ID
				 FROM(
						SELECT SI.SCM_SITE_ID FROM_SITE 
							  ,SI.ITEM_ID 
							  ,MU.USER_ID
							  --,MU.VALID_YN			
						FROM SCM_MST_SITE_ITEM SI WITH(NOLOCK) 			
							JOIN SCM_MST_SITE  FS WITH(NOLOCK) ON FS.DIVISION_ID = @v_division_id AND FS.OPERATION_GROUP = @v_operation_group
															  AND FS.DIVISION_ID = SI.DIVISION_ID AND  FS.SCM_SITE_ID = SI.SCM_SITE_ID AND  FS.SITE_TYPE  = 'PLANT' AND FS.VALID_YN = 'Y'				
							LEFT OUTER JOIN SSP_MST_MODEL_USER MU WITH(NOLOCK) ON MU.DIVISION_ID = SI.DIVISION_ID AND MU.FROM_SITE = SI.SCM_SITE_ID AND MU.ITEM_ID = SI.ITEM_iD 	
						WHERE 1=1 		
						GROUP BY FS.OPERATION_GROUP, SI.SCM_SITE_ID, SI.ITEM_ID, MU.USER_ID								
						--GROUP BY SI.DIVISION_ID, FS.OPERATION_GROUP, SI.SCM_SITE_ID, SI.ITEM_ID, MU.USER_ID, MU.PART_LEADER, MU.TEAM_LEADER, MU.VALID_YN			
				 ) a
				LEFT OUTER JOIN TB_FX_User u on u.UserID = a.USER_ID
				--WHERE a.VALID_YN = 'Y'
			) MODEL_PIC
			LEFT OUTER JOIN
			(
				SELECT PACKER_CODE, SUM(STOCK_QTY) AS QTY
				  FROM SCM_DNM_SCS_STOCK (nolock) 
				 WHERE 1 = 1
				   AND CUTOFF_DATE = @v_cutoff_date
				   AND DIVISION_ID = @v_division_id
				   AND CELL_PACK = @v_operation_group
				 GROUP BY PACKER_CODE
			) SCS_STOCK
			   ON MODEL_PIC.FROM_SITE = SCS_STOCK.PACKER_CODE
		) XXX
		WHERE 1 = 1
		  AND XXX.QTY <= 0
		  AND XXX.PIC IS NOT NULL
		GROUP BY XXX.SITE_DESCRIPTION, XXX.FROM_SITE, XXX.PIC, XXX.USER_ID;

		-- 세로데이터를 가로로 만든다(MODEL_PIC)
		INSERT INTO #TMP_RESULT_TABLE_2
		(
			PACKER
		  , PACKER_CODE
		  , MAIL_RECEIVER
		  , MODEL_PIC
		)
		SELECT * FROM
		(
			SELECT PACKER, PACKER_CODE, USER_ID AS MAIL_RECEIVER, STUFF((SELECT ',' + MODEL_PIC FROM #TMP_RESULT_TABLE_1 WHERE PACKER = A.PACKER AND PACKER_CODE = A.PACKER_CODE
										FOR XML PATH('')), 1, 1, '') AS 'MODEL_PIC' FROM #TMP_RESULT_TABLE_1 AS A 
		) A GROUP BY A.PACKER, A.PACKER_CODE, A.MAIL_RECEIVER, MODEL_PIC;


		-- LOOK UP 테이블을 조인하여 최종 메일보낼 데이터를 만든다.
		INSERT INTO #TMP_MAILSEND_TABLE_P
		(
		    PACKER			
		  , PACKER_CODE		
  		  , MODEL_PIC			
		  , MAIL_RECEIVER	    
		)
		SELECT PACKER, PACKER_CODE, MODEL_PIC, MAIL_RECEIVER FROM
		(
			SELECT PACKER, PACKER_CODE, MODEL_PIC, MAIL_RECEIVER FROM #TMP_RESULT_TABLE_2

			UNION ALL

			SELECT A.PACKER, A.PACKER_CODE, A.MODEL_PIC, M.SEGMENT2 AS MAIL_RECEIVER FROM SCM_ADM_LOOKUP_MASTER_DETAIL M WITH(NOLOCK) , #TMP_RESULT_TABLE_2 A
			WHERE  M.LOOKUP_TYPE ='WARNING_MAIL_SEND_SCSBOH_40'
				AND  M.VALID_YN    ='Y'
				AND  M.SEGMENT1    ='SSP'
             GROUP BY A.PACKER, A.PACKER_CODE, A.MODEL_PIC, M.SEGMENT2
		) A
		WHERE 1 = 1
		;

		-- #TMP_MAILSEND_TABLE_P 에서 메일을 보내기 위해 DENSE_RANK()를 만든다.  MAIL_RECEIVER 별로 
		INSERT INTO #TMP_MAILSEND_TABLE
		(
			RECEIVER_NUM
		  , PACKER			
		  , PACKER_CODE		
  		  , MODEL_PIC			
		  , MAIL_RECEIVER	    
		)
		SELECT DENSE_RANK() OVER (ORDER BY MAIL_RECEIVER) AS RECEIVER_NUM, PACKER, PACKER_CODE, MODEL_PIC, MAIL_RECEIVER
		 FROM #TMP_MAILSEND_TABLE_P ORDER BY MAIL_RECEIVER, PACKER, MODEL_PIC;
		
		--SELECT * FROM #TMP_RESULT_TABLE_1;
		--SELECT * FROM #TMP_MAILSEND_TABLE ORDER BY RECEIVER_NUM;

		-- 루프를 돌면서 메일을 보내면 된다.
		SET @v_send_tmpcnt = 0;

		SELECT 
			@v_send_cnt = MAX(RECEIVER_NUM)
		FROM #TMP_MAILSEND_TABLE
		WHERE 1 = 1 ;		

		WHILE @v_send_tmpcnt < @v_send_cnt
		BEGIN
			/********************************************************************************
			* HEAD CONT 
			********************************************************************************/
			SET @v_head_cont = '';
			SET @v_head_cont = @v_head_cont+ '<tr>'

			SET @v_head_cont = @v_head_cont+ '<th>' + 'Cut off date' + '</th>'
			SET @v_head_cont = @v_head_cont+ '<th>' + 'Packer' + '</th>'
			SET @v_head_cont = @v_head_cont+ '<th>' + 'Packer code' + '</th>'
			SET @v_head_cont = @v_head_cont+ '<th>' + 'Model PIC' + '</th>'
			SET @v_head_cont = @v_head_cont+ '<th>' + 'Dead line' + '</th>'

			SET @v_head_cont = @v_head_cont+ '</tr>'

			SET @v_mail_title = '[SSP_Stock_Warning] Yesterday BOH has not been received.';
			SET @v_body_contents = 'The BOH(Beginning On Hand) of the previous day has not been received until now. Encourage Packer to upload daily inventory. If stock is not received, it is not possible to change SSP shipping plan.
								';
			SET @v_body_cont = '';

			SET @v_send_tmpcnt = @v_send_tmpcnt + 1;

			SELECT 
				@v_mail_receiver = MAX(MAIL_RECEIVER)
			FROM #TMP_MAILSEND_TABLE
			WHERE 1 = 1
			  AND RECEIVER_NUM = @v_send_tmpcnt		 -- @v_send_tmpcnt 메일받는사람수
			; 
			
			SET @v_to_mail = @v_mail_receiver+'@lgensol.com';  
			--SET @v_to_mail = 'corewhite11@lgespartner.com';  -- 테스트용
			--================================================================

			DECLARE CUR_SEND CURSOR FOR
			SELECT
				PACKER
			  , PACKER_CODE
			  , MODEL_PIC
			  , MAIL_RECEIVER
			FROM #TMP_MAILSEND_TABLE
			WHERE 1 = 1
			  AND RECEIVER_NUM = @v_send_tmpcnt
			ORDER BY PACKER, PACKER_CODE, MODEL_PIC, MAIL_RECEIVER
			;

			OPEN CUR_SEND;
			FETCH NEXT FROM CUR_SEND INTO @v_packer, @v_packer_code, @v_model_pic, @v_mail_receiver
		
			WHILE @@FETCH_STATUS = 0
			BEGIN

				SET @v_body_cont = @v_body_cont+ '<tr>';	

				SET @v_body_cont = @v_body_cont+ '<td align=''center''>' + REPLACE(ISNULL(@v_dis_cutoff_date,''), CHAR(10),' ') + '</td>';
				SET @v_body_cont = @v_body_cont+ '<td align=''center''>' + REPLACE(ISNULL(@v_packer,''), CHAR(10),' ') + '</td>';
				SET @v_body_cont = @v_body_cont+ '<td align=''center''>' + REPLACE(ISNULL(@v_packer_code,''), CHAR(10),' ') + '</td>';
				SET @v_body_cont = @v_body_cont+ '<td align=''left''>' + REPLACE(ISNULL(@v_model_pic,''), CHAR(10),' ') + '</td>';
				SET @v_body_cont = @v_body_cont+ '<td align=''left''>' + REPLACE(ISNULL(@v_dead_line,''), CHAR(10),' ') + '</td>';

				SET @v_body_cont = @v_body_cont+ '</tr>'

			FETCH NEXT FROM CUR_SEND INTO @v_packer, @v_packer_code, @v_model_pic, @v_mail_receiver
			END

			CLOSE CUR_SEND;
			DEALLOCATE CUR_SEND;

			SET @TABLE_BODY = '';
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
											'<table style=''border-top:2px solid #c8294b; width:1150px;''>
											<thead>' + ISNULL(@v_head_cont,'') +'</thead>
											<tbody>' + ISNULL(@v_body_cont, '') + '</tbody>
											</div>
										</body>
								</html>';

				--//메일 발송	일단 맊음	나중에 풀어야 된다. 
			EXEC SCM_ADM_MAIL_SEND
				  @v_to_mail		-- 'corewhite11@lgespartner.com' -- @v_to_mail			
				, @v_mail_title
				, @TABLE_BODY
				, 'Y'
			;

			EXEC SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG 'MAIL'
							,'-'
							,@v_program_name
							,@v_mail_title
							,@v_division_id
							,@v_operation_group
							,@v_model_pic
							,@v_mail_receiver
							,''
							,''
							,''
							,''
							,'' 
							,@v_to_mail;
						--//END : 메일 발송

--			SELECT @v_to_mail, @v_mail_title, @v_body_cont, @TABLE_BODY;
		END

		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	END TRY

	BEGIN CATCH
		IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WHERE CURSOR_NAME = 'CUR_SEND')
		BEGIN
			CLOSE CUR_SEND;
			DEALLOCATE CUR_SEND;
		END

		print 'STEP ERROR';

		BEGIN
			DECLARE @v_error_message NVARCHAR(1000);
			SET @v_error_message = SUBSTRING(ERROR_MESSAGE(),1,1000);
			print @v_error_message;

			INSERT INTO scm_sys_log_batch 
			(
				program_name
				, log_type
				, log_count
				, log_message
				, description
				, event_date
				, creation_date
				, created_by
				, last_update_date
				, last_updated_by
			)
			VALUES 
			(
				ERROR_PROCEDURE()
				, 'ERROR'
				, NULL
				, ERROR_MESSAGE()
				, NULL
				, SYSDATETIME()
				, SYSDATETIME()
				, ERROR_PROCEDURE()
				, SYSDATETIME()
				, ERROR_PROCEDURE()
			);

			--MAIL 발송 LOG 저장
			EXEC SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG 
				'ERROR'
				, '-'
				, @v_program_name
				, 'MAIN ERROR' 
				, ''
				, ''
				, ''
				, ''
				, ''
				, ''
				, ''
				, ''
				, @v_error_message --p_send_pgm
				, ''
			;
		END

		-- error코드, errror 메시지 반환
		SELECT 'F' AS result_code;
		SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
			
--		set @p_log_messge = @v_error_message;

--		return -1;

	END CATCH;

	IF OBJECT_ID('TEMPDB..#TMP_RESULT_TABLE_1') IS NOT NULL	
		DROP TABLE #TMP_RESULT_TABLE_1;

	IF OBJECT_ID('TEMPDB..#TMP_RESULT_TABLE_2') IS NOT NULL	
		DROP TABLE #TMP_RESULT_TABLE_2;

	IF OBJECT_ID('TEMPDB..##TMP_MAILSEND_TABLE_P') IS NOT NULL	
		DROP TABLE #TMP_MAILSEND_TABLE_P;

	IF OBJECT_ID('TEMPDB..##TMP_MAILSEND_TABLE') IS NOT NULL	
		DROP TABLE #TMP_MAILSEND_TABLE;

	return 1;
END



