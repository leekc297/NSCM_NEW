
CREATE   PROCEDURE [dbo].[PR_XIF_FCS_PRODUCTION_PLAN_S]

-- ================================================================================================
-- Program ID          : FP04070
-- Program Name        : PR_XIF_FCS_PRODUCTION_PLAN_S
-- Param               :
-- Batch Period        : 1Hour
-- Description         :
--
-- Source System       : FP SDB
-- Destination System  : FCS
-- Source Table        : FP_DAILY_PRODUCTION_PLAN_R, FP_MPP_WPP_BASE_PLAN_M
-- Destination Table   : XIF_FCS_DAILY_PLAN_S
--
-- Create Date		   : 2018.06.05
-- Update Date		   : 2018.07.10 PIYONG
--						 2018.09.07 PIYONG
--                       2018.12.27 kimcd
--						 2019.05.27 PIYONG
--                       2019.07.23 kimcd
--						 2019.11.28 PIYONG
--						 2020.03.18 2.0 PIYONG
--						 2020.03.26 2.1 kimcd
--                       2021.05.12 2.2 kimcd
--                       2021.05.26 2.3 kimis
--                       2022.03.28 2.4 kimcd
--                       2022.07.23 2.6 kimcd
--                       2023.01.18 2.7 kimcd
--
-- Author              : PIYONG
-- Version             : 1.0
--						 1.1 계획 수량이 0인 데이터 제외 하는 조건 추가
--						 1.2  MEMO 정보 추가 송신
--                       1.3 2018-12-27 kimcd 폴란드 활성화 계획을 B1000 포장 계획으로 전송
--						 1.4 LINE MAPPING 문제로 PLANT G182 제외
--                       1.5 2019-07-23 kimcd plan id 형성 제한이 없어 과거 정보 조회되어 조건 추가
--						 1.6 2019-11-28 XIF_FCS_DAILY_PLAN_S 테이블 ATTR_02, ATTR_03에 생산 라인 코드(MES 라인 기준), 전송일자 YYYYMMDD 추가
--										폴란드 일 경우 시뮬레이터(OFP0_PSIM_FCS_DAILY_PLAN) 용 추가 전송
--						 2.0 CUR_RELEASE 기준 테이블 변경 SCM_FP_PLAN_H -> SCM_FP_PLAN_DETAIL_H
--						 2.1 2020-03-26  kimcd 동별 배포한 계획이 전송 안 되어 Factory_id를 Group by, Partition by에 추가
--						 2.2 2021-05-12  kimcd Plan Group별 배포 로직 추가
--						 2.3 2021-05-26  kimis ESNJ 6동 GMES DB 분리에 따른 변경
--		 				     동 기준(SCM_FACTORY_M.MES_SOURCE_GROUP)에서 라인 기준(SCM_MMD_LINE_M.MES_SOURCE_GROUP)으로 MES_SOURCE_GROUP 정보 반영
--						     라인 기준으로 MES_SOURCE_GROUP 정보 반영하고 라인 기준  데이터가 NULL 인 경우 동 기준으로 정보 반영 (FCS_SOURCE_GROUP도 동일 로직 반영)
--						 2.4 2022-03-28  kimcd 가상 Division 사용에 따른 보완
--                       2.5 2022-06-09  kimcd SPC 계획 전송 추가
--                       2.6 2022-07-23  kimcd 설비 정보 Option으로 변경
--                       2.7 2023-01-18  kimcd WPP 계획 전송에서 ATTR_03에 월요일 값 추가 전송 C20230106-000329 [ESNB 활성화 ]FP 계획 연동report error
--                       2.8 2024-03-15 chkim.68 하드코딩 전환 (ref scm_code_lookup_value )
--                       2.9 2024-03-28  KIMJS NERP PLANT_ID 변경에 따른 CONVERSION 반영 및 하드코딩 제거
--						 3.0 2025-12-15   yschoithira	[E20251205-001628] ESMI4동 ESS, 자동차 라인 MES DB통합에 따른 기능개선 건
-- ================================================================================================

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_FCS_PRODUCTION_PLAN_S'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	   = 0
	DECLARE @sysdate     DATETIME2     = GETDATE()
	DECLARE @enddate     DATE          = DATEADD( D, 31, GETDATE()) -- 2022-06-09 kimcd SPC 계획 전송 일자 범위 조건 
	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)

	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	--변수 설정
	DECLARE @INSTANCE_ID		    NVARCHAR(50)
	DECLARE @FP_PLAN_ID			    NVARCHAR(60)
	DECLARE @BASE_PLAN_ID		    NVARCHAR(60)	-- 2020-03-18 PIYONG ADD

	DECLARE @PLAN_WEEK				NVARCHAR(50)
	DECLARE @PLAN_REVISION			NVARCHAR(50)
	DECLARE @FACTORY_ID			    NVARCHAR(30)
	DECLARE @PLAN_GROUP_ID		    NVARCHAR(30)
	DECLARE @LOCAL_TIME				NVARCHAR(20) --2018-12-27 KIMCD 추가
	DECLARE @PLAN_START_TIME		NVARCHAR(8)		--2019-11-28 PIYONG ADD
	
	

	DECLARE CUR_RELEASE CURSOR FOR
		SELECT INSTANCE_ID
			   , RELEASE_PLAN_ID						-- 2020-03-18 PIYONG ADD
			   , PLAN_START_TIME						-- 2019-11-28 PIYONG ADD
			   , PLAN_ID
			   , FACTORY_ID        -- 2022-06-09  kimcd SPC 계획 전송 추가. Dummy 계획 전송용
			   , PLAN_GROUP_ID     -- 2022-06-09  kimcd SPC 계획 전송 추가. Dummy 계획 전송용
		  FROM (
				SELECT INSTANCE_ID
					   , PLAN_ID																			-- 2020-03-18 PIYONG CHAGNE BASIS_PLAN_ID -> PLAN_ID
   					   , RELEASE_PLAN_ID																	-- 2020-03-18 PIYONG ADD
					   , RANK() OVER ( PARTITION BY INSTANCE_ID, FACTORY_ID ORDER BY MAX(RELEASE_TIME) DESC ) AS SEQ  -- 2020-03-26  kimcd 동별 배포한 계획이 전송 안 되어 Factory_id를 Group by, Partition by에 추가
					   , PLAN_DATE AS PLAN_START_TIME														-- 2019-11-28 PIYONG ADD -- 2020-03-18 PIYONG CHANGE CONVERT(NVARCHAR(8), PLAN_START_TIME, 112 ) -> PLAN_DATE
					   , FACTORY_ID 
					   , '-' AS PLAN_GROUP_ID
				  FROM [SCM_FP_PLAN_DETAIL_H]																-- 2020-03-18 PIYONG CHANGE SCM_FP_PLAN_H -> SCM_FP_PLAN_DETAIL_H
				 WHERE INSTANCE_ID IN (
										SELECT DISTINCT INSTANCE_ID
										  FROM FP_INSTANCE_FACTORY_M
										 WHERE INSTANCE_TYPE = 'F'
									  )
				   AND RELEASE_FLAG = 'Y'
				   AND RELEASE_TIME >= GETDATE()-2  -- 2019-07-23 kimcd plan id 형성 제한이 없어 과거 정보 조회되어 조건 추가
				 GROUP BY INSTANCE_ID
					   , PLAN_ID					-- 2020-03-18 PIYONG CHANGE BASIS_PLAN_ID -> PLAN_ID
					   , RELEASE_PLAN_ID			-- 2020-03-18 PIYONG ADD
					   , PLAN_DATE					-- 2019-11-28 PIYONG ADD 2020-03-18 PIYONG CHANGE CONVERT(NVARCHAR(8), PLAN_START_TIME, 112 ) -> PLAN_DATE
					   , FACTORY_ID                 -- 2020-03-26  kimcd 동별 배포한 계획이 전송 안 되어 Factory_id를 Group by, Partition by에 추가
				UNION
				SELECT INSTANCE_ID
					   , PLAN_ID
   					   , RELEASE_PLAN_ID
					   , RANK() OVER ( PARTITION BY INSTANCE_ID, PLAN_GROUP_ID ORDER BY MAX(RELEASE_TIME) DESC ) AS SEQ
					   , PLAN_DATE AS PLAN_START_TIME
   					   , '-'      AS FACTORY_ID 
					   , PLAN_GROUP_ID
				  FROM [SCM_FP_PLAN_GROUP_DETAIL_H]
				 WHERE INSTANCE_ID IN (
										SELECT DISTINCT INSTANCE_ID
										  FROM FP_INSTANCE_FACTORY_M
										 WHERE INSTANCE_TYPE = 'F'
									  )
				   AND RELEASE_FLAG = 'Y'
				   AND RELEASE_TIME >= GETDATE()-2
				 GROUP BY INSTANCE_ID
					   , PLAN_ID
					   , RELEASE_PLAN_ID
					   , PLAN_DATE
					   , PLAN_GROUP_ID
			   ) A
		 WHERE A.SEQ = 1				
		   AND NOT EXISTS (
							SELECT 1
							  FROM SY_XIF_FCS_DAILY_PLAN_S B
							 WHERE B.INSTANCE_ID = A.INSTANCE_ID
							   AND B.FP_PLAN_ID = A.RELEASE_PLAN_ID
						  )
					


	DECLARE CUR_WPP CURSOR FOR
		SELECT H.INSTANCE_ID
			   ,H.PLAN_WEEK
			   ,H.PLAN_REVISION
			   ,H.FACTORY_ID
			   ,H.PLAN_GROUP_ID
			   ,( SELECT TOP 1 CONVERT(NVARCHAR(8), C.DATE_ID, 112)
				  FROM   [DBO].SCM_SYS_CALENDAR_M C WITH(NOLOCK)
				  WHERE  C.WEEK = H.PLAN_WEEK
				  ORDER  BY C.DATE_ID) AS FIRST_DATE -- 2023-01-18 kimcd 주별 시작일 추가 C20230106-000329 [ESNB 활성화 ]FP 계획 연동report error
		  FROM FP_MPP_WPP_BASE_PLAN_H H
		 WHERE H.WPP = 'Y'
		   AND H.INSTANCE_ID IN (
									SELECT DISTINCT INSTANCE_ID
									  FROM FP_INSTANCE_FACTORY_M
									 WHERE INSTANCE_TYPE = 'F'
							    )
		   AND H.INSERT_TIME >= GETDATE()-2  -- 2019-07-23 kimcd plan id 형성 제한이 없어 과거 정보 조회되어 조건 추가
		   AND H.[PLANT_ID] not in (SELECT SEGMENT2 FROM SCM_CODE_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE='PR_XIF_FCS_PRODUCTION_PLAN_S' AND SEGMENT1  = '0' AND ACTIVE_FLAG = 'Y') --2019-05-27 PIYONG ADD  2024-03-28 PLANT_ID G182 하드코딩 제거
		   AND NOT EXISTS (
							SELECT 1
							  FROM SY_XIF_FCS_DAILY_PLAN_S A
							 WHERE A.INSTANCE_ID = H.INSTANCE_ID
							   AND A.FP_PLAN_ID = H.PLAN_WEEK+'_'+H.PLAN_REVISION
						  )


	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

	BEGIN TRY				

		BEGIN TRAN
		-- ================================================
		-- 로직 추가
		-- ================================================
			OPEN CUR_RELEASE;
			
			FETCH NEXT FROM CUR_RELEASE INTO @INSTANCE_ID
											,@FP_PLAN_ID
											,@PLAN_START_TIME
											,@BASE_PLAN_ID
											,@FACTORY_ID        -- 2022-06-09  kimcd SPC 계획 전송 추가. Dummy 계획 전송용
											,@PLAN_GROUP_ID     -- 2022-06-09  kimcd SPC 계획 전송 추가. Dummy 계획 전송용

			WHILE (@@FETCH_STATUS = 0)
				BEGIN
				   

					INSERT INTO SY_XIF_FCS_DAILY_PLAN_S (
						[IF_SEQ]
						,[IF_TYPE]
						,[IF_ID]
						,[IF_INS_DATE]
						,[IF_FLAG]
						,[IF_SND_DATE]
						,[INSTANCE_ID]
						,[FP_PLAN_ID]
						,[PLAN_GROUP_ID]
						,[PLAN_TYPE]
						,[COMPANY_ID]
						,[DIVISION_ID]
						,[SITE_ID]
						,[PLANT_ID]
						,[FACTORY_ID]
						,[LOCATION]
						,[OPERATION_ID]
						,[LINE_ID]
						,[PLAN_DATE]
						,[ITEM_ID]
						,[NICK_NAME]
						,[CUSTOMER_ID]
						,[PRODUCTION_TYPE]
						,[MARKET]
						,[SEQ]
						,[PLAN_IN_QTY]
						,[PLAN_OUT_QTY]
						,[TOTAL_WORKING_TIME]
						,[SETUP_TIME]
						,[DAILY_CAPA]
						,[OFF_TIME]
						,[MEMO]
						,[ACCUM_COUNT]
						,[INSERT_ID]
						,[INSERT_TIME]
						,[UPDATE_ID]
						,[UPDATE_TIME]
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
					)
					SELECT 'OFP0' + SUBSTRING(CONVERT(NVARCHAR(12), GETDATE(), 112), 3,6) + REPLICATE('0', 10 - LEN(NEXT VALUE FOR [dbo].[XIF_FCS_SEND_SEQ])) + CAST( NEXT VALUE FOR [dbo].[XIF_FCS_SEND_SEQ] AS NVARCHAR)	AS IF_SEQ
						   , IF_TYPE
                           , IF_ID
                           , IF_INS_DATE
                           , IF_FLAG
                           , IF_SND_DATE
                           , INSTANCE_ID
                           , FP_PLAN_ID
                           , PLAN_GROUP_ID
                           , PLAN_TYPE
                           , SO.COMPANY_ID
                           , ISNULL(PD.ORIGINAL_DIVISION_ID, ISNULL(F.DIVISION_ID,SO.DIVISION_ID)) -- [E20251205-001628] 변경 된 DIVISION_ID 정보를 보냄
                           , SO.SITE_ID
                           , F.MES_PLANT_ID  -- 2024-03-28 NERP PLANT_ID 변경에 따른 CONVERSION 반영 
                           , F.FACTORY_ID	-- [E20251205-001628] 변경 된 FACTORY 정보를 보냄	
                           , LOCATION
                           , OPERATION_ID
                           , SEGMENT2
                           , PLAN_DATE
						   -- 2022-03-24 kimcd 가상 Division 로직 추가
						   , ITEM_ID
                           , NICK_NAME
                           , CUSTOMER_ID
                           , PRODUCTION_TYPE
                           , MARKET
                           , SEQ
                           , PLAN_IN_QTY
                           , PLAN_OUT_QTY
                           , TOTAL_WORKING_TIME
                           , SETUP_TIME
                           , DAILY_CAPA
                           , OFF_TIME
                           , MEMO
						   --2021-05-26 kimis ESNJ 6동 GMES DB 분리에 따른 변경 : COUNT에 IF_ID 추가
						   --, COUNT(*) OVER (PARTITION BY INSTANCE_ID, PLAN_GROUP_ID,  SO.FACTORY_ID, IF_ID) AS ACCUM_COUNT
                           , COUNT(*) OVER (PARTITION BY INSTANCE_ID, PLAN_GROUP_ID,  F.FACTORY_ID, IF_ID) AS ACCUM_COUNT	-- [E20251205-001628] 변경 된 FACTORY 정보를 보냄	
						   , SO.INSERT_ID
                           , SO.INSERT_TIME
                           , SO.UPDATE_ID
                           , SO.UPDATE_TIME
                           , ATTR_01
                           , LINE_ID
                           , PLAN_START_TIME
                           , ATTR_04
                           , ATTR_05
                           , ATTR_06
                           , ATTR_07
                           , ATTR_08
                           , ATTR_09
                           , ATTR_10					
					FROM (
							SELECT --'OFP0' + SUBSTRING(CONVERT(NVARCHAR(12), GETDATE(), 112), 3,6) + REPLICATE('0', 10 - LEN(NEXT VALUE FOR [dbo].[XIF_FCS_SEND_SEQ])) + CAST( NEXT VALUE FOR [dbo].[XIF_FCS_SEND_SEQ] AS NVARCHAR)	AS IF_SEQ
								   'S' AS IF_TYPE
								   --2021-05-26 kimis ESNJ 6동 GMES DB 분리에 따른 변경 : 라인 기준(SCM_MMD_LINE_M.FCS_SOURCE_GROUP)으로 FCS_SOURCE_GROUP 반영하고 라인 기준 데이터가 NULL 인 경우 동 기준(SCM_FACTORY_M.FCS_SOURCE_GROUP)으로 반영
								   --,'OFP0'+'_'+( SELECT ISNULL(FCS_SOURCE_GROUP,'') FROM SCM_FACTORY_M F WHERE F.FACTORY_ID = AA.FACTORY_ID ) +'_'+'FCS_DAILY_PLAN' -- [IF_ID]
								   -- [E20251205-001628] 1순위 라인 기준 2순위 view
								   ,'OFP0'+'_'+ ISNULL(( SELECT ISNULL(L.FCS_SOURCE_GROUP,(SELECT ISNULL(F.FCS_SOURCE_GROUP,'') 
								   															FROM FP_MES_FACTORY_M_V F WITH(NOLOCK) 
								   															WHERE F.ORG_FACTORY_ID = AA.FACTORY_ID)) 
								   						 FROM SCM_MMD_LINE_M L  WITH(NOLOCK) 
								   						 WHERE L.FACTORY_ID = AA.FACTORY_ID 
								   						 AND L.LINE_ID = AA.MES_LINE_ID 
								   						 ),(SELECT ISNULL(F.FCS_SOURCE_GROUP,'') 
								   						 	FROM FP_MES_FACTORY_M_V F WITH(NOLOCK) 
								   						 	WHERE F.ORG_FACTORY_ID = AA.FACTORY_ID)
								   						) +'_'+'FCS_DAILY_PLAN' AS IF_ID
								   ,GETDATE()					AS IF_INS_DATE
								   ,'N'								AS IF_FLAG
								   ,NULL							AS IF_SND_DATE
								   ,INSTANCE_ID
								   ,FP_PLAN_ID
								   ,PLAN_GROUP_ID
								   ,'RELEASE'						AS PLAN_TYPE
								   ,COMPANY_ID
								   ,DIVISION_ID
								   ,SITE_ID
								   ,AA.PLANT_ID
								   ,FACTORY_ID
								   ,LOCATION
								   ,OPERATION_ID
								   ,SSLV.SEGMENT2
								   ,PLAN_DATE
								   ,ITEM_ID
								   ,NICK_NAME
								   ,NULL							AS CUSTOMER_ID
								   ,PRODUCTION_TYPE
								   ,MARKET
								   ,SEQ
		   						   ,PLAN_IN_QTY
								   ,PLAN_OUT_QTY
								   ,TOTAL_WORKING_TIME
							       ,SETUP_TIME
								   ,DAILY_CAPA
								   ,OFF_TIME
								   --------------------------------------------------------------------------------
								   --2018-09-07 PIYONG ADD
								   ,(
								     SELECT SUBSTRING([MEMO],1,200)
									   FROM [FP_AMEND_MEMO_M] AM
									  WHERE INSTANCE_ID = AA.INSTANCE_ID
										AND [COMPANY_ID] = AA.[COMPANY_ID]
										AND [DIVISION_ID] = AA.[DIVISION_ID]
										AND [SITE_ID] = AA.[SITE_ID]
										AND [PLANT_ID] = AA.[PLANT_ID]
										AND [FACTORY_ID] = AA.[FACTORY_ID]
										AND [OPERATION_ID] = AA.[OPERATION_ID]
										AND [LINE_ID] = AA.[LINE_ID]
										AND [PLAN_DATE] = AA.[PLAN_DATE]
										AND [MARKET] = AA.[MARKET]
										AND [PRODUCTION_TYPE] = AA.[PRODUCTION_TYPE]
										AND [TOP_ITEM_ID] = AA.[TOP_ITEM_ID]
										AND [ITEM_ID] = AA.[ITEM_ID]
																		)	AS MEMO
									--2018-09-07 PIYONG ADD
									--------------------------------------------------------------------------------
								   --,COUNT(*) OVER (PARTITION BY INSTANCE_ID, PLAN_GROUP_ID,  FACTORY_ID) AS ACCUM_COUNT
								   ,'PR_XIF_FCS_PRODUCTION_PLAN_S'	AS INSERT_ID
								   ,GETDATE()						AS INSERT_TIME
								   ,'PR_XIF_FCS_PRODUCTION_PLAN_S'	AS UPDATE_ID
								   ,GETDATE()						AS UPDATE_TIME
						   		   ,ATTR_01
								   ,AA.LINE_ID						-- 생산 라인 코드(MES 라인 기준)  -- PIYONG 2019-11-28 ADD
								   ,@PLAN_START_TIME AS PLAN_START_TIME		-- 전송일자 YYYYMMDD				  -- PIYONG 2019-11-28 ADD
								   ,NULL							AS ATTR_04
								   ,NULL							AS ATTR_05
								   ,NULL							AS ATTR_06
								   ,NULL							AS ATTR_07
								   ,NULL							AS ATTR_08
								   ,NULL							AS ATTR_09
								   ,NULL							AS ATTR_10
							  FROM (
									SELECT INSTANCE_ID
											,FP_PLAN_ID
											,FACTORY_ID
											,LINE_ID
											,PLAN_DATE
											,TOP_ITEM_ID
											,ITEM_ID
											,OPERATION_ID
											,MAX([PLAN_GROUP_ID] ) AS [PLAN_GROUP_ID]
											,MAX([COMPANY_ID] ) AS [COMPANY_ID]
											,MAX([DIVISION_ID] ) AS [DIVISION_ID]
											,MAX([SITE_ID] ) AS [SITE_ID]
											,MAX([PLANT_ID] ) AS [PLANT_ID]
											,MAX([LOCATION] ) AS [LOCATION]
											,MAX([NICK_NAME] ) AS [NICK_NAME]
											,MAX([PRODUCTION_TYPE] ) AS [PRODUCTION_TYPE]
											,MAX([MARKET] ) AS [MARKET]
											,MAX([SEQ] ) AS [SEQ]
											,SUM([PLAN_OUT_QTY] ) AS [PLAN_OUT_QTY]
											,SUM([PLAN_IN_QTY] ) AS [PLAN_IN_QTY]
											,SUM([TOTAL_WORKING_TIME] ) AS [TOTAL_WORKING_TIME]
											,SUM([DAILY_CAPA] ) AS [DAILY_CAPA]
											,SUM([OFF_TIME]   ) AS [OFF_TIME]
											,SUM([SETUP_TIME] ) AS [SETUP_TIME]
											,ATTR_01
											,MAX(MES_LINE_ID) AS [MES_LINE_ID]-- 2021-07-15 kimis ADD
									  FROM (
											SELECT FDPP.INSTANCE_ID
												   ,FDPP.FP_PLAN_ID
												   ,FDPP.FACTORY_ID
												   ,FDPP.LINE_ID
												   ,FDPP.PLAN_DATE
												   ,FDPP.ITEM_ID
												   ,FDPP.TOP_ITEM_ID
												   ,FDPP.OPERATION_ID
												   ,ISNULL(
															( 
																SELECT D.PLAN_GROUP_ID
																  FROM DBO.SCM_FP_PLAN_GROUP_DETAIL_H D WITH(NOLOCK)
																 WHERE D.RELEASE_FLAG IN ( 'P', 'Y')
																   AND D.RELEASE_PLAN_ID = FDPP.[FP_PLAN_ID]
															)
														  ,'-') AS [PLAN_GROUP_ID]
												   ,FDPP.[COMPANY_ID]
												   ,FDPP.[DIVISION_ID]
												   ,FDPP.[SITE_ID]
												   ,FDPP.[PLANT_ID]
												   ,ISNULL(
															(
																SELECT LOCATION 
																	FROM SCM_LINE_M WITH(NOLOCK)
																	WHERE LINE_ID = FDPP.LINE_ID
																	AND OPERATION_ID = FDPP.OPERATION_ID
																	AND FACTORY_ID = FDPP.FACTORY_ID
																	AND ELECTRODE_TYPE = FDPP.ELECTRODE_TYPE
															)
															, '-') AS [LOCATION]
												   ,( 
														SELECT A.NICK_NAME
														FROM SCM_ITEM_M A(NOLOCK)
														WHERE A.ACTIVE_FLAG = 'Y'
															AND ITEM_ID = FDPP.ITEM_ID
															AND A.COMPANY_ID = FDPP.COMPANY_ID
															AND A.DIVISION_ID = FDPP.DIVISION_ID
															AND A.SITE_ID = FDPP.SITE_ID
																								) AS [NICK_NAME]
												   ,FDPP.[PRODUCTION_TYPE]
												   ,FDPP.[MARKET]
												   ,FDPP.LINE_ITEM_SEQ  AS [SEQ]
												   ,FDPP.[PLAN_QTY] AS [PLAN_OUT_QTY]
												   ,FDPP.[PLAN_IN_QTY] AS [PLAN_IN_QTY]
												   ,FDPP.[TOTAL_WORKING_TIME]
												   ,FPFAI.[DAILY_CAPA]
												   ,FPFAI.[OFF_TIME]
												   ,FPFAI.[SETUP_TIME]
						   						   ,CASE WHEN FPFAI.CATEGORY = 'SETUP' THEN  'Y' ELSE 'N' END  AS [ATTR_01]
						   						 ,ISNULL((SELECT TOP 1 C.MES_LINE_ID
						   						  FROM [dbo].[SCM_LINE_M] C  -- 2022-07-23  kimcd 설비 정보 Option화에 따라 라인으로 변경
													  WHERE C.COMPANY_ID   = FDPP.COMPANY_ID
														AND C.DIVISION_ID  = FDPP.DIVISION_ID
														AND C.SITE_ID      = FDPP.SITE_ID
														AND C.PLANT_ID     = FDPP.PLANT_ID
														AND C.LINE_ID      = FDPP.LINE_ID
														AND C.OPERATION_ID = FDPP.OPERATION_ID
														AND C.ACTIVE_FLAG  = 'Y'), FDPP.LINE_ID ) AS [MES_LINE_ID]  -- 2021-07-15 kimis ADD
											  FROM FP_DAILY_PRODUCTION_PLAN_R FDPP
											  LEFT OUTER JOIN FP_PLAN_FORM_ADDITIONAL_INFO FPFAI
														   ON FDPP.INSTANCE_ID  = FPFAI.INSTANCE_ID
														  AND @BASE_PLAN_ID		= FPFAI.FP_PLAN_ID		-- 2020-03-18 PIYONG CHANGE FDPP.FP_PLAN_ID -> @BASE_PLAN_ID
														  AND FDPP.FACTORY_ID   = FPFAI.FACTORY_ID
														  AND FDPP.LINE_ID      = FPFAI.LINE_ID
														  AND FDPP.PLAN_DATE    = FPFAI.PLAN_DATE
														  AND FDPP.ITEM_ID      = FPFAI.ITEM_ID
														  AND FDPP.OPERATION_ID = FPFAI.OPERATION_ID
											 WHERE FDPP.INSTANCE_ID  = @INSTANCE_ID
											   AND FDPP.FP_PLAN_ID   = @FP_PLAN_ID
											   AND FDPP.[PLAN_IN_QTY] != 0		--2018-07-10 PIYONG ADD
											   AND FDPP.PLANT_ID not in (SELECT SEGMENT2 FROM SCM_CODE_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE='PR_XIF_FCS_PRODUCTION_PLAN_S' AND SEGMENT1  = '0' AND ACTIVE_FLAG = 'Y')		--2019-05-27 PIYONG ADD  2024-03-28 PLANT_ID G182 하드코딩 제거
										   ) A
									 GROUP BY INSTANCE_ID
											,FP_PLAN_ID
											,FACTORY_ID
											,LINE_ID
											,PLAN_DATE
											,TOP_ITEM_ID
											,ITEM_ID
											,OPERATION_ID
											,[ATTR_01]
								   ) AA
							  LEFT OUTER JOIN (SELECT SEGMENT1, SEGMENT2, SEGMENT5, ROW_NUMBER() OVER (PARTITION BY SEGMENT1, SEGMENT5 ORDER BY SEGMENT2) AS ROW_NUM -- 2018-12-27  KIMCD 중복 정보 발생으로 로직 수정
												 FROM [dbo].[SCM_SYS_LOOKUP_VALUE] WITH(NOLOCK)
												WHERE LOOKUP_TYPE_CODE = 'FORMATION_LINE_MAPPING'
												 AND ACTIVE_FLAG = 'Y') SSLV
										   ON AA.LINE_ID  = SSLV.SEGMENT5
										  AND AA.SITE_ID = SSLV.SEGMENT1
										  AND SSLV.ROW_NUM = 1   -- 2018-12-27  KIMCD 중복 정보 발생으로 로직 수정
						) SO		  
                      --INNER JOIN [dbo].[SCM_FACTORY_M] F WITH(NOLOCK)
						INNER JOIN [dbo].[FP_MES_FACTORY_M_V] F WITH(NOLOCK)			-- [E20251205-001628] VIEW 변경 
                           ON SO.COMPANY_ID = F.COMPANY_ID
                          AND SO.FACTORY_ID = F.ORG_FACTORY_ID  -- [E20251205-001628] Column 변경 -- 2024-03-28 NERP PLANT_ID 변경에 따른 CONVERSION 반영 
		 			  LEFT OUTER JOIN [dbo].[SCM_PSEUDO_DIVISION_M] PD (NOLOCK)  -- 2022-03-24 kimcd 가상 Division 로직 추가
				 			  ON PD.PLANT_ID = F.PLANT_ID			-- [E20251205-001628] Column 변경
						   --ON PD.PLANT_ID = SO.PLANT_ID			

					-- 2022-06-09 kimcd SPC 계획 전송 과정 시작
						SET @LOCAL_TIME = REPLACE(REPLACE(REPLACE(CONVERT( NVARCHAR, DBO.FN_SITE_TIME( 
																									  (
																									   SELECT TOP 1 SITE_ID
																										 FROM [dbo].[FP_DAILY_PRODUCTION_PLAN_R] SOURCES WITH(NOLOCK)
																										WHERE SOURCES.FP_PLAN_ID  = @FP_PLAN_ID
																										  AND SOURCES.INSTANCE_ID = @INSTANCE_ID
																									  )
																									 ), 120), '-', ''), ':', ''), ' ', '')

						INSERT INTO [SY_XIF_MES_DAILY_PP_S]
									([IF_SEQ]
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
									,[ATTR_11])  -- 2021-05-12 kimcd FP 라인 추가
							
							 SELECT 'OFP0' + SUBSTRING(CONVERT(NVARCHAR(12), GETDATE(), 112), 3,6) + REPLICATE('0', 10 - LEN(NEXT VALUE FOR [DBO].[XIF_MES_SEND_SEQ])) + CAST( NEXT VALUE FOR [DBO].[XIF_MES_SEND_SEQ] AS NVARCHAR)   AS IF_SEQ,
							 IF_TYPE, IF_ID, IF_INS_DATE, IF_FLAG, IF_SND_DATE, RSLT_IF_SEQ, RSLT_PROC_FLAG, RSLT_PROC_MSG, PLAN_ID, PLANT_ID, BUILNO, LINE_ID, OPERATION_ID, EQUIPMENT_ID, ITEM_ID, WO, WO_DETAIL, PLAN_DATE, PLAN_IN_QTY, PLAN_OUT_QTY, CREATE_PSN_ID, CREATE_DATE, UPDATE_PSN_ID, UPDATE_DATE, INSTANCE_ID, PLAN_GROUP_ID, ATTR_03,
							 --2021-05-26 kimis ESNJ 6동 GMES DB 분리에 따른 변경 : Interface Count를 FACTORY_ID(BUILNO)에서 FACTORY_ID(BUILNO), IF_ID 기준으로 변경
							 COUNT(*) OVER(PARTITION BY BUILNO, IF_ID) AS  ATTR_04,
							 ATTR_05, ATTR_06, ATTR_07, ATTR_08, ATTR_09, ATTR_10, ATTR_11
							 FROM ( SELECT '' AS IF_SEQ
							 --SELECT ''
									,'S'                AS IF_TYPE
									--2021-05-26 kimis ESNJ 6동 GMES DB 분리에 따른 변경 : 라인 기준(SCM_MMD_LINE_M.MES_SOURCE_GROUP)으로 MES_SOURCE_GROUP 반영하고 라인 기준 데이터가 NULL 인 경우 동 기준(SCM_FACTORY_M.MES_SOURCE_GROUP)으로 반영
									,'OFP0'+'_'+ ISNULL(F.SPC_SOURCE_GROUP,'') +'_'+'FP_DPP' AS IF_ID
									--,@if_id_code        -- IF_ID
									,GETDATE()          AS IF_INS_DATE
									,'N'                AS IF_FLAG
									,NULL               AS IF_SND_DATE
									,NULL               AS RSLT_IF_SEQ
									,NULL               AS RSLT_PROC_FLAG
									,NULL               AS RSLT_PROC_MSG
									,SOURCES.[FP_PLAN_ID] AS PLAN_ID
									,F.[MES_PLANT_ID]   AS PLANT_ID  -- 2024-03-28 NERP PLANT_ID 변경에 따른 CONVERSION 반영 
									,F.FACTORY_ID		AS BUILNO		-- [E20251205-001628] 변경 된 FACTORY 정보를 보냄--,SOURCES.[FACTORY_ID] AS BUILNO
									,ISNULL( (SELECT TOP 1 C.MES_LINE_ID FROM [dbo].[SCM_LINE_M] C -- 2022-07-23  kimcd 설비 정보 Option화에 따라 라인으로 변경
											   WHERE C.COMPANY_ID = SOURCES.COMPANY_ID
												 AND C.DIVISION_ID = SOURCES.DIVISION_ID
												 AND C.SITE_ID = SOURCES.SITE_ID
												 AND C.PLANT_ID = SOURCES.PLANT_ID
												 AND C.LINE_ID = SOURCES.LINE_ID
												 AND C.OPERATION_ID = SOURCES.OPERATION_ID), SOURCES.LINE_ID) AS LINE_ID
									,SOURCES.[OPERATION_ID]
									,'-'	 AS [EQUIPMENT_ID]
									,SOURCES.[ITEM_ID]
									,[FP_PLAN_ID] + CONVERT(NVARCHAR(10), ROW_NUMBER() OVER (ORDER BY PLAN_DATE, ITEM_ID, LINE_ID))  AS WO
									,[FP_PLAN_ID] + CONVERT(NVARCHAR(10), ROW_NUMBER() OVER (ORDER BY PLAN_DATE, ITEM_ID, LINE_ID))  AS WO_DETAIL
									,CONVERT(NVARCHAR(50), PLAN_DATE, 120) AS PLAN_DATE
									,[PLAN_IN_QTY]
									,[PLAN_OUT_QTY]
									,@v_proc_name AS CREATE_PSN_ID
									,GETDATE() AS CREATE_DATE
									,@v_proc_name AS UPDATE_PSN_ID
									,GETDATE() AS UPDATE_DATE
									,SOURCES.INSTANCE_ID
									,SOURCES.[PLAN_GROUP_ID]
									,@LOCAL_TIME AS ATTR_03  -- @local_time
									-- ,COUNT(*) OVER(PARTITION BY [FACTORY_ID])						 AS  ATTR_04
									,'' AS  ATTR_04
									,NULL AS ATTR_05  -- full 세척 여부 - 세척 전 WO에 표시
									,NULL AS ATTR_06  -- pouch->원각 형교환 - 형교환 전 WO에 표시
									,(SELECT TOP 1 SUBSTRING(AM.[MEMO],1,200)
									  FROM   [FP_AMEND_MEMO_M] AM WITH(NOLOCK)
									  WHERE  AM.[INSTANCE_ID]     = SOURCES.[INSTANCE_ID]
									  AND    AM.[COMPANY_ID]      = SOURCES.[COMPANY_ID]
									  AND    AM.[DIVISION_ID]     = SOURCES.[DIVISION_ID]
									  AND    AM.[SITE_ID]         = SOURCES.[SITE_ID]
									  AND    AM.[PLANT_ID]        = SOURCES.[PLANT_ID]
									  AND    AM.[FACTORY_ID]      = SOURCES.[FACTORY_ID]
									  AND    AM.[OPERATION_ID]    = SOURCES.[OPERATION_ID]
									  AND    AM.[LINE_ID]         = SOURCES.[LINE_ID]
									  AND    AM.[PLAN_DATE]       = SOURCES.[PLAN_DATE]
									  AND    AM.[MARKET]          = SOURCES.[MARKET]
									  AND    AM.[PRODUCTION_TYPE] = SOURCES.[PRODUCTION_TYPE]
									  AND    AM.[TOP_ITEM_ID]     = SOURCES.[TOP_ITEM_ID]
									  AND    AM.[ITEM_ID]         = SOURCES.[ITEM_ID])               AS ATTR_07  -- memo
									,NULL               AS ATTR_08
									,NULL               AS ATTR_09
									,NULL               AS ATTR_10
									,LINE_ID            AS ATTR_11 -- 2021-05-12 kimcd FP 라인 추가
							 FROM ( SELECT   INSTANCE_ID
											,FP_PLAN_ID
											,FACTORY_ID
											,LINE_ID
											,PLAN_DATE
											,TOP_ITEM_ID
											,ITEM_ID
											,OPERATION_ID
											,MAX([PLAN_GROUP_ID] ) AS [PLAN_GROUP_ID]
											,MAX([COMPANY_ID] ) AS [COMPANY_ID]
											,MAX([DIVISION_ID] ) AS [DIVISION_ID]
											,MAX([SITE_ID] ) AS [SITE_ID]
											,MAX([PLANT_ID] ) AS [PLANT_ID]
											,MAX([PRODUCTION_TYPE] ) AS [PRODUCTION_TYPE]
											,MAX([MARKET] ) AS [MARKET]
											,MAX([SEQ] ) AS [SEQ]
											,SUM([PLAN_OUT_QTY] ) AS [PLAN_OUT_QTY]
											,SUM([PLAN_IN_QTY] ) AS [PLAN_IN_QTY]
											,SUM([TOTAL_WORKING_TIME] ) AS [TOTAL_WORKING_TIME]
									FROM ( 	SELECT  FDPP.INSTANCE_ID
												   ,FDPP.FP_PLAN_ID
												   ,FDPP.FACTORY_ID
												   ,FDPP.LINE_ID
												   ,FDPP.PLAN_DATE
												   ,FDPP.ITEM_ID
												   ,FDPP.TOP_ITEM_ID
												   ,FDPP.OPERATION_ID
												   ,ISNULL(
															(
																SELECT D.PLAN_GROUP_ID
																  FROM DBO.SCM_FP_PLAN_GROUP_DETAIL_H D WITH(NOLOCK)
																 WHERE D.RELEASE_FLAG IN ( 'P', 'Y')
																   AND D.RELEASE_PLAN_ID = FDPP.[FP_PLAN_ID]
															)
														  ,'-') AS [PLAN_GROUP_ID]
												   ,FDPP.[COMPANY_ID]
												   ,FDPP.[DIVISION_ID]
												   ,FDPP.[SITE_ID]
												   ,FDPP.[PLANT_ID]
												   ,FDPP.[PRODUCTION_TYPE]
												   ,FDPP.[MARKET]
												   ,FDPP.LINE_ITEM_SEQ  AS [SEQ]
												   ,FDPP.[PLAN_QTY] AS [PLAN_OUT_QTY]
												   ,FDPP.[PLAN_IN_QTY] AS [PLAN_IN_QTY]
												   ,FDPP.[TOTAL_WORKING_TIME]
											  FROM FP_DAILY_PRODUCTION_PLAN_R FDPP WITH(NOLOCK)
											 WHERE FDPP.INSTANCE_ID  = @INSTANCE_ID
											   AND FDPP.FP_PLAN_ID   = @FP_PLAN_ID
											   AND FDPP.PLAN_DATE    < @enddate -- 계획 전송 조건
											   AND FDPP.[PLAN_IN_QTY] != 0  ) A
									GROUP BY INSTANCE_ID
											,FP_PLAN_ID
											,FACTORY_ID
											,LINE_ID
											,PLAN_DATE
											,TOP_ITEM_ID
											,ITEM_ID
											,OPERATION_ID
									UNION ALL
									SELECT   @INSTANCE_ID AS INSTANCE_ID
											,@FP_PLAN_ID  AS FP_PLAN_ID
											,FACTORY_ID
											,LINE_ID
											,CONVERT(NVARCHAR(50), CONVERT(DATETIME, CONVERT(DATE,GETDATE())), 120) AS PLAN_DATE
											,'DUMMY' AS ITEM_ID
											,'DUMMY' AS TOP_ITEM_ID
											,OPERATION_ID
											,MAX([MODEL_TYPE] ) AS [PLAN_GROUP_ID]
											,MAX([COMPANY_ID] ) AS [COMPANY_ID]
											,MAX([DIVISION_ID] ) AS [DIVISION_ID]
											,MAX([SITE_ID] ) AS [SITE_ID]
											,MAX([PLANT_ID] ) AS [PLANT_ID]
											,'DUMMY'  AS [PRODUCTION_TYPE]
											,'D'  AS [MARKET]
											,1    AS [SEQ]
											,0 AS [PLAN_OUT_QTY]
											,0 AS [PLAN_IN_QTY]
											,0 AS [TOTAL_WORKING_TIME]
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
															WHERE SOURCES.FP_PLAN_ID   = @fp_plan_id
															AND SOURCES.INSTANCE_ID    = @instance_id
															AND SOURCES.COMPANY_ID     = C.COMPANY_ID
															AND SOURCES.DIVISION_ID    = C.DIVISION_ID
															AND SOURCES.SITE_ID        = C.SITE_ID
															AND SOURCES.PLANT_ID       = C.PLANT_ID
															AND SOURCES.FACTORY_ID     = C.FACTORY_ID
															AND SOURCES.OPERATION_ID   = C.OPERATION_ID
															AND SOURCES.LINE_ID        = C.LINE_ID
															AND SOURCES.ELECTRODE_TYPE = C.ELECTRODE_TYPE
															AND SOURCES.PLAN_DATE      < @enddate -- 계획 전송 조건
															AND SOURCES.PLAN_IN_QTY   != 0	)
										GROUP BY C.FACTORY_ID
												,C.LINE_ID
												,C.OPERATION_ID
										) SOURCES
									--INNER JOIN SCM_FACTORY_M F (NOLOCK)
   									 INNER JOIN FP_MES_FACTORY_M_V F WITH(NOLOCK)			-- [E20251205-001628] VIEW 변경 
										ON  SOURCES.COMPANY_ID = F.COMPANY_ID
										AND SOURCES.FACTORY_ID = F.ORG_FACTORY_ID				-- [E20251205-001628] Column 변경
							WHERE F.SPC_SOURCE_GROUP IS NOT NULL) SO
					-- 2022-06-09 kimcd SPC 계획 전송 과정 끝

				-- 2018-12-27 kimcd 추가 시작
				IF @INSTANCE_ID = 'PL_FORM_A'
					BEGIN
						--DELETE FROM [SY_XIF_MES_DAILY_PP_S]
						--WHERE PLAN_ID = @FP_PLAN_ID
						--; -- 2022-06-09 kimcd 삭제 막음

						SET @LOCAL_TIME = REPLACE(REPLACE(REPLACE(CONVERT( NVARCHAR, DBO.FN_SITE_TIME( 
																									  (
																									   SELECT TOP 1 SITE_ID
																										 FROM [dbo].[FP_DAILY_PRODUCTION_PLAN_R] SOURCES WITH(NOLOCK)
																										WHERE SOURCES.FP_PLAN_ID  = @FP_PLAN_ID
																										  AND SOURCES.INSTANCE_ID = @INSTANCE_ID
																									  )
																									 ), 120), '-', ''), ':', ''), ' ', '')

						INSERT INTO [SY_XIF_MES_DAILY_PP_S]
									([IF_SEQ]
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
									,[ATTR_11])  -- 2021-05-12 kimcd FP 라인 추가
							
							 SELECT 'OFP0' + SUBSTRING(CONVERT(NVARCHAR(12), GETDATE(), 112), 3,6) + REPLICATE('0', 10 - LEN(NEXT VALUE FOR [DBO].[XIF_MES_SEND_SEQ])) + CAST( NEXT VALUE FOR [DBO].[XIF_MES_SEND_SEQ] AS NVARCHAR)   AS IF_SEQ,
							 IF_TYPE, IF_ID, IF_INS_DATE, IF_FLAG, IF_SND_DATE, RSLT_IF_SEQ, RSLT_PROC_FLAG, RSLT_PROC_MSG, PLAN_ID, PLANT_ID, BUILNO, LINE_ID, OPERATION_ID, EQUIPMENT_ID, ITEM_ID, WO, WO_DETAIL, PLAN_DATE, PLAN_IN_QTY, PLAN_OUT_QTY, CREATE_PSN_ID, CREATE_DATE, UPDATE_PSN_ID, UPDATE_DATE, INSTANCE_ID, PLAN_GROUP_ID, ATTR_03,
							 --2021-05-26 kimis ESNJ 6동 GMES DB 분리에 따른 변경 : Interface Count를 FACTORY_ID(BUILNO)에서 FACTORY_ID(BUILNO), IF_ID 기준으로 변경
							 COUNT(*) OVER(PARTITION BY BUILNO, IF_ID) AS  ATTR_04,
							 ATTR_05, ATTR_06, ATTR_07, ATTR_08, ATTR_09, ATTR_10, ATTR_11
							 FROM ( SELECT '' AS IF_SEQ
							 --SELECT ''
									,'S'                AS IF_TYPE
									--2021-05-26 kimis ESNJ 6동 GMES DB 분리에 따른 변경 : 라인 기준(SCM_MMD_LINE_M.MES_SOURCE_GROUP)으로 MES_SOURCE_GROUP 반영하고 라인 기준 데이터가 NULL 인 경우 동 기준(SCM_FACTORY_M.MES_SOURCE_GROUP)으로 반영
									/* -- [E20251205-001628] LINE 기준으로 먼저 보고 View 기준으로 */
									,'OFP0'+'_'+ISNULL(( SELECT ISNULL(L.MES_SOURCE_GROUP,(	SELECT ISNULL(F.MES_SOURCE_GROUP,'') 
																							FROM FP_MES_FACTORY_M_V F WITH(NOLOCK) 
																							WHERE F.ORG_FACTORY_ID = SOURCES.FACTORY_ID)) 
														FROM SCM_MMD_LINE_M L  WITH(NOLOCK) 
														WHERE L.FACTORY_ID = SOURCES.FACTORY_ID 
									 					AND L.LINE_ID = (ISNULL( (   SELECT TOP 1 C.MES_LINE_ID FROM [dbo].[SCM_LINE_M] C  -- 2022-07-23  kimcd 설비 정보 Option화에 따라 라인으로 변경
											         								  WHERE C.COMPANY_ID   = SOURCES.COMPANY_ID
												                  						AND C.DIVISION_ID  = SOURCES.DIVISION_ID
												                  						AND C.SITE_ID      = SOURCES.SITE_ID
												                  						AND C.PLANT_ID     = SOURCES.PLANT_ID
												                  						AND C.LINE_ID      = SOURCES.LINE_ID
												                  						AND C.OPERATION_ID = SOURCES.OPERATION_ID
												                  						AND C.ACTIVE_FLAG  = 'Y'), SOURCES.LINE_ID))
												        ),(	SELECT ISNULL(F.FCS_SOURCE_GROUP,'') 
												        	FROM FP_MES_FACTORY_M_V F WITH(NOLOCK)
												        	WHERE F.ORG_FACTORY_ID = SOURCES.FACTORY_ID)
												       ) +'_'+'FP_DPP' AS IF_ID
									--,@if_id_code        -- IF_ID
									,GETDATE()          AS IF_INS_DATE
									,'N'                AS IF_FLAG
									,NULL               AS IF_SND_DATE
									,NULL               AS RSLT_IF_SEQ
									,NULL               AS RSLT_PROC_FLAG
									,NULL               AS RSLT_PROC_MSG
									,[FP_PLAN_ID] AS PLAN_ID
									,F.[MES_PLANT_ID]   AS PLANT_ID  -- 2024-03-28 NERP PLANT_ID 변경에 따른 CONVERSION 반영 
									,F.FACTORY_ID		AS BUILNO		-- [E20251205-001628] 변경 된 FACTORY 정보를 보냄	--,SOURCES.[FACTORY_ID] AS BUILNO
									,ISNULL( (SELECT TOP 1 C.MES_LINE_ID FROM [dbo].[SCM_LINE_M] C  -- 2022-07-23  kimcd 설비 정보 Option화에 따라 라인으로 변경
											   WHERE C.COMPANY_ID = SOURCES.COMPANY_ID
												 AND C.DIVISION_ID = SOURCES.DIVISION_ID
												 AND C.SITE_ID = SOURCES.SITE_ID
												 AND C.PLANT_ID = SOURCES.PLANT_ID
												 AND C.LINE_ID = SOURCES.LINE_ID
												 AND C.OPERATION_ID = SOURCES.OPERATION_ID), SOURCES.LINE_ID) AS LINE_ID
									,'B1000' AS [OPERATION_ID]
									,'-'	 AS [EQUIPMENT_ID]
									,[ITEM_ID]
									,[FP_PLAN_ID] + CONVERT(NVARCHAR(10), ROW_NUMBER() OVER (ORDER BY PLAN_DATE, ITEM_ID, LINE_ID))  AS WO
									,[FP_PLAN_ID] + CONVERT(NVARCHAR(10), ROW_NUMBER() OVER (ORDER BY PLAN_DATE, ITEM_ID, LINE_ID))  AS WO_DETAIL
									,CONVERT(NVARCHAR(50), PLAN_DATE, 120) AS PLAN_DATE
									,[PLAN_IN_QTY]
									,[PLAN_OUT_QTY]
									,@v_proc_name AS CREATE_PSN_ID
									,GETDATE() AS CREATE_DATE
									,@v_proc_name AS UPDATE_PSN_ID
									,GETDATE() AS UPDATE_DATE
									,SOURCES.INSTANCE_ID
									,SOURCES.[PLAN_GROUP_ID]
									,@LOCAL_TIME AS ATTR_03  -- @local_time
									-- ,COUNT(*) OVER(PARTITION BY [FACTORY_ID])						 AS  ATTR_04
									,'' AS  ATTR_04
									,NULL AS ATTR_05  -- full 세척 여부 - 세척 전 WO에 표시
									,NULL AS ATTR_06  -- pouch->원각 형교환 - 형교환 전 WO에 표시
									,(SELECT TOP 1 SUBSTRING(AM.[MEMO],1,200)
									  FROM   [FP_AMEND_MEMO_M] AM WITH(NOLOCK)
									  WHERE  AM.[INSTANCE_ID]     = SOURCES.[INSTANCE_ID]
									  AND    AM.[COMPANY_ID]      = SOURCES.[COMPANY_ID]
									  AND    AM.[DIVISION_ID]     = SOURCES.[DIVISION_ID]
									  AND    AM.[SITE_ID]         = SOURCES.[SITE_ID]
									  AND    AM.[PLANT_ID]        = SOURCES.[PLANT_ID]
									  AND    AM.[FACTORY_ID]      = SOURCES.[FACTORY_ID]
									  AND    AM.[OPERATION_ID]    = SOURCES.[OPERATION_ID]
									  AND    AM.[LINE_ID]         = SOURCES.[LINE_ID]
									  AND    AM.[PLAN_DATE]       = SOURCES.[PLAN_DATE]
									  AND    AM.[MARKET]          = SOURCES.[MARKET]
									  AND    AM.[PRODUCTION_TYPE] = SOURCES.[PRODUCTION_TYPE]
									  AND    AM.[TOP_ITEM_ID]     = SOURCES.[TOP_ITEM_ID]
									  AND    AM.[ITEM_ID]         = SOURCES.[ITEM_ID])               AS ATTR_07  -- memo
									,NULL               AS ATTR_08
									,NULL               AS ATTR_09
									,NULL               AS ATTR_10
									,LINE_ID            AS ATTR_11 -- 2021-05-12 kimcd FP 라인 추가
							 FROM ( SELECT   INSTANCE_ID
											,FP_PLAN_ID
											,FACTORY_ID
											,LINE_ID
											,PLAN_DATE
											,TOP_ITEM_ID
											,ITEM_ID
											,OPERATION_ID
											,MAX([PLAN_GROUP_ID] ) AS [PLAN_GROUP_ID]
											,MAX([COMPANY_ID] ) AS [COMPANY_ID]
											,MAX([DIVISION_ID] ) AS [DIVISION_ID]
											,MAX([SITE_ID] ) AS [SITE_ID]
											,MAX([PLANT_ID] ) AS [PLANT_ID]
											,MAX([PRODUCTION_TYPE] ) AS [PRODUCTION_TYPE]
											,MAX([MARKET] ) AS [MARKET]
											,MAX([SEQ] ) AS [SEQ]
											,SUM([PLAN_OUT_QTY] ) AS [PLAN_OUT_QTY]
											,SUM([PLAN_IN_QTY] ) AS [PLAN_IN_QTY]
											,SUM([TOTAL_WORKING_TIME] ) AS [TOTAL_WORKING_TIME]
									FROM ( 	SELECT  FDPP.INSTANCE_ID
												   ,FDPP.FP_PLAN_ID
												   ,FDPP.FACTORY_ID
												   ,FDPP.LINE_ID
												   ,FDPP.PLAN_DATE
												   ,FDPP.ITEM_ID
												   ,FDPP.TOP_ITEM_ID
												   ,FDPP.OPERATION_ID
												   ,ISNULL(
															(
																SELECT D.PLAN_GROUP_ID
																  FROM DBO.SCM_FP_PLAN_GROUP_DETAIL_H D WITH(NOLOCK)
																 WHERE D.RELEASE_FLAG IN ( 'P', 'Y')
																   AND D.RELEASE_PLAN_ID = FDPP.[FP_PLAN_ID]
															)
														  ,'-') AS [PLAN_GROUP_ID]
												   ,FDPP.[COMPANY_ID]
												   ,FDPP.[DIVISION_ID]
												   ,FDPP.[SITE_ID]
												   ,FDPP.[PLANT_ID]
												   ,FDPP.[PRODUCTION_TYPE]
												   ,FDPP.[MARKET]
												   ,FDPP.LINE_ITEM_SEQ  AS [SEQ]
												   ,FDPP.[PLAN_QTY] AS [PLAN_OUT_QTY]
												   ,FDPP.[PLAN_IN_QTY] AS [PLAN_IN_QTY]
												   ,FDPP.[TOTAL_WORKING_TIME]
											  FROM FP_DAILY_PRODUCTION_PLAN_R FDPP WITH(NOLOCK)
											 WHERE FDPP.INSTANCE_ID  = @INSTANCE_ID
											   AND FDPP.FP_PLAN_ID   = @FP_PLAN_ID
											   AND FDPP.[PLAN_IN_QTY] != 0  ) A
									GROUP BY INSTANCE_ID
											,FP_PLAN_ID
											,FACTORY_ID
											,LINE_ID
											,PLAN_DATE
											,TOP_ITEM_ID
											,ITEM_ID
											,OPERATION_ID 
                                   ) SOURCES 
                             --INNER JOIN [dbo].[SCM_FACTORY_M] F WITH(NOLOCK)
                             INNER JOIN [dbo].[FP_MES_FACTORY_M_V] F WITH(NOLOCK)			-- [E20251205-001628] VIEW 변경 
                                ON SOURCES.COMPANY_ID = F.COMPANY_ID
                               AND SOURCES.FACTORY_ID = F.ORG_FACTORY_ID  	-- [E20251205-001628] Column 변경 -- 2024-03-28 NERP PLANT_ID 변경에 따른 CONVERSION 반영 
                                   ) SO


							--------------------------------------------------------------------------------------------------------------------------------------------------
							--- 2019-11-28 PIYONG OFP0_PSIM_FCS_DAILY_PLAN ADD
							INSERT INTO SY_XIF_FCS_DAILY_PLAN_S (
								[IF_SEQ]
								,[IF_TYPE]
								,[IF_ID]
								,[IF_INS_DATE]
								,[IF_FLAG]
								,[IF_SND_DATE]
								,[INSTANCE_ID]
								,[FP_PLAN_ID]
								,[PLAN_GROUP_ID]
								,[PLAN_TYPE]
								,[COMPANY_ID]
								,[DIVISION_ID]
								,[SITE_ID]
								,[PLANT_ID]
								,[FACTORY_ID]
								,[LOCATION]
								,[OPERATION_ID]
								,[LINE_ID]
								,[PLAN_DATE]
								,[ITEM_ID]
								,[NICK_NAME]
								,[CUSTOMER_ID]
								,[PRODUCTION_TYPE]
								,[MARKET]
								,[SEQ]
								,[PLAN_IN_QTY]
								,[PLAN_OUT_QTY]
								,[TOTAL_WORKING_TIME]
								,[SETUP_TIME]
								,[DAILY_CAPA]
								,[OFF_TIME]
								,[MEMO]
								,[ACCUM_COUNT]
								,[INSERT_ID]
								,[INSERT_TIME]
								,[UPDATE_ID]
								,[UPDATE_TIME]
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
							)
							SELECT 'OFP0' + SUBSTRING(CONVERT(NVARCHAR(12), GETDATE(), 112), 3,6)
										   + REPLICATE('0', 10 - LEN(NEXT VALUE FOR [dbo].[XIF_FCS_SEND_SEQ]))
										   + CAST( NEXT VALUE FOR [dbo].[XIF_FCS_SEND_SEQ] AS NVARCHAR)	AS IF_SEQ
								   ,'S' -- [IF_TYPE]
								   ,'OFP0_PSIM_FCS_DAILY_PLAN'		-- [IF_ID]
								   ,GETDATE()						-- [IF_INS_DATE]
								   ,'N'								-- [IF_FLAG]
								   ,NULL							-- [IF_SND_DATE]
								   ,INSTANCE_ID
								   ,FP_PLAN_ID
								   ,PLAN_GROUP_ID
								   ,'RELEASE'						-- PLAN_TYPE
								   ,AA.COMPANY_ID
								   ,F.DIVISION_ID				-- [E20251205-001628] 변경 된 DIVISION_ID 정보를 보냄	--,AA.DIVISION_ID
								   ,AA.SITE_ID
								   ,F.MES_PLANT_ID                  -- 2024-03-28 NERP PLANT_ID 변경에 따른 CONVERSION 반영 
								   ,F.FACTORY_ID				-- [E20251205-001628] 변경 된 FACTORY 정보를 보냄	--,AA.FACTORY_ID
								   ,LOCATION
								   ,OPERATION_ID
								   ,SSLV.SEGMENT2
								   ,PLAN_DATE
								   ,ITEM_ID
								   ,NICK_NAME
								   ,NULL							-- [CUSTOMER_ID]
								   ,PRODUCTION_TYPE
								   ,MARKET
								   ,SEQ
   								   ,PLAN_IN_QTY
								   ,PLAN_OUT_QTY
								   ,TOTAL_WORKING_TIME
								   ,SETUP_TIME
								   ,DAILY_CAPA
								   ,OFF_TIME
								   --------------------------------------------------------------------------------
								   --2018-09-07 PIYONG ADD
								   ,(
									 SELECT SUBSTRING(AM.[MEMO],1,200)
									   FROM [FP_AMEND_MEMO_M] AM
									  WHERE INSTANCE_ID = AA.INSTANCE_ID
										AND [COMPANY_ID] = AA.[COMPANY_ID]
										AND [DIVISION_ID] = AA.[DIVISION_ID]
										AND [SITE_ID] = AA.[SITE_ID]
										AND [PLANT_ID] = AA.[PLANT_ID]
										AND [FACTORY_ID] = AA.[FACTORY_ID]
										AND [OPERATION_ID] = AA.[OPERATION_ID]
										AND [LINE_ID] = AA.[LINE_ID]
										AND [PLAN_DATE] = AA.[PLAN_DATE]
										AND [MARKET] = AA.[MARKET]
										AND [PRODUCTION_TYPE] = AA.[PRODUCTION_TYPE]
										AND [TOP_ITEM_ID] = AA.[TOP_ITEM_ID]
										AND [ITEM_ID] = AA.[ITEM_ID]
																		)	-- [MEMO]
									--2018-09-07 PIYONG ADD
									--------------------------------------------------------------------------------
								   ,COUNT(*) OVER (PARTITION BY INSTANCE_ID, PLAN_GROUP_ID,  AA.FACTORY_ID) AS ACCUM_COUNT
								   ,'PR_XIF_FCS_PRODUCTION_PLAN_S'	-- [INSERT_ID]
								   ,GETDATE()						-- [INSERT_TIME]
								   ,'PR_XIF_FCS_PRODUCTION_PLAN_S'	-- [UPDATE_ID]
								   ,GETDATE()						-- [UPDATE_TIME]
				   				   ,ATTR_01
								   ,AA.LINE_ID						-- 생산 라인 코드(MES 라인 기준)  -- PIYONG 2019-11-28 ADD
								   ,@PLAN_START_TIME AS PLAN_START_TIME		-- 전송일자 YYYYMMDD				  -- PIYONG 2019-11-28 ADD
								   ,NULL							-- [ATTR_04]
								   ,NULL							-- [ATTR_05]
								   ,NULL							-- [ATTR_06]
								   ,NULL							-- [ATTR_07]
								   ,NULL							-- [ATTR_08]
								   ,NULL							-- [ATTR_09]
								   ,NULL							-- [ATTR_10]
							  FROM (
									SELECT INSTANCE_ID
											,FP_PLAN_ID
											,FACTORY_ID
											,LINE_ID
											,PLAN_DATE
											,TOP_ITEM_ID
											,ITEM_ID
											,OPERATION_ID
											,MAX([PLAN_GROUP_ID] ) AS [PLAN_GROUP_ID]
											,MAX([COMPANY_ID] ) AS [COMPANY_ID]
											,MAX([DIVISION_ID] ) AS [DIVISION_ID]
											,MAX([SITE_ID] ) AS [SITE_ID]
											,MAX([PLANT_ID] ) AS [PLANT_ID]
											,MAX([LOCATION] ) AS [LOCATION]
											,MAX([NICK_NAME] ) AS [NICK_NAME]
											,MAX([PRODUCTION_TYPE] ) AS [PRODUCTION_TYPE]
											,MAX([MARKET] ) AS [MARKET]
											,MAX([SEQ] ) AS [SEQ]
											,SUM([PLAN_OUT_QTY] ) AS [PLAN_OUT_QTY]
											,SUM([PLAN_IN_QTY] ) AS [PLAN_IN_QTY]
											,SUM([TOTAL_WORKING_TIME] ) AS [TOTAL_WORKING_TIME]
											,SUM([DAILY_CAPA] ) AS [DAILY_CAPA]
											,SUM([OFF_TIME]   ) AS [OFF_TIME]
											,SUM([SETUP_TIME] ) AS [SETUP_TIME]
											,ATTR_01
									  FROM (
											SELECT FDPP.INSTANCE_ID
												   ,FDPP.FP_PLAN_ID
												   ,FDPP.FACTORY_ID
												   ,FDPP.LINE_ID
												   ,FDPP.PLAN_DATE
												   ,FDPP.ITEM_ID
												   ,FDPP.TOP_ITEM_ID
												   ,FDPP.OPERATION_ID
												   ,ISNULL(
															( 
																SELECT D.PLAN_GROUP_ID
																  FROM DBO.SCM_FP_PLAN_GROUP_DETAIL_H D WITH(NOLOCK)
																 WHERE D.RELEASE_FLAG IN ( 'P', 'Y')
																   AND D.RELEASE_PLAN_ID = FDPP.[FP_PLAN_ID]
															)
														  ,'-') AS [PLAN_GROUP_ID]
												   ,FDPP.[COMPANY_ID]
												   ,FDPP.[DIVISION_ID]
												   ,FDPP.[SITE_ID]
												   ,FDPP.[PLANT_ID]
												   ,ISNULL(
															(
																SELECT LOCATION 
																	FROM SCM_LINE_M WITH(NOLOCK)
																	WHERE LINE_ID = FDPP.LINE_ID
																	AND OPERATION_ID = FDPP.OPERATION_ID
																	AND FACTORY_ID = FDPP.FACTORY_ID
																	AND ELECTRODE_TYPE = FDPP.ELECTRODE_TYPE
															)
															, '-') AS [LOCATION]
												   ,( 
														SELECT A.NICK_NAME
														FROM SCM_ITEM_M A(NOLOCK)
														WHERE A.ACTIVE_FLAG = 'Y'
															AND ITEM_ID = FDPP.ITEM_ID
															AND A.COMPANY_ID = FDPP.COMPANY_ID
															AND A.DIVISION_ID = FDPP.DIVISION_ID
															AND A.SITE_ID = FDPP.SITE_ID
																								) AS [NICK_NAME]
												   ,FDPP.[PRODUCTION_TYPE]
												   ,FDPP.[MARKET]
												   ,FDPP.LINE_ITEM_SEQ  AS [SEQ]
												   ,FDPP.[PLAN_QTY] AS [PLAN_OUT_QTY]
												   ,FDPP.[PLAN_IN_QTY] AS [PLAN_IN_QTY]
												   ,FDPP.[TOTAL_WORKING_TIME]
												   ,FPFAI.[DAILY_CAPA]
												   ,FPFAI.[OFF_TIME]
												   ,FPFAI.[SETUP_TIME]
				   								   ,CASE WHEN FPFAI.CATEGORY = 'SETUP' THEN  'Y' ELSE 'N' END  AS [ATTR_01]
											  FROM FP_DAILY_PRODUCTION_PLAN_R FDPP
											  LEFT OUTER JOIN FP_PLAN_FORM_ADDITIONAL_INFO FPFAI
														   ON FDPP.INSTANCE_ID  = FPFAI.INSTANCE_ID
														  AND @BASE_PLAN_ID		= FPFAI.FP_PLAN_ID		-- 2020-03-18 PIYONG CHANGE FDPP.FP_PLAN_ID -> @BASE_PLAN_ID
														  AND FDPP.FACTORY_ID   = FPFAI.FACTORY_ID
														  AND FDPP.LINE_ID      = FPFAI.LINE_ID
														  AND FDPP.PLAN_DATE    = FPFAI.PLAN_DATE
														  AND FDPP.ITEM_ID      = FPFAI.ITEM_ID
														  AND FDPP.OPERATION_ID = FPFAI.OPERATION_ID
											 WHERE FDPP.INSTANCE_ID  = @INSTANCE_ID
											   AND FDPP.FP_PLAN_ID   = @FP_PLAN_ID
											   AND FDPP.[PLAN_IN_QTY] != 0		--2018-07-10 PIYONG ADD
										--	   AND FDPP.PLANT_ID != 'G182'		--2019-05-27 PIYONG ADD	--2019-11-28 PIYONG DEL
										   ) A
									 GROUP BY INSTANCE_ID
											,FP_PLAN_ID
											,FACTORY_ID
											,LINE_ID
											,PLAN_DATE
											,TOP_ITEM_ID
											,ITEM_ID
											,OPERATION_ID
											,[ATTR_01]
								   ) AA
                              --INNER JOIN [dbo].[SCM_FACTORY_M] F WITH(NOLOCK)
							  INNER JOIN [dbo].[FP_MES_FACTORY_M_V] F WITH(NOLOCK)			-- [E20251205-001628] VIEW 변경 
                                 ON AA.COMPANY_ID = F.COMPANY_ID
                                AND AA.FACTORY_ID = F.ORG_FACTORY_ID  -- [E20251205-001628] Column 변경 -- 2024-03-28 NERP PLANT_ID 변경에 따른 CONVERSION 반영 
							  LEFT OUTER JOIN (SELECT SEGMENT1, SEGMENT2, SEGMENT5, ROW_NUMBER() OVER (PARTITION BY SEGMENT1, SEGMENT5 ORDER BY SEGMENT2) AS ROW_NUM -- 2018-12-27  KIMCD 중복 정보 발생으로 로직 수정
												 FROM [dbo].[SCM_SYS_LOOKUP_VALUE] WITH(NOLOCK)
												WHERE LOOKUP_TYPE_CODE = 'FORMATION_LINE_MAPPING'
												 AND ACTIVE_FLAG = 'Y') SSLV
										   ON AA.LINE_ID  = SSLV.SEGMENT5
										  AND AA.SITE_ID = SSLV.SEGMENT1
										  AND SSLV.ROW_NUM = 1   -- 2018-12-27  KIMCD 중복 정보 발생으로 로직 수정
							--- 2019-11-28 PIYONG OFP0_PSIM_FCS_DAILY_PLAN END
							--------------------------------------------------------------------------------------------------------------------------------------------------
					END;
				-- 2018-12-27 kimcd 추가 끝

				FETCH NEXT FROM CUR_RELEASE INTO @INSTANCE_ID
												 ,@FP_PLAN_ID
												 ,@PLAN_START_TIME
												 ,@BASE_PLAN_ID
												 ,@FACTORY_ID        -- 2022-06-09  kimcd SPC 계획 전송 추가. Dummy 계획 전송용
												 ,@PLAN_GROUP_ID     -- 2022-06-09  kimcd SPC 계획 전송 추가. Dummy 계획 전송용
					;

				END

			CLOSE CUR_RELEASE;
			DEALLOCATE CUR_RELEASE;


			OPEN CUR_WPP;
			
			FETCH NEXT FROM CUR_WPP INTO @INSTANCE_ID
									     ,@PLAN_WEEK
									     ,@PLAN_REVISION
									     ,@FACTORY_ID
										 ,@PLAN_GROUP_ID
										 ,@PLAN_START_TIME -- 2023-01-18 kimcd 매주 월요일 추가

			WHILE (@@FETCH_STATUS = 0)
				BEGIN

					INSERT INTO SY_XIF_FCS_DAILY_PLAN_S (
						[IF_SEQ]
						,[IF_TYPE]
						,[IF_ID]
						,[IF_INS_DATE]
						,[IF_FLAG]
						,[IF_SND_DATE]
						,[INSTANCE_ID]
						,[FP_PLAN_ID]
						,[PLAN_GROUP_ID]
						,[PLAN_TYPE]
						,[COMPANY_ID]
						,[DIVISION_ID]
						,[SITE_ID]
						,[PLANT_ID]
						,[FACTORY_ID]
						,[LOCATION]
						,[OPERATION_ID]
						,[LINE_ID]
						,[PLAN_DATE]
						,[ITEM_ID]
						,[NICK_NAME]
						,[CUSTOMER_ID]
						,[PRODUCTION_TYPE]
						,[MARKET]
						,[SEQ]
						,[PLAN_IN_QTY]
						,[PLAN_OUT_QTY]
						,[TOTAL_WORKING_TIME]
						,[SETUP_TIME]
						,[DAILY_CAPA]
						,[OFF_TIME]
						,[MEMO]
						,[ACCUM_COUNT]
						,[INSERT_ID]
						,[INSERT_TIME]
						,[UPDATE_ID]
						,[UPDATE_TIME]
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
					)
					SELECT 'OFP0' + SUBSTRING(CONVERT(NVARCHAR(12), GETDATE(), 112), 3,6) + REPLICATE('0', 10 - LEN(NEXT VALUE FOR [dbo].[XIF_FCS_SEND_SEQ])) + CAST( NEXT VALUE FOR [dbo].[XIF_FCS_SEND_SEQ] AS NVARCHAR)
						--SELECT ''
						   ,'S' AS [IF_TYPE]
						   --2021-05-26 kimis ESNJ 6동 GMES DB 분리에 따른 변경 :  라인 기준(SCM_MMD_LINE_M.FCS_SOURCE_GROUP)으로 FCS_SOURCE_GROUP 반영하고 라인 기준 데이터가 NULL 인 경우 동 기준(SCM_FACTORY_M.FCS_SOURCE_GROUP)으로 반영
						   --,'OFP0'+'_'+( SELECT ISNULL(FCS_SOURCE_GROUP,'') FROM SCM_FACTORY_M F WHERE F.FACTORY_ID = A.FACTORY_ID ) +'_'+'FCS_DAILY_PLAN' AS [IF_ID]
						   ,A.IF_ID
						   ,GETDATE() AS [IF_INS_DATE]
						   ,'N' AS [IF_FLAG]
						   ,NULL AS [IF_SND_DATE]
						   ,@INSTANCE_ID AS [INSTANCE_ID]
						   ,A.[FP_PLAN_ID]
						   ,A.[PLAN_GROUP_ID]
						   ,A.[PLAN_TYPE]
						   ,A.[COMPANY_ID]
						   ,ISNULL(PD.ORIGINAL_DIVISION_ID, ISNULL(F.DIVISION_ID,A.DIVISION_ID)) -- [E20251205-001628] 변경 된 DIVISION_ID 정보를 보냄 -- 2022-03-24 kimcd 가상 Division 로직 추가
						   ,A.[SITE_ID]
						   ,F.[MES_PLANT_ID]   -- 2024-03-28 NERP PLANT_ID 변경에 따른 CONVERSION 반영 
						   ,F.FACTORY_ID				-- [E20251205-001628] 변경 된 FACTORY 정보를 보냄	--,A.[FACTORY_ID]
						   ,A.[LOCATION]
						   ,A.[OPERATION_ID]
						   ,SSLV.SEGMENT2 AS [LINE_ID]
						   ,A.[PLAN_DATE]
						   ,A.[ITEM_ID]
						   ,A.[NICK_NAME]
						   ,A.[CUSTOMER_ID]
						   ,A.[PRODUCTION_TYPE]
						   ,A.[MARKET]
						   ,A.[SEQ]
   						   ,A.[PLAN_IN_QTY]
						   ,A.[PLAN_OUT_QTY]
						   ,A.[TOTAL_WORKING_TIME]
						   ,A.[SETUP_TIME]
						   ,A.[DAILY_CAPA]
						   ,A.[OFF_TIME]
						   ,[MEMO]
						   --2021-05-26 kimis ESNJ 6동 GMES DB 분리에 따른 변경 :  COUNT에 IF_ID 추가
						   ,COUNT(*) OVER (PARTITION BY @INSTANCE_ID, PLAN_GROUP_ID, PLAN_TYPE, A.FACTORY_ID, IF_ID) AS ACCUM_COUNT
						   ,A.[INSERT_ID]
						   ,A.[INSERT_TIME]
						   ,A.[UPDATE_ID]
						   ,A.[UPDATE_TIME]
						   ,NULL AS [ATTR_01]
						   ,NULL AS [ATTR_02]
						   ,@PLAN_START_TIME AS [ATTR_03] -- 2023-01-18 kimcd 매주 월요일 추가 C20230106-000329 [ESNB 활성화 ]FP 계획 연동report error
						   ,NULL AS [ATTR_04]
						   ,NULL AS [ATTR_05]
						   ,NULL AS [ATTR_06]
						   ,NULL AS [ATTR_07]
						   ,NULL AS [ATTR_08]
						   ,NULL AS [ATTR_09]
						   ,NULL AS [ATTR_10]
					  FROM (
							SELECT M.PLAN_WEEK+'_'+M.PLAN_REVISION AS [FP_PLAN_ID]
								   ,@PLAN_GROUP_ID AS [PLAN_GROUP_ID]
								   ,'WPP' AS [PLAN_TYPE]
								   ,M.[COMPANY_ID]
								   ,M.[DIVISION_ID]
								   ,M.[SITE_ID]
								   ,M.[PLANT_ID]
								   ,M.[FACTORY_ID]
								   ,'-' AS [LOCATION]
								   ,M.[OPERATION_ID]
								   ,M.[LINE_ID]
								   ,M.[PLAN_DATE]
								   ,M.[ITEM_ID]
								   ,( 
									  SELECT A.NICK_NAME
										FROM SCM_ITEM_M A(NOLOCK)
									   WHERE A.ACTIVE_FLAG = 'Y'
										 AND ITEM_ID = M.ITEM_ID
										 AND A.COMPANY_ID = M.COMPANY_ID
										 AND A.DIVISION_ID = M.DIVISION_ID
										 AND A.SITE_ID = M.SITE_ID
																			) AS [NICK_NAME]
								   ,NULL AS [CUSTOMER_ID]
								   ,M.[PRODUCTION_TYPE]
								   ,M.[MARKET]
								   ,NULL  AS [SEQ]
								   ,M.[PLAN_QTY] AS [PLAN_OUT_QTY]
								   ,M.[PLAN_QTY] AS [PLAN_IN_QTY]
								   ,NULL AS [TOTAL_WORKING_TIME]
								   ,NULL AS [SETUP_TIME]
								   ,NULL AS [DAILY_CAPA]
								   ,NULL AS [OFF_TIME]
								   ,NULL AS [MEMO]
								   ,'PR_XIF_FCS_PRODUCTION_PLAN_S' AS [INSERT_ID]
								   ,GETDATE() AS [INSERT_TIME]
								   ,'PR_XIF_FCS_PRODUCTION_PLAN_S' AS [UPDATE_ID]
								   ,GETDATE() AS [UPDATE_TIME]
								   --2021-05-26 kimis ESNJ 6동 GMES DB 분리에 따른 변경 :  라인 기준(SCM_MMD_LINE_M.FCS_SOURCE_GROUP)으로 FCS_SOURCE_GROUP 반영하고 라인 기준 데이터가 NULL 인 경우 동 기준(SCM_FACTORY_M.FCS_SOURCE_GROUP)으로 반영								   
								   /* -- [E20251205-001628] LINE 기준으로 먼저 보고 View 기준으로 */
								   ,'OFP0'+'_'+ ISNULL(( SELECT ISNULL(L.FCS_SOURCE_GROUP,(	SELECT ISNULL(F.FCS_SOURCE_GROUP,'') 
								   															FROM FP_MES_FACTORY_M_V F WITH(NOLOCK) 
								   															WHERE F.ORG_FACTORY_ID = M.FACTORY_ID)) 
								   						 FROM SCM_MMD_LINE_M L  WITH(NOLOCK) 
								   						 WHERE L.FACTORY_ID = M.FACTORY_ID 
								                     	 AND L.LINE_ID = (ISNULL( (	SELECT TOP 1 C.MES_LINE_ID FROM [dbo].[SCM_LINE_M] C  -- 2022-07-23  kimcd 설비 정보 Option화에 따라 라인으로 변경
								                                                	WHERE C.COMPANY_ID   = M.COMPANY_ID
								                                                  	AND C.DIVISION_ID  = M.DIVISION_ID
								                                                  	AND C.SITE_ID      = M.SITE_ID
								                                                  	AND C.PLANT_ID     = M.PLANT_ID
								                                                  	AND C.LINE_ID      = M.LINE_ID
								                                                  	AND C.OPERATION_ID = M.OPERATION_ID
								                                                  	AND C.ACTIVE_FLAG  = 'Y'), M.LINE_ID)) 
								                        ),( SELECT ISNULL(F.FCS_SOURCE_GROUP,'')
															FROM FP_MES_FACTORY_M_V F WITH(NOLOCK) 
															WHERE F.ORG_FACTORY_ID = M.FACTORY_ID)
													) +'_'+'FCS_DAILY_PLAN' AS [IF_ID]
							  FROM FP_MPP_WPP_BASE_PLAN_M M
							 WHERE M.PLAN_WEEK = @PLAN_WEEK
							   AND M.PLAN_REVISION = @PLAN_REVISION
							   -- AND M.FACTORY_ID = @FACTORY_ID 2021-05-12 kimcd plan group별 배포 반영하기 위해 조건 제거
							   AND M.[PLAN_QTY] != 0		--2018-07-10 PIYONG ADD
							   --AND M.[PLANT_ID] not in (SELECT SEGMENT2 FROM SCM_CODE_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE='PR_XIF_FCS_PRODUCTION_PLAN_S' AND SEGMENT1  = 'MOBILE_EXCEPT' AND ACTIVE_FLAG='Y')	--2019-05- PIYONG ADD  -- 2024-03-28 PLANT_ID G182 하드코딩 제거
						   ) A
                      --INNER JOIN [dbo].[SCM_FACTORY_M] F WITH(NOLOCK)
					  INNER JOIN [dbo].[FP_MES_FACTORY_M_V] F WITH(NOLOCK)			-- [E20251205-001628] VIEW 변경
                            ON   A.COMPANY_ID = F.COMPANY_ID
                            AND  A.FACTORY_ID = F.ORG_FACTORY_ID  -- [E20251205-001628] Column 변경 -- 2024-03-28 NERP PLANT_ID 변경에 따른 CONVERSION 반영 
					  LEFT OUTER JOIN (
									   SELECT SEGMENT1, SEGMENT2, SEGMENT5, ROW_NUMBER() OVER (PARTITION BY SEGMENT1, SEGMENT5 ORDER BY SEGMENT2) AS ROW_NUM  -- 2018-12-27  KIMCD 중복 정보 발생으로 로직 수정
										 FROM [dbo].[SCM_SYS_LOOKUP_VALUE] WITH(NOLOCK)
										WHERE LOOKUP_TYPE_CODE = 'FORMATION_LINE_MAPPING'
										  AND ACTIVE_FLAG = 'Y'
									  ) SSLV
								   ON A.LINE_ID = SSLV.SEGMENT5
								  AND A.SITE_ID = SSLV.SEGMENT1
								  AND SSLV.ROW_NUM = 1  -- 2018-12-27  KIMCD 중복 정보 발생으로 로직 수정
		 			  LEFT OUTER JOIN [dbo].[SCM_PSEUDO_DIVISION_M] PD (NOLOCK)  -- 2022-03-24 kimcd 가상 Division 로직 추가
						   ON PD.PLANT_ID = F.PLANT_ID	-- [E20251205-001628] PLANT_ID 변경 --ON PD.PLANT_ID = A.PLANT_ID

					FETCH NEXT FROM CUR_WPP INTO @INSTANCE_ID
											     ,@PLAN_WEEK
												 ,@PLAN_REVISION
												 ,@FACTORY_ID
												 ,@PLAN_GROUP_ID
												 ,@PLAN_START_TIME -- 2023-01-18 kimcd 매주 월요일 추가
					;

				END

			CLOSE CUR_WPP;
			DEALLOCATE CUR_WPP;


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
