
CREATE PROCEDURE [dbo].[PR_XIF_RCCP_SALES_EXFACTORY_R_DV]

-- ================================================================================================
-- Program ID          : 
-- Program Name        : PR_XIF_RCCP_SALES_EXFACTORY_R
-- Param               :
-- Batch Period        : 15 MINUTE
-- Description         :
--
-- Source System       : RCCP
-- Destination System  : FP SDB
-- Source Table        : XIF_RCCP_SALES_EXFACTORY_R
-- Destination Table   : FP_WEEKLY_DEMAND_SHIPMENT_H
--
-- Create Date		   : 2016.09.08
-- Update Date		   : 2017.05.16 PIYONG 1.1
--			           : 2017.06.20 piyong 1.2

-- Author              : 김 석
-- Version             : 1.0
--					   : 1.1  메일 송신 로직 추가
--						 1.2  실행 여부를 이번주, 지난주 모두 확인 하도록 변경
-- ================================================================================================

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_RCCP_SALES_EXFACTORY_R'
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
								  FROM [dbo].[SY_XIF_RCCP_SALES_EXFACTORY_R]
								 WHERE ISNULL(PROC_FLAG,'N') = 'N'
							)

		IF @PROC_FLAG_CHK > 0

			BEGIN

				DECLARE @CNT_CHK			NUMERIC(10,0)
				DECLARE @V_PLAN_WEEK		NVARCHAR(50)
				DECLARE @DV					NVARCHAR(50)
				DECLARE @PHONE_NUM			NVARCHAR(50)

				--데이터가 있는지 확인
				DECLARE @DATA_CNT      NUMERIC(10,0)

				SET @DATA_CNT = (
									SELECT COUNT(PLAN_WEEK)
									  FROM [DBO].[SY_XIF_RCCP_SALES_EXFACTORY_R]
									 WHERE ISNULL(PROC_FLAG,'N') = 'N'
								)

				-- ================================================================================================                                                                                                      
				-- @V_SCP_PLAN_ID 구하기                                                                                                                               
				-- ================================================================================================				
				IF @DATA_CNT > 0

					BEGIN
						SET @V_PLAN_WEEK = (
												SELECT MAX( PLAN_WEEK)
												  FROM [dbo].[SY_XIF_RCCP_SALES_EXFACTORY_R]
												 WHERE ISNULL(PROC_FLAG,'N') = 'N'
											)
					END



					DECLARE CUR_DIVISION CURSOR FOR
						SELECT DISTINCT DIVISION
						  FROM [dbo].[SY_XIF_RCCP_SALES_EXFACTORY_R] WITH(NOLOCK)
						 WHERE ISNULL(PROC_FLAG,'N') = 'N'
						   AND PLAN_WEEK = @V_PLAN_WEEK

					OPEN CUR_DIVISION;
					FETCH NEXT FROM CUR_DIVISION INTO @DV  
					WHILE (@@FETCH_STATUS = 0)
						BEGIN

									SET @CNT_CHK = (
										SELECT COUNT(1) -- 값이 0 보다 크면 수행을 하면 안됨.
										  FROM (
												SELECT  (
														--SELECT * FROM [LGCE_INF].[dbo].[XIF_RCCP_SALES_EXFACTORY_R] A WHERE A.PLAN_WEEK LIKE '20161212' + '%'
														--SELECT DISTINCT SITE_ID FROM [LGCE_INF].[dbo].[XIF_RCCP_SALES_EXFACTORY_R] A WHERE A.PLAN_WEEK LIKE '20161212' + '%'
														SELECT COUNT(1)
														  FROM [dbo].[SY_XIF_RCCP_SALES_EXFACTORY_R] A WITH(NOLOCK)
														 WHERE A.PLAN_WEEK LIKE @V_PLAN_WEEK + '%'	-- 2017-06-20 PIYONG  @V_LAST_PLAN_WEEK 조건 추가
														   AND A.OPERATION_GROUP  = W.SEGMENT3
														   AND A.SITE_ID          = W.SEGMENT2
														   AND A.DIVISION         = W.SEGMENT1
														) COUNTS
												  FROM [DBO].[SCM_SYS_LOOKUP_VALUE] W WITH(NOLOCK)
												 WHERE W.LOOKUP_TYPE_CODE = 'RCCP_PLANT'
												   AND ATTRIBUTE3 = 'Y'
												   AND SEGMENT1 = @DV
											   ) X
										WHERE COUNTS = 0
									)
        

									IF @CNT_CHK = 0

										BEGIN
											-- RCCP Target수신 정보를 SDB로 적재
											INSERT INTO [DBO].[FP_WEEKLY_DEMAND_SHIPMENT_H]
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
												,INSERT_ID
												,INSERT_TIME
												,UPDATE_ID
												,UPDATE_TIME
											   )
										--DECLARE @V_SCP_PLAN_ID NVARCHAR(50) = '20161212_001'
										SELECT  A.COMPANY_ID,
												A.DIVISION_ID,
												A.SITE_ID,
												A.PLANT_ID,
												A.SHOP_G4ROUP_ID,
												A.SCP_PLAN_ID,
												A.SCP_TARGET_ID,
												A.FP_TARGET_ID,
												MAX(A.ITEM_ID) AS ITEM_ID,
												MAX(A.TO_SITE_ID) AS TO_SITE_ID,
												MAX(A.TO_PLANT_ID) AS TO_PLANT_ID,
												MAX(A.CUSTOMER_ID) AS CUSTOMER_ID,
												MAX(A.SHIP_DATE) AS SHIP_DATE,
												MAX(A.SHIP_WEEK) AS SHIP_WEEK,
												SUM(A.SHIP_QTY) AS SHIP_QTY,
												MAX(A.PRODUCTION_TYPE) AS PRODUCTION_TYPE,
												MAX(A.TRANSPORT_MODE) AS TRANSPORT_MODE,
												NULL AS BIZ_TYPE,
												NULL AS CONFIRM_TYPE,
												A.MARKET,
												'PR_XIF_RCCP_SALES_EXFACTORY_R' AS INSERT_ID,
												GETDATE() AS INSERT_TIME,
												'PR_XIF_RCCP_SALES_EXFACTORY_R' AS UPDATE_ID,
												GETDATE() AS UPDATE_TIME
										  FROM (
												SELECT --F.DIVISION, F.SITE_ID,F.OPERATION_GROUP,
														B.ATTRIBUTE1 AS COMPANY_ID
													   ,B.SEGMENT4 AS DIVISION_ID
													   ,( SELECT TOP 1 P.SITE_ID                                                                                                                        
															FROM [DBO].[SCM_PLANT_M] P WITH(NOLOCK)                                                                                             
														   WHERE B.SEGMENT5 = P.PLANT_ID															) AS SITE_ID
													   ,B.SEGMENT5 AS PLANT_ID
													   ,( SELECT CASE LEFT(OPERATION_GROUP,1) WHEN 'F' THEN 'A' ELSE  LEFT(OPERATION_GROUP,1) END ) AS SHOP_G4ROUP_ID
													   ,@V_PLAN_WEEK AS SCP_PLAN_ID
													   ,SHIP_ID AS SCP_TARGET_ID
													   ,'-' AS FP_TARGET_ID
													   ,ITEM_ID
													   ,ISNULL((
																SELECT TOP 1 P.SITE_ID                                                                                                                        
																  FROM [DBO].[SCM_PLANT_M] P WITH(NOLOCK)                                                                                            
																 WHERE C.SEGMENT5 = P.PLANT_ID
															   )  , A.DEST_SITE_ID )		AS TO_SITE_ID
													   ,ISNULL( C.SEGMENT5, A.DEST_SITE_ID ) AS TO_PLANT_ID
														,CUSTOMER_CODE AS CUSTOMER_ID
														,EXFACTORY_WEEK AS SHIP_DATE
														,( SELECT TOP 1 [ISO_YYYYWW]
															 FROM [DBO].[TH_UIS_CAL] WITH(NOLOCK)
															WHERE [YYYYMMDD] = A.EXFACTORY_WEEK) AS SHIP_WEEK
														,EXFACTORY_QTY AS SHIP_QTY
														,ORDER_TYPE AS PRODUCTION_TYPE
														,SHIP_METHOD AS TRANSPORT_MODE
														,A.MARKET
												  FROM (

														SELECT A.*
														  FROM [dbo].[SY_XIF_RCCP_SALES_EXFACTORY_R] A WITH(NOLOCK)
															   ,(
																SELECT  W.SEGMENT3   OPERATION_GROUP
																	   ,W.SEGMENT2   SITE_CODE
																	   ,W.SEGMENT1   DIVISION
																  FROM [DBO].[SCM_SYS_LOOKUP_VALUE] W WITH(NOLOCK)
																 WHERE W.LOOKUP_TYPE_CODE = 'RCCP_PLANT'
																   AND ATTRIBUTE3 = 'Y'
															  ) PLAN_SUBJECT
														WHERE A.OPERATION_GROUP  = PLAN_SUBJECT.OPERATION_GROUP 
														  AND A.SITE_ID          = PLAN_SUBJECT.SITE_CODE 
														  AND A.DIVISION         = PLAN_SUBJECT.DIVISION
														  AND A.EXFACTORY_QTY    > 0
  														  AND A.PLAN_WEEK		 = @V_PLAN_WEEK
														  AND A.DIVISION		 = @DV

													   ) A LEFT OUTER JOIN [DBO].[SCM_SYS_LOOKUP_VALUE] B				   
													ON  A.DIVISION  = B.SEGMENT1
													AND A.SITE_ID   = B.SEGMENT2
													AND A.OPERATION_GROUP = B.SEGMENT3
													AND B.LOOKUP_TYPE_CODE = 'RCCP_PLANT'
														   LEFT OUTER JOIN [DBO].[SCM_SYS_LOOKUP_VALUE] C
													ON  A.DIVISION        = C.SEGMENT1
													AND A.DEST_SITE_ID    = C.SEGMENT2
													AND A.OPERATION_GROUP = C.SEGMENT3
													AND C.LOOKUP_TYPE_CODE = 'RCCP_PLANT'
											   ) A
										GROUP BY A.COMPANY_ID,
												 A.DIVISION_ID,
												 A.SITE_ID,
												 A.PLANT_ID,
												 A.SHOP_G4ROUP_ID,
												 A.SCP_PLAN_ID,
												 A.SCP_TARGET_ID,
												 A.FP_TARGET_ID,
												 A.MARKET 

														;


											MERGE INTO [DBO].[SCM_SCP_PLAN_H] A
											USING (

												   SELECT @V_PLAN_WEEK AS SCP_PLAN_ID,
														  'SHIPMENT' AS SCP_PLAN_TYPE,
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
														   ,A.UPDATE_ID           = 'PR_XIF_RCCP_SALES_EXFACTORY_R'
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
														'PR_XIF_RCCP_SALES_EXFACTORY_R',
														GETDATE(),
														'PR_XIF_RCCP_SALES_EXFACTORY_R',
														GETDATE()
													   )

													;

											SET @ROWCOUNT = @@ROWCOUNT

											
										IF @ROWCOUNT > 0
											BEGIN
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
														,[MAIL_SUBJECT]
														,REPLACE(REPLACE([MAIL_BODY],'@V_SCP_PLAN_ID',@V_PLAN_WEEK),'@DV',@DV)
														,[MAIL_QUERY]
														,[ATTACH_FILE_NAME]
														,[MAIL_RECEIVER_LIST]
														,'FP_MAIL_TEST'
														,'N'
														,NULL  
														,@v_proc_name
														,getdate()
														,@v_proc_name
														,getdate()
												   FROM [SCM_MAILING_LIST_M]
												  WHERE MAIL_PKEY = 'FP_MAILING_IF11'

												DECLARE CUR_SMS CURSOR FOR
													SELECT ATTRIBUTE1 AS PN
													  FROM [DBO].[SCM_SYS_LOOKUP_VALUE] WITH(NOLOCK)
													 WHERE LOOKUP_TYPE_CODE = 'SMS_ADDRESSEE'
													   AND SEGMENT1 =  'SHIPPING_TARGET'


												OPEN CUR_SMS;
												FETCH NEXT FROM CUR_SMS INTO @PHONE_NUM;
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
															,N'[FP-LIVE] Shipping TARGET('+@V_PLAN_WEEK+' DIVISION '+@DV+N' )이 새로 생성 되었습니다.'
														)
									
														FETCH NEXT FROM CUR_SMS INTO @PHONE_NUM;
													END;

												CLOSE CUR_SMS;
												DEALLOCATE CUR_SMS;


											END
										;

									END;


								UPDATE [dbo].[SY_XIF_RCCP_SALES_EXFACTORY_R]
								   SET PROC_FLAG = 'Y'
									   ,PROC_DATE = GETDATE()
								 WHERE PROC_FLAG = 'N'
								   AND PLAN_WEEK  = @V_PLAN_WEEK
								   AND DIVISION   = @DV
								;

								FETCH NEXT FROM CUR_DIVISION INTO @DV

							END

						CLOSE CUR_DIVISION;
						DEALLOCATE CUR_DIVISION; 


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



