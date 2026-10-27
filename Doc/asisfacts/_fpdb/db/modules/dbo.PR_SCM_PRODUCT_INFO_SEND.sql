CREATE PROCEDURE [dbo].[PR_SCM_PRODUCT_INFO_SEND]

-- ================================================================================================
-- Program ID          : 
-- Program Name        : PR_SCM_PRODUCT_INFO_SEND
-- Param               :
-- Batch Period        : realtime
-- Description         : PRODUCT 정보  Mailing
--
-- Source System       : 
-- Destination System  : 
-- Source Table        : FP_WEEKLY_DEMAND_PRODUCT_H, FP_WEEKLY_DEMAND_PRODUCT_TEST_H
-- Destination Table   : 
--
-- Create Date		   : 2018.10.12
-- Update Date		   : 1.1 2019.07.22 PIYONG

-- Author              : PIYONG
-- Version             : 1.0
--						 1.1 장현석책임 요청으로 50주 이하의 정보만 확인 한다.
--						 1.2 메일 발송 조건에 시업시간 추가

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
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_SCM_PRODUCT_INFO_SEND'
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

	DECLARE @INSTANCE				NVARCHAR(50)
	DECLARE @PLANT					NVARCHAR(10)
    DECLARE @MAIL_ADDR				NVARCHAR(MAX)

	DECLARE @DATA_TYPE				NVARCHAR(30)
	DECLARE @BEFOR_DATA_TYPE		NVARCHAR(30) = ''
	DECLARE @DIVISION_ID			NVARCHAR(30)
	DECLARE @BEFOR_DIVISION_ID		NVARCHAR(30) = ''
	DECLARE @PLANT_ID				NVARCHAR(30)
	DECLARE @BEFOR_PLANT_ID			NVARCHAR(30) = ''
	DECLARE @SHOP_GROUP_ID			NVARCHAR(30)
	DECLARE @BEFOR_SHOP_GROUP_ID	NVARCHAR(30) = ''
	DECLARE @MARKET					NVARCHAR(30)
	DECLARE @BEFOR_MARKET			NVARCHAR(30) = ''

	DECLARE @NICK_NAME				NVARCHAR(50)
	DECLARE @ITEM_ID				NVARCHAR(50)
	DECLARE @ITEM_CLASS_NAME		NVARCHAR(50)
	DECLARE @SPEC					NVARCHAR(50)
	DECLARE @PRODUCTION_TYPE		NVARCHAR(10)
	DECLARE @LINE_ID				NVARCHAR(50)
	DECLARE @OPERATION_ID			NVARCHAR(10)
	DECLARE @MFG_WEEK				NVARCHAR(150)
	DECLARE @MFG_DATE	 			NVARCHAR(50)
	DECLARE @MFG_QTY				NVARCHAR(50)
	
	DECLARE @DIVISION_CNT			NUMERIC(18,0)
	DECLARE @PLANT_CNT				NUMERIC(18,0)
	DECLARE @DATA_TYPE_CNT			NUMERIC(18,0)
	DECLARE @SHOP_GROUP_ID_CNT		NUMERIC(18,0)
	DECLARE @MARKET_CNT				NUMERIC(18,0)

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
			-- 조회쿼리
			SELECT F.INSTANCE_ID
				   ,DATA_TYPE
				   ,A.[COMPANY_ID]
				   ,A.[DIVISION_ID]
				   ,A.[SITE_ID]
				   ,A.[PLANT_ID]
				   ,A.[SHOP_GROUP_ID]
				   ,A.[MARKET]
				   ,A.[ITEM_ID]
				   ,A.NICK_NAME
				   ,A.ITEM_CLASS_NAME
				   ,A.SPEC
				   ,A.[PRODUCTION_TYPE]
				   ,A.[LINE_ID]
				   ,A.[OPERATION_ID]
				   ,A.MFG_WEEK
				   ,A.MFG_DATE
				   ,A.MFG_QTY
			  INTO #PRODUCT_INFO
			  FROM (
					SELECT 'SCP PROD TARGET' AS DATA_TYPE
						   ,A.[COMPANY_ID]
						   ,A.[DIVISION_ID]
						   ,A.[SITE_ID]
						   ,A.[PLANT_ID]
						   ,A.[SHOP_GROUP_ID]
						   ,A.[MARKET]
						   ,A.[ITEM_ID]
						   ,MAX(I.NICK_NAME) AS NICK_NAME
						   ,MAX(I.ITEM_CLASS_NAME) AS ITEM_CLASS_NAME
						   ,MAX(I.SPEC) AS SPEC
						   ,A.[PRODUCTION_TYPE]
						   ,A.[LINE_ID]
						   ,A.[OPERATION_ID]
						   ,MIN(A.[MFG_WEEK]) AS MFG_WEEK
						   ,ISNULL(MIN(A.[MFG_DATE]),(SELECT YYYYMMDD
													    FROM TH_UIS_CAL AA WITH(NOLOCK)
													   WHERE ISO_YYYYWW = MIN(A.[MFG_WEEK])
													     AND DATEPART(DW, DT) = 2))  AS MFG_DATE
						   ,SUM(A.[MFG_QTY]) AS MFG_QTY
					  FROM [FP_WEEKLY_DEMAND_PRODUCT_H] A WITH(NOLOCK)
						   ,( SELECT DIVISION_ID, SHOP_GROUP_ID, MAX(SCP_PLAN_ID) AS MAX_PLAN_ID
								FROM [FP_WEEKLY_DEMAND_PRODUCT_H] B WITH(NOLOCK)
							   GROUP BY B.DIVISION_ID, B.SHOP_GROUP_ID ) B
						   , SCM_ITEM_M I WITH(NOLOCK)
					 WHERE A.DIVISION_ID   = B.DIVISION_ID
					   AND A.SHOP_GROUP_ID = B.SHOP_GROUP_ID
					   AND A.SCP_PLAN_ID   = B.MAX_PLAN_ID
					   AND A.COMPANY_ID    = I.COMPANY_ID
					   AND A.DIVISION_ID   = I.DIVISION_ID
					   AND A.SITE_ID       = I.SITE_ID
					   AND A.ITEM_ID       = I.ITEM_ID
					   AND I.ITEM_TYPE     = 'Q'
					   AND A.SITE_ID  = @P_SITE_ID
					 GROUP BY A.[COMPANY_ID]
						   ,A.[DIVISION_ID]
						   ,A.[SITE_ID]
						   ,A.[PLANT_ID]
						   ,A.[SHOP_GROUP_ID]
						   ,A.[MARKET]
						   ,A.[ITEM_ID]
						   ,A.[PRODUCTION_TYPE]
						   ,A.[LINE_ID]
						   ,A.[OPERATION_ID]
					UNION ALL
					SELECT 'TEST DEMAND' AS DATA_TYPE
						   ,A.[COMPANY_ID]
						   ,A.[DIVISION_ID]
						   ,A.[SITE_ID]
						   ,A.[PLANT_ID]
						   ,SUBSTRING(A.[OPERATION_ID], 1,1) AS SHOP_GROUP_ID
						   ,A.[MARKET]
						   ,A.[ITEM_ID]
						   ,MAX(I.NICK_NAME) AS NICK_NAME
						   ,MAX(I.ITEM_CLASS_NAME) AS ITEM_CLASS_NAME
						   ,MAX(I.SPEC) AS SPEC
						   ,'TEST' AS PRODUCTION_TYPE
						   ,A.[LINE_ID]
						   ,A.[OPERATION_ID]
						   ,MIN(A.[MFG_WEEK]) AS MFG_WEEK
						   ,ISNULL(MIN(A.[DUE_DATE]),(SELECT YYYYMMDD
													    FROM TH_UIS_CAL AA WITH(NOLOCK)
													   WHERE ISO_YYYYWW = MIN(A.[MFG_WEEK])
													     AND DATEPART(DW, DT) = 2))  AS MFG_DATE
						   ,SUM(A.[MFG_QTY])  AS MFG_QTY
					  FROM [FP_WEEKLY_DEMAND_PRODUCT_TEST_H] A WITH(NOLOCK)
						   , SCM_ITEM_M I WITH(NOLOCK)
					 WHERE A.COMPANY_ID    = I.COMPANY_ID
					   AND A.DIVISION_ID   = I.DIVISION_ID
					   AND A.SITE_ID       = I.SITE_ID
					   AND A.ITEM_ID       = I.ITEM_ID
					   AND I.ITEM_TYPE     = 'Q'
					   AND A.DUE_DATE     >= CONVERT(DATE, GETDATE())
					  GROUP BY A.[COMPANY_ID]
						  ,A.[DIVISION_ID]
						  ,A.[SITE_ID]
						  ,A.[PLANT_ID]
						  ,A.[MARKET]
						  ,A.[ITEM_ID]
						  ,A.[LINE_ID]
						  ,A.[OPERATION_ID]

				 ) A
				 , SCM_MMD_OPERATION_GROUP_M  MOG (NOLOCK)
				 , (SELECT DISTINCT F.INSTANCE_ID, SF.PLANT_ID, F.SHOP_GROUP_ID
					  FROM SCM_FACTORY_M   SF (NOLOCK)
						   ,FP_INSTANCE_FACTORY_M F (NOLOCK)
					 WHERE SF.FACTORY_ID  = F.FACTORY_ID
					   AND SF.ACTIVE_FLAG = 'Y'
					   AND F.ACTIVE_FLAG  = 'Y' )  F
			WHERE A.SHOP_GROUP_ID = MOG.OPERATION_GROUP_ID
			  AND F.SHOP_GROUP_ID	= ISNULL(MOG.ROUTE_TYPE, MOG.OPERATION_GROUP_ID)
			  AND F.PLANT_ID		= A.PLANT_ID
			  AND A.MFG_WEEK		<= ( SELECT [WEEK] FROM [dbo].[SCM_SYS_CALENDAR_M] WHERE DATE_ID = dateadd(WW, 50,CONVERT( NVARCHAR, GETDATE(), 112)) )	-- 2019-07-22 PIYONG ADD
  			  AND EXISTS ( SELECT TOP 1 1 
							 FROM SCM_SYS_LOOKUP_VALUE LV1 (NOLOCK)
							WHERE LV1.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
							  AND LV1.SEGMENT1         = F.INSTANCE_ID
							  AND LV1.ACTIVE_FLAG      = 'Y'
							  AND LV1.ATTRIBUTE1       = 'BUILDING' )
			



		DECLARE CUR_OPERATION_GROUP_LIST CURSOR FOR				
			 SELECT ATTRIBUTE1, SEGMENT1, SEGMENT2
			   FROM [DBO].[SCM_SYS_LOOKUP_VALUE] SLV WITH(NOLOCK)
			  WHERE LOOKUP_TYPE_CODE = 'PRODUCT_INFO_MAIL'
				AND ACTIVE_FLAG = 'Y'
				------------------------------------------------------------------------------
				-- 2019-09-19 PIYONG ADD
				AND ATTRIBUTE1 IS NOT NULL
				AND SEGMENT2 IN (
									SELECT V.SEGMENT1
									  FROM SCM_SYS_LOOKUP_VALUE V  WITH(NOLOCK)
									 WHERE V.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
									   AND V.ACTIVE_FLAG = 'Y'
									   AND V.SEGMENT2    = @P_BASIS_START_TIME
									)
				-- 2019-09-19 PIYONG ADD
				------------------------------------------------------------------------------


		OPEN CUR_OPERATION_GROUP_LIST;
		
		FETCH NEXT FROM CUR_OPERATION_GROUP_LIST INTO @MAIL_ADDR
													  ,@INSTANCE
													  ,@PLANT
		WHILE (@@FETCH_STATUS = 0)
			BEGIN
				SET @MAIL_TITLE = N'[DEV] [Notification] COMMODITY(GOODS) Info ('+ SUBSTRING(CONVERT(NVARCHAR(10),GETDATE(), 102), 3, 8)+')'
				SET @MAIL_CONTENT = N'Please change the item type from the commodity to the product at PLM.'
				SET @MAIL_RECEIVER_LIST = ''
				SET @TABLE_CONTENTS = ''

				SET @BEFOR_DATA_TYPE = ''
				SET @BEFOR_DIVISION_ID = ''
				SET @BEFOR_PLANT_ID = ''
				SET @BEFOR_SHOP_GROUP_ID = ''
				SET @BEFOR_MARKET = ''

				DECLARE CUR_DATA_LIST CURSOR FOR
					SELECT --A.DATA_TYPE
						   --,A.DIVISION_ID,
						   A.PLANT_ID
						   --,A.SHOP_GROUP_ID
						   --,A.MARKET
						   ,A.NICK_NAME
						   ,A.ITEM_ID
						   ,A.ITEM_CLASS_NAME
						   ,A.SPEC
						   ,A.PRODUCTION_TYPE
						   ,A.LINE_ID
       					   --,A.OPERATION_ID
						   ,A.MFG_WEEK
						   ,A.MFG_DATE
						   --,ISNULL( CAST(CONVERT(NUMERIC(20,10),A.MFG_QTY) AS NVARCHAR), '') AS MFG_QTY
						   --,COUNT(DATA_TYPE) OVER( PARTITION BY DATA_TYPE ORDER BY DATA_TYPE  ) AS DATA_TYPE_CNT
						   --,COUNT(DIVISION_ID) OVER( PARTITION BY DATA_TYPE, DIVISION_ID ORDER BY DATA_TYPE, DIVISION_ID  ) AS DIVISION_CNT
						   ,COUNT(PLANT_ID) OVER( PARTITION BY DATA_TYPE, DIVISION_ID, PLANT_ID ORDER BY DATA_TYPE, DIVISION_ID , PLANT_ID ) AS PLANT_CNT
						   --,COUNT(SHOP_GROUP_ID) OVER( PARTITION BY DATA_TYPE, DIVISION_ID, PLANT_ID, SHOP_GROUP_ID ORDER BY DATA_TYPE, DIVISION_ID, PLANT_ID, SHOP_GROUP_ID ) AS SHOP_GROUP_ID_CNT
						   --,COUNT(MARKET) OVER( PARTITION BY DATA_TYPE, DIVISION_ID, PLANT_ID, SHOP_GROUP_ID, MARKET
						   --						  ORDER BY DATA_TYPE, DIVISION_ID, PLANT_ID, SHOP_GROUP_ID, MARKET ) AS MARKET_CNT

--						   ,COUNT(OPERATION_ID) OVER( PARTITION BY DATA_TYPE, DIVISION_ID, PLANT_ID, SHOP_GROUP_ID, OPERATION_ID
--													      ORDER BY DATA_TYPE, DIVISION_ID, PLANT_ID, SHOP_GROUP_ID, OPERATION_ID ) AS OPERATION_CNT
--						   ,COUNT(LINE_ID) OVER( PARTITION BY DATA_TYPE, DIVISION_ID, PLANT_ID, SHOP_GROUP_ID, OPERATION_ID, LINE_ID, NICK_NAME
--													 ORDER BY DATA_TYPE, DIVISION_ID, PLANT_ID, SHOP_GROUP_ID, OPERATION_ID, LINE_ID, NICK_NAME ) AS LINE_CNT
--						   ,COUNT(NICK_NAME) OVER( PARTITION BY DATA_TYPE, DIVISION_ID, PLANT_ID, SHOP_GROUP_ID, OPERATION_ID, LINE_ID, NICK_NAME, NICK_NAME
--													   ORDER BY DATA_TYPE, DIVISION_ID, PLANT_ID, SHOP_GROUP_ID, OPERATION_ID, LINE_ID, NICK_NAME ) AS LINE_CNT
--						   ,COUNT(ITEM_ID) OVER( PARTITION BY DATA_TYPE, DIVISION_ID, PLANT_ID, SHOP_GROUP_ID, OPERATION_ID, LINE_ID, NICK_NAME, ITEM_ID
--												     ORDER BY DATA_TYPE, DIVISION_ID, PLANT_ID, SHOP_GROUP_ID, OPERATION_ID, LINE_ID, NICK_NAME, ITEM_ID ) AS LINE_CNT
--						   ,COUNT(PRODUCTION_TYPE) OVER( PARTITION BY DATA_TYPE, DIVISION_ID, PLANT_ID, SHOP_GROUP_ID, OPERATION_ID, LINE_ID, NICK_NAME, ITEM_ID, PRODUCTION_TYPE
--												     ORDER BY DATA_TYPE, DIVISION_ID, PLANT_ID, SHOP_GROUP_ID, OPERATION_ID, LINE_ID, NICK_NAME, ITEM_ID, PRODUCTION_TYPE ) AS LINE_CNT
					  FROM #PRODUCT_INFO A
					 WHERE INSTANCE_ID = @INSTANCE
					   AND PLANT_ID = @PLANT
					 ORDER BY A.DATA_TYPE, A.MFG_WEEK, A.MFG_DATE
						   , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.SHOP_GROUP_ID, A.LINE_ID, A.OPERATION_ID
						   , CASE WHEN NICK_NAME IS NOT NULL THEN NICK_NAME ELSE 'ZZZZZZ' END
						   , A.ITEM_ID

				OPEN CUR_DATA_LIST;
		
				FETCH NEXT FROM CUR_DATA_LIST INTO --@DATA_TYPE
												--,@DIVISION_ID,
												@PLANT_ID
												--,@SHOP_GROUP_ID
												--,@MARKET
												,@NICK_NAME
												,@ITEM_ID
												,@ITEM_CLASS_NAME
												,@SPEC
												,@PRODUCTION_TYPE
												,@LINE_ID
												--,@OPERATION_ID
												,@MFG_WEEK
												,@MFG_DATE
												--,@MFG_QTY
												--,@DATA_TYPE_CNT
												--,@DIVISION_CNT
												,@PLANT_CNT
												--,@SHOP_GROUP_ID_CNT
												--,@MARKET_CNT

				WHILE (@@FETCH_STATUS = 0)
					BEGIN



						SET @TABLE_CONTENTS = @TABLE_CONTENTS+'<tr>'
						/*
						IF @BEFOR_DATA_TYPE != @DATA_TYPE
							BEGIN
								SET @TABLE_CONTENTS = @TABLE_CONTENTS + '<td ROWSPAN='''+CAST(@DATA_TYPE_CNT AS nvarchar)+'''>'+@DATA_TYPE+'</td>'
								SET @BEFOR_DATA_TYPE = @DATA_TYPE
							END

						IF @BEFOR_DIVISION_ID != @DIVISION_ID
							BEGIN
								SET @TABLE_CONTENTS = @TABLE_CONTENTS + '<td ROWSPAN='''+CAST(@DIVISION_CNT AS nvarchar)+'''>'+@DIVISION_ID+'</td>'
								SET @BEFOR_DIVISION_ID = @DIVISION_ID
							END
						*/
						IF @BEFOR_PLANT_ID != @PLANT_ID
							BEGIN
								SET @TABLE_CONTENTS = @TABLE_CONTENTS + '<td ROWSPAN='''+CAST(@PLANT_CNT AS nvarchar)+'''>'+@PLANT_ID+'</td>'
								SET @BEFOR_PLANT_ID = @PLANT_ID
							END
						/*
						IF @BEFOR_SHOP_GROUP_ID != @SHOP_GROUP_ID
							BEGIN
								SET @TABLE_CONTENTS = @TABLE_CONTENTS + '<td ROWSPAN='''+CAST(@SHOP_GROUP_ID_CNT AS nvarchar)+'''>'+@SHOP_GROUP_ID+'</td>'
								SET @BEFOR_SHOP_GROUP_ID = @SHOP_GROUP_ID
							END

						IF @BEFOR_MARKET != @MARKET
							BEGIN
								SET @TABLE_CONTENTS = @TABLE_CONTENTS + '<td ROWSPAN='''+CAST(@MARKET_CNT AS nvarchar)+'''>'+@MARKET+'</td>'
								SET @BEFOR_MARKET = @MARKET
							END
							*/

						SET @TABLE_CONTENTS = @TABLE_CONTENTS+'<td>'+@NICK_NAME+'</td>'
						SET @TABLE_CONTENTS = @TABLE_CONTENTS+'<td>'+@ITEM_ID+'</td>'
						SET @TABLE_CONTENTS = @TABLE_CONTENTS+'<td>'+@ITEM_CLASS_NAME+'</td>'
						SET @TABLE_CONTENTS = @TABLE_CONTENTS+'<td>'+@SPEC+'</td>'
						SET @TABLE_CONTENTS = @TABLE_CONTENTS+'<td>'+@PRODUCTION_TYPE+'</td>'
						SET @TABLE_CONTENTS = @TABLE_CONTENTS+'<td>'+@LINE_ID+'</td>'
						--SET @TABLE_CONTENTS = @TABLE_CONTENTS+'<td>'+@OPERATION_ID+'</td>'
						SET @TABLE_CONTENTS = @TABLE_CONTENTS+'<td>'+@MFG_WEEK+'</td>'
						SET @TABLE_CONTENTS = @TABLE_CONTENTS+'<td>'+@MFG_DATE+'</td>'
						--SET @TABLE_CONTENTS = @TABLE_CONTENTS+'<td>'+@MFG_QTY+'</td>'


						SET @TABLE_CONTENTS = @TABLE_CONTENTS+'</tr>'

						FETCH NEXT FROM CUR_DATA_LIST INTO --@DATA_TYPE
														--,@DIVISION_ID,
														@PLANT_ID
														--,@SHOP_GROUP_ID
														--,@MARKET
														,@NICK_NAME
														,@ITEM_ID
														,@ITEM_CLASS_NAME
														,@SPEC
														,@PRODUCTION_TYPE
														,@LINE_ID
														--,@OPERATION_ID
														,@MFG_WEEK
														,@MFG_DATE
														--,@MFG_QTY
														--,@DATA_TYPE_CNT
														--,@DIVISION_CNT
														,@PLANT_CNT
														--,@SHOP_GROUP_ID_CNT
														--,@MARKET_CNT
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
								REPLACE(ISNULL(@MAIL_CONTENT, ''), CHAR(10), '<br>') --+ 'Report generated on : ' + CONVERT(VARCHAR(10), GETDATE(), 120)

   									+'<div class=''wrap''>
       									<div class=''hori-table''>
           									<table style=''border-top:2px solid #c8294b; width:1650px;''>
               									<thead>' 
													+'<tr>'
													--+'	<th>Data Type</th>'
													--+'	<th>Division</th>'
													+'	<th>Plant</th>'
													--+'	<th>Shop Group</th>'
													--+'	<th>Market</th>'
													+'	<th>PJT Code</th>'
													+'	<th>Material</th>'
													+'	<th>Material Class</th>'
													+'	<th>Spec</th>'
													+'	<th>Production Type</th>'
													+'	<th>LINE</th>'
													--+'	<th>Operation</th>'
													+'	<th>Week</th>'
													+'	<th>Date</th>'
													--+'	<th>Quantity</th>'
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

				FETCH NEXT FROM CUR_OPERATION_GROUP_LIST INTO @MAIL_ADDR
															  ,@INSTANCE
															  ,@PLANT
													
				;
			END;
			
		CLOSE CUR_OPERATION_GROUP_LIST;
		DEALLOCATE CUR_OPERATION_GROUP_LIST;


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
