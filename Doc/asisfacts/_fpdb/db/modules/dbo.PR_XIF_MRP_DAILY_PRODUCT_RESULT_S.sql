
CREATE PROCEDURE [dbo].[PR_XIF_MRP_DAILY_PRODUCT_RESULT_S]

-- ================================================================================================
-- Program ID          : FP00831
-- Program Name        : PR_XIF_MRP_DAILY_PRODUCT_RESULT_S
-- Param               :
-- Batch Period        : 1 Day
-- Description         : 
--                    
-- Source System       : FP
-- Destination System  : MRP
-- Source Table        : SCM_DAILY_PRODUCT_RESULT_H
-- Destination Table   : XIF_MRP_DAILY_PRODUCT_RESULT_S
--
-- Create Date	       : 2022.09.20
-- Update Date         : 2022.09.20  leeseongmin 1.0 -- initial
--                       2022.12.07  leeseongmin 1.1
--                       
-- Author              : leeseongmin 
-- Version             : 1.0
--					     2022-09-20 실적DATA 20일전까지 DATA의 변동이 있어 20일 이전 DATA만 전송
--					     2022-12-07 실적DATA 사이트 및 시업시간별로 MRP I/F 송신 
-- ================================================================================================
@SITE_ID       NVARCHAR(100) ,      -- 2022-12-07 실적DATA 사이트 및 시업시간별로 MRP I/F 송신 
@START_TIME    NVARCHAR(100)        -- 2022-12-07 실적DATA 사이트 및 시업시간별로 MRP I/F 송신 

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
            SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_MRP_DAILY_PRODUCT_RESULT_S'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	  = 0
	DECLARE @sysdate     DATETIME     = GETDATE()

	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)

	DECLARE @SITE_ID_L     NVARCHAR(1000)
	DECLARE @START_TIME_L    NVARCHAR(1000)

	SET @SITE_ID_L = @SITE_ID         --  2022-12-07 실적DATA 사이트 및 시업시간별로 MRP I/F 송신 
	SET @START_TIME_L = @START_TIME   --  2022-12-07 실적DATA 사이트 및 시업시간별로 MRP I/F 송신 

	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

	BEGIN TRY				

		BEGIN TRAN
		-- ================================================
		-- 로직 추가 start
		-- ================================================
	
			INSERT INTO  [dbo].[SY_XIF_MRP_DAILY_PRODUCT_RESULT_S]   --동의어처리 작업
			           ( IF_SEQ
                        ,IF_TYPE
                        ,IF_ID
                        ,IF_INS_DATE
                        ,IF_FLAG
                        ,IF_SND_DATE
                        ,COMPANY_ID
                        ,PLANT_ID
                        ,FACTORY_ID
                        ,ITEM_ID
                        ,OPERATION_ID
						,PRODUCTION_TYPE
                        ,LINE_ID
                        ,PLAN_DATE
                        ,ACTUAL_QTY
                        ,ACTUAL_GOOD_QTY
                        ,ACTUAL_SCRAP_QTY
                        ,ATTR_01 
                        ,ATTR_02 
                        ,ATTR_03
                        ,ATTR_04 
                        ,ATTR_05)
                  SELECT 'OFP0' + SUBSTRING(CONVERT(NVARCHAR(12), GETDATE(), 112), 3,6) + REPLICATE('0', 10 - LEN(NEXT VALUE FOR [DBO].[XIF_MRP_SEND_SEQ])) + CAST( NEXT VALUE FOR [DBO].[XIF_MRP_SEND_SEQ] AS NVARCHAR)
                        ,B.IF_TYPE
                        ,B.IF_ID
                        ,B.IF_INS_DATE
                        ,B.IF_FLAG
                        ,B.IF_SND_DATE
                        ,B.COMPANY_ID
                        ,B.PLANT_ID
                        ,B.FACTORY_ID
                        ,B.ITEM_ID
                        ,B.OPERATION_ID
						,B.PRODUCTION_TYPE
                        ,B.LINE_ID
                        ,B.PLAN_DATE
                        ,B.ACTUAL_QTY
                        ,B.ACTUAL_GOOD_QTY
                        ,B.ACTUAL_SCRAP_QTY
                        ,B.ATTR_01 
                        ,COUNT(*) OVER (PARTITION BY 1)   AS ATTR_02
                        ,B.ATTR_03
                        ,B.ATTR_04 
                        ,B.ATTR_05
                     FROM	(SELECT 'I'   AS IF_TYPE
                               ,'OFP0_OMRP_MRP_PROD_ACT_QTY'  AS IF_ID
		                       ,GETDATE()     AS IF_INS_DATE
		                       ,'N'           AS IF_FLAG
		                       ,NULL          AS IF_SND_DATE
                               ,MAX (DPR.COMPANY_ID) AS COMPANY_ID
							   ,DIVISION_ID
							   ,SITE_ID
		                       ,PLANT_ID
		                       ,FACTORY_ID
		                       ,ITEM_ID
		                       ,OPERATION_ID     
		                       ,PRODUCTION_TYPE      
		                       ,LINE_ID
		                       ,PLAN_DATE
		                       ,SUM (ACTUAL_QTY) AS ACTUAL_QTY
		                       ,SUM (ACTUAL_GOOD_QTY) AS ACTUAL_GOOD_QTY
		                       ,SUM (DPR.ACTUAL_SCRAP_QTY) AS ACTUAL_SCRAP_QTY
							   ,REPLACE(REPLACE(REPLACE(CONVERT(varchar, getdate(), 120), '-', ''), ' ', ''), ':', '')  AS ATTR_01	--  2022-12-07 실적DATA 사이트 및 시업시간별로 MRP I/F 송신 			 
		                       ,NULL	AS ATTR_03
		                       ,NULL	AS ATTR_04
		                       ,NULL	AS ATTR_05      
                           FROM [dbo].[SCM_DAILY_PRODUCT_RESULT_H] DPR WITH(NOLOCK)
				           WHERE PLAN_DATE > CAST(DATEADD(DD, -23, GETDATE()) AS DATE)                         --  2022-12-07 실적DATA 사이트 및 시업시간별로 MRP I/F 송신 
				           AND   SITE_ID   = @SITE_ID_L                                                        --  2022-12-07 실적DATA 사이트 및 시업시간별로 MRP I/F 송신 
				           AND   PLANT_ID  IN (  SELECT  W.SEGMENT1                                            
				                                 FROM   [DBO].[SCM_SYS_LOOKUP_VALUE] W  WITH(NOLOCK) 
				                                 WHERE  W.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
				                                 AND    W.ACTIVE_FLAG = 'Y' 
				                                 AND    W.SEGMENT2    = @START_TIME_L  )  				       --  2022-12-07 실적DATA 사이트 및 시업시간별로 MRP I/F 송신 
						   GROUP BY DPR.DIVISION_ID, DPR.SITE_ID ,DPR.PLANT_ID,DPR.FACTORY_ID,DPR.ITEM_ID,DPR.OPERATION_ID,DPR.PRODUCTION_TYPE,DPR.LINE_ID,DPR.PLAN_DATE				  
				     ) B

				   	INNER JOIN SCM_OPERATION_M SOM WITH(NOLOCK)
					ON     B.COMPANY_ID   = SOM.COMPANY_ID
					AND    B.DIVISION_ID  = SOM.DIVISION_ID
					AND    B.SITE_ID      = SOM.SITE_ID
					AND    B.OPERATION_ID = SOM.OPERATION_ID
					WHERE  SOM.ACTIVE_FLAG = 'Y' AND    WO_FLAG = 'Y'

		-- ================================================
		-- 로직 추가 end
		-- ================================================
		COMMIT TRAN

		EXEC PR_XIF_LOG @v_proc_name, NULL, 'END', NULL, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
		
	END TRY

	BEGIN CATCH

	    ROLLBACK TRAN
		-- 에러나도 로그는 인서트
		SET @v_descr = ERROR_MESSAGE()
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate

	END CATCH

END


