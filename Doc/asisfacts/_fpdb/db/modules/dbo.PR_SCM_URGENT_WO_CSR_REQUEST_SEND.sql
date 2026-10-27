CREATE PROCEDURE [dbo].[PR_SCM_URGENT_WO_CSR_REQUEST_SEND]

-- ================================================================================================
-- Program ID          : 
-- Program Name        : PR_SCM_URGENT_WO_CSR_REQUEST_SEND
-- Param               :
-- Batch Period        : realtime
-- Description         : RELEASE 정보  Mailing
--
-- Source System       : 
-- Destination System  : 
-- Source Table        : SCM_MAILING_H
-- Destination Table   : 
--
-- Create Date		   : 2018.01.30
-- Update Date		   : 

-- Author              : 
-- Version             : 1.0

-- ================================================================================================
-- PARAMETER


AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_SCM_URGENT_WO_CSR_REQUEST_SEND'
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
	DECLARE @MAIL_CONTENT          NVARCHAR(MAX)
	DECLARE @MAIL_TITLE            NVARCHAR(MAX)

	DECLARE @MAIL_RECEIVER_LIST    NVARCHAR(4000)

	DECLARE @WO_BASE_DATE		    NVARCHAR(10) = ''
	DECLARE @FACTORY_ID				NVARCHAR(50) = ''
	DECLARE @LINE_ID				NVARCHAR(50) = ''
	DECLARE @OPERATION_ID			NVARCHAR(50) = ''
	DECLARE @ITEM_ID				NVARCHAR(50) = ''
	DECLARE @ORDER_TYPE				NVARCHAR(50) = ''
	DECLARE @START_TIME				NVARCHAR(50) = ''
	DECLARE @END_TIME				NVARCHAR(50) = ''
	DECLARE @MARKET					NVARCHAR(1) = ''
	DECLARE @REQUESTER				NVARCHAR(50) = ''

	DECLARE @REC_CNT				NUMERIC(10,0) = 0
	DECLARE @CNT					NUMERIC(10,0) = 1

	SET @ROWCOUNT = @@ROWCOUNT

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

		DECLARE CUR_REQUESTER_LIST CURSOR FOR				
			SELECT SUBSTRING(WO_BASE_DATE, 1, 4 ) + '-'+SUBSTRING(WO_BASE_DATE, 5, 2 )+'-'+SUBSTRING(WO_BASE_DATE, 7, 2 ) AS WO_BASE_DATE
				   , FACTORY_ID
				   , LINE_ID
				   , OPERATION_ID
				   , ITEM_ID
				   , ORDER_TYPE
				   , SUBSTRING(START_TIME, 1, 4 ) + '-'+SUBSTRING(START_TIME, 5, 2 )+'-'+SUBSTRING(START_TIME, 7, 2 )+' '+SUBSTRING(START_TIME, 9, 2 )+':'+SUBSTRING(START_TIME, 11, 2 )  AS START_TIME
				   , SUBSTRING(END_TIME, 1, 4 ) + '-'+SUBSTRING(END_TIME, 5, 2 )+'-'+SUBSTRING(END_TIME, 7, 2 )+' '+SUBSTRING(END_TIME, 9, 2 )+':'+SUBSTRING(END_TIME, 11, 2 )  AS END_TIME
				   , MARKET
				   , REQUESTER
				   , COUNT(REQUESTER) OVER( PARTITION BY WO_BASE_DATE, REQUESTER ORDER BY REQUESTER, WO_BASE_DATE   ) AS REC_CNT
			  FROM SCM_MANUAL_WO_CREATE
			 WHERE STATUS = 'INSERT'
			   AND PROCESSING_YN = 'Y'
			   AND REQUESTER IS NOT NULL
			   AND CSR_ID IS NULL
			   AND WO_BASE_DATE >= '20171214'
			 ORDER BY REQUESTER, WO_BASE_DATE, START_TIME, OPERATION_ID desc


		OPEN CUR_REQUESTER_LIST;
		
		FETCH NEXT FROM CUR_REQUESTER_LIST INTO @WO_BASE_DATE
												,@FACTORY_ID
												,@LINE_ID
												,@OPERATION_ID
												,@ITEM_ID
												,@ORDER_TYPE
												,@START_TIME
												,@END_TIME
												,@MARKET
												,@REQUESTER
												,@REC_CNT
		WHILE (@@FETCH_STATUS = 0)
			BEGIN
				SET @MAIL_TITLE = N'[DEV] [REQUEST] CSR ID ('+ SUBSTRING(CONVERT(NVARCHAR(10),GETDATE(), 102), 3, 8)+')'
				SET @MAIL_CONTENT = +N'요청하신 긴급 WO의  CSR ID를 알려 주지 않았습니다. CSR ID 회신 요청 드립니다. </br></br>'
				SET @MAIL_CONTENT = @MAIL_CONTENT+N'Did not inform the CSR ID of the urgent WO you requested. Please request a CSR ID reply.'

				SET @TABLE_CONTENTS = @TABLE_CONTENTS+'<tr>'

				SET @TABLE_CONTENTS = @TABLE_CONTENTS+'<td>'+@WO_BASE_DATE+'</td>'
				SET @TABLE_CONTENTS = @TABLE_CONTENTS+'<td>'+@FACTORY_ID+'</td>'
				SET @TABLE_CONTENTS = @TABLE_CONTENTS+'<td>'+@LINE_ID+'</td>'
				SET @TABLE_CONTENTS = @TABLE_CONTENTS+'<td>'+@OPERATION_ID+'</td>'
				SET @TABLE_CONTENTS = @TABLE_CONTENTS+'<td>'+@ITEM_ID+'</td>'
				SET @TABLE_CONTENTS = @TABLE_CONTENTS+'<td>'+@ORDER_TYPE+'</td>'
				SET @TABLE_CONTENTS = @TABLE_CONTENTS+'<td>'+@START_TIME+'</td>'
				SET @TABLE_CONTENTS = @TABLE_CONTENTS+'<td>'+@END_TIME+'</td>'
				SET @TABLE_CONTENTS = @TABLE_CONTENTS+'<td>'+@MARKET+'</td>'

				SET @TABLE_CONTENTS = @TABLE_CONTENTS+'</tr>'

				IF @REC_CNT = 1 OR @CNT  = @REC_CNT 
					BEGIN
						SET @TABLE_BODY = ' <html>
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
												<body>' +'</br>'+
													REPLACE(ISNULL(@MAIL_CONTENT, ''), CHAR(10), '<br>') + 
   													'<div class=''wrap''>
       													<div class=''hori-table''>
           													<table style=''border-top:2px solid #c8294b; width:1400px;''>
               													<thead>' 
																	+'<tr>'
																	+'	<th>REQUEST DATE</th>'
																	+'	<th>FACTORY</th>'
																	+'	<th>LINE</th>'
																	+'	<th>OPERATION</th>'
																	+'	<th>ITEM</th>'
																	+'	<th>ORDER_TYPE</th>'
																	+'	<th>START_TIME</th>'
																	+'	<th>END_TIME</th >'
																	+'	<th>MARKET</th>'
																	+'</tr>'
               													+'</thead>
               													<tbody>' + ISNULL(@TABLE_CONTENTS, '') + '</tbody>
															</table>
       													</div>

   													</div>
												</body>
										</html>'

						SET @MAIL_RECEIVER_LIST = 'piyong@lgchem.com;'--+@REQUESTER+'@lgchem.com;'


						IF LEN(@TABLE_CONTENTS) > 0
							BEGIN
								exec msdb.dbo.sp_send_dbmail @profile_name           = 'FP_MAIL_TEST'
															 , @recipients             = @MAIL_RECEIVER_LIST
															 , @query_result_separator = ';'
															 , @subject                = @MAIL_TITLE
															 , @body                   = @TABLE_BODY
															 , @body_format            = 'html'
							 END

						SET @CNT = 1;
						SET @MAIL_RECEIVER_LIST = ''
						SET @TABLE_CONTENTS = ''				

					  END
				ELSE
					BEGIN
						SET @CNT = @CNT+1;
					  END

				FETCH NEXT FROM CUR_REQUESTER_LIST INTO @WO_BASE_DATE
														,@FACTORY_ID
														,@LINE_ID
														,@OPERATION_ID
														,@ITEM_ID
														,@ORDER_TYPE
														,@START_TIME
														,@END_TIME
														,@MARKET
														,@REQUESTER
														,@REC_CNT
													
				;
			END;
			
		CLOSE CUR_REQUESTER_LIST;
		DEALLOCATE CUR_REQUESTER_LIST;


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
