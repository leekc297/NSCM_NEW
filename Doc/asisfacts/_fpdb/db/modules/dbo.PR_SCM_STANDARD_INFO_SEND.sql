CREATE PROCEDURE [dbo].[PR_SCM_STANDARD_INFO_SEND]

-- ================================================================================================
-- Program ID          : FP00560
-- Program Name        : PR_SCM_STANDARD_INFO_SEND
-- Param               :
-- Batch Period        : realtime
-- Description         : RELEASE 정보  Mailing
--
-- Source System       : 
-- Destination System  : 
-- Source Table        : SCM_MAILING_H
-- Destination Table   : 
--
-- Create Date		   : 2017.12.08
-- Update Date		   : 2018.02.13 piyong 1.1
--					     2018.02.27 piyong 1.2
--					     2018.03.02 piyong 1.3
--						 2018.03.05 PIYONG 1.4 
--						 2018.03.12 PIYONG 1.5
--						 2018.03.12 PIYONG 1.6
--						 2018.07.23 PIYONG 1.7
--						 2018.10.15 PIYONG 1.8
--						 2018.11.27 PIYONG 1.9
--						 2018.12.11 PIYONG 1.10
--                       2018.12.26 kimcd  1.11
--                       2019.01.07 kimcd  1.12
--                       2019.01.17 kimcd  1.13
--                       2019.02.13 kimcd  1.14
--						 2019.09.09 piyong 1.15
--						 2019.09.19 piyong 1.16
--						 2019.12.06 PIYONG 1.17
--						 2020.03.09 PIYONG 2.0
--						 2020.03.20 PIYONG 2.1
--						 2022.07.13 PIYONG 2.2
--						 2022.10.12 leeseongmin 2.3
-- Author              : 
-- Version             : 1.0
--						 1.1 DAILY_CAPA 확인 쿼리 변경 ( ITEM_LINE_ASSIGN_M 등록 되어 있는 ITEM 중  TAT_TIME 과 DAILY_CAPA가 0 일경우 X로 변경 )
--						 1.2 전극 기준정보 추가
--						 1.3 조립 공정 조회 쿼리 수정 MIN(MFG_WEEK ) 기준으로 GROUP BY
--						 1.4 전극 기준정보 MIN(SHIP_WEEK ) 기준으로 GROUP BY
--						 1.5 PJT Code Merge 해제
--						 1.6 ORDER BY NICK_NAME	주석처리
--						 1.7 TEST TARGET 추가
--						 1.8 #ELEC_TEMP 생성 기준 테이블 변경 (FP_WEEKLY_DEMAND_SHIPMENT_ELEC_H, FP_WEEKLY_DEMAND_SHIPMENT_AUTO_H - > FP_WEEKLY_DEMAND_PRODUCT_H )
--						 1.9 PILOT 라인 제외
--						 1.10 조회 대상 조건 변경
--						   ISNULL(BB.ITEM_TYPE,'-') != 'R' -> ( ISNULL(BB.ITEM_TYPE,'-') IN ('P','H','Q') OR A.ITEM_ID LIKE 'A%')
--                       1.11 2018-12-26 kimcd 주차 조건에서 년 계산 오류 보완
--                       1.12 2019-01-07 kimcd 오창 S2동은 Notch 품목은 Validation에서 제외
--                       1.13 2019-01-17 kimcd 대치 품목 제외 로직 추가 - alt_id, priority 기준으로 첫 품목만으로 제약
--                       1.14 2019-02-13 kimcd INSTANCE_OPERATION_EXCEPT 제거에서 전체 라인인 경우만 VALIDATION 제외하도록 로직 보완
--						 1.15 INSTANCE 구분 테이블 추가
--						 1.16 메일 발송 조건에 시업 시간 추가
--						 1.17 SCM_LINE_ASSIGN_M와 SCM_LINE_M JOIN 추가
--						 2.0 조립, 팩 기준정보 조회 조건 변경
--						 2.1 품목이 없는 경우, ERP 평가 CLASS가 없는 경우 분리
--                       2.2 2022-07-13 kimcd 설비 존재 Validation에서 제외
--                       2.3 2022-10-12 leeseongmin 시인성작업 ( 테두리 라인 및 정렬 )
-- ================================================================================================
-- PARAMETER
@site_id  NVARCHAR(100) =  'A001'
,@P_BASIS_START_TIME NVARCHAR(6) = '060000'

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_SCM_STANDARD_INFO_SEND'
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
	DECLARE @TABLE_BODY            NVARCHAR(MAX)
	DECLARE @TABLE_CONTENTS        NVARCHAR(MAX) = ''
--	DECLARE @TABLE_HEAD_CONTENT    NVARCHAR(MAX)
	DECLARE @MAIL_CONTENT          NVARCHAR(MAX)
	DECLARE @MAIL_TITLE            NVARCHAR(MAX)

	DECLARE @MAIL_RECEIVER_LIST    NVARCHAR(4000)

	SET @ROWCOUNT = @@ROWCOUNT

	DECLARE @INSTANCE_ID			NVARCHAR(20)
    DECLARE @MAIL_ADDR				NVARCHAR(MAX)

	DECLARE @MFG_WEEK				NVARCHAR(20)
	DECLARE @NICK_NAME				NVARCHAR(1000)
	DECLARE @MODEL_ID				NVARCHAR(1000)
	DECLARE @BEFOR_MFG_WEEK			NVARCHAR(20)	= ''
	DECLARE @BEFOR_NICK_NAME		NVARCHAR(1000)	= ''
	DECLARE @BEFOR_MODEL_ID			NVARCHAR(1000)	= ''

	DECLARE @CHILD_ITEM_ID			NVARCHAR(1000)
	DECLARE @FLOW_ID				NVARCHAR(100)
	DECLARE @LINE_ASSIGN			NVARCHAR(2)
	DECLARE @DAILY_CAPA				NVARCHAR(2)
	DECLARE @MDM_CODE_EXPANSION		NVARCHAR(2)
	DECLARE @MDM_VALUATION_CLASS	NVARCHAR(2)				-- 2020-03-20 PIYONG ADD
	DECLARE @MMD_ROUTING			NVARCHAR(2)
	DECLARE @ERP_BOM_EXPANING 		NVARCHAR(2)
	DECLARE @ERP_PROD_VERSION		NVARCHAR(2)
	DECLARE @STANDARD_COST			NVARCHAR(2)
	DECLARE @MODEL_PIC				NVARCHAR(120)

	DECLARE @WEEK_CNT				NUMERIC(18,0)
	DECLARE @NICK_CNT				NUMERIC(18,0)
	DECLARE @MODEL_CNT				NUMERIC(18,0)


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
		
			----------------------------------------------------------------------------------------------------------------------------------------------------------------
			--2018-02-27 PIYONG ADD 끝
			----------------------------------------------------------------------------------------------------------------------------------------------------------------
			--전극 대상 조회
			SELECT A.COMPANY_ID
				   ,A.DIVISION_ID
				   ,A.SITE_ID
				   ,A.PLANT_ID
				   ,A.ITEM_ID
				   ,MIN(A.MFG_WEEK) AS SHIP_WEEK  --2017-03-05 PIYONG CHANGE	-- 2018-10-15  PIYONG CHANGE SHIP_WEEK -> MFG_WEEK
				   ,A.SHOP_GROUP_ID
				   ,A.OP_TYPE
				   ,A.LINE_ID						-- 2019-09-09  PIYONG ADD
			  INTO #ELEC_TEMP
			  FROM (
					SELECT A.COMPANY_ID
						   ,A.DIVISION_ID
						   ,A.SITE_ID
						   ,A.PLANT_ID
						   ,A.ITEM_ID
						   ,A.MFG_WEEK			-- 2018-10-15  PIYONG CHANGE SHIP_WEEK -> MFG_WEEK
						   ,A.SHOP_GROUP_ID
						   ,A.OPERATION_ID AS OP_TYPE	-- 2018-10-15  PIYONG 'E2000' -> OPERATION_ID
						   ,A.LINE_ID			-- 2019-09-09  PIYONG ADD
					  FROM (
							 SELECT COMPANY_ID
									,DIVISION_ID
									,SITE_ID
									,PLANT_ID
									,ITEM_ID
									,MFG_WEEK			-- 2018-10-15  PIYONG CHANGE SHIP_WEEK -> MFG_WEEK
									,SHOP_GROUP_ID 
									,SCP_PLAN_ID
									,OPERATION_ID		-- 2018-10-15  PIYONG ADD
									,LINE_ID			-- 2019-09-09  PIYONG ADD
								FROM [dbo].[FP_WEEKLY_DEMAND_PRODUCT_H] WITH(NOLOCK)	-- 2018-10-15  PIYONG FP_WEEKLY_DEMAND_SHIPMENT_ELEC_H -> FP_WEEKLY_DEMAND_PRODUCT_H
																									) A
							,(
								SELECT MAX(SCP_PLAN_ID) AS SCP_PLAN_ID , DIVISION_ID
								  FROM [FP_WEEKLY_DEMAND_PRODUCT_H]						-- 2018-10-15  PIYONG FP_WEEKLY_DEMAND_SHIPMENT_ELEC_H -> FP_WEEKLY_DEMAND_PRODUCT_H
								 WHERE SHOP_GROUP_ID = 'E'		-- 2018-10-15  PIYONG ADD
								 GROUP BY DIVISION_ID
																									) PLAN_SUBJECT
					 WHERE A.SCP_PLAN_ID  = PLAN_SUBJECT.SCP_PLAN_ID 
					   AND A.DIVISION_ID  = PLAN_SUBJECT.DIVISION_ID
					   AND A.SHOP_GROUP_ID = 'E'				-- 2018-10-15  PIYONG ADD
					   AND A.MFG_WEEK IN (		-- 2018-10-15  PIYONG CHANGE SHIP_WEEK -> MFG_WEEK
												-- 2018-12-26 kimcd 년 계산 오류 막음 SUBSTRING(CONVERT(CHAR(10),GETDATE(),120),1,4) + RIGHT('00' + CONVERT(VARCHAR, DATEPART(WEEK, GETDATE()), 23), 2)   -- 당주
												-- 2018-12-26 kimcd 년 계산 오류 막음 ,SUBSTRING(CONVERT(CHAR(10),GETDATE(),120),1,4) + RIGHT('00' + CONVERT(VARCHAR, DATEPART(WEEK, GETDATE()+7), 23), 2) -- 차주
											SELECT DISTINCT WEEK
											FROM  [DBO].SCM_SYS_CALENDAR_M  SC WITH(NOLOCK)
											WHERE DATE_ID >= CONVERT( DATE, GETDATE()) 
											AND   DATE_ID <= CONVERT( DATE, DATEADD(D,7,GETDATE())) -- -- 2018-12-26 kimcd 년 계산 오류 개선
										  ) 
					   AND A.SITE_ID = @site_id

					/*		-- 2018-10-15  PIYONG DEL
					UNION ALL
					SELECT A.COMPANY_ID
						   ,A.DIVISION_ID
						   ,A.SITE_ID
						   ,A.PLANT_ID
						   ,A.ITEM_ID
						   ,A.SHIP_WEEK
						   ,A.SHOP_GROUP_ID
						   ,'E2000' AS TYPE
					  FROM (
							 SELECT COMPANY_ID
									,DIVISION_ID
									,SITE_ID
									,PLANT_ID
									,ITEM_ID
									,SHIP_WEEK
									,SHOP_GROUP_ID 
									,SCP_PLAN_ID
							   FROM [dbo].[FP_WEEKLY_DEMAND_SHIPMENT_AUTO_H] WITH(NOLOCK) 
																									) A
						   ,(
							 SELECT MAX(SCP_PLAN_ID) AS SCP_PLAN_ID , DIVISION_ID
							   FROM [FP_WEEKLY_DEMAND_SHIPMENT_AUTO_H]
							  GROUP BY DIVISION_ID
																									) PLAN_SUBJECT
					 WHERE A.SCP_PLAN_ID  = PLAN_SUBJECT.SCP_PLAN_ID 
					   AND A.DIVISION_ID  = PLAN_SUBJECT.DIVISION_ID
					   AND A.SHIP_WEEK IN (
											-- 2018-12-26 kimcd 년 계산 오류 막음 SUBSTRING(CONVERT(CHAR(10),GETDATE(),120),1,4) + RIGHT('00' + CONVERT(VARCHAR, DATEPART(WEEK, GETDATE()), 23), 2)   -- 당주
											-- 2018-12-26 kimcd 년 계산 오류 막음 ,SUBSTRING(CONVERT(CHAR(10),GETDATE(),120),1,4) + RIGHT('00' + CONVERT(VARCHAR, DATEPART(WEEK, GETDATE()+7), 23), 2) -- 차주
											SELECT DISTINCT WEEK
											FROM  [DBO].SCM_SYS_CALENDAR_M  SC WITH(NOLOCK)
											WHERE DATE_ID >= CONVERT( DATE, GETDATE()) 
											AND   DATE_ID <= CONVERT( DATE, DATEADD(D,7,GETDATE())) -- -- 2018-12-26 kimcd 년 계산 오류 개선
										  ) 
					   AND A.SITE_ID = @site_id
					*/
					---------------------------------------------------------------------------------------------------------------------------------------------------------------
					--2018-07-23 PIYONG TEST TARGET  ADD 시작
					UNION ALL
					SELECT WDPH.[COMPANY_ID]
						   ,WDPH.[DIVISION_ID]
						   ,WDPH.[SITE_ID]
						   ,WDPH.[PLANT_ID]
						   ,WDPH.[ITEM_ID]
						   ,WDPH.[MFG_WEEK]
						   ,OM.OPERATION_GROUP_ID AS SHOP_GROUP_ID
						   ,WDPH.[OPERATION_ID] AS OP_TYPE
						   ,WDPH.LINE_ID							-- 2019-09-09  PIYONG ADD
					  FROM [FP_WEEKLY_DEMAND_PRODUCT_TEST_H] WDPH
						   ,[SCM_OPERATION_M] OM
					 WHERE WDPH.[COMPANY_ID] = OM.[COMPANY_ID]
					   AND WDPH.[DIVISION_ID] = OM.[DIVISION_ID]
					   AND WDPH.[SITE_ID] = OM.[SITE_ID]
					   AND WDPH.[OPERATION_ID] = OM.[OPERATION_ID]
					   AND WDPH.OPERATION_ID = 'E2000'
					   AND WDPH.MFG_WEEK IN (
												-- 2018-12-26 kimcd 년 계산 오류 막음 SUBSTRING(CONVERT(CHAR(10),GETDATE(),120),1,4) + RIGHT('00' + CONVERT(VARCHAR, DATEPART(WEEK, GETDATE()), 23), 2)   -- 당주
												-- 2018-12-26 kimcd 년 계산 오류 막음 ,SUBSTRING(CONVERT(CHAR(10),GETDATE(),120),1,4) + RIGHT('00' + CONVERT(VARCHAR, DATEPART(WEEK, GETDATE()+7), 23), 2) -- 차주
												SELECT DISTINCT WEEK
												FROM  [DBO].SCM_SYS_CALENDAR_M  SC WITH(NOLOCK)
												WHERE DATE_ID >= CONVERT( DATE, GETDATE()) 
												AND   DATE_ID <= CONVERT( DATE, DATEADD(D,7,GETDATE())) -- -- 2018-12-26 kimcd 년 계산 오류 개선
											) 
					   AND WDPH.SITE_ID = @site_id

					UNION ALL
					SELECT WDPH.[COMPANY_ID]
						   ,WDPH.[DIVISION_ID]
						   ,WDPH.[SITE_ID]
						   ,WDPH.[PLANT_ID]
						   ,WDPH.[ITEM_ID]
						   ,WDPH.[MFG_WEEK]
						   ,OM.OPERATION_GROUP_ID AS SHOP_GROUP_ID
						   ,WDPH.[OPERATION_ID] AS OP_TYPE
						   ,WDPH.LINE_ID			-- 2019-09-09  PIYONG ADD
					  FROM [FP_WEEKLY_DEMAND_PRODUCT_TEST_H] WDPH
						   ,[SCM_OPERATION_M] OM
					 WHERE WDPH.[COMPANY_ID] = OM.[COMPANY_ID]
					   AND WDPH.[DIVISION_ID] = OM.[DIVISION_ID]
					   AND WDPH.[SITE_ID] = OM.[SITE_ID]
					   AND WDPH.[OPERATION_ID] = OM.[OPERATION_ID]
					   AND WDPH.OPERATION_ID = 'E0500'
					   AND WDPH.MFG_WEEK IN (
												-- 2018-12-26 kimcd 년 계산 오류 막음 SUBSTRING(CONVERT(CHAR(10),GETDATE(),120),1,4) + RIGHT('00' + CONVERT(VARCHAR, DATEPART(WEEK, GETDATE()), 23), 2)   -- 당주
												-- 2018-12-26 kimcd 년 계산 오류 막음 ,SUBSTRING(CONVERT(CHAR(10),GETDATE(),120),1,4) + RIGHT('00' + CONVERT(VARCHAR, DATEPART(WEEK, GETDATE()+7), 23), 2) -- 차주
												SELECT DISTINCT WEEK
												FROM  [DBO].SCM_SYS_CALENDAR_M  SC WITH(NOLOCK)
												WHERE DATE_ID >= CONVERT( DATE, GETDATE()) 
												AND   DATE_ID <= CONVERT( DATE, DATEADD(D,7,GETDATE())) -- -- 2018-12-26 kimcd 년 계산 오류 개선
											) 
					   AND WDPH.SITE_ID = @site_id


					--2018-07-23 PIYONG TEST TARGET  ADD 끝
					---------------------------------------------------------------------------------------------------------------------------------------------------------------
					UNION ALL
					SELECT A.COMPANY_ID
						   ,A.DIVISION_ID
						   ,A.SITE_ID
						   ,A.PLANT_ID
						   ,A.ITEM_ID
						   ,A.SHIP_WEEK
						   ,A.SHOP_GROUP_ID
						   ,'E0500' AS OP_TYPE
						   ,LINE_ID			-- 2019-09-09  PIYONG ADD
					  FROM (
							 SELECT COMPANY_ID
									,DIVISION_ID
									,SITE_ID
									,PLANT_ID
									,ITEM_ID
									,MFG_WEEK AS SHIP_WEEK
									,SHOP_GROUP_ID 
									,DPP_PLAN_ID AS SCP_PLAN_ID
									,LINE_ID			-- 2019-09-09  PIYONG ADD
								FROM [dbo].FP_DAILY_NET_DEMAND_H WITH(NOLOCK)
																									) A
						   ,(
							 SELECT MAX(DPP_PLAN_ID) AS SCP_PLAN_ID , DIVISION_ID
							   FROM FP_DAILY_NET_DEMAND_H
							  WHERE INSTANCE_ID IN  (SELECT DISTINCT B.INSTANCE_ID
													   FROM FP_INSTANCE_FACTORY_M B
													  WHERE B.INSTANCE_TYPE = 'E3')
														AND DPP_PLAN_ID = INSTANCE_ID + '-' + CONVERT(NVARCHAR(8), GETDATE(), 112) + '-00'
							  GROUP BY DIVISION_ID
																									) PLAN_SUBJECT
					 WHERE A.SCP_PLAN_ID  = PLAN_SUBJECT.SCP_PLAN_ID 
					   AND A.DIVISION_ID  = PLAN_SUBJECT.DIVISION_ID
					   AND A.SHIP_WEEK IN (
											-- 2018-12-26 kimcd 년 계산 오류 막음 SUBSTRING(CONVERT(CHAR(10),GETDATE(),120),1,4) + RIGHT('00' + CONVERT(VARCHAR, DATEPART(WEEK, GETDATE()), 23), 2)   -- 당주
											-- 2018-12-26 kimcd 년 계산 오류 막음 ,SUBSTRING(CONVERT(CHAR(10),GETDATE(),120),1,4) + RIGHT('00' + CONVERT(VARCHAR, DATEPART(WEEK, GETDATE()+7), 23), 2) -- 차주
											SELECT DISTINCT WEEK
											FROM  [DBO].SCM_SYS_CALENDAR_M  SC WITH(NOLOCK)
											WHERE DATE_ID >= CONVERT( DATE, GETDATE()) 
											AND   DATE_ID <= CONVERT( DATE, DATEADD(D,7,GETDATE())) -- -- 2018-12-26 kimcd 년 계산 오류 개선
										  ) 
					   AND A.SITE_ID = @site_id

				   ) A
			--2017-03-05 PIYONG ADD
			 GROUP BY A.COMPANY_ID
				   ,A.DIVISION_ID
				   ,A.SITE_ID
				   ,A.PLANT_ID
				   ,A.ITEM_ID
				   ,A.SHOP_GROUP_ID
				   ,A.OP_TYPE
				   ,A.LINE_ID			-- 2019-09-09  PIYONG ADD
			----------------------------------------------------------------------------------------------------------------------------------------------------------------
			--2018-02-27 PIYONG ADD 끝
			----------------------------------------------------------------------------------------------------------------------------------------------------------------

			-- 기준 정보 조회
			SELECT DISTINCT A.INSTANCE_ID  -- instance id별 메일 발송
				   ,A.MFG_WEEK
				   ,A.NICK_NAME
				   ,A.ITEM_ID  AS MODEL_ID
				   ,A.CHILD_ITEM_ID
				   ,A.FLOW_ID
				   ,A.SHOP_GROUP_ID 
				   ,A.ITEM_TYPE
				   ,(
					 SELECT TOP 1 OPERATION_NAME
					   FROM SCM_OPERATION_M D  WITH(NOLOCK) -- 공정이름, 사용하고 있는 공정만
					  WHERE D.COMPANY_ID = A.CHILD_COMPANY_ID
					    AND D.DIVISION_ID = A.CHILD_DIVISION_ID
					    AND D.SITE_ID = A.CHILD_SITE_ID
					    AND D.OPERATION_ID = A.FLOW_ID
					    AND ACTIVE_FLAG = 'Y'
															) AS OPERATION_NAME
				   ,( 
					 SELECT TOP 1 IIA.LINE_ID
				       FROM SCM_ITEM_LINE_ASSIGN_M IIA WITH(NOLOCK)
							,SCM_LINE_M LM WITH(NOLOCK)
				      WHERE 1=1
				        AND MONTH = CONVERT(VARCHAR(6), GETDATE(), 112)
					    AND IIA.COMPANY_ID		= LM.COMPANY_ID
						AND IIA.DIVISION_ID		= LM.DIVISION_ID
						AND IIA.SITE_ID			= LM.SITE_ID
						AND IIA.PLANT_ID		= LM.PLANT_ID
						AND IIA.FACTORY_ID		= LM.FACTORY_ID
						AND IIA.OPERATION_ID	= LM.OPERATION_ID
						AND IIA.LINE_ID			= LM.LINE_ID
						AND IIA.ELECTRODE_TYPE	= LM.ELECTRODE_TYPE
				        AND IIA.PRIORITY != '9'
				        AND IIA.ACTIVE_FLAG = 'Y'
						AND LM.ACTIVE_FLAG = 'Y'
				        AND IIA.COMPANY_ID  = A.COMPANY_ID
				        AND IIA.DIVISION_ID = A.DIVISION_ID
				        AND IIA.SITE_ID     = A.SITE_ID
				        AND IIA.PLANT_ID = A.CHILD_PLANT_ID
				        AND IIA.OPERATION_ID = A.FLOW_ID
				        AND IIA.ITEM_ID  = A.CHILD_ITEM_ID
															) AS  LINE_ASSIGN
					--2018-02-13 PIYONG  ITEM_LINE_ASSIGN_M 등록 되어 있는 ITEM 중  TAT_TIME 과 DAILY_CAPA가 0 일경우 X로 변경 시작
				   ,ISNULL((
							SELECT TOP 1'X'
							  FROM [SCM_ITEM_LINE_ASSIGN_M]  ILA WITH(NOLOCK)
  								   ,SCM_LINE_M LM WITH(NOLOCK)
								   ,SCM_OPERATION_M SOM WITH(NOLOCK)
							 WHERE  ILA.COMPANY_ID	 = LM.COMPANY_ID
							    AND ILA.DIVISION_ID	 = LM.DIVISION_ID
							    AND ILA.SITE_ID		 = LM.SITE_ID
							    AND ILA.PLANT_ID	 = LM.PLANT_ID
							    AND ILA.FACTORY_ID	 = LM.FACTORY_ID
							    AND ILA.OPERATION_ID = LM.OPERATION_ID
							    AND ILA.LINE_ID		 = LM.LINE_ID
							    AND ILA.ELECTRODE_TYPE	= LM.ELECTRODE_TYPE
								AND LM.ACTIVE_FLAG	 = 'Y'
								AND ILA.COMPANY_ID   = SOM.COMPANY_ID
								AND ILA.DIVISION_ID  = SOM.DIVISION_ID
								AND ILA.SITE_ID      = SOM.SITE_ID
								AND ILA.OPERATION_ID = SOM.OPERATION_ID
								AND SOM.WO_FLAG      = 'Y'
								AND SOM.ACTIVE_FLAG  = 'Y'
								AND SOM.CAPA_TYPE    = 'TACT'
								AND ILA.MONTH		 = CONVERT(VARCHAR(6), GETDATE(), 112)
								AND ILA.PRIORITY	!= '9'
								AND ILA.ACTIVE_FLAG  = 'Y'
								AND ILA.COMPANY_ID   = A.COMPANY_ID
								AND ILA.DIVISION_ID  = A.DIVISION_ID
								AND ILA.SITE_ID      = A.SITE_ID
								AND ILA.PLANT_ID	 = A.CHILD_PLANT_ID
								AND ILA.OPERATION_ID = A.FLOW_ID
								AND ILA.ITEM_ID		 = A.CHILD_ITEM_ID
								AND NOT EXISTS (
												SELECT 1
												  FROM SCM_TACT_TIME_M TT  WITH(NOLOCK)
												 WHERE 1=1
												   AND TT.COMPANY_ID		= ILA.COMPANY_ID
												   AND TT.DIVISION_ID		= ILA.DIVISION_ID
												   AND TT.SITE_ID			= ILA.SITE_ID
												   AND TT.PLANT_ID			= ILA.PLANT_ID
												   AND TT.FACTORY_ID		= ILA.FACTORY_ID
												   AND TT.OPERATION_ID		= ILA.OPERATION_ID
   												   AND TT.LINE_ID			= ILA.LINE_ID
												   AND TT.ELECTRODE_TYPE	= ILA.ELECTRODE_TYPE
												   AND TT.ITEM_ID			= ILA.ITEM_ID
   												   AND TT.MONTH				=  CONVERT(VARCHAR(6), GETDATE(), 112)
												   AND (ISNULL(TT.TACT_TIME,0) > 0 OR  ISNULL(DAILY_CAPA,0) > 0  )
											   ) 
									), 'O') AS DAILY_CAPA
					--2018-02-13 PIYONG  ITEM_LINE_ASSIGN_M 등록 되어 있는 ITEM 중  TAT_TIME 과 DAILY_CAPA가 0 일경우 X로 변경 끝
				   ,CASE WHEN A.MDM_ITEM_ID IS NULL OR ISNULL(A.MDM_ACTIVE_FLAG,'N') != 'Y' THEN 'X' ELSE 'O' END AS MDM_CODE_EXPANSION	-- 2020-03-20 PIYONG CHANGE
				   ,CASE WHEN (A.MDM_ITEM_ID IS NOT NULL AND ISNULL(A.MDM_ACTIVE_FLAG,'N') = 'Y') AND ( A.ITEM_TYPE = '' OR A.ITEM_TYPE IS NULL) THEN 'X' ELSE 'O' END AS MDM_VALUATION_CLASS	-- 2020-03-20 PIYONG ADD
				   ,CASE WHEN A.FLOW_ID = '' OR A.FLOW_ID IS NULL THEN 'X' ELSE 'O' END AS MMD_ROUTING
				   ,ISNULL( ( 
							  SELECT TOP 1 'O'
							    FROM SCM_BOM_M EE WITH(NOLOCK)-- 하위공정
							   WHERE EE.ACTIVE_FLAG = 'Y'
								 AND EE.COMPANY_ID    = A.COMPANY_ID
								 AND EE.DIVISION_ID   = A.DIVISION_ID
								 AND EE.SITE_ID       = A.SITE_ID
								 AND EE.PLANT_ID      = A.PLANT_ID
								 AND EE.PARENT_ITEM_ID  = ISNULL(A.CHILD_ITEM_ID, A.ITEM_ID)
								 AND EE.EFF_END_DATE >= GETDATE()
							), 'X')						     AS ERP_BOM_EXPANING 
				   ,ISNULL( (
							 SELECT TOP 1'X'
							   FROM [SCM_ITEM_LINE_ASSIGN_M]  ILA WITH(NOLOCK)
								    ,SCM_LINE_M LM WITH(NOLOCK)
									--,[SCM_EQUIPMENT_M]         SE  WITH(NOLOCK)  -- 2022-07-13 kimcd 설비 정보 필수 조건 제거
							  WHERE ILA.COMPANY_ID		= LM.COMPANY_ID
								AND ILA.DIVISION_ID		= LM.DIVISION_ID
								AND ILA.SITE_ID			= LM.SITE_ID
								AND ILA.PLANT_ID		= LM.PLANT_ID
								AND ILA.FACTORY_ID		= LM.FACTORY_ID
								AND ILA.OPERATION_ID	= LM.OPERATION_ID
								AND ILA.LINE_ID			= LM.LINE_ID
								AND ILA.ELECTRODE_TYPE	= LM.ELECTRODE_TYPE
								AND LM.ACTIVE_FLAG		= 'Y'
							    --AND ILA.COMPANY_ID     = SE.COMPANY_ID  -- 2022-07-13 kimcd 설비 정보 필수 조건 제거
							    --AND ILA.DIVISION_ID    = SE.DIVISION_ID
							    --AND ILA.SITE_ID        = SE.SITE_ID
							    --AND ILA.PLANT_ID       = SE.PLANT_ID
							    --AND ILA.FACTORY_ID     = SE.FACTORY_ID
							    --AND ILA.LINE_ID        = SE.LINE_ID
							    --AND ILA.OPERATION_ID   = SE.OPERATION_ID
							    --AND ILA.ELECTRODE_TYPE = ISNULL(SE.ELECTRODE_TYPE, '-')
							    --AND SE.EQUIPMENT_TYPE  = 'M'
							    --AND SE.ACTIVE_FLAG     = 'Y'
							    AND ILA.MONTH = CONVERT(VARCHAR(6), GETDATE(), 112)
							    AND ILA.PRIORITY != '9'
							    AND ILA.ACTIVE_FLAG = 'Y'
							    AND ILA.COMPANY_ID  = A.COMPANY_ID
							    AND ILA.DIVISION_ID = A.DIVISION_ID
							    AND ILA.SITE_ID     = A.SITE_ID
							    AND ILA.PLANT_ID = A.CHILD_PLANT_ID
							    AND ILA.OPERATION_ID = A.FLOW_ID
							    AND ILA.ITEM_ID  = A.CHILD_ITEM_ID
								AND NOT EXISTS ( SELECT 1
												   FROM [SCM_ITEM_LINE_ASSIGN_ERP]  ILE WITH(NOLOCK)
												  WHERE ILE.COMPANY_ID     = ILA.COMPANY_ID
													AND ILE.DIVISION_ID    = ILA.DIVISION_ID
													AND ILE.SITE_ID        = ILA.SITE_ID
													AND ILE.PLANT_ID       = ILA.PLANT_ID
													AND ILE.FACTORY_ID     = ILA.FACTORY_ID
													AND ILE.ITEM_ID        = ILA.ITEM_ID
													AND ILE.WORK_CENTER_ID = LM.WORK_CENTER_ID  -- 2022-07-13 kimcd 설비 정보 필수 조건 제거 라인으로 조건 변경
													AND ILE.ACTIVE_FLAG = 'Y' ) ), 'O' ) AS ERP_PROD_VERSION

				   ,CASE WHEN A.STANDARD_COST IS NULL  THEN 'X' ELSE 'O' END AS STANDARD_COST
				   ,CASE WHEN A.SITE_ID = 'A001' THEN
							ISNULL((SELECT ITEM_USER
									  FROM FP_BOM_ITEM_CHARGER
									 WHERE ITEM_STATUS = N'AMS30'
									   AND BOM_YN = 'Y'
									   AND SPPL_YN = 'N'
									   AND ITEM_ID = A.ITEM_ID ), '')
						 ELSE
							ISNULL((SELECT MAIL_ID
									  FROM FP_BOM_ITEM_CHARGER
								     WHERE ITEM_STATUS = N'AMS30'
									   AND BOM_YN = 'Y'
									   AND SPPL_YN = 'N'
									   AND ITEM_ID = A.ITEM_ID ), '')
						 END AS MODEL_PIC
				   ,A.ALT_ID          -- 2019-01-17 kimcd BOM 대치 구분자
				   ,A.ALT_PRIORITY    -- 2019-01-17 kimcd BOM 대치 우선 순위
			  INTO #STANDARD_INFO
			  FROM (
					--2018-03-02 PIYONG GROUP BY  ADD
					SELECT MIN(MFG_WEEK) AS MFG_WEEK
						   ,NICK_NAME
						   ,ITEM_ID
						   ,CHILD_ITEM_ID
						   ,FLOW_ID
						   ,MAX(MDM_ITEM_ID)  AS MDM_ITEM_ID		-- 2020-03-20 PIYONG ADD
						   ,MAX(MDM_ACTIVE_FLAG) AS MDM_ACTIVE_FLAG	-- 2020-03-20 PIYONG ADD
						   ,SHOP_GROUP_ID 
						   ,ITEM_TYPE
						   ,COMPANY_ID
						   ,DIVISION_ID
						   ,SITE_ID
						   ,CHILD_PLANT_ID
						   ,CHILD_COMPANY_ID
						   ,CHILD_DIVISION_ID
						   ,CHILD_SITE_ID
						   ,PLANT_ID
						   ,STANDARD_COST
						   ,INSTANCE_ID
						   ,MAX(A.ALT_ID)        AS ALT_ID       -- 2019-01-17 kimcd BOM 대치 구분자
						   ,MAX(A.ALT_PRIORITY)  AS ALT_PRIORITY -- 2019-01-17 kimcd BOM 대치 우선 순위
					 FROM (
							SELECT DISTINCT A.MFG_WEEK
								   ,BB.NICK_NAME
								   ,A.ITEM_ID
								   ,B.CHILD_ITEM_ID
								   ,BB.FLOW_ID
								   ,BB.ITEM_ID AS MDM_ITEM_ID			-- 2020-03-20 PIYONG ADD
								   ,BB.ACTIVE_FLAG AS MDM_ACTIVE_FLAG	-- 2020-03-20 PIYONG ADD
								   ,A.SHOP_GROUP_ID 
								   ,BB.ITEM_TYPE
								   ,B.COMPANY_ID
								   ,B.DIVISION_ID
								   ,B.SITE_ID
								   ,B.CHILD_PLANT_ID
								   ,B.CHILD_COMPANY_ID
								   ,B.CHILD_DIVISION_ID
								   ,B.CHILD_SITE_ID
								   ,A.PLANT_ID
								   ,BB.STANDARD_COST
								   ,( 
										SELECT TOP 1 C.SEGMENT4
										  FROM SCM_SYS_LOOKUP_VALUE C WITH(NOLOCK)
												,SCM_LINE_M L WITH(NOLOCK)
												,FP_INSTANCE_FACTORY_M FIF WITH(NOLOCK)	--2019-09-09 piyong add
										  WHERE L.COMPANY_ID     = A.COMPANY_ID
											AND L.DIVISION_ID    = A.DIVISION_ID
											AND L.SITE_ID        = A.SITE_ID
											AND L.PLANT_ID       = A.PLANT_ID
											AND ( ( L.SCP_LINE_ID    = ISNULL(A.LINE_ID, L.SCP_LINE_ID)  ) OR (L.LINE_ID = A.LINE_ID ))	--2018-07-23 PIYONG L.LINE_ID = A.LINE_ID ADD
											AND L.ACTIVE_FLAG    = 'Y'
											AND A.SITE_ID        = C.SEGMENT2
											AND A.SHOP_GROUP_ID    = C.SEGMENT3
											AND A.DIVISION_ID      = C.SEGMENT5
											AND C.LOOKUP_TYPE_CODE = 'TARGET_INSTANCE'
											AND C.SEGMENT1         = 'SCP TARGET'
											AND C.ACTIVE_FLAG      = 'Y'
											AND L.FACTORY_ID     = FIF.FACTORY_ID		--2019-09-09 piyong add
											AND FIF.SHOP_GROUP_ID = C.SEGMENT3			--2019-09-09 piyong add
											AND FIF.INSTANCE_ID   = C.SEGMENT4			--2019-09-09 piyong add
											AND EXISTS ( SELECT 1 
														   FROM SCM_SYS_LOOKUP_VALUE LV1 WITH(NOLOCK)
														  WHERE LV1.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
															AND LV1.SEGMENT1         = C.SEGMENT4
															AND LV1.ACTIVE_FLAG      = 'Y'
															AND LV1.ATTRIBUTE1       = 'BUILDING'
														UNION ALL
														SELECT 1 
														  FROM SCM_SYS_LOOKUP_VALUE LV1 WITH(NOLOCK),
																SCM_SYS_LOOKUP_VALUE LV2 WITH(NOLOCK)
														 WHERE LV1.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
															AND LV2.LOOKUP_TYPE_CODE = 'INSTANCE_PLANNING_GROUP'
															AND LV1.SEGMENT1         = LV2.SEGMENT1
															AND LV1.SEGMENT1         = C.SEGMENT4
															AND LV1.ACTIVE_FLAG      = 'Y'
															AND LV1.ATTRIBUTE1       = 'PLAN GROUP'
															AND LV2.SEGMENT2         = ISNULL(L.MODEL_TYPE,LV2.SEGMENT2) )
																														) AS INSTANCE_ID
								   ,B.ALT_ID         -- 2019-01-17 kimcd BOM 대치 구분자
								   ,B.ALT_PRIORITY   -- 2019-01-17 kimcd BOM 대치 우선 순위
							  FROM (
									SELECT A.COMPANY_ID
											,A.DIVISION_ID
											,A.SITE_ID
											,A.PLANT_ID
											,A.ITEM_ID
											,MIN(A.MFG_WEEK) AS MFG_WEEK
											,A.SHOP_GROUP_ID --컬럼 추가. Cell 하위가 조회되는 것을 막기 위해
											,A.LINE_ID
									  FROM (
											 SELECT A.COMPANY_ID
													,A.DIVISION_ID
													,A.SITE_ID
													,A.PLANT_ID
													,A.ITEM_ID
													,A.MFG_WEEK
													,A.SHOP_GROUP_ID
													,A.LINE_ID
											   FROM [dbo].[FP_WEEKLY_DEMAND_PRODUCT_H] A WITH(NOLOCK)
													,(
														SELECT MAX(SCP_PLAN_ID) AS SCP_PLAN_ID , DIVISION_ID
														  FROM [FP_WEEKLY_DEMAND_PRODUCT_H]
														 WHERE SHOP_GROUP_ID != 'E'		-- 2018-10-15  PIYONG ADD
														 GROUP BY DIVISION_ID
																							) PLAN_SUBJECT
											  WHERE A.SCP_PLAN_ID  = PLAN_SUBJECT.SCP_PLAN_ID 
												AND A.DIVISION_ID  = PLAN_SUBJECT.DIVISION_ID
												AND SHOP_GROUP_ID != 'E'				-- 2018-10-15  PIYONG ADD
												AND MFG_WEEK IN (
																	-- 2018-12-26 kimcd 년 계산 오류 막음 SUBSTRING(CONVERT(CHAR(10),GETDATE(),120),1,4) + RIGHT('00' + CONVERT(VARCHAR, DATEPART(WEEK, GETDATE()), 23), 2)   -- 당주
																	-- 2018-12-26 kimcd 년 계산 오류 막음 ,SUBSTRING(CONVERT(CHAR(10),GETDATE(),120),1,4) + RIGHT('00' + CONVERT(VARCHAR, DATEPART(WEEK, GETDATE()+7), 23), 2) -- 차주
																	SELECT DISTINCT WEEK
																	FROM  [DBO].SCM_SYS_CALENDAR_M  SC WITH(NOLOCK)
																	WHERE DATE_ID >= CONVERT( DATE, GETDATE()) 
																	AND   DATE_ID <= CONVERT( DATE, DATEADD(D,7,GETDATE())) -- -- 2018-12-26 kimcd 년 계산 오류 개선
																) 
												AND A.SITE_ID = @site_id

											) A
										GROUP BY A.COMPANY_ID
											, A.DIVISION_ID
											, A.SITE_ID
											, A.PLANT_ID
											, A.ITEM_ID
											, A.SHOP_GROUP_ID  -- GROUP BY를 한 단계 늦춤.. 먼저 조회한 후에 GROUP BY하도록 함. SHOP_GROUP_ID, INSTANCE_ID 컬럼 추가함
											, A.LINE_ID
									---------------------------------------------------------------------------------------------------------------------------------------------------------------
									--2018-07-23 PIYONG TEST TARGET  ADD 시작
									UNION ALL
									SELECT A.COMPANY_ID
										   ,A.DIVISION_ID
										   ,A.SITE_ID
										   ,A.PLANT_ID
										   ,A.ITEM_ID
										   ,MIN(A.MFG_WEEK) AS MFG_WEEK
										   ,A.SHOP_GROUP_ID --컬럼 추가. Cell 하위가 조회되는 것을 막기 위해
										   ,A.LINE_ID
									  FROM (
											SELECT WDPH.[COMPANY_ID]
												   ,WDPH.[DIVISION_ID]
												   ,WDPH.[SITE_ID]
												   ,WDPH.[PLANT_ID]
												   ,WDPH.[ITEM_ID]
												   ,WDPH.[MFG_WEEK]
												   ,OM.OPERATION_GROUP_ID AS SHOP_GROUP_ID
												   ,WDPH.[LINE_ID]
											  FROM [FP_WEEKLY_DEMAND_PRODUCT_TEST_H] WDPH
												   ,[SCM_OPERATION_M] OM
											 WHERE WDPH.[COMPANY_ID] = OM.[COMPANY_ID]
											   AND WDPH.[DIVISION_ID] = OM.[DIVISION_ID]
											   AND WDPH.[SITE_ID] = OM.[SITE_ID]
											   AND WDPH.[OPERATION_ID] = OM.[OPERATION_ID]
											   AND OM.OPERATION_GROUP_ID IN ( 'A', 'P' )
											   AND WDPH.MFG_WEEK IN (
																		-- 2018-12-26 kimcd 년 계산 오류 막음 SUBSTRING(CONVERT(CHAR(10),GETDATE(),120),1,4) + RIGHT('00' + CONVERT(VARCHAR, DATEPART(WEEK, GETDATE()), 23), 2)   -- 당주
																		-- 2018-12-26 kimcd 년 계산 오류 막음 ,SUBSTRING(CONVERT(CHAR(10),GETDATE(),120),1,4) + RIGHT('00' + CONVERT(VARCHAR, DATEPART(WEEK, GETDATE()+7), 23), 2) -- 차주
																		SELECT DISTINCT WEEK
																		FROM  [DBO].SCM_SYS_CALENDAR_M  SC WITH(NOLOCK)
																		WHERE DATE_ID >= CONVERT( DATE, GETDATE()) 
																		AND   DATE_ID <= CONVERT( DATE, DATEADD(D,7,GETDATE())) -- -- 2018-12-26 kimcd 년 계산 오류 개선
																	) 
											   AND WDPH.SITE_ID = @site_id

										   ) A
									 GROUP BY A.COMPANY_ID
										   , A.DIVISION_ID
										   , A.SITE_ID
										   , A.PLANT_ID
										   , A.ITEM_ID
										   , A.SHOP_GROUP_ID
										   , A.LINE_ID
									--2018-07-23 PIYONG TEST TARGET  ADD 끝
									---------------------------------------------------------------------------------------------------------------------------------------------------------------
																			) A
								LEFT OUTER JOIN [dbo].[SCM_MODEL_COMP_TEMP] B WITH(NOLOCK)
											ON A.COMPANY_ID = B.COMPANY_ID
											AND A.DIVISION_ID = B.DIVISION_ID
											AND A.SITE_ID  = B.SITE_ID
											AND A.PLANT_ID =  B.PLANT_ID
											AND A.ITEM_ID = B.MODEL_ID
											AND B.PLANT_ID = B.CHILD_PLANT_ID -- 상위 PLANT_ID 와 하위PLANT_ID가 같은 ITEM 만
											-- 2019-01-07 kimcd 추가 시작. 오창 ESS 노칭 품목 제거
											AND NOT EXISTS ( SELECT 1
															 FROM   [DBO].[SCM_SYS_LOOKUP_VALUE] SLV WITH(NOLOCK),
																	[DBO].[SCM_FACTORY_M]        SFM WITH(NOLOCK)
															 WHERE  SLV.LOOKUP_TYPE_CODE = 'INSTANCE_OPERATION_EXCEPT' 
															 AND    SLV.ACTIVE_FLAG      = 'Y' 
															 AND    SFM.COMPANY_ID     = B.COMPANY_ID
															 AND    SFM.DIVISION_ID    = B.DIVISION_ID
															 AND    SFM.SITE_ID        = B.SITE_ID
															 AND    SFM.PLANT_ID       = B.CHILD_PLANT_ID
															 AND    SFM.DIVISION_ID    = SLV.SEGMENT2
															 AND    SFM.FACTORY_ID     = SLV.SEGMENT4
															 AND    SLV.SEGMENT5       = 'ALL'  -- 2019-02-13 kimcd 전체 라인 제외할 경우만 제외
															 AND    B.CHILD_ITEM_ID LIKE SLV.SEGMENT3 + '%' )
											-- 2019-01-07 kimcd 추가 끝
								LEFT OUTER JOIN ( --  하위 ITEM의 공정정보를 얻기 위해 조인
												SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID, A.NICK_NAME, A.ITEM_TYPE
														,A.STANDARD_COST
														,A.ITEM_CLASS
														,SUBSTRING(A.FLOW_ID, 1, 5) AS FLOW_ID
													   ,A.ACTIVE_FLAG											-- 2020-03-20 PIYONG ADD
													   ,C.USE_FLAG												-- 2020-03-20 PIYONG ADD
												  FROM SCM_ITEM_M A(NOLOCK)
													   INNER HASH JOIN SCM_ITEM_CLASS_M C(NOLOCK)
																	ON A.ITEM_CLASS = C.CLASS_ID
															--	   AND A.ACTIVE_FLAG = 'Y'						-- 2020-03-20 PIYONG DEL
															--	   AND C.USE_FLAG = 'Y'							-- 2020-03-20 PIYONG DEL
																   AND C.LEVEL_2_CODE NOT IN ( 'APC', 'ASL')  -- SLURRY 제외 추가 김춘동 로직 통일 필요.
																											) BB
											ON B.COMPANY_ID=BB.COMPANY_ID
											AND B.SITE_ID=BB.SITE_ID
											AND B.DIVISION_ID=BB.DIVISION_ID
											AND B.CHILD_ITEM_ID=BB.ITEM_ID
											AND B.CHILD_SITE_ID=BB.SITE_ID
								WHERE ( 
										( ISNULL(BB.ITEM_TYPE,'-') != 'R' OR B.CHILD_ITEM_ID LIKE 'A%' )	-- 2020-03-09 PIYONG CHANGE BB.ITEM_TYPE IN ('P','H','Q') -> BB.ITEM_TYPE != 'R'
										AND B.CHILD_ITEM_ID NOT IN ('ACETON', 'ADB02D')
									  )
								  AND (BB.FLOW_ID IS NULL OR BB.FLOW_ID LIKE A.SHOP_GROUP_ID + '%')
								  AND NOT ( ( A.ITEM_ID != B.CHILD_ITEM_ID AND ( ISNULL(BB.ITEM_CLASS,'') LIKE 'EM%' OR ISNULL(BB.ITEM_CLASS,'') LIKE 'ER%') ) ) -- 2020-03-09 PIYONG ADD BB.ITEM_CLASS LIKE 'ER%'
								  AND ISNULL(BB.USE_FLAG, 'N' ) = 'Y'										-- 2020-03-20 PIYONG ADD
								----------------------------------------------------------------------------------------------------------------------
								-- 2018-11-27 PIYONG PILOT 라인 제외
								  AND NOT EXISTS (
													SELECT 1
													  FROM [DBO].[SCM_SYS_LOOKUP_VALUE] WITH(NOLOCK)
													 WHERE LOOKUP_TYPE_CODE = 'PILOT_LINE'
													   AND ISNULL(ATTRIBUTE3, 'Y') = 'N'
													   AND ACTIVE_FLAG = 'Y'
													   AND SEGMENT2 = LINE_ID
													   AND SEGMENT3 = BB.FLOW_ID
												)
								-- 2018-11-27 PIYONG PILOT 라인 제외
								----------------------------------------------------------------------------------------------------------------------
								----------------------------------------------------------------------------------------------------------------------------------------------------------------
								-- 2020-03-09 PIYONG ADD
								----------------------------------------------------------------------------------------------------------------------------------------------------------------
								  AND NOT EXISTS (
													SELECT 1 					
													  FROM [SCM_BOM_M] BC WITH(NOLOCK)					
														   , [SCM_ITEM_LINE_ASSIGN_M] LA WITH(NOLOCK)	
														   , [SCM_LINE_M] L WITH(NOLOCK)
													 WHERE A.COMPANY_ID = BC.COMPANY_ID					
													   AND A.DIVISION_ID = BC.DIVISION_ID
													   AND A.SITE_ID = BC.SITE_ID
													   AND A.PLANT_ID = BC.PLANT_ID
													   AND B.PARENT_ITEM_ID = BC.PARENT_ITEM_ID
													   AND BC.EFF_END_DATE > CAST(GETDATE()-1 AS DATE)
													   AND B.ALT_ID = BC.ALT_ID
													   AND LA.COMPANY_ID = BC.COMPANY_ID
													   AND LA.DIVISION_ID = BC.DIVISION_ID
													   AND LA.SITE_ID = BC.SITE_ID
													   AND LA.PLANT_ID = BC.PLANT_ID
													   AND LA.ITEM_ID  = BC.CHILD_ITEM_ID
													   AND LA.MONTH    = CONVERT(VARCHAR(6), GETDATE(), 112)
													   AND LA.COMPANY_ID = L.COMPANY_ID
													   AND LA.DIVISION_ID = L.DIVISION_ID
													   AND LA.SITE_ID = L.SITE_ID
													   AND LA.PLANT_ID = L.PLANT_ID
													   AND LA.FACTORY_ID = L.FACTORY_ID
													   AND LA.LINE_ID  = L.LINE_ID
													   AND LA.OPERATION_ID = L.OPERATION_ID
													   AND LA.ELECTRODE_TYPE = L.ELECTRODE_TYPE
													   AND L.ACTIVE_FLAG = 'Y'
												)
							----------------------------------------------------------------------------------------------------------------------------------------------------------------
							-- 2020-03-09 PIYONG ADD END
							----------------------------------------------------------------------------------------------------------------------------------------------------------------
						) A
					--2018-03-02 PIYONG GROUP BY  ADD
				    GROUP BY NICK_NAME
						  ,ITEM_ID
						  ,CHILD_ITEM_ID
						  ,FLOW_ID
						  ,SHOP_GROUP_ID 
						  ,ITEM_TYPE
						  ,COMPANY_ID
						  ,DIVISION_ID
						  ,SITE_ID
						  ,CHILD_PLANT_ID
						  ,CHILD_COMPANY_ID
						  ,CHILD_DIVISION_ID
						  ,CHILD_SITE_ID
						  ,PLANT_ID
						  ,STANDARD_COST
						  ,INSTANCE_ID

					UNION ALL
					----------------------------------------------------------------------------------------------------------------------------------------------------------------
					--2018-02-27 PIYONG ADD 시작
					----------------------------------------------------------------------------------------------------------------------------------------------------------------
					--전극 E2000, E0500
					SELECT DISTINCT A.SHIP_WEEK AS MFG_WEEK
						   ,BB.NICK_NAME
						   ,A.ITEM_ID
						   ,A.ITEM_ID AS CHILD_ITEM_ID
						   ,BB.FLOW_ID
						   ,BB.ITEM_ID AS  MDM_ITEM_ID			-- 2020-03-20 PIYONG ADD
						   ,BB.ACTIVE_FLAG AS MDM_ACTIVE_FLAG	-- 2020-03-20 PIYONG ADD
						   ,A.SHOP_GROUP_ID 
						   ,BB.ITEM_TYPE
						   ,A.COMPANY_ID
						   ,A.DIVISION_ID
						   ,A.SITE_ID
						   ,A.PLANT_ID AS CHILD_PLANT_ID
						   ,A.COMPANY_ID AS CHILD_COMPANY_ID
						   ,A.DIVISION_ID AS CHILD_DIVISION_ID
						   ,A.SITE_ID AS CHILD_SITE_ID
						   ,A.PLANT_ID
						   ,BB.STANDARD_COST
						   ,( SELECT TOP 1 C.SEGMENT4
								FROM SCM_SYS_LOOKUP_VALUE C WITH(NOLOCK)
									 ,SCM_LINE_M L WITH(NOLOCK)
									 ,FP_INSTANCE_FACTORY_M FIF WITH(NOLOCK)	--2019-09-09 piyong add
							   WHERE L.COMPANY_ID     = A.COMPANY_ID
								 AND L.DIVISION_ID    = A.DIVISION_ID
								 AND L.SITE_ID        = A.SITE_ID
								 AND L.PLANT_ID       = A.PLANT_ID
								 AND ( ( L.SCP_LINE_ID    = ISNULL(A.LINE_ID, L.SCP_LINE_ID)  ) OR (L.LINE_ID = A.LINE_ID ))	--2018-07-23 PIYONG L.LINE_ID = A.LINE_ID ADD
								 AND L.ACTIVE_FLAG    = 'Y'
								 AND A.SITE_ID        = C.SEGMENT2
								 AND A.SHOP_GROUP_ID    = C.SEGMENT3
								 AND A.DIVISION_ID      = C.SEGMENT5
								 AND C.LOOKUP_TYPE_CODE = 'TARGET_INSTANCE'
								 AND C.SEGMENT1         = 'SCP TARGET'
								 AND C.ACTIVE_FLAG      = 'Y'
								 AND L.FACTORY_ID     = FIF.FACTORY_ID			--2019-09-09 piyong add
								 AND FIF.SHOP_GROUP_ID = C.SEGMENT3				--2019-09-09 piyong add
								 AND FIF.INSTANCE_ID   = C.SEGMENT4	) AS INSTANCE_ID 		--2019-09-09 piyong add
						   ,NULL   AS ALT_ID         -- 2019-01-17 kimcd BOM 대치 구분자
						   ,NULL   AS ALT_PRIORITY   -- 2019-01-17 kimcd BOM 대치 우선 순위
		  			  FROM #ELEC_TEMP A
					  LEFT OUTER JOIN ( --  ITEM의 공정정보를 얻기 위해 조인
										 SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID, A.NICK_NAME, A.ITEM_TYPE
											    ,A.STANDARD_COST
											    ,SUBSTRING(A.FLOW_ID, 1, 5) AS FLOW_ID
											    ,A.ACTIVE_FLAG							-- 2020-03-20 PIYONG ADD
										   FROM SCM_ITEM_M A(NOLOCK)
										  INNER HASH JOIN SCM_ITEM_CLASS_M C(NOLOCK)
													   ON A.ITEM_CLASS = C.CLASS_ID
													  AND A.ACTIVE_FLAG = 'Y'
													  AND C.USE_FLAG = 'Y'
													  AND C.LEVEL_2_CODE IN ( 'APC', 'ASL')
																							) BB
						     ON A.COMPANY_ID=BB.COMPANY_ID
						    AND A.SITE_ID=BB.SITE_ID
						    AND A.DIVISION_ID=BB.DIVISION_ID
						    AND A.ITEM_ID=BB.ITEM_ID
					 WHERE ( ( ISNULL(BB.ITEM_TYPE,'-') IN ('P','H','Q') OR A.ITEM_ID LIKE 'A%') AND A.ITEM_ID NOT IN ('ACETON', 'ADB02D') )
					   AND (BB.FLOW_ID IS NULL OR BB.FLOW_ID LIKE A.SHOP_GROUP_ID + '%')

					UNION ALL
					--MIXING 
					SELECT DISTINCT A.SHIP_WEEK AS MFG_WEEK
						   ,BB.NICK_NAME
						   ,A.ITEM_ID
						   ,B.CHILD_ITEM_ID
						   ,BB.FLOW_ID
						   ,BB.ITEM_ID AS  MDM_ITEM_ID			-- 2020-03-20 PIYONG ADD
						   ,BB.ACTIVE_FLAG AS MDM_ACTIVE_FLAG	-- 2020-03-20 PIYONG ADD
						   ,A.SHOP_GROUP_ID 
						   ,BB.ITEM_TYPE
						   ,A.COMPANY_ID
						   ,A.DIVISION_ID
						   ,A.SITE_ID
						   ,A.PLANT_ID AS CHILD_PLANT_ID
						   ,A.COMPANY_ID AS CHILD_COMPANY_ID
						   ,A.DIVISION_ID AS CHILD_DIVISION_ID
						   ,A.SITE_ID AS CHILD_SITE_ID
						   ,A.PLANT_ID
						   ,BB.STANDARD_COST
						   ,( SELECT TOP 1 C.SEGMENT4
								FROM SCM_SYS_LOOKUP_VALUE C WITH(NOLOCK)
									 ,SCM_LINE_M L WITH(NOLOCK)
									 ,FP_INSTANCE_FACTORY_M FIF WITH(NOLOCK)		--2019-09-09 piyong add
							   WHERE L.COMPANY_ID     = A.COMPANY_ID
								 AND L.DIVISION_ID    = A.DIVISION_ID
								 AND L.SITE_ID        = A.SITE_ID
								 AND L.PLANT_ID       = A.PLANT_ID
								 AND ( ( L.SCP_LINE_ID    = ISNULL(A.LINE_ID, L.SCP_LINE_ID)  ) OR (L.LINE_ID = A.LINE_ID ))	--2018-07-23 PIYONG L.LINE_ID = A.LINE_ID ADD
								 AND L.ACTIVE_FLAG    = 'Y'
								 AND A.SITE_ID        = C.SEGMENT2
								 AND A.SHOP_GROUP_ID    = C.SEGMENT3
								 AND A.DIVISION_ID      = C.SEGMENT5
								 AND C.LOOKUP_TYPE_CODE = 'TARGET_INSTANCE'
								 AND C.SEGMENT1         = 'SCP TARGET'
								 AND C.ACTIVE_FLAG      = 'Y'
								 AND L.FACTORY_ID     = FIF.FACTORY_ID				--2019-09-09 piyong add
								 AND FIF.SHOP_GROUP_ID = C.SEGMENT3					--2019-09-09 piyong add
								 AND FIF.INSTANCE_ID   = C.SEGMENT4	) AS INSTANCE_ID 		--2019-09-09 piyong add
						   ,B.ALT_ID         -- 2019-01-17 kimcd BOM 대치 구분자
						   ,CONVERT( NVARCHAR(30),B.ALT_PRIORITY) AS ALT_PRIORITY   -- 2019-01-17 kimcd BOM 대치 우선 순위
					  FROM (SELECT * FROM #ELEC_TEMP WHERE OP_TYPE = 'E2000' )A
					  LEFT OUTER JOIN [dbo].[SCM_BOM_M] B WITH(NOLOCK)
								   ON A.COMPANY_ID = B.COMPANY_ID
								  AND A.DIVISION_ID = B.DIVISION_ID
								  AND A.SITE_ID  = B.SITE_ID 
								  AND A.ITEM_ID = B.PARENT_ITEM_ID
								  AND B.ACTIVE_FLAG = 'Y'
								  AND B.EFF_START_DATE <= GETDATE()
								  AND B.EFF_END_DATE > GETDATE()
					  LEFT OUTER JOIN ( --  하위 ITEM의 공정정보를 얻기 위해 조인
										SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID, A.NICK_NAME, A.ITEM_TYPE
											   ,A.STANDARD_COST
											   ,SUBSTRING(A.FLOW_ID, 1, 5) AS FLOW_ID
											   ,A.ACTIVE_FLAG							-- 2020-03-20 PIYONG ADD
											   ,C.USE_FLAG
										  FROM SCM_ITEM_M A(NOLOCK)
										 INNER HASH JOIN SCM_ITEM_CLASS_M C(NOLOCK)
													  ON A.ITEM_CLASS = C.CLASS_ID
													 AND A.ACTIVE_FLAG = 'Y'
												--	 AND C.USE_FLAG = 'Y'				-- 2020-03-20 PIYONG ADD
													 AND C.LEVEL_2_CODE IN ( 'APC', 'ASL')
																							) BB
								   ON B.COMPANY_ID=BB.COMPANY_ID
								  AND B.SITE_ID=BB.SITE_ID
								  AND B.DIVISION_ID=BB.DIVISION_ID
								  AND B.CHILD_ITEM_ID=BB.ITEM_ID
					 WHERE ( ( ISNULL(BB.ITEM_TYPE,'-') IN ('P','H','Q') OR B.CHILD_ITEM_ID LIKE 'A%') AND B.CHILD_ITEM_ID NOT IN ('ACETON', 'ADB02D') )
				--	   AND (BB.FLOW_ID IS NULL OR BB.FLOW_ID LIKE A.SHOP_GROUP_ID + '%') -- Pack에서 Cell 하위 품목 조회되지 않도록 막음		-- 2020-03-09 PIYONG DEL
					----------------------------------------------------------------------------------------------------------------------------------------------------------------
					--2018-02-27 PIYONG ADD 끝
					----------------------------------------------------------------------------------------------------------------------------------------------------------------
					----------------------------------------------------------------------------------------------------------------------------------------------------------------
					-- 2020-03-09 PIYONG ADD
					----------------------------------------------------------------------------------------------------------------------------------------------------------------
					   AND NOT EXISTS (
										SELECT 1 					
										  FROM [SCM_BOM_M] BC WITH(NOLOCK)					
											   , [SCM_ITEM_LINE_ASSIGN_M] LA WITH(NOLOCK)	
											   , [SCM_LINE_M] L WITH(NOLOCK)
										 WHERE A.COMPANY_ID = BC.COMPANY_ID					
										   AND A.DIVISION_ID = BC.DIVISION_ID
										   AND A.SITE_ID = BC.SITE_ID
										   AND A.PLANT_ID = BC.PLANT_ID
										   AND A.ITEM_ID = BC.PARENT_ITEM_ID
										   AND BC.EFF_END_DATE > CAST(GETDATE()-1 AS DATE)
										   AND B.ALT_ID = BC.ALT_ID
										   AND LA.COMPANY_ID = BC.COMPANY_ID
										   AND LA.DIVISION_ID = BC.DIVISION_ID
										   AND LA.SITE_ID = BC.SITE_ID
										   AND LA.PLANT_ID = BC.PLANT_ID
										   AND LA.ITEM_ID  = BC.CHILD_ITEM_ID
										   AND LA.MONTH    = CONVERT(VARCHAR(6), GETDATE(), 112)
										   AND LA.COMPANY_ID = L.COMPANY_ID
										   AND LA.DIVISION_ID = L.DIVISION_ID
										   AND LA.SITE_ID = L.SITE_ID
										   AND LA.PLANT_ID = L.PLANT_ID
										   AND LA.FACTORY_ID = L.FACTORY_ID
										   AND LA.LINE_ID  = L.LINE_ID
										   AND LA.OPERATION_ID = L.OPERATION_ID
										   AND LA.ELECTRODE_TYPE = L.ELECTRODE_TYPE
										   AND L.ACTIVE_FLAG = 'Y'
										)
					----------------------------------------------------------------------------------------------------------------------------------------------------------------
					-- 2020-03-09 PIYONG ADD END
					----------------------------------------------------------------------------------------------------------------------------------------------------------------
					   AND BB.USE_FLAG = 'Y'							-- 2020-03-20 PIYONG ADD
				   ) A
				------------------------------------------------------------------------------
				-- 2019-09-19 PIYONG ADD
			 WHERE A.PLANT_ID IN (
									SELECT V.SEGMENT1
									  FROM SCM_SYS_LOOKUP_VALUE V  WITH(NOLOCK)
									 WHERE V.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
									   AND V.ACTIVE_FLAG = 'Y'
									   AND V.SEGMENT2    = @P_BASIS_START_TIME
								 )
				-- 2019-09-19 PIYONG ADD
				------------------------------------------------------------------------------




			DECLARE CUR_INSTANCE_LIST CURSOR FOR				
				 SELECT SEGMENT2, ATTRIBUTE1						--instance별 MAIL 수신자  조회
				   FROM [DBO].[SCM_SYS_LOOKUP_VALUE] WITH(NOLOCK)
				  WHERE LOOKUP_TYPE_CODE = 'STANDARD_INFO_MAIL'
					AND SEGMENT1 = @site_id
					AND ACTIVE_FLAG = 'Y'
					AND ATTRIBUTE1 IS NOT NULL

			OPEN CUR_INSTANCE_LIST;
		
			FETCH NEXT FROM CUR_INSTANCE_LIST INTO @INSTANCE_ID
												   ,@MAIL_ADDR
			WHILE (@@FETCH_STATUS = 0)
				BEGIN
					SET @MAIL_TITLE = N'[DEV] [Notification]Daily Master Data Check('+ SUBSTRING(CONVERT(NVARCHAR(10),GETDATE(), 102), 3, 8)+')'
/*				
				SET @TABLE_HEAD_CONTENT = (
										SELECT 'Week' as td ,'PJT Code' as td ,'MODEL' as td ,'Material' as td ,'Oper.' as td , 'FP Line Assign' as td ,'FP Daily CAPA' as td ,'MDM Code Expansion' as td, 'MMD Routing' as td  ,'ERP BOM Expaning' as td ,'ERP Prod Version' as td 
										 FOR   XML RAW('tr'), ELEMENTS
									 )
*/
					SET @MAIL_CONTENT = N'INSTANCE '+@INSTANCE_ID+N' 기준 정보 '
					SET @MAIL_RECEIVER_LIST = ''
					SET @TABLE_CONTENTS = ''
					SET @BEFOR_MFG_WEEK = ''
					SET @BEFOR_NICK_NAME = ''
					SET @BEFOR_MODEL_ID = ''

/*
				SET @TABLE_CONTENTS = ( SELECT td = MFG_WEEK, td = NICK_NAME, td = MODEL_ID, td = CHILD_ITEM_ID, td = FLOW_ID, td = LINE_ASSIGN, td = DAILY_CAPA, td = MDM_CODE_EXPANSION, td = MMD_ROUTING, td = ERP_BOM_EXPANING, td = ERP_PROD_VERSION
										  FROM (
												SELECT MFG_WEEK
													   ,NICK_NAME
													   ,MODEL_ID
													   ,CHILD_ITEM_ID
													   ,FLOW_ID
													   ,ITEM_TYPE
													   ,CASE WHEN LINE_ASSIGN = '' OR LINE_ASSIGN IS NULL THEN
																'X'
															 ELSE
																'O'
															  END  AS LINE_ASSIGN
													   ,CASE WHEN DAILY_CAPA = '' OR DAILY_CAPA IS NULL THEN
																'X'
															 ELSE
																'O'
															  END  AS DAILY_CAPA
													   ,MDM_CODE_EXPANSION
													   ,MMD_ROUTING
													   ,ERP_BOM_EXPANING 
													   ,CASE WHEN LINE_ASSIGN IS NULL AND ERP_PROD_VERSION = 'O' THEN
																'X'
															 ELSE
																ERP_PROD_VERSION
															  END AS ERP_PROD_VERSION
												  FROM #STANDARD_INFO
												 WHERE PLANT_ID = @INSTANCE_ID
											   ) Z
										 WHERE 1=1
									     ORDER BY MFG_WEEK
											   ,NICK_NAME
												,MODEL_ID
											   ,CHILD_ITEM_ID
											   ,FLOW_ID
							 FOR   XML RAW('tr'), ELEMENTS
							)
*/
				DECLARE CUR_DATA_LIST CURSOR FOR				--INSTANCE 별 발송
					SELECT MFG_WEEK
						   ,CASE WHEN NICK_NAME = '' OR NICK_NAME IS NULL THEN '-' ELSE NICK_NAME END AS NICK_NAME
						   ,MODEL_ID
						   ,CHILD_ITEM_ID
						   ,ISNULL(FLOW_ID, '-') AS FLOW_ID
						   ,LINE_ASSIGN
						   ,DAILY_CAPA
						   ,MDM_CODE_EXPANSION
						   ,MDM_VALUATION_CLASS						-- 2020-03-20 PIYONG ADD
						   ,MMD_ROUTING
						   ,ERP_BOM_EXPANING 
						   ,ERP_PROD_VERSION
						   ,STANDARD_COST
						   ,MODEL_PIC
						   ,COUNT(MFG_WEEK) OVER( PARTITION BY MFG_WEEK ORDER BY MFG_WEEK  ) AS WEEK_CNT
						   ,COUNT(NICK_NAME) OVER( PARTITION BY MFG_WEEK, NICK_NAME ORDER BY MFG_WEEK , NICK_NAME ) AS NICK_CNT
						   ,COUNT(MODEL_ID) OVER( PARTITION BY MFG_WEEK, MODEL_ID ORDER BY MFG_WEEK, MODEL_ID ) AS MODEL_CNT
					  FROM (
							SELECT MFG_WEEK
								   ,NICK_NAME
								   ,MODEL_ID
								   ,CHILD_ITEM_ID
								   ,FLOW_ID
								   ,CASE WHEN LINE_ASSIGN = '' OR LINE_ASSIGN IS NULL THEN
											'X'
										 ELSE
											'O'
										  END  AS LINE_ASSIGN
								   ,CASE WHEN LINE_ASSIGN IS NULL AND DAILY_CAPA = 'O' THEN
											'X'
										  ELSE
											DAILY_CAPA
										   END  AS DAILY_CAPA
								   ,MDM_CODE_EXPANSION
								   ,MDM_VALUATION_CLASS												-- 2020-03-20 PIYONG ADD
								   ,MMD_ROUTING
								   ,ERP_BOM_EXPANING 
								   ,CASE WHEN LINE_ASSIGN IS NULL AND ERP_PROD_VERSION = 'O' THEN
											'X'
										 ELSE
											ERP_PROD_VERSION
										  END AS ERP_PROD_VERSION
								   ,STANDARD_COST
								   ,MODEL_PIC
								   ,ITEM_TYPE
								   ,CASE WHEN ALT_ID IS NULL THEN 1 ELSE ROW_NUMBER() OVER ( PARTITION BY MODEL_ID, FLOW_ID, ALT_ID ORDER BY ISNULL(LINE_ASSIGN,'Z'), ISNULL(ALT_PRIORITY,'Z'), CHILD_ITEM_ID) END AS ORD_PRIORITY -- 2019-01-17 kimcd 라인 Assign이 존재하는 것 우선
							  FROM #STANDARD_INFO
							 WHERE INSTANCE_ID = @INSTANCE_ID
						   ) A
					 WHERE ( LINE_ASSIGN = 'X'
							OR DAILY_CAPA = 'X'
							OR MDM_CODE_EXPANSION = 'X'
							OR MDM_VALUATION_CLASS = 'X'											-- 2020-03-20 PIYONG ADD
							OR MMD_ROUTING = 'X'
							OR ERP_BOM_EXPANING  = 'X'
							OR ERP_PROD_VERSION = 'X'
							OR STANDARD_COST = 'X' )
						AND ORD_PRIORITY = 1 -- 2019-01-17 kimcd 모델, 공정별 ALT ID별로 한 품목만 추출.
					 ORDER BY MFG_WEEK
--						   ,NICK_NAME				--2018-03-12 PIYONG 주석처리
						   ,MODEL_ID
   					       ,ITEM_TYPE DESC
						   ,FLOW_ID DESC
						   ,CHILD_ITEM_ID


				OPEN CUR_DATA_LIST;
		
				FETCH NEXT FROM CUR_DATA_LIST INTO @MFG_WEEK
													,@NICK_NAME
												    ,@MODEL_ID
												    ,@CHILD_ITEM_ID
												    ,@FLOW_ID
												    ,@LINE_ASSIGN
												    ,@DAILY_CAPA
												    ,@MDM_CODE_EXPANSION
													,@MDM_VALUATION_CLASS		-- 2020-03-20 PIYONG ADD
												    ,@MMD_ROUTING
												    ,@ERP_BOM_EXPANING 
												    ,@ERP_PROD_VERSION
													,@STANDARD_COST
													,@MODEL_PIC
													,@WEEK_CNT
													,@NICK_CNT
													,@MODEL_CNT

				WHILE (@@FETCH_STATUS = 0)
					BEGIN

						
--select @W_CNT, @WEEK_CNT,@BEFOR_MFG_WEEK, @MFG_WEEK, @N_CNT, @NICK_CNT, @BEFOR_NICK_NAME, @NICK_NAME, @M_CNT, @MODEL_CNT, @BEFOR_MODEL_ID, @MODEL_ID 
						SET @TABLE_CONTENTS = @TABLE_CONTENTS+'<tr style=''text-align:center;''>'    --2022-10-12 leeseongmin 시인성작업 ( 테두리 라인 및 정렬 )

						IF @BEFOR_MFG_WEEK != @MFG_WEEK
							BEGIN
								SET @TABLE_CONTENTS = @TABLE_CONTENTS + '<td ROWSPAN='''+CAST(@WEEK_CNT AS nvarchar)+'''>'+@MFG_WEEK+'</td>'
								SET @BEFOR_MFG_WEEK = @MFG_WEEK
							END

						IF @BEFOR_MODEL_ID != @MODEL_ID
							BEGIN
								SET @TABLE_CONTENTS = @TABLE_CONTENTS + '<td ROWSPAN='''+CAST(@MODEL_CNT AS nvarchar)+'''>'+@MODEL_ID+'</td>'
								SET @BEFOR_MODEL_ID = @MODEL_ID
							END
																				

						SET @TABLE_CONTENTS = @TABLE_CONTENTS + '<td >'+@NICK_NAME+'</td>'																				
						--2018.03.12 PIYONG 주석 처리
/*
						IF @BEFOR_NICK_NAME != @NICK_NAME
							BEGIN
								SET @TABLE_CONTENTS = @TABLE_CONTENTS + '<td >'+@NICK_NAME+'</td>'

								IF @NICK_NAME = '-'
									BEGIN
										SET @BEFOR_NICK_NAME = @MODEL_ID
									  END
								ELSE
									BEGIN
										SET @BEFOR_NICK_NAME = @NICK_NAME
									  END
							END
*/


						SET @TABLE_CONTENTS = @TABLE_CONTENTS	+'<td>'+@CHILD_ITEM_ID+'</td>'
																+'<td>'+@FLOW_ID+'</td>'

						SET @TABLE_CONTENTS = 	CASE WHEN @LINE_ASSIGN = 'X' THEN
														@TABLE_CONTENTS+'<td style=''FONT-WEIGHT: bold; color:red;''>'+@LINE_ASSIGN+'</td>'
												     ELSE
														@TABLE_CONTENTS+'<td>'+@LINE_ASSIGN+'</td>'
													  END

						SET @TABLE_CONTENTS = 	CASE WHEN @DAILY_CAPA = 'X' THEN
														@TABLE_CONTENTS+'<td style=''FONT-WEIGHT: bold; color:red;''>'+@DAILY_CAPA+'</td>'
												     ELSE
														@TABLE_CONTENTS+'<td>'+@DAILY_CAPA+'</td>'
													  END

						SET @TABLE_CONTENTS = 	CASE WHEN @MDM_CODE_EXPANSION = 'X' THEN
														@TABLE_CONTENTS+'<td style=''FONT-WEIGHT: bold; color:red;''>'+@MDM_CODE_EXPANSION+'</td>'
												     ELSE
														@TABLE_CONTENTS+'<td>'+@MDM_CODE_EXPANSION+'</td>'
													  END

						SET @TABLE_CONTENTS = 	CASE WHEN @MDM_VALUATION_CLASS = 'X' THEN																-- 2020-03-20 PIYONG ADD
														@TABLE_CONTENTS+'<td style=''FONT-WEIGHT: bold; color:red;''>'+@MDM_VALUATION_CLASS+'</td>'
												     ELSE
														@TABLE_CONTENTS+'<td>'+@MDM_VALUATION_CLASS+'</td>'
													  END


						SET @TABLE_CONTENTS = 	CASE WHEN @MMD_ROUTING = 'X' THEN
														@TABLE_CONTENTS+'<td style=''FONT-WEIGHT: bold; color:red;''>'+@MMD_ROUTING+'</td>'
													 ELSE
														@TABLE_CONTENTS+'<td>'+@MMD_ROUTING+'</td>'
													  END

						SET @TABLE_CONTENTS = 	CASE WHEN @ERP_BOM_EXPANING = 'X' THEN
														@TABLE_CONTENTS+'<td style=''FONT-WEIGHT: bold; color:red;''>'+@ERP_BOM_EXPANING+'</td>'
													 ELSE
														@TABLE_CONTENTS+'<td>'+@ERP_BOM_EXPANING+'</td>'
													  END

						SET @TABLE_CONTENTS = 	CASE WHEN @ERP_PROD_VERSION = 'X' THEN
														@TABLE_CONTENTS+'<td style=''FONT-WEIGHT: bold; color:red;''>'+@ERP_PROD_VERSION+'</td>'
													 ELSE
														@TABLE_CONTENTS+'<td>'+@ERP_PROD_VERSION+'</td>'
													  END

						SET @TABLE_CONTENTS = 	CASE WHEN @STANDARD_COST = 'X' THEN
														@TABLE_CONTENTS+'<td style=''FONT-WEIGHT: bold; color:red;''>'+@STANDARD_COST+'</td>'
													 ELSE
														@TABLE_CONTENTS+'<td>'+@STANDARD_COST+'</td>'
													  END

						SET @TABLE_CONTENTS =   @TABLE_CONTENTS+'<td>'+@MODEL_PIC+'</td>'
												
													  
						SET @TABLE_CONTENTS = @TABLE_CONTENTS+'</tr>'

					FETCH NEXT FROM CUR_DATA_LIST INTO @MFG_WEEK
													,@NICK_NAME
												    ,@MODEL_ID
												    ,@CHILD_ITEM_ID
												    ,@FLOW_ID
												    ,@LINE_ASSIGN
												    ,@DAILY_CAPA
												    ,@MDM_CODE_EXPANSION
													,@MDM_VALUATION_CLASS	-- 2020-03-20 PIYONG ADD
												    ,@MMD_ROUTING
												    ,@ERP_BOM_EXPANING 
												    ,@ERP_PROD_VERSION
													,@STANDARD_COST
													,@MODEL_PIC
													,@WEEK_CNT
													,@NICK_CNT
													,@MODEL_CNT
													
					;
					END;
			
				CLOSE CUR_DATA_LIST;
				DEALLOCATE CUR_DATA_LIST;
				--2022-10-12 leeseongmin 시인성작업 ( 테두리 라인 및 정렬 )
				SET @TABLE_BODY = '  	<html>
								<head>
								<title>Untitled Document</title>
								<style>
   									* {margin:0;padding:0;}
   									body {font-family:Malgun Gothic, Arial, Helvetica, sans-serif;font-size:12px;line-height:1.8;color:#333333;}
   									table {width:100%;}
   									table th {background:#f5f5f5;border-bottom:1px solid #e1e1e1;}
   									table td {background:#fff;border-right:1px solid #e1e1e1;border-left:1px solid #e1e1e1;border-bottom:1px solid #e1e1e1;}
   									table tbody th {border-left:1px solid #e1e1e1;text-align:right;padding:6px 8px;}
   									table tbody td {text-align:left;padding:6px 8px;}
   									table thead th {text-align:center;padding:3px;border-right:1px solid #e1e1e1;border-left:1px solid #e1e1e1; border-bottom:1px solid #d1d1d1;}
                                    .hori-table table thead td {text-align:center;padding:3px;}  
   									.hori-table table tbody td {text-align:center;padding:3px;}
   									.vertical-table, .hori-table {margin-bottom:20px;}
                                    th, td { border: 1px solid #444444; }
								</style>
								</head>
								<body>' +
								REPLACE(ISNULL(@MAIL_CONTENT, ''), CHAR(10), '<br>') + 'Report generated on : ' + CONVERT(VARCHAR(10), GETDATE(), 120) + '
   									<br>
   									<div class=''wrap''>
       									<div class=''hori-table''>
           									<table style=''border-collapse:collapse; border-top:2px solid #c8294b; border-Bottom:2px solid #c8294b; border-left:2px solid #c8294b; border-right:2px solid #c8294b; max-width:2000px;''>
               									<thead>' 
													+'<tr>
														<th ROWSPAN = ''2''>Week</th>
														<th ROWSPAN = ''2''>MODEL</th>
														<th ROWSPAN = ''2''>PJT Code</th>
														<th ROWSPAN = ''2''>Material</th>
														<th ROWSPAN = ''2''>Oper.</th>
														<th COLSPAN = ''2''>FP</th>
														<th COLSPAN = ''2''>MDM</th>
														<th>MMD</th>
														<th COLSPAN = ''3''>ERP</th>
														<th ROWSPAN = ''2''>Model PIC</th>
													</tr>
													<tr>
														<th>Line Assign</th>
														<th>Daily CAPA</th>
														<th>Code Expansion</th>
														<th>Valuation Class</th>
														<th>Routing</th>
														<th>BOM Expaning</th>
														<th>Prod Version</th>
														<th>Cost Est.</th>
													</tr>
													'
               									+'</thead>
               									<tbody>' + ISNULL(@TABLE_CONTENTS, '') + '</tbody>
											</table>
           									</table>
       									</div>
   									</div>
								</body>
								</html>'

				SET @MAIL_RECEIVER_LIST = 'kimcd@lgespartner.com;leeseongmin@lgespartner.com;'+ISNULL( @MAIL_ADDR, '')


				IF LEN(@TABLE_CONTENTS) > 0
					BEGIN
						exec msdb.dbo.sp_send_dbmail @profile_name           = 'FP_MAIL_TEST'
													 , @recipients             = @MAIL_RECEIVER_LIST
													 , @query_result_separator = ';'
													 , @subject                = @MAIL_TITLE
													 , @body                   = @TABLE_BODY
													 , @body_format            = 'html'
					 END

				FETCH NEXT FROM CUR_INSTANCE_LIST INTO @INSTANCE_ID
										    ,@MAIL_ADDR
													
				;
			END;
			
		CLOSE CUR_INSTANCE_LIST;
		DEALLOCATE CUR_INSTANCE_LIST;


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
