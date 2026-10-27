
CREATE PROCEDURE [dbo].[PR_XIF_SCP_SALES_EXFACTORY_R]

-- ================================================================================================
-- Program ID          : 
-- Program Name        : PR_XIF_SCP_SALES_EXFACTORY_R
-- Param               :
-- Batch Period        : 15 MINUTE
-- Description         :
--
-- Source System       : SCP
-- Destination System  : FP SDB
-- Source Table        : XIF_SCP_SALES_EXFACTORY_R
-- Destination Table   : FP_WEEKLY_DEMAND_SHIPMENT_SCP_H
--
-- Create Date		   : 2018.04.26
-- Update Date		   : 2018.06.11 1.1 PIYONG
--						 2018.07.24 1.2 PIYONG
--						 2018.08.02 1.3 PIYONG
--						 2018.08.16 1.4 PIYONG
--                       2018.08.21 1.5 KIMCD
--						 2018.09.17	1.6 PIYONG
--						 2018.10.11 1.7 PIYONG
--						 2019.05.29 1.8 PIYONG
--						 2020.02.25 2.0 PIYONG
--						 2022.03.30 2.1 kimcd

-- Author              : PIYONG
-- Version             : 1.0
--						 1.1 PLAN_TYPE FN 추가
--						 1.2 DIVISION 별 메일 발송
--						 1.3 PLANT 별 DEMAND_TYPE_MAPPING
--							 도착예정일, 도착지 컬럼 추가
--						 1.4 DIVISION EE(전극) 처리 로직 추가
--                       1.5 2018-08-21 KIMCD 도착지 코드(ship_to_code) 컬럼 추가
--						 1.6 CNA PRODUCTION_TYPE 조회 조건 추가
--						 1.7 A002 MARKET 값이 없을 경우 조건없이 'E' (CASE ->  'E')
--						 1.8 SCM_SCP_PLAN_H  PLAN_WEEK 컬럼 단자리 주차 생성시 0 생성되도록 변경
---						 2.0 TARGET 생성 구간 설정 로직 추가
-- 						 2.1 2022-03-30 kimcd JV용 가상 Division 로직 추가
---- ================================================================================================

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_SCP_SALES_EXFACTORY_R'
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
	DECLARE @CNT_CHK			NUMERIC(10,0)	= 0
	DECLARE @V_PLAN_WEEK		NVARCHAR(50)
	DECLARE @DIVISION           NVARCHAR(30)
	DECLARE @SHOP_GROUP         NVARCHAR(50)            -- 2022-03-30 kimcd 공정 군 추가
	DECLARE @V_SCP_PLAN_ID		NVARCHAR(50)
	DECLARE @DIVISION_NAME		NVARCHAR(150)	-- 2018-07-18 PIYONG ADD


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
		
		DECLARE @PROC_FLAG_CHK    NUMERIC(10,0)

		SET @PROC_FLAG_CHK = (
								SELECT COUNT(PROC_FLAG)
								  FROM [dbo].[SY_XIF_SCP_SALES_EXFACTORY_R]
								 WHERE ISNULL(PROC_FLAG,'N') = 'N'
								   AND PLAN_TYPE IN ( 'MA', 'FN')	--2018-06-11 PIYONG FN ADD
							)

		IF @PROC_FLAG_CHK > 0

			BEGIN
				DECLARE CUR_DIVISION CURSOR FOR
					SELECT DIVISION
						   , MAX(PLAN_WEEK) AS PLAN_WEEK
						   , MAX(OPERATION_GROUP) AS SHOP_GROUP_ID  -- 2022-03-30 kimcd 공정 군 추가
					FROM   [dbo].[SY_XIF_SCP_SALES_EXFACTORY_R]
					WHERE  ISNULL(PROC_FLAG,'N') = 'N'
					AND    PLAN_TYPE IN ( 'MA', 'FN')				--2018-06-11 PIYONG FN ADD
					GROUP  BY DIVISION
				
				OPEN CUR_DIVISION
				FETCH NEXT FROM CUR_DIVISION INTO @DIVISION
												, @V_PLAN_WEEK 
												, @SHOP_GROUP -- 2022-03-30 kimcd 공정 군 추가

				WHILE @@FETCH_STATUS = 0 -- DATA 가 존재하여 정상적으로 반환된 경우 : 0
				BEGIN
					-- ================================================================================================                                                                                                      
					-- @V_SCP_PLAN_ID 구하기                                                                                                                               
					-- ================================================================================================							
					SET @V_SCP_PLAN_ID = @V_PLAN_WEEK;

					SET @CNT_CHK = (
									SELECT COUNT(1) -- 값이 0 보다 크면 수행을 하면 안됨.
										FROM (
												SELECT (
														SELECT COUNT(1)
															FROM [dbo].[SY_XIF_SCP_SALES_EXFACTORY_R] A
															WHERE A.PLAN_WEEK	  = @V_PLAN_WEEK
															AND A.PLAN_TYPE IN ( 'MA', 'FN')		--2018-06-11 PIYONG FN ADD
															AND ISNULL(A.PROC_FLAG,'N') = 'N'
															AND A.DIVISION        = @DIVISION
															AND A.DIVISION        = W.SEGMENT1
															AND A.OPERATION_GROUP = W.SEGMENT2
															AND A.PLANT_ID		  = W.SEGMENT4
														) COUNTS
														,W.SEGMENT1
												FROM [DBO].[SCM_SYS_LOOKUP_VALUE] W WITH(NOLOCK)
												WHERE W.LOOKUP_TYPE_CODE = 'SCP_PLANT'
												AND ATTRIBUTE3 = 'Y'
												AND ACTIVE_FLAG = 'Y'
											) X
										WHERE COUNTS = 0
										AND SEGMENT1 IN (
															SELECT DISTINCT DIVISION
															FROM [dbo].[SY_XIF_SCP_SALES_EXFACTORY_R] A
															WHERE A.PLAN_WEEK = @V_PLAN_WEEK
																AND ISNULL(A.PROC_FLAG,'N') = 'N'
																AND A.PLAN_TYPE IN ( 'MA', 'FN')	--2018-06-11 PIYONG FN ADD
																AND A.DIVISION  = @DIVISION

														)
							)
        

					IF @CNT_CHK = 0

						BEGIN	  
  
							-- SCP Target수신 정보를 SDB로 적재
							INSERT INTO [DBO].[FP_WEEKLY_DEMAND_SHIPMENT_SCP_H]
							(
								COMPANY_ID
								,DIVISION_ID
								,SITE_ID
								,PLANT_ID
								,SHOP_GROUP_ID
								,SCP_PLAN_ID
								,SCP_TARGET_ID
								,FP_TARGET_ID
								,ITEM_ID
								,TO_SITE_ID
								,TO_PLANT_ID
								,CUSTOMER_ID
								,SHIP_DATE
								,SHIP_WEEK
								,SHIP_QTY
								,PRODUCTION_TYPE
								,TRANSPORT_MODE
								,BIZ_TYPE
								,CONFIRM_TYPE
								,MARKET
								,SHIP_TO_PARTY			--2018-08-02 PIYONG ADD
								,RECEIVE_YYYYMMDD		--2018-08-02 PIYONG ADD
								,SHIP_TO_CODE           --2018-08-21 KIMCD 도착지 코드 ADD
								,INSERT_ID
								,INSERT_TIME
								,UPDATE_ID
								,UPDATE_TIME
							)
							SELECT A.COMPANY_ID,
								   A.DIVISION_ID,
								   A.SITE_ID,
								   A.PLANT_ID,
								   A.SHOP_GROUP_ID,
								   A.SCP_PLAN_ID,
								   A.SCP_TARGET_ID,
								   A.FP_TARGET_ID,
								   MAX(A.ITEM_ID) AS ITEM_ID,
								   MAX(A.TO_SITE_ID) AS TO_SITE_ID,
								   MAX(A.TO_PLANT_ID) AS TO_PLANT_ID,
								   MAX(A.CUSTOMER_ID) AS CUSTOMER_ID,
								   A.SHIP_DATE      AS SHIP_DATE, --2018-08-21 KIMCD group by에 포함
								   MAX(A.SHIP_WEEK) AS SHIP_WEEK,
								   SUM(A.SHIP_QTY) AS SHIP_QTY,
								   MAX(A.PRODUCTION_TYPE) AS PRODUCTION_TYPE,
								   MAX(A.TRANSPORT_MODE) AS TRANSPORT_MODE,
								   NULL AS BIZ_TYPE,
								   NULL AS CONFIRM_TYPE,
								   A.MARKET,
								   MAX(A.SHIP_TO_PARTY) AS SHIP_TO_PARTY,			--2018-08-02 PIYONG ADD
								   MAX(A.RECEIVE_YYYYMMDD) AS RECEIVE_YYYYMMDD,		--2018-08-02 PIYONG ADD
								   MAX(A.SHIP_TO_CODE) AS SHIP_TO_CODE,             --2018-08-21 KIMCD 도착지 코드 ADD
								   'PR_XIF_SCP_SALES_EXFACTORY_R' AS INSERT_ID,
								   GETDATE() AS INSERT_TIME,
								   'PR_XIF_SCP_SALES_EXFACTORY_R' AS UPDATE_ID,
								   GETDATE() AS UPDATE_TIME
							  FROM (
									SELECT P.COMPANY_ID
											,B.SEGMENT3 AS DIVISION_ID					-- 2018-08-16 PIYONG CHANGE A.DIVISION -> B.SEGMENT3
											,P.SITE_ID
											,A.PLANT_ID
											,A.OPERATION_GROUP							AS SHOP_GROUP_ID
											,@V_PLAN_WEEK AS SCP_PLAN_ID
											,SHIP_ID AS SCP_TARGET_ID
											,'-' AS FP_TARGET_ID
											,ITEM_ID
											,ISNULL(( SELECT TOP 1 P.SITE_ID                                                                                                                        
														FROM [DBO].[SCM_PLANT_M] P WITH(NOLOCK)                                                                                             
														WHERE A.DEST_PLANT_ID = P.PLANT_ID		), A.DEST_SITE_CODE		) AS TO_SITE_ID
											,ISNULL(A.DEST_PLANT_ID, A.PLANT_ID)		 AS TO_PLANT_ID
											,CUSTOMER_CODE								 AS CUSTOMER_ID
											,EXFACTORY_YYYYMMDD							 AS SHIP_DATE
											,( SELECT TOP 1 [ISO_YYYYWW]
												FROM [DBO].[TH_UIS_CAL] WITH(NOLOCK)
												WHERE [YYYYMMDD] = A.EXFACTORY_WEEK)	 AS SHIP_WEEK
											,EXFACTORY_QTY AS SHIP_QTY
											,C.ATTRIBUTE2								 AS PRODUCTION_TYPE
											,SHIP_METHOD AS TRANSPORT_MODE
											,CASE WHEN P.SITE_ID = 'A002' THEN 
													ISNULL( ( SELECT TOP 1 M.DEFAULT_MARKET 
																FROM SCM_MODEL_MARKET_M M WITH(NOLOCK)
															   WHERE M.COMPANY_ID  = P.COMPANY_ID
																 AND M.DIVISION_ID = P.DIVISION_ID
																 AND M.SITE_ID     = P.SITE_ID                                                                                                                        
																 AND M.ITEM_ID = A.ITEM_ID
																 AND M.PRODUCTION_TYPE = C.ATTRIBUTE2		--2018-09-17 PIYONG 조건 추가
																 AND ISNULL(M.ACTIVE_FLAG,'N') = 'Y'
															),  'E' --CASE WHEN AA.MARKET = '-' THEN 'D' ELSE AA.MARKET END	-- 2018-10-10 PIYONG  CASE WHEN AA.MARKET = '-' THEN 'D' ELSE AA.MARKET END -> 'E'
														  )
												  ELSE
													 CASE WHEN A.MARKET = '-' THEN 'D' ELSE A.MARKET END
												   END							 		AS MARKET
											,A.SHIP_TO_PARTY								--2018-08-02 PIYONG ADD
											,A.RECEIVE_YYYYMMDD								--2018-08-02 PIYONG ADD
											,A.SHIP_TO_CODE                                 --2018-08-21 KIMCD 도착지 코드 ADD
									   FROM [dbo].[SY_XIF_SCP_SALES_EXFACTORY_R] A
											,(
												SELECT   W.SEGMENT4  PLANT
														,W.SEGMENT3
														,W.SEGMENT2  OPERATION_GROUP
														,W.SEGMENT1  DIVISION
														,W.ATTRIBUTE5
													FROM [DBO].[SCM_SYS_LOOKUP_VALUE] W WITH(NOLOCK)
													WHERE W.LOOKUP_TYPE_CODE = 'SCP_PLANT'
													AND ATTRIBUTE3 = 'Y'   
											) B
											,(SELECT *
												FROM [DBO].[SCM_SYS_LOOKUP_VALUE] W WITH(NOLOCK)
												WHERE W.LOOKUP_TYPE_CODE = 'SCP_DEMAND_TYPE_MAPPING'
												AND ACTIVE_FLAG = 'Y') C
											,[SCM_PLANT_M] P
										WHERE A.PLAN_WEEK     = @V_PLAN_WEEK
										AND A.DIVISION        = @DIVISION
										AND ISNULL(A.PROC_FLAG,'N') = 'N'
										AND A.PLAN_TYPE IN ( 'MA', 'FN')	--2018-06-11 PIYONG FN ADD
										AND A.SHIP_ID IS NOT NULL
							   			AND A.EXFACTORY_QTY   > 0
										AND (
												--A.DIVISION != 'EE'
												@SHOP_GROUP != 'E' -- 2022-03-30 kimcd 가상 Division 대응하여 공정군 조건으로 변경
												OR (
													--A.DIVISION = 'EE'  AND A.ITEM_ID LIKE 'APC%'
													@SHOP_GROUP = 'E' AND A.ITEM_ID LIKE 'APC%' -- 2022-03-30 kimcd 가상 Division 대응하여 공정군 조건으로 변경
												   )
										   )  -- 2018-08-16 PIYONG ADD
										AND A.OPERATION_GROUP = B.OPERATION_GROUP 
										AND A.PLANT_ID	      = B.PLANT 
										AND A.DIVISION        = B.DIVISION
										------------------------------------------------------------------------------------------------------------------------------------------------
									    -- 2020-02-25 PIYONG ADD
										AND A.EXFACTORY_YYYYMMDD < CONVERT(NVARCHAR(8), (
																							SELECT MAX( WEEKSTART_DATE )
																							  FROM [DBO].SCM_SYS_CALENDAR_M WITH(NOLOCK)
																							 WHERE DATE_ID = DATEADD( WW, CONVERT(INT, B.ATTRIBUTE5), CONVERT( DATE, GETDATE(), 120) )
																						), 112)
										-- 2020-02-25 PIYONG ADD END
										------------------------------------------------------------------------------------------------------------------------------------------------
										AND A.ORDER_TYPE	  = C.SEGMENT1
										AND A.PLANT_ID		  = C.SEGMENT2	--2018-08-01 PIYONG
										AND A.PLANT_ID		  = P.PLANT_ID	
									) A 
								GROUP BY A.COMPANY_ID,
									A.DIVISION_ID,
									A.SITE_ID,
									A.PLANT_ID,
									A.SHOP_GROUP_ID,
									A.SCP_PLAN_ID,
									A.SCP_TARGET_ID,
									A.FP_TARGET_ID,
									A.SHIP_DATE, --2018-08-21 KIMCD group by에 포함
									A.MARKET
							;

							SET @ROWCOUNT = @@ROWCOUNT

							MERGE INTO [DBO].[SCM_SCP_PLAN_H] A
							USING (
									SELECT @V_PLAN_WEEK AS SCP_PLAN_ID,
											'SHIPMENT' AS SCP_PLAN_TYPE,
											CONVERT(DATETIME, SUBSTRING(@V_PLAN_WEEK, 1, 8)) AS PLAN_START_TIME,
											200 AS PLAN_HORIZON,
											200 AS DEMAND_HORIZON,
											SUBSTRING(@V_PLAN_WEEK, 1, 4) + 
												REPLICATE('0', 2 - LEN(DATEPART(WW, SUBSTRING(@V_PLAN_WEEK, 1, 8)) )) +
													CAST(DATEPART(WW, SUBSTRING(@V_PLAN_WEEK, 1, 8))  AS VARCHAR)  AS PLAN_WEEK	--2019-05-29 PIYONG CHANGE 단자리 주차앞에 0 생성하도록 변경
									) B
								ON (
									A.SCP_PLAN_ID = B.SCP_PLAN_ID
									)
								WHEN MATCHED THEN

								UPDATE SET  A.[SCP_PLAN_TYPE]     = B.[SCP_PLAN_TYPE]
											,A.[PLAN_START_TIME]   = B.[PLAN_START_TIME]
											,A.[PLAN_HORIZON]      = B.[PLAN_HORIZON]
											,A.[DEMAND_HORIZON]    = B.[DEMAND_HORIZON]
											,A.UPDATE_ID           = 'PR_XIF_SCP_SALES_EXFACTORY_R'
											,A.UPDATE_TIME         = GETDATE()

								WHEN NOT MATCHED THEN

								INSERT ([SCP_PLAN_ID]
										,[SCP_PLAN_TYPE]
										,[PLAN_START_TIME]
										,[PLAN_HORIZON]
										,[DEMAND_HORIZON]
										,[PLAN_WEEK]
										,[INSERT_ID]
										,[INSERT_TIME]
										,[UPDATE_ID]
										,[UPDATE_TIME]
								) VALUES (
										B.SCP_PLAN_ID,
										B.SCP_PLAN_TYPE,
										B.PLAN_START_TIME,
										B.PLAN_HORIZON,
										B.DEMAND_HORIZON,
										B.PLAN_WEEK,
										'PR_XIF_SCP_SALES_EXFACTORY_R',
										GETDATE(),
										'PR_XIF_SCP_SALES_EXFACTORY_R',
										GETDATE()
								)
							;

							UPDATE [dbo].[SY_XIF_SCP_SALES_EXFACTORY_R]
							   SET PROC_FLAG = 'Y'
									,PROC_DATE = GETDATE()
							 WHERE PROC_FLAG = 'N'
							   AND PLAN_WEEK = @V_PLAN_WEEK
							   AND DIVISION  = @DIVISION
							;

							IF @ROWCOUNT > 0
								BEGIN
									-- 2018-07-24 PIYONG ADD
									SET @DIVISION_NAME = (
															SELECT TOP 1 DIVISION_NAME
																FROM SCM_DIVISION_M
																WHERE DIVISION_ID = @DIVISION
																ORDER BY DIVISION_NAME
															)

									-- 2018-08-16 PIYONG ADD
									--IF @DIVISION = 'EE'
									IF @SHOP_GROUP = 'E' -- 2022-03-30 kimcd 가상 Division 대응하여 공정군 조건으로 변경
										BEGIN
											SET @DIVISION_NAME = @DIVISION + ' Electrode'
										END


									INSERT INTO dbo.SCM_MAILING_H
									(   [MAIL_PKEY]
										,[MAIL_SEQ]
										,[MAIL_DATETIME]
										,[MAIL_SUBJECT]
										,[MAIL_BODY]
										,[MAIL_QUERY]
										,[ATTACH_FILE_NAME]
										,[MAIL_RECEIVER_LIST]
										,[MAIL_PROFILE_NAME]
										,[MAIL_SEND_FLAG]
										,[MESSAGE]
										,[CREATE_USER_ID]
										,[CREATE_DATE]
										,[MODIFY_USER_ID]
										,[MODIFY_DATE]
									)
									SELECT [MAIL_PKEY]
											, NEXT VALUE FOR SEQ_SCM_MAIL
											, NULL
											, REPLACE([MAIL_SUBJECT],'@DIVISION_NAME',@DIVISION_NAME)											-- 2018-07-24 PIYONG CHANGE
											, REPLACE( REPLACE([MAIL_BODY],'@V_SCP_PLAN_ID',@V_SCP_PLAN_ID) ,'@DIVISION_NAME',@DIVISION_NAME)	-- 2018-07-24 PIYONG CHANGE
											, [MAIL_QUERY]
											, [ATTACH_FILE_NAME]
											, [MAIL_RECEIVER_LIST]+ ISNULL(	-- 2018-07-24 PIYONG CHANGE
																			(
																				SELECT ATTRIBUTE1
																					FROM [DBO].[SCM_SYS_LOOKUP_VALUE] WITH(NOLOCK)
																					WHERE LOOKUP_TYPE_CODE = 'TARGET_INFO_MAIL'
																					AND SEGMENT1 ='SCP_SALES'
																					AND SEGMENT3 = @DIVISION
																					AND ACTIVE_FLAG = 'Y'
																			)
																		, ';')
											, 'FP_MAIL_TEST'
											, 'N'
											, NULL  
											, @v_proc_name
											, getdate()
											, @v_proc_name
											, getdate()
										FROM [SCM_MAILING_LIST_M]
										WHERE MAIL_PKEY = 'SCP_SALES'+@DIVISION
									;

								END					

						END

					FETCH NEXT FROM CUR_DIVISION INTO @DIVISION
													, @V_PLAN_WEEK
													, @SHOP_GROUP -- 2022-03-30 kimcd 공정 군 추가


				END  -- WHILE @@FETCH_STATUS = 0  CUR_DIVISION
				CLOSE CUR_DIVISION;
				DEALLOCATE CUR_DIVISION;   -- 메모리 해제
			END





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



