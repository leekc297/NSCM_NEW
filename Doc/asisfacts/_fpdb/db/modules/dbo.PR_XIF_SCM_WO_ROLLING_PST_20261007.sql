


CREATE   PROCEDURE [dbo].[PR_XIF_SCM_WO_ROLLING_PST_20261007]

-- ================================================================================================
-- Program ID          : FP01671
-- Program Name        : PR_XIF_SCM_WO_ROLLING_PST
-- Param               :
-- Batch Period        : 1DAY
-- Description         :
--
-- Source System       : FP SDB
-- Destination System  : MES, ERP
-- Source Table        : FP_RELEASE_FIX_PLAN_H, SCM_MES_WIP_HISTORY_H
-- Destination Table   : SY_XIF_ERP_PRODUCTION_PLAN_S, SY_XIF_MES_WO_S
--
-- Create Date		   : 2017.06.01
-- Update Date		   : 2017.06.14
--					     2017-06-23 PIYONG 1.2
--						 2017-07-24	PIYONG 1.4
--						 2017-08-04	KIMCD  1.5
--						 2017-08-22 PIYONG 1.6
--						 2017-08-25	PIYONG 1.7
--                       2017-08-29 KIMCD  1.8
--						 2017-08-30 PIYONG 1.9
--						 2017-11-10 PIYONG 1.10
--						 2017-11-23 PIYONG 1.11
--                       2018-03-05 KIMCD  1.12
--                       2018-03-06 kimcd  1.13
--                       2018-05-26 kimcd  1.14
--                       2018-06-06 kimcd  1.15
--                       2018-07-05 kimcd  1.16
--                       2018-12-18 kimcd  1.17
--                       2018-12-18 kimcd  1.2
--                       2019-02-11 kimcd  1.21
--                       2019-02-26 PIYONG 1.22
--                       2019-03-26 PIYONG 1.23
--						 2019-09-10 PIYONG 1.3
--						 2019-10-01 kimcd  1.31
--                       2019-11-04 kimcd  1.32
--                       2020-07-27 kimcd  1.33
--                       2021-06-04 kimcd  1.34
--                       2022-01-25 kimcd  1.35
--                       2022-05-12 kimcd  1.36
--                       2022-08-12 kimcd  1.37
--                       2022-10-06 leeseongmin  1.38
--                       2022-12-13 leeseongmin  1.39
--                       2023-03-03 kimcd  1.4
--						 2024-12-19 NERP XIF 테이블 컬럼변경 반영
-- Author              : PIYONG
-- Version             : 1.0
--					   : 1.1  실적수량 조회시 ADD_QTY 추가 
--						 1.2  실적수량 조회시 ADD_QTY 삭제  양품 수량에 이미 포함되어 있음
--                       1.3  월 초 제한 로직 제거 kimcd 2017-06-24
--                            MES에서 월 초에는 ERP로  실적 전송 안 하는 것으로 결정되어  전월 WO도 사용 가능함
--						 1.4  시업 시간 LOOKUP 기준으로 변경
--						 1.5  NET_JOB - FIRST_ENGINE_RUN 실행 로직 추가
--						 1.6  엑셀업로드('KR_CELL_M_P')한 데이터도 적용하기 위한 쿼리 추가
--						 1.7   SCM_MES_WIP_HISTORY_H 의 WIP_TYPE_CODE 조건에  PROD 추가
--                       1.8  오창 소형 조립 Pilot Instance 반영 
--						 1.9  PILOT 구분을 위한 MES_WO_S 에 ATTR_11 추가
--						 1.10 Plan Release Group 기준으로 최종릴리즈 버전 찾기
--						 1.11 MES_WO_S ATTR_12에 TOP_ITEM_ID 정보 송신
--                       1.12 2018-03-05 KIMCD OPEN WO 수신 점검 TABLE을 I/F TABLE로 변경
--                       1.13 2018-03-06 kimcd work order id 채번 rule 변경에 따른 top back work order id 연결 로직 수정
--                       1.14 2018-05-26 kimcd work order 전송을 변경 필요한 work order만 if 정보 형성하여
--                                             자동 rolling에서 누락되는 WO 발생하여 보완
--                       1.15 2018-06-06 kimcd 엔진 호출에서 factory 기준 전송 정보 존재 여부 찾는 것으로 조건 변경
--                       1.16 2018-07-05 kimcd VD용 최초 테스트 WO 컬럼 추가 - ATTRIBUTE14
--                       1.17 2018-12-18 kimcd 수신 점검 대상 factory에서 setup 진행 중인 공장 제외 - lookup 적용
--                       1.2  2018-12-18 kimcd W/O 전송을 양품 기준으로 수행함에 따라 수정
--                       1.21 2019-02-11 kimcd KR_CELL_A2 추가에 따른 최종 Release 대상 추출 로직 추가
--						 1.22 2019-02-26 PIYONG 3일 이전 WO  롤링에서 제외 조건 추가
--						 1.22 2019-03-26 PIYONG 4일 이전 WO  롤링에서 제외 조건 추가( 장현석 책임 요청 3일이전으로 하면 금요일 생성된 WO가 주말에 추가 생성하지 않으면 ROLLING 되지 않기 때문)
--						 1.3  AUTO RUN 실행 확인 시업시간 조건 추가
--                       1.31 2019-10-01 kimcd  시업 시간 조건 오류 보완 시업 시간 기준으로 factory 구분
--                       1.32 2019-11-04 kimcd  동별로 자동 rolling 제외 로직 추가
--                       1.33 2020-07-27 kimcd  mixer 공정의 ATTR_01(Total Batch), ATTR_03(Total Batch Kg) 전송 정보 제거
--          1.34 2021-06-04 kimcd  M8(남경 소형 6동) MES Instance 분리에 따른 대응
--                       1.35 2022-01-25 kimcd  Hazel Pack 실적, Open WO 검증 로직 보완
--                       1.36 2022-05-12 kimcd  Ultium Cells 시업 시간 작업 반영
--                       1.37 2022-08-12 kimcd  설비 정보 Option화에 따른 수정
--                       1.38 2022-10-06 leeseongmin 계획가능시점 SMS,MAIL
--                       1.39 2022-11-24 kimcd	전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
--                       1.39 2022-12-13 leeseongmin 실적DATA 사이트 및 시업시간별로 MRP I/F 송신
--                       1.4  2023-03-03 kimcd NJ 전극의 경우 FP 전극 버전 그대로 전송
--                       1.41 2023-03-17 kimcd HM 추가에 따른 최초 작업 호출 부분 수정
--                       1.5  2023-10-27 kimcd WA 분리에 따른 자동 계획 FLAG 설정 부분 보완
--                       1.6  2023-11-08 crjung FIRST_ENGINE_RUN_UC2 추가
--                       1.7  2024-03-15 chkim.68 하드코딩 전환 (ref scm_code_lookup_value )
--                       1.8  2024-04-08 KIMJS NERP PLANT_ID 변경에 따른 CONVERSION 반영
--                       1.9  2025-09-18 CYS	[E20250918-001592] PDS 버전 -자리수 조치 요청건
--                       2.0  2025-10-19 CYS    	[E20251019-001993] FP 시스템의 W/O 과실적 방지를 위한 기능변경 건 - 과실적 Flag, next W/O 추가 
--						 2.1  2025-10-19 yschoithira  	[E20251105-001138] W/O 과실적 관련 증량이 안되는 오류 조치 - 현재일자 이후 롤링 리스트 추가 하여 Next WO 찾을 수 있도록 조치
--						 2.2 2025-12-15   yschoithira	[E20251205-001628] ESMI4동 ESS, 자동차 라인 MES DB통합에 따른 기능개선 건
--						 2.3 2026-02-11   yschoithira	[E20260212-001538] 과실적 WO 오더 수량 처리 오류 조치 - 증량이 된건은 이후 WO 리스트에 올라오더라도 처리하지 않음
--						 2.4 2026-03-23   yschoithira	[E20260313-002098] 과실적 로직 적용 시점 오류 - 과실적 처리 목록 적용 시 미래 3일인 경우 빠지는 상황이 있어 보완 ( 명절, setup 등 기간이 벌어지는 next w/o), Plan Date 변경시 과거 w/o 만 변경
--                       2.5 2026-04-07   yokejacob     [E20260325-001091] 시업시간 변경 추가 조치건 입니다. BASIS_TIME 변경건
--                       2.6 2026-05-12  kimcd    [PJ20266179] AZ 법인 증설 SCM 대응. Site 기준으로 최종 일자 점검하는 것으로 로직 보완
--                       2.7 2026-08-04  kimcd    [PJ2026-50201] FP 라인별 환산자 산출 및 생산계획 반영
-- ================================================================================================


AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_XIF_SCM_WO_ROLLING_PST'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	   = 0
	DECLARE @sysdate     DATETIME2     = GETDATE()
	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)

	DECLARE @SITE_ID     NVARCHAR(30)
	DECLARE @FACTORY_ID  NVARCHAR(30)

	DECLARE @BASE_HOUR   NVARCHAR(10)
	DECLARE @BASIS_TIME  NVARCHAR(6)	--2019-09-10 PIYONG ADD

	DECLARE @CHECK_FACTORY INTEGER		--2017.08.04 ADD KIMCD
	DECLARE @CHECK_PST INTEGER			--2017.07.24 ADD
	DECLARE @CHECK_WIP INTEGER			--2017.07.24 ADD
	DECLARE @CHECK_WIP_HIS INTEGER		--2017.07.24 ADD
	DECLARE @CHECK_MWO     INTEGER		--2017.08.04 ADD KIMCD

	DECLARE @SEQ		 INTEGER

	DECLARE @TEMP_TABLE TABLE (
			COMPANY_ID				  NVARCHAR(30)													--2019-09-03 PIYONG ADD
			, DIVISION_ID             NVARCHAR(30)
	        , SITE_ID                 NVARCHAR(30)
	        , FACTORY_ID              NVARCHAR(30)
	        , OPERATION_ID            NVARCHAR(50)
	        , ITEM_ID                 NVARCHAR(150)
	        , EQUIPMENT_ID            NVARCHAR(100)
	        , WORK_ORDER_ID           NVARCHAR(100)
	        , RELEASE_PLAN_ID         NVARCHAR(50)
	        , PLAN_IN_QTY             NUMERIC(18,5)
	        , MES_QTY	              NUMERIC(18,5)		-- [E20251019-001993]	변경 할 수량 반영 Modify
	        , INSTANCE_ID             NVARCHAR(30)		-- [E20251019-001993]	변경 할 수량 반영 Modify
	        , CHANGE_FLAG             NVARCHAR(1)		-- [E20251019-001993]	변경 할 수량 반영 Modify
	        , PLAN_START_TIME         DATETIME			-- [E20251105-001138] ADD
	        , PLAN_DATE         	  DATETIME			-- [E20260313-002098] ADD
	        , START_TIME         	  DATETIME			-- [E20260313-002098] ADD
	        , END_TIME         		  DATETIME			-- [E20260313-002098] ADD
	)

	DECLARE @MES_SOURCE_GROUP TABLE (
			MES_SOURCE_GROUP		  NVARCHAR(30)
		   ,ACCUM_DATE                NVARCHAR(8)  -- 2026-05-12  kimcd    [PJ20266179] AZ 법인 증설 SCM 대응. Site 기준으로 최종 일자 점검용으로 일자 저장
	)


	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

	BEGIN TRY				

		BEGIN TRAN
		-- ================================================
		-- 로직 추가
		-- ================================================
		INSERT INTO @MES_SOURCE_GROUP (MES_SOURCE_GROUP, ACCUM_DATE ) -- 2026-05-12  kimcd    [PJ20266179] AZ 법인 증설 SCM 대응. ACCUM_DATE 추가
		/*2026-05-12  kimcd    [PJ20266179] AZ 법인 증설 SCM 대응. Site 기준으로 최종 일자 점검하는 것으로 로직 보완
		                       법인 시간으로 수신 확인
		  SELECT SUBSTRING(IF_ID,1,4) AS MES_SOURCE_GROUP
		  FROM [SY_XIF_MES_DAILY_WIP_HISTORY_R] -- NOLOCK 걸지 않음
							 WHERE  1=1
							 AND    PROC_FLAG = 'Y'
							 AND    ACCUM_DATE = CONVERT( NVARCHAR(8), GETDATE(), 112)
							 GROUP  BY IF_ID, ACCUM_DATE */
		SELECT R.MES_SOURCE_GROUP, MAX(R.ACCUM_DATE)
		FROM   ( SELECT SUBSTRING(IF_ID,1,4) AS MES_SOURCE_GROUP, R.ACCUM_DATE
		         FROM [SY_XIF_MES_DAILY_WIP_HISTORY_R] R-- NOLOCK 걸지 않음
		         WHERE  1=1
		         AND    R.PROC_FLAG   = 'Y'
		         AND    R.ACCUM_DATE >= CONVERT( NVARCHAR(8), GETDATE()-1, 112)
	             GROUP  BY R.IF_ID, R.ACCUM_DATE ) R
		         INNER JOIN ( SELECT MES_SOURCE_GROUP, CONVERT( NVARCHAR(8), DBO.[FN_SITE_TIME](MAX(Z.SITE_ID)) , 112) AS SITE_TIME
			                  FROM   SCM_FACTORY_M Z WITH(NOLOCK)
							  WHERE  MES_SOURCE_GROUP > ' '
							  GROUP  BY MES_SOURCE_GROUP
							  UNION
							  SELECT 'UHZT' AS MES_SOURCE_GROUP, CONVERT( NVARCHAR(8), DBO.[FN_SITE_TIME](MAX(Z.SITE_ID)) , 112) AS SITE_TIME
			                  FROM   SCM_FACTORY_M Z WITH(NOLOCK)
							  WHERE  MES_SOURCE_GROUP = 'UMS3'
							  GROUP  BY MES_SOURCE_GROUP
							  UNION
							  SELECT MES_SOURCE_GROUP, CONVERT( NVARCHAR(8), DBO.[FN_SITE_TIME](MAX(Z.SITE_ID)) , 112) AS SITE_TIME
			                  FROM   SCM_MMD_LINE_M Z WITH(NOLOCK)
							  WHERE  MES_SOURCE_GROUP > ' '
							  GROUP  BY MES_SOURCE_GROUP
							  ) Z
			       ON  R.MES_SOURCE_GROUP = Z.MES_SOURCE_GROUP
				   AND R.ACCUM_DATE       = Z.SITE_TIME
		WHERE  1=1
        GROUP  BY R.MES_SOURCE_GROUP
		;
		
			DECLARE CUR_SITE CURSOR FOR
				--WITH MD AS ( SELECT SUBSTRING(IF_ID,1,4) AS MES_SOURCE_GROUP
				--			 FROM   [SY_XIF_MES_DAILY_WIP_HISTORY_R] -- NOLOCK 걸지 않음
				--			 WHERE  1=1
				--			 AND    PROC_FLAG = 'Y'
				--			 AND    ACCUM_DATE = CONVERT( NVARCHAR(8), GETDATE(), 112)
				--			 GROUP  BY IF_ID, ACCUM_DATE )
				SELECT DISTINCT Z.SITE_ID, Z.FACTORY_ID		
				  FROM SCM_FACTORY_M Z WITH(NOLOCK)
				WHERE  EXISTS ( SELECT 1 
								 FROM ( SELECT F.SITE_ID, F.FACTORY_ID, (SELECT 'Y'
																	     FROM   @MES_SOURCE_GROUP AS MD
																		 WHERE  MD.MES_SOURCE_GROUP = ISNULL(ML.MES_SOURCE_GROUP, F.MES_SOURCE_GROUP)) AS RECEIVE_CHECK
										FROM   SCM_MMD_LINE_M ML WITH(NOLOCK),
											   SCM_FACTORY_M  F  WITH(NOLOCK)
										WHERE  ML.COMPANY_ID  = F.COMPANY_ID
										AND    ML.DIVISION_ID = F.DIVISION_ID
										AND    ML.SITE_ID     = F.SITE_ID
										AND    ML.PLANT_ID    = F.PLANT_ID
										AND    ML.FACTORY_ID  = F.FACTORY_ID ) A
							    WHERE A.RECEIVE_CHECK = 'Y'
							    AND   A.FACTORY_ID = Z.FACTORY_ID )
				AND NOT EXISTS ( SELECT 1 
								 FROM ( SELECT F.SITE_ID, F.FACTORY_ID, (SELECT 'Y'
																		 FROM   @MES_SOURCE_GROUP AS MD
																		 WHERE  MD.MES_SOURCE_GROUP = ISNULL(ML.MES_SOURCE_GROUP, F.MES_SOURCE_GROUP)) AS RECEIVE_CHECK
										FROM   SCM_MMD_LINE_M ML WITH(NOLOCK),
											   SCM_FACTORY_M  F  WITH(NOLOCK)
										WHERE  ML.COMPANY_ID  = F.COMPANY_ID
										AND    ML.DIVISION_ID = F.DIVISION_ID
										AND    ML.SITE_ID     = F.SITE_ID
										AND    ML.PLANT_ID    = F.PLANT_ID
										AND    ML.FACTORY_ID  = F.FACTORY_ID ) A
								 WHERE A.RECEIVE_CHECK IS NULL
								 AND   A.FACTORY_ID = Z.FACTORY_ID )
				AND NOT EXISTS ( SELECT 1
				                   FROM [DBO].[SCM_SYS_LOOKUP_VALUE]  SV WITH(NOLOCK)
						          WHERE SV.LOOKUP_TYPE_CODE = 'WO_ROLL_EXEC_FLAG'
							        AND SV.SEGMENT1 = Z.SITE_ID
								    AND SV.SEGMENT2 = Z.FACTORY_ID
								    AND SV.ATTRIBUTE1 IN ( SELECT ACCUM_DATE
									                       FROM   @MES_SOURCE_GROUP AS MD
														   WHERE  MD.MES_SOURCE_GROUP = Z.MES_SOURCE_GROUP  -- 2026-05-12  kimcd    [PJ20266179] AZ 법인 증설 SCM 대응. ACCUM_DATE 기준으로 ROLLING 점검
									                       UNION 
														   SELECT '29991231') )  -- 2019-10-01 kimcd 29991231 일자로 자동 롤링 예외 FACTORY 관리 
				--AND Z.COMPANY_ID NOT IN ('G180', 'G450', 'G630', 'G480')
				
				 ;


			OPEN CUR_SITE;
			FETCH NEXT FROM CUR_SITE INTO  @SITE_ID
			                              ,@FACTORY_ID 

			WHILE (@@FETCH_STATUS = 0)
				BEGIN
					DELETE @TEMP_TABLE					

					SET @BASE_HOUR = (	
										 SELECT TOP 1 CONCAT(' ', SUBSTRING(SEGMENT2, 1, 2), ':',SUBSTRING(SEGMENT2, 3, 2), ':',SUBSTRING(SEGMENT2, 5, 2))
										   FROM [DBO].[SCM_SYS_LOOKUP_VALUE] V  WITH(NOLOCK)
												,SCM_FACTORY_M F
										  WHERE V.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
											AND V.ACTIVE_FLAG = 'Y'
											AND V.SEGMENT1 = F.PLANT_ID
											AND F.SITE_ID = @SITE_ID
											AND F.FACTORY_ID = @FACTORY_ID
									 )

					--IF( SUBSTRING( CONVERT(VARCHAR, getdate(), 120), 9,2) != '01')  -- kimcd 2017-06-24 block condition
						BEGIN
	   							INSERT INTO @TEMP_TABLE
								SELECT COMPANY_ID																					--2019-09-03 PIYONG ADD
										, DIVISION_ID
										, SITE_ID
										, FACTORY_ID
										, OPERATION_ID
										, ITEM_ID
										, EQUIPMENT_ID
										, WORK_ORDER_ID
										, RELEASE_PLAN_ID
										-- , PLAN_IN_QTY  2018-12-18 kimcd out 컬럼으로 변경
										, PLAN_QTY AS PLAN_IN_QTY-- 2018-12-18 kimcd out 컬럼으로 변경
										, MES_QTY				--	[E20251019-001993]	MES 실적 수량	Add
										, A.INSTANCE_ID			--	[E20251019-001993]	인스턴스 정보	Add
										, 'N' AS CHANGE_FLAG	--	[E20251019-001993]	변경 Flag		Add
										, START_TIME	AS PLAN_START_TIME	-- [E20251105-001138] Balance 이 후 롤링 정보 삭제 위해 ADD
										, PLAN_DATE     AS PLAN_DATE		-- [E20260313-002098] ADD
										, START_TIME    AS START_TIME		-- [E20260313-002098] ADD
										, END_TIME      AS END_TIME			-- [E20260313-002098] ADD
								FROM ( SELECT B.SITE_ID	
											  , B.COMPANY_ID 																					--2019-09-03 PIYONG ADD
											  , (SELECT ISNULL( 
																SUM(ISNULL(C.WIPQTY2_ED,0))
																/* 2018-12-18 kimcd 양품 실적으로 수정
																+ SUM(ISNULL(CONVERT(NUMERIC(14,3), C.CNFM_DFCT_QTY2),0)) 
																+ SUM(ISNULL(CONVERT(NUMERIC(14,3), C.CNFM_LOSS_QTY2),0)) 
																+ SUM(ISNULL(CONVERT(NUMERIC(14,3), C.CNFM_PRDT_REQ_QTY2),0))
																+ SUM(ISNULL(CAST(C.SCRAP_QTY AS NUMERIC(14,3)),0))*/
																,0)
													FROM DBO.SCM_MES_WIP_HISTORY_H C WITH(NOLOCK, INDEX(IDX1_SCM_MES_WIP_HISTORY_H))
													WHERE C.WOID = A.WORK_ORDER_ID
														AND C.PRODID = A.ITEM_ID
														AND C.WIP_TYPE_CODE IN ( 'OUT','INOUT' ,'PACKED', 'PROD')	-- PIYONG 2017-08-25 PROD 추가
														AND CAST(C.WIPDTTM_ED AS datetime) >= CAST(SUBSTRING( CONVERT(VARCHAR,  CONVERT(DATE, A.INSTANCE_DATE, 112), 120), 1,10 ) + @BASE_HOUR AS datetime)
												) AS MES_QTY, A.*
										FROM FP_RELEASE_FIX_PLAN_H A WITH(NOLOCK)
											-- 2017-11-10 PIYONG Plan Release Group 기준으로 최종릴리즈 버전 찾기 시작
											,( SELECT PLAN_ID
													  ,FACTORY_ID
													  ,SITE_ID
													  ,COMPANY_ID										--2019-09-03 PIYONG ADD
												 FROM ( SELECT B.SITE_ID
																,A.INSTANCE_ID
																,INSTANCE_DATE
																,DIVISION_ID
																,B.FACTORY_ID
																,A.PLAN_GROUP_ID						--2017-11-10 PIYONG ADD
																,A.RELEASE_PLAN_ID AS PLAN_ID	        --2017-11-10 PIYONG ADD
																,B.COMPANY_ID																					--2019-09-03 PIYONG ADD
																,ROW_NUMBER() OVER ( PARTITION BY  DIVISION_ID, INSTANCE_TYPE, A.FACTORY_ID, A.PLAN_GROUP_ID ORDER BY INSERT_TIME DESC ) NUMS -- 마지막 RELEASE VERSION --2017-11-10 PIYONG PARTITION BY A.PLAN_GROUP_ID ADD
															FROM [DBO].FP_RELEASE_PLAN_INFO_H  A        
																,( SELECT A.[INSTANCE_ID]
																		  ,INSTANCE_TYPE
																		  ,B.SITE_ID
																		  ,B.FACTORY_ID
																		  ,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE B.FACTORY_ID END  AS LINK_FACTORY_ID	--2017-11-10 PIYONG ADD
																		  ,ISNULL(MP.SEGMENT2,'-')  AS PLAN_GROUP_ID													--2017-11-10 PIYONG ADD
																		  ,B.COMPANY_ID																					--2019-09-03 PIYONG ADD
																	 FROM DBO.[FP_INSTANCE_FACTORY_M] A WITH(NOLOCK)     
																		  ,DBO.SCM_FACTORY_M B WITH(NOLOCK)
																		  -- 2017-11-06 PIYONG  LINK_FACTORY_ID 값을 만들기 위해 테이블 조인 시작
																		  ------------------------------------------------------------------------
																		  ,SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
																		  LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE MP WITH(NOLOCK)
																					   ON MP.LOOKUP_TYPE_CODE  = 'INSTANCE_PLANNING_GROUP'
																					  AND MP.SEGMENT1 = SLV.SEGMENT1
																					  AND SLV.ATTRIBUTE1 = 'PLAN GROUP'
																		  ------------------------------------------------------------------------
																		  -- 2017-11-06 PIYONG  LINK_FACTORY_ID 값을 만들기 위해 테이블 조인 끝
																	WHERE A.FACTORY_ID = B.FACTORY_ID     
																	  AND A.ACTIVE_FLAG = 'Y'     
																	  AND A.ACTIVE_FLAG = B.ACTIVE_FLAG     
																	  AND B.SITE_ID = @SITE_ID
																	  AND B.FACTORY_ID = @FACTORY_ID
																	  AND A.INSTANCE_ID != 'KR_CELL_M_P' -- KIMCD 2017-08-29
																	  AND A.INSTANCE_ID != 'KR_CELL_A2'  -- KIMCD 2019-02-11 일반적인 Model에서 제외
																	  AND SLV.LOOKUP_TYPE_CODE = 'INSTANCE_ID'
																	  AND SLV.SEGMENT1 = A.INSTANCE_ID
																	--PIYONG 1.6 엑셀 업로드 데이터도 적용 하기 위한 추가
																	UNION ALL
																	SELECT A.[INSTANCE_ID]  AS INSTANCE_ID
																		   ,INSTANCE_TYPE+'_P' AS INSTANCE_TYPE  -- KIMCD 2017-08-29
																		   ,B.SITE_ID
																		   ,B.FACTORY_ID
																		   ,CASE WHEN SLV.ATTRIBUTE1 = 'PLAN GROUP' THEN '-' ELSE B.FACTORY_ID END  AS LINK_FACTORY_ID	--2017-11-10 PIYONG ADD
																		   ,ISNULL(MP.SEGMENT2,'-')  AS PLAN_GROUP_ID													--2017-11-10 PIYONG ADD
																		   ,B.COMPANY_ID																					--2019-09-03 PIYONG ADD
																	  FROM DBO.[FP_INSTANCE_FACTORY_M] A WITH(NOLOCK)     
																		   ,DBO.SCM_FACTORY_M B WITH(NOLOCK)
																		   -- 2017-11-06 PIYONG  LINK_FACTORY_ID 값을 만들기 위해 테이블 조인 시작
																		   ------------------------------------------------------------------------
																		   ,SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)
																		   LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE MP WITH(NOLOCK)
																						ON MP.LOOKUP_TYPE_CODE  = 'INSTANCE_PLANNING_GROUP'
																					   AND MP.SEGMENT1 = SLV.SEGMENT1
																					   AND SLV.ATTRIBUTE1 = 'PLAN GROUP'
																		   ------------------------------------------------------------------------
																		   -- 2017-11-06 PIYONG  LINK_FACTORY_ID 값을 만들기 위해 테이블 조인 끝
																	 WHERE A.FACTORY_ID = B.FACTORY_ID     
																	   AND A.ACTIVE_FLAG = 'Y'     
																	   AND A.ACTIVE_FLAG = B.ACTIVE_FLAG     
																	   AND B.SITE_ID = @SITE_ID
																	   AND B.FACTORY_ID = @FACTORY_ID
																	   AND A.INSTANCE_ID IN ( 'KR_CELL_M_P', 'KR_CELL_A2')  -- KIMCD 2017-08-29 KIMCD 2019-02-11 예외 모델링 'KR_CELL_A2' 추가
																	   AND SLV.LOOKUP_TYPE_CODE = 'INSTANCE_ID'															--2017-11-10 PIYONG ADD
																	   AND SLV.SEGMENT1 = A.INSTANCE_ID																	--2017-11-10 PIYONG ADD
																) B      
															WHERE A.INSTANCE_ID = B.INSTANCE_ID
																AND A.FACTORY_ID = B.LINK_FACTORY_ID																	--2017-11-10 PIYONG ADD
																AND A.PLAN_GROUP_ID = B.PLAN_GROUP_ID																	--2017-11-10 PIYONG ADD
														) ZZ       
												WHERE ZZ.NUMS = 1
												-- 2017-11-10 PIYONG Plan Release Group 기준으로 최종릴리즈 버전 찾기 끝
												) B
										  WHERE A.RELEASE_PLAN_ID = B.PLAN_ID
											AND A.FACTORY_ID = B.FACTORY_ID
											AND (CLOSE_FLAG != 'Y' OR  CLOSE_FLAG IS NULL )
											--AND START_TIME < SUBSTRING( CONVERT(VARCHAR, GETDATE(), 120), 1,10 ) +@BASE_HOUR		-- [E20251105-001138] change
											-- [E20260313-002098] 당일 이후 W/O 가져온다. ( 기간 차이가 많이 나는 경우 때문)
											--AND START_TIME <= SUBSTRING( CONVERT(VARCHAR, GETDATE() +3, 120), 1,10 ) + @BASE_HOUR	-- [E20251105-001138] 3일 이후  물량까지 포함 후 balance 로직 처리 후 삭제
											AND START_TIME >= SUBSTRING( CONVERT(VARCHAR, GETDATE() -3, 120), 1,10 ) + @BASE_HOUR										-- PIYONG 2019-02-26 3일이전 대상제외 추가	-- PIYONG 2019-03-26 4일이전 대상제외 추가
											/* kimcd 2017-06-24 전월 실적 존재하는 경우 rolling 제외하는 로직 제거
											AND NOT EXISTS (SELECT 1
															  FROM DBO.SCM_MES_WIP_HISTORY_H C WITH(NOLOCK)         
															 WHERE C.WOID = A.WORK_ORDER_ID
															   AND C.WIP_TYPE_CODE IN ( 'OUT','INOUT' ,'PACKED')
															   AND WIPDTTM_ED < -- SUBSTRING( CONVERT(VARCHAR, getdate(), 120), 1,10 ) + ' '+@BASE_HOUR+':00:00'
																				SUBSTRING(CONVERT(VARCHAR, DATEADD(mm, DATEDIFF(mm,0,getdate()),0), 120), 1,10 ) + ' '+@BASE_HOUR+':00:00'
															)
											-- 마지막 실적일자가 전달이 아닌것 조건 추가
											*/
								)A
							WHERE PLAN_QTY > ISNULL( MES_QTY, 0) -- 2018-12-18 kimcd out 컬럼으로 변경

							;
						END
					/* kimcd 2017-06-24 bock 매월 1일 수행 로직 제거
					ELSE IF(SUBSTRING( CONVERT(VARCHAR, getdate(), 120), 9,2) = '01')
						BEGIN
					
								INSERT INTO @TEMP_TABLE
								SELECT DIVISION_ID
										, SITE_ID
										, FACTORY_ID
										, OPERATION_ID
										, ITEM_ID
										, EQUIPMENT_ID
										, WORK_ORDER_ID
										, RELEASE_PLAN_ID
										, PLAN_IN_QTY
								FROM (SELECT B.SITE_ID, A.*
										FROM FP_RELEASE_FIX_PLAN_H A WITH(NOLOCK)
											,( SELECT PLAN_ID
														,FACTORY_ID
														,SITE_ID
												FROM ( SELECT B.SITE_ID
																,A.INSTANCE_ID
																,INSTANCE_DATE
																,DIVISION_ID
																,A.FACTORY_ID
																,RELEASE_PLAN_ID AS PLAN_ID        
																,ROW_NUMBER() OVER ( PARTITION BY  DIVISION_ID, INSTANCE_TYPE, A.FACTORY_ID ORDER BY INSERT_TIME DESC ) NUMS -- 마지막 RELEASE VERSION         
															FROM [DBO].FP_RELEASE_PLAN_INFO_H  A        
																,( SELECT A.[INSTANCE_ID]
																		,INSTANCE_TYPE
																		,B.SITE_ID
																		,B.FACTORY_ID
																	FROM DBO.[FP_INSTANCE_FACTORY_M] A WITH(NOLOCK)     
																		,DBO.SCM_FACTORY_M B WITH(NOLOCK)    
																	WHERE A.FACTORY_ID = B.FACTORY_ID     
																	AND A.ACTIVE_FLAG = 'Y'     
																	AND A.ACTIVE_FLAG = B.ACTIVE_FLAG     
																	AND B.SITE_ID = @SITE_ID
																	AND B.FACTORY_ID = @FACTORY_ID     
																) B      
															WHERE A.INSTANCE_ID = B.INSTANCE_ID
															  AND A.FACTORY_ID = B.FACTORY_ID
														) ZZ       
												WHERE ZZ.NUMS = 1    
												) B
										WHERE A.RELEASE_PLAN_ID = B.PLAN_ID
											AND A.FACTORY_ID = B.FACTORY_ID
											AND (SELECT COUNT(1)
													FROM DBO.SCM_MES_WIP_HISTORY_H C WITH(NOLOCK)         
												WHERE C.WOID = A.WORK_ORDER_ID
													AND C.WIP_TYPE_CODE IN ( 'OUT','INOUT' ,'PACKED')
												) = 0
											AND (CLOSE_FLAG != 'Y' OR  CLOSE_FLAG IS NULL )
											AND START_TIME <  SUBSTRING( CONVERT(VARCHAR, getdate(), 120), 1,10 ) + ' '+@BASE_HOUR+':00:00' -- 1일 전이기 떄문에 전달 조건이랑 같은 의미임.
								)A
						END	*/
						
						
						
					--- 과실적 WO 처리 로직 Start [E20251019-001993]	Create
					IF 1= (
								SELECT	CASE WHEN ISNULL(COUNT(1) ,0) > 0 THEN 1 ELSE 0 END AS CNT	-- 2건 이상 있음
								FROM	FP_INSTANCE_FACTORY_M A WITH(NOLOCK)
										INNER JOIN (
													SELECT DISTINCT SEGMENT1 AS INSTANCE_ID
													FROM [DBO].[SCM_SYS_LOOKUP_VALUE]  SV WITH(NOLOCK)
													WHERE SV.LOOKUP_TYPE_CODE = 'INSTANCE_OPTION'
													AND SV.ACTIVE_FLAG = 'Y'
													AND SV.ATTRIBUTE2 = 'Y'	-- WO_BALANCE
										) B
										ON 1=1
										AND A.INSTANCE_ID = B.INSTANCE_ID
								WHERE	1=1
								AND 	A.FACTORY_ID 	= @FACTORY_ID
							)
					BEGIN
						
						--1. next flag 의 조건의 plan qty 를 조정 plan-actual 동일 history?
						
						--2. next wo 에 기존 수량 수량 만큼 증량 (잔량?)
						
						--	가장 최근의 과실적 WO 기준으로 Cursor 발췌
						DECLARE CUR_MES_NEXT_WO CURSOR FOR
							
						/*	-- [E20260212-001538] 삭제
							SELECT 	DISTINCT MAX_ACCUM_DATE, WORK_ORDER_ID, NEXT_WORK_ORDER_ID, WO_BALANCE_FLAG						--[E20251105-001138] WO_BALANCE_FLAG flag Add
							FROM 	(
										SELECT	MAX(A.ACCUM_DATE) OVER (PARTITION BY A.WORK_ORDER_ID ) AS MAX_ACCUM_DATE
												, A.ACCUM_DATE, A.WORK_ORDER_ID, A.NEXT_WORK_ORDER_ID, ATTR_01 AS WO_BALANCE_FLAG	--[E20251105-001138] WO_BALANCE_FLAG flag Add
										FROM	FP_WO_BALANCE_M A WITH(NOLOCK)
												INNER JOIN (
																SELECT	DISTINCT WORK_ORDER_ID
																FROM	FP_MES_PRODUCTION_PLAN_M A WITH(NOLOCK)
																		INNER JOIN (
																						SELECT DISTINCT SEGMENT1 AS INSTANCE_ID
																						FROM [DBO].[SCM_SYS_LOOKUP_VALUE]  SV WITH(NOLOCK)
																						WHERE SV.LOOKUP_TYPE_CODE = 'INSTANCE_OPTION'
																						AND SV.ACTIVE_FLAG = 'Y'
																						AND SV.ATTRIBUTE2 = 'Y'	-- WO_BALANCE
																					) B
																		ON 1=1
																		AND A.INSTANCE_ID = B.INSTANCE_ID
																WHERE 1=1
																AND 	A.SITE_ID    = @SITE_ID
																AND 	A.FACTORY_ID = @FACTORY_ID	
															) B
													ON 1=1
													AND A.WORK_ORDER_ID = B.WORK_ORDER_ID
												INNER JOIN  @TEMP_TABLE C
												ON 1=1
												AND A.WORK_ORDER_ID = C.WORK_ORDER_ID
										WHERE	1=1
										--AND	ACCUM_DATE <= GETDATE() -- 일자 비교 (바로전것만 할건지?)
										--AND		ISNULL(ATTR_01,'X') NOT IN ('C', 'P', 'D')	--[E20251105-001138]
										AND		ISNULL(ATTR_01,'X') NOT IN ( 'P', 'D') 		-- [E20251105-001138] 다음 Rolling 시 C 인것은 유지 하기 위해서
									) A
							--ORDER BY MAX_ACCUM_DATE, WORK_ORDER_ID
							ORDER BY WORK_ORDER_ID -- MAX_ACCUM_DATE 를 넣으면 순서가 꼬여 제외
							*/
							--[E20260212-001538] MaxDate 기준으로 찾을 경우 이미 처리된 건 이후도 처리 대상에 포함되어 Next WO 에 중복으로 수량이 더해져 rank() 로 변경 함
							SELECT 	DISTINCT MAX_ACCUM_DATE, WORK_ORDER_ID, NEXT_WORK_ORDER_ID, WO_BALANCE_FLAG						--[E20251105-001138] WO_BALANCE_FLAG flag Add
							FROM 	(
										SELECT	DENSE_RANK() OVER(PARTITION BY A.WORK_ORDER_ID ORDER BY (CASE WHEN ISNULL(ATTR_01,'X') = 'C' THEN 1 ELSE 2 END) , A.ACCUM_DATE DESC) AS WO_RANK -- [E20260212-001538] 처리된 건 먼저 순위를 가진다 
												, A.ACCUM_DATE AS MAX_ACCUM_DATE, A.WORK_ORDER_ID, A.NEXT_WORK_ORDER_ID, ATTR_01 AS WO_BALANCE_FLAG	--[E20251105-001138] WO_BALANCE_FLAG flag Add
										FROM	FP_WO_BALANCE_M A WITH(NOLOCK)
												INNER JOIN (
																SELECT	DISTINCT WORK_ORDER_ID
																FROM	FP_MES_PRODUCTION_PLAN_M A WITH(NOLOCK)
																		INNER JOIN (
																						SELECT DISTINCT SEGMENT1 AS INSTANCE_ID
																						FROM [DBO].[SCM_SYS_LOOKUP_VALUE]  SV WITH(NOLOCK)
																						WHERE SV.LOOKUP_TYPE_CODE = 'INSTANCE_OPTION'
																						AND SV.ACTIVE_FLAG = 'Y'
																						AND SV.ATTRIBUTE2 = 'Y'	-- WO_BALANCE
																					) B
																		ON 1=1
																		AND A.INSTANCE_ID = B.INSTANCE_ID
																WHERE 1=1
																AND 	A.SITE_ID    = @SITE_ID
																AND 	A.FACTORY_ID = @FACTORY_ID	
															) B
													ON 1=1
													AND A.WORK_ORDER_ID = B.WORK_ORDER_ID
												INNER JOIN  @TEMP_TABLE C
												ON 1=1
												AND A.WORK_ORDER_ID = C.WORK_ORDER_ID
										WHERE	1=1
										AND		ISNULL(ATTR_01,'X') NOT IN ( 'P', 'D') 		-- [E20251105-001138] 다음 Rolling 시 C 인것은 유지 하기 위해서
									) A
							WHERE 1=1
							AND WO_RANK = 1			-- [E20260212-001538] 우선 순위가 1 인것만 대상으로 삼는다. 
							ORDER BY WORK_ORDER_ID -- MAX_ACCUM_DATE 를 넣으면 순서가 꼬여 제외
							
							DECLARE @MAX_ACCUM_DATE		NVARCHAR(50)
							--DECLARE @ACCUM_DATE			NVARCHAR(50)
							DECLARE @WORK_ORDER_ID		NVARCHAR(50)
							DECLARE @NEXT_WORK_ORDER_ID	NVARCHAR(50)
							DECLARE @WO_BALANCE_FLAG	NVARCHAR(10)	-- [E20251105-001138] WO_BALANCE_FLAG flag Add
							
							OPEN CUR_MES_NEXT_WO;
								FETCH NEXT FROM CUR_MES_NEXT_WO INTO @MAX_ACCUM_DATE
																	,@WORK_ORDER_ID
																	,@NEXT_WORK_ORDER_ID
																	,@WO_BALANCE_FLAG		-- [E20251105-001138] WO_BALANCE_FLAG flag Add
								    ;
							
								
								WHILE (@@FETCH_STATUS = 0)
								BEGIN
									
									-- 1. 기준 테이블에서 org, 실적을 반영한다.
									UPDATE 	A
									SET		A.ORG_PLAN_QTY = B.PLAN_IN_QTY
										   ,A.ACTUAL_IN_QTY = B.MES_QTY
									FROM	FP_WO_BALANCE_M A
											INNER JOIN @TEMP_TABLE B
											ON 1=1
											AND A.WORK_ORDER_ID = B.WORK_ORDER_ID
									WHERE 1=1
									AND		A.WORK_ORDER_ID	= @WORK_ORDER_ID
									AND		A.ACCUM_DATE    = @MAX_ACCUM_DATE
									AND		ISNULL(A.ATTR_01,'X')	!= 'C'	-- [E20251105-001138] 이미 사용한건 제외
									;
									
									
									-- 2. 기준 테이블에서 Deduct 수량 계산
									UPDATE A
									SET		A.PLAN_QTY = B.PLAN_IN_QTY
											, A.ACTUAL_QTY = B.MES_QTY
											, A.DEDUCT_QTY = ISNULL(B.PLAN_IN_QTY,0) - ISNULL(B.MES_QTY,0)
											, A.UPDATE_ID = 'A'
											, A.UPDATE_DTTM = GETDATE()
											, A.ATTR_01 = 'P'
									FROM	FP_WO_BALANCE_M A
											INNER JOIN @TEMP_TABLE B
											ON 1=1
											AND A.WORK_ORDER_ID = B.WORK_ORDER_ID
									WHERE 1=1
									AND		A.WORK_ORDER_ID	= @WORK_ORDER_ID
									AND		A.ACCUM_DATE    = @MAX_ACCUM_DATE
									AND		ISNULL(A.ATTR_01,'X')	!= 'C'	--[E20251105-001138] 이미 사용한건 제외
									;
									
										
									-- 3. 기준 테이블에 변경 된 계획 수량 반영 ( WO balance 되었더라도 수량 맞춤 )	[E20251105-001138]
									UPDATE A
									SET 	A.PLAN_IN_QTY = CASE WHEN A.PLAN_IN_QTY < A.MES_QTY THEN A.PLAN_IN_QTY
									                      		 ELSE A.MES_QTY END
									       ,A.CHANGE_FLAG = 'Y' 
									FROM	@TEMP_TABLE A
									WHERE 1=1
									AND WORK_ORDER_ID = @WORK_ORDER_ID
									;
									
									-- 4. 기준 테이블에 Next WO 에 Deduct 수량 반영
									UPDATE 	A
									SET 	A.PLAN_IN_QTY = A.PLAN_IN_QTY + B.DEDUCT_QTY
										   ,A.CHANGE_FLAG = 'Y'
									FROM	@TEMP_TABLE A
											INNER JOIN FP_WO_BALANCE_M B WITH(NOLOCK)
											ON 1=1
											AND		A.WORK_ORDER_ID	= B.NEXT_WORK_ORDER_ID
											AND		B.ACCUM_DATE    = @MAX_ACCUM_DATE
											AND 	B.DEDUCT_QTY    > 0
									WHERE 1=1
									AND A.WORK_ORDER_ID = @NEXT_WORK_ORDER_ID
									;
									
									-- 5. Balance 테이블에 완료 처리
									UPDATE A
									SET		  A.UPDATE_ID = @v_proc_name
											, A.UPDATE_DTTM = GETDATE()
											, A.ATTR_01 = 'C'
											, A.ATTR_02 = ISNULL(A.ATTR_02,0) + 1	-- [E20251105-001138] 재 롤링횟수
									FROM	FP_WO_BALANCE_M A
											INNER JOIN @TEMP_TABLE B				--[E20251105-001138] Rolling 에 포함 된 W/O 만
											ON 1=1
											AND A.WORK_ORDER_ID = B.WORK_ORDER_ID
									WHERE 1=1
									AND		A.WORK_ORDER_ID	= @WORK_ORDER_ID
									AND		A.ACCUM_DATE    = @MAX_ACCUM_DATE
									;
									
									-- 6. Balance 테이블에 이전 WO 는 Delete 처리 한다.	--[E20251105-001138] 최종 하나의 W/O 사용하고 이전 동일 W/O 는 제외
									UPDATE A
									SET		  A.UPDATE_ID = @v_proc_name
											, A.UPDATE_DTTM = GETDATE()
											, A.ATTR_01 = 'D'
									FROM	FP_WO_BALANCE_M A
											INNER JOIN @TEMP_TABLE B
											ON 1=1
											AND A.WORK_ORDER_ID = B.WORK_ORDER_ID
									WHERE 1=1
									AND		A.WORK_ORDER_ID	= @WORK_ORDER_ID
									--AND		A.ACCUM_DATE    < @MAX_ACCUM_DATE 
									AND		A.ACCUM_DATE    <> @MAX_ACCUM_DATE	-- [E20260212-001538] 처리가 되면 나머지는 DELETE 이후에도 I/F 되는 건이 있음
									;
									
									FETCH NEXT FROM CUR_MES_NEXT_WO INTO @MAX_ACCUM_DATE
																		,@WORK_ORDER_ID
																		,@NEXT_WORK_ORDER_ID
																		,@WO_BALANCE_FLAG			-- [E20251105-001138] WO_BALANCE_FLAG flag Add
								    ;
								  
								END	--WHILE END
								
							CLOSE CUR_MES_NEXT_WO;
							DEALLOCATE CUR_MES_NEXT_WO;		
							
					END
					
					-- --[E20251105-001138] 현재 이후 건 중 next wo 대상을 제외한 건 들은 rolling 목록에서 제외한다.
					DELETE 	@TEMP_TABLE
					WHERE 	1=1
					AND		PLAN_START_TIME >= SUBSTRING( CONVERT(VARCHAR, GETDATE(), 120), 1,10 ) + @BASE_HOUR
					AND		ISNULL(CHANGE_FLAG,'X') != 'Y'
					;
					--- ## 과실적 WO 처리 로직 End --
						
						
					SET @SEQ = NEXT VALUE FOR RELEASE_PLAN

						-- ERP 전송 WO 정보 생성
					INSERT INTO  DBO.SY_XIF_ERP_PRODUCTION_PLAN_S 
					(
					[IFSEQNO]
					,[SEQ]
					,[FP_PLAN_ID]
					,[PLANT_ID]
					,[FACTORY_ID]
					,[LINE_ID]
					,[OPERATION_ID]
					,[BOM_VERSION_ID]
					,[WORK_CENTER_ID]
					,[ITEM_ID]
					,[DEMAND_ID]
					,[WORK_ORDER_ID]
					,[ORDER_TYPE]
					,[PLAN_DATE]
					,[START_TIME]
					,[END_TIME]
					,[PLAN_IN_QTY]
					,[PLAN_QTY]
					,[FIX_TYPE]
					,[TRANSFER_FLAG]
					,[TRANSFER_DATE]
					,[CREATE_USER_ID]
					,[CREATE_DATE]
					,[MODIFY_USER_ID]
					,[MODIFY_DATE]
					,[LANE_QTY]
					,[BATCH_ORDER_ID]
					,[SLITTER_PLANT]
					,[MARKET]
					,[ATTRIBUTE1]
					,[ATTRIBUTE2]
					,[ATTRIBUTE3]
					,[ATTRIBUTE4]
					,[ATTRIBUTE5]
					,[ATTRIBUTE6]
					,[ATTRIBUTE7]
					,[ATTRIBUTE8]
					,[ATTRIBUTE9]
					,[ATTRIBUTE10]
					,[TOP_BACK_IND]
					,[LINK_WO]
					,[FP_PLAN_QTY]
					,[FP_SNAP_QTY]
					,[TECO_IND]
					,[ZMODEL]
					,[VERSION]
					,[SERIAL]
					,[EQUIPMENT_ID]
					,[PLAN_GRP]
					,[PLAN_WEEK]
					,[SCP_PLAN_ID]
					,[CUDTY]
					)
					-- 2018-05-26 kimcd 조회 컬럼 전체에 NVL 처리함. IF 테이블에 존재하면 사용, 없는 경우 WO Master 기준으로 가공 시작
					SELECT REPLACE(REPLACE(REPLACE(CONVERT(NVARCHAR(19),GETDATE(),120),'-',''),':',''),' ','') -- [IFSEQNO]     
							,ROW_NUMBER() OVER ( ORDER BY ISNULL(A.LINE_ID,C.ATTRIBUTE1), ISNULL(A.ITEM_ID,C.ITEM_ID)) --[SEQ]      ,ROW_NUMBER() OVER ( ORDER BY LINE_ID, ITEM_ID) --[SEQ]
							,CONCAT(B.RELEASE_PLAN_ID,'_00X',@SEQ)
							,ISNULL(A.[PLANT_ID],C.PLANT_ID)
							,ISNULL(A.[FACTORY_ID],C.FACTORY_ID)
							,ISNULL(A.[LINE_ID],C.ATTRIBUTE1)
							,ISNULL(A.[OPERATION_ID],C.OPERATION_ID)
							,A.[BOM_VERSION_ID]
							,ISNULL(A.[WORK_CENTER_ID],C.WORK_CENTER_ID)
							,ISNULL(A.[ITEM_ID],C.ITEM_ID)
							,ISNULL(A.[DEMAND_ID],C.WORK_ORDER_ID)
							,ISNULL(A.[WORK_ORDER_ID],C.WORK_ORDER_ID)
							,ISNULL(A.[ORDER_TYPE],C.PRODUCTION_TYPE)
							/* -- [E20260313-002098] 당일이후 W/O 인 경우일자가 바뀌는 오류 수정.
							,REPLACE(REPLACE(REPLACE(CONVERT(NVARCHAR(19),CAST( SUBSTRING( CONVERT( VARCHAR, GETDATE(), 120 ) , 1, 10 ) + (SELECT CONCAT(' ', SUBSTRING(SEGMENT2, 1, 2), ':',SUBSTRING(SEGMENT2, 3, 2), ':',SUBSTRING(SEGMENT2, 5, 2))
																																			 FROM [DBO].[SCM_SYS_LOOKUP_VALUE] W  WITH(NOLOCK)
																																			WHERE W.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
																																			  AND W.ACTIVE_FLAG = 'Y'
																																			  AND SEGMENT1 = ISNULL(A.[PLANT_ID],C.PLANT_ID)
																																		  ) AS DATETIME) ,120),'-',''),':',''),' ','')						-- [PLAN_DATE]
							,REPLACE(REPLACE(REPLACE(CONVERT(NVARCHAR(19),CAST( SUBSTRING( CONVERT( VARCHAR, GETDATE(), 120 ) , 1, 10 ) +(SELECT CONCAT(' ', SUBSTRING(SEGMENT2, 1, 2), ':',SUBSTRING(SEGMENT2, 3, 2), ':',SUBSTRING(SEGMENT2, 5, 2))
																																			 FROM [DBO].[SCM_SYS_LOOKUP_VALUE] W  WITH(NOLOCK)
																																			WHERE W.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
																																			  AND W.ACTIVE_FLAG = 'Y'
																																			  AND SEGMENT1 = ISNULL(A.[PLANT_ID],C.PLANT_ID)
																																		  ) AS DATETIME) ,120),'-',''),':',''),' ','')						 -- [START_TIME]
							,REPLACE(REPLACE(REPLACE(CONVERT(NVARCHAR(19),CAST( SUBSTRING( CONVERT( VARCHAR, GETDATE(), 120 ) , 1, 10 ) + (SELECT CONCAT(' ', SUBSTRING(SEGMENT2, 1, 2), ':',SUBSTRING(SEGMENT2, 3, 2)+10, ':',SUBSTRING(SEGMENT2, 5, 2))
																																			 FROM [DBO].[SCM_SYS_LOOKUP_VALUE] W  WITH(NOLOCK)
																																			WHERE W.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
																																			  AND W.ACTIVE_FLAG = 'Y'
																																			  AND SEGMENT1 = ISNULL(A.[PLANT_ID],C.PLANT_ID)
																																		  ) AS DATETIME) ,120),'-',''),':',''),' ','')						-- [END_TIME]
							*/
							-- [E20260313-002098] 당일이후 W/O 인 경우일자가 바뀌는 오류 수정. START
							, CASE WHEN B.PLAN_START_TIME >= SUBSTRING( CONVERT(VARCHAR, GETDATE(), 120), 1,10 ) + @BASE_HOUR THEN REPLACE(REPLACE(REPLACE(CONVERT(NVARCHAR(19),B.PLAN_DATE,120),'-',''),':',''),' ','')
							       ELSE REPLACE(REPLACE(REPLACE(CONVERT(NVARCHAR(19),CAST( SUBSTRING( CONVERT( VARCHAR, GETDATE(), 120 ) , 1, 10 ) + (SELECT CONCAT(' ', SUBSTRING(SEGMENT2, 1, 2), ':',SUBSTRING(SEGMENT2, 3, 2), ':',SUBSTRING(SEGMENT2, 5, 2))
																																			 FROM [DBO].[SCM_SYS_LOOKUP_VALUE] W  WITH(NOLOCK)
																																			WHERE W.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
																																			  AND W.ACTIVE_FLAG = 'Y'
																																			  AND SEGMENT1 = ISNULL(A.[PLANT_ID],C.PLANT_ID)
																																		  ) AS DATETIME) ,120),'-',''),':',''),' ','')						-- [PLAN_DATE]
							  END
							, CASE WHEN B.PLAN_START_TIME >= SUBSTRING( CONVERT(VARCHAR, GETDATE(), 120), 1,10 ) + @BASE_HOUR THEN REPLACE(REPLACE(REPLACE(CONVERT(NVARCHAR(19),B.START_TIME,120),'-',''),':',''),' ','')
								   ELSE REPLACE(REPLACE(REPLACE(CONVERT(NVARCHAR(19),CAST( SUBSTRING( CONVERT( VARCHAR, GETDATE(), 120 ) , 1, 10 ) +(SELECT CONCAT(' ', SUBSTRING(SEGMENT2, 1, 2), ':',SUBSTRING(SEGMENT2, 3, 2), ':',SUBSTRING(SEGMENT2, 5, 2))
																																			 FROM [DBO].[SCM_SYS_LOOKUP_VALUE] W  WITH(NOLOCK)
																																			WHERE W.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
																																			  AND W.ACTIVE_FLAG = 'Y'
																																			  AND SEGMENT1 = ISNULL(A.[PLANT_ID],C.PLANT_ID)
																																		  ) AS DATETIME) ,120),'-',''),':',''),' ','')						 -- [START_TIME]
							  END
							, CASE WHEN B.PLAN_START_TIME >= SUBSTRING( CONVERT(VARCHAR, GETDATE(), 120), 1,10 ) + @BASE_HOUR THEN REPLACE(REPLACE(REPLACE(CONVERT(NVARCHAR(19),B.END_TIME,120),'-',''),':',''),' ','')							
								   ELSE REPLACE(REPLACE(REPLACE(CONVERT(NVARCHAR(19),CAST( SUBSTRING( CONVERT( VARCHAR, GETDATE(), 120 ) , 1, 10 ) + (SELECT CONCAT(' ', SUBSTRING(SEGMENT2, 1, 2), ':',SUBSTRING(SEGMENT2, 3, 2)+10, ':',SUBSTRING(SEGMENT2, 5, 2))
																																			 FROM [DBO].[SCM_SYS_LOOKUP_VALUE] W  WITH(NOLOCK)
																																			WHERE W.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
																																			  AND W.ACTIVE_FLAG = 'Y'
																																			  AND SEGMENT1 = ISNULL(A.[PLANT_ID],C.PLANT_ID)
																																		  ) AS DATETIME) ,120),'-',''),':',''),' ','')						-- [END_TIME]
							  END
							-- [E20260313-002098] 당일이후 W/O 인 경우일자가 바뀌는 오류 수정. END
							,CASE WHEN B.CHANGE_FLAG = 'Y' THEN B.PLAN_IN_QTY ELSE ISNULL(A.[PLAN_IN_QTY],C.PLAN_IN_QTY) 	END 	-- [E20251019-001993]	변경 할 수량 반영 Modify
							,CASE WHEN B.CHANGE_FLAG = 'Y' THEN B.PLAN_IN_QTY ELSE ISNULL(A.[PLAN_QTY],C.PLAN_QTY) 			END   	-- [E20251019-001993]	변경 할 수량 반영 Modify
							,ISNULL(A.[FIX_TYPE],C.FIX_TYPE)
							,'N' --[TRANSFER_FLAG]
							,A.[TRANSFER_DATE]
							,ISNULL(A.[CREATE_USER_ID],@v_proc_name)
							,ISNULL(A.[CREATE_DATE],GETDATE())
							,'MONTH_CHAGE_ADJ' -- [MODIFY_USER_ID]
							,GETDATE() -- [MODIFY_DATE]
							,ISNULL(A.[LANE_QTY],C.LANE_QTY)
							,ISNULL(A.[BATCH_ORDER_ID],C.BATCH_ORDER_ID)
							,ISNULL(A.[SLITTER_PLANT],C.SLIT_PLANT_ID)
							,ISNULL(A.[MARKET],C.MARKET)
							,A.[ATTRIBUTE1]
							,A.[ATTRIBUTE2]
							,A.[ATTRIBUTE3]
							,A.[ATTRIBUTE4]
							,A.[ATTRIBUTE5]
							,A.[ATTRIBUTE6]
							,A.[ATTRIBUTE7]
							,A.[ATTRIBUTE8]
							,CASE WHEN B.CHANGE_FLAG = 'Y' THEN B.PLAN_IN_QTY ELSE A.[PLAN_IN_QTY]	END		-- [E20251019-001993]	변경 할 수량 반영 Modify
							,CASE WHEN B.CHANGE_FLAG = 'Y' THEN B.PLAN_IN_QTY ELSE A.[PLAN_QTY]		END		-- [E20251019-001993]	변경 할 수량 반영 Modify
							,CASE WHEN EQPC.SEGMENT1 IS NOT NULL AND IMC.SEGMENT1 IS NOT NULL THEN
										'B'
									END AS TOP_BACK_IND -- 단면 설비에 양면 제품이 계획된 경우 TOP BACK 구분
							,CASE WHEN EQPC.SEGMENT1 IS NOT NULL AND IMC.SEGMENT1 IS NOT NULL THEN
									CASE WHEN ISNULL(A.WORK_ORDER_ID,C.WORK_ORDER_ID) LIKE 'W%' OR ISNULL(A.WORK_ORDER_ID,C.WORK_ORDER_ID) LIKE 'M%' THEN
										SUBSTRING(ISNULL(A.WORK_ORDER_ID,C.WORK_ORDER_ID),1,5) + CONVERT(NVARCHAR(2), CONVERT(NUMERIC,SUBSTRING(ISNULL(A.WORK_ORDER_ID,C.WORK_ORDER_ID),6,2)) + 50) + SUBSTRING(ISNULL(A.WORK_ORDER_ID,C.WORK_ORDER_ID),8,10)
									WHEN SUBSTRING(ISNULL(A.WORK_ORDER_ID,C.WORK_ORDER_ID),9,1) = '0' THEN
										CASE WHEN SUBSTRING(ISNULL(A.WORK_ORDER_ID,C.WORK_ORDER_ID),6,1) = 'X' THEN
											SUBSTRING(ISNULL(A.WORK_ORDER_ID,C.WORK_ORDER_ID),1,5) + 'Y' + SUBSTRING(ISNULL(A.WORK_ORDER_ID,C.WORK_ORDER_ID),7,10)
										ELSE
											SUBSTRING(ISNULL(A.WORK_ORDER_ID,C.WORK_ORDER_ID),1,4) + CONVERT(NVARCHAR(2), CONVERT(NUMERIC,SUBSTRING(ISNULL(A.WORK_ORDER_ID,C.WORK_ORDER_ID),5,2)) + 50) + SUBSTRING(ISNULL(A.WORK_ORDER_ID,C.WORK_ORDER_ID),7,10)
										END
									ELSE
										CASE WHEN SUBSTRING(ISNULL(A.WORK_ORDER_ID,C.WORK_ORDER_ID),7,1) = 'X' THEN
											SUBSTRING(ISNULL(A.WORK_ORDER_ID,C.WORK_ORDER_ID),1,6) + 'Y' + SUBSTRING(ISNULL(A.WORK_ORDER_ID,C.WORK_ORDER_ID),8,10)
										ELSE
											SUBSTRING(ISNULL(A.WORK_ORDER_ID,C.WORK_ORDER_ID),1,5) + CONVERT(NVARCHAR(2), CONVERT(NUMERIC,SUBSTRING(ISNULL(A.WORK_ORDER_ID,C.WORK_ORDER_ID),6,2)) + 50) + SUBSTRING(ISNULL(A.WORK_ORDER_ID,C.WORK_ORDER_ID),8,10)
										END
									END -- 2018-03-06 kimcd work order id 채번 rule 변경에 따른 TOP, Back 로직 WO 로직 수정
								END AS LINK_WO      -- 연계된 WO명 - TOP은 BACK WO, BACK은 TOP WO
							,CASE WHEN B.CHANGE_FLAG = 'Y' THEN B.PLAN_IN_QTY ELSE A.PLAN_IN_QTY END AS FP_PLAN_QTY  -- FP PLAN 수량	-- [E20251019-001993]	변경 할 수량 반영 Modify
							,-- 2018-05-26 kimcd 막음 ISNULL((SELECT ISNULL(SUM(MPP.ACTUAL_QTY),0) FROM [DBO].[FP_MES_PRODUCTION_PLAN_M] MPP WITH(NOLOCK)
							--		WHERE  MPP.WORK_ORDER_ID     = A.WORK_ORDER_ID
							--		AND    MPP.ITEM_ID           = A.ITEM_ID),0) AS FP_SNAP_QTY  -- FP 실적 수량
							C.ACTUAL_QTY -- 2018-05-26 kimcd 실적을 ERP W/O Master에서 직접 추출
							,A.TECO_IND	
						-- 2018-05-26 kimcd 조회 컬럼 전체에 NVL 처리함. IF 테이블에 존재하면 사용, 없는 경우 WO Master 기준으로 가공 끝
							--- FIX --
							,A.ZMODEL
							,A.VERSION
							,A.SERIAL
							,A.EQUIPMENT_ID
							,A.PLAN_GRP
							,A.PLAN_WEEK
							,A.SCP_PLAN_ID
							,A.CUDTY
						FROM @TEMP_TABLE B
						LEFT OUTER JOIN DBO.SY_XIF_ERP_PRODUCTION_PLAN_S A -- 2018-05-26 kimcd left outer join으로 전환
							ON  A.WORK_ORDER_ID = B.WORK_ORDER_ID
							AND A.FP_PLAN_ID = B.RELEASE_PLAN_ID
						LEFT OUTER JOIN DBO.FP_ERP_PRODUCTION_PLAN_M C -- 2018-05-26 kimcd erp work order master 추가
							ON  C.WORK_ORDER_ID = B.WORK_ORDER_ID
						LEFT OUTER JOIN [DBO].[SCM_EQUIPMENT_M]  EQP WITH(NOLOCK)
							ON EQP.EQUIPMENT_ID = B.EQUIPMENT_ID
						AND EQP.OPERATION_ID = B.OPERATION_ID
						AND EQP.FACTORY_ID   = B.FACTORY_ID
						AND EQP.EQUIPMENT_TYPE = 'M'
						AND EQP.ACTIVE_FLAG    = 'Y'
						LEFT OUTER JOIN [DBO].[SCM_SYS_LOOKUP_VALUE]  EQPC WITH(NOLOCK)
							ON EQPC.LOOKUP_TYPE_CODE = 'FP_COATER_TOP_COPY_OP'
						AND EQPC.SEGMENT1         = EQP.OPERATION_ID
						AND EQPC.SEGMENT2         = EQP.COATER_EQPT_TYPE_CODE
						AND EQPC.ACTIVE_FLAG      = 'Y'
						LEFT OUTER JOIN [DBO].[SCM_ITEM_M]  IM WITH(NOLOCK)
							ON IM.COMPANY_ID = B.COMPANY_ID
					    AND IM.DIVISION_ID  = B.DIVISION_ID
						AND IM.SITE_ID      = B.SITE_ID
						AND IM.ITEM_ID      = B.ITEM_ID
						LEFT OUTER JOIN [DBO].[SCM_SYS_LOOKUP_VALUE]  IMC WITH(NOLOCK)
							ON IMC.LOOKUP_TYPE_CODE = 'FP_COATER_TOP_COPY_ITEM_CLASS'
						AND IMC.SEGMENT1         = IM.ITEM_CLASS
						AND IMC.ACTIVE_FLAG      = 'Y' 
						WHERE ISNULL(A.[WORK_ORDER_ID],C.WORK_ORDER_ID) IS NOT NULL  -- 2018-05-26 kimcd WORK ORDER 존재하는 경우만 전송
						;

	
					INSERT INTO [dbo].[SY_XIF_ERP_PRODUCTION_PLAN_S]
							([IFSEQNO]
							,[SEQ]
							,[FP_PLAN_ID]
							,[PLANT_ID]
							,[FACTORY_ID]
							,[LINE_ID]
							,[OPERATION_ID]
							,[BOM_VERSION_ID]
							,[WORK_CENTER_ID]
							,[ITEM_ID]
							,[DEMAND_ID]
							,[WORK_ORDER_ID]
							,[ORDER_TYPE]
							,[PLAN_DATE]
							,[START_TIME]
							,[END_TIME]
							,[PLAN_IN_QTY]
							,[PLAN_QTY]
							,[FIX_TYPE]
							,[TRANSFER_FLAG]
							,[TRANSFER_DATE]
							,[CREATE_USER_ID]
							,[CREATE_DATE]
							,[MODIFY_USER_ID]
							,[MODIFY_DATE]
							,[LANE_QTY]
							,[BATCH_ORDER_ID]
							,[SLITTER_PLANT]
							,[MARKET] -- 170208 Add
							,[ATTRIBUTE1]
							,[ATTRIBUTE2]
							,[ATTRIBUTE3]
							,[ATTRIBUTE4]
							,[ATTRIBUTE5]
							,[ATTRIBUTE6]
							,[ATTRIBUTE7]
							,[ATTRIBUTE8]
							,[ATTRIBUTE9]
							,[ATTRIBUTE10]
							,[TOP_BACK_IND] -- 단면 설비에 양면 제품이 계획된 경우 TOP BACK 구분
							,[LINK_WO]      -- 연계된 WO명 - TOP은 Back WO, Back은 TOP WO
							,[FP_PLAN_QTY]  -- FP Plan 수량
							,[FP_SNAP_QTY]) -- FP 실적 수량
					SELECT  REPLACE(REPLACE(REPLACE(CONVERT(NVARCHAR(19),GETDATE(),120),'-',''),':',''),' ','') -- [IFSEQNO]
							,2000 + ROW_NUMBER() OVER( ORDER BY A.[FP_PLAN_ID], A.[PLANT_ID], A.[FACTORY_ID], A.[LINE_ID], A.[OPERATION_ID], A.[ITEM_ID], A.[WORK_ORDER_ID] ) AS SEQ
							,A.[FP_PLAN_ID]
							,A.[PLANT_ID]
							,A.[FACTORY_ID]
							,A.[LINE_ID]
							,A.[OPERATION_ID]
							,A.[BOM_VERSION_ID]
							,A.[WORK_CENTER_ID]
							,A.[ITEM_ID]
							,A.[DEMAND_ID]
							,A.[LINK_WO]    -- [WORK_ORDER_ID]
							,A.[ORDER_TYPE]
							,A.[PLAN_DATE]
							,A.[START_TIME]
							,A.[END_TIME]
							,A.[PLAN_IN_QTY]
							,A.[PLAN_QTY]
							,A.[FIX_TYPE]
							,A.[TRANSFER_FLAG]
							,A.[TRANSFER_DATE]
							,A.[CREATE_USER_ID]
							,A.[CREATE_DATE]
							,A.[MODIFY_USER_ID]
							,A.[MODIFY_DATE]
							,A.[LANE_QTY]
							,A.[BATCH_ORDER_ID]
							,A.[SLITTER_PLANT]
							,A.[MARKET]
							,A.[ATTRIBUTE1]
							,A.[ATTRIBUTE2]
							,A.[ATTRIBUTE3]
							,A.[ATTRIBUTE4]
							,A.[ATTRIBUTE5]
							,A.[ATTRIBUTE6]
							,A.[ATTRIBUTE7]
							,A.[ATTRIBUTE8]
							,A.[ATTRIBUTE9]
							,A.[ATTRIBUTE10]
							,'T'               -- [TOP_BACK_IND] 단면 설비에 양면 제품이 계획된 경우 TOP BACK 구분
							,A.[WORK_ORDER_ID] -- [LINK_WO] 연계된 WO명 - TOP은 Back WO, Back은 TOP WO
							,A.[FP_PLAN_QTY]   -- FP Plan 수량
							,A.[FP_SNAP_QTY]   -- FP 실적 수량
					FROM    [dbo].[SY_XIF_ERP_PRODUCTION_PLAN_S] A WITH(NOLOCK)
					WHERE   A.[FP_PLAN_ID] IN  (SELECT CONCAT(B.RELEASE_PLAN_ID,'_00X',@SEQ)
													FROM @TEMP_TABLE B )
					AND     A.[TOP_BACK_IND] = 'B';

					-- MES 전송 WO 정보 생성
					INSERT INTO [DBO].[SY_XIF_MES_WO_S]
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
							  ,[DEMAND_ID]
							  ,[WO]
							  ,[WO_TYPE]
							  ,[WO_DETAIL]
							  ,[PLAN_DATE]
							  ,[START_TIME]
							  ,[END_TIME]
							  ,[IN_QTY]
							  ,[OUT_QTY]
							  ,[IS_RELEASE]
							  ,[CREATE_PSN_ID]
							  ,[CREATE_DATE]
							  ,[UPDATE_PSN_ID]
							  ,[UPDATE_DATE]
							  ,[LANE_QTY]
							  ,[UNIT]
							  ,[ORDER_TYPE]
							  ,[BATCH_ORDER_ID]
							  ,[SLITTER_PLANT]
							  ,[MARKET]
							  -- ,[ATTR_01] 2020-07-27 kimcd total batch 수 정보 전송 제거
							  ,[ATTR_02]
							  -- ,[ATTR_03] 2020-07-27 kimcd total batch kg 정보 전송 제거
							  ,[ATTR_04]
							  ,[ATTR_05]
							  ,[ATTR_06]
							  ,[ATTR_07]
							  ,[ATTR_08]
							  ,[ATTR_09]
							  ,[ATTR_10]
							  ,[ATTR_11] -- PILOT 구분 PIYONG ADD 2017-08-30
							  ,[ATTR_12] -- TOP_ITEM_ID PIYONG ADD 2017-11-23
							  ,[ATTR_13] -- 2018-05-26 kimcd 테스트 수요용 work order 중 첫 공정 work order 구분자
							  ,[ATTR_14] -- 2018-07-05 kimcd VD 공정이 테스트 수요용 work order 중 첫 공정 work order 구분자
							  ,[ATTR_17] -- 2022-11-24 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
							  ,[ATTR_18] -- 2022-11-24 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
							  ,[ATTR_19] -- 2022-11-24 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
							  ,[ATTR_20] -- 2022-11-24 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
					)
					-- 2018-05-26 kimcd 조회 컬럼 전체에 NVL 처리함. IF 테이블에 존재하면 사용, 없는 경우 WO Master 기준으로 가공 시작
					SELECT 'OFP0' + SUBSTRING(CONVERT(NVARCHAR(12), GETDATE(), 112), 3,6) + REPLICATE('0', 10 - LEN(NEXT VALUE FOR [DBO].[XIF_MES_SEND_SEQ])) + CAST( NEXT VALUE FOR [DBO].[XIF_MES_SEND_SEQ] AS NVARCHAR)   -- IF_SEQ      ,[IF_TYPE]
							,'S'
							,'OFP0'+'_'+ISNULL(ISNULL( (SELECT LM.MES_SOURCE_GROUP 
														FROM  SCM_MMD_LINE_M LM (NOLOCK) 
														WHERE LM.FACTORY_ID = ISNULL(SOURCES.[BUILNO], ISNULL(F.FACTORY_ID,C.FACTORY_ID)) 	-- [E20251205-001628] Column 변경 
														AND LM.LINE_ID 		= ISNULL(SOURCES.[LINE_ID],SL.MES_LINE_ID)) -- 2022-08-12 kimcd MES 라인 기준을 설비에서 라인으로 변경 -- 2021-06-04 kimcd  M8(남경 소형 6동) MES Instance 분리에 따른 대응
														, ISNULL(F.MES_SOURCE_GROUP,'') ),'') +'_'+'FP_WO' -- [IF_ID] 	-- [E20251205-001628] Column 변경 
							,GETDATE() -- [IF_INS_DATE] 2020-07-27 kimcd 전송 정보 형성 시간을 현재 시간으로 입력
							,'N' --[IF_FLAG]
							,SOURCES.[IF_SND_DATE]
							,NULL -- [RSLT_IF_SEQ]
							,NULL--[RSLT_PROC_FLAG]
							,NULL--[RSLT_PROC_MSG]
							,CONCAT(B.RELEASE_PLAN_ID,'_00X',@SEQ)
							,ISNULL(SOURCES.[PLANT_ID], F.MES_PLANT_ID)  -- 2024-04-08 NERP PLANT_ID 변경에 따른 CONVERSION 반영
							,ISNULL(SOURCES.[BUILNO], ISNULL(F.FACTORY_ID,C.FACTORY_ID))		-- [E20251205-001628] 변경 된 FACTORY 정보를 보냄
							,ISNULL(SOURCES.[LINE_ID],ISNULL(EQP.MES_LINE_ID,SL.MES_LINE_ID))  -- 2022-08-12 kimcd MES 라인 기준을 설비에서 라인으로 변경
							,ISNULL(SOURCES.[OPERATION_ID],C.OPERATION_ID)
							,ISNULL(SOURCES.[EQUIPMENT_ID],C.EQUIPMENT_ID)
							,ISNULL(SOURCES.[ITEM_ID],C.ITEM_ID)
							,ISNULL(SOURCES.[DEMAND_ID],C.WORK_ORDER_ID)
							,ISNULL(SOURCES.[WO],C.WORK_ORDER_ID)
							,ISNULL(SOURCES.[WO_TYPE],C.ORDER_TYPE+'O')
							,ISNULL(SOURCES.[WO_DETAIL],C.WORK_ORDER_SPL_ID)
							/*	-- [E20260313-002098] 당일이후 W/O 인 경우일자가 바뀌는 오류 수정. 
							,CONVERT(NVARCHAR(50), CAST( SUBSTRING( CONVERT( VARCHAR, GETDATE(), 120 ) , 1, 10 ) + (SELECT CONCAT(' ', SUBSTRING(SEGMENT2, 1, 2), ':',SUBSTRING(SEGMENT2, 3, 2), ':',SUBSTRING(SEGMENT2, 5, 2))
																													  FROM [DBO].[SCM_SYS_LOOKUP_VALUE] W  WITH(NOLOCK)
																													 WHERE W.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
																													   AND W.ACTIVE_FLAG = 'Y'
																													   AND SEGMENT1 = ISNULL(F.PLANT_ID ,C.PLANT_ID)  -- 2024-04-08 NERP PLANT_ID 변경에 따른 CONVERSION 반영
																													) AS DATETIME), 120) -- [PLAN_DATE]
							,CONVERT(NVARCHAR(50), CAST( SUBSTRING( CONVERT( VARCHAR, GETDATE(), 120 ) , 1, 10 ) + (SELECT CONCAT(' ', SUBSTRING(SEGMENT2, 1, 2), ':',SUBSTRING(SEGMENT2, 3, 2), ':',SUBSTRING(SEGMENT2, 5, 2))
																													  FROM [DBO].[SCM_SYS_LOOKUP_VALUE] W  WITH(NOLOCK)
																													 WHERE W.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
																													   AND W.ACTIVE_FLAG = 'Y'
																													   AND SEGMENT1 = ISNULL(F.PLANT_ID ,C.PLANT_ID)  -- 2024-04-08 NERP PLANT_ID 변경에 따른 CONVERSION 반영
																													) AS DATETIME), 120) -- [START_TIME]
							,CONVERT(NVARCHAR(50), CAST( SUBSTRING( CONVERT( VARCHAR, GETDATE(), 120 ) , 1, 10 ) + (SELECT CONCAT(' ', SUBSTRING(SEGMENT2, 1, 2), ':',SUBSTRING(SEGMENT2, 3, 2)+10, ':',SUBSTRING(SEGMENT2, 5, 2))
																													  FROM [DBO].[SCM_SYS_LOOKUP_VALUE] W  WITH(NOLOCK)
																													 WHERE W.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
																													   AND W.ACTIVE_FLAG = 'Y'
																													   AND SEGMENT1 = ISNULL(F.PLANT_ID ,C.PLANT_ID)  -- 2024-04-08 NERP PLANT_ID 변경에 따른 CONVERSION 반영
																													) AS DATETIME), 120) --[END_TIME]
							*/
							-- [E20260313-002098] 당일이후 W/O 인 경우일자가 바뀌는 오류 수정. START
							, CASE WHEN B.PLAN_START_TIME >= SUBSTRING( CONVERT(VARCHAR,GETDATE(), 120), 1,10 ) + @BASE_HOUR THEN CONVERT(NVARCHAR(50), B.PLAN_DATE, 120)
							       ELSE CONVERT(NVARCHAR(50), CAST( SUBSTRING( CONVERT( VARCHAR, GETDATE(), 120 ) , 1, 10 ) + (SELECT CONCAT(' ', SUBSTRING(SEGMENT2, 1, 2), ':',SUBSTRING(SEGMENT2, 3, 2), ':',SUBSTRING(SEGMENT2, 5, 2))
																													  FROM [DBO].[SCM_SYS_LOOKUP_VALUE] W  WITH(NOLOCK)
																													 WHERE W.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
																													   AND W.ACTIVE_FLAG = 'Y'
																													   AND SEGMENT1 = ISNULL(F.PLANT_ID ,C.PLANT_ID)  -- 2024-04-08 NERP PLANT_ID 변경에 따른 CONVERSION 반영
																													) AS DATETIME), 120) -- [PLAN_DATE]
							  END
							, CASE WHEN B.PLAN_START_TIME >= SUBSTRING( CONVERT(VARCHAR,GETDATE(), 120), 1,10 ) + @BASE_HOUR THEN CONVERT(NVARCHAR(50), B.START_TIME, 120)							
								   ELSE CONVERT(NVARCHAR(50), CAST( SUBSTRING( CONVERT( VARCHAR, GETDATE(), 120 ) , 1, 10 ) + (SELECT CONCAT(' ', SUBSTRING(SEGMENT2, 1, 2), ':',SUBSTRING(SEGMENT2, 3, 2), ':',SUBSTRING(SEGMENT2, 5, 2))
																													  FROM [DBO].[SCM_SYS_LOOKUP_VALUE] W  WITH(NOLOCK)
																													 WHERE W.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
																													   AND W.ACTIVE_FLAG = 'Y'
																													   AND SEGMENT1 = ISNULL(F.PLANT_ID ,C.PLANT_ID)  -- 2024-04-08 NERP PLANT_ID 변경에 따른 CONVERSION 반영
																													) AS DATETIME), 120) -- [START_TIME]
							  END
							, CASE WHEN B.PLAN_START_TIME >= SUBSTRING( CONVERT(VARCHAR,GETDATE(), 120), 1,10 ) + @BASE_HOUR THEN CONVERT(NVARCHAR(50), B.END_TIME, 120)							  
								   ELSE CONVERT(NVARCHAR(50), CAST( SUBSTRING( CONVERT( VARCHAR, GETDATE(), 120 ) , 1, 10 ) + (SELECT CONCAT(' ', SUBSTRING(SEGMENT2, 1, 2), ':',SUBSTRING(SEGMENT2, 3, 2)+10, ':',SUBSTRING(SEGMENT2, 5, 2))
																													  FROM [DBO].[SCM_SYS_LOOKUP_VALUE] W  WITH(NOLOCK)
																													 WHERE W.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
																													   AND W.ACTIVE_FLAG = 'Y'
																													   AND SEGMENT1 = ISNULL(F.PLANT_ID ,C.PLANT_ID)  -- 2024-04-08 NERP PLANT_ID 변경에 따른 CONVERSION 반영
																													) AS DATETIME), 120) --[END_TIME]
							  END
							-- [E20260313-002098] 당일이후 W/O 인 경우일자가 바뀌는 오류 수정. END
							,CASE WHEN B.CHANGE_FLAG = 'Y' THEN B.PLAN_IN_QTY ELSE ISNULL(SOURCES.[IN_QTY],C.PLAN_IN_QTY) 	END 	-- [E20251019-001993]	변경 할 수량 반영 Modify
							,CASE WHEN B.CHANGE_FLAG = 'Y' THEN B.PLAN_IN_QTY ELSE ISNULL(SOURCES.[OUT_QTY],C.PLAN_QTY)		END 	-- [E20251019-001993]	변경 할 수량 반영 Modify
							,ISNULL(SOURCES.[IS_RELEASE], CASE WHEN C.FIX_TYPE = 'F' THEN 'Y'	WHEN C.FIX_TYPE = 'N' THEN 'Y' WHEN C.FIX_TYPE = 'P' THEN '-' ELSE FIX_TYPE END)
							,ISNULL(SOURCES.[CREATE_PSN_ID],@v_proc_name)
							,ISNULL(SOURCES.[CREATE_DATE],GETDATE())
							,'MONTH_CHAGE_ADJ' --[UPDATE_PSN_ID]
							,GETDATE() --[UPDATE_DATE]
							,ISNULL(SOURCES.[LANE_QTY],C.LANE_QTY)
							,ISNULL(SOURCES.[UNIT],IM.ITEM_UOM)
							,ISNULL(SOURCES.[ORDER_TYPE],C.PRODUCTION_TYPE)
							,ISNULL(SOURCES.[BATCH_ORDER_ID],C.BATCH_ORDER_ID)
							,ISNULL(SOURCES.[SLITTER_PLANT], (	SELECT F.MES_PLANT_ID 
																FROM FP_MES_FACTORY_M_V F WITH(NOLOCK) 		-- [E20251205-001628] VIEW 변경 
																WHERE F.ORG_FACTORY_ID = C.FACTORY_ID 		-- [E20251205-001628] Column 변경 
																AND F.PLANT_ID = C.SLIT_PLANT_ID))  -- 2024-04-08 NERP PLANT_ID 변경에 따른 CONVERSION 반영
							,ISNULL(SOURCES.[MARKET],C.MARKET)
							-- ,ISNULL(SOURCES.[ATTR_01],C.BATCH_SUM_QTY) 2020-07-27 kimcd total batch 수 정보 전송 제거
							,ISNULL(SOURCES.[ATTR_02],C.BATCH_QTY)
							-- ,SOURCES.[ATTR_03] 2020-07-27 kimcd total batch kg 정보 전송 제거
							,ISNULL([ATTR_04],C.MARKET)
							,CASE WHEN EQPC.SEGMENT1 IS NOT NULL AND IMC.SEGMENT1 IS NOT NULL THEN
										'B'
									END AS TOP_BACK_IND -- ATTR_05 단면 설비에 양면 제품이 계획된 경우 TOP BACK 구분
							,RTRIM ( CASE WHEN EQPC.SEGMENT1 IS NOT NULL AND IMC.SEGMENT1 IS NOT NULL THEN
											CASE WHEN ISNULL(SOURCES.WO,C.WORK_ORDER_ID) LIKE 'W%' OR ISNULL(SOURCES.WO,C.WORK_ORDER_ID) LIKE 'M%' THEN
												SUBSTRING(ISNULL(SOURCES.WO,C.WORK_ORDER_ID),1,5) + CONVERT(NVARCHAR(2), CONVERT(NUMERIC,SUBSTRING(ISNULL(SOURCES.WO,C.WORK_ORDER_ID),6,2)) + 50) + SUBSTRING(ISNULL(SOURCES.WO,C.WORK_ORDER_ID),8,10)
											WHEN SUBSTRING(ISNULL(SOURCES.WO,C.WORK_ORDER_ID),9,1) = '0' THEN
												CASE WHEN SUBSTRING(ISNULL(SOURCES.WO,C.WORK_ORDER_ID),6,1) = 'X' THEN
													SUBSTRING(ISNULL(SOURCES.WO,C.WORK_ORDER_ID),1,5) + 'Y' + SUBSTRING(ISNULL(SOURCES.WO,C.WORK_ORDER_ID),7,10)
												ELSE
													SUBSTRING(ISNULL(SOURCES.WO,C.WORK_ORDER_ID),1,4) + CONVERT(NVARCHAR(2), CONVERT(NUMERIC,SUBSTRING(ISNULL(SOURCES.WO,C.WORK_ORDER_ID),5,2)) + 50) + SUBSTRING(ISNULL(SOURCES.WO,C.WORK_ORDER_ID),7,10)
												END
											ELSE
												CASE WHEN SUBSTRING(ISNULL(SOURCES.WO,C.WORK_ORDER_ID),7,1) = 'X' THEN
													SUBSTRING(ISNULL(SOURCES.WO,C.WORK_ORDER_ID),1,6) + 'Y' + SUBSTRING(ISNULL(SOURCES.WO,C.WORK_ORDER_ID),8,10)
												ELSE
													SUBSTRING(ISNULL(SOURCES.WO,C.WORK_ORDER_ID),1,5) + CONVERT(NVARCHAR(2), CONVERT(NUMERIC,SUBSTRING(ISNULL(SOURCES.WO,C.WORK_ORDER_ID),6,2)) + 50) + SUBSTRING(ISNULL(SOURCES.WO,C.WORK_ORDER_ID),8,10)
												END
											END -- 2018-03-06 kimcd work order id 채번 rule 변경에 따른 TOP, Back 로직 WO 로직 수정
										END) AS LINK_WO      -- ATTR_06 연계된 WO명 - TOP은 BACK WO, BACK은 TOP WO
							,RTRIM ( CASE WHEN EQPC.SEGMENT1 IS NOT NULL AND IMC.SEGMENT1 IS NOT NULL THEN
											CASE WHEN ISNULL(SOURCES.WO_DETAIL,C.WORK_ORDER_SPL_ID) LIKE 'W%' OR ISNULL(SOURCES.WO_DETAIL,C.WORK_ORDER_SPL_ID) LIKE 'M%' THEN
												SUBSTRING(ISNULL(SOURCES.WO_DETAIL,C.WORK_ORDER_SPL_ID),1,5) + CONVERT(NVARCHAR(2), CONVERT(NUMERIC,SUBSTRING(ISNULL(SOURCES.WO_DETAIL,C.WORK_ORDER_SPL_ID),6,2)) + 50) + SUBSTRING(ISNULL(SOURCES.WO_DETAIL,C.WORK_ORDER_SPL_ID),8,10)
											WHEN SUBSTRING(ISNULL(SOURCES.WO_DETAIL,C.WORK_ORDER_SPL_ID),9,1) = '0' THEN
												CASE WHEN SUBSTRING(ISNULL(SOURCES.WO_DETAIL,C.WORK_ORDER_SPL_ID),6,1) = 'X' THEN
													SUBSTRING(ISNULL(SOURCES.WO_DETAIL,C.WORK_ORDER_SPL_ID),1,5) + 'Y' + SUBSTRING(ISNULL(SOURCES.WO_DETAIL,C.WORK_ORDER_SPL_ID),7,10)
												ELSE
													SUBSTRING(ISNULL(SOURCES.WO_DETAIL,C.WORK_ORDER_SPL_ID),1,4) + CONVERT(NVARCHAR(2), CONVERT(NUMERIC,SUBSTRING(ISNULL(SOURCES.WO_DETAIL,C.WORK_ORDER_SPL_ID),5,2)) + 50) + SUBSTRING(ISNULL(SOURCES.WO_DETAIL,C.WORK_ORDER_SPL_ID),7,10)
												END
											ELSE
												CASE WHEN SUBSTRING(ISNULL(SOURCES.WO_DETAIL,C.WORK_ORDER_SPL_ID),7,1) = 'X' THEN
													SUBSTRING(ISNULL(SOURCES.WO_DETAIL,C.WORK_ORDER_SPL_ID),1,6) + 'Y' + SUBSTRING(ISNULL(SOURCES.WO_DETAIL,C.WORK_ORDER_SPL_ID),8,10)
												ELSE
													SUBSTRING(ISNULL(SOURCES.WO_DETAIL,C.WORK_ORDER_SPL_ID),1,5) + CONVERT(NVARCHAR(2), CONVERT(NUMERIC,SUBSTRING(ISNULL(SOURCES.WO_DETAIL,C.WORK_ORDER_SPL_ID),6,2)) + 50) + SUBSTRING(ISNULL(SOURCES.WO_DETAIL,C.WORK_ORDER_SPL_ID),8,10)
												END
											END -- 2018-03-06 kimcd work order id 채번 rule 변경에 따른 TOP, Back 로직 WO 로직 수정
										END) AS DETAIL_LINK_WO      -- ATTR_07 연계된 DETAIL WO명 - TOP은 BACK WO, BACK은 TOP WO
							,B.PLAN_IN_QTY AS FP_PLAN_QTY  -- ATTR_08 FP PLAN 수량
							,--ISNULL((SELECT ISNULL(SUM(MPP.ACTUAL_QTY),0) FROM [DBO].[FP_MES_PRODUCTION_PLAN_M] MPP WITH(NOLOCK)
							--		WHERE MPP.WORK_ORDER_ID     = SOURCES.WO
							--		AND MPP.WORK_ORDER_SPL_ID = SOURCES.WO_DETAIL
							--		AND MPP.ITEM_ID           = SOURCES.ITEM_ID),0) AS FP_SNAP_QTY  -- ATTR_09 FP 실적 수량
							C.ACTUAL_QTY
							,ISNULL(SOURCES.[ATTR_10],C.LINE_ID)
							,ISNULL(SOURCES.[ATTR_11],C.[ATTRIBUTE3])										-- PILOT 구분 PIYONG ADD 2017-08-30
							,ISNULL(SOURCES.[ATTR_12],C.[ATTRIBUTE4]) -- TOP_ITEM_ID PIYONG ADD 2017-11-23
							,C.[ATTRIBUTE6] -- 2018-05-26 kimcd 테스트 수요용 work order 중 첫 공정 work order 구분자
							,C.[ATTRIBUTE7] -- 2018-07-05 kimcd VD 공정이 테스트 수요용 work order 중 첫 공정 work order 구분자
						-- 2018-05-26 kimcd 조회 컬럼 전체에 NVL 처리함. IF 테이블에 존재하면 사용, 없는 경우 WO Master 기준으로 가공 끝
							,CASE WHEN ISNULL(SOURCES.[ATTR_17],C.[WORK_REQUEST_MODEL_ID]) = '-' THEN NULL ELSE ISNULL(SOURCES.[ATTR_17],C.[WORK_REQUEST_MODEL_ID]) END -- 2022-11-24 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
							,CASE WHEN ISNULL(SOURCES.[ATTR_18],C.[VERSION]) = '-' THEN NULL -- [E20250918-001592] PDS 적용 인스턴스에서 PLM 버전을 자르고 사용할 경우 예외 처리 PLM_VERSION_FLAG 으로 구분
								  -- 2026-08-04 kimcd [PJ2026-50201] FP 라인별 환산자 산출 및 생산계획 반영 [FP_PDS_VERSION_M] outer join 추가. PDS VERSION table 우선 사용.
								  ELSE CASE WHEN F.ELEC_VERSION_TYPE = 'FP' THEN ISNULL(SOURCES.[ATTR_18],C.[VERSION])
								       ELSE CASE WHEN ISNULL(X.PLM_VERSION_FLAG,'N') = 'N' 
									   AND  ISNULL ( (  SELECT TOP 1 'Y'
														FROM [DBO].[SCM_SYS_LOOKUP_VALUE]  SLVC WITH(NOLOCK)	
																INNER JOIN FP_INSTANCE_INFO_V FIIC 
																ON 1=1
																AND SLVC.SEGMENT1 = FIIC.INSTANCE_ID
																INNER JOIN FP_INSTANCE_FACTORY_M FIVC 
																ON 1=1
																AND SLVC.SEGMENT1 = FIVC.INSTANCE_ID
														WHERE 1=1
														AND SLVC.LOOKUP_TYPE_CODE = 'PDS_INSTANCE'
														AND SLVC.ACTIVE_FLAG = 'Y'
														AND FIVC.FACTORY_ID = ISNULL(SOURCES.[BUILNO], ISNULL(F.FACTORY_ID,C.FACTORY_ID)) ), 'N') = 'Y' 
									   THEN ISNULL(ISNULL(SOURCES.[ATTR_18],PVM.[PDS_VERSION]),C.[VERSION]) ELSE ISNULL(SOURCES.[ATTR_18],SUBSTRING(C.[VERSION],1,3)) END
									   END
							 END -- 2022-11-24 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
							,ISNULL(SOURCES.[ATTR_19],C.[PROD_SEQ])              -- 2022-11-24 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
							,ISNULL(SOURCES.[ATTR_20],C.[PLM_EC_NO])             -- 2022-11-24 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
						FROM @TEMP_TABLE B
						LEFT OUTER JOIN [DBO].[SY_XIF_MES_WO_S] SOURCES WITH(NOLOCK) 
							 ON SOURCES.WO      = B.WORK_ORDER_ID
							AND SOURCES.PLAN_ID = B.RELEASE_PLAN_ID
							AND SOURCES.IF_ID  <> 'OFP0_OPLM_FP_WO'
						LEFT OUTER JOIN [DBO].[FP_MES_PRODUCTION_PLAN_M] C WITH(NOLOCK)  -- 2018-05-26 kimcd I/F table에 없는 경우 WO Master 정보 사용
							 ON C.WORK_ORDER_ID     = B.WORK_ORDER_ID
							AND C.WORK_ORDER_SPL_ID = B.WORK_ORDER_ID
						--LEFT OUTER JOIN SCM_FACTORY_M F  WITH(NOLOCK)
						LEFT OUTER JOIN FP_MES_FACTORY_M_V F  WITH(NOLOCK)	-- [E20251205-001628] VIEW 변경 
						     ON F.ORG_FACTORY_ID = B.FACTORY_ID -- [E20251205-001628] Column 변경 -- 2023-03-03 kimcd NJ의 경우 FP 전극 생산 버전 그대로 전송
						LEFT OUTER JOIN (	-- [E20250918-001592] ADD PLM 버전을 체크위함
											SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.MODEL_ID, A.ITEM_ID, A.PROD_VERSION, X.PLM_VERSION_FLAG
											FROM FP_PROD_VERSION_M A WITH(NOLOCK)
												 INNER JOIN (
																SELECT DISTINCT A.SEGMENT1 AS INSTANCE_ID, ISNULL(A.ATTRIBUTE2, 'N') AS PLM_VERSION_FLAG
																		, B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID, C.FACTORY_ID
																FROM [DBO].[SCM_SYS_LOOKUP_VALUE]  A WITH(NOLOCK)	
																	 INNER JOIN FP_INSTANCE_INFO_V B 
																	 ON 1=1
																	 AND A.SEGMENT1 = B.INSTANCE_ID
																	 INNER JOIN FP_INSTANCE_FACTORY_M C  WITH(NOLOCK)
																	 ON 1=1
																	 AND A.SEGMENT1 = C.INSTANCE_ID
																WHERE 1=1
																AND A.LOOKUP_TYPE_CODE = 'PDS_INSTANCE'
																AND A.ACTIVE_FLAG = 'Y'
																AND A.ATTRIBUTE2 = 'Y'		--PLM_VERSION_FLAG
																--AND A.SEGMENT1 IN ( SELECT DISTINCT INSTANCE_ID FROM SCM_FP_PLAN_H WHERE PLAN_ID =  '0' )
													) X
													ON 1=1
													AND A.COMPANY_ID	= X.COMPANY_ID
													AND A.DIVISION_ID	= X.DIVISION_ID
													AND A.SITE_ID		= X.SITE_ID
													AND A.PLANT_ID		= X.PLANT_ID
													AND A.FACTORY_ID	= X.FACTORY_ID
											WHERE 1=1
											AND A.INSERT_ID LIKE '%PLM_WO%'	-- PLM/PDS 버전 구분이 여의치 않아 insert id 로 처리 (추후 변경 필요)
										) X
						ON	1=1
						AND B.COMPANY_ID	= X.COMPANY_ID
						AND B.DIVISION_ID	= X.DIVISION_ID
						AND B.SITE_ID		= X.SITE_ID
						AND B.FACTORY_ID	= X.FACTORY_ID
						AND B.ITEM_ID		= X.ITEM_ID
						AND C.[WORK_REQUEST_MODEL_ID]	= X.MODEL_ID
						AND C.[VERSION]		= X.PROD_VERSION	-- SY_XIF_MES_WO_S 기준으로 잡으면 version 이 잘린것으로 비교되어 wo 마스터만 보도록 한다.
						--AND ISNULL(SOURCES.[ATTR_17],C.[WORK_REQUEST_MODEL_ID])	= X.MODEL_ID
						--AND ISNULL(SOURCES.[ATTR_18],C.[VERSION])				= X.PROD_VERSION     
						     
						LEFT OUTER JOIN [DBO].[SCM_LINE_M] SL WITH(NOLOCK)  -- 2022-08-12 kimcd 설비 정보 Option화에 따른 수정
							 ON  SL.COMPANY_ID   = C.COMPANY_ID
							 AND SL.DIVISION_ID  = C.DIVISION_ID
							 AND SL.SITE_ID      = C.SITE_ID
							 AND SL.PLANT_ID     = C.PLANT_ID
							 AND SL.FACTORY_ID   = C.FACTORY_ID
							 AND SL.OPERATION_ID = C.OPERATION_ID
							 AND SL.LINE_ID      = C.LINE_ID
							 AND SL.ELECTRODE_TYPE = C.ELECTRODE_TYPE
						LEFT OUTER JOIN [DBO].[SCM_EQUIPMENT_M]  EQP WITH(NOLOCK)
							ON EQP.EQUIPMENT_ID = B.EQUIPMENT_ID
						AND EQP.OPERATION_ID = B.OPERATION_ID
						AND EQP.FACTORY_ID   = B.FACTORY_ID
						AND EQP.EQUIPMENT_TYPE = 'M'
						AND EQP.ACTIVE_FLAG    = 'Y'
						LEFT OUTER JOIN [DBO].[SCM_SYS_LOOKUP_VALUE]  EQPC WITH(NOLOCK)
							ON EQPC.LOOKUP_TYPE_CODE = 'FP_COATER_TOP_COPY_OP'
						AND EQPC.SEGMENT1         = EQP.OPERATION_ID
						AND EQPC.SEGMENT2         = EQP.COATER_EQPT_TYPE_CODE
						AND EQPC.ACTIVE_FLAG      = 'Y'
						LEFT OUTER JOIN [DBO].[SCM_ITEM_M]  IM WITH(NOLOCK)
							ON IM.COMPANY_ID = B.COMPANY_ID
						AND IM.DIVISION_ID  = B.DIVISION_ID
						AND IM.SITE_ID      = B.SITE_ID
						AND IM.ITEM_ID      = B.ITEM_ID
						LEFT OUTER JOIN [DBO].[SCM_SYS_LOOKUP_VALUE]  IMC WITH(NOLOCK)
							ON IMC.LOOKUP_TYPE_CODE = 'FP_COATER_TOP_COPY_ITEM_CLASS'
						AND IMC.SEGMENT1         = IM.ITEM_CLASS
						AND IMC.ACTIVE_FLAG      = 'Y'
						-- 2026-08-04 kimcd [PJ2026-50201] FP 라인별 환산자 산출 및 생산계획 반영 [FP_PDS_VERSION_M] outer join 추가
                        LEFT OUTER JOIN [dbo].[FP_PDS_VERSION_M]  PVM WITH(NOLOCK)
							ON 	PVM.[FACTORY_ID] = C.[FACTORY_ID]
							AND PVM.[MODEL_ID]   = C.[WORK_REQUEST_MODEL_ID]
							AND PVM.[VERSION]    = C.[VERSION]
						WHERE ISNULL(SOURCES.[WO],C.WORK_ORDER_ID) IS NOT NULL  -- 2018-05-26 kimcd WORK ORDER 존재하는 경우만 전송
					;


 					INSERT INTO [DBO].[SY_XIF_MES_WO_S]                                                                                                                                                                                                           
								( [IF_SEQ]                                                                                                                                                                                                                                  
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
								,[DEMAND_ID]                                                                                                                                                                                                                                 
								,[WO]                                                                                                                                                                                                                                        
								,[WO_TYPE]                                                                                                                                                                                                                                   
								,[WO_DETAIL]                                                                                                                                                                                                                                 
								,[PLAN_DATE]                                    
								,[START_TIME]                                                                                                                                                                                                                                
								,[END_TIME]                                                                                                                                                                                                                                  
								,[IN_QTY]                                                                                                                                                                                                                                    
								,[OUT_QTY]                                                                                                                                                                                                                                   
								,[IS_RELEASE]                                                                                                                                                                                                                                
								,[CREATE_PSN_ID]                                                                                                                                                                                                                             
								,[CREATE_DATE]                                                                                                                                                                                                                               
								,[UPDATE_PSN_ID]                                                                                                                                                                                                                             
								,[UPDATE_DATE]                                                                                                                                                                                                                               
								,[LANE_QTY]                                                                                                                                                                                                                                  
								,[UNIT]                                                                                                                                                                                              
								,[ORDER_TYPE]    
								,[BATCH_ORDER_ID]
								,[SLITTER_PLANT]
								,[ATTR_01]
								,[ATTR_02]
								,[ATTR_03]
								,[ATTR_04]
								,[ATTR_05] -- 단면 설비에 양면 제품이 계획된 경우 TOP BACK 구분
								,[ATTR_06] -- 연계된 WO명 - TOP은 BACK WO, BACK은 TOP WO
								,[ATTR_07] -- 연계된 DETAIL WO명 - TOP은 BACK WO, BACK은 TOP WO
								,[ATTR_08] -- FP PLAN 수량
								,[ATTR_09] -- FP 실적 수량
								,[ATTR_10]
								,[ATTR_11] -- PILOT 구분 PIYONG ADD 2017-08-30
								,[ATTR_12] -- TOP_ITEM_ID PIYONG ADD 2017-11-23
								,[ATTR_13] -- 2018-05-26 kimcd 테스트 수요용 work order 중 첫 공정 work order 구분자
								,[ATTR_14] -- 2018-07-05 kimcd VD 공정이 테스트 수요용 work order 중 첫 공정 work order 구분자
								,[ATTR_17] -- 2022-11-24 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
								,[ATTR_18] -- 2022-11-24 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
								,[ATTR_19] -- 2022-11-24 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
								,[ATTR_20] -- 2022-11-24 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
							)
							SELECT 'OFP0' + SUBSTRING(CONVERT(NVARCHAR(12), GETDATE(), 112), 3,6) + REPLICATE('0', 10 - LEN(NEXT VALUE FOR [DBO].[XIF_MES_SEND_SEQ])) + CAST( NEXT VALUE FOR [DBO].[XIF_MES_SEND_SEQ] AS NVARCHAR)   -- IF_SEQ
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
								,[DEMAND_ID]
								,[ATTR_06] -- [WO]
								,[WO_TYPE]
								,[ATTR_07] -- [WO_DETAIL]
								,[PLAN_DATE]
								,[START_TIME]
								,[END_TIME]
								,[IN_QTY]
								,[OUT_QTY]
								,[IS_RELEASE]
								,[CREATE_PSN_ID]
								,[CREATE_DATE]
								,[UPDATE_PSN_ID]
								,[UPDATE_DATE]
								,[LANE_QTY]
								,[UNIT]
								,[ORDER_TYPE]
								,[BATCH_ORDER_ID]
								,[SLITTER_PLANT]					                                                                                                                                                                                                                            
								,[ATTR_01]
								,[ATTR_02]
								,[ATTR_03]
								,[ATTR_04]
								,'T'          -- [ATTR_05] -- 단면 설비에 양면 제품이 계획된 경우 TOP BACK 구분
								,[WO]         -- [ATTR_06] -- 연계된 WO명 - TOP은 BACK WO, BACK은 TOP WO
								,[WO_DETAIL]  -- [ATTR_07] -- 연계된 DETAIL WO명 - TOP은 BACK WO, BACK은 TOP WO
								,[ATTR_08] -- FP PLAN 수량
								,[ATTR_09] -- FP 실적 수량
								,[ATTR_10]
								,[ATTR_11] -- PILOT 구분 PIYONG ADD 2017-08-30
								,[ATTR_12] -- TOP_ITEM_ID PIYONG ADD 2017-11-23
								,[ATTR_13] -- 2018-05-26 kimcd 테스트 수요용 work order 중 첫 공정 work order 구분자
								,[ATTR_14] -- 2018-07-05 kimcd VD 공정이 테스트 수요용 work order 중 첫 공정 work order 구분자
								,[ATTR_17] -- 2022-11-24 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
								,[ATTR_18] -- 2022-11-24 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
								,[ATTR_19] -- 2022-11-24 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
								,[ATTR_20] -- 2022-11-24 kimcd  전극 FP고도화 I/F 작업 - 전극 생산 버전별 계획 수립, PLM EC 추가 관리
							FROM [DBO].[SY_XIF_MES_WO_S] WITH(NOLOCK)
							WHERE PLAN_ID IN (SELECT  CONCAT(B.RELEASE_PLAN_ID,'_00X',@SEQ)
												FROM @TEMP_TABLE B )
							AND ATTR_05 = 'B'

					MERGE INTO [DBO].[SCM_SYS_LOOKUP_VALUE] A
					USING ( 
						SELECT @SITE_ID              AS SITE_ID
							  ,@FACTORY_ID           AS FACTORY_ID
							  -- ,CONVERT( NVARCHAR(8), GETDATE(), 112) AS EXEC_DATE
							  ,CONVERT( NVARCHAR(8), DBO.[FN_SITE_TIME](@SITE_ID), 112) AS EXEC_DATE -- 2026-05-12  kimcd    [PJ20266179] AZ 법인 증설 SCM 대응. EXEC_DATE 기준을 법인 시간으로 변경
							  ) B
					ON  (     A.LOOKUP_TYPE_CODE = 'WO_ROLL_EXEC_FLAG'
						  AND A.SEGMENT1         = B.SITE_ID
						  AND A.SEGMENT2         = B.FACTORY_ID)
					WHEN MATCHED THEN
					UPDATE SET A.[ATTRIBUTE1]     = B.[EXEC_DATE]
							  ,A.[MODIFY_USER_ID] = 'PR_XIF_SCM_WO_ROLLING_PST'        
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
					VALUES('WO_ROLL_EXEC_FLAG'
						  ,B.SITE_ID
						  ,B.FACTORY_ID
						  ,'-'
						  ,'-'
						  ,'-'
						  ,'Y'
						  ,'PR_XIF_SCM_WO_ROLLING_PST'
						  ,GETDATE()
						  ,'PR_XIF_SCM_WO_ROLLING_PST'
						  ,GETDATE()
						  ,B.[EXEC_DATE]);

				FETCH NEXT FROM CUR_SITE INTO  @SITE_ID
											  ,@FACTORY_ID 

				END;
			
			CLOSE CUR_SITE;
			DEALLOCATE CUR_SITE;

			--2017-08-04 KIMCD ADD START
			DECLARE CUR_AUTO_RUN  CURSOR FOR
				SELECT SFM.SITE_ID
					   ,BASIS_TIME								--2019-09-10 PIYONG ADD
					   ,MAX(FACTORY_COUNT)    AS FACTORY_COUNT
					   ,COUNT(PR.FACTORY_ID)  AS PR_COUNT
					   ,COUNT(SS.FACTORY_ID)  AS SS_COUNT
					   ,COUNT(OW.FACTORY_ID)  AS OW_COUNT
					   ,COUNT(MWO.FACTORY_ID) AS MWO_COUNT
				  FROM ( SELECT SFM.FACTORY_ID
				               ,SFM.SITE_ID
							   ,SFM.BASIS_TIME
							   ,COUNT(*) OVER (PARTITION BY SFM.SITE_ID, SFM.BASIS_TIME)  AS FACTORY_COUNT  -- site id, 시업 시간 기준으로 검증하기 위해 시업 시간 추가
				         FROM  ( SELECT FIF.FACTORY_ID
							           ,SFM.SITE_ID
							            ----------------------------------------------------------------
									    -- 2019-09-10 PIYONG ADD
									   ,ISNULL( (
												 SELECT TOP 1 SEGMENT2
												   FROM [DBO].[SCM_SYS_LOOKUP_VALUE] V  WITH(NOLOCK)
												  WHERE V.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
													AND V.ACTIVE_FLAG = 'Y'
													AND V.SEGMENT1 = SFM.PLANT_ID
											  ),  '060000'																										) AS BASIS_TIME
										-- 2019-09-10 PIYONG ADD END
										----------------------------------------------------------------
						         FROM DBO.FP_INSTANCE_FACTORY_M FIF WITH(NOLOCK)
							         ,DBO.SCM_FACTORY_M         SFM WITH(NOLOCK)
								 WHERE FIF.FACTORY_ID = SFM.FACTORY_ID
								 AND FIF.ACTIVE_FLAG = 'Y'
								 AND EXISTS (
											   /* 2018-06-06 kimcd 계획 전송 여부 점검하는 로직 수정
											   SELECT 1
												 FROM DBO.SCM_FP_PLAN_DETAIL_H  FPD WITH(NOLOCK)
												WHERE FPD.INSTANCE_ID  = FIF.INSTANCE_ID
												  AND FPD.FACTORY_ID   = FIF.FACTORY_ID
												  AND FPD.RELEASE_FLAG = 'Y'
											--2017-11-10 PIYONG PLAN_GROUP_ID 기준 데이터 조회 ADD 시작
											-----------------------------------------------------------------------------------------------------------------------------------------------------------
												 UNION ALL
											   SELECT 1
												 FROM SCM_FP_PLAN_GROUP_DETAIL_H D WITH(NOLOCK)
												WHERE D.RELEASE_FLAG = 'Y'
												  AND D.INSTANCE_ID  = FIF.INSTANCE_ID
											-----------------------------------------------------------------------------------------------------------------------------------------------------------
											--2017-11-10 PIYONG PLAN_GROUP_ID 기준 데이터 조회 ADD 끝
											*/ SELECT 1
											   FROM   SY_XIF_MES_WO_S MW WITH(NOLOCK)
											   WHERE  MW.BUILNO = SFM.FACTORY_ID  -- 2018-06-06 kimcd 계획 전송 여부 점검 로직 수정
											   AND    MW.BUILNO NOT IN (SELECT SV.SEGMENT1 
																		FROM   [SCM_SYS_LOOKUP_VALUE]  SV WITH(NOLOCK)
																		WHERE  SV.LOOKUP_TYPE_CODE = 'ABNORMAL_FACTORY'
																		AND    SV.ACTIVE_FLAG = 'Y' ) -- 2018-12-18 kimcd setup 진행 중인 공장 KPI 대상 제외
											   UNION ALL  -- 2023-10-27 kimcd WA 분리에 따른 자동 계획 FLAG 설정 부분 보완
                                SELECT 1
											   FROM   [SCM_SYS_LOOKUP_VALUE]  SV WITH(NOLOCK)
											   WHERE  SV.LOOKUP_TYPE_CODE = 'ABNORMAL_FACTORY'
											   AND    SV.SEGMENT1         = SFM.FACTORY_ID
											   AND    SV.ACTIVE_FLAG      = 'Y'
											   AND    SV.ATTRIBUTE2       = 'Y'
                                               --  2023-03-17 kimcd HM 추가에 따른 최초 작업 호출 부분 수정
											  )
								) SFM  -- 2019-10-01 kimcd site id, 시업 시간 기준으로 검증하기 위해 시업 시간 추가
					  ) SFM
					  LEFT OUTER JOIN ( SELECT DISTINCT Z.SITE_ID, Z.FACTORY_ID
										FROM   SCM_FACTORY_M Z WITH(NOLOCK)
										WHERE MES_SOURCE_GROUP IN ( SELECT DISTINCT SUBSTRING(IF_ID,1,4) -- 2018-03-05 KIMCD 튜닝 DISTINCT로 수정
																	 FROM [SY_XIF_MES_DAILY_WIP_HISTORY_R] -- NOLOCK 걸지 않음
						 											WHERE 1=1
																	  AND PROC_FLAG = 'Y'
																	  -- AND ACCUM_DATE = CONVERT( NVARCHAR(8), GETDATE(), 112)
																	  AND ACCUM_DATE = CONVERT( NVARCHAR(8), DBO.[FN_SITE_TIME](Z.SITE_ID), 112) -- 2026-05-12  kimcd    [PJ20266179] AZ 법인 증설 SCM 대응. ACCUM_DATE 기준을 법인 시간으로 변경
																		-- GROUP BY IF_ID, ACCUM_DATE -- 2018-03-05 KIMCD 튜닝 GROUP BY 문장 막음
																	) 
										AND   FACTORY_ID != 'PB'
										UNION ALL  -- 2022-01-25 kimcd  Hazel Pack 실적, Open WO 수신이 Factory의 MES SOURCE GROUP으로 관리되지 않아 별도 예외 로직 추가
										SELECT Z.SITE_ID, Z.FACTORY_ID
										FROM   SCM_FACTORY_M Z WITH(NOLOCK)
										WHERE MES_SOURCE_GROUP IN ( SELECT DISTINCT 'UMS3'
																	 FROM [SY_XIF_MES_DAILY_WIP_HISTORY_R] -- NOLOCK 걸지 않음
						 											WHERE 1=1
																	  AND PROC_FLAG = 'Y'
																	  AND IF_ID     = 'UHZT_OFP0_DAILY_WIPHISTORY'
																	  --AND ACCUM_DATE = CONVERT( NVARCHAR(8), GETDATE(), 112)
																	  AND ACCUM_DATE = CONVERT( NVARCHAR(8), DBO.[FN_SITE_TIME](Z.SITE_ID), 112) -- 2026-05-12  kimcd    [PJ20266179] AZ 법인 증설 SCM 대응. ACCUM_DATE 기준을 법인 시간으로 변경
																	) 
										-- 하드코딩 PB, G380
										AND   FACTORY_ID in (SELECT SEGMENT2 FROM SCM_CODE_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE='PR_XIF_SCM_WO_ROLLING_PST' AND SEGMENT1  = 'HAZEL_EXCEPT_FACTORY' AND ACTIVE_FLAG='Y') 
										AND   COMPANY_ID in (SELECT SEGMENT2 FROM SCM_CODE_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE='PR_XIF_SCM_WO_ROLLING_PST' AND SEGMENT1  = 'HAZEL_EXCEPT_COMPANY' AND ACTIVE_FLAG='Y')
									  ) PR
								  ON  SFM.FACTORY_ID = PR.FACTORY_ID
								  AND SFM.SITE_ID    = PR.SITE_ID
					  LEFT OUTER JOIN (
					  /*
					                    SELECT DISTINCT SITE_ID, FACTORY_ID
										FROM  [dbo].[SCM_STOCK_H]
										WHERE CUTOFF_DATE = CONVERT(VARCHAR(10), GETDATE(), 120)
										AND STORAGE_ID = 'MES'
										AND UPDATE_ID  = 'PR_XIF_MES_WIP_R'
										UNION  --일시적 예외처리
										SELECT SEGMENT3 AS FACTORY_ID, SEGMENT2 AS SITE_ID
										FROM [DBO].[SCM_SYS_LOOKUP_VALUE] V  WITH(NOLOCK)
										WHERE V.LOOKUP_TYPE_CODE = 'PR_XIF_SCM_WO_ROLLING_PST'
										AND SEGMENT1 = 'SCM_STOCK_H'
										AND ACTIVE_FLAG = 'Y'
                       */
						                SELECT DISTINCT Z.SITE_ID, Z.FACTORY_ID 
							              FROM SCM_FACTORY_M Z WITH(NOLOCK)
							             WHERE MES_SOURCE_GROUP IN ( SELECT DISTINCT SUBSTRING(IF_ID,1,4) -- 2018-03-05 KIMCD 튜닝 DISTINCT로 수정
							                                           FROM [sy_XIF_MES_WIP_HOLD_SUM_R] WITH(NOLOCK)-- NOLOCK 걸지 않음
							                                          WHERE 1 = 1
							                                            AND PROC_FLAG = 'Y'
							                                            --AND SUM_DATE = CONVERT( NVARCHAR(8), GETDATE(), 112)
																		AND SUM_DATE = CONVERT( NVARCHAR(8), DBO.[FN_SITE_TIME](Z.SITE_ID), 112) -- 2026-05-12  kimcd    [PJ20266179] AZ 법인 증설 SCM 대응. ACCUM_DATE 기준을 법인 시간으로 변경
							                                       ) 
							               AND ACTIVE_FLAG = 'Y'

								     ) SS
								  ON  SFM.FACTORY_ID = SS.FACTORY_ID
								  AND SFM.SITE_ID    = SS.SITE_ID
					  LEFT OUTER JOIN ( SELECT SLV.SEGMENT1          AS SITE_ID,
											   SLV.SEGMENT2          AS FACTORY_ID
										FROM   [DBO].[SCM_SYS_LOOKUP_VALUE] SLV
										WHERE  SLV.LOOKUP_TYPE_CODE = 'WO_ROLL_EXEC_FLAG'
										-- AND    SLV.ATTRIBUTE1       IN ( CONVERT( NVARCHAR(8), GETDATE(), 112), '29991231')  -- 2019-10-01 kimcd 29991231 일자로 자동 롤링 예외 FACTORY 관리 
										AND    SLV.ATTRIBUTE1       IN ( CONVERT( NVARCHAR(8), DBO.[FN_SITE_TIME](SLV.SEGMENT1), 112), '29991231') -- 2026-05-12  kimcd    [PJ20266179] AZ 법인 증설 SCM 대응. ACCUM_DATE 기준을 법인 시간으로 변경
									   ) OW
								  ON  SFM.FACTORY_ID = OW.FACTORY_ID
								  AND SFM.SITE_ID    = OW.SITE_ID
					  LEFT OUTER JOIN ( /*-- 2018-03-05 kimcd block 조회문
											SELECT DISTINCT MWO.SITE_ID, MWO.FACTORY_ID
											FROM   [DBO].[FP_MES_WORK_ORDER_STATUS_H] MWO
											WHERE  [CUTOFF_DATE] = CAST(GETDATE() AS DATE)*/
											-- 2018-03-05 kimcd 기준 Table 변경함
											SELECT DISTINCT Z.SITE_ID, Z.FACTORY_ID
											FROM   SCM_FACTORY_M Z WITH(NOLOCK)
											WHERE  MES_SOURCE_GROUP IN (SELECT DISTINCT SUBSTRING(IF_ID,1,4)
																		FROM   [SY_XIF_MES_OPEN_WO_R] -- NOLOCK 걸지 않음
																		WHERE  1=1
																		AND    PROC_FLAG = 'Y'
																		-- AND    ACCUM_DATE = CONVERT( NVARCHAR(8), GETDATE(), 112)
																		AND ACCUM_DATE = CONVERT( NVARCHAR(8), DBO.[FN_SITE_TIME](Z.SITE_ID), 112) -- 2026-05-12  kimcd    [PJ20266179] AZ 법인 증설 SCM 대응. ACCUM_DATE 기준을 법인 시간으로 변경
																		)
											AND   FACTORY_ID != 'PB'
											UNION ALL  -- 2022-01-25 kimcd  Hazel Pack 실적, Open WO 수신이 Factory의 MES SOURCE GROUP으로 관리되지 않아 별도 예외 로직 추가
											SELECT Z.SITE_ID, Z.FACTORY_ID
											FROM   SCM_FACTORY_M Z WITH(NOLOCK)
											WHERE MES_SOURCE_GROUP IN ( SELECT DISTINCT 'UMS3'
																		 FROM [SY_XIF_MES_OPEN_WO_R] -- NOLOCK 걸지 않음
						 												WHERE 1=1
																		  AND PROC_FLAG = 'Y'
																		  AND IF_ID     = 'UHZT_OFP0_DAILY_OPEN_WO'
																		  -- AND ACCUM_DATE = CONVERT( NVARCHAR(8), GETDATE(), 112)
																		  AND ACCUM_DATE = CONVERT( NVARCHAR(8), DBO.[FN_SITE_TIME](Z.SITE_ID), 112) -- 2026-05-12  kimcd    [PJ20266179] AZ 법인 증설 SCM 대응. ACCUM_DATE 기준을 법인 시간으로 변경
																		) 
										-- 하드코딩
										AND   FACTORY_ID in (SELECT SEGMENT2 FROM SCM_CODE_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE='PR_XIF_SCM_WO_ROLLING_PST' AND SEGMENT1  = 'HAZEL_EXCEPT_FACTORY' AND ACTIVE_FLAG='Y')
										AND   COMPANY_ID in (SELECT SEGMENT2 FROM SCM_CODE_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE='PR_XIF_SCM_WO_ROLLING_PST' AND SEGMENT1  = 'HAZEL_EXCEPT_COMPANY' AND ACTIVE_FLAG='Y')
									   ) MWO
									ON  SFM.FACTORY_ID = MWO.FACTORY_ID
									AND SFM.SITE_ID    = MWO.SITE_ID
				WHERE NOT EXISTS ( SELECT 1
								   FROM   [DBO].[SCM_SYS_LOOKUP_VALUE]  SV WITH(NOLOCK)
								   WHERE  SV.LOOKUP_TYPE_CODE = 'AUTO_PLAN_CALL_FLAG'
								   AND    SV.SEGMENT1 = SFM.SITE_ID
								   AND    SV.SEGMENT2 = SFM.BASIS_TIME								-- 2019-09-10 PIYONG ADD
								   -- AND    SV.ATTRIBUTE1 = CONVERT( NVARCHAR(8), GETDATE(), 112) )
								   AND    SV.ATTRIBUTE1 = CONVERT( NVARCHAR(8), DBO.[FN_SITE_TIME](SV.SEGMENT1), 112) )
								   -- 2026-05-12  kimcd    [PJ20266179] AZ 법인 증설 SCM 대응. ACCUM_DATE 기준을 법인 시간으로 변경
			GROUP BY SFM.SITE_ID, BASIS_TIME
			HAVING 	 MAX(FACTORY_COUNT) = COUNT(PR.FACTORY_ID)
			AND	     MAX(FACTORY_COUNT) = COUNT(SS.FACTORY_ID)
			AND	     MAX(FACTORY_COUNT) = COUNT(OW.FACTORY_ID)
			AND	     MAX(FACTORY_COUNT) = COUNT(MWO.FACTORY_ID);

			OPEN CUR_AUTO_RUN;
			FETCH NEXT FROM CUR_AUTO_RUN INTO   @SITE_ID,
												@BASIS_TIME,						--2019-09-10 PIYONG ADD
												@CHECK_FACTORY,
												@CHECK_WIP_HIS,
												@CHECK_WIP,
												@CHECK_PST,
												@CHECK_MWO

			WHILE (@@FETCH_STATUS = 0)
				BEGIN
					UPDATE [DBO].[JOB_SCHEDULE_MASTER]
					   SET IMMEDIATE_FLAG = 'Y'
					 WHERE CONVERT( NVARCHAR(8),LATEST_RUN_DATE, 112) < CONVERT( NVARCHAR(8), GETDATE(), 112)
					  AND  GROUP_ID = CASE WHEN @SITE_ID = 'A001' THEN
												'FIRST_ENGINE_RUN_KR'
										   WHEN @SITE_ID = 'A002' AND @BASIS_TIME = '080000' THEN
												'FIRST_ENGINE_RUN_CN'
										   WHEN @SITE_ID = 'A002' AND @BASIS_TIME = '083000' THEN
												'FIRST_ENGINE_RUN_CNB'
										   WHEN @SITE_ID = 'A003' AND @BASIS_TIME = '060000' THEN  -- 2026-03-28 E20260325-001091 시업시간 변경 추가 조치건 입니다. BASIS_TIME 변경건
												'FIRST_ENGINE_RUN_US'
										   WHEN @SITE_ID = 'A003' AND @BASIS_TIME = '053000' THEN  -- 2022-07-01 kimcd Ultium Cells 시업 시간 05시 30분 경우 반영
												'FIRST_ENGINE_RUN_UC'
										   WHEN @SITE_ID = 'A003' AND @BASIS_TIME = '063000' THEN  -- 2022-07-01 kimcd Ultium Cells2 시업 시간 06시 30분 경우 반영
												'FIRST_ENGINE_RUN_UC2'
										   WHEN @SITE_ID = 'A003' AND @BASIS_TIME = '090000' THEN  -- 2026-05-12 kimcd [PJ20266179] AZ 법인 증설 SCM 대응
												'FIRST_ENGINE_RUN_AZ'
										   WHEN @SITE_ID = 'A004' THEN
												'FIRST_ENGINE_RUN_PL'
										   WHEN @SITE_ID = 'A007' THEN
												'FIRST_ENGINE_RUN_ID'  -- 2023-03-17 ID HM 작업 호출 추가
										   WHEN @SITE_ID = 'A009' THEN
												'FIRST_ENGINE_RUN_ST'  
										END


					MERGE INTO [DBO].[SCM_SYS_LOOKUP_VALUE] A
					USING ( 
						SELECT @SITE_ID              AS SITE_ID
							   ,@BASIS_TIME			 AS BASIS_TIME					-- 2019-09-10 PIYONG ADD
							  --,CONVERT( NVARCHAR(8), GETDATE(), 112) AS EXEC_DATE
							  ,CONVERT( NVARCHAR(8), DBO.[FN_SITE_TIME](@SITE_ID), 112) AS EXEC_DATE -- 2026-05-12  kimcd    [PJ20266179] AZ 법인 증설 SCM 대응. EXEC_DATE 기준을 법인 시간으로 변경
							  ) B
					ON  (     A.LOOKUP_TYPE_CODE = 'AUTO_PLAN_CALL_FLAG'
						  AND A.SEGMENT1		= B.SITE_ID
						  AND A.SEGMENT2		= B.BASIS_TIME						-- 2019-09-10 PIYONG ADD
						)
					WHEN MATCHED THEN
					UPDATE SET A.[ATTRIBUTE1]     = B.[EXEC_DATE]
							  ,A.[MODIFY_USER_ID] = 'PR_XIF_SCM_WO_ROLLING_PST'        
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
							  ,[ATTRIBUTE1]
						) VALUES (
							'AUTO_PLAN_CALL_FLAG'
						  ,B.SITE_ID
						  ,B.BASIS_TIME												-- 2019-09-10 PIYONG ADD
						  ,'-'
						  ,'-'
						  ,'-'
						  ,'Y'
						  ,'PR_XIF_SCM_WO_ROLLING_PST'
						  ,GETDATE()
						  ,'PR_XIF_SCM_WO_ROLLING_PST'
						  ,GETDATE()
						  ,B.[EXEC_DATE]
						);

                    EXEC [dbo].[PR_XIF_MES_RECEIVED_ALARM_S] @SITE_ID,@BASIS_TIME   -- 2022-10-06 leeseongmin		
					
					-- 2022-12-13 leeseongmin 실적DATA 사이트 및 시업시간별로 MRP I/F 송신 
					/*UPDATE [DBO].[JOB_SCHEDULE_DETAIL]
					SET  PARAMETER1 = @SITE_ID ,  PARAMETER2 = @BASIS_TIME  -- 사이트,시업시간 수정
					WHERE GROUP_ID = '999_0001' AND JOB_ID = 'PR_XIF_MRP_DAILY_PRODUCT_RESULT_S';                    
	        
				   	-- 2022-12-13 leeseongmin 실적DATA 사이트 및 시업시간별로 MRP I/F 송신 
					UPDATE [DBO].[JOB_SCHEDULE_MASTER]
					SET IMMEDIATE_FLAG = 'Y'	   -- 실행
					WHERE  GROUP_ID = '999_0001';
					불필요한 작업으로 막음 
					*/

					FETCH NEXT FROM CUR_AUTO_RUN INTO   @SITE_ID,
														@BASIS_TIME,				-- 2019-09-10 PIYONG ADD
														@CHECK_FACTORY,
														@CHECK_WIP_HIS,
														@CHECK_WIP,
														@CHECK_PST,
														@CHECK_MWO

				END;
			
			CLOSE CUR_AUTO_RUN;
			DEALLOCATE CUR_AUTO_RUN;
		--2017-08-04 KIMCD ADD END

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




