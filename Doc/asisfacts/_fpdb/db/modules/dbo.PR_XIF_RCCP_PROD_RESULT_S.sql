                                                                                                                                                                    
CREATE PROCEDURE [dbo].[PR_XIF_RCCP_PROD_RESULT_S]                                                                                                                   
                                                                                                                                                                    
-- ================================================================================================                                                                 
-- PROGRAM ID          :                                                                                                                                            
-- PROGRAM NAME        : PR_XIF_RCCP_PROD_RESULT_S                                                                                                                  
-- PARAM               :                                                                                                                                            
-- BATCH PERIOD        : 1HOUR                                                                                                                                      
-- DESCRIPTION         :                                                                                                                                            
--                                                                                                                                                                  
-- SOURCE SYSTEM       : FP SDB                                                                                                                                       
-- DESTINATION SYSTEM  : RCCP                                                                                                                                     
-- SOURCE TABLE        : SCM_PRODUCT_RESULT_H                                                                                                                     
-- DESTINATION TABLE   : XIF_RCCP_PROD_RESULT_S                                                                                                                     
--                                                                                                                                                                  
-- CREATE(UPDATE) DATE : 2016.08.16                                                                                                                                 
-- AUTHOR              : 김 석                                                                                                                                        
-- VERSION             : 1.0                                                                                                                                        
-- ================================================================================================                                                                 
                                                                                                                                                                    
AS                                                                                                                                                                  
                                                                                                                                                                    
BEGIN                                                                                                                                                               
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED                                                                                                                  
    SET NOCOUNT ON                                                                                                                                                  
	SET XACT_ABORT ON                                                                                                                                               
                                                                                                                                                                    
	-- LOG 용 변수 설정                                                                                                                                                  
	DECLARE @V_PROC_NAME NVARCHAR(100) = 'PR_XIF_RCCP_PROD_RESULT_S'                                                                                                 
	DECLARE @V_DESCR     NVARCHAR(250)                                                                                                                               
	DECLARE @V_COUNT     INTEGER	  = 0                                                                                                                           
	DECLARE @SYSDATE     DATETIME     = GETDATE()       
	
	DECLARE @ROWCOUNT    INTEGER
	                                                                                                            
	-- ERROR_LINE                                                                                                                                                   
	DECLARE @V_TEMP1     NVARCHAR(1000)                                                                                                                              
	DECLARE @V_TEMP2     NVARCHAR(1000)                                                                                                                              
                                                                                                                                                                    
	-- ================================================                                                                                                             
    -- DECLARE START                                                                                                                                                
	-- ================================================                                                                                                             
	DECLARE @IF_SEQ       BIGINT                                                                                                                                    
                                                                                                                                                                    
	-- ================================================                                                                                                             
    -- DECLARE END                                                                                                                                                  
	-- ================================================                                                                                                             
                                                                                                                                                                    
	SET @V_TEMP1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))                                               
	SET @V_TEMP2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))                                               
                                                                                                                                                                    
	-- START 로그는 무조건 남김                                                                                                                                             
	EXEC PR_XIF_LOG @V_PROC_NAME, NULL, 'START', NULL, @V_TEMP1, '############### START OF PROCEDURE ###############', NULL, @SYSDATE                               
                                                                                                                                                                    
	BEGIN TRY			                                                                                                                                            
                                                                                                                                                                    
		BEGIN TRAN                                                                                                                                                  
		-- ================================================                                                                                                         
		-- 로직 추가 START                                                                                                                                              
		-- ================================================                                                                                                         
		                                                                                                                                                            
	 SET @IF_SEQ = REPLACE(REPLACE(REPLACE(CONVERT(NVARCHAR(19),GETDATE(),121),'-',''),':',''),' ','')                                                               
		                                                                                                                                                            
	 -- 동일 일자로 기존에 만들어진 정보 존재시 삭제                                                                                                                               
     DELETE [dbo].[SY_XIF_RCCP_PROD_RESULT_S]                                                                                                            
      WHERE CONVERT(NVARCHAR(8),IF_INS_DATE,112)  = CONVERT(NVARCHAR(8),GETDATE(),112)                                                                                
		                                                                                                                                                                    
		INSERT INTO [dbo].[SY_XIF_RCCP_PROD_RESULT_S]                                                                                                    
				   ([IF_SEQ]                                                                                                                                        
				   ,[IF_TYPE]                                                                                                                                       
				   ,[IF_ID]                                                                                                                                         
				   ,[IF_INS_DATE]                                                                                                                                   
				   ,[IF_FLAG]                                                                                                                                       
				   ,[IF_SND_DATE]                                                                                                                                   
				   ,[DIVISION_CODE]                                                                                                                                 
				   ,[SITE_CODE]                                                                                                                                     
				   ,[SITE_NAME]                                                                                                                                     
				   ,[RESOURCE_CODE]                                                                                                                                 
				   ,[RESOURCE_NAME]                                                                                                                                 
				   ,[YYYYMMDD]                                                                                                                                      
				   ,[ITEM_CODE]                                                                                                                                     
				   ,[ITEM_NAME]                                                                                                                                     
				   ,[RESULT_QTY]                                                                                                                                    
				   ,[CREATE_USER_ID]                                                                                                                                
				   ,[CREATE_DATE]                                                                                                                                   
				   ,[MODIFY_USER_ID]                                                                                                                                
				   ,[MODIFY_DATE]                                                                                                                                   
				   ,[ATTR_01]                                                                                                                                       
				   ,[ATTR_02]                                                                                                                                       
				   ,[ATTR_03]                                                                                                                                       
				   ,[ATTR_04]                                                                                                                                       
				   ,[ATTR_05]                                                                                                                                       
				   ,[ATTR_06]                                                                                                                                       
				   ,[ATTR_07]                                                                                                                                       
				   ,[ATTR_08]                                                                                                                                       
				   ,[ATTR_09]                                                                                                                                       
				   ,[ATTR_10])                                                                                                                                      
			SELECT 'OFP0' + SUBSTRING(CONVERT(NVARCHAR(12), GETDATE(), 112), 3,6) + REPLICATE('0', 10 - LEN(NEXT VALUE FOR [LGCE_INFDEV].[dbo].[XIF_RCCP_SEND_SEQ])) + CAST( NEXT VALUE FOR [LGCE_INFDEV].[dbo].[XIF_RCCP_SEND_SEQ] AS NVARCHAR),
			--SELECT '1'                        AS IF_SEQ,
				   'I'                          AS IF_TYPE,
				   'OFP0_ORCP_FP_PROD_RESULT'   AS IF_ID,
				   GETDATE()                    AS IF_INS_DATE,
				   'N'                          AS IF_FLAG,
				   NULL                         AS IF_SND_DATE,
				   X.DIVISION_ID AS DIVISION_CODE,
				   X.PLANT_ID AS SITE_CODE,
				   P.PLANT_NAME AS SITE_NAME,
				   X.LINE_ID AS RESOURCE_CODE,
				   ( SELECT TOP 1 L.LINE_NAME
				     FROM   DBO.SCM_LINE_M L
					 WHERE  L.LINE_ID = X.LINE_ID ) AS RESOURCE_NAME,
				   CONVERT(NVARCHAR, X.PRODUCT_DATE, 112) YYYYMMDD,
				   X.ITEM_ID AS ITEM_CODE,
				   I.ITEM_NAME,
				   SUM(X.QTY) AS RESULT_QTY,
			       'PR_XIF_RCCP_PROD_RESULT_S' AS CREATE_USER_ID,                                                                                                   
			       GETDATE() AS CREATE_DATE,                                                                                                                        
			       'PR_XIF_RCCP_PROD_RESULT_S' AS MODIFY_USER_ID,                                                                                                   
			       GETDATE() AS MODIFY_DATE,                                                                                                                        
				   NULL AS ATTR_01,                                                                                                                                 
				   NULL AS ATTR_02,                                                                                                                                 
				   NULL AS ATTR_03,                                                                                                                                 
				   NULL AS ATTR_04,                                                                                                                                 
				   NULL AS ATTR_05,                                                                                                                                 
				   NULL AS ATTR_06,                                                                                                                                 
				   NULL AS ATTR_07,                                                                                                                                 
				   NULL AS ATTR_08,                                                                                                                                 
				   NULL AS ATTR_09,                                                                                                                                 
				   NULL AS ATTR_10                                                                                                                                  
			  FROM [DBO].[SCM_PRODUCT_RESULT_H] X WITH(NOLOCK)                                                                                                                  
				  ,DBO.SCM_ITEM_M I WITH(NOLOCK)  
				  ,(/*
				    SELECT DISTINCT 
						   A.LINE_ID
						  ,A.OPERATION_ID
						  ,B.[LINE_NAME]
					  FROM [DBO].[SCM_PRODUCT_RESULT_H] A WITH(NOLOCK),
						   [DBO].[SCM_LINE_M] B WITH(NOLOCK)
					 WHERE 1=1
					   AND A.LINE_ID      = B.LINE_ID
					   AND A.OPERATION_ID = B.OPERATION_ID
					   AND A.CUTOFF_DATE  > (GETDATE() -30 )*/
				    SELECT BASE.LINE_ID
						  ,BASE.OPERATION_ID
						  ,BASE.CUTOFF_DATE
						  ,BASE.PRODUCT_DATE
					FROM (SELECT A.LINE_ID
								,A.OPERATION_ID
								,A.CUTOFF_DATE
								,A.PRODUCT_DATE
								,ROW_NUMBER() OVER (PARTITION BY A.LINE_ID,A.OPERATION_ID,A.PRODUCT_DATE
													ORDER BY A.LINE_ID,A.OPERATION_ID,A.PRODUCT_DATE,A.CUTOFF_DATE DESC
													) AS DIS_NUM
						  FROM  [DBO].[SCM_PRODUCT_RESULT_H] A WITH(NOLOCK)
						  WHERE 1=1
						  AND   A.LINE_ID IS NOT NULL
						  AND   A.CUTOFF_DATE  > (GETDATE() -7 )
						  AND   A.OPERATION_ID IN (SELECT L.SEGMENT1
												   FROM   DBO.SCM_SYS_LOOKUP_VALUE L WITH(NOLOCK)
												   WHERE  L.LOOKUP_TYPE_CODE = 'RCCP_CALENDAR_OPERATION'
												   AND    L.ACTIVE_FLAG      = 'Y')
						  GROUP BY A.LINE_ID
								  ,A.OPERATION_ID
								  ,A.CUTOFF_DATE
								  ,A.PRODUCT_DATE ) BASE
					WHERE  BASE.DIS_NUM = 1
				  ) BASE                                                                                                                              
				  ,DBO.SCM_PLANT_M P WITH(NOLOCK)                                                                                                                               
			WHERE X.CUTOFF_DATE > (GETDATE() -7 ) -- 과거 30일 생산실적 정보를 넘김.                                                                                             
			  AND I.ITEM_ID  = X.ITEM_ID                                                                                                                             
			  AND I.SITE_ID  = X.SITE_ID                                                                                                                             
			  AND P.PLANT_ID = X.PLANT_ID                                                                                                                           
			  AND X.PLANT_ID = P.PLANT_ID   
			  AND X.LINE_ID  = BASE.LINE_ID
			  AND X.OPERATION_ID = BASE.OPERATION_ID
			  AND X.CUTOFF_DATE	 = BASE.CUTOFF_DATE
			  AND X.PRODUCT_DATE = BASE.PRODUCT_DATE                                                                                                                        
			GROUP BY X.DIVISION_ID,                                                                                                                                 
					 X.PLANT_ID,                                                                                                                                    
					 P.PLANT_NAME,                                                                                                                                  
					 X.LINE_ID,                                                                                                                                     
					 CONVERT(NVARCHAR, X.PRODUCT_DATE, 112),                                                                                                         
					 X.ITEM_ID,                                                                                                                                     
					 I.ITEM_NAME                                                                                                                                    
                                                                                                                                                                    
			                                                                                                                                                        
			  ;                   
			                                                                                                                                    
        SET @ROWCOUNT = @@ROWCOUNT                                                                                                                                                   
                                                                                                                                                                    
		-- ================================================                                                                                                         
		-- 로직 추가 END                                                                                                                                                
		-- ================================================                                                                                                         
		COMMIT TRAN                                                                                                                                                 
                                                                                                                                                                    
		EXEC PR_XIF_LOG @V_PROC_NAME, NULL, 'END', @ROWCOUNT, @V_TEMP1, '############### END OF PROCEDURE ###############', NULL, @SYSDATE                             
		                                                                                                                                                            
	END TRY                                                                                                                                                         
                                                                                                                                                                    
	BEGIN CATCH                                                                                                                                                     
                                                                                                                                                                    
	    ROLLBACK TRAN                                                                                                                                                
		-- 에러나도 로그는 인서트                                                                                                                                             
		SET @V_DESCR = ERROR_MESSAGE()                                                                                                                              
		EXEC PR_XIF_LOG @V_PROC_NAME, NULL, 'ERROR', NULL, @V_TEMP2, NULL, @V_DESCR, @SYSDATE                                                                       
                                                                                                                                                                    
	END CATCH                                                                                                                                                       
                                                                                                                                                                    
END                                                                                                                                                                 
                                                                                                                                                                    


