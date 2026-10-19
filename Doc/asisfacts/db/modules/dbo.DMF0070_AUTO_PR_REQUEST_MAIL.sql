
/****************************************************************************************************************************
* Program ID  : DMF0070_AUTO_PR_REQUEST_MAIL                                               
* Description : Procedure 작성 가이드                                                             
* Usage       : PR Request 자동 생성 대상 추출하여 메일발송
* Parameter   :                                                                                  
* 
*----------------------------------------------------------------------------------------------------------------------------
* Date			In Charge    Description                                                           
*----------------------------------------------------------------------------------------------------------------------------
* 2024-01-25	kjj			신규생성
* 2024-06-05	JSSBAE		[E20240529-001017]_Auto PR Request 개선요청건
							W1 주차에 Auto PR 데이터 생성 후 BNP In이 생성되지 않은 대상은 W2 주차에 대상이되는 데이터로 Auto PR 목록에 다시 생성 되어야 함 
--EXEC DMF0070_AUTO_PR_REQUEST_MAIL 
****************************************************************************************************************************/

CREATE PROCEDURE [dbo].[DMF0070_AUTO_PR_REQUEST_MAIL]

AS  
BEGIN
/*
--메인테이블 변경
DM_PLN_BNP_IN_PR_DETAIL_AUTO
=>DM_PLN_AUTO_PR_CHECK
*/
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
	SET ANSI_WARNINGS ON;

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'DMF0070_AUTO_PR_REQUEST_MAIL';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_log_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
    DECLARE @n_delete_count    INTEGER = 0;
    DECLARE @n_insert_count INTEGER = 0;
    DECLARE @n_input_count     INTEGER = 0;
    DECLARE @n_logo_count      INTEGER = 0;
	DECLARE @n_Invalid_item		nvarchar(50)
	DECLARE @n_msg			nvarchar(1000)
	DECLARE @V_BF_REQ_NO	NVARCHAR(30)
	DECLARE @V_BF_QTY		INT = 0;
	DECLARE @V_THIS_QTY		INT = 0;

	-- 시작 LOG  (START)
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure @@@##########';
	SET @v_log_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_DM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_log_description, @d_event_date, 'SCM_BATCH'
	SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/ 

	BEGIN TRANSACTION

	--------------------------------------------------------------------------------------------	
	BEGIN TRY
	--------------------------------------------------------------------------------------------
			--메일발송 주기(케이스 별)
			/*
			*1차
		(A) Incoterms= EXW => D-91(13주)
		(B) Incoterms = C* or F*, Country=KR => D-119(17주)
		(C) Incoterms = D*, Country=JP => D-119(17주)
		(D) Incoterms = D*, Country = not KR => D-175(25주)


			*2차
		(A) Incoterms= EXW => D-20 (3주 전)
		(B) Incoterms = C* or F*, Country=KR => D-48 (7주 전)
		(C) Incoterms = D*, Country=JP => D-48 (7주 전)
		(D) Incoterms = D*, Country = not KR => D-104 (15주 전)
			*/

			----------------------------------------------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' ### 메일발송 대상추출 ' 
			----------------------------------------------------------------------------------------------------------------------------------------------------------
				--대상 추출------------------------------------------
			IF OBJECT_ID('TEMPDB..#TMP_TARGET_LIST') IS NOT NULL
				DROP TABLE #TMP_TARGET_LIST;


			CREATE TABLE #TMP_TARGET_LIST(
				COUNTRY			NVARCHAR(100),
				PROJECT_OWNER	NVARCHAR(100),
				OWNER			NVARCHAR(100),
				ITEM_ID			NVARCHAR(100),
				SCM_SITE_ID		NVARCHAR(100),
				PROJECT_CODE	NVARCHAR(100),
				QTY				NUMERIC(30,10),
				YYYYMMDD		NVARCHAR(10),
				DIVISION_ID		NVARCHAR(100),
				DOM_EXP			NVARCHAR(100),	
				FCST_TYPE		NVARCHAR(100),	
				INCOTERMS		NVARCHAR(100),	
				MEASURE			NVARCHAR(100),	
				PLANT_SITE_ID	NVARCHAR(100)
			)


			DECLARE @V_SUB_QRY NVARCHAR(MAX) = ''

				DECLARE   @CUR_DIVISION			NVARCHAR(100)
						, @CUR_INCOTERMS		NVARCHAR(100)
						, @CUR_COUNTRY			NVARCHAR(100)
						, @CUR_BNP_WEEK			NVARCHAR(100)--BNP IN 출하시점
						, @CUR_DATA_WEEK		NVARCHAR(150)--DATA 생성 시점(대상추출 메일발송은 DATA 생성시점의 1주 전)
						, @V_CUR_NOT_COND			NVARCHAR(1000)--NOT 조건으로 지정된 건

				DECLARE CUR_GUIDE_LIST CURSOR FAST_FORWARD FOR
				SELECT SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5
				FROM SCM_ADM_LOOKUP_MASTER_DETAIL 
				WHERE LOOKUP_TYPE = 'AUTO_PR_CHECK_CRITERIA' 
				AND VALID_YN = 'Y'
				ORDER BY DISPLAY_SEQ 

				OPEN CUR_GUIDE_LIST;
				FETCH NEXT FROM CUR_GUIDE_LIST INTO @CUR_DIVISION, @CUR_INCOTERMS, @CUR_COUNTRY, @CUR_BNP_WEEK, @CUR_DATA_WEEK

				WHILE @@FETCH_STATUS = 0
				BEGIN

					IF @V_SUB_QRY <> '' 
					BEGIN
						SET @V_SUB_QRY = @V_SUB_QRY + N'
						UNION
						'
					END

					SET @V_SUB_QRY = @V_SUB_QRY + N'
						SELECT MS.COUNTRY, 
						(
							SELECT TOP 1 PROJECT_OWNER FROM SCM_MST_PROJECT MP WITH(NOLOCK)
							where MP.DIVISION_ID = MF.DIVISION_ID
							and MP.PROJECT_CODE = MF.PROJECT_CODE
						) PROJECT_OWNER,
						(
							SELECT TOP 1 OWNER FROM SCM_MST_SITE_ITEM ITM WITH(NOLOCK)
							WHERE ITM.DIVISION_ID = MF.DIVISION_ID
							AND ITM.PROJECT_CODE = MF.PROJECT_CODE
							AND ITM.SCM_SITE_ID = MF.SCM_SITE_ID
							AND ITM.ITEM_ID = MF.ITEM_ID
						) OWNER
						, MF.ITEM_ID, MF.SCM_SITE_ID, MF.PROJECT_CODE, MF.QTY, MF.YYYYMMDD
						, MF.DIVISION_ID,
						MF.DOM_EXP,	
						MF.FCST_TYPE,	
						MF.INCOTERMS,	
						MF.MEASURE,	
						MF.PLANT_SITE_ID
						FROM DM_PLN_MKT_FCST MF WITH(NOLOCK)
						INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LUP WITH(NOLOCK)
							ON MF.DIVISION_ID = LUP.SEGMENT1
							AND MF.ITEM_ID = LUP.SEGMENT2
							AND LUP.VALID_YN = ''Y''
							AND LUP.LOOKUP_TYPE = ''ESS_PRICE_EXCEPT_MODEL''
						INNER JOIN SCM_MST_SITE MS WITH(NOLOCK)
							ON MF.DIVISION_ID = MS.DIVISION_ID
							AND MF.SCM_SITE_ID = MS.SCM_SITE_ID
						WHERE MF.MEASURE = ''MKT_FCST''
						AND ISNULL(MF.ATTRIBUTE9, '''') = '''' -- 확정되지 않은 것들
						/* [E20240529-001017]_Auto PR Request 개선요청건
						AND NOT EXISTS --메일전송목록에 없는 것들만 발송
						(
							SELECT * FROM DM_PLN_AUTO_PR_CHECK ATO WITH(NOLOCK)
							WHERE ATO.DIVISION_ID = MF.DIVISION_ID
							AND ATO.PROJECT_CODE = MF.PROJECT_CODE
							AND ATO.SCM_SITE_ID = MF.SCM_SITE_ID
							AND ATO.ITEM_ID = MF.ITEM_ID
							AND ATO.DOM_EXP = MF.DOM_EXP
							AND ATO.FCST_TYPE = MF.FCST_TYPE
							AND ATO.INCOTERMS = MF.INCOTERMS
							AND ATO.PLANT_SITE_ID = MF.PLANT_SITE_ID
							AND ATO.MKT_FCST_DATE = MF.YYYYMMDD
							AND ATO.PLAN_QTY = MF.QTY
						) */
						AND MF.QTY > 0 --수량이 0 이상인 것들만
						AND
						(
							(
								MF.YYYYMMDD >= 
								(
										SELECT BASIS_START_DATE FROM SCM_SYS_CALENDAR_M WITH(NOLOCK)
										WHERE BASIS_YYYYMMDD = CONVERT(VARCHAR, DATEADD(WEEK, ' + CONVERT(VARCHAR,@CUR_DATA_WEEK + 1) + ', GETDATE()), 112) --데이터 생성 시점의 1주 전
								)
								AND MF.YYYYMMDD <=
								(
										SELECT BASIS_END_DATE FROM SCM_SYS_CALENDAR_M WITH(NOLOCK)
										WHERE BASIS_YYYYMMDD = CONVERT(VARCHAR, DATEADD(WEEK, ' + CONVERT(VARCHAR,@CUR_DATA_WEEK + 1) + ', GETDATE()), 112)
								)
							) 
							OR
							(
								MF.YYYYMMDD >= 
								(
										SELECT BASIS_START_DATE FROM SCM_SYS_CALENDAR_M WITH(NOLOCK)
										WHERE BASIS_YYYYMMDD = CONVERT(VARCHAR, DATEADD(WEEK, ' + CONVERT(VARCHAR,@CUR_DATA_WEEK + 1 - 10) + ', GETDATE()), 112) --2차발송은 1차의 10주 뒤
								)
								AND MF.YYYYMMDD <=
								(
										SELECT BASIS_END_DATE FROM SCM_SYS_CALENDAR_M WITH(NOLOCK)
										WHERE BASIS_YYYYMMDD = CONVERT(VARCHAR, DATEADD(WEEK, ' + CONVERT(VARCHAR,@CUR_DATA_WEEK + 1) + ', GETDATE()), 112) --To는 1차발송일과 동일
								)
							)
						)

					'
					--INCOTERMS
					IF @CUR_INCOTERMS <> '-'
					BEGIN
						IF CHARINDEX ('*', @CUR_INCOTERMS) > 0
						BEGIN
							SET @V_SUB_QRY = @V_SUB_QRY + N'
								AND MF.INCOTERMS LIKE ''' + REPLACE(@CUR_INCOTERMS,'*', '%') + '''
							'
						END
						ELSE IF CHARINDEX ('NOT_', @CUR_INCOTERMS) > 0
						BEGIN
						/*
						--Not 의 규칙
						1)Not_로 등록
						2)여러개일 경우는 ,로 구분
						*/
							DECLARE CUR_NOT_COND CURSOR FAST_FORWARD FOR
							SELECT TOKEN FROM DBO.UF_FX_STRING_SPLIT(@CUR_INCOTERMS		, ',')

							OPEN CUR_NOT_COND;
							FETCH NEXT FROM CUR_NOT_COND INTO @V_CUR_NOT_COND

							WHILE @@FETCH_STATUS = 0
							BEGIN

								SET @V_SUB_QRY = @V_SUB_QRY + N'
									AND MF.INCOTERMS <> ''' + REPLACE(@V_CUR_NOT_COND,'NOT_', '') + '''
								'

							FETCH NEXT FROM CUR_NOT_COND INTO @V_CUR_NOT_COND
							END

							CLOSE CUR_NOT_COND;
							DEALLOCATE CUR_NOT_COND;

						END
						ELSE
						BEGIN
							SET @V_SUB_QRY = @V_SUB_QRY + N'
								AND MF.INCOTERMS = ''' + @CUR_INCOTERMS + '''
							'
							END
					END

					--COUNTRY
					IF @CUR_COUNTRY <> '-'
					BEGIN
						IF CHARINDEX ('*', @CUR_COUNTRY) > 0
						BEGIN
							SET @V_SUB_QRY = @V_SUB_QRY + N'
								AND MS.COUNTRY LIKE ''' + REPLACE(@CUR_COUNTRY,'*', '%') + '''
							'
						END
						ELSE IF CHARINDEX ('NOT_', @CUR_COUNTRY) > 0
						BEGIN

						/*
							SET @V_SUB_QRY = @V_SUB_QRY + N'
								AND MS.COUNTRY <> ''' + REPLACE(@CUR_COUNTRY,'NOT ', '') + '''
							'
							*/
							/*
							--Not 의 규칙
							1)Not_로 등록
							2)여러개일 경우는 ,로 구분
							*/
							DECLARE CUR_NOT_COND CURSOR FAST_FORWARD FOR
							SELECT TOKEN FROM DBO.UF_FX_STRING_SPLIT(@CUR_COUNTRY		, ',')

							OPEN CUR_NOT_COND;
							FETCH NEXT FROM CUR_NOT_COND INTO @V_CUR_NOT_COND

							WHILE @@FETCH_STATUS = 0
							BEGIN

								SET @V_SUB_QRY = @V_SUB_QRY + N'
									AND MS.COUNTRY <> ''' + REPLACE(@V_CUR_NOT_COND,'NOT_', '') + '''
								'

							FETCH NEXT FROM CUR_NOT_COND INTO @V_CUR_NOT_COND
							END

							CLOSE CUR_NOT_COND;
							DEALLOCATE CUR_NOT_COND;
						END
						ELSE
						BEGIN
						SET @V_SUB_QRY = @V_SUB_QRY + N'
							AND MS.COUNTRY = ''' + @CUR_COUNTRY + '''
						'
						END
					END

			
				FETCH NEXT FROM CUR_GUIDE_LIST INTO @CUR_DIVISION, @CUR_INCOTERMS, @CUR_COUNTRY, @CUR_BNP_WEEK, @CUR_DATA_WEEK
				END

				--PRINT @V_SUB_QRY
				--EXEC (@V_SUB_QRY)

				CLOSE CUR_GUIDE_LIST;
				DEALLOCATE CUR_GUIDE_LIST;


			--PRINT @V_QRY
			INSERT #TMP_TARGET_LIST
			EXEC (@V_SUB_QRY)


			--SELECT * FROM #TMP_TARGET_LIST

			IF OBJECT_ID('TEMPDB..#TMP_OWNER_LIST') IS NOT NULL
				DROP TABLE #TMP_OWNER_LIST;

			--OWNER 정보 추출
			SELECT * 
			INTO #TMP_OWNER_LIST
			FROM
			(
				SELECT PROJECT_OWNER TO_OWNER 
				FROM #TMP_TARGET_LIST
				WHERE ISNULL(PROJECT_OWNER, '') <> ''
				UNION
				SELECT OWNER  TO_OWNER 
				FROM #TMP_TARGET_LIST
				WHERE ISNULL(OWNER, '') <> ''
			) A

			----------------------------------------------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' ### 메일발송'
			----------------------------------------------------------------------------------------------------------------------------------------------------------
			DECLARE @TABLE_BODY			NVARCHAR(MAX)
					, @v_body_contents	NVARCHAR(MAX)
					, @v_head_cont		NVARCHAR(MAX)
					, @v_body_cont		NVARCHAR(MAX)
					--, @v_to_mail		NVARCHAR(150)
					, @v_mail_title		NVARCHAR(100)
					, @v_cnt int
					, @v_i int


			DECLARE   @CUR_MODEL			NVARCHAR(100)
					, @CUR_SITE				NVARCHAR(100)
					, @CUR_PROJECT			NVARCHAR(8)
					, @CUR_QTY				NUMERIC(30,10)
					, @CUR_YYYYMMDD			NVARCHAR(10)
					, @CUR_TOOWNER			NVARCHAR(150)
					, @CUR_TOMAIL			NVARCHAR(150)


			-----------------------------
			SET @v_mail_title = N'[SCM.DM] BNP In & PR Request 자동생성 대상 안내' 
			SET @v_body_contents = N'안녕하십니까, SCM.DM 시스템입니다. 다음주 <B>월요일</B> BNP In과 PR Request 자동수행 대상을 안내드립니다.</BR>
					자동생성을 위해서는 SCM 시스템 → Demand → Demand Plan → Auto PR Check화면에서 <B>Plant Site, SLOC 정보를 이번 주</B> 안에 입력해주셔야 합니다. (공란일 시 생성 X)
					PR 요청 취소가 필요하다면 SCM 시스템 → Demand > Demand Plan > Auto PR Check 화면에 접속하시어 ''BNP In/PR Request Auto'' 값을 <B>N</B> 으로 수정해주시기 바랍니다. 				
					PR 요청 수정이 필요하다면    
					1) MKT FCST 입력값을 수정 → 1주 후에 다시 메일 안내 드리며                       
				2) 긴급 건은 수기로 BNP In 입력 → 수기로 PR Request 진행 부탁드립니다.'					

			SET @v_body_cont = '';
			SET @v_head_cont = N'<TR>
				<TH>Model 코드</TH>
				<TH>Sales Site</TH>
				<TH>Project Code</TH>
				<TH>QTY</TH>
				<TH>YYYYMMDD</TH>
				</TR>'


			DECLARE CUR_OWNER CURSOR FAST_FORWARD FOR
			SELECT	TO_OWNER, TO_OWNER + '@lgensol.com'	FROM #TMP_OWNER_LIST

			--발송할 오너 가져오기
			OPEN CUR_OWNER;
			FETCH NEXT FROM CUR_OWNER INTO @CUR_TOOWNER, @CUR_TOMAIL


			WHILE @@FETCH_STATUS = 0
			BEGIN
				--오너에 맞는 대상 목록 가져오기
				DECLARE CUR_TARGET CURSOR FAST_FORWARD FOR
				SELECT ITEM_ID, SCM_SITE_ID, PROJECT_CODE, QTY, YYYYMMDD FROM #TMP_TARGET_LIST
				WHERE PROJECT_OWNER = @CUR_TOOWNER OR OWNER = @CUR_TOOWNER

				OPEN CUR_TARGET;
				FETCH NEXT FROM CUR_TARGET INTO @CUR_MODEL, @CUR_SITE, @CUR_PROJECT, @CUR_QTY, @CUR_YYYYMMDD

				SET @v_body_cont = ''

				WHILE @@FETCH_STATUS = 0
				BEGIN

					SET @v_body_cont = @v_body_cont+ '<TR>'
					SET @v_body_cont = @v_body_cont+ '<TD>' + ISNULL(@CUR_MODEL,'') + '</TD>'	
					SET @v_body_cont = @v_body_cont+ '<TD>'	+ ISNULL(@CUR_SITE,'') + '</TD>'	
					SET @v_body_cont = @v_body_cont+ '<TD>'	+ ISNULL(@CUR_PROJECT,'') + '</TD>'	
					SET @v_body_cont = @v_body_cont+ '<TD ALIGN="RIGHT">'	+ DBO.FN_GET_NUMER_TO_STRING(@CUR_QTY,0) + '</TD>'	
					SET @v_body_cont = @v_body_cont+ '<TD>'	+ ISNULL(@CUR_YYYYMMDD,'') + '</TD>'	
					SET @v_body_cont = @v_body_cont+ '</TR>'

				FETCH NEXT FROM CUR_TARGET INTO @CUR_MODEL, @CUR_SITE, @CUR_PROJECT, @CUR_QTY, @CUR_YYYYMMDD
				END

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

					/*	
					EXEC SCM_ADM_MAIL_SEND
							'kjj0070@lgespartner.com;park.choyi@lgespartner.com'
							--@CUR_TOMAIL
						, @v_mail_title
						, @TABLE_BODY
						, 'Y'
						*/
						/*
					EXEC SCM_ADM_MAIL_SEND
							'kjj0070@lgespartner.com'
							--@CUR_TOMAIL
						, @v_mail_title
						, @TABLE_BODY
						, 'Y'
						*/
						--SELECT @v_body_cont
						--SELECT @CUR_TOMAIL

		
					IF DB_NAME() <> 'LGCE_SCMDEV'
					BEGIN
						EXEC SCM_ADM_MAIL_SEND
							@CUR_TOMAIL
							, @v_mail_title
							, @TABLE_BODY
							, 'Y'
					END
					
					
				CLOSE CUR_TARGET;
				DEALLOCATE CUR_TARGET;	
		

				FETCH NEXT FROM CUR_OWNER INTO @CUR_TOOWNER, @CUR_TOMAIL
				END
				CLOSE CUR_OWNER;
				DEALLOCATE CUR_OWNER;

			----------------------------------------------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' ### 신규테이블에 저장' 
			----------------------------------------------------------------------------------------------------------------------------------------------------------

			MERGE INTO DM_PLN_AUTO_PR_CHECK AS A
			USING #TMP_TARGET_LIST AS B
			   ON (
						A.DIVISION_ID        =   B.DIVISION_ID      
						AND A.PROJECT_CODE       =   B.PROJECT_CODE   
						AND A.SCM_SITE_ID        =   B.SCM_SITE_ID  
						AND A.ITEM_ID            =   B.ITEM_ID      
						AND A.DOM_EXP            =   B.DOM_EXP      
						AND A.FCST_TYPE          =   B.FCST_TYPE    
						AND A.INCOTERMS          =   B.INCOTERMS    						   				   
						AND A.PLANT_SITE_ID      =   B.PLANT_SITE_ID
						AND A.MKT_FCST_DATE      =   B.YYYYMMDD
						AND A.MAIL_INFO_DATE	= CONVERT(VARCHAR, GETDATE(), 112)
				)
			WHEN MATCHED THEN
				UPDATE SET 
				A.PLAN_QTY = B.QTY
				,A.CREATION_DATE = GETDATE()
				,A.LAST_UPDATE_DATE = GETDATE()
			WHEN NOT MATCHED THEN
			INSERT 
						([MAIL_INFO_DATE]
						,[DIVISION_ID]
						,[PROJECT_CODE]
						,[SCM_SITE_ID]
						,[ITEM_ID]
						,[DOM_EXP]
						,[FCST_TYPE]
						,[INCOTERMS]
						,[PLANT_SITE_ID]
						,[MKT_FCST_DATE]
						,[PLAN_QTY]
						,[CREATED_BY]
						,[CREATION_DATE]
						,[LAST_UPDATED_BY]
						,[LAST_UPDATE_DATE]
					)
				VALUES
				(
					CONVERT(VARCHAR, GETDATE(), 112)
					,B.DIVISION_ID
					,B.PROJECT_CODE
					,B.SCM_SITE_ID
					,B.ITEM_ID
					,B.DOM_EXP
					,B.FCST_TYPE
					,B.INCOTERMS
					,B.PLANT_SITE_ID
					,B.YYYYMMDD
					,B.QTY
					,'SCM_BATCH'		   
					,GETDATE()
					,'SCM_BATCH'
					,GETDATE()
				);
	
		IF XACT_STATE() > 0 and @@trancount > 0
		BEGIN
			COMMIT TRAN 
		END
	------------------------------------------------------------------------------------------	
	END TRY
	--------------------------------------------------------------------------------------------	

	--------------------------------------------------------------	
    BEGIN CATCH
	--------------------------------------------------------------	
		-- 트랜잭션 (END)
		--select XACT_STATE() as xact_state_1, @@trancount 
		--select XACT_STATE() as xact_state_2, @@trancount, 'A21'
		IF @@trancount > 0
		BEGIN 
			ROLLBACK TRAN
		END
		
		SET @v_log_type = 'ERROR';
		SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
		SET @v_log_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
		SET @d_event_date = SYSDATETIME();

		SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE() AS ERR_MSG;  /*-- 에러메시지 DISPLAY --*/

		EXEC PR_DM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_log_description, @d_event_date, 'SCM_BATCH';


	--------------------------------------------------------------	
    END CATCH;
	--------------------------------------------------------------	

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure @@@##########';
    SET @v_log_description = 'input_count: ' + Convert(NVARCHAR(10), @n_input_count) ;
    SET @d_event_date = SYSDATETIME();

    EXEC PR_DM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_log_description, @d_event_date, 'SCM_BATCH';

END










