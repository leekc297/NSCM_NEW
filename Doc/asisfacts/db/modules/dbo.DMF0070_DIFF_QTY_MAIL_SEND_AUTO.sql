

/*************************************************************************************************
* Program ID  : DMF0003_DIFF_QTY_MAIL_SEND_AUTO                                               
* Description : Procedure 작성 가이드                                                             
* Usage       : PR Request가 확정된 후에 MKT FCST 데이터가 변경되면(수정 or 삭제), 외주관리팀 담당자에게 자동메일 발송 (실시간 or 일 단위)
* Parameter   :                                                                                  
* 
*------------------------------------------------------------------------------------------------
* Date        In Charge    Description                                                           
*------------------------------------------------------------------------------------------------
* 2024-01-26   kjj		 신규생성
--EXEC DMF0070_DIFF_QTY_MAIL_SEND_AUTO
***************************************************************************************************/

CREATE PROCEDURE [dbo].[DMF0070_DIFF_QTY_MAIL_SEND_AUTO]

AS  
BEGIN

    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
	SET ANSI_WARNINGS ON;
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'DMF0070_DIFF_QTY_MAIL_SEND_AUTO';
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


		IF OBJECT_ID('TEMPDB..#TMP_DIFF_QTY_LIST') IS NOT NULL
			DROP TABLE #TMP_DIFF_QTY_LIST;

		--대상 추출

		SELECT 
		MF.DIVISION_ID
		,MF.ITEM_ID
		,MF.SCM_SITE_ID
		,MF.PROJECT_CODE
		,(
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
		,MSND.PLAN_QTY BEFORE_QTY
		,MF.QTY AFTER_QTY
		,MF.YYYYMMDD
		INTO #TMP_DIFF_QTY_LIST
		FROM DM_PLN_MKT_FCST MF WITH(NOLOCK)
		INNER JOIN DM_PLN_AUTO_PR_CHECK MSND WITH(NOLOCK)
			ON MSND.DIVISION_ID = MF.DIVISION_ID
			AND MSND.PROJECT_CODE = MF.PROJECT_CODE
			AND MSND.SCM_SITE_ID = MF.SCM_SITE_ID
			AND MSND.ITEM_ID = MF.ITEM_ID
			AND MSND.DOM_EXP = MF.DOM_EXP
			AND MSND.FCST_TYPE = MF.FCST_TYPE
			AND MSND.INCOTERMS = MF.INCOTERMS
			AND MSND.PLANT_SITE_ID = MF.PLANT_SITE_ID
			AND MSND.MKT_FCST_DATE = MF.YYYYMMDD
			AND MSND.AUTO_FLAG = 'Y'
		WHERE MF.MEASURE = 'MKT_FCST'
		AND ISNULL(MF.ATTRIBUTE9, '') <> '' -- 확정된 것들
		AND MF.LAST_UPDATE_DATE >= DATEADD(HOUR, -12, GETDATE()) --12시간 이전에 데이터가 변경된 것들
		AND MF.YYYYMMDD > CONVERT(VARCHAR(8), GETDATE(), 112) --d-DAY가 도래하지 않은 것들 
		AND MF.QTY <> MSND.PLAN_QTY --수량이 다른것들
		--삭제가 된 경우는?


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
				, @CUR_PJTOWNER			NVARCHAR(150)
				, @CUR_OWNER			NVARCHAR(150)
				, @CUR_BEFORE_QTY		NUMERIC(30,10)
				, @CUR_AFTER_QTY		NUMERIC(30,10)
				, @CUR_YYYYMMDD			NVARCHAR(10)
				, @V_CUR_DIV			NVARCHAR(100)
				, @V_CUR_ADDR			NVARCHAR(100)

		--DIVISION 별로 처리하기 위해 타겟의 DIVISION을 가져온다
		IF OBJECT_ID('TEMPDB..#TMP_DIV_LIST') IS NOT NULL
			DROP TABLE #TMP_DIV_LIST;

		SELECT DISTINCT DIVISION_ID
		INTO #TMP_DIV_LIST
		FROM #TMP_DIFF_QTY_LIST

		-----------------------------
		SET @v_mail_title = N'[SCM.DM] PR 확정 후 MKT FCST 데이터 변경' 
		SET @v_body_contents = N'안녕하십니까, SCM.DM 시스템입니다. PR Request확정 후에 MKT FCST 데이터가 변경된 건을 공유드립니다.
             데이터 수정 사유에 관해서는 마케팅/PM담당자와 확인 부탁드립니다..'					

		SET @v_body_cont = '';
		SET @v_head_cont = N'<TR>
			<TH>Model 코드</TH>
			<TH>Sales Site</TH>
			<TH>Project Code</TH>
			<TH>Project Owner</TH>
			<TH>Owner</TH>
			<TH>QTY(수정전)</TH>
			<TH>QTY(수정후)</TH>
			<TH>YYYYMMDD</TH>
			</TR>'

		DECLARE CUR_DIV_LIST CURSOR FAST_FORWARD FOR
		SELECT	DIVISION_ID	FROM #TMP_DIV_LIST

		OPEN CUR_DIV_LIST;
		FETCH NEXT FROM CUR_DIV_LIST INTO @V_CUR_DIV

		WHILE @@FETCH_STATUS = 0
		BEGIN
			--DIV에 맞는 목록 가져와 메일 BODY 만들기
			DECLARE CUR_DIFF_QTY_LIST CURSOR FAST_FORWARD FOR
			SELECT 
				ITEM_ID
				,SCM_SITE_ID
				,PROJECT_CODE
				,PROJECT_OWNER
				,OWNER
				,BEFORE_QTY
				,AFTER_QTY
				,YYYYMMDD			
			FROM #TMP_DIFF_QTY_LIST
			WHERE DIVISION_ID = @V_CUR_DIV

			OPEN CUR_DIFF_QTY_LIST;
			FETCH NEXT FROM CUR_DIFF_QTY_LIST INTO @CUR_MODEL, @CUR_SITE, @CUR_PROJECT, @CUR_PJTOWNER, @CUR_OWNER, @CUR_BEFORE_QTY, @CUR_AFTER_QTY, @CUR_YYYYMMDD

			SET @v_body_cont = '';
			WHILE @@FETCH_STATUS = 0
			BEGIN

					SET @v_body_cont = @v_body_cont+ '<TR>'
					SET @v_body_cont = @v_body_cont+ '<TD>' + ISNULL(@CUR_MODEL,'') + '</TD>'	
					SET @v_body_cont = @v_body_cont+ '<TD>'	+ ISNULL(@CUR_SITE,'') + '</TD>'	
					SET @v_body_cont = @v_body_cont+ '<TD>'	+ ISNULL(@CUR_PROJECT,'') + '</TD>'	
					SET @v_body_cont = @v_body_cont+ '<TD>'	+ ISNULL(@CUR_PJTOWNER,'') + '</TD>'	
					SET @v_body_cont = @v_body_cont+ '<TD>'	+ ISNULL(@CUR_OWNER,'') + '</TD>'	
					SET @v_body_cont = @v_body_cont+ '<TD ALIGN="RIGHT">'	+ DBO.FN_GET_NUMER_TO_STRING(@CUR_BEFORE_QTY,0) + '</TD>'	
					SET @v_body_cont = @v_body_cont+ '<TD ALIGN="RIGHT">'	+ DBO.FN_GET_NUMER_TO_STRING(@CUR_AFTER_QTY,0) + '</TD>'	
					SET @v_body_cont = @v_body_cont+ '<TD>'	+ ISNULL(@CUR_YYYYMMDD,'') + '</TD>'	
					SET @v_body_cont = @v_body_cont+ '</TR>'		
			FETCH NEXT FROM CUR_DIFF_QTY_LIST INTO @CUR_MODEL, @CUR_SITE, @CUR_PROJECT, @CUR_PJTOWNER, @CUR_OWNER, @CUR_BEFORE_QTY, @CUR_AFTER_QTY, @CUR_YYYYMMDD
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

			--SELECT @v_body_cont
			/*
			EXEC SCM_ADM_MAIL_SEND
					'kjj0070@lgespartner.com;park.choyi@lgespartner.com'
				, @v_mail_title
				, @TABLE_BODY
				, 'Y'
				*/

	--메일 전송은 지정된 두명에게 전송
	--ID: harrylee(이형훈 사원) , jjkim1129(김재준 책임)
			/*IF DB_NAME() <> 'LGCE_SCMDEV'
			BEGIN
				EXEC SCM_ADM_MAIL_SEND
						'harrylee@lgensol.com'
					, @v_mail_title
					, @TABLE_BODY
					, 'Y'

				EXEC SCM_ADM_MAIL_SEND
						'jjkim1129@lgensol.com'
					, @v_mail_title
					, @TABLE_BODY
					, 'Y'
				
			END
			*/


			CLOSE CUR_DIFF_QTY_LIST;
			DEALLOCATE CUR_DIFF_QTY_LIST;


			----DIV에 맞는 룩업 등록 주소로 메일발송
			DECLARE CUR_PR_CHECK CURSOR FAST_FORWARD FOR		
			SELECT SEGMENT2
			FROM SCM_ADM_LOOKUP_MASTER_DETAIL 
			WHERE LOOKUP_TYPE = 'AUTO_PR_CHECK_CHANGE_MAIL' 
			AND VALID_YN = 'Y'
			AND SEGMENT1 = @V_CUR_DIV

			OPEN CUR_PR_CHECK;
			FETCH NEXT FROM CUR_PR_CHECK INTO @V_CUR_ADDR

			WHILE @@FETCH_STATUS = 0
			BEGIN

				IF DB_NAME() <> 'LGCE_SCMDEV'
				BEGIN
					EXEC SCM_ADM_MAIL_SEND
						@V_CUR_ADDR
						, @v_mail_title
						, @TABLE_BODY
						, 'Y'
				END

			FETCH NEXT FROM CUR_PR_CHECK INTO @V_CUR_ADDR
			END
			CLOSE CUR_PR_CHECK;
			DEALLOCATE CUR_PR_CHECK;

		FETCH NEXT FROM CUR_DIV_LIST INTO @V_CUR_DIV
		END

		CLOSE CUR_DIV_LIST;
		DEALLOCATE CUR_DIV_LIST;

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










