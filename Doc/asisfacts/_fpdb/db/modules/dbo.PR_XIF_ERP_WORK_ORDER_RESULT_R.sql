
CREATE PROCEDURE [dbo].[PR_XIF_ERP_WORK_ORDER_RESULT_R]

-- ================================================================================================
-- Program ID          : FP02640
-- Program Name        : PR_XIF_ERP_WORK_ORDER_RESULT_R
-- Param               :
-- Batch Period        : 1Hour
-- Description         :
--
-- Source System       : ERP
-- Destination System  : FP SDB
-- Source Table        : XIF_ERP_PRODUCTION_PLAN_LOG, XIF_ERP_WORK_ORDER_RESULT_R
-- Destination Table   : FP_ERP_PRODUCTION_PLAN_H, FP_ERP_PRODUCTION_PLAN_M
--
-- Create(Update) Date : 2019.08.15
-- Author              : PIYONG
-- Version             : 1.0
--                       1.1 2018-05-23 kimcd SY_XIF_ERP_WORK_ORDER_RESULT_R 정보 수신 방식을 Merge로 변경
--                                            계획 결과 전송에서 이력 정보를 무조건 형성하도록 하여 수정 반영함
--                       1.2 2018-05-26 kimcd MES 라인 정보 추가 ATTRIBUTE1
--                       1.3 2018-07-05 kimcd 변경 사용자 명 - release 사람으로 변경
--                                            한국 Cell S-TEST 노칭은 첫 테스트 WO로 표시
--                       1.4 2018-07-24 kimcd TOP Item ID를 FP 계획에서 못 찾는 경우 MES WO Master 사용
--                       1.5 2019-08-15 kimcd 자동 Rolling WO에서 Electrode 값이 누락됨 MES WO Master로 NVL 처리
-- ================================================================================================

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_ERP_WORK_ORDER_RESULT_R'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	   = 0
	DECLARE @sysdate     DATETIME2     = GETDATE()
	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)

	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

	BEGIN TRY				

		BEGIN TRAN
		-- ================================================
		-- 로직 추가
		-- ================================================
			--미수신 정보 Transfer_flag를 P로 갱신
			UPDATE SY_XIF_ERP_WORK_ORDER_RESULT_R
			   SET TRANSFER_FLAG = 'P'
			 WHERE ISNULL(TRANSFER_FLAG,'N') = 'N'


			UPDATE SY_XIF_ERP_PRODUCTION_PLAN_LOG
			   SET TRANSFER_FLAG = 'P'
			 WHERE ISNULL(TRANSFER_FLAG,'N') = 'N'



			--XIF_ERP_PRODUCTION_PLAN_LOG 미수신된 정보를 추출
			-- 2018-05-23 kimcd Insert 문장에서 Merge 문장으로 수정 시작
			MERGE FP_ERP_PRODUCTION_PLAN_H  T
			USING (SELECT B.FP_PLAN_ID
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
						, B.ERP_IF_STATUS
						, B.FP_IF_RETURN
						, B.ERP_IF_RETURN
						, B.MES_LINE_ID   -- 2018-05-26 kimcd MES 라인 정보 추가
						, B.INSERT_ID
						, B.INSERT_TIME
						, B.UPDATE_ID
						, B.UPDATE_TIME
					FROM   ( SELECT  XES.FP_PLAN_ID
								   , ISNULL(FPP.INSTANCE_ID, 'MANUAL')    AS INSTANCE_ID
								   , FM.COMPANY_ID
								   , FM.DIVISION_ID
								   , FM.SITE_ID
								   , FM.PLANT_ID
								   , FM.FACTORY_ID
								   , XES.WORK_ORDER_ID
								   , XES.BATCH_ORDER_ID
								   , 'W'  ORDER_TYPE
								   , ISNULL(ISNULL(FPP.TOP_ITEM_ID, MPP.ATTRIBUTE4), XES.ITEM_ID ) AS TOP_ITEM_ID  -- 2018-07-24 kimcd TOP Item ID 조회 방식 변경
								   , XES.ITEM_ID
								   , FPP.LANE_QTY
								   , ISNULL(ISNULL( FPP.LINE_ID, MPP.LINE_ID), XES.LINE_ID) AS LINE_ID -- 2018-07-24 kimcd Line ID 조회 방식 변경
								   , XES.OPERATION_ID
								   , ISNULL(FPP.ELECTRODE_TYPE,MPP.ELECTRODE_TYPE) AS ELECTRODE_TYPE -- 2019-08-15 kimcd 전극 유형 NULL 처리
								   , XES.WORK_CENTER_ID
								   , ISNULL(FPP.PLAN_DATE, CONVERT(DATETIME, SUBSTRING(XES.PLAN_DATE, 1, 8))) AS PLAN_DATE
								   , ISNULL(FPP.START_TIME, CONVERT(DATETIME, SUBSTRING(XES.START_TIME,1,8) + ' ' + SUBSTRING(XES.START_TIME,9,2)  + ':' + SUBSTRING(XES.START_TIME,11,2) + ':' + SUBSTRING(XES.START_TIME,13,2))) AS START_TIME
								   , ISNULL(FPP.END_TIME, CONVERT(DATETIME, SUBSTRING(XES.END_TIME,1,8) + ' ' + SUBSTRING(XES.END_TIME,9,2)  + ':' + SUBSTRING(XES.END_TIME,11,2) + ':' + SUBSTRING(XES.END_TIME,13,2))) AS END_TIME
								   , FEM.PLAN_QTY  AS ORG_PLAN_QTY
								   , FEM.PLAN_IN_QTY  AS ORG_PLAN_IN_QTY
								   , XES.PLAN_QTY
								   , XES.PLAN_IN_QTY
								   , FPP.ROLL_IN_QTY
								   , FPP.ROLL_OUT_QTY
								   , FPP.JR_IN_QTY
								   , FPP.JR_OUT_QTY
								   , FPP.BATCH_QTY
								   , XES.FIX_TYPE
								   , ISNULL(XES.ORDER_TYPE,FPP.PRODUCTION_TYPE) AS PRODUCTION_TYPE
								   , ISNULL(ISNULL(FPP.FP_PRODUCTION_TYPE,MPP.ATTRIBUTE5), XES.ORDER_TYPE) AS FP_PRODUCTION_TYPE -- 2018-07-24 kimcd FP PRODUCTION TYPE 조회 방식 변경
								   , ISNULL(XES.MARKET,FPP.MARKET)              AS MARKET
								   , XES.SLITTER_PLANT AS SLIT_PLANT_ID
								   , XES.ATTRIBUTE1 AS PUBLISH_TYPE
								   , XEL.MTYPE      AS ERP_IF_STATUS
								   , XEL.FP_MESSAGE AS FP_IF_RETURN
								   , XEL.MESSAGE    AS ERP_IF_RETURN
								   , XES.LINE_ID    AS MES_LINE_ID   -- 2018-05-26 kimcd MES 라인 정보 추가
								   , ISNULL(SFP.UPDATE_ID,XES.CREATE_USER_ID)   AS INSERT_ID  -- 2018-07-05 kimcd 변경 사용자 명 - release 사람으로 변경으로 추가
								   , GETDATE()      AS INSERT_TIME
								   , ISNULL(SFP.UPDATE_ID,XES.CREATE_USER_ID)   AS UPDATE_ID  -- 2018-07-05 kimcd 변경 사용자 명 - release 사람으로 변경으로 추가
								   , GETDATE()      AS UPDATE_TIME 
								   , ROW_NUMBER()   OVER ( PARTITION BY XES.FP_PLAN_ID, XES.WORK_ORDER_ID ORDER BY XES.IFSEQNO DESC ) ROWNUMS
							  FROM SY_XIF_ERP_PRODUCTION_PLAN_S XES WITH(NOLOCK)
								   LEFT OUTER JOIN FP_PRODUCTION_PLAN_R FPP WITH(NOLOCK)
												ON FPP.FP_PLAN_ID    = XES.FP_PLAN_ID
											   AND FPP.WORK_ORDER_ID = XES.WORK_ORDER_ID
										INNER JOIN SY_XIF_ERP_PRODUCTION_PLAN_LOG   XEL WITH(NOLOCK)
												ON XEL.FPPLANID      = XES.FP_PLAN_ID
											   AND XEL.WORKORDERID   = XES.WORK_ORDER_ID
											   AND XEL.TRANSFER_FLAG = 'P'		
								   LEFT OUTER JOIN FP_ERP_PRODUCTION_PLAN_M FEM WITH(NOLOCK)
												ON XEL.WORKORDERID = FEM.WORK_ORDER_ID
								   LEFT OUTER JOIN FP_MES_PRODUCTION_PLAN_M MPP WITH(NOLOCK)  -- 2018-07-24 kimcd MES WORK ORDER MASTER 추가
												ON XEL.WORKORDERID = MPP.WORK_ORDER_ID
										INNER JOIN SCM_FACTORY_M FM WITH(NOLOCK)
												ON FM.FACTORY_ID     = XES.FACTORY_ID
								   LEFT OUTER JOIN SCM_FP_PLAN_H SFP WITH(NOLOCK)  -- 2018-07-05 kimcd 변경 사용자 명 - release 사람으로 변경으로 추가
												ON SFP.PLAN_ID = XES.FP_PLAN_ID ) B
				WHERE B.ROWNUMS = 1 ) B
			ON  T.FP_PLAN_ID    = B.FP_PLAN_ID
			AND T.WORK_ORDER_ID = B.WORK_ORDER_ID
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
					 , T.ERP_IF_STATUS      = B.ERP_IF_STATUS
					 , T.FP_IF_RETURN       = B.FP_IF_RETURN
					 , T.ERP_IF_RETURN      = B.ERP_IF_RETURN
					 , T.ATTRIBUTE1         = B.MES_LINE_ID -- 2018-05-26 kimcd MES 라인 정보 추가
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
					  , ERP_IF_STATUS
					  , FP_IF_RETURN
					  , ERP_IF_RETURN
					  , ATTRIBUTE1   -- 2018-05-26 kimcd MES 라인 정보 추가
					  , INSERT_ID
					  , INSERT_TIME
					  , UPDATE_ID
					  , UPDATE_TIME)
				VALUES (   B.FP_PLAN_ID
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
						 , B.ERP_IF_STATUS
						 , B.FP_IF_RETURN
						 , B.ERP_IF_RETURN
						 , B.MES_LINE_ID -- 2018-05-26 kimcd MES 라인 정보 추가
						 , B.INSERT_ID
						 , B.INSERT_TIME
						 , B.UPDATE_ID
						 , B.UPDATE_TIME
				) 
			;
			-- 2018-05-23 kimcd Insert 문장에서 Merge 문장으로 수정 끝

			--FP_ERP_PRODUCTION_PLAN_H 정보에 갱신
			MERGE FP_ERP_PRODUCTION_PLAN_H T
			USING ( 
					SELECT XES.FP_PLAN_ID
						   , ISNULL(FPP.INSTANCE_ID, 'MANUAL')    AS INSTANCE_ID
						   , FM.COMPANY_ID
						   , FM.DIVISION_ID
						   , FM.SITE_ID
						   , FM.PLANT_ID
						   , FM.FACTORY_ID
						   , XES.WORK_ORDER_ID
						   , XES.BATCH_ORDER_ID
						   , 'W'  ORDER_TYPE
						   , ISNULL(ISNULL(FPP.TOP_ITEM_ID, MPP.ATTRIBUTE4), XES.ITEM_ID) AS TOP_ITEM_ID  -- 2018-07-24 kimcd TOP ITEM ID 조회 방식 변경
						   , XES.ITEM_ID
						   , FPP.LANE_QTY
						   , ISNULL(ISNULL(FPP.LINE_ID, MPP.LINE_ID), XES.LINE_ID)     AS LINE_ID  -- 2018-07-24 kimcd LINE_ID 조회 방식 변경
						   , XES.OPERATION_ID
						   , ISNULL(FPP.ELECTRODE_TYPE,MPP.ELECTRODE_TYPE) AS ELECTRODE_TYPE -- 2019-08-15 kimcd 전극 유형 NULL 처리
						   , XES.WORK_CENTER_ID
						   , ISNULL(FPP.PLAN_DATE, CONVERT(DATETIME, SUBSTRING(XES.PLAN_DATE, 1, 8))) AS PLAN_DATE
						   , ISNULL(FPP.START_TIME, CONVERT(DATETIME, SUBSTRING(XES.START_TIME,1,8) + ' ' + SUBSTRING(XES.START_TIME,9,2)  + ':' + SUBSTRING(XES.START_TIME,11,2) + ':' + SUBSTRING(XES.START_TIME,13,2))) AS START_TIME
						   , ISNULL(FPP.END_TIME, CONVERT(DATETIME, SUBSTRING(XES.END_TIME,1,8) + ' ' + SUBSTRING(XES.END_TIME,9,2)  + ':' + SUBSTRING(XES.END_TIME,11,2) + ':' + SUBSTRING(XES.END_TIME,13,2))) AS END_TIME
						   , FEM.PLAN_QTY  AS ORG_PLAN_QTY
						   , FEM.PLAN_IN_QTY  AS ORG_PLAN_IN_QTY
						   , XES.PLAN_QTY
						   , XES.PLAN_IN_QTY
						   , FPP.ROLL_IN_QTY
						   , FPP.ROLL_OUT_QTY
						   , FPP.JR_IN_QTY
						   , FPP.JR_OUT_QTY
						   , FPP.BATCH_QTY
						   , XES.FIX_TYPE
						   , ISNULL(XES.ORDER_TYPE,FPP.PRODUCTION_TYPE) AS PRODUCTION_TYPE
						   , ISNULL(ISNULL(FPP.FP_PRODUCTION_TYPE, MPP.ATTRIBUTE5), XES.ORDER_TYPE) AS FP_PRODUCTION_TYPE -- 2018-07-24 kimcd FP PRODUCTION TYPE 조회 방식 변경
						   , ISNULL(XES.MARKET,FPP.MARKET)              AS MARKET
						   , XES.SLITTER_PLANT AS SLIT_PLANT_ID
						   , XES.ATTRIBUTE1    AS PUBLISH_TYPE
						   , XEL.E_MTYPE       AS ERP_IF_STATUS
						   , XEL.FP_MESSAGE    AS FP_IF_RETURN
						   , XEL.E_MESSAGE     AS ERP_IF_RETURN
						   , XES.LINE_ID       AS MES_LINE_ID -- 2018-05-26 kimcd MES 라인 정보 추가
						   , ISNULL(SFP.UPDATE_ID,XES.CREATE_USER_ID)   AS INSERT_ID  -- 2018-07-05 kimcd 변경 사용자 명 - release 사람으로 변경으로 추가
						   , GETDATE()      AS INSERT_TIME
						   , ISNULL(SFP.UPDATE_ID,XES.CREATE_USER_ID)   AS UPDATE_ID  -- 2018-07-05 kimcd 변경 사용자 명 - release 사람으로 변경으로 추가
						   , GETDATE()      AS UPDATE_TIME 
					  FROM SY_XIF_ERP_PRODUCTION_PLAN_S   XES WITH(NOLOCK)
						   LEFT OUTER JOIN FP_PRODUCTION_PLAN_R  FPP WITH(NOLOCK)
										ON FPP.FP_PLAN_ID    = XES.FP_PLAN_ID
									   AND FPP.WORK_ORDER_ID = XES.WORK_ORDER_ID
								INNER JOIN ( SELECT XEL.PLAN_ID
												    ,XEL.WO_NO
												    ,XEL.E_MTYPE
												    ,XEL.E_MESSAGE
												    ,XEL.FP_MESSAGE
												    ,ROW_NUMBER() OVER( PARTITION BY XEL.PLAN_ID, XEL.WO_NO ORDER BY IFSEQNO DESC) ROWNUMS
											   FROM SY_XIF_ERP_WORK_ORDER_RESULT_R   XEL WITH(NOLOCK)
											  WHERE XEL.TRANSFER_FLAG = 'P')  XEL
										ON XES.FP_PLAN_ID    = XEL.PLAN_ID
									   AND XES.WORK_ORDER_ID = XEL.WO_NO
									   AND XEL.ROWNUMS       = 1
						   LEFT OUTER JOIN FP_ERP_PRODUCTION_PLAN_M		FEM WITH(NOLOCK)
										ON XEL.WO_NO = FEM.WORK_ORDER_ID
						   LEFT OUTER JOIN FP_MES_PRODUCTION_PLAN_M     MPP WITH(NOLOCK)  -- 2018-07-24 kimcd MES WORK ORDER MASTER 추가
										ON XEL.WO_NO = MPP.WORK_ORDER_ID
								INNER JOIN SCM_FACTORY_M                    FM WITH(NOLOCK)
										ON FM.FACTORY_ID     = XES.FACTORY_ID
						   LEFT OUTER JOIN SCM_FP_PLAN_H SFP WITH(NOLOCK)  -- 2018-07-05 kimcd 변경 사용자 명 - release 사람으로 변경으로 추가
										ON SFP.PLAN_ID = XES.FP_PLAN_ID
				) B
			 ON T.[FP_PLAN_ID]    = B.FP_PLAN_ID
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
					 , T.ERP_IF_STATUS      = B.ERP_IF_STATUS
					 , T.FP_IF_RETURN       = B.FP_IF_RETURN
					 , T.ERP_IF_RETURN      = B.ERP_IF_RETURN
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
					 , ERP_IF_STATUS
					 , FP_IF_RETURN
					 , ERP_IF_RETURN
					 , ATTRIBUTE1    -- 2018-05-26 kimcd MES 라인 정보 추가
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
					 , B.ERP_IF_STATUS
					 , B.FP_IF_RETURN
					 , B.ERP_IF_RETURN
					 , B.MES_LINE_ID -- 2018-05-26 kimcd MES 라인 정보 추가
					 , B.INSERT_ID
					 , B.INSERT_TIME
					 , B.UPDATE_ID
					 , B.UPDATE_TIME
				) 
			;


			--FP_ERP_PRODUCTION_PLAN_M 정보 갱신
			MERGE FP_ERP_PRODUCTION_PLAN_M T
		    USING ( 
					 SELECT ISNULL(FPP.INSTANCE_ID, 'MANUAL')    AS INSTANCE_ID
							, FM.COMPANY_ID
						    , FM.DIVISION_ID
						    , FM.SITE_ID
						    , FM.PLANT_ID
						    , FM.FACTORY_ID
						    , XES.WORK_ORDER_ID
						    , XES.BATCH_ORDER_ID
						    , 'W'  ORDER_TYPE
							, ISNULL(ISNULL(FPP.TOP_ITEM_ID, MPP.ATTRIBUTE4), XES.ITEM_ID) AS TOP_ITEM_ID  -- 2018-07-24 kimcd TOP ITEM ID 조회 방식 변경
						    , XES.ITEM_ID
						    , FPP.LANE_QTY
						    , ISNULL(ISNULL(FPP.LINE_ID, MPP.LINE_ID), XES.LINE_ID)     AS LINE_ID  -- 2018-07-24 kimcd LINE ID 조회 방식 변경
						    , XES.OPERATION_ID
							, ISNULL(FPP.ELECTRODE_TYPE,MPP.ELECTRODE_TYPE) AS ELECTRODE_TYPE -- 2019-08-15 kimcd 전극 유형 NULL 처리
						    , XES.WORK_CENTER_ID
							, ISNULL(FPP.PLAN_DATE, CONVERT(DATETIME, SUBSTRING(XES.PLAN_DATE, 1, 8))) AS PLAN_DATE
							, ISNULL(FPP.START_TIME, CONVERT(DATETIME, SUBSTRING(XES.START_TIME,1,8) + ' ' + SUBSTRING(XES.START_TIME,9,2)  + ':' + SUBSTRING(XES.START_TIME,11,2) + ':' + SUBSTRING(XES.START_TIME,13,2))) AS START_TIME
							, ISNULL(FPP.END_TIME, CONVERT(DATETIME, SUBSTRING(XES.END_TIME,1,8) + ' ' + SUBSTRING(XES.END_TIME,9,2)  + ':' + SUBSTRING(XES.END_TIME,11,2) + ':' + SUBSTRING(XES.END_TIME,13,2))) AS END_TIME
						    , XES.PLAN_QTY
						    , XES.PLAN_IN_QTY
						    , FPP.ROLL_IN_QTY
						    , FPP.ROLL_OUT_QTY
						    , FPP.JR_IN_QTY
						    , FPP.JR_OUT_QTY
						    , FPP.BATCH_QTY
						    , XES.FIX_TYPE
						    , ISNULL(XES.ORDER_TYPE,FPP.PRODUCTION_TYPE) AS PRODUCTION_TYPE
						    , ISNULL(ISNULL(FPP.FP_PRODUCTION_TYPE, MPP.ATTRIBUTE5), XES.ORDER_TYPE) AS FP_PRODUCTION_TYPE -- 2018-07-24 kimcd MES WORK ORDER MASTER 추가
						    , ISNULL(XES.MARKET,FPP.MARKET)              AS MARKET
						    , XES.SLITTER_PLANT AS SLIT_PLANT_ID
						    , XES.ATTRIBUTE1    AS PUBLISH_TYPE
						    , XEL.E_MTYPE       AS ERP_IF_STATUS
						    , XEL.FP_MESSAGE    AS FP_IF_RETURN
						    , XEL.E_MESSAGE     AS ERP_IF_RETURN
							, XES.LINE_ID       AS MES_LINE_ID -- 2018-05-26 kimcd MES 라인 정보 추가
						    , XES.FP_PLAN_ID    AS INSERT_FP_PLAN_ID
							, ISNULL(SFP.UPDATE_ID,XES.CREATE_USER_ID)   AS INSERT_ID  -- 2018-07-05 kimcd 변경 사용자 명 - release 사람으로 변경으로 추가
							, GETDATE()         AS INSERT_TIME
						    , XES.FP_PLAN_ID    AS UPDATE_FP_PLAN_ID
							, ISNULL(SFP.UPDATE_ID,XES.CREATE_USER_ID)   AS UPDATE_ID  -- 2018-07-05 kimcd 변경 사용자 명 - release 사람으로 변경으로 추가
							, GETDATE()         AS UPDATE_TIME
							,(  SELECT TOP 1 'Y'
								FROM   SCM_SYS_LOOKUP_VALUE  SLV WITH(NOLOCK)
								WHERE  SLV.LOOKUP_TYPE_CODE = 'FIRST_TEST_WO'
								AND    SLV.SEGMENT1         = FPP.INSTANCE_ID
								AND    SLV.SEGMENT2         = FPP.FP_PRODUCTION_TYPE
								AND    SLV.SEGMENT3         = FPP.OPERATION_ID
								AND    SLV.ACTIVE_FLAG      = 'Y' ) AS FIRST_TEST_WO  -- 2018-07-05 kimcd 한국 S-TEST 노칭은 최초 WO로 표시
					   FROM SY_XIF_ERP_PRODUCTION_PLAN_S   XES WITH(NOLOCK)
						    LEFT OUTER JOIN FP_PRODUCTION_PLAN_R  FPP WITH(NOLOCK)
									     ON FPP.FP_PLAN_ID    = XES.FP_PLAN_ID
									    AND FPP.WORK_ORDER_ID = XES.WORK_ORDER_ID
								 INNER JOIN ( SELECT XEL.PLAN_ID
												     ,XEL.WO_NO
												     ,XEL.E_MTYPE
												     ,XEL.E_MESSAGE
												     ,XEL.FP_MESSAGE
												     ,ROW_NUMBER() OVER( PARTITION BY XEL.WO_NO ORDER BY IFSEQNO DESC) ROWNUMS
											    FROM SY_XIF_ERP_WORK_ORDER_RESULT_R   XEL WITH(NOLOCK)
											   WHERE XEL.TRANSFER_FLAG = 'P')  XEL
										ON XES.FP_PLAN_ID    = XEL.PLAN_ID
									   AND XES.WORK_ORDER_ID = XEL.WO_NO
									   AND XEL.ROWNUMS       = 1
									   AND XEL.E_MTYPE       = 'S'
						   LEFT OUTER JOIN FP_MES_PRODUCTION_PLAN_M     MPP WITH(NOLOCK)  -- 2018-07-24 kimcd MES WORK ORDER MASTER 추가
										ON XEL.WO_NO = MPP.WORK_ORDER_ID
								INNER JOIN SCM_FACTORY_M                    FM WITH(NOLOCK)
										ON FM.FACTORY_ID     = XES.FACTORY_ID
						   LEFT OUTER JOIN SCM_FP_PLAN_H SFP WITH(NOLOCK)  -- 2018-07-05 kimcd 변경 사용자 명 - release 사람으로 변경으로 추가
										ON SFP.PLAN_ID = XES.FP_PLAN_ID
				  ) B
			   ON T.[WORK_ORDER_ID] = B.WORK_ORDER_ID
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
					  , T.ORG_PLAN_QTY       = T.PLAN_QTY
					  , T.ORG_PLAN_IN_QTY    = T.PLAN_IN_QTY
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
					  , T.WO_STATUS          = CASE WHEN B.PLAN_IN_QTY = 0 THEN 'Deleted'
												    WHEN B.PLAN_IN_QTY <= T.ACTUAL_QTY THEN 'Completed'
												    ELSE 'Planning' END
					  , T.ERP_IF_STATUS      = B.ERP_IF_STATUS
					  , T.FP_IF_RETURN       = B.FP_IF_RETURN
					  , T.ERP_IF_RETURN      = B.ERP_IF_RETURN
					  , T.ATTRIBUTE1         = B.MES_LINE_ID  -- 2018-05-26 kimcd MES 라인 정보 추가
					  , T.UPDATE_FP_PLAN_ID  = B.UPDATE_FP_PLAN_ID
					  , T.UPDATE_ID          = B.UPDATE_ID
					  , T.UPDATE_TIME        = B.UPDATE_TIME
			WHEN NOT MATCHED THEN
				INSERT (
						 INSTANCE_ID
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
						 , WO_STATUS
						 , ERP_IF_STATUS
						 , FP_IF_RETURN
						 , ERP_IF_RETURN
						 , ATTRIBUTE1    -- 2018-05-26 kimcd MES 라인 정보 추가
						 , INSERT_FP_PLAN_ID
						 , INSERT_ID
						 , INSERT_TIME
						 , UPDATE_FP_PLAN_ID
						 , UPDATE_ID
						 , UPDATE_TIME
						 , FIRST_TEST_WO -- 2018-07-05 kimcd 한국 S-TEST 노칭은 최초 WO로 표시
				) VALUES (
						 B.INSTANCE_ID
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
						 , 0           -- ORG_PLAN_QTY
						 , 0           -- ORG_PLAN_IN_QTY
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
						 , 'Planning'               -- WO_STATUS
						 , B.ERP_IF_STATUS
						 , B.FP_IF_RETURN
						 , B.ERP_IF_RETURN
						 , B.MES_LINE_ID   -- 2018-05-26 kimcd MES 라인 정보 추가
						 , B.INSERT_FP_PLAN_ID
						 , B.INSERT_ID
						 , B.INSERT_TIME
						 , B.UPDATE_FP_PLAN_ID
						 , B.UPDATE_ID
						 , B.UPDATE_TIME
						 , B.FIRST_TEST_WO -- 2018-07-05 kimcd 한국 S-TEST 노칭은 최초 WO로 표시
			)
		;


			--Transfer_flag를  P인 정보를 Y로 갱신
			UPDATE SY_XIF_ERP_WORK_ORDER_RESULT_R
			  SET  TRANSFER_FLAG = 'Y'
			WHERE  TRANSFER_FLAG = 'P'

			UPDATE SY_XIF_ERP_PRODUCTION_PLAN_LOG
			  SET  TRANSFER_FLAG = 'Y'
			WHERE  TRANSFER_FLAG = 'P'


		COMMIT TRAN

		EXEC PR_XIF_LOG @v_proc_name, NULL, 'END',   NULL, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
		
	END TRY

	BEGIN CATCH

		-- 에러나도 로그는 인서트
		SET @v_descr = ERROR_MESSAGE()
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate

	END CATCH

END



