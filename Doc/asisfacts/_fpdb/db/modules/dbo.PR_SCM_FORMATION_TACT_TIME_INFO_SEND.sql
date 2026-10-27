CREATE PROCEDURE [dbo].[PR_SCM_FORMATION_TACT_TIME_INFO_SEND]

-- ================================================================================================
-- Program ID          : 
-- Program Name        : PR_SCM_FORMATION_TACT_TIME_INFO_SEND
-- Param               :
-- Batch Period        : realtime
-- Description         : 활성화 TACT TIME 미 입력 정보  Mailing
--
-- Source System       : 
-- Destination System  : 
-- Source Table        : SCM_MAILING_H
-- Destination Table   : 
--
-- Create Date		   : 2018.08.09
-- Update Date		   : 2019.09.19 PIYONG ADD

-- Author              : 
-- Version             : 1.0
--						 1.1 메일 발송 조건에 시업 시간 추가

-- ================================================================================================
-- PARAMETER
@P_SITE_ID NVARCHAR(100) =  'A001'
,@P_BASIS_START_TIME NVARCHAR(6) = '060000'

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_SCM_FORMATION_TACT_TIME_INFO_SEND'
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

	SET @ROWCOUNT = @@ROWCOUNT

	DECLARE @PLANT					NVARCHAR(10)
    DECLARE @MAIL_ADDR				NVARCHAR(MAX)


	DECLARE @DIVISION_ID			NVARCHAR(30)
	DECLARE @BEFOR_DIVISION_ID		NVARCHAR(30)
	DECLARE @PLANT_ID				NVARCHAR(30)
	DECLARE @BEFOR_PLANT_ID			NVARCHAR(30)
	DECLARE @FACTORY_ID				NVARCHAR(30)
	DECLARE @BEFOR_FACTORY_ID		NVARCHAR(30)
	DECLARE @LINE_ID				NVARCHAR(30)
	DECLARE @BEFOR_LINE_ID			NVARCHAR(30)
	DECLARE @ITEM_ID				NVARCHAR(30)
	DECLARE @FLOW_ID				NVARCHAR(30)
	DECLARE @BEFOR_FLOW_ID			NVARCHAR(30)
	DECLARE @NICK_NAME				NVARCHAR(50)
	DECLARE @ROUTE_TYPE_B			NVARCHAR(1)
	DECLARE @ROUTE_TYPE_C			NVARCHAR(1)
	DECLARE @DIVISION_CNT			NUMERIC(18,0)
	DECLARE @PLANT_CNT				NUMERIC(18,0)
	DECLARE @FACTORY_CNT			NUMERIC(18,0)
	DECLARE @LINE_ID_CNT			NUMERIC(18,0)
	DECLARE @FLOW_CNT				NUMERIC(18,0)


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
			SELECT I.COMPANY_ID
				   ,I.DIVISION_ID
				   ,I.SITE_ID
				   ,ILA.PLANT_ID
				   ,ILA.FACTORY_ID
				   ,ILA.LINE_ID
				   ,ILA.MONTH
				   ,I.ITEM_ID
				   ,I.NICK_NAME
				   ,FLOW_ID
				   ,ISNULL((SELECT TOP 1 'O'
							  FROM SCM_AGING_ITEM_FLOW_M AIF
							 WHERE I.COMPANY_ID = AIF.COMPANY_ID
							   AND I.DIVISION_ID = AIF.DIVISION_ID
							   AND I.SITE_ID = AIF.SITE_ID
							   AND I.ITEM_ID = AIF.ITEM_ID
							   AND AIF.DEFAULT_FLAG = 'B' ), 'X') AS ROUTE_TYPE_B
					,ISNULL((SELECT TOP 1 'O'
							   FROM SCM_AGING_ITEM_FLOW_M AIF
							  WHERE I.COMPANY_ID = AIF.COMPANY_ID
								AND I.DIVISION_ID = AIF.DIVISION_ID
								AND I.SITE_ID = AIF.SITE_ID
								AND I.ITEM_ID = AIF.ITEM_ID
								AND AIF.DEFAULT_FLAG = 'C' ), 'X') AS ROUTE_TYPE_C
		      INTO #TACT_INFO
			  FROM SCM_ITEM_M I
			 INNER JOIN SCM_ITEM_LINE_ASSIGN_M ILA
					 ON I.COMPANY_ID = ILA.COMPANY_ID
					AND I.DIVISION_ID = ILA.DIVISION_ID
					AND I.SITE_ID = ILA.SITE_ID
					AND I.FORMATION_FLOW_ID = ILA.OPERATION_ID
					AND I.ITEM_ID = ILA.ITEM_ID
					AND ILA.PRIORITY != 9
					AND ILA.ACTIVE_FLAG = 'Y'
 					AND ILA.MONTH IN(  CONVERT(NVARCHAR(6), GETDATE(), 112), CONVERT(NVARCHAR(6), GETDATE(), 112)+1 )
					AND FORMATION_FLOW_ID IS NOT NULL
		     INNER JOIN SCM_TACT_TIME_M PWTT
					 ON ILA.COMPANY_ID = PWTT.COMPANY_ID
					AND ILA.DIVISION_ID = PWTT.DIVISION_ID
					AND ILA.SITE_ID = PWTT.SITE_ID
					AND ILA.PLANT_ID = PWTT.PLANT_ID
					AND ILA.OPERATION_ID = PWTT.OPERATION_ID
					AND ILA.ITEM_ID = PWTT.ITEM_ID
					AND ILA.LINE_ID = PWTT.LINE_ID
					AND ILA.MONTH = PWTT.MONTH
					AND (PWTT.TACT_TIME IS NULL OR PWTT.TACT_TIME = 0 ) 
			

		DECLARE CUR_MAIL_LIST CURSOR FOR				
			 SELECT ATTRIBUTE1, SEGMENT2, SEGMENT3
			   FROM [DBO].[SCM_SYS_LOOKUP_VALUE] SLV WITH(NOLOCK)
			  WHERE LOOKUP_TYPE_CODE = 'FORMATION_TACT_TIME_INFO_MAIL'
				AND ACTIVE_FLAG = 'Y'
				AND ATTRIBUTE1 IS NOT NULL
				AND SEGMENT1 = @P_SITE_ID
			------------------------------------------------------------------------------
			-- 2019-09-19 PIYONG ADD
				AND SEGMENT2 IN (
									SELECT V.SEGMENT1
									  FROM SCM_SYS_LOOKUP_VALUE V  WITH(NOLOCK)
									 WHERE V.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
									   AND V.ACTIVE_FLAG = 'Y'
									   AND V.SEGMENT2    = @P_BASIS_START_TIME
								)
			-- 2019-09-19 PIYONG ADD
			------------------------------------------------------------------------------


		OPEN CUR_MAIL_LIST;
		
		FETCH NEXT FROM CUR_MAIL_LIST INTO @MAIL_ADDR
										  ,@PLANT_ID
										  ,@FACTORY_ID
		WHILE (@@FETCH_STATUS = 0)
			BEGIN
				SET @MAIL_TITLE = N'[DEV] [Notification] FORMATION Aging L/T Info ('+ SUBSTRING(CONVERT(NVARCHAR(10),GETDATE(), 102), 3, 8)+')'
				SET @MAIL_CONTENT = N'FORMATION Aging L/T Info '
				SET @MAIL_RECEIVER_LIST = ''
				SET @TABLE_CONTENTS = ''
				SET @BEFOR_DIVISION_ID = ''
				SET @BEFOR_PLANT_ID = ''
				SET @BEFOR_FACTORY_ID = ''
				SET @BEFOR_LINE_ID = ''
				SET @BEFOR_FLOW_ID = ''

				DECLARE CUR_DATA_LIST CURSOR FOR
					SELECT DIVISION_ID
						   ,PLANT_ID
						   ,FACTORY_ID
						   ,LINE_ID
   						   ,FLOW_ID
   						   ,NICK_NAME
   						   ,ITEM_ID
						   ,ROUTE_TYPE_B
						   ,ROUTE_TYPE_C
   						   ,COUNT(DIVISION_ID) OVER( PARTITION BY DIVISION_ID ORDER BY DIVISION_ID ) AS DIVISION_CNT
						   ,COUNT(DIVISION_ID) OVER( PARTITION BY DIVISION_ID, PLANT_ID ORDER BY DIVISION_ID, PLANT_ID ) AS PLANT_CNT
						   ,COUNT(DIVISION_ID) OVER( PARTITION BY DIVISION_ID, PLANT_ID, FACTORY_ID 
														 ORDER BY DIVISION_ID, PLANT_ID, FACTORY_ID ) AS FACTORY_CNT
						   ,COUNT(DIVISION_ID) OVER( PARTITION BY DIVISION_ID, PLANT_ID, FACTORY_ID, LINE_ID  
														 ORDER BY DIVISION_ID, PLANT_ID, FACTORY_ID, LINE_ID  ) AS LINE_ID_CNT
						   ,COUNT(DIVISION_ID) OVER( PARTITION BY DIVISION_ID, PLANT_ID, FACTORY_ID, LINE_ID  ,FLOW_ID
														 ORDER BY DIVISION_ID, PLANT_ID, FACTORY_ID, LINE_ID  ,FLOW_ID ) AS FLOW_CNT
					 FROM (
							SELECT DISTINCT DIVISION_ID
								   ,PLANT_ID
								   ,FACTORY_ID
								   ,LINE_ID
   								   ,FLOW_ID
   								   ,NICK_NAME
   								   ,ITEM_ID
								   ,ROUTE_TYPE_B
								   ,ROUTE_TYPE_C
							  FROM #TACT_INFO
							 WHERE PLANT_ID = @PLANT_ID
							   AND FACTORY_ID = @FACTORY_ID
							   AND (ROUTE_TYPE_B = 'X' OR ROUTE_TYPE_C = 'X' )
					   ) A
					 ORDER BY DIVISION_ID, PLANT_ID
						   ,FACTORY_ID, LINE_ID, FLOW_ID, ITEM_ID

				OPEN CUR_DATA_LIST;
		
				FETCH NEXT FROM CUR_DATA_LIST INTO @DIVISION_ID
													,@PLANT_ID
												    ,@FACTORY_ID
													,@LINE_ID
												    ,@FLOW_ID
												    ,@NICK_NAME
													,@ITEM_ID
													,@ROUTE_TYPE_B
													,@ROUTE_TYPE_C
													,@DIVISION_CNT
													,@PLANT_CNT
													,@FACTORY_CNT
													,@LINE_ID_CNT
													,@FLOW_CNT

				WHILE (@@FETCH_STATUS = 0)
					BEGIN


						SET @TABLE_CONTENTS = @TABLE_CONTENTS+'<tr>'


						IF @BEFOR_DIVISION_ID != @DIVISION_ID
							BEGIN
								SET @TABLE_CONTENTS = @TABLE_CONTENTS + '<td ROWSPAN='''+CAST(@DIVISION_CNT AS nvarchar)+'''>'+@DIVISION_ID+'</td>'
								SET @BEFOR_DIVISION_ID = @DIVISION_ID
							END
						
						IF @BEFOR_PLANT_ID != @PLANT_ID  OR @PLANT_CNT  = 1 
							BEGIN
								SET @TABLE_CONTENTS = @TABLE_CONTENTS + '<td ROWSPAN='''+CAST(@PLANT_CNT AS nvarchar)+'''>'+@PLANT_ID+'</td>'
								SET @BEFOR_PLANT_ID = @PLANT_ID
							END

						IF @BEFOR_FACTORY_ID != @FACTORY_ID
							BEGIN
								SET @TABLE_CONTENTS = @TABLE_CONTENTS + '<td ROWSPAN='''+CAST(@FACTORY_CNT AS nvarchar)+'''>'+@FACTORY_ID+'</td>'
								SET @BEFOR_FACTORY_ID = @FACTORY_ID
							END

						IF @BEFOR_LINE_ID != @LINE_ID
							BEGIN
								SET @TABLE_CONTENTS = @TABLE_CONTENTS + '<td ROWSPAN='''+CAST(@LINE_ID_CNT AS nvarchar)+'''>'+@LINE_ID+'</td>'
								SET @BEFOR_LINE_ID = @LINE_ID
							END

						SET @TABLE_CONTENTS = @TABLE_CONTENTS + '<td >'+@NICK_NAME+'</td>'

						SET @TABLE_CONTENTS = @TABLE_CONTENTS+'<td>'+@ITEM_ID+'</td>'

						IF @BEFOR_FLOW_ID != @FLOW_ID
							BEGIN
								SET @TABLE_CONTENTS = @TABLE_CONTENTS + '<td ROWSPAN='''+CAST(@FLOW_CNT AS nvarchar)+'''>'+@FLOW_ID+'</td>'
								SET @BEFOR_FLOW_ID = @FLOW_ID
							END

						SET @TABLE_CONTENTS = CASE WHEN @ROUTE_TYPE_B = 'X' THEN
														@TABLE_CONTENTS+'<td style=''FONT-WEIGHT: bold; color:red;''>'+@ROUTE_TYPE_B+'</td>'
													 ELSE
														@TABLE_CONTENTS+'<td>'+@ROUTE_TYPE_B+'</td>'
													  END

						SET @TABLE_CONTENTS = CASE WHEN @ROUTE_TYPE_C = 'X' THEN
														@TABLE_CONTENTS+'<td style=''FONT-WEIGHT: bold; color:red;''>'+@ROUTE_TYPE_C+'</td>'
													 ELSE
														@TABLE_CONTENTS+'<td>'+@ROUTE_TYPE_C+'</td>'
													  END

						SET @TABLE_CONTENTS = @TABLE_CONTENTS+'</tr>'


						FETCH NEXT FROM CUR_DATA_LIST INTO @DIVISION_ID
															,@PLANT_ID
															,@FACTORY_ID
															,@LINE_ID
															,@FLOW_ID
															,@NICK_NAME
															,@ITEM_ID
															,@ROUTE_TYPE_B
															,@ROUTE_TYPE_C
															,@DIVISION_CNT
															,@PLANT_CNT
															,@FACTORY_CNT
															,@LINE_ID_CNT
															,@FLOW_CNT
													
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
								REPLACE(ISNULL(@MAIL_CONTENT, ''), CHAR(10), '<br>') + 'Report generated on : ' + CONVERT(VARCHAR(10), GETDATE(), 120) + '
   									<br>
   									<div class=''wrap''>
       									<div class=''hori-table''>
           									<table style=''border-top:2px solid #c8294b; width:1250px;''>
               									<thead>' 
													+'<tr>'
													+'	<th>Division</th>'
													+'	<th>Plant</th>'
													+'	<th>Factory</th>'
													+'	<th>Line</th>'
													+'	<th>PJT CODE</th>'
													+'	<th>ITEM_ID</th>'
													+'	<th>Flow</th>'
													+'	<th>Basic Route</th>'
													+'	<th>Capacity Route</th>'
													+'</tr>'
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
						exec msdb.dbo.sp_send_dbmail @profile_name           = 'FP_MAIL_TEST'
													 , @recipients             = @MAIL_RECEIVER_LIST
													 , @query_result_separator = ';'
													 , @subject                = @MAIL_TITLE
													 , @body                   = @TABLE_BODY
													 , @body_format            = 'html'
					 END

				FETCH NEXT FROM CUR_MAIL_LIST INTO @MAIL_ADDR
												  ,@PLANT_ID
												  ,@FACTORY_ID
													
				;
			END;
			
		CLOSE CUR_MAIL_LIST;
		DEALLOCATE CUR_MAIL_LIST;


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
