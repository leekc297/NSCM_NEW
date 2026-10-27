
CREATE PROCEDURE [dbo].[PR_XIF_DW_LOSS_TIME_R]

-- ================================================================================================
-- Program ID          : FP02431
-- Program Name        : PR_XIF_DW_LOSS_TIME_R
-- Param               :
-- Batch Period        : 1DAY
-- Description         :
--
-- Source System       : DW
-- Destination System  : FP SDB
-- Source Table        : XIF_DW_RECEIVE_LOSS_TIME_R
-- Destination Table   : FP_DW_LOSS_M
--
-- Create Date		   : 2019.08.30
-- Update Date		   : 2024.06.12
-- Author              : PIYONG
-- Version             : 1.0
--                       2.0 2021-01-16 kimcd Loss 수신에서 Loss 이력 형성, Calender 이력 형성
--                                            [FP_DW_LOSS_M]에 [LOSS_TIME_SUM] [numeric](20, 0) NULL 컬럼 추가됨
--                       2.1 2021-03-25 kimcd Loss 수식 산출 수식 변경. 월별 가용 시간 - 비가동 - 비부하 제외한 시간을 분모로 함
--                       2.2 2021-09-17 kimcd M10 성능가동률, M11 양품률 정보 추가 수신
--                                            폴란드 전극 후 공정은 MES 라인 기준으로 집계
--                       2.3 2021-10-27 kimcd M10 성능가동률, M12 양품률 분자 분모 계산 로직 수정
--                                            Loss Time / Loss CNT
--                       2.4 2022-07-25 leeseongmin 전월여부확인하여 수신 일자 범위에서 수정 안 된 정보를 삭제 (C20220713-000530)
--                       2.5 2023-06-05 kimcd AVAILABLE_TIME - 0 시간 오류 보완
--                       2.6 2024-06-12 kimcd Loss 실적을 WA.FP로 전송 과정 추가
-- ================================================================================================
@P_SITE_ID  NVARCHAR(50) = NULL
,@P_BASIS_START_TIME  NVARCHAR(6) = NULL
,@P_MAKE_DAY NVARCHAR(10) = NULL

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_DW_LOSS_TIME_R'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	   = 0
	DECLARE @sysdate     DATETIME2     = GETDATE()
	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)

	DECLARE @TOTAL_TIME  NUMERIC(20, 0)  -- 2021-03-25 kimcd 전월 전체 가동 시간 - 초
	DECLARE @SUM_TABLE table
			( COMPANY_ID      NVARCHAR(30)
			, DIVISION_ID     NVARCHAR(30)
			, [SITE_ID]       NVARCHAR(30)
			, [PLANT_ID]      NVARCHAR(30)
			, [FACTORY_ID]    NVARCHAR(30)
			, [LINE_ID]       NVARCHAR(30)
			, [OPERATION_ID]  NVARCHAR(30)
			, [EQUIPMENT_ID]  NVARCHAR(30)
			, [ELECTRODE_TYPE] NVARCHAR(30)
			, [LOSS_TIME_SUM] NUMERIC(20, 0)
			) -- 2021-03-25 kimcd 비가동 - 비부하 합산 시간 저장용 임시 테이블

	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

	BEGIN TRY				

		BEGIN TRAN
		-- ================================================
		-- 로직 추가
		-- ================================================

			DELETE A
			  FROM SY_XIF_DW_RECEIVE_LOSS_TIME_R A
				   ,(
						SELECT [IFSEQNO]
							   ,[SITE_ID]
							   ,[PLANT_ID]
							   ,[AREA_ID]
							   ,[LINE_ID]
							   ,[PROCESS_ID]
							   ,[EQPT_ID]
							   ,[WORK_DATE]
							   ,[MEASURE_CODE]
						  FROM (
								SELECT [IFSEQNO]
									   ,[SITE_ID]
									   ,[PLANT_ID]
									   ,[AREA_ID]
									   ,[LINE_ID]
									   ,[PROCESS_ID]
									   ,[EQPT_ID]
									   ,[WORK_DATE]
									   ,[MEASURE_CODE]
									   ,ROW_NUMBER() OVER (PARTITION BY [SITE_ID], [PLANT_ID], [AREA_ID], [LINE_ID], [PROCESS_ID], [EQPT_ID], [MEASURE_CODE], [WORK_DATE]
															   ORDER BY SORT_ORDER, [CREATE_DATE] DESC																		) AS NUM
								  FROM SY_XIF_DW_RECEIVE_LOSS_TIME_R as x
	 							 WHERE x.[SITE_iD] = @P_SITE_ID
								   AND X.[PLANT_ID] IN (
														SELECT Y.MES_PLANT_ID
														  FROM SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
														       INNER JOIN SCM_FACTORY_M AS Y with(nolock)
				                                                   ON SLV.SEGMENT1 = Y.PLANT_ID
														 WHERE SLV.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
														   AND SLV.SEGMENT2 = @P_BASIS_START_TIME
														GROUP BY Y.MES_PLANT_ID
													 )
							   ) A
						 WHERE NUM > 1
				   ) B
			 WHERE A.IFSEQNO		= B.IFSEQNO
			   AND A.SITE_ID		= B.SITE_ID
			   AND A.PLANT_ID		= B.PLANT_ID
			   AND A.AREA_ID		= B.AREA_ID
			   AND A.LINE_ID		= B.LINE_ID
			   AND A.PROCESS_ID		= B.PROCESS_ID
			   AND A.[EQPT_ID]		= B.[EQPT_ID]
			   AND A.MEASURE_CODE	= B.MEASURE_CODE
   			   AND A.WORK_DATE		= B.WORK_DATE

			-- 2022-07-25 leeseongmin 수신 일자 범위에서 수정 안 된 정보 삭제
			IF EXISTS
			--전월 여부 조건
                   (SELECT TOP 1 [WORK_DATE]
				    FROM   SY_XIF_DW_RECEIVE_LOSS_TIME_R
					WHERE  [SITE_ID]   = @P_SITE_ID
					AND    [PLANT_ID] IN ( SELECT SEGMENT1
										   FROM   SCM_SYS_LOOKUP_VALUE
										   WHERE  LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
										   AND    SEGMENT2         = @P_BASIS_START_TIME )
					AND    [WORK_DATE]   < CONVERT(NVARCHAR(8), DATEADD(mm, DATEDIFF(mm,0,GETDATE()), 0), 112)
					AND    [MODIFY_DATE] > CONVERT(DATE, GETDATE()))

				BEGIN
					--전월데이터가 있으면   전월과 이번달까지삭제
					DELETE A
					FROM   SY_XIF_DW_RECEIVE_LOSS_TIME_R A
					WHERE  [SITE_ID] = @P_SITE_ID
					AND    [PLANT_ID] IN ( SELECT SEGMENT1
										   FROM   SCM_SYS_LOOKUP_VALUE
										   WHERE  LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
										   AND    SEGMENT2         = @P_BASIS_START_TIME )
					AND    [WORK_DATE]  >= CONVERT(NVARCHAR(8), DATEADD(mm, DATEDIFF(mm,0,GETDATE())-1, 0), 112)
					AND    [MODIFY_DATE] < CONVERT(DATE, GETDATE())
			    END

			 ELSE

				BEGIN
					-- 전월데이터가 없으면   이번달만 삭제
			        DELETE A
			        FROM   SY_XIF_DW_RECEIVE_LOSS_TIME_R A
			        WHERE  [SITE_ID] = @P_SITE_ID
			        AND    [PLANT_ID] IN ( SELECT SEGMENT1
			        					   FROM   SCM_SYS_LOOKUP_VALUE
			        					   WHERE  LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
			        					   AND    SEGMENT2         = @P_BASIS_START_TIME )
			        AND    [WORK_DATE]  >= CONVERT(NVARCHAR(8), DATEADD(mm, DATEDIFF(mm,0,GETDATE()), 0), 112)
			        AND    [MODIFY_DATE] < CONVERT(DATE, GETDATE());
			    END



			IF DAY( GETDATE()) >= 5	AND DAY( GETDATE()) <= 15 -- 매월 5일만 실행, 15일까지 11일간 수행. 마감 지연 대비. 2021-10-27
				BEGIN
					DELETE FP_DW_LOSS_M
					WHERE  [SITE_ID]  =  @P_SITE_ID
				    AND    [PLANT_ID] IN (	SELECT SEGMENT1
											FROM   SCM_SYS_LOOKUP_VALUE
											WHERE  LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
											AND    SEGMENT2 = @P_BASIS_START_TIME
											); -- 2021-01-16 kimcd 임시 정보 초기화


					INSERT INTO FP_DW_LOSS_M
						([SITE_ID]
						,[PLANT_ID]
						,[FACTORY_ID]
						,[LINE_ID]
						,[OPERATION_ID]
						,[EQUIPMENT_ID]
						,[MEASURE_CODE]
						,[MEASURE_NAME_KO]
						,[MEASURE_NAME_EN]
						,[MEASURE_NAME_ZH]
						,[MEASURE_NAME_PL]
						,[LEVEL_1_KO]
						,[LEVEL_2_KO]
						,[LEVEL_3_KO]
						,[LEVEL_4_KO]
						,[LEVEL_1_EN]
						,[LEVEL_2_EN]
						,[LEVEL_3_EN]
						,[LEVEL_4_EN]
						,[LEVEL_1_ZH]
						,[LEVEL_2_ZH]
						,[LEVEL_3_ZH]
						,[LEVEL_4_ZH]
						,[LEVEL_1_PL]
						,[LEVEL_2_PL]
						,[LEVEL_3_PL]
						,[LEVEL_4_PL]
						,[LOSS_CNT]
						,[LOSS_TIME]
						,[SORT_ORDER]
						,[INSERT_ID]
						,[INSERT_DATE]
						,[UPDATE_ID]
						,[UPDATE_DATE])
					SELECT   XIF.[SITE_ID]
							,XIF.[PLANT_ID]
							,XIF.[AREA_ID]
							,E.[LINE_ID]
							,XIF.[PROCESS_ID]
							,XIF.[EQPT_ID]
							,XIF.[MEASURE_CODE]
							,MAX( [MEASURE_NAME_KO] ) AS [MEASURE_NAME_KO]
							,MAX( [MEASURE_NAME_EN] ) AS [MEASURE_NAME_EN]
							,MAX( [MEASURE_NAME_ZH] ) AS [MEASURE_NAME_ZH]
							,MAX( [MEASURE_NAME_PL] ) AS [MEASURE_NAME_PL]
							,MAX( [LEVEL_1_KO] ) AS [LEVEL_1_KO]
							,MAX( [LEVEL_2_KO] ) AS [LEVEL_2_KO]
							,MAX( [LEVEL_3_KO] ) AS [LEVEL_3_KO]
							,MAX( [LEVEL_4_KO] ) AS [LEVEL_4_KO]
							,MAX( [LEVEL_1_EN] ) AS [LEVEL_1_EN]
							,MAX( [LEVEL_2_EN] ) AS [LEVEL_2_EN]
							,MAX( [LEVEL_3_EN] ) AS [LEVEL_3_EN]
							,MAX( [LEVEL_4_EN] ) AS [LEVEL_4_EN]
							,MAX( [LEVEL_1_ZH] ) AS [LEVEL_1_ZH]
							,MAX( [LEVEL_2_ZH] ) AS [LEVEL_2_ZH]
							,MAX( [LEVEL_3_ZH] ) AS [LEVEL_3_ZH]
							,MAX( [LEVEL_4_ZH] ) AS [LEVEL_4_ZH]
							,MAX( [LEVEL_1_PL] ) AS [LEVEL_1_PL]
							,MAX( [LEVEL_2_PL] ) AS [LEVEL_2_PL]
							,MAX( [LEVEL_3_PL] ) AS [LEVEL_3_PL]
							,MAX( [LEVEL_4_PL] ) AS [LEVEL_4_PL]
							,AVG( CAST( REPLACE( [LOSS_CNT], 'null', 0 ) AS float ) ) AS [LOSS_CNT]
							,AVG( CAST( REPLACE( [LOSS_TIME], 'null', 0 ) AS float ) ) AS [LOSS_TIME]
							,MAX( [SORT_ORDER] ) AS [SORT_ORDER]
							,'PR_XIF_DW_LOSS_TIME_R'
							,GETDATE()
							,'PR_XIF_DW_LOSS_TIME_R'
							,GETDATE()
					FROM SY_XIF_DW_RECEIVE_LOSS_TIME_R XIF
						INNER JOIN SCM_EQUIPMENT_M  E
									ON  XIF.[SITE_ID]		= E.SITE_ID
									AND XIF.[PLANT_ID]		= E.PLANT_ID
									AND XIF.[AREA_ID]		= E.FACTORY_ID
 									AND XIF.[EQPT_ID]		= E.EQUIPMENT_ID
									AND XIF.[PROCESS_ID]	= E.OPERATION_ID
 									AND XIF.[LINE_ID]		= E.MES_LINE_ID
					WHERE XIF.[SITE_ID] = @P_SITE_ID
					AND XIF.[PROCESS_ID] IN ('E3000', 'E4000') -- 2021-01-16 kimcd 전극 후 공정으로 제한
					AND XIF.[PLANT_ID] IN (
										SELECT SEGMENT1
											FROM SCM_SYS_LOOKUP_VALUE
											WHERE LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
											AND SEGMENT2 = @P_BASIS_START_TIME
										)
					AND [WORK_DATE]	>= CONVERT( NVARCHAR(8), DATEADD(DAY, CAST(@P_MAKE_DAY AS NUMERIC), GETDATE() ), 112 )
					GROUP BY XIF.[SITE_ID]
							,XIF.[PLANT_ID]
							,XIF.[AREA_ID]
							,E.[LINE_ID]
							,XIF.[PROCESS_ID]
							,XIF.[EQPT_ID]
							,XIF.[MEASURE_CODE];

					--전극 후 공정  LOSS 생성
					MERGE INTO SCM_LINE_LOSS_M M
					USING (
							SELECT A.[COMPANY_ID]
								   ,A.[DIVISION_ID]
								   ,A.[SITE_ID]
								   ,A.[PLANT_ID]
								   ,A.[FACTORY_ID]
								   ,A.[OPERATION_ID]
								   ,A.[LINE_ID]
								   ,A.[ELECTRODE_TYPE]
								   ,ISNULL(B.EQU_CNT,1) AS EQU_CNT  --설비 수
								   ,ROUND(((A.LOSS_TIME/ISNULL(B.EQU_CNT,1))/86400), 4) AS LOSS_RATE  -- LOSS 시간 / 설비 / 하루의 초
								   ,C.[MONTH]
							  FROM (
    								SELECT B.[COMPANY_ID]
										   , B.[DIVISION_ID]
										   , A.SITE_ID
										   , A.PLANT_ID
										   , A.FACTORY_ID
										   , A.LINE_ID
										   , A.OPERATION_ID
										   , B.ELECTRODE_TYPE
    									   , SUM(LOSS_TIME) AS LOSS_TIME
    								  FROM FP_DW_LOSS_M A WITH(NOLOCK)
    									   INNER JOIN SCM_EQUIPMENT_M B WITH(NOLOCK)					-- FP에 등록되어 사용 중인 설비의 LOSS 정보 만 생성
    											   ON A.SITE_ID			= B.SITE_ID
    											  AND A.PLANT_ID		= B.PLANT_ID
    											  AND A.FACTORY_ID		= B.FACTORY_ID
    											  AND A.LINE_ID			= B.LINE_ID
    											  AND A.OPERATION_ID	= B.OPERATION_ID
    											  AND A.EQUIPMENT_ID	= B.EQUIPMENT_ID
												  AND B.EQUIPMENT_TYPE  = 'M'   -- 2021-01-16 kimcd Main 설비, 현재 사용하는 설비로만 제한
    											  AND B.ACTIVE_FLAG		= 'Y'
    											WHERE A.OPERATION_ID IN ('E3000', 'E4000')
												  AND A.MEASURE_CODE IN ( SELECT A.SEGMENT1
    																		FROM SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)
    																	   WHERE A.LOOKUP_TYPE_CODE = 'LOSS_TIME_MEASURE_CODE'
																			 AND ATTRIBUTE3 = 'Y'
						    											)
				  								  AND A.[SITE_ID]  =  @P_SITE_ID
												  AND A.[PLANT_ID] IN (	SELECT SEGMENT1
																		FROM   SCM_SYS_LOOKUP_VALUE
																		WHERE  LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
																		AND    SEGMENT2 = @P_BASIS_START_TIME
																		) -- 2021-01-16 kimcd Site Plant 제한
    											GROUP BY B.[COMPANY_ID]
													  , B.[DIVISION_ID]
													  , A.SITE_ID
													  , A.PLANT_ID
													  , A.FACTORY_ID
													  , A.LINE_ID
													  , A.OPERATION_ID
													  , B.ELECTRODE_TYPE
    							   ) A
    							   LEFT OUTER JOIN (												-- 사용 중인 설비 정보 만 생성
    												SELECT A.SITE_ID
														   , A.PLANT_ID
														   , A.FACTORY_ID
														   , A.LINE_ID
														   , A.OPERATION_ID
														   , A.ELECTRODE_TYPE
														   , COUNT(*) AS EQU_CNT
    												  FROM SCM_EQUIPMENT_M A WITH(NOLOCK)
    												 WHERE A.ACTIVE_FLAG = 'Y'
													 AND   A.EQUIPMENT_TYPE  = 'M'   -- 2021-01-16 kimcd Main 설비, 현재 사용하는 설비로만 제한
    												 GROUP BY A.SITE_ID
														   , A.PLANT_ID
														   , A.FACTORY_ID
														   , A.LINE_ID
														   , A.OPERATION_ID
														   , A.ELECTRODE_TYPE
    											   ) B
    											ON A.SITE_ID        = B.SITE_ID
    										   AND A.PLANT_ID       = B.PLANT_ID
    										   AND A.FACTORY_ID     = B.FACTORY_ID
    										   AND A.LINE_ID        = B.LINE_ID
    										   AND A.OPERATION_ID   = B.OPERATION_ID
    										   AND A.ELECTRODE_TYPE = B.ELECTRODE_TYPE
								   ,(
										SELECT DISTINCT [YEAR]+[MONTH] AS [MONTH]
										  FROM SCM_SYS_CALENDAR_M
										 WHERE [YEAR]+[MONTH] BETWEEN CONVERT(NVARCHAR(6),GETDATE(), 112)
										   AND CONVERT(NVARCHAR(6),DATEADD(MM, 5, GETDATE()), 112)
									) C

							) D
						ON (
							M.[COMPANY_ID]			= D.[COMPANY_ID]
							AND M.[DIVISION_ID]		= D.[DIVISION_ID]
							AND M.[SITE_ID]			= D.[SITE_ID]
							AND M.[PLANT_ID]		= D.[PLANT_ID]
							AND M.[FACTORY_ID]		= D.[FACTORY_ID]
							AND M.[OPERATION_ID]	= D.[OPERATION_ID]
							AND M.[LINE_ID]			= D.[LINE_ID]
							AND M.[ELECTRODE_TYPE]	= D.[ELECTRODE_TYPE]
							AND M.[MONTH]			= D.[MONTH]
						   )
					WHEN MATCHED THEN
						UPDATE
							SET LOSS_RATE		= D.LOSS_RATE
								, UPDATE_ID		= 'PR_XIF_DW_LOSS_TIME_R'
								, UPDATE_TIME	= GETDATE()
					WHEN NOT MATCHED THEN
						INSERT (
							[COMPANY_ID]
						    ,[DIVISION_ID]
						    ,[SITE_ID]
						    ,[PLANT_ID]
						    ,[FACTORY_ID]
						    ,[OPERATION_ID]
						    ,[LINE_ID]
						    ,[ELECTRODE_TYPE]
						    ,[MONTH]
						    ,[LOSS_RATE]
							,[INSERT_ID]
							,[INSERT_TIME]
							,[UPDATE_ID]
							,[UPDATE_TIME]
						) VALUES (
							D.[COMPANY_ID]
						    ,D.[DIVISION_ID]
						    ,D.[SITE_ID]
						    ,D.[PLANT_ID]
						    ,D.[FACTORY_ID]
						    ,D.[OPERATION_ID]
						    ,D.[LINE_ID]
						    ,D.[ELECTRODE_TYPE]
						    ,D.[MONTH]
						    ,D.[LOSS_RATE]
							,'PR_XIF_DW_LOSS_TIME_R'
							,GETDATE()
							,'PR_XIF_DW_LOSS_TIME_R'
							,GETDATE()
						)
					;

					-- 2021-01-16 kimcd Loss 이력 형성 시작
					DELETE FP_DW_LOSS_M
					WHERE  [SITE_ID]  =  @P_SITE_ID
				    AND    [PLANT_ID] IN (	SELECT SEGMENT1
											FROM   SCM_SYS_LOOKUP_VALUE
											WHERE  LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
											AND    SEGMENT2 = @P_BASIS_START_TIME
											);

					INSERT INTO FP_DW_LOSS_M
						([SITE_ID]
						,[PLANT_ID]
						,[FACTORY_ID]
						,[LINE_ID]
						,[OPERATION_ID]
						,[EQUIPMENT_ID]
						,[MEASURE_CODE]
						,[MEASURE_NAME_KO]
						,[MEASURE_NAME_EN]
						,[MEASURE_NAME_ZH]
						,[MEASURE_NAME_PL]
						,[LEVEL_1_KO]
						,[LEVEL_2_KO]
						,[LEVEL_3_KO]
						,[LEVEL_4_KO]
						,[LEVEL_1_EN]
						,[LEVEL_2_EN]
						,[LEVEL_3_EN]
						,[LEVEL_4_EN]
						,[LEVEL_1_ZH]
						,[LEVEL_2_ZH]
						,[LEVEL_3_ZH]
						,[LEVEL_4_ZH]
						,[LEVEL_1_PL]
						,[LEVEL_2_PL]
						,[LEVEL_3_PL]
						,[LEVEL_4_PL]
						,[LOSS_CNT]
						,[LOSS_TIME]
						,[SORT_ORDER]
						,[INSERT_ID]
						,[INSERT_DATE]
						,[UPDATE_ID]
						,[UPDATE_DATE]
						,[LOSS_TIME_SUM]   -- 달 기준으로 LOSS 시간 총 합 구하기
						,[LOSS_CNT_SUM]) -- 2021-10-27 kimcd 컬럼 추가
 					SELECT   XIF.[SITE_ID]
							,XIF.[PLANT_ID]
							,XIF.[AREA_ID]
							,E.[LINE_ID]
							,XIF.[PROCESS_ID]
							,XIF.[EQPT_ID]
							,XIF.[MEASURE_CODE]
							,MAX( [MEASURE_NAME_KO] ) AS [MEASURE_NAME_KO]
							,MAX( [MEASURE_NAME_EN] ) AS [MEASURE_NAME_EN]
							,MAX( [MEASURE_NAME_ZH] ) AS [MEASURE_NAME_ZH]
							,MAX( [MEASURE_NAME_PL] ) AS [MEASURE_NAME_PL]
							,MAX( [LEVEL_1_KO] ) AS [LEVEL_1_KO]
							,MAX( [LEVEL_2_KO] ) AS [LEVEL_2_KO]
							,MAX( [LEVEL_3_KO] ) AS [LEVEL_3_KO]
							,MAX( [LEVEL_4_KO] ) AS [LEVEL_4_KO]
							,MAX( [LEVEL_1_EN] ) AS [LEVEL_1_EN]
							,MAX( [LEVEL_2_EN] ) AS [LEVEL_2_EN]
							,MAX( [LEVEL_3_EN] ) AS [LEVEL_3_EN]
							,MAX( [LEVEL_4_EN] ) AS [LEVEL_4_EN]
							,MAX( [LEVEL_1_ZH] ) AS [LEVEL_1_ZH]
							,MAX( [LEVEL_2_ZH] ) AS [LEVEL_2_ZH]
							,MAX( [LEVEL_3_ZH] ) AS [LEVEL_3_ZH]
							,MAX( [LEVEL_4_ZH] ) AS [LEVEL_4_ZH]
							,MAX( [LEVEL_1_PL] ) AS [LEVEL_1_PL]
							,MAX( [LEVEL_2_PL] ) AS [LEVEL_2_PL]
							,MAX( [LEVEL_3_PL] ) AS [LEVEL_3_PL]
							,MAX( [LEVEL_4_PL] ) AS [LEVEL_4_PL]
							,AVG( CAST( REPLACE( [LOSS_CNT], 'null', 0 ) AS float ) ) AS [LOSS_CNT]
							,AVG( CAST( REPLACE( [LOSS_TIME], 'null', 0 ) AS float ) ) AS [LOSS_TIME]
							,MAX( [SORT_ORDER] ) AS [SORT_ORDER]
							,'PR_XIF_DW_LOSS_TIME_R'
							,GETDATE()
							,'PR_XIF_DW_LOSS_TIME_R'
							,GETDATE()
							,SUM( CAST( REPLACE( [LOSS_TIME], 'null', 0 ) AS float ) ) AS [LOSS_TIME_SUM] -- 달 기준으로 LOSS 시간 총 합 구하기
							,SUM( CAST( REPLACE( [LOSS_CNT], 'null', 0 ) AS float ) ) AS [LOSS_CNT_SUM] -- 2021-10-27 kimcd 달 기준으로 LOSS CNT 총 합 구하기
					FROM SY_XIF_DW_RECEIVE_LOSS_TIME_R XIF
						INNER JOIN SCM_EQUIPMENT_M  E (NOLOCK)
								ON  XIF.[SITE_ID]		= E.SITE_ID
								AND XIF.[PLANT_ID]		= E.PLANT_ID
								AND XIF.[AREA_ID]		= E.FACTORY_ID
 								AND XIF.[EQPT_ID]		= E.EQUIPMENT_ID
								AND XIF.[PROCESS_ID]	= E.OPERATION_ID
 								AND XIF.[LINE_ID]		= E.MES_LINE_ID
					WHERE XIF.[SITE_ID] = @P_SITE_ID
					AND XIF.[PLANT_ID] IN (
											SELECT SEGMENT1
											FROM SCM_SYS_LOOKUP_VALUE (NOLOCK)
											WHERE LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
											AND SEGMENT2 = @P_BASIS_START_TIME
											)
					AND [WORK_DATE]	>= DATEADD(mm, DATEDIFF(mm,0,GETDATE())-1, 0) -- 전달 1일
					AND [WORK_DATE]	 < DATEADD(mm, DATEDIFF(mm,0,GETDATE()), 0)   -- 이번달 1일
					GROUP BY XIF.[SITE_ID]
							,XIF.[PLANT_ID]
							,XIF.[AREA_ID]
							,E.[LINE_ID]
							,XIF.[PROCESS_ID]
							,XIF.[EQPT_ID]
							,XIF.[MEASURE_CODE]

 					-- 2021-03-25 kimcd 비가동 - 비부하 합산 시간 저장 시작
					SELECT @TOTAL_TIME = DATEDIFF( SS, DATEADD(mm, DATEDIFF(mm,0,GETDATE())-1, 0), DATEADD(mm, DATEDIFF(mm,0,GETDATE()), 0))
					DELETE FROM @SUM_TABLE
					INSERT INTO @SUM_TABLE
						( [COMPANY_ID]
						, [DIVISION_ID]
						, [SITE_ID]
						, [PLANT_ID]
						, [FACTORY_ID]
						, [LINE_ID]
						, [OPERATION_ID]
						, [EQUIPMENT_ID]
						, [ELECTRODE_TYPE]
						, [LOSS_TIME_SUM])
					SELECT MAX(E.[COMPANY_ID])
						, MAX(E.[DIVISION_ID])
						, DL.[SITE_ID]
						, DL.[PLANT_ID]
						, DL.[FACTORY_ID]
						, DL.[LINE_ID]
						, DL.[OPERATION_ID]
						, DL.[EQUIPMENT_ID]
						, MAX(ISNULL(E.ELECTRODE_TYPE,'-'))
						, SUM(DL.[LOSS_TIME_SUM])
					FROM FP_DW_LOSS_M DL
						INNER JOIN SCM_EQUIPMENT_M  E (NOLOCK)
						ON  DL.[SITE_ID]	  = E.SITE_ID
						AND DL.[PLANT_ID]	  = E.PLANT_ID
						AND DL.[FACTORY_ID]	  = E.FACTORY_ID
 						AND DL.[EQUIPMENT_ID] = E.EQUIPMENT_ID
						AND DL.[OPERATION_ID] = E.OPERATION_ID
 						AND DL.[LINE_ID]	  = E.LINE_ID
						AND E.EQUIPMENT_TYPE  = 'M'
						AND E.ACTIVE_FLAG	  = 'Y'
					WHERE DL.[SITE_ID] = @P_SITE_ID
					AND DL.[PLANT_ID] IN (  SELECT SEGMENT1
											FROM SCM_SYS_LOOKUP_VALUE
											WHERE LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
											AND SEGMENT2 = @P_BASIS_START_TIME )
    				AND DL.MEASURE_CODE IN (SELECT A.SEGMENT1
    										FROM SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)
    										WHERE A.LOOKUP_TYPE_CODE = 'CAPA_UI_LOSS_TYPE_DEFINIT'  -- 'LOSS_TYPE_DEFINITION'
											AND A.ACTIVE_FLAG = 'Y'
											AND A.ATTRIBUTE1 IN ('Not-Available', 'No-Load') )
					GROUP BY DL.[SITE_ID]
							, DL.[PLANT_ID]
							, DL.[FACTORY_ID]
							, DL.[LINE_ID]
							, DL.[OPERATION_ID]
							, DL.[EQUIPMENT_ID]

					INSERT INTO @SUM_TABLE
						( [COMPANY_ID]
						, [DIVISION_ID]
						, [SITE_ID]
						, [PLANT_ID]
						, [FACTORY_ID]
						, [LINE_ID]
						, [OPERATION_ID]
						, [EQUIPMENT_ID]
						, [ELECTRODE_TYPE]
						, [LOSS_TIME_SUM])
					SELECT [COMPANY_ID]
						, [DIVISION_ID]
						, [SITE_ID]
						, [PLANT_ID]
						, [FACTORY_ID]
						, [LINE_ID]
						, [OPERATION_ID]
						, [EQUIPMENT_ID]
						, ISNULL(ELECTRODE_TYPE,'-')
						, 0
					FROM  SCM_EQUIPMENT_M EM (NOLOCK)
					WHERE EM.[SITE_ID] = @P_SITE_ID
					AND   EM.[PLANT_ID] IN (SELECT SEGMENT1
											FROM SCM_SYS_LOOKUP_VALUE (NOLOCK)
											WHERE LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
											AND SEGMENT2 = @P_BASIS_START_TIME )
					AND   EM.EQUIPMENT_TYPE = 'M'
    				AND   EM.ACTIVE_FLAG	= 'Y'
					AND   EXISTS (  SELECT 1
					                FROM   @SUM_TABLE X
									WHERE  X.[SITE_ID]      = EM.[SITE_ID]
									AND    X.[PLANT_ID]     = EM.[PLANT_ID]
									AND    X.[FACTORY_ID]   = EM.[FACTORY_ID]
									AND    X.[LINE_ID]      = EM.[LINE_ID]
									AND    X.[OPERATION_ID] = EM.[OPERATION_ID]
									AND    X.[ELECTRODE_TYPE] = EM.[ELECTRODE_TYPE])
					AND   NOT EXISTS (  SELECT 1
					                    FROM   @SUM_TABLE X
									    WHERE  X.[SITE_ID]      = EM.[SITE_ID]
										AND    X.[PLANT_ID]     = EM.[PLANT_ID]
										AND    X.[FACTORY_ID]   = EM.[FACTORY_ID]
										AND    X.[LINE_ID]      = EM.[LINE_ID]
										AND    X.[OPERATION_ID] = EM.[OPERATION_ID]
										AND    X.[EQUIPMENT_ID] = EM.[EQUIPMENT_ID])
					-- 2021-03-25 kimcd 비가동 - 비부하 합산 시간 저장 끝

					-- 2021-09-17 kimcd 폴란드 전극 후 공정 라인의 MES 라인 정보 추가 시작
					INSERT INTO @SUM_TABLE
						( [COMPANY_ID]
						, [DIVISION_ID]
						, [SITE_ID]
						, [PLANT_ID]
						, [FACTORY_ID]
						, [LINE_ID]
						, [OPERATION_ID]
						, [EQUIPMENT_ID]
						, [ELECTRODE_TYPE]
						, [LOSS_TIME_SUM])
					SELECT MAX(X.[COMPANY_ID])
						, MAX(X.[DIVISION_ID])
						, X.[SITE_ID]
						, X.[PLANT_ID]
						, X.[FACTORY_ID]
						, EM.[MES_LINE_ID]
						, X.[OPERATION_ID]
						, X.[EQUIPMENT_ID]
						, MAX(X.ELECTRODE_TYPE)
						, SUM(X.[LOSS_TIME_SUM])
					FROM  SCM_EQUIPMENT_M EM (NOLOCK)
					     ,@SUM_TABLE X
						 ,SCM_SYS_LOOKUP_VALUE SLV (NOLOCK)
					WHERE X.[SITE_ID]      = EM.[SITE_ID]
					AND   X.[COMPANY_ID]   = EM.[COMPANY_ID]
					AND   X.[DIVISION_ID]  = EM.[DIVISION_ID]
					AND   X.[PLANT_ID]     = EM.[PLANT_ID]
					AND   X.[FACTORY_ID]   = EM.[FACTORY_ID]
					AND   X.[LINE_ID]      = EM.[LINE_ID]
					AND   X.[OPERATION_ID] = EM.[OPERATION_ID]
					AND   X.[EQUIPMENT_ID] = EM.[EQUIPMENT_ID]
					AND   SLV.LOOKUP_TYPE_CODE  = 'CAPA_UI_EXCEPT_LINE'
					AND   SLV.ACTIVE_FLAG  = 'Y'
					AND   EM.DIVISION_ID   = SLV.SEGMENT1
					AND   EM.PLANT_ID      = SLV.SEGMENT2
					AND   EM.OPERATION_ID  = SLV.SEGMENT3
					AND   EM.LINE_ID       = SLV.SEGMENT4
					AND   EM.ELECTRODE_TYPE = SLV.SEGMENT5
					AND   EM.[SITE_ID] = @P_SITE_ID
					AND   EM.[PLANT_ID] IN (SELECT SEGMENT1
											FROM SCM_SYS_LOOKUP_VALUE (NOLOCK)
											WHERE LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
											AND SEGMENT2 = @P_BASIS_START_TIME )
					AND   EM.EQUIPMENT_TYPE = 'M'
    				AND   EM.ACTIVE_FLAG	= 'Y'
					AND   NOT EXISTS (  SELECT 1
					                    FROM   @SUM_TABLE X
									    WHERE  X.[SITE_ID]      = EM.[SITE_ID]
										AND    X.[PLANT_ID]     = EM.[PLANT_ID]
										AND    X.[FACTORY_ID]   = EM.[FACTORY_ID]
										AND    X.[LINE_ID]      = EM.[MES_LINE_ID]
										AND    X.[OPERATION_ID] = EM.[OPERATION_ID]
										AND    X.[EQUIPMENT_ID] = EM.[EQUIPMENT_ID])
					GROUP BY X.[SITE_ID]
							, X.[PLANT_ID]
							, X.[FACTORY_ID]
							, EM.[MES_LINE_ID]
							, X.[OPERATION_ID]
							, X.[EQUIPMENT_ID]
					-- 2021-09-17 kimcd 폴란드 전극 후 공정 라인의 MES 라인 정보 추가 종료
							
					MERGE INTO SCM_LOSS_M M
					USING (
							SELECT B.[COMPANY_ID]
								   ,B.[DIVISION_ID]
								   ,B.[SITE_ID]
								   ,B.[PLANT_ID]
								   ,B.[FACTORY_ID]
								   ,B.[OPERATION_ID]
								   ,B.[LINE_ID]
								   ,B.[ELECTRODE_TYPE]
								   ,A.[MEASURE_CODE]
								   ,CASE WHEN A.MEASURE_CODE LIKE 'M%' THEN
								        ROUND((A.LOSS_TIME/CASE WHEN A.LOSS_CNT = 0 THEN 1 ELSE A.LOSS_CNT END ), 4)
								    ELSE 
									    CASE WHEN B.AVAILABLE_TIME = 0 THEN 0 ELSE ROUND((A.LOSS_TIME/B.AVAILABLE_TIME), 4) END   -- 2023-06-05 kimcd AVAILABLE_TIME - 0 시간 오류 보완
									END AS LOSS_RATE  -- 2021-10-27 kimcd 양품 지표 산출위해 로지 분기. 2021-03-25 kimcd loss 산출하는 로직 재구성
								   ,C.[MONTH]
							  FROM (SELECT [COMPANY_ID]
										 , [DIVISION_ID]
										 , [SITE_ID]
										 , [PLANT_ID]
										 , [FACTORY_ID]
										 , [LINE_ID]
										 , [OPERATION_ID]
										 , [ELECTRODE_TYPE]
										 , SUM(@TOTAL_TIME - [LOSS_TIME_SUM]) AS AVAILABLE_TIME
									FROM  @SUM_TABLE
									GROUP BY [COMPANY_ID]
										 , [DIVISION_ID]
										 , [SITE_ID]
										 , [PLANT_ID]
										 , [FACTORY_ID]
										 , [LINE_ID]
										 , [OPERATION_ID]
										 , [ELECTRODE_TYPE] ) B
									LEFT OUTER JOIN (
										SELECT B.[COMPANY_ID]
												, B.[DIVISION_ID]
												, A.SITE_ID
												, A.PLANT_ID
												, A.FACTORY_ID
												, A.LINE_ID
												, A.OPERATION_ID
												, ISNULL( B.ELECTRODE_TYPE, '-') AS ELECTRODE_TYPE
												, A.MEASURE_CODE
    											, SUM(LOSS_TIME_SUM) AS LOSS_TIME
												, SUM(LOSS_CNT_SUM)  AS LOSS_CNT  -- 2021-10-27 kimcd 양품용 컬럼 추가
    										FROM FP_DW_LOSS_M A WITH(NOLOCK)
    											INNER JOIN SCM_EQUIPMENT_M B WITH(NOLOCK)					-- FP에 등록되어 사용 중인 설비의 LOSS 정보 만 생성
    													ON A.SITE_ID			= B.SITE_ID
    													AND A.PLANT_ID		= B.PLANT_ID
    													AND A.FACTORY_ID		= B.FACTORY_ID
    													AND A.LINE_ID			= B.LINE_ID
    													AND A.OPERATION_ID	= B.OPERATION_ID
    													AND A.EQUIPMENT_ID	= B.EQUIPMENT_ID
														AND B.EQUIPMENT_TYPE  = 'M'   -- 2021-01-16 kimcd Main 설비, 현재 사용하는 설비로만 제한
    													AND B.ACTIVE_FLAG		= 'Y'
    												WHERE A.MEASURE_CODE IN ( SELECT A.SEGMENT1
    																			FROM SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)
    																			WHERE A.LOOKUP_TYPE_CODE = 'CAPA_UI_LOSS_TYPE_DEFINIT' -- 'LOSS_TYPE_DEFINITION'
																					AND A.ACTIVE_FLAG = 'Y'
																					AND ATTRIBUTE3 = 'SCM_LOSS_M'
						    												)
				  										AND A.[SITE_ID]  =  @P_SITE_ID
														AND A.[PLANT_ID] IN (	SELECT SEGMENT1
																			FROM   SCM_SYS_LOOKUP_VALUE
																			WHERE  LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
																			AND    SEGMENT2 = @P_BASIS_START_TIME
																			) -- 2021-01-16 kimcd Site Plant 제한
    												GROUP BY B.[COMPANY_ID]
															, B.[DIVISION_ID]
															, A.SITE_ID
															, A.PLANT_ID
															, A.FACTORY_ID
															, A.LINE_ID
															, A.OPERATION_ID
															, B.ELECTRODE_TYPE
															, A.MEASURE_CODE
    									) A
										ON  B.[COMPANY_ID]     = A.[COMPANY_ID]
										AND	B.[DIVISION_ID]    = A.[DIVISION_ID]
										AND	B.[SITE_ID]        = A.[SITE_ID]
										AND	B.[PLANT_ID]       = A.[PLANT_ID]
										AND	B.[FACTORY_ID]     = A.[FACTORY_ID]
										AND	B.[LINE_ID]        = A.[LINE_ID]
										AND	B.[OPERATION_ID]   = A.[OPERATION_ID]
										AND	B.[ELECTRODE_TYPE] = A.[ELECTRODE_TYPE]
								   ,(
										SELECT CONVERT(NVARCHAR(6), DATEADD(mm, DATEDIFF(mm,0,GETDATE())-1, 0), 112)  AS [MONTH] -- 전달 1일
									) C
								WHERE A.MEASURE_CODE IS NOT NULL --  2021-09-17 kimcd 폴란드 전극 후 공정 MES 라인 추가하면서 조건 추가
							) D
						ON (
							M.[COMPANY_ID]			= D.[COMPANY_ID]
							AND M.[DIVISION_ID]		= D.[DIVISION_ID]
							AND M.[SITE_ID]			= D.[SITE_ID]
							AND M.[PLANT_ID]		= D.[PLANT_ID]
							AND M.[FACTORY_ID]		= D.[FACTORY_ID]
							AND M.[OPERATION_ID]	= D.[OPERATION_ID]
							AND M.[LINE_ID]			= D.[LINE_ID]
							AND M.[ELECTRODE_TYPE]	= D.[ELECTRODE_TYPE]
							AND M.[WORK_MONTH]		= D.[MONTH]
							AND M.[LOSS_CODE]       = D.[MEASURE_CODE]
						   )
					WHEN MATCHED THEN
						UPDATE
							SET LOSS_RATE_RESULT= D.LOSS_RATE
								, UPDATE_ID		= 'PR_XIF_DW_LOSS_TIME_R'
								, UPDATE_TIME	= GETDATE()
					WHEN NOT MATCHED THEN
						INSERT (
							[COMPANY_ID]
						    ,[DIVISION_ID]
						    ,[SITE_ID]
						    ,[PLANT_ID]
						    ,[FACTORY_ID]
						    ,[OPERATION_ID]
						    ,[LINE_ID]
						    ,[ELECTRODE_TYPE]
						    ,[WORK_MONTH]
							,[LOSS_CODE]
						    ,[LOSS_RATE_RESULT]
							,[INSERT_ID]
							,[INSERT_TIME]
							,[UPDATE_ID]
							,[UPDATE_TIME]
						) VALUES (
							D.[COMPANY_ID]
						    ,D.[DIVISION_ID]
						    ,D.[SITE_ID]
						    ,D.[PLANT_ID]
						    ,D.[FACTORY_ID]
						    ,D.[OPERATION_ID]
						    ,D.[LINE_ID]
						    ,D.[ELECTRODE_TYPE]
						    ,D.[MONTH]
							,D.[MEASURE_CODE]
						    ,D.[LOSS_RATE]
							,'PR_XIF_DW_LOSS_TIME_R'
							,GETDATE()
							,'PR_XIF_DW_LOSS_TIME_R'
							,GETDATE()
						)
					;

					-- 2021-09-17 kimcd 폴란드 전극 후 공정 갱신 시작
					MERGE INTO SCM_LOSS_M M
					USING (
							SELECT B.[COMPANY_ID]
								   ,B.[DIVISION_ID]
								   ,B.[SITE_ID]
								   ,B.[PLANT_ID]
								   ,B.[FACTORY_ID]
								   ,B.[OPERATION_ID]
								   ,B.[LINE_ID]
								   ,B.[ELECTRODE_TYPE]
								   ,A.[MEASURE_CODE]
								   ,CASE WHEN A.MEASURE_CODE LIKE 'M%' THEN
								        ROUND((A.LOSS_TIME/CASE WHEN A.LOSS_CNT = 0 THEN 1 ELSE A.LOSS_CNT END ), 4)
								    ELSE 
									    CASE WHEN B.AVAILABLE_TIME = 0 THEN 0 ELSE ROUND((A.LOSS_TIME/B.AVAILABLE_TIME), 4) END   -- 2023-06-05 kimcd AVAILABLE_TIME - 0 시간 오류 보완
									END AS LOSS_RATE  -- 2021-10-27 kimcd 양품 지표 산출위해 로지 분기. 2021-03-25 kimcd loss 산출하는 로직 재구성
								   ,C.[MONTH]
							  FROM (SELECT X.[COMPANY_ID]
										 , X.[DIVISION_ID]
										 , X.[SITE_ID]
										 , X.[PLANT_ID]
										 , X.[FACTORY_ID]
										 , X.[LINE_ID]
										 , X.[OPERATION_ID]
										 , X.[ELECTRODE_TYPE]
										 , SUM(@TOTAL_TIME - [LOSS_TIME_SUM]) AS AVAILABLE_TIME
									FROM  SCM_EQUIPMENT_M EM (NOLOCK)
									     ,@SUM_TABLE X
									WHERE X.[SITE_ID]      = EM.[SITE_ID]
									AND   X.[COMPANY_ID]   = EM.[COMPANY_ID]
									AND   X.[DIVISION_ID]  = EM.[DIVISION_ID]
									AND   X.[PLANT_ID]     = EM.[PLANT_ID]
									AND   X.[FACTORY_ID]   = EM.[FACTORY_ID]
									AND   X.[LINE_ID]      = EM.[MES_LINE_ID]
									AND   X.[OPERATION_ID] = EM.[OPERATION_ID]
									AND   X.[EQUIPMENT_ID] = EM.[EQUIPMENT_ID]
									AND   EM.EQUIPMENT_TYPE = 'M'
    								AND   EM.ACTIVE_FLAG	= 'Y'
									AND   X.[LINE_ID]     != EM.[LINE_ID]
									GROUP BY X.[COMPANY_ID]
										 , X.[DIVISION_ID]
										 , X.[SITE_ID]
										 , X.[PLANT_ID]
										 , X.[FACTORY_ID]
										 , X.[LINE_ID]
										 , X.[OPERATION_ID]
										 , X.[ELECTRODE_TYPE] ) B
									LEFT OUTER JOIN (
										SELECT B.[COMPANY_ID]
												, B.[DIVISION_ID]
												, A.SITE_ID
												, A.PLANT_ID
												, A.FACTORY_ID
												, B.MES_LINE_ID
												, A.OPERATION_ID
												, ISNULL( B.ELECTRODE_TYPE, '-') AS ELECTRODE_TYPE
												, A.MEASURE_CODE
    											, SUM(LOSS_TIME_SUM) AS LOSS_TIME
												, SUM(LOSS_CNT_SUM)  AS LOSS_CNT  -- 2021-10-27 kimcd 양품용 컬럼 추가
    										FROM FP_DW_LOSS_M A WITH(NOLOCK)
    											INNER JOIN SCM_EQUIPMENT_M B WITH(NOLOCK)					-- FP에 등록되어 사용 중인 설비의 LOSS 정보 만 생성
    													ON A.SITE_ID		= B.SITE_ID
    													AND A.PLANT_ID		= B.PLANT_ID
    													AND A.FACTORY_ID	= B.FACTORY_ID
    													AND A.LINE_ID		= B.LINE_ID
    													AND A.OPERATION_ID	= B.OPERATION_ID
    													AND A.EQUIPMENT_ID	= B.EQUIPMENT_ID
														AND B.EQUIPMENT_TYPE = 'M'   -- 2021-01-16 kimcd Main 설비, 현재 사용하는 설비로만 제한
    													AND B.ACTIVE_FLAG	= 'Y'
    												WHERE A.MEASURE_CODE IN ( SELECT A.SEGMENT1
    																			FROM SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)
    																			WHERE A.LOOKUP_TYPE_CODE = 'CAPA_UI_LOSS_TYPE_DEFINIT' -- 'LOSS_TYPE_DEFINITION'
																				AND A.ACTIVE_FLAG = 'Y'
																				AND ATTRIBUTE3 = 'SCM_LOSS_M'
						    												)
				  										AND A.[SITE_ID]  =  @P_SITE_ID
														AND A.[PLANT_ID] IN (SELECT SEGMENT1
																			 FROM   SCM_SYS_LOOKUP_VALUE
																			 WHERE  LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
																			 AND    SEGMENT2 = @P_BASIS_START_TIME
																			 ) -- 2021-01-16 kimcd Site Plant 제한
    												GROUP BY B.[COMPANY_ID]
															, B.[DIVISION_ID]
															, A.SITE_ID
															, A.PLANT_ID
															, A.FACTORY_ID
															, B.MES_LINE_ID
															, A.OPERATION_ID
															, B.ELECTRODE_TYPE
															, A.MEASURE_CODE
    									) A
										ON  B.[COMPANY_ID]     = A.[COMPANY_ID]
										AND	B.[DIVISION_ID]    = A.[DIVISION_ID]
										AND	B.[SITE_ID]        = A.[SITE_ID]
										AND	B.[PLANT_ID]       = A.[PLANT_ID]
										AND	B.[FACTORY_ID]     = A.[FACTORY_ID]
										AND	B.[LINE_ID]        = A.[MES_LINE_ID]
										AND	B.[OPERATION_ID]   = A.[OPERATION_ID]
										AND	B.[ELECTRODE_TYPE] = A.[ELECTRODE_TYPE]
								   ,(
										SELECT CONVERT(NVARCHAR(6), DATEADD(mm, DATEDIFF(mm,0,GETDATE())-1, 0), 112)  AS [MONTH] -- 전달 1일
									) C

							) D
						ON (
							M.[COMPANY_ID]			= D.[COMPANY_ID]
							AND M.[DIVISION_ID]		= D.[DIVISION_ID]
							AND M.[SITE_ID]			= D.[SITE_ID]
							AND M.[PLANT_ID]		= D.[PLANT_ID]
							AND M.[FACTORY_ID]		= D.[FACTORY_ID]
							AND M.[OPERATION_ID]	= D.[OPERATION_ID]
							AND M.[LINE_ID]			= D.[LINE_ID]
							AND M.[ELECTRODE_TYPE]	= D.[ELECTRODE_TYPE]
							AND M.[WORK_MONTH]		= D.[MONTH]
							AND M.[LOSS_CODE]       = D.[MEASURE_CODE]
						   )
					WHEN MATCHED THEN
						UPDATE
							SET LOSS_RATE_RESULT= D.LOSS_RATE
								, UPDATE_ID		= 'PR_XIF_DW_LOSS_TIME_R'
								, UPDATE_TIME	= GETDATE()
					WHEN NOT MATCHED THEN
						INSERT (
							[COMPANY_ID]
						    ,[DIVISION_ID]
						    ,[SITE_ID]
						    ,[PLANT_ID]
						    ,[FACTORY_ID]
						    ,[OPERATION_ID]
						    ,[LINE_ID]
						    ,[ELECTRODE_TYPE]
						    ,[WORK_MONTH]
							,[LOSS_CODE]
						    ,[LOSS_RATE_RESULT]
							,[INSERT_ID]
							,[INSERT_TIME]
							,[UPDATE_ID]
							,[UPDATE_TIME]
						) VALUES (
							D.[COMPANY_ID]
						    ,D.[DIVISION_ID]
						    ,D.[SITE_ID]
						    ,D.[PLANT_ID]
						    ,D.[FACTORY_ID]
						    ,D.[OPERATION_ID]
						    ,D.[LINE_ID]
						    ,D.[ELECTRODE_TYPE]
						    ,D.[MONTH]
							,D.[MEASURE_CODE]
						    ,D.[LOSS_RATE]
							,'PR_XIF_DW_LOSS_TIME_R'
							,GETDATE()
							,'PR_XIF_DW_LOSS_TIME_R'
							,GETDATE()
						);
					-- 2021-09-17 kimcd 폴란드 전극 후 공정 갱신 끝

					MERGE INTO SCM_WORK_CALENDAR_M M
					USING (
							SELECT A.[COMPANY_ID]
								   ,A.[DIVISION_ID]
								   ,A.[SITE_ID]
								   ,A.[PLANT_ID]
								   ,A.[FACTORY_ID]
								   ,A.[OPERATION_ID]
								   ,A.[LINE_ID]
								   ,A.[ELECTRODE_TYPE]
								   ,A.[MEASURE_CODE]
								   ,ISNULL(B.EQU_CNT,1) AS EQU_CNT  --설비 수
								   ,ROUND(((A.LOSS_TIME_SUM/60/ISNULL(B.EQU_CNT,1))), 0) AS LOSS_TIME_SUM  -- LOSS 시간/분으로 전환/설비
								   ,C.[HIS_DATE]
							  FROM (
    								SELECT B.[COMPANY_ID]
										   , B.[DIVISION_ID]
										   , A.SITE_ID
										   , A.PLANT_ID
										   , A.FACTORY_ID
										   , A.LINE_ID
										   , A.OPERATION_ID
										   , B.ELECTRODE_TYPE
										   , A.MEASURE_CODE
    									   , SUM(LOSS_TIME_SUM) AS LOSS_TIME_SUM  -- 달 기준으로 LOSS 시간 총 합 구하기
    								  FROM FP_DW_LOSS_M A WITH(NOLOCK)
    									   INNER JOIN SCM_EQUIPMENT_M B WITH(NOLOCK)					-- FP에 등록되어 사용 중인 설비의 LOSS 정보 만 생성
    											   ON A.SITE_ID			= B.SITE_ID
    											  AND A.PLANT_ID		= B.PLANT_ID
    											  AND A.FACTORY_ID		= B.FACTORY_ID
    											  AND A.LINE_ID			= B.LINE_ID
    											  AND A.OPERATION_ID	= B.OPERATION_ID
    											  AND A.EQUIPMENT_ID	= B.EQUIPMENT_ID
												  AND B.EQUIPMENT_TYPE  = 'M'   -- 2021-01-16 kimcd Main 설비, 현재 사용하는 설비로만 제한
												  AND B.ACTIVE_FLAG     = 'Y'
    											WHERE A.MEASURE_CODE IN ( SELECT A.SEGMENT1
    																		FROM SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)
    																	   WHERE A.LOOKUP_TYPE_CODE = 'CAPA_UI_LOSS_TYPE_DEFINIT' -- 'LOSS_TYPE_DEFINITION'
																		     AND A.ACTIVE_FLAG = 'Y'
																			 AND ATTRIBUTE3 = 'SCM_WORK_CALENDAR_M'
						    											)
				  								  AND A.[SITE_ID]  =  @P_SITE_ID
												  AND A.[PLANT_ID] IN (	SELECT SEGMENT1
																		FROM   SCM_SYS_LOOKUP_VALUE
																		WHERE  LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
																		AND    SEGMENT2 = @P_BASIS_START_TIME
																		) -- 2021-01-16 kimcd Site Plant 제한
    											GROUP BY B.[COMPANY_ID]
													  , B.[DIVISION_ID]
													  , A.SITE_ID
													  , A.PLANT_ID
													  , A.FACTORY_ID
													  , A.LINE_ID
													  , A.OPERATION_ID
													  , B.ELECTRODE_TYPE
													  , A.MEASURE_CODE
    							   ) A
    							   LEFT OUTER JOIN (												-- 사용 중인 설비 정보 만 생성
    												SELECT A.SITE_ID
														   , A.PLANT_ID
														   , A.FACTORY_ID
														   , A.LINE_ID
														   , A.OPERATION_ID
														   , A.ELECTRODE_TYPE
														   , COUNT(*) AS EQU_CNT
    												  FROM SCM_EQUIPMENT_M A WITH(NOLOCK)
    												 WHERE A.ACTIVE_FLAG = 'Y'
													 AND   A.EQUIPMENT_TYPE  = 'M'   -- 2020-01-16 kimcd Main 설비, 현재 사용하는 설비로만 제한
    												 GROUP BY A.SITE_ID
														   , A.PLANT_ID
														   , A.FACTORY_ID
														   , A.LINE_ID
														   , A.OPERATION_ID
														   , A.ELECTRODE_TYPE
    											   ) B
    											ON A.SITE_ID        = B.SITE_ID
    										   AND A.PLANT_ID       = B.PLANT_ID
    										   AND A.FACTORY_ID     = B.FACTORY_ID
    										   AND A.LINE_ID        = B.LINE_ID
    										   AND A.OPERATION_ID   = B.OPERATION_ID
    										   AND A.ELECTRODE_TYPE = B.ELECTRODE_TYPE
								   ,(
										SELECT DATEADD(mm, DATEDIFF(mm,0,GETDATE())-1, 0)  AS [HIS_DATE] -- 전달 1일
									) C

							) D
						ON (
							M.[COMPANY_ID]			= D.[COMPANY_ID]
							AND M.[DIVISION_ID]		= D.[DIVISION_ID]
							AND M.[SITE_ID]			= D.[SITE_ID]
							AND M.[PLANT_ID]		= D.[PLANT_ID]
							AND M.[FACTORY_ID]		= D.[FACTORY_ID]
							AND M.[OPERATION_ID]	= D.[OPERATION_ID]
							AND M.[LINE_ID]			= D.[LINE_ID]
							AND M.[ELECTRODE_TYPE]	= D.[ELECTRODE_TYPE]
							AND M.[WORK_DATE]		= D.[HIS_DATE]
							AND M.[LOSS_CODE]       = D.[MEASURE_CODE]
						   )
					WHEN MATCHED THEN
						UPDATE
							SET TIME_TERM_RESULT = D.LOSS_TIME_SUM
								, UPDATE_ID		 = 'PR_XIF_DW_LOSS_TIME_R'
								, UPDATE_TIME	 = GETDATE()
					WHEN NOT MATCHED THEN
						INSERT (
							[COMPANY_ID]
						    ,[DIVISION_ID]
						    ,[SITE_ID]
						    ,[PLANT_ID]
						    ,[FACTORY_ID]
						    ,[OPERATION_ID]
						    ,[LINE_ID]
						    ,[ELECTRODE_TYPE]
						    ,[WORK_DATE]
							,[LOSS_CODE]
						    ,[TIME_TERM_RESULT]
							,[INSERT_ID]
							,[INSERT_TIME]
							,[UPDATE_ID]
							,[UPDATE_TIME]
						) VALUES (
							D.[COMPANY_ID]
						    ,D.[DIVISION_ID]
						    ,D.[SITE_ID]
						    ,D.[PLANT_ID]
						    ,D.[FACTORY_ID]
						    ,D.[OPERATION_ID]
						    ,D.[LINE_ID]
						    ,D.[ELECTRODE_TYPE]
						    ,D.[HIS_DATE]
							,D.[MEASURE_CODE]
						    ,D.[LOSS_TIME_SUM]
							,'PR_XIF_DW_LOSS_TIME_R'
							,GETDATE()
							,'PR_XIF_DW_LOSS_TIME_R'
							,GETDATE()
						)
					;

					-- 2021-09-17 kimcd 폴란드 전극 후 공정 갱신 시작
					MERGE INTO SCM_WORK_CALENDAR_M M
					USING (
							SELECT A.[COMPANY_ID]
								   ,A.[DIVISION_ID]
								   ,A.[SITE_ID]
								   ,A.[PLANT_ID]
								   ,A.[FACTORY_ID]
								   ,A.[OPERATION_ID]
								   ,A.[LINE_ID]
								   ,A.[ELECTRODE_TYPE]
								   ,A.[MEASURE_CODE]
								   ,ISNULL(B.EQU_CNT,1) AS EQU_CNT  --설비 수
								   ,ROUND(((A.LOSS_TIME_SUM/60/ISNULL(B.EQU_CNT,1))), 0) AS LOSS_TIME_SUM  -- LOSS 시간/분으로 전환/설비
								   ,C.[HIS_DATE]
							  FROM (
    								SELECT B.[COMPANY_ID]
										   , B.[DIVISION_ID]
										   , A.SITE_ID
										   , A.PLANT_ID
										   , A.FACTORY_ID
										   , B.MES_LINE_ID AS LINE_ID
										   , A.OPERATION_ID
										   , B.ELECTRODE_TYPE
										   , A.MEASURE_CODE
    									   , SUM(LOSS_TIME_SUM) AS LOSS_TIME_SUM  -- 달 기준으로 LOSS 시간 총 합 구하기
    								  FROM FP_DW_LOSS_M A WITH(NOLOCK)
    									   INNER JOIN SCM_EQUIPMENT_M B WITH(NOLOCK)					-- FP에 등록되어 사용 중인 설비의 LOSS 정보 만 생성
    											   ON A.SITE_ID			= B.SITE_ID
    											  AND A.PLANT_ID		= B.PLANT_ID
    											  AND A.FACTORY_ID		= B.FACTORY_ID
    											  AND A.LINE_ID			= B.LINE_ID
    											  AND A.OPERATION_ID	= B.OPERATION_ID
    											  AND A.EQUIPMENT_ID	= B.EQUIPMENT_ID
												  AND B.EQUIPMENT_TYPE  = 'M'   -- 2021-01-16 kimcd Main 설비, 현재 사용하는 설비로만 제한
												  AND B.ACTIVE_FLAG     = 'Y'
										  INNER JOIN SCM_SYS_LOOKUP_VALUE SLV (NOLOCK)
												  ON   SLV.LOOKUP_TYPE_CODE  = 'CAPA_UI_EXCEPT_LINE'
												 AND   SLV.ACTIVE_FLAG  = 'Y'
												 AND   B.DIVISION_ID    = SLV.SEGMENT1
												 AND   A.PLANT_ID       = SLV.SEGMENT2
												 AND   A.OPERATION_ID   = SLV.SEGMENT3
												 AND   A.LINE_ID        = SLV.SEGMENT4
												 AND   B.ELECTRODE_TYPE = SLV.SEGMENT5
    											WHERE A.MEASURE_CODE IN ( SELECT A.SEGMENT1
    																		FROM SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)
    																	   WHERE A.LOOKUP_TYPE_CODE = 'CAPA_UI_LOSS_TYPE_DEFINIT' -- 'LOSS_TYPE_DEFINITION'
																		     AND A.ACTIVE_FLAG = 'Y'
																			 AND ATTRIBUTE3 = 'SCM_WORK_CALENDAR_M'
						    											)
				  								  AND A.[SITE_ID]  =  @P_SITE_ID
												  AND A.[PLANT_ID] IN (	SELECT SEGMENT1
																		FROM   SCM_SYS_LOOKUP_VALUE
																		WHERE  LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
																		AND    SEGMENT2 = @P_BASIS_START_TIME
																		) -- 2021-01-16 kimcd Site Plant 제한
    											GROUP BY B.[COMPANY_ID]
													  , B.[DIVISION_ID]
													  , A.SITE_ID
													  , A.PLANT_ID
													  , A.FACTORY_ID
													  , B.MES_LINE_ID
													  , A.OPERATION_ID
													  , B.ELECTRODE_TYPE
													  , A.MEASURE_CODE
    							   ) A
    							   LEFT OUTER JOIN (												-- 사용 중인 설비 정보 만 생성
    												SELECT A.SITE_ID
														   , A.PLANT_ID
														   , A.FACTORY_ID
														   , A.MES_LINE_ID
														   , A.OPERATION_ID
														   , A.ELECTRODE_TYPE
														   , COUNT(*) AS EQU_CNT
    												  FROM SCM_EQUIPMENT_M A WITH(NOLOCK)
    												 WHERE A.ACTIVE_FLAG = 'Y'
													 AND   A.EQUIPMENT_TYPE  = 'M'   -- 2020-01-16 kimcd Main 설비, 현재 사용하는 설비로만 제한
    												 GROUP BY A.SITE_ID
														   , A.PLANT_ID
														   , A.FACTORY_ID
														   , A.MES_LINE_ID
														   , A.OPERATION_ID
														   , A.ELECTRODE_TYPE
    											   ) B
    											ON A.SITE_ID        = B.SITE_ID
    										   AND A.PLANT_ID       = B.PLANT_ID
    										   AND A.FACTORY_ID     = B.FACTORY_ID
    										   AND A.LINE_ID        = B.MES_LINE_ID
    										   AND A.OPERATION_ID   = B.OPERATION_ID
    										   AND A.ELECTRODE_TYPE = B.ELECTRODE_TYPE
								   ,(
										SELECT DATEADD(mm, DATEDIFF(mm,0,GETDATE())-1, 0)  AS [HIS_DATE] -- 전달 1일
									) C

							) D
						ON (
							M.[COMPANY_ID]			= D.[COMPANY_ID]
							AND M.[DIVISION_ID]		= D.[DIVISION_ID]
							AND M.[SITE_ID]			= D.[SITE_ID]
							AND M.[PLANT_ID]		= D.[PLANT_ID]
							AND M.[FACTORY_ID]		= D.[FACTORY_ID]
							AND M.[OPERATION_ID]	= D.[OPERATION_ID]
							AND M.[LINE_ID]			= D.[LINE_ID]
							AND M.[ELECTRODE_TYPE]	= D.[ELECTRODE_TYPE]
							AND M.[WORK_DATE]		= D.[HIS_DATE]
							AND M.[LOSS_CODE]       = D.[MEASURE_CODE]
						   )
					WHEN MATCHED THEN
						UPDATE
							SET TIME_TERM_RESULT = D.LOSS_TIME_SUM
								, UPDATE_ID		 = 'PR_XIF_DW_LOSS_TIME_R'
								, UPDATE_TIME	 = GETDATE()
					WHEN NOT MATCHED THEN
						INSERT (
							[COMPANY_ID]
						    ,[DIVISION_ID]
						    ,[SITE_ID]
						    ,[PLANT_ID]
						    ,[FACTORY_ID]
						    ,[OPERATION_ID]
						    ,[LINE_ID]
						    ,[ELECTRODE_TYPE]
						    ,[WORK_DATE]
							,[LOSS_CODE]
						    ,[TIME_TERM_RESULT]
							,[INSERT_ID]
							,[INSERT_TIME]
							,[UPDATE_ID]
							,[UPDATE_TIME]
						) VALUES (
							D.[COMPANY_ID]
						    ,D.[DIVISION_ID]
						    ,D.[SITE_ID]
						    ,D.[PLANT_ID]
						    ,D.[FACTORY_ID]
						    ,D.[OPERATION_ID]
						    ,D.[LINE_ID]
						    ,D.[ELECTRODE_TYPE]
						    ,D.[HIS_DATE]
							,D.[MEASURE_CODE]
						    ,D.[LOSS_TIME_SUM]
							,'PR_XIF_DW_LOSS_TIME_R'
							,GETDATE()
							,'PR_XIF_DW_LOSS_TIME_R'
							,GETDATE()
						)
					;
					-- 2021-09-17 kimcd 폴란드 전극 후 공정 갱신 끝

					-- 2020-01-16 kimcd Loss 이력 형성 끝
				END -- IF DAY( GETDATE()) = 5	-- 매월 5일만 실행

			-- 2024-06-12 kimcd WA.FP 전송 과정 추가 시작
		    INSERT INTO [dbo].[SY_XIF_FP_RESULT_LOSS_TIME_S]
			    ( [IF_SEQ]
			    , [IF_TYPE]
			    , [IF_ID]
			    , [IF_INS_DATE]
			    , [IF_FLAG]
			    , [IF_SND_DATE]
			    , [WORK_DATE]
			    , [AREA_ID]
			    , [LINE_ID]
			    , [PROCESS_ID]
			    , [EQPT_ID]
			    , [MEASURE_CODE]
			    , [LOSS_CNT]
			    , [LOSS_TIME]
			    , [GNRT_DTTM]
			    , [ACCUM_COUNT])
           SELECT  'OFP0' + SUBSTRING(CONVERT(NVARCHAR(12), GETDATE(), 112), 3,6)
           	   	   + REPLICATE('0', 10 - LEN(NEXT VALUE FOR [dbo].[XIF_FP_SEND_SEQ]))
           	   	   + CAST( NEXT VALUE FOR [dbo].[XIF_FP_SEND_SEQ] AS NVARCHAR)   -- IF_SEQ
                 , 'S' AS IF_TYPE
                 , 'OFP0' +'_' + SLV.ATTRIBUTE1 +'_RESULT_LOSS_TIME'
                 , GETDATE()        AS IF_INS_DATE
                 , 'N'              AS IF_FLAG
                 , GETDATE()        AS IF_SND_DATE
			   	 , [WORK_DATE]
			     , [AREA_ID]
			     , [LINE_ID]
			     , [PROCESS_ID]
			     , [EQPT_ID]
			     , [MEASURE_CODE]
			     , [LOSS_CNT]
			     , [LOSS_TIME]
				 , GETDATE() AS GNRT_DTTM
				 , COUNT(*)  OVER(PARTITION BY SLV.ATTRIBUTE1)   ACCUM_COUNT
			FROM  SY_XIF_DW_RECEIVE_LOSS_TIME_R XIF WITH(NOLOCK)
				  INNER JOIN [DBO].[SCM_PLANT_M]	SPM WITH(NOLOCK)
				  ON   XIF.PLANT_ID   = SPM.PLANT_ID
				  INNER JOIN [DBO].[SCM_SYS_LOOKUP_VALUE]  SLV WITH(NOLOCK)
				  ON   SLV.LOOKUP_TYPE_CODE = 'COMPANY_FP_SYSTEM_CODE'
				  AND  SLV.SEGMENT1         = SPM.COMPANY_ID
				  AND  SLV.ACTIVE_FLAG      = 'Y'
				  INNER JOIN [DBO].[SCM_SYS_LOOKUP_VALUE]  SLVL WITH(NOLOCK)
				  ON   SLVL.LOOKUP_TYPE_CODE = 'SEND_LOSS_CODE_FOR_TEEP'
				  AND  SLVL.SEGMENT1         = XIF.MEASURE_CODE
				  AND  SLVL.ACTIVE_FLAG      = 'Y'
			WHERE  XIF.[MODIFY_DATE] >= CONVERT(DATE, GETDATE())
			AND    XIF.[SITE_iD]      = @P_SITE_ID
			AND    XIF.[PLANT_ID]    IN ( SELECT SSC.SEGMENT1
										  FROM   SCM_SYS_LOOKUP_VALUE SSC WITH(NOLOCK)
										  WHERE  SSC.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
										  AND    SSC.SEGMENT2         = @P_BASIS_START_TIME );
			-- 2024-06-12 kimcd WA.FP 전송 과정 추가 종료
		COMMIT TRAN

		EXEC PR_XIF_LOG @v_proc_name, NULL, 'END',   NULL, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
		
	END TRY

	BEGIN CATCH

		ROLLBACK TRAN 

		-- 에러나도 로그는 인서트
		SET @v_descr = ERROR_MESSAGE()
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate

	END CATCH

END
