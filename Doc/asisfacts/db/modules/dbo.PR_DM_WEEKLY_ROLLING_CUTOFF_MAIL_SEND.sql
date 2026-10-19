
/*=====================================================================================================================================================
 * Program ID   : PR_DM_WEEKLY_ROLLING_CUTOFF_MAIL_SEND    
 * Description  : MF_W, SF_W CUTOFF시 완료 후 메일 발송 
 * Parameter	: @p_division_id, @p_version_no  
 * Program History    
 *=====================================================================================================================================================
 *   Date       In Charge		Description    
 *=====================================================================================================================================================
 * 2025.05.29	JSSBAE			[E20250529-001289]_DM 장애 대응 개선을 위한 시스템 개선
 * 2026.06.01	JSSBAE			[E20260529-001499]_Sales Plan Cutoff 메일링 방식 개선
 *  
 * EXEC PR_DM_WEEKLY_ROLLING_CUTOFF_MAIL_SEND @p_division_id=N'82', @p_version_no = N'MF_W_20250529_V002'    
 *===================================================================================================================================================*/
 
CREATE PROCEDURE [dbo].[PR_DM_WEEKLY_ROLLING_CUTOFF_MAIL_SEND]
	  @p_division_id				NVARCHAR(30)  -- DIVISION_ID	
	, @p_version_no					NVARCHAR(100) -- VERSION_NO
AS  
BEGIN
	SET NOCOUNT ON;    
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;    
	--============================================================================================================== 
	--STEP 01. LOG 저장 (변수 생성 및 실행)   
	--==============================================================================================================
	----------------------------------------------------------------------------------------------------------------  
	--STEP 01_01. LOG 용 변수 설정  
	----------------------------------------------------------------------------------------------------------------  
	DECLARE @v_program_name		NVARCHAR(150) = 'PR_DM_WEEKLY_ROLLING_CUTOFF_MAIL_SEND';  
	DECLARE @v_log_type			NVARCHAR(30); -- START/END/ERROR/...  
	DECLARE @n_log_count		INTEGER = 0;  
	DECLARE @v_log_message		NVARCHAR(1000);  
	DECLARE @v_description		NVARCHAR(500);  
	DECLARE @d_event_date		DATETIME;  
  
PRINT @v_program_name + ' : A001--' +'Div: ' + @p_division_id +' /VerNo: ' + @p_version_no + ' / ' + CONVERT(NVARCHAR(30), GETDATE(), 121);
	---------------------------------------------------------------------------------------------------------------- 
	--시작 LOG (START) 
	---------------------------------------------------------------------------------------------------------------- 
	SET	@v_log_type		= 'START';  
	SET	@v_log_message	= '##### Start of procedure #####';  
	SET	@v_description	= N'Weekly Cutoff 완료 후 메일 발송 / Div: ' + @p_division_id +' / Ver: ' + @p_version_no;
	SET	@d_event_date	= SYSDATETIME();  

	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;  
	----------------------------------------------------------------------------------------------------------------  
	--시작 LOG (END) 
	---------------------------------------------------------------------------------------------------------------- 
	BEGIN TRY     
		--==============================================================================================================  
		--STEP 02. 임시테이블 / 변수 생성   
		--==============================================================================================================   
		IF OBJECT_ID (N'tempdb..#TEMP_CUTOFF_INFO', N'U') IS NOT NULL 
			DROP TABLE #TEMP_CUTOFF_INFO;
		IF OBJECT_ID (N'tempdb..#TEMP_MAIL_ADDR', N'U') IS NOT NULL	
			DROP TABLE #TEMP_MAIL_ADDR;
			
		----------------------------------------------------------------------------------------------------------------
		--임시테이블 생성
		---------------------------------------------------------------------------------------------------------------- 
		CREATE TABLE #TEMP_CUTOFF_INFO 
		( CUTOFF_TYPE		NVARCHAR(MAX)
		, DIVISION_ID		NVARCHAR(MAX)
		, VERSION_NO		NVARCHAR(MAX)
		, CNT				NVARCHAR(MAX))

		----------------------------------------------------------------------------------------------------------------
		--변수생성
		---------------------------------------------------------------------------------------------------------------- 
		DECLARE @s_MKT_FCST_CNT				NVARCHAR(15);	--MKT FCST CUTOFF COUNT 보관용변수
		DECLARE @s_NetDemand_CNT			NVARCHAR(15);	--NET_DEMNAD COUNT 보관용변수
		DECLARE @s_Pegging_CNT				NVARCHAR(15);	--PEGIING COUNT 보관용변수
		DECLARE @s_Net_Pegging_Version		NVARCHAR(200);	--NET_DEMNAD, PEGGIN VERSION 보관용 변수
		
		----------------------------------------------------------------------------------------------------------------  
		--NetDemand, Pegging의 경우 동일한 날짜에 MF_W, SF_W가 버전도 동일하다면, SF_W로 NetDemand, Pegging COUNT 건수를 구해야 한다.
		--하여, 버전을 MKT_FCST COUNT하는 버전과는 다르게, 버전을 구한 후 해당 버전으로 데이터를 COUNT한 후 메일링 해야한다.
		----------------------------------------------------------------------------------------------------------------  
		SELECT TOP 1 @s_Net_Pegging_Version = A.VERSION_NO 						
		FROM (	SELECT VERSION_NO, RANK() OVER (ORDER BY YYYYMMDD DESC, VER_CRE_SEQ DESC, VERSION_TYPE DESC) AS RN	--가장 최근의 버젼이면서 SF_W가 MF_W보다 우선함.
				FROM DM_MST_VERSION WITH(NOLOCK)
				WHERE DIVISION_ID = @p_division_id
				AND   VERSION_TYPE IN ('MF_W', 'SF_W')
				AND YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -7*1, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)    -- 당주 월요일부터
				AND YYYYMMDD <= CONVERT(CHAR(8), DATEADD(DD, 0, dbo.FN_NEXT_DAY(getdate(), 'SUN')), 112)       -- 당주 일요일까지
			 ) A
		WHERE RN = 1;
		
		--==============================================================================================================  
		--STEP 03. 파라미터로 받은 DIV, VERSION으로 데이터 건수가 몇 건인지 확인하여 테이블에 데이터 적재
		--==============================================================================================================  
		BEGIN			
			----------------------------------------------------------------------------------------------------------------   
			--STEP 03_01. MKT FCST CUTOFF 생성건수확인
			----------------------------------------------------------------------------------------------------------------  
			SELECT @s_MKT_FCST_CNT = COUNT(*) 
			FROM (	SELECT DIVISION_ID
					FROM DM_PLN_MKT_FCST_C WITH(NOLOCK)
					WHERE	DIVISION_ID = @p_division_id
					AND		VERSION_NO	= @p_version_no
					UNION ALL
					SELECT DIVISION_ID
					FROM DM_PLN_MKT_FCST_RESULT_C WITH(NOLOCK)
					WHERE	DIVISION_ID = @p_division_id
					AND		VERSION_NO	= @p_version_no ) T			
			
			----------------------------------------------------------------------------------------------------------------   
			--STEP 03_02. MKT FCST CUTOFF 데이터 적재
			----------------------------------------------------------------------------------------------------------------   
			INSERT INTO #TEMP_CUTOFF_INFO
			( CUTOFF_TYPE, DIVISION_ID, VERSION_NO, CNT )
			VALUES
			( 'MKT FCST CUTOFF', @p_division_id, @p_version_no, @s_MKT_FCST_CNT )
			
			----------------------------------------------------------------------------------------------------------------     
			--STEP 03_03. NET DEMAND 생성건수확인
			----------------------------------------------------------------------------------------------------------------   
			SELECT @s_NetDemand_CNT = COUNT(*) 
			FROM (	SELECT DIVISION_ID
					FROM DM_PLN_NET_DEMAND WITH(NOLOCK)
					WHERE	DIVISION_ID = @p_division_id
					AND		VERSION_NO	= @s_Net_Pegging_Version ) T	
					
			----------------------------------------------------------------------------------------------------------------   
			--STEP 03_04. MKT FCST CUTOFF 데이터 적재
			----------------------------------------------------------------------------------------------------------------   
			INSERT INTO #TEMP_CUTOFF_INFO
			( CUTOFF_TYPE, DIVISION_ID, VERSION_NO, CNT )
			VALUES
			( 'NET_DEMAND', @p_division_id, @s_Net_Pegging_Version, @s_NetDemand_CNT )
					
			----------------------------------------------------------------------------------------------------------------   
			--STEP 03_05. PEGGING 생성건수확인
			----------------------------------------------------------------------------------------------------------------   
			SELECT @s_Pegging_CNT = COUNT(*) 
			FROM (	SELECT DIVISION_ID
					FROM DM_PLN_DEMANDID_PEGGING WITH(NOLOCK)
					WHERE	DIVISION_ID = @p_division_id
					AND		VERSION_NO	= @s_Net_Pegging_Version ) T		
					
			----------------------------------------------------------------------------------------------------------------   
			--STEP 03_06. PEGGING 데이터 적재
			----------------------------------------------------------------------------------------------------------------   
			INSERT INTO #TEMP_CUTOFF_INFO
			( CUTOFF_TYPE, DIVISION_ID, VERSION_NO, CNT )
			VALUES
			( 'PEGGING', @p_division_id, @s_Net_Pegging_Version, @s_Pegging_CNT )
		END	
PRINT @v_program_name + ' : A002--' +'MKT FCST CUTOFF: 버전:' + @p_version_no + N' /건수:' + @s_MKT_FCST_CNT + N' /NET DEMAND: 버전:' + @s_Net_Pegging_Version+ N' /건수:'+ @s_NetDemand_CNT + N' /PEGGING: 버전:' + @s_Net_Pegging_Version+ N' /건수:'+ @s_Pegging_CNT + ' / ' + CONVERT(NVARCHAR(30), GETDATE(), 121);

		----------------------------------------------------------------------------------------------------------------   
		--건수 LOG (START) 
		----------------------------------------------------------------------------------------------------------------   
		SET @v_log_type	= 'APPEND';  
		SET @v_log_message = '##### APPEND of procedure #####';  
		SET @v_description = N'MKT FCST CUTOFF: 버전:' + @p_version_no + N' /건수:' + @s_MKT_FCST_CNT+ N' /NET DEMAND: 버전:'+ @s_Net_Pegging_Version+ N' /건수:'+ @s_NetDemand_CNT + N' /PEGGING: 버전:' + @s_Net_Pegging_Version+ N' /건수:'+ @s_Pegging_CNT;
		SET @d_event_date	= SYSDATETIME();  
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;  
		----------------------------------------------------------------------------------------------------------------   
		--건수 LOG (END) 
		----------------------------------------------------------------------------------------------------------------    
		--==============================================================================================================  
		--STEP 04. 메일발송 대상    
		--==============================================================================================================  

		BEGIN		
			----------------------------------------------------------------------------------------------------------------   
			--STEP 04_01. 룩업에 등록된 대상에 대해서만 메일을 발송한다.
			----------------------------------------------------------------------------------------------------------------
			--[E20260529-001499]_원소스 주석처리 (START)   
			/*
			CREATE TABLE #T_MAIL_ADDR 
			( ADDR				NVARCHAR(150)
			, SEQ				INT				IDENTITY(0,1))

			INSERT INTO #T_MAIL_ADDR ( ADDR )			
			SELECT	A.SEGMENT2 
			FROM	SCM_ADM_LOOKUP_MASTER_DETAIL A WITH(NOLOCK)
			WHERE	A.LOOKUP_TYPE = 'DM_WEEKLY_ROLLING_CUTOFF_MAIL_ADDR'
			AND		(A.SEGMENT1 = @p_division_id  OR A.SEGMENT1 = 'ALL')
			AND		A.VALID_YN	= 'Y' 
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
					WHERE	A.LOOKUP_TYPE = 'DM_WEEKLY_ROLLING_CUTOFF_MAIL_ADDR'
					AND		(A.SEGMENT1 = @p_division_id  OR A.SEGMENT1 = 'ALL')
					AND		A.VALID_YN	= 'Y' ) A
			GROUP BY GroupNo
			--[E20260529-001499]_메일 발송 시 시간이 너무 오래걸려 방식 변경 (AS_IS: 한명씩 발송 / TO_BE: 5명씩 발송) (END)
		END
PRINT @v_program_name + ' : A003--' +'Div: ' + @p_division_id +' /VerNo: ' + @p_version_no + ' /net_pegging_VerNo: ' + @s_Net_Pegging_Version +  ' / ' + CONVERT(NVARCHAR(30), GETDATE(), 121);


		--==============================================================================================================  
		--STEP 05. 메일발송 - 전송대상만큼 반복 (헤더, 본문)   
		--==============================================================================================================  
		BEGIN
			DECLARE   @TABLE_BODY					NVARCHAR(MAX)  
					, @v_body_contents				NVARCHAR(MAX)  
					, @v_head_cont					NVARCHAR(MAX)  
					, @v_body_cont					NVARCHAR(MAX)  
					, @v_mail_title					NVARCHAR(150)  
					--, @V_OWNER					NVARCHAR(100)  --[E20260529-001499]_원소스 주석처리
					, @V_OWNER						NVARCHAR(MAX)  --[E20260529-001499]_변경
					, @V_OWNER_TYPE		            CHAR(3)
					, @V_LIKE_STRING	            NVARCHAR(100)
					, @v_cnt int
					, @v_i int						
			
			DECLARE   @C_CUTOFF_TYPE		NVARCHAR(200)
					, @C_DIVISION_ID		NVARCHAR(50)
					, @C_VERSION_NO			NVARCHAR(100)
					, @C_CNT				NVARCHAR(50)
					;
					
			----------------------------------------------------------------------------------------------------------------     
			--STEP 05_01. 테이블 HEADER   
			----------------------------------------------------------------------------------------------------------------   
			SET @v_mail_title = N'Weekly Rolling Cutoff 완료 메일 발송'  
			
			/* 개발인경우 무조건 보내기 운영인 경우에는 주석처리 하기
			SET @v_body_contents  = N'개발시스템 TEST 진행중입니다. </br> ' 
								 +  N'Weekly Rolling Cutoff가 완료되어, 생성된 버전 및 해당 데이터의 건수 안내드립니다. </br> '  
			 */

			SET @v_body_contents = N'안녕하십니까, SCM.DM 시스템입니다. </br> ' 
								 +  N'Weekly Rolling Cutoff가 완료되어, 생성된 버전 및 해당 데이터의 건수 안내드립니다. </br> '  

			SET @v_head_cont = N'<TR>
				<TH width:400px>CUTOFF TYPE</TH>
				<TH width:110px>DIVISION</TH>
				<TH width:150px>VERSION_NO</TH>
				<TH width:50px>CNT</TH>
				</TR>';
			----------------------------------------------------------------------------------------------------------------      
			--STEP 05_02. 테이블 반복 내용  
			----------------------------------------------------------------------------------------------------------------     	
			SELECT @V_CNT = COUNT(*), @V_I = 0, @V_OWNER = ''
			FROM #TEMP_MAIL_ADDR					
PRINT @v_program_name + ' : A004--' +'Div: ' + @p_division_id +N' /VerNo: ' + @p_version_no + N' /net_pegging_VerNo: ' + @s_Net_Pegging_Version +  ' / ' + CONVERT(NVARCHAR(30), GETDATE(), 121);

   			IF ( SELECT COUNT(*) FROM #TEMP_CUTOFF_INFO ) > 0
			BEGIN
				WHILE ( @V_I < @V_CNT )
				BEGIN
					SELECT @V_OWNER = ADDR
					FROM #TEMP_MAIL_ADDR
					WHERE SEQ = @V_I;

					SET @v_body_cont = '';	-- 본문내용 생성

					DECLARE CUR_SEND CURSOR FAST_FORWARD FOR
					SELECT CUTOFF_TYPE, DIVISION_ID, VERSION_NO, CNT
					FROM #TEMP_CUTOFF_INFO A;						

					OPEN CUR_SEND;
					FETCH NEXT FROM CUR_SEND INTO @C_CUTOFF_TYPE, @C_DIVISION_ID, @C_VERSION_NO, @C_CNT;

					WHILE @@FETCH_STATUS = 0
					BEGIN
						SET @v_body_cont = @v_body_cont+ N'<TR>';
						SET @v_body_cont = @v_body_cont+ N'<TD ALIGN = LEFT >'	+ ISNULL(@C_CUTOFF_TYPE,'') + N'</TD>'	;
						SET @v_body_cont = @v_body_cont+ N'<TD ALIGN = LEFT >'	+ ISNULL(@C_DIVISION_ID,'') + N'</TD>'	;
						SET @v_body_cont = @v_body_cont+ N'<TD ALIGN = LEFT >'	+ ISNULL(@C_VERSION_NO,'') + N'</TD>'	;
						SET @v_body_cont = @v_body_cont+ N'<TD ALIGN = LEFT >'	+ ISNULL(@C_CNT,'') + N'</TD>'	;
						SET @v_body_cont = @v_body_cont+ N'</TR>';				
					FETCH NEXT FROM CUR_SEND INTO @C_CUTOFF_TYPE, @C_DIVISION_ID, @C_VERSION_NO, @C_CNT;
		
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
												+ N'<table style=''border-top:2px solid #c8294b; width:700px;''>
											<thead>' + ISNULL(@v_head_cont,'') + N'</thead>
											<tbody>' + ISNULL(@v_body_cont, '') + N'</tbody>
											</div>
										</body>
									</html>';
				---------------------------------------------------------------------------------------------------------------- 
				--STEP 05-03. Mail 전송  
				---------------------------------------------------------------------------------------------------------------- 	
PRINT @v_program_name + N' : A005--' +'Div: ' + @p_division_id +N' /VerNo: ' + @p_version_no + N' /net_pegging_VerNo: ' + @s_Net_Pegging_Version +  ' / ' + CONVERT(NVARCHAR(30), GETDATE(), 121);
				BEGIN		
					/*
					EXEC SCM_ADM_MAIL_SEND
						'JSSBAE@lgespartner.com'				
						, @v_mail_title
						, @TABLE_BODY
						, 'Y'
					*/
					
					---------------------------------------------------------------------------------------------------------------- 
					--STEP 05-04. 메일은 운영일 경우에만 발송함.
					---------------------------------------------------------------------------------------------------------------- 
					IF DB_NAME() <> 'LGCE_SCMDEV'
					BEGIN 
						IF @V_OWNER != ''
						BEGIN
							EXEC SCM_ADM_MAIL_SEND @V_OWNER, @v_mail_title, @TABLE_BODY, 'Y' 
						END
					END
PRINT @v_program_name
PRINT @V_OWNER
						IF @V_OWNER != ''
						BEGIN
							------------------------------------------------------------------------------------------------------
							--MAIL 발송 LOG 저장
							------------------------------------------------------------------------------------------------------
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
								, @V_OWNER ;
						END
				END

				IF ( @V_I % 5 IN ( 0, 5 ))
				BEGIN  
					WAITFOR DELAY '00:00:30'  
				END

				SET @V_I = @V_I + 1
				END			
			END		
		END			
		
PRINT @v_program_name + ' : A006--' +'Div: ' + @p_division_id +N' /VerNo: ' + @p_version_no + N' /net_pegging_VerNo: ' + @s_Net_Pegging_Version +  ' / ' + CONVERT(NVARCHAR(30), GETDATE(), 121);
	
	END TRY  
   
BEGIN CATCH   
  SET @v_log_type = 'ERROR';  
  SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));  
  SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());  
  SET @d_event_date = SYSDATETIME();      
  SELECT @v_log_message     
  EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;    
END CATCH    
   
----------------------------------------------------------------------------------------------------------------------------------------- 
--종료 LOG (START) 
----------------------------------------------------------------------------------------------------------------------------------------- 
 SET @v_log_type = 'END';  
 SET @v_log_message = '##### END of procedure #####';  
 SET @v_description = N'Weekly Cutoff 완료 후 메일 발송 / Div: ' + @p_division_id +' / Ver: ' + @p_version_no;
 SET @d_event_date = SYSDATETIME();  
 EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;  
----------------------------------------------------------------------------------------------------------------------------------------- 
--종료 LOG (END) 
----------------------------------------------------------------------------------------------------------------------------------------- 
  
END; 
  
