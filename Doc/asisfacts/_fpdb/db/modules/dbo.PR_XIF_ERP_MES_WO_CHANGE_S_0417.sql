CREATE PROCEDURE [dbo].[PR_XIF_ERP_MES_WO_CHANGE_S_0417]

-- ================================================================================================
-- Program ID          : 
-- Program Name        : PR_XIF_ERP_MES_WO_CHANGE_S
-- Param               :
-- Batch Period        : 1 Day
-- Description         :
--
-- Source System       : FP SDB
-- Destination System  : INF DEV
-- Source Table        : FP_PRODUCTION_PLAN_EQUIPMENT_CHANGE_R
-- Destination Table   : XIF_ERP_PRODUCTION_PLAN_R, XIF_MES_WO_S
--
-- Create(Update) Date : 2016.09.08
-- Author              : 김 석
-- Version             : 1.0
--                       2.0 2017-04-09 kimcd. update work order result to mes work order master table.
--                       3.0 2017-04-10 kimcd. add session_id parameter.
-- ================================================================================================

-- ERP요청 SEQNO
--@P_FP_PLAN_ID NVARCHAR(50) = NULL
    @P_SESSION_ID  NVARCHAR(30)
AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_ERP_MES_WO_CHANGE_S'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	   = 0
	DECLARE @sysdate     DATETIME      = GETDATE()

   
  DECLARE @v_table_name     nvarchar(100)


	DECLARE @ROWCOUNT    INTEGER

	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)

	-- ================================================
    -- Declare start
	-- ================================================
	DECLARE @IFSEQNO     NVARCHAR(50)


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

		-- ERP 수신 IFSEQNO 형식과 맞춤
		SET @IFSEQNO = REPLACE(REPLACE(REPLACE(CONVERT(NVARCHAR(19),GETDATE(),120),'-',''),':',''),' ','')

		/*
		DELETE FROM [LGCE_INF].[dbo].[XIF_ERP_PRODUCTION_PLAN_S]
		 WHERE FP_PLAN_ID = ISNULL(@P_FP_PLAN_ID,'0')
		;
		*/

		UPDATE [dbo].[FP_PRODUCTION_PLAN_EQUIPMENT_CHANGE_R]
		   SET IF_FLAG = 'P'
	     WHERE IF_FLAG = 'N'
		 AND   SESSION_ID = @P_SESSION_ID -- kimcd add parameter 2017-04-10
		;

		INSERT INTO [dbo].[SY_XIF_ERP_PRODUCTION_PLAN_S]
				   ([IFSEQNO]
				   ,[SEQ]
				   ,[FP_PLAN_ID]
				   ,[PLANT_ID]
				   ,[FACTORY_ID]
				   ,[LINE_ID]
				   ,[OPERATION_ID]
				   ,[BOM_VERSION_ID]
				   ,[WORK_CENTER_ID]
				   ,[ITEM_ID]
				   ,[DEMAND_ID]
				   ,[WORK_ORDER_ID]
				   ,[ORDER_TYPE]
				   ,[PLAN_DATE]
				   ,[START_TIME]
				   ,[END_TIME]
				   ,[PLAN_IN_QTY]
				   ,[PLAN_QTY]
				   ,[FIX_TYPE]
				   ,[TRANSFER_FLAG]
				   ,[TRANSFER_DATE]
				   ,[CREATE_USER_ID]
				   ,[CREATE_DATE]
				   ,[MODIFY_USER_ID]
				   ,[MODIFY_DATE]
				   ,[LANE_QTY]
				   ,[BATCH_ORDER_ID]
				   ,[SLITTER_PLANT]
				   ,[ATTRIBUTE1]
				   ,[ATTRIBUTE2]
				   ,[ATTRIBUTE3]
				   ,[ATTRIBUTE4]
				   ,[ATTRIBUTE5]
				   ,[ATTRIBUTE6]
				   ,[ATTRIBUTE7]
				   ,[ATTRIBUTE8]
				   ,[ATTRIBUTE9]
				   ,[ATTRIBUTE10])
			SELECT @IFSEQNO
			--SELECT ''  
				   ,ROW_NUMBER() OVER( ORDER BY A.[FP_PLAN_ID], A.[PLANT_ID], A.[FACTORY_ID], MAX(A.[LINE_ID]), A.[OPERATION_ID], /*A.[WORK_CENTER_ID],*/ A.[ITEM_ID], A.[WORK_ORDER_ID] ) AS SEQ -- modify by kimcd 2016-12-02
				   --,A.[FP_PLAN_ID]
				   ,CONCAT( SUBSTRING(FP_PLAN_ID,0,PATINDEX('%-%',FP_PLAN_ID)) ,'-',CONVERT(VARCHAR, GETDATE(),112),'-XX') -- [FP_PLAN_ID]	
				   ,A.[PLANT_ID]
				   ,A.[FACTORY_ID]
				   ,SUBSTRING(MAX(A.LINE_ID), 1, CHARINDEX('^', MAX(A.LINE_ID))-1)  AS LINE_ID  -- A.[LINE_ID]  modify by kimcd 2016-12-02
				   ,A.[OPERATION_ID]
				   ,A.[BOM_VERSION_ID]	
				   ,SUBSTRING(MAX(A.LINE_ID), CHARINDEX('^', MAX(A.LINE_ID))+1, LEN(MAX(A.LINE_ID)))  AS WORK_CENTER_ID -- A.[WORK_CENTER_ID]	 modify by kimcd 2016-12-02
				   ,A.[ITEM_ID]
				   ,MAX( A.[DEMAND_ID]) AS DEMAND_ID -- modify by kimcd 2016-12-02
				   ,A.[WORK_ORDER_ID]
				   ,MAX(A.ORDER_TYPE) AS ORDER_TYPE
				   ,MAX(A.PLAN_DATE) AS PLAN_DATE
				   ,MAX(A.START_TIME) AS START_TIME
				   ,MAX(A.END_TIME) AS END_TIME
				   ,SUM(A.PLAN_IN_QTY) AS PLAN_IN_QTY
				   ,SUM(A.PLAN_QTY) AS PLAN_QTY
				   ,MAX(A.FIX_TYPE) AS FIX_TYPE
					,'N' AS TRANSFER_FLAG                                                                                                                          
					,NULL AS TRANSFER_DATE                                                                                                                         
					,'PR_XIF_ERP_MES_WO_CHANGE_S' AS CREATE_USER_ID                                                                                               
					,GETDATE() AS CREATE_DATE                                                                                                                    
					,'PR_XIF_ERP_MES_WO_CHANGE_S' AS MODIFY_USER_ID                                                                                                
					,GETDATE() AS MODIFY_DATE
					,SUM(A.LANE_QTY) AS LANE_QTY
					,MAX(A.BATCH_ORDER_ID) AS BATCH_ORDER_ID
					,MAX(A.SLIT_PLANT_ID) AS SLIT_PLANT_ID
					,NULL                                                                                                 
					,NULL                                                                                                 
					,NULL                                                                                                 
					,NULL                                                                                                 
					,NULL                                                                                                 
					,NULL                                                                                                 
					,NULL                                                                                                 
					,NULL                                                                                                 
					,NULL                                                                                                 
					,NULL
			FROM (
					SELECT  A.[FP_PLAN_ID]                                                                                                                
						   ,A.[PLANT_ID]                                                                                                                  
						   ,A.[FACTORY_ID]                                                                                                                
						   --,A.[LINE_ID]     
						   ,CASE WHEN A.INSTANCE_ID = 'KR_PACK' THEN A.LINE_ID + '^' + A.WORK_CENTER_ID
						         WHEN B.ATTRIBUTE1 IS NOT NULL THEN
								 (SELECT TOP 1 ISNULL(C.MES_LINE_ID,'-') + '^' + ISNULL(C.WORK_CENTER_ID,'-')  FROM [dbo].[SCM_EQUIPMENT_M] C
								   WHERE C.COMPANY_ID = B.ATTRIBUTE1
									 AND C.DIVISION_ID = B.ATTRIBUTE2
									 AND C.SITE_ID = A.SITE_ID
									 AND C.PLANT_ID = B.ATTRIBUTE3
									 AND C.EQUIPMENT_ID = A.EQUIPMENT_ID
									 AND C.OPERATION_ID = A.OPERATION_ID
								 )
						    ELSE (SELECT TOP 1 ISNULL(C.MES_LINE_ID,'-') + '^' + ISNULL(C.WORK_CENTER_ID,'-')  FROM [dbo].[SCM_EQUIPMENT_M] C
								   WHERE C.COMPANY_ID = A.COMPANY_ID
									 AND C.DIVISION_ID = A.DIVISION_ID
									 AND C.SITE_ID = A.SITE_ID
									 AND C.PLANT_ID = A.PLANT_ID
									 AND C.EQUIPMENT_ID = A.EQUIPMENT_ID
									 AND C.OPERATION_ID = A.OPERATION_ID
								 )
							 END AS LINE_ID            -- modify by kimcd 2016-12-02                                                                                                  
						   --,SUBSTRING(A.WORK_CENTER_ID, 1, 5) AS LINE_ID
						   ,A.EQUIPMENT_ID
						   ,A.[OPERATION_ID]                                                                                                              
						   ,A.[BOM_VERSION_ID]                                                                                   
						   --,A.[WORK_CENTER_ID]       blocked by kimcd 2016-12-02                                                                                                     
						   ,A.[ITEM_ID]                                                                                                                   
						   ,A.[DEMAND_ID]                                                                                                                 
						   ,A.[WORK_ORDER_ID]                                                                                                             
						   ,ISNULL((SELECT TOP 1 PRODUCTION_TYPE AS ORDER_TYPE                                                                            
							 FROM [DBO].[FP_WEEKLY_DEMAND_PRODUCT_H]                                                                                     
							WHERE SCP_TARGET_ID = A.DEMAND_ID                                                                                             
						   ), 'MASS') AS ORDER_TYPE                                                                                                      
						   ,REPLACE(REPLACE(REPLACE(CONVERT(NVARCHAR(19),A.[PLAN_DATE],120),'-',''),':',''),' ','') [PLAN_DATE]                            
						   ,REPLACE(REPLACE(REPLACE(CONVERT(NVARCHAR(19),A.[START_TIME],120),'-',''),':',''),' ','') [START_TIME]                          
						   ,REPLACE(REPLACE(REPLACE(CONVERT(NVARCHAR(19),A.[END_TIME],120),'-',''),':',''),' ','') [END_TIME]                              
						   ,A.[PLAN_IN_QTY]                                                                                                               
						   ,A.[PLAN_QTY]                                                                                                                  
						   ,CASE WHEN A.FIX_TYPE = 'F' THEN 'Y'
						         WHEN A.FIX_TYPE = 'N' THEN 'Y'
								 WHEN A.FIX_TYPE = 'P' THEN '-'
							ELSE A.FIX_TYPE
							 END AS FIX_TYPE
						   ,A.[LANE_QTY]                                                                                                                  
						   ,A.[BATCH_ORDER_ID]                                                                                                            
						   ,A.[SLIT_PLANT_ID]                                                                                                                     
					  FROM [dbo].[FP_PRODUCTION_PLAN_EQUIPMENT_CHANGE_R] A	WITH(NOLOCK)				       
					       LEFT OUTER JOIN [DBO].[SCM_SYS_LOOKUP_VALUE]  B WITH(NOLOCK)
						   ON  B.LOOKUP_TYPE_CODE = 'BOM_ADD_FOR_RES_SHARE'
						   AND B.SEGMENT1         = A.PLANT_ID
						   AND B.ACTIVE_FLAG      = 'Y'
					 WHERE A.ORDER_TYPE IN ('W')
					   AND A.IF_FLAG = 'P'
					   AND A.SESSION_ID = @P_SESSION_ID -- kimcd add parameter 2017-04-10
					   --AND A.FP_PLAN_ID LIKE '%99'
					   --AND A.FP_PLAN_ID = ISNULL(@P_FP_PLAN_ID,'0')
				) A
			GROUP BY A.[FP_PLAN_ID]	
					,A.[PLANT_ID]
					,A.[FACTORY_ID]
					-- ,A.[LINE_ID]          blocked by kimcd 2016-12-02
					,A.[OPERATION_ID]
					,A.[BOM_VERSION_ID]	
					-- ,A.[WORK_CENTER_ID]	 blocked by kimcd 2016-12-02
					,A.[ITEM_ID]
					-- ,A.[DEMAND_ID]        blocked by kimcd 2016-12-02
					,A.[WORK_ORDER_ID]
			 ;


			/*
			DELETE FROM [LGCE_INF].[dbo].[XIF_MES_WO_S]
			 WHERE PLAN_ID = ISNULL(@P_FP_PLAN_ID,'0')
			;
			*/


			INSERT INTO [dbo].[SY_XIF_MES_WO_S]                                                                                                                                                                                                           
					     ( [IF_SEQ]                                                                                                                                                                                                                                  
				        ,[IF_TYPE]                                                                                                                                                                                                                                   
				        ,[IF_ID]                                                                                                                                                                                                                                     
				        ,[IF_INS_DATE]                                                                                                                                                                                                                               
				        ,[IF_FLAG]                                                                                                                                                                                                                                   
				        ,[IF_SND_DATE]                                                                                                                                                                                                                               
				        ,[RSLT_IF_SEQ]                                                                                                                                                                                                                               
				        ,[RSLT_PROC_FLAG]                                                                                                                                                                                                                            
				        ,[RSLT_PROC_MSG]                                                                                                                                                                                                                             
				        ,[PLAN_ID]                                                                                                                                                                                                                                   
				        ,[PLANT_ID]                                                                                                                                                                                                                                  
				        ,[BUILNO]                                                                                                                                                                                                                                    
				        ,[LINE_ID]                                                                                                                                                                                                                                   
				        ,[OPERATION_ID]                                                                                                                                                                                                                              
				        ,[EQUIPMENT_ID]                                                                                                                                                                                                                              
				        ,[ITEM_ID]                                                                                                                                                                                                                                   
				        ,[DEMAND_ID]                                                                                                                                                                                                                                 
				        ,[WO]                                                                                                                                                                                                                                        
				        ,[WO_TYPE]                                                                                                                                                                                                                                   
				        ,[WO_DETAIL]                                                                                                                                                                                                                                 
				        ,[PLAN_DATE]                                                                                                                                                                                                                                 
				        ,[START_TIME]                                                                                                                                                                                                                                
				        ,[END_TIME]                                                                                                                                                                                                                                  
				        ,[IN_QTY]                                                                                                                                                                                                                                    
				        ,[OUT_QTY]                                                                                                                                                                                                                                   
				        ,[IS_RELEASE]                                                                                                                                                                                                                                
				        ,[CREATE_PSN_ID]                                                                                                                                                                                                                             
				        ,[CREATE_DATE]                                                                                                                                                                                                                               
				        ,[UPDATE_PSN_ID]                                                                                                                                                                                                                             
				        ,[UPDATE_DATE]                                                                                                                                                                                                                               
				        ,[LANE_QTY]                                                                                                                                                                                                                                  
				        ,[UNIT]                                                                                                                                                                                                                                      
				        ,[ORDER_TYPE]    
					    ,[BATCH_ORDER_ID]
					    ,[SLITTER_PLANT]						                                                                                                                                                                                                                            
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
							                                                                                                                                                                                                                                         
						SELECT 'OFP0' + SUBSTRING(CONVERT(NVARCHAR(12), GETDATE(), 112), 3,6) + REPLICATE('0', 10 - LEN(NEXT VALUE FOR [LGCE_INFDEV].[dbo].[XIF_MES_SEND_SEQ])) + CAST( NEXT VALUE FOR [LGCE_INFDEV].[dbo].[XIF_MES_SEND_SEQ] AS NVARCHAR)   -- IF_SEQ
						--SELECT ''
							   ,'S'   -- IF_TYPE                                                                                                                                                                                                                     
							   ,'OFP0'+'_'+ISNULL(( SELECT ISNULL(MES_SOURCE_GROUP,'') FROM SCM_FACTORY_M F WHERE F.FACTORY_ID = SOURCES.FACTORY_ID ),'') +'_'+'FP_WO'                                                                                                          
							   --,@if_id_code  -- IF_ID                                                                                                                                                                                                              
							   ,GETDATE()   -- IF_INS_DATE                                                                                                                                                                                                           
							   ,'N'  -- IF_FLAG                                                                                                                                                                                                                      
							   ,NULL  -- IF_SND_DATE                                                                                                                                                                                                                 
							   ,NULL  -- RSLT_IF_SEQ                                                                                                                                                                                                                 
							   ,NULL  -- RSLT_PROC_FLAG                                                                                                                                                                                                              
							   ,NULL  -- RSLT_PROC_MSG                                                                                                                                                                                                               
							   --,FP_PLAN_ID  -- PLAN_ID
							   ,CONCAT( SUBSTRING(FP_PLAN_ID,0,PATINDEX('%-%',FP_PLAN_ID)) ,'-',CONVERT(VARCHAR, GETDATE(),112),'-XX') -- [FP_PLAN_ID]
							   ,SOURCES.PLANT_ID  -- PLANT_ID                                                                                                                                                                                                                
							   ,FACTORY_ID  -- BUILNO                                                                                                                                                                                                                
							   --,LINE_ID  -- LINE_ID   
							   ,CASE WHEN SOURCES.INSTANCE_ID = 'KR_PACK' THEN SOURCES.LINE_ID
						         WHEN B.ATTRIBUTE1 IS NOT NULL THEN
								 (SELECT TOP 1 C.MES_LINE_ID FROM [dbo].[SCM_EQUIPMENT_M] C
								   WHERE C.COMPANY_ID = B.ATTRIBUTE1
									 AND C.DIVISION_ID = B.ATTRIBUTE2
									 AND C.SITE_ID = SOURCES.SITE_ID
									 AND C.PLANT_ID = B.ATTRIBUTE3
									 AND C.EQUIPMENT_ID = SOURCES.EQUIPMENT_ID
									 AND C.OPERATION_ID = SOURCES.OPERATION_ID
								 )
								ELSE (SELECT C.MES_LINE_ID  FROM [dbo].[SCM_EQUIPMENT_M] C
									   WHERE C.COMPANY_ID = SOURCES.COMPANY_ID
										 AND C.DIVISION_ID = SOURCES.DIVISION_ID
										 AND C.SITE_ID = SOURCES.SITE_ID
										 AND C.PLANT_ID = SOURCES.PLANT_ID
										 AND C.EQUIPMENT_ID = SOURCES.EQUIPMENT_ID
										 AND C.OPERATION_ID = SOURCES.OPERATION_ID)
								 END AS MES_LINE_ID						                                                                                                                                                                                                                  
							   ,OPERATION_ID  -- OPERATION_ID                                                                                                                                                                                                        
							   ,EQUIPMENT_ID  -- EQUIPMENT_ID                                                                                                                                                                                                        
							   ,ITEM_ID  -- ITEM_ID                                                                                                                                                                                                                  
							   ,DEMAND_ID  -- DEMAND_ID                                                                                                                                                                                                              
							   ,WORK_ORDER_ID  -- WO                                                                                                                                                                                                                 
							   ,CASE WHEN ORDER_TYPE = 'W' THEN 'WO'                                                                                                                                                                                                 
							         WHEN ORDER_TYPE = 'M' THEN 'MO'                                                                                                                                                                                                 
						        END  -- WO_TYPE                                                                                                                                                                                                                      
							   ,WORK_ORDER_SPL_ID  -- WO_DETAIL    
							   ,CONVERT(NVARCHAR(50), PLAN_DATE, 120) AS PLAN_DATE
							   ,CONVERT(NVARCHAR(50), START_TIME, 120) AS START_TIME
							   ,CONVERT(NVARCHAR(50), END_TIME, 120) AS END_TIME                                                                                                                                                                                                           
							   ,PLAN_IN_QTY + (SELECT ISNULL(SUM(WIPQTY2_IN), 0) FROM [dbo].[SCM_MES_WIP_HISTORY_H]
							                    WHERE WOID       = SOURCES.WORK_ORDER_ID
												  AND WO_DETL_ID = SOURCES.WORK_ORDER_SPL_ID
												  AND PRODID     = SOURCES.ITEM_ID) -- IN_QTY                                                                                                                                                                                                               
							   ,PLAN_QTY + (SELECT ISNULL(SUM(WIPQTY2_ED),0) FROM [dbo].[SCM_MES_WIP_HISTORY_H]
							                 WHERE WOID       = SOURCES.WORK_ORDER_ID
											   AND WO_DETL_ID = SOURCES.WORK_ORDER_SPL_ID
											   AND PRODID     = SOURCES.ITEM_ID) -- OUT_QTY                                                                                                                                                                                                                 
							   ,CASE WHEN FIX_TYPE = 'F' THEN 'Y'
									 WHEN FIX_TYPE = 'N' THEN 'Y'
									 WHEN FIX_TYPE = 'P' THEN '-'
								ELSE FIX_TYPE 
								 END AS FIX_TYPE                                                                                                                                                                                                            
							   ,'PR_XIF_ERP_MES_WO_CHANGE_S'  -- CREATE_PSN_ID                                                                                                                                                                                                  
							   ,GETDATE()  -- CREATE_DATE                                                                                                                                                                                                            
							   ,'PR_XIF_ERP_MES_WO_CHANGE_S'  -- UPDATE_PSN_ID                                                                                                                                                                                                  
							   ,GETDATE()  -- UPDATE_DATE                                                                                                                                                                                                            
							   ,LANE_QTY  -- LANE_QTY                                                                                                                                                                                                                
							   ,(SELECT DISTINCT I.ITEM_UOM FROM [DBO].[SCM_ITEM_M] I WHERE I.ITEM_ID = SOURCES.ITEM_ID AND I.SITE_ID = SOURCES.SITE_ID )  -- UNIT                                                                                                   
							   ,PRODUCTION_TYPE  -- ORDER_TYPE
							   ,[BATCH_ORDER_ID]
							   ,[SLIT_PLANT_ID]
							   ,SOURCES.BATCH_SUM_QTY  -- ATTR_01 BATCH ORDER 기준 BATCH 수                                                                                                                                                                                                            
							   ,SOURCES.BATCH_QTY      -- ATTR_02 WORK ORDER 기준 W/O별 BATCH 수                                                                                                                                                                                                                    
							   ,CASE WHEN SOURCES.BATCH_ORDER_ID != '-' THEN 
							         SUM(PLAN_IN_QTY) OVER (PARTITION BY SOURCES.BATCH_ORDER_ID)
							    END  -- ATTR_03 BATCH ORDER 별 계획 수량의 합   
							   ,ISNULL(SOURCES.MARKET,'D')  -- ATTR_04  170208 Add                                                                                                                                                                                                                  
							   ,NULL  -- ATTR_05                                                                                                                                                                                                                     
							   ,NULL  -- ATTR_06                                                                                                                                                                                                                     
							   ,NULL  -- ATTR_07                                                                                                                                                                                                                     
							   ,NULL  -- ATTR_08                                                                                                                                                                                                                     
							   ,NULL  -- ATTR_09                                                                                                                                                                                                                     
							   ,NULL  -- ATTR_10                                                                                                                                                                                                                     
				 FROM [dbo].[FP_PRODUCTION_PLAN_EQUIPMENT_CHANGE_R] SOURCES WITH(NOLOCK)
					  LEFT OUTER JOIN [DBO].[SCM_SYS_LOOKUP_VALUE]  B WITH(NOLOCK)
						   ON  B.LOOKUP_TYPE_CODE = 'BOM_ADD_FOR_RES_SHARE'
						   AND B.SEGMENT1         = SOURCES.PLANT_ID
						   AND B.ACTIVE_FLAG      = 'Y'
				 --AND SOURCES.FP_PLAN_ID LIKE '%99'
			    --WHERE SOURCES.FP_PLAN_ID = ISNULL(@P_FP_PLAN_ID,'0')       
				WHERE SOURCES.IF_FLAG    = 'P'
				AND   SOURCES.SESSION_ID = @P_SESSION_ID -- kimcd add parameter 2017-04-10
		;

		-- WO에 LINE을 변경하면 기존 MES 송신 정보에 해당 WO에 대해서 BUILNO, LINE 정보를 UPDATE 함.
		-- MES OPEN WO 생성시에도 변경되도록 적용하기 위함.
		UPDATE [SY_XIF_MES_WO_S]
		   SET [LINE_ID] = ZZ.LINE_ID
			  ,[BUILNO]  = ZZ.BUILNO
			  ,[EQUIPMENT_ID] = ZZ.EQUIPMENT_ID
			  ,[ATTR_10] = 'WO_LINE_CHANGE'
		  FROM (
				SELECT ROW_NUMBER() OVER ( PARTITION BY A.WO_DETAIL, A.LINE_ID, B.LINE_ID  ORDER BY B.IF_SEQ DESC ) ROWNUMS
					  ,B.PLAN_ID, A.WO_DETAIL, A.LINE_ID, A.BUILNO, A.EQUIPMENT_ID
				  FROM [SY_XIF_MES_WO_S] A
					  ,[SY_XIF_MES_WO_S] B
					  ,[FP_PRODUCTION_PLAN_EQUIPMENT_CHANGE_R] C
				 WHERE A.WO_DETAIL = C.WORK_ORDER_SPL_ID
				   AND A.IF_FLAG = 'N'
				   AND A.[PLAN_ID] LIKE '%-XX'
				   AND C.IF_FLAG    = 'P'
				   AND C.SESSION_ID = @P_SESSION_ID -- kimcd add parameter  2017-04-10
				   AND A.WO_DETAIL = B.WO_DETAIL
				   AND B.PLAN_ID NOT LIKE '%XX'
			   ) ZZ
		  WHERE [SY_XIF_MES_WO_S].PLAN_ID   = ZZ.PLAN_ID
			AND [SY_XIF_MES_WO_S].WO_DETAIL = ZZ.WO_DETAIL
			AND ZZ.ROWNUMS = 1
		;


        ---------------------------------------------------------------------------------------------------------------------------------
		-- kimcd 2017-04-09 add starrt - maintain mes work order master
			MERGE INTO DBO.FP_MES_PRODUCTION_PLAN_M A
			USING ( 
		        SELECT [INSTANCE_ID]
					  ,[FP_PLAN_ID]
					  ,[COMPANY_ID]
					  ,[DIVISION_ID]
					  ,[SITE_ID]
					  ,[PLANT_ID]
					  ,[FACTORY_ID]
					  ,[WORK_ORDER_SPL_ID]
					  ,[WORK_ORDER_ID]
					  ,[BATCH_ORDER_ID]
					  ,[BIN_ORDER_ID]
					  ,[ORDER_TYPE]
					  ,[SCP_TARGET_ID]
					  ,[DEMAND_ID]
					  ,[ITEM_ID]
					  ,[LANE_QTY]
					  ,[TOP_ITEM_ID]
					  ,[TOP_WORK_ORDER_ID]
					  ,[LINE_ID]
					  ,[OPERATION_ID]
					  ,[ELECTRODE_TYPE]
					  ,[WORK_CENTER_ID]
					  ,[EQUIPMENT_ID]
					  ,[PLAN_DATE]
					  ,[START_TIME]
					  ,[END_TIME]
					  ,[PLAN_QTY]
					  ,[PLAN_IN_QTY]
					  ,[ITEM_UOM]
					  ,[ROLL_IN_QTY]
					  ,[ROLL_OUT_QTY]
					  ,[JR_IN_QTY]
					  ,[JR_OUT_QTY]
					  ,[BATCH_QTY]
					  ,[BATCH_SUM_QTY]
					  ,[FIX_TYPE]
					  ,[PRODUCTION_TYPE]
					  ,[BOM_VERSION_ID]
					  ,[SLIT_PLANT_ID]
					  ,[MARKET]
				FROM   DBO.FP_PRODUCTION_PLAN_EQUIPMENT_CHANGE_R SOURCES WITH(NOLOCK)
			    WHERE  SOURCES.IF_FLAG    = 'P'
				AND    SESSION_ID         = @P_SESSION_ID -- kimcd add parameter
				                               ) B
			ON  (     A.[WORK_ORDER_SPL_ID] = B.[WORK_ORDER_SPL_ID]
			      AND A.[WORK_ORDER_ID]     = B.[WORK_ORDER_ID] )
			WHEN MATCHED THEN
			UPDATE SET A.[PLANT_ID]          = B.[PLANT_ID]         
					  ,A.[FACTORY_ID]        = B.[FACTORY_ID]       
					  ,A.[BATCH_ORDER_ID]    = B.[BATCH_ORDER_ID]   
					  ,A.[ORDER_TYPE]        = B.[ORDER_TYPE]       
					  ,A.[ITEM_ID]           = B.[ITEM_ID]          
					  ,A.[LANE_QTY]          = B.[LANE_QTY]         
					  ,A.[LINE_ID]           = B.[LINE_ID]          
					  ,A.[EQUIPMENT_ID]      = B.[EQUIPMENT_ID]     
					  ,A.[START_TIME]        = B.[START_TIME]       
					  ,A.[END_TIME]          = B.[END_TIME]         
					  ,A.[FIX_TYPE]          = B.[FIX_TYPE]         
					  ,A.[PRODUCTION_TYPE]   = B.[PRODUCTION_TYPE]  
					  ,A.[SLIT_PLANT_ID]     = B.[SLIT_PLANT_ID]    
					  ,A.[MARKET]            = B.[MARKET]           
					  ,A.[UPDATE_FP_PLAN_ID] = B.[FP_PLAN_ID]
					  ,A.[UPDATE_ID]         = 'WO_LINE_CHANGE'     
					  ,A.[UPDATE_TIME]       = GETDATE() 
			WHEN NOT MATCHED THEN
				INSERT ([INSTANCE_ID]
					  ,[COMPANY_ID]
					  ,[DIVISION_ID]
					  ,[SITE_ID]
					  ,[PLANT_ID]
					  ,[FACTORY_ID]
					  ,[WORK_ORDER_SPL_ID]
					  ,[WORK_ORDER_ID]
					  ,[BATCH_ORDER_ID]
					  ,[ORDER_TYPE]
					  ,[ITEM_ID]
					  ,[LANE_QTY]
					  ,[LINE_ID]
					  ,[OPERATION_ID]
					  ,[ELECTRODE_TYPE]
					  ,[EQUIPMENT_ID]
					  ,[START_TIME]
					  ,[END_TIME]
					  ,[PLAN_QTY]
					  ,[PLAN_IN_QTY]
					  ,[ROLL_IN_QTY]
					  ,[ROLL_OUT_QTY]
					  ,[JR_IN_QTY]
					  ,[JR_OUT_QTY]
					  ,[BATCH_QTY]
					  ,[BATCH_SUM_QTY]
					  ,[FIX_TYPE]
					  ,[PRODUCTION_TYPE]
					  ,[SLIT_PLANT_ID]
					  ,[MARKET]
					  ,[INSERT_FP_PLAN_ID]
					  ,[INSERT_ID]
					  ,[INSERT_TIME]
					  ,[UPDATE_FP_PLAN_ID]
					  ,[UPDATE_ID]
					  ,[UPDATE_TIME])
			VALUES(B.[INSTANCE_ID]
				  ,B.[COMPANY_ID]
				  ,B.[DIVISION_ID]
				  ,B.[SITE_ID]
				  ,B.[PLANT_ID]
				  ,B.[FACTORY_ID]
				  ,B.[WORK_ORDER_SPL_ID]
				  ,B.[WORK_ORDER_ID]
				  ,B.[BATCH_ORDER_ID]
				  ,B.[ORDER_TYPE]
				  ,B.[ITEM_ID]
				  ,B.[LANE_QTY]
				  ,B.[LINE_ID]
				  ,B.[OPERATION_ID]
				  ,B.[ELECTRODE_TYPE]
				  ,B.[EQUIPMENT_ID]
				  ,B.[START_TIME]
				  ,B.[END_TIME]
				  ,B.[PLAN_QTY]
				  ,B.[PLAN_IN_QTY]
				  ,B.[ROLL_IN_QTY]
				  ,B.[ROLL_OUT_QTY]
				  ,B.[JR_IN_QTY]
				  ,B.[JR_OUT_QTY]
				  ,B.[BATCH_QTY]
				  ,B.[BATCH_SUM_QTY]
				  ,B.[FIX_TYPE]
				  ,B.[PRODUCTION_TYPE]
				  ,B.[SLIT_PLANT_ID]
				  ,B.[MARKET]
				  ,B.[FP_PLAN_ID] -- [INSERT_FP_PLAN_ID]
				  ,'WO_LINE_CHANGE'
				  ,GETDATE()
				  ,B.[FP_PLAN_ID] -- [UPDATE_FP_PLAN_ID]
				  ,'WO_LINE_CHANGE'
				  ,GETDATE());
			-- add end kimcd 2017-04-09 manage mes work order master
		---------------------------------------------------------------------------------------------------------------------------------

		---------------------------------------------------------------------------------------------------------------------------------
		---------------------------------------------------------------------------------------------------------------------------------
		---------------------------------------------------------------------------------------------------------------------------------
		---------------------------------------------------------------------------------------------------------------------------------

    

    /*** fp_release_fix_plan_h UPDATE ***/
    -- FP_PRODUCTION_PLAN_EQUIPMENT_CHANGE_R 이용  Update
    BEGIN

    	EXEC PR_XIF_LOG @v_proc_name, NULL, 'Start', NULL, @v_temp1, 'fp_release_fix_plan_h update start', NULL, @sysdate
     
      SET @v_table_name = 'fp_release_fix_plan_h'

      update  fp_release_fix_plan_h
      set     fp_release_fix_plan_h.line_id      = b.line_id,
              fp_release_fix_plan_h.equipment_id = b.equipment_id
      --select  a.line_id, a.equipment_id, b.line_id, b.equipment_id
      from    fp_release_fix_plan_h a,
              (
                select 
                       instance_id, fp_plan_id, company_id, division_id, site_id, plant_id, factory_id,
                       work_order_spl_id, work_order_id, line_id, equipment_id
                from   FP_PRODUCTION_PLAN_EQUIPMENT_CHANGE_R
                --where  instance_id = 'KR_E_PRE'
                --and    fp_plan_id  = 'KR_E_PRE-20170407-98'
                ) b
      where  1=1
      and    a.instance_id         = b.instance_id
      --and    a.release_plan_id     = b.fp_plan_id
      and    a.work_order_id       = b.work_order_id


    	EXEC PR_XIF_LOG @v_proc_name, NULL, 'END', NULL, @v_temp1, 'fp_release_fix_plan_h update end', NULL, @sysdate

    END


--------------------------------------------------------------------------------------------


    /*** fp_release_full_plan_h UPDATE ***/
    -- FP_PRODUCTION_PLAN_EQUIPMENT_CHANGE_R 이용  Update
    BEGIN

     	EXEC PR_XIF_LOG @v_proc_name, NULL, 'Start', NULL, @v_temp1, 'fp_release_full_plan_h update start', NULL, @sysdate

      SET @v_table_name = 'fp_release_full_plan_h'

      update  fp_release_full_plan_h
      set     fp_release_full_plan_h.line_id      = b.line_id,
              fp_release_full_plan_h.equipment_id = b.equipment_id                  
      -- select  a.line_id, a.equipment_id, b.line_id, b.equipment_id
      from    fp_release_full_plan_h a,
              (
                select 
                       instance_id, fp_plan_id, company_id, division_id, site_id, plant_id, factory_id,
                       work_order_spl_id, work_order_id, line_id, equipment_id
                from   FP_PRODUCTION_PLAN_EQUIPMENT_CHANGE_R
                --where  instance_id = 'KR_E_PRE'
                --and    fp_plan_id  = 'KR_E_PRE-20170407-98'
                ) b
      where  1=1
      and    a.instance_id         = b.instance_id
      --and    a.release_plan_id     = b.fp_plan_id
      and    a.work_order_id       = b.work_order_id

    	EXEC PR_XIF_LOG @v_proc_name, NULL, 'END', NULL, @v_temp1, 'fp_release_full_plan_h update end', NULL, @sysdate


    END
    
--------------------------------------------------------------------------------------------


    /*** fp_production_plan_equipment_r UPDATE ***/
    -- FP_PRODUCTION_PLAN_EQUIPMENT_CHANGE_R 이용  Update
    BEGIN
     
    	EXEC PR_XIF_LOG @v_proc_name, NULL, 'Start', NULL, @v_temp1, 'fp_production_plan_equipment_r update start', NULL, @sysdate
     
      SET @v_table_name = 'fp_production_plan_equipment_r'

      update  fp_production_plan_equipment_r
      set     fp_production_plan_equipment_r.line_id      = b.line_id,
              fp_production_plan_equipment_r.equipment_id = b.equipment_id      
      --select  a.line_id, a.equipment_id, b.line_id, b.equipment_id
      from    fp_production_plan_equipment_r a,
              (
                select 
                       instance_id, fp_plan_id, company_id, division_id, site_id, plant_id, factory_id,
                       work_order_spl_id, work_order_id, line_id, equipment_id
                from   FP_PRODUCTION_PLAN_EQUIPMENT_CHANGE_R
                --where  instance_id = 'KR_E_PRE'
                --and    fp_plan_id  = 'KR_E_PRE-20170407-98'
                ) b
      where  1=1
      and    a.instance_id         = b.instance_id
      --and    a.fp_plan_id          = b.fp_plan_id
      and    a.work_order_id       = b.work_order_id


     	EXEC PR_XIF_LOG @v_proc_name, NULL, 'END', NULL, @v_temp1, 'fp_production_plan_equipment_r update end', NULL, @sysdate

    END

--------------------------------------------------------------------------------------------

    /*** fp_production_plan_r UPDATE ***/
    -- FP_PRODUCTION_PLAN_EQUIPMENT_CHANGE_R 이용  Update
    BEGIN

     	EXEC PR_XIF_LOG @v_proc_name, NULL, 'Start', NULL, @v_temp1, 'fp_production_plan_r update start', NULL, @sysdate

      SET @v_table_name = 'fp_production_plan_r'



      update  fp_production_plan_r
      set     fp_production_plan_r.line_id      = b.line_id
      --select  a.line_id, b.line_id
      from    fp_production_plan_r a,
              (
                select 
                       instance_id, fp_plan_id, company_id, division_id, site_id, plant_id, factory_id,
                       work_order_spl_id, work_order_id, line_id, equipment_id
                from   FP_PRODUCTION_PLAN_EQUIPMENT_CHANGE_R
                --where  instance_id = 'KR_E_PRE'
                --and    fp_plan_id  = 'KR_E_PRE-20170407-98'
                ) b
      where  a.instance_id         = b.instance_id
      --and    a.fp_plan_id          = b.fp_plan_id
      and    a.work_order_id       = b.work_order_id

    	EXEC PR_XIF_LOG @v_proc_name, NULL, 'END', NULL, @v_temp1, 'fp_production_plan_r update end', NULL, @sysdate


    END


--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------



		---------------------------------------------------------------------------------------------------------------------------------
		---------------------------------------------------------------------------------------------------------------------------------

		SET @ROWCOUNT = @@ROWCOUNT

		UPDATE [dbo].[FP_PRODUCTION_PLAN_EQUIPMENT_CHANGE_R]
		   SET IF_FLAG = 'Y'
			  ,IF_TIME = GETDATE()
	     WHERE IF_FLAG = 'P'
		   AND SESSION_ID = @P_SESSION_ID   -- kimcd add parameter 2017-04-10
		;

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
