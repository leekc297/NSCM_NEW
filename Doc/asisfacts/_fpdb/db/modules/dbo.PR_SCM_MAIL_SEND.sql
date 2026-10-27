CREATE PROCEDURE [dbo].[PR_SCM_MAIL_SEND]

-- ================================================================================================
-- Program ID          : FP02723
-- Program Name        : PR_SCM_MAIL_SEND
-- Param               :
-- Batch Period        : realtime
-- Description         :
--
-- Source System       : 
-- Destination System  : 
-- Source Table        : SCM_MAILING_H
-- Destination Table   : 
--
-- Create Date		   : 2017.02.14
-- Update Date		   : 2017.05.30 PIYONG 1.2
--						 2018.07.30 PIYONG 1.3
--						 2018.09.03 PIYONG 1.4
--						 2019.01.11 PIYONG 1.5
--						 2019.09.25 PIYONG 1.6
--                       2020.02.26 kimcd  1.7
--                       2020.02.28 kimcd  1.8
--						 2020.03.11 PIYONG 1.9
--                       2020.04.10 kimcd  1.91
--						 2020.04.20 PIYONG 1.10
--						 2020.05.13 PIYONG 1.11
--                       2020.08.18 kimcd  1.12
--                       2021.01.29 kimcd  1.13
--                       2021.10.29 kimcd  1.14
--                       2022.01.07 kimcd  1.15
--                       2022.03.29 kimcd  1.16
--                       2022.04.30 kimcd  1.17

-- Author              : 
-- Version             : 1.1	Initial Creation
--					   : 1.2	SMS 송신 로직 추가
--						 1.3	SMS 대상 메일KEY,  문구 수정
--						 1.4	남경 SMS 발송 로직 추가 
--						 1.5    메일 송신 로직에 ACTIVE_FLAG  추가
--						 1.6   I/F 또는 엔진 수행 오류시 문자 발송 로직 추가  
--                       1.7    2020-02-26 kimcd 
--                              FP_MAILING_IF15	계획 전송 지연
--                              FP_MAILING_IF21	활성화 당일 재고 와 전일 재고 비교
--                              FP_MAILING_IF22	MES Snapshot 수신 지연
--                              FP_MAILING_IF23	ERP,OWMS,포장대기 재고 수신 요청 전일 대비 20% 이상 차이 발생
--                              FP_MAILING_IF24	SCP 생산 Target 수신 지연
--                              FP_MAILING_IF25	DW 특성 실적 미수신
--                              SMS 대상 추가
--                       1.8    2020-02-28 kimcd MES 수신 대상 추가
--						 1.9	OWMS, 포장대기 생성 누락 SMS 수신 대상 추가
--                       1.91   kimcd FP_MAILING_IF25 조건 누락, FP_MAILING_IF18 활성화 재고 SMS 전송 오류 수정
--						 1.10	FP_MAILING_IF17 - ENGINE 장기 대기 후 강제 종료 대상 추가
--						 1.11	문자 발송 A9 동 제외 로직 추가
--                       1.12   2020-08-18 kimcd FP_MAILING_IF23 ERP, OWMS, Cell Packing 미형성 검증 추가
--                       1.13   2021-01-29 kimcd 예외 동 검증. 장기 수행 메시지 개선, Plan, SSP, ERP 재고 검증 과정 추가, Release 지연 조회
--                       1.14   2021-10-29 kimcd Release 지연에서 release plan id NULL 처리
--                       1.15   2022-01-07 kimcd 활성화 MES 실적 수신 점검 문장 수정
--                       1.16   2022-03-29 kimcd JV 가상 Division 로직 적용
--                       1.17   2022-04-30 kimcd Tomcat 정상 Check 로직 추가
--                       1.18   2022-05-17 kimcd FP_MAILING_IF19 항목에 비정상 동 제외 로직 추가
--                       1.19   2022-05-23 kimcd Ultium Cells SCP Target 수신 항목 추가
--                       1.20   2022-08-18 kimcd FP_MAILING_IF20 활성화 실적 미입수 확인 추가
--                       1.21   2024-01-02 kimcd ISNULL(SLV.ATTRIBUTE2, 'N')  != 'Y' 조건 추가
--                       1.22   2025-07-30 OHIJ  [IT20250117A] 하드코딩 변경
-- ================================================================================================

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_SCM_MAIL_SEND'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	   = 0
	DECLARE @sysdate     DATETIME      = GETDATE()

	DECLARE @ROWCOUNT    INTEGER

	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)

	-- ================================================
    -- Declare start
	-- ================================================
	DECLARE @MAIL_PKEY             NVARCHAR(100)
	DECLARE @MAIL_SEQ              numeric
	DECLARE @MAIL_SUBJECT          NVARCHAR(1000)
	DECLARE @MAIL_SUBJECT2         NVARCHAR(1000)
	DECLARE @MAIL_BODY             NVARCHAR(4000)
	DECLARE @MAIL_QUERY            NVARCHAR(4000)
	DECLARE @ATTACH_FILE_NAME      NVARCHAR(4000)
	DECLARE @MAIL_RECEIVER_LIST    NVARCHAR(4000)                               
	DECLARE @MAIL_PROFILE_NAME     NVARCHAR(100)
	DECLARE @MAIL_SEND_FLAG        NVARCHAR(1)
	DECLARE @MAIL_QUERY2           NVARCHAR(4000)
	DECLARE @RtnCode               INT


	DECLARE @PHONE_NUM			NVARCHAR(30)	 --SMS 송신위한 전화 번호 2017.05.30  PIYONG 1.2
	DECLARE @SITE_ID			NVARCHAR(30)	 --SMS 송신위한 지역 코드 2017.05.30  PIYONG 1.3
	DECLARE @PROC_NAME			NVARCHAR(80)	 -- I/F 또는 ENGINE 수행 중 오류 JOB 2019.09.25 PIYONG 1.4
	DECLARE @SEND_TYPE			NVARCHAR(10)	 -- I/F 또는 ENGINE 수행 중 오류 JOB 2019.09.25 PIYONG 1.4
	DECLARE @TIME_GAP			NVARCHAR(10)	 -- 2021-01-29 kimcd 작업 경과 시간
	DECLARE @MSG			    NVARCHAR(20)	 -- 2021-01-29 kimcd 부가 메시지



	-- 중복되는 BOM 체크
	DECLARE @BOM_CNT		   INT = 0;


	DECLARE CUR_MAILING_LIST CURSOR FOR
		select [MAIL_PKEY]
		      ,[MAIL_SEQ]
		      ,[MAIL_SUBJECT]
		      ,[MAIL_BODY]
		      ,[MAIL_QUERY]
		      ,[ATTACH_FILE_NAME]
		      ,[MAIL_RECEIVER_LIST]
		      ,[MAIL_PROFILE_NAME]
		      ,[MAIL_SEND_FLAG]
		  from [dbo].[SCM_MAILING_H]
		 where MAIL_SEND_FLAG = 'P'
		;

	SET @ROWCOUNT = @@ROWCOUNT

	--1.22 [IT20250117A] 하드코딩 변경START
	DECLARE @PLANT_ID_NJ01		NVARCHAR(50)
	DECLARE @COMPANY_ID_NB		NVARCHAR(50)
	DECLARE @COMPANY_ID_GM		NVARCHAR(50)
	DECLARE @PLANT_ID_GM00		NVARCHAR(50)
	DECLARE @PLANT_ID_GM01		NVARCHAR(50)

	SELECT @PLANT_ID_NJ01   = (SELECT TOP 1 SEGMENT2 FROM SCM_CODE_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE = 'PR_SCM_MAIL_SEND' AND SEGMENT1 = '0' AND ACTIVE_FLAG = 'Y') --G182
	SELECT @COMPANY_ID_NB	= (SELECT TOP 1 SEGMENT2 FROM SCM_CODE_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE = 'PR_SCM_MAIL_SEND' AND SEGMENT1 = 'EXP_COMPANY_ID' AND ACTIVE_FLAG = 'Y') --G630
	SELECT @COMPANY_ID_GM	= (SELECT TOP 1 SEGMENT2 FROM SCM_CODE_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE = 'PR_SCM_MAIL_SEND' AND SEGMENT1 = 'EXP_COMPANY_ID2' AND ACTIVE_FLAG = 'Y') --G670
	SELECT @PLANT_ID_GM00	= (SELECT TOP 1 SEGMENT2 FROM SCM_CODE_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE = 'PR_SCM_MAIL_SEND' AND SEGMENT1 = '2' AND ACTIVE_FLAG = 'Y') --G671
	SELECT @PLANT_ID_GM01	= (SELECT TOP 1 SEGMENT2 FROM SCM_CODE_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE = 'PR_SCM_MAIL_SEND' AND SEGMENT1 = '3' AND ACTIVE_FLAG = 'Y') --G673
	--1.22 [IT20250117A] 하드코딩 변경END

	-- ================================================
    -- Declare end
	-- ================================================

	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

	BEGIN TRY				

		BEGIN TRAN
		-- ================================================
		-- 로직 추가 start
		-- ================================================
		
		 UPDATE [dbo].[SCM_MAILING_H]
			SET MAIL_SEND_FLAG = 'P'
		  WHERE MAIL_SEND_FLAG = 'N'
         ;
     
		  -- SITE 정보 추가
		  OPEN CUR_MAILING_LIST;
		  FETCH NEXT FROM CUR_MAILING_LIST INTO  @MAIL_PKEY
												,@MAIL_SEQ
												,@MAIL_SUBJECT
												,@MAIL_BODY
												,@MAIL_QUERY
												,@ATTACH_FILE_NAME
												,@MAIL_RECEIVER_LIST
												,@MAIL_PROFILE_NAME
												,@MAIL_SEND_FLAG
										  ;
		  WHILE (@@FETCH_STATUS = 0)
		  BEGIN
				
				SET @MAIL_QUERY2 = 'print ''sep=;'' '+ISNULL(@MAIL_QUERY,'')
				;
			--	SET @MAIL_SUBJECT2 = '[LIVE] '+ISNULL(@MAIL_SUBJECT,'')
			  	SET @MAIL_SUBJECT2 = ISNULL(@MAIL_SUBJECT,'')

				BEGIN TRY
				        begin

						IF @MAIL_QUERY IS NOT NULL
							begin
							exec @RtnCode =  msdb.dbo.sp_send_dbmail
							  @profile_name           = @MAIL_PROFILE_NAME
							, @recipients             = @MAIL_RECEIVER_LIST
							, @query_result_separator = ';'
							, @query                  = @MAIL_QUERY2
							, @subject                = @MAIL_SUBJECT2
							, @body                   = @MAIL_BODY
							, @body_format            = 'html' 
							, @attach_query_result_as_file = 1
							, @exclude_query_output   = 1
							, @query_result_no_padding= 1
							, @query_result_header    = 1
							, @query_attachment_filename = @ATTACH_FILE_NAME
							; 
							end
                        ELSE
							begin
							exec @RtnCode =  msdb.dbo.sp_send_dbmail
							  @profile_name           = @MAIL_PROFILE_NAME
							, @recipients             = @MAIL_RECEIVER_LIST
							, @subject                = @MAIL_SUBJECT2
							, @body                   = @MAIL_BODY
							; 
							end


						end

						IF  @RtnCode = 0 
						    BEGIN
								UPDATE [dbo].[SCM_MAILING_H]
								SET [MAIL_DATETIME]    = getdate()
									,[MAIL_SEND_FLAG]  = 'Y'
									,[MESSAGE]         = 'SUCCESS'
									,[MODIFY_USER_ID]  = @v_proc_name
									,[MODIFY_DATE]     = getdate()
								WHERE [MAIL_PKEY]       = @MAIL_PKEY
								AND [MAIL_SEQ]        = @MAIL_SEQ

								IF @MAIL_PKEY IN ( 'ELECTRODE_EXFACTORY40', 'ELECTRODE_EXFACTORY81', 'ELECTRODE_EXFACTORY82', 'ELECTRODE_EXFACTORYEE'
												   , 'FP_MAILING_IF8'
												   , 'RCCP_PROD40', 'RCCP_PROD81', 'RCCP_PROD82', 'RCCP_PRODEE'
												   , 'SCP_PROD40', 'SCP_PROD81', 'SCP_PROD81_UC', 'SCP_PROD82', 'SCP_PRODEE', 'SCP_PRODEE_UC'  -- 2022-05-23 kimcd Ultium Cells SCP Target 수신 항목 추가
												   , 'RCCP_SALES40', 'RCCP_SALES81', 'RCCP_SALES82', 'RCCP_SALESEE'
												   , 'SCP_SALES40', 'SCP_SALES81', 'SCP_SALES82', 'SCP_SALESEE'
												   , 'SSP_SALES40', 'SSP_SALES81', 'SSP_SALES82', 'SSP_SALESEE'
												 )
									BEGIN
										--2017.05.30  PIYONG 1.2
										DECLARE CUR_SMS CURSOR FOR
											SELECT ATTRIBUTE1 AS PN, ATTRIBUTE2 AS SITE_ID
											  FROM [DBO].[SCM_SYS_LOOKUP_VALUE] WITH(NOLOCK)
											 WHERE LOOKUP_TYPE_CODE = 'SMS_ADDRESSEE'
											   AND SEGMENT1 =  @MAIL_PKEY
											   AND ACTIVE_FLAG = 'Y'	--2019-01-11 PIYONG ADD
										;

										OPEN CUR_SMS;
										FETCH NEXT FROM CUR_SMS INTO @PHONE_NUM
																	 ,@SITE_ID
										;

										WHILE (@@FETCH_STATUS = 0)
											BEGIN

												IF @SITE_ID = 'A002'
													BEGIN

														INSERT INTO SY_XIF_IFS_SMS_NJ_DATA (
															  [IF_TYPE]
															   ,[IF_ID]
															   ,[IF_INS_DATE]
															   ,[IF_FLAG]
															   ,[IF_SND_DATE]
															   ,[INTIME]
															   ,[USERCODE]
															   ,[REQTIME]
															   ,[REQNAME]
															   ,[REQPHONE]
															   ,[CALLNAME]
															   ,[COUNTRY]
															   ,[CALLPHONE]
															   ,[SUBJECT]
															   ,[MSG]
															   ,[SMS_TYPE]
															   ,[KIND]
														  ) VALUES (
															  'S'
															   ,'OFP0_CSPC_SMS_NJ'
															   ,GETDATE()
															   ,'N'
															   ,GETDATE()
															   ,CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112) + REPLACE(CONVERT(CHAR(8), CURRENT_TIMESTAMP, 108),':','')
															   ,'PIYONG'
															   ,CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112) + REPLACE(CONVERT(CHAR(8), CURRENT_TIMESTAMP, 108),':','')
															   ,'PIYONG'
															   ,@PHONE_NUM
															   ,NULL --CALLNAME
															   ,'86'
															   ,@PHONE_NUM
															   ,'TARGET is newly received.'
															   , CASE WHEN @MAIL_PKEY = 'ELECTRODE_EXFACTORY40'THEN
																	  N'[FP-LIVE] Small Battery ELECTRODE SHIPPING TARGET is newly received.'
																   WHEN @MAIL_PKEY = 'ELECTRODE_EXFACTORY81'THEN
																	  N'[FP-LIVE] Automotive Battery ELECTRODE SHIPPING TARGET is newly received.'
																   WHEN @MAIL_PKEY = 'ELECTRODE_EXFACTORY82'THEN
																	  N'[FP-LIVE] Advanced Battery ESS ELECTRODE SHIPPING TARGET is newly received.'
   																   WHEN @MAIL_PKEY = 'ELECTRODE_EXFACTORYEE'THEN
																	  N'[FP-LIVE] ELECTRODE SHIPPING TARGET is newly received.'


																   WHEN @MAIL_PKEY = 'RCCP_PROD40'THEN
																	  N'[FP-LIVE] RCCP Small Battery PROD TARGET is newly received.'
																   WHEN @MAIL_PKEY = 'RCCP_PROD81'THEN
																	  N'[FP-LIVE] RCCP Automotive Battery PROD TARGET is newly received.'
																   WHEN @MAIL_PKEY = 'RCCP_PROD82'THEN
																	  N'[FP-LIVE] RCCP Advanced Battery ESS PROD TARGET is newly received.'
																   WHEN @MAIL_PKEY = 'RCCP_PRODEE'THEN
																	  N'[FP-LIVE] RCCP ELECTRODE PROD TARGET is newly received.'
														   
																   WHEN @MAIL_PKEY = 'SCP_PROD40'THEN
																	  N'[FP-LIVE] SCP Small Battery PROD TARGET is newly received.'
																   WHEN @MAIL_PKEY = 'SCP_PROD81'THEN
																	  N'[FP-LIVE] SCP Automotive Battery PROD TARGET is newly received.'
																   WHEN @MAIL_PKEY = 'SCP_PROD81_UC'THEN -- 2022-05-23 kimcd Ultium Cells SCP Target 수신 항목 추가
																	  N'[FP-LIVE] SCP Ultium Cells PROD TARGET is newly received.'
																   WHEN @MAIL_PKEY = 'SCP_PROD82'THEN
																	  N'[FP-LIVE] SCP Advanced Battery ESS PROD TARGET is newly received.'
																   WHEN @MAIL_PKEY = 'SCP_PRODEE'THEN
																	  N'[FP-LIVE] SCP ELECTRODE PROD TARGET is newly received.'
																   WHEN @MAIL_PKEY = 'SCP_PRODEE_UC'THEN -- 2022-05-23 kimcd Ultium Cells SCP Target 수신 항목 추가
																	  N'[FP-LIVE] SCP Ultium Cells ELECTRODE PROD TARGET is newly received.'
																   WHEN @MAIL_PKEY = 'RCCP_SALES40' THEN
																	  N'[FP-LIVE] RCCP Small Battery SHIPPING TARGET is newly received.'
																   WHEN @MAIL_PKEY = 'RCCP_SALES81' THEN
																	  N'[FP-LIVE] RCCP Automotive Battery SHIPPING TARGET is newly received.'
																   WHEN @MAIL_PKEY = 'RCCP_SALES82' THEN
																	  N'[FP-LIVE] RCCP Advanced Battery ESS SHIPPING TARGET is newly received.'
																   WHEN @MAIL_PKEY = 'RCCP_SALESEE' THEN
																	  N'[FP-LIVE] RCCP ELECTRODE SHIPPING TARGET is newly received.'

																   WHEN @MAIL_PKEY = 'SCP_SALES40' THEN
																	  N'[FP-LIVE] SCP Small Battery SHIPPING TARGET is newly received.'
																   WHEN @MAIL_PKEY = 'SCP_SALES81' THEN
																	  N'[FP-LIVE] SCP Automotive Battery SHIPPING TARGET is newly received.'
																   WHEN @MAIL_PKEY = 'SCP_SALES82' THEN
																	  N'[FP-LIVE] SCP Advanced Battery ESS SHIPPING TARGET is newly received.'
																   WHEN @MAIL_PKEY = 'SCP_SALESEE' THEN
																	  N'[FP-LIVE] SCP ELECTRODE SHIPPING TARGET is newly received.'

																   WHEN @MAIL_PKEY = 'SSP_SALES40' THEN
																	  N'[FP-LIVE] SSP Small Battery SHIPPING TARGET is newly received.'
																   WHEN @MAIL_PKEY = 'SSP_SALES81' THEN
																	  N'[FP-LIVE] SSP Automotive Battery SHIPPING TARGET is newly received.'
																   WHEN @MAIL_PKEY = 'SSP_SALES82' THEN
																	  N'[FP-LIVE] SSP Advanced Battery ESS SHIPPING TARGET is newly received.'
																   WHEN @MAIL_PKEY = 'SSP_SALESEE' THEN
																	  N'[FP-LIVE] SSP ELECTRODE SHIPPING TARGET is newly received.'
																	END
															   ,'FP'
															   ,'I'
														   )
													END
												ELSE
													BEGIN

														INSERT INTO [SY_XIF_IFS_SMS_DATA] (
															[IF_TYPE]
															,[IF_ID]
															,[IF_INS_DATE]
															,[IF_FLAG]
															,[IF_SND_DATE]
															,[TR_SENDSTAT]
															,[TR_MSGTYPE]
															,[TR_PHONE]
															,[TR_CALLBACK]
															,[TR_MSG]
														) VALUES (
															'S'
															,'OFP0_OSMS_SMS'
															,GETDATE()
															,'N'
															,NULL
															,'0'
															,'0'
															,@PHONE_NUM
															,@PHONE_NUM
															, CASE WHEN @MAIL_PKEY = 'ELECTRODE_EXFACTORY40'THEN
																	  N'[FP-LIVE] Small Battery ELECTRODE SHIPPING TARGET is newly received.'
																   WHEN @MAIL_PKEY = 'ELECTRODE_EXFACTORY81'THEN
																	  N'[FP-LIVE] Automotive Battery ELECTRODE SHIPPING TARGET is newly received.'
																   WHEN @MAIL_PKEY = 'ELECTRODE_EXFACTORY82'THEN
																	  N'[FP-LIVE] Advanced Battery ESS ELECTRODE SHIPPING TARGET is newly received.'
																   WHEN @MAIL_PKEY = 'ELECTRODE_EXFACTORYEE'THEN
																	  N'[FP-LIVE] ELECTRODE SHIPPING TARGET is newly received.'
																   WHEN @MAIL_PKEY = 'FP_MAILING_IF8'THEN
																	  N'[FP-LIVE] 장기수행중인 PLAN이 있습니다.'
																   WHEN @MAIL_PKEY = 'RCCP_PROD40'THEN
																	  N'[FP-LIVE] RCCP Small Battery PROD TARGET is newly received.'
																   WHEN @MAIL_PKEY = 'RCCP_PROD81'THEN
																	  N'[FP-LIVE] RCCP Automotive Battery PROD TARGET is newly received.'
																   WHEN @MAIL_PKEY = 'RCCP_PROD82'THEN
																	  N'[FP-LIVE] RCCP Advanced Battery ESS PROD TARGET is newly received.'
																   WHEN @MAIL_PKEY = 'RCCP_PRODEE'THEN
																	  N'[FP-LIVE] RCCP ELECTRODE PROD TARGET is newly received.'
														   
																   WHEN @MAIL_PKEY = 'SCP_PROD40'THEN
																	  N'[FP-LIVE] SCP Small Battery PROD TARGET is newly received.'
																   WHEN @MAIL_PKEY = 'SCP_PROD81'THEN
																	  N'[FP-LIVE] SCP Automotive Battery PROD TARGET is newly received.'
																   WHEN @MAIL_PKEY = 'SCP_PROD81_UC'THEN -- 2022-05-23 kimcd Ultium Cells SCP Target 수신 항목 추가
																	  N'[FP-LIVE] SCP Ultium Cells PROD TARGET is newly received.'
																   WHEN @MAIL_PKEY = 'SCP_PROD82'THEN
																	  N'[FP-LIVE] SCP Advanced Battery ESS PROD TARGET is newly received.'
																   WHEN @MAIL_PKEY = 'SCP_PRODEE'THEN
																	  N'[FP-LIVE] SCP ELECTRODE PROD TARGET is newly received.'
																   WHEN @MAIL_PKEY = 'SCP_PRODEE_UC'THEN -- 2022-05-23 kimcd Ultium Cells SCP Target 수신 항목 추가
																	  N'[FP-LIVE] SCP Ultium Cells ELECTRODE PROD TARGET is newly received.'
																   WHEN @MAIL_PKEY = 'RCCP_SALES40' THEN
																	  N'[FP-LIVE] RCCP Small Battery SHIPPING TARGET is newly received.'
																   WHEN @MAIL_PKEY = 'RCCP_SALES81' THEN
																	  N'[FP-LIVE] RCCP Automotive Battery SHIPPING TARGET is newly received.'
																   WHEN @MAIL_PKEY = 'RCCP_SALES82' THEN
																	  N'[FP-LIVE] RCCP Advanced Battery ESS SHIPPING TARGET is newly received.'
																   WHEN @MAIL_PKEY = 'RCCP_SALESEE' THEN
																	  N'[FP-LIVE] RCCP ELECTRODE SHIPPING TARGET is newly received.'

																   WHEN @MAIL_PKEY = 'SCP_SALES40' THEN
																	  N'[FP-LIVE] SCP Small Battery SHIPPING TARGET is newly received.'
																   WHEN @MAIL_PKEY = 'SCP_SALES81' THEN
																	  N'[FP-LIVE] SCP Automotive Battery SHIPPING TARGET is newly received.'
																   WHEN @MAIL_PKEY = 'SCP_SALES82' THEN
																	  N'[FP-LIVE] SCP Advanced Battery ESS SHIPPING TARGET is newly received.'
																   WHEN @MAIL_PKEY = 'SCP_SALESEE' THEN
																	  N'[FP-LIVE] SCP ELECTRODE SHIPPING TARGET is newly received.'

																   WHEN @MAIL_PKEY = 'SSP_SALES40' THEN
																	  N'[FP-LIVE] SSP Small Battery SHIPPING TARGET is newly received.'
																   WHEN @MAIL_PKEY = 'SSP_SALES81' THEN
																	  N'[FP-LIVE] SSP Automotive Battery SHIPPING TARGET is newly received.'
																   WHEN @MAIL_PKEY = 'SSP_SALES82' THEN
																	  N'[FP-LIVE] SSP Advanced Battery ESS SHIPPING TARGET is newly received.'
																   WHEN @MAIL_PKEY = 'SSP_SALESEE' THEN
																	  N'[FP-LIVE] SSP ELECTRODE SHIPPING TARGET is newly received.'
																	END
														)
													END

												FETCH NEXT FROM CUR_SMS INTO @PHONE_NUM
																			 ,@SITE_ID			 --SMS 송신위한 지역코드  2018.09.03  PIYONG 1.4
												;
											END;
										CLOSE CUR_SMS;
										DEALLOCATE CUR_SMS;

									END	

								IF @MAIL_PKEY IN ( 'FP_MAILING_IF6', 'FP_MAILING_IF5', 'FP_MAILING_IF17', 'FP_MAILING_IF18', 'FP_MAILING_IF21' -- 활성화 당일 재고 와 전일 재고 비교
								                  ,'FP_MAILING_IF15', 'FP_MAILING_IF22', 'FP_MAILING_IF23', 'FP_MAILING_IF24'					-- 2020-02-26 kimcd SMS 대상 추가
												  ,'FP_MAILING_IF19' -- 2020-03-11 piyong SMS 대상 추가
												  ,'FP_MAILING_IF25' -- 2020-04-10 kimcd SMS 전송 안되는 오류 수정 DW 특성 실적 미수신
												  ,'FP_MAILING_IF8'   -- 장기 수행 Plan 2021-01-29 kimcd 항목 추가
												  ,'FP_MAILING_IF29'  -- SSP 재고 2021-01-29 kimcd 항목 추가
												  ,'FP_MAILING_IF30'  -- ERP 재고 미수신 창고 2021-01-29 kimcd 항목 추가
												  ,'FP_MAILING_IF31'  -- 릴리즈 지연 조회 2021-01-29 kimcd 항목 추가
												  ,'FP_MAILING_IF33'  -- 2022-04-30 kimcd tomcat 작동 점검 항목 - 30분 단위 수행
												  ,'FP_MAILING_IF20'  -- 2022-08-18 kimcd 활성화 실적 미입수 확인
												  )
												  --계획 전송 지연, MES Snapshot 수신 지연, ERP,OWMS,포장대기 재고 수신 요청 전일 대비 20% 이상 차이 발생, SCP 생산 Target 수신 지연
									BEGIN
										--2017.05.30  PIYONG 1.2
										DECLARE CUR_SMS CURSOR FOR
											SELECT ATTRIBUTE1 AS PN, ATTRIBUTE2 AS SEND_TYPE
											  FROM [DBO].[SCM_SYS_LOOKUP_VALUE] WITH(NOLOCK)
											 WHERE LOOKUP_TYPE_CODE = 'SMS_ADDRESSEE'
											   AND SEGMENT1 =  'ERROR'
											   AND ACTIVE_FLAG = 'Y'
										;

										OPEN CUR_SMS;
										FETCH NEXT FROM CUR_SMS INTO @PHONE_NUM
																	 ,@SEND_TYPE
										;
											WHILE (@@FETCH_STATUS = 0)
											BEGIN
												IF @MAIL_PKEY = 'FP_MAILING_IF17' AND @SEND_TYPE != 'MES' AND @SEND_TYPE NOT LIKE '%PI%'  -- 2020-02-28 kimcd MES 유형 추가. 2020-02-26 kimcd 기존 SMS 전송에서 PI는 제외
													BEGIN
														DECLARE CUR_IF17 CURSOR FOR -- 2021-01-29 kimcd 작업 시간 경과 추가
														   SELECT PROC_NAME,  DATEDIFF(MI, EVENT_DTTM, GETDATE()) AS TIME_GAP, '' AS MSG
															 FROM (
																	SELECT MASTER_ID, PLAN_ID, PROC_NAME, LOG_TYPE, EVENT_DTTM
																	  FROM [TH_LOG_HISTORY] with(nolock)
																	 WHERE DATEDIFF ( mi , EVENT_DTTM , getdate() ) < 60
																	   AND LOG_TYPE = 'START'
																   ) w
															 WHERE NOT EXISTS ( SELECT 1
																				  FROM [TH_LOG_HISTORY] x with(nolock)
																				 WHERE W.MASTER_ID = X.MASTER_ID
																				   AND W.PROC_NAME = X.PROC_NAME
																				   AND W.EVENT_DTTM <= X.EVENT_DTTM
																				   AND X.LOG_TYPE = 'END')
															   AND DATEDIFF ( MI , EVENT_DTTM , GETDATE() ) > 10
															-----------------------------------------------------------------------
															-- 2020-04-20 PIYONG ADD ENGINE 장기 대기 후 강제 종료 대상 추가
															UNION ALL
															SELECT PROC_NAME, DATEDIFF(MI, EVENT_DTTM, GETDATE()), 'Engine Not Finished' AS MSG
															  FROM [TH_LOG_HISTORY] with(nolock)
															 WHERE DATEDIFF ( mi , EVENT_DTTM , getdate() ) < 10
															   AND MESSAGE LIKE '%ENGINE Not Finised%'
															   AND LOG_TYPE = 'ENGINE'
															-- 2020-04-20 PIYONG END
															-----------------------------------------------------------------------
														;

														OPEN CUR_IF17;
														FETCH NEXT FROM CUR_IF17 INTO @PROC_NAME, @TIME_GAP, @MSG
														;
															WHILE (@@FETCH_STATUS = 0)
																BEGIN
																	INSERT INTO [SY_XIF_IFS_SMS_DATA] (
																		[IF_TYPE]
																		,[IF_ID]
																		,[IF_INS_DATE]
																		,[IF_FLAG]
																		,[IF_SND_DATE]
																		,[TR_SENDSTAT]
																		,[TR_MSGTYPE]
																		,[TR_PHONE]
																		,[TR_CALLBACK]
																		,[TR_MSG]
																	) VALUES (
																		'S'
																		,'OFP0_OSMS_SMS'
																		,GETDATE()
																		,'N'
																		,NULL
																		,'0'
																		,'0'
																		,@PHONE_NUM
																		,@PHONE_NUM
																		,SUBSTRING(@PROC_NAME + ' ' + @TIME_GAP + N'분 경과 ' + @MSG + N' 장기 수행 중인  Batch Job이 있습니다.', 1, 80)
																	)

																	FETCH NEXT FROM CUR_IF17 INTO @PROC_NAME, @TIME_GAP, @MSG
																END
															;
														CLOSE CUR_IF17;
														DEALLOCATE CUR_IF17;
													END
												ELSE IF @MAIL_PKEY = 'FP_MAILING_IF6' AND @SEND_TYPE = 'IF'
													BEGIN
														DECLARE CUR_IF6 CURSOR FOR
														   SELECT [SERVICE_NAME] AS PROC_NAME
															 FROM [DBO].[SY_XIF_ERP_DW_LOG]
															WHERE LOG_MSR IS NOT NULL
															  AND DATEDIFF ( MI, [CREATE_DATE], GETDATE() ) < 15
														;

														OPEN CUR_IF6;
														FETCH NEXT FROM CUR_IF6 INTO @PROC_NAME
														;
															WHILE (@@FETCH_STATUS = 0)
																BEGIN
																	INSERT INTO [SY_XIF_IFS_SMS_DATA] (
																		[IF_TYPE]
																		,[IF_ID]
																		,[IF_INS_DATE]
																		,[IF_FLAG]
																		,[IF_SND_DATE]
																		,[TR_SENDSTAT]
																		,[TR_MSGTYPE]
																		,[TR_PHONE]
																		,[TR_CALLBACK]
																		,[TR_MSG]
																	) VALUES (
																		'S'
																		,'OFP0_OSMS_SMS'
																		,GETDATE()
																		,'N'
																		,NULL
																		,'0'
																		,'0'
																		,@PHONE_NUM
																		,@PHONE_NUM
																		,@PROC_NAME + N' CLASS 송수신 작업 오류'
																	)

																	FETCH NEXT FROM CUR_IF6 INTO @PROC_NAME
																	;
																END
														CLOSE CUR_IF6;
														DEALLOCATE CUR_IF6;
													END
												ELSE IF @MAIL_PKEY = 'FP_MAILING_IF5' AND @SEND_TYPE = 'IF'
													BEGIN
														DECLARE CUR_IF12 CURSOR FOR
														   SELECT w.PROC_NAME, DATEDIFF ( mi , w.EVENT_DTTM , getdate() ) AS TIME_GAP -- 2021-01-29 kimcd 경과 시간 추가
															 FROM (
																	SELECT PROC_NAME, LOG_TYPE, EVENT_DTTM
																	  FROM [dbo].[SY_XIF_LOG_HISTORY] with(nolock)
																	 WHERE DATEDIFF ( mi , EVENT_DTTM , getdate() ) < 60
																	   AND PROC_NAME <> 'PR_SCM_MAIL_PERIOD'
																	   AND LOG_TYPE = 'START'
																   ) w
																   left outer join SCM_SYS_LOOKUP_VALUE as lv with(nolock)
																on w.proc_name = lv.segment1
															   and lv.lookup_type_code = 'PR_SCM_MAIL_SEND'
															   and lv.active_flag = 'Y'
															 WHERE NOT EXISTS ( SELECT 1 FROM [dbo].[SY_XIF_LOG_HISTORY] x with(nolock)
																				 WHERE W.PROC_NAME = X.PROC_NAME
																				   AND W.EVENT_DTTM <= X.EVENT_DTTM
																				   AND X.LOG_TYPE = 'END')
															   AND DATEDIFF( mi, w.EVENT_DTTM, getdate() ) > ISNULL(CAST(lv.attribute1 as int), 10)
 
														;

														OPEN CUR_IF12;
														FETCH NEXT FROM CUR_IF12 INTO @PROC_NAME, @TIME_GAP -- 2021-01-29 kimcd 경과 시간 추가
														;
															WHILE (@@FETCH_STATUS = 0)
																BEGIN
																	INSERT INTO [SY_XIF_IFS_SMS_DATA] (
																		[IF_TYPE]
																		,[IF_ID]
																		,[IF_INS_DATE]
																		,[IF_FLAG]
																		,[IF_SND_DATE]
																		,[TR_SENDSTAT]
																		,[TR_MSGTYPE]
																		,[TR_PHONE]
																		,[TR_CALLBACK]
																		,[TR_MSG]
																	) VALUES (
																		'S'
																		,'OFP0_OSMS_SMS'
																		,GETDATE()
																		,'N'
																		,NULL
																		,'0'
																		,'0'
																		,@PHONE_NUM
																		,@PHONE_NUM
																		,@PROC_NAME + ' ' + @TIME_GAP + N'분 경과 장기 수행 중 입니다.'
																	)

																	FETCH NEXT FROM CUR_IF12 INTO @PROC_NAME, @TIME_GAP -- 2021-01-29 kimcd 경과 시간 추가
																	;
																END
														CLOSE CUR_IF12;
														DEALLOCATE CUR_IF12;
													END
												ELSE IF @MAIL_PKEY = 'FP_MAILING_IF18' AND @SEND_TYPE = 'IF'
													BEGIN
														DECLARE CUR_IF18 CURSOR FOR
														   SELECT CONCAT(GROUP_ID, '  ', JOB_DESC ) AS PROC_NAME
															 FROM JOB_SCHEDULE_HISTORY AS S WITH (NOLOCK)
															WHERE S.JOB_ID IN ( 'PR_XIF_FCS_INVENTORY_R', 'PR_XIF_MES_FORM_WIP_R') -- 2022-04-30 kimcd 활성화 MES 재고 수신 작업 추가
															  AND CONVERT(NVARCHAR(10), S.[CREATE_DATE], 112 ) = CONVERT(NVARCHAR(10), GETDATE(), 112 )
															  AND S.[STATUS] = 'END'
															  AND EXISTS (
																			SELECT 1
																			  FROM SCM_FACTORY_M AS F WITH(NOLOCK)
																			 WHERE F.SHOP_GROUP_ID = 'A'
																			   AND F.ACTIVE_FLAG = 'Y'
																			   AND F.FACTORY_ID NOT IN ('M9', 'M4', 'A1', 'A9','AA','VF_AG')  --AE 제외 --2026-05-27 'VF_AG'
																			   AND F.SITE_ID = CASE WHEN S.GROUP_ID = '999_0002' THEN
																										'A001'
																								  WHEN S.GROUP_ID = '999_0007' OR S.GROUP_ID = '999_0064' THEN
																										'A002'
																								  WHEN S.GROUP_ID = '999_0008' OR S.GROUP_ID = '999_0044' OR S.GROUP_ID = '999_0072' --THEN -- 2022-04-30 kimcd Ultium Cells 작업 추가
																								    OR S.GROUP_ID = '999_0074' OR S.GROUP_ID = '999_0078' THEN --2026-05-27  HD, HG
																										'A003'
																								  WHEN S.GROUP_ID = '999_0076' THEN 'A009'   --2026-05-27 OT (ST) LGES Canada
																								  WHEN S.GROUP_ID = '999_0035' THEN 'A007'   --2026-05-27 HM LGES Indonesia
																								  WHEN S.GROUP_ID = '999_0045' THEN
																										'A004'
																								  END
--[IT20250117A] 하드코딩 변경 START
																			   --AND ( ( F.COMPANY_ID != 'G630' AND GROUP_ID != '999_0064' ) OR ( F.COMPANY_ID = 'G630'  AND S.GROUP_ID = '999_0064' )) -- 2020-04-10 kimcd CNB 구분용 조건 추가
																			   ----AND ( ( F.COMPANY_ID != 'G670' AND GROUP_ID != '999_0044' ) OR ( F.COMPANY_ID = 'G670'  AND S.GROUP_ID = '999_0044' )) -- 2022-07-10 kimcd Ultium Cells 작업 추가
																	           --AND ( ( F.PLANT_ID != 'G671' AND GROUP_ID != '999_0044' ) OR ( F.PLANT_ID = 'G671'  AND GROUP_ID = '999_0044' ))  --UC1
																	           --AND ( ( F.PLANT_ID != 'G673' AND GROUP_ID != '999_0072' ) OR ( F.PLANT_ID = 'G673'  AND GROUP_ID = '999_0072' ))  --UC2
																			   AND ( ( F.COMPANY_ID != @COMPANY_ID_NB AND GROUP_ID != '999_0064' ) OR ( F.COMPANY_ID = @COMPANY_ID_NB  AND S.GROUP_ID = '999_0064' )) -- 2020-04-10 kimcd CNB 구분용 조건 추가
																	           AND ( ( F.PLANT_ID != @PLANT_ID_GM00 AND GROUP_ID != '999_0044' ) OR ( F.PLANT_ID = @PLANT_ID_GM00  AND GROUP_ID = '999_0044' ))  --UC1
																	           AND ( ( F.PLANT_ID != @PLANT_ID_GM01 AND GROUP_ID != '999_0072' ) OR ( F.PLANT_ID = @PLANT_ID_GM01  AND GROUP_ID = '999_0072' ))  --UC2
																				AND ( ( F.COMPANY_ID != 'HD00' AND GROUP_ID != '999_0074' ) OR ( F.COMPANY_ID = 'HD00'  AND GROUP_ID = '999_0074' ))  -- 2026-05-27 'HD00' 
																				AND ( ( F.COMPANY_ID != 'HG00' AND GROUP_ID != '999_0078' ) OR ( F.COMPANY_ID = 'HG00'  AND GROUP_ID = '999_0078' ))  -- 2026-05-27 'HG00'
--[IT20250117A] 하드코딩 변경 END																	
																			   AND NOT EXISTS (SELECT 1
																							   FROM  SCM_SYS_LOOKUP_VALUE AS SLV with(NOLOCK)
																							   WHERE SLV.LOOKUP_TYPE_CODE = 'ABNORMAL_FACTORY'
																							   AND   SLV.SEGMENT1    = F.FACTORY_ID
																							   AND   ISNULL(SLV.ATTRIBUTE2, 'N')  != 'Y'  -- 2024-01-02 kimcd 조건 추가
																							   AND   SLV.ACTIVE_FLAG = 'Y') -- 2021-01-29 kimcd A9 제외에서 비정상 동 제외로 보완
																			   AND NOT EXISTS (
																								SELECT 1
																								  FROM SCM_AGING_STOCK_H A with(nolock)
																								 WHERE A.COMPANY_ID = F.COMPANY_ID
																								   AND A.DIVISION_ID = F.DIVISION_ID
																								   AND A.SITE_ID = F.SITE_ID
																								   AND A.PLANT_ID = F.PLANT_ID
																								   AND A.FACTORY_ID = F.FACTORY_ID
																								   AND A.CUTOFF_DATE = CONVERT(NVARCHAR,GETDATE(), 112)
																								 GROUP BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID
																								 UNION ALL 
																								SELECT 1
																								  FROM SY_XIF_MES_CHAR_AGING_STOCK_R WITH(NOLOCK)
																								  WHERE ACCUM_DATE = CONVERT(NVARCHAR,GETDATE(), 112)
																								   AND IF_ID LIKE F.FCS_SOURCE_GROUP + '%'
																								   AND ITEM_ID = 'NO_CHAR_AGING_STOCK'
																								UNION ALL 
																								SELECT 1
																								  FROM (
																								        SELECT  BUILDING
																									      FROM SY_XIF_DW_FCS_INVENTORY_R WITH(NOLOCK)
																								         WHERE 1 = 1
																								           AND WORKDATE = FORMAT(getdate(), 'yyyy-MM-dd')
																								         GROUP BY BUILDING
																								       ) AS T
																								 WHERE T.BUILDING = F.FACTORY_ID
																							  )
																		 )  
														;

														OPEN CUR_IF18;
														FETCH NEXT FROM CUR_IF18 INTO @PROC_NAME
														;
															WHILE (@@FETCH_STATUS = 0)
																BEGIN
																	INSERT INTO [SY_XIF_IFS_SMS_DATA] (
																		[IF_TYPE]
																		,[IF_ID]
																		,[IF_INS_DATE]
																		,[IF_FLAG]
																		,[IF_SND_DATE]
																		,[TR_SENDSTAT]
																		,[TR_MSGTYPE]
																		,[TR_PHONE]
																		,[TR_CALLBACK]
																		,[TR_MSG]
																	) VALUES (
																		'S'
																		,'OFP0_OSMS_SMS'
																		,GETDATE()
																		,'N'
																		,NULL
																		,'0'
																		,'0'
																		,@PHONE_NUM
																		,@PHONE_NUM
																		,@PROC_NAME + N' 활성화 재고가 생성되지 않았습니다.'
																	)

																	FETCH NEXT FROM CUR_IF18 INTO @PROC_NAME
																	;
																END
														CLOSE CUR_IF18;
														DEALLOCATE CUR_IF18;
													END
												ELSE IF @MAIL_PKEY = 'FP_MAILING_IF21' AND @SEND_TYPE != 'MES' AND @SEND_TYPE != 'ENGINE' AND @SEND_TYPE NOT LIKE '%PI%' -- 2020-02-28 kimcd MES 유형 추가. 2020-02-26 kimcd 활성화 당일 재고 와 전일 재고 비교. 엔진 인원만 전송 대상에서 제외
													BEGIN
														DECLARE CUR_IF21 CURSOR FOR
														   	SELECT FACTORY_ID
															  FROM SCM_FACTORY_M F
															 WHERE SHOP_GROUP_ID = 'A'
															   AND ACTIVE_FLAG = 'Y'
															   AND COMPANY_ID != @COMPANY_ID_NB --'G630' --[IT20250117A]하드코딩 변경
															   AND FACTORY_ID != 'S3'
															   AND SITE_ID IN ( SELECT CASE WHEN GROUP_ID = '999_0002' THEN
																								'A001'
																							WHEN GROUP_ID = '999_0007' OR GROUP_ID = '999_0064' THEN
																								'A002'
																							WHEN GROUP_ID = '999_0008' OR GROUP_ID = '999_0044' THEN  -- 2022-04-30 kimcd Ultium Cells 작업 추가
																								'A003'
																							WHEN GROUP_ID = '999_0045' THEN
																								'A004'
																							END
																				  FROM JOB_SCHEDULE_HISTORY S WITH (NOLOCK)
																			     WHERE S.JOB_ID IN ( 'PR_XIF_FCS_INVENTORY_R', 'PR_XIF_MES_FORM_WIP_R') -- 2022-04-30 kimcd 활성화 MES 재고 수신 작업 추가
																				   AND CONVERT(NVARCHAR(10), S.[CREATE_DATE], 112 ) = CONVERT(NVARCHAR(10), GETDATE(), 112 )
																				   AND S.[STATUS] = 'END'
																				   --[IT20250117A] 하드코딩 변경 START
																				   --AND ( ( F.COMPANY_ID != 'G630' AND GROUP_ID != '999_0064' ) OR ( F.COMPANY_ID = 'G630'  AND GROUP_ID = '999_0064' )) -- 2022-04-30 kimcd CNB 구분용 조건 추가
																				   --AND ( ( F.COMPANY_ID != 'G670' AND GROUP_ID != '999_0044' ) OR ( F.COMPANY_ID = 'G670'  AND GROUP_ID = '999_0044' )) -- 2022-07-01 kimcd Ultium Cells 구분용 조건 추가
																				   AND ( ( F.COMPANY_ID != @COMPANY_ID_NB AND GROUP_ID != '999_0064' ) OR ( F.COMPANY_ID = @COMPANY_ID_NB  AND GROUP_ID = '999_0064' )) -- 2022-04-30 kimcd CNB 구분용 조건 추가
																				   AND ( ( F.COMPANY_ID != @COMPANY_ID_GM AND GROUP_ID != '999_0044' ) OR ( F.COMPANY_ID = @COMPANY_ID_GM  AND GROUP_ID = '999_0044' )) -- 2022-07-01 kimcd Ultium Cells 구분용 조건 추가
																				   --[IT20250117A] 하드코딩 변경 END 
																			  )
															   AND 1 =  (
																			SELECT CASE WHEN ( (SUM(D) /  SUM(D1) ) < 0.85 ) OR ( (SUM(D) /  SUM(D1) ) > 1.15 ) THEN 1  ELSE 0 END FLAG
																			  FROM (
																						SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, ITEM_ID, STOCK_TYPE
																								, CASE WHEN CUTOFF_DATE = CONVERT(NVARCHAR,GETDATE()-1, 112)  THEN ORIGINAL_QTY ELSE NULL END AS D1
																								, CASE WHEN CUTOFF_DATE = CONVERT(NVARCHAR,GETDATE(), 112)  THEN ORIGINAL_QTY ELSE NULL END AS D
																						  FROM SCM_AGING_STOCK_H A
																						 WHERE A.COMPANY_ID = F.COMPANY_ID   
																						   AND A.DIVISION_ID = F.DIVISION_ID
																						   AND A.SITE_ID = F.SITE_ID
																						   AND A.PLANT_ID = F.PLANT_ID
																						   AND A.FACTORY_ID = F.FACTORY_ID
																						   AND A.CUTOFF_DATE IN ( CONVERT(NVARCHAR,GETDATE()-1, 112), CONVERT(NVARCHAR,GETDATE(), 112))
																					) AA
																			  GROUP BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID
																		 )
														;

														OPEN CUR_IF21;
														FETCH NEXT FROM CUR_IF21 INTO @PROC_NAME
														;
															WHILE (@@FETCH_STATUS = 0)
																BEGIN
																	INSERT INTO [SY_XIF_IFS_SMS_DATA] (
																		[IF_TYPE]
																		,[IF_ID]
																		,[IF_INS_DATE]
																		,[IF_FLAG]
																		,[IF_SND_DATE]
																		,[TR_SENDSTAT]
																		,[TR_MSGTYPE]
																		,[TR_PHONE]
																		,[TR_CALLBACK]
																		,[TR_MSG]
																	) VALUES (
																		'S'
																		,'OFP0_OSMS_SMS'
																		,GETDATE()
																		,'N'
																		,NULL
																		,'0'
																		,'0'
																		,@PHONE_NUM
																		,@PHONE_NUM
																		,@PROC_NAME + N' 전일 대비 활성화 재고 20% 이상 차이 발생.'
																	)

																	FETCH NEXT FROM CUR_IF21 INTO @PROC_NAME
																END
															;
														CLOSE CUR_IF21;
														DEALLOCATE CUR_IF21;
													END
												-- 2020-02-26 kimcd 추가 시작
												ELSE IF @MAIL_PKEY = 'FP_MAILING_IF15' AND @SEND_TYPE IN ('IF', 'PI', 'MES' ) -- 2020-02-28 kimcd MES 유형 추가. 2020-02-26 kimcd 계획 전송 지연
													BEGIN
														DECLARE CUR_IF15 CURSOR FOR
															SELECT 'ERP WO ' + FP_PLAN_ID AS DATA_TYPE
															  FROM [DBO].[SY_XIF_ERP_PRODUCTION_PLAN_S] with(nolock)
															 WHERE TRANSFER_FLAG = 'N' 
															   AND DATEDIFF ( mi , MODIFY_DATE , getdate() ) > 20
															GROUP BY FP_PLAN_ID
															UNION ALL
															SELECT 'MES Daily Plan ' + PLAN_ID
															  FROM [DBO].[SY_XIF_MES_DAILY_PP_S] with(nolock)
															 WHERE IF_FLAG = 'N'
															   AND DATEDIFF ( mi ,  IF_INS_DATE, getdate() ) > 20
															GROUP BY PLAN_ID
															UNION ALL
															SELECT 'MES WO ' + PLAN_ID
															  FROM [DBO].[SY_XIF_MES_WO_S] with(nolock)
															 WHERE IF_FLAG = 'N'
															   AND DATEDIFF ( mi ,  IF_INS_DATE, getdate() ) > 20
															GROUP BY PLAN_ID
															UNION ALL
															SELECT 'MES Pegging ' + PLAN_ID
															  FROM [DBO].[SY_XIF_MES_WO_PEGGING_S] with(nolock)
															 WHERE IF_FLAG = 'N'
															   AND DATEDIFF ( mi ,  IF_INS_DATE, getdate() ) > 20
															GROUP BY PLAN_ID
															UNION ALL
															SELECT 'MRP Plan ' + ATTR_01
															  FROM [DBO].[SY_XIF_MRP_PROD_TARGET_S] with(nolock)
															 WHERE IF_FLAG = 'N'
															   AND DATEDIFF ( mi ,  IF_INS_DATE, getdate() ) > 20
															GROUP BY ATTR_01;

														OPEN CUR_IF15;
														FETCH NEXT FROM CUR_IF15 INTO @PROC_NAME
														;
															WHILE (@@FETCH_STATUS = 0)
																BEGIN
																	INSERT INTO [SY_XIF_IFS_SMS_DATA] (
																		[IF_TYPE]
																		,[IF_ID]
																		,[IF_INS_DATE]
																		,[IF_FLAG]
																		,[IF_SND_DATE]
																		,[TR_SENDSTAT]
																		,[TR_MSGTYPE]
																		,[TR_PHONE]
																		,[TR_CALLBACK]
																		,[TR_MSG]
																	) VALUES (
																		'S'
																		,'OFP0_OSMS_SMS'
																		,GETDATE()
																		,'N'
																		,NULL
																		,'0'
																		,'0'
																		,@PHONE_NUM
																		,@PHONE_NUM
																		,@PROC_NAME + N' 계획 전송이 지연됨'
																	)

																	FETCH NEXT FROM CUR_IF15 INTO @PROC_NAME
																END
															;
														CLOSE CUR_IF15;
														DEALLOCATE CUR_IF15;
													END
												ELSE IF @MAIL_PKEY = 'FP_MAILING_IF22' AND @SEND_TYPE IN ('IF', 'PI', 'MES' ) -- 2020-02-28 kimcd MES 유형 추가. 2020-02-26 kimcd MES Snapshot 수신 지연
													BEGIN
														DECLARE CUR_IF22 CURSOR FOR
															SELECT 'Site : ' + LV.SEGMENT1 + N', 시업 시간 : ' + LV.SEGMENT2 AS DATA_TYPE
															FROM   SCM_SYS_LOOKUP_VALUE LV (NOLOCK)
															WHERE  LV.LOOKUP_TYPE_CODE = 'AUTO_PLAN_CALL_FLAG'
															AND    LV.ATTRIBUTE1 != CONVERT(NVARCHAR(8), GETDATE(), 112)
															AND    DATEADD( MI, IIF(LV.SEGMENT1 = 'A004', -60, -40), DBO.FN_SITE_TIME(LV.SEGMENT1))  > CONVERT(DATETIME, CONCAT(CONVERT(NVARCHAR(10), GETDATE(), 120) ,' ', SUBSTRING(LV.SEGMENT2, 1, 2), ':',SUBSTRING(LV.SEGMENT2, 3, 2), ':',SUBSTRING(LV.SEGMENT2, 5, 2)),120)
															;

														OPEN CUR_IF22;
														FETCH NEXT FROM CUR_IF22 INTO @PROC_NAME
														;
															WHILE (@@FETCH_STATUS = 0)
																BEGIN
																	INSERT INTO [SY_XIF_IFS_SMS_DATA] (
																		[IF_TYPE]
																		,[IF_ID]
																		,[IF_INS_DATE]
																		,[IF_FLAG]
																		,[IF_SND_DATE]
																		,[TR_SENDSTAT]
																		,[TR_MSGTYPE]
																		,[TR_PHONE]
																		,[TR_CALLBACK]
																		,[TR_MSG]
																	) VALUES (
																		'S'
																		,'OFP0_OSMS_SMS'
																		,GETDATE()
																		,'N'
																		,NULL
																		,'0'
																		,'0'
																		,@PHONE_NUM
																		,@PHONE_NUM
																		,@PROC_NAME + N' MES Snapshot 정보 형성 지연'
																	)

																	FETCH NEXT FROM CUR_IF22 INTO @PROC_NAME
																END
															;
														CLOSE CUR_IF22;
														DEALLOCATE CUR_IF22;
													END
												ELSE IF @MAIL_PKEY = 'FP_MAILING_IF23' AND @SEND_TYPE != 'MES' AND @SEND_TYPE != 'ENGINE' AND @SEND_TYPE NOT LIKE '%PI%' -- 2020-02-26 kimcd ERP,OWMS,포장대기 재고 수신 요청 전일 대비 20% 이상 차이 발생
													BEGIN
														DECLARE CUR_IF23 CURSOR FOR -- 2021-01-29 kimcd ERP 재고 제거 50%로 기준 수정
															SELECT CASE WHEN S.STOCK_TYPE = 'DW' AND S.STORAGE_ID = '-' THEN 'Cell Packing '
																		ELSE 'OWMS '
																   END + S.PLANT_ID + CASE WHEN SUM(CASE WHEN S.CUTOFF_DATE = CONVERT(DATE,GETDATE(),120) THEN QTY END) IS NULL THEN N' 미형성 Error ' ELSE '' END -- 2020-08-18 kimcd NULL 구분자 추가 
																   AS DATA_TYPE
															FROM   (SELECT S.CUTOFF_DATE, S.STOCK_TYPE, PLANT_ID, CASE WHEN S.STORAGE_ID = '-' THEN '-' ELSE '*' END AS STORAGE_ID, SUM(QTY) AS QTY, MAX(S.SITE_ID) AS SITE_ID, MAX(S.COMPANY_ID) AS COMPANY_ID
																	FROM   SCM_STOCK_H S (NOLOCK)
																	WHERE  S.CUTOFF_DATE IN  (CONVERT(DATE,GETDATE(),120), CONVERT(DATE,DATEADD(D,-1,GETDATE()),120))
																	AND    S.STOCK_TYPE = 'DW'
																	AND    S.PLANT_ID IN  (SELECT V.SEGMENT1
																						   FROM   SCM_SYS_LOOKUP_VALUE V  WITH(NOLOCK)
																								 ,SCM_PLANT_M          P  WITH(NOLOCK)
																						   WHERE  V.SEGMENT1 = P.PLANT_ID
																						   AND    V.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
																						   AND    V.ACTIVE_FLAG = 'Y'
																						   AND    SUBSTRING(CONVERT(NVARCHAR(20), DATEADD(HOUR,-3, [DBO].[FN_SITE_TIME] ( P.SITE_ID )), 120), 12,8) 
																								  < LEFT(V.SEGMENT2, 2) +':'+ SUBSTRING(V.SEGMENT2, 3, 2) +':00'
																						   )
																	GROUP BY S.CUTOFF_DATE, S.STOCK_TYPE, PLANT_ID, CASE WHEN S.STORAGE_ID = '-' THEN '-' ELSE '*' END) S
															-- WHERE   S.QTY > 0 제거 2020-08-18 kimcd NULL 형성용 조건 제거
															WHERE   EXISTS (SELECT 1
																			FROM   JOB_SCHEDULE_HISTORY H WITH (NOLOCK)
																			WHERE  H.JOB_ID = 'PR_XIF_DW_INVENTORY_R'
																			AND    CONVERT(NVARCHAR(10), H.[CREATE_DATE], 112 ) = CONVERT(NVARCHAR(10), GETDATE(), 112 )
																			AND    H.[STATUS] = 'END'
																			--[IT20250117A] 하드코딩 변경 START
																			AND    H.GROUP_ID = CASE  WHEN S.SITE_ID = 'A001' THEN '999_0002'
																									--WHEN S.SITE_ID = 'A002' AND S.COMPANY_ID = 'G630' THEN '999_0064'
																									WHEN S.SITE_ID = 'A002' AND S.COMPANY_ID = @COMPANY_ID_NB THEN '999_0064'
																									WHEN S.SITE_ID = 'A002' THEN '999_0007'
																									--WHEN S.SITE_ID = 'A003'	AND S.COMPANY_ID = 'G670' THEN '999_0044'  -- 2022-07-01 kimcd ultium cells 구분 추가
																									WHEN S.SITE_ID = 'A003'	AND S.COMPANY_ID = @COMPANY_ID_GM THEN '999_0044'  -- 2022-07-01 kimcd ultium cells 구분 추가
																									WHEN S.SITE_ID = 'A003' THEN '999_0008'
																									WHEN S.SITE_ID = 'A004' THEN '999_0045'	END)
																			-- [IT20250117A] 하드코딩 변경 END
															GROUP BY S.STOCK_TYPE, S.PLANT_ID, S.STORAGE_ID
															HAVING SUM(CASE WHEN S.CUTOFF_DATE != CONVERT(DATE,GETDATE(),120) THEN QTY END)/SUM(CASE WHEN S.CUTOFF_DATE = CONVERT(DATE,GETDATE(),120) THEN CASE WHEN QTY = 0 THEN 1 ELSE QTY END END) > 1.5
															OR     SUM(CASE WHEN S.CUTOFF_DATE != CONVERT(DATE,GETDATE(),120) THEN QTY END)/SUM(CASE WHEN S.CUTOFF_DATE = CONVERT(DATE,GETDATE(),120) THEN CASE WHEN QTY = 0 THEN 1 ELSE QTY END END) < 0.5
															OR     SUM(CASE WHEN S.CUTOFF_DATE = CONVERT(DATE,GETDATE(),120) THEN QTY END) IS NULL  -- 2020-08-18 kimcd NULL 형성용 조건 추가

														OPEN CUR_IF23;
														FETCH NEXT FROM CUR_IF23 INTO @PROC_NAME
														;
															WHILE (@@FETCH_STATUS = 0)
																BEGIN
																	IF (@PROC_NAME LIKE '%OWMS%' AND @SEND_TYPE = 'IF' OR @PROC_NAME NOT LIKE '%OWMS%' )  -- 2021-01-29 kimcd OWMS는 IF만 SMS 수신
																		BEGIN
																			INSERT INTO [SY_XIF_IFS_SMS_DATA] (
																				[IF_TYPE]
																				,[IF_ID]
																				,[IF_INS_DATE]
																				,[IF_FLAG]
																				,[IF_SND_DATE]
																				,[TR_SENDSTAT]
																				,[TR_MSGTYPE]
																				,[TR_PHONE]
																				,[TR_CALLBACK]
																				,[TR_MSG]
																			) VALUES (
																				'S'
																				,'OFP0_OSMS_SMS'
																				,GETDATE()
																				,'N'
																				,NULL
																				,'0'
																				,'0'
																				,@PHONE_NUM
																				,@PHONE_NUM
																				,@PROC_NAME + N' 전일 대비 재고 50% 초과 차이 발생'
																			)
																		END;
																	FETCH NEXT FROM CUR_IF23 INTO @PROC_NAME
																END
															;
														CLOSE CUR_IF23;
														DEALLOCATE CUR_IF23;
													END
												ELSE IF @MAIL_PKEY = 'FP_MAILING_IF24' AND @SEND_TYPE IN ('IF', 'PI' ) -- 2020-02-26 kimcd SCP 생산 Target 수신 지연
													BEGIN
														DECLARE CUR_IF24 CURSOR FOR
															SELECT DIVISION + ' ' + PLAN_WEEK AS DATA_TYPE
															FROM [DBO].[SY_XIF_SCP_PROD_TARGET_R] WITH(NOLOCK)
															WHERE ISNULL(PROC_FLAG,'N') = 'N'
															AND PLAN_TYPE IN ( 'MA', 'FN')
															AND  DATEDIFF ( mi ,  IF_RCV_DATE, getdate() ) > 30
															GROUP BY DIVISION, PLAN_WEEK
														OPEN CUR_IF24;
														FETCH NEXT FROM CUR_IF24 INTO @PROC_NAME
														;
															WHILE (@@FETCH_STATUS = 0)
																BEGIN
																	INSERT INTO [SY_XIF_IFS_SMS_DATA] (
																		[IF_TYPE]
																		,[IF_ID]
																		,[IF_INS_DATE]
																		,[IF_FLAG]
																		,[IF_SND_DATE]
																		,[TR_SENDSTAT]
																		,[TR_MSGTYPE]
																		,[TR_PHONE]
																		,[TR_CALLBACK]
																		,[TR_MSG]
																	) VALUES (
																		'S'
																		,'OFP0_OSMS_SMS'
																		,GETDATE()
																		,'N'
																		,NULL
																		,'0'
																		,'0'
																		,@PHONE_NUM
																		,@PHONE_NUM
																		,@PROC_NAME + N' SCP Target 수신 지연'
																	)

																	FETCH NEXT FROM CUR_IF24 INTO @PROC_NAME
																END
															;
														CLOSE CUR_IF24;
														DEALLOCATE CUR_IF24;
													END
												ELSE IF @MAIL_PKEY = 'FP_MAILING_IF25' AND @SEND_TYPE IN ('IF', 'PI' ) -- 2020-02-26 kimcd DW 특성 실적 미수신
													BEGIN
														DECLARE CUR_IF25 CURSOR FOR
															SELECT F.FACTORY_ID
															FROM JOB_SCHEDULE_HISTORY S (NOLOCK),
																 SCM_FACTORY_M        F (NOLOCK),
																 SCM_SYS_LOOKUP_VALUE V (NOLOCK)
															WHERE V.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
															AND   V.ACTIVE_FLAG = 'Y'
															AND   F.PLANT_ID    = V.SEGMENT1
															AND S.JOB_ID IN ('PR_XIF_DW_QUALITY_WIP_HISTORY_PL_R', 'PR_XIF_DW_QUALITY_WIP_HISTORY_R', 'PR_XIF_MES_FORM_QUALITY_WIP_HIST_R')  -- 2022-01-07 kimcd PR_XIF_MES_FORM_QUALITY_WIP_HIST_R 항목 추가
															AND CONVERT(NVARCHAR(10), S.[CREATE_DATE], 112 ) = CONVERT(NVARCHAR(10), GETDATE(), 112 )
															AND S.[STATUS] = 'END'
															AND F.SHOP_GROUP_ID = 'A'
															AND F.ACTIVE_FLAG = 'Y'
															AND F.DIVISION_ID != '40' -- 소형은 정보 없음
															AND F.FACTORY_ID NOT IN  ('S2', 'S4', 'A1', 'A9')  -- FCS 인스턴스 통합 관리되어 해당 동으로는 정보 없음 -- 2020-05-13 PIYONG A9 ADD
														    AND NOT EXISTS (SELECT 1
																			FROM  SCM_SYS_LOOKUP_VALUE SLV(NOLOCK)
																			WHERE SLV.LOOKUP_TYPE_CODE = 'ABNORMAL_FACTORY'
																			AND   SLV.SEGMENT1    = F.FACTORY_ID
																			AND   ISNULL(SLV.ATTRIBUTE2, 'N')  != 'Y'  -- 2024-01-02 kimcd 조건 추가
																			AND   SLV.ACTIVE_FLAG = 'Y') -- 2021-01-29 kimcd A9 제외에서 비정상 동 제외로 보완
															AND F.SITE_ID = CASE WHEN S.GROUP_ID = '999_0002' THEN
																					'A001'
																				WHEN S.GROUP_ID = '999_0007' OR S.GROUP_ID = '999_0064' THEN
																					'A002'
																				WHEN S.GROUP_ID = '999_0008' OR S.GROUP_ID = '999_0044' THEN -- 2022-04-30 kimcd Ultium Cells 경우 포함
																					'A003'
																				WHEN S.GROUP_ID = '999_0045' THEN
																					'A004'
																				END
															AND V.SEGMENT2   = CASE WHEN S.GROUP_ID = '999_0002' THEN
																					'060000'
																				WHEN S.GROUP_ID = '999_0007' THEN
																					'080000'
																				WHEN S.GROUP_ID = '999_0064' THEN
																					'083000'
																				WHEN S.GROUP_ID = '999_0044' THEN -- 2022-04-30 kimcd Ultium Cells 경우 포함
																					'053000'
																				WHEN S.GROUP_ID = '999_0008' THEN
																					'070000'
																				WHEN S.GROUP_ID = '999_0045' THEN
																					'070000'
																				END
															AND NOT EXISTS (SELECT 1 FROM  SY_XIF_DW_QUALITY_WIP_HISTORY_PL_R R (NOLOCK)
																			WHERE R.IFSEQNO LIKE CONVERT(NVARCHAR(8), GETDATE(), 112 ) + '%'
																			AND   R.BUILDING = F.FACTORY_ID
																			UNION ALL
																			SELECT 1 FROM  SY_XIF_DW_QUALITY_WIP_HISTORY_R R (NOLOCK)
																			WHERE R.IFSEQNO LIKE CONVERT(NVARCHAR(8), GETDATE(), 112 ) + '%'
																			AND   R.BUILDING = F.FACTORY_ID
																			UNION ALL
																			SELECT 1 FROM  SY_XIF_MES_CHAR_DAILY_RESULT_R R (NOLOCK)  -- 2022-01-07 kimcd 활성화 MES 수신 Table 추가
																			WHERE R.IF_ID LIKE F.FCS_SOURCE_GROUP + '%'
																			AND   R.ACCUM_DATE = CONVERT(NVARCHAR(8), GETDATE(), 112)
																			)
																AND DATEDIFF ( MI, S.CREATE_DATE, GETDATE() ) <= 120; -- 2시간 이내만 전송

														OPEN CUR_IF25;
														FETCH NEXT FROM CUR_IF25 INTO @PROC_NAME
														;
															WHILE (@@FETCH_STATUS = 0)
																BEGIN
																	INSERT INTO [SY_XIF_IFS_SMS_DATA] (
																		[IF_TYPE]
																		,[IF_ID]
																		,[IF_INS_DATE]
																		,[IF_FLAG]
																		,[IF_SND_DATE]
																		,[TR_SENDSTAT]
																		,[TR_MSGTYPE]
																		,[TR_PHONE]
																		,[TR_CALLBACK]
																		,[TR_MSG]
																	) VALUES (
																		'S'
																		,'OFP0_OSMS_SMS'
																		,GETDATE()
																		,'N'
																		,NULL
																		,'0'
																		,'0'
																		,@PHONE_NUM
																		,@PHONE_NUM
																		,@PROC_NAME + N' DW 활성화 특성 실적 누락'
																	)

																	FETCH NEXT FROM CUR_IF25 INTO @PROC_NAME
																END
															;
														CLOSE CUR_IF25;
														DEALLOCATE CUR_IF25;
													END
												-- 2020-02-26 kimcd 추가 끝
												-- 2020-03-11 piyong add 
												ELSE IF @MAIL_PKEY = 'FP_MAILING_IF19' AND @SEND_TYPE IN ('IF') -- 2020-03-11 piyong OWMS, 포장대기 재고 미수신
													BEGIN
														DECLARE CUR_IF19 CURSOR FOR
															SELECT F.PLANT_ID
															  FROM JOB_SCHEDULE_HISTORY S (NOLOCK),
																   (
																	SELECT F.PLANT_ID, F.SITE_ID
																	  FROM SCM_FACTORY_M F WITH(NOLOCK)
																	 WHERE F.ACTIVE_FLAG   = 'Y'
																	   AND F.SHOP_GROUP_ID = 'A'
																	   AND NOT EXISTS ( SELECT 1
																						FROM   LGCE_FP_TR.DBO.SCM_SYS_LOOKUP_VALUE SLV (NOLOCK)
																						WHERE  SLV.LOOKUP_TYPE_CODE = 'ABNORMAL_FACTORY'
																						AND    F.FACTORY_ID    = SLV.SEGMENT1
																						AND    SLV.ACTIVE_FLAG = 'Y' ) -- 2022-05-17 kimcd 비정상 동 제외 로직 추가
																	 GROUP BY F.PLANT_ID, F.SITE_ID	) F
															 WHERE S.JOB_ID = 'PR_XIF_DW_INVENTORY_R'
															   AND CONVERT(NVARCHAR(10), S.[CREATE_DATE], 112 ) = CONVERT(NVARCHAR(10), GETDATE(), 112 )
															   AND S.[STATUS] = 'END'
   															   AND DATEDIFF ( MI, S.CREATE_DATE, GETDATE() ) <= 120					 -- 2시간 이내만 전송
															   AND F.SITE_ID = CASE WHEN S.GROUP_ID = '999_0002' THEN
																						'A001'
																					WHEN S.GROUP_ID = '999_0007' OR S.GROUP_ID = '999_0064' THEN
																						'A002'
																					WHEN S.GROUP_ID = '999_0008' OR S.GROUP_ID = '999_0044' THEN -- 2022-04-30 kimcd Ultium Cells 포함
																						'A003'
																					WHEN S.GROUP_ID = '999_0045' THEN
																						'A004'
																					END
															  AND F.PLANT_ID IN (
																						(
																							SELECT V.SEGMENT1
																							  FROM SCM_SYS_LOOKUP_VALUE V  WITH(NOLOCK)
																							 WHERE V.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
																							   AND V.ACTIVE_FLAG = 'Y'
																							   AND V.SEGMENT1 = F.PLANT_ID
																							   AND V.SEGMENT2 = CASE WHEN S.GROUP_ID = '999_0002' THEN
																															'060000'
																														WHEN S.GROUP_ID = '999_0007'THEN
																															'080000'
																														WHEN S.GROUP_ID = '999_0064' THEN
																															'083000'
																														WHEN S.GROUP_ID = '999_0044' THEN --2022-07-01 kimcd Ultium Cells 포함
																															'053000'
																														ELSE
																															'070000'
																														END
																						)
																					)
															  AND  NOT EXISTS (
																			SELECT 1
																			  FROM (
																					SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, CUTOFF_DATE, CASE WHEN STORAGE_ID != '-' THEN 'W' ELSE STORAGE_ID END STORAGE_ID
																					  FROM SCM_STOCK_H 
																					 WHERE CUTOFF_DATE = CONVERT(NVARCHAR(10), GETDATE(), 112 )
																					   AND SITE_ID = F.SITE_ID
																					   AND STOCK_TYPE = 'DW'
																					   AND PLANT_ID = F.PLANT_ID
																					 GROUP BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, CUTOFF_DATE, CASE WHEN STORAGE_ID != '-' THEN 'W' ELSE STORAGE_ID END
																				   ) A
																			 GROUP BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, CUTOFF_DATE
																			HAVING COUNT( STORAGE_ID ) = 2
																		  )
															;


														OPEN CUR_IF19;
														FETCH NEXT FROM CUR_IF19 INTO @PROC_NAME
														;
														WHILE (@@FETCH_STATUS = 0)
															BEGIN
																	INSERT INTO [SY_XIF_IFS_SMS_DATA] (
																		[IF_TYPE]
																		,[IF_ID]
																		,[IF_INS_DATE]
																		,[IF_FLAG]
																		,[IF_SND_DATE]
																		,[TR_SENDSTAT]
																		,[TR_MSGTYPE]
																		,[TR_PHONE]
																		,[TR_CALLBACK]
																		,[TR_MSG]
																	) VALUES (
																		'S'
																		,'OFP0_OSMS_SMS'
																		,GETDATE()
																		,'N'
																		,NULL
																		,'0'
																		,'0'
																		,@PHONE_NUM
																		,@PHONE_NUM
																		,@PROC_NAME + N' OWMS, 포장대기 재고 누락'
																	)

																	FETCH NEXT FROM CUR_IF19 INTO @PROC_NAME
															END
														;
														CLOSE CUR_IF19;
														DEALLOCATE CUR_IF19;
													END
												-- 2020-03-11 piyong add end
												-- 2021-01-29 kimcd 추가 시작
												ELSE IF @MAIL_PKEY = 'FP_MAILING_IF8' AND @SEND_TYPE != 'MES' AND @SEND_TYPE NOT LIKE '%PI%'  -- 2021-01-29 kimcd Plan 장기 수행 Alert
													BEGIN
														DECLARE CUR_IF8 CURSOR FOR
														   SELECT PLAN_ID, DATEDIFF(MINUTE, UPDATE_TIME, GETDATE()) AS TIMEGAP
														   FROM   LGCE_FP_TR.DBO.FP_PLAN_STATUS_H
														   WHERE  ACTIVE_FLAG = 1 
														   AND    DATEDIFF(MINUTE, UPDATE_TIME, sysdatetime()) > 25 
														   AND    INSTANCE_ID != 'PL_E_POST'
														;

														OPEN CUR_IF8;
														FETCH NEXT FROM CUR_IF8 INTO @PROC_NAME, @TIME_GAP
														;
															WHILE (@@FETCH_STATUS = 0)
																BEGIN
																	INSERT INTO [SY_XIF_IFS_SMS_DATA] (
																		[IF_TYPE]
																		,[IF_ID]
																		,[IF_INS_DATE]
																		,[IF_FLAG]
																		,[IF_SND_DATE]
																		,[TR_SENDSTAT]
																		,[TR_MSGTYPE]
																		,[TR_PHONE]
																		,[TR_CALLBACK]
																		,[TR_MSG]
																	) VALUES (
																		'S'
																		,'OFP0_OSMS_SMS'
																		,GETDATE()
																		,'N'
																		,NULL
																		,'0'
																		,'0'
																		,@PHONE_NUM
																		,@PHONE_NUM
																		,SUBSTRING(@PROC_NAME + ' ' + @TIME_GAP + N'분 경과 장기 수행 중인  Plan이 있습니다.', 1, 80)
																	)

																	FETCH NEXT FROM CUR_IF8 INTO @PROC_NAME, @TIME_GAP
																END
															;
														CLOSE CUR_IF8;
														DEALLOCATE CUR_IF8;
													END
												ELSE IF @MAIL_PKEY = 'FP_MAILING_IF29' AND @SEND_TYPE = 'IF'  -- SSP 재고 미수신
													BEGIN
														DECLARE CUR_IF29 CURSOR FOR
															SELECT FACTORY_ID
															FROM  ( 
															SELECT ( SELECT TOP 1 'Y'
																	 FROM   LGCE_FP_TR.DBO.FP_SSP_STOCK_BACKUP_H SB (NOLOCK)
																	 WHERE  SB.FACTORY_ID  = F.FACTORY_ID
																	 AND    SB.CUTOFF_DATE = CONVERT(DATE, LGCE_FP_TR.DBO.[FN_SITE_TIME] ( F.SITE_ID ))) AS DATA_RECEIVE
																 , FACTORY_ID
															FROM   LGCE_FP_TR.DBO.SCM_FACTORY_M F (NOLOCK)
															WHERE  F.SHOP_GROUP_ID = 'A'
															AND    NOT EXISTS ( SELECT 1
																				FROM   LGCE_FP_TR.DBO.SCM_SYS_LOOKUP_VALUE SLV (NOLOCK)
																				WHERE  SLV.LOOKUP_TYPE_CODE = 'ABNORMAL_FACTORY'
																				AND    F.FACTORY_ID    = SLV.SEGMENT1
																				AND    SLV.ACTIVE_FLAG = 'Y' )
															AND    F.DIVISION_ID IN ('81','82', '81_UC') -- 2022-03-29 kimcd JV 가상 Division 추가.
															AND    EXISTS (  SELECT TOP 1 'Y'
																			 FROM   LGCE_FP_TR.DBO.FP_SSP_STOCK_BACKUP_H SB (NOLOCK)
																			 WHERE  SB.FACTORY_ID  = F.FACTORY_ID
																			 AND    SB.CUTOFF_DATE = CONVERT(DATE, LGCE_FP_TR.DBO.[FN_SITE_TIME] ( F.SITE_ID )-1))
															AND    CONVERT(NVARCHAR(20), LGCE_FP_TR.DBO.[FN_SITE_TIME] ( F.SITE_ID ), 120)
																	> (	SELECT DISTINCT DATEADD( HH, 1, CONVERT( DATETIME, CONVERT(NVARCHAR(11), LGCE_FP_TR.DBO.[FN_SITE_TIME] ( F.SITE_ID ), 120) +
																								LEFT(V.SEGMENT2, 2) +':'+ SUBSTRING(V.SEGMENT2, 3, 2) +':00'))
																		FROM   LGCE_FP_TR.DBO.SCM_SYS_LOOKUP_VALUE V  WITH(NOLOCK)
																		WHERE  V.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
																		AND    V.ACTIVE_FLAG = 'Y'
																		AND    V.SEGMENT1    = F.PLANT_ID ) ) A
															WHERE DATA_RECEIVE IS NULL
														;

														OPEN CUR_IF29;
														FETCH NEXT FROM CUR_IF29 INTO @PROC_NAME
														;
															WHILE (@@FETCH_STATUS = 0)
																BEGIN
																	INSERT INTO [SY_XIF_IFS_SMS_DATA] (
																		[IF_TYPE]
																		,[IF_ID]
																		,[IF_INS_DATE]
																		,[IF_FLAG]
																		,[IF_SND_DATE]
																		,[TR_SENDSTAT]
																		,[TR_MSGTYPE]
																		,[TR_PHONE]
																		,[TR_CALLBACK]
																		,[TR_MSG]
																	) VALUES (
																		'S'
																		,'OFP0_OSMS_SMS'
																		,GETDATE()
																		,'N'
																		,NULL
																		,'0'
																		,'0'
																		,@PHONE_NUM
																		,@PHONE_NUM
																		,@PROC_NAME + N'동 SSP 포장 대기 재고가 생성되지 않았습니다.'
																	)

																	FETCH NEXT FROM CUR_IF29 INTO @PROC_NAME
																	;
																END
														CLOSE CUR_IF29;
														DEALLOCATE CUR_IF29;
													END
												ELSE IF @MAIL_PKEY = 'FP_MAILING_IF30' AND @SEND_TYPE != 'MES' AND @SEND_TYPE != 'ENGINE' AND @SEND_TYPE NOT LIKE '%PI%' -- 2021-01-29 kimcd ERP 재고 없는 창고 메시지 전송
													BEGIN
														DECLARE CUR_IF30 CURSOR FOR
															SELECT 'Plant Id : ' + P.PLANT_ID + ', SLOC ID : ' + P.STORAGE_ID AS PROC_NAME
															FROM   (SELECT P.DIVISION_ID
																		 , P.SITE_ID
																		 , P.PLANT_ID
																		 , S.STORAGE_ID
																		 , (SELECT TOP 1 'Y'
																			FROM   LGCE_FP_TR.DBO.SCM_STOCK_H O (NOLOCK)
																			WHERE  O.CUTOFF_DATE = CONVERT(DATE,GETDATE(),120)
																			AND    O.STOCK_TYPE = 'INVENTORY'
																			AND    O.COMPANY_ID = P.COMPANY_ID
																			AND    O.DIVISION_ID = P.DIVISION_ID
																			AND    O.SITE_ID = P.SITE_ID
																			AND    O.PLANT_ID = P.PLANT_ID
																			AND    O.STORAGE_ID = S.STORAGE_ID ) AS DATA_CHECK
																	FROM  ( SELECT P.PLANT_ID, P.SITE_ID, P.COMPANY_ID, P.DIVISION_ID
																			FROM  ( SELECT P.PLANT_ID, P.SITE_ID, P.COMPANY_ID, P.DIVISION_ID
																					FROM   LGCE_FP_TR.DBO.SCM_SYS_LOOKUP_VALUE V  WITH(NOLOCK)
																							,LGCE_FP_TR.DBO.SCM_PLANT_M          P  WITH(NOLOCK)
																					WHERE  V.SEGMENT1 = P.PLANT_ID
																					AND    V.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
																					AND    V.ACTIVE_FLAG = 'Y'
																					AND    SUBSTRING(CONVERT(NVARCHAR(20), DATEADD(HOUR,-3, LGCE_FP_TR.DBO.[FN_SITE_TIME] ( P.SITE_ID )), 120), 12,8) 
																							< LEFT(V.SEGMENT2, 2) +':'+ SUBSTRING(V.SEGMENT2, 3, 2) +':00'
																					) P
																			WHERE EXISTS (SELECT 1
																							FROM   LGCE_FP_TR.DBO.JOB_SCHEDULE_HISTORY H WITH (NOLOCK)
																							WHERE  H.JOB_ID = 'PR_XIF_DW_INVENTORY_R'
																							AND    CONVERT(NVARCHAR(10), H.[CREATE_DATE], 112 ) = CONVERT(NVARCHAR(10), GETDATE(), 112 )
																							AND    H.[STATUS] = 'END'
																							-- START [IT20250117A] 하드코딩 변경
																							AND    H.GROUP_ID = CASE  WHEN P.SITE_ID = 'A001' THEN '999_0002'
																													--WHEN P.SITE_ID = 'A002' AND P.COMPANY_ID = 'G630' THEN '999_0064'
																													WHEN P.SITE_ID = 'A002' AND P.COMPANY_ID = @COMPANY_ID_NB THEN '999_0064'
																													WHEN P.SITE_ID = 'A002' THEN '999_0007'
																													--WHEN P.SITE_ID = 'A003'	AND P.COMPANY_ID = 'G670' THEN '999_0044'
																													WHEN P.SITE_ID = 'A003'	AND P.COMPANY_ID = @COMPANY_ID_GM THEN '999_0044'
																													
																													WHEN P.SITE_ID = 'A003'	THEN '999_0008'
																													WHEN P.SITE_ID = 'A004' THEN '999_0045'	END) ) P,
																							-- END [IT20250117A] 하드코딩 변경
																			( SELECT LOC.DIVISION_ID, LOC.PLANT_ID, LOC.STORAGE_ID 					
																			  FROM   LGCE_SCMPROD.DBO.SCM_MST_LOCATION LOC WITH(NOLOCK)	
																						LEFT OUTER JOIN LGCE_SCMPROD.DBO.SCM_MST_SITE MST_SITE	 WITH(NOLOCK)
																						ON  LOC.DIVISION_ID = MST_SITE.DIVISION_ID
																						AND LOC.SCM_SITE_ID = MST_SITE.SCM_SITE_ID
																			  WHERE  LOC.VALID_YN = 'Y'	
																			  AND    ISNULL(LOC.ATTRIBUTE1, 'Y') != 'N'	
																			  AND    LOC.STORAGE_ID != ''	
																			  AND	 MST_SITE.OPERATION_GROUP IS NOT NULL	
																			  AND	 MST_SITE.OSP_YN = 'N'	
																			  GROUP  BY LOC.DIVISION_ID, LOC.PLANT_ID, LOC.STORAGE_ID) S
																	WHERE P.PLANT_ID = S.PLANT_ID
																	AND   P.DIVISION_ID = S.DIVISION_ID ) P
															WHERE P.DATA_CHECK IS NULL

														OPEN CUR_IF30;
														FETCH NEXT FROM CUR_IF30 INTO @PROC_NAME
														;
															WHILE (@@FETCH_STATUS = 0)
																BEGIN
																	INSERT INTO [SY_XIF_IFS_SMS_DATA] (
																		[IF_TYPE]
																		,[IF_ID]
																		,[IF_INS_DATE]
																		,[IF_FLAG]
																		,[IF_SND_DATE]
																		,[TR_SENDSTAT]
																		,[TR_MSGTYPE]
																		,[TR_PHONE]
																		,[TR_CALLBACK]
																		,[TR_MSG]
																	) VALUES (
																		'S'
																		,'OFP0_OSMS_SMS'
																		,GETDATE()
																		,'N'
																		,NULL
																		,'0'
																		,'0'
																		,@PHONE_NUM
																		,@PHONE_NUM
																		,@PROC_NAME + N' 창고 재고가 수신 되지 않았습니다.'
																	)
																	FETCH NEXT FROM CUR_IF30 INTO @PROC_NAME
																END
															;
														CLOSE CUR_IF30;
														DEALLOCATE CUR_IF30;
													END
												ELSE IF @MAIL_PKEY = 'FP_MAILING_IF31' AND @SEND_TYPE != 'MES' AND @SEND_TYPE NOT LIKE '%PI%'  -- 2021-01-29 kimcd Release Alert
													BEGIN
														DECLARE CUR_IF31 CURSOR FOR
															-- 2021-10-29 kimcd Release 지연에서 release plan id NULL 처리
															SELECT ISNULL(A.RELEASE_PLAN_ID,PLAN_ID) +  ', ' + ISNULL(CONVERT( NVARCHAR(20), RELEASE_TIME, 120),'CONFIRM PENDING') + ',' + PLAN_GROUP_ID + N', MES Transfer Flag N'  AS MSG
															FROM   LGCE_FP_TR.DBO.SCM_FP_PLAN_GROUP_DETAIL_H A (NOLOCK),
																   LGCE_FP_TR.DBO.FP_INSTANCE_FACTORY_M FF (NOLOCK)
															WHERE  A.INSTANCE_ID = FF.INSTANCE_ID
															AND    A.MES_TRANSFER_FLAG = 'N'
															AND    FF.INSTANCE_TYPE != 'F'
															AND    A.PLAN_DATE >= CONVERT(NVARCHAR(8), DATEADD(DD, -1, GETDATE()),112)
															AND    A.UPDATE_TIME < (SELECT TOP 1 DATEADD( MI, -10, LGCE_FP_TR.DBO.[FN_SITE_TIME] ( F.SITE_ID ))
																					FROM   LGCE_FP_TR.DBO.SCM_FACTORY_M F(NOLOCK)
																					WHERE  FF.FACTORY_ID = F.FACTORY_ID)
															UNION
															-- 2021-10-29 kimcd Release 지연에서 release plan id NULL 처리
															SELECT ISNULL(A.RELEASE_PLAN_ID,PLAN_ID) +  ', ' + ISNULL(CONVERT( NVARCHAR(20), RELEASE_TIME, 120),'CONFIRM PENDING') + ',' + A.FACTORY_ID + N', MES Transfer Flag N'  AS MSG
															FROM   LGCE_FP_TR.DBO.SCM_FP_PLAN_DETAIL_H A (NOLOCK),
																   LGCE_FP_TR.DBO.FP_INSTANCE_FACTORY_M FF (NOLOCK)
															WHERE  A.INSTANCE_ID = FF.INSTANCE_ID
															AND    A.FACTORY_ID  = FF.FACTORY_ID
															AND    A.MES_TRANSFER_FLAG = 'N'
															AND    FF.INSTANCE_TYPE != 'F'
															AND    A.PLAN_DATE >= CONVERT(NVARCHAR(8), DATEADD(DD, -1, GETDATE()),112) 
															AND    A.UPDATE_TIME < (SELECT TOP 1 DATEADD( MI, -10, LGCE_FP_TR.DBO.[FN_SITE_TIME] ( F.SITE_ID ))
		     																		FROM   LGCE_FP_TR.DBO.SCM_FACTORY_M F (NOLOCK)
			    																	WHERE  A.FACTORY_ID = F.FACTORY_ID)
															UNION
															SELECT FP_PLAN_ID + ', ' + + CONVERT( NVARCHAR(20), INSERT_DTTM, 120) + ',' + PARAMETER5 + N', Release Batch 지연' AS MSG
															FROM   LGCE_FP_TR.DBO.[FP_NETJOB_QUEUE] A (NOLOCK)
															WHERE  PROC_NAME = 'PR_SCM_OF_RELEASE_AUTO_PROCESSING'
															AND    UPDATE_DTTM >= DATEADD(DD, -1, GETDATE())
															AND    UPDATE_DTTM < DATEADD(MI, -10, GETDATE())
															AND    JOB_TYPE IN ('R','P','E')   -- JOB_TYPE : R / P / C /E  : READY / PROCEEDING / COMPLETE / ERROR )
															AND    ISNULL(ERROR_TYPE,'N') != 'Y';

														OPEN CUR_IF31;
														FETCH NEXT FROM CUR_IF31 INTO @PROC_NAME
														;
															WHILE (@@FETCH_STATUS = 0)
																BEGIN
																	INSERT INTO [SY_XIF_IFS_SMS_DATA] (
																		[IF_TYPE]
																		,[IF_ID]
																		,[IF_INS_DATE]
																		,[IF_FLAG]
																		,[IF_SND_DATE]
																		,[TR_SENDSTAT]
																		,[TR_MSGTYPE]
																		,[TR_PHONE]
																		,[TR_CALLBACK]
																		,[TR_MSG]
																	) VALUES (
																		'S'
																		,'OFP0_OSMS_SMS'
																		,GETDATE()
																		,'N'
																		,NULL
																		,'0'
																		,'0'
																		,@PHONE_NUM
																		,@PHONE_NUM
																		,SUBSTRING(@PROC_NAME, 1, 80)
																	)

																	FETCH NEXT FROM CUR_IF31 INTO @PROC_NAME
																END
															;
														CLOSE CUR_IF31;
														DEALLOCATE CUR_IF31;
													END
												-- 2021-01-29 kimcd 추가 종료
												-- 2022-04-30 kimcd 추가 시작
												ELSE IF @MAIL_PKEY = 'FP_MAILING_IF33' AND @SEND_TYPE = 'IF'
													BEGIN
														DECLARE CUR_IF33 CURSOR FOR
														   SELECT N'[FP_LIVE]Tomcat 정상 수행'
														;

														OPEN CUR_IF33;
														FETCH NEXT FROM CUR_IF33 INTO @PROC_NAME
														;
															WHILE (@@FETCH_STATUS = 0)
																BEGIN
																	INSERT INTO [SY_XIF_IFS_SMS_DATA] (
																		[IF_TYPE]
																		,[IF_ID]
																		,[IF_INS_DATE]
																		,[IF_FLAG]
																		,[IF_SND_DATE]
																		,[TR_SENDSTAT]
																		,[TR_MSGTYPE]
																		,[TR_PHONE]
																		,[TR_CALLBACK]
																		,[TR_MSG]
																	) VALUES (
																		'S'
																		,'OFP0_OSMS_SMS'
																		,GETDATE()
																		,'N'
																		,NULL
																		,'0'
																		,'0'
																		,@PHONE_NUM
																		,@PHONE_NUM
																		,@PROC_NAME
																	)

																	FETCH NEXT FROM CUR_IF33 INTO @PROC_NAME
																	;
																END
														CLOSE CUR_IF33;
														DEALLOCATE CUR_IF33;
													END
												-- 2022-04-30 kimcd 추가 종료
												-- 2022-08-18 kimcd FP_MAILING_IF20 활성화 실적 추가 시작
												ELSE IF @MAIL_PKEY = 'FP_MAILING_IF20' AND @SEND_TYPE = 'IF'
													BEGIN
														DECLARE CUR_IF34 CURSOR FOR
														    SELECT F.FACTORY_ID
															FROM   SCM_FACTORY_M F (NOLOCK)
															WHERE  F.SHOP_GROUP_ID = 'A'
															AND    F.ACTIVE_FLAG   = 'Y'
															AND    F.FACTORY_ID   NOT IN ( 'S4', 'M9', 'A1')
															--AND    F.FACTORY_ID   != 'M9'
															AND    EXISTS ( SELECT TOP 1  1       
															                FROM   JOB_SCHEDULE_HISTORY  S (NOLOCK)
															                WHERE  ( S.JOB_ID = 'PR_XIF_DW_QUALITY_WIP_HISTORY_R' OR S.JOB_ID = 'PR_XIF_DW_QUALITY_WIP_HISTORY_PL_R' OR S.JOB_ID = 'PR_XIF_DW_QUALITY_WIP_HISTORY_M_R' OR S.JOB_ID = 'PR_XIF_MES_FORM_QUALITY_WIP_HIST_R' )
																			AND    CONVERT(NVARCHAR(10), S.[CREATE_DATE], 112 ) = CONVERT(NVARCHAR(10), GETDATE(), 112 )
																			AND    S.[STATUS] = 'END'
																			AND    F.SITE_ID = CASE WHEN S.GROUP_ID = '999_0002' THEN 'A001'
																			                        WHEN S.GROUP_ID = '999_0007' OR S.GROUP_ID = '999_0064' THEN 'A002'
																									WHEN S.GROUP_ID = '999_0008' OR S.GROUP_ID = '999_0044' THEN 'A003'
																									WHEN S.GROUP_ID = '999_0045' THEN 'A004' END
																			-- START [IT20250117A] 하드코딩 변경
															                --AND    ( ( F.COMPANY_ID != 'G630' AND GROUP_ID != '999_0064' ) OR ( F.COMPANY_ID = 'G630'  AND GROUP_ID = '999_0064' ))
																			--AND    ( ( F.COMPANY_ID != 'G670' AND GROUP_ID != '999_0044' ) OR ( F.COMPANY_ID = 'G670'  AND GROUP_ID = '999_0044' ))
																			AND    ( ( F.COMPANY_ID != @COMPANY_ID_NB AND GROUP_ID != '999_0064' ) OR ( F.COMPANY_ID = @COMPANY_ID_NB  AND GROUP_ID = '999_0064' ))
																			AND    ( ( F.COMPANY_ID != @COMPANY_ID_GM AND GROUP_ID != '999_0044' ) OR ( F.COMPANY_ID = @COMPANY_ID_GM  AND GROUP_ID = '999_0044' ))
																			)
															AND    NOT EXISTS (SELECT 1
															                   FROM   SCM_SYS_LOOKUP_VALUE SLV(NOLOCK)
																	  		   WHERE  SLV.LOOKUP_TYPE_CODE = 'ABNORMAL_FACTORY'
																		  	   AND    SLV.SEGMENT1    = F.FACTORY_ID
																			   AND   ISNULL(SLV.ATTRIBUTE2, 'N')  != 'Y'  -- 2024-01-02 kimcd 조건 추가
																			   AND    SLV.ACTIVE_FLAG = 'Y')
															AND    PLANT_ID NOT IN (SELECT SEGMENT2 FROM SCM_CODE_LOOKUP_VALUE WHERE LOOKUP_TYPE_CODE = 'PR_SCM_MAIL_SEND' AND SEGMENT1 = '0' AND ACTIVE_FLAG = 'Y') --( 'G182') --1.22
															--END [IT20250117A] 하드코딩 변경
															AND    NOT EXISTS ( SELECT A.SITE_ID
															                    FROM   SCM_DAILY_PRODUCT_RESULT_H A WITH (NOLOCK)
																				WHERE  CONVERT(NVARCHAR(10), A.[UPDATE_TIME], 112 ) = CONVERT(NVARCHAR(10), GETDATE(), 112 )
																				AND    A.OPERATION_ID IN ('F4000', 'F4700', 'F6000')
																				AND    A.UPDATE_ID    IN ('PR_XIF_DW_QUALITY_WIP_HISTORY_R', 'PR_XIF_DW_QUALITY_WIP_HISTORY_PL_R', 'PR_XIF_DW_QUALITY_WIP_HISTORY_M_R','PR_XIF_MES_FORM_QUALITY_WIP_HIST_R')
																				AND    A.COMPANY_ID    = F.COMPANY_ID
																				AND    A.DIVISION_ID   = F.DIVISION_ID
																				AND    A.SITE_ID       = F.SITE_ID
																				AND    A.PLANT_ID      = F.PLANT_ID
																				AND    A.FACTORY_ID    = F.FACTORY_ID
																				GROUP BY SITE_ID )
														;

														OPEN CUR_IF34;
														FETCH NEXT FROM CUR_IF34 INTO @PROC_NAME
														;
															WHILE (@@FETCH_STATUS = 0)
																BEGIN
																	INSERT INTO [SY_XIF_IFS_SMS_DATA] (
																		[IF_TYPE]
																		,[IF_ID]
																		,[IF_INS_DATE]
																		,[IF_FLAG]
																		,[IF_SND_DATE]
																		,[TR_SENDSTAT]
																		,[TR_MSGTYPE]
																		,[TR_PHONE]
																		,[TR_CALLBACK]
																		,[TR_MSG]
																	) VALUES (
																		'S'
																		,'OFP0_OSMS_SMS'
																		,GETDATE()
																		,'N'
																		,NULL
																		,'0'
																		,'0'
																		,@PHONE_NUM
																		,@PHONE_NUM
																		,@PROC_NAME + N'동 활성화 실적 수신되지 않았습니다.'
																	)

																	FETCH NEXT FROM CUR_IF34 INTO @PROC_NAME
																	;
																END
														CLOSE CUR_IF34;
														DEALLOCATE CUR_IF34;
													END
												-- 2022-08-18 kimcd FP_MAILING_IF20 활성화 실적 추가 종료

												FETCH NEXT FROM CUR_SMS INTO @PHONE_NUM
																			 ,@SEND_TYPE
												;
											END;
										CLOSE CUR_SMS;
										DEALLOCATE CUR_SMS;
									 END
							end
									
						ELSE
						    BEGIN
								UPDATE [dbo].[SCM_MAILING_H]
								   SET [MAIL_DATETIME]   = GETDATE()
									   ,[MAIL_SEND_FLAG] = 'E'
									   ,[MESSAGE]        = 'ERROR_CODE : '+CONVERT(VARCHAR,@RtnCode)
									   ,[MODIFY_USER_ID] = @v_proc_name
									   ,[MODIFY_DATE]    = GETDATE()
								 WHERE [MAIL_PKEY]       = @MAIL_PKEY
								   AND [MAIL_SEQ]        = @MAIL_SEQ
						    
							END

				END TRY
				
				BEGIN CATCH
						 UPDATE [dbo].[SCM_MAILING_H]
						    SET [MAIL_DATETIME]   = getdate()
							   ,[MAIL_SEND_FLAG]  = 'E'
							   ,[MESSAGE]         = ERROR_MESSAGE()
							   ,[MODIFY_USER_ID]  = @v_proc_name
							   ,[MODIFY_DATE]     = getdate()
						  WHERE [MAIL_PKEY]       = @MAIL_PKEY
						    AND [MAIL_SEQ]        = @MAIL_SEQ
						  ;							
				
				END CATCH


						   	
			FETCH NEXT FROM CUR_MAILING_LIST INTO    @MAIL_PKEY
													,@MAIL_SEQ
													,@MAIL_SUBJECT
													,@MAIL_BODY
													,@MAIL_QUERY
													,@ATTACH_FILE_NAME
													,@MAIL_RECEIVER_LIST
													,@MAIL_PROFILE_NAME
													,@MAIL_SEND_FLAG
											 ;
		  END;

		  CLOSE CUR_MAILING_LIST;
		  DEALLOCATE CUR_MAILING_LIST;      


		-- ================================================
		-- 로직 추가 end
		-- ================================================
		COMMIT TRAN

		EXEC PR_XIF_LOG @v_proc_name, NULL, 'END', @ROWCOUNT, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
		
	END TRY

	BEGIN CATCH
		CLOSE CUR_MAILING_LIST;
		DEALLOCATE CUR_MAILING_LIST;

	    ROLLBACK TRAN
		-- 에러나도 로그는 인서트
		SET @v_descr = ERROR_MESSAGE()
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate

	END CATCH

END
