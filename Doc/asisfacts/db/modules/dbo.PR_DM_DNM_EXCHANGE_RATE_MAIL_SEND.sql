---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


/****************************************************************************************************/
/*  
 * Program ID   : PR_DM_DNM_EXCHANGE_RATE_MAIL_SEND  
 * Description  : 최신 환율 정보 공유 메일 발송 - 매주 수요일 밤 11시40분 발송
 * PARAMETER    : N/A
 * Program History  
 *===================================================================================================  
 *   Date       In Charge      Description  
 *===================================================================================================
 * 2021.08.03	SJHAN	        [C20210723-000366] GSCM 환율 IF 알람(현재월포함 13개월)
 * 2021.08.24	hwi1993	        [C20210723-000366] - 메일 누락 수정
 * 2022.11.28	chano0612		[C20221124-000290] 환율 IF관련 수정 요청 건
 * 2023-08-04   HMIN            [E20230721-001841] 용어 수정  GSCM->SCM
 * 2025.07.03   kjiyoon			[PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 각 담당하는 사업부 환율 정보만 수신

 */ 
 /****************************************************************************************************/
 
CREATE PROC [dbo].[PR_DM_DNM_EXCHANGE_RATE_MAIL_SEND] 
AS
SET NOCOUNT ON

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
    SET NOCOUNT ON;

	-----------------------------------------------------------------------------------------------------------------------------------------
	-- STEP 01. LOG 저장 (변수 생성 및 실행) 
	-----------------------------------------------------------------------------------------------------------------------------------------
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_DM_DMM_EXCHANGE_RATE_MAIL_SEND';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
	DECLARE @dispatch_serial_no INT;

	-- 시작 LOG
	SET @v_log_type = 'START';
	SET @v_log_message = '##### Start of procedure #####';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

BEGIN TRY
	-----------------------------------------------------------------------------------------------------------------------------------------
	-- STEP 02. 임시테이블 / 변수 생성 
	-----------------------------------------------------------------------------------------------------------------------------------------

	--IF OBJECT_ID (N'tempdb..#EXCHANGE', N'U') IS NOT NULL 		DROP TABLE #EXCHANGE --주석. 아래로 이동 [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 각 담당하는 사업부 환율 정보만 수신
	--IF OBJECT_ID (N'tempdb..#T_MAIL_ADDR', N'U') IS NOT NULL 	DROP TABLE #T_MAIL_ADDR --주석. 아래로 이동 [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 각 담당하는 사업부 환율 정보만 수신

	DECLARE @V_FROMDATE NVARCHAR(10) = CONVERT(VARCHAR(6), GETDATE(), 112) + '01'								-- 날짜 From
	DECLARE @V_TODATE NVARCHAR(10) = CONVERT(VARCHAR(6), DATEADD(YEAR, 1, GETDATE()), 112) + '01'				-- 날짜 To
	DECLARE @NSQL		NVARCHAR(MAX);
	DECLARE @V_SCNT		INT = 1;
	DECLARE @V_TCNT		INT = 1;
	-----------------------------------------------------------------------------------------------------------------------------------------
	-- STEP 03. 환율 DATA 조회
	-----------------------------------------------------------------------------------------------------------------------------------------	
	
	--[PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 각 담당하는 사업부 환율 정보만 수신 START---------------------------------------------------------------------------------------------------------------------
	-- CURSOR 변수
	DECLARE @C_CUR_DIV_DIVISION_ID		NVARCHAR(10);
	DECLARE @C_CUR_DIV_DIVISION_ID_LIST NVARCHAR(200);

	DECLARE CUR_DIV CURSOR LOCAL FOR
		SELECT ATTRIBUTE3 AS DIVISION_ID, STRING_AGG(DIVISION_ID, ',') AS DIVISION_ID_LIST
		FROM SCM_MST_DIVISION
		WHERE ATTRIBUTE3 IN ('40', '81', '82' )
		GROUP BY ATTRIBUTE3

	OPEN CUR_DIV;
	FETCH NEXT FROM CUR_DIV INTO @C_CUR_DIV_DIVISION_ID,@C_CUR_DIV_DIVISION_ID_LIST

	WHILE @@FETCH_STATUS = 0
	BEGIN
	----[PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 각 담당하는 사업부 환율 정보만 수신 END-------------------------------------------------------------------------------------------------------------
		--PRINT '@C_CUR_DIV_DIVISION_ID = ' + @C_CUR_DIV_DIVISION_ID
		--PRINT '@C_CUR_DIV_DIVISION_ID_LIST = '+@C_CUR_DIV_DIVISION_ID_LIST 
		--PRINT 'TOP LOOP START : '+ FORMAT(GETDATE(), 'yyyyMMdd HH:mm:ss')
		
		IF OBJECT_ID (N'tempdb..#EXCHANGE', N'U') IS NOT NULL 		DROP TABLE #EXCHANGE

		SELECT *
		INTO #EXCHANGE
		FROM (
		SELECT DIVISION_ID, CURRENCY, UNIT_CURRENCY, EXCHANGE_PRICE, ROW_NUM
		FROM (
			SELECT 
					DIVISION_ID  
					,CURRENCY
					,UNIT_CURRENCY
					,YYYYMMDD
					,[dbo].[FN_GET_NUMER_TO_STRING] (ROUND(EXCHANGE_PRICE, 2),2) AS EXCHANGE_PRICE
					, DENSE_RANK() OVER ( ORDER BY YYYYMMDD ) AS ROW_NUM
			FROM [dbo].[DM_MST_EXCHANGE_RATE] (NOLOCK)
			WHERE
				YYYYMMDD >= @V_FROMDATE
				and YYYYMMDD <= @V_TODATE
				AND UNIT_CURRENCY IN ( SELECT SEGMENT1
										FROM SCM_ADM_LOOKUP_MASTER_DETAIL A
										WHERE LOOKUP_TYPE = 'DMF0020_CURRENCY'
											AND VALID_YN = 'Y'
									) 
				AND CURRENCY = 'KRW'
				AND DIVISION_ID IN (SELECT TOKEN from STRING_SPLIT(@C_CUR_DIV_DIVISION_ID_LIST ,',')) --사업부조건추가 [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 각 담당하는 사업부 환율 정보만 수신
			GROUP BY DIVISION_ID,CURRENCY, UNIT_CURRENCY, YYYYMMDD, EXCHANGE_PRICE 
			) A
		UNPIVOT (
			AA FOR BB IN ( YYYYMMDD )
			) UNP
		) A
		PIVOT (
			MAX(EXCHANGE_PRICE) FOR ROW_NUM IN ( [1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13])
			) AS PVT

		-----------------------------------------------------------------------------------------------------------------------------------------
		-- STEP 04. 메일발송 대상 
		-----------------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID (N'tempdb..#T_MAIL_ADDR', N'U') IS NOT NULL 	DROP TABLE #T_MAIL_ADDR

		SELECT A.SEGMENT1, ROW_NUMBER() OVER ( ORDER BY SEGMENT1 ) AS SEQ
		INTO #T_MAIL_ADDR
		FROM 
		(
			SELECT A.SEGMENT1
			FROM SCM_ADM_LOOKUP_MASTER_DETAIL A WITH (NOLOCK)
			CROSS APPLY STRING_SPLIT(A.SEGMENT3, ',') SS -- 사업부조건추가 [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 각 담당하는 사업부 환율 정보만 수신
			WHERE A.LOOKUP_TYPE = 'DM_EXCHANGE_RATE_MAIL_ADDR'
			  AND A.VALID_YN = 'Y' AND REPLACE(SEGMENT2, '-','') = ''
			  AND SS.TOKEN IN (SELECT TOKEN from STRING_SPLIT(@C_CUR_DIV_DIVISION_ID_LIST ,',')) -- 사업부조건추가 [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 각 담당하는 사업부 환율 정보만 수신

			UNION-- UNION ALL -> UNION 으로 변경 [PJ2025-50188]소형 매출계획 동기화 개선 고도화

			SELECT INFO.USER_ID + '@lgensol.com' -- POTAL ID + 에너지솔루션 MAIL주소
			--SELECT INFO.USER_ID + '@lgespartner.com' -- INFO.USER_ID, INFO.USER_NAME (Mail0000 - 테스트용)
			FROM SCM_MST_SSO_USER_INFO INFO
			INNER JOIN (SELECT B.DEPT_ID 
						FROM SCM_ADM_LOOKUP_MASTER_DETAIL A WITH (NOLOCK)
						INNER JOIN SCM_MST_SSO_DEPT_INFO B WITH (NOLOCK) ON  A.SEGMENT2 = B.DEPT_ID 
						CROSS APPLY STRING_SPLIT(A.SEGMENT3, ',') SS -- 사업부조건추가 [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 각 담당하는 사업부 환율 정보만 수신
						WHERE A.LOOKUP_TYPE = 'DM_EXCHANGE_RATE_MAIL_ADDR'
						AND A.VALID_YN = 'Y' AND REPLACE(SEGMENT2, '-','') <> ''
						AND SS.TOKEN IN (SELECT TOKEN from STRING_SPLIT(@C_CUR_DIV_DIVISION_ID_LIST ,',')) --사업부조건추가 [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 각 담당하는 사업부 환율 정보만 수신
					   ) B ON INFO.DEPT_ID = B.DEPT_ID
		
		) A


		SELECT @V_TCNT = COUNT(*) FROM #T_MAIL_ADDR
		DECLARE @V_MAIL_ADDR_LIST VARCHAR(MAX) = '';

		PRINT '@V_TCNT = ' + ISNULL(CONVERT(NVARCHAR, @V_TCNT), '0')

		-----------------------------------------------------------------------------------------------------------------------------------------
		-- STEP 05. 메일발송 - 전송대상만큼 반복 (헤더, 본문) 
		-----------------------------------------------------------------------------------------------------------------------------------------

			DECLARE @TABLE_BODY		NVARCHAR(MAX)
				, @v_body_contents	NVARCHAR(MAX)
				, @v_head_cont		NVARCHAR(MAX)
				, @v_body_cont		NVARCHAR(MAX)
				, @v_to_mail		NVARCHAR(150)
				, @v_mail_title		NVARCHAR(100)
				, @V_OWNER			NVARCHAR(100)
				, @V_OWNER_TYPE		CHAR(3)
				, @V_LIKE_STRING	NVARCHAR(100)

			DECLARE   @C_DIVISION_ID		NVARCHAR(150)
					, @C_CURRENCY			NVARCHAR(100)
					, @C_UNIT_CURRENCY		NVARCHAR(50)
					, @C_Mon01				NVARCHAR(50)		-- 조회 대상월(1) 환율값
					, @C_Mon02				NVARCHAR(50)		-- 조회 대상월(2) 환율값
					, @C_Mon03				NVARCHAR(50)		-- 조회 대상월(3) 환율값
					, @C_Mon04				NVARCHAR(50)		-- 조회 대상월(4) 환율값
					, @C_Mon05				NVARCHAR(50)		-- 조회 대상월(5) 환율값
					, @C_Mon06				NVARCHAR(50)		-- 조회 대상월(6) 환율값
					, @C_Mon07				NVARCHAR(50)		-- 조회 대상월(7) 환율값
					, @C_Mon08				NVARCHAR(50)		-- 조회 대상월(8) 환율값
					, @C_Mon09				NVARCHAR(50)		-- 조회 대상월(9) 환율값
					, @C_Mon10				NVARCHAR(50)		-- 조회 대상월(10) 환율값
					, @C_Mon11				NVARCHAR(50)		-- 조회 대상월(11) 환율값
					, @C_Mon12				NVARCHAR(50)		-- 조회 대상월(12) 환율값
					, @C_Mon13				NVARCHAR(50)		-- 조회 대상월(13) 환율값
					--, @C_OWNER			NVARCHAR(100)

			------------------------------------------------------------------------------------------------------
			-- STEP 05-1. 테이블 헤더 rowspan, colspan, 대상 월 구하기
			------------------------------------------------------------------------------------------------------
			DECLARE @v_ThisYearCol varchar(10) = '';
			DECLARE @v_NextYearCol varchar(10) = '';
			DECLARE @v_thisYear varchar(10) = '';
			DECLARE @v_NextYear varchar(10) = '';

			SET @v_ThisYearCol = DATEDIFF(MM, GETDATE(), DATEADD(YEAR, DATEDIFF(YEAR, -1, GETDATE()), -1)) + 1
			SET @v_NextYearCol = 13 - @v_ThisYearCol;
			SET @v_thisYear = CONVERT(VARCHAR(4), GETDATE(), 21);
			SET @v_NextYear = CONVERT(VARCHAR(4), DATEADD(YEAR, 1, GETDATE()), 21)
			------------------------------------------------------------------------------------------------------
			-- STEP 05-2. 최근환율 년, 월, 일 - 메일 제목 변수 
			------------------------------------------------------------------------------------------------------
			DECLARE @V_YYMMDD	NVARCHAR(8);
			DECLARE @V_YYYY		NVARCHAR(4);
			DECLARE @V_MM		NVARCHAR(2);
			DECLARE @V_DD		NVARCHAR(2);
			DECLARE @V_DATETIME	NVARCHAR(50);

			SET @V_YYMMDD = (SELECT TOP 1 CONVERT(NVARCHAR(8), LAST_UPDATE_DATE, 112) FROM DM_MST_EXCHANGE_RATE WITH (NOLOCK) ORDER BY LAST_UPDATE_DATE DESC)
			SET @V_YYYY = SUBSTRING(@V_YYMMDD, 1,4)
			SET @V_MM = SUBSTRING(@V_YYMMDD, 5,2)
			SET @V_DD = SUBSTRING(@V_YYMMDD, 7,2)

			SET @V_DATETIME = (SELECT TOP 1CONVERT(NVARCHAR(19), LAST_UPDATE_DATE, 121) FROM DM_MST_EXCHANGE_RATE WITH (NOLOCK) ORDER BY LAST_UPDATE_DATE DESC)

			------------------------------------------------------------------------------------------------------
			-- STEP 05-2. 테이브 HEADER 
			------------------------------------------------------------------------------------------------------
			SET @v_mail_title = N'최신 환율 정보 공유'
			SET @v_body_contents = N'안녕하십니까? </br> '
			+ N'</br> BPS 로부터 [ '+ @V_DATETIME + N' ] 에 IF받은 Exchange Rate가 SCM에 적용되어 있습니다. </br></br>' -- [E20230721-001841] 용어 수정  GSCM->SCM
			--	+ N'</br> EnSemble으로부터 [ '+ @V_DATETIME + N' ] 에 IF받은 Exchange Rate가 GSCM에 적용되어 있습니다. </br></br>' -- [C20221124-000290] 환율 IF관련 수정 요청 건
			--	+ N'</br> 챔피온으로부터 [ '+ @V_DATETIME + N' ] 에 IF받은 Exchange Rate가 GSCM에 적용되어 있습니다. </br></br>'
			--	+ N'</br> 챔피온으로부터 '+ @V_YYYY + N'년 ' + @V_MM + N'월 '+ @V_DD + N'일 IF받은 Exchange Rate가 GSCM에 적용되어 있습니다. </br></br>'
		

			SET @v_head_cont = N'<TR>
				<TH rowspan="2">DIV</TH>
				<TH rowspan="2">Currency</TH>
				<TH rowspan="2">Unit</TH>
				<TH colspan="'+ @v_ThisYearCol +'">'+ @v_thisYear +'</TH>
				<TH colspan="'+ @v_NextYearCol +'">'+ @v_NextYear +'</TH>
				</TR>
				<TR>
				<TH>'+ SUBSTRING(CONVERT(VARCHAR(10), GETDATE(), 21), 6, 2) +'</TH>
				<TH>'+ SUBSTRING(CONVERT(VARCHAR(10), DATEADD(MM, 1, GETDATE()), 21), 6, 2) +'</TH>
				<TH>'+ SUBSTRING(CONVERT(VARCHAR(10), DATEADD(MM, 2, GETDATE()), 21), 6, 2) +'</TH>
				<TH>'+ SUBSTRING(CONVERT(VARCHAR(10), DATEADD(MM, 3, GETDATE()), 21), 6, 2) +'</TH>
				<TH>'+ SUBSTRING(CONVERT(VARCHAR(10), DATEADD(MM, 4, GETDATE()), 21), 6, 2) +'</TH>
				<TH>'+ SUBSTRING(CONVERT(VARCHAR(10), DATEADD(MM, 5, GETDATE()), 21), 6, 2) +'</TH>
				<TH>'+ SUBSTRING(CONVERT(VARCHAR(10), DATEADD(MM, 6, GETDATE()), 21), 6, 2) +'</TH>
				<TH>'+ SUBSTRING(CONVERT(VARCHAR(10), DATEADD(MM, 7, GETDATE()), 21), 6, 2) +'</TH>
				<TH>'+ SUBSTRING(CONVERT(VARCHAR(10), DATEADD(MM, 8, GETDATE()), 21), 6, 2) +'</TH>
				<TH>'+ SUBSTRING(CONVERT(VARCHAR(10), DATEADD(MM, 9, GETDATE()), 21), 6, 2) +'</TH>
				<TH>'+ SUBSTRING(CONVERT(VARCHAR(10), DATEADD(MM, 10, GETDATE()), 21), 6, 2) +'</TH>
				<TH>'+ SUBSTRING(CONVERT(VARCHAR(10), DATEADD(MM, 11, GETDATE()), 21), 6, 2) +'</TH>
				<TH>'+ SUBSTRING(CONVERT(VARCHAR(10), DATEADD(MM, 12, GETDATE()), 21), 6, 2) +'</TH>
				</TR>'

			--LOOP 수행전 COUNT 변수 초기화 - [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 각 담당하는 사업부 환율 정보만 수신
			SET @V_SCNT = 1;

			------------------------------------------------------------------------------------------------------
			-- STEP 05-3. 테이블 반복 내용
			------------------------------------------------------------------------------------------------------
			WHILE ( @V_SCNT <= @V_TCNT )
			BEGIN
		
				SET @V_OWNER = '';
				SET @v_body_cont = '';
				SELECT @V_OWNER = SEGMENT1 FROM #T_MAIL_ADDR WHERE SEQ = @V_SCNT
				
				-- 본문내용 생성
				DECLARE CUR_SEND CURSOR FAST_FORWARD FOR
				SELECT * FROM #EXCHANGE
				ORDER BY DIVISION_ID, CURRENCY, UNIT_CURRENCY

				OPEN CUR_SEND;
				FETCH NEXT FROM CUR_SEND INTO @C_DIVISION_ID, @C_CURRENCY, @C_UNIT_CURRENCY
					, @C_Mon01, @C_Mon02, @C_Mon03, @C_Mon04, @C_Mon05, @C_Mon06, @C_Mon07, @C_Mon08, @C_Mon09, @C_Mon10, @C_Mon11, @C_Mon12, @C_Mon13
					--, @C_OWNER

				WHILE @@FETCH_STATUS = 0
				BEGIN
					SET @v_body_cont = @v_body_cont+ N'<TR>'
					SET @v_body_cont = @v_body_cont+ N'<TD align = center>' + ISNULL(@C_DIVISION_ID,'') + N'</TD>'	
					SET @v_body_cont = @v_body_cont+ N'<TD align = center>'	+ ISNULL(@C_CURRENCY,'') + N'</TD>' 
					SET @v_body_cont = @v_body_cont+ N'<TD align = center>'	+ ISNULL(@C_UNIT_CURRENCY,'') + N'</TD>' 
					SET @v_body_cont = @v_body_cont+ N'<TD align = right>'	+ ISNULL(@C_Mon01,'') + N'</TD>' 
					SET @v_body_cont = @v_body_cont+ N'<TD align = right>'	+ ISNULL(@C_Mon02,'') + N'</TD>' 
					SET @v_body_cont = @v_body_cont+ N'<TD align = right>'	+ ISNULL(@C_Mon03,'') + N'</TD>' 
					SET @v_body_cont = @v_body_cont+ N'<TD align = right>'	+ ISNULL(@C_Mon04,'') + N'</TD>' 
					SET @v_body_cont = @v_body_cont+ N'<TD align = right>'	+ ISNULL(@C_Mon05,'') + N'</TD>' 
					SET @v_body_cont = @v_body_cont+ N'<TD align = right>'	+ ISNULL(@C_Mon06,'') + N'</TD>' 
					SET @v_body_cont = @v_body_cont+ N'<TD align = right>'	+ ISNULL(@C_Mon07,'') + N'</TD>' 
					SET @v_body_cont = @v_body_cont+ N'<TD align = right>'	+ ISNULL(@C_Mon08,'') + N'</TD>' 
					SET @v_body_cont = @v_body_cont+ N'<TD align = right>'	+ ISNULL(@C_Mon09,'') + N'</TD>' 
					SET @v_body_cont = @v_body_cont+ N'<TD align = right>'	+ ISNULL(@C_Mon10,'') + N'</TD>' 					
					SET @v_body_cont = @v_body_cont+ N'<TD align = right>'	+ ISNULL(@C_Mon11,'') + N'</TD>' 
					SET @v_body_cont = @v_body_cont+ N'<TD align = right>'	+ ISNULL(@C_Mon12,'') + N'</TD>' 
					SET @v_body_cont = @v_body_cont+ N'<TD align = right>'	+ ISNULL(@C_Mon13,'') + N'</TD>' 
					SET @v_body_cont = @v_body_cont+ N'</TR>'
		
				FETCH NEXT FROM CUR_SEND INTO @C_DIVISION_ID, @C_CURRENCY, @C_UNIT_CURRENCY
					, @C_Mon01, @C_Mon02, @C_Mon03, @C_Mon04, @C_Mon05, @C_Mon06, @C_Mon07, @C_Mon08, @C_Mon09, @C_Mon10, @C_Mon11, @C_Mon12, @C_Mon13
		
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


				----------------------------------------------------------
				-- 테스트용
				----------------------------------------------------------
				--SET @V_MAIL_ADDR_LIST = @V_MAIL_ADDR_LIST + @V_OWNER + ';'
				--SELECT * FROM #T_MAIL_ADDR
				--SELECT @V_OWNER, @V_SCNT
				--SET @v_mail_title = N'Mail 제목: ' + @V_OWNER;
				--SET @V_OWNER = 'kjiyoon_es@lgespartner.com';			
				----------------------------------------------------------
				------------------------------------------------------------------------------------------------------
				-- STEP 05-4. Mail 전송
				------------------------------------------------------------------------------------------------------
				EXEC SCM_ADM_MAIL_SEND
					@V_OWNER 
					, @v_mail_title
					, @TABLE_BODY
					, 'Y'

				IF ( @V_SCNT % 5 IN ( 0, 5 ))
				BEGIN
					WAITFOR DELAY '00:00:30'
				END

				SET @V_SCNT = @V_SCNT + 1;

			END

			-- SELECT @V_MAIL_ADDR_LIST

	--[PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 각 담당하는 사업부 환율 정보만 수신 START---------------------------------------------------------------------------------------------------------------------
	
		FETCH NEXT FROM CUR_DIV INTO @C_CUR_DIV_DIVISION_ID,@C_CUR_DIV_DIVISION_ID_LIST
	END

	CLOSE CUR_DIV
	DEALLOCATE CUR_DIV
	
	--[PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 각 담당하는 사업부 환율 정보만 수신 END---------------------------------------------------------------------------------------------------------------------
	
	
END TRY
			
BEGIN CATCH

		SET @v_log_type = 'ERROR';
		SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
		SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
		SET @d_event_date = SYSDATETIME();
		
		SELECT @v_log_message 

		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
END CATCH

	
	-- 종료 LOG
	SET @v_log_type = 'END';
	SET @v_log_message = '##### END of procedure #####';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;



