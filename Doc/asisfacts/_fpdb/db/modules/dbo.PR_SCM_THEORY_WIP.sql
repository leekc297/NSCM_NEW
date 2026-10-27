
CREATE PROCEDURE [dbo].[PR_SCM_THEORY_WIP]
--ALTER PROCEDURE [dbo].[PR_SCM_THEORY_WIP]

-- ================================================================================================
-- Program ID          : 
-- Program Name        : PR_SCM_THEORY_WIP
-- Param               :
-- Batch Period        : 1HOUR
-- Description         : MES 재고 정보 전환
--
-- Source System       : FP SDB
-- Destination System  : FP SDB
-- Source Table        : SCM_BASE_STOCK_H, SCM_MES_WIP_HISTORY_H
-- Destination Table   : 이론재고
-- 이동 유형
--              MOVE_AREA : 동일 PLANT 동간이동 EX) A1 -> A2, E5 -> E6
--              MOVE_LINE : 라인간 이동
--              MOVE_MTRL : 자재 이동
--              MOVE_PROC : 동일 PLANT, 동 공정이동 EX) 310A -> 310B, 310N -> 310M
--              MOVE_SHOP : PLANT 이동 EX) A041 -> A040, G452 -> G451
--              RETURN_MTRL : 자재 반품
--              RETURN_SHOP : PLANT 반품 EX) A040 -> A041, G451 -> G452
--
-- Create Date		   : 2017.08.18
-- Update Date		   : 2020.07.07

-- Author              : PIYONG
-- Version             : 1.1 kimcd 2017.09.18 활성화 후 재작업 WO에서 
--                           실적은 실적 수량에서 제외
--                       1.2 kimcd 긴급 반영 A7000은 A5000으로 반영되도록 수정
--                           lookup에 공정 설정된 경우 해당 공정 직접 입력
--                       1.3 2017-12-18 남경 소형 조립의 경우 location 정보 형성
--                       1.4 2017-12-30 kimcd 작업 속도 향상을 위해 실적을 일자별 실적 Table에서 추출
--                       1.5 2018-01-16 kimcd BOM Primary 품목 기준으로 계산
--                                            A4000의 경우 IN 기준으로 재고 이동할 경우 문제가 되어 예외 처리
--                                            A6000 실적 기반으로 층 이동 정보 형성
--                       1.6 2018-07-27 kimcd 활성화 특성 공정 제거
--                       1.7 2019-09-27 kimcd CNB 시업시간 분리에 따른 Site 시업 시간 기준으로 작업 분리
--                       1.71 2020-07-07 kimcd 이동 실적 조회 문장 속도 저하로 튜닝 - 동 조건 제거
--                       2024-03-15 chkim.68 하드코딩 전환 (ref scm_code_lookup_value )
-- ================================================================================================

-- PARAMETER
@P_SITE_ID     NVARCHAR(50) = NULL,
@P_BASIS_START_TIME NVARCHAR(6) = '060000'  -- 2019-09-27 kimcd 시업 시간 구분자 추가
AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_SCM_THEORY_WIP'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	   = 0
	DECLARE @sysdate     DATETIME      = GETDATE()
	DECLARE @ACCUM_DATE  DATE          = CONVERT(DATE, GETDATE(), 120)
	DECLARE @I_CNT       INTEGER
	DECLARE @INSERT_ID   NVARCHAR(150)

	DECLARE @ROWCOUNT    INTEGER

	DECLARE @START_TIME	 NVARCHAR(10)

	DECLARE @TEMP_TABLE TABLE (
			 COMPANY_ID		NVARCHAR(30)
			,DIVISION_ID	NVARCHAR(30)
			,SITE_ID		NVARCHAR(30)
			,PLANT_ID		NVARCHAR(30)
			,FACTORY_ID		NVARCHAR(30)
			,ITEM_ID		NVARCHAR(150)
			,OPERATION_ID	NVARCHAR(30)
			,RESULT_DATE    DATE             -- 2019-09-27 kimcd 작업일자 추가
			,RESULT_QTY	    NUMERIC(20,10)
			,CONSUME_QTY    NUMERIC(20,10)
			,DATA_TYPE      NVARCHAR(30)
			,LOCATION       NVARCHAR(10) )  -- 2017-12-18 kimcd 층 정보 추가
	DECLARE @BASIS_START_TIME   NVARCHAR(6) = @P_BASIS_START_TIME; -- 2019-09-27 kimcd 시업 시간 추가
	DECLARE @SITE_ID        NVARCHAR(10) = @P_SITE_ID; -- 2019-09-27 kimcd 시업 시간 추가

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
		-- 로직 추가 start
		-- ================================================
		SET @v_temp1 = 'GET START TIME'
		-- 2019-09-27 kimcd 시업 시간 추출 로직 주석 처리 시작
		--SELECT TOP 1 @START_TIME = MAX(CONCAT(' ', SUBSTRING(W.[SEGMENT2], 1, 2), ':',SUBSTRING(W.[SEGMENT2], 3, 2), ':',SUBSTRING(W.[SEGMENT2], 5, 2)))
		--FROM   [DBO].[SCM_SYS_LOOKUP_VALUE] W  WITH(NOLOCK)
		--	  ,[DBO].[SCM_PLANT_M]          P  WITH(NOLOCK)
		--WHERE  W.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
		--AND    W.ACTIVE_FLAG = 'Y'
		--AND    W.SEGMENT1 = P.PLANT_ID
		--AND    P.SITE_ID = @P_SITE_ID;
		-- 2019-09-27 kimcd 시업 시간 추출 로직 주석 처리 끝
		SELECT TOP 1 @START_TIME = CONCAT(' ', SUBSTRING(@P_BASIS_START_TIME, 1, 2), ':',SUBSTRING(@P_BASIS_START_TIME, 3, 2), ':',SUBSTRING(@P_BASIS_START_TIME, 5, 2))
		-- 2019-09-27 kimcd 시업 시간 추출을 매개변수 기준으로 수행

		-- 최신 기초재고 CUTOFF 날짜 기준 실적 조회
		SET @v_temp1 = 'GET PROD RESULT'
		-- 2017-12-30 kimcd 실적 취합 기반 Table SCM_MES_WIP_HISTORY_H에서 SCM_DAILY_PRODUCT_RESULT_H으로 전환
		INSERT INTO @TEMP_TABLE
		SELECT  A.COMPANY_ID
				,A.DIVISION_ID
				,A.SITE_ID
				,A.PLANT_ID
				,A.FACTORY_ID
				,A.ITEM_ID
				,A.OPERATION_ID
				,A.PLAN_DATE  -- 2019-09-27 kimcd 작업일자 추가
				,A.RESULT_QTY
				,A.CONSUME_QTY
				,'RESULT'
				,A.LOCATION -- 2017-12-18 kimcd location 정보 추가
			FROM (SELECT W.COMPANY_ID
						,W.DIVISION_ID
						,W.SITE_ID
						,W.PLANT_ID
						,W.FACTORY_ID
						,W.ITEM_ID
						,W.OPERATION_ID
						,W.PLAN_DATE -- 2019-09-27 kimcd 작업일자 추가
						,SUM(W.ACTUAL_GOOD_QTY)   AS RESULT_QTY
						,SUM(W.ACTUAL_QTY)        AS CONSUME_QTY
						,ISNULL(W.LOCATION,'-')   AS LOCATION -- 2017-12-18 kimcd 층 정보 추가
				  FROM  [DBO].[SCM_ITEM_M]                 I WITH(NOLOCK)
					   ,[DBO].[SCM_DAILY_PRODUCT_RESULT_H] W WITH(NOLOCK)
				  WHERE W.PLAN_DATE >= (SELECT TOP 1 S.[CUTOFF_DATE]
										FROM   SCM_BASE_STOCK_H  S WITH(NOLOCK)
										WHERE  S.SITE_ID    = W.SITE_ID
										AND    S.FACTORY_ID = W.FACTORY_ID
										ORDER  BY S.[CUTOFF_DATE] DESC )
				  AND I.ITEM_TYPE    IN ('P','H')
				  AND I.ACTIVE_FLAG   = 'Y'
				  AND I.ITEM_ID       = W.ITEM_ID
				  AND I.DIVISION_ID   = W.DIVISION_ID
				  AND I.SITE_ID       = W.SITE_ID
				  AND I.COMPANY_ID    = W.COMPANY_ID
				  AND I.SITE_ID       = @SITE_ID
				  AND ( I.FLOW_ID    LIKE 'A%' OR I.FLOW_ID    LIKE 'P%' )	-- 임시. 안정화 후 제거
				  AND W.SITE_ID       = @SITE_ID
				  AND W.PLANT_ID IN  (SELECT W.SEGMENT1
									  FROM   [DBO].[SCM_SYS_LOOKUP_VALUE] W  WITH(NOLOCK)
									  WHERE  W.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
									  AND    W.ACTIVE_FLAG = 'Y'
									  AND    W.SEGMENT2 = @BASIS_START_TIME) -- 2019-09-27 kimcd PLANT 시업 시간 구분자 추가
				  AND W.OPERATION_ID != 'A6000' -- 임시. 안정화 후 제거
				  AND W.OPERATION_ID NOT IN  ('F4000', 'F5300', 'F5500', 'F5600', 'F6000') -- 2018-07-27 kimcd 활성화 특성 공정 제거 2019-09-27 kimcd F4000 제거 대상 공정에 추가
				  GROUP BY   W.COMPANY_ID
							,W.DIVISION_ID
							,W.SITE_ID
							,W.PLANT_ID
							,W.FACTORY_ID
							,ISNULL(W.LOCATION,'-')
							,W.ITEM_ID
							,W.OPERATION_ID
							,W.PLAN_DATE ) A -- 2019-09-27 kimcd 작업일자(PLAN_DATE) 추가
			   , SCM_OPERATION_M  SOM WITH(NOLOCK)
			WHERE SOM.COMPANY_ID   = A.COMPANY_ID
			AND   SOM.DIVISION_ID  = A.DIVISION_ID
			AND   SOM.SITE_ID      = A.SITE_ID
			AND   SOM.OPERATION_ID = A.OPERATION_ID
		/* 2017-12-30 kimcd 실적 취합 Table 변경
		INSERT INTO @TEMP_TABLE
		SELECT  A.COMPANY_ID
				,A.DIVISION_ID
				,A.SITE_ID
				,A.PLANT_ID
				,A.FACTORY_ID
				,A.ITEM_ID
				,A.OPERATION_ID
				,A.RESULT_QTY
				,A.CONSUME_QTY
				,'RESULT'
				,A.LOCATION -- 2017-12-18 kimcd location 정보 추가
			FROM (SELECT ISNULL(L.COMPANY_ID, C.COMPANY_ID)    AS COMPANY_ID
						,ISNULL(L.DIVISION_ID, C.DIVISION_ID)  AS DIVISION_ID
						,ISNULL(L.SITE_ID, C.SITE_ID)          AS SITE_ID
						,ISNULL(L.PLANT_ID, C.PLANT_ID)        AS PLANT_ID
						,ISNULL(L.FACTORY_ID, C.FACTORY_ID)    AS FACTORY_ID
						,PRODID                                AS ITEM_ID
						,PROCID                                AS OPERATION_ID
						,SUM(WIPQTY2_ED)                       AS RESULT_QTY
						,ISNULL( SUM(ISNULL(WIPQTY2_ED,0))
								+ SUM(ISNULL(CONVERT(NUMERIC(14,3),CNFM_DFCT_QTY2),0)) 
								+ SUM(ISNULL(CONVERT(NUMERIC(14,3),CNFM_LOSS_QTY2),0)) 
								+ SUM(ISNULL(CONVERT(NUMERIC(14,3),CNFM_PRDT_REQ_QTY2),0))
								+ SUM(ISNULL(CAST(SCRAP_QTY AS NUMERIC(14,3)),0))
							,0)                                AS CONSUME_QTY
						,ISNULL(L.LOCATION, ISNULL(C.LOCATION,'-'))   AS LOCATION -- 2017-12-18 kimcd 층 정보 추가
					FROM (SELECT  W.PRODID
								,W.EQSGID
								,W.PROCID
								,W.EQPTID
								,W.WIPQTY_ED
								,W.WIPQTY2_ED
								,W.CNFM_DFCT_QTY2
								,W.CNFM_LOSS_QTY2
								,W.CNFM_PRDT_REQ_QTY2
								,W.SCRAP_QTY
                                ,(SELECT TOP 1 A.DIVISION_ID
									FROM [DBO].[FP_PRODUCTION_PLAN_R] A WITH(NOLOCK)
									WHERE A.WORK_ORDER_ID = W.WOID
									AND A.PRODUCTION_TYPE IS NOT NULL
									ORDER BY FP_PLAN_ID DESC) DIVISION_CODE
							FROM [DBO].[SCM_MES_WIP_HISTORY_H] W WITH(NOLOCK)
							WHERE CAST( W.WIPDTTM_ED AS DATETIME) >= (SELECT TOP 1 CONVERT ( DATETIME, CONVERT(NVARCHAR(10), S.[CUTOFF_DATE] ,120) + @START_TIME,	120)
																	FROM   SCM_BASE_STOCK_H  S WITH(NOLOCK)
																	WHERE  S.SITE_ID = W.ATTRIBUTE1
																	AND    S.FACTORY_ID = SUBSTRING(W.EQSGID,1,2)
																	ORDER  BY S.[CUTOFF_DATE] DESC)
							AND W.WIP_TYPE_CODE IN ('INOUT','OUT','PACKED', 'PROD')  -- PACKED 는 PACK 포장용
							AND (W.FORMATION_REWORK_TYPE <> 'Y' OR W.FORMATION_REWORK_TYPE IS NULL)	  -- kimcd 2017-09-18 조건 추가
							AND EXISTS (SELECT 1
											FROM SCM_ITEM_M I
										WHERE I.ITEM_TYPE IN ('P','H')
											AND I.ACTIVE_FLAG = 'Y'
											AND I.ITEM_ID = W.PRODID
											AND I.SITE_ID = @P_SITE_ID
											AND I.FLOW_ID LIKE 'A%'  -- 임시. 안정화 후 제거
										)
							AND W.ATTRIBUTE1 = @P_SITE_ID
							AND W.PROCID != 'A6000' -- 임시. 안정화 후 제거
						) U
					LEFT OUTER JOIN [DBO].[SCM_EQUIPMENT_M] L WITH(NOLOCK)
					ON U.EQPTID  = L.EQUIPMENT_ID
					AND (CASE WHEN U.DIVISION_CODE = '81' AND U.EQSGID = 'E7D01' THEN
								'E8'
								WHEN ( SELECT TOP 1 SUBSTRING(A.ITEM_NAME,1,1) FROM SCM_ITEM_M A WHERE A.ITEM_ID = U.PRODID ) IN ( 'A', 'E') AND U.EQSGID = 'E7D01' THEN
								'E8'
								WHEN ( SELECT DISTINCT SUBSTRING(A.ITEM_NAME,1,1) FROM SCM_ITEM_M A WHERE A.ITEM_ID = U.PRODID ) = 'M'  AND U.EQSGID = 'E7D01' THEN
								'E7'
								ELSE SUBSTRING(U.EQSGID,1,2)
								END )  =  L.FACTORY_ID
					AND L.MES_LINE_ID = U.EQSGID
					AND L.DIVISION_ID =  ISNULL(U.DIVISION_CODE, (CASE WHEN ( SELECT TOP 1 SUBSTRING(A.ITEM_NAME,1,1) FROM SCM_ITEM_M A WHERE A.ITEM_ID = U.PRODID ) IN ('A','E') AND U.EQSGID = 'E7D01' THEN
																		'81'
																		WHEN  ( SELECT DISTINCT SUBSTRING(A.ITEM_NAME,1,1) FROM SCM_ITEM_M A WHERE A.ITEM_ID = U.PRODID ) = 'M'  AND U.EQSGID = 'E7D01' THEN
																		'40'
																		ELSE L.DIVISION_ID
																		END ))
					AND U.PROCID = L.OPERATION_ID  -- 하나의 설비가 여러 공정에 속할 수 있다고 함.
                -- 설비가 우리쪽에 없는 CASE에 대해서 COMPANY,DIVISION을 찾기 위함.
					LEFT OUTER JOIN (SELECT A.COMPANY_ID
											,A.DIVISION_ID
											,A.SITE_ID
											,A.PLANT_ID
											,A.FACTORY_ID
											,A.OPERATION_ID
											,A.MES_LINE_ID
											,MAX( A.LINE_ID) AS LINE_ID
											,MAX(A.LOCATION) AS LOCATION -- 2017-12-18 kimcd 층 정보 추가
										FROM [DBO].SCM_EQUIPMENT_M A WITH(NOLOCK)
									GROUP BY A.COMPANY_ID
											,A.DIVISION_ID
											,A.SITE_ID
											,A.PLANT_ID
											,A.FACTORY_ID
											,A.OPERATION_ID
											,A.MES_LINE_ID
									) C
					ON U.EQSGID =  C.MES_LINE_ID
					AND U.PROCID = C.OPERATION_ID
					AND C.DIVISION_ID =  ISNULL(U.DIVISION_CODE, (CASE WHEN ( SELECT TOP 1 SUBSTRING(A.ITEM_NAME,1,1) FROM SCM_ITEM_M A WHERE A.ITEM_ID = U.PRODID ) IN ( 'A','E') AND U.EQSGID = 'E7D01' THEN
																		'81'
																		WHEN ( SELECT DISTINCT SUBSTRING(A.ITEM_NAME,1,1) FROM SCM_ITEM_M A WHERE A.ITEM_ID = U.PRODID ) = 'M'  AND U.EQSGID = 'E7D01' THEN
																		'40'
																		ELSE C.DIVISION_ID
																		END ))
					AND SUBSTRING(U.EQSGID,1,2)  =  C.FACTORY_ID
					WHERE ISNULL(L.COMPANY_ID, C.COMPANY_ID) IS NOT NULL
					GROUP BY ISNULL(L.COMPANY_ID, C.COMPANY_ID)
						,ISNULL(L.DIVISION_ID, C.DIVISION_ID)
						,ISNULL(L.SITE_ID, C.SITE_ID)
						,ISNULL(L.PLANT_ID, C.PLANT_ID)
						,ISNULL(L.FACTORY_ID, C.FACTORY_ID)
						,ISNULL(L.LOCATION, ISNULL(C.LOCATION,'-'))  -- 2017-12-18 kimcd 층 정보 추가
						,PRODID
						,PROCID
				)A
			   , SCM_OPERATION_M  SOM WITH(NOLOCK)
			WHERE SOM.COMPANY_ID   = A.COMPANY_ID
			AND   SOM.DIVISION_ID  = A.DIVISION_ID
			AND   SOM.SITE_ID      = A.SITE_ID
			AND   SOM.OPERATION_ID = A.OPERATION_ID*/

		SET @v_temp1 = 'SET MOVE ORDER CONSUME RESULT'
		INSERT INTO @TEMP_TABLE
		SELECT  T.COMPANY_ID
			   ,T.DIVISION_ID
			   ,T.SITE_ID
			   ,T.PLANT_ID
			   ,T.FACTORY_ID
			   ,T.ITEM_ID
				, CASE WHEN SEGMENT4  IN ( 'PRE', 'STATUS') THEN
						CASE WHEN T.[FACTORY_ID] = 'E4' AND T.OPERATION_ID = 'E3000' THEN
							'E2500'
						ELSE
							ISNULL((SELECT TOP 1 F.OPERATION_ID				 
									FROM 	 DBO.SCM_ITEM_M       I WITH(NOLOCK)
											,SCM_OPERATION_FLOW_M F WITH(NOLOCK)
									WHERE  I.COMPANY_ID   = T.COMPANY_ID
									AND    I.DIVISION_ID  = T.DIVISION_ID
									AND    I.SITE_ID      = T.SITE_ID
									AND    I.ITEM_ID      = T.ITEM_ID
									AND    F.COMPANY_ID   = I.COMPANY_ID
									AND    F.DIVISION_ID  = I.DIVISION_ID
									AND    F.SITE_ID      = I.SITE_ID
									AND    F.FLOW_ID      = I.FLOW_ID
									AND    F.OPERATION_ID < T.OPERATION_ID
									ORDER  BY F.OPERATION_SEQ DESC) , T.OPERATION_ID)
						END
					ELSE                  
						ISNULL( SEGMENT4, T.OPERATION_ID)  -- 2017-12-14 kimcd lookup 기본 값 적용
					END AS OPERATION_ID
			   , T.RESULT_DATE   -- 2019-09-27 kimcd 생산 일자 컬럼 추가
			   , 0 AS RESULT_QTY
			   ,-T.CONSUME_QTY
			   ,'RESULT_MO'
			   ,T.LOCATION -- 2017-12-18 kimcd 층 정보 추가
		FROM    @TEMP_TABLE      T
				LEFT OUTER JOIN [DBO].[SCM_SYS_LOOKUP_VALUE] W WITH(NOLOCK)
				ON  W.LOOKUP_TYPE_CODE = 'WIP_OPERATION_STOCK_MAP'
				AND W.SEGMENT1 = T.OPERATION_ID
				AND W.SEGMENT3 = 'INOUT'
				AND W.ACTIVE_FLAG = 'Y'
			   ,SCM_OPERATION_M  SOM WITH(NOLOCK)
		WHERE SOM.COMPANY_ID   = T.COMPANY_ID
		AND   SOM.DIVISION_ID  = T.DIVISION_ID
		AND   SOM.SITE_ID      = T.SITE_ID
		AND   SOM.OPERATION_ID = T.OPERATION_ID
		AND   SOM.MO_FLAG      = 'Y'
		AND   T.DATA_TYPE      = 'RESULT'

		-- 최신 생산 실적 
		SET @v_temp1 = 'GET WORK ORDER CONSUME RESULT'
			INSERT INTO @TEMP_TABLE
			SELECT A.COMPANY_ID
				   ,A.DIVISION_ID
				   ,A.SITE_ID
				   ,A.PLANT_ID
				   ,A.FACTORY_ID
				   ,A.CHILD_ITEM_ID
				   ,A.OPERATION_ID
				   ,A.RESULT_DATE  -- 2019-09-27 kimcd 생산 일자 컬럼 추가
				   ,A.RESULT_QTY
				   ,A.CONSUME_QTY
				   ,A.DATA_TYPE
				   ,A.LOCATION -- 2017-12-18 kimcd 층 정보 추가
			FROM ( 	SELECT  A.COMPANY_ID
						   ,A.DIVISION_ID
						   ,A.SITE_ID
						   ,A.PLANT_ID
						   ,A.FACTORY_ID
						   ,B.CHILD_ITEM_ID
						, CASE WHEN SEGMENT4  IN ( 'PRE', 'STATUS') THEN
								CASE WHEN A.[FACTORY_ID] = 'E4' AND A.OPERATION_ID = 'E3000' THEN
									'E2500'
								ELSE
									ISNULL((SELECT TOP 1 F.OPERATION_ID
											FROM	SCM_OPERATION_FLOW_M F WITH(NOLOCK)
											WHERE  F.COMPANY_ID   = I.COMPANY_ID
											AND    F.DIVISION_ID  = I.DIVISION_ID
											AND    F.SITE_ID      = I.SITE_ID
											AND    F.FLOW_ID      = I.FLOW_ID
											AND    F.OPERATION_ID < A.OPERATION_ID
											AND    F.OPERATION_ID != 'A6000' --임시. 안정화 후 제거
											ORDER  BY F.OPERATION_SEQ DESC) , A.OPERATION_ID)
								END
							ELSE                  
								ISNULL( SEGMENT4, A.OPERATION_ID)  -- 2017-12-14 kimcd lookup 기본 값 적용
							END AS OPERATION_ID
						   ,A.RESULT_DATE  -- 2019-09-27 kimcd 생산 일자 컬럼 추가
						   ,0  AS RESULT_QTY
						   ,- ( A.CONSUME_QTY * B.CHILD_QTY ) / B.PARENT_QTY  AS CONSUME_QTY
						   ,'RESULT_WO'  AS DATA_TYPE
						   ,A.LOCATION -- 2017-12-18 kimcd 층 정보 추가
						   ,CASE WHEN B.[ALT_ID] IS NULL THEN
								1
							ELSE
								RANK() OVER (PARTITION BY B.[COMPANY_ID]
														,B.[DIVISION_ID]
														,B.[SITE_ID]
														,B.[PLANT_ID]
														,B.[BOM_VERSION_ID]
														,B.[PARENT_ITEM_ID]
														,B.[KEY_DATE]
														,B.[ALT_ID]
											ORDER BY B.[COMPANY_ID]
													,B.[DIVISION_ID]
													,B.[SITE_ID]
													,B.[PLANT_ID]
													,B.[BOM_VERSION_ID]
													,B.[PARENT_ITEM_ID]
													,B.[KEY_DATE]
													,B.[ALT_ID]
													,B.[ALT_PRIORITY])
							END  AS PRI_FLAG   -- 2018-01-16 kimcd Primary 품목 조건 추가
					  FROM  @TEMP_TABLE      A
							LEFT OUTER JOIN [DBO].[SCM_SYS_LOOKUP_VALUE] W WITH(NOLOCK)
							ON  W.LOOKUP_TYPE_CODE = 'WIP_OPERATION_STOCK_MAP'
							AND W.SEGMENT1 = A.OPERATION_ID
							AND W.SEGMENT3 = 'IN'
							AND W.ACTIVE_FLAG = 'Y'
						  , SCM_OPERATION_M  SOM WITH(NOLOCK)
						  , SCM_BOM_M B WITH(NOLOCK)
						  , SCM_ITEM_M I WITH(NOLOCK)
					WHERE  A.COMPANY_ID      = B.COMPANY_ID
					AND    A.DIVISION_ID     = B.DIVISION_ID
					AND    A.SITE_ID         = B.SITE_ID
					AND    A.PLANT_ID        = B.PLANT_ID
					AND    A.ITEM_ID         = B.PARENT_ITEM_ID
					AND    B.EFF_START_DATE <= GETDATE()
					AND    B.EFF_END_DATE    > GETDATE()
					AND    B.COMPANY_ID      = I.COMPANY_ID
					AND    B.DIVISION_ID     = I.DIVISION_ID
					AND    B.SITE_ID         = I.SITE_ID
					AND    B.CHILD_ITEM_ID   = I.ITEM_ID
					AND    I.ITEM_TYPE IN  ('P','Q','H')
					AND    I.ACTIVE_FLAG     = 'Y'
					AND    I.FLOW_ID        IS NOT NULL
					AND    ( I.FLOW_ID    LIKE 'A%' OR I.FLOW_ID LIKE 'P%' ) -- 임시. 안정화 후 제거
					AND   SOM.COMPANY_ID   = A.COMPANY_ID
					AND   SOM.DIVISION_ID  = A.DIVISION_ID
					AND   SOM.SITE_ID      = A.SITE_ID
					AND   SOM.OPERATION_ID = A.OPERATION_ID
					AND   SOM.WO_FLAG      = 'Y'
					AND   A.DATA_TYPE      = 'RESULT' ) A
			WHERE A.PRI_FLAG = 1  -- 2018-01-16 kimcd Primary 품목 조건 추가

		-- SET INITIAL QTY
		SET @v_temp1 = 'SET INITIAL INVENTORY'
		INSERT INTO @TEMP_TABLE
		SELECT  A.COMPANY_ID
				,A.DIVISION_ID
				,A.SITE_ID
				,A.PLANT_ID
				,A.FACTORY_ID
				,A.ITEM_ID
				--,A.OPERATION_ID  -- 임시. 안정화 후 주석 제거
				,CASE WHEN A.OPERATION_ID = 'A6000' THEN 'A5000' ELSE A.OPERATION_ID END AS OPERATION_ID -- 임시. 안정화 후 제거
				,A.CUTOFF_DATE   AS RESULT_DATE -- 2019-09-27 kimcd 일자 추가
				,A.WIPQTY        AS RESULT_QTY
				,0 CONSUME_QTY
				,'INITIAL'
				,ISNULL(A.LOCATION,'-') -- 2017-12-18 kimcd 층 정보 추가
        FROM   SCM_BASE_STOCK_H  A WITH(NOLOCK)
			  ,SCM_FACTORY_M     F WITH(NOLOCK)
		WHERE  A.COMPANY_ID  = F.COMPANY_ID
		AND    A.DIVISION_ID = F.DIVISION_ID
		AND    A.SITE_ID     = F.SITE_ID
		AND    A.PLANT_ID    = F.PLANT_ID
		AND    A.FACTORY_ID  = F.FACTORY_ID
		AND    F.SITE_ID     = @SITE_ID
		AND    F.PLANT_ID IN  ( SELECT  W.SEGMENT1
								FROM   [DBO].[SCM_SYS_LOOKUP_VALUE] W  WITH(NOLOCK)
								WHERE  W.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
								AND    W.ACTIVE_FLAG = 'Y'
								AND    W.SEGMENT2 = @BASIS_START_TIME) -- 2019-09-27 kimcd PLANT 시업 시간 구분자 추가
		AND    EXISTS ( SELECT 1
						FROM   SCM_ITEM_M I WITH(NOLOCK)
						WHERE  I.ITEM_TYPE  IN ('P','H')
						AND    I.ACTIVE_FLAG = 'Y'
						AND    I.ITEM_ID     = A.ITEM_ID
						AND    I.DIVISION_ID = A.DIVISION_ID
						AND    I.SITE_ID     = A.SITE_ID
						AND    I.COMPANY_ID  = A.COMPANY_ID
						AND    ( I.FLOW_ID  LIKE 'A%' OR I.FLOW_ID LIKE 'P%' )
						)   -- 임시. 안정화 후 제거
		AND    A.CUTOFF_DATE = ( SELECT TOP 1 S.CUTOFF_DATE
		                         FROM   SCM_BASE_STOCK_H  S WITH(NOLOCK)
                                 WHERE  S.SITE_ID = @SITE_ID
								 AND    S.FACTORY_ID = F.FACTORY_ID
								 ORDER  BY S.[CUTOFF_DATE] DESC )

		-- 이동 실적 취합 
		SET @v_temp1 = 'GET MOVE RESULT'
		INSERT INTO @TEMP_TABLE
		-- 2017-12-18 kimcd 층 정보 넣기 위해 GROUP BY로 조회 문장 한번더 감쌈.
		SELECT A.TO_COMPANY_ID
			  ,A.TO_DIVISION_ID
			  ,A.TO_SITE_ID
			  ,A.TO_PLANT_ID
			  ,A.TO_FACTORY_ID
			  ,A.ITEM_ID
			  ,A.OPERATION_ID
			  ,A.MOVE_STRT_DATE -- 2019-09-27 kimcd 이동일 추가
			  ,SUM(A.RESULT_QTY)
			  ,SUM(A.CONSUME_QTY) 
			  ,'MOVE_TO'
			  ,A.LOCATION -- 2017-12-18 kimcd 층 정보 추가
		FROM  ( SELECT  T.TO_COMPANY_ID
					   ,T.TO_DIVISION_ID
					   ,T.TO_SITE_ID
					   ,T.TO_PLANT_ID
					   ,T.TO_FACTORY_ID
					   ,T.ITEM_ID
						, CASE WHEN SEGMENT4  IN ( 'PRE', 'STATUS') THEN
								CASE WHEN T.[TO_FACTORY_ID] = 'E4' AND T.TO_OPERATION_ID = 'E3000' THEN
									'E2500'
								ELSE
									ISNULL((SELECT TOP 1 F.OPERATION_ID				 
											FROM 	 DBO.SCM_ITEM_M       I WITH(NOLOCK)
													,SCM_OPERATION_FLOW_M F WITH(NOLOCK)
											WHERE  I.COMPANY_ID   = T.TO_COMPANY_ID
											AND    I.DIVISION_ID  = T.TO_DIVISION_ID
											AND    I.SITE_ID      = T.TO_SITE_ID
											AND    I.ITEM_ID      = T.ITEM_ID
											AND    F.COMPANY_ID   = I.COMPANY_ID
											AND    F.DIVISION_ID  = I.DIVISION_ID
											AND    F.SITE_ID      = I.SITE_ID
											AND    F.FLOW_ID      = I.FLOW_ID
											AND    F.OPERATION_ID != 'A6000' --임시. 안정화 후 제거
											AND    F.OPERATION_ID < T.TO_OPERATION_ID
											ORDER  BY F.OPERATION_SEQ DESC) , T.TO_OPERATION_ID)
								END
							ELSE                  
								ISNULL( SEGMENT4, T.TO_OPERATION_ID)  -- 2017-12-14 kimcd lookup 기본 값 적용
							END AS OPERATION_ID
					   , T.MOVE_STRT_DATE -- 2019-09-27 kimcd 이동일 추가
					   , T.QTY AS RESULT_QTY
					   , 0     AS CONSUME_QTY
					   ,ISNULL((SELECT TOP 1 L.LOCATION
								FROM   SCM_EQUIPMENT_M L WITH(NOLOCK)
								WHERE  L.OPERATION_ID = T.TO_OPERATION_ID
								AND    L.MES_LINE_ID  = T.TO_EQSGID
								AND    L.PLANT_ID     = T.TO_PLANT_ID
								AND    L.EQUIPMENT_TYPE = 'M'
								AND    L.ACTIVE_FLAG  = 'Y'
								ORDER  BY L.EQUIPMENT_ID ) ,'-') AS LOCATION -- 2017-12-18 kimcd 층 정보 추가
				FROM   ( SELECT  T.PRODID         AS ITEM_ID
								,TF.COMPANY_ID    AS TO_COMPANY_ID
								,TF.DIVISION_ID   AS TO_DIVISION_ID
								,TF.SITE_ID       AS TO_SITE_ID
								,TF.PLANT_ID      AS TO_PLANT_ID
								,T.TO_AREAID      AS TO_FACTORY_ID
								,CASE WHEN T.TO_PROCID IS NULL OR T.TO_PROCID = '' THEN
										CASE WHEN MAX(TF.SHOP_GROUP_ID) = 'E' THEN
											'E7000'
										ELSE
											(SELECT TOP 1 LM.OPERATION_ID
											FROM   SCM_LINE_M LM WITH(NOLOCK)
											WHERE  LM.[FACTORY_ID]  = T.[TO_AREAID]
											AND    LM.[ACTIVE_FLAG] = 'Y'
											ORDER  BY LM.OPERATION_ID)
										END
									ELSE
										T.TO_PROCID 
									END             AS TO_OPERATION_ID
								,T.TO_EQSGID      -- 2017-12-18 kimcd 층 정보 넣기 위해 GROUP BY 추가
								,CONVERT(DATE,T.MOVE_STRT_DTTM)  AS MOVE_STRT_DATE -- 2019-09-27 kimcd 이동일 추가
								,SUM(T.MOVE_ORD_QTY2)  AS QTY
						FROM   [DBO].[SCM_MES_MOVE_H]  T WITH(NOLOCK, INDEX(IX01_SCM_MES_MOVE_H))
								,[DBO].[SCM_FACTORY_M]   TF WITH(NOLOCK)
								,[DBO].[SCM_ITEM_M]      I WITH(NOLOCK)
						WHERE  T.[TO_AREAID]     = TF.[FACTORY_ID]
						AND    TF.[COMPANY_ID]   = I.[COMPANY_ID]
						AND    TF.[DIVISION_ID]  = I.[DIVISION_ID]
						AND    T.[PRODID]        = I.[ITEM_ID]
						AND    I.[ITEM_TYPE]    IN  ('P','Q','H')
						AND    I.[ACTIVE_FLAG]   = 'Y'
						AND    I.[FLOW_ID]      IS NOT NULL
						AND    ( I.FLOW_ID    LIKE 'A%' OR I.FLOW_ID LIKE 'P%' ) -- 임시. 안정화 후 제거
						AND    T.[MOVE_TYPE_CODE] IN ( 'MOVE_SHOP', 'RETURN_SHOP' , 'MOVE_AREA', 'MOVE_LINE', 'MOVE_PROC') -- 2017-12-18 kimcd 층 정보 구분위해 'MOVE_LINE', 'MOVE_PROC' 이동 정보 추가
						AND    T.[MOVE_ORD_STAT_CODE] != 'CANCEL_MOVE'   -- 2018-01-16 kimcd 취소된 이동은 수량 합산에 제외
						AND    TF.[SITE_ID]      = @SITE_ID -- 2019-09-27 kimcd 내부 변수 사용
						AND    TF.PLANT_ID IN ( SELECT  W.SEGMENT1
												FROM   [DBO].[SCM_SYS_LOOKUP_VALUE] W  WITH(NOLOCK)
												WHERE  W.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
												AND    W.ACTIVE_FLAG = 'Y'
												AND    W.SEGMENT2 = @BASIS_START_TIME) -- 2019-09-27 kimcd PLANT 시업 시간 구분자 추가
						AND    I.[SITE_ID]       = @SITE_ID -- 2019-09-27 kimcd 내부 변수 사용
						AND    T.MOVE_STRT_DTTM >= (SELECT TOP 1 CONVERT ( DATETIME, CONVERT(NVARCHAR(10), S.[CUTOFF_DATE] ,120) + @START_TIME,	120)
													FROM   SCM_BASE_STOCK_H  S WITH(NOLOCK)
													WHERE  S.SITE_ID = @SITE_ID -- 2019-09-27 kimcd 내부 변수 사용
													-- AND    S.FACTORY_ID = T.TO_AREAID 2020-07-07 kimcd 동구분 없이 site 기준 재고 일 이후 조회
													ORDER  BY S.[CUTOFF_DATE] DESC)
						AND    T.MOVE_STRT_DTTM  < CONVERT ( DATETIME, CONVERT( NVARCHAR(10), @ACCUM_DATE, 120) + @START_TIME,	120)
						GROUP BY TF.COMPANY_ID
								,TF.DIVISION_ID
								,TF.SITE_ID
								,TF.PLANT_ID
								,T.TO_AREAID
								,T.PRODID
								,T.TO_PROCID
								,T.TO_EQSGID -- 2017-12-18 kimcd 층 정보 넣기 위해 GROUP BY 추가
								,CONVERT(DATE,T.MOVE_STRT_DTTM) -- 2019-09-27 kimcd 이동일 추가
								) T
						LEFT OUTER JOIN [DBO].[SCM_SYS_LOOKUP_VALUE] W WITH(NOLOCK)
						ON  W.LOOKUP_TYPE_CODE = 'WIP_OPERATION_STOCK_MAP'
						AND W.SEGMENT1 = T.TO_OPERATION_ID
						AND W.SEGMENT3 = CASE WHEN T.TO_OPERATION_ID = 'A4000' THEN 'OUT' ELSE 'IN' END -- 2018-01-16 kimcd washing 공정의 경우 A3000 유지되도록 예외 처리
						AND W.ACTIVE_FLAG = 'Y'
						) A
		-- 2017-12-18 kimcd 층 정보 넣기 위해 GROUP BY 추가
		GROUP BY A.TO_COMPANY_ID
				,A.TO_DIVISION_ID
				,A.TO_SITE_ID
				,A.TO_PLANT_ID
				,A.TO_FACTORY_ID
				,A.ITEM_ID
				,A.OPERATION_ID
				,A.MOVE_STRT_DATE -- 2019-09-27 kimcd 이동일 추가
				,A.LOCATION -- 2017-12-18 kimcd 층 정보 추가

		-- 이동 실적 취합 
		SET @v_temp1 = 'GET MOVE CONSUME'
		INSERT INTO @TEMP_TABLE
		-- 2017-12-18 kimcd 층 정보 넣기 위해 GROUP BY로 조회 문장 한번더 감쌈.
		SELECT  A.FROM_COMPANY_ID
			   ,A.FROM_DIVISION_ID
			   ,A.FROM_SITE_ID
			   ,A.FROM_PLANT_ID
			   ,A.FROM_FACTORY_ID
			   ,A.ITEM_ID
			   ,A.OPERATION_ID
			   ,A.MOVE_STRT_DATE -- 2019-09-27 kimcd 이동일 추가
			   ,SUM(A.RESULT_QTY)
			   ,SUM(A.CONSUME_QTY)
			   ,'MOVE_FROM'
			   ,A.LOCATION -- 2017-12-18 kimcd 층 정보 추가
		FROM   ( SELECT T.FROM_COMPANY_ID
					   ,T.FROM_DIVISION_ID
					   ,T.FROM_SITE_ID
					   ,T.FROM_PLANT_ID
					   ,T.FROM_FACTORY_ID
					   ,T.ITEM_ID
						, CASE WHEN SEGMENT4  IN ( 'PRE', 'STATUS') THEN
								CASE WHEN T.[FROM_FACTORY_ID] = 'E4' AND T.FROM_OPERATION_ID = 'E3000' THEN
									'E2500'
								ELSE
									ISNULL((SELECT TOP 1 F.OPERATION_ID				 
											FROM 	 DBO.SCM_ITEM_M       I WITH(NOLOCK)
													,SCM_OPERATION_FLOW_M F WITH(NOLOCK)
											WHERE  I.COMPANY_ID   = T.FROM_COMPANY_ID
											AND    I.DIVISION_ID  = T.FROM_DIVISION_ID
											AND    I.SITE_ID      = T.FROM_SITE_ID
											AND    I.ITEM_ID      = T.ITEM_ID
											AND    F.COMPANY_ID   = I.COMPANY_ID
											AND    F.DIVISION_ID  = I.DIVISION_ID
											AND    F.SITE_ID      = I.SITE_ID
											AND    F.FLOW_ID      = I.FLOW_ID
											AND    F.OPERATION_ID != 'A6000' --임시. 안정화 후 제거
											AND    F.OPERATION_ID < T.FROM_OPERATION_ID
											ORDER  BY F.OPERATION_SEQ DESC) , T.FROM_OPERATION_ID)
								END
							ELSE                  
								ISNULL( SEGMENT4, T.FROM_OPERATION_ID)  -- 2017-12-14 kimcd lookup 기본 값 적용
							END AS OPERATION_ID
					   ,T.MOVE_STRT_DATE -- 2019-09-27 kimcd 이동일 추가
					   , 0          AS RESULT_QTY
					   , -T.QTY     AS CONSUME_QTY
					   ,ISNULL((SELECT TOP 1 L.LOCATION
								FROM   SCM_EQUIPMENT_M L WITH(NOLOCK)
								WHERE  L.OPERATION_ID = T.FROM_OPERATION_ID
								AND    L.MES_LINE_ID  = T.FROM_EQSGID
								AND    L.PLANT_ID     = T.FROM_PLANT_ID
								AND    L.EQUIPMENT_TYPE = 'M'
								AND    L.ACTIVE_FLAG  = 'Y'
								ORDER  BY L.EQUIPMENT_ID ),'-') AS LOCATION -- 2017-12-18 kimcd 층 정보 추가
				FROM   ( SELECT  T.PRODID         AS ITEM_ID
								,TF.COMPANY_ID    AS FROM_COMPANY_ID
								,TF.DIVISION_ID   AS FROM_DIVISION_ID
								,TF.SITE_ID       AS FROM_SITE_ID
								,TF.PLANT_ID      AS FROM_PLANT_ID
								,T.FROM_AREAID    AS FROM_FACTORY_ID
								,CASE WHEN T.FROM_PROCID IS NULL OR T.FROM_PROCID = '' THEN
										CASE WHEN MAX(TF.SHOP_GROUP_ID) = 'E' THEN
											'E7000'
										ELSE
											(SELECT TOP 1 LM.OPERATION_ID
											FROM   SCM_LINE_M LM WITH(NOLOCK)
											WHERE  LM.[FACTORY_ID]  = T.[FROM_AREAID]
											AND    LM.[ACTIVE_FLAG] = 'Y'
											ORDER  BY LM.OPERATION_ID DESC)
										END
									ELSE
										T.FROM_PROCID 
									END             AS FROM_OPERATION_ID
								,T.FROM_EQSGID      -- 2017-12-18 kimcd 층 정보 넣기 위해 GROUP BY 추가
								,CONVERT(DATE,T.MOVE_STRT_DTTM)  AS MOVE_STRT_DATE -- 2019-09-27 kimcd 이동일 추가1
								,SUM(T.MOVE_ORD_QTY2)  AS QTY
						FROM   [DBO].[SCM_MES_MOVE_H]  T WITH(NOLOCK, INDEX(IX01_SCM_MES_MOVE_H))
								,[DBO].[SCM_FACTORY_M]   TF WITH(NOLOCK)
								,[DBO].[SCM_ITEM_M]      I WITH(NOLOCK)
						WHERE  T.[FROM_AREAID]   = TF.[FACTORY_ID]
						AND    TF.[COMPANY_ID]   = I.[COMPANY_ID]
						AND    TF.[DIVISION_ID]  = I.[DIVISION_ID]
						AND    T.[PRODID]        = I.[ITEM_ID]
						AND    I.[ITEM_TYPE]    IN  ('P','Q','H')
						AND    I.[ACTIVE_FLAG]   = 'Y'
						AND    I.[FLOW_ID]      IS NOT NULL
						AND    ( I.FLOW_ID    LIKE 'A%' OR I.FLOW_ID LIKE 'P%' ) -- 임시. 안정화 후 제거
						AND    T.[MOVE_TYPE_CODE] IN ( 'MOVE_SHOP', 'RETURN_SHOP' , 'MOVE_AREA', 'MOVE_LINE', 'MOVE_PROC') -- 2017-12-18 kimcd 층 정보 구분위해 'MOVE_LINE', 'MOVE_PROC' 이동 정보 추가
						AND    T.[MOVE_ORD_STAT_CODE] != 'CANCEL_MOVE'   -- 2018-01-16 kimcd 취소된 이동은 수량 합산에 제외
						AND    TF.[SITE_ID]      = @SITE_ID -- 2019-09-27 kimcd 내부 변수 사용
						AND    TF.PLANT_ID IN ( SELECT W.SEGMENT1
												FROM   [DBO].[SCM_SYS_LOOKUP_VALUE] W  WITH(NOLOCK)
												WHERE  W.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
												AND    W.ACTIVE_FLAG = 'Y'
												AND    W.SEGMENT2 = @BASIS_START_TIME) -- 2019-09-27 kimcd PLANT 시업 시간 구분자 추가
						AND    I.[SITE_ID]       = @SITE_ID -- 2019-09-27 kimcd 내부 변수 사용
						AND    T.MOVE_STRT_DTTM >= (SELECT TOP 1 CONVERT ( DATETIME, CONVERT(NVARCHAR(10), S.[CUTOFF_DATE] ,120) + @START_TIME,	120)
													FROM   SCM_BASE_STOCK_H  S WITH(NOLOCK)
													WHERE  S.SITE_ID = @SITE_ID -- 2019-09-27 kimcd 내부 변수 사용
													-- AND    S.FACTORY_ID = T.FROM_AREAID 2020-07-07 kimcd 동구분 없이 site 기준 재고 일 이후 조회
													ORDER  BY S.[CUTOFF_DATE] DESC)
						AND    T.MOVE_STRT_DTTM  < CONVERT ( DATETIME, CONVERT( NVARCHAR(10), @ACCUM_DATE, 120) + @START_TIME,	120)
						GROUP BY TF.COMPANY_ID
								,TF.DIVISION_ID
								,TF.SITE_ID
								,TF.PLANT_ID
								,T.FROM_AREAID
								,T.PRODID
								,T.FROM_PROCID
								,T.FROM_EQSGID      -- 2017-12-18 kimcd 층 정보 넣기 위해 GROUP BY 추가
								,CONVERT(DATE,T.MOVE_STRT_DTTM) -- 2019-09-27 kimcd 이동일 추가
								) T
						LEFT OUTER JOIN [DBO].[SCM_SYS_LOOKUP_VALUE] W WITH(NOLOCK)
						ON  W.LOOKUP_TYPE_CODE = 'WIP_OPERATION_STOCK_MAP'
						AND W.SEGMENT1 = T.FROM_OPERATION_ID
						AND W.SEGMENT3 = CASE WHEN T.FROM_OPERATION_ID = 'A4000' THEN 'OUT' ELSE 'IN' END -- 2018-01-16 kimcd washing 공정의 경우 A3000 유지되도록 예외 처리
						AND W.ACTIVE_FLAG = 'Y'
						) A
		-- 2017-12-18 kimcd 층 정보 넣기 위해 GROUP BY로 조회 문장 한번더 감쌈.
		GROUP BY A.FROM_COMPANY_ID
				,A.FROM_DIVISION_ID
				,A.FROM_SITE_ID
				,A.FROM_PLANT_ID
				,A.FROM_FACTORY_ID
				,A.ITEM_ID
				,A.OPERATION_ID
				,A.MOVE_STRT_DATE -- 2019-09-27 kimcd 이동일 추가
				,A.LOCATION -- 2017-12-18 kimcd 층 정보 추가

		-- 2018-01-16 kimcd VD 추가 시작 - 재고 층간 이동 감안을 위해
		INSERT INTO @TEMP_TABLE
		SELECT  A.COMPANY_ID
				,A.DIVISION_ID
				,A.SITE_ID
				,A.PLANT_ID
				,A.FACTORY_ID
				,A.ITEM_ID
				,A.OPERATION_ID
				,A.PLAN_DATE  -- 2019-09-27 kimcd 이동일 추가
				,A.RESULT_QTY
				,A.CONSUME_QTY
				,'VD_MOVE_TO'
				,A.LOCATION -- 2017-12-18 kimcd location 정보 추가
			FROM (SELECT W.COMPANY_ID
						,W.DIVISION_ID
						,W.SITE_ID
						,W.PLANT_ID
						,W.FACTORY_ID
						,W.ITEM_ID
						,'A5000'                  AS OPERATION_ID
						,W.PLAN_DATE   -- 2019-09-27 kimcd 이동일 추가
						,SUM(W.ACTUAL_GOOD_QTY)   AS RESULT_QTY
						,0                        AS CONSUME_QTY
						,ISNULL(W.LOCATION,'-')   AS LOCATION -- 2017-12-18 kimcd 층 정보 추가
				  FROM  [DBO].[SCM_ITEM_M]                 I WITH(NOLOCK)
					   ,[DBO].[SCM_DAILY_PRODUCT_RESULT_H] W WITH(NOLOCK)
				  WHERE W.PLAN_DATE >= (SELECT TOP 1 S.[CUTOFF_DATE]
										FROM   SCM_BASE_STOCK_H  S WITH(NOLOCK)
										WHERE  S.SITE_ID    = W.SITE_ID
										AND    S.FACTORY_ID = W.FACTORY_ID
										ORDER  BY S.[CUTOFF_DATE] DESC )
				  AND I.ITEM_TYPE    IN ('P','H')
				  AND I.ACTIVE_FLAG   = 'Y'
				  AND I.ITEM_ID       = W.ITEM_ID
				  AND I.DIVISION_ID   = W.DIVISION_ID
				  AND I.SITE_ID       = W.SITE_ID
				  AND I.COMPANY_ID    = W.COMPANY_ID
				  AND I.SITE_ID       = @SITE_ID
				  AND I.FLOW_ID    LIKE 'A%'  -- 임시. 안정화 후 제거
				  AND W.SITE_ID       = @SITE_ID
				  AND W.PLANT_ID IN   ( SELECT W.SEGMENT1
										FROM   [DBO].[SCM_SYS_LOOKUP_VALUE] W  WITH(NOLOCK)
										WHERE  W.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
										AND    W.ACTIVE_FLAG = 'Y'
										AND    W.SEGMENT2 = @BASIS_START_TIME) -- 2019-09-27 kimcd PLANT 시업 시간 구분자 추가
				  AND W.OPERATION_ID = 'A6000'
				  AND ( SELECT L.SEGMENT2
						FROM   SCM_SYS_LOOKUP_VALUE L WITH(NOLOCK)
						WHERE  L.LOOKUP_TYPE_CODE = 'WIP_LOCATION'
						AND    L.ACTIVE_FLAG      = 'Y'
						AND    L.SEGMENT1         = W.PLANT_ID ) = 'Y'
				  GROUP BY   W.COMPANY_ID
							,W.DIVISION_ID
							,W.SITE_ID
							,W.PLANT_ID
							,W.FACTORY_ID
							,ISNULL(W.LOCATION,'-')
							,W.ITEM_ID
							,W.PLAN_DATE -- 2019-09-27 kimcd 이동일 추가
							,W.OPERATION_ID ) A
			   , SCM_OPERATION_M  SOM WITH(NOLOCK)
			WHERE SOM.COMPANY_ID   = A.COMPANY_ID
			AND   SOM.DIVISION_ID  = A.DIVISION_ID
			AND   SOM.SITE_ID      = A.SITE_ID
			AND   SOM.OPERATION_ID = A.OPERATION_ID

		INSERT INTO @TEMP_TABLE
		SELECT  A.COMPANY_ID
				,A.DIVISION_ID
				,A.SITE_ID
				,A.PLANT_ID
				,A.FACTORY_ID
				,A.ITEM_ID
				,A.OPERATION_ID
				,A.PLAN_DATE -- 2019-09-27 kimcd 이동일 추가
				,A.RESULT_QTY
				,A.CONSUME_QTY
				,'VD_MOVE_FROM'
				,A.LOCATION -- 2017-12-18 kimcd location 정보 추가
			FROM (SELECT W.COMPANY_ID
						,W.DIVISION_ID
						,W.SITE_ID
						,W.PLANT_ID
						,W.FACTORY_ID
						,W.ITEM_ID
						,'A5000'                  AS OPERATION_ID
						,W.PLAN_DATE    -- 2019-09-27 kimcd 이동일 추가
						,0                        AS RESULT_QTY
						,- SUM(W.ACTUAL_QTY)      AS CONSUME_QTY
						,ISNULL((SELECT TOP 1 L.LOCATION
								 FROM   SCM_EQUIPMENT_M L WITH(NOLOCK)
								 WHERE  L.OPERATION_ID = W.OPERATION_ID
								 AND    L.MES_LINE_ID  = W.LINE_ID
								 AND    L.PLANT_ID     = W.PLANT_ID
								 AND    L.EQUIPMENT_TYPE = 'M'
								 AND    L.ACTIVE_FLAG  = 'Y'
								 ORDER  BY L.EQUIPMENT_ID ),'-')   AS LOCATION
				  FROM  [DBO].[SCM_ITEM_M]                 I WITH(NOLOCK)
					   ,[DBO].[SCM_DAILY_PRODUCT_RESULT_H] W WITH(NOLOCK)
				  WHERE W.PLAN_DATE >= (SELECT TOP 1 S.[CUTOFF_DATE]
										FROM   SCM_BASE_STOCK_H  S WITH(NOLOCK)
										WHERE  S.SITE_ID    = W.SITE_ID
										AND    S.FACTORY_ID = W.FACTORY_ID
										ORDER  BY S.[CUTOFF_DATE] DESC )
				  AND I.ITEM_TYPE    IN ('P','H')
				  AND I.ACTIVE_FLAG   = 'Y'
				  AND I.ITEM_ID       = W.ITEM_ID
				  AND I.DIVISION_ID   = W.DIVISION_ID
				  AND I.SITE_ID       = W.SITE_ID
				  AND I.COMPANY_ID    = W.COMPANY_ID
				  AND I.SITE_ID       = @SITE_ID
				  AND I.FLOW_ID    LIKE 'A%'  -- 임시. 안정화 후 제거
				  AND W.SITE_ID       = @SITE_ID
				  AND W.PLANT_ID IN   ( SELECT W.SEGMENT1
										FROM   [DBO].[SCM_SYS_LOOKUP_VALUE] W  WITH(NOLOCK)
										WHERE  W.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
										AND    W.ACTIVE_FLAG = 'Y'
										AND    W.SEGMENT2 = @BASIS_START_TIME) -- 2019-09-27 kimcd PLANT 시업 시간 구분자 추가
				  AND W.OPERATION_ID = 'A6000'
				  AND ( SELECT TOP 1 L.SEGMENT2
						FROM   SCM_SYS_LOOKUP_VALUE L WITH(NOLOCK)
						WHERE  L.LOOKUP_TYPE_CODE = 'WIP_LOCATION'
						AND    L.ACTIVE_FLAG      = 'Y'
						AND    L.SEGMENT1         = W.PLANT_ID ) = 'Y'
				  GROUP BY   W.COMPANY_ID
							,W.DIVISION_ID
							,W.SITE_ID
							,W.PLANT_ID
							,W.FACTORY_ID
							,W.LINE_ID
							,W.ITEM_ID
							,W.OPERATION_ID
							,W.PLAN_DATE ) A   -- 2019-09-27 kimcd 이동일 추가
			   , SCM_OPERATION_M  SOM WITH(NOLOCK)
			WHERE SOM.COMPANY_ID   = A.COMPANY_ID
			AND   SOM.DIVISION_ID  = A.DIVISION_ID
			AND   SOM.SITE_ID      = A.SITE_ID
			AND   SOM.OPERATION_ID = A.OPERATION_ID

		-- LOCATION 정리 - A5000 공정에 대해서 일괄 갱신
		UPDATE T
		SET    T.LOCATION = ISNULL ( (SELECT TOP 1 SL.LOCATION
									  FROM   SCM_LINE_M               SL  WITH(NOLOCK)
											,SCM_ITEM_LINE_ASSIGN_M   SIL WITH(NOLOCK)
									  WHERE  SL.COMPANY_ID     = SIL.COMPANY_ID
									  AND    SL.DIVISION_ID    = SIL.DIVISION_ID
									  AND    SL.SITE_ID        = SIL.SITE_ID
									  AND    SL.PLANT_ID       = SIL.PLANT_ID
									  AND    SL.FACTORY_ID     = SIL.FACTORY_ID
									  AND    SL.LINE_ID        = SIL.LINE_ID
									  AND    SL.OPERATION_ID   = SIL.OPERATION_ID
									  AND    SL.ELECTRODE_TYPE = SIL.ELECTRODE_TYPE
									  AND    SL.ACTIVE_FLAG    = 'Y'
									  AND    SIL.COMPANY_ID    = T.COMPANY_ID
									  AND    SIL.DIVISION_ID   = T.DIVISION_ID
									  AND    SIL.SITE_ID       = T.SITE_ID
									  AND    SIL.PLANT_ID      = T.PLANT_ID
									  AND    SIL.FACTORY_ID    = T.FACTORY_ID
									  AND    SIL.OPERATION_ID  = T.OPERATION_ID
									  AND    SIL.ITEM_ID       = T.ITEM_ID
									  AND    SIL.MONTH         = CONVERT(NVARCHAR(6), GETDATE(), 112)
									  ORDER BY SIL.PRIORITY ), T.LOCATION)
		FROM   @TEMP_TABLE          T
		      ,SCM_SYS_LOOKUP_VALUE L WITH(NOLOCK)
		WHERE  L.LOOKUP_TYPE_CODE = 'WIP_LOCATION'
		AND    L.ACTIVE_FLAG      = 'Y'
		AND    L.SEGMENT1         = T.PLANT_ID
		AND    T.OPERATION_ID     = 'A5000'
		AND    L.SEGMENT2		  = 'Y'
		-- 2018-01-16 kimcd VD 추가 끝 - 재고 층간 이동 감안을 위해

		DECLARE @HARD_CODE_STORAGE_ID NVARCHAR(1000) 
		SET @HARD_CODE_STORAGE_ID  = (SELECT TOP 1 SEGMENT2 FROM SCM_CODE_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE='PR_SCM_THEORY_WIP' AND SEGMENT1  = '0' AND ACTIVE_FLAG = 'Y')

		SET @v_temp1 = 'CLEAR CAL QTY'
		UPDATE A 
		SET [CAL_QTY] = 0
		FROM [dbo].[SCM_STOCK_H] A
		WHERE CUTOFF_DATE = @ACCUM_DATE
		AND STORAGE_ID in (SELECT SEGMENT2 FROM SCM_CODE_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE='PR_SCM_THEORY_WIP' AND SEGMENT1  = '0' AND ACTIVE_FLAG = 'Y')
		AND SITE_ID    = @SITE_ID
		AND PLANT_ID IN   ( SELECT W.SEGMENT1
							FROM   [DBO].[SCM_SYS_LOOKUP_VALUE] W  WITH(NOLOCK)
							WHERE  W.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
							AND    W.ACTIVE_FLAG = 'Y'
							AND    W.SEGMENT2 = @BASIS_START_TIME) -- 2019-09-27 kimcd PLANT 시업 시간 구분자 추가
		AND UPDATE_ID  = 'PR_XIF_MES_WIP_R'
		AND   ( FP_APPLY_OPERATION_ID LIKE 'A%' OR FP_APPLY_OPERATION_ID LIKE 'P%' ) -- 임시. 안정화 후 제거
		AND    EXISTS ( SELECT 1
						FROM   SCM_ITEM_M I WITH(NOLOCK)
						WHERE  I.ITEM_TYPE  IN ('P','H')
						AND    I.ACTIVE_FLAG = 'Y'
						AND    I.ITEM_ID     = A.FP_APPLY_ITEM_ID
						AND    I.DIVISION_ID = A.DIVISION_ID
						AND    I.SITE_ID     = A.SITE_ID
						AND    I.COMPANY_ID  = A.COMPANY_ID
						AND    ( I.FLOW_ID  LIKE 'A%' OR I.FLOW_ID LIKE 'P%' )
						)   -- 임시. 안정화 후 제거

		SET @v_temp1 = 'GET MAX SEQ'
		SELECT @I_CNT = ISNULL(MAX(SEQ), 0)
		FROM   [DBO].[SCM_STOCK_H]
		WHERE  CUTOFF_DATE = @ACCUM_DATE
		AND    SITE_ID     = @SITE_ID ;

		SET @v_temp1 = 'GET INSERT ID'
		SELECT @INSERT_ID = MAX(INSERT_ID)
		FROM   [DBO].[SCM_STOCK_H]
		WHERE  CUTOFF_DATE = @ACCUM_DATE
		AND STORAGE_ID in (SELECT SEGMENT2 FROM SCM_CODE_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE='PR_SCM_THEORY_WIP' AND SEGMENT1  = '0' AND ACTIVE_FLAG = 'Y')
		AND SITE_ID    = @SITE_ID
		AND UPDATE_ID  = 'PR_XIF_MES_WIP_R'
		AND PLANT_ID IN   ( SELECT W.SEGMENT1
							FROM   [DBO].[SCM_SYS_LOOKUP_VALUE] W  WITH(NOLOCK)
							WHERE  W.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
							AND    W.ACTIVE_FLAG = 'Y'
							AND    W.SEGMENT2 = @BASIS_START_TIME) -- 2019-09-27 kimcd PLANT 시업 시간 구분자 추가


		MERGE INTO [dbo].[SCM_STOCK_H] A
		USING (	SELECT COMPANY_ID
					  ,DIVISION_ID
					  ,SITE_ID
				      ,PLANT_ID
					  ,FACTORY_ID
					  ,OPERATION_ID
					  ,ITEM_ID
					  ,@HARD_CODE_STORAGE_ID AS STORAGE_ID
					  ,'WIP' AS STOCK_TYPE
					  ,SUM(RESULT_QTY) AS RESULT_QTY
					  ,@I_CNT + ROW_NUMBER() OVER ( ORDER BY A.OPERATION_ID, A.ITEM_ID ) AS NEW_SEQ
					  ,(SELECT TOP 1  H.SEQ
					    FROM   SCM_STOCK_H  H WITH(NOLOCK)
						WHERE  H.STORAGE_ID   in (SELECT SEGMENT2 FROM SCM_CODE_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE='PR_SCM_THEORY_WIP' AND SEGMENT1  = '0' AND ACTIVE_FLAG = 'Y')
						AND    H.CUTOFF_DATE  = @ACCUM_DATE
            			AND    H.STOCK_TYPE   = 'WIP'
						AND    H.COMPANY_ID   = A.COMPANY_ID
						AND    H.DIVISION_ID  = A.DIVISION_ID
						AND    H.SITE_ID      = A.SITE_ID
						AND    H.PLANT_ID     = A.PLANT_ID
						AND    H.FACTORY_ID   = A.FACTORY_ID
						AND    H.FP_APPLY_OPERATION_ID = A.OPERATION_ID
						AND    H.FP_APPLY_ITEM_ID      = A.ITEM_ID
						AND    ISNULL(H.WIPHOLD_YN,'N') != 'Y'
						AND    ISNULL(H.LOCATION,'-') = CASE WHEN A.LOCATION = '^' THEN ISNULL(H.LOCATION,'-') ELSE A.LOCATION END -- 2017-12-18 kimcd LOCATION 조건 추가
						ORDER  BY H.SEQ )  AS OLD_SEQ
					  ,(SELECT TOP 1 SIM.ITEM_UOM
					    FROM   DBO.SCM_ITEM_M SIM WITH(NOLOCK)
						WHERE  SIM.COMPANY_ID   = A.COMPANY_ID
						AND    SIM.DIVISION_ID  = A.DIVISION_ID
						AND    SIM.SITE_ID      = A.SITE_ID
						AND    SIM.ITEM_ID      = A.ITEM_ID) AS ITEM_UOM
					  ,LOCATION -- 2017-12-18 kimcd LOCATION 구분 추가
				FROM  ( SELECT COMPANY_ID
							  ,DIVISION_ID
							  ,SITE_ID
							  ,T.PLANT_ID
							  ,FACTORY_ID
							  ,OPERATION_ID
							  ,ITEM_ID
							  ,RESULT_QTY
							  ,CASE WHEN SEGMENT2 = 'Y' THEN T.LOCATION ELSE '^' END LOCATION -- 2017-12-18 kimcd  LOCATION 연결
						FROM   @TEMP_TABLE T
							   LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE L WITH(NOLOCK)
							   ON L.LOOKUP_TYPE_CODE = 'WIP_LOCATION'
							   AND L.ACTIVE_FLAG = 'Y'
							   AND L.SEGMENT1    = T.PLANT_ID -- 2017-12-18 kimcd  LOCATION 구분 여부 LOOKUP 연결
						WHERE  RESULT_QTY > 0
						UNION ALL
						SELECT COMPANY_ID
							  ,DIVISION_ID
							  ,SITE_ID
							  ,T.PLANT_ID
							  ,FACTORY_ID
							  ,OPERATION_ID
							  ,ITEM_ID
							  ,CONSUME_QTY
							  ,CASE WHEN SEGMENT2 = 'Y' THEN T.LOCATION ELSE '^' END LOCATION -- 2017-12-18 kimcd  LOCATION 연결
						FROM   @TEMP_TABLE T
							   LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE L WITH(NOLOCK)
							   ON L.LOOKUP_TYPE_CODE = 'WIP_LOCATION'
							   AND L.ACTIVE_FLAG = 'Y'
							   AND L.SEGMENT1    = T.PLANT_ID -- 2017-12-18 kimcd  LOCATION 구분 여부 LOOKUP 연결
						WHERE  CONSUME_QTY < 0 ) A
				GROUP BY COMPANY_ID
						,DIVISION_ID
						,SITE_ID
						,PLANT_ID
						,FACTORY_ID
						,OPERATION_ID
						,ITEM_ID
						,LOCATION -- 2017-12-18 kimcd LOCATION 구분 추가
						) B
		ON ( A.COMPANY_ID     = B.COMPANY_ID
			AND A.DIVISION_ID = B.DIVISION_ID
			AND A.SITE_ID     = B.SITE_ID
			AND A.PLANT_ID    = B.PLANT_ID
			AND A.FACTORY_ID  = B.FACTORY_ID
			AND A.STORAGE_ID  = B.STORAGE_ID
			AND A.CUTOFF_DATE = @ACCUM_DATE
			AND A.SEQ         = B.OLD_SEQ
			)
		WHEN MATCHED THEN
			UPDATE SET A.CAL_QTY	 = B.RESULT_QTY
				      ,A.UPDATE_TIME = GETDATE()
		WHEN NOT MATCHED THEN
			INSERT ( [COMPANY_ID]
					,[DIVISION_ID]
					,[SITE_ID]
					,[PLANT_ID]
					,[FACTORY_ID]
					,[STORAGE_ID]
					,[CUTOFF_DATE]
					,[SEQ]
					,[STOCK_TYPE]
					,[ITEM_ID]
					,[PRODUCTION_TYPE]
					,[AVAILABLE_DATE]
					,[REMAIN_LEAD_TIME]
					,[HOLDING_DATE]
					,[QTY]
					,[QTY_UOM]
					,[QTY2]
					,[STOCK_STATUS]
					,[OPERATION_ID]
					,[LANE]
					,[LINE_ID]
					,[OUTSOURCING_FLAG]
					,[OUTSOURCING_FACTORY]
					,[DESCRIPTION]
					,[FP_APPLY_OPERATION_ID]
					,[FP_APPLY_ITEM_ID]
					,[FP_APPLY_WIPQTY]
					,[CAL_QTY]
					,[WIPHOLD_YN]
					,[WIP_TYPE_CODE]
					,[INSERT_ID]
					,[INSERT_TIME]
					,[UPDATE_ID]
					,[UPDATE_TIME]
					,[LOCATION] -- 2017-12-18 kimcd  LOCATION 추가
					)
			VALUES ( B.[COMPANY_ID]
					,B.[DIVISION_ID]
					,B.[SITE_ID]
					,B.[PLANT_ID]
					,B.[FACTORY_ID]
					,B.[STORAGE_ID]
					,@ACCUM_DATE       -- [CUTOFF_DATE]
					,B.[NEW_SEQ]       -- [SEQ]
					,B.[STOCK_TYPE]
					,B.[ITEM_ID]
					,NULL              -- [PRODUCTION_TYPE]
					,'1999-01-01 00:00:00' -- [AVAILABLE_DATE]
					,0                 -- [REMAIN_LEAD_TIME]
					,'1999-01-01 00:00:00' -- [HOLDING_DATE]
					,0                     -- [QTY]
					,B.[ITEM_UOM]          -- [QTY_UOM]
					,0                     -- [QTY2]
					,'WAIT'                -- [STOCK_STATUS]
					,B.[OPERATION_ID]
					,NULL                  -- [LANE]
					,'-'                   -- [LINE_ID]
					,'-'                   -- [OUTSOURCING_FLAG]
					,NULL                  -- [OUTSOURCING_FACTORY]
					,NULL                  -- [DESCRIPTION]
					,B.[OPERATION_ID]      -- [FP_APPLY_OPERATION_ID]
					,B.[ITEM_ID]           -- [FP_APPLY_ITEM_ID]
					,0                     -- [FP_APPLY_WIPQTY]
					,B.[RESULT_QTY]        -- [CAL_QTY]
					,'N'                   -- [WIPHOLD]
					,'IN'                  -- [WIP_TYPE_CODE]
					,@INSERT_ID
					,GETDATE()
					,'PR_XIF_MES_WIP_R' -- 재고 정리 로직 유지를 위해 update id는 stock 수신 procedure 명을 사용
					,GETDATE()
					,CASE WHEN B.LOCATION = '^' THEN NULL ELSE B.LOCATION END  -- 2017-12-18 kimcd  LOCATION 추가
					);

		-------------------------------
		-- 임시. 안정화 후 제거
		DELETE [dbo].[ZFP_THEORY_WIP_TEMP]
		WHERE SITE_ID = @SITE_ID
		AND PLANT_ID IN  (  SELECT W.SEGMENT1
							FROM   [DBO].[SCM_SYS_LOOKUP_VALUE] W  WITH(NOLOCK)
							WHERE  W.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
							AND    W.ACTIVE_FLAG = 'Y'
							AND    W.SEGMENT2 = @BASIS_START_TIME) -- 2019-09-27 kimcd PLANT 시업 시간 구분자 추가


		INSERT INTO [dbo].[ZFP_THEORY_WIP_TEMP]
		SELECT * FROM  @TEMP_TABLE
		-------------------------------
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
		SELECT @v_descr
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate

	END CATCH

END
