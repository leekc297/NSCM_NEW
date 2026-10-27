CREATE PROCEDURE [dbo].[PR_SCM_FORMATION_INVENTORY_GAP_INFO_SEND]

-- ================================================================================================
-- Program ID          : FP02722
-- Program Name        : PR_SCM_FORMATION_INVENTORY_GAP_INFO_SEND
-- Param               :
-- Batch Period        : realtime
-- Description         : 활성화 재고 GAP 차이
--
-- Source System       : 
-- Destination System  : 
-- Source Table        : SCM_AGING_STOCK_H
-- Destination Table   : 
--
-- Create Date		   : 2019.10.23
-- Update Date		   : 2020.01.21 piyong 2.0

-- Author              : PIYONG
-- Version             : 1.0
--						 2.0 활성화 재고  전일 -  당일 -> (  (  활성화 재고 당일 ) / (  전일 조립 실적 - ( 활성화 재고 전일 + 전일 특성 실적 )  ) > 1.1 ) 로직 변경
--							 전송 대상 추출 로직 변경

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
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_SCM_FORMATION_INVENTORY_GAP_INFO_SEND'
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

    DECLARE @MAIL_ADDR				NVARCHAR(MAX)
	DECLARE @MAIL_CNT			   INT = 0;
	DECLARE @ADDR_LIST			   NVARCHAR(4000)

	DECLARE @C_COMPANY_ID			NVARCHAR(30)
	DECLARE @C_DIVISION_ID			NVARCHAR(30)
	DECLARE @C_SITE_ID				NVARCHAR(30)
	DECLARE @C_PLANT_ID				NVARCHAR(30)
	DECLARE @C_FACTORY_ID			NVARCHAR(30)

	DECLARE @PLANT_ID				NVARCHAR(30)
	DECLARE @BEFOR_PLANT_ID			NVARCHAR(30) = ''
	DECLARE @FACTORY_ID				NVARCHAR(30)
	DECLARE @BEFOR_FACTORY_ID		NVARCHAR(30) = ''

	DECLARE @NICK_NAME				NVARCHAR(50)
	DECLARE @ITEM_ID				NVARCHAR(50)
	DECLARE @YESTERDAY_CNT			NVARCHAR(50)
	DECLARE @TO_DATE_CNT			NVARCHAR(50)
	DECLARE @INVEN_QTY				NVARCHAR(50)
	DECLARE @ASSY_RESULT_QTY		NVARCHAR(50)
	DECLARE @FORMATION_RESULT_QTY	NVARCHAR(50)
	DECLARE @RESULT_QTY				NVARCHAR(50)
	DECLARE @GAP_QTY				NVARCHAR(50)
	
	DECLARE @PLANT_CNT				NVARCHAR(50)
	DECLARE @FACTORY_CNT			NVARCHAR(50)

	DECLARE CUR_CAP_PLANT CURSOR FOR
/*		--2020-01-21 piyong DEL
		SELECT DISTINCT COMPANY_ID
			   , DIVISION_ID
			   , SITE_ID
			   , PLANT_ID
			   , FACTORY_ID
		  FROM (
				SELECT COMPANY_ID
					   , DIVISION_ID
					   , SITE_ID
					   , PLANT_ID
					   , FACTORY_ID
					   , ITEM_ID
					   , SUM(D) AS TO_DATE
					   , SUM(D1) AS YESTERDAY
					   , CASE WHEN SUM(D)  = 0 THEN 1
							  WHEN SUM(D1)  = 0 THEN 1
							  WHEN ( (SUM(D) /  SUM(D1) ) < 0.20 ) OR ( (SUM(D) /  SUM(D1) ) > 1.20 ) THEN 1  ELSE 0 END FLAG
				  FROM (
						SELECT COMPANY_ID
							   , DIVISION_ID
							   , SITE_ID
							   , PLANT_ID
							   , FACTORY_ID
							   , LINE_ID
							   , CUTOFF_DATE
							   , ISNULL( (
											SELECT NICK_NAME
											  FROM SCM_ITEM_M
											 WHERE COMPANY_ID = S.COMPANY_ID
											   AND DIVISION_ID = S.DIVISION_ID
											   AND SITE_ID = S.SITE_ID
											   AND ITEM_ID = S.ITEM_ID			), '') AS NICK_NAME
							   , ITEM_ID
							   , CASE WHEN CUTOFF_DATE = CONVERT(NVARCHAR(10), GETDATE() -1, 120)  THEN QTY ELSE 0 END AS D1
							   , CASE WHEN CUTOFF_DATE = CONVERT(NVARCHAR(10), GETDATE(), 120)  THEN QTY ELSE 0 END AS D															
						  FROM SCM_AGING_STOCK_H S
						 WHERE SITE_ID = @P_SITE_ID
						   AND PLANT_ID IN (
											SELECT SEGMENT1
											  FROM SCM_SYS_LOOKUP_VALUE WITH(NOLOCK)
											 WHERE LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
											   AND ACTIVE_FLAG = 'Y'
											   AND SEGMENT2    = @P_BASIS_START_TIME
										   )
						   AND CUTOFF_DATE IN ( CONVERT(NVARCHAR(10), GETDATE() -1, 120), CONVERT(NVARCHAR(10), GETDATE(), 120) )
					   ) A
				 GROUP BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ITEM_ID

			   ) AA
		 WHERE FLAG = 1
*/
		--2020-01-21 piyong ADD
		SELECT COMPANY_ID
			   , DIVISION_ID
			   , SITE_ID
			   , PLANT_ID
		  FROM SCM_PLANT_M
		 WHERE SITE_ID = @P_SITE_ID
		   AND PLANT_ID IN (
							SELECT SEGMENT1
							  FROM SCM_SYS_LOOKUP_VALUE WITH(NOLOCK)
							 WHERE LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
							   AND ACTIVE_FLAG = 'Y'
							   AND SEGMENT2    = @P_BASIS_START_TIME
						   )


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
			SET @v_temp1 = 'SITE : ' + @P_SITE_ID + ' TIME : '+ @P_BASIS_START_TIME

			OPEN CUR_CAP_PLANT;
		
			FETCH NEXT FROM CUR_CAP_PLANT INTO @C_COMPANY_ID
											   , @C_DIVISION_ID
											   , @C_SITE_ID
											   , @C_PLANT_ID
										--	   , @C_FACTORY_ID

			WHILE (@@FETCH_STATUS = 0)
				BEGIN
					-- 조회쿼리

					SET @MAIL_TITLE = N'[Notification] ['+@C_PLANT_ID+' / '+
										(SELECT TOP 1 PLANT_NAME FROM SCM_PLANT_M WHERE PLANT_ID = @C_PLANT_ID) +
														']  AGING Inventory Info ('+ SUBSTRING(CONVERT(NVARCHAR(10),GETDATE(), 102), 3, 8)+')'
					SET @MAIL_CONTENT = N'Please check the quantity of items.'
					SET @MAIL_RECEIVER_LIST = ''
					SET @TABLE_CONTENTS = ''

					SET @BEFOR_PLANT_ID = ''
					SET @BEFOR_FACTORY_ID = ''


					DECLARE CUR_DATA_LIST CURSOR FOR
/*						--2020-01-21 piyong DEL
						SELECT PLANT_ID
							   ,FACTORY_ID
							   ,NICK_NAME
							   ,ITEM_ID
							   ,YESTERDAY
							   ,TO_DATE
							   ,COUNT(PLANT_ID) OVER( PARTITION BY PLANT_ID ORDER BY PLANT_ID ) AS PLANT_CNT
							   ,COUNT(FACTORY_ID) OVER( PARTITION BY PLANT_ID, FACTORY_ID ORDER BY PLANT_ID, FACTORY_ID ) AS FACTORY_CNT
						  FROM (
								SELECT AA.COMPANY_ID
									   , AA.DIVISION_ID
									   , AA.SITE_ID
									   , AA.PLANT_ID
									   , AA.FACTORY_ID
									   , AA.NICK_NAME
									   , AA.ITEM_ID
									   , TO_DATE
									   , YESTERDAY
									   , CASE WHEN TO_DATE  = 0 AND YESTERDAY  = 0 THEN 0
											  WHEN TO_DATE  = 0 THEN 1
											  WHEN YESTERDAY  = 0 THEN 1 
											  WHEN ( ( YESTERDAY - TO_DATE ) > MAX_CAPA ) OR ( ( TO_DATE -  YESTERDAY ) > MAX_CAPA ) THEN 1  ELSE 0 END FLAG
								  FROM (
										SELECT COMPANY_ID
											   , DIVISION_ID
											   , SITE_ID
											   , PLANT_ID
											   , FACTORY_ID
											   , NICK_NAME
											   , ITEM_ID
											   , SUM(D) AS TO_DATE
											   , SUM(D1) AS YESTERDAY
										  FROM (
												SELECT COMPANY_ID
													   , DIVISION_ID
													   , SITE_ID
													   , PLANT_ID
													   , FACTORY_ID
													   , LINE_ID
													   , CUTOFF_DATE
													   , ISNULL( (
																	SELECT NICK_NAME
																	  FROM SCM_ITEM_M
																	 WHERE COMPANY_ID = S.COMPANY_ID
																	   AND DIVISION_ID = S.DIVISION_ID
																	   AND SITE_ID = S.SITE_ID
																	   AND ITEM_ID = S.ITEM_ID			), '') AS NICK_NAME
													   , ITEM_ID
													   , CASE WHEN CUTOFF_DATE = CONVERT(NVARCHAR(10), GETDATE() -1, 120)  THEN QTY ELSE 0 END AS D1
													   , CASE WHEN CUTOFF_DATE = CONVERT(NVARCHAR(10), GETDATE(), 120)  THEN QTY ELSE 0 END AS D															
												  FROM SCM_AGING_STOCK_H S
												 WHERE COMPANY_ID	= @C_COMPANY_ID
												   AND DIVISION_ID	= @C_DIVISION_ID
												   AND SITE_ID		= @C_SITE_ID
												   AND PLANT_ID		= @C_PLANT_ID
												-- AND FACTORY_ID		= @C_FACTORY_ID
												   AND CUTOFF_DATE IN (
																		CONVERT(NVARCHAR(10), GETDATE() -1, 120)
																		, CONVERT(NVARCHAR(10), GETDATE(), 120)
																		)
											   ) A
										 GROUP BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, NICK_NAME, ITEM_ID
									   ) AA
									   LEFT OUTER JOIN (
														SELECT [COMPANY_ID]
															   ,[DIVISION_ID]
															   ,[SITE_ID]
															   ,[PLANT_ID]
															   ,[FACTORY_ID]
															   ,MAX([DAILY_CAPA] ) * 1.2 AS MAX_CAPA
														  FROM SCM_TACT_TIME_M
      													 WHERE SITE_ID		= @C_SITE_ID
														   AND PLANT_ID		= @C_PLANT_ID
														   AND OPERATION_ID ='F6000'
														   AND [MONTH]		= CONVERT( NVARCHAR(6), GETDATE(), 112)
														 GROUP BY [COMPANY_ID]
															   ,[DIVISION_ID]
															   ,[SITE_ID]
															   ,[PLANT_ID]
															   ,[FACTORY_ID]
													   ) B
												    ON AA.COMPANY_ID = B.[COMPANY_ID]
												   AND AA.DIVISION_ID = B.DIVISION_ID
												   AND AA.SITE_ID = B.SITE_ID
												   AND AA.PLANT_ID = B.PLANT_ID
												   AND AA.FACTORY_ID = B.FACTORY_ID
							   ) AAA
						 WHERE FLAG = 1
						 ORDER BY PLANT_ID, FACTORY_ID
							   , CASE WHEN NICK_NAME IS NOT NULL THEN NICK_NAME ELSE 'ZZZZZZ' END
							   , ITEM_ID
*/
						--2020-01-21 piyong ADD
						SELECT PLANT_ID
							   , FACTORY_ID
							   , NICK_NAME
							   , ITEM_ID
/*
							   , YESTERDAY
							   , TO_DATE
							   , ABS( TO_DATE - (YESTERDAY - RESULT_QTY ) ) AS INVEN_QTY
							   , ASSY_RESULT_QTY
							   , FORMATION_RESULT_QTY
							   , RESULT_QTY
							   , ABS(YESTERDAY - RESULT_QTY ) AS GAP_QTY
*/
							   --, REPLACE( CONVERT( VARCHAR, CONVERT( MONEY, YESTERDAY ), 1 ), '.00', '') AS YESTERDAY
							   , REPLACE( CONVERT( VARCHAR, CONVERT( MONEY, TO_DATE ), 1 ), '.00', '') AS TO_DATE
							   , REPLACE( CONVERT( VARCHAR, CONVERT( MONEY, YESTERDAY + RESULT_QTY ) , 1 ), '.00', '') AS INVEN_QTY
							   --, REPLACE( CONVERT( VARCHAR, CONVERT( MONEY, ASSY_RESULT_QTY) , 1 ), '.00', '') AS ASSY_RESULT_QTY
							   --, REPLACE( CONVERT( VARCHAR, CONVERT( MONEY, FORMATION_RESULT_QTY ), 1 ), '.00', '') AS FORMATION_RESULT_QTY
							   --, REPLACE( CONVERT( VARCHAR, CONVERT( MONEY, RESULT_QTY ), 1 ), '.00', '') AS RESULT_QTY
							   , REPLACE( CONVERT( VARCHAR, CONVERT( MONEY, TO_DATE - (YESTERDAY + RESULT_QTY ) ), 1 ), '.00', '') AS GAP_QTY

							   , COUNT(PLANT_ID) OVER( PARTITION BY PLANT_ID ORDER BY PLANT_ID ) AS PLANT_CNT
							   , COUNT(FACTORY_ID) OVER( PARTITION BY PLANT_ID, FACTORY_ID ORDER BY PLANT_ID, FACTORY_ID ) AS FACTORY_CNT
						  FROM (
								SELECT AA.COMPANY_ID
									   , AA.DIVISION_ID
									   , AA.SITE_ID
									   , AA.PLANT_ID
									   , AA.FACTORY_ID
									   , AA.NICK_NAME
									   , AA.ITEM_ID
									   , FLOW_ID
									   , FORMATION_FLOW_ID
									   , AA.TO_DATE
									   , AA.YESTERDAY
--									   , CONVERT(INT, ABS( AA.INVEN_QTY ) ) AS INVEN_QTY
									   , ISNULL(BB.ASSY_RESULT_QTY, 0) AS ASSY_RESULT_QTY
									   , ISNULL(CC.FORMATION_RESULT_QTY , 0 ) AS FORMATION_RESULT_QTY
									   , CONVERT(INT, ISNULL(BB.ASSY_RESULT_QTY, 0) - ISNULL(CC.FORMATION_RESULT_QTY , 0 ) ) AS RESULT_QTY
									   , CASE WHEN AA.YESTERDAY = 0  AND ISNULL(BB.ASSY_RESULT_QTY, 0) = 0 AND ISNULL(CC.FORMATION_RESULT_QTY , 0 ) = 0 THEN
												0
										--	  WHEN AA.YESTERDAY > 0 AND ( ISNULL(BB.ASSY_RESULT_QTY, 0) - ISNULL(CC.FORMATION_RESULT_QTY , 0 ) ) < 0 THEN
										--		1
											  WHEN AA.YESTERDAY = 0 AND ISNULL(CC.FORMATION_RESULT_QTY , 0 ) > 0 THEN
												1
											  WHEN ( AA.YESTERDAY + ISNULL(BB.ASSY_RESULT_QTY, 0) - ISNULL(CC.FORMATION_RESULT_QTY , 0 ) ) * 0.9 <= AA.TO_DATE
											     AND   AA.TO_DATE <= ( AA.YESTERDAY +  ISNULL(BB.ASSY_RESULT_QTY, 0) - ISNULL(CC.FORMATION_RESULT_QTY , 0) ) * 1.1 THEN
												0
											  ELSE
												1
											  END
											 AS FLAG
								  FROM (
										SELECT COMPANY_ID
											   , DIVISION_ID
											   , SITE_ID
											   , PLANT_ID
											   , FACTORY_ID
											   , NICK_NAME
											   , ITEM_ID
											   , FLOW_ID
											   , FORMATION_FLOW_ID
											   , CONVERT(INT, SUM(D) ) AS TO_DATE
											   , CONVERT(INT, SUM(D1) ) AS YESTERDAY
--											   , SUM(D) - SUM(D1) AS INVEN_QTY
										  FROM (
												SELECT S.COMPANY_ID
													   , S.DIVISION_ID
													   , S.SITE_ID
													   , S.PLANT_ID
													   , S.FACTORY_ID
													   , S.CUTOFF_DATE
													   , ISNULL( (
																	SELECT NICK_NAME
																	  FROM SCM_ITEM_M
																	 WHERE COMPANY_ID = S.COMPANY_ID
																	   AND DIVISION_ID = S.DIVISION_ID
																	   AND SITE_ID = S.SITE_ID
																	   AND ITEM_ID = S.ITEM_ID			), '') AS NICK_NAME
													   , S.ITEM_ID
													   , BB.FLOW_ID
													   , BB.FORMATION_FLOW_ID
													   , CASE WHEN CUTOFF_DATE = CONVERT(NVARCHAR(10), GETDATE() -1, 120)  THEN QTY ELSE 0 END AS D1
													   , CASE WHEN CUTOFF_DATE = CONVERT(NVARCHAR(10), GETDATE(), 120)  THEN QTY ELSE 0 END AS D
												  FROM SCM_AGING_STOCK_H S
													   INNER JOIN (
																	SELECT COMPANY_ID
																		   , DIVISION_ID
																		   , SITE_ID
																		   , ITEM_ID
																		   , FLOW_ID
																		   , FORMATION_FLOW_ID
																	  FROM (
																			SELECT COMPANY_ID
																				   , DIVISION_ID
																				   , SITE_ID
																				   , ITEM_ID
																				   , FLOW_ID
																				   , RIGHT(FORMATION_FLOW_ID, 5) AS FORMATION_FLOW_ID
																			  FROM SCM_ITEM_M
																			 WHERE FORMATION_FLOW_ID IS NOT NULL
																			   AND SITE_ID = @C_SITE_ID
																			 GROUP BY COMPANY_ID
																				   ,DIVISION_ID
																				   ,SITE_ID
																				   ,ITEM_ID
																				   ,FLOW_ID
																				   ,RIGHT(FORMATION_FLOW_ID, 5)
																		   ) B
																  ) BB
															   ON S.COMPANY_ID	= BB.COMPANY_ID
															  AND S.DIVISION_ID	= BB.DIVISION_ID
															  AND S.SITE_ID		= BB.SITE_ID
															  AND S.ITEM_ID		= BB.ITEM_ID
												 WHERE S.SITE_ID		= @C_SITE_ID
												   AND S.PLANT_ID		= @C_PLANT_ID
								--				   AND S.iTEM_ID ='MCSS20253-A2'
												   AND CUTOFF_DATE IN (
																		CONVERT(NVARCHAR(10), GETDATE() -1, 120)
																		, CONVERT(NVARCHAR(10), GETDATE(), 120)
																	  )
											   ) A
										 GROUP BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, NICK_NAME, ITEM_ID
											   , FLOW_ID, FORMATION_FLOW_ID
									   ) AA
									   LEFT OUTER JOIN (
														SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ITEM_ID, OPERATION_ID
																, CONVERT(INT, SUM(D) ) AS ASSY_RESULT_QTY
														  FROM (
																SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ITEM_ID, OPERATION_ID, PLAN_DATE
																	   , CASE WHEN PLAN_DATE = CONVERT(NVARCHAR(10), GETDATE() -1, 120)  THEN ACTUAL_GOOD_QTY ELSE 0 END AS D
																  FROM SCM_DAILY_PRODUCT_RESULT_H
 																 WHERE SITE_ID		= @C_SITE_ID
																   AND PLANT_ID		= @C_PLANT_ID
																   AND PLAN_DATE	= CONVERT(NVARCHAR(10), GETDATE() -1, 120)
															--	   AND ITEM_ID ='MCSS20253-A2'	
															   ) B
														 GROUP BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ITEM_ID, OPERATION_ID
													   ) BB
													ON AA.COMPANY_ID	= BB.COMPANY_ID
												   AND AA.DIVISION_ID	= BB.DIVISION_ID
												   AND AA.SITE_ID		= BB.SITE_ID
												   AND AA.PLANT_ID		= BB.PLANT_ID
												   AND AA.FACTORY_ID	= BB.FACTORY_ID
												   AND AA.ITEM_ID		= BB.ITEM_ID
												   AND AA.FLOW_ID		= BB.OPERATION_ID
									   LEFT OUTER JOIN (
														SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ITEM_ID, OPERATION_ID
																, CONVERT(INT, SUM(D) ) AS FORMATION_RESULT_QTY
														  FROM (
																SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ITEM_ID, OPERATION_ID, PLAN_DATE
																	   , CASE WHEN PLAN_DATE = CONVERT(NVARCHAR(10), GETDATE() -1, 120)  THEN ACTUAL_GOOD_QTY ELSE 0 END AS D		
																  FROM SCM_DAILY_PRODUCT_RESULT_H
 																 WHERE SITE_ID		= @C_SITE_ID
																   AND PLANT_ID		= @C_PLANT_ID
																   AND PLAN_DATE	= CONVERT(NVARCHAR(10), GETDATE() -1, 120)
															--	   AND ITEM_ID ='ACEN1076I-A1'
															   ) C
														 GROUP BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ITEM_ID, OPERATION_ID
													   ) CC
													ON AA.COMPANY_ID		= CC.COMPANY_ID
												   AND AA.DIVISION_ID		= CC.DIVISION_ID
												   AND AA.SITE_ID			= CC.SITE_ID
												   AND AA.PLANT_ID			= CC.PLANT_ID
												   AND AA.FACTORY_ID		= CC.FACTORY_ID
												   AND AA.ITEM_ID			= CC.ITEM_ID
												   AND AA.FORMATION_FLOW_ID	= CC.OPERATION_ID
								 WHERE ISNULL(BB.ASSY_RESULT_QTY, 0) > 0 OR ISNULL(CC.FORMATION_RESULT_QTY , 0 ) > 0
							   ) AAA
						 WHERE FLAG = 1
						 ORDER BY PLANT_ID, FACTORY_ID
								  , CASE WHEN NICK_NAME IS NOT NULL THEN NICK_NAME ELSE 'ZZZZZZ' END
								  , ITEM_ID


						OPEN CUR_DATA_LIST;
		
						FETCH NEXT FROM CUR_DATA_LIST INTO @PLANT_ID
															,@FACTORY_ID
															,@NICK_NAME
															,@ITEM_ID
													--		,@YESTERDAY_CNT
															,@TO_DATE_CNT
															---------------------------
															--2020-01-21 piyong ADD
															,@INVEN_QTY
													--		,@ASSY_RESULT_QTY
													--		,@FORMATION_RESULT_QTY
													--		,@RESULT_QTY
															,@GAP_QTY
															--2020-01-21 piyong ADD END
															---------------------------
															,@PLANT_CNT
															,@FACTORY_CNT

							WHILE (@@FETCH_STATUS = 0)
								BEGIN

									SET @TABLE_CONTENTS = @TABLE_CONTENTS+'<tr>'
									IF @BEFOR_PLANT_ID != @PLANT_ID
										BEGIN
											SET @TABLE_CONTENTS = @TABLE_CONTENTS + '<td ROWSPAN='''+CAST(@PLANT_CNT AS nvarchar)+'''>'+@PLANT_ID+'</td>'
											SET @BEFOR_PLANT_ID = @PLANT_ID
										END

									IF @BEFOR_FACTORY_ID != @FACTORY_ID
										BEGIN
											SET @TABLE_CONTENTS = @TABLE_CONTENTS + '<td ROWSPAN='''+CAST(@FACTORY_CNT AS nvarchar)+'''>'+@FACTORY_ID+'</td>'
											SET @BEFOR_FACTORY_ID = @FACTORY_ID
										END

									SET @TABLE_CONTENTS = @TABLE_CONTENTS+'<td>'+@NICK_NAME+'</td>'
									SET @TABLE_CONTENTS = @TABLE_CONTENTS+'<td>'+@ITEM_ID+'</td>'

--									SET @TABLE_CONTENTS = @TABLE_CONTENTS+'<td style = "font-weight:bold;text-align:right;padding:10px;" >'+@GAP_QTY+'</td>'	--2020-01-21 piyong ADD

									SET @TABLE_CONTENTS = @TABLE_CONTENTS+'<td style = "text-align:right;padding:10px;">'+@TO_DATE_CNT+'</td>'
									SET @TABLE_CONTENTS = @TABLE_CONTENTS+'<td style = "text-align:right;padding:10px;">'+@INVEN_QTY+'</td>'				--2020-01-21 piyong ADD
									SET @TABLE_CONTENTS = @TABLE_CONTENTS+'<td style = "text-align:right;padding:10px;">'+@GAP_QTY+'</td>'
--									SET @TABLE_CONTENTS = @TABLE_CONTENTS+'<td style = "text-align:right;padding:10px;">  </td>'		--2020-01-21 piyong ADD

--									SET @TABLE_CONTENTS = @TABLE_CONTENTS+'<td style = "text-align:right;padding:10px;">'+@ASSY_RESULT_QTY+'</td>'		--2020-01-21 piyong ADD
--									SET @TABLE_CONTENTS = @TABLE_CONTENTS+'<td style = "text-align:right;padding:10px;">'+@FORMATION_RESULT_QTY+'</td>'	--2020-01-21 piyong ADD


									SET @TABLE_CONTENTS = @TABLE_CONTENTS+'</tr>'

									FETCH NEXT FROM CUR_DATA_LIST INTO @PLANT_ID
																		,@FACTORY_ID
																		,@NICK_NAME
																		,@ITEM_ID
																	--	,@YESTERDAY_CNT
																		,@TO_DATE_CNT
																		---------------------------
																		--2020-01-21 piyong ADD
																		,@INVEN_QTY
																	--	,@ASSY_RESULT_QTY
																	--	,@FORMATION_RESULT_QTY
																	--	,@RESULT_QTY
																		,@GAP_QTY
																		--2020-01-21 piyong ADD END
																		---------------------------
																		,@PLANT_CNT
																		,@FACTORY_CNT
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
           							<table style=''border-top:2px solid #c8294b; width:1420px;''>
               							<thead>' 
											+'<tr>'
											+'	<th ROWSPAN=''2'' >Plant</th>'
											+'	<th ROWSPAN=''2'' >Factory</th>'
											+'	<th ROWSPAN=''2'' >PJT Code</th>'
											+'	<th ROWSPAN=''2'' >Material</th>'
											+'	<th COLSPAN=''3'' >Inventory</th>'			--2020-01-21 piyong ADD
									--		+'	<th COLSPAN=''2'' >Product Result</th>'		--2020-01-21 piyong ADD
											+'</tr>'
											+'<tr>'
											+'	<th>Today Qty</th>'
											+'	<th>Today Qty</BR>(calculation)</th>'
											+'	<th>Gap Qty</th>'							--2020-01-21 piyong ADD
									--		+'	<th>ERP Qty</th>'							--2020-01-21 piyong ADD
									--		+'	<th>EOL Qty</th>'							--2020-01-21 piyong ADD
											+'</tr>'
               							+'</thead>
               							<tbody>' + ISNULL(@TABLE_CONTENTS, '') + '</tbody>
									</table>
       							</div>
   							</div>
						</body>
						</html>'


					IF LEN(@TABLE_CONTENTS) > 0
						BEGIN

							DECLARE CUR_RECIPIENT_LIST CURSOR FOR				
								SELECT ATTRIBUTE3
								  FROM [DBO].[SCM_SYS_LOOKUP_VALUE] SLV WITH(NOLOCK)
								 WHERE LOOKUP_TYPE_CODE = 'SMS_ADDRESSEE'
								   AND SEGMENT1 = 'ELECTRODE_PI'
								   AND ATTRIBUTE4 = 'Y'
								   AND ATTRIBUTE1 IS NOT NULL


							OPEN CUR_RECIPIENT_LIST;
		
							FETCH NEXT FROM CUR_RECIPIENT_LIST INTO @MAIL_ADDR

							WHILE (@@FETCH_STATUS = 0)

								BEGIN
									SET @MAIL_RECEIVER_LIST = @MAIL_RECEIVER_LIST+';'+ ISNULL( @MAIL_ADDR, '')

									FETCH NEXT FROM CUR_RECIPIENT_LIST INTO @MAIL_ADDR
									END
							;

							CLOSE CUR_RECIPIENT_LIST;
							DEALLOCATE CUR_RECIPIENT_LIST;



							EXEC MSDB.DBO.SP_SEND_DBMAIL @profile_name           = 'FP_MAIL_TEST'
								, @recipients             = @MAIL_RECEIVER_LIST
								, @query_result_separator = ';'
								, @subject                = @MAIL_TITLE
								, @body                   = @TABLE_BODY
								, @body_format            = 'html'


							DECLARE CUR_MAIL_ADDR_LIST CURSOR FOR							--instance별 MAIL 수신자  조회
								SELECT ATTRIBUTE1	
									FROM [DBO].[SCM_SYS_LOOKUP_VALUE] WITH(NOLOCK)
									WHERE LOOKUP_TYPE_CODE = 'FORMATION_GAP_INFO_MAIL'
									AND REPLACE(SEGMENT1, '-', @C_SITE_ID)	= @C_SITE_ID
									AND REPLACE(SEGMENT2, '-', @C_PLANT_ID)	= @C_PLANT_ID
									AND @C_PLANT_ID NOT IN ('3050', 'HQ06',  'G182', 'G183')
									AND ACTIVE_FLAG = 'Y'
									AND ATTRIBUTE1 IS NOT NULL


							OPEN CUR_MAIL_ADDR_LIST;
		
							SET @MAIL_RECEIVER_LIST = '';
							SET @MAIL_CNT = 0;

							FETCH NEXT FROM CUR_MAIL_ADDR_LIST INTO @ADDR_LIST
							WHILE (@@FETCH_STATUS = 0)
								BEGIN
									SET @MAIL_CNT = @MAIL_CNT +1;
									SET @MAIL_RECEIVER_LIST =  @MAIL_RECEIVER_LIST+';'+ @ADDR_LIST

									IF @MAIL_CNT % 30 = 0
										BEGIN
											EXEC  msdb.dbo.sp_send_dbmail @profile_name		= 'FP_MAIL_TEST'
																	, @recipients             = @MAIL_RECEIVER_LIST
																	, @query_result_separator = ';'
																	, @subject                = @MAIL_TITLE
																	, @body                   = @TABLE_BODY
																	, @body_format            = 'html'
											;

											SET @MAIL_CNT = 0;
											SET @MAIL_RECEIVER_LIST = '';
										END
									FETCH NEXT FROM CUR_MAIL_ADDR_LIST INTO @ADDR_LIST
									;
								END;
			
							CLOSE CUR_MAIL_ADDR_LIST;
							DEALLOCATE CUR_MAIL_ADDR_LIST;

							IF @MAIL_CNT > 0 AND @MAIL_RECEIVER_LIST != ''
								BEGIN
									EXEC  msdb.dbo.sp_send_dbmail @profile_name		= 'FP_MAIL_TEST'
															, @recipients             = @MAIL_RECEIVER_LIST
															, @query_result_separator = ';'
															, @subject                = @MAIL_TITLE
															, @body                   = @TABLE_BODY
															, @body_format            = 'html'
								END

						END;

					FETCH NEXT FROM CUR_CAP_PLANT INTO @C_COMPANY_ID
													, @C_DIVISION_ID
													, @C_SITE_ID
													, @C_PLANT_ID
										--	   , @C_FACTORY_ID
					;
				END;
			
			CLOSE CUR_CAP_PLANT;
			DEALLOCATE CUR_CAP_PLANT;


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
