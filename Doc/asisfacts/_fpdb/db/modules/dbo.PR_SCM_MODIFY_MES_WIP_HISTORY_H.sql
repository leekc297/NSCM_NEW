
CREATE PROCEDURE [dbo].[PR_SCM_MODIFY_MES_WIP_HISTORY_H]

-- ================================================================================================
-- Program ID          : 
-- Program Name        : PR_SCM_MODIFY_MES_WIP_HISTORY_H
-- Param               :
-- Batch Period        : 1DAY
-- Description         :
--
-- Source System       : FP SDB
-- Destination System  : FP SDB
-- Source Table        : SCM_MES_WIP_HISTORY_H
-- Destination Table   : SCM_MES_WIP_HISTORY_H
--
-- Create Date		   : 2017.12.20
-- Update Date		   : 2018.03.08
--						 2018.03.26 1.6 PIYONG
--                       2018.04.02 1.7 kimcd
--                       2018.04.09 1.8 kimcd
--                       2018.04.21 1.9 kimcd
--						 2018.10.16 1.10 PIYONG
--						 2018.11.14 2.3  PIYONG
--						 2018-11-21 3.0	 PIYONG
--						 2018-12-07 3.1  PIYONG
--                       2018-12-18 3.2  kimcd
--                       2019-04-04 3.21 kimcd
--						 2019-07-09 3.3  PIYONG
--						 2019-07-15 3.4  PIYONG
--						 2019-08-02 3.41 PIYONG
--						 2019-08-29 3.5  PIYONG
--						 2019-09-09 3.6  PIYONG
--						 2020-02-24 3.7  PIYONG
--						 2020-06-30 3.8  kimcd
--                       2020-07-21 3.9  kimcd

-- Author              : PIYONG
-- Version             : 1.0
--                       1.1 2018-01-10 kimcd YIELD_LOSS_QTY 컬럼 추가
--                       1.2 2018-01-23 kimcd 일자별 실적 계산 추가
--                       1.3 2018-02-01 kimcd LOCATION 컬럼 KEY에서 제거
--                       1.4 2018-02-23 kimcd 일별 실적에 equipment id 추가
--                       1.5 2018-03-08 kimcd 남경 재작업 실적을 기존 라인의 수량에 포함.
--						 1.6 2018-03-26 PIYONG SCM_DAILY_PRODUCT_RESULT_H 남경 재작업 생산(C Product)의 경우 적용 MODEL를 찾아서 TOP_ITEM_ID 에 넣음
--                       1.7 2018-04-02 kimcd wip_type_code가 PROD인 경우 WIPQTY_ED, WIPQTY2_ED, WIPQTY2_ENGINE 3개 컬럼의 값을 0으로 치환
--                       1.8 2018-04-09 kimcd fp production type 컬럼 추가 - FP 전용 생산 유형
--                       1.9 2018-04-21 kimcd coating 공정에 환산 실적 갱신
--                       2.0 2018-08-26 kimcd 소형 특성 실적 수신 과정 수정. UPDATE_ID는 기존 작업명 유지하도록 수정
--                       2.1 2018-09-06 PIYONG 조립 공정 Cell 기준 수량 추가
--						 2.2 2018-11-16 PIYONG 	 E8동이 없어지면서 관련 로직 제거
--						 2.3 2018-11-14 PIYONG 최기주수선님 요청으로 Coating 공정에 환산 실적 갱신 로직을 MAX-> MIN으로 변경 (엔진에서 MIN으로 적용)
--						 3.0 2018-11-21 Coating 공정에 환산 실적 갱신 로직 변경
--										 MIN(VALUE) -> MODEL_ID, PROD_VERSION_TYPE 포함하여 PROD_VER_TYPE 우선순으로 찾음  없으면 값이 작은 값 우선 순위 
--						 3.1 2018-12-07 Coating 공정에 환산 실적 갱신 로직 변경
--										 우선 순위 변경
--                       3.2 2-18-12-18 kimcd 당일 실적 제외
--                       3.21 2019-04-04 kimcd 양면 품목의 단면 코팅 실적 형성 J/R
--						 3.3 2019-07-09 데이터 생성 JOIN  테이블 변경 SCM_EQUIPMENT_M -> SCM_LINE_M
--						 3.4  2019-07-15 PIYONG SCM_EQUIPMENT_M, SCM_LINE_M  조인시 컬럼 추가, 정렬
--						 3.41 2019-08-02 PIYONG TOP_COATING_QTY2 컬럼 조건 추가
--												MES UI 구조 문제로 단면 제품인데도 TOP COATING 수량이 존재하여 조건 추가
--						 3.5 일별  환산 실적 전극 후공정(E3000, E4000) 추가
--						 3.6  SCM_DAILY_PRODUCT_RESULT_H 삭제 로직 수정
--						 3.7 오창 소형 활성화 생성 제외
--                       3.8 2020-06-30 kimcd 환산자 적용 우선 순위를 FP Instance, Plant별로 관리함. 해당 정보 기반으로 환산자 적용.
--                       3.9 2020-07-21 kimcd 조립 Cell 환산에서 Primary, 대치 구분자 추가
--                       2024-03-15 chkim.68 하드코딩 전환 (ref scm_code_lookup_value )
-- ================================================================================================

AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_SCM_MODIFY_MES_WIP_HISTORY_H'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	   = 0
	DECLARE @sysdate     DATETIME2     = GETDATE()
	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)

	DECLARE @CONV_TABLE TABLE (
			 FACTORY_ID         NVARCHAR(30),
			 PROD_VERSION_TYPE  NVARCHAR(30),
			 PRODUCTION_TYPE    NVARCHAR(30),
			 VERSION_TYPE       NVARCHAR(30),
             IDX                NUMERIC(10) )  -- 2020-06-30 kimcd 환산자 정렬용 임시 Table

	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

	BEGIN TRY
	    -- 2018-01-23 kimcd 일자별 실적 계산 추가 시작
	    set @v_temp1 = 'step merge daily result'
		MERGE SCM_DAILY_PRODUCT_RESULT_H A
		USING ( 
				SELECT COMPANY_ID
						,DIVISION_ID
						,SITE_ID
						,PLANT_ID
						,FACTORY_ID
						,ISNULL(TOP_ITEM_ID, ITEM_ID) AS TOP_ITEM_ID
						,ITEM_ID
						,OPERATION_ID
						,MIN(LOCATION) AS LOCATION -- 2018-02-01 kimcd LOCATION 컬럼 KEY에서 제거
						,MAX(PRODUCTION_TYPE) AS PRODUCTION_TYPE -- 2018-04-09 kimcd FP 내부 관리용 수요 유형 추가에 따라 Group by에서 제거
						,FP_PRODUCTION_TYPE     -- 2018-04-09 kimcd FP 내부 관리용 수요 유형 추가에 따라 Group by에서 추가
						,MARKET
						,LINE_ID
						,ELECTRODE_TYPE
						,EQUIPMENT_ID  -- 2018-02-23 kimcd 설비 추가
						,PLAN_DATE
						,ISNULL( SUM(ISNULL(WIPQTY2_ENGINE,0))																				-- PIYONG 2017-11-29
									+ SUM(ISNULL(CONVERT(NUMERIC(14,3), CNFM_DFCT_QTY2),0)) 
									+ SUM(ISNULL(CONVERT(NUMERIC(14,3), CNFM_LOSS_QTY2),0)) 
									+ SUM(ISNULL(CONVERT(NUMERIC(14,3), CNFM_PRDT_REQ_QTY2),0))
									+ SUM(ISNULL(CAST(SCRAP_QTY AS NUMERIC(14,3)),0))
								,0)																	               		AS ACTUAL_QTY
						, ISNULL(SUM(WIPQTY2_ENGINE),0)                                             					AS ACTUAL_GOOD_QTY	-- PIYONG 2017-11-29
						, ISNULL(ISNULL(SUM(CONVERT(NUMERIC(14,3), CNFM_DFCT_QTY2)) ,0)
									+ ISNULL(SUM(CONVERT(NUMERIC(14,3), CNFM_LOSS_QTY2)) ,0)
									+ ISNULL(SUM(CONVERT(NUMERIC(14,3), CNFM_PRDT_REQ_QTY2)) ,0)
									+ ISNULL(SUM(CAST(SCRAP_QTY AS NUMERIC(14,3))) ,0) ,0)								AS ACTUAL_SCRAP_QTY				
						,'PR_XIF_MES_DAILY_WIP_HISTORY_R' AS INSERT_ID  -- 2018-12-18 kimcd 변경자 일별 실적 Procedure로 hard coding
						,GETDATE() AS INSERT_TIME
						,'PR_XIF_MES_DAILY_WIP_HISTORY_R' AS UPDATE_ID  -- 2018-12-18 kimcd 변경자 일별 실적 Procedure로 hard coding
						,GETDATE() AS UPDATE_TIME
						-- 2018-01-23 kimcd 수량 상세 정보 추가 시작
						,SUM(ISNULL([WIPQTY_ED],0))             AS QTY
						,SUM(ISNULL([WIPQTY2_ED],0))            AS QTY_LANE
						,SUM(ISNULL([CNFM_DFCT_QTY2],0))        AS DFCT_QTY2
						,SUM(ISNULL([CNFM_LOSS_QTY2],0))        AS LOSS_QTY2
						,SUM(ISNULL([CNFM_PRDT_REQ_QTY2],0))    AS PRDT_REQ_QTY2
						,SUM(ISNULL([TOP_COATING_QTY2],0))      AS TOP_COATING_QTY2
						,SUM(ISNULL([YIELD_LOSS_QTY],0))        AS YIELD_LOSS_QTY
						-- 2018-01-23 kimcd 수량 상세 정보 추가 끝
				  FROM ( SELECT ISNULL(L.COMPANY_ID, C.COMPANY_ID)  AS  COMPANY_ID
								,ISNULL(L.DIVISION_ID, C.DIVISION_ID)  AS DIVISION_ID
								,ISNULL(L.SITE_ID, C.SITE_ID) AS SITE_ID
								,ISNULL(L.PLANT_ID, C.PLANT_ID) AS PLANT_ID
								,ISNULL(L.FACTORY_ID, C.FACTORY_ID) AS FACTORY_ID
								--	2018-03-26 PIYONG 남경 재작업 생산(C Product)의 경우 적용 MODEL를 찾아서 넣음.
								,CASE WHEN U.ATTRIBUTE5 IS NOT NULL THEN 
										( SELECT TOP 1 APPLIED_MODEL FROM SCM_ITEM_M WHERE COMPANY_ID = ISNULL(L.COMPANY_ID, C.COMPANY_ID)  AND SITE_ID = ISNULL(L.SITE_ID, C.SITE_ID) AND DIVISION_ID = ISNULL(L.DIVISION_ID, C.DIVISION_ID) AND ITEM_ID = U.PRODID)
									  ELSE
										U.TOP_ITEM_ID
									  END                   AS TOP_ITEM_ID
								,PRODID AS ITEM_ID
								,PROCID AS OPERATION_ID
								,ISNULL(L.LINE_ID ,ISNULL(( SELECT TOP 1 LM.LINE_ID
															  FROM SCM_LINE_M LM
																	,SCM_EQUIPMENT_M EM
															-----------------------------------------------------------------------------
															--	2019-07-15 PIYONG  JOIN 컬럼 ADD
															 WHERE LM.COMPANY_ID = EM.COMPANY_ID
															   AND LM.DIVISION_ID = EM.DIVISION_ID
															   AND LM.SITE_ID = EM.SITE_ID
															   AND LM.PLANT_ID = EM.PLANT_ID
															   AND LM.FACTORY_ID = EM.FACTORY_ID
															   AND LM.OPERATION_ID = EM.OPERATION_ID
															--	2019-07-15 PIYONG  JOIN 컬럼 ADD
															-----------------------------------------------------------------------------
															   AND LM.LINE_ID = EM.LINE_ID
															   AND EM.MES_LINE_ID = U.EQSGID
															   AND EM.OPERATION_ID = U.PROCID
															   AND (CASE WHEN U.PROCID IN ( 'E1000','E2000','E2300','E2500','E3000','E8000','E4000', 'A5000' ,'A6000' ) THEN 
																			CASE  SUBSTRING( U.PRODID, 4,1) WHEN 'A' THEN 'ANODE'
																											WHEN 'C' THEN 'CATHODE'
																											ELSE '-' END
																		 WHEN U.PROCID IN ('A7000', 'E3800', 'E3900') THEN 
																			CASE  SUBSTRING( U.PRODID, 4,1) WHEN 'A' THEN 'A'
																											WHEN 'C' THEN 'C'
																											ELSE '-' END
																		 WHEN U.PROCID = 'E2100' THEN
																			CASE WHEN SUBSTRING(U.EQSGID,1,2) IN ('E1', 'E4') THEN 
																					CASE  SUBSTRING( U.PRODID, 4,1) WHEN 'A' THEN 'Anode'
																													WHEN 'C' THEN 'Cathode'
																													ELSE '-' END
																				 ELSE
																					CASE  SUBSTRING( U.PRODID, 4,1) WHEN 'A' THEN 'A'
																													WHEN 'C' THEN 'C'
																													ELSE '-' END
																				 END
												
																		 ELSE '-' END) = lm.ELECTRODE_TYPE 
															), U.EQSGID)																				) AS  LINE_ID
								,CAL_WIPDTTM_ED AS PLAN_DATE
								,ISNULL(U.PRODUCTION_TYPE, 'MASS') AS PRODUCTION_TYPE
								,ISNULL(U.FP_PRODUCTION_TYPE, 'MASS') AS FP_PRODUCTION_TYPE  -- 2018-04-09 kimcd FP 내부 수요 유형 관리용 컬럼 추가
								,ISNULL(L.ELECTRODE_TYPE, '-') AS ELECTRODE_TYPE	          
								,WIPQTY_ED         -- 2018-01-23 kimcd 창고 재고 보관 기준으로 표현된  수량
								,WIPQTY2_ED        -- 2018-01-23 kimcd Item UOM 기준으로 표현된 수량
								,WIPQTY2_ENGINE
								,CNFM_DFCT_QTY2
								,CNFM_LOSS_QTY2
								,CNFM_PRDT_REQ_QTY2
								,SCRAP_QTY
								,YIELD_LOSS_QTY    -- 2018-01-23 kimcd 투입 수량 표시하기 위해 YILED에 포하되어야 하는 LOSS 수량 컬럼 추가
								,TOP_COATING_QTY2  -- 2018-01-23 kimcd top coding 수량 추가
								,ISNULL(MARKET, 'E') AS MARKET
								,ISNULL(L.LOCATION, ISNULL(C.LOCATION, '-')) AS LOCATION  -- 2018-01-01 kimcd 층 정보 추출에 Operation, Line 기준 추가
								,CASE WHEN U.PROCID LIKE 'E%' OR U.PROCID LIKE 'S%' THEN ISNULL(U.EQPTID,'-') ELSE '-' END AS EQUIPMENT_ID -- 2018-02-23 kimcd 설비 정보 추가
						   FROM (
									SELECT CAST( CONVERT( VARCHAR,CAST(CALDATE AS DATETIME),112) AS DATETIME ) AS CAL_WIPDTTM_ED
										,PRODID
										,CASE WHEN W.ATTRIBUTE5 IS NOT NULL THEN
											ISNULL(W.ATTRIBUTE3, W.EQSGID)
											ELSE
											W.EQSGID
											END                   AS EQSGID -- 2018-03-08 kimcd 남경 재작업 생산(C Product)의 경우 인계 라인을 찾아서 넣음.
										,CASE WHEN W.ATTRIBUTE5 IS NOT NULL THEN
											W.ATTRIBUTE5
											ELSE
											W.PROCID
											END                   AS PROCID -- 2018-03-08 kimcd 남경 재작업 생산(C Product)의 경우 인계 라인의 공정을 찾아서 넣음.
										,CASE WHEN W.ATTRIBUTE5 IS NOT NULL THEN 
											ISNULL(W.ATTRIBUTE4,W.EQPTID)
											ELSE
											W.EQPTID
											END                   AS EQPTID -- 2018-03-08 kimcd 남경 재작업 생산(C Product)의 경우 인계 설비를 찾아서 넣음.
										-- 2018-04-02 kimcd wip_type_code가 PROD인 경우 WIPQTY_ED, WIPQTY2_ED, WIPQTY2_ENGINE 3개 컬럼의 값을 0으로 치환 시작
										,CASE WHEN W.WIP_TYPE_CODE = 'PROD' THEN 0 ELSE W.WIPQTY_ED END       AS WIPQTY_ED
										,CASE WHEN W.WIP_TYPE_CODE = 'PROD' THEN 0 ELSE W.WIPQTY2_ED END      AS WIPQTY2_ED
										,CASE WHEN W.WIP_TYPE_CODE = 'PROD' THEN 0 ELSE W.WIPQTY2_ENGINE END  AS WIPQTY2_ENGINE
										-- 2018-04-02 kimcd wip_type_code가 PROD인 경우 WIPQTY_ED, WIPQTY2_ED, WIPQTY2_ENGINE 3개 컬럼의 값을 0으로 치환 시작
										,COATING_SIDE_TYPE_CODE
										,CNFM_DFCT_QTY2
										,CNFM_LOSS_QTY2
										,CNFM_PRDT_REQ_QTY2
										,SCRAP_QTY
										,W.YIELD_LOSS_QTY                 -- 2018-01-23 kimcd 투입 수량 표시하기 위해 YILED에 포하되어야 하는 LOSS 수량 컬럼 추가
										,CASE WHEN COATING_SIDE_TYPE_CODE = 'T' AND SUBSTRING (PRODID, 4 ,2 ) != 'CS' THEN WIPQTY2_ED ELSE 0 END TOP_COATING_QTY2  -- 2018-01-23 kimcd top coding 수량 추가	--2019-08-02 PIYONG  AND SUBSTRING (PRODID, 4 ,2 )  != 'CS' ADD 
										,W.PRODUCTION_TYPE
										,ISNULL(W.ATTRIBUTE6,W.PRODUCTION_TYPE) AS FP_PRODUCTION_TYPE -- 2018-04-09 kimcd FP_PRODUCTION_TYPE. FP 내부용 수요 유형 추가
                                        ,(SELECT TOP 1 A.DIVISION_ID
											FROM [DBO].[FP_PRODUCTION_PLAN_R] A with(nolock)
											WHERE A.WORK_ORDER_ID = W.WOID
												AND A.PRODUCTION_TYPE IS NOT NULL
												ORDER BY FP_PLAN_ID DESC  ) DIVISION_CODE
										,W.MARKET
										,W.TOP_ITEM_ID
										,W.ATTRIBUTE5																  --2018-03-26 PIYONG APPLIED_MODEL 값을 찾기 위해 추가, DIVISION_ID를 조회문 밖에서 구해야 함
									FROM [dbo].[SCM_MES_WIP_HISTORY_H] W -- 2018-01-06 kimcd with(nolock) 제거                                                                                                                
									WHERE cast( WIPDTTM_ED as datetime) >= CAST(DATEADD(DD, -45, GETDATE()) AS DATE)  -- 2018-01-01 kimcd 실적 수정하는 경우 발생하여 목요일 기준으로 전주까지 범위 확대
									AND W.WIP_TYPE_CODE IN ( 'INOUT','OUT' ,'PACKED', 'PROD')
									AND (W.FORMATION_REWORK_TYPE <> 'Y' OR W.FORMATION_REWORK_TYPE IS NULL)
									AND ( PROCID != 'F6000'															-- 2018-01-17 PIYONG 활성화 공정 제외
									--		OR ( PROCID = 'F6000' AND W.ATTRIBUTE2 IN ('M1', 'M2')  )				-- 2018-08-26 KIMCD ADD		--2020-02-24 piyong DEL
										)
									-- AND W.ATTRIBUTE1 = @SITE_ID
								) U
						   LEFT OUTER JOIN [DBO].[SCM_EQUIPMENT_M] L WITH(NOLOCK)
										-----------------------------------------------------------------------------
										--	2019-07-15 PIYONG  JOIN 컬럼순서 변경및 기준 테이블 컬럼을 왼쪽으로 이동
										ON L.DIVISION_ID =  ISNULL(U.DIVISION_CODE, L.DIVISION_ID )
										-- 2018-11-16 PIYONG 	 E8동이 없어지면서 관련 로직 제거
										--AND (CASE WHEN U.DIVISION_CODE = '81' AND U.EQSGID = 'E7D01' THEN 'E8' WHEN ( SELECT TOP 1 SUBSTRING(A.ITEM_NAME,1,1) FROM SCM_ITEM_M A WHERE A.ITEM_ID = U.PRODID ) IN ( 'A', 'E') AND U.EQSGID = 'E7D01' THEN 'E8' WHEN  ( SELECT DISTINCT SUBSTRING(A.ITEM_NAME,1,1) FROM SCM_ITEM_M A WHERE A.ITEM_ID = U.PRODID ) = 'M'  AND U.EQSGID = 'E7D01' THEN 'E7' ELSE SUBSTRING(U.EQSGID,1,2) END )  =  L.FACTORY_ID
										AND L.FACTORY_ID = SUBSTRING(U.EQSGID,1,2)
										AND L.MES_LINE_ID = U.EQSGID
										-- 2018-11-16 PIYONG 	 E8동이 없어지면서 관련 로직 제거
										--AND L.DIVISION_ID =  ISNULL(U.DIVISION_CODE, (CASE WHEN ( SELECT TOP 1 SUBSTRING(A.ITEM_NAME,1,1) FROM SCM_ITEM_M A WHERE A.ITEM_ID = U.PRODID ) IN ('A','E') AND U.EQSGID = 'E7D01' THEN '81' WHEN  ( SELECT DISTINCT SUBSTRING(A.ITEM_NAME,1,1) FROM SCM_ITEM_M A WHERE A.ITEM_ID = U.PRODID ) = 'M'  AND U.EQSGID = 'E7D01' THEN '40' ELSE L.DIVISION_ID END ))
										AND L.OPERATION_ID = U.PROCID  -- 하나의 설비가 여러 공정에 속할 수 있다고 함.
										AND L.EQUIPMENT_ID = U.EQPTID
										--	2019-07-15 PIYONG  JOIN 컬럼순서 변경및 기준 테이블 컬럼을 왼쪽으로 이동
										-----------------------------------------------------------------------------
							LEFT OUTER JOIN (
												SELECT A.COMPANY_ID
													   ,A.DIVISION_ID
													   ,A.SITE_ID
													   ,A.PLANT_ID
													   ,A.FACTORY_ID
													   ,A.OPERATION_ID
												--	   ,A.MES_LINE_ID			-- 2019-07-09 PIYONG DEL
													   ,A.LINE_ID				--MAX( A.LINE_ID ) AS LINE_ID	-- 2019-07-09 PIYONG DEL MAX 삭제
													   ,MAX( A.LOCATION ) AS LOCATION		-- 2018-01-01 kimcd 층 정보 추가
												  FROM [DBO].SCM_LINE_M A WITH(NOLOCK)		-- 2019-07-09 PIYONG CHANGE SCM_EQUIPMENT_M -> SCM_LINE_M
												/*
													-- 2019-07-09 PIYONG DEL SCM_EQUIPMENT_M에서 SCM_LINE_M 변경하면서 필요 없어짐
												   WHERE A.EQUIPMENT_TYPE = 'M'	-- 2018-01-01 kimcd 조건 추가
												   AND A.ACTIVE_FLAG    = 'Y'   -- 2018-01-01 kimcd 조건 추가
												*/
												 GROUP BY A.COMPANY_ID
														, A.DIVISION_ID
														, A.SITE_ID
														, A.PLANT_ID
														, A.FACTORY_ID
														, A.OPERATION_ID
														, A.LINE_ID			-- 2019-07-09 PIYONG CHANGE MES_LINE_ID -> LINE_ID
											) C
										-----------------------------------------------------------------------------
										--	2019-07-15 PIYONG  JOIN 컬럼순서 변경및 기준 테이블 컬럼을 왼쪽으로 이동
										 ON C.DIVISION_ID =  ISNULL(U.DIVISION_CODE, C.DIVISION_ID )
 										AND C.FACTORY_ID =  SUBSTRING(U.EQSGID,1,2)
										AND C.OPERATION_ID = U.PROCID
										-- 2018-11-16 PIYONG 	 E8동이 없어지면서 관련 로직 제거
										--AND C.DIVISION_ID =  ISNULL(U.DIVISION_CODE, (CASE WHEN ( SELECT TOP 1 SUBSTRING(A.ITEM_NAME,1,1) FROM SCM_ITEM_M A WHERE A.ITEM_ID = U.PRODID ) IN ( 'A','E') AND U.EQSGID = 'E7D01' THEN '81' WHEN  ( SELECT DISTINCT SUBSTRING(A.ITEM_NAME,1,1) FROM SCM_ITEM_M A WHERE A.ITEM_ID = U.PRODID ) = 'M'  AND U.EQSGID = 'E7D01' THEN '40' ELSE C.DIVISION_ID END ))
										AND C.LINE_ID = U.EQSGID			-- 2019-07-09 PIYONG CHANGE MES_LINE_ID -> LINE_ID
										--	2019-07-15 PIYONG  JOIN 컬럼순서 변경및 기준 테이블 컬럼을 왼쪽으로 이동
										-----------------------------------------------------------------------------
							WHERE U.cal_wipdttm_ed IS NOT NULL
							AND U.cal_wipdttm_ed >= CAST(DATEADD(DD, -42, GETDATE()) AS DATE) -- 2018-01-01 kimcd 실적 수정하는 경우 발생하여 목요일 기준으로 42일 전 까지 범위 확대
							AND ISNULL(L.COMPANY_ID, C.COMPANY_ID) IS NOT NULL
							AND U.cal_wipdttm_ed < CAST(DATEADD(DD, -0, GETDATE()) AS DATE) -- 2018-12-18 kimcd 당일 실적 제외
						) A
				  GROUP BY COMPANY_ID
						,DIVISION_ID
						,SITE_ID
						,PLANT_ID
						,FACTORY_ID
						,ISNULL(TOP_ITEM_ID, ITEM_ID)
						,ITEM_ID
						,OPERATION_ID
						-- ,LOCATION   -- 2018-02-01 kimcd LOCATION 컬럼 KEY에서 제거
						,FP_PRODUCTION_TYPE -- 2018-04-09 kimcd FP 내부 관리용 수요 유형 추가하여 Group by에 추가. PRODUCTION_TYPE에서 FP_PRODUCTION_TYPE으로 변경
						,MARKET
						,LINE_ID
						,ELECTRODE_TYPE
						,EQUIPMENT_ID -- 2018-02-23 kimcd 설비 정보 추가
						,PLAN_DATE
				) B
			ON ( A.[FACTORY_ID] = B.[FACTORY_ID]
				AND A.[LINE_ID] = B.[LINE_ID]
				AND A.[PLAN_DATE] = B.[PLAN_DATE]
				AND A.[OPERATION_ID] = B.[OPERATION_ID]
				AND A.[TOP_ITEM_ID] = B.[TOP_ITEM_ID]
				AND A.[ITEM_ID] = B.[ITEM_ID]
				-- AND A.[PRODUCTION_TYPE] = B.[PRODUCTION_TYPE] 2018-04-09 kimcd FP_PRODUCTION_TYPE 추가에 따른 조건 제거
				AND A.[FP_PRODUCTION_TYPE] = B.[FP_PRODUCTION_TYPE] -- 2018-04-09 kimcd FP_PRODUCTION_TYPE 추가에 따른 조건 추가
				-- AND A.[LOCATION] = B.[LOCATION]  -- 2018-02-01 kimcd LOCATION 컬럼 KEY에서 제거
				AND A.[MARKET] = B.[MARKET]
				AND A.[ELECTRODE_TYPE] = B.[ELECTRODE_TYPE]
				AND A.[EQUIPMENT_ID] = B.[EQUIPMENT_ID] -- 2018-02-23 kimcd 설비 조건 추가
				)
			WHEN MATCHED THEN
			UPDATE 
				SET A.[COMPANY_ID]		 = B.COMPANY_ID
					,A.[DIVISION_ID]		 = B.[DIVISION_ID]
					,A.[SITE_ID]			 = B.[SITE_ID]
					,A.[PLANT_ID]		 = B.[PLANT_ID]
					,A.[LOCATION]        = B.[LOCATION]   -- 2018-02-01 kimcd LOCATION 컬럼 KEY에서 제거
					,A.[ACTUAL_QTY]		 = B.[ACTUAL_QTY]
					,A.[ACTUAL_GOOD_QTY]	 = B.[ACTUAL_GOOD_QTY]
					,A.[ACTUAL_SCRAP_QTY] = B.[ACTUAL_SCRAP_QTY]
					-- ,A.[UPDATE_ID]		 = B.[UPDATE_ID] -- 2018-08-26 KIMCD UPDATE_ID 막음. 기존 변경자 유지
					,A.[UPDATE_TIME]		 = B.[UPDATE_TIME]
					-- 2018-01-23 kimcd 수량 상세 정보 추가 시작
					,A.[QTY]              = B.[QTY]
					,A.[QTY_LANE]         = B.[QTY_LANE]
					,A.[DFCT_QTY2]        = B.[DFCT_QTY2]
					,A.[LOSS_QTY2]        = B.[LOSS_QTY2]
					,A.[PRDT_REQ_QTY2]    = B.[PRDT_REQ_QTY2]
					,A.[TOP_COATING_QTY2] = B.[TOP_COATING_QTY2]
					,A.[YIELD_LOSS_QTY]   = B.[YIELD_LOSS_QTY]
					-- 2018-01-23 kimcd 수량 상세 정보 추가 끝
					,A.[PRODUCTION_TYPE]  = B.[PRODUCTION_TYPE]  -- 2018-04-09 kimcd FP_PRODUCTION_TYPE 추가에 따라 Production type 갱신 대상에 추가
			WHEN NOT MATCHED THEN
			INSERT (
				[COMPANY_ID]
				,[DIVISION_ID]
				,[SITE_ID]
				,[PLANT_ID]
				,[FACTORY_ID]
				,[TOP_ITEM_ID]
				,[ITEM_ID]
				,[OPERATION_ID]
				,[LOCATION]
				,[PRODUCTION_TYPE]
				,[MARKET]
				,[LINE_ID]
				,[ELECTRODE_TYPE]
				,[PLAN_DATE]
				,[ACTUAL_QTY]
				,[ACTUAL_GOOD_QTY]
				,[ACTUAL_SCRAP_QTY]
				,[INSERT_ID]
				,[INSERT_TIME]
				,[UPDATE_ID]
				,[UPDATE_TIME]
				-- 2018-01-23 kimcd 수량 상세 정보 추가 시작
				,[QTY]
				,[QTY_LANE]
				,[DFCT_QTY2]
				,[LOSS_QTY2]
				,[PRDT_REQ_QTY2]
				,[TOP_COATING_QTY2]
				,[YIELD_LOSS_QTY]
				-- 2018-01-23 kimcd 수량 상세 정보 추가 끝
				,[EQUIPMENT_ID] -- 2018-02-23 kimcd 설비 정보 추가
				,[FP_PRODUCTION_TYPE]  -- 2018-04-09 kimcd FP 내부 관리용 수요 유형 추가
			) VALUES (
				B.[COMPANY_ID]
				,B.[DIVISION_ID]
				,B.[SITE_ID]
				,B.[PLANT_ID]
				,B.[FACTORY_ID]
				,B.[TOP_ITEM_ID]
				,B.[ITEM_ID]
				,B.[OPERATION_ID]
				,B.[LOCATION]
				,B.[PRODUCTION_TYPE]
				,B.[MARKET]
				,B.[LINE_ID]
				,B.[ELECTRODE_TYPE]
				,B.[PLAN_DATE]
				,B.[ACTUAL_QTY]
				,B.[ACTUAL_GOOD_QTY]
				,B.[ACTUAL_SCRAP_QTY]
				,B.[INSERT_ID]
				,B.[INSERT_TIME]
				,B.[UPDATE_ID]
				,B.[UPDATE_TIME]
				-- 2018-01-23 kimcd 수량 상세 정보 추가 시작
				,B.[QTY]
				,B.[QTY_LANE]
				,B.[DFCT_QTY2]
				,B.[LOSS_QTY2]
				,B.[PRDT_REQ_QTY2]
				,B.[TOP_COATING_QTY2]
				,B.[YIELD_LOSS_QTY]
				-- 2018-01-23 kimcd 수량 상세 정보 추가 끝
				,B.[EQUIPMENT_ID] -- 2018-02-23 kimcd 설비 정보 추가
				,B.[FP_PRODUCTION_TYPE]  -- 2018-04-09 kimcd FP 내부 관리용 수요 유형 추가
			)
		;

		-- 일자별 실적 정리
		SET @v_temp1 = 'delete daily result'
		DELETE W
		FROM   SCM_DAILY_PRODUCT_RESULT_H W
		WHERE  ( W.OPERATION_ID  NOT IN ( 'F4000', 'F6000' )									--2018-01-17 PIYONG 활성화 공정 제외		--2019-09-09 PIYONG ADD
		--		 OR ( W.OPERATION_ID = 'F6000' AND W.PLANT_ID = 'A010'  )						--2018-08-26 KIMCD ADD		--2020-02-24 PIYONG DEL
				  OR ( W.OPERATION_ID = 'F4000') AND W.PLANT_ID in (SELECT SEGMENT2 FROM SCM_CODE_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE='PR_SCM_MODIFY_MES_WIP_HISTORY_H' AND SEGMENT1  = '0' AND ACTIVE_FLAG='Y')  						--2019-09-09 PIYONG ADD
				)
		-- AND    W.[SITE_ID]      = @SITE_ID
		AND    W.[PLAN_DATE]   >= CAST(DATEADD(DD, -42, GETDATE()) AS DATE)
		AND    W.[UPDATE_TIME]  < CONVERT(DATE, GETDATE()) -- 변경 대상 중에 오늘 변경 안 된 것 삭제
	    AND    W.INSERT_ID = 'PR_XIF_MES_DAILY_WIP_HISTORY_R'	-- 2018-12-18 kimcd 삭제에서 FCS 실적 취합된 정보 제외

	    -- 2018-01-23 kimcd 일자별 실적 계산 추가 끝

		-- 2020-06-30 kimcd 수요 유형별 우선 순위 설정 임시 Table 시작
		DELETE FROM @CONV_TABLE

		INSERT INTO @CONV_TABLE
		SELECT FACTORY_ID, PROD_VERSION_TYPE, PRODUCTION_TYPE, VERSION_TYPE
				,RANK() OVER (PARTITION BY FACTORY_ID, PROD_VERSION_TYPE, PRODUCTION_TYPE ORDER BY GUBUN) AS IDX
		FROM (	SELECT B.FACTORY_ID, B.PROD_VERSION_TYPE, SLV.SEGMENT3 AS PRODUCTION_TYPE, SLV.ATTRIBUTE1, SLV.ATTRIBUTE2, SLV.ATTRIBUTE3, SLV.ATTRIBUTE4, SLV.ATTRIBUTE5
				FROM   SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
						,(SELECT DISTINCT A.[INSTANCE_ID]
								,B.PLANT_ID
								,B.PROD_VERSION_TYPE
								,B.FACTORY_ID
						FROM   DBO.[FP_INSTANCE_FACTORY_M] A WITH(NOLOCK)     
								,DBO.SCM_LINE_M              B WITH(NOLOCK)
								,DBO.SCM_SYS_LOOKUP_VALUE    SLV WITH(NOLOCK)
						WHERE A.FACTORY_ID  = B.FACTORY_ID     
						AND A.ACTIVE_FLAG   = 'Y'     
						AND SLV.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
						AND SLV.SEGMENT1    = A.INSTANCE_ID
						AND SLV.ACTIVE_FLAG = 'Y'
						AND A.INSTANCE_TYPE = SLV.ATTRIBUTE9 -- E1 전극 전 공정
						AND A.INSTANCE_TYPE = 'E1'
						AND B.OPERATION_ID  = 'E2000'
						AND B.PROD_VERSION_TYPE IS NOT NULL
						) B
				WHERE  1=1
				AND	   SLV.LOOKUP_TYPE_CODE	= 'INSTANCE_CONV_PRIORITY'
				AND	   SLV.SEGMENT1			=  B.INSTANCE_ID
				AND    SLV.SEGMENT2         =  B.PLANT_ID
				AND    SLV.ACTIVE_FLAG		= 'Y'
				) A
		UNPIVOT(VERSION_TYPE FOR GUBUN IN (ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5)) AS X
		-- 2020-06-30 kimcd 수요 유형별 우선 순위 설정 임시 Table 끝

		-- 2018-04-21 kimcd Coating 공정에 환산 실적 갱신 시작
		UPDATE T
		SET   T.ROLL_IN_QTY   = CASE WHEN W.ITEM_UOM = 'EA' THEN W.ACTUAL_QTY / W.CELL_M ELSE W.ACTUAL_QTY END 
			, T.ROLL_OUT_QTY  = CASE WHEN W.ITEM_UOM = 'EA' THEN W.ACTUAL_GOOD_QTY / W.CELL_M ELSE W.ACTUAL_GOOD_QTY END 
			, T.JR_IN_QTY     = CASE WHEN W.ITEM_UOM = 'EA' THEN W.ACTUAL_QTY / W.CELL_M / W.LANE ELSE W.ACTUAL_QTY / W.LANE END 
			, T.JR_OUT_QTY    = CASE WHEN W.ITEM_UOM = 'EA' THEN W.ACTUAL_GOOD_QTY / W.CELL_M / W.LANE ELSE	W.ACTUAL_GOOD_QTY /W.LANE END
			, T.BATCH_IN_QTY  = CASE WHEN W.ITEM_UOM = 'EA' THEN W.ACTUAL_QTY / W.CELL_BATCH ELSE W.ACTUAL_QTY / W.M_BATCH END
			, T.BATCH_OUT_QTY = CASE WHEN W.ITEM_UOM = 'EA' THEN W.ACTUAL_QTY / W.CELL_BATCH ELSE W.ACTUAL_QTY / W.M_BATCH END
			, T.CELL_IN_QTY   = CASE WHEN W.ITEM_UOM = 'EA' THEN W.ACTUAL_QTY ELSE W.ACTUAL_QTY * W.CELL_M END
			, T.CELL_OUT_QTY  = CASE WHEN W.ITEM_UOM = 'EA' THEN W.ACTUAL_GOOD_QTY ELSE W.ACTUAL_GOOD_QTY * W.CELL_M END
			, T.TOP_JR_OUT_QTY = CASE WHEN W.ITEM_UOM = 'EA' THEN W.TOP_COATING_QTY2 / W.CELL_M / W.LANE ELSE	W.TOP_COATING_QTY2 /W.LANE END  -- 2019-04-04 kimcd 양면의 top coding 실적 전환
		FROM  SCM_DAILY_PRODUCT_RESULT_H  T WITH(NOLOCK)
			,(	SELECT   W.ITEM_ID
						,W.TOP_ITEM_ID
						,W.LINE_ID
						,W.PLAN_DATE
						,W.OPERATION_ID
						,W.FACTORY_ID
						,W.FP_PRODUCTION_TYPE
						,W.MARKET
						,W.EQUIPMENT_ID
						,W.ELECTRODE_TYPE
						,W.ACTUAL_QTY
						,W.ACTUAL_GOOD_QTY
						,CASE WHEN I.ITEM_CLASS = 'ES0303' THEN 0 ELSE W.TOP_COATING_QTY2 END AS TOP_COATING_QTY2  -- 2019-04-04 kimcd 양면의 top coding 실적 전환
						,I.ITEM_UOM
/*							--2018-11-21 PIYONG 주석처리
						,(  SELECT MIN(VALUE) AS LANE					-- 2018-11-14 PIYONG  MAX-> MIN
							FROM   SCM_ITEM_CONV_CALC_M C WITH(NOLOCK)
							WHERE  C.MAX_VER_FLAG = 'Y'
							AND    ISNULL(C.VALUE, 0) > 0
							AND    C.CATEGORY     = 'Lane Number'
							AND    C.COMPANY_ID   = W.COMPANY_ID
							AND    C.DIVISION_ID  = W.DIVISION_ID
							AND    C.SITE_ID      = W.SITE_ID
							AND    C.PLANT_ID     = W.PLANT_ID
							AND    C.FACTORY_ID   = W.FACTORY_ID
							AND    C.OPERATION    = W.OPERATION_ID
							AND    C.ITEM_ID      = W.ITEM_ID) AS LANE
						,CASE WHEN I.ITEM_UOM = 'M' THEN
							(   SELECT MIN(VALUE) AS M_BATCH					-- 2018-11-14 PIYONG  MAX-> MIN
								FROM   SCM_ITEM_CONV_CALC_M C WITH(NOLOCK)
								WHERE  C.MAX_VER_FLAG = 'Y'
								AND    ISNULL(C.VALUE, 0) > 0
								AND    C.CATEGORY    IN ('m/batch','Pancake (m/batch)')
								AND    C.COMPANY_ID   = W.COMPANY_ID
								AND    C.DIVISION_ID  = W.DIVISION_ID
								AND    C.SITE_ID      = W.SITE_ID
								AND    C.PLANT_ID     = W.PLANT_ID
								AND    C.FACTORY_ID   = W.FACTORY_ID
								AND    C.OPERATION    = W.OPERATION_ID
								AND    C.ITEM_ID      = W.ITEM_ID)
							END  AS M_BATCH
						,CASE WHEN I.ITEM_UOM = 'EA' THEN
							(   SELECT MIN(VALUE) AS CELL_BATCH					-- 2018-11-14 PIYONG  MAX-> MIN
								FROM   SCM_ITEM_CONV_CALC_M C WITH(NOLOCK)
								WHERE  C.MAX_VER_FLAG = 'Y'
								AND    ISNULL(C.VALUE, 0) > 0
								AND    C.CATEGORY     = 'cell/batch'
								AND    C.COMPANY_ID   = W.COMPANY_ID
								AND    C.DIVISION_ID  = W.DIVISION_ID
								AND    C.SITE_ID      = W.SITE_ID
								AND    C.PLANT_ID     = W.PLANT_ID
								AND    C.FACTORY_ID   = W.FACTORY_ID
								AND    C.OPERATION    = W.OPERATION_ID
								AND    C.ITEM_ID      = W.ITEM_ID)
							END  AS CELL_BATCH
						,(  SELECT MIN(VALUE) AS CELL_M					-- 2018-11-14 PIYONG  MAX-> MIN
							FROM   SCM_ITEM_CONV_CALC_M C WITH(NOLOCK)
							WHERE  C.MAX_VER_FLAG = 'Y'
							AND    ISNULL(C.VALUE, 0) > 0
							AND    C.CATEGORY     = 'Pancake (cell/m)'
							AND    C.COMPANY_ID   = W.COMPANY_ID
							AND    C.DIVISION_ID  = W.DIVISION_ID
							AND    C.SITE_ID      = W.SITE_ID
							AND    C.PLANT_ID     = W.PLANT_ID
							AND    C.FACTORY_ID   = W.FACTORY_ID
							AND    C.OPERATION    = W.OPERATION_ID
							AND    C.ITEM_ID      = W.ITEM_ID)  AS CELL_M
*/
						   -------------------------------------------------------------------------------------------------------------------------------------------------
						   --	2018-11-21 PIYONG CHANGE 시작
						   ,( ISNULL(
										(	
											SELECT TOP 1 VALUE AS LANE
											FROM   SCM_ITEM_CONV_CALC_M C WITH(NOLOCK)
												  ,@CONV_TABLE          CT -- 2020-06-30 kimcd 환산자 사용 우선 순위 적용
											WHERE  C.MAX_VER_FLAG = 'Y'
											AND    ISNULL(C.VALUE, 0) > 0
											AND    C.CATEGORY     = 'Lane Number'
											AND    C.COMPANY_ID   = W.COMPANY_ID
											AND    C.DIVISION_ID  = W.DIVISION_ID
											AND    C.SITE_ID      = W.SITE_ID
											AND    C.PLANT_ID     = W.PLANT_ID
											AND    C.FACTORY_ID   = W.FACTORY_ID
											AND    C.OPERATION    = 'E2000'
											AND    C.ITEM_ID      = W.ITEM_ID
										--	AND	   C.MODEL_ID	  = I.APPLIED_MODEL		--2018-12-07 PIYONG DEL
											AND	   C.PROD_VERSION_TYPE = L.PROD_VERSION_TYPE
											AND    W.FACTORY_ID        = CT.FACTORY_ID -- 2020-06-30 kimcd 환산자 사용 우선 순위 적용
											AND    L.PROD_VERSION_TYPE = CT.PROD_VERSION_TYPE -- 2020-06-30 kimcd 환산자 사용 우선 순위 적용
											AND    W.PRODUCTION_TYPE   = CT.PRODUCTION_TYPE -- 2020-06-30 kimcd 환산자 사용 우선 순위 적용
											ORDER BY CASE WHEN C.VERSION_TYPE = CT.VERSION_TYPE THEN IDX ELSE 999 END -- 2020-06-30 kimcd 환산자 사용 우선 순위 적용
													,C.APPLY_DATE DESC -- 2020-06-30 kimcd 적용일 우선 순위
													---------------------------------------------------------------------------------------------
													-- 2018-12-07 PIYONG ADD
													 ,(CASE WHEN C.MODEL_ID	  = I.APPLIED_MODEL THEN 1 ELSE 2 END)
													 ,C.MODEL_ID
													 ,( CASE WHEN C.VERSION  LIKE 'Z%' THEN REPLACE(C.VERSION, 'Z', '/') ELSE C.VERSION END ) DESC
													-- 2018-12-07 PIYONG ADD 끝
													---------------------------------------------------------------------------------------------
										)
										, (
											SELECT TOP 1 VALUE AS LANE
											FROM   SCM_ITEM_CONV_CALC_M C WITH(NOLOCK)
												  ,@CONV_TABLE          CT -- 2020-06-30 kimcd 환산자 사용 우선 순위 적용
											WHERE  C.MAX_VER_FLAG = 'Y'
											AND    ISNULL(C.VALUE, 0) > 0
											AND    C.CATEGORY     = 'Lane Number'
											AND    C.COMPANY_ID   = W.COMPANY_ID
											AND    C.DIVISION_ID  = W.DIVISION_ID
											AND    C.SITE_ID      = W.SITE_ID
											AND    C.PLANT_ID     = W.PLANT_ID
											AND    C.FACTORY_ID   = W.FACTORY_ID
											AND    C.OPERATION    = 'E2000'
											AND    C.ITEM_ID      = W.ITEM_ID
										--	AND	   C.PROD_VERSION_TYPE = L.PROD_VERSION_TYPE	-- 2019-08-29 PIYONG DEL
											AND    W.FACTORY_ID        = CT.FACTORY_ID -- 2020-06-30 kimcd 환산자 사용 우선 순위 적용
											AND    W.PRODUCTION_TYPE   = CT.PRODUCTION_TYPE -- 2020-06-30 kimcd 환산자 사용 우선 순위 적용
											ORDER BY CASE WHEN C.VERSION_TYPE = CT.VERSION_TYPE THEN IDX ELSE 999 END -- 2020-06-30 kimcd 환산자 사용 우선 순위 적용
													,C.APPLY_DATE DESC -- 2020-06-30 kimcd 적용일 우선 순위
													,VALUE
										)
									)
																			) AS LANE
						   ,CASE WHEN I.ITEM_UOM = 'M' THEN
									ISNULL(
											(
												SELECT TOP 1 VALUE AS M_BATCH
												FROM   SCM_ITEM_CONV_CALC_M C WITH(NOLOCK)
													  ,@CONV_TABLE          CT -- 2020-06-30 kimcd 환산자 사용 우선 순위 적용
												WHERE  C.MAX_VER_FLAG = 'Y'
												AND    ISNULL(C.VALUE, 0) > 0
												AND    C.CATEGORY     ='Pancake (m/batch)'
												AND    C.COMPANY_ID   = W.COMPANY_ID
												AND    C.DIVISION_ID  = W.DIVISION_ID
												AND    C.SITE_ID      = W.SITE_ID
												AND    C.PLANT_ID     = W.PLANT_ID
												AND    C.FACTORY_ID   = W.FACTORY_ID
												AND    C.OPERATION    = 'E2000'
												AND    C.ITEM_ID      = W.ITEM_ID
											--	AND	   C.MODEL_ID	  = I.APPLIED_MODEL		--2018-12-07 PIYONG DEL
												AND	   C.PROD_VERSION_TYPE = L.PROD_VERSION_TYPE
												AND    W.FACTORY_ID        = CT.FACTORY_ID -- 2020-06-30 kimcd 환산자 사용 우선 순위 적용
												AND    L.PROD_VERSION_TYPE = CT.PROD_VERSION_TYPE -- 2020-06-30 kimcd 환산자 사용 우선 순위 적용
												AND    W.PRODUCTION_TYPE   = CT.PRODUCTION_TYPE -- 2020-06-30 kimcd 환산자 사용 우선 순위 적용
												ORDER BY CASE WHEN C.VERSION_TYPE = CT.VERSION_TYPE THEN IDX ELSE 999 END -- 2020-06-30 kimcd 환산자 사용 우선 순위 적용
														,C.APPLY_DATE DESC -- 2020-06-30 kimcd 적용일 우선 순위
														---------------------------------------------------------------------------------------------
														-- 2018-12-07 PIYONG ADD
														 ,(CASE WHEN C.MODEL_ID	  = I.APPLIED_MODEL THEN 1 ELSE 2 END)
														 ,C.MODEL_ID
														 ,( CASE WHEN C.VERSION  LIKE 'Z%' THEN REPLACE(C.VERSION, 'Z', '/') ELSE C.VERSION END ) DESC
														-- 2018-12-07 PIYONG ADD 끝
														---------------------------------------------------------------------------------------------
											),
											( 
												SELECT TOP 1 VALUE AS M_BATCH
												FROM   SCM_ITEM_CONV_CALC_M C WITH(NOLOCK)
													  ,@CONV_TABLE          CT -- 2020-06-30 kimcd 환산자 사용 우선 순위 적용
												WHERE  C.MAX_VER_FLAG = 'Y'
												AND    ISNULL(C.VALUE, 0) > 0
												AND    C.CATEGORY     = 'Pancake (m/batch)'
												AND    C.COMPANY_ID   = W.COMPANY_ID
												AND    C.DIVISION_ID  = W.DIVISION_ID
												AND    C.SITE_ID      = W.SITE_ID
												AND    C.PLANT_ID     = W.PLANT_ID
												AND    C.FACTORY_ID   = W.FACTORY_ID
												AND    C.OPERATION    = 'E2000'
												AND    C.ITEM_ID      = W.ITEM_ID
											--	AND	   C.PROD_VERSION_TYPE = L.PROD_VERSION_TYPE	-- 2019-08-29 PIYONG DEL
												AND    W.FACTORY_ID        = CT.FACTORY_ID -- 2020-06-30 kimcd 환산자 사용 우선 순위 적용
												AND    W.PRODUCTION_TYPE   = CT.PRODUCTION_TYPE -- 2020-06-30 kimcd 환산자 사용 우선 순위 적용
												ORDER BY CASE WHEN C.VERSION_TYPE = CT.VERSION_TYPE THEN IDX ELSE 999 END -- 2020-06-30 kimcd 환산자 사용 우선 순위 적용
														,C.APPLY_DATE DESC -- 2020-06-30 kimcd 적용일 우선 순위
														,VALUE
											)
										)
								 END										AS M_BATCH
						   ,CASE WHEN I.ITEM_UOM = 'EA' THEN
									ISNULL ( (
												SELECT TOP 1 VALUE AS CELL_BATCH
												FROM   SCM_ITEM_CONV_CALC_M C WITH(NOLOCK)
													  ,@CONV_TABLE          CT -- 2020-06-30 kimcd 환산자 사용 우선 순위 적용
												WHERE  C.MAX_VER_FLAG = 'Y'
												AND    ISNULL(C.VALUE, 0) > 0
												AND    C.CATEGORY     = 'cell/batch'
												AND    C.COMPANY_ID   = W.COMPANY_ID
												AND    C.DIVISION_ID  = W.DIVISION_ID
												AND    C.SITE_ID      = W.SITE_ID
												AND    C.PLANT_ID     = W.PLANT_ID
												AND    C.FACTORY_ID   = W.FACTORY_ID
												AND    C.OPERATION    = 'E2000'
												AND    C.ITEM_ID      = W.ITEM_ID
											--	AND	   C.MODEL_ID	  = I.APPLIED_MODEL		--2018-12-07 PIYONG DEL
												AND	   C.PROD_VERSION_TYPE = L.PROD_VERSION_TYPE
												AND    W.FACTORY_ID        = CT.FACTORY_ID -- 2020-06-30 kimcd 환산자 사용 우선 순위 적용
												AND    L.PROD_VERSION_TYPE = CT.PROD_VERSION_TYPE -- 2020-06-30 kimcd 환산자 사용 우선 순위 적용
												AND    W.PRODUCTION_TYPE   = CT.PRODUCTION_TYPE -- 2020-06-30 kimcd 환산자 사용 우선 순위 적용
												ORDER BY CASE WHEN C.VERSION_TYPE = CT.VERSION_TYPE THEN IDX ELSE 999 END -- 2020-06-30 kimcd 환산자 사용 우선 순위 적용
														,C.APPLY_DATE DESC -- 2020-06-30 kimcd 적용일 우선 순위
														---------------------------------------------------------------------------------------------
														-- 2018-12-07 PIYONG ADD
														 ,(CASE WHEN C.MODEL_ID	  = I.APPLIED_MODEL THEN 1 ELSE 2 END)
														 ,C.MODEL_ID
														 ,( CASE WHEN C.VERSION  LIKE 'Z%' THEN REPLACE(C.VERSION, 'Z', '/') ELSE C.VERSION END ) DESC
														-- 2018-12-07 PIYONG ADD 끝
														---------------------------------------------------------------------------------------------
											),
											(
												SELECT TOP 1 VALUE AS CELL_BATCH
												FROM   SCM_ITEM_CONV_CALC_M C WITH(NOLOCK)
													  ,@CONV_TABLE          CT -- 2020-06-30 kimcd 환산자 사용 우선 순위 적용
												WHERE  C.MAX_VER_FLAG = 'Y'
												AND    ISNULL(C.VALUE, 0) > 0
												AND    C.CATEGORY     = 'cell/batch'
												AND    C.COMPANY_ID   = W.COMPANY_ID
												AND    C.DIVISION_ID  = W.DIVISION_ID
												AND    C.SITE_ID      = W.SITE_ID
												AND    C.PLANT_ID     = W.PLANT_ID
												AND    C.FACTORY_ID   = W.FACTORY_ID
												AND    C.OPERATION    = 'E2000'
												AND    C.ITEM_ID      = W.ITEM_ID
											--	AND	   C.PROD_VERSION_TYPE = L.PROD_VERSION_TYPE	-- 2019-08-29 PIYONG DEL
												AND    W.FACTORY_ID        = CT.FACTORY_ID -- 2020-06-30 kimcd 환산자 사용 우선 순위 적용
												AND    W.PRODUCTION_TYPE   = CT.PRODUCTION_TYPE -- 2020-06-30 kimcd 환산자 사용 우선 순위 적용
												ORDER BY CASE WHEN C.VERSION_TYPE = CT.VERSION_TYPE THEN IDX ELSE 999 END -- 2020-06-30 kimcd 환산자 사용 우선 순위 적용
														,C.APPLY_DATE DESC -- 2020-06-30 kimcd 적용일 우선 순위
														,VALUE
											) 
									)
								 END										AS CELL_BATCH
							,(
								ISNULL(
										(
											SELECT  TOP 1 VALUE AS CELL_M
											FROM   SCM_ITEM_CONV_CALC_M C WITH(NOLOCK)
												  ,@CONV_TABLE          CT -- 2020-06-30 kimcd 환산자 사용 우선 순위 적용
											WHERE  C.MAX_VER_FLAG = 'Y'
											AND    ISNULL(C.VALUE, 0) > 0
											AND    C.CATEGORY     = 'Pancake (cell/m)'
											AND    C.COMPANY_ID   = W.COMPANY_ID
											AND    C.DIVISION_ID  = W.DIVISION_ID
											AND    C.SITE_ID      = W.SITE_ID
											AND    C.PLANT_ID     = W.PLANT_ID
											AND    C.FACTORY_ID   = W.FACTORY_ID
											AND    C.OPERATION    = 'E2000'
											AND    C.ITEM_ID      = W.ITEM_ID
										--	AND	   C.MODEL_ID	  = I.APPLIED_MODEL		--2018-12-07 PIYONG DEL
											AND	   C.PROD_VERSION_TYPE = L.PROD_VERSION_TYPE
											AND    W.FACTORY_ID        = CT.FACTORY_ID -- 2020-06-30 kimcd 환산자 사용 우선 순위 적용
											AND    L.PROD_VERSION_TYPE = CT.PROD_VERSION_TYPE -- 2020-06-30 kimcd 환산자 사용 우선 순위 적용
											AND    W.PRODUCTION_TYPE   = CT.PRODUCTION_TYPE -- 2020-06-30 kimcd 환산자 사용 우선 순위 적용
											ORDER BY CASE WHEN C.VERSION_TYPE = CT.VERSION_TYPE THEN IDX ELSE 999 END -- 2020-06-30 kimcd 환산자 사용 우선 순위 적용
													,C.APPLY_DATE DESC -- 2020-06-30 kimcd 적용일 우선 순위
													---------------------------------------------------------------------------------------------
													-- 2018-12-07 PIYONG ADD
													 ,(CASE WHEN C.MODEL_ID	  = I.APPLIED_MODEL THEN 1 ELSE 2 END)
													 ,C.MODEL_ID
													 ,( CASE WHEN C.VERSION  LIKE 'Z%' THEN REPLACE(C.VERSION, 'Z', '/') ELSE C.VERSION END ) DESC
													-- 2018-12-07 PIYONG ADD 끝
													---------------------------------------------------------------------------------------------
										)
										, (
											SELECT TOP 1 VALUE AS CELL_M
											FROM   SCM_ITEM_CONV_CALC_M C WITH(NOLOCK)
												  ,@CONV_TABLE          CT -- 2020-06-30 kimcd 환산자 사용 우선 순위 적용
											WHERE  C.MAX_VER_FLAG = 'Y'
											AND    ISNULL(C.VALUE, 0) > 0
											AND    C.CATEGORY     = 'Pancake (cell/m)'
											AND    C.COMPANY_ID   = W.COMPANY_ID
											AND    C.DIVISION_ID  = W.DIVISION_ID
											AND    C.SITE_ID      = W.SITE_ID
											AND    C.PLANT_ID     = W.PLANT_ID
											AND    C.FACTORY_ID   = W.FACTORY_ID
											AND    C.OPERATION    = 'E2000'
											AND    C.ITEM_ID      = W.ITEM_ID
										--	AND	   C.PROD_VERSION_TYPE = L.PROD_VERSION_TYPE	-- 2019-08-29 PIYONG DEL
											AND    W.FACTORY_ID        = CT.FACTORY_ID -- 2020-06-30 kimcd 환산자 사용 우선 순위 적용
											AND    W.PRODUCTION_TYPE   = CT.PRODUCTION_TYPE -- 2020-06-30 kimcd 환산자 사용 우선 순위 적용
											ORDER BY CASE WHEN C.VERSION_TYPE = CT.VERSION_TYPE THEN IDX ELSE 999 END -- 2020-06-30 kimcd 환산자 사용 우선 순위 적용
													,C.APPLY_DATE DESC -- 2020-06-30 kimcd 적용일 우선 순위
													,VALUE
										) 
								)
						   )												AS CELL_M
						   --	2018-11-21 PIYONG CHANGE 끝
						   -------------------------------------------------------------------------------------------------------------------------------------------------
				FROM   SCM_ITEM_M                 I WITH(NOLOCK)
					  ,SCM_DAILY_PRODUCT_RESULT_H W WITH(NOLOCK)
					  ,SCM_LINE_M				  L WITH(NOLOCK)	--2018-11-21 PIYONG ADD
				WHERE  I.COMPANY_ID     = W.COMPANY_ID
				AND    I.DIVISION_ID    = W.DIVISION_ID
				AND    I.SITE_ID        = W.SITE_ID
				AND    I.ITEM_ID        = W.ITEM_ID
				-----------------------------------------------
				--2018-11-21 PIYONG ADD
				AND	   W.COMPANY_ID		= L.COMPANY_ID
				AND	   W.DIVISION_ID	= L.DIVISION_ID
				AND    W.SITE_ID		= L.SITE_ID
				AND    W.PLANT_ID		= L.PLANT_ID
				AND    W.FACTORY_ID		= L.FACTORY_ID
				AND    W.OPERATION_ID	= L.OPERATION_ID
				AND    W.LINE_ID		= L.LINE_ID
				AND    W.ELECTRODE_TYPE = L.ELECTRODE_TYPE
				AND    L.ACTIVE_FLAG = 'Y'
				--2018-11-21 PIYONG ADD END
				-----------------------------------------------
				AND    W.OPERATION_ID   IN  ( 'E2000', 'E3000', 'E4000' ) -- 2019-08-29 PIYONG  E3000, E4000도  포함
				AND    W.[PLAN_DATE]   >= CAST(DATEADD(DD, -42, GETDATE()) AS DATE) ) W
		WHERE T.ITEM_ID            = W.ITEM_ID
		AND   T.TOP_ITEM_ID        = W.TOP_ITEM_ID
		AND   T.LINE_ID            = W.LINE_ID
		AND   T.PLAN_DATE          = W.PLAN_DATE
		AND   T.OPERATION_ID       = W.OPERATION_ID
		AND   T.FACTORY_ID         = W.FACTORY_ID
		AND   T.FP_PRODUCTION_TYPE = W.FP_PRODUCTION_TYPE
		AND   T.MARKET             = W.MARKET
		AND   T.EQUIPMENT_ID       = W.EQUIPMENT_ID
		AND   T.ELECTRODE_TYPE     = W.ELECTRODE_TYPE
		-- 2018-04-21 kimcd Coating 공정에 환산 실적 갱신 종료

		---------------------------------------------------------------------------------------------------------------------------------------------
		--20180-09-06 PIYONG ADD
		UPDATE T
		SET    T.CELL_IN_QTY   = W.ACTUAL_QTY / W.ACCUM_QTY
				, T.CELL_OUT_QTY  = W.ACTUAL_GOOD_QTY / W.ACCUM_QTY
		FROM  SCM_DAILY_PRODUCT_RESULT_H  T WITH(NOLOCK)
				,(
				SELECT  W.ITEM_ID
						,W.TOP_ITEM_ID
						,W.LINE_ID
						,W.PLAN_DATE
						,W.OPERATION_ID
						,W.FACTORY_ID
						,W.FP_PRODUCTION_TYPE
						,W.MARKET
						,W.EQUIPMENT_ID
						,W.ELECTRODE_TYPE
						,W.ACTUAL_QTY
						,W.ACTUAL_GOOD_QTY
						,ISNULL( (
									SELECT TOP 1 SUM(MCT.ACCUMULATED_CHILD_QTY)
									FROM   SCM_MODEL_COMP_TEMP MCT WITH(NOLOCK)
									WHERE  MCT.[COMPANY_ID]    = W.[COMPANY_ID]
									AND    MCT.[DIVISION_ID]   = W.[DIVISION_ID]
									AND    MCT.[SITE_ID]       = W.[SITE_ID]
									AND    MCT.[PLANT_ID]      = W.[PLANT_ID]
									AND    MCT.[CHILD_ITEM_ID] = W.[ITEM_ID]
									AND    MCT.MODEL_ID        = W.[TOP_ITEM_ID]
									GROUP  BY [MODEL_ID], MCT.ALT_PRIORITY, CASE WHEN MCT.ALT_PRIORITY = 'Y' THEN NULL ELSE CONCAT_ALT_PRIORITY END -- 2020-07-21 kimcd 조립 Cell 환산에서 Primary, 대치 구분자 추가
									ORDER  BY [MODEL_ID], MCT.ALT_PRIORITY DESC, CASE WHEN MCT.ALT_PRIORITY = 'Y' THEN NULL ELSE CONCAT_ALT_PRIORITY END ) -- 2020-07-21 kimcd 조립 Cell 환산에서 Primary, 대치 구분자 추가
									,( SELECT TOP 1 SUM(MCT.ACCUMULATED_CHILD_QTY)
									FROM   SCM_MODEL_COMP_TEMP MCT WITH(NOLOCK)
									WHERE  MCT.[COMPANY_ID]    = W.[COMPANY_ID]
									AND    MCT.[DIVISION_ID]   = W.[DIVISION_ID]
									AND    MCT.[SITE_ID]       = W.[SITE_ID]
									AND    MCT.[PLANT_ID]      = W.[PLANT_ID]
									AND    MCT.[CHILD_ITEM_ID] = W.[ITEM_ID]
									AND    EXISTS ( SELECT TOP 1 1
													FROM SCM_ITEM_M  M WITH(NOLOCK)
													WHERE  M.COMPANY_ID  = MCT.COMPANY_ID
													AND    M.DIVISION_ID = MCT.DIVISION_ID
													AND    M.SITE_ID     = MCT.SITE_ID
													AND    M.ITEM_ID     = MCT.MODEL_ID
													AND    M.FLOW_ID LIKE 'A%') -- 2018-05-15 kimcd Cell 공정 모델만으로 제한
									GROUP  BY [MODEL_ID], MCT.ALT_PRIORITY, CASE WHEN MCT.ALT_PRIORITY = 'Y' THEN NULL ELSE CONCAT_ALT_PRIORITY END -- 2020-07-21 kimcd 조립 Cell 환산에서 Primary, 대치 구분자 추가
									ORDER  BY [MODEL_ID], MCT.ALT_PRIORITY DESC, CASE WHEN MCT.ALT_PRIORITY = 'Y' THEN NULL ELSE CONCAT_ALT_PRIORITY END ) -- 2020-07-21 kimcd 조립 Cell 환산에서 Primary, 대치 구분자 추가
																			)  AS ACCUM_QTY
				FROM   SCM_DAILY_PRODUCT_RESULT_H W WITH(NOLOCK)
				WHERE  W.OPERATION_ID  LIKE  'A%'
				AND    W.[PLAN_DATE]   >= CAST(DATEADD(DD, -42, GETDATE()) AS DATE) ) W
		WHERE T.ITEM_ID            = W.ITEM_ID
		AND   T.TOP_ITEM_ID        = W.TOP_ITEM_ID
		AND   T.LINE_ID            = W.LINE_ID
		AND   T.PLAN_DATE          = W.PLAN_DATE
		AND   T.OPERATION_ID       = W.OPERATION_ID
		AND   T.FACTORY_ID         = W.FACTORY_ID
		AND   T.FP_PRODUCTION_TYPE = W.FP_PRODUCTION_TYPE
		AND   T.MARKET             = W.MARKET
		AND   T.EQUIPMENT_ID       = W.EQUIPMENT_ID
		AND   T.ELECTRODE_TYPE     = W.ELECTRODE_TYPE

		--20180-09-06 PIYONG ADD END
		---------------------------------------------------------------------------------------------------------------------------------------------


		/* 2018-04-09 kimcd 과거 일자별 이력 정리하는 문장 막음 시작
		BEGIN TRAN
		-- ================================================
		-- 로직 추가
		-- ================================================
		-- 임시 테이블에 저장			
		SELECT SUBSTRING(WIPSEQ, 1, CHARINDEX('^',WIPSEQ, 1)-1)         AS LOTID
			   , RTRIM(SUBSTRING(WIPSEQ, CHARINDEX('^',WIPSEQ, 1)+1, LEN(WIPSEQ)))  AS WIPSEQ		--	SCM_MES_WIP_HISTORY_H 테이블 KEY
			   ,WOID
			   ,WO_DETL_ID
			   ,PROCID
			   ,PRODID
			   ,WIP_TYPE_CODE
			   ,CALDATE
			   ,WIPDTTM_ED
			   ,WIPQTY_ED
			   ,WIPQTY2_ED
			   ,WIPQTY2_ENGINE
			   ,CNFM_DFCT_QTY2
			   ,CNFM_LOSS_QTY2
			   ,CNFM_PRDT_REQ_QTY2
			   ,ADD_QTY
			   ,MODIFY_DATE
			   ,YIELD_LOSS_QTY   -- 2018-01-10 kimcd 컬럼 추가
		  INTO #TMP_WIP_HISTORY_H
		  FROM ( 
				 SELECT MAX( LOTID + '^' +  WIPSEQ ) AS WIPSEQ		--	SCM_MES_WIP_HISTORY_H 테이블 KEY
					    ,WOID
					    ,WO_DETL_ID
					    ,PROCID
					    ,PRODID
					    ,WIP_TYPE_CODE
					    ,MAX(CALDATE) AS CALDATE
					    ,MAX(WIPDTTM_ED) AS WIPDTTM_ED
					    ,SUM( WIPQTY_ED ) AS WIPQTY_ED
					    ,SUM( WIPQTY2_ED ) AS WIPQTY2_ED
					    ,SUM( WIPQTY2_ENGINE ) AS WIPQTY2_ENGINE
					    ,SUM( CNFM_DFCT_QTY2 ) AS CNFM_DFCT_QTY2
					    ,SUM( CNFM_LOSS_QTY2 ) AS CNFM_LOSS_QTY2
					    ,SUM( CNFM_PRDT_REQ_QTY2 ) AS CNFM_PRDT_REQ_QTY2
					    ,SUM( ADD_QTY ) AS ADD_QTY
					    ,MAX( MODIFY_DATE ) AS MODIFY_DATE
						,SUM( YIELD_LOSS_QTY ) AS YIELD_LOSS_QTY   -- 2018-01-10 kimcd 컬럼 추가
				   FROM SCM_MES_WIP_HISTORY_H
				  WHERE CAST( WIPDTTM_ED AS DATETIME) <= CAST(DATEADD(DD, -46, GETDATE()) AS DATE) 
				  GROUP BY WOID
					    ,WO_DETL_ID
					    ,PROCID
					    ,PRODID
					    ,WIP_TYPE_CODE
			   ) B

			--  -46일보다 이전 LOT별 데이터 삭제
			DELETE FROM SCM_MES_WIP_HISTORY_H
 			 WHERE CAST( WIPDTTM_ED AS DATETIME) <= CAST(DATEADD(DD, -46, GETDATE()) AS DATE)

			-- 데이터 저장
			INSERT INTO [SCM_MES_WIP_HISTORY_H]
				(
					[LOTID]
					,[WIPSEQ]
					,[WOID]
					,[WO_DETL_ID]
					,[PROCID]
					,[PRODID]
					,[WIP_TYPE_CODE]
					,[CALDATE]
					,[WIPDTTM_ED]
					,[WIPQTY_ED]
					,[WIPQTY2_ED]
					,[WIPQTY2_ENGINE]
					,[CNFM_DFCT_QTY2]
					,[CNFM_LOSS_QTY2]
					,[CNFM_PRDT_REQ_QTY2]
					,[ADD_QTY]
					,[YIELD_LOSS_QTY]  -- 2018-01-10 kimcd 컬럼 추가
					,CREATE_DATE
					,CREATE_USER_ID
					,[MODIFY_DATE]
			)
			SELECT [LOTID]
				   ,[WIPSEQ] 
				   ,[WOID]
				   ,[WO_DETL_ID]
				   ,[PROCID]
				   ,[PRODID]
				   ,[WIP_TYPE_CODE]
				   ,[CALDATE]
				   ,[WIPDTTM_ED]
				   ,[WIPQTY_ED]
				   ,[WIPQTY2_ED]
				   ,[WIPQTY2_ENGINE]
				   ,[CNFM_DFCT_QTY2]
				   ,[CNFM_LOSS_QTY2]
				   ,[CNFM_PRDT_REQ_QTY2]
				   ,[ADD_QTY]
				   ,[YIELD_LOSS_QTY] -- 2018-01-10 kimcd 컬럼 추가
				   ,GETDATE()
				   ,'PR_SCM_MODIFY_MES_WIP_HISTORY_H'
				   ,[MODIFY_DATE]
			  FROM #TMP_WIP_HISTORY_H A
			 ORDER BY LOTID
			;

		COMMIT TRAN
		2018-04-09 kimcd 과거 일자별 이력 정리하는 문장 막음 끝 */

		EXEC PR_XIF_LOG @v_proc_name, NULL, 'END',   NULL, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
		
	END TRY

	BEGIN CATCH

		-- 에러나도 로그는 인서트
		SET @v_descr = ERROR_MESSAGE()
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate

	END CATCH

END
