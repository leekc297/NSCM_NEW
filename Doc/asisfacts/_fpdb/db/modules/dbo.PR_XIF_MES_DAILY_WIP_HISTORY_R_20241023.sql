

create PROCEDURE [dbo].[PR_XIF_MES_DAILY_WIP_HISTORY_R_20241023]

-- ================================================================================================
-- Program ID          : FP00830
-- Program Name        : PR_XIF_MES_WIP_HISTORY_R
-- Param               :
-- Batch Period        : 1Day
-- Description         : FP00780 실행 Work Order 전환
--                       FP00830 생산 완료 실적 전환 > SCM_PRODUCT_RESULT_H
--                       FP00860 생산 투입 실적 전환 > SCM_PRODUCT_RESULT_H
-- Source System       : MES
-- Destination System  : FP SDB
-- Source Table        : XIF_MES_WIP_HISTORY_R
-- Destination Table   : FP_MES_WORK_ORDER_STATUS_H, SCM_PRODUCT_RESULT_H
--
-- Create Date		   : 2017.04.11
-- Update Date         : 2017.05.24  PIYONG 1.1
--			             2017.06.02  PIYONG 1.2 ,  운영 소스 개발로 이관
--					     2017.06.14  PIYONG 1.3    FP_MES_WORK_ORDER_STATUS_H 관련 로직 삭제
--                                                 실적수량 ADD_QTY 컬럼 추가
--					     2017.06.23  PIYONG 1.4    ADD_QTY 삭제  양품 수량에 이미 포함되어 있음
--						 2017-07-13  PIYONG 1.5
--						 2017-08-04  KIMCD  1.6
--						 2017-08-09  KIMCD  1.7
--						 2017-08-28	 PIYONG 1.8
--                       2017-09-05  KIMCD  1.9
--                       2017-09-05  KIMCD  1.91
--                       2017-09-05  KIMCD  2.0
--						 2017-09-08  PIYONG 2.1
--						 2017-09-15  PIYONG 2.2
--						 2017-11-23  PIYONG 2.3
--						 2017-11-24  PIYONG 2.4
--						 2017-11-29  PIYONG 2.5
--						 2017-12-11	 PIYONG	3.0
--						 2017-12-27	 kimcd	3.1
--                       2018-01-01  kimcd  3.2
--                       2018-01-06  kimcd  3.3
--                       2018-01-10  kimcd  3.4
--                       2018-01-17  PIYONG 3.5
--                       2018-01-23  kimcd  3.6
--                       2018-02-01  kimcd  3.7
--                       2018-02-23  kimcd  3.8
--                       2018-03-08  kimcd  3.9
--						 2018-03-26  PIYONG 3.10
--                       2018-04-02  kimcd  3.11
--                       2018-04-09  kimcd  3.12
--                       2018-04-21  kimcd  3.13
--                       2018-05-16  kimcd  3.14
--						 2018-05-23  PIYONG 3.15
--						 2018-08-07  PIYONG 3.16  
--                       2018-08-27	 kimcd  3.17
--						 2018-09-06  PIYONG 3.18
--						 2018-10-16  PIYONG 3.19
--                       2018-11-06  KIMCD  3.20
--						 2018-11-14	 PIYONG 3.21
--						 2018-11-21	 PIYONG 4.0
--						 2018-11-27  PIYONG 4.1
--						 2018-11-27  PIYONG 4.2
--                       2018-12-18  kimcd  4.21
--                       2019-04-04  kimcd  4.22
--						 2019-05-10  PIYONG 4.23
--						 2019-07-09  PIYONG 4.3
--						 2019-07-15  PIYONG 4.4
--						 2019-07-15  PIYONG 4.41
--                       2019-08-16  kimcd  4.42
--						 2019-08-29  PIYONG 4.5
--						 2019-09-11  PIYONG 4.6
--						 2020-02-04  PIYONG 4.7
--						 2020-03-13  PIYONG 4.8
--						 2020-03-20  PIYONG 4.9
--						 2020-06-30  kimcd  5.0
--                       2020-07-21  kimcd  5.1
--                       2020-10-08  kimcd  5.2
--                       2021-01-29  kimcd  5.3
--                       2021-07-22  kimcd  5.4
--                       2021-10-28  kimcd  5.5
--                       2022-05-10  kimcd  5.6
--                       2022-08-11  kimcd  5.7
--                       2022-08-24  kimcd  5.8
--                       2022-11-01  leeseonmgin  5.9
--                       2023-01-12  kimcd  6.0
-- Author              : PIYONG
-- Version             : 1.0
--					     1.1 실적 조회 기간 수정 최기주수석 요청 
--					     1.2 실적이 없는 날은 ACCUM_COUNT가 0 으로 수신되어 추가
--						     실적이 없어도 SCM_PRODUCT_RESULT_H 데이터 생성은 되어야 함
--						 1.3 FP_MES_WORK_ORDER_STATUS_H 관련 로직 삭제
--							 ADD_QTY  컬럼 추가
--						 1.4  실적수량 조회시 ADD_QTY 삭제  양품 수량에 이미 포함되어 있음
--						 1.5 FP_MES_PRODUCTION_PLAN_M 수정 조건 추가
--						 1.6 WO_DETAIL_ID가 없는 경우 WO_ID로 입력
--                       1.7 설비 연결 조건에 EQSGID 조건 추가 2017-08-09
--						 1.8 SCM_MES_WIP_HISTORY_H 의 WIP_TYPE_CODE 조건에  PROD 추가
--                       1.9 Rownumber order by 조건 변경
--                       1.91 kimcd 2017-09-06 detail work order id가 다른 경우 work order id로 변경. 조립의 엉뚱한 Detail WO ID 할당 현상 방지용
--                       2.0 kimcd 2017-09-06 일자 구분 컬럼 wipdttm_ed에서 caldate로 변경
--						 2.1 마스터 생성  WIPDTTM_ED NOT NULL 조건 추가
--						 2.2 기준실적 조회시 활성화 후 재작업으로 다시 들어온 Cell 재고 제외 조건 추가
--						 2.3  1)MARKET, PRODUCTION_TYPE 정보 수신 처리
--							  2)SCM_DAILY_PRODUCT_RESULT_H 저장 로직 추가
--						 2.4  FP_MES_PRODUCTION_PLAN_M 수정시 장시간 수행되서 주석 처리
--						 2.5  WIPQTY2_ED -> WIPQTY2_ENGINE 변경
--							  WIPQTY2_ED은 TOP코팅 수량이 실적에 포함 되어 있어  포함되어 있지 않는 WIPQTY2_ENGINE로 변경
--						 3.0  IF_ID 별 SCM_PRODUCT_RESULT_H, SCM_DAILY_PRODUCT_RESULT_H 정보 생성을 SCM_MES_WIP_HISTORY_H 모든 정보가 생성 한 후에 생성하는걸로 변경
--                       3.1  실적 취합 Table에 Market 구분하여 정보 입력. 2017-12-27 kimcd
--                       3.2  일자별 실적 취합 범위 증대 - 11일 location을 공정, 라인 기준으로 찾을 수 있도록 보완. 2018-01-01 kimcd
--                       3.3  2018-01-06 kimcd 일자별 이력에서 미반영된 정보 정리하는 과정 추가
--                       3.4  2018-01-10 kimcd loss 중 수율에 반영되어야 할 수량만 별도 입수함
--						 3.5  2018-01-17 PIYONG SCM_DAILY_PRODUCT_RESULT_H에 활성화 공정 제외 조건 추가
--                       3.6  2018-01-23 kimcd 실적 화면의 base table 수정용으로 실적, 불량 수량 컬럼 추가
--                       3.7  2018-02-01 kimcd 일자별 실적에서 LOCATION 컬럼 KEY에서 제거
--                       3.8  2018-02-23 kimcd 실적 취합에서 설비별로 구분하여 취합함.
--                       3.9  2018-03-08 kimcd 남경 재작업 실적을 기존 라인의 수량에 포함.
--						 3.10 2018-03-26 SCM_DAILY_PRODUCT_RESULT_H 남경 재작업 생산(C Product)의 경우 적용 MODEL를 찾아서 TOP_ITEM_ID 에 넣음
--                       3.11 2018-04-02 kimcd wip_type_code가 PROD인 경우 WIPQTY_ED, WIPQTY2_ED, WIPQTY2_ENGINE 3개 컬럼의 값을 0으로 치환
--                       3.12 2018-04-09 kimcd fp production type 컬럼 추가 - FP 전용 생산 유형
--                       3.13 2018-04-21 kimcd Coating 공정의 환산 실적 정보 계산
--                       3.14 2018-05-16 kimcd Pack 포장 공정 실적 수신 과정 수정. WIP_TYPE_CODE 조건에 CREATED 추가 PACKED로 DECODE하여 입력
--						 3.15 2018-05-23 PIYONG P5000이고 WIPDTTM_ST가NOT NULL 이고 WIPDTTM_ED가 NULL일 경우 WIPDTTM_ED에 WIPDTTM_ST 입력
--						 3.16 2018-08-07 PIYONG 활성화 소형 수신 처리
--                       3.17 2018-08-27 kimcd 활성화 후 공정 실적에서 - 양품 아닌 경우 수량 제거
--						 3.18 2018-09-06 PIYONG  SCM_DAILY_PRODUCT_RESULT_H 테이블에 공정이 A로 시작하는 데이터에 CELL_IN_QTY, CELL_OUT_QTY  추가
--						 3.19 2018-10-16 PIYONG 	 E8동이 없어지면서 관련 로직 제거
--												ISNULL(U.DIVISION_CODE, (CASE WHEN ( SELECT TOP 1 SUBSTRING(A.ITEM_NAME,1,1) FROM SCM_ITEM_M A WHERE A.ITEM_ID = U.PRODID ) IN ('A','E') AND U.EQSGID = 'E7D01' THEN '81' 
--																			 WHEN  ( SELECT DISTINCT SUBSTRING(A.ITEM_NAME,1,1) FROM SCM_ITEM_M A WHERE A.ITEM_ID = U.PRODID ) = 'M'  AND U.EQSGID = 'E7D01' THEN '40' 
--																			  ELSE L.DIVISION_ID END ))
--												(case when U.DIVISION_CODE = '81' and U.EQSGID = 'E7D01' then 
--															'E8' 
--													  when ( select top 1 substring(a.ITEM_NAME,1,1) from scm_item_m a where a.item_id = u.PRODID ) IN ( 'A', 'E') and U.EQSGID = 'E7D01' then 
--															'E8' 
--													  when ( select distinct substring(a.ITEM_NAME,1,1) from scm_item_m a where a.item_id = u.PRODID ) = 'M'  and U.EQSGID = 'E7D01' then 
--															'E7'
--													  else substring(u.EQSGID,1,2) end )  =  L.FACTORY_ID
--                       3.20 2018-11-06 kimcd 활성화 후 공정에 cell material id 추가. 일자별 실적 갱신 기간 21일로 증가
--						 3.21 2018-11-14 PIYONG 최기주수선님 요청으로 Coating 공정에 환산 실적 갱신 로직을 MAX-> MIN으로 변경 (엔진에서 MIN으로 적용)
--						 4.0  2018-11-21 Coating 공정에 환산 실적 갱신 로직 변경
--										 MIN(VALUE) -> MODEL_ID, PROD_VERSION_TYPE 포함하여 PROD_VER_TYPE 우선순으로 찾음  없으면 값이 작은 값 우선 순위
--						 4.1  2018-11-27 SCM_MES_WIP_HISTORY_H 테이블에 PROD_LOTID 수신 추가
--						 4.2  2018-12-07 Coating 공정에 환산 실적 갱신 로직 변경
--										 우선 순위 변경
--                       4.21 2018-12-18 kimcd 당일 이후 실적은 일별 실적 형성에서 제외
--                       4.22 2019-04-04 kimcd top coding 수량 jumro roll 환산 수량 형성
--						 4.23 2019-05-10 PIYONG SCM_PRODUCT_RESULT_H 테이블 데이터 생성 주석 처리
--						 4.3  2019-07-09 PIYONG SCM_DAILY_PRODUCT_RESULT_H 데이터 생성 JOIN  테이블 변경 SCM_EQUIPMENT_M -> SCM_LINE_M
--						 4.4  2019-07-15 PIYONG SCM_EQUIPMENT_M, SCM_LINE_M  조인시 컬럼 추가, 정렬
--						 4.41 2019-08-02 PIYONG TOP_COATING_QTY2 컬럼 조건 추가
--												MES UI 구조 문제로 단면 제품인데도 TOP COATING 수량이 존재하여 조건 추가
--						 4.42 2019-08-16 kimcd  [SCM_MES_WIP_HISTORY_H] key 구조 변경. PROCID, ATTRIBUTE2(FACTORY_ID) 추가
--						 4.5 일별  환산 실적 전극 후공정(E3000, E4000) 추가
--						 4.6 일별 실적 관리 생성 조건에 동 조건 추가
--						 4.7 속도 개선을 위한 임시 테이블 추가
--						 4.8 SCM_MES_WIP_HISTORY_H 생성 쿼리 중 ROWUMBER에 UPDDTTM DESC 조건 추가
--						 4.9 오창 소형 활성화 생성 제외
--                       5.0 2020-06-30 kimcd 환산자 적용 우선 순위를 FP Instance, Plant별로 관리함. 해당 정보 기반으로 환산자 적용.
--                       5.1 2020-07-21 kimcd 조립 Cell 환산에서 Primary, 대치 구분자 추가
--                       5.2 2020-10-08 kimcd Site ID 조회 조건을 IF ID에서 AREA_ID로 변경
--                       5.3 2021-01-29 kimcd Pack 실적을 가상 Lotid로 전환하면서 P5000 공정 실적 수신 보완
--                       5.4 2021-07-22 kimcd 전극/조립 동은 마감 전 월의 1일 이후 실적 전체 받음
--                                            실적 갱신 전에 초기화 과정 추가
--                       5.5 2021-10-28 kimcd ATTRIBUTE12 - Hazel Pack 재작업 실적 구분자 입수
--                       5.6 2022-05-10 kimcd 속도 개선 - Temp Table 도입. CXPACKET lock 회피용
--                       5.7 2022-08-11 kimcd 설비 없는 공정 실적 수신할 수 있도록 보완
--                       5.8 2022-08-24 kimcd 라인 정보 없어도 실적 수신되도록 수정 ILT 공정용
--                       5.9 2022-11-01 leeseonmgin 전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
--                       6.0 2023-01-12 kimcd 전극 FP고도화 I/F 작업 - MES에서 전극 생산 버전을 모델과 버전까지만 회신하기로 하여 수정
--                       6.1 2023.09.10 FP Pjt. E20230905-000545 / application for updating performance of past in 38day (As is 21 day，To be 38 day) when GSCM plan update
--                       2024-03-15 chkim.68 하드코딩 전환 (ref scm_code_lookup_value )
--                       6.3 2024-06-01 FP Pjt. P5000/P5200일 경우 착공 -> 완공으로 변경 (WIPDTTM_ST/WIPQTY_ST/WIPQTY2_ST -> WIPDTTM_ED/WIPQTY_ED/WIPQTY2_ED)
--                           2024-06-12 FP Pjt. P5000/P5200일 경우 WIPQTY_ED/WIPQTY2_ED -> WIPQTY_ED/WIPQTY2_ED - CNFM_DFCT_QTY/CNFM_DFCT_QTY2
-- ================================================================================================


AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_MES_DAILY_WIP_HISTORY_R'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	   = 0
	DECLARE @sysdate     DATETIME      = GETDATE()

	DECLARE @ROWCOUNT    INTEGER

	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)
	DECLARE @v_table     NVARCHAR(1000)

	DECLARE @v_temp3     NVARCHAR(1000)


	declare @v_check     int;
	-- ================================================
    -- Declare start
	-- ================================================
	DECLARE @IF_ID        NVARCHAR(50)
	DECLARE @ACCUM_DATE   NVARCHAR(8)
	DECLARE @SITE_ID      NVARCHAR(50)
	DECLARE @BASE_HOUR    NVARCHAR(2)
	CREATE TABLE #XIF_MES_DAILY_WIP_HISTORY_TEMP_FACTORY (
								FACTORY_ID NVARCHAR(30)
						
								)
	CREATE TABLE #XIF_MES_DAILY_WIP_HISTORY_UPDATE_INFO (		--2020-02-04 PIYONG ADD
								IF_ID NVARCHAR(50)
								, ACCUM_DATE NVARCHAR(8)
								, SITE_ID NVARCHAR(30) -- 2020-10-08 kimcd 지역 코드 추가
							  )

	DECLARE @CONV_TABLE TABLE (
			 FACTORY_ID         NVARCHAR(30),
			 PROD_VERSION_TYPE  NVARCHAR(30),
			 PRODUCTION_TYPE    NVARCHAR(30),
			 VERSION_TYPE       NVARCHAR(30),
             IDX                NUMERIC(10) )  -- 2020-06-30 kimcd 환산자 정렬용 임시 Table

    SET @v_temp3 = '0001'


	DECLARE CUR_IF_MES_WIPHIST CURSOR FOR
		SELECT IF_ID, ACCUM_DATE, ( SELECT DISTINCT Z.SITE_ID FROM SCM_FACTORY_M Z WHERE Z.FACTORY_ID = MAX(R.AREA_ID) ) SITE_ID -- 2020-10-08 kimcd Site ID를 동 사용하여 조회
		  FROM [SY_XIF_MES_DAILY_WIP_HISTORY_R] R
		 WHERE 1=1
		   AND PROC_FLAG = 'N'
		 GROUP BY IF_ID, ACCUM_DATE
		HAVING ( COUNT(1) = MAX(ACCUM_COUNT) 
				 OR ( COUNT(1) = 1 AND MAX(ACCUM_COUNT) = 0 )																			-- 2017-06-02 PIYONG 실적이 없는 날은 ACCUM_COUNT가 0 으로 수신
			   )  -- 전체를 수신받지 못한 경우에는 처리하지 않음.
		 ORDER BY IF_ID, ACCUM_DATE


	-- ================================================
    -- Declare end
	-- ================================================
	--Violation of PRIMARY KEY constraint 'PK_FP_MES_WORK_ORDER_STATUS_H'. Cannot insert duplicate key in object 'dbo.FP_MES_WORK_ORDER_STATUS_H'. The duplicate key value is (C100, 81, A001, A040, A1, Nov 19 2016 12:00AM, WK116B03LM00N#1).

	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	----오류방지 : 트랜잭션 교착 상태 발생 방지
	--IF [dbo].[FN_GET_PROCEDURE_EXECUTION_CHECK]('PR_XIF_SCM_WO_ROLLING_PST') > 0
	--	RETURN;

	--IF [dbo].[FN_GET_PROCEDURE_EXECUTION_CHECK]('PR_SCM_WO_ROLLING') > 0
	--	RETURN;

	SET @v_temp3 = '0002'

	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

	BEGIN TRY				

		BEGIN TRAN
		-- ================================================
		-- 로직 추가 start
		-- ================================================

	    -- SITE 정보 추가
		  OPEN CUR_IF_MES_WIPHIST;
		  FETCH NEXT FROM CUR_IF_MES_WIPHIST INTO  @IF_ID        
												  ,@ACCUM_DATE
												  ,@SITE_ID  -- 2020-10-08 kimcd Site ID를 동 사용하여 조회
												  ;
		  WHILE (@@FETCH_STATUS = 0)
		  BEGIN
	
				-------------------------------------------------------
				--2020-02-04 PIYONG ADD

				INSERT INTO #XIF_MES_DAILY_WIP_HISTORY_UPDATE_INFO
				SELECT @IF_ID, @ACCUM_DATE, @SITE_ID  
				
				-- 2020-10-08 kimcd Site ID추가
				--2020-02-04 PIYONG ADD END
				-------------------------------------------------------
				-- 2021-07-22 kimcd 기존 실적 초기화 시작
				-- 2021-10-28 전극, 조립에 실저 summary 적용 안되어 주석 처리
				--UPDATE A
				--SET  A.WIPQTY_ED		  = 0
				--	,A.WIPQTY2_IN         = 0
				--	,A.WIPQTY2_ST         = 0
				--	,A.WIPQTY2_ED         = 0
				--	,A.WIPQTY2_OT         = 0
				--	,A.CNFM_DFCT_QTY      = 0
				--	,A.CNFM_LOSS_QTY      = 0
				--	,A.CNFM_PRDT_REQ_QTY  = 0
				--	,A.CNFM_DFCT_QTY2     = 0
				--	,A.CNFM_LOSS_QTY2     = 0
				--	,A.CNFM_PRDT_REQ_QTY2 = 0
				--	,A.SCRAP_QTY          = 0
				--	,A.WIPQTY2_ENGINE     = 0
				--	,A.ADD_QTY			  = 0
				--	,A.YIELD_LOSS_QTY     = 0
				--	,A.MODIFY_USER_ID     = 'PR_XIF_MES_DAILY_WIP_HISTORY_R'
				--	,A.MODIFY_DATE        = GETDATE()
				--FROM   [SCM_MES_WIP_HISTORY_H] A
				--	  ,[SCM_FACTORY_M]         F (NOLOCK)
				--	  ,(SELECT ISNULL( XIF.AREA_ID, SUBSTRING( XIF.EQSGID, 1, 2) ) AS FACTORY_ID, CONVERT(VARCHAR, CONVERT( DATETIME, ATTRIBUTE11, 112), 120) AS FROM_DATE
				--		  FROM [dbo].[SY_XIF_MES_DAILY_WIP_HISTORY_R] XIF (NOLOCK)
				--		 WHERE XIF.IF_ID       = @IF_ID
				--		   AND XIF.ACCUM_DATE  = @ACCUM_DATE
				--		   AND XIF.ACCUM_COUNT > 0
				--		GROUP BY XIF.IF_ID, XIF.ACCUM_DATE, ISNULL( XIF.AREA_ID, SUBSTRING( XIF.EQSGID, 1, 2) ), ATTRIBUTE11) C
				--WHERE F.FACTORY_ID = C.FACTORY_ID
				--AND   F.SHOP_GROUP_ID IN ('A','E') -- 전극 조립 Factory로 한정
				--AND   A.ATTRIBUTE2 = C.FACTORY_ID
				--AND   A.CALDATE   >= C.FROM_DATE
				--AND   EXISTS ( SELECT TOP 1 1
				--               FROM   SCM_MMD_LINE_M ML (NOLOCK)
				--               WHERE  ML.LINE_ID = A.EQSGID
				--			   AND    (ML.MES_SOURCE_GROUP IS NULL
				--					   OR ML.MES_SOURCE_GROUP LIKE LEFT(@IF_ID,4) + '%') )
			   -- 2021-07-22 kimcd 기존 실적 초기화 종료

			   SET @v_temp3 = '1111'

				MERGE INTO [dbo].[SCM_MES_WIP_HISTORY_H] A
				USING ( SELECT C.*
							, ISNULL ( (SELECT TOP 1 CM.[VERSION] + '^' + CM.PROD_SEQ
										FROM   [DBO].[SCM_EQUIPMENT_M] L WITH(NOLOCK) 
											INNER JOIN [dbo].[SCM_ITEM_CONV_CALC_USE_M]  CU (NOLOCK)
												ON    CU.FACTORY_ID     = C.FACTORY_ID
												AND   CU.MODEL_ID       = C.WORK_REQUEST_MODEL_ID
												AND   CU.ITEM_ID        = C.PRODID
												AND   CU.[LINE_ID]      = L.LINE_ID
												AND   CU.[OPERATION_ID] = 'E2000'
												AND   CU.[VERSION]   LIKE C.[VERSION] + '%'
												AND   CU.[ACTIVE_FLAG]  = 'Y'
											INNER JOIN [dbo].[SCM_ITEM_CONV_CALC_M] CM (NOLOCK)
												ON  CM.COMPANY_ID = CU.COMPANY_ID
												AND CM.FACTORY_ID = CU.FACTORY_ID
												AND CM.ITEM_ID    = CU.ITEM_ID
												AND CM.OPERATION  = CU.OPERATION_ID
												AND CM.MODEL_ID   = CU.MODEL_ID
												AND CM.[VERSION]  = CU.[VERSION]
										WHERE L.SITE_ID      = C.SITE_ID
										AND   L.FACTORY_ID   = C.FACTORY_ID
   										AND   L.OPERATION_ID = C.PROCID
										AND   L.OPERATION_ID LIKE 'E%'
										AND   L.EQUIPMENT_ID = C.EQPTID
										ORDER BY CM.APPLY_DATE DESC), C.[VERSION] + '^' + ISNULL(C.PROD_SEQ,'') ) AS VER_SEQ -- 2023-01-12 kimcd 전극 FP고도화 I/F 작업 - MES에서 전극 생산 버전을 모델과 버전까지만 회신하기로 하여 수정
						  FROM (
						  
								 SELECT A.LOTID
										-- 2018-05-23 PIYONG 조건 추가
									    ,CASE WHEN A.PROCID ='P5000' THEN
												 '999'
									          ELSE
												 ISNULL(A.WIPSEQ, '1')
											   END AS WIPSEQ
									   ,convert( varchar, A.CALDATE ,120) CALDATE
									   ,A.SHIFT            
									   ,A.PRODID           
									   ,A.BOMREV           
									   ,A.ROUTID           
									   ,A.FLOWID           
									   ,A.PCSGID           
									   ,A.PROCID           
									   ,A.EQSGID           
									   ,A.EQPTID
									   ,convert( varchar, A.WIPDTTM_ST ,120) WIPDTTM_ST
									   -- 2018-05-23 PIYONG 조건 추가 투입 일자를 생산 완료 일자로 전환
									   ,CASE WHEN A.PROCID = 'P5000' AND A.WIPDTTM_ST IS NOT NULL AND A.WIPDTTM_ED IS NULL THEN
												 convert( varchar, A.WIPDTTM_ST ,120)
									         ELSE
												 convert( varchar, A.WIPDTTM_ED ,120)
											 END	AS WIPDTTM_ED
									   -- 2018-05-23 PIYONG CASE 추가 투입 수량을 완료 수량으로 전환
									   ,CASE WHEN NOT ( (A.PROCID LIKE 'F%' OR A.PROCID LIKE 'B%') AND ISNULL(A.ATTRIBUTE10, 'G') = 'N' ) THEN -- 2018-08-27 kimcd FXXXX공정(활성화), BXXX 공정(포장)양품 Lot 구분자 WIP_QLTY_TYPE_CODE (G/N), N인 경우 수신 제외
											 CASE WHEN A.PROCID IN ('P5000', 'P5200') THEN -- 2021-01-29 kimcd P5000 공정은 항상 투입 수량 사용 AND A.WIPDTTM_ST IS NOT NULL AND A.WIPDTTM_ED IS NULL THEN
												A.WIPQTY_ED - ISNULL(CNFM_DFCT_QTY, 0)  --WIPQTY_ST
											 ELSE
												A.WIPQTY_ED
											 END
										ELSE 0 END  AS WIPQTY_ED
									   ,A.WOID             
									   ,A.WIPQTY2_IN       
									   ,A.WIPQTY2_ST       
									   -- 2018-05-23 PIYONG CASE 추가 투입 수량을 완료 수량으로 전환
									   ,CASE WHEN NOT ( (A.PROCID LIKE 'F%' OR A.PROCID LIKE 'B%') AND ISNULL(A.ATTRIBUTE10, 'G') = 'N' ) THEN -- 2018-08-27 kimcd FXXXX공정(활성화), BXXX 공정(포장)양품 Lot 구분자 WIP_QLTY_TYPE_CODE (G/N), N인 경우 수신 제외
											 CASE WHEN A.PROCID IN ('P5000', 'P5200') THEN -- 2021-01-29 kimcd P5000 공정은 항상 투입 수량 사용 AND A.WIPDTTM_ST IS NOT NULL AND A.WIPDTTM_ED IS NULL THEN
												A.WIPQTY2_ED - ISNULL(CNFM_DFCT_QTY2, 0) --WIPQTY2_ST
											 ELSE
												A.WIPQTY2_ED
											 END
									    ELSE 0 END  AS WIPQTY2_ED
									   ,A.COATING_SIDE_TYPE_CODE  -- 추가
									   -- 양면 coating을 하는 경우에 Top과 Back의 LOT ID가 다르게 채번됨.
									   -- 양품 수량은 Back 기준으로 하면되나 Loss나 Dfct 같은 경우에는 top back을 더해야 함.
									   -- 단면 모델인 경우에는 top 수량을 생산실적으로 넣어야 함. 
									   /*
									   ,ISNULL(CASE WHEN COATING_SIDE_TYPE_CODE = 'T' AND (select count(1) from scm_item_m w where w.item_id = A.PRODID  and w.item_class_level_3 = 'CS') = 0 THEN NULL ELSE WIPQTY2_ED END, 0) 
												+ ISNULL(A.CNFM_DFCT_QTY2, 0) + ISNULL(A.CNFM_PRDT_REQ_QTY2, 0) + ISNULL(A.CNFM_LOSS_QTY2, 0)  AS WIPQTY2_ENGINE -- 추가
                                       */
									   ,CASE WHEN NOT ( (A.PROCID LIKE 'F%' OR A.PROCID LIKE 'B%') AND ISNULL(A.ATTRIBUTE10, 'G') = 'N' ) THEN -- 2018-08-27 kimcd FXXXX공정(활성화), BXXX 공정(포장)양품 Lot 구분자 WIP_QLTY_TYPE_CODE (G/N), N인 경우 수신 제외
											ISNULL(CASE WHEN COATING_SIDE_TYPE_CODE = 'T' AND (select count(1) from scm_item_m w, scm_item_class_m x  where w.item_id = A.PRODID  and w.item_class = x.class_id and x.level_3_code = 'APCCS') = 0 THEN NULL 
												   ELSE CASE WHEN A.PROCID IN ('P5000', 'P5200') THEN -- 2021-01-29 kimcd P5000 공정은 항상 투입 수량 사용 AND A.WIPDTTM_ST IS NOT NULL AND A.WIPDTTM_ED IS NULL THEN
															A.WIPQTY2_ED - ISNULL(CNFM_DFCT_QTY2, 0)  --WIPQTY2_ST
														ELSE
															A.WIPQTY2_ED
														END  -- 2018-05-23 PIYONG CASE 추가 투입 수량을 완료 수량으로 전환
													END, 0) 
										ELSE 0 END	AS WIPQTY2_ENGINE -- 추가
									   ,A.WIPQTY2_OT       
									   ,CASE WHEN A.WIP_TYPE_CODE = 'CREATED' THEN 'PACKED' ELSE A.WIP_TYPE_CODE  END AS WIP_TYPE_CODE  -- 2018-05-16 kimcd CREATED 유형은 PACKED로 전환
									   ,A.CNFM_DFCT_QTY
									   ,A.CNFM_LOSS_QTY
									   ,A.CNFM_PRDT_REQ_QTY
									   ,A.CNFM_DFCT_QTY2
									   ,A.CNFM_LOSS_QTY2
									   ,A.CNFM_PRDT_REQ_QTY2
									   ,A.WIP_NOTE         
									   ,A.ERP_TRNF_FLAG    
									   ,CASE WHEN A.WOID != A.WO_DETL_ID THEN A.WOID ELSE ISNULL(A.WO_DETL_ID, A.WOID) END  AS WO_DETL_ID  -- KIMCD 2017-08-04 ADD ISNULL() KIMCD 2017-09-06 ADD CASE
									   ,A.SCRAP_QTY
									   ,A.ADD_QTY
									   -- ,( SELECT DISTINCT Z.SITE_ID FROM SCM_FACTORY_M Z WHERE MES_SOURCE_GROUP = SUBSTRING(IF_ID,1,4) ) SITE_ID   -- 2020-10-08 kimcd 주석 처리
									   ,@SITE_ID     AS SITE_ID -- 2020-10-08 kimcd Site ID를 변수로 추가
									   ,A.ATTRIBUTE2 AS FORMATION_REWORK_TYPE				-- PIYONG 2017-09-15 추가
									   ,A.ATTRIBUTE3 AS MARKET								-- PIYONG 2017-11-17 추가
									   ,CASE WHEN A.ATTRIBUTE12 = 'Y' THEN 'REWORK' ELSE A.ATTRIBUTE4 END AS PRODUCTION_TYPE -- 2021-10-28 kimcd Hazel Pack 재작업 실적 구분자 입수	-- PIYONG 2017-11-17 추가
									   ,ISNULL(A.ATTRIBUTE5, (SELECT TOP 1 APPLIED_MODEL 
									                            FROM SCM_ITEM_M AS X with(nolock) 
									                                 JOIN SCM_FACTORY_M AS Y WITH(NOLOCK)
												                  ON X.COMPANY_ID = Y.COMPANY_ID
												                 AND X.DIVISION_ID = Y.DIVISION_ID
												                 AND X.SITE_ID = Y.SITE_ID
												                 AND X.ITEM_ID = A.PRODID
												                 AND Y.FACTORY_ID = A.AREA_ID
											                 )
									          )		AS TOP_ITEM_ID							-- PIYONG 2017-11-23 추가
									   ,CASE WHEN ISNUMERIC(A.ATTRIBUTE6) = 1 THEN CONVERT(NUMERIC(18,5), A.ATTRIBUTE6) END AS YIELD_LOSS_QTY   -- 2018-01-10 kimcd 투입 수량 표시하기 위해 YILED에 포하되어야 하는 LOSS 수량 컬럼 추가
									   ,ROW_NUMBER() over ( partition by lotid, (CASE WHEN A.PROCID ='P5000' THEN '999' ELSE ISNULL(A.WIPSEQ, '1') END), A.PROCID, ISNULL(A.AREA_ID, SUBSTRING(A.EQSGID,1,2)) 
																order by UPDDTTM DESC, if_rcv_date desc) ROWUMBER  -- 2019-08-16 kimcd 분할 조건에 PROCID, ISNULL(AREA_ID, SUBSTRING(A.EQSGID,1,2)) 추가	-- kimcd 2017-09-05 transfer_date에서 if_rcv_date로 변경		--2020-03-13 PIYONG UPDDTTM DESC 추가
									   -- 2018-05-23 PIYONG ISNULL(A.WIPSEQ, '1') -> (CASE WHEN A.PROCID ='P5000' THEN '999' ELSE ISNULL(A.WIPSEQ, '1') END)
									   ,ISNULL(A.AREA_ID, SUBSTRING(A.EQSGID,1,2))    AS FACTORY_ID -- 2019-08-16 kimcd 동 없는 경우 대비 NULL 처리 -- 2018-03-08 kimcd 동 정보 추가
									   ,A.ATTRIBUTE8 AS C_PJT_LINE_ID        -- 2018-03-08 kimcd 남경 C 생산으로 전송한 인계 라인
									   ,A.ATTRIBUTE9 AS C_PJT_EQUIPMENT_ID   -- 2018-03-08 kimcd 남경 C 생산으로 전송한 인계 설비
									   ,(
									   
									  --   SELECT TOP 1 E.OPERATION_ID
										 --FROM   SCM_ITEM_M       I WITH(NOLOCK)
											--  , SCM_EQUIPMENT_M  E WITH(NOLOCK)
										 --WHERE  I.COMPANY_ID  = E.COMPANY_ID
										 --AND    I.DIVISION_ID = E.DIVISION_ID
										 --AND    I.SITE_ID     = E.SITE_ID
										 --AND    I.ITEM_ID     = A.PRODID
										 --AND    I.FLOW_ID     = E.OPERATION_ID
										 --AND    E.MES_LINE_ID  = A.ATTRIBUTE8
										 --AND    E.EQUIPMENT_ID = A.ATTRIBUTE9
										 
										 
									   SELECT TOP 1 E.OPERATION_ID
										 FROM SCM_ITEM_M       I WITH(NOLOCK)
											, SCM_EQUIPMENT_M  E WITH(NOLOCK)
											, SCM_FACTORY_M F with(nolock)
										WHERE I.COMPANY_ID		= E.COMPANY_ID
										  AND I.DIVISION_ID		= E.DIVISION_ID
										  AND I.SITE_ID			= E.SITE_ID
										  AND I.ITEM_ID			= A.PRODID
										  AND I.FLOW_ID			= E.OPERATION_ID
										  AND E.MES_LINE_ID		= A.ATTRIBUTE8
										  AND E.EQUIPMENT_ID	= A.ATTRIBUTE9
										  AND E.FACTORY_ID		= F.FACTORY_ID
										  AND E.COMPANY_ID		= F.COMPANY_ID
										  AND E.FACTORY_ID		= A.AREA_ID
										  AND E.PLANT_ID		= F.PLANT_ID
										 
										 )   AS  C_PJT_OPERATION_ID  -- 2018-03-08 kimcd 남경 C 생산으로 전송한 인계 공정
									   ,CASE WHEN A.ATTRIBUTE12 = 'Y' THEN 'REWORK'
									    ELSE ISNULL( B.ATTRIBUTE5,A.ATTRIBUTE4)
										END  AS FP_PRODUCTION_TYPE -- 2021-10-28 kimcd Hazel Pack 재작업 실적 구분자 입수 -- 2018-04-09 kimcd FP 내부 관리 수요 유형 컬럼 추가
										                           -- 2023-01-12 kimcd 전극 FP고도화 I/F 작업 - MES WO MASTER를 OUTER JOIN으로 변경
									   ,A.ATTRIBUTE10 AS WIP_QLTY_TYPE_CODE -- 2018-08-27 kimcd FXXXX공정(활성화), BXXX 공정(포장)양품 Lot 구분자 WIP_QLTY_TYPE_CODE (G/N), N인 경우 수신 제외
									   ,CASE WHEN A.PROD_LOTID = '' THEN NULL ELSE A.PROD_LOTID	END AS PROD_LOTID	-- 2018-11-27 PIYONG ADD
								       ,CASE WHEN A.ATTRIBUTE13 = '' OR A.ATTRIBUTE13 = '-' THEN NULL ELSE A.ATTRIBUTE13 END AS WORK_REQUEST_MODEL_ID	-- 2022-11-01 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
								       ,CASE WHEN A.ATTRIBUTE14 = '' OR A.ATTRIBUTE14 = '-' THEN NULL ELSE A.ATTRIBUTE14 END AS [VERSION]	-- 2022-11-01 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
									   ,A.ATTRIBUTE15 AS PROD_SEQ	-- 2022-11-01 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
									   ,A.ATTRIBUTE16 AS PLM_EC_NO	-- 2022-11-01 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
									   --,case when A.PCSGID = 'A' and LEFT(A.ATTRIBUTE16, 1) IN ('X') then A.ATTRIBUTE16 else null end as PLM_EC_NO
									   ,B.[WORK_REQUEST_MODEL_ID]   AS WO_MODEL_ID -- 2023-01-12 kimcd 전극 FP고도화 I/F 작업 - MES에서 전극 생산 버전을 모델과 버전까지만 회신하기로 하여 수정
									   ,B.[VERSION]                 AS WO_VERSION  -- 2023-01-12 kimcd 전극 FP고도화 I/F 작업 - MES에서 전극 생산 버전을 모델과 버전까지만 회신하기로 하여 수정
									   ,B.[PROD_SEQ]                AS WO_PROD_SEQ -- 2023-01-12 kimcd 전극 FP고도화 I/F 작업 - MES에서 전극 생산 버전을 모델과 버전까지만 회신하기로 하여 수정
								  FROM [dbo].[SY_XIF_MES_DAILY_WIP_HISTORY_R] A
									   LEFT OUTER JOIN FP_MES_PRODUCTION_PLAN_M B WITH(NOLOCK)
										   ON B.WORK_ORDER_SPL_ID = CASE WHEN A.WOID != A.WO_DETL_ID THEN A.WOID ELSE ISNULL(A.WO_DETL_ID, A.WOID) END
										   AND    B.WORK_ORDER_ID = A.WOID

								 WHERE A.WIP_TYPE_CODE IN ( 'INOUT','OUT','PACKED', 'PROD', 'CREATED') -- 2018-05-16 kimcd CREATED 유형 추가. PACKED 는 Pack 포장용	-- PIYONG 2017-08-28 PROD 추가
								   AND ( 
											A.WIPDTTM_ED IS NOT NULL								-- PIYONG 2017-09-08 추가
											OR
											( 
												A.PROCID = 'P5000' AND A.WIPDTTM_ST IS NOT NULL		-- 2018-05-23 PIYONG 조건 추가
											) 
									   )
								   AND A.ATTRIBUTE7 = 'Y'                                  -- 2018-01-06 kimcd 실제 실적이 있는 경우만 취합
								   AND IF_ID       = @IF_ID
								   AND accum_date  = @ACCUM_DATE
							   )  C

						 WHERE C.ROWUMBER = 1
						) B
				 ON (    A.LOTID  = B.LOTID
					 AND A.WIPSEQ = B.WIPSEQ
					 AND A.PROCID = B.PROCID  -- 2019-08-16 kimcd 공정 추가
					 AND A.ATTRIBUTE2 = B.FACTORY_ID ) -- 2019-08-16 kimcd 공장 동 추가
				WHEN MATCHED THEN
					UPDATE SET   A.CALDATE           = B.CALDATE          
								,A.SHIFT             = B.SHIFT            
								,A.PRODID            = B.PRODID           
								,A.BOMREV            = B.BOMREV           
								,A.ROUTID            = B.ROUTID           
								,A.FLOWID            = B.FLOWID           
								,A.PCSGID            = B.PCSGID           
								-- ,A.PROCID            = B.PROCID -- 2019-08-16 kimcd 공정 갱신 막음
								,A.EQSGID            = B.EQSGID           
								,A.EQPTID            = B.EQPTID         
								,A.WIPDTTM_ST		 = B.WIPDTTM_ST
								,A.WIPDTTM_ED		 = B.WIPDTTM_ED
								,A.WIPQTY_ED		 = B.WIPQTY_ED						  
								,A.WOID              = B.WOID             
								,A.WIPQTY2_IN        = B.WIPQTY2_IN       
								,A.WIPQTY2_ST        = B.WIPQTY2_ST       
								,A.WIPQTY2_ED        = B.WIPQTY2_ED       
								,A.WIPQTY2_OT        = B.WIPQTY2_OT       
								,A.WIP_TYPE_CODE     = B.WIP_TYPE_CODE    
								,A.CNFM_DFCT_QTY     = B.CNFM_DFCT_QTY    
								,A.CNFM_LOSS_QTY     = B.CNFM_LOSS_QTY    
								,A.CNFM_PRDT_REQ_QTY = B.CNFM_PRDT_REQ_QTY
								,A.CNFM_DFCT_QTY2     = B.CNFM_DFCT_QTY2    
								,A.CNFM_LOSS_QTY2     = B.CNFM_LOSS_QTY2   
								,A.CNFM_PRDT_REQ_QTY2 = B.CNFM_PRDT_REQ_QTY2
								,A.WIP_NOTE               = B.WIP_NOTE         
								,A.ERP_TRNF_FLAG          = B.ERP_TRNF_FLAG    
								,A.WO_DETL_ID             = B.WO_DETL_ID       
								,A.SCRAP_QTY              = B.SCRAP_QTY 
								,A.MODIFY_USER_ID         = 'PR_XIF_MES_DAILY_WIP_HISTORY_R'
								,A.MODIFY_DATE            = GETDATE()
								,A.COATING_SIDE_TYPE_CODE = B.COATING_SIDE_TYPE_CODE    -- 추가
								,A.WIPQTY2_ENGINE         = B.WIPQTY2_ENGINE            -- 추가
								,A.attribute1             = B.SITE_ID                   -- 추가
								,A.ADD_QTY				  = B.ADD_QTY					-- 2017-06-14 추가
								,A.FORMATION_REWORK_TYPE  = B.FORMATION_REWORK_TYPE		-- 2017-09-15 추가
								,A.MARKET				  = B.MARKET					-- 2017-11-17 ADD
								,A.PRODUCTION_TYPE		  = B.PRODUCTION_TYPE			-- 2017-11-17 ADD
								,A.TOP_ITEM_ID			  = B.TOP_ITEM_ID				-- 2017-11-23 ADD
								,A.YIELD_LOSS_QTY         = B.YIELD_LOSS_QTY            -- 2018-01-10 kimcd 투입 수량 표시하기 위해 YILED에 포하되어야 하는 LOSS 수량 컬럼 추가
								-- ,A.ATTRIBUTE2             = B.FACTORY_ID             -- 2019-08-16 kimcd 공장 동 갱신 막음   -- 2018-03-08 kimcd Factory ID(동) 정보 추가
								,A.ATTRIBUTE3             = B.C_PJT_LINE_ID             -- 2018-03-08 kimcd 생산으로 전송한 인계 라인 C Product 인계라인
								,A.ATTRIBUTE4             = B.C_PJT_EQUIPMENT_ID        -- 2018-03-08 kimcd 생산으로 전송한 인계 설비 C Product 인계설비
								,A.ATTRIBUTE5             = B.C_PJT_OPERATION_ID        -- 2018-03-08 kimcd 남경 C 생산으로 전송한 인계 공정
								,A.ATTRIBUTE6             = B.FP_PRODUCTION_TYPE        -- 2018-04-09 kimcd FP 내부 관리 수요 유형 컬럼 추가
								,A.ATTRIBUTE7			  = B.PROD_LOTID				-- 2018-11-27 PIYONG 컬럼 추가
								,A.[WORK_REQUEST_MODEL_ID] = ISNULL(B.[WORK_REQUEST_MODEL_ID], B.WO_MODEL_ID)  -- 2022-11-01 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
								,A.[VERSION]               = case when B.PCSGID = 'E' then CASE WHEN B.[WORK_REQUEST_MODEL_ID] IS NULL THEN B.WO_VERSION ELSE ISNULL(SUBSTRING(B.VER_SEQ, 1, CHARINDEX('^', B.VER_SEQ)-1), B.WO_VERSION) END 
								                                  when B.PCSGID = 'A' and LEFT(B.VERSION, 1) IN ('X') then B.VERSION 
																  end
								,A.[PROD_SEQ]              = CASE WHEN B.[WORK_REQUEST_MODEL_ID] IS NULL THEN B.WO_PROD_SEQ 
								                                  ELSE CASE WHEN SUBSTRING(B.VER_SEQ, CHARINDEX('^', B.VER_SEQ)+1, LEN(B.VER_SEQ)) = '' THEN NULL ELSE SUBSTRING(B.VER_SEQ, CHARINDEX('^', B.VER_SEQ)+1, LEN(B.VER_SEQ)) END 
																  END 
								,A.[PLM_EC_NO]             = B.[PLM_EC_NO]              -- 

				WHEN NOT MATCHED THEN
					INSERT (  LOTID            
							 ,WIPSEQ           
							 ,CALDATE          
							 ,SHIFT            
							 ,PRODID           
							 ,BOMREV           
							 ,ROUTID           
							 ,FLOWID           
							 ,PCSGID           
							 ,PROCID           
							 ,EQSGID           
							 ,EQPTID    
							 ,WIPDTTM_ST
							 ,WIPDTTM_ED
							 ,WIPQTY_ED				        
							 ,WOID             
							 ,WIPQTY2_IN       
							 ,WIPQTY2_ST       
							 ,WIPQTY2_ED       
							 ,WIPQTY2_OT       
							 ,WIP_TYPE_CODE    
							 ,CNFM_DFCT_QTY    
							 ,CNFM_LOSS_QTY    
							 ,CNFM_PRDT_REQ_QTY
							 ,CNFM_DFCT_QTY2
							 ,CNFM_LOSS_QTY2
							 ,CNFM_PRDT_REQ_QTY2
							 ,WIP_NOTE         
							 ,ERP_TRNF_FLAG    
							 ,WO_DETL_ID       
							 ,SCRAP_QTY
							 ,CREATE_USER_ID
							 ,CREATE_DATE
							 ,MODIFY_USER_ID
							 ,MODIFY_DATE
							 ,COATING_SIDE_TYPE_CODE       -- 추가
							 ,WIPQTY2_ENGINE               -- 추가
							 ,ATTRIBUTE1                   -- 추가
							 ,ADD_QTY					   -- 2017-06-14 추가
							 ,FORMATION_REWORK_TYPE		   -- 2017-09-15 추가
							 ,MARKET					   -- 2017-11-17 ADD
							 ,PRODUCTION_TYPE			   -- 2017-11-17 ADD
							 ,TOP_ITEM_ID				   -- 2017-11-23 ADD
							 ,YIELD_LOSS_QTY               -- 2018-01-10 kimcd 투입 수량 표시하기 위해 YILED에 포하되어야 하는 LOSS 수량 컬럼 추가
							 ,ATTRIBUTE2                   -- 2018-03-08 kimcd Factory ID(동) 정보 추가
							 ,ATTRIBUTE3                   -- 2018-03-08 kimcd 생산으로 전송한 인계 라인 C Product 인계라인
							 ,ATTRIBUTE4                   -- 2018-03-08 kimcd 생산으로 전송한 인계 설비 C Product 인계설비
							 ,ATTRIBUTE5                   -- 2018-03-08 kimcd 남경 C 생산으로 전송한 인계 공정
							 ,ATTRIBUTE6                   -- 2018-04-09 kimcd FP 내부 관리 수요 유형 컬럼 추가. FP_PRODUCTION_TYPE
							 ,ATTRIBUTE7				   -- 2018-11-27 PIYONG 컬럼 추가
							 ,WORK_REQUEST_MODEL_ID        -- 2022-11-01 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
							 ,[VERSION]                    -- 2022-11-01 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
							 ,PROD_SEQ                     -- 2022-11-01 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
							 ,PLM_EC_NO                    -- 
							)
					VALUES ( B.LOTID            
							,B.WIPSEQ           
							,B.CALDATE          
							,B.SHIFT            
							,B.PRODID           
							,B.BOMREV           
							,B.ROUTID           
							,B.FLOWID           
							,B.PCSGID           
							,B.PROCID           
							,B.EQSGID           
							,B.EQPTID    
							,B.WIPDTTM_ST
							,B.WIPDTTM_ED
							,B.WIPQTY_ED					       
							,B.WOID             
							,B.WIPQTY2_IN       
							,B.WIPQTY2_ST       
							,B.WIPQTY2_ED       
							,B.WIPQTY2_OT       
							,B.WIP_TYPE_CODE    
							,B.CNFM_DFCT_QTY    
							,B.CNFM_LOSS_QTY    
							,B.CNFM_PRDT_REQ_QTY
							,B.CNFM_DFCT_QTY2
							,B.CNFM_LOSS_QTY2
							,B.CNFM_PRDT_REQ_QTY2
							,B.WIP_NOTE         
							,B.ERP_TRNF_FLAG    
							,B.WO_DETL_ID       
							,B.SCRAP_QTY
							,'PR_XIF_MES_DAILY_WIP_HISTORY_R'
							,GETDATE()
							,'PR_XIF_MES_DAILY_WIP_HISTORY_R'
							,GETDATE()
							,B.COATING_SIDE_TYPE_CODE  -- 추가
							,B.WIPQTY2_ENGINE          -- 추가
							,B.SITE_ID                 -- 추가
							,B.ADD_QTY					-- 2017-06-14 추가
							,B.FORMATION_REWORK_TYPE	-- 2017-09-15 추가
							,B.MARKET					-- 2017-11-16 ADD
							,B.PRODUCTION_TYPE			-- 2017-11-16 ADD
							,B.TOP_ITEM_ID			    -- 2017-11-23 ADD
							,B.YIELD_LOSS_QTY           -- 2018-01-10 kimcd 투입 수량 표시하기 위해 YILED에 포하되어야 하는 LOSS 수량 컬럼 추가
							,B.FACTORY_ID               -- 2018-03-08 kimcd Factory ID(동) 정보 추가
							,B.C_PJT_LINE_ID            -- 2018-03-08 kimcd 생산으로 전송한 인계 라인 C Product 인계라인
							,B.C_PJT_EQUIPMENT_ID       -- 2018-03-08 kimcd 생산으로 전송한 인계 설비 C Product 인계설비
							,B.C_PJT_OPERATION_ID       -- 2018-03-08 kimcd 남경 C 생산으로 전송한 인계 공정
							,B.FP_PRODUCTION_TYPE       -- 2018-04-09 kimcd FP 내부 관리 수요 유형 컬럼 추가 ATTRIBUTE6
							,B.PROD_LOTID				-- 2018-11-27 PIYONG 컬럼 추가
							,ISNULL(B.[WORK_REQUEST_MODEL_ID], B.WO_MODEL_ID)  
							,case when B.PCSGID = 'E' then CASE WHEN B.[WORK_REQUEST_MODEL_ID] IS NULL THEN B.WO_VERSION ELSE ISNULL(SUBSTRING(B.VER_SEQ, 1, CHARINDEX('^', B.VER_SEQ)-1), B.WO_VERSION) END 
							      when B.PCSGID = 'A' and LEFT(B.VERSION, 1) IN ('X') then B.VERSION 
								  end
							,CASE WHEN B.[WORK_REQUEST_MODEL_ID] IS NULL THEN B.WO_PROD_SEQ 
							      ELSE CASE WHEN SUBSTRING(B.VER_SEQ, CHARINDEX('^', B.VER_SEQ)+1, LEN(B.VER_SEQ)) = '' THEN NULL ELSE SUBSTRING(B.VER_SEQ, CHARINDEX('^', B.VER_SEQ)+1, LEN(B.VER_SEQ)) END 
							      END -- PROD_SEQ
							,B.PLM_EC_NO                
							)
				;

			   SET @v_temp3 = '1112'

			UPDATE [dbo].[SY_XIF_MES_DAILY_WIP_HISTORY_R]
			   SET PROC_FLAG    = 'P'						--2017-12-11 PIYONG  Y -> P 로 변경
				  ,PROC_DATE    = GETDATE()
			 WHERE IF_ID        = @IF_ID  
			   AND ACCUM_DATE   = @ACCUM_DATE
			   AND PROC_FLAG    = 'N'
			;

			FETCH NEXT FROM CUR_IF_MES_WIPHIST INTO  @IF_ID        
												  ,@ACCUM_DATE
												  ,@SITE_ID  -- 2020-10-08 kimcd Site ID를 동 사용하여 조회
												  ;



		  END;
		  CLOSE CUR_IF_MES_WIPHIST;
		  DEALLOCATE CUR_IF_MES_WIPHIST;   


			-----------------------------------------------------------------------------------------------------------------------------
			--2017-12-11 piyong ---------------------------------------------------------------------------------------------------------
			-----------------------------------------------------------------------------------------------------------------------------


			-----------------------------------------------------------------------------------------------------------------------------
			-- 2019-09-11 PIYONG ADD
			INSERT INTO #XIF_MES_DAILY_WIP_HISTORY_TEMP_FACTORY
			SELECT DISTINCT F.FACTORY_ID
			  FROM [dbo].[SY_XIF_MES_DAILY_WIP_HISTORY_R] XIF (NOLOCK)
				   , SCM_FACTORY_M F (NOLOCK)
				   , SCM_SYS_LOOKUP_VALUE L (NOLOCK)
			 WHERE XIF.PROC_FLAG		= 'P'
			   AND XIF.ACCUM_COUNT		> 0
			   -- AND F.MES_SOURCE_GROUP	= SUBSTRING( XIF.IF_ID, 1, 4) 2020-10-08 kimcd 조건 주석 처리 - CMI Hazel Park 예외 처리용(I/F ID가 hard coding 됨)
			   AND F.FACTORY_ID			= ISNULL( XIF.AREA_ID, SUBSTRING( XIF.EQSGID, 1, 2) )
			   AND F.ACTIVE_FLAG		= 'Y'
			   AND F.PLANT_ID			= L.SEGMENT1
			   AND L.[LOOKUP_TYPE_CODE]	= 'BASIS_START_TIME_PLANT'
			   AND L.ACTIVE_FLAG		= 'Y'
			-- 2019-09-11 PIYONG ADD
			-----------------------------------------------------------------------------------------------------------------------------


			DECLARE CUR_IF_SITE CURSOR FOR
				SELECT DISTINCT SITE_ID -- ( SELECT DISTINCT Z.SITE_ID FROM SCM_FACTORY_M Z WHERE MES_SOURCE_GROUP = SUBSTRING(IF_ID,1,4) ) SITE_ID 2020-10-08 kimcd 임시 Table에 Site Id 컬럼 추가
				  FROM #XIF_MES_DAILY_WIP_HISTORY_UPDATE_INFO					-- 2020-02-04 PIYONG  CHANGE [SY_XIF_MES_DAILY_WIP_HISTORY_R] --> #XIF_MES_DAILY_WIP_HISTORY_UPDATE_INFO
			;

			OPEN CUR_IF_SITE
			FETCH NEXT FROM CUR_IF_SITE INTO  @SITE_ID
												  ;
			WHILE (@@FETCH_STATUS = 0)
			BEGIN
/*			--2019-05-10 PIYONG DEL

				-- [SCM_PRODUCT_RESULT_H] 에 data inesrt
				-- 기존 data 삭제 처리 
				DELETE
				  FROM [dbo].[SCM_PRODUCT_RESULT_H]
				 WHERE CUTOFF_DATE = CAST(GETDATE() AS DATE)
				   AND UPDATE_ID   = 'PR_XIF_MES_DAILY_WIP_HISTORY_R'
				   AND SITE_ID     = @SITE_ID
				;

				
				SET @BASE_HOUR = (	
								 SELECT TOP 1 SUBSTRING(SEGMENT2, 1, 2)
								   FROM [DBO].[SCM_SYS_LOOKUP_VALUE] V  WITH(NOLOCK)
										,[DBO].[SCM_FACTORY_M] F
								  WHERE V.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
									AND V.ACTIVE_FLAG = 'Y'
									AND V.SEGMENT1 = F.PLANT_ID
									AND F.SITE_ID = @SITE_ID
								 )

				SET @v_table = 'DELETE FROM [dbo].[SCM_PRODUCT_RESULT_H]'
				INSERT INTO [dbo].[SCM_PRODUCT_RESULT_H]
						   ([COMPANY_ID]
						   ,[DIVISION_ID]
						   ,[SITE_ID]
						   ,[PLANT_ID]
						   ,[FACTORY_ID]
						   ,[CUTOFF_DATE]
						   ,[SEQ]
						   ,[ITEM_ID]
						   ,[OPERATION_ID]
						   ,[LINE_ID]
						   ,[WORK_CENTER_ID]
						   ,[QTY]
						   ,[QTY_LANE]
						   ,WIPQTY2_ENGINE			-- 추가
						   ,DFCT_QTY2				-- 추가
						   ,LOSS_QTY2				-- 추가
						   ,PRDT_REQ_QTY2			-- 추가 
						   ,TOP_COATING_QTY2		-- 추가
						   ,ADD_QTY					--2017-06-14 추가
						   ,[PRODUCT_DATE]
						   ,[PRODUCTION_TYPE]
						   ,[DESCRIPTION]
						   ,[MARKET]                -- 2017-12-27 kimcd 수출/내수 구분하여 실적 취합
						   ,[YIELD_LOSS_QTY]        -- 2018-01-10 kimcd 투입 수량 표시하기 위해 YILED에 포하되어야 하는 LOSS 수량 컬럼 추가
						   ,[FP_PRODUCTION_TYPE]    -- 2018-04-09 kimcd FP 내부 관리용 수요유형
						   ,[INSERT_ID]
						   ,[INSERT_TIME]
						   ,[UPDATE_ID]
						   ,[UPDATE_TIME])
					 SELECT COMPANY_ID                                                                                                                                           
							,DIVISION_ID                                                                                                                                       
							,SITE_ID                                                                                                                                               
							,PLANT_ID                                                                                                                                          
							,FACTORY_ID
							,CUTOFF_DATE
							,ROW_NUMBER() OVER( ORDER BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID,FACTORY_ID, CUTOFF_DATE) AS SEQ
							,ITEM_ID
							,OPERATION_ID  
							,LINE_ID 
							,WORK_CENTER_ID                                                                                                                         
							,QTY
							,QTY_LANE         
							,WIPQTY2_ENGINE        -- 추가
							,CNFM_DFCT_QTY2        -- 추가
							,CNFM_LOSS_QTY2        -- 추가
							,CNFM_PRDT_REQ_QTY2    -- 추가 
							,TOP_COATING_QTY2      -- 추가
							,ADD_QTY				-- 2017-06-14 추가
							,PRODUCT_DATE
							,PRODUCTION_TYPE
							,DESCRIPTION
							,MARKET                -- 2017-12-27 kimcd 수출/내수 구분하여 실적 취합
							,YIELD_LOSS_QTY        -- 2018-01-10 kimcd 투입 수량 표시하기 위해 YILED에 포하되어야 하는 LOSS 수량 컬럼 추가
							,FP_PRODUCTION_TYPE    -- 2018-04-09 kimcd FP 내부 관리용 수요 유형
							,INSERT_ID
							,INSERT_TIME
							,UPDATE_ID
							,UPDATE_TIME	        
					   FROM (SELECT ISNULL(L.COMPANY_ID, C.COMPANY_ID)  AS  COMPANY_ID                                                                                                                                           
									,ISNULL(L.DIVISION_ID, C.DIVISION_ID)  AS DIVISION_ID                                                                                                                                       
									,ISNULL(L.SITE_ID, C.SITE_ID) AS SITE_ID                                                                                                                                               
									,ISNULL(L.PLANT_ID, C.PLANT_ID) AS PLANT_ID                                                                                                                                          
									,ISNULL(L.FACTORY_ID, C.FACTORY_ID) AS FACTORY_ID
									,CAST(GETDATE() AS DATE) AS CUTOFF_DATE
									,PRODID AS ITEM_ID
									,PROCID AS OPERATION_ID  
								--	,ISNULL(L.LINE_ID, c.line_id) AS LINE_ID 
								    ,ISNULL(L.LINE_ID ,ISNULL((    select top 1 lm.line_id
																	   from scm_line_m lm
																		   ,scm_equipment_m em
																	  where lm.line_id = em.line_id
																		and em.mes_line_id = U.EQSGID
																		and (CASE WHEN U.PROCID IN ( 'E1000','E2000','E2300','E2500','E3000','E8000','E4000', 'A5000' ,'A6000' ) THEN 
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
																	), U.EQSGID) ) as  LINE_ID 
									,L.WORK_CENTER_ID                                                                                                                         
									,SUM(WIPQTY_ED) AS QTY
									,SUM(WIPQTY2_ED) AS QTY_LANE                                                                                                                                                  
									,cal_wipdttm_ed AS PRODUCT_DATE
									,U.PRODUCTION_TYPE
									,NULL DESCRIPTION
									,U.MARKET  -- 2017-12-27 kimcd group by 추가
									,'PR_XIF_MES_DAILY_WIP_HISTORY_R' AS INSERT_ID
									,GETDATE() AS INSERT_TIME
									,'PR_XIF_MES_DAILY_WIP_HISTORY_R' AS UPDATE_ID
									,GETDATE() AS UPDATE_TIME	          
									,SUM(WIPQTY2_ENGINE)     AS WIPQTY2_ENGINE			-- 추가
									,SUM(CNFM_DFCT_QTY2)     AS CNFM_DFCT_QTY2			-- 추가
									,SUM(CNFM_LOSS_QTY2)     AS CNFM_LOSS_QTY2			-- 추가
									,SUM(CNFM_PRDT_REQ_QTY2) AS CNFM_PRDT_REQ_QTY2		-- 추가
									,SUM(TOP_COATING_QTY2)   AS TOP_COATING_QTY2		-- 추가
									,SUM(ADD_QTY)		  	 AS ADD_QTY					-- 2017-06-14 추가
									,SUM(YIELD_LOSS_QTY)     AS YIELD_LOSS_QTY          -- 2018-01-10 kimcd 투입 수량 표시하기 위해 YILED에 포하되어야 하는 LOSS 수량 컬럼 추가
									,U.FP_PRODUCTION_TYPE    AS FP_PRODUCTION_TYPE      -- 2018-04-09 kimcd fp 내부 관리용 수요 유형 추가 
							   FROM (SELECT --CALDATE
											/*CASE WHEN SUBSTRING( CONVERT(VARCHAR,CAST(WIPDTTM_ED AS DATETIME),120), 12,2) < @BASE_HOUR THEN
													CAST( CONVERT( VARCHAR, DATEADD(DD,-1,WIPDTTM_ED), 112) AS DATETIME )
											     ELSE
													CAST( CONVERT( VARCHAR,CAST(WIPDTTM_ED AS DATETIME),112) AS DATETIME )
												 END kimcd 2017-09-06 wipdttm_ed -> caldate로 컬럼 변경 block*/

--							                 ,case when substring( convert(varchar,cast(WIPDTTM_ED as datetime),120), 12,2) < '06' and @SITE_ID = 'A001' then cast( convert( varchar, dateadd(DD,-1,WIPDTTM_ED), 112) as datetime ) 
--											      when substring( convert(varchar,cast(WIPDTTM_ED as datetime),120), 12,2) < '08' and @SITE_ID = 'A002' then cast( convert( varchar, dateadd(DD,-1,WIPDTTM_ED), 112) as datetime ) 
--												  when substring( convert(varchar,cast(WIPDTTM_ED as datetime),120), 12,2) < '07' and @SITE_ID = 'A003' then cast( convert( varchar, dateadd(DD,-1,WIPDTTM_ED), 112) as datetime ) 
--											      else cast( convert( varchar,cast(WIPDTTM_ED as datetime),112) as datetime ) end
											 
											CAST( CONVERT( VARCHAR,CAST(CALDATE AS DATETIME),112) AS DATETIME ) -- kimcd 2017-09-06 add caldate
													  AS cal_wipdttm_ed          -- 추가
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
											,CASE WHEN W.WIP_TYPE_CODE = 'PROD' THEN 0 ELSE W.WIPQTY_ED END      AS WIPQTY_ED
											,CASE WHEN W.WIP_TYPE_CODE = 'PROD' THEN 0 ELSE W.WIPQTY2_ED END     AS WIPQTY2_ED
											,CASE WHEN W.WIP_TYPE_CODE = 'PROD' THEN 0 ELSE W.WIPQTY2_ENGINE END AS WIPQTY2_ENGINE         -- 추가
											 -- 2018-04-02 kimcd wip_type_code가 PROD인 경우 WIPQTY_ED, WIPQTY2_ED, WIPQTY2_ENGINE 3개 컬럼의 값을 0으로 치환 끝
											,COATING_SIDE_TYPE_CODE -- 추가
											,CNFM_DFCT_QTY2         -- 추가
											,CNFM_LOSS_QTY2         -- 추가
											,CNFM_PRDT_REQ_QTY2     -- 추가
											,ADD_QTY				-- 2017-06-14  추가
											,W.MARKET               -- 2017-12-27 kimcd 수출/내수 구분하여 실적 집계
											,W.YIELD_LOSS_QTY       -- 2018-01-10 kimcd 투입 수량 표시하기 위해 YILED에 포하되어야 하는 LOSS 수량 컬럼 추가
											,CASE WHEN COATING_SIDE_TYPE_CODE = 'T' THEN WIPQTY2_ED ELSE 0 END TOP_COATING_QTY2  -- 추가
											,W.PRODUCTION_TYPE		-- PRODUCTION_TYPE WO를 연결해서 WO의 PRODUCTION TYPE을 구함.  --2017-11-17 PIYONG 수신 컬럼으로 변경
											,ISNULL(W.ATTRIBUTE6,W.PRODUCTION_TYPE) AS FP_PRODUCTION_TYPE -- 2018-04-09 kimcd FP 내부 수요 관리용. 수요 유형 추가
                                            ,(SELECT TOP 1 A.DIVISION_ID                                                                                                                       
												FROM [DBO].[FP_PRODUCTION_PLAN_R] A with(nolock)                                                                                                  
											    WHERE A.WORK_ORDER_ID = W.WOID
												  AND A.PRODUCTION_TYPE IS NOT NULL
												  ORDER BY FP_PLAN_ID DESC  ) DIVISION_CODE												                                                                                 
									    FROM [dbo].[SCM_MES_WIP_HISTORY_H] W -- 2018-01-06 kimcd with(nolock) 제거
									--   WHERE CAST(CALDATE AS DATE) >= CAST(DATEADD(DD,-7, GETDATE()) AS DATE)
									   -- wipdttm_ed 일자 기준으로 일주일의 실적을 가져옴.
									   WHERE CAST( WIPDTTM_ED AS DATETIME) >= CAST(DATEADD(DD, -23/*-16 -9*/ , GETDATE()) AS DATE) -- CUTOFF 실적 생성 구간 늘림. 170516,  최기주수석 요청170524 
										 AND W.WIP_TYPE_CODE IN ( 'INOUT','OUT' ,'PACKED', 'PROD') -- PACKED 는 Pack 포장용	-- PIYONG 2017-08-28 PROD 추가
										 -- AND W.WIPQTY_ED > 0   -- 2018-01-10 kimcd 조건 제거. 투입 수량 표시하기 위해 양품 수량이 없는 경우도 취합.
										 AND (W.FORMATION_REWORK_TYPE <> 'Y' OR W.FORMATION_REWORK_TYPE IS NULL)										-- PIYONG 2017-09-15 조건 추가
										 AND W.ATTRIBUTE1 = @SITE_ID
									) U                                                                                                                                                     
						      left outer JOIN [DBO].[SCM_EQUIPMENT_M] L WITH(NOLOCK) 
								   ON U.EQPTID  = L.EQUIPMENT_ID
								   -- modify 2017.05.15 설비는 다 E7 이나 자동차는 E8 이고 소형은 E7 임 
								   -- and substring(u.EQSGID,1,2)  =  L.FACTORY_ID
								   and  substring(u.EQSGID,1,2)  =  L.FACTORY_ID					-- 2018-11-16 PIYONG E8동이 없어지면서 관련 로직 제거
								   -- and substring(L.MES_LINE_ID,1,2)  =  L.FACTORY_ID -- 남경에 전극 설비가 planning을 위해서 여러 building에 속해져 있음.
								   and L.MES_LINE_ID = U.EQSGID  -- kimcd add 2017-08-09 설비 중복 등록 예방
								   and L.DIVISION_ID =  ISNULL(U.DIVISION_CODE, L.DIVISION_ID )		-- 2018-11-16 PIYONG E8동이 없어지면서 관련 로직 제거
								   and u.procid = l.OPERATION_ID  -- 하나의 설비가 여러 공정에 속할 수 있다고 함.
                              -- 설비가 우리쪽에 없는 case에 대해서 company,division을 찾기 위함.
							  left outer JOIN (SELECT A.COMPANY_ID
														, A.DIVISION_ID
														, A.SITE_ID
														, A.PLANT_ID
														, A.FACTORY_ID
														, A.OPERATION_ID
														, A.MES_LINE_ID
														,MAX( A.LINE_ID) AS LINE_ID
												--		,ELECTRODE_TYPE
													FROM [DBO].SCM_EQUIPMENT_M A WITH(NOLOCK) 
													GROUP BY A.COMPANY_ID
														, A.DIVISION_ID
														, A.SITE_ID
														, A.PLANT_ID
														, A.FACTORY_ID
														, A.OPERATION_ID
														, A.MES_LINE_ID
												--	    , A.ELECTRODE_TYPE
												   ) C
							       ON  U.EQSGID =  C.MES_LINE_ID
								   and u.procid = C.OPERATION_ID
								   and c.DIVISION_ID =  ISNULL(U.DIVISION_CODE,  c.DIVISION_ID )		-- 2018-11-16 PIYONG E8동이 없어지면서 관련 로직 제거
								   and substring(U.EQSGID,1,2)  =  C.FACTORY_ID
							--	 WHERE U.CALDATE IS NOT NULL
								 WHERE U.cal_wipdttm_ed IS NOT NULL
			 				--	   AND C.SITE_ID = @SITE_ID
								   AND U.cal_wipdttm_ed >= CAST(DATEADD(DD, -21/*-14  -7*/ , GETDATE()) AS DATE) -- cutoff 실적 생성 구간 늘림. 170516 최기주수석 요청170524 
								   AND ISNULL(L.COMPANY_ID, C.COMPANY_ID) IS NOT NULL

								 GROUP BY ISNULL(L.COMPANY_ID, C.COMPANY_ID)                                                                                                                                             
									   ,ISNULL(L.DIVISION_ID, C.DIVISION_ID)                                                                                                                                         
									   ,ISNULL(L.SITE_ID, C.SITE_ID)                                                                                                                                                
									   ,ISNULL(L.PLANT_ID, C.PLANT_ID)                                                                                                                                           
									   ,ISNULL(L.FACTORY_ID, C.FACTORY_ID)
									--   ,CALDATE        
									   ,cal_wipdttm_ed                                                                                                                                         
									   ,PRODID                                                                                                                                                  
									   ,PROCID
									--   ,ISNULL(L.LINE_ID, c.line_id)
									   ,L.LINE_ID
									   ,U.EQSGID
			  						   ,l.WORK_CENTER_ID                                                                                                                                          
									   ,PRODUCTION_TYPE
									   ,U.MARKET  -- 2017-12-27 kimcd 수출/내수 구분하여 실적 집계
									   ,U.FP_PRODUCTION_TYPE -- 2018-04-09 kimcd FP 내부 관리용 수요 유형
							)A
				;

*/
           -- [FP_MES_PRODUCTION_PLAN_M] value update
		--------------------------------------------------------------------------------------------------------------------------------------------------------
/*			--2017-11-24 PIYONG 
		    SET @v_table = 'UPDATE [FP_MES_PRODUCTION_PLAN_M]'
			UPDATE A
				SET  ACTUAL_QTY		    = ISNULL(B.ACTUAL_QTY, 0)
				    ,ACTUAL_GOOD_QTY    = ISNULL(B.ACTUAL_GOOD_QTY, 0)
				    ,ACTUAL_SCRAP_QTY	= ISNULL(B.ACTUAL_SCRAP_QTY, 0)
					,WO_STATUS          = CASE WHEN ISNULL(A.PLAN_QTY, 0) < ISNULL(B.ACTUAL_QTY, 0) THEN 'CLOSE'
					                      ELSE 'OPEN'
										   END
					,UPDATE_ID          = 'PR_XIF_MES_DAILY_WIP_HISTORY_R'
					,UPDATE_TIME        = GETDATE()
			FROM [DBO].[FP_MES_PRODUCTION_PLAN_M] A 
					,(SELECT A.WOID
							, A.WO_DETL_ID
							, A.PRODID
							, MAX(CONVERT(NVARCHAR, MODIFY_DATE, 112))															AS MODIFY_DATE
							, CAST(MAX(A.[CALDATE]) AS DATETIME)																AS CUTOFF_DATE
							, MAX(CAST(A.WIPDTTM_ST  AS DATETIME))																AS ACTUAL_START_TIME
							, MAX(CAST(A.WIPDTTM_ED  AS DATETIME))																AS ACTUAL_END_TIME
							, ISNULL( SUM(ISNULL(A.WIPQTY2_ED,0))
										+ SUM(ISNULL(CONVERT(NUMERIC(14,3), A.CNFM_DFCT_QTY2),0)) 
										+ SUM(ISNULL(CONVERT(NUMERIC(14,3), A.CNFM_LOSS_QTY2),0)) 
										+ SUM(ISNULL(CONVERT(NUMERIC(14,3), A.CNFM_PRDT_REQ_QTY2),0))
										+ SUM(ISNULL(CAST(A.SCRAP_QTY AS NUMERIC(14,3)),0))
									,0)																	               			AS ACTUAL_QTY
							, ISNULL(SUM(A.WIPQTY2_ED),0)                                             							AS ACTUAL_GOOD_QTY
							, ISNULL(ISNULL(SUM(CONVERT(NUMERIC(14,3), A.CNFM_DFCT_QTY2)) ,0)
										+ ISNULL(SUM(CONVERT(NUMERIC(14,3), A.CNFM_LOSS_QTY2)) ,0)
										+ ISNULL(SUM(CONVERT(NUMERIC(14,3), A.CNFM_PRDT_REQ_QTY2)) ,0)
										+ ISNULL(SUM(CAST(A.SCRAP_QTY AS NUMERIC(14,3))) ,0) ,0)								AS ACTUAL_SCRAP_QTY
					    FROM [DBO].[SCM_MES_WIP_HISTORY_H] A WITH(NOLOCK)
						-- 조건 변경
					    WHERE cast( WIPDTTM_ED as datetime) >= CAST(DATEADD(DD,-7, GETDATE()) AS DATE)
						  AND A.ATTRIBUTE1 = @SITE_ID
					    GROUP BY A.WOID, A.WO_DETL_ID, A.PRODID
					) B
			WHERE A.WORK_ORDER_ID      = B.WOID
		      AND A.WORK_ORDER_SPL_ID  = B.WO_DETL_ID    
			  AND A.ITEM_ID            = B.PRODID
			  AND A.SITE_ID            = @SITE_ID
			  */
		--------------------------------------------------------------------------------------------------------------------------------------------------------
				IF OBJECT_ID('tempdb..#SCM_MES_WIP_HISTORY_H') IS NOT NULL -- 2022-05-10 kimcd 임시 Table 삭제
					DROP TABLE #SCM_MES_WIP_HISTORY_H

			   SET @v_temp3 = '2222'


				--  2022-05-10 kimcd 임시 정보 형성 시작
				SELECT U.CAL_WIPDTTM_ED
					 , U.PRODID
					 , U.EQSGID
					 , U.PROCID
					 , U.EQPTID
					 , SUM(U.WIPQTY_ED)          AS WIPQTY_ED
					 , SUM(U.WIPQTY2_ED)         AS WIPQTY2_ED
					 , SUM(U.WIPQTY2_ENGINE)     AS WIPQTY2_ENGINE
					 , U.COATING_SIDE_TYPE_CODE
					 , SUM(U.CNFM_DFCT_QTY2)     AS CNFM_DFCT_QTY2
					 , SUM(U.CNFM_LOSS_QTY2)     AS CNFM_LOSS_QTY2
					 , SUM(U.CNFM_PRDT_REQ_QTY2) AS CNFM_PRDT_REQ_QTY2
					 , SUM(CAST(U.SCRAP_QTY AS NUMERIC(14,3)))          AS SCRAP_QTY
					 , SUM(U.YIELD_LOSS_QTY)     AS YIELD_LOSS_QTY
					 , SUM(U.TOP_COATING_QTY2)   AS TOP_COATING_QTY2
					 , U.PRODUCTION_TYPE
					 , U.FP_PRODUCTION_TYPE
                     , U.DIVISION_CODE
					 , U.MARKET
					 , U.TOP_ITEM_ID
					 , U.ATTRIBUTE5
					 , U.FACTORY_ID  -- 2022-08-11 kimcd 설비 없는 실적 수집용 추가
					 , U.WORK_REQUEST_MODEL_ID    -- 2022-11-01 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
					 , U.[VERSION]                -- 2022-11-01 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
					 , U.PROD_SEQ                 -- 2022-11-01 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
					 , U.PLM_EC_NO                -- 2022-11-01 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
				INTO   #SCM_MES_WIP_HISTORY_H
				FROM  (SELECT CAST( CONVERT( VARCHAR,CAST(CALDATE AS DATETIME),112) AS DATETIME ) AS CAL_WIPDTTM_ED
							, PRODID
							, CASE WHEN W.ATTRIBUTE5 IS NOT NULL THEN
									ISNULL(W.ATTRIBUTE3, W.EQSGID)
							  ELSE
									W.EQSGID
							  END                   AS EQSGID -- 2018-03-08 kimcd 남경 재작업 생산(C Product)의 경우 인계 라인을 찾아서 넣음.                                                                                                                                                   
							, CASE WHEN W.ATTRIBUTE5 IS NOT NULL THEN
									W.ATTRIBUTE5
							  ELSE
									W.PROCID
							  END                   AS PROCID -- 2018-03-08 kimcd 남경 재작업 생산(C Product)의 경우 인계 라인의 공정을 찾아서 넣음.
							, CASE WHEN W.ATTRIBUTE5 IS NOT NULL THEN 
									ISNULL(W.ATTRIBUTE4,W.EQPTID)
							  ELSE
									W.EQPTID
							  END                   AS EQPTID -- 2018-03-08 kimcd 남경 재작업 생산(C Product)의 경우 인계 설비를 찾아서 넣음.
								-- 2018-04-02 kimcd wip_type_code가 PROD인 경우 WIPQTY_ED, WIPQTY2_ED, WIPQTY2_ENGINE 3개 컬럼의 값을 0으로 치환 시작
							, CASE WHEN W.WIP_TYPE_CODE = 'PROD' THEN 0 ELSE W.WIPQTY_ED END      AS WIPQTY_ED
							, CASE WHEN W.WIP_TYPE_CODE = 'PROD' THEN 0 ELSE W.WIPQTY2_ED END     AS WIPQTY2_ED
							, CASE WHEN W.WIP_TYPE_CODE = 'PROD' THEN 0 ELSE W.WIPQTY2_ENGINE END AS WIPQTY2_ENGINE         -- 추가
								-- 2018-04-02 kimcd wip_type_code가 PROD인 경우 WIPQTY_ED, WIPQTY2_ED, WIPQTY2_ENGINE 3개 컬럼의 값을 0으로 치환 끝
							, COATING_SIDE_TYPE_CODE
							, CNFM_DFCT_QTY2
							, CNFM_LOSS_QTY2
							, CNFM_PRDT_REQ_QTY2
							, SCRAP_QTY
							, W.YIELD_LOSS_QTY                 -- 2018-01-23 kimcd 투입 수량 표시하기 위해 YILED에 포하되어야 하는 LOSS 수량 컬럼 추가
							, CASE WHEN COATING_SIDE_TYPE_CODE = 'T' AND SUBSTRING ( PRODID, 4 ,2 ) != 'CS' THEN WIPQTY2_ED ELSE 0 END TOP_COATING_QTY2  -- 2018-01-23 kimcd top coding 수량 추가	--2019-08-02 PIYONG  AND SUBSTRING (PRODID, 4 ,2 )  != 'CS' ADD 
							, W.PRODUCTION_TYPE
							, ISNULL(W.ATTRIBUTE6, W.PRODUCTION_TYPE) AS FP_PRODUCTION_TYPE -- 2018-04-09 kimcd FP_PRODUCTION_TYPE. FP 내부 관리용 수요 유형 추가
							, ( SELECT TOP 1 A.DIVISION_ID                                                                                                                       
								FROM   [DBO].[FP_MES_PRODUCTION_PLAN_M] A with(nolock)                                                                                                  
								WHERE  A.WORK_ORDER_ID     = W.WOID
								AND    A.WORK_ORDER_SPL_ID = W.WOID
								AND    A.PRODUCTION_TYPE IS NOT NULL)  AS DIVISION_CODE
							, W.MARKET
							, W.TOP_ITEM_ID
							, W.ATTRIBUTE5																--2018-03-26 PIYONG APPLIED_MODEL 값을 찾기 위해 추가, DIVISION_ID를 조회문 밖에서 구해야 함
							, W.ATTRIBUTE2 AS FACTORY_ID  -- 2022-08-11 kimcd 설비 없는 실적 수집용 추가
							, ISNULL(W.WORK_REQUEST_MODEL_ID,'-') AS WORK_REQUEST_MODEL_ID -- 2022-11-01 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
					 		, ISNULL(W.[VERSION],'-')             AS VERSION               -- 2022-11-01 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
					 		, ISNULL(W.PROD_SEQ,'-')              AS PROD_SEQ              -- 2022-11-01 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
					 		, ISNULL(W.PLM_EC_NO,'-')             AS PLM_EC_NO             -- 2022-11-01 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
					   FROM  [dbo].[SCM_MES_WIP_HISTORY_H] W -- 2018-01-06 kimcd with(nolock) 제거                                                                                                                
					   WHERE CAST( WIPDTTM_ED AS DATETIME) >= CAST(DATEADD(DD, -40, GETDATE()) AS DATE)  -- -21 to -38
					   AND   W.WIP_TYPE_CODE IN ( 'INOUT','OUT' ,'PACKED', 'PROD')
					   AND   (W.FORMATION_REWORK_TYPE <> 'Y' OR W.FORMATION_REWORK_TYPE IS NULL)
					   AND   PROCID != 'F6000'															-- 2018-01-17 PIYONG 활성화 공정 제외
					   AND   W.ATTRIBUTE1 = @SITE_ID
					   AND   W.ATTRIBUTE2 IN ( SELECT FACTORY_ID FROM #XIF_MES_DAILY_WIP_HISTORY_TEMP_FACTORY )	) U
				GROUP BY U.CAL_WIPDTTM_ED
						,U.ATTRIBUTE5
						,U.PRODID
						,U.TOP_ITEM_ID
						,U.PRODID
						,U.PROCID
						,U.EQSGID
						,U.EQPTID
						,U.COATING_SIDE_TYPE_CODE
						,U.PRODUCTION_TYPE
						,U.FP_PRODUCTION_TYPE
						,U.MARKET
						,U.DIVISION_CODE
						,U.FACTORY_ID  -- 2022-08-11 kimcd 설비 없는 실적 수집용 추가
						,U.WORK_REQUEST_MODEL_ID         -- 2022-11-01 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
					    ,U.[VERSION]                     -- 2022-11-01 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
					    ,U.PROD_SEQ                      -- 2022-11-01 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
					    ,U.PLM_EC_NO                     -- 2022-11-01 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
				--  2022-05-10 kimcd 임시 정보 형성 끝

			-- 2017-11-16 PIYONG

			   SET @v_temp3 = '3333'


			SET @v_table = 'MERGE [dbo].[SCM_DAILY_PRODUCT_RESULT_H]'
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
							,MIN(LOCATION) AS LOCATION  -- 2018-02-01 kimcd LOCATION 컬럼 KEY에서 제거							
							,MAX(PRODUCTION_TYPE) AS PRODUCTION_TYPE -- 2018-04-09 kimcd FP_PRODUCTION_TYPE 추가에 따른 GROUP BY 대상에서 제외
							,FP_PRODUCTION_TYPE                      -- 2018-04-09 kimcd FP_PRODUCTION_TYPE. FP 내부 관리용 수요 유형을 GROUP BY 단위로 추가
							,MARKET
							,LINE_ID
							,ELECTRODE_TYPE
							,EQUIPMENT_ID -- 2018-02-23 kimcd add 설비 정보
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
							,'PR_XIF_MES_DAILY_WIP_HISTORY_R' AS INSERT_ID
							,GETDATE() AS INSERT_TIME
							,'PR_XIF_MES_DAILY_WIP_HISTORY_R' AS UPDATE_ID
							,GETDATE() AS UPDATE_TIME
						    -- 2018-01-23 kimcd 수량 상세 정보 추가 시작
						    ,SUM(ISNULL([WIPQTY_ED],0))             AS QTY
						    ,SUM(ISNULL([WIPQTY2_ED],0))            AS QTY_LANE
						    ,SUM(ISNULL([CNFM_DFCT_QTY2],0))        AS DFCT_QTY2
						    ,SUM(ISNULL([CNFM_LOSS_QTY2],0))        AS LOSS_QTY2
						    ,SUM(ISNULL([CNFM_PRDT_REQ_QTY2],0))    AS PRDT_REQ_QTY2
						    ,SUM(ISNULL([TOP_COATING_QTY2],0))      AS TOP_COATING_QTY2
						    ,SUM(ISNULL([YIELD_LOSS_QTY],0))        AS YIELD_LOSS_QTY
							,WORK_REQUEST_MODEL_ID                     -- 2022-11-01 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
					        ,[VERSION]                                 -- 2022-11-01 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
					        ,PROD_SEQ                                  -- 2022-11-01 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
					        ,PLM_EC_NO                                 -- 2022-11-01 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
						    -- 2018-01-23 kimcd 수량 상세 정보 추가 끝
					   FROM (SELECT ISNULL(ISNULL(L.COMPANY_ID, C.COMPANY_ID),ML.COMPANY_ID)  AS  COMPANY_ID     -- 2022-08-24 kimcd 라인 정보 없어도 실적 수신되도록 수정 ILT 공정용                                                                                                                                       
									,ISNULL(ISNULL(L.DIVISION_ID, C.DIVISION_ID),ML.DIVISION_ID)  AS DIVISION_ID                                                                                                                                       
									,ISNULL(ISNULL(L.SITE_ID, C.SITE_ID),ML.SITE_ID) AS SITE_ID                                                                                                                                               
									,ISNULL(ISNULL(L.PLANT_ID, C.PLANT_ID),ML.PLANT_ID) AS PLANT_ID                                                                                                                                          
									,ISNULL(ISNULL(L.FACTORY_ID, C.FACTORY_ID),ML.FACTORY_ID) AS FACTORY_ID
									--	2018-03-26 PIYONG  남경 재작업 생산(C Product)의 경우 적용 MODEL를 찾아서 넣음.
									,CASE WHEN ATTRIBUTE5 IS NOT NULL THEN
											( SELECT TOP 1 APPLIED_MODEL FROM SCM_ITEM_M WHERE COMPANY_ID = ISNULL(ISNULL(L.COMPANY_ID, C.COMPANY_ID),ML.COMPANY_ID)  AND SITE_ID = @SITE_ID AND DIVISION_ID = ISNULL(ISNULL(L.DIVISION_ID, C.DIVISION_ID),ML.DIVISION_ID) AND ITEM_ID = U.PRODID)
											-- 2022-08-24 kimcd 라인 정보 없어도 실적 수신되도록 수정 ILT 공정용
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
																   -- 2022-05-10 kimcd 조건 추가 시작
																   AND EM.COMPANY_ID = C.COMPANY_ID
																   AND EM.DIVISION_ID = C.DIVISION_ID
																   AND EM.SITE_ID = C.SITE_ID
																   AND EM.PLANT_ID = C.PLANT_ID
																   AND EM.FACTORY_ID = C.FACTORY_ID
																   -- 2022-05-10 kimcd 조건 추가 끝
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
																	), U.EQSGID) ) as  LINE_ID                                                                                                                                            
									,CAL_WIPDTTM_ED AS PLAN_DATE
									,ISNULL(U.PRODUCTION_TYPE, 'MASS') AS PRODUCTION_TYPE
									,ISNULL(U.FP_PRODUCTION_TYPE, 'MASS') AS FP_PRODUCTION_TYPE -- 2018-04-09 kimcd FP_PRODUCTION_TYPE. FP 내부 관리용 수요 유형 추가
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
									,CASE WHEN U.PROCID LIKE 'E%' OR U.PROCID LIKE 'S%' THEN ISNULL(U.EQPTID,'-') ELSE '-' END AS EQUIPMENT_ID  -- 2018-02-23 kimcd 설비 정보 추가
									,WORK_REQUEST_MODEL_ID                                    -- 2022-11-01 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
            					    ,[VERSION]                                                -- 2022-11-01 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
            					    ,PROD_SEQ                                                 -- 2022-11-01 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
            					    ,PLM_EC_NO                                                -- 2022-11-01 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
							   FROM /* 2022-05-10 kimcd 주석 처리 ( 
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
											,CASE WHEN W.WIP_TYPE_CODE = 'PROD' THEN 0 ELSE W.WIPQTY_ED END      AS WIPQTY_ED
											,CASE WHEN W.WIP_TYPE_CODE = 'PROD' THEN 0 ELSE W.WIPQTY2_ED END     AS WIPQTY2_ED
											,CASE WHEN W.WIP_TYPE_CODE = 'PROD' THEN 0 ELSE W.WIPQTY2_ENGINE END AS WIPQTY2_ENGINE         -- 추가
											 -- 2018-04-02 kimcd wip_type_code가 PROD인 경우 WIPQTY_ED, WIPQTY2_ED, WIPQTY2_ENGINE 3개 컬럼의 값을 0으로 치환 끝
											,COATING_SIDE_TYPE_CODE
											,CNFM_DFCT_QTY2
											,CNFM_LOSS_QTY2
											,CNFM_PRDT_REQ_QTY2
											,SCRAP_QTY
											,W.YIELD_LOSS_QTY                 -- 2018-01-23 kimcd 투입 수량 표시하기 위해 YILED에 포하되어야 하는 LOSS 수량 컬럼 추가
											,CASE WHEN COATING_SIDE_TYPE_CODE = 'T' AND SUBSTRING ( PRODID, 4 ,2 ) != 'CS' THEN WIPQTY2_ED ELSE 0 END TOP_COATING_QTY2  -- 2018-01-23 kimcd top coding 수량 추가	--2019-08-02 PIYONG  AND SUBSTRING (PRODID, 4 ,2 )  != 'CS' ADD 
											,W.PRODUCTION_TYPE
											,ISNULL(W.ATTRIBUTE6, W.PRODUCTION_TYPE) AS FP_PRODUCTION_TYPE -- 2018-04-09 kimcd FP_PRODUCTION_TYPE. FP 내부 관리용 수요 유형 추가
                                            ,(SELECT TOP 1 A.DIVISION_ID                                                                                                                       
												FROM [DBO].[FP_PRODUCTION_PLAN_R] A with(nolock)                                                                                                  
											    WHERE A.WORK_ORDER_ID = W.WOID
												  AND A.PRODUCTION_TYPE IS NOT NULL
												  ORDER BY FP_PLAN_ID DESC  ) DIVISION_CODE
											,W.MARKET
											,W.TOP_ITEM_ID
											,W.ATTRIBUTE5																--2018-03-26 PIYONG APPLIED_MODEL 값을 찾기 위해 추가, DIVISION_ID를 조회문 밖에서 구해야 함
									   FROM [dbo].[SCM_MES_WIP_HISTORY_H] W -- 2018-01-06 kimcd with(nolock) 제거                                                                                                                
									  WHERE CAST( WIPDTTM_ED AS DATETIME) >= CAST(DATEADD(DD, -23, GETDATE()) AS DATE)  -- 2018-11-06 KIMCD 13일에서 23일로 일자 구간 증가
										AND W.WIP_TYPE_CODE IN ( 'INOUT','OUT' ,'PACKED', 'PROD')
										AND (W.FORMATION_REWORK_TYPE <> 'Y' OR W.FORMATION_REWORK_TYPE IS NULL)
										AND ( PROCID != 'F6000'															-- 2018-01-17 PIYONG 활성화 공정 제외
									--		  OR ( PROCID = 'F6000' AND W.ATTRIBUTE2 IN ('M1', 'M2')  )					-- 2018-08-07 PIYONG ADD	--2020-02-19 piyong DEL
											)
										AND W.ATTRIBUTE1 = @SITE_ID
										AND W.ATTRIBUTE2 IN ( SELECT FACTORY_ID FROM #XIF_MES_DAILY_WIP_HISTORY_TEMP_FACTORY )				-- 2019-09-10 PIYONG ADD END
										

									) */   #SCM_MES_WIP_HISTORY_H U                                                                                                                                                     
						       LEFT OUTER JOIN [DBO].[SCM_EQUIPMENT_M] L WITH(NOLOCK) 
											-----------------------------------------------------------------------------
											--	2019-07-15 PIYONG  JOIN 컬럼순서 변경및 기준 테이블 컬럼을 왼쪽으로 이동
										    ON L.DIVISION_ID =  ISNULL(U.DIVISION_CODE, L.DIVISION_ID )	-- 2018-11-16 PIYONG E8동이 없어지면서 관련 로직 제거
										   AND L.SITE_ID = @SITE_ID
										   AND L.FACTORY_ID = SUBSTRING(U.EQSGID,1,2)					-- 2018-11-16 PIYONG E8동이 없어지면서 관련 로직 제거
										   AND L.MES_LINE_ID = U.EQSGID
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
												 WHERE A.SITE_ID = @SITE_ID		-- 2019-07-09 PIYONG ADD
												/*
													-- 2019-07-09 PIYONG DEL SCM_EQUIPMENT_M에서 SCM_LINE_M 변경하면서 필요 없어짐
												   AND A.EQUIPMENT_TYPE = 'M'   -- 2018-01-01 kimcd 조건 추가
												   AND A.ACTIVE_FLAG    = 'Y'   -- 2018-01-01 kimcd 조건 추가
												*/
												 GROUP BY A.COMPANY_ID
														, A.DIVISION_ID
														, A.SITE_ID
														, A.PLANT_ID
														, A.FACTORY_ID
														, A.OPERATION_ID
														, A.LINE_ID				-- 2019-07-09 PIYONG CHANGE MES_LINE_ID -> LINE_ID
												) C
											-----------------------------------------------------------------------------
											--	2019-07-15 PIYONG  JOIN 컬럼순서 변경및 기준 테이블 컬럼을 왼쪽으로 이동
											 ON C.DIVISION_ID =  ISNULL(U.DIVISION_CODE, C.DIVISION_ID)		-- 2018-11-16 PIYONG E8동이 없어지면서 관련 로직 제거
										    AND C.OPERATION_ID = U.PROCID
										    AND C.LINE_ID = U.EQSGID			-- 2019-07-09 PIYONG CHANGE MES_LINE_ID -> LINE_ID
										    AND C.FACTORY_ID = U.FACTORY_ID  -- 2022-08-11 kimcd 설비 없는 실적 수집용 추가 SUBSTRING(U.EQSGID,1,2)
											--	2019-07-15 PIYONG  JOIN 컬럼순서 변경및 기준 테이블 컬럼을 왼쪽으로 이동
											-----------------------------------------------------------------------------
							   LEFT OUTER JOIN [DBO].SCM_MMD_LINE_M ML WITH(NOLOCK) -- 2022-08-24 kimcd 라인 정보 없어도 실적 수신되도록 수정 ILT 공정용
											 ON ML.DIVISION_ID = ISNULL(U.DIVISION_CODE, ML.DIVISION_ID)
										    AND ML.LINE_ID     = U.EQSGID
										    AND ML.FACTORY_ID  = U.FACTORY_ID
											AND ML.SITE_ID     = @SITE_ID
											-----------------------------------------------------------------------------
							  WHERE U.cal_wipdttm_ed IS NOT NULL
							    AND U.cal_wipdttm_ed >= CAST(DATEADD(DD, -38, GETDATE()) AS DATE) -- -21 to -38
							    AND ISNULL(ISNULL(L.COMPANY_ID, C.COMPANY_ID),ML.COMPANY_ID) IS NOT NULL -- 2022-08-24 kimcd 라인 정보 없어도 실적 수신되도록 수정 ILT 공정용 
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
							-- ,LOCATION	 -- 2018-02-01 kimcd LOCATION 컬럼 KEY에서 제거
							,FP_PRODUCTION_TYPE -- 2018-04-09 kimcd FP_PRODUCTION_TYPE. FP 내부 관리용 수요 유형을 GROUP BY 단위로 추가. PRODUCTION_TYPE에서 FP_PRODUCTION_TYPE으로 변경
							,MARKET
							,LINE_ID
							,ELECTRODE_TYPE
							,EQUIPMENT_ID -- 2018-02-23 kimcd 설비 정보 추가
							,PLAN_DATE
							,WORK_REQUEST_MODEL_ID        -- 2022-11-01 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
            				,[VERSION]                    -- 2022-11-01 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
            				,PROD_SEQ                     -- 2022-11-01 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
            				,PLM_EC_NO                    -- 2022-11-01 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
				  ) B
			   ON ( A.[FACTORY_ID] = B.[FACTORY_ID]
					AND A.[LINE_ID] = B.[LINE_ID]
					AND A.[PLAN_DATE] = B.[PLAN_DATE]
					AND A.[OPERATION_ID] = B.[OPERATION_ID]
					AND A.[TOP_ITEM_ID] = B.[TOP_ITEM_ID]
					AND A.[ITEM_ID] = B.[ITEM_ID]
					-- AND A.[PRODUCTION_TYPE] = B.[PRODUCTION_TYPE] -- 2018-04-09 kimcd FP_PRODUCTION_TYPE 추가에 따라 PRODUCTION_TYPE 조건 제거
					AND A.[FP_PRODUCTION_TYPE] = B.[FP_PRODUCTION_TYPE]  -- 2018-04-09 kimcd FP_PRODUCTION_TYPE. FP 내부 관리용 수요 유형 추가
					-- AND A.[LOCATION] = B.[LOCATION]  -- 2018-02-01 kimcd LOCATION 컬럼 KEY에서 제거
					AND A.[MARKET] = B.[MARKET]
					AND A.[ELECTRODE_TYPE] = B.[ELECTRODE_TYPE]
					AND A.[EQUIPMENT_ID] = B.[EQUIPMENT_ID] -- 2018-02-23 kimcd 설비 조건 추가
					AND A.[WORK_REQUEST_MODEL_ID] = B.[WORK_REQUEST_MODEL_ID] -- 2022-11-01 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
					AND A.[VERSION] = B.[VERSION]                             -- 2022-11-01 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
					AND A.[PROD_SEQ] = B.[PROD_SEQ]                           -- 2022-11-01 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
					AND A.[PLM_EC_NO] = B.[PLM_EC_NO]                         -- 2022-11-01 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
				  )
			 WHEN MATCHED THEN
				UPDATE 
				   SET A.[COMPANY_ID]		 = B.COMPANY_ID
					   ,A.[DIVISION_ID]		 = B.[DIVISION_ID]
					   ,A.[SITE_ID]			 = B.[SITE_ID]
					   ,A.[PLANT_ID]		 = B.[PLANT_ID]
					   ,A.[LOCATION]         = B.[LOCATION]   -- 2018-02-01 kimcd LOCATION 컬럼 KEY에서 제거
					   ,A.[ACTUAL_QTY]		 = B.[ACTUAL_QTY]
					   ,A.[ACTUAL_GOOD_QTY]	 = B.[ACTUAL_GOOD_QTY]
					   ,A.[ACTUAL_SCRAP_QTY] = B.[ACTUAL_SCRAP_QTY]
					   ,A.[UPDATE_ID]		 = B.[UPDATE_ID]
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
					   ,A.[PRODUCTION_TYPE]  = B.[PRODUCTION_TYPE] -- 2018-04-09 kimcd FP_PRODUCTION_TYPE 추가에 따라 PRODUCTION_TYPE 갱신
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
				  ,[EQUIPMENT_ID]  -- 2018-02-23 kimcd 설비 정보 추가
				  ,[FP_PRODUCTION_TYPE]  -- 2018-04-09 kimcd FP 내부 수요 유형 관리. FP_PRODUCTION_TYPE 추가
				  ,WORK_REQUEST_MODEL_ID -- 2022-11-01 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
            	  ,[VERSION]             -- 2022-11-01 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
            	  ,PROD_SEQ              -- 2022-11-01 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
            	  ,PLM_EC_NO             -- 2022-11-01 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
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
				  ,B.[EQUIPMENT_ID]  -- 2018-02-23 kimcd 설비 정보 추가
				  ,B.[FP_PRODUCTION_TYPE]  -- 2018-04-09 kimcd FP 내부 수요 유형 관리. FP_PRODUCTION_TYPE 추가
				  ,B.[WORK_REQUEST_MODEL_ID] -- 2022-11-01 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
            	  ,B.[VERSION]               -- 2022-11-01 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
            	  ,B.[PROD_SEQ]              -- 2022-11-01 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
            	  ,B.[PLM_EC_NO]             -- 2022-11-01 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
				)
			;


		--------------------------------------------------------------------------------------------------------------------------------------------------------
			   SET @v_temp3 = '4444'

			-- 2018-01-06 kimcd 일자별 실적 정리
			SET @v_table = 'MERGE [dbo].[SCM_DAILY_PRODUCT_RESULT_H]'
			DELETE W
			  FROM SCM_DAILY_PRODUCT_RESULT_H W
			 WHERE W.[SITE_ID]      = @SITE_ID
			   AND ( W.OPERATION_ID  NOT in (SELECT SEGMENT2 FROM SCM_CODE_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE='PR_XIF_MES_DAILY_WIP_HISTORY_R' AND SEGMENT1  = '2' AND ACTIVE_FLAG = 'Y')									--2018-01-17 PIYONG 활성화 공정 제외		--2019-09-09 PIYONG ADD
				--	 OR ( W.OPERATION_ID = 'F6000' AND W.PLANT_ID = 'A010'  )						-- 2018-08-07 PIYONG ADD	--2020-02-24 PIYONG DEL
					 OR ( W.OPERATION_ID in (SELECT SEGMENT2 FROM SCM_CODE_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE='PR_XIF_MES_DAILY_WIP_HISTORY_R' AND SEGMENT1  = '1' AND ACTIVE_FLAG = 'Y') 
					 AND W.PLANT_ID  in (SELECT SEGMENT2 FROM SCM_CODE_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE='PR_XIF_MES_DAILY_WIP_HISTORY_R' AND SEGMENT1  = '0' AND ACTIVE_FLAG = 'Y')  )						--2019-09-09 PIYONG ADD
				   )
			   AND W.[PLAN_DATE]   >= CAST(DATEADD(DD, -38, GETDATE()) AS DATE) -- -21 to -38
			   AND W.[UPDATE_TIME]  < CONVERT(DATE, GETDATE()) -- 변경 대상 중에 오늘 변경 안 된 것 삭제
			   AND W.INSERT_ID = 'PR_XIF_MES_DAILY_WIP_HISTORY_R'									-- 2018-08-07 PIYONG ADD
			   AND W.[FACTORY_ID] IN ( SELECT FACTORY_ID FROM #XIF_MES_DAILY_WIP_HISTORY_TEMP_FACTORY )						-- 2019-09-11 PIYONG ADD



		--------------------------------------------------------------------------------------------------------------------------------------------------------
			-- 2018-04-21 kimcd Coating 공정에 환산 실적 갱신 시작

			-- 2020-06-30 kimcd 수요 유형별 우선 순위 설정 임시 Table 시작

			   SET @v_temp3 = '5555'

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
							AND B.SITE_ID       = @SITE_ID
							) B
					WHERE  1=1
					AND	   SLV.LOOKUP_TYPE_CODE	= 'INSTANCE_CONV_PRIORITY'
					AND	   SLV.SEGMENT1			=  B.INSTANCE_ID
					AND    SLV.SEGMENT2         =  B.PLANT_ID
					AND    SLV.ACTIVE_FLAG		= 'Y'
					) A
			UNPIVOT(VERSION_TYPE FOR GUBUN IN (ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5)) AS X
			-- 2020-06-30 kimcd 수요 유형별 우선 순위 설정 임시 Table 끝

			SET @v_temp3 = '6666' 
			UPDATE T
			SET    T.ROLL_IN_QTY   = CASE WHEN W.ITEM_UOM = 'EA' THEN W.ACTUAL_QTY / W.CELL_M ELSE W.ACTUAL_QTY END 
				 , T.ROLL_OUT_QTY  = CASE WHEN W.ITEM_UOM = 'EA' THEN W.ACTUAL_GOOD_QTY / W.CELL_M ELSE W.ACTUAL_GOOD_QTY END 
				 , T.JR_IN_QTY     = CASE WHEN W.ITEM_UOM = 'EA' THEN W.ACTUAL_QTY / W.CELL_M / W.LANE ELSE W.ACTUAL_QTY / W.LANE END 
				 , T.JR_OUT_QTY    = CASE WHEN W.ITEM_UOM = 'EA' THEN W.ACTUAL_GOOD_QTY / W.CELL_M / W.LANE ELSE	W.ACTUAL_GOOD_QTY /W.LANE END
				 , T.BATCH_IN_QTY  = CASE WHEN W.ITEM_UOM = 'EA' THEN	W.ACTUAL_QTY / W.CELL_BATCH ELSE W.ACTUAL_QTY / W.M_BATCH END
				 , T.BATCH_OUT_QTY = CASE WHEN W.ITEM_UOM = 'EA' THEN W.ACTUAL_QTY / W.CELL_BATCH ELSE W.ACTUAL_QTY / W.M_BATCH END
				 , T.CELL_IN_QTY   = CASE WHEN W.ITEM_UOM = 'EA' THEN W.ACTUAL_QTY ELSE W.ACTUAL_QTY * W.CELL_M END
				 , T.CELL_OUT_QTY  = CASE WHEN W.ITEM_UOM = 'EA' THEN W.ACTUAL_GOOD_QTY ELSE W.ACTUAL_GOOD_QTY * W.CELL_M END
				 , T.TOP_JR_OUT_QTY = CASE WHEN W.ITEM_UOM = 'EA' THEN W.TOP_COATING_QTY2 / W.CELL_M / W.LANE ELSE	W.TOP_COATING_QTY2 /W.LANE END  -- 2019-04-04 kimcd 양면의 top coding 실적 전환
			FROM  SCM_DAILY_PRODUCT_RESULT_H  T WITH(NOLOCK)
				 ,(	SELECT W.ITEM_ID
						   ,W.TOP_ITEM_ID
						   ,W.LINE_ID
						   ,W.PLAN_DATE
						   ,W.OPERATION_ID
						   ,W.COMPANY_ID
						   ,W.DIVISION_ID
						   ,W.SITE_ID
						   ,W.PLANT_ID
						   ,W.FACTORY_ID
						   ,W.FP_PRODUCTION_TYPE
						   ,W.MARKET
						   ,W.EQUIPMENT_ID
						   ,W.ELECTRODE_TYPE
						   ,W.ACTUAL_QTY
						   ,W.ACTUAL_GOOD_QTY
                           ,W.WORK_REQUEST_MODEL_ID -- 2022-11-01 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
						   ,W.VERSION               -- 2022-11-01 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
						   ,W.PROD_SEQ              -- 2022-11-01 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
						   ,W.PLM_EC_NO             -- 2022-11-01 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
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
								  ( SELECT MIN(VALUE) AS M_BATCH			-- 2018-11-14 PIYONG  MAX-> MIN
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
								  ( SELECT MIN(VALUE) AS CELL_BATCH			-- 2018-11-14 PIYONG  MAX-> MIN
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
										   SELECT TOP 1 VALUE AS LANE               	-- 2022-11-01 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
                                            FROM   SCM_ITEM_CONV_CALC_M C WITH(NOLOCK)
                                           WHERE  ISNULL(C.VALUE, 0) > 0
                                            AND    C.CATEGORY     = 'Lane Number'
                                            AND    C.COMPANY_ID   = W.COMPANY_ID
                                            AND    C.DIVISION_ID  = W.DIVISION_ID
                                            AND    C.SITE_ID      = W.SITE_ID
                                            AND    C.PLANT_ID     = W.PLANT_ID
                                            AND    C.FACTORY_ID   = W.FACTORY_ID
                                            AND    C.OPERATION    = 'E2000'
                                            AND    C.ITEM_ID      = W.ITEM_ID
                                            AND    C.PROD_VERSION_TYPE = L.PROD_VERSION_TYPE    	
                                            AND    C.MODEL_ID	  =  W.[WORK_REQUEST_MODEL_ID]      -- 2022-11-01 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
                                            AND    C.VERSION      = W.[VERSION]                     -- 2022-11-01 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
											-- ORDER BY CASE WHEN C.VERSION_TYPE = CT.VERSION_TYPE THEN IDX ELSE 999 END -- 2020-06-30 kimcd 환산자 사용 우선 순위 적용
											--		,C.APPLY_DATE DESC -- 2020-06-30 kimcd 적용일 우선 순위
											---------------------------------------------------------------------------------------------
											-- 2018-12-07 PIYONG ADD
											--		,(CASE WHEN C.MODEL_ID	  = I.APPLIED_MODEL THEN 1 ELSE 2 END)
											--		,C.MODEL_ID
											--		,( CASE WHEN C.VERSION  LIKE 'Z%' THEN REPLACE(C.VERSION, 'Z', '/') ELSE C.VERSION END ) DESC
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
											ORDER BY CASE WHEN C.PROD_VERSION_TYPE = L.PROD_VERSION_TYPE THEN 1 ELSE 2 END	-- 2022-11-01 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
											        ,CASE WHEN C.VERSION_TYPE = CT.VERSION_TYPE THEN IDX ELSE 999 END -- 2020-06-30 kimcd 환산자 사용 우선 순위 적용
													,C.APPLY_DATE DESC -- 2020-06-30 kimcd 적용일 우선 순위
													,VALUE
										)
									)
																			) AS LANE
						   ,CASE WHEN I.ITEM_UOM = 'M' THEN
									ISNULL(
											(
											SELECT TOP 1 VALUE AS M_BATCH                                     	-- 2022-11-01 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
                                            FROM   SCM_ITEM_CONV_CALC_M C WITH(NOLOCK)
                                           WHERE  ISNULL(C.VALUE, 0) > 0
                                            AND    C.CATEGORY     = 'Pancake (m/batch)'
                                            AND    C.COMPANY_ID   = W.COMPANY_ID
                                            AND    C.DIVISION_ID  = W.DIVISION_ID
                                            AND    C.SITE_ID      = W.SITE_ID
                                            AND    C.PLANT_ID     = W.PLANT_ID
                                            AND    C.FACTORY_ID   = W.FACTORY_ID
                                            AND    C.OPERATION    = 'E2000'
                                            AND    C.ITEM_ID      = W.ITEM_ID
                                            AND    C.PROD_VERSION_TYPE = L.PROD_VERSION_TYPE    	
                                            AND    C.MODEL_ID	  =  W.[WORK_REQUEST_MODEL_ID]      -- 2022-11-01 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
                                            AND    C.VERSION      = W.[VERSION]                     -- 2022-11-01 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
											-- ORDER BY CASE WHEN C.VERSION_TYPE = CT.VERSION_TYPE THEN IDX ELSE 999 END -- 2020-06-30 kimcd 환산자 사용 우선 순위 적용
											--		,C.APPLY_DATE DESC -- 2020-06-30 kimcd 적용일 우선 순위
											---------------------------------------------------------------------------------------------
											-- 2018-12-07 PIYONG ADD
											--		,(CASE WHEN C.MODEL_ID	  = I.APPLIED_MODEL THEN 1 ELSE 2 END)
											--		,C.MODEL_ID
											--		,( CASE WHEN C.VERSION  LIKE 'Z%' THEN REPLACE(C.VERSION, 'Z', '/') ELSE C.VERSION END ) DESC
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
												ORDER BY CASE WHEN C.PROD_VERSION_TYPE = L.PROD_VERSION_TYPE THEN 1 ELSE 2 END	-- 2022-11-01 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
											            ,CASE WHEN C.VERSION_TYPE = CT.VERSION_TYPE THEN IDX ELSE 999 END -- 2020-06-30 kimcd 환산자 사용 우선 순위 적용
														,C.APPLY_DATE DESC -- 2020-06-30 kimcd 적용일 우선 순위
														,VALUE
											)
										)
								 END										AS M_BATCH
						   ,CASE WHEN I.ITEM_UOM = 'EA' THEN
									ISNULL ( (
												SELECT VALUE AS CELL_BATCH                                     	-- 2022-11-01 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
                                            FROM   SCM_ITEM_CONV_CALC_M C WITH(NOLOCK)
                                           WHERE  ISNULL(C.VALUE, 0) > 0
                                            AND    C.CATEGORY     = 'cell/batch'
                                            AND    C.COMPANY_ID   = W.COMPANY_ID
                                            AND    C.DIVISION_ID  = W.DIVISION_ID
                                            AND    C.SITE_ID      = W.SITE_ID
                                            AND    C.PLANT_ID     = W.PLANT_ID
                                            AND    C.FACTORY_ID   = W.FACTORY_ID
                                            AND    C.OPERATION    = 'E2000'
                                            AND    C.ITEM_ID      = W.ITEM_ID
                                            AND    C.PROD_VERSION_TYPE = L.PROD_VERSION_TYPE    	
                                            AND    C.MODEL_ID	  =  W.[WORK_REQUEST_MODEL_ID]      -- 2022-11-01 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
                                            AND    C.VERSION      = W.[VERSION]                     -- 2022-11-01 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
											-- ORDER BY CASE WHEN C.VERSION_TYPE = CT.VERSION_TYPE THEN IDX ELSE 999 END -- 2020-06-30 kimcd 환산자 사용 우선 순위 적용
											--		,C.APPLY_DATE DESC -- 2020-06-30 kimcd 적용일 우선 순위
											---------------------------------------------------------------------------------------------
											-- 2018-12-07 PIYONG ADD
											--		,(CASE WHEN C.MODEL_ID	  = I.APPLIED_MODEL THEN 1 ELSE 2 END)
											--		,C.MODEL_ID
											--		,( CASE WHEN C.VERSION  LIKE 'Z%' THEN REPLACE(C.VERSION, 'Z', '/') ELSE C.VERSION END ) DESC
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
												ORDER BY CASE WHEN C.PROD_VERSION_TYPE = L.PROD_VERSION_TYPE THEN 1 ELSE 2 END	-- 2022-11-01 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
											            ,CASE WHEN C.VERSION_TYPE = CT.VERSION_TYPE THEN IDX ELSE 999 END -- 2020-06-30 kimcd 환산자 사용 우선 순위 적용
														,C.APPLY_DATE DESC -- 2020-06-30 kimcd 적용일 우선 순위
														,VALUE
											) 
									)
								 END										AS CELL_BATCH
							,(
								ISNULL(
										(
											SELECT VALUE AS CELL_M                                     	-- 2022-11-01 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
                                            FROM   SCM_ITEM_CONV_CALC_M C WITH(NOLOCK)
                                           WHERE  ISNULL(C.VALUE, 0) > 0
                                            AND    C.CATEGORY     = 'Pancake (cell/m)'
                                            AND    C.COMPANY_ID   = W.COMPANY_ID
                                            AND    C.DIVISION_ID  = W.DIVISION_ID
                                            AND    C.SITE_ID      = W.SITE_ID
                                            AND    C.PLANT_ID     = W.PLANT_ID
                                            AND    C.FACTORY_ID   = W.FACTORY_ID
                                            AND    C.OPERATION    = 'E2000'
                                            AND    C.ITEM_ID      = W.ITEM_ID
                                            AND    C.PROD_VERSION_TYPE = L.PROD_VERSION_TYPE    	
                                            AND    C.MODEL_ID	  =  W.[WORK_REQUEST_MODEL_ID]      -- 2022-11-01 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
                                            AND    C.VERSION      = W.[VERSION]                     -- 2022-11-01 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
											-- ORDER BY CASE WHEN C.VERSION_TYPE = CT.VERSION_TYPE THEN IDX ELSE 999 END -- 2020-06-30 kimcd 환산자 사용 우선 순위 적용
											--		,C.APPLY_DATE DESC -- 2020-06-30 kimcd 적용일 우선 순위
											---------------------------------------------------------------------------------------------
											-- 2018-12-07 PIYONG ADD
											--		,(CASE WHEN C.MODEL_ID	  = I.APPLIED_MODEL THEN 1 ELSE 2 END)
											--		,C.MODEL_ID
											--		,( CASE WHEN C.VERSION  LIKE 'Z%' THEN REPLACE(C.VERSION, 'Z', '/') ELSE C.VERSION END ) DESC
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
											ORDER BY CASE WHEN C.PROD_VERSION_TYPE = L.PROD_VERSION_TYPE THEN 1 ELSE 2 END	-- 2022-11-01 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
											        ,CASE WHEN C.VERSION_TYPE = CT.VERSION_TYPE THEN IDX ELSE 999 END -- 2020-06-30 kimcd 환산자 사용 우선 순위 적용
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
					AND    W.[SITE_ID]      = @SITE_ID
					AND    W.OPERATION_ID   IN  ( 'E2000', 'E3000', 'E4000' ) -- 2019-08-29 PIYONG  E3000, E4000도  포함
					AND    W.[PLAN_DATE]   >= CAST(DATEADD(DD, -38, GETDATE()) AS DATE)  -- -21 to -38
				    AND	   W.[FACTORY_ID]	IN ( SELECT FACTORY_ID FROM #XIF_MES_DAILY_WIP_HISTORY_TEMP_FACTORY )		-- 2019-09-11 PIYONG ADD
				  ) W
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
            AND	  T.WORK_REQUEST_MODEL_ID = W.WORK_REQUEST_MODEL_ID -- 2022-11-01 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
            AND	  T.VERSION               = W.VERSION               -- 2022-11-01 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
            AND	  T.PROD_SEQ              = W.PROD_SEQ              -- 2022-11-01 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
            AND	  T.PLM_EC_NO             = W.PLM_EC_NO             -- 2022-11-01 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
			-- 2018-04-21 kimcd Coating 공정에 환산 실적 갱신 종료

			SET @v_temp3 = '7777'
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
                            ,W.WORK_REQUEST_MODEL_ID -- 2022-11-01 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
						    ,W.VERSION               -- 2022-11-01 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
						    ,W.PROD_SEQ              -- 2022-11-01 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
						    ,W.PLM_EC_NO             -- 2022-11-01 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
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
														AND   (M.FLOW_ID LIKE 'A%' OR M.FLOW_ID LIKE 'F%')
													  ) -- 2018-05-15 kimcd Cell 공정 모델만으로 제한
										GROUP  BY [MODEL_ID], MCT.ALT_PRIORITY, CASE WHEN MCT.ALT_PRIORITY = 'Y' THEN NULL ELSE CONCAT_ALT_PRIORITY END -- 2020-07-21 kimcd 조립 Cell 환산에서 Primary, 대치 구분자 추가
										ORDER  BY [MODEL_ID], MCT.ALT_PRIORITY DESC, CASE WHEN MCT.ALT_PRIORITY = 'Y' THEN NULL ELSE CONCAT_ALT_PRIORITY END ) -- 2020-07-21 kimcd 조립 Cell 환산에서 Primary, 대치 구분자 추가
										)  AS ACCUM_QTY
					FROM   SCM_DAILY_PRODUCT_RESULT_H W WITH(NOLOCK)
					WHERE  W.[SITE_ID]      = @SITE_ID
					AND    W.OPERATION_ID  LIKE  'A%'
					AND    W.[PLAN_DATE]   >= CAST(DATEADD(DD, -38, GETDATE()) AS DATE)		-- -21 to -38
				    AND	   W.[FACTORY_ID]	IN ( SELECT FACTORY_ID FROM #XIF_MES_DAILY_WIP_HISTORY_TEMP_FACTORY )		-- 2019-09-11 PIYONG ADD
																								) W
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
            AND	  T.WORK_REQUEST_MODEL_ID = W.WORK_REQUEST_MODEL_ID -- 2022-11-01 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
            AND	  T.VERSION               = W.VERSION               -- 2022-11-01 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
            AND	  T.PROD_SEQ              = W.PROD_SEQ              -- 2022-11-01 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
            AND	  T.PLM_EC_NO             = W.PLM_EC_NO             -- 2022-11-01 leeseonmgin 전극 생산 버전별 계획 수립, PLM EC 추가 관리
			--20180-09-06 PIYONG ADD END
			---------------------------------------------------------------------------------------------------------------------------------------------


			SET @v_temp3 = '8888'
			---------------------------------------------------------------------------------------------------------------------------------------------
			-- 2018-11-06 kimcd 수정 시작 활성화 후 공정에 cell material id 추가
			UPDATE T
			SET    T.CELL_MATERIAL_ID = (   SELECT TOP 1 CHILD_ITEM_ID
											FROM   [dbo].[SCM_BOM_M] BOM WITH(NOLOCK)
											WHERE  BOM.COMPANY_ID    = T.COMPANY_ID
											AND    BOM.DIVISION_ID     = T.DIVISION_ID
											AND    BOM.SITE_ID         = T.SITE_ID
											AND    BOM.PLANT_ID        = T.PLANT_ID
											AND    BOM.PARENT_ITEM_ID  = T.[ITEM_ID]
											AND    EXISTS (	SELECT 1 
															FROM   DBO.SCM_ITEM_M I WITH(NOLOCK)
																 , [dbo].[SCM_ITEM_CLASS_M]  ICM WITH(NOLOCK)
															WHERE  I.COMPANY_ID   = BOM.COMPANY_ID
															AND    I.DIVISION_ID  = BOM.DIVISION_ID
															AND    I.SITE_ID      = BOM.SITE_ID
															AND    I.ITEM_ID      = BOM.CHILD_ITEM_ID
															AND    ICM.[CLASS_ID]      = I.[ITEM_CLASS]
															AND    ICM.[LEVEL_1_NAME]  = 'Model')
											AND BOM.EFF_START_DATE <= T.[PLAN_DATE] 
											AND BOM.EFF_END_DATE    > T.[PLAN_DATE] 
											)
			FROM  SCM_DAILY_PRODUCT_RESULT_H  T WITH(NOLOCK)
			WHERE  T.[SITE_ID]      = @SITE_ID
			AND    T.OPERATION_ID  LIKE  'F%'
			AND    T.OPERATION_ID  >= 'F6200'
			AND    T.[PLAN_DATE]   >= CAST(DATEADD(DD, -38, GETDATE()) AS DATE)    --  -21 to -38
			-- 2018-11-06 kimcd 수정 끝 활성화 후 공정에 cell material id 추가
		    AND	   T.[FACTORY_ID]	IN ( SELECT FACTORY_ID FROM #XIF_MES_DAILY_WIP_HISTORY_TEMP_FACTORY )		-- 2019-09-11 PIYONG ADD



		  	FETCH NEXT FROM CUR_IF_SITE INTO @SITE_ID
			;


			END;

			CLOSE CUR_IF_SITE;
			DEALLOCATE CUR_IF_SITE;

			SET @v_temp3 = '9999'
			UPDATE R
			   SET R.PROC_FLAG  = 'Y'
				   ,R.PROC_DATE = GETDATE()
			  FROM [dbo].[SY_XIF_MES_DAILY_WIP_HISTORY_R] R
			-------------------------------------------------------
			--2020-02-04 PIYONG ADD
				   , #XIF_MES_DAILY_WIP_HISTORY_UPDATE_INFO U
			 WHERE R.IF_ID = U.IF_ID
			   AND R.ACCUM_DATE = U.ACCUM_DATE
			--2020-02-04 PIYONG ADD END
			-------------------------------------------------------
			   AND R.PROC_FLAG  = 'P'

			-----------------------------------------------------------------------------------------------------------------------------
			--2017-12-11 piyong ---------------------------------------------------------------------------------------------------------
			-----------------------------------------------------------------------------------------------------------------------------

			IF OBJECT_ID('tempdb..#XIF_MES_DAILY_WIP_HISTORY_TEMP_FACTORY') IS NOT NULL
				DROP TABLE #XIF_MES_DAILY_WIP_HISTORY_TEMP_FACTORY

			IF OBJECT_ID('tempdb..#XIF_MES_DAILY_WIP_HISTORY_UPDATE_INFO') IS NOT NULL
				DROP TABLE #XIF_MES_DAILY_WIP_HISTORY_UPDATE_INFO

			IF OBJECT_ID('tempdb..#SCM_MES_WIP_HISTORY_H') IS NOT NULL 
				DROP TABLE #SCM_MES_WIP_HISTORY_H

         --  [FP_MES_WORK_ORDER_STATUS_H] 부분... 추가 고민해 볼 것.


		-- ================================================
		-- 로직 추가 end
		-- ================================================
		COMMIT TRAN

		EXEC PR_XIF_LOG @v_proc_name, @v_table, 'END', @ROWCOUNT, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
		
	END TRY

	BEGIN CATCH

	    ROLLBACK TRAN


		IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WHERE CURSOR_NAME = 'CUR_IF_MES_WIPHIST')
		BEGIN
			CLOSE CUR_IF_MES_WIPHIST
			DEALLOCATE CUR_IF_MES_WIPHIST
		END

		IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WHERE CURSOR_NAME = 'CUR_IF_SITE')
		BEGIN
			CLOSE CUR_IF_SITE
			DEALLOCATE CUR_IF_SITE
		END

		IF OBJECT_ID('tempdb..#XIF_MES_DAILY_WIP_HISTORY_TEMP_FACTORY') IS NOT NULL
			DROP TABLE #XIF_MES_DAILY_WIP_HISTORY_TEMP_FACTORY

		IF OBJECT_ID('tempdb..#XIF_MES_DAILY_WIP_HISTORY_UPDATE_INFO') IS NOT NULL
			DROP TABLE #XIF_MES_DAILY_WIP_HISTORY_UPDATE_INFO

		IF OBJECT_ID('tempdb..#SCM_MES_WIP_HISTORY_H') IS NOT NULL 
			DROP TABLE #SCM_MES_WIP_HISTORY_H


		-- 에러나도 로그는 인서트
		SET @v_descr = ERROR_MESSAGE()
		--EXEC PR_XIF_LOG @v_proc_name, @v_table, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate
		EXEC PR_XIF_LOG @v_proc_name, @v_table, 'ERROR', NULL, @v_temp2, @v_temp3, @v_descr, @sysdate

	END CATCH

END


SET ANSI_NULLS ON
