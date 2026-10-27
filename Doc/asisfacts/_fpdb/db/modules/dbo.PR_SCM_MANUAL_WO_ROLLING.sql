
--CREATE PROCEDURE [dbo].[PR_SCM_MANUAL_WO_ROLLING]
CREATE PROCEDURE [dbo].[PR_SCM_MANUAL_WO_ROLLING]
-- ================================================================================================
-- Program ID          : FP00XXX
-- Program Name        : PR_SCM_MANUAL_WO_ROLLING
-- Param               :
-- Batch Period        : 1DAY
-- Description         :
--
-- Source System       : FP SDB
-- Destination System  : MES, ERP
-- Source Table        : FP_MES_WORK_ORDER_STATUS_H, FP_MPP_WPP_BASE_PLAN_M 
-- Destination Table   : FP_MANUAL_WORK_ORDER_H
--
-- Create Date		   : 2017.07.15
-- Update Date		   : 2018.12.18
--
-- Author              : KIMCD
-- Version             : 1.0
--                       1.1 kimcd 2017-08-08 남경 작업 허용
--                       1.2 kimcd 2017-08-19 소형 전극 Pilot, F6200 공정 추가
--                       1.3 kimcd 2017-08-29 오창 소형 조립 Pilot Instacne 구분
--                       1.4 kimcd 2017-11-04 남경 조립 허용. market 구분 추가. Plan Release Group 배포 로직 추가
--                       1.5 kimcd 2018-01-06 CNJ 허용에서 활성화 후 공정만 허용하는 것으로 변경.
--                                            작업 오류 방지를 위해 설비, Demand ID 없는 정보 제외.
--                       1.6 kimcd 2018-01-30 오창 자동차 확산
--                       1.7 kimcd 2018-02-14 남경 활성화 후 공정 Instance 누락 오류 보완
--                       1.8 kimcd 2018-04-26 남경 EGL 라인 추가
--                       1.9 kimcd 2018-12-18 OUT 수량 기준 계획 배포에 따른 수율 감안 로직 수정
-- ================================================================================================


AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_SCM_MANUAL_WO_ROLLING'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	   = 0
	DECLARE @sysdate     DATETIME2     = GETDATE()
	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)

	DECLARE @SITE_ID     NVARCHAR(30)
	DECLARE @FACTORY_ID  NVARCHAR(30)

	DECLARE @BASE_DATE   DATE
	DECLARE @SEQ		 INTEGER

	-- 2017-11-04 CURSOR 사용하여 정보 입력하는 방식으로 전환 변수 추가 시작
	DECLARE @I_COMPANY_ID            NVARCHAR(30)
	DECLARE @I_DIVISION_ID           NVARCHAR(30)
	DECLARE @I_SITE_ID               NVARCHAR(30)
	DECLARE @I_PLANT_ID              NVARCHAR(30)
	DECLARE @I_FACTORY_ID            NVARCHAR(30)
	DECLARE @I_PLAN_WEEK             NVARCHAR(10)
	DECLARE @I_PLAN_REVISION         NVARCHAR(100)
	DECLARE @I_INSTANCE_ID           NVARCHAR(30)
	DECLARE @I_PLAN_ID               NVARCHAR(30)
	DECLARE @I_CUTOFF_DATE           DATETIME
	DECLARE @I_WORK_ORDER_SPL_ID     NVARCHAR(150)
	DECLARE @I_WORK_ORDER_ID         NVARCHAR(150)
	DECLARE @I_DEMAND_ID             NVARCHAR(150)
	DECLARE @I_PRODUCTION_TYPE       NVARCHAR(30)
	DECLARE @I_ORDER_TYPE            NVARCHAR(50)
	DECLARE @I_ITEM_ID               NVARCHAR(150)
	DECLARE @I_TOP_ITEM_ID           NVARCHAR(150)
	DECLARE @I_OPERATION_ID          NVARCHAR(30)
	DECLARE @I_LINE_ID               NVARCHAR(30)
	DECLARE @I_ELECTRODE_TYPE        NVARCHAR(30)
	DECLARE @I_EQUIPMENT_ID          NVARCHAR(50)
	DECLARE @I_PLAN_DATE             DATETIME
	DECLARE @I_PLAN_START_TIME       DATETIME
	DECLARE @I_PLAN_END_TIME         DATETIME
	DECLARE @I_REMAIN_QTY            NUMERIC(14, 4)
	DECLARE @I_REMAIN_IN_QTY         NUMERIC(14, 4)
	DECLARE @I_BASE_PLAN_START_TIME  DATETIME
	DECLARE @I_ACTUAL_QTY            NUMERIC(14, 4)
	DECLARE @I_RUNNING_FLAG          NVARCHAR(1)
	DECLARE @I_WO_STATUS             NVARCHAR(30)
	DECLARE @I_MARKET                NVARCHAR(10)
	DECLARE @I_LANE_QTY              NUMERIC(14, 4)
	DECLARE @I_BATCH_ORDER_ID        NVARCHAR(150)
	DECLARE @I_INSERT_ID             NVARCHAR(150)
	DECLARE @I_INSERT_TIME           DATETIME
	DECLARE @I_UPDATE_ID             NVARCHAR(150)
	DECLARE @I_UPDATE_TIME           DATETIME
	DECLARE @I_PLAN_TYPE             NVARCHAR(10)
	DECLARE @I_FIXED_YN              NVARCHAR(10)
	-- 2017-11-04 CURSOR 사용하여 정보 입력하는 방식으로 전환 변수 추가 끝

	DECLARE @TEMP_TABLE TABLE (
					[CUTOFF_DATE]       [DATETIME],
					[COMPANY_ID]        [NVARCHAR](30),
					[DIVISION_ID]       [NVARCHAR](30),
					[SITE_ID]           [NVARCHAR](30),
					[PLANT_ID]          [NVARCHAR](30),
					[FACTORY_ID]        [NVARCHAR](30),
					[PLAN_WEEK]         [NVARCHAR](10),
					[PLAN_REVISION]     [NVARCHAR](100),
					[INSTANCE_ID]       [NVARCHAR](30),
					[PLAN_ID]           [NVARCHAR](30),
					[PRODUCTION_TYPE]   [NVARCHAR](30),
					[ORDER_TYPE]        [NVARCHAR](50),
					[WORK_ORDER_SPL_ID] [NVARCHAR](150),
					[WORK_ORDER_ID]     [NVARCHAR](150),
					[ITEM_ID]           [NVARCHAR](150),
					[OPERATION_ID]      [NVARCHAR](30),
					[LINE_ID]           [NVARCHAR](30),
					[ELECTRODE_TYPE]    [NVARCHAR](30),
					[EQUIPMENT_ID]      [NVARCHAR](50),
					[MARKET]            [NVARCHAR](10),
					[LANE_QTY]          [NUMERIC](14, 4),
					[PLAN_DATE]         [DATETIME],
					[ACCUM_PLAN_QTY]    [NUMERIC](20,4),
					[ROW_SEQ]           [NUMERIC](5))

	DECLARE	@TT_COMPANY_ID      [NVARCHAR](30)
	DECLARE	@TT_DIVISION_ID     [NVARCHAR](30)
	DECLARE	@TT_SITE_ID         [NVARCHAR](30)
	DECLARE	@TT_PLANT_ID        [NVARCHAR](30)
	DECLARE @TT_FACTORY_ID      [NVARCHAR](30)
	DECLARE	@TT_PLAN_WEEK       [NVARCHAR](10)
	DECLARE	@TT_PLAN_REVISION   [NVARCHAR](100)
	DECLARE	@TT_INSTANCE_ID     [NVARCHAR](30)
	DECLARE	@TT_PLAN_ID         [NVARCHAR](30)
	DECLARE @TT_PRODUCTION_TYPE [NVARCHAR](30)
	DECLARE	@TT_ORDER_TYPE      [NVARCHAR](50)
	DECLARE @TT_ITEM_ID         [NVARCHAR](150)
	DECLARE @TT_OPERATION_ID    [NVARCHAR](30)
	DECLARE @TT_LINE_ID         [NVARCHAR](30)
	DECLARE	@TT_ELECTRODE_TYPE  [NVARCHAR](30)
	DECLARE @TT_EQUIPMENT_ID    [NVARCHAR](50)
	DECLARE	@TT_MARKET          [NVARCHAR](10)
	DECLARE	@TT_LANE_QTY        [NUMERIC](14, 4)
	DECLARE @TT_PLAN_DATE       [DATETIME]
	DECLARE @TT_ROW_SEQ         [NUMERIC](5)
	DECLARE @TT_ACCUM_PLAN_QTY  [NUMERIC](14, 4)
	DECLARE @NEW_ORDER_SEQ      [NUMERIC](5)
	DECLARE @MIN_OTHER_PLAN_DATE   [DATETIME]
	DECLARE @MAX_ITEM_PLAN_DATE    [DATETIME]
	DECLARE @NEW_ITEM_PLAN_DATE    [DATETIME]
	DECLARE @NEW_WORK_ORDER_SPL_ID [NVARCHAR](150)
	DECLARE @NEW_WORK_ORDER_ID     [NVARCHAR](150)


	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @BASE_DATE = CAST(GETDATE() AS DATE)
	SET @NEW_ORDER_SEQ = 0

	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

	BEGIN TRY				

		BEGIN TRAN
		-- ================================================
		-- 로직 추가
		-- ================================================
			DECLARE CUR_SITE CURSOR FOR
				SELECT DISTINCT Z.SITE_ID, Z.FACTORY_ID
				FROM   SCM_FACTORY_M Z WITH(NOLOCK)
				WHERE Z.FACTORY_ID IN ( SELECT DISTINCT FACTORY_ID
				                             FROM [FP_MES_WORK_ORDER_STATUS_H]  A -- NOLOCK 걸지 않음
						 					WHERE 1=1
											  AND CUTOFF_DATE = CAST(GETDATE() AS DATE)
											  AND ( ( A.FACTORY_ID IN ('E1'/*,'E2','E3','E4','E5','E6','E7','E8','EA' 2018-04-26 kimcd 대상 제외 */) /*2017-08-08 KIMCD ADD 남경 공장 */	 AND A.OPERATION_ID IN ('E1000','E2000','E2500') )
											          /*2018-01-30 kimcd 오창 자동차 추가*/
											      OR  ( A.FACTORY_ID IN ('M1','M2') AND A.WO_STATUS = 'PILOT' AND A.OPERATION_ID IN ('A2000','A3000') ) -- kimcd 소형 Pilot WO 추가 2017-08-19 -- kimcd 2017-11-04 동 조건 추가
												  -- 2018-01-06 kimcd 조건 막음. OR  ( A.PLANT_ID = 'G182' ) -- kimcd 2017-11-04 남경 소형 조립은 모두 수용.
												  OR  ( A.FACTORY_ID = 'M7' )  -- 2018-04-26 kimcd 대상 추가 - EGL용
												  OR  ( A.OPERATION_ID IN ('F6200','F7000','F7100','F7200','F7300') ) ) -- 2018-01-06 kimcd 남경 활성화 후 공정 추가. kimcd 활성화 용접 tab 추가 2017-08-19
										) 
				AND   NOT EXISTS ( SELECT 1
				                   FROM   [DBO].[SCM_SYS_LOOKUP_VALUE]  SV WITH(NOLOCK)
						           WHERE  SV.LOOKUP_TYPE_CODE = 'WO_MANUAL_ROLLING_FLAG'
							       AND    SV.SEGMENT1 = Z.SITE_ID
								   AND    SV.SEGMENT2 = Z.FACTORY_ID
								   AND    SV.ATTRIBUTE1 = CONVERT( NVARCHAR(8), GETDATE(), 112) );

			OPEN CUR_SITE;
			FETCH NEXT FROM CUR_SITE INTO  @SITE_ID
			                              ,@FACTORY_ID;

			WHILE (@@FETCH_STATUS = 0)
				BEGIN
					SET @v_temp1 = 'INSERT @FP_MANUAL_WORK_ORDER_H'
					-- 2017-11-04 kimcd 정보 입력 과정을 loop로 변경 시작
					DECLARE CUR_WO CURSOR FOR
						WITH PLAN_ID AS (SELECT  ZZ.SITE_ID
												,ZZ.INSTANCE_ID
												,ZZ.INSTANCE_DATE
												,ZZ.RELEASE_PLAN_ID    AS PLAN_ID
												,ZZ.DIVISION_ID
												,ZZ.FACTORY_ID
												,ZZ.LINK_FACTORY_ID    -- 2017-11-04 kimcd link factory id 추가
												,ZZ.PLAN_GROUP_ID      -- 2017-11-04 kimcd Plan Group Id 추가
												,ZZ.AMEND_PLAN_ID
												,ZZ.OPERATION_ID
												,ZZ.INSTANCE_TYPE
										FROM ( SELECT  B.SITE_ID
													,A.INSTANCE_ID
													,A.INSTANCE_DATE
													,A.DIVISION_ID
													,B.FACTORY_ID       -- 2017-11-04 kimcd FACTOR 추출 기준을 FP_RELEASE_PLAN_INFO_H에서 [FP_INSTANCE_FACTORY_M]으로 변경
													,B.LINK_FACTORY_ID  -- 2017-11-04 kimcd link factory Id 추가
													,A.PLAN_GROUP_ID    -- 2017-11-04 kimcd Plan Group Id 추가
													,A.RELEASE_PLAN_ID
													,A.AMEND_PLAN_ID
													,B.OPERATION_ID
													,B.INSTANCE_TYPE
													,ROW_NUMBER() OVER ( PARTITION BY  DIVISION_ID, INSTANCE_TYPE, A.FACTORY_ID, A.PLAN_GROUP_ID, B.OPERATION_ID ORDER BY INSERT_TIME DESC ) NUMS -- 마지막 RELEASE VERSION         
													-- 2017-11-04 kimcd Plan Release Group 배포 로직 추가
												FROM    DBO.FP_RELEASE_PLAN_INFO_H  A WITH(NOLOCK)
													,  (SELECT   FIF.INSTANCE_ID  -- kimcd 2017-08-29 소형 조립 Pilot 
																,FIF.INSTANCE_TYPE
																,F.SITE_ID
																,F.FACTORY_ID
																,O.OPERATION_ID
																,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE F.FACTORY_ID END  AS LINK_FACTORY_ID 
																,ISNULL(MP.SEGMENT2,'-')  AS PLAN_GROUP_ID
														FROM     DBO.[FP_INSTANCE_FACTORY_M] FIF WITH(NOLOCK)     
																,DBO.SCM_FACTORY_M           F   WITH(NOLOCK)   
																,SCM_OPERATION_M             O   WITH(NOLOCK)
																,SCM_SYS_LOOKUP_VALUE        SLV WITH(NOLOCK)  -- 2017-11-04 kimcd instance 유형에 따라 배포 구룹 구분 추가
																	LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE MP WITH(NOLOCK) -- 2017-11-04 kimcd instance별 배포 유형
																	ON   MP.LOOKUP_TYPE_CODE  = 'INSTANCE_PLANNING_GROUP'
																	AND  MP.SEGMENT1          = SLV.SEGMENT1
																	AND  SLV.ATTRIBUTE1       = 'PLAN GROUP'
														WHERE FIF.FACTORY_ID    = F.FACTORY_ID
														AND   FIF.ACTIVE_FLAG   = 'Y'
														AND   FIF.ACTIVE_FLAG   = F.ACTIVE_FLAG     
														AND   F.FACTORY_ID      = @FACTORY_ID
														AND   F.SITE_ID         = @SITE_ID
														AND   FIF.INSTANCE_TYPE = O.INSTANCE_TYPE
														AND   F.COMPANY_ID      = O.COMPANY_ID
														AND   F.DIVISION_ID     = O.DIVISION_ID
														AND   F.SITE_ID         = O.SITE_ID
														AND   FIF.INSTANCE_ID  != 'KR_CELL_M' -- kimcd 2017-08-29 소형 조립 Pilot
														AND   SLV.LOOKUP_TYPE_CODE = 'INSTANCE_ID' -- 2017-11-04 kimcd instance별 배포 단위 조회
														AND   SLV.SEGMENT1      = FIF.INSTANCE_ID  -- 2017-11-04 kimcd instance별 배포 단위 조회
														) B      
												WHERE A.INSTANCE_ID = B.INSTANCE_ID
												AND   A.FACTORY_ID  = B.LINK_FACTORY_ID -- 2017-11-04 kimcd B.FACTORY_ID에서 배포 단위 기준으로 다른 값이 join되도록 함
												AND   A.PLAN_GROUP_ID = B.PLAN_GROUP_ID -- 2017-11-04 kimcd 한 공장에서 배포 단위 기준으로 여러 PLAN ID가 join되도록 함
												AND   A.INSERT_TIME < @BASE_DATE
											) ZZ       
										WHERE ZZ.NUMS = 1)
						SELECT OW.[COMPANY_ID]
							  ,OW.[DIVISION_ID]
							  ,OW.[SITE_ID]
							  ,OW.[PLANT_ID]
							  ,OW.[FACTORY_ID]
							  ,ISNULL(WU.[PLAN_WEEK], '-')       AS PLAN_WEEK
							  ,ISNULL(WU.[PLAN_REVISION], '-')   AS PLAN_REVISION
							  ,OW.[INSTANCE_ID]
							  ,ISNULL(OW.[PLAN_ID],'-')          AS PLAN_ID
							  ,OW.[CUTOFF_DATE]
							  ,OW.[WORK_ORDER_SPL_ID]
							  ,OW.[WORK_ORDER_ID]
							  ,OW.[DEMAND_ID]
							  ,OW.[PRODUCTION_TYPE]
							  ,OW.[ORDER_TYPE]
							  ,OW.[ITEM_ID]
							  ,OW.[TOP_ITEM_ID]
							  ,OW.[OPERATION_ID]
							  ,OW.[LINE_ID]
							  ,OW.[ELECTRODE_TYPE]
							  ,OW.[EQUIPMENT_ID]
							  ,CASE WHEN OW.[PLAN_DATE] < @BASE_DATE THEN
									CAST(GETDATE() AS DATE)
							   ELSE
									OW.[PLAN_DATE]
							   END								  AS PLAN_DATE
							  ,CASE WHEN OW.[PLAN_START_TIME] < CONVERT ( DATETIME, CONVERT( NVARCHAR(10), @BASE_DATE,  120) + ' ' + SUBSTRING(STL.SEGMENT2, 1,2) + ':' + SUBSTRING(STL.SEGMENT2, 3,2) + ':' + SUBSTRING(STL.SEGMENT2, 5,2), 120) THEN
									CONVERT ( DATETIME, CONVERT( NVARCHAR(10), @BASE_DATE,  120) + ' ' + SUBSTRING(STL.SEGMENT2, 1,2) + ':' + SUBSTRING(STL.SEGMENT2, 3,2) + ':' + SUBSTRING(STL.SEGMENT2, 5,2), 120)
							   ELSE
									OW.[PLAN_START_TIME]
							   END                                AS PLAN_START_TIME
							  ,CASE WHEN OW.[PLAN_END_TIME]  <  CONVERT ( DATETIME, CONVERT( NVARCHAR(10), @BASE_DATE,  120) + ' ' + SUBSTRING(STL.SEGMENT2, 1,2) + ':' + CONVERT(NVARCHAR(2), CONVERT(NUMERIC, SUBSTRING(STL.SEGMENT2, 3,2)) + 10) + ':' + SUBSTRING(STL.SEGMENT2, 5,2), 120) THEN
									CONVERT ( DATETIME, CONVERT( NVARCHAR(10), @BASE_DATE,  120) + ' ' + SUBSTRING(STL.SEGMENT2, 1,2) + ':' + CONVERT(NVARCHAR(2), CONVERT(NUMERIC, SUBSTRING(STL.SEGMENT2, 3,2)) + 10) + ':' + SUBSTRING(STL.SEGMENT2, 5,2), 120)
							   ELSE
									OW.[PLAN_END_TIME]
							   END                                AS PLAN_END_TIME
							  ,CASE WHEN OW.REMAIN_QTY < 0 THEN
									0
								ELSE 
									OW.REMAIN_QTY
								END								AS REMAIN_QTY
							  ,CASE WHEN OW.REMAIN_IN_QTY < 0 THEN
									0
								ELSE
									OW.REMAIN_IN_QTY
								END								AS REMAIN_IN_QTY
							  ,OW.[PLAN_START_TIME]  -- [BASE_PLAN_START_TIME]
							  ,OW.[ACTUAL_QTY]
							  ,OW.[RUNNING_FLAG]
							  ,OW.[WO_STATUS]
							  ,OW.[MARKET]
							  ,OW.[LANE_QTY]
							  ,OW.[BATCH_ORDER_ID]
							  ,@v_proc_name
							  ,GETDATE()
							  ,@v_proc_name
							  ,GETDATE()
							  ,'ROLLING'
							  ,'Y'
						FROM ( SELECT  OW.[COMPANY_ID]
									  ,OW.[DIVISION_ID]
									  ,OW.[SITE_ID]
									  ,OW.[PLANT_ID]
									  ,OW.[FACTORY_ID]
									  ,OW.[CUTOFF_DATE]
									  ,OW.[WORK_ORDER_SPL_ID]
									  ,OW.[WORK_ORDER_ID]
									  ,OW.[DEMAND_ID]
									  ,OW.[PRODUCTION_TYPE]
									  ,OW.[ORDER_TYPE]
									  ,OW.[ITEM_ID]
									  ,OW.[TOP_ITEM_ID]
									  ,OW.[OPERATION_ID]
									  ,OW.[LINE_ID]
									  ,OW.[ELECTRODE_TYPE]
									  ,OW.[WORK_CENTER_ID]
									  ,OW.[EQUIPMENT_ID]
									  ,OW.[PLAN_DATE]
									  ,OW.[PLAN_START_TIME]
									  ,OW.[PLAN_END_TIME]
									  /* 2018-12-18 kimcd 수량 실적 처리 컬럼 수정,CASE WHEN SY.YIELD IS NULL OR SY.YIELD = 0 THEN
											OW.[PLAN_QTY] - OW.[ACTUAL_QTY]
											ELSE
											( OW.[PLAN_QTY] * SY.YIELD ) - OW.[ACTUAL_QTY]
											END    AS REMAIN_QTY
									  ,OW.[PLAN_IN_QTY] - OW.[ACTUAL_QTY] AS REMAIN_IN_QTY
									  ,OW.ACTUAL_QTY*/
									  ,OW.[PLAN_QTY] - OW.[ACTUAL_GOOD_QTY]   AS REMAIN_QTY -- 2018-12-18 kimcd 잔량을 양품실적 기준으로 산출
									  , CASE WHEN SY.YIELD IS NULL OR SY.YIELD = 0 THEN
											OW.[PLAN_QTY] - OW.[ACTUAL_GOOD_QTY]
										ELSE
											( OW.[PLAN_QTY]/SY.YIELD ) - OW.[ACTUAL_GOOD_QTY]
										END    AS REMAIN_IN_QTY -- 2018-12-18 kimcd 투입 잔량에 수율 감안
									  ,OW.ACTUAL_GOOD_QTY AS ACTUAL_QTY -- 2018-12-18 kimcd 실적을 양품 실적으로 변경
									  ,OW.[RUNNING_FLAG]
									  ,OW.[WO_STATUS]
									  ,OW.[MARKET]
									  ,OW.[LANE_QTY]
									  ,OW.[BATCH_ORDER_ID]
									  -- 2017-11-04 kimcd facory 기준 배포, plan group id 기준 배포 이원화에 따른 plan id 추출 과정 수정 시작
									  ,(SELECT  TOP 1 PL.[INSTANCE_ID]
										FROM    PLAN_ID PL
											   ,SCM_LINE_M  SL
										WHERE OW.SITE_ID      = PL.SITE_ID
										AND   OW.FACTORY_ID   = PL.FACTORY_ID
										AND   OW.OPERATION_ID = PL.OPERATION_ID
										AND   OW.FACTORY_ID   = SL.FACTORY_ID
										AND   OW.LINE_ID      = SL.LINE_ID
										AND   OW.OPERATION_ID = SL.OPERATION_ID
										AND   SL.MODEL_TYPE   = CASE WHEN PL.PLAN_GROUP_ID = '-' THEN SL.MODEL_TYPE ELSE PL.PLAN_GROUP_ID END) AS INSTANCE_ID
									  ,(SELECT  TOP 1 PL.[PLAN_ID]
										FROM    PLAN_ID PL
											   ,SCM_LINE_M  SL
										WHERE OW.SITE_ID      = PL.SITE_ID
										AND   OW.FACTORY_ID   = PL.FACTORY_ID
										AND   OW.OPERATION_ID = PL.OPERATION_ID
										AND   OW.FACTORY_ID   = SL.FACTORY_ID
										AND   OW.LINE_ID      = SL.LINE_ID
										AND   OW.OPERATION_ID = SL.OPERATION_ID
										AND   SL.MODEL_TYPE   = CASE WHEN PL.PLAN_GROUP_ID = '-' THEN SL.MODEL_TYPE ELSE PL.PLAN_GROUP_ID END) AS PLAN_ID
									  ,(SELECT  TOP 1 PL.[INSTANCE_TYPE]
										FROM    PLAN_ID PL
											   ,SCM_LINE_M  SL
										WHERE OW.SITE_ID      = PL.SITE_ID
										AND   OW.FACTORY_ID   = PL.FACTORY_ID
										AND   OW.OPERATION_ID = PL.OPERATION_ID
										AND   OW.FACTORY_ID   = SL.FACTORY_ID
										AND   OW.LINE_ID      = SL.LINE_ID
										AND   OW.OPERATION_ID = SL.OPERATION_ID
										AND   SL.MODEL_TYPE   = CASE WHEN PL.PLAN_GROUP_ID = '-' THEN SL.MODEL_TYPE ELSE PL.PLAN_GROUP_ID END) AS INSTANCE_TYPE
									  ,(SELECT  TOP 1 PL.[LINK_FACTORY_ID]
										FROM    PLAN_ID PL
											   ,SCM_LINE_M  SL
										WHERE OW.SITE_ID      = PL.SITE_ID
										AND   OW.FACTORY_ID   = PL.FACTORY_ID
										AND   OW.OPERATION_ID = PL.OPERATION_ID
										AND   OW.FACTORY_ID   = SL.FACTORY_ID
										AND   OW.LINE_ID      = SL.LINE_ID
										AND   OW.OPERATION_ID = SL.OPERATION_ID
										AND   SL.MODEL_TYPE   = CASE WHEN PL.PLAN_GROUP_ID = '-' THEN SL.MODEL_TYPE ELSE PL.PLAN_GROUP_ID END) AS LINK_FACTORY_ID
									  ,(SELECT  TOP 1 PL.[PLAN_GROUP_ID]
										FROM    PLAN_ID PL
											   ,SCM_LINE_M  SL
										WHERE OW.SITE_ID      = PL.SITE_ID
										AND   OW.FACTORY_ID   = PL.FACTORY_ID
										AND   OW.OPERATION_ID = PL.OPERATION_ID
										AND   OW.FACTORY_ID   = SL.FACTORY_ID
										AND   OW.LINE_ID      = SL.LINE_ID
										AND   OW.OPERATION_ID = SL.OPERATION_ID
										AND   SL.MODEL_TYPE   = CASE WHEN PL.PLAN_GROUP_ID = '-' THEN SL.MODEL_TYPE ELSE PL.PLAN_GROUP_ID END) AS PLAN_GROUP_ID
									  -- 2017-11-04 kimcd facory 기준 배포, plan group id 기준 배포 이원화에 따른 plan id 추출 과정 수정 끝
								FROM   [DBO].[FP_MES_WORK_ORDER_STATUS_H]   OW WITH(NOLOCK)
										LEFT OUTER JOIN DBO.SCM_YIELD_M  SY WITH(NOLOCK)
										ON  OW.[COMPANY_ID]   = SY.[COMPANY_ID]
										AND OW.[DIVISION_ID]  = SY.[DIVISION_ID]
										AND OW.[SITE_ID]      = SY.[SITE_ID]
										AND OW.[PLANT_ID]     = SY.[PLANT_ID]
										AND OW.[FACTORY_ID]   = SY.[FACTORY_ID]
										AND OW.[OPERATION_ID] = SY.[OPERATION_ID]
										AND OW.[LINE_ID]      = SY.[LINE_ID]
										AND OW.[ITEM_ID]      = SY.[ITEM_ID]
										AND SUBSTRING(CONVERT(NVARCHAR(20), OW.PLAN_DATE, 112) ,1, 6) = SY.[MONTH]
								WHERE ( ( OW.FACTORY_ID   IN ('E1'/*,'E2','E3','E4','E5','E6','E7','E8','EA' 2018-04-26 kimcd 대상 제외 */) /* 2017-08-08 KIMCD ADD 남경 공장 */ AND   OW.OPERATION_ID IN ('E1000','E2000','E2500') )
										/*2018-01-30 kimcd 오창 자동차 추가*/
										OR  ( OW.FACTORY_ID IN ('M1','M2') AND OW.WO_STATUS = 'PILOT' AND OW.OPERATION_ID IN ('A2000','A3000') ) -- kimcd 소형 Pilot WO 추가 2017-08-19 -- kimcd 2017-11-04 동 조건 추가
										-- 2018-01-06 kimcd 조건 막음. OR  ( OW.PLANT_ID = 'G182' ) -- kimcd 2017-11-04 남경 소형 조립은 모두 수용.
										OR  ( OW.FACTORY_ID = 'M7' )  -- 2018-04-26 kimcd 대상 추가 - EGL용
										OR  ( OW.OPERATION_ID IN  ('F6200','F7000','F7100','F7200','F7300') ) ) -- 2018-01-06 kimcd 남경 활성화 후 공정 추가. kimcd 활성화 용접 tab 추가 2017-08-19
								AND   OW.FACTORY_ID   = @FACTORY_ID
								AND   OW.SITE_ID      = @SITE_ID
								AND   OW.CUTOFF_DATE  = @BASE_DATE
								AND   OW.DEMAND_ID IS NOT NULL     -- 2018-01-06 kimcd MES 자체 형성 Data 제외
								AND   OW.EQUIPMENT_ID IS NOT NULL  -- 2018-01-06 kimcd MES 자체 형성 Data 제외
								                                   ) OW
						LEFT OUTER JOIN DBO.SCM_SYS_LOOKUP_VALUE  STL WITH(NOLOCK)
						ON  STL.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
						AND STL.SEGMENT1         = OW.[PLANT_ID]
						AND STL.ACTIVE_FLAG      = 'Y'
						LEFT OUTER JOIN (SELECT  [PLAN_WEEK]
												,[PLAN_REVISION]
												,[COMPANY_ID]
												,[DIVISION_ID]
												,[SITE_ID]
												,[PLANT_ID]
												,[FACTORY_ID]
												,[INSTANCE_ID]
												,[PLAN_GROUP_ID]  -- 2017-11-04 kimcd 제품군별 배포 추가
												,(SELECT TOP 1 FIF.[INSTANCE_TYPE]
												  FROM  [FP_INSTANCE_FACTORY_M] FIF WITH(NOLOCK)
												  WHERE 1 = 1 -- FIF.[FACTORY_ID]  = B.[FACTORY_ID] 2018-02-14 kimcd Factory_id 조건 제거. 남경 활성화 후 공정에서 MPP WPP 정보 추출이 안 되어 막음
												  AND   FIF.[INSTANCE_ID] = B.[INSTANCE_ID] )  AS INSTANCE_TYPE
										FROM  ( SELECT [PLAN_WEEK]
													  ,[PLAN_REVISION]
													  ,[COMPANY_ID]
													  ,[DIVISION_ID]
													  ,[SITE_ID]
													  ,[PLANT_ID]
													  ,[FACTORY_ID]
													  ,[INSTANCE_ID]
													  ,[PLAN_GROUP_ID]  -- 2017-11-04 kimcd 제품군별 배포 추가
													  ,ROW_NUMBER() OVER ( PARTITION BY  DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, PLAN_GROUP_ID, INSTANCE_ID ORDER BY INSERT_TIME DESC ) NUMS -- 마지막 RELEASE VERSION. 2017-11-04 kimcd plan_group_id 조건 추가
												 FROM    [dbo].[FP_MPP_WPP_BASE_PLAN_H]  BPH WITH(NOLOCK)
												 WHERE   BPH.[WO] = 'Y'  
												 -- AND     BPH.FACTORY_ID = @FACTORY_ID 2017-11-04 kimcd 조건 block
												 AND     BPH.SITE_ID    = @SITE_ID
											  ) B      
										WHERE B.NUMS = 1 )  WU
						ON 	 OW.[COMPANY_ID]      = WU.[COMPANY_ID]
						AND  OW.[DIVISION_ID]     = WU.[DIVISION_ID]
						AND  OW.[SITE_ID]         = WU.[SITE_ID]
						AND  OW.[PLANT_ID]        = WU.[PLANT_ID]
						AND  OW.[LINK_FACTORY_ID] = WU.[FACTORY_ID]      -- 2017-11-04 FACTORY ID에서 LINK FACTORY ID로 전환
						AND  OW.[INSTANCE_TYPE]   = WU.[INSTANCE_TYPE]
						AND  OW.[PLAN_GROUP_ID]   = WU.[PLAN_GROUP_ID];  -- 2017-11-04 PLAN GROUP ID 조건 추가

					OPEN CUR_WO;
					FETCH NEXT FROM CUR_WO INTO  @I_COMPANY_ID
												,@I_DIVISION_ID
												,@I_SITE_ID
												,@I_PLANT_ID
												,@I_FACTORY_ID
												,@I_PLAN_WEEK
												,@I_PLAN_REVISION
												,@I_INSTANCE_ID
												,@I_PLAN_ID
												,@I_CUTOFF_DATE
												,@I_WORK_ORDER_SPL_ID
												,@I_WORK_ORDER_ID
												,@I_DEMAND_ID
												,@I_PRODUCTION_TYPE
												,@I_ORDER_TYPE
												,@I_ITEM_ID
												,@I_TOP_ITEM_ID
												,@I_OPERATION_ID
												,@I_LINE_ID
												,@I_ELECTRODE_TYPE
												,@I_EQUIPMENT_ID
												,@I_PLAN_DATE
												,@I_PLAN_START_TIME
												,@I_PLAN_END_TIME
												,@I_REMAIN_QTY
												,@I_REMAIN_IN_QTY
												,@I_BASE_PLAN_START_TIME
												,@I_ACTUAL_QTY
												,@I_RUNNING_FLAG
												,@I_WO_STATUS
												,@I_MARKET
												,@I_LANE_QTY
												,@I_BATCH_ORDER_ID
												,@I_INSERT_ID
												,@I_INSERT_TIME
												,@I_UPDATE_ID
												,@I_UPDATE_TIME
												,@I_PLAN_TYPE
												,@I_FIXED_YN

					WHILE (@@FETCH_STATUS = 0)
						BEGIN
							INSERT INTO [DBO].[FP_MANUAL_WORK_ORDER_H]
								([COMPANY_ID]
								,[DIVISION_ID]
								,[SITE_ID]
								,[PLANT_ID]
								,[FACTORY_ID]
								,[PLAN_WEEK]
								,[PLAN_REVISION]
								,[INSTANCE_ID]
								,[PLAN_ID]
								,[CUTOFF_DATE]
								,[WORK_ORDER_SPL_ID]
								,[WORK_ORDER_ID]
								,[DEMAND_ID]
								,[PRODUCTION_TYPE]
								,[ORDER_TYPE]
								,[ITEM_ID]
								,[TOP_ITEM_ID]
								,[OPERATION_ID]
								,[LINE_ID]
								,[ELECTRODE_TYPE]
								,[EQUIPMENT_ID]
								,[PLAN_DATE]
								,[PLAN_START_TIME]
								,[PLAN_END_TIME]
								,[REMAIN_QTY]
								,[REMAIN_IN_QTY]
								,[BASE_PLAN_START_TIME]
								,[ACTUAL_QTY]
								,[RUNNING_FLAG]
								,[WO_STATUS]
								,[MARKET]
								,[LANE_QTY]
								,[BATCH_ORDER_ID]
								,[INSERT_ID]
								,[INSERT_TIME]
								,[UPDATE_ID]
								,[UPDATE_TIME]
								,[PLAN_TYPE]
								,[FIXED_YN])
 							VALUES ( @I_COMPANY_ID
									,@I_DIVISION_ID
									,@I_SITE_ID
									,@I_PLANT_ID
									,@I_FACTORY_ID
									,@I_PLAN_WEEK
									,@I_PLAN_REVISION
									,@I_INSTANCE_ID
									,@I_PLAN_ID
									,@I_CUTOFF_DATE
									,@I_WORK_ORDER_SPL_ID
									,@I_WORK_ORDER_ID
									,@I_DEMAND_ID
									,@I_PRODUCTION_TYPE
									,@I_ORDER_TYPE
									,@I_ITEM_ID
									,@I_TOP_ITEM_ID
									,@I_OPERATION_ID
									,@I_LINE_ID
									,@I_ELECTRODE_TYPE
									,@I_EQUIPMENT_ID
									,@I_PLAN_DATE
									,@I_PLAN_START_TIME
									,@I_PLAN_END_TIME
									,@I_REMAIN_QTY
									,@I_REMAIN_IN_QTY
									,@I_BASE_PLAN_START_TIME
									,@I_ACTUAL_QTY
									,@I_RUNNING_FLAG
									,@I_WO_STATUS
									,@I_MARKET
									,@I_LANE_QTY
									,@I_BATCH_ORDER_ID
									,@I_INSERT_ID
									,@I_INSERT_TIME
									,@I_UPDATE_ID
									,@I_UPDATE_TIME
									,@I_PLAN_TYPE
									,@I_FIXED_YN
									);

						FETCH NEXT FROM CUR_WO INTO  @I_COMPANY_ID
													,@I_DIVISION_ID
													,@I_SITE_ID
													,@I_PLANT_ID
													,@I_FACTORY_ID
													,@I_PLAN_WEEK
													,@I_PLAN_REVISION
													,@I_INSTANCE_ID
													,@I_PLAN_ID
													,@I_CUTOFF_DATE
													,@I_WORK_ORDER_SPL_ID
													,@I_WORK_ORDER_ID
													,@I_DEMAND_ID
													,@I_PRODUCTION_TYPE
													,@I_ORDER_TYPE
													,@I_ITEM_ID
													,@I_TOP_ITEM_ID
													,@I_OPERATION_ID
													,@I_LINE_ID
													,@I_ELECTRODE_TYPE
													,@I_EQUIPMENT_ID
													,@I_PLAN_DATE
													,@I_PLAN_START_TIME
													,@I_PLAN_END_TIME
													,@I_REMAIN_QTY
													,@I_REMAIN_IN_QTY
													,@I_BASE_PLAN_START_TIME
													,@I_ACTUAL_QTY
													,@I_RUNNING_FLAG
													,@I_WO_STATUS
													,@I_MARKET
													,@I_LANE_QTY
													,@I_BATCH_ORDER_ID
													,@I_INSERT_ID
													,@I_INSERT_TIME
													,@I_UPDATE_ID
													,@I_UPDATE_TIME
													,@I_PLAN_TYPE
													,@I_FIXED_YN
						END;
			
					CLOSE CUR_WO;
					DEALLOCATE CUR_WO;  
					-- 2017-11-04 kimcd 정보 입력 과정을 loop로 변경 끝

					SET @v_temp1 = 'INSERT @TEMP_TABLE'
					INSERT INTO   @TEMP_TABLE
						(	[CUTOFF_DATE],
							[COMPANY_ID],
							[DIVISION_ID],
							[SITE_ID],
							[PLANT_ID],
							[FACTORY_ID],
							[PLAN_WEEK],
							[PLAN_REVISION],
							[INSTANCE_ID],
							[PLAN_ID],
							[PRODUCTION_TYPE],
							[ORDER_TYPE],
							[WORK_ORDER_SPL_ID],
							[WORK_ORDER_ID],
							[ITEM_ID],
							[OPERATION_ID],
							[LINE_ID],
							[ELECTRODE_TYPE],
							[EQUIPMENT_ID],
							[MARKET],
							[LANE_QTY],
							[PLAN_DATE],
							[ACCUM_PLAN_QTY],
							[ROW_SEQ])
					SELECT MO.[CUTOFF_DATE]
					      ,MO.[COMPANY_ID]
					      ,MO.[DIVISION_ID]
					      ,MO.[SITE_ID]
					      ,MO.[PLANT_ID]
					      ,MO.[FACTORY_ID]
					      ,MO.[PLAN_WEEK]
					      ,MO.[PLAN_REVISION]
						  ,MO.[INSTANCE_ID]
						  ,MO.[PLAN_ID]
					      ,MO.[PRODUCTION_TYPE]
						  ,MO.[ORDER_TYPE]
						  ,MO.[WORK_ORDER_SPL_ID]
						  ,MO.[WORK_ORDER_ID]
					      ,MO.[ITEM_ID]
					      ,MO.[OPERATION_ID]
					      ,MO.[LINE_ID]
						  ,MO.[ELECTRODE_TYPE]
					      ,MO.[EQUIPMENT_ID]
						  ,MO.[MARKET]
						  ,MO.[LANE_QTY]
					      ,MO.[PLAN_DATE]
						  ,ISNULL(WBP.PLAN_QTY,0) - SUM(MO.REMAIN_QTY)  OVER ( PARTITION BY MO.[FACTORY_ID], MO.[PRODUCTION_TYPE], MO.[ITEM_ID], MO.[OPERATION_ID], MO.[LINE_ID], MO.[EQUIPMENT_ID], MO.[PLAN_DATE] 
																				 ORDER BY MO.[BASE_PLAN_START_TIME], MO.[WORK_ORDER_SPL_ID] ) AS ACCUM_PLAN_QTY
						  ,ROW_NUMBER()  OVER ( PARTITION BY MO.[FACTORY_ID], MO.[PRODUCTION_TYPE], MO.[ITEM_ID], MO.[OPERATION_ID], MO.[LINE_ID], MO.[EQUIPMENT_ID], MO.[PLAN_DATE] 
												ORDER BY MO.[BASE_PLAN_START_TIME], MO.[WORK_ORDER_SPL_ID] ) AS ROW_SEQ
					FROM   [DBO].[FP_MANUAL_WORK_ORDER_H]  MO
					LEFT OUTER JOIN [DBO].[FP_MPP_WPP_BASE_PLAN_M]  WBP WITH(NOLOCK)
					ON     MO.[COMPANY_ID]      = WBP.[COMPANY_ID]
					AND    MO.[DIVISION_ID]     = WBP.[DIVISION_ID]
					AND    MO.[SITE_ID]         = WBP.[SITE_ID]
					AND    MO.[PLANT_ID]        = WBP.[PLANT_ID]
					AND    MO.[FACTORY_ID]      = WBP.[FACTORY_ID]
					AND    MO.[PLAN_WEEK]       = WBP.[PLAN_WEEK]
					AND    MO.[PLAN_REVISION]   = WBP.[PLAN_REVISION]
					AND    MO.[PRODUCTION_TYPE] = WBP.[PRODUCTION_TYPE]
					AND    MO.[ITEM_ID]         = WBP.[ITEM_ID]
					AND    MO.[OPERATION_ID]    = WBP.[OPERATION_ID]
					AND    MO.[LINE_ID]         = WBP.[LINE_ID]
					AND    MO.[EQUIPMENT_ID]    = WBP.[EQUIPMENT_ID]
					AND    MO.[PLAN_DATE]       = WBP.[PLAN_DATE]
					AND    MO.[MARKET]          = WBP.[MARKET] -- kimcd 2017-11-04 남경 market 구분자 추가
					WHERE  MO.[FACTORY_ID]      = @FACTORY_ID
					AND    MO.[SITE_ID]         = @SITE_ID
					AND    MO.[CUTOFF_DATE]     = @BASE_DATE
					AND    MO.[PLAN_DATE]       = @BASE_DATE
					AND    MO.[PLAN_TYPE]       = 'ROLLING'
					

					DECLARE CUR_MAX_PLAN_DATE CURSOR FOR
						SELECT  MAX(TT.[COMPANY_ID])  AS COMPANY_ID,
								MAX(TT.[DIVISION_ID]) AS DIVISION_ID,
								MAX(TT.[SITE_ID])     AS  SITE_ID,
								MAX(TT.[PLANT_ID])    AS PLANT_ID,
								TT.[FACTORY_ID],
								TT.[PLAN_WEEK],
								TT.[PLAN_REVISION],
								MAX(TT.[INSTANCE_ID]) AS INSTANCE_ID,
								MAX(TT.[PLAN_ID])     AS PLAN_ID,
								TT.[PRODUCTION_TYPE],
								MAX(TT.[ORDER_TYPE])  AS ORDER_TYPE,
								TT.[ITEM_ID],
								TT.[OPERATION_ID],
								TT.[LINE_ID],
								MAX(TT.[ELECTRODE_TYPE]) AS ELECTRODE_TYPE,
								TT.[EQUIPMENT_ID],
								-- MAX(TT.[MARKET])      AS MARKET, kimcd 2017-11-04 남경 market을 group by에 추가
								TT.[MARKET], -- kimcd 2017-11-04 남경 market을 group by에 추가
								MAX(TT.[LANE_QTY])    AS LANE_QTY,
								TT.[PLAN_DATE],
								MAX(TT.[ROW_SEQ])     AS ROW_SEQ,
								MIN([ACCUM_PLAN_QTY]) AS ACCUM_PLAN_QTY
						FROM    @TEMP_TABLE   TT
						WHERE   TT.[FACTORY_ID]      = @FACTORY_ID
						AND     TT.[SITE_ID]         = @SITE_ID
						AND     TT.[CUTOFF_DATE]     = @BASE_DATE
						GROUP BY TT.[FACTORY_ID]
							    ,TT.[PLAN_WEEK]
							    ,TT.[PLAN_REVISION]
								,TT.[PRODUCTION_TYPE]
								,TT.[ITEM_ID]
								,TT.[OPERATION_ID]
								,TT.[LINE_ID]
								,TT.[EQUIPMENT_ID]
								,TT.[MARKET]   -- kimcd 2017-11-04 남경 market 구분 추가
								,TT.[PLAN_DATE]
						HAVING   MIN([ACCUM_PLAN_QTY]) < 0;

					OPEN CUR_MAX_PLAN_DATE;
					FETCH NEXT FROM CUR_MAX_PLAN_DATE INTO	 @TT_COMPANY_ID
															,@TT_DIVISION_ID
															,@TT_SITE_ID
															,@TT_PLANT_ID
															,@TT_FACTORY_ID
															,@TT_PLAN_WEEK
															,@TT_PLAN_REVISION
															,@TT_INSTANCE_ID
															,@TT_PLAN_ID
															,@TT_PRODUCTION_TYPE
															,@TT_ORDER_TYPE
															,@TT_ITEM_ID
															,@TT_OPERATION_ID
															,@TT_LINE_ID
															,@TT_ELECTRODE_TYPE
															,@TT_EQUIPMENT_ID
															,@TT_MARKET
															,@TT_LANE_QTY
															,@TT_PLAN_DATE
															,@TT_ROW_SEQ
															,@TT_ACCUM_PLAN_QTY

					WHILE (@@FETCH_STATUS = 0)
						BEGIN
							SET @v_temp1 = 'ROLLING WORK ORDER'
							SET @MIN_OTHER_PLAN_DATE   = NULL;
							SET @MAX_ITEM_PLAN_DATE    = NULL;
							SET @NEW_ITEM_PLAN_DATE    = NULL;
							SET @NEW_WORK_ORDER_SPL_ID = NULL;
							SET @NEW_WORK_ORDER_ID     = NULL;

							SELECT @MIN_OTHER_PLAN_DATE = MIN(WBP.[PLAN_DATE])
							FROM   [DBO].[FP_MPP_WPP_BASE_PLAN_M]  WBP WITH(NOLOCK)		
							WHERE  WBP.FACTORY_ID      = @TT_FACTORY_ID
							AND		WBP.ITEM_ID       != @TT_ITEM_ID
							AND		WBP.OPERATION_ID   = @TT_OPERATION_ID
							AND		WBP.LINE_ID	       = @TT_LINE_ID
							AND		WBP.EQUIPMENT_ID   = @TT_EQUIPMENT_ID
							AND     WBP.MARKET         = @TT_MARKET  -- kimcd 2017-11-04 남경 market 구분자 추가
							AND		WBP.PLAN_DATE      >= @TT_PLAN_DATE
							AND		WBP.PLAN_WEEK      = @TT_PLAN_WEEK
							AND		WBP.PLAN_REVISION  = @TT_PlAN_REVISION;

							SELECT @MAX_ITEM_PLAN_DATE = MAX(WBP.[PLAN_DATE])
							FROM   [DBO].[FP_MPP_WPP_BASE_PLAN_M]  WBP WITH(NOLOCK)		
							WHERE  WBP.FACTORY_ID      = @TT_FACTORY_ID
							AND		WBP.ITEM_ID        = @TT_ITEM_ID
							AND		WBP.OPERATION_ID   = @TT_OPERATION_ID
							AND		WBP.LINE_ID	       = @TT_LINE_ID
							AND		WBP.EQUIPMENT_ID   = @TT_EQUIPMENT_ID
							AND     WBP.MARKET         = @TT_MARKET  -- kimcd 2017-11-04 남경 market 구분자 추가
							AND		WBP.PLAN_DATE      >= @TT_PLAN_DATE
							AND		WBP.PLAN_DATE      <= ISNULL(@MIN_OTHER_PLAN_DATE,GETDATE()+100)
							AND		WBP.PLAN_WEEK      = @TT_PLAN_WEEK
							AND		WBP.PLAN_REVISION  = @TT_PlAN_REVISION;

						IF @MIN_OTHER_PLAN_DATE IS NOT NULL AND @MAX_ITEM_PLAN_DATE IS NOT NULL
						AND ( @MIN_OTHER_PLAN_DATE = @MAX_ITEM_PLAN_DATE )
						AND @MIN_OTHER_PLAN_DATE > @TT_PLAN_DATE
							BEGIN
								SET @NEW_ITEM_PLAN_DATE = @MAX_ITEM_PLAN_DATE;
							END; 	
						ELSE IF @MIN_OTHER_PLAN_DATE IS NOT NULL AND @MAX_ITEM_PLAN_DATE IS NOT NULL
						AND ( @MIN_OTHER_PLAN_DATE >= @MAX_ITEM_PLAN_DATE+1 )
							BEGIN
								SET @NEW_ITEM_PLAN_DATE = @MAX_ITEM_PLAN_DATE+1;
							END; 	
						ELSE IF @MAX_ITEM_PLAN_DATE >= @TT_PLAN_DATE AND @MIN_OTHER_PLAN_DATE IS NULL
							BEGIN
								SET @NEW_ITEM_PLAN_DATE = @MAX_ITEM_PLAN_DATE+1;
							END;
							
						IF @NEW_ITEM_PLAN_DATE IS NOT NULL
							BEGIN
								UPDATE MWO
								SET    MWO.[REMAIN_QTY] =	CASE WHEN  MWO.[REMAIN_QTY] + TT.[ACCUM_PLAN_QTY] < 0 THEN
																0
															ELSE
																MWO.[REMAIN_QTY] + TT.[ACCUM_PLAN_QTY]
															END
									  ,MWO.[REMAIN_IN_QTY] = CASE WHEN  MWO.[REMAIN_IN_QTY] + TT.[ACCUM_PLAN_QTY] < 0 THEN
																0
															ELSE
																MWO.[REMAIN_IN_QTY] + TT.[ACCUM_PLAN_QTY]
															END
									  ,MWO.[ROLLING_PLAN_DATE] = @NEW_ITEM_PLAN_DATE
									  ,MWO.[UPDATE_TIME]  = GETDATE()
								FROM   [DBO].[FP_MANUAL_WORK_ORDER_H]  MWO
									  ,@TEMP_TABLE  TT
								WHERE   MWO.[FACTORY_ID]        = TT.[FACTORY_ID]
								AND		MWO.[PLAN_WEEK]         = TT.[PLAN_WEEK]
								AND		MWO.[PLAN_REVISION]     = TT.[PLAN_REVISION]
								AND		MWO.[CUTOFF_DATE]       = TT.[CUTOFF_DATE]
								AND		MWO.[WORK_ORDER_SPL_ID] = TT.[WORK_ORDER_SPL_ID]
								AND		MWO.[WORK_ORDER_ID]     = TT.[WORK_ORDER_ID]
								AND		MWO.[PRODUCTION_TYPE]   = TT.[PRODUCTION_TYPE]
								AND		MWO.[ITEM_ID]           = TT.[ITEM_ID]
								AND		MWO.[OPERATION_ID]      = TT.[OPERATION_ID]
								AND		MWO.[LINE_ID]           = TT.[LINE_ID]
								AND		MWO.[EQUIPMENT_ID]      = TT.[EQUIPMENT_ID]
								AND     MWO.[MARKET]            = TT.[MARKET]   -- kimcd 2017-11-04 남경 market 구분자 추가
								AND		MWO.[PLAN_DATE]         = TT.[PLAN_DATE]
								AND		TT.[CUTOFF_DATE]     = @BASE_DATE
								AND		TT.[FACTORY_ID]      = @TT_FACTORY_ID
								AND		TT.[PRODUCTION_TYPE] = @TT_PRODUCTION_TYPE
								AND		TT.[ITEM_ID]         = @TT_ITEM_ID
								AND		TT.[OPERATION_ID]    = @TT_OPERATION_ID
								AND		TT.[LINE_ID]         = @TT_LINE_ID
								AND		TT.[EQUIPMENT_ID]    = @TT_EQUIPMENT_ID
								AND     TT.[MARKET]          = @TT_MARKET  -- kimcd 2017-11-04 남경 market 구분자 추가
								AND		TT.[PLAN_DATE]       = @TT_PLAN_DATE
								AND		TT.[ACCUM_PLAN_QTY]  < 0
								AND     MWO.[PLAN_TYPE]      = 'ROLLING'


								SELECT TOP 1
										@NEW_WORK_ORDER_SPL_ID = MWO.[WORK_ORDER_SPL_ID],
										@NEW_WORK_ORDER_ID     = MWO.[WORK_ORDER_ID]
								FROM   [DBO].[FP_MANUAL_WORK_ORDER_H]  MWO
								WHERE   MWO.[FACTORY_ID]        = @TT_FACTORY_ID
								AND		MWO.[PLAN_WEEK]         = @TT_PLAN_WEEK
								AND		MWO.[PLAN_REVISION]     = @TT_PlAN_REVISION
								AND		MWO.[CUTOFF_DATE]       = @BASE_DATE
								AND		MWO.[PRODUCTION_TYPE]   = @TT_PRODUCTION_TYPE
								AND		MWO.[ITEM_ID]           = @TT_ITEM_ID
								AND		MWO.[OPERATION_ID]      = @TT_OPERATION_ID
								AND		MWO.[LINE_ID]           = @TT_LINE_ID
								AND		MWO.[EQUIPMENT_ID]      = @TT_EQUIPMENT_ID
								AND		MWO.[PLAN_DATE]         = @NEW_ITEM_PLAN_DATE
								AND     MWO.[MARKET]            = @TT_MARKET -- kimcd 2017-11-04 남경 market 구분자 추가
								AND     MWO.[PLAN_TYPE]         = 'ROLLING'
								ORDER   BY MWO.ACTUAL_QTY, MWO.[WORK_ORDER_SPL_ID] DESC;

								IF @NEW_WORK_ORDER_SPL_ID IS NULL
									BEGIN
									    SET @NEW_ORDER_SEQ = @NEW_ORDER_SEQ + 1
										SET @NEW_WORK_ORDER_SPL_ID = 'NEW_' + CONVERT(NVARCHAR(8), GETDATE() , 112) + '_' + CONVERT(NVARCHAR(5), @NEW_ORDER_SEQ)
										SET @NEW_WORK_ORDER_ID = @NEW_WORK_ORDER_SPL_ID
										-- SELECT ISNULL(@NEW_WORK_ORDER_ID,'*')
									END
	
								IF @NEW_WORK_ORDER_SPL_ID LIKE 'NEW%'
									BEGIN
										INSERT INTO [DBO].[FP_MANUAL_WORK_ORDER_H]
													([COMPANY_ID]
													,[DIVISION_ID]
													,[SITE_ID]
													,[PLANT_ID]
													,[FACTORY_ID]
													,[PLAN_WEEK]
													,[PLAN_REVISION]
													,[INSTANCE_ID]
													,[PLAN_ID]
													,[CUTOFF_DATE]
													,[WORK_ORDER_SPL_ID]
													,[WORK_ORDER_ID]
													,[DEMAND_ID]
													,[PRODUCTION_TYPE]
													,[ORDER_TYPE]
													,[ITEM_ID]
													,[TOP_ITEM_ID]
													,[OPERATION_ID]
													,[LINE_ID]
													,[ELECTRODE_TYPE]
													,[EQUIPMENT_ID]
													,[PLAN_DATE]
													,[PLAN_START_TIME]
													,[PLAN_END_TIME]
													,[REMAIN_QTY]
													,[REMAIN_IN_QTY]
													,[BASE_PLAN_START_TIME]
													,[ACTUAL_QTY]
													,[RUNNING_FLAG]
													,[WO_STATUS]
													,[MARKET]
													,[LANE_QTY]
													,[INSERT_ID]
													,[INSERT_TIME]
													,[UPDATE_ID]
													,[UPDATE_TIME]
													,[PLAN_TYPE]
													,[FIXED_YN])
										SELECT   @TT_COMPANY_ID
												,@TT_DIVISION_ID
												,@TT_SITE_ID
												,@TT_PLANT_ID
												,@TT_FACTORY_ID
												,@TT_PLAN_WEEK
												,@TT_PLAN_REVISION
												,@TT_INSTANCE_ID
												,@TT_PLAN_ID
												,@BASE_DATE
												,@NEW_WORK_ORDER_SPL_ID
												,@NEW_WORK_ORDER_ID
												,'MANUAL_DEMAND'
												,@TT_PRODUCTION_TYPE
												,@TT_ORDER_TYPE
												,@TT_ITEM_ID
												,@TT_ITEM_ID
												,@TT_OPERATION_ID
												,@TT_LINE_ID
												,@TT_ELECTRODE_TYPE
												,@TT_EQUIPMENT_ID
												,@NEW_ITEM_PLAN_DATE
												,CONVERT ( DATETIME, CONVERT( NVARCHAR(10), @NEW_ITEM_PLAN_DATE,  120) + ' ' + SUBSTRING(STL.SEGMENT2, 1,2) + ':' + SUBSTRING(STL.SEGMENT2, 3,2) + ':' + SUBSTRING(STL.SEGMENT2, 5,2), 120)
												,CONVERT ( DATETIME, CONVERT( NVARCHAR(10), @NEW_ITEM_PLAN_DATE,  120) + ' ' + SUBSTRING(STL.SEGMENT2, 1,2) + ':' + CONVERT(NVARCHAR(2), CONVERT(NUMERIC, SUBSTRING(STL.SEGMENT2, 3,2)) + 10) + ':' + SUBSTRING(STL.SEGMENT2, 5,2), 120)
											    ,ABS(@TT_ACCUM_PLAN_QTY)
												,ABS(@TT_ACCUM_PLAN_QTY)
												,@NEW_ITEM_PLAN_DATE
												,0
												,'-'   -- [RUNNING_FLAG]
												,'OPEN'   -- [WO_STATUS]
												,@TT_MARKET
												,@TT_LANE_QTY
												,@v_proc_name
												,GETDATE()
												,@v_proc_name
												,GETDATE()
												,'ROLLING'
												,'N'
										FROM   DBO.SCM_SYS_LOOKUP_VALUE  STL WITH(NOLOCK)
										WHERE  STL.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
										AND    STL.SEGMENT1         = @TT_PLANT_ID
										AND    STL.ACTIVE_FLAG      = 'Y';
									END;
								ELSE
									BEGIN
										UPDATE [DBO].[FP_MANUAL_WORK_ORDER_H]
										SET  [REMAIN_QTY]    = [REMAIN_QTY] + ABS(@TT_ACCUM_PLAN_QTY)
											,[REMAIN_IN_QTY] = [REMAIN_IN_QTY] + ABS(@TT_ACCUM_PLAN_QTY)
											,[UPDATE_ID]     = @v_proc_name
											,[UPDATE_TIME]   = GETDATE()
										WHERE	[WORK_ORDER_SPL_ID] = @NEW_WORK_ORDER_SPL_ID
										AND		[WORK_ORDER_ID]     = @NEW_WORK_ORDER_ID
										AND     [FACTORY_ID]        = @TT_FACTORY_ID
										AND		[PLAN_WEEK]         = @TT_PLAN_WEEK
										AND		[PLAN_REVISION]     = @TT_PlAN_REVISION
										AND		[CUTOFF_DATE]       = @BASE_DATE
										AND		[PRODUCTION_TYPE]   = @TT_PRODUCTION_TYPE
										AND		[ITEM_ID]           = @TT_ITEM_ID
										AND		[OPERATION_ID]      = @TT_OPERATION_ID
										AND		[LINE_ID]           = @TT_LINE_ID
										AND		[EQUIPMENT_ID]      = @TT_EQUIPMENT_ID
										AND		[PLAN_DATE]         = @NEW_ITEM_PLAN_DATE
										AND     [MARKET]            = @TT_MARKET -- kimcd 2017-11-04 남경 market 구분자 추가
										AND     [PLAN_TYPE]         = 'ROLLING';
									END;

							END;
						

						FETCH NEXT FROM CUR_MAX_PLAN_DATE INTO	 @TT_COMPANY_ID
																,@TT_DIVISION_ID
																,@TT_SITE_ID
																,@TT_PLANT_ID
																,@TT_FACTORY_ID
																,@TT_PLAN_WEEK
																,@TT_PLAN_REVISION
																,@TT_INSTANCE_ID
																,@TT_PLAN_ID
																,@TT_PRODUCTION_TYPE
																,@TT_ORDER_TYPE
																,@TT_ITEM_ID
																,@TT_OPERATION_ID
																,@TT_LINE_ID
																,@TT_ELECTRODE_TYPE
																,@TT_EQUIPMENT_ID
																,@TT_MARKET
																,@TT_LANE_QTY
																,@TT_PLAN_DATE
																,@TT_ROW_SEQ
																,@TT_ACCUM_PLAN_QTY

						END;
			
					CLOSE CUR_MAX_PLAN_DATE;
					DEALLOCATE CUR_MAX_PLAN_DATE;  

					MERGE INTO [DBO].[SCM_SYS_LOOKUP_VALUE] A
					USING ( 
						SELECT @SITE_ID              AS SITE_ID
							  ,@FACTORY_ID           AS FACTORY_ID
							  ,CONVERT( NVARCHAR(8), GETDATE(), 112) AS EXEC_DATE
							  ) B
					ON  (     A.LOOKUP_TYPE_CODE = 'WO_MANUAL_ROLLING_FLAG'
						  AND A.SEGMENT1         = B.SITE_ID
						  AND A.SEGMENT2         = B.FACTORY_ID)
					WHEN MATCHED THEN
					UPDATE SET A.[ATTRIBUTE1]     = B.[EXEC_DATE]
							  ,A.[MODIFY_USER_ID] = 'PR_SCM_MANUAL_WO_ROLLING'        
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
							  ,[ATTRIBUTE1])
					VALUES('WO_MANUAL_ROLLING_FLAG'
						  ,B.SITE_ID
						  ,B.FACTORY_ID
						  ,'-'
						  ,'-'
						  ,'-'
						  ,'Y'
						  ,'PR_SCM_MANUAL_WO_ROLLING'
						  ,GETDATE()
						  ,'PR_SCM_MANUAL_WO_ROLLING'
						  ,GETDATE()
						  ,B.[EXEC_DATE]);

				DELETE FROM @TEMP_TABLE;

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



