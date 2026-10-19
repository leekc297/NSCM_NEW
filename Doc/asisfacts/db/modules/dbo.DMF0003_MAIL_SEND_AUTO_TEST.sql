

/*************************************************************************************************
* Program ID  : DMF0003_MAIL_SEND_AUTO                                               
* Description : Procedure 작성 가이드                                                             
* Usage       : PR Request 자동 생성할 때 사용
* Parameter   :                                                                                  
* 
*------------------------------------------------------------------------------------------------
* Date        In Charge    Description                                                           
*------------------------------------------------------------------------------------------------
* 2024-01-25   kjj		 신규생성
--EXEC DMF0003_MAIL_SEND_AUTO_TEST 'TYPE_A', 1
--EXEC DMF0003_MAIL_SEND_AUTO_TEST 'TYPE_A', 2
--EXEC DMF0003_MAIL_SEND_AUTO_TEST 'TYPE_B', 1
--EXEC DMF0003_MAIL_SEND_AUTO_TEST 'TYPE_B', 2
--EXEC DMF0003_MAIL_SEND_AUTO_TEST 'TYPE_C', 1
--EXEC DMF0003_MAIL_SEND_AUTO_TEST 'TYPE_C', 2
--EXEC DMF0003_MAIL_SEND_AUTO_TEST 'TYPE_D', 1
--EXEC DMF0003_MAIL_SEND_AUTO_TEST 'TYPE_D', 2
***************************************************************************************************/

CREATE PROCEDURE [dbo].[DMF0003_MAIL_SEND_AUTO_TEST]
	@p_TYPE		NVARCHAR(60)	 -- TYPE_A / TYPE_B / TYPE_C / TYPE_D => 타입에 따라 조회해오는 기간, 쿼리가 다름
	,@SEQ		INT					-- 1 / 2 => 1차, 2차에 따라 기간 다름
AS  
BEGIN

    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
	SET ANSI_WARNINGS ON;
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'DMF0003_MAIL_SEND_AUTO';
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
	EXEC PR_DM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_log_description, @d_event_date, 'SCM_Batch'
	SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/ 


	--BEGIN TRANSACTION
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


	--대상 추출
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

DECLARE @V_QRY NVARCHAR(MAX)

DECLARE @V_DIFF_WEEK NVARCHAR(100)
DECLARE @V_ADD_QRY NVARCHAR(MAX)

IF (@p_TYPE = 'TYPE_A')
BEGIN
	IF (@SEQ = 1)
	BEGIN
		SET @V_DIFF_WEEK = '13'--1차 메일발송 시점
	END
	ELSE
	BEGIN
		SET @V_DIFF_WEEK = '3'--2차 메일발송 시점
	END

	SET @V_ADD_QRY = ' AND INCOTERMS = ''EXW'''--추가조건
END
ELSE IF(@p_TYPE = 'TYPE_B')
BEGIN
	IF (@SEQ = 1)
	BEGIN
		SET @V_DIFF_WEEK = '17'--1차 메일발송 시점
	END
	ELSE
	BEGIN
		SET @V_DIFF_WEEK = '7'--2차 메일발송 시점
	END

	SET @V_ADD_QRY = ' AND (INCOTERMS LIKE ''C%'' OR INCOTERMS LIKE ''F%'') AND MS.COUNTRY = ''KR'''--추가조건
END
ELSE IF(@p_TYPE = 'TYPE_C')
BEGIN
	IF (@SEQ = 1)
	BEGIN
		SET @V_DIFF_WEEK = '17'--1차 메일발송 시점
	END
	ELSE
	BEGIN
		SET @V_DIFF_WEEK = '7'--2차 메일발송 시점
	END

	SET @V_ADD_QRY = ' AND (INCOTERMS LIKE ''D%'' AND MS.COUNTRY = ''JP'') '--추가조건
END
ELSE IF(@p_TYPE = 'TYPE_D')
BEGIN
	IF (@SEQ = 1)
	BEGIN
		SET @V_DIFF_WEEK = '25'--1차 메일발송 시점
	END
	ELSE
	BEGIN
		SET @V_DIFF_WEEK = '15'--2차 메일발송 시점
	END

	SET @V_ADD_QRY = ' AND (INCOTERMS LIKE ''D%'' AND MS.COUNTRY <> ''KR'')'--추가조건
END


SET @V_QRY = N'
;WITH DTTMP AS
(
	SELECT BASIS_START_DATE, BASIS_END_DATE FROM SCM_SYS_CALENDAR_M WITH(NOLOCK)
	WHERE BASIS_YYYYMMDD = CONVERT(VARCHAR, DATEADD(WEEK, ' + @V_DIFF_WEEK + ', GETDATE()), 112)
)
INSERT INTO #TMP_TARGET_LIST
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
WHERE MEASURE = ''MKT_FCST''
AND YYYYMMDD >= (SELECT BASIS_START_DATE FROM DTTMP) 
AND YYYYMMDD <= (SELECT BASIS_END_DATE FROM DTTMP)
AND NOT EXISTS
(
	SELECT * FROM DM_PLN_BNP_IN_PR_DETAIL_AUTO ATO WITH(NOLOCK)
	WHERE ATO.DIVISION_ID = MF.DIVISION_ID
    AND ATO.PROJECT_CODE = MF.PROJECT_CODE
    AND ATO.SCM_SITE_ID = MF.SCM_SITE_ID
    AND ATO.ITEM_ID = MF.ITEM_ID
    AND ATO.DOM_EXP = MF.DOM_EXP
    AND ATO.FCST_TYPE = MF.FCST_TYPE
    AND ATO.INCOTERMS = MF.INCOTERMS
    AND ATO.PLANT_SITE_ID = MF.PLANT_SITE_ID
    AND ATO.MKT_FCST_DATE = MF.YYYYMMDD
)
'
+ @V_ADD_QRY

EXEC(@V_QRY)


IF OBJECT_ID('TEMPDB..#TMP_OWNER_LIST') IS NOT NULL
	DROP TABLE #TMP_OWNER_LIST;

--OWNER 정보 추출
SELECT * 
INTO #TMP_OWNER_LIST
FROM
(
	SELECT PROJECT_OWNER TO_OWNER FROM #TMP_TARGET_LIST
	UNION
	SELECT OWNER  TO_OWNER FROM #TMP_TARGET_LIST
) A


--SELECT * FROM #TMP_TARGET_LIST
--SELECT * FROM #TMP_OWNER_LIST

		----------------------------------------------------------------------------------------------------------------
		-- 메일발송
		----------------------------------------------------------------------------------------------------------------
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
		SET @v_body_contents = N'안녕하십니까, SCM.DM 시스템입니다. 다음주 PR Request 자동수행 대상을 안내드립니다.</BR>
             PR 요청 취소가 필요하다면 SCM 시스템 → Demand > Demand Plan > PR Request Auto 화면에 접속하시어 ''BNP In/PR Request Auto'' 값을 N 으로 수정해주시기 바랍니다. 				
             PR 요청 수정이 필요하다면    
			 1) MKT FCST 입력값을 수정 → 1주 후에 PR Request 자동수행되며                       
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
					 'kjj0070@lgespartner.com'
					 --@CUR_TOMAIL
					, @v_mail_title
					, @TABLE_BODY
					, 'Y'
					*/
					SELECT @v_body_cont
					SELECT @CUR_TOMAIL
					
			CLOSE CUR_TARGET;
			DEALLOCATE CUR_TARGET;	
		

		FETCH NEXT FROM CUR_OWNER INTO @CUR_TOOWNER, @CUR_TOMAIL
		END
		CLOSE CUR_OWNER;
		DEALLOCATE CUR_OWNER;


		----------------------------------------------------------------------------------------------------------------
		--신규테이블에 저장
		----------------------------------------------------------------------------------------------------------------
		INSERT INTO [dbo].[DM_PLN_BNP_IN_PR_DETAIL_AUTO]
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
			 SELECT
			CONVERT(VARCHAR, GETDATE(), 112)
			,[DIVISION_ID]
           ,[PROJECT_CODE]
           ,[SCM_SITE_ID]
           ,[ITEM_ID]
           ,[DOM_EXP]
           ,[FCST_TYPE]
           ,[INCOTERMS]
           ,[PLANT_SITE_ID]
           ,[YYYYMMDD]
           ,[QTY]	
		   ,'SCM_BATCH'		   
		   ,GETDATE()
		   ,'SCM_BATCH'
		   ,GETDATE()
		   FROM #TMP_TARGET_LIST
		
		/*
			INSERT INTO DM_PLN_BNP_IN_PR_DETAIL_AUTO
			([DIVISION_ID]
           ,[PROJECT_CODE]
           ,[SCM_SITE_ID]
           ,[ITEM_ID]
           ,[DOM_EXP]
           ,[FCST_TYPE]
           ,[INCOTERMS]
           ,[MEASURE]
           ,[PLANT_SITE_ID]
           ,[YYYYMMDD]
           ,[QTY]
           ,[MAIL_INFORMATION_DATE]
           ,[CREATED_BY]
           ,[CREATION_DATE]
           ,[LAST_UPDATED_BY]
           ,[LAST_UPDATE_DATE])
		   SELECT 
			[DIVISION_ID]
           ,[PROJECT_CODE]
           ,[SCM_SITE_ID]
           ,[ITEM_ID]
           ,[DOM_EXP]
           ,[FCST_TYPE]
           ,[INCOTERMS]
           ,[MEASURE]
           ,[PLANT_SITE_ID]
           ,[YYYYMMDD]
           ,[QTY]		   
		   ,GETDATE()
		   ,'SCM_BATCH'
		   ,GETDATE()
		   ,'SCM_BATCH'
		   ,GETDATE()
		   FROM #TMP_TARGET_LIST
		   */
		   


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

		EXEC PR_DM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_log_description, @d_event_date, 'SCM_Batch';


	--------------------------------------------------------------	
    END CATCH;
	--------------------------------------------------------------	

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure @@@##########';
    SET @v_log_description = 'input_count: ' + Convert(NVARCHAR(10), @n_input_count) ;
    SET @d_event_date = SYSDATETIME();

    EXEC PR_DM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_log_description, @d_event_date, 'SCM_Batch';


  END;










