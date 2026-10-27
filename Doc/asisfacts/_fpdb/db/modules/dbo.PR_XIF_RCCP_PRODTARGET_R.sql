                                                                                                                                                                 
CREATE PROCEDURE [dbo].[PR_XIF_RCCP_PRODTARGET_R]
                                                                                                                                                                 
-- ================================================================================================                                                              
-- Program ID          :                                                                                                                                         
-- Program Name        : PR_XIF_RCCP_PRODTARGET_R                                                                                                                
-- Param               :                                                                                                                                         
-- Batch Period        : 15 MINUTE                                                                                                                                   
-- Description         :                                                                                                                                         
--                                                                                                                                                               
-- Source System       : RCCP                                                                                                                                    
-- Destination System  : FP SDB                                                                                                                                  
-- Source Table        : XIF_RCCP_PROD_TARGET_R                                                                                                                  
-- Destination Table   : FP_WEEKLY_DEMAND_PRODUCT_H                                                                                                              
--                                                                                                                                                               
-- Create Date         : 2016.09.08
-- Update Date         : 2017.04.06
--					     2017.05.16 PIYONG 1.2
--			             2017.06.20 piyong 1.3
--						 2017.11.10 PIYONG 1.4
--						 2017.11.24 PIYONG 1.5
--						 2017.12.22 PIYONG 1.6
--                       2018-01-04 kimcd  1.7
--						 2018-04-26 PIYONG 1.8
--						 2018-07-23	PIYONG 1.9
--						 2018-09-17 PIYONG 1.10
--
-- Author              : 김 석                                                                                                                                     
-- Version             : 1.0
--					   : 1.1  201-04-06 MARKET PK로 변경
--									    FP_WEEKLY_DEMAND_PRODUCT_H  입력 할때 ISNULL(MARKERT, 'D') 변경

--					   : 1.2 FP_WEEKLY_DEMAND_PRODUCT_H 테이블 PRODUCTION_TYPE 값 변경 로직 추가
--					   : 1.3 실행 여부를 이번주, 지난주 모두 확인 하도록 변경
--						 1.4 실행 여부를 월,화 는 전주 월, 목요일 ~일요일은 금주 월요일로 변경
--							 MARKET이 NULL 일때 값 설정 변경
--						 1.5 기 생성된 SCP_PLAN_ID에서 변경이 일어난 데이터 중 PRODUCTION_TYPE, MARKET 값을 신규로 생성된 SCP_PLAN_ID에 적용
--							 ([COMPANY_ID], [DIVISION_ID], [SITE_ID], [PLANT_ID], [SHOP_GROUP_ID], [SCP_TARGET_ID] 값이 동일한 데이터만 적용)
--						 1.6 매주 첫번째 물동을 수신할 때는  SCM_MODEL_MARKET_M 기준으로 내수로 변경하고.
--							 그 이후에 다시 받는 경우만 기존 물동의 MARKET을 복사
--                       1.7 active flag 조건 누락되어 추가함
--						 1.8 지난주 체크 로직 삭제
--						 1.9 DIVISION 별 메일 발송 로직 추가
--						 1.10 CNA PRODUCTION_TYPE 조회 조건 추가
-- ================================================================================================                                                              
                                                                                                                                                                 
AS                                                                                                                                                               
                                                                                                                                                                 
BEGIN                                                                                                                                                            
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED                                                                                                               
    SET NOCOUNT ON                                                                                                                                               
	SET XACT_ABORT ON                                                                                                                                            
                                                                                                                                                                 
	-- LOG 용 변수 설정                                                                                                                                               
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_RCCP_PRODTARGET_R'                                                                                               
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
	DECLARE @DIVISION_NAME	NVARCHAR(150)	-- 2018-07-03 PIYONG ADD
	DECLARE @DIVISION_ID	NVARCHAR(30)	-- 2018-07-03 PIYONG ADD                                                                                                                                              
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
								  FROM [dbo].[SY_XIF_RCCP_PROD_TARGET_R] WITH(NOLOCK)
								 WHERE ISNULL(PROC_FLAG,'N') = 'N'
							)

		IF @PROC_FLAG_CHK > 0

			BEGIN

				DECLARE @CNT_CHK			NUMERIC(10,0)
				DECLARE @V_PLAN_WEEK		NVARCHAR(50)
--				DECLARE @V_LAST_PLAN_WEEK   NVARCHAR(50)	-- ADD PIYONG 2017-06-20 DEL PIYONG 2018-04-26
				DECLARE @V_SCP_PLAN_ID		NVARCHAR(50)
				DECLARE @C_PLAN_WEEK		NVARCHAR(50)	-- ADD PIYONG 2017-12-22 CUSOR PLAN_WEEK
				DECLARE @C_DIVISION			NVARCHAR(50)	-- ADD PIYONG 2017-12-22 CUSOR DIVISION

				--데이터가 있는지 확인
				DECLARE @DATA_CNT			NUMERIC(10,0)

				-- ================================================================================================                                                                                                      
				-- 월요일, 화요일 전주 월요일, 수요일부터 일요일까지는 당주 월요일 일자                                                                                                                                  
				-- ================================================================================================ 
				DECLARE @V_DAY				INTEGER = 0
--				DECLARE @V_WEEK				NVARCHAR(8)

				--------------------------------------------------------------------------------------------------------
				-- PIYONG 2017-11-13  소스 시작

				SET @V_DAY = DATEPART(WEEKDAY, GETDATE())

				IF(@V_DAY = 2 OR @V_DAY = 3)
					BEGIN
						SET @V_PLAN_WEEK =  CONVERT(CHAR(8), DATEADD(d, DATEPART(dw, GETDATE()) * -1 - 5, GETDATE()), 112)
					END
				ELSE
					BEGIN
						SET @V_PLAN_WEEK = CONVERT(CHAR(8), DATEADD(d, DATEPART(dw, GETDATE()) * -1 + 2, GETDATE()), 112)
					END

				-- PIYONG 2017-11-13  소스 끝
				-----------------------------------------------------------------------------------------------------------
				-- ADD PIYONG 2017-06-20   DEL PIYONG 2018-04-26
--				SET @V_LAST_PLAN_WEEK = CONVERT(CHAR(8), DATEADD(d, DATEPART(dw, GETDATE()) * -1 + 2 -7, GETDATE()), 112)


				SET @DATA_CNT = (
								SELECT COUNT(SCP_PLAN_ID)
								  FROM [DBO].[FP_WEEKLY_DEMAND_PRODUCT_H] WITH(NOLOCK)
								 --WHERE PLAN_WEEK LIKE '20161212' + '%'
								 WHERE SCP_PLAN_ID LIKE @V_PLAN_WEEK + '%'
								)

				--------------------------------------------------------------------------------------------
				--신규 SCP_PLAN_ID 생성 전 DIVISION별 SCP_PLAN_ID MAX값 구하기 시작				--2017-11-24 ADD
				
				SELECT DISTINCT MAX(SCP_PLAN_ID) AS SCP_PLAN_ID, DIVISION_ID
				  INTO #BEFORE_SCP_PLAN_ID
				  FROM [DBO].[FP_WEEKLY_DEMAND_PRODUCT_H] WITH(NOLOCK)
				 GROUP BY DIVISION_ID

			    --신규 SCP_PLAN_ID 생성 전 DIVISION별 SCP_PLAN_ID MAX값 구하기 끝				--2017-11-24 ADD
 				--------------------------------------------------------------------------------------------

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
													   REPLICATE('0',3 - LEN( CAST(SUBSTRING(MAX(SCP_PLAN_ID), 10, 3) AS NUMERIC)+1 ) ) 
													   + CAST(CAST(SUBSTRING(MAX(SCP_PLAN_ID), 10, 3) AS NUMERIC)+1 AS NVARCHAR) -- 2017-07-14  0자리수 구하는 로직 수정
													  --,MAX(PLAN_WEEK)
												  FROM [DBO].[FP_WEEKLY_DEMAND_PRODUCT_H] WITH(NOLOCK)
												 WHERE SCP_PLAN_ID LIKE @V_PLAN_WEEK + '%'
											)
					END



				SET @CNT_CHK = (
								SELECT COUNT(1) -- 값이 0 보다 크면 수행을 하면 안됨.
								  FROM (
										SELECT (
												SELECT COUNT(1)
												  FROM [dbo].[SY_XIF_RCCP_PROD_TARGET_R] A WITH(NOLOCK)
												 WHERE --(A.PLAN_WEEK LIKE @V_PLAN_WEEK + '%' OR  A.PLAN_WEEK LIKE @V_LAST_PLAN_WEEK + '%' )	-- 2017-06-20 PIYONG  @V_LAST_PLAN_WEEK 조건 추가 
													   A.PLAN_WEEK LIKE @V_PLAN_WEEK + '%'														-- 2018-04-26 PIYONG	  @V_LAST_PLAN_WEEK 조건 삭제
												   AND ISNULL(A.PROC_FLAG,'N') = 'N'
												   AND A.OPERATION_GROUP  = W.SEGMENT3
												   AND A.SITE_CODE        = W.SEGMENT2
												   AND A.DIVISION         = W.SEGMENT1
												) COUNTS
												,W.SEGMENT1
										   FROM [DBO].[SCM_SYS_LOOKUP_VALUE] W WITH(NOLOCK)
										  WHERE W.LOOKUP_TYPE_CODE = 'RCCP_PLANT'
											AND ATTRIBUTE2 = 'Y'
											AND ACTIVE_FLAG = 'Y'
									   ) X
								 WHERE COUNTS = 0
								   -- 2018-04-26 PIYONG ADD 다른 사이트에 수신 안된 데이터 존재 여부
								   AND SEGMENT1 IN (
													SELECT DISTINCT DIVISION
													  FROM [dbo].[SY_XIF_RCCP_PROD_TARGET_R] A WITH(NOLOCK)
													 WHERE A.PLAN_WEEK LIKE @V_PLAN_WEEK + '%'
													   AND ISNULL(PROC_FLAG,'N') = 'N'
												   )
								)

				IF @CNT_CHK = 0

					BEGIN

						/*
						UPDATE [LGCE_INF].[dbo].[XIF_RCCP_PROD_TARGET_R]                                                                                                       
						   SET PROC_FLAG = 'P'                                                                                                                                  
							  ,PROC_DATE = GETDATE()                                                                                                                            
						 WHERE ISNULL(PROC_FLAG,'N') = 'N'                                                                                                                      
						;
						*/                                                                                                                                                     
		             
						-- RCCP Target 정보를 수신하여 SDB에 적재                                                                                                                                 
						INSERT INTO [DBO].[FP_WEEKLY_DEMAND_PRODUCT_H]
									(                                                                                                                                                       
									  COMPANY_ID                                                                                                                                             
									 ,DIVISION_ID                                                                                                                                             
									 ,SITE_ID                                                                                                                                                 
									 ,PLANT_ID                                                                                                                                                
									 ,SHOP_GROUP_ID                                                                                                                                           
									 ,SCP_PLAN_ID                                                                                                                                             
									 ,SCP_TARGET_ID                                                                                                                                           
									 ,ITEM_ID                                                                                                                                                 
									 ,MFG_WEEK                                                                                                                                                
									 ,MFG_QTY                                                                                                                                                 
									 ,CHG_QTY                                                                                                                                                 
									 ,PRODUCTION_TYPE                                                                                                                                         
									 ,SAMPLE_FROM_DATE                                                                                                                                        
									 ,SAMPLE_TO_DATE                                                                                                                                          
									 ,LINE_ID                                                                                                                                                 
									 ,PRIORITY                                                                                                                                                
									 ,PERIOD_TYPE                                                                                                                                             
									 ,CONFIRM_TYPE                                                                                                                                            
									 ,DEMAND_TYPE
									 ,MARKET                                                                                                                                             
									 ,INSERT_ID                                                                                                                                               
									 ,INSERT_TIME                                                                                                                                             
									 ,UPDATE_ID                                                                                                                                               
									 ,UPDATE_TIME                                                                                                                                             
								   )		                                                                                                                                                 
						SELECT   A.ATTRIBUTE1 AS COMPANY_ID                                                                                                                       
								,A.SEGMENT4 AS DIVISION                                                                                                                              
								,( SELECT TOP 1 P.SITE_ID                                                                                                                        
									 FROM [DBO].[SCM_PLANT_M] P WITH(NOLOCK)                                                                                            
									WHERE A.SEGMENT5 = P.PLANT_ID															) AS SITE_ID                                                                                                                               
								,A.SEGMENT5 AS PLANT_ID                                                                                                                    
								,( SELECT  CASE LEFT(OPERATION_GROUP,1) WHEN 'F' THEN 'A' ELSE  LEFT(OPERATION_GROUP,1) END ) AS SHOP_GROUP_ID                           
								,@V_SCP_PLAN_ID AS SCP_PLAN_ID                                                                                                         
								,TARGET_ID AS SCP_TARGET_ID                                                                                                       
								,ITEM_ID
								,(SELECT TOP 1 [ISO_YYYYWW]
									FROM [DBO].[TH_UIS_CAL] WITH(NOLOCK)
									WHERE [YYYYMMDD] = A.PROD_WEEK															) AS MFG_WEEK                                                                                             
								,PROD_QTY        AS MFG_QTY                                                                                                             
								,NULL            AS CHG_QTY                                                                                                             
								,ORDER_TYPE      AS PRODUCTION_TYPE                                                                                                     
								,PST             AS SAMPLE_FROM_DATE                                                                                                    
								,PET             AS SAMPLE_TO_DATE                                                                                                      
								,PRODUCTION_LINE AS LINE_ID                                                                                                             
								,PRIORITY                                                                                                             
								,FIX_FLAG        AS PERIOD_TYPE                                                                                                         
								,NULL            AS CONFIRM_TYPE                                                                                                        
								,NULL            AS DEMAND_TYPE
								--2017-11-13 PIYONG MARKET 조회 로직 변경 시작 
								-------------------------------------------------------------------------------------------
								, CASE WHEN ( SELECT TOP 1 P.SITE_ID                                                                                                                        
												FROM [DBO].[SCM_PLANT_M] P WITH(NOLOCK)                                                                                            
											   WHERE A.SEGMENT5 = P.PLANT_ID              ) = 'A002'  THEN 
										ISNULL( ( SELECT MMM.DEFAULT_MARKET 
													FROM SCM_MODEL_MARKET_M  MMM  WITH(NOLOCK)
												   WHERE MMM.COMPANY_ID  = A.ATTRIBUTE1
												   AND   MMM.DIVISION_ID = A.SEGMENT4
												   AND   MMM.SITE_ID     = ( SELECT TOP 1 P.SITE_ID                                                                                                                        
																             FROM   [DBO].[SCM_PLANT_M] P WITH(NOLOCK)                                                                                             
															                 WHERE  A.SEGMENT5 = P.PLANT_ID )
												   AND   MMM.ITEM_ID     = A.ITEM_ID
												   AND   MMM.PRODUCTION_TYPE = A.ORDER_TYPE		--2018-09-17 PIYONG 조건 추가
												   AND   ISNULL(MMM.ACTIVE_FLAG,'N') = 'Y' -- 2018-01-04 kimcd 조건 추가
												), 'E' )
									   ELSE
										  A.MARKET
									    END AS MARKET
								--2017-11-13 PIYONG MARKET 조회 로직 변경 끝
								--------------------------------------------------------------------------------------------
								,'PR_XIF_RCCP_PRODTARGET_R' AS INSERT_ID                                                                                                   
								,GETDATE() AS INSERT_TIME                                                                                                         
								,'PR_XIF_RCCP_PRODTARGET_R' AS UPDATE_ID                                                                                                   
								,GETDATE() AS UPDATE_TIME  
							FROM (
									SELECT A.*
										   ,PLAN_SUBJECT.SEGMENT4
										   ,PLAN_SUBJECT.SEGMENT5
										   ,PLAN_SUBJECT.ATTRIBUTE1
									  FROM [dbo].[SY_XIF_RCCP_PROD_TARGET_R] A WITH(NOLOCK)
										  ,(
											 SELECT A.OPERATION_GROUP, A.SITE_CODE, A.DIVISION, MAX(A.PLAN_WEEK) PLAN_WEEK
											   FROM [dbo].[SY_XIF_RCCP_PROD_TARGET_R] A WITH(NOLOCK)
											  WHERE --(A.PLAN_WEEK LIKE @V_PLAN_WEEK + '%'  OR  A.PLAN_WEEK LIKE @V_LAST_PLAN_WEEK + '%' ) -- 2017-06-20 PIYONG 지난 주  조건 추가
													A.PLAN_WEEK LIKE @V_PLAN_WEEK + '%'													   -- 2018-04-26 PIYONG 지난 주  조건 삭제
												AND ISNULL(A.PROC_FLAG,'N') = 'N'
											  GROUP BY A.OPERATION_GROUP, A.SITE_CODE, A.DIVISION
										  ) TARGET_PLANWEEK
										  ,(
											SELECT  W.SEGMENT4   SEGMENT4
												   ,W.SEGMENT5   SEGMENT5
												   ,W.ATTRIBUTE1 ATTRIBUTE1
												   ,W.SEGMENT3   OPERATION_GROUP
												   ,W.SEGMENT2   SITE_CODE
												   ,W.SEGMENT1   DIVISION
											  FROM [DBO].[SCM_SYS_LOOKUP_VALUE] W WITH(NOLOCK)
											 WHERE W.LOOKUP_TYPE_CODE = 'RCCP_PLANT'
											   AND ATTRIBUTE2 = 'Y'    
										  ) PLAN_SUBJECT
									WHERE A.PLAN_WEEK        = TARGET_PLANWEEK.PLAN_WEEK
									  AND A.OPERATION_GROUP  = TARGET_PLANWEEK.OPERATION_GROUP
									  AND A.SITE_CODE        = TARGET_PLANWEEK.SITE_CODE
									  AND A.DIVISION         = TARGET_PLANWEEK.DIVISION
									  AND ISNULL(A.PROC_FLAG,'N') = 'N'
									  AND A.OPERATION_GROUP  = PLAN_SUBJECT.OPERATION_GROUP 
									  AND A.SITE_CODE        = PLAN_SUBJECT.SITE_CODE 
									  AND A.DIVISION         = PLAN_SUBJECT.DIVISION

								) A

						;              


						--------------------------------------------------------------------------------------------------------------------------
						--2017-11-24 PIYONG  신규로 생성되기전 변경이 있는 데이터에 PRODUCTION_TYPE, MARKET 값을 신규SCP_PLAN_ID에 적용 시작
						--2017-12-22 PIYONG  매주 첫번째 물동 이면 SCM_MODEL_MARKET_M 기준으로 복사 로직 추가
						-------------------------------------------------------------------------------------------------------------------------
						-- 이번주 첫 물동 이후 들어온 수신된 MARKET 정보 변경
						DECLARE CUR_MARKET_U CURSOR FOR
							SELECT DISTINCT A.DIVISION_ID
							  FROM FP_WEEKLY_DEMAND_PRODUCT_H A
							 WHERE SCP_PLAN_ID = @V_SCP_PLAN_ID
							   AND NOT EXISTS ( SELECT 1
								                  FROM [dbo].[SY_XIF_RCCP_PROD_TARGET_R] B WITH(NOLOCK)
												 WHERE ISNULL(PROC_FLAG,'N') = 'N'
												   AND B.DIVISION = A.DIVISION_ID
												   AND B.PLAN_WEEK = @V_PLAN_WEEK+'_001' )

						OPEN CUR_MARKET_U;
						FETCH NEXT FROM CUR_MARKET_U INTO @C_DIVISION
						;             

						WHILE (@@FETCH_STATUS = 0)
							BEGIN
								UPDATE A
								   SET PRODUCTION_TYPE = B.PRODUCTION_TYPE
									   ,MARKET = B.MARKET
								  FROM FP_WEEKLY_DEMAND_PRODUCT_H A
									   ,(SELECT [COMPANY_ID]
												,H.[DIVISION_ID]
												,[SITE_ID]
												,[PLANT_ID]
												,[SHOP_GROUP_ID]
												,[SCP_TARGET_ID]
												,PRODUCTION_TYPE
												,MARKET
										   FROM FP_WEEKLY_DEMAND_PRODUCT_H H
												INNER JOIN #BEFORE_SCP_PLAN_ID SP
														ON (
															 H.SCP_PLAN_ID = SP.SCP_PLAN_ID
															 AND H.DIVISION_ID = SP.DIVISION_ID
														   )
										  WHERE H.DIVISION_ID = @C_DIVISION
																									) B
									WHERE SCP_PLAN_ID = @V_SCP_PLAN_ID
									  AND A.[COMPANY_ID] = B.[COMPANY_ID]
									  AND A.[DIVISION_ID] = B.[DIVISION_ID]
									  AND A.[SITE_ID] = B.[SITE_ID]
									  AND A.[PLANT_ID] = B.[PLANT_ID]
									  AND A.[SHOP_GROUP_ID] = B.[SHOP_GROUP_ID]
									  AND A.[SCP_TARGET_ID] = B.[SCP_TARGET_ID]
									
								FETCH NEXT FROM CUR_MARKET_U INTO @C_DIVISION
								;              

								END;

						CLOSE CUR_MARKET_U;
						DEALLOCATE CUR_MARKET_U;
						--2017-12-22 PIYONG ADD 끝
						--------------------------------------------------------------------------------------------------------------------------
						--2017-11-24 PIYONG  신규로 생성되기전 변경이 있는 데이터에 PRODUCTION_TYPE, MARKET 값을 신규SCP_PLAN_ID에 적용 끝
						--------------------------------------------------------------------------------------------------------------------------


						MERGE INTO [DBO].[SCM_SCP_PLAN_H] A
						USING (
							   SELECT @V_SCP_PLAN_ID AS SCP_PLAN_ID,
									  'PRODUCT' AS SCP_PLAN_TYPE,
									  CONVERT(DATETIME, SUBSTRING(@V_SCP_PLAN_ID, 1, 8)) AS PLAN_START_TIME,
									  200 AS PLAN_HORIZON,
									  200 AS DEMAND_HORIZON,
									  SUBSTRING(@V_SCP_PLAN_ID, 1, 4) + CAST(DATEPART(WW, SUBSTRING(@V_SCP_PLAN_ID, 1, 8)) AS NVARCHAR) AS PLAN_WEEK
							  ) B
						ON (
							A.SCP_PLAN_ID = B.SCP_PLAN_ID
						   )
						WHEN MATCHED THEN
							UPDATE SET  A.[SCP_PLAN_TYPE]     = B.[SCP_PLAN_TYPE]
									   ,A.[PLAN_START_TIME]   = B.[PLAN_START_TIME]
									   ,A.[PLAN_HORIZON]      = B.[PLAN_HORIZON]
									   ,A.[DEMAND_HORIZON]    = B.[DEMAND_HORIZON]
									   ,A.UPDATE_ID           = 'PR_XIF_RCCP_PRODTARGET_R'
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
									'PR_XIF_RCCP_PRODTARGET_R',
									GETDATE(),
									'PR_XIF_RCCP_PRODTARGET_R',
									GETDATE()
						   )
						;
                  
						SET @ROWCOUNT = @@ROWCOUNT

						IF @ROWCOUNT > 0
							BEGIN
								-- 2018-07-23 PIYONG ADD
								DECLARE CUR_MAIL CURSOR FOR
									SELECT DISTINCT SEGMENT1 AS  DIVISION_ID
									  FROM [DBO].[SCM_SYS_LOOKUP_VALUE] WITH(NOLOCK)
									 WHERE LOOKUP_TYPE_CODE = 'RCCP_PLANT'
									   AND ATTRIBUTE2 = 'Y'
									   AND ACTIVE_FLAG = 'Y'

								OPEN CUR_MAIL;
			
								FETCH NEXT FROM CUR_MAIL INTO @DIVISION_ID

								WHILE (@@FETCH_STATUS = 0)
									BEGIN

										-- 2018-07-23 PIYONG ADD
										SET @DIVISION_NAME = (
																SELECT TOP 1 DIVISION_NAME
																  FROM SCM_DIVISION_M
																 WHERE DIVISION_ID = @DIVISION_ID
																 ORDER BY DIVISION_NAME
															 )

										INSERT INTO dbo.SCM_MAILING_H (
										   [MAIL_PKEY]
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
												,REPLACE([MAIL_SUBJECT],'@DIVISION_NAME',@DIVISION_NAME)											-- 2018-07-23 PIYONG CHANGE
												,REPLACE( REPLACE([MAIL_BODY],'@V_SCP_PLAN_ID',@V_SCP_PLAN_ID) ,'@DIVISION_NAME',@DIVISION_NAME)	-- 2018-07-23 PIYONG CHANGE
												,[MAIL_QUERY]
												,[ATTACH_FILE_NAME]
												,[MAIL_RECEIVER_LIST]+ ISNULL(	-- 2018-07-23 PIYONG CHANGE
																			  (
																				SELECT ATTRIBUTE1
																				  FROM [DBO].[SCM_SYS_LOOKUP_VALUE] WITH(NOLOCK)
																				 WHERE LOOKUP_TYPE_CODE = 'TARGET_INFO_MAIL'
																				   AND SEGMENT1 ='RCCP_PROD'
																				   AND SEGMENT3 = @DIVISION_ID
																				   AND ACTIVE_FLAG = 'Y'
																			  )
																			   , ';')
												,'FP_MAIL_TEST'
												,'N'
												,NULL  
												,@v_proc_name
												,getdate()
												,@v_proc_name
												,getdate()
										  FROM [SCM_MAILING_LIST_M]
										 WHERE MAIL_PKEY = 'RCCP_PROD'+@DIVISION_ID

								 		FETCH NEXT FROM CUR_MAIL INTO @DIVISION_ID
										;

									END

								CLOSE CUR_MAIL;
								DEALLOCATE CUR_MAIL;

							END


						UPDATE [dbo].[SY_XIF_RCCP_PROD_TARGET_R]
						   SET PROC_FLAG = 'Y'
							  ,PROC_DATE = GETDATE()
						 WHERE ISNULL(PROC_FLAG,'N') = 'N'
						;


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
                                                                                                                                                                 


