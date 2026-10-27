                                                                                                                                                                                                                                                                     
CREATE PROCEDURE [dbo].[PR_XIF_EUM_FP_DPP_H_S]
                                                                                                                                                                                                                                                                     
-- ================================================================================================                                                                                                                                                                  
-- Program ID          : FPX0007
-- Program Name        : PR_XIF_EUM_FP_DPP_H_S                                                                                                                                                                                                                             
-- Param               :                                                                                                                                                                                                                                             
-- Batch Period        : 20 Minutes                                                                                                                                                                                                                                      
-- Description         :                                                                                                                                                                                                                                             
--                                                                                                                                                                                                                                                                   
-- Source System       : FP SDB                                                                                                                                                                                                                                      
-- Destination System  : INF                                                                                                                                                                                                                                     
-- Source Table        : FP_DAILY_PRODUCTION_PLAN_H                                                                                                                                                                                                              
-- Destination Table   : XIF_FP_DPP_H_S                                                                                                                                                                                                                               
--                                                                                                                                                                                                                                                                   
-- Create(Update) Date : 2025.12.01
-- Update Date         : 
--						 
-- Author              : FP Pjt.                                                                                                                                                                                                                                         
-- Version             : 1.0 FP Pjt. E20251120-001239_ESG 팀 생산계획 DATA IF 진행건 (SCP.FP)
--						 1.1 yokejacob E20260518-000387 [공급/생산 SCM PI팀] SCM FP 주단위 생산계획 I/F 요청의 건
--		
--	
-- ================================================================================================                                                                                                                                                               

AS 

BEGIN     
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED 
    SET NOCOUNT ON                                                                                                                                                                                                                                                   
	SET XACT_ABORT ON                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                     
	-- LOG 용 변수 설정                                                                                                                                                                                                                                                   
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_EUM_FP_DPP_H_S'                 
	
	DECLARE @v_descr     NVARCHAR(250)                                                                                                                                                                                                                                
	DECLARE @v_count     INTEGER	  = 0                                                                                                                                                                                                                            
	DECLARE @sysdate     DATETIME     = GETDATE()  
	
	DECLARE @ROWCOUNT    INTEGER                                                                                                                                                                                                                  
                                                                                                                                                                                                                                                                     
	-- ERROR_LINE                                                                                                                                                                                                                                                    
	DECLARE @v_temp1     NVARCHAR(1000)                                                                                                                                                                                                                               
	DECLARE @v_temp2     NVARCHAR(1000)                                                                                                                                                                                                                               
                                                                                                                                                                                                                                                                     
	
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
		
		--LOOKUP 추가하여 관리, E20260518-000387 [공급/생산 SCM PI팀] SCM FP 주단위 생산계획 I/F 요청의 건
		;WITH LOOKUPDATA AS (
			SELECT SEGMENT1, SEGMENT2
			FROM SCM_SYS_LOOKUP_VALUE WITH(NOLOCK)
			WHERE LOOKUP_TYPE_CODE = 'GEUM_FP_DPP'
			  AND SEGMENT1 IN ('COMPANY_ID', 'OPERATION_ID')
			  AND ACTIVE_FLAG ='Y'
		)
		INSERT INTO [dbo].[SY_XIF_FP_DPP_H_S] (
			   [IF_SEQ]                                                                                                                                                                                                                                  
			 , [IF_TYPE]                                                                                                                                                                                                                                   
			 , [IF_ID]                                                                                                                                                                                                                                     
			 , [IF_INS_DATE]                                                                                                                                                                                                                               
			 , [IF_FLAG]                                                                                                                                                                                                                                   
			 , [IF_SND_DATE]                                                                                                                                                                                                                               
			 , COMPANY_ID                                                                                                                                  
			 , DIVISION_ID                                                                                                                                  
			 , SITE_ID                                                                                                                                  
			 , PLANT_ID                                                                                                                                  
			 , FACTORY_ID                                                                                                                                  
			 , OPERATION_ID                                                                                                                                  
			 , LINE_ID                                                                                                                                  
			 , ELECTRODE_TYPE                                                                                                                                  
			 , EQUIPMENT_ID                                                                                                                                  
			 , LOCATION                                                                                                                                  
			 , MARKET                                                                                                                                  
			 , PRODUCTION_TYPE                                                                                                                                  
			 , ITEM_ID                                                                                                                                  
			 , PLAN_DATE                                                                                                                                  
			 , PLAN_IN_QTY                                                                                                                                  
			 , PLAN_QTY                                                                                                                                  
			 )		 
			SELECT 
				'OFP0' + SUBSTRING(CONVERT(NVARCHAR(12), GETDATE(), 112), 3,6) + REPLICATE('0', 10 - LEN(NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ])) + CAST( NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ] AS NVARCHAR)   -- IF_SEQ
				, 'S'   -- IF_TYPE 
				, 'OFP0_GEUM_FP_DPP_H'
				, GETDATE()   -- IF_INS_DATE 
				, 'N'  -- IF_FLAG 
				, NULL  -- IF_SND_DATE 
				, COMPANY_ID
				, DIVISION_ID
				, SITE_ID
				, PLANT_ID
				, FACTORY_ID
				, OPERATION_ID
				, LINE_ID
				, ELECTRODE_TYPE
				, EQUIPMENT_ID
				, LOCATION
				, MARKET
				, PRODUCTION_TYPE
				, ITEM_ID
				, CONVERT(VARCHAR(10), PLAN_DATE, 23) AS PLAN_DATE 
				, PLAN_IN_QTY
				, PLAN_QTY
             FROM [10.34.220.88,7433].LGCE_FP_TR.DBO.[FP_DAILY_PRODUCTIOIN_PLAN_H] WITH(NOLOCK)
            WHERE PLAN_TYPE = 'RELEASE'
			  AND COMPANY_ID IN (SELECT SEGMENT2 FROM LOOKUPDATA WHERE SEGMENT1 = 'COMPANY_ID')      --LOOKUP 추가하여 관리, E20260518-000387 [공급/생산 SCM PI팀] SCM FP 주단위 생산계획 I/F 요청의 건
			  AND OPERATION_ID IN (SELECT SEGMENT2 FROM LOOKUPDATA WHERE SEGMENT1 = 'OPERATION_ID')  --LOOKUP 추가하여 관리, E20260518-000387 [공급/생산 SCM PI팀] SCM FP 주단위 생산계획 I/F 요청의 건
			  AND PLAN_DATE BETWEEN CAST(GETDATE() AS DATE) AND CAST(DATEADD(DAY, 14, GETDATE()) AS DATE) 
		
		SET @ROWCOUNT = @@ROWCOUNT
		
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
