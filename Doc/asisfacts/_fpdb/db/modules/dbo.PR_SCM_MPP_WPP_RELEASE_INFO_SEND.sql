CREATE PROCEDURE [dbo].[PR_SCM_MPP_WPP_RELEASE_INFO_SEND]

-- ================================================================================================
-- Program ID          : 
-- Program Name        : PR_SCM_MPP_WPP_RELEASE_INFO_SEND
-- Param               :
-- Batch Period        : realtime
-- Description         : RELEASE 정보  Mailing
--
-- Source System       : 
-- Destination System  : 
-- Source Table        : SCM_MAILING_H
-- Destination Table   : 
--
-- Create Date		   : 2018.04.05
-- Update Date		   : 2018.04.24 PIYONG 1.1
--						 2018.08.29 PIYONG 1.2
--						 2018.10.08 PIYOMG 1.3
--						 2020.10.16 KIMCD  1.4
--                       2021.06.24 KIMCD  1.5

-- Author              : 
-- Version             : 1.0
--						 1.1 2018-04-24 WPP 전송 여부 체크 조건 변경
--						 1.2 2018-08-29 정인천 책임 요청으로 전극WPP 전송 체크 기간을 금~월로 변경
--						 1.3 2018-10-08 정인천C 요청으로 INSTANCE가 전극이 아닌 경우 금~월 ->수~일 변경
--                       1.4 2020-10-16	kimcd 전극 배포 일 범위를 전주 금요일부터로 변경.
--                                            Instance factory 검증에서 active flag 추가
--                       1.5 2021-06-24	kimcd 전극 외 Instance의 계획 배포 일자를 월요일까지 포함
-- ================================================================================================
-- PARAMETER
@site_id  NVARCHAR(100) =  'A001'


AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_SCM_MPP_WPP_RELEASE_INFO_SEND'
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
	DECLARE @TABLE_BODY            NVARCHAR(MAX)
	DECLARE @TABLE_CONTENTS        NVARCHAR(MAX) = ''
--	DECLARE @TABLE_HEAD_CONTENT    NVARCHAR(MAX)
	DECLARE @MAIL_CONTENT          NVARCHAR(MAX)
	DECLARE @MAIL_TITLE            NVARCHAR(MAX)

	DECLARE @MAIL_RECEIVER_LIST    NVARCHAR(4000)

	SET @ROWCOUNT = @@ROWCOUNT

	DECLARE @INSTANCE_ID			NVARCHAR(20)
    DECLARE @MAIL_ADDR				NVARCHAR(MAX)

	DECLARE @MONTH					NVARCHAR(10)
	DECLARE @WEEK					NVARCHAR(10)
	DECLARE @DIVISION_ID			NVARCHAR(100)
	DECLARE @INSTANCE_NAME			NVARCHAR(1000)
	DECLARE @MPP_SEND_YN			NVARCHAR(1)
	DECLARE @WPP_SEND_YN			NVARCHAR(1)


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
			-- INSTANCE별 전송 여부 조회
			SELECT ST.INSTANCE_ID
				   , ST.INSTANCE_NAME
				   , ST.COMPANY_ID
				   , ST.DIVISION_ID
				   , ST.SITE_ID
				   , MM.YEAR+MM.MONTH AS MONTH 
				   , MM.WEEK
				   , MM.WEEKSTART_DATE AS WEEK_DATE
				   , ISNULL( (SELECT TOP 1 'O'     
								FROM FP_MPP_WPP_BASE_PLAN_H BP (NOLOCK)    
							   WHERE BP.MPP = 'Y'    
								 AND BP.PLAN_MONTH = MM.YEAR + MM.MONTH    
								 AND BP.INSTANCE_ID = ST.INSTANCE_ID), 'X') AS MPP_SEND_YN
				   , ISNULL( (SELECT TOP 1 'O'    
							    FROM FP_MPP_WPP_BASE_PLAN_H BP (NOLOCK)    
							   WHERE BP.WPP = 'Y'    
								 --2018-04-24 PIYONG  조건 추가 시작
								 AND BP.PLAN_WEEK IN( MM.WEEK, (SELECT WEEK
																  FROM SCM_SYS_CALENDAR_M WITH(NOLOCK)
																 WHERE DATE_ID = CONVERT( DATE,  GETDATE()-7, 112) ) )			 --당주, 전주
								 AND ( (ST.INSTANCE_TYPE LIKE 'E%' AND BP.UPDATE_TIME >=  DATEADD(D,-3,MM.WEEKSTART_DATE) AND BP.UPDATE_TIME < DATEADD(D,2,MM.WEEKSTART_DATE))	-- 2020-10-16 kimcd 전극 배포 일 범위를 전주 금요일부터로 변경. --전극 토~화
										OR (ST.INSTANCE_TYPE NOT LIKE 'E%' AND BP.UPDATE_TIME >= DATEADD(D,-5 ,MM.WEEKSTART_DATE) 
																		   AND BP.UPDATE_TIME < DATEADD(D, 1,MM.WEEKSTART_DATE) )   -- 2021-06-24 kimcd 전극 외 월요일 배포도 허용 --전극X --PIYONG 2018-10-08 CHANGE 금~월 ->수~일
									 )
							--2018-04-24 PIYONG  조건 추가 끝
								AND BP.INSTANCE_ID = ST.INSTANCE_ID), 'X')   AS WPP_SEND_YN
		     INTO #STANDARD_INFO
			 FROM (
					SELECT SL.SEGMENT1 AS INSTANCE_ID
						   , SL.SEGMENT2 AS INSTANCE_NAME
						   , SIF.COMPANY_ID
						   , SIF.DIVISION_ID
						   , SIF.SITE_ID
						   , SIF.INSTANCE_TYPE       
					  FROM SCM_SYS_LOOKUP_VALUE  SL (NOLOCK)      
						   , (SELECT SIF.COMPANY_ID
									 , SIF.DIVISION_ID
									 , SIF.SITE_ID
									 , SIF.INSTANCE_ID
									 , SIF.INSTANCE_TYPE
								FROM ( SELECT F.COMPANY_ID
											  , F.DIVISION_ID
											  , F.SITE_ID
											  , SIF.INSTANCE_ID
											  , SIF.INSTANCE_TYPE
											  , ROW_NUMBER() OVER (PARTITION BY SIF.INSTANCE_ID ORDER BY SIF.FACTORY_ID) AS ROW_NUM     
										 FROM FP_INSTANCE_FACTORY_M SIF (NOLOCK)  
											  ,SCM_FACTORY_M          F (NOLOCK)
										WHERE SIF.FACTORY_ID = F.FACTORY_ID
										  AND F.SITE_ID = @site_id
										  AND SIF.ACTIVE_FLAG = 'Y' -- 2020-10-16 kimcd 현재 사용하는 동만 추출
									 ) SIF  
							   WHERE SIF.ROW_NUM = 1
						   ) SIF     
					 WHERE SL.SEGMENT1 = SIF.INSTANCE_ID      
					   AND SL.LOOKUP_TYPE_CODE = 'INSTANCE_ID'      
					   AND SL.ACTIVE_FLAG = 'Y'      
					   AND SL.SEGMENT1 NOT LIKE '%FORM_T%'      
					   AND SL.SEGMENT1 NOT LIKE '%POST%'      
					   AND SL.SEGMENT1 != 'KR_CELL_M_P'
					   AND ( (SIF.INSTANCE_TYPE LIKE 'E%' AND DATEPART(WEEKDAY, GETDATE()) = 3) OR (SIF.INSTANCE_TYPE NOT LIKE 'E%' AND DATEPART(WEEKDAY, GETDATE()) = 2) )
				  ) ST
				  , (
					  SELECT YEAR
						     , MONTH
						     , WEEK
						     , WEEKSTART_DATE
					    FROM SCM_SYS_CALENDAR_M WITH(NOLOCK)
					   WHERE DATE_ID = CONVERT( DATE,  GETDATE(), 112) 
				  )  MM



			DECLARE CUR_INSTANCE_LIST CURSOR FOR				
				 SELECT SEGMENT2, ATTRIBUTE1						--instance별 MAIL 수신자  조회
				   FROM [DBO].[SCM_SYS_LOOKUP_VALUE] WITH(NOLOCK)
				  WHERE LOOKUP_TYPE_CODE = 'MPP_WPP_RELEASE_INFO_MAIL'
					AND SEGMENT1 = @site_id
					AND ACTIVE_FLAG = 'Y'


			OPEN CUR_INSTANCE_LIST;
		
			FETCH NEXT FROM CUR_INSTANCE_LIST INTO @INSTANCE_ID
												   ,@MAIL_ADDR
			WHILE (@@FETCH_STATUS = 0)
				BEGIN
					SET @MAIL_TITLE = N'[DEV-Notification]MPP WPP SEND Check('+ SUBSTRING(CONVERT(NVARCHAR(10),GETDATE(), 102), 3, 8)+')'

					SET @MAIL_CONTENT = N'INSTANCE '+@INSTANCE_ID+N'     MPP WPP 전송 여부'
					SET @MAIL_RECEIVER_LIST = ''
					SET @TABLE_CONTENTS = ''


				DECLARE CUR_DATA_LIST CURSOR FOR				--INSTANCE 별 발송
					SELECT MONTH
						   ,WEEK
						   ,DIVISION_ID
						   ,INSTANCE_NAME
						   ,MPP_SEND_YN
						   ,WPP_SEND_YN
					  FROM (
							SELECT MONTH
								   ,WEEK
								   ,DIVISION_ID
								   ,INSTANCE_NAME
								   ,MPP_SEND_YN
								   ,WPP_SEND_YN
							  FROM #STANDARD_INFO
							 WHERE INSTANCE_ID = @INSTANCE_ID
						   ) A
					 WHERE MPP_SEND_YN = 'X'
					    OR WPP_SEND_YN = 'X'
					 ORDER BY MONTH
						   ,WEEK
						   ,DIVISION_ID
						   ,INSTANCE_NAME
						   ,MPP_SEND_YN
						   ,WPP_SEND_YN


				OPEN CUR_DATA_LIST;
		
				FETCH NEXT FROM CUR_DATA_LIST INTO @MONTH
													,@WEEK
												    ,@DIVISION_ID
												    ,@INSTANCE_NAME
												    ,@MPP_SEND_YN
												    ,@WPP_SEND_YN
												    

				WHILE (@@FETCH_STATUS = 0)
					BEGIN

						SET @TABLE_CONTENTS = @TABLE_CONTENTS+'<tr>'

						SET @TABLE_CONTENTS = @TABLE_CONTENTS + '<td >'+@MONTH+'</td>'																				
						

						SET @TABLE_CONTENTS = @TABLE_CONTENTS	+'<td>'+@WEEK+'</td>'
																+'<td>'+@DIVISION_ID+'</td>'
																+'<td>'+@INSTANCE_NAME+'</td>'

						SET @TABLE_CONTENTS = 	CASE WHEN @MPP_SEND_YN = 'X' THEN
														@TABLE_CONTENTS+'<td style=''FONT-WEIGHT: bold; color:red;''>'+@MPP_SEND_YN+'</td>'
												     ELSE
														@TABLE_CONTENTS+'<td>'+@MPP_SEND_YN+'</td>'
													  END

						SET @TABLE_CONTENTS = 	CASE WHEN @WPP_SEND_YN = 'X' THEN
														@TABLE_CONTENTS+'<td style=''FONT-WEIGHT: bold; color:red;''>'+@WPP_SEND_YN+'</td>'
												     ELSE
														@TABLE_CONTENTS+'<td>'+@WPP_SEND_YN+'</td>'
													  END
												
													  
						SET @TABLE_CONTENTS = @TABLE_CONTENTS+'</tr>'

					FETCH NEXT FROM CUR_DATA_LIST INTO @MONTH
													,@WEEK
												    ,@DIVISION_ID
												    ,@INSTANCE_NAME
												    ,@MPP_SEND_YN
												    ,@WPP_SEND_YN
													
					;
					END;
			
				CLOSE CUR_DATA_LIST;
				DEALLOCATE CUR_DATA_LIST;

				SET @TABLE_BODY = '  	<html>
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
								<body>' +
								REPLACE(ISNULL(@MAIL_CONTENT, ''), CHAR(10), '<br>') + '
   									<br>
   									<div class=''wrap''>
       									<div class=''hori-table''>
           									<table style=''border-top:2px solid #c8294b; width:1020px;''>
               									<thead>' 
													+N'<tr>
														<th ROWSPAN = ''2''>Month</th>
														<th ROWSPAN = ''2''>WEEK</th>
														<th ROWSPAN = ''2''>Division</th>
														<th ROWSPAN = ''2''>INSTANCE_NAME</th>
														<th COLSPAN = ''2''>Status</th>
													</tr>
													<tr>
														<th>MPP</th>
														<th>WPP</th>
													</tr>
													'
               									+'</thead>
               									<tbody>' + ISNULL(@TABLE_CONTENTS, '') + '</tbody>
											</table>
       									</div>
   									</div>
								</body>
								</html>'

				SET @MAIL_RECEIVER_LIST = 'kimcd@lgespartner.com;'+ISNULL( @MAIL_ADDR, '')

				IF LEN(@TABLE_CONTENTS) > 0
					BEGIN
						exec msdb.dbo.sp_send_dbmail @profile_name           =  'FP_MAIL_TEST'
													 , @recipients             = @MAIL_RECEIVER_LIST
													 , @query_result_separator = ';'
													 , @subject                = @MAIL_TITLE
													 , @body                   = @TABLE_BODY
													 , @body_format            = 'html'
					 END

				FETCH NEXT FROM CUR_INSTANCE_LIST INTO @INSTANCE_ID
										    ,@MAIL_ADDR
													
				;
			END;
			
		CLOSE CUR_INSTANCE_LIST;
		DEALLOCATE CUR_INSTANCE_LIST;


		-- ================================================
		-- 로직 추가 end
		-- ================================================
		COMMIT TRAN

		EXEC PR_XIF_LOG @v_proc_name, NULL, 'END', @ROWCOUNT, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
		
	END TRY

	BEGIN CATCH
	    ROLLBACK TRAN
		-- 에러나도 로그는 인서트
		SET @v_descr = ERROR_MESSAGE()
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate

	END CATCH

END
