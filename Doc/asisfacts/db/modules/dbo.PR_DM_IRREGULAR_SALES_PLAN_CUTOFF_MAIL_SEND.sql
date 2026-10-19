
/*==============================================================================================================================
 * Program ID   : PR_DM_IRREGULAR_SALES_PLAN_CUTOFF_MAIL_SEND    
 * Description  : Sales Plan 정기 CUTOFF 외 SCP에서 CALL하여 CUTOFF 진행되는 경우 메일 발송 
 * Parameter	: Division, @p_creation_type--[E20250529-001289]_추가 
 * Program History    
 *==============================================================================================================================
 *   Date       In Charge	Description    
 *==============================================================================================================================
 * 2025-02-24	JSSBAE		[E20250210-000219]_SCP 엔진 재수행에 따른 Sales Plan Cutoff 재수행 자동화
 * 2025-06-05	JSSBAE		[E20250529-001289]_DM 장애 대응 개선을 위한 시스템 개선
 * 2026-06-01	JSSBAE		[E20260529-001499]_Sales Plan Cutoff 메일링 방식 개선
 *  
 * EXEC PR_DM_IRREGULAR_SALES_PLAN_CUTOFF_MAIL_SEND @p_division_id=N'82', @p_creation_type=N'REGULAR'    
 ==============================================================================================================================*/
     
CREATE PROC [dbo].[PR_DM_IRREGULAR_SALES_PLAN_CUTOFF_MAIL_SEND]
	  @p_division_id				NVARCHAR(30)	-- DIVISION_ID
	, @p_creation_type				NVARCHAR(100)	--[E20250529-001289]_생성에 따라 메일링 문구가 다르기 때문에, 배치일정을 기본으로 셋팅한다.
AS  


BEGIN
	SET NOCOUNT ON;   
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;  
	SET NOCOUNT ON;    
	--=================================================================================================
	--STEP 01. LOG 저장 (변수 생성 및 실행)   
	--=================================================================================================
	---------------------------------------------------------------------------------------------------
	-- LOG 용 변수 설정  
	---------------------------------------------------------------------------------------------------
	DECLARE @v_program_name		NVARCHAR(150) = 'PR_DM_IRREGULAR_SALES_PLAN_CUTOFF_MAIL_SEND';  
	DECLARE @v_log_type			NVARCHAR(30); -- START/END/ERROR/...  
	DECLARE @n_log_count		INTEGER = 0;  
	DECLARE @v_log_message		NVARCHAR(1000);  
	DECLARE @v_description		NVARCHAR(500);  
	DECLARE @d_event_date		DATETIME;    
	---------------------------------------------------------------------------------------------------
	-- 시작 LOG (START)
	---------------------------------------------------------------------------------------------------
	SET @v_log_type		= 'START';  
	SET @v_log_message	= '##### Start of procedure #####';  
	SET @v_description	= N'Sales Plan CUTOFF 후 알림 메일 발송';  
	SET @d_event_date	= SYSDATETIME();  

	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;  
	---------------------------------------------------------------------------------------------------
	-- 시작 LOG (END)
	---------------------------------------------------------------------------------------------------  
	BEGIN TRY     
		--================================================================================================= 
		-- STEP 02. 임시테이블 / 변수 생성   
		--=================================================================================================
		IF OBJECT_ID (N'tempdb..#TEMP_SALES_PLAN_CUTOFF', N'U')			
			IS NOT NULL DROP TABLE #TEMP_SALES_PLAN_CUTOFF;
		IF OBJECT_ID (N'tempdb..#T_MAIL_ADDR', N'U')					
			IS NOT NULL	DROP TABLE #T_MAIL_ADDR;
		
PRINT ( @v_program_name + ' A001: ' + 'DIVISION_ID: '+ @p_division_id + N' / CREATION_TYPE: '+ @p_creation_type + N' / '+ CONVERT(NVARCHAR(30), GETDATE(), 121))	 
		--================================================================================================= 
		-- STEP 03. 호출된 날짜로 SALES PLAN CUTOFF가 진행된 내역이 있는지 데이터 보관
		--================================================================================================= 
		BEGIN
			DECLARE @V_MAX_NO	NVARCHAR(30);

			SELECT	@V_MAX_NO = MAX(VERSION_NO)
			FROM	DM_MST_VERSION WITH(NOLOCK)
			WHERE	VERSION_TYPE = 'SP_W'
			AND		DIVISION_ID = @p_division_id
			AND		CONVERT(VARCHAR(8), CREATION_DATE, 112) = CONVERT(VARCHAR(8), GETDATE(), 112);	
		
			SELECT	DIVISION_ID, VERSION_NO, VERSION_DESCRIPTION, VERSION_TYPE, CREATED_BY, CREATION_DATE
			INTO	#TEMP_SALES_PLAN_CUTOFF
			FROM	DM_MST_VERSION WITH(NOLOCK)
			WHERE	DIVISION_ID = @p_division_id
			AND		VERSION_NO	= @V_MAX_NO
		END
	
PRINT ( @v_program_name + ' A002: ' + 'DIVISION_ID: '+ @p_division_id + N' / MAX_VERSION_NO: '+ @V_MAX_NO + N' / '+ CONVERT(NVARCHAR(30), GETDATE(), 121))	 
		--================================================================================================= 
		-- STEP 04. 메일발송 대상    
		--================================================================================================= 
		BEGIN	
			--[E20260529-001499]_원소스 주석처리 (START)
			/*
			DECLARE @T_MAIL_ADDR TABLE 
			( ADDR			NVARCHAR(150)
			, SEQ			INT				IDENTITY(0,1))
			
			-- 룩업에 등록된 대상에 대해서만 메일을 발송한다.
			INSERT INTO @T_MAIL_ADDR ( ADDR )
			SELECT	A.SEGMENT2
			FROM	SCM_ADM_LOOKUP_MASTER_DETAIL A WITH(NOLOCK)
			WHERE	A.LOOKUP_TYPE	= 'DM_IRREGULAR_SALES_PLAN_CUTOFF_MAIL_ADDR'
			AND 	(A.SEGMENT1 = @p_division_id  OR A.SEGMENT1 = 'ALL')
			AND 	A.VALID_YN = 'Y'
			*/
			--[E20260529-001499]_원소스 주석처리 (END)
			
			CREATE TABLE #TEMP_MAIL_ADDR
			( SEQ			INT	
			, ADDR			NVARCHAR(MAX))

			--[E20260529-001499]_메일 발송 시 시간이 너무 오래걸려 방식 변경 (AS_IS: 한명씩 발송 / TO_BE: 5명씩 발송) (START)
			INSERT INTO #TEMP_MAIL_ADDR ( SEQ, ADDR )
			SELECT GroupNo, STRING_AGG(SEGMENT2, ';') AS ADDR 
			FROM ( SELECT	A.SEGMENT2, ((ROW_NUMBER() OVER (ORDER BY SEGMENT2) - 1) / 5) + 1 AS GroupNo 
					FROM	SCM_ADM_LOOKUP_MASTER_DETAIL A WITH(NOLOCK)
					WHERE	A.LOOKUP_TYPE	= 'DM_IRREGULAR_SALES_PLAN_CUTOFF_MAIL_ADDR'
					AND 	(A.SEGMENT1 = @p_division_id  OR A.SEGMENT1 = 'ALL')
					AND 	A.VALID_YN = 'Y' ) A
			GROUP BY GroupNo
			--[E20260529-001499]_메일 발송 시 시간이 너무 오래걸려 방식 변경 (AS_IS: 한명씩 발송 / TO_BE: 5명씩 발송) (END)

		END
PRINT ( @v_program_name + ' A003: ' + 'DIVISION_ID: '+ @p_division_id + N' / MAX_VERSION_NO: '+ @V_MAX_NO + N' / '+ CONVERT(NVARCHAR(30), GETDATE(), 121))	 

		--================================================================================================= 
		-- STEP 05. 메일발송 - 전송대상만큼 반복 (헤더, 본문)   
		--================================================================================================= 
		BEGIN
			DECLARE	  @TABLE_BODY					NVARCHAR(MAX)  
					, @v_body_contents				NVARCHAR(MAX)  
					, @v_head_cont					NVARCHAR(MAX)  
					, @v_body_cont					NVARCHAR(MAX)  
					, @v_mail_title					NVARCHAR(MAX)  					
					--, @V_OWNER					NVARCHAR(100)  --[E20260529-001499]_원소스 주석처리 
					, @V_OWNER						NVARCHAR(MAX)  --[E20260529-001499]_MAX로 변경
					, @V_OWNER_TYPE		            CHAR(3)
					, @V_LIKE_STRING	            NVARCHAR(MAX)
					, @v_cnt						INT
					, @v_i							INT
			---------------------------------------------------------------------------------------------------
			-- STEP 05-1. 테이블 HEADER   
			---------------------------------------------------------------------------------------------------
			--SET @v_mail_title = N'Sales Plan Cutoff 재수행' --[E20250529-001289]_정기적으로 CUTOFF 진행하는 SALES PLAN에 대해서도 CUTOFF를 요청하여 문구 분기처리하기 위해 원소스 주석처리
			---------------------------------------------------------------------------------------------------
			--[E20250529-001289]_정기배치인 경우는 문구 수행완료, 비정기로 발생한 건은 재수행완료로 메시지 셋팅 START
			---------------------------------------------------------------------------------------------------
			IF @p_creation_type = 'REGULAR'
			BEGIN
				SET @v_mail_title = N'Sales Plan Cutoff 수행완료'
			END
			ELSE 
			BEGIN
				SET @v_mail_title = N'Sales Plan Cutoff 재수행완료'
			END		
			---------------------------------------------------------------------------------------------------
			--[E20250529-001289]_정기배치인 경우는 문구 수행완료, 비정기로 발생한 건은 재수행완료로 메시지 셋팅 END
			---------------------------------------------------------------------------------------------------
			/* 운영용 */
			/*
			SET @v_body_contents = N'안녕하십니까, SCM.DM 시스템입니다. </br> ' 
								 --+ N'Sales Plan Cutoff가 재생성되어, 생성된 버전 안내드립니다. </br> ' --[E20250529-001289]_정기적으로 CUTOFF 진행하는 SALES PLAN에 대해서도 CUTOFF를 요청하여 문구 분기처리하기 위해 원소스 주석처리
			*/
			/* 개발용 */
			SET @v_body_contents = N'개발시스템 TEST 진행중입니다. </br> ' 
								 + N'안녕하십니까, SCM.DM 시스템입니다.  </br> ' 
								 --+ N'Sales Plan Cutoff가 재생성되어, 생성된 버전 안내드립니다. </br> ' --[E20250529-001289]_정기적으로 CUTOFF 진행하는 SALES PLAN에 대해서도 CUTOFF를 요청하여 문구 분기처리하기 위해 원소스 주석처리
			
			---------------------------------------------------------------------------------------------------
			--[E20250529-001289]_정기배치인 경우는 문구 수행완료, 비정기로 발생한 건은 재수행완료로 메시지 셋팅 START
			---------------------------------------------------------------------------------------------------
			IF @p_creation_type = 'REGULAR'
			BEGIN
				SET @v_body_contents += N'Sales Plan Cutoff가 생성되어, 생성된 버전 안내드립니다. </br> '
			END
			ELSE 
			BEGIN
				SET @v_body_contents += N'Sales Plan Cutoff가 재생성되어, 생성된 버전 안내드립니다. </br> '
			END		
			---------------------------------------------------------------------------------------------------
			--[E20250529-001289]_정기배치인 경우는 문구 수행완료, 비정기로 발생한 건은 재수행완료로 메시지 셋팅 END
			---------------------------------------------------------------------------------------------------			
			SET @v_body_contents += + N'Report → Waterfall → Sales Plan Waterfall 화면에서 해당 버전 조회 가능하십니다. </br>' 
									+ N'' + @p_division_id +  ' Version: ' + @V_MAX_NO + ' </br></br>' 
			SET @v_body_cont = '';  

PRINT ( @v_program_name + ' A004: ' + @v_body_cont)		 
			------------------------------------------------------------------------------------------------------  
			-- STEP 05-2. 테이블 반복 내용  
			------------------------------------------------------------------------------------------------------ 		
			SELECT @V_CNT = COUNT(*), @V_I = 0, @V_OWNER = ''
			FROM #TEMP_MAIL_ADDR

		
			WHILE ( @V_I < @V_CNT )
			BEGIN		
				SELECT	@V_OWNER = ADDR
				FROM	#TEMP_MAIL_ADDR
				WHERE	SEQ = @V_I			   

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

								
				------------------------------------------------------------------------------------------------------   
				-- STEP 05-3. Mail 전송  
				------------------------------------------------------------------------------------------------------  		
				--실제로 생성된 버전이 존재하는 경우에만 메일을 발송한다.
				IF (SELECT COUNT(*) FROM #TEMP_SALES_PLAN_CUTOFF) > 0
				BEGIN
						-- 현업한테 가는 메일은 운영일 경우에만 발송함.
						IF DB_NAME() <> 'LGCE_SCMDEV'
						BEGIN 
							IF @V_OWNER != ''
							BEGIN
								EXEC SCM_ADM_MAIL_SEND @V_OWNER, @v_mail_title, @TABLE_BODY, 'Y' 
							END
						END
							IF @V_OWNER != ''
							BEGIN
								--MAIL 발송 LOG 저장
								EXEC SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG 
									'MAIL'
									, '-'
									, @v_program_name
									, ''
									, ''
									, ''
									, ''
									, ''
									, ''
									, ''
									, ''
									, ''
									, '' --p_send_pgm
									, @V_OWNER --> RECEIVE
								;
							END
				END

				IF ( @V_I % 5 IN ( 0, 5 ))
				BEGIN  
					WAITFOR DELAY '00:00:30'  
				END
			SET @V_I = @V_I + 1
			END			
		
		
PRINT ( @v_program_name + ' A005: ' + 'DIVISION_ID: '+ @p_division_id + N' / MAX_VERSION_NO: '+ @V_MAX_NO + N' / '+ CONVERT(NVARCHAR(30), GETDATE(), 121))	 
		END			 

	END TRY     
	---------------------------------------------------------------------------------------------------
	BEGIN CATCH   
	---------------------------------------------------------------------------------------------------	
	  SET @v_log_type		= 'ERROR';  
	  SET @v_log_message	= CAST(ERROR_MESSAGE() AS NVARCHAR(1000));  
	  SET @v_description	= 'ERROR_LINE : ' + STR(ERROR_LINE());  
	  SET @d_event_date		= SYSDATETIME();   
	  
	  SELECT @v_log_message;     

	  EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;    
	---------------------------------------------------------------------------------------------------
	END CATCH   
	---------------------------------------------------------------------------------------------------
   
	---------------------------------------------------------------------------------------------------
	-- 종료 LOG (START)
	---------------------------------------------------------------------------------------------------
	SET @v_log_type			= 'END';  
	SET @v_log_message		= '##### END of procedure #####';  
	SET @v_description		= N'Sales Plan CUTOFF 후 알림 메일 발송';  
	SET @d_event_date		= SYSDATETIME();  
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;  
	---------------------------------------------------------------------------------------------------
	-- 종료 LOG (END)
	---------------------------------------------------------------------------------------------------  
 END 
  
