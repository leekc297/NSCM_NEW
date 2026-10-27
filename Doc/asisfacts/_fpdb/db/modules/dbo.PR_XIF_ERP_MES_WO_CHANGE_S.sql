CREATE PROCEDURE [dbo].[PR_XIF_ERP_MES_WO_CHANGE_S]

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
-- Create Date		   : 2016.09.08
-- Update Date		   : 2017.06.14
--					     2017.06.23  PIYONG 3.2
--						 2017.07.13  PIYONG 3.4
--						 2017.08.25	 PIYONG 3.5
--						 2017.11.02	 PIYONG 4.0
--						 2017.11.23  PIYONG 4.1

-- Author              : 김 석
-- Version             : 1.0
--                       2.0 2017-04-09 kimcd. update work order result to mes work order master table.
--                       3.0 2017-04-10 kimcd. add session_id parameter.
--						 3.1 2017-06-14 PIYONG	실적 합산시 ADD_QTY 추가
--					     3.2 2017.06.23 PIYONG  ADD_QTY 삭제  양품 수량에 이미 포함되어 있음
--                       3.3 2017-07-12 kimcd   add fp line id
--						 3.4 2017-07-13 PIYONG 실적 조회 조건 추가
--						 3.5 SCM_MES_WIP_HISTORY_H 의 WIP_TYPE_CODE 조건에  PROD 추가
--						 4.0 1)기 발행된 WO의 MES_SOURCE_GROUP 와 @P_FP_PLAN_ID의 MES_SOURCE_GROUP 가 다른 경우 기 발행한 WO를 삭제
--						     2)FP_RELEASE_FIX_PLAN_H에  WO의 최근 릴리즈된 정보 수정
--						 4.1 MES_WO_S ATTR_12에  TOP_ITEM_ID 정보 송신 추가
--                       4.2 2023-11-01 FP Pjt. 스마트 팩토리 핵심 IT 품질 시스템 구축_FP영역 / PDS 전송 추가
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
	DECLARE @v_proc_name			NVARCHAR(100) = 'PR_XIF_ERP_MES_WO_CHANGE_S'
	DECLARE @v_descr				NVARCHAR(250)
	DECLARE @v_count				INTEGER	   = 0
	DECLARE @sysdate				DATETIME      = GETDATE()

   
	DECLARE @v_table_name			nvarchar(100)


	DECLARE @ROWCOUNT				INTEGER

	-- ERROR_LINE
	DECLARE @v_temp1				NVARCHAR(1000)
	DECLARE @v_temp2				NVARCHAR(1000)

	-- ================================================
    -- Declare start
	-- ================================================
	DECLARE @IFSEQNO				NVARCHAR(50)
	DECLARE @PDS_IFSEQNO			NVARCHAR(50) 

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
		SET @IFSEQNO		= SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(CONVERT(NVARCHAR(26),GETDATE(),21),'-',''),':',''),' ',''),'.',''),1,16)
		SET @PDS_IFSEQNO	= CONVERT(VARCHAR,GETDATE(),12) + dbo.FN_ZERO_LPAD(CONVERT(VARCHAR,NEXT VALUE FOR [dbo].[XIF_PDS_SEQ]),10)

		/*
		DELETE FROM [dbo].[XIF_ERP_PRODUCTION_PLAN_S]
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


		--2017-11-08 PIYONG  기 발행된 WO의 MES_SOURCE_GROUP 와 @FACTORY_ID의 MES_SOURCE_GROUP가 다른 경우 기 발행한 WO를 삭제  시작
		---------------------------------------------------------------------------------------------------------
		---------------------------------------------------------------------------------------------------------
		---------------------------------------------------------------------------------------------------------
		IF (SELECT COUNT(*)
			  FROM (
					SELECT B.IF_ID, B.WO, B.WO_DETAIL, B.BUILNO, E.FACTORY_ID , ROW_NUMBER() OVER( PARTITION BY B.WO ORDER BY IF_SEQ DESC) ROWNUMS
					  FROM [DBO].[SY_XIF_MES_WO_S] B
						   INNER JOIN (
									   SELECT WORK_ORDER_ID AS WO
											  ,WORK_ORDER_SPL_ID AS WO_DETAIL
											  ,FACTORY_ID
									     FROM [FP_PRODUCTION_PLAN_EQUIPMENT_CHANGE_R]
									    WHERE IF_FLAG    = 'P'
									      AND SESSION_ID = @P_SESSION_ID
									  ) E
								   ON (B.WO = E.WO
 									   AND B.WO_DETAIL = E.WO_DETAIL											
									  )
						        WHERE IF_ID != 'OFP0_OPLM_FP_WO'
					) A
		      WHERE ROWNUMS  = 1
			    AND A.IF_ID != ('OFP0'+'_'+ISNULL(( SELECT ISNULL(MES_SOURCE_GROUP,'') FROM SCM_FACTORY_M F  WITH(NOLOCK) WHERE F.FACTORY_ID = A.FACTORY_ID ),'') +'_'+'FP_WO')		) > 0 

			BEGIN
				--최근 릴리즈된 정보 수정
				UPDATE FP_RELEASE_FIX_PLAN_H
					SET LINE_ID			= X.LINE_ID
						,FACTORY_ID		= X.FACTORY_ID
						,EQUIPMENT_ID	= X.EQUIPMENT_ID
					FROM (
							SELECT B.RELEASE_PLAN_ID,B.INSTANCE_DATE, B.WORK_ORDER_ID, E.FACTORY_ID, E.EQUIPMENT_ID,E.LINE_ID
								, ROW_NUMBER() OVER( PARTITION BY B.WORK_ORDER_ID ORDER BY INSTANCE_DATE DESC) ROWNUMS
							FROM [DBO].[FP_RELEASE_FIX_PLAN_H] B
								INNER JOIN (
											SELECT WORK_ORDER_ID, FP_PLAN_ID, FACTORY_ID, EQUIPMENT_ID,LINE_ID
												FROM [FP_PRODUCTION_PLAN_EQUIPMENT_CHANGE_R]
											   WHERE IF_FLAG    = 'P'
												 AND SESSION_ID = @P_SESSION_ID
											) E
										ON (
												B.RELEASE_PLAN_ID = E.FP_PLAN_ID
 												AND B.WORK_ORDER_ID = E.WORK_ORDER_ID											
											)
						) x
					WHERE FP_RELEASE_FIX_PLAN_H.WORK_ORDER_ID      = X.WORK_ORDER_ID
					AND FP_RELEASE_FIX_PLAN_H.INSTANCE_DATE = X.INSTANCE_DATE
					AND FP_RELEASE_FIX_PLAN_H.RELEASE_PLAN_ID    = X.RELEASE_PLAN_ID
					AND X.ROWNUMS = 1
					AND ('OFP0'+'_'+ISNULL(( SELECT ISNULL(MES_SOURCE_GROUP,'') FROM SCM_FACTORY_M F  WITH(NOLOCK) WHERE F.FACTORY_ID = FP_RELEASE_FIX_PLAN_H.FACTORY_ID ),'') +'_'+'FP_WO') 
							!= 
						('OFP0'+'_'+ISNULL(( SELECT ISNULL(MES_SOURCE_GROUP,'') FROM SCM_FACTORY_M F  WITH(NOLOCK) WHERE F.FACTORY_ID = X.FACTORY_ID ),'') +'_'+'FP_WO')	


				INSERT INTO [DBO].[SY_XIF_MES_WO_S]
						([IF_SEQ]
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
						,[MARKET]
						,[ATTR_01]
						,[ATTR_02]
						,[ATTR_03]
						,[ATTR_04]
						,[ATTR_05]
						,[ATTR_06]
						,[ATTR_07]
						,[ATTR_08]
						,[ATTR_09]
						,[ATTR_10]
						,[ATTR_11]
						,[ATTR_12]
						,[ATTR_30] -- PDS_IFSEQNO
				)
				SELECT 'OFP0' + SUBSTRING(CONVERT(NVARCHAR(12), GETDATE(), 112), 3,6) + REPLICATE('0', 10 - LEN(NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ])) + CAST( NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ] AS NVARCHAR)   -- IF_SEQ
						,[IF_TYPE]
						,'OFP0'+'_'+ISNULL(( SELECT ISNULL(MES_SOURCE_GROUP,'') FROM SCM_FACTORY_M F  WITH(NOLOCK) WHERE F.FACTORY_ID = A.BUILNO ),'') +'_'+'FP_WO' -- [IF_ID]
						,[IF_INS_DATE]
						,'N'  --[IF_FLAG]		  -- 2017-11-08 PIYONG N 처리
						,NULL --[IF_SND_DATE]	  -- 2017-11-08 PIYONG NULL 처리
						,NULL -- [RSLT_IF_SEQ]
						,NULL --[RSLT_PROC_FLAG]
						,NULL --[RSLT_PROC_MSG]
						,CONCAT( SUBSTRING(FP_PLAN_ID,0,PATINDEX('%-%',FP_PLAN_ID)) ,'-',CONVERT(VARCHAR, GETDATE(),112),'-XX') -- [FP_PLAN_ID]
						,A.[PLANT_ID]
						,BUILNO AS [FACTORY_ID]
						,LINE_ID
						,OPERATION_ID
						,EQUIPMENT_ID
						,[ITEM_ID]
						,[DEMAND_ID]
						,A.[WO]
						,[WO_TYPE]
						,A.[WO_DETAIL]
						,CASE WHEN PLAN_DATE > GETDATE() THEN	-- 계획 일자가 과거이면 계획 일자를 과거 처리
								CONCAT(CONVERT(NVARCHAR(10),DATEADD(DAY, -1, GETDATE()), 120), ' 00:00:00')
							  ELSE
								PLAN_DATE
							  END AS PLAN_DATE
						,CASE WHEN PLAN_DATE > GETDATE() THEN	-- 계획 일자가 과거이면 시작 일자를 과거 처리
								CONCAT(CONVERT(NVARCHAR(10),DATEADD(DAY, -1, GETDATE()), 120), ' 06:00:00')
							  ELSE
								START_TIME
							  END AS START_TIME
						,CASE WHEN PLAN_DATE > GETDATE() THEN	-- 계획 일자가 과거이면 종료 일자를 과거 처리
								CONCAT(CONVERT(NVARCHAR(10),DATEADD(DAY, -1, GETDATE()), 120), ' 06:10:00')
							  ELSE
								END_TIME
							  END AS END_TIME
						,0  -- [IN_QTY]
						,0  -- [OUT_QTY]
						,[IS_RELEASE]
						,[CREATE_PSN_ID]
						,getdate() --[CREATE_DATE]
						,'PR_XIF_ERP_MES_WO_CHANGE_DEL' -- [UPDATE_PSN_ID]
						,getdate() --[UPDATE_DATE]
						,[LANE_QTY]
						,[UNIT]
						,[ORDER_TYPE]
						,[BATCH_ORDER_ID]
						,[SLITTER_PLANT]
						,[MARKET]
						,[ATTR_01]
						,[ATTR_02]
						,[ATTR_03]
						,[ATTR_04]
						,[ATTR_05]
						,[ATTR_06]
						,[ATTR_07]
						,[ATTR_08]
						,[ATTR_09]
						,[ATTR_10]
						,[ATTR_11]
						,[ATTR_12]	 -- 2017-11-23  PIYONG ATTR_12 ADD
						,@PDS_IFSEQNO
					FROM ( 
							SELECT SOURCES.[IF_TYPE]
								   ,SOURCES.[IF_INS_DATE]
								   ,SOURCES.[IF_SND_DATE]
   								   ,SOURCES.PLAN_ID
								   ,SOURCES.[PLANT_ID]
   								   ,SOURCES.LINE_ID
								   ,SOURCES.[OPERATION_ID]
   								   ,SOURCES.EQUIPMENT_ID
 								   ,SOURCES.BUILNO
								   ,SOURCES.[ITEM_ID]
								   ,SOURCES.[DEMAND_ID]
								   ,SOURCES.[WO]
								   ,SOURCES.[WO_TYPE]
								   ,SOURCES.[WO_DETAIL]
								   ,SOURCES.[PLAN_DATE]
								   ,SOURCES.[START_TIME]
								   ,SOURCES.[END_TIME]
								   ,SOURCES.[IS_RELEASE]
								   ,SOURCES.[CREATE_PSN_ID]
								   ,SOURCES.[LANE_QTY]
								   ,SOURCES.[UNIT]
								   ,SOURCES.[ORDER_TYPE]
								   ,SOURCES.[BATCH_ORDER_ID]
								   ,SOURCES.[SLITTER_PLANT]
								   ,SOURCES.[MARKET]
								   ,SOURCES.[ATTR_01]
								   ,SOURCES.[ATTR_02]
								   ,SOURCES.[ATTR_03]
								   ,SOURCES.[ATTR_04]
								   ,SOURCES.[ATTR_05]
								   ,SOURCES.[ATTR_06]
								   ,SOURCES.[ATTR_07]
								   ,SOURCES.[ATTR_08]
								   ,SOURCES.[ATTR_09]
								   ,SOURCES.[ATTR_10]
								   ,SOURCES.[ATTR_11]
								   ,SOURCES.[ATTR_12]	 -- 2017-11-23  PIYONG ATTR_12 ADD
								   ,X.FP_PLAN_ID
							FROM [DBO].[SY_XIF_MES_WO_S] SOURCES
								,(
									SELECT IF_SEQ
											, B.WO
											, B.WO_DETAIL
 											, E.FACTORY_ID
											, E.FP_PLAN_ID
											, ROW_NUMBER() OVER( PARTITION BY B.WO ORDER BY IF_SEQ DESC) ROWNUMS
										FROM [DBO].[SY_XIF_MES_WO_S] B
											INNER JOIN (SELECT WORK_ORDER_ID AS WO
																, WORK_ORDER_SPL_ID AS WO_DETAIL
 																, FACTORY_ID
																, FP_PLAN_ID
														  FROM [FP_PRODUCTION_PLAN_EQUIPMENT_CHANGE_R]
														 WHERE IF_FLAG    = 'P'
														   AND SESSION_ID = @P_SESSION_ID
														) E
													ON (B.WO = E.WO
 														AND B.WO_DETAIL = E.WO_DETAIL											
														)
									WHERE B.IF_ID != 'OFP0_OPLM_FP_WO'
								) x
							WHERE SOURCES.WO      = X.WO
							AND SOURCES.WO_DETAIL = X.WO_DETAIL
							AND SOURCES.IF_SEQ    = X.IF_SEQ
							AND X.ROWNUMS = 1
							AND SOURCES.IF_ID != ('OFP0'+'_'+ISNULL(( SELECT ISNULL(MES_SOURCE_GROUP,'') FROM SCM_FACTORY_M F  WITH(NOLOCK) WHERE F.FACTORY_ID = X.FACTORY_ID ),'') +'_'+'FP_WO')										
						)A
			  END
		--2017-11-08 PIYONG 기 발행된 WO의 MES_SOURCE_GROUP 와 @FACTORY_ID의 MES_SOURCE_GROUP가 다른 경우 기 발행한 WO를 삭제  끝
		---------------------------------------------------------------------------------------------------------
		---------------------------------------------------------------------------------------------------------
		---------------------------------------------------------------------------------------------------------

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
				        ,[ATTR_10]
						,[ATTR_11] -- 2017-11-08  PIYONG ATTR_11 ADD
						,[ATTR_12] -- 2017-11-23  PIYONG ATTR_12 ADD
						,[ATTR_30] -- @PDS_IFSEQNO
				)
				SELECT 'OFP0' + SUBSTRING(CONVERT(NVARCHAR(12), GETDATE(), 112), 3,6) + REPLICATE('0', 10 - LEN(NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ])) + CAST( NEXT VALUE FOR [dbo].[XIF_MES_SEND_SEQ] AS NVARCHAR)   -- IF_SEQ
						,'S'   -- IF_TYPE                                                                                                                                                                                                                     
						,'OFP0'+'_'+ISNULL(( SELECT ISNULL(MES_SOURCE_GROUP,'') FROM SCM_FACTORY_M F WHERE F.FACTORY_ID = SOURCES.FACTORY_ID ),'') +'_'+'FP_WO'                                                                                                          
						,GETDATE()   -- IF_INS_DATE                                                                                                                                                                                                           
						,'N'  -- IF_FLAG                                                                                                                                                                                                                      
						,NULL  -- IF_SND_DATE                                                                                                                                                                                                                 
						,NULL  -- RSLT_IF_SEQ                                                                                                                                                                                                                 
						,NULL  -- RSLT_PROC_FLAG                                                                                                                                                                                                              
						,NULL  -- RSLT_PROC_MSG
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
						,PLAN_IN_QTY + (SELECT ISNULL( SUM(ISNULL(W.WIPQTY2_ED,0))
														+ SUM(ISNULL(CONVERT(NUMERIC(14,3),W.CNFM_DFCT_QTY2),0)) 
														+ SUM(ISNULL(CONVERT(NUMERIC(14,3),W.CNFM_LOSS_QTY2),0)) 
														+ SUM(ISNULL(CONVERT(NUMERIC(14,3),W.CNFM_PRDT_REQ_QTY2),0))
														+ SUM(ISNULL(CAST(W.SCRAP_QTY AS NUMERIC(14,3)),0))
													,0)
											FROM DBO.SCM_MES_WIP_HISTORY_H W WITH(NOLOCK)
										WHERE W.WOID   = SOURCES.WORK_ORDER_ID
											AND W.PROCID = SOURCES.OPERATION_ID
											AND W.WIP_TYPE_CODE in ( 'OUT','INOUT','PACKED', 'PROD')	-- PIYONG 2017-08-25 PROD 추가
											AND W.WO_DETL_ID = SOURCES.WORK_ORDER_SPL_ID
									) -- IN_QTY
						,PLAN_QTY + (SELECT ISNULL( SUM(ISNULL(W.WIPQTY2_ED,0))
													+ SUM(ISNULL(CONVERT(NUMERIC(14,3),W.CNFM_DFCT_QTY2),0)) 
													+ SUM(ISNULL(CONVERT(NUMERIC(14,3),W.CNFM_LOSS_QTY2),0)) 
													+ SUM(ISNULL(CONVERT(NUMERIC(14,3),W.CNFM_PRDT_REQ_QTY2),0))
													+ SUM(ISNULL(CAST(W.SCRAP_QTY AS NUMERIC(14,3)),0))
												,0)
										FROM  DBO.SCM_MES_WIP_HISTORY_H W WITH(NOLOCK)
										WHERE W.WOID   = SOURCES.WORK_ORDER_ID
										AND W.PROCID = SOURCES.OPERATION_ID
										AND W.WIP_TYPE_CODE in ( 'OUT','INOUT','PACKED', 'PROD')	-- PIYONG 2017-08-25 PROD 추가
										AND W.WO_DETL_ID = SOURCES.WORK_ORDER_SPL_ID
									) -- OUT_QTY                                                                                                                                                                                                                 
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
						,SOURCES.LINE_ID  -- ATTR_10  FP_LINE_ID kimcd add 2017-07-12
						,CASE WHEN INSTANCE_ID = 'KR_CELL_M_P' THEN
								'Y'
							  END AS PILOT_YN  
						,SOURCES.TOP_ITEM_ID  -- 2017-11-23  PIYONG ADD        
						,@PDS_IFSEQNO
				   FROM [dbo].[FP_PRODUCTION_PLAN_EQUIPMENT_CHANGE_R] SOURCES WITH(NOLOCK)
				        LEFT OUTER JOIN [DBO].[SCM_SYS_LOOKUP_VALUE]  B WITH(NOLOCK)
									 ON B.LOOKUP_TYPE_CODE = 'BOM_ADD_FOR_RES_SHARE'
									AND B.SEGMENT1         = SOURCES.PLANT_ID
									AND B.ACTIVE_FLAG      = 'Y'
									 --AND SOURCES.FP_PLAN_ID LIKE '%99'
									--WHERE SOURCES.FP_PLAN_ID = ISNULL(@P_FP_PLAN_ID,'0')       
				  WHERE SOURCES.IF_FLAG    = 'P'
				    AND SOURCES.SESSION_ID = @P_SESSION_ID -- kimcd add parameter 2017-04-10
		;

		-- WO에 LINE을 변경하면 기존 MES 송신 정보에 해당 WO에 대해서 BUILNO, LINE 정보를 UPDATE 함.
		-- MES OPEN WO 생성시에도 변경되도록 적용하기 위함.
		UPDATE [SY_XIF_MES_WO_S]
		   SET [LINE_ID] = ZZ.LINE_ID
			   ,[BUILNO]  = ZZ.BUILNO
			   ,[EQUIPMENT_ID] = ZZ.EQUIPMENT_ID
			   ,[ATTR_10] = ZZ.ATTR_10				-- 2017-11-08 PIYONG ADD
		 FROM (
				SELECT ROW_NUMBER() OVER ( PARTITION BY A.WO_DETAIL, A.LINE_ID, B.LINE_ID  ORDER BY B.IF_SEQ DESC ) ROWNUMS
					  ,B.PLAN_ID, A.WO_DETAIL, A.LINE_ID, A.BUILNO, A.EQUIPMENT_ID, A.ATTR_10
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


		SET @ROWCOUNT = @@ROWCOUNT

		UPDATE [dbo].[FP_PRODUCTION_PLAN_EQUIPMENT_CHANGE_R]
		   SET IF_FLAG = 'Y'
			  ,IF_TIME = GETDATE()
	     WHERE IF_FLAG = 'P'
		   AND SESSION_ID = @P_SESSION_ID   -- kimcd add parameter 2017-04-10
		;

			-- PDS 전송
			INSERT INTO SY_XIF_PDS_WO_S
                        ( [IF_SEQ]                                                                                                                                                                                                                                  
						, [IF_TYPE]                                                                                                                                                                                                                                   
						, [IF_ID]                                                                                                                                                                                                                                     
						, [IF_INS_DATE]                                                                                                                                                                                                                               
						, [IF_FLAG]                                                                                                                                                                                                                                   
						, [IF_SND_DATE]                                                                                                                                                                                                                               
						, [RSLT_IF_SEQ]                                                                                                                                                                                                                               
						, [RSLT_PROC_FLAG]                                                                                                                                                                                                                            
						, [RSLT_PROC_MSG]                                                                                                                                                                                                                             
						, [PLAN_ID]                                                                                                                                                                                                                                   
						, [PLANT_ID]                                                                                                                                                                                                                                  
						, [BUILNO]                                                                                                                                                                                                                                    
						, [LINE_ID]                                                                                                                                                                                                                                   
						, [OPERATION_ID]                                                                                                                                                                                                                              
						, [EQUIPMENT_ID]                                                                                                                                                                                                                              
						, [ITEM_ID]                                                                                                                                                                                                                                   
						, [DEMAND_ID]                                                                                                                                                                                                                                 
						, [WO]                                                                                                                                                                                                                                        
						, [WO_TYPE]                                                                                                                                                                                                                                   
						, [WO_DETAIL]                                                                                                                                                                                                                                 
						, [PLAN_DATE]                                                                                                                                                                                                                                 
						, [START_TIME]                                                                                                                                                                                                                                
						, [END_TIME]                                                                                                                                                                                                                                  
						, [IN_QTY]                                                                                                                                                                                                                                    
						, [OUT_QTY]                                                                                                                                                                                                                                   
						, [IS_RELEASE]                                                                                                                                                                                                                                
						, [CREATE_PSN_ID]                                                                                                                                                                                                                             
						, [CREATE_DATE]                                                                                                                                                                                                                               
						, [UPDATE_PSN_ID]                                                                                                                                                                                                                             
						, [UPDATE_DATE]                                                                                                                                                                                                                               
						, [LANE_QTY]                                                                                                                                                                                                                                  
						, [UNIT]                                                                                                                                                                                                                                      
						, [ORDER_TYPE]    
						, [BATCH_ORDER_ID]
						, [SLITTER_PLANT]
						, [MARKET]
						, [ATTR_01]
						, [ATTR_02]
						, [ATTR_03]
						, [ATTR_04]
						, [ATTR_05] 
						, [ATTR_06] 
						, [ATTR_07] 
						, [ATTR_08] 
						, [ATTR_09] 
						, [ATTR_10]
						, [ATTR_11]							  
						, [ATTR_12] 
						, [ATTR_13] 
						, [ATTR_14] 
						, [ATTR_15] 
						, [ATTR_16] 
						, [ATTR_17] 
						, [ATTR_18] 
						, [ATTR_19] 
						, [ATTR_20] 
						)
					SELECT 
						  X.[IF_SEQ]                                                                                                   
						, X.[IF_TYPE]                                                                                                  
						, 'OFP0_GPDS_FP_WO' --X.[IF_ID]                                                                                                    
						, X.[IF_INS_DATE]                                                                                              
						, 'N'  --X.[IF_FLAG]                                                                                                  
						, NULL --X.[IF_SND_DATE]                                                                                              
						, X.[RSLT_IF_SEQ]                                                                                              
						, X.[RSLT_PROC_FLAG]                                                                                           
						, X.[RSLT_PROC_MSG]                                                                                            
						, X.[PLAN_ID]                                                                                                  
						, X.[PLANT_ID]                                                                                                 
						, X.[BUILNO]                                                                                                   
						, X.[LINE_ID]                                                                                                  
						, X.[OPERATION_ID]                                                                                             
						, X.[EQUIPMENT_ID]                                                                                             
						, X.[ITEM_ID]                                                                                                  
						, X.[DEMAND_ID]                                                                                                
						, X.[WO]                                                                                                       
						, X.[WO_TYPE]                                                                                                  
						, X.[WO_DETAIL]                                                                                                
						, X.[PLAN_DATE]                                                                                                
						, X.[START_TIME]                                                                                               
						, X.[END_TIME]                                                                                                 
						, X.[IN_QTY]                                                                                                   
						, X.[OUT_QTY]                                                                                                  
						, X.[IS_RELEASE]                                                                                               
						, X.[CREATE_PSN_ID]                                                                                            
						, X.[CREATE_DATE]                                                                                              
						, X.[UPDATE_PSN_ID]                                                                                            
						, X.[UPDATE_DATE]                                                                                              
						, X.[LANE_QTY]                                                                                                 
						, X.[UNIT]                                                                                                     
						, X.[ORDER_TYPE]    
						, X.[BATCH_ORDER_ID]
						, X.[SLITTER_PLANT]
						, X.[MARKET]
						, X.[ATTR_01]
						, X.[ATTR_02]
						, X.[ATTR_03]
						, X.[ATTR_04]
						, X.[ATTR_05] 
						, X.[ATTR_06] 
						, X.[ATTR_07] 
						, X.[ATTR_08] 
						, X.[ATTR_09] 
						, X.[ATTR_10] 
						, X.[ATTR_11] 
						, X.[ATTR_12] 
						, X.[ATTR_13] 
						, X.[ATTR_14] 
						, X.[ATTR_15] 
						, X.[ATTR_16] 
						, X.[ATTR_17] 
						, X.[ATTR_18] 
						, X.[ATTR_19] 
						, X.[ATTR_20] 
					FROM SY_XIF_MES_WO_S as x with(nolock)
						join scm_factory_m as y with(nolock)
						on x.[BUILNO] = y.factory_id
					where y.company_id = 'G670'
					  and x.ATTR_30 = @PDS_IFSEQNO
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