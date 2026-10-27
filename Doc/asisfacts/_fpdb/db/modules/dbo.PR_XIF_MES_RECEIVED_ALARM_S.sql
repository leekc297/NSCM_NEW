CREATE PROCEDURE [dbo].[PR_XIF_MES_RECEIVED_ALARM_S]

-- ================================================================================================
-- Program ID          : FP01671
-- Program Name        : PR_XIF_MES_RECEIVED_ALARM_S
-- Param               :
-- Batch Period        : realtime
-- Description         : MES 정보  Mailing
--
-- Source System       : 
-- Destination System  : 
-- Source Table        : SCM_MAILING_H
-- Destination Table   : 
--
-- Create Date		   : 2022-09-27
-- Update Date		   : 2022.10.20 leeseongmin 1.1 
--                       2022.11.03 leeseongmin 1.2
--
--
-- Author              : leeseonmgin
-- Version             : 1.0
--                       1.1 2022-10-26 leeseongmin SMS 발송내용 변경
--                       1.2 2022-11-03 leeseongmin 중국 SMS 추가
-- ================================================================================================
-- PARAMETER
@factory_site_id    NVARCHAR(100) ,
@start_time         NVARCHAR(100) 

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

    DECLARE @lookup_type_code   NVARCHAR(100) ='SMS_ADDRESSEE'
    DECLARE @work_type          NVARCHAR(100) ='MES_RECEIVED'

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_MES_RECEIVED_ALARM_S'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	   = 0
	DECLARE @sysdate     DATETIME      = GETDATE()

	DECLARE @ROWCOUNT    INTEGER

	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)
	DECLARE @data_s      INTEGER
	-- ================================================
    -- Declare start
	-- ================================================
	DECLARE @TABLE_BODY            NVARCHAR(MAX) -- 메일본분

	DECLARE @CONTENT               NVARCHAR(MAX) -- SMS 내용
	DECLARE @MAIL_TITLE            NVARCHAR(MAX) -- 메일제목
	DECLARE @MAIL_RECEIVER_LIST    NVARCHAR(MAX) -- 수신리스트
	DECLARE @ADDR_LIST			   NVARCHAR(4000) 

	DECLARE @MAIL_WIDTH			   NUMERIC = 1650;	-- 메일 화면 넓이

	DECLARE @PHONE_NUM			   NVARCHAR(30)	 --SMS 송신위한 전화 번호

	DECLARE @CHECK_CHINA		   NVARCHAR(30)	 --2022-11-03 leeseongmin 중국 SMS 추가
	-- ================================================
    -- Declare end
	-- ================================================

	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	-- Start 로그는 무조건 남김
	INSERT [LGCE_INFDEV].[dbo].[XIF_LOG_HISTORY](
			  PROC_NAME, 
              TABLE_NAME, 
              LOG_TYPE, 
              LOG_COUNT, 
              LOG_CODE, 
              MESSAGE, 
              DESCR,
			  EVENT_DTTM)
     VALUES (
              @v_proc_name, 
              NULL, 
             'START', 
              NULL, 
              @v_temp1, 
              '############### Start of procedure ###############', 
              NULL,
			  @sysdate)

	

    	-- ================================================
		-- 로직 추가 start
		-- ================================================
		   
			SET @MAIL_TITLE = 'Alarm ready to create plan'

			-- SET @CONTENT =  'Reference information create a production plan is complete.'
			-- 2022-10-26 leeseongmin SMS 발송내용 변경    
			SET @CONTENT =  'Reference informations are ready to create FP plan.'
								
			SET @TABLE_BODY = '	<html>
									<head>
										<title>Untitled Document</title>
										<style>
   											* {margin:0;padding:0;}
   											body {font-family:Malgun Gothic, Arial, Helvetica, sans-serif;font-size:12px;line-height:1.8;color:#333333;}
   											table {border-collapse:collapse;width:100%;}
   											table th {background:#f5f5f5;border-bottom:1px solid #e1e1e1;}
   											table td {background:#fff;border-right:1px solid #e1e1e1;border-left:1px solid #e1e1e1;border-bottom:1px solid #e1e1e1;}
   											table tbody th {border-left:1px solid #e1e1e1;text-align:right;padding:6px 8px;}
   											table tbody td {text-align:left;padding:6px 8px;}
   											table thead th {text-align:center;padding:3px;border-right:1px solid #e1e1e1;border-left:1px solid #e1e1e1; border-bottom:1px solid #d1d1d1;}
											.hori-table table thead td {text-align:center;padding:3px;}  
   											.hori-table table tbody td {text-align:center;padding:3px;}
   											.vertical-table, .hori-table {margin-bottom:20px;}
										</style>
									</head>
									<body>' + REPLACE(ISNULL(@MAIL_TITLE, ''), CHAR(10), '<br>') + '
   										<br>
   										<div class=''wrap''> '
                                             + N'생산계획 생성을 위한 참조정보(실적, 재고, 기준정보 등) 준비가 완료되었습니다. '
       										 + ' <br>  Reference information(production result, inventory, master data, etc.) to create a production plan is complete. <br>'
                                             + N' 创建生产计划的参考情报（生产结果、库存、基准数据其他）完成。
   										</div>
									</body>
								</html>'



			DECLARE CUR_MES_MAIL_LIST CURSOR FOR							--instance별 MAIL 수신자  조회
				SELECT ATTRIBUTE1,ATTRIBUTE3	
				  FROM [DBO].[SCM_SYS_LOOKUP_VALUE] WITH(NOLOCK)
				 WHERE LOOKUP_TYPE_CODE = 'SMS_ADDRESSEE'
				   AND SEGMENT1 = 'MES_RECEIVED'
				   AND SEGMENT3 = @factory_site_id
				   AND SEGMENT4 = @start_time
				   AND ATTRIBUTE4 = 'Y'      -- MAIL_YN
				 ORDER BY CAST(SEGMENT2 AS INT)

		  OPEN CUR_MES_MAIL_LIST;

		   SET @MAIL_RECEIVER_LIST = '';
			FETCH NEXT FROM CUR_MES_MAIL_LIST INTO @PHONE_NUM
			                                      ,@ADDR_LIST
			WHILE (@@FETCH_STATUS = 0)
				BEGIN

				   -----------------MAIL-----------------	

			   SET @MAIL_RECEIVER_LIST =  @MAIL_RECEIVER_LIST+';'+ @ADDR_LIST

					IF @ADDR_LIST IS NOT NULL
						BEGIN

							EXEC  msdb.dbo.sp_send_dbmail @profile_name		= 'FP_MAIL_TEST'  -- 개발 메일계정 _TEST 삭제해야 운영에서발송
												   , @recipients             = @MAIL_RECEIVER_LIST
												   , @query_result_separator = ';'
												   , @subject                = @MAIL_TITLE
												   , @body                   = @TABLE_BODY
												   , @body_format            = 'html' ;	
						END	

				SET @MAIL_RECEIVER_LIST = ''; -- 2022-10-26 leeseongmin IF 밖으로 이동작업

				FETCH NEXT FROM CUR_MES_MAIL_LIST INTO @PHONE_NUM
				                                      ,@ADDR_LIST
				;
			END;
		
		CLOSE CUR_MES_MAIL_LIST;
		DEALLOCATE CUR_MES_MAIL_LIST;



		DECLARE CUR_MES_SMS_LIST CURSOR FOR							--instance별 SMS 수신자  조회
				SELECT ATTRIBUTE1,ATTRIBUTE3,ATTRIBUTE6	            -- 2022-11-03 leeseongmin 중국 SMS 추가	
				  FROM [DBO].[SCM_SYS_LOOKUP_VALUE] WITH(NOLOCK)
				 WHERE LOOKUP_TYPE_CODE = 'SMS_ADDRESSEE'
				   AND SEGMENT1 = 'MES_RECEIVED'
				   AND SEGMENT3 = @factory_site_id
				   AND SEGMENT4 = @start_time
				   AND ACTIVE_FLAG = 'Y'   -- Active
				 ORDER BY CAST(SEGMENT2 AS INT)

		  OPEN CUR_MES_SMS_LIST;

		   SET @MAIL_RECEIVER_LIST = '';
			FETCH NEXT FROM CUR_MES_SMS_LIST INTO @PHONE_NUM
			                                      ,@ADDR_LIST
												  ,@CHECK_CHINA  -- 2022-11-03 leeseongmin 중국 SMS 추가
			WHILE (@@FETCH_STATUS = 0)
							
						BEGIN
						 IF @PHONE_NUM IS NOT NULL

						 -----------------SMS NJ-----------------	
						  IF @CHECK_CHINA = 'CHINA' -- 2022-11-03 leeseongmin 중국 SMS 추가
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
									,'lgecom3'
									,CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112) + REPLACE(CONVERT(CHAR(8), CURRENT_TIMESTAMP, 108),':','')
									,'KIMCD'
									,@PHONE_NUM
									,NULL --CALLNAME
									,'86'
									,@PHONE_NUM
									,'plan ready'
									,@CONTENT
									,'FP'
									,'I'
							)
						   END;

						  ELSE 
						
						  BEGIN
						 -----------------SMS -----------------	
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
															,'OFP0_OSMS_SMS_DEV'    -- 운영에서 _DEV삭제해야 SMS발송
															,GETDATE()
															,'N'
															,NULL
															,'0'
															,'0'
															,@PHONE_NUM
															,@PHONE_NUM
															,@CONTENT	-- 메세지내용															
														);
					 END												


				FETCH NEXT FROM CUR_MES_SMS_LIST INTO @PHONE_NUM
				                                      ,@ADDR_LIST
												      ,@CHECK_CHINA  -- 2022-11-03 leeseongmin 중국 SMS 추가
				;
			END;
			
		CLOSE CUR_MES_SMS_LIST;
		DEALLOCATE CUR_MES_SMS_LIST;


		-- ================================================
		-- 로직 추가 end
		-- ================================================


	  INSERT [LGCE_INFDEV].[dbo].[XIF_LOG_HISTORY](
			  PROC_NAME, 
              TABLE_NAME, 
              LOG_TYPE, 
              LOG_COUNT, 
              LOG_CODE, 
              MESSAGE, 
              DESCR,
			  EVENT_DTTM)
      VALUES (
              @v_proc_name, 
              NULL, 
             'END', 
              NULL, 
              @v_temp2, 
              '############### End of procedure ###############', 
              NULL,
			  @sysdate)

END
