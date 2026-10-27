
--CREATE PROCEDURE [dbo].[PR_XIF_SSP_PROD_TARGET_S]
CREATE PROCEDURE [dbo].[PR_XIF_SSP_PROD_TARGET_S]

-- ================================================================================================
-- Program ID          : FP01558
-- Program Name        : PR_XIF_SSP_PROD_TARGET_S
-- Param               :
-- Batch Period        : 0 Minute
-- Description         :
--
-- Source System       : FP SDB
-- Destination System  : 
-- Source Table        : FP_DAILY_PRODUCTION_PLAN_R
-- Destination Table   : FP_DAILY_PRODUCTIOIN_PLAN_H
--
-- Create(Update) Date : 2019.10.18
--						 2019.12.06	PIYONG 1.1
--                       2022.11.18 kimcd  1.2
--
--
-- Author              : PIYONG
-- Version             : 1.0
--						 1.1 PLAN_TYPE = RELEASE 이며 KR_CELL_M INTANCE 정보 추가 전송
--                       1.2 2022-11-18 kimcd 전극 생산 버전별 계획 수립에 따른 수정
-- ================================================================================================

-- PARAM PLAN_ID
--@P_FP_PLAN_ID NVARCHAR(50) = NULL
AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_SSP_PROD_TARGET_S'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	  = 0
	DECLARE @sysdate     DATETIME     = GETDATE()

	DECLARE @ROWCOUNT    INTEGER	  = 0

	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)

	-- ================================================
    -- Declare start
	-- ================================================	
	DECLARE @INSTANCE_ID		NVARCHAR(30)      
	DECLARE @PLAN_ID			NVARCHAR(30)
	DECLARE @INSTANCE_TYPE		NVARCHAR(30)
	DECLARE @PLAN_START_TIME	NVARCHAR(10)
	DECLARE @PLAN_TYPE			NVARCHAR(30)


	DECLARE CUR_PLAN_ID CURSOR FOR
		SELECT A.INSTANCE_ID
			   ,A.PLAN_ID
			   ,(SELECT TOP 1 IFM.INSTANCE_TYPE
				   FROM FP_INSTANCE_FACTORY_M IFM WITH(NOLOCK)
				  WHERE IFM.INSTANCE_ID = A.INSTANCE_ID) AS INSTANCE_TYPE
			   ,SUBSTRING( CONVERT(NVARCHAR(10), PLAN_START_TIME, 120), 1, 10 )  AS PLAN_START_TIME
			   ,PLAN_TYPE
		  FROM DBO.SCM_FP_PLAN_H A
		 WHERE INSTANCE_ID != 'KR_CELL_M_P' -- 오창 소형 조립 PILOT 제외 (양산과 구분할 방법 없음..)
 		   AND PLAN_START_TIME >= CONVERT(NVARCHAR(8), DATEADD(DD, -1, GETDATE()),112)
		   AND ( 
				 ( PLAN_TYPE = 'RELEASE' AND ISNULL(SSP_FLAG, 'N' ) = 'N' AND INSTANCE_ID = 'KR_CELL_M' )	-- 2019-12-06 PIYONG CHANGE
				 OR
				 ( SSP_FLAG  = 'N' )
			   )
		;



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

		OPEN CUR_PLAN_ID
		FETCH NEXT FROM CUR_PLAN_ID INTO @INSTANCE_ID
											,@PLAN_ID
											,@INSTANCE_TYPE
											,@PLAN_START_TIME
											,@PLAN_TYPE


		WHILE @@FETCH_STATUS = 0 -- DATA 가 존재하여 정상적으로 반환된 경우 : 0
			BEGIN
				-- 기존 생성된 데이터 삭제
				----------------------------------------------------------------------------------------------------------------------------------------------------
				----------------------------------------------------------------------------------------------------------------------------------------------------
				---2019-11-06 PIYONG ADD

				IF @PLAN_TYPE = 'RELEASE'
					BEGIN
						DELETE A
						  FROM FP_DAILY_PRODUCTIOIN_PLAN_H A
							   ,(
									SELECT B.INSTANCE_TYPE
										   ,CONVERT(DATETIME, A.PLAN_DATE, 112) AS INSTANCE_DATE
										   ,B.FACTORY_ID
										   ,A.DIVISION_ID  -- 2019-02-14 kimcd 라인 정보 추출을 위해 구분자 추가
										   ,A.INSTANCE_ID  -- 2019-02-14 kimcd 라인 정보 추출을 위해 구분자 추가
									  FROM (
											SELECT PLAN_DATE
												   , INSTANCE_ID
												   , DIVISION_ID
												   , FACTORY_ID
												   , '-' AS PLAN_GROUP_ID
												   , RELEASE_PLAN_ID
												   , RELEASE_FLAG
											  FROM DBO.SCM_FP_PLAN_DETAIL_H C(NOLOCK)
											 WHERE RELEASE_FLAG IN ( 'P', 'Y')
											   AND RELEASE_PLAN_ID = @PLAN_ID
										   ) A
										   ,( 
												SELECT A.[INSTANCE_ID]
													   , INSTANCE_TYPE
													   , B.SITE_ID
													   , B.FACTORY_ID
													   , CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE B.FACTORY_ID END  AS LINK_FACTORY_ID
													   , ISNULL(MP.SEGMENT2,'-')  AS PLAN_GROUP_ID
												  FROM DBO.[FP_INSTANCE_FACTORY_M] A WITH(NOLOCK)     
													   ,DBO.SCM_FACTORY_M B WITH(NOLOCK)
													   ,SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
													   LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE MP WITH(NOLOCK)
																	ON MP.LOOKUP_TYPE_CODE  = 'INSTANCE_PLANNING_GROUP'
																   AND MP.SEGMENT1 = SLV.SEGMENT1
																   AND SLV.ATTRIBUTE1 = 'PLAN GROUP'
												 WHERE A.FACTORY_ID = B.FACTORY_ID     
												   AND A.ACTIVE_FLAG = 'Y'     
												   AND A.ACTIVE_FLAG = B.ACTIVE_FLAG     
												   AND A.INSTANCE_ID != 'KR_CELL_M_P'
												   AND SLV.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
												   AND SLV.SEGMENT1 = A.INSTANCE_ID
											
										   ) B      
									 WHERE A.INSTANCE_ID = B.INSTANCE_ID
									   AND A.FACTORY_ID = B.LINK_FACTORY_ID
									   AND A.PLAN_GROUP_ID = B.PLAN_GROUP_ID
									   AND A.RELEASE_PLAN_ID = @PLAN_ID
							   ) B
						 WHERE A.FACTORY_ID = B.FACTORY_ID
						   AND A.INSTANCE_TYPE = B.INSTANCE_TYPE
						   AND A.PLAN_DATE >= @PLAN_START_TIME
						   AND A.PLAN_TYPE  = 'SSP'
						   AND A.LINE_ID IN ( SELECT DISTINCT LINE_ID
											  FROM   SCM_LINE_M L WITH(NOLOCK)
											  WHERE  L.FACTORY_ID  = B.FACTORY_ID
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
											  )
						AND B.INSTANCE_ID = @INSTANCE_ID
					END
				ELSE
				---2019-11-06 PIYONG ADD END
				----------------------------------------------------------------------------------------------------------------------------------------------------
				----------------------------------------------------------------------------------------------------------------------------------------------------
					BEGIN
						DELETE A
						  FROM FP_DAILY_PRODUCTIOIN_PLAN_H A
							   ,(
								  SELECT A.[INSTANCE_ID]
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
									WHERE A.FACTORY_ID = B.FACTORY_ID     
									AND A.ACTIVE_FLAG = 'Y'     
									AND A.ACTIVE_FLAG = B.ACTIVE_FLAG     
									AND A.INSTANCE_ID != 'KR_CELL_M_P'
									AND SLV.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
									AND SLV.SEGMENT1 = A.INSTANCE_ID
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
								   WHERE A.FACTORY_ID = B.FACTORY_ID     
									 AND A.ACTIVE_FLAG = 'Y'     
									 AND A.ACTIVE_FLAG = B.ACTIVE_FLAG     
									 AND A.INSTANCE_ID = 'KR_CELL_M_P'
									 AND SLV.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
									 AND SLV.SEGMENT1 = A.INSTANCE_ID
							   ) B
						 WHERE A.FACTORY_ID = B.FACTORY_ID
						   AND A.INSTANCE_TYPE = B.INSTANCE_TYPE
						   AND A.PLAN_DATE >= @PLAN_START_TIME
						   AND A.PLAN_TYPE  = 'SSP'
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
						AND B.INSTANCE_ID = @INSTANCE_ID
					END




				-- 데이터 생성
				MERGE INTO FP_DAILY_PRODUCTIOIN_PLAN_H DP
				USING ( 
						SELECT  A.COMPANY_ID
							   ,A.DIVISION_ID
							   ,A.SITE_ID
							   ,A.PLANT_ID
							   ,A.FACTORY_ID
							   ,ISNULL(A.PLAN_GROUP_ID, '-' ) AS PLAN_GROUP_ID
							   ,@INSTANCE_TYPE AS INSTANCE_TYPE
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
							   ,A.PLAN_IN_QTY
							   ,'PR_XIF_SSP_PROD_TARGET_S'  AS INSERT_ID  
							   ,GETDATE()                AS INSERT_TIME
							   ,'PR_XIF_SSP_PROD_TARGET_S'	AS UPDATE_ID
							   ,GETDATE()                AS UPDATE_TIME
							   ,'SSP'					 AS PLAN_TYPE	-- 계획 유형 추가
							   ,A.EQUIPMENT_ID							-- 설비 정보 추가
							   ,A.FP_PRODUCTION_TYPE
							   ,A.ROLL_IN_QTY							-- 전극 환산 계획 수량 시작
							   ,A.ROLL_OUT_QTY
							   ,A.JR_IN_QTY
							   ,A.JR_OUT_QTY
							   ,A.BATCH_IN_QTY
							   ,A.BATCH_OUT_QTY
							   ,A.CELL_IN_QTY
							   ,A.CELL_OUT_QTY							-- 전극 환산 계획 수량 끝
							   ,A.FULL_CLEANING_FLAG					-- 풀 세척					
							   ,A.PIG_CLEANING_FLAG						-- PIG 세정					
							   ,A.MODEL_TYPE_CHANGE_FLAG				-- 파우치->원각 모델 변경	
   							   ,A.SEQ									-- 전극 생산 우선 순위를 관리하기 위한 SEQ
							   ,A.CELL_MATERIAL_ID						-- 활성화 후 공정 Cell Material ID 값 추가
							   ,A.TOTAL_BATCH							-- 주별 계획 BATCH 합 추가
							   ,A.SETUP_COLOR_CODE						-- full, pig세정 강화 관련 색 지정
   							   ,A.[WORK_REQUEST_MODEL_ID]
							   ,A.[VERSION]
							   ,A.[PROD_SEQ]
							   ,A.[PLM_EC_NO]   -- 2022-11-18 kimcd 일별 계획 이력에 전극 version, ec no 추가
						  FROM (
								SELECT  PP.COMPANY_ID
									   ,PP.DIVISION_ID
									   ,PP.SITE_ID
									   ,PP.PLANT_ID
									   ,PP.FACTORY_ID
									   ,CASE WHEN SLV.ATTRIBUTE1 = 'BUILDING' THEN '-' ELSE MODEL_TYPE END  AS PLAN_GROUP_ID
									   ,PP.TOP_ITEM_ID
									   ,PP.ITEM_ID
									   ,PP.OPERATION_ID
									   ,PP.PRODUCTION_TYPE AS PRODUCTION_TYPE
									   ,PP.PRODUCTION_TYPE AS FP_PRODUCTION_TYPE
									   ,ISNULL(MARKET,'D') AS MARKET
									   ,PP.LINE_ID
									   ,MAX(PP.ELECTRODE_TYPE) AS ELECTRODE_TYPE
									   ,PP.PLAN_DATE
									   ,SUM(ADJUST_OUT_QTY)    AS PLAN_QTY
									   ,SUM(ADJUST_IN_QTY)     AS PLAN_IN_QTY
									   ,@INSTANCE_ID AS INSTANCE_ID
									   ,'-' AS EQUIPMENT_ID
									   ,NULL AS ROLL_IN_QTY
									   ,NULL AS ROLL_OUT_QTY
									   ,NULL AS JR_IN_QTY
									   ,NULL AS JR_OUT_QTY
									   ,NULL AS BATCH_IN_QTY
									   ,NULL AS BATCH_OUT_QTY
									   ,SUM(PP.PLAN_IN_QTY_CELL)    AS CELL_IN_QTY
									   ,SUM(PP.PLAN_OUT_QTY_CELL)   AS CELL_OUT_QTY
									   ,NULL AS FULL_CLEANING_FLAG					-- 풀 세척					
									   ,NULL AS PIG_CLEANING_FLAG					-- PIG 세정					
									   ,NULL AS MODEL_TYPE_CHANGE_FLAG				-- 파우치->원각 모델 변경		
									   ,NULL AS SEQ									-- 전극 생산 우선 순위를 관리하기 위한 SEQ
									   ,NULL AS CELL_MATERIAL_ID					-- 활성화 후 공정 Cell Material ID 값 추가
									   ,NULL AS TOTAL_BATCH							-- 주별 계획 BATCH 합 추가
									   ,MAX(PP.SETUP_COLOR_CODE)	AS SETUP_COLOR_CODE
									   ,PP.[WORK_REQUEST_MODEL_ID]
									   ,PP.[VERSION]
									   ,ISNULL(PP.[PROD_SEQ],'-')   AS PROD_SEQ
									   ,PP.[PLM_EC_NO]   -- 2022-11-18 kimcd 일별 계획 이력에 전극 version, ec no 추가
								  FROM FP_AMEND_DAILY_PLAN_R PP WITH(NOLOCK)
									    LEFT OUTER JOIN DBO.SCM_LINE_M L 
													ON L.[COMPANY_ID] = PP.[COMPANY_ID]
												   AND L.[DIVISION_ID] = PP.[DIVISION_ID]
												   AND L.[SITE_ID] = PP.[SITE_ID]
												   AND L.[PLANT_ID] = PP.[PLANT_ID]
												   AND L.[FACTORY_ID] = PP.[FACTORY_ID]
												   AND L.[OPERATION_ID] = PP.[OPERATION_ID]
												   AND L.[LINE_ID] = PP.[LINE_ID]
												   AND L.[ELECTRODE_TYPE] = PP.[ELECTRODE_TYPE]
										LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE SLV
													ON SLV.SEGMENT1 = PP.INSTANCE_ID
												   AND SLV.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
												   AND SLV.ACTIVE_FLAG = 'Y'
								 WHERE PP.FP_PLAN_ID = @PLAN_ID
								   AND PP.INSTANCE_ID = @INSTANCE_ID
								   AND NOT (PP.INSTANCE_ID = 'KR_CELL_A2' AND PP.LINE_ID = 'A2AV1')  -- 오창 Pilot 예외 처리
								 GROUP BY PP.COMPANY_ID
									   , PP.DIVISION_ID
									   , PP.SITE_ID
									   , PP.PLANT_ID
									   , PP.FACTORY_ID
									    ,CASE WHEN SLV.ATTRIBUTE1 = 'BUILDING' THEN '-' ELSE MODEL_TYPE END
									   , TOP_ITEM_ID
									   , ITEM_ID
									   , PP.OPERATION_ID
									   , PP.PRODUCTION_TYPE
									   , ISNULL(MARKET,'D')
									   , PP.LINE_ID
									   , PP.PLAN_DATE
									   , PP.[WORK_REQUEST_MODEL_ID]
									   , PP.[VERSION]
									   , ISNULL(PP.[PROD_SEQ],'-')
									   , PP.[PLM_EC_NO]   -- 2022-11-18 kimcd 일별 계획 이력에 전극 version, ec no 추가
								UNION ALL
								SELECT  PP.COMPANY_ID
									   ,PP.DIVISION_ID
									   ,PP.SITE_ID
									   ,PP.PLANT_ID
									   ,PP.FACTORY_ID
									   ,CASE WHEN SLV.ATTRIBUTE1 = 'BUILDING' THEN '-' ELSE MODEL_TYPE END  AS PLAN_GROUP_ID
									   ,TOP_ITEM_ID
									   ,ITEM_ID
									   ,PP.OPERATION_ID
									   ,PP.PRODUCTION_TYPE AS PRODUCTION_TYPE
									   ,PP.PRODUCTION_TYPE AS FP_PRODUCTION_TYPE
									   ,ISNULL(MARKET,'D') AS MARKET
									   ,PP.LINE_ID
									   ,MAX(PP.ELECTRODE_TYPE) AS ELECTRODE_TYPE
									   ,PP.PLAN_DATE
									   ,SUM(OUT_QTY)    AS PLAN_QTY
									   ,SUM(IN_QTY)     AS PLAN_IN_QTY
									   ,@INSTANCE_ID AS INSTANCE_ID
									   ,'-' AS EQUIPMENT_ID
									   ,NULL AS ROLL_IN_QTY
									   ,NULL AS ROLL_OUT_QTY
									   ,NULL AS JR_IN_QTY
									   ,NULL AS JR_OUT_QTY
									   ,NULL AS BATCH_IN_QTY
									   ,NULL AS BATCH_OUT_QTY
									   ,SUM(PP.CELL_IN_QTY)    AS CELL_IN_QTY
									   ,SUM(PP.CELL_OUT_QTY)   AS CELL_OUT_QTY
									   ,NULL AS FULL_CLEANING_FLAG					-- 풀 세척					
									   ,NULL AS PIG_CLEANING_FLAG					-- PIG 세정					
									   ,NULL AS MODEL_TYPE_CHANGE_FLAG				-- 파우치->원각 모델 변경		
									   ,NULL AS SEQ									-- 전극 생산 우선 순위를 관리하기 위한 SEQ
									   ,NULL AS CELL_MATERIAL_ID					-- 활성화 후 공정 Cell Material ID 값 추가
									   ,NULL AS TOTAL_BATCH							-- 주별 계획 BATCH 합 추가
									   ,MAX(PP.SETUP_COLOR_CODE)	AS SETUP_COLOR_CODE		
									   ,'-' AS [WORK_REQUEST_MODEL_ID]
									   ,'-' AS [VERSION]
									   ,'-' AS [PROD_SEQ]
									   ,'-' AS [PLM_EC_NO]   -- 2022-11-18 kimcd 일별 계획 이력에 전극 version, ec no 추가
								  FROM FP_AMEND_PLAN_CELL_R PP WITH(NOLOCK)
									   LEFT OUTER JOIN DBO.SCM_LINE_M L 
													ON L.[COMPANY_ID] = PP.[COMPANY_ID]
												   AND L.[DIVISION_ID] = PP.[DIVISION_ID]
												   AND L.[SITE_ID] = PP.[SITE_ID]
												   AND L.[PLANT_ID] = PP.[PLANT_ID]
												   AND L.[FACTORY_ID] = PP.[FACTORY_ID]
												   AND L.[OPERATION_ID] = PP.[OPERATION_ID]
												   AND L.[LINE_ID] = PP.[LINE_ID]
												   AND L.[ELECTRODE_TYPE] = PP.[ELECTRODE_TYPE]
										LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE SLV
													ON SLV.SEGMENT1 = PP.INSTANCE_ID
												   AND SLV.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
												   AND SLV.ACTIVE_FLAG = 'Y'
								 WHERE PP.FP_PLAN_ID = @PLAN_ID
								   AND PP.INSTANCE_ID = @INSTANCE_ID
								   AND NOT (PP.INSTANCE_ID = 'KR_CELL_A2' AND PP.LINE_ID = 'A2AV1')  -- 오창 Pilot 예외 처리
								 GROUP BY PP.COMPANY_ID
									   , PP.DIVISION_ID
									   , PP.SITE_ID
									   , PP.PLANT_ID
									   , PP.FACTORY_ID
									   , CASE WHEN SLV.ATTRIBUTE1 = 'BUILDING' THEN '-' ELSE MODEL_TYPE END
									   , TOP_ITEM_ID
									   , ITEM_ID
									   , PP.OPERATION_ID
									   , PP.PRODUCTION_TYPE
									   , ISNULL(MARKET,'D')
									   , PP.LINE_ID
									   , PP.PLAN_DATE
								UNION ALL
								SELECT  PP.COMPANY_ID
									   ,PP.DIVISION_ID
									   ,PP.SITE_ID
									   ,PP.PLANT_ID
									   ,PP.FACTORY_ID
									   ,CASE WHEN SLV.ATTRIBUTE1 = 'BUILDING' THEN '-' ELSE L.MODEL_TYPE END AS PLAN_GROUP_ID
									   ,TOP_ITEM_ID
									   ,ITEM_ID
									   ,PP.OPERATION_ID
									   ,PP.PRODUCTION_TYPE AS PRODUCTION_TYPE
									   ,PP.PRODUCTION_TYPE AS FP_PRODUCTION_TYPE
									   ,ISNULL(MARKET,'D') AS MARKET
									   ,PP.LINE_ID
									   ,MAX(PP.ELECTRODE_TYPE) AS ELECTRODE_TYPE
									   ,PP.PLAN_DATE
									   ,SUM(OUT_QTY) AS PLAN_QTY
									   ,SUM(IN_QTY) AS PLAN_IN_QTY
									   ,@INSTANCE_ID AS INSTANCE_ID
									   ,'-' AS EQUIPMENT_ID
									   ,NULL AS ROLL_IN_QTY
									   ,NULL AS ROLL_OUT_QTY
									   ,NULL AS JR_IN_QTY
									   ,NULL AS JR_OUT_QTY
									   ,NULL AS BATCH_IN_QTY
									   ,NULL AS BATCH_OUT_QTY
									   ,NULL AS CELL_IN_QTY
									   ,NULL AS CELL_OUT_QTY
									   ,NULL AS FULL_CLEANING_FLAG					-- 풀 세척					
									   ,NULL AS PIG_CLEANING_FLAG					-- PIG 세정					
									   ,NULL AS MODEL_TYPE_CHANGE_FLAG				-- 파우치->원각 모델 변경		
									   ,NULL AS SEQ									-- 전극 생산 우선 순위를 관리하기 위한 SEQ
									   ,NULL AS CELL_MATERIAL_ID					-- 활성화 후 공정 Cell Material ID 값 추가
									   ,NULL AS TOTAL_BATCH							-- 주별 계획 BATCH 합 추가
									   ,NULL AS SETUP_COLOR_CODE	
									   ,'-' AS [WORK_REQUEST_MODEL_ID]
									   ,'-' AS [VERSION]
									   ,'-' AS [PROD_SEQ]
									   ,'-' AS [PLM_EC_NO]   -- 2022-11-18 kimcd 일별 계획 이력에 전극 version, ec no 추가
								  FROM FP_AMEND_PLAN_FORM_R PP WITH(NOLOCK)
									    LEFT OUTER JOIN DBO.SCM_LINE_M L 
													ON L.[COMPANY_ID] = PP.[COMPANY_ID]
												   AND L.[DIVISION_ID] = PP.[DIVISION_ID]
												   AND L.[SITE_ID] = PP.[SITE_ID]
												   AND L.[PLANT_ID] = PP.[PLANT_ID]
												   AND L.[FACTORY_ID] = PP.[FACTORY_ID]
												   AND L.[OPERATION_ID] = PP.[OPERATION_ID]
												   AND L.[LINE_ID] = PP.[LINE_ID]
												   AND L.[ELECTRODE_TYPE] = PP.[ELECTRODE_TYPE]
										LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE SLV
													ON SLV.SEGMENT1 = PP.INSTANCE_ID
												   AND SLV.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
												   AND SLV.ACTIVE_FLAG = 'Y'
								 WHERE PP.FP_PLAN_ID = @PLAN_ID
								   AND PP.INSTANCE_ID = @INSTANCE_ID
								   AND NOT (PP.INSTANCE_ID = 'KR_CELL_A2' AND PP.LINE_ID = 'A2AV1')  -- 오창 Pilot 예외 처리
								 GROUP BY PP.COMPANY_ID
									   , PP.DIVISION_ID
									   , PP.SITE_ID
									   , PP.PLANT_ID
									   , PP.FACTORY_ID
									   , CASE WHEN SLV.ATTRIBUTE1 = 'BUILDING' THEN '-' ELSE MODEL_TYPE END
									   , TOP_ITEM_ID
									   , ITEM_ID
									   , PP.OPERATION_ID
									   , PP.PRODUCTION_TYPE
									   , ISNULL(MARKET,'D')
									   , PP.LINE_ID
									   , PP.PLAN_DATE
								UNION ALL
								SELECT PP.COMPANY_ID
									   ,PP.DIVISION_ID
									   ,PP.SITE_ID
									   ,PP.PLANT_ID
									   ,PP.FACTORY_ID
									   ,CASE WHEN SLV.ATTRIBUTE1 = 'BUILDING' THEN '-' ELSE MODEL_TYPE END AS PLAN_GROUP_ID
									   ,TOP_ITEM_ID
									   ,ITEM_ID
									   ,PP.OPERATION_ID
									   ,PP.PRODUCTION_TYPE AS PRODUCTION_TYPE
									   ,PP.PRODUCTION_TYPE AS FP_PRODUCTION_TYPE
									   ,ISNULL(MARKET,'D') AS MARKET
									   ,PP.LINE_ID
									   ,MAX(PP.ELECTRODE_TYPE) AS ELECTRODE_TYPE
									   ,PP.PLAN_DATE
									   ,SUM(OUT_QTY) AS PLAN_QTY
									   ,SUM(IN_QTY) AS PLAN_IN_QTY
									   ,@INSTANCE_ID AS INSTANCE_ID
									   ,'-' AS EQUIPMENT_ID
									   ,NULL AS ROLL_IN_QTY
									   ,NULL AS ROLL_OUT_QTY
									   ,NULL AS JR_IN_QTY
									   ,NULL AS JR_OUT_QTY
									   ,NULL AS BATCH_IN_QTY
									   ,NULL AS BATCH_OUT_QTY
									   ,SUM(PP.CELL_IN_QTY)    AS CELL_IN_QTY
									   ,SUM(PP.CELL_OUT_QTY)   AS CELL_OUT_QTY
									   ,NULL AS FULL_CLEANING_FLAG					-- 풀 세척					
									   ,NULL AS PIG_CLEANING_FLAG					-- PIG 세정					
									   ,NULL AS MODEL_TYPE_CHANGE_FLAG				-- 파우치->원각 모델 변경		
									   ,NULL AS SEQ									-- 전극 생산 우선 순위를 관리하기 위한 SEQ
									   ,NULL AS CELL_MATERIAL_ID					-- 활성화 후 공정 Cell Material ID 값 추가
									   ,NULL AS TOTAL_BATCH							-- 주별 계획 BATCH 합 추가
									   ,MAX(PP.SETUP_COLOR_CODE)	AS SETUP_COLOR_CODE			
									   ,'-' AS [WORK_REQUEST_MODEL_ID]
									   ,'-' AS [VERSION]
									   ,'-' AS [PROD_SEQ]
									   ,'-' AS [PLM_EC_NO]   -- 2022-11-18 kimcd 일별 계획 이력에 전극 version, ec no 추가
								  FROM FP_AMEND_PLAN_PACK_R PP WITH(NOLOCK)
									  LEFT OUTER JOIN DBO.SCM_LINE_M L 
													ON L.[COMPANY_ID] = PP.[COMPANY_ID]
												   AND L.[DIVISION_ID] = PP.[DIVISION_ID]
												   AND L.[SITE_ID] = PP.[SITE_ID]
												   AND L.[PLANT_ID] = PP.[PLANT_ID]
												   AND L.[FACTORY_ID] = PP.[FACTORY_ID]
												   AND L.[OPERATION_ID] = PP.[OPERATION_ID]
												   AND L.[LINE_ID] = PP.[LINE_ID]
												   AND L.[ELECTRODE_TYPE] = PP.[ELECTRODE_TYPE]
										LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE SLV
													ON SLV.SEGMENT1 = PP.INSTANCE_ID
												   AND SLV.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
												   AND SLV.ACTIVE_FLAG = 'Y'
								 WHERE PP.FP_PLAN_ID = @PLAN_ID
								   AND PP.INSTANCE_ID = @INSTANCE_ID
								   AND NOT (PP.INSTANCE_ID = 'KR_CELL_A2' AND PP.LINE_ID = 'A2AV1')  -- 오창 Pilot 예외 처리
								 GROUP BY PP.COMPANY_ID
									   ,PP.DIVISION_ID
									   ,PP.SITE_ID
									   ,PP.PLANT_ID
									   ,PP.FACTORY_ID
									   ,CASE WHEN SLV.ATTRIBUTE1 = 'BUILDING' THEN '-' ELSE MODEL_TYPE END
									   ,TOP_ITEM_ID
									   ,ITEM_ID
									   ,PP.OPERATION_ID
									   ,PRODUCTION_TYPE
									   ,ISNULL(MARKET,'D')
									   ,PP.LINE_ID
									   ,PP.PLAN_DATE
								----------------------------------------------------------------------------------------------------------------
								----------------------------------------------------------------------------------------------------------------
								---	2019-12-06 PIYONG ADD
								UNION ALL
								SELECT PP.COMPANY_ID
									   ,PP.DIVISION_ID
									   ,PP.SITE_ID
									   ,PP.PLANT_ID
									   ,PP.FACTORY_ID
									   ,'-' AS PLAN_GROUP_ID
									   ,TOP_ITEM_ID
									   ,ITEM_ID
									   ,PP.OPERATION_ID
									   ,PP.PRODUCTION_TYPE AS PRODUCTION_TYPE
									   ,PP.PRODUCTION_TYPE AS FP_PRODUCTION_TYPE
									   ,ISNULL(MARKET,'D') AS MARKET
									   ,PP.LINE_ID
									   ,MAX(PP.ELECTRODE_TYPE) AS ELECTRODE_TYPE
									   ,PP.PLAN_DATE
									   ,SUM(PP.PLAN_QTY) AS PLAN_QTY
									   ,SUM(PP.PLAN_IN_QTY) AS PLAN_IN_QTY
									   ,@INSTANCE_ID AS INSTANCE_ID
									   ,'-' AS EQUIPMENT_ID
									   ,NULL AS ROLL_IN_QTY
									   ,NULL AS ROLL_OUT_QTY
									   ,NULL AS JR_IN_QTY
									   ,NULL AS JR_OUT_QTY
									   ,NULL AS BATCH_IN_QTY
									   ,NULL AS BATCH_OUT_QTY
									   ,SUM(PP.CELL_IN_QTY)    AS CELL_IN_QTY
									   ,SUM(PP.CELL_OUT_QTY)   AS CELL_OUT_QTY
									   ,NULL AS FULL_CLEANING_FLAG					-- 풀 세척					
									   ,NULL AS PIG_CLEANING_FLAG					-- PIG 세정					
									   ,NULL AS MODEL_TYPE_CHANGE_FLAG				-- 파우치->원각 모델 변경		
									   ,NULL AS SEQ									-- 전극 생산 우선 순위를 관리하기 위한 SEQ
									   ,NULL AS CELL_MATERIAL_ID					-- 활성화 후 공정 Cell Material ID 값 추가
									   ,NULL AS TOTAL_BATCH							-- 주별 계획 BATCH 합 추가
									   ,MAX(PP.SETUP_COLOR_CODE)	AS SETUP_COLOR_CODE
									   ,PP.[WORK_REQUEST_MODEL_ID]  AS [WORK_REQUEST_MODEL_ID]
									   ,PP.[VERSION]                AS [VERSION]
									   ,ISNULL(PP.[PROD_SEQ],'-')   AS [PROD_SEQ]
									   ,PP.[PLM_EC_NO]              AS [PLM_EC_NO]   -- 2022-11-18 kimcd 일별 계획 이력에 전극 version, ec no 추가
								  FROM FP_DAILY_PRODUCTION_PLAN_R PP WITH(NOLOCK)
								 WHERE PP.FP_PLAN_ID = @PLAN_ID
								   AND PP.INSTANCE_ID = @INSTANCE_ID
								   AND NOT (PP.INSTANCE_ID = 'KR_CELL_A2' AND PP.LINE_ID = 'A2AV1')  -- 오창 Pilot 예외 처리
								   AND @PLAN_TYPE = 'RELEASE'
								 GROUP BY PP.COMPANY_ID
									   ,PP.DIVISION_ID
									   ,PP.SITE_ID
									   ,PP.PLANT_ID
									   ,PP.FACTORY_ID
									   ,TOP_ITEM_ID
									   ,ITEM_ID
									   ,PP.OPERATION_ID
									   ,PRODUCTION_TYPE
									   ,ISNULL(MARKET,'D')
									   ,PP.LINE_ID
									   ,PP.PLAN_DATE
									   ,PP.[WORK_REQUEST_MODEL_ID]
									   ,PP.[VERSION]
									   ,ISNULL(PP.[PROD_SEQ],'-')
									   ,PP.[PLM_EC_NO]   -- 2022-11-18 kimcd 일별 계획 이력에 전극 version, ec no 추가
								---	2019-12-06 PIYONG ADD
								----------------------------------------------------------------------------------------------------------------
								----------------------------------------------------------------------------------------------------------------
							   ) A
					 ) B
				  ON (
						DP.[FACTORY_ID]				= B.[FACTORY_ID]
						AND DP.[INSTANCE_TYPE]		= B.[INSTANCE_TYPE]
						AND DP.[PLAN_TYPE]			= B.[PLAN_TYPE]
						AND DP.[ITEM_ID]			= B.[ITEM_ID]
						AND DP.[LINE_ID]			= B.[LINE_ID]
						AND DP.[PLAN_DATE]			= B.[PLAN_DATE]
						AND DP.[TOP_ITEM_ID]		= B.[TOP_ITEM_ID]
						AND DP.[OPERATION_ID]		= B.[OPERATION_ID]
						AND DP.[FP_PRODUCTION_TYPE]	= B.[FP_PRODUCTION_TYPE]
						AND DP.[MARKET]				= B.[MARKET]
						AND DP.[EQUIPMENT_ID]		= B.[EQUIPMENT_ID]
						AND DP.[WORK_REQUEST_MODEL_ID] = B.[WORK_REQUEST_MODEL_ID]
						AND DP.[VERSION]               = B.[VERSION]
						AND DP.[PROD_SEQ]              = B.[PROD_SEQ]
						AND DP.[PLM_EC_NO]             = B.[PLM_EC_NO]   -- 2022-11-18 kimcd 일별 계획 이력에 전극 version, ec no 추가
					 )
				  WHEN MATCHED THEN
						UPDATE SET   DP.[PRODUCTION_TYPE]         = B.[PRODUCTION_TYPE]
									,DP.[ELECTRODE_TYPE]          = B.[ELECTRODE_TYPE]
									,DP.[PLAN_QTY]                = B.[PLAN_QTY]
									,DP.[PLAN_IN_QTY]             = B.[PLAN_IN_QTY]
									,DP.[ROLL_IN_QTY]             = B.[ROLL_IN_QTY]
									,DP.[ROLL_OUT_QTY]            = B.[ROLL_OUT_QTY]
									,DP.[JR_IN_QTY]               = B.[JR_IN_QTY]
									,DP.[JR_OUT_QTY]              = B.[JR_OUT_QTY]
									,DP.[BATCH_IN_QTY]            = B.[BATCH_IN_QTY]
									,DP.[BATCH_OUT_QTY]           = B.[BATCH_OUT_QTY]
									,DP.[CELL_IN_QTY]             = B.[CELL_IN_QTY]
									,DP.[CELL_OUT_QTY]            = B.[CELL_OUT_QTY]
									,DP.[FULL_CLEANING_FLAG]      = B.[FULL_CLEANING_FLAG]		-- 풀 세척					
									,DP.[PIG_CLEANING_FLAG]		  = B.[PIG_CLEANING_FLAG]		-- PIG 세정				
									,DP.[MODEL_TYPE_CHANGE_FLAG]  = B.[MODEL_TYPE_CHANGE_FLAG]	-- 파우치->원각 모델 변경	
									,DP.[SEQ]					  = B.[SEQ]						-- 전극 생산 우선 순위를 관리하기 위한 SEQ
									,DP.[CELL_MATERIAL_ID]        = B.[CELL_MATERIAL_ID]		-- 활성화 후 공정 Cell Material ID 값 추가
									,DP.[TOTAL_BATCH]             = B.[TOTAL_BATCH]				-- 주별 계획 BATCH 합 추가
									,DP.[SETUP_COLOR_CODE]		  = B.SETUP_COLOR_CODE			-- full, pig세정 강화 관련 색 지정
									,DP.[PLAN_GROUP_ID]           = B.[PLAN_GROUP_ID]			-- PLAN GROUP ID 조건을 제거하고 갱신하도록 함
									,DP.[UPDATE_ID]               = B.[UPDATE_ID]
									,DP.[UPDATE_TIME]             = B.[UPDATE_TIME]
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
								,[PLAN_TYPE]				-- 계획 유형 추가 - RELEASE
								,[EQUIPMENT_ID]				-- 설비 정보 추가
								,[FP_PRODUCTION_TYPE]
								,[ROLL_IN_QTY]				-- 전극 환산 계획 수량 시작
								,[ROLL_OUT_QTY]
								,[JR_IN_QTY]
								,[JR_OUT_QTY]
								,[BATCH_IN_QTY]
								,[BATCH_OUT_QTY]
								,[CELL_IN_QTY]
								,[CELL_OUT_QTY]				-- 전극 환산 계획 수량 끝
								,[FULL_CLEANING_FLAG]		-- 풀 세척
								,[PIG_CLEANING_FLAG]		-- PIG 세정
								,[MODEL_TYPE_CHANGE_FLAG]	-- 파우치->원각 모델 변경
								,[SEQ]						-- 전극 생산 우선 순위를 관리하기 위한 SEQ
								,[CELL_MATERIAL_ID]			-- 활성화 후 공정 Cell Material ID 값
								,[TOTAL_BATCH]				-- 주별 계획 BATCH 합
								,[SETUP_COLOR_CODE]			-- full, pig세정 강화 관련 색 지정
								,[WORK_REQUEST_MODEL_ID]
								,[VERSION]
								,[PROD_SEQ]
								,[PLM_EC_NO]                -- 2022-11-18 kimcd 일별 계획 이력에 전극 version, ec no 추가
						) VALUES ( B.[COMPANY_ID]
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
								,B.[PLAN_TYPE]				-- 계획 유형 추가 - RELEASE
								,B.[EQUIPMENT_ID]			-- 설비 정보 추가
								,B.[FP_PRODUCTION_TYPE]
								,B.[ROLL_IN_QTY]			-- 전극 환산 계획 수량 시작
								,B.[ROLL_OUT_QTY]
								,B.[JR_IN_QTY]
								,B.[JR_OUT_QTY]
								,B.[BATCH_IN_QTY]
								,B.[BATCH_OUT_QTY]
								,B.[CELL_IN_QTY]
								,B.[CELL_OUT_QTY]			-- 전극 환산 계획 수량 끝
								,B.[FULL_CLEANING_FLAG]		-- 추가 풀 세척						
								,B.[PIG_CLEANING_FLAG]		-- 추가 PIG 세정					
								,B.[MODEL_TYPE_CHANGE_FLAG]	-- 파우치->원각 모델 변경		
								,B.[SEQ]					-- 전극 생산 우선 순위를 관리하기 위한 SEQ
								,B.[CELL_MATERIAL_ID]		-- 활성화 후 공정 Cell Material ID 값 추가
								,B.[TOTAL_BATCH]			-- 주별 계획 BATCH 합
								,B.[SETUP_COLOR_CODE]		-- full, pig세정 강화 관련 색 지정
								,B.[WORK_REQUEST_MODEL_ID]
								,B.[VERSION]
								,B.[PROD_SEQ]
								,B.[PLM_EC_NO]   -- 2022-11-18 kimcd 일별 계획 이력에 전극 version, ec no 추가
						)
					;			


				SET @ROWCOUNT = @ROWCOUNT + @@ROWCOUNT


				UPDATE DBO.SCM_FP_PLAN_H
				SET    SSP_FLAG		= 'Y'
					   ,UPDATE_ID	= 'PR_XIF_SSP_PROD_TARGET_S'
					   ,UPDATE_TIME	= GETDATE()
				WHERE  INSTANCE_ID	= @INSTANCE_ID
				AND    PLAN_ID		= @PLAN_ID


				FETCH NEXT FROM CUR_PLAN_ID INTO @INSTANCE_ID
												,@PLAN_ID
												,@INSTANCE_TYPE
												,@PLAN_START_TIME
												,@PLAN_TYPE

			END;  -- WHILE @@FETCH_STATUS = 0

        CLOSE CUR_PLAN_ID;
        DEALLOCATE CUR_PLAN_ID;   -- 메모리 해제


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
