
CREATE PROCEDURE [dbo].[PR_XIF_MES_DAILY_PP2_S_20240509]

-- ================================================================================================
-- Program ID          : FP02620
-- Program Name        : PR_XIF_MES_DAILY_PP2_S
-- Param               :
-- Batch Period        : 1 Day
-- Description         :
--
-- Source System       : FP SDB
-- Destination System  : INF
-- Source Table        : FP_DAILY_PRODUCTION_PLAN_R
-- Destination Table   : XIF_MES_DAILY_PP_S
--
-- Create(Update) Date : 2020.01.10
-- Update Date		   : 2023.03.03

-- Author              : PIYONG
-- Version             : 1.0
--                       1.1 2020-01-14 kimcd release 정보 추출 오류 보완
--                       1.2 2020-12-01 kimcd 오창 소형의 경우 오창 FCS로 계획 전송하도록 보완
--                       1.21 2020-12-16 kimcd 일자별 계획에 Start_time, End_Time 값 추가 형성
--                       1.22 2021-04-16 kimcd 일자별 계획에 fp line 추가 ATTR_11
--	                     1.3 2021-05-27 kimis ESNJ 6동 GMES DB 분리에 따른 변경
--                           동 기준(SCM_FACTORY_M.MES_SOURCE_GROUP)에서 라인 기준(SCM_MMD_LINE_M.MES_SOURCE_GROUP)으로 MES_SOURCE_GROUP 정보 반영
--                           라인 기준으로 MES_SOURCE_GROUP 정보 반영하고 라인 기준  데이터가 NULL 인 경우 동 기준으로 정보 반영
--	                     1.4 2021-07-07 kimcd 전체 계획을 제거한 경우 라인별로 DUMMY 정보 전송
--	                     1.5 2022-06-09 kimcd SPC 계획 전송 기능 추가
--	                     1.6 2022-07-27 kimcd 설비 정보 Option 화 
--	                     1.7 2022-09-14 kimcd plan group에서 정보 일관성 깨지는 현상 발생.
--                                            전송 대상 조회에서 조회된 plan group 사용하도록 수정
--                       1.8 2022-10-31 kimcd 일별 계획 이력에 전극 version, ec no 추가 전송
--                       1.81 2023-03-03 kimcd NJ 전극의 경우 FP 전극 버전 그대로 전송
--                       1.9 2024-03-28 KIMJS NERP PLANT_ID 변경에 따른 CONVERSION 반영 및 하드코딩 제거
-- ================================================================================================

-- PARAM PLAN_ID
--@P_FP_PLAN_ID NVARCHAR(50) = NULL

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_MES_DAILY_PP2_S'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	  = 0
	DECLARE @sysdate     DATETIME     = GETDATE()
	DECLARE @enddate     DATE         = DATEADD( D, 31, GETDATE()) -- 2022-06-09 kimcd SPC 계획 전송 일자 범위 조건 

	DECLARE @ROWCOUNT    INTEGER

	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)

	-- ================================================
    -- Declare start
	-- ================================================
	DECLARE @fp_plan_id				NVARCHAR(50)
	DECLARE @instance_id			NVARCHAR(50)
	DECLARE @factory_id				NVARCHAR(50)
	DECLARE @local_time				NVARCHAR(20) --2018-05-28 PIYONG ADD
	DECLARE @plan_group_id			NVARCHAR(20) --2021-07-07 kimcd add

	CREATE TABLE #BASE_INFO (
								COMPANY_ID				NVARCHAR (30)
								,DIVISION_ID			NVARCHAR (30)
								,SITE_ID				NVARCHAR (30)
								,PLANT_ID				NVARCHAR (30)
								,FACTORY_ID				NVARCHAR (30)
								,PROD_VERSION_TYPE		NVARCHAR (30)
								,PROD_TYPE				NVARCHAR (30)
								,PROD_VERSION			NVARCHAR (30)
								,PC_ITEM_ID				NVARCHAR (150)
								,MODEL_ID				NVARCHAR (150)
								,PROD_SEQ               NVARCHAR (10)
								,ACTIVE_MATERIAL_1		NVARCHAR (100)
								,ACTIVE_MATERIAL_2		NVARCHAR (100)
								,ACTIVE_MATERIAL_3		NVARCHAR (100)
								,BINDER_1				NVARCHAR (100)
								,BINDER_2				NVARCHAR (100)
								,BINDER_3				NVARCHAR (100)
								,PRE_DISPERSION_ID		NVARCHAR (100)
								,PRE_DISPERSION_NAME	NVARCHAR (100)
								,CMC					NVARCHAR (100)
								,CONDUCTION_MATERIAL_1	NVARCHAR (100)
								,CONDUCTION_MATERIAL_2	NVARCHAR (100)
							)
	
	DECLARE PLAN_INFO_CUR CURSOR FOR
		SELECT A.RELEASE_PLAN_ID
			   ,A.INSTANCE_ID
			   ,A.FACTORY_ID
			   ,A.PLAN_GROUP_ID  --2021-07-07 kimcd add
		  FROM (
				SELECT A.INSTANCE_ID
					   ,A.RELEASE_PLAN_ID
					   ,RELEASE_TIME
					   ,'-'      AS FACTORY_ID 
					   ,A.PLAN_GROUP_ID AS PLAN_GROUP_ID  --2021-07-07 kimcd add
				  FROM DBO.SCM_FP_PLAN_GROUP_DETAIL_H A
				 WHERE MES_TRANSFER_FLAG = 'Y'
				   AND PLAN_DATE >= CONVERT(NVARCHAR(8), DATEADD(DD, -1, GETDATE()),112)  -- 2010-01-14 kimcd index 사용용 조건
				   AND (MES_TRANSFER_TIME >= DATEADD(MI, -60, GETDATE()) OR UPDATE_TIME >=  DATEADD(MI, -60, GETDATE() ) )-- 2010-01-14 kimcd 1시간 이내 변경 정보 추출
				UNION ALL
				SELECT A.INSTANCE_ID
					   ,A.RELEASE_PLAN_ID
					   ,RELEASE_TIME
					   ,FACTORY_ID 
					   ,'-' AS PLAN_GROUP_ID --2021-07-07 kimcd add
				  FROM DBO.SCM_FP_PLAN_DETAIL_H A
				 WHERE MES_TRANSFER_FLAG = 'Y'
				   AND PLAN_DATE >= CONVERT(NVARCHAR(8), DATEADD(DD, -1, GETDATE()),112) 
				   AND (MES_TRANSFER_TIME >= DATEADD(MI, -60, GETDATE()) OR UPDATE_TIME >=  DATEADD(MI, -60, GETDATE() )  )-- 2010-01-14 kimcd 1시간 이내 변경 정보 추출
			   ) A
			   , DBO.SCM_FP_PLAN_H P
		 WHERE A.INSTANCE_ID != 'KR_CELL_M_P'
		   AND A.INSTANCE_ID = P.INSTANCE_ID
		   AND A.RELEASE_PLAN_ID = P.PLAN_ID
		   AND NOT EXISTS (
							SELECT 1 
							  FROM [dbo].[SY_XIF_MES_DAILY_PP_S] B WITH(NOLOCK)
							 WHERE B.PLAN_ID = A.RELEASE_PLAN_ID
						  )
		 ORDER BY A.RELEASE_TIME

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

			OPEN PLAN_INFO_CUR
			FETCH NEXT FROM PLAN_INFO_CUR INTO @fp_plan_id
												,@instance_id
												,@factory_id
												,@PLAN_GROUP_ID --2021-07-07 kimcd add

			WHILE (@@FETCH_STATUS = 0)
				BEGIN																									 


					IF (
							SELECT SEGMENT1
							  FROM SCM_SYS_LOOKUP_VALUE
							 WHERE LOOKUP_TYPE_CODE = 'INSTANCE_ID'
							   AND ATTRIBUTE9 = 'E1'
							   AND SEGMENT1 = @instance_id
					   ) IS NOT NULL
						BEGIN
							INSERT INTO #BASE_INFO
							SELECT A.COMPANY_ID
									, A.DIVISION_ID
									, A.SITE_ID
									, A.PLANT_ID
									, A.FACTORY_ID
									, A.PROD_VERSION_TYPE
									, A.PROD_TYPE
									, A.PAN_PROD_VERSION   AS PROD_VERSION
									, A.PC_ITEM_ID
									, A.MODEL_ID
									, A.PROD_SEQ
									, MAX(CASE WHEN A.UI_COLUMN = 'Active Material 1' THEN A.DESCRIPTION END) AS ACTIVE_MATERIAL_1
									, MAX(CASE WHEN A.UI_COLUMN = 'Active Material 2' THEN A.DESCRIPTION END) AS ACTIVE_MATERIAL_2
									, MAX(CASE WHEN A.UI_COLUMN = 'Active Material 3' THEN A.DESCRIPTION END) AS ACTIVE_MATERIAL_3
									, MAX(CASE WHEN A.UI_COLUMN = 'Binder 1' THEN A.DESCRIPTION END) AS BINDER_1
									, MAX(CASE WHEN A.UI_COLUMN = 'Binder 2' THEN A.DESCRIPTION END) AS BINDER_2
									, MAX(CASE WHEN A.UI_COLUMN = 'Binder 3' THEN A.DESCRIPTION END) AS BINDER_3
									, MAX(CASE WHEN A.CLASS_NAME = 'Pre Dispersion Slurry' THEN A.MATERIAL_ITEM_ID END) AS PRE_DISPERSION_ID
									, MAX(CASE WHEN A.CLASS_NAME = 'Pre Dispersion Slurry' THEN A.DESCRIPTION END) AS PRE_DISPERSION_NAME
									, MAX(CASE WHEN A.CLASS_NAME = 'CMC' then A.DESCRIPTION END) AS CMC
									, MAX(CASE WHEN A.UI_COLUMN = 'Conducting Material 1' THEN A.DESCRIPTION END) AS CONDUCTION_MATERIAL_1
									, MAX(CASE WHEN A.UI_COLUMN = 'Conducting Material 2' THEN A.DESCRIPTION END) AS CONDUCTION_MATERIAL_2
							  FROM SCM_PANCAKE_MATERIAL_ALL_VERSION_V A WITH(NOLOCK) -- 2022-10-31 kimcd 전체 버전 조회용으로 View 수정.
							 WHERE A.FACTORY_ID = @factory_id
							 GROUP BY A.COMPANY_ID
									, A.DIVISION_ID
									, A.SITE_ID
									, A.PLANT_ID
									, A.FACTORY_ID
									, A.PROD_VERSION_TYPE
									, A.PROD_TYPE
									, A.PAN_PROD_VERSION
									, A.PC_ITEM_ID
									, A.MODEL_ID
									, A.PROD_SEQ
							OPTION (HASH join);
						END
					ELSE
						BEGIN
							INSERT INTO #BASE_INFO
							SELECT '' COMPANY_ID
									, '' DIVISION_ID
									, '' SITE_ID
									, '' PLANT_ID
									, '' FACTORY_ID
									, '' PROD_VERSION_TYPE
									, '' AS PROD_TYPE
									, '' AS PROD_VERSION
									, '' AS PC_ITEM_ID
									, '' AS MODEL_ID
									, '' AS PROD_SEQ
									, '' AS ACTIVE_MATERIAL_1
									, '' AS ACTIVE_MATERIAL_2
									, '' AS ACTIVE_MATERIAL_3
									, '' AS BINDER_1
									, '' AS BINDER_2
									, '' AS BINDER_3
									, '' AS PRE_DISPERSION_ID
									, '' AS PRE_DISPERSION_NAME
									, '' AS CMC
									, '' AS CONDUCTION_MATERIAL_1
									, '' AS CONDUCTION_MATERIAL_2
						END
						

					--2018-05-28 PIYONG ADD
					SET @local_time = REPLACE(REPLACE(REPLACE(CONVERT( NVARCHAR, DBO.FN_SITE_TIME(
																								  (
																								   SELECT TOP 1 SITE_ID
																									 FROM [dbo].[FP_DAILY_PRODUCTION_PLAN_R] SOURCES
																									WHERE SOURCES.FP_PLAN_ID = ISNULL(@fp_plan_id,'0')
																									  AND SOURCES.INSTANCE_ID = (	SELECT INSTANCE_ID
																																	FROM DBO.SCM_FP_PLAN_DETAIL_H C  WITH(NOLOCK)
																																	WHERE RELEASE_FLAG IN ( 'P', 'Y')
																																	AND RELEASE_PLAN_ID = ISNULL(@fp_plan_id,'0')
																																	UNION ALL
																																	SELECT INSTANCE_ID
																																	FROM DBO.SCM_FP_PLAN_GROUP_DETAIL_H D WITH(NOLOCK)
																																	WHERE D.RELEASE_FLAG IN ( 'P', 'Y')
																																	AND RELEASE_PLAN_ID = ISNULL(@fp_plan_id,'0')
																																	) -- 2020-12-01 kimcd 조건 추가 작업 속도 개선

																								  )
																								 ), 120), '-', ''), ':', ''), ' ', '')

					DELETE
					  FROM [dbo].[SY_XIF_MES_DAILY_PP_S]
					 WHERE PLAN_ID = ISNULL(@fp_plan_id,'0')
					;

					--------------------------------------------------------------------------------------------------------------------
					----- 2017-11-29 PIYONG   FP_DAILY_PRODUCTIOIN_PLAN_H 정보 생성 시작
					--------------------------------------------------------------------------------------------------------------------

					INSERT INTO [dbo].[SY_XIF_MES_DAILY_PP_S] (
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
						,[WO]
						,[WO_DETAIL]
						,[PLAN_DATE]
						,[IN_QTY]
						,[OUT_QTY]
						,[CREATE_PSN_ID]
						,[CREATE_DATE]
						,[UPDATE_PSN_ID]
						,[UPDATE_DATE]
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
						,[ELECTRODE_TYPE]
						,[PRE_DISPERSION_ID]
						,[PRE_DISPERSION_NAME]
						,[ACTIVE_MATERIAL_1]
						,[ACTIVE_MATERIAL_2]
						,[ACTIVE_MATERIAL_3]
						,[BINDER_1]
						,[BINDER_2]
						,[BINDER_3]
						,[CONDUCTION_MATERIAL_1]
						,[CONDUCTION_MATERIAL_2]
						,[CMC]
						,[FOIL]
						,[DAILY_CAPA_PPM]
						,[PROD_VERSION]
						,[PANCAKE_IN_QTY]
						,[PANCAKE_OUT_QTY]
						,[BATCH_IN_QTY]
						,[BATCH_OUT_QTY]
						,[CELL_IN_QTY]
						,[CELL_OUT_QTY]
						,[SEQ]
						,[CELL_MATERIAL_ID]
						,[START_TIME]  -- 2020-12-16 kimcd 시작일시 추가
						,[END_TIME]    -- 2020-12-16 kimcd 종료일시 추가
						,[ATTR_11]     -- 2021-04-16 kimcd FP line 추가
						,[ATTR_12]     -- 2022-10-31 kimcd 작업의뢰서 모델
						,[ATTR_13]     -- 2022-10-31 kimcd 작업의뢰서 버전별 차수
						,[ATTR_14]     -- 2022-10-31 kimcd PLM EC NO
					)	
					SELECT 
					'OFP0' + SUBSTRING(CONVERT(NVARCHAR(12), GETDATE(), 112), 3,6) + REPLICATE('0', 10 - LEN(NEXT VALUE FOR [DBO].[XIF_MES_SEND_SEQ])) + CAST( NEXT VALUE FOR [DBO].[XIF_MES_SEND_SEQ] AS NVARCHAR)   AS IF_SEQ,
					IF_TYPE, IF_ID, IF_INS_DATE, IF_FLAG,IF_SND_DATE, RSLT_IF_SEQ, RSLT_PROC_FLAG, RSLT_PROC_MSG, PLAN_ID, PLANT_ID, FACTORY_ID, LINE_ID, OPERATION_ID, EQUIPMENT_ID, ITEM_ID, WO, WO_DETAIL, PLAN_DATE, PLAN_IN_QTY, PLAN_QTY, CREATE_PSN_ID, CREATE_DATE, UPDATE_PSN_ID, UPDATE_DATE, INSTANCE_ID, PLAN_GR_ID, ATTR_03, 
					--2021-05-27 kimis ESNJ 6동 GMES DB 분리에 따른 변경 : Interface Count를 FACTORY_ID에서 FACTORY_ID, IF_ID 기준으로 변경
					COUNT(*) OVER(PARTITION BY FACTORY_ID, IF_ID)					 AS  ATTR_04,
					FULL_CLEANING_FLAG, MODEL_TYPE_CHANGE_FLAG, MEMO, JR_IN_QTY, JR_OUT_QTY, ATTR_10, ELECTRODE_TYPE, PRE_DISPERSION_ID, PRE_DISPERSION_NAME, ACTIVE_MATERIAL_1, ACTIVE_MATERIAL_2, ACTIVE_MATERIAL_3, BINDER_1, BINDER_2, BINDER_3, CONDUCTION_MATERIAL_1, CONDUCTION_MATERIAL_2, CMC, FOIL_ID, DAILY_CAPA_PPM, PROD_VERSION /* 2023-03-03 kimcd 버전 정리하는 로직 위치 이동 2022-10-31 kimcd 작업의뢰서 버전 */, ROLL_IN_QTY, ROLL_OUT_QTY, BATCH_IN_QTY, BATCH_OUT_QTY, CELL_IN_QTY, CELL_OUT_QTY, SEQ, CELL_MATERIAL_ID, START_TIME, END_TIME, FP_LINE_ID
					,[WORK_REQUEST_MODEL_ID] -- 2022-10-31 kimcd [ATTR_12] 작업의뢰서 모델
					,[PROD_SEQ]              -- 2022-10-31 kimcd [ATTR_13] 작업의뢰서 버전별 차수
					,[PLM_EC_NO]             -- 2022-10-31 kimcd [ATTR_14] PLM EC NO
					FROM (
					SELECT --'OFP0' + SUBSTRING(CONVERT(NVARCHAR(12), GETDATE(), 112), 3,6) + REPLICATE('0', 10 - LEN(NEXT VALUE FOR [DBO].[XIF_MES_SEND_SEQ])) + CAST( NEXT VALUE FOR [DBO].[XIF_MES_SEND_SEQ] AS NVARCHAR)   -- IF_SEQ
						--SELECT ''
							'S'                 IF_TYPE
							--'OFP0'+'_'+( SELECT ISNULL(MES_SOURCE_GROUP,'') FROM SCM_FACTORY_M F WHERE F.FACTORY_ID = M.FACTORY_ID ) +'_'+'FP_DPP'
							--2021-05-27 kimis ESNJ 6동 GMES DB 분리에 따른 변경 : 라인 기준(SCM_MMD_LINE_M.MES_SOURCE_GROUP)으로 MES_SOURCE_GROUP 반영하고 라인 기준 데이터가 NULL 인 경우 동 기준(SCM_FACTORY_M.MES_SOURCE_GROUP)으로 반영
						    ,'OFP0'+'_'+ ISNULL (  (SELECT TOP 1 L.MES_SOURCE_GROUP
							                        FROM   SCM_MMD_LINE_M L  WITH(NOLOCK)
											        WHERE  L.FACTORY_ID = M.FACTORY_ID 
									                AND    L.LINE_ID    = M.LINE_ID),ISNULL(F.MES_SOURCE_GROUP,''))
											 +'_'+'FP_DPP' AS IF_ID
						    --,@if_id_code        -- IF_ID
							,GETDATE()           IF_INS_DATE
							,'N'                 IF_FLAG
							,NULL                IF_SND_DATE
							,NULL                RSLT_IF_SEQ
							,NULL                RSLT_PROC_FLAG
							,NULL                RSLT_PROC_MSG
							,PLAN_ID
							,F.MES_PLANT_ID AS PLANT_ID  -- 2024-03-28 NERP PLANT_ID 변경에 따른 CONVERSION 반영 
							,M.[FACTORY_ID]
							,M.LINE_ID
							,M.[OPERATION_ID]
							,M.[EQUIPMENT_ID]
							,M.[ITEM_ID]
							,M.WO
							,M.WO_DETAIL
							,M.PLAN_DATE
							,M.[PLAN_IN_QTY]
							,M.[PLAN_QTY]
							,'PR_XIF_MES_DAILY_PP2_S' AS CREATE_PSN_ID
							,GETDATE() AS CREATE_DATE
							,'PR_XIF_MES_DAILY_PP2_S' AS UPDATE_PSN_ID
							,GETDATE() AS UPDATE_DATE
							,M.INSTANCE_ID																--ATTR_01
							,M.PLAN_GR_ID																--ATTR_02
							,@local_time												 AS  ATTR_03	--2018-05-28 PIYONG ADD
							--,COUNT(*) OVER(PARTITION BY M.[FACTORY_ID])					 AS  ATTR_04
							,M.FULL_CLEANING_FLAG														--ATTR_05
							,M.MODEL_TYPE_CHANGE_FLAG													--ATTR_06
							,M.MEMO																		--ATTR_07
							,M.JR_IN_QTY																--ATTR_08
							,M.JR_OUT_QTY																--ATTR_09
							,NULL														AS ATTR_10
							,M.ELECTRODE_TYPE
							,PM.PRE_DISPERSION_ID/*, V.PRE_DISPERSION_ID)*/ AS PRE_DISPERSION_ID
							,PM.PRE_DISPERSION_NAME/*, V.PRE_DISPERSION_NAME)*/ AS PRE_DISPERSION_NAME
							,PM.ACTIVE_MATERIAL_1/*, V.ACTIVE_MATERIAL_1)*/ AS ACTIVE_MATERIAL_1
							,PM.ACTIVE_MATERIAL_2/*, V.ACTIVE_MATERIAL_2)*/ AS ACTIVE_MATERIAL_2
							,PM.ACTIVE_MATERIAL_3/*, V.ACTIVE_MATERIAL_3)*/ AS ACTIVE_MATERIAL_3
   							,PM.BINDER_1/*, V.BINDER_1)*/ AS BINDER_1
							,PM.BINDER_2/*, V.BINDER_2)*/ AS BINDER_2
							,PM.BINDER_3/*, V.BINDER_3)*/ AS BINDER_3
							,PM.CONDUCTION_MATERIAL_1/*, V.CONDUCTION_MATERIAL_1)*/ AS CONDUCTION_MATERIAL_1
							,PM.CONDUCTION_MATERIAL_2/*, V.CONDUCTION_MATERIAL_2)*/ AS CONDUCTION_MATERIAL_2
							,PM.CMC/*, V.CMC)*/ AS CMC
							,FO.FOIL_ID
							,( 
									SELECT CONVERT( NUMERIC(10,4) ,MAX( CASE WHEN T.TACT_TIME > 0 THEN ROUND(60/T.TACT_TIME, 0) ELSE 0 END) )
									FROM SCM_TACT_TIME_M T
									WHERE T.COMPANY_ID = M.COMPANY_ID
										AND T.DIVISION_ID = M.DIVISION_ID
										AND T.SITE_ID = M.SITE_ID
										AND T.PLANT_ID = M.PLANT_ID
										AND T.FACTORY_ID = M.FACTORY_ID
										AND T.OPERATION_ID =  M.OPERATION_ID
										AND T.LINE_ID = M.FP_LINE_ID
										AND T.ITEM_ID = M.ITEM_ID
										AND T.ELECTRODE_TYPE = M.ELECTRODE_TYPE
										AND T.[MONTH] = REPLACE(SUBSTRING(M.PLAN_DATE, 1, 7), '-','')
																									) AS DAILY_CAPA_PPM
							--,ISNULL(PM.PROD_VERSION, V.PROD_VERSION) AS PROD_VERSION
							,CASE WHEN M.[VERSION] = '-' THEN NULL ELSE CASE WHEN F.ELEC_VERSION_TYPE = 'FP' THEN M.[VERSION] ELSE SUBSTRING(M.[VERSION],1,3) END END AS PROD_VERSION -- 2023-03-02 kimcd NJ 버전 예외 처리  -- 2022-10-31 kimcd 작업의뢰서 버전
							,M.ROLL_IN_QTY
							,M.ROLL_OUT_QTY
							,M.BATCH_IN_QTY
							,M.BATCH_OUT_QTY
							,M.CELL_IN_QTY
							,M.CELL_OUT_QTY
							,M.SEQ
							,M.CELL_MATERIAL_ID
							,M.[START_TIME]  -- 2020-12-16 kimcd 시작일시 추가
							,M.[END_TIME]    -- 2020-12-16 kimcd 종료일시 추가
							,M.[FP_LINE_ID]  -- 2021-04-16 kimcd FP line 추가
							,CASE WHEN M.[WORK_REQUEST_MODEL_ID] = '-' THEN NULL ELSE M.[WORK_REQUEST_MODEL_ID] END AS [WORK_REQUEST_MODEL_ID] -- 2023-03-03 kimcd NJ 전극의 경우 FP 전극 버전 그대로 전송 2022-10-31 kimcd [ATTR_12] 작업의뢰서 모델
							,M.[PROD_SEQ]              -- 2022-10-31 kimcd [ATTR_13] 작업의뢰서 버전별 차수
							,M.[PLM_EC_NO]             -- 2022-10-31 kimcd [ATTR_14] PLM EC NO
						FROM (
							SELECT [FP_PLAN_ID] AS PLAN_ID
									,SOURCES.COMPANY_ID
									,SOURCES.DIVISION_ID
									,SOURCES.SITE_ID
									,SOURCES.[PLANT_ID]   AS PLANT_ID
									,SOURCES.[FACTORY_ID]
									,ISNULL(SEM.MES_LINE_ID,ISNULL(CASE WHEN C.MES_LINE_ID = '' THEN NULL ELSE C.MES_LINE_ID END,SOURCES.LINE_ID)) AS LINE_ID -- 2022-07-27 kimcd 설비 정보 Option 화 line의 mes line id 직접 사용
									,SOURCES.LINE_ID AS FP_LINE_ID
									,SOURCES.[OPERATION_ID]
									,SOURCES.[EQUIPMENT_ID]
									,[ITEM_ID]
									,[WORK_ORDER_ID]     AS WO
									,[WORK_ORDER_SPL_ID] AS WO_DETAIL
									,CONVERT(NVARCHAR(50), PLAN_DATE, 120) AS PLAN_DATE
									,[PLAN_IN_QTY]
									,[PLAN_QTY]
									,SOURCES.INSTANCE_ID
									--,ISNULL( (
									--			SELECT D.PLAN_GROUP_ID
									--				FROM DBO.SCM_FP_PLAN_GROUP_DETAIL_H D WITH(NOLOCK)
									--				WHERE D.RELEASE_FLAG IN ( 'P', 'Y')
									--				AND D.RELEASE_PLAN_ID = ISNULL(@fp_plan_id,'0') ),'-') AS PLAN_GR_ID
									,@PLAN_GROUP_ID    AS PLAN_GR_ID  -- 2022-09-14 kimcd plan group id 대상 조회에서 조회된 결과 사용
									,SOURCES.FULL_CLEANING_FLAG
									,SOURCES.MODEL_TYPE_CHANGE_FLAG
									,(
										SELECT TOP 1 SUBSTRING(AM.[MEMO],1,200)
											FROM [FP_AMEND_MEMO_M] AM WITH(NOLOCK)
											WHERE AM.[INSTANCE_ID]     = SOURCES.[INSTANCE_ID]
											AND AM.[COMPANY_ID]      = SOURCES.[COMPANY_ID]
											AND AM.[DIVISION_ID]     = SOURCES.[DIVISION_ID]
											AND AM.[SITE_ID]         = SOURCES.[SITE_ID]
											AND AM.[PLANT_ID]        = SOURCES.[PLANT_ID]
											AND AM.[FACTORY_ID]      = SOURCES.[FACTORY_ID]
											AND AM.[OPERATION_ID]    = SOURCES.[OPERATION_ID]
											AND AM.[LINE_ID]         = SOURCES.[LINE_ID]
											AND AM.[PLAN_DATE]       = SOURCES.[PLAN_DATE]
											AND AM.[MARKET]          = SOURCES.[MARKET]
											AND AM.[PRODUCTION_TYPE] = SOURCES.[PRODUCTION_TYPE]
											AND AM.[TOP_ITEM_ID]     = SOURCES.[TOP_ITEM_ID]
											AND AM.[ITEM_ID]         = SOURCES.[ITEM_ID]				) AS MEMO
									,SOURCES.JR_IN_QTY
									,SOURCES.JR_OUT_QTY
									,SOURCES.ELECTRODE_TYPE
									,SOURCES.CALC_TYPE
									,C.PROD_VERSION_TYPE
									,SOURCES.ROLL_IN_QTY
									,SOURCES.ROLL_OUT_QTY
									,SOURCES.BATCH_IN_QTY
									,SOURCES.BATCH_OUT_QTY
									,SOURCES.CELL_IN_QTY
									,SOURCES.CELL_OUT_QTY
									,SOURCES.SEQ
									,SOURCES.CELL_MATERIAL_ID
									,CONVERT(NVARCHAR(20), SOURCES.[START_TIME], 120) AS START_TIME  -- 2020-12-16 kimcd 시작일시 추가
									,CONVERT(NVARCHAR(20), SOURCES.[END_TIME], 120) AS END_TIME      -- 2020-12-16 kimcd 종료일시 추가
									,SOURCES.[WORK_REQUEST_MODEL_ID] -- 2022-10-31 kimcd [ATTR_12] 작업의뢰서 모델
									,SOURCES.[VERSION]               -- 2022-10-31 kimcd [PROD_VERSION] 작업의뢰서 버전
									,SOURCES.[PROD_SEQ]              -- 2022-10-31 kimcd [ATTR_13] 작업의뢰서 버전별 차수
									,SOURCES.[PLM_EC_NO]             -- 2022-10-31 kimcd [ATTR_14] PLM EC NO
								FROM (
									SELECT *
										FROM [FP_DAILY_PRODUCTION_PLAN_R] SOURCES WITH(NOLOCK)
										WHERE SOURCES.FP_PLAN_ID = ISNULL(@fp_plan_id,'0')
										AND SOURCES.FIX_TYPE IN ('F','N') -- 2017-12-28 kimcd 확정 계획만 전송
										AND SOURCES.INSTANCE_ID = (
																	SELECT INSTANCE_ID
																		FROM DBO.SCM_FP_PLAN_DETAIL_H C  WITH(NOLOCK)
																		WHERE RELEASE_FLAG IN ( 'P', 'Y')
																		AND RELEASE_PLAN_ID = ISNULL(@fp_plan_id,'0')
																	UNION ALL
																	SELECT INSTANCE_ID
																		FROM DBO.SCM_FP_PLAN_GROUP_DETAIL_H D WITH(NOLOCK)
																		WHERE D.RELEASE_FLAG IN ( 'P', 'Y')
																		AND RELEASE_PLAN_ID = ISNULL(@fp_plan_id,'0')
																	)
									) SOURCES
									INNER JOIN SCM_LINE_M C WITH(NOLOCK)
											ON SOURCES.COMPANY_ID     = C.COMPANY_ID
											AND SOURCES.DIVISION_ID    = C.DIVISION_ID
											AND SOURCES.SITE_ID        = C.SITE_ID
											AND SOURCES.PLANT_ID       = C.PLANT_ID
											AND SOURCES.FACTORY_ID     = C.FACTORY_ID
											AND SOURCES.OPERATION_ID   = C.OPERATION_ID
											AND SOURCES.LINE_ID        = C.LINE_ID
											AND SOURCES.ELECTRODE_TYPE = C.ELECTRODE_TYPE
									LEFT OUTER JOIN SCM_EQUIPMENT_M SEM WITH(NOLOCK)
											ON SOURCES.COMPANY_ID     = SEM.COMPANY_ID
											AND SOURCES.DIVISION_ID    = SEM.DIVISION_ID
											AND SOURCES.SITE_ID        = SEM.SITE_ID
											AND SOURCES.PLANT_ID       = SEM.PLANT_ID
											AND SOURCES.FACTORY_ID     = SEM.FACTORY_ID
											AND SOURCES.OPERATION_ID   = SEM.OPERATION_ID
											AND SOURCES.LINE_ID        = SEM.LINE_ID
											AND SOURCES.EQUIPMENT_ID   = SEM.EQUIPMENT_ID
											AND SOURCES.ELECTRODE_TYPE = SEM.ELECTRODE_TYPE
							-- 2021-07-07 kimcd 계획 없는 라인 발생하면 DUMMY 품목 WO 전송 시작
							UNION ALL
							SELECT   @fp_plan_id AS PLAN_ID
									,C.COMPANY_ID
									,C.DIVISION_ID
									,C.SITE_ID
									,C.[PLANT_ID]   AS PLANT_ID
									,C.[FACTORY_ID]
									,ISNULL(CASE WHEN C.MES_LINE_ID = '' THEN NULL ELSE C.MES_LINE_ID END,C.LINE_ID) AS LINE_ID -- 2022-07-27 kimcd 설비 정보 Option 화 line Table의 MES LINE ID 사용
									,C.LINE_ID AS FP_LINE_ID
									,C.[OPERATION_ID]
									,'-' AS [EQUIPMENT_ID]
									,'DUMMY' [ITEM_ID]
									,'DUMMY' AS WO
									,'DUMMY' AS WO_DETAIL
									,CONVERT(NVARCHAR(50), CONVERT(DATETIME, CONVERT(DATE,GETDATE())), 120) AS PLAN_DATE
									,0 [PLAN_IN_QTY]
									,0 [PLAN_QTY]
									,@instance_id INSTANCE_ID
									--,ISNULL( (
									--			SELECT D.PLAN_GROUP_ID
									--				FROM DBO.SCM_FP_PLAN_GROUP_DETAIL_H D WITH(NOLOCK)
									--				WHERE D.RELEASE_FLAG IN ( 'P', 'Y')
									--				AND D.RELEASE_PLAN_ID = ISNULL(@fp_plan_id,'0') ),'-') AS PLAN_GR_ID
									,@PLAN_GROUP_ID    AS PLAN_GR_ID  -- 2022-09-14 kimcd plan group id 대상 조회에서 조회된 결과 사용
									,NULL AS FULL_CLEANING_FLAG
									,NULL AS MODEL_TYPE_CHANGE_FLAG
									,NULL AS MEMO
									,NULL AS JR_IN_QTY
									,NULL AS JR_OUT_QTY
									,C.ELECTRODE_TYPE
									,NULL AS CALC_TYPE
									,NULL AS PROD_VERSION_TYPE
									,NULL AS ROLL_IN_QTY
									,NULL AS ROLL_OUT_QTY
									,NULL AS BATCH_IN_QTY
									,NULL AS BATCH_OUT_QTY
									,NULL AS CELL_IN_QTY
									,NULL AS CELL_OUT_QTY
									,NULL AS SEQ
									,NULL AS CELL_MATERIAL_ID
									,CONVERT(NVARCHAR(50), CONVERT(DATETIME, CONVERT(DATE,GETDATE())), 120) AS START_TIME  -- 2020-12-16 kimcd 시작일시 추가
									,CONVERT(NVARCHAR(50), CONVERT(DATETIME, CONVERT(DATE,GETDATE())), 120) AS END_TIME      -- 2020-12-16 kimcd 종료일시 추가
									,NULL AS [WORK_REQUEST_MODEL_ID] -- 2022-10-31 kimcd [ATTR_12] 작업의뢰서 모델
									,NULL AS [VERSION]               -- 2022-10-31 kimcd [PROD_VERSION] 작업의뢰서 버전
									,NULL AS [PROD_SEQ]              -- 2022-10-31 kimcd [ATTR_13] 작업의뢰서 버전별 차수
									,NULL AS [PLM_EC_NO]             -- 2022-10-31 kimcd [ATTR_14] PLM EC NO
								FROM (   SELECT L.*
										 FROM  SCM_LINE_M   L WITH(NOLOCK)
											  ,SCM_OPERATION_M O WITH(NOLOCK)
											  ,FP_INSTANCE_FACTORY_M IFM WITH(NOLOCK)
										 WHERE L.COMPANY_ID    = O.COMPANY_ID
										 AND   L.DIVISION_ID   = O.DIVISION_ID
										 AND   L.SITE_ID       = O.SITE_ID
										 AND   L.OPERATION_ID  = O.OPERATION_ID
										 AND   L.FACTORY_ID    = IFM.FACTORY_ID
										 AND   O.INSTANCE_TYPE = IFM.INSTANCE_TYPE
										 AND   IFM.INSTANCE_ID = @INSTANCE_ID
										 AND   L.ACTIVE_FLAG   = 'Y'
										 AND   CASE WHEN @FACTORY_ID = '-' THEN @FACTORY_ID ELSE L.FACTORY_ID END = @FACTORY_ID
										 AND   CASE WHEN @PLAN_GROUP_ID = '-' THEN @PLAN_GROUP_ID ELSE L.MODEL_TYPE END = @PLAN_GROUP_ID
										 AND   NOT EXISTS ( SELECT 1
															FROM   SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
															WHERE  SLV.LOOKUP_TYPE_CODE  = 'INSTANCE_SPLIT_LINE_DEFINITION'
															AND    SLV.ACTIVE_FLAG       = 'Y'
															AND    SLV.SEGMENT2          = @INSTANCE_ID
															AND    SLV.SEGMENT3          = L.LINE_ID )
										 AND    NOT EXISTS (SELECT 1
															FROM   SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
															WHERE  SLV.LOOKUP_TYPE_CODE  = 'INSTANCE_SPLIT_LINE_DEFINITION'
															AND    SLV.ACTIVE_FLAG       = 'Y'
															AND    SLV.SEGMENT1          = @INSTANCE_ID)
										 UNION ALL
										 SELECT L.*
										 FROM  SCM_LINE_M   L WITH(NOLOCK)
											  ,SCM_OPERATION_M O WITH(NOLOCK)
											  ,FP_INSTANCE_FACTORY_M IFM WITH(NOLOCK)
										 WHERE L.COMPANY_ID    = O.COMPANY_ID
										 AND   L.DIVISION_ID   = O.DIVISION_ID
										 AND   L.SITE_ID       = O.SITE_ID
										 AND   L.OPERATION_ID  = O.OPERATION_ID
										 AND   L.FACTORY_ID    = IFM.FACTORY_ID
										 AND   O.INSTANCE_TYPE = IFM.INSTANCE_TYPE
										 AND   IFM.INSTANCE_ID = @INSTANCE_ID
										 AND   L.ACTIVE_FLAG   = 'Y'
										 AND   CASE WHEN @FACTORY_ID = '-' THEN @FACTORY_ID ELSE L.FACTORY_ID END = @FACTORY_ID
										 AND   CASE WHEN @PLAN_GROUP_ID = '-' THEN @PLAN_GROUP_ID ELSE L.MODEL_TYPE END = @PLAN_GROUP_ID
										 AND   L.LINE_ID IN ( SELECT SLV.SEGMENT3
															FROM   SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
															WHERE  SLV.LOOKUP_TYPE_CODE  = 'INSTANCE_SPLIT_LINE_DEFINITION'
															AND    SLV.ACTIVE_FLAG       = 'Y'
															AND    SLV.SEGMENT1          = @INSTANCE_ID )
											) C
								WHERE  	NOT EXISTS ( SELECT 1
													FROM [FP_DAILY_PRODUCTION_PLAN_R] SOURCES WITH(NOLOCK)
													WHERE SOURCES.FP_PLAN_ID = ISNULL(@fp_plan_id,'0')
													AND SOURCES.FIX_TYPE IN ('F','N') -- 2017-12-28 kimcd 확정 계획만 전송
													AND SOURCES.INSTANCE_ID = @instance_id
													AND SOURCES.COMPANY_ID     = C.COMPANY_ID
													AND SOURCES.DIVISION_ID    = C.DIVISION_ID
													AND SOURCES.SITE_ID        = C.SITE_ID
													AND SOURCES.PLANT_ID       = C.PLANT_ID
													AND SOURCES.FACTORY_ID     = C.FACTORY_ID
													AND SOURCES.OPERATION_ID   = C.OPERATION_ID
													AND SOURCES.LINE_ID        = C.LINE_ID
													AND SOURCES.ELECTRODE_TYPE = C.ELECTRODE_TYPE
													)
							-- 2021-07-07 kimcd 계획 없는 라인에 대해서 DUMMY 품목, WO 전송
							) M
							INNER JOIN SCM_FACTORY_M F WITH(NOLOCK)
							    ON  F.FACTORY_ID = M.FACTORY_ID -- 2023-03-03 kimcd NJ 전극의 경우 FP 전극 버전 그대로 전송
							LEFT OUTER JOIN #BASE_INFO PM
										ON M.COMPANY_ID			= PM.COMPANY_ID
										AND M.DIVISION_ID		= PM.DIVISION_ID
										AND M.SITE_ID			= PM.SITE_ID
										AND M.PLANT_ID			= PM.PLANT_ID
										AND M.FACTORY_ID		= PM.FACTORY_ID
										AND M.[WORK_REQUEST_MODEL_ID] = PM.MODEL_ID      -- 2022-10-31 kimcd 작업의뢰서 모델
									    AND M.[VERSION]               = PM.PROD_VERSION  -- 2022-10-31 kimcd 작업의뢰서 버전
										AND M.[PROD_SEQ]        = PM.PROD_SEQ            -- 2022-10-31 kimcd 작업의뢰서 차수
									    AND M.ITEM_ID			= PM.PC_ITEM_ID
										AND M.OPERATION_ID		IN (SELECT SEGMENT2 FROM SCM_CODE_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE = @v_proc_name AND SEGMENT1  = 'OPERATION_A' AND ACTIVE_FLAG = 'Y')  -- 2024-03-28 OPERATION_ID E2000 하드코딩 제거
										--AND M.PROD_VERSION_TYPE	= PM.PROD_VERSION_TYPE
										--AND (CASE WHEN (M.CALC_TYPE = 'TEST' OR M.CALC_TYPE = 'S-TEST') THEN 'TEST' ELSE 'MASS' END) = PM.PROD_TYPE

							--LEFT OUTER JOIN #BASE_INFO V
							--			ON M.COMPANY_ID			= V.COMPANY_ID
							--			AND M.DIVISION_ID		= V.DIVISION_ID
							--			AND M.SITE_ID			= V.SITE_ID
							--			AND M.PLANT_ID			= V.PLANT_ID
							--			AND M.FACTORY_ID		= V.FACTORY_ID
							--			AND M.ITEM_ID			= V.PC_ITEM_ID
							--			AND M.PROD_VERSION_TYPE	= V.PROD_VERSION_TYPE
							--			AND (CASE WHEN (M.CALC_TYPE = 'TEST' OR M.CALC_TYPE = 'S-TEST') THEN 'TEST' ELSE 'MASS' END) <> V.PROD_TYPE
							--			AND M.OPERATION_ID		= 'E2000'
							-- 2022-10-31 kimcd 작업의뢰서 버전 기준으로 조회문장 전환
							LEFT OUTER JOIN SCM_ITEM_FOIL_M FO WITH(NOLOCK)
							ON  M.FACTORY_ID = FO.FACTORY_ID
							AND M.[WORK_REQUEST_MODEL_ID] = FO.MODEL_ID
							AND M.[ITEM_ID]    = FO.ITEM_ID
							AND M.[VERSION]    = FO.PROD_VERSION
							AND M.[PROD_SEQ]   = FO.PROD_SEQ  -- 2022-10-31 kimcd 작업의뢰서 버전 기준으로 조회문장 전환
							--LEFT OUTER JOIN (
							--				SELECT FF.COMPANY_ID
							--						, FF.DIVISION_ID
							--						, FF.SITE_ID
							--						, FF.PLANT_ID
							--						, FF.FACTORY_ID
							--						, FF.ITEM_ID
							--						, FF.PROD_VERSION
							--						, FF.PROD_VERSION_TYPE
							--						, FF.FOIL_ID
							--					FROM (
							--						SELECT F.COMPANY_ID
							--								, F.DIVISION_ID
							--								, F.SITE_ID
							--								, F.PLANT_ID
							--								, F.FACTORY_ID
							--								, F.ITEM_ID
							--								, F.PROD_VERSION
							--								, F.PROD_VERSION_TYPE
							--								, F.FOIL_ID
							--								, ROW_NUMBER() OVER ( PARTITION BY F.COMPANY_ID, F.DIVISION_ID, F.SITE_ID, F.PLANT_ID, F.FACTORY_ID, F.ITEM_ID, F.PROD_VERSION_TYPE
							--															ORDER BY PV.APPLY_DATE DESC )	 AS NUM
							--							FROM SCM_ITEM_FOIL_M F WITH(NOLOCK)
							--								, FP_PROD_VERSION_M PV WITH(NOLOCK)
							--							WHERE F.COMPANY_ID = PV.COMPANY_ID
							--							AND F.DIVISION_ID = PV.DIVISION_ID
							--							AND F.SITE_ID = PV.SITE_ID
							--							AND F.PLANT_ID = PV.PLANT_ID
							--							AND F.FACTORY_ID = PV.FACTORY_ID
							--							AND F.MODEL_ID = PV.MODEL_ID
							--							AND F.ITEM_ID = PV.ITEM_ID
							--							AND F.PROD_VERSION = PV.PROD_VERSION
							--							AND F.PROD_SEQ = PV.PROD_SEQ
							--						) FF
							--					WHERE NUM =1 
							--				) FO
							--			ON M.COMPANY_ID = FO.COMPANY_ID
							--			AND M.DIVISION_ID = FO.DIVISION_ID
							--			AND M.SITE_ID = FO.SITE_ID
							--			AND M.PLANT_ID = FO.PLANT_ID
							--			AND M.FACTORY_ID = FO.FACTORY_ID
							--			AND M.ITEM_ID = FO.ITEM_ID
							--			AND M.PROD_VERSION_TYPE = FO.PROD_VERSION_TYPE
							-- 2022-10-31 kimcd foil 정보 직접 조회로 수정
										) SO
					;
					--------------------------------------------------------------------------------------------------------------------
					----- 2017-11-29 PIYONG   FP_DAILY_PRODUCTIOIN_PLAN_H 정보 생성 끝
					--------------------------------------------------------------------------------------------------------------------
					
					SET @ROWCOUNT = @@ROWCOUNT

					-- 2022-06-09 kimcd SPC 계획 전송 추가 시작
					INSERT INTO [dbo].[SY_XIF_MES_DAILY_PP_S] (
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
						,[WO]
						,[WO_DETAIL]
						,[PLAN_DATE]
						,[IN_QTY]
						,[OUT_QTY]
						,[CREATE_PSN_ID]
						,[CREATE_DATE]
						,[UPDATE_PSN_ID]
						,[UPDATE_DATE]
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
						,[ELECTRODE_TYPE]
						,[PRE_DISPERSION_ID]
						,[PRE_DISPERSION_NAME]
						,[ACTIVE_MATERIAL_1]
						,[ACTIVE_MATERIAL_2]
						,[ACTIVE_MATERIAL_3]
						,[BINDER_1]
						,[BINDER_2]
						,[BINDER_3]
						,[CONDUCTION_MATERIAL_1]
						,[CONDUCTION_MATERIAL_2]
						,[CMC]
						,[FOIL]
						,[DAILY_CAPA_PPM]
						,[PROD_VERSION]
						,[PANCAKE_IN_QTY]
						,[PANCAKE_OUT_QTY]
						,[BATCH_IN_QTY]
						,[BATCH_OUT_QTY]
						,[CELL_IN_QTY]
						,[CELL_OUT_QTY]
						,[SEQ]
						,[CELL_MATERIAL_ID]
						,[START_TIME]  -- 2020-12-16 kimcd 시작일시 추가
						,[END_TIME]    -- 2020-12-16 kimcd 종료일시 추가
						,[ATTR_11]     -- 2021-04-16 kimcd FP line 추가
						,[ATTR_12]     -- 2022-10-31 kimcd 작업의뢰서 모델
						,[ATTR_13]     -- 2022-10-31 kimcd 작업의뢰서 버전별 차수
						,[ATTR_14]     -- 2022-10-31 kimcd PLM EC NO
					)	
					SELECT 
					'OFP0' + SUBSTRING(CONVERT(NVARCHAR(12), GETDATE(), 112), 3,6) + REPLICATE('0', 10 - LEN(NEXT VALUE FOR [DBO].[XIF_MES_SEND_SEQ])) + CAST( NEXT VALUE FOR [DBO].[XIF_MES_SEND_SEQ] AS NVARCHAR)   AS IF_SEQ
                    , IF_TYPE
                    , IF_ID
                    , IF_INS_DATE
                    , IF_FLAG
                    , IF_SND_DATE
                    , RSLT_IF_SEQ
                    , RSLT_PROC_FLAG
                    , RSLT_PROC_MSG
                    , PLAN_ID
                    , F.MES_PLANT_ID  -- 2024-03-28 NERP PLANT_ID 변경에 따른 CONVERSION 반영 
                    , SO.FACTORY_ID
                    , LINE_ID
                    , OPERATION_ID
                    , EQUIPMENT_ID
                    , ITEM_ID
                    , WO
                    , WO_DETAIL
                    , PLAN_DATE
                    , PLAN_IN_QTY
                    , PLAN_QTY
                    , CREATE_PSN_ID
                    , CREATE_DATE
                    , UPDATE_PSN_ID
                    , UPDATE_DATE
                    , INSTANCE_ID
                    , PLAN_GR_ID
                    , ATTR_03
					--2021-05-27 kimis ESNJ 6동 GMES DB 분리에 따른 변경 : Interface Count를 FACTORY_ID에서 FACTORY_ID, IF_ID 기준으로 변경
                    , COUNT(*) OVER(PARTITION BY SO.FACTORY_ID, IF_ID)					 AS  ATTR_04
                    , FULL_CLEANING_FLAG
                    , MODEL_TYPE_CHANGE_FLAG 
                    , MEMO
                    , JR_IN_QTY
                    , JR_OUT_QTY
                    , ATTR_10
                    , ELECTRODE_TYPE
                    , PRE_DISPERSION_ID
                    , PRE_DISPERSION_NAME
                    , ACTIVE_MATERIAL_1
                    , ACTIVE_MATERIAL_2
                    , ACTIVE_MATERIAL_3
                    , BINDER_1
                    , BINDER_2
                    , BINDER_3
                    , CONDUCTION_MATERIAL_1
                    , CONDUCTION_MATERIAL_2
                    , CMC
                    , FOIL_ID
                    , DAILY_CAPA_PPM
                    , PROD_VERSION
                    , ROLL_IN_QTY
                    , ROLL_OUT_QTY
                    , BATCH_IN_QTY
                    , BATCH_OUT_QTY
                    , CELL_IN_QTY
                    , CELL_OUT_QTY
                    , SEQ
                    , CELL_MATERIAL_ID
                    , START_TIME
                    , END_TIME
                    , FP_LINE_ID
					, [WORK_REQUEST_MODEL_ID] -- 2022-10-31 kimcd [ATTR_12] 작업의뢰서 모델
					, [PROD_SEQ]              -- 2022-10-31 kimcd [ATTR_13] 작업의뢰서 버전별 차수
					, [PLM_EC_NO]             -- 2022-10-31 kimcd [ATTR_14] PLM EC NO
					FROM (
					SELECT 'S'                 IF_TYPE
							,'OFP0'+'_'+ ISNULL((SELECT TOP 1 F.SPC_SOURCE_GROUP FROM SCM_FACTORY_M F (NOLOCK) WHERE F.COMPANY_ID = M.COMPANY_ID AND F.FACTORY_ID = M.FACTORY_ID),'') +'_'+'FP_DPP' AS IF_ID
						    --,@if_id_code        -- IF_ID
							,GETDATE()           IF_INS_DATE
							,'N'                 IF_FLAG
							,NULL                IF_SND_DATE
							,NULL                RSLT_IF_SEQ
							,NULL                RSLT_PROC_FLAG
							,NULL                RSLT_PROC_MSG
							,PLAN_ID
                            ,M.COMPANY_ID  -- 2024-03-28 NERP PLANT_ID 변경에 따른 CONVERSION 반영 
							,M.PLANT_ID
							,M.[FACTORY_ID]
							,M.LINE_ID
							,M.[OPERATION_ID]
							,M.[EQUIPMENT_ID]
							,M.[ITEM_ID]
							,M.WO
							,M.WO_DETAIL
							,M.PLAN_DATE
							,M.[PLAN_IN_QTY]
							,M.[PLAN_QTY]
							,'PR_XIF_MES_DAILY_PP2_S' AS CREATE_PSN_ID
							,GETDATE() AS CREATE_DATE
							,'PR_XIF_MES_DAILY_PP2_S' AS UPDATE_PSN_ID
							,GETDATE() AS UPDATE_DATE
							,M.INSTANCE_ID																--ATTR_01
							,M.PLAN_GR_ID																--ATTR_02
							,@local_time												 AS  ATTR_03	--2018-05-28 PIYONG ADD
							--,COUNT(*) OVER(PARTITION BY M.[FACTORY_ID])					 AS  ATTR_04
							,M.FULL_CLEANING_FLAG														--ATTR_05
							,M.MODEL_TYPE_CHANGE_FLAG													--ATTR_06
							,M.MEMO																		--ATTR_07
							,M.JR_IN_QTY																--ATTR_08
							,M.JR_OUT_QTY																--ATTR_09
							,NULL														AS ATTR_10
							,M.ELECTRODE_TYPE
							,PM.PRE_DISPERSION_ID AS PRE_DISPERSION_ID
							,PM.PRE_DISPERSION_NAME AS PRE_DISPERSION_NAME
							,PM.ACTIVE_MATERIAL_1 AS ACTIVE_MATERIAL_1
							,PM.ACTIVE_MATERIAL_2 AS ACTIVE_MATERIAL_2
							,PM.ACTIVE_MATERIAL_3 AS ACTIVE_MATERIAL_3
   							,PM.BINDER_1 AS BINDER_1
							,PM.BINDER_2 AS BINDER_2
							,PM.BINDER_3 AS BINDER_3
							,PM.CONDUCTION_MATERIAL_1 AS CONDUCTION_MATERIAL_1
							,PM.CONDUCTION_MATERIAL_2 AS CONDUCTION_MATERIAL_2
							,PM.CMC AS CMC
							,FO.FOIL_ID
							,( 
									SELECT CONVERT( NUMERIC(10,4) ,MAX( CASE WHEN T.TACT_TIME > 0 THEN ROUND(60/T.TACT_TIME, 0) ELSE 0 END) )
									FROM SCM_TACT_TIME_M T
									WHERE T.COMPANY_ID = M.COMPANY_ID
										AND T.DIVISION_ID = M.DIVISION_ID
										AND T.SITE_ID = M.SITE_ID
										AND T.PLANT_ID = M.PLANT_ID
										AND T.FACTORY_ID = M.FACTORY_ID
										AND T.OPERATION_ID =  M.OPERATION_ID
										AND T.LINE_ID = M.FP_LINE_ID
										AND T.ITEM_ID = M.ITEM_ID
										AND T.ELECTRODE_TYPE = M.ELECTRODE_TYPE
										AND T.[MONTH] = REPLACE(SUBSTRING(M.PLAN_DATE, 1, 7), '-','')
																									) AS DAILY_CAPA_PPM
							,M.[VERSION] AS PROD_VERSION
							,M.ROLL_IN_QTY
							,M.ROLL_OUT_QTY
							,M.BATCH_IN_QTY
							,M.BATCH_OUT_QTY
							,M.CELL_IN_QTY
							,M.CELL_OUT_QTY
							,M.SEQ
							,M.CELL_MATERIAL_ID
							,M.[START_TIME]  -- 2020-12-16 kimcd 시작일시 추가
							,M.[END_TIME]    -- 2020-12-16 kimcd 종료일시 추가
							,M.[FP_LINE_ID]  -- 2021-04-16 kimcd FP line 추가
							,M.[WORK_REQUEST_MODEL_ID] -- 2022-10-31 kimcd [ATTR_12] 작업의뢰서 모델
							,M.[PROD_SEQ]              -- 2022-10-31 kimcd [ATTR_13] 작업의뢰서 버전별 차수
							,M.[PLM_EC_NO]             -- 2022-10-31 kimcd [ATTR_14] PLM EC NO
						FROM (
							SELECT [FP_PLAN_ID] AS PLAN_ID
									,SOURCES.COMPANY_ID
									,SOURCES.DIVISION_ID
									,SOURCES.SITE_ID
									,SOURCES.[PLANT_ID]   AS PLANT_ID
									,SOURCES.[FACTORY_ID]
									,ISNULL(SEM.MES_LINE_ID,ISNULL(CASE WHEN C.MES_LINE_ID = '' THEN NULL ELSE C.MES_LINE_ID END,SOURCES.LINE_ID)) AS LINE_ID -- 2022-07-27 kimcd 설비 정보 Option 화 line의 mes line id 직접 사용
									,SOURCES.LINE_ID AS FP_LINE_ID
									,SOURCES.[OPERATION_ID]
									,SOURCES.[EQUIPMENT_ID]
									,[ITEM_ID]
									,[WORK_ORDER_ID]     AS WO
									,[WORK_ORDER_SPL_ID] AS WO_DETAIL
									,CONVERT(NVARCHAR(50), PLAN_DATE, 120) AS PLAN_DATE
									,[PLAN_IN_QTY]
									,[PLAN_QTY]
									,SOURCES.INSTANCE_ID
									--,ISNULL( (
									--			SELECT D.PLAN_GROUP_ID
									--				FROM DBO.SCM_FP_PLAN_GROUP_DETAIL_H D WITH(NOLOCK)
									--				WHERE D.RELEASE_FLAG IN ( 'P', 'Y')
									--				AND D.RELEASE_PLAN_ID = ISNULL(@fp_plan_id,'0') ),'-') AS PLAN_GR_ID
									,@PLAN_GROUP_ID    AS PLAN_GR_ID  -- 2022-09-14 kimcd plan group id 대상 조회에서 조회된 결과 사용
									,SOURCES.FULL_CLEANING_FLAG
									,SOURCES.MODEL_TYPE_CHANGE_FLAG
									,(
										SELECT TOP 1 SUBSTRING(AM.[MEMO],1,200)
											FROM [FP_AMEND_MEMO_M] AM WITH(NOLOCK)
											WHERE AM.[INSTANCE_ID]     = SOURCES.[INSTANCE_ID]
											AND AM.[COMPANY_ID]      = SOURCES.[COMPANY_ID]
											AND AM.[DIVISION_ID]     = SOURCES.[DIVISION_ID]
											AND AM.[SITE_ID]         = SOURCES.[SITE_ID]
											AND AM.[PLANT_ID]        = SOURCES.[PLANT_ID]
											AND AM.[FACTORY_ID]      = SOURCES.[FACTORY_ID]
											AND AM.[OPERATION_ID]    = SOURCES.[OPERATION_ID]
											AND AM.[LINE_ID]         = SOURCES.[LINE_ID]
											AND AM.[PLAN_DATE]       = SOURCES.[PLAN_DATE]
											AND AM.[MARKET]          = SOURCES.[MARKET]
											AND AM.[PRODUCTION_TYPE] = SOURCES.[PRODUCTION_TYPE]
											AND AM.[TOP_ITEM_ID]     = SOURCES.[TOP_ITEM_ID]
											AND AM.[ITEM_ID]         = SOURCES.[ITEM_ID]				) AS MEMO
									,SOURCES.JR_IN_QTY
									,SOURCES.JR_OUT_QTY
									,SOURCES.ELECTRODE_TYPE
									,SOURCES.CALC_TYPE
									,C.PROD_VERSION_TYPE
									,SOURCES.ROLL_IN_QTY
									,SOURCES.ROLL_OUT_QTY
									,SOURCES.BATCH_IN_QTY
									,SOURCES.BATCH_OUT_QTY
									,SOURCES.CELL_IN_QTY
									,SOURCES.CELL_OUT_QTY
									,SOURCES.SEQ
									,SOURCES.CELL_MATERIAL_ID
									,CONVERT(NVARCHAR(20), SOURCES.[START_TIME], 120) AS START_TIME  -- 2020-12-16 kimcd 시작일시 추가
									,CONVERT(NVARCHAR(20), SOURCES.[END_TIME], 120) AS END_TIME      -- 2020-12-16 kimcd 종료일시 추가
									,SOURCES.[WORK_REQUEST_MODEL_ID] -- 2022-10-31 kimcd [ATTR_12] 작업의뢰서 모델
									,SOURCES.[VERSION]               -- 2022-10-31 kimcd [PROD_VERSION] 작업의뢰서 버전
									,SOURCES.[PROD_SEQ]              -- 2022-10-31 kimcd [ATTR_13] 작업의뢰서 버전별 차수
									,SOURCES.[PLM_EC_NO]             -- 2022-10-31 kimcd [ATTR_14] PLM EC NO
								FROM (
									SELECT *
										FROM [FP_DAILY_PRODUCTION_PLAN_R] SOURCES WITH(NOLOCK)
										WHERE SOURCES.FP_PLAN_ID = ISNULL(@fp_plan_id,'0')
										AND SOURCES.PLAN_DATE <  @enddate -- 계획 전송 조건
										AND SOURCES.INSTANCE_ID = (
																	SELECT INSTANCE_ID
																		FROM DBO.SCM_FP_PLAN_DETAIL_H C  WITH(NOLOCK)
																		WHERE RELEASE_FLAG IN ( 'P', 'Y')
																		AND RELEASE_PLAN_ID = ISNULL(@fp_plan_id,'0')
																	UNION ALL
																	SELECT INSTANCE_ID
																		FROM DBO.SCM_FP_PLAN_GROUP_DETAIL_H D WITH(NOLOCK)
																		WHERE D.RELEASE_FLAG IN ( 'P', 'Y')
																		AND RELEASE_PLAN_ID = ISNULL(@fp_plan_id,'0')
																	)
										AND EXISTS (SELECT 1 FROM SCM_FACTORY_M F (NOLOCK) WHERE F.COMPANY_ID = SOURCES.COMPANY_ID AND F.FACTORY_ID = SOURCES.FACTORY_ID AND F.SPC_SOURCE_GROUP IS NOT NULL )
									) SOURCES
									INNER JOIN SCM_LINE_M C WITH(NOLOCK)
											ON SOURCES.COMPANY_ID     = C.COMPANY_ID
											AND SOURCES.DIVISION_ID    = C.DIVISION_ID
											AND SOURCES.SITE_ID        = C.SITE_ID
											AND SOURCES.PLANT_ID       = C.PLANT_ID
											AND SOURCES.FACTORY_ID     = C.FACTORY_ID
											AND SOURCES.OPERATION_ID   = C.OPERATION_ID
											AND SOURCES.LINE_ID        = C.LINE_ID
											AND SOURCES.ELECTRODE_TYPE = C.ELECTRODE_TYPE
									LEFT OUTER JOIN SCM_EQUIPMENT_M SEM WITH(NOLOCK)
											ON SOURCES.COMPANY_ID     = SEM.COMPANY_ID
											AND SOURCES.DIVISION_ID    = SEM.DIVISION_ID
											AND SOURCES.SITE_ID        = SEM.SITE_ID
											AND SOURCES.PLANT_ID       = SEM.PLANT_ID
											AND SOURCES.FACTORY_ID     = SEM.FACTORY_ID
											AND SOURCES.OPERATION_ID   = SEM.OPERATION_ID
											AND SOURCES.LINE_ID        = SEM.LINE_ID
											AND SOURCES.EQUIPMENT_ID   = SEM.EQUIPMENT_ID
											AND SOURCES.ELECTRODE_TYPE = SEM.ELECTRODE_TYPE
							-- 2021-07-07 kimcd 계획 없는 라인 발생하면 DUMMY 품목 WO 전송 시작
							UNION ALL
							SELECT   @fp_plan_id AS PLAN_ID
									,C.COMPANY_ID
									,C.DIVISION_ID
									,C.SITE_ID
									,C.[PLANT_ID]   AS PLANT_ID
									,C.[FACTORY_ID]
									,ISNULL(CASE WHEN C.MES_LINE_ID = '' THEN NULL ELSE C.MES_LINE_ID END,C.LINE_ID) AS LINE_ID -- 2022-07-27 kimcd 설비 정보 Option 화 line Table의 MES LINE ID 사용
									,C.LINE_ID AS FP_LINE_ID
									,C.[OPERATION_ID]
									,'-' AS [EQUIPMENT_ID]  -- 2022-07-27 kimcd 설비 정보 Option 화 설비 제거
									,'DUMMY' [ITEM_ID]
									,'DUMMY' AS WO
									,'DUMMY' AS WO_DETAIL
									,CONVERT(NVARCHAR(50), CONVERT(DATETIME, CONVERT(DATE,GETDATE())), 120) AS PLAN_DATE
									,0 [PLAN_IN_QTY]
									,0 [PLAN_QTY]
									,@instance_id INSTANCE_ID
									--,ISNULL( (
									--			SELECT D.PLAN_GROUP_ID
									--				FROM DBO.SCM_FP_PLAN_GROUP_DETAIL_H D WITH(NOLOCK)
									--				WHERE D.RELEASE_FLAG IN ( 'P', 'Y')
									--				AND D.RELEASE_PLAN_ID = ISNULL(@fp_plan_id,'0') ),'-') AS PLAN_GR_ID
									,@PLAN_GROUP_ID    AS PLAN_GR_ID  -- 2022-09-14 kimcd plan group id 대상 조회에서 조회된 결과 사용
									,NULL AS FULL_CLEANING_FLAG
									,NULL AS MODEL_TYPE_CHANGE_FLAG
									,NULL AS MEMO
									,NULL AS JR_IN_QTY
									,NULL AS JR_OUT_QTY
									,C.ELECTRODE_TYPE
									,NULL AS CALC_TYPE
									,NULL AS PROD_VERSION_TYPE
									,NULL AS ROLL_IN_QTY
									,NULL AS ROLL_OUT_QTY
									,NULL AS BATCH_IN_QTY
									,NULL AS BATCH_OUT_QTY
									,NULL AS CELL_IN_QTY
									,NULL AS CELL_OUT_QTY
									,NULL AS SEQ
									,NULL AS CELL_MATERIAL_ID
									,CONVERT(NVARCHAR(50), CONVERT(DATETIME, CONVERT(DATE,GETDATE())), 120) AS START_TIME  -- 2020-12-16 kimcd 시작일시 추가
									,CONVERT(NVARCHAR(50), CONVERT(DATETIME, CONVERT(DATE,GETDATE())), 120) AS END_TIME      -- 2020-12-16 kimcd 종료일시 추가
									,NULL AS [WORK_REQUEST_MODEL_ID] -- 2022-10-31 kimcd [ATTR_12] 작업의뢰서 모델
									,NULL AS [VERSION]               -- 2022-10-31 kimcd [PROD_VERSION] 작업의뢰서 버전
									,NULL AS [PROD_SEQ]              -- 2022-10-31 kimcd [ATTR_13] 작업의뢰서 버전별 차수
									,NULL AS [PLM_EC_NO]             -- 2022-10-31 kimcd [ATTR_14] PLM EC NO
								FROM (   SELECT L.*
										 FROM  SCM_LINE_M   L WITH(NOLOCK)
											  ,SCM_OPERATION_M O WITH(NOLOCK)
											  ,FP_INSTANCE_FACTORY_M IFM WITH(NOLOCK)
										 WHERE L.COMPANY_ID    = O.COMPANY_ID
										 AND   L.DIVISION_ID   = O.DIVISION_ID
										 AND   L.SITE_ID       = O.SITE_ID
										 AND   L.OPERATION_ID  = O.OPERATION_ID
										 AND   L.FACTORY_ID    = IFM.FACTORY_ID
										 AND   O.INSTANCE_TYPE = IFM.INSTANCE_TYPE
										 AND   IFM.INSTANCE_ID = @INSTANCE_ID
										 AND   L.ACTIVE_FLAG   = 'Y'
										 AND   CASE WHEN @FACTORY_ID = '-' THEN @FACTORY_ID ELSE L.FACTORY_ID END = @FACTORY_ID
										 AND   CASE WHEN @PLAN_GROUP_ID = '-' THEN @PLAN_GROUP_ID ELSE L.MODEL_TYPE END = @PLAN_GROUP_ID
										 AND   NOT EXISTS ( SELECT 1
															FROM   SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
															WHERE  SLV.LOOKUP_TYPE_CODE  = 'INSTANCE_SPLIT_LINE_DEFINITION'
															AND    SLV.ACTIVE_FLAG       = 'Y'
															AND    SLV.SEGMENT2          = @INSTANCE_ID
															AND    SLV.SEGMENT3          = L.LINE_ID )
										 AND    NOT EXISTS (SELECT 1
															FROM   SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
															WHERE  SLV.LOOKUP_TYPE_CODE  = 'INSTANCE_SPLIT_LINE_DEFINITION'
															AND    SLV.ACTIVE_FLAG       = 'Y'
															AND    SLV.SEGMENT1          = @INSTANCE_ID)
										 UNION ALL
										 SELECT L.*
										 FROM  SCM_LINE_M   L WITH(NOLOCK)
											  ,SCM_OPERATION_M O WITH(NOLOCK)
											  ,FP_INSTANCE_FACTORY_M IFM WITH(NOLOCK)
										 WHERE L.COMPANY_ID    = O.COMPANY_ID
										 AND   L.DIVISION_ID   = O.DIVISION_ID
										 AND   L.SITE_ID       = O.SITE_ID
										 AND   L.OPERATION_ID  = O.OPERATION_ID
										 AND   L.FACTORY_ID    = IFM.FACTORY_ID
										 AND   O.INSTANCE_TYPE = IFM.INSTANCE_TYPE
										 AND   IFM.INSTANCE_ID = @INSTANCE_ID
										 AND   L.ACTIVE_FLAG   = 'Y'
										 AND   CASE WHEN @FACTORY_ID = '-' THEN @FACTORY_ID ELSE L.FACTORY_ID END = @FACTORY_ID
										 AND   CASE WHEN @PLAN_GROUP_ID = '-' THEN @PLAN_GROUP_ID ELSE L.MODEL_TYPE END = @PLAN_GROUP_ID
										 AND   L.LINE_ID IN ( SELECT SLV.SEGMENT3
															FROM   SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
															WHERE  SLV.LOOKUP_TYPE_CODE  = 'INSTANCE_SPLIT_LINE_DEFINITION'
															AND    SLV.ACTIVE_FLAG       = 'Y'
															AND    SLV.SEGMENT1          = @INSTANCE_ID )
											) C
								WHERE NOT EXISTS ( SELECT 1
													FROM [FP_DAILY_PRODUCTION_PLAN_R] SOURCES WITH(NOLOCK)
													WHERE SOURCES.FP_PLAN_ID = ISNULL(@fp_plan_id,'0')
													AND SOURCES.PLAN_DATE    <  @enddate -- 계획 전송 조건
													AND SOURCES.INSTANCE_ID = @instance_id
													AND SOURCES.COMPANY_ID     = C.COMPANY_ID
													AND SOURCES.DIVISION_ID    = C.DIVISION_ID
													AND SOURCES.SITE_ID        = C.SITE_ID
													AND SOURCES.PLANT_ID       = C.PLANT_ID
													AND SOURCES.FACTORY_ID     = C.FACTORY_ID
													AND SOURCES.OPERATION_ID   = C.OPERATION_ID
													AND SOURCES.LINE_ID        = C.LINE_ID
													AND SOURCES.ELECTRODE_TYPE = C.ELECTRODE_TYPE
													)
								AND    EXISTS (SELECT 1 FROM SCM_FACTORY_M F (NOLOCK) WHERE F.COMPANY_ID = C.COMPANY_ID AND F.FACTORY_ID = C.FACTORY_ID AND F.SPC_SOURCE_GROUP IS NOT NULL )
							-- 2021-07-07 kimcd 계획 없는 라인에 대해서 DUMMY 품목, WO 전송
							) M
							LEFT OUTER JOIN #BASE_INFO PM
										ON M.COMPANY_ID			= PM.COMPANY_ID
										AND M.DIVISION_ID		= PM.DIVISION_ID
										AND M.SITE_ID			= PM.SITE_ID
										AND M.PLANT_ID			= PM.PLANT_ID
										AND M.FACTORY_ID		= PM.FACTORY_ID
										AND M.[WORK_REQUEST_MODEL_ID] = PM.MODEL_ID      -- 2022-10-31 kimcd 작업의뢰서 모델
									    AND M.[VERSION]               = PM.PROD_VERSION  -- 2022-10-31 kimcd 작업의뢰서 버전
										AND M.[PROD_SEQ]        = PM.PROD_SEQ            -- 2022-10-31 kimcd 작업의뢰서 차수
									    AND M.ITEM_ID			= PM.PC_ITEM_ID
										AND M.OPERATION_ID		IN (SELECT SEGMENT2 FROM SCM_CODE_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE = @v_proc_name AND SEGMENT1  = 'OPERATION_A' AND ACTIVE_FLAG = 'Y')  -- 2024-03-28 OPERATION_ID E2000 하드코딩 제거
										--AND M.PROD_VERSION_TYPE	= PM.PROD_VERSION_TYPE
										--AND (CASE WHEN (M.CALC_TYPE = 'TEST' OR M.CALC_TYPE = 'S-TEST') THEN 'TEST' ELSE 'MASS' END) = PM.PROD_TYPE

							LEFT OUTER JOIN SCM_ITEM_FOIL_M FO WITH(NOLOCK)
							ON  M.FACTORY_ID = FO.FACTORY_ID
							AND M.[WORK_REQUEST_MODEL_ID] = FO.MODEL_ID
							AND M.[ITEM_ID]    = FO.ITEM_ID
							AND M.[VERSION]    = FO.PROD_VERSION
							AND M.[PROD_SEQ]   = FO.PROD_SEQ  -- 2022-10-31 kimcd 작업의뢰서 버전 기준으로 조회문장 전환
						) SO
                        INNER JOIN [dbo].[SCM_FACTORY_M] F WITH(NOLOCK)
                        ON    SO.COMPANY_ID = F.COMPANY_ID
                        AND   SO.FACTORY_ID = F.FACTORY_ID  -- 2024-03-28 NERP PLANT_ID 변경에 따른 CONVERSION 반영 
					;
					SET @ROWCOUNT = @ROWCOUNT + @@ROWCOUNT
					-- 2022-06-09 kimcd SPC 계획 전송 추가 끝

					-- 2020-12-01 kimcd 오창 소형의 경우 오창 FCS로 계획 전송하도록 추가 시작
					IF @instance_id = 'KR_CELL_M' 
						BEGIN
							INSERT INTO [dbo].[SY_XIF_MES_DAILY_PP_S] (
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
								,[WO]
								,[WO_DETAIL]
								,[PLAN_DATE]
								,[IN_QTY]
								,[OUT_QTY]
								,[CREATE_PSN_ID]
								,[CREATE_DATE]
								,[UPDATE_PSN_ID]
								,[UPDATE_DATE]
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
								,[ELECTRODE_TYPE]
								,[DAILY_CAPA_PPM]
								,[PANCAKE_IN_QTY]
								,[PANCAKE_OUT_QTY]
								,[BATCH_IN_QTY]
								,[BATCH_OUT_QTY]
								,[CELL_IN_QTY]
								,[CELL_OUT_QTY]
								,[SEQ]
								,[CELL_MATERIAL_ID]
								,[START_TIME]  -- 2020-12-16 kimcd 시작일시 추가
								,[END_TIME]    -- 2020-12-16 kimcd 종료일시 추가
								,[ATTR_11]     -- 2021-04-16 kimcd FP line 추가
								,[ATTR_14]     -- 2022-10-31 kimcd PLM EC NO
							)	
							-- 2021-07-07 kimcd 남경 8동 복수 DB 사용에 따른 수정 시작
							SELECT 'OFP0' + SUBSTRING(CONVERT(NVARCHAR(12), GETDATE(), 112), 3,6) + REPLICATE('0', 10 - LEN(NEXT VALUE FOR [DBO].[XIF_MES_SEND_SEQ])) + CAST( NEXT VALUE FOR [DBO].[XIF_MES_SEND_SEQ] AS NVARCHAR)   -- IF_SEQ
									, 'S'                -- IF_TYPE
									, [IF_ID]
									, GETDATE()          -- IF_INS_DATE
									, 'N'                -- IF_FLAG
									, NULL               -- IF_SND_DATE
									, NULL               -- RSLT_IF_SEQ
									, NULL               -- RSLT_PROC_FLAG
									, NULL               -- RSLT_PROC_MSG
									, M.PLAN_ID
                                    , F.MES_PLANT_ID     -- 2024-03-28 NERP PLANT_ID 변경에 따른 CONVERSION 반영
                                    , M.[FACTORY_ID]
                                    , M.LINE_ID
                                    , M.[OPERATION_ID]
                                    , M.[EQUIPMENT_ID]
                                    , M.[ITEM_ID]
                                    , M.WO
                                    , M.WO_DETAIL
                                    , M.PLAN_DATE
                                    , M.[PLAN_IN_QTY]
                                    , M.[PLAN_QTY]
									, M.CREATE_PSN_ID
                                    , M.CREATE_DATE
                                    , M.UPDATE_PSN_ID
                                    , M.UPDATE_DATE
                                    , M.INSTANCE_ID
                                    , M.PLAN_GR_ID
                                    , M.ATTR_03
									, COUNT(*) OVER(PARTITION BY M.IF_ID, M.[FACTORY_ID])					 AS  ATTR_04
									, M.FULL_CLEANING_FLAG
                                    , M.MODEL_TYPE_CHANGE_FLAG
                                    , M.MEMO
                                    , M.JR_IN_QTY
                                    , M.JR_OUT_QTY
                                    , M.ATTR_10
                                    , M.ELECTRODE_TYPE
                                    , M.DAILY_CAPA_PPM
									, M.ROLL_IN_QTY
                                    , M.ROLL_OUT_QTY
                                    , M.BATCH_IN_QTY
                                    , M.BATCH_OUT_QTY
                                    , M.CELL_IN_QTY
                                    , M.CELL_OUT_QTY
                                    , M.SEQ
                                    , M.CELL_MATERIAL_ID
                                    , M.[START_TIME]
                                    , M.[END_TIME]
                                    , M.[FP_LINE_ID]
									, M.[PLM_EC_NO]             -- 2022-10-31 kimcd [ATTR_14] PLM EC NO
							FROM  (
							-- 2021-07-07 kimcd 남경 8동 복수 DB 사용에 따른 수정 종료
							SELECT 
								--SELECT ''
									'OFP0'+'_'+(SELECT TOP 1 ISNULL ((SELECT TOP 1 L.FCS_SOURCE_GROUP
																	  FROM   SCM_MMD_LINE_M L  WITH(NOLOCK)
																	  WHERE  L.FACTORY_ID = M.FACTORY_ID 
																	  AND    L.LINE_ID    = M.LINE_ID),ISNULL(F.FCS_SOURCE_GROUP,''))
												FROM SCM_FACTORY_M F WITH(NOLOCK) WHERE F.FACTORY_ID = M.FACTORY_ID) +'_'+'FP_DPP' AS [IF_ID]
									-- 2021-07-07 kimcd 남경 8동 복수 DB 사용에 따른 IF_ID 문장 수정
									--,@if_id_code        -- IF_ID
									,PLAN_ID
                                    ,M.COMPANY_ID  -- 2024-03-28 NERP PLANT_ID 변경에 따른 CONVERSION 반영 
									,M.PLANT_ID
									,M.[FACTORY_ID]
									,M.LINE_ID
									,M.[OPERATION_ID]
									,M.[EQUIPMENT_ID]
									,M.[ITEM_ID]
									,M.WO
									,M.WO_DETAIL
									,M.PLAN_DATE
									,M.[PLAN_IN_QTY]
									,M.[PLAN_QTY]
									,'PR_XIF_MES_DAILY_PP2_S' AS CREATE_PSN_ID
									,GETDATE() AS CREATE_DATE
									,'PR_XIF_MES_DAILY_PP2_S' AS UPDATE_PSN_ID
									,GETDATE() AS UPDATE_DATE
									,M.INSTANCE_ID																--ATTR_01
									,M.PLAN_GR_ID																--ATTR_02
									,@local_time												 AS  ATTR_03	--2018-05-28 PIYONG ADD
									,COUNT(*) OVER(PARTITION BY M.[FACTORY_ID])					 AS  ATTR_04
									,M.FULL_CLEANING_FLAG														--ATTR_05
									,M.MODEL_TYPE_CHANGE_FLAG													--ATTR_06
									,M.MEMO																		--ATTR_07
									,M.JR_IN_QTY																--ATTR_08
									,M.JR_OUT_QTY																--ATTR_09
									,NULL														AS ATTR_10
									,M.ELECTRODE_TYPE
									,( 
											SELECT CONVERT( NUMERIC(10,4) ,MAX( CASE WHEN T.TACT_TIME > 0 THEN ROUND(60/T.TACT_TIME, 0) ELSE 0 END) )
											FROM SCM_TACT_TIME_M T
											WHERE T.COMPANY_ID = M.COMPANY_ID
												AND T.DIVISION_ID = M.DIVISION_ID
												AND T.SITE_ID = M.SITE_ID
												AND T.PLANT_ID = M.PLANT_ID
												AND T.FACTORY_ID = M.FACTORY_ID
												AND T.OPERATION_ID =  M.OPERATION_ID
												AND T.LINE_ID = M.FP_LINE_ID
												AND T.ITEM_ID = M.ITEM_ID
												AND T.ELECTRODE_TYPE = M.ELECTRODE_TYPE
												AND T.[MONTH] = REPLACE(SUBSTRING(M.PLAN_DATE, 1, 7), '-','')
																											) AS DAILY_CAPA_PPM
									,M.ROLL_IN_QTY
									,M.ROLL_OUT_QTY
									,M.BATCH_IN_QTY
									,M.BATCH_OUT_QTY
									,M.CELL_IN_QTY
									,M.CELL_OUT_QTY
									,M.SEQ
									,M.CELL_MATERIAL_ID
									,M.[START_TIME]  -- 2020-12-16 kimcd 시작일시 추가
									,M.[END_TIME]    -- 2020-12-16 kimcd 종료일시 추가
									,M.[FP_LINE_ID]  -- 2021-04-16 kimcd FP line 추가
									,M.[PLM_EC_NO]   -- 2022-10-31 kimcd [ATTR_14] PLM EC NO
								FROM (
									SELECT [FP_PLAN_ID] AS PLAN_ID
											,SOURCES.COMPANY_ID
											,SOURCES.DIVISION_ID
											,SOURCES.SITE_ID
											,SOURCES.[PLANT_ID]   AS PLANT_ID
											,SOURCES.[FACTORY_ID]
											,ISNULL(CASE WHEN C.MES_LINE_ID = '' THEN NULL ELSE C.MES_LINE_ID END,SOURCES.LINE_ID) AS LINE_ID -- 2022-07-27 kimcd 설비 정보 Option 화 line의 mes line id 직접 사용
											,SOURCES.LINE_ID AS FP_LINE_ID
											,SOURCES.[OPERATION_ID]
											,[EQUIPMENT_ID]
											,[ITEM_ID]
											,[WORK_ORDER_ID]     AS WO
											,[WORK_ORDER_SPL_ID] AS WO_DETAIL
											,CONVERT(NVARCHAR(50), PLAN_DATE, 120) AS PLAN_DATE
											,[PLAN_IN_QTY]
											,[PLAN_QTY]
											,SOURCES.INSTANCE_ID
											--,ISNULL( (
											--			SELECT D.PLAN_GROUP_ID
											--				FROM DBO.SCM_FP_PLAN_GROUP_DETAIL_H D WITH(NOLOCK)
											--				WHERE D.RELEASE_FLAG IN ( 'P', 'Y')
											--				AND D.RELEASE_PLAN_ID = ISNULL(@fp_plan_id,'0') ),'-') AS PLAN_GR_ID
											,@PLAN_GROUP_ID    AS PLAN_GR_ID  -- 2022-09-14 kimcd plan group id 대상 조회에서 조회된 결과 사용
											,SOURCES.FULL_CLEANING_FLAG
											,SOURCES.MODEL_TYPE_CHANGE_FLAG
											,(
												SELECT TOP 1 SUBSTRING(AM.[MEMO],1,200)
													FROM [FP_AMEND_MEMO_M] AM WITH(NOLOCK)
													WHERE AM.[INSTANCE_ID]     = SOURCES.[INSTANCE_ID]
													AND AM.[COMPANY_ID]      = SOURCES.[COMPANY_ID]
													AND AM.[DIVISION_ID]     = SOURCES.[DIVISION_ID]
													AND AM.[SITE_ID]         = SOURCES.[SITE_ID]
													AND AM.[PLANT_ID]        = SOURCES.[PLANT_ID]
													AND AM.[FACTORY_ID]      = SOURCES.[FACTORY_ID]
													AND AM.[OPERATION_ID]    = SOURCES.[OPERATION_ID]
													AND AM.[LINE_ID]         = SOURCES.[LINE_ID]
													AND AM.[PLAN_DATE]       = SOURCES.[PLAN_DATE]
													AND AM.[MARKET]          = SOURCES.[MARKET]
													AND AM.[PRODUCTION_TYPE] = SOURCES.[PRODUCTION_TYPE]
													AND AM.[TOP_ITEM_ID]     = SOURCES.[TOP_ITEM_ID]
													AND AM.[ITEM_ID]         = SOURCES.[ITEM_ID]				) AS MEMO
											,SOURCES.JR_IN_QTY
											,SOURCES.JR_OUT_QTY
											,SOURCES.ELECTRODE_TYPE
											,SOURCES.CALC_TYPE
											,C.PROD_VERSION_TYPE
											,SOURCES.ROLL_IN_QTY
											,SOURCES.ROLL_OUT_QTY
											,SOURCES.BATCH_IN_QTY
											,SOURCES.BATCH_OUT_QTY
											,SOURCES.CELL_IN_QTY
											,SOURCES.CELL_OUT_QTY
											,SOURCES.SEQ
											,SOURCES.CELL_MATERIAL_ID
											,CONVERT(NVARCHAR(20), SOURCES.[START_TIME], 120) AS START_TIME  -- 2020-12-16 kimcd 시작일시 추가
											,CONVERT(NVARCHAR(20), SOURCES.[END_TIME], 120) AS END_TIME      -- 2020-12-16 kimcd 종료일시 추가
											,SOURCES.[PLM_EC_NO]             -- 2022-10-31 kimcd [ATTR_14] PLM EC NO
										FROM (
											SELECT SOURCES.*
												FROM [FP_DAILY_PRODUCTION_PLAN_R] SOURCES WITH(NOLOCK)
													,[SCM_ITEM_M]                 SIM     WITH(NOLOCK)
												WHERE SOURCES.COMPANY_ID = SIM.COMPANY_ID
												AND SOURCES.DIVISION_ID  = SIM.DIVISION_ID
												AND SOURCES.SITE_ID      = SIM.SITE_ID
												AND SOURCES.ITEM_ID      = SIM.ITEM_ID
												AND SIM.ITEM_TYPE        = 'P' -- 제품 한정
												AND SOURCES.FP_PLAN_ID = ISNULL(@fp_plan_id,'0')
												AND SOURCES.FIX_TYPE IN ('F','N') -- 2017-12-28 kimcd 확정 계획만 전송
												AND SOURCES.INSTANCE_ID = (
																			SELECT INSTANCE_ID
																				FROM DBO.SCM_FP_PLAN_DETAIL_H C  WITH(NOLOCK)
																				WHERE RELEASE_FLAG IN ( 'P', 'Y')
																				AND RELEASE_PLAN_ID = ISNULL(@fp_plan_id,'0')
																			UNION ALL
																			SELECT INSTANCE_ID
																				FROM DBO.SCM_FP_PLAN_GROUP_DETAIL_H D WITH(NOLOCK)
																				WHERE D.RELEASE_FLAG IN ( 'P', 'Y')
																				AND RELEASE_PLAN_ID = ISNULL(@fp_plan_id,'0')
																			)
											) SOURCES
											INNER JOIN SCM_LINE_M C WITH(NOLOCK)
													ON SOURCES.COMPANY_ID     = C.COMPANY_ID
													AND SOURCES.DIVISION_ID    = C.DIVISION_ID
													AND SOURCES.SITE_ID        = C.SITE_ID
													AND SOURCES.PLANT_ID       = C.PLANT_ID
													AND SOURCES.FACTORY_ID     = C.FACTORY_ID
													AND SOURCES.OPERATION_ID   = C.OPERATION_ID
													AND SOURCES.LINE_ID        = C.LINE_ID
													AND SOURCES.ELECTRODE_TYPE = C.ELECTRODE_TYPE
									-- 2021-07-07 kimcd 계획 없는 라인 발생하면 DUMMY 품목 WO 전송 시작
									UNION ALL
									SELECT   @fp_plan_id AS PLAN_ID
											,C.COMPANY_ID
											,C.DIVISION_ID
											,C.SITE_ID
											,C.[PLANT_ID]   AS PLANT_ID
											,C.[FACTORY_ID]
											,ISNULL(CASE WHEN C.MES_LINE_ID = '' THEN NULL ELSE C.MES_LINE_ID END,C.LINE_ID) AS LINE_ID -- 2022-07-27 kimcd 설비 정보 Option 화 line Table의 MES LINE ID 사용
											,C.LINE_ID AS FP_LINE_ID
											,C.[OPERATION_ID]
											,'-'  AS [EQUIPMENT_ID]  -- 2022-07-27 kimcd 설비 정보 Option 화 설비 정보 제거
											,'DUMMY' [ITEM_ID]
											,'DUMMY' AS WO
											,'DUMMY' AS WO_DETAIL
											,CONVERT(NVARCHAR(50), CONVERT(DATETIME, CONVERT(DATE,GETDATE())), 120) AS PLAN_DATE
											,0 [PLAN_IN_QTY]
											,0 [PLAN_QTY]
											,@instance_id INSTANCE_ID
											--,ISNULL( (
											--			SELECT D.PLAN_GROUP_ID
											--				FROM DBO.SCM_FP_PLAN_GROUP_DETAIL_H D WITH(NOLOCK)
											--				WHERE D.RELEASE_FLAG IN ( 'P', 'Y')
											--				AND D.RELEASE_PLAN_ID = ISNULL(@fp_plan_id,'0') ),'-') AS PLAN_GR_ID
											,@PLAN_GROUP_ID    AS PLAN_GR_ID  -- 2022-09-14 kimcd plan group id 대상 조회에서 조회된 결과 사용
											,NULL AS FULL_CLEANING_FLAG
											,NULL AS MODEL_TYPE_CHANGE_FLAG
											,NULL AS MEMO
											,NULL AS JR_IN_QTY
											,NULL AS JR_OUT_QTY
											,C.ELECTRODE_TYPE
											,NULL AS CALC_TYPE
											,NULL AS PROD_VERSION_TYPE
											,NULL AS ROLL_IN_QTY
											,NULL AS ROLL_OUT_QTY
											,NULL AS BATCH_IN_QTY
											,NULL AS BATCH_OUT_QTY
											,NULL AS CELL_IN_QTY
											,NULL AS CELL_OUT_QTY
											,NULL AS SEQ
											,NULL AS CELL_MATERIAL_ID
											,CONVERT(NVARCHAR(50), CONVERT(DATETIME, CONVERT(DATE,GETDATE())), 120) AS START_TIME  -- 2020-12-16 kimcd 시작일시 추가
											,CONVERT(NVARCHAR(50), CONVERT(DATETIME, CONVERT(DATE,GETDATE())), 120) AS END_TIME      -- 2020-12-16 kimcd 종료일시 추가
											,NULL AS [PLM_EC_NO]             -- 2022-10-31 kimcd [ATTR_14] PLM EC NO
										FROM (   SELECT L.*
												 FROM  SCM_LINE_M   L WITH(NOLOCK)
													  ,SCM_OPERATION_M O WITH(NOLOCK)
													  ,FP_INSTANCE_FACTORY_M IFM WITH(NOLOCK)
												 WHERE L.COMPANY_ID    = O.COMPANY_ID
												 AND   L.DIVISION_ID   = O.DIVISION_ID
												 AND   L.SITE_ID       = O.SITE_ID
												 AND   L.OPERATION_ID  = O.OPERATION_ID
												 AND   L.FACTORY_ID    = IFM.FACTORY_ID
												 AND   O.INSTANCE_TYPE = IFM.INSTANCE_TYPE
												 AND   IFM.INSTANCE_ID = @INSTANCE_ID
												 AND   L.ACTIVE_FLAG   = 'Y'
												 AND   CASE WHEN @FACTORY_ID = '-' THEN @FACTORY_ID ELSE L.FACTORY_ID END = @FACTORY_ID
												 AND   CASE WHEN @PLAN_GROUP_ID = '-' THEN @PLAN_GROUP_ID ELSE L.MODEL_TYPE END = @PLAN_GROUP_ID
												 AND   NOT EXISTS ( SELECT 1
																	FROM   SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
																	WHERE  SLV.LOOKUP_TYPE_CODE  = 'INSTANCE_SPLIT_LINE_DEFINITION'
																	AND    SLV.ACTIVE_FLAG       = 'Y'
																	AND    SLV.SEGMENT2          = @INSTANCE_ID
																	AND    SLV.SEGMENT3          = L.LINE_ID )
												 AND    NOT EXISTS (SELECT 1
																	FROM   SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
																	WHERE  SLV.LOOKUP_TYPE_CODE  = 'INSTANCE_SPLIT_LINE_DEFINITION'
																	AND    SLV.ACTIVE_FLAG       = 'Y'
																	AND    SLV.SEGMENT1          = @INSTANCE_ID)
												 UNION ALL
												 SELECT L.*
												 FROM  SCM_LINE_M   L WITH(NOLOCK)
													  ,SCM_OPERATION_M O WITH(NOLOCK)
													  ,FP_INSTANCE_FACTORY_M IFM WITH(NOLOCK)
												 WHERE L.COMPANY_ID    = O.COMPANY_ID
												 AND   L.DIVISION_ID   = O.DIVISION_ID
												 AND   L.SITE_ID       = O.SITE_ID
												 AND   L.OPERATION_ID  = O.OPERATION_ID
												 AND   L.FACTORY_ID    = IFM.FACTORY_ID
												 AND   O.INSTANCE_TYPE = IFM.INSTANCE_TYPE
												 AND   IFM.INSTANCE_ID = @INSTANCE_ID
												 AND   L.ACTIVE_FLAG   = 'Y'
												 AND   CASE WHEN @FACTORY_ID = '-' THEN @FACTORY_ID ELSE L.FACTORY_ID END = @FACTORY_ID
												 AND   CASE WHEN @PLAN_GROUP_ID = '-' THEN @PLAN_GROUP_ID ELSE L.MODEL_TYPE END = @PLAN_GROUP_ID
												 AND   L.LINE_ID IN ( SELECT SLV.SEGMENT3
																	FROM   SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
																	WHERE  SLV.LOOKUP_TYPE_CODE  = 'INSTANCE_SPLIT_LINE_DEFINITION'
																	AND    SLV.ACTIVE_FLAG       = 'Y'
																	AND    SLV.SEGMENT1          = @INSTANCE_ID )
													) C
										WHERE  NOT EXISTS ( SELECT 1
															FROM [FP_DAILY_PRODUCTION_PLAN_R] SOURCES WITH(NOLOCK)
															WHERE SOURCES.FP_PLAN_ID = ISNULL(@fp_plan_id,'0')
															AND SOURCES.FIX_TYPE IN ('F','N') -- 2017-12-28 kimcd 확정 계획만 전송
															AND SOURCES.INSTANCE_ID = @instance_id
															AND SOURCES.COMPANY_ID     = C.COMPANY_ID
															AND SOURCES.DIVISION_ID    = C.DIVISION_ID
															AND SOURCES.SITE_ID        = C.SITE_ID
															AND SOURCES.PLANT_ID       = C.PLANT_ID
															AND SOURCES.FACTORY_ID     = C.FACTORY_ID
															AND SOURCES.OPERATION_ID   = C.OPERATION_ID
															AND SOURCES.LINE_ID        = C.LINE_ID
															AND SOURCES.ELECTRODE_TYPE = C.ELECTRODE_TYPE
															)
									-- 2021-07-07 kimcd 계획 없는 라인에 대해서 DUMMY 품목, WO 전송
									) M  
                                ) M
                             INNER JOIN [dbo].[SCM_FACTORY_M] F WITH(NOLOCK)
                                ON M.COMPANY_ID = F.COMPANY_ID
                               AND M.FACTORY_ID = F.FACTORY_ID  -- 2024-03-28 NERP PLANT_ID 변경에 따른 CONVERSION 반영 
						END; -- IF @instance_id = 'KR_CELL_M'
					-- 2020-12-01 kimcd 오창 소형의 경우 오창 FCS로 계획 전송하도록 추가 끝

					INSERT INTO [dbo].[SY_XIF_LOG_HISTORY](
						[PROC_NAME],
						[LOG_TYPE],
						[MESSAGE],
							[EVENT_DTTM]
					) VALUES (
						'PR_XIF_MES_DAILY_PP2_S',
						'LOG',
						@ROWCOUNT,
						GETDATE()
					)

					FETCH NEXT FROM PLAN_INFO_CUR INTO @fp_plan_id
														,@instance_id
														,@factory_id
														,@PLAN_GROUP_ID --2021-07-07 kimcd add
					;
				END;

			CLOSE PLAN_INFO_CUR;
			DEALLOCATE PLAN_INFO_CUR;

			IF OBJECT_ID('tempdb..#BASE_INFO') IS NOT NULL
				DROP TABLE #BASE_INFO

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
