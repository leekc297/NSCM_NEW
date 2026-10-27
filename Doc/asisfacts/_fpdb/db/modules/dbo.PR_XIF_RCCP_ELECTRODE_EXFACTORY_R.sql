
CREATE PROCEDURE [dbo].[PR_XIF_RCCP_ELECTRODE_EXFACTORY_R]

-- ================================================================================================
-- Program ID          : 
-- Program Name        : PR_XIF_RCCP_ELECTRODE_EXFACTORY_R
-- Param               :
-- Batch Period        : 1Hour
-- Description         :
--
-- Source System       : RCCP
-- Destination System  : FP SDB
-- Source Table        : XIF_RCCP_ELECTRODE_EXFACTORY_R
-- Destination Table   : FP_WEEKLY_DEMAND_SHIPMENT_ELEC_H
--
-- Create Date		   : 2017.01.02
-- Update Date         : 2017.05.11 piyong 1.1
--			             2017.05.16 piyong 1.2
--			             2017.05.17 piyong 1.3
--						 2018.03.23 PIYONG 1.4

-- Author              : 
-- Version             : 1.0
--					     1.1 운영 과 동기화
--					     1.2 FP_WEEKLY_DEMAND_SHIPMENT_ELEC_H 테이블 PRODUCTION_TYPE 값 변경 로직 추가
--					     1.3 FP_WEEKLY_DEMAND_SHIPMENT_ELEC_H 테이블 MODEL에 속한 CHIL_ITEM_ID의 PRODUCTION_TYPE 값 변경 로직 추가
--						 1.4 중국법인이면  MARKET 값을  SCP TARGET   중국법인이 아니면  D
-- ================================================================================================

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_RCCP_ELECTRODE_EXFACTORY_R'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	   = 0
	DECLARE @sysdate     DATETIME      = GETDATE()

	DECLARE @ROWCOUNT		INTEGER
	DECLARE @DIVISION_NAME	NVARCHAR(150)
	DECLARE @DIVISION_ID	NVARCHAR(30)
	DECLARE @SITE_ID		NVARCHAR(30)

	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)

	-- ================================================
    -- Declare start
	-- ================================================


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
								  FROM [SY_XIF_RCCP_ELECTRODE_EXFACTORY_R] WITH(NOLOCK)
								 WHERE ISNULL(PROC_FLAG,'N') = 'N'
							 )

		IF @PROC_FLAG_CHK > 0

			BEGIN

				DECLARE @CNT_CHK			NUMERIC(10,0)
				DECLARE @V_PLAN_WEEK		NVARCHAR(50)
				DECLARE @V_SCP_PLAN_ID		NVARCHAR(50)
				DECLARE @V_LAST_PLAN_WEEK   NVARCHAR(50)

				--데이터가 있는지 확인
				DECLARE @DATA_CNT      NUMERIC(10,0)

				-- ================================================================================================                                                                                                      
				-- 월요일에서 수요일 사이는 전주 월요일 목요일부터 일요일까지는 당주 월요일 일자                                                                                                                                  
				-- ================================================================================================  
				DECLARE @V_DAY        INTEGER = 0
				DECLARE @V_WEEK       NVARCHAR(8)

				SET @V_DAY = DATEPART(WEEKDAY, GETDATE())

				/*
				IF(@V_DAY = 2 OR @V_DAY = 3 OR @V_DAY = 4)
					BEGIN
						SET @V_PLAN_WEEK = CONVERT(CHAR(8), DATEADD(d, DATEPART(dw, GETDATE()) * -1 - 5, GETDATE()), 112)
					END
				ELSE
					BEGIN
						SET @V_PLAN_WEEK = CONVERT(CHAR(8), DATEADD(d, DATEPART(dw, GETDATE()) * -1 + 2, GETDATE()), 112)
					END
                */
                
				SET @V_PLAN_WEEK = CONVERT(CHAR(8), DATEADD(d, DATEPART(dw, GETDATE()) * -1 + 2, GETDATE()), 112)
				SET @V_LAST_PLAN_WEEK = CONVERT(CHAR(8), DATEADD(d, DATEPART(dw, GETDATE()) * -1 + 2 -7, GETDATE()), 112)

				SET @DATA_CNT = (
									SELECT COUNT(SCP_PLAN_ID)
									  FROM [DBO].[FP_WEEKLY_DEMAND_SHIPMENT_ELEC_H] WITH(NOLOCK)
									 --WHERE PLAN_WEEK LIKE '20161212' + '%'
									 WHERE SCP_PLAN_ID LIKE @V_PLAN_WEEK + '%'
								)

				-- ================================================================================================                                                                                                      
				-- @V_SCP_PLAN_ID 구하기                                                                                                                               
				-- ================================================================================================				
				IF @DATA_CNT = 0
					BEGIN
						SET @V_SCP_PLAN_ID = @V_PLAN_WEEK + '_001'
					END
				ELSE
					BEGIN 
						SET @V_SCP_PLAN_ID = (
												SELECT SUBSTRING(MAX(SCP_PLAN_ID), 1, 8) + '_' +
													   REPLICATE('0',3 - LEN( CAST(SUBSTRING(MAX(SCP_PLAN_ID), 10, 3) AS NUMERIC)+1 ) ) + CAST(CAST(SUBSTRING(MAX(SCP_PLAN_ID), 10, 3) AS NUMERIC)+1 AS NVARCHAR) -- 2017-07-14  0자리수 구하는 로직 수정
													  --,MAX(PLAN_WEEK)
												  FROM [DBO].[FP_WEEKLY_DEMAND_SHIPMENT_ELEC_H] WITH(NOLOCK)
												 WHERE SCP_PLAN_ID LIKE @V_PLAN_WEEK + '%'
											)
					END

				SET @CNT_CHK = (
								SELECT COUNT(1) -- 값이 0 보다 크면 수행을 하면 안됨.
								  FROM (
										SELECT (
												SELECT COUNT(1)
												  FROM [SY_XIF_RCCP_ELECTRODE_EXFACTORY_R] A WITH(NOLOCK)
												 WHERE (A.PLAN_WEEK LIKE @V_PLAN_WEEK + '%' OR  A.PLAN_WEEK LIKE @V_LAST_PLAN_WEEK + '%' )
												   AND A.OPERATION_GROUP  = W.SEGMENT3
												   AND A.SITE_ID          = W.SEGMENT2
												   AND A.DIVISION         = W.SEGMENT1
											   ) COUNTS
										  FROM [DBO].[SCM_SYS_LOOKUP_VALUE] W WITH(NOLOCK)
										 WHERE W.LOOKUP_TYPE_CODE = 'RCCP_PLANT'
										   AND ATTRIBUTE4 = 'Y'
										   AND ACTIVE_FLAG = 'Y'
									   ) X
								 WHERE COUNTS = 0
							)
                
				SET @CNT_CHK = 0

				IF @CNT_CHK = 0

					BEGIN

						/*
						UPDATE LGCE_INFDEV.[dbo].[XIF_RCCP_SALES_EXFACTORY_R]
						   SET PROC_FLAG = 'P'
							   ,PROC_DATE = GETDATE()
						 WHERE ISNULL(PROC_FLAG,'N') = 'N'
						;
						*/
		  
  
						-- RCCP Target수신 정보를 SDB로 적재
						INSERT INTO [DBO].[FP_WEEKLY_DEMAND_SHIPMENT_ELEC_H]
									(
									 [COMPANY_ID]
                                    ,[DIVISION_ID]
                                    ,[SITE_ID]
                                    ,[PLANT_ID]
									,[TO_PLANT_ID]
                                    ,[SHOP_GROUP_ID]
                                    ,[SCP_PLAN_ID]
                                    ,[SCP_TARGET_ID]
                                    ,[FP_TARGET_ID]
									,[MARKET]
                                    ,[ITEM_ID]
                                    ,[SHIP_DATE]
                                    ,[SHIP_WEEK]
                                    ,[SHIP_QTY]
                                    ,[PRODUCTION_TYPE]
									,[CELL_MODEL]
                                    ,[INSERT_ID]
                                    ,[INSERT_TIME]
                                    ,[UPDATE_ID]
                                    ,[UPDATE_TIME]
								   )
							--DECLARE @V_SCP_PLAN_ID NVARCHAR(50) = '20161212_001'
							SELECT  A.COMPANY_ID,
									A.DIVISION_ID,
									A.SITE_ID,
									A.PLANT_ID,
									A.TO_PLANT_ID,
									A.SHOP_GROUP_ID,
									A.SCP_PLAN_ID,
									A.SCP_TARGET_ID,
									A.FP_TARGET_ID,
									A.MARKET,
									MAX(A.ITEM_ID) AS ITEM_ID,
									MAX(A.SHIP_DATE) AS SHIP_DATE,
									MAX(A.SHIP_WEEK) AS SHIP_WEEK,
									SUM(A.SHIP_QTY) AS SHIP_QTY,
									MAX(A.PRODUCTION_TYPE) AS PRODUCTION_TYPE,
									A.CELL_MODEL,
									'PR_XIF_RCCP_ELECTRODE_EXFACTORY_R' AS INSERT_ID,
									GETDATE() AS INSERT_TIME,
									'PR_XIF_RCCP_ELECTRODE_EXFACTORY_R' AS UPDATE_ID,
									GETDATE() AS UPDATE_TIME
							  FROM (
									-- 2018-03-23 PIYONG   MARKET 변경을 위해 SELECT 한번 더 실행
									SELECT COMPANY_ID
										   ,DIVISION_ID
										   ,SITE_ID
										   ,PLANT_ID
										   ,TO_PLANT_ID
										   ,SHOP_GROUP_ID
										   ,SCP_PLAN_ID
										   ,SCP_TARGET_ID
										   ,FP_TARGET_ID
										   ,CASE WHEN SITE_ID = 'A002' THEN MARKET ELSE 'D' END MARKET
										   ,ITEM_ID
										   ,SHIP_DATE
										   ,SHIP_WEEK
										   ,SHIP_QTY
										   ,PRODUCTION_TYPE
										   ,CELL_MODEL
									  FROM (
											SELECT --F.DIVISION, F.SITE_ID,F.OPERATION_GROUP,
													B.ATTRIBUTE1 AS COMPANY_ID
												   ,B.SEGMENT4 AS DIVISION_ID
												   ,( SELECT TOP 1 P.SITE_ID                                                                                                                        
													   FROM [DBO].[SCM_PLANT_M] P WITH(NOLOCK)                                                                                            
													  WHERE B.SEGMENT5 = P.PLANT_ID                                                                                                         
													 ) AS SITE_ID
												   ,B.SEGMENT5 AS PLANT_ID
												   ,( SELECT CASE LEFT(OPERATION_GROUP,1) WHEN 'F' THEN 'A' ELSE  LEFT(OPERATION_GROUP,1) END ) AS SHOP_GROUP_ID
												   ,@V_SCP_PLAN_ID AS SCP_PLAN_ID
												   -- 공용 P/C 정보가 들어와서 SHIP_ID 구분이 안됨. CELL 모델까지 추가해서 처리하도록 변경 2017-04-24
												   -- RCCP에서 SHIP ID 생성 로직 변경 적용으로 원복시킴 2017-04-25
												   ,SHIP_ID AS SCP_TARGET_ID
													-- ,SHIP_ID+'_'+A.ATTR_01  AS SCP_TARGET_ID
												   ,'-' AS FP_TARGET_ID
												   ,ITEM_ID
													,EXFACTORY_DATE AS SHIP_DATE
													,( SELECT TOP 1 [ISO_YYYYWW]
														 FROM [DBO].[TH_UIS_CAL] WITH(NOLOCK)
														WHERE [YYYYMMDD] = A.EXFACTORY_DATE) AS SHIP_WEEK
													,EXFACTORY_QTY AS SHIP_QTY
													,ORDER_TYPE AS PRODUCTION_TYPE
													,TO_PLANT_ID
													,A.MARKET
													,A.ATTR_01 AS CELL_MODEL
											  FROM (
													SELECT A.*
													  FROM [SY_XIF_RCCP_ELECTRODE_EXFACTORY_R] A WITH(NOLOCK)
														  ,(
															 SELECT A.OPERATION_GROUP, A.SITE_ID, A.DIVISION, MAX(A.PLAN_WEEK) PLAN_WEEK
															   FROM [SY_XIF_RCCP_ELECTRODE_EXFACTORY_R] A WITH(NOLOCK)
															  WHERE ( A.PLAN_WEEK LIKE @V_PLAN_WEEK + '%' OR A.PLAN_WEEK LIKE @V_LAST_PLAN_WEEK + '%'  ) -- 월요일에서 수요일 사이는 전주 월요일 목요일부터 일요일까지는 당주 월요일 일자
															  GROUP BY A.OPERATION_GROUP, A.SITE_ID, A.DIVISION
														   ) TARGET_PLANWEEK
														  ,(
															SELECT  W.SEGMENT3   OPERATION_GROUP
																   ,W.SEGMENT2   SITE_CODE
																   ,W.SEGMENT1   DIVISION
															  FROM [DBO].[SCM_SYS_LOOKUP_VALUE] W WITH(NOLOCK)
															 WHERE W.LOOKUP_TYPE_CODE = 'RCCP_PLANT'
															   AND ATTRIBUTE4 = 'Y'
														   ) PLAN_SUBJECT
													WHERE A.PLAN_WEEK        = TARGET_PLANWEEK.PLAN_WEEK
													  AND A.OPERATION_GROUP  = TARGET_PLANWEEK.OPERATION_GROUP 
													  AND A.SITE_ID          = TARGET_PLANWEEK.SITE_ID 
													  AND A.DIVISION         = TARGET_PLANWEEK.DIVISION
													  AND A.OPERATION_GROUP  = PLAN_SUBJECT.OPERATION_GROUP 
													  AND A.SITE_ID          = PLAN_SUBJECT.SITE_CODE 
													  AND A.DIVISION         = PLAN_SUBJECT.DIVISION

												   ) A
											  LEFT OUTER JOIN [DBO].[SCM_SYS_LOOKUP_VALUE] B				   
														   ON A.DIVISION  = B.SEGMENT1
														  AND A.SITE_ID   = B.SEGMENT2
														  AND A.OPERATION_GROUP = B.SEGMENT3
														  AND B.LOOKUP_TYPE_CODE = 'RCCP_PLANT'
										)AA
								   ) A
							 GROUP BY A.COMPANY_ID,
								   A.DIVISION_ID,
								   A.SITE_ID,
								   A.PLANT_ID,
								   A.TO_PLANT_ID,
								   A.SHOP_GROUP_ID,
								   A.SCP_PLAN_ID,
								   A.SCP_TARGET_ID,
								   A.FP_TARGET_ID ,
								   A.MARKET,
								   A.CELL_MODEL
						;			 


						MERGE INTO [DBO].[SCM_SCP_PLAN_H] A
						USING (
							   SELECT @V_SCP_PLAN_ID AS SCP_PLAN_ID,
									  'ELEC_SHIPMENT' AS SCP_PLAN_TYPE,
									  CONVERT(DATETIME, SUBSTRING(@V_PLAN_WEEK, 1, 8)) AS PLAN_START_TIME,
									  200 AS PLAN_HORIZON,
									  200 AS DEMAND_HORIZON,
									  SUBSTRING(@V_PLAN_WEEK, 1, 4) + CAST(DATEPART(WW, SUBSTRING(@V_PLAN_WEEK, 1, 8)) AS NVARCHAR) AS PLAN_WEEK

							  ) B
						ON (
							A.SCP_PLAN_ID = B.SCP_PLAN_ID
						   )
						WHEN MATCHED THEN

							UPDATE SET  A.[SCP_PLAN_TYPE]     = B.[SCP_PLAN_TYPE]
									   ,A.[PLAN_START_TIME]   = B.[PLAN_START_TIME]
									   ,A.[PLAN_HORIZON]      = B.[PLAN_HORIZON]
									   ,A.[DEMAND_HORIZON]    = B.[DEMAND_HORIZON]
									   ,A.UPDATE_ID           = 'PR_XIF_RCCP_ELECTRODE_EXFACTORY_R'
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
								   ,[UPDATE_TIME])
							VALUES (
									B.SCP_PLAN_ID,
									B.SCP_PLAN_TYPE,
									B.PLAN_START_TIME,
									B.PLAN_HORIZON,
									B.DEMAND_HORIZON,
									B.PLAN_WEEK,
									'PR_XIF_RCCP_ELECTRODE_EXFACTORY_R',
									GETDATE(),
									'PR_XIF_RCCP_ELECTRODE_EXFACTORY_R',
									GETDATE()
								   )

						;

						SET @ROWCOUNT = @@ROWCOUNT

						-- ADD piyong 2017-05-16
						UPDATE [DBO].[FP_WEEKLY_DEMAND_SHIPMENT_ELEC_H] 
						   SET PRODUCTION_TYPE = 'SPECIAL'
						       , UPDATE_ID = UPDATE_ID+'_'+PRODUCTION_TYPE
							   , UPDATE_TIME = GETDATE()
						  FROM [DBO].[FP_WEEKLY_DEMAND_SHIPMENT_ELEC_H] SE
						  JOIN (SELECT PV_APP_PLAN_END_DATE
									   ,MODEL_NAME
								  FROM (SELECT CONVERT(DATE,PV_APP_PLAN_END_DATE, 120)  AS PV_APP_PLAN_END_DATE
											   ,MODEL_NAME
											   ,ROW_NUMBER() OVER ( PARTITION BY MODEL_NAME ORDER BY UPDATE_TIME DESC) AS ROWUMBER
										  FROM LGCE_FPDEV_TR.[DBO].[FP_PLM_PJT_SCHEDULE_R]
									    ) A
								  WHERE ROWUMBER = 1
								) PMM
						     ON (SE.ITEM_ID = PMM.MODEL_NAME
 								 AND SE.SHIP_DATE < PMM.PV_APP_PLAN_END_DATE
								 AND SE.SCP_PLAN_ID =  @V_SCP_PLAN_ID
								 AND SE.PRODUCTION_TYPE = 'MASS'
							    )
						;

						-- ADD piyong 2017-05-17
						-- MODEL에 속한 CHILD_ID도 업데이트
						UPDATE [DBO].[FP_WEEKLY_DEMAND_SHIPMENT_ELEC_H] 
						   SET PRODUCTION_TYPE = 'SPECIAL'
						       , UPDATE_ID = UPDATE_ID+'_'+PRODUCTION_TYPE
							   , UPDATE_TIME = GETDATE()
						  FROM [DBO].[FP_WEEKLY_DEMAND_SHIPMENT_ELEC_H] SE
						  JOIN (SELECT DISTINCT MODEL_ID, CHILD_ITEM_ID, C.PV_APP_PLAN_END_DATE
								  FROM [LGCE_FPDEV_TR].[DBO].[SCM_MODEL_COMP_TEMP]
									  ,[LGCE_FPDEV_TR].[DBO].SCM_ITEM_M B
									  ,(SELECT PV_APP_PLAN_END_DATE
												,MODEL_NAME
											FROM (SELECT CONVERT(DATE,PV_APP_PLAN_END_DATE, 120)  AS PV_APP_PLAN_END_DATE
														,MODEL_NAME
														,ROW_NUMBER() OVER ( PARTITION BY MODEL_NAME ORDER BY UPDATE_TIME DESC) AS ROWUMBER
													FROM LGCE_FPDEV_TR.[DBO].[FP_PLM_PJT_SCHEDULE_R]
												) A
											WHERE ROWUMBER = 1
										) C
								 WHERE MODEL_ID = ITEM_ID
								   AND B.ITEM_TYPE IN ( 'P','H')
								   AND MODEL_ID = C.MODEL_NAME
								) PMM
						     ON (SE.ITEM_ID = PMM.CHILD_ITEM_ID
 								 AND SE.SHIP_DATE < PMM.PV_APP_PLAN_END_DATE
								 AND SE.SCP_PLAN_ID =  @V_SCP_PLAN_ID
								 AND SE.PRODUCTION_TYPE = 'MASS'
							    )
						;


						UPDATE [SY_XIF_RCCP_ELECTRODE_EXFACTORY_R]
						   SET PROC_FLAG = 'Y'
							  ,PROC_DATE = GETDATE()
						 WHERE PROC_FLAG = 'N'
						;


						IF @ROWCOUNT > 0
							BEGIN
								--2018-07-23 PIYONG ADD
								DECLARE CUR_MAIL CURSOR FOR
									SELECT DISTINCT SEGMENT1 AS  DIVISION_ID
									  FROM [DBO].[SCM_SYS_LOOKUP_VALUE] WITH(NOLOCK)
									 WHERE LOOKUP_TYPE_CODE = 'RCCP_PLANT'
									   AND ATTRIBUTE4 = 'Y'
									   AND ACTIVE_FLAG = 'Y'

								OPEN CUR_MAIL;
			
								FETCH NEXT FROM CUR_MAIL INTO @DIVISION_ID


								WHILE (@@FETCH_STATUS = 0)
									BEGIN
									--2018-07-23 PIYONG ADD
									SET @DIVISION_NAME = (
															SELECT TOP 1 DIVISION_NAME
															  FROM SCM_DIVISION_M
															 WHERE DIVISION_ID = @DIVISION_ID
															 ORDER BY DIVISION_NAME
														 )

										INSERT INTO dbo.SCM_MAILING_H
										  (  [MAIL_PKEY]
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
												,REPLACE([MAIL_SUBJECT],'@DIVISION_NAME',@DIVISION_NAME)		--2018-07-23 PIYONG CHANGE
												,REPLACE( REPLACE([MAIL_BODY],'@V_SCP_PLAN_ID',@V_SCP_PLAN_ID) ,'@DIVISION_NAME',@DIVISION_NAME)		--2018-07-23 PIYONG CHANGE
												,[MAIL_QUERY]
												,[ATTACH_FILE_NAME]
												,[MAIL_RECEIVER_LIST]+ ISNULL(									--2018-07-23 PIYONG ADD
																			  (SELECT ATTRIBUTE1
																				 FROM [DBO].[SCM_SYS_LOOKUP_VALUE] WITH(NOLOCK)
																				WHERE LOOKUP_TYPE_CODE = 'TARGET_INFO_MAIL'
																				  AND SEGMENT1 ='ELECTRODE_EXFACTORY'
																				  AND SEGMENT3 = @DIVISION_ID
																				  AND ACTIVE_FLAG = 'Y')
																			   , ';')
												,'FP_MAIL_TEST'
												,'N'
												,NULL  
												,@v_proc_name
												,getdate()
												,@v_proc_name
												,getdate()
										   FROM [SCM_MAILING_LIST_M]
										  WHERE MAIL_PKEY = 'ELECTRODE_EXFACTORY'+@DIVISION_ID

										FETCH NEXT FROM CUR_MAIL INTO @DIVISION_ID
										;

									END

								CLOSE CUR_MAIL;
								DEALLOCATE CUR_MAIL;

							END

					END

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
