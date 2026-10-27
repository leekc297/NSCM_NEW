
CREATE PROCEDURE [dbo].[PR_MK_DAILY_PLAN_FP_KPI]

-- ================================================================================================
-- Program ID          : FP03571
-- Program Name        : PR_MK_DAILY_PLAN_FP_KPI
-- Param               :
-- Batch Period        : 1 Day
-- Description         :
--
-- Source System       : FP SDB
-- Destination System  : FP SDB
-- Source Table        : FP_DAILY_PRODUCTION_PLAN_R
-- Destination Table   : FP_KPI_DAILY_PRODUCTION_PLAN_H
--
-- Create(Update) Date : 2018.04.12
-- Update Date		   : 2022.11.18 2.1
--
-- Author              : 김춘동
-- Version             : 1.0 생산 계획 변경률 관리를 위해 3일 계획 HISTORY 정보 형성
--                       1.1 2018-08-23 KIMCD TOP_ITEM_ID 컬럼 추가
--                       1.2 2018-09-04 KIMCD PLAN_TYPE 컬럼추가
--                                            3일 FIX 외에 W+2주 계획 형성 작업 추가 
--                       1.3 2018-10-09 KIMCD 생산 계획 준수율 지표 변경에 따라 W+2주 계획 형성 로직 수정
--                       1.4 2018-11-01 kimcd 계획 편성한 일자 insert_time에서 update_time으로 수정 W+2
--                       1.5 2019-06-26 kimcd 계획 편성일자 - A2동에 대해서 일반, Pilot 구분하여 정보 형성
--                       1.6 2019-09-30 kimcd CNB 시업 시간 분리에 따른 대응
--                       1.7 2019-12-30 kimcd 24시 기준으로 W+2주 계획 형성 및 DPP 정보 형성
--                       1.8 2020-01-15 kimcd 24시 기준으로 WPP, Release 계획 이력 형성
--                       1.9 2022-05-26 kimcd 일 기준으로 1일 backup 정보 형성 과정 추가
--                       2.0 2022-08-25 leeseongmin WPP/MPP Cut-off 저장 추가 - C20220818-000257
--                       2.1 2022-11-18 kimcd 전극 버전별 계획 수립에 따른 계획 합산으로 로직 보완
--                       2.2 2024-05-21 kimcd WPP 검증 로직 수정
-- ================================================================================================

-- PARAM PLAN_ID
@P_DATE_TERM   NUMERIC(3) = NULL,
@P_CUTOFF_DATE DATE       = NULL,
@P_SITE_ID     NVARCHAR(30) = NULL

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_MK_DAILY_PLAN_FP_KPI'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	  = 0
	DECLARE @sysdate     DATETIME     = GETDATE()

	DECLARE @ROWCOUNT    INTEGER = 0

	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)

	-- ================================================
    -- Declare start
	-- ================================================
    DECLARE @DATE_TERM   NUMERIC(3)
	DECLARE @SITE_ID     NVARCHAR(10)
	DECLARE @CUTOFF_DATE DATE
	DECLARE @START_TIME  NVARCHAR(6)  -- 2019-09-30 kimcd 시업 시간 조건 추가
	DECLARE @YYYYWW      NVARCHAR(6)  -- 2020-01-15 kimcd Release, WPP 계획 기준 주차
	-- ================================================
    -- Declare end
	-- ================================================


	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

	BEGIN TRY				

		-- BEGIN TRAN 2022-05-26 kimcd transaction 시작 제거
		-- ================================================
		-- 로직 추가 start
		-- ================================================
		IF @P_DATE_TERM IS NULL
			SET @DATE_TERM = 3
		ELSE
			SET @DATE_TERM = @P_DATE_TERM

		DECLARE CUR_SITE CURSOR FOR				--INSTANCE 별 발송
			SELECT DISTINCT SITE_ID
				  ,CASE WHEN @P_CUTOFF_DATE IS NULL THEN
							DATEADD(D,-1,CONVERT(DATE, [dbo].[FN_SITE_TIME] (S.SITE_ID), 120)) -- 2019-06-26 kimcd 시업 시간으로 변경하면서 기준일 어제로 만듬
						ELSE
							@P_CUTOFF_DATE
						END        AS CUTOFF_DATE
				  ,CASE WHEN @P_CUTOFF_DATE IS NOT NULL THEN (  SELECT TOP 1 SUBSTRING(VL.SEGMENT2,1,2)
																FROM   SCM_SYS_LOOKUP_VALUE  VL WITH(NOLOCK),
																		SCM_PLANT_M           P  WITH(NOLOCK)
																WHERE  VL.SEGMENT1         = P.PLANT_ID
																AND    P.SITE_ID           = S.SITE_ID
																AND    VL.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
																AND    VL.ACTIVE_FLAG      = 'Y')
				                                        ELSE SUBSTRING(REPLACE(CONVERT(NVARCHAR(20), [dbo].[FN_SITE_TIME] (S.SITE_ID), 120),':', ''), 12, 3) END AS START_TIME  -- 2019-09-30 kimcd 시업 시간 조건 추가
			FROM  DBO.SCM_SITE_M S WITH(NOLOCK)
			WHERE ( @P_SITE_ID IS NULL OR SITE_ID = @P_SITE_ID )
			AND   ( @P_CUTOFF_DATE IS NOT NULL OR ( @P_CUTOFF_DATE IS NULL AND SUBSTRING(REPLACE(CONVERT(NVARCHAR(20), [dbo].[FN_SITE_TIME] (S.SITE_ID), 120),':', ''), 12, 3) IN ( SELECT SUBSTRING(VL.SEGMENT2,1,3)
																																													FROM   SCM_SYS_LOOKUP_VALUE  VL WITH(NOLOCK),
																																														   SCM_PLANT_M           P  WITH(NOLOCK)
																																													WHERE  VL.SEGMENT1         = P.PLANT_ID
																																													AND    P.SITE_ID           = S.SITE_ID
																																													AND    VL.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
																																													AND    VL.ACTIVE_FLAG      = 'Y') ) ); -- 2019-06-26 kimcd 시업 시간으로 수정 2019-09-30 kimcd 시업 시간 기준으로 3자리로 변경

			OPEN CUR_SITE;
			
			FETCH NEXT FROM CUR_SITE INTO @SITE_ID
										  ,@CUTOFF_DATE
										  ,@START_TIME  -- 2019-09-30 kimcd 시업 시간 조건 추가
			
			EXECUTE pr_log_process  null, @CUTOFF_DATE, @SITE_ID, @@FETCH_STATUS, @START_TIME, 'PR_MK_DAILY_PLAN_FP_KPI 0', @ROWCOUNT, null, @DATE_TERM, null
			
			WHILE (@@FETCH_STATUS = 0)
				BEGIN
					DELETE FROM [dbo].[FP_KPI_DAILY_PRODUCTION_PLAN_H]
					WHERE CUTOFF_DATE  = @CUTOFF_DATE
					AND   SITE_ID      = @SITE_ID
					AND   PLANT_ID    IN (  SELECT  W.SEGMENT1
											FROM   [DBO].[SCM_SYS_LOOKUP_VALUE] W  WITH(NOLOCK)
											WHERE  W.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
											AND    W.ACTIVE_FLAG = 'Y'
											AND    W.SEGMENT2    LIKE @START_TIME + '%' ) -- 2019-09-30 kimcd PLANT 시업 시간 구분자 추가
					AND   PLAN_TYPE    = '3DAY_FIX'; -- 2018-09-04 kimcd PLAN 유형 추가

					INSERT INTO [dbo].[FP_KPI_DAILY_PRODUCTION_PLAN_H]
						(  [CUTOFF_DATE]
						  ,[INSTANCE_ID]
						  ,[FP_PLAN_ID]
						  ,[COMPANY_ID]
						  ,[DIVISION_ID]
						  ,[SITE_ID]
						  ,[PLANT_ID]
						  ,[FACTORY_ID]
						  ,[WORK_ORDER_SPL_ID]
						  ,[WORK_ORDER_ID]
						  ,[DEMAND_ID]
						  ,[ITEM_ID]
						  ,[OPERATION_ID]
						  ,[LINE_ID]
						  ,[ELECTRODE_TYPE]
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
						  ,[CELL_IN_QTY]
						  ,[CELL_OUT_QTY]
						  ,[BATCH_IN_QTY]
						  ,[BATCH_OUT_QTY]
						  ,[FIX_TYPE]
						  ,[PRODUCTION_TYPE]
						  ,[LINE_ITEM_SEQ]
						  ,[OPERATION_ITEM_SEQ]
						  ,[MARKET]
						  ,[FP_PRODUCTION_TYPE]
						  ,[INSERT_ID]
						  ,[INSERT_DTTM] 
						  ,[TOP_ITEM_ID]   -- 2018-08-23 KIMCD TOP_ITEM_ID 컬럼 추가
						  ,[PLAN_TYPE])    -- 2018-09-04 kimcd PLAN 유형 추가 '3DAY_FIX'
					SELECT @CUTOFF_DATE   AS [CUTOFF_DATE]
						  ,A.[INSTANCE_ID]
						  ,A.[FP_PLAN_ID]
						  ,A.[COMPANY_ID]
						  ,A.[DIVISION_ID]
						  ,A.[SITE_ID]
						  ,A.[PLANT_ID]
						  ,A.[FACTORY_ID]
						  ,A.[WORK_ORDER_SPL_ID]
						  ,A.[WORK_ORDER_ID]
						  ,A.[DEMAND_ID]
						  ,A.[ITEM_ID]
						  ,A.[OPERATION_ID]
						  ,A.[LINE_ID]
						  ,A.[ELECTRODE_TYPE]
						  ,A.[EQUIPMENT_ID]
						  ,A.[PLAN_DATE]
						  ,A.[START_TIME]
						  ,A.[END_TIME]
						  ,A.[PLAN_QTY]
						  ,A.[PLAN_IN_QTY]
						  ,A.[ITEM_UOM]
						  ,A.[ROLL_IN_QTY]
						  ,A.[ROLL_OUT_QTY]
						  ,A.[JR_IN_QTY]
						  ,A.[JR_OUT_QTY]
						  ,A.[CELL_IN_QTY]
						  ,A.[CELL_OUT_QTY]
						  ,A.[BATCH_IN_QTY]
						  ,A.[BATCH_OUT_QTY]
						  ,A.[FIX_TYPE]
						  ,A.[PRODUCTION_TYPE]
						  ,A.[LINE_ITEM_SEQ]
						  ,A.[OPERATION_ITEM_SEQ]
						  ,A.[MARKET]
						  ,A.[FP_PRODUCTION_TYPE]
						  ,@v_proc_name
						  ,GETDATE()
						  ,ISNULL(A.[TOP_ITEM_ID],A.[ITEM_ID]) -- 2018-08-23 KIMCD TOP_ITEM_ID 컬럼 추가
						  ,'3DAY_FIX' -- 2018-09-04 kimcd PLAN 유형 추가 
					FROM FP_DAILY_PRODUCTION_PLAN_R A WITH(NOLOCK)
						 ,SCM_OPERATION_M           O WITH(NOLOCK)
						 ,( SELECT   PLAN_ID
									,FACTORY_ID
									,SITE_ID
									,PLAN_GROUP_ID
									,INSTANCE_ID
									,ZZ.NUMS
							FROM ( SELECT B.SITE_ID
										  ,A.INSTANCE_ID
										  ,INSTANCE_DATE
										  ,DIVISION_ID
										  ,B.FACTORY_ID
										  ,A.PLAN_GROUP_ID
										  ,A.RELEASE_PLAN_ID AS PLAN_ID
										  ,ROW_NUMBER() OVER ( PARTITION BY  DIVISION_ID, INSTANCE_TYPE, B.FACTORY_ID, A.FACTORY_ID, A.PLAN_GROUP_ID ORDER BY INSERT_TIME DESC ) NUMS -- 마지막 RELEASE VERSION
									FROM [DBO].FP_RELEASE_PLAN_INFO_H  A
										,( SELECT A.[INSTANCE_ID]
													,INSTANCE_TYPE
													,B.SITE_ID
													,B.FACTORY_ID
													,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE B.FACTORY_ID END  AS LINK_FACTORY_ID
													,ISNULL(MP.SEGMENT2,'-')  AS PLAN_GROUP_ID
											FROM DBO.[FP_INSTANCE_FACTORY_M] A WITH(NOLOCK)     
												,DBO.SCM_FACTORY_M           B WITH(NOLOCK)
												,SCM_SYS_LOOKUP_VALUE        SLV WITH(NOLOCK)
												LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE MP WITH(NOLOCK)
													ON MP.LOOKUP_TYPE_CODE = 'INSTANCE_PLANNING_GROUP'
													AND MP.SEGMENT1        = SLV.SEGMENT1
													AND SLV.ATTRIBUTE1     = 'PLAN GROUP'
											WHERE A.FACTORY_ID = B.FACTORY_ID     
											AND A.ACTIVE_FLAG  = 'Y'     
											AND A.ACTIVE_FLAG  = B.ACTIVE_FLAG     
											AND A.INSTANCE_ID != 'KR_CELL_M_P' -- 오창 소형 조립 테스트용 계획 SCM과 무관함
											AND A.INSTANCE_ID != 'KR_CELL_A2'  -- 2019-06-26 kimcd 오창 자동차 Pilot 계획 제거
											AND SLV.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
											AND SLV.SEGMENT1   = A.INSTANCE_ID
											AND B.SITE_ID = @SITE_ID
											) B      
									WHERE A.INSTANCE_ID = B.INSTANCE_ID
									AND A.FACTORY_ID = B.LINK_FACTORY_ID
									AND A.PLAN_GROUP_ID = B.PLAN_GROUP_ID
									AND A.INSTANCE_DATE <= CONVERT(NVARCHAR(8), @CUTOFF_DATE, 112)
									UNION ALL
									SELECT B.SITE_ID
										  ,A.INSTANCE_ID
										  ,INSTANCE_DATE
										  ,DIVISION_ID
										  ,B.FACTORY_ID
										  ,A.PLAN_GROUP_ID
										  ,A.RELEASE_PLAN_ID AS PLAN_ID
										  ,ROW_NUMBER() OVER ( PARTITION BY  DIVISION_ID, INSTANCE_TYPE, B.FACTORY_ID, A.FACTORY_ID, A.PLAN_GROUP_ID ORDER BY INSERT_TIME DESC ) NUMS -- 마지막 RELEASE VERSION
									FROM [DBO].FP_RELEASE_PLAN_INFO_H  A
										,( SELECT A.[INSTANCE_ID]
													,INSTANCE_TYPE
													,B.SITE_ID
													,B.FACTORY_ID
													,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE B.FACTORY_ID END  AS LINK_FACTORY_ID
													,ISNULL(MP.SEGMENT2,'-')  AS PLAN_GROUP_ID
											FROM DBO.[FP_INSTANCE_FACTORY_M] A WITH(NOLOCK)     
												,DBO.SCM_FACTORY_M           B WITH(NOLOCK)
												,SCM_SYS_LOOKUP_VALUE        SLV WITH(NOLOCK)
												LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE MP WITH(NOLOCK)
													ON MP.LOOKUP_TYPE_CODE = 'INSTANCE_PLANNING_GROUP'
													AND MP.SEGMENT1        = SLV.SEGMENT1
													AND SLV.ATTRIBUTE1     = 'PLAN GROUP'
											WHERE A.FACTORY_ID = B.FACTORY_ID     
											AND A.ACTIVE_FLAG  = 'Y'     
											AND A.ACTIVE_FLAG  = B.ACTIVE_FLAG     
											AND A.INSTANCE_ID  = 'KR_CELL_A2'  -- 2019-06-26 kimcd 오창 자동차 Pilot 계획만 추가
											AND SLV.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
											AND SLV.SEGMENT1   = A.INSTANCE_ID
											AND B.SITE_ID = @SITE_ID
											) B      
									WHERE A.INSTANCE_ID = B.INSTANCE_ID
									AND A.FACTORY_ID = B.LINK_FACTORY_ID
									AND A.PLAN_GROUP_ID = B.PLAN_GROUP_ID
									AND A.INSTANCE_DATE <= CONVERT(NVARCHAR(8), @CUTOFF_DATE, 112)
								) ZZ       
						  WHERE ZZ.NUMS = 1
						  ) B
					WHERE A.FP_PLAN_ID  = B.PLAN_ID
					AND   A.INSTANCE_ID = B.INSTANCE_ID
					AND   A.FACTORY_ID  = B.FACTORY_ID
					AND   A.PLAN_DATE  >= @CUTOFF_DATE
					AND   A.PLAN_DATE  <= DATEADD(DD,@DATE_TERM,@CUTOFF_DATE)
					AND   A.COMPANY_ID   = O.COMPANY_ID
					AND   A.DIVISION_ID  = O.DIVISION_ID
					AND   A.SITE_ID      = O.SITE_ID
					AND   A.OPERATION_ID = O.OPERATION_ID
					AND   O.WO_FLAG      = 'Y'
					AND   A.PLANT_ID    IN (SELECT  W.SEGMENT1
											FROM   [DBO].[SCM_SYS_LOOKUP_VALUE] W  WITH(NOLOCK)
											WHERE  W.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
											AND    W.ACTIVE_FLAG = 'Y'
											AND    W.SEGMENT2    LIKE @START_TIME + '%' ); -- 2019-09-30 kimcd PLANT 시업 시간 구분자 추가

					SET @ROWCOUNT = @ROWCOUNT + @@ROWCOUNT
					
					 EXECUTE pr_log_process  null, @CUTOFF_DATE, @SITE_ID, @@FETCH_STATUS, @START_TIME, 'PR_MK_DAILY_PLAN_FP_KPI 1', @ROWCOUNT, null, @DATE_TERM, null

					-- 2022-05-26 kimcd 일 기준으로 1일 backup 정보 형성 과정 추가 시작
					INSERT INTO [dbo].[FP_DAILY_PRODUCTION_PLAN_CUTOFF_H]
						([CUTOFF_DATE]
						,[COMPANY_ID]
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
						,[FULL_CLEANING_FLAG]
						,[MODEL_TYPE_CHANGE_FLAG]
						,[SEQ]
						,[CELL_MATERIAL_ID]
						,[TOTAL_BATCH]
						,[PIG_CLEANING_FLAG]
						,[SETUP_COLOR_CODE]
						,[SHIFT]) 
					 SELECT @CUTOFF_DATE
						  ,[COMPANY_ID]
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
						  ,@v_proc_name -- [INSERT_ID]
						  ,GETDATE() -- [INSERT_TIME]
						  ,@v_proc_name -- [UPDATE_ID]
						  ,GETDATE() -- [UPDATE_TIME]
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
						  ,[FULL_CLEANING_FLAG]
						  ,[MODEL_TYPE_CHANGE_FLAG]
						  ,[SEQ]
						  ,[CELL_MATERIAL_ID]
						  ,[TOTAL_BATCH]
						  ,[PIG_CLEANING_FLAG]
						  ,[SETUP_COLOR_CODE]
						  ,[SHIFT]
					FROM  FP_DAILY_PRODUCTIOIN_PLAN_H A WITH(NOLOCK)
					WHERE A.PLAN_DATE  >= @CUTOFF_DATE
					AND   A.SITE_ID     = @SITE_ID
					AND   A.PLAN_QTY    > 0
					AND   A.PLAN_TYPE   = 'RELEASE'
					AND   A.PLANT_ID    IN (SELECT  W.SEGMENT1
											FROM   [DBO].[SCM_SYS_LOOKUP_VALUE] W  WITH(NOLOCK)
											WHERE  W.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
											AND    W.ACTIVE_FLAG = 'Y'
											AND    W.SEGMENT2    LIKE @START_TIME + '%' );

					SET @ROWCOUNT = @ROWCOUNT + @@ROWCOUNT
					-- 2022-05-26 kimcd 일 기준으로 1일 backup 정보 형성 과정 추가 끝
					
					EXECUTE pr_log_process  null, @CUTOFF_DATE, @SITE_ID, @@FETCH_STATUS, @START_TIME, 'PR_MK_DAILY_PLAN_FP_KPI 2', @ROWCOUNT, null, @DATE_TERM, null
					
					FETCH NEXT FROM CUR_SITE INTO @SITE_ID
												  ,@CUTOFF_DATE
												  ,@START_TIME  -- 2019-09-30 kimcd 시업 시간 조건 추가

				END

		CLOSE CUR_SITE;
		DEALLOCATE CUR_SITE;

		--------------------------------------------------------------------------------
		------------------  C20220818-000257 WPP Cut-off Data 생성 START ---------------
		DECLARE CUR_WPP_SITE CURSOR FOR				--INSTANCE 별 발송		
			
			SELECT DISTINCT SITE_ID
				  ,CONVERT(DATE,DATEADD(wk, DATEDIFF(d, 0, CONVERT(DATE, [dbo].[FN_SITE_TIME] (S.SITE_ID), 120)) / 7 - 1, 0), 120)  AS CUTOFF_DATE  -- 2022-08-23 leeseongmin 기준일을 전주 월요일로 적용
    			  ,SUBSTRING(REPLACE(CONVERT(NVARCHAR(20), [dbo].[FN_SITE_TIME] (S.SITE_ID), 120),':', ''), 12, 3) AS START_TIME  
			FROM  [dbo].[SCM_SITE_M] S WITH(NOLOCK)
			WHERE (( SUBSTRING(REPLACE(CONVERT(NVARCHAR(20), [dbo].[FN_SITE_TIME] (S.SITE_ID), 120),':', ''), 12, 3) IN ( SELECT SUBSTRING(VL.ATTRIBUTE7,1,3)
																														   FROM   SCM_SYS_LOOKUP_VALUE  VL WITH(NOLOCK),
																																  SCM_PLANT_M           P  WITH(NOLOCK)
																															WHERE  VL.SEGMENT1         = P.PLANT_ID
																															AND    P.SITE_ID           = S.SITE_ID
																															AND    VL.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
																															AND    VL.ACTIVE_FLAG      = 'Y') ) )																			
			-- AND   (( CONVERT(varchar(3), DATENAME(WEEKDAY, CONVERT(DATE, [dbo].[FN_SITE_TIME] (S.SITE_ID) )))
			AND   (( CONVERT(varchar(3), DATEPART(WEEKDAY, CONVERT(DATE, [dbo].[FN_SITE_TIME] (S.SITE_ID) ))) -- 2024-05-21 kimcd 검증로직 수정  요일 숫자로 변경
			                                                                           IN ( SELECT CONVERT(varchar(3),VL.ATTRIBUTE5)
																							FROM   SCM_SYS_LOOKUP_VALUE  VL WITH(NOLOCK),
																							SCM_PLANT_M           P  WITH(NOLOCK)
																							WHERE  VL.SEGMENT1         = P.PLANT_ID
																							AND    P.SITE_ID           = S.SITE_ID
																							AND    VL.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
																							AND    VL.ACTIVE_FLAG      = 'Y') ) );  -- 2022-08-23 C20220818-000257 leeseongmin 월요일 체크

			OPEN CUR_WPP_SITE;
			
			FETCH NEXT FROM CUR_WPP_SITE INTO @SITE_ID
										     ,@CUTOFF_DATE
										     ,@START_TIME  -- 2019-09-30 kimcd 시업 시간 조건 추가


			WHILE (@@FETCH_STATUS = 0)
				BEGIN	
					-- 2022-05-26 kimcd 일 기준으로 1일 backup 정보 형성 과정 추가 시작
					INSERT INTO [dbo].[FP_DAILY_PRODUCTION_PLAN_CUTOFF_H]
						([CUTOFF_DATE]
						,[COMPANY_ID]
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
						,[FULL_CLEANING_FLAG]
						,[MODEL_TYPE_CHANGE_FLAG]
						,[SEQ]
						,[CELL_MATERIAL_ID]
						,[TOTAL_BATCH]
						,[PIG_CLEANING_FLAG]
						,[SETUP_COLOR_CODE]
						,[SHIFT]) 
					 SELECT @CUTOFF_DATE
						  ,[COMPANY_ID]
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
						  ,@v_proc_name -- [INSERT_ID]
						  ,GETDATE() -- [INSERT_TIME]
						  ,@v_proc_name -- [UPDATE_ID]
						  ,GETDATE() -- [UPDATE_TIME]
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
						  ,[FULL_CLEANING_FLAG]
						  ,[MODEL_TYPE_CHANGE_FLAG]
						  ,[SEQ]
						  ,[CELL_MATERIAL_ID]
						  ,[TOTAL_BATCH]
						  ,[PIG_CLEANING_FLAG]
						  ,[SETUP_COLOR_CODE]
						  ,[SHIFT]
					FROM  FP_DAILY_PRODUCTIOIN_PLAN_H A WITH(NOLOCK)
					WHERE A.PLAN_DATE  >= @CUTOFF_DATE
					AND   A.SITE_ID     = @SITE_ID
					AND   A.PLAN_QTY    > 0
					AND   A.PLAN_TYPE   = 'WPP'  -- 2022-08-23 WPP 추가작업 
					AND   A.PLANT_ID    IN (SELECT  W.SEGMENT1
											FROM   [DBO].[SCM_SYS_LOOKUP_VALUE] W  WITH(NOLOCK)
											WHERE  W.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
											AND    W.ACTIVE_FLAG = 'Y'
											AND    W.ATTRIBUTE7    LIKE @START_TIME + '%' );

					SET @ROWCOUNT = @ROWCOUNT + @@ROWCOUNT
					-- 2022-05-26 kimcd 일 기준으로 1일 backup 정보 형성 과정 추가 끝

					FETCH NEXT FROM CUR_WPP_SITE INTO @SITE_ID
												     ,@CUTOFF_DATE
												     ,@START_TIME  -- 2019-09-30 kimcd 시업 시간 조건 추가

				END

		CLOSE CUR_WPP_SITE;
		DEALLOCATE CUR_WPP_SITE;
		-----------------------------	WPP  END   -------------------------------------

		----------------- C20220818-000257  MPP Cut-off Data 생성 START ----------------	

		DECLARE CUR_MPP_SITE CURSOR FOR				--INSTANCE 별 발송		
			
			SELECT DISTINCT SITE_ID
				  ,DATEADD(m,-1, DATEADD(d,-day(CONVERT(DATE, [dbo].[FN_SITE_TIME] (S.SITE_ID), 120))+1,CONVERT(DATE, [dbo].[FN_SITE_TIME] (S.SITE_ID), 120))) AS CUTOFF_DATE
				  -- 2022-08-23 leeseongmin 기준일 전월 1일로 만듬						   
				  ,SUBSTRING(REPLACE(CONVERT(NVARCHAR(20), [dbo].[FN_SITE_TIME] (S.SITE_ID), 120),':', ''), 12, 3) AS START_TIME    -- 2019-09-30 kimcd 시업 시간 조건 추가
			FROM  DBO.SCM_SITE_M S WITH(NOLOCK)
			WHERE (( SUBSTRING(REPLACE(CONVERT(NVARCHAR(20), [dbo].[FN_SITE_TIME] (S.SITE_ID), 120),':', ''), 12, 3) IN ( SELECT SUBSTRING(VL.ATTRIBUTE7,1,3)
																														   FROM   SCM_SYS_LOOKUP_VALUE  VL WITH(NOLOCK),
																																  SCM_PLANT_M           P  WITH(NOLOCK)
																															WHERE  VL.SEGMENT1         = P.PLANT_ID
																															AND    P.SITE_ID           = S.SITE_ID
																															AND    VL.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
																															AND    VL.ACTIVE_FLAG      = 'Y') ) )																								
			AND   (( CONVERT(varchar(2),DAY(CONVERT(DATE,[dbo].[FN_SITE_TIME] (S.SITE_ID))))
			                                                                           IN ( SELECT CONVERT(varchar(2),VL.ATTRIBUTE6)
																							FROM   SCM_SYS_LOOKUP_VALUE  VL WITH(NOLOCK),
																							SCM_PLANT_M           P  WITH(NOLOCK)
																							WHERE  VL.SEGMENT1         = P.PLANT_ID
																							AND    P.SITE_ID           = S.SITE_ID
																							AND    VL.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
																							AND    VL.ACTIVE_FLAG      = 'Y') ) ); -- 2022-08-23 leeseongmin 날짜 1일 확인

			OPEN CUR_MPP_SITE;
			
			FETCH NEXT FROM CUR_MPP_SITE INTO @SITE_ID
										     ,@CUTOFF_DATE
										     ,@START_TIME  -- 2019-09-30 kimcd 시업 시간 조건 추가


			WHILE (@@FETCH_STATUS = 0)
				BEGIN	
					-- 2022-05-26 kimcd 일 기준으로 1일 backup 정보 형성 과정 추가 시작
					INSERT INTO [dbo].[FP_DAILY_PRODUCTION_PLAN_CUTOFF_H]
						([CUTOFF_DATE]
						,[COMPANY_ID]
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
						,[FULL_CLEANING_FLAG]
						,[MODEL_TYPE_CHANGE_FLAG]
						,[SEQ]
						,[CELL_MATERIAL_ID]
						,[TOTAL_BATCH]
						,[PIG_CLEANING_FLAG]
						,[SETUP_COLOR_CODE]
						,[SHIFT]) 
					 SELECT @CUTOFF_DATE
						  ,[COMPANY_ID]
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
						  ,@v_proc_name -- [INSERT_ID]
						  ,GETDATE() -- [INSERT_TIME]
						  ,@v_proc_name -- [UPDATE_ID]
						  ,GETDATE() -- [UPDATE_TIME]
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
						  ,[FULL_CLEANING_FLAG]
						  ,[MODEL_TYPE_CHANGE_FLAG]
						  ,[SEQ]
						  ,[CELL_MATERIAL_ID]
						  ,[TOTAL_BATCH]
						  ,[PIG_CLEANING_FLAG]
						  ,[SETUP_COLOR_CODE]
						  ,[SHIFT]
					FROM  FP_DAILY_PRODUCTIOIN_PLAN_H A WITH(NOLOCK)
					WHERE A.PLAN_DATE  >= @CUTOFF_DATE
					AND   A.SITE_ID     = @SITE_ID
					AND   A.PLAN_QTY    > 0
					AND   A.PLAN_TYPE   = 'MPP'  -- 2022-08-23 MPP 추가작업 
					AND   A.PLANT_ID    IN (SELECT  W.SEGMENT1
											FROM   [DBO].[SCM_SYS_LOOKUP_VALUE] W  WITH(NOLOCK)
											WHERE  W.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
											AND    W.ACTIVE_FLAG = 'Y'
											AND    W.ATTRIBUTE7    LIKE @START_TIME + '%' );

					SET @ROWCOUNT = @ROWCOUNT + @@ROWCOUNT
					-- 2022-05-26 kimcd 일 기준으로 1일 backup 정보 형성 과정 추가 끝

					FETCH NEXT FROM CUR_MPP_SITE INTO @SITE_ID
												     ,@CUTOFF_DATE
												     ,@START_TIME  -- 2019-09-30 kimcd 시업 시간 조건 추가

				END

		CLOSE CUR_MPP_SITE;
		DEALLOCATE CUR_MPP_SITE;
		---------------------------------	MPP  END   -------------------------------
		-- 2018-09-04 kimcd W+2주 계획 BACKUP 시작
		DECLARE CUR_W_SITE CURSOR FOR				--INSTANCE 별 발송
			SELECT DISTINCT SITE_ID
				  ,CONVERT(DATE, [dbo].[FN_SITE_TIME] (S.SITE_ID), 120) AS CUTOFF_DATE
			FROM  DBO.SCM_SITE_M S WITH(NOLOCK)
			WHERE ( @P_SITE_ID IS NULL OR SITE_ID = @P_SITE_ID )
			AND   SUBSTRING(CONVERT(NVARCHAR(20), [dbo].[FN_SITE_TIME] (S.SITE_ID), 120), 12, 2) = '00'
			AND   DATEPART( DW, [dbo].[FN_SITE_TIME] (S.SITE_ID) ) = 2
			-- 각 Site별로 일요일 23시에 작업 수행됨
			-- 2019-12-30 kimcd 월요일 00시 기준으로 작업 수행

			OPEN CUR_W_SITE;
			
			FETCH NEXT FROM CUR_W_SITE INTO  @SITE_ID
											,@CUTOFF_DATE


			WHILE (@@FETCH_STATUS = 0)
				BEGIN
					DELETE FROM [dbo].[FP_KPI_DAILY_PRODUCTION_PLAN_H]
					WHERE CUTOFF_DATE  = DATEADD(D, -1, @CUTOFF_DATE) -- 2019-12-30 kimcd 월요일 00시 기준으로 작업 수행하면서 기준 일자 전일로 전환
					AND   SITE_ID      = @SITE_ID
					AND   PLAN_TYPE    = 'W+2_PLAN';

					INSERT INTO [dbo].[FP_KPI_DAILY_PRODUCTION_PLAN_H]
						(  [CUTOFF_DATE]
						  ,[INSTANCE_ID]
						  ,[FP_PLAN_ID]
						  ,[COMPANY_ID]
						  ,[DIVISION_ID]
						  ,[SITE_ID]
						  ,[PLANT_ID]
						  ,[FACTORY_ID]
						  ,[WORK_ORDER_SPL_ID]
						  ,[WORK_ORDER_ID]
						  ,[DEMAND_ID]
						  ,[ITEM_ID]
						  ,[OPERATION_ID]
						  ,[LINE_ID]
						  ,[ELECTRODE_TYPE]
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
						  ,[CELL_IN_QTY]
						  ,[CELL_OUT_QTY]
						  ,[BATCH_IN_QTY]
						  ,[BATCH_OUT_QTY]
						  ,[FIX_TYPE]
						  ,[PRODUCTION_TYPE]
						  ,[LINE_ITEM_SEQ]
						  ,[OPERATION_ITEM_SEQ]
						  ,[MARKET]
						  ,[FP_PRODUCTION_TYPE]
						  ,[INSERT_ID]
						  ,[INSERT_DTTM] 
						  ,[TOP_ITEM_ID]   -- 2018-08-23 KIMCD TOP_ITEM_ID 컬럼 추가
						  ,[PLAN_TYPE])    -- 2018-09-04 kimcd PLAN 유형 추가 '3DAY_FIX'
					-- 2018-10-09 KIMCD 입력 문장 재구성 시작
					SELECT DATEADD(D, -1, @CUTOFF_DATE)   AS [CUTOFF_DATE]  -- 2019-12-30 kimcd 월요일 00시 기준으로 작업 수행하면서 기준 일자 전일로 전환
						  ,A.FACTORY_ID + '^' + A.PLAN_GROUP_ID AS INSTANCE_ID
						  ,CONVERT(NVARCHAR(8), CASE WHEN A.UPDATE_TIME > DATEADD(D, -1, @CUTOFF_DATE) THEN DATEADD(D, -1, @CUTOFF_DATE) ELSE A.UPDATE_TIME END, 112) + '^' + A.FACTORY_ID + '^' + A.PLAN_GROUP_ID AS FP_PLAN_ID
						  -- 2019-12-30 kimcd 월요일 00시 기준으로 작업 수행하면서 기준 일자 전일로 전환
						  -- INSERT_TIME에서 UPDATE_TIME을 수정 2018-11-01 kimcd
						  ,A.[COMPANY_ID]
						  ,A.[DIVISION_ID]
						  ,A.[SITE_ID]
						  ,A.[PLANT_ID]
						  ,A.[FACTORY_ID]
						  ,A.FACTORY_ID + '^' + A.PLAN_GROUP_ID + '^' + CONVERT(NVARCHAR(8), DATEADD(D, -1, @CUTOFF_DATE), 112) + '^' + CONVERT(NVARCHAR,ROW_NUMBER() OVER (ORDER BY PLAN_DATE, LINE_ID, ITEM_ID))  AS WORK_ORDER_SPL_ID
						  ,A.FACTORY_ID + '^' + A.PLAN_GROUP_ID + '^' + CONVERT(NVARCHAR(8), DATEADD(D, -1, @CUTOFF_DATE), 112) + '^' + CONVERT(NVARCHAR,ROW_NUMBER() OVER (ORDER BY PLAN_DATE, LINE_ID, ITEM_ID))  AS WORK_ORDER_ID
						  -- 2019-12-30 kimcd 월요일 00시 기준으로 작업 수행하면서 기준 일자 전일로 전환
						  ,NULL AS DEMAND_ID
						  ,A.[ITEM_ID]
						  ,A.[OPERATION_ID]
						  ,A.[LINE_ID]
						  ,A.[ELECTRODE_TYPE]
						  ,A.[EQUIPMENT_ID]
						  ,A.[PLAN_DATE]
						  ,A.[PLAN_DATE]  AS START_TIME
						  ,A.[PLAN_DATE]  AS END_TIME
						  ,A.[PLAN_QTY]
						  ,A.[PLAN_IN_QTY]
						  ,NULL AS ITEM_UOM
						  ,A.[ROLL_IN_QTY]
						  ,A.[ROLL_OUT_QTY]
						  ,A.[JR_IN_QTY]
						  ,A.[JR_OUT_QTY]
						  ,A.[CELL_IN_QTY]
						  ,A.[CELL_OUT_QTY]
						  ,A.[BATCH_IN_QTY]
						  ,A.[BATCH_OUT_QTY]
						  ,NULL AS FIX_TYPE
						  ,A.[PRODUCTION_TYPE]
						  ,NULL AS LINE_ITEM_SEQ
						  ,NULL AS OPERATION_ITEM_SEQ
						  ,A.[MARKET]
						  ,A.[FP_PRODUCTION_TYPE]
						  ,@v_proc_name
						  ,GETDATE()
						  ,ISNULL(A.[TOP_ITEM_ID],A.[ITEM_ID]) -- 2018-08-23 KIMCD TOP_ITEM_ID 컬럼 추가
						  ,'W+2_PLAN' -- 2018-09-04 kimcd PLAN 유형 추가 
					FROM  FP_DAILY_PRODUCTIOIN_PLAN_H A WITH(NOLOCK)
						 ,SCM_OPERATION_M             O WITH(NOLOCK)
					WHERE A.PLAN_DATE  >= DATEADD(DD,-7,@CUTOFF_DATE) -- 2019-12-30 kimcd 월요일 00시 기준으로 작업 수행하면서 -6에서 -7로 변경
					AND   A.PLAN_DATE  <= DATEADD(DD, 6,@CUTOFF_DATE) -- 2019-12-30 kimcd 월요일 00시 기준으로 작업 수행하면서 7에서 6으로 변경
					AND   A.COMPANY_ID   = O.COMPANY_ID
					AND   A.DIVISION_ID  = O.DIVISION_ID
					AND   A.SITE_ID      = O.SITE_ID
					AND   A.OPERATION_ID = O.OPERATION_ID
					AND   O.WO_FLAG      = 'Y'
					AND   A.SITE_ID      = @SITE_ID
					AND   A.PLAN_QTY     > 0
					AND   A.PLAN_TYPE    = 'RELEASE'
					-- 2018-10-09 KIMCD 입력 문장 재구성 끝

					SET @ROWCOUNT = @ROWCOUNT + @@ROWCOUNT

                    ----------------------------------------------------------------
					-- 2020-01-15 kimcd Release, WPP 계획을 별도 계획 이력으로 형성
					SELECT @YYYYWW = [ISO_YYYYWW]
					FROM [DBO].[TH_UIS_CAL] WITH(NOLOCK)
					WHERE [DT] = DATEADD(D, -1, @CUTOFF_DATE)

					DELETE FROM [dbo].[FP_DAILY_PRODUCTION_PLAN_DW_H]
					WHERE YYYYWW       = @YYYYWW
					AND   SITE_ID      = @SITE_ID;

					INSERT INTO [dbo].[FP_DAILY_PRODUCTION_PLAN_DW_H]
						(  [YYYYWW]
						  ,[COMPANY_ID]
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
						  ,[FULL_CLEANING_FLAG]
						  ,[MODEL_TYPE_CHANGE_FLAG]
						  ,[SEQ]
						  ,[CELL_MATERIAL_ID]
						  ,[TOTAL_BATCH]
						  ,[PIG_CLEANING_FLAG]
						  ,[SETUP_COLOR_CODE] )
					SELECT @YYYYWW
					      ,MAX([COMPANY_ID])
						  ,MAX([DIVISION_ID])
						  ,MAX([SITE_ID])
						  ,MAX([PLANT_ID])
						  ,[FACTORY_ID]
						  ,MAX([PLAN_GROUP_ID])
						  ,[INSTANCE_TYPE]
						  ,[TOP_ITEM_ID]
						  ,[ITEM_ID]
						  ,[OPERATION_ID]
						  ,MAX([LOCATION])
						  ,MAX([PRODUCTION_TYPE])
						  ,[MARKET]
						  ,[LINE_ID]
						  ,MAX([ELECTRODE_TYPE])
						  ,[PLAN_DATE]
						  ,SUM([PLAN_QTY])
						  ,SUM([PLAN_IN_QTY])
						  ,@v_proc_name -- [INSERT_ID]
						  ,GETDATE() -- [INSERT_TIME]
						  ,@v_proc_name -- [UPDATE_ID]
						  ,GETDATE() -- [UPDATE_TIME]
						  ,[PLAN_TYPE]
						  ,[EQUIPMENT_ID]
						  ,[FP_PRODUCTION_TYPE]
						  ,SUM([ROLL_IN_QTY])
						  ,SUM([ROLL_OUT_QTY])
						  ,SUM([JR_IN_QTY])
						  ,SUM([JR_OUT_QTY])
						  ,SUM([BATCH_IN_QTY])
						  ,SUM([BATCH_OUT_QTY])
						  ,SUM([CELL_IN_QTY])
						  ,SUM([CELL_OUT_QTY])
						  ,MAX([FULL_CLEANING_FLAG])
						  ,MAX([MODEL_TYPE_CHANGE_FLAG])
						  ,MAX([SEQ])
						  ,MAX([CELL_MATERIAL_ID])
						  ,SUM([TOTAL_BATCH])
						  ,MAX([PIG_CLEANING_FLAG])
						  ,MAX([SETUP_COLOR_CODE])
					FROM  FP_DAILY_PRODUCTIOIN_PLAN_H A WITH(NOLOCK)
					WHERE A.PLAN_DATE  >= DATEADD(D, -7, @CUTOFF_DATE)
					AND   A.SITE_ID     = @SITE_ID
					AND   A.PLAN_QTY    > 0
					AND   A.PLAN_TYPE  IN ( 'RELEASE', 'WPP')
					GROUP BY [FACTORY_ID]
							,[INSTANCE_TYPE]
							,[PLAN_TYPE]
							,[ITEM_ID]
							,[LINE_ID]
							,[PLAN_DATE]
							,[TOP_ITEM_ID]
							,[OPERATION_ID]
							,[FP_PRODUCTION_TYPE]
							,[MARKET]
							,[EQUIPMENT_ID]  -- 2022-11-18 kimcd 전극 버전별 계획 수립에 따른 계획 합산으로 로직 보완

					--SET @ROWCOUNT = @ROWCOUNT + @@ROWCOUNT
					-- 2020-01-15 kimcd Release, WPP 계획을 별도로 형성
					----------------------------------------------------------------

					FETCH NEXT FROM CUR_W_SITE INTO  @SITE_ID
													,@CUTOFF_DATE

				END

		CLOSE CUR_W_SITE;
		DEALLOCATE CUR_W_SITE;
		-- 2018-09-04 kimcd W+2주 계획 BACKUP 끝
		--------------------------------------------------------------------------------

		-- ================================================
		-- 로직 추가 end
		-- ================================================
		-- COMMIT TRAN 2022-05-26 kimcd transaction 종료 제거

		EXEC PR_XIF_LOG @v_proc_name, NULL, 'END', @ROWCOUNT, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
		
	END TRY

	BEGIN CATCH

	    ROLLBACK TRAN
		-- 에러나도 로그는 인서트
		SET @v_descr = ERROR_MESSAGE()
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate

	END CATCH

END
