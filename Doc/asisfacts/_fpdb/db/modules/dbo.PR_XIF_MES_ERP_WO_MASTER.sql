                                                                                                                                                                                                                                                                     
--CREATE PROCEDURE [dbo].[PR_XIF_MES_ERP_WO_MASTER]
CREATE PROCEDURE [dbo].[PR_XIF_MES_ERP_WO_MASTER]
                                                                                                                                                                                                                                                                     
-- ================================================================================================                                                                                                                                                                  
-- Program ID          : FP02020                                                                                                                                                                                                                                 
-- Program Name        : PR_XIF_MES_ERP_WO_MASTER                                                                                                                                                                                                                             
-- Param               :                                                                                                                                                                                                                                             
-- Batch Period        : 1 Day                                                                                                                                                                                                                                       
-- Description         :                                                                                                                                                                                                                                             
--                                                                                                                                                                                                                                                                   
-- Source System       : FP SDB                                                                                                                                                                                                                                      
-- Destination System  : FP SDB                                                                                                                                                                                                                                     
-- Source Table        : FP_PRODUCTION_PLAN_EQUIPMENT_R                                                                                                                                                                                                              
-- Destination Table   : FP_MES_PRODUCTION_PLAN_M, FP_ERP_PRODUCTION_PLAN_M
--                                                                                                                                                                                                                                                                   
-- Create(Update) Date : 2018.04.29
-- Update Date         : 2018.07.25  kimcd  1.4
--                       2022.11.17  leeseongmin  1.5

-- Author              : 김 춘 동
-- Version             : 1.0  2018-04-29 kimcd 정상적으로 MES, ERP에 전송된 경우 Master 정보 갱신
-- Version             : 1.1  2018-05-23 kimcd History 정보도 형성하도록 함
-- Version             : 1.2  2018-05-26 kimcd ERP History 정보에 MES Line 정보 추가 - ATTRIBUTE1
-- Version             : 1.3  2018-07-05 kimcd 변경 사용자 명 - release 사람으로 변경
--                                             S-TEST이고 노칭 공정인 경우 첫 테스트 공정으로 표시
--                       1.4  2018-07-25 kimcd fp_production_type NULL 처리
--                       1.5 2022-11-17 leeseonmgin  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
-- ================================================================================================                                                                                                                                                                  

-- PARAM PLAN_ID
@P_FP_PLAN_ID NVARCHAR(50) = NULL

AS 

BEGIN     
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED 
    SET NOCOUNT ON                                                                                                                                                                                                                                                   
	SET XACT_ABORT ON                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                     
	-- LOG 용 변수 설정                                                                                                                                                                                                                                                   
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_MES_ERP_WO_MASTER'                                                                                                                                                                                                            
	DECLARE @v_descr     NVARCHAR(250)                                                                                                                                                                                                                                
	DECLARE @v_count     INTEGER	  = 0                                                                                                                                                                                                                            
	DECLARE @sysdate     DATETIME     = GETDATE()  
	DECLARE @plan_user_id  NVARCHAR(150)  -- 2018-07-05 kimcd 변경 사용자 명 - release 사람으로 변경
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
		SELECT @plan_user_id = UPDATE_ID
		FROM   SCM_FP_PLAN_H WITH(NOLOCK)
		WHERE  PLAN_ID = @P_FP_PLAN_ID  -- 2018-07-05 kimcd 변경 사용자 명 - release 사람으로 변경
  
		SET @v_temp1 = 'MERGE FP_MES_PRODUCTION_PLAN_M'
		MERGE INTO DBO.FP_MES_PRODUCTION_PLAN_M A  /* 2018-04-28 kimcd 기존 계획과 다른 work order만 전송하고, work order master를 갱신함*/
		USING (  SELECT SO.[INSTANCE_ID]
						,SO.[FP_PLAN_ID]
						,SO.[COMPANY_ID]
						,SO.[DIVISION_ID]
						,SO.[SITE_ID]
						,SO.[PLANT_ID]
						,SO.[FACTORY_ID]
						,SO.[WORK_ORDER_SPL_ID]
						,SO.[WORK_ORDER_ID]
						,SO.[BATCH_ORDER_ID]
						,SO.[BIN_ORDER_ID]
						,SO.[ORDER_TYPE]
						,SO.[SCP_TARGET_ID]
						,SO.[DEMAND_ID]
						,SO.[ITEM_ID]
						,SO.[LANE_QTY]
						,SO.[TOP_ITEM_ID]
						,SO.[TOP_WORK_ORDER_ID]
						,SO.[LINE_ID]
						,SO.[OPERATION_ID]
						,SO.[ELECTRODE_TYPE]
						,SO.[WORK_CENTER_ID]
						,SO.[EQUIPMENT_ID]
						,SO.[PLAN_DATE]
						,SO.[START_TIME]
						,SO.[END_TIME]
						,MW.[OUT_QTY]
						,MW.[IN_QTY]
						,SO.[ITEM_UOM]
						,SO.[ROLL_IN_QTY]
						,SO.[ROLL_OUT_QTY]
						,SO.[JR_IN_QTY]
						,SO.[JR_OUT_QTY]
						,SO.[BATCH_QTY]
						,SO.[BATCH_SUM_QTY]
						,SO.[FIX_TYPE]
						,SO.[PRODUCTION_TYPE]
						,SO.[BOM_VERSION_ID]
						,MW.[SLITTER_PLANT] AS [SLIT_PLANT_ID]
						,ISNULL(SO.MARKET,'D') AS MARKET
						,CASE WHEN SO.INSTANCE_ID = 'KR_CELL_M_P' THEN
						'Y'
						END AS PILOT_YN
						,ISNULL(SO.FP_PRODUCTION_TYPE,SO.PRODUCTION_TYPE) AS FP_PRODUCTION_TYPE  -- 2018-07-25 kimcd NULL 처리
						,(  SELECT TOP 1 'Y'
							FROM   SCM_SYS_LOOKUP_VALUE  SLV WITH(NOLOCK)
							WHERE  SLV.LOOKUP_TYPE_CODE = 'FIRST_TEST_WO'
							AND    SLV.SEGMENT1         = SO.INSTANCE_ID
							AND    SLV.SEGMENT2         = SO.FP_PRODUCTION_TYPE
							AND    SLV.SEGMENT3         = SO.OPERATION_ID
							AND    SLV.ACTIVE_FLAG      = 'Y' ) AS FIRST_TEST_WO  -- 2018-07-05 kimcd 한국 S-TEST 노칭은 최초 WO로 표시
						,SO.WORK_REQUEST_MODEL_ID   -- 2022-11-17 leeseonmgin  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
						,SO.[VERSION]               -- 2022-11-17 leeseonmgin  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
						,SO.PROD_SEQ                -- 2022-11-17 leeseonmgin  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
						,SO.PLM_EC_NO               -- 2022-11-17 leeseonmgin  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
					FROM   DBO.FP_PRODUCTION_PLAN_EQUIPMENT_R SO WITH(NOLOCK)
							LEFT OUTER JOIN [DBO].[SY_XIF_MES_WO_S] MW WITH(NOLOCK)
							ON SO.FP_PLAN_ID     = MW.PLAN_ID
							AND SO.WORK_ORDER_ID = MW.WO
							AND SO.WORK_ORDER_SPL_ID = MW.WO_DETAIL
							AND SO.FACTORY_ID    = MW.BUILNO
					WHERE  SO.FP_PLAN_ID = ISNULL(@P_FP_PLAN_ID,'0')
					AND    FIX_TYPE IN ( 'F', 'N')
				) B
		ON  (     A.[WORK_ORDER_SPL_ID] = B.[WORK_ORDER_SPL_ID]
				AND A.[WORK_ORDER_ID]     = B.[WORK_ORDER_ID] )
		WHEN MATCHED THEN
			UPDATE SET   A.[FACTORY_ID]        = B.[FACTORY_ID]       
						,A.[BATCH_ORDER_ID]    = B.[BATCH_ORDER_ID]   
						,A.[ORDER_TYPE]        = B.[ORDER_TYPE]       
						,A.[LANE_QTY]          = B.[LANE_QTY]         
						,A.[LINE_ID]           = B.[LINE_ID]          
						,A.[EQUIPMENT_ID]      = B.[EQUIPMENT_ID]     
						,A.[START_TIME]        = B.[START_TIME]       
						,A.[END_TIME]          = B.[END_TIME]         
						,A.[PLAN_QTY]          = ISNULL(B.[OUT_QTY], A.[PLAN_QTY])
						,A.[PLAN_IN_QTY]       = ISNULL(B.[IN_QTY], A.[PLAN_IN_QTY])
						,A.[ROLL_IN_QTY]       = B.[ROLL_IN_QTY]
						,A.[ROLL_OUT_QTY]      = B.[ROLL_OUT_QTY]
						,A.[JR_IN_QTY]         = B.[JR_IN_QTY]
						,A.[JR_OUT_QTY]        = B.[JR_OUT_QTY]
						,A.[BATCH_QTY]         = B.[BATCH_QTY]
						,A.[BATCH_SUM_QTY]     = B.[BATCH_SUM_QTY]
						,A.[FIX_TYPE]          = B.[FIX_TYPE]         
						,A.[PRODUCTION_TYPE]   = B.[PRODUCTION_TYPE]  
						,A.[SLIT_PLANT_ID]     = B.[SLIT_PLANT_ID]    
						,A.[MARKET]            = B.[MARKET]           
						,A.[UPDATE_FP_PLAN_ID] = B.[FP_PLAN_ID]
						,A.[UPDATE_ID]         = @plan_user_id  -- 2018-07-05 kimcd 변경 사용자 명 - release 사람으로 변경
						,A.[UPDATE_TIME]       = GETDATE() 
						,A.[OPERATION_ID]      = B.[OPERATION_ID]
						,A.[ELECTRODE_TYPE]    = B.[ELECTRODE_TYPE]
						,A.[ATTRIBUTE2]        = CONVERT(NVARCHAR(50), B.[PLAN_DATE], 120) 
						,A.[ATTRIBUTE3]        = ISNULL(B.PILOT_YN, '-')     -- PILOT 여부
						,A.[ATTRIBUTE4]        = ISNULL(B.TOP_ITEM_ID, '-')  -- TOP ITEM ID
						,A.[ATTRIBUTE5]        = B.FP_PRODUCTION_TYPE        -- FP Demand Type						
						,A.WORK_REQUEST_MODEL_ID   = B.WORK_REQUEST_MODEL_ID   -- 2022-11-17 leeseonmgin  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
						,A.[VERSION]               = B.[VERSION]               -- 2022-11-17 leeseonmgin  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
						,A.PROD_SEQ                = B.PROD_SEQ                -- 2022-11-17 leeseonmgin  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
						,A.PLM_EC_NO               = B.PLM_EC_NO               -- 2022-11-17 leeseonmgin  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
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
					,[ATTRIBUTE1]  -- FP-058 초기 계획 수량 kimcd 2017-05-25
					,[INSERT_FP_PLAN_ID]
					,[INSERT_ID]
					,[INSERT_TIME]
					,[UPDATE_FP_PLAN_ID]
					,[UPDATE_ID]
					,[UPDATE_TIME]
					,[ATTRIBUTE2]      -- PLAN_DATE
					,[ATTRIBUTE3]      -- PILOT 여부
					,[ATTRIBUTE4]      -- TOP ITEM ID
					,[ATTRIBUTE5]      -- FP Demand Type
					,[ATTRIBUTE6]      -- FIRST_TEST_WO 2018-07-05 kimcd S TEST에 노칭은 테스트 첫 WO로 표시
					,WORK_REQUEST_MODEL_ID   -- 2022-11-17 leeseonmgin  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
					,[VERSION]               -- 2022-11-17 leeseonmgin  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
					,PROD_SEQ                -- 2022-11-17 leeseonmgin  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
					,PLM_EC_NO               -- 2022-11-17 leeseonmgin  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
					)
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
					,B.[OUT_QTY]
					,B.[IN_QTY]
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
					,B.[IN_QTY] -- FP-058 초기 계획 수량 kimcd 2017-05-25
					,B.[FP_PLAN_ID]  -- [INSERT_FP_PLAN_ID]
					,@plan_user_id  -- 2018-07-05 kimcd 변경 사용자 명 - release 사람으로 변경
					,GETDATE()
					,B.[FP_PLAN_ID]  -- [UPDATE_FP_PLAN_ID]
					,@plan_user_id  -- 2018-07-05 kimcd 변경 사용자 명 - release 사람으로 변경
					,GETDATE()
					,CONVERT(NVARCHAR(50), B.[PLAN_DATE], 120)  -- PLAN_DATE ATTRIBUTE2
					,ISNULL(B.PILOT_YN, '-')     -- PILOT 여부        ATTRIBUTE3
					,ISNULL(B.TOP_ITEM_ID, '-')  -- TOP ITEM ID       ATTRIBUTE4
					,B.FP_PRODUCTION_TYPE        -- FP Demand Type    ATTRIBUTE5
					,B.FIRST_TEST_WO             -- FIRST TEST WO     ATTRIBUTE6 2018-07-05 kimcd S TEST에 노칭은 테스트 첫 WO로 표시
					,B.WORK_REQUEST_MODEL_ID   -- 2022-11-17 leeseonmgin  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
					,B.[VERSION]               -- 2022-11-17 leeseonmgin  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
					,B.PROD_SEQ                -- 2022-11-17 leeseonmgin  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
					,B.PLM_EC_NO               -- 2022-11-17 leeseonmgin  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
					);

		SET @ROWCOUNT = @@ROWCOUNT

		SET @v_temp1 = 'MERGE FP_ERP_PRODUCTION_PLAN_M'
		MERGE FP_ERP_PRODUCTION_PLAN_M T
		USING ( SELECT FPP.FACTORY_ID
					, FPP.WORK_ORDER_ID
					, FPP.TOP_ITEM_ID
					, FPP.ITEM_ID
					, FPP.ELECTRODE_TYPE
					, FPP.ROLL_IN_QTY
					, FPP.ROLL_OUT_QTY
					, FPP.JR_IN_QTY
					, FPP.JR_OUT_QTY
					, FPP.BATCH_QTY
					, ISNULL(FPP.FP_PRODUCTION_TYPE,FPP.PRODUCTION_TYPE) AS FP_PRODUCTION_TYPE -- 2018-07-25 kimcd NULL 처리
					, FPP.FP_PLAN_ID    AS UPDATE_FP_PLAN_ID
					, @plan_user_id     AS UPDATE_ID   -- 2018-07-05 kimcd 변경 사용자 명 - release 사람으로 변경
					, GETDATE()         AS UPDATE_TIME
			  FROM      FP_PRODUCTION_PLAN_R             FPP WITH(NOLOCK)
			  WHERE     FPP.FP_PLAN_ID    = ISNULL(@P_FP_PLAN_ID,'0')
			  AND       FPP.FIX_TYPE IN ( 'F', 'N')  -- 2018-05-23 kimcd 확정 계획만 Master에 입력
			  AND       NOT EXISTS ( SELECT 1
									   FROM   SY_XIF_ERP_PRODUCTION_PLAN_S     XES WITH(NOLOCK)
									   WHERE     XES.FP_PLAN_ID    = FPP.FP_PLAN_ID
									   AND       XES.WORK_ORDER_ID = FPP.WORK_ORDER_ID )
			 ) B
		ON  T.[WORK_ORDER_ID] = B.WORK_ORDER_ID
		WHEN MATCHED THEN
		 UPDATE   SET T.FACTORY_ID     = B.FACTORY_ID
					, T.TOP_ITEM_ID        = B.TOP_ITEM_ID
					, T.ELECTRODE_TYPE     = B.ELECTRODE_TYPE
					, T.ROLL_IN_QTY        = B.ROLL_IN_QTY
					, T.ROLL_OUT_QTY       = B.ROLL_OUT_QTY
					, T.JR_IN_QTY          = B.JR_IN_QTY
					, T.JR_OUT_QTY         = B.JR_OUT_QTY
					, T.BATCH_QTY          = B.BATCH_QTY
					, T.FIX_TYPE           = 'Y'
					, T.FP_PRODUCTION_TYPE = B.FP_PRODUCTION_TYPE
					, T.PUBLISH_TYPE       = 'Keep'
					, T.ORG_PLAN_IN_QTY    = T.PLAN_IN_QTY     -- 2018-05-23 kimcd 수량 유지의 경우 기존 수량을 현재 계획수량으로 함
					, T.ORG_PLAN_QTY       = T.PLAN_QTY        -- 2018-05-23 kimcd 수량 유지의 경우 기존 수량을 현재 계획수량으로 함
					, T.UPDATE_FP_PLAN_ID  = B.UPDATE_FP_PLAN_ID
					, T.UPDATE_ID          = B.UPDATE_ID
					, T.UPDATE_TIME        = B.UPDATE_TIME;

		SET @ROWCOUNT = @ROWCOUNT + @@ROWCOUNT

		-- 2018-05-23 kimcd 이력 정보 Release할 때 형성함. 이력을 UI에서 조회하기 위해 모두 입력함. 수정 시작
		SET @v_temp1 = 'MERGE FP_ERP_PRODUCTION_PLAN_H'
		--FP_ERP_PRODUCTION_PLAN_H 정보에 갱신
		MERGE FP_ERP_PRODUCTION_PLAN_H T
		USING ( 
				SELECT FPP.FP_PLAN_ID
						, FPP.INSTANCE_ID
						, FM.COMPANY_ID
						, FM.DIVISION_ID
						, FM.SITE_ID
						, FM.PLANT_ID
						, FM.FACTORY_ID
						, FPP.WORK_ORDER_ID
						, FPP.BATCH_ORDER_ID
						, 'W'  ORDER_TYPE
						, FPP.TOP_ITEM_ID
						, FPP.ITEM_ID
						, FPP.LANE_QTY
						, ISNULL(FPP.LINE_ID, XES.LINE_ID)     AS LINE_ID
						, FPP.OPERATION_ID
						, FPP.ELECTRODE_TYPE
						, ISNULL(XES.WORK_CENTER_ID, FEM.WORK_CENTER_ID) AS WORK_CENTER_ID
						, FPP.PLAN_DATE
						, FPP.START_TIME
						, FPP.END_TIME
						, FEM.PLAN_QTY     AS ORG_PLAN_QTY
						, FEM.PLAN_IN_QTY  AS ORG_PLAN_IN_QTY
						, ISNULL(XES.PLAN_QTY, FEM.PLAN_QTY)         AS PLAN_QTY
						, ISNULL(XES.PLAN_IN_QTY, FEM.PLAN_IN_QTY)   AS PLAN_IN_QTY
						, FPP.ROLL_IN_QTY
						, FPP.ROLL_OUT_QTY
						, FPP.JR_IN_QTY
						, FPP.JR_OUT_QTY
						, FPP.BATCH_QTY
						, 'Y'              AS FIX_TYPE
						, FPP.PRODUCTION_TYPE
						, ISNULL(FPP.FP_PRODUCTION_TYPE, FPP.PRODUCTION_TYPE) AS FP_PRODUCTION_TYPE -- 2018-07-25 kimcd NULL 처리
						, FPP.MARKET
						, ISNULL(XES.SLITTER_PLANT,FEM.SLIT_PLANT_ID) AS SLIT_PLANT_ID
						, ISNULL(XES.ATTRIBUTE1,FEM.PUBLISH_TYPE)     AS PUBLISH_TYPE
						, XES.LINE_ID  AS MES_LINE_ID -- 2018-05-26 kimcd MES 라인 정보 추가
						, @plan_user_id     AS INSERT_ID   -- 2018-07-05 kimcd 변경 사용자 명 - release 사람으로 변경
						, GETDATE() AS INSERT_TIME
						, @plan_user_id     AS UPDATE_ID   -- 2018-07-05 kimcd 변경 사용자 명 - release 사람으로 변경
						, GETDATE() AS UPDATE_TIME
					FROM FP_PRODUCTION_PLAN_R  FPP WITH(NOLOCK) 
						LEFT OUTER JOIN SY_XIF_ERP_PRODUCTION_PLAN_S   XES WITH(NOLOCK)
									ON FPP.FP_PLAN_ID    = XES.FP_PLAN_ID
									AND FPP.WORK_ORDER_ID = XES.WORK_ORDER_ID
						LEFT OUTER JOIN FP_ERP_PRODUCTION_PLAN_M		FEM WITH(NOLOCK)
									ON FPP.WORK_ORDER_ID = FEM.WORK_ORDER_ID
							INNER JOIN SCM_FACTORY_M                    FM WITH(NOLOCK)
									ON FM.FACTORY_ID     = FPP.FACTORY_ID
				WHERE  FPP.FP_PLAN_ID = ISNULL(@P_FP_PLAN_ID,'0')
				AND    FPP.FIX_TYPE IN ( 'F', 'N')
				AND    FPP.ORDER_TYPE = 'W'
			) B
		ON T.[FP_PLAN_ID]     = B.FP_PLAN_ID
		AND T.[WORK_ORDER_ID] = B.WORK_ORDER_ID
		WHEN MATCHED THEN
			UPDATE SET T.FACTORY_ID     = B.FACTORY_ID
					, T.BATCH_ORDER_ID     = B.BATCH_ORDER_ID
					, T.ORDER_TYPE         = B.ORDER_TYPE
					, T.TOP_ITEM_ID        = B.TOP_ITEM_ID
					, T.LANE_QTY           = B.LANE_QTY
					, T.LINE_ID            = B.LINE_ID
					, T.OPERATION_ID       = B.OPERATION_ID
					, T.ELECTRODE_TYPE     = B.ELECTRODE_TYPE
					, T.WORK_CENTER_ID     = B.WORK_CENTER_ID
					, T.PLAN_DATE          = B.PLAN_DATE
					, T.START_TIME         = B.START_TIME
					, T.END_TIME           = B.END_TIME
					, T.ORG_PLAN_QTY       = B.ORG_PLAN_QTY
					, T.ORG_PLAN_IN_QTY    = B.ORG_PLAN_IN_QTY
					, T.PLAN_QTY           = B.PLAN_QTY
					, T.PLAN_IN_QTY        = B.PLAN_IN_QTY
					, T.ROLL_IN_QTY        = B.ROLL_IN_QTY
					, T.ROLL_OUT_QTY       = B.ROLL_OUT_QTY
					, T.JR_IN_QTY          = B.JR_IN_QTY
					, T.JR_OUT_QTY         = B.JR_OUT_QTY
					, T.BATCH_QTY          = B.BATCH_QTY
					, T.FIX_TYPE           = B.FIX_TYPE
					, T.PRODUCTION_TYPE    = B.PRODUCTION_TYPE
					, T.FP_PRODUCTION_TYPE = B.FP_PRODUCTION_TYPE
					, T.MARKET             = B.MARKET
					, T.SLIT_PLANT_ID      = B.SLIT_PLANT_ID
					, T.PUBLISH_TYPE       = B.PUBLISH_TYPE
					, T.ATTRIBUTE1         = B.MES_LINE_ID   -- 2018-05-26 kimcd MES 라인 정보 추가
					, T.UPDATE_ID          = B.UPDATE_ID
					, T.UPDATE_TIME        = B.UPDATE_TIME
		WHEN NOT MATCHED THEN
			INSERT (
					FP_PLAN_ID
					, INSTANCE_ID
					, COMPANY_ID
					, DIVISION_ID
					, SITE_ID
					, PLANT_ID
					, FACTORY_ID
					, WORK_ORDER_ID
					, BATCH_ORDER_ID
					, ORDER_TYPE
					, TOP_ITEM_ID
					, ITEM_ID
					, LANE_QTY
					, LINE_ID
					, OPERATION_ID
					, ELECTRODE_TYPE
					, WORK_CENTER_ID
					, PLAN_DATE
					, START_TIME
					, END_TIME
					, ORG_PLAN_QTY
					, ORG_PLAN_IN_QTY
					, PLAN_QTY
					, PLAN_IN_QTY
					, ROLL_IN_QTY
					, ROLL_OUT_QTY
					, JR_IN_QTY
					, JR_OUT_QTY
					, BATCH_QTY
					, FIX_TYPE
					, PRODUCTION_TYPE
					, FP_PRODUCTION_TYPE
					, MARKET
					, SLIT_PLANT_ID
					, PUBLISH_TYPE
					, ATTRIBUTE1  -- 2018-05-26 kimcd MES 라인 정보 추가
					, INSERT_ID
					, INSERT_TIME
					, UPDATE_ID
					, UPDATE_TIME
			) VALUES (
					B.FP_PLAN_ID
					, B.INSTANCE_ID
					, B.COMPANY_ID
					, B.DIVISION_ID
					, B.SITE_ID
					, B.PLANT_ID
					, B.FACTORY_ID
					, B.WORK_ORDER_ID
					, B.BATCH_ORDER_ID
					, B.ORDER_TYPE
					, B.TOP_ITEM_ID
					, B.ITEM_ID
					, B.LANE_QTY
					, B.LINE_ID
					, B.OPERATION_ID
					, B.ELECTRODE_TYPE
					, B.WORK_CENTER_ID
					, B.PLAN_DATE
					, B.START_TIME
					, B.END_TIME
					, B.ORG_PLAN_QTY
					, B.ORG_PLAN_IN_QTY
					, B.PLAN_QTY
					, B.PLAN_IN_QTY
					, B.ROLL_IN_QTY
					, B.ROLL_OUT_QTY
					, B.JR_IN_QTY
					, B.JR_OUT_QTY
					, B.BATCH_QTY
					, B.FIX_TYPE
					, B.PRODUCTION_TYPE
					, B.FP_PRODUCTION_TYPE
					, B.MARKET
					, B.SLIT_PLANT_ID
					, B.PUBLISH_TYPE
					, B.MES_LINE_ID -- 2018-05-26 kimcd MES 라인 정보 추가
					, B.INSERT_ID
					, B.INSERT_TIME
					, B.UPDATE_ID
					, B.UPDATE_TIME
			) 
		;


		SET @ROWCOUNT = @ROWCOUNT + @@ROWCOUNT
		-- 2018-05-23 kimcd 이력 정보 Release할 때 형성함. 이력을 UI에서 조회하기 위해 모두 입력함. 수정 끝

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
                                                                                                                                                                                                                                                                     

