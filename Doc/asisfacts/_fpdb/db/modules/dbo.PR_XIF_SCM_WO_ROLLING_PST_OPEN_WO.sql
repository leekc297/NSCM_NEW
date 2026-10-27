
--CREATE PROCEDURE [dbo].[PR_XIF_SCM_WO_ROLLING_PST_OPEN_WO]
CREATE PROCEDURE [dbo].[PR_XIF_SCM_WO_ROLLING_PST_OPEN_WO]

-- ================================================================================================
-- Program ID          : 
-- Program Name        : PR_XIF_SCM_WO_ROLLING_PST_OPEN_WO
-- Param               :
-- Batch Period        : 1DAY
-- Description         :
--
-- Source System       : FP SDB
-- Destination System  : MES, ERP
-- Source Table        : FP_MES_WORK_ORDER_STATUS_H
-- Destination Table   : SY_XIF_ERP_PRODUCTION_PLAN_S, SY_XIF_MES_WO_S
--
-- Create Date		   : 
-- Update Date		   : 



-- Author              : PIYONG
-- Version             : 1.0

-- ================================================================================================


AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_SCM_WO_ROLLING_PST_OPEN_WO'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	   = 0
	DECLARE @sysdate     DATETIME2     = GETDATE()
	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)

	DECLARE @SITE_ID     NVARCHAR(30)
	DECLARE @FACTORY_ID  NVARCHAR(30)

	DECLARE @BASE_HOUR NVARCHAR(10)
	DECLARE @SEQ		 INTEGER

	DECLARE @TEMP_TABLE TABLE (
			 DIVISION_ID             NVARCHAR(30)
	        , SITE_ID                 NVARCHAR(30)
	        , FACTORY_ID              NVARCHAR(30)
	        , OPERATION_ID            NVARCHAR(50)
	        , ITEM_ID                 NVARCHAR(150)
	        , EQUIPMENT_ID            NVARCHAR(100)
	        , WORK_ORDER_ID           NVARCHAR(100)
	        , RELEASE_PLAN_ID         NVARCHAR(50)
	        , PLAN_IN_QTY             NUMERIC(18,5)
	)

	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

	BEGIN TRY				

		BEGIN TRAN
		-- ================================================
		-- 로직 추가
		-- ================================================
--			SELECT ' STEP  DECLARE CURSOR'
			DECLARE CUR_SITE CURSOR FOR
				SELECT DISTINCT Z.SITE_ID, Z.FACTORY_ID
				  FROM SCM_FACTORY_M Z WITH(NOLOCK)
				 WHERE MES_SOURCE_GROUP IN ( SELECT SUBSTRING(IF_ID,1,4)
				                               FROM [SY_XIF_MES_OPEN_WO_R]
						 					  WHERE 1=1
											    AND PROC_FLAG = 'Y'
											    AND ACCUM_DATE = CONVERT( NVARCHAR(8), GETDATE(), 112)
											  GROUP BY IF_ID, ACCUM_DATE) 
				   AND NOT EXISTS ( SELECT 1
				                      FROM [DBO].[SCM_SYS_LOOKUP_VALUE]  SV WITH(NOLOCK)
						             WHERE SV.LOOKUP_TYPE_CODE = 'WO_ROLL_EXEC_FLAG'
							           AND SV.SEGMENT1 = Z.SITE_ID
								       AND SV.SEGMENT2 = Z.FACTORY_ID
								       AND SV.ATTRIBUTE1 = CONVERT( NVARCHAR(8), GETDATE(), 112) )
--				   AND Z.SITE_ID = 'A001'

			;

			OPEN CUR_SITE;
			FETCH NEXT FROM CUR_SITE INTO  @SITE_ID
			                              ,@FACTORY_ID 

			WHILE (@@FETCH_STATUS = 0)
				BEGIN
					DELETE @TEMP_TABLE

--			SELECT ' STEP  DECLARE CURSOR'
					SET @BASE_HOUR = (	
										 SELECT TOP 1 CONCAT(' ', SUBSTRING(SEGMENT2, 1, 2), ':',SUBSTRING(SEGMENT2, 3, 2), ':',SUBSTRING(SEGMENT2, 5, 2))
										   FROM [DBO].[SCM_SYS_LOOKUP_VALUE] V  WITH(NOLOCK)
												,SCM_FACTORY_M F
										  WHERE V.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
											AND V.ACTIVE_FLAG = 'Y'
											AND V.SEGMENT1 = F.PLANT_ID
											AND F.SITE_ID = @SITE_ID
											AND F.FACTORY_ID = @FACTORY_ID
									 )



					SET @SEQ = NEXT VALUE FOR RELEASE_PLAN

					-- ERP 전송 WO 정보 생성
					INSERT INTO [dbo].[SY_XIF_ERP_PRODUCTION_PLAN_S]
						(
							[IFSEQNO]
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
						   ,[MARKET]
						   ,[ATTRIBUTE1]
						   ,[ATTRIBUTE2]
						   ,[ATTRIBUTE3]
						   ,[ATTRIBUTE4]
						   ,[ATTRIBUTE5]
						   ,[ATTRIBUTE6]
						   ,[ATTRIBUTE7]
						   ,[ATTRIBUTE8]
						   ,[ATTRIBUTE9]
						   ,[ATTRIBUTE10]
						   ,[TOP_BACK_IND] -- 단면 설비에 양면 제품이 계획된 경우 TOP BACK 구분
						   ,[LINK_WO]      -- 연계된 WO명 - TOP은 Back WO, Back은 TOP WO
						   ,[FP_PLAN_QTY]  -- FP Plan 수량
						   ,[FP_SNAP_QTY]) -- FP 실적 수량
					SELECT REPLACE(REPLACE(REPLACE(CONVERT(NVARCHAR(19),GETDATE(),120),'-',''),':',''),' ','') -- [IFSEQNO]
						   ,ROW_NUMBER() OVER ( ORDER BY H.LINE_ID, H.ITEM_ID) --[SEQ]
						   ,CONCAT('OPEN_WO_', CONVERT(NVARCHAR(8), GETDATE(), 112)+'-00XX', 1)
						   ,H.[PLANT_ID]
						   ,H.[FACTORY_ID]
						   ,EQP.MES_LINE_ID AS LINE_ID
						   ,H.[OPERATION_ID]
						   ,NULL AS [BOM_VERSION_ID]
						   ,EQP.[WORK_CENTER_ID]
						   ,H.[ITEM_ID]
						   ,[DEMAND_ID]
						   ,[WORK_ORDER_ID]
						   ,PRODUCTION_TYPE [ORDER_TYPE]
						   ,REPLACE(REPLACE(REPLACE(CONVERT(NVARCHAR(19),CAST( SUBSTRING( CONVERT( VARCHAR, GETDATE(), 120 ) , 1, 10 ) + (SELECT CONCAT(' ', SUBSTRING(SEGMENT2, 1, 2), ':',SUBSTRING(SEGMENT2, 3, 2), ':',SUBSTRING(SEGMENT2, 5, 2))
																																			 FROM [DBO].[SCM_SYS_LOOKUP_VALUE] W  WITH(NOLOCK)
																																			WHERE W.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
																																			  AND W.ACTIVE_FLAG = 'Y'
																																			  AND SEGMENT1 = H.PLANT_ID
																																		  ) AS DATETIME) ,120),'-',''),':',''),' ','') AS [PLAN_DATE]
						   ,REPLACE(REPLACE(REPLACE(CONVERT(NVARCHAR(19),CAST( SUBSTRING( CONVERT( VARCHAR, GETDATE(), 120 ) , 1, 10 ) + (SELECT CONCAT(' ', SUBSTRING(SEGMENT2, 1, 2), ':',SUBSTRING(SEGMENT2, 3, 2), ':',SUBSTRING(SEGMENT2, 5, 2))
																																			 FROM [DBO].[SCM_SYS_LOOKUP_VALUE] W  WITH(NOLOCK)
																																			WHERE W.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
																																			  AND W.ACTIVE_FLAG = 'Y'
																																			  AND SEGMENT1 = H.PLANT_ID
																																		  ) AS DATETIME) ,120),'-',''),':',''),' ','') AS [START_TIME]
						   ,REPLACE(REPLACE(REPLACE(CONVERT(NVARCHAR(19),CAST( SUBSTRING( CONVERT( VARCHAR, GETDATE(), 120 ) , 1, 10 ) + (SELECT CONCAT(' ', SUBSTRING(SEGMENT2, 1, 2), ':',SUBSTRING(SEGMENT2, 3, 2) + 10, ':',SUBSTRING(SEGMENT2, 5, 2))
																																			 FROM [DBO].[SCM_SYS_LOOKUP_VALUE] W  WITH(NOLOCK)
																																			WHERE W.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
																																			  AND W.ACTIVE_FLAG = 'Y'
																																			  AND SEGMENT1 = H.PLANT_ID
																																		  ) AS DATETIME) ,120),'-',''),':',''),' ','') AS [END_TIME]
						   ,H.[PLAN_IN_QTY]
						   ,H.[PLAN_QTY]
						   ,'Y' [FIX_TYPE]
						   ,'N' --[TRANSFER_FLAG]
						   ,GETDATE() [TRANSFER_DATE]
						   ,'OPEN_W0_'+CONVERT(NVARCHAR(8), GETDATE(), 112) AS [CREATE_USER_ID]
						   ,GETDATE() [CREATE_DATE]
						   ,'OPEN_W0_'+CONVERT(NVARCHAR(8), GETDATE(), 112) AS [MODIFY_USER_ID]
						   ,GETDATE() [MODIFY_DATE]
						   ,[LANE_QTY]
						   ,ISNULL([BATCH_ORDER_ID], '-')
						   ,CASE WHEN H.[OPERATION_ID] = 'E2000' THEN 
									ISNULL( (
												SELECT TOP 1 Z.PLANT_ID
												  FROM [DBO].[FP_PRODUCTION_PLAN_EQUIPMENT_R] Z
												 WHERE Z.OPERATION_ID = 'E4000'
												   AND Z.COMPANY_ID   = H.COMPANY_ID
												   AND Z.DIVISION_ID  = H.DIVISION_ID
												   AND Z.SITE_ID      = H.SITE_ID
												   AND Z.ITEM_ID      = H.ITEM_ID 
												 ORDER BY Z.INSERT_TIME DESC 
											),(
												SELECT TOP 1 ILA.PLANT_ID
												  FROM [DBO].[SCM_ITEM_LINE_ASSIGN_M] ILA
												 WHERE ILA.OPERATION_ID = 'E4000'
												   AND ILA.COMPANY_ID   = H.COMPANY_ID
												   AND ILA.DIVISION_ID  = H.DIVISION_ID
												   AND ILA.SITE_ID      = H.SITE_ID
												   AND ILA.ITEM_ID      = H.ITEM_ID 
												   AND ILA.ACTIVE_FLAG = 'Y'
												 ORDER BY ILA.INSERT_TIME DESC 

											) )
								 ELSE NULL
								  END [SLITTER_PLANT]
						   ,[MARKET]
						   ,NULL [ATTRIBUTE1]
						   ,NULL [ATTRIBUTE2]
						   ,NULL [ATTRIBUTE3]
						   ,NULL [ATTRIBUTE4]
						   ,NULL [ATTRIBUTE5]
						   ,NULL [ATTRIBUTE6]
						   ,NULL [ATTRIBUTE7]
						   ,NULL [ATTRIBUTE8]
						   ,H.ACTUAL_QTY AS [ATTRIBUTE9]
						   ,H.ACTUAL_QTY AS [ATTRIBUTE10]
						   ,CASE WHEN EQPC.SEGMENT1 IS NOT NULL AND IMC.SEGMENT1 IS NOT NULL THEN
									'B'
								  END AS TOP_BACK_IND -- 단면 설비에 양면 제품이 계획된 경우 TOP BACK 구분
						   ,RTRIM ( CASE WHEN EQPC.SEGMENT1 IS NOT NULL AND IMC.SEGMENT1 IS NOT NULL THEN
											CASE WHEN SUBSTRING(H.WORK_ORDER_ID,7,1) = 'X' THEN
													SUBSTRING(H.WORK_ORDER_ID,1,6) + 'Y' + SUBSTRING(H.WORK_ORDER_ID,8,10)
												 WHEN SUBSTRING(H.WORK_ORDER_ID,7,1) = 'Y' THEN
													SUBSTRING(H.WORK_ORDER_ID,1,6) + 'X' + SUBSTRING(H.WORK_ORDER_ID,8,10)
												 ELSE
													CASE WHEN H.WORK_ORDER_ID LIKE 'W%' OR H.WORK_ORDER_ID LIKE 'M%' THEN
															SUBSTRING(H.WORK_ORDER_ID,1,6) + CONVERT(NVARCHAR(2), CONVERT(NUMERIC,SUBSTRING(H.WORK_ORDER_ID,7,2)) + 50) + SUBSTRING(H.WORK_ORDER_ID,9,10)
														ELSE
															SUBSTRING(H.WORK_ORDER_ID,1,5) + CONVERT(NVARCHAR(2), CONVERT(NUMERIC,SUBSTRING(H.WORK_ORDER_ID,6,2)) + 50) + SUBSTRING(H.WORK_ORDER_ID,8,10)
														 END
												  END
										  END) AS LINK_WO
						   ,H.PLAN_IN_QTY AS [FP_PLAN_QTY]
						   ,ISNULL((SELECT ISNULL(SUM(MPP.ACTUAL_QTY),0)
									  FROM [DBO].[FP_MES_PRODUCTION_PLAN_M] MPP WITH(NOLOCK)
									 WHERE MPP.WORK_ORDER_ID     = H.WORK_ORDER_ID
									   AND MPP.ITEM_ID           = H.ITEM_ID), 0 ) AS [FP_SNAP_QTY]
					  FROM DBO.FP_MES_WORK_ORDER_STATUS_H H
					    LEFT OUTER JOIN [DBO].[SCM_EQUIPMENT_M] EQP WITH(NOLOCK)
						  ON EQP.EQUIPMENT_ID = H.EQUIPMENT_ID
					     AND EQP.OPERATION_ID = H.OPERATION_ID
						 AND EQP.FACTORY_ID   = H.FACTORY_ID
						 AND EQP.EQUIPMENT_TYPE = 'M'
						 AND EQP.ACTIVE_FLAG    = 'Y'
						LEFT OUTER JOIN [DBO].[SCM_SYS_LOOKUP_VALUE]  EQPC WITH(NOLOCK)
						  ON EQPC.LOOKUP_TYPE_CODE = 'FP_COATER_TOP_COPY_OP'
					     AND EQPC.SEGMENT1         = EQP.OPERATION_ID
					     AND EQPC.SEGMENT2         = EQP.COATER_EQPT_TYPE_CODE
					     AND EQPC.ACTIVE_FLAG      = 'Y'
						LEFT OUTER JOIN [DBO].[SCM_ITEM_M]  IM WITH(NOLOCK)
						  ON IM.DIVISION_ID  = H.DIVISION_ID
						 AND IM.SITE_ID      = H.SITE_ID
						 AND IM.ITEM_ID      = H.ITEM_ID
						LEFT OUTER JOIN [DBO].[SCM_SYS_LOOKUP_VALUE]  IMC WITH(NOLOCK)
						  ON IMC.LOOKUP_TYPE_CODE = 'FP_COATER_TOP_COPY_ITEM_CLASS'
						 AND IMC.SEGMENT1         = IM.ITEM_CLASS
						 AND IMC.ACTIVE_FLAG      = 'Y'
					 WHERE CUTOFF_DATE = CONVERT(DATE, GETDATE(), 120)
					   AND PLAN_END_TIME <= CAST( SUBSTRING( CONVERT( VARCHAR, GETDATE()-1, 120 ) , 1, 10 ) + (SELECT CONCAT(' ', SUBSTRING(SEGMENT2, 1, 2), ':',SUBSTRING(SEGMENT2, 3, 2), ':',SUBSTRING(SEGMENT2, 5, 2))
																												 FROM [DBO].[SCM_SYS_LOOKUP_VALUE] W  WITH(NOLOCK)
																												WHERE W.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
																												  AND W.ACTIVE_FLAG = 'Y'
																												  AND SEGMENT1 = H.PLANT_ID
																												) AS DATETIME)
					   AND ORDER_TYPE = 'WO'
   					   AND H.SITE_ID = @SITE_ID
					   AND H.FACTORY_ID = @FACTORY_ID
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
							,[MARKET] 
							,[ATTRIBUTE1]
							,[ATTRIBUTE2]
							,[ATTRIBUTE3]
							,[ATTRIBUTE4]
							,[ATTRIBUTE5]
							,[ATTRIBUTE6]
							,[ATTRIBUTE7]
							,[ATTRIBUTE8]
							,[ATTRIBUTE9]
							,[ATTRIBUTE10]
							,[TOP_BACK_IND] -- 단면 설비에 양면 제품이 계획된 경우 TOP BACK 구분
							,[LINK_WO]      -- 연계된 WO명 - TOP은 Back WO, Back은 TOP WO
							,[FP_PLAN_QTY]  -- FP Plan 수량
							,[FP_SNAP_QTY]) -- FP 실적 수량
					SELECT  REPLACE(REPLACE(REPLACE(CONVERT(NVARCHAR(19),GETDATE(),120),'-',''),':',''),' ','') -- [IFSEQNO]
							,2000 + ROW_NUMBER() OVER( ORDER BY A.[FP_PLAN_ID], A.[PLANT_ID], A.[FACTORY_ID], A.[LINE_ID], A.[OPERATION_ID], A.[ITEM_ID], A.[WORK_ORDER_ID] ) AS SEQ
							,A.[FP_PLAN_ID]
							,A.[PLANT_ID]
							,A.[FACTORY_ID]
							,A.[LINE_ID]
							,A.[OPERATION_ID]
							,A.[BOM_VERSION_ID]
							,A.[WORK_CENTER_ID]
							,A.[ITEM_ID]
							,A.[DEMAND_ID]
							,A.[LINK_WO]
							,A.[ORDER_TYPE]
							,A.[PLAN_DATE]
							,A.[START_TIME]
							,A.[END_TIME]
							,A.[PLAN_IN_QTY]
							,A.[PLAN_QTY]
							,A.[FIX_TYPE]
							,A.[TRANSFER_FLAG]
							,A.[TRANSFER_DATE]
							,A.[CREATE_USER_ID]
							,A.[CREATE_DATE]
							,A.[MODIFY_USER_ID]
							,A.[MODIFY_DATE]
							,A.[LANE_QTY]
							,A.[BATCH_ORDER_ID]
							,A.[SLITTER_PLANT]
							,A.[MARKET]
							,A.[ATTRIBUTE1]
							,A.[ATTRIBUTE2]
							,A.[ATTRIBUTE3]
							,A.[ATTRIBUTE4]
							,A.[ATTRIBUTE5]
							,A.[ATTRIBUTE6]
							,A.[ATTRIBUTE7]
							,A.[ATTRIBUTE8]
							,A.[ATTRIBUTE9]
							,A.[ATTRIBUTE10]
							,'T'               -- [TOP_BACK_IND] 단면 설비에 양면 제품이 계획된 경우 TOP BACK 구분
							,A.[WORK_ORDER_ID] -- [LINK_WO] 연계된 WO명 - TOP은 Back WO, Back은 TOP WO
							,A.[FP_PLAN_QTY]   -- FP Plan 수량
							,A.[FP_SNAP_QTY]   -- FP 실적 수량
					   FROM [dbo].[SY_XIF_ERP_PRODUCTION_PLAN_S] A WITH(NOLOCK)
					  WHERE A.[FP_PLAN_ID] = 'OPEN_WO_'+CONVERT(NVARCHAR(8), GETDATE(), 112) + '-00XX' + @SEQ
					    AND A.[TOP_BACK_IND] = 'B'
					;


					-- MES 전송 WO 정보 생성
					INSERT INTO [DBO].[SY_XIF_MES_WO_S]
					(
						[IF_SEQ]
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
					)
					 SELECT 'OFP0' + SUBSTRING(CONVERT(NVARCHAR(12), GETDATE(), 112), 3,6) + REPLICATE('0', 10 - LEN(NEXT VALUE FOR [LGCE_INFDEV].[DBO].[XIF_MES_SEND_SEQ])) + CAST( NEXT VALUE FOR [LGCE_INFDEV].[DBO].[XIF_MES_SEND_SEQ] AS NVARCHAR)   -- IF_SEQ      ,[IF_TYPE]
							,'S'
							,'OFP0'+'_'+ISNULL(( SELECT ISNULL(MES_SOURCE_GROUP,'') FROM SCM_FACTORY_M F  WITH(NOLOCK) WHERE F.FACTORY_ID = SOURCES.[FACTORY_ID] ),'') +'_'+'FP_WO' -- [IF_ID]
							,GETDATE() AS [IF_INS_DATE]
							,'N' --[IF_FLAG]
							,GETDATE() AS [IF_SND_DATE]
							,NULL -- [RSLT_IF_SEQ]
							,NULL--[RSLT_PROC_FLAG]
							,NULL--[RSLT_PROC_MSG]
							,'OPEN_WO_'+CONVERT(NVARCHAR(8), GETDATE(), 112) + '-00XX' + @SEQ
							,SOURCES.[PLANT_ID]
							,SOURCES.[FACTORY_ID]
							,(SELECT EQP.MES_LINE_ID
							    FROM [DBO].[SCM_EQUIPMENT_M] EQP WITH(NOLOCK)
							   WHERE EQP.EQUIPMENT_ID = SOURCES.EQUIPMENT_ID
							     AND EQP.OPERATION_ID = SOURCES.OPERATION_ID
							     AND EQP.FACTORY_ID   = SOURCES.FACTORY_ID
							     AND EQP.EQUIPMENT_TYPE = 'M'
							     AND EQP.ACTIVE_FLAG    = 'Y') AS [LINE_ID]
							,SOURCES.[OPERATION_ID]
							,SOURCES.[EQUIPMENT_ID]
							,SOURCES.[ITEM_ID]
							,SOURCES.[DEMAND_ID]
							,SOURCES.[WORK_ORDER_ID]
							,SOURCES.[PRODUCTION_TYPE]
							,SOURCES.[WORK_ORDER_SPL_ID]
							,CONVERT(NVARCHAR(50), CAST( SUBSTRING( CONVERT( VARCHAR, GETDATE(), 120 ) , 1, 10 ) + (SELECT CONCAT(' ',SUBSTRING(SEGMENT2, 1, 2),':' , SUBSTRING(SEGMENT2, 3, 2),':', SUBSTRING(SEGMENT2, 5, 2))
																													  FROM [DBO].[SCM_SYS_LOOKUP_VALUE] W  WITH(NOLOCK)
																													 WHERE W.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
																													   AND W.ACTIVE_FLAG = 'Y'
																													   AND SEGMENT1 = SOURCES.PLANT_ID) AS DATETIME), 120) -- [PLAN_DATE]
							,CONVERT(NVARCHAR(50), CAST( SUBSTRING( CONVERT( VARCHAR, GETDATE(), 120 ) , 1, 10 ) + (SELECT CONCAT(' ',SUBSTRING(SEGMENT2, 1, 2),':' , SUBSTRING(SEGMENT2, 3, 2),':', SUBSTRING(SEGMENT2, 5, 2))
																													  FROM [DBO].[SCM_SYS_LOOKUP_VALUE] W  WITH(NOLOCK)
																													 WHERE W.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
																													   AND W.ACTIVE_FLAG = 'Y'
																													   AND SEGMENT1 = SOURCES.PLANT_ID) AS DATETIME), 120) -- [START_TIME]
							,CONVERT(NVARCHAR(50), CAST( SUBSTRING( CONVERT( VARCHAR, GETDATE(), 120 ) , 1, 10 ) + (SELECT CONCAT(' ',SUBSTRING(SEGMENT2, 1, 2),':' , SUBSTRING(SEGMENT2, 3, 2)+10,':', SUBSTRING(SEGMENT2, 5, 2))
																													  FROM [DBO].[SCM_SYS_LOOKUP_VALUE] W  WITH(NOLOCK)
																													 WHERE W.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
																													   AND W.ACTIVE_FLAG = 'Y'
																													   AND SEGMENT1 = SOURCES.PLANT_ID) AS DATETIME), 120) --[END_TIME]
							,SOURCES.[PLAN_IN_QTY]
							,SOURCES.[PLAN_QTY]
							,'Y' [IS_RELEASE]
							,'WO_PST' AS [CREATE_PSN_ID]
							,GETDATE() AS [CREATE_DATE]
							,'WO_PST' --[UPDATE_PSN_ID]
							,GETDATE() --[UPDATE_DATE]
							,SOURCES.[LANE_QTY]
							,(SELECT ITEM_UOM
							    FROM [DBO].[SCM_ITEM_M]  IM WITH(NOLOCK)
							   WHERE IM.DIVISION_ID  = SOURCES.DIVISION_ID
							     AND IM.SITE_ID      = SOURCES.SITE_ID
							     AND IM.ITEM_ID      = SOURCES.ITEM_ID ) AS [UNIT]
							,SOURCES.[ORDER_TYPE]
							,ISNULL(SOURCES.[BATCH_ORDER_ID], '-')
							,CASE WHEN SOURCES.[OPERATION_ID] = 'E2000' THEN 
									ISNULL( (
												SELECT TOP 1 Z.PLANT_ID
												  FROM [DBO].[FP_PRODUCTION_PLAN_EQUIPMENT_R] Z
												 WHERE Z.OPERATION_ID = 'E4000'
												   AND Z.COMPANY_ID   = SOURCES.COMPANY_ID
												   AND Z.DIVISION_ID  = SOURCES.DIVISION_ID
												   AND Z.SITE_ID      = SOURCES.SITE_ID
												   AND Z.ITEM_ID      = SOURCES.ITEM_ID 
												 ORDER BY Z.INSERT_TIME DESC 
											),(
												SELECT TOP 1 ILA.PLANT_ID
												  FROM [DBO].[SCM_ITEM_LINE_ASSIGN_M] ILA
												 WHERE ILA.OPERATION_ID = 'E4000'
												   AND ILA.COMPANY_ID   = SOURCES.COMPANY_ID
												   AND ILA.DIVISION_ID  = SOURCES.DIVISION_ID
												   AND ILA.SITE_ID      = SOURCES.SITE_ID
												   AND ILA.ITEM_ID      = SOURCES.ITEM_ID 
												   AND ILA.ACTIVE_FLAG = 'Y'
												 ORDER BY ILA.INSERT_TIME DESC 

											) )
								 ELSE NULL
								  END AS [SLITTER_PLANT]
							,SOURCES.[MARKET]
							,(SELECT SOURCES.PLAN_IN_QTY / FLOOR(B.BATCH_LOT_SIZE)
								FROM SCM_ITEM_EQUIP_RATE_BATCH_M B WITH(NOLOCK)
							   WHERE 1=1
							     AND SOURCES.COMPANY_ID     = B.COMPANY_ID
								 AND SOURCES.DIVISION_ID    = B.DIVISION_ID
								 AND SOURCES.SITE_ID        = B.SITE_ID
								 AND SOURCES.PLANT_ID       = B.PLANT_ID
								 AND SOURCES.FACTORY_ID     = B.FACTORY_ID
								 AND SOURCES.OPERATION_ID   = B.OPERATION_ID
								 AND SOURCES.ITEM_ID        = B.ITEM_ID
								 AND B.ACTIVE_FLAG    = 'Y'
								 AND FLOOR(B.BATCH_LOT_SIZE) > 0) AS [ATTR_01]
							,(SELECT SOURCES.PLAN_IN_QTY / FLOOR(B.BATCH_LOT_SIZE)
								FROM SCM_ITEM_EQUIP_RATE_BATCH_M B WITH(NOLOCK)
							   WHERE 1=1
							     AND SOURCES.COMPANY_ID     = B.COMPANY_ID
								 AND SOURCES.DIVISION_ID    = B.DIVISION_ID
								 AND SOURCES.SITE_ID        = B.SITE_ID
								 AND SOURCES.PLANT_ID       = B.PLANT_ID
								 AND SOURCES.FACTORY_ID     = B.FACTORY_ID
								 AND SOURCES.OPERATION_ID   = B.OPERATION_ID
								 AND SOURCES.ITEM_ID        = B.ITEM_ID
								 AND B.ACTIVE_FLAG    = 'Y'
								 AND FLOOR(B.BATCH_LOT_SIZE) > 0) AS [ATTR_02]
							,CASE WHEN SOURCES.BATCH_ORDER_ID != '-' THEN 
									SUM(SOURCES.PLAN_IN_QTY) OVER (PARTITION BY SOURCES.BATCH_ORDER_ID)
								   END AS [ATTR_03]
							,SOURCES.[MARKET] AS [ATTR_04]
							,CASE WHEN EQPC.SEGMENT1 IS NOT NULL AND IMC.SEGMENT1 IS NOT NULL THEN
										'B'
									END AS TOP_BACK_IND -- ATTR_05 단면 설비에 양면 제품이 계획된 경우 TOP BACK 구분
							,RTRIM ( CASE WHEN EQPC.SEGMENT1 IS NOT NULL AND IMC.SEGMENT1 IS NOT NULL THEN
											CASE WHEN SUBSTRING(SOURCES.WORK_ORDER_ID,7,1) = 'X' THEN
													SUBSTRING(SOURCES.WORK_ORDER_ID,1,6) + 'Y' + SUBSTRING(SOURCES.WORK_ORDER_ID,8,10)
												 ELSE
													CASE WHEN SOURCES.WORK_ORDER_ID LIKE 'W%' OR SOURCES.WORK_ORDER_ID LIKE 'M%' THEN
															SUBSTRING(SOURCES.WORK_ORDER_ID,1,6) + CONVERT(NVARCHAR(2), CONVERT(NUMERIC,SUBSTRING(SOURCES.WORK_ORDER_ID,7,2)) + 50) + SUBSTRING(SOURCES.WORK_ORDER_ID,9,10)
														 ELSE
															SUBSTRING(SOURCES.WORK_ORDER_ID,1,5) + CONVERT(NVARCHAR(2), CONVERT(NUMERIC,SUBSTRING(SOURCES.WORK_ORDER_ID,6,2)) + 50) + SUBSTRING(SOURCES.WORK_ORDER_ID,8,10)
														 END
												 END
										 END) AS LINK_WO      -- ATTR_06 연계된 WO명 - TOP은 BACK WO, BACK은 TOP WO
							,RTRIM ( CASE WHEN EQPC.SEGMENT1 IS NOT NULL AND IMC.SEGMENT1 IS NOT NULL THEN
											CASE WHEN SUBSTRING(SOURCES.WORK_ORDER_SPL_ID,7,1) = 'X' THEN
													SUBSTRING(SOURCES.WORK_ORDER_SPL_ID,1,6) + 'Y' + SUBSTRING(SOURCES.WORK_ORDER_SPL_ID,8,10)
												 ELSE
													CASE WHEN SOURCES.WORK_ORDER_SPL_ID LIKE 'W%' OR SOURCES.WORK_ORDER_SPL_ID LIKE 'M%' THEN
															SUBSTRING(SOURCES.WORK_ORDER_SPL_ID,1,6) + CONVERT(NVARCHAR(2), CONVERT(NUMERIC,SUBSTRING(SOURCES.WORK_ORDER_SPL_ID,7,2)) + 50) + SUBSTRING(SOURCES.WORK_ORDER_SPL_ID,9,10)
														 ELSE
															SUBSTRING(SOURCES.WORK_ORDER_SPL_ID,1,5) + CONVERT(NVARCHAR(2), CONVERT(NUMERIC,SUBSTRING(SOURCES.WORK_ORDER_SPL_ID,6,2)) + 50) + SUBSTRING(SOURCES.WORK_ORDER_SPL_ID,8,10)
														 END
												 END
										  END) AS DETAIL_LINK_WO      -- ATTR_07 연계된 DETAIL WO명 - TOP은 BACK WO, BACK은 TOP WO
							,SOURCES.PLAN_IN_QTY AS FP_PLAN_QTY  -- ATTR_08 FP PLAN 수량
							,ISNULL((SELECT ISNULL(SUM(MPP.ACTUAL_QTY),0) FROM [DBO].[FP_MES_PRODUCTION_PLAN_M] MPP WITH(NOLOCK)
									WHERE MPP.WORK_ORDER_ID     = SOURCES.WORK_ORDER_ID
									AND MPP.WORK_ORDER_SPL_ID = SOURCES.WORK_ORDER_SPL_ID
									AND MPP.ITEM_ID           = SOURCES.ITEM_ID),0) AS FP_SNAP_QTY  -- ATTR_09 FP 실적 수량
							,SOURCES.ACTUAL_QTY
							,CASE WHEN SOURCES.WO_STATUS = 'PILOT' THEN
									'Y'
								   END
					   FROM [DBO].[FP_MES_WORK_ORDER_STATUS_H] SOURCES WITH(NOLOCK)
							LEFT OUTER JOIN [DBO].[SCM_EQUIPMENT_M]  EQP WITH(NOLOCK)
							  ON EQP.EQUIPMENT_ID = SOURCES.EQUIPMENT_ID
							 AND EQP.OPERATION_ID = SOURCES.OPERATION_ID
							 AND EQP.FACTORY_ID   = SOURCES.FACTORY_ID
							 AND EQP.EQUIPMENT_TYPE = 'M'
							 AND EQP.ACTIVE_FLAG    = 'Y'
							LEFT OUTER JOIN [DBO].[SCM_SYS_LOOKUP_VALUE]  EQPC WITH(NOLOCK)
							  ON EQPC.LOOKUP_TYPE_CODE = 'FP_COATER_TOP_COPY_OP'
							 AND EQPC.SEGMENT1         = EQP.OPERATION_ID
							 AND EQPC.SEGMENT2         = EQP.COATER_EQPT_TYPE_CODE
							 AND EQPC.ACTIVE_FLAG      = 'Y'
							LEFT OUTER JOIN [DBO].[SCM_ITEM_M]  IM WITH(NOLOCK)
							  ON IM.DIVISION_ID  = SOURCES.DIVISION_ID
							 AND IM.SITE_ID      = SOURCES.SITE_ID
							 AND IM.ITEM_ID      = SOURCES.ITEM_ID
							LEFT OUTER JOIN [DBO].[SCM_SYS_LOOKUP_VALUE]  IMC WITH(NOLOCK)
							  ON IMC.LOOKUP_TYPE_CODE = 'FP_COATER_TOP_COPY_ITEM_CLASS'
							 AND IMC.SEGMENT1         = IM.ITEM_CLASS
							 AND IMC.ACTIVE_FLAG      = 'Y'
					  WHERE CUTOFF_DATE = CONVERT(DATE, GETDATE(), 120)
					    AND PLAN_END_TIME <= CAST( SUBSTRING( CONVERT( VARCHAR, GETDATE()-1, 120 ) , 1, 10 ) + (SELECT CONCAT(' ', SUBSTRING(SEGMENT2, 1, 2), ':',SUBSTRING(SEGMENT2, 3, 2), ':',SUBSTRING(SEGMENT2, 5, 2))
																												  FROM [DBO].[SCM_SYS_LOOKUP_VALUE] W  WITH(NOLOCK)
																												 WHERE W.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
																												   AND W.ACTIVE_FLAG = 'Y'
																												   AND SEGMENT1 = SOURCES.PLANT_ID
																												) AS DATETIME)
						AND SOURCES.SITE_ID = @SITE_ID
						AND SOURCES.FACTORY_ID = @FACTORY_ID
					;



					INSERT INTO [DBO].[SY_XIF_MES_WO_S]                                                                                                                                                                                                           
					( 
							[IF_SEQ]                                                                                                                                                                                                                                  
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
							,[ATTR_05] -- 단면 설비에 양면 제품이 계획된 경우 TOP BACK 구분
							,[ATTR_06] -- 연계된 WO명 - TOP은 BACK WO, BACK은 TOP WO
							,[ATTR_07] -- 연계된 DETAIL WO명 - TOP은 BACK WO, BACK은 TOP WO
							,[ATTR_08] -- FP PLAN 수량
							,[ATTR_09] -- FP 실적 수량
							,[ATTR_10]
							,[ATTR_11]
					)
					SELECT 'OFP0' + SUBSTRING(CONVERT(NVARCHAR(12), GETDATE(), 112), 3,6) + REPLICATE('0', 10 - LEN(NEXT VALUE FOR [LGCE_INFDEV].[DBO].[XIF_MES_SEND_SEQ])) + CAST( NEXT VALUE FOR [LGCE_INFDEV].[DBO].[XIF_MES_SEND_SEQ] AS NVARCHAR)   -- IF_SEQ
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
							,[ATTR_06] -- [WO]
							,[WO_TYPE]
							,[ATTR_07] -- [WO_DETAIL]
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
							,'T'          -- [ATTR_05] -- 단면 설비에 양면 제품이 계획된 경우 TOP BACK 구분
							,[WO]         -- [ATTR_06] -- 연계된 WO명 - TOP은 BACK WO, BACK은 TOP WO
							,[WO_DETAIL]  -- [ATTR_07] -- 연계된 DETAIL WO명 - TOP은 BACK WO, BACK은 TOP WO
							,[ATTR_08] -- FP PLAN 수량
							,[ATTR_09] -- FP 실적 수량
							,[ATTR_10]
							,[ATTR_11]
					   FROM [DBO].[SY_XIF_MES_WO_S] WITH(NOLOCK)
					  WHERE PLAN_ID = 'OPEN_WO_'+CONVERT(NVARCHAR(8), GETDATE(), 112) + '-00XX' + @SEQ
						AND ATTR_05 = 'B'




					MERGE INTO [DBO].[SCM_SYS_LOOKUP_VALUE] A
					USING ( 
							SELECT @SITE_ID              AS SITE_ID
								   ,@FACTORY_ID          AS FACTORY_ID
								   ,CONVERT( NVARCHAR(8), GETDATE(), 112) AS EXEC_DATE
						  ) B
					   ON ( A.LOOKUP_TYPE_CODE = 'WO_ROLL_EXEC_FLAG'
							AND A.SEGMENT1         = B.SITE_ID
							AND A.SEGMENT2         = B.FACTORY_ID
						  )
					 WHEN MATCHED THEN
						UPDATE SET A.[ATTRIBUTE1]     = B.[EXEC_DATE]
								  ,A.[MODIFY_USER_ID] = 'PR_XIF_SCM_WO_ROLLING_PST_OPEN_WO'        
								  ,A.[MODIFY_DATE]    = GETDATE() 
					 WHEN NOT MATCHED THEN
						INSERT ([LOOKUP_TYPE_CODE]
							  ,[SEGMENT1]
							  ,[SEGMENT2]
							  ,[SEGMENT3]
							  ,[SEGMENT4]
							  ,[SEGMENT5]
							  ,[ACTIVE_FLAG]
							  ,[CREATE_USER_ID]
							  ,[CREATE_DATE]
							  ,[MODIFY_USER_ID]
							  ,[MODIFY_DATE]
							  ,[ATTRIBUTE1]
						) VALUES (
							'WO_ROLL_EXEC_FLAG'
							,B.SITE_ID
							,B.FACTORY_ID
							,'-'
							,'-'
							,'-'
							,'Y'
							,'PR_XIF_SCM_WO_ROLLING_PST_OPEN_WO'
							,GETDATE()
							,'PR_XIF_SCM_WO_ROLLING_PST_OPEN_WO'
							,GETDATE()
							,B.[EXEC_DATE]
						);

				FETCH NEXT FROM CUR_SITE INTO  @SITE_ID
											  ,@FACTORY_ID 

				END;
			
			CLOSE CUR_SITE;
			DEALLOCATE CUR_SITE;  
		
		COMMIT TRAN

		EXEC PR_XIF_LOG @v_proc_name, NULL, 'END',   NULL, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
		
	END TRY

	BEGIN CATCH

		-- 에러나도 로그는 인서트
		SET @v_descr = ERROR_MESSAGE()
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate

	END CATCH

END



