                                                                                                                                                                 
CREATE PROCEDURE [dbo].[PR_XIF_SCP_PRODTARGET_UPDATE_R]
                                                                                                                                                                 
-- ================================================================================================                                                              
-- Program ID          : FP00522
-- Program Name        : PR_XIF_SCP_PRODTARGET_UPDATE_R
-- Param               :
-- Batch Period        : 15 MINUTE                                                                                                                                   
-- Description         :
--                                                                                                                                                               
-- Source System       : SCP                                                                                                                                    
-- Destination System  : FP SDB                                                                                                                                  
-- Source Table        : LGCE_SCMPROD.DBO.SCP_ANL_PRODUCTION_PLAN_TARGET
-- Destination Table   : FP_WEEKLY_DEMAND_PRODUCT_H                                                                                                              
--                                                                                                                                                               
-- Create Date         : 2020.11.25
-- Update Date		   : 2022.07.22 1.2 KIMCD
--
-- Author              : KIMCD
-- Version             : 2020-11-25 1.0 KIMCD 최초 개발. SCP에서 확정한 긴급 수요를 FP 최신 SCP Target에 추가
--                       2022-04-13 1.1 kimcd 기존 SCP Plan ID 조회 조건 정리. Division과 Shop Group만 남김
--                       2022-07-22 1.2 kimcd ISUSU CMA Assy 수요 수용하도록 Hard Coding
-- ================================================================================================

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON
                                                                                                                                                                 
	-- LOG 용 변수 설정                                                                                                                                               
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_SCP_PRODTARGET_UPDATE_R'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	   = 0
	DECLARE @sysdate     DATETIME      = GETDATE()

	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)

	-- ================================================
    -- Declare start
	-- ================================================
	DECLARE @TARGET_ID   NVARCHAR(300)
	DECLARE @COMPANY_ID  NVARCHAR(30)
    DECLARE @DIVISION_ID NVARCHAR(30)
	DECLARE @SITE_ID     NVARCHAR(30)
    DECLARE @PLANT_ID    NVARCHAR(30)
    DECLARE @OPERATION_ID NVARCHAR(30)
    DECLARE @SHOP_GROUP_ID NVARCHAR(1)
    DECLARE @SCP_PLAN_ID NVARCHAR(30)
	DECLARE @SCP_TARGET_ID NVARCHAR(150)
	DECLARE @ITEM_ID     NVARCHAR(150)
    DECLARE @MFG_WEEK    NVARCHAR(10)
    DECLARE @MFG_DATE    NVARCHAR(8)
    DECLARE @MFG_QTY     NUMERIC(20,10)
    DECLARE @PRODUCTION_TYPE NVARCHAR(30)
    DECLARE @LINE_ID     NVARCHAR(30)
    DECLARE @MARKET      NVARCHAR(10)
	DECLARE @CONFIRM_DATE DATETIME

	DECLARE CUR_TARGET CURSOR FOR
		SELECT    PT.TARGET_ID
				, PT.COMPANY_ID
    			, PT.DIVISION_ID
				, PT.SITE_ID
    			, PT.PLANT_ID					
    			, PT.OPERATION_ID
    			, PT.SHOP_GROUP_ID                           
    			, ( SELECT TOP 1 W.SCP_PLAN_ID
					FROM   [FP_WEEKLY_DEMAND_PRODUCT_H] W (NOLOCK)
					WHERE  1=1
					--AND    W.COMPANY_ID    = PT.COMPANY_ID
					AND    W.DIVISION_ID   = PT.DIVISION_ID  -- 2022-04-13 kimcd 기존 SCP Plan ID 조회 조건 정리. Division과 Shop Group만 남김
					--AND    W.SITE_ID       = PT.SITE_ID
					--AND    W.PLANT_ID      = PT.PLANT_ID
					AND    W.SHOP_GROUP_ID = PT.SHOP_GROUP_ID
					ORDER  BY W.SCP_PLAN_ID DESC )	AS SCP_PLAN_ID
				, 'EMC^' + PT.DIVISION_ID +'^'+PT.PLANT_SCM_SITE_ID+'^'+PT.YYYYMMDD+'^'+PT.ITEM_ID+'^'+PT.LINE_ID+'^'+PT.OPERATION_ID+'^'+PT.PRODUCTION_TYPE+'^'+PT.MARKET AS SCP_TARGET_ID
				, PT.ITEM_ID
    			, PT.MFG_WEEK
    			, PT.YYYYMMDD -- 2019-11-26 kimcd 일자 group by 조건에서 제외 주 기준으로 정보 형성
    			, PT.QTY	AS MFG_QTY
    			, PT.PRODUCTION_TYPE
    			, PT.LINE_ID
    			, PT.MARKET
				, PT.CONFIRM_DATE
    	FROM   (SELECT    PT.PLANT_SCM_SITE_ID
						, PT.TARGET_ID
						, P.COMPANY_ID
    					, P.DIVISION_ID
    					, P.SITE_ID
    					, P.PLANT_ID
						, PT.OPERATION_ID
    					, PT.ITEM_ID
    					, PT.MFG_WEEK
    					, CONVERT(NVARCHAR(8), PT.PROD_DATE, 112) AS YYYYMMDD
    					, PT.QTY
    					, PT.LINE_ID
    					, ( SELECT CASE WHEN O.OPERATION_GROUP_ID IN ('B','M') THEN 'P' ELSE O.OPERATION_GROUP_ID END -- 2022-07-22 kimcd M도 P로 전환되도록 추가
							FROM   SCM_OPERATION_M O WITH(NOLOCK)
							WHERE  O.COMPANY_ID   = P.COMPANY_ID
							AND    O.DIVISION_ID  = P.DIVISION_ID
							AND    O.SITE_ID      = P.SITE_ID
							AND    O.OPERATION_ID = PT.OPERATION_ID)	AS SHOP_GROUP_ID
						, ISNULL( ( SELECT TOP 1 W.ATTRIBUTE2
									FROM   [DBO].[SCM_SYS_LOOKUP_VALUE] W WITH(NOLOCK)
									WHERE  W.LOOKUP_TYPE_CODE = 'SCP_DEMAND_TYPE_MAPPING'
									AND    W.ACTIVE_FLAG      = 'Y'
									AND    W.SEGMENT1         = PT.ORDER_TYPE
									AND    W.SEGMENT2         = PT.PLANT_ID)
								, 'MASS')		AS PRODUCTION_TYPE
						, PT.MARKET
						, PT.CONFIRM_DATE
				FROM      ( SELECT (SELECT TOP 1 L.PLANT_ID
									FROM   SCM_LINE_M L (NOLOCK)
									WHERE  L.LINE_ID      = PT.LINE_ID
									AND    L.OPERATION_ID = PT.OPERATION_ID ) AS PLANT_ID
									, PLANT_SCM_SITE_ID
							        , TARGET_ID
									, PROD_DATE
									, ITEM_ID
									, LINE_ID
									, OPERATION_ID
									, ORDER_TYPE
									, SUBSTRING(MARKET,1,1) AS MARKET
									, QTY
									, ( SELECT TOP 1 WEEK
							    		FROM   [DBO].SCM_SYS_CALENDAR_M C WITH(NOLOCK)
							    		WHERE  C.DATE_ID = PT.PROD_DATE )   AS MFG_WEEK
									, CONFIRM_DATE
    						FROM  LGCE_SCMDEV.DBO.SCP_ANL_PRODUCTION_PLAN_TARGET  PT
							WHERE CONFIRM_YN = 'Y'
							AND   TARGET_YN  = 'N' ) PT
				   		, [SCM_PLANT_M] P
				WHERE P.PLANT_ID = PT.PLANT_ID ) PT
		ORDER BY PT.CONFIRM_DATE, PT.TARGET_ID
	-- ================================================
    -- Declare end
	-- ================================================

	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

	BEGIN TRY
		-- ================================================
		-- 로직 추가 start
		-- ================================================
		OPEN CUR_TARGET
		FETCH NEXT FROM CUR_TARGET INTO   @TARGET_ID
										, @COMPANY_ID
										, @DIVISION_ID
										, @SITE_ID
										, @PLANT_ID
										, @OPERATION_ID
										, @SHOP_GROUP_ID
										, @SCP_PLAN_ID
										, @SCP_TARGET_ID
										, @ITEM_ID
										, @MFG_WEEK
										, @MFG_DATE
										, @MFG_QTY
										, @PRODUCTION_TYPE
										, @LINE_ID
										, @MARKET
										, @CONFIRM_DATE
		WHILE @@FETCH_STATUS = 0
		BEGIN
			MERGE INTO [FP_WEEKLY_DEMAND_PRODUCT_H] A
			USING ( SELECT    @COMPANY_ID      AS COMPANY_ID
							, @DIVISION_ID     AS DIVISION_ID
							, @SITE_ID         AS SITE_ID
							, @PLANT_ID        AS PLANT_ID
							, @OPERATION_ID    AS OPERATION_ID
							, @SHOP_GROUP_ID   AS SHOP_GROUP_ID
							, @SCP_PLAN_ID     AS SCP_PLAN_ID
							, @SCP_TARGET_ID   AS SCP_TARGET_ID
							, @ITEM_ID         AS ITEM_ID
							, @MFG_WEEK        AS MFG_WEEK
							, @MFG_DATE        AS MFG_DATE
							, @MFG_QTY         AS MFG_QTY
							, @PRODUCTION_TYPE AS PRODUCTION_TYPE
							, @LINE_ID         AS LINE_ID
							, @MARKET          AS MARKET ) B
			 ON (	  A.[COMPANY_ID]    = B.[COMPANY_ID]
				  AND A.[DIVISION_ID]   = B.[DIVISION_ID]
				  AND A.[SITE_ID]       = B.[SITE_ID]
				  AND A.[PLANT_ID]      = B.[PLANT_ID]
				  AND A.[SHOP_GROUP_ID] = B.[SHOP_GROUP_ID]
				  AND A.[SCP_PLAN_ID]   = B.[SCP_PLAN_ID]
				  AND A.[SCP_TARGET_ID] = B.[SCP_TARGET_ID]
				  AND A.[MARKET]        = B.[MARKET]
			     )
			WHEN MATCHED THEN
				UPDATE SET  [MFG_QTY]     = B.[MFG_QTY]
						   ,[DEMAND_TYPE] = 'EMERGENCY'
						   ,[UPDATE_ID]   = @v_proc_name
						   ,[UPDATE_TIME] = GETDATE()
			WHEN NOT MATCHED THEN
				INSERT ( COMPANY_ID
						,DIVISION_ID
						,SITE_ID
						,PLANT_ID
						,OPERATION_ID
						,SHOP_GROUP_ID
						,SCP_PLAN_ID
						,SCP_TARGET_ID
						,ITEM_ID
						,MFG_WEEK
						,MFG_DATE
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
						,UPDATE_TIME )
				VALUES ( B.[COMPANY_ID]
						,B.[DIVISION_ID]
						,B.[SITE_ID]
						,B.[PLANT_ID]
						,B.[OPERATION_ID]
						,B.[SHOP_GROUP_ID]
						,B.[SCP_PLAN_ID]
						,B.[SCP_TARGET_ID]
						,B.[ITEM_ID]
						,B.[MFG_WEEK]
						,B.[MFG_DATE]
						,B.[MFG_QTY]
						,NULL  -- CHG_QTY
						,B.[PRODUCTION_TYPE]
						,NULL  -- SAMPLE_FROM_DATE
						,NULL  -- SAMPLE_TO_DATE
						,B.[LINE_ID]
						,NULL  -- PRIORITY
						,NULL  -- PERIOD_TYPE
						,NULL  -- CONFIRM_TYPE
						,'EMERGENCY'  -- DEMAND_TYPE
						,B.[MARKET]
						,@v_proc_name
						,GETDATE()
						,@v_proc_name
						,GETDATE()	);

			SET @v_count = @v_count + 1

			UPDATE LGCE_SCMDEV.DBO.SCP_ANL_PRODUCTION_PLAN_TARGET
			SET  TARGET_YN = 'Y', TARGET_DATE = GETDATE(), ATTRIBUTE1 = @SCP_PLAN_ID
			WHERE TARGET_ID = @TARGET_ID

			FETCH NEXT FROM CUR_TARGET INTO   @TARGET_ID
											, @COMPANY_ID
											, @DIVISION_ID
											, @SITE_ID
											, @PLANT_ID
											, @OPERATION_ID
											, @SHOP_GROUP_ID
											, @SCP_PLAN_ID
											, @SCP_TARGET_ID
											, @ITEM_ID
											, @MFG_WEEK
											, @MFG_DATE
											, @MFG_QTY
											, @PRODUCTION_TYPE
											, @LINE_ID
											, @MARKET
											, @CONFIRM_DATE
		END  -- WHILE @@FETCH_STATUS = 0  CUR_TARGET
				
		CLOSE CUR_TARGET;
		DEALLOCATE CUR_TARGET;   -- 메모리 해제                                         
		-- ================================================                                                                                                      
		-- 로직 추가 end                                                                                                                                             
		-- ================================================                                                                                                      
                    
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'END', @v_count, @v_temp1, '############### End of procedure ###############', NULL, @sysdate                                                                                                                                             
		
		                                                                                                                                                         
	END TRY                                                                                                                                                      
                                                                                                                                                                 
	BEGIN CATCH                                                                                                                                                  
                                                                                                                                                                 
	    ROLLBACK TRAN                                                                                                                                             
		-- 에러나도 로그는 인서트                                                                                                                                          
		SET @v_descr = ERROR_MESSAGE()                                                                                                                           
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate                                                                    
                                                                                                                                                                 
	END CATCH                                                                                                                                                    
                                                                                                                                                                 
END                                                                                                                                                              
