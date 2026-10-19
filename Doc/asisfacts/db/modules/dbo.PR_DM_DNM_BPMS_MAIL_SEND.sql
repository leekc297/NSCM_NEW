
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


/*  
 * Program ID   : PR_DM_DNM_BPMS_MAIL_SEND  
 * Description  : BPMS에서 수신된 공급품목의 VALID 가 'N'으로 변경되면 Owner에게 메일 발송
 * PARAMETER    : N/A
 * Program History  
 *===================================================================================================  
 *   Date       In Charge      Description  
 *===================================================================================================
 * 2021.06.08	P.C.I		   [C20210312-000399] BPMS -> GSCM I/F 시 VALID 'N'은 Sales Site Project Model 적용
 */  


CREATE PROC [dbo].[PR_DM_DNM_BPMS_MAIL_SEND]
AS
SET NOCOUNT ON

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
    SET NOCOUNT ON;

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_DM_DNM_BPMS_MAIL_SEND';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
	DECLARE @dispatch_serial_no INT;

	-- 시작 LOG
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

BEGIN TRY
	


	IF OBJECT_ID (N'tempdb..#TEMP_SCM_MST_SITE_ITEM', N'U') IS NOT NULL 		DROP TABLE #TEMP_SCM_MST_SITE_ITEM
	IF OBJECT_ID (N'tempdb..#T_MAIN', N'U') IS NOT NULL 		DROP TABLE #T_MAIN


	SELECT *
		, DBO.FN_GET_DM_MKT_OWNER_NAME (SMSI.OWNER, ',', 'EN' )                AS OWNER_NAME
		, DBO.FN_GET_DM_MKT_OWNER_NAME (SMSI.OWNER, ',', 'KO' )                AS OWNER_NAME_KO
		,(	SELECT SU.DEPT_ID  
			FROM SCM_MST_SSO_USER_INFO SU WITH (NOLOCK)
			WHERE SU.USER_ID = (SELECT top 1 token FROM [dbo].[String_Split](SMSI.owner, ',')) ) DEPT_ID
	INTO #TEMP_SCM_MST_SITE_ITEM
	FROM SCM_MST_SITE_ITEM SMSI WITH(NOLOCK)
	WHERE SMSI.LAST_UPDATED_BY  = 'SYSTEM_BATCH_BOM_VALID_N'
	AND   VALID_YN = 'N'

	
	SELECT D.DEPT_NAME_KO, ISNULL(E.SEGMENT3, C.END_CUSTOMER) AS END_CUSTOMER, A.SCM_SITE_ID, A.PROJECT_CODE, F.PROJECT_NAME, A.ITEM_ID, A.OWNER
	INTO #T_MAIN
	FROM #TEMP_SCM_MST_SITE_ITEM A
	LEFT OUTER JOIN SCM_MST_SITE C ON A.DIVISION_ID = C.DIVISION_ID AND A.SCM_SITE_ID = C.SCM_SITE_ID
	LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO D ON C.DEPT_ID = D.DEPT_ID
	LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL E ON C.DIVISION_ID = E.SEGMENT1 AND C.END_CUSTOMER = E.SEGMENT2 AND E.LOOKUP_TYPE = 'END_CUSTOMER'
	LEFT OUTER JOIN SCM_MST_PROJECT F ON A.DIVISION_ID = F.DIVISION_ID AND A.PROJECT_CODE = F.PROJECT_CODE
	GROUP BY D.DEPT_NAME_KO, ISNULL(E.SEGMENT3, C.END_CUSTOMER), A.SCM_SITE_ID, A.PROJECT_CODE, F.PROJECT_NAME, A.ITEM_ID, A.OWNER

	IF ((SELECT count(*) FROM #T_MAIN) > 0 )
	BEGIN


		DECLARE @T_MAIL_ADDR TABLE (
		ADDR			NVARCHAR(150)
		, OWNER_TYPE	CHAR(3)
		, SEQ			INT				IDENTITY(0,1)
		)

		INSERT INTO @T_MAIL_ADDR ( ADDR, OWNER_TYPE )
		SELECT DISTINCT B.TOKEN+'@LGENSOL.COM', 'GEN'
		FROM #T_MAIN A
		CROSS APPLY DBO.STRING_SPLIT(A.OWNER, ',') B 
		WHERE B.TOKEN IS NOT NULL

		-- 영업관리팀 주소 추가 ( 영업관리는 모든 데이터를 보낸다 )
		INSERT INTO @T_MAIL_ADDR ( ADDR, OWNER_TYPE )
		SELECT	  CASE WHEN [1] IS NOT NULL THEN [1]+';' ELSE '' END
			+ CASE WHEN [2] IS NOT NULL THEN [2]+';' ELSE '' END
			+ CASE WHEN [3] IS NOT NULL THEN [3]+';' ELSE '' END
			+ CASE WHEN [4] IS NOT NULL THEN [4]+';' ELSE '' END
			+ CASE WHEN [5] IS NOT NULL THEN [5]+';' ELSE '' END
			+ CASE WHEN [6] IS NOT NULL THEN [6]+';' ELSE '' END
			+ CASE WHEN [7] IS NOT NULL THEN [7]+';' ELSE '' END
			, 'MNG'
		FROM (
			SELECT A.SEGMENT1, ROW_NUMBER() OVER ( ORDER BY DISPLAY_SEQ ) AS ROW_NUM
			FROM SCM_ADM_LOOKUP_MASTER_DETAIL A
			WHERE A.LOOKUP_TYPE = 'DM_BPMS_MAIL_ADDR'
				AND A.VALID_YN = 'Y'
			) A
		PIVOT ( 
			MAX(SEGMENT1) FOR ROW_NUM IN ([1],[2],[3],[4],[5],[6],[7])
			) AS PVT



		------------------------------------------------------------------------------------------------------
		-- 메일발송 시작
		------------------------------------------------------------------------------------------------------

			DECLARE @TABLE_BODY			NVARCHAR(MAX)
				, @v_body_contents	NVARCHAR(MAX)
				, @v_head_cont		NVARCHAR(MAX)
				, @v_body_cont		NVARCHAR(MAX)
				, @v_to_mail		NVARCHAR(150)
				, @v_mail_title		NVARCHAR(100)
				, @V_OWNER			NVARCHAR(100)
				, @V_OWNER_TYPE		CHAR(3)
				, @V_LIKE_STRING	NVARCHAR(100)
				, @v_cnt int
				, @v_i int

			DECLARE   @C_DEPT_NAME_KO	NVARCHAR(150)
					, @C_END_CUSTOMER	NVARCHAR(100)
					, @C_SCM_SITE_ID	NVARCHAR(200)
					, @C_PROJECT_CODE	NVARCHAR(50)
					, @C_PROJECT_NAME	NVARCHAR(200)
					, @C_ITEM_ID		NVARCHAR(50)
					, @C_OWNER			NVARCHAR(100)


		

			-----------------------------
			SET @v_mail_title = N'BPMS 공급품목 Active = N 리스트 안내'
			SET @v_body_contents = N'안녕하십니까? </br> ' + CONVERT(NVARCHAR(40), GETDATE(), 120) 
				+ N' BPMS 공급품목에서 삭제 되어, Sales Site Project Model에서 아래 모델은 Active = N으로 변경되었습니다.</BR></BR>'
			SET @v_head_cont = N'<TR>
				<TH rowspan="1">팀</TH>
				<TH rowspan="1">고객명</TH>
				<TH rowspan="1">Sales Site</TH>
				<TH rowspan="1">Project Code</TH>
				<TH rowspan="1">프로젝트명</TH>
				<TH rowspan="1">Model</TH>
				<TH rowspan="1">담당자</TH>
				</TR>'

			SELECT @V_CNT = COUNT(*), @V_I = 0, @v_to_mail = '', @V_OWNER = ''
			FROM @T_MAIL_ADDR

			WHILE ( @V_I < @V_CNT )
			BEGIN
		
				SELECT @V_OWNER = ADDR
					, @V_OWNER_TYPE = OWNER_TYPE
				FROM @T_MAIL_ADDR
				WHERE SEQ = @V_I

				SET @V_LIKE_STRING = CASE WHEN CHARINDEX('@', @V_OWNER) > 0 THEN LEFT(@V_OWNER, CHARINDEX('@', @V_OWNER)-1)
										ELSE @V_OWNER
										END

				SET @v_body_cont = '';

				
					-- 본문내용 생성
					DECLARE CUR_SEND CURSOR FAST_FORWARD FOR
					SELECT 
						DEPT_NAME_KO	
						, END_CUSTOMER	
						, SCM_SITE_ID
						, PROJECT_CODE	
						, PROJECT_NAME	
						, ITEM_ID		
						, OWNER			
					FROM #T_MAIN A
					WHERE OWNER LIKE '%' + CASE WHEN @V_OWNER_TYPE = 'GEN' THEN @V_LIKE_STRING  ELSE '' END + '%'
					--ORDER BY SORT_KEY

					OPEN CUR_SEND;
					FETCH NEXT FROM CUR_SEND INTO @C_DEPT_NAME_KO, @C_END_CUSTOMER, @C_SCM_SITE_ID, @C_PROJECT_CODE, @C_PROJECT_NAME, @C_ITEM_ID, @C_OWNER

					WHILE @@FETCH_STATUS = 0
					BEGIN
						SET @v_body_cont = @v_body_cont+ N'<TR>'
						SET @v_body_cont = @v_body_cont+ N'<TD>' + ISNULL(@C_DEPT_NAME_KO,'') + N'</TD>'	
						SET @v_body_cont = @v_body_cont+ N'<TD>'	+ ISNULL(@C_END_CUSTOMER,'') + N'</TD>'	
						SET @v_body_cont = @v_body_cont+ N'<TD>'	+ ISNULL(@C_SCM_SITE_ID,'') + N'</TD>'	
						SET @v_body_cont = @v_body_cont+ N'<TD>'	+ ISNULL(@C_PROJECT_CODE,'') + N'</TD>'	
						SET @v_body_cont = @v_body_cont+ N'<TD>'	+ ISNULL(@C_PROJECT_NAME,'') + N'</TD>'	
						SET @v_body_cont = @v_body_cont+ N'<TD>'	+ ISNULL(@C_ITEM_ID,'') + N'</TD>'	
						SET @v_body_cont = @v_body_cont+ N'<TD>'	+ ISNULL(@C_OWNER,'') + N'</TD>'	
						SET @v_body_cont = @v_body_cont+ N'</TR>'
		
					FETCH NEXT FROM CUR_SEND INTO @C_DEPT_NAME_KO, @C_END_CUSTOMER, @C_SCM_SITE_ID, @C_PROJECT_CODE, @C_PROJECT_NAME, @C_ITEM_ID, @C_OWNER
		
					END
	
					CLOSE CUR_SEND;
					DEALLOCATE CUR_SEND;

					SET @TABLE_BODY = N' <html>
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
										<body></br><b>' + REPLACE(ISNULL(@v_body_contents, ''), CHAR(10), N'<br>') + N'</b>'
												+ N'<div id="divBody" style="width: 100%; overflow-x: auto; overflow-y: auto; font-size: 9pt; line-break: auto;">'
												+ N'<table style=''border-top:2px solid #c8294b; width:1450px;''>
											<thead>' + ISNULL(@v_head_cont,'') + N'</thead>
											<tbody>' + ISNULL(@v_body_cont, '') + N'</tbody>
											</div>
										</body>
								</html>';


				--//메일 발송
				
				IF DB_NAME() <> 'LGCE_SCMDEV'
					IF @V_OWNER_TYPE = 'GEN' 
						BEGIN 
							EXEC SCM_ADM_MAIL_SEND
								  @V_OWNER -- 영업관리가 아니면 @뒷부분 붙여준다. ( 영업관리는 앞에서 붙였음 )
								--'CHOIYA2@LGESPARTNER.COM'
								, @v_mail_title -- @v_mail_title 
								, @TABLE_BODY
								, 'Y'
						END
					ELSE
						BEGIN
							EXEC SCM_ADM_MAIL_SEND
								  @V_OWNER -- 영업관리가 아니면 @뒷부분 붙여준다. ( 영업관리는 앞에서 붙였음 )
								--'CHOIYA2@LGESPARTNER.COM' -- 'sooykwon@lgensol.com'
								, @v_mail_title -- @v_mail_title 
								, @TABLE_BODY
								, 'Y'
						END

				--EXEC SCM_ADM_MAIL_SEND
				--			--  @V_OWNER -- 영업관리가 아니면 @뒷부분 붙여준다. ( 영업관리는 앞에서 붙였음 )
				--			'jssbae@LGESPARTNER.COM'
				--			, @v_mail_title -- @v_mail_title 
				--			, @TABLE_BODY
				--			, 'Y'
			
			
				--MAIL 발송 LOG 저장
				EXEC SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG 
					'MAIL'
					, '-'
					, @v_program_name
					, @V_OWNER_TYPE
					, @v_mail_title
					, @TABLE_BODY
					, ''
					, ''
					, ''
					, ''
					, ''
					, ''
					, '' --p_send_pgm
					, @V_OWNER --'HWI1993@LGESPARTNER.COM' -- @v_to_mail
				;



				SET @V_I = @V_I + 1
			END

			UPDATE SCM_MST_SITE_ITEM 
			SET   LAST_UPDATED_BY  = 'SYSTEM_BATCH_BOM'
			    , LAST_UPDATE_DATE = GETDATE()
			WHERE LAST_UPDATED_BY  = 'SYSTEM_BATCH_BOM_VALID_N'
			AND   VALID_YN = 'N'


		END


END TRY
			
BEGIN CATCH

		SET @v_log_type = 'ERROR';
		SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
		SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
END CATCH

	
	-- 종료 LOG
	SET @v_log_type = 'END';
	SET @v_log_message = '########## END of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;



