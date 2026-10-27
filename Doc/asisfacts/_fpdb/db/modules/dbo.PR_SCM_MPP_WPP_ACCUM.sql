
-- CREATE PROCEDURE [dbo].[PR_SCM_MPP_WPP_ACCUM]
CREATE PROCEDURE [dbo].[PR_SCM_MPP_WPP_ACCUM]

-- ================================================================================================
-- Program ID          : 
-- Program Name        : PR_SCM_MPP_WPP_ACCUM
-- Param               :
-- Batch Period        : called from MPP WPP UI
-- Description         :
--
-- Source System       : FP MPP WPP
-- Destination System  : FP DAILY PLAN
-- Source Table        : FP_MPP_WPP_BASE_PLAN_H, FP_MPP_WPP_BASE_PLAN_M
-- Destination Table   : FP_DAILY_PRODUCTIOIN_PLAN_H
--
-- Create(Update) Date : 2018-08-06
--						 2018-11-21 PIYONG 2.0
--						 2018-12-07 PIYONG 2.1
--                       2018-12-11 kimcd  2.2
--                       2020-06-30 kimcd  2.3
--                       2021-08-26 kimcd  2.4
--                       2022-11-02 kimcd  2.5

-- Author              : KIMCD
-- Version             : 1.0
--                       2018-04-24 kimcd 계획 이력 정보에 MPP, WPP 확정 계획 추가
--                       2018-05-15 kimcd 일자별 계획 전송에서 LOCK 발생하는 경우 발생하여 
--                                        FP_DAILY_PRODUCTIOIN_PLAN_H 삭제 과정에서 NOLOCK 삭제
--                                        CELL 공정 BOM 대상 소요량 산출 로직 보완
--                       2018-08-06 kimcd MPP, WPP 이력 정보 형성에서 해당 월이나, 주, 공정 기준으로
--                                        upload된 정보가 존재하는 경우만 삭제
--                                        ELECTORDE TYPE 문장 보완 - LINE ASSIGN 정보 조회
--						 2018-11-21 PIYONG Coating 공정에 환산로직 변경
--										 MAN(VALUE) -> MODEL_ID, PROD_VERSION_TYPE 포함하여 PROD_VER_TYPE 우선순으로 찾음  없으면 값이 작은 값 우선 순위
--						 2018-12-07 PIYONG Coating 공정에 환산 실적 갱신 로직 변경
--										 우선 순위 변경
--                       2018-12-11 kimcd 조립 공정 Cell 수량 계산 로직에서 Applied model을 우선하도록 수정
--                       2019-02-25 kimcd 일자별 계획 누적에서 정보 삭제 기준을 Plan Group 제거하고 라인 기준으로 변경
--                       2020-06-30 kimcd 환산자 선택 로직 수정
--                       2021-08-26 kimcd  MPP, WPP 계획과 DPP의 DW 취합 기준을 1원화하기 위해서 기존 정보 삭제하지 않고 수량 갱신함
--                       2021-09-17 kimcd  설비를 '-'로 넣는 조립,활성화,Pack에서 ELECTRODE_TYPE을 ON 조건에서 제거
--                       2022-06-09 kimcd location은 항상 갱신하도록 보완
--                       2022-11-02 kimcd 전극 version, ec no 추가 관리
-- ================================================================================================
	@P_PLAN_WEEK      NVARCHAR(10)  = NULL,
	@P_PLAN_REVISION  NVARCHAR(100) = NULL
AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_SCM_MPP_WPP_ACCUM'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	   = 0
	DECLARE @sysdate     DATETIME2     = GETDATE()
	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)
	DECLARE @v_temp3     NVARCHAR(1000)
	DECLARE @SITE_ID     NVARCHAR(10)
	DECLARE @INSTANCE_ID    NVARCHAR(30)
	DECLARE @PLANT_ID    NVARCHAR(30)  -- 2020-06-30 kimcd 환산자 선택 로직 수정
	DECLARE @FACTORY_ID     NVARCHAR(30)
	DECLARE @PLAN_GROUP_ID  NVARCHAR(30)
	DECLARE @WPP_FLAG    NVARCHAR(10)
	DECLARE @MPP_FLAG    NVARCHAR(10)
	DECLARE @PLAN_WEEK   NVARCHAR(10)
	DECLARE @PLAN_MONTH  NVARCHAR(10)
	DECLARE @FIRST_DATE  DATE
	DECLARE @LAST_DATE   DATE
	DECLARE @TEMP_TABLE TABLE (
			 OPERATION_ID	NVARCHAR(30) )  -- 2018-08-06 kimcd 공정용 임시 Table
	DECLARE @CONV_TABLE TABLE (
			 INSTANCE_ID      NVARCHAR(30),
			 PLANT_ID         NVARCHAR(30),
			 PRODUCTION_TYPE  NVARCHAR(30),
			 VERSION_TYPE     NVARCHAR(30),
             IDX              NUMERIC(10) )  -- 2020-06-30 kimcd 환산자 정렬용 임시 Table

	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp3 = 'PLAN_WEEK : ' + ISNULL(@P_PLAN_WEEK,'') + ' PLAN_REVISION : '+ISNULL(@P_PLAN_REVISION,'')


	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', @v_temp3, @sysdate

	BEGIN TRY				

		BEGIN TRAN
		-- ================================================
		-- 로직 추가
		-- ================================================
		IF (@P_PLAN_WEEK IS NULL OR @P_PLAN_REVISION IS NULL)
			BEGIN
				RAISERROR ('Paramter Plan Week or Plan Revision are NULL. All Parameters are Required Value.', -- Message text.
							16, -- Severity.
							1 -- State.
							);
			END;

			SELECT @SITE_ID       = SITE_ID
				  ,@INSTANCE_ID   = INSTANCE_ID
				  ,@PLANT_ID      = PLANT_ID  -- 2020-06-30 kimcd 환산자 선택 로직 수정
				  ,@FACTORY_ID    = FACTORY_ID
				  ,@PLAN_GROUP_ID = PLAN_GROUP_ID
				  ,@WPP_FLAG      = WPP
				  ,@MPP_FLAG      = MPP
				  ,@PLAN_WEEK     = PLAN_WEEK
				  ,@PLAN_MONTH    = PLAN_MONTH
			FROM   [dbo].[FP_MPP_WPP_BASE_PLAN_H] A  WITH(NOLOCK)
			WHERE  A.PLAN_WEEK     = @P_PLAN_WEEK
			AND    A.PLAN_REVISION = @P_PLAN_REVISION

			IF @WPP_FLAG = 'Y'
				BEGIN
					SELECT TOP 1 @FIRST_DATE = SSC.DATE_ID
					FROM   DBO.SCM_SYS_CALENDAR_M SSC WITH(NOLOCK)
					WHERE  SSC.WEEK = @PLAN_WEEK
					ORDER BY SSC.DATE_ID;
					--SELECT TOP 1 @FIRST_DATE = A.PLAN_DATE
					--FROM   [DBO].[FP_MPP_WPP_BASE_PLAN_M] A WITH(NOLOCK)
					--WHERE  A.PLAN_WEEK     = @P_PLAN_WEEK
					--AND    A.PLAN_REVISION = @P_PLAN_REVISION
					--ORDER  BY A.PLAN_DATE

					-- SELECT  @FIRST_DATE = CASE WHEN @FIRST_DATE > CONVERT(DATE, [dbo].[FN_SITE_TIME] (@SITE_ID), 112) THEN @FIRST_DATE ELSE CONVERT(DATE, [dbo].[FN_SITE_TIME] (@SITE_ID), 112) END

					SELECT TOP 1 @LAST_DATE = SSC.WEEKEND_DATE
					FROM   DBO.SCM_SYS_CALENDAR_M SSC WITH(NOLOCK)
					WHERE  SSC.WEEK = @PLAN_WEEK

					-- 2018-08-06 kimcd logic 막음 SELECT  @LAST_DATE = CASE WHEN @LAST_DATE >= CONVERT(DATE, [dbo].[FN_SITE_TIME] (@SITE_ID), 112) THEN DATEADD(D,365,@LAST_DATE) ELSE @LAST_DATE END
					
					-- 2018-08-06 kimcd logic 추가 시작
					-- 삭제해야 할 일자 범위 찾기
					IF @LAST_DATE >= CONVERT(DATE, [dbo].[FN_SITE_TIME] (@SITE_ID), 112)
						BEGIN
							SELECT TOP 1 @LAST_DATE = SSC.WEEKEND_DATE
							FROM   DBO.SCM_SYS_CALENDAR_M     SSC WITH(NOLOCK)
								 , DBO.FP_MPP_WPP_BASE_PLAN_M A   WITH(NOLOCK)
							WHERE  SSC.DATE_ID     = A.PLAN_DATE
							AND    A.PLAN_WEEK     = @P_PLAN_WEEK
							AND    A.PLAN_REVISION = @P_PLAN_REVISION
							ORDER  BY SSC.WEEKEND_DATE DESC
						END;

					-- 삭제해야 할 공정 범위 찾기
					DELETE @TEMP_TABLE

					INSERT INTO @TEMP_TABLE
					SELECT DISTINCT OPERATION_ID
					FROM   DBO.FP_MPP_WPP_BASE_PLAN_M A   WITH(NOLOCK)
					WHERE  A.PLAN_WEEK     = @P_PLAN_WEEK
					AND    A.PLAN_REVISION = @P_PLAN_REVISION
					-- 2018-08-06 kimcd logic 추가 종료

					-- WPP 기존 생성된 데이터 삭제
					-- DELETE A 2021-08-26 kimcd 삭제에서 수량 갱신으로 변경
					UPDATE A
					SET  [PLAN_QTY]      = 0
						,[PLAN_IN_QTY]   = 0
						,[UPDATE_ID]     = 'PR_SCM_MPP_WPP_ACCUM'
						,[UPDATE_TIME]   = GETDATE()
						,[ROLL_IN_QTY]   = 0
						,[ROLL_OUT_QTY]  = 0
						,[JR_IN_QTY]     = 0
						,[JR_OUT_QTY]    = 0
						,[BATCH_IN_QTY]  = 0
						,[BATCH_OUT_QTY] = 0
						,[CELL_IN_QTY]   = 0
						,[CELL_OUT_QTY]  = 0
					  FROM FP_DAILY_PRODUCTIOIN_PLAN_H A -- WITH(NOLOCK) 2018-05-15 kimcd lock waiting 함
						   ,( SELECT  B.PLAN_GROUP_ID
									 ,B.INSTANCE_TYPE
									 ,B.FACTORY_ID
									 ,B.INSTANCE_ID  -- 2019-02-25 kimcd 라인 정보 추출을 위해 구분자 추가
								FROM  ( SELECT A.[INSTANCE_ID]
												,INSTANCE_TYPE
												,B.SITE_ID
												,B.FACTORY_ID
												,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE B.FACTORY_ID END  AS LINK_FACTORY_ID
												,ISNULL(MP.SEGMENT2,'-')  AS PLAN_GROUP_ID
										   FROM DBO.[FP_INSTANCE_FACTORY_M] A WITH(NOLOCK)     
												,DBO.SCM_FACTORY_M B WITH(NOLOCK)
												,SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
												LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE MP WITH(NOLOCK)
															 ON MP.LOOKUP_TYPE_CODE  = 'INSTANCE_PLANNING_GROUP'
															AND MP.SEGMENT1 = SLV.SEGMENT1
															AND SLV.ATTRIBUTE1 = 'PLAN GROUP'
										  WHERE A.FACTORY_ID  = B.FACTORY_ID     
											AND A.ACTIVE_FLAG = 'Y'     
											AND A.ACTIVE_FLAG = B.ACTIVE_FLAG     
											AND A.INSTANCE_ID != 'KR_CELL_M_P'
											AND SLV.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
											AND SLV.SEGMENT1  = A.INSTANCE_ID
											AND A.INSTANCE_ID = @INSTANCE_ID
										UNION ALL
										 SELECT A.[INSTANCE_ID]  AS INSTANCE_ID
												,INSTANCE_TYPE+'_P' AS INSTANCE_TYPE
												,B.SITE_ID
												,B.FACTORY_ID
												,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE B.FACTORY_ID END  AS LINK_FACTORY_ID
												,ISNULL(MP.SEGMENT2,'-')  AS PLAN_GROUP_ID
										   FROM DBO.[FP_INSTANCE_FACTORY_M] A WITH(NOLOCK)     
												,DBO.SCM_FACTORY_M B WITH(NOLOCK)
												,SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
												LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE MP WITH(NOLOCK)
															 ON MP.LOOKUP_TYPE_CODE  = 'INSTANCE_PLANNING_GROUP'
															AND MP.SEGMENT1 = SLV.SEGMENT1
															AND SLV.ATTRIBUTE1 = 'PLAN GROUP'
										  WHERE A.FACTORY_ID  = B.FACTORY_ID     
											AND A.ACTIVE_FLAG = 'Y'     
											AND A.ACTIVE_FLAG = B.ACTIVE_FLAG     
											AND A.INSTANCE_ID = 'KR_CELL_M_P'
											AND SLV.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
											AND SLV.SEGMENT1  = A.INSTANCE_ID
											AND A.INSTANCE_ID = @INSTANCE_ID
									 ) B      
							   WHERE B.LINK_FACTORY_ID = @FACTORY_ID
								 AND B.PLAN_GROUP_ID   = @PLAN_GROUP_ID
						   ) B
					 WHERE A.FACTORY_ID = B.FACTORY_ID
					   -- AND A.PLAN_GROUP_ID = B.PLAN_GROUP_ID 2019-02-25 kimcd PLAN GROUP ID 조건을 제거하고 라인 기준으로 함
					   AND A.INSTANCE_TYPE = B.INSTANCE_TYPE
					   AND A.PLAN_DATE >= @FIRST_DATE
					   AND A.PLAN_DATE <= @LAST_DATE
					   AND A.PLAN_TYPE  = 'WPP'
					   AND A.OPERATION_ID IN (SELECT C.OPERATION_ID
											  FROM   @TEMP_TABLE C ) -- 2018-08-06 kimcd 계획 존재하는 공정만 삭제
					   -- 2019-02-25 kimcd 라인 조건 추가 시작
					   AND A.LINE_ID IN ( SELECT DISTINCT LINE_ID
										  FROM   SCM_LINE_M L WITH(NOLOCK)
										  WHERE  L.FACTORY_ID  = B.FACTORY_ID
										  AND    CASE WHEN B.PLAN_GROUP_ID = '-' THEN B.PLAN_GROUP_ID ELSE L.MODEL_TYPE END = B.PLAN_GROUP_ID
										  AND    NOT EXISTS (SELECT 1
															 FROM   SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
															 WHERE  SLV.LOOKUP_TYPE_CODE  = 'INSTANCE_SPLIT_LINE_DEFINITION'
															 AND    SLV.ACTIVE_FLAG       = 'Y'
															 AND    SLV.SEGMENT2          = B.INSTANCE_ID
															 AND    SLV.SEGMENT3          = L.LINE_ID )
										  AND    NOT EXISTS (SELECT 1
															 FROM   SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
															 WHERE  SLV.LOOKUP_TYPE_CODE  = 'INSTANCE_SPLIT_LINE_DEFINITION'
															 AND    SLV.ACTIVE_FLAG       = 'Y'
															 AND    SLV.SEGMENT1          = B.INSTANCE_ID)
										  UNION ALL
										  SELECT SLV.SEGMENT3
										  FROM   SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
										  WHERE  SLV.LOOKUP_TYPE_CODE  = 'INSTANCE_SPLIT_LINE_DEFINITION'
										  AND    SLV.ACTIVE_FLAG       = 'Y'
										  AND    SLV.SEGMENT1          = B.INSTANCE_ID
										  )
						-- 2019-02-25 kimcd 라인 조건 추가 끝

					-- 2020-06-30 kimcd 수요 유형별 우선 순위 설정 임시 Table 시작
					DELETE FROM @CONV_TABLE

					INSERT INTO @CONV_TABLE
					SELECT SEGMENT1 AS INSTANCE_ID, SEGMENT2 AS PLANT_ID, SEGMENT3 AS PRODUCTION_TYPE, VERSION_TYPE
						 , RANK() OVER (PARTITION BY SEGMENT1,SEGMENT2, SEGMENT3 ORDER BY GUBUN) AS IDX
					FROM (	SELECT *
							FROM   SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
							WHERE  1=1
							AND	   LOOKUP_TYPE_CODE	= 'INSTANCE_CONV_PRIORITY'
							AND	   SEGMENT1			=  @INSTANCE_ID -- INSTANCE_ID
							AND    SEGMENT2         =  @PLANT_ID    -- PLANT_ID
							AND    ACTIVE_FLAG		= 'Y'
							) A
					UNPIVOT(VERSION_TYPE FOR GUBUN IN (ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5)) AS X
					-- 2020-06-30 kimcd 수요 유형별 우선 순위 설정 임시 Table 끝

					-- WPP 데이터 생성
					MERGE INTO FP_DAILY_PRODUCTIOIN_PLAN_H DP  -- 2021-08-26 kimcd INSERT에서 Merge로 변경
					USING ( SELECT  A.COMPANY_ID
								   ,A.DIVISION_ID
								   ,A.SITE_ID
								   ,A.PLANT_ID
								   ,A.FACTORY_ID
								   ,A.PLAN_GROUP_ID
								   ,(SELECT TOP 1 INSTANCE_TYPE
									  FROM ( SELECT FF.INSTANCE_TYPE
												  FROM DBO.[FP_INSTANCE_FACTORY_M] FF WITH(NOLOCK)
												 WHERE FF.ACTIVE_FLAG = 'Y'     
												   AND FF.INSTANCE_ID != 'KR_CELL_M_P'
												   AND FF.INSTANCE_ID = @INSTANCE_ID
												UNION ALL
												SELECT FF.INSTANCE_TYPE+'_P' AS INSTANCE_TYPE
												  FROM DBO.[FP_INSTANCE_FACTORY_M] FF WITH(NOLOCK)
												 WHERE FF.ACTIVE_FLAG = 'Y'     
												   AND FF.INSTANCE_ID = 'KR_CELL_M_P'
												   AND FF.INSTANCE_ID = @INSTANCE_ID  ) FF)  INSTANCE_TYPE
								   ,A.TOP_ITEM_ID
								   ,A.ITEM_ID
								   ,A.OPERATION_ID
								   ,ISNULL((SELECT LOCATION 
											  FROM SCM_LINE_M WITH(NOLOCK)
											 WHERE LINE_ID = A.LINE_ID
											   AND OPERATION_ID = A.OPERATION_ID
											   AND FACTORY_ID = A.FACTORY_ID
											   AND ELECTRODE_TYPE = A.ELECTRODE_TYPE), '-') AS LOCATION
								   ,A.PRODUCTION_TYPE
								   ,A.MARKET
								   ,A.LINE_ID
								   ,A.ELECTRODE_TYPE
								   ,A.PLAN_DATE
								   ,A.PLAN_QTY
								   ,A.PLAN_QTY / ISNULL(A.YIELD, 1) AS [PLAN_IN_QTY]
								   ,'PR_SCM_MPP_WPP_ACCUM' AS INSERT_ID
								   ,GETDATE() AS INSERT_TIME
								   ,'PR_SCM_MPP_WPP_ACCUM' AS UPDATE_ID
								   ,GETDATE() AS UPDATE_TIME
								   ,'WPP' AS PLAN_TYPE
								   ,A.EQUIPMENT_ID
								   ,CASE WHEN A.OPERATION_ID = 'E2000' THEN CASE WHEN A.ITEM_UOM = 'EA' THEN A.PLAN_QTY / A.CELL_M ELSE A.PLAN_QTY END / ISNULL(A.YIELD, 1) END                    ROLL_IN_QTY
								   ,CASE WHEN A.OPERATION_ID = 'E2000' THEN CASE WHEN A.ITEM_UOM = 'EA' THEN A.PLAN_QTY / A.CELL_M ELSE A.PLAN_QTY END END                                         ROLL_OUT_QTY
								   ,CASE WHEN A.OPERATION_ID = 'E2000' THEN CASE WHEN A.ITEM_UOM = 'EA' THEN A.PLAN_QTY / A.CELL_M / A.LANE ELSE A.PLAN_QTY / A.LANE END / ISNULL(A.YIELD, 1) END  JR_IN_QTY
								   ,CASE WHEN A.OPERATION_ID = 'E2000' THEN CASE WHEN A.ITEM_UOM = 'EA' THEN A.PLAN_QTY / A.CELL_M / A.LANE ELSE A.PLAN_QTY /A.LANE END END                        JR_OUT_QTY
								   ,CASE WHEN A.OPERATION_ID = 'E2000' THEN CASE WHEN A.ITEM_UOM = 'EA' THEN A.PLAN_QTY / A.CELL_BATCH ELSE A.PLAN_QTY / A.M_BATCH END / ISNULL(A.YIELD, 1) END    BATCH_IN_QTY
								   ,CASE WHEN A.OPERATION_ID = 'E2000' THEN CASE WHEN A.ITEM_UOM = 'EA' THEN A.PLAN_QTY / A.CELL_BATCH ELSE A.PLAN_QTY / A.M_BATCH END END                          BATCH_OUT_QTY
								   ,CASE WHEN A.OPERATION_ID = 'E2000' THEN CASE WHEN A.ITEM_UOM = 'EA' THEN A.PLAN_QTY ELSE A.PLAN_QTY * A.CELL_M END / ISNULL(A.YIELD, 1)
										 WHEN A.OPERATION_ID LIKE 'A%' AND A.CELL_REQ_QTY > 0 THEN  A.PLAN_QTY / A.CELL_REQ_QTY / ISNULL(A.YIELD, 1) END                    CELL_IN_QTY
								   ,CASE WHEN A.OPERATION_ID = 'E2000' THEN CASE WHEN A.ITEM_UOM = 'EA' THEN A.PLAN_QTY ELSE A.PLAN_QTY * A.CELL_M END
										 WHEN A.OPERATION_ID LIKE 'A%' AND A.CELL_REQ_QTY > 0 THEN  A.PLAN_QTY / A.CELL_REQ_QTY END                                         CELL_OUT_QTY
									,A.[WORK_REQUEST_MODEL_ID]
									,A.[VERSION]
									,A.[PROD_SEQ]
									,A.[PLM_EC_NO]  -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
							  FROM (SELECT  A.COMPANY_ID
										   ,A.DIVISION_ID
										   ,A.SITE_ID
										   ,A.PLANT_ID
										   ,A.FACTORY_ID
										   ,@PLAN_GROUP_ID  AS PLAN_GROUP_ID
										   ,ISNULL(SI.APPLIED_MODEL, A.ITEM_ID) AS TOP_ITEM_ID
										   ,A.ITEM_ID
										   ,A.OPERATION_ID
										   ,A.PRODUCTION_TYPE
										   ,A.MARKET
										   ,A.LINE_ID
										   ,SI.ITEM_UOM
										   ,ISNULL(  (  SELECT E.ELECTRODE_TYPE
														FROM   SCM_EQUIPMENT_M E WITH(NOLOCK)
														WHERE  E.COMPANY_ID   = A.COMPANY_ID
														AND    E.DIVISION_ID  = A.DIVISION_ID
														AND    E.SITE_ID      = A.SITE_ID
														AND    E.PLANT_ID     = A.PLANT_ID
														AND    E.FACTORY_ID   = A.FACTORY_ID
														AND    E.EQUIPMENT_ID = A.EQUIPMENT_ID
														AND    E.OPERATION_ID = A.OPERATION_ID ), ISNULL( ( SELECT TOP 1 ILA.ELECTRODE_TYPE
																											FROM   SCM_ITEM_LINE_ASSIGN_M ILA WITH(NOLOCK)
																											WHERE  ILA.COMPANY_ID   = A.COMPANY_ID
																											AND    ILA.DIVISION_ID  = A.DIVISION_ID
																											AND    ILA.SITE_ID      = A.SITE_ID
																											AND    ILA.PLANT_ID     = A.PLANT_ID
																											AND    ILA.FACTORY_ID   = A.FACTORY_ID
																											AND    ILA.ITEM_ID      = A.ITEM_ID
																											AND    ILA.OPERATION_ID = A.OPERATION_ID
																											AND    ILA.LINE_ID      = A.LINE_ID
																											AND    ILA.MONTH >= CONVERT( NVARCHAR(6), @FIRST_DATE, 112)) ,'-' ) ) AS ELECTRODE_TYPE -- 2018-08-06 kimcd LINE ASSIGN 조회문장 추가
										   ,A.PLAN_DATE
										   ,A.PLAN_QTY
										   ,A.EQUIPMENT_ID
		/*
											--2018-11-21 PIYONG 주석 처리

										   ,CASE WHEN A.OPERATION_ID = 'E2000' THEN
											   (SELECT MAX(VALUE) AS LANE
												FROM   SCM_ITEM_CONV_CALC_M C WITH(NOLOCK)
												WHERE  C.MAX_VER_FLAG = 'Y'
												AND    ISNULL(C.VALUE, 0) > 0
												AND    C.CATEGORY     = 'Lane Number'
												AND    C.COMPANY_ID   = A.COMPANY_ID
												AND    C.DIVISION_ID  = A.DIVISION_ID
												AND    C.SITE_ID      = A.SITE_ID
												AND    C.PLANT_ID     = A.PLANT_ID
												AND    C.FACTORY_ID   = A.FACTORY_ID
												AND    C.OPERATION    = A.OPERATION_ID
												AND    C.ITEM_ID      = A.ITEM_ID)
											END AS LANE
										   ,CASE WHEN A.OPERATION_ID = 'E2000' AND SI.ITEM_UOM = 'M' THEN
												  ( SELECT MAX(VALUE) AS M_BATCH
													FROM   SCM_ITEM_CONV_CALC_M C WITH(NOLOCK)
													WHERE  C.MAX_VER_FLAG = 'Y'
													AND    ISNULL(C.VALUE, 0) > 0
													AND    C.CATEGORY    IN ('m/batch','Pancake (m/batch)')
													AND    C.COMPANY_ID   = A.COMPANY_ID
													AND    C.DIVISION_ID  = A.DIVISION_ID
													AND    C.SITE_ID      = A.SITE_ID
													AND    C.PLANT_ID     = A.PLANT_ID
													AND    C.FACTORY_ID   = A.FACTORY_ID
													AND    C.OPERATION    = A.OPERATION_ID
													AND    C.ITEM_ID      = A.ITEM_ID)
											 END  AS M_BATCH
											,CASE WHEN A.OPERATION_ID = 'E2000' AND SI.ITEM_UOM = 'EA' THEN
												  ( SELECT MAX(VALUE) AS CELL_BATCH
													FROM   SCM_ITEM_CONV_CALC_M C WITH(NOLOCK)
													WHERE  C.MAX_VER_FLAG = 'Y'
													AND    ISNULL(C.VALUE, 0) > 0
													AND    C.CATEGORY     = 'cell/batch'
													AND    C.COMPANY_ID   = A.COMPANY_ID
													AND    C.DIVISION_ID  = A.DIVISION_ID
													AND    C.SITE_ID      = A.SITE_ID
													AND    C.PLANT_ID     = A.PLANT_ID
													AND    C.FACTORY_ID   = A.FACTORY_ID
													AND    C.OPERATION    = A.OPERATION_ID
													AND    C.ITEM_ID      = A.ITEM_ID)
											 END  AS CELL_BATCH
											,CASE WHEN A.OPERATION_ID = 'E2000' THEN
												( SELECT MAX(VALUE) AS CELL_M
												  FROM   SCM_ITEM_CONV_CALC_M C WITH(NOLOCK)
												  WHERE  C.MAX_VER_FLAG = 'Y'
												  AND    ISNULL(C.VALUE, 0) > 0
												  AND    C.CATEGORY     = 'Pancake (cell/m)'
												  AND    C.COMPANY_ID   = A.COMPANY_ID
												  AND    C.DIVISION_ID  = A.DIVISION_ID
												  AND    C.SITE_ID      = A.SITE_ID
												  AND    C.PLANT_ID     = A.PLANT_ID
												  AND    C.FACTORY_ID   = A.FACTORY_ID
												  AND    C.OPERATION    = A.OPERATION_ID
												  AND    C.ITEM_ID      = A.ITEM_ID)
											END  AS CELL_M

		*/
											,CASE WHEN A.OPERATION_ID = 'E2000' THEN
															(
															   SELECT TOP 1 VALUE AS LANE
																FROM   SCM_ITEM_CONV_CALC_M C WITH(NOLOCK),
																	   @CONV_TABLE          CT -- 2020-06-30 kimcd 환산자 사용 우선 순위 적용
																WHERE  C.MAX_VER_FLAG = 'Y'
																AND    ISNULL(C.VALUE, 0) > 0
																AND    C.CATEGORY     = 'Lane Number'
																AND    C.COMPANY_ID   = A.COMPANY_ID
																AND    C.DIVISION_ID  = A.DIVISION_ID
																AND    C.SITE_ID      = A.SITE_ID
																AND    C.PLANT_ID     = A.PLANT_ID
																AND    C.FACTORY_ID   = A.FACTORY_ID
																AND    C.OPERATION    = A.OPERATION_ID
																AND    C.ITEM_ID      = A.ITEM_ID
																-----------------------------------------------
																--2018-11-21 PIYONG ADD
																AND	   C.PROD_VERSION_TYPE = L.PROD_VERSION_TYPE
															--	AND    C.MODEL_ID	  = SI.APPLIED_MODEL	--2018-12-07 PIYONG DEL
																AND    A.PRODUCTION_TYPE = CT.PRODUCTION_TYPE -- 2020-06-30 kimcd 환산자 사용 우선 순위 적용
																ORDER BY CASE WHEN C.VERSION_TYPE = CT.VERSION_TYPE THEN IDX ELSE 999 END -- 2020-06-30 kimcd 환산자 사용 우선 순위 적용
																		 ,C.APPLY_DATE DESC -- 2020-06-30 kimcd 적용일 우선 순위
																---------------------------------------------------------------------------------------------
																-- 2018-12-07 PIYONG ADD
																		 ,(CASE WHEN C.MODEL_ID	  = SI.APPLIED_MODEL THEN 1 ELSE 2 END)
																		 ,C.MODEL_ID
																		 ,( CASE WHEN C.VERSION  LIKE 'Z%' THEN REPLACE(C.VERSION, 'Z', '/') ELSE C.VERSION END ) DESC
																-- 2018-12-07 PIYONG ADD 끝
																---------------------------------------------------------------------------------------------
															)
											END AS LANE
										   ,CASE WHEN A.OPERATION_ID = 'E2000' AND SI.ITEM_UOM = 'M' THEN
															  (
																SELECT TOP 1 VALUE AS M_BATCH
																FROM   SCM_ITEM_CONV_CALC_M C WITH(NOLOCK),
																	   @CONV_TABLE          CT -- 2020-06-30 kimcd 환산자 사용 우선 순위 적용
																WHERE  C.MAX_VER_FLAG = 'Y'
																AND    ISNULL(C.VALUE, 0) > 0
																AND    C.CATEGORY     = 'Pancake (m/batch)'
																AND    C.COMPANY_ID   = A.COMPANY_ID
																AND    C.DIVISION_ID  = A.DIVISION_ID
																AND    C.SITE_ID      = A.SITE_ID
																AND    C.PLANT_ID     = A.PLANT_ID
																AND    C.FACTORY_ID   = A.FACTORY_ID
																AND    C.OPERATION    = A.OPERATION_ID
																AND    C.ITEM_ID      = A.ITEM_ID
																-----------------------------------------------
																--2018-11-21 PIYONG ADD
																AND	   C.PROD_VERSION_TYPE = L.PROD_VERSION_TYPE
															--	AND    C.MODEL_ID	  = SI.APPLIED_MODEL	--2018-12-07 PIYONG DEL
																AND    A.PRODUCTION_TYPE = CT.PRODUCTION_TYPE -- 2020-06-30 kimcd 환산자 사용 우선 순위 적용
																ORDER BY CASE WHEN C.VERSION_TYPE = CT.VERSION_TYPE THEN IDX ELSE 999 END -- 2020-06-30 kimcd 환산자 사용 우선 순위 적용
																		 ,C.APPLY_DATE DESC -- 2020-06-30 kimcd 적용일 우선 순위
																---------------------------------------------------------------------------------------------
																-- 2018-12-07 PIYONG ADD
																		 ,(CASE WHEN C.MODEL_ID	  = SI.APPLIED_MODEL THEN 1 ELSE 2 END)
																		 ,C.MODEL_ID
																		 ,( CASE WHEN C.VERSION  LIKE 'Z%' THEN REPLACE(C.VERSION, 'Z', '/') ELSE C.VERSION END ) DESC
																-- 2018-12-07 PIYONG ADD 끝
																---------------------------------------------------------------------------------------------
															)
											 END  AS M_BATCH
											,CASE WHEN A.OPERATION_ID = 'E2000' AND SI.ITEM_UOM = 'EA' THEN
														 (
															SELECT TOP 1 VALUE	AS CELL_BATCH
															FROM   SCM_ITEM_CONV_CALC_M C WITH(NOLOCK),
																   @CONV_TABLE          CT -- 2020-06-30 kimcd 환산자 사용 우선 순위 적용
															WHERE  C.MAX_VER_FLAG = 'Y'
															AND    ISNULL(C.VALUE, 0) > 0
															AND    C.CATEGORY     = 'cell/batch'
															AND    C.COMPANY_ID   = A.COMPANY_ID
															AND    C.DIVISION_ID  = A.DIVISION_ID
															AND    C.SITE_ID      = A.SITE_ID
															AND    C.PLANT_ID     = A.PLANT_ID
															AND    C.FACTORY_ID   = A.FACTORY_ID
															AND    C.OPERATION    = A.OPERATION_ID
															AND    C.ITEM_ID      = A.ITEM_ID
															-----------------------------------------------
															--2018-11-21 PIYONG ADD
															AND    C.PROD_VERSION_TYPE = L.PROD_VERSION_TYPE
														--	AND    C.MODEL_ID	  = SI.APPLIED_MODEL	--2018-12-07 PIYONG DEL
															AND    A.PRODUCTION_TYPE = CT.PRODUCTION_TYPE -- 2020-06-30 kimcd 환산자 사용 우선 순위 적용
															ORDER BY CASE WHEN C.VERSION_TYPE = CT.VERSION_TYPE THEN IDX ELSE 999 END -- 2020-06-30 kimcd 환산자 사용 우선 순위 적용
																	 ,C.APPLY_DATE DESC -- 2020-06-30 kimcd 적용일 우선 순위
															---------------------------------------------------------------------------------------------
															-- 2018-12-07 PIYONG ADD
																	 ,(CASE WHEN C.MODEL_ID	  = SI.APPLIED_MODEL THEN 1 ELSE 2 END)
																	 ,C.MODEL_ID
																	 ,( CASE WHEN C.VERSION  LIKE 'Z%' THEN REPLACE(C.VERSION, 'Z', '/') ELSE C.VERSION END ) DESC
															-- 2018-12-07 PIYONG ADD 끝
															---------------------------------------------------------------------------------------------
														)
											 END  AS CELL_BATCH
											,CASE WHEN A.OPERATION_ID = 'E2000' THEN
														( 
															SELECT TOP 1 VALUE AS CELL_M
															FROM   SCM_ITEM_CONV_CALC_M C WITH(NOLOCK),
																   @CONV_TABLE          CT -- 2020-06-30 kimcd 환산자 사용 우선 순위 적용
															WHERE  C.MAX_VER_FLAG = 'Y'
															AND    ISNULL(C.VALUE, 0) > 0
															AND    C.CATEGORY     = 'Pancake (cell/m)'
															AND    C.COMPANY_ID   = A.COMPANY_ID
															AND    C.DIVISION_ID  = A.DIVISION_ID
															AND    C.SITE_ID      = A.SITE_ID
															AND    C.PLANT_ID     = A.PLANT_ID
															AND    C.FACTORY_ID   = A.FACTORY_ID
															AND    C.OPERATION    = A.OPERATION_ID
															AND    C.ITEM_ID      = A.ITEM_ID
															-----------------------------------------------
															--2018-11-21 PIYONG ADD
															AND	   C.PROD_VERSION_TYPE = L.PROD_VERSION_TYPE
														--	AND    C.MODEL_ID	  = SI.APPLIED_MODEL	--2018-12-07 PIYONG DEL
															AND    A.PRODUCTION_TYPE = CT.PRODUCTION_TYPE -- 2020-06-30 kimcd 환산자 사용 우선 순위 적용
															ORDER BY CASE WHEN C.VERSION_TYPE = CT.VERSION_TYPE THEN IDX ELSE 999 END -- 2020-06-30 kimcd 환산자 사용 우선 순위 적용
																	 ,C.APPLY_DATE DESC -- 2020-06-30 kimcd 적용일 우선 순위
															---------------------------------------------------------------------------------------------
															-- 2018-12-07 PIYONG ADD
																	 ,(CASE WHEN C.MODEL_ID	  = SI.APPLIED_MODEL THEN 1 ELSE 2 END)
																	 ,C.MODEL_ID
																	 ,( CASE WHEN C.VERSION  LIKE 'Z%' THEN REPLACE(C.VERSION, 'Z', '/') ELSE C.VERSION END ) DESC
															-- 2018-12-07 PIYONG ADD 끝
															---------------------------------------------------------------------------------------------
														)
											END  AS CELL_M
											,(  SELECT TOP 1 SY.YIELD
												FROM   SCM_YIELD_M  SY WITH(NOLOCK)
												WHERE  SY.[COMPANY_ID]   = A.[COMPANY_ID]
												AND    SY.[DIVISION_ID]  = A.[DIVISION_ID]
												AND    SY.[SITE_ID]      = A.[SITE_ID]
												AND    SY.[PLANT_ID]     = A.[PLANT_ID]
												AND    SY.[FACTORY_ID]   = A.[FACTORY_ID]
												AND    SY.[OPERATION_ID] = A.[OPERATION_ID]
												AND    SY.[LINE_ID]      = A.[LINE_ID]
												AND    SY.[ITEM_ID]      = A.[ITEM_ID]
												AND    SY.[MONTH]        = CONVERT(NVARCHAR(6), [dbo].[FN_SITE_TIME] (A.SITE_ID), 112)
												AND    SY.[YIELD]        > 0
												AND    SY.[YIELD]       <= 1 )  AS YIELD
											,CASE WHEN A.OPERATION_ID LIKE 'A%' THEN
												(SELECT TOP 1 SUM(MCT.ACCUMULATED_CHILD_QTY)
												 FROM   SCM_MODEL_COMP_TEMP MCT WITH(NOLOCK)
												 WHERE  MCT.[COMPANY_ID]    = A.[COMPANY_ID]
												 AND    MCT.[DIVISION_ID]   = A.[DIVISION_ID]
												 AND    MCT.[SITE_ID]       = A.[SITE_ID]
												 AND    MCT.[PLANT_ID]      = A.[PLANT_ID]
												 AND    MCT.[CHILD_ITEM_ID] = A.[ITEM_ID]
												 AND    EXISTS (SELECT TOP 1 1
																FROM SCM_ITEM_M  M WITH(NOLOCK)
																WHERE  M.COMPANY_ID  = MCT.COMPANY_ID
																AND    M.DIVISION_ID = MCT.DIVISION_ID
																AND    M.SITE_ID     = MCT.SITE_ID
																AND    M.ITEM_ID     = MCT.MODEL_ID
																AND    M.FLOW_ID LIKE 'A%') -- 2018-05-15 kimcd Cell 공정 모델만으로 제한
												 GROUP  BY [MODEL_ID]
												 ORDER  BY CASE WHEN MCT.MODEL_ID = SI.APPLIED_MODEL THEN 1 ELSE 2 END, -- 2018-12-11 kimcd 적용 모델 우선
														   1 DESC )
											END  AS CELL_REQ_QTY
											,A.[WORK_REQUEST_MODEL_ID]
											,A.[VERSION]
											,A.[PROD_SEQ]
											,A.[PLM_EC_NO]  -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
									FROM   [dbo].[FP_MPP_WPP_BASE_PLAN_M] A   WITH(NOLOCK)
											-----------------------------------------------
											--2018-11-21 PIYONG ADD
										   LEFT OUTER JOIN [dbo].[SCM_LINE_M]			  L   WITH(NOLOCK)	--2018-11-21 PIYONG ADD 
														ON	   L.OPERATION_ID = 'E2000'
														AND    L.ACTIVE_FLAG    = 'Y'
														AND	   A.COMPANY_ID	    = L.COMPANY_ID
														AND	   A.DIVISION_ID	= L.DIVISION_ID
														AND    A.SITE_ID		= L.SITE_ID
														AND    A.PLANT_ID		= L.PLANT_ID
														AND    A.FACTORY_ID 	= L.FACTORY_ID
														AND    A.OPERATION_ID	= L.OPERATION_ID
														AND    A.LINE_ID		= L.LINE_ID
											--2018-11-21 PIYONG ADD END
											-----------------------------------------------			
										   ,[dbo].[SCM_ITEM_M]            SI  WITH(NOLOCK)
									WHERE  SI.COMPANY_ID   = A.COMPANY_ID
									AND    SI.SITE_ID      = A.SITE_ID
									AND    SI.DIVISION_ID  = A.DIVISION_ID
									AND    SI.ITEM_ID      = A.ITEM_ID
									AND    A.PLAN_WEEK     = @P_PLAN_WEEK
									AND    A.PLAN_REVISION = @P_PLAN_REVISION
									AND    A.PLAN_DATE    >= @FIRST_DATE
									AND    A.PLAN_DATE    <= @LAST_DATE
							 ) A ) B
							ON (DP.[FACTORY_ID]    = B.[FACTORY_ID]
							AND DP.[INSTANCE_TYPE] = B.[INSTANCE_TYPE]
							AND DP.[PLAN_TYPE]     = B.[PLAN_TYPE]
							AND DP.[ITEM_ID]       = B.[ITEM_ID]
							AND DP.[LINE_ID]       = B.[LINE_ID]
							AND DP.[PLAN_DATE]     = B.[PLAN_DATE]
							AND DP.[TOP_ITEM_ID]   = B.[TOP_ITEM_ID]
							AND DP.[OPERATION_ID]  = B.[OPERATION_ID]
							AND DP.[FP_PRODUCTION_TYPE] = B.[PRODUCTION_TYPE]
							AND DP.[MARKET]        = B.[MARKET]
							AND DP.[WORK_REQUEST_MODEL_ID] = B.[WORK_REQUEST_MODEL_ID]
							AND	DP.[VERSION]			= B.[VERSION]
							AND	DP.[PROD_SEQ]			= B.[PROD_SEQ]
							AND	DP.[PLM_EC_NO]			= B.[PLM_EC_NO]  -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
							--AND DP.[ELECTRODE_TYPE]= B.[ELECTRODE_TYPE]
							AND DP.[EQUIPMENT_ID]  = B.[EQUIPMENT_ID] )
						WHEN MATCHED THEN
							UPDATE SET   DP.[PLAN_GROUP_ID] = B.[PLAN_GROUP_ID]
										,DP.[PRODUCTION_TYPE] = B.[PRODUCTION_TYPE]
										,DP.[ELECTRODE_TYPE]= B.[ELECTRODE_TYPE] -- 2021-09-17 kimcd ON 조건에서 제거하고 갱신
										,DP.[PLAN_QTY]      = B.[PLAN_QTY]
										,DP.[PLAN_IN_QTY]   = B.[PLAN_IN_QTY]
										,DP.[UPDATE_ID]     = B.[UPDATE_ID]
										,DP.[UPDATE_TIME]   = B.[UPDATE_TIME]
										,DP.[ROLL_IN_QTY]   = B.[ROLL_IN_QTY]
										,DP.[ROLL_OUT_QTY]  = B.[ROLL_OUT_QTY]
										,DP.[JR_IN_QTY]     = B.[JR_IN_QTY]
										,DP.[JR_OUT_QTY]    = B.[JR_OUT_QTY]
										,DP.[BATCH_IN_QTY]  = B.[BATCH_IN_QTY]
										,DP.[BATCH_OUT_QTY] = B.[BATCH_OUT_QTY]
										,DP.[CELL_IN_QTY]   = B.[CELL_IN_QTY]
										,DP.[CELL_OUT_QTY]  = B.[CELL_OUT_QTY]
										,DP.[LOCATION]      = B.[LOCATION]  -- 2022-06-09 kimcd LOCATION 갱신 문장 추가
						WHEN NOT MATCHED THEN
							INSERT ( [COMPANY_ID]
									,[DIVISION_ID]
									,[SITE_ID]
									,[PLANT_ID]
									,[FACTORY_ID]
									,[PLAN_GROUP_ID]
									,[INSTANCE_TYPE]
									,[TOP_ITEM_ID]
									,[ITEM_ID]
									,[OPERATION_ID]
									,[LOCATION]
									,[PRODUCTION_TYPE]
									,[MARKET]
									,[LINE_ID]
									,[ELECTRODE_TYPE]
									,[PLAN_DATE]
									,[PLAN_QTY]
									,[PLAN_IN_QTY]
									,[INSERT_ID]
									,[INSERT_TIME]
									,[UPDATE_ID]
									,[UPDATE_TIME]
									,[PLAN_TYPE]
									,[EQUIPMENT_ID]
									,[FP_PRODUCTION_TYPE]
									,[ROLL_IN_QTY]
									,[ROLL_OUT_QTY]
									,[JR_IN_QTY]
									,[JR_OUT_QTY]
									,[BATCH_IN_QTY]
									,[BATCH_OUT_QTY]
									,[CELL_IN_QTY]
									,[CELL_OUT_QTY]
									,[WORK_REQUEST_MODEL_ID]
									,[VERSION]
									,[PROD_SEQ]
									,[PLM_EC_NO]  -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
									)
							VALUES ( B.[COMPANY_ID]
									,B.[DIVISION_ID]
									,B.[SITE_ID]
									,B.[PLANT_ID]
									,B.[FACTORY_ID]
									,B.[PLAN_GROUP_ID]
									,B.[INSTANCE_TYPE]
									,B.[TOP_ITEM_ID]
									,B.[ITEM_ID]
									,B.[OPERATION_ID]
									,B.[LOCATION]
									,B.[PRODUCTION_TYPE]
									,B.[MARKET]
									,B.[LINE_ID]
									,B.[ELECTRODE_TYPE]
									,B.[PLAN_DATE]
									,B.[PLAN_QTY]
									,B.[PLAN_IN_QTY]
									,B.[INSERT_ID]
									,B.[INSERT_TIME]
									,B.[UPDATE_ID]
									,B.[UPDATE_TIME]
									,B.[PLAN_TYPE]
									,B.[EQUIPMENT_ID]
									,B.[PRODUCTION_TYPE]
									,B.[ROLL_IN_QTY]
									,B.[ROLL_OUT_QTY]
									,B.[JR_IN_QTY]
									,B.[JR_OUT_QTY]
									,B.[BATCH_IN_QTY]
									,B.[BATCH_OUT_QTY]
									,B.[CELL_IN_QTY]
									,B.[CELL_OUT_QTY]
									,B.[WORK_REQUEST_MODEL_ID]
									,B.[VERSION]
									,B.[PROD_SEQ]
									,B.[PLM_EC_NO]  -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
									);

				END


			IF @MPP_FLAG = 'Y'
				BEGIN
					SELECT  @FIRST_DATE = CONVERT(DATE, @PLAN_MONTH+'01', 112)
					--SELECT TOP 1 @FIRST_DATE = A.PLAN_DATE
					--FROM   [DBO].[FP_MPP_WPP_BASE_PLAN_M] A WITH(NOLOCK)
					--WHERE  A.PLAN_WEEK     = @P_PLAN_WEEK
					--AND    A.PLAN_REVISION = @P_PLAN_REVISION
					--ORDER  BY A.PLAN_DATE

					SELECT @LAST_DATE = DATEADD(D, -1, DATEADD( M, 1, @FIRST_DATE))

					-- 2018-08-06 kimcd SELECT  @LAST_DATE = CASE WHEN @LAST_DATE >= CONVERT(DATE, [dbo].[FN_SITE_TIME] (@SITE_ID), 112) THEN DATEADD(D,365,@LAST_DATE) ELSE @LAST_DATE END

					-- 2018-08-06 kimcd logic 추가 시작
					IF @LAST_DATE >= CONVERT(DATE, [dbo].[FN_SITE_TIME] (@SITE_ID), 112)
						BEGIN
							SELECT TOP 1 @LAST_DATE = DATEADD(D, -1, DATEADD( M, 1, CONVERT(DATE, SSC.YEAR+SSC.MONTH+'01', 112)))
							FROM   DBO.SCM_SYS_CALENDAR_M     SSC WITH(NOLOCK)
								 , DBO.FP_MPP_WPP_BASE_PLAN_M A   WITH(NOLOCK)
							WHERE  SSC.DATE_ID     = A.PLAN_DATE
							AND    A.PLAN_WEEK     = @P_PLAN_WEEK
							AND    A.PLAN_REVISION = @P_PLAN_REVISION
							ORDER  BY SSC.WEEKEND_DATE DESC
						END;

					-- 삭제해야 할 공정 범위 찾기
					DELETE @TEMP_TABLE

					INSERT INTO @TEMP_TABLE
					SELECT DISTINCT OPERATION_ID
					FROM   DBO.FP_MPP_WPP_BASE_PLAN_M A   WITH(NOLOCK)
					WHERE  A.PLAN_WEEK     = @P_PLAN_WEEK
					AND    A.PLAN_REVISION = @P_PLAN_REVISION
					-- 2018-08-06 kimcd logic 추가 종료

					-- WPP 기존 생성된 데이터 삭제
					-- DELETE A 2021-08-26 kimcd 삭제에서 수량 갱신으로 변경
					UPDATE A
					SET  [PLAN_QTY]      = 0
						,[PLAN_IN_QTY]   = 0
						,[UPDATE_ID]     = 'PR_SCM_MPP_WPP_ACCUM'
						,[UPDATE_TIME]   = GETDATE()
						,[ROLL_IN_QTY]   = 0
						,[ROLL_OUT_QTY]  = 0
						,[JR_IN_QTY]     = 0
						,[JR_OUT_QTY]    = 0
						,[BATCH_IN_QTY]  = 0
						,[BATCH_OUT_QTY] = 0
						,[CELL_IN_QTY]   = 0
						,[CELL_OUT_QTY]  = 0
					  FROM FP_DAILY_PRODUCTIOIN_PLAN_H A -- WITH(NOLOCK) 2018-05-15 kimcd lock waiting 함
						   ,( SELECT  B.PLAN_GROUP_ID
									 ,B.INSTANCE_TYPE
									 ,B.FACTORY_ID
									 ,B.INSTANCE_ID  -- 2019-02-25 kimcd 라인 정보 추출을 위해 구분자 추가
								FROM  ( SELECT A.[INSTANCE_ID]
												,INSTANCE_TYPE
												,B.SITE_ID
												,B.FACTORY_ID
												,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE B.FACTORY_ID END  AS LINK_FACTORY_ID
												,ISNULL(MP.SEGMENT2,'-')  AS PLAN_GROUP_ID
										   FROM DBO.[FP_INSTANCE_FACTORY_M] A WITH(NOLOCK)     
												,DBO.SCM_FACTORY_M B WITH(NOLOCK)
												,SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
												LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE MP WITH(NOLOCK)
															 ON MP.LOOKUP_TYPE_CODE  = 'INSTANCE_PLANNING_GROUP'
															AND MP.SEGMENT1 = SLV.SEGMENT1
															AND SLV.ATTRIBUTE1 = 'PLAN GROUP'
										  WHERE A.FACTORY_ID  = B.FACTORY_ID     
											AND A.ACTIVE_FLAG = 'Y'     
											AND A.ACTIVE_FLAG = B.ACTIVE_FLAG     
											AND A.INSTANCE_ID != 'KR_CELL_M_P'
											AND SLV.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
											AND SLV.SEGMENT1  = A.INSTANCE_ID
											AND A.INSTANCE_ID = @INSTANCE_ID
										UNION ALL
										 SELECT A.[INSTANCE_ID]  AS INSTANCE_ID
												,INSTANCE_TYPE+'_P' AS INSTANCE_TYPE
												,B.SITE_ID
												,B.FACTORY_ID
												,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE B.FACTORY_ID END  AS LINK_FACTORY_ID
												,ISNULL(MP.SEGMENT2,'-')  AS PLAN_GROUP_ID
										   FROM DBO.[FP_INSTANCE_FACTORY_M] A WITH(NOLOCK)     
												,DBO.SCM_FACTORY_M B WITH(NOLOCK)
												,SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
												LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE MP WITH(NOLOCK)
															 ON MP.LOOKUP_TYPE_CODE  = 'INSTANCE_PLANNING_GROUP'
															AND MP.SEGMENT1 = SLV.SEGMENT1
															AND SLV.ATTRIBUTE1 = 'PLAN GROUP'
										  WHERE A.FACTORY_ID  = B.FACTORY_ID     
											AND A.ACTIVE_FLAG = 'Y'     
											AND A.ACTIVE_FLAG = B.ACTIVE_FLAG     
											AND A.INSTANCE_ID = 'KR_CELL_M_P'
											AND SLV.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
											AND SLV.SEGMENT1  = A.INSTANCE_ID
											AND A.INSTANCE_ID = @INSTANCE_ID
									 ) B      
							   WHERE B.LINK_FACTORY_ID = @FACTORY_ID
								 AND B.PLAN_GROUP_ID   = @PLAN_GROUP_ID
						   ) B
					 WHERE A.FACTORY_ID = B.FACTORY_ID
					   -- AND A.PLAN_GROUP_ID = B.PLAN_GROUP_ID 2019-02-25 kimcd PLAN GROUP ID 조건을 제거하고 라인 기준으로 함
					   AND A.INSTANCE_TYPE = B.INSTANCE_TYPE
					   AND A.PLAN_DATE >= @FIRST_DATE
					   AND A.PLAN_DATE <= @LAST_DATE
					   AND A.PLAN_TYPE  = 'MPP'
					   AND A.OPERATION_ID IN (SELECT C.OPERATION_ID
											  FROM   @TEMP_TABLE C ) -- 2018-08-06 kimcd 계획 존재하는 공정만 삭제
					   -- 2019-02-25 kimcd 라인 조건 추가 시작
					   AND A.LINE_ID IN ( SELECT DISTINCT LINE_ID
										  FROM   SCM_LINE_M L WITH(NOLOCK)
										  WHERE  L.FACTORY_ID  = B.FACTORY_ID
										  AND    CASE WHEN B.PLAN_GROUP_ID = '-' THEN B.PLAN_GROUP_ID ELSE L.MODEL_TYPE END = B.PLAN_GROUP_ID
										  AND    NOT EXISTS (SELECT 1
															 FROM   SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
															 WHERE  SLV.LOOKUP_TYPE_CODE  = 'INSTANCE_SPLIT_LINE_DEFINITION'
															 AND    SLV.ACTIVE_FLAG       = 'Y'
															 AND    SLV.SEGMENT2          = B.INSTANCE_ID
															 AND    SLV.SEGMENT3          = L.LINE_ID )
										  AND    NOT EXISTS (SELECT 1
															 FROM   SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
															 WHERE  SLV.LOOKUP_TYPE_CODE  = 'INSTANCE_SPLIT_LINE_DEFINITION'
															 AND    SLV.ACTIVE_FLAG       = 'Y'
															 AND    SLV.SEGMENT1          = B.INSTANCE_ID)
										  UNION ALL
										  SELECT SLV.SEGMENT3
										  FROM   SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
										  WHERE  SLV.LOOKUP_TYPE_CODE  = 'INSTANCE_SPLIT_LINE_DEFINITION'
										  AND    SLV.ACTIVE_FLAG       = 'Y'
										  AND    SLV.SEGMENT1          = B.INSTANCE_ID
										  )
						-- 2019-02-25 kimcd 라인 조건 추가 끝

					-- 2020-06-30 kimcd 수요 유형별 우선 순위 설정 임시 Table 시작
					DELETE FROM @CONV_TABLE

					INSERT INTO @CONV_TABLE
					SELECT SEGMENT1 AS INSTANCE_ID, SEGMENT2 AS PLANT_ID, SEGMENT3 AS PRODUCTION_TYPE, VERSION_TYPE
						 , RANK() OVER (PARTITION BY SEGMENT1,SEGMENT2, SEGMENT3 ORDER BY GUBUN) AS IDX
					FROM (	SELECT *
							FROM   SCM_SYS_LOOKUP_VALUE
							WHERE  1=1
							AND	   LOOKUP_TYPE_CODE	= 'INSTANCE_CONV_PRIORITY'
							AND	   SEGMENT1			=  @INSTANCE_ID -- INSTANCE_ID
							AND    SEGMENT2         =  @PLANT_ID    -- PLANT_ID
							AND    ACTIVE_FLAG		= 'Y'
							) A
					UNPIVOT(VERSION_TYPE FOR GUBUN IN (ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5)) AS X
					-- 2020-06-30 kimcd 수요 유형별 우선 순위 설정 임시 Table 끝

					-- MPP 데이터 생성
					MERGE INTO FP_DAILY_PRODUCTIOIN_PLAN_H DP  -- 2021-08-26 kimcd INSERT에서 Merge로 변경
					USING ( SELECT  A.COMPANY_ID
								   ,A.DIVISION_ID
								   ,A.SITE_ID
								   ,A.PLANT_ID
								   ,A.FACTORY_ID
								   ,A.PLAN_GROUP_ID
								   ,(SELECT TOP 1 INSTANCE_TYPE
									  FROM ( SELECT FF.INSTANCE_TYPE
												  FROM DBO.[FP_INSTANCE_FACTORY_M] FF WITH(NOLOCK)
												 WHERE FF.ACTIVE_FLAG = 'Y'     
												   AND FF.INSTANCE_ID != 'KR_CELL_M_P'
												   AND FF.INSTANCE_ID = @INSTANCE_ID
												UNION ALL
												SELECT FF.INSTANCE_TYPE+'_P' AS INSTANCE_TYPE
												  FROM DBO.[FP_INSTANCE_FACTORY_M] FF WITH(NOLOCK)
												 WHERE FF.ACTIVE_FLAG = 'Y'     
												   AND FF.INSTANCE_ID = 'KR_CELL_M_P'
												   AND FF.INSTANCE_ID = @INSTANCE_ID  ) FF)  INSTANCE_TYPE
								   ,A.TOP_ITEM_ID
								   ,A.ITEM_ID
								   ,A.OPERATION_ID
								   ,ISNULL((SELECT LOCATION 
											  FROM SCM_LINE_M WITH(NOLOCK)
											 WHERE LINE_ID = A.LINE_ID
											   AND OPERATION_ID = A.OPERATION_ID
											   AND FACTORY_ID = A.FACTORY_ID
											   AND ELECTRODE_TYPE = A.ELECTRODE_TYPE), '-') AS LOCATION
								   ,A.PRODUCTION_TYPE
								   ,A.MARKET
								   ,A.LINE_ID
								   ,A.ELECTRODE_TYPE
								   ,A.PLAN_DATE
								   ,A.PLAN_QTY
								   ,A.PLAN_QTY / ISNULL(A.YIELD, 1) AS [PLAN_IN_QTY]
								   ,'PR_SCM_MPP_WPP_ACCUM' AS INSERT_ID
								   ,GETDATE() AS INSERT_TIME
								   ,'PR_SCM_MPP_WPP_ACCUM' AS UPDATE_ID
								   ,GETDATE() AS UPDATE_TIME
								   ,'MPP' AS PLAN_TYPE
								   ,A.EQUIPMENT_ID
								   ,CASE WHEN A.OPERATION_ID = 'E2000' THEN CASE WHEN A.ITEM_UOM = 'EA' THEN A.PLAN_QTY / A.CELL_M ELSE A.PLAN_QTY END / ISNULL(A.YIELD, 1) END                    ROLL_IN_QTY
								   ,CASE WHEN A.OPERATION_ID = 'E2000' THEN CASE WHEN A.ITEM_UOM = 'EA' THEN A.PLAN_QTY / A.CELL_M ELSE A.PLAN_QTY END END                                         ROLL_OUT_QTY
								   ,CASE WHEN A.OPERATION_ID = 'E2000' THEN CASE WHEN A.ITEM_UOM = 'EA' THEN A.PLAN_QTY / A.CELL_M / A.LANE ELSE A.PLAN_QTY / A.LANE END / ISNULL(A.YIELD, 1) END  JR_IN_QTY
								   ,CASE WHEN A.OPERATION_ID = 'E2000' THEN CASE WHEN A.ITEM_UOM = 'EA' THEN A.PLAN_QTY / A.CELL_M / A.LANE ELSE A.PLAN_QTY /A.LANE END END                        JR_OUT_QTY
								   ,CASE WHEN A.OPERATION_ID = 'E2000' THEN CASE WHEN A.ITEM_UOM = 'EA' THEN A.PLAN_QTY / A.CELL_BATCH ELSE A.PLAN_QTY / A.M_BATCH END / ISNULL(A.YIELD, 1) END    BATCH_IN_QTY
								   ,CASE WHEN A.OPERATION_ID = 'E2000' THEN CASE WHEN A.ITEM_UOM = 'EA' THEN A.PLAN_QTY / A.CELL_BATCH ELSE A.PLAN_QTY / A.M_BATCH END END                          BATCH_OUT_QTY
								   ,CASE WHEN A.OPERATION_ID = 'E2000' THEN CASE WHEN A.ITEM_UOM = 'EA' THEN A.PLAN_QTY ELSE A.PLAN_QTY * A.CELL_M END / ISNULL(A.YIELD, 1)
										 WHEN A.OPERATION_ID LIKE 'A%' AND A.CELL_REQ_QTY > 0 THEN  A.PLAN_QTY / A.CELL_REQ_QTY / ISNULL(A.YIELD, 1) END                    CELL_IN_QTY
								   ,CASE WHEN A.OPERATION_ID = 'E2000' THEN CASE WHEN A.ITEM_UOM = 'EA' THEN A.PLAN_QTY ELSE A.PLAN_QTY * A.CELL_M END
										 WHEN A.OPERATION_ID LIKE 'A%' AND A.CELL_REQ_QTY > 0 THEN  A.PLAN_QTY / A.CELL_REQ_QTY END                                         CELL_OUT_QTY
									,A.[WORK_REQUEST_MODEL_ID]
									,A.[VERSION]
									,A.[PROD_SEQ]
									,A.[PLM_EC_NO]  -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
							  FROM (SELECT  A.COMPANY_ID
										   ,A.DIVISION_ID
										   ,A.SITE_ID
										   ,A.PLANT_ID
										   ,A.FACTORY_ID
										   ,@PLAN_GROUP_ID  AS PLAN_GROUP_ID
										   ,ISNULL(SI.APPLIED_MODEL, A.ITEM_ID) AS TOP_ITEM_ID
										   ,A.ITEM_ID
										   ,A.OPERATION_ID
										   ,A.PRODUCTION_TYPE
										   ,A.MARKET
										   ,A.LINE_ID
										   ,SI.ITEM_UOM
										   ,ISNULL(  (  SELECT E.ELECTRODE_TYPE
														FROM   SCM_EQUIPMENT_M E WITH(NOLOCK)
														WHERE  E.COMPANY_ID   = A.COMPANY_ID
														AND    E.DIVISION_ID  = A.DIVISION_ID
														AND    E.SITE_ID      = A.SITE_ID
														AND    E.PLANT_ID     = A.PLANT_ID
														AND    E.FACTORY_ID   = A.FACTORY_ID
														AND    E.EQUIPMENT_ID = A.EQUIPMENT_ID
														AND    E.OPERATION_ID = A.OPERATION_ID ), ISNULL( ( SELECT TOP 1 ILA.ELECTRODE_TYPE
																											FROM   SCM_ITEM_LINE_ASSIGN_M ILA WITH(NOLOCK)
																											WHERE  ILA.COMPANY_ID   = A.COMPANY_ID
																											AND    ILA.DIVISION_ID  = A.DIVISION_ID
																											AND    ILA.SITE_ID      = A.SITE_ID
																											AND    ILA.PLANT_ID     = A.PLANT_ID
																											AND    ILA.FACTORY_ID   = A.FACTORY_ID
																											AND    ILA.ITEM_ID      = A.ITEM_ID
																											AND    ILA.OPERATION_ID = A.OPERATION_ID
																											AND    ILA.LINE_ID      = A.LINE_ID
																											AND    ILA.MONTH >= CONVERT( NVARCHAR(6), @FIRST_DATE, 112)) ,'-' ) ) AS ELECTRODE_TYPE -- 2018-08-06 kimcd LINE ASSIGN 조회문장 추가
										   ,A.PLAN_DATE
										   ,A.PLAN_QTY
										   ,A.EQUIPMENT_ID
		/*									-- 2018-11-21 PIYONG 주석처리
										   ,CASE WHEN A.OPERATION_ID = 'E2000' THEN
											   (SELECT MAX(VALUE) AS LANE
												FROM   SCM_ITEM_CONV_CALC_M C WITH(NOLOCK)
												WHERE  C.MAX_VER_FLAG = 'Y'
												AND    ISNULL(C.VALUE, 0) > 0
												AND    C.CATEGORY     = 'Lane Number'
												AND    C.COMPANY_ID   = A.COMPANY_ID
												AND    C.DIVISION_ID  = A.DIVISION_ID
												AND    C.SITE_ID      = A.SITE_ID
												AND    C.PLANT_ID     = A.PLANT_ID
												AND    C.FACTORY_ID   = A.FACTORY_ID
												AND    C.OPERATION    = A.OPERATION_ID
												AND    C.ITEM_ID      = A.ITEM_ID)
											END AS LANE
										   ,CASE WHEN A.OPERATION_ID = 'E2000' AND SI.ITEM_UOM = 'M' THEN
												  ( SELECT MAX(VALUE) AS M_BATCH
													FROM   SCM_ITEM_CONV_CALC_M C WITH(NOLOCK)
													WHERE  C.MAX_VER_FLAG = 'Y'
													AND    ISNULL(C.VALUE, 0) > 0
													AND    C.CATEGORY    IN ('m/batch','Pancake (m/batch)')
													AND    C.COMPANY_ID   = A.COMPANY_ID
													AND    C.DIVISION_ID  = A.DIVISION_ID
													AND    C.SITE_ID      = A.SITE_ID
													AND    C.PLANT_ID     = A.PLANT_ID
													AND    C.FACTORY_ID   = A.FACTORY_ID
													AND    C.OPERATION    = A.OPERATION_ID
													AND    C.ITEM_ID      = A.ITEM_ID)
											 END  AS M_BATCH
											,CASE WHEN A.OPERATION_ID = 'E2000' AND SI.ITEM_UOM = 'EA' THEN
												  ( SELECT MAX(VALUE) AS CELL_BATCH
													FROM   SCM_ITEM_CONV_CALC_M C WITH(NOLOCK)
													WHERE  C.MAX_VER_FLAG = 'Y'
													AND    ISNULL(C.VALUE, 0) > 0
													AND    C.CATEGORY     = 'cell/batch'
													AND    C.COMPANY_ID   = A.COMPANY_ID
													AND    C.DIVISION_ID  = A.DIVISION_ID
													AND    C.SITE_ID      = A.SITE_ID
													AND    C.PLANT_ID     = A.PLANT_ID
													AND    C.FACTORY_ID   = A.FACTORY_ID
													AND    C.OPERATION    = A.OPERATION_ID
													AND    C.ITEM_ID      = A.ITEM_ID)
											 END  AS CELL_BATCH
											,CASE WHEN A.OPERATION_ID = 'E2000' THEN
												( SELECT MAX(VALUE) AS CELL_M
												  FROM   SCM_ITEM_CONV_CALC_M C WITH(NOLOCK)
												  WHERE  C.MAX_VER_FLAG = 'Y'
												  AND    ISNULL(C.VALUE, 0) > 0
												  AND    C.CATEGORY     = 'Pancake (cell/m)'
												  AND    C.COMPANY_ID   = A.COMPANY_ID
												  AND    C.DIVISION_ID  = A.DIVISION_ID
												  AND    C.SITE_ID      = A.SITE_ID
												  AND    C.PLANT_ID     = A.PLANT_ID
												  AND    C.FACTORY_ID   = A.FACTORY_ID
												  AND    C.OPERATION    = A.OPERATION_ID
												  AND    C.ITEM_ID      = A.ITEM_ID)
											END  AS CELL_M
		*/
											,CASE WHEN A.OPERATION_ID = 'E2000' THEN
															(
															   SELECT TOP 1 VALUE AS LANE
																FROM   SCM_ITEM_CONV_CALC_M C WITH(NOLOCK),
																	   @CONV_TABLE          CT -- 2020-06-30 kimcd 환산자 사용 우선 순위 적용
																WHERE  C.MAX_VER_FLAG = 'Y'
																AND    ISNULL(C.VALUE, 0) > 0
																AND    C.CATEGORY     = 'Lane Number'
																AND    C.COMPANY_ID   = A.COMPANY_ID
																AND    C.DIVISION_ID  = A.DIVISION_ID
																AND    C.SITE_ID      = A.SITE_ID
																AND    C.PLANT_ID     = A.PLANT_ID
																AND    C.FACTORY_ID   = A.FACTORY_ID
																AND    C.OPERATION    = A.OPERATION_ID
																AND    C.ITEM_ID      = A.ITEM_ID
																-----------------------------------------------
																--2018-11-21 PIYONG ADD
																AND	   C.PROD_VERSION_TYPE = L.PROD_VERSION_TYPE
															--	AND    C.MODEL_ID	  = SI.APPLIED_MODEL	--2018-12-07 PIYONG DEL
																AND    A.PRODUCTION_TYPE = CT.PRODUCTION_TYPE -- 2020-06-30 kimcd 환산자 사용 우선 순위 적용
																ORDER BY CASE WHEN C.VERSION_TYPE = CT.VERSION_TYPE THEN IDX ELSE 999 END -- 2020-06-30 kimcd 환산자 사용 우선 순위 적용
																		 ,C.APPLY_DATE DESC -- 2020-06-30 kimcd 적용일 우선 순위
																---------------------------------------------------------------------------------------------
																-- 2018-12-07 PIYONG ADD
																		 ,(CASE WHEN C.MODEL_ID	  = SI.APPLIED_MODEL THEN 1 ELSE 2 END)
																		 ,C.MODEL_ID
																		 ,( CASE WHEN C.VERSION  LIKE 'Z%' THEN REPLACE(C.VERSION, 'Z', '/') ELSE C.VERSION END ) DESC
																-- 2018-12-07 PIYONG ADD 끝
																---------------------------------------------------------------------------------------------
															)
											END AS LANE
										   ,CASE WHEN A.OPERATION_ID = 'E2000' AND SI.ITEM_UOM = 'M' THEN
															  (
																SELECT TOP 1 VALUE AS M_BATCH
																FROM   SCM_ITEM_CONV_CALC_M C WITH(NOLOCK),
																	   @CONV_TABLE          CT -- 2020-06-30 kimcd 환산자 사용 우선 순위 적용
																WHERE  C.MAX_VER_FLAG = 'Y'
																AND    ISNULL(C.VALUE, 0) > 0
																AND    C.CATEGORY     = 'Pancake (m/batch)'
																AND    C.COMPANY_ID   = A.COMPANY_ID
																AND    C.DIVISION_ID  = A.DIVISION_ID
																AND    C.SITE_ID      = A.SITE_ID
																AND    C.PLANT_ID     = A.PLANT_ID
																AND    C.FACTORY_ID   = A.FACTORY_ID
																AND    C.OPERATION    = A.OPERATION_ID
																AND    C.ITEM_ID      = A.ITEM_ID
																-----------------------------------------------
																--2018-11-21 PIYONG ADD
																AND	   C.PROD_VERSION_TYPE = L.PROD_VERSION_TYPE
															--	AND    C.MODEL_ID	  = SI.APPLIED_MODEL	--2018-12-07 PIYONG DEL
																AND    A.PRODUCTION_TYPE = CT.PRODUCTION_TYPE -- 2020-06-30 kimcd 환산자 사용 우선 순위 적용
																ORDER BY CASE WHEN C.VERSION_TYPE = CT.VERSION_TYPE THEN IDX ELSE 999 END -- 2020-06-30 kimcd 환산자 사용 우선 순위 적용
																		 ,C.APPLY_DATE DESC -- 2020-06-30 kimcd 적용일 우선 순위
																---------------------------------------------------------------------------------------------
																-- 2018-12-07 PIYONG ADD
																		 ,(CASE WHEN C.MODEL_ID	  = SI.APPLIED_MODEL THEN 1 ELSE 2 END)
																		 ,C.MODEL_ID
																		 ,( CASE WHEN C.VERSION  LIKE 'Z%' THEN REPLACE(C.VERSION, 'Z', '/') ELSE C.VERSION END ) DESC
																-- 2018-12-07 PIYONG ADD 끝
																---------------------------------------------------------------------------------------------
															)
											 END  AS M_BATCH
											,CASE WHEN A.OPERATION_ID = 'E2000' AND SI.ITEM_UOM = 'EA' THEN
														 (
															SELECT TOP 1 VALUE	AS CELL_BATCH
															FROM   SCM_ITEM_CONV_CALC_M C WITH(NOLOCK),
																   @CONV_TABLE          CT -- 2020-06-30 kimcd 환산자 사용 우선 순위 적용
															WHERE  C.MAX_VER_FLAG = 'Y'
															AND    ISNULL(C.VALUE, 0) > 0
															AND    C.CATEGORY     = 'cell/batch'
															AND    C.COMPANY_ID   = A.COMPANY_ID
															AND    C.DIVISION_ID  = A.DIVISION_ID
															AND    C.SITE_ID      = A.SITE_ID
															AND    C.PLANT_ID     = A.PLANT_ID
															AND    C.FACTORY_ID   = A.FACTORY_ID
															AND    C.OPERATION    = A.OPERATION_ID
															AND    C.ITEM_ID      = A.ITEM_ID
															-----------------------------------------------
															--2018-11-21 PIYONG ADD
															AND    C.PROD_VERSION_TYPE = L.PROD_VERSION_TYPE
														--	AND    C.MODEL_ID	  = SI.APPLIED_MODEL	--2018-12-07 PIYONG DEL
															AND    A.PRODUCTION_TYPE = CT.PRODUCTION_TYPE -- 2020-06-30 kimcd 환산자 사용 우선 순위 적용
															ORDER BY CASE WHEN C.VERSION_TYPE = CT.VERSION_TYPE THEN IDX ELSE 999 END -- 2020-06-30 kimcd 환산자 사용 우선 순위 적용
																	 ,C.APPLY_DATE DESC -- 2020-06-30 kimcd 적용일 우선 순위
															---------------------------------------------------------------------------------------------
															-- 2018-12-07 PIYONG ADD
																	 ,(CASE WHEN C.MODEL_ID	  = SI.APPLIED_MODEL THEN 1 ELSE 2 END)
																	 ,C.MODEL_ID
																	 ,( CASE WHEN C.VERSION  LIKE 'Z%' THEN REPLACE(C.VERSION, 'Z', '/') ELSE C.VERSION END ) DESC
															-- 2018-12-07 PIYONG ADD 끝
															---------------------------------------------------------------------------------------------
														)
											 END  AS CELL_BATCH
											,CASE WHEN A.OPERATION_ID = 'E2000' THEN
														( 
															SELECT TOP 1 VALUE AS CELL_M
															FROM   SCM_ITEM_CONV_CALC_M C WITH(NOLOCK),
																   @CONV_TABLE          CT -- 2020-06-30 kimcd 환산자 사용 우선 순위 적용
															WHERE  C.MAX_VER_FLAG = 'Y'
															AND    ISNULL(C.VALUE, 0) > 0
															AND    C.CATEGORY     = 'Pancake (cell/m)'
															AND    C.COMPANY_ID   = A.COMPANY_ID
															AND    C.DIVISION_ID  = A.DIVISION_ID
															AND    C.SITE_ID      = A.SITE_ID
															AND    C.PLANT_ID     = A.PLANT_ID
															AND    C.FACTORY_ID   = A.FACTORY_ID
															AND    C.OPERATION    = A.OPERATION_ID
															AND    C.ITEM_ID      = A.ITEM_ID
															-----------------------------------------------
															--2018-11-21 PIYONG ADD
															AND	   C.PROD_VERSION_TYPE = L.PROD_VERSION_TYPE
														--	AND    C.MODEL_ID	  = SI.APPLIED_MODEL	--2018-12-07 PIYONG DEL
															AND    A.PRODUCTION_TYPE = CT.PRODUCTION_TYPE -- 2020-06-30 kimcd 환산자 사용 우선 순위 적용
															ORDER BY CASE WHEN C.VERSION_TYPE = CT.VERSION_TYPE THEN IDX ELSE 999 END -- 2020-06-30 kimcd 환산자 사용 우선 순위 적용
																	 ,C.APPLY_DATE DESC -- 2020-06-30 kimcd 적용일 우선 순위
															---------------------------------------------------------------------------------------------
															-- 2018-12-07 PIYONG ADD
																	 ,(CASE WHEN C.MODEL_ID	  = SI.APPLIED_MODEL THEN 1 ELSE 2 END)
																	 ,C.MODEL_ID
																	 ,( CASE WHEN C.VERSION  LIKE 'Z%' THEN REPLACE(C.VERSION, 'Z', '/') ELSE C.VERSION END ) DESC
															-- 2018-12-07 PIYONG ADD 끝
															---------------------------------------------------------------------------------------------
														)
											END  AS CELL_M
											,(  SELECT TOP 1 SY.YIELD
												FROM   SCM_YIELD_M  SY WITH(NOLOCK)
												WHERE  SY.[COMPANY_ID]   = A.[COMPANY_ID]
												AND    SY.[DIVISION_ID]  = A.[DIVISION_ID]
												AND    SY.[SITE_ID]      = A.[SITE_ID]
												AND    SY.[PLANT_ID]     = A.[PLANT_ID]
												AND    SY.[FACTORY_ID]   = A.[FACTORY_ID]
												AND    SY.[OPERATION_ID] = A.[OPERATION_ID]
												AND    SY.[LINE_ID]      = A.[LINE_ID]
												AND    SY.[ITEM_ID]      = A.[ITEM_ID]
												AND    SY.[MONTH]        = CONVERT(NVARCHAR(6), [dbo].[FN_SITE_TIME] (A.SITE_ID), 112)
												AND    SY.[YIELD]        > 0
												AND    SY.[YIELD]       <= 1 )  AS YIELD
											,CASE WHEN A.OPERATION_ID LIKE 'A%' THEN
												(SELECT TOP 1 SUM(MCT.ACCUMULATED_CHILD_QTY)
												 FROM   SCM_MODEL_COMP_TEMP MCT WITH(NOLOCK)
												 WHERE  MCT.[COMPANY_ID]    = A.[COMPANY_ID]
												 AND    MCT.[DIVISION_ID]   = A.[DIVISION_ID]
												 AND    MCT.[SITE_ID]       = A.[SITE_ID]
												 AND    MCT.[PLANT_ID]      = A.[PLANT_ID]
												 AND    MCT.[CHILD_ITEM_ID] = A.[ITEM_ID]
												 AND    EXISTS (SELECT TOP 1 1
																FROM SCM_ITEM_M  M WITH(NOLOCK)
																WHERE  M.COMPANY_ID  = MCT.COMPANY_ID
																AND    M.DIVISION_ID = MCT.DIVISION_ID
																AND    M.SITE_ID     = MCT.SITE_ID
																AND    M.ITEM_ID     = MCT.MODEL_ID
																AND    M.FLOW_ID LIKE 'A%') -- 2018-05-15 kimcd Cell 공정 모델만으로 제한
												 GROUP  BY [MODEL_ID]
												 ORDER  BY CASE WHEN MCT.MODEL_ID = SI.APPLIED_MODEL THEN 1 ELSE 2 END, -- 2018-12-11 kimcd 적용 모델 우선
														   1 DESC )
											END  AS CELL_REQ_QTY
											,A.[WORK_REQUEST_MODEL_ID]
											,A.[VERSION]
											,A.[PROD_SEQ]
											,A.[PLM_EC_NO]  -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
									FROM   [dbo].[FP_MPP_WPP_BASE_PLAN_M] A   WITH(NOLOCK)
											-----------------------------------------------
											--2018-11-21 PIYONG ADD
										   LEFT OUTER JOIN [dbo].[SCM_LINE_M]			  L   WITH(NOLOCK)	--2018-11-21 PIYONG ADD 
														ON	   L.OPERATION_ID = 'E2000'
														AND    L.ACTIVE_FLAG    = 'Y'
														AND	   A.COMPANY_ID	    = L.COMPANY_ID
														AND	   A.DIVISION_ID	= L.DIVISION_ID
														AND    A.SITE_ID		= L.SITE_ID
														AND    A.PLANT_ID		= L.PLANT_ID
														AND    A.FACTORY_ID 	= L.FACTORY_ID
														AND    A.OPERATION_ID	= L.OPERATION_ID
														AND    A.LINE_ID		= L.LINE_ID
											--2018-11-21 PIYONG ADD END
											-----------------------------------------------			
										  ,[dbo].[SCM_ITEM_M]             SI  WITH(NOLOCK)
									WHERE  SI.COMPANY_ID   = A.COMPANY_ID
									AND    SI.SITE_ID      = A.SITE_ID
									AND    SI.DIVISION_ID  = A.DIVISION_ID
									AND    SI.ITEM_ID      = A.ITEM_ID
									AND    A.PLAN_WEEK     = @P_PLAN_WEEK
									AND    A.PLAN_REVISION = @P_PLAN_REVISION
									AND    A.PLAN_DATE    >= @FIRST_DATE
									AND    A.PLAN_DATE    <= @LAST_DATE
									) A ) B
							ON (DP.[FACTORY_ID]    = B.[FACTORY_ID]
							AND DP.[INSTANCE_TYPE] = B.[INSTANCE_TYPE]
							AND DP.[PLAN_TYPE]     = B.[PLAN_TYPE]
							AND DP.[ITEM_ID]       = B.[ITEM_ID]
							AND DP.[LINE_ID]       = B.[LINE_ID]
							AND DP.[PLAN_DATE]     = B.[PLAN_DATE]
							AND DP.[TOP_ITEM_ID]   = B.[TOP_ITEM_ID]
							AND DP.[OPERATION_ID]  = B.[OPERATION_ID]
							AND DP.[FP_PRODUCTION_TYPE] = B.[PRODUCTION_TYPE]
							AND DP.[MARKET]        = B.[MARKET]
							--AND DP.[ELECTRODE_TYPE]= B.[ELECTRODE_TYPE]
							AND DP.[WORK_REQUEST_MODEL_ID] = B.[WORK_REQUEST_MODEL_ID]
							AND	DP.[VERSION]			= B.[VERSION]
							AND	DP.[PROD_SEQ]			= B.[PROD_SEQ]
							AND	DP.[PLM_EC_NO]			= B.[PLM_EC_NO]  -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
							AND DP.[EQUIPMENT_ID]  = B.[EQUIPMENT_ID] )
						WHEN MATCHED THEN
							UPDATE SET   DP.[PLAN_GROUP_ID] = B.[PLAN_GROUP_ID]
										,DP.[PRODUCTION_TYPE] = B.[PRODUCTION_TYPE]
										,DP.[ELECTRODE_TYPE]= B.[ELECTRODE_TYPE] -- 2021-09-17 kimcd ON 조건에서 제거하고 갱신
										,DP.[PLAN_QTY]      = B.[PLAN_QTY]
										,DP.[PLAN_IN_QTY]   = B.[PLAN_IN_QTY]
										,DP.[UPDATE_ID]     = B.[UPDATE_ID]
										,DP.[UPDATE_TIME]   = B.[UPDATE_TIME]
										,DP.[ROLL_IN_QTY]   = B.[ROLL_IN_QTY]
										,DP.[ROLL_OUT_QTY]  = B.[ROLL_OUT_QTY]
										,DP.[JR_IN_QTY]     = B.[JR_IN_QTY]
										,DP.[JR_OUT_QTY]    = B.[JR_OUT_QTY]
										,DP.[BATCH_IN_QTY]  = B.[BATCH_IN_QTY]
										,DP.[BATCH_OUT_QTY] = B.[BATCH_OUT_QTY]
										,DP.[CELL_IN_QTY]   = B.[CELL_IN_QTY]
										,DP.[CELL_OUT_QTY]  = B.[CELL_OUT_QTY]
										,DP.[LOCATION]      = B.[LOCATION]  -- 2022-06-09 kimcd LOCATION 갱신 문장 추가
						WHEN NOT MATCHED THEN
							INSERT ( [COMPANY_ID]
									,[DIVISION_ID]
									,[SITE_ID]
									,[PLANT_ID]
									,[FACTORY_ID]
									,[PLAN_GROUP_ID]
									,[INSTANCE_TYPE]
									,[TOP_ITEM_ID]
									,[ITEM_ID]
									,[OPERATION_ID]
									,[LOCATION]
									,[PRODUCTION_TYPE]
									,[MARKET]
									,[LINE_ID]
									,[ELECTRODE_TYPE]
									,[PLAN_DATE]
									,[PLAN_QTY]
									,[PLAN_IN_QTY]
									,[INSERT_ID]
									,[INSERT_TIME]
									,[UPDATE_ID]
									,[UPDATE_TIME]
									,[PLAN_TYPE]
									,[EQUIPMENT_ID]
									,[FP_PRODUCTION_TYPE]
									,[ROLL_IN_QTY]
									,[ROLL_OUT_QTY]
									,[JR_IN_QTY]
									,[JR_OUT_QTY]
									,[BATCH_IN_QTY]
									,[BATCH_OUT_QTY]
									,[CELL_IN_QTY]
									,[CELL_OUT_QTY]
									,[WORK_REQUEST_MODEL_ID]
									,[VERSION]
									,[PROD_SEQ]
									,[PLM_EC_NO]  -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
									)
							VALUES ( B.[COMPANY_ID]
									,B.[DIVISION_ID]
									,B.[SITE_ID]
									,B.[PLANT_ID]
									,B.[FACTORY_ID]
									,B.[PLAN_GROUP_ID]
									,B.[INSTANCE_TYPE]
									,B.[TOP_ITEM_ID]
									,B.[ITEM_ID]
									,B.[OPERATION_ID]
									,B.[LOCATION]
									,B.[PRODUCTION_TYPE]
									,B.[MARKET]
									,B.[LINE_ID]
									,B.[ELECTRODE_TYPE]
									,B.[PLAN_DATE]
									,B.[PLAN_QTY]
									,B.[PLAN_IN_QTY]
									,B.[INSERT_ID]
									,B.[INSERT_TIME]
									,B.[UPDATE_ID]
									,B.[UPDATE_TIME]
									,B.[PLAN_TYPE]
									,B.[EQUIPMENT_ID]
									,B.[PRODUCTION_TYPE]
									,B.[ROLL_IN_QTY]
									,B.[ROLL_OUT_QTY]
									,B.[JR_IN_QTY]
									,B.[JR_OUT_QTY]
									,B.[BATCH_IN_QTY]
									,B.[BATCH_OUT_QTY]
									,B.[CELL_IN_QTY]
									,B.[CELL_OUT_QTY]
									,B.[WORK_REQUEST_MODEL_ID]
									,B.[VERSION]
									,B.[PROD_SEQ]
									,B.[PLM_EC_NO]  -- 2022-11-02 kimcd 전극 version, ec no 추가 관리
									);
				END

		COMMIT TRAN

		EXEC PR_XIF_LOG @v_proc_name, NULL, 'END',   NULL, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
		
	END TRY

	BEGIN CATCH

		-- 에러나도 로그는 인서트
		SET @v_descr = ERROR_MESSAGE()
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate

	END CATCH

END
