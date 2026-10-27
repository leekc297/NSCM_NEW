                                                                                                                                                                 
CREATE PROCEDURE [dbo].[PR_XIF_RCCP_PRODTARGET_R_DV]                                                                                                                 
                                                                                                                                                                 
-- ================================================================================================                                                              
-- Program ID          :                                                                                                                                         
-- Program Name        : PR_XIF_RCCP_PRODTARGET_R_DV                                                                                                                
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
--
-- Author              : 김 석                                                                                                                                     
-- Version             : 1.0
--					   : 1.1  201-04-06 MARKET PK로 변경
--									    FP_WEEKLY_DEMAND_PRODUCT_H  입력 할때 ISNULL(MARKERT, 'D') 변경

--					   : 1.2 FP_WEEKLY_DEMAND_PRODUCT_H 테이블 PRODUCTION_TYPE 값 변경 로직 추가
--					   : 1.3 실행 여부를 이번주, 지난주 모두 확인 하도록 변경
-- ================================================================================================                                                              
                                                                                                                                                                 
AS                                                                                                                                                               
                                                                                                                                                                 
BEGIN                                                                                                                                                            
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED                                                                                                               
    SET NOCOUNT ON                                                                                                                                               
	SET XACT_ABORT ON                                                                                                                                            
                                                                                                                                                                 
	-- LOG 용 변수 설정                                                                                                                                               
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_RCCP_PRODTARGET_R_DV'                                                                                               
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
								  FROM [dbo].[SY_XIF_RCCP_PROD_TARGET_R] WITH(NOLOCK)
								 WHERE ISNULL(PROC_FLAG,'N') = 'N'
							)

		IF @PROC_FLAG_CHK > 0

			BEGIN

				DECLARE @CNT_CHK			NUMERIC(10,0)
				DECLARE @V_PLAN_WEEK		NVARCHAR(50)
				DECLARE @V_SCP_PLAN_ID		NVARCHAR(50)
				DECLARE @DV					NVARCHAR(50)
				DECLARE @PHONE_NUM			NVARCHAR(50)

				SET @V_PLAN_WEEK = (
									SELECT MAX( PLAN_WEEK)
									  FROM [dbo].[SY_XIF_RCCP_PROD_TARGET_R]
									 WHERE ISNULL(PROC_FLAG,'N') = 'N'
								   )

				SET @V_SCP_PLAN_ID = @V_PLAN_WEEK

				DECLARE CUR_DIVISION CURSOR FOR
					SELECT DISTINCT DIVISION
					  FROM [dbo].[SY_XIF_RCCP_PROD_TARGET_R] WITH(NOLOCK)
					 WHERE ISNULL(PROC_FLAG,'N') = 'N'
					   AND PLAN_WEEK = @V_PLAN_WEEK

				OPEN CUR_DIVISION;
				FETCH NEXT FROM CUR_DIVISION INTO @DV  
				WHILE (@@FETCH_STATUS = 0)
					BEGIN
						SET @CNT_CHK = (
										SELECT COUNT(1) -- 값이 0 보다 크면 수행을 하면 안됨.
										  FROM (
												SELECT (
														SELECT COUNT(1)
														  FROM [dbo].[SY_XIF_RCCP_PROD_TARGET_R] A WITH(NOLOCK)
														 WHERE A.PLAN_WEEK = @V_PLAN_WEEK
														   AND A.OPERATION_GROUP  = W.SEGMENT3
														   AND A.SITE_CODE        = W.SEGMENT2
														   AND A.DIVISION         = W.SEGMENT1
														) COUNTS
												   FROM [DBO].[SCM_SYS_LOOKUP_VALUE] W WITH(NOLOCK)
												  WHERE W.LOOKUP_TYPE_CODE = 'RCCP_PLANT'
													AND ATTRIBUTE2 = 'Y'
												    AND SEGMENT1 = @DV
											   ) X
										 WHERE COUNTS = 0
										)

						IF @CNT_CHK = 0

							BEGIN		             
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
										,ISNULL(A.MARKET, 'D') AS MARKET
										,'PR_XIF_RCCP_PRODTARGET_R_DV' AS INSERT_ID                                                                                                   
										,GETDATE() AS INSERT_TIME                                                                                                         
										,'PR_XIF_RCCP_PRODTARGET_R_DV' AS UPDATE_ID                                                                                                   
										,GETDATE() AS UPDATE_TIME  
								   FROM (
											SELECT A.*
												   ,PLAN_SUBJECT.SEGMENT4
												   ,PLAN_SUBJECT.SEGMENT5
												   ,PLAN_SUBJECT.ATTRIBUTE1
											  FROM [dbo].[SY_XIF_RCCP_PROD_TARGET_R] A WITH(NOLOCK)
												  ,(
													SELECT W.SEGMENT4   SEGMENT4
														   ,W.SEGMENT5   SEGMENT5
														   ,W.ATTRIBUTE1 ATTRIBUTE1
														   ,W.SEGMENT3   OPERATION_GROUP
														   ,W.SEGMENT2   SITE_CODE
														   ,W.SEGMENT1   DIVISION
													  FROM [DBO].[SCM_SYS_LOOKUP_VALUE] W WITH(NOLOCK)
													 WHERE W.LOOKUP_TYPE_CODE = 'RCCP_PLANT'
													   AND ATTRIBUTE2 = 'Y'    
												  ) PLAN_SUBJECT
											WHERE A.OPERATION_GROUP  = PLAN_SUBJECT.OPERATION_GROUP 
											  AND A.SITE_CODE        = PLAN_SUBJECT.SITE_CODE 
											  AND A.DIVISION         = PLAN_SUBJECT.DIVISION
											  AND A.PROC_FLAG		 = 'N'
											  AND A.PLAN_WEEK		 = @V_PLAN_WEEK
											  AND A.DIVISION		 = @DV

										) A

								;              

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
											   ,A.UPDATE_ID           = 'PR_XIF_RCCP_PRODTARGET_R_DV'                                                                                          
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
											'PR_XIF_RCCP_PRODTARGET_R_DV',                                                                                                                                
											GETDATE(),                                                                                                                                   
											'PR_XIF_RCCP_PRODTARGET_R_DV',                                                                                                                                
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
												,REPLACE(REPLACE([MAIL_BODY],'@V_SCP_PLAN_ID',@V_SCP_PLAN_ID),'@DV',@DV)
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
										  WHERE MAIL_PKEY = 'FP_MAILING_IF10'

										DECLARE CUR_SMS CURSOR FOR
											SELECT ATTRIBUTE1 AS PN
											  FROM [DBO].[SCM_SYS_LOOKUP_VALUE] WITH(NOLOCK)
											 WHERE LOOKUP_TYPE_CODE = 'SMS_ADDRESSEE'
											   AND SEGMENT1 =  'PROD_TARGET'


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
													,N'[FP-LIVE] SCP TARGET('+@V_SCP_PLAN_ID+' DIVISION '+@DV+N' )이 새로 생성 되었습니다.'
												)
									
												FETCH NEXT FROM CUR_SMS INTO @PHONE_NUM;
											END;

										CLOSE CUR_SMS;
										DEALLOCATE CUR_SMS;

									END
								;

							END;


						UPDATE [dbo].[SY_XIF_RCCP_PROD_TARGET_R]
						   SET PROC_FLAG = 'Y'
							   ,PROC_DATE = GETDATE()                                                                                                                            
						 WHERE ISNULL(PROC_FLAG,'N') = 'N'
						   AND PLAN_WEEK  = @V_PLAN_WEEK
						   AND DIVISION = @DV
							
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
                                                                                                                                                                 


