

CREATE       PROCEDURE [dbo].[PR_XIF_ERP_PRODUCTION_PLAN_S_20261007]

-- ================================================================================================
-- Program ID          : FP01640
-- Program Name        : PR_XIF_ERP_PRODUCTION_PLAN_S
-- Param               :
-- Batch Period        : 1 Day
-- Description         :
--
-- Source System       : FP SDB
-- Destination System  : INF
-- Source Table        : FP_PRODUCTION_PLAN_R
-- Destination Table   : XIF_ERP_PRODUCTION_PLAN_R
--
-- Create Date         : 2016.09.08
-- Update Date         : 2017.04.07   W/O 검증을 위해 TRANSFER_FLAG X로 입력하도록 변경
--                       2017.05.24   FP-058 Top W/O 복사 과정 추가. kimcd
--                       2017.06.03   실적 취합하는 Table을 원천 Table로 변경 kimcd
--						 2017.06.14   조회 쿼리 수정 및 실적수량 조회 ADD_QTY 컬럼 추가
--					     2017.06.23  PIYONG 1.4    ADD_QTY 삭제  양품 수량에 이미 포함되어 있음
--						 2017.07.13  PIYONG	실적수량 조회 조건 추가
--						 2017.08.25  PIYONG SCM_MES_WIP_HISTORY_H 의 WIP_TYPE_CODE 조건에  PROD 추가
--						 2017.09.28  PIYONG 1.7
--						 2017.10.19  PIYONG 1.8
--                       2018.03.06  kimcd  1.9
--						 2018.04.18	 PIYONG 2.0
--						 2018.05.26	 kimcd  2.1
--						 2018.12.19  PIYONG 2.2
--						 2019.03.07  PIYONG 2.3
--                       2019.06.07  kimcd  2.4
--						 2019.06.10  PIYONG 2.5
--						 2019.07.18  PIYONG 2.51
--                       2019.10.01  kimcd  2.52
--                       2022.07.19  kimcd  2.53
--                       2024-12-19  chkim.68 NERP XIF_ERP_PRODUCTION_PLAN_S 테이블 변경 반영

-- Author              : 김 석
-- Version             : 1.1
--						 1.7  계획수량이 0이고, PLANT_DATE가 미래일 경우 PLAN_DATE, START_TIME, END_TIME의 날짜를 GET_DATE()-1 변경
--						 1.8 SLIT_PLANT_ID 조회 조건 추가
--                       1.9 2018-03-06 kimcd work order id 채번 rule 변경에 따른 TOP, Back 로직 WO 로직 수정
--						 2.0 FP_ERP_PRODUCTION_PLAN_M 생성된 WO 제외  로직 추가
--                       2.1 2018-05-26 kimcd 기존 WO와 비교 조건 수정 - FP 계획 라인 기준으로 수정하도록 함
--						 2.2 발생한 실적 수량의 양품만 적용
--						 2.3 중복 전송 WO 제외 로직 추가
--                       2.4 2019-06-07 kimcd SCM_ITEM_M에 COMPANY_ID 조인 누락에 따른 오류 보완
--						 2.5 MES와 FP 생산 계획 동기화 처리
--							 - WO 수량을 0으로 계획을 만들었으나 MES에서 이미 투입하여 실적이 발생했을 경우, 투입수량으로 WO 수량을 변경
--						 2.51 WO 수량 생성시 정수로 변경하는 로직(CEILING) 추가
--                       2.52 2019-10-01 kimcd scm_equipment_m join에서 factory id 추가
--                       2.53 2022-07-19 kimcd scm_equipment_m 정보를 필수에서 Option으로 변경.라인의 ERP Work Center ID 사용하도록 수정
--                       2.6  2025-12-29 yschoithira [E20251023-001125] 오더 수율 반영 계획 수량 조정 기능 ( 수율 보관 기간이 한달이어서 이전 Open W/O 전송되면 수량 차이로 결산 시 문제 발생 )
--																		에너지솔루션 업무 규칙으로는 월별로 실적 처리할 수 있는 W/O가 구분됨. -> 과거 월에 실적 처리된 W/O에는 이번 달에 실적 처리 불가
--																		시스템적으로는 2017년 5Mega Open하면서 과거 월 W/O, 이번 달 W/O에 대한 구분 관리 안 됨
--																		전월 마감이 3일 업무일에 이루어져서 3일 과거 w/o 배포 안 하는 것으로 하면 업무적으로 문제 없을 것으로 판단
--																		W/O 자동 Rolling도 과거 3일 이내 W/O만 재전송함
--																		월 구분 없이 과거 3일 이전 W/O는 배포 대상에서 제외함
--                       2.7  2026-08-04 kimcd          [PJ2026-50201] FP 라인별 환산자 산출 및 생산계획 반영
-- ================================================================================================

-- ERP요청 SEQNO
@P_FP_PLAN_ID NVARCHAR(50) = NULL

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_ERP_PRODUCTION_PLAN_S'
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
	DECLARE @IFSEQNO     NVARCHAR(50)
	DECLARE @v_PLAN_GROUP_ID	NVARCHAR(50)
	DECLARE @v_PLAN_WEEK		NVARCHAR(50)
	DECLARE @v_SCP_PLAN_ID	NVARCHAR(50)

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

		DELETE FROM [dbo].[SY_XIF_ERP_PRODUCTION_PLAN_S]
		 WHERE FP_PLAN_ID = ISNULL(@P_FP_PLAN_ID,'0')
		;

				SELECT   @v_PLAN_GROUP_ID = A.PLAN_GROUP_ID  -- PLAN_GRP
				,@v_PLAN_WEEK = (SELECT SLV.ATTRIBUTE15 FROM  SCM_SYS_LOOKUP_VALUE  SLV WITH(NOLOCK) WHERE SLV.LOOKUP_TYPE_CODE = 'INSTANCE_ID' AND SLV.SEGMENT1 = A.INSTANCE_ID)
				,@v_SCP_PLAN_ID = CASE WHEN P.SCP_PLAN_ID IS NOT NULL THEN P.SCP_PLAN_ID
					ELSE
						( SELECT TOP 1 WD.SCP_PLAN_ID
						FROM   [DBO].[FP_WEEKLY_DEMAND_PRODUCT_H] WD WITH(NOLOCK)
						WHERE  WD.[COMPANY_ID] = ( SELECT TOP 1 F.COMPANY_ID
													FROM   SCM_FACTORY_M  F WITH(NOLOCK)
															INNER JOIN FP_INSTANCE_FACTORY_M FIF WITH(NOLOCK)
															ON F.FACTORY_ID = FIF.FACTORY_ID
													WHERE  FIF.INSTANCE_ID = P.INSTANCE_ID )
						ORDER  BY WD.SCP_PLAN_ID DESC )     
					END     
			FROM (	SELECT  A.INSTANCE_ID
						,A.RELEASE_PLAN_ID
						,A.PLAN_GROUP_ID
						,'-'      AS FACTORY_ID   -- 2019-02-18 kimcd 컬럼 추가
				FROM   DBO.SCM_FP_PLAN_GROUP_DETAIL_H A
				WHERE  A.RELEASE_PLAN_ID  = ISNULL( @P_FP_PLAN_ID,'0')
				UNION ALL
				SELECT  A.INSTANCE_ID
						,A.RELEASE_PLAN_ID
						,'-' AS PLAN_GROUP_ID
						,A.FACTORY_ID             -- 2019-02-18 kimcd 컬럼 추가
				FROM   DBO.SCM_FP_PLAN_DETAIL_H A
				WHERE A.RELEASE_PLAN_ID  = ISNULL( @P_FP_PLAN_ID,'0')
				) A
				, DBO.SCM_FP_PLAN_H P
		WHERE A.INSTANCE_ID = P.INSTANCE_ID
			AND A.RELEASE_PLAN_ID = P.PLAN_ID


		INSERT INTO [dbo].[SY_XIF_ERP_PRODUCTION_PLAN_S] (
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
				,[MARKET] -- 170208 Add
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
				-- FP-058 kimcd 컬럼 추가 시작. 2017-05-24 
				,[TOP_BACK_IND] -- 단면 설비에 양면 제품이 계획된 경우 TOP BACK 구분
				,[LINK_WO]      -- 연계된 WO명 - TOP은 Back WO, Back은 TOP WO
				,[FP_PLAN_QTY]  -- FP Plan 수량
				,[FP_SNAP_QTY] -- FP 실적 수량
				-- FP-058 kimcd 컬럼 추가 끝. 2017-05-24
				-- TECO_IND -- 누락
				,[TECO_IND]
				-- NERP 신규컬럼 (2024-07-10)
				,[EQUIPMENT_ID] -- 전극 EQUIPMENT 정보
				,[ZMODEL]       -- 모델
				,[VERSION]      -- 문서 버전
				,[SERIAL]       -- 문서 시리얼
				
				,[PLAN_GRP]     -- SCP PLAN GROUP
				,[PLAN_WEEK]    -- SCP PLAN WEEK
				,[SCP_PLAN_ID]  -- SCP PLAN ID

				,[CUDTY]
				--- NERP 신규컬럼 (2024-07-10 끝)
				)
			SELECT @IFSEQNO
			--SELECT ''  
				   ,ROW_NUMBER() OVER( ORDER BY B.[FP_PLAN_ID], B.[PLANT_ID], B.[FACTORY_ID], B.[LINE_ID], B.[OPERATION_ID], /*A.[WORK_CENTER_ID],*/ B.[ITEM_ID], B.[WORK_ORDER_ID] ) AS SEQ -- modify by kimcd 2016-12-02
				   ,B.[FP_PLAN_ID]	
			       ,B.[PLANT_ID]
			       ,B.[FACTORY_ID]
			       ,B.[LINE_ID]
			       ,B.[OPERATION_ID]
			       ,B.[BOM_VERSION_ID]
			       ,B.[WORK_CENTER_ID]
			       ,B.[ITEM_ID]
			       ,B.[DEMAND_ID]
			       ,B.[WORK_ORDER_ID]
			       ,B.[ORDER_TYPE]
			       ,B.[PLAN_DATE]
			       ,B.[START_TIME]
			       ,B.[END_TIME]
				   ,B.PLAN_IN_QTY
			       ,B.PLAN_QTY
			       ,B.[FIX_TYPE]
			       ,'X'  AS TRANSFER_FLAG    
			       ,NULL AS TRANSFER_DATE
			       ,'PR_XIF_ERP_PRODUCTION_PLAN_S' AS CREATE_USER_ID
			       ,GETDATE() AS CREATE_DATE
			       ,'PR_XIF_ERP_PRODUCTION_PLAN_S' AS MODIFY_USER_ID
			       ,GETDATE() AS MODIFY_DATE
			       ,B.LANE_QTY
			       ,B.BATCH_ORDER_ID
			       ,B.SLIT_PLANT_ID
			       ,B.MARKET
			       ,B.ATTRIBUTE1					-- 2018-04-18 PIYONG ADD
			       ,NULL
			       ,NULL
			       ,NULL
			       ,NULL
			       ,NULL
			       ,NULL
			       ,NULL
			       ,NULL
			       ,NULL
			       ,B.TOP_BACK_IND -- 단면 설비에 양면 제품이 계획된 경우 TOP BACK 구분
			       ,B.LINK_WO      -- 연계된 WO명 - TOP은 Back WO, Back은 TOP WO
			       ,B.FP_PLAN_QTY -- FP Plan 수량
			       ,B.FP_SNAP_QTY  -- FP 실적 수량

				    -- TECO_IND -- 누락
				,NULL
				-- NERP 신규컬럼 (2024-07-10)
				 ,B.EQUIPMENT_ID -- 전극 EQUIPMENT 정보
				,B.ZMODEL-- 전극 EQUIPMENT 정보
				--,B.VERSION-- 전극 문서 버전
				-- 2026-08-04 kimcd [PJ2026-50201] FP 라인별 환산자 산출 및 생산계획 반영 [FP_MES_FACTORY_M_V],[FP_PDS_VERSION_M] outer join 추가. PDS VERSION table 우선 사용.
				,CASE WHEN B.[VERSION] = '-' THEN NULL 
				 ELSE CASE WHEN F.ELEC_VERSION_TYPE = 'FP'  THEN B.[VERSION]
					  ELSE ISNULL(PVM.[PDS_VERSION], B.[VERSION])
					  END
				 END AS [VERSION]
				,B.SERIAL-- 전극 문서 시리얼
				,@v_PLAN_GROUP_ID AS PLAN_GRP
				,@v_PLAN_WEEK AS PLAN_WEEK
				,@v_SCP_PLAN_ID  AS SCP_PLAN_ID

				,'C' AS [CUDTY]
				--- NERP 신규컬럼 (2024-07-10 끝)


			  FROM (
					SELECT A.[FP_PLAN_ID]	
						   ,A.[PLANT_ID]
						   ,A.[FACTORY_ID]
						   ,A.[LINE_ID]
						   ,A.[OPERATION_ID]
						   ,A.[BOM_VERSION_ID]
						   ,A.[WORK_CENTER_ID]
						   ,A.[ITEM_ID]
						   ,A.[DEMAND_ID]
						   ,A.[WORK_ORDER_ID]
						   ,A.[ORDER_TYPE]
						   ,A.[PLAN_DATE]
						   ,A.[START_TIME]
						   ,A.[END_TIME]
						   ,CASE WHEN A.FP_PLAN_QTY = 0 THEN		-- 2019-06-10 PIYONG CHANG A.[PLAN_IN_QTY] -> CASE
									CASE WHEN ISNULL(M.ATTRIBUTE9, 'N' ) = 'N' THEN									-- WO CLOSE 여부
											--2019-07-18 PIYONG ADD CEILING 
											CEILING( ISNULL( CAST(M.ATTRIBUTE10 AS NUMERIC(25,10)), 0 ) * ISNULL((			-- MES 투입 수량 * 계획 일자 수율
																													SELECT [YIELD]
																													  FROM SCM_YIELD_M  WITH(NOLOCK)
																													 WHERE [COMPANY_ID] = A.COMPANY_ID
																													   AND [DIVISION_ID] = A.DIVISION_ID
																													   AND [SITE_ID] = A.SITE_ID
																													   AND [PLANT_ID] = A.PLANT_ID
																													   AND [FACTORY_ID] = A.[FACTORY_ID]
																													   AND [OPERATION_ID] = A.[OPERATION_ID]
																													   AND [LINE_ID] = A.[FP_LINE_ID]
																													   AND [ITEM_ID] =A.[ITEM_ID]
																													   AND [MONTH] = (
																																		SELECT YEAR+MONTH
																																		  FROM [DBO].SCM_SYS_CALENDAR_M WITH(NOLOCK)
																																		 WHERE DATE_ID = SUBSTRING( A.[PLAN_DATE], 1, 8)
																																	  )
																												), 1 )
													)
										 ELSE 0 
										 END 
								 ELSE
									A.[PLAN_IN_QTY]
								 END AS PLAN_IN_QTY
						   ,CASE WHEN A.FP_PLAN_QTY = 0 THEN		-- 2019-06-10 PIYONG CHANG A.[PLAN_IN_QTY] -> CASE
								    CASE WHEN ISNULL(M.ATTRIBUTE9, 'N' ) = 'N' THEN
											--2019-07-18 PIYONG ADD CEILING 
											CEILING( ISNULL( CAST(M.ATTRIBUTE10 AS NUMERIC(25,10)), 0 ) * ISNULL((
																													SELECT [YIELD]
																													  FROM SCM_YIELD_M  WITH(NOLOCK)
																													 WHERE [COMPANY_ID] = A.COMPANY_ID
																													   AND [DIVISION_ID] = A.DIVISION_ID
																													   AND [SITE_ID] = A.SITE_ID
																													   AND [PLANT_ID] = A.PLANT_ID
																													   AND [FACTORY_ID] = A.[FACTORY_ID]
																													   AND [OPERATION_ID] = A.[OPERATION_ID]
																													   AND [LINE_ID] = A.[FP_LINE_ID]
																													   AND [ITEM_ID] =A.[ITEM_ID]
																													   AND [MONTH] = (
																																		SELECT YEAR+MONTH
																																		  FROM [DBO].SCM_SYS_CALENDAR_M WITH(NOLOCK)
																																		 WHERE DATE_ID = SUBSTRING( A.[PLAN_DATE], 1, 8)
																																	  )
																												), 1 )
													)
										 ELSE 0
										 END 
								 ELSE
									A.[PLAN_QTY]
								 END AS [PLAN_QTY]
						   ,A.[FIX_TYPE]
						   ,A.LANE_QTY
						   ,A.BATCH_ORDER_ID
						   ,A.SLIT_PLANT_ID
						   ,A.MARKET
						   ,CASE WHEN A.PLAN_IN_QTY = 0 THEN 'Deleted'
								 WHEN (SELECT COUNT (*)
										 FROM FP_ERP_PRODUCTION_PLAN_M B WITH(NOLOCK)
										WHERE B.WORK_ORDER_ID = A.[WORK_ORDER_ID] ) = 0 THEN
									'Created'
								 ELSE 'Changed' END AS ATTRIBUTE1					-- 2018-04-18 PIYONG ADD
						   ,A.TOP_BACK_IND -- 단면 설비에 양면 제품이 계획된 경우 TOP BACK 구분
						   ,A.LINK_WO      -- 연계된 WO명 - TOP은 Back WO, Back은 TOP WO
						   ,A.FP_PLAN_QTY	-- FP Plan 수량
						   ,A.FP_SNAP_QTY  -- FP 실적 수량
						   ,A.FP_START_TIME
						   ,A.FP_END_TIME
						   ,A.FP_LINE_ID
						   ,A.EQUIPMENT_ID -- NERP 전송 데이터
						   		    ,A.ZMODEL
									,A.VERSION
									,A.SERIAL
					  FROM ( 
							SELECT A.[FP_PLAN_ID] 
								   ,A.[COMPANY_ID]
								   ,A.[DIVISION_ID]
								   ,A.[SITE_ID]
								   ,A.[PLANT_ID]
								   ,A.[FACTORY_ID]
								   ,MAX(A.[FP_LINE_ID])  AS FP_LINE_ID    --  2018-05-26 kimcd 계획 라인 비교 기준 추가
								   ,SUBSTRING(MAX(A.LINE_ID), 1, CHARINDEX('^', MAX(A.LINE_ID))-1)  AS LINE_ID  -- A.[LINE_ID]  modify by kimcd 2016-12-02
								   ,A.[OPERATION_ID]
								   ,A.[BOM_VERSION_ID]	
								   ,SUBSTRING(MAX(A.LINE_ID), CHARINDEX('^', MAX(A.LINE_ID))+1, LEN(MAX(A.LINE_ID)))  AS WORK_CENTER_ID -- A.[WORK_CENTER_ID]	 modify by kimcd 2016-12-02
								   ,A.[ITEM_ID]
								   ,MAX( A.[DEMAND_ID]) AS DEMAND_ID -- modify by kimcd 2016-12-02
								   ,A.[WORK_ORDER_ID]
								   ,A.[WORK_ORDER_SPL_ID]
								   ,MAX(A.ORDER_TYPE) AS ORDER_TYPE
								   ,MAX(A.PLAN_DATE) AS PLAN_DATE
								   ,MAX(A.START_TIME) AS START_TIME
								   ,MAX(A.END_TIME) AS END_TIME
								   ,SUM(A.PLAN_QTY) + ( SELECT ISNULL( SUM(ISNULL(W.WIPQTY2_ED,0)) --2018-12-19 PIYONG IN 수량 컬럼에 OUT 수량을 입력
																		--	+ SUM(ISNULL(CONVERT(NUMERIC(14,3),W.CNFM_DFCT_QTY2),0))		--2018-12-19 PIYONG DEL
																		--	+ SUM(ISNULL(CONVERT(NUMERIC(14,3),W.CNFM_LOSS_QTY2),0))		--2018-12-19 PIYONG DEL 
																		--	+ SUM(ISNULL(CONVERT(NUMERIC(14,3),W.CNFM_PRDT_REQ_QTY2),0))	--2018-12-19 PIYONG DEL
																		--	+ SUM(ISNULL(CAST(W.SCRAP_QTY AS NUMERIC(14,3)),0))				--2018-12-19 PIYONG DEL
																		,0)
														   FROM DBO.SCM_MES_WIP_HISTORY_H W WITH(NOLOCK, INDEX(IDX1_SCM_MES_WIP_HISTORY_H))
														  WHERE W.WOID   = A.WORK_ORDER_ID
															AND W.PROCID = A.OPERATION_ID
															AND W.WIP_TYPE_CODE in ( 'OUT','INOUT','PACKED', 'PROD')	-- PIYONG 2017-08-25 PROD 추가
														  ) AS PLAN_IN_QTY
								   ,SUM(A.PLAN_QTY) + ( SELECT ISNULL( SUM(ISNULL(W.WIPQTY2_ED,0))
																	--	+ SUM(ISNULL(CONVERT(NUMERIC(14,3),W.CNFM_DFCT_QTY2),0))			--2018-12-19 PIYONG DEL
																	--	+ SUM(ISNULL(CONVERT(NUMERIC(14,3),W.CNFM_LOSS_QTY2),0))			--2018-12-19 PIYONG DEL
																	--	+ SUM(ISNULL(CONVERT(NUMERIC(14,3),W.CNFM_PRDT_REQ_QTY2),0))		--2018-12-19 PIYONG DEL
																	--	+ SUM(ISNULL(CAST(W.SCRAP_QTY AS NUMERIC(14,3)),0))					--2018-12-19 PIYONG DEL
																	,0)
														   FROM DBO.SCM_MES_WIP_HISTORY_H W WITH(NOLOCK, INDEX(IDX1_SCM_MES_WIP_HISTORY_H))
														  WHERE W.WOID   = A.WORK_ORDER_ID
															AND W.PROCID = A.OPERATION_ID
															AND W.WIP_TYPE_CODE in ( 'OUT','INOUT','PACKED', 'PROD')	-- PIYONG 2017-08-25 PROD 추가
													 ) AS PLAN_QTY
								   ,MAX(A.FIX_TYPE) AS FIX_TYPE
								   ,SUM(A.LANE_QTY) AS LANE_QTY
								   ,MAX(A.BATCH_ORDER_ID) AS BATCH_ORDER_ID
								   ,MAX(A.SLIT_PLANT_ID) AS SLIT_PLANT_ID
								   ,MARKET-- 170208 Add   
								   -- FP-058 kimcd 컬럼 추가 시작. 2017-05-24 
								   ,MAX(A.[TOP_BACK_IND])     AS TOP_BACK_IND -- 단면 설비에 양면 제품이 계획된 경우 TOP BACK 구분
								   ,MAX(RTRIM(A.[LINK_WO]))   AS LINK_WO      -- 연계된 WO명 - TOP은 Back WO, Back은 TOP WO
								   ,SUM(A.[FP_PLAN_QTY])      AS FP_PLAN_QTY -- FP Plan 수량
								   ,( SELECT ISNULL( SUM(ISNULL(W.WIPQTY2_ED,0))
													--	+ SUM(ISNULL(CONVERT(NUMERIC(14,3),W.CNFM_DFCT_QTY2),0))							--2018-12-19 PIYONG DEL 
													--	+ SUM(ISNULL(CONVERT(NUMERIC(14,3),W.CNFM_LOSS_QTY2),0))							--2018-12-19 PIYONG DEL 
													--	+ SUM(ISNULL(CONVERT(NUMERIC(14,3),W.CNFM_PRDT_REQ_QTY2),0))						--2018-12-19 PIYONG DEL
													--	+ SUM(ISNULL(CAST(W.SCRAP_QTY AS NUMERIC(14,3)),0))									--2018-12-19 PIYONG DEL
													,0)
										FROM DBO.SCM_MES_WIP_HISTORY_H W WITH(NOLOCK, INDEX(IDX1_SCM_MES_WIP_HISTORY_H))
									   WHERE W.WOID   = A.WORK_ORDER_ID
										 AND W.PROCID = A.OPERATION_ID
										 AND W.WIP_TYPE_CODE in ( 'OUT','INOUT','PACKED', 'PROD')	-- PIYONG 2017-08-25 PROD 추가
																															) AS FP_SNAP_QTY	-- FP 실적 수량
								   -- FP-058 kimcd 컬럼 추가 끝. 2017-05-24
								   ,MAX(A.FP_START_TIME)    AS FP_START_TIME
								   ,MAX(A.FP_END_TIME)      AS FP_END_TIME
								   ,MAX(A.EQUIPMENT_ID) AS EQUIPMENT_ID -- ERP 전송 대상으로 변경 (NERP)
								   ,MAX(ZMODEL) AS ZMODEL
								   ,MAX(VERSION) AS VERSION
								   ,MAX(SERIAL) AS SERIAL
					          FROM (
									SELECT A.[FP_PLAN_ID]
										   ,A.[COMPANY_ID]
										   ,A.[DIVISION_ID]
										   ,A.[SITE_ID]
										   ,A.[PLANT_ID]
										   ,A.[FACTORY_ID]
										   ,A.[LINE_ID]   AS FP_LINE_ID  --  2018-05-26 kimcd 계획 라인 비교 기준 추가
										   ,CASE WHEN A.INSTANCE_ID = 'KR_PACK' AND A.WORK_CENTER_ID != '-' THEN A.LINE_ID + '^' + A.WORK_CENTER_ID
												 WHEN B.ATTRIBUTE1 IS NOT NULL THEN
													(SELECT TOP 1 ISNULL(C.MES_LINE_ID,'-') + '^' + ISNULL(C.WORK_CENTER_ID,'-')  FROM [dbo].[SCM_EQUIPMENT_M] C WITH(NOLOCK)
													  WHERE C.COMPANY_ID = B.ATTRIBUTE1
													    AND C.DIVISION_ID = B.ATTRIBUTE2
														AND C.SITE_ID = A.SITE_ID
														AND C.PLANT_ID = B.ATTRIBUTE3
														AND C.EQUIPMENT_ID = A.EQUIPMENT_ID
														AND C.OPERATION_ID = A.OPERATION_ID
													 )
												  ELSE
													ISNULL ( (SELECT TOP 1 ISNULL(C.MES_LINE_ID,'-') + '^' + ISNULL(C.WORK_CENTER_ID,'-')  FROM [dbo].[SCM_EQUIPMENT_M] C WITH(NOLOCK)
															  WHERE C.COMPANY_ID = A.COMPANY_ID
																AND C.DIVISION_ID = A.DIVISION_ID
																AND C.SITE_ID = A.SITE_ID
																AND C.PLANT_ID = A.PLANT_ID
																AND C.FACTORY_ID = A.FACTORY_ID -- 2019-10-01 kimcd 중복 방지용 조건 추가
																AND C.EQUIPMENT_ID = A.EQUIPMENT_ID
																AND C.OPERATION_ID = A.OPERATION_ID
															 ), (SELECT TOP 1 ISNULL(C.MES_LINE_ID,'-') + '^' + ISNULL(C.WORK_CENTER_ID,'-')  FROM [dbo].[SCM_LINE_M] C WITH(NOLOCK)
																  WHERE C.COMPANY_ID     = A.COMPANY_ID
																	AND C.DIVISION_ID    = A.DIVISION_ID
																	AND C.SITE_ID        = A.SITE_ID
																	AND C.PLANT_ID       = A.PLANT_ID
																	AND C.FACTORY_ID     = A.FACTORY_ID
																	AND C.LINE_ID        = A.LINE_ID
																	AND C.OPERATION_ID   = A.OPERATION_ID
																	AND C.ELECTRODE_TYPE = A.ELECTRODE_TYPE
																 ) ) -- 2022-07-19 scm_equipment_m 정보를 필수에서 Option으로 변경.라인의 ERP Work Center ID 사용하도록 수정
												  END AS LINE_ID            -- modify by kimcd 2016-12-02
										   --,SUBSTRING(A.WORK_CENTER_ID, 1, 5) AS LINE_ID
										   ,A.EQUIPMENT_ID
										   ,A.[OPERATION_ID]
										   ,A.[BOM_VERSION_ID]
										   --,A.[WORK_CENTER_ID]       blocked by kimcd 2016-12-02
										   ,A.[ITEM_ID]
										   ,A.[DEMAND_ID]
										   ,A.[WORK_ORDER_ID]
										   ,A.[WORK_ORDER_SPL_ID]
										   /*  -- 2017.04.24 order_type 값 search 조건을 MES 전송과 동일 로직으로 변경 함.
										   ,ISNULL((SELECT TOP 1 PRODUCTION_TYPE AS ORDER_TYPE
											 FROM [DBO].[FP_WEEKLY_DEMAND_PRODUCT_H]
											WHERE SCP_TARGET_ID = A.DEMAND_ID
										   ), 'MASS') AS ORDER_TYPE
										   */
										   ,A.PRODUCTION_TYPE  AS ORDER_TYPE
										   ,CASE WHEN A.PLAN_DATE > GETDATE() AND A.PLAN_IN_QTY = 0 THEN
													CONCAT(CONVERT(NVARCHAR(8),DATEADD(DAY, -1, GETDATE()), 112), '000000')
												 ELSE
													REPLACE(REPLACE(REPLACE(CONVERT(NVARCHAR(19),A.[PLAN_DATE],120),'-',''),':',''),' ','')
												  END AS PLAN_DATE														--2017-09-28  PIYONG  변경
											,CASE WHEN A.PLAN_DATE > GETDATE() AND A.PLAN_IN_QTY = 0 THEN
													CONCAT(CONVERT(NVARCHAR(8),DATEADD(DAY, -1, GETDATE()), 112), '060000')
												  ELSE
													REPLACE(REPLACE(REPLACE(CONVERT(NVARCHAR(19),A.[START_TIME],120),'-',''),':',''),' ','')
												  END AS START_TIME														--2017-09-28  PIYONG  변경
											,CASE WHEN A.PLAN_DATE > GETDATE() AND A.PLAN_IN_QTY  = 0 THEN
													CONCAT(CONVERT(NVARCHAR(8),DATEADD(DAY, -1, GETDATE()), 112), '061000')
												  ELSE
													REPLACE(REPLACE(REPLACE(CONVERT(NVARCHAR(19),A.[END_TIME],120),'-',''),':',''),' ','')
												  END AS END_TIME														--2017-09-28  PIYONG  변경
										   --,A.[PLAN_IN_QTY]
										   --,A.[PLAN_QTY]
										   /*
											,A.PLAN_IN_QTY + (SELECT ISNULL(SUM(MPP.ACTUAL_QTY), 0) FROM [dbo].[FP_MES_PRODUCTION_PLAN_M] MPP WITH(NOLOCK)
															  WHERE MPP.WORK_ORDER_ID     = A.WORK_ORDER_ID
															  AND   MPP.ITEM_ID           = A.ITEM_ID) AS PLAN_IN_QTY
											,A.PLAN_QTY + (SELECT ISNULL(SUM(MPP.ACTUAL_QTY),0) FROM [dbo].[FP_MES_PRODUCTION_PLAN_M] MPP WITH(NOLOCK)
														   WHERE  MPP.WORK_ORDER_ID     = A.WORK_ORDER_ID
														   AND    MPP.ITEM_ID           = A.ITEM_ID) AS PLAN_QTY  -- kimcd change base table
											kimcd 2017-06-03 block */
											-- kimcd add start 2017-06-03
											,A.PLAN_IN_QTY AS PLAN_IN_QTY
											,A.PLAN_QTY AS PLAN_QTY
											-- kimcd add end 2017-06-03
										    ,CASE WHEN A.FIX_TYPE = 'F' THEN 'Y'
												  WHEN A.FIX_TYPE = 'N' THEN 'Y'
												  WHEN A.FIX_TYPE = 'P' THEN '-'
												  ELSE A.FIX_TYPE
												  END AS FIX_TYPE
										    ,A.[LANE_QTY]
										    ,A.[BATCH_ORDER_ID]
										   -- SLIT_PLANT_ID 를 구하는 로직 변경 req by kcd 170412                                                                                                       
										    ,CASE WHEN A.[OPERATION_ID] = 'E2000' THEN 
													ISNULL( (
															  SELECT TOP 1 Z.PLANT_ID
																FROM [DBO].[FP_PRODUCTION_PLAN_EQUIPMENT_R] Z
															   WHERE Z.OPERATION_ID = 'E4000'
																 AND Z.COMPANY_ID   = A.COMPANY_ID
																 AND Z.DIVISION_ID  = A.DIVISION_ID
																 AND Z.SITE_ID      = A.SITE_ID
																 AND Z.ITEM_ID      = A.ITEM_ID 
															   ORDER BY Z.INSERT_TIME DESC 
															),(
															   SELECT TOP 1 ILA.PLANT_ID
																 FROM [DBO].[SCM_ITEM_LINE_ASSIGN_M] ILA WITH(NOLOCK)
															   WHERE ILA.OPERATION_ID = 'E4000'
																 AND ILA.COMPANY_ID   = A.COMPANY_ID
																 AND ILA.DIVISION_ID  = A.DIVISION_ID
																 AND ILA.SITE_ID      = A.SITE_ID
																 AND ILA.ITEM_ID      = A.ITEM_ID 
																 AND ILA.ACTIVE_FLAG = 'Y'
																 AND ILA.PRIORITY != 9											--2017-10-19 PIYONG ADD
																 AND ILA.MONTH >= CONVERT(NVARCHAR(6), GETDATE(),112)		    --2017-10-19 PIYONG ADD
															   ORDER BY CASE WHEN EQP.PLANT_ID = ILA.PLANT_ID THEN 1 ELSE 2 END --2017-10-19 PIYONG ADD
																	 ,ILA.INSERT_TIME DESC
															) )
												 ELSE NULL END  SLIT_PLANT_ID
										   ,ISNULL(A.MARKET,'D')  MARKET            -- 170208 ADD
										   -- FP-058 kimcd 추가 시작. 2017-05-24
										   ,CASE WHEN EQPC.SEGMENT1 IS NOT NULL AND IMC.SEGMENT1 IS NOT NULL THEN
													 'B'
												 END AS TOP_BACK_IND -- 단면 설비에 양면 제품이 계획된 경우 TOP BACK 구분
										   ,CASE WHEN EQPC.SEGMENT1 IS NOT NULL AND IMC.SEGMENT1 IS NOT NULL THEN
													CASE WHEN A.WORK_ORDER_ID LIKE 'W%' OR A.WORK_ORDER_ID LIKE 'M%' THEN
															SUBSTRING(A.WORK_ORDER_ID,1,5) + CONVERT(NVARCHAR(2), CONVERT(NUMERIC,SUBSTRING(A.WORK_ORDER_ID,6,2)) + 50) + SUBSTRING(A.WORK_ORDER_ID,8,10)
														 WHEN SUBSTRING(A.WORK_ORDER_ID,9,1) = '0' THEN
															CASE WHEN SUBSTRING(A.WORK_ORDER_ID,6,1) = 'X' THEN
																SUBSTRING(A.WORK_ORDER_ID,1,5) + 'Y' + SUBSTRING(A.WORK_ORDER_ID,7,10)
															ELSE
																SUBSTRING(A.WORK_ORDER_ID,1,4) + CONVERT(NVARCHAR(2), CONVERT(NUMERIC,SUBSTRING(A.WORK_ORDER_ID,5,2)) + 50) + SUBSTRING(A.WORK_ORDER_ID,7,10)
															END
														 ELSE
															CASE WHEN SUBSTRING(A.WORK_ORDER_ID,7,1) = 'X' THEN
																SUBSTRING(A.WORK_ORDER_ID,1,6) + 'Y' + SUBSTRING(A.WORK_ORDER_ID,8,10)
															ELSE
																SUBSTRING(A.WORK_ORDER_ID,1,5) + CONVERT(NVARCHAR(2), CONVERT(NUMERIC,SUBSTRING(A.WORK_ORDER_ID,6,2)) + 50) + SUBSTRING(A.WORK_ORDER_ID,8,10)
															END
														 END				-- 2018-03-06 kimcd work order id 채번 rule 변경에 따른 TOP, Back 로직 WO 로직 수정
												 END AS LINK_WO				-- 연계된 WO명 - TOP은 Back WO, Back은 TOP WO
										   ,A.PLAN_QTY		AS FP_PLAN_QTY  -- FP Plan 수량 아웃 수량 기준으로 변경 PLAN_IN_QTY -> PLAN_QTY
										   -- FP-058 kimcd 추가 끝. 2017-05-24
										   ,A.START_TIME	AS FP_START_TIME
										   ,A.END_TIME		AS FP_END_TIME
										   ,A.WORK_REQUEST_MODEL_ID AS ZMODEL
										   ,A.VERSION AS VERSION
										   ,A.PROD_SEQ AS SERIAL
									  FROM [DBO].[FP_PRODUCTION_PLAN_EQUIPMENT_R] A WITH(NOLOCK)
									  LEFT OUTER JOIN [DBO].[SCM_SYS_LOOKUP_VALUE]  B WITH(NOLOCK)
												   ON B.LOOKUP_TYPE_CODE = 'BOM_ADD_FOR_RES_SHARE'
												  AND B.SEGMENT1         = A.PLANT_ID
												  AND B.ACTIVE_FLAG      = 'Y'
								   -- FP-058 kimcd 추가 시작. 2017-05-24 
									  LEFT OUTER JOIN [DBO].[SCM_EQUIPMENT_M]  EQP WITH(NOLOCK)
												   ON EQP.EQUIPMENT_ID = A.EQUIPMENT_ID
												  AND EQP.OPERATION_ID = A.OPERATION_ID
												  AND EQP.FACTORY_ID   = A.FACTORY_ID
												  AND EQP.EQUIPMENT_TYPE = 'M'
												  AND EQP.ACTIVE_FLAG    = 'Y'
									  LEFT OUTER JOIN [DBO].[SCM_SYS_LOOKUP_VALUE]  EQPC WITH(NOLOCK)
												   ON EQPC.LOOKUP_TYPE_CODE = 'FP_COATER_TOP_COPY_OP'
												  AND EQPC.SEGMENT1         = EQP.OPERATION_ID
												  AND EQPC.SEGMENT2         = EQP.COATER_EQPT_TYPE_CODE
												  AND EQPC.ACTIVE_FLAG      = 'Y'
									 LEFT OUTER JOIN [DBO].[SCM_ITEM_M]  IM WITH(NOLOCK)
												  ON IM.DIVISION_ID  = A.DIVISION_ID
												 AND IM.SITE_ID      = A.SITE_ID
												 AND IM.ITEM_ID      = A.ITEM_ID
										         AND IM.COMPANY_ID   = A.COMPANY_ID  -- 2019-06-07 kimcd error fix.
									 LEFT OUTER JOIN [DBO].[SCM_SYS_LOOKUP_VALUE]  IMC WITH(NOLOCK)
												  ON IMC.LOOKUP_TYPE_CODE = 'FP_COATER_TOP_COPY_ITEM_CLASS'
												 AND IMC.SEGMENT1         = IM.ITEM_CLASS
												 AND IMC.ACTIVE_FLAG      = 'Y'
								   -- FP-058 kimcd 추가 끝. 2017-05-24 
									 WHERE A.ORDER_TYPE IN ('W')
									 --AND A.FP_PLAN_ID LIKE '%99'
									   AND A.FP_PLAN_ID = ISNULL( @P_FP_PLAN_ID,'0')
									   AND A.PLAN_DATE >= DATEADD(DAY, -3, GETDATE())	-- [E20251023-001125]  한달 전 수율 적용이 안되어 전송 구간 조정, rolling, reschedule 과 기준 맞춤
								   ) A
							 GROUP BY A.[FP_PLAN_ID]
								   ,A.[COMPANY_ID]
								   ,A.[DIVISION_ID]
								   ,A.[SITE_ID]	
								   ,A.[PLANT_ID]
								   ,A.[FACTORY_ID]
								-- ,A.[LINE_ID]          blocked by kimcd 2016-12-02
								   ,A.[OPERATION_ID]
								   ,A.[BOM_VERSION_ID]	
								-- ,A.[WORK_CENTER_ID]	 blocked by kimcd 2016-12-02
								   ,A.[ITEM_ID]
								-- ,A.[DEMAND_ID]        blocked by kimcd 2016-12-02
								   ,A.[WORK_ORDER_ID]
								   ,A.[WORK_ORDER_SPL_ID]
								   ,A.market -- 170208 Add   
						  ) A
					 LEFT OUTER JOIN FP_MES_PRODUCTION_PLAN_M M WITH(NOLOCK)
								  ON M.WORK_ORDER_ID = A.[WORK_ORDER_ID]
								  AND M.WORK_ORDER_SPL_ID = A.WORK_ORDER_SPL_ID
				   ) B
			-- 2018-04-18 PIYONG ADD
			-- 2026-08-04 kimcd [PJ2026-50201] FP 라인별 환산자 산출 및 생산계획 반영 [FP_MES_FACTORY_M_V],[FP_PDS_VERSION_M] outer join 추가
		    INNER JOIN FP_MES_FACTORY_M_V AS F
				ON F.ORG_FACTORY_ID = B.FACTORY_ID
            LEFT OUTER JOIN [dbo].[FP_PDS_VERSION_M]  PVM WITH(NOLOCK)
				ON 	PVM.[FACTORY_ID] = B.[FACTORY_ID]
				AND PVM.[MODEL_ID]   = B.[ZMODEL]
				AND PVM.[VERSION]    = B.[VERSION]
	         WHERE NOT EXISTS (
							   SELECT 1
							     FROM DBO.FP_ERP_PRODUCTION_PLAN_M MWS WITH(NOLOCK)
							    WHERE MWS.[WORK_ORDER_ID]     = B.WORK_ORDER_ID
							      AND ISNULL(MWS.BATCH_ORDER_ID,'-') = ISNULL(B.BATCH_ORDER_ID,'-') 
							      AND ISNULL(MWS.LANE_QTY, 0)   = ISNULL(B.LANE_QTY,0) 
							      AND MWS.LINE_ID = B.FP_LINE_ID  -- 2018-05-26 kimcd 계획 라인 비교 기준 수정 - FP 계획 라인 기준으로 함
								  AND ISNULL(MWS.ATTRIBUTE1,'-') = ISNULL(B.LINE_ID,'-') -- 2018-05-26 kimcd MES 라인 기준 비교
							      AND MWS.OPERATION_ID = B.OPERATION_ID
							      AND MWS.WORK_CENTER_ID = B.WORK_CENTER_ID
							      AND MWS.START_TIME     = B.FP_START_TIME
							      AND MWS.END_TIME     = B.FP_END_TIME
							      AND MWS.PLAN_QTY     = B.PLAN_QTY
							      AND MWS.PLAN_IN_QTY     = B.PLAN_IN_QTY
							      AND MWS.PRODUCTION_TYPE = B.ORDER_TYPE
							      AND MWS.MARKET         = B.MARKET
							      AND ISNULL(MWS.SLIT_PLANT_ID,'-') = ISNULL(B.SLIT_PLANT_ID,'-')
							 )
			;

		SET @ROWCOUNT = @@ROWCOUNT

		--  FP-058 kimcd 추가 시작. 2017-05-24 
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
				   ,[MARKET] -- 170208 Add
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
                   ,[FP_SNAP_QTY] -- FP 실적 수량

				   
				-- TECO_IND -- 누락
				,[TECO_IND]
				-- NERP 신규컬럼 (2024-07-10)
				,[EQUIPMENT_ID] -- 전극 EQUIPMENT 정보
				,[ZMODEL]       -- 모델
				,[VERSION]      -- 문서 버전
				,[SERIAL]       -- 문서 시리얼
				
				,[PLAN_GRP]     -- SCP PLAN GROUP
				,[PLAN_WEEK]    -- SCP PLAN WEEK
				,[SCP_PLAN_ID]  -- SCP PLAN ID

				,[CUDTY]
				--- NERP 신규컬럼 (2024-07-10 끝)
				)
			SELECT  @IFSEQNO
				   ,@ROWCOUNT + ROW_NUMBER() OVER( ORDER BY A.[FP_PLAN_ID], A.[PLANT_ID], A.[FACTORY_ID], A.[LINE_ID], A.[OPERATION_ID], A.[ITEM_ID], A.[WORK_ORDER_ID] ) AS SEQ
				   ,A.[FP_PLAN_ID]
				   ,A.[PLANT_ID]
				   ,A.[FACTORY_ID]
				   ,A.[LINE_ID]
				   ,A.[OPERATION_ID]
				   ,A.[BOM_VERSION_ID]
				   ,A.[WORK_CENTER_ID]
				   ,A.[ITEM_ID]
				   ,A.[DEMAND_ID]
				   ,A.[LINK_WO]    -- [WORK_ORDER_ID]
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
				   
				-- TECO_IND -- 누락
				,[TECO_IND]
				-- NERP 신규컬럼 (2024-07-10)
				,[EQUIPMENT_ID] -- 전극 EQUIPMENT 정보
				,[ZMODEL]       -- 모델
				,[VERSION]      -- 문서 버전
				,[SERIAL]       -- 문서 시리얼
				
				,[PLAN_GRP]     -- SCP PLAN GROUP
				,[PLAN_WEEK]    -- SCP PLAN WEEK
				,[SCP_PLAN_ID]  -- SCP PLAN ID

				,[CUDTY]
				--- NERP 신규컬럼 (2024-07-10 끝)
				
			FROM    [dbo].[SY_XIF_ERP_PRODUCTION_PLAN_S] A WITH(NOLOCK)
			WHERE   A.[FP_PLAN_ID] = ISNULL(@P_FP_PLAN_ID,'0')
			AND     A.[TOP_BACK_IND] = 'B';

		SET @ROWCOUNT = @ROWCOUNT + @@ROWCOUNT
		--  FP-058 kimcd 추가 끝. 2017-05-24 


		---------------------------------------------------------------------------------------------------------------
		-- 2019-03-07 PIYONG 중복 전송 제외 로직 추가
		UPDATE S
		   SET TRANSFER_FLAG = 'Y'
			   ,TRANSFER_DATE =  GETDATE()
			   ,MODIFY_USER_ID = 'Changed to duplicate'
		  FROM [dbo].[SY_XIF_ERP_PRODUCTION_PLAN_S] S
			   ,(
					SELECT IFSEQNO
						   , FP_PLAN_ID
						   , WORK_ORDER_ID
					  FROM (
							SELECT IFSEQNO
								   , FP_PLAN_ID
								   , WORK_ORDER_ID
								   ,ROW_NUMBER() OVER( PARTITION BY  WORK_ORDER_ID ORDER BY CREATE_DATE DESC) AS NUM
							  FROM [dbo].[SY_XIF_ERP_PRODUCTION_PLAN_S]
							 WHERE TRANSFER_FLAG IN ( 'X', 'N')
						  ) A
					WHERE NUM > 1
			   ) B
		 WHERE S.IFSEQNO = B.IFSEQNO
		   AND S.FP_PLAN_ID = B.FP_PLAN_ID
		   AND S.WORK_ORDER_ID = B.WORK_ORDER_ID
		-- 2019-03-07 PIYONG 중복 전송 제외 로직 추가
		---------------------------------------------------------------------------------------------------------------


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

